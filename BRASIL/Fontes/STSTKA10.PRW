#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STSTKA10        | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA IMPORTAR EMPRESAS E PESSOAS PARA MOVIDESK                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSTKA10()

	Local _cToken		:= "b30f4526-7f7e-4f01-ac5d-aaa40d5c0ffe"
	Local nTimeOut 		:= 60
	Local aHeadOut 		:= {}
	Local cHeadRet 		:= ""
	Local _cQuery1 		:= ""
	Local _cAlias1 		:= ""
	Local _cUrl 		:= "https://api.movidesk.com/public/v1/persons?token="+_cToken

	If IsBlind()
		RpcSetType( 3 )
		RpcSetEnv("01","01",,,"FAT")
	EndIf

	aAdd( aHeadOut , "Content-type:application/json")

	_cAlias1 		:= GetNextAlias()

	ConOut("[STSTKA10]["+ FWTimeStamp(2) +"] Iniciando envio de empresas para movidesk.")

	//Cadastro de empresas
	_cQuery1 := " SELECT '01' EMPRESA, A1_COD||A1_LOJA CODIGO, A1_CGC, A1_NOME, A1_NREDUZ, A1_TEL, A1_XNOMZ
	_cQuery1 += " FROM SA1010 A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND SUBSTR(A1_COD,1,1)<>'E' AND A1_CGC<>' ' AND A1_NOME NOT LIKE '%STECK%'

	If IsBlind()
		_cQuery1 += " AND TO_CHAR(TO_DATE('19960101','YYYYMMDD')+((ASCII(SUBSTR(A1_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTR(A1_USERLGI,16,1)) - 50)),'YYYYMMDD')>='"+DTOS(Date()-GetMv("STSTKA101",,5))+"'
	Else
		_cQuery1 += " AND A1_COD='"+SA1->A1_COD+"'
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nCount := 0

	While (_cAlias1)->(!Eof())

		_nCount++

		_cBody := '{
		_cBody += '  "id": "'+(_cAlias1)->EMPRESA+'_'+(_cAlias1)->CODIGO+'",
		_cBody += '  "codRefAdditional": "'+(_cAlias1)->EMPRESA+'_'+(_cAlias1)->CODIGO+'",
		_cBody += '  "isActive": true,
		_cBody += '  "personType": 2,
		_cBody += '  "profileType": 2,
		_cBody += '  "accessProfile": "Perfil - Usuários Comuns (Clientes)",
		_cBody += '  "businessName": "'+AllTrim((_cAlias1)->A1_NREDUZ)+'",
		If !Empty(AllTrim((_cAlias1)->A1_XNOMZ))
			_cBody += '  "corporateName": "'+AllTrim((_cAlias1)->A1_XNOMZ)+'",
		Else
			_cBody += '  "corporateName": "'+AllTrim((_cAlias1)->A1_NOME)+'",
		EndIf
		_cBody += '  "cpfCnpj": "'+AllTrim((_cAlias1)->A1_CGC)+'"
		_cBody += '}

		_cJson := EncodeUTF8(_cBody)

		cHttpPost := HTTPPost (_cUrl, "" , _cJson, nTimeOut, aHeadOut, @cHeadRet )

		ConOut("[STSTKA10]["+ FWTimeStamp(2) +"] - Cliente "+CVALTOCHAR(_nCount))

		(_cAlias1)->(DbSkip())
	EndDo

	ConOut("[STSTKA10]["+ FWTimeStamp(2) +"] Iniciando envio de pessoas para movidesk.")

	//Cadastro de pessoas
	_cQuery1 := " SELECT DISTINCT '01_'||A1_COD||A1_LOJA CODIGO, A1_CGC, U5_CODCONT, U5_CONTAT, U5_DDD, U5_FONE, U5_CELULAR, U5_FCOM1, U5_EMAIL
	_cQuery1 += " FROM SA1010 A1
	_cQuery1 += " LEFT JOIN SUA010 UA
	_cQuery1 += " ON UA_CLIENTE=A1_COD AND UA_LOJA=A1_LOJA
	_cQuery1 += " LEFT JOIN SU5010 U5
	_cQuery1 += " ON U5_CODCONT=UA_CODCONT
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND U5.D_E_L_E_T_=' ' AND UA.D_E_L_E_T_=' ' AND U5_EMAIL<>' '

	If IsBlind()
		_cQuery1 += " AND TO_CHAR(TO_DATE('19960101','YYYYMMDD')+((ASCII(SUBSTR(U5_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTR(U5_USERLGI,16,1)) - 50)),'YYYYMMDD')>='"+DTOS(Date()-GetMv("STSTKA101",,5))+"'
	Else
		_cQuery1 += " AND A1_COD='"+SA1->A1_COD+"'
	EndIf
	//_cQuery1 += " AND A1_COD='082156'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nCount := 0

	While (_cAlias1)->(!Eof())

		_nCount++

		_cBody := ' {
		_cBody += '   "id": "'+AllTrim((_cAlias1)->U5_EMAIL)+'",
		_cBody += '   "codRefAdditional": "'+AllTrim((_cAlias1)->U5_EMAIL)+'",
		_cBody += '   "isActive": true,
		_cBody += '   "personType": 1,
		_cBody += '   "profileType": 2,
		_cBody += '   "accessProfile": "Perfil - Usuários Comuns (Clientes)",
		_cBody += '   "businessName": "'+AllTrim((_cAlias1)->U5_CONTAT)+'",
		_cBody += '   "corporateName": "'+AllTrim((_cAlias1)->U5_CONTAT)+'",
		_cBody += '   "cpfCnpj": "",
		_cBody += '  "relationships": [
		_cBody += '       {
		_cBody += '         "id": "'+AllTrim((_cAlias1)->CODIGO)+'"
		_cBody += '       }
		_cBody += '     ],
		_cBody += '   "contacts": [
		_cBody += '   	{"contactType": "Telefone Comercial", "contact": "+55'+AllTrim((_cAlias1)->U5_DDD+(_cAlias1)->U5_FONE)+'"}
		_cBody += '   	],
		_cBody += '   	"emails": [
		_cBody += '   		{"emailType": "Proffisional", "email": "'+AllTrim(UPPER((_cAlias1)->U5_EMAIL))+'"}]
		_cBody += ' }

		_cBody := STTIRAGR(_cBody)
		_cJson := EncodeUTF8(_cBody)

		cHttpPost := HTTPPost (_cUrl, "" , _cJson, nTimeOut, aHeadOut, @cHeadRet )

		ConOut("[STSTKA10]["+ FWTimeStamp(2) +"] - Pessoa "+CVALTOCHAR(_nCount))

		(_cAlias1)->(DbSkip())
	EndDo

	ConOut("[STSTKA10]["+ FWTimeStamp(2) +"] Rotina finalizada.")

	If !IsBlind()
		MsgAlert("Cliente enviado com sucesso, obrigado!")
	EndIf

Return()

Static Function STTIRAGR(_cStrRec)

	Default _cStrRec := ""

	_cStrRec = StrTran (_cStrRec, "á", "a")
	_cStrRec = StrTran (_cStrRec, "é", "e")
	_cStrRec = StrTran (_cStrRec, "í", "i")
	_cStrRec = StrTran (_cStrRec, "ó", "o")
	_cStrRec = StrTran (_cStrRec, "ú", "u")
	_cStrRec = StrTran (_cStrRec, "Á", "A")
	_cStrRec = StrTran (_cStrRec, "É", "E")
	_cStrRec = StrTran (_cStrRec, "Í", "I")
	_cStrRec = StrTran (_cStrRec, "Ó", "O")
	_cStrRec = StrTran (_cStrRec, "Ú", "U")
	_cStrRec = StrTran (_cStrRec, "ã", "a")
	_cStrRec = StrTran (_cStrRec, "õ", "o")
	_cStrRec = StrTran (_cStrRec, "Ã", "A")
	_cStrRec = StrTran (_cStrRec, "Õ", "O")
	_cStrRec = StrTran (_cStrRec, "â", "a")
	_cStrRec = StrTran (_cStrRec, "ê", "e")
	_cStrRec = StrTran (_cStrRec, "î", "i")
	_cStrRec = StrTran (_cStrRec, "ô", "o")
	_cStrRec = StrTran (_cStrRec, "û", "u")
	_cStrRec = StrTran (_cStrRec, "Â", "A")
	_cStrRec = StrTran (_cStrRec, "Ê", "E")
	_cStrRec = StrTran (_cStrRec, "Î", "I")
	_cStrRec = StrTran (_cStrRec, "Ô", "O")
	_cStrRec = StrTran (_cStrRec, "Û", "U")
	_cStrRec = StrTran (_cStrRec, "ç", "c")
	_cStrRec = StrTran (_cStrRec, "Ç", "C")
	_cStrRec = StrTran (_cStrRec, "à", "a")
	_cStrRec = StrTran (_cStrRec, "À", "A")
	_cStrRec = StrTran (_cStrRec, "º", ".")
	_cStrRec = StrTran (_cStrRec, "ª", ".")
	_cStrRec = StrTran (_cStrRec, chr (9), " ")
	_cStrRec = StrTran (_cStrRec, "Ø", "")
	_cStrRec = StrTran (_cStrRec, "ø", "")
	_cStrRec = StrTran (_cStrRec, "&", "E")

	_cStrRet := _cStrRec

Return(_cStrRet)