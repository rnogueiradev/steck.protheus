#INCLUDE "PROTHEUS.CH"

Static cARQLOG := "\Arquivos\Logs\STVLDT01.log"

/*/{Protheus.doc} STVLDT01
description
Rotina que fará a validação Entrega / Frete / Transportadora
@type function
@version  
@author Valdemir Jose
@since 24/08/2021
@return variant, return_description
/*/
USER FUNCTION STVLDT01(pAlias)
	LOCAL lRET    := .T.
	Local lNovaR  := GETMV("STREGRAFT",.F.,.T.) .and. (cEmpAnt=="01")

	if file(cArqLog)
		FErase(cArqlog)
	endif

	LjWriteLog( cARQLOG, "INICIO VALIDAÇÃO ROTINA STVLDT01")

	IF lNovaR 
		// Verifico Regra de Entrega
		lRET := GetVldEnt(pAlias)
		LjWriteLog( cARQLOG, "Retorno GetVldEnt() linha:22 é "+cValToChar(lRet))

		// Verifico regra de Frete
		if lRET
			lRET := GetVldFre(pAlias)
			LjWriteLog( cARQLOG, "Retorno GetVldFre() linha:27 é "+cValToChar(lRet))
		endif

		// Verifico regra de Transportadora
		if lRET
			lRET := getVldTra(pAlias)
			LjWriteLog( cARQLOG, "Retorno getVldTra() linha:33 é "+cValToChar(lRet))
		endif
	ENDIF

	LjWriteLog( cARQLOG, "Retorno rotina STVLDT01 é "+cValToChar(lRet))

RETURN lRET

/*/{Protheus.doc} GetVldEnt
description
Rotina que valida a Entrega
@type function
@version  
@author Valdemir Jose
@since 24/08/2021
@return variant, return_description
/*/
Static Function GetVldEnt(pAlias)
	Local lRET        := .T.
	Local cMsg        := ""
	Local cTIPO       := ""
	Local cTPRETE     := ""
	Local cTIPOPED    := ""                     // VALDEMIR RABELO 23/02/2022 - CHAMADO: 20220125001919
	Local _aGrupos    := {}
	Local cFS_GRPSPVE := SuperGetMV("FS_GRPSPVE",,"")

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	IF (pAlias=="SC5")
		cTIPO    := "M->C5_XTIPO"
		cTPRETE  := "M->C5_TPFRETE"
		cZBLOQ   := "M->C5_ZBLOQ"
		cMOTBLO  := "M->C5_ZMOTBLO"
		cTipoFat := ""
		cTIPOPED := "M->C5_TIPO"             // VALDEMIR RABELO 23/02/2022 - CHAMADO: 20220125001919
	ELSE
		cTIPO    := "M->UA_XTIPOPV"
		cTPRETE  := "M->UA_TPFRETE"
		cTipoFat := "M->UA_OPER"
		cZBLOQ   := "M->UA_XBLOQ"
		cMOTBLO  := "M->UA_XDESBLQ"
	ENDIF

	lRET := ((&(cTIPO)=="1") .and. (&(cTPRETE)=="F")) .or. ((&(cTIPO)=="2") .and. (&(cTPRETE)=="C"))
	IF (!EMPTY(cTIPOPED) .and. !lRET)        // VALDEMIR RABELO 23/02/2022 - CHAMADO: 20220125001919
       lRET := (&cTIPOPED=="B")
	ENDIF 

	LjWriteLog( cARQLOG, "Linha: 82 "+cTIPO+"="+&(cTIPO)+" "+cTPRETE+"="+&(cTPRETE)+" Retorno="+cValToChar(lRET))

	/*   Removido conforme solicitação kleber e Carla  01/09/2021
	if !lRET
		if (&(cTIPO)=="1")
			cMsg := "Para Retira o tipo de frete deve ser FOB"
		else
			cMsg := "Para Entrega o tipo de frete deve ser CIF"
		endif
		FWMsgRun(,{|| sleep(3000) },"Informativo", cMsg)
	endif
	*/

	if (SA1->A1_TPFRET != &(cTPRETE)) .and. (SA1->A1_TPFRET=="F") .and. (!FWIsInCall("U_STTELALC"))
		lFrt := .F.
		IF (cTipoFat == "M->UA_OPER")     // 13/09/2021 - Valdemir Rabelo
           lFrt := (&cTipoFat =="1")
		ENDIF
        IF (!lFrt) .AND. (!FWIsInCall("U_STFSVE40"))   // Valdemir 15/09/2021
		   if (&cTIPOPED != "B")                       // Valdemir Rabelo 28/02/2022 - Chamado: 20220125001919
				&(cZBLOQ)  := "1"
				&(cMOTBLO) += "/FRETE" 
		   Endif 
			//MsgInfo("Tipo Frete no cadastro do cliente está diferente do informado"+CRLF+;
			//	"Altere para Retira FOB","Informativo")
		ENDIF
	Endif

Return lRET

/*/{Protheus.doc} GetVldFre
description
Rotina que valida o tipo de FRETE utilizado
@type function
@version  
@author Valdemir Jose
@since 24/08/2021
@param pAlias, variant, param_description
@return variant, return_description
/*/
Static Function GetVldFre(pAlias)
	Local aArea       := GetArea()
	Local _lRet       := .T.
	Local cFS_GRPSPVE := SuperGetMV("FS_GRPSPVE",,"")
	Local _aGrupos, _nPos

	IF (pAlias=="SC5")
		_cCliente := "M->C5_CLIENTE"
		_cLoja    := "M->C5_LOJACLI"
	ELSE
		_cCliente := "M->UA_CLIENTE"
		_cLoja    := "M->UA_LOJA"
	ENDIF

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

return .T.
	// Verificar pois acredito que esta validação seja para liberação de campo para determinados usuários

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		DbSelectArea("SA1")
		DbSetOrder(1)
		_lRet := DbSeek(xFilial("SA1")+&(_cCliente)+&(_cLoja))

		If _lRet

			If AllTrim(SA1->A1_TPFRET)=="C"

				_lRet	:= .T.

			ElseIf AllTrim(SA1->A1_TPFRET)=="F" .And. !SA1->A1_COD$"035444"  .And. !_aGrupos[1][10][1] $ cFS_GRPSPVE

				_lRet	:= .F.

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return _lRet

/*/{Protheus.doc} getVldTra
description
Rotina que faz validação de Estados por Transportadora
@type function
@version  
@author Valdemir Jose
@since 24/08/2021
@param pAlias, variant, param_description
@return variant, return_description
/*/
Static Function getVldTra (pAlias)
	Local _aArea	:= GetArea()
	Local _lRet		:= .T.
	Local cCODMUN   := ""
	Local cEST      := ""
	Local cTRANSP   := ""
	Local cTPRETE   := ""
	Local mvTrans   := GETMV("STTRANSTNT",.F.,'000163#004064')

	dbSelectArea("SA4")
	SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD

	IF (pAlias=="SC5")
		cCODMUN  := "M->C5_XCODMUN"
		cEST     := "M->C5_ZESTE"
		cTRANSP  := "M->C5_TRANSP"
		cTIPOCLI := "M->C5_TIPOCLI"
		cTPRETE  := "M->C5_TPFRETE"
	ELSE
		cCODMUN  := "M->UA_XCODMUN"
		cEST     := "M->UA_ESTE"
		cTRANSP  := "M->UA_TRANSP"
		cTIPOCLI := "M->UA_XTIPO"
		cTPRETE  := "M->UA_TPFRETE"
	ENDIF

	_lRet :=  SA4->( dbSeek(xFilial("SA4") + &(cTransp)) )

	if _lRet
		If SA4->A4_XCIF == '2' .Or. Empty(Alltrim(SA4->A4_XCIF))
			lRet := .F.
			FWMsgRun(,{|| sleep(3000) },"Informativo","(SA4) Transportadora Não Cadastrada Com Frete CIF...!!!!!!")
		EndIf
	Else
		FWMsgRun(,{|| sleep(3000) },"Informativo","(SA4) Transportadora Não Cadastrada...!!!!!!")
	EndIf

	if _lRet
		if !Empty(&(cCODMUN))
			//if (cEmpAnt=="01") .and. (cFilAnt == "02")
			if (cEmpAnt=="11") .and. (cFilAnt == "01")      //     Valdemir Rabelo 20/05/2021 Ticket: 20200825006248
				if (&cTPRETE=="C")
					if !u_LocUFTRA( &(cTRANSP), SA1->A1_EST, cTRANSP)   // &(cEST) Campo está vindo vazio
						_lRet	:= .F.
					endif
				endif
			endif
		else
			//if (cEmpAnt=="01") .and. (cFilAnt == "02")
			if (cEmpAnt=="11") .and. (cFilAnt == "01")       //     Valdemir Rabelo 20/05/2021 Ticket: 20200825006248
				if (&cTPRETE=="C")
					if !u_LocUFTRA( &(cTRANSP), SA1->A1_EST, cTRANSP)
						_lRet	:= .F.
					endif
				endif
			endif
		endif
		/*   Removido conforme solicitação kleber e Carla   01/09/2021
		If !((Alltrim(&(cTransp)) $ mvTrans)) .And. _lRet
			If !__cUserId $ AllTrim(GetMv("ST_GRUCIF"))
				If !AllTrim(SC5->C5_TIPOCLI) == "X"
					_lRet := .F.
					MsgInfo("Tipo de Frete CIF não é permitido trocar a Transportadora...!!!!!!")
				EndIf
			EndIf
		EndIf
		*/
	endif

	RestArea(_aArea)

Return _lRet
