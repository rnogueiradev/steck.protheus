#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STWSFT10         | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|Descrição | Montagem de querys para graficos de vendas						          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STWSFT10(_cVend,_nTipo)

	Local _cQuery1 		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local _cAno	   		:= ""
	Local _cMes	   		:= ""
	Local _cRetorno		:= ""
	Local _cObjetivo	:= ""
	Local _cCaptado		:= ""
	Local _cFatFinal	:= ""
	Local _cCapFinal	:= ""
	Local _cFaturado	:= ""	

	//RpcSetType(3)
	//RpcSetEnv("01","02",,,"FAT")

	_cAno := SubStr(DTOS(Date()),1,4)

	If !(_nTipo==3)

		If _nTipo==2
			_cQuery1 += " SELECT MES, SUM(OBJETIVO) OBJETIVO, SUM(CAPTADO) CAPTADO, SUM(FATURADO) FATURADO, SUM(DEVOLVIDO) DEVOLVIDO
			_cQuery1 += " FROM (
		EndIf

		_cQuery1 += " SELECT CODIGO, NOME, JJJ.MES MES, OBJETIVO, CAPTADO, ROUND(NVL(FATURADO,0),2) FATURADO, ROUND(NVL(DEVOLVIDO,0),2) DEVOLVIDO
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT CODIGO, NOME, MES, SUM(OBJETIVO) OBJETIVO, SUM(CAPTADO) CAPTADO
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT XXX.A3_COD CODIGO, XXX.A3_NOME NOME, XXX.MES MES, XXX.OBJETIVO, ROUND(NVL(YYY.CAPTADO,0),2) CAPTADO
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT A3_COD, A3_NOME, RTRIM(X5_CHAVE) MES, SUM(NVL(ZZD_VALOR,0)) OBJETIVO
		_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
		_cQuery1 += " LEFT JOIN "+RetSqlName("SX5")+" X5
		_cQuery1 += " ON X5_TABELA='_A'
		_cQuery1 += " LEFT JOIN "+RetSqlName("ZZD")+" ZZD
		_cQuery1 += " ON ZZD_VEND=A3_COD AND ZZD.D_E_L_E_T_=' ' AND ZZD_ANO='"+_cAno+"' AND ZZD_MES=X5_CHAVE
		_cQuery1 += " WHERE A3.D_E_L_E_T_=' '  AND X5.D_E_L_E_T_=' '  

		If _nTipo==2
			_cQuery1 += " AND A3_SUPER='"+_cVend+"'
		Else
			_cQuery1 += " AND A3_COD='"+_cVend+"'
		EndIf

		_cQuery1 += " GROUP BY A3_COD, A3_NOME, X5_CHAVE
		_cQuery1 += " ) XXX
		_cQuery1 += " LEFT JOIN (
		_cQuery1 += " 
		_cQuery1 += " SELECT 							SUM(
		_cQuery1 += " 							CASE 
		_cQuery1 += " 								WHEN C6_BLQ = 'R' 
		_cQuery1 += " 								THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT 
		_cQuery1 += " 								ELSE C6_ZVALLIQ 
		_cQuery1 += " 							END) AS CAPTADO, SUBSTR(C5_EMISSAO,5,2) MES, C5_VEND1
		_cQuery1 += " 						FROM
		_cQuery1 += " 							"+RetSqlName("SC6")+" SC6 
		_cQuery1 += " 							INNER JOIN (SELECT
		_cQuery1 += " 											* 
		_cQuery1 += " 										FROM
		_cQuery1 += " 											"+RetSqlName("SB1")+" ) SB1 
		_cQuery1 += " 							ON SB1.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 							SB1.B1_COD = SC6.C6_PRODUTO AND
		_cQuery1 += " 							SB1.B1_FILIAL = '  ' 
		_cQuery1 += " 							INNER JOIN (SELECT
		_cQuery1 += " 											* 
		_cQuery1 += " 										FROM
		_cQuery1 += " 											"+RetSqlName("SC5")+" )SC5 
		_cQuery1 += " 							ON SC5.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 							SC5.C5_NUM = SC6.C6_NUM AND
		_cQuery1 += " 							SC5.C5_FILIAL = SC6.C6_FILIAL 
		_cQuery1 += " AND 							SUBSTR(SC5.C5_EMISSAO , 1 , 4) ='"+_cAno+"' 
		_cQuery1 += " 							INNER JOIN(	SELECT
		_cQuery1 += " 											* 
		_cQuery1 += " 										FROM
		_cQuery1 += " 											"+RetSqlName("SA1")+" ) SA1 
		_cQuery1 += " 							ON SA1.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 							SA1.A1_COD = SC5.C5_CLIENTE AND
		_cQuery1 += " 							SA1.A1_LOJA = SC5.C5_LOJACLI AND
		_cQuery1 += " 							SA1.A1_FILIAL = '  ' 
		_cQuery1 += " 							LEFT JOIN (	SELECT
		_cQuery1 += " 											* 
		_cQuery1 += " 										FROM
		_cQuery1 += " 											"+RetSqlName("PC1")+" )PC1 
		_cQuery1 += " 							ON C6_NUM = PC1.PC1_PEDREP AND
		_cQuery1 += " 							PC1.D_E_L_E_T_ = ' ' 
		_cQuery1 += " 							INNER JOIN (SELECT
		_cQuery1 += " 											* 
		_cQuery1 += " 										FROM
		_cQuery1 += " 											"+RetSqlName("SF4")+" ) SF4 
		_cQuery1 += " 							ON SC6.C6_TES = SF4.F4_CODIGO AND
		_cQuery1 += " 							SF4.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 							SF4.F4_DUPLIC = 'S' 
		_cQuery1 += " 						WHERE
		_cQuery1 += " 							SC6.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 							SC6.C6_FILIAL = '"+cFilAnt+"' AND
		_cQuery1 += " 							SC5.C5_TIPO = 'N' AND
		_cQuery1 += " 							SA1.A1_GRPVEN <> 'ST' AND
		_cQuery1 += " 							SA1.A1_EST <> 'EX' AND
		_cQuery1 += " SUBSTR(SC5.C5_EMISSAO,1,4) ='"+_cAno+"'
		_cQuery1 += " AND							PC1.PC1_PEDREP IS NULL
		_cQuery1 += " GROUP BY SUBSTR(C5_EMISSAO,5,2), C5_VEND1
		_cQuery1 += " 
		_cQuery1 += " ) YYY
		_cQuery1 += " ON XXX.A3_COD=YYY.C5_VEND1 AND XXX.MES=YYY.MES
		_cQuery1 += " ORDER BY A3_COD, MES
		_cQuery1 += " ) WWW
		_cQuery1 += " GROUP BY CODIGO, NOME, MES
		_cQuery1 += " ORDER BY CODIGO, MES
		_cQuery1 += " ) JJJ
		_cQuery1 += " LEFT JOIN (
		_cQuery1 += " 
		_cQuery1 += " SELECT
		_cQuery1 += " 					SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.
		_cQuery1 += " 					D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS FATURADO, SUBSTR(F2_EMISSAO,5,2) MES, SF2.F2_VEND1 F2_VEND1
		_cQuery1 += " 				FROM
		_cQuery1 += " 					"+RetSqlName("SF2")+" SF2 
		_cQuery1 += " 					INNER JOIN(	SELECT
		_cQuery1 += " 									* 
		_cQuery1 += " 								FROM
		_cQuery1 += " 									"+RetSqlName("SD2")+" ) SD2 
		_cQuery1 += " 					ON SD2.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 					SD2.D2_FILIAL = SF2.F2_FILIAL AND
		_cQuery1 += " 					SD2.D2_DOC = SF2.F2_DOC AND
		_cQuery1 += " 					SD2.D2_SERIE = SF2.F2_SERIE AND
		_cQuery1 += " 					SD2.D2_CF IN('5101',
		_cQuery1 += " 					'5102',
		_cQuery1 += " 					'5109',
		_cQuery1 += " 					'5116',
		_cQuery1 += " 					'5117',
		_cQuery1 += " 					'5118',
		_cQuery1 += " 					'5119',
		_cQuery1 += " 					'5122',
		_cQuery1 += " 					'5123',
		_cQuery1 += " 					'5401',
		_cQuery1 += " 					'5403',
		_cQuery1 += " 					'5501',
		_cQuery1 += " 					'5502',
		_cQuery1 += " 					'6101',
		_cQuery1 += " 					'6102',
		_cQuery1 += " 					'6107',
		_cQuery1 += " 					'6108',
		_cQuery1 += " 					'6109',
		_cQuery1 += " 					'6110',
		_cQuery1 += " 					'6111',
		_cQuery1 += " 					'6114',
		_cQuery1 += " 					'6116',
		_cQuery1 += " 					'6117',
		_cQuery1 += " 					'6118',
		_cQuery1 += " 					'6119',
		_cQuery1 += " 					'6122',
		_cQuery1 += " 					'6123',
		_cQuery1 += " 					'6401',
		_cQuery1 += " 					'6403',
		_cQuery1 += " 					'6501',
		_cQuery1 += " 					'6502',
		_cQuery1 += " 					'7101',
		_cQuery1 += " 					'7102') 
		_cQuery1 += " 				WHERE
		_cQuery1 += " 					SUBSTR(F2_EMISSAO,1,4) = '"+_cAno+"' AND
		_cQuery1 += " 					SF2.D_E_L_E_T_ = ' ' AND
		//_cQuery1 += " 					SF2.F2_VEND1 = SA3.A3_COD AND
		_cQuery1 += " 					EXISTS(	SELECT
		_cQuery1 += " 								* 
		_cQuery1 += " 							FROM
		_cQuery1 += " 								"+RetSqlName("SC6")+" SC6 
		_cQuery1 += " 							WHERE
		_cQuery1 += " 								SC6.C6_NUM = SD2.D2_PEDIDO AND
		_cQuery1 += " 								SC6.C6_FILIAL = SD2.D2_FILIAL AND
		_cQuery1 += " 								SC6.D_E_L_E_T_ = ' ' )
		_cQuery1 += " GROUP BY SUBSTR(F2_EMISSAO,5,2), F2_VEND1
		_cQuery1 += " 
		_cQuery1 += " ) ZZZ
		_cQuery1 += " ON JJJ.CODIGO=ZZZ.F2_VEND1 AND JJJ.MES=ZZZ.MES
		_cQuery1 += " LEFT JOIN (
		_cQuery1 += " 
		_cQuery1 += " 	SELECT
		_cQuery1 += " 					COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.
		_cQuery1 += " 					D1_VALICM),0) AS DEVOLVIDO,  SUBSTR(SD1.D1_EMISSAO,5,2) MES, SF2.F2_VEND1
		_cQuery1 += " 				FROM
		_cQuery1 += " 					"+RetSqlName("SD1")+" SD1 
		_cQuery1 += " 					INNER JOIN(	SELECT
		_cQuery1 += " 									* 
		_cQuery1 += " 								FROM
		_cQuery1 += " 									"+RetSqlName("SA1")+" ) SA1 
		_cQuery1 += " 					ON SA1.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 					SD1.D1_TIPO = 'D' AND
		_cQuery1 += " 					SA1.A1_COD = SD1.D1_FORNECE AND
		_cQuery1 += " 					SA1.A1_LOJA = SD1.D1_LOJA AND
		_cQuery1 += " 					SA1.A1_FILIAL = '  ' 
		_cQuery1 += " 					INNER JOIN (SELECT
		_cQuery1 += " 									* 
		_cQuery1 += " 								FROM
		_cQuery1 += " 									"+RetSqlName("SB1")+" )SB1 
		_cQuery1 += " 					ON SB1.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 					SB1.B1_COD = SD1.D1_COD AND
		_cQuery1 += " 					SB1.B1_FILIAL = '  ' 
		_cQuery1 += " 					INNER JOIN(	SELECT
		_cQuery1 += " 									* 
		_cQuery1 += " 								FROM
		_cQuery1 += " 									"+RetSqlName("SF2")+" ) SF2 
		_cQuery1 += " 					ON SF2.D_E_L_E_T_ = ' ' AND
		_cQuery1 += " 					SF2.F2_DOC = D1_NFORI AND
		_cQuery1 += " 					SF2.F2_SERIE = D1_SERIORI AND
		_cQuery1 += " 					SF2.F2_FILIAL = SD1.D1_FILIAL 
		_cQuery1 += " 				WHERE
		_cQuery1 += " 					SD1.D_E_L_E_T_ = ' ' AND
		//_cQuery1 += " 					SF2.F2_VEND1 = SA3.A3_COD AND
		_cQuery1 += " 					SD1.D1_CF IN ('1201',
		_cQuery1 += " 					'1202',
		_cQuery1 += " 					'1410',
		_cQuery1 += " 					'1411',
		_cQuery1 += " 					'2201',
		_cQuery1 += " 					'2202',
		_cQuery1 += " 					'2410',
		_cQuery1 += " 					'2411',
		_cQuery1 += " 					'2203',
		_cQuery1 += " 					'1918',
		_cQuery1 += " 					'2918',
		_cQuery1 += " 					'3201',
		_cQuery1 += " 					'3202',
		_cQuery1 += " 					'3211',
		_cQuery1 += " 					'2204') AND
		_cQuery1 += " 					(SD1.D1_FILIAL = '02' OR
		_cQuery1 += " 					SD1.D1_FILIAL = '01') AND
		_cQuery1 += " 					SUBSTR(SD1.D1_EMISSAO,1,4) ='"+_cAno+"' 
		_cQuery1 += " GROUP BY SUBSTR(SD1.D1_EMISSAO,5,2), SF2.F2_VEND1
		_cQuery1 += " ) KKK
		_cQuery1 += " ON JJJ.CODIGO=KKK.F2_VEND1 AND JJJ.MES=KKK.MES
		_cQuery1 += " ORDER BY CODIGO, MES

		If _nTipo==2
			_cQuery1 += " ) LLL
			_cQuery1 += " GROUP BY MES 
			_cQuery1 += " ORDER BY MES
		EndIf	

	Else

		_cQuery1 := " SELECT ZS_ANO ANO, ZS_MES MES, ZS_OBJETIV OBJETIVO, ZS_CAPTUR CAPTADO, ZS_FATUR FATURADO, 0 DEVOLVIDO
		_cQuery1 += " FROM "+RetSqlName("SZS")+" ZS
		_cQuery1 += " WHERE ZS.D_E_L_E_T_=' ' AND ZS_ANO='"+_cAno+"'
		_cQuery1 += " ORDER BY ZS_MES

	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())

		While (_cAlias1)->(!Eof())

			_nCaptado 	:= (_cAlias1)->(CAPTADO/OBJETIVO)*100
			If _nCaptado>200
				_nCaptado := 200
			EndIf
			_nFaturado	:= (_cAlias1)->(FATURADO-DEVOLVIDO)/(_cAlias1)->OBJETIVO*100
			If _nFaturado>200
				_nFaturado := 200
			EndIf

			If Val((_cAlias1)->MES)<=Val(substr(dtos(date()),5,2))
				_cObjetivo 	+= '100'//CVALTOCHAR((cAliasSuper)->OBJETIVO)
				_cCaptado 	+= CVALTOCHAR(Abs(_nCaptado))
				_cFaturado 	+= CVALTOCHAR(Abs(_nFaturado))
				If Val((_cAlias1)->MES)<12
					_cObjetivo 	+= ","
					_cCaptado 	+= ","
					_cFaturado 	+= ","
				EndIf
				If Val((_cAlias1)->MES)==Val(substr(dtos(date()),5,2))//-1
					_cCapFinal := CVALTOCHAR(Abs(Round((_cAlias1)->(CAPTADO/OBJETIVO)*100,0)))
					_cFatFinal := CVALTOCHAR(Abs(Round((_cAlias1)->(FATURADO-DEVOLVIDO)/(_cAlias1)->OBJETIVO*100,0)))
				EndIf
			EndIf

			(_cAlias1)->(DbSkip())
		EndDo
	EndIf

	If Empty(_cObjetivo)
		_cObjetivo := ",,,,,,,,,,,"
		_cCaptado  := ",,,,,,,,,,,"
		_cFaturado := ",,,,,,,,,,,"
	EndIf

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbGoTop())
	SA3->(DbSeek(xFilial("SA3")+_cVend))

	_cRegiao	:= UPPER(SA3->A3_XZONA)
	If Empty(_cRegiao)
		_cRegiao := "."
	EndIf

	If Empty(SA3->A3_SUPER)
		_cCodSup := ""
		_cNomSup := ""
		_cCarSup := ""
	Else
		_cCodSup	:= AllTrim(UPPER(Posicione("SA3",1,xFilial("SA3")+SA3->A3_SUPER,"A3_COD")))
		_cNomSup 	:= AllTrim(UPPER(Posicione("SA3",1,xFilial("SA3")+_cCodSup,"A3_NOME")))
		_cCarSup 	:= AllTrim(LOWER(Posicione("SA3",1,xFilial("SA3")+_cCodSup,"A3_XCARGO")))
	EndIf

	If Empty(SA3->A3_GEREN)
		_cCodGer := ""
		_cNomGer := ""
		_cCarGer := ""
	Else
		_cCodGer	:= AllTrim(UPPER(Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_COD")))
		_cNomGer 	:= AllTrim(UPPER(Posicione("SA3",1,xFilial("SA3")+_cCodGer,"A3_NOME")))
		_cCarGer 	:= AllTrim(LOWER(Posicione("SA3",1,xFilial("SA3")+_cCodGer,"A3_XCARGO")))
	EndIf

	If Empty(_cNomSup)
		_cNomSup := "."
	EndIf
	If Empty(_cNomGer)
		_cNomGer := "."
	EndIf
	If Empty(_cCarSup)
		_cCarSup := "supervisor"
	EndIf
	If Empty(_cCarGer)
		_cCarGer := "gerente"
	EndIf

	_cRetorno += "<ano>"+substr(dtos(date()),1,4)+"</ano>"
	_cRetorno += "<mes>"+UPPER(MesExtenso(Date()))+"</mes>"
	_cRetorno += "<objetivo>"+_cObjetivo+"</objetivo>"
	_cRetorno += "<captacao>"+_cCaptado+"</captacao>"
	_cRetorno += "<faturamento>"+_cFaturado+"</faturamento>"
	_cRetorno += "<capfinal>"+_cCapFinal+"</capfinal>"
	_cRetorno += "<fatfinal>"+_cFatFinal+"</fatfinal>"
	_cRetorno += "<supervisor>"+_cNomSup+"</supervisor>"
	_cRetorno += "<cargsup>"+_cCarSup+"</cargsup>"
	_cRetorno += "<gerente>"+_cNomGer+"</gerente>"
	_cRetorno += "<cargger>"+_cCarGer+"</cargger>"
	_cRetorno += "<regiao>"+_cRegiao+"</regiao>

Return(_cRetorno)