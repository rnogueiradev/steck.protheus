#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTG0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL chkEmei DESCRIPTION "Aplicativo Steck"

WSDATA cEmei As String

WSMETHOD GET DESCRIPTION "Verificar se celular está autorizado a usar a rotina" WSSYNTAX "/rest/chkEmei"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cEmei WSSERVICE chkEmei

	Local cResp 	:= ""
	Local _cEmei    := Self:cEmei
	Local _nX
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	ConOut("[STRESTG0]["+ FWTimeStamp(2) +"] - Usuario "+AllTrim(UsrRetName(__cUserId))+" realizou o acesso.")
	ConOut("[STRESTG0]["+ FWTimeStamp(2) +"] - Dispositivo "+AllTrim(_cEmei)+" tentou acessar a rotina.")

	_cUsuario := AllTrim(UsrRetName(__cUserId))

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	_aDevices := StrTokArr(AllTrim(UPPER(GetMv("APPFATAUT",,""))),"#")
	_lAchou	  := .F.
	/*
	For _nX:=1 To Len(_aDevices)
	If AllTrim(Upper(_cEmei))==_aDevices[_nX]
	_lAchou := .T.
	EndIf
	Next
	*/

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM Z75010 Z75
	_cQuery1 += " WHERE Z75.D_E_L_E_T_=' ' AND UPPER(Z75_CODIGO)='"+AllTrim(Upper(_cEmei))+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_lAchou := .T.
		ConOut("[STRESTG0]["+ FWTimeStamp(2) +"] - Dispositivo de "+AllTrim((_cAlias1)->Z75_NOME)+" autorizado.")
	EndIf

	If _lAchou
		cResp := '{"status": "01"}'
	Else
		cResp := '{"status": "00"}'
	EndIf

	ConOut("[STRESTG0]["+ FWTimeStamp(2) +"] - Resposta: "+cResp)

	::SetResponse(cResp)

Return .T.