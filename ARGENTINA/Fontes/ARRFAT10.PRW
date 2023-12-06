#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} U_ARRFAT10()

Informe de ventas por artículos/vendedor

@type function
@author Everson Santana
@since 01/07/19
@version Protheus 12 - Faturamento

@history ,,

/*/

User Function ARRFAT10()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT10", Len (SX1->X1_GRUPO))
	//Private _cTipo	 := ""
	//Private _cTipo1	 := ""
	Private _cTitulo := ""

	ValidPerg()

	Pergunte(_cPerg,.T.)

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

	_cTitulo := "Informe de ventas por Articulos/vendedor"

	_oReport := TReport():New("ARRFAT10",_cTitulo,,{|_oReport| PrintReport(_oReport)},_cTitulo)
	_oReport:cFontBody := 'Courier New'
	_oReport:nFontBody := 10

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "F2_VEND1"	,,"Vendedor			" ,PesqPict('SF1',"F2_VEND1")	,TamSX3("F2_VEND1")[1]		,.F.,)
	TRCell():New( _oSecCab, "A3_NOME"	,,"Nome				" ,PesqPict('SA3',"A3_NOME")	,TamSX3("A3_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_CLIENTE",,"Cliente			" ,PesqPict('SD2',"D2_CLIENTE")	,TamSX3("D2_CLIENTE")[1]	,.F.,)
	TRCell():New( _oSecCab, "D2_LOJA"  	,,"Loja				" ,PesqPict('SD2',"D2_LOJA")	,TamSX3("D2_LOJA")[1]		,.F.,)
	TRCell():New( _oSecCab, "A1_NOME"  	,,"NOme 			" ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_EMISSAO",,"Dt Emissao 		" ,PesqPict('SD2',"D2_EMISSAO")	,TamSX3("D2_EMISSAO")[1]	,.F.,)
	TRCell():New( _oSecCab, "D2_SERIE"  ,,"Serie			" ,PesqPict('SD2',"D2_SERIE")	,TamSX3("D2_SERIE")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_DOC"  	,,"Documento		" ,PesqPict('SD2',"D2_DOC")		,TamSX3("D2_DOC")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_COD"  	,,"Produto			" ,PesqPict('SC5',"D2_COD")		,TamSX3("D2_COD")[1]		,.F.,)
	TRCell():New( _oSecCab, "B1_DESC"  	,,"Descricao		" ,PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1]		,.F.,)
	TRCell():New( _oSecCab, "B1_GRUPO" 	,,"Grupo			" ,PesqPict('SB1',"B1_GRUPO")	,TamSX3("B1_GRUPO")[1]		,.F.,)
	TRCell():New( _oSecCab, "BM_DESC"  	,,"Descricao		" ,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1]		,.F.,)

	TRCell():New( _oSecCab, "B1_XDERUB" ,,"Desc. Rubro"		  ,PesqPict('SB1',"B1_XDERUB")	,TamSX3("B1_XDERUB")[1]	,.F.,)
	TRCell():New( _oSecCab, "B1_XDSRUB" ,,"Desc. SubRubro"    ,PesqPict('SB1',"B1_XDSRUB")	,TamSX3("B1_XDSRUB")[1]	,.F.,)

	TRCell():New( _oSecCab, "D2_QUANT"  ,,"Quantidade 		" ,PesqPict('SD2',"D2_QUANT")	,TamSX3("D2_QUANT")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_PRCVEN"	,,"Unitario			" ,PesqPict('SD2',"D2_PRCVEN")	,TamSX3("D2_PRCVEN")[1]		,.F.,)
	TRCell():New( _oSecCab, "D2_TOTAL"  ,,"Valor 			" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]		,.F.,)
	TRCell():New( _oSecCab, "A1_XGRPCOM" ,,"Gr. Compras 	" ,PesqPict('SA1',"A1_XGRPCOM")	,TamSX3("A1_XGRPCOM")[1]		,.F.,)

	TRCell():New( _oSecCab, "C5_XORPC" ,,"Ordem Compras 	" ,PesqPict('SC5',"C5_XORPC")	,TamSX3("C5_XORPC")[1]		,.F.,)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery := " SELECT SF2.F2_VEND1,SA3.A3_NOME,SD2.D2_CLIENTE, ' ' D1_NFORI, ' ' D1_SERIORI ,SD2.D2_LOJA ,SA1.A1_NOME,SA1.A1_XGRPCOM ,SD2.D2_EMISSAO ,SD2.D2_SERIE , SD2.D2_DOC , SD2.D2_COD ,SB1.B1_DESC ,SB1.B1_GRUPO , SBM.BM_DESC," 
	_cQuery += "    B1_XDERUB, B1_XDSRUB, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SF2.F2_MOEDA MOEDA, SF2.F2_TXMOEDA TXMOEDA, SC5.C5_XORPC C5_XORPC " + CR
	_cQuery += "                            FROM "+RetSqlName("SD2")+" SD2 " + CR
	_cQuery += "                                INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+") SF4 " + CR
	_cQuery += "                                    ON F4_CODIGO = D2_TES " + CR
	_cQuery += "                                    AND F4_DUPLIC = 'S' "  + CR
	_cQuery += " 									AND F4_ESTOQUE = 'S' "  + CR
	_cQuery += " 									AND SF4.D_E_L_E_T_ = ' ' "  + CR
	_cQuery += "                                LEFT JOIN "+RetSqlName("SF2")+" SF2 " + CR
	_cQuery += "                                    ON SF2.F2_FILIAL = SD2.D2_FILIAL " + CR
	_cQuery += "                                    AND SF2.F2_DOC = SD2.D2_DOC " + CR
	_cQuery += "                                    AND SF2.F2_SERIE = SD2.D2_SERIE "  + CR
	_cQuery += "                                    AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " + CR
	_cQuery += "                                    AND SF2.F2_LOJA = SD2.D2_LOJA " + CR
	_cQuery += "                                    AND SF2.D_E_L_E_T_ = ' ' " + CR

	_cQuery += "                                LEFT JOIN "+RetSqlName("SC5")+" SC5 " + CR
	_cQuery += "                                    ON SC5.C5_FILIAL = SD2.D2_FILIAL " + CR
	_cQuery += "                                    AND SC5.C5_CLIENTE = SD2.D2_CLIENTE " + CR
	_cQuery += "                                    AND SC5.C5_LOJACLI = SD2.D2_LOJA " + CR
	_cQuery += "                                    AND SC5.C5_NUM = SD2.D2_PEDIDO " + CR
	_cQuery += "                                    AND SC5.D_E_L_E_T_ = ' ' " + CR

	_cQuery += "                                LEFT JOIN "+RetSqlName("SA3")+" SA3 " + CR
	_cQuery += "                                    ON SA3.A3_FILIAL = ' ' "  + CR
	_cQuery += "                                    AND SA3.A3_COD = SF2.F2_VEND1 "  + CR
	_cQuery += "                                    AND SA3.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                                LEFT JOIN "+RetSqlName("SA1")+" SA1 " + CR
	_cQuery += "                                   ON SA1.A1_FILIAL =  ' ' " + CR
	_cQuery += "                                   AND SA1.A1_COD = SD2.D2_CLIENTE " + CR
	_cQuery += "                                   AND SA1.A1_LOJA = SD2.D2_LOJA " + CR
	_cQuery += "								   AND SA1.A1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + CR
	_cQuery += "                                   AND SA1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CR
	_cQuery += "                                  ON SB1.B1_FILIAL = SD2.D2_FILIAL " + CR
	_cQuery += "                                   AND SB1.B1_COD = SD2.D2_COD " + CR
	_cQuery += "                                   AND SB1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SBM")+" SBM " + CR
	_cQuery += "                                  ON SBM.BM_GRUPO = SB1.B1_GRUPO " + CR
	_cQuery += "                                  AND SBM.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                            WHERE D2_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'" + CR
	_cQuery += "                                AND D2_ESPECIE = 'NF' " + CR
	_cQuery += "                                AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery += "								AND D2_SERIE <> 'R' " + CR
	_cQuery += "                                AND SD2.D_E_L_E_T_ = ' ' " + CR

	_cQuery += "	 UNION ALL " + CR
	_cQuery += " 			SELECT  'DEVOLUCAO' VENDEDOR,SA3.A3_NOME A3_NOME,SD1.D1_FORNECE CLIENTE,SD1.D1_NFORI, SD1.D1_SERIORI,SD1.D1_LOJA LOJA,SA1.A1_NOME NOME,SA1.A1_XGRPCOM GRPCOM,SD1.D1_DTDIGIT EMISSAO,SD1.D1_SERIE SERIE, SD1.D1_DOC NOTA, SD1.D1_COD CODIGO,SB1.B1_DESC DESCRICAO,SB1.B1_GRUPO GRUPO, SBM.BM_DESC DESC_GRUPO,"
	_cQuery += "			B1_XDERUB, B1_XDSRUB, (SD1.D1_QUANT)*-1 QTDFAT, SD1.D1_VUNIT D1_VUNIT, (SD1.D1_TOTAL)*-1 AS VLRFAT, 0 MOEDA, 0 TXMOEDA,  '  ' C5_XORPC " + CR
	_cQuery += "				FROM "+RetSqlName("SD1")+" SD1 " + CR
	_cQuery += "                   INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+" ) SF4 " + CR
	_cQuery += "                                                 ON F4_CODIGO = D1_TES " + CR
	_cQuery += "                                                     AND F4_DUPLIC = 'S' " + CR
	_cQuery += "                                                     AND SF4.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SF2")+" SF2 " + CR
	_cQuery += "                                    ON SF2.F2_FILIAL = SD1.D1_FILIAL " + CR
	_cQuery += "                                    AND SF2.F2_DOC = SD1.D1_NFORI " + CR
	_cQuery += "                                    AND SF2.F2_SERIE = SD1.D1_SERIORI " + CR
	_cQuery += "                                    AND SF2.F2_CLIENTE = SD1.D1_FORNECE " + CR
	_cQuery += "                                    AND SF2.F2_LOJA = SD1.D1_LOJA " + CR
	_cQuery += "                                    AND SF2.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SA3")+" SA3 " + CR
	_cQuery += "                                    ON SA3.A3_FILIAL = ' ' " + CR
	_cQuery += "                                    AND SA3.A3_COD = SF2.F2_VEND1 " + CR
	_cQuery += " 									AND SA3.A3_NOME IS NOT NULL " + CR
	_cQuery += "                                    AND SA3.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SA1")+" SA1 " + CR
	_cQuery += "                                   	ON SA1.A1_FILIAL =  ' ' " + CR
	_cQuery += "                                   	AND SA1.A1_COD = SD1.D1_FORNECE " + CR
	_cQuery += "                                   	AND SA1.A1_LOJA = SD1.D1_LOJA " + CR
	_cQuery += "									AND SA1.A1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + CR
	_cQuery += "                                   	AND SA1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CR
	_cQuery += "                                   ON SB1.B1_FILIAL = SD1.D1_FILIAL " + CR
	_cQuery += "                                   AND SB1.B1_COD = SD1.D1_COD " + CR
	_cQuery += "                                   AND SB1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SBM")+" SBM " + CR
	_cQuery += "                                  ON SBM.BM_GRUPO = SB1.B1_GRUPO " + CR
	_cQuery += "                                  AND SBM.D_E_L_E_T_ = ' ' " + CR
	_cQuery += " 				WHERE D1_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'" + CR
	_cQuery += " 					AND D1_CF IN('112') " + CR
	_cQuery += " 					AND D1_TES <> '043' " + CR // Conforme solicitado por debora n�o considerar SellOut - 20230713008876 
	_cQuery += " 					AND D1_TIPO IN('D') " + CR
	_cQuery += " 					AND D1_ESPECIE IN('NCC') " + CR
	_cQuery += " 					AND D1_TP = 'PA' " + CR
	_cQuery += "					AND D1_DTDIGIT  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery += " 					AND SD1.D_E_L_E_T_ = ' ' " + CR

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		While !QRY->(Eof())

			_oSecCab:Init()
			_oSecCab:Cell("F2_VEND1"):SetValue(QRY->F2_VEND1)
			_oSecCab:Cell("A3_NOME"):SetValue(Alltrim(QRY->A3_NOME))
			_oSecCab:Cell("D2_CLIENTE"):SetValue(Alltrim(QRY->D2_CLIENTE))
			_oSecCab:Cell("D2_LOJA"):SetValue(QRY->D2_LOJA)
			_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
			_oSecCab:Cell("D2_EMISSAO"):SetValue(Stod(QRY->D2_EMISSAO))
			_oSecCab:Cell("D2_SERIE"):SetValue(QRY->D2_SERIE)
			_oSecCab:Cell("D2_DOC"):SetValue(QRY->D2_DOC)
			_oSecCab:Cell("D2_COD"):SetValue(QRY->D2_COD)
			_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
			_oSecCab:Cell("B1_GRUPO"):SetValue(QRY->B1_GRUPO)
			_oSecCab:Cell("BM_DESC"):SetValue(QRY->BM_DESC)
			_oSecCab:Cell("B1_XDERUB"):SetValue(QRY->B1_XDERUB)
			_oSecCab:Cell("B1_XDSRUB"):SetValue(QRY->B1_XDSRUB)
			_oSecCab:Cell("D2_QUANT"):SetValue(QRY->D2_QUANT)
			
			_nPreco := QRY->D2_PRCVEN
			_nTotal := QRY->D2_TOTAL
			If QRY->MOEDA==2
				_nPreco := QRY->D2_PRCVEN*QRY->TXMOEDA
				_nTotal := QRY->D2_TOTAL*QRY->TXMOEDA
			EndIf
			
			_oSecCab:Cell("D2_PRCVEN"):SetValue(_nPreco)
			_oSecCab:Cell("D2_TOTAL"):SetValue(_nTotal)
			_oSecCab:Cell("A1_XGRPCOM"):SetValue(QRY->A1_XGRPCOM)
			_oSecCab:Cell("C5_XORPC"):SetValue(QRY->C5_XORPC)

			_oSecCab:PrintLine()

			QRY->(DbSkip())

		EndDo
		_oReport:ThinLine()

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

	u_ARPutSX1(	_cPerg, "01", 	"Fecha inicio ?",  	"MV_PAR01", "mv_ch1", "D", 08, 0, "G", /*cValid*/, /*cF3*/, /*cPicture*/, "", "", "", "", "", "Informe la fecha del inicio")
	u_ARPutSX1(	_cPerg, "02", 	"Fecha hasta?",  	"MV_PAR02", "mv_ch2", "D", 08, 0, "G", /*cValid*/, /*cF3*/,	/*cPicture*/, "", "", "", "", "", "Informe la fecha hasta")
	u_ARPutSX1(	_cPerg, "03", 	"Cliente Inicio?", 	"MV_PAR03", "mv_ch3", "C", 06, 0, "G", /*cValid*/, "SA1",	/*cPicture*/, "", "", "", "", "", "Informe cliente del inicio")
	u_ARPutSX1(	_cPerg, "04", 	"Cliente Hasta?",  	"MV_PAR04", "mv_ch4", "C", 06, 0, "G", "NaoVazio() .And. MV_PAR04 >= MV_PAR03", "SA1",	/*cPicture*/, "", "", "", "", "", "Informe cliente hasta")
	u_ARPutSX1(	_cPerg, "05", 	"Producto Inicio?", "MV_PAR05", "mv_ch5", "C", 15, 0, "G", /*cValid*/, "SB1", /*cPicture*/, "", "", "", "", "", "")
	u_ARPutSX1(	_cPerg, "06", 	"Producto Hasta?", 	"MV_PAR06", "mv_ch6", "C", 15, 0, "G", /*cValid*/, "SB1", /*cPicture*/, "", "", "", "", "", "")

/*
	AADD(_aRegs,{_cPerg, "01", "Fecha inicio ?",	"Fecha inicio ?",	"Fecha inicio ? ",	"mv_ch1","D",08,0,0, 	"G","", "",		"","","mv_par01","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "02", "Fecha final ?",		"Fecha final ?",	"Fecha final ? ",	"mv_ch2","D",08,0,0, 	"G","", "",		"","","mv_par02","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "03", "Do Cliente?	 ",		"Do Cliente? ",		"Do Cliente?",		"mv_ch3","C",06,0,0, 	"G","", "SA1",	"","","mv_par03","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "04", "Ate Cliente?",		"Ate Cliente? ",	"Ate Cliente?",		"mv_ch4","C",06,0,0, 	"G","", "SA1",	"","","mv_par04","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "02", "Ate Vendedor ?",	"Ate Vendedor ?",	"Ate Vendedor ?",	"mv_ch2","C",06,0,0,	"G","",	"SA3",	"","","mv_par02","","","","","","","","","","","","","","","",""})

	//AADD(_aRegs,{_cPerg,"03","Serie ?"			,"Serie ? "			,"Serie ?  "		,"mv_ch3","C",03,0,0,"C","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
*/



Return
