#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAI    ºAutor  ³Giovani Zago    º Data ³  08/04/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio CUSTO GERENCIAL JESSICA    	                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATAI()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAI"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cAliasP		   	:= 'P'+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	PutSx1(cPerg, "01", "Da Emissao:"	,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Até a Emissao:","Até a Emissao:"	,"Até a Emissao:" 		,"mv_ch2","D"   ,08     	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Do Produto:" 	,"Da Data: ?" 		,"Da Data: ?" 			,"mv_ch3","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Produto:" 	,"Ate Data: ?" 		,"Ate Data: ?" 			,"mv_ch4","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par04","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	 oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio CUSTO GERENCIAL   			                  º±±
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
	
	oReport := TReport():New(cPergTit,"RELATÓRIO DE CUSTO GERENCIAL",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório DE CUSTO GERENCIAL")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"CUSTO GERENCIAL",{"ZZJ"})
	
	
	TRCell():New(oSection,"01",,"EMPRESA"		,,10,.F.,)
	TRCell():New(oSection,"02",,"FILIAL"		,,10,.F.,)
	TRCell():New(oSection,"03",,"PRODUTO" 		,,30,.F.,)
	TRCell():New(oSection,"04",,"MES" 			,,10,.F.,)
	TRCell():New(oSection,"05",,"CUSTO" 		,"@E 99,999,999.99",14)
	
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("ZZJ")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio CUSTO GERENCIAL				                  º±±
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
	
	oReport:SetTitle("CUSTO GERENCIAL")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			aDados1[01]	:=  (cAliasLif)->EMPRESA
			aDados1[02]	:=  (cAliasLif)->FILIAL
			aDados1[03]	:=  (cAliasLif)->PRODUTO
			aDados1[04]	:=  (cAliasLif)->MES
			aDados1[05]	:=  (cAliasLif)->CUSTO
			
			
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			
			(cAliasLif)->(dbskip())
		End
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	
	
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio CUSTO GERENCIAL				                  º±±
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
	
	
	
	
	
	
	cQuery :=  " 	SELECT
	cQuery += " DISTINCT
	cQuery += " 'SP'
	cQuery += ' "EMPRESA",
	cQuery += " SD2.D2_FILIAL
	cQuery += ' "FILIAL",
	cQuery += " SD2.D2_COD
	cQuery += ' "PRODUTO",
	cQuery += " SUBSTR(SD2.D2_EMISSAO, 1,6)
	cQuery += ' "MES",
	cQuery += " NVL((SELECT B9_CM1 FROM SB9010 SB9
	cQuery += " WHERE SB9.D_E_L_E_T_ = ' '
	cQuery += " AND B9_COD = SD2.D2_COD
	cQuery += " AND B9_LOCAL = SD2.D2_LOCAL
	cQuery += " AND B9_FILIAL = SD2.D2_FILIAL
	cQuery += ' AND  SUBSTR(B9_DATA, 1,6)  =  SUBSTR(SD2.D2_EMISSAO, 1,6)),0) "CUSTO"
	
	
	
	cQuery += " FROM SD2010 SD2
	
	
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND SD2.D2_CF  IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND EXISTS (SELECT B9_CM1 FROM SB9010 SB9
	cQuery += " WHERE SB9.D_E_L_E_T_ = ' '
	cQuery += " AND B9_COD = SD2.D2_COD
	cQuery += " AND B9_LOCAL = SD2.D2_LOCAL
	cQuery += " AND B9_FILIAL = SD2.D2_FILIAL
	cQuery += " AND  SUBSTR(B9_DATA, 1,6)  =  SUBSTR(SD2.D2_EMISSAO, 1,6))
	
	cQuery += " UNION
	
	cQuery += " SELECT
	cQuery += " DISTINCT
	cQuery += " 'AM'
	cQuery += ' "EMPRESA",
	cQuery += " TD2.D2_FILIAL
	cQuery += ' "FILIAL",
	cQuery += " TD2.D2_COD
	cQuery += ' "PRODUTO",
	cQuery += " SUBSTR(TD2.D2_EMISSAO, 1,6)
	cQuery += ' "MES",
	cQuery += " NVL((SELECT B9_CM1 FROM SB9030 SB9
	cQuery += " WHERE SB9.D_E_L_E_T_ = ' '
	cQuery += " AND B9_COD = TD2.D2_COD
	cQuery += " AND B9_LOCAL = TD2.D2_LOCAL
	cQuery += " AND B9_FILIAL = TD2.D2_FILIAL
	cQuery += ' AND  SUBSTR(B9_DATA, 1,6)  =  SUBSTR(TD2.D2_EMISSAO, 1,6)),0) "CUSTO"
	
	
	
	cQuery += " FROM SD2030 TD2
	
	
	cQuery += " WHERE TD2.D_E_L_E_T_ = ' '
	cQuery += " AND TD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND TD2.D2_CF  IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND TD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND EXISTS (SELECT B9_CM1 FROM SB9030 SB9
	cQuery += " WHERE SB9.D_E_L_E_T_ = ' '
	cQuery += " AND B9_COD = TD2.D2_COD
	cQuery += " AND B9_LOCAL = TD2.D2_LOCAL
	cQuery += " AND B9_FILIAL = TD2.D2_FILIAL
	cQuery += " AND  SUBSTR(B9_DATA, 1,6)  =  SUBSTR(TD2.D2_EMISSAO, 1,6))
	
	cQuery += " ORDER BY PRODUTO,MES
	
	
	
	
	
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()
