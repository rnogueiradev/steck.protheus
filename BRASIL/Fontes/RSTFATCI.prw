#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_RSTFATCI()

RELATORIO DE FLUXO DE UNICOM

@type function
@author Everson Santana
@since 16/07/19
@version Protheus 12 - Faturamento

@history ,Ticket  20190522000031 ,

/*/
User Function RSTFATCI()

	Local   oReport
	Private _cPerg 	 := PadR ("RSTFATCI", Len (SX1->X1_GRUPO))
	Private _cAlias	:= GetNextAlias()

	ValidPerg()

	oReport:= ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2
	oReport := TReport():New("RSTFATCI","RELATORIO DE FLUXO DE UNICOM","RSTFATCI",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir RELATORIO DE FLUXO DE UNICOM")

	Pergunte(_cPerg,.F.)

	oSection := TRSection():New(oReport,"RELATORIO DE FLUXO DE UNICOM",{"PP7"})
	oSection2 := TRSection():New(oReport,"RELATORIO DE FLUXO DE UNICOM",{"PP7"})

	TRCell():New(oSection,"01",,"Codigo"		,PesqPict('PP7',"PP7_CODIGO")	,TamSX3("PP7_CODIGO")[1]+35	,.F.,)
	TRCell():New(oSection,"02",,"Cliente"		,PesqPict('PP7',"PP7_CLIENT")	,TamSX3("PP7_CLIENT")[1]+35	,.F.,)
	TRCell():New(oSection,"03",,"Loja"			,PesqPict('PP7',"PP7_LOJA")		,TamSX3("PP7_LOJA")[1]+30	,.F.,)
	TRCell():New(oSection,"04",,"Nome  "		,PesqPict('PP7',"PP7_NOME")		,TamSX3("PP7_NOME")[1]+100	,.F.,)
	TRCell():New(oSection,"05",,"Historico"		,PesqPict('PP8',"PP8_HIST")		,TamSX3("PP8_HIST")[1]+100	,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection2:SetHeaderSection(.t.)
	oSection:Setnofilter("PP7")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(1)
	//Local nX		:= 0
	//Local aDados[2]
	//Local aDados1[99]

	Local _cCodigo := ""

	//oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	//oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	//oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	//oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	//oSection2:Cell("05") :SetBlock( { || aDados1[05] } )

	oReport:SetTitle("RELATORIO DE FLUXO DE UNICOM")// Titulo do relatório

	oReport:SetMeter(0)
	//aFill(aDados,nil)
	//aFill(aDados1,nil)


	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	If  Select(_cAlias) > 0

		While 	(_cAlias)->(!Eof())

			oSection1:Init()

			oSection1:Cell("01"):SetValue((_cAlias)->PP7_CODIGO)
			oSection1:Cell("02"):SetValue((_cAlias)->PP7_CLIENT)
			oSection1:Cell("03"):SetValue((_cAlias)->PP7_LOJA)
			oSection1:Cell("04"):SetValue((_cAlias)->PP7_NOME)
			oSection1:Cell("05"):SetValue(StrTran((_cAlias)->PP8_HIST+(_cAlias)->PP8_HIST1,"-"," "))

			oSection1:PrintLine()

			oSection1:Finish()

			/*
			_cCodigo := (_cAlias)->PP7_CODIGO

			While !EOF() .AND. (_cAlias)->PP7_CODIGO = _cCodigo

				oSection2:Init()

				oSection2:Cell("05"):SetValue((_cAlias)->PP8_HIST)

				oSection2:PrintLine()
				(_cAlias)->(dbskip())

			End

			_cCodigo := ""
			oSection2:Finish()
			*/

			(_cAlias)->(dbskip())

		End



		(_cAlias)->(dbCloseArea())
	EndIf

	oReport:SkipLine()

Return oReport

Static Function StQuery()

	Local _cQuery     := ""

	_cQuery     := " SELECT PP7.PP7_CODIGO,PP7.PP7_CLIENT,PP7.PP7_LOJA,PP7.PP7_NOME,Replace(utl_raw.cast_to_varchar2(dbms_lob.substr(PP8.PP8_HIST,2000,1)),'-','') PP8_HIST, Replace(utl_raw.cast_to_varchar2(dbms_lob.substr(PP8.PP8_HIST,2000,1)),'-','') PP8_HIST1  " + CR
	_cQuery 	+= "	FROM "+RetSqlName("PP7")+" PP7 " + CR
	_cQuery 	+= "	INNER JOIN "+RetSqlName("PP8")+" PP8 " + CR
	_cQuery 	+= "		ON PP8.PP8_FILIAL = PP7.PP7_FILIAL " + CR
	_cQuery 	+= "    		AND PP8.PP8_CODIGO = PP7.PP7_CODIGO " + CR
	_cQuery 	+= "     		AND PP8.D_E_L_E_T_ = ' ' " + CR
	_cQuery 	+= " WHERE PP7.PP7_EMISSA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery 	+= " AND  PP7.D_E_L_E_T_ = ' ' " + CR

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


