#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSTFAT67  บAutor  ณRenato Nogueira     บ Data ณ  27/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de pedidos em aberto (exporta็ใo)               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Exporta็ใo                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT67()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT67"
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

oReport := TReport():New(cPergTit,"Relat๓rio de pedidos em aberto exporta็ใo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de pedidos em aberto de exporta็ใo")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Pedidos",{"SC6"})

	TRCell():New(oSection,"PEDIDO"	  			 ,,"PEDIDO"					,"@!"		   				,6  ,.F.,)
	TRCell():New(oSection,"NOME"			 	 ,,"CLIENTE"				,"@!"		   				,40 ,.F.,)
	TRCell():New(oSection,"EMISSAO"				 ,,"EMISSAO"				,"@!" 			   			,10 ,.F.,)
	TRCell():New(oSection,"COND"				 ,,"COND"					,"@!"				  		,3  ,.F.,)
	TRCell():New(oSection,"ITEM"				 ,,"ITEM"					,"@!"						,2  ,.F.,)
	TRCell():New(oSection,"QTDVEN"				 ,,"QTD VENDIDA"			,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"QTDENT"				 ,,"QTD ENTREGUE"			,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"PRODUTO"				 ,,"PRODUTO"				,"@!"				  		,15 ,.F.,)
	TRCell():New(oSection,"GRUPO"				 ,,"GRUPO"					,"@!"				 	 	,45 ,.F.,)
	TRCell():New(oSection,"ORIGEM"				 ,,"ORIGEM"					,"@!"				  		,1  ,.F.,)
	TRCell():New(oSection,"FALTA"				 ,,"FALTA"					,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"VLRFALTA"			 ,,"VLR FALTA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"RESERVA"				 ,,"RESERVA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"VLRRESERVA"			 ,,"VLR RESERVA"			,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"EMPENHO"				 ,,"EMPENHO"				,"@E 999,999,999.99"  		,12 ,.F.,)

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
Local aDados1[15]
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""         
Local nHours
Local nMinuts
Local nSeconds

	oSection1:Cell("PEDIDO")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("NOME")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("EMISSAO")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("COND")		  			:SetBlock( { || aDados1[04] } )
	oSection1:Cell("ITEM")		  			:SetBlock( { || aDados1[05] } )
	oSection1:Cell("QTDVEN")	  			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("QTDENT")				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("PRODUTO")				:SetBlock( { || aDados1[08] } )
	oSection1:Cell("GRUPO")	  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("ORIGEM")	  			:SetBlock( { || aDados1[10] } )
	oSection1:Cell("FALTA")	  				:SetBlock( { || aDados1[11] } )
	oSection1:Cell("RESERVA")	  			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("EMPENHO")	  			:SetBlock( { || aDados1[13] } )
	oSection1:Cell("VLRFALTA") 				:SetBlock( { || aDados1[14] } )
	oSection1:Cell("VLRRESERVA")			:SetBlock( { || aDados1[15] } )
	
oReport:SetTitle("Pedidos em aberto exporta็ใo")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	If  Select(cAliasLif) > 0
		
		While (cAliasLif)->(!Eof())
			
			aDados1[01]	:=	(cAliasLif)->PEDIDO
			aDados1[02]	:=	(cAliasLif)->NOME
			aDados1[03]	:=	DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[04]	:= 	(cAliasLif)->COND
			aDados1[05]	:=	(cAliasLif)->ITEM
			aDados1[06]	:=	(cAliasLif)->QTDVEN
			aDados1[07]	:= 	(cAliasLif)->QTDENT
			aDados1[08]	:=	(cAliasLif)->PRODUTO
			aDados1[09]	:=	(cAliasLif)->GRUPO
			aDados1[10]	:=	(cAliasLif)->ORIGEM
			aDados1[11]	:=	(cAliasLif)->FALTA
			aDados1[12]	:=	(cAliasLif)->RESERVA
			aDados1[13]	:=	(cAliasLif)->EMPENHO
			aDados1[14]	:=	(cAliasLif)->VLRFALTA
			aDados1[15]	:=	(cAliasLif)->VLRRESERVA

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

	cQuery := " SELECT C6_NUM PEDIDO, A1_NOME NOME, C5_EMISSAO EMISSAO, C5_CONDPAG COND, C6_ITEM ITEM, C6_QTDVEN QTDVEN, "
	cQuery += " C6_QTDENT QTDENT, C6_PRODUTO PRODUTO, BM_DESC GRUPO, B1_CLAPROD ORIGEM, "
	cQuery += " NVL((SELECT SUM(PA1_QUANT) FROM "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_=' ' AND PA1_FILIAL=C6.C6_FILIAL AND PA1_CODPRO=C6_PRODUTO AND PA1_DOC=C6_NUM||C6_ITEM),0) AS FALTA, "
	cQuery += " NVL((SELECT SUM(PA2_QUANT) FROM "+RetSqlName("PA2")+" PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_FILRES=C6.C6_FILIAL AND PA2_CODPRO=C6_PRODUTO AND PA2_DOC=C6_NUM||C6_ITEM),0) AS RESERVA, "
	cQuery += " NVL((SELECT SUM(DC_QUANT) FROM "+RetSqlName("SDC")+" DC WHERE DC.D_E_L_E_T_=' ' AND DC_ORIGEM='SC6' AND DC_FILIAL=C6_FILIAL AND DC_PEDIDO=C6_NUM AND DC_ITEM=C6_ITEM),0) AS EMPENHO, "
	cQuery += " NVL((SELECT SUM(ROUND((C6.C6_VALOR/C6.C6_QTDVEN)*PA11.PA1_QUANT,2)) FROM "+RetSqlName("PA1")+" PA11 WHERE PA11.D_E_L_E_T_=' ' AND PA1_FILIAL=C6.C6_FILIAL AND PA1_CODPRO=C6_PRODUTO AND PA1_DOC=C6_NUM||C6_ITEM),0) AS VLRFALTA,
	cQuery += " NVL((SELECT SUM(ROUND((C6.C6_VALOR/C6.C6_QTDVEN)*PA22.PA2_QUANT,2)) FROM "+RetSqlName("PA2")+" PA22 WHERE PA22.D_E_L_E_T_=' ' AND PA2_FILRES=C6.C6_FILIAL AND PA2_CODPRO=C6_PRODUTO AND PA2_DOC=C6_NUM||C6_ITEM),0) AS VLRRESERVA
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery += " ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM AND C5.C5_CLIENT=C6.C6_CLI AND C5.C5_LOJACLI=C6.C6_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery += " ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1_COD=C6_PRODUTO "
	cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM "
	cQuery += " ON B1_GRUPO=BM_GRUPO " 
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND BM.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	cQuery += " AND C5_TIPOCLI='X' AND A1_PAIS NOT IN ('493','063') AND C6.C6_QTDVEN - C6.C6_QTDENT > 0 AND C6.C6_BLQ = ' ' "
	cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND C6_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND A1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " AND A1_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	cQuery += " AND C6_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	cQuery += " ORDER BY C6_NUM, C6_NUM, C6_ITEM, C6_PRODUTO "                    	 

cQuery := ChangeQuery(cQuery)

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

Aadd(aPergs,{"Emissao de ?                 ","Emissao de ?                 ","Emissao de ?                 ","mv_ch1","D",8,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Emissao ate ?                ","Emissao ate ?                ","Emissao ate ?                ","mv_ch2","D",8,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Pedido de ?  		           ","Pedido de ?     		       ","Pedido de ?       	       ","mv_ch3","C",6,0,0,"G",""                    ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Pedido ate ?     		       ","Pedido ate ?    		       ","Pedido ate ?      	       ","mv_ch4","C",6,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Cliente de ?  		       ","Cliente de ?     		       ","Cliente de ?       	       ","mv_ch5","C",6,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
Aadd(aPergs,{"Cliente ate ?     		   ","Cliente ate ?    		       ","Cliente ate ?      	       ","mv_ch6","C",6,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
Aadd(aPergs,{"Loja de ?  			       ","Loja de ?     		       ","Loja de ?     	  	       ","mv_ch7","C",2,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Loja ate ?     			   ","Loja ate ?    		       ","Loja ate ?     	 	       ","mv_ch8","C",2,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Produto de ?  		       ","Produto de ?     		       ","Produto de ?       	       ","mv_ch9","C",15,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Produto ate ?     		   ","Produto ate ?    		       ","Produto ate ?      	       ","mv_cha","C",15,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})

//AjustaSx1(cPerg,aPergs)

Return