#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  STBLOQPROD บAutor  ณRichard N Cabral  บ Data ณ  14/09/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloqueio de produto fabricados e materia prima              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function STBLOQPROD()
*-----------------------------*
	Local   oReport

	Private cPerg		:= "BLOQ01"
	Private cTime		:= Time()
	Private cHora		:= SUBSTR(cTime, 1, 2)
	Private cMinutos	:= SUBSTR(cTime, 4, 2)
	Private cSegundos	:= SUBSTR(cTime, 7, 2)
	Private cAlias		:= "BLOQ01"
	Private cPergTit	:= cPerg + cHora + cMinutos + cSegundos
	Private aAtualiza	:= {}

	oReport	:= ReportDef()
	oReport:PrintDialog()

	If MsgNoYes("Confirma o bloqueio dos produtos com estoque zerado ?")
		Processa({|| BloqProd() },"Aguarde, Bloqueando Produtos")
	EndIF	

Return

Static Function BloqProd()
	Local nX := 0
	
	SB1->(DbSetOrder(1))
	For nX := 1 to Len(aAtualiza)
		If SB1->(DbSeek(xFilial("SB1") + aAtualiza[nX]))
			IncProc("Bloqueando Produto " + aAtualiza[nX])
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "1"
			SB1->B1_XDESAT := "2"
			SB1->(MsUnLock())
		EndIf
	Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef  บAutor  ณRichard N Cabral  บ Data ณ  14/09/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloqueio de produto fabricados e materia prima              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Listagem de ocorr๊ncias - Bloqueio de Produtos Fabricados",,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir a Listagem de ocorr๊ncias - Bloqueio de Produtos Fabricados")

	oSection := TRSection():New(oReport,"Bloqueio de Produtos Fabricados",{"SB1"})

	TRCell():New(oSection,"01",,"Relat๓rio"				,,15,.F.,)
	TRCell():New(oSection,"02",,"Tipo"					,,02,.F.,)
	TRCell():New(oSection,"03",,"Classe Produto"	 	,,10,.F.,)
	TRCell():New(oSection,"04",,"Bloqueado" 			,,10,.F.,)
	TRCell():New(oSection,"05",,"Desativado"  		 	,,10,.F.,)
	TRCell():New(oSection,"06",,"C๓digo"				,,15,.F.,)
	TRCell():New(oSection,"07",,"Descri็ใo"				,,40,.F.,)
	TRCell():New(oSection,"08",,"Estoque"				,,15,.F.,)
	TRCell():New(oSection,"09",,"Status"				,,15,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SB1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrintบAutor  ณRichard N Cabral  บ Data ณ  14/09/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloqueio de produto fabricados e materia prima              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados	:= {}

	Local aBloqu	:= {{"1","Sim"},{"2","Nใo"},{" ","Nใo"}}
	Local aDesat	:= {{"1","Ativado"},{"2","0esativado"},{" ","Ativado"}}
	Local aClasse	:= {{"F","FABRICADO"},{"I","IMPORTADO"},{"C","COMPRADO"},{" "," "}}

	Local lSemEst	:= .T.
	Local cClasse	:= "" 
	Local cBloqu	:= "" 
	Local cDesat	:= "" 
	Local cStatus	:= ""

	oSection1:Cell("01") :SetBlock( { || aDados[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados[09] } )

	oReport:SetTitle("Relat๓rio de entregas de itens importados")// Titulo do relat๓rio

	oReport:SetMeter(0)

	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	aAtualiza	:= {}
	
	If Select(cAlias) > 0
		Do While (cAlias)->(!Eof())
			aDados	:= {}
			lSemEst	:= ( Empty((cAlias)->ESTOQUE) )
			cClasse	:= aClasse[aScan(aClasse	,{|x| x[1] = (cAlias)->B1_CLAPROD	}),2] 
			cBloqu	:= aBloqu[aScan(aBloqu		,{|x| x[1] = (cAlias)->B1_MSBLQL	}),2] 
			cDesat	:= aDesat[aScan(aDesat		,{|x| x[1] = (cAlias)->B1_XDESAT	}),2]
			cStatus	:= If(lSemEst,"Bloquear","Analisar")
			aAdd(aDados,(cAlias)->TPRELAT)							//01	"TPRELAT"
			aAdd(aDados,(cAlias)->B1_TIPO)							//02	"B1_TIPO"
			aAdd(aDados,cClasse)									//03	"B1_CLAPROD"
			aAdd(aDados,cBloqu)										//04	"B1_MSBLQL"
			aAdd(aDados,cDesat)										//05	"B1_XDESAT"
			aAdd(aDados,(cAlias)->B1_COD)							//06	"B1_COD"
			aAdd(aDados,(cAlias)->B1_DESC)							//07	"B1_DESC"
			aAdd(aDados,(cAlias)->ESTOQUE)							//08	"ESTOQUE"
			aAdd(aDados,cStatus)									//09	"STATUS"
			If lSemEst
				aAdd(aAtualiza,(cAlias)->B1_COD)
			EndIf
			oSection1:PrintLine()
			(cAlias)->(dbskip())
		EndDo
		(cAlias)->(dbCloseArea())
	EndIf

	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery    บAutor  ณRichard N Cabral  บ Data ณ  14/09/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloqueio de produto fabricados e materia prima              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery := ""

	// Fabricado
	cQuery += " SELECT 'Fabricado' TPRELAT, B1_TIPO, B1_CLAPROD, B1_MSBLQL, B1_XDESAT, B1_COD, B1_DESC,  " + CRLF
	cQuery += " NVL(( SELECT SUM(B2_QATU) SOMA FROM " + RetSqlName("SB2") + " SB2 WHERE B2_COD = B1_COD AND B2_QATU <> 0 AND D_E_L_E_T_ = ' '),0) ESTOQUE " + CRLF
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'  " + CRLF
	cQuery += " AND B1_TIPO NOT IN ('PA','MP') " + CRLF
	cQuery += " AND (B1_MSBLQL <> '1' OR B1_XDESAT <> '2') " + CRLF
	cQuery += " AND NOT EXISTS (SELECT G1_COMP FROM " + RetSqlName("SG1") + " SG1 WHERE SB1.B1_COD = SG1.G1_COMP AND SG1.D_E_L_E_T_ = ' ') " + CRLF
	cQuery += " AND B1_CLAPROD = 'F' " + CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' '  " + CRLF

	cQuery += " UNION ALL  " + CRLF

	// Materia Prima
	cQuery += " SELECT 'Materia Prima' TPRELAT, B1_TIPO, B1_CLAPROD, B1_MSBLQL, B1_XDESAT, B1_COD, B1_DESC,  " + CRLF
	cQuery += " NVL(( SELECT SUM(B2_QATU) SOMA FROM " + RetSqlName("SB2") + " SB2 WHERE B2_COD = B1_COD AND B2_QATU <> 0 AND D_E_L_E_T_ = ' '),0) ESTOQUE " + CRLF
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'  " + CRLF
	cQuery += " AND B1_TIPO = 'MP' " + CRLF
	cQuery += " AND (B1_MSBLQL <> '1' OR B1_XDESAT <> '2') " + CRLF
	cQuery += " AND NOT EXISTS (SELECT G1_COMP FROM " + RetSqlName("SG1") + " SG1 WHERE SB1.B1_COD = SG1.G1_COMP AND SG1.D_E_L_E_T_ = ' ') " + CRLF
	cQuery += " AND B1_CLAPROD <> 'F' " + CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' '  " + CRLF

	cQuery += " ORDER BY TPRELAT, B1_TIPO, B1_CLAPROD, B1_MSBLQL, B1_XDESAT " + CRLF

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)


Return()

