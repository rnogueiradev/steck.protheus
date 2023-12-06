#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATBC   ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE FATURAMENTO NET POR VEND EXTERNO E REPRES.   º±±
±±º          ³  E POR GRUPO                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RSTFATBC()

	Local   oReport
	Private _cPerg 	 := PadR ("RSTFATBC", Len (SX1->X1_GRUPO))
	Private _cAlias	:= GetNextAlias()
	
	ValidPerg()
	
	oReport:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATBC   ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE FATURAMENTO NET POR VEND EXTERNO E REPRES.   º±±
±±º          ³  E POR GRUPO                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

	Local oReport
	Local oSection
	
	oReport := TReport():New("RSTFATBC","Relatório de Faturamento Net Por Vendedor Externo e Representante","RSTFATBC",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir Relatório de Faturamento Net Por Vendedor Externo e Representante")
	
	Pergunte(_cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Relatório de Faturamento Net Por Vendedor Externo e Representante",{"SC5"})
	
	//TRCell():New(oSection1, "B1_FILIAL"	, "QRY", 'FILIAL'	,PesqPict('SB1',"B1_FILIAL"),TamSX3("B1_FILIAL")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,"01",,"Vendedor"		,PesqPict('SC5',"C5_VEND1")		,TamSX3("C5_VEND1")[1]	,.F.,)
	TRCell():New(oSection,"02",,"Nome"			,PesqPict('SA3',"A3_NOME")		,TamSX3("A3_NOME")[1]	,.F.,)
	TRCell():New(oSection,"03",,"Produto"		,PesqPict('SC6',"C6_PRODUTO")	,TamSX3("C6_PRODUTO")[1]	,.F.,)
	TRCell():New(oSection,"04",,"Grupo"		,PesqPict('SB1',"B1_GRUPO")		,TamSX3("B1_GRUPO")[1]	,.F.,)
	TRCell():New(oSection,"05",,"Vlr Liquido"	,PesqPict('SC6',"C6_ZVALLIQ")	,TamSX3("C6_ZVALLIQ")[1]	,.F.,)
	TRCell():New(oSection,"06",,"Qtd Vendida"	,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
	TRCell():New(oSection,"07",,"Qtd Entregue",PesqPict('SC6',"C6_QTDENT")	,TamSX3("C6_QTDENT")[1]	,.F.,)
	TRCell():New(oSection,"08",,"Dt Emissão"	,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]	,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATBC   ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE FATURAMENTO NET POR VEND EXTERNO E REPRES.   º±±
±±º          ³  E POR GRUPO                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

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
 
	oReport:SetTitle("Relatório de Faturamento Net Por Vendedor Externo e Representante")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	If  Select(_cAlias) > 0
	
		While 	(_cAlias)->(!Eof())

			aDados1[01]	:=	(_cAlias)->C5_VEND1
			aDados1[02]	:=	(_cAlias)->A3_NOME
			aDados1[03]	:=	(_cAlias)->C6_PRODUTO
			aDados1[04]	:=	(_cAlias)->B1_GRUPO
			aDados1[05]	:=	(_cAlias)->C6_ZVALLIQ
			aDados1[06]	:=	(_cAlias)->C6_QTDVEN
			aDados1[07]	:= 	(_cAlias)->C6_QTDENT
			aDados1[08]	:= Stod((_cAlias)->C5_EMISSAO)
				  	
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(_cAlias)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(_cAlias)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery    ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE FATURAMENTO NET POR VEND EXTERNO E REPRES.   º±±
±±º          ³  E POR GRUPO                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function StQuery()

	Local _cQuery     := ""
	
	
	_cQuery := " SELECT C5.C5_VEND1,A3.A3_NOME,C6.C6_PRODUTO,B1.B1_GRUPO,C6.C6_ZVALLIQ,C6.C6_QTDVEN,C6.C6_QTDENT,C5.C5_EMISSAO "
	_cQuery += " FROM " + RetSqlName("SC5") + " C5 "
	_cQuery += " INNER JOIN " + RetSqlName("SC6") + " C6 "
	_cQuery += "  ON C6.C6_FILIAL = C5.C5_FILIAL "
	_cQuery += "  AND C6.C6_NUM = C5.C5_NUM "
	_cQuery += "  AND C6.D_E_L_E_T_ = ' ' "
	_cQuery += " INNER JOIN "+ RetSqlName("SA3") + " A3 "
	_cQuery += "  ON A3.A3_COD = C5.C5_VEND1 "
	_cQuery += "  AND A3.D_E_L_E_T_ = ' ' "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
	_cQuery += "  ON B1.B1_COD = C6.C6_PRODUTO "
	_cQuery += "  AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE C5.C5_VEND1 BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "  AND C5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
	_cQuery += "  AND B1.B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += "  AND C5.D_E_L_E_T_ = ' ' "
			
	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_cAlias)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ValidPerg  ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Criacao e apresentacao das perguntas						    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0

	_cPerg         := PADR(_cPerg,10)

	AADD(_aRegs,{_cPerg, "01", "Do Vendedor ?" 	,"Do Vendedor ?" 	 ,"Do Vendedor ?" 	,"mv_ch1","C",06,0,0,"G","","SA3" ,"","","mv_par01","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "02", "Ate Vendedor ?" 	,"Ate Vendedor ?"	 ,"Ate Vendedor ?"	,"mv_ch2","C",06,0,0,"G","","SA3" ,"","","mv_par02","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "03", "Da Emissão ?"		,"Da Emissão ?"	 ,"Da Emissão ?"		,"mv_ch3","D",08,0,0,"G","",""    ,"","","mv_par03","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "04", "Ate Emissão ?"	,"Ate Emissão ?"	 ,"Ate Emissão ?"		,"mv_ch4","D",08,0,0,"G","",""    ,"","","mv_par04","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "05", "Do Grupo ?"		,"Do Grupo ?"	 	 ,"Do Grupo ?"		,"mv_ch5","C",03,0,0,"G","","SBM" ,"","","mv_par05","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "06", "Ate Grupo ?"		,"Ate Grupo ?"	 ,"Ate Grupo ?"		,"mv_ch6","c",03,0,0,"G","","SBM" ,"","","mv_par06","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Endif
			next j
			MsUnlock()
		EndIf
	next i

	RestArea(_sAlias)

return

