#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATC5     บAutor  ณGIOVANI.ZAGO    บ Data ณ  16/05/18     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Empenho x OS				              	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATC5()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATC5"
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader  := .F.
	Private lXmlEndRow  := .F.
	Private cPergTit 	:= cAliasLif
	
	
	xPutSx1(cPerg, "01", "Produto :"		,"Produto de:" 	 	,"Produto de:" 			,"mv_ch1","C"		,15			,0		,0		,"G",""	,'SB1' 	,"","","mv_par01","","","","","","","","","","","","","","","","")
//	xPutSx1(cPerg, "02", "Produto Ate:"	,"Produto Ate:"  	,"Produto Ate:"			,"mv_ch2","C"		,15			,0		,0		,"G",""	,'SB1' 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg, "03", "Faturamento de:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch3","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par03","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg, "04", "Faturamento ate:"	,"At้ a Emissao:"		,"At้ a Emissao:" 		,"mv_ch4","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par04","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg, "05", "Grupo de:"		,"Produto de:" 	 	,"Produto de:" 			,"mv_ch5","C"		,15			,0		,0		,"G",""	,'SBM' 	,"","","mv_par05","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg, "06", "Grupo Ate:"	,"Produto Ate:"  	,"Produto Ate:"			,"mv_ch6","C"		,15			,0		,0		,"G",""	,'SBM' 	,"","","mv_par06","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg   ,"07"  ,"Origem"      ,"Origem"      ,"Origem"      ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,""    ,""     ,"S"  ,"mv_par07"    ,"Comprado"        ,""      ,""      ,""                   ,"Importado"        ,""        ,""      ,"Fabricado"    ,""      ,""      ,"Todos"               ,""      ,""      ,""    ,""      ,""      ,  ,  ,)
	
	
 
	oReport		:= ReportDef()
	
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
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
	
	oReport := TReport():New(cPergTit,"RELATำRIO de Empenho x OS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio para anแlise dos Empenho x OS")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Relat๓rio de Empenho x OS",{"SDC"})
	
	
	TRCell():New(oSection,"01",,"PRODUTO"		,,15,.F.,)
	TRCell():New(oSection,"02",,"LOCAL."		,,02,.F.,)
	TRCell():New(oSection,"03",,"LOCALIZAวรO" 	,,15,.F.,)
	TRCell():New(oSection,"04",,"QUANTIDADE"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"05",,"PEDIDO"		,,06,.F.,)
	TRCell():New(oSection,"06",,"SEPARAวรO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"07",,"EMBALAGEM"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"STATUS"		,,06,.F.,)
	
	
	       
	
		
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SUA")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
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
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	
	
	
	
	oReport:SetTitle("SUA")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			
			aDados1[01]	:=  (cAliasLif)->DC_PRODUTO
			aDados1[02]	:=  (cAliasLif)->DC_LOCAL
			aDados1[03]	:=  (cAliasLif)->DC_LOCALIZ
			aDados1[04]	:=  (cAliasLif)->DC_QUANT
			aDados1[05]	:=  (cAliasLif)->DC_PEDIDO
			aDados1[06]	:=	(cAliasLif)->CB8_SALDOS
			aDados1[07]	:= 	(cAliasLif)->CB8_SALDOE
			aDados1[08]	:= 	(cAliasLif)->STATUS
			
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
		
		
		
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
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
	cQuery += "  DC_FILIAL,
	cQuery += "  DC_PRODUTO,
	cQuery += "  DC_LOCAL,
	cQuery += "  DC_LOCALIZ,
	cQuery += "  DC_QUANT,
	cQuery += "  DC_PEDIDO,CB8_SALDOS,CB8_SALDOE,
	cQuery += "  CASE WHEN CB8_SALDOS<>'0' THEN 'Inicio'
	cQuery += "  ELSE
	cQuery += "  CASE WHEN CB8_SALDOS='0' THEN 'Sep.Final'
	cQuery += "  ELSE
	cQuery += "  ' '
	cQuery += "  END
	cQuery += "  END AS STATUS

	cQuery += "  FROM SDC010 SDC
	cQuery += "  INNER JOIN(SELECT * FROM CB8010)CB8
	cQuery += "  ON CB8.D_E_L_E_T_ = ' '
	cQuery += "  AND CB8_FILIAL = DC_FILIAL
	cQuery += "  AND CB8_PEDIDO = DC_PEDIDO
	cQuery += "  AND CB8_PROD = DC_PRODUTO
	cQuery += "  AND CB8_LCALIZ = DC_LOCALIZ
	cQuery += "  AND CB8_QTDORI = DC_QUANT

	cQuery += "  WHERE SDC.D_E_L_E_T_ = ' '
	cQuery += "  AND DC_FILIAL = '02'
	cQuery += "  AND DC_PRODUTO = '"+mv_par01+"'
	cQuery += "  AND DC_QUANT <> 0

	cQuery += "  UNION


	cQuery += "  SELECT
	cQuery += "  'ZX',
	cQuery += "  ' ',
	cQuery += "  ' ',
	cQuery += "  DC_LOCALIZ,
	cQuery += "  NVL((SELECT BF_QUANT FROM SBF010 SBF WHERE SBF.D_E_L_E_T_ = ' ' AND BF_PRODUTO = DC_PRODUTO AND BF_LOCAL = DC_LOCAL AND BF_LOCALIZ = DC_LOCALIZ),0)  ,
	cQuery += "  ' ',0,0,
	cQuery += "  ' '

	cQuery += "  FROM SDC010 SDC
	cQuery += "  INNER JOIN(SELECT * FROM CB8010)CB8
	cQuery += "  ON CB8.D_E_L_E_T_ = ' '
	cQuery += "  AND CB8_FILIAL = DC_FILIAL
	cQuery += "  AND CB8_PEDIDO = DC_PEDIDO
	cQuery += "  AND CB8_PROD = DC_PRODUTO
	cQuery += "  AND CB8_LCALIZ = DC_LOCALIZ
	cQuery += "  AND CB8_QTDORI = DC_QUANT


	cQuery += "  WHERE SDC.D_E_L_E_T_ = ' '
	cQuery += "  AND DC_FILIAL = '02'
	cQuery += "  AND DC_PRODUTO = '"+mv_par01+"'
	cQuery += "  AND DC_QUANT <> 0


	cQuery += "  UNION


	cQuery += "  SELECT
	cQuery += "  'ZY',
	cQuery += "  ' ',
	cQuery += "  ' ',
	cQuery += "  DC_LOCALIZ,
	cQuery += "  0  ,
	cQuery += "  ' ',SUM(CB8_SALDOS),0,
	cQuery += "  ' '

	cQuery += "  FROM SDC010 SDC
	cQuery += "  INNER JOIN(SELECT * FROM CB8010)CB8
	cQuery += "  ON CB8.D_E_L_E_T_ = ' '
	cQuery += "  AND CB8_FILIAL = DC_FILIAL
	cQuery += "  AND CB8_PEDIDO = DC_PEDIDO
	cQuery += "  AND CB8_PROD = DC_PRODUTO
	cQuery += "  AND CB8_LCALIZ = DC_LOCALIZ
	cQuery += "  AND CB8_QTDORI = DC_QUANT


	cQuery += "  WHERE SDC.D_E_L_E_T_ = ' '
	cQuery += "  AND DC_FILIAL = '02'
	cQuery += "  AND DC_PRODUTO = '"+mv_par01+"'
	cQuery += "  AND DC_QUANT <> 0
	cQuery += "  GROUP BY DC_LOCALIZ


	cQuery += "  UNION


	cQuery += "  SELECT
	cQuery += "  'ZZ',
	cQuery += "  ' ',
	cQuery += "  ' ',
	cQuery += "  DC_LOCALIZ,
	cQuery += "  0  ,
	cQuery += "  ' ',0,SUM(CB8_SALDOE),
	cQuery += "  ' '

	cQuery += "  FROM SDC010 SDC
	cQuery += "  INNER JOIN(SELECT * FROM CB8010)CB8
	cQuery += "  ON CB8.D_E_L_E_T_ = ' '
	cQuery += "  AND CB8_FILIAL = DC_FILIAL
	cQuery += "  AND CB8_PEDIDO = DC_PEDIDO
	cQuery += "  AND CB8_PROD = DC_PRODUTO
	cQuery += "  AND CB8_LCALIZ = DC_LOCALIZ
	cQuery += "  AND CB8_QTDORI = DC_QUANT


	cQuery += "  WHERE SDC.D_E_L_E_T_ = ' '
	cQuery += "  AND DC_FILIAL = '02'
	cQuery += "  AND DC_PRODUTO = '"+mv_par01+"'
	cQuery += "  AND DC_QUANT <> 0
	cQuery += "  GROUP BY DC_LOCALIZ


	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
		cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
		cF3, cGrpSxg,cPyme,;
		cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
		cDef02,cDefSpa2,cDefEng2,;
		cDef03,cDefSpa3,cDefEng3,;
		cDef04,cDefSpa4,cDefEng4,;
		cDef05,cDefSpa5,cDefEng5,;
		aHelpPor,aHelpEng,aHelpSpa,cHelp)
	
	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	
	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )
	
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	
	If !( DbSeek( cGrupo + cOrdem ))
		
		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		/* Removido - 12/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock( "SX1" , .T. )
		
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		
		Replace X1_VAR01   With cVar01
		
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg
		
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
		
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		
		Replace X1_HELP With cHelp
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		
		MsUnlock()
	Else
		
		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
		
		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf*/
	Endif
	
	RestArea( aArea )
	
Return
