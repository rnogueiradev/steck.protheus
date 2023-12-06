#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAS     ºAutor  ³Giovani Zago    º Data ³  26/07/16     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Metas	P/ Vendedor  	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAS()
	
	Local   oReport
	Private cPerg 			:= "RFATAS"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private _aErro			:= {}
	
	
	PutSX1(cPerg,"01","Produto De?     "   	,"Produto De?  "	,"Produto De?  "		,"mv_ch1","C",15,0,1,"G","SB1",""		,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"02","Produto Ate?     "   ,"Produto Ate? "	,"Produto Ate?"		,"mv_ch2","C",15,0,1,"G","SB1",""		,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"03","Data De?     "   	,"Data De?  "	,"Data De?  "		,"mv_ch3","D",8,0,1,"G","",""		,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"04","Data Até?     "   	,"Data Até?  "	,"Data Até?  "		,"mv_ch4","D",8,0,1,"G","",""		,"","","mv_par04","","","","","","","","","","","","","","","","")
	
	
	
	
	
	
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
	
	oReport := TReport():New(cPergTit,"ANÁLISE DE REDUÇÕES DE IMPOSTOS II  ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório ANÁLISE DE REDUÇÕES DE IMPOSTOS II ")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"ANÁLISE DE REDUÇÕES DE IMPOSTOS II ",{"SD1"})
	
	
	
	
	TRCell():New(oSection,"01",,"CODIGO"	,,02,.F.,)
	TRCell():New(oSection,"02",,"DESCRIÇÃO"			,,40,.F.,)
	TRCell():New(oSection,"03",,"DCRE" 			,,30,.F.,)
	 TRCell():New(oSection,"04",,"COD PAI" 			,,30,.F.,)
	 TRCell():New(oSection,"05",,"ALTERNATIVO" 			,,30,.F.,)
	
	
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SD1")
	
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
	Local i		:= 0
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	
	
	oReport:SetTitle("ANÁLISE DE REDUÇÕES DE IMPOSTOS II ")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	
	//Z9_OBS
	oSection1:PrintLine()
	aFill(aDados1,nil)
	For i:=1 To Len(_aErro)
		aDados1[01]	:=  _aErro[i,1]
		aDados1[02]	:=  _aErro[i,2]
		aDados1[03]	:=  _aErro[i,3]
		aDados1[04]	:=  _aErro[i,4]
		aDados1[05]	:=  _aErro[i,5]
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
	Next i
	
	
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
	Local cQuery1     := ' '
	Local _aCod 	  := {}
	Local _nt         := 0
	Local _nCon         := 0
/*
	cQuery1 := "    SELECT DISTINCT SB1.B1_COD AS COD, NVL(SG1.G1_COMP,' ') AS COMP1, NVL(TG1.G1_COD,' ') AS COMP2,  NVL(TG2.G1_COD,' ') AS COMP3, NVL(TG3.G1_COD,' ') AS COMP4, NVL(TG4.G1_COD,' ') AS COMP5, NVL(TG5.G1_COD,' ') AS COMP6, NVL(TG6.G1_COD,' ') AS COMP7,
	cQuery1 += " 	SB1.B1_DESC AS DESCRR,        SB1.B1_DCRE AS DCRE,  	        SB1.B1_COEFDCR AS COEF,           SB1.B1_DCRII  AS DCRII
	cQuery1 += " 	FROM "+RetSqlName("SB1")+" SB1
	cQuery1 += " 	INNER JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG1  ON TG1.D_E_L_E_T_ = ' ' AND SG1.G1_COMP = TG1.G1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG2  ON TG1.D_E_L_E_T_ = ' ' AND TG1.G1_COMP = TG2.G1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG3  ON TG1.D_E_L_E_T_ = ' ' AND TG2.G1_COMP = TG3.G1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG4  ON TG1.D_E_L_E_T_ = ' ' AND TG3.G1_COMP = TG4.G1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG5  ON TG1.D_E_L_E_T_ = ' ' AND TG4.G1_COMP = TG5.G1_COD
	cQuery1 += " 	LEFT JOIN  (SELECT * FROM  "+RetSqlName("SG1")+") TG6  ON TG1.D_E_L_E_T_ = ' ' AND TG5.G1_COMP = TG6.G1_COD
	cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND     SB1.D_E_L_E_T_ = ' '       ORDER BY SB1.B1_COD
*/

cQuery1 := " 	SELECT DISTINCT  SB1.B1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE ,SB1.B1_COD,SB1.B1_ALTER   FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = SB1.B1_COD 
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' '   

cQuery1 += " 	UNION
cQuery1 += " 	SELECT DISTINCT  SG1.G1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE ,SB1.B1_COD ,SB1.B1_ALTER FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = SG1.G1_COD 
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' '   
cQuery1 += " 	 UNION
cQuery1 += " 	SELECT DISTINCT  TG1.G1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE ,SB1.B1_COD,SB1.B1_ALTER FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG1  ON TG1.D_E_L_E_T_ = ' ' AND SG1.G1_COMP = TG1.G1_COD
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = TG1.G1_COD  
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' '  

cQuery1 += " 	 UNION
cQuery1 += " 	SELECT DISTINCT  TG2.G1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE ,SB1.B1_COD,SB1.B1_ALTER FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG1  ON TG1.D_E_L_E_T_ = ' ' AND SG1.G1_COMP = TG1.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG2  ON TG1.D_E_L_E_T_ = ' ' AND TG1.G1_COMP = TG2.G1_COD
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = TG2.G1_COD  
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' ' 
cQuery1 += " 	  UNION
cQuery1 += " 	SELECT DISTINCT  TG3.G1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE,SB1.B1_COD ,SB1.B1_ALTER FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG1  ON TG1.D_E_L_E_T_ = ' ' AND SG1.G1_COMP = TG1.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG2  ON TG1.D_E_L_E_T_ = ' ' AND TG1.G1_COMP = TG2.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG3  ON TG1.D_E_L_E_T_ = ' ' AND TG2.G1_COMP = TG3.G1_COD
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = TG3.G1_COD  
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' ' 
cQuery1 += " 	  UNION
cQuery1 += " 	SELECT DISTINCT  TG4.G1_COD AS COD, SB1.B1_DESC AS DESCRR, SB1.B1_DCRE AS DCRE ,SB1.B1_COD ,SB1.B1_ALTER FROM SB1030 SB1  
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) SG1  ON SG1.D_E_L_E_T_ = ' ' AND SG1.G1_COD = B1_COD 
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG1  ON TG1.D_E_L_E_T_ = ' ' AND SG1.G1_COMP = TG1.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG2  ON TG1.D_E_L_E_T_ = ' ' AND TG1.G1_COMP = TG2.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG3  ON TG1.D_E_L_E_T_ = ' ' AND TG2.G1_COMP = TG3.G1_COD
cQuery1 += " 	INNER JOIN  (SELECT * FROM  SG1030) TG4  ON TG1.D_E_L_E_T_ = ' ' AND TG3.G1_COMP = TG4.G1_COD
cQuery1 += " 	INNER JOIN(SELECT *  FROM SD1030)  SD1 ON SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' ' AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND SD1.D1_TIPO NOT IN ('D','C')
cQuery1 += " 	AND   SD1.D1_COD = TG4.G1_COD  
cQuery1 += " 	WHERE SB1.B1_FILIAL = ' ' AND    SB1.D_E_L_E_T_ = ' ' 


	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)
	
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			(cAliasLif)->(dbskip())
			_nCon++
		End
	EndIf
	//_nCon:= (cAliasLif)->(RecCount())
	ProcRegua(_nCon) // Numero de registros a processar
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			_nt++
			IncProc("Processando: "+cvaltochar(_nt)+"/"+cvaltochar(_nCon))
			
			//If  Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COD }) == 0
			 
						Aadd(_aCod,{(cAliasLif)->COD , (cAliasLif)->DESCRR ,(cAliasLif)->DCRE,(cAliasLif)->B1_COD,(cAliasLif)->B1_ALTER })
				 
		//	EndIf
			
			/*
			If  Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COD }) == 0
				If xxStQuery((cAliasLif)->COD)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COD)
						Aadd(_aCod,{(cAliasLif)->COD , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP1 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP1 }) == 0
				
				If xxStQuery((cAliasLif)->COMP1)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP1)
						Aadd(_aCod,{(cAliasLif)->COMP1 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP2 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP2 }) == 0
				
				If xxStQuery((cAliasLif)->COMP2)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP2)
						Aadd(_aCod,{(cAliasLif)->COMP2 ,SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP3 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP3 }) == 0
				
				If xxStQuery((cAliasLif)->COMP3)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP3)
						Aadd(_aCod,{(cAliasLif)->COMP3 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP4 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP4 }) == 0
				
				If xxStQuery((cAliasLif)->COMP4)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP4)
						Aadd(_aCod,{(cAliasLif)->COMP4 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP5 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP5 }) == 0
				
				If xxStQuery((cAliasLif)->COMP5)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP5)
						Aadd(_aCod,{(cAliasLif)->COMP5 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP6 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP6 }) == 0
				
				If xxStQuery((cAliasLif)->COMP6)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP6)
						Aadd(_aCod,{(cAliasLif)->COMP6 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			If !(Empty(Alltrim((cAliasLif)->COMP7 ))) .And. Ascan(_aCod, { |x| x[ 1 ] == (cAliasLif)->COMP7 }) == 0
				
				If xxStQuery((cAliasLif)->COMP7)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+(cAliasLif)->COMP7)
						Aadd(_aCod,{(cAliasLif)->COMP7 , SB1->B1_DESC  ,(cAliasLif)->DCRE })
					EndIf
				EndIf
				
			EndIf
			
			*/
			
			
			(cAliasLif)->(dbskip())
			
		End
		
	EndIf
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	_aErro:= _aCod
Return()


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
Static Function xxStQuery(_cCod)
	*-----------------------------*
	Local cQuery1     := ' '
	Local _lXRe		  := .f.
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private xcAliasLif   	:= 'xxStQuery'+cHora+ cMinutos+cSegundos
	
	
	cQuery1 := " 	SELECT *  FROM "+RetSqlName("SD1")+"  SD1
	cQuery1 += " 	WHERE SD1.D1_FILIAL = '01'    AND   SD1.D_E_L_E_T_ = ' '
	cQuery1 += " 	AND  ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') )
	cQuery1 += " 	AND   SD1.D1_COD = '"+_cCod+"'
	cQuery1 += " 	AND SD1.D1_TIPO NOT IN ('D','C')
	
	
	
	If Select(xcAliasLif) > 0
		(xcAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),xcAliasLif)
	
	
	dbSelectArea(xcAliasLif)
	(xcAliasLif)->(dbgotop())
	If  Select(xcAliasLif) > 0
		
		While 	(xcAliasLif)->(!Eof())
			
			_lXRe:= .t.
			(xcAliasLif)->(dbskip())
			
		End
		
	EndIf
	
	If Select(xcAliasLif) > 0
		(xcAliasLif)->(dbCloseArea())
	EndIf
	
Return(_lXRe)
