#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STREST90        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL fechaRomaneio DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Fechar romaneio" WSSYNTAX "/rest/fechaRomaneio"

END WSRESTFUL

WSMETHOD POST WSSERVICE fechaRomaneio

	Local cResp 	:= "ERRO"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _lErro	:= .F.

	ConOut("[STREST90]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STREST90]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If _lRet

		_cQuery1 := " SELECT PD1.R_E_C_N_O_ RECPD1, PD2.R_E_C_N_O_ RECPD2, PD2_STATUS
		_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
		_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
		_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
		_cQuery1 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '
		_cQuery1 += " AND PD1_FILIAL='"+xFilial("PD1")+"'
		_cQuery1 += " AND PD1_CODROM='"+oInfo:INFORMACOES:ROMANEIO+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		DbSelectArea("PD1")
		DbSelectArea("PD2")

		If (_cAlias1)->(!Eof())

			While (_cAlias1)->(!Eof())

				PD2->(DbGoTo((_cAlias1)->RECPD2))

				If PD2->(!Eof())

					If !(AllTrim(PD2->PD2_STATUS)$"4#5")
						cResp  := 'Existem notas sem bipagem, verifique!'
						_lErro := .T.
					EndIf	

				EndIf

				(_cAlias1)->(DbSkip())
			EndDo
			
			(_cAlias1)->(DbGoTop())

			PD1->(DbGoTo((_cAlias1)->RECPD1))

			If PD1->(!Eof())

				If Val(PD1->PD1_KMSAID)>=Val(oInfo:INFORMACOES:KMCHEGADA)
					_lErro := .T.
					cResp := "KM de saida maior ou igual ao KM de chegada, verifique!"
				EndIf

				If !_lErro
					PD1->(RecLock("PD1",.F.))
					PD1->PD1_KMCHEG := oInfo:INFORMACOES:KMCHEGADA
					PD1->(MsUnLock())
				EndIf

			EndIf

		Else

			cResp := "Romaneio não encontrado, verifique!"

		EndIf

	Else

		cResp := 'Erro ao converter Json, entre em contato com o TI'

	EndIf

	If !_lErro
		cResp := "OK"
	EndIf

	ConOut("[STREST90]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.
