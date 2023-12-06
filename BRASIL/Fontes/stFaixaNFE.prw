#INCLUDE "SPEDNFE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE TAMMAXXML  GetNewPar("MV_XMLSIZE",400000)
#DEFINE VBOX       080
#DEFINE HMARGEM    030

#Define STR0010 "Serie da Nota Fiscal"
#Define STR0011 "Nota fiscal inicial"
#Define STR0012 "Nota fiscal final"
#Define STR0035 "Ambiente"
#Define STR0036 "Modalidade"
#Define STR0049 "NF"
#Define STR0050 "Protocolo"
#Define STR0051 "Recomendação"
#Define STR0052 "Tempo decorrido"
#Define STR0053 "Tempo SEF"
#Define STR0054 "Mensagens"
#Define STR0115 "Schema"
#Define STR0114 "OK"
#Define STR0021 "Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
#Define STR0249 ""
#Define STR0459 ""
#Define STR0460 ""


static cTipoNfe := ""
static __cDocChv

static _lPEFilNFE := nil

/*/{Protheus.doc} stFaixaNFE
@description
Rotina que irá retornar um array com status da SEFAZ
@type function
@author Valdemir Jose
@since 22/10/2021
 U_stFaixaNFE
/*/
User Function stFaixaNFE(cSerie,cNotaIni,cNotaFim)
	Default cSerie   := ""
	Default cNotaIni := ""
	Default cNotaFim := ""
Return SpedNFe1Mnt(cSerie,cNotaIni,cNotaFim)


/*/{Protheus.doc} SpedNFe1Mnt
@description
Rotina que chama controle para validação da SEFAZ
@type function
@author Valdemir Jose
@since 22/10/2021
/*/
Static Function SpedNFe1Mnt(cSerie,cNotaIni,cNotaFim )
	Local lCTE:=  IIf (FunName()$"SPEDCTE,TMSA200,TMSAE70,TMSA500",.T.,.F.)
	Local lNFCE:= IIf (FunName()$"LOJA701",.T.,.F.)
	Local cModel     := ""
	Default cSerie   := ""
	Default cNotaIni := ""
	Default cNotaFim := ""

Return SpedNFetst(cSerie,cNotaIni,cNotaFim,lCTE,,)


/*/{Protheus.doc} SpedNFetst
description
@type function
@version  
@author Valdemir Jose
@since 22/10/2021
@param cSerie, character, param_description
@param cNotaIni, character, param_description
@param cNotaFim, character, param_description
@param lCTe, logical, param_description
@param lMDFe, logical, param_description
@param cModel, character, param_description
@param lTMS, logical, param_description
@param lAutoColab, logical, param_description
@param lExibTela, logical, param_description
@param lUsaColab, logical, param_description
@param lNFCE, logical, param_description
@param lICC, logical, param_description
@return variant, return_description
/*/
static Function SpedNFetst(cSerie,cNotaIni,cNotaFim, lCTe, lMDFe, cModel,lTMS, lAutoColab,lExibTela,lUsaColab,lNFCE,lICC)

	Local cIdEnt   := ""
	local cUrl			:= Padr( GetNewPar("MV_SPEDURL",""), 250 )
	Local aPerg    := {}
	Local aParam   := {Space(Len(SerieNfId("SF2",2,"F2_SERIE"))),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),CtoD(""),CtoD("")}
	Local aSize    := {}
	Local aObjects := {}
	Local aListBox := {}
	Local aInfo    := {}
	Local aPosObj  := {}
	Local oWS
	Local oDlg
	Local oListBox
	Local oBtn1
	Local oBtn2
	Local oBtn3
	Local oBtn4
	Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local lOK        := .F.
	Local lInter     := .F.
	Local dDataDe	 := CtoD("")
	Local dDataAte	 := CtoD("")
	Local lSdoc      := TamSx3("F2_SERIE")[1] == 14

	Default cSerie     := ''
	Default cNotaIni   := ''
	Default cNotaFim   := ''
	Default lCTe       := .F.
	Default lMDFe      := .F.
	Default cModel     := ""
	default lTMS       := .F.
	Default lAutoColab := .F.
	Default lExibTela  := .T. // Não exibe se Falso
	Default lUsaColab  := .F.
	Default lNFCE      := IIf (FunName()$"LOJA701",.T.,.F.)
	Default lICC       := .F.

	// Tratamento da NFCe para o Loja
	If cModel == "65"
		If !Empty( GetNewPar("MV_NFCEURL","") )
			cURL := PadR(GetNewPar("MV_NFCEURL","http://"),250)
		Endif
	EndIf

	lUsaColab := UsaColaboracao( IIF(lCte,"2",IIF(lMDFe,"5",IIF(lNFCE,,"1"))))
	if lUsaColab .And. Empty(cModel)
		cModel := Iif(lCte,"57",iif(lMDFe,"58","55"))
	endif

	If !lAutoColab
		aadd(aPerg,{1,Iif(lMDFe,STR0249,STR0010),aParam[01],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
		aadd(aPerg,{1,Iif(lMDFe,STR0459,STR0011),aParam[02],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
		aadd(aPerg,{1,Iif(lMDFe,STR0460,STR0012),aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

		aParam[01] := ParamLoad(cParNfeRem,aPerg,1,aParam[01])
		aParam[02] := ParamLoad(cParNfeRem,aPerg,2,aParam[02])
		aParam[03] := ParamLoad(cParNfeRem,aPerg,3,aParam[03])
	EndIF

	If lSdoc
		aadd(aPerg,{1,"Dt. Emissão De"	,aParam[04],"@R 99/99/9999",".T.","",".T.",50,.F.}) 			//"Data de Emissão"
		aadd(aPerg,{1,"Dt. Emissão Até"	,aParam[05],"@R 99/99/9999",".T.","",".T.",50,.F.}) 			//"Data de Emissão"

		dDataDe := aParam[04] := ParamLoad(cParNfeRem,aPerg,4,aParam[04])
		dDataAte := aParam[05] := ParamLoad(cParNfeRem,aPerg,5,aParam[05])
	EndIf

	If IsReady( ,,,lUsaColab )
		// Obtem o codigo da entidade
		cIdEnt := GetIdEnt( lUsaColab )
		If !Empty(cIdEnt)
			// Instancia a classe
			If !Empty(cIdEnt)
				If lAutoColab
					aParam[01] := cSerie
					aParam[02] := cNotaIni
					aParam[03] := cNotaFim
					lOK        := .T.
				Else
					If (lCTe) .And. !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim)
						aParam[01] := cSerie
						aParam[02] := cNotaIni
						aParam[03] := cNotaFim
						lOK        := .T.
					ElseIf (lMDFe) .And. !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim)
						aParam[01] := cSerie
						aParam[02] := cNotaIni
						aParam[03] := cNotaFim
						lOK        := .T.
					Else
						IF (lExibTela)
							aParam[01] := cSerie
							aParam[02] := cNotaIni
							aParam[03] := cNotaFim
							lOK        := .T.
						Else
							lOK        := ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,,cParNfeRem,.T.,.T.)
							cSerie   := aParam[01]
							cNotaIni := aParam[02]
							cNotaFim := aParam[03]
						EndIF
					EndIf

					If lSdoc
						dDataDe  := aParam[04]
						dDataAte := aParam[05]
						GetFiltroF3(@aParam,,dDataDe,dDataAte)
					EndIF
				EndIF
				If (lOK)
					If lMDFe .And. !lUsaColab
						aListBox := WsMDFeMnt(cIdEnt,cSerie,cNotaIni,cNotaFim,.T.)
					Else
						aListBox := getListBox(cIdEnt, cUrl, aParam, 1, cModel, lCte, .T., lMDFe, lTMS,lUsaColab,lICC)
					EndIf
					if lInter
						If !Empty(aListBox) .And. !lAutoColab
							aSize := MsAdvSize()
							aObjects := {}
							AAdd( aObjects, { 100, 100, .t., .t. } )
							AAdd( aObjects, { 100, 015, .t., .f. } )

							aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
							aPosObj := MsObjSize( aInfo, aObjects )

							DEFINE MSDIALOG oDlg TITLE "SPED - NFe" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

							If Len(aListBox[1]) >= 10
								@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "",STR0049,STR0035,STR0036,STR0050,STR0051,STR0052,STR0053, "Tentativas", "Observacao"; //"NF"###"Ambiente"###"Modalidade"###"Protocolo"###"Recomendação"###"Tempo decorrido"###"Tempo SEF"
								SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
							Else
								@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "",STR0049,STR0035,STR0036,STR0050,STR0051,STR0052,STR0053; //"NF"###"Ambiente"###"Modalidade"###"Protocolo"###"Recomendação"###"Tempo decorrido"###"Tempo SEF"
								SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
							EndIf
							oListBox:SetArray( aListBox )
							If Len(aListBox[1]) >= 10
								oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ],aListBox[ oListBox:nAT,10 ],aListBox[ oListBox:nAT,11 ] } }
							Else
								oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ] } }
							EndIf

							@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT STR0114   		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //"OK"
							@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn2 PROMPT STR0054   		ACTION (Bt2NFeMnt(aListBox[oListBox:nAT][09])) OF oDlg PIXEL SIZE 035,011 //"Mensagens"
							@ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn3 PROMPT STR0055   		ACTION (Bt3NFeMnt(cIdEnt,aListBox[ oListBox:nAT,2 ],,lUsaColab,cModel)) OF oDlg PIXEL SIZE 035,011 //"Rec.XML"
							If lMDFe .And. !lUsaColab
								@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT STR0118 	ACTION (aListBox := WsMDFeMnt(cIdEnt,cSerie,cNotaIni,cNotaFim,.T.),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
							Else
								@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT STR0118 	ACTION (aListBox := getListBox(cIdEnt, cUrl, aParam, 1, cModel, lCte, .T., lMDfe, lTMS,lUsaColab),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
							EndIf
							@ aPosObj[2,1],aPosObj[2,4]-200 BUTTON oBtn4 PROMPT STR0115  		ACTION (Bt3NFeMnt(cIdEnt,aListBox[ oListBox:nAT,2 ],2,lUsaColab,cModel)) OF oDlg PIXEL SIZE 035,011 //"Schema"
							ACTIVATE MSDIALOG oDlg
						EndIf
					Endif
				EndIf
			EndIf
		Else
			Aviso("SPED",STR0021,{STR0114},3)	//"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
		EndIf
	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
	EndIf

Return aListBox

/*/{Protheus.doc} getListBox
description
Retorna Array com as notas validada pela SEFAZ. Apresentando
seu status visual por cores
@type function
@version  
@author Valdemir Jose
@since 22/10/2021
@param cIdEnt, character, param_description
@param cUrl, character, param_description
@param aParam, array, param_description
@param nTpMonitor, numeric, param_description
@param cModelo, character, param_description
@param lCte, logical, param_description
@param lMsg, logical, param_description
@param lMDfe, logical, param_description
@param lTMS, logical, param_description
@param lUsaColab, logical, param_description
@param lICC, logical, param_description
@return variant, return_description
/*/
static function getListBox(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, lMsg, lMDfe, lTMS,lUsaColab, lICC)

	local aLote          := {}
	local aListBox       := {}
	local aRetorno       := {}
	local cId            := ""
	local cProtocolo     := ""
	local cRetCodNfe     := ""
	local cAviso         := ""
	local cSerie         := ""
	local cNota          := ""

	local nAmbiente      := ""
	local nModalidade    := ""
	local cRecomendacao  := ""
	local cTempoDeEspera := ""
	local nTempoMedioSef := ""
	local nX             := 0


	local oOk				:= LoadBitMap(GetResources(), "ENABLE")
	local oNo				:= LoadBitMap(GetResources(), "DISABLE")

	local cTenConsInd		:= ""
	local cObsConsInd		:= ""

	default lUsaColab		:= .F.
	default lMsg			:= .T.
	default lCte			:= .F.
	default lMDfe			:= .F.
	default cModelo			:= IIf(lCte,"57",IIf(lMDfe,"58","55"))
	default lTMS			:= .F.
	default lICC			:= .F.

	if cModelo <> "65"
		lUsaColab := UsaColaboracao( IIf(lCte,"2",IIf(lMDFe,"5","1")) )
	endif

	if 	lUsaColab
		//processa monitoramento por tempo
		aRetorno := colNfeMonProc( aParam, nTpMonitor, cModelo, lCte, @cAviso, lMDfe, lTMS ,lUsaColab, lICC )
	else
		//processa monitoramento
		//aRetorno := procMntDoc(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, @cAviso)
		aRetorno := procMonitorDoc(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, @cAviso ,lUsaColab)
	endif

	if empty(cAviso)

		for nX := 1 to len(aRetorno)

			cId				:= aRetorno[nX][1]
			cSerie			:= aRetorno[nX][2]
			cNota			:= aRetorno[nX][3]
			cProtocolo		:= aRetorno[nX][4]
			cRetCodNfe		:= aRetorno[nX][5]
			nAmbiente		:= aRetorno[nX][7]
			nModalidade	:= aRetorno[nX][8]
			cRecomendacao	:= aRetorno[nX][9]
			cTempoDeEspera:= aRetorno[nX][10]
			nTempoMedioSef:= aRetorno[nX][11]
			aLote			:= aRetorno[nX][12]
			cTenConsInd		:= aRetorno[nX][15]

			if 	Len(aRetorno[nx]) >= 16 // Se TC 2.0 aRetorno[nx] terá até 15 posições
				cObsConsInd		:= aRetorno[nX][16]
			endif

			aadd(aListBox,{	iif(empty(cProtocolo) .Or.  cRetCodNfe $ RetCodDene(),oNo,oOk),;
				cId,;
				if(nAmbiente == 1,STR0056,STR0057),; //"Produção"###"Homologação"
				IIF(lUsaColab,iif(nModalidade==1,STR0058,STR0059),IIf(nModalidade ==1 .Or. nModalidade == 4 .Or. nModalidade == 6,STR0058,STR0059)),; //"Normal"###"Contingência"
				cProtocolo,;
					cRecomendacao,;
					cTempoDeEspera,;
					nTempoMedioSef,;
					aLote,;
					cTenConsInd,;
					cObsConsInd;
					})
			next

			if Empty(aListBox) .and. lMsg .and. !lCte
				Aviso("SPED","Não existe dados a ser apresentado",{"OK"})
			endIf

		elseif !lCTe .And. lMsg
			aviso("SPED", cAviso,{STR0114},3)
		endif

		return aListBox


/*/{Protheus.doc} IsReady
description
@type function
@version  
@author Valdemir Jose
@since 22/10/2021
@param cURL, character, param_description
@param nTipo, numeric, param_description
@param lHelp, logical, param_description
@param lUsaColab, logical, param_description
@return variant, return_description
/*/
Static Function IsReady(cURL,nTipo,lHelp,lUsaColab)

	Local nX       := 0
	Local cHelp    := ""
	local cError	:= ""
	Local oWS
	Local lRetorno := .F.
	DEFAULT nTipo := 1
	DEFAULT lHelp := .F.
	DEFAULT lUsaColab := .F.
	if !lUsaColab
		If FunName() <> "LOJA701"
			If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
				RecLock("SX6",.T.)
				SX6->X6_FIL     := xFilial( "SX6" )
				SX6->X6_VAR     := "MV_SPEDURL"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "URL SPED NFe"
				MsUnLock()
				PutMV("MV_SPEDURL",cURL)
			EndIf
			SuperGetMv() //Limpa o cache de parametros - nao retirar
			DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
		Else
			If !Empty(cURL) .And. !PutMV("MV_NFCEURL",cURL)
				RecLock("SX6",.T.)
				SX6->X6_FIL     := xFilial( "SX6" )
				SX6->X6_VAR     := "MV_NFCEURL"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "URL de comunicação com TSS"
				MsUnLock()
				PutMV("MV_NFCEURL",cURL)
			EndIf
			SuperGetMv() //Limpa o cache de parametros - nao retirar
			DEFAULT cURL      := PadR(GetNewPar("MV_NFCEURL","http://"),250)
		EndIf
		//Verifica se o servidor da Totvs esta no ar
		if(isConnTSS(@cError))
			lRetorno := .T.
		Else
			If lHelp
				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
			EndIf
			lRetorno := .F.
		EndIf


		//Verifica se Há Certificado configurado
		If nTipo <> 1 .And. lRetorno

			if( isCfgReady(, @cError) )
				lRetorno := .T.
			else
				If nTipo == 3
					cHelp := cError

					If lHelp .And. !"003" $ cHelp
						Aviso("SPED",cHelp,{STR0114},3)
						lRetorno := .F.

					EndIf

				Else
					lRetorno := .F.

				EndIf
			endif

		EndIf

		//Verifica Validade do Certificado
		If nTipo == 2 .And. lRetorno
			isValidCert(, @cError)
		EndIf
	else
		lRetorno := ColCheckUpd()
		if lHelp .And. !lRetorno .And. !lAuto
			MsgInfo("UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0")
		endif
	endif

Return(lRetorno)


/*/{Protheus.doc} GetIdEnt
description
@type function
@version  
@author Valdemir Jose
@since 21/10/2021
@param cError, character, param_description
@return variant, return_description
/*/
Static Function GetIdEnt(lUsaColab)

	local cIdEnt := ""
	local cError := ""

	Default lUsaColab := .F.

	If !lUsaColab

		cIdEnt := getCfgEntidade(@cError)

		if(empty(cIdEnt))
			Aviso("SPED", cError, {"OK"}, 3)

		endif

	else
		if !( ColCheckUpd() )
			Aviso("SPED","UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0",{"OK"},3)
		else
			cIdEnt := "000000"
		endif
	endIf

Return(cIdEnt)




static function procMntDoc(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, cAviso ,lUsaColab)

	local aRetorno			:= {}
	local aLote			:= {}

	local cId				:= ""
	local cSerie 			:= ""
	local cNota			:= ""
	local cProtocolo		:= ""
	local cRetCodNfe		:= ""
	local cMsgRetNfe		:= ""
	local cRecomendacao	:= ""
	local cTempoDeEspera	:= ""

	local lOk				:= .F.
	local lUpd				:= .F.

	local nX				:= 0
	local nY				:= 0
	local nTamF2_DOC		:= tamSX3("F2_DOC")[1]
	local nAmbiente		:= 0
	local nModalidade		:= 0
	local nTempoMedioSef	:= 0
	local nCount			:= 0

	local oLote				:= nil
	local oWs				:= nil
	local lSdoc			:= TamSx3("F2_SERIE")[1] == 14

	local cTenConsInd		:= ""
	local cObsConsInd		:= ""

	private oRetorno		:= nil
	private CERROR          := ""

	default cModelo		:= "55"
	default cAviso			:= ""
	default lCte			:= .F.
	default lUsaColab		:= UsaColaboracao("1")

	oWS:= wsNfeSBra():new()
	oWS:cUserToken	:= "TOTVS"
	oWS:cId_ent		:= cIdEnt
	oWS:_url			:= AllTrim(cUrl)+"/NFeSBRA.apw"

	if cModelo == "65"
		if !empty( getNewPar("MV_NFCEURL","") )
			cUrl := padr(getNewPar("MV_NFCEURL","http://"),250)
		endif

		oWS:cModelo   := cModelo
	endif

	//Monitor por Range de notas
	if nTpMonitor == 1

		If lSdoc
			oWS:cIdInicial    := aParam[01]+aParam[02]
			oWS:cIdFinal      := aParam[Len(aParam)]+aParam[03]
		Else
			oWS:cIdInicial    := aParam[01]+aParam[02]
			oWS:cIdFinal      := aParam[01]+aParam[03]
		EndIf

		lOk := oWS:monitorFaixa()

		oRetorno := oWS:oWsMonitorFaixaResult:oWSMonitorNfe

		//monitor por lote de Id
	elseif nTpMonitor == 2

		oWS:oWSLoteDocs:oWSDocsId := nfeSBra_arrayOfDocId():new()

		for nX := 1 to len(aParam)
			aadd(oWS:oWSLoteDocs:oWSDocsId:oWSDocId, nfeSBra_docId():new())
			oWS:oWSLoteDocs:oWSDocsId:oWSDocId[nX]:cId := aParam[nX][1]
		next

		lOk := oWS:monitorDocumentos()

		oRetorno := oWS:oWSMonitorDocumentosResult:oWSMonitorNfe

		//monitor por tempo
	else
		if valType(aParam[01]) == "N"
			oWS:nIntervalo := max((aParam[01]),60)
		else
			oWS:nIntervalo := max(val(aParam[01]),60)
		endIf

		lOk := oWS:monitorTempo()

		oRetorno := oWS:oWsMonitorTempoResult:oWSMonitorNfe
	EndIf

	if lOk

		for nX := 1 to len(oRetorno)

			cId				:= oRetorno[nX]:cId
			cSerie			:= If (lSdoc,substr(oRetorno[nX]:cId, 1, 14),substr(oRetorno[nX]:cId, 1, 3))
			cNota			:= If (lSdoc,padr( substr(oRetorno[nX]:cId, 15 ), nTamF2_DOC ),padr( substr(oRetorno[nX]:cId, 4 ), nTamF2_DOC ))
			cProtocolo		:= oRetorno[nX]:cProtocolo
			nAmbiente		:= oRetorno[nX]:nAmbiente
			nModalidade		:= oRetorno[nX]:nModalidade
			cRecomendacao	:= PadR(oRetorno[nX]:cRecomendacao,250)
			cTempoDeEspera	:= oRetorno[nX]:cTempoDeEspera
			nTempoMedioSef	:= oRetorno[nX]:nTempoMedioSef
			cRetCodNfe		:= ""
			cMsgRetNfe		:= ""
			lUpd			:= .F.

			If (oRetorno[nX]:OWSWS01ConsumoIndevido) <> Nil
				cObsConsInd		:= oRetorno[nX]:OWSWS01ConsumoIndevido:COBSERVACAO
				cTenConsInd		:= oRetorno[nX]:OWSWS01ConsumoIndevido:CTENTATIVAS
			Else
				cObsConsInd		:= cTenConsInd	:= ""
			EndIf

			//obtem dados dos lotes transmitidos para o documento
			aLote := {}
			if type("oRetorno["+cValToChar(nX)+"]:OWSErro:OWSLoteNfe")<>"U"

				oLote := oRetorno[nX]:OWSErro:OWSLoteNfe
				lUpd := .T.

				for nY := 1 to len( oLote )
					if oLote[nY]:nLote<>0
						aadd(aLote,{	oLote[nY]:nLote,;
							oLote[nY]:dDataLote,;
							oLote[nY]:cHoraLote,;
							oLote[nY]:nReciboSefaz,;
							oLote[nY]:cCodEnvLote,;
							padr(oLote[nY]:cMsgEnvLote,50),;
							oLote[nY]:cCodRetRecibo,;
							padr(oLote[nY]:cMsgRetRecibo,50),;
							iif(SubStr(cRecomendacao,1,3)$"003-004-009-025","",oLote[nY]:cCodRetNfe),;
							oLote[nY]:cMsgRetNfe;
							})

						//Ponto de entrada para obter as informações que serão apresentadas no monitor faixa.
						If ExistBlock("FISMNTNFE")
							ExecBlock("FISMNTNFE",.f.,.f.,{cId,aLote})
						Endif

					EndIf

				Next nY

				cRetCodNfe	:= if( len(aLote) > 0, aTail(aLote)[9], "")
				cMsgRetNfe	:= if( len(aLote) > 0, aTail(aLote)[10], "")

				oLote := nil

			endif

			//dados para atualização da base
			aadd(aRetorno, {	cId,;
				cSerie,;
				cNota,;
				cProtocolo,;
				cRetCodNfe,;
				cMsgRetNfe,;
				nAmbiente,;
				nModalidade,;
				cRecomendacao,;
				cTempoDeEspera,;
				nTempomedioSef,;
				aLote,;
				lUpd,;
				.F.,;
				cTenConsInd,;
				cObsConsInd;
				})
		next

		if len(aRetorno) > 0
			//busca informações complemetares para atualização da base atraves do metodo retornaNotas

			nCount:= Len(getXmlNfe(cIdEnt,@aRetorno,if(lCTE,"57","") ))

			while nCount > 0 .and. nCount <	 len(aRetorno)
				If nCount > 0 .and. nCount < len(aRetorno)
					//atualiza a base e retorno
					monitorUpd(cIdEnt, aRetorno, lCte)
				EndIf
				nCount+= getXmlNfe(cIdEnt,@aRetorno,if(lCTE,"57","") )
			EndDo

			//atualiza a base e retorno
			monitorUpd(cIdEnt, aRetorno, lCte)
		endif

	else
		cAviso := iif( empty(getWscError(3)),getWscError(1),getWscError(3) )
	endif

	FreeObj( oWs )
	oWs	:= nil

return aRetorno


/*/{Protheus.doc} monitorUpd
description
Atualiza status do monitor e tabelas relacionadas
@type function
@version  
@author Valdemir Jose
@since 22/10/2021
@param cIdEnt, character, param_description
@param aRetorno, array, param_description
@param lCTe, logical, param_description
@param lMDfe, logical, param_description
@param lUsaColab, logical, param_description
@param lICC, logical, param_description
@return variant, return_description
/*/
static Function monitorUpd(cIdEnt, aRetorno, lCTe, lMDfe, lUsaColab, lICC)

	local cChaveF3			:= ""
	local cChaveFT			:= ""
	local cId				:= ""
	local cSerie			:= ""
	local cNota				:= ""
	local nAmbiente			:= 0
	local cProtocolo		:= ""
	local cCodRetNfe		:= ""
	local cMsgRetNfe		:= ""
	local cXml				:= ""
	local cDpecProtocolo	:= ""
	local cDpecXml			:= ""
	local cHautNfe			:= ""
	Local cTextInut			:= GetNewPar("MV_TXTINUT","")
	Local cFlag				:= ""
	local cRecomendacao		:= ""
	local cEspecieNfe 		:= ""
	Local cCODAnt    		:= ""
	Local cMsgAnt			:= ""
	Local aArea		 		:= {}
	Local lTMSCTe  	 		:= IntTms()
	local dDautNfe	 		:= SToD("  /  /  ")
	Local cSitCTE	 		:= ""
	local lUpd		 		:= .F.
	Local lCTECan	 		:= GetNewPar( "MV_CTECAN", .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
	local lMVGfe	 		:= GetNewPar( "MV_INTGFE", .F. ) // Se tem integração com o GFE
	local nModalidade		:= 0
	local nX		 		:= 0
	Local nRecnoSF1	 		:= 0
	local aArrayDel	 		:= {}
	local cMV_INTTAF 		:= GetNewPar( 'MV_INTTAF', 'N' ) //Verifica se o parâmetro da integração online esta como 'S'
	local lTafKey    		:= SFT->( FieldPos( 'FT_TAFKEY' ) ) > 0
	local lIntegTaf  		:= ( cMV_INTTAF == 'S' .and. lTafKey )
	local lTAFVldAmb 		:= FindFunction( 'TAFVldAmb' ) .And. TAFVldAmb( '1' ) .And. FindFunction( 'DocFisxTAF' ) //Valida se o cliente habilitou a integração nativa Protheus x TAF
	Local lIntegM461 		:= ExistFunc("MATI461EAI") .And. ( FWHasEAI("MATA410B",.T.,,.T.) .Or. FWHasEAI("MATA461",.T.,,.T.) )	//Verifica se o envio da mensagem única DOCUMENTTRACEABILITYORDER ou INVOICE está configurado
	Local cChvF2Ant  		:= ""
	local lChaveEpec
	Local cPriCTe	 		:= ""
	Local cUltCTe	 		:= ""
	Local cSerCTe	 		:= ""
	local cCliFor	 		:= ""
	local cLoja 	 		:= ""
	local lSeekSF3			:= .F.

	Default lCTe		:= .F.
	Default lMDfe		:= .F.
	Default lUsaColab	:= .F.
	Default lICC	 	:= .F.
	default cIdEnt		:= if(lUsaColab, "000000", getCfgEntidade())

	For nX := 1 To Len(aRetorno)

		//dados do monitor
		cId				:= aRetorno[nX][1]
		cSerie			:= aRetorno[nX][2]
		cNota			:= aRetorno[nX][3]
		cProtocolo		:= aRetorno[nX][4]
		cCodRetNfe		:= aRetorno[nX][5]
		cMsgRetNfe		:= aRetorno[nX][6]
		nAmbiente 		:= aRetorno[nX][7]
		nModalidade		:= aRetorno[nX][8]
		cRecomendacao	:= aRetorno[nX][9]
		lUpd			:= aRetorno[nX][13]
		cXml			:= aTail(aRetorno[nX])[2]
		cDpecProtocolo  := aTail(aRetorno[nX])[3]
		cDpecXml		:= aTail(aRetorno[nX])[4]
		cHautNfe		:= aTail(aRetorno[nX])[5]
		dDautNfe		:= if( !empty(aTail(aRetorno[nX])[6]), aTail(aRetorno[nX])[6], SToD("  /  /  ") )
		cEspecieNfe		:= ""
		cCliFor			:= ""
		cLoja			:= ""
		lSeekSF3		:= .F.

		//Verifica se a chave foi autorizada em contingencia
		lChaveEpec  := !empty(aRetorno[nX][12]) .and. aScan(aRetorno[nX][12], {|x| x[09] $ "136" } ) > 0

		nSFTRecno:= SFT->(RECNO())
		nSFTIndex:= SFT->(IndexOrd())

		if lUpd
			//-- Atualizar status dos MDF-e (SIGATMS)
			If lMDfe .And. lUsaColab .And. lTMSCTe
				If lICC
					TME73UpdIC(aRetorno)
				Else
					TME73Upd(cNota,cSerie,cCodRetNfe,Substr(cRecomendacao,1,3),cProtocolo,nAmbiente,cRecomendacao,IIF(Empty(cCodRetNfe),"",Substr(cCodRetNfe+" - "+cMsgRetNfe,1,150)),nModalidade)
				EndIf
				Loop
			EndIf
			SF3->(dbSetOrder(5))
			If SF3->(MsSeek(xFilial("SF3")+ cId,.T.))

				While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))== AllTrim(cId)
					nSF3Recno:= SF3->(RECNO())
					nSF3Index:= SF3->(IndexOrd())
					lSeekSF3 := .T.
					If SF3->( (Left(F3_CFO,1)>="5" .Or. (Left(F3_CFO,1)<"5" .And. F3_FORMUL=="S")) .And. FieldPos("F3_CODRSEF")<>0)
						RecLock("SF3")
						cCODAnt:= SF3->F3_CODRSEF
						If SF3->(FieldPos("F3_DESCRET"))> 0
							cMsgAnt:= SF3->F3_DESCRET
						EndIf

						SF3->F3_CODRSEF:= cCodRetNfe
						// -- Para NFC-e não existe o parametro MV_CANCNFE e o campo F3_CODRSEF fica em branco para venda autorizada, por esse motivo caso seja NFC-e e não seja status final o campo F3_CODRSEF não é atualizado.
						If	(cCODAnt == "100" .and.  SuperGetMv("MV_CANCNFE",.F.,.F.) .OR. AllTrim(SF3->F3_ESPECIE) == "NFCE" ) .and. !cCodRetNfe $ "100,101,102,124,136,135,155"+ RetCodDene()
							SF3->F3_CODRSEF:= cCODAnt
							cMsgRetNfe:= cMsgAnt
						ENDIF

						// Grava protocolo - chamado TRBOLF(Fiscal)
						If SF3->(FieldPos("F3_PROTOC")) > 0 .and. !Empty(cProtocolo)
							SF3->F3_PROTOC:= cProtocolo
						EndIf
						//SE FOR UMA NOTA DENEGADA, INFORMA NO CAMPO F3_OBSERV
						If cCodRetNfe $ RetCodDene()
							SF3->F3_OBSERV := "NF DENEGADA"
						EndIf
						//SE FOR INUTILIZAÇÃO ALTERA NOS LIVROS FISCAIS
						If !Empty(cTextInut)
							If !empty(cMsgRetNfe) .And. (Left(cCodRetNfe,3) == '102')//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
								SF3->F3_OBSERV := ALLTRIM(cTextInut)
							EndIf
						EndIF

						If SF3->F3_FORMUL == "S"
							cTipoMov :=	"E"
						Else
							cTipoMov := "S"
						EndIf

						// apenas flaga a SF3 com status monitorada quando possuir retorno da sefaz OU falha no Schema.
						if ( (!empty(cCodRetNfe) .and. cCodRetNfe <> "103") .or. "029" $ cRecomendacao ) .and. SF3->(FieldPos("F3_CODRET"))> 0 .and. SF3->(FieldPos("F3_DESCRET"))> 0
							SF3->F3_CODRET := "M"
							SF3->F3_DESCRET:= cMsgRetNfe
						endif

						//apenas para notas de entradas canceladas formulario proprio "S"
						If !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)<"5" //Alimenta Chave da NFe Cancelada na F3 ao consultar o monitorfaixa
							If !Empty(cXml) .And. !Empty(cProtocolo) .and. cCodRetNfe <> "102" // Inserida verificação do protocolo, antes de gravar a Chave.
								SF3->F3_CHVNFE  := SubStr(NfeIdSPED(cXML,"Id"),4)
							EndIf
						EndIf

						SFT->(dbSetOrder(1))
						SFT->(Dbseek(xFilial("SFT")+cTipoMov+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA))

						While !SFT->(Eof()) .And. SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == xFilial("SFT")+cTipoMov+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
							If !Empty(cTextInut)
								If Left(cCodRetNfe,3) == '102'//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
									RecLock("SFT")
									SFT->FT_OBSERV := ALLTRIM(cTextInut)
									SFT->(MsUnlock())
								EndIf
							EndIF
							SFT->(dbSkip())
						EndDo
						MsUnlock()

						If Alltrim(SF3->F3_ESPECIE) == "CTE" .And. lTMSCTe
							aArea := GetArea()
							If lUsaColab
								//-- Atualizacao dados CTE - TOTVS Colaboracao 2.0
								DT6->(dbSetOrder(1))
								If	DT6->(MsSeek(xFilial("DT6")+cFilAnt+PadR(SF3->F3_NFISCAL,Len(DT6->DT6_DOC))+SF3->F3_SERIE))
									cSitCTE := DT6->DT6_SITCTE //-- 0=Nao Transmitido;1=Aguardando...;2=Autorizado o uso do Cte.;3=Nao Autorizado;4=Autorizado Contingencia
									If Left(cCodRetNfe,3) == '100'
										cSitCTE := StrZero(2,Len(DT6->DT6_SITCTE))
									ElseIf Left(cCodRetNfe,3) >= '200'
										cSitCTE := StrZero(3,Len(DT6->DT6_SITCTE))
									ElseIf Left(cCodRetNfe,3) == '100' .And. nModalidade == 5
										cSitCTE := StrZero(4,Len(DT6->DT6_SITCTE))
									EndIf
									RecLock("DT6",.F.)
									DT6->DT6_RETCTE := cRecomendacao
									If !Empty(cCodRetNfe)
										DT6->DT6_AMBIEN := Val(SubStr(ColGetPar("MV_AMBCTE","2"),1,1))
										DT6->DT6_SITCTE := cSitCTE
										DT6->DT6_IDRCTE := cCodRetNfe
										DT6->DT6_PROCTE := cProtocolo
										DT6->DT6_CHVCTE := SubStr(NfeIdSPED(cXML,"Id"),4)
									EndIf
									MsUnlock()
								EndIf
							Else
								//-- Atualizacao dados CTE - TSS
								cSerCTe := SF3->F3_SERIE
								If Empty(cPriCTe)
									cPriCTe := SF3->F3_NFISCAL
								EndIf
								cUltCTe := SF3->F3_NFISCAL
							EndIf
							RestArea(aArea)
						Endif

						//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ
						If lCTE .And. lCTECan .And. !Empty(SF3->F3_DTCANC)
							DT6->(dbSetOrder(1))
							If	DT6->(MsSeek(xFilial('DT6')+cFilAnt+PadR(SF3->F3_NFISCAL,Len(DT6->DT6_DOC))+SF3->F3_SERIE)) .And. DT6->DT6_STATUS$"B/D"
								RecLock('DT6',.F.)
								If SF3->F3_CODRSEF == '101'
									DT6->DT6_STATUS := 'C'  //Cancelamento SEFAZ Autorizado
								Else
									DT6->DT6_STATUS := 'D'  //Cancelamento SEFAZ Nao Autorizado
								EndIf
								MsUnLock()

								//Exclui o documento automaticamente caso o parâmetro MV_CTECAN e MV_CANAUTO esteja habilitado, e se for TOTVS Colab 2.0
								If lCTECan .And. SF3->F3_CODRSEF == '101' .And. lUsaColab
									Aadd(aArrayDel , { DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE, "", .T., DT6->DT6_SITCTE })
									TMSA200Exc(aArrayDel, DT6->DT6_LOTNFC, .F., .F., )
								EndIf
							EndIf
						EndIf

					EndIf

					If lUsaColab
						If FindFunction ("AvbeGrvCte") .And. AliasInDic("DL5") .And. SF3->F3_CODRSEF == '101'   //Cancelamento
							AvbeGrvCte( cFilAnt, PadR(SF3->F3_NFISCAL,Len(DT6->DT6_DOC)), SF3->F3_SERIE,,,'101',,,)
						ElseIf FindFunction ("AvbeGrvCte") .And. AliasInDic("DL5")
							AvbeGrvCte( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE,DT6->DT6_DATEMI,DT6->DT6_HOREMI,DT6->DT6_IDRCTE,DT6->DT6_DOCTMS, DT6->DT6_CLIDEV, DT6->DT6_LOJDEV)
						EndIf
					EndIf

					SF3->(dbSkip())
				End
				//-- Faz chamada da rotina que exporta para Datasul
				SF3->(dbSetOrder(5))
				If SF3->(MsSeek(xFilial("SF3")+ cId,.T.))
					if FindFunction("TMSAE76")
						TMSAE76()
					endif
				EndIf
				SFT->(DBSETORDER(nSFTIndex))
				SFT->(DBGOTO(nSFTRecno))
				SF3->(DBSETORDER(nSF3Index))
				SF3->(DBGOTO(nSF3Recno))
			EndIf

			//Nota de saida
			dbSelectArea("SF2")
			dbSetOrder(1)
			If SF2->(MsSeek(xFilial("SF2")+ cNota + cSerie,.T.))
				cEspecieNfe	:= SF2->F2_ESPECIE
				cFlag		:= SF2->F2_FIMP
				cCliFor		:= SF2->F2_CLIENTE
				cLoja		:= SF2->F2_LOJA
				IF lUsacolab .AND. SuperGetMv("MV_CANCNFE",.F.,.F.)
					IF "005" $ cRecomendacao .OR. "009" $ cRecomendacao
						RecLock("SF2")
						SF2->F2_STATUS := '025' //Legenda do job do faturamento para cancelamento e inutilização: Em processamento
						MsUnlock()
					ELSEIF "026"     $ cRecomendacao
						RecLock("SF2")
						SF2->F2_STATUS := '026'//Legenda do job do faturamento para cancelamento e inutilização: Não autorizado
						MsUnlock()
					ENDIF
				ENDIF
				if  !Empty(cCodRetNfe) .And. cCodRetNfe $ "100,101,102,124,136"
					/*	Legenda fica verde após consultar a autorização no monitor
						(não somente após consulta chave ou impressão do danfe)
						Alteração feita em 23/09/16
					*/
					cFlag := "S" // Autorizada
				elseIf  !Empty(cCodRetNfe) .And. !cCodRetNfe $ "100,101,102,124,136"+ RetCodDene()
					cFlag := "N" // Não Autorizada
				elseIf !Empty(cCodRetNfe) .And. cCodRetNfe $ RetCodDene()	 					// Atualizar a Leganda para Nf-e denegada
					cFlag := "D" // Denegada
					//else //retirada valição para permitir que cFlag continue como N ao consultar o monitor para uma nota com erro de schema
					//cFlag := "T" // Transmitida
				endIf

				If (SF2->(FieldPos("F2_HAUTNFE"))<>0 .And. SF2->(FieldPos("F2_DAUTNFE"))<>0) .And. (SF2->(FieldPos("F2_CHVNFE"))>0 .And. !Empty(cFlag))
//				If (SF2->(FieldPos("F2_HAUTNFE"))<>0 .And. SF2->(FieldPos("F2_DAUTNFE"))<>0) .And. (Empty(SF2->F2_HAUTNFE) .Or. Empty(SF2->F2_DAUTNFE) .Or. (SF2->(FieldPos("F2_CHVNFE"))>0 .And. Empty(SF2->F2_CHVNFE))) .And. !Empty(cFlag)
					RecLock("SF2")
					SF2->F2_HAUTNFE	:= substr(cHautNfe,1,5)      //Grava a hora de autorização da nota
					SF2->F2_DAUTNFE	:= dDautNfe   //Grava a data de autorização da nota
					SF2->F2_FIMP := cFlag

					If Empty(SF2->F2_HORA)
						RecLock("SF2")
						SF2->F2_HORA := cHautNfe
						MsUnlock()
					EndIf

					MsUnlock()
				EndIf

				If !Empty(cXml) .And. ( !Empty(cProtocolo) .OR. cCodRetNfe $ RetCodDene() )// Inserida verificação do protocolo , antes de gravar a Chave. Para nota denegada deve gravar a chave
					cChvF2Ant := SF2->F2_CHVNFE

					RecLock("SF2")
					SF2->F2_CHVNFE  := RetChave(cXML)
					MsUnlock()

					If lIntegM461 .And. cChvF2Ant <> SF2->F2_CHVNFE
						//Chama Integração EAI - INVOICE >= 3.009
						STARTJOB("MATI461EAI", GetEnvServer(),.F., cEmpant,cFilAnt,SF2->F2_DOC, SF2->F2_SERIE)
					Endif

					// Grava quando a nota for Transferencia entre filiais
					IF !EMPTY (SF2->F2_FORDES)
						SF1->(dbSetOrder(1))
						If SF1->(MsSeek(SF2->F2_FILDEST+SF2->F2_DOC+SF2->f2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES+SF2->F2_FORMDES))
							If EMPTY(SF1->F1_CHVNFE)
								RecLock("SF1",.F.)
								SF1->F1_CHVNFE := SF2->F2_CHVNFE
								MsUnlock()
							EndIf
						Endif
					EndiF
				ElseIf !Empty(cXml) .And. Empty(cProtocolo) .And. (nModalidade = 7 .or. lChaveEpec) // Contingencia FD-SA
					RecLock("SF2")
					SF2->F2_CHVNFE  := RetChave(cXML)
					MsUnlock()
				EndIf
				// Atualização dos campos da Tabela GFE
				if FindFunction("GFECHVNFE") .and. lMVGfe  // Integração com o GFE
					if  SF2->F2_TIPO $ "D|B"    // Documento com tipo de devolução ou "Utilizar Fornecedor"
						dbSelectArea("SA2")
						dbSetOrder(1)
						If SA2->(MsSeek(xFilial("SA2")+ SF2->F2_CLIENTE + SF2->F2_LOJA,.T.))
							GFECHVNFE(xFilial("SF2"),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_TIPO,SA2->A2_CGC,SA2->A2_COD,SA2->A2_LOJA,SF2->F2_CHVNFE,SF2->F2_FIMP, "S")
						EndIf
					else
						dbSelectArea("SA1")
						dbSetOrder(1)
						If SA1->(MsSeek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA,.T.))
							GFECHVNFE(xFilial("SF2"),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_TIPO,SA1->A1_CGC,SA1->A1_COD,SA1->A1_LOJA,SF2->F2_CHVNFE,SF2->F2_FIMP, "S")
						Endif
					endif
				endif

				//Atualizo SF3
				SF3->(dbSetOrder(4))
				cChave := xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE
				If SF3->(MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE,.T.))
					Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
						If (Val(SF3->F3_CFO) >= 5000 .Or. SF3->F3_FORMUL=='S')
							RecLock("SF3",.F.)
							If !Empty(cXml) .And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene() )  // Inserida verificação do protocolo, antes de gravar a Chave. Para nota denegada deve gravar a chave.
								If EMPTY(SF3->F3_CHVNFE)
									SF3->F3_CHVNFE  := SubStr(NfeIdSPED(cXML,"Id"),4)
								EndIf
							EndIf
						EndIf
						MsUnLock()
						SF3->(dbSkip())
					EndDo
				EndIf
				//Atualizo SF3
				// Grava quando a nota for Transferencia entre filiais
				IF SF1->(!EOF()) .And. !EMPTY (SF2->F2_FORDES)
					SF3->(dbSetOrder(4))
					cChave := SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
					If SF3->(MsSeek(SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.T.))
						Do While cChave == SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
							RecLock("SF3",.F.)
							If !Empty(cXml).And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave. Para nota denegada deve gravar a chave.
								If EMPTY(SF3->F3_CHVNFE)
									SF3->F3_CHVNFE  := SF2->F2_CHVNFE
								EndIf
							EndIf
							MsUnLock()
							SF3->(dbSkip())
						EndDo
					EndIf
				EndIf

				//Atualizo SFT
				SFT->(dbSetOrder(1))
				cChave := xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
				If SFT->(MsSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
					Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA ;
							.And. (Val(SFT->FT_CFOP) >= 5000 .Or. SFT->FT_FORMUL=='S') .And. !SFT->(Eof())
						RecLock("SFT",.F.)
						If !Empty(cXml).And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave.
							if cCodRetNfe <> "102"
								SFT->FT_CHVNFE  := RetChave(cXML)
							endif
						EndIf
						MsUnLock()

						//-----------------------------------------------------------------------------------------
						//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
						//-----------------------------------------------------------------------------------------
						if lIntegTaf .and. !empty( SFT->FT_CHVNFE )
							FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
						endif

						SFT->(dbSkip())
					EndDo
				EndIf

				//Atualizo SFT
				// Grava quando a nota for Transferencia entre filiais
				IF SF1->(!EOF()) .And. !EMPTY (SF2->F2_FORDES)
					SFT->(dbSetOrder(1))
					cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
					If SFT->(MsSeek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
						Do While cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
							RecLock("SFT",.F.)
							If !Empty(cXml).And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave.
								If EMPTY(SFT->FT_CHVNFE)
									SFT->FT_CHVNFE  := SF2->F2_CHVNFE
								Endif
							EndIf
							MsUnLock()

							//-----------------------------------------------------------------------------------------
							//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
							//-----------------------------------------------------------------------------------------
							if lIntegTaf .and. !empty( SFT->FT_CHVNFE )
								FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
							endif

							SFT->(dbSkip())
						EndDo
					EndIf
				EndIf
			ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)>="5" //Alimenta Chave da NFe Cancelada na F3/FT ao consultar o monitorfaixa
				SF3->(dbSetOrder(4))
				cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
				cChaveFT := xFilial("SFT")+"S"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
				SF3->(dbSeek(cChaveF3,.T.))
				While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
					RecLock("SF3",.F.)
					If !Empty(cXml) .And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene()) // Inserida verificação do protocolo, antes de gravar a Chave.
						If !(Left(cCodRetNfe,3) == '102')//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
							//Tratamento para o XML do Colaboração que retorna como evento.
							SF3->F3_CHVNFE  := RetChave(cXML)
						EndIf
					EndIf
					SF3->(MsUnLock())
					SF3->(dbSkip())
				EndDo

				SFT->(dbSetOrder(1))
				SFT->(dbSeek(cChaveFT,.T.))
				While !SFT->(Eof()) .And. xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
					RecLock("SFT",.F.)
					If !Empty(cXml).And. ( !Empty(cProtocolo) .Or. cCodRetNfe $ RetCodDene()) // Inserida verificação do protocolo, antes de gravar a Chave.
						If !(Left(cCodRetNfe,3) == '102')//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
							//Tratamento para o XML do Colaboração que retorna como evento.
							SFT->FT_CHVNFE  := RetChave(cXML)
						EndIf
					EndIf
					SFT->(MsUnLock())

					//-----------------------------------------------------------------------------------------
					//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
					//-----------------------------------------------------------------------------------------
					if lIntegTaf .and. !empty( SFT->FT_CHVNFE )
						FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
					endif

					SFT->(dbSkip())
				EndDo
			EndIf

			//Nota de entrada
			dbSelectArea("SF1")
			dbSetOrder(1)
			if lSeekSF3 .and. nSF3Recno > 0
				SF3->(dbSetOrder(nSF3Index))
				SF3->(dbGoto(nSF3Recno))
			endif
			If SF1->(MsSeek(xFilial("SF1")+ cNota + cSerie,.T.)) //.And. nLastXml > 0 .And. !Empty(aXml)
				nRecnoSF1 := 0
				While !SF1->(Eof()) .And. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE == xFilial("SF1")+cNota+cSerie
					If SF1->F1_FORMUL == "S"
						//If SF1->(FieldPos("F1_HORA"))<>0 .And. (Empty(SF1->F1_HORA) .OR. Empty(SF1->F1_NFELETR) .Or. Empty(SF1->F1_EMINFE) .Or.Empty(SF1->F1_HORNFE) .Or. Empty(SF1->F1_CODNFE) .Or. (SF1->(FieldPos("F1_CHVNFE"))>0 .And. Empty(SF1->F1_CHVNFE)))
						cEspecieNfe	:= SF1->F1_ESPECIE
						cCliFor		:= SF1->F1_FORNECE
						cLoja		:= SF1->F1_LOJA

						If (SF1->(FieldPos("F1_HAUTNFE")) <> 0 .And. SF1->(FieldPos("F1_DAUTNFE")) <> 0) .And. (Empty(SF1->F1_HAUTNFE) .Or. Empty(SF1->F1_DAUTNFE) .Or. (SF1->(FieldPos("F1_CHVNFE")) > 0 .And. Empty(SF1->F1_CHVNFE)))
							RecLock("SF1")

							SF1->F1_HAUTNFE := substr(cHautNfe, 1, 5 )     //Grava a hora de autorização da nota
							SF1->F1_DAUTNFE	:= dDautNfe	//Grava a data de autorização da nota
							If !Empty(cXml).And. !Empty(cProtocolo) .Or. (!Empty(cXml).And. !Empty(cProtocolo) .And. nModalidade = 7) .or. lChaveEpec // Inserida verificação do protocolo, antes de gravar a Chave. e se está em contigencia FSDA
								If (SF1->F1_FORMUL == "S") // So grava a a chave da nota se for formulerio prorpio igual a SIM
									SF1->F1_CHVNFE  := SubStr(NfeIdSPED(cXML,"Id"),4)
								EndIF
							EndIf

							If !Empty(cCodRetNfe) .And. cCodRetNfe $ "100,101,102,124,136"
							/*	Alteração replicada em 13/02/2017 também para entrada
								Legenda fica verde após consultar a autorização no monitor
								(não somente após consulta chave ou impressão do danfe)
							*/
								SF1->F1_FIMP := "S" // Autorizada
							ElseIf !Empty(cCodRetNfe) .And. !cCodRetNfe $ "100,101,102,124,"+RetCodDene() 	 //Se o retorno for uma rejeição, grava o F1_FIMP como N e a legenda fica como Não Autorizada(preto) (124 = Autorização DPEC)
								SF1->F1_FIMP := "N"
							ElseIf !Empty(cCodRetNfe) .And. cCodRetNfe $ RetCodDene()  					// Atualizar a Leganda para Nf-e denegada
								SF1->F1_FIMP := "D"
							EndIf

							If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
								RecLock("SF1")
								SF1->F1_HORA := cHautNfe
								MsUnlock()
							EndIf

							MsUnlock()
							// Atualização dos campos da Tabela GFE
							if FindFunction("GFECHVNFE") .and. lMVGfe  // Integração com o GFE
								if  SF1->F1_TIPO $ "D|B"    // Documento com tipo de devolução ou "Utilizar Fornecedor"
									dbSelectArea("SA1")
									dbSetOrder(1)
									If SA1->(DbSeek(xFilial("SA1")+ SF1->F1_FORNECE + SF1->F1_LOJA))
										GFECHVNFE(xFilial("SF1"),SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_TIPO,SA1->A1_CGC,SA1->A1_COD,SA1->A1_LOJA,SF1->F1_CHVNFE,SF1->F1_FIMP, "E")
									Endif
								else
									dbSelectArea("SA2")
									dbSetOrder(1)
									If SA2->(MsSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA,.T.))
										GFECHVNFE(xFilial("SF1"),SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_TIPO,SA2->A2_CGC,SA2->A2_COD,SA2->A2_LOJA,SF1->F1_CHVNFE,SF1->F1_FIMP, "E")
									endif
								endif
							endif
						EndIf
						nRecnoSF1 := SF1->(Recno())
						//cEspecieNfe	:= SF1->F2_ESPECIE

					Endif
					SF1->(dbSkip())
				EndDo

				If nRecnoSF1 > 0
					SF1->(DbGoTo(nRecnoSF1))
				Else
					SF1->(MsSeek(xFilial("SF1")+ cNota + cSerie,.T.))
				EndIf

				//Atualizo SF3
				SF3->(dbSetOrder(4))
				cChave := xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
				If SF3->(MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.T.))
					Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
						If (Val(SF3->F3_CFO) >= 5000 .Or. SF3->F3_FORMUL=='S')
							RecLock("SF3",.F.)
							If !Empty(cXml).And. !Empty(cProtocolo) // Inserida verificação do protocolo, antes de gravar a Chave.
								If (SF3->F3_FORMUL == "S") .And. !(Left(cCodRetNfe,3) == '102')//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
									SF3->F3_CHVNFE  := SubStr(NfeIdSPED(cXml,"Id"),4)
								Endif
							EndIf
						Endif
						MsUnLock()
						SF3->(dbSkip())
					EndDo
				EndIf

				//Atualizo SFT
				SFT->(dbSetOrder(1))
				cChave := xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
				If SFT->(MsSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
					Do While cChave == xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA ;
							.And. (Val(SFT->FT_CFOP) >= 5000 .Or. SFT->FT_FORMUL=='S') .And. !SFT->(Eof())
						RecLock("SFT",.F.)
						If !Empty(cXml).And. !Empty(cProtocolo) // Inserida verificação do protocolo, antes de gravar a Chave.
							If (SFT->FT_FORMUL == "S") .And. !(Left(cCodRetNfe,3) == '102')//("Inutilizacao de numero homologado" $ cMsgRetNfe .Or. "Inutilização de número homologado" $ cMsgRetNfe)
								SFT->FT_CHVNFE := RetChave(cXML)
							Endif
						EndIf
						MsUnLock()

						//-----------------------------------------------------------------------------------------
						//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
						//-----------------------------------------------------------------------------------------
						if lIntegTaf .and. !empty( SFT->FT_CHVNFE )
							FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
						endif

						SFT->(dbSkip())
					EndDo
				EndIf
			ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)<"5" //Alimenta Chave da NFe Cancelada na F3/FT  ao consultar o monitorfaixa
				SF3->(dbSetOrder(4))
				cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
				cChaveFT := xFilial("SFT")+"E"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
				SF3->(dbSeek(cChaveF3,.T.))
				While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
					RecLock("SF3",.F.)
					If !Empty(cXml) .And. !Empty(cProtocolo) // Inserida verificação do protocolo, antes de gravar a Chave.
						If (SF3->F3_FORMUL == "S") .And. !(Left(cCodRetNfe,3) == '102')
							//Tratamento para o XML do Colaboração que retorna como evento.
							SF3->F3_CHVNFE  := RetChave(cXML)
						EndIf
					EndIf
					SF3->(MsUnLock())
					SF3->(dbSkip())
				EndDo

				SFT->(dbSetOrder(1))
				SFT->(dbSeek(cChaveFT,.T.))
				While !SFT->(Eof()) .And. xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
					RecLock("SFT",.F.)
					If !Empty(cXml) .And. !Empty(cProtocolo) // Inserida verificação do protocolo, antes de gravar a Chave.
						If (SFT->FT_FORMUL == "S") .And. !(Left(cCodRetNfe,3) == '102')
							//Tratamento para o XML do Colaboração que retorna como evento.
							SFT->FT_CHVNFE  := RetChave(cXML)
						EndIf
					EndIf
					SFT->(MsUnLock())

					//-----------------------------------------------------------------------------------------
					//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
					//-----------------------------------------------------------------------------------------
					if lIntegTaf .and. !empty( SFT->FT_CHVNFE )
						FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
					endif

					SFT->(dbSkip())
				EndDo
			EndIf
		endif

		//Ponto de entrada para o cliente customizar impressao automatica da DANFE posicionado por nota.
		If 	AllTrim(Upper(cEspecieNfe)) $ "SPED" .and. !empty(cXml) .and. !empty(cCodRetNfe) .And. !(alltrim(cCodRetNfe) $ "101,102") .and. (!empty(cProtocolo) .or. !empty(cDpecProtocolo)) .and. ( IsInCallStack("SPEDNFe") .or. IsInCallStack("execJobAuto") )
			If ExistBlock("SPDNFDANF")
				ExecBlock("SPDNFDANF",.F.,.F.,{cNota,cSerie,SubStr(NfeIdSPED(cXml,"Id"),4), cIdEnt, cCliFor, cLoja})
			EndIf
		EndIf

	Next nX

	If !Empty(cPriCTe) .And. !Empty(cUltCTe) .And. !Empty(cSerCTe) .And. ExistFunc("TMSSpedCte")
		TMSSpedCte(cSerCTe, cPriCTe, cUltCTe) // ATUALIZA OS DADOS DO CTE NA DT6
	EndIf

Return nil



