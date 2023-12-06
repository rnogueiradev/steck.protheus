#INCLUDE "PROTHEUS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RSTFAT06   º Autor ³ Giovani.Zago       º Data ³  20/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de pedidos rejeitados                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSTFAT06()

Local cString 			:= "SC5"
Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "dos Pedidos Com Pendências"
Local cDesc3         	:= ""
Local cPict         	:= ""
Local titulo       		:= "Pedidos Com Pendências"
Local nLin         		:= 70
//                                    1         2         3         4         5         6         7         8         9         0         1         2         3         4         6         7         8         9
//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       		:= "PEDIDO  CLI.LOJA   NOME CLIENTE                         EMISSAO     TRANSP. VEND.EXTERNO            VEND.INTERNO            SAIDA    TIPO    RESER DT.VENDAS   DT.FABRICA  SALDO P.V.     SALDO RESERVADO"
Local Cabec2      		:= "======= ========== ==================================== =========== ======= ======================= ======================= ======== ======= ===== =========== =========== =============== =============="
Local imprime      		:= .T.
Local aOrd 				:= {}
Private _nGetCond       :=  GetMv("ST_VALMIN",,400)
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 70
Private tamanho         := "G"
Private nomeprog        := "COMISS"
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFAT06"
Private cPerg       	:= "RFAT06"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

cbtxt     		:= Space(10)


AjustaSX1(cPerg)
If Pergunte(cPerg,.t.)
	
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Endif
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RunReport  º Autor ³ Giovani.Zago       º Data ³  16/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de pedido aptos a faturar                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local _aResult  :={{0,0,0,0,0}}
Local _nXCon    := 0

StQuery()


SetRegua(FCOUNT())

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		IncRegua( "Analisando Pedido: "+(cAliasLif)->PEDIDO  )
		
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin := nLin + 1
		@nLIN,000 PSAY 	(cAliasLif)->PEDIDO
		@nLIN,008 PSAY 	(cAliasLif)->CODI
		@nLIN,019 PSAY  (cAliasLif)->NOME
		@nLIN,056 PSAY 	STOD((cAliasLif)->EMISSAO)
		@nLIN,068 PSAY  (cAliasLif)->TRANSP
		@nLIN,076 PSAY 	(cAliasLif)->VEND01
		@nLIN,100 PSAY  (cAliasLif)->VEND02
		@nLIN,124 PSAY 	(cAliasLif)->ENTREGA
		@nLIN,133 PSAY 	(cAliasLif)->TIPO
		@nLIN,141 PSAY 	(cAliasLif)->RESERVA
		@nLIN,147 PSAY 	STOD((cAliasLif)->DT_VENDAS)
		@nLIN,159 PSAY 	STOD((cAliasLif)->DT_FABRICA)
		@nLIN,171 PSAY 	(cAliasLif)->LIQUIDO Picture "@E 99,999,999.99"
		@nLIN,187 PSAY 	(cAliasLif)->RESERVADO Picture "@E 99,999,999.99"
		
		
		If Empty(alltrim(	(cAliasLif)->TRANSP  ))
			nLin := nLin + 1
			@nLIN,008 PSAY '- Transportadora em Branco'
		Endif
		
		If 	(cAliasLif)->C6VALOR < _nGetCond
			nLin := nLin + 1
			@nLIN,008 PSAY '- Parcela Inferior ao Minimo Permitido    - Cond.Pagamento: '+	(cAliasLif)->COND + ' ('+ALLTRIM((cAliasLif)->DESCOND)+')  ' //  - Valor Pendente : R$ '+cvaltochar(_nGetCond - (cAliasLif)->C6VALOR)
		Endif
		If alltrim(	(cAliasLif)->ENTREGA) = 'RETIRA'
			nLin := nLin + 1
			@nLIN,008 PSAY '- Pedidos Tipo Retira'
		Endif
		
		If alltrim(	(cAliasLif)->BLOQ) = '1'
			nLin := nLin + 1
			@nLIN,008 PSAY '- Pedidos Bloqueado Por Regras Comerciais'
		Endif
		If alltrim(	(cAliasLif)->XSTATUS) <> 'LIBERADO'
			nLin := nLin + 1
			@nLIN,008 PSAY '- O Pedido Está '+alltrim(	(cAliasLif)->XSTATUS)+' Pelo Financeiro'
		Endif 
		
			If alltrim(	(cAliasLif)->C5_ZREFNF) = '1'
			nLin := nLin + 1
			@nLIN,008 PSAY '- O Pedido Está Bloqueado p/ Refaturamento'
		Endif 
		 
		nLin := nLin + 1
		@nLIN,008 PSAY Replicate("-",180)
		_nXCon++
		(cAliasLif)->(dbskip())
		
	End
	
	
	
	
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function AjustaSX1(cPerg)

Local _aArea	  := GetArea()
Local _aRegistros := {}
Local i			  := 0
Local j           := 0

cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
Aadd(_aRegistros,{cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(_aRegistros,{cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(_aRegistros,{cPerg, "03", "Do Vendedor:" ,"Do Vendedor: ?" ,"Do Vendedor: ?" 			   	,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
//Aadd(_aRegistros,{cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 			,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(_aRegistros,{cPerg, "04","Cliente de  ?",											   "","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(_aRegistros,{cPerg, "05","Cliente até ?",											   "","","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(_aRegistros,{cPerg, "06","Loja de    ?",											   "","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegistros,{cPerg, "07","Loja até   ?",											   "","","mv_ch7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(_aRegistros,{cPerg, "08", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"              ,"mv_ch8","C",10,0,3,"C","","mv_par08","Pedido","Pedido","Pedido","","","Dt.Emissão","Dt.Emissão","Dt.Emissão","","","Cliente","Cliente","Cliente","","","",""})

dbSelectArea("SX1")
_nCols := FCount()

For i:=1 to Len(_aRegistros)
	
	aSize(_aRegistros[i],_nCols)
	
	If !dbSeek(_aRegistros[i,1]+_aRegistros[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,if(_aRegistros[i,j]=Nil, "",_aRegistros[i,j] ))
		Next j
		
		MsUnlock()
		
	EndIf
Next i

RestArea(_aArea)

Return(NIL)





Static Function StQuery()

Local cQuery     := ' '
Local  _cVenUsr:= ' '
Local  _cUsrVen:= '( '
Local	lret:= .F.
Local _lVend:= .F.
Local  _cVenSupe := ' '



SetRegua(4)


IncRegua(   )

DbSelectArea('SA3')
SA3->(DbSetOrder(1))
If SA3->(dbSeek(xFilial('SA3')+MV_PAR03))
	/* desabilitado solicitação Simone Soares 28/06/13  Giovani Zago supervisor ve tudo e interno ve tudo
	If Empty(ALLTRIM(SA3->A3_SUPER))  .or. empty(ALLTRIM(SA3->A3_GEREN))
	_lVend:= .T.
	_cVenSupe:= SA3->A3_COD
	EndIf
	*/
	If SA3->A3_TPVEND = 'I'
		_cVenUsr  := SA3->A3_COD
		lret:= .T.
	Else
		_cVenUsr  := SA3->A3_COD
	EndIf
	
	
	If !lret
		_cUsrVen+="'"+_cVenUsr+"')"
	Else
	_cUsrVen+="'"+_cVenUsr+"'"
		dbSelectArea("SA3")
		SA3->(dbGoTop())
		While SA3->(!Eof())
			If SA3->A3_XCODINT = _cVenUsr
				_cUsrVen+=",'"+_cVenUsr+"'"
			EndIf
			SA3->(dbSkip())
		End
		_cUsrVen += " )"
	EndIf
	
	
Else
	_cUsrVen:="('"+"      ')"
EndIf
IncRegua(   )

IncRegua(   )
cQuery := " SELECT
cQuery += "  C5_NUM
cQuery += '  "PEDIDO",
cQuery += "  E4_DESCRI
cQuery += '  "DESCOND",
cQuery += "  C5_CONDPAG
cQuery += '  "COND",
cQuery += "  C5_CLIENTE||'-'||C5_LOJACLI
cQuery += '  "CODI" ,
cQuery += "  SUBSTR(SA1.A1_NOME,1,35)
cQuery += '  "NOME",
cQuery += "  SC5.C5_EMISSAO
cQuery += '  "EMISSAO",
cQuery += "  SC5.C5_TRANSP
cQuery += '  "TRANSP",
cQuery += "  SC5.C5_VEND1||'-'||SUBSTR(TA3.A3_NREDUZ,1,15)
cQuery += '  "VEND01",
cQuery += "  SC5.C5_VEND2||'-'||SUBSTR(SA3.A3_NREDUZ,1,15)
cQuery += '  "VEND02",
cQuery += '  SC5.C5_ZBLOQ  "BLOQ"  ,
cQuery += "   CASE WHEN SC5.C5_XTIPO = '1' THEN 'RETIRA' ELSE 'ENTREGA' END
cQuery += '  "ENTREGA",
cQuery += "  CASE WHEN SC5.C5_XTIPF = '1' THEN 'TOTAL' ELSE 'PARCIAL' END
cQuery += '  "TIPO",
cQuery += "  CASE WHEN
cQuery += "  NVL((SELECT SUM(PA1_QUANT) FROM PA1010 PA1
cQuery += "  WHERE PA1.PA1_DOC LIKE SC5.C5_NUM||'%'
cQuery += "  AND PA1.D_E_L_E_T_ = ' '
cQuery += " AND PA1.PA1_FILIAL = '01' ) ,0 ) = 0 THEN 'SIM' ELSE 'NAO' END
cQuery += '  "RESERVA",
cQuery += "  C5_XDTEN
cQuery += '  "DT_VENDAS", 
cQuery += "  C5_ZREFNF , 
cQuery += " C5_XDTFABR
cQuery += ' "DT_FABRICA",
cQuery += " (
cQuery += " SELECT   ROUND(SUM ((C6_VALOR/C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)) ,2)" //TROQUEI DE VALOR LIQUIDO PARA TOTAL SOLICITAÇÃO DA TATI
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 )
cQuery += '  "LIQUIDO",

cQuery += " CASE WHEN ( SELECT DISTINCT C9_BLCRED FROM SC9010 SC9
cQuery += " WHERE SC9.C9_PEDIDO = SC5.C5_NUM
cQuery += " AND SC9.D_E_L_E_T_ = ' '
cQuery += " AND SC9.C9_BLCRED = '09'
cQuery += " AND SC5.C5_FILIAL   = SC9.C9_FILIAL
cQuery += " ) ='09' THEN 'REJEITADO' ELSE
cQuery += " CASE WHEN ( SELECT DISTINCT C9_BLCRED FROM SC9010 SC9
cQuery += " WHERE SC9.C9_PEDIDO = SC5.C5_NUM
cQuery += " AND SC9.D_E_L_E_T_ = ' '
cQuery += " AND SC9.C9_BLCRED = ' '
cQuery += " AND SC5.C5_FILIAL   = SC9.C9_FILIAL
cQuery += " ) =' ' THEN 'LIBERADO' ELSE 'AGUARDANDO ANALISE'END END
cQuery += '  "XSTATUS",


cQuery += " (
cQuery += " SELECT   nvl(ROUND(SUM ((C6_VALOR/C6_QTDVEN)*(SELECT nvl(sum(PA2_QUANT),0)
cQuery += '  "PA2QUANT"
cQuery += " FROM "+RetSqlName("PA2")+" PA2 "
cQuery += "  WHERE PA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM
cQuery += "  AND PA2.D_E_L_E_T_   = ' '
cQuery += "  AND PA2.PA2_FILIAL   = ' ')) ,2),0)
cQuery += " FROM SC6010 SC6
cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 )
cQuery += '  "RESERVADO",


cQuery += " PARCELA
cQuery += " ,C5_ZBLOQ
cQuery += " ,(
cQuery += " SELECT   SUM (C6_VALOR)
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 )
cQuery += '  "VAL"
cQuery += " ,ROUND( ((
cQuery += " SELECT   SUM (C6_VALOR)
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 ) / PARCELA),2) AS C6VALOR
cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
cQuery += " INNER JOIN (SELECT REGEXP_COUNT(E4_COND,',',1,'i')+1
cQuery += '  "PARCELA"
cQuery += " , E4_CODIGO, E4_DESCRI, D_E_L_E_T_   FROM "+RetSqlName("SE4")+" )SE4 "
cQuery += " ON SE4.E4_CODIGO = SC5.C5_CONDPAG
cQuery += " AND SE4.D_E_L_E_T_ = ' '

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
cQuery += " ON SA1.D_E_L_E_T_   = ' '
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
cQuery += " ON SA3.D_E_L_E_T_   = ' '
cQuery += " AND SA3.A3_COD = SC5.C5_VEND2
cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )TA3 "
cQuery += " ON TA3.D_E_L_E_T_   = ' '
cQuery += " AND TA3.A3_COD = SC5.C5_VEND1
cQuery += " AND TA3.A3_FILIAL = '"+xFilial("SA3")+"'"


/* desabilitado solicitação Simone Soares 28/06/13  Giovani Zago supervisor ve tudo e interno ve tudo

If _lVend
cQuery += " inner JOIN(SELECT * FROM "+RetSqlName("SA3")+" )ZA3 "
cQuery += " ON ZA3.D_E_L_E_T_   = ' '
cQuery += " AND (ZA3.A3_COD = SC5.C5_VEND1   OR  ZA3.A3_COD = SC5.C5_VEND2  )
cQuery += " AND ZA3.A3_SUPER = '"+_cVenSupe+"'  "
cQuery += " AND ZA3.A3_FILIAL = '"+xFilial("SA3")+"'"
EndIf
*/

cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_EMISSAO between  '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'"
cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
cQuery += " AND SC5.C5_CLIENTE between  '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
cQuery += " AND SC5.C5_LOJACLI between  '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
//If !_lVend   //desabilitado solicitação Simone Soares 28/06/13  Giovani Zago supervisor ve tudo e interno ve tudo
cQuery += " AND (SC5.C5_VEND1 IN "+_cUsrVen+" Or SC5.C5_VEND2 IN "+_cUsrVen+" )
//EndIf

cQuery += " AND (SC5.C5_TRANSP = ' '
cQuery += " OR  ((
cQuery += " SELECT   SUM (C6_VALOR)
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 ) / PARCELA) < "+CVALTOCHAR(_nGetCond)
cQuery += " OR  EXISTS( SELECT C9_BLCRED FROM "+RetSqlName("SC9")+" SC9 "
cQuery += " WHERE SC9.C9_PEDIDO = SC5.C5_NUM
cQuery += " AND SC9.D_E_L_E_T_ = ' '
cQuery += " AND SC9.C9_BLCRED <> '10'
cQuery += " AND SC9.C9_BLCRED <> '  '
cQuery += " AND SC5.C5_FILIAL   = SC9.C9_FILIAL
cQuery += " )
cQuery += " OR SC5.C5_XTIPO = '1'
cQuery += " OR SC5.C5_ZBLOQ = '1')
cQuery += " AND EXISTS(
cQuery += " SELECT  *
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 )

If MV_PAR08 =1
	cQuery += " Order by SC5.C5_NUM  "
ElseIf MV_PAR08=2
	cQuery += " Order by SC5.C5_EMISSAO "
ElseIf MV_PAR08=3
	cQuery += " ORDER BY SC5.C5_CLIENTE "
EndIf

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
