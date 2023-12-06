#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} U_STFTR003()

RELATÓRIO FATURAMENTO ACUMULADO POR LINHA

@type function
@author Everson Santana
@since 28/06/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190412000027,

/*/

User Function STFTR003()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STFTR003", Len (SX1->X1_GRUPO))
	//Private _cTipo	 := ""
	//Private _cTipo1	 := ""
	Private _cTitulo := ""

	ValidPerg()


	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

Return
/*
Definição da estrutura do relatório.
*/
Static Function ReportDef()

	_cTitulo := "RELATORIO FATURAMENTO ACUMULADO POR LINHA"

	Pergunte(_cPerg,.f.)

	_oReport := TReport():New(_cPerg,_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "LINHA"		,,"Linha			" ,PesqPict('SX5',"X5_DESCRI")	,TamSX3("X5_DESCRI")[1]	,.F.,)
	TRCell():New( _oSecCab, "VLR_META"	,,"Meta				" ,PesqPict('ZZD',"ZZD_VALOR")	,TamSX3("ZZD_VALOR")[1]	,.F.,)
	TRCell():New( _oSecCab, "ACM_FATU"	,,"Fatumento		" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)
	TRCell():New( _oSecCab, "VLR_FALTA" ,,"Falta			" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)
	TRCell():New( _oSecCab, "PERC_FALTA",,"Percentual 		" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += " SELECT RETFIM.X5_DESCRI, RETFIM.VLR_META,RETFIM.ACM_FATU,RETFIM.VLR_FALTA, ROUND(((RETFIM.VLR_FALTA/RETFIM.VLR_META)*100),2) PERC_FALTA FROM ( "+ CR
	_cQuery += " SELECT RET.X5_DESCRI, RET.VLR_META,RET.ACM_FATU,(RET.ACM_FATU-RET.VLR_META) VLR_FALTA FROM ( " + CR
	_cQuery += " SELECT SA31.A3_SUPER,  " + CR
	_cQuery += " 		SBM.BM_XAGRUP, "+ CR
	_cQuery += " 		SX5.X5_DESCRI, " + CR
	_cQuery += " (SELECT ZZD_VALOR  FROM (  " + CR
	_cQuery += "                             SELECT SA3M.A3_SUPER,SBMM.BM_XAGRUP,SX5M.X5_DESCRI,SUM(ZZD_VALOR) ZZD_VALOR  " + CR
	_cQuery += "                                       FROM "+RetSqlName("ZZD")+" ZZD " + CR
	_cQuery += "                                           INNER JOIN "+RetSqlName("SBM")+" SBMM ON SBMM.BM_FILIAL  = ' ' AND SBMM.BM_GRUPO = ZZD.ZZD_GRUPO AND SBMM.BM_XAGRUP <> ' ' AND SBMM.D_E_L_E_T_ = ' '  " + CR
	_cQuery += "                                           INNER JOIN "+RetSqlName("SA3")+" SA3M ON SA3M.A3_FILIAL = '  ' AND SA3M.A3_COD = ZZD_VEND AND SA3M.D_E_L_E_T_   = ' ' AND SA3M.A3_SUPER = '"+MV_PAR01+"' " + CR
	_cQuery += "                                           INNER JOIN "+RetSqlName("SX5")+" SX5M ON SX5M.X5_FILIAL = ' '  AND SX5M.X5_TABELA = 'ZZ' AND SX5M.X5_CHAVE = SBMM.BM_XAGRUP AND SX5M.D_E_L_E_T_ =  ' ' " + CR
	_cQuery += "                                       WHERE ZZD.ZZD_ANO = '"+MV_PAR02+"' " + CR
//	_cQuery += "                                         AND ZZD.ZZD_MES = '06'  " + CR
	_cQuery += "                                         AND ZZD.D_E_L_E_T_ = ' '  " + CR
	_cQuery += "                                       GROUP BY SA3M.A3_SUPER,SBMM.BM_XAGRUP,SX5M.X5_DESCRI " + CR
	_cQuery += " 						)  META WHERE META.A3_SUPER = SA31.A3_SUPER   AND  META.BM_XAGRUP = SBM.BM_XAGRUP ) VLR_META, " + CR
	_cQuery += "   SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_DIFAL-SD2.D2_ICMSCOM) ACM_FATU " + CR
	_cQuery += " FROM "+RetSqlName("SD2")+" SD2  " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SF2")+" SF2  ON SD2.D2_FILIAL  = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.D_E_L_E_T_ = ' '  " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SB1")+" SB1  ON SB1.B1_FILIAL  = '  ' AND SB1.B1_COD = SD2.D2_COD AND SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = ' '  " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SBM")+" SBM  ON SBM.BM_FILIAL  = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_XAGRUP <> ' ' AND SBM.D_E_L_E_T_ = ' '  " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SA1")+" SA1  ON SA1.A1_FILIAL  = '  ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ' '   " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SA3")+" SA31 ON SA31.A3_FILIAL = '  ' AND SA31.A3_COD = SF2.F2_VEND1 AND SA31.D_E_L_E_T_   = ' ' AND SA31.A3_SUPER = '"+MV_PAR01+"' " + CR
	_cQuery += "   INNER JOIN "+RetSqlName("SX5")+" SX5 ON SX5.X5_FILIAL = ' '  AND SX5.X5_TABELA = 'ZZ' AND SX5.X5_CHAVE = SBM.BM_XAGRUP AND SX5.D_E_L_E_T_ =  ' ' " + CR
	_cQuery += " WHERE SubStr(SF2.F2_EMISSAO,1,4) =  '"+MV_PAR02+"' " + CR
//	_cQuery += "   AND SubStr(SF2.F2_EMISSAO,5,2) =  '06' " + CR
	_cQuery += "   AND SA1.A1_CGC NOT IN ('05890658000130','05890658000210','05890658000300','05890658000482','06048486000114','06048486000114','30708667761')  " + CR
	_cQuery += "   AND SD2.D2_CF IN('5101' , '5102' , '5109' , '5116' , '5117' , '5118' , '5119' , '5122' , '5123' , '5401' , '5403' , '5501' , '5502' , '6101' , '6102' , '6107' , '6108' , '6109' , '6110' , '6111' , '6114' , '6116' , '6117' , '6118' , '6119' , '6122' , '6123' , '6401' , '6403' , '6501' , '6502' , '7101' , '7102')  " + CR
	_cQuery += "   AND SA31.A3_XSEGVEN <> 'IN' " + CR
	_cQuery += "   AND SD2.D_E_L_E_T_ = ' ' " + CR
	_cQuery += " GROUP BY SBM.BM_XAGRUP,SX5.X5_DESCRI,SA31.A3_SUPER " + CR
	_cQuery += " ORDER BY SBM.BM_XAGRUP) RET) RETFIM " + CR

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

			_oSecCab:Init()

			_oSecCab:Cell("LINHA"):SetValue(QRY->X5_DESCRI)
			_oSecCab:Cell("VLR_META"):SetValue(QRY->VLR_META)
			_oSecCab:Cell("ACM_FATU"):SetValue(QRY->ACM_FATU)
			_oSecCab:Cell("VLR_FALTA"):SetValue(QRY->VLR_FALTA)
			_oSecCab:Cell("PERC_FALTA"):SetValue(QRY->PERC_FALTA)

			_oSecCab:PrintLine()

			QRY->(DbSkip())

	EndDo
	_oSecCab:Finish()

Return Nil
/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","Coordenador ?"	,"Coordenador ?"	,"Coordenador ?"	,"mv_ch1","C",06,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ano ?"			,"Ano ?"			,"Ano ? "			,"mv_ch2","C",04,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"03","Mes ?"			,"Mes ?"			,"Mes ?"			,"mv_ch3","C",02,0,0,"C","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"04","Do Vendedor ? "	,"Do Vendedor ? "	,"Do Vendedor ?","mv_ch4","C",06,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"05","Ate Vendedor?"	,"Ate Vendedor?"	,"Ate Vendedor?","mv_ch5","C",06,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


Return