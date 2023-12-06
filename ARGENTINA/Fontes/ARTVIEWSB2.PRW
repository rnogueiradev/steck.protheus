#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} ARVIEWSB2

Consulta Saldo de Pedidos

@type function
@author Everson Santana
@since 24/01/19
@version Protheus 12 - SIGAEST

@history ,Chamado 008598 ,

/*/

User Function ARVIEWSB2(cProduto,cFilCon,cAlmox)

	Local aArea			:= GetArea()
	Local aAreaSB1		:= SB1->(GetArea())
	Local aAreaSB2		:= SB2->(GetArea())
	Local aAreaSM0		:= SM0->(GetArea())
	Local aViewB2		:= {}
	Local aStruSB2  	:= {}
	Local aNewSaldo 	:= {}
	Local oCursor		:= LoadBitMap(GetResources(),"LBNO")
	Local nTotDisp		:= 0
	Local nTotExecDisp	:=0
	Local nSaldo		:= 0
	Local nQtPV			:= 0
	Local nQemp			:= 0
	Local nSalpedi		:= 0
	Local nReserva		:= 0
	Local nQempSA		:= 0
	Local nSaldoSB2		:=0
	Local nQtdTerc 		:=0
	Local nQtdNEmTerc	:=0
	Local nSldTerc 		:=0
	Local nQEmpN 		:=0
	Local nQAClass 		:=0
	Local nQEmpPrj  	:= 0
	Local nQEmpPre  	:= 0
	Local _nQPreV  		:= 0
	Local _nEstSeg		:= 0
	Local _cXLIENCI		:= ""
	Local _cXSEGURI		:= ""
	Local _cXPREMES		:= ""	
	Local nX        	:= 0
	Local nB2_QATU  	:= 0,nB2_QPEDVEN := 0,nB2_QEMP := 0,nB2_SALPEDI := 0,nB2_QEMPSA := 0,nB2_RESERVA :=0
	Local nB2_QTNP  	:= 0,nB2_QNPT := 0,	nB2_QTER := 0,nB2_QEMPN := 0,nB2_QACLASS := 0,nB2_QPRJ := 0, nB2_QPRE := 0 , nB2_PREV := 0
	Local _cLocal 		:= AllTrim(GetMv("ST_ARMDISP",,"01"))
	
	Local cFilialSB2	:= xFilial("SB2")
	Local cFilialSB1	:= xFilial("SB1")
	Local nAtIni    	:= 1
	Local oListBox, oDlg, oBold
	Local nHdl      	:= GetFocus()

	DEFAULT cAlmox 		:= ""

	//?Verifica a filial de pesquisa do saldo                                 ?

	If !Empty(cFilCon)
		If !Empty(cFilialSB2)
			cFilialSB2 := cFilCon
		EndIf
		dbSelectArea("SM0")
		dbSetOrder(1)
		MsSeek(cEmpAnt+cFilCon)
	EndIf

	//?Posiciona o cadastro de produtos                                       ?

	dbSelectArea('SB1')
	dbSetOrder(1)
	If MsSeek(cFilialSB1+cProduto)
		cCursor  := "MAVIEWSB2"
		lQuery   := .T.
		aStruSB2 := SB2->(dbStruct())

		cQuery := ""
		cQuery += "SELECT * FROM "+RetSqlName("SB2")+" WHERE "
		cQuery += "B2_FILIAL='"+cFilialSB2+"' AND "
		cQuery += "B2_COD='"+cProduto+"' AND "
		cQuery += "B2_STATUS <> '2' AND "
		
		//Ajustado para atender o Ticket 20190531000012
		//cQuery += "B2_LOCAL = '"+_cLocal+"' AND "
		
		cQuery += "D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY B2_LOCAL "

		cQuery := ChangeQuery(cQuery)

		SB2->(dbCommit())

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		For nX := 1 To Len(aStruSB2)
			If aStruSB2[nX][2]<>"C"
				TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
			EndIf
		Next nX

		dbSelectArea(cCursor)
		While ( !Eof() )
			

				
				nSaldoSB2:=SaldoSB2(,,,,,cCursor)
	
				nB2_QATU    := (cCursor)->B2_QATU
				nB2_QPEDVEN := (cCursor)->B2_QPEDVEN
				nB2_QEMP    := (cCursor)->B2_QEMP
				nB2_SALPEDI := (cCursor)->B2_SALPEDI
				nB2_QEMPSA  := (cCursor)->B2_QEMPSA
				nB2_RESERVA := (cCursor)->B2_RESERVA
				nB2_QTNP    := (cCursor)->B2_QTNP
				nB2_QNPT    := (cCursor)->B2_QNPT
				nB2_QTER    := (cCursor)->B2_QTER
				nB2_QEMPN   := (cCursor)->B2_QEMPN
				nB2_QACLASS := (cCursor)->B2_QACLASS
				nB2_QPRJ 	:= (cCursor)->B2_QEMPPRJ
				nB2_QPRE 	:= (cCursor)->B2_QEMPPRE
				nB2_PREV	:= (cCursor)->B2_SALPEDI
	
				aAdd(aViewB2,{TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
				TransForm(nSaldoSB2,PesqPict("SB2","B2_QATU")),;
				TransForm(nB2_QATU,PesqPict("SB2","B2_QATU")),;
				TransForm(nB2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
				TransForm(nB2_QEMP,PesqPict("SB2","B2_QEMP")),;
				TransForm(nB2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
				TransForm(nB2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
				TransForm(nB2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
				TransForm(nB2_QTNP,PesqPict("SB2","B2_QTNP")),;
				TransForm(nB2_QNPT,PesqPict("SB2","B2_QNPT")),;
				TransForm(nB2_QTER,PesqPict("SB2","B2_QTER")),;
				TransForm(nB2_QEMPN,PesqPict("SB2","B2_QEMPN")),;
				TransForm(nB2_QACLASS,PesqPict("SB2","B2_QACLASS")),;
				TransForm(nB2_QPRJ,PesqPict("SB2","B2_QEMPPRJ")),;
				TransForm(nB2_QPRE,PesqPict("SB2","B2_QEMPPRE")),;
				TransForm(nB2_PREV,PesqPict("SB2","B2_SALPEDI"))})
	
				If !Empty(cAlmox) .And. cAlmox == (cCursor)->B2_LOCAL
					nAtIni := Len(aViewB2)
				EndIf
				
			If (cCursor)->B2_LOCAL	$ _cLocal
			
				nTotDisp	+= nSaldoSB2
				nSaldo		+= nB2_QATU
				nQtPV		+= nB2_QPEDVEN
				nQemp		+= nB2_QEMP
				nSalpedi	+= nB2_SALPEDI
				nReserva	+= nB2_RESERVA
				nQempSA		+= nB2_QEMPSA
				nQtdTerc	+= nB2_QTNP
				nQtdNEmTerc	+= nB2_QNPT
				nSldTerc	+= nB2_QTER
				nQEmpN		+= nB2_QEMPN
				nQAClass	+= nB2_QACLASS
				nQEmpPrj    += nB2_QPRJ
				nQEmpPre    += nB2_QPRE
				_nQPreV 	+= nB2_PREV
			
			EndIf
			
			dbSelectArea(cCursor)
			dbSkip()
				
		EndDo
		
		If lQuery
			dbSelectArea(cCursor)
			dbCloseArea()
			dbSelectArea("SB2")
		EndIf

		If !Empty(aViewB2)

			DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
			DEFINE MSDIALOG oDlg FROM 000,000  TO 570,600 TITLE "Saldos em Estoque" Of oMainWnd PIXEL
			@ 023,004 To 24,296 Label "" of oDlg PIXEL
			@ 113,004 To 114,296 Label "" of oDlg PIXEL
			oListBox := TWBrowse():New( 30,2,297,69,,{"Local","Qtd.Disponivel","Sld.Atual","Qtd.Pedido de Vendas","Qtd. Empenhada","Qtd. Prevista Entrada","Qtd.Empenhada S.A.","Qtd. Reservada",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

			oListBox:SetArray(aViewB2)
			oListBox:bLine := { || aViewB2[oListBox:nAT]}
			oListBox:nAt   := Max(1,nAtIni)
			@ 004,010 SAY SM0->M0_CODIGO+"/"+FWCodFil()+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
			@ 014,010 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
			@ 104,010 SAY "TOTAL " Of oDlg PIXEL SIZE 30 ,9 FONT oBold

			@ 120,007 SAY "Quantidade Disponivel    " of oDlg PIXEL
			@ 119,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

			@ 120,155 SAY "Quantidade Empenhada " of oDlg PIXEL
			@ 119,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.

			@ 135,007 SAY "Saldo Atual   " of oDlg PIXEL
			@ 134,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

			@ 135,155 SAY "Qtd. Entrada Prevista" of oDlg PIXEL
			@ 134,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.

			@ 150,007 SAY "Qtd. Pedido de Vendas  " of oDlg PIXEL
			@ 149,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.

			@ 150,155 SAY "Qtd. Reservada  " of oDlg PIXEL
			@ 149,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.

			@ 165,007 SAY "Qtd. Empenhada S.A." of oDlg PIXEL
			@ 164,075 MsGet nQEmpSA Picture PesqPict("SB2","B2_QEMPSA") of oDlg PIXEL SIZE 070,009 When .F.

			@ 165,155 SAY RetTitle("B2_QTNP") of oDlg PIXEL
			@ 164,223 MsGet nQtdTerc Picture PesqPict("SB2","B2_QTNP") of oDlg PIXEL SIZE 070,009 When .F.

			@ 180,007 SAY RetTitle("B2_QNPT") of oDlg PIXEL
			@ 179,075 MsGet nQtdNEmTerc Picture PesqPict("SB2","B2_QNPT") of oDlg PIXEL SIZE 070,009 When .F.

			@ 180,155 SAY RetTitle("B2_QTER") of oDlg PIXEL
			@ 179,223 MsGet nSldTerc Picture PesqPict("SB2","B2_QTER") of oDlg PIXEL SIZE 070,009 When .F.

			@ 195,007 SAY RetTitle("B2_QEMPN") of oDlg PIXEL
			@ 194,075 MsGet nQEmpN Picture PesqPict("SB2","B2_QEMPN") of oDlg PIXEL SIZE 070,009 When .F.

			@ 195,155 SAY RetTitle("B2_QACLASS") of oDlg PIXEL
			@ 194,223 MsGet nQAClass Picture PesqPict("SB2","B2_QACLASS") of oDlg PIXEL SIZE 070,009 When .F.

			@ 210,007 SAY RetTitle("B2_QEMPPRJ") of oDlg PIXEL
			@ 209,075 MsGet nQEmpPrj Picture PesqPict("SB2","B2_QEMPPRJ") of oDlg PIXEL SIZE 070,009 When .F.

			@ 210,155 SAY RetTitle("B2_QEMPPRE") of oDlg PIXEL
			@ 209,223 MsGet nQEmpPre Picture PesqPict("SB2","B2_QEMPPRE") of oDlg PIXEL SIZE 070,009 When .F.

			_nEstSeg  := POSICIONE("SB1", 1, xFilial("SB1") + cProduto, "B1_ESTSEG")
			_cXSEGURI := IIf(POSICIONE("SB1", 1, xFilial("SB1") + cProduto, "B1_XSEGURI") = "1", "SOLICITA","NO SOLICITA")
			_cXLIENCI := IIf(POSICIONE("SB1", 1, xFilial("SB1") + cProduto, "B1_XLIENCI") = "1", "AUTOMATICA", "NO AUTOMATICA")
			_cXPREMES := POSICIONE("SB1", 1, xFilial("SB1") + cProduto, "B1_XPREMES")
			
			@ 225,007 SAY RetTitle("B1_ESTSEG") of oDlg PIXEL
			@ 224,075 MsGet _nEstSeg Picture PesqPict("SB1","B1_ESTSEG") of oDlg PIXEL SIZE 070,009 When .F.

			@ 225,155 SAY RetTitle("B2_SALPEDI") of oDlg PIXEL
			@ 224,223 MsGet nQEmpPre Picture PesqPict("SB2","B2_QEMPPRE") of oDlg PIXEL SIZE 070,009 When .F.


			@ 240,007 SAY RetTitle("B1_XSEGURI") of oDlg PIXEL
			@ 239,075 MsGet _cXSEGURI Picture PesqPict("SB1","B1_XSEGURI") of oDlg PIXEL SIZE 070,009 When .F.

			@ 240,155 SAY RetTitle("B1_XLIENCI") of oDlg PIXEL
			@ 239,223 MsGet _cXLIENCI Picture PesqPict("SB2","B1_XLIENCI") of oDlg PIXEL SIZE 070,009 When .F.

			@ 255,007 SAY RetTitle("B1_XPREMES") of oDlg PIXEL
			@ 254,075 MsGet _cXPREMES Picture PesqPict("SB1","B1_XPREMES") of oDlg PIXEL SIZE 070,009 When .F.
			
			
			@ 270,244  BUTTON "Voltar" SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL

			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			Aviso("Atencao","Nao registro de estoques para este produto.",{"Voltar"},2)
		EndIf
	EndIf
	RestArea(aAreaSM0)
	RestArea(aAreaSB2)
	RestArea(aAreaSB1)
	RestArea(aArea)
	SetFocus(nHdl)

Return(.F.)
