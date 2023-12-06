#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTF0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL getFat DESCRIPTION "Aplicativo Steck"

WSMETHOD GET DESCRIPTION "Buscar dados de faturamento" WSSYNTAX "/rest/getFat"

END WSRESTFUL

WSMETHOD GET WSSERVICE getFat

	Local cResp 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cUsuario	:= ""
	Private _cDat     		:= Month2Str( date())
	Private _cDat1    		:= Month2Str(MonthSum(date(),1))
	Private _cDat2    		:= Month2Str(MonthSum(date(),2))
	Private _cDat3    		:= Month2Str(MonthSum(date(),3))
	Private _cDat4    		:= Month2Str(MonthSum(date(),4))
	Private _cDat5    		:= Month2Str(MonthSum(date(),5))
	Private _cDat6    		:= Month2Str(MonthSum(date(),6))
	Private _cDat7    		:= Month2Str(MonthSum(date(),7))
	Private _cDat8    		:= Month2Str(MonthSum(date(),8))

	ConOut("[STRESTF0]["+ FWTimeStamp(2) +"] - Usuario "+AllTrim(UsrRetName(__cUserId))+" realizou o acesso.")

	_cUsuario := AllTrim(UsrRetName(__cUserId))

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

	//Captação BR
	_cQuery1 := " SELECT
	_cQuery1 += "    SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         )
	_cQuery1 += ' "TOTAL",
	_cQuery1 += "    SUM(round(CASE WHEN  (SC5.C5_XATE = '30'   AND  C5_XMATE = ' ' OR    SC5.C5_XATE = '31'   AND C5_XMATE = ' ') OR  (SC5.C5_XATE = '30'   AND C5_XMATE = '11' OR    SC5.C5_XATE = '31'   AND C5_XMATE = '11')
	_cQuery1 += "  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "MES",
	_cQuery1 += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(TC9.QUANT),2)),0) "REJEITADOS",
	_cQuery1 += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(BC9.QUANT),2)),0) "ANALISE",
	//_cQuery1 += " NVL(SUM(      round(    CASE WHEN   SC5.C5_ZBLOQ   = '1' THEN (    SC6.C6_ZVALLIQ/SC6.C6_QTDVEN) ELSE 0 END    ,2)   ),0)
	//_cQuery1 += ' "BLQ_COMER",
	/*
	_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL1",
	_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL2",
	_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL3"
	_cQuery1 += "  ,SUM(round(CASE WHEN  SC5.C5_XMATE||SC5.C5_XAANO >=  '"+_cDat4+ substr(dtos(MonthSum(date(),4)),1,4)+"'
	_cQuery1 += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL5"
	*/
	
	
	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	If _cDat = '12'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat1+"'
	Else
		_cQuery1 += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	EndIf
	_cQuery1 += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL1",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	If _cDat = '11'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE))=   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	ElseIf _cDat = '12'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	Else
		_cQuery1 += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	EndIf
	_cQuery1 += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL2",

	//_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	If _cDat = '10'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '11'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '12'
		_cQuery1 += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	Else
		_cQuery1 += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	EndIf
	_cQuery1 += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL3",


	If _cDat = '09'
		_cQuery1 += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"01'
	ElseIf _cDat = '10'
		_cQuery1 += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"02'
	ElseIf _cDat = '11'
		_cQuery1 += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"03'
	Else
		_cQuery1 += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '" + substr(dtos(date()),1,4)+_cDat4+"'
	EndIf
	_cQuery1 += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "TOTAL5"

	
	
	_cQuery1 += "  , SUM(round(CASE WHEN  SB1.B1_GRUPO = '999' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "X999"
	_cQuery1 += " , SUM(round(CASE WHEN ( SC5.C5_XMATE = '"+_cDat1+"' or SC5.C5_XMATE = '"+_cDat2+"' or SC5.C5_XMATE >= '"+_cDat3+"' )  AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' "X9991",
	//_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' 0 "X9992",
	//_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' 0 "X9993",
	//_cQuery1 += "  SUM(round(CASE WHEN  SC5.C5_XMATE > '"+_cDat3+"' and SC5.C5_XMATE <= '12'  AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	_cQuery1 += ' 0 "X9994"
	_cQuery1 += " FROM SC5010 SC5
	_cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	_cQuery1 += " ON SC6.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	_cQuery1 += " AND SC5.C5_NUM      = SC6.C6_NUM
	_cQuery1 += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	_cQuery1 += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	_cQuery1 += " FROM "+RetSqlName("SC9")+" SC9 "
	_cQuery1 += " WHERE   SC9.D_E_L_E_T_ = ' '
	_cQuery1 += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)TC9
	_cQuery1 += " ON  TC9.C9_PEDIDO = SC6.C6_NUM
	_cQuery1 += " AND  TC9.C9_ITEM   = SC6.C6_ITEM
	_cQuery1 += " AND TC9.C9_FILIAL = SC6.C6_FILIAL
	_cQuery1 += " AND TC9.C9_BLCRED = '09'
	_cQuery1 += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	_cQuery1 += " FROM "+RetSqlName("SC9")+" SC9 "
	_cQuery1 += " WHERE   SC9.D_E_L_E_T_ = ' '
	_cQuery1 += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)BC9
	_cQuery1 += " ON  BC9.C9_PEDIDO = SC6.C6_NUM
	_cQuery1 += " AND  BC9.C9_ITEM   = SC6.C6_ITEM
	_cQuery1 += " AND BC9.C9_FILIAL = SC6.C6_FILIAL
	_cQuery1 += " AND (BC9.C9_BLCRED = '04' or BC9.C9_BLCRED = '01')
	_cQuery1 += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
	_cQuery1 += " ON SB1.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SB1.B1_COD    = SC6.C6_PRODUTO
	_cQuery1 += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	_cQuery1 += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
	_cQuery1 += " ON SBM.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
	_cQuery1 += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
	_cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	_cQuery1 += " ON SA1.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SA1.A1_COD = SC5.C5_CLIENTE
	_cQuery1 += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
	_cQuery1 += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	_cQuery1 += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
	_cQuery1 += " ON SA3.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SA3.A3_COD = SC5.C5_VEND2
	_cQuery1 += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
	_cQuery1 += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
	_cQuery1 += " ON C6_NUM = PC1.PC1_PEDREP
	_cQuery1 += " AND PC1.D_E_L_E_T_ = ' '
	_cQuery1 += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	_cQuery1 += " ON SC6.C6_TES = SF4.F4_CODIGO
	_cQuery1 += " AND SF4.D_E_L_E_T_ = ' '
	_cQuery1 += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	_cQuery1 += " WHERE  SC5.D_E_L_E_T_   = ' '
	_cQuery1 += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	_cQuery1 += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	_cQuery1 += " AND SC5.C5_TIPO = 'N'
	_cQuery1 += " AND SA1.A1_GRPVEN <> 'ST'
	_cQuery1 += " AND SA1.A1_GRPVEN <> 'SC'
	_cQuery1 += " AND SA1.A1_EST    <> 'EX'
	_cQuery1 += " AND SBM.BM_XAGRUP <> ' '
	_cQuery1 += " AND PC1.PC1_PEDREP IS NULL

	Conout(_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif
	Conout(time())
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	Conout(time())
	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	_nCapBr := 0

	If (_cAlias1)->(!Eof())
		_nCapBr := (_cAlias1)->TOTAL-(_cAlias1)->REJEITADOS-(_cAlias1)->ANALISE-(_cAlias1)->TOTAL5-(_cAlias1)->TOTAL1-(_cAlias1)->TOTAL2-(_cAlias1)->TOTAL3 -(_cAlias1)->X999+(_cAlias1)->X9994+(_cAlias1)->X9991+(_cAlias1)->X9992+(_cAlias1)->X9993
	EndIf

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

	//Captação AR
	_cQuery1:= " SELECT
	_cQuery1+= "  SUM(C6_VALOR) as TOTAL,
	_cQuery1+= " NVL(sum(case when C5_EMISSAO = '"+ dtos(date()) +"'  then C6_VALOR else 0 end ),0) as DIA
	_cQuery1+= " FROM SC6070 SC6
	_cQuery1+= " INNER JOIN(SELECT * FROM SC5070) SC5
	_cQuery1+= " ON SC5.D_E_L_E_T_ = ' '
	_cQuery1+= " AND SUBSTR(C5_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'
	_cQuery1+= " AND C5_NUM = C6_NUM
	_cQuery1+= " INNER JOIN(SELECT * FROM SF4070)SF4
	_cQuery1+= " ON SF4.D_E_L_E_T_ = ' '
	_cQuery1+= " AND F4_CODIGO = C6_TES
	_cQuery1+= " AND F4_DUPLIC = 'S'
	_cQuery1+= " WHERE SC6.D_E_L_E_T_ = ' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	_nCapAr := 0

	If (_cAlias1)->(!Eof())
		_nCapAr := (_cAlias1)->TOTAL
	EndIf

	//Atingido BR
	_nAtingBr := (_nFatMesBr/_nFatMetBr)*100
	_nRestBr  := IIf(_nAtingBr<100,100-_nAtingBr,0)

	//Atingido AR
	_nAtingAr := (_nFatMesAr/_nFatMetAr)*100
	_nRestAr  := IIf(_nAtingAr<100,100-_nAtingAr,0)

	cResp += '{"fatbrm": "Mensal FAT (RS) '+AllTrim(Transform(_nFatMesBr,"@E 999,999,999.99"))+'",
	cResp += '"fatbrd": "Diário FAT (RS) '+AllTrim(Transform(_nFatDiaBr,"@E 999,999,999.99"))+'",
	cResp += '"capbr": "Captação (RS) '+AllTrim(Transform(_nCapBr,"@E 999,999,999.99"))+'",
	cResp += '"atinbr": "'+cValToChar(Round(_nAtingBr,0))+'",
	cResp += '"restbr": "'+cValToChar(Round(_nRestBr,0))+'",
	cResp += '"fatarm": "Mensal FAT (ARS) '+AllTrim(Transform(_nFatMesAr,"@E 999,999,999.99"))+'",
	cResp += '"fatard": "Diário FAT (ARS) '+AllTrim(Transform(_nFatDiaAr,"@E 999,999,999.99"))+'",
	cResp += '"capar": "Captação (USS) '+AllTrim(Transform(_nCapAr,"@E 999,999,999.99"))+'",
	cResp += '"atinar": "'+cValToChar(Round(_nAtingAr,0))+'",
	cResp += '"restar": "'+cValToChar(Round(_nRestAr,0))+'",
	cResp += '"ultatu": "Última atualização feita em '+DTOC(Date())+' - '+Time()+'"
	cResp += '}

	ConOut("[STRESTF0]["+ FWTimeStamp(2) +"] - Resposta: "+cResp)

	::SetResponse(cResp)

Return .T.