#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "RWMake.ch"

/*/Protheus.doc nomeStaticFunction
@(long_description) Inclusao de 4 campos novos no Cabeçalho do Pedido de Compras.
type User Function
@author Steck
@since 26/02/2021
@version 12.1.25
see (links_or_references) https://tdn.totvs.com/display/public/PROT/MT120TEL
/*/

User Function MT120TEL()

	Local oNewDialog  	:= ParamixB[1]
	Local aPosGet     	:= ParamixB[2]
	Local aObj        	:= ParamixB[3]
	Local nOpcx       	:= ParamixB[4]
	Local nReg        	:= ParamixB[5]	//-- Customizações do usuario
	Local cTitulo		:= "Selecione o Contrato de Parceria"
	Local cVar
	Local oDlg
	Local oChk
	Local oLbx
	Local lChk 			:= .F.
	Local lMark 		:= .F.
	Local aVetor 		:= {}
	Local oLocaliz
	Local cLocaliz 		:= Space(06)
	Private oOk			:= LoadBitmap(GetResources(),"LBOK")
	Private oNo			:= LoadBitmap(GetResources(),"LBNO")
	Private nClrC23		:= RGB(238,185,162) // Cinza Avermelhado Claro
	Public _cMail	 	:= Iif(nOpcx == 3,CriaVar("C7_XEMAIL"),SC7->C7_XEMAIL  )
	Public _oMail
	Public  cNumCP		:= Space(06)
	//ExecBlock("MT120TEL",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nReg} )
	If Alltrim(FunName()) == "MATA122"
		dbSelectArea("SC3")
		dbSetOrder(1)
		cFilSC3 := xFilial("SC3")
		dbSeek(cFilSC3)
		// Carrega o vetor conforme a condicao.
		While SC3->( !Eof() ) .And. SC3->C3_FILIAL == cFilSC3
			If Empty(SC3->C3_ENCER)
				//	               01,          02,              03,                                                                              04,           05,           06
				//		             ,      Nro CP,      Fornecedor,         												        Desc. Fornecedor,         Loja,   Cond Pagto 
				aAdd( aVetor, { lMark, SC3->C3_NUM, SC3->C3_FORNECE, Posicione("SA2", 1, xFilial("SA2") + SC3->C3_FORNECE + SC3->C3_LOJA, "A2_NOME"), SC3->C3_LOJA, SC3->C3_COND } )
			EndIf
			dbSkip()
		End
		// Tela de Markbrowse para selecionar o Contrato de Parceira e alimentar os campos do cabeçalho da AE
		oDlg := MsDialog():New( 000,000,415,693,cTitulo,,,.F.,,,CLR_YELLOW,,,.T.,,,.T. )
		@010,010 ListBox oLbx Var cVar Fields Header " ", "Num CP", "Desc. Fornecedor", "Fornecedor", "Loja", "Cond. Pagto" Size 330,180 Of oDlg Pixel On dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
		oLbx:SetArray(aVetor)
		oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo),;	// Marca e Desmarca
								aVetor[oLbx:nAt,2],;			// Numero do Contrato de Parceria
								aVetor[oLbx:nAt,3],;			// Fornecedor
								aVetor[oLbx:nAt,4],;			// Desc. do Fornecedor
								aVetor[oLbx:nAt,5],;			// Loja
								aVetor[oLbx:nAt,6]}}			// Condicao de Pagamento
		If oChk <> Nil
			@245,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 Pixel Of oDlg On Click(Iif(lChk,Marca(lChk,aVetor),Marca(lChk,aVetor)))
		EndIf
		@193,010 MSGET oLocaliz VAR cLocaliz SIZE 040, 009 Of oDlg COLORS 0, 16777215 PIXEL
		oBtnPesq := TButton():New( 193, 060,"Localizar",oDlg,{||MsgRun("Localizando Contrato, aguarde...",,{||LocRegs(@aVetor,@oLbx,@cLocaliz)})},050,011,,,,.T.,,"",,,,.F. )
		oBtnPesq:SetCss(SetCssImg("","Danger"))
		oBtnPesq := TButton():New( 193, 290,"Confirmar",oDlg,{||MsgRun("Selecionando dados, aguarde...",,{||CarregC7(@aVetor,oNewDialog,aPosGet),oDlg:End()})},050,011,,,,.T.,,"",,,,.F. )
		oBtnPesq:SetCss(SetCssImg("","Primary"))
		oDlg:Activate(,,,.T.)
	Else
		If cEmpAnt == "01"
			Public _cMesMrp   := Iif(Inclui,Space(15),SC7->C7_XMESMRP)
			Public _cAnoMrp   := Iif(Inclui,Space(15),SC7->C7_XANOMRP)
			// Campo Mês MRP
			@ 062,aPosGet[2,5]+20 SAY "Mês MRP" OF oNewDialog PIXEL SIZE 060,006
			@ 061,aPosGet[2,6]-25 ComboBox _cMesMrp ITEMS {'              ','01=Janeiro','02=Fevereiro','03=Marco','04=Abril','05=Maio','06=Junho','07=Julho','08=Agosto','09=Setembro','10=Outubro','11=Novembro','12=Dezembro'    } when ((Inclui .or. Empty(Alltrim(_cMesMrp))) .And. Alltrim(CA120FORN) = '005866') OF oNewDialog PIXEL SIZE 045,006
			// Campo Ano MRP
			@ 074,aPosGet[2,5]+20 SAY "Ano MRP" OF oNewDialog PIXEL SIZE 060,006
			@ 073,aPosGet[2,6]-25 ComboBox _cAnoMrp ITEMS {'    ','2019','2020','2021','2022','2023'} When ((Inclui .or. Empty(Alltrim(_cAnoMrp))) .And. Alltrim(CA120FORN) = '005866') OF oNewDialog PIXEL SIZE 045,006		
		EndIf
		// Campo E-mail
		@ 074,aPosGet[2,3] SAY "Email" OF oNewDialog PIXEL SIZE 060,006
		@ 073,aPosGet[2,4] MSGET _oMail VAR _cMail   PIXEL SIZE 150, 010 OF oNewDialog
		// Campo Numero do Contrato de Parceria
		@ 074,aPosGet[1,1] SAY "Num CP" OF oNewDialog PIXEL SIZE 060,006
		@ 073,aPosGet[1,2] MSGET cNumCP F3 "SC3" PIXEL SIZE 060, 010 When .F. OF oNewDialog
	EndIf

Return .T.

/*/Protheus.doc LocRegs
(long_description) Localiza o contrato
type Static Function
@author Eduardo Pereira - Sigamat
@since 12/03/2021
@version 12.1.25
/*/

Static Function LocRegs(aVetor, oLbx, cConteud)

Local nPos := 0

If Empty(cConteud)
	apMsgInfo("Para localizar precisa informar o Contrato","Atenção")
	Return
EndIf

nPos := aScan(aVetor, { |x| Alltrim(x[2]) == Alltrim(cConteud)} )

If nPos > 0
	oLbx:nAT := nPos
	oLbx:SetArray(aVetor)
	oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6] }}
Else
	apMsgInfo("Contrato não encontrado","Atenção")
EndIf

oLbx:SetFocus()
oLbx:Refresh()

Return

/*/Protheus.doc CarregC7
(long_description) Carrego os campos do cabeçalho da A.E
type Static Function
@author Eduardo Pereira - Sigamat
@since 10/03/2021
@version 12.1.25
/*/

Static Function CarregC7(aVetor,oNewDialog,aPosGet)

Local nA

If cEmpAnt == "01"
	Public _cMesMrp   := Iif(Inclui,Space(15),SC7->C7_XMESMRP)
	Public _cAnoMrp   := Iif(Inclui,Space(15),SC7->C7_XANOMRP)
	// Campo Mês MRP
	@ 062,aPosGet[2,5]+20 SAY "Mês MRP" OF oNewDialog PIXEL SIZE 060,006
	@ 061,aPosGet[2,6]-25 ComboBox _cMesMrp ITEMS {'              ','01=Janeiro','02=Fevereiro','03=Marco','04=Abril','05=Maio','06=Junho','07=Julho','08=Agosto','09=Setembro','10=Outubro','11=Novembro','12=Dezembro'    } when ((Inclui .or. Empty(Alltrim(_cMesMrp))) .And. Alltrim(CA120FORN) = '005866') OF oNewDialog PIXEL SIZE 045,006
	// Campo Ano MRP
	@ 074,aPosGet[2,5]+20 SAY "Ano MRP" OF oNewDialog PIXEL SIZE 060,006
	@ 073,aPosGet[2,6]-25 ComboBox _cAnoMrp ITEMS {'    ','2019','2020','2021','2022','2023'} when ((Inclui .or. Empty(Alltrim(_cAnoMrp))) .And. Alltrim(CA120FORN) = '005866') OF oNewDialog PIXEL SIZE 045,006
EndIf
// Campo E-mail
@ 074,aPosGet[2,3] SAY "Email" OF oNewDialog PIXEL SIZE 060,006
@ 073,aPosGet[2,4] MSGET _oMail VAR _cMail   PIXEL SIZE 150, 010 OF oNewDialog
// Campo Numero do Contrato de Parceria
@ 074,aPosGet[1,1] SAY "Num CP" OF oNewDialog PIXEL SIZE 060,006
@ 073,aPosGet[1,2] MSGET cNumCP PIXEL SIZE 060, 010 When .F. OF oNewDialog
For nA := 1 to Len(aVetor)
	If aVetor[nA,1] == .T.
		cNumCP		:= aVetor[nA,2]
		cA120Forn	:= aVetor[nA,3]
		cA120Loj	:= aVetor[nA,5]
		cCondicao	:= aVetor[nA,6]
	EndIf
Next nA

Return

/*/Protheus.doc SetCssImg
@(long_description) Funcao para setar CSS e Imagem nos Botoes
@type Function SetCssImg
@author Eduardo Silva
@since 27/10/2020
@version 12.1.25
/*/

Static Function SetCssImg(cImg,cTipo)

Local cCssRet	:= ""
Default cImg	:= "rpo:yoko_sair.png"
Default cTipo	:= "Botao Branco"
If cTipo == "Primary"  
	cCssRet := "QPushButton {"  
	cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
	cCssRet += "}"
EndIf
If cTipo == "Danger"  
	cCssRet := "QPushButton {"  
	cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
	cCssRet += "}"
EndIf

Return cCssRet
