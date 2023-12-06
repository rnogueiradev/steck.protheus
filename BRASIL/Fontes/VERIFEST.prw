#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static __lOpened := .F.

User Function VERIFEST()

Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local nTotDisp	:= 0
Local nSaldo	:= 0
Local nQtPV		:= 0
Local nQemp		:= 0
Local nSalpedi	:= 0
Local nReserva	:= 0
Local nQempSA	:= 0
Local nSaldoSB2:=0
Local nQtdTerc :=0
Local nQtdNEmTerc:=0
Local nSldTerc :=0
Local nQEmpN	:=0
Local nQAClass :=0
Local nQEmpPrj := 0
Local nQEmpPre := 0
Local nResOP	:= 0
Local nResSDC	:= 0
Local oPasta,oListBox,oDlg,oBold,oBitPro,oScr,oScr2,oObs,cObs
Local aButtons	:=	{}
Local oPanel
Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)	// Leonardo Flex -> Comentado pois tem que considerar o parâmetro da producao
Local oOk		:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo		:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local aRetB2	:={}
Local cFunName := Upper(FunName())
Local nQtdeFalta
Local cFilCon, cArmz
Local aNeg		:={}
Local _cNeg

Private aViewB2:= {}
Private aViewB8:= {}
Private aBkpB8	:= {}
Private aTotFil:= {}
Private oLstB8
Private lMostraB8 := GetMV("FS_SLDB8",NIL,.t.)

_cLog:= "RELATÓRIO DE ESTOQUES NEGATIVOS "+CHR(13) +CHR(10)

DbSelectArea("SB1")
DbSetOrder(1)
DbGoTop()

cQuery1	:= " SELECT C6_PRODUTO "
cQuery1	+= " FROM SC6010 C6 "
cQuery1	+= " RIGHT JOIN SC5010 C5 "
cQuery1	+= " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA "
cQuery1	+= " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C5_EMISSAO>='20130329' "
cQuery1	+= " GROUP BY C6_PRODUTO "
cQuery1 += " UNION "
cQuery1	+= " SELECT D4_COD "
cQuery1	+= " FROM SD4010 "
cQuery1	+= " WHERE D_E_L_E_T_=' ' "
cQuery1	+= " GROUP BY D4_COD "

cQuery := ChangeQuery(cQuery1)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1),"PRODUTOS", .T., .T.)

While PRODUTOS->(!Eof())
	
	cProduto	:= PRODUTOS->C6_PRODUTO
	
	nQtdeFalta := U_STResFalta(cProduto)
	cQuery	:= " SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_QPEDVEN,B2_QEMP,B2_SALPEDI,B2_QEMPSA,"
	cQuery 	+= " B2_RESERVA,B2_QTNP,B2_QNPT,B2_QTER,B2_QEMPN,B2_QACLASS,B2_QEMPPRJ,B2_QEMPPRE,B2_STATUS,"
	cQuery 	+= " B8_FILIAL,B8_PRODUTO,B8_LOCAL,B8_LOTECTL,B8_PRODUTO,B8_QTDORI,B8_SALDO,B8_EMPENHO"
	cQuery 	+= " FROM " + RetSqlName("SB2") + " SB2 LEFT OUTER JOIN " + RetSqlName("SB8") + " SB8"
	cQuery 	+= " ON B8_FILIAL = B2_FILIAL AND B2_LOCAL = B8_LOCAL AND B8_PRODUTO = B2_COD  AND"
	cQuery 	+= " SB8.D_E_L_E_T_<> '*' "
	cQuery	+= " WHERE B2_COD='" + cProduto + "' "
	cQuery  += " AND B2_STATUS <> '2' "
	If Empty(cFilCon)
		cQuery   += " AND (B2_FILIAL = '"+cFilAnt+"' OR B2_FILIAL = '"+cFilDP+"') "
	Else
		cQuery   += " AND B2_FILIAL = '"+cFilCon+"' "
	EndIf
	If ! Empty(cArmz)
		cQuery   += " AND B2_LOCAL = '"+cArmz+"' "
	EndIf
	cQuery	+= " AND SB2.D_E_L_E_T_<> '*'"
	cQuery	+= " ORDER BY B2_FILIAL,B2_LOCAL "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SLDB2B9", .T., .T.)
	
	While SLDB2B9->(!Eof())
		
		nResOP	:=nResPA2:=	nResSDC:= 0
		SB1->(DbSeek(xFilial("SB1")+SLDB2B9->B2_COD))
		nSaldoSB2:=SLDB2B9->B2_QATU //SaldoSB2(,.f.,,,,"SLDB2B9")
		If SB1->B1_LOCPAD == SLDB2B9->B2_LOCAL .and. cFilAnt== SLDB2B9->B2_FILIAL 	//Leonardo Flex -> Comentado para não subtrair duas vezes do saldoSB2
			nResOP	:= U_STResOP(SLDB2B9->B2_COD,cFilAnt)
			nResSDC	:= U_STResSDC(SLDB2B9->B2_COD)
			nResPA2 := u_STSldPV(SLDB2B9->B2_COD,cFilAnt)
			nSaldoSB2-= (nResOP +nResPA2+ nResSDC)
		EndIf
		If SB1->B1_LOCPAD == SLDB2B9->B2_LOCAL .and. cFilDP == SLDB2B9->B2_FILIAL
			nResPA2:= 0
			nResOP	:= U_STResOP(SLDB2B9->B2_COD,cFilDP)
			nResPA2 := u_STSldPV(SLDB2B9->B2_COD,cFilDP)   //U_STSldRes(SLDB2B9->B2_COD,cFilDP)
			nSaldoSB2-=(nResOP +nResPA2+ nResSDC)
		EndIf
		aadd(aRetB2,{SLDB2B9->B2_FILIAL,SLDB2B9->B2_LOCAL,nSaldoSB2,SB1->B1_LOCPAD == SLDB2B9->B2_LOCAL })
		aAdd(aViewB2,{If(SB1->B1_LOCPAD == SLDB2B9->B2_LOCAL,oOk,oNo),;
		TransForm(SLDB2B9->B2_FILIAL				,PesqPict("SB2","B2_FILIAL")),;
		TransForm(SLDB2B9->B2_LOCAL					,PesqPict("SB2","B2_LOCAL")),;
		TransForm(nSaldoSB2							,PesqPict("SB2","B2_QATU")),;
		TransForm(SLDB2B9->B2_QATU					,PesqPict("SB2","B2_QATU")),;
		TransForm(nResOP   							,PesqPict("SB2","B2_QEMP")),;	//Leonardo Flex -> Comentado para não duplicar Empenho OP
		TransForm(nResSDC+nResPA2			  		,PesqPict("SB2","B2_RESERVA")),;
		TransForm(SLDB2B9->B2_QPEDVEN				,PesqPict("SB2","B2_QPEDVEN")),;
		TransForm(SLDB2B9->B2_SALPEDI				,PesqPict("SB2","B2_SALPEDI")),;
		TransForm(SLDB2B9->B2_QEMPSA				,PesqPict("SB2","B2_QEMPSA")),;
		TransForm(SLDB2B9->B2_QTNP					,PesqPict("SB2","B2_QTNP")),;
		TransForm(SLDB2B9->B2_QNPT					,PesqPict("SB2","B2_QNPT")),;
		TransForm(SLDB2B9->B2_QTER					,PesqPict("SB2","B2_QTER")),;
		TransForm(SLDB2B9->B2_QEMPN					,PesqPict("SB2","B2_QEMPN")),;
		TransForm(SLDB2B9->B2_QACLASS				,PesqPict("SB2","B2_QACLASS")),;
		TransForm(SLDB2B9->B2_QEMPPRJ				,PesqPict("SB2","B2_QEMPPRJ")),;
		TransForm(SLDB2B9->B2_QEMPPRE				,PesqPict("SB2","B2_QEMPPRE"))})
		
		If SB1->B1_LOCPAD == SLDB2B9->B2_LOCAL
			nTotDisp	+= nSaldoSB2
			If nSaldoSB2 < 0
				If SLDB2B9->B2_FILIAL == cFilAnt
				_ClOG+= "Código: "+B2_COD+" Local: "+B2_LOCAL+" NEGATIVO EM: "+CVALTOCHAR(nSaldoSB2)+CHR(13) +CHR(10)
				_cNeg	:= "Código: "+B2_COD+" Local: "+B2_LOCAL+" NEGATIVO EM: "+CVALTOCHAR(nSaldoSB2)+"Filial: "+SLDB2B9->B2_FILIAL
				Aadd(aNeg,_cNeg)
			    GeraPA1_(cProduto,SLDB2B9->B2_FILIAL)
			    EndIf
			EndIf
			nSaldo		+= SLDB2B9->B2_QATU
			nQtPV		+= SLDB2B9->B2_QPEDVEN
			nQemp		+= nResOP	//(nResOP+nResSDC)	//Leonardo Flex -> Comentado para não duplicar Empenho OP
			nSalpedi	+= SLDB2B9->B2_SALPEDI
			nReserva	+= nResSDC+nResPA2
			nQempSA		+= SLDB2B9->B2_QEMPSA
			nQtdTerc	+= SLDB2B9->B2_QTNP
			nQtdNEmTerc	+= SLDB2B9->B2_QNPT
			nSldTerc	+= SLDB2B9->B2_QTER
			nQEmpN		+= SLDB2B9->B2_QEMPN
			nQAClass	+= SLDB2B9->B2_QACLASS
			nQEmpPrj    += SLDB2B9->B2_QEMPPRJ
			nQEmpPre    += SLDB2B9->B2_QEMPPRE
		Endif
		
		SLDB2B9->(dbSkip())
		
	EndDo
	
	SLDB2B9->(DbCloseArea())
	
	RestArea(aAreaSM0)
	RestArea(aAreaSB2)
	RestArea(aArea)
	
	PRODUTOS->(dbSkip())
	
End

PRODUTOS->(DbCloseArea())

@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return .f.             

Static Function GeraPA1_(__cProduto,_cFilial)

Local cQuery 	:= ""
Local cQuery1	:= ""
Local cQuery2	:= ""
Local __cProduto

//Apagar todas as reservas do produto selecionado
cQuery1 := "SELECT PA2_FILIAL, PA2_CODPRO, PA2_QUANT, PA2_DOC, PA2_TIPO, PA2_FILRES "
cQuery1 += "FROM PA2010 "
cQuery1 += "WHERE D_E_L_E_T_=' ' AND PA2_CODPRO='"+__cProduto+"' AND PA2_FILRES='"+_cFilial+"' "

cQuery1 := ChangeQuery(cQuery1)
TCQUERY cQuery1 NEW ALIAS "TMP1"

While TMP1->(!Eof())

	DbSelectArea("PA2")
	DbSetOrder(3)      
	DbGoTop()
	DbSeek(xFilial("PA2")+TMP1->PA2_DOC+TMP1->PA2_CODPRO+TMP1->PA2_FILRES)
	
	If !PA2->(Eof())
	
   		PA2->(RecLock("PA2",.F.))
   		PA2->(Dbdelete())
   		PA2->(MsUnlock())
	
	EndIf				
			
	DbSelectArea("TMP1")
	TMP1->(DbSkip())

EndDo

TMP1->(DbCloseArea())

//Apagar todas as faltas do produto selecionado
cQuery2 := "SELECT PA1_FILIAL, PA1_CODPRO, PA1_QUANT, PA1_DOC, PA1_TIPO "
cQuery2 += "FROM PA1010 "
cQuery2 += "WHERE D_E_L_E_T_=' ' AND PA1_CODPRO='"+__cProduto+"' AND PA1_FILIAL='"+_cFilial+"' "

cQuery2 := ChangeQuery(cQuery2)
TCQUERY cQuery2 NEW ALIAS "TMP2"

While TMP2->(!Eof())

	DbSelectArea("PA1")
	DbSetOrder(3)
	DbGoTop()
	DbSeek(xFilial("PA1")+TMP2->PA1_DOC+TMP2->PA1_CODPRO)
	
	If !PA1->(Eof())
	
   		PA1->(RecLock("PA1",.F.))
   		PA1->(Dbdelete())
   		PA1->(MsUnlock())
	
	EndIf				
			
	DbSelectArea("TMP2")
	TMP2->(DbSkip())

EndDo

TMP2->(DbCloseArea())

If cFilAnt="01" .And. _cFilial==cFilAnt
UPPA1OP(__cProduto,_cFilial)  //Construir PA1 de OP na filia 01
ElseIf cFilAnt="02" .And. _cFilial==cFilAnt
UPPA1PED(__cProduto,_cFilial) //Contrutir PA1 de Pedido na filial 02
EndIf

Return

Static Function UPPA1OP(__cProduto,_cFilial) 

cQuery := "SELECT D4_FILIAL AS FILIAL, D4_OP AS DOC, D4_COD AS PROD, D4_QUANT AS SALDO,'2' AS TIPO, SDC, CB8 "
cQuery += "FROM "
cQuery += "(SELECT SD4010.*, "
cQuery += "NVL((SELECT SUM(DC_QUANT)    FROM SDC010 WHERE D4_OP = DC_OP AND D4_COD = DC_PRODUTO  AND D4_FILIAL = DC_FILIAL AND SDC010.D_E_L_E_T_ = ' ' AND DC_LOCAL IN ('01','03')  ),0) AS SDC, "
cQuery += "NVL((SELECT SUM(CB8_QTDORI)  FROM CB8010 WHERE CB8_OP = D4_OP AND CB8_PROD = D4_COD AND D4_FILIAL = CB8_FILIAL AND CB8010.D_E_L_E_T_ = ' ' AND CB8_LOCAL IN ('01','03') ),0) AS CB8 "
cQuery += "FROM SD4010 "
cQuery += "LEFT JOIN SC2010 ON D4_FILIAL = C2_FILIAL AND D4_OP = C2_NUM||C2_ITEM||C2_SEQUEN "
cQuery += "WHERE SD4010.D_E_L_E_T_ = ' ' AND D4_QUANT > 0 AND D4_LOCAL IN ('01','03') AND SC2010.D_E_L_E_T_ = ' ' AND SC2010.C2_QUJE < SC2010.C2_QUANT AND D4_COD='"+__cProduto+"' AND D4_FILIAL='"+_cFilial+"' "
cQuery += ") TAB_TEMP "
cQuery += "LEFT JOIN SB1010 ON B1_COD = D4_COD "
cQuery += "WHERE B1_APROPRI = 'D' AND SDC = 0 "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While (cAlias)->(!Eof())
	
	DbSelectArea("PA1")
	
	PA1->(RecLock("PA1",.T.))
	PA1->PA1_FILIAL	:= (cAlias)->FILIAL
	PA1->PA1_CODPRO	:= (cAlias)->PROD
	PA1->PA1_QUANT	:= (cAlias)->SALDO
	PA1->PA1_DOC	:= (cAlias)->DOC
	PA1->PA1_TIPO	:= (cAlias)->TIPO
	PA1->PA1_OBS	:= "GERADO POR ROTINA AUTOMATICA"
	PA1->(MsUnlock())
	
	U_STGrvSt((cAlias)->DOC,NIL)
	
	DbSelectArea(cAlias)
	(cAlias)->(DbSkip())
	
EndDo                           

Return()

Static Function UPPA1PED(__cProduto,_cFilial)

Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"

cQuery := "SELECT C6_FILIAL AS FILIAL,   DOC, C6_PRODUTO AS PROD, A_FATURAR AS SALDO,'1' AS TIPO , SDC, CB8 FROM ( "
cQuery += "SELECT C6_FILIAL, C6_NUM||C6_ITEM AS DOC , C6_PRODUTO, C6_QTDVEN-C6_QTDENT AS A_FATURAR,C6_TES, "
cQuery += "NVL((SELECT SUM(DC_QUANT)    FROM SDC010 WHERE C6_NUM = DC_PEDIDO AND DC_ITEM = C6_ITEM AND C6_FILIAL = DC_FILIAL AND SDC010.D_E_L_E_T_ = ' '),0) AS SDC, "
cQuery += "NVL((SELECT SUM(CB8_QTDORI)  FROM CB8010 WHERE C6_NUM = CB8_PEDIDO AND CB8_ITEM = C6_ITEM AND C6_FILIAL = CB8_FILIAL AND CB8010.D_E_L_E_T_ = ' '),0) AS CB8 "
cQuery += "FROM SC6010 C6 "
cQuery += "LEFT JOIN SC5010 C5 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL "
cQuery += "WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_QTDVEN-C6_QTDENT>0 AND C5_EMISSAO>='20130329' AND C6_BLQ = ' ' AND C6_FILIAL='"+_cFilial+"' AND C6_PRODUTO='"+__cProduto+"' "
cQuery += ") DDDD "
cQuery += "LEFT JOIN SF4010 ON F4_CODIGO = C6_TES "
cQuery += "WHERE SDC = 0 AND F4_ESTOQUE = 'S' "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While (cAlias)->(!Eof())
	
	DbSelectArea("PA1")
	
	PA1->(RecLock("PA1",.T.))
	PA1->PA1_FILIAL	:= (cAlias)->FILIAL
	PA1->PA1_CODPRO	:= (cAlias)->PROD
	PA1->PA1_QUANT	:= (cAlias)->SALDO
	PA1->PA1_DOC	:= (cAlias)->DOC
	PA1->PA1_TIPO	:= (cAlias)->TIPO
	PA1->PA1_OBS	:= "GERADO POR ROTINA AUTOMATICA"
	PA1->(MsUnlock())
	
	U_STGrvSt(SubStr((cAlias)->DOC,1,6),NIL)

	DbSelectArea(cAlias)
	(cAlias)->(DbSkip())
	
EndDo

Return
