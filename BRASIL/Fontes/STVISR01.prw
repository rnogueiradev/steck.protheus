#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} STVISR01

Relatorio de Visitas Externas

@type Relatorio
@author Everson Santana
@since 05/04/18
@version Protheus 12 - Call Center

@history , ,

/*/

User Function STVISR01()

	Local oReport
	Private _cPerg 	 := PadR ("STVISR01", Len (SX1->X1_GRUPO))

	ValidPerg()

	Pergunte(_cPerg,.F.)

	oReport		:= ReportDef(_cPerg)
	oReport		:PrintDialog()

Return

Static Function ReportDef(_cPerg)

	Local oReport 	:= nil
	Local oSection1	:= nil
	Local oSection2	:= nil
	Local oBreak
	Local oFunction

	oReport := TReport():New("STVISR01","Relatorio De Visitas",_cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir um relat√≥rio De Campanha.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport,"Vendedor",{"Z1R"})

	TRCell():New(oSection1,"01",,"Vendedor      " ,PesqPict('Z1R',"Z1R_VEND")	,TamSX3("Z1R_VEND")[1]	,.F.,)
	TRCell():New(oSection1,"02",,"Nome Vendedor " ,PesqPict('Z1R',"Z1R_NOME")	,TamSX3("Z1R_NOME")[1]	,.F.,)

	oSection2 := TRSection():New(oReport,"Cliente",{"Z1S"})

	TRCell():New(oSection2,"03",,"Cliente      " ,PesqPict('Z1S',"Z1S_CLIENT")	,TamSX3("Z1S_CLIENT")[1]	,.F.,)
	TRCell():New(oSection2,"04",,"Loja 		 " ,PesqPict('Z1S',"Z1S_LOJA")		,TamSX3("Z1S_CLIENT")[1]	,.F.,)
	TRCell():New(oSection2,"05",,"Nome 		 " ,PesqPict('Z1S',"Z1S_NOME")		,TamSX3("Z1S_NOME")[1]	,.F.,)
	TRCell():New(oSection2,"06",,"Cnpj		 	 " ,PesqPict('Z1S',"Z1S_CGC")		,TamSX3("Z1S_CGC")[1]	,.F.,)
	TRCell():New(oSection2,"07",,"Contato 	 	 " ,PesqPict('Z1S',"Z1S_CONTAT")	,TamSX3("Z1S_CONTAT")[1]	,.F.,)
	TRCell():New(oSection2,"08",,"Data Visita	 " ,PesqPict('Z1U',"Z1U_DATA")		,TamSX3("Z1U_DATA")[1]	,.F.,)
	TRCell():New(oSection2,"09",,"Hora da Visi " ,PesqPict('Z1U',"Z1U_HORA")		,TamSX3("Z1U_HORA")[1]	,.F.,)
	TRCell():New(oSection2,"10",,"Data Inclusa " ,PesqPict('Z1U',"Z1U_DATAIN")	,TamSX3("Z1U_DATAIN")[1]	,.F.,)
	TRCell():New(oSection2,"11",,"Detalhes 	 " ,PesqPict('Z1U',"Z1U_OBS")		,TamSX3("Z1U_OBS")[1]	,.F.,)
	TRCell():New(oSection2,"12",,"Dt.Retorno 	 " ,PesqPict('Z1U',"Z1U_DTPRO")		,TamSX3("Z1U_DTPRO")[1]	,.F.,)
	TRCell():New(oSection2,"13",,"OrÁamento 	 " ,PesqPict('Z1U',"Z1U_ORCAME")	,TamSX3("Z1U_ORCAME")[1]	,.F.,)
	TRCell():New(oSection2,"14",,"Dt.Agendada	 " ,PesqPict('Z1T',"Z1T_DATA")		,TamSX3("Z1T_DATA")[1] 	,.F.,)
	TRCell():New(oSection2,"15",,"Hora Agendad " ,PesqPict('Z1T',"Z1T_HORA")		,TamSX3("Z1T_HORA")[1] 	,.F.,)
	TRCell():New(oSection2,"16",,"Data Inclusa " ,PesqPict('Z1T',"Z1T_DATAIN")	,TamSX3("Z1T_DATAIN")[1]	,.F.,)
	TRCell():New(oSection2,"17",,"Detalhes   	 " ,PesqPict('Z1T',"Z1T_OBS")		,TamSX3("Z1T_OBS")[1] 	,.F.,)


	//TRFunction():New(oSection2:Cell("Z1S_CLIENT"),NIL,"COUNT",,,,,.F.,.T.)

	//oSection1:SetHeaderSection(.T.)

//oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local _cQuery 	:= ""
	Local _cAlias		:= ""
	//Local _lRet		:=
	oReport:SetTitle("Relatorio De Visitas")// Titulo do relat√≥rio

	_cAlias := GetNextAlias()
	_cQuery := " SELECT utl_raw.cast_to_varchar2(cast(dbms_lob.substr(Z1U_OBS,2000,1) as varchar2(4000))) AS Z1U_OBS,utl_raw.cast_to_varchar2(cast(dbms_lob.substr(Z1T_OBS,2000,1) as varchar2(4000))) AS Z1T_OBS, Z1R.*,Z1S.*,Z1T.*,Z1U.* FROM "+RetSqlName("Z1R")+" Z1R "
	_cQuery += "    INNER JOIN "+RetSqlName("Z1S")+" Z1S "
	_cQuery += "        ON Z1S.Z1S_FILIAL = Z1R.Z1R_FILIAL "
	_cQuery += "            AND Z1S.Z1S_COD = Z1R.Z1R_COD "
	_cQuery += "            AND Z1S.Z1S_CLIENT BETWEEN '"+MV_PAR01+" ' AND '"+MV_PAR03+"' "
	_cQuery += "            AND Z1S.Z1S_LOJA BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR04+"' "
	_cQuery += "            AND Z1S.D_E_L_E_T_ = ' ' "
	_cQuery += "    INNER JOIN "+RetSqlName("Z1U")+" Z1U "
	_cQuery += "        ON Z1U.Z1U_FILIAL = Z1R.Z1R_FILIAL "
	_cQuery += "            AND Z1U.Z1U_COD = Z1R.Z1R_COD "
	_cQuery += "            AND Z1U.Z1U_CODVIS = Z1S.Z1S_CODVIS "
	_cQuery += "            AND Z1U.Z1U_CODVIS <> ' ' "
	_cQuery += "            AND Z1U.D_E_L_E_T_ = ' '  "
	_cQuery += "    LEFT JOIN "+RetSqlName("Z1T")+" Z1T "
	_cQuery += "        ON Z1T.Z1T_FILIAL = Z1U.Z1U_FILIAL "
	_cQuery += "            AND Z1T.Z1T_COD = Z1U.Z1U_COD  "
	_cQuery += "            AND Z1T.Z1T_CODVIS = Z1U.Z1U_CODVIS  "
	_cQuery += " 			   AND Z1T.Z1T_ITEM = Z1U.Z1U_ITEM "
	_cQuery += "            AND Z1T.Z1T_DATA BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
	_cQuery += "            AND Z1T.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE Z1R.Z1R_VEND BETWEEN '"+MV_PAR07+" ' AND '"+MV_PAR08+"' "
	_cQuery += " AND Z1R.D_E_L_E_T_ = ' ' "
	_cQuery += " Order by Z1R.Z1R_VEND "
	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	_cQuery := ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	oReport:SetMeter(0)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While !(_cAlias)->(Eof())

		oSection1:Init()
		oSection1:Cell("01"):SetValue((_cAlias)->Z1R_VEND)
		oSection1:Cell("02"):SetValue((_cAlias)->Z1R_NOME)
		oSection1:PrintLine()
		oSection2:Init()
		_cZ1RCOD := (_cAlias)->Z1R_COD

		While !(_cAlias)->(Eof()) .AND. (_cAlias)->Z1R_COD = _cZ1RCOD

			oSection2:Cell("03"):SetValue((_cAlias)->Z1S_CLIENT)
			oSection2:Cell("04"):SetValue((_cAlias)->Z1S_LOJA)
			oSection2:Cell("05"):SetValue((_cAlias)->Z1S_NOME)
			oSection2:Cell("06"):SetValue((_cAlias)->Z1S_CGC)
			oSection2:Cell("07"):SetValue((_cAlias)->Z1S_CONTAT)
			oSection2:Cell("08"):SetValue(Stod((_cAlias)->Z1U_DATA))
			oSection2:Cell("09"):SetValue((_cAlias)->Z1U_HORA)
			oSection2:Cell("10"):SetValue(Stod((_cAlias)->Z1U_DATAIN))
			oSection2:Cell("11"):SetValue((_cAlias)->Z1U_OBS)
			oSection2:Cell("12"):SetValue(Stod((_cAlias)->Z1U_DTPRO))
			oSection2:Cell("13"):SetValue((_cAlias)->Z1U_ORCAME)
			oSection2:Cell("14"):SetValue(Stod((_cAlias)->Z1T_DATA))
			oSection2:Cell("15"):SetValue((_cAlias)->Z1T_HORA)
			oSection2:Cell("16"):SetValue(Stod((_cAlias)->Z1T_DATAIN))
			oSection2:Cell("17"):SetValue((_cAlias)->Z1T_OBS)

			oSection2:PrintLine()

			(_cAlias)->(DbSkip())

		EndDo

		oSection1:Finish()
		oSection2:Finish()
	EndDo
	oSection1:Finish()
	oSection2:Finish()

Return oReport

Static Function ValidPerg()

	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local j
	Local i
	_cPerg         := PADR(_cPerg,10)
//               01    02    03                   04                05                  06       07  08 09 10 11  12 13          14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38
	AADD(_aRegs,{_cPerg, "01", "Do Cliente ?" 	,"Do Cliente ?" 	 ,"Do Cliente ?" 		,"MV_CH1","C",06, 0, 0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegs,{_cPerg, "02", "Da Loja ?" 		,"Da Loja ?"	 	 ,"Da Loja ?"			,"MV_CH2","C",02, 0, 0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "03", "Ate Cliente ?"	,"Ate Cliente ?"	 ,"Ate Cliente ?"		,"MV_CH3","C",06, 0, 0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegs,{_cPerg, "04", "Ate Loja ?"		,"Ate Loja ?"	 	 ,"Ate Loja ?"		,"MV_CH4","C",02, 0, 0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "05", "Da Dt Agenda ?"	,"Da Dt Agenda ?"	 ,"Da Dt Agenda ?"	,"MV_CH5","D",08, 0, 0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "06", "Ate Dt Agenda ?"	,"Ate Dt Agenda ?" ,"Ate Dt Agenda?"	,"MV_CH6","D",08, 0, 0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "07", "Do Vendedor ?"	,"Do Vendedor ?" 	 ,"Do Vendedor ?"		,"MV_CH7","C",06, 0, 0,"G","","mv_par07" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(_aRegs,{_cPerg, "08", "Ate Vendedor ?"	,"Ate Vendedor ?"	 ,"Ate Vendedor ?"	,"MV_CH8","C",06, 0, 0,"G","","mv_par08" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next

	RestArea(_sAlias)

return

Static Function TransformaMemo(Memo)

Local cLinha := ""
Local nX

For nX := 1 to MlCount(Memo,150)
cLinha += Alltrim(MemoLine(Memo,150,nX)) + " "
Next nX


Return cLinha
