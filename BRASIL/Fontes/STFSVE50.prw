#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"

Static __lOpened := .F.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³STFSVE50	 ³ Autor ³ Luiz Enrique		    ³ Data ³18/11/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cria uma tela de consulta com os saldos atuais por Empresa   ³±±
±±³          ³Totalizando suas respectivas filiais ou de Filial especifica ³±± 
±±³          ³de todos os armazens ou armazem especifico.				   ³±±
±±³          ³Cria Tambem um Array com as Totalizacoes para ser retornada. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametro 1: Codigo do Produto                               ³±±
±±³          ³Parametro 2: Filial de Consulta, ou Nil para Todas.	       ³±±
±±³          ³Parametro 3: Armazem, ou Nil para Todos.				   	   ³±± 
±±³          ³Parametro 4: Logico: 	Se .T. Retorna Totais em Array.   	   ³±±
±±³          ³								Se .F. Mostra consulta de Saldo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK		                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/   
User Function STFSVE50(cProduto,cFilCon,cArmz,aRetArray)
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
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
//Local cFilDP 	:= Right(AllTrim(GetMV("FS_PRODUCA")),2)
Local oOk		:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo		:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local aRetB2	:={}
Local cFunName := Upper(FunName())
Local nQtdeFalta
//conout(time()+' - ve50')
If __lOpened
	Return
Endif

If !U_STProducao()
	Return .T.
EndIf

__lOpened := .T.
                                                               	
Private aViewB2:= {}
Private aViewB8:= {}
Private aBkpB8	:= {}
Private aTotFil:= {}
Private oLstB8
Private lMostraB8 := GetMV("FS_SLDB8",NIL,.t.) 

Default cArmz := ""
	 
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProduto)) 
 
nQtdeFalta := U_STResFalta(cProduto)
cQuery	:= "   Select B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_QPEDVEN,B2_QEMP,Nvl(b2_salpedi,0) - NVL(SC1.SALDO,0) b2_salpedi,B2_QEMPSA,"
cQuery 	+= "          B2_RESERVA,B2_QTNP,B2_QNPT,B2_QTER,B2_QEMPN,B2_QACLASS,B2_QEMPPRJ,B2_QEMPPRE,B2_STATUS,"
cQuery 	+= "          B8_FILIAL,B8_PRODUTO,B8_LOCAL,B8_LOTECTL,B8_PRODUTO,B8_QTDORI,B8_SALDO,B8_EMPENHO, " 
cQuery 	+= "          NVL((SELECT SUM (BF_QUANT)  FROM "+RetSqlName("SBF")+" SBF WHERE SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL),0) BF_QUANT " //Ticket 20210609009702
cQuery 	+= "     From " + RetSqlName("SB2") + " SB2 LEFT OUTER JOIN " + RetSqlName("SB8") + " SB8" 
cQuery 	+= "       ON B8_FILIAL = B2_FILIAL AND B2_LOCAL = B8_LOCAL AND B8_PRODUTO = B2_COD  AND"
cQuery 	+= "          SB8.D_E_L_E_T_<> '*' "

//>> Ticket 20200629003515 - Everson Santana - 06.07.2020
cQuery 	+= "       LEFT JOIN (SELECT C1_FILIAL,C1_PRODUTO,C1_LOCAL,SUM(C1_QUANT-C1_QUJE) SALDO FROM "+RetSqlName("SC1")+ " SC1 "
cQuery 	+= "                     WHERE D_E_L_E_T_ = ' ' "
cQuery 	+= "                         AND C1_ZSTATUS IN ('4','5') "
cQuery 	+= "                         AND C1_FILIAL = '"+cFilAnt+"' "
cQuery 	+= "                         AND C1_QUJE < C1_QUANT   "
cQuery 	+= "						 AND C1_RESIDUO = ' ' " //Ticket 20200923007799 - Everson Santana - 29.09.2020
cQuery 	+= "                     GROUP BY C1_FILIAL,C1_PRODUTO,C1_LOCAL) SC1 "
cQuery 	+= "             ON SC1.C1_PRODUTO = SB2.b2_cod "
cQuery 	+= "                AND SC1.C1_LOCAL = SB2.B2_LOCAL "
cQuery 	+= "                AND Sc1.C1_Filial = SB2.B2_FILIAL   "
//<< Ticket 20200629003515 

cQuery	+= "    Where B2_COD='" + cProduto + "' "
cQuery   += "      and B2_STATUS <> '2' " 
If Empty(cFilCon)
	cQuery   += "      and (B2_FILIAL = '"+cFilAnt+"' OR B2_FILIAL = '"+cFilDP+"') "
Else                                                                               
	cQuery   += "      and B2_FILIAL = '"+cFilCon+"' "
EndIf	                                             
If ! Empty(cArmz)
	cQuery   += "      and B2_LOCAL = '"+cArmz+"' "
EndIf	
cQuery	+= " AND SB2.D_E_L_E_T_<> '*'"
cQuery	+= " Order By B2_FILIAL,B2_LOCAL "
 		

			
//cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "SLDB2B8"
			
If SLDB2B8->(Eof())
	If aRetArray == NIL
		ApMsgAlert("Nao existe registro em estoque para este produto.","Atencao")	
	EndIf		
	RestArea(aAreaSM0)
	RestArea(aAreaSB2)
	RestArea(aAreaSB1)
	RestArea(aArea)
	SLDB2B8->(DbCloseArea())
	__lOpened := .F.
	Return
Endif
			
While SLDB2B8->(!Eof())			
						
	If ascan(aViewB2,{|x| x[02]+x[03] == SLDB2B8->B2_FILIAL+SLDB2B8->B2_LOCAL}) == 0 // Ignora duplicidade do LEFT OUTER JOIN
		nResOP	:=nResPA2:=	nResSDC:= 0	
		SB1->(DbSeek(xFilial("SB1")+SLDB2B8->B2_COD)) 			
		//nSaldoSB2:=SLDB2B8->B2_QATU - SLDB2B8->B2_QACLASS //SaldoSB2(,.f.,,,,"SLDB2B8")  // ALTERADO GALLO-RVG PARA DESCONTAR SALDO A ENDERECAR
		nSaldoSB2:=SLDB2B8->BF_QUANT //Ticket 20210609009702
		
		If Empty(cArmz)

			If SB1->B1_LOCPAD == SLDB2B8->B2_LOCAL .and. cFilAnt== SLDB2B8->B2_FILIAL 	//Leonardo Flex -> Comentado para não subtrair duas vezes do saldoSB2
				nResOP	:= U_STResOP(SLDB2B8->B2_COD,cFilAnt)
				nResSDC	:= U_STResSDC(SLDB2B8->B2_COD)	 
				nResPA2 := u_STSldPV(SLDB2B8->B2_COD,cFilAnt)	 
				nSaldoSB2-= (nResOP +nResPA2+ nResSDC)
				//nSaldoSB2-= nResSDC // Leonardo Flex -> retirado pois estava subtraindo SDC do saldo e ficando negativo 10042013
			EndIf

			nSaldoSB2 := Iif(nSaldoSB2<0,0,nSaldoSB2)
			aadd(aRetB2,{SLDB2B8->B2_FILIAL,SLDB2B8->B2_LOCAL,nSaldoSB2,SB1->B1_LOCPAD == SLDB2B8->B2_LOCAL })								
			aAdd(aViewB2,{If(SB1->B1_LOCPAD == SLDB2B8->B2_LOCAL,oOk,oNo),;
								TransForm(SLDB2B8->B2_FILIAL				,PesqPict("SB2","B2_FILIAL")),;
								TransForm(SLDB2B8->B2_LOCAL					,PesqPict("SB2","B2_LOCAL")),;
								TransForm(nSaldoSB2							,PesqPict("SB2","B2_QATU")),;
								TransForm(SLDB2B8->B2_QATU					,PesqPict("SB2","B2_QATU")),;
								TransForm(nResOP    /*nResOP+nResSDC*/		,PesqPict("SB2","B2_QEMP")),;	//Leonardo Flex -> Comentado para não duplicar Empenho OP
								TransForm(nResSDC+nResPA2			  		,PesqPict("SB2","B2_RESERVA")),;
								TransForm(SLDB2B8->B2_QPEDVEN				,PesqPict("SB2","B2_QPEDVEN")),;
								TransForm(SLDB2B8->B2_SALPEDI				,PesqPict("SB2","B2_SALPEDI")),;
								TransForm(SLDB2B8->B2_QEMPSA				,PesqPict("SB2","B2_QEMPSA")),;
								TransForm(SLDB2B8->B2_QTNP					,PesqPict("SB2","B2_QTNP")),;
								TransForm(SLDB2B8->B2_QNPT					,PesqPict("SB2","B2_QNPT")),;
								TransForm(SLDB2B8->B2_QTER					,PesqPict("SB2","B2_QTER")),;
								TransForm(SLDB2B8->B2_QEMPN					,PesqPict("SB2","B2_QEMPN")),;
								TransForm(SLDB2B8->B2_QACLASS				,PesqPict("SB2","B2_QACLASS")),;
								TransForm(SLDB2B8->B2_QEMPPRJ				,PesqPict("SB2","B2_QEMPPRJ")),;
								TransForm(SLDB2B8->B2_QEMPPRE				,PesqPict("SB2","B2_QEMPPRE"))})
			
			If SB1->B1_LOCPAD == SLDB2B8->B2_LOCAL
				nTotDisp	+= nSaldoSB2
				nSaldo		+= SLDB2B8->B2_QATU
				nQtPV		+= SLDB2B8->B2_QPEDVEN
				nQemp		+= nResOP	//(nResOP+nResSDC)	//Leonardo Flex -> Comentado para não duplicar Empenho OP
				nSalpedi	+= SLDB2B8->B2_SALPEDI
				nReserva	+= nResSDC+nResPA2
				nQempSA		+= SLDB2B8->B2_QEMPSA
				nQtdTerc	+= SLDB2B8->B2_QTNP
				nQtdNEmTerc	+= SLDB2B8->B2_QNPT
				nSldTerc	+= SLDB2B8->B2_QTER
				nQEmpN		+= SLDB2B8->B2_QEMPN 
				nQAClass	+= SLDB2B8->B2_QACLASS
				nQEmpPrj    += SLDB2B8->B2_QEMPPRJ
				nQEmpPre    += SLDB2B8->B2_QEMPPRE
			Endif	
		Else

			If cArmz == SLDB2B8->B2_LOCAL .and. cFilAnt== SLDB2B8->B2_FILIAL 	//Leonardo Flex -> Comentado para não subtrair duas vezes do saldoSB2
				nResOP	:= U_STResOP(SLDB2B8->B2_COD,cFilAnt)
				nResSDC	:= U_STResSDC(SLDB2B8->B2_COD,cArmz)	 
				nResPA2 := u_STSldPV(SLDB2B8->B2_COD,cFilAnt,cArmz)	 
				nSaldoSB2-= (nResOP +nResPA2+ nResSDC)
				//nSaldoSB2-= nResSDC // Leonardo Flex -> retirado pois estava subtraindo SDC do saldo e ficando negativo 10042013
			EndIf

			nSaldoSB2 := Iif(nSaldoSB2<0,0,nSaldoSB2)
			aadd(aRetB2,{SLDB2B8->B2_FILIAL,SLDB2B8->B2_LOCAL,nSaldoSB2,.T. })								
			aAdd(aViewB2,{If(SB1->B1_LOCPAD == SLDB2B8->B2_LOCAL,oOk,oNo),;
								TransForm(SLDB2B8->B2_FILIAL				,PesqPict("SB2","B2_FILIAL")),;
								TransForm(SLDB2B8->B2_LOCAL					,PesqPict("SB2","B2_LOCAL")),;
								TransForm(nSaldoSB2							,PesqPict("SB2","B2_QATU")),;
								TransForm(SLDB2B8->B2_QATU					,PesqPict("SB2","B2_QATU")),;
								TransForm(nResOP    /*nResOP+nResSDC*/		,PesqPict("SB2","B2_QEMP")),;	//Leonardo Flex -> Comentado para não duplicar Empenho OP
								TransForm(nResSDC+nResPA2			  		,PesqPict("SB2","B2_RESERVA")),;
								TransForm(SLDB2B8->B2_QPEDVEN				,PesqPict("SB2","B2_QPEDVEN")),;
								TransForm(SLDB2B8->B2_SALPEDI				,PesqPict("SB2","B2_SALPEDI")),;
								TransForm(SLDB2B8->B2_QEMPSA				,PesqPict("SB2","B2_QEMPSA")),;
								TransForm(SLDB2B8->B2_QTNP					,PesqPict("SB2","B2_QTNP")),;
								TransForm(SLDB2B8->B2_QNPT					,PesqPict("SB2","B2_QNPT")),;
								TransForm(SLDB2B8->B2_QTER					,PesqPict("SB2","B2_QTER")),;
								TransForm(SLDB2B8->B2_QEMPN					,PesqPict("SB2","B2_QEMPN")),;
								TransForm(SLDB2B8->B2_QACLASS				,PesqPict("SB2","B2_QACLASS")),;
								TransForm(SLDB2B8->B2_QEMPPRJ				,PesqPict("SB2","B2_QEMPPRJ")),;
								TransForm(SLDB2B8->B2_QEMPPRE				,PesqPict("SB2","B2_QEMPPRE"))})
			
			If cArmz == SLDB2B8->B2_LOCAL
				nTotDisp	+= nSaldoSB2
				nSaldo		+= SLDB2B8->B2_QATU
				nQtPV		+= SLDB2B8->B2_QPEDVEN
				nQemp		+= nResOP	//(nResOP+nResSDC)	//Leonardo Flex -> Comentado para não duplicar Empenho OP
				nSalpedi	+= SLDB2B8->B2_SALPEDI
				nReserva	+= nResSDC+nResPA2
				nQempSA		+= SLDB2B8->B2_QEMPSA
				nQtdTerc	+= SLDB2B8->B2_QTNP
				nQtdNEmTerc	+= SLDB2B8->B2_QNPT
				nSldTerc	+= SLDB2B8->B2_QTER
				nQEmpN		+= SLDB2B8->B2_QEMPN 
				nQAClass	+= SLDB2B8->B2_QACLASS
				nQEmpPrj    += SLDB2B8->B2_QEMPPRJ
				nQEmpPre    += SLDB2B8->B2_QEMPPRE
			Endif	

		EndIf
		
	Endif
					
	If Rastro(SLDB2B8->B2_COD) .And. SLDB2B8->B8_PRODUTO <> Nil
	
			aAdd(aViewB8,{	TransForm(SLDB2B8->B8_FILIAL	    ,PesqPict("SB8","B8_FILIAL")),;
							TransForm(SLDB2B8->B8_LOCAL		    ,PesqPict("SB8","B8_LOCAL")),;
							TransForm(SLDB2B8->B8_LOTECTL		,PesqPict("SB8","B8_LOTECTL")),;
							TransForm(SLDB2B8->B8_SALDO		    ,PesqPict("SB8","B8_SALDO")),;
							TransForm(SLDB2B8->B8_EMPENHO		,PesqPict("SB8","B8_SALDO")),;
							TransForm(SLDB2B8->B8_QTDORI		,PesqPict("SB8","B8_QTDORI"))})	
	Endif 
	
	
	SLDB2B8->(dbSkip())
	
EndDo
SLDB2B8->(DbCloseArea())

If aRetArray <> NIL	//Apenas Retorna o Array com os Totais das Filiais
	If !Empty(aViewB2)
		aRetArray:= aClone(aRetB2)
		RestArea(aAreaSM0)
		RestArea(aAreaSB2)                                                                              
		RestArea(aAreaSB1)
		RestArea(aArea)	
		__lOpened := .F.
		Return aRetArray // .F.
	Endif
Endif

aBkpB8:= Aclone(aViewB8)

If "TMKA271" $ cFunName
	aAdd(aButtons, {'tabprice', 	{|| FSTabela(cProduto) } 			, "Tabela","Precos"} )
	aAdd(aButtons, {'SduRepl', 	{|| FSVisuProd(cProduto,cArmz) }	, "Cadastro","Produto"} )
Else
	If "MATA410" $ cFunName
		aAdd(aButtons, {'Note', 	{|| FSVisuProd(cProduto,cArmz) }	, "Cadastro","Cadastro"} )
	Else
		aAdd(aButtons, {'SduRepl', 	{|| FSMC050CON(cProduto) } 		, "Produto","Produto"} )
	Endif
EndIf 

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg FROM 000,000  TO 470,600 TITLE "Saldos em Estoque" Of oMainWnd PIXEL 

EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)
oPanel :=TPanel():New( 010, 010, ,oDlg, , , , , , 10, 20, .F.,.T. )
oPanel :align := CONTROL_ALIGN_TOP
@ 004,007 SAY SM0->M0_CODIGO			+	" - " + SM0->M0_FILIAL 	+ If (!Empty(cFilCon)	,"  - Filial: "	+ SM0->M0_NOME,"")	Of oPanel PIXEL SIZE 245,009
@ 010,007 SAY Alltrim(cProduto)		+ 	" - " + SB1->B1_DESC 	+ If (!Empty(cArmz)		,"  - Armazem: "	+ cArmz,"") 			Of oPanel PIXEL SIZE 245,009 FONT oBold

oPasta:= TFolder():New(035,000,{"Totais","Filias","Imagem","Observação"},{},oDlg,,,,.T.,.F.,400,300,)
oPasta:align 	:= CONTROL_ALIGN_ALLCLIENT  
@ 015,115 SAY "FILIAIS SUMARIZADAS " 									of oPasta:aDialogs[1] PIXEL SIZE 90 ,09 FONT oBold  
@ 035,007 SAY "Quantidade Disponivel    " 					  		of oPasta:aDialogs[1] PIXEL 
@ 034,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") 		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 035,155 SAY "Reserva/Empenho OP " 						  			of oPasta:aDialogs[1] PIXEL 
@ 034,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") 			of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 050,007 SAY "Saldo Atual   " 											of oPasta:aDialogs[1] PIXEL 
@ 049,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU")   		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 050,155 SAY "Reserva/Empenho PV "				 						of oPasta:aDialogs[1] PIXEL 
@ 049,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 065,007 SAY "Pedido de Vendas  " 										of oPasta:aDialogs[1] PIXEL 
@ 064,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") 		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 065,155 SAY "Entrada Prevista" 										of oPasta:aDialogs[1] PIXEL 
@ 064,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 080,007 SAY "Solicitação Armazem" 									of oPasta:aDialogs[1] PIXEL 
@ 079,075 MsGet nQEmpSA Picture PesqPict("SB2","B2_QEMPSA") 	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 080,155 SAY RetTitle("B2_QTNP") 										of oPasta:aDialogs[1] PIXEL
@ 079,223 MsGet nQtdTerc Picture PesqPict("SB2","B2_QTNP") 		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 095,007 SAY RetTitle("B2_QNPT") 										of oPasta:aDialogs[1] PIXEL
@ 094,075 MsGet nQtdNEmTerc Picture PesqPict("SB2","B2_QNPT")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 095,155 SAY RetTitle("B2_QTER") 										of oPasta:aDialogs[1] PIXEL 
@ 094,223 MsGet nSldTerc Picture PesqPict("SB2","B2_QTER") 		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.
@ 110,007 SAY RetTitle("B2_QEMPN") 										of oPasta:aDialogs[1] PIXEL 
@ 109,075 MsGet nQEmpN Picture PesqPict("SB2","B2_QEMPN") 		of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.
@ 110,155 SAY RetTitle("B2_QACLASS") 									of oPasta:aDialogs[1] PIXEL 
@ 109,223 MsGet nQAClass Picture PesqPict("SB2","B2_QACLASS") 	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.
@ 125,007 SAY RetTitle("B2_QEMPPRJ") 									of oPasta:aDialogs[1] PIXEL 
@ 124,075 MsGet nQEmpPrj Picture PesqPict("SB2","B2_QEMPPRJ")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		
@ 125,155 SAY RetTitle("B2_QEMPPRE") 									of oPasta:aDialogs[1] PIXEL 
@ 124,223 MsGet nQEmpPre Picture PesqPict("SB2","B2_QEMPPRE")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.     
@ 140,007 SAY "Falta"					 									of oPasta:aDialogs[1] PIXEL 
@ 139,075 MsGet nQtdeFalta Picture PesqPict("SB2","B2_QATU")	of oPasta:aDialogs[1] PIXEL SIZE 070,009 When .F.		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ITENS DO SB2  						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oListBox:= TWBrowse():New( 010,007,050,080,,{ " ",;
																"Filial",;  
																"Local",;
																"Disponivel",;
																"Saldo",;
																"Emp/Reserva OP",;
																"Emp/Reserva PV",;
																"Pedido de Vendas",;
																"Prevista Entrada",;
																"Solicitação Armazem.",;
																SB2->(RetTitle("B2_QTNP")),;
																SB2->(RetTitle("B2_QNPT")),;
																SB2->(RetTitle("B2_QTER")),;
																SB2->(RetTitle("B2_QEMPN")),;
																SB2->(RetTitle("B2_QACLASS")),;
																SB2->(RetTitle("B2_QEMPPRJ")),;
											  					SB2->(RetTitle("B2_QEMPPRE"))},;
																{5,17,17,58,58,58,58,58,58,58},oPasta:aDialogs[2],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aViewB2)
oListBox:bLine := { || aViewB2[oListBox:nAT]}
oListBox:nAt   := 1
oListBox:bLDblClick  := { || { AtuBoxB8(aViewB2[oListBox:nAT,2],aViewB2[oListBox:nAT,3]) }}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ITENS DO SB8  						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aViewB8) > 0 .And. lMostraB8
	oListBox:align := CONTROL_ALIGN_TOP
	oLstB8:= TWBrowse():New(095,007,287,080,,{"Filial","Local","Lote","Saldo Atual","Qtd. Empenhada","Qtd. Original"},{20,20,20,20,20,20},oPasta:aDialogs[2],,,,,,,,,,,,.F.,,.T.,,.F.,,,) 
	oLstB8:SetArray(aBkpB8)
	oLstB8:bLine := { || aBkpB8[oLstB8:nAT]}
	oLstB8:nAt   := 1
	//oLstB8:align := CONTROL_ALIGN_BOTTOM
	oLstB8:align := CONTROL_ALIGN_ALLCLIENT
Else
	oListBox:align := CONTROL_ALIGN_ALLCLIENT 
Endif
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a imagem do produto   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

If ! Empty(SB1->B1_BITMAP)
	@ 00,00 REPOSITORY oBitPro OF oPasta:aDialogs[3] NOBORDER SIZE 190,155 PIXEL
	Showbitmap(oBitPro,SB1->B1_BITMAP,"")
	oBitPro:align := CONTROL_ALIGN_ALLCLIENT
	oBitPro:lStretch:=.T.                  
	oBitPro:blDBlClick := {|| oBitPro:lStretch:=!oBitPro:lStretch }
	oBitPro:Refresh()
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as observa‡ao sobre o produto B1_OBS         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cObs   := MSMM(SB1->B1_CODOBS,TamSx3("B1_OBS")[1])
@ 04,04 GET oObs VAR cObs OF oPasta:aDialogs[4] MEMO Size 273,040 PIXEL READONLY 

AtuBoxB8(aViewB2[oListBox:nAT,2],aViewB2[oListBox:nAT,3])

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aAreaSM0)
RestArea(aAreaSB2)
RestArea(aAreaSB1)
RestArea(aArea)

__lOpened := .F.
//conout(time()+' - ve50s')
Return .f.             

Static Function FSMC050CON(cProduto)
Private cCadastro := "Consulta" 
SaveInter()           
Pergunte("MTC050",.F.)
MC050CON()
RestInter()
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FSVisuProd ³ Autor ³ Luiz Enrique		     ³ Data ³18/11/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Visualiza‡„o do cadastro de Produtos. 					    		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK		                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FSVisuProd(cProduto,cLocal)
Private cCadastro := "Visualiza‡„o de Produtos"

DbSelectArea("SB1")

AxVisual("SB1",SB1->(RECNO()), 2)

Return(.T.)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FSTabela	 ³ Autor ³ Luiz Enrique		     ³ Data ³18/11/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Carrega as Tabelas de Preco da consulta de produto.     		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK		                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FSTabela(cProduto)

Local aArea 	:= GetArea()
Local aCores   := {}
Local aRotAnt	:= aClone(aRotina)
Local cCadAnt	:= cCadastro
Local lIncAnt  := INCLUI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := {	{ "Pesquisar"	,"AxPesqui"	,0,1},;	
							{ "Visualizar"	,"Oms010Tab",0,2},;	
							{ "Incluir"		,"Oms010Tab",0,3},;	
							{ "Alterar"		,"Oms010Tab",0,4},;	
							{ "Excluir"		,"Oms010Tab",0,5},;	
							{ "Copiar"		,"Oms010Tab",0,4},; 
							{ "Copiar"		,"Oms010For",0,3},; 	
							{ "Reajuste"	,"Oms010Rej",0,5},; 
				  			{ "Legenda"		,"Oms010Leg",0,2} }	

cCadastro := "Manutencao da Tabela de Precos"	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as cores da MBrowse                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCores,{"Dtos(DA0_DATATE) <= Dtos(dDataBase).AND. !Empty(Dtos(DA0_DATATE))","DISABLE"}) //inativa
Aadd(aCores,{"(Dtos(DA0_DATATE) > Dtos(dDataBase) .OR. Empty(Dtos(DA0_DATATE))).AND.DA0_ATIVO =='1'","ENABLE"})    //Ativa simples
Aadd(aCores,{"(Dtos(DA0_DATATE) > Dtos(dDataBase) .OR. Empty(Dtos(DA0_DATATE))) .AND.DA0_ATIVO =='2'","BR_LARANJA"}) //Ativa especial

INCLUI := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Endereca para a funcao MBrowse                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DA0")
DbSetOrder(1)
DbSeek(xFilial("DA0"))

If Pergunte("OMS010",.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a Integridade da Rotina                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Oms010Tab("DA0",DA0->(Recno()),2,.T.)

Endif
	
DbSelectArea("DA0")
DbSetOrder(1)
DbClearFilter()

RestArea(aArea)
cCadastro 	:= cCadAnt
aRotina		:= aClone(aRotAnt)	 
INCLUI 		:= lIncAnt
	
Return 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AtuBoxB8	 ³ Autor ³ Luiz Enrique		     ³ Data ³18/11/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Atualiza lista dos Saldo por Lote conforme Filial/Local  		³±±
±±³          ³selecionada na Lista das Filiais										³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK		                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AtuBoxB8(cFil,cArm)

Local ncop,nx

If Len(aViewB8) == 0 .Or. !lMostraB8
	Return
Endif

aBkpB8:= {}

nx:= ascan(aViewB8,{|x| x[01] + x[02] == cFil + cArm})
If nx > 0
	For ncop:= nx to Len(aViewB8)
		If aViewB8[ncop,1] + aViewB8[ncop,2] == cFil + cArm
				aAdd(aBkpB8,{	aViewB8[ncop,1]	,;
									aViewB8[ncop,2]	,;
									aViewB8[ncop,3]	,;
									aViewB8[ncop,4]	,;
									aViewB8[ncop,5]	,;
									aViewB8[ncop,6]	}) 
		Endif
	Next
Else
	aAdd(aBkpB8,{	TransForm(cFil				,PesqPict("SB8","B8_FILIAL")),;
						TransForm(cArm				,PesqPict("SB8","B8_LOCAL")),;
						TransForm("Sem Lotes!"	,PesqPict("SB8","B8_LOTECTL")),;
						TransForm(0 				,PesqPict("SB8","B8_SALDO")),;
						TransForm(0					,PesqPict("SB8","B8_SALDO")),;
						TransForm(0 				,PesqPict("SB8","B8_QTDORI"))})
Endif

oLstB8:SetArray(aBkpB8)
oLstB8:bLine := { || aBkpB8[oLstB8:nAT]}
oLstB8:Refresh()

Return
