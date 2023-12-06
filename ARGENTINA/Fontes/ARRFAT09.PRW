#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} U_ARRFAT09()

Informe de Remitos/Factura

@type function
@author Everson Santana
@since 25/06/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190624000060,

/*/

User Function ARRFAT09()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT09", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Informe de Remitos/Factura"

	_oReport := TReport():New("ARRFAT09",_cTitulo+" - "+Alltrim(aPergunta[1][1])+" : "+dtoc(MV_PAR01)+" "+Alltrim(aPergunta[1][1])+" : "+dtoc(MV_PAR01),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "CLIENTE"	,,"Cliente			" ,PesqPict('SF2',"F2_CLIENTE")	,TamSX3("F2_CLIENTE")[1]	,.F.,)
	TRCell():New( _oSecCab, "LOJA"		,,"Tienda			" ,PesqPict('SF2',"F2_LOJA")	,TamSX3("F2_LOJA")[1]		,.F.,)
	TRCell():New( _oSecCab, "NOME"		,,"Nombre			" ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "SERIE"  	,,"Serie			" ,PesqPict('SF2',"F2_SERIE")	,TamSX3("F2_SERIE")[1]		,.F.,)
	TRCell():New( _oSecCab, "DOC"  		,,"Documento 		" ,PesqPict('SF2',"F2_DOC")		,TamSX3("F2_DOC")[1]		,.F.,)
	TRCell():New( _oSecCab, "EMISSAO"  	,,"Dt Emisión 		" ,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]	,.F.,)
	TRCell():New( _oSecCab, "HORA"  	,,"Hr Emisión		" ,"99:99:99"					,08							,.F.,)
	TRCell():New( _oSecCab, "PEDIDO"  	,,"Pedido			" ,PesqPict('SD2',"D2_PEDIDO")	,TamSX3("D2_PEDIDO")[1]		,.F.,)
	TRCell():New( _oSecCab, "EMIPEDI"  	,,"Dt Pedido		" ,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]	,.F.,)
	TRCell():New( _oSecCab, "HRPEDI"  	,,"Hr Pedido		" ,PesqPict('SC5',"C5_XHRINC")	,TamSX3("C5_XHRINC")[1]		,.F.,)
	TRCell():New( _oSecCab, "ORDENSP"  	,,"Orden Separación " ,PesqPict('SF2',"F2_XORDSEP")	,TamSX3("F2_XORDSEP")[1]	,.F.,)
	TRCell():New( _oSecCab, "VLRBRUT"  	,,"Valor 			" ,PesqPict('SF2',"F2_VALBRUT")	,TamSX3("F2_VALBRUT")[1]	,.F.,)
	
	TRCell():New( _oSecCab, "SERIEFAT"  	,,"Serie Factura			" ,PesqPict('SF2',"F2_SERIE")	,TamSX3("F2_SERIE")[1]		,.F.,)
	TRCell():New( _oSecCab, "DOCFAT"  		,,"Documento Factura 		" ,PesqPict('SF2',"F2_DOC")		,TamSX3("F2_DOC")[1]		,.F.,)
	TRCell():New( _oSecCab, "EMISSAOFAT"  	,,"Dt Emisión Factura 		" ,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]	,.F.,)
	TRCell():New( _oSecCab, "HORAFAT"  		,,"Hr Emisión Factura		" ,"99:99:99"					,08							,.F.,)
	TRCell():New( _oSecCab, "VLRBRUTFAT"  	,,"Valor Factura 			" ,PesqPict('SF2',"F2_VALBRUT")	,TamSX3("F2_VALBRUT")[1]	,.F.,)
	TRCell():New( _oSecCab, "MOED"  		,,"Tipo de Cambio 			" ,PesqPict('SF2',"F2_TXMOEDA")	,TamSX3("F2_TXMOEDA")[1]	,.F.,)
	
Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += " SELECT SF2.F2_CLIENTE ,SF2.F2_LOJA,A1_NOME ,SF2.F2_SERIE ,SF2.F2_DOC,SF2.F2_EMISSAO,SF2.F2_HORA||':00' F2_HORA,SD2.D2_PEDIDO,SC5.C5_XHRINC,SF2.F2_XORDSEP,SF2.F2_VALBRUT,C5_EMISSAO  "
	_cQuery += " ,F2FAT.F2_SERIE F2_SERIEFAT,F2FAT.F2_DOC F2_DOCFAT,F2FAT.F2_EMISSAO F2_EMISSAOFAT,F2FAT.F2_HORA||':00' F2_HORAFAT,F2FAT.F2_VALBRUT F2_VALBRUTFAT,F2FAT.F2_TXMOEDA F2_MOEDAFAT " 
	_cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1 "
	_cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+ "' "
	_cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "

	_cQuery += " LEFT JOIN "+RetSqlName("SD2")+" SD2 "
	_cQuery += " ON SD2.D2_FILIAL = SF2.F2_FILIAL "
	_cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
	_cQuery += " AND SD2.D2_LOJA = SF2.F2_LOJA "
	_cQuery += " AND SD2.D2_DOC = SF2.F2_DOC "
	_cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE "
	_cQuery += " AND SD2.D_E_L_E_T_ = ' ' "

	_cQuery += " LEFT JOIN "+RetSqlName("SC5")+" SC5"
	_cQuery += " ON SC5.C5_FILIAL = SF2.F2_FILIAL "
	_cQuery += " AND SC5.C5_NUM = SD2.D2_PEDIDO "
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "

	_cQuery += " LEFT JOIN "+RetSqlName("SF2")+" F2FAT "
	_cQuery += " ON SF2.F2_FILIAL = F2FAT.F2_FILIAL "
	_cQuery += " AND SF2.F2_DOC = F2FAT.F2_XREMITO "
	_cQuery += " AND F2FAT.D_E_L_E_T_ = ' ' "


	_cQuery += " WHERE SF2.F2_SERIE IN ('R') "
	_cQuery += "     AND SF2.F2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'  "
	_cQuery += "     AND SF2.D_E_L_E_T_ = ' ' "
	_cQuery += " GROUP BY SF2.F2_CLIENTE ,SF2.F2_LOJA,A1_NOME ,SF2.F2_SERIE ,SF2.F2_DOC,SF2.F2_EMISSAO,SF2.F2_HORA,SD2.D2_PEDIDO,C5_XHRINC,SF2.F2_XORDSEP,SF2.F2_VALBRUT,C5_EMISSAO "
	_cQuery += " ,F2FAT.F2_SERIE,F2FAT.F2_DOC,F2FAT.F2_EMISSAO,F2FAT.F2_HORA,F2FAT.F2_VALBRUT,F2FAT.F2_TXMOEDA " 

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

			_oSecCab:Cell("CLIENTE"):SetValue(QRY->F2_CLIENTE)
			_oSecCab:Cell("LOJA"):SetValue(Alltrim(QRY->F2_LOJA))
			_oSecCab:Cell("NOME"):SetValue(Alltrim(QRY->A1_NOME))
			_oSecCab:Cell("SERIE"):SetValue(QRY->F2_SERIE)
			_oSecCab:Cell("DOC"):SetValue(QRY->F2_DOC)
			_oSecCab:Cell("EMISSAO"):SetValue(Stod(QRY->F2_EMISSAO))
			_oSecCab:Cell("HORA"):SetValue(QRY->F2_HORA)
			_oSecCab:Cell("PEDIDO"):SetValue(QRY->D2_PEDIDO)
			_oSecCab:Cell("EMIPEDI"):SetValue(Stod(QRY->C5_EMISSAO))
			_oSecCab:Cell("HRPEDI"):SetValue(QRY->C5_XHRINC)
			_oSecCab:Cell("ORDENSP"):SetValue(QRY->F2_XORDSEP)
			_oSecCab:Cell("VLRBRUT"):SetValue(QRY->F2_VALBRUT)
			
			_oSecCab:Cell("SERIEFAT"):SetValue(QRY->F2_SERIEFAT)
			_oSecCab:Cell("DOCFAT"):SetValue(QRY->F2_DOCFAT)
			_oSecCab:Cell("EMISSAOFAT"):SetValue(Stod(QRY->F2_EMISSAOFAT))
			_oSecCab:Cell("HORAFAT"):SetValue(QRY->F2_HORAFAT)
			_oSecCab:Cell("VLRBRUTFAT"):SetValue(QRY->F2_VALBRUTFAT)
			_oSecCab:Cell("MOED"):SetValue(QRY->F2_MOEDAFAT)
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
	AADD(_aRegs,{_cPerg,"01","Fecha inicio ?"	,"Fecha inicio ?"	,"Fecha inicio ? "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Fecha final ?"	,"Fecha final ?"	,"Fecha final ? "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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


Return