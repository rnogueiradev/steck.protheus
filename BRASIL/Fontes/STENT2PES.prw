#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} STENT2PES
description
    Rotina Manutenção de Pedidos
@type function
@version 
@author Valdemir Jose
@since 24/06/2020
@return return_type, return_description
u_STENT2PES
/*/
User Function STENT2PES()
	Local nTop    := 0
	Local nLeft   := 0
	Local nBottom := 0
	Local nRight  := 0
	Local aSize   := {}
	Local aObjects:= 0
	Local oBtFiltrar
	Local oBtProcessa
	Local oBtSair
	Local oGCliente
	Local oGEntrega
	Local oGetCliente
	Local oGetLoja
	Local oCBStatus
	Local oGetEmis1
	Local oGetEmis2
	Local oGetPedido
	Local oGetEnt11
	Local oGetEnt12
	Local oGetEnt21
	Local oGetEnt22
	Local oGetProduto
	Local oGPedido
	Local oGProduto
	Local oSCliente
	Local oSEmissao
	Local oSEnt1
	Local oSEnt2
	Local oSPedido
	Local oSStatus
	Local oSSeqItem
	Local oGetSeqItem
	Local oSPedCom
	Local oGetPedCom
	Local oGetItPedC
	Local oGetProduto

	Local nLinAj    := 0
	Local aCabec    := {"","","Pedido","Item","Produto","Descrição","Quantidade","Saldo","Entrega","Entrega-2","Ped.Comp","Local",IIF(cEmpAnt = "01","Recurso",""),"Cliente","Loja"}

	Local aTamCol   := {20,20,20,15,60,120,30,30,40,40,45,30,60}
	Local aFields	:= {'C5_NOTA','C5_ZBLOQ','C6_NUM','C6_ITEM','C6_PRODUTO','C6_DESCRI','C6_QTDVEN','SALDO',;
		IIF(cEmpAnt = "01","C6_ENTRE1","C6_ENTREG"),'C6_ZENTRE2','C6_NUMPCOM','C6_LOCAL','G2_DESCRI','C5_ZFATBLQ','C5_ZMOTREJ'}

	Private oDlgConsCons
	Private cCadastro 	:= OemToAnsi("Manutenção de Pedidos - Entrega 2")
	Private oOk	        := LoadBitmap(GetResources(), "LBOK")
	Private oNo	        := LoadBitmap(GetResources(), "LBNO")
	Private oVerde      := LoadBitmap(GetResources(), "br_verde")
	Private oAmarelo    := LoadBitmap(GetResources(), "br_amarelo")
	Private oVermelho   := LoadBitmap(GetResources(), "BR_VERMELHO")
	Private oMarrom     := LoadBitmap(GetResources(), "BR_MARROM")
	Private oLaranja    := LoadBitmap(GetResources(), "BR_LARANJA")
	Private oAzul       := LoadBitmap(GetResources(), "BR_AZUL")
	Private oPreto      := LoadBitmap(GetResources(), "BR_PRETO")
	Private oBranco     := LoadBitmap(GetResources(), "BR_BRANCO")
	Private aTMP        := {}
	Private oPanelEsq
	Private oPanelDIR
	Private oPanelINFERIOR
	Private cCBStatus    := Space(50)
	Private cGetCliente  := CriaVar("A1_COD",.F.)
	Private cGetLoja     := CriaVar("G2_RECURSO",.F.)      // ALTERADO 20/10/2020
	Private dGetEmiss1   := FirstDate(dDatabase-90)
	Private dGetEmiss2   := dDatabase
	Private dGetEnt11    := CTOD("")
	Private dGetEnt12    := CTOD("")
	Private dGetEnt21    := CTOD("")
	Private dGetEnt22    := CTOD("")
	Private cGetPedido   := CriaVar("C5_NUM",.F.)
	Private cGetProduto  := CriaVar("B1_COD",.F.)
	Private cGetSeqItem  := CriaVar("C6_ITEM",.F.)
	Private cGetPedCom   := CriaVar("C6_NUMPCOM",.F.)
	Private bFiltrar     := {|| CURSORWAIT(), FilRun(), AtuaPedidos(oListPedidos), CURSORARROW()}
	Private dDtEntEdit   := CTOD("")
	Private aHeader      := getHeader(aFields)
	Private nPosEnt1     := aScan(aCabec, {|X| alltrim(X)=="Entrega"})
	Private nPosEnt2     := aScan(aCabec, {|X| alltrim(X)=="Entrega-2"})
	Private nPosPedCom   := aScan(aCabec, {|X| alltrim(X)=="Ped.Comp"})
	Private nPosClie     := aScan(aCabec, {|X| alltrim(X)=="Cliente"})
	Private nPosLoja     := aScan(aCabec, {|X| alltrim(X)=="Loja"})
	Private nPosSaldo    := aScan(aCabec, {|X| alltrim(X)=="Saldo"})
	Private cGetItPedC   := CriaVar("C6_ITEM",.F.)
	Private cGetGrProd   := CriaVar("B1_GRUPO")
	PRIVATE oComboAlt
	PRIVATE nComboAlt := 1
	PRIVATE aMotAlt := {"        ","Quebra de máquina","Atraso de Matéria Prima","Atraso Embarque"}
	PRIVATE oListPedidos

	aSize := MSADVSIZE()

	oMainWnd:ReadClientCoors() // atualiza as coordernadas

	SETKEY( VK_F12, {|| getSituacao() } )

	If  FlatMode()
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

	aHeader      := getHeader(aFields)
	nBottom := 780
	nTop := 20
	Define MsDialog oDlgCons FROM nTop, nLeft To nBottom*0.8,nRight*0.7 TITLE OemToAnsi(cCadastro) Pixel style DS_MODALFRAME    // STYLE nOR( WS_VISIBLE, WS_POPUP )
	MntTela(oDlgCons)

	nLinAj    := 2
	cCBStatus := '2,3,5'

	@ 008, 005 GROUP oGCliente TO 065, 097 PROMPT "[ Cliente ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215  PIXEL
	@ 015, 012 SAY oSCliente PROMPT "Cod.Cliente" SIZE 030, 007 OF oGCliente COLORS 0, 16777215 PIXEL

	If cEmpAnt == "01"
		@ 039, 012 SAY oSLoja    PROMPT "Recurso"     SIZE 025, 007 OF oGCliente COLORS 0, 16777215 PIXEL
	Else 
		@ 039, 012 SAY oSLoja    PROMPT "Loja"     SIZE 025, 007 OF oGCliente COLORS 0, 16777215 PIXEL	
	EndIf

	@ 023, 012 MSGET oGetCliente VAR cGetCliente  SIZE 060, 010 OF oGCliente VALID VldCliente() COLORS 0, 16777215 F3 "SA1" PIXEL
	//@ 030, 012 MSGET oGetLoja    VAR cGetLoja     SIZE 020, 010 OF oGLoja                       COLORS 0, 16777215          PIXEL  //FR - 21/12/2022 - TICKET #20221215021889 Filtro tela manutenção

	If cEmpAnt == "01"
		@ 047, 012 MSGET oGetLoja    VAR cGetLoja     SIZE 030, 010 OF oGCliente  F3 "SH1" COLORS 0, 16777215 PIXEL
	Else 
		@ 047, 012 MSGET oGetLoja    VAR cGetLoja     SIZE 030, 010 OF oGCliente  COLORS 0, 16777215 PIXEL	//FR - 21/12/2022 - TICKET #20221215021889 Filtro tela manutenção
	EndIf
	//oGCliente:SetCSS( CSSFUND )

	@ 008, 100 GROUP oGProduto TO 065, 180 PROMPT "[ Produto ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 015, 110 SAY oSProduto PROMPT "Cod.Produto" SIZE 030, 007 OF oGCliente COLORS 0, 16777215 PIXEL
	@ 023, 110 MSGET oGetProduto VAR cGetProduto  SIZE 060, 010 OF oGProduto VALID VldProd() COLORS 0, 16777215 F3 "SB1" PIXEL
	@ 039, 110 SAY oSGrProd PROMPT "Grupo Prod"   SIZE 030, 007 OF oGCliente COLORS 0, 16777215 PIXEL
	@ 047, 110 MSGET oGetProduto VAR cGetGrProd   SIZE 060, 010 OF oGProduto COLORS 0, 16777215 F3 "SBM" PIXEL
	//oGProduto:SetCSS( CSSFUND )
	nLinAj += 23
	@ 043+nLinAj, 005 GROUP oGPedido TO 097+nLinAj, 180 PROMPT "[ Pedido ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 052+nLinAj, 008 SAY oSPedido PROMPT "Numero"         SIZE 025, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 008 MSGET oGetPedido VAR cGetPedido      SIZE 060, 010 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 052+nLinAj, 070 SAY oSEmissao PROMPT "Emissão De"    SIZE 035, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 070 MSGET oGetEmis1   VAR dGetEmiss1     SIZE 048, 010 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 052+nLinAj, 120 SAY oSEmissao PROMPT "Emissão Ate"   SIZE 035, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 060+nLinAj, 120 MSGET oGetEmis2   VAR dGetEmiss2     SIZE 048, 010 OF oGPedido COLORS 0, 16777215 PIXEL

	//oGPedido:SetCSS( CSSFUND )

	@ 073+nLinAj, 008 SAY oSSeqItem PROMPT "Seq.Item"      SIZE 025, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 081+nLinAj, 008 MSGET oGetSeqItem VAR cGetSeqItem    SIZE 020, 010 OF oGPedido COLORS 0, 16777215 PIXEL

	@ 073+nLinAj, 035 SAY oSStatus PROMPT "Status"     SIZE 025, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 081+nLinAj, 035 MsGET oCBStatus VAR cCBStatus    SIZE 056, 010 OF oGPedido COLORS 0, 16777215 PIXEL
	oCBStatus:cPlaceHold := "F12 Seleção Status"

	@ 073+nLinAj, 095 SAY oSPedCom PROMPT "Ped.Compra" SIZE 028, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 081+nLinAj, 095 MSGET oGetPedCom VAR cGetPedCom  SIZE 040, 010 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 073+nLinAj, 135 SAY oSItPedC PROMPT "Item"       SIZE 014, 007 OF oGPedido COLORS 0, 16777215 PIXEL
	@ 081+nLinAj, 135 MSGET oGetItPedC VAR cGetItPedC  SIZE 010, 010 OF oGPedido COLORS 0, 16777215 PIXEL

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

	//oGEntrega:SetCSS( CSSFUND )
	ajCol := 10

	@ 150+nLinAj, 005 GROUP oGMotivo TO 175+nLinAj, 180 PROMPT "[ Motivo da Alteração ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
  @ 160+nLinAj, 008 MSCOMBOBOX oComboAlt VAR nComboAlt ITEMS aMotAlt SIZE 121, 010 OF oGMotivo COLORS 0, 16777215 PIXEL

	@ 190+nLinAj, 005 GROUP oGAcoes TO 230+nLinAj, 180 PROMPT "[ Ações ]" OF oPanelDIR COLOR CLR_HBLUE, 16777215 PIXEL
	@ 200+nLinAj, 016 BUTTON oBtFiltrar    PROMPT "Filtrar"     SIZE 038, 025 OF oPanelDIR ACTION (Filtrar(),AtuaPedidos(oListPedidos))   PIXEL
	@ 200+nLinAj, 056 BUTTON oBtProcessa   PROMPT "Processar"   SIZE 038, 025 OF oGAcoes ACTION (Processar(),AtuaPedidos(oListPedidos) ) PIXEL
	@ 200+nLinAj, 096 BUTTON oBtExpor      PROMPT "Exportar"    SIZE 038, 025 OF oGAcoes ACTION ExpExcel(aCabec, aTMP)  PIXEL
	@ 200+nLinAj, 136 BUTTON oBtSair       PROMPT "Sair"        SIZE 038, 025 OF oGAcoes ACTION oDlgCons:End()  PIXEL
	//oGAcoes:SetCSS( CSSFUND )

	lRet := .T.
	if Empty(aTMP)
		aAdd(aTMP, {.F., ,"","","","","",0,0,"","","","","","",0} )
	endif

	oListPedidos       := TWBrowse():New(0, 0, 0, 0,, aCabec, aTamCol, oPanelEsq)
	oListPedidos:Align := CONTROL_ALIGN_ALLCLIENT
	AtuaPedidos(oListPedidos)
	if lRet
		oListPedidos:blDblClick   := {|| if( oListPedidos:ColPos==1, aTMP[oListPedidos:nAt, 1] := !aTMP[oListPedidos:nAt, 1], If(oListPedidos:ColPos > 1, ExecFun(oListPedidos:ColPos, oListPedidos),nil)), oListPedidos:DrawSelect(), oListPedidos:Refresh()}

		oListPedidos:bHeaderClick := { |o,nCol| nColuna := nCol, if(nCol==1, aEval(aTMP, {|X| X[nColuna] := If(!X[nColuna], .T., .F.)  }) ,nil), if(aTMP[1,1],InputEnt(oListPedidos),nil), oListPedidos:Refresh() }
	Endif
	oListPedidos:nAt  := 1

	oBtFiltrar:SetCSS( SetCssImg("", "Primary") )  // CSSBOTAO
	oBtProcessa:SetCSS( SetCssImg("", "Success") )
	oBTExpor:SetCSS( SetCssImg("", "Warning") )
	oBtSair:SetCSS( SetCssImg(, "Danger") )
	oBtFiltrar:cToolTip  := "Filtra registro com base nos dados informados"
	oBtProcessa:cToolTip := "Inicia processamento dos itens selecionados"
	oBTExpor:cToolTip    := "Exporta dados para planilha excel"
	oBtSair:cToolTip     := "Sai da tela"

	ACTIVATE MSDIALOG oDlgCons CENTER

	SETKEY( VK_F12, {|| Nil } )

Return


/*/{Protheus.doc} MntTela SetCssImg(cImg, cTipo)
description
   Monta tela primaria
@type function
@version 
@author Valdemir Jose
@since 24/06/2020
@param poDlgCons, param_type, param_description
@return return_type, return_description
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

Return


Static Function VldCliente()

Return .T.

Static Function VldProd()

Return .T.



Static Function SetCssImg(cImg, cTipo)

	Local cCssRet := ""
	Default cImg := "rpo:yoko_sair.png"
	Default cTipo := "Botao Branco"

	If cTipo == "Success"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#28a745;border-color:#28a745 "
		cCssRet += "}"
	EndIf

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

	If cTipo == "Warning"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#FFD700;border-color:#FFD700 "
		cCssRet += "}"
	EndIf

Return cCssRet

/*/{Protheus.doc} AtuaPedidos
description
Rotina Atualiza Grid
@type function
@version 
@author Valdemir Jose
@since 25/06/2020
@param oListPedidos, object, param_description
@return return_type, return_description
/*/
Static Function AtuaPedidos(oListPedidos)
	oListPedidos:SetArray(aTMP)
	oListPedidos:bLine      := {|| {IIf(	aTMP[oListPedidos:nAt,01],oOK, oNO),;
		GetStatus(aTMP[oListPedidos:nAt,02]),;
		aTMP[oListPedidos:nAt,03],;
		aTMP[oListPedidos:nAt,04],;
		aTMP[oListPedidos:nAt,05],;
		aTMP[oListPedidos:nAt,06],;
		aTMP[oListPedidos:nAt,07],;
		aTMP[oListPedidos:nAt,08],;
		aTMP[oListPedidos:nAt,09],;
		aTMP[oListPedidos:nAt,10],;
		aTMP[oListPedidos:nAt,11],;
		aTMP[oListPedidos:nAt,12],;
		aTMP[oListPedidos:nAt,13],;
		aTMP[oListPedidos:nAt,14],;
		aTMP[oListPedidos:nAt,15];
		} }
	oListPedidos:nAt := 1
Return



/*/{Protheus.doc} Filtrar
description
Rotina executada pelo botão
@type function
@version 
@author Valdemir Jose
@since 25/06/2020
@return return_type, return_description
/*/
Static Function Filtrar()
	Local lConf := (!Empty(cGetCliente) .or. !Empty(cGetProduto) .or. !Empty(cGetPedido) .or.;
		!Empty(dTos(dGetEmiss1)) .or. !Empty(dtos(dGetEmiss2)) .or. !Empty(cGetSeqItem) .or.;
		!Empty(cGetPedCom) .or. !Empty(dtos(dGetEnt11)) .or. !Empty(dtos(dGetEnt12)) .or. ;
		!Empty(dtos(dGetEnt21)) .or. !Empty(dtos(dGetEnt22)) )

	if !lConf
		lConf := MsgNoYes("Não foi informado nenhum campo no filtro, isto poderá¡ levar" + CRLF+;
			"um tempo maior no carregamento. Deseja continuar mesmo assim?","Atenção")
	Endif
	if lConf
		FwMsgRun(, bFiltrar, "Aguarde","Carregando os dados")
	endif
Return


/*/{Protheus.doc} FilRun
description
Rotina que popula o array para apresentação dos dados
@type function
@version 
@author Valdemir Jose
@since 25/06/2020
@return return_type, return_description
/*/
Static Function FilRun()
	Local cTabTMP    := GetNextAlias()
	Local cTMPSTATUS := ""

	AbreTMP(cTabTMP)

	aTMP := {}

	While (cTabTMP)->(! Eof() )

		if ((cTabTMP)->ZBLOQ = '1')                                                                              // PEDIDO BLOQUEADO POR REGRA DO COMERCIAL
			cTMPSTATUS := "9"
		elseif ( (cTabTMP)->NOTA=' ') .AND. ((cTabTMP)->ZFATBLQ = '3') .AND. ((cTabTMP)->ZMOTREJ =' ')           // ABERTO
			cTMPSTATUS := "2"
		elseif ((cTabTMP)->NOTA=' ') .AND.  ((cTabTMP)->ZFATBLQ = ' ') .AND. ((cTabTMP)->ZMOTREJ =' ')           // PEDIDO VENDA LIBERADO
			cTMPSTATUS := "3"
		elseif ((cTabTMP)->ZFATBLQ = '1') .AND.  !('XXXX' $ (cTabTMP)->NOTA )                                    // PEDIDO FATURADO TOTALMENTE
			cTMPSTATUS := "4"
		elseif ((cTabTMP)->ZFATBLQ = '2') .AND.  !('XXXX' $ (cTabTMP)->NOTA)                                     // PEDIDO FATURADO PARCIALMENTE
			cTMPSTATUS := "5"
		elseif ('XXXX' $ (cTabTMP)->NOTA) .AND. ( (cTabTMP)->ZFATBLQ = '3' .OR.  Empty((cTabTMP)->ZFATBLQ))      // PEDIDO CANCELADO
			cTMPSTATUS := "6"
		//20230808010015 - Removido o filtro C6_BLQ, pois, estava gerando error.log e ajustado o filtro por query
		//elseif (( (cTabTMP)->NOTA $ 'XXXX') .AND. ( (cTabTMP)->ZFATBLQ $ '1/2')  .OR.  (cTabTMP)->C6_BLQ =="R") // PEDIDO ELIMINADO POR RESIDUO
		elseif (( (cTabTMP)->NOTA $ 'XXXX') .AND. ( (cTabTMP)->ZFATBLQ $ '1/2') )  // PEDIDO ELIMINADO POR RESIDUO
			cTMPSTATUS := "7"
		elseif (!Empty( (cTabTMP)->ZMOTREJ )) .AND. !('XXXX' $(cTabTMP)->NOTA) .AND. ((cTabTMP)->ZFATBLQ == ' ') // Pedido REJEITADO PELO FINANCEIRO
			cTMPSTATUS := "8"
		Endif

		aAdd(aTMP, {;
			.F.,;
			cTMPSTATUS,;
			(cTabTMP)->PEDIDO,;
			(cTabTMP)->ITEM,;
			(cTabTMP)->PRODUTO,;
			(cTabTMP)->DESCRICAO,;
			(cTabTMP)->QUANTIDADE,;
			(cTabTMP)->SALDO,;
			stod((cTabTMP)->ENTREGA1),;
			stod((cTabTMP)->ENTREGA2),;
			(cTabTMP)->PEDCOMPRA,;
			(cTabTMP)->LOCAL,;
			IIF( cEmpAnt == "01",(cTabTMP)->RECURSO,""),;
			(cTabTMP)->CLIENTE,;
			(cTabTMP)->LOJA,;
			(cTabTMP)->REG;
			})
		(cTabTMP)->( dbSkip() )
	EndDo

	FileClose()

Return




/*/{Protheus.doc} FechaTMP
    (long_description)
    Rotina para fechar tabela temporaria
    @type  Function
    @author user
    Valdemir Rabelo
    @since 22/04/2020
    @version version
    @param 
/*/
Static Function FechaTMP(cTabTMP)

	if Select(cTabTMP) > 0
		(cTabTMP)->( dbCloseArea() )
	endif

Return



/*/{Protheus.doc} AbreTMP
    (long_description)
    Rotina para abrir tabela temporaria
    @type  Function
    @author user
    Valdemir Rabelo
    @since 25/06/2020
    @version version
    @param 
/*/
Static Function AbreTMP(cTabTMP)
	Local cQry   := ""
	Local cView  := ""

	cQry := MntQry(cTabTMP)

	FechaTMP(cTabTMP)

	TcQuery cQry New Alias (cTabTMP)

Return

/*/{Protheus.doc} MntQry
description
Rotina que farÃ¡ o fitro dos dados
@type function
@version 
@author Valdemir Jose
@since 25/06/2020
@return return_type, return_description
/*/
Static Function MntQry(cTabTMP)
	Local cRET     := ""
	Local cTMPRET  := ""
	LOCAL nX       := 0
	LOCAL aSTATUS  := SEPARA(cCBStatus,',')

	FechaTMP(cTabTMP)

	IF LEN(aSTATUS)==0
		aSTATUS  := {'1'}
	ENDIF

	cTMPRET  := "SELECT PEDIDO, ITEM, EMISSAO, PRODUTO, DESCRICAO, QUANTIDADE, SALDO, LOCAL, ENTREGA1, PEDCOMPRA, ENTREGA2, NOTA, ZFATBLQ, ZMOTREJ, ZBLOQ, REG, CLIENTE, LOJA" +;
		IIF(cEmpAnt == "01", ", MAX(RECURSO) RECURSO ","") + CRLF
	cTMPRET  += "FROM ( " + CRLF

	FOR nX := 1 TO LEN(aSTATUS)

		IF nX > 1
			cRET += " UNION " + CRLF
		ENDIF

		cRET += "SELECT C6_NUM PEDIDO, C6_ITEM ITEM, C6_EMISSAO EMISSAO, C6_PRODUTO PRODUTO, C6_DESCRI DESCRICAO, C6_QTDVEN QUANTIDADE, (C6_QTDVEN-C6_QTDENT) SALDO,C6_LOCAL LOCAL,"
		cRet += IIF(cEmpAnt == "01","C6_ENTRE1","C6_ENTREG") + " ENTREGA1, C6_NUMPCOM PEDCOMPRA, C6_ZENTRE2 ENTREGA2, C5_NOTA NOTA, C5_ZFATBLQ ZFATBLQ, C5_ZMOTREJ ZMOTREJ, C5_ZBLOQ ZBLOQ, B.R_E_C_N_O_ REG "
		cRet += IIF(cEmpAnt == "01", ", H.G2_DESCRI RECURSO, ",",")
		cRet += "C5_CLIENTE CLIENTE, C5_LOJACLI LOJA, C6_BLQ "
		cRET += "FROM "+RETSQLNAME("SC5")+" A       " + CRLF
		cRET += "INNER JOIN "+RETSQLNAME("SC6")+" B " + CRLF
		cRET += "ON B.C6_FILIAL=A.C5_FILIAL AND B.C6_NUM=A.C5_NUM AND B.C6_CLI=A.C5_CLIENTE AND B.C6_LOJA=A.C5_LOJACLI AND B.D_E_L_E_T_ = ' ' " + CRLF
		cRET += "INNER JOIN "+RETSQLNAME("SB1")+" G " + CRLF
		cRET += "ON G.B1_COD=B.C6_PRODUTO AND G.D_E_L_E_T_ = ' ' " + CRLF

		IF cEmpAnt == "01"
			cRET += "LEFT JOIN "+RETSQLNAME("SG2")+" H " + CRLF
			cRET += "ON G.B1_COD=H.G2_PRODUTO AND H.G2_FILIAL='"+XFILIAL('SG2')+"' AND  H.D_E_L_E_T_ = ' ' " + CRLF
		EndIf

		cRET += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
		cRET += " AND C6_FILIAL='"+XFILIAL("SC6")+"' " + CRLF

		cProdTMP := ""

		IF !Empty(cGetCliente)
			cRET += " AND B.C6_CLI='"+cGetCliente+"'  " + CRLF
		Endif

		IF cEmpAnt == "01"		
			IF !Empty(cGetLoja)
				cRET += " AND H.G2_RECURSO='"+cGetLoja+"'      " + CRLF
			Endif
		//FR - 21/12/2022 - TICKET #20221215021889 Filtro tela manutenção pedidos
		Else 
			IF !Empty(cGetLoja)
				cRET += " AND B.C6_LOJA = '" + cGetLoja + "'  " + CRLF
			Endif 
		EndIf
		//FR - 21/12/2022 - TICKET #20221215021889 Filtro tela manutenção pedidos

		If !Empty(cGetProduto)
			cRET += " AND B.C6_PRODUTO='"+alltrim(cGetProduto)+"' " + CRLF
		Endif

		if !Empty(cGetGrProd)
			cRET += " AND G.B1_GRUPO='"+alltrim(cGetGrProd)+"' " + CRLF
		Endif

		if !Empty(cGetPedido)
			cRET += " AND A.C5_NUM='"+cGetPedido+"' " + CRLF
		Endif

		if !Empty(dtos(dGetEmiss2))
			cRET += " AND A.C5_EMISSAO BETWEEN '"+dtos(dGetEmiss1)+"' AND '"+dtos(dGetEmiss2)+"' " + CRLF
		Endif

		if !Empty(cGetSeqItem)
			cRET += " AND B.C6_ITEM='"+cGetSeqItem+"' " + CRLF
		Endif

		if !Empty(cGetPedCom)
			cRET += " AND B.C6_NUMPCOM='"+cGetPedCom+"' " + CRLF
		Endif

		if !Empty(cGetItPedC)
			cRET += " AND B.C6_ITEMPC ='"+cGetItPedC+"' " + CRLF        // 15/07/2020 - valdemir
		Endif

		if !Empty(dtos(dGetEnt12))
			IF cEmpAnt == "01"
				cRET += " AND B.C6_ENTRE1 BETWEEN '"+dtos(dGetEnt11)+"' AND '" +dtos(dGetEnt12)+"' " + CRLF
			Else
				cRET += " AND B.C6_ENTREG BETWEEN '"+dtos(dGetEnt11)+"' AND '" +dtos(dGetEnt12)+"' " + CRLF
			Endif
		Endif

		if !Empty(dtos(dGetEnt22))
			cRET += " AND B.C6_ZENTRE2 BETWEEN '"+dtos(dGetEnt21)+"' AND '" +dtos(dGetEnt22)+"' " + CRLF
		Endif

		if  Alltrim(aSTATUS[nX]) == '2'		//ABERTO
			//FR - 21/12/2022 - Comentado por Flávia Rocha - Sigamat Consultoria
			//cRET += " AND  (A.C5_NOTA=' ' AND A.C5_ZFATBLQ = '3' AND A.C5_ZMOTREJ =' ' AND A.C5_ZBLOQ <> '1')" + CRLF             // ABERTO
			
			//FR - 20/12/2022 - TICKET #20221215021889 - Filtro "aberto" está trazendo item de pedido que já foi entregue total
			cRET += " AND  ( (B.C6_QTDVEN - B.C6_QTDENT )> 0  AND A.C5_ZFATBLQ = '3' AND A.C5_ZMOTREJ =' ' AND A.C5_ZBLOQ <> '1' and  B.C6_BLQ <>'R')" + CRLF             // ABERTO
			
		Elseif  Alltrim(aSTATUS[nX]) == '3'	//LIBERADO
			//FR - 21/12/2022 - Comentado por Flávia Rocha - Sigamat Consultoria
			//cRET += " AND (A.C5_NOTA=' ' AND  A.C5_ZFATBLQ = ' ' AND A.C5_ZMOTREJ =' ' AND A.C5_ZBLOQ <> '1')" + CRLF            // PEDIDO VENDA LIBERADO
			
			//FR - 20/12/2022 - TICKET #20221215021889 - Filtro "aberto" está trazendo item de pedido que já foi entregue total
			cRET += " AND ( (B.C6_QTDVEN - B.C6_QTDENT )> 0  AND  A.C5_ZFATBLQ = ' ' AND A.C5_ZMOTREJ =' ' AND A.C5_ZBLOQ <> '1' and  B.C6_BLQ <>'R')" + CRLF            // PEDIDO VENDA LIBERADO(B.C6_QTDVEN - B.C6_QTDENT )> 0
		
		Elseif  Alltrim(aSTATUS[nX]) == '4'	//FATURADO TOTALMENTE
			cRET += " AND (A.C5_ZFATBLQ = '1' AND A.C5_NOTA <> 'XXXXXXXXX' AND A.C5_ZBLOQ <> '1' and  B.C6_BLQ ='R')" + CRLF                         // PEDIDO FATURADO TOTALMENTE
		
		Elseif  Alltrim(aSTATUS[nX]) == '5'	//FATURADO PARCIALMENTE
			//FR - 21/12/2022 - Comentado por Flávia Rocha - Sigamat Consultoria
			//cRET += " AND (A.C5_ZFATBLQ = '2' AND A.C5_NOTA <>'XXXXXXXXX'  AND A.C5_ZBLOQ <> '1')" + CRLF                         // PEDIDO FATURADO PARCIALMENTE
			
			//FR - 20/12/2022 - TICKET #20221215021889 - Filtro "aberto" está trazendo item de pedido que já foi entregue total
			cRET += " AND ( (B.C6_QTDVEN - B.C6_QTDENT )> 0 AND A.C5_ZFATBLQ = '2' AND A.C5_NOTA <>'XXXXXXXXX'  AND A.C5_ZBLOQ <> '1' and  B.C6_BLQ <> 'R')" + CRLF                         // PEDIDO FATURADO PARCIALMENTE

		Elseif  Alltrim(aSTATUS[nX]) == '6'
			cRET += " AND (A.C5_NOTA IN('XXXX') AND A.C5_ZFATBLQ = '3' AND A.C5_ZBLOQ <> '1') " + CRLF                            // PEDIDO CANCELADO - OR (A.C5_ZFATBLQ= ' ')
		Elseif  Alltrim(aSTATUS[nX]) == '7'
			//20230808010015 - Alterado, pois, na validação do chamado foi identificado que não estava sendo filtro os pedidos eliminados por residuo
		  //cRET += " AND A.C5_NOTA IN('XXXX') AND A.C5_ZFATBLQ IN('1','2')   AND A.C5_ZBLOQ <> '1' " + CRLF                      // PEDIDO ELIMINADO POR RESIDUO
			cRET += " AND B.C6_BLQ='R'" + CRLF  // PEDIDO ELIMINADO POR RESIDUO
		Elseif  Alltrim(aSTATUS[nX]) == '8'
			cRET += " AND (A.C5_ZMOTREJ <> ' ' AND A.C5_NOTA <>'XXXXXXXXX' AND A.C5_ZFATBLQ = ' '  AND A.C5_ZBLOQ <> '1' and  B.C6_BLQ<>'R')" + CRLF  // Pedido REJEITADO PELO FINANCEIRO
		Elseif  Alltrim(aSTATUS[nX]) == '9'
			cRET += " AND (A.C5_ZBLOQ = '1'  B.C6_BLQ <>'R')" + CRLF                                                       // PEDIDO BLOQUEADO POR REGRA DO COMERCIAL
		Endif

	NEXT
	cTMPRET  += cRET
	cTMPRET  += " ) X " + CRLF

	If cEmpAnt=="01"
		cTMPRET += " GROUP BY PEDIDO, ITEM, EMISSAO, PRODUTO, DESCRICAO, QUANTIDADE, SALDO, LOCAL, ENTREGA1, PEDCOMPRA, ENTREGA2, NOTA, ZFATBLQ, ZMOTREJ, ZBLOQ, REG, CLIENTE, LOJA " + CRLF
	EndIf

	cTMPRET  += "ORDER BY PEDIDO, ITEM, EMISSAO " + CRLF

	cRET     := cTMPRET

	MemoWrite("C:\QUERY\STENT2PES.TXT" , cRET)

Return cRET


/*/{Protheus.doc} CLICKALT
   description
   Rotina que permitirÃ¡ editar a data de entrega 2
   @type function
   @version 
   @author Valdemir Jose
   @since 25/06/2020
   @param aWBrowse1, array, param_description
   @param oWBrowse1, object, param_description
   @return return_type, return_description
/*/
Static Function CLICKALT(aWBrowse1,oWBrowse1)
	Local lOK := .T.
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xFilial('SB1')+aWBrowse1[oWBrowse1:nAT,5]) )

	SetKey(VK_F4,{|| MaViewSB2(SB1->B1_COD) })

	IF (oWBrowse1:COLPOS == nPosEnt2)

		/*******************************
		Caso o cliente for a distribuidora não permite alterar a data sem pedido de compra vinculado
		*******************************/
		IF  EMPTY(aWBrowse1[oWBrowse1:nAT,11]) .AND. aWBrowse1[oWBrowse1:nAT,14] = "033467" .AND. aWBrowse1[oWBrowse1:nAT,15] = "06"
			MSGALERT("Não é possível altar a data pois não existe pedido de compra vinculado! Entre em contato com o Planejamento.")
		ELSEIF aWBrowse1[oWBrowse1:nAT,08] <= 0 
			MSGALERT("Não é possível altar a data pois não existe saldo para o pedido.")
		ELSE
			if  !(aWBrowse1[oWBrowse1:nAT,2] $ "4/7")
				lEditCell( @aWBrowse1, oWBrowse1, "@D 99/99/9999", oWBrowse1:COLPOS )
				// Verifico se foi informado uma data menor que a entrega1
				/******************************
				Retirado tramento conforme solitação do usuário
				lOK := (!(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] < aWBrowse1[oWBrowse1:nAT,nPosEnt1])) .or. Empty(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS]) .or. (!aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] < dDatabase)
				*******************************/
				if lOK
					aWBrowse1[oWBrowse1:nAT][1] := !Empty(aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS])
				else
					///FWMsgRun(,{|| sleep(3000)},'Atenção!','A data entrega-2, não pode ser retroativa. Por favor, verifique.')
					aWBrowse1[oWBrowse1:nAT,oWBrowse1:COLPOS] := ctod("")
				endif
			else
				FWMsgRun(,{|| sleep(3000)},"Atenção","Esta situação do registro não permite alterar data de entrega.")
			endif
		ENDIF
	ELSE
		FWMsgRun(,{|| sleep(3000)},"Atenção","Coluna selecionada não editavel...")
	ENDIF

	SetKey(VK_F4,{|| Nil })

	oWBrowse1:Refresh()
Return

/*/{Protheus.doc} InputEnt
   description
   Rotina para ser informado a nova data de entrega
   @type function
   @version 
   @author Valdemir Jose
   @since 26/06/2020
   @param oObjList, object, param_description
   @return return_type, return_description
/*/
Static Function InputEnt(oObjList)
	Local oBTOk
	Local oGetData
	Local oGRData
	Local nX   := 0
	Local nOPC := 0
	LOCAL cMsgRet := ""
	Static oDlgData

	dDtEntEdit := ctod(" /  /  ")

	DEFINE MSDIALOG oDlgData TITLE "Informe" FROM 000, 000  TO 150, 240 COLORS 0, 16777215 PIXEL style DS_MODALFRAME

	@ 011, 015 GROUP oGRData TO 041, 107 PROMPT "[ Nova Data ]" OF oDlgData COLOR 0, 16777215 PIXEL
	@ 022, 030 MSGET oGetData VAR dDtEntEdit SIZE 060, 010 OF oDlgData COLORS 0, 16777215 PIXEL
	@ 048, 045 BUTTON oBTOk PROMPT "OK" SIZE 037, 012 OF oDlgData ACTION (nOPC :=1,oDlgData:End()) PIXEL
	oGRData:SetCSS( CSSFUND )
	oBTOk:SetCSS( SetCssImg("", "Primary") )
	ACTIVATE MSDIALOG oDlgData CENTERED

	if nOPC==1
		if !Empty(dtos(dDtEntEdit))
			For nX := 1 to Len(aTMP)
		    
				/*******************************
				Caso o cliente for a distribuidora não permite alterar a data sem pedido de compra vinculado
				*******************************/
				IF EMPTY(aTMP[nX][nPosPedCom]) .AND. aTMP[nX][nPosClie] = "033467" .AND. aTMP[nX][nPosLoja] = "06"
					cMsgRet := "Existem itens que não serão atualizados pois não possuem pedido de Compra da Distribuidora vinculado!"
				ELSEIF aTMP[nX][nPosSaldo] > 0 
					aTMP[nX][nPosEnt2] := dDtEntEdit
				ENDIF
			Next
		else
			aEval(aTMP, {|X| X[nColuna] := .F.})
		Endif
		oObjList:Refresh()

		IF !EMPTY(cMsgRet)
			MSGALERT(cMsgRet)
		ENDIF
	Endif

Return

/*/{Protheus.doc} GetStatus
description
  Rotina para apresentação de status visual
@type function
@version 
@author Valdemir Jose
@since 26/06/2020
@param pStatus, param_type, param_description
@return return_type, return_description
/*/
Static Function GetStatus(pStatus)
	Local oRetObJ := ""

	if pStatus=="2"
		oRetObj := "br_verde"
	elseif pStatus=="3"
		oRetObj := "br_amarelo"
	elseif pStatus == "4"
		oRetObj := "br_vermelho"
	elseif pStatus == "5"
		oRetObj := "br_branco"
	elseif pStatus == "6"
		oRetObj := "br_marrom"
	elseif pStatus == "7"
		oRetObj := "br_laranja"
	elseif pStatus == "8"
		oRetObj := "br_azul"
	elseif pStatus == "9"
		oRetObj := "br_preto"
	endif

Return LoadBitmap(GetResources(), oRetObj)


/*/{Protheus.doc} Legenda
description
  Rotina de apresentação de legendas
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@return return_type, return_description
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
Return




/*/{Protheus.doc} ExecFun
description
   Rotina que irÃ¡ alterar dados da celula
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param pnCol, param_type, param_description
@param oListPedidos, object, param_description
@return return_type, return_description
/*/
Static Function ExecFun(pnCol,oListPedidos)
	if pnCol == 2
		Legenda()
	elseif pnCol == nPosEnt2
		CLICKALT(aTMP,oListPedidos)
	else
		FWMsgRun(,{|| sleep(3000)},"Atenção","Coluna selecionada não editavel...")
	Endif
Return

/*/{Protheus.doc} Processar
description
   Rotina para chamada de processamento
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@return return_type, return_description
/*/
Static Function Processar()
	Local nSel := 0

	if Len(aTMP)==0
		FWMsgRun(,{|| Sleep(4000)},'Informação',"Não existe registros carregado na tela")
		Return
	Endif
	aEval(aTMP, {|X| if(X[1], nSel++,nil) })

	if (nSel == 0)
		FWMsgRun(,{|| Sleep(4000)},'Informação',"Não foi selecionado nenhum registro para processar.")
		Return
	Endif

	IF oComboAlt:Nat = 1	
		MSGALERT("Informe o motivo da Alteração.")
		Return
	ENDIF

	Processa( {|| ProcesReg()}, "Aguarde...")

Return

/*/{Protheus.doc} ProcesReg
description
   Rotina para processar registros tabela SC6
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@return return_type, return_description
/*/
Static Function ProcesReg()
	Local nX       := 0
	Local nUltCol  := Len(aTMP[1])
	Local aArea    := GetArea()
	LOCAL dDtaNova := ""
	Local cTravData:= GetNewPar("STENT2DAT", "N")	
	dbSelectArea("SC5")
	dbSetOrder(1)

	ProcRegua( Len(aTMP) )
	dbSelectArea("SC6")
	SC6->( dbSetOrder(1) )

	For nX := 1 to Len(aTMP)
		INCPROC("")

		If aTMP[nX, 1]
			
      /***************************************************************************************************************************************
      <<Alteração>>
      Ação......: Não permite efetuar alteração no pedido se a Data de Entrega2 não estiver preenchida
      Analista..: Marcelo Klopfer Leme - SIGAMAT
      Data......: 29/09/2022
      Chamado...:  20220928018282
      ***************************************************************************************************************************************/
			IF aTMP[nX, 1] = .T. .AND. !EMPTY(aTmp[nX, nPosEnt2])
				//FR - 21/12/2022 - Ticket #20221215021889 - filtro tela manutenção pedidos - impedir que seja digitada data entrega menor que Database
				If (aTmp[nX, nPosEnt2] < dDatabase) .and. (cTravData =="S")
					MsgAlert("Data Informada menor que DataBase !!!")
				Else 
					Begin Transaction // Inicia Transação .
					
					SC6->( dbGoto( aTmp[nX, nUltCol] ) )
					RecLock("SC6", .F.)
					SC6->C6_ZENTRE2 := aTmp[nX, nPosEnt2]
					IF empty(sc6->C6_ZENTRE1)//Kleber Ribeiro - CRM Services 06/05/2023
						SC6->C6_ZENTRE1 := aTmp[nX, nPosEnt2]
						SC6->C6_ZMOTALT := aMotAlt[oComboAlt:NAT]
					ELSE
						SC6->C6_ZENTREC := u_STTMKG04(aTmp[nX, nPosEnt2])
					ENDIF

					If cEmpAnt == "01" .And. cFilAnt = "05" .And. SC6->C6_CLI == "012047"
						If !Empty(dtos(SC6->C6_ZENTRE2))
							If GetMv("STENT2PES1",,.F.)
								SC6->C6_XALTDT  := "S"
							EndIf
						Endif
					EndIf
					SC6->( MsUnlock() )

					IF empty(SC6->C6_ZENTREC)
						u_LOGJORPED("SC6"," ",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Alteracao Data1C - " +cvaltochar(SC6->C6_ZENTRE1))
					ELSE
						u_LOGJORPED("SC6"," ",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Alteracao Data2C - " +cvaltochar(SC6->C6_ZENTREC))
					ENDIF

					cQuery := "UPDATE "+AllTrim(GetMv("STALIASDIS"))+".SC7110 C7 SET C7.C7_XDTENT2 = '"+DTOS(SC6->C6_ZENTRE2)+"', "  
					IF empty(SC6->C6_ZENTREC)
						cQuery += "C7.C7_ZENTRE1 = '"+DTOS(SC6->C6_ZENTRE1)+"', " 
						cQuery += "C7.C7_ZMOTALT = '"+ALLTRIM(SC6->C6_ZMOTALT)+"' " 
					ELSE
						cQuery += "C7.C7_ZENTREC = '"+DTOS(SC6->C6_ZENTREC)+"' " 
					ENDIF
					cQuery += "WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='01' AND C7_NUM='"+AllTrim(SC6->C6_NUMPCOM)+"' AND C7_ITEM='"+Alltrim(SC6->C6_ITEMPC)+"'
					IF TCSqlExec(cQuery) < 0 
						CONOUT("[STENT2P] - Não foi possível atualizar o registro na tabela SC7 na distribuidora" ) //+ALLTRIM(STR(TZ96->SC7REC)))
					ENDIF

					/****************************************
					Alteração....: Atualiação dos campos C6_ZENTRE2 e C7_XDTENT2
					.............: Neste momento atualiza as datadas no pedido de Compras da Distribuidora e o Pedido de Venda
					Desenvolvedor: Marcelo Klopfer Leme
					Data.........: 22/06/2022
					Chamado......: 20220429009114 - Oferta Logística
					*************************************/
					cQuery := "SELECT C7.C7_FORNECE, C7.C7_LOJA,C6.C6_ENTREG,Z96.Z96_PEDCOM,Z96.Z96_ITECOM,Z96.Z96_PA1DOC, "
							cQuery += "Z96.Z96_PROD,Z96.R_E_C_N_O_ AS Z96REC,C7.R_E_C_N_O_ AS SC7REC,C6.R_E_C_N_O_ AS SC6REC FROM "+AllTrim(GetMv("STALIASDIS"))+".Z96110 Z96 "
							cQuery += "INNER JOIN "+AllTrim(GetMv("STALIASDIS"))+".SC7110 C7 ON C7.D_E_L_E_T_ = ' ' AND C7.C7_NUM = Z96.Z96_PEDCOM AND C7.C7_ITEM = Z96.Z96_ITECOM "
							cQuery += "INNER JOIN "+AllTrim(GetMv("STALIASDIS"))+".SC6110 C6 ON C6.D_E_L_E_T_ = ' ' AND C6.C6_NUM = SUBSTR(Z96.Z96_PA1DOC,1,6) AND C6.C6_ITEM = SUBSTR(Z96.Z96_PA1DOC,7,2) "
					cQuery += "WHERE Z96.D_E_L_E_T_ = ' ' "
					cQuery += "AND Z96.Z96_PVIND = '"+SC6->C6_NUM+"' AND Z96.Z96_ITPVIN = '"+SC6->C6_ITEM+"' "
					cQuery += "ORDER BY Z96.Z96_PVIND "
					cQuery := ChangeQuery(cQuery)
					
					If Select("TZ96") > 0
						DbselectArea("TZ96")
						DbCloseArea()
					Endif 

					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ96', .F., .T.)
					WHILE TZ96->(!EOF())

						/*************************************
						Atualiza a tabela Z97 de LOG de alteração
						*************************************/
						DBSELECTAREA("Z97")
						RECLOCK("Z97",.T.)
						Z97->Z97_FILIAL := XFILIAL("Z97")
						Z97->Z97_CODEMP := cEmpAnt+cFilAnt
						Z97->Z97_TIPREG := "PV"
						Z97->Z97_CODFOR := TZ96->C7_FORNECE
						Z97->Z97_LOJAFO := TZ96->C7_LOJA
						Z97->Z97_DATALT := DATE()
						Z97->Z97_NUMPVI := SC6->C6_NUM
						Z97->Z97_ITEPVI := SC6->C6_ITEM
						Z97->Z97_NUMPCD := TZ96->Z96_PEDCOM
						Z97->Z97_ITEPCD := TZ96->Z96_ITECOM
						Z97->Z97_NUMPVC := SUBSTR(ALLTRIM(TZ96->Z96_PA1DOC),1,6)
						Z97->Z97_ITEPVC := SUBSTR(ALLTRIM(TZ96->Z96_PA1DOC),7,2)
						Z97->Z97_CODPRO := TZ96->Z96_PROD
						Z97->Z97_DATANT := STOD(TZ96->C6_ENTREG)
						Z97->Z97_DATNEW := SC6->C6_ZENTRE2
						Z97->Z97_MOTIVO := aMotAlt[oComboAlt:NAT]
						Z97->Z97_CODUSR := __cUserId
						Z97->(MSUNLOCK())

						cQuery := "UPDATE "+AllTrim(GetMv("STALIASDIS"))+".Z96110 Z96 SET Z96.Z96_DTPVIN = '"+DTOS(SC6->C6_ZENTRE2)+"' "  
						cQuery += "WHERE Z96.R_E_C_N_O_  = "+ALLTRIM(STR(TZ96->Z96REC))+" " 
						IF TCSqlExec(cQuery) < 0 
							CONOUT("[STENT2P] - Não foi possível atualizar o registro na tabela Z96 na distribuidora"+ALLTRIM(STR(TZ96->Z96REC)))
						ENDIF

						/********************************
						Monta a query para buscar na Z96 a maior data para este pedido/item
						********************************/
						cQuery := "SELECT Z96.Z96_PA1DOC, MAX(Z96_DTPVIN) MAIORDATA FROM "+AllTrim(GetMv("STALIASDIS"))+".Z96110 Z96 "
									cQuery += "WHERE Z96.D_E_L_E_T_ = ' ' AND Z96.Z96_PA1DOC = '"+TZ96->Z96_PA1DOC+"' "
						cQuery += "GROUP BY Z96.Z96_PA1DOC "
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'XZ96', .F., .T.)
									dDtaNova := ""
									IF STOD(XZ96->MAIORDATA) > SC6->C6_ZENTRE2
										dDtaNova := XZ96->MAIORDATA
									ELSE
										dDtaNova := DTOS(SC6->C6_ZENTRE2)
									ENDIF
									XZ96->(DBCLOSEAREA())

									cQuery := "UPDATE "+AllTrim(GetMv("STALIASDIS"))+".SC6110 C6 SET C6.C6_ZENTRE2 = '"+dDtaNova+"' "  
									cQuery += "WHERE C6.R_E_C_N_O_  = "+ALLTRIM(STR(TZ96->SC6REC))+" " 
									IF TCSqlExec(cQuery) < 0 
										CONOUT("[STENT2P] - Não foi possível atualizar o registro na tabela SC6 na distribuidora"+ALLTRIM(STR(TZ96->SC6REC)))
									ENDIF

						TZ96->(DBSKIP())
					ENDDO
					TZ96->(DBCLOSEAREA())

					// Se foi alterado atualizo SC5
					If cEmpAnt == "01" .And. cFilAnt = "05" .And. SC6->C6_CLI == "012047"
						If SC5->( dbSeek(xFilial('SC5')+SC6->C6_NUM) ) .And. (SC6->C6_XALTDT=="S")
							If SC5->C5_XALTDT <> "S"
								RecLock("SC5", .F.)
								SC5->C5_XALTDT := "S"
								MsUnlock()
							Endif
						EndIf
					EndIf
				
				    End Transaction 
					
				Endif //se a data digitada menor que database  //FR - 21/12/2022
			EndIf
		EndIf
	Next

	aTMP := {}

	FWMsgRun(,{|| aAdd(aTMP, {.F., ,"","","","","",0,0,"","","","","","",0} ) , Sleep(4000)},"Informativo","Registro Processado com Sucesso.")

	RestArea( aArea )

Return

/*/{Protheus.doc} getHeader
description
   Rotina para tratar cabeÃ§alho
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param paFields, param_type, param_description
@return return_type, return_description
/*/
Static Function getHeader(paFields)
	Local aRET   := {}
	Local nX     := 0
	Local aAreaT := GetArea()

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(paFields)
		If SX3->(DbSeek(paFields[nX]))
			Aadd(aRET, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	RestArea( aAreaT )

Return aRET



/*/{Protheus.doc} ExpExcel
description
   Rotina para exportar para excel
@type function
@version 
@author Valdemir Jose
@since 06/07/2020
@param paCabec, param_type, param_description
@param paTMP, param_type, param_description
@return return_type, return_description
/*/
Static Function ExpExcel(paCabec, paTMP)
	Local aCab   := aClone(paCabec)
	Local aDados := aClone(paTMP)
	Local aTipo  := {"C","C","C","C","N","N","D","D","C","N","C"}

	if (Len(paTMP) > 0 .OR. Len(paTMP)==1)
		if Empty(alltrim(paTMP[1][3]))
			FWMsgRun(,{|| sleep(4000)},'Informação','Não existe registros a serem exportado. Por favor, verifique.')
			Return
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

Return



Static Function getSituacao()
	Local aSitua := {;
		{.f.,"1","Todos"},;
		{.f.,"2","Aberto"},;
		{.f.,"3","Liberado"},;
		{.f.,"4","Faturado Totalmente"},;
		{.f.,"5","Faturado Parcialmente"},;
		{.f.,"6","Cancelado"},;
		{.f.,"7","Eliminado Residuo"},;
		{.f.,"8","Rejeitado Financeiro"},;
		{.f.,"9","Bloqueado por Regras"};
		}
	Local oBTOK
	Local oLbx
	Local nLbx   := 1
	Local aColun := {05,20,50}
	Private oOk  := LoadBitmap(GetResources(), "LBOK")
	Private oNo  := LoadBitmap(GetResources(), "LBNO")
	Static oDlgStatus

	DEFINE MSDIALOG oDlgStatus TITLE "Selecione Status" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

	@ 004, 005 LISTBOX oLbx  VAR nLbx FIELDS Header " ", "Status", "Descrição" SIZE 138, 115 Of oDlgStatus PIXEL ON dblClick(aSitua[oLbx:nAt,1] := (!aSitua[oLbx:nAt,1] ,oLbx:Refresh()) )
	oLbx:SetArray(aSitua)
	oLbx:bLine := {|| { Iif(aSitua[oLbx:nAt,1],oOk,oNo), aSitua[oLbx:nAt,2], aSitua[oLbx:nAt,3] }}
	oLbx:blDblClick   := {|| aSitua[oLbx:nAt, 1] := !aSitua[oLbx:nAt, 1], oLbx:DrawSelect(), oLbx:Refresh()}
	@ 128, 055 BUTTON oBTOK PROMPT "OK" ACTION (PROCESSA({|| OKCLICK(aSitua)}, "Filtrando itens...","Aguarde!",.F.), oDlgStatus:End()) SIZE 037, 012 OF oDlgStatus PIXEL

	ACTIVATE MSDIALOG oDlgStatus CENTERED


Return .T.


Static Function OKCLICK(aSitua)
	Local nX  := 0
	Local cTabTMP    := GetNextAlias()
	Local cTMPSTATUS := ""
	cCBStatus := ""

	For nX := 1 to Len(aSitua)
		if aSitua[nX, 1]
			if !Empty(cCBStatus)
				cCBStatus += ","
			endif
			cCBStatus += aSitua[nX,2]
		Endif
	Next

	cQry := MntQry(cTabTMP)
	TcQuery cQry New Alias (cTabTMP)

	AbreTMP(cTabTMP)

	aTMP := {}

	While (cTabTMP)->(! Eof() )

		IncProc("Carregando Informações...")

		if ((cTabTMP)->ZBLOQ = '1')                                                                              // PEDIDO BLOQUEADO POR REGRA DO COMERCIAL
			cTMPSTATUS := "9"
		elseif ( (cTabTMP)->NOTA=' ') .AND. ((cTabTMP)->ZFATBLQ = '3') .AND. ((cTabTMP)->ZMOTREJ =' ')           // ABERTO
			cTMPSTATUS := "2"
		elseif ((cTabTMP)->NOTA=' ') .AND.  ((cTabTMP)->ZFATBLQ = ' ') .AND. ((cTabTMP)->ZMOTREJ =' ')           // PEDIDO VENDA LIBERADO
			cTMPSTATUS := "3"
		elseif ((cTabTMP)->ZFATBLQ = '1') .AND.  !('XXXX' $ (cTabTMP)->NOTA )                                    // PEDIDO FATURADO TOTALMENTE
			cTMPSTATUS := "4"
		elseif ((cTabTMP)->ZFATBLQ = '2') .AND.  !('XXXX' $ (cTabTMP)->NOTA)                                     // PEDIDO FATURADO PARCIALMENTE
			cTMPSTATUS := "5"
		elseif ('XXXX' $ (cTabTMP)->NOTA) .AND. ( (cTabTMP)->ZFATBLQ = '3' .OR.  Empty((cTabTMP)->ZFATBLQ))      // PEDIDO CANCELADO
			cTMPSTATUS := "6"
		elseif ( (cTabTMP)->NOTA $ 'XXXX') .AND. ( (cTabTMP)->ZFATBLQ $ '1/2')                                   // PEDIDO ELIMINADO POR RESIDUO
			cTMPSTATUS := "7"
		elseif (!Empty( (cTabTMP)->ZMOTREJ )) .AND. !('XXXX' $(cTabTMP)->NOTA) .AND. ((cTabTMP)->ZFATBLQ == ' ') // Pedido REJEITADO PELO FINANCEIRO
			cTMPSTATUS := "8"
		Endif

		aAdd(aTMP, {;
			.F.,;
			cTMPSTATUS,;
			(cTabTMP)->PEDIDO,;
			(cTabTMP)->ITEM,;
			(cTabTMP)->PRODUTO,;
			(cTabTMP)->DESCRICAO,;
			(cTabTMP)->QUANTIDADE,;
			(cTabTMP)->SALDO,;
			stod((cTabTMP)->ENTREGA1),;
			stod((cTabTMP)->ENTREGA2),;
			(cTabTMP)->PEDCOMPRA,;
			(cTabTMP)->LOCAL,;
			IIF( cEmpAnt == "01",(cTabTMP)->RECURSO,""),;
			(cTabTMP)->CLIENTE,;
			(cTabTMP)->LOJA,;
			(cTabTMP)->REG})

		(cTabTMP)->( dbSkip() )
	EndDo

	FileClose()

	oListPedidos:SetArray(aTMP)
	oListPedidos:bLine := {|| {IIf(	aTMP[oListPedidos:nAt,01],oOK, oNO),;
		GetStatus(aTMP[oListPedidos:nAt,02]),;
		aTMP[oListPedidos:nAt,03],;
		aTMP[oListPedidos:nAt,04],;
		aTMP[oListPedidos:nAt,05],;
		aTMP[oListPedidos:nAt,06],;
		aTMP[oListPedidos:nAt,07],;
		aTMP[oListPedidos:nAt,08],;
		aTMP[oListPedidos:nAt,09],;
		aTMP[oListPedidos:nAt,10],;
		aTMP[oListPedidos:nAt,11],;
		aTMP[oListPedidos:nAt,12],;
		aTMP[oListPedidos:nAt,13],;
		aTMP[oListPedidos:nAt,14],;
		aTMP[oListPedidos:nAt,15],;
		aTMP[oListPedidos:nAt,16];
		} }
	oListPedidos:nAt := 1

FechaTMP(cTabTMP)

Return


static Function FileClose()
	Local cQry := "Drop View MNTVENDA"

	tcSQLexec(cQry) < 0   //para verificar se a query funciona

Return
