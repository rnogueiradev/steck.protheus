#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSTFAT65  บAutor  ณRenato Nogueira     บ Data ณ  18/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de pedidos e or็amentos	                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Marketing                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT65()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT65"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

Ajusta()

oReport		:= ReportDef()
oReport:PrintDialog()

FreeObj(oReport)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณRenato Nogueira     บ Data ณ  22/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
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

oReport := TReport():New(cPergTit,"Relat๓rio de pedidos/or็amentos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de pedidos/or็amentos")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Pedidos/Or็amentos",{"SC6"})

	TRCell():New(oSection,"TIPO"	  			 ,,"TIPO"					,"@!"			   			,7  ,.F.,)
	TRCell():New(oSection,"VIROUPED"	  		 ,,"VIROU PEDIDO?"			,"@!"			   			,2  ,.F.,)
	TRCell():New(oSection,"NUMERO"	   			 ,,"NUMERO"					,"@!"			   			,6  ,.F.,)
	TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"					,"@!"			   			,15 ,.F.,)
	TRCell():New(oSection,"DESC"			 	 ,,"DESCRICAO"				,"@!" 			   			,50 ,.F.,)
	TRCell():New(oSection,"GRUPO"				 ,,"GRUPO"					,"@!" 			   			,45 ,.F.,)
	TRCell():New(oSection,"AGRUP"				 ,,"AGRUPAMENTO"			,"@!"				  		,55 ,.F.,)
	TRCell():New(oSection,"QTDE"				 ,,"QTDE"					,"@E 999,999,999.99"		,12 ,.F.,)
	TRCell():New(oSection,"VALOR"				 ,,"VALOR"					,"@E 999,999,999.99"	  	,12 ,.F.,)
	TRCell():New(oSection,"MARKUP"				 ,,"MARKUP"					,"@E 999,999,999.99"	  	,12 ,.F.,)
	TRCell():New(oSection,"VEND1"				 ,,"VEND1"					,"@!"					  	,6  ,.F.,)
	TRCell():New(oSection,"VEND2"				 ,,"VEND2"					,"@!"				  		,6  ,.F.,)
	TRCell():New(oSection,"AREA"				 ,,"AREA"					,"@!"				  		,5  ,.F.,)
	TRCell():New(oSection,"CLIENTE"				 ,,"CLIENTE"				,"@!"				 	 	,40 ,.F.,)
	TRCell():New(oSection,"TPCLI"				 ,,"TIPO"					,"@!"				 	 	,08 ,.F.,)
	TRCell():New(oSection,"REGIAO"				 ,,"REGIAO"					,"@!"				 	 	,15 ,.F.,)
	TRCell():New(oSection,"EMISSAO"				 ,,"EMISSAO"				,"@!"				 	 	,10 ,.F.,)
	

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC6")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบAutor  ณRenato Nogueira     บ Data ณ  22/07/14  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
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
Local aDados1[17]
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""         
Local nHours
Local nMinuts
Local nSeconds

	oSection1:Cell("CODIGO")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESC")  					:SetBlock( { || aDados1[02] } )
	oSection1:Cell("GRUPO")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("AGRUP")		  			:SetBlock( { || aDados1[04] } )
	oSection1:Cell("QTDE")		  			:SetBlock( { || aDados1[05] } )
	oSection1:Cell("VALOR")		  			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("VEND1")	  				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("VEND2")	  				:SetBlock( { || aDados1[08] } )
	oSection1:Cell("AREA")	  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("CLIENTE")	  			:SetBlock( { || aDados1[10] } )
	oSection1:Cell("TIPO")		  			:SetBlock( { || aDados1[11] } )
	oSection1:Cell("VIROUPED")	  			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("EMISSAO")	  			:SetBlock( { || aDados1[13] } )
	oSection1:Cell("NUMERO")	  			:SetBlock( { || aDados1[14] } )
	oSection1:Cell("TPCLI")		  			:SetBlock( { || aDados1[15] } )
	oSection1:Cell("REGIAO")	  			:SetBlock( { || aDados1[16] } )
	oSection1:Cell("MARKUP")	  			:SetBlock( { || aDados1[17] } )
	
oReport:SetTitle("Pedidos/Or็amento")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	If  Select(cAliasLif) > 0
		
		While (cAliasLif)->(!Eof())
			
			aDados1[01]	:=	(cAliasLif)->CODIGO
			aDados1[02]	:=	(cAliasLif)->DESCRICAO
			aDados1[03]	:=	(cAliasLif)->GRUPO
			aDados1[04]	:= 	(cAliasLif)->AGRUPAMENTO
			aDados1[05]	:=	(cAliasLif)->QUANTIDADE
			aDados1[06]	:=	(cAliasLif)->VALOR
			aDados1[07]	:= 	(cAliasLif)->VEND1
			aDados1[08]	:=	(cAliasLif)->VEND2
			aDados1[09]	:=	(cAliasLif)->AREA
			aDados1[10]	:=	(cAliasLif)->CLIENTE
			aDados1[11]	:=	(cAliasLif)->TIPO
			aDados1[12]	:=	(cAliasLif)->VIROUPED
			aDados1[13]	:=	DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[14]	:=	(cAliasLif)->NUMERO
			aDados1[15]	:=	(cAliasLif)->TPCLI
			aDados1[16]	:=	U_STREGIAO((cAliasLif)->ESTADO)
			aDados1[17]	:=	(cAliasLif)->MARKUP

			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			(cAliasLif)->(dbskip())
			
		EndDo

		oReport:SkipLine()
		
	EndIf
	
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณRenato Nogueira บ Data ณ  21/02/14     บฑฑ
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
Static Function StQuery(cCodOpe)
*-----------------------------*

Local cQuery     := ' '

	cQuery := " SELECT TIPO, VIROUPED, CODIGO, NUMERO, DESCRICAO, GRUPO, AGRUPAMENTO, QUANTIDADE, VALOR, MARKUP,
	cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=VEND1),0) VEND1, " 
	cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=VEND2),0) VEND2, "
	cQuery += " AREA, CLIENTE, ESTADO, EMISSAO, TPCLI "
	cQuery += " FROM ( "
	cQuery += " SELECT 'PEDIDO' TIPO, 'PEDIDO' VIROUPED, C5_NUM NUMERO, C6_PRODUTO CODIGO, B1_DESC DESCRICAO, BM_DESC GRUPO, X5_DESCRI AGRUPAMENTO, C6_QTDVEN QUANTIDADE,  "
	cQuery += " C6_ZVALLIQ VALOR, C6_ZMARKUP MARKUP, C5_VEND1 VEND1, C5_VEND2 VEND2, SUBSTR(C5_VEND1,2,5) AREA, A1_NOME CLIENTE, A1_EST ESTADO, C5_EMISSAO EMISSAO, A1_ATIVIDA TPCLI "
	cQuery += " FROM "+RetSqlName("SC5")+" C5 "
	cQuery += " LEFT JOIN "+RetSqlName("SC6")+" C6 "
	cQuery += " ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM AND C5.C5_CLIENTE=C6.C6_CLI AND C5.C5_LOJACLI=C6.C6_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery += " ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1_COD=C6_PRODUTO "
	cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM "
	cQuery += " ON B1_GRUPO=BM_GRUPO AND BM.D_E_L_E_T_=' '  "
	cQuery += " LEFT JOIN "+RetSqlName("SX5")+" SX "
	cQuery += " ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP AND SX.D_E_L_E_T_=' '  "
	cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	cQuery += " AND C6.C6_OPER='01' "
	cQuery += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND BM_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND BM_XAGRUP BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " AND A1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR09+"' "
	cQuery += " AND A1_LOJA BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR10+"' "
	cQuery += " AND A1_COD NOT LIKE '"+MV_PAR11+"' "
	cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR12)+"' AND '"+DTOS(MV_PAR13)+"' "
	cQuery += " UNION ALL "
	cQuery += " SELECT 'COTACAO' TIPO, (CASE WHEN UA_NUMSC5=' ' THEN 'NAO' ELSE 'SIM' END) VIROUPED, "
	cQuery += " UA_NUM, UB_PRODUTO CODIGO, B1_DESC DESCRICAO, BM_DESC GRUPO, X5_DESCRI AGRUPAMENTO, UB_QUANT QUANTIDADE, "
	cQuery += " UB_ZVALLIQ VALOR, UB_ZMARKUP MARKUP, UA_VEND VEND1, 'NAOPOSSUI' VEND2, SUBSTR(UA_VEND,2,5) AREA, A1_NOME, A1_EST ESTADO, UA_EMISSAO EMISSAO, A1_ATIVIDA TPCLI "
	cQuery += " FROM "+RetSqlName("SUA")+" UA "
	cQuery += " LEFT JOIN "+RetSqlName("SUB")+" UB "
	cQuery += " ON UA.UA_FILIAL=UB.UB_FILIAL AND UA.UA_NUM=UB.UB_NUM "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1_COD=UB_PRODUTO "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery += " ON UA_CLIENTE=A1_COD AND UA_LOJA=A1_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM "
	cQuery += " ON B1_GRUPO=BM_GRUPO AND BM.D_E_L_E_T_=' ' "
	cQuery += " LEFT JOIN "+RetSqlName("SX5")+" SX "
	cQuery += " ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP AND SX.D_E_L_E_T_=' ' "
	cQuery += " WHERE UA.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	cQuery += " AND UB.UB_OPER='01' "
	//cQuery += " AND UA_NUMSC5=' ' "
	cQuery += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND BM_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND BM_XAGRUP BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " AND A1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR09+"' "
	cQuery += " AND A1_LOJA BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR10+"' "
	cQuery += " AND A1_COD NOT LIKE '"+MV_PAR11+"' "
	cQuery += " AND UA_EMISSAO BETWEEN '"+DTOS(MV_PAR12)+"' AND '"+DTOS(MV_PAR13)+"' "
	cQuery += " ) "
	cQuery += " ORDER BY TIPO, CODIGO, GRUPO, AGRUPAMENTO "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณAjusta    ณ Autor ณ Vitor Merguizo 		  ณ Data ณ 16/08/2012		ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	ณฑฑ
ฑฑณ          ณ no SX3                                                           	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ 																		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch1","C",15,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch2","C",15,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch3","C",4,0,0,"G",""                    ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch4","C",4,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Agrupamento de ?             ","Agrupamento de ?             ","Agrupamento de ?             ","mv_ch5","C",3,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Agrupamento ate ?            ","Agrupamento ate ?            ","Agrupamento ate ?            ","mv_ch6","C",3,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Cliente de ?                 ","Cliente de ?                 ","Cliente de ?                 ","mv_ch7","C",6,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
Aadd(aPergs,{"Loja de ?                    ","Loja de ?                    ","Loja de ?                    ","mv_ch8","C",2,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Cliente ate ?                ","Cliente ate ?                ","Cliente ate ?                ","mv_ch9","C",6,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
Aadd(aPergs,{"Loja ate ?                   ","Loja ate ?                   ","Loja ate ?                   ","mv_cha","C",2,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Nใo Considera os Clientes:   ","Nใo Considera os Clientes:   ","Nใo Considera os Clientes:   ","mv_chb","C",30,0,0,"G",""                   ,"mv_par11","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Data de ?                    ","Data de ?                    ","Data de ?                    ","mv_chc","D",8,0,0,"G",""                    ,"mv_par12","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_chd","D",8,0,0,"G",""                    ,"mv_par13","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1(cPerg,aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTREGIAO  บAutor  ณRenato Nogueira     บ Data ณ  18/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Retorna regiao do estado enviado	                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Marketing                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STREGIAO(_cEst)

Local _cRegiao	:= ""

_cEst	:= AllTrim(_cEst)

Do Case
Case _cEst $ "AC#AM#AP#PA#RO#RR#TO"
_cRegiao	:= "NORTE"
Case _cEst $ "AL#BA#CE#MA#PB#PE#PI#RN#SE"
_cRegiao	:= "NORDESTE"
Case _cEst $ "GO#MS#MT"
_cRegiao	:= "CENTRO-OESTE"
Case _cEst $ "ES#MG#RJ#SP"
_cRegiao	:= "SUDESTE"
Case _cEst $ "PR#RS#SC"
_cRegiao	:= "SUL"
EndCase

Return(_cRegiao)