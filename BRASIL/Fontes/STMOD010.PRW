#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STMOD010        | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA CRIAR USUARIOS NO MOODLE STECK                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMOD010()

	Local _cToken		:= ""
	Local _cFunc		:= "core_user_create_users"
	Local nTimeOut 		:= 60
	Local aHeadOut 		:= {}
	Local cHeadRet 		:= ""
	Local _cQuery1 		:= ""
	Local _cAlias1 		:= ""
	Local _cUrl 		:= "http://mail2.steck.com.br:8355/moodle/webservice/rest/server.php?

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	aAdd( aHeadOut , "Content-type:application/json;charset=UTF-8")

	_cAlias1 		:= GetNextAlias()

	_cToken := GetMv("ST_TOKMOD",,"e8bc8a3b76149d6ebee4720883455ee1")

	aAdd( aHeadOut , "Accept: application/json")
	aAdd( aHeadOut , "Content-type: application/json;charset=UTF-8")

	_cQuery1 += " SELECT EMP, RA_FILIAL, NOME , SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, QB_DESCRIC, CCH_PAIS, RA_CODIGO, MAX(RD0_CODIGO) RD0_COD
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT '01' EMP, RA_FILIAL, SUBSTR(RA_NOME,1,INSTR(RA_NOME,' ')) NOME ,SUBSTR(RA_NOME,INSTR(RA_NOME,' ')+1,999) SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, RD0_CODIGO, QB_DESCRIC, CCH_PAIS, RA_CODIGO
	_cQuery1 += " FROM SRA010 RA
	_cQuery1 += " LEFT JOIN RD0010 RD
	_cQuery1 += " ON RA_CIC=RD0_CIC
	_cQuery1 += " LEFT JOIN SQB010 QB
	_cQuery1 += " ON QB_DEPTO=RA_DEPTO
	_cQuery1 += " LEFT JOIN CCH010 CCH
	_cQuery1 += " ON CCH_CODIGO=RA_NACIONC
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RD.D_E_L_E_T_=' ' AND QB.D_E_L_E_T_=' ' AND CCH.D_E_L_E_T_=' ' AND RA_FILIAL<>'01'
	_cQuery1 += " AND RA_DEMISSA=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " GROUP BY EMP, RA_FILIAL, NOME , SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, QB_DESCRIC, CCH_PAIS, RA_CODIGO
	_cQuery1 += " UNION ALL
	_cQuery1 += " SELECT EMP, RA_FILIAL, NOME , SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, QB_DESCRIC, CCH_PAIS, RA_CODIGO, MAX(RD0_CODIGO) RD0_COD
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT '03' EMP, RA_FILIAL, SUBSTR(RA_NOME,1,INSTR(RA_NOME,' ')) NOME ,SUBSTR(RA_NOME,INSTR(RA_NOME,' ')+1,999) SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, RD0_CODIGO, QB_DESCRIC, CCH_PAIS, RA_CODIGO
	_cQuery1 += " FROM SRA030 RA
	_cQuery1 += " LEFT JOIN RD0030 RD
	_cQuery1 += " ON RA_CIC=RD0_CIC
	_cQuery1 += " LEFT JOIN SQB030 QB
	_cQuery1 += " ON QB_DEPTO=RA_DEPTO
	_cQuery1 += " LEFT JOIN CCH030 CCH
	_cQuery1 += " ON CCH_CODIGO=RA_NACIONC
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RD.D_E_L_E_T_=' ' AND QB.D_E_L_E_T_=' ' AND CCH.D_E_L_E_T_=' '
	_cQuery1 += " AND RA_DEMISSA=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " GROUP BY EMP, RA_FILIAL, NOME , SOBRENOME, RA_EMAIL,RA_MUNICIP,
	_cQuery1 += " RA_NACIONC,
	_cQuery1 += " RA_DEPTO, RA_MAT, RA_CIC, RD0_LOGIN, RD0_SENHA, QB_DESCRIC, CCH_PAIS, RA_CODIGO

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC7")

	While (_cAlias1)->(!Eof())

		_cParam := ""

		_cParam += "wstoken="+escape(_cToken)

		If !Empty((_cAlias1)->RA_CODIGO)
			_cParam += "&wsfunction="+escape("core_user_update_users")
			_cParam += "&users[0][id]="+escape(AllTrim((_cAlias1)->RA_CODIGO))
		Else
			_cParam += "&wsfunction="+escape("core_user_create_users")
		EndIf

		_cParam += "&users[0][username]="+escape(AllTrim((_cAlias1)->RA_CIC))
		_cParam += "&users[0][auth]="+escape("manual")
		_cParam += "&users[0][password]="+escape(AllTrim((_cAlias1)->RD0_SENHA))
		_cParam += "&users[0][firstname]="+escape(Capital(AllTrim((_cAlias1)->NOME)))
		_cParam += "&users[0][lastname]="+escape(Capital(AllTrim((_cAlias1)->SOBRENOME)))

		If !Empty((_cAlias1)->RA_EMAIL)
			_cParam += "&users[0][email]="+escape(AllTrim((_cAlias1)->RA_EMAIL))
		Else
			_cParam += "&users[0][email]="+escape(AllTrim((_cAlias1)->RA_CIC)+"@noemail.com.br")
		EndIf

		_cParam += "&users[0][city]="+escape(Capital(AllTrim((_cAlias1)->RA_MUNICIP)))
		_cParam += "&users[0][country]="+escape(Capital(AllTrim((_cAlias1)->CCH_PAIS)))
		_cParam += "&users[0][customfields][0][type]=filial_cadprotheus&users[0][customfields][0][value]="+escape(AllTrim((_cAlias1)->RA_FILIAL))
		_cParam += "&users[0][customfields][1][type]=emp_cadprotheus&users[0][customfields][1][value]="+escape(AllTrim((_cAlias1)->EMP))
		_cParam += "&users[0][customfields][2][type]=mat_cadprotheus&users[0][customfields][2][value]="+escape(AllTrim((_cAlias1)->RA_MAT))
		_cParam += "&users[0][customfields][3][type]=cpf_cadprotheus&users[0][customfields][3][value]="+escape(Transform(AllTrim((_cAlias1)->RA_CIC),"@R 999.999.999-99"))
		_cParam += "&users[0][customfields][4][type]=profilerole&users[0][customfields][4][value]=escape('Estudante')
		_cParam += "&users[0][customfields][5][type]=department_cadprotheus&users[0][customfields][5][value]="+escape(AllTrim((_cAlias1)->QB_DESCRIC))

		_cJson := '{'
		_cJson += '}'

		_cJson := EncodeUTF8(_cJson)

		//cHttpPost := HTTPSPost (_cUrl, "", "", "", _cParam , _cJson, nTimeOut, aHeadOut, @cHeadRet )
		cHttpPost := HTTPPost (_cUrl, _cParam, "", nTimeOut, aHeadOut, @cHeadRet )

		(_cAlias1)->(DbSkip())
	EndDo

Return()