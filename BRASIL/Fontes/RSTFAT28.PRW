#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  RSTFAT28     ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RSTFAT28()

	Local   oReport
	Private cPerg 			:= "RFAT28"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	PutSx1(cPerg, "01", "Da Data:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ate Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Do Vendedor:" 	,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C",6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Vendedor:"  ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 	,"mv_ch4","C",6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Comissao",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Comissão")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Comissão",{"SC5"})

	TRCell():New(oSection,"PREFIXO"	  	,,"PREFIXO"		,,3,.F.,)
	TRCell():New(oSection,"VENDEDOR"  	,,"VENDEDOR"	,,6,.F.,)
	TRCell():New(oSection,'NOME'  		,,'NOME'		,,35,.F.,)
	TRCell():New(oSection,"CLIENTE"  	,,"CLIENTE"		,,6,.F.,)
	TRCell():New(oSection,'NOME_CLI'  	,,'NOME_CLI'	,,35,.F.,)
	TRCell():New(oSection,"PEDIDO"  	,,"PEDIDO"		,,6,.F.,)
	TRCell():New(oSection,"NUMERO"		,,"NUMERO"		,,9,.F.,)
	TRCell():New(oSection,"PARCELA"		,,"PARCELA"		,,3,.F.,)
	TRCell():New(oSection,"EMISSAO"  	,,"EMISSAO"	    ,,10,.F.,)
	TRCell():New(oSection,"LIQUIDO"     ,,"LIQUIDO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"PRODUTO"     ,,"PRODUTO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"COMTOT"      ,,"COMISSAO NF"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ICMS"       	,,"ICMS"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"PIS"       	,,"PIS"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"COFINS"      ,,"COFINS"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ST"       	,,"ST"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"IPI"       	,,"IPI"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TOTALNF"     ,,"TOTALNF"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"RECEBIDO"    ,,"RECEBIDO"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"%RECEBIDO"   ,,"%RECEBIDO" 	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"COMISSAO"    ,,"COMISSAO"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"%COMISSAO"   ,,"%COMISSAO" 	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CONTRATO"  	,,"CONTRATO"	,,10,.F.,)
	TRCell():New(oSection,"BAIXA"  		,,"BAIXA"	    ,,10,.F.,)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[50]
	Local _cSta 	:= ''

	oSection1:Cell("PREFIXO")    	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("VENDEDOR")  	:SetBlock( { || aDados1[02] } )
	oSection1:Cell('NOME')  		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("CLIENTE")       :SetBlock( { || aDados1[04] } )
	oSection1:Cell('NOME_CLI')  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("NUMERO")		:SetBlock( { || aDados1[06] } )
	oSection1:Cell("EMISSAO")		:SetBlock( { || aDados1[07] } )
	oSection1:Cell("PRODUTO")     	:SetBlock( { || aDados1[08] } )
	oSection1:Cell("ICMS")     		:SetBlock( { || aDados1[09] } )
	oSection1:Cell("PIS")			:SetBlock( { || aDados1[10] } )
	oSection1:Cell("COFINS")      	:SetBlock( { || aDados1[11] } )
	oSection1:Cell("ST")			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("IPI")     		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("TOTALNF")		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("RECEBIDO")		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("COMISSAO")		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("%COMISSAO")		:SetBlock( { || aDados1[17] } )
	oSection1:Cell("CONTRATO")		:SetBlock( { || aDados1[18] } )
	oSection1:Cell("COMTOT")		:SetBlock( { || aDados1[19] } )
	oSection1:Cell("BAIXA")			:SetBlock( { || aDados1[20] } )
	oSection1:Cell("PARCELA")		:SetBlock( { || aDados1[21] } )
	oSection1:Cell("LIQUIDO")		:SetBlock( { || aDados1[22] } )
	oSection1:Cell("%RECEBIDO")		:SetBlock( { || aDados1[23] } )
	oSection1:Cell("PEDIDO")		:SetBlock( { || aDados1[24] } )
	oReport:SetTitle("Comissao")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If  Select(cAliasLif) > 0
		While 	(cAliasLif)->( !Eof() )
			aDados1[01]	:= (cAliasLif)->E1_PREFIXO
			aDados1[02]	:= (cAliasLif)->E1_VEND1
			aDados1[03]	:= (cAliasLif)->A3_NOME
			aDados1[04]	:= (cAliasLif)->A1_COD
			aDados1[05]	:= (cAliasLif)->A1_NOME
			aDados1[06]	:= (cAliasLif)->E1_NUM
			aDados1[07]	:= (cAliasLif)->EMISSAO
			aDados1[08]	:= (cAliasLif)->NOTA
			aDados1[09]	:= (cAliasLif)->ICMS
			aDados1[10]	:= (cAliasLif)->PIS
			aDados1[11]	:= (cAliasLif)->COFINS
			aDados1[12]	:= (cAliasLif)->ST
			aDados1[13]	:= (cAliasLif)->IPI
			aDados1[14]	:= (cAliasLif)->NOTA+(cAliasLif)->IPI+(cAliasLif)->ST
			aDados1[15]	:= (cAliasLif)->RECEBIDO - (cAliasLif)->RADEV
			aDados1[18]	:= (cAliasLif)->A3_XDTASSI
			aDados1[19]	:= (cAliasLif)->COMISSAO
			aDados1[20]	:= (cAliasLif)->E1_BAIXA
			aDados1[21]	:= (cAliasLif)->E1_PARCELA
			aDados1[22]	:= (cAliasLif)->VALOR_LIQUIDO
			aDados1[23]	:= ((cAliasLif)->RECEBIDO - (cAliasLif)->RADEV)/aDados1[14]
			dbSelectArea("SD2")
			SD2->( dbSetOrder(3) )	// D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
			If SD2->( dbSeek(xFilial("SD2")+	(cAliasLif)->E1_NUM+'001'+(cAliasLif)->A1_COD) )
				aDados1[24]	:=  SD2->D2_PEDIDO
			EndIf
			aDados1[17] := (cAliasLif)->COMISSAO / (cAliasLif)->NOTA
			If !((cAliasLif)->E1_VEND1 $ 'R00051/R00041/R00482/R00492')
				IF (cAliasLif)->XBASE <>'T' // Calculo normal atual 
				   aDados1[16]	:=   ((cAliasLif)->NOTA * (((cAliasLif)->RECEBIDO - (cAliasLif)->RADEV) / aDados1[14])) * ((cAliasLif)->COMISSAO / (cAliasLif)->NOTA)
				ELSE 
                   //Calculo pelo total da nota fiscal 
				   aDados1[16]	:=   (aDados1[14] * (((cAliasLif)->RECEBIDO - (cAliasLif)->RADEV) / aDados1[14])) * ((cAliasLif)->COMISSAO / (cAliasLif)->NOTA)
				ENDIF   
			Else
				aDados1[16]	:=   ((cAliasLif)->VALOR_LIQUIDO * aDados1[23]) * aDados1[17]
			EndIf
			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
		End
	EndIf

	oReport:SkipLine()

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function StQuery()

	Local cQuery := ' '

	cQuery := " SELECT
	cQuery += " SE1.E1_PREFIXO,
	cQuery += " SE1.E1_NUM    ,
	cQuery += " SE1.E1_PARCELA   ,
	cQuery += " SE1.E1_VEND1  ,
	cQuery += " SA3.A3_NOME,
	cQuery += " SA3.A3_XBASE XBASE ,

	cQuery += " Substr(SE1.E1_BAIXA,7,2)||'/'||Substr(SE1.E1_BAIXA,5,2)||'/'||Substr(SE1.E1_BAIXA,1,4)
	cQuery += ' "E1_BAIXA",
	cQuery += " Substr(SA3.A3_XDTASSI,7,2)||'/'||Substr(SA3.A3_XDTASSI,5,2)||'/'||Substr(SA3.A3_XDTASSI,1,4)
	cQuery += ' "A3_XDTASSI" ,
	cQuery += " SA1.A1_NOME,
	cQuery += " SA1.A1_COD,
	cQuery += " Substr(SE1.E1_EMISSAO,7,2)||'/'||Substr(SE1.E1_EMISSAO,5,2)||'/'||Substr(SE1.E1_EMISSAO,1,4)
	cQuery += ' "EMISSAO" ,
	cQuery += ' SUM(SE5.E5_VALOR-SE5.E5_VLJUROS-SE5.E5_VLMULTA) "RECEBIDO",
 
	cQuery += " (SELECT Nvl(SUM(FE5.E5_VALOR),0) FROM UDBP12.SE5010 FE5 "                    // Valdemir Rabelo 06/05/2022 - Chamado: 20220506009627
	cQuery += " WHERE FE5.D_E_L_E_T_ = ' '
	cQuery += " 	AND FE5.E5_FILIAL = '02'
	cQuery += " 	AND FE5.E5_NUMERO =  SE1.E1_NUM
	cQuery += " 	AND FE5.E5_RECPAG = 'P'
	cQuery += " 	AND FE5.E5_TIPODOC = 'ES'
	cQuery += " 	AND FE5.E5_TIPO  = 'NF')
	cQuery += ' "RADEV",
	//############################
 
	cQuery += " (SELECT Nvl(SUM((SD2.D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6) * (SD2.D2_COMIS1/100)),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "EXCOMISSAO",

	cQuery += " (SELECT Nvl(SUM((SD2.D2_TOTAL) * (SD2.D2_COMIS1/100)),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "COMISSAO",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_TOTAL ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "NOTA",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "VALOR_LIQUIDO",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_VALICM ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "ICMS",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_VALIMP5 ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "COFINS",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_VALIMP6 ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "PIS",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_VALIPI ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "IPI",

	cQuery += " (SELECT Nvl(SUM(SD2.D2_ICMSRET ),0) FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " 	AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_SERIE = '001')
	cQuery += ' "ST"

	cQuery += " FROM " + RetSqlName("SE5") + " SE5 "

	cQuery += " INNER JOIN( SELECT * FROM " + RetSqlName("SE1") + " )SE1 "
	cQuery += " ON SE1.D_E_L_E_T_ = ' '
	cQuery += " 	AND SE5.E5_FILIAL = SE1.E1_FILIAL
	cQuery += " 	AND SE5.E5_PREFIXO = SE1.E1_PREFIXO
	cQuery += " 	AND SE5.E5_NUMERO  = SE1.E1_NUM
	cQuery += " 	AND SE5.E5_PARCELA  =SE1.E1_PARCELA
	cQuery += " 	AND (SUBSTR(SE1.E1_VEND1,1,1) = 'R' or SUBSTR(SE1.E1_VEND1,1,1) = 'E' )
	cQuery += " 	AND SE1.E1_VEND1 BETWEEN   '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "

	cQuery += "  INNER JOIN (SELECT * FROM " + RetSqlName("SA3") + " )SA3 "
	cQuery += "  ON  SA3.D_E_L_E_T_ = ' '
	cQuery += "  	AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' "
	cQuery += "  	AND SA3.A3_COD = SE1.E1_VEND1

	cQuery += "  INNER JOIN (SELECT * FROM " + RetSqlName("SA1") + " )SA1 "
	cQuery += "  ON  SA1.D_E_L_E_T_ = ' '
	cQuery += "  	AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery += "  	AND SA1.A1_COD = SE1.E1_CLIENTE
	cQuery += "  	AND SA1.A1_LOJA = SE1.E1_LOJA

	cQuery += " WHERE SE5.E5_DATA BETWEEN   '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery += " 	AND   SE5.D_E_L_E_T_ = ' '
	cQuery += " 	AND SE5.E5_RECPAG = 'R'
	cQuery += " 	AND NOT EXISTS (SELECT * FROM " + RetSqlName("SE5") + " TE5
	cQuery += " WHERE TE5.D_E_L_E_T_ = ' '
	cQuery += " 	AND TE5.E5_NUMERO =SE5.E5_NUMERO
	cQuery += " 	AND TE5.E5_MOTBX = SE5.E5_MOTBX
	cQuery += "  	AND TE5.E5_RECPAG = 'R'
	cQuery += "  	AND  (TE5.E5_HISTOR   LIKE '%Cancelamento%' OR
	cQuery += "  	TE5.E5_HISTOR   = 'Cancel. de Compensacao                                                                                                  ' )
	cQuery += "  	AND TE5.E5_SEQ = SE5.E5_SEQ)
	 
	cQuery += "      AND  SE5.E5_HISTOR  not  LIKE '%Multa%'
	cQuery += " AND (SE5.E5_MOTBX IN ('NOR','LIQ') OR ( SE5.E5_MOTBX = 'CMP'
	//cQuery += " AND  (SE5.E5_HISTOR LIKE 'Compensaçäo de Adiantamentos%'    OR SE5.E5_HISTOR LIKE 'Compens. Adiantamento%') 
	cQuery += " AND SE5.E5_DOCUMEN LIKE '%RA%' AND SE5.E5_TIPO = 'NF'))
	cQuery += " AND SE5.E5_FILIAL= '" + xFilial("SE5") + "' "
	cQuery += " AND EXISTS (SELECT D2_FILIAL FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_DOC = SE1.E1_NUM
	cQuery += " AND SD2.D2_FILIAL = SE1.E1_FILIAL
	cQuery += " AND SD2.D2_SERIE = '001'  )

	cQuery += " GROUP BY
	cQuery += " SE1.E1_PREFIXO,
	cQuery += " SE1.E1_NUM    ,SE1.E1_PARCELA ,
	cQuery += " SE1.E1_VEND1 ,SA3.A3_NOME  ,  SA1.A1_NOME , SA1.A1_COD , E1_EMISSAO ,SE1.E1_BAIXA
	cQuery += " ,SA3.A3_XDTASSI , SA3.A3_XBASE 
	cQuery += " ORDER BY SE1.E1_VEND1,SE1.E1_PREFIXO,SE1.E1_NUM

	// SELECT SE1.E1_PREFIXO, SE1.E1_NUM    , SE1.E1_PARCELA   , SE1.E1_VEND1  , SA3.A3_NOME, substr(SE1.E1_BAIXA,7,2)||'/'||substr(SE1.E1_BAIXA,5,2)||'/'||substr(SE1.E1_BAIXA,1,4) "E1_BAIXA", substr(SA3.A3_XDTASSI,7,2)||'/'||substr(SA3.A3_XDTASSI,5,2)||'/'||substr(SA3.A3_XDTASSI,1,4) "A3_XDTASSI" , SA1.A1_NOME, SA1.A1_COD, substr(SE1.E1_EMISSAO,7,2)||'/'||substr(SE1.E1_EMISSAO,5,2)||'/'||substr(SE1.E1_EMISSAO,1,4) "EMISSAO" , SUM(SE5.E5_VALOR-SE5.E5_VLJUROS-SE5.E5_VLMULTA) "RECEBIDO", (SELECT nvl(SUM((SD2.D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6) * (SD2.D2_COMIS1/100)),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "EXCOMISSAO", (SELECT nvl(SUM((SD2.D2_TOTAL) * (SD2.D2_COMIS1/100)),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "COMISSAO", (SELECT nvl(SUM(SD2.D2_TOTAL ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "NOTA", (SELECT nvl(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "VALOR_LIQUIDO", (SELECT nvl(SUM(SD2.D2_VALICM ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "ICMS", (SELECT nvl(SUM(SD2.D2_VALIMP5 ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "COFINS", (SELECT nvl(SUM(SD2.D2_VALIMP6 ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "PIS", (SELECT nvl(SUM(SD2.D2_VALIPI ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "IPI", (SELECT nvl(SUM(SD2.D2_ICMSRET ),0) FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = '02' AND SD2.D2_SERIE = '001') "ST" FROM SE5010 SE5  INNER JOIN( SELECT * FROM SE1010 )SE1  ON SE1.D_E_L_E_T_ = ' ' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO  = SE1.E1_NUM AND SE5.E5_PARCELA  =SE1.E1_PARCELA AND (SUBSTR(SE1.E1_VEND1,1,1) = 'R' or SUBSTR(SE1.E1_VEND1,1,1) = 'E' ) AND SE1.E1_VEND1 BETWEEN   'R00051' AND 'R00051'   INNER JOIN (SELECT * from SA3010 )SA3   ON  SA3.D_E_L_E_T_ = ' '  AND SA3.A3_FILIAL = '  '  AND SA3.A3_COD = SE1.E1_VEND1  INNER JOIN (SELECT * from SA1010 )SA1   ON  SA1.D_E_L_E_T_ = ' '  AND SA1.A1_FILIAL = '  '  AND SA1.A1_COD = SE1.E1_CLIENTE  AND SA1.A1_LOJA = SE1.E1_LOJA WHERE SE5.E5_DATA BETWEEN   '20180801' AND '20180901'  AND   SE5.D_E_L_E_T_ = ' ' AND SE5.E5_RECPAG = 'R' AND (SE5.E5_MOTBX = 'NOR'   OR ( SE5.E5_MOTBX = 'CMP'  AND  (SE5.E5_HISTOR LIKE 'Compensaçäo de Adiantamentos%'    OR SE5.E5_HISTOR LIKE 'Compens. Adiantamento%') AND SE5.E5_DOCUMEN LIKE '%RA%' AND SE5.E5_TIPO = 'NF')) AND SE5.E5_FILIAL= '02' AND EXISTS (SELECT D2_FILIAL FROM SD2010 SD2  WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_FILIAL = SE1.E1_FILIAL AND SD2.D2_SERIE = '001'  ) GROUP BY SE1.E1_PREFIXO, SE1.E1_NUM    ,SE1.E1_PARCELA , SE1.E1_VEND1 ,SA3.A3_NOME  ,  SA1.A1_NOME , SA1.A1_COD , E1_EMISSAO ,SE1.E1_BAIXA ,SA3.A3_XDTASSI ORDER BY SE1.E1_VEND1,SE1.E1_PREFIXO,SE1.E1_NUM"

	cQuery := ChangeQuery(cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return
