#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "aarray.ch"
#INCLUDE "json.ch"

/*====================================================================================\
|Programa  | STGOOG02         | Autor | Renato Nogueira            | Data | 02/10/2016|
|=====================================================================================|
|Descrição | Fonte utilizado para listar produtos do google shopping                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STGOOG02()

	Local cHttpGet			:= ""
	Local cUrl				:= "https://www.googleapis.com/calendar/v3/calendars/steck.zworkforce@gmail.com/events"
	Local aHeadOut			:= {}
	Local _cEmp				:= "01"
	Local _cFil				:= "02"
	Local nTimeOut 			:= 120
	Local cHeadRet 			:= ""
	Local cToken			:= ""
	Local _nX				:= 0
	Local _cQuery2 			:= ""
	Local _cAlias2 			:= GetNextAlias()
	Local _cTokenZW			:= ""
	Local nTimeOut1 		:= 60
	Local aHeadOut1 		:= {}
	Local cHeadRet1 		:= ""
	Local _cUrl1 			:= "https://panel.zworkforce.com/rest/visit"
	Local _cJson1			:= ""
	Local oInfo
	Local cNextP			:= ""
	Local _lContinua		:= .T.

	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES 'SB1' MODULO 'COM'

	_cTokenZW			:= AllTrim(GetMv("ST_TOKZWOR",,"cmVuYXRvLm9saXZlaXJhQHN0ZWNrLmNvbS5icjoxMjM0NTY3ODkw"))

	ConOut("[STGOOG02]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	cToken	:= U_STGOOG01() //Obter token de acesso

	If Empty(cToken)
		ConOut("[STGOOG02]["+ FWTimeStamp(2) +"] - Token não encontrado, verifique!")
		Return
	EndIf

	aAdd( aHeadOut , "Authorization: Bearer "+cToken)

	DbSelectArea("Z56")
	Z56->(DbSetOrder(1))
	Z56->(DbGoTop())
	Z56->(DbSeek(xFilial("Z56")))

	While _lContinua

		cNextP := Z56->Z56_TOKEN

		cUrl := "https://www.googleapis.com/calendar/v3/calendars/steck.zworkforce@gmail.com/events?maxResults=30&singleEvents=true"

		If !Empty(cNextP)
			cUrl := "https://www.googleapis.com/calendar/v3/calendars/steck.zworkforce@gmail.com/events?maxResults=30&singleEvents=true&pageToken="+cNextP
		EndIf

		cHttpGet 	:= HttpSGet(cUrl,"","","","",nTimeOut,aHeadOut,@cHeadRet)

		_lRet    := FWJsonDeserialize(cHttpGet,@oInfo)

		DbSelectArea("Z28")
		Z28->(DbSetOrder(1))

		If _lRet

			oObj1 	:= oInfo

			If Type("oObj1:NEXTPAGETOKEN")=="C"
				If !Empty(oObj1:NEXTPAGETOKEN)
					cNextP := oObj1:NEXTPAGETOKEN
					Z56->(RecLock("Z56",.F.))
					Z56->Z56_TOKEN := cNextP
					Z56->(MsUnLock())
				Else
					_lContinua := .F.
				EndIf
			Else
				_lContinua := .F.
			EndIf

			For _nX:=1 To Len(oInfo:Items)

				oObj := oInfo:Items[_nX]

				If !Type("oObj:SUMMARY")=="C"
					Loop
				EndIf

				If !Type("oObj:START:DATETIME")=="C" //Visita o dia todo
					_cStart := oObj:START:DATE+"T08:00:00-02:00"
					_cEnd	:= oObj:START:DATE+"T17:00:00-02:00"
				Else
					_cStart := oInfo:Items[_nX]:START:DATETIME
					_cEnd	:= oInfo:Items[_nX]:END:DATETIME
				EndIf

				_cId := StrTran(oInfo:Items[_nX]:ETAG,'"')

				If !Z28->(DbSeek(xFilial("Z28")+_cId))
					Z28->(RecLock("Z28",.T.))
					Z28->Z28_FILIAL := xFilial("Z28")
					Z28->Z28_ID		:= _cId
					Z28->Z28_TITLE	:= oInfo:Items[_nX]:SUMMARY
					Z28->Z28_ZONETM	:= oInfo:TIMEZONE
					Z28->Z28_START	:= _cStart
					Z28->Z28_END	:= _cEnd

					If "ITC-" $ oInfo:Items[_nX]:SUMMARY
						Z28->Z28_CUSTOM	:= SubStr(oInfo:Items[_nX]:SUMMARY,1,AT(" ",oInfo:Items[_nX]:SUMMARY)-1)
					Else
						Z28->Z28_CUSTOM	:= SubStr(oInfo:Items[_nX]:SUMMARY,1,8)
					EndIf

					Z28->Z28_IDVEND	:= GETID(AllTrim(oInfo:Items[_nX]:ORGANIZER:EMAIL))
					Z28->Z28_EMAIL	:= AllTrim(oInfo:Items[_nX]:ORGANIZER:EMAIL)
					Z28->Z28_STATUS := "0"
					Z28->(MsUnLock())
				EndIf
			Next
		EndIf

	EndDo

	_cQuery2 := " SELECT *
	_cQuery2 += " FROM "+RetSqlName("Z28")+" Z28
	_cQuery2 += " WHERE Z28.D_E_L_E_T_=' ' AND Z28_STATUS='0'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	aAdd( aHeadOut1 , "Authorization: Basic "+_cTokenZw)

	While (_cAlias2)->(!Eof())

		Z28->(DbGoTo((_cAlias2)->R_E_C_N_O_))

		If STOD(SubStr(StrTran(Z28->Z28_START,"-"),1,8))<Date()
			Z28->(RecLock("Z28",.F.))
			Z28->Z28_STATUS := "2"
			Z28->(MsUnLock())
			(_cAlias2)->(DbSkip())
			Loop
		EndIf
		If STOD(SubStr(StrTran(Z28->Z28_START,"-"),1,8))==Date() .And. SubStr(Z28->Z28_START,12,8)<=Time()
			Z28->(RecLock("Z28",.F.))
			Z28->Z28_STATUS := "2"
			Z28->(MsUnLock())
			(_cAlias2)->(DbSkip())
			Loop
		EndIf

		_cJson1 := '{
		_cJson1 += '"title": "'+AllTrim(Z28->Z28_TITLE)+'",
		_cJson1 += '"timezoneId": "'+AllTrim(Z28->Z28_ZONETM)+'",
		_cJson1 += '"start": "'+AllTrim(Z28->Z28_START)+'",
		_cJson1 += '"end": "'+AllTrim(Z28->Z28_END)+'",
		_cJson1 += '"customer": {
		_cJson1 += '"foreignId": "'+AllTrim(Z28->Z28_CUSTOM)+'"
		_cJson1 += '},
		_cJson1 += '"zfAppUser": {
		_cJson1 += '"foreignId": "'+AllTrim(Z28->Z28_IDVEND)+'",
		_cJson1 += '"email": "'+AllTrim(Z28->Z28_EMAIL)+'"
		_cJson1 += '}
		_cJson1 += '}

		_cJson1 := EncodeUTF8(_cJson1)

		cHttpPost := HTTPSPost(_cUrl1, "", "", "", "", _cJson1, nTimeOut1, aHeadOut1, @cHeadRet1 )

		If !Empty(cHttpPost)
			Z28->(RecLock("Z28",.F.))
			Z28->Z28_STATUS := "1"
			Z28->(MsUnLock())
		EndIf

		(_cAlias2)->(DbSkip())
	EndDo

	ConOut("[STGOOG02]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

/*====================================================================================\
|Programa  | GETID         | Autor | Renato Nogueira            | Data | 02/10/2016|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETID(_cEmail)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cId	   := ""

	_cQuery1 := " SELECT A3_COD
	_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
	_cQuery1 += " WHERE A3.D_E_L_E_T_=' ' AND (UPPER(A3_EMAIL)='"+Upper(_cEmail)+"' OR UPPER(A3_XEMAIL)='"+Upper(_cEmail)+"')

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cId := (_cAlias1)->A3_COD
	EndIf

Return(_cId)