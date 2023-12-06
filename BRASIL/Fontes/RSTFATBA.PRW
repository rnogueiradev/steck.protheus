#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RSTFATBA  ºAutor  ³ Richard N Cabral   ºData  ³  20/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Analise Cliente Anual                             º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATBA()
	
	Local   oReport
	Private cPerg 			:= "RSTFATBA"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasSD2   	:= "TMPSD2"
	Private cAliasSD1   	:= "TMPSD1"
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private _cNome          := " "
	Private _cCod           := __cuserid
	Private cPergTit 		:= cPerg+cHora+cMinutos+cSegundos
	Private aLojaGrp		:= {}
	Private aTotx			:= {}
	Private nSeqCol			:= 0
	Private aAuxCol			:= {}
	
	Public  _cXCodVen361    := ' '
	Public n
	
	DbSelectArea('SA1')
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3') + _cCod))
		If ! (Substr(SA3->A3_COD,1,1) $ "/C/S")
			If ! (_cCod $ GetMv("ST_FATBA",,'000391/000380')+'/000000/000645')
				MsgInfo("Usuario sem acesso")
				Return()
			EndIf
		EndIf
		If SA3->A3_TPVEND <> 'I'
			_cXCodVen361 := SA3->A3_COD
			SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
		EndIf
	EndIf

	U_STPutSx1( cPerg, "01","Cliente ?" 			   	,"MV_PAR01","mv_ch1","C",06,0,"G",'ExistCpo("SA1")'		,"SA1"	,"@!"		)
	U_STPutSx1( cPerg, "02","Loja De ?" 			   	,"MV_PAR02","mv_ch2","C",02,0,"G",""					,""		,"99"		)
	U_STPutSx1( cPerg, "03","Loja Ate ?" 			   	,"MV_PAR03","mv_ch3","C",02,0,"G",""					,""		,"99"		)
	U_STPutSx1( cPerg, "04","Ano(Base) ?"				,"MV_PAR04","mv_ch4","C",04,0,"G","U_ValAno(MV_PAR04)"	,""		,"9999"		)
	U_STPutSx1( cPerg, "05","Mês de ?" 					,"MV_PAR05","mv_ch5","C",02,0,"G","U_ValMes(MV_PAR05)"	,""		,"99"		)
	U_STPutSx1( cPerg, "06","Mês Até ?"    				,"MV_PAR06","mv_ch6","C",02,0,"G","U_ValMes(MV_PAR06)"	,""		,"99"		)
	U_STPutSx1( cPerg, "07","Analítico/Sintético ?" 	,"MV_PAR07","mv_ch7","N",01,0,"C",""					,""		,""			,"Analítico","Sintético"	)

	oReport		:= ReportDef()

	oReport:PrintDialog()
	SA1->(DbClearFilter())
Return

Static Function ReportDef()
	
	Local oReport
	Local oSection1
	Local nMeses := 0


	DbSelectArea("SA1")
	SA1->(dbGoTop())
	SA1->(dbSetOrder(1))
	If Pergunte(cPerg,.T.) .And. SA1->(DbSeek(xFilial("SA1") + MV_PAR01 ))

		oReport := TReport():New(cPergTit,"Relatório Análise de Clientes Anual - " + If(MV_PAR07 = 1,"Analítico","Sintético"),cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Análise de Cliente Anual.")

		_cNome := ""
		
		DbSelectArea("SA1")
		SA1->(dbGoTop())
		SA1->(dbSetOrder(1))
		If	SA1->(DbSeek(xFilial("SA1") + MV_PAR01))
			_cNome := ALLTRIM(SA1->A1_NREDUZ)
		EndIf

		aAuxCol := {}

		oSection1 := TRSection():New(oReport,"Análise de Cliente Anual ("+_cNome+") - "+If(MV_PAR07 = 1,"Analítico","Sintético"),{"SA1"})
		
		TRCell():New(oSection1,"CLIENTE"			,,"Cliente"			,"@!"				,06,.F.,)
		TRCell():New(oSection1,"LOJA"				,,"Loja"			,"@!"				,02,.F.,)

		aAdd(aAuxCol,"CLIENTE")
		aAdd(aAuxCol,"LOJA")

		If MV_PAR07 = 1
			TRCell():New(oSection1,"GRUPO"			,,"Grupo"			,"@!"				,40,.F.,)
			aAdd(aAuxCol,"GRUPO")
		EndIf
		
		For nMeses := Val(MV_PAR05) to Val(MV_PAR06)
			cAnoMesAtu	:= MV_PAR04 + StrZero(nMeses,2)
			cAnoMesAnt	:= Tira1(MV_PAR04) + StrZero(nMeses,2)
			cValorAtu	:= "VALOR" + cAnoMesAtu
			cValorAnt	:= "VALOR" + cAnoMesAnt
			cCabecAtu	:= "Valor (" + MV_PAR04 + ")"
			cCabecAnt	:= MesExtenso(nMeses) + " Valor (" + Tira1(MV_PAR04) + ")"
			cDifer		:= "DIFER" + StrZero(nMeses,2)
			TRCell():New(oSection1,cValorAnt		,,cCabecAnt			,"@E 99,999,999.99"	,14,.F.,)
			TRCell():New(oSection1,cValorAtu		,,cCabecAtu			,"@E 99,999,999.99"	,14,.F.,)
			TRCell():New(oSection1,cDifer			,,"%Diferença"		,"@E 99,999.99"		,07,.F.,)
			aAdd(aAuxCol,cValorAnt)
			aAdd(aAuxCol,cValorAtu)
			aAdd(aAuxCol,cDifer)
		Next nMeses

		oSection1:SetHeaderSection(.t.)
		//oSection1:Setnofilter("SA1")
	EndIf
	
Return oReport

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local aDados[99]
	Local nMeses		:= 0
	Local nSeq			:= 0
	Local nX,nY := 0

	oSection1:Cell("CLIENTE")									:SetBlock( { || aDados[01] } )
	oSection1:Cell("LOJA")										:SetBlock( { || aDados[02] } )

	If MV_PAR07 = 1
		oSection1:Cell("GRUPO")									:SetBlock( { || aDados[03] } )
		nSeqCol := 4
	Else
		nSeqCol := 3
	EndIf

	For nMeses := Val(MV_PAR05) to Val(MV_PAR06)
		cAnoMesAtu	:= MV_PAR04 + StrZero(nMeses,2)
		cAnoMesAnt	:= Tira1(MV_PAR04) + StrZero(nMeses,2)
		cValorAtu	:= "VALOR" + cAnoMesAtu
		cValorAnt	:= "VALOR" + cAnoMesAnt
		cCabecAtu	:= "Valor (" + MV_PAR04 + ")"
		cCabecAnt	:= "Valor (" + Tira1(MV_PAR04) + ")"
		cDifer		:= "DIFER" + StrZero(nMeses,2)
		oSection1:Cell(cValorAnt)								:SetBlock( &("{ || aDados["+cValToChar(nSeqCol+0)+"] }") )
		oSection1:Cell(cValorAtu)								:SetBlock( &("{ || aDados["+cValToChar(nSeqCol+1)+"] }") )
		oSection1:Cell(cDifer)									:SetBlock( &("{ || aDados["+cValToChar(nSeqCol+2)+"] }") )
		nSeqCol += 3
	Next nMeses

	oReport:SetTitle("Análise de Cliente Anual ("+_cNome+") - "+Iif (MV_PAR07 = 1,'Analítico','Sintético'))// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection1:Init()

	Processa({|| StQueryBA() },"Compondo Relatorio")

	cLojaOld := ""
	For nX := 1 to Len(aLojaGrp)
		For nY := 1 to Len(aAuxCol)
			If "DIFER" $ aAuxCol[nY] .And. aLojaGrp[nX,nY-1] <> 0 .And. aLojaGrp[nX,nY-2] <> 0 
				aDados[nY] := ( ( aLojaGrp[nX,nY-1] / aLojaGrp[nX,nY-2] ) - 1 ) * 100
			Else
				aDados[nY] := aLojaGrp[nX,nY]
			EndIf
		Next nY
		
		If MV_PAR07 = 1
			If ! Empty(cLojaOld) .And. aLojaGrp[nX,2] <> cLojaOld
				oReport:SkipLine()
			EndIf

			If aLojaGrp[nX,2] = cLojaOld
				aDados[1] := ""
				aDados[2] := ""
			Endif
			cLojaOld := aLojaGrp[nX,2]
		Endif

		oSection1:PrintLine()
		aFill(aDados,nil)
	Next nX

	oReport:SkipLine()

	For nX := 1 to Len(aTotx)
		For nY := 1 to Len(aAuxCol)
			If "DIFER" $ aAuxCol[nY] .And. aTotx[nX,nY-1] <> 0 .And. aTotx[nX,nY-2] <> 0
				aDados[nY] := ( ( aTotx[nX,nY-1] / aTotx[nX,nY-2] ) - 1 ) * 100
			Else
				aDados[nY] := aTotx[nX,nY]
			EndIf
		Next nY
	Next nX
	oSection1:PrintLine()
	aFill(aDados,nil)

	oReport:SkipLine()

Return oReport

Static Function StQueryBA()
	
	Local cQuerySD2 := ''
	Local cQuerySD2 := ''
	Local nY 		:= 0

	//---------------------------
	// Query Faturamento
	//---------------------------
	cQuerySD2 += " SELECT "
	cQuerySD2 += ' SD2.D2_LOJA "LOJA", SUBSTR(SD2.D2_EMISSAO,1,6) "MES", '

	If MV_PAR07 = 1
		cQuerySD2 += ' SB1.B1_GRUPO "GRUPO", '
		cQuerySD2 += ' SBM.BM_DESC  "DESCG", '
	EndIf

	cQuerySD2 += ' SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM) "FATUR", '
	cQuerySD2 += ' 0 "DEVOL" '
	cQuerySD2 += " FROM " + RetSqlName("SD2") + " SD2 "

	If MV_PAR07 = 1
		cQuerySD2 += " INNER JOIN (SELECT * FROM " + RetSqlName("SB1") + ") SB1 "
		cQuerySD2 += " ON SB1.D_E_L_E_T_   = ' ' "
		cQuerySD2 += " AND SB1.B1_COD    = SD2.D2_COD "
		cQuerySD2 += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
			
		cQuerySD2 += " INNER JOIN (SELECT * FROM " + RetSqlName("SBM") + ") SBM "
		cQuerySD2 += " ON SBM.D_E_L_E_T_   = ' ' "
		cQuerySD2 += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO "
		cQuerySD2 += " AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' "
	EndIf
		
	cQuerySD2 += " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + ") SA1 "
	cQuerySD2 += " ON SA1.D_E_L_E_T_   = ' ' "
	cQuerySD2 += " AND SA1.A1_COD = SD2.D2_CLIENTE "
	cQuerySD2 += " AND SA1.A1_LOJA = SD2.D2_LOJA "
	cQuerySD2 += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
		
	If SA3->A3_TPVEND <> 'I'
		cQuerySD2 += " AND SA1.A1_VEND = '" + _cXCodVen361 + "' "
	EndIf
		
	cQuerySD2 += " INNER JOIN (SELECT * FROM " + RetSqlName("SF4") + ") SF4 "
	cQuerySD2 += " ON SD2.D2_TES = SF4.F4_CODIGO "
	cQuerySD2 += " AND SF4.D_E_L_E_T_ = ' ' "
//	cQuerySD2 += " AND SF4.F4_DUPLIC = 'S' "
	cQuerySD2 += " AND SF4.F4_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') "
		
	cQuerySD2 += " WHERE  SD2.D_E_L_E_T_ = ' ' "
	cQuerySD2 += " AND ( SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '" + Tira1(MV_PAR04) + MV_PAR05 + "' AND '" + Tira1(MV_PAR04) + MV_PAR06 + "' OR SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '" + MV_PAR04 + MV_PAR05 + "' AND '" + MV_PAR04 + MV_PAR06 + "') "
	cQuerySD2 += " AND SD2.D2_CLIENTE =  '" + MV_PAR01 + "' "
	cQuerySD2 += " AND SD2.D2_LOJA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
//	cQuerySD2 += " AND SD2.D2_FILIAL   = '" + xFilial("SD2") + "' "
	cQuerySD2 += " AND SA1.A1_GRPVEN <> 'ST' "
	cQuerySD2 += " AND SA1.A1_EST    <> 'EX' "

	cQuerySD2 += " GROUP BY SD2.D2_LOJA, SUBSTR(D2_EMISSAO,1,6) "
	
	If MV_PAR07 = 1
		cQuerySD2 += ",SB1.B1_GRUPO, SBM.BM_DESC "
	EndIf

	cQuerySD2 += " UNION ALL "

	//---------------------------
	// Query Devolucao
	//---------------------------
	cQuerySD2 += " SELECT "
	cQuerySD2 += ' SD1.D1_LOJA "LOJA", SUBSTR(SD1.D1_EMISSAO,1,6) "MES", '

	If MV_PAR07 = 1
		cQuerySD2 += ' SB1.B1_GRUPO "GRUPO", '
		cQuerySD2 += ' SBM.BM_DESC  "DESCG", '
	EndIf
	
	cQuerySD2 += ' 0 "FATUR", '
	cQuerySD2 += ' NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) "DEVOL" '
	cQuerySD2 += " FROM " + RetSqlName("SD1") + " SD1 "

	If MV_PAR07 = 1
		cQuerySD2 += " INNER JOIN (SELECT * FROM " + RetSqlName("SB1") + ") SB1 "
		cQuerySD2 += " ON SB1.D_E_L_E_T_   = ' ' "
		cQuerySD2 += " AND SB1.B1_COD    = SD1.D1_COD "
		cQuerySD2 += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
			
		cQuerySD2 += " INNER JOIN (SELECT * FROM " + RetSqlName("SBM") + ") SBM "
		cQuerySD2 += " ON SBM.D_E_L_E_T_   = ' ' "
		cQuerySD2 += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO "
		cQuerySD2 += " AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' "
	EndIf
	
	cQuerySD2 += " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + ") SA1 "
	cQuerySD2 += " ON SA1.D_E_L_E_T_ = ' ' "
	cQuerySD2 += " AND SD1.D1_TIPO = 'D' "
	cQuerySD2 += " AND SA1.A1_GRPVEN <> 'ST' "
	cQuerySD2 += " AND SA1.A1_GRPVEN <> 'SC' "
	cQuerySD2 += " AND SA1.A1_EST    <> 'EX' "
	cQuerySD2 += " AND SA1.A1_COD = SD1.D1_FORNECE "
	cQuerySD2 += " AND SA1.A1_LOJA = SD1.D1_LOJA "
	cQuerySD2 += " AND SA1.A1_FILIAL = '  ' "
	
	If SA3->A3_TPVEND <> 'I'
		cQuerySD2 += " AND SA1.A1_VEND = '" + _cXCodVen361 + "' "
	EndIf
	
	cQuerySD2 += " INNER JOIN(SELECT * FROM " + RetSqlName("SF2") + ") SF2 "
	cQuerySD2 += " ON SF2.D_E_L_E_T_ = ' ' "
	cQuerySD2 += " AND SF2.F2_DOC = D1_NFORI "
	cQuerySD2 += " AND SF2.F2_SERIE = D1_SERIORI "
	cQuerySD2 += " AND SF2.F2_FILIAL = SD1.D1_FILIAL "

	cQuerySD2 += " WHERE SD1.D_E_L_E_T_ = ' ' "
	cQuerySD2 += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') "
	cQuerySD2 += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " 
	cQuerySD2 += " AND SA1.A1_LOJA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
	cQuerySD2 += " AND ( SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '" + Tira1(MV_PAR04) + MV_PAR05 + "' AND '" + Tira1(MV_PAR04) + MV_PAR06 + "' OR SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '" + MV_PAR04 + MV_PAR05 + "' AND '" + MV_PAR04 + MV_PAR06 + "') "
	cQuerySD2 += " AND SA1.A1_COD = '" + MV_PAR01 + "' "

	If MV_PAR07 = 1
		cQuerySD2 += " GROUP BY SD1.D1_LOJA, SUBSTR(D1_EMISSAO,1,6), SB1.B1_GRUPO, SBM.BM_DESC "
		cQuerySD2 += " ORDER BY LOJA, MES, GRUPO "
	Else
		cQuerySD2 += " GROUP BY SD1.D1_LOJA, SUBSTR(D1_EMISSAO,1,6) "
		cQuerySD2 += " ORDER BY LOJA, MES "
	EndIf
	
	cQuerySD2 := ChangeQuery(cQuerySD2)
	
	If Select(cAliasSD2) > 0
		(cAliasSD2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuerySD2),cAliasSD2)

	aLojaGrp := {}
	aTotx  := {}

	DbSelectArea(cAliasSD2)
	(cAliasSD2)->(DbGoTop())

	aAdd(aTotx,Array(Len(aAuxCol)))

	aTotx[Len(aTotx),1] := "TOTAIS"
	For nY := 1 to Len(aAuxCol)
		If "VALOR" $ aAuxCol[nY] .Or. "DIFER" $ aAuxCol[nY]
			aTotx[Len(aTotx),nY] := 0
		EndIf
	Next nY

	If  Select(cAliasSD2) > 0
		Do While (cAliasSD2)->(! Eof())
			If MV_PAR07 = 1
				nPosLoja := aScan(aLojaGrp,	{|x| x[2] = (cAliasSD2)->LOJA .And.  Substr(x[3],1,4) = (cAliasSD2)->GRUPO })
			Else
				nPosLoja := aScan(aLojaGrp,	{|x| x[2] = (cAliasSD2)->LOJA })
			EndIf
			
			If Empty(nPosLoja)
				aAdd(aLojaGrp,Array(Len(aAuxCol)))
				nPosLoja := Len(aLojaGrp)
				aLojaGrp[nPosLoja,1] := MV_PAR01
				aLojaGrp[nPosLoja,2] := (cAliasSD2)->LOJA
				If MV_PAR07 = 1
					aLojaGrp[nPosLoja,3] := PadR((cAliasSD2)->GRUPO,4) + " - " + (cAliasSD2)->DESCG
				EndIf
				For nY := 1 to Len(aAuxCol)
					If "VALOR" $ aAuxCol[nY] .Or. "DIFER" $ aAuxCol[nY]
						aLojaGrp[nPosLoja,nY] := 0
					EndIf
				Next nY
			EndIf
			nPosAnoMes := aScan(aAuxCol,"VALOR"+(cAliasSD2)->MES)
			aLojaGrp[nPosLoja, nPosAnoMes] += ( (cAliasSD2)->FATUR - (cAliasSD2)->DEVOL )
			aTotx[Len(aTotx), nPosAnoMes]  += ( (cAliasSD2)->FATUR - (cAliasSD2)->DEVOL )
			(cAliasSD2)->(dbskip())
		EndDo

		(cAliasSD2)->(dbCloseArea())
	EndIf

Return()

User Function ValAno(cAno)

	If ! ( cAno >= "2000" )
		MsgAlert("Digite o Ano acima de '2000'")
		Return(.F.)
	EndIf

Return(.T.)

User Function ValMes(cMes)

	If ! ( cMes >= "01" .And. cMes <= "12" )
		MsgAlert("Digite o Mês entre '01' e '12'")
		Return(.F.)
	EndIf

Return(.T.)

