#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STREST80        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL setCheckIn DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Baixar nota fiscal do romaneio" WSSYNTAX "/rest/setCheckIn"

END WSRESTFUL

WSMETHOD POST WSSERVICE setCheckIn

	Local cResp 	:= "ERRO"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cUser    := __cUserId

	ConOut("[STREST80]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STREST80]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment
	
	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	_cAlias1 := GetNextAlias()
	
	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)
	
	If _lRet
	
		_cQuery1 := " SELECT PD1.R_E_C_N_O_ RECPD1
		_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
		_cQuery1 += " WHERE PD1.D_E_L_E_T_=' '
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
		
		If (_cAlias1)->(!Eof())
		
			PD1->(DbGoTo((_cAlias1)->RECPD1))

			If PD1->(!Eof())
			
				PD1->(RecLock("PD1",.F.))
				PD1->PD1_KMSAID := oInfo:INFORMACOES:KMSAIDA
				PD1->PD1_HRSAID := Time()
				//PD1->PD1_MOTORI	:= oInfo:INFORMACOES:MOTORISTA
				//PD1->PD1_DTENT  := CTOD(oInfo:INFORMACOES:DTENT)
				//PD1->PD1_PLACA  := oInfo:INFORMACOES:PLACA
				//PD1->PD1_AJUDA1	:= oInfo:INFORMACOES:AJUDANTE
				//PD1->PD1_XROTA	:= oInfo:INFORMACOES:ROTA
				PD1->PD1_XDTCH1 := Date()
				PD1->PD1_XHRCH1 := Time()
				PD1->PD1_XUSCH1 := UsrRetName(_cUser)
				PD1->(MsUnLock())

				cResp := 'OK'

			EndIf

		EndIf

	Else

		cResp := 'ERRO'

	EndIf
	
	ConOut("[STREST80]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.
