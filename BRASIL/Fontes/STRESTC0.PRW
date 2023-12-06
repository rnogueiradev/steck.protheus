#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTC0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL setCheckVeic DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Gravar check list do veículo" WSSYNTAX "/rest/setCheckVeic"

END WSRESTFUL

WSMETHOD POST WSSERVICE setCheckVeic

	Local cResp 	:= "ERRO"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= ""
	Local _nX 		:= 0
	Local _cUser 	:= __cUserId
	Local _cCheck	:= ""
	Local _nX     	:= 0
	Local _lErro	:= .F.

	ConOut("[STRESTC0]["+ FWTimeStamp(2) +"] - Usuario "+_cUser+" realizou o acesso.")
	ConOut("[STRESTC0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	DbSelectArea("PD1")
	PD1->(DbSetOrder(1))

	If _lRet

		If PD1->(DbSeek(xFilial("PD1")+oInfo:INFORMACOES:ROMANEIO))

			_cQuery2 := " SELECT *
			_cQuery2 += " FROM "+RetSqlName("PD1")+" PD1
			_cQuery2 += " WHERE PD1.D_E_L_E_T_=' ' AND PD1_FILIAL='"+PD1->PD1_FILIAL+"'
			_cQuery2 += " AND PD1_PLACA='"+PD1->PD1_PLACA+"' AND PD1_CODROM<>'"+PD1->PD1_CODROM+"'
			_cQuery2 += " AND PD1_KMCHEG=' ' 

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)
			(_cAlias2)->(dbGoTop())

			If (_cAlias2)->(!Eof())
				_lErro := .T.
				cResp := "Existem romaneios para essa mesma placa com KM de chegada sem preenchimento, verifique!"
				::SetResponse(cResp)
				Return .T.
			EndIf			

			_cCheck := ""
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK1),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK2),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK3),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK4),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK5),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK6),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK7),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK8),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK9),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK10),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK11),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK12),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK13),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK14),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK15),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK16),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK17),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK18),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK19),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK20),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK21),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK22),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK23),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK24),1,1)
			_cCheck += SubStr(UPPER(oInfo:INFORMACOES:CHK25),1,1)
			
			PD1->(RecLock("PD1",.F.))
			PD1->PD1_XDTCH2 := Date()
			PD1->PD1_XHRCH2 := Time()
			PD1->PD1_XCHKV  := _cCheck
			PD1->PD1_XCHKVO := AllTrim(oInfo:INFORMACOES:OUTROS) 
			PD1->PD1_XUSCH2 := UsrRetName(_cUser)
			PD1->(MsUnLock())

			cResp := 'OK'

		EndIf

	Else

		_lErro := .T.
		cResp := "Erro ao converter Json, entre em contato com o TI"
		::SetResponse(cResp)
		Return .T.

	EndIf

	ConOut("[STRESTC0]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.
