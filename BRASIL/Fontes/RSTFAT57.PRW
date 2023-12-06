#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT57     บAutor  ณGiovani Zago    บ Data ณ  29/09/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio NGA	Faturamento por cliente                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT57()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT57"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	
	
	PutSx1(cPerg, "01", "Da Data: ?"  		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","D",8,0,0,"G","",' '    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ate Data: ?" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",' '    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Do Vendedor:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Vendedor:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Do Supervisor:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch5","C", 6,0,0,"G","",'SA3' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Supervisor:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch6","C", 6,0,0,"G","",'SA3' ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Ano(01):" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch7","C", 4,0,0,"G","",'' ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "08", "Ano(02):"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch8","C", 4,0,0,"G","",'' ,"","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "09", "Tipo  :"			,"Tipo   :"			,"Tipo    :"        ,"mv_ch9","N", 1,0,0,"C","",''    ,'','',"mv_par09","Completo","","","","Totaliza","","","","","","","","","","")
	
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio ONE VOICE				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"RELATำRIO NGA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio NGA ")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"NGA",{"PPC"})
	
	
	TRCell():New(oSection,"01",,"CODIGO"							,,06,.F.,)
	TRCell():New(oSection,"02",,"LOJA"								,,02,.F.,)
	TRCell():New(oSection,"03",,"NOME" 								,,35,.F.,)
	TRCell():New(oSection,"04",,"GRUPO"								,,03,.F.,)
	TRCell():New(oSection,"05",,"MUNICIPIO"							,,15,.F.,)
	TRCell():New(oSection,"06",,"REPRESENTANTE"						,,06,.F.,)
	TRCell():New(oSection,"07",,"NOME_REPRE"						,,25,.F.,)
	TRCell():New(oSection,"08",,"SUPERVISOR"						,,06,.F.,)
	TRCell():New(oSection,"09",,"NOME_SUPER"						,,25,.F.,)
	TRCell():New(oSection,"10",,"VALOR"								,"@E 99,999,999.99",14)
	
	
	
	
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("PPC")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Produtos em transito	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta 	:= ' '
	Local _cSuper   := ' '
	Local _n10		:= 0
	Local _n11		:= 0
	Local _n12		:= 0
	
	TRCell():New(oSection,"11",,"Ano("+Mv_Par07+")"								,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12",,"Ano("+Mv_Par08+")"									,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13",,"ESTADO"						,,2,.F.,)
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	
	
	oReport:SetTitle("NGA")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			aDados1[01]	:=	(cAliasLif)->CODIGO
			aDados1[02]	:= 	(cAliasLif)->LOJA
			aDados1[03]	:=  (cAliasLif)->NOME
			aDados1[04]	:=  (cAliasLif)->GRUPO
			aDados1[05]	:=  (cAliasLif)->MUNICIPIO
			aDados1[06]	:=	(cAliasLif)->REPRESENTANTE
			aDados1[07]	:= 	(cAliasLif)->NOME_REPRE
			aDados1[08]	:= 	(cAliasLif)->SUPER
			aDados1[09]	:= 	(cAliasLif)->NOME_SUPER
			aDados1[10]	:= 	(cAliasLif)->VALOR
			aDados1[11]	:= 	(cAliasLif)->ANO1
			aDados1[12]	:= 	(cAliasLif)->ANO2
			aDados1[13]	:= 	(cAliasLif)->ESTADO
			
			_n10+= 	(cAliasLif)->VALOR
			_n11+= 	(cAliasLif)->ANO1
			_n12+= 	(cAliasLif)->ANO2
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			_cSuper:=(cAliasLif)->SUPER
			(cAliasLif)->(dbskip())
			
			If (cAliasLif)->SUPER <> _cSuper .Or. (cAliasLif)->(!Eof()) .And. MV_PAR09 = 1
				aDados1[08]	:= 	_cSuper
				aDados1[09]	:= 	'TOTAL'
				aDados1[10]	:= 	_n10
				aDados1[11]	:= 	_n11
				aDados1[12]	:= 	_n12
				_n10:= 0
				_n11:= 0
				_n12:= 0
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
			EndIf
		End
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*
	
	Local cQuery     := ' '
	
	
	cQuery := " SELECT
	cQuery += " SA1.A1_COD
	cQuery += ' "CODIGO",
	cQuery += " SA1.A1_LOJA
	cQuery += ' "LOJA",
	cQuery += " SA1.A1_NOME
	cQuery += ' "NOME",
	cQuery += " SA1.A1_GRPVEN
	cQuery += ' "GRUPO",
	cQuery += " SA1.A1_MUN
	cQuery += ' "MUNICIPIO",
	cQuery += " SA1.A1_EST
	cQuery += ' "ESTADO",
	cQuery += " SA1.A1_VEND
	cQuery += ' "REPRESENTANTE",
	cQuery += " (select SA3.A3_NOME
	cQuery += " from "+RetSqlName("SA3")+" SA3 "
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '  AND SA1.A1_VEND = SA3.A3_COD)
	cQuery += ' AS "NOME_REPRE" ,
	cQuery += " TA3.A3_SUPER
	
	cQuery += ' AS "SUPER" ,
	cQuery += " (select SA3.A3_NOME
	cQuery += " from "+RetSqlName("SA3")+" SA3 "
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '  AND (select SA3.A3_SUPER
	cQuery += " from "+RetSqlName("SA3")+" SA3 "
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '  AND SA1.A1_VEND = SA3.A3_COD) = SA3.A3_COD)
	cQuery += ' AS "NOME_SUPER",
	cQuery += " (((SELECT NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	,0)
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2 "
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_SERIE = SD2.D2_SERIE   WHERE SD2.D_E_L_E_T_ = ' '   AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND  SD2.D2_EMISSAO
	cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += "  AND SA1.A1_COD  = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " )) - (SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND  SD1.D1_EMISSAO
	cQuery += " BETWEEN   '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE  AND SA1.A1_LOJA = SD1.D1_LOJA AND SD1.D1_TIPO = 'D'
	cQuery += ' )) AS "VALOR"   ,
	
	
	
	cQuery += " (((SELECT NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	,0)
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2 "
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_SERIE = SD2.D2_SERIE   WHERE SD2.D_E_L_E_T_ = ' '   AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND  SUBSTR(SD2.D2_EMISSAO,1,4) =  '"+ MV_PAR07+"'
	cQuery += "  AND SA1.A1_COD  = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " )) - (SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery += " AND  SUBSTR(SD1.D1_EMISSAO,1,4)   =  '"+ MV_PAR07+"'
	cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE  AND SA1.A1_LOJA = SD1.D1_LOJA AND SD1.D1_TIPO = 'D'
	cQuery += ' )) AS "ANO1"  ,
	
	cQuery += " (((SELECT NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	,0)
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2 "
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_SERIE = SD2.D2_SERIE   WHERE SD2.D_E_L_E_T_ = ' '   AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND  SUBSTR(SD2.D2_EMISSAO,1,4) =  '"+ MV_PAR08+"'
	cQuery += "  AND SA1.A1_COD  = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " )) - (SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery += " AND  SUBSTR(SD1.D1_EMISSAO,1,4)   =  '"+ MV_PAR08+"'
	cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE  AND SA1.A1_LOJA = SD1.D1_LOJA AND SD1.D1_TIPO = 'D'
	cQuery += ' )) AS "ANO2"
	
	
	cQuery += " FROM "+RetSqlName("SA1")+" SA1 "
	cQuery += " INNER JOIN(select *  from "+RetSqlName("SA3")+" )TA3 "
	cQuery += " ON TA3.D_E_L_E_T_ = ' '  AND SA1.A1_VEND = TA3.A3_COD
	cQuery += " AND TA3.A3_SUPER BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	
	cQuery += " WHERE SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_FILIAL = ' '
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_VEND BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' order by TA3.A3_SUPER
	
	
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

