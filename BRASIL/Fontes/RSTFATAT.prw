#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAT     ºAutor  ³Giovani Zago    º Data ³  24/01/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ESTOQUE CONSOLIDADO 	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAT()
	
	Local   oReport
	Private cPerg 			:= "RFATAT"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Produto de:" 	,"Produto de:" 	 ,"Produto de:" 		 	,"mv_ch1","C",12,0,0,"G","",'SB1' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Produto Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch2","C",12,0,0,"G","",'SB1' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Armazem de:" 	,"Produto de:" 	 ,"Produto de:" 			,"mv_ch3","C",02,0,0,"G","",' ' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Armazem Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch4","C",02,0,0,"G","",' ' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	
	
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
	
	oReport := TReport():New(cPergTit,"RELATÓRIO ESTOQUE CONSOLIDADO ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório ESTOQUE CONSOLIDADO ")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"ESTOQUE CONSOLIDADO ",{"SC6"})
	
	
	TRCell():New(oSection,"01",,"FILIAL"				,,02,.F.,)
	TRCell():New(oSection,"02",,"PRODUTO"				,,15,.F.,)
	TRCell():New(oSection,"03",,"DESCRIÇÃO" 			,,30,.F.,)
	TRCell():New(oSection,"04",,"ARMAZEM" 				,,02,.F.,)
	TRCell():New(oSection,"05",,"TIPO" 					,,01,.F.,)
	TRCell():New(oSection,"06",,"ESTOQUE"				,"@E 999,999.99",3)
	TRCell():New(oSection,"07",,"PARA ENDEREÇAR"		,"@E 999,999.99",3)
	TRCell():New(oSection,"08",,"ESTOQUE ENDEREÇOS(SBF)","@E 999,999.99",3)
	TRCell():New(oSection,"09",,"EMPENHO ENDEREÇOS(SBF)","@E 999,999.99",3)
	TRCell():New(oSection,"10",,"EMPENHO (SDC)"			,"@E 999,999.99",3)
	TRCell():New(oSection,"11",,"ESTOQUE(SB2) X ENDEREÇO(SBF)"		,"@E 999,999.99",3)
	TRCell():New(oSection,"12",,"EMPENHO(SBF) X EMPENHO(SDC)"		,"@E 999,999.99",3)
	TRCell():New(oSection,"13",,"ESTOQUE(SB2) X EMPENHO(SDC)"		,"@E 999,999.99",3)
	TRCell():New(oSection,"14",,"CUSTO"		,"@E 999,999.99",3)
	
	
 
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")
	
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
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	
	
	oReport:SetTitle("ESTOQUE")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
		 	aDados1[01]	:=  (cAliasLif)->B2_FILIAL
			aDados1[02]	:=  (cAliasLif)->B2_COD
			aDados1[03]	:=  (cAliasLif)->B1_DESC
			aDados1[04]	:=  (cAliasLif)->B2_LOCAL
			aDados1[05]	:=   (cAliasLif)->B1_APROPRI
			aDados1[06]	:=  (cAliasLif)->B2_QATU
			aDados1[07]	:= (cAliasLif)->B2_QACLASS
			aDados1[08]	:= (cAliasLif)->QTD_ENDEREÇO__SBF
			aDados1[09]	:= (cAliasLif)->QTD_EMPENHO1_ENDEREÇO__SBF
			aDados1[10]	:=  (cAliasLif)->EMPENHO2__SDC
			aDados1[11]	:= (cAliasLif)->DIF_EST_X_ENDEREÇO
			aDados1[12]	:= (cAliasLif)->DIF_EMPENHO1_X_EMPENHO2
			aDados1[13]	:= (cAliasLif)->DIF_EST_X_EMPENHO
			aDados1[14]	:= (cAliasLif)->CUSTO
 
	
	
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
	
	
		
	
	
	
	
	cQuery := " 	SELECT  B2_FILIAL ,    B2_COD  ,  B1_DESC,     B2_LOCAL ,    B2_QATU ,B2_QACLASS,B1_APROPRI,
	cQuery += " 	NVL((SELECT SUM(BF_QUANT)  FROM "+RetSqlName("SBF")+" BF WHERE BF.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=BF.BF_FILIAL  AND BF.BF_PRODUTO=SB2.B2_COD AND BF.BF_LOCAL=SB2.B2_LOCAL),0) AS QTD_ENDEREÇO__SBF,
	cQuery += " 	NVL((SELECT SUM(BF_EMPENHO)  FROM "+RetSqlName("SBF")+" BF WHERE BF.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=BF.BF_FILIAL  AND BF.BF_PRODUTO=SB2.B2_COD AND BF.BF_LOCAL=SB2.B2_LOCAL),0) AS QTD_EMPENHO1_ENDEREÇO__SBF,
	cQuery += " 	NVL((SELECT SUM(DC_QUANT)  FROM "+RetSqlName("SDC")+" SDC WHERE SDC.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=SDC.DC_FILIAL  AND SDC.DC_PRODUTO=SB2.B2_COD AND SDC.DC_LOCAL=SB2.B2_LOCAL),0) AS EMPENHO2__SDC,

	cQuery += " 	(B2_QATU -B2_QACLASS -
	cQuery += " 	NVL((SELECT SUM(BF_QUANT)  FROM "+RetSqlName("SBF")+" BF WHERE BF.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=BF.BF_FILIAL  AND BF.BF_PRODUTO=SB2.B2_COD AND BF.BF_LOCAL=SB2.B2_LOCAL),0)) AS DIF_EST_X_ENDEREÇO,

	cQuery += " 	(NVL((SELECT SUM(BF_EMPENHO)  FROM "+RetSqlName("SBF")+" BF WHERE BF.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=BF.BF_FILIAL  AND BF.BF_PRODUTO=SB2.B2_COD AND BF.BF_LOCAL=SB2.B2_LOCAL),0) -
	cQuery += " 	NVL((SELECT SUM(DC_QUANT)  FROM "+RetSqlName("SDC")+" SDC WHERE SDC.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=SDC.DC_FILIAL  AND SDC.DC_PRODUTO=SB2.B2_COD AND SDC.DC_LOCAL=SB2.B2_LOCAL),0)) AS DIF_EMPENHO1_X_EMPENHO2,


	cQuery += " 	(B2_QATU -B2_QACLASS -
	cQuery += " 	NVL((SELECT SUM(DC_QUANT)  FROM "+RetSqlName("SDC")+" SDC WHERE SDC.D_E_L_E_T_=' ' AND SB2.B2_FILIAL=SDC.DC_FILIAL  AND SDC.DC_PRODUTO=SB2.B2_COD AND SDC.DC_LOCAL=SB2.B2_LOCAL),0)) AS DIF_EST_X_EMPENHO,

	cQuery += "   NVL((SELECT B9_CM1 FROM "+RetSqlName("SB9")+" SB9 WHERE SB9.D_E_L_E_T_ = ' ' AND B9_FILIAL = B2_FILIAL AND B9_COD = B2_COD AND B9_LOCAL = B2_LOCAL AND B9_DATA >=  '"+dtos(DDATABASE-31)+"'),0) AS CUSTO  " //+SubStr(dtoc(DDATABASE-31),8)+"'),0) AS CUSTO



	cQuery += " 	FROM "+RetSqlName("SB2")+" SB2
	cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+")SB1
	cQuery += " 	ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += " 	AND SB1.B1_COD = B2_COD


	cQuery += " 	WHERE SB2.D_E_L_E_T_ = ' ' 
	cQuery += " 	AND B2_FILIAL = '"+xFilial("SB2")+"' 
	cQuery += " 	AND B2_LOCAL BETWEEN '"+  MV_PAR03 +"' AND '"+  MV_PAR04 +"'
	cQuery += " 	AND B2_COD BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'


	
	
	
	
	
	 
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

