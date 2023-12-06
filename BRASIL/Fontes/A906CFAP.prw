#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA906CFAP    บAutor  ณCristiano Pereira บ Data ณ  03/18/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณComposi็ใo da base das saํdas / tributadas CIAP             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑTicket 20191204000012                                                   บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A906CFAP()


	Local cQuery := ""

	cAliasSD2 := GetNextAlias() 

	cQuery := "SELECT D2_EMISSAO, D2_TIPO, D2_TES, D2_CF, SUM(D2_TOTAL) D2_TOTAL ,SUM(D2_SEGURO) D2_SEGURO, "
	cQuery += " SUM(D2_VALFRE) D2_VALFRE, SUM(D2_DESPESA) D2_DESPESA, SUM(D2_VALIPI) D2_VALIPI, "
	cQuery += " SUM(D2_ICMSRET) D2_ICMSRET, SUM(D2_DESCICM) D2_DESCICM, SUM(D2_BASEICM)  D2_BASEICM, SUM(D2_VALBRUT) D2_VALBRUT, "
	cQuery += " SUM(SFT.FT_VALCONT) FT_VALCONT, SUM(SFT.FT_BASEICM) FT_BASEICM, SUM(SFT.FT_OUTRICM) FT_OUTRICM, SUM(SFT.FT_ISENICM) FT_ISENICM, SUM(SFT.FT_TOTAL) FT_TOTAL FROM "
	cQuery +=   RetSqlName("SD2")+" SD2 "			
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4  ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = SD2.D2_TES AND F4_LFICM NOT IN ('N','Z') AND F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ = ' ' )"
	cQuery += " INNER JOIN "+RetSqlName("SFT")+" SFT  ON "
	cQuery += " (SFT.FT_FILIAL = '"+xFilial("SFT")+"' AND SFT.FT_TIPOMOV='S'AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE AND SFT.FT_CLIEFOR = SD2.D2_CLIENTE AND SFT.FT_LOJA = SD2.D2_LOJA AND SFT.FT_ITEM = SD2.D2_ITEM AND SFT.D_E_L_E_T_='') "
	cQuery += " WHERE D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(ParamIXB[1])+"' AND '"+dTos(ParamIXB[2])+"'"     
	cQuery += " AND D2_TIPO <> 'I'"
	cQuery += " AND ( SD2.D2_CF NOT IN ('5913 ','5920','5921','6912','6913','6916') )  " 
	cQuery += " AND (SD2.D2_CF LIKE '5%' OR SD2.D2_CF LIKE '6%' OR SD2.D2_CF LIKE '7%') "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " AND F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND F4_CODIGO = D2_TES "
	cQuery += " AND F4_LFICM NOT IN ('N','Z')"
	cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY  D2_EMISSAO, D2_TIPO, D2_TES,D2_CF "
	
	
	cQuery += " UNION ALL "
	
	cQuery += "SELECT D1_DTDIGIT D2_EMISSAO, D2_TIPO, D2_TES, D2_CF, SUM(D1_TOTAL)*(-1) D2_TOTAL, SUM(D1_SEGURO)*(-1) D2_SEGURO, SUM(D1_VALFRE)*(-1) D2_VALFRE, SUM(D1_DESPESA)*(-1) D2_DESPESA, SUM(D1_VALIPI)*(-1) D2_VALIPI, SUM(D1_ICMSRET)*(-1) D2_ICMSRET, SUM(D1_DESCICM)*(-1) D2_DESCICM, SUM(D1_BASEICM)*(-1) D2_BASEICM, SUM(D1_TOTAL - D1_VALDESC + D1_VALFRE + D1_SEGURO + D1_DESPESA)*(-1) D2_VALBRUT, "
	cQuery += " SUM(SFT2.FT_VALCONT)*(-1) FT_VALCONT, SUM(SFT2.FT_BASEICM)*(-1) FT_BASEICM, SUM(SFT2.FT_OUTRICM)*(-1) FT_OUTRICM, SUM(SFT2.FT_ISENICM)*(-1) FT_ISENICM, SUM(SFT2.FT_TOTAL)*(-1) FT_TOTAL "
	cQuery += "FROM "+RetSqlName("SD1")+" SD1 INNER JOIN "+RetSqlName("SD2")+" SD2 ON (SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_CLIENTE = SD1.D1_FORNECE  AND SD2.D2_LOJA = SD1.D1_LOJA AND SD2.D2_COD = SD1.D1_COD AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D_E_L_E_T_ = '') "
	cQuery += "INNER JOIN  "+RetSqlName("SFT")+" SFT2  ON "
	cQuery += "(SFT2.FT_FILIAL ='"+xFilial("SFT")+"' AND SFT2.FT_TIPOMOV='E' AND SFT2.FT_NFISCAL = SD1.D1_DOC AND SFT2.FT_SERIE = SD1.D1_SERIE AND SFT2.FT_CLIEFOR = SD1.D1_FORNECE AND SFT2.FT_LOJA = SD1.D1_LOJA AND SFT2.FT_ITEM = SD1.D1_ITEM AND SFT2.D_E_L_E_T_='')"				
	cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND SD1.D1_DTDIGIT BETWEEN '"+dTos(ParamIXB[1])+"' AND '"+dTos(ParamIXB[2])+"' AND SD1.D1_TIPO = 'D' AND SD1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY D1_DTDIGIT, D2_TIPO, D2_TES, D2_CF "	
    cQuery += " ORDER BY D2_EMISSAO"

	cQuery := ChangeQuery(cQuery)  




	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2)  

	TCSETFIELD(cAliasSD2,"D2_EMISSAO","D",8,0)



return(cAliasSD2)
