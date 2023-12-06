#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STFAT070        | Autor | RENATO.OLIVEIRA           | Data | 15/01/2019  |
|=====================================================================================|
|Descrição | ROTINA PARA SUBIR CLIENTES NA ZWORKFORCE                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT070()

	Local _cToken		:= ""
	Local nTimeOut 		:= 60
	Local aHeadOut 		:= {}
	Local cHeadRet 		:= ""
	Local nTimeOut1 	:= 60
	Local aHeadOut1 	:= {}
	Local cHeadRet1 	:= ""
	Local _cUrl 		:= "https://panel.zworkforce.com/rest/customer"
	Local _cJson		:= ""
	Local _cQuery1 		:= ""
	Local _cAlias1 		:= ""
	Local _cQuery2 		:= ""
	Local _cAlias2 		:= ""
	Local _nCount		:= 0
	Local _nTotal		:= 0
	//Local oInfo

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	_cToken		:= AllTrim(GetMv("ST_TOKZWOR",,"cmVuYXRvLm9saXZlaXJhQHN0ZWNrLmNvbS5icjoxMjM0NTY3ODkw"))

	ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Inicio do envio de clientes.")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cQuery2 := " SELECT *
	_cQuery2 += " FROM "+RetSqlName("SA3")+" A3
	_cQuery2 += " WHERE A3.D_E_L_E_T_=' ' AND A3_NOME NOT LIKE '%ENCERRADO%' AND SUBSTR(A3_COD,1,1) IN ('E','X')

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	While (_cAlias2)->(!Eof())

		If !SA1->(DbSeek(xFilial("SA1")+(_cAlias2)->A3_COD+"01"))
			SA1->(RecLock("SA1",.T.))
			SA1->A1_COD 	:= (_cAlias2)->A3_COD
			SA1->A1_LOJA	:= "01"
			SA1->A1_NOME	:= "PROSPECT ZWORKFORCE"
			SA1->A1_VEND 	:= (_cAlias2)->A3_COD
			SA1->(MsUnLock())
		Else
			SA1->(RecLock("SA1",.F.))
			SA1->A1_NOME	:= "PROSPECT ZWORKFORCE"
			SA1->A1_VEND 	:= (_cAlias2)->A3_COD
			SA1->(MsUnLock())
		EndIf
		If !SA1->(DbSeek(xFilial("SA1")+(_cAlias2)->A3_COD+"02"))
			SA1->(RecLock("SA1",.T.))
			SA1->A1_COD 	:= (_cAlias2)->A3_COD
			SA1->A1_LOJA	:= "02"
			SA1->A1_NOME	:= "HOMEOFFICE ZWORKFORCE"
			SA1->A1_VEND 	:= (_cAlias2)->A3_COD
			SA1->(MsUnLock())
		Else
			SA1->(RecLock("SA1",.F.))
			SA1->A1_NOME	:= "HOMEOFFICE ZWORKFORCE"
			SA1->A1_VEND 	:= (_cAlias2)->A3_COD
			SA1->(MsUnLock())
		EndIf

		(_cAlias2)->(DbSkip())
	EndDo

	aAdd( aHeadOut , "Authorization: Basic "+_cToken)

	_cQuery1 := " SELECT A1_NOME, A1_EMAIL, A1_END, A1_BAIRRO, A1_COMPLEM, A1_EST, A1_PAIS, A1_MUN, A1_CEP, A1_COD||A1_LOJA CODIGO,
	_cQuery1 += " A1_XLAT, A1_XLON, A1_VEND, A3_NOME, A1.R_E_C_N_O_ RECSA1, A3_SUPER, A1_COD, A3_COD, A1_XNOMZ
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" A3
	_cQuery1 += " ON A3_COD=A1_VEND
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A3.D_E_L_E_T_=' '
	_cQuery1 += " AND SUBSTR(A3_COD,1,1) IN ('C','E','X','S','R') AND A3_NOME NOT LIKE '%ENCERRADO%'
	_cQuery1 += " AND A1_XDTENVM=' '
	_cQuery1 += " ORDER BY A1_COD, A1_LOJA

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To _nTotal

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_nCount++

		ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Enviando "+CVALTOCHAR(_nCount)+"/"+CVALTOCHAR(_nTotal))

		SA1->(DbGoTo((_cAlias1)->RECSA1))

		If Empty(SA1->A1_XLAT) .And. GetMv("ST_GETLATG",,.F.)

			_cUrlGoog 	:= "https://maps.google.com/maps/api/geocode/json"
			_cParam 	:= "key="+escape(AllTrim(GetMv("ST_KEYGOOG",,"")))"
			_cParam 	+= "&address="+escape(AllTrim(SA1->A1_END)+", "+AllTrim(SA1->A1_BAIRRO)+", "+(AllTrim(SA1->A1_EST)))
			_cParam 	:= EncodeUTF8(_cParam)
			cHttpGet1 	:= HttpSGet(_cUrlGoog,"","","",_cParam,nTimeOut1,aHeadOut1,@cHeadRet1)
			oInfo 	  	:= ""
			_lRet     	:= FWJsonDeserialize(cHttpGet1,@oInfo)

			If Type("oInfo:RESULTS[1]:GEOMETRY:LOCATION")=="O"

				_cLat 	:= oInfo:RESULTS[1]:GEOMETRY:LOCATION:LAT
				_cLong	:= oInfo:RESULTS[1]:GEOMETRY:LOCATION:LNG

				SA1->(RecLock("SA1",.F.))
				SA1->A1_XLAT := cValToChar(_cLat)
				SA1->A1_XLON := cValToChar(_cLong)
				SA1->(MsUnLock())

			EndIf

		EndIf

		_cJson := '{

		If !Empty((_cAlias1)->A1_XNOMZ)
			_cJson += '"name": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_XNOMZ)))+'",
		Else
			_cJson += '"name": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_NOME)))+'",
		EndIf

		_cJson += '"email": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_EMAIL)))+'",
		_cJson += '"address": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_END)))+'",
		//_cJson += '"addrNumber": "'+AllTrim("teste@teste.com.br")+'",
		_cJson += '"addrComp": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_COMPLEM)))+'",
		_cJson += '"addrArea": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_BAIRRO)))+'",
		_cJson += '"addrCity": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->A1_MUN)))+'",
		_cJson += '"addrState": "'+AllTrim((_cAlias1)->A1_EST)+'",
		_cJson += '"addrCountry": "'+AllTrim("BRASIL")+'",
		_cJson += '"addrZipcode": "'+AllTrim((_cAlias1)->A1_CEP)+'",
		_cJson += '"foreignId": "'+AllTrim((_cAlias1)->CODIGO)+'",
		_cJson += '"lat": "'+AllTrim(SA1->A1_XLAT)+'",
		_cJson += '"lon": "'+AllTrim(SA1->A1_XLON)+'"
		_cJson += ',"portfolioContributors": { "zfAppUser" : {

		_cVends := (_cAlias1)->A1_VEND+";"

		If !(AllTrim((_cAlias1)->A1_COD)==AllTrim((_cAlias1)->A3_COD))

			If SubStr((_cAlias1)->CODIGO,1,6) $ "038134#028358#014519#023789#090222"
				_cVends += "X01025;"
			EndIf
			If SubStr((_cAlias1)->CODIGO,1,6) $ "065560#092661#093019"
				_cVends += "X00003;"
			EndIf
			If SubStr((_cAlias1)->CODIGO,1,6) $ "065560#094282#092920"
				_cVends += "X00004;"
			EndIf
			If SubStr((_cAlias1)->CODIGO,1,6) $ "077683#051134#094401#094954"
				_cVends += "X00005;"
			EndIf
			If SubStr((_cAlias1)->CODIGO,1,6) $ "093966#094283#095155#061925"
				_cVends += "X00006;"
			EndIf
			If SubStr((_cAlias1)->CODIGO,1,6) $ "094536#093740#092905#094162#095317"
				_cVends += "X00007;"
			EndIf
			If AllTrim((_cAlias1)->A1_VEND) $ "R00105#R00104#R00408"
				_cVends += "S00003;"
			EndIf
			If AllTrim((_cAlias1)->A3_SUPER) $ "S00006"
				_cVends += "S00006;"
			EndIf

			_cVends += "I08599;I08600;"

		EndIf

		_cJson += '"foreignId": "'+AllTrim(_cVends)+'"

		_cJson += '} } }

		_cJson := EncodeUTF8(_cJson)

		cHttpPost := HTTPSPost (_cUrl, "", "", "", "", _cJson, nTimeOut, aHeadOut, @cHeadRet )

		oInfo := ""
		_lRet := FWJsonDeserialize(cHttpPost,@oInfo)

		If _lRet

			If oInfo:control:code==0
				SA1->(RecLock("SA1",.F.))
				SA1->A1_XDTENVM := Date()
				SA1->(MsUnLock())
			EndIf

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Fim do envio de clientes.")

	ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Inicio do envio de obras.")

	_nTotal := 0

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("ZZ5")+" ZZ5
	_cQuery1 += " WHERE ZZ5.D_E_L_E_T_=' ' AND ZZ5_COD<>' '
	_cQuery1 += " AND ZZ5_XDTENV=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To _nTotal

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("ZZ5")

	While (_cAlias1)->(!Eof())

		_nCount++

		ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Enviando "+CVALTOCHAR(_nCount)+"/"+CVALTOCHAR(_nTotal))

		ZZ5->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		_cJson := '{
		_cJson += '"name": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->ZZ5_NOMEOB)))+'",
		_cJson += '"email": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->ZZ5_EMAIL)))+'",
		_cJson += '"address": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->ZZ5_ENDERE)))+'",
		_cJson += '"addrComp": "",
		_cJson += '"addrArea": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->ZZ5_BAIRRO)))+'",
		_cJson += '"addrCity": "'+AllTrim(U_STTIRAGR(AllTrim((_cAlias1)->ZZ5_CIDADE)))+'",
		_cJson += '"addrState": "'+AllTrim((_cAlias1)->ZZ5_ESTADO)+'",
		_cJson += '"addrCountry": "'+AllTrim("BRASIL")+'",
		_cJson += '"addrZipcode": "'+AllTrim((_cAlias1)->ZZ5_CEP)+'",
		_cJson += '"category": "Obra",
		_cJson += '"foreignId": "'+"ITC-"+AllTrim((_cAlias1)->ZZ5_COD)+'",
		_cJson += '"lat": "",
		_cJson += '"lon": ""
		_cJson += ',"portfolioContributors": { "zfAppUser" : {
		_cJson += '"foreignId": "'+AllTrim((_cAlias1)->ZZ5_AREA)+'"
		_cJson += '} } }

		_cJson := EncodeUTF8(_cJson)

		cHttpPost := HTTPSPost (_cUrl, "", "", "", "", _cJson, nTimeOut, aHeadOut, @cHeadRet )

		oInfo := ""
		_lRet := FWJsonDeserialize(cHttpPost,@oInfo)

		If _lRet

			If oInfo:control:code==0
				ZZ5->(RecLock("ZZ5",.F.))
				ZZ5->ZZ5_XDTENV := Date()
				ZZ5->(MsUnLock())
				ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Obra: "+AllTrim((_cAlias1)->ZZ5_COD)+" enviada com sucesso!")
			EndIf

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	ConOut("[STFAT070]["+ FWTimeStamp(2) +"] Fim do envio de obras.")

Return()
