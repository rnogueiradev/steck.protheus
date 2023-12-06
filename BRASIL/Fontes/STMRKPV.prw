#Include "Totvs.ch"
#Include "FWMVCDef.ch"


Static cMessage    := ""
Static cCaminho    := "C:\Temp\"
Static cArquivo    := "STMRKPV_"
Static cCopiaArq   := "STMRKPV_"


/*/{Protheus.doc} STmrkPV
Rotina para selecionar e gerar pedidos de vendas 
e notas fiscais
Projeto Simulação PV
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, nil
/*/
User Function STmrkPV(pTipo)
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local xPar0 := sToD("")
	Local xPar1 := sToD("")
	Local xPar2 := Space(06)
	Local xPar3 := Space(02)
	Local xPar4 := Space(06)
	Local xPar5 := Space(02)
	Default pTipo := ""
	Private cSelecao := pTipo

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Data Inicial", xPar0,  "", ".T.", "",    ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Data Final",   xPar1,  "", ".T.", "",    ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Cliente de",   xPar2,  "", ".T.", "SA1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Loja de",      xPar3,  "", ".T.", "",    ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Cliente Ate",  xPar4,  "", ".T.", "SA1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Loja Até",     xPar5,  "", ".T.", "",    ".T.", 80,  .F.})

	//Se a pergunta for confirma, chama a tela
	If ParamBox(aPergs, "Informe os parametros")
		vMntTela(cSelecao)
	EndIf

	FWRestArea(aArea)

Return


/*/{Protheus.doc} vMntTela
Rotina para montar tela
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, nil
/*/
Static Function vMntTela(pTipo)
	Local aArea      := GetArea()
	Local aCampos    := {}
	Local aSeek      := {}
	Local aFilter    := {}
	Local oTempTable := Nil
	Local aColunas   := {}
	Local cFontPad   := 'Tahoma'
	Local oFontGrid  := TFont():New(cFontPad, , -14)
	//Janela e componentes
	Private oDlgMark
	Private oPanGrid
	Private oMarkBrowse
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, { 'OK',         'C',  2, 0}) //Flag para marcação
	aAdd(aCampos, { 'ZAA_NUMOC',  'C', 15, 0}) //Nro.Pedido
	aAdd(aCampos, { 'ZAA_CLIENT', 'C',  6, 0}) //Cod.Cliente
	aAdd(aCampos, { 'ZAA_LOJA',   'C',  2, 0}) //Loja
	aAdd(aCampos, { 'ZAA_NOME',   'C', 30, 0}) //Cliente
	aAdd(aCampos, { 'ZAA_DATA',   'D', 08, 0}) //Data
	aAdd(aCampos, { 'ZAA_HORA',   'C', 08, 0}) //Hora
	aAdd(aCampos, { 'ZAA_TPENT',  'C',  1, 0}) //Tipo Entrega
	aAdd(aCampos, { 'ZAA_TPFRET', 'C',  1, 0}) //Tipo Frete
	aAdd(aCampos, { 'ZAA_TPFAT',  'C',  1, 0}) //Tipo Faturamento
	aAdd(aCampos, { 'ZAA_NUMPED', 'C', 06, 0}) //Pedido Gerado
	aAdd(aCampos, { 'ZAA_NUMNF' , 'C', 09, 0}) //Nota Gerado

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| vPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := vCriaCols()

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Tela para Marcação de dados - Geração de Nota' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Dados
	oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse := FWMarkBrowse():New()
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:SetDescription('Gerar Pedidos e Notas das Simulações')
	//oMarkBrowse:SetParam(bKeyF12)                   // Seta tecla F12
	oMarkBrowse:SetDBFFilter(.T.)
	//oMarkBrowse:DisableFilter()
	oMarkBrowse:DisableConfig()
	//oMarkBrowse:DisableSeek()
	oMarkBrowse:SetSeek(.T.)
	oMarkBrowse:DisableSaveConfig()
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetTemporary(.T.)
	oMarkBrowse:SetColumns(aColunas)
	oMarkBrowse:AllMark()
	//oMarkBrowse:bAllMark := { || stInvert(oBrowse:Mark(), lMarcar := !lMarcar ), oBrowse:Refresh(.T.)  }
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:Activate()

	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()

	RestArea(aArea)

Return


/*/{Protheus.doc} MenuDef
Rotina que adiciona botão
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/09/2022
@return variant, Array
/*/
Static Function MenuDef()
	Local aRotina  := {}
	Local cMsgMenu := ''

	if Empty(cSelecao)
		cMsgMenu := 'Gerar Pedidos/Notas'
	else
		cMsgMenu := 'Limpar Status'
	endif

	//Criação das opções
	ADD OPTION aRotina TITLE cMsgMenu  ACTION 'u_STmrkPVO'     OPERATION 2 ACCESS 0

Return aRotina


/*/{Protheus.doc} vPopula
Rotina para popular a tabela temporaria
@type function
@version  12.1.33   
@author valdemir rabelo
@since 31/08/2022
@return variant, nil
/*/
Static Function vPopula()
	Local cQryDados := MntQuery()
	Local nTotal := 0
	Local nAtual := 0

	//Monta a consulta
	PLSQuery(cQryDados, 'QRYDADTMP')

	//Definindo o tamanho da régua
	DbSelectArea('QRYDADTMP')
	Count to nTotal
	ProcRegua(nTotal)
	QRYDADTMP->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! QRYDADTMP->(EoF())
		nAtual++
		IF (QRYDADTMP->ZAA_STATUS != "G") .or. (cSelecao=='1')
			IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

			RecLock(cAliasTmp, .T.)
			(cAliasTmp)->OK         := Space(2)
			(cAliasTmp)->ZAA_NUMOC  := QRYDADTMP->ZAA_NUMOC
			(cAliasTmp)->ZAA_CLIENT := QRYDADTMP->ZAA_CLIENT
			(cAliasTmp)->ZAA_LOJA   := QRYDADTMP->ZAA_LOJA
			(cAliasTmp)->ZAA_NOME   := QRYDADTMP->ZAA_NOME
			(cAliasTmp)->ZAA_DATA   := QRYDADTMP->ZAA_DATA
			(cAliasTmp)->ZAA_HORA   := QRYDADTMP->ZAA_HORA
			(cAliasTmp)->ZAA_TPENT  := QRYDADTMP->ZAA_TPENT
			(cAliasTmp)->ZAA_TPFRET := QRYDADTMP->ZAA_TPFRET
			(cAliasTmp)->ZAA_TPFAT  := QRYDADTMP->ZAA_TPFAT
			(cAliasTmp)->ZAA_NUMPED := QRYDADTMP->ZAA_NUMPED
			(cAliasTmp)->ZAA_NUMNF  := QRYDADTMP->ZAA_NUMNF
			(cAliasTmp)->(MsUnlock())
		Endif
		QRYDADTMP->(DbSkip())
	EndDo

	QRYDADTMP->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())

Return



/*/{Protheus.doc} vCriaCols
Rotina para adicionar colunas
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, array
/*/
Static Function vCriaCols()
	Local nAtual       := 0
	Local aColunas := {}
	Local aEstrut  := {}
	Local oColumn

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara
	aAdd(aEstrut, { 'ZAA_NUMOC',  'Nro.Simulacao','C', 15, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_CLIENT', 'Cod.Cliente',  'C',  6, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_LOJA',   'Loja',         'C',  2, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_NOME',   'Cliente',      'C', 30, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_DATA',   'Data',         'D', 08, 0, '@D 99/99/9999'})
	aAdd(aEstrut, { 'ZAA_HORA',   'Hora',         'C', 08, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_TPENT',  'Tipo Entrega', 'C',  1, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_TPFRET', 'Tipo Frete',   'C',  1, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_TPFAT',  'Tipo Fatur.',  'C',  1, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_NUMPED', 'Pedido Gerado','C',06, 0, '@!'})
	aAdd(aEstrut, { 'ZAA_NUMNF',  'Nota Gerado',  'C',09, 0, '@!'})

	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next

Return aColunas

/*/{Protheus.doc} STmrkPVO
Rotina para acionar o processamento
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, nil
/*/
User Function STmrkPVO()
	cMessage    := ""
	Processa( { |oObj| vProcessa(oObj), oDlgMark:End() }, 'Processando...')

Return



/*/{Protheus.doc} vProcessa
Rotina de processamento
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, nil
/*/
Static Function vProcessa(oObj)
	Local aArea     := FWGetArea()
	Local cMarca    := oMarkBrowse:Mark()
	Local nAtual    := 0
	Local nTotal    := 0
	Local nTotMarc  := 0
	Local lRET      := .F.
	Local cStatus   := ""

	cMessage := ""

	dbSelectArea("ZAB")
	dbSetOrder(1)

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	dbSelectArea("SA1")
	dbSetOrder(1)

	//Define o tamanho da régua
	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())
	Count To nTotal
	ProcRegua(nTotal)

	//Percorrendo os registros
	(cAliasTmp)->(DbGoTop())
	While ! (cAliasTmp)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		//Caso esteja marcado
		If oMarkBrowse:IsMark(cMarca)
			nTotMarc++
			if Empty(cSelecao)
				cStatus := ""
				if SA1->( MsSeek(xFilial('SA1')+(cAliasTmp)->(ZAA_CLIENT+ZAA_LOJA)) )
					if Empty((cAliasTmp)->ZAA_NUMPED)
						FWMsgRun(,{ |oSay| lRET := GeraPV((cAliasTmp)->ZAA_NUMOC, oSay) },"Aguarde", "Processando Dados para Pedido Venda")
						if lRET
							//cStatus := gLocStatus()    // Verifico se existe bloqueio
						endif
					ELSE
						lRET := SC5->( MsSeek(xFilial('SC5')+(cAliasTmp)->ZAA_NUMPED) )
						if lRET
							//cStatus := gLocStatus()   // Verifico se ainda existe bloqueio
						endif
					Endif
					if lRET
						IF !(cStatus $ "B/G")
							FWMsgRun(,{ |oSay| lRET := GeraNotaF(SC5->C5_NUM, oSay) },"Aguarde","Processando Dados para Nota Fiscal")
							if lRET
								ZAA->( dbSetOrder(1) )
								ZAA->( MsSeek(xFilial('ZAA')+(cAliasTmp)->ZAA_NUMOC) )
								RecLock("ZAA",.f.)
								ZAA->ZAA_NUMNF := SF2->F2_DOC+'/'+SF2->F2_SERIE
								ZAA->ZAA_STATUS := "G"
								MsUnlock()
							endif
						else
							FWMsgRun(,{|| Sleep(3000)},'Informativo','Pedido: '+SC5->C5_NUM+' com bloqueio (Estoque/Credito).')
							cMessage += 'Simulação: '+(cAliasTmp)->ZAA_NUMOC+' - Pedido: '+SC5->C5_NUM+' com bloqueio (Estoque/Credito).'
							lRET := .F.
						Endif
					endif
				Else
					FWMsgRun(,{|| Sleep(3000)},'Informativo','Simulação: '+(cAliasTmp)->ZAA_NUMOC+' - Cliente: '+(cAliasTmp)->ZAA_CLIENT+' não encontrado.')
				Endif

				if !lRET
					cMessage += CRLF
				Endif
			Else
				ZAA->( dbSetOrder(1) )
				ZAA->( MsSeek(xFilial('ZAA')+(cAliasTmp)->ZAA_NUMOC) )
				RecLock("ZAA",.f.)
				 ZAA->ZAA_NUMPED  := ""
				 ZAA->ZAA_NUMNF  := ""
				 ZAA->ZAA_STATUS := ""
				MsUnlock()
			Endif
		EndIf

		(cAliasTmp)->(DbSkip())
	EndDo

	//Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
	FWAlertInfo('Existe(m) [' + cValToChar(nTotal) + '] registro(s). foram processados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')

	if lRET
		FWMsgRun(,{|| Sleep(3000)},'Informativo','Arquivo de Pedido de Venda salvo no servidor: \arquivos\Simula\pedidos\')
	endif

	if !Empty(cMessage)
		if Len(Alltrim(cMessage)) > 0
			MEMOWRITE( cCaminho+cArquivo, cMessage )
		endif
		if File(cCaminho+cArquivo)
			WinExec('explorer.exe  '+cCaminho+cArquivo)
		endif
	Endif
	//oDlgMark:End()

	FWRestArea(aArea)
Return


/*/{Protheus.doc} MntQuery
Rotina que monta a query para filtrar
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@return variant, String
/*/
Static Function MntQuery()
	Local cRET := ""

	cRET += "SELECT * " + CRLF
	cRET += "FROM " + RETSQLNAME("ZAA") + " A " + CRLF
	cRET += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cRET += " AND ZAA_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
	cRET += " AND ZAA_CLIENT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR05 + "' " + CRLF
	cRET += " AND ZAA_LOJA BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' " + CRLF
	if Empty(cSelecao)
		cRET += " AND ((ZAA_STATUS = ' ') or (ZAA_STATUS = 'B')) " + CRLF
	endif 
	cRET += "ORDER BY ZAA_NUMOC " + CRLF

Return cRET



/*/{Protheus.doc} GeraPV
Rotina que irá gerar o Pedido
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@param pNUMOC, variant, String
@return variant, Nil
/*/
Static Function GeraPV(pNUMOC, oSay)
	Local lRET        := .T.
	Local aCabec      := {}
	Local aItens      := {}
	Local _cTransp    := ""
	Local _cVend2     := ""
	Local _cVend1     := ""
	Local _cProduto   := ""
	Local _cCliente   := ""
	Local _cCondPag   := ""
	Local _cLoja      := ""
	Local _cDesc      := ""
	Local _cLocPad    := ""
	Local cStatus     := ""
	Local _CTPFRE     := GETMV("FS_TPFRSIM",.F.,"F")
	Local _cTpFat     := ""
	Local _cTpCli     := ""
	Local _cBloq      := ""
	Local _nPreco     := 0
	Local _nPrecoTab  := 0
	Local _nPrecoSis  := 0
	Local _nPrecoAnt  := 0
	Local i           := 0
	Local z           := 0
	Local _nQtdItem   := 0
	Local _nValLiqTot := 0
	Local _nValLiqPrd := 0
	Local _nPosCom1   := 0
	Local _nPosComiss := 0
	Local _nValComiss := 0
	Local _nVaPed     := 0
	Local _nSaldo     := 0
	Local _lPrecoDiv  := .F.
	Local _lPrcPsc    := .F.
	Local _lCondDiv   := .F.
	Local _lTemStella := .F.
	Local _cX         := "00"
	Local aArea       := FWGetArea()

	Private nAliqICM    := 0
	Private nValICms    := 0
	Private nAliqIPI    := 0
	Private nValIPI     := 0
	Private nValICMSST  := 0
	Private nValPis     := 0
	Private nValCof     := 0
	Private _cTabela    := ''
	Private cZConsumo	:= ""
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private _cxCliContr := "SA1->A1_GRPTRIB"
	Private _cCliEst    := "SA1->A1_EST"
	Private _cTipoCli   := "SC5->C5_TIPOCLI"
	Private _nXmargSf7  := 0

	ZAB->(dbSetOrder(1))

	ZAA->( dbSetOrder(1) )
	ZAA->( MsSeek(xFilial('ZAA')+pNUMOC) )

	_cCliente := SA1->A1_COD
	_cLoja    := SA1->A1_LOJA
	_cCondPag := SA1->A1_ZCONDPG
	_cVend1   := SA1->A1_VEND
	_cCliNom  := SA1->A1_NOME

	_cTpCli   := "F"
	if !Empty(SA1->A1_TIPO)
		_cTpCli := SA1->A1_TIPO
	endif

	if Empty(_cCondPag)
		_cCondPag := ZAA->ZAA_CONDPG
	endif

	If !ZAA->ZAA_TPFRET $ "C#F#T#S"
		_cTpFre	:= "F"      //Frete
	EndIf
	If !Empty(SA1->A1_TPFRET)
		_cTpFre	:= SA1->A1_TPFRET
	EndIf
	If !Empty(SA1->A1_ZCONDPG)
		If _cCliente = '003322' .And. SubStr(Alltrim(ZAA->ZAA_NUMOC),1,2) = 'OE'
			_cCondPag := '656'
		Else
			_cCondPag	:= SA1->A1_ZCONDPG
		EndIf
	EndIf
	If (SA1->A1_TIPO $ 'R' .And. SA1->A1_CONTRIB = '1'  .And. (alltrim(SA1->A1_GRPVEN) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(SA1->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(SA1->A1_INSCR))))
		cZConsumo := "1"
	EndIf
	If !Empty(SA1->A1_TRANSP)
		_cTransp	:= SA1->A1_TRANSP
	EndIf
	If !Empty(SA1->A1_TPFRET)
		_cTpFre	:= SA1->A1_TPFRET
	EndIf
	IF SA1->A1_COD = "038134"
		_cTpEnt	:= "1" // Tipo de entrega - Retira
	ELSE
		_cTpEnt	:= "2" // Tipo de entrega - Entrega
	ENDIF
	cObserv	:= ZAA->ZAA_OBSERV
	_cTpFat	:= "2"

	_cTabela := U_STXZ2B(_cCliente,_cLoja)      // Valdemir Rabelo 10/10/2022

	oSay:SetText("Gerando Pedido de Venda...")

	If	AllTrim(SA1->A1_COD) $ "038134/014519/023789/028358/092187/092887"
		_cTpFat	:= "1"
	EndIf

	If !Empty(SA1->A1_TRANSP)
		_cTransp	:= SA1->A1_TRANSP
	EndIf

	If Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
		cObserv	:=  Alltrim(ZAA->ZAA_NUMOC)+' - '+ Alltrim(cObserv)
	EndIf

	aAdd(aCabec, {"C5_TIPO"		,"N"												,Nil}) // Tipo do Pedido
	aAdd(aCabec, {"C5_CLIENTE"	,SA1->A1_COD										,Nil}) // Codigo do Cliente
	aAdd(aCabec, {"C5_LOJACLI"	,SA1->A1_LOJA										,Nil}) // Loja do Cliente
	aAdd(aCabec, {"C5_TIPOCLI"	,_cTpCli		    								,Nil}) // Tipo do Cliente
	aAdd(aCabec, {"C5_CONDPAG"	,_cCondPag      									,Nil}) // Condicao de pagamanto
	aAdd(aCabec, {"C5_EMISSAO"	,dDatabase											,Nil}) // Data de Emissao
	aAdd(aCabec, {"C5_ZCONDPG"	,_cCondPag      									,Nil}) // COND PG
	aAdd(aCabec, {"C5_TABELA"	,_cTabela					 						,Nil}) // TABELA
	aAdd(aCabec, {"C5_VEND1"	,SA1->A1_VEND										,Nil}) //VENDEDOR 1
	aAdd(aCabec, {"C5_VEND2"	,_cVend2											,Nil}) //VENDEDOR 2
	aAdd(aCabec, {"C5_TPFRETE"	,_cTpFre											,Nil}) // C=CIF;F=FOB;T=Por conta
	aAdd(aCabec, {"C5_TRANSP"	,_cTransp											,Nil}) // Transportadora
	aAdd(aCabec, {"C5_XTIPO"	,_cTpEnt											,Nil}) // 1=Retira;2=Entrega
	aAdd(aCabec, {"C5_XTIPF"	,_cTpFat											,Nil}) // 1=Total;2=Parcial
	aAdd(aCabec, {"C5_ZOBS"		,cObserv											,Nil}) // Observação
	aAdd(aCabec, {"C5_XORDEM"	,ZAA->ZAA_NUMOC										,Nil}) // Pedido do cliente
	aAdd(aCabec, {"C5_ZCONSUM"	,cZConsumo											,Nil}) // Consumo
	aAdd(aCabec, {"C5_ZEDI"		,"S"												,Nil}) // EDI
	aAdd(aCabec, {"C5_XNOME"	,Alltrim(SA1->A1_NOME)								,Nil}) // NOME
	aAdd(aCabec, {"C5_XORIG"	,"3"												,Nil})

	_lCepNEnt := .F.

	If  Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
		_cCep  := Alltrim(ZAA->ZAA_ENTCEP)
		_cXCep := ' '
		DbSelectArea("JC2")
		JC2->( dbSetOrder(1))
		If JC2->( dbSeek(xFilial("JC2")+_cCep) ) .And. !(Empty(Alltrim(_cCep)))

			aAdd(aCabec, {"C5_ZENDENT"	,Alltrim(ZAA->ZAA_ENTEND)									,Nil}) // End entrega
			aAdd(aCabec, {"C5_ZBAIRRE"	,Iif(Empty(Alltrim(JC2->JC2_BAIRRO)),"CENTRO",Alltrim(JC2->JC2_BAIRRO)) 									,Nil}) // Bairro entrega
			aAdd(aCabec, {"C5_ZCEPE"	,_cCep														,Nil}) // CEP entrega
			aAdd(aCabec, {"C5_ZESTE"	,Alltrim(JC2->JC2_ESTADO)									,Nil}) // Estado entrega
			aAdd(aCabec, {"C5_ZMUNE"	,Alltrim(JC2->JC2_CIDADE)									,Nil}) // Mun entrega
			aAdd(aCabec, {"C5_XCODMUN"	,Alltrim(JC2->JC2_CODCID)									,Nil}) // Codigo mun entrega
			_cXCep := _cCep
		Else

			aAdd(aCabec, {"C5_ZENDENT"	,SA1->A1_ENDENT										        ,Nil}) // End entrega
			aAdd(aCabec, {"C5_ZBAIRRE"	,Iif(Empty(SA1->A1_BAIRROE),"CENTRO",SA1->A1_BAIRROE)       ,Nil}) // Bairro entrega //Ticket 20200127000148
			aAdd(aCabec, {"C5_ZCEPE"	,SA1->A1_CEPE										        ,Nil}) // CEP entrega
			aAdd(aCabec, {"C5_ZESTE"	,SA1->A1_ESTE										        ,Nil}) // Estado entrega
			aAdd(aCabec, {"C5_ZMUNE"	,SA1->A1_MUNE										        ,Nil}) // Mun entrega
			aAdd(aCabec, {"C5_XCODMUN"	,SA1->A1_COD_MUN									        ,Nil}) // Codigo mun entrega
			_cXCep := SA1->A1_CEPE

			If !(Empty(ZAA->ZAA_ENTCEP))
				_lCepNEnt := .T.
			EndIf

		EndIf
		If SA1->A1_COD $ "038134"
			aAdd(aCabec, {"C5_XOBSEXP"		,"LEROY MERLIN"											,Nil}) //Obs. Exped.
		ElseIf SA1->A1_COD $ "028358/023789"
			aAdd(aCabec, {"C5_XOBSEXP"		,"EMBALAGEM INDIVIDUAL POR PRODUTO + EAN14"												,Nil}) //Obs. Exped.
			aAdd(aCabec, {"C5_XEAN"			,"1"													,Nil}) //Cod. Barras
		ElseIf SA1->A1_COD=="006596"
			aAdd(aCabec, {"C5_XOBSEXP"		,"NORTEL"												,Nil}) //Obs. Exped.
		ElseIf SA1->A1_COD=="014519"
			aAdd(aCabec, {"C5_XOBSEXP"		,"C&C CASA CONSTRUÇÃO"									,Nil}) //Obs. Exped.
		ElseIf SA1->A1_COD=="092887"
			aAdd(aCabec, {"C5_XOBSEXP"		,"AMAZON"									            ,Nil}) //Obs. Exped.
		Else
			aAdd(aCabec, {"C5_XOBSEXP"		," "												    ,Nil}) //Obs. Exped.
			aAdd(aCabec, {"C5_XEAN"		    ," "												    ,Nil}) //Obs. Exped.
		EndIf

		If Substr(_cXCep,1,1) = '0'
			aAdd(aCabec, {"C5_XDANO"	,Substr(Dtos(ddatabase),1,4)								,Nil}) // ano entrega
			aAdd(aCabec, {"C5_XMDE"		,Substr(Dtos(ddatabase),5,2)								,Nil}) // mes entrega
			aAdd(aCabec, {"C5_XDE"		,Substr(Dtos(ddatabase),7,2)								,Nil}) // dia entrega
			aAdd(aCabec, {"C5_XAANO"	,Substr(Dtos(ddatabase+8),1,4)								,Nil}) // ano entrega
			aAdd(aCabec, {"C5_XMATE"	,Substr(Dtos(ddatabase+8),5,2)								,Nil}) // mes entrega
			aAdd(aCabec, {"C5_XATE"		,Substr(Dtos(ddatabase+8),7,2)								,Nil}) // dia entrega

		EndIf
	Else
		aAdd(aCabec, {"C5_ZENDENT"	,SA1->A1_ENDENT										,Nil}) // End entrega
		aAdd(aCabec, {"C5_ZBAIRRE"	,SA1->A1_BAIRROE									,Nil}) // Bairro entrega
		aAdd(aCabec, {"C5_ZCEPE"	,SA1->A1_CEPE										,Nil}) // CEP entrega
		aAdd(aCabec, {"C5_ZESTE"	,SA1->A1_ESTE										,Nil}) // Estado entrega
		aAdd(aCabec, {"C5_ZMUNE"	,SA1->A1_MUNE										,Nil}) // Mun entrega
		aAdd(aCabec, {"C5_XCODMUN"	,SA1->A1_COD_MUN									,Nil}) // Codigo mun entrega

	EndIf

	ZAB->( MsSeek(xFILIAL('ZAB')+pNUMOC) )
	While ZAB->( !Eof() .and. ZAB_NUMOC==pNUMOC)

		_aAreaB1    := SB1->(GetArea())
		SB1->( MsSeek(xFilial("SB1")+ZAB->ZAB_PRODUT) )

		_cProduto   := SB1->B1_COD
		_cDesc      := SB1->B1_DESC
		_cLocPad    := SB1->B1_LOCPAD
		cTesPad     := U_STRETSST( '01' ,_cCliente,_cLoja,_cProduto,_cCondPag, 'TES' ,.T.)
		_nValLiqPrd := STLiq(_nPrecoTab*ZAB->ZAB_QUANT,_cProduto,ZAB->ZAB_QUANT,cTesPad)
		_nPosCom1   := u_ValPorComiss(AllTrim(_cProduto),_cVend1)           //C6_COMIS1
		_nPosComiss := Round(((_nPrecoTab*ZAB->ZAB_QUANT*_nPosCom1)/100),2) //C6_XVALCOM
		_nSaldo     := u_versaldo(AllTrim(_cProduto))
		_dDtEntrega := u_atudtentre(_nSaldo,AllTrim(_cProduto),ZAB->ZAB_QUANT)

		_nQtdItem++
		_cX      := Soma1(_cX)
		_cTabela := U_STXZ2B(_cCliente,_cLoja)
		_nPreco  := U_STRETSST( '01' ,_cCliente,_cLoja,_cProduto,_cCondPag, 'PRECO' ,.F.,,,_cTabela)
		If valtype(_nPreco) <> 'N'
			_nPreco:= 0.01
		EndIf

		_nPrecoTab	:= _nPreco
		_nPrecoSis	:= _nPrecoTab
		_nPrecoTab  := ZAB->ZAB_PRECO
		_nPrecoAnt	:=	U_STRETSST('01',_cCliente,_cLoja,_cProduto,_cCondPag,'PRECO',.F.,,,"X12")
		If valtype(_nPrecoAnt) <> 'N'
			_nPrecoAnt:= 0.01
		EndIf
		_nPreco	:= _nPreco-ZAB->ZAB_PRECO

		If !Positivo(_nPreco)
			_nPreco	:= _nPreco*-1
		EndIf

		If _cCliente $ "038134/028358/014519/092187/023789"
			If _nPreco < 0.03 .And. _nPreco > -0.03
				_nPrecoTab	:= ZAB->ZAB_PRECO
				_nPreco		:= 0
			EndIf
		EndIf

		If GetMv("STEDIPV002",,.T.)
			If Substr(AllTrim(SA1->A1_NREDUZ),1,3)=="MRV"
				_nPrecoTab	:= ZAB->ZAB_PRECO
				_nPreco     := 1
			EndIf
		EndIf

		If _nPreco > 0.02
			_lPrecoDiv	:= .T.
		EndIf
		If _nPrecoSis <= 0.01
			_lPrcPsc := .T.
		EndIf

		cTesPad     := U_STRETSST( '01' ,_cCliente,_cLoja,_cProduto,_cCondPag, 'TES' ,.T.)
		_nValLiqPrd := STLiq(_nPrecoTab*ZAB->ZAB_QUANT,_cProduto,ZAB->ZAB_QUANT,cTesPad)
		_nPosCom1   := u_ValPorComiss(AllTrim(_cProduto),_cVend1)
		_nPosComiss := Round(((_nPrecoTab*ZAB->ZAB_QUANT*_nPosCom1)/100),2)
		_nSaldo     := u_versaldo(AllTrim(_cProduto))
		_dDtEntrega := u_atudtentre(_nSaldo,AllTrim(_cProduto),ZAB->ZAB_QUANT)

		If _cX = '01'
			_cPrDu := AllTrim(_cProduto)
		EndIf
		If VALTYPE(cTesPad) <> 'C'
			cTesPad := '501'
		EndIf
		_cProdZAB := AllTrim(ZAB->ZAB_PRODUT)

		If _cCliente == '040289'
			_cProdZAB := '"' +AllTrim(ZAB->ZAB_PRODUT)+ '"'
		EndIf

		RestArea(_aAreaB1)

		Aadd(aItens,{{"C6_ITEM"		,_cX																			            ,Nil},; // Numero do Item no Pedido
		{"C6_PRODUTO"	,AllTrim(_cProduto)																			,Nil},; // Codigo do Produto
		{"C6_UM"   		,"UN"		  																				,Nil},; // Unidade de Medida Primar.
		{"C6_QTDVEN"	,ZAB->ZAB_QUANT																				,Nil},; // Quantidade Vendida
		{"C6_PRCVEN"	,_nPrecoTab																					,Nil},; // Preco Venda
		{"C6_PRUNIT"	,_nPrecoTab																					,Nil},; // Preco Unitario
		{"C6_VALOR"		,round(_nPrecoTab*ZAB->ZAB_QUANT,2)															,Nil},; // Valor Total do Item
		{"C6_LOCAL"		,_cLocPad																					,Nil},; // Almoxarifado
		{"C6_CLI"		,_cCliente																					,Nil},; // Cliente
		{"C6_OPER"		,"01"																						,Nil},; // OPERAÇÃO
		{"C6_TES"		,cTesPad																					,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_ITEMPC"	,Iif(AllTrim(SA1->A1_COD)=="028358",AllTrim(ZAB->ZAB_ITEMP)+'0',AllTrim(ZAB->ZAB_ITEMP))	,Nil},; // Item do pedido de compra
		{"C6_NUMPCOM"	,AllTrim(ZAA->ZAA_NUMOC)																	,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_XORDEM"	,_cProdZAB																					,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_ZVALLIQ"	,_nValLiqPrd																				,Nil},; //Valor liquido
		{"C6_ENTRE1"	,_dDtEntrega																				,Nil},; // Data da Entrega
		{"C6_ZPICMS"	,nAliqICM																					,Nil},; // Aliq ICMS
		{"C6_ZVALICM"	,nValICms																					,Nil},; // Val ICMS
		{"C6_ZIPI"		,nAliqIPI																					,Nil},; // Aliq IPI
		{"C6_ZVALIPI"	,nValIPI																					,Nil},; // Val IPI
		{"C6_ZVALIST"	,nValICMSST																					,Nil},; // Val ICMS ST
		{"C6_ZMOTBLO"	,Iif(_nPreco>0.02,"6","3")																	,Nil},; // Bloqueio do item
		{"C6_COMIS1"	,_nPosCom1																					,Nil},; // C6_COMIS1
		{"C6_EMISSAO"	,dDatabase																					,Nil},; // C6_EMISSAO
		{"C6_XVALCOM"	,_nPosComiss																				,Nil}}) // C6_XVALCOM

		_nValComiss		+= _nPosComiss
		_nVaPed			+= round(_nPrecoTab*ZAB->ZAB_QUANT,2)
		_nValLiqTot		+= _nValLiqPrd

		_nQtITCLI := 0
		Do Case
		Case AllTrim(_cCliente)=="010566"
			_nQtITCLI=30
		Case AllTrim(_cCliente)=="006596"
			_nQtITCLI=20
		Case AllTrim(_cCliente)=="008724"
			_nQtITCLI=30
		Case AllTrim(_cCliente)=="011859"
			_nQtITCLI=20
		Case AllTrim(_cCliente)=="003382"
			_nQtITCLI=20
		Case Alltrim(_cCliente)== "036659"
			_nQtITCLI = 20
		Case Alltrim(_cCliente)== "008724"
			_nQtITCLI = 30
		Case Alltrim(_cCliente)== "007613"
			_nQtITCLI = 30
		EndCase

		If i == z .Or. (_nQtdItem == _nQtITCLI)

			_nQtdItem	:= 0

			//	Begin Transaction

			If _lPrcPsc
				_cBloq	+= "PSC/"
			EndIf
			If _lPrecoDiv
				_cBloq	+= "PRCEDI/"
			EndIf

			If    _cCliente $ GetMv("ST_EDIBLQ",, '023789/')
				_cBloq	+= "EDI-/"
			EndIf

			If _lCepNEnt
				_cBloq	+= "CEPENT/"
			EndIf

			_lPrecoDiv	:= .F.

			//aAdd(aCabec, {"C5_ZBLOQ"	,IIf(Empty(Alltrim(_cBloq)),"2","1")				,Nil}) // Bloqueio
			//aAdd(aCabec, {"C5_ZMOTBLO"	,_cBloq												,Nil}) // Descrição do bloqueio
			aAdd(aCabec, {"C5_ZVALLIQ"	,_nValLiqTot										,Nil}) // Valor líquido
			aAdd(aCabec, {"C5_COMIS1"	,((_nValComiss*100)/_nVaPed)						,Nil}) // Comissão Total

			If !Empty(ZAA->ZAA_DTENT)
				aAdd(aCabec, {"C5_ZDTCLI"	,ZAA->ZAA_DTENT									,Nil}) // Descrição do bloqueio
			EndIf
			If _lTemStella
				aAdd(aCabec, {"C5_XSTELLA"	,"2"											,Nil}) //Stella
			EndIf

			lMsErroAuto	:= .F.
			If GetMv("ST_EDIPVX",,.T.) .And. !(STDUPLOD(ZAA->ZAA_NUMOC,_cPrDu,_cCliente,_cLoja))
				DisarmTransaction()
				RollBackSX8()
			Else
				Begin Transaction
					lMsErroAuto := .F.

					MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,3)

					If lMsErroAuto
						lRET := .F.
						cMessage += 'Simulação: '+ZAA->ZAA_NUMOC+' Problemas na geração, detalhes a seguir:' + CRLF
						cMessage += MostraErro("/dirdoc", "error.log") + CRLF+ CRLF
						cArquivo := cCopiaArq+alltrim(ZAA->ZAA_NUMOC)+".txt"
						DisarmTransaction()
						RollBackSX8()
					else
						// Verifico se ocorreu bloqueio na geração do pedido
						//cStatus := gLocStatus()
						RecLock("ZAA", .F.)
						ZAA->ZAA_STATUS := cStatus
						ZAA->ZAA_NUMPED := SC5->C5_NUM
						MsUnlock()
						ConfirmSX8()
						FWMsgRun(, { |oSay| PDF_PV(SC5->C5_NUM, oSay) },"Aguarde...","Gerando PDF do pedido de vendas")

						if !lRET
							FWMsgRun(, {|| Sleep(300)},'Atenção!','Pedido bloqueado (Estoque/Credito)')
						endif
					EndIf

				End Transaction

			EndIf

			aItens      := {}
			_cX         := "00"
			_cBloq      := " "
			_nValLiqTot := 0
			_nValComiss := 0
			_nVaPed     := 0

			If _lCondDiv
				_cBloq	+= "CONDPG/"
			EndIf

			_nValLiqTot	:= 0

		Endif

		ZAB->( dbSkip() )
	EndDo

	FWRestArea( aArea )


Return lRET


/*/{Protheus.doc} GeraNotaF
Rotina que irá gerar Nota Fiscal
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@param pNUMOC, variant, String
@return variant, Nil
/*/
Static Function GeraNotaF(pNUMSC5, oSay)
	Local aAreaG     := FWGetArea()
	Local lRET       := .T. as logical
	Local cNumPed    := ""  as String
	Local aPvlNfs    := {}  as Array
	Local _cNota     := ''  as String
	Local cPasta     := '\arquivos\simula\nota fiscais\'
	Private _cSerIbl := IIF(cFILANT= '01' , '001' , '001' )

	if !ExistDir("\arquivos")
		MAKEDIR( "\arquivos" )
	endif
	if !ExistDir("\arquivos\simula")
		MAKEDIR( "\arquivos\simula" )
	endif
	if !ExistDir("\arquivos\simula\nota fiscais")
		MAKEDIR( "\arquivos\simula\nota fiscais" )
	endif

	DbSelectArea("SF4")
	SF4->(DbSetOrder(1))

	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SE4")
	SE4->(DbSetOrder(1))

	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SC5")
	SC5->( DbSetOrder(1) )
	if !SC5->( MsSeek(xFilial('SC5')+pNUMSC5) )
		cMessage += "Pedido: "+pNUMSC5+" não encontrado <GeraNotaF>"
		Return .F.
	endif
	cNumPed:= SC5->C5_NUM

	oSay:SetText("Gerando Nota Fiscal...")

	If SC9->(MsSeek(xFilial("SC9")+cNumPed))
		While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO == xFilial("SC9")+cNumPed)
			Reclock("SC9",.F.)
			SC9->C9_BLEST  := ""
			SC9->C9_BLCRED := ""
			MsUnlock()
			If SC6->(MsSeek(xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				If SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG))
					If		SB1->(MsSeek(xFilial("SB1")+SC9->C9_PRODUTO))
						If		SB2->(MsSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
							If		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
								Aadd(aPvlNfs,{;
									SC9->C9_PEDIDO,;
									SC9->C9_ITEM,;
									SC9->C9_SEQUEN,;
									SC9->C9_QTDLIB,;
									SC9->C9_PRCVEN,;
									SC9->C9_PRODUTO,;
									.F.,;
									SC9->(RecNo()),;
									SC5->(RecNo()),;
									SC6->(RecNo()),;
									SE4->(RecNo()),;
									SB1->(RecNo()),;
									SB2->(RecNo()),;
									SF4->(RecNo())})
							Endif
						Endif
					Endif
				Endif
			Endif
			SC9->(Dbskip())
		EndDo
	Else
		cMessage += "Pedido: "+pNUMSC5+" não encontrado na tabela Pedidos Liberado (SC9) <GeraNotaF>"
		Return .F.
	Endif

	_cNota := MaPvlNfs(aPvlNfs, _cSerIbl, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
	lRET   := (!Empty(_cNota))
	if lRET
		SF2->( dbSetOrder(1) )
		if SF2->( dbSeek(xFilial("SF2")+_cNota+_cSerIbl+SA1->A1_COD+SA1->A1_LOJA) )
			U_STAutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0","2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
			Sleep(10000)
			U_STRONFE(SF2->F2_CHVNFE,.T.,SF2->F2_DOC)
			//U_STDANFENFe(SF2->F2_DOC, SF2->F2_SERIE, cPasta, .F.)
			cArquivo := cCopiaArq +ZAA->ZAA_NUMOC+ ".txt"
		endif
	endif

	FWRestArea( aAreaG )

Return lRET



Static Function AddLOG(pMSG)
	LjWriteLog( cCaminho+cArquivo, pMSG )
Return



/*/{Protheus.doc} PDF_PV
Rotina que irá gerar o arquivo do Pedido em PDF
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/09/2022
@param pC5_NUM, variant, String
@return variant, Nil
/*/
Static Function PDF_PV(pC5_NUM, oSay)
	// Chama Impressão PDF
	U_RSTFAT09()
/*
	PRIVATE cStartPath 	  := '\arquivos\Simula\pedidos\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") 
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.
	Private oPrint

    if !ExistDir("\arquivos")
       MAKEDIR( "\arquivos" )
    endif
    if !ExistDir("\arquivos\simula")
       MAKEDIR( "\arquivos\simula" )
    endif
    if !ExistDir("\arquivos\Simula\pedidos")
       MAKEDIR( "\arquivos\Simula\pedidos" )
    endif

	_cNomePdf  :=cEmpAnt+"_Pedido_"+SC5->C5_NUM
	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , cStartPath  ,.T.			,  ,  ,  ,  .T.,  ,.f.,.f. )
	oPrint:SetLandScape()
	oPrint:SetMargin(60,60,60,60)
	oPrint:setPaperSize(9)

	CriaPVPDF()

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath
	oPrint:Print()    
*/
Return



/*

Static Function CriaPVPDF()

	LOCAL _nTxper      := GETMV("MV_TXPER")
	LOCAL i            := 0
	Local _cDMoed      := "R$"
	LOCAL oBrush
	Local _nTotIPI     := 0
	Local _nTotICMSST  := 0
	Local _nTotvalmerc := 0
	Local _nTotpedvend := 0
	Local _nTotal      := 0
	Local _nTotSuf     := 0
	Local _ncount      := 0

	Private _nLin      := 4000
	Private _cNomeCom  := SM0->M0_NOMECOM
	Private _cEndereco := SM0->M0_ENDENT
	Private cCep       := SM0->M0_CEPENT
	Private cCidade    := SM0->M0_CIDENT
	Private cEstado    := SM0->M0_ESTENT
	Private cCNPJ      := SM0->M0_CGC
	Private cTelefone  := SM0->M0_TEL
	Private cFax       := SM0->M0_FAX
	Private cIe        := Alltrim(SM0->M0_INSC)
	Private nAliqICM   := 0
	Private nValICms   := 0
	Private nAliqIPI   := 0
	Private nValIPI    := 0
	Private nValICMSS  := 0
	Private nValSuf    := 0
	Private nValPis    := 0
	Private nValCof    := 0

	aBmp := "STECK.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oBrush := TBrush():New("",4)

	_ntotal  := 0
	_npagina := 0
	_aItRed  := {}

	Dbselectarea("SM0")
	Dbselectarea("SC6")
	SC6->(Dbsetorder(1))
	SC6->(Dbseek(xfilial("SC6")+SC5->C5_NUM) )

	oPrint:StartPage()     // INICIALIZA a página
	xCabOrc()

	Do While !eof()  .and. SC5->C5_NUM == SC6->C6_NUM

		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

		STGETIMP()

		_nTotIPI     := (nValIPI)+(_nTotIPI)
		_nTotICMSST  := (nValICMSST)+(_nTotICMSST)
		_nTotSuf     := (nValSuf)+_nTotSuf
		_nTotvalmerc := (SC6->C6_VALOR)+(_nTotvalmerc)
		_nTotpedvend := (_nTotvalmerc)+(_nTotIPI)+(_nTotICMSST)

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		// Posiciona No Cad Produtos
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SC6->C6_PRODUTO)

		// Posiciona No Cad De TES
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4") + SC6->C6_TES,.t.)

		_nXmargSf7 := Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+_cTipoCli,'F7_MARGEM')

		//Impressao do Item
		oPrint:Say  (_nLin,020, SC6->C6_ITEM	,oFont8)

		//Impressao do Codigo e Descricao do Produto
		oPrint:Say  (_nLin,040, SC6->C6_produto	,oFont8)
		_nTam		:= 60
		_ctexto  	:= Alltrim(SubStr(SB1->B1_DESC,1,42))
		_nlinhas 	:= mlcount(_ctexto,_nTam)

		for _ncount:= 1 to _nlinhas
			oPrint:Say  (_nLin ,095, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin+=60
			EndIf
		next _ncount

		//Impressao da Quantidade e Unidade de Medida
		oPrint:Say  (_nLin,280, transform(SC6->C6_QTDVEN,"@E 999999.99")	,oFont8)
		_nTam		:= 60
		_ctexto  	:= Alltrim(SB1->B1_UM)
		_nlinhas 	:= mlcount(_ctexto,_nTam)

		for _ncount:= 1 to _nlinhas
			oPrint:Say  (_nLin ,320, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin+=60
			EndIf
		next _ncount

		//Impressao do Valor Unitario
		oPrint:Say  (_nLin,350, transform(SC6->C6_PRCVEN	,"@E 999,999.99")	,oFont8)

		//Impressao do Percentual de IPI
		oPrint:Say  (_nLin,390, transform(nAliqIPI 	,"@E 999.99")		,oFont8)

		//Impressao do Percentual de ICMS
		oPrint:Say  (_nLin,420, transform(nAliqICM,"@E 999.99")		,oFont8)

		//Impressao do Percentual de IVA
		oPrint:Say  (_nLin,450, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)

		//Impressao do Valor de ICMS-ST
		oPrint:Say  (_nLin,490, transform((nValICMSST)	,"@E 99,999,999,999.99")		,oFont8)

		//Impressao do Valor Total
		oPrint:Say  (_nLin,550, transform(SC6->C6_VALOR	,"@E 9,999,999.99")	,oFont8)
		_nTotal	+= SC6->C6_VALOR

		//Impressao do Prazo de Entraga
		//oPrint:Say  (_nLin,600, transform(SC6->C6_ENTRE1	,"@E 999.999,99")	,oFont8)

		//Impressao do NCM
		//oPrint:Say  (_nLin,660, transform(SC6->C6_ZNCM  	,"@R 9999.99.99")	,oFont8)
		oPrint:Say  (_nLin,600, transform(SC6->C6_ZNCM  	,"@R 9999.99.99")	,oFont8)

		//Impressao da Ordem de Compra por Item
		//oPrint:Say  (_nLin,720, transform(SC6->C6_XORDEM  	,"@!")	            ,oFont8)
		oPrint:Say  (_nLin,660, transform(SC6->C6_XORDEM  	,"@!")	            ,oFont8)

		//Impressao de dias uteis
		//oPrint:Say  (_nLin,720, transform(SC6->C6_ENTRE1	,"@E 999.999,99")	,oFont8)
		//oPrint:Say  (_nLin,720, transform(CVALTOCHAR(Iif(POSITIVO(SC6->C6_ENTRE1-SC5->C5_EMISSAO),SC6->C6_ENTRE1-SC5->C5_EMISSAO,(SC6->C6_ENTRE1-SC5->C5_EMISSAO)*-1)+1)+" dias corridos"				  	,"@!")	            ,oFont8)
		oPrint:Say  (_nLin,720, transform(CVALTOCHAR(U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2"))+" dias corridos"				  	,"@!")	            ,oFont8)

		_nLin+=15

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		Dbselectarea("SC6")
		SC6->(DbSkip())

	Enddo

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total do Pedido de Venda
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Say  (_nLin,550, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*_nTotvalmerc*//*_nTotal,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotIPI,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotICMSST,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total Suframa (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotSuf,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total do Pedido de Venda (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*_nTotpedvend*//*_nTotal+_nTotIPI+_nTotICMSST-_nTotSuf,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	// Observação da Cotação:
	oPrint:Say  (_nLin,020, "Observação"						,oFont10)
	oPrint:Say  (_nLin,070, ": " + SC5->C5_ZOBS 				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	// Inicia Mensagens do Pedido de Venda
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	// Imprime Vendedor
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_NOME"))
	oPrint:Say  (_nLin,020, "Operador"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend1)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_TEL"))
	oPrint:Say  (_nLin,020, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend2)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend3 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_FAX"))
	oPrint:Say  (_nLin,020, "Fax"						 		,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend3)		 		,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))
	oPrint:Say  (_nLin,020, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + lower(_cVend4)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	oPrint:EndPage()     // Finaliza a página

Return()


/*{Protheus.doc} xCabOrc
Rotina que faz impressão cabeçalho
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/09/2022
@return variant, nil
/*
Static Function xCabOrc ()

	oPrint:Box(045,005,580,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,120,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SC5->C5_CLIENTE + SC5->C5_LOJACLI )

	oPrint:Box(125,005,230,800)

	oPrint:Say  (140,020,"Empresa: "+ Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (155,020,"Código de Cliente: "+ SC5->C5_CLIENTE + " - " + SC5->C5_LOJACLI			,oFont12)

	oPrint:Say  (170,020,"Dados de Faturamento: " 																																								,oFont12)
	oPrint:Say  (185,020,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (200,020,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        		   																											,oFont12)
	oPrint:Say  (215,020,"I.E.: "+ SA1->A1_INSCR 											   	   																												,oFont12)

	oPrint:Box(230,005,295,800)
	cBmpName  :=SC5->C5_NUM
	oPrint:Say  (245,020,"Pedido de Venda"						,oFont12)
	oPrint:Say  (245,100,": " + SC5->C5_NUM						,oFont12)
	oPrint:Say  (245,220,"Emissão" 								,oFont12)
	oPrint:Say  (245,310,": " + dtoc(SC5->C5_EMISSAO)			,oFont12)


	dbselectarea("SU5")
	MsSeek(Xfilial("SU5")  + SC5->C5_ZCODCON )
	dbselectarea("SQB")
	MsSeek(Xfilial("SQB")  + SU5->U5_DEPTO )

	_cDepto:=SQB->QB_DESCRIC

	oPrint:Say  (260,020, "Contato" 						,oFont12)
	oPrint:Say  (260,100, ": " + Capital(SU5->U5_CONTAT)	,oFont12)
	oPrint:Say  (260,220, "Departamento"					,oFont12)
	oPrint:Say  (260,310, ": " + (_cDepto)					,oFont12)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + SC5->C5_CONDPAG )

	oPrint:Say  (275,020, "Cond. Pagto" 					,oFont12)
	oPrint:Say  (275,100, ": " + SE4->E4_DESCRI				,oFont12)
	oPrint:Say  (275,220, "Ordem de Compra" 				,oFont12)
	oPrint:Say  (275,310, ": "+ SC5->C5_XORDEM				,oFont12)

	IF SC5->C5_TPFRETE = "F"
		_cFrete = "FOB"
	Else
		_cFrete = "CIF"
	Endif

	oPrint:Say  (290,020, "Frete"				,oFont12)
	oPrint:Say  (290,100, ": "	+ (_cFrete)		,oFont12)
	oPrint:Say  (290,220, "Atendimento"			,oFont12)
	oPrint:Say  (290,310, ": "+SC5->C5_ZORCAME	,oFont12)

	oPrint:Box(295,005,320,800)
	oPrint:Say  (310,020, "Item"			    	,oFont10)
	oPrint:Say  (310,040, "Código"					,oFont10)
	oPrint:Say  (310,095, "Descrição"				,oFont10)
	oPrint:Say  (310,280, "Qtde." 					,oFont10)
	oPrint:Say  (310,320, "UM"						,oFont10)
	oPrint:Say  (310,350, "Vlr Unit"  				,oFont10)
	oPrint:Say  (310,390, "IPI"				    	,oFont10)
	oPrint:Say  (310,420, "ICMS"				   	,oFont10)
	oPrint:Say  (310,450, "IVA"				    	,oFont10)
	oPrint:Say  (310,490, "ICMS-ST"				    ,oFont10)
	oPrint:Say  (310,550, "Valor Total"				,oFont10)
	//oPrint:Say  (310,600, "Prazo Entrega"			,oFont10)
	//oPrint:Say  (310,660, "Clas. Fiscal"			,oFont10)
	oPrint:Say  (310,600, "Clas. Fiscal"			,oFont10)
	//oPrint:Say  (310,720, "Ordem/Produto"			,oFont10)
	oPrint:Say  (310,660, "Ordem/Produto"			,oFont10)
	oPrint:Say  (310,720, "Prazo de entrega"  			,oFont10)

	_nLin := 330

Return()



/*{Protheus.doc} STGETIMP
Rotina que carrega os impostos
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/09/2022
@return variant, Nil
/*
STATIC Function STGETIMP()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SC5->C5_CLIENTE,;	// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					    // 3-C:Cliente , F:Fornecedor
	"N",;					    // 4-Tipo da NF
	SC5->C5_TIPOCLI,;		    // 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(SC6->C6_PRODUTO,;                                               // 1-Codigo do Produto ( Obrigatorio )
	SC6->C6_TES,;                                                            // 2-Codigo do TES ( Opcional )
	SC6->C6_QTDVEN,;                                                         // 3-Quantidade ( Obrigatorio )
	SC6->C6_PRCVEN,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	SC6->C6_VALOR,;  														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	nValSuf		:= (MaFisRet(1,"IT_DESCZF",14,2)  )	   //Valor do suframa

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

Return

/*{Protheus.doc} gLocStatus
Rotina Que Verifica Status
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/09/2022
@return variant, String
/*
Static Function gLocStatus()
    Local cRET   := ""
    Local aAreaT := FWGetArea()

    dbSelectArea("SC9")
    SC9->( dbSetOrder(1) )
    SC9->( MsSeek(xFilial('SC9')+SC5->C5_NUM) )
    While SC9->(!Eof() .and. C9_PEDIDO==SC5->C5_NUM .AND. C9_FILIAL==SC5->C5_FILIAL)
        if (!Empty(SC9->C9_BLCRED) .and. (SC9->C9_BLCRED <> '10')) .OR. SC9->( (!Empty(C9_BLEST) ) .And. (C9_BLEST <> '10') .And. (C9_BLEST <> 'ZZ') )
           cRET := "B"
           Exit
        Endif 
        SC9->( dbSkip() )
    EndDo 

    FWRestArea( aAreaT )

Return cRET
*/


Static Function STLiq(_nValor,_cProduto,_nQuant,_cTesA)

	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI

	nValIPI 	:= ROUND(MaFisRet(1,"IT_VALIPI",14,2) / _nQuant,2)    //Valor do IPI

	nValICMSST 	:= ROUND(MaFisRet(1,'IT_VALSOL',14,2) / _nQuant,2)    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof + nValCmp + nValDif)

Return(round(_nValor,2))



Static Function STDUPLOD(_cOrdem,_cPrDu,_cCliedi,_cLJedi)
	Local _lRex			:= .T.
	Local _cQuery 		:= ""
	Local _cAlias 		:= "STDUPLOD"

	_cQuery	:= " SELECT C5_NUM, C6_PRODUTO FROM "+RetSqlName("SC5")+" SC5
	_cQuery	+= " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+")SC6
	_cQuery	+= " ON SC6.D_E_L_E_T_ = ' '
	_cQuery	+= " AND C6_FILIAL = C5_FILIAL
	_cQuery	+= " AND C6_NUM = C5_NUM
	_cQuery	+= " AND C6_ITEM = '01'
	_cQuery	+= " AND C6_PRODUTO = '"+_cPrDu+"' AND C5_CLIENTE = '"+_cCliedi+"' AND C5_LOJACLI = '"+_cLJedi+"'
	_cQuery	+= " WHERE SC5.D_E_L_E_T_ = ' ' AND C5_NOTA NOT LIKE '%XXXX%' AND C5_XORDEM = '"+ ALLTRIM(_cOrdem)+"' AND C5_FILIAL = '02' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())

		_lRex	:= .F.

	EndIf

Return(_lRex)

