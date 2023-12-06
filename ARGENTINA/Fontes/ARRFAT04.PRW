#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} ARRFAT04

Ventas por Vendedor

@type function
@author Everson Santana
@since 18/09/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARRFAT04()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT04", Len (SX1->X1_GRUPO))
	//Private _cTipo	 := ""
	//Private _cTipo1	 := ""
	Private _cTitulo := ""

	ValidPerg()

	Pergunte(_cPerg,.T.)

	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

Return
/*
Definição da estrutura do relatório.
*/
Static Function ReportDef()

	If MV_PAR03 == 1
		_cTitulo := "Ventas por Vendedor - Facturado"
	Else
		_cTitulo := "Ventas por Vendedor - Captado"
	EndIF

	_oReport := TReport():New("ARRFAT04",_cTitulo+" - "+Alltrim(aPergunta[1][1])+" : "+dtoc(MV_PAR01)+" "+Alltrim(aPergunta[2][1])+" : "+dtoc(MV_PAR02),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)
	_oReport:cFontBody := 'Courier New'
	_oReport:nFontBody := 10

	If MV_PAR03 == 1

		_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

		TRCell():New( _oSecCab, "CODVEN"		,,"Cod. Vendedor	" ,"@!"	,06,.F.,)
		TRCell():New( _oSecCab, "NOMVEN"		,,"Nome Vendedor	" ,"@!"	,30,.F.,)
		TRCell():New( _oSecCab, "QTDFAT"		,,"Qtd Faturada		" ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "VLRFAT"  		,,"Vlr Faturada		" ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "QTDMET"  		,,"Qtd Meta			" ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "VLRMET"  		,,"Vlr Meta 		" ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "PERMET"  		,,"% 				" ,PesqPict('SC6',"C6_DESCONT")	,TamSX3("C6_DESCONT")[1]	,.F.,)

		TRFunction():New(_oSecCab:Cell("QTDFAT"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("VLRFAT"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("QTDMET"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("VLRMET"),NIL,"SUM",,,,,.F.,.T.)

	Else
		_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

		TRCell():New( _oSecCab, "CODVEN"		,,"Cod. Vendedor	" ,"@!"	,06,.F.,)
		TRCell():New( _oSecCab, "NOMVEN"		,,"Nome Vendedor	" ,"@!"	,30,.F.,)

/*
		TRCell():New( _oSecCab, "QTDCAP"		,,"Qtd Captado		" ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "VLRCAP"  		,,"Vlr Captado 		" ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "QTDMET"  		,,"Qtd Meta			" ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "VLRMET"  		,,"Vlr Meta 		" ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
*/

		TRCell():New( _oSecCab, "QTDCAP"		,,"Qtd Captado		" ,"@e 999,999,999,999",			15,.F.,)
		TRCell():New( _oSecCab, "VLRCAP"  		,,"Vlr Captado 		" ,"@e 999,999,999,999.99",			17.2,.F.,)
		TRCell():New( _oSecCab, "QTDMET"  		,,"Qtd Meta			" ,"@e 999,999,999,999",			15,.F.,)
		TRCell():New( _oSecCab, "VLRMET"  		,,"Vlr Meta 		" ,"@e 999,999,999,999.99",			17.2,.F.,)
		TRCell():New( _oSecCab, "PERMET"  		,,"% 				" ,PesqPict('SC6',"C6_DESCONT"),	TamSX3("C6_DESCONT")[1]	,.F.,)

		TRFunction():New(_oSecCab:Cell("QTDCAP"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("VLRCAP"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("QTDMET"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("VLRMET"),NIL,"SUM",,,,,.F.,.T.)
	EndIf

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	If MV_PAR03 == 1 // Facturado

/*

		_cQuery += " SELECT VENDEDOR,NOME,NVL((SUM(QTDFAT)+SUM(QTDFATDEV)),0) QTDFAT,NVL(VLRFAT+SUM(VLRFATDEV),0) VLRFAT 
		
		_cQuery += "   ,(SELECT NVL(SUM(ZZD_QTD),0) FROM "+RetSqlName("ZZD")+" ZZD "
		_cQuery += "		WHERE ZZD.ZZD_VEND = TMP2.VENDEDOR  " +CR
 		_cQuery += "         AND ZZD.ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' " +CR 
		_cQuery += "         AND ZZD.ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' " +CR
        _cQuery += "		AND ZZD.D_E_L_E_T_ = ' ' "
        _cQuery += " ) QTDMETA "
         
		_cQuery += "   ,(SELECT NVL(SUM(ZZD_VALOR),0) FROM "+RetSqlName("ZZD")+" ZZD "
		_cQuery += "		WHERE ZZD.ZZD_VEND = TMP2.VENDEDOR  " +CR
 		_cQuery += "         AND ZZD.ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' " +CR 
		_cQuery += "         AND ZZD.ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' " +CR
        _cQuery += "		AND ZZD.D_E_L_E_T_ = ' ' "
        _cQuery += " ) VLRMETA "
         
		_cQuery += "  FROM ( " +CR
		_cQuery += "         SELECT VENDEDOR,NOME, SUM(QTDFAT) QTDFAT,SUM(VLRFAT) VLRFAT, SUM(QTDFATDEV) QTDFATDEV, SUM(VLRFATDEV) VLRFATDEV " +CR
		_cQuery += "             FROM ( "            +CR
		_cQuery += "                     SELECT SF2.F2_VEND1 VENDEDOR,SA3.A3_NOME NOME, SUM(SD2.D2_QUANT) QTDFAT,SUM(SD2.D2_TOTAL) AS VLRFAT, " +CR
		_cQuery += " NVL(( " +CR
		
		_cQuery += " SELECT (SUM(TMPQTD.QTDFAT)*-1) FROM ( " +CR
		
		_cQuery += " SELECT  SF2.F2_VEND1,SD1.D1_QUANT QTDFAT  " +CR
		_cQuery += " FROM "+RetSqlName("SD1")+" SD1 " +CR
		_cQuery += "                                         INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+" ) SF4 " +CR 
		_cQuery += "                                             ON SF4.D_E_L_E_T_ = ' ' " +CR
		_cQuery += "                                                 AND F4_CODIGO = D1_TES " +CR
		_cQuery += "                                                 AND F4_DUPLIC = 'S' " +CR
		
        _cQuery += " 			                              LEFT JOIN "+RetSqlName("SF2")+" SF2 " +CR 
        _cQuery += " 			                                  ON SF2.F2_FILIAL = SD1.D1_FILIAL " +CR
        _cQuery += " 				                                  AND SF2.F2_DOC = SD1.D1_NFORI " +CR
        _cQuery += " 				                                  AND SF2.F2_SERIE = SD1.D1_SERIORI " +CR
        _cQuery += " 				                                  AND SF2.F2_CLIENTE = SD1.D1_FORNECE " +CR
        _cQuery += " 				                                  AND SF2.F2_LOJA = SD1.D1_LOJA " +CR		
		
		_cQuery += " 			WHERE D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " +CR
		_cQuery += "				AND D1_CF IN('112') " +CR
		_cQuery += "				AND D1_TIPO IN('D') " +CR
		_cQuery += "				AND D1_ESPECIE IN('NCC') " +CR 
		_cQuery += "				AND D1_TP = 'PA' " +CR
		_cQuery += "				AND SD1.D_E_L_E_T_ = ' ' "            +CR
		
		_cQuery += "	) TMPQTD " +CR
		_cQuery += " WHERE TMPQTD.F2_VEND1 = SF2.F2_VEND1 " +CR
		       
		_cQuery += " ),0) QTDFATDEV, " +CR
		_cQuery += " NVL(( " +CR
		
		_cQuery += " SELECT (SUM(TMPVLR.VLRFAT)*-1) FROM ( " +CR
		
		_cQuery += " SELECT  SF2.F2_VEND1,SD1.D1_TOTAL  VLRFAT  " +CR 
		_cQuery += "			FROM "+RetSqlName("SD1")+" SD1 " +CR
		_cQuery += "                                         INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+" ) SF4 " +CR 
		_cQuery += "                                             ON SF4.D_E_L_E_T_ = ' ' " +CR 
		_cQuery += "                                                 AND F4_CODIGO = D1_TES " +CR
		_cQuery += "                                                 AND F4_DUPLIC = 'S' " +CR
		
		_cQuery += "                                        LEFT JOIN "+RetSqlName("SF2")+" SF2 " +CR 
        _cQuery += "                                    		ON SF2.F2_FILIAL = SD1.D1_FILIAL " +CR
        _cQuery += "                                    			AND SF2.F2_DOC = SD1.D1_NFORI " +CR
        _cQuery += "                                    			AND SF2.F2_SERIE = SD1.D1_SERIORI " +CR
        _cQuery += "                                    			AND SF2.F2_CLIENTE = SD1.D1_FORNECE " +CR 
        _cQuery += "                                    			AND SF2.F2_LOJA = SD1.D1_LOJA " +CR
                                            
		_cQuery += "			WHERE D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " +CR
		_cQuery += "				AND D1_CF IN('112') " +CR
		_cQuery += "				AND D1_TIPO IN('D') " +CR
		_cQuery += "				AND D1_ESPECIE IN('NCC') " +CR 
		_cQuery += "				AND D1_TP = 'PA' " +CR
		_cQuery += "				AND SD1.D_E_L_E_T_ = ' ' "            +CR
		
		_cQuery += "     ) TMPVLR " +CR
		_cQuery += " WHERE TMPVLR.F2_VEND1 = SF2.F2_VEND1 " +CR

		         
		_cQuery += " ),0) VLRFATDEV " +CR
		_cQuery += "                         FROM "+RetSqlName("SD2")+" SD2 " +CR 
		_cQuery += "                             INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+" ) SF4 " +CR 
		_cQuery += "                                 ON SF4.D_E_L_E_T_ = ' ' " +CR 
		_cQuery += "                                 AND F4_CODIGO = D2_TES " +CR
		_cQuery += "                                 AND F4_DUPLIC = 'S' " +CR
		_cQuery += "                                 AND F4_ESTOQUE = 'S' " +CR
		_cQuery += "                             LEFT JOIN "+RetSqlName("SF2")+" SF2 " +CR
		_cQuery += "                                 ON SF2.F2_FILIAL = SD2.D2_FILIAL " +CR 
		_cQuery += "                                 AND SF2.F2_DOC = SD2.D2_DOC " +CR
		_cQuery += "                                 AND SF2.F2_SERIE = SD2.D2_SERIE " +CR 
		_cQuery += "                                 AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " +CR 
		_cQuery += "                                 AND SF2.F2_LOJA = SD2.D2_LOJA " +CR
		_cQuery += "                                 AND SF2.D_E_L_E_T_ = ' ' " +CR
		_cQuery += "                             LEFT JOIN "+RetSqlName("SA3")+" SA3 " +CR
		_cQuery += "                                 ON SA3.A3_FILIAL = '  ' " +CR  
		_cQuery += "                                 AND SA3.A3_COD = SF2.F2_VEND1 " +CR 
		_cQuery += "                                 AND SA3.D_E_L_E_T_ = ' ' " +CR
		_cQuery += "                         WHERE SD2.D_E_L_E_T_ = ' ' " +CR
		_cQuery += "                             AND D2_SERIE <> 'R' " +CR
		_cQuery += "                             AND D2_ESPECIE = 'NF' " +CR
		_cQuery += "                             AND D2_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " +CR 
		_cQuery += "                             AND SF2.F2_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " +CR
		
		_cQuery += "                GROUP BY SF2.F2_VEND1,SA3.A3_NOME " +CR  
		                
		_cQuery += "             ) TMPFAT " +CR
		_cQuery += "         GROUP BY VENDEDOR,NOME " +CR 
		_cQuery += "     ) TMP2 " +CR
		_cQuery += " GROUP BY VENDEDOR,NOME,VLRFAT " +CR
		_cQuery += " ORDER BY VENDEDOR " +CR
*/
		_cQuery := "SELECT" + CR
		_cQuery += "	VENDEDOR," + CR
		_cQuery += "    NOME," + CR
		_cQuery += "    NVL((SUM(QTDFAT)+SUM(QTDFATDEV)),0) QTDFAT," + CR
		_cQuery += "    NVL(VLRFAT+SUM(VLRFATDEV),0) VLRFAT," + CR
		_cQuery += "    (	SELECT NVL(SUM(ZZD_QTD),0)" + CR
		_cQuery += "		FROM " + RetSqlName("ZZD") + " ZZD" + CR
		_cQuery += "        WHERE ZZD_VEND = TMP2.VENDEDOR" + CR
 		_cQuery += "        AND ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' " + CR 
		_cQuery += "        AND ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' " + CR
		_cQuery += "		AND ZZD.D_E_L_E_T_ = ' '  ) QTDMETA," + CR
		_cQuery += "    (   SELECT NVL(SUM(ZZD_VALOR),0)" + CR
		_cQuery += "        FROM " + RetSqlName("ZZD") + " ZZD" + CR
		_cQuery += "        WHERE ZZD_VEND = TMP2.VENDEDOR" + CR
 		_cQuery += "        AND ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' " + CR 
		_cQuery += "        AND ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' " + CR
		_cQuery += "		AND ZZD.D_E_L_E_T_ = ' '  ) VLRMETA" + CR
		_cQuery += " FROM (" + CR
		_cQuery += "    SELECT" + CR
		_cQuery += "        VENDEDOR," + CR
		_cQuery += "        NOME," + CR
		_cQuery += "        SUM(QTDFAT)     QTDFAT," + CR
		_cQuery += "        SUM(VLRFAT)     VLRFAT," + CR
		_cQuery += "        SUM(QTDFATDEV)  QTDFATDEV," + CR
		_cQuery += "        SUM(VLRFATDEV)  VLRFATDEV" + CR
		_cQuery += "        FROM (" + CR
		_cQuery += "            SELECT" + CR
		_cQuery += "                F2_VEND1            VENDEDOR," + CR
		_cQuery += "                A3_NOME             NOME," + CR
		_cQuery += "                SUM(SD2.D2_QUANT)   QTDFAT," + CR
		_cQuery += "                SUM(SD2.D2_TOTAL)   VLRFAT," + CR
		_cQuery += "                NVL((" + CR
		_cQuery += "                    SELECT" + CR
		_cQuery += "                    (SUM(TMPQTD.QTDFAT)*-1)" + CR
		_cQuery += "                    FROM (" + CR
		_cQuery += "                        SELECT" + CR
		_cQuery += "                            F2_VEND1," + CR
		_cQuery += "                            D1_QUANT QTDFAT" + CR
		_cQuery += "                        FROM " + RetSqlName("SD1") + " SD1" + CR
		_cQuery += "                        INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "                        LEFT    JOIN " + RetSqlName("SF2") + " SF2 ON ( SF2.F2_FILIAL = SD1.D1_FILIAL AND SF2.F2_DOC = SD1.D1_NFORI AND SF2.F2_SERIE = SD1.D1_SERIORI" + CR 
		_cQuery += "                            AND SF2.F2_CLIENTE = SD1.D1_FORNECE" + CR
		_cQuery += "                            AND SF2.F2_LOJA = SD1.D1_LOJA" + CR
		_cQuery += "                            AND SF2.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "                    WHERE SD1.D_E_L_E_T_ = ' '" + CR
		_cQuery += "					AND D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " + CR
		_cQuery += "                    AND D1_CF       IN ('112')" + CR
		_cQuery += "                    AND D1_TIPO     IN ('D')" + CR
		_cQuery += "                    AND D1_ESPECIE  IN ('NCC')" + CR
		_cQuery += "                    AND D1_TP = 'PA' ) TMPQTD" + CR
		_cQuery += "                WHERE TMPQTD.F2_VEND1 = SF2.F2_VEND1 ),0) QTDFATDEV," + CR
		_cQuery += "                NVL((" + CR
		_cQuery += "                    SELECT (SUM(TMPVLR.VLRFAT)*-1)" + CR
		_cQuery += "                    FROM (" + CR
		_cQuery += "                        SELECT" + CR
		_cQuery += "                            SF2.F2_VEND1,SD1.D1_TOTAL  VLRFAT" + CR
		_cQuery += "                        FROM " + RetSqlname("SD1") + " SD1" + CR
		_cQuery += "                        INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = D1_TES     AND F4_DUPLIC = 'S'     AND SF4.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "                        LEFT    JOIN " + RetSqlName("SF2") + " SF2 ON ( F2_FILIAL = D1_FILIAL  AND F2_DOC = D1_NFORI   AND F2_SERIE = D1_SERIORI" + CR
		_cQuery += "                            AND F2_CLIENTE = D1_FORNECE AND F2_LOJA = D1_LOJA )" + CR
		_cQuery += "                        WHERE SD1.D_E_L_E_T_ = ' '" + CR
		_cQuery += "						AND D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " + CR
		_cQuery += "                        AND D1_CF IN('112')" + CR
		_cQuery += "                        AND D1_TIPO 	IN ('D')" + CR
		_cQuery += "                        AND D1_ESPECIE 	IN ('NCC')" + CR
		_cQuery += "                        AND D1_TP 		= 'PA' ) TMPVLR" + CR
		_cQuery += "                    WHERE TMPVLR.F2_VEND1 = SF2.F2_VEND1 ),0) VLRFATDEV" + CR
		_cQuery += "            FROM " + RetSqlName("SD2") + " SD2" + CR
		_cQuery += "            INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = D2_TES AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "            LEFT    JOIN " + RetSqlName("SF2") + " SF2 ON ( F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE" + CR
		_cQuery += "                AND F2_LOJA = D2_LOJA AND SF2.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "            LEFT    JOIN " + RetSqlName("SA3") + " SA3 ON ( A3_FILIAL = '  ' AND A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "            INNER   JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = F2_CLIENTE    AND A1_LOJA = F2_LOJA   AND A1_GRPVEN <> 'ST'   AND SA1.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += "            WHERE SD2.D_E_L_E_T_ = ' '" + CR
		_cQuery += "            AND D2_SERIE 	<> 'R'" + CR
		_cQuery += "            AND D2_ESPECIE 	= 'NF'" + CR
		_cQuery += "            AND D2_EMISSAO 	BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " + CR
		_cQuery += "            AND F2_VEND1 	BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " + CR
		_cQuery += "            GROUP BY SF2.F2_VEND1,SA3.A3_NOME ) TMPFAT" + CR
		_cQuery += "        GROUP BY VENDEDOR,NOME ) TMP2" + CR
		_cQuery += "    GROUP BY VENDEDOR,NOME,VLRFAT" + CR
		_cQuery += " ORDER BY VENDEDOR"  + CR

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery _cQuery New Alias "QRY"

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		While !QRY->(Eof())

			While !QRY->(Eof()) 

				_oSecCab:Init()

				_oSecCab:Cell("CODVEN"):SetValue(QRY->VENDEDOR)
				_oSecCab:Cell("NOMVEN"):SetValue(QRY->NOME)
				_oSecCab:Cell("QTDFAT"):SetValue(QRY->QTDFAT)
				_oSecCab:Cell("VLRFAT"):SetValue(QRY->VLRFAT)
				_oSecCab:Cell("QTDMET"):SetValue(QRY->QTDMETA)
				_oSecCab:Cell("VLRMET"):SetValue(QRY->VLRMETA)
				_oSecCab:Cell("PERMET"):SetValue((QRY->VLRFAT/QRY->VLRMETA)*100)

				_oSecCab:PrintLine()

				QRY->(DbSkip())

			EndDo
			_oReport:ThinLine()

		EndDo
		
		_oSecCab:Finish()
		
	Else // Captado

/*
		_cQuery := " SELECT VENDEDOR,NOME,SUM(QTDVEN) QTDVEN,CAPTADO,SUM(ZZD_QTD) QTDMETA,SUM(ZZD_VALOR) VLRMETA  "
		_cQuery += "    FROM ( "
		_cQuery += "            SELECT VENDEDOR,NOME,SUM(QTDVEN) QTDVEN,SUM(TOTAL) CAPTADO "
		_cQuery += "                 FROM ( "
		_cQuery += "                         SELECT SC5.C5_VEND1 VENDEDOR , SA3.A3_NOME NOME, SC6.C6_QTDVEN QTDVEN,SC6.C6_VALOR TOTAL "
		_cQuery += "                             FROM " + RetSqlName("SC5") + " SC5 "
		_cQuery += "                                 LEFT JOIN " + RetSqlName("SC6") +" SC6 "
		
		_cQuery += "                                     ON SC5.C5_FILIAL = SC6.C6_FILIAL "
		_cQuery += "                                     AND SC5.C5_NUM = SC6.C6_NUM "
		_cQuery += "                                     AND SC6.D_E_L_E_T_ = ' ' "
		_cQuery += "                                 LEFT JOIN " + RetSqlName("SA3") +" SA3 "
		_cQuery += "                                     ON SA3.A3_FILIAL = '" + xFilial("SA3") + "' "
		_cQuery += "                                     AND SA3.A3_COD = SC5.C5_VEND1 "
		_cQuery += "                                     AND SA3.D_E_L_E_T_ = ' ' "
		_cQuery += "                             WHERE SC5.C5_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
		_cQuery += "                                 AND SC5.C5_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		_cQuery += "                                 AND SC5.C5_TIPO = 'N' "
		_cQuery += "                                 AND SC5.D_E_L_E_T_ = ' ' "
		_cQuery += "                         ) TMP "
		_cQuery += "                 GROUP BY VENDEDOR,NOME "
		_cQuery += "             ) TMP2 "
		_cQuery += "         LEFT JOIN "+ RetSqlName("ZZD") +" ZZD "
		_cQuery += "             ON ZZD.ZZD_VEND = TMP2.VENDEDOR "
		_cQuery += "             AND ZZD.ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' "
		_cQuery += "             AND ZZD.ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' "
		_cQuery += "             AND ZZD.D_E_L_E_T_ = ' ' "
		_cQuery += " GROUP BY VENDEDOR,NOME,CAPTADO "
		_cQuery += " ORDER BY VENDEDOR "
*/
		_cQuery := "SELECT"  + CR
		_cQuery += "    VENDEDOR,"  + CR
		_cQuery += "    NOME,"  + CR
		_cQuery += "    SUM(QTDVEN)    	QTDVEN,"  + CR
		_cQuery += "                    CAPTADO,"  + CR
		_cQuery += "	SUM(ZZD_QTD)    QTDMETA,"  + CR
		_cQuery += "    SUM(ZZD_VALOR)  VLRMETA"  + CR
		_cQuery += " FROM ("  + CR
		_cQuery += "    SELECT"  + CR
		_cQuery += "        VENDEDOR,"  + CR
		_cQuery += "        NOME,"  + CR
		_cQuery += "        SUM(QTDVEN) QTDVEN,"  + CR
		_cQuery += "        SUM(TOTAL)  CAPTADO"  + CR
		_cQuery += "    FROM ("  + CR
		_cQuery += "        SELECT"  + CR
		_cQuery += "            C5_VEND1    VENDEDOR,"  + CR
		_cQuery += "            A3_NOME     NOME,"  + CR
		_cQuery += "            C6_QTDVEN   QTDVEN,"  + CR
		_cQuery += "            C6_VALOR    TOTAL"  + CR
		_cQuery += "        FROM " + RetSqlName("SC5") + " SC5"  + CR
		_cQuery += "        LEFT    JOIN " + RetSqlName("SC6") + " SC6 ON ( C5_FILIAL = C6_FILIAL  AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ' ' )"  + CR
		_cQuery += "    	INNER   JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = C5_CLIENTE    AND A1_LOJA = C5_LOJACLI   AND A1_GRPVEN <> 'ST'   AND SA1.D_E_L_E_T_ = ' ' )"  + CR
		_cQuery += "		INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = C6_TES     AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )"  + CR
		_cQuery += "        LEFT    JOIN " + RetSqlName("SA3") + " SA3 ON ( A3_COD = C5_VEND1      AND SA3.D_E_L_E_T_ = ' ' )"  + CR
		_cQuery += "        WHERE SC5.D_E_L_E_T_ = ' '"  + CR
		_cQuery += "        AND C5_EMISSAO	BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " + CR
		_cQuery += "        AND C5_VEND1    BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'" + CR
		_cQuery += "		AND SC5.C5_TIPO = 'N' ) TMP"  + CR
		_cQuery += "    GROUP BY VENDEDOR,NOME ) TMP2"  + CR
		_cQuery += " LEFT JOIN "+ RetSqlName("ZZD") + " ZZD ON ( ZZD_VEND = TMP2.VENDEDOR " + CR
		_cQuery += " AND ZZD_ANO BETWEEN '" + SubStr( Dtos(MV_PAR01),1,4 ) + "' AND '" + SubStr( Dtos(MV_PAR02),1,4 ) + "' " + CR
		_cQuery += " AND ZZD_MES BETWEEN '" + SubStr( Dtos(MV_PAR01),5,2 ) + "' AND '" + SubStr( Dtos(MV_PAR02),5,2 ) + "' " + CR
		_cQuery += " AND ZZD.D_E_L_E_T_ = ' ' )" + CR
		_cQuery += " GROUP BY VENDEDOR,NOME,CAPTADO"  + CR
		_cQuery += " ORDER BY VENDEDOR"  + CR

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery _cQuery New Alias "QRY"

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		While !QRY->(Eof())

			While !QRY->(Eof()) 

				_oSecCab:Init()

				_oSecCab:Cell("CODVEN"):SetValue(QRY->VENDEDOR)
				_oSecCab:Cell("NOMVEN"):SetValue(QRY->NOME)
				_oSecCab:Cell("QTDCAP"):SetValue(QRY->QTDVEN)
				_oSecCab:Cell("VLRCAP"):SetValue(QRY->CAPTADO)
				_oSecCab:Cell("QTDMET"):SetValue(QRY->QTDMETA)
				_oSecCab:Cell("VLRMET"):SetValue(QRY->VLRMETA)
				_oSecCab:Cell("PERMET"):SetValue((QRY->CAPTADO/QRY->VLRMETA)*100)

				_oSecCab:PrintLine()

				QRY->(DbSkip())

			EndDo

		EndDo
		_oSecCab:Finish()

	EndIF


Return Nil
/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","De DT Emissao? "	,"De Fch Emision "	,"Issue Date  "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","De DT Emissao? "	,"Ate Fch Emision "	,"Issue Date  "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Tipo ?  	 	"	,"Tipo ? "			,"Tipo ?  "		,"mv_ch3","N",01,0,0,"C","          ","mv_par03","Facturado","Facturado","Facturado","","","Captado","Captado","Captado","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Do Vendedor ? "	,"Do Vendedor ? "	,"Do Vendedor ?","mv_ch4","C",06,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","Ate Vendedor?"	,"Ate Vendedor?"	,"Ate Vendedor?","mv_ch5","C",06,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next
	RestArea(_sAlias)


Return