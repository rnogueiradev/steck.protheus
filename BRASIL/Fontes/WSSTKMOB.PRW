#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*====================================================================================\
|Programa  | WSSTKMOB         | Autor | Renato Nogueira            | Data | 14/03/2019|
|=====================================================================================|
|Descrição | Webservice para realizar as comunicações com o stkMobile		          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                       |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSSERVICE WSSTKMOB DESCRIPTION "Serviço para comunicações com o app Steck"

	WSDATA _cLogin		AS STRING
	WSDATA _cPassword	AS STRING
	WSDATA _cXmlRet		AS STRING
	WSDATA _cXmlRec		AS STRING
	WSDATA _cRom		AS STRING
	WSDATA _cNf			AS STRING

	WSMETHOD Logar DESCRIPTION "Método que retorna se o usuário e senha estão corretos"
	WSMETHOD GetFat DESCRIPTION "Método que retorna os dados de faturamento"
	WSMETHOD GetRom DESCRIPTION "Método que retorna os romaneios abertos"
	WSMETHOD BaixaNF DESCRIPTION "Método que realiza a baixa da NF num romaneio"

ENDWSSERVICE

WSMETHOD Logar WSRECEIVE _cLogin,_cPassword WSSEND _cXmlRet WSSERVICE WSSTKMOB

	Local _aUser 	:= {}
	Local _cStatus	:= ""
	Local _cAcessos := ""
	Local _cTipo	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	Conout("[WSSTKMOB][LOGAR]["+FwTimeStamp(2)+"] - Tentativa de login com o usuario: "+::_cLogin)

	PswOrder(2)

	If PswSeek(::_cLogin,.T.)
		// retorna array com dados do usuario
		_aUser := PswRet()
		// verifico se a senha esta correta
		If PswName(::_cPassword)
			_cStatus := "OK"
			_cTipo   := "2"
		Else
			_cStatus := "ERRO"
		Endif
	EndIf

	If AllTrim(_cStatus)=="ERRO" .Or. Empty(_cStatus)

		// indice 1 - por ID
		PswOrder(1)

		If PswSeek(::_cLogin,.T.)
			// retorna array com dados do usuario
			_aUser := PswRet()
			// verifico se a senha esta correta
			If PswName(::_cPassword)
				_cStatus := "OK"
				_cTipo   := "1"
			Else
				_cStatus := "ERRO"
			Endif
		EndIf

	EndIf

	If AllTrim(_cStatus)=="OK"

		_cAcessos += "X"

		If _cTipo=="1" //ID
			If AllTrim(::_cLogin) $ GetMv("STKMOBFAT1",,"000000#000010#000591")
				_cAcessos += "X"
			EndIf
		Else
			If AllTrim(::_cLogin) $ GetMv("STKMOBFAT2",,"Administrador#renato.oliveira#klecios.souza")
				_cAcessos += "X"
			EndIf
		EndIf

	EndIf

	_cXml := "<login><resultado>
	_cXml += "<status>"+_cStatus+"</status>
	_cXml += "<acessos>"+_cAcessos+"</acessos>
	_cXml += "</resultado></login>

	::_cXmlRet := _cXml

Return .T.

WSMETHOD GetFat WSRECEIVE _cLogin,_cPassword WSSEND _cXmlRet WSSERVICE WSSTKMOB

	Local cResp 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	//Faturamento BR
	_cQuery1:= " SELECT NVL(SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM),0) AS TOTAL,
	_cQuery1+= " NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) else 0 end ),0) as DIA
	_cQuery1+= " FROM SD2010 SD2 WHERE SD2.D_E_L_E_T_ = ' '    AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502'
	_cQuery1+= " )
	_cQuery1+= " AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'  and d2_filial ='02' "

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_nFatMesBr := (_cAlias1)->TOTAL
		_nFatDiaBr := (_cAlias1)->DIA
	EndIf

	//Devoluções BR
	_cQuery1:= " SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) as	TOTAL ,
	_cQuery1+= " NVL(sum(case when D1_EMISSAO = '"+ dtos(date()) +"'  then (D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) else 0 end ),0) DIA
	_cQuery1+= " FROM  SD1010  SD1   INNER JOIN(SELECT * FROM   SA1010 )SA1   ON SA1.D_E_L_E_T_ = ' '   AND SD1.D1_TIPO = 'D'   AND SA1.A1_COD = SD1.D1_FORNECE  AND SA1.A1_LOJA = SD1.D1_LOJA   AND SA1.A1_FILIAL = '  '
	_cQuery1+= " INNER JOIN ( SELECT * FROM SB1010 )SB1  ON SB1.D_E_L_E_T_   = ' '  AND SB1.B1_COD    = SD1.D1_COD   AND SB1.B1_FILIAL = ' ' 	INNER JOIN(SELECT * FROM SF2010 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
	_cQuery1+= " WHERE  SD1.D_E_L_E_T_ = ' '   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	_cQuery1+= " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '02')   AND SUBSTR(SD1.D1_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_nFatMesBr := _nFatMesBr-(_cAlias1)->TOTAL
		_nFatDiaBr := _nFatDiaBr-(_cAlias1)->DIA
	EndIf

	_nFatMetBr := GetMv("ST_METABR")

	_cQuery1:= " 	SELECT
	_cQuery1+= " SUM(SD2.D2_TOTAL) AS TOTAL,
	_cQuery1+= " NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then d2_total else 0 end ),0) as DIA
	_cQuery1+= " FROM SD2070 SD2
	_cQuery1+= " INNER JOIN(SELECT * FROM SF4070)SF4
	_cQuery1+= " ON SF4.D_E_L_E_T_ = ' '
	_cQuery1+= " AND F4_CODIGO = D2_TES
	_cQuery1+= " AND F4_DUPLIC = 'S'
	_cQuery1+= " WHERE SD2.D_E_L_E_T_ = ' '
	_cQuery1+= " AND D2_SERIE <> 'R'
	_cQuery1+= " AND D2_ESPECIE = 'NF'
	_cQuery1+= " AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'  and d2_filial ='01' "

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_nFatMesAr := (_cAlias1)->TOTAL
		_nFatDiaAr := (_cAlias1)->DIA
	EndIf

	_nFatMetAr := GetMv("ST_METAAR")

	cResp := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
	cResp += '<xml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	cResp += '<faturamento>
	cResp += '<pais>BRA</pais><atingido>'+cValTochar(_nFatMesBr)+'</atingido><restante>'+cValToChar(IIf(_nFatMetBr-_nFatMesBr<0,0,_nFatMetBr-_nFatMesBr))+'</restante><vlrmensal>'+AllTrim(Transform(_nFatMesBr,"@E 999,999,999.99"))+'</vlrmensal><vlrdiario>'+AllTrim(Transform(_nFatDiaBr,"@E 999,999,999.99"))+'</vlrdiario>
	cResp += '</faturamento>
	cResp += '<faturamento>
	cResp += '<pais>ARG</pais><atingido>'+cValTochar(_nFatMesAr)+'</atingido><restante>'+cValToChar(IIf(_nFatMetAr-_nFatMesAr<0,0,_nFatMetAr-_nFatMesAr))+'</restante><vlrmensal>'+AllTrim(Transform(_nFatMesAr,"@E 999,999,999.99"))+'</vlrmensal><vlrdiario>'+AllTrim(Transform(_nFatDiaAr,"@E 999,999,999.99"))+'</vlrdiario>
	cResp += '</faturamento>
	cResp += '</xml>

	::_cXmlRet := cResp

Return .T.

WSMETHOD GetRom WSRECEIVE _cLogin,_cPassword WSSEND _cXmlRet WSSERVICE WSSTKMOB

	Local cResp 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= ""
	Local _cQuery3 	:= ""
	Local _cAlias3 	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()
	_cAlias3 := GetNextAlias()

	_cQuery1 := " SELECT PD1_FILIAL, PD1_CODROM
	_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
	_cQuery1 += " WHERE PD1.D_E_L_E_T_=' '
	_cQuery1 += " AND PD1_PLACA='FFS 0453' AND PD1_STATUS='0'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	cResp := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
	cResp += '<xml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	If (_cAlias1)->(!Eof())

		While (_cAlias1)->(!Eof())

			cResp += '<romaneio>
			cResp += '<key>'+(_cAlias1)->PD1_CODROM+'</key>
			cResp += '<id>'+(_cAlias1)->PD1_CODROM+'</id>
			cResp += '<name>'+(_cAlias1)->PD1_CODROM+'</name>
			cResp += '</romaneio>

			cResp += '<romaneiocompleto>
			cResp += '<id>'+(_cAlias1)->PD1_CODROM+'</id>
			cResp += '<notas>

			_cQuery2 := " SELECT F2_DOC, F2_CHVNFE, PD2_SERIES, PD2_CLIENT, PD2_LOJCLI
			_cQuery2 += " FROM "+RetSqlName("PD1")+" PD1
			_cQuery2 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
			_cQuery2 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
			_cQuery2 += " LEFT JOIN "+RetSqlName("SF2")+" F2
			_cQuery2 += " ON F2_FILIAL=PD2_FILIAL AND F2_DOC=PD2_NFS
			_cQuery2 += " AND F2_SERIE=PD2_SERIES AND F2_CLIENTE=PD2_CLIENT AND F2_LOJA=PD2_LOJCLI
			_cQuery2 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '
			_cQuery2 += " AND F2.D_E_L_E_T_=' '
			_cQuery2 += " AND PD1_FILIAL='"+(_cAlias1)->PD1_FILIAL+"' AND PD1_CODROM='"+(_cAlias1)->PD1_CODROM+"'

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)

			(_cAlias2)->(dbGoTop())

			While (_cAlias2)->(!Eof())

				cResp += '<nota>
				cResp += '<numero>'+(_cAlias2)->F2_DOC+'</numero>
				cResp += '<chave>'+(_cAlias2)->F2_CHVNFE+'</chave>

				cResp += '<volumes>'

				_cQuery3 := " SELECT CB6_VOLUME
				_cQuery3 += " FROM "+RetSqlName("PD1")+" PD1
				_cQuery3 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
				_cQuery3 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
				_cQuery3 += " LEFT JOIN "+RetSqlName("SF2")+" F2
				_cQuery3 += " ON F2_FILIAL=PD2_FILIAL AND F2_DOC=PD2_NFS
				_cQuery3 += " AND F2_SERIE=PD2_SERIES AND F2_CLIENTE=PD2_CLIENT AND F2_LOJA=PD2_LOJCLI
				_cQuery3 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
				_cQuery3 += " ON CB7_FILIAL=F2_FILIAL AND CB7_NOTA=F2_DOC
				_cQuery3 += " AND CB7_SERIE=F2_SERIE AND CB7_CLIENT=F2_CLIENTE AND CB7_LOJA=F2_LOJA
				_cQuery3 += " LEFT JOIN "+RetSqlName("CB6")+" CB6
				_cQuery3 += " ON CB6_FILIAL=CB7_FILIAL AND CB7_PEDIDO=CB6_PEDIDO AND CB7_ORDSEP=CB6_XORDSE
				_cQuery3 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '
				_cQuery3 += " AND F2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' '
				_cQuery3 += " AND PD1_FILIAL='"+(_cAlias1)->PD1_FILIAL+"' AND PD1_CODROM='"+(_cAlias1)->PD1_CODROM+"'
				_cQuery3 += " AND PD2_NFS='"+(_cAlias2)->F2_DOC+"' AND PD2_SERIES='"+(_cAlias2)->PD2_SERIES+"'
				_cQuery3 += " ORDER BY PD1_CODROM, F2_DOC, CB6_VOLUME

				If !Empty(Select(_cAlias3))
					DbSelectArea(_cAlias3)
					(_cAlias3)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

				dbSelectArea(_cAlias3)

				(_cAlias3)->(dbGoTop())

				_nVolumes := 0

				While (_cAlias3)->(!Eof())

					_nVolumes++

					cResp += '<volume>'+(_cAlias3)->CB6_VOLUME+'</volume>'
					cResp += '<bipado>N</bipado>'

					(_cAlias3)->(DbSkip())
				EndDo

				cResp += '<totvol>'+CVALTOCHAR(_nVolumes)+'</totvol>'
				cResp += '</volumes>'

				cResp += '</nota>

				(_cAlias2)->(DbSkip())
			EndDo

			cResp += '</notas>'
			cResp += '</romaneiocompleto>

			(_cAlias1)->(DbSkip())
		EndDo

	EndIf

	cResp += '</xml>

	::_cXmlRet := cResp

Return .T.

WSMETHOD BaixaNf WSRECEIVE _cLogin,_cPassword,_cRom,_cNf WSSEND _cXmlRet WSSERVICE WSSTKMOB

	Local cResp 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cStatus  := "ERRO"

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	conout(::_cRom)
	conout(::_cNf)

	_cQuery1 := " SELECT PD2.R_E_C_N_O_ RECPD2
	_cQuery1 += " FROM "+RetSqlName("PD2")+" PD2
	_cQuery1 += " WHERE PD2.D_E_L_E_T_=' '
	_cQuery1 += " AND PD2_CODROM='"+::_cRom+"' AND PD2_NFS='"+::_cNf+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	cResp := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
	cResp += '<xml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	DbSelectArea("PD2")

	If (_cAlias1)->(!Eof())

		PD2->(DbGoTo((_cAlias1)->RECPD2))

		If PD2->(!Eof())

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS := "2"
			PD2->(MsUnLock())

			_cStatus := "OK"

		EndIf

	EndIf

	cResp += '<notafiscal><status>'+_cStatus+'</status></notafiscal>

	cResp += '</xml>

	::_cXmlRet := cResp

Return .T.