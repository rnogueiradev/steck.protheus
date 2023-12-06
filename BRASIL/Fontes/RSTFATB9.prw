#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CRLF chr(10)+chr(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATB9   บAutor  ณRichard N Cabral  บ Data ณ  30/11/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Anแlise de Oferta Logํstica II                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATB9()		//U_RSTFATB9()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATB9"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	cHelp15 := "Informe o c๓digo para filtro ou * para Todos, X somente imprimir produtos que Nใo Controla ou deixe em branco para todos exceto os que Nใo Controla"

	U_STPutSx1( cPerg, "01","Produto de:"			   		,"MV_PAR01","mv_ch1","C",15,0,"G",,"SB1"	,"@!")
	U_STPutSx1( cPerg, "02","Produto at้:"			   		,"MV_PAR02","mv_ch2","C",15,0,"G",,"SB1"	,"@!")
	U_STPutSx1( cPerg, "03","Grupo de:"    			   		,"MV_PAR03","mv_ch3","C",04,0,"G",,"SBM"	,"@!")
	U_STPutSx1( cPerg, "04","Grupo At้:"   			   		,"MV_PAR04","mv_ch4","C",04,0,"G",,"SBM"	,"@!")
	U_STPutSx1( cPerg, "05","Grp.Vendas de?" 		   		,"MV_PAR05","mv_ch5","C",06,0,"G",,"ACY"	,"@!")
	U_STPutSx1( cPerg, "06","Grp.Vendas ate?"		   		,"MV_PAR06","mv_ch6","C",06,0,"G",,"ACY"	,"@!")
	U_STPutSx1( cPerg, "07","Cliente de?" 			   		,"MV_PAR07","mv_ch7","C",06,0,"G",,"SA1"	,"@!")
	U_STPutSx1( cPerg, "08","Cliente ate?"					,"MV_PAR08","mv_ch8","C",06,0,"G",,"SA1"	,"@!")
	U_STPutSx1( cPerg, "09","Data Entrega de?" 		   		,"MV_PAR09","mv_ch9","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "10","Data Entrega ate?"				,"MV_PAR10","mv_cha","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "11","Data Lib.Financ. de?" 		   	,"MV_PAR11","mv_chb","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "12","Data Lib.Financ. ate?"			,"MV_PAR12","mv_chc","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "13","Data Faturamento de?" 		   	,"MV_PAR13","mv_chd","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "14","Data Faturamento ate?"			,"MV_PAR14","mv_che","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "15","Prazo Oferta Logistica?"		,"MV_PAR15","mv_chf","C",01,0,"G",,"ZZO001"	,"@!",,,,,,cHelp15)

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef  บAutor  ณRichard N Cabral  บ Data ณ  30/11/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Anแlise de Oferta Logํstica II                             บฑฑ
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

	Pergunte(cPerg,.T.)

	oReport := TReport():New(cPergTit,"Relatorio de Anแlise de Oferta Logํstica",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o relat๓rio de Anแlise de Oferta Logํstica")

	oSection := TRSection():New(oReport,"Anแlise de Oferta Logํstica",{"SC6"})

	TRCell():New(oSection,"01",,"Pedido"				,"@!"		,06,.F.,)
	TRCell():New(oSection,"02",,"Cliente"				,"@!"		,06,.F.,)
	TRCell():New(oSection,"03",,"Loja"					,"@!"		,02,.F.,)
	TRCell():New(oSection,"04",,"Razใo Social"			,"@!"		,40,.F.,)
	TRCell():New(oSection,"05",,"Grupo Vendas"			,"@!"		,06,.F.,)
	TRCell():New(oSection,"06",,"Descri็ใo Grupo Vendas","@!"		,30,.F.,)
	TRCell():New(oSection,"07",,"Item"					,"@!"		,02,.F.,)
	TRCell():New(oSection,"08",,"Produto"				,"@!"		,15,.F.,)
	TRCell():New(oSection,"09",,"Descri็ใo Produto"		,"@!"		,50,.F.,)
	TRCell():New(oSection,"10",,"Grupo"					,"@!"		,04,.F.,)
	TRCell():New(oSection,"11",,"Descri็ใo Grupo"		,"@!"		,45,.F.,)
	TRCell():New(oSection,"12",,"Qtde.Vendida"			,"@!"		,08,.F.,)
	TRCell():New(oSection,"13",,"Qtde.Entregue"			,"@!"		,08,.F.,)
	TRCell():New(oSection,"14",,"Data Emissใo"			,"@!"		,10,.F.,)
	TRCell():New(oSection,"15",,"Data Maior Entrega"	,"@!"		,10,.F.,)
	TRCell():New(oSection,"16",,"Data Entrega"			,"@!"		,10,.F.,)
	TRCell():New(oSection,"17",,"Data Entrega 2"		,"@!"		,10,.F.,)
	TRCell():New(oSection,"18",,"Resํduo"				,"@!"		,04,.F.,)
	TRCell():New(oSection,"19",,"Tipo Fatura"			,"@!"		,07,.F.,)
	TRCell():New(oSection,"20",,"Data Faturamento"		,"@!"		,10,.F.,)
	TRCell():New(oSection,"21",,"Data Lib.Financ."		,"@!"		,10,.F.,)
	TRCell():New(oSection,"22",,"Dias OF"				,"@E 9999"	,03,.F.,)
	TRCell():New(oSection,"23",,"Data Separa็ใo De"		,"@!"		,10,.F.,)
	TRCell():New(oSection,"24",,"Data Separa็ใo At้"	,"@!"		,10,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrintบAutor  ณRichard N Cabral  บ Data ณ  30/11/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Anแlise de Oferta Logํstica II                             บฑฑ
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
	Local aDados[24]

	oSection:Cell("01") :SetBlock( { || aDados[01] } )
	oSection:Cell("02") :SetBlock( { || aDados[02] } )
	oSection:Cell("03") :SetBlock( { || aDados[03] } )
	oSection:Cell("04") :SetBlock( { || aDados[04] } )
	oSection:Cell("05") :SetBlock( { || aDados[05] } )
	oSection:Cell("06") :SetBlock( { || aDados[06] } )
	oSection:Cell("07") :SetBlock( { || aDados[07] } )
	oSection:Cell("08") :SetBlock( { || aDados[08] } )
	oSection:Cell("09") :SetBlock( { || aDados[09] } )
	oSection:Cell("10") :SetBlock( { || aDados[10] } )
	oSection:Cell("11") :SetBlock( { || aDados[11] } )
	oSection:Cell("12") :SetBlock( { || aDados[12] } )
	oSection:Cell("13") :SetBlock( { || aDados[13] } )
	oSection:Cell("14") :SetBlock( { || aDados[14] } )
	oSection:Cell("15") :SetBlock( { || aDados[15] } )
	oSection:Cell("16") :SetBlock( { || aDados[16] } )
	oSection:Cell("17") :SetBlock( { || aDados[17] } )
	oSection:Cell("18") :SetBlock( { || aDados[18] } )
	oSection:Cell("19") :SetBlock( { || aDados[19] } )
	oSection:Cell("20") :SetBlock( { || aDados[20] } )
	oSection:Cell("21") :SetBlock( { || aDados[21] } )
	oSection:Cell("22") :SetBlock( { || aDados[22] } )
	oSection:Cell("23") :SetBlock( { || aDados[23] } )
	oSection:Cell("24") :SetBlock( { || aDados[24] } )

	oReport:SetTitle("Anแlise de Oferta Logํstica")

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()


	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		Do While (cAliasLif)->(!Eof())

			dDtSepDe	:= CtoD("  /  /  ")
			dDtSepAte	:= CtoD("  /  /  ") 
			If	! Empty((cAliasLif)->C5_XDE)  .And. ! Empty((cAliasLif)->C5_XMDE)  .And. ! Empty((cAliasLif)->C5_XDANO) .And. ; 
				! Empty((cAliasLif)->C5_XATE) .And. ! Empty((cAliasLif)->C5_XMATE) .And. ! Empty((cAliasLif)->C5_XAANO)
				dDtSepDe	:= StoD((cAliasLif)->(C5_XDANO+C5_XMDE+C5_XDE))
				dDtSepAte	:= StoD((cAliasLif)->(C5_XAANO+C5_XMATE+C5_XATE)) 
 			EndIf
			aDados[01]	:=  (cAliasLif)->C6_NUM
			aDados[02]	:=  (cAliasLif)->C5_CLIENTE
			aDados[03]	:=  (cAliasLif)->C5_LOJACLI
			aDados[04]	:=  (cAliasLif)->A1_NOME
			aDados[05]	:=  (cAliasLif)->ACY_GRPVEN
			aDados[06]	:=  (cAliasLif)->ACY_DESCRI
			aDados[07]	:=  (cAliasLif)->C6_ITEM
			aDados[08]	:=  (cAliasLif)->C6_PRODUTO
			aDados[09]	:=	(cAliasLif)->B1_DESC
			aDados[10]	:=	(cAliasLif)->B1_GRUPO
			aDados[11]	:= 	(cAliasLif)->BM_DESC
			aDados[12]	:=  (cAliasLif)->C6_QTDVEN
			aDados[13]	:=  (cAliasLif)->C6_QTDENT
			aDados[14]	:= 	StoD((cAliasLif)->C6_ZDTEMIS)
			aDados[15]	:= 	StoD((cAliasLif)->C5_XDTEN)
			aDados[16]	:= 	StoD((cAliasLif)->C6_ENTRE1)
			aDados[17]	:= 	StoD((cAliasLif)->C6_ZENTRE2)
			aDados[18]	:=  (cAliasLif)->C6_BLQ
			aDados[19]	:=  (cAliasLif)->TIPO
			aDados[20]	:= 	StoD((cAliasLif)->C6_DATFAT)
			aDados[21]	:= 	StoD((cAliasLif)->C6_ZDTLIBF)
			aDados[22]	:= 	(cAliasLif)->C6_ZPROFL
			aDados[23]	:= 	dDtSepDe
			aDados[24]	:= 	dDtSepAte

			oSection:PrintLine()
			aFill(aDados,nil)
			(cAliasLif)->(dbskip())
		EndDo
	
		oSection:PrintLine()
		aFill(aDados,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery    บAutor  ณRichard N Cabral  บ Data ณ  30/11/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Anแlise de Oferta Logํstica II                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery := ' '

	cQuery := " SELECT C5_CLIENTE, C5_LOJACLI, C5_XDTEN, C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, C6_QTDENT, " + CRLF
	cQuery += " C5_XDE, C5_XMDE, C5_XDANO, C5_XATE, C5_XMATE, C5_XAANO, " + CRLF
	cQuery += " CASE WHEN C5_XTIPF = 1 THEN 'TOTAL' ELSE 'PARCIAL' END AS TIPO, " + CRLF
	cQuery += " B1_DESC, B1_GRUPO, BM_DESC, B1_ZCODOL, A1_NOME, ACY_GRPVEN, ACY_DESCRI, " + CRLF
	cQuery += " C6_ZDTEMIS, C6_ZDTLIBF, C6_ZPROFL, C6_ENTRE1, C6_ZENTRE2, C6_DATFAT, C6_BLQ " + CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SC5") + " SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND SC5.D_E_L_E_T_= ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SF4") + " SF4 ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("ACY") + " ACY ON ACY_GRPVEN = A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SBM") + " SBM ON BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cQuery += " AND (B1_TIPO = 'PA' OR B1_TIPO = 'PI') " + CRLF
	cQuery += " AND F4_ESTOQUE = 'S' " + CRLF
	cQuery += " AND F4_DUPLIC = 'S' " + CRLF
	cQuery += " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
	cQuery += " AND B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	cQuery += " AND C6_ZDTLIBF BETWEEN '" + DtoS(MV_PAR11) + "' AND '" + Dtos(MV_PAR12) + "' " + CRLF
	cQuery += " AND C6_ENTRE1 BETWEEN '" + DtoS(MV_PAR09) + "' AND '" + Dtos(MV_PAR10) + "' " + CRLF
	cQuery += " AND C6_DATFAT BETWEEN '" + DtoS(MV_PAR13) + "' AND '" + Dtos(MV_PAR14) + "' " + CRLF
	cQuery += " AND C6_CLI BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " + CRLF
	cQuery += " AND A1_GRPVEN BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
	If MV_PAR15 <> "*"
		If MV_PAR15 = " "
			cQuery += " AND B1_ZCODOL <> 'X' " + CRLF
		Else
			cQuery += " AND B1_ZCODOL = '" + MV_PAR15 + "' " + CRLF
		EndIf		
	EndIf		
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " ORDER BY C6_NUM, C6_ITEM " + CRLF

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
