#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_RSTFATCH()

 Relatorio Captação por canal

@type function
@author Everson Santana
@since 08/02/19
@version Protheus 12 - Faturamento

@history ,Ticket  20190715000072 ,

/*/
User Function RSTFATCH()

	Local   oReport
	Private _cPerg 	 := PadR ("RSTFATCH", Len (SX1->X1_GRUPO))
	Private _cAlias	:= GetNextAlias()

	ValidPerg()

	oReport:= ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New("RSTFATCH","Relatorio Captação por canal","RSTFATCH",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir Relatorio Captação por canal")

	Pergunte(_cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatorio Captação por canal",{"SC5"})

	TRCell():New(oSection,"01",,"Mes"			,PesqPict('SC5',"C5_VEND1")		,TamSX3("C5_VEND1")[1]+15	,.F.,)
	TRCell():New(oSection,"02",,"Codigo"		,PesqPict('SA1',"A1_COD")		,TamSX3("A1_COD")[1]+25		,.F.,)
	TRCell():New(oSection,"03",,"Agrupamento"	,PesqPict('SBM',"BM_XAGRUP")	,TamSX3("BM_XAGRUP")[1]+35	,.F.,)
	TRCell():New(oSection,"04",,"Grp.Vendas  "	,PesqPict('SA1',"A1_GRPVEN")	,TamSX3("A1_GRPVEN")[1]+35	,.F.,)
	TRCell():New(oSection,"05",,"Valor"			,PesqPict('SC6',"C6_ZVALLIQ")	,TamSX3("C6_ZVALLIQ")[1]+35	,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

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

	oReport:SetTitle("Relatorio Captação por canal")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	If  Select(_cAlias) > 0

		While 	(_cAlias)->(!Eof())

			aDados1[01]	:=	(_cAlias)->MES
			aDados1[02]	:=	(_cAlias)->A1_COD
			aDados1[03]	:=	(_cAlias)->BM_XAGRUP
			aDados1[04]	:=	(_cAlias)->A1_GRPVEN
			aDados1[05]	:=	(_cAlias)->VALOR

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

Static Function StQuery()

	Local _cQuery     := ""

	_cQuery := " SELECT SUBSTR(SC5.C5_EMISSAO,5,2) AS MES, A1_COD, BM_XAGRUP, A1_GRPVEN, SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR " + CR
	_cQuery += " FROM "+RetSqlName("SC6")+" SC6 " + CR
	_cQuery += " 	INNER JOIN (SELECT * FROM "+RetSqlName("SB1")+") SB1 " + CR
	_cQuery += " 		ON SB1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += " 			AND SB1.B1_COD = SC6.C6_PRODUTO " + CR
	_cQuery += " 			AND SB1.B1_FILIAL = '  ' " + CR
	_cQuery += " 	INNER JOIN (SELECT * FROM "+RetSqlName("SBM")+" ) SBM "+ CR
	_cQuery += " 		ON SBM.D_E_L_E_T_ = ' ' "+ CR
	_cQuery += " 			AND SB1.B1_GRUPO = SBM.BM_GRUPO "+ CR
	_cQuery += " 	INNER JOIN (SELECT *  FROM "+RetSqlName("SC5")+") SC5 "+ CR
	_cQuery += " 		ON SC5.D_E_L_E_T_ = ' ' "+ CR
	_cQuery += " 			AND SC5.C5_NUM = SC6.C6_NUM "+ CR
	_cQuery += " 			AND SC5.C5_FILIAL = SC6.C6_FILIAL "+ CR
	_cQuery += " 			AND SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+ CR
	_cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" ) SA1 "+ CR
	_cQuery += " 		ON SA1.D_E_L_E_T_ = ' ' "+ CR
	_cQuery += " 			AND A1_COD = C5_CLIENTE "+ CR
	_cQuery += " 			AND A1_LOJA = C5_LOJACLI "+ CR
	_cQuery += " 			AND A1_FILIAL = ' ' "+ CR
	_cQuery += "	LEFT JOIN (SELECT *  FROM  "+RetSqlName("PC1")+" )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '"+ CR
	_cQuery += " 	INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' "+ CR
	_cQuery += " WHERE  SC6.D_E_L_E_T_ = ' ' "+ CR
	_cQuery += "	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"+ CR
	_cQuery += " 	AND SC5.C5_TIPO = 'N' "+ CR
	_cQuery += "	AND SA1.A1_GRPVEN <> 'ST' "+ CR
	_cQuery += "	AND SA1.A1_EST <> 'EX' "+ CR
	_cQuery += "	AND PC1.PC1_PEDREP IS NULL"+ CR
	_cQuery += " GROUP BY SUBSTR(SC5.C5_EMISSAO,5,2)  , "+ CR
	_cQuery += "	A1_COD,A1_GRPVEN,"+ CR
	_cQuery += "	BM_XAGRUP "+ CR

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_cAlias)

Return()

Static Function ValidPerg()

	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0

	_cPerg         := PADR(_cPerg,10)

	AADD(_aRegs,{_cPerg, "01", "Da Emissão ?"		,"Da Emissão ?"	 ,"Da Emissão ?"		,"mv_ch1","D",08,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "02", "Ate Emissão ?"		,"Ate Emissão ?"	 ,"Ate Emissão ?"	,"mv_ch2","D",08,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","",""})

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

