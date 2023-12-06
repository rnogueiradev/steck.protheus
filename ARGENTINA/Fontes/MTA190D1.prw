#Include "rwmake.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA190D1   ºAutor  ³Cristiano Pereira º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Custo reposição - Variação do cambio Remito / Fatura        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA190D1()

	Local _cQryD1   := ""


	If !Empty(SD1->D1_REMITO) 
	
	    //Variação cambial  Remito x Factura de compra

		_cQryD1:= " MERGE INTO "+RetSqlName("SD1")+" T1 USING ( "  

		_cQryD1+= " SELECT SD1.D1_FILIAL AS FIL,                "
		_cQryD1+= "        SD1.D1_DOC    AS NF,                 "  
		_cQryD1+= "        SD1.D1_FORNECE AS FORNECE,           "
		_cQryD1+= "        SD1.D1_LOJA    AS LOJA,              "
		_cQryD1+= "        SD1.D1_SERIE   AS SERIE,             "
		_cQryD1+= "        SF1.F1_TXMOEDA AS TXMOEDA,           "
		_cQryD1+= "        SD1.D1_REMITO  AS REMITO,            "
		_cQryD1+= "        SD1.D1_COD     AS COD,               "
		_cQryD1+= "        SD1.R_E_C_N_O_ AS RECNO              "


		_cQryD1+= " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1  "    

		_cQryD1+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'               AND    "
		_cQryD1+= "       SD1.D1_REMITO='"+SD1->D1_REMITO+"'                 AND    "
		_cQryD1+= "       SD1.D1_FORNECE = '"+SD1->D1_FORNECE+"'             AND    "
		_cQryD1+= "       SD1.D1_LOJA    = '"+SD1->D1_LOJA+"'                AND    "
		_cQryD1+= "       SD1.D_E_L_E_T_ <> '*'                              AND    " 
		_cQryD1+= "       SF1.F1_FILIAL = SD1.D1_FILIAL                      AND    "
		_cQryD1+= "       SD1.D1_SERIE ='E'                                  AND    "
		_cQryD1+= "  	   SF1.F1_DOC    = SD1.D1_DOC                         AND    "
		_cQryD1+= "  	   SF1.F1_FORNECE = SD1.D1_FORNECE                    AND    "  
		_cQryD1+= " 	   SF1.F1_LOJA   = SD1.D1_LOJA                        AND    "
		_cQryD1+= "  	   SF1.F1_SERIE =SD1.D1_SERIE                         AND    "
		_cQryD1+= "       SF1.D_E_L_E_T_ <> '*'                                     "              


		_cQryD1+= "     )T2 ON (T1.D1_FILIAL = T2.FIL AND T1.D1_DOC=T2.REMITO AND T1.D1_FORNECE=T2.FORNECE AND T1.D1_LOJA =T2.LOJA  AND T1.D1_COD=T2.COD AND T1.D1_SERIE='R'  )  "                   
		_cQryD1+= " 	 WHEN MATCHED THEN                                                                                                                    "
		_cQryD1+= " 	 UPDATE SET T1.D1_CUSRP1 = T1.D1_TOTAL * T2.TXMOEDA,T1.D1_CUSTO=T1.D1_TOTAL * T2.TXMOEDA "

		TcSqlExec( _cQryD1 )

        
        /*
        //Rateio das despesas de importação

		_cQryD1:= " MERGE INTO "+RetSqlName("SD1")+" T1 USING ( "  

		_cQryD1+= " SELECT  SD1.D1_FILIAL   AS FIL,             "  
        _cQryD1+= "         SD1.D1_DOC     AS NF,               "                 
        _cQryD1+= "         SD1.D1_FORNECE AS FORNECE,          "          
        _cQryD1+= "         SD1.D1_LOJA    AS LOJA,             "             
        _cQryD1+= "         SD1.D1_SERIE   AS SERIE,            "        
        _cQryD1+= "         SF1.F1_TXMOEDA AS TXMOEDA,          "          
        _cQryD1+= "         SD1.D1_REMITO  AS REMITO,           "
        _cQryD1+= "         SD1.D1_QUANT   AS QUANTIDADE,       "
        _cQryD1+= "         SD1.D1_VUNIT   AS VUNIT,            "
        _cQryD1+= "         SD1.D1_COD     AS COD,              "
        _cQryD1+= "         SD1.D1_TOTAL   AS TOTAL,            "
        _cQryD1+= "         SD1.D1_CUSRP1  AS CUSTO_REPOSICAO,  "
        _cQryD1+= "         SD1.D1_LOTECTL AS LOTE,             "
        
        _cQryD1+= " Ltrim(Rtrim(to_char( (( SELECT SUM(SDX.D1_TOTAL)  "
        _cQryD1+= " FROM "+RetSqlName("SD1")+" SDX                    "
        _cQryD1+= " WHERE SDX.D1_FILIAL='"+xFilial("SD1")+"'   AND    "
        _cQryD1+= "       SDX.D1_TES    <>'018'                AND    "
        _cQryD1+= "        RTRIM(SD1.D1_LOTECTL) like '%'||RTRIM(SDX.D1_DOC)||'%'     AND "
        _cQryD1+= "        SDX.D_E_L_E_T_ <>'*'  )  ),'9999999d99'))) TOTAL_DESP_ACES,    "
        
         _cQryD1+= " (SD1.D1_TOTAL/SF1.F1_VALMERC )  PERCENT_RATEIO, "
         
         _cQryD1+= " (     "  
         _cQryD1+= "  ((SD1.D1_TOTAL/SF1.F1_VALMERC ) *( SELECT SUM(SDX.D1_TOTAL)  "
         _cQryD1+= "  FROM "+RetSqlName("SD1")+" SDX                               "
         _cQryD1+= "  WHERE SDX.D1_FILIAL='"+xFilial("SD1")+"'            AND      "
         _cQryD1+= "        RTRIM(SD1.D1_LOTECTL) like '%'||RTRIM(SDX.D1_DOC)||'%'     AND "
         _cQryD1+= "        SDX.D1_TES    <>'018'                        AND               "
         _cQryD1+= "        SDX.D_E_L_E_T_ <>'*'  ) )  )  VALOR_RATEADO_DOLAR,             "
         
         _cQryD1+= "  (   "    
         _cQryD1+= "     ((SD1.D1_TOTAL/SF1.F1_VALMERC ) *( SELECT SUM(SDX.D1_TOTAL)       "
         _cQryD1+= " FROM "+RetSqlName("SD1")+" SDX                                        "
         _cQryD1+= "  WHERE SDX.D1_FILIAL='"+xFilial("SD1")+"'                         AND "
         _cQryD1+= "       RTRIM(SD1.D1_LOTECTL) like '%'||RTRIM(SDX.D1_DOC)||'%'     AND "
         _cQryD1+= "        SDX.D1_TES    <>'018'                        AND "
         _cQryD1+= "       SDX.D_E_L_E_T_ <>'*'  ) ) )*  SF1.F1_TXMOEDA  VALOR_RATEADO_PESO, "
         _cQryD1+= " SD1.R_E_C_N_O_ AS RECNO "
        


		_cQryD1+= " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1  "    

		_cQryD1+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'               AND    "
		_cQryD1+= "       SD1.D1_REMITO='"+SD1->D1_DOC+"'                       AND    "
		_cQryD1+= "       SD1.D1_FORNECE = '"+SD1->D1_FORNECE+"'             AND    "
		_cQryD1+= "       SD1.D1_LOJA    = '"+SD1->D1_LOJA+"'                AND    "
		_cQryD1+= "       SD1.D_E_L_E_T_ <> '*'                              AND    " 
		_cQryD1+= "       SF1.F1_FILIAL = SD1.D1_FILIAL                      AND    "
		_cQryD1+= "       SD1.D1_SERIE ='E'                                  AND    "
		_cQryD1+= "  	   SF1.F1_DOC    = SD1.D1_DOC                         AND    "
		_cQryD1+= "  	   SF1.F1_FORNECE = SD1.D1_FORNECE                    AND    "  
		_cQryD1+= " 	   SF1.F1_LOJA   = SD1.D1_LOJA                        AND    "
		_cQryD1+= "  	   SF1.F1_SERIE =SD1.D1_SERIE                         AND    "
		_cQryD1+= "       SF1.D_E_L_E_T_ <> '*'                                     "              


		_cQryD1+= "     )T2 ON (T1.D1_FILIAL = T2.FIL AND T1.D1_DOC=T2.REMITO AND T1.D1_FORNECE=T2.FORNECE AND T1.D1_LOJA =T2.LOJA  AND T1.D1_COD=T2.COD AND SD1.D1_SERIE='R'  )  "                   
		_cQryD1+= " 	 WHEN MATCHED THEN                                                                                                                    "
		_cQryD1+= " 	 UPDATE SET T1.D1_CUSRP1 = T1.D1_CUSRP1+T2.VALOR_RATEADO_PESO,T1.D1_CUSTO=T1.D1_CUSTO+T2.VALOR_RATEADO_PESO,T1.D1_CUSRP2=T1.D1_CUSRP2+VALOR_RATEADO_DOLAR,T1.D1_CUSTO2=T1.D1_CUSTO2+T2.VALOR_RATEADO_DOLAR "

		TcSqlExec( _cQryD1 )
        */
        
        
        
        
	Endif

return