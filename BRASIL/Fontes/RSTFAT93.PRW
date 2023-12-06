#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT93     ºAutor  ³Renato Nogueira º Data ³  24/08/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de transito 01 para 02			                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT93()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT93"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Da Emissao:"	,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Até a Emissao:","Até a Emissao:"	,"Até a Emissao:" 		,"mv_ch2","D"   ,08     	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Do Produto:" 	,"Da Data: ?" 		,"Da Data: ?" 			,"mv_ch3","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Produto:" 	,"Ate Data: ?" 		,"Ate Data: ?" 			,"mv_ch4","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Do Grupo:" 	,"Do Vendedor: ?" 	,"Do Vendedor: ?" 		,"mv_ch5","C"	,04			,0			,0		,"G"	,""		,'SBM' 		,""			,""		,"mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Grupo:"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 		,"mv_ch6","C"	,04			,0			,0		,"G"	,""		,'SBM' 		,""			,""		,"mv_par06","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO TRANSITO 01 - 02",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de transito 01 - 02")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SD2",{"SD2"})

	TRCell():New(oSection,"D2_COD"			,,"CODIGO"			,,15,.F.,)
	TRCell():New(oSection,"B1_DESC"			,,"DESCRICAO"		,,50,.F.,)
	TRCell():New(oSection,"B1_XABC"			,,"ABC"				,,01,.F.,)
	TRCell():New(oSection,"B1_XFMR"			,,"FMR"				,,01,.F.,)
	TRCell():New(oSection,"B1_MSBLQL"		,,"BLOQUEADO"		,,01,.F.,)
	TRCell():New(oSection,"B1_XDESAT"		,,"DESATIVADO"		,,01,.F.,)
	TRCell():New(oSection,"B1_GRUPO"		,,"GRUPO"			,,04,.F.,)
	TRCell():New(oSection,"BM_DESC"			,,"DESCRICAO"		,,20,.F.,)
	//TRCell():New(oSection,"SLDATU"			,,"SALDO ATUAL"				,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"SLDABE"			,,"SALDO ABERTO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ESTOQUE"	   		,,"Estoque" 				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CARTEIRA"	   	,,"Carteira" 				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CRED_CARTEIRA"  	,,"Carteira Crédito"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FALTAREAL"		,,"FALTA REAL"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"QTDTRANSITO"		,,"TRANSITO MES"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FALTA_TRANSITO"  ,,"ESTOQUE COM TRANSITO"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"SALDOSP"  		,, "SALDO PEDIDO SP"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"EMBARQUESP"		,, "ESTOQUE COM SALDO PEDIDO SP" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"MediaTrim"	   	,,"Media Trim" 				,"@E 99,999,999.99",14)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SD2")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell('D2_COD')  :SetBlock( { || aDados1[01] } )
	oSection1:Cell('B1_DESC')  :SetBlock( { || aDados1[02] } )
	oSection1:Cell('B1_XABC')  	:SetBlock( { || aDados1[03] } )
	oSection1:Cell('B1_XFMR') :SetBlock( { || aDados1[04] } )
	oSection1:Cell('B1_MSBLQL')  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell('B1_XDESAT')  	:SetBlock( { || aDados1[06] } )
	oSection1:Cell('B1_GRUPO')  	:SetBlock( { || aDados1[07] } )
	oSection1:Cell('BM_DESC') :SetBlock( { || aDados1[08] } )
	//oSection1:Cell('SLDATU')  	:SetBlock( { || aDados1[09] } )
	//oSection1:Cell('SLDABE') :SetBlock( { || aDados1[10] } )
	oSection1:Cell('QTDTRANSITO') :SetBlock( { || aDados1[11] } )
	oSection1:Cell('FALTAREAL') :SetBlock( { || aDados1[12] } )
	oSection1:Cell('MediaTrim') :SetBlock( { || aDados1[13] } )
	oSection1:Cell('ESTOQUE') :SetBlock( { || aDados1[14] } )
	oSection1:Cell('CARTEIRA') :SetBlock( { || aDados1[15] } )
	oSection1:Cell('CRED_CARTEIRA') :SetBlock( { || aDados1[16] } )
	oSection1:Cell('FALTA_TRANSITO') :SetBlock( { || aDados1[17] } )
	oSection1:Cell('SALDOSP') :SetBlock( { || aDados1[18] } )
	oSection1:Cell('EMBARQUESP') :SetBlock( { || aDados1[19] } )
	
	oReport:SetTitle("SD2")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
		
			aDados1[01]	:=  (cAliasLif)->B1_COD
			aDados1[02]	:=  (cAliasLif)->B1_DESC
			aDados1[03]	:=  (cAliasLif)->B1_XABC
			aDados1[04]	:=  (cAliasLif)->B1_XFMR
			aDados1[05]	:=  IIf((cAliasLif)->B1_MSBLQL=="2","N","S")
			aDados1[06]	:=	IIf((cAliasLif)->B1_XDESAT=="2","S","N")
			aDados1[07]	:= 	(cAliasLif)->B1_GRUPO
			aDados1[08]	:= 	(cAliasLif)->BM_DESC
			//aDados1[09]	:=	(cAliasLif)->SLDATU
			//aDados1[10]	:=	(cAliasLif)->SLDABE
			aDados1[11]	:=	(cAliasLif)->QTDTRANSITO
			
			aDados1[13]	:=	GETMEDIA((cAliasLif)->B1_COD)
			aDados1[14]	:=	(cAliasLif)->ESTOQUE
			aDados1[15]	:=	(cAliasLif)->CARTEIRA
			
			aDados1[12]	:=	aDados1[14]-aDados1[15]
			
			aDados1[16]	:=	(cAliasLif)->CRED_CARTEIRA
			aDados1[17]	:=	aDados1[11]+aDados1[12]
			aDados1[18]	:=	(cAliasLif)->SALDOSP
			aDados1[19]	:=	aDados1[18]+aDados1[17]

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT B1_COD, B1_DESC, B1_XABC, B1_XFMR, B1_MSBLQL, B1_XDESAT, B1_GRUPO, BM_DESC, QTDTRANSITO, SLDATU, SLDABE, "
	cQuery += " SLDATU-SLDABE AS FALTAREAL, ESTOQUE, CARTEIRA, CRED_CARTEIRA, CARTEIRA-ESTOQUE-QTDTRANSITO FALTA_TRANSITO, SALDOSP "
	cQuery += " FROM ( "
	cQuery += " SELECT B1_COD, B1_DESC, B1_XABC, B1_XFMR, B1_MSBLQL, B1_XDESAT, B1_GRUPO, BM_DESC, "
		
	cQuery += " NVL((SELECT SUM(D2_QUANT) FROM "+RetSqlName("SF2")+" F2 "
	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE "
	cQuery += " AND D2_LOJA=F2_LOJA "
	cQuery += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND F2_EMISSAO>'20150801' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND F2_FILIAL='01' AND F2_CLIENTE='033467' AND F2_LOJA='02' AND F2_DOC||F2_SERIE NOT IN ( SELECT F1_DOC||F1_SERIE FROM "+RetSqlName("SF1")+" F1 "
	cQuery += " WHERE F1.D_E_L_E_T_=' ' AND F1_FILIAL='02' AND F1_FORNECE='005764' AND F1_LOJA='01') AND D2.D2_COD=B1.B1_COD),0) AS QTDTRANSITO, "
		
	cQuery += " NVL((SELECT	SUM(B2_QATU) SALDO FROM	"+RetSqlName("SB2")+" B2 WHERE B2.D_E_L_E_T_=' ' AND B2_FILIAL='02' AND B2_COD=B1.B1_COD),0) AS SLDATU, "
		
	cQuery += " NVL((SELECT	SUM(C6_QTDVEN-C6_QTDENT) FROM "+RetSqlName("SC6")+" C6 LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO=C6_TES "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND F4.D_E_L_E_T_=' ' AND C6_FILIAL='02' AND C6_BLQ=' ' AND F4_DUPLIC='S' AND F4_ESTOQUE='S' "
	cQuery += " AND C6_PRODUTO=B1.B1_COD),0) AS SLDABE, "
		
	cQuery += " (NVL((SELECT SUM(SB2.B2_QATU) FROM "+RetSqlName("SB2")+" SB2 WHERE SB2.D_E_L_E_T_ = ' ' AND SB2.B2_FILIAL = '02' AND SB2.B2_COD = B1.B1_COD "
	cQuery += " AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' ) ),0)) AS ESTOQUE, "
		
	cQuery += " (NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND SC5.C5_XTRONF=' ' AND SC6.C6_PRODUTO = B1.B1_COD AND SC6.C6_FILIAL = '02' " //Chamado 003047 - Retirar troca de nota do relatório
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11'  AND SC6.C6_BLQ <> 'R' AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' ' AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_BLCRED IN ('01','09') "
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL) AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0)) AS CARTEIRA, "
		
	cQuery += " (NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND SC5.C5_XTRONF=' ' AND SC6.C6_PRODUTO = B1.B1_COD AND SC6.C6_FILIAL = '02' " //Chamado 003047 - Retirar troca de nota do relatório
	cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39'  OR SC5.C5_TIPOCLI = 'X') AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11'  "
	cQuery += " AND SC6.C6_BLQ <> 'R' AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0 AND EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' ' AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_BLCRED IN ('01','09') "
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL) ),0)) AS CRED_CARTEIRA, "
	
	cQuery += " (NVL((SELECT
	cQuery += "  SUM(
	cQuery += " FC6.C6_QTDVEN - FC6.C6_QTDENT)
	cQuery += ' FROM SC6010 FC6
	cQuery += " WHERE FC6.D_E_L_E_T_ = ' '
	cQuery += " AND FC6.C6_FILIAL = '01'
	cQuery += " AND FC6.C6_CLI = '033467'
	cQuery += " AND FC6.C6_LOJA = '02'
	cQuery += " AND FC6.C6_QTDVEN > FC6.C6_QTDENT
	cQuery += " AND FC6.C6_BLQ <> 'R'
	cQuery += " AND FC6.C6_OPER = '15' "
	cQuery += " AND FC6.C6_PRODUTO = B1.B1_COD),0))
	cQuery += " AS SALDOSP "
		
	cQuery += " FROM "+RetSqlName("SB1")+" B1 "
	cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM "
	cQuery += " ON BM.BM_GRUPO=B1.B1_GRUPO AND BM.D_E_L_E_T_=' ' "
	cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1.B1_CLAPROD='F' AND B1.B1_LOCPAD='03' "
	cQuery += " AND B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND BM_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " ) XXX WHERE (ESTOQUE>0 OR CARTEIRA>0 OR CRED_CARTEIRA>0) "


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function GETMEDIA(_cCod)

	Local _nMedia	:= 0

	DbSelectArea("SB3")
	SB3->(DbSetOrder(1))
	SB3->(Dbseek(xfilial("SB3")+_cCod))
	_nMedia  := (&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2))+;
		&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2))+;
		&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)))/3

Return(_nMedia)