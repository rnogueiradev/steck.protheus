#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "spednfe.ch"  
#DEFINE MAXJOBNOAR 20

User Function STAutoNfeEnv(cEmpresa,cFilProc,cWait,cOpc,cSerie,cNotaIni,cNotaFim)

	Local aArea       := GetArea()
	Local aPerg       := {}
	Local lEnd        := .F.
	Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
	Local aXML        := {}
	Local cRetorno    := ""
	Local cIdEnt      := ""
	Local cModalidade := ""
	Local cAmbiente   := ""
	Local cVersao     := ""
	Local cVersaoCTe  := ""
	Local cVersaoDpec := ""
	Local cMonitorSEF := ""
	Local cSugestao   := ""
	Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local nX          := 0
	Local lOk         := .T.
	Local oWs
	Local cParNfeRem  := SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFEREM"

	If cSerie == Nil
		MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfeRem,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfeRem,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
	Else
		MV_PAR01 := aParam[01] := cSerie
		MV_PAR02 := aParam[02] := cNotaIni
		MV_PAR03 := aParam[03] := cNotaFim
	EndIf

	If .T.//IsReady()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cIdEnt := GetIdEnt()

		If !Empty(cIdEnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o ambiente de execucao do Totvs Services SPED                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oWS := WsSpedCfgNFe():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:nAmbiente  := 0
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk			   := execWSRet( oWS, "CFGAMBIENTE")
			If lOk
				cAmbiente := oWS:cCfgAmbienteResult
			Else
				Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem a modalidade de execucao do Totvs Services SPED                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:nModalidade:= 0
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				oWs:cModelo	   := "55"
				lOk 		   := execWSRet( oWS, "CFGModalidade" )
				If lOk
					cModalidade:= oWS:cCfgModalidadeResult
				Else
					Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				EndIf
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem a versao de trabalho da NFe do Totvs Services SPED                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk			   := execWSRet( oWs, "CFGVersao" )
				If lOk
					cVersao    := oWS:cCfgVersaoResult
				Else
					Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				EndIf
			EndIf
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk 		   := execWSRet( oWs, "CFGVersaoCTe" )
				If lOk
					cVersaoCTe := oWS:cCfgVersaoCTeResult
				Else
					Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				EndIf
			EndIf
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk			   := execWSRet( oWs, "CFGVersaoDpec" )
				If lOk
					cVersaoDpec:= oWS:cCfgVersaoDpecResult
				Else
					Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				EndIf
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o status na SEFAZ                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:= WSNFeSBRA():New()
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
				lOk := oWS:MONITORSEFAZMODELO()
				If lOk
					aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
					For nX := 1 To Len(aXML)
						Do Case
						Case aXML[nX]:cModelo == "55"
							cMonitorSEF += "- NFe"+CRLF
							cMonitorSEF += STR0017+cVersao+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += STR0125+"(NFe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
							EndIf

						Case aXML[nX]:cModelo == "57"
							cMonitorSEF += "- CTe"+CRLF
							cMonitorSEF += STR0017+cVersaoCTe+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += STR0125+"(CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
							EndIf
						EndCase
						cMonitorSEF += Space(6)+STR0129+": "+aXML[nX]:cVersaoMensagem+CRLF //"Versão da mensagem"
						cMonitorSEF += Space(6)+STR0120+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //"Código do Status"
						cMonitorSEF += Space(6)+STR0121+": "+aXML[nX]:cUFOrigem //"UF Origem"
						If !Empty(aXML[nX]:cUFResposta)
							cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
						Else
							cMonitorSEF += CRLF
						EndIf
						If aXML[nX]:nTempoMedioSEF <> Nil
							cMonitorSEF += Space(6)+STR0071+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //"Tempo de espera"
						EndIf
						If !Empty(aXML[nX]:cMotivo)
							cMonitorSEF += Space(6)+STR0123+": "+aXML[nX]:cMotivo+CRLF //"Motivo"
						EndIf
						If !Empty(aXML[nX]:cObservacao)
							cMonitorSEF += Space(6)+STR0124+": "+aXML[nX]:cObservacao+CRLF //"Observação"
						EndIf
					Next nX
				EndIf
			EndIf

			Conout("[JOB  ]["+cIdEnt+"] - Iniciando transmissao NF-e de saida!")
			cRetorno := SpedNFeTrf("SF2",aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
			Conout("[JOB  ]["+cIdEnt+"] - "+cRetorno)

			Conout("[JOB  ]["+cIdEnt+"] - Iniciando transmissao NF-e de entrada!")
			cRetorno := SpedNFeTrf("SF1",aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
			Conout("[JOB  ]["+cIdEnt+"] - "+cRetorno)

		EndIf
	Else
		Conout("SPED","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!")
	EndIf

	RestArea(aArea)
Return


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
	±±³          ³Service                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function GetIdEnt()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	EndIf

	RestArea(aArea)
Return(cIdEnt)
