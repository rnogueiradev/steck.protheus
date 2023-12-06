#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} ARRFAT07

Envío de documentos por correo electrónico

@type function
@author Everson Santana
@since 17/12/18
@version Protheus 12 - Faturamento

@history ,Chamado 008135,

/*/

User Function ARRFAT07()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT07", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Envío de documentos por correo electrónico"

	_oReport := TReport():New("ARRFAT07",_cTitulo+" - "+Alltrim(aPergunta[1][1])+" : "+dtoc(MV_PAR01)+" "+Alltrim(aPergunta[2][1])+" : "+dtoc(MV_PAR02),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "CLIENTE"	,,"Cliente			" ,PesqPict('SF2',"F2_CLIENTE")	,TamSX3("F2_CLIENTE")[1]	,.F.,)
	TRCell():New( _oSecCab, "LOJA"		,,"Tienda			" ,PesqPict('SF2',"F2_LOJA")	,TamSX3("F2_LOJA")[1]		,.F.,)
	TRCell():New( _oSecCab, "NOME"		,,"Nombre			" ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]		,.F.,)
	TRCell():New( _oSecCab, "ESPECIE"  	,,"Especie			" ,PesqPict('SF2',"F2_ESPECIE")	,TamSX3("F2_ESPECIE")[1]	,.F.,)
	TRCell():New( _oSecCab, "SERIE"  	,,"Serie			" ,PesqPict('SF2',"F2_SERIE")	,TamSX3("F2_SERIE")[1]		,.F.,)
	TRCell():New( _oSecCab, "DOC"  		,,"Documento 		" ,PesqPict('SF2',"F2_DOC")		,TamSX3("F2_DOC")[1]		,.F.,)
	TRCell():New( _oSecCab, "REMITO" 	,,"Remito 			" ,PesqPict('SF2',"F2_XREMITO")	,TamSX3("F2_XREMITO")[1]		,.F.,)
	TRCell():New( _oSecCab, "EMISSAO"  	,,"Dt Emisión 		" ,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]	,.F.,)
	TRCell():New( _oSecCab, "DTENV"  	,,"Dt Envio			" ,PesqPict('SF2',"F2_XDTENV")	,TamSX3("F2_XDTENV")[1]		,.F.,)
	TRCell():New( _oSecCab, "HRENV"  	,,"Hr Envio			" ,PesqPict('SF2',"F2_XHRENV")	,TamSX3("F2_XHRENV")[1]		,.F.,)
	TRCell():New( _oSecCab, "ENVLOG"  	,,"Registro de envío" ,PesqPict('SF2',"F2_ENVLOG")	,TamSX3("F2_ENVLOG")[1]		,.F.,)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += " SELECT F2_CLIENTE ,F2_LOJA,A1_NOME ,F2_ESPECIE ,F2_SERIE ,F2_DOC,F2_XREMITO ,F2_EMISSAO ,F2_XDTENV,F2_XHRENV,F2_ENVLOG " 
	_cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1 "
	_cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+ "' "
	_cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE F2_SERIE <> 'R' "
	_cQuery += "     AND F2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'  "
	_cQuery += "     AND SF2.D_E_L_E_T_ = ' ' "
	_cQuery += " UNION "
	_cQuery += " SELECT F1_FORNECE,F1_LOJA,A2_NOME,F1_ESPECIE,F1_SERIE,F1_DOC,' ' F2_XREMITO,F1_EMISSAO,F1_XDTENV,F1_XHRENV,F1_ENVLOG    "
	_cQuery += " FROM "+RetSqlName("SF1")+" SF1 "
	_cQuery += " LEFT JOIN "+RetSqlName("SA2")+" SA2 "
	_cQuery += " ON SA2.A2_FILIAL = '"+xFilial("SA2")+ "' "
	_cQuery += " AND SA2.A2_COD = SF1.F1_FORNECE "
	_cQuery += " AND SA2.A2_LOJA = SF1.F1_LOJA "
	_cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE F1_SERIE <> 'R' "
	_cQuery += "     AND F1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	_cQuery += "     AND F1_FORMUL = 'S' "
	_cQuery += "     AND F1_TIPO IN('D','B') "
	_cQuery += "     AND SF1.D_E_L_E_T_ = ' ' "

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
			_oSecCab:Cell("ESPECIE"):SetValue(QRY->F2_ESPECIE)
			_oSecCab:Cell("SERIE"):SetValue(QRY->F2_SERIE)
			_oSecCab:Cell("DOC"):SetValue(QRY->F2_DOC)
			_oSecCab:Cell("REMITO"):SetValue(QRY->F2_XREMITO)
			_oSecCab:Cell("EMISSAO"):SetValue(QRY->F2_EMISSAO)
			_oSecCab:Cell("DTENV"):SetValue(QRY->F2_XDTENV)
			_oSecCab:Cell("HRENV"):SetValue(QRY->F2_XHRENV)

			If Empty(QRY->F2_ENVLOG)
				_oSecCab:Cell("ENVLOG"):SetValue("Compruebe los registros de correo electrónico")
			Else
				_oSecCab:Cell("ENVLOG"):SetValue(Alltrim(QRY->F2_ENVLOG))
			EndIf

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
	//	AADD(_aRegs,{_cPerg,"03","Tipo ?"	,"Tipo ? "	,"Tipo ?  "	,"mv_ch3","N",01,0,0,"C","          ","mv_par03","Articulo","Articulo","Articulo","","","Grupo","Grupo","Grupo","","","","","","","","","","","","","","","","","",""})
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