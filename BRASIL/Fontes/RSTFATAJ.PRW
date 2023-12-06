#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATAJ    บAutor  ณGiovani Zago    บ Data ณ  19/05/16      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio UNHEALTH STOCK               				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATAJ()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAJ"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cAliasP		   	:= 'P'+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private nDias			:= 0
	
	PutSx1(cPerg, "01", "Faturado de:"	,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Faturado At้:" ,"At้ a Emissao:"	,"At้ a Emissao:" 		,"mv_ch2","D"   ,08     	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Do Produto:" 	,"Da Data: ?" 		,"Da Data: ?" 			,"mv_ch3","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Produto:" 	,"Ate Data: ?" 		,"Ate Data: ?" 			,"mv_ch4","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Dias"     		,""					,""						,"mv_ch5","N"	,2			,0			,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par05",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	
	
	oReport		:= ReportDef()
	 oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  19/05/16     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio UNHEALTH STOCK    			                  บฑฑ
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
	
	oReport := TReport():New(cPergTit,"RELATำRIO UNHEALTH STOCK ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio UNHEALTH STOCK ")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"UNHEALTH STOCK ",{"ZZJ"})
	
	
	TRCell():New(oSection,"01",,"PRODUTO"		,,15,.F.,)
	TRCell():New(oSection,"02",,"GRUPO"		,,05,.F.,)
	TRCell():New(oSection,"03",,"DESC" 		,,30,.F.,)
	TRCell():New(oSection,"04",,"FATURADO" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"05",,"RESERVA" 		,"@E 99,999,999.99",14)
	
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("ZZJ")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio UNHEALTH STOCK				                  บฑฑ
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
	Local aDados[2]
	Local aDados1[99]
	
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	
	oReport:SetTitle("UNHEALTH STOCK")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			aDados1[01]	:=  (cAliasLif)->PRODUTO
			aDados1[02]	:=  (cAliasLif)->GRUPO
			aDados1[03]	:=  (cAliasLif)->DESC
			aDados1[04]	:=  (cAliasLif)->FATURADO
			aDados1[05]	:=  (cAliasLif)->RESERVA
			
			
			
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio CUSTO GERENCIAL				                  บฑฑ
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
	
	
	
	nDias:= MV_PAR05
	
	
	cQuery :=  " SELECT
	cQuery += " B1_COD
	cQuery += ' "PRODUTO",
	cQuery += " B1_GRUPO
	cQuery += ' "GRUPO",
	cQuery += " BM_DESC
	cQuery += ' "DESC",
	
	cQuery += " NVL((
	cQuery += " SELECT SUM(D2_QUANT)  FROM SD2010 SD2 INNER JOIN(SELECT * FROM SA1010 )
	cQuery += " SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  '
	cQuery += " INNER JOIN(SELECT * FROM SF2010)SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL
	cQuery += " and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114',
	cQuery += " '6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND D2_COD = B1_COD
	cQuery += " AND SD2.D2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01)+"' AND '"+ DTOS(MV_PAR02)+"'    ),0)
	cQuery += ' "FATURADO"      ,
	
	
	
	cQuery += " NVL((SELECT SUM( CASE WHEN  C6_ZENTRE2 <> ' ' AND C6_ZENTRE2 < '"+ DTOS(SomDiaUt(ddatabase,nDias))+"' AND SBM.BM_GRUPO NOT IN ('039','041','042') THEN PA2_QUANT
	cQuery += " ELSE
	cQuery += " CASE
	cQuery += " WHEN C6_ENTRE1  < '"+ DTOS(SomDiaUt(ddatabase,nDias))+"' AND SBM.BM_GRUPO NOT IN ('039','041','042')
	cQuery += " THEN PA2_QUANT
	
	cQuery += " 	ELSE 
	cQuery += " CASE 
	cQuery += " WHEN SBM.BM_GRUPO IN ('039','041','042')
	cQuery += " THEN PA2_QUANT 
 
	
	cQuery += " ELSE 0
	cQuery += ' END END END) "RESERVA"
	cQuery += "  FROM PA2010 PA2 INNER JOIN(SELECT * FROM SC6010)SC6 ON SC6.D_E_L_E_T_ = ' '
	cQuery += "  AND C6_PRODUTO = PA2_CODPRO AND PA2_DOC = C6_NUM||C6_ITEM AND C6_BLQ <> 'R' AND C6_QTDVEN > C6_QTDENT
	cQuery += " WHERE PA2.D_E_L_E_T_ = ' ' and PA2_FILRES = '02'   AND PA2_CODPRO = B1_COD AND PA2_QUANT <> 0),0)
	
	cQuery += ' "RESERVA"
	cQuery += "  FROM SB1010 SB1
	
	cQuery += " INNER JOIN( SELECT * FROM SBM010) SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND BM_GRUPO = B1_GRUPO
	
	
	
	cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SB1.B1_TIPO = 'PA'
	cQuery += " AND SB1.B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	
	
	
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()


Static function SomDiaUt(dData,nDias)
Local nCont:= 0 
	For nCont:=1 to nDias
		dData += 1
		If dow(dData)== 1 //domingo
			dData += 1
		ElseIf dow(dData)== 7 //sabado
			dData += 2
		EndIf
	Next
	
Return dData
