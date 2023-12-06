#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAM     ºAutor  ³Giovani Zago    º Data ³  26/07/16     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Metas	P/ Vendedor  	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAM()
	Local   oReport
	Private cPerg 			:= "RFATAM"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	PutSx1(cPerg, "01", "CLIENTE de:" 	,"Produto de:" 	 ,"Produto de:" 		,"mv_ch1","C",06,0,0,"G","",'SA1' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "CLIENTE Ate:"	,"Produto Ate:"  ,"Produto Ate:"		,"mv_ch2","C",06,0,0,"G","",'SA1' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "CGC de:" 	,"Produto de:" 	 ,"Produto de:" 			,"mv_ch3","C",14,0,0,"G","",' ' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "CGC Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch4","C",14,0,0,"G","",' ' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	
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
	Local oSectio2
	
	oReport := TReport():New(cPergTit,"RELATÓRIO Financeiro Serasa",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Financeiro Serasa")
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 10
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Financeiro Serasa",{"SC6"})
	oSectio2 := TRSection():New(oReport,"Serasa Geral",{"SC6"})
	
	TRCell():New(oSection,"01",,"CODIGO",,		09,.F.,)
	TRCell():New(oSection,"02",,"LOJA",,		09,.F.,)
	TRCell():New(oSection,"03",,"NOME",,		30,.F.,)
	TRCell():New(oSection,"04",,"CNPJ",,		14,.F.,)
	TRCell():New(oSection,"05",,"COND.PAG.",,	03,.F.,)
	TRCell():New(oSection,"06",,"DT.SERASA",,	10,.F.,)
	TRCell():New(oSection,"07",,"DT.OS",,		10,.F.,)
	TRCell():New(oSection,"08",,"ORDEM SEP",,	06,.F.,)
	TRCell():New(oSection,"09",,"DIAS",			"@E 99999",3)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

	TRCell():New(oSectio2,"01",,"CODIGO",,		09,.F.,)
	TRCell():New(oSectio2,"02",,"LOJA",,		09,.F.,)
	TRCell():New(oSectio2,"03",,"NOME",,		30,.F.,)
	TRCell():New(oSectio2,"04",,"CNPJ",,		14,.F.,)
	TRCell():New(oSectio2,"05",,"COND.PAG.",,	03,.F.,)
	TRCell():New(oSectio2,"06",,"DT.SERASA",,	10,.F.,)
	TRCell():New(oSectio2,"07",,"DT.OS",,		10,.F.,)
	TRCell():New(oSectio2,"08",,"ORDEM SEP",,	06,.F.,)

	oSectio2:SetHeaderSection(.t.)
	oSectio2:Setnofilter("SC6")
	
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
	//Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	
	Local aDados[2]
	Local aDados1[99]

	Local aSerasa[2]
	Local aSeras1[99]
	
	Local _cSA1Cod	:= ""
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )

	oSection2:Cell("01") :SetBlock( { || aSeras1[01] } )
	oSection2:Cell("02") :SetBlock( { || aSeras1[02] } )
	oSection2:Cell("03") :SetBlock( { || aSeras1[03] } )
	oSection2:Cell("04") :SetBlock( { || aSeras1[04] } )
	oSection2:Cell("05") :SetBlock( { || aSeras1[05] } )
	oSection2:Cell("06") :SetBlock( { || aSeras1[06] } )
	oSection2:Cell("07") :SetBlock( { || aSeras1[07] } )
	oSection2:Cell("08") :SetBlock( { || aSeras1[08] } )
	
	//oReport:SetTitle("Frete x Financeiro")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	//oSection:Init()
	oSection1:Init()
	
	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			If _cSA1Cod <> (cAliasLif)->A1_COD
				_cSA1Cod := (cAliasLif)->A1_COD

				If	STOD((cAliasLif)->A1_XDTSERA) < DataValida(dDataBase + 10 , .T.)
					If (cAliasLif)->DIAS <= 10
						aDados1[01]	:=  (cAliasLif)->A1_COD 
						aDados1[02]	:=  (cAliasLif)->A1_LOJA
						aDados1[03]	:=  (cAliasLif)->A1_NOME
						//aDados1[04]	:=  (cAliasLif)->A1_CGC
						aDados1[04]	:=  Left((cAliasLif)->A1_CGC,8)
						aDados1[05]	:=  (cAliasLif)->C5_CONDPAG
						aDados1[06]	:=  Dtoc(Stod((cAliasLif)->A1_XDTSERA))
						aDados1[07]	:=  Dtoc(Stod((cAliasLif)->CB7_DTEMIS))
						aDados1[08]	:=  (cAliasLif)->CB7_ORDSEP
						aDados1[09]	:=  (cAliasLif)->DIAS
	
						oSection1:PrintLine()
						aFill(aDados1,nil)
					EndIf
				EndIf

			EndIf
		
			(cAliasLif)->(dbskip())
			
			//oSection1:PrintLine()
			//aFill(aDados1,nil)
		Enddo
			
		(cAliasLif)->(dbCloseArea())
	EndIf

	oReport:SkipLine()
	
// 2a. Parte aqui
	oReport:SetMeter(0)
	aFill(aSerasa,nil)
	aFill(aSeras1,nil)
	oSection2:Init()
	
	Processa({|| StQuer2() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	_cSA1Cod := "" 

	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			If _cSA1Cod <> (cAliasLif)->A1_COD
				_cSA1Cod := (cAliasLif)->A1_COD

				aSeras1[01]	:=  (cAliasLif)->A1_COD 
				aSeras1[02]	:=  (cAliasLif)->A1_LOJA
				aSeras1[03]	:=  (cAliasLif)->A1_NOME
				aSeras1[04]	:=  Left((cAliasLif)->A1_CGC,8)
				aSeras1[05]	:=  (cAliasLif)->C5_CONDPAG
				aSeras1[06]	:=  Dtoc(Stod((cAliasLif)->A1_XDTSERA))
				aSeras1[07]	:=  Dtoc(Stod((cAliasLif)->CB7_DTEMIS))
				aDados1[08]	:=  (cAliasLif)->CB7_ORDSEP
	
				oSection2:PrintLine()
				aFill(aDados1,nil)
			EndIf
		
			(cAliasLif)->(dbskip())

		Enddo
			
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
Static Function StQuery()
*-----------------------------*
	Local cQuery     := ' '

	cQuery := " SELECT" 
	cQuery += " 	DISTINCT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_XDTSERA, CB7_DTEMIS, CB7_ORDSEP,"
	cQuery += " 	C6_NUM, C5_CONDPAG," 
	cQuery += " ROUND(TO_DATE(A1_XDTSERA,'YYYYMMDD') + 90 - SYSDATE,0) " + '"DIAS"'
	cQuery += " FROM " + RetSqlname("CB7") + " CB7"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SA1") + ") SA1		ON SA1.D_E_L_E_T_ = ' ' AND A1_COD 		= CB7_CLIENT 	AND A1_LOJA 	= CB7_LOJA"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC5") + ") SC5 	ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL 	= CB7_FILIAL	AND C5_NUM 		= CB7_PEDIDO 	AND C5_CONDPAG NOT IN ('501' , '599' , 'FRC')"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC6") + ") SC6 	ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL 	= C5_FILIAL 	AND C6_NUM 		= C5_NUM 		AND C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <>'R'"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC9") + ") SC9 	ON SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO 	= C6_NUM 		AND C6_ITEM 	= C9_ITEM 		AND C9_FILIAL = C6_FILIAL AND C9_BLCRED = ' '"
	cQuery += " WHERE CB7.D_E_L_E_T_ = ' '"
	cQuery += " AND A1_XDTSERA <> ' '"
	cQuery += " AND A1_EST <> 'EX'"
	cQuery += " AND A1_COD BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'
	cQuery += " AND A1_CGC BETWEEN '"+  MV_PAR03 +"' AND '"+  MV_PAR04 +"'
	cQuery += " AND CB7_FILIAL 	= '" + cFilAnt + "'"
	cQuery += " AND CB7_NOTA 	= ' '"
	cQuery += " AND CB7_PEDIDO 	<> ' '"
	cQuery += " AND C5_CONDPAG 	<> '501'"
	cQuery += " AND C5_XOBSEXP	NOT IN 'PEDIDO DE INTERNET'"
	cQuery += " ORDER BY 1"

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias (cAliasLif)
	
Return()

Static Function StQuer2()
*-----------------------------*
	Local cQuery     := ' '

	cQuery := " SELECT" 
	cQuery += " 	DISTINCT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_XDTSERA, CB7_DTEMIS, CB7_ORDSEP,"
	cQuery += " 	C6_NUM, C5_CONDPAG" 
	cQuery += " FROM " + RetSqlname("CB7") + " CB7"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SA1") + ") SA1		ON SA1.D_E_L_E_T_ = ' ' AND A1_COD 		= CB7_CLIENT 	AND A1_LOJA 	= CB7_LOJA"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC5") + ") SC5 	ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL 	= CB7_FILIAL	AND C5_NUM 		= CB7_PEDIDO 	AND C5_CONDPAG NOT IN ('501' , '599' , 'FRC')"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC6") + ") SC6 	ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL 	= C5_FILIAL 	AND C6_NUM 		= C5_NUM 		AND C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <>'R'"
	cQuery += " INNER 	JOIN ( SELECT * FROM " + RetSqlName("SC9") + ") SC9 	ON SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO 	= C6_NUM 		AND C6_ITEM 	= C9_ITEM 		AND C9_FILIAL = C6_FILIAL AND C9_BLCRED = ' '"
	cQuery += " WHERE CB7.D_E_L_E_T_ = ' '"
	cQuery += " AND A1_XDTSERA = ' '"
	cQuery += " AND A1_EST <> 'EX'"
	cQuery += " AND A1_COD BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'
	cQuery += " AND A1_CGC BETWEEN '"+  MV_PAR03 +"' AND '"+  MV_PAR04 +"'
	cQuery += " AND CB7_FILIAL 	= '" + cFilAnt + "'"
	cQuery += " AND CB7_NOTA 	= ' '"
	cQuery += " AND CB7_PEDIDO 	<> ' '"
	cQuery += " AND C5_CONDPAG 	<> '501'"
	cQuery += " AND C5_XOBSEXP	NOT IN 'PEDIDO DE INTERNET'"
	cQuery += " ORDER BY 1"

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias (cAliasLif)
	
Return()