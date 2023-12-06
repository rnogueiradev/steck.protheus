#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT270        | Autor | RENATO.OLIVEIRA           | Data | 14/11/2019  |
|=====================================================================================|
|Descrição | Rotina para puxar as visitas do zworkforce			                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT270()

	Local _cQuery1 		:= ""
	Local _cAlias1 		:= ""
	Local _cQuery2 		:= ""
	Local _cTokenZW		:= ""
	Local aHeadOut1 	:= {}
	Local nTimeOut1 	:= 60
	Local aHeadOut1 	:= {}
	Local cHeadRet1 	:= ""
	Local _nX			:= 0
	Local _nCurPage		:= 0
	Local _lContinua    := .T.
	Local _nA			:= 0
	Local _nB			:= 0
	Local _nC			:= 0
	Local _nw			:= 0
	Private _cAlias2 	:= ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cTokenZW := AllTrim(GetMv("ST_TOKZWOR",,"cmVuYXRvLm9saXZlaXJhQHN0ZWNrLmNvbS5icjoxMjM0NTY3ODkw"))

	ConOut("[STFAT270]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	aAdd( aHeadOut1 , "Authorization: Basic "+_cTokenZw)

	For _nW:=1 To GetMv("ST_DIASZW",,5)

		If _nW==1
			_dDate := Date()
		Else
			_dDate := Date()-_nW
		EndIf

		_sDate := DTOS(_dDate)
		_sDate := SubStr(_sDate,1,4)+"-"+SubStr(_sDate,5,2)+"-"+SubStr(_sDate,7,2)

		_nCurPage := 0

		While _lContinua

			_cUrlGoog 	:= "https://panel.zworkforce.com/rest/accomplishedVisit"
			_cParam 	:= "currentPage="+cValToChar(_nCurPage)+"&startDate="+_sDate+"&endDate="+_sDate
			_cParam 	:= EncodeUTF8(_cParam)
			cHttpGet1 	:= HttpSGet(_cUrlGoog,"","","",_cParam,nTimeOut1,aHeadOut1,@cHeadRet1)

			oInfo 	  	:= ""
			_lRet     	:= FWJsonDeserialize(cHttpGet1,@oInfo)

			DbSelectArea("Z55")
			Z55->(DbSetOrder(1))

			DbSelectArea("ZZ5")
			ZZ5->(DbSetOrder(1))

			If !_lRet
				Exit
			EndIf

			For _nX:=1 To Len(oInfo:RESULTS)

				If !Z55->(DbSeek(xFilial("Z55")+oInfo:RESULTS[_nX]:ZFACCOMPLISHEDVISITID)) .And.;
				!Empty(oInfo:RESULTS[_nX]:FINISHTIME)

					_cQuery2 := " SELECT
					_cQuery2 += " TO_CHAR((TIMESTAMP '1970-01-01 00:00:00' AT TIME ZONE 'UTC'+
					_cQuery2 += " numtodsinterval("+oInfo:RESULTS[_nX]:arrivalTime+",'second'))
					_cQuery2 += " AT time zone tz_offset('"+GetMv("ST_TIMEZN",,"-06:00")+"')) CHEGADA,
					_cQuery2 += " TO_CHAR((TIMESTAMP '1970-01-01 00:00:00' AT TIME ZONE 'UTC'+
					_cQuery2 += " numtodsinterval("+oInfo:RESULTS[_nX]:startTime+",'second'))
					_cQuery2 += " AT time zone tz_offset('"+GetMv("ST_TIMEZN",,"-06:00")+"')) INICIO,
					_cQuery2 += " TO_CHAR((TIMESTAMP '1970-01-01 00:00:00' AT TIME ZONE 'UTC'+
					_cQuery2 += " numtodsinterval("+oInfo:RESULTS[_nX]:finishTime+",'second'))
					_cQuery2 += " AT time zone tz_offset('"+GetMv("ST_TIMEZN",,"-06:00")+"')) FIM
					_cQuery2 += " FROM DUAL

					If !Empty(Select(_cAlias2))
						DbSelectArea(_cAlias2)
						(_cAlias2)->(dbCloseArea())
					Endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

					dbSelectArea(_cAlias2)
					(_cAlias2)->(dbGoTop())

					If (_cAlias2)->(!Eof())
						dData 		:= GETDATA()
						cHrChegad	:= GETTIME((_cAlias2)->CHEGADA)
						cHrStart	:= GETTIME((_cAlias2)->INICIO)
						cHrFinish	:= GETTIME((_cAlias2)->FIM)
					EndIf

					Z55->(RecLock("Z55",.T.))
					Z55->Z55_VISID 	:= oInfo:RESULTS[_nX]:ZFACCOMPLISHEDVISITID
					Z55->Z55_DATA  	:= dData
					Z55->Z55_HORA  	:= cHrChegad
					Z55->Z55_HRINI 	:= cHrStart
					Z55->Z55_HRFIM 	:= cHrFinish
					Z55->Z55_VEND  	:= oInfo:RESULTS[_nX]:ZFAPPUSER:FOREIGNID

					If Type("oInfo:RESULTS["+cValToChar(_nX)+"]:CUSTOMER:FOREIGNID")=="C"
						If SubStr(oInfo:RESULTS[_nX]:CUSTOMER:FOREIGNID,1,3)=="ITC"
							Z55->Z55_CODCLI	:= oInfo:RESULTS[_nX]:CUSTOMER:FOREIGNID
						Else
							Z55->Z55_CODCLI	:= SubStr(oInfo:RESULTS[_nX]:CUSTOMER:FOREIGNID,0,6)
							Z55->Z55_LOJCLI	:= SubStr(oInfo:RESULTS[_nX]:CUSTOMER:FOREIGNID,7,2)
						EndIf
					EndIf

					Z55->Z55_NOMCLI := oInfo:RESULTS[_nX]:CUSTOMER:NAME
					Z55->Z55_MOTIVO := oInfo:RESULTS[_nX]:ZFVISITTYPEID
					Z55->Z55_RESULT := oInfo:RESULTS[_nX]:ZFVISITRESULTID

					For _nA:=1 To Len(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES)
						If AllTrim(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:ZFQUIZID)=="376" //Obras
							For _nB:=1 To Len(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS)
								For _nC:=1 To Len(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS)
									If AllTrim(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:ZFQUIZQUESTIONID)=="3759"
										Z55->Z55_OBSTA := GETSTAOB(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:COLUMNAANSWER)
										If ZZ5->(DbSeek(xFilial("ZZ5")+SubStr(Z55->Z55_CODCLI,5,10)))
											ZZ5->(RecLock("ZZ5",.F.))
											ZZ5->ZZ5_STATUS := Z55->Z55_OBSTA
											ZZ5->(MsUnLock())
										EndIf
									ElseIf AllTrim(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:ZFQUIZQUESTIONID)=="19733"
										If ZZ5->(DbSeek(xFilial("ZZ5")+SubStr(Z55->Z55_CODCLI,5,10)))
											ZZ5->(RecLock("ZZ5",.F.))
											ZZ5->ZZ5_OBS := oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:COLUMNAANSWER+CHR(13)+CHR(10)+ZZ5->ZZ5_OBS
											ZZ5->(MsUnLock())
										EndIf
									ElseIf AllTrim(oInfo:RESULTS[_nX]:ANSWEREDQUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:ZFQUIZQUESTIONID)=="19734"

										_cQuery2 := " SELECT
										_cQuery2 += " TO_CHAR((TIMESTAMP '1970-01-01 00:00:00' AT TIME ZONE 'UTC'+
										_cQuery2 += " numtodsinterval("+oInfo:RESULTS[_nX]:QUIZZES[_nA]:QUESTIONS[_nB]:ANSWERS[_nC]:COLUMNAANSWER+",'second'))
										_cQuery2 += " AT time zone tz_offset('"+GetMv("ST_TIMEZN",,"-06:00")+"')) CHEGADA
										_cQuery2 += " FROM DUAL

										If !Empty(Select(_cAlias2))
											DbSelectArea(_cAlias2)
											(_cAlias2)->(dbCloseArea())
										Endif

										dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

										dbSelectArea(_cAlias2)
										(_cAlias2)->(dbGoTop())

										dDtReto := CTOD("  /  /    ")

										If (_cAlias2)->(!Eof())
											dDtReto		:= GetData()
										EndIf

										If ZZ5->(DbSeek(xFilial("ZZ5")+SubStr(Z55->Z55_CODCLI,5,10)))
											ZZ5->(RecLock("ZZ5",.F.))
											ZZ5->ZZ5_DTRETO := dDtReto
											ZZ5->(MsUnLock())
											
											U_STEITC01(4)
											
										EndIf
									EndIf
								Next
							Next
						EndIf
					Next

					Z55->(MsUnLock())

				EndIf

			Next

			If Type("oInfo:PAGINATION:LASTPAGE")=="N"
				If _nCurPage==oInfo:PAGINATION:LASTPAGE
					Exit
				EndIf
				_nCurPage++
			Else
				Exit
			EndIf

		EndDo

	Next

	ConOut("[STFAT270]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

/*/{Protheus.doc} GETDATA
@name GETDATA
@type Static Function
@desc ajustar data
@author Renato Nogueira
@since 18/11/2019
/*/

Static Function GETDATA()

	_cData := StrTran(SubStr((_cAlias2)->CHEGADA,1,9),"-","/")

	Do Case
		Case "JAN" $ _cData
		_cData := StrTran(_cData,"JAN","01")
		Case "FEB" $ _cData
		_cData := StrTran(_cData,"FEB","02")
		Case "MAR" $ _cData
		_cData := StrTran(_cData,"MAR","03")
		Case "APR" $ _cData
		_cData := StrTran(_cData,"APR","04")
		Case "MAY" $ _cData
		_cData := StrTran(_cData,"MAY","05")
		Case "JUN" $ _cData
		_cData := StrTran(_cData,"JUN","06")
		Case "JUL" $ _cData
		_cData := StrTran(_cData,"JUL","07")
		Case "AUG" $ _cData
		_cData := StrTran(_cData,"AUG","08")
		Case "SEP" $ _cData
		_cData := StrTran(_cData,"SEP","09")
		Case "OCT" $ _cData
		_cData := StrTran(_cData,"OCT","10")
		Case "NOV" $ _cData
		_cData := StrTran(_cData,"NOV","11")
		Case "DEC" $ _cData
		_cData := StrTran(_cData,"DEC","12")
	EndCase

	_dData := CTOD(_cData)

Return(_dData)

/*/{Protheus.doc} GETTIME
@name GETTIME
@type Static Function
@desc ajustar hora
@author Renato Nogueira
@since 18/11/2019
/*/

Static Function GETTIME(_sTime)

	_cHora := SubStr(_sTime,11,2)

	If "PM" $ _sTime
		_cHora := PADL(Val(_cHora)+12,2,"0")
	EndIf

	_sTime := _cHora+SubStr(_sTime,13,6)

	_cTime := StrTran(_sTime,".",":")

Return(_cTime)

/*/{Protheus.doc} GETSTAOB
@name GETSTAOB
@type Static Function
@desc pegar status da obra
@author Renato Nogueira
@since 18/11/2019
/*/

Static Function GETSTAOB(_cStatus)

	_cStatus := UPPER(AllTrim(_cStatus))

	Do Case
		Case _cStatus=="AGUARD VISITA"
		_cRet := "O"
		Case _cStatus=="SOMEN TERRENO"
		_cRet := "1"
		Case _cStatus=="LIMP TERRENO"
		_cRet := "2"
		Case _cStatus=="STAND"
		_cRet := "3"
		Case _cStatus=="FUNDACAO"
		_cRet := "4"
		Case _cStatus=="EM CONSTRUCAO"
		_cRet := "5"
		Case _cStatus=="OBRA PARADA"
		_cRet := "6"
		Case _cStatus=="OBRA PRONTA"
		_cRet := "7"
		Case _cStatus=="OUTROS"
		_cRet := "8"
		Case _cStatus=="FINALIZ"
		_cRet := "9"
	EndCase

Return(_cRet)
