#Include "Rwmake.ch"
#Include "TopConn.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBFORM    ºAutor  ³Cristiano Pereira  º Data ³  07/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Formulas visao gerencial                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTBFORM(_cProc)

Local _nValor := 0
Local _cQry   := ""

If _cProc=="1"
	// _nValor := SaldoConta("114001001",ctod("31/12/2017"),"01","1",1)
	_nValor += CTSMCONTA("114001001",ctod("31/12/2017"),"01","1",1,0)
Endif

If _cProc=="2"
	// _nValor := SaldoConta("114001001",ctod("31/12/2017"),"01","1",1)
	_nValor += CTSMCONTA("114001015:114001030",ctod("31/12/2017"),"01","1",1,0)
Endif

If _cProc=="3"
	// _nValor := SaldoConta("114001001",ctod("31/12/2017"),"01","1",1)
	_nValor += CTSMCONTA("114001045",ctod("31/12/2017"),"01","1",1,0)
Endif

If _cProc=="4"
	
	
	If Select("TCT2") > 0
		DbSelectArea("TCT2")
		DbCloSeArea()
	Endif
	
	_cQry := " SELECT SUM(SLD.VALOR) AS VALOR      "
	
	_cQry += " FROM (                              "
	
	_cQry += " SELECT CT2.CT2_FILIAL AS FIL,       "
	_cQry += "       CT2.CT2_LOTE   AS LOTE,       "
	_cQry += "       SUM(CT2.CT2_VALOR)  AS VALOR  "
	
	_cQry += " FROM "+RetSqlName("CT2")+" CT2      "
	
	_cQry += " WHERE                               "
	
	_cQry += "      SUBSTR(CT2.CT2_DATA,1,4)='"+StrZero(year(ddatabase)-1,4)+"'   AND  "
	_cQry += "      CT2.D_E_L_E_T_ <> '*'      AND         "
	_cQry += "      CT2.CT2_LP  = '650'        AND         "
	_cQry += "      CT2.CT2_LOTE='008810'      AND         "
	_cQry += "      ( CT2.CT2_DEBITO ='114001001' OR       "
	_cQry += "      ( CT2.CT2_DEBITO >='114001015' AND CT2.CT2_DEBITO <='114001030') OR    "
	_cQry += "        CT2.CT2_DEBITO ='114001045' )    "
	
	_cQry += " GROUP BY CT2.CT2_FILIAL,CT2.CT2_LOTE         "
	
	_cQry += " UNION ALL   "
	
	
	_cQry += " SELECT CT2.CT2_FILIAL AS FIL,      "
	_cQry += "       CT2.CT2_LOTE   AS LOTE,      "
	_cQry += "       SUM(CT2.CT2_VALOR)  AS VALOR "
	
	_cQry += " FROM "+RetSqlName("CT2")+" CT2     "
	
	_cQry += " WHERE                              "
	
	_cQry += "      SUBSTR(CT2.CT2_DATA,1,4)='"+StrZero(year(ddatabase)-1,4)+"'   AND    "
	_cQry += "      CT2.D_E_L_E_T_ <> '*'             AND    "
	_cQry += "      CT2.CT2_DEBITO ='114001035'              "
	
	_cQry += " GROUP BY CT2.CT2_FILIAL,CT2.CT2_LOTE          "
	
	_cQry += " UNION ALL                                     "
	
	_cQry += " SELECT CT2.CT2_FILIAL AS FIL,                 "
	_cQry += "       CT2.CT2_LOTE   AS LOTE,                 "
	_cQry += "       SUM(CT2.CT2_VALOR)*(-1)  AS VALOR       "
	
	_cQry += " FROM "+RetSqlName("CT2")+" CT2                "
	
	_cQry += " WHERE   "
	
	_cQry += "      SUBSTR(CT2.CT2_DATA,1,4)='"+StrZero(year(ddatabase)-1,4)+"'   AND   "
	_cQry += "      CT2.D_E_L_E_T_ <> '*'      AND          "
	_cQry += "      CT2.CT2_CREDIT ='114001035'             "
	
	_cQry += " GROUP BY CT2.CT2_FILIAL,CT2.CT2_LOTE         "
	
	
	
	_cQry += " UNION ALL                                    "
	
	_cQry += " SELECT CT2.CT2_FILIAL AS FIL,                "
	_cQry += "       CT2.CT2_LOTE   AS LOTE,                "
	_cQry += "       SUM(CT2.CT2_VALOR)*(-1)  AS VALOR      "
	
	_cQry += " FROM "+RetSqlName("CT2")+" CT2               "
	
	_cQry += " WHERE  "
	
	_cQry += "      SUBSTR(CT2.CT2_DATA,1,4)='"+StrZero(year(ddatabase)-1,4)+"'   AND   "
	_cQry += "      CT2.D_E_L_E_T_ <> '*'             AND   "
	_cQry += "      CT2.CT2_LP  IN ('610','650')      AND   "
	_cQry += "      CT2.CT2_LOTE IN ('008820','008810')      AND  "
	_cQry += "      ( CT2.CT2_CREDIT ='114001001' OR              "
	_cQry += "      ( CT2.CT2_CREDIT >='114001015' AND CT2.CT2_CREDIT <='114001030') OR    "
	_cQry += "        CT2.CT2_CREDIT ='114001045'  ) AND                                   "
	_cQry += "        CT2.CT2_DEBITO='        '                                            "
	
	_cQry += " GROUP BY CT2.CT2_FILIAL,CT2.CT2_LOTE ) SLD                                  "
	
	TCQUERY _cQry   NEW ALIAS "TCT2"
	
	DbSelectArea("TCT2")
	DbGotop()
	
	If TCT2->VALOR > 0
		_nValor := TCT2->VALOR
	Endif
	
	
	
	
Endif




return(_nValor)
