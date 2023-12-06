#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} U_CORFAT10()

Informe de ventas por artículos/vendedor

@type function
@author Everson Santana
@since 01/07/19
@version Protheus 12 - Faturamento

@history ,,

/*/

User Function CORFAT10()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("CORFAT10", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Informe de ventas por articulos/vendedor"

	_oReport := TReport():New("CORFAT10",_cTitulo,,{|_oReport| PrintReport(_oReport)},_cTitulo)
	_oReport:cFontBody := 'Courier New'
	_oReport:nFontBody := 10

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "VENDEDOR"	,,"Vendedor			" ,PesqPict('SF1',"F2_VEND1")	,TamSX3("F2_VEND1")[1]		,.F.,)
	TRCell():New( _oSecCab, "A3_NOME"	,,"Nome				" ,PesqPict('SA3',"A3_NOME")	,TamSX3("A3_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "PEDIDO"	,,"No.Pedido 		" ,PesqPict('SD2',"D2_PEDIDO")	,TamSX3("D2_PEDIDO")[1]	,.F.,)
	TRCell():New( _oSecCab, "CLIENTE"	,,"Cliente			" ,PesqPict('SD2',"D2_CLIENTE")	,TamSX3("D2_CLIENTE")[1]	,.F.,)
	TRCell():New( _oSecCab, "LOJA"  	,,"Loja				" ,PesqPict('SD2',"D2_LOJA")	,TamSX3("D2_LOJA")[1]		,.F.,)
	TRCell():New( _oSecCab, "A1_NOME"  	,,"Nome 			" ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "EMISSAO"	,,"Dt Emissao 		" ,PesqPict('SD2',"D2_EMISSAO")	,TamSX3("D2_EMISSAO")[1]	,.F.,)

	/*/TRCell():New( _oSecCab, "F2_XCOMPNF",,"Id. CONFIAR		" ,PesqPict('SF2',"F2_XCOMPNF")	,TamSX3("F2_XCOMPNF")[1]		,.F.,)/*/
	TRCell():New( _oSecCab, "NOTA"  	,,"Documento		" ,PesqPict('SD2',"D2_DOC")		,TamSX3("D2_DOC")[1]		,.F.,)
	TRCell():New( _oSecCab, "SERIE"  	,,"Serie			" ,PesqPict('SD2',"D2_SERIE")	,TamSX3("D2_SERIE")[1]		,.F.,)

	TRCell():New( _oSecCab, "CODIGO"  	,,"Produto			" ,PesqPict('SC5',"D2_COD")		,TamSX3("D2_COD")[1]		,.F.,)
	TRCell():New( _oSecCab, "DESCRICAO"	,,"Descricion		" ,PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1]		,.F.,)
	TRCell():New( _oSecCab, "GRUPO" 	,,"Grupo			" ,PesqPict('SB1',"B1_GRUPO")	,TamSX3("B1_GRUPO")[1]		,.F.,)
	TRCell():New( _oSecCab, "DESC_GRUPO",,"Descricion		" ,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1]		,.F.,)
	TRCell():New( _oSecCab, "QTDFAT"  	,,"Quantidade 		" ,PesqPict('SD2',"D2_QUANT")	,TamSX3("D2_QUANT")[1]		,.F.,)
	TRCell():New( _oSecCab, "UNITARIO"	,,"Unitario			" ,PesqPict('SD2',"D2_PRCVEN")	,TamSX3("D2_PRCVEN")[1]		,.F.,)
	TRCell():New( _oSecCab, "TOTAL"  	,,"Valor 			" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]		,.F.,)
Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery := " SELECT SF2.F2_VEND1	VENDEDOR,"
	_cQuery += "	SA3.A3_NOME			A3_NOME,"
	_cQuery += "	SD2.D2_CLIENTE		CLIENTE,"
	_cQuery += "	SD2.D2_LOJA			LOJA,"
	_cQuery += "	SA1.A1_NOME			A1_NOME,"
	_cQuery += " 	' ' D1_NFORI,"
	_cQuery += "	' ' D1_SERIORI,"
	_cQuery += "	SD2.D2_PEDIDO		PEDIDO,"
	_cQuery += "	SD2.D2_EMISSAO		EMISSAO,"
/*/	_cQuery += "	SF2.F2_XCOMPNF		F2_XCOMPNF," /*/
	_cQuery += "	SD2.D2_DOC			NOTA,"
	_cQuery += "	SD2.D2_SERIE		SERIE,"
	_cQuery += "	SD2.D2_COD			CODIGO,"
	_cQuery += "	SB1.B1_DESC			DESCRICAO,"
	_cQuery += "	SB1.B1_GRUPO		GRUPO,"
	_cQuery += "	SBM.BM_DESC			DESC_GRUPO,"
	_cQuery += "	SD2.D2_QUANT		QTDFAT,"
	_cQuery += "	SD2.D2_PRCVEN		UNITARIO,"
	_cQuery += "	SD2.D2_TOTAL		TOTAL " + CR
	_cQuery += "                            FROM "+RetSqlName("SD2")+" SD2 " + CR
	_cQuery += "                                INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+") SF4 " + CR
	_cQuery += "                                    ON SF4.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                                    AND F4_CODIGO = D2_TES " + CR
	_cQuery += "                                    AND F4_DUPLIC = 'S' "  + CR
	_cQuery += " 									AND F4_ESTOQUE = 'S' "  + CR
	_cQuery += "                                LEFT JOIN "+RetSqlName("SF2")+" SF2 " + CR
	_cQuery += "                                    ON SF2.F2_FILIAL = SD2.D2_FILIAL " + CR
	_cQuery += "                                    AND SF2.F2_DOC = SD2.D2_DOC " + CR
	_cQuery += "                                    AND SF2.F2_SERIE = SD2.D2_SERIE "  + CR
	_cQuery += "                                    AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " + CR
	_cQuery += "                                    AND SF2.F2_LOJA = SD2.D2_LOJA " + CR
	_cQuery += "                                    AND SF2.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                                LEFT JOIN "+RetSqlName("SA3")+" SA3 " + CR
	_cQuery += "                                    ON SA3.A3_FILIAL = ' ' "  + CR
	_cQuery += "                                    AND SA3.A3_COD = SF2.F2_VEND1 "  + CR
	_cQuery += "                                    AND SA3.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                                LEFT JOIN "+RetSqlName("SA1")+" SA1 " + CR
	_cQuery += "                                   ON SA1.A1_FILIAL =  ' ' " + CR
	_cQuery += "                                   AND SA1.A1_COD = SD2.D2_CLIENTE " + CR
	_cQuery += "                                   AND SA1.A1_LOJA = SD2.D2_LOJA " + CR
	_cQuery += "                                   AND SA1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CR
	_cQuery += "                                  ON SB1.B1_FILIAL = SD2.D2_FILIAL " + CR
	_cQuery += "                                   AND SB1.B1_COD = SD2.D2_COD " + CR
	_cQuery += "                                   AND SB1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SBM")+" SBM " + CR
	_cQuery += "                                  ON SBM.BM_GRUPO = SB1.B1_GRUPO " + CR
	_cQuery += "                                  AND SBM.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                            WHERE SD2.D_E_L_E_T_ = ' ' "  + CR
	_cQuery += "                                AND D2_SERIE <> 'R' " + CR
	_cQuery += "                                AND D2_ESPECIE = 'NF' " + CR
	_cQuery += "                                AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery += "								AND SA1.A1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + CR
	_cQuery += "								AND D2_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'" + CR

	_cQuery += "	 UNION ALL " + CR
	_cQuery += " SELECT  'DEVOLUCAO' 	VENDEDOR,"
	_cQuery += "	SA3.A3_NOME 		A3_NOME,"
	_cQuery += " 	SD1.D1_FORNECE 		CLIENTE,"
	_cQuery += " 	SD1.D1_LOJA 		LOJA,"
	_cQuery += " 	SA1.A1_NOME 		A1_NOME,"
	_cQuery += " 	SD1.D1_NFORI,"
	_cQuery += " 	SD1.D1_SERIORI,"
	_cQuery += " 	' ' 				PEDIDO,"
	_cQuery += "	SD1.D1_DTDIGIT 		EMISSAO,"
/*/_cQuery += "	''					F2_XCOMPNF," /*/
	_cQuery += "	SD1.D1_DOC 			NOTA,"
	_cQuery += "	SD1.D1_SERIE 		SERIE,"
	_cQuery += "	SD1.D1_COD 			CODIGO,"
	_cQuery += "	SB1.B1_DESC 		DESCRICAO,"
	_cQuery += "	SB1.B1_GRUPO 		GRUPO,"
	_cQuery += "	SBM.BM_DESC 		DESC_GRUPO,"
	_cQuery += "	(SD1.D1_QUANT)*-1 	QTDFAT,"
	_cQuery += "	SD1.D1_VUNIT 		UNITARIO,"
	_cQuery += "	(SD1.D1_TOTAL)*-1 	TOTAL " + CR
	_cQuery += "				FROM "+RetSqlName("SD1")+" SD1 " + CR
	_cQuery += "                   INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+" ) SF4 " + CR
	_cQuery += "                                                 ON SF4.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                                                     AND F4_CODIGO = D1_TES " + CR
	_cQuery += "                                                     AND F4_DUPLIC = 'S' " + CR
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
	_cQuery += "                                    AND SA3.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SA1")+" SA1 " + CR
	_cQuery += "                                   	ON SA1.A1_FILIAL =  ' ' " + CR
	_cQuery += "                                   	AND SA1.A1_COD = SD1.D1_FORNECE " + CR
	_cQuery += "                                   	AND SA1.A1_LOJA = SD1.D1_LOJA " + CR
	_cQuery += "                                   	AND SA1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CR
	_cQuery += "                                   ON SB1.B1_FILIAL = SD1.D1_FILIAL " + CR
	_cQuery += "                                   AND SB1.B1_COD = SD1.D1_COD " + CR
	_cQuery += "                                   AND SB1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "                               LEFT JOIN "+RetSqlName("SBM")+" SBM " + CR
	_cQuery += "                                  ON SBM.BM_GRUPO = SB1.B1_GRUPO " + CR
	_cQuery += "                                  AND SBM.D_E_L_E_T_ = ' ' " + CR
	_cQuery += " 				WHERE D1_DTDIGIT  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery += " 					AND D1_CF IN('112') " + CR
	_cQuery += " 					AND D1_TIPO IN('D') " + CR
	_cQuery += " 					AND D1_ESPECIE IN('NCC') " + CR
	_cQuery += " 					AND D1_TP = 'PA' " + CR
	_cQuery += " 					AND SA3.A3_NOME IS NOT NULL " + CR
	_cQuery += " 					AND SD1.D_E_L_E_T_ = ' ' " + CR
	_cQuery += "					AND SA1.A1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + CR
	_cQuery += "					AND D1_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'" + CR

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

			_oSecCab:Cell("VENDEDOR"):SetValue(QRY->VENDEDOR)
			_oSecCab:Cell("A3_NOME"):SetValue(Alltrim(QRY->A3_NOME))
			_oSecCab:Cell("PEDIDO"):SetValue(QRY->PEDIDO)
			_oSecCab:Cell("CLIENTE"):SetValue(Alltrim(QRY->CLIENTE))
			_oSecCab:Cell("LOJA"):SetValue(QRY->LOJA)
			_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
			_oSecCab:Cell("EMISSAO"):SetValue(Stod(QRY->EMISSAO))

/*/			_oSecCab:Cell("F2_XCOMPNF"):SetValue(QRY->F2_XCOMPNF) /*/
			_oSecCab:Cell("NOTA"):SetValue(QRY->NOTA)
			_oSecCab:Cell("SERIE"):SetValue(QRY->SERIE)
			
			_oSecCab:Cell("CODIGO"):SetValue(QRY->CODIGO)
			_oSecCab:Cell("DESCRICAO"):SetValue(QRY->DESCRICAO)
			_oSecCab:Cell("GRUPO"):SetValue(QRY->GRUPO)
			_oSecCab:Cell("DESC_GRUPO"):SetValue(QRY->DESC_GRUPO)
			_oSecCab:Cell("QTDFAT"):SetValue(QRY->QTDFAT)
			_oSecCab:Cell("UNITARIO"):SetValue(QRY->UNITARIO)
			_oSecCab:Cell("TOTAL"):SetValue(QRY->TOTAL)
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
	Local _sAlias 	:= GetArea()
	Local _aRegs  	:= {}
	Local i 		:= 0
	Local j 		:= 0
	_cPerg         	:= PADR(_cPerg,10)

	u_COPutSX1(	_cPerg, "01", 	"Fecha inicio ?",  	"MV_PAR01", "mv_ch1", "D", 08, 0, "G", /*cValid*/, /*cF3*/, /*cPicture*/, "", "", "", "", "", "Informe la fecha del inicio")
	u_COPutSX1(	_cPerg, "02", 	"Fecha hasta?",  	"MV_PAR02", "mv_ch2", "D", 08, 0, "G", /*cValid*/, /*cF3*/,	/*cPicture*/, "", "", "", "", "", "Informe la fecha hasta")
	u_COPutSX1(	_cPerg, "03", 	"Cliente Inicio?", 	"MV_PAR03", "mv_ch3", "C", 06, 0, "G", /*cValid*/, "SA1",	/*cPicture*/, "", "", "", "", "", "Informe cliente del inicio")
	u_COPutSX1(	_cPerg, "04", 	"Cliente Hasta?",  	"MV_PAR04", "mv_ch4", "C", 06, 0, "G", "NaoVazio() .And. MV_PAR04 >= MV_PAR03", "SA1",	/*cPicture*/, "", "", "", "", "", "Informe cliente hasta")
	u_COPutSX1(	_cPerg, "05", 	"Producto Inicio?", "MV_PAR05", "mv_ch5", "C", 15, 0, "G", /*cValid*/, "SB1", /*cPicture*/, "", "", "", "", "", "")
	u_COPutSX1(	_cPerg, "06", 	"Producto Hasta?", 	"MV_PAR06", "mv_ch6", "C", 15, 0, "G", /*cValid*/, "SB1", /*cPicture*/, "", "", "", "", "", "")
Return
