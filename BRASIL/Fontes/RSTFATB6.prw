#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RSTFATB6 ºAutor  ³Richard N Cabral  º Data ³  15/09/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Transportes                                    ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATB6()
*-----------------------------*

	Local   oReport
	Private cPerg		:= "RFATB05"
	Private cTime		:= Time()
	Private cHora		:= SUBSTR(cTime, 1, 2)
	Private cMinutos	:= SUBSTR(cTime, 4, 2)
	Private cSegundos	:= SUBSTR(cTime, 7, 2)
	Private cAlias		:= "FATB6"
	Private lXlsHeader	:= .f.
	Private lXmlEndRow	:= .f.
	Private cPergTit	:= cPerg+cHora+cMinutos+cSegundos
	Private aColunas	:= {}

	AjustaSX1()

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDefºAutor  ³Richard N Cabral  º Data ³  15/09/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Transportes                                    ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection
	Local nX

	oReport := TReport():New(cPergTit,"Relatório de Transportes",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o Relatório de Transportes")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatório de Transportes",{"SB1"})

	aColunas := {}
	aAdd(aColunas, {"GW3_FILIAL",""}) 
	aAdd(aColunas, {"D2_CLIENTE",""}) 
	aAdd(aColunas, {"D2_SERIE",""}) 
	aAdd(aColunas, {"A1_NOME",""}) 
	aAdd(aColunas, {"GW4_NRDC",""}) 
	aAdd(aColunas, {"F2_EMISSAO",""})
	aAdd(aColunas, {"F2_VALBRUT",""})
	aAdd(aColunas, {"F2_VALMERC",""})
	aAdd(aColunas, {"F2_VOLUME1",""})
	aAdd(aColunas, {"F2_PLIQUI",""})
	aAdd(aColunas, {"F2_PBRUTO",""})
	aAdd(aColunas, {"F2_XCODROM",""})
	aAdd(aColunas, {"PD1_PLACA",""})
	aAdd(aColunas, {"PD1_MOTORI",""})
	aAdd(aColunas, {"A4_COD",""})
	aAdd(aColunas, {"A4_NOME",""})
	aAdd(aColunas, {"GW3_NRDF",""})
	aAdd(aColunas, {"GW3_EMISDF",""})
	aAdd(aColunas, {"GW3_VLDF",""})
	aAdd(aColunas, {"GW3_TAXAS",""})
	aAdd(aColunas, {"GW3_FRPESO",""})
	aAdd(aColunas, {"GW3_FRVAL",""})
	aAdd(aColunas, {"GW3_PEDAG",""})
	aAdd(aColunas, {"GW3_QTVOL",""})
	aAdd(aColunas, {"GW3_PESOR",""})
	aAdd(aColunas, {"GW3_VOLUM",""})
	aAdd(aColunas, {"GW3_VLCARG",""})
	aAdd(aColunas, {"GW3_BASIMP",""})
	aAdd(aColunas, {"GW3_PCIMP",""})
	aAdd(aColunas, {"GW3_VLIMP",""})
	aAdd(aColunas, {"GW3_BASCOF",""})
	aAdd(aColunas, {"GW3_VLCOF",""})
	aAdd(aColunas, {"GW3_BASPIS",""})
	aAdd(aColunas, {"GW3_VLPIS",""})
	aAdd(aColunas, {"GW3_TPCTE",""})
	aAdd(aColunas, {"GWF_BASICM",""})
	aAdd(aColunas, {"GW3_NRFAT",""})
	aAdd(aColunas, {"GW6_DTVENC",""})
	aAdd(aColunas, {"GW6_VLFATU",""})
	aAdd(aColunas, {"GW3_DTAPR",""})
	aAdd(aColunas, {"GW3_USUAPR",""})
	aAdd(aColunas, {"GWF_CIDDES",""})

	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aColunas)
		SX3->(DbSeek(aColunas[nX,1]))
		aColunas[nX,2] := SX3->X3_TIPO
		TRCell():New(oSection,Strzero(nX,2),,SX3->X3_TITULO,,SX3->X3_TAMANHO,.F.,)
	Next nX

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SB1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrintºAutor  ³Richard N Cabral  º Data ³  15/09/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Transportes                                    ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados	:= {}
	Local nX
	Local cCampo

	For nX := 1 to Len(aColunas)
		cCampo := aColunas[nX,1]
		oSection1:Cell(Strzero(nX,2)):SetBlock( &("{ || aDados["+cValToChar(nX)+"] }") )		//oSection1:Cell(Strzero(nX,2)) :SetBlock( { || aDados[nX] } )
	Next nX		

	oReport:SetTitle("Relatório de Transportes")

	oReport:SetMeter(0)

	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatório")

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	aAtualiza	:= {}
	
	If Select(cAlias) > 0
		Do While (cAlias)->(!Eof())
			aDados	:= {}
			For nX := 1 to Len(aColunas)
				cCampo := "(cAlias)->"+aColunas[nX,1]
				aAdd(aDados,If(aColunas[nX,2] = "D", StoD(&cCampo),&cCampo))
			Next nX
			oSection1:PrintLine()
			(cAlias)->(dbskip())
		EndDo
		(cAlias)->(dbCloseArea())
	EndIf

	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery    ºAutor  ³Richard N Cabral  º Data ³  15/09/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Transportes                                    ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery := ""

	cQuery += " SELECT  " + CRLF
	cQuery += " GW3_FILIAL, D2_CLIENTE,D2_SERIE,A1_NOME, GW4_NRDC, F2_EMISSAO,F2_VALBRUT,F2_VALMERC,F2_VOLUME1,F2_PLIQUI,F2_PBRUTO, " + CRLF
	cQuery += " F2_XCODROM, PD1_PLACA, PD1_MOTORI, A4_COD,A4_NOME,GW3_NRDF,GW3_EMISDF, GW3_VLDF,GW3_TAXAS,GW3_FRPESO,GW3_FRVAL,GW3_PEDAG, " + CRLF
	cQuery += " GW3_QTVOL,GW3_PESOR,GW3_VOLUM,GW3_VLCARG,GW3_BASIMP,GW3_PCIMP,GW3_VLIMP,GW3_BASCOF,GW3_VLCOF,GW3_BASPIS,GW3_VLPIS,GW3_TPCTE, " + CRLF
	cQuery += " GWF_BASICM, GW3_NRFAT, GW6_DTVENC, GW6_VLFATU, GW3_DTAPR,GW3_USUAPR, GWF_CIDDES " + CRLF
	cQuery += " FROM " + RetSqlName("GW3") + " GW3 " + CRLF
	cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("GW6") + ") GW6 " + CRLF
	cQuery += " ON GW6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND GW6_NRFAT = GW3_NRFAT " + CRLF
	cQuery += " AND GW6_SERFAT = GW3_SERFAT " + CRLF
	cQuery += " AND GW3_FILIAL = GW6_FILIAL " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("GW4") + ") GW4 " + CRLF
	cQuery += " ON GW4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND GW4_NRDF = GW3_NRDF " + CRLF
	cQuery += " AND GW4_SERDF = GW3_SERDF " + CRLF
	cQuery += " AND GW3_FILIAL = GW4_FILIAL " + CRLF
	cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("GWH") + ") GWH " + CRLF
	cQuery += " ON GWH.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND GW4_NRDC = GWH_NRDC " + CRLF
	cQuery += " AND GW4_SERDC = GWH_SERDC " + CRLF
	cQuery += " AND GWH_FILIAL = GW4_FILIAL " + CRLF
	cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("GWF") + ") GWF " + CRLF
	cQuery += " ON GWF.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND GWF_NRCALC = GWH_NRCALC " + CRLF
	cQuery += " AND GWF_FILIAL = GWH_FILIAL " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SF2") + ") SF2 " + CRLF
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND GW4_NRDC = F2_DOC " + CRLF
	cQuery += " AND GW4_SERDC = F2_SERIE " + CRLF
	cQuery += " AND F2_FILIAL = GW4_FILIAL " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SD2") + ") SD2 " + CRLF
	cQuery += " ON SD2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND D2_DOC = F2_DOC " + CRLF
	cQuery += " AND D2_SERIE = F2_SERIE " + CRLF
	cQuery += " AND F2_FILIAL = D2_FILIAL " + CRLF
	cQuery += " AND D2_ITEM = '01' " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("PD1") + ") PD1 " + CRLF
	cQuery += " ON PD1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND PD1_CODROM = F2_XCODROM " + CRLF
	cQuery += " AND F2_FILIAL = PD1_FILIAL " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SA1") + ") SA1 " + CRLF
	cQuery += " ON SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND A1_COD= F2_CLIENTE " + CRLF
	cQuery += " AND A1_LOJA = F2_LOJA " + CRLF
	cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SA4") + ") SA4 " + CRLF
	cQuery += " ON SA4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND A4_COD= F2_TRANSP " + CRLF
	cQuery += " WHERE GW3.D_E_L_E_T_ =  ' ' " + CRLF
	cQuery += " AND F2_DOC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
	cQuery += " AND F2_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' " + CRLF
	cQuery += " AND F2_FILIAL = '" + xFilial("SD2") + "' " + CRLF

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)


Return()

Static Function AjustaSX1()

PutSx1(cPerg, "01", "NF De" 		,"NF De" 		,"NF De" 		,"mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "NF Até" 		,"NF Até" 		,"NF Até"	 	,"mv_ch2","C",09,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Emissão De"	,"Emissão De"	,"Emissão De"	,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Emissão Até"	,"Emissão Até"	,"Emissão Até"	,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")

Return

