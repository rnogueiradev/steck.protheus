/****************************************
Ação.........: Rotina para alteração de Data de Entrega no P.O.
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 27/05/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK21()
	Local nTop    := 0
	Local nLeft   := 0
	Local nBottom := 0
	Local nRight  := 0
	Local aSize   := {}
	Local aObjects:= 0
	Local oBtFiltrar
	Local oBtProcessa
	Local oBtSair
	Local oGFornece
	Local oGEntrega
	Local oGetFornece
	Local oGetEmis1
	Local oGetEmis2
	Local oGetNumPO
	Local oGetEnt11
	Local oGetEnt12
	Local oGetEnt21
	Local oGetEnt22
	Local oGetProduto
	Local oGNumPO
	Local oGProduto
	Local oSFornece
	Local oSEmissao
	Local oSEnt1
	Local oSEnt2
	Local oSNumPO
	Local oSSeqItem
	Local oGetSeqItem
	Local nLinAj    := 0
	Local aCabec    := {"","","Número P.O.","No. da S.I.","Posição","Código Item","Descrição","Dt. Emissão","Dt. Entrega","Dt. Entrega 2"}
	Local aTamCol   := {20,20,40,40,30,60,180,50,50}
	Local aFields	:= {"W3_PO_NUM","W3_SI_NUM","W3_POSICAO","W3_COD_I","B1_DESC","W2_PO_DT","W3_DT_ENTR","W3_XDTENT2" }
	PRIVATE oListPedidos
	PRIVATE oDlgConsCons
	PRIVATE cCadastro 	:= OemToAnsi("Manutenção de P.O. - Entrega 2")
	PRIVATE oOk	        := LoadBitmap(GetResources(), "LBOK")
	PRIVATE oNo	        := LoadBitmap(GetResources(), "LBNO")
	PRIVATE oVerde      := LoadBitmap(GetResources(), "br_verde")
	PRIVATE oAmarelo    := LoadBitmap(GetResources(), "br_amarelo")
	PRIVATE oVermelho   := LoadBitmap(GetResources(), "BR_VERMELHO")
	PRIVATE oMarrom     := LoadBitmap(GetResources(), "BR_MARROM")
	PRIVATE oLaranja    := LoadBitmap(GetResources(), "BR_LARANJA")
	PRIVATE oAzul       := LoadBitmap(GetResources(), "BR_AZUL")
	PRIVATE oPreto      := LoadBitmap(GetResources(), "BR_PRETO")
	PRIVATE oBranco     := LoadBitmap(GetResources(), "BR_BRANCO")
	PRIVATE aTMP        := {}
	PRIVATE oPanelEsq
	PRIVATE oPanelDIR
	PRIVATE oPanelINFERIOR
	PRIVATE cCBStatus    := Space(50)
	PRIVATE cGetFornece  := CriaVar("A2_COD",.F.)
	PRIVATE cGetLoja     := CriaVar("G2_RECURSO",.F.)      // ALTERADO 20/10/2020
	PRIVATE dGetEmiss1   := FirstDate(dDatabase-90)
	PRIVATE dGetEmiss2   := dDatabase
	PRIVATE dGetEnt11    := STOD("")
	PRIVATE dGetEnt12    := STOD("")
	PRIVATE dGetEnt21    := STOD("")
	PRIVATE dGetEnt22    := STOD("")
	PRIVATE cGetNumPO    := CriaVar("W3_SI_NUM",.F.)
	PRIVATE cGetProduto  := CriaVar("W3_COD_I",.F.)
	PRIVATE cGetSeqItem  := CriaVar("W3_POSICAO",.F.)
	PRIVATE bFiltrar     := {|| CURSORWAIT(), /*(FilRun()*/, CarregaPO(oListPedidos), CURSORARROW()}
	PRIVATE dDtEntEdit   := CTOD("")
	PRIVATE aHeader      := getHeader(aFields)
	PRIVATE nPosEnt1     := aScan(aCabec, {|X| alltrim(X)=="Dt. Entrega"})
	PRIVATE nPosEnt2     := aScan(aCabec, {|X| alltrim(X)=="Dt. Entrega 2"})
	PRIVATE cGetGrProd   := CriaVar("B1_GRUPO")
	PRIVATE oComboAlt
	PRIVATE nComboAlt := 1
	PRIVATE aMotAlt := {"        ","Atraso do Embarque","Aguard. Disp. Fornecedor","Aguard. Confirmação Booking"}
  PRIVATE aVetSC7 := {}

	aSize := MSADVSIZE()

	oMainWnd:ReadClientCoors() // atualiza as coordernadas

	IF  FlatMode()
		nTop    := 40
		nLeft   := 0
		nBottom := oMainWnd:nBottom + 30
		nRight  := oMainWnd:nRight  + 450
	Else
		nTop    := oMainWnd:nTop    + 105   // 125
		nLeft   := oMainWnd:nLeft   + 2
		nBottom := oMainWnd:nBottom - 40
		nRight  := oMainWnd:nRight  - 13
	EndIf

	aSize 		:= MsAdvSize(.T.)
	aObjects    := {}
	CSSFUND     := u_GetSetCSS("GROUP",,)
	CSSLIST     := u_GetSetCSS("LISTBOX",,)
	aAdd( aObjects, { 100, 045, .T., .T. } )
	aAdd( aObjects, { 100, 055, .T., .T.,.T. } )

	aInfo  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPObjs := MsObjSize( aInfo, aObjects, .T. )

	aObjects := {}
	AAdd( aObjects, { 100, 100, .T., .T. } )

	aInfo := { aPObjs[2, 1], aPObjs[2, 2], aPObjs[2, 3], aPObjs[2, 4], 0, 0 }
	aPGDs := MsObjSize( aInfo, aObjects, .T. )

	aHeader := getHeader(aFields)

	//Define MsDialog oDlgCons FROM nTop, nLeft To nBottom*0.8,nRight*0.7 TITLE OemToAnsi(cCadastro) Pixel style DS_MODALFRAME    // STYLE nOR( WS_VISIBLE, WS_POPUP )
	Define MsDialog oDlgCons FROM nTop, nLeft To nBottom*0.8,nRight*0.6 TITLE OemToAnsi(cCadastro) Pixel style DS_MODALFRAME    // STYLE nOR( WS_VISIBLE, WS_POPUP )
	MntTela(oDlgCons)

	nLinAj    := 2

	@ 008, 005 GROUP oGFornece TO 065, 097 PROMPT "[ Cliente ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215  PIXEL
	@ 015, 012 SAY oSFornece PROMPT "Cod.Fornecedor" SIZE 040, 007 OF oGFornece COLORS 0, 16777215 PIXEL
	@ 023, 012 MSGET oGetFornece VAR cGetFornece  SIZE 060, 010 OF oGFornece VALID VldCliente() COLORS 0, 16777215 F3 "SA1" PIXEL

	@ 008, 100 GROUP oGProduto TO 065, 180 PROMPT "[ Produto ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 015, 110 SAY oSProduto PROMPT "Cod.Produto" SIZE 030, 007 OF oGFornece COLORS 0, 16777215 PIXEL
	@ 023, 110 MSGET oGetProduto VAR cGetProduto  SIZE 060, 010 OF oGProduto VALID VldProd() COLORS 0, 16777215 F3 "SB1" PIXEL
	@ 039, 110 SAY oSGrProd PROMPT "Grupo Prod"   SIZE 030, 007 OF oGFornece COLORS 0, 16777215 PIXEL
	@ 047, 110 MSGET oGetProduto VAR cGetGrProd   SIZE 060, 010 OF oGProduto COLORS 0, 16777215 F3 "SBM" PIXEL

	nLinAj += 23
	@ 043+nLinAj, 005 GROUP oGNumPO TO 097+nLinAj, 180 PROMPT "[ Número do P.O. ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 052+nLinAj, 008 SAY oSNumPO PROMPT "Numero"         SIZE 025, 007 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 008 MSGET oGetNumPO VAR cGetNumPO      SIZE 060, 010 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 052+nLinAj, 070 SAY oSEmissao PROMPT "Emissão De"    SIZE 035, 007 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 070 MSGET oGetEmis1   VAR dGetEmiss1     SIZE 048, 010 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 052+nLinAj, 120 SAY oSEmissao PROMPT "Emissão Ate"   SIZE 035, 007 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 120 MSGET oGetEmis2   VAR dGetEmiss2     SIZE 048, 010 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 073+nLinAj, 008 SAY oSSeqItem PROMPT "Seq.Item"      SIZE 025, 007 OF oGNumPO COLORS 0, 16777215 PIXEL
	@ 081+nLinAj, 008 MSGET oGetSeqItem VAR cGetSeqItem    SIZE 020, 010 OF oGNumPO COLORS 0, 16777215 PIXEL

	nLinAj += 3
	@ 099+nLinAj, 005 GROUP oGEntrega TO 140+nLinAj, 180 PROMPT "[ Entrega ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 109+nLinAj, 030 SAY   oSEnt1 PROMPT "1 - "     SIZE 009, 007 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 108+nLinAj, 038 MSGET oGetEnt11 VAR dGetEnt11  SIZE 048, 010 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 109+nLinAj, 091 SAY   oSEnt2 PROMPT "Até"      SIZE 009, 007 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 108+nLinAj, 108 MSGET oGetEnt12 VAR dGetEnt12  SIZE 048, 010 OF oGEntrega COLORS 0, 16777215 PIXEL

	@ 124+nLinAj, 030 SAY   oSEnt1 PROMPT "2 - "     SIZE 009, 007 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 122+nLinAj, 038 MSGET oGetEnt21 VAR dGetEnt21  SIZE 048, 010 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 124+nLinAj, 091 SAY   oSEnt2 PROMPT "Até"      SIZE 009, 007 OF oGEntrega COLORS 0, 16777215 PIXEL
	@ 122+nLinAj, 108 MSGET oGetEnt22 VAR dGetEnt22  SIZE 048, 010 OF oGEntrega COLORS 0, 16777215 PIXEL

	ajCol := 10
	@ 150+nLinAj, 005 GROUP oGMotivo TO 175+nLinAj, 180 PROMPT "[ Motivo da Alteração ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
  @ 160+nLinAj, 008 MSCOMBOBOX oComboAlt VAR nComboAlt ITEMS aMotAlt SIZE 121, 010 OF oGMotivo COLORS 0, 16777215 PIXEL

	@ 190+nLinAj, 005 GROUP oGAcoes TO 230+nLinAj, 180 PROMPT "[ Ações ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 200+nLinAj, 016 BUTTON oBtFiltrar    PROMPT "Filtrar"     SIZE 038, 025 OF oPanelDIR ACTION (Filtrar(),CarregaPO(oListPedidos))   PIXEL
	@ 200+nLinAj, 056 BUTTON oBtProcessa   PROMPT "Processar"   SIZE 038, 025 OF oGAcoes   ACTION (Processar()) PIXEL
	@ 200+nLinAj, 096 BUTTON oBtExpor      PROMPT "Exportar"    SIZE 038, 025 OF oGAcoes   ACTION ExpExcel(aCabec, aTMP)  PIXEL
	@ 200+nLinAj, 136 BUTTON oBtSair       PROMPT "Sair"        SIZE 038, 025 OF oGAcoes   ACTION oDlgCons:End()  PIXEL

	lRet := .T.

	oListPedidos       := TWBrowse():New(0, 0, 0, 0,, aCabec, aTamCol, oPanelEsq)
	oListPedidos:Align := CONTROL_ALIGN_ALLCLIENT
	CarregaPO(oListPedidos)
	IF lRet
		oListPedidos:blDblClick   := {|| if( oListPedidos:ColPos==1, aTMP[oListPedidos:nAt, 1] := !aTMP[oListPedidos:nAt, 1], If(oListPedidos:ColPos > 1, ExecFun(oListPedidos:ColPos, oListPedidos),nil)), oListPedidos:DrawSelect(), oListPedidos:Refresh()}

		oListPedidos:bHeaderClick := { |o,nCol| nColuna := nCol, if(nCol==1, aEval(aTMP, {|X| X[nColuna] := If(!X[nColuna], .T., .F.)  }) ,nil), if(aTMP[1,1],InputEnt(oListPedidos),nil), oListPedidos:Refresh() }
	Endif
	oListPedidos:nAt  := 1
	oListPedidos:ACOLSIZES[5] := 25
	oListPedidos:ACOLSIZES[3] := 25
	oListPedidos:ACOLSIZES[4] := 25
	oListPedidos:ACOLSIZES[5] := 25
	oListPedidos:ACOLSIZES[6] := 40
	oListPedidos:ACOLSIZES[7] := 100
	oBtFiltrar:SetCSS( SetCssImg("", "Primary") )  // CSSBOTAO
	oBtProcessa:SetCSS( SetCssImg("", "Success") )
	oBTExpor:SetCSS( SetCssImg("", "Warning") )
	oBtSair:SetCSS( SetCssImg(, "Danger") )
	oBtFiltrar:cToolTip  := "Filtra registro com base nos dados informados"
	oBtProcessa:cToolTip := "Inicia processamento dos itens selecionados"
	oBTExpor:cToolTip    := "Exporta dados para planilha excel"
	oBtSair:cToolTip     := "Sai da tela"

	ACTIVATE MSDIALOG oDlgCons CENTER

RETURN 


/*/{Protheus.doc} MntTela SetCssImg(cImg, cTipo)
description
   Monta tela primaria
@type function
@version 
@author Valdemir Jose
@since 24/06/2020
@param poDlgCons, param_type, param_description
@RETURN RETURN_type, RETURN_description
/*/
Static Function MntTela(poDlgCons)

	oLayer := FWLayer():New()

	oLayer:Init(poDlgCons, .f.)
	oLayer:addLine("TOP",100,.F.)

	oLayer:addCollumn("COL_TOP1",70,.f.,"TOP")
	oLayer:addCollumn("COL_TOP2",30,.f.,"TOP")

	oLayer:AddWindow( "COL_TOP1", "WinTOP",     "Seleção", 100, .T., .F.,/*bAction*/,"TOP",/*bGotFocus*/)
	oLayer:AddWindow( "COL_TOP2", "WinCENTRO",  "Filtro",  100, .T., .F.,/*bAction*/,"TOP",/*bGotFocus*/)

	oPanelEsq := oLayer:GetWinPanel('COL_TOP1','WinTOP',"TOP" )
	oPanelDIR := oLayer:GetWinPanel('COL_TOP2','WinCENTRO',"TOP" )

RETURN


Static Function VldCliente()

RETURN .T.

Static Function VldProd()

RETURN .T.



Static Function SetCssImg(cImg, cTipo)

	Local cCssRet := ""
	Default cImg := "rpo:yoko_sair.png"
	Default cTipo := "Botao Branco"

	IF cTipo == "Success"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#28a745;border-color:#28a745 "
		cCssRet += "}"
	EndIf

	IF cTipo == "Primary"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
		cCssRet += "}"
	EndIf

	IF cTipo == "Danger"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
		cCssRet += "}"
	EndIf

	IF cTipo == "Warning"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#FFD700;border-color:#FFD700 "
		cCssRet += "}"
	EndIf

RETURN cCssRet


/*/{Protheus.doc} Filtrar
description
Rotina executada pelo botão
@type function
@version 
@author Valdemir Jose
@since 25/06/2020
@RETURN RETURN_type, RETURN_description
/*/
Static Function Filtrar()
	Local lConf := (!Empty(cGetFornece) .or. !Empty(cGetProduto) .or. !Empty(cGetNumPO) .or.;
		!Empty(dTos(dGetEmiss1)) .or. !Empty(dtos(dGetEmiss2)) .or. !Empty(cGetSeqItem) .or.;
		!Empty(cGetPedCom) .or. !Empty(dtos(dGetEnt11)) .or. !Empty(dtos(dGetEnt12)) .or. ;
		!Empty(dtos(dGetEnt21)) .or. !Empty(dtos(dGetEnt22)) )

	IF !lConf
		lConf := MsgNoYes("Não foi informado nenhum campo no filtro, isto poderá¡ levar" + CRLF+;
			"um tempo maior no carregamento. Deseja continuar mesmo assim?","Atenção")
	Endif
	IF lConf
		FwMsgRun(, bFiltrar, "Aguarde","Carregando os dados")
	endif
RETURN



/*/{Protheus.doc} CLICKALT
   description
   Rotina que permitirÃ¡ editar a data de entrega 2
   @type function
   @version 
   @author Valdemir Jose
   @since 25/06/2020
   @param aWBrowse1, array, param_description
   @param oWBrowse1, object, param_description
   @RETURN RETURN_type, RETURN_description
/*/
Static Function CLICKALT(aWBrowse1,oWBrowse1)
	Local lOK := .T.
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xFilial('SB1')+aWBrowse1[oWBrowse1:nAT,5]) )

	SetKey(VK_F4,{|| MaViewSB2(SB1->B1_COD) })

	IF (oWBrowse1:COLPOS == nPosEnt2)
		//IF  !(aWBrowse1[oWBrowse1:nAT,2] $ "4/7")
			lEditCell( @aWBrowse1, oWBrowse1, "@D 99/99/9999", oWBrowse1:COLPOS )
			// Verifico se foi informado uma data menor que a entrega1
			lOK := (!(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] < aWBrowse1[oWBrowse1:nAT,nPosEnt1])) .or. Empty(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS]) .or. (!aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] < dDatabase)
			IF lOK
				aWBrowse1[oWBrowse1:nAT][1] := !Empty(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS])
			else
				FWMsgRun(,{|| sleep(3000)},'Atenção!','A data entrega-2, não pode ser retroativa. Por favor, verifique.')
				aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] := ctod("")
			endif
		//else
		//	FWMsgRun(,{|| sleep(3000)},"Atenção","Esta situação do registro não permite alterar data de entrega.")
		//endif
	ELSE
		FWMsgRun(,{|| sleep(3000)},"Atenção","Coluna selecionada não editavel...")
	ENDIF

	SetKey(VK_F4,{|| Nil })

	oWBrowse1:Refresh()
RETURN

/*/{Protheus.doc} InputEnt
   description
   Rotina para ser informado a nova data de entrega
   @type function
   @version 
   @author Valdemir Jose
   @since 26/06/2020
   @param oObjList, object, param_description
   @RETURN RETURN_type, RETURN_description
/*/
Static Function InputEnt(oObjList)
	Local oBTOk
	Local oGetData
	Local oGRData
	Local nX   := 0
	Local nOPC := 0
	Static oDlgData

	dDtEntEdit := ctod(" /  /  ")

	DEFINE MSDIALOG oDlgData TITLE "Informe" FROM 000, 000  TO 150, 240 COLORS 0, 16777215 PIXEL style DS_MODALFRAME

	@ 011, 015 GROUP oGRData TO 041, 107 PROMPT "[ Nova Data ]" OF oDlgData COLOR 0, 16777215 PIXEL
	@ 022, 030 MSGET oGetData VAR dDtEntEdit SIZE 060, 010 OF oDlgData COLORS 0, 16777215 PIXEL
	@ 048, 045 BUTTON oBTOk PROMPT "OK" SIZE 037, 012 OF oDlgData ACTION (nOPC :=1,oDlgData:End()) PIXEL
	oGRData:SetCSS( CSSFUND )
	oBTOk:SetCSS( SetCssImg("", "Primary") )
	ACTIVATE MSDIALOG oDlgData CENTERED

	IF nOPC==1
		IF !Empty(dtos(dDtEntEdit))
			For nX := 1 to Len(aTMP)
				IF dDtEntEdit > aTMP[nX][nPosEnt1]
					aTMP[nX][nPosEnt2] := dDtEntEdit
				Else
					aTMP[nX][1] := .F.
				Endif
			Next
		else
			aEval(aTMP, {|X| X[nColuna] := .F.})
		Endif
		oObjList:Refresh()

	Endif

RETURN

/*/{Protheus.doc} GetStatus
description
  Rotina para apresentação de status visual
@type function
@version 
@author Valdemir Jose
@since 26/06/2020
@param pStatus, param_type, param_description
@RETURN RETURN_type, RETURN_description
/*/
Static Function GetStatus(pStatus)
	Local oRetObJ := ""
	LOCAL pStatus := "2"

	IF pStatus=="2"
		oRetObj := "br_verde"
	elseIF pStatus=="3"
		oRetObj := "br_amarelo"
	elseIF pStatus == "4"
		oRetObj := "br_vermelho"
	elseIF pStatus == "5"
		oRetObj := "br_branco"
	elseIF pStatus == "6"
		oRetObj := "br_marrom"
	elseIF pStatus == "7"
		oRetObj := "br_laranja"
	elseIF pStatus == "8"
		oRetObj := "br_azul"
	elseIF pStatus == "9"
		oRetObj := "br_preto"
	endif

RETURN LoadBitmap(GetResources(), oRetObj)

/*/{Protheus.doc} Legenda
description
  Rotina de apresentação de legendas
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@RETURN RETURN_type, RETURN_description
/*/
Static Function Legenda()
	Local aCor := {}
	aCor := {{"BR_VERDE","PV em Aberto"},;     			            //OK - Pedido em aberto
	{"BR_AMARELO","PV Liberado"},;             			//OK - Pedido de Venda Liberado
	{"BR_VERMELHO","PV Faturado Totalmente"},;	         	//OK - Pedido de Venda Faturado Totalmente
	{"BR_BRANCO","PV Faturado Parcialmente"},;	           	//OK - Pedido de Venda Faturado Parcialmente
	{"BR_MARRON","PV Cancelado"},;	           				//OK - Pedido de Venda Cancelado
	{"BR_LARANJA","PV Eliminado por ResÃ­duo (Saldo)"},;	//OK - Pedido de Venda Eliminado por ResÃ­duo (Saldo)
	{"BR_AZUL","PV Rejeitado pelo Financeiro"},;           //OK - Pedido de Venda Rejeitado pelo Financeiro
	{"BR_PRETO","PV Bloqueado por Regras Comerciais"}}     //OK - Pedido de Venda Bloqueado por Regras Comerciais
	BrwLegenda(cCadastro,"Legenda",aCor)
RETURN




/*/{Protheus.doc} ExecFun
description
   Rotina que irÃ¡ alterar dados da celula
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param pnCol, param_type, param_description
@param oListPedidos, object, param_description
@RETURN RETURN_type, RETURN_description
/*/
Static Function ExecFun(pnCol,oListPedidos)
	IF pnCol == 2
		Legenda()
	elseIF pnCol == nPosEnt2
		CLICKALT(aTMP,oListPedidos)
	else
		FWMsgRun(,{|| sleep(3000)},"Atenção","Coluna selecionada não editavel...")
	Endif
RETURN

/*/{Protheus.doc} Processar
description
   Rotina para chamada de processamento
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@RETURN RETURN_type, RETURN_description
/*/
Static Function Processar()
	Local nSel := 0

	IF Len(aTMP)==0
		FWMsgRun(,{|| Sleep(4000)},'Informação',"Não existe registros carregado na tela")
		RETURN
	Endif
	aEval(aTMP, {|X| if(X[1], nSel++,nil) })

	IF (nSel == 0)
		FWMsgRun(,{|| Sleep(4000)},'Informação',"Não foi selecionado nenhum registro para processar.")
		RETURN
	Endif

	IF oComboAlt:Nat = 1	
		MSGALERT("Informe o motivo da Alteração.")
		RETURN
	ENDIF

	Processa( {|| ProcesReg()}, "Aguarde...")

RETURN

/*/{Protheus.doc} ProcesReg
description
   Rotina para processar registros tabela SC6
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@RETURN RETURN_type, RETURN_description
/*/
Static Function ProcesReg()
	Local nX     := 0
  LOCAL nSaldo := 0

	For nX := 1 to Len(aTMP)
		INCPROC("")

		IF aTMP[nX,1] = .T.
      SW3->(DBSETORDER(8))
      IF SW3->(DBSEEK(XFILIAL("SW3")+aTmp[nX,3]+aTmp[nX,5]))
        WHILE SW3->(!EOF()) .AND. ALLTRIM(SW3->W3_PO_NUM) = ALLTRIM(aTmp[nX,3]) .AND. ALLTRIM(SW3->W3_POSICAO) = ALLTRIM(aTmp[nX,5])

          /*************************************
          Atualiza a tabela Z97 de LOG de alteração
          *************************************/
          DBSELECTAREA("Z97")
          RECLOCK("Z97",.T.)
          Z97->Z97_FILIAL := XFILIAL("Z97")
          Z97->Z97_CODEMP := cEmpAnt+cFilAnt
          Z97->Z97_TIPREG := "PO"
          Z97->Z97_CODFOR := SW3->W3_FORN
          Z97->Z97_LOJAFO := SW3->W3_FORLOJ
          Z97->Z97_DATALT := DATE()
          Z97->Z97_NUMPVI := SW3->W3_PO_NUM
          Z97->Z97_ITEPVI := SW3->W3_POSICAO
          Z97->Z97_CODPRO := aTmp[nX,6]
          Z97->Z97_DATANT := SW3->W3_DT_ENTR
          Z97->Z97_DATNEW := aTmp[nX,nPosEnt2]
          Z97->Z97_MOTIVO := aMotAlt[oComboAlt:NAT]
          Z97->Z97_CODUSR := __cUserId
          Z97->(MSUNLOCK())

          RECLOCK("SW3", .F.)
          SW3->W3_XDTENT2 := aTmp[nX,nPosEnt2]
          SW3->(MSUNLOCK())

          SC7->(DBSETORDER(1))
          IF SC7->(DBSEEK(XFILIAL("SC7")+ALLTRIM(SW3->W3_PO_NUM)+ALLTRIM(SW3->W3_POSICAO)))
            RECLOCK("SC7",.F.)
            SC7->C7_XDTENT2 := aTmp[nX,nPosEnt2]
            SC7->(MSUNLOCK())
            AADD(aVetSC7,{SC7->(RECNO()),"0101","PO"})
          ENDIF
          SW3->(DBSKIP())
        ENDDO
      ENDIF
    ENDIF
	NEXT

	//aTMP := {}
	///FWMsgRun(,{|| AADD(aTMP,{.F.,,"","","","","",STOD(""),STOD(""),STOD("")}), Sleep(4000)},"Informativo","Registro Processado com Sucesso.")
	FWMsgRun(,{||Sleep(4000)},"Informativo","Registro Processado com Sucesso.")

  /******************************
  Baseado nos RECNOS da tabela SC7 iremos alimentar a tabela Z96 e os pedidos de Venda amarrados na PA1
  ******************************/
  FOR nX := 1 TO LEN(aVetSC7)

    SC7->(DBSETORDER(1))
    SC7->(DBGOTO(aVetSC7[nX,1]))

    //// Variável para controlar o saldo 
    nSaldo := SC7->C7_QUANT
    
    cQuery := "SELECT PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "
    cQuery += "INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_NUM = SUBSTR(PA1.PA1_DOC,1,6) "
    cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_TIPO = '1' AND PA1.PA1_SALDO > 0 "
    cQuery += "AND PA1.PA1_CODPRO = '"+SC7->C7_PRODUTO+"' "
    cQuery += "ORDER BY C5.C5_EMISSAO "
    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
    WHILE TPA1->(!EOF()) .AND. nSaldo > 0 

      //// Posiciona na tabela PA1 para atualizar o saldo 
      PA1->(DBSETORDER(1))
      PA1->(DBGOTO(TPA1->PA1REC))

      /********************************
      Busca o saldo a reservar no PA1
      Verifica se a variável nSaldo descontando o saldo da PA1 ficará negativa.
      Neste caso a variável nSaldo é zerada e somente será consumido a diferença entre o PA1_SALDO 
      ********************************/
      //// Quando o Saldo na PA1 for maior que o saldo restante 
      nSalRev := 0
      IF PA1->PA1_SALDO >= nSaldo
        nSalRev := PA1->PA1_SALDO - nSaldo
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := nSalrev
        PA1->(MSUNLOCK())
        nSaldo := 0 
      ELSE
        //// Quando a variável nSaldo for maior que o saldo da PA1 Zera o saldo na PA1
        IF nSaldo > PA1->PA1_SALDO
          nSalRev := PA1->PA1_SALDO
          nSaldo  := (nSaldo - PA1->PA1_SALDO)
          RECLOCK("PA1",.F.)
          PA1->PA1_SALDO := 0
          PA1->(MSUNLOCK())
        ENDIF
      ENDIF 

      /**************************
      Atualiza a tabela de integração 
      **************************/
      RECLOCK("Z96",.T.)
      Z96->Z96_FILIAL  := XFILIAL("Z96")
      Z96->Z96_PA1DOC  := PA1->PA1_DOC
      Z96->Z96_PROD    := SC7->C7_PRODUTO
      Z96->Z96_PEDCOM  := SC7->C7_NUM
      Z96->Z96_ITECOM  := SC7->C7_ITEM
      //Z96->Z96_PVIND   := aVetSC7[i,2]
      //Z96->Z96_ITPVIND := aVetSC7[i,3]
      Z96->Z96_QTDATE  := nSalrev
      Z96->Z96_DTPVIN  := IIf(!Empty(SC7->C7_XDTENT2),SC7->C7_XDTENT2,SC7->C7_DATPRF)
      Z96->Z96_EMPFIL  := aVetSC7[nX,2]
      Z96->Z96_TIPREG  := aVetSC7[nX,3]
      Z96->(MSUNLOCK())

      TPA1->(DBSKIP())
    ENDDO
    TPA1->(DBCLOSEAREA())

     /**************************
     Atualiza domente a Data de Entrega na Z96
		 Esta chamaada é referente a quando o usuário já altgerou uma primeira vez a data de entrega e ai não entra no While acima
     **************************/
     Z96->(DBSETORDER(2))
		 IF Z96->(DBSEEK(XFILIAL("Z96")+SC7->C7_PRODUTO+SC7->C7_NUM+SC7->C7_ITEM))
			WHILE Z96->(!EOF())	.AND. ALLTRIM(Z96->Z96_PROD+Z96->Z96_PEDCOM+Z96->Z96_ITECOM) = ALLTRIM(SC7->C7_PRODUTO+SC7->C7_NUM+SC7->C7_ITEM)
				RECLOCK("Z96",.F.)
				Z96->Z96_FILIAL  := XFILIAL("Z96")
				Z96->Z96_DTPVIN  := IIf(!Empty(SC7->C7_XDTENT2),SC7->C7_XDTENT2,SC7->C7_DATPRF)
				Z96->(MSUNLOCK())
				Z96->(DBSKIP())
			ENDDO
		ENDIF
  NEXT
	CarregaPO()
RETURN

/*/{Protheus.doc} getHeader
description
   Rotina para tratar cabeÃ§alho
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param paFields, param_type, param_description
@RETURN RETURN_type, RETURN_description
/*/
Static Function getHeader(paFields)
	Local aRET   := {}
	Local nX     := 0
	Local aAreaT := GetArea()

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(paFields)
		IF SX3->(DbSeek(paFields[nX]))
			Aadd(aRET, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	RestArea( aAreaT )

RETURN aRET



/*/{Protheus.doc} ExpExcel
description
   Rotina para exportar para excel
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param paCabec, param_type, param_description
@param paTMP, param_type, param_description
@RETURN RETURN_type, RETURN_description
/*/
Static Function ExpExcel(paCabec, paTMP)
	Local aCab   := aClone(paCabec)
	Local aDados := aClone(paTMP)
	Local aTipo  := {"C","C","C","C","N","N","D","D","C","N","C"}

	IF (Len(paTMP) > 0 .OR. Len(paTMP)==1)
		IF Empty(alltrim(paTMP[1][3]))
			FWMsgRun(,{|| sleep(4000)},'Informação','Não existe registros a serem exportado. Por favor, verifique.')
			RETURN
		endif
	endif

	// Preparando arrays
	aEval(aDados, {|X| aDel(x, 1) })
	aEval(aDados, {|X| aDel(x, 1) })
	aEval(aDados, {|X| aDel(x, Len(x)) })
	aEval(aDados, {|X| aSize(X, Len(X)-3)} )

	aDel(aCab, 1)
	aDel(aCab, 1)
	aSize(aCab, Len(aCab)-2)

	//FWMsgRun(, {|| CursorWait(),StaticCall (STFSLIB, ExpotMsExcel, aCab, aDados, aTipo, "MANUTENÇÃO DE PEDIDOS"), CursorArrow() },'Aguarde','Montando planilha')
	FWMsgRun(, {|| CursorWait(), U_ExpotMsExcel(aCab, aDados, aTipo, "MANUTENÇÃO DE PEDIDOS"), CursorArrow() },'Aguarde','Montando planilha')

RETURN

Static Function OKCLICK(aSitua)
	Local nX  := 0
	cCBStatus := ""

	For nX := 1 to Len(aSitua)
		IF aSitua[nX, 1]
			IF !Empty(cCBStatus)
				cCBStatus += ","
			endif
			cCBStatus += aSitua[nX,2]
		Endif
	Next

RETURN

STATIC FUNCTION CarregaPO()

  aTMP := {}
  cQuery := "SELECT W3.W3_PO_NUM,W3_SI_NUM,W3_POSICAO,W3_COD_I,B1_DESC,W2.W2_PO_DT,W3_DT_ENTR,W3_XDTENT2 FROM "+RetSqlName("SW3")+" W3 "
  cQuery += "INNER JOIN "+RetSqlName("SW2")+" W2 ON W2.D_E_L_E_T_ = ' ' AND W2.W2_PO_NUM = W3.W3_PO_NUM "

  cQuery += "INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = W3.W3_COD_I "
  cQuery += "WHERE W3.D_E_L_E_T_ = ' ' "
  IF !EMPTY(cGetNumPO)
    cQuery += "AND W3.W3_PO_NUM = '"+cGetNumPO+"' "
  ENDIF
  IF !EMPTY(cGetFornece)
    cQuery += "AND W3.W3_FORN = '"+cGetFornece+"' "
  ENDIF
  IF !EMPTY(cGetProduto)
    cQuery += "AND W3.W3_COD_I = '"+cGetProduto+"' "
  ENDIF
  IF !EMPTY(dGetEmiss1)
    cQuery += "AND W2.W2_PO_DT >= '"+DTOS(dGetEmiss1)+"' "
  ENDIF
  IF !EMPTY(dGetEmiss2)
    cQuery += "AND W2.W2_PO_DT <= '"+DTOS(dGetEmiss2)+"' "
  ENDIF
  IF !EMPTY(cGetSeqItem)
    cQuery += "AND W3.W3_POSICAO = '"+cGetSeqItem+"' "
  ENDIF
  IF !EMPTY(dGetEnt11)
    cQuery += "AND W3.W3_DT_ENTR >= '"+DTOS(dGetEnt11)+"' "
  ENDIF
  IF !EMPTY(dGetEnt12)
    cQuery += "AND W3.W3_DT_ENTR <= '"+DTOS(dGetEnt12)+"' "
  ENDIF
  IF !EMPTY(dGetEnt21)
  ENDIF
  IF !EMPTY(dGetEnt22)
  ENDIF
  cQuery += "GROUP BY W3_PO_NUM,W3_SI_NUM,W3_POSICAO,W3_COD_I,B1_DESC,W2.W2_PO_DT,W3_DT_ENTR,W3_XDTENT2 "
  cQuery += "ORDER BY W3_PO_NUM,W3_POSICAO "
  cQuery := ChangeQuery(cQuery)
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSW3', .F., .T.)
  WHILE TSW3->(!EOF())
    AADD(aTMP,{.F.,,TSW3->W3_PO_NUM,TSW3->W3_SI_NUM,TSW3->W3_POSICAO,TSW3->W3_COD_I,TSW3->B1_DESC,STOD(TSW3->W2_PO_DT),STOD(TSW3->W3_DT_ENTR),STOD(TSW3->W3_XDTENT2)})
    TSW3->(DBSKIP())
  ENDDO
  TSW3->(DBCLOSEAREA())

	IF EMPTY(aTMP)
		AADD(aTMP, {.F.,,"","","","","",STOD(""),STOD(""),STOD("")})
	ENDIF

	oListPedidos:SetArray(aTMP)
	oListPedidos:bLine      := {|| {IIf(	aTMP[oListPedidos:nAt,01],oOK, oNO),;
		LoadBitmap(GetResources(), "br_verde"),;
		aTMP[oListPedidos:nAt,03],;
		aTMP[oListPedidos:nAt,04],;
		aTMP[oListPedidos:nAt,05],;
		aTMP[oListPedidos:nAt,06],;
		aTMP[oListPedidos:nAt,07],;
		aTMP[oListPedidos:nAt,08],;
		aTMP[oListPedidos:nAt,09],;
		aTMP[oListPedidos:nAt,10];
		} }
	oListPedidos:nAt := 1

RETURN 


	//	GetStatus(aTMP[oListPedidos:nAt,02]),;


RETURN
