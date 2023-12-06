#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*====================================================================================\
|Programa  | WSPRTFUN         | Autor | Renato Nogueira            | Data | 24/09/2019|
|=====================================================================================|
|Descrição | Webservice para realizar as comunicações com o portal do funcionário     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSSERVICE WSPRTFUN DESCRIPTION "Serviço para comunicações com o portal do funcionário"

	WSDATA _cLogin		AS STRING
	WSDATA _cPassword	AS STRING
	WSDATA lRetorno  	AS BOOLEAN
	WSDATA _cXmlEnv		AS STRING
	WSDATA _cXmlRet		AS STRING
	WSDATA _cXml		AS STRING
	WSDATA _cTipo		AS STRING
	WSDATA _cIP			AS STRING

	WSMETHOD GetAprova DESCRIPTION "Método que retorna solicitações para o usuário interagir"
	WSMETHOD SetAprova DESCRIPTION "Método que atualiza as solicitações"
	WSMETHOD Logar DESCRIPTION "Método que retorna se o usuário e senha estão corretos"

ENDWSSERVICE

WSMETHOD GetAprova WSRECEIVE _cXmlEnv WSSEND _cXmlRet WSSERVICE WSPRTFUN

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cUsuario := "renato.oliveira"
	Local _cXml		:= ""
	Local cAviso	:= ""
	Local cErro		:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	_cAlias1  := GetNextAlias()
	
	oXml := XmlParser(_cXmlEnv,"_",@cAviso,@cErro)

	_cQuery1 := " SELECT '01' EMP, C1_FILIAL, C1_NUM, C1_SOLICIT, MAX(C1_OBS) DESCRIC
	_cQuery1 += " ,MAX(utl_raw.cast_to_varchar2(dbms_lob.substr(C1_XOBSU))) OBSUSER
	_cQuery1 += " ,MAX(utl_raw.cast_to_varchar2(dbms_lob.substr(C1_XOBSC))) OBSCOMP
	_cQuery1 += " ,(SUM(C1_XPRC*C1_QUANT)) VALOR
	_cQuery1 += " FROM SC1010 C1
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND (
	_cQuery1 += " (C1_XAPROV1='"+AllTrim(oXml:_GETAPROVA:_USER:TEXT)+"' AND C1_XDTAP1=' ')
	_cQuery1 += " OR
	_cQuery1 += " (C1_XAPROV2='"+AllTrim(oXml:_GETAPROVA:_USER:TEXT)+"' AND C1_XDTAP2=' ')
	_cQuery1 += " )
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM, C1_SOLICIT
	_cQuery1 += " UNION
	_cQuery1 += " SELECT '03' EMP, C1_FILIAL, C1_NUM, C1_SOLICIT, MAX(C1_OBS) DESCRIC
	_cQuery1 += " ,MAX(utl_raw.cast_to_varchar2(dbms_lob.substr(C1_XOBSU))) OBSUSER
	_cQuery1 += " ,MAX(utl_raw.cast_to_varchar2(dbms_lob.substr(C1_XOBSC))) OBSCOMP
	_cQuery1 += " ,(SUM(C1_XPRC*C1_QUANT)) VALOR
	_cQuery1 += " FROM SC1030 C1
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND (
	_cQuery1 += " (C1_XAPROV1='"+AllTrim(oXml:_GETAPROVA:_USER:TEXT)+"' AND C1_XDTAP1=' ')
	_cQuery1 += " OR
	_cQuery1 += " (C1_XAPROV2='"+AllTrim(oXml:_GETAPROVA:_USER:TEXT)+"' AND C1_XDTAP2=' ')
	_cQuery1 += " )
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM, C1_SOLICIT

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cXml := "<getaprova>"

	While (_cAlias1)->(!Eof())

		If AllTrim((_cAlias1)->EMP)=="01"
			_cEmpresa := "Sao Paulo"
		Else
			_cEmpresa := "Manaus"
		EndIf

		_cDesc := AllTrim((_cAlias1)->DESCRIC)
		If Empty(_cDesc)
			_cDesc := "Não possui"
		EndIf

		_cXml += "<solicitacao>
		_cXml += "<empresa>"+_cEmpresa+"</empresa>
		_cXml += "<filial>"+(_cAlias1)->C1_FILIAL+"</filial>
		_cXml += "<numero>"+(_cAlias1)->C1_NUM+"</numero>
		_cXml += "<solicitante>"+(_cAlias1)->C1_SOLICIT+"</solicitante>
		_cXml += "<descricao>"+_cDesc+"</descricao>
		_cXml += "<obscomp>"+(_cAlias1)->OBSCOMP+"</obscomp>
		_cXml += "<obsuser>"+(_cAlias1)->OBSUSER+"</obsuser>
		_cXml += "<valor>R$ "+TRANSFORM((_cAlias1)->VALOR ,"@E 99,999,999,999.99")+"</valor>
		_cXml += "</solicitacao>

		(_cAlias1)->(DbSkip())
	EndDo

	_cXml += "</getaprova>

	::_cXmlRet := _cXml

Return .T.

WSMETHOD SetAprova WSRECEIVE _cXmlEnv,_cTipo WSSEND _cXmlRet WSSERVICE WSPRTFUN

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cXml		:= ""
	Local _nX
	Local _cUser 	:= "renato.oliveira"
	Local _lAtu		:= .F.

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	_cAlias1  := GetNextAlias()

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlEnv,@oInfo)

	DbSelectArea("SC1")

	If Type("oInfo")=="A"
		For _nX:=1 To Len(oInfo)
			If oInfo[_nX]:MARCAR .Or. AllTrim(_cTipo)=="G"

				_cEmpresa := ""
				If AllTrim(oInfo[_nX]:EMPRESA)=="Sao Paulo"
					_cEmpresa := "01"
				ElseIf AllTrim(oInfo[_nX]:EMPRESA)=="Manaus"
					_cEmpresa := "03"
				EndIf

				_cQuery1 := " SELECT *
				_cQuery1 += " FROM SC1"+_cEmpresa+"0 C1
				_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND C1_FILIAL='"+oInfo[_nX]:FILIAL+"'
				_cQuery1 += " AND C1_NUM='"+oInfo[_nX]:SOLICITAO+"'
				_cQuery1 += " AND (
				_cQuery1 += " (C1_XAPROV1='renato.oliveira' AND C1_XDTAP1=' ')
				_cQuery1 += " OR
				_cQuery1 += " (C1_XAPROV2='renato.oliveira' AND C1_XDTAP2=' ')
				_cQuery1 += " )

				If !Empty(Select(_cAlias1))
					DbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

				dbSelectArea(_cAlias1)
				(_cAlias1)->(dbGoTop())

				While (_cAlias1)->(!Eof())

					If oInfo[_nX]:MARCAR

						_cUpdate := "UPDATE SC1"+_cEmpresa+"0"

						If AllTrim((_cAlias1)->C1_XAPROV1)==AllTrim(_cUser)
							_cUpdate += " SET C1_XDTAP1='"+DTOS(Date())+"', C1_XHRAP1='"+Time()+"', C1_XSTAPRO='"+_cTipo+"'
						ElseIf AllTrim((_cAlias1)->C1_XAPROV2)==AllTrim(_cUser)
							_cUpdate += " SET C1_XDTAP2='"+DTOS(Date())+"', C1_XHRAP2='"+Time()+"', C1_XSTAPRO='"+_cTipo+"'
						EndIf
						_cUpdate += " WHERE R_E_C_N_O_="+cValToChar((_cAlias1)->R_E_C_N_O_)

						TcSqlExec(_cUpdate)

					ElseIf AllTrim(_cTipo)=="G"

						_cUpdate := "UPDATE SC1"+_cEmpresa+"0"
						_cUpdate += " SET C1_XOBSU=RAWTOHEX('"+AllTrim(oInfo[_nX]:USUARIO)+"')
						_cUpdate += " WHERE R_E_C_N_O_="+cValToChar((_cAlias1)->R_E_C_N_O_)

						TcSqlExec(_cUpdate)

						conout(_cupdate)

					EndIf

					_lAtu := .T.

					(_cAlias1)->(DbSkip())
				EndDo

			EndIf
		Next
	EndIf

	If _lAtu
		_cXml := "[OK] - Registros atualizados com sucesso, obrigado!"
	Else
		_cXml := "[ERRO] - Problema ao atualizar os registros, entre em contato com o TI!"
	EndIf

	::_cXmlRet := _cXml

Return .T.

WSMETHOD Logar WSRECEIVE _cLogin,_cPassword,_cIp WSSEND _cXml WSSERVICE WSPRTFUN

	Local _aUser 	:= {}
	Local _lRet		:= .F.

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	PswOrder(2)

	If PswSeek(::_cLogin,.T.)
		_aUser := PswRet()
		If PswName(::_cPassword)
			_lRet := .T.
		Else
			_lRet := .F.
		Endif
	EndIf

	If !_lRet
		PswOrder(1)
		If PswSeek(::_cLogin,.T.)
			_aUser := PswRet()
			If PswName(::_cPassword)
				_lRet := .T.
			Else
				_lRet := .F.
			Endif
		EndIf
	EndIf

	_cXml := "<login><resultado>

	If !_lRet
		_cXml += "<status>ERRO</status>
		_cXml += "<msg>Login e/ou senha incorretos!</msg>
		_cXml += "<user></user>
		_cXml += "<nome></nome>
	Else
		_cXml += "<status>OK</status>
		_cXml += "<msg></msg>
		_cXml += "<user>"+AllTrim(_aUser[1][2])+"</user>
		_cXml += "<nome></nome>
	EndIf

	_cXml += "</resultado></login>

	::_cXml := _cXml

Return .T.