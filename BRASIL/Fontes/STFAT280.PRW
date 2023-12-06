#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT280        | Autor | RENATO.OLIVEIRA           | Data | 21/11/2019  |
|=====================================================================================|
|Descrição | Rotina roteirizar CEPs								                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT280(_aCeps)

	Local _nX 		:= 0
	Local _nY 		:= 0
	Local _cTicGeoP	:= AllTrim(GetMv("ST_TIKGEOP",,"9C6EC80A-CB87-46A6-8700-F772B6B96819"))
	Local cUrl 		:= "https://www.geoportal.com.br/xgeocoder/xCep.aspx?Ticket="+_cTicGeoP+"&cep="
	Local nTimeOut 	:= 120
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}
	Local _cUrl1 	:= "https://www.geoportal.com.br/WS/service.asmx/BestRoute"
	Local nTimeOut1	:= 120
	Local cHeadRet1	:= ""
	Local aHeadOut1	:= {}
	Local cAviso    := ""
	Local cErro	    := ""
	Local _cCordCd  := "-46.5984509;-23.5320673;"
	Local _cCords	:= ""

	DbSelectArea("Z58")
	Z58->(DbSetOrder(1))

	For _nX:=1 To Len(_aCeps)

		_cLat 	:= ""
		_cLon 	:= ""
		cAviso	:= ""
		cErro	:= ""

		If Z58->(DbSeek(xFilial("Z58")+_aCeps[_nX][3]))

			_cLat := Z58->Z58_LAT
			_cLon := Z58->Z58_LON

		Else

			cHttpGet := HttpSGet(cUrl+_aCeps[_nX][3],"","","","",nTimeOut,aHeadOut,@cHeadRet)
			oXml := XmlParser(cHttpGet,"_",@cAviso,@cErro)

			If (Type("oXml:_SQLMAPA:_XCEP:_RUA[2]:_X:TEXT")=="C")
				Z58->(RecLock("Z58",.T.))
				Z58->Z58_CEP := _aCeps[_nX][3]
				Z58->Z58_LAT := oXml:_SQLMAPA:_XCEP:_RUA[2]:_X:TEXT
				Z58->Z58_LON := oXml:_SQLMAPA:_XCEP:_RUA[2]:_Y:TEXT
				Z58->(MsUnLock())
			Else
				MsgAlert("Atenção, não foi encontrada coordenada para o CEP: "+_aCeps[_nX][3]+" da nota "+_aCeps[_nX][1])
				Return(_aCeps)
			EndIf

			_cLat := Z58->Z58_LAT
			_cLon := Z58->Z58_LON

		EndIf

		_aCeps[_nX][4] := _cLat
		_aCeps[_nX][5] := _cLon

	Next

	For _nX:=1 To Len(_aCeps)
		If Empty(_aCeps[_nX][4]) .Or. Empty(_aCeps[_nX][5])
			MsgAlert("Atenção, coordenadas do CEP "+_aCeps[_nX][3]+" não foram encontradas e o romaneio não será roteirizado!")
			Return(_aCeps)
		EndIf
		_cCords += AllTrim(_aCeps[_nX][4])+";"+AllTrim(_aCeps[_nX][5])+";"
	Next

	aAdd( aHeadOut1 , "Content-Type: application/json; charset=utf-8")

	_cJsReq := '{
	_cJsReq += '"ticket": "'+_cTicGeoP+'",
	_cJsReq += '"comando": "Get_Rota_Ordenada",
	_cJsReq += '"parametros":[
	_cJsReq += '{"POSICAO": "'+_cCordCd+_cCords+_cCordCd+'"},
	_cJsReq += '{ "RESUMIDO": true },
	_cJsReq += '{ "TIPO": "Velocidade" },
	_cJsReq += '{ "ROTA_INCOMPLETA": true },
	_cJsReq += '{ "EVITA_RISCOS": true },
	_cJsReq += '{ "EVITA_CONDOMINIOS": true },
	_cJsReq += '{ "EVITA_PEDAGIOS": true },
	_cJsReq += '{ "EVITAR_PONTO": "" },
	_cJsReq += '{ "EVITAR_POLIGONO": "" }
	_cJsReq += ']
	_cJsReq += '}

	_cJsReq := EncodeUTF8(_cJsReq)

	cHttpPost := HTTPSPost (_cUrl1, "", "", "", "", _cJsReq, nTimeOut1, aHeadOut1, @cHeadRet1 )
	cHttpPost := StrTran(cHttpPost,"\")
	cHttpPost := SubStr(cHttpPost,7,Len(cHttpPost)-7)

	oInfo := ""
	_lRet := FWJsonDeserialize(cHttpPost,@oInfo)
	
	Conout(_cJsReq)

	If _lRet
		For _nX:=1 To Len(oInfo:SERVGEOPORTAL:MULTIROTA)
			For _nY:=1 To Len(_aCeps)
				If SubStr(AllTrim(oInfo:SERVGEOPORTAL:MULTIROTA[_nX]:XFIM),1,12)==SubStr(AllTrim(_aCeps[_nY][4]),1,12) .And.;
				SubStr(AllTrim(oInfo:SERVGEOPORTAL:MULTIROTA[_nX]:YFIM),1,12)==SubStr(AllTrim(_aCeps[_nY][5]),1,12)
					_aCeps[_nY][6] := _nX
					Exit
				EndIf
			Next
		Next
	EndIf

Return(_aCeps)