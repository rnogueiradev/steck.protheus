#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | WSVLDUSR         | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|Descrição | Webservice para conferir usuário/senha digitados no portal               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

//WSSTRUCT WSSubjects
	//WSDATA lRetorno				AS BOOLEAN
//ENDWSSTRUCT

WSSERVICE WSVLDUSR DESCRIPTION "Serviço para validar usuário"

	WSDATA _cLogin		AS STRING
	WSDATA _cPassword	AS STRING
	//WSDATA aRetorno  	AS ARRAY OF WSSubjects
	WSDATA lRetorno				AS BOOLEAN
	WSDATA _cXml  		AS STRING

	WSMETHOD Logar DESCRIPTION "Método que retorna se o usuário e senha estão corretos"
	WSMETHOD LogarMoodle DESCRIPTION "Método que retorna se o usuário e senha estão corretos - Moodle"

ENDWSSERVICE

WSMETHOD Logar WSRECEIVE _cLogin,_cPassword WSSEND _cXml WSSERVICE WSVLDUSR

	Local _aUser := {}

	::lRetorno	:= .F.

	// indice 2 - por login
	PswOrder(2)

	If PswSeek(::_cLogin,.T.)
		// retorna array com dados do usuario
		_aUser := PswRet()
		// verifico se a senha esta correta
		If PswName(::_cPassword)
			::lRetorno    := .T.
		Else
			::lRetorno    := .F.
		Endif
	EndIf

	If !::lRetorno

		// indice 1 - por ID
		PswOrder(1)

		If PswSeek(::_cLogin,.T.)
			// retorna array com dados do usuario
			_aUser := PswRet()
			// verifico se a senha esta correta
			If PswName(::_cPassword)
				::lRetorno    := .T.
			Else
				::lRetorno    := .F.
			Endif
		EndIf

	EndIf

Return .T.

WSMETHOD LogarMoodle WSRECEIVE _cLogin,_cPassword WSSEND lRetorno WSSERVICE WSVLDUSR

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	cONOUT(::_cLogin)
	cONOUT(::_cPassword)

	//::aRetorno := {}
	//AAdd(::aRetorno, WSClassNew("WSSubjects"))

	_cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("RD0")+" RD
	_cQuery1 += " WHERE RD.D_E_L_E_T_=' ' AND RD0_USER='"+::_cLogin+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		//i := Len(::aRetorno)
		//::aRetorno[i]:lRetorno      := .F.
		::lRetorno := .F.
		CONOUT(1)
	Else
		If Embaralha(AllTrim((_cAlias1)->RD0_SENHA),1)==AllTrim(::_cPassword)
			//i := Len(::aRetorno)
			//::aRetorno[1]:lRetorno      := .T.
			::lRetorno := .T.
			CONOUT(2)
		Else
			//i := Len(::aRetorno)
			//::aRetorno[1]:lRetorno      := .F.
			::lRetorno := .F.
			CONOUT(3)
		EndIf
	EndIf

	Conout(Time())

Return .T.