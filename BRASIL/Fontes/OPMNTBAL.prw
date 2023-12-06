#INCLUDE "PROTHEUS.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "TOPCONN.CH"
#include "tryexception.ch"

#Define MODULE_PIXEL_SIZE 12
#Define  lAdjustToLegacy  .F.
#Define  lDisableSetup    .T.

#Define CLR_VERMELHO  RGB(255,048,048)	//Cor Vermelha
#Define CLR_AZUL	  RGB(058,074,119)	//Cor Azul

Static cPath    := "\arquivos\seb\imagens\"
Static lImprime := .F.
Static lValidOK := .F.
Static lVldEtq  := .F.

/*/{Protheus.doc} OPMNTBAL
description
Rotina Manutenção Peso para emissão Etiqueta
@type function
@version 
@author Valdemir Jose
@since 24/07/2020
@return return_type, return_description
 u_OPMNTBAL
/*/
USER FUNCTION OPMNTBAL()
	Local oFont1     := TFont():New("Arial",,025,,.T.,,,,,.F.,.F.)
	Local oFont2     := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
	Local oFCodBar 	 := TFont():New("MS Sans Serif",,060,,.T.,,,,,.F.,.F.)
	Local oFntMsg    := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
	Local oFntStatus := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	Local oFontAlert := TFont():New("Arial",,014,,.T.,,,,,.F.,.F.)
	Local oGetProd
	Local oGPCXCH
	Local oGPCXV
	Local oGTFim
	Local oGTIni
	Local oPCXV
	Local oSay1
	Local oSay4
	Local oSPsCxCheia
	Local oSToler
	Local oGPesPC
	Local nCarrega      := 0

	Local nTop          := 0
	Local nLeft         := 0
	Local nBottom       := 0
	Local nRight        := 0
	Local aSize         := {}
	Local aObjects      := 0
	Local nColAju       := 15
	Local bSavKeyF12    := SetKey(VK_F12, NIL)
	Local bSavKeyF2     := SetKey(VK_F2, NIL)
	Local bWhn          := {}
	Local bVld          := {}
	Local bChge         := {}
	Local lHasButton    := .T.

	Private nHdl        := GetFocus()
	Private oGQtdPCx
	Private oBtFechar
	Private lPisca      := .F.
	PRIVATE lGet        := .F.
	Private oGetCodBar
	Private oPesoAtu
	Private oPDesProd
	Private cGetCodBar  := SPACE(15)
	Private cGetProd    := CriaVar("B1_COD",.F.)
	Private cDesProd    := ""
	Private nGPCXCH     := 0
	Private nGPCXV      := 0
	Private nGQtdPCx    := 0
	Private nGTFim      := 0
	Private nGTIni      := 0
	Private nGPesPC     := 0
	Private cGetPesoAtu := 0
	Private cStatus     := ""
	Private cCodProd    := ''
	Private nPesVaz     := 0
	Private nPesChe     := 0
	Private nPesPca     := 0
	Private nGTPer      := 0
	Private nPesoTMP    := 0
	Private aCoordenadas:= MsAdvSize(.T.)

	Private oPanelEsq   := Nil
	Private oPanelDir   := Nil
	Private oPanelCNT   := Nil
	Private oPnlINF1    := Nil
	Private oPnlINF2    := Nil
	Private oPnlINF3    := Nil
	Private oSayMsg     := NIL
	Private cMensage    := ""
	Private oTimer
	Private oTBitmap
	Private cImagem
	Private cKeyUser    := GetMV("ST_KEYUSRB",.F.,"001036/000039/001289/000010/000645/000597")

	Static oDlg

	bWhn   := { || vdNQtdCX(cKeyUser) }
	bVld   := { || oTimer:Activate(), oGQtdPCx:bWhen := {|| .F.}, oPesoAtu:SetFocus() }
	bChge  := { || .T. }

	cEstiloNom := "QLineEdit{ color: #00FF00;border: 1px solid gray;border-radius: 5px;background-color: #000000;selection-background-color: #000000;"
	cEstiloNom += "background-repeat: no-repeat;"
	cEstiloNom += "background-attachment: fixed;"
	cEstiloNom += "padding-left:25px; "
	cEstiloNom += "}"

	cEstiloNo2 := "QLineEdit{ color: #FFFF00;border: 1px solid gray;border-radius: 5px;background-color: #000000;selection-background-color: #000000;"
	cEstiloNo2 += "background-repeat: no-repeat;"
	cEstiloNo2 += "background-attachment: fixed;"
	cEstiloNo2 += "padding-left:25px; "
	cEstiloNo2 += "}"

	cCssRet := "QPushButton {"
	cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
	cCssRet += "}"

	cCssLim := "QPushButton {"
	cCssLim += " color:#fff;background-color:#FF0000;border-color:#FF0000 "
	cCssLim += "}"

	cCssVid := "QPushButton {"
	cCssVid += " color:#fff;background-color:#00ff00;border-color:#FF0000 "
	cCssVid += "}"

	cCSSPri := "QPushButton { color:#f0fff0;background-color:#f7c23f;border-color:#f7c23f }"

	nGTPer      := SuperGetMV("ST_PESTOLE",.f.,5)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Pesagem") FROM aCoordenadas[7],000 To aCoordenadas[6],aCoordenadas[5] COLORS 0,16772829 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

	MntTela(oDlG)

	nLin := 10

	@ nLin, 009 MSGET oGetCodBar VAR cGetCodBar  VALID VLDCODBAR() WHEN WCodBar() SIZE 280, 050 OF oPanelEsq   COLORS CLR_GREEN, CLR_BLACK   FONT oFCodBar PIXEL
	@ nLin, 009 MSGET oPesoAtu   VAR cGetPesoAtu WHEN GetBalan(@nCarrega)  SIZE 280, 050 OF oPanelDir   COLORS 0, 4259584 FONT oFCodBar PIXEL
	oGetCodBar:SetCSS( cEstiloNom  )
	oPesoAtu:SetCSS( cEstiloNo2 )
	@ nLin, 010+nColAju SAY oSay1        PROMPT "Produto"            SIZE 025, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	@ nLin, 065+nColAju MSGET oGetProd   VAR cGetProd    SIZE 060, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL

	oTBitmap  := tBitmap():New(nLin-9, 435, 234, 124,, cImagem, .T., oPanelCNT,;
		{||Alert("Clique em TBitmap1")},,.F.,.F.,,,.F.,,.T.,,.F.)
	oTBitmap:lStretch:= .T.

	//@ nLin+9, 280+nColAju BUTTON oBtVldEmb  PROMPT "Valida 1ª Embalag."  SIZE 060, 014 OF oPanelCNT ACTION getVldEmb() PIXEL     // Valdemir Rabelo 04/01/2021 Ticket: 20201116010613
	@ nLin+9, 340+nColAju BUTTON oBtVideoJ  PROMPT "Enviar p/ videojet"  SIZE 060, 014 OF oPanelCNT ACTION ImpVideoJ() PIXEL
	@ nLin-9, 310+nColAju SAY oBtPegPes     PROMPT "Editar Qtde < F2 >"  SIZE 060, 014 OF oPanelCNT COLOR CLR_RED,16777215 FONT oFontAlert PIXEL
	@ nLin,   310+nColAju SAY oBtPegPes     PROMPT "Pegar Peso < F12 >"  SIZE 060, 014 OF oPanelCNT COLOR CLR_RED,16777215 FONT oFontAlert PIXEL

	nLin += 12
	@ nLin, 010+nColAju SAY oPDesProd    PROMPT cDesProd SIZE 450, 20 OF oPanelCNT COLORS CLR_BLUE, 16777215 FONT oFont1 CENTERED  PIXEL // (nRight*0.5)-490
	nLin += 27
	@ nLin, 280+nColAju SAY oPCXV        PROMPT "Peso Caixa Vazia"   SIZE 055, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	@ nLin, 360+nColAju MSGET oGPCXV     VAR nGPCXV   Picture "@E 999999.999"   SIZE 045, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL
	@ nLin, 010+nColAju SAY oSay4        PROMPT "Qtde.P/Caixa"       SIZE 045, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL

	oGQtdPCx := TGet():New( nLin, 065+nColAju, { | u | If( PCount() == 0, nGQtdPCx, nGQtdPCx := u ) },oPanelCNT, ;
		046, 010, "@E 999999.999",bVld, 0, 16777215,,.F.,,.T.,,.F.,bWhn,.F.,.F.,bChge,.F.,.F. ,,"nGQtdPCx",,,,lHasButton  )
	nLin += 17
	@ nLin, 280+nColAju SAY oSPsCxCheia  PROMPT "Peso Caixa Cheia"   SIZE 060, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	@ nLin, 360+nColAju MSGET oGPCXCH    VAR nGPCXCH  Picture "@E 999999.999" SIZE 045, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL
	@ nLin, 010+nColAju SAY oSToler      PROMPT "Tolerância"         SIZE 045, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	@ nLin, 065+nColAju MSGET oGTIni     VAR nGTIni          SIZE 045, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL
	@ nLin, 118+nColAju MSGET oGTFim     VAR nGTFim          SIZE 043, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL
	@ nLin, 163+nColAju MSGET oGTPer     VAR nGTPer  Picture "@E 999" SIZE 025, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL
	@ nLin, 189+nColAju SAY oSTPer       PROMPT "%"          SIZE 010, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	nLin += 17
	@ nLin, 010+nColAju BUTTON oBtLimpa PROMPT "Resetar"    SIZE 060, 014 OF oPanelCNT ACTION Limpa() PIXEL
	@ nLin, 280+nColAju SAY oSPsPca     PROMPT "Peso Peça"  SIZE 060, 007 OF oPanelCNT COLORS 0, 16777215 FONT oFont2 PIXEL
	@ nLin, 360+nColAju MSGET oGPesPC    VAR nGPesPC  Picture "@E 999999.999" SIZE 045, 010 OF oPanelCNT COLORS 0, 16777215 WHEN .F. FONT oFont2 PIXEL

	@ 001, 002 SAY oSay5        PROMPT "Status Contagem: "  SIZE 090, 008 OF oPnlINF1 COLORS 0, 16777215 FONT oFont2 PIXEL
	@ 010, 025 SAY oSayStatus   PROMPT cStatus     SIZE 090, 015 OF oPnlINF1 COLORS CLR_GREEN, 16777215 FONT oFntStatus PIXEL
	@ 008, 002 SAY oSayMsg      PROMPT cMensage    SIZE 210, 007 OF oPnlINF2 CENTER COLORS CLR_RED, 16777215 FONT oFntMsg PIXEL
	@ 000, 010 BUTTON oBtFechar PROMPT "Processar" SIZE 076, 024 OF oPnlINF3 ACTION btProcess() PIXEL
	oBtFechar:SetCSS( cCssRet )
	oBtLimpa:SetCSS( cCssLim )
	oBtVideoJ:SetCSS( cCssVid )
	//oBtVldEmb:SetCSS( cCSSPri )
	oGetCodBar:SetFocus()
	nHdl        := GetFocus()

	nMilissegundos := GetMv("OPMNTBAL2",,3000) 								// Disparo será de 3 em 3 segundos
	oTimer := TTimer():New(nMilissegundos, {|| TimeBlink() }, oDlg )
	oTimer:Activate()

	ACTIVATE MSDIALOG oDlg CENTERED

RETURN

/*/{Protheus.doc} Limpa
description
Reseta dados para nova leitura
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return sem retorno
/*/
Static Function Limpa()
	nPesVaz     := 0
	nPesChe     := 0
	nPesPca     := 0
	cCodProd    := ""
	cStatus     := ""
	cGetProd    := CriaVar("B1_COD",.F.)
	cDesProd    := ""
	nGPCXCH     := 0
	nGPCXV      := 0
	nGPesPC     := 0
	nGQtdPCx    := 0
	lValidOK    := .F.
	lVldEtq     := .F.

	cGetCodBar  := Space(15)
	nGTFim      := 0
	nGTIni      := 0
	cGetPesoAtu := 0
	cMensage    := ""
	SetKey(VK_F2, nil)
	SetKey(VK_F12, nil)
	oDlg:Refresh()
	oGetCodBar:SetFocus()
Return

/*/{Protheus.doc} btProcess
description
Rotina de Processamento após validação
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
Static Function btProcess()
	Local lRET := .T.

	if lRET
		if (cGetPesoAtu > nPesPca)
			lRET := VLDPESAT()
			if !lRET
				cStatus := "REPROVADO"
				oSayStatus:NCLRTEXT := CLR_RED
				cGetPesoAtu := 0       // Valdemir 05/10/2020
			else
				cStatus := "APROVADO"
				oSayStatus:NCLRTEXT := CLR_GREEN
				cMensage := ""
			endif
		Endif
		oSayStatus:Refresh()
	Endif
	oSayMsg:Refresh()
	oPesoAtu:SETFOCUS()
Return


/*/{Protheus.doc} MntTela
description
Monta tela Interface
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@param poDlG, param_type, param_description
@return Sem Retorno
/*/
Static Function MntTela(poDlG)
	Local oLayer := NIL

	oLayer := FWLayer():New()

	// LINHAS
	oLayer:Init(poDlG, .f.)
	oLayer:addLine("TOP", 030,.F.)
	oLayer:addLine("CORPO", 050,.F.)
	oLayer:addLine("RODAPE",020,.F.)

	// COLUNAS
	oLayer:addCollumn("COL_TOP1",50,.f.,"TOP")          // COLUNAS LINHA1
	oLayer:addCollumn("COL_TOP2",50,.f.,"TOP")          // COLUNAS LINHA1
	oLayer:addCollumn("COL_CORPO", 100,.f.,"CORPO")     // COLUNAS LINHA2
	oLayer:addCollumn("COL1_RODAPE",30,.f.,"RODAPE")    // COLUNAS LINHA3
	oLayer:addCollumn("COL2_RODAPE",50,.f.,"RODAPE")    // COLUNAS LINHA3
	oLayer:addCollumn("COL3_RODAPE",20,.f.,"RODAPE")    // COLUNAS LINHA3

	// JANELAS
	oLayer:AddWindow( "COL_TOP1", "WinBar",  "Codigo Barra", 100, .T., .F.,/*bAction*/,"TOP",/*bGotFocus*/)
	oLayer:AddWindow( "COL_TOP2", "WinPes",  "Peso Atual",   100, .T., .F.,/*bAction*/,"TOP",/*bGotFocus*/)

	oLayer:AddWindow( "COL_CORPO",  "WinDados", "Dados",    100, .T., .F.,/*bAction*/,"CORPO",/*bGotFocus*/)
	oLayer:AddWindow( "COL1_RODAPE", "WinInf1", "Conferência",  100, .T., .F.,/*bAction*/,"RODAPE",/*bGotFocus*/)
	oLayer:AddWindow( "COL2_RODAPE", "WinInf2", "Mensagens"  ,  100, .T., .F.,/*bAction*/,"RODAPE",/*bGotFocus*/)
	oLayer:AddWindow( "COL3_RODAPE", "WinInf3", "Ação" ,  100, .T., .F.,/*bAction*/,"RODAPE",/*bGotFocus*/)

	oPanelEsq := oLayer:GetWinPanel('COL_TOP1','WinBar',  "TOP" )
	oPanelDir := oLayer:GetWinPanel('COL_TOP2','WinPes',  "TOP" )
	oPanelCNT := oLayer:GetWinPanel('COL_CORPO','WinDados',"CORPO" )
	oPnlINF1  := oLayer:GetWinPanel('COL1_RODAPE','WinInf1',  "RODAPE" )
	oPnlINF2  := oLayer:GetWinPanel('COL2_RODAPE','WinInf2',  "RODAPE" )
	oPnlINF3  := oLayer:GetWinPanel('COL3_RODAPE','WinInf3',  "RODAPE" )

Return

/*/{Protheus.doc} VldCodBar
description
Rotina que fará a validação do código de barra, se auto 
identificando se é uma OP ou código Produto
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return lógico
/*/
Static Function VldCodBar()
	Local lRET     := .T.
	Local nTMP     := 0
	//Local aAreaP   := GetArea()
	Local aLeitura := Separa(cGetCodBar, "|")

	if !Empty(cGetCodBar)

		if Len(aLeitura) == 3

			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			lRET   := SC2->(dbSeek(XFilial("SC2")+aLeitura[1]+aLeitura[2]+aLeitura[3]))
			if lREt
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				lRET   := SB1->(dbSeek(xFilial('SB1')+SC2->C2_PRODUTO))

				if lREt
					VldAtuBar()
				else
					cMensage := 'PRODUTO NÃO ENCONTRADO!'
					cGetCodBar := Space(15)
				Endif
			Else
				cMensage := 'ORDEM PRODUÇÃO NÃO ENCONTRADO!'
				cGetCodBar := Space(15)
			Endif

		else
			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			lRET   := SC2->(dbSeek(XFilial("SC2")+cGetCodBar))
			if lREt
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				lRET   := SB1->(dbSeek(xFilial('SB1')+SC2->C2_PRODUTO))

				if lREt
					VldAtuBar()
				else
					cMensage := 'PRODUTO NÃO ENCONTRADO!'
					cGetCodBar := Space(15)
				Endif
			Else
				lRET   := .F.                       // Removido consideração de código de produto devido a necessidade
				dbSelectArea("SB1")               // do numero da OP nas etiquetas - Ticket: 20201116010613 - 18/11/2020
				SB1->(dbSetOrder(1))
				lRET   := SB1->(dbSeek(xFilial('SB1')+cGetCodBar))
				if lRET
					VldAtuBar()
				else
					cMensage   := 'CÓDIGO DE BARRA INVÁLIDO!'
					cGetCodBar := Space(15)
				Endif
			endif
		endif

	Endif

	if lRET
		oTimer:Activate()
	endif

	if !Empty(cMensage)
		oSayMsg:Refresh()
	Endif

	//RestArea( aAreaP )

Return lRET


/*/{Protheus.doc} VldAtuBar
description
Valida Atualização dos Pesos
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
Static Function VldAtuBar()

	ZA2->(RecLock("ZA2",.T.))
	ZA2->ZA2_FILIAL := cFilAnt
	ZA2->ZA2_USER   := __cUserID
	ZA2->ZA2_DATA   := Date()
	ZA2->ZA2_HORA   := Time()
	ZA2->ZA2_PROD   := SB1->B1_COD
	ZA2->ZA2_COMP	:= GetComputerName()
	ZA2->ZA2_STATUS := "0"
	ZA2->(MsUnLock())

	cGetProd    := SB1->B1_COD
	cDesProd    := SB1->B1_DESC

	// Valdemir Rabelo 16/11/2020 - Ticket:  20201116010613
	if !Empty(SB1->B1_XPROTHU)
		IF FILE("\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".png")
			cImagem := "\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".png"
		else
			if FILE("\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".bmp")
				cImagem := "\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".bmp"
			else
				if FILE("\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".jpg")
					cImagem := "\arquivos\seb\imagens\"+alltrim(SB1->B1_XPROTHU)+".jpg"
				endif
			endif
		Endif
		oTBitmap:cBmpFile := cImagem
		oTBitmap:Refresh()
	ENDIF

	IF SB1->B1_XPSCXVA > 0
		nPesVaz := SB1->B1_XPSCXVA
	endif
	if SB1->B1_XPSCXCH > 0
		nPesChe := SB1->B1_XPSCXCH
	Endif
	nGPCXV      := nPesVaz
	nGPCXCH     := nPesChe              //
	nGPesPc     := nPesPca
	nGQtdPCx    := SB1->B1_XQTYMUL     // Valdemir Rabelo 07/10/2020
	CalToler()

	IF (cCodProd != cGetProd)
		nPesVaz := 0
		nPesChe := 0
		nPesPca := 0
		lValidOK:= .F.
		lVldEtq := .F.
		IF SB1->B1_XPSCXVA > 0
			nPesVaz := SB1->B1_XPSCXVA
			if SB1->B1_XPSCXCH > 0
				nPesChe := SB1->B1_XPSCXCH
				if (nPesPca==0)
					cMensage := 'COLOQUE A PEÇA NA BALANÇA'
				else
					cMensage := 'COLOQUE A CAIXA CHEIA NA BALANÇA'
				endif
			Else
				cMensage := 'COLOQUE A CAIXA CHEIA NA BALANÇA'
			Endif
		Else
			cMensage := "POR FAVOR COLOQUE A CAIXA VAZIA NA BALANÇA"
		endif
		if !lValidOK
			cMensage := "POR FAVOR VALIDE A EMBALAGEM FLOWPACK"
		Endif
		oSayMsg:Refresh()
	else
		cMensage    := ''
	Endif
	cGetPesoAtu := 0
	cStatus     := ''
	oPDesProd:Refresh()
	oDlg:Refresh()
	oPesoAtu:SetFocus()

Return

/*/{Protheus.doc} VLDPES
description
Rotina de validação de peso
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
Static Function VLDPES()
	Local lRET     := .t.
	Local nTMP     := 0

	if !Empty(cGetProd)
		if !Empty(cGetPesoAtu)
			IF (cCodProd != cGetProd)
				lRET := .f.
				if (nPesVaz == 0)
					nPesVaz     := cGetPesoAtu
					nGPCXV      := nPesVaz
					cGetPesoAtu := 0
				endif
				if (nPesChe == 0)
					nPesChe     := cGetPesoAtu
					nGPCXCH     := nPesChe
					cGetPesoAtu := 0
				endif
				if (nPesPca == 0)
					nPesPca     := cGetPesoAtu
					nGPesPC     := nPesPca
					cGetPesoAtu := 0
				Endif
				if (nPesVaz > 0) .and. (nPesChe > 0) .and. (nPesPca > 0)
					CalToler()
					cCodProd := cGetProd
					lRET     := .T.
					oBtFechar:SetFocus()
				Else
					oPesoAtu:Refresh()
					oPesoAtu:SetFocus()
				endif

				TrataMsg()

				oSayMsg:Refresh()
			Endif
		Endif

		if lRET
			lGet := .F.
		endif
	Endif
	oPesoAtu:Refresh()

Return lRET

/*/{Protheus.doc} CalToler
description
Realiza o calculo da tolerancia
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
Static Function CalToler()
	Local nResPC := 0
	Local nPerTol:= 0
	Local nPesTol:= 0

	IF SB1->B1_XTOPESI > 0
		nPerTol :=  SB1->B1_XTOPESI
	ELSE
		nPerTol     := 50/100
	ENDIF

	nPesTol     := nPesPca * nPerTol

	nGTIni      := (nPesChe-nPesTol)
	nGTFim      := (nPesChe+nPesTol)

Return


/*/{Protheus.doc} TrataMsg
description
Rotina de tratamento de mensagem
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
Static Function TrataMsg()

	if (nPesVaz == 0) .and. (nPesChe == 0) .and. (nPesPca == 0)
		cMensage := 'COLOQUE A CAIXA VAZIA NA BALANÇA'
	ELSEIF (nPesVaz > 0) .and. (nPesChe == 0) .and. (nPesPca == 0)
		cMensage := 'COLOQUE A CAIXA CHEIA NA BALANÇA'
	ELSEIF  (nPesVaz > 0) .and. (nPesChe > 0) .and. (nPesPca == 0)
		cMensage := 'COLOQUE A PEÇA NA BALANÇA'
	ELSE
		//cMensage := 'PESAGEM ATUAL ==> CLIQUE EM PROCESSAR'
		cMensage := 'COLOQUE A CAIXA CHEIA NA BALANÇA'
	Endif

Return

/*/{Protheus.doc} VLDPESAT
description
@type function
@version 
@author Valdemir Jose
@since 13/08/2020
@return return_type, return_description
/*/
STATIC FUNCTION VLDPESAT()
	LOCAL lRET := .T.

	if cGetPesoAtu > 0

		lRET := (nPesVaz != 0)
		if !lRET
			cMensage := "PRECISA SER INFORMADO O PESO DA CAIXA VAZIA"
		Endif
		lRET := (nPesChe != 0)
		if !lRET
			cMensage := "PRECISA SER INFORMADO O PESO DA CAIXA CHEIA"
		Endif
		lRET := (nGTIni != 0)
		if !lRET
			cMensage := "NÃO FOI INFORMADO A TELERANCIA MINIMA"
		Endif
		lRET := (nGTFim != 0)
		if !lRET
			cMensage := "NÃO FOI INFORMADO A TOLERANCIA MAXIMA"
		Endif

		if lRET
			lRET := (cGetPesoAtu >= nGTIni) .AND. (cGetPesoAtu <= nGTFim)
			if lRET    // Emite a Etiqueta
				cMensage := "INICIADA IMPRESSÃO ETIQUETA"

				ZA2->(RecLock("ZA2",.T.))
				ZA2->ZA2_FILIAL := cFilAnt
				ZA2->ZA2_USER   := __cUserID
				ZA2->ZA2_DATA   := Date()
				ZA2->ZA2_HORA   := Time()
				ZA2->ZA2_PROD   := SB1->B1_COD
				ZA2->ZA2_COMP	:= GetComputerName()
				ZA2->ZA2_STATUS := "1"
				ZA2->(MsUnLock())

				if !lImprime

					FWMsgRun(,{|| OPETQPROC() },'Aguarde','Imprimindo Etiqueta')

					// --------------- Valdemir Rabelo 05/01/2021 Ticket: 20201116010613 ---------------------
					if (!lVldEtq)
						lVldEtq := .T.
						lRet := getVldEmb("Faça leitura código barra - Embalagem Individual")
						if !lRET
							return lRET
						endif
					endif
					// ----------------------
				Endif
				// ---------------- Valdemir Rabelo 16/11/2020 Ticket: 20201116010613 --------------
				lImprime := .T.			// Já imprimiu a etiqueta
				// ----------------
				cMensage := ""
			else
				if cGetPesoAtu < nGTIni
					cMensage := "O PESO INFORMADO ESTÁ MENOR QUE A TOLERÊNCIA MINIMA"
					lRet := .F.
				endif
				if (cGetPesoAtu > nGTFim)
					cMensage := "O PESO INFORMADO ESTÁ MAIOR QUE A TOLERÊNCIA MAXIMA"
					lRet := .F.
				endif
			endif
		Endif

	Endif

	oPesoAtu:Refresh()
	oDlg:Refresh()

RETURN lRET


//--------------------------------------------------------------
	/*/{Protheus.doc} Function TimeBlink
	Description
	Rotina para apresentar intermitencia no objeto de cubage
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/11/2019
	/*/
//--------------------------------------------------------------
Static Function TimeBlink()

	FWMsgRun(,{|| ComBal()},"Informação","Aguarde,, pegando peso.")

	if  (cGetPesoAtu != 0)    // Valdemir 05/10/2020 (cMensage == 'PESAGEM ATUAL ==> CLIQUE EM PROCESSAR') .and.

		IF (cGetPesoAtu > 0) .AND. (nPesPca > 0) .and. (nGTIni > 0) .AND. (nGTFim > 0)
			IF (cGetPesoAtu > nPesPca) .and. (cGetPesoAtu >= nGTIni) .AND. (cGetPesoAtu <= nGTFim)
				btProcess()          // Valdemir 05/10/2020
				cStatus := "APROVADO"
				oSayStatus:NCLRTEXT := CLR_GREEN
				cMensage := ""
			else
				if cGetPesoAtu < nGTIni
					cMensage := "O PESO INFORMADO ESTÁ MENOR QUE A TOLERÊNCIA MINIMA"
					cStatus  := "REPROVADO"
					oSayStatus:NCLRTEXT := CLR_RED
					cGetPesoAtu := 0       // Valdemir 05/10/2020
					lRet := .F.
				else
					if (cGetPesoAtu > nGTFim)
						cMensage := "O PESO INFORMADO ESTÁ MAIOR QUE A TOLERÊNCIA MAXIMA"
						oSayStatus:NCLRTEXT := CLR_RED
						cGetPesoAtu := 0       // Valdemir 05/10/2020
						lRet := .F.
					else
						TrataMsg()
					Endif
				endif
				lGet := .T.
			Endif
			oSayStatus:Refresh()
			oPesoAtu:Refresh()
		Endif
	else                              // Se o peso foi zerado, altero a variavel para .F.
		lImprime := .F.                // Valdemir Rabelo 17/11/2020 Ticket: 20201116010613
	Endif

	// Verifica se para o timer, caso entre no campo codigo barra
	if (nHdl == GetFocus())
		oTimer:DeActivate()
	Endif

	if !Empty(cMensage)

		If lPisca
			lPisca := .f.
			oSayMsg:Hide()
		Else
			lPisca := .t.
			oSayMsg:Show()
		EndIf

	Endif

	oSayMsg:Refresh()
	oPesoAtu:Refresh()
	oSayStatus:Refresh()

Return .T.


Static Function GetBalan(nCarrega)
	Local bSavKeyF12 := {|| getPegaPes() }
	if (nCarrega==1)
		lGet := .t.
		ComBal()
		SetKey(VK_F12, bSavKeyF12,"Pegando peso")
	endif
	nCarrega := 1
Return .T.







// u_TstEtiq
User Function TstEtiq(_cProd1)
	//Local cVld := u_getLista()
	/*
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(XFilial('SC2')+'00058901001')
	*/
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+'S3B72010'))      //S3B72465 - S70117324H / S70110304V - SC2->C2_PRODUTO


	//ComBal()
	//Unschime()
	//A4940502()
	//INIEAV8525()         // Vertical EAV8525400
	//V9130400()       	   // Horizontal - Convertido
	//EAV14597()           // EAV1459702 - Flow Packs
	//HRB8045002()         // HRB8045002 - Flow Packs
	//INIQGH5230()         // QGH5230900 - Flow Packs
	//A4940502()
	//u_TSTFlow4()
	//if !Empty(cVld)
	// &(cVld)
	//endif   
	u_ExecEtiq("HRB1068")


Return



Static Function ComBal()
	Local cCfg    := GetMV("ST_CFGBALA",,"COM5:9600,n,8,1")
	Local cBuffer := ""
	Local nH      := 0
	Local _cPeso
	Local lRET    := .F.
	Local ncont
	Local lDesenv := .T.    // Mudar ao finalizar trabalho

	if lDesenv
		cCFG := "COM3:9600,n,8,1"
	Endif
	lRet := msOpenPort(nH, cCfg)
	if(!lRet)
		Alert('Ocorreu problemas com a comunicação com a balança')
		Return
	EndIf

	msWrite(nH, Chr(5))
	Sleep(200)

	For ncont := 1 To 20
		msRead(nH, @cBuffer)
		if(!Empty(cBuffer))
			cPeso :=FwNoAccent(cBuffer)           // IsNumber função que criei para tirar os caracteres especiais                            cBuffer := “”
			Exit
		EndIf
	Next
	msClosePort(nH)

	cPeso       := Substr(cBuffer,2,Len(cBuffer)-2)
	cPeso       := Substr(cPeso,1,Len(cPeso)-3)+"."+Right(cPeso,3)
	cGetPesoAtu := val(cPeso)
	oPesoAtu:Refresh()

Return

/*/{Protheus.doc} getPegaPes
description
Rotina para pegar o peso atraves de botão ou tecla de atalho
@type function
@version 
@author Valdemir Jose
@since 07/10/2020
@return return_type, return_description
/*/
Static Function getPegaPes()
	if lValidOK
		VLDPES()
	else
		MsgInfo("Só pode pegar a pesagem após validação da FlowPack","Atenção!")
	Endif

Return


/*/{Protheus.doc} INIV913040
description
Imprime Etiqueta Orion Horizontal - EAV9130400
@type function
@version 
@author Valdemir Rabelo
@since 11/08/2020
@return return_type, return_description
/*/
Static Function INIEAV9130(oPrinter)
	Local _nQtde       := 1 // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx       //SB1->B1_XQTYMUL - Trocado Valdemir 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHDE4
	Local _cDesSpan    := SB1->B1_XSHDE5
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cPais       := SB1->B1_XFROM // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1 // POSICAO 29
	Local _cDtProducao := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))+" "+Left(Time(),5)
	Local _cNUMOP      := "OP: "+ALLTRIM(SC2->C2_NUM)
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cDiagEletr  := ""
	Local _cRohs       := alltrim(SB1->B1_XROHLOG)
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := alltrim(SB1->B1_XPROTHU)
	Local cCodBar      := Alltrim(if(Empty(SB1->B1_XEAN14),SB1->B1_XEAN14,SB1->B1_XEAN14))
	Local _cLogo       := "logosebh"
	Local oFont5b      := TFont():New("Arial", , 5 , .T.,.T.)
	Local oFont6       := TFont():New("Arial", , 6 , .T.,.T.)
	Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
	Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
	Local oFont11      := TFont():New("Arial", , 11, .T., .F.)
	Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
	Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)
	Local oFont14b     := TFont():New("Arial", , 14, .T., .T.)
	Local nLin         := 0
	Local nCol         := -25

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin += 20
	oPrinter:Say(nLin, nCol+040, _cProd,             oFont14b)
	oPrinter:Say(nLin, nCol+180, cValToChar(_cQtde), oFont10b)
	oPrinter:Say(nLin, nCol+196, "X",                oFont10b)
	oPrinter:Say(nLin, nCol+208, cValToChar(_cQtdeV),oFont13b)
	oPrinter:Say(nLin, nCol+220, "=",                oFont13b)
	oPrinter:Say(nLin, nCol+235, _cQtdeT,            oFont13b)
	nLin += 6
	oPrinter:Line( nLin, nCol+035, nLin, 250, , "-9")
	nLin += 6.5
	oPrinter:Say(nLin, nCol+040, _cDesPort, oFont6)             // Desc.Portugues
	oPrinter:Say(nLin, nCol+185, _cPais, oFont6)
	if !Empty(_cRohs)
		oPrinter:SayBitmap ( nLin-3.1,nCol+235, cPath+_cRohs+".png", 10, 10 )
	Endif
	nLin += 7
	oPrinter:Say(nLin, nCol+040, _cDesSpan, oFont6)             // Desc. Spanhol
	oPrinter:Say(nLin, nCol+185, "Hecho en Brasil", oFont6)
	nLin += 7
	oPrinter:Line( nLin-5.7, nCol+185, nLin-5.7, 250, , "-9")
	oPrinter:Say(nLin, nCol+040, _cDesEngl, oFont6)             // Desc.English
	oPrinter:Say(nLin, nCol+185, _cDtProducao, oFont6)
	oPrinter:Say(nLin, nCol+248, _cNUMOP, oFont5b)
	nLin += 7
	oPrinter:Line( nLin-5.5, nCol+185, nLin-5.5, 250, , "-9")
	oPrinter:Say(nLin+0.5, nCol+185, _cProd, oFont6)
	nLin += 2.5
	oPrinter:Line( nLin, nCol+035, nLin, 250, , "-9")
	nLin += 3
	// Adicionar imagem do Produto
	oPrinter:SayBitmap ( nLin+13, 165, cPath+_Imagem+".png", 50, 70 )
	nLin += 9
	oPrinter:Say(nLin, nCol+040, _cRange,   oFont11)             // Desc.English - _c2DadosTec

	If !Empty(SB1->B1_XTECHDE) .And. !AllTrim(SB1->B1_XTECHDE)=="-"
		oPrinter:Say(nLin, nCol+075, AllTrim(SB1->B1_XTECHDE), oFont6)
	EndIf

	If !Empty(SB1->B1_XTECHD2) .And. !AllTrim(SB1->B1_XTECHD2)=="-"
		oPrinter:Say(nLin+7, nCol+075, AllTrim(SB1->B1_XTECHD2), oFont6)
	EndIf

	If !Empty(SB1->B1_XDIAG1)
		oPrinter:SayBitmap ( nLin-10, nCol+160, cPath+AllTrim(SB1->B1_XDIAG1)+".png", 20, 20 )
	EndIf

	oPrinter:Say(nLin, nCol+185, _cCIP,     oFont10b)
	nLin += 10
	oPrinter:Line( nLin, nCol+035, nLin, 165, , "-9")
	// Adicionar Imagem do imntro

	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		oPrinter:SayBitmap ( nLin+1, nCol+039, cPath+"BV2.png", 32, 20 )
	EndIf

	If !Empty(SB1->B1_XNTCLOG) .And. !AllTrim(SB1->B1_XNTCLOG)=="-"
		oPrinter:SayBitmap ( nLin+1, nCol+075, cPath+"retiev.png", 25, 20 )  // Certificado
	EndIf

	If !Empty(SB1->B1_XCERING) .And. !AllTrim(SB1->B1_XCERING)=="-"
		oPrinter:SayBitmap ( nLin+1, nCol+105, cPath+"ingcerv.png", 25, 20 )  // Certificado
	EndIf

	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		oPrinter:SayBitmap ( nLin+1, nCol+135, cPath+"logo_mexicov.png", 25, 20 )  // Certificado
	EndIf

	nLin += 21
	oPrinter:Line( nLin, nCol+035, nLin, 165, , "-9")
	nLin += 6

	oPrinter:Code128( nLin, nCol+039 , cCodBar, 1.4,37,.T.,oFont6)
	oPrinter:SayBitmap ( 153, 080, cPath+_cLogo+".png", 90, 25 )  // 124.5
	oPrinter:Line( 152, nCol+035, 152, 250, , "-9")    //152

	oPrinter:EndPage()

Return
//------------------------------------------------------------------------------------------------------------------

/*/{Protheus.doc} E8525400
    (long_description)
    Etiqueta Orion Vertical EAV8525400 - Caixa Coletiva
    @type  Static Function
    @author user
    Valdemir Rabelo
    @since 04/09/2020
    @version version
/*/
Static Function INIEAV8525(oPrinter)
	Local _nQtde       := 1     // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx   //SB1->B1_XQTYMUL  Valdemir Rabelo - 07/10/2020                  // POSICAO 28
	Local _cQtdeV      := SB1->B1_XQTYUNT                    // POSICAO 27
	Local _cQtdeT      := cValToChar(_cQtde)         // POSICAO 02
	Local _cDesPort    := SB1->B1_XSHDE4                     // POSICAO 21
	Local _cDesSpan    := SB1->B1_XSHDE5                     // POSICAO 22
	Local _cDesEngl    := SB1->B1_XSHDE6                     // POSICAO 23
	Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
	Local _cDtProducao := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local _cNUMOP      := ALLTRIM(SC2->C2_NUM)
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cDiagEletr  := ""
	Local _cRohs       := alltrim(SB1->B1_XROHLOG)
	Local _cCIP        := SB1->B1_XCIP                      // POSICAO 20
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := alltrim(SB1->B1_XPROTHU)
	Local cCodBar      := alltrim(if(Empty(SB1->B1_XEAN14),SB1->B1_XEAN14,SB1->B1_XEAN14))
	Local _cLogo       := "logosebv"
	Local oFont5b      := TFont():New("Arial", , 5 , .T.,.T.)
	Local oFont6       := TFont():New("Arial", , 5 , .T.,.T.)
	Local oFont7       := TFont():New("Arial", , 7 , .T.,.F.)
	Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
	Local oFont11     := TFont():New("Arial", , 11, .T., .f.)
	Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
	Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)
	Local oFont14b     := TFont():New("Arial", , 13, .T., .T.)
	Local nLin         := 230
	Local nA           := 90

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin -= 10
	oPrinter:Say(010, nLin, _cProd,             oFont14b,,,nA)
	oPrinter:Say(118, nLin, cValToChar(_cQtde), oFont10b,,,nA)
	oPrinter:Say(132, nLin, "X",                oFont10b,,,nA)
	oPrinter:Say(141, nLin, cValToChar(_cQtdeV),oFont13b,,,nA)
	oPrinter:Say(150, nLin, "=",                oFont13b,,,nA)
	oPrinter:Say(158, nLin, _cQtdeT,            oFont13b,,,nA)

	nLin -= 6
	oPrinter:Line( 010, nLin, 175, nLin, , "-9")
	nLin -= 7.5

	oPrinter:Say(010, nLin,  _cDesPort, oFont6,,,nA)                          // Desc.Portugues - Ticket: 20210223002988 - Alterado Fonte 7 para 6 - 28/05/2021
	oPrinter:Say(125, nLin, _cPais, oFont6,,,nA)
	oPrinter:SayBitmap (163, nLin-6, cPath+_cRohs+".png", 10, 10 )
	nLin -= 9
	oPrinter:Say(010, nLin, _cDesSpan, oFont6,,,nA)                          // Desc. Spanhol
	oPrinter:Say(125, nLin, "Hecho en Brasil", oFont6,,,nA)
	nLin -= 9
	oPrinter:Line(125, nLin+5, 175, nLin+5,, "-9")
	oPrinter:Say(010, nLin, _cDesEngl, oFont6,,,nA)             // Desc.English
	oPrinter:Say(125, nLin-0.5, _cDtProducao+" "+Left(Time(),5), oFont6,,,nA)
	nLin -= 9
	oPrinter:Line( 125, nLin+5, 175, nLin+5, , "-9")
	oPrinter:Say(122, nLin-0.5, _cProd, oFont6,,,nA)
	oPrinter:Say(149, nLin-0.5, "OP: "+_cNUMOP, oFont5b,,,nA)
	nLin -= 4.5
	oPrinter:Line( 010, nLin, 175, nLin, , "-9")

	// Adicionar imagem do Produto
	nLin -= 11
	oPrinter:Say(010, nLin, _cRange,   oFont11,,,nA)                       // Desc.English

	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		oPrinter:SayBitmap( 010, nLin-40, cPath+"bv2o.png", 20, 25 )  // 124.5
	EndIf
	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		oPrinter:SayBitmap( 035, nLin-40, cPath+"logo_mexicoo.png", 20, 25 )  // 124.5
	EndIf
	//20201124011103
	If !Empty(SB1->B1_XNTCLOG) .And. !AllTrim(SB1->B1_XNTCLOG)=="-"
		oPrinter:SayBitmap ( 060, nLin-40, cPath+"retieo.png", 20, 25 )   // Certificado
	EndIf
	If !Empty(SB1->B1_XCERING) .And. !AllTrim(SB1->B1_XCERING)=="-"
		oPrinter:SayBitmap ( 85, nLin-40, cPath+"ingcero.png", 20, 25 )   // Certificado
	EndIf

	If !Empty(SB1->B1_XTECHDE) .And. !AllTrim(SB1->B1_XTECHDE)=="-"
		oPrinter:Say(050, nLin+1, AllTrim(SB1->B1_XTECHDE), oFont7,,,nA)
	EndIf
	If !Empty(SB1->B1_XTECHD2) .And. !AllTrim(SB1->B1_XTECHD2)=="-"
		oPrinter:Say(050, nLin-7, AllTrim(SB1->B1_XTECHD2), oFont6,,,nA)
	EndIf
	If !Empty(AllTrim(SB1->B1_XDIAG1))
		oPrinter:SayBitmap ( 100, nLin-10, cPath+ AllTrim(SB1->B1_XDIAG1) + ".png", 20, 20 )
	Endif
	oPrinter:Say(125, nLin, _cCIP,     oFont10b,,,nA)
	nLin -= 15
	//oPrinter:Line( 010, nLin, 115, nLin, , "-9")
	oPrinter:SayBitmap (119,  nLin-60, cPath+_Imagem+".png", 60, 60 )
	// Adicionar Imagem do imntro
	//oPrinter:SayBitmap ( 080, nLin-50, cPath+"lg_mex_orionv.png", 20, 35 )
	nLin -= 26
	oPrinter:Line( 010, nLin, 115, nLin, , "-9")
	nLin -= 45
	//oPrinter:Code128( 10, nLin, "23606480721858", 37,1.3,.T.,oFont6)

	oPrinter:SayBitmap( 050, nLin-68, cPath+_cLogo+".png", 25, 90 )  // 124.5

	oPrinter:Say(45, nLin-42, cCodBar,     oFont6,,,nA)
	oPrinter:Line( 010, nLin, 175, nLin, , "-9")                 //152

	oPrinter:FWMSBAR("CODE128",;                          // 01 - Tipo Código Barra
	01,;                              // 02 - Linha
	3,;                               // 03 - Coluna
	cCodBar,;                         // 04 - Chave Codigo barra
	oPrinter,;                        // 05 - Objeto Printer
	.F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
	,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
	.f.,;                             // 08 - Se imprime na Horizontal. Default .T.
	0.025,;                           // 09 - Numero do Tamanho da barra. Default 0.025
	1.2,;                             // 10 - Numero da Altura da barra. Default 1.5
	.F.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
	"Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
	,;                            // 13 - Modo do codigo de barras CO. Default ""
	.f.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
	0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
	0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
	.F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

	oPrinter:EndPage()
Return




/*/{Protheus.doc} Unschime
description
@type function
@version 
@author Valdemir Jose
@since 10/09/2020
@return return_type, return_description
/*/
Static Function INIUNSCHIM(oPrinter)
	Local _nQtde       := 1     // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx           //SB1->B1_XQTYMUL - Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHDE4                            // "Door Chime, White"   //
	Local _cDesSpan    := SB1->B1_XSHDE5                            // "100 - 220V"
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cDtProducao := 'UNSCHIME2M_WE'
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
	Local _cDiagEletr  := ""
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := ""
	Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
	Local _cLogo       := ""
	Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
	Local oFont6b      := TFont():New("Arial", , 6 , .T.,.T.)
	Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
	Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
	Local oFont12      := TFont():New("Arial", , 12 , .T.,.F.)
	Local oPure        := TFont():New("Arial", , 10 , .T.,.F.)
	Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
	Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)
	Local nLin         := 0
	Local nCol         := 25

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin += 20
	oPrinter:Say(nLin, 010+nCol, "UNSCHIME2M_WE",    oFont12b)
	oPrinter:Say(nLin, 121+nCol, "Unica Pure",       oPure)
	oPrinter:Say(nLin, 175+nCol, "Net Qty: "+Alltrim(cValToChar(_cQtde))+"N", oFont10b)
	nLin += 6
	oPrinter:Line( nLin, 010+nCol, nLin, 230+nCol, , "-9")
	nLin += 6.5
	oPrinter:Say(nLin, 010+nCol, _cDesPort, oFont6b)             // Desc.Portugues
	oPrinter:Say(nLin, 150+nCol, _cPais, oFont6b)
	nLin += 3
	oPrinter:Line( nLin+1, 150+nCol, nLin+1, 230+nCol, , "-9")
	nLin += 7
	oPrinter:Say(nLin-2, 010+nCol, _cDesSpan,     oFont6b)             // Desc. Spanhol
	oPrinter:Say(nLin-2, 090+nCol, "Dispose the", oFont6b)             // Desc. Spanhol
	oPrinter:Say(nLin, 150+nCol, "CIP "+_cCIP,    oFont6b)
	nLin += 7
	oPrinter:Line( nLin-5.7, 150+nCol, nLin-5.7, 230+nCol, , "-9")
	//oPrinter:Say(nLin, 010+nCol, _cDesEngl,       oFont6)             // Desc.English
	oPrinter:Say(nLin, 090+nCol, "Product as per", oFont6b)               // Desc. Spanhol
	oPrinter:Say(nLin, 150+nCol, "Logistic Ref",  oFont6b)
	oPrinter:Say(nLin, 185+nCol, "UNSCHIME2M_WE", oFont6b)
	nLin += 7
	oPrinter:Line( nLin-5.5, 150+nCol, nLin-5.5, 230+nCol, , "-9")
	oPrinter:Say(nLin, 090+nCol, "Environmental laws", oFont6b)
	oPrinter:Say(nLin+0.5, 150+nCol, "Mig Date: May 2020", oFont6b)
	nLin += 7
	oPrinter:Say(nLin+8, 010+nCol, "MRP: Rs",     oFont12b)
	oPrinter:Say(nLin+3, 090+nCol, "(Incl of all taxes)", oFont6b)
	nLin += 15
	oPrinter:QRCode ( nLin+20, 155+nCol, "3606489700577", 35 )
	// Adicionar imagem do Produto
	oPrinter:SayBitmap ( nLin-15, 225, cPath+"reciclagem.png", 25, 25 )
	nLin += 12
	oPrinter:Say(nLin, 10+nCol, "Customer Care executive", oFont6b)
	nLin += 7
	oPrinter:Say(nLin, 10+nCol, "Schneider Electric India PM Ltda", oFont6b)
	nLin += 7
	oPrinter:Say(nLin, 10+nCol, "2nd flocr Tower A Bestech Business Tower", oFont6b)
	nLin += 7
	oPrinter:Say(nLin, 10+nCol, "Sec 66, Mohali-160062, Punjab", oFont6b)
	nLin += 7
	oPrinter:Say(nLin, 10+nCol, "Customer Care Tel 1800 103 0011", oFont6b)
	nLin += 7
	oPrinter:Say(nLin, 10+nCol, "customercare.int@schneider.electric.com", oFont6b)
	nLin += 7

	oPrinter:FWMSBAR("EAN13",;                          // 01 - Tipo Código Barra
	8.3,;                             // 02 - Linha
	13.8,;                               // 03 - Coluna
                        "3606489700577"/*Alltrim(cCodBar)/*/,;                // 04 - Chave Codigo barra
	oPrinter,;                        // 05 - Objeto Printer
	.F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
	,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
	.T.,;                             // 08 - Se imprime na Horizontal. Default .T.
	0.020,;                           // 09 - Numero do Tamanho da barra. Default 0.025
	0.7,;                             // 10 - Numero da Altura da barra. Default 1.5
	.T.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
	"Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
	,;                            // 13 - Modo do codigo de barras CO. Default ""
	.F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
	0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
	0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
	.F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.


Return




/*/{Protheus.doc} EAV14597
description
    Rotina Impressão Etiqueta EAV1459702  - Flow Packs 265 x 200
@type function
@version 
@author Valdemir Jose
@since 11/09/2020
@return return_type, return_description
/*/
/*
Static Function INIEAV1459(oPrinter)
    // Variaveis de memoria
    Local _nQtde       := 1     // Qtde.Etiq.Impressa
    Local _cProd       := SB1->B1_COD
    Local _cQtde       := SB1->B1_XQTYMUL
    Local _cQtdeV      := SB1->B1_XQTYUNT
    Local _cQtdeT      := cValToChar(_cQtde*_cQtdeV)
    Local _cDesPort    := SB1->B1_XSHDE4                           //"PLACA 4 X 2 CEGA BRANCA"   //
    Local _cDesSpan    := SB1->B1_XSHDE5                           //"PLACA 4 X 2 CEGA BRANCA"   //
    Local _cDesEngl    := SB1->B1_XSHDE6
    Local _cDtProducao := 'BG-2020-W19-3'
    Local _cRange      := SB1->B1_XAESNM
    Local _c1DadosTec  := SB1->B1_XTECHDE
    Local _c2DadosTec  := SB1->B1_XTECHD2
    Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
    Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
    Local _cDiagEletr  := ""
    Local _cCIP        := SB1->B1_XCIP
    Local _CertMark1   := "INMET"
    Local _CertMark2   := ""
    Local _CertMark3   := ""
    Local _CertMark4   := ""
    Local _CertMark5   := ""
    Local _Imagem      := ""
    Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
    Local _cLogo       := ""
    Local nLin         := 0
    Local nCol         := 0

    // Configura tipos de fontes a ser utilizada
    Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
    Local oFont6b      := TFont():New("Arial", , 6 , .T.,.T.)
    Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
    Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
    Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
    Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)

    // Cria uma pagina
    oPrinter:StartPage()
    //IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

    nLin += 20
    oPrinter:SayBitmap ( nLin-19, 006+nCol, cPath+"balao.png", 90, 36 )
    oPrinter:Say(nLin+2, 016+nCol, _cProd,    oFont12b)
    oPrinter:Say(nLin, 100+nCol, "X "+Alltrim(cValToChar(_cQtde)), oFont12b)
    nLin += 19
    oPrinter:Say(nLin, 010+nCol, _cDesPort, oFont6b)             // Desc.Portugues
    nLin += 9
    oPrinter:Say(nLin, 010+nCol, _cDesSpan, oFont6b)             // Desc.Espanhol
    nLin += 28
    // Gerar código de barra
    oPrinter:FWMSBAR("EAN13",;                            // 01 - Tipo Código Barra
    4.2,;                             // 02 - Linha
    1.8,;                            // 03 - Coluna
    Alltrim(cCodBar),;                // 04 - Chave Codigo barra   "3606489700577"
    oPrinter,;                        // 05 - Objeto Printer
    .F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
    ,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
    .T.,;                             // 08 - Se imprime na Horizontal. Default .T.
    0.020,;                           // 09 - Numero do Tamanho da barra. Default 0.025
    0.7,;                             // 10 - Numero da Altura da barra. Default 1.5
    .T.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
    "Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
    ,;                            // 13 - Modo do codigo de barras CO. Default ""
    .F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
    0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
    0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
    .F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    nLin += 15
    oPrinter:Say(nLin, 10+nCol, "Made in "+_cPais, oFont6b)
    oPrinter:Say(nLin, 75, _cDtProducao, oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 25+nCol, _c1DadosTec, oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 25+nCol, _c2DadosTec, oFont6b)
    nLin += 90

    oPrinter:SayBitmap ( nLin, 010, cPath+"certflow.png", 20, 20 )
    nLin += 28
    oPrinter:Say(nLin, 010, "Instalación debe", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "ser realizada", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "por una persona", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "calificada,", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "recomendamos", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "un eletricista.", oFont6b)

Return
*/


/*/{Protheus.doc} HRB8045002
description
    Rotina Impressão Etiqueta HRB8045002  - Flow Packs 210 X 140
@type function
@version 
@author Valdemir Jose
@since 11/09/2020
@return return_type, return_description
/*/
/*
Static Function INIHRB8045(oPrinter)
    // Variaveis de memoria
    Local _nQtde       := 1     // Qtde.Etiq.Impressa
    Local _cProd       := SB1->B1_COD
    Local _cQtde       := SB1->B1_XQTYMUL
    Local _cQtdeV      := SB1->B1_XQTYUNT
    Local _cQtdeT      := cValToChar(_cQtde*_cQtdeV)
    Local _cDesPort    := SB1->B1_XSHDE4                           //"PLACA 4 X 2 CEGA BRANCA"   //
    Local _cDesSpan    := SB1->B1_XSHDE5                           // "PLACA 4 X 2 CEGA BRANCA"   //
    Local _cDesEngl    := SB1->B1_XSHDE6
    Local _cDtProducao := 'BG-2020-W19-3'
    Local _cRange      := SB1->B1_XAESNM
    Local _c1DadosTec  := SB1->B1_XTECHDE
    Local _c2DadosTec  := SB1->B1_XTECHD2
    Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
    Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
    Local _cDiagEletr  := ""
    Local _cCIP        := SB1->B1_XCIP
    Local _CertMark1   := "INMET"
    Local _CertMark2   := ""
    Local _CertMark3   := ""
    Local _CertMark4   := ""
    Local _CertMark5   := ""
    Local _Imagem      := ""
    Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
    Local _cLogo       := ""
    Local nLin         := 0
    Local nCol         := 0

    // Configura tipos de fontes a ser utilizada
    Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
    Local oFont6b      := TFont():New("Arial", , 6 , .T.,.T.)
    Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
    Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
    Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
    Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)

    // Cria uma pagina
    oPrinter:StartPage()
    //IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

    nLin += 20
    oPrinter:SayBitmap ( nLin-19, 006+nCol, cPath+"balao.png", 90, 36 )
    oPrinter:Say(nLin+2, 016+nCol, _cProd,    oFont12b)
    oPrinter:Say(nLin, 100+nCol, "X "+Alltrim(cValToChar(_cQtde)), oFont12b)
    nLin += 19
    oPrinter:Say(nLin, 010+nCol, _cDesPort, oFont6b)             // Desc.Portugues
    nLin += 9
    oPrinter:Say(nLin, 010+nCol, _cDesSpan, oFont6b)             // Desc.Espanhol
    nLin += 7
    // Gerar código de barra
    oPrinter:FWMSBAR("EAN13",;                            // 01 - Tipo Código Barra
    4.1,;                             // 02 - Linha
    1.8,;                            // 03 - Coluna
    Alltrim(cCodBar),;                // 04 - Chave Codigo barra     // "3606489700577"
    oPrinter,;                        // 05 - Objeto Printer
    .F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
    ,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
    .T.,;                             // 08 - Se imprime na Horizontal. Default .T.
    0.020,;                           // 09 - Numero do Tamanho da barra. Default 0.025
    0.7,;                             // 10 - Numero da Altura da barra. Default 1.5
    .T.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
    "Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
    ,;                            // 13 - Modo do codigo de barras CO. Default ""
    .F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
    0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
    0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
    .F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    nLin += 34
    oPrinter:Say(nLin, 10+nCol, "Made in "+_cPais, oFont6b)
    oPrinter:Say(nLin, 75, _cDtProducao, oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 25+nCol, _c1DadosTec, oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 25+nCol, _c2DadosTec, oFont6b)

    nLin += 8
    oPrinter:SayBitmap ( nLin, 020, cPath+"NHA2721900.png", 90, 50 )
    nLin += 55

    oPrinter:SayBitmap ( nLin, 010, cPath+"certflow.png", 20, 20 )
    oPrinter:SayBitmap ( nLin, 070, cPath+"BV2.png", 35, 26 )

    nLin += 28
    oPrinter:Say(nLin, 010, "Instalación debe", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "ser realizada", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "por una persona", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "calificada,", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "recomendamos", oFont6b)
    nLin += 7
    oPrinter:Say(nLin, 010, "un eletricista.", oFont6b)

Return
*/



/*/{Protheus.doc} QGH5230900
description
    Rotina Impressão Etiqueta QGH5230900  - Flow Packs 210 X 140
@type function
@version 
@author Valdemir Jose
@since 11/09/2020
@return return_type, return_description
/*/
/*
Static Function INIQGH5230(oPrinter)
    // Variaveis de memoria
    Local _nQtde       := 1     // Qtde.Etiq.Impressa
    Local _cProd       := SB1->B1_COD
    Local _cQtde       := SB1->B1_XQTYMUL
    Local _cQtdeV      := SB1->B1_XQTYUNT
    Local _cQtdeT      := cValToChar(_cQtde*_cQtdeV)
    Local _cDesPort    := SB1->B1_XSHDE4             // "Interruptor Simples CJ BR"
    Local _cDesSpan    := SB1->B1_XSHDE5             // "Inter Sencillo Cj BL"
    Local _cDesEngl    := SB1->B1_XSHDE6
    Local _cDtProducao := 'BG-2020-W19-3'
    Local _cRange      := SB1->B1_XAESNM
    Local _c1DadosTec  := SB1->B1_XTECHDE
    Local _c2DadosTec  := SB1->B1_XTECHD2
    Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
    Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
    Local _cDiagEletr  := ""
    Local _cCIP        := SB1->B1_XCIP
    Local _CertMark1   := "INMET"
    Local _CertMark2   := ""
    Local _CertMark3   := ""
    Local _CertMark4   := ""
    Local _CertMark5   := ""
    Local _Imagem      := ""
    Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
    Local _cLogo       := ""
    Local nLin         := 0
    Local nCol         := 0

    // Configura tipos de fontes a ser utilizada
    Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
    Local oFont6b      := TFont():New("Arial", , 6 , .T.,.T.)
    Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
    Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
    Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
    Local oFont13b     := TFont():New("Arial", , 13, .T., .T.)

    // Cria uma pagina
    oPrinter:StartPage()
    //IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

    nLin += 20
    oPrinter:SayBitmap ( nLin-19, 006+nCol, cPath+"balao.png", 90, 36 )
    oPrinter:Say(nLin+2, 016+nCol, _cProd,    oFont12b)
    oPrinter:Say(nLin, 100+nCol, "X "+Alltrim(cValToChar(_cQtde)), oFont12b)
    nLin += 19
    oPrinter:Say(nLin, 010+nCol, _cDesPort, oFont6b)             // Desc.Portugues
    nLin += 7
    oPrinter:Say(nLin, 010+nCol, _cDesSpan, oFont6b)             // Desc.Espanhol
    nLin += 4
    // Gerar código de barra
    oPrinter:FWMSBAR("EAN13",;                            // 01 - Tipo Código Barra
    3.9,;                             // 02 - Linha
    1.3,;                            // 03 - Coluna
    Alltrim(cCodBar),;                // 04 - Chave Codigo barra       // "7898384696185"/*
    oPrinter,;                        // 05 - Objeto Printer
    .F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
    ,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
    .T.,;                             // 08 - Se imprime na Horizontal. Default .T.
    0.020,;                           // 09 - Numero do Tamanho da barra. Default 0.025
    0.7,;                             // 10 - Numero da Altura da barra. Default 1.5
    .T.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
    "Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
    ,;                            // 13 - Modo do codigo de barras CO. Default ""
    .F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
    0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
    0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
    .F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    nLin += 37
    oPrinter:Say(nLin, 25+nCol, "Made in "+_cPais, oFont6b)
    nLin += 6
    oPrinter:Say(nLin, 25+nCol, _cDtProducao, oFont6b)
    nLin += 6
    oPrinter:Say(nLin, 25+nCol, _c1DadosTec, oFont6b)
    nLin += 7
    oPrinter:SayBitmap ( nLin, 025, cPath+"BV2.png", 35, 26 )

Return
*/

/*/{Protheus.doc} HRB1068200
description
Rotina ETIQUETA 112X70 - DEFINICAO GRAFICA (ARTE FINAL) - EXTERNA - caixa coletiva MILUZ
@type function
@version 
@author Valdemir Jose
@since 16/09/2020
@return return_type, return_description
/*/
Static Function INIHRB1068(oPrinter)
	Local _nQtde       := 1 // Qtde.Etiq.Impressa
	Local _cProd       := AllTrim(SB1->B1_COD)
	Local _cQtde       := nGQtdPCx          //SB1->B1_XQTYMUL  Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHDE4
	Local _cDesSpan    := SB1->B1_XSHDE5
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cPais       := SB1->B1_XFROM // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1 // POSICAO 29
	Local _cDtProducao := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))+" "+Left(Time(),5)
	Local _cNUMOP      := ALLTRIM(SC2->C2_NUM)
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cDiagEletr  := ""
	Local _cRohs       := if(!Empty(SB1->B1_XROHLOG),alltrim(SB1->B1_XROHLOG),"")
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := if(!Empty(SB1->B1_XPROTHU),alltrim(SB1->B1_XPROTHU),"")
	Local cCodBar      := if(Empty(SB1->B1_XEAN14),SB1->B1_XEAN14,SB1->B1_XEAN14)
	Local _xCering     := if(!Empty(SB1->B1_XCERING),alltrim(SB1->B1_XCERING),"")   // Valdemir Rabelo 04/03/2022 - Chamado: 20220201002554
	Local _cLogo       := "logosebh"

	Local oFont30b     := TFont():New("Arial", , 30 , .T.,.T.)
	Local oFont20b     := TFont():New("Arial", , 20 , .T.,.T.)
	Local oFont11      := TFont():New("Arial", , 11, .T., .F.)
	Local oFont12      := TFont():New("Arial", , 12, .T., .F.)
	Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
	Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
	Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
	Local oFont8       := TFont():New("Arial", , 8 , .T.,.F.)
	Local oFont7       := TFont():New("Arial", , 7 , .T.,.F.)
	Local oFont5b      := TFont():New("Arial", , 5 , .T.,.T.)
	Local nLin         := -10
	Local nCol         := 15
	Local nA           := 270

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin += 35
	oPrinter:Say(300+nCol, nLin,  _cProd,             oFont20b,,,nA)
	oPrinter:Say(075+nCol, nLin,  cValToChar(_cQtde), oFont11,,,nA)
	oPrinter:Say(060+nCol, nLin,  "X",                oFont11,,,nA)
	oPrinter:Say(045+nCol, nLin,  cValToChar(_cQtdeV),oFont11,,,nA)
	oPrinter:Say(030+nCol, nLin,  "=",                oFont11,,,nA)
	oPrinter:Say(015+nCol, nLin,  _cQtdeT,            oFont20b,,,nA)
	nLin += 6
	oPrinter:Line( 001+nCol,nLin, 300+nCol, nLin,  , "-9")
	nLin += 8.5
	oPrinter:Say(280+nCol, nLin+1, _cDesPort, oFont7,,,nA)                          // Desc.Portugues
	oPrinter:Say(124+nCol, nLin, _cPais, oFont8,,,nA)

	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		oPrinter:SayBitmap ( 285+nCol, nLin-8, cPath+"logo_mexico.png", 30, 15 )  // Certificado
	Endif
	If !Empty(SB1->B1_XNTCLOG) .And. !AllTrim(SB1->B1_XNTCLOG)=="-"
		oPrinter:SayBitmap ( 285+nCol, nLin+25, cPath+"retiev.png", 30, 15 )  // Certificado
	EndIf

	if !Empty(SB1->B1_XROHLOG) .And. !AllTrim(SB1->B1_XROHLOG)=="-"
		oPrinter:SayBitmap ( 10+nCol, nLin-4.1, cPath+_cRohs+".png", 15, 15 )   // tem img
	Endif
	nLin += 9

	oPrinter:Say(124+nCol, nLin, "CNPJ 05.890.658/0005-63", oFont5b,,,nA)

	oPrinter:Say(280+nCol,nLin+3, _cDesSpan, oFont7,,,nA)                           // Desc. Spanhol
	//oPrinter:Say(nLin, 215+nCol, "Hecho en "+_cPais1, oFont8)

	nLin += 9
	//oPrinter:Line( nLin-5.7, 215+nCol, nLin-5.7, 250+nCol, , "-9")
	oPrinter:Say(280+nCol, nLin+4, _cDesEngl, oFont7,,,nA)
	oPrinter:Say(124+nCol, nLin, "Estrada Mun. Noriko Hamada, 180- Guararema-SP", oFont5b,,,nA)
	nLin += 13
	oPrinter:Line( 124+nCol, nLin-5.5, 001+nCol, nLin-5.5, , "-9")
	nLin += 2
	oPrinter:Say(124+nCol,nLin, _cDtProducao,   oFont8,,,nA)
	oPrinter:Say(030+nCol,nLin, "OP: "+_cNUMOP, oFont5b,,,nA)
	nLin += 1
	oPrinter:Line( 001+nCol,nLin,  124+nCol,nLin, , "-9")
	oPrinter:Line( 120+nCol,nLin,  280+nCol,nLin, , "-9")

	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"		
		oPrinter:SayBitmap ( 010+nCol, nLin+12, cPath+"BV2SEPD.png", 20, 28 )    // SEGURANÇA
	EndIf

	nLin += 8
	oPrinter:Say(124+nCol, nLin, _cProd, oFont8,,,nA)

	If !Empty(SB1->B1_XCOLOR1)
		oPrinter:Say(170+nCol, nLin,    AllTrim(SB1->B1_XCOLOR1),    oFont8,,,nA)
	EndIf
	If !Empty(SB1->B1_XCOLOR2)
		oPrinter:Say(170+nCol, nLin+10, AllTrim(SB1->B1_XCOLOR2),   oFont8,,,nA)
	EndIf
	If !Empty(SB1->B1_XCOLOR2)
		oPrinter:Say(170+nCol, nLin+20, AllTrim(SB1->B1_XCOLOR3),   oFont8,,,nA)
	EndIf

	nLin += 2
	oPrinter:Line( 124+nCol, nLin, 001+nCol, nLin, , "-9")
	nLin += 7
	oPrinter:Say(124+nCol, nLin+3, _cCIP,     oFont12,,,nA)
	
	// Adicionar imagem do Produto
	if !Empty(_Imagem)
		oPrinter:SayBitmap ( nCol+55, nLin+5, cPath+_Imagem+".png", 80, 60 )
	Endif
	// Valdemir Rabelo 04/03/2022 - Chamado: 20220201002554 / 20220315005842
	If !Empty(_xCering) .And. !AllTrim(_xCering)=="-"
		oPrinter:SayBitmap ( 285+nCol, nLin+07, cPath+_xCering+".png", 20, 17 )     // Valdemir Rabelo 28/03/2022 - Chamado: 20220317005983
	Endif

	nLin += 10
	oPrinter:Say(280+nCol, nLin, _cRange,   oFont30b,,,nA)

	nLin += 12
	If !Empty(SB1->B1_XTECHDE) .And. !AllTrim(SB1->B1_XTECHDE)=="-"
		oPrinter:Say(280+nCol, nLin, AllTrim(SB1->B1_XTECHDE), oFont10,,,nA)
	EndIf

	nLin += 9
	If !Empty(SB1->B1_XTECHD2) .And. !AllTrim(SB1->B1_XTECHD2)=="-"
		oPrinter:Say(280+nCol, nLin, AllTrim(SB1->B1_XTECHD2), oFont10,,,nA)
	EndIf

	nLin += 5
	oPrinter:Line( 124+nCol,nLin,  280+nCol,nLin, , "-9")

	// Adicionar Imagem do imntro
	oPrinter:FWMSBAR("INT25",;        // 01 - Tipo Código Barra
	13,;                              // 02 - Linha
	10.5,;                            // 03 - Coluna
	Alltrim(cCodBar) ,;               // 04 - Chave Codigo barra       // "7898384696185"/*
	oPrinter,;                        // 05 - Objeto Printer
	.F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
	,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
	.F.,;                             // 08 - Se imprime na Horizontal. Default .T.
	0.015,;                           // 09 - Numero do Tamanho da barra. Default 0.025
	1.3,;                             // 10 - Numero da Altura da barra. Default 1.5
	.F.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
	"Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
	,;                                // 13 - Modo do codigo de barras CO. Default ""
	.F.,;                             // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
	1,;                               // 15 - Número do índice de ajuste da largura da fonte. Default 1
	0.50,;                            // 16 - Número do índice de ajuste da altura da fonte. Default 1
	.T.)                              // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

	nLin +=52
	oPrinter:Say(250+nCol, nLin, Alltrim(cCodBar) , oFont10,,,nA)
	nLin += 1
	oPrinter:Line( 050+nCol, nLin, 300+nCol, nLin,  , "-9")    //152
/*
    nLin += 4
    oPrinter:Say(035+nCol, nLin+8, "schneider-electric.com/contact",     oFont12)          
    oPrinter:SayBitmap ( 275+nCol, nLin, cPath+_cLogo+".png", 60, 20 )  // 124.5
*/
	oPrinter:EndPage()

Return

Static Function ININHA6862(oPrinter)
	Local _nQtde       := 1 // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx   //SB1->B1_XQTYMUL   Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHDE4
	Local _cDesSpan    := SB1->B1_XSHDE5
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cPais       := SB1->B1_XFROM // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1 // POSICAO 29
	Local _cDtProducao := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cDiagEletr  := ""
	Local _cRohs       := if(!Empty(SB1->B1_XROHLOG),alltrim(SB1->B1_XROHLOG),"")
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := if(!Empty(SB1->B1_XPROTHU),alltrim(SB1->B1_XPROTHU),"")
	Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
	Local _cLogo       := "logosebh"

	Local oFont15b     := TFont():New("Arial", , 15 , .T.,.T.)
	Local oFont15      := TFont():New("Arial", , 15 , .T.,.F.)
	Local oFont20b     := TFont():New("Arial", , 20 , .T.,.T.)
	Local oFont11      := TFont():New("Arial", , 11, .T., .F.)
	Local oFont12      := TFont():New("Arial", , 12, .T., .F.)
	Local oFont12b     := TFont():New("Arial", , 12, .T., .T.)
	Local oFont10      := TFont():New("Arial", , 10, .T., .F.)
	Local oFont10b     := TFont():New("Arial", , 10, .T., .t.)
	Local oFont8       := TFont():New("Arial", , 8 , .T.,.F.)
	Local oFont5b      := TFont():New("Arial", , 5 , .T.,.T.)
	Local nLin         := 0
	Local nCol         := 0

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin += 20
	oPrinter:Say(nLin, 038+nCol, _cProd,             oFont20b)
	oPrinter:Say(nLin, 255+nCol, cValToChar(_cQtde), oFont8)
	oPrinter:Say(nLin, 270+nCol, "X",                oFont8)
	oPrinter:Say(nLin, 285+nCol, cValToChar(_cQtdeV),oFont8)
	oPrinter:Say(nLin, 300+nCol, "=",                oFont8)
	oPrinter:Say(nLin, 315+nCol, _cQtdeT,            oFont8)
	nLin += 6
	oPrinter:Line( nLin, 035+nCol, nLin, 330+nCol, , "-9")
	nLin += 8.5
	oPrinter:Say(nLin+1, 050+nCol, _cDesPort, oFont8)             // Desc.Portugues
	oPrinter:Say(nLin+12, 208+nCol, _cPais, oFont15)
	oPrinter:SayBitmap ( nLin-8,035+nCol, cPath+"logo_mexico.png", 15, 50 )  // Certificado
	if !Empty(_cRohs)
		oPrinter:SayBitmap ( nLin-4.1,310+nCol, cPath+_cRohs+".png", 15, 15 )
	Endif
	nLin += 14
	oPrinter:Line( nLin-0.5, 206+nCol, nLin-0.5, 330+nCol, , "-9")
	oPrinter:Say(nLin,   050+nCol, _cDesSpan, oFont8)             // Desc. Spanhol
	oPrinter:Say(nLin+7, 208+nCol, _cDtProducao, oFont8)

	nLin += 9
	oPrinter:Line( nLin, 208+nCol, nLin, 330+nCol, , "-9")
	oPrinter:Say(nLin+4, 050+nCol, _cDesEngl, oFont8)
	nLin += 13

	oPrinter:Line( nLin, 050+nCol, nLin, 200+nCol, , "-9")

	oPrinter:SayBitmap ( nLin-8, 300+nCol, cPath+"BV2.png", 33, 24 )

	nLin += 9
	oPrinter:Say(nLin+3, 208+nCol, _cCIP,     oFont12)

	// Adicionar imagem do Produto
	if !Empty(_Imagem)
		oPrinter:SayBitmap ( nLin+11, 240+nCol, cPath+_Imagem+".png", 40, 70 )
	Endif
	nLin += 10
	oPrinter:Say(nLin, 050+nCol, _cRange,   oFont15b)
	nLin += 12
	oPrinter:Say(nLin, 050+nCol, _c1DadosTec, oFont11)
	nLin += 9
	oPrinter:Say(nLin, 050+nCol, _c2DadosTec, oFont11)

	nLin += 7
	oPrinter:Line( nLin, 050+nCol, nLin, 210+nCol, , "-9")
	// Adicionar Imagem do imntro
	nLin += 4

	oPrinter:FWMSBAR("INT25",;                            // 01 - Tipo Código Barra
	10,;                             // 02 - Linha
	4,;                            // 03 - Coluna
	"23606480721858"/*Alltrim(cCodBar)*/,;                // 04 - Chave Codigo barra       // "7898384696185"/*
	oPrinter,;                        // 05 - Objeto Printer
	.F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
	,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
	.T.,;                             // 08 - Se imprime na Horizontal. Default .T.
	0.017,;                           // 09 - Numero do Tamanho da barra. Default 0.025
	0.90,;                               // 10 - Numero da Altura da barra. Default 1.5
	.F.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
	"Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
	,;                            // 13 - Modo do codigo de barras CO. Default ""
	.F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
	1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
	0.50,;                        // 16 - Número do índice de ajuste da altura da fonte. Default 1
	.T.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.


	nLin += 40
	oPrinter:Say(nLin, 080+nCol,"23606480721858" , oFont10)
	nLin += 11
	oPrinter:Line( nLin, 035+nCol, nLin, 330+nCol, , "-9")    //152
	nLin += 4

	oPrinter:SayBitmap ( nLin,275+nCol, cPath+_cLogo+".png", 60, 20 )  // 124.5
	oPrinter:EndPage()

Return


/*/{Protheus.doc} ININHA4940
    description
    Imprime Etiqueta Orion NHA4940502 (ETIQUETA 70X23) Blister
    @type function
    @version 
    @author Valdemir Jose
    @since 11/08/2020
    @return return_type, return_description
/*/
Static Function ININHA4940(oPrinter)
	Local _nQtde       := 1 // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := SB1->B1_XQTYUNT   //SB1->B1_XQTYMUL Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHO1
	Local _cDesSpan    := SB1->B1_XSHO2
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cPais       := SB1->B1_XFROM // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1 // POSICAO 29
	Local _cLote       := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECDF1
	Local _c2DadosTec  := SB1->B1_XTECDF2
	Local _cDiagEletr  := ""
	Local _cRohs       := if(!Empty(SB1->B1_XROHLOG),alltrim(SB1->B1_XROHLOG)+ 'H',"")
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := if(!Empty(SB1->B1_XPROTHU),alltrim(SB1->B1_XPROTHU),"")
	Local cCodBar      := Alltrim(SB1->B1_CODBAR)
	Local _cLogo       := "logosebh"
	Local _cCores      := SB1->B1_XCOLUNT



	Local oFont6       := TFont():New("Arial", , 7 , .T.,.T.)
	Local oFont7       := TFont():New("Arial", , 7 , .T.,.F.)
	Local oFont8       := TFont():New("Arial", , 8 , .T.,.F.)
	Local oFont8b      := TFont():New("Arial", , 9 , .T.,.T.)
	Local nLin         := 0
	Local nCol         := -12

	oPrinter:StartPage()
	//IncProc("Montando "+Str(_nConta)+"º etiqueta de "+Str(pTotal))

	nLin += 15
	oPrinter:Say(nLin, 020+nCol, _cProd,            oFont8b)
	oPrinter:Say(nLin, 91+nCol, "X",                oFont8)
	oPrinter:Say(nLin, 98+nCol, cValToChar(_cQtde), oFont8)
	oPrinter:Code128(nLin-7, 105, cCodBar, 0.75, 25, .T., oFont8)   // Valdemir Rabelo - 24/03/2022 - Chamado: 20220323006385
    /*
    oPrinter:FWMSBAR("CODE128",;                          // 01 - Tipo Código Barra
    0.80,;                            // 02 - Linha
    7.6,;                             // 03 - Coluna
    cCodBar,;                         // 04 - Chave Codigo barra
    oPrinter,;                        // 05 - Objeto Printer
    .F.,;                             // 06 - Se calcula o digito de controle. Defautl .T.
    ,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
    .T.,;                             // 08 - Se imprime na Horizontal. Default .T.
    0.018,;                           // 09 - Numero do Tamanho da barra. Default 0.025
    0.6,;                             // 10 - Numero da Altura da barra. Default 1.5
    .T.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
    "Arial",;                         // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
    ,;                            // 13 - Modo do codigo de barras CO. Default ""
    .F.,;                         // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
    0.1,;                         // 15 - Número do índice de ajuste da largura da fonte. Default 1
    0.5,;                         // 16 - Número do índice de ajuste da altura da fonte. Default 1
    .F.)                          // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    */
	nLin += 10
	oPrinter:Say(nLin, 020+nCol, _cDesPort, oFont6)
	nLin += 10
	oPrinter:Say(nLin, 020+nCol, _cDesSpan, oFont6)
	nLin += 10
	oPrinter:Say(nLin, 020+nCol, _c1DadosTec,  oFont6)
	nLin += 6
	//oPrinter:Say(nLin, 020+nCol, alltrim(_c2DadosTec)+" Made in "+_cPais,   oFont8)
	oPrinter:Say(nLin, 120+nCol, _cLote,      oFont7)
	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		oPrinter:SayBitmap ( 40, nCol+180, cPath+"BV2.bmp", 32, 20 )
	EndIf
	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		oPrinter:SayBitmap ( 40, nCol+180, cPath+"logo_mexicov.png", 32, 20 )
	EndIf

	nLin += 10
	oPrinter:Say(nLin, 020+nCol, _cCores,  oFont6)
	oPrinter:Say(nLin, 140+nCol, _cRange,  oFont8b)
	oPrinter:EndPage()
Return





/*/{Protheus.doc} HRB1068200
    description
    Rotina ETIQUETA 112X70 - DEFINICAO GRAFICA (ARTE FINAL) - EXTERNA
    @type function
    @version 
    @author Valdemir Jose
    @since 16/09/2020
    @return return_type, return_description
/*/
User Function ExecEtiq(pModelo, aDados)
	Local oPrinter := u_ConfEtiq( pModelo )          // Configura impressão
	Local oException
	Local oError
	Local bError   :={|oError| MyError( oError ) }
	Local cBlock   := "INI"+Left(Alltrim(pModelo),7)+"(oPrinter)"
	Default aDados := {}
	/*
	if (pModelo=="HUETIQUETA")
		cBlock   := "INI"+Left(Alltrim(pModelo),7)+"(oPrinter,aDados)"
	else
    	cBlock   := "INI"+Left(Alltrim(pModelo),7)+"(oPrinter)"
	endif
	*/
	TRYEXCEPTION USING bError

		// Monta layout para impressão da etiqueta
		Processa( {|| &(cBlock) }, "Imprimindo Etiqueta "+pModelo+", Aguarde...")

		//oPrinter:Preview()
		oPrinter:Print()

		FreeObj(oPrinter)
		oPrinter := Nil

	CATCHEXCEPTION USING oError
		MsgInfo( oError:Description , "Peguei o Desvio do BREAK" )
		oPrinter := Nil
	ENDEXCEPTION

Return

Static Function MyError( oError )
	//MsgInfo( oError:Description , "Deu Erro" )
	BREAK
Return( NIL )


/*/{Protheus.doc} OPETQPROC
    description
        Rotina que busca a etiqueta com base no produto
    @type function
    @author Valdemir Jose
    @since 15/09/2020
    @return return_type, return_description
/*/
Static Function OPETQPROC()
	Local cVld := U_getLista()
	//Local nPos := aScan(aVld, {|X| ALLTRIM(X[1])==ALLTRIM(SB1->B1_COD) .and. X[2]== SB1->B1_XVH })    // Verifico qual etiqueta será chamada

	if !Empty(cVld)
		&(cVld)
	else
		FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não consta na lista de etiquetas individuais (GetLista)")
	endif

Return

Static Function GetSaida(pData)
	Local cRET := Left(dtoc(pData),2)+" "+MesExtenso(Month(pData))+" "+Left(dtos(pData),4)
Return cRET



Static Function ImpVideoJ()
	Local lVld := .F.
	If !Empty(cGetProd) .And. !Empty(cGetCodBar)
		If !Empty(SB1->B1_XMODFLO)

			Do Case
			Case AllTrim(SB1->B1_XMODFLO)=="EAV1459702"
				Processa( {|| INIEAV1459(cGetProd,cGetCodBar)  }, "Enviando etiqueta para videojet", "Aguarde...")
			Case AllTrim(SB1->B1_XMODFLO)=="HRB8045002"
				Processa( {|| INIHRB8045(cGetProd,cGetCodBar)  }, "Enviando etiqueta para videojet", "Aguarde...")
			Case AllTrim(SB1->B1_XMODFLO)=="QGH5230900"
				Processa( {|| INIQGH5230(cGetProd,cGetCodBar)  }, "Enviando etiqueta para videojet", "Aguarde...")
			OtherWise
				MsgAlert("Atenção, modelo de etiqueta vinculado não existe.")
			EndCase

			MsgAlert("Atenção, Impressão da etiqueta enviada")
			lValidOK := getVldEmb("Por favor, faça leitura do código Barra da 1ª FlowPack")
			if !lValidOK
				Limpa()
			Endif
			cMensage := "POR FAVOR COLOQUE A CAIXA VAZIA NA BALANÇA"
		Else
			MsgAlert("Atenção, modelo de flowpack não preenchido,verifique!")
		EndIf
	Else
		MsgAlert("Atenção, produto ou OP não preenchido,verifique!")
	EndIf

Return


/*/{Protheus.doc} QGH5230900
    description
        Rotina Impressão Etiqueta QGH5230900  - Flow Packs 210 X 140
    @type function
    @version 
    @author Valdemir Jose
    @since 11/09/2020
    @return return_type, return_description
/*/
Static Function INIQGH5230()

	Local cString   := ""
	Local cProd     := SB1->B1_COD
	Local cQtde     := SB1->B1_XQTYUNT
	Local cDesc1    := SB1->B1_XSHO1
	Local cDesc2    := SB1->B1_XSHO2
	Local cCodBar   := Alltrim(if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR))
	Local cPais		:= SB1->B1_XFROM                      // POSICAO 08
	Local cCodX     := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local cDescTec  := SB1->B1_XTECHDE
	Local cPortaImp := "LPT1"
	Local nLin      := 0
	Local nCol      := 0

	cString += "^XA" + CRLF

	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		cString += "^FO"+cValToChar(110)+","+cValToChar(360)+"^GFA,648,648,12,,06,1FC,3DE,3800C0601080070660301C,3E03F1FF71CFDDCFF8FC7F,1FC739CF71CF8CCF39CE63,03E7FB8771CE0FCF3BC03F,30F7FB8F71CE3CCF3BC0F7,38E639CF79CE38CF39CEE3,3FE7F8FF3FCE3FCF39FCFF,0F81E04F1D8E0EC618787B,K01CEP03,L0FCP078,,:Q07OFE,J07EK07OFE,I03EF8J07OFE,I0E00EJ07OFE,I0CFE2J07OFE,0019C7BM0JFE,0013009M0DIFE,003600D8L0CIFE,00240048L0C3FFE,0024006CL0C1FFE,006C006CL0C0FFE,006FC8ECL0C07FE,006E68E4L0C03FE,006F6DA4L0C00FE,006FE524L0C007E,006E2724L0C003E,006F662CL0C001E,006FC26CL0CI0E,006C006CL0EI07,00240048L07I03,00340048L07C003,003600D8L07E003,0013019M07F003,0019FF3M07F803,I0C7C6M07FC03,I0600CM07FE03,I03FF8M07FF83,T07FFC3,T07FFE3,T0JF3,T07IFB,1E39E1CE27J0KF,336DB17A6787OFE,2341B37B6787OFE,3341E37B2587OFE,3E7D01CE2787OFE,0C3I0842307OFC,,^FS
	EndIf

	cString += "^FO50,30^GFA,1519,1519,31,,:K03hOFC,J07hQF8,J0hRFE,I0hTFE,I0FChQ07E,003FhR01F8,007ChS07C,00F8hS03E,00FhT01E,01ChU078,07ChU038,078hU03C,0F8hU03E,1FhV03E,1FhV01F,1EhV01F,3EhW078,:38hW078,38hW038,::::38hW078,3EhW078,:3EhV01F,1FhV01F,1F8hU03F,0F8hU03E,0F8hU03C,078hU03C,01ChU038,01FhT01E,00F8hS03E,0078hS07C,003EhS0FC,003FChQ07F8,I07FChO07FC,I01hSF,J07hQFC,K0hQF,,:::^FS" + CRLF
	cString += "^CF0,40" + CRLF
	cString += "^FO"+cValToChar(90)+","+cValToChar(50+nLin)+"^FD " + cProd + " ^FS" + CRLF
	cString += "^FO"+cValToChar(300)+","+cValToChar(50+nLin)+"^FD X " + cValToChar(cQtde) + " ^FS" + CRLF
	cString += "^CF0,20,10" + CRLF
	cString += "^CFA,20,10" + CRLF
	cString += "^FO"+cValToChar(60)+","+cValToChar(100)+"^FD " + cDesc1 + " ^FS" + CRLF
	cString += "^FO"+cValToChar(60)+","+cValToChar(130)+"^FD " + cDesc2 + " ^FS" + CRLF
	cString += "^CFA,15" + CRLF
	cString += "^FX Third section with barcode." + CRLF
	cString += "^BY2,2,70" + CRLF

	cString += "^FO"+cValToChar(100)+","+cValToChar(175)+"^BE^FD"+cCodBar+"^FS" + CRLF
	//cString += "^FO"+cValToChar(30+nCol)+","+cValToChar(175+nLin)+"^BC^FD " + cCodBar + "^FS" + CRLF

	cString += "^CFA,20" + CRLF
	cString += "^FO"+cValToChar(100)+","+cValToChar(280+nLin)+"^FD "+SB1->B1_XFROM+" ^FS" + CRLF
	cString += "^FO"+cValToChar(100)+","+cValToChar(310+nLin)+"^FD "+"BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))+" ^FS" + CRLF
	cString += "^FO"+cValToChar(100)+","+cValToChar(340+nLin)+"^FH_^FD "+AjuEspec(Alltrim(SB1->B1_XTECDF1))+" ^FS" + CRLF
	cString += "^FX Fourth section (the two boxes on the bottom)." + CRLF
	//>> Ticket 20210205001905 - Everson Santana - 11.02.2021
	// Ticket 20210218002720 - Everson Santana - 18.02.2021
	if AllTrim(SB1->B1_XNTCLOG) $ "RITIE"
		cString += "^FO"+cValToChar(120)+","+cValToChar(370+nLin)+"^GFA,1152,1152,16,,::007gKF,01gLFC,03CgJ01E,07gL07,0EgL038,0CgL018,18gM0C,:3gN06,:3001K03JF1JFC7C1JF806,3003IFE07JFBJFCFE3JF806,3003003F03I03B8I0CEE38003806,3003I0383I03BJ0CC63I01806,3003I0183I03B8I0CC63I01806,30033FF0C33IFBFE3FCC631IF806,30033FF8C33IF3FE3FCC631IF806,30033018C33K06300C6318J06,3003300CC33K06300C6318J06,:30033018C33FFE006300C631IF006,30033FF8C33IF006300C631IF006,30033FF1831FF7006300C631FFB006,3003I0383I07006300C63I03006,3003I0703I07006300C63I03006,30031C3E033IF006300C631IF006,30033F1C033IF006300C631IF006,300I38E033K06300C6318J06,300331C6033K06300C6318J06,300330C3033K06300C6318J06,30033063833K06300C6318J06,300330618338J06300C6318J06,30033030C33IF806300C631IFC06,30033038C33IF806300C631IFC06,3003301863I01806300C63J0C06,3003300C63I01806300C63I01C06,3003F00FF3JF807F00FE3JFC06,3003F007F3JF807F00FE3JF806,3gN06,::::3K0FE001FC07ES06,3003E1JF3FECFF61F8183F83F006,3007F1JFBFECFF73FC183FC7F806,300E3980C1860CC0730C3C30C61806,300C1980C1860CC077063C30EE1C06,301C0180C3860CC076007C306C0C06,301C01F8FF860CFC760066306C0C06,301C01F8FE060CFC760066306C0C06,301C0180C6060CC07600FF306C0C06,300C1980C7060CC07704FF30EC1C06,300E3980C3060CC0730CC330C61806,3007F1FEC1860CC073FD83BFC7F806,3003F1FFC1860CC061F981BF83F006,3001C1FEI020880206I01E00C006,3gN06,:18gM0C,:0CgL018,0EgL038,07gL07,03CgJ01E,00gLFC,003gKF,,:^FS" + CRLF
	Endif
	//<<
	cString += "^XZ" + CRLF

	//WaitRun("net use lpt1  \\localhost\Etiqueta")
	Memowrite("C:\Temp\"+cProd+".ETI",cString)
	__CopyFile("C:\Temp\"+cProd+".ETI",cPortaImp)
Return

//U_TestFlow2
User Function TestFlow2()
    Private nGQtdPCx := 1
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial('SB1')+"S3B62090")
	INIEAV1459()
	
Return


/*/{Protheus.doc} EAV14597
    description
        Rotina Impressão Etiqueta EAV1459702  - Flow Packs 265 x 200
    @type function
    @version 
    @author Valdemir Jose
    @since 11/09/2020
    @return return_type, return_description
/*/
Static Function INIEAV1459()
	Local cString      := ""
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx          //SB1->B1_XQTYMUL Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHO1                           //"PLACA 4 X 2 CEGA BRANCA"   //
	Local _cDesSpan    := SB1->B1_XSHO2                           //"PLACA 4 X 2 CEGA BRANCA"   //
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cDtProducao := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cPais       := SB1->B1_XFROM                      // POSICAO 08
	Local _cPais1      := SB1->B1_XFROM1                     // POSICAO 29
	Local _cDiagEletr  := ""
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := ""
	Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
	Local cPortaImp := "LPT1"
	Local nLin      := -39
	Local nCol      := 20


	cString += "^XA" + CRLF

	//Circulo
	cString += "^FO00,00^GFA,1519,1519,31,,:K03hOFC,J07hQF8,J0hRFE,I0hTFE,I0FChQ07E,003FhR01F8,007ChS07C,00F8hS03E,00FhT01E,01ChU078,07ChU038,078hU03C,0F8hU03E,1FhV03E,1FhV01F,1EhV01F,3EhW078,:38hW078,38hW038,::::38hW078,3EhW078,:3EhV01F,1FhV01F,1F8hU03F,0F8hU03E,0F8hU03C,078hU03C,01ChU038,01FhT01E,00F8hS03E,0078hS07C,003EhS0FC,003FChQ07F8,I07FChO07FC,I01hSF,J07hQFC,K0hQF,,:::^FS

	// Boneco
	cString += "^FO"+cValToChar(10+nCol)+","+cValToChar(665+nLin)+"^GFA,790,790,10,3XF87XFCYFE:FW01E::::FN07CM01EFM01FFM01EFM07FFCL01EFM0IFEL01E::FL01JFL01E:::::FM0IFEL01E:FM07FFCL01EFM03FF8L01EFN0FEM01EFW01E:FL03JF8K01EFK01KFEK01EFK03LF8J01EFK07LF8J01EFK07LFCJ01EFK0MFEJ01EFJ01NFJ01EFJ03C7JF87J01EFJ03C0IFE078I01EFJ07C00FE007CI01EFJ0FC003I07EI01EFI01FCL07EI01EFI01FCL07FI01EFI03FCL07F8001EFI07FCL07FC001E:FI0IFEJ0IFE001EF001JFI03JF001EF003JF8003JF001EF003JF8007JF801EF007JFC007JFC01EF00KFC007JFE01EF00KF8007JFE01EF01KF8003JFE01EF01KFI01JFE01EF00JFCJ07IFE01EF00KFI03JFE01EF007FC3FE01FF8FFC01EF003E03FFC7FF81F801EFK03LF8J01E::::FW01E::F03TF01E::::FW01E::::YFE:7XFC3XF8^FS

	// Segurança
	if !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		cString += "^FO"+cValToChar(185+nCol)+","+cValToChar(665+nLin)+"^GFA,648,648,12,,06,1FC,3DE,3800C0601080070660301C,3E03F1FF71CFDDCFF8FC7F,1FC739CF71CF8CCF39CE63,03E7FB8771CE0FCF3BC03F,30F7FB8F71CE3CCF3BC0F7,38E639CF79CE38CF39CEE3,3FE7F8FF3FCE3FCF39FCFF,0F81E04F1D8E0EC618787B,K01CEP03,L0FCP078,,:Q07OFE,J07EK07OFE,I03EF8J07OFE,I0E00EJ07OFE,I0CFE2J07OFE,0019C7BM0JFE,0013009M0DIFE,003600D8L0CIFE,00240048L0C3FFE,0024006CL0C1FFE,006C006CL0C0FFE,006FC8ECL0C07FE,006E68E4L0C03FE,006F6DA4L0C00FE,006FE524L0C007E,006E2724L0C003E,006F662CL0C001E,006FC26CL0CI0E,006C006CL0EI07,00240048L07I03,00340048L07C003,003600D8L07E003,0013019M07F003,0019FF3M07F803,I0C7C6M07FC03,I0600CM07FE03,I03FF8M07FF83,T07FFC3,T07FFE3,T0JF3,T07IFB,1E39E1CE27J0KF,336DB17A6787OFE,2341B37B6787OFE,3341E37B2587OFE,3E7D01CE2787OFE,0C3I0842307OFC,,^FS
	Endif

	// Retie - Valdemir Rabelo 26/01/2021 - Ticket:  20210125001289
	if !Empty(SB1->B1_XNTCLOG) .And. !AllTrim(SB1->B1_XNTCLOG)=="-"
		cString += "^FO"+cValToChar(165+nCol)+","+cValToChar(665+nLin)+"^GFA,1152,1152,16,,::007gKF,01gLFC,03CgJ01E,07gL07,0EgL038,0CgL018,18gM0C,:3gN06,:3001K03JF1JFC7C1JF806,3003IFE07JFBJFCFE3JF806,3003003F03I03B8I0CEE38003806,3003I0383I03BJ0CC63I01806,3003I0183I03B8I0CC63I01806,30033FF0C33IFBFE3FCC631IF806,30033FF8C33IF3FE3FCC631IF806,30033018C33K06300C6318J06,3003300CC33K06300C6318J06,:30033018C33FFE006300C631IF006,30033FF8C33IF006300C631IF006,30033FF1831FF7006300C631FFB006,3003I0383I07006300C63I03006,3003I0703I07006300C63I03006,30031C3E033IF006300C631IF006,30033F1C033IF006300C631IF006,300I38E033K06300C6318J06,300331C6033K06300C6318J06,300330C3033K06300C6318J06,30033063833K06300C6318J06,300330618338J06300C6318J06,30033030C33IF806300C631IFC06,30033038C33IF806300C631IFC06,3003301863I01806300C63J0C06,3003300C63I01806300C63I01C06,3003F00FF3JF807F00FE3JFC06,3003F007F3JF807F00FE3JF806,3gN06,::::3K0FE001FC07ES06,3003E1JF3FECFF61F8183F83F006,3007F1JFBFECFF73FC183FC7F806,300E3980C1860CC0730C3C30C61806,300C1980C1860CC077063C30EE1C06,301C0180C3860CC076007C306C0C06,301C01F8FF860CFC760066306C0C06,301C01F8FE060CFC760066306C0C06,301C0180C6060CC07600FF306C0C06,300C1980C7060CC07704FF30EC1C06,300E3980C3060CC0730CC330C61806,3007F1FEC1860CC073FD83BFC7F806,3003F1FFC1860CC061F981BF83F006,3001C1FEI020880206I01E00C006,3gN06,:18gM0C,:0CgL018,0EgL038,07gL07,03CgJ01E,00gLFC,003gKF,,:^FS"
	Endif


	cString += "^CF0,30,40" + CRLF
	cString += "^FO"+cValToChar(-10+nCol)+","+cValToChar(50+nLin)+"^FD "+_cProd+" ^FS" + CRLF
	cString += "^FO"+cValToChar(230+nCol)+","+cValToChar(50+nLin)+"^FD X"+cValToChar(_cQtdeV)+" ^FS" + CRLF

	cString += "^CF0,30,20" + CRLF

	If !Empty(SB1->B1_XSHO1) .And. !AllTrim(SB1->B1_XSHO1)=="-"
		cString += "^FO"+cValToChar(-20+nCol)+","+cValToChar(100+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XSHO1))+" ^FS" + CRLF
	EndIf
	If !Empty(SB1->B1_XSHO2) .And. !AllTrim(SB1->B1_XSHO2)=="-"
		cString += "^FO"+cValToChar(-20+nCol)+","+cValToChar(135+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XSHO2))+" ^FS" + CRLF
	EndIf
	cString += "^CFA,15" + CRLF

	cString += "^BY2,3,100" + CRLF
	cString += "^FO"+cValToChar(30+nCol)+","+cValToChar(195+nLin)+"^BE^FD"+Alltrim(cCodBar)+"^FS" + CRLF

	//http://labelary.com/viewer.html
	If !Empty(SB1->B1_XIMGFLO)
		cString += "^FO"+cValToChar(10)+","+cValToChar(489+nLin)+SubString(AllTrim(SB1->B1_XIMGFLO),At("^GFA",AllTrim(SB1->B1_XIMGFLO)),Len(AllTrim(SB1->B1_XIMGFLO)))
	EndIf
    /*
	If Alltrim(_cProd) $ 'S3B60350'
        cString += "^FO"+cValToChar(50+nCol)+","+cValToChar(489+nLin)+"^GFA,4118,4118,29,,:hO02004,hO0200C,hO02014,gM03Cg02004,gM07Eg02004,gM0FFg02004,hNF82004,gM0FFg02004,:gM07Eg02004,gM03Cg03F84,gM01,::::::::gM01gG020428078,gM03gG030428084,T07CQ04gG028448084,T0FEQ08gG028448004,T0FFQ08gG02I48004,hNF824488008,T0FFQ08gG022488008,T0FEQ04gG02148801,T07EQ03gG02148802,T018Q01gG020D0804,T01R01gG02050FEFC,T01R01,:::::T01R01gI06,:::T03L0FK03gI06,T04K01F8J04gI06,T08K03FCJ08gI06,hNF87IFE,T08K03FCJ08gG07IFE,T08K03FCJ08,T04K01F8J04gH0IF,T03L0FK028gG0IF,T01L02L08,:T01L02L08gG03FC,:T01L02L08,:::::::::::::::::::::::N0gMF,M03L01L02L08L0C,M04L01L02L08L02,:M08L01L02L08L01,::M08J0KFEI02I07KFJ01,M08I03001001C002003800800CI01,M08I04001I02002004I08002I01,M08I08001I02002004I08001I01,M08001I01I01002008I08001I01,M08001I01I01002008I08I08001,:::M08001I0FF00100200800FFI08001,M08001001D080100200801C8C008001,M0800100276401002008026F4008001,M080010067F201002008077FA008001,M08001007FFA0100200807FFA008001,M0800100DFFA0100200805FFB008001,M0800100DFF20100200804FF1008001,:L07800100DFFA0100200805FFB008001E,L048001005FFE0100200805FFE0080012,L048001005FE60100200806FE60080012,L048001002E6401002008026640080012,L04800100103801002008010380080012,L048001208FF001KF800FFI080012,L048001308J01002008M080012,L048001288J01002008M080012,:L048001248J01002008M080012,:L048001228J01002008M080012,:L048001218J01002008M080012,L048I0A08J01002008L01I012,L048I08L02002004L01I012,L078I04L02002004L02I01E,M08I03K01C0020038K0CI01,M08J0KFEI02I07KFJ01,M08O02001F8004O01,M08O0200726004O01,M08O0200F21004O01,M08O02009BD03F8N01,M08O02019FE8404N01,M08O02017FE8842N01,M08O02013FC9041N01,M08O02013FCA0408M01,:M08O02017FEA0408M01,M08O02017FBA0408M01,M08O0201B99AFFE8M01,M08O020090D2I08M01,M08O020060623F88M01,M08O02001F81001N01,M08O02L09F2N01,M08O02L0404N02,M04O02L03F8N02,M03O02M04O0C,N0gMF,^FS" + CRLF
	ENDIF

	If Alltrim(_cProd) $ 'S3B69050'

        cString += "^FO"+cValToChar(00+nCol)+","+cValToChar(489+nLin)+"^GFA,4797,4797,41,,:gR0201h01004,gR0203h0100C,gR0205h01014,007gO0201gN03EP01004,00F8gN0201gN07EP01004,gQFE201L01gRFC1004,00F8gN0201gN07EP01004,:007gO01EgO01CP01F04,002,::::::002gO0200203gW0100201800CgO0308A048gJ01Q0184602401gL01E00208AW0FO03Q01046,01gL03F002892008S01FO04Q0144A004FBgLFBFBC2492008I0gGF7PFC124A00402gL03F00249201T01F8N04Q0124A00802gL03F00228202T01FO02Q0115201,01gM040021A204U0FO01Q010D202,008gL040020A3E78gV01013E7C006gL04gI04,002gL04gI04,:::002gL04gI04gI04,:002gL04hM04,002gL04gI04O01S04,002gL04gH018J07CI03S04,002gL04gH01K0FCI04Q01IF8,002N07FF8T04gH01K0FCI04Q01IF8,002N04008T04R0gRFC,002K01FFC00FFCR04gH01K0FCI04,002K0EM018Q04gI0CJ078I03R07FE,002J01O04Q04gI04J01J01,002J01O04Q04gN01,002J01O04Q04gI04J01W01F8,002J01O04Q04gI04J01,:::::002J01K07CF84Q04gI04J01,002J01K085044Q04gI04J01,002J01J017BF44Q04gI04J01,002J01J01010A4Q04gI04J01,::002J01J0104824Q04gI04J01,002J01J012F644Q04gI04J01,002J01K0FDF84Q04gI04J01,002J01O04Q04gI04J01,:002J01L07004Q04gI04J01,002J01L0D804Q04gI04J01,002J01K019804Q04gN01,002J01M0804Q04W01KF7JFD7IFDKFE,002J01L01004Q04W06K04J01J01K018,002J01L02004Q04W08P01Q04,002J01L04004Q04W08K04J01Q04,002J01L0C004Q04gI04J01Q04,002J01K01F804Q04gN01Q04,002J01O04Q04g01KF001003JFEI04,002J01O04Q04g06K0801004J018004,002J01O04Q04g0400400401008K08004,002J01O04007IFEJ04g08004J0101L04004,002J01O04004I01J04g080040020101L04004,002J01O04004I01J04g08K020101L04004,002J01O04004I01J04g0800600201010018004004,002J01O04004I01J04g0801F80201010077004004,002J01O04004I01J04g08070402010100C0804004,002J01O04004I01J04g0801BA0201010137C04004,002J01O04004N04g080DFE02010101FFC04004,002J01008L04004I038I04g080BF902010102FF404004,002J01008J0C04004I07CI04g080BF9020101027E604004,002J01008I03C04004I086I04V01I080BF9020101027E604006,002J01008I02C04004001FFI04V05I080BFD02010100FF404005,002J01008J0C0400400183I04V04I080BF6020101017EC04004,002J01008J0C0400400183IFCV04I0805120201010126804004,002J01008J0C0400400183g04I08020C02010100C3804004,002J01008J0C0400400183g04I0B09F803JF003E004004,002J0100F8I0C04004001FFg04I0B08I020101L04004,002J0100F8I080400400303g04I0A88I020101L04004,002J01O0400400101g04I0A48I020101L04004,:002J01030603070400400301g04I0A28I020101L04004,002J010E990ED884004002gH04I0A08I020101L04004,002J0118709C3044004002008Y04I0A18I020101L04004,002J0117D1509F04004002008Y04I04K0401008K08004,002J012F90500FA400400400CY03I02K0801008J01I07,M01AF90500FE4K04004gI01KF001001JFEI04,M013F90580FA4K08006gN02003001N04,M0117FF57EF44J01I03gN0201DE01N04,M0110D088D0C4J01I01gN0202D101N04,M01078F078F04J03I018gM02027C87EM04,M01O04J03I018gM0205FE901M04,M01O04J03I018gM0204FEA108L04,M01O04J03I018gM0204FCA104L04,M01O04J03I01gN0204FE8104L04,M01O04J01I01gN0205FE8104L04,M01O04J01I02gN0200E90FF4L04,M01O04K08006gN02024EI04L04,M01O04K04004gN0201FC2008L04,N08N0CK03018g08M02J02388L04,N06M038L0FFgG08M02J0183M04,O0FF800FFCgP04M02K07CM04,Q04008gR06M02K01M018,Q07FF8,^FS
        //cString += "^FO"+cValToChar(00+nCol)+","+cValToChar(489+nLin)+"^GFA,9794,9794,59,,::hL02001hX04001,hL02003hX04003,hL02005hX04005,hL02009hX04009,I078hG02001h01F8U04001,I0FChG02001h03FCU04001,001FEhG02001h07FCU04001,hKF82001O01hLFC04001,001FEhG02001h07FCU04001,:001FEhG02001h03FCU04001,I0FChG03F81h01F8U07F01,I078jL06,I02jM04,:::::::::I02hH020205003CgV04V04040C0078,I0EhH0302090044gV04V0604140088,001gX07CI0282090082g01ES01CV0504140104,002gX0FEI028209I02g03F8R02W050414I04,002gW01FEI024211I02g07F8R02W048424I04,004gW01FFI0I211I04g07FCR02W0I424I08,hKF8I211I04J01hLFC0I424I08,004gW01FEI021221I08g07FCR02W042I4001,004gW01FEI020A21001gG07F8R02W041I4002,004gX0FCI020A21002gG03F8R018V041I4004,002gX01J020641004gG01FT04V040C84008,001gX01J020241FCFEgG04T04V040487F1FC,I0EgW01gT04T04,I02gW01gT04T04,::::::I02gW01gT04T04X06,:::I02gW01gT0CT04X06,I02gW01gS03M07EK018X06,I02gW01gS04M0FFK02Y06,I02gW01gS04L01FFK02W0KF8,I02R0JF8g01gS04L01FFK02W0KF8,I02R08I08g01W01hLFC,I02R08I08g01gS04L01FFK02,I02N03IF8I0IFCW01gS04M0FFK02,I02M01CP01CV01gS03M07EK018V01IFC,I02M06R03V01gT0CL018L04V01IFC,I02M04R01V01gT04M08L04,:I02M04R01V01gT04M08L04W03FE,:I02M04R01V01gT04M08L04,:::::::I02M04M0701C01V01gT04M08L04,I02M04L01CE6381V01gT04M08L04,I02M04L03028041V01gT04M08L04,I02M04L04F9BF41V01gT04M08L04,I02M04L05044121V01gT04M08L04,I02M04L050440A1V01gT04M08L04,:::I02M04L05042121V01gT04M08L04,I02M04L04FBBE41V01gT04M08L04,I02M04L020680C1V01gT04M08L04,I02M04L01FC7F01V01gT04M08L04,I02M04R01V01gT04M08L04,::I02M04N078001V01gT04M08L04,I02M04N0FC001V01gT04M08L04,I02M04M01CE001V01gT04M08L04,I02M04M0186001V01gT04M08L04,I02M04O06001V01gT04M08L04,I02M04O06001V01gL0gQFE,I02M04O0C001V01gK03N04M08L04M018,I02M04N018001V01gK04N04M08L04N04,I02M04N03I01V01gK04N04M08L04N04,I02M04N06I01V01gK08N04M08L04N02,I02M04N0CI01V01gK08N04M08L04N02,I02M04M01FE001V01gK08N04M08L04N02," 
        //cString += ":I02M04R01V01gK08J03MFJ08001MF8J02,I02M04R01V01gK08J0CI04I08I08002I04I06J02,I02M04R01V01gK08I01J04I04I08004I04I01J02,I02M04R01V01gK08I01J04I02I08008I04I01J02,I02M04R01J0LFCK01gK08I02J04I02I08008I04J08I02,I02M04R01J08K04K01gK08I02J04I01I0801J04J08I02,:::I02M04R01J08K04K01gK08I02J0EI01I0801J0FJ08I02,I02M04R01J08K04K01gK08I02I075C001I0801I074EI08I02,I02M04R01J08K04K01gK08I02001C42001I0801I0E41I08I02,I02M04R01J08K04K01gK08I02002759001I080100134C8008I02,I02M04R01J08K04K01gK08I0200237C801I08010031DEC008I02,I02M04R01J08K04K01gK08I020077FE801I0801003BFF4008I02,I02M04R01J08K04K01gK08I02005FFEC01I0801002IF4008I02,I02M04006L03001J08J01F8J01gK08I02004FFC401I08010067FE6008I02,I02M04006L07001J08J03F8J01gK08I02004FFC401I08010067FC6008I02,I02M04006L0F001J08J060CJ01gK08I02004FFC401I08010067FC6008I02,I02M04006K01B001J08J0E07J01gJ078I02004FFC401I08010027FE6008I03C,I02M04006K013001J08J0IFJ01gJ048I02005FFEC01I0801002IF4008I024,I02M04006L03001J08J0C03J01gJ048I02004FFB801I08010027FDC008I024,I02M04006L03001J08J0C03J01gJ048I020027F1801I08010013F8C008I024,I02M04006L03001J08J0C03KFgJ048I02001219001I080100110C8008I024,I02M04006L03001J08J0C03gO048I02I080E001I0801I0C07I08I024,I02M04006L03001J08J0C03gO048I024047FC001LFI03FCI08I024,I02M04006L03001J08J0C03gO048I02604K01I0801O08I024,I02M04007F8J03001J08J0IFgO048I02504K01I0801O08I024,I02M04007F8J03001J08I018038gN048I02504K01I0801O08I024,I02M04R01J08I018018gN048I02484K01I0801O08I024,I02M04R01J08I018018gN048I02I4K01I0801O08I024,:I02M04R01J08I018018gN048I02424K01I0801O08I024,I02M040380E00701E01J08I010018gN048I02414K01I0801O08I024,I02M040E63181CE6181J08I01I08gN048I02414K01I0801O08I024,I02M041814043028041J08I03I0CgN048I0240CK01I0801O08I024,I02M0427DDF24F9BF41J08I03I0CgN048I01404K02I08008N08I024,I02M042FE20A5047F21J08I02I04gN048I01N02I08008M01J024," 
        //cString += "I02M044FE20A5047FA1J08I06I06gN078J08M04I08004M02J03C,I03PFE20A5047MF8I04I06gO08J06L018I080038L0CJ02,Q045FE20A5047FA1N0CI03gO08J01LFEJ08I07LFK02,Q046FE20A5047FA1M018I038gN08Q04I018I04Q02,Q042FE20A5043F21M03K0CgN08Q04001EFI04Q02,Q0427DDF24FBBE41M03K0CgN08Q0400388C004Q02,Q0410340420680C1M02K04gN08Q04004CA6004Q02,Q040FE3F81FC7F01M06K06gN08Q0400C7F203FCP02,Q04R01M06K06gN08Q0400CFF90C02P02,Q04R01M06K06gN08Q04013FF91041P02,Q04R01M06K06gN08Q04011FF920408O02,Q04R01M06K06gN08Q04011FF120404O02,Q04R01M06K06gN08Q04011FF140404O02,Q04R01M06K04gN08Q04011FF940404O02,Q04R01M02K04gN08Q04013FF940404O02,Q04R01M03K0CgN08Q0400BFE740404O02,Q04R01M03K08gN08Q04009E624IF4O02,Q04R01M018I018gN08Q04004C744I04O02,Q04R01N0CI03gO08Q0400201847FC4O02,Q04R01N06I06gO08Q04001FF02I08O02,Q06R03N03801CgO08Q04L021F08O02,Q03R06N01IF8gO04Q04L01001P02,R0EP038O03FCgP04Q04M0C06P04,R01IF8I0IFChI02Q04M03F8P04,V08I08hL03Q04N04P018,V08I08hM0gQFE,V0JF8,^FS" + CRLF
	Endif
    */
	cString += "^CFA,20" + CRLF
	cString += "^FO"+cValToChar(-20+nCol)+","+cValToChar(395+nLin)+"^FD "+_cPais+" ^FS" + CRLF
	cString += "^FO"+cValToChar(135+nCol)+","+cValToChar(395+nLin)+"^FD "+_cDtProducao+" ^FS" + CRLF

	If !Empty(SB1->B1_XTECDF1) .And. !AllTrim(SB1->B1_XTECDF1)=="-"
		cString += "^FO"+cValToChar(090+nCol)+","+cValToChar(435+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XTECDF1))+" ^FS" + CRLF
	EndIf
	If !Empty(SB1->B1_XTECDF2) .And. !AllTrim(SB1->B1_XTECDF2)=="-"
		cString += "^FO"+cValToChar(090+nCol)+","+cValToChar(460+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XTECDF2))+" ^FS" + CRLF
	EndIf
	//>> Ticket 20210218002720 - Everson Santana - 18.02.2021
	if AllTrim(SB1->B1_XNTCLOG) $ "RITIE"
		cString += "^FO190,620^GFA,1615,1615,19,I07gPF,007gQFE,01gSF8,03EgQ03E,078gR0F,0EgS078,1CgS01C,38gS01C,38gT0E,7gU06,7gU07,6gU07,6gU03,EP02gJ03,E001JFE007KF9LF9FF0LF003,E001KF807KFDLF9FE0LF003,E001CI07C07J039CJ039C60CJ07003,E0018J0E07J039CJ039C60CJ07003,E0018J0707J039CJ039C60CJ07003,E00183FF03071JFDFFC3FF9C60C3JF003,E00187FFC3871JF9FFC3FF9C60C7JF003,E0018601C3871JF8FFC3FF1C60C7IFE003,E0018600E1871CL0C3001C60C7L03,E001860061871CL0C3001C60C7L03,:E001860063871CL0C3001C60C7L03,E0018600E3871JFI0C3001C60C7IFC003,E00187FFC3071JFI0C3001C60C7IFC003,E00187FF87070JFI0C3001C60C3IFC003,E0018J0F07J07I0C3001C60CJ0C003,E0018I01E07J07I0C3001C60CJ0C003,E0018I0FC070JFI0C3001C60C3IFC003,E00187C1F0071JFI0C3001C60C7IFC003,E00187F1E0071JFI0C3001C60C7IFC003,E00187F870071CL0C3001C60C7L03,E001861C38071CL0C3001C60C7L03,E001860C1C071CL0C3001C60C7L03,E001860E1C071CL0C3001C60C7L03,E00186070E071CL0C3001C60C7L03,E001860707071CL0C3001C60C7L03,E001860387071JFC00C3001C60C7JF003,E0018601C3871JFC00C3001C60C7JF003,E0018601C1870IFDC00C3001C60C3IF7003,E0018600E1C7J01C00C3001C60CJ03003,E001860060C7J01C00C3001C60CJ03003,E001C60070E7KFC00FF001FE0LF003,E001FE003FE7KFC00FF801FE0LF003,E001FE003FE7KFC00FF001FE0LF003,EgU03,::::::EI0FC1FFDFF3FFDCFFEE0FE0180FF00FC003,E001FE1KFBFFDCIFE1FF0381FF83FE003,E007FF1FFBFFDFF9CFFEE3FF03C1FFC7FF003,E007071C0381C1C1CE00E38387C1C1C707003,E006031C0381C1C1CE00E70387E1C0E603003,E00E001C0381C1C1CE00E70106E1C0EE03803,E00E001FC3FFC1C1CFF0E7I0E61C0EE03803,E00E001FE3FF81C1CFF0E7I0E71C0EE03803,E00E001FC3FE01C1CFF0E7I0E71C0EE03803,E00E001C038E01C1CE00E7001FF1C0EE03803,E006031C038701C1CE00E7019FF9C0EE03803,E007071C038781C1CE00E383B839C1C707003,E0078F1C038381C1CE00E3C7B81DC3C78F003,E003FE1IF81C1C1CE00E1FF301DFF83FE003,E001FC1FFD81C1C1CE00E0FE300DFF01FC0038EI0781FF80081808600C038J0FC007I03,EgU03,6gU03,6gU07,7gU06,3gU0E,38gT0C,1CgS01C,0EgS038,07gS07,03CgQ01E,01F8gP0FC,007gRF,I0gQF8,,^FS"
	EndIf
	//<<
	If !Empty(SB1->B1_XCERING) .And. !AllTrim(SB1->B1_XCERING)=="-"   // Valdemir Rabelo 28/03/2022- Ticket: 20220324006522
       cString += "^FO200,720^GFA,1001,1001,13,,Q013,P03IF,O01JFE,O07KFC,N01LFE,N07MF8,N0NFC,M01NFE,M03OF8,M07OFC,M0PFC,L01PFE,L03QF,L03QF8,L07QF8,L07FFN07C,L0FFCN07C,L0FF8N07E,K01FEO07E,K01FCO07E,K01FCO0FF,K03F803OF,K03F80PF,K03F01PF,K03F01PF8,N03F,::N07F,N03F,::K03F01PF,K03F00PF,K03F807OF,K01F801OF,K01FCO07E,:L0FEO07E,L0FF8N07C,L07FCN07C,L07FFN078,L03QF8,L03QF,L01PFE,M0PFE,M07OFC,M03OF8,M01OF,N0NFE,N07MF8,N01MF,O0LFC,O03KF,P07IFC,Q03F,,:::::E700E0IFC1IF81IFBIFC,E780E1IFC3IF87IFBIFE,E7C0E3IFC7IF8JFBJF,E7E0E78I0FJ0EM0F,E7F0E7J0EI01CM07,E7FCE61FFCEI01CIF38007,E67EE61FFCEI01CIFBC007,E63FE71FFCEI01CIFBIFE,E61FE7I0CEI01EI03IFE,E60FE7801CF8001FI03JF,E607E3IFC7IF8JFBC01F8,E603E3IFC3IF87IFBC00FC,E601E0IFC1IF83IFBC007C,,^FS"
	Endif 

	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(745+nLin)+"^FD Instalacion debe ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(765+nLin)+"^FD ser realizada ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(785+nLin)+"^FD por una persona ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(805+nLin)+"^FD calificada, ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(825+nLin)+"^FD recomendamos ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(845+nLin)+"^FD un eletricista ^FS" + CRLF

	// Valdemir Rabelo - 18/11/2021 - Ticket: 20211112024339 Adicionado Logo NOM
	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(865+nLin)+"^GFA,759,759,11,,::0XF,0XF8,::0XF,,:::::0FC3F001FE001F8001F8,0FC1F003FF801F8003F8,0FC1F007FFC01FC003F8,0FC1F00IFE01FC007F8,0FE1F01IFE01FC007F8,0FE1F01JF01FC00FF8,0FE1F01F83F01FE00FF8,:0FF1F01F01F01FE00FF8,0FF1F01F01F01FE01FF8,:0FF9F01F01F01FF01FF8,:0FF9F01F01F01FF83FF8,0FFDF01F01F01FF83FF8,0FFDF01F01F01FF87FF8,0FFDF01F01F01FFC7FF8,0JF01F01F01FFC7FF8,0JF01F01F01FFCIF8,0JF01F01F01FFEFDF8,0JF01F01F01F7EFDF8,0JF01F01F01F3FF9F8,::0FBFF01F01F01F3FF1F8,:0F9FF01F01F01F1FF1F8,0F9FF01F01F01F1FE1F8,:0F8FF01F01F01F1FE1F8,0F8FF01F01F01F0FC1F,0F8FF01F01F01F07C1F8,0F87F01F83F01FI01F8,0F87F03F83F01FI01F8,0F87F01FEFF01FI01F8,0F83F00IFE01FI01F8,:0F83F007FFC01FI01F8,0F83F003FF801FI01F8,0FC3FI0FF001FI01F8,0F81FI038001FI01F,,::::0XF,::::,:::^FS
	EndIf


	cString += "^XZ" + CRLF
	//WaitRun("net use lpt1  \\localhost\Etiqueta")
	_cProd := Alltrim(_cProd)
	Memowrite("C:\Temp\"+_cProd+"_2.ETI",cString)
	__CopyFile("C:\Temp\"+_cProd+"_2.ETI",cPortaImp)
Return



/*/{Protheus.doc} HRB8045002
    description
        Rotina Impressão Etiqueta HRB8045002  - Flow Packs 210 X 140
    @type function
    @version 
    @author Valdemir Jose
    @since 11/09/2020
    @return return_type, return_description
/*/
Static Function INIHRB8045()
	Local cString   := ""
	Local cProd     := "PRM044011"
	Local cQtde     := "1"
	Local cDesc1    := "Interrupetor Simples CJ BR"
	Local cDesc2    := "Inter Sencillo Cj BL"
	Local cCodBar   := "12345678"
	Local cPais     := "Made in Brasil"
	Local cCodX     := "BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))
	Local cDescTec  := "10A 250V"
	Local cPortaImp := "LPT1"
	Local nLin      := 0
	Local nCol      := 0

	cString += "^XA" + CRLF

	//Circulo
	cString += "^FO00,00^GFA,1519,1519,31,,:K03hOFC,J07hQF8,J0hRFE,I0hTFE,I0FChQ07E,003FhR01F8,007ChS07C,00F8hS03E,00FhT01E,01ChU078,07ChU038,078hU03C,0F8hU03E,1FhV03E,1FhV01F,1EhV01F,3EhW078,:38hW078,38hW038,::::38hW078,3EhW078,:3EhV01F,1FhV01F,1F8hU03F,0F8hU03E,0F8hU03C,078hU03C,01ChU038,01FhT01E,00F8hS03E,0078hS07C,003EhS0FC,003FChQ07F8,I07FChO07FC,I01hSF,J07hQFC,K0hQF,,:::^FS

	// Produto
	//cString += "^FO"+cValToChar(100+nCol)+","+cValToChar(220+nLin)+"^GFA,2869,2869,19,,:408008,608008,508008,:488008,:448008T01QFE,428008T06R0C,428008T08R02,418008S01S01,408008S02S01,40800FCR04T08,Y08T04,X01U02,X02U01,X04U01,X08V08,01J08P01W04,01J08P02W02,01J08P02W018,01J08P02X08,::::01J08J07F8I02003JF800KFI08,01J08I01804I0200EJ0301J01C008,01J08I02003I02018K086K06008,01I0FFI05007I0203L044K03008,01001088008804800202L048K01808,01002084008404400206L068L0808,078020820102084002043E00F8283C00F0808,0FC040820101104002047F01FC287E01F8C08,1FE040820100A04002047F01FC28FE03FC408,1IFC083FF00407MF01FE28FF03FC408,1FEI0800100A04002047F01FE28FF03FC408,1FEI0800101104002047F01FC28FE03FC408,0FCI0800102084002043F00FC287E01F8C08,078I0800104044002041C007028180060808,01J08I08802800206L068J040808,01J08I09003800202L048J041808,01J08I06001I0203L044J043008,01J08I03002I02018K082J046008,01J08J0C1CI0200EJ03018I05C008,01J08J03EJ02003JFC007JFI08,01J08P02T04I08,:::01J08P02Q04004I08,01J08P02J03L04004I08,01J08P02J05L04004I08,01J08P02J01L04004I08,:::::::01J08P02J01L07E04I08,01J08P02T04I08,::::::01I03CP02T04I08,01I07EP02T04I08,01I07FP02T04I08,01I0gMFCI08,01I0FFP02X08,01I07FP02X08,01I07EP02X08,01I01CP02X08,01J08P02X08,:::::::::::::::::::::::::::::::::01J08P02003JFC00KF8008,01J08P0200EJ0103K0E008,01J08P02018K084K03008,01J08P0203L048K01008,01J08P0202L048K01808,01J08P0206L068L0808,01J08P02043E00F8287C01F0808,01J08P02047F01FC28FE03F8C08,01J08P02047F01FC28FF03FC408,01J08P02047F01FE28FF03FC408,01J08P02047F01FC28FF03FC408,01J08P02047F01FC28FE03F8C08,01J08P02043E00F8287E01F8808,01J08P0206L028L0808,01J08P0202L068K01808,01J08P0203L048K01008,01J08P02018K044K03008,01J08P0200CJ0182K0E008,01J08P020078I0601CI038008,01J08P02I0JF8003IFEI08,01J08P02X08,::::01J08P02W01,01J08P01W02,01J08Q08V04,01J08Q04V08,01J08Q04U01,01J08Q02U02,01J08Q01U04,01J08R08T08,01J08R04S01,01J08R03S01,01J08R01S03,01J08S0CR04,01J08S03Q038,gG0QFC,^FS" + CRLF

	//http://labelary.com/viewer.html
	If !Empty(SB1->B1_XIMGFLO)
		cString += "^FO20,220"+SubString(AllTrim(SB1->B1_XIMGFLO),At("^GFA",AllTrim(SB1->B1_XIMGFLO)),Len(AllTrim(SB1->B1_XIMGFLO)))
	EndIf

    /*
	Do Case
	Case AllTrim(SB1->B1_COD)$"S3B77400#S3B76120#S3B76140#S3B76020"
        cString += ""
	Case AllTrim(SB1->B1_COD)$"S3B66340#S3B66440"
        //cString += "^FO20,220^GFA,4118,4118,29,,:hO02004,hO0200C,hO02014,gM03Cg02004,gM07Eg02004,gM0FFg02004,hNF82004,gM0FFg02004,:gM07Eg02004,gM03Cg03F84,gM01,::::::::gM01gG020428078,gM03gG030428084,T07CQ04gG028448084,T0FEQ08gG028448004,T0FFQ08gG02I48004,hNF824488008,T0FFQ08gG022488008,T0FEQ04gG02148801,T07EQ03gG02148802,T018Q01gG020D0804,T01R01gG02050FEFC,T01R01,:::::T01R01gI06,:::T03L0FK03gI06,T04K01F8J04gI06,T08K03FCJ08gI06,hNF87IFE,T08K03FCJ08gG07IFE,T08K03FCJ08,T04K01F8J04gH0IF,T03L0FK028gG0IF,T01L02L08,:T01L02L08gG03FC,:T01L02L08,:::::::::::::::::::::::N0gMF,M03L01L02L08L0C,M04L01L02L08L02,:M08L01L02L08L01,::M08J0KFEI02I07KFJ01,M08I03001001C002003800800CI01,M08I04001I02002004I08002I01,M08I08001I02002004I08001I01,M08001I01I01002008I08001I01,M08001I01I01002008I08I08001,:::M08001I0FF00100200800FFI08001,M08001001D080100200801C8C008001,M0800100276401002008026F4008001,M080010067F201002008077FA008001,M08001007FFA0100200807FFA008001,M0800100DFFA0100200805FFB008001,M0800100DFF20100200804FF1008001,:L07800100DFFA0100200805FFB008001E,L048001005FFE0100200805FFE0080012,L048001005FE60100200806FE60080012,L048001002E6401002008026640080012,L04800100103801002008010380080012,L048001208FF001KF800FFI080012,L048001308J01002008M080012,L048001288J01002008M080012,:L048001248J01002008M080012,:L048001228J01002008M080012,:L048001218J01002008M080012,L048I0A08J01002008L01I012,L048I08L02002004L01I012,L078I04L02002004L02I01E,M08I03K01C0020038K0CI01,M08J0KFEI02I07KFJ01,M08O02001F8004O01,M08O0200726004O01,M08O0200F21004O01,M08O02009BD03F8N01,M08O02019FE8404N01,M08O02017FE8842N01,M08O02013FC9041N01,M08O02013FCA0408M01,:M08O02017FEA0408M01,M08O02017FBA0408M01,M08O0201B99AFFE8M01,M08O020090D2I08M01,M08O020060623F88M01,M08O02001F81001N01,M08O02L09F2N01,M08O02L0404N02,M04O02L03F8N02,M03O02M04O0C,N0gMF,^FS"
        cString += "^FO20,220^GFA,4118,4118,29,,:hN0801,hN0803,hN0805,gL01Cg0801,gL03Eg0801,hLFE0801,gL07Fg0801,:gL03Eg0801,gL01Cg0FE1,gM08,::::::::gM08g0810403C,S01FQ02gG0A114042,S03F8P04gG0A114002,S03FCP04gG09114002,hLFE09124004,S03FCP04gG08924004,S03F8P02gG08524008,S01F8P018g0852401,T06R08g0834402,T04R08g08147F7E,T04R08,:::::T04R08gG018,::T0CK078J018gG018,S01L0FCJ02gH018,S02K01FEJ04gH018,hLFE1JF,S02K01FEJ04g01JF,S02K01FEJ04,S01L0FCJ02gG03FF8,T0CK078J014g03FF8,T04K01L04,:T04K01L04gG0FF,:T04K01L04,:::::::::::::::::::::M01gLF,M06L04K01L04L0C,M08L04K01L04L02,:L01M04K01L04L01,::L01J06004007001001C00400CI01,L01J08004I0801002I04002I01,L01I01I04I0801002I04001I01,L01I02I04I0401004I04001I01,L01I02I04I0401004I04I08001,:::L01I02003FC00401004007FI08001,L01I02007420040100400E4C008001,L01I02009D90040100401374008001,L01I02019FC8040100403BFA008001,L01I0201FFE8040100403FFA008001,L01I02037FE8040100402FFB008001,L01I02037FC80401004027F1008001,L0FI02037FE8040100402FFB008001C,L09I02017FF8040100402FFE0080014,L09I02017F980401004037E60080014,L09I0200B9900401004013240080014,L09I020040E00401004008380080014,L09I02423FC007JFC007FI080014,L09I0262K0401004M080014,L09I0242K0401004M080014,:L09I0252K0401004M080014,:L09I024AK0401004M080014,:L09I0246K0401004M080014,L09I0142K0401004L01I014,L0FJ08L0801002L02I01C,L01J06K07001001CK0CI01,L01J01KF8001I03KFJ01,L01P0800FC002O01,L01P080193002O01,L01P080390802O01,L01P0802DE81FCN01,L01P0806FF4202N01,L01P0805FF4421N01,L01P0805FE48208M01,L01P0805FE50204M01,:L01P0805FF50204M01,L01P0805FDD0204M01,L01P0807CCD7FF4M01,L01P08010311FC4M01,L01P0800FC08008M01,L01P08K04F9N01,L01P08K0202N02,M08O08K01FCN02,M06O08L02O0C,M01gLF,,::::::::^FS
	Case AllTrim(SB1->B1_COD)$"S3B60340"
        cString += "^FO20,220^GFA,4118,4118,29,,:hM01002,hM01006,hM0100A,gL03CY01002,gL07EY01002,hLFC1002,gL0FFY01002,:gL07EY01002,gL03CY01FC2,gL01,:::::::gL01g010210078,gL03g018210084,S01FQ04g014220084,S03F8P08g01422I04,S03FCP08g01I2I04,hLFC1224I08,S03FCP08g01124I08,S03F8P04g010A4001,S01F8P03g010A4002,T06Q01g01068004,T04Q01g010287EFC,T04Q01,::::T04Q01gH03,:::T0CK078J03gH03,S01L0FCJ04gH03,S02K01FEJ08gH03,hLFC3IFE,S02K01FEJ08g03IFE,S02K01FEJ08,T0CK078J028g07FF8,T04K01L08,:T04K01L08g01FE,:T04K01L08,:::::::::::::::::::::M01gKFE,M06L04K01L08K018,M08L04K01L08L04,:L01M04K01L08L02,::L01J03KFI01I07KFJ02,L01J0C00400E001001800800CI02,L01I01I04001001002I08002I02,L01I02I04001001002I08L02,L01I04I04I0801004I08L02,L01I04I04I0801004I08001I02,::L01I04003FC0080100400FF001I02,L01I04007420080100401C8C01I02,L01I04009D900801004026F401I02,L01I04019FC80801004077FA01I02,L01I0401FFE8080100407FFA01I02,L01I04037FE8080100405FFB01I02,L01I04037FC8080100404FF101I02,:L0FI04037FE8080100405FFB01I03C,L09I04017FF8080100405FFE01I024,L09I04017F98080100406FE601I024,L09I040040E008010040103801I024,L09I04823FC00KFC00FF001I024,L09I04C2K0801004L01I024,L09I04A2K0801004L01I024,:L09I0492K0801004L01I024,:L09I048AK0801004L01I024,:L09I0486K0801004L01I024,L09I0282K0801004P024,L09I02L01001002P024,L0FI01L01001002L02I03C,L01J03KFI01I07KFJ02,L01S0FC004O02,L01R0393004O02,L01R0790804O02,L01R04DE81F8N02,L01R0CFF4204N02,L01R0BFFI42N02,L01R09FE4841N02,L01R09FE50408M02,:L01R0BFF50408M02,L01R0BFDD0408M02,L01R0DCCD7FE8M02,L01R030311F88M02,L01S0FC0801N02,L01V04F2N02,L01V0204N04,M08U01F8N04,M06V04N018,M01gKFE,,:::::::::^FS
	OtherWise
        cString += "^FO20,220^GFA,4692,4692,34,,:N08,70E038018hX0470E038038hX0C78E038078hP070E01C01C7CE0380F8hP078E01C03C7CE0381F8X07PF8g078E01C07C76E038038X0QFCg07CE01C0FC77E038038W01CO01Eg07CE01C01C73E038038W038P0Fg07EE01C01C71E038038W07Q078Y077E01C01C71E03FE38W0EQ03CY073E01C01C70E03FE38V01CQ01EY071E01FE1CJ03FE38V038R0FY070E01FE1CgK07S078X070E01FE1CgK0ES03C,gJ01CS01E,0FI0FX038T0F,0FI0FX07U078,0FI0FX06U03CX0F001E,0FI0FX06U01EX0F001E,0FI0FX06V0EX0F001E,0FI0FX06V06X0F001E,0FI0FX060KFI01JF806X0F001E,0FI0FX061KF8003JFC06X0F001E,0FI0FX0638I01C007I01E06X0F001E,0FI0FX067K0E00EJ0F06X0F001E,0FI0FX06EK0701CJ0786X0F001E,0FI0FX06CK03038J03C6X0F001E,0FI0FX06C3C03C3030F00F1C6X0F001E,0FI0FX06C7E07E3031F81F8C6X0F001E,0FI0FX06CFF0FF3033FC3FCC6X0F001E,::0FI0FX06C7E07E3031F81F8C6X0F001E,0FI0FX06C3C03C3030F00F0C6X0F001E,0FI0FX06CK0303L0C6X0F001E,0FI0FX06EK0303K01C6X0F001E,0FI0FX067K07038J0386X0F001E,0FI0FX0638J0E01CJ0706X0F001E,0FI0FX061CI03C00EJ0E06X0F001E,0FI0FX060KF8787JFC06X0F001E,0FI0FX0607IFE0783JF806X0F001E,0FI0FX06M078M06X0F001E,:::::::::::::0FI0FX0600IF007803FFC006X0F001E,0FI0FX0601IF807807FFE006X0F001E,0FI0FX0603C01C0780E007006X0F001E,0FI0FX0607I0C0781C003806X0F001E,0FI0FX060E0F06078383C1806X0F001E,0FI0FX060E1F86078307E1806X0F001E,0FI0FX060C3FC707830FF1806X0F001E,0FI0FX060C3FC307830FF1806X0F001E,:0FI0FX060C1F83078307E1806X0F001E,0FI0FX060C0F03078303C1806X0F001E,0FI0FX060CI030783I01806X0F001E,:0FI0FX060CI030783I01806W01FC01E,0FI0FX060CI030783I01806W07FE01E,0FI0FX060CI030783I01806W0FFE01E,0FI0FX060CI0307830381806V01EF781E,0F001F8W060C0F03078307C1806V01CF381E,0F003FCW060C1F8307830FE1806V038F1C3F,0F007gJFC307830gIF0F1C7F8,0F007gJFC307830gIF0F1IFC,:0F007gJF83078307gHF0F1IFC,0F003FCW06070F0707838383006X0F007F8,0F001F8W0607800E0781C003006X0F003F,0FI0FX0603C01C0780E007006X0F001E,0FI0FX0601IF80780700E006X0F001E,0FI0FX0600IF007803FFC006X0F001E,0FI0FX06M07801FF8006X0F001E,0FI0FX06M078M06X0F001E,0FI0FX060060400780301I06X0F001E,0FI0FX060060C00780303I06X0F001E,0FI0FX060061C00780307I06X0F001E,0FI0FX060063C0078030FI06X0F001E,0FI0FX060060C00780303I06X0F001E,::0FI0FX06007CC00780303I06X0F001E,0FI0FX06007CC007803F3I06X0F001E,0FI0FX06M07803F3I06X0F001E,0FI0FX06M078M06X0F001E,0FI0FN01FCM06M078M06M03FO0F001E,0FI0FN07FFM06M078M06M0FFCN0F001E,0FI0FN0F87CL0607JF8003JF806L03E0FN0F001E,0FI0FM03C00FL061KFC007JFC06L07003CM0F001E,0FI0FM078007L063CI01E00EJ0E06L0F003CM0F001E,0F003F8L0FC00F8K0638J0F01CJ0706K01F807EM0F001E,0F007FEL0FE01DCK067K07038J0306K039C0E6M0F001E,0F00IFK01E7038CK066K0303K0186K030E1C3M0F001E,0F00CF38J01C3870CK0660E03C3030F00E186K0707383L01F801E,0F81CF18J01C1CE0EK0661F07E3031F81F186K0703F038K03FC01E,1FC18F1LFC0FC07OF8FF3033FC3OFE01E01NFE01E,3IF8F1LF807807OF8FF3033FC3OFE01E01NFE01E,7IF8F1LF807807OF8FF3033FC3OFE03F01NFE01E,7FFE0F0LF80FC0PF87E3031F83OFE07B81NFC01E,7FFE0FL01C1CE0EK0661F03C3030F01F186K060F1C38K03FC01E,3FC00FM0C3870CK0660EI0303J0E186K071C0E3L01F801E,1F800FM0C7039CK067K0303K0386K0738073M0F001E,0FI0FM0EE01D8K0638J07038J0706K03F003FM0F001E,0FI0FM07C00F8K0638J0E01CJ0E06K01E001EM0F001E,0FI0FM038007L061KFC00KFC06K01E003EM0F001E,0FI0FM01C00EL060KF8007JF806L0F003CM0F001E,0FI0FN0F03CL06V06L07C1FN0F001E,0FI0FN07FF8L06V06L01FFEN0F001E,0FI0FN01FFM06I01M038I06M0FF8N0F001E,0FI0FX06I03M07CI06X0F001E,0FI0FX06I07M06EI0EX0F001E,0FI0FX07I0FM046001CX0F001E,0FI0FX07801FN060038X0F001E,0FI0FX03C003N0C007Y0F001E,0FI0FX01E003M01800EY0F001E,0FI0FY0F003M03001CY0F001E,0FI0FY07803M060038Y0F001E,0FI0FY03C03M07E07g0F001E,0FI0FY01E03M07E0Eg0F001E,0FI0Fg0FQ01Cg0F001E,gL078P038,gL03RF,gL01QFE,,^FS
	EndCase
    */

	// Seguranca
	//cString += "^FO"+cValToChar(200+nCol)+","+cValToChar(380+nLin)+"^GFA,1260,1260,15,,::I03C,I0FF,001FF,001C78,001C00781EE71CE67E3FC1F07E,001F80FE3FE71CFEFF3FF3F8FF,I0FF1CE79E71CFCE73DF7FCE7,I07FBCE79E71CF0073CF71C07,J079FF71E71CF0FF3CF700FF,003C3BC079E71CE0E73CF71CE7,001E79CF79E73CE0E73CF7FCE7,001FF1FE3FE7FCF0FF3CF3F8FF,I0FE0FC05E7FCE0E73CF1F0E7,N039EQ0C,N03FCP03F,N01F8P03F,,::::3RFCN03FFC,3RFCM01JF8,3RFCM03JFC,3RFCM07F007F,3RFCM0FC001F,3RFCL01F0FF078,3RFCL03E3FFE3C,3RFCL03C7IF3C,3RFCL07CF8079E,I03LFCO079E0039E,I03LFCO0FBC001CF,I03CKFCO0FBC001CF,I03C7JFCO0F38I0CF,I03C1JFCN01F78I0E78,I03C0JFCN01F7J0E78,I03C07IFCN01F7J0E78,I03C01IFCN01E7J0678,I03C00IFCN01E77F63638,I03C003FFCN01EF7F63738,I03C001FFCN01EF7F63738,I03CI07FCN01EF6363738,I03CI03FCN01EF7E6373C,I03CJ0FCN01EF7E3673C,I03CJ07CN01EF633E738,I03CJ03CN01E77F1C738,:I03CJ03CN01E77F1C678,I03CJ03CN01F7J0678,I03EJ03CN01F7J0E78,I03F8I03CN01F78I0E78,I03FCI03CO0F38I0EF,I03FFI03CO0F38001CF,I03FF8003CO0FBC001CF,I03FFC003CO079C003DF,I03IF003CO07DE0079E,I03IFC03CO03CJF3E,I03IFE03CO03E7FFE3C,I03JF03CO01E1FFC7C,I03JFC3CO01F8I0F8,I03JFE3CP0FE007F,I03KF3CP03JFE,I03LFCP01JFC,I07LFCQ07IF,3RFCO0FF8,3RFC,:3RFCJ03879F0E386783RFCJ07CFDF9F7CEFC3RFCJ0C6CD99B6DECC3RFCJ0C6C1F9B6C6783RFCJ0C6C1F1B6C6781RF8J0C6CD81B6C6CCX07C7D81F7C6FCX0387980E38678,:::::^FS" + CRLF

	// Boneco
	//cString += "^FO"+cValToChar(50+nCol)+","+cValToChar(390+nLin)+"^GFA,594,594,9,07SF8,1CS0E,3T03,6T018,4U08,CU0C,8U0C,8U04,8L07F8L04,8L0FFCL04,8K01FFEL04,:8K03IFL04,:::::8K01FFEL04,8L0FFCL04,8L07F8L04,8L03FM04,8U04,:8J01JFEK04,8J03KFK04,8J07KF8J04,8J0LF8J04,8I01LFCJ04,8I01CJFCEJ04,8I03C1FFE0FJ04,8I07C03E00FJ04,8I07CK0F8I04,8I0FCK0FCI04,8001FCK0FEI04,8003FCK0FEI04,8003FCK0FFI04,8007FFC001IF8004,800IFE003IF8004,801JF003IFC004,801JF003IFE004,803JF003JF004,:803IFE001JF004,803IF8I07IF004,803IFE001JF004,801FC3FC0FF1FE004,800603KF018004,8J03KFK04,:::8U04,::803QF804,:8U04,8U0C,:CU0C,4U08,6T01,3T03,1ER03C,07SF8,^FS" + CRLF
	cString += "^FO"+cValToChar(30+nCol)+","+cValToChar(377+nLin)+"^GFA,790,790,10,3XF87XFCYFE:FW01E::::FN07CM01EFM01FFM01EFM07FFCL01EFM0IFEL01E::FL01JFL01E:::::FM0IFEL01E:FM07FFCL01EFM03FF8L01EFN0FEM01EFW01E:FL03JF8K01EFK01KFEK01EFK03LF8J01EFK07LF8J01EFK07LFCJ01EFK0MFEJ01EFJ01NFJ01EFJ03C7JF87J01EFJ03C0IFE078I01EFJ07C00FE007CI01EFJ0FC003I07EI01EFI01FCL07EI01EFI01FCL07FI01EFI03FCL07F8001EFI07FCL07FC001E:FI0IFEJ0IFE001EF001JFI03JF001EF003JF8003JF001EF003JF8007JF801EF007JFC007JFC01EF00KFC007JFE01EF00KF8007JFE01EF01KF8003JFE01EF01KFI01JFE01EF00JFCJ07IFE01EF00KFI03JFE01EF007FC3FE01FF8FFC01EF003E03FFC7FF81F801EFK03LF8J01E::::FW01E::F03TF01E::::FW01E::::YFE:7XFC3XF8^FS

	cString += "^CF0,30,40" + CRLF
	cString += "^FO"+cValToChar(5+nCol)+","+cValToChar(14+nLin)+"^FD "+AllTrim(SB1->B1_COD)+" ^FS" + CRLF

	cString += "^CF0,30" + CRLF
	cString += "^FO"+cValToChar(240+nCol)+","+cValToChar(15+nLin)+"^FD X"+cValToChar(SB1->B1_XQTYUNT)+" ^FS" + CRLF

	cString += "^CFA,20,5" + CRLF

	If !Empty(SB1->B1_XSHO1) .And. !AllTrim(SB1->B1_XSHO1)=="-"
		cString += "^FO"+cValToChar(5+nCol)+","+cValToChar(52+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XSHO1))+" ^FS" + CRLF
	EndIf
	If !Empty(SB1->B1_XSHO2) .And. !AllTrim(SB1->B1_XSHO2)=="-"
		cString += "^FO"+cValToChar(5+nCol)+","+cValToChar(72+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XSHO2))+"  ^FS" + CRLF
	EndIf

	cString += "^CFA,15" + CRLF
	cString += "^BY2,2,70" + CRLF
	cString += "^FO"+cValToChar(30+nCol)+","+cValToChar(90+nLin)+"^BE^FD"+AllTrim(SB1->B1_CODBAR)+"^FS" + CRLF

	cString += "^CFA,20" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(185+nLin)+"^FD "+AllTrim(SB1->B1_XFROM)+" ^FS" + CRLF
	cString += "^FO"+cValToChar(125+nCol)+","+cValToChar(185+nLin)+"^FD "+"BG-"+cValToChar(Year(Date()))+"-W"+RetSem(Date())+"-"+cValToChar(Dow(Date()))+" ^FS" + CRLF

	If !Empty(SB1->B1_XTECDF1) .And. !AllTrim(SB1->B1_XTECDF1)=="-"
		cString += "^FO"+cValToChar(010+nCol)+","+cValToChar(205+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XTECDF1))+" ^FS" + CRLF
	EndIf
	If !Empty(SB1->B1_XTECDF2) .And. !AllTrim(SB1->B1_XTECDF2)=="-"
		cString += "^FO"+cValToChar(150+nCol)+","+cValToChar(205+nLin)+"^FH_^FD "+AjuEspec(AllTrim(SB1->B1_XTECDF2))+" ^FS" + CRLF
	EndIf

	If !Empty(SB1->B1_XGRFBV) .And. !AllTrim(SB1->B1_XGRFBV)=="-"
		cString += "^FO"+cValToChar(165+nCol)+","+cValToChar(390+nLin)+"^GFA,648,648,12,,06,1FC,3DE,3800C0601080070660301C,3E03F1FF71CFDDCFF8FC7F,1FC739CF71CF8CCF39CE63,03E7FB8771CE0FCF3BC03F,30F7FB8F71CE3CCF3BC0F7,38E639CF79CE38CF39CEE3,3FE7F8FF3FCE3FCF39FCFF,0F81E04F1D8E0EC618787B,K01CEP03,L0FCP078,,:Q07OFE,J07EK07OFE,I03EF8J07OFE,I0E00EJ07OFE,I0CFE2J07OFE,0019C7BM0JFE,0013009M0DIFE,003600D8L0CIFE,00240048L0C3FFE,0024006CL0C1FFE,006C006CL0C0FFE,006FC8ECL0C07FE,006E68E4L0C03FE,006F6DA4L0C00FE,006FE524L0C007E,006E2724L0C003E,006F662CL0C001E,006FC26CL0CI0E,006C006CL0EI07,00240048L07I03,00340048L07C003,003600D8L07E003,0013019M07F003,0019FF3M07F803,I0C7C6M07FC03,I0600CM07FE03,I03FF8M07FF83,T07FFC3,T07FFE3,T0JF3,T07IFB,1E39E1CE27J0KF,336DB17A6787OFE,2341B37B6787OFE,3341E37B2587OFE,3E7D01CE2787OFE,0C3I0842307OFC,,^FS
	EndIf

	If !Empty(SB1->B1_XNOMLOG) .And. !AllTrim(SB1->B1_XNOMLOG)=="-"
		cString += "^FO"+cValToChar(165+nCol)+","+cValToChar(450+nLin)+"^GFA,759,759,11,,::0XF,0XF8,::0XF,,:::::0FC3F001FE001F8001F8,0FC1F003FF801F8003F8,0FC1F007FFC01FC003F8,0FC1F00IFE01FC007F8,0FE1F01IFE01FC007F8,0FE1F01JF01FC00FF8,0FE1F01F83F01FE00FF8,:0FF1F01F01F01FE00FF8,0FF1F01F01F01FE01FF8,:0FF9F01F01F01FF01FF8,:0FF9F01F01F01FF83FF8,0FFDF01F01F01FF83FF8,0FFDF01F01F01FF87FF8,0FFDF01F01F01FFC7FF8,0JF01F01F01FFC7FF8,0JF01F01F01FFCIF8,0JF01F01F01FFEFDF8,0JF01F01F01F7EFDF8,0JF01F01F01F3FF9F8,::0FBFF01F01F01F3FF1F8,:0F9FF01F01F01F1FF1F8,0F9FF01F01F01F1FE1F8,:0F8FF01F01F01F1FE1F8,0F8FF01F01F01F0FC1F,0F8FF01F01F01F07C1F8,0F87F01F83F01FI01F8,0F87F03F83F01FI01F8,0F87F01FEFF01FI01F8,0F83F00IFE01FI01F8,:0F83F007FFC01FI01F8,0F83F003FF801FI01F8,0FC3FI0FF001FI01F8,0F81FI038001FI01F,,::::0XF,::::,:::^FS
	EndIf

	If !Empty(SB1->B1_XNTCLOG) .And. !AllTrim(SB1->B1_XNTCLOG)=="-"
		cString += "^FO"+cValToChar(165+nCol)+","+cValToChar(515+nLin)+"^GFA,638,638,11,,:03VFE,0EV038,18W0C,1X06,2X02,:2X03,607FF07FFDIF3CIF81,606018600D8012CC0181,604004400D00124C0181,604FE64FFDFBF24DFF81,604C324C0019024D8001,::604FE64FF819024DFF01,604784400819024C0101,60403847F819024CFF01,604F304FF819024DFF01,604D984C0019024D8001,604C884C0019024D8001,604C4C4C0019024D8001,604C644FFC19024DFF81,604C2247FC19024CFF81,604C3360041B024C0081,607C1F7FFC1F03CIF81,6K03FF80E0187FF81,6X01,::6079FBCFF7F8E08F8701,60FDFBEFD7F9F18FCF81,60C582I361919CCD881,6081E363379B03CC50C1,6081F3E3379B024C70C1,60818243361B03EC50C1,60CD82633619166CD881,607DFEI3619F42F8F81,6031F8031208E40F0703,2X03,2X02,3X06,1X04,0CV01C,07V07,01VFC,,::::::::::^FS
	EndIf

	If !Empty(SB1->B1_XCERING) .And. !AllTrim(SB1->B1_XCERING)=="-"
		cString += "^FO"+cValToChar(165+nCol)+","+cValToChar(560+nLin)+"^GFA,1014,1014,13,,:P01IF8,P0KF,O07KFC,O0MF,N03MF8,N07MFE,M01OF,M03OF8,M07OFC,M07OFE,M0QF,L01QF8,L03QF8,L03QFC,L07FFCM07C,L07FEN07E,L0FF8N07E,L0FFO07F,K01FEO07F,K01FCO07F,K01FC00OF8,K01F803OF8,K03F80PF8,K03F01PF8,:N03F,::::N01F,K03F01PF8,K03F00PF8,K01F80PF8,K01F803OF8,K01FCN01FF,K01FCO07F,L0FEO07F,L0FFO07E,L07F8N07E,L07FEN07C,L03FFCM07C,L03QF8,L01QF8,M0QF,M0PFE,M07OFC,M03OF8,M01OF,N0NFE,N03MFC,N01MF,O07KFE,O01KF,P03IFC,Q01F8,,:::::E700E0IFE0IFC1IF9IFE,E780E1IFE3IFC3IF9JF,E7C0E3IFE7IFC7IF9JF8,E7F0E78I078I0FM078,E7F8E7J0FJ0EM038,E7FCE71FFEEJ0E7FF9C0038,E77EE71FFEEJ0E7FFDE0038,E73FE71FFEEJ0E7FFDJF,E71FE7I0EFJ0EI01JF,E70FE7C00E78I0FI01JF8,E707E3IFE7IFC7IF9E00FC,E703E1IFE3IFC3IF9E007E,E701E0IFE1IFC1IF9E003F,,^FS
	EndIf

	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(460+nLin)+"^FD Instalacion debe ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(480+nLin)+"^FD ser realizada ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(500+nLin)+"^FD por una persona ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(520+nLin)+"^FD calificada ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(540+nLin)+"^FD recomendamos, ^FS" + CRLF
	cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(560+nLin)+"^FD un eletricista ^FS" + CRLF
	//cString += "^FO"+cValToChar(000+nCol)+","+cValToChar(580+nLin)+"^FD un eletricista ^FS" + CRLF

	cString += "^XZ" + CRLF


	Memowrite("C:\Temp\"+cProd+"_3.ETI",cString)
	__CopyFile("C:\Temp\"+cProd+"_3.ETI",cPortaImp)

Return




//u_TSTFlow4
user Function TSTFlow4()
	Local ctamG        := "050,035"
	Local ctamM        := "038,025"
	Local ctamP        := "028,018"
	Local ctamx        := "023,014"
	Local _nQtde       := 1     // Qtde.Etiq.Impressa
	Local _cProd       := SB1->B1_COD
	Local _cQtde       := nGQtdPCx      //SB1->B1_XQTYMUL Valdemir Rabelo 07/10/2020
	Local _cQtdeV      := SB1->B1_XQTYUNT
	Local _cQtdeT      := cValToChar(_cQtde)
	Local _cDesPort    := SB1->B1_XSHDE4                           //POSICIONE("SB1",1,XFILIAL("SB1")+_cProd,"B1_DESC")
	Local _cDesSpan    := SB1->B1_XSHDE5
	Local _cDesEngl    := SB1->B1_XSHDE6
	Local _cDtProducao := dtoc(dDatabase)
	Local _cRange      := SB1->B1_XAESNM
	Local _c1DadosTec  := SB1->B1_XTECHDE
	Local _c2DadosTec  := SB1->B1_XTECHD2
	Local _cDiagEletr  := ""
	Local _cCIP        := SB1->B1_XCIP
	Local _CertMark1   := "INMET"
	Local _CertMark2   := ""
	Local _CertMark3   := ""
	Local _CertMark4   := ""
	Local _CertMark5   := ""
	Local _Imagem      := ""
	Local cCodBar      := if(Empty(SB1->B1_CODBAR),SB1->B1_COD,SB1->B1_CODBAR)
	Local _cLogo       := ""
	Local nAJ          := -2

	nLin      := 15
	nCol      := 0

	If !CB5SETIMP('000006', IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return(Nil)
	EndIf

	MSCBBEGIN(_nQtde,1)

	MSCBSAY(025+nCol, 154+nAJ,_cProd				     ,"B","0",ctamM)    // tam fonte 5.5mm (01)
	MSCBSAY(025+nCol, 120+nAJ,_cDesPort				     ,"B","0",ctamM)    // tam fonte 2.2mm (02)
	MSCBSAY(025+nCol, 106+nAJ,_cDesSpan				     ,"B","0",ctamP)    // tam fonte 2.2mm (03)
	// MSCBSAY(005+nCol, 019+nAJ,_c1DadosTec		         ,"B","0",ctamP)    // tam fonte 2.2mm (04)
	// MSCBSAY(030+nCol, 019+nAJ,_cDtProducao	    	     ,"B","0",ctamX)    // tam fonte 1.7mm (07)
	// MSCBSAYBAR(035+nCol,004+nAJ,Alltrim(cCodBar)         ,"N","MB01",08,.T.,.T.,.F.,"B",3,1)  // (17)
	//MSCBGRAFIC(045-nCol,016+nAJ,"BV2",.T.)                                  // Certificado INMETRO

	MSCBEND()

Return



Static Function AjuEspec(_cRec)

	_cRet := _cRec

	If "~" $ _cRet
		_cRet := StrTran(_cRet,"~","_7E")
	EndIf

Return(_cRet)


Static Function vldQtdCX()

	oTimer:Activate()

Return .T.

Static Function vdNQtdCX(cKeyUser)
	Local lRET := .F.
	Local bSavKeyF2 := {|| CHGEQTD() }

	//if lRET
	SetKey(VK_F2, bSavKeyF2,"Editando Quantidade")
	//endif

Return lRET

Static Function CHGEQTD()
	Local lRET := (!Empty(cGetCodBar))
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}

	if lRET

		AADD(_aParamBox,{1,"SENHA",Space(10) ,"@!","","","",0,.F.})

		If !ParamBox(_aParamBox,"Digite a senha",@_aRet,,,.T.,,500)
			Return(.F.)
		EndIf

		If !AllTrim(GetMv("OPMNTBAL1",,"071020"))==AllTrim(MV_PAR01)
			MsgAlert("Senha incorreta!")
			Return
		EndIf

		oGQtdPCx:bWhen := {|| .T. }
		oTimer:DeActivate()
		oGQtdPCx:SETFOCUS()
	endif

Return


Static Function WCodBar()
	lGet := .F.
Return .T.

/*/{Protheus.doc} EtiqueHU
description
Rotina temporaria para impressão Etiqueta
@type function
@version 
@author Valdemir Jose
@since 08/10/2020
@return return_type, return_description
u_EtiqueHU
/*/
/*/{Protheus.doc} EtiqueHU
description
Rotina temporaria para impressão Etiqueta
@type function
@version 
@author Valdemir Jose
@since 08/10/2020
@return return_type, return_description
u_EtiqueHU
/*/
User Function EtiqueHU()

	Local _aPar1   := {}
	Local _aRet1        := {}
	Local _aPar2   := {}
	Local _aRet2        := {}
	Local aAreaSB1     := GetArea()
	Local nQtdEtiq     := 0
	Local nX           := 0
	Local _nX
	Private _cQuery1     := ""
	Private _cAlias1     := GetNextAlias()

	//AADD(_aParamBox,{1,"Data da Saída",DDATABASE,"99/99/9999","","","",50,.T.})
	//AADD(_aParamBox,{1,"Pedido Compra",Space(25),"@!","","SC7","",50,.T.})
	AADD(_aPar1,{1,"Nota Fiscal",Space(9),"@!","","SF2","",50,.T.})
	//AADD(_aParamBox,{1,"Quantidade",Space(9),"@E 9999999999","","","",50,.T.})
	//AADD(_aParamBox,{1,"Produto",Space(15),"@!","","SB1","",50,.T.})
	//AADD(_aParamBox,{1,"Qde.Etiquetas",nQtdEtiq,"@E 9999999999","","","",50,.T.})

	If !ParamBox(_aPar1,"Emissão Etiqueta Pallet",_aRet1)
		Return
	Endif

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	If !SF2->(DbSeek(xFilial("SF2")+MV_PAR01+"001"))
		MsgAlert("NF não encontrada")
		Return()
	EndIf

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	_cQuery1 := " SELECT F2_DOC, D2_COD, C6_NUMPCOM, SUM(D2_QUANT) QTD
	_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
	_cQuery1 += " ON F2_FILIAL=D2_FILIAL AND D2_DOC=F2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_FILIAL='"+SF2->F2_FILIAL+"' AND F2_DOC='"+SF2->F2_DOC+"' AND F2_SERIE='"+SF2->F2_SERIE+"'
	_cQuery1 += " GROUP BY F2_DOC, D2_COD, C6_NUMPCOM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nQtdImp    := 0

	While (_cAlias1)->(!Eof())

		_nQtdOrig   := (_cAlias1)->QTD
		_aPar2      := {}
		nQtdEtiq    := 1
		cPc         := AllTrim((_cAlias1)->C6_NUMPCOM)

		AADD(_aPar2,{1,"Produto",(_cAlias1)->D2_COD,"@!","","",".F.",50,.F.})
		AADD(_aPar2,{1,"Pedido",Val(cPc),"@E 999999999999999","","",".F.",50,.F.})
		AADD(_aPar2,{1,"Quantidade",(_cAlias1)->QTD,"@E 9999999999","","","",50,.T.})
		AADD(_aPar2,{1,"Qde.Etiquetas",nQtdEtiq,"@E 9999999999","","","",50,.T.})

		If !ParamBox(_aPar2,"Parametros",_aRet2)
			Return
		Endif

		For _nX:=1 To MV_PAR04
			FWMsgRun(,{|| u_ExecEtiq("HUETIQUETA") },'Informação','Aguarde, imprimindo etiqueta HU')
		Next

		_nQtdImp += MV_PAR03*MV_PAR04

		If _nQtdImp>=(_cAlias1)->QTD
			_nQtdImp    := 0
			(_cAlias1)->(DbSkip())
		EndIf

	EndDo

	RestArea( aAreaSB1 )

Return



/*/{Protheus.doc} INIHUETIQUETA
    description
        Montagem da etiqueta HU
    @type function
    @version 
    @author Valdemir Jose
    @since 21/09/2020
    @param oPrinter, object, param_description
    @return return_type, return_description
/*/
Static Function INIHUETIQU(oPrinter)

	Local cCabTitulo   := "STECK INDÚSTRIA ELÉTRICA"    //FWFilName(cEmpAnt, cFilAnt)
	Local cCabSubTit   := ALLTRIM(SM0->M0_CIDENT)
	Local oBrush1      := TBrush():New( , CLR_BLACK)
	Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
	Local oFont8       := TFont():New("Arial", , 8 , .T.,.F.)
	Local oFont8b      := TFont():New("Arial", , 8 , .T.,.T.)
	Local oFont9b      := TFont():New("Arial", , 9 , .T.,.T.)
	Local oCabecB      := TFont():New("Arial", , 12 , .T.,.T.)
	Local oCabec       := TFont():New("Arial", , 10 , .T.,.F.)
	Local oFont6       := TFont():New("Arial", , 6 , .T.,.F.)
	Local oConteudo    := TFont():New("Arial", , 10 , .T.,.T.)
	Local oLegenda     := TFont():New("Arial", , 10 , .T.,.F.)
	Local nLin         := 290
	Local nCol         := 0
	Local nColMax      := 350//350
	Local cPedCompra   := ""
	Local cSaida       := GetSaida(dDatabase)
	Local cNotaFiscal  := ""
	Local cQuantidade  := ""
	Local cProduto     := ""
	Local nA           := 90

	cPedCompra   := cValToChar(MV_PAR02)
	cSaida       := GetSaida(SF2->F2_EMISSAO)
	cNotaFiscal  := SF2->F2_DOC
	cQuantidade  := cValToChar(MV_PAR03)
	cProduto     := (_cAlias1)->D2_COD

	SB1->(DbSeek(xFilial("SB1")+cProduto))

	oPrinter:StartPage()

	oPrinter:Code128(240, 40, cValToChar(Val(cQuantidade)), 1, 40, .F., oFont8)

	nLin -= 10

	oPrinter:Box(015+nCol,nLin+9,nColMax+nCol,nLin-12,"-5")
	nLin -= 10
	oPrinter:Say(020+nCol, nLin+2, cCabTitulo, oCabecB,,,nA)
	oPrinter:Say(240+nCol, nLin+2, cCabSubTit, oCabec,,,nA)
	oPrinter:Box(015+nCol,nLin-2,200+nCol,nLin-31,"-5")
	oPrinter:Box(200+nCol,nLin-2,nColMax+nCol,nLin-31,"-5")
	nLin -= 11
	oPrinter:Say(020+nCol, nLin,  "Saída:", oLegenda,,,nA)
	oPrinter:Say(205+nCol, nLin,  "Pedido Compra", oLegenda,,,nA)
	nLin -= 11
	oPrinter:Say(020+nCol, nLin-2, cSaida,        oConteudo,,,nA)
	oPrinter:Say(205+nCol, nLin-2, cPedCompra,    oConteudo,,,nA)
	nLin -= 08
	oPrinter:Box(015+nCol, nLin,200+nCol, nLin-84,"-5")                   // Quadro dados Steck até Tipo Embalagem
	oPrinter:Box(200+nCol, nLin,nColMax+nCol, nLin-43, "-5")
	nLin -= 12
	oPrinter:Say(020+nCol, nLin, ALLTRIM(SM0->M0_NOMECOM), oCabecB,,,nA)
	nLin -= 11
	oPrinter:Say(020+nCol, nLin, SM0->M0_ENDENT,    oConteudo,,,nA)
	oPrinter:Say(205+nCol, nLin+11, "Nota Fiscal", oLegenda,,,nA)
	oPrinter:Line(265+nCol, nLin-38, 265+nCol, nLin+21,,"-5")    // Cria linha entre os dois titulos
	oPrinter:Say(270+nCol, nLin+11, "Made in", oLegenda,,,nA)
	nLin -= 10
	oPrinter:Say(020+nCol, nLin, ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT),    oConteudo,,,nA)
	oPrinter:Say(205+nCol, nLin+2, cNotaFiscal, oConteudo,,,nA)
	oPrinter:Say(275+nCol, nLin+2, "Brasil", oConteudo,,,nA)
	nLin -= 11
	oPrinter:Say(020+nCol, nLin, ALLTRIM(SM0->M0_CEPENT), oConteudo,,,nA)
	oPrinter:Box(200+nCol, nLin+2, nColMax+nCol, nLin-39, "-5")
	oPrinter:Line(265+nCol, nLin+2, 265+nCol, nLin-39,,"-5")    // Cria linha entre os dois titulos
	nLin -= 10
	oPrinter:Say(204+nCol, nLin+2, "Quantidade", oLegenda,,,nA)
	oPrinter:Say(270+nCol, nLin+2, "UM", oLegenda,,,nA)
	nLin -= 16
	oPrinter:Say(206+nCol, nLin-2, cQuantidade,  oConteudo,,,nA)
	oPrinter:Say(280+nCol, nLin-2, SB1->B1_UM,  oConteudo,,,nA)
	//oPrinter:Box(015+nCol, nLin-13, nColMax+nCol, nLin-60, "-5")

	//oPrinter:Box(015+nCol,nLin+9,nColMax+nCol,nLin-12,"-5")

	//oPrinter:Line(079+nCol, nLin-13, 079+nCol, nLin-60,,"-5")    // Cria linha entre os dois titulos
	nLin -= 16
	oPrinter:Say(020+nCol, nLin-6, "Produto", oLegenda,,,nA)
	nLin -= 10
	oPrinter:Say(020+nCol, nLin-9, SB1->B1_COD, oConteudo,,,nA)

	nLin -= 14
	oPrinter:Say(020+nCol, nLin-6, "Descrição", oLegenda,,,nA)

	nLin -= 10
	oPrinter:Say(020+nCol, nLin-9, UPPER(SB1->B1_DESC),  oConteudo,,,nA)

	nLin -= 7

	oPrinter:FWMSBAR("CODE128",;                          // 01 - Tipo Código Barra
	01.5,;                              // 02 - Linha
	4,;                              // 03 - Coluna
	ALLTRIM(cProduto),;                  // 04 - Chave Codigo barra
	oPrinter,;                          // 05 - Objeto Printer
	.F.,;                               // 06 - Se calcula o digito de controle. Defautl .T.
	,;                                  // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
	.F.,;                               // 08 - Se imprime na Horizontal. Default .T.
	0.025,;                             // 09 - Numero do Tamanho da barra. Default 0.025
	1.5,;                               // 10 - Numero da Altura da barra. Default 1.5
	.F.,;                               // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
	"Arial",;                           // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
	,;                                  // 13 - Modo do codigo de barras CO. Default ""
	.F.,;                               // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
	0.1,;                               // 15 - Número do índice de ajuste da largura da fonte. Default 1
	0.5,;                               // 16 - Número do índice de ajuste da altura da fonte. Default 1
	.F.)                                // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

	oPrinter:EndPage()

Return


user Function TSTPORT(aDados)
	Local ctamG        := "050,035"
	Local ctamM        := "038,025"
	Local ctamP        := "028,018"
	Local ctamx        := "023,014"
	Local cQuantidade  := ""
	Local cProduto     := ""
	Local nAJ          := 0
	Local nX

	Default aDados     := {}
	nLin      := 15
	nCol      := 0

	cProduto     := MV_PAR02
	cQuantidade  := cValToChar(MV_PAR03)
	nQtdEtiq     := MV_PAR04

	If !CB5SETIMP('000006', IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return(Nil)
	EndIf

	MSCBBEGIN(1,1)

	MSCBSAY(015+nCol, 010+nAJ,"Produto"				     ,"B","0",ctamP)
	MSCBSAY(035+nCol, 010+nAJ,"Descrição"			     ,"B","0",ctamP)
	MSCBSAY(015+nCol, 024+nAJ,cProduto				     ,"B","0",ctamM)
	MSCBSAY(025+nCol, 024+nAJ,UPPER(SB1->B1_DESC)	     ,"B","0",ctamP)
	MSCBSAY(015+nCol, 036+nAJ,"Quantidade"			     ,"B","0",ctamP)
	MSCBSAY(015+nCol, 048+nAJ,cQuantidade			     ,"B","0",ctamP)
	MSCBBOX(035+nCol, 36+nAj,075+nCol,60+nAj,2)
	nTMP := 0
	For nX := 1 to Len(aDados)
		nTMP += 9
		MSCBSAY(038+nCol, 048+nAJ+nTMP,aDados[nX][1]			 ,"B","0",ctamM)
	Next
	MSCBSAYBAR(015+nCol,054+nAJ,Alltrim(cProduto)         ,"N","MB01",08,.T.,.T.,.F.,"B",3,1)

	MSCBSAYBAR(080+nCol,054+nAJ,Alltrim(cQuantidade)      ,"B","MB01",08,.T.,.T.,.F.,"B",3,1)

	MSCBEND()

Return


/*/{Protheus.doc} getVldEmb
description
Rotina que fará a validação do código da primeira embalagem com a OP
Ticket: 20201116010613
@type function
@version  
@author Valdemir Jose
@since 04/01/2021
@return return_type, return_description
/*/
Static Function getVldEmb(pMessage)
	Local lRET     := .F.
	Local cTMP     := ""
	Local aAreaSB1 := GetArea()

	dbSelectArea("SB1")
	dbSetOrder(5)

	cTMP := FWInputBox(pMessage,"")

	lRET := dbSeek(xFilial('SB1')+cTMP)
	if lRET
		lRET := (alltrim(SC2->C2_PRODUTO)==alltrim(SB1->B1_COD))
		if !lRET
			ApMsgInfo("Código de Barra da leitura, não confere com OP: "+SC2->C2_NUM+CRLF+CRLF+;
				"Produto OP: <B>"+alltrim(SC2->C2_PRODUTO)+"</B>"+CRLF+;
				"Produto Leitura: <B>"+alltrim(SB1->B1_COD)+"</B>",'Atenção!')
		endif
	Else
		FWMsgRun(,{|| sleep(3000)},'Atenção!',"Código de Barra não encontrado na tabela: SB1")
	Endif

	RestArea( aAreaSB1 )

Return lRET



User Function VLDETQTST()
	LOCAL cOP := "UM702901001"
	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	lRET   := SC2->(dbSeek(XFilial("SC2")+cOP))
	if lREt
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		lRET   := SB1->(dbSeek(xFilial('SB1')+SC2->C2_PRODUTO))
		if !lRET
			ApMsgInfo("Produto não encontrado")
			Return 
		endif
	ELSE
		ApMsgInfo("OP não encontrado")
		Return
	ENDIF

	//OPETQPROC()
	INIHRB8045()
Return
