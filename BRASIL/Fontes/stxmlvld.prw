#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"


/*/{Protheus.doc} STXMLVLD
@description
Rotina que fará a validação do status da Nota
@type function
@version 1.00  
@author Valdemir Jose
@since 12/07/2021
@return variant, return_description
/*/
User Function STXMLVLD(cChave, lJOB)
	Private cIdEnt := GetIdEnt()	
Return VldNfe(cChave, cIdEnt, lJOB)



/*/{Protheus.doc} VldNfe
@description
   Rotina que faz a validação da NFE
@type function
@version  
@author Valdemir Jose
@since 13/07/2021
@param cChaveNFe, character, param_description
@param cIndChv, character, param_description
@param lJOB, logical, param_description
@return variant, return_description
/*/
Static Function VldNfe(cChaveNFe,cIndChv,lJOB)

	Local cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMensagem := ""
	Local oWS
	Local cCodRet   := ""
	Local cVersao   := ""
	Local cMensagem := ""
	Local cTpRet    := ""
	Local cDescRet  := ""
	Local lRET      := .T.

	oWs            := WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := cIndChv
	ows:cCHVNFE    := cChaveNFe
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()

		cCodRet    := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		cVersao    := oWs:oWSCONSULTACHAVENFERESULT:cVERSAO
		cMensagem  := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE
		cProtocolo := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO

		lRET := (cMensagem != "Cancelamento de NF-e homologado")

		if !lRET 
			dbSelectArea("SF1")
			SF1->(DbSetOrder(8))
			
			DbSelectArea("SZ9")
			SZ9->(DbGoTop())
			SZ9->(DbSetOrder(1))
			If SZ9->(DbSeek(xFilial('SZ9')+AllTrim(cChaveNFe)))
			    lSF1 := SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))
				SZ9->(Reclock("SZ9",.F.))
				SZ9->Z9_STATUS	:= "X"
				SZ9->Z9_XML		:= "Nota fiscal cancelada"			
				SZ9->(MsUnlock())
				SZ9->(DbCommit())
				// Valdemir Rabelo 15/07/2021 - Ticket: 20210707011905
				if  lSF1
					U_UPDTESF1(SF1->F1_DOC) //StaticCall (CONSLOTE, UPDTESF1, SF1->F1_DOC)
				endif				
			EndIf
			if !lJOB
			   MsgInfo('Chave: '+AllTrim(cChaveNFe)+' - Nota Fiscal Cancelada','Informação')
			else 
			   Conout('Chave: '+AllTrim(cChaveNFe)+' - Nota Fiscal Cancelada')
			endif 		
		Endif 

	Else
		if !lJOB
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		else
			Conout("SPED - "+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		endif

	EndIf

Return(lRET)


/*/{Protheus.doc} GetIdEnt
@description
Rotina que Obtem o codigo da entidade apos enviar o post para o Totvs
@type function
@version 1.00
@author Valdemir Jose
@since 13/07/2021
@return variant, return_description
/*/
Static Function GetIdEnt()

	Local aArea := GetArea()
	Local cIdEnt := ""
	Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local lMethodOk := .F.
	Local oWsSPEDAdm

	BEGIN SEQUENCE

		IF !( CTIsReady(cURL) )
			BREAK
		EndIF

		cURL := AllTrim(cURL)+"/SPEDADM.apw"

		IF !( CTIsReady(cURL) )
			BREAK
		EndIF

		oWsSPEDAdm := WsSPEDAdm():New()

		oWsSPEDAdm:cUSERTOKEN := "TOTVS"
		oWsSPEDAdm:oWsEmpresa:cCNPJ := SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cCPF := SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cIE := SM0->M0_INSC
		oWsSPEDAdm:oWsEmpresa:cIM := SM0->M0_INSCM
		oWsSPEDAdm:oWsEmpresa:cNOME := SM0->M0_NOMECOM
		oWsSPEDAdm:oWsEmpresa:cFANTASIA := SM0->M0_NOME
		oWsSPEDAdm:oWsEmpresa:cENDERECO := FisGetEnd(SM0->M0_ENDENT)[1]
		oWsSPEDAdm:oWsEmpresa:cNUM := FisGetEnd(SM0->M0_ENDENT)[3]
		oWsSPEDAdm:oWsEmpresa:cCOMPL := FisGetEnd(SM0->M0_ENDENT)[4]
		oWsSPEDAdm:oWsEmpresa:cUF := SM0->M0_ESTENT
		oWsSPEDAdm:oWsEmpresa:cCEP := SM0->M0_CEPENT
		oWsSPEDAdm:oWsEmpresa:cCOD_MUN := SM0->M0_CODMUN
		oWsSPEDAdm:oWsEmpresa:cCOD_PAIS := "1058"
		oWsSPEDAdm:oWsEmpresa:cBAIRRO := SM0->M0_BAIRENT
		oWsSPEDAdm:oWsEmpresa:cMUN := SM0->M0_CIDENT
		oWsSPEDAdm:oWsEmpresa:cCEP_CP := NIL
		oWsSPEDAdm:oWsEmpresa:cCP := NIL
		oWsSPEDAdm:oWsEmpresa:cDDD := Str(FisGetTel(SM0->M0_TEL)[2],3)
		oWsSPEDAdm:oWsEmpresa:cFONE := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
		oWsSPEDAdm:oWsEmpresa:cFAX := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
		oWsSPEDAdm:oWsEmpresa:cEMAIL := UsrRetMail(RetCodUsr())
		oWsSPEDAdm:oWsEmpresa:cNIRE := SM0->M0_NIRE
		oWsSPEDAdm:oWsEmpresa:dDTRE := SM0->M0_DTRE
		oWsSPEDAdm:oWsEmpresa:cNIT := SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cINDSITESP := ""
		oWsSPEDAdm:oWsEmpresa:cID_MATRIZ := ""
		oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
		oWsSPEDAdm:_URL := cURL

		lMethodOk := oWsSPEDAdm:AdmEmpresas()

		DEFAULT lMethodOk := .F.

		IF !( lMethodOk )
			cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
			BREAK
		EndIF

		cIdEnt := oWsSPEDAdm:cAdmEmpresasResult

	END SEQUENCE

	RestArea(aArea)

Return( cIdEnt )
