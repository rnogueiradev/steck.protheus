#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAN     ºAutor  ³Giovani Zago    º Data ³  08/08/16     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Lista Avançada Comercial                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAN()
	
	Local   oReport
	Private cPerg 			:= "RFATAN"
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
	PutSx1(cPerg, "03", "Unicon de:" 	,"Produto de:" 	 ,"Produto de:" 			,"mv_ch3","C",06,0,0,"G","",' ' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Unicon Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch4","C",06,0,0,"G","",' ' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	
	
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
	
	oReport := TReport():New(cPergTit,"RELATÓRIO Lista Avançada",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Lista Avançada")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Financeiro Serasa",{"SC6"})
	
	
	TRCell():New(oSection,"01",,"UNICON"	,,06,.F.,)
	TRCell():New(oSection,"02",,"ITEM"		,,03,.F.,)
	TRCell():New(oSection,"03",,"PRODUTO" 	,,14,.F.,)
	TRCell():New(oSection,"04",,"DESCRIÇÃO"	,,30,.F.,)
	TRCell():New(oSection,"05",,"TIPO"		,,07,.F.,)
	TRCell():New(oSection,"07",,"CLASSIFICAÇÃO"		,,07,.F.,)
	TRCell():New(oSection,"06",,"QTD"		,"@E 999",3)
	TRCell():New(oSection,"08",,"PREVISÃO"		,,10,.F.,)
	TRCell():New(oSection,"09",,"ESTOQUE SP"	,,01,.F.,)
	TRCell():New(oSection,"10",,"ESTOQUE AM"	,,01,.F.,)
	 
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
	
	oReport:SetTitle("Lista Avançada")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			aDados1[01]	:=  (cAliasLif)->CJ_XUNICOM
			aDados1[02]	:=  (cAliasLif)->CK_ITEM
			aDados1[03]	:=  (cAliasLif)->CK_PRODUTO
			aDados1[04]	:=  (cAliasLif)->B1_DESC
			aDados1[05]	:=  Iif((cAliasLif)->CK_XTP_PRD = 'S', 'STECK','MERCADO')
			aDados1[06]	:=  (cAliasLif)->CK_QTDVEN
			If (cAliasLif)->CLAPRODSP = 'C'  .AND. 		(cAliasLif)->CLAPRODAM = 'F'
				aDados1[07]	:= 'Fabricado AM'
			ElseIf (cAliasLif)->CLAPRODSP = 'I'
				aDados1[07]	:= 'Importado'
				
			ElseIf (cAliasLif)->CLAPRODSP = 'F'
				aDados1[07]	:= 'Fabricado SP'
			Else
				aDados1[07]	:= 'Comprado'
			EndIf
			
			_nSaldo			:= 0
			_dDtEntrega		:= CTOD('  /  /    ')
			_nSaldo			:= u_versaldo(AllTrim((cAliasLif)->CK_PRODUTO))
			_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim((cAliasLif)->CK_PRODUTO),(cAliasLif)->CK_QTDVEN)
			aDados1[08]		:=  DTOC(_dDtEntrega)
			aDados1[09]		:=  AllTrim((cAliasLif)->SALDOSP)
			aDados1[10]		:=  AllTrim((cAliasLif)->SALDOAM)
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
	
	cQuery := " SELECT CJ_XUNICOM, CK_ITEM  ,   CK_PRODUTO,  SB1.B1_DESC    ,  CK_XTP_PRD,   CK_QTDVEN, SB1.B1_CLAPROD CLAPRODSP ,TB1.B1_CLAPROD CLAPRODAM, 
	cQuery += " CASE WHEN SB2.B2_QATU > 0 THEN 'S' ELSE 'N' END  SALDOSP,
	cQuery += " CASE WHEN TB2.B2_QATU > 0 THEN 'S' ELSE 'N' END  SALDOAM
	cQuery += " FROM PP7010 PP7 INNER JOIN (SELECT * FROM PP8010)PP8	
	cQuery += " ON PP8.D_E_L_E_T_ = ' ' AND PP7_CODIGO = PP8_CODIGO AND PP7_FILIAL = PP8_FILIAL INNER JOIN(SELECT * FROM SCJ010)SCJ ON SCJ.D_E_L_E_T_ = ' ' AND SCJ.CJ_FILIAL = PP7_FILIAL AND SCJ.CJ_XUNICOM = PP8_CODIGO|| PP8_ITEM
	cQuery += " INNER JOIN(SELECT * FROM SCK010)SCK
	cQuery += " ON SCK.D_E_L_E_T_ = ' ' AND CK_NUM = CJ_NUM AND CK_PRODUTO BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"' AND CK_FILIAL = CJ_FILIAL inner join(SELECT * FROM SB1010)SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = CK_PRODUTO
	cQuery += " inner join(SELECT * FROM SB1030)TB1 ON TB1.D_E_L_E_T_ = ' ' AND TB1.B1_COD = CK_PRODUTO 
	cQuery += " LEFT JOIN (SELECT * FROM SB2010) SB2 
	cQuery += " 	ON SB2.B2_COD = CK_PRODUTO
	cQuery += "			AND SB2.B2_LOCAL = '01'
	cQuery += "			AND SB2.B2_FILIAL = '04'
	cQuery += "			AND SB2.D_E_L_E_T_ = ' '
	cQuery += " LEFT JOIN (SELECT * FROM SB2030) TB2
	cQuery += "		ON TB2.B2_COD = CK_PRODUTO
	cQuery += "			AND TB2.B2_LOCAL = '01'
	cQuery += "			AND TB2.B2_FILIAL = '01'
	cQuery += "			AND TB2.D_E_L_E_T_ = ' '
	cQuery += " WHERE PP7.D_E_L_E_T_ = ' '
	cQuery += " AND PP7_CODIGO BETWEEN '"+  MV_PAR03 +"' AND '"+  MV_PAR04 +"'
	cQuery += " AND PP7_FILIAL = '02' ORDER BY CJ_XUNICOM , CK_ITEM
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()


