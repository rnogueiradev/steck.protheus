#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} CORFAT01

Detalle de Pedidos

@type function
@author Everson Santana
@since 14/08/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function CORFAT01()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("CORFAT01", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
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
DefiniÃ§Ã£o da estrutura do relatÃ³rio.
*/
Static Function ReportDef()

	If MV_PAR01 == 1
		_cTitulo := "Detalle de Pedidos"
	Else
		_cTitulo := "Listado de Pedidos"
	EndIF

	If MV_PAR08 = 1
		_cTipo := "En Abierto"
	ElseIf MV_PAR08 = 2
		_cTipo := "Cerrados"
	Else
		_cTipo := "Ambos"
	EndIf

	_oReport := TReport():New("CORFAT01",_cTitulo+" - "+Alltrim(aPergunta[4][1])+" : "+dtoc(MV_PAR04)+" "+Alltrim(aPergunta[5][1])+" : "+dtoc(MV_PAR05),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo+" "+_cTipo)
	_oReport:cFontBody := 'Courier New'
	_oReport:nFontBody := 10

	If MV_PAR01 == 1

		_oSecCab := TRSection():New( _oReport , "Detalle de Pedidos", {"QRY"} )

		TRCell():New( _oSecCab, "C5_EMISSAO"	,,"Fecha 		   ",			PesqPict('SC5',"C5_EMISSAO"),	TamSX3("C5_EMISSAO")[1],.F.,)
		TRCell():New( _oSecCab, "C5_CLIENTE"	,,"Cliente 		   ",			PesqPict('SC5',"C5_CLIENTE"),	TamSX3("C5_CLIENTE")[1],.F.,)
		TRCell():New( _oSecCab, "C5_LOJACLI"	,,"Loja			   ",			PesqPict('SC5',"C5_LOJACLI"),	TamSX3("C5_LOJACLI")[1],.F.,)
		TRCell():New( _oSecCab, "A1_NOME"  		,,"Nombre          ",			PesqPict('SA1',"A1_NOME"),		TamSX3("A1_NOME")[1]	,.F.,)

		TRCell():New( _oSecCab, "C5_NUM"    	,,"Pedido          ",			PesqPict('SC5',"C5_NUM"),		TamSX3("C5_NUM")[1],.F.,)
		TRCell():New( _oSecCab, "C5_XTPED"    	,,"Tipo            ",			PesqPict('SC5',"C5_XTPED"),		TamSX3("C5_XTPED")[1],.F.,)

		TRCell():New( _oSecCab, "C6_ITEM"   	,,"Item            ",			PesqPict('SC6',"C6_ITEM"),		TamSX3("C6_ITEM")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_PRODUTO"   	,,"Producto        ",			PesqPict('SC6',"C6_PRODUTO"),	TamSX3("C6_PRODUTO")[1]	,.F.,)
		TRCell():New( _oSecCab, "B1_DESC"   	,,"Descripcion     ",			PesqPict('SB1',"B1_DESC"),		20/*TamSX3("B1_DESC")[1]*/	,.T.,)
		TRCell():New( _oSecCab, "C6_QTDVEN"   	,,"Cantidad        ",			PesqPict('SC6',"C6_QTDVEN"),	TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_PRCVEN"   	,,"Vlr Unitario    ",			PesqPict('SC6',"C6_PRCVEN"),	TamSX3("C6_PRCVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_VALOR"   	,,"Total     	   ",			PesqPict('SC6',"C6_VALOR"),		TamSX3("C6_VALOR")[1]	,.F.,)

		TRCell():New( _oSecCab, "MOEDA"   		,,"Moneda     	   ",			"@!",							3					,.F.,)
		TRCell():New( _oSecCab, "C5_TXMOEDA"   	,,"Valor moneda	   ",			PesqPict('SC5',"C5_TXMOEDA"),	TamSX3("C5_TXMOEDA")[1]	,.F.,)

		TRCell():New( _oSecCab, "C6_QTDENT"		,,"Entegue         ",			PesqPict('SC6',"C6_QTDENT"),	TamSX3("C6_QTDENT")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_QTDEMP"    	,,"Pendiente       ",			PesqPict('SC6',"C6_QTDEMP"),	TamSX3("C6_QTDEMP")[1]	,.F.,)
		TRCell():New( _oSecCab, "B2_QATU"     	,,"Stock 01        ",			PesqPict('SB2',"B2_QATU"),		TamSX3("B2_QATU")[1]	,.F.,)
		TRCell():New( _oSecCab, "B2_QATU2"     	,,"Stock 02        ",			PesqPict('SB2',"B2_QATU"),		TamSX3("B2_QATU")[1]	,.F.,)
		TRCell():New( _oSecCab, "B2_QATU3"     	,,"Stock 03        ",			PesqPict('SB2',"B2_QATU"),		TamSX3("B2_QATU")[1]	,.F.,)
		TRCell():New( _oSecCab, "B2_SALPEDI"   	,,"Prev.Entrada    ",			PesqPict('SB2',"B2_SALPEDI"),	TamSX3("B2_SALPEDI")[1],.F.,)

		TRCell():New( _oSecCab, "C5_XORDEM" 	,,"Orden de Compra ",			"@!"	,2000	,.F.,)
		TRCell():New( _oSecCab, "C5_XOBS" 		,,"Observaciones   ",			"@!"	,2000	,.F.,)

		If MV_PAR08 = 2 .oR. MV_PAR08 = 3 //Faturado
			TRCell():New( _oSecCab, "F2_XCOMPNF",,	"Id. CONFIAR",				"@!", 	TamSX3("F2_XCOMPNF")[1]	,.F.,)
			TRCell():New( _oSecCab, "C6_NOTA"  	,,	"Factura",					"@!",	TamSX3("C6_NOTA")[1]	,.F.,)
			TRCell():New( _oSecCab, "C6_SERIE"	,,	"Serie",					"@!", 	TamSX3("C6_SERIE")[1]	,.F.,)
			TRCell():New( _oSecCab, "F2_EMISSAO",,	"Fecha",					"@!", 	TamSX3("F2_EMISSAO")[1]	,.F.,)
			TRCell():New( _oSecCab, "D2_QUANT",,	"Qtd.Fact",					"@!", 	TamSX3("D2_QUANT")[1]	,.F.,)
		EndIf

		TRCell():New( _oSecCab, "BM_DESC"     	,,"Nombre Grupo de Articulos",	PesqPict('SBM',"BM_DESC"),		TamSX3("BM_DESC")[1]	,.F.,)
		TRCell():New( _oSecCab, "A3_NOME"     	,,"Nombre Vendedor ",			PesqPict('SA3',"A3_NOME"),		TamSX3("A3_NOME")[1]	,.F.,)
		TRCell():New( _oSecCab, "LEYENDA"    	,,"Leyenda         ",			"@!"	,20	,.F.,)
		TRCell():New( _oSecCab, "C5_XUSRINC"    ,,"Nombre del Operador",		PesqPict('SC5',"C5_XUSRINC"),	TamSX3("C5_XUSRINC")[1]	,.F.,)
		TRCell():New( _oSecCab, "C5_XHRINC"     ,,"Hora de ingreso ",			PesqPict('SC5',"C5_XHRINC"),	TamSX3("C5_XHRINC")[1]	,.F.,)

		TRFunction():New(_oSecCab:Cell("C6_VALOR"),NIL,"SUM",,,,,.F.,.T.)
	Else
		_oSecCab := TRSection():New( _oReport , "Listado de Pedidos ", {"QRY"} )

		TRCell():New( _oSecCab, "C5_EMISSAO"	,,"Emision 		" ,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1],.F.,)
		TRCell():New( _oSecCab, "C6_ENTREG"		,,"Entrega 		" ,PesqPict('SC6',"C6_ENTREG")	,TamSX3("C6_ENTREG")[1],.F.,)
		TRCell():New( _oSecCab, "C5_NUM"    	,,"Pedido       " ,PesqPict('SC5',"C5_NUM")		,TamSX3("C5_NUM")[1],.F.,)
		TRCell():New( _oSecCab, "C5_XTPED"    	,,"Tipo       " ,PesqPict('SC5',"C5_XTPED")		,TamSX3("C5_XTPED")[1],.F.,)
		TRCell():New( _oSecCab, "C5_CLIENTE"	,,"Cliente 		" ,PesqPict('SC5',"C5_CLIENTE")	,TamSX3("C5_CLIENTE")[1],.F.,)
		TRCell():New( _oSecCab, "C5_LOJACLI"	,,"Loja			" ,PesqPict('SC5',"C5_LOJACLI")	,TamSX3("C5_LOJACLI")[1],.F.,)
		TRCell():New( _oSecCab, "A1_NOME"  		,,"Nombre       " ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]	,.F.,)
		TRCell():New( _oSecCab, "MOEDA"   		,,"Moneda     	" ,"@!"							,3					,.F.,)
		TRCell():New( _oSecCab, "C5_TXMOEDA"   	,,"Valor moneda	" ,PesqPict('SC5',"C5_TXMOEDA")	,TamSX3("C5_TXMOEDA")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_QTDVEN"   	,,"Cantidad     " ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "C6_VALOR"		,,"SubTotal	    " ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "TIVA"			,,"Total IVA    " ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "TOTAL"     	,,"Total        " ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)

		TRCell():New( _oSecCab, "C5_XUSRINC"    ,,"Nombre del operador " ,PesqPict('SC5',"C5_XUSRINC")	,TamSX3("C5_XUSRINC")[1]	,.F.,)
		TRCell():New( _oSecCab, "C5_XHRINC"     ,,"Hora de ingreso     " ,PesqPict('SC5',"C5_XHRINC")	,TamSX3("C5_XHRINC")[1]	,.F.,)

		TRFunction():New(_oSecCab:Cell("C6_VALOR"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("TIVA"),NIL,"SUM",,,,,.F.,.T.)
		TRFunction():New(_oSecCab:Cell("TOTAL"),NIL,"SUM",,,,,.F.,.T.)

		_oSecCab:SetTotalText(" ")
	EndIf

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)
	Local _cQuery     := ""
	Local _cCliente	  := ""
	Local _nLin		  := 0
	Local _nTIVA	  := 0
	Local _nTotal	  := 0
	Local _cMoeda	  := ""
	Local cVdDe		:= "      "
	Local cVdAte	:= "ZZZZZZ"
	Local lErro		:= .F.

	If !__cUserId $ GetMv("ST_CORFAT",,"001220x001221x001243x001186") //("001220x001221x001243x001186") Ticket
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))

		If SA3->(DbSeek(xFilial("SA3") + __cUserId))
			cVdDe	:= SA3->A3_COD
			cVdAte	:= SA3->A3_COD
		Else
			MsgInfo("El usuario no es un vendedor registrado.","Atenção")
			lErro := .T.
		EndIf
	Else
		cVdDe	:= MV_PAR02
		cVdAte	:= MV_PAR03
	Endif

	If !lErro
		If MV_PAR01 == 1
			// "Detalle de Pedidos"


			If MV_PAR08==1 .Or. MV_PAR08==2

				_cQuery := "SELECT "
				_cQuery += "    C5.C5_EMISSAO,C5.C5_CLIENTE ,C5_XTPED,C5.C5_LOJACLI,A1.A1_NOME,C5.C5_NUM, C6.C6_ITEM, C6.C6_PRODUTO, C6_TES,C6.C6_QTDVEN,"
				_cQuery += "    C6.C6_QTDENT,C6.C6_QTDVEN - C6.C6_QTDENT C6_QTDEMP, NVL(B2.B2_SALPEDI,0) B2_SALPEDI,"
				_cQuery += "    C5.C5_LIBEROK,C5.C5_NOTA,C5.C5_BLQ,C5.C5_LIBEROK,C5.C5_XUSRINC, C5.C5_XHRINC,"
				_cQuery += "    NVL(B2.B2_QATU,0) SLD01, NVL(B2_02.B2_QATU,0) SLD02, NVL(B2_03.B2_QATU,0) SLD03,"
				_cQuery += "    C6.C6_PRCVEN,C6.C6_VALOR,C6.C6_LOCAL, NVL(B1_DESC,' ') B1_DESC,"
				_cQuery += "    C5_XORDEM, C6_NOTA, C6_SERIE,"


				If MV_PAR08 = 2  //Cerrado
					_cQuery += "    D2_QUANT, F2_EMISSAO, F2_XCOMPNF, "
				EndIf

				_cQuery += "    'AAAA' C5_XOBS, BM_DESC, A3_NOME, C5_MOEDA, NVL(M2_MOEDA2,0) TXMOEDA, C5.R_E_C_N_O_ RECSC5"
				_cQuery += " FROM " + RetSqlName("SC5") + " C5"
				_cQuery += " INNER   JOIN " + RetSqlName("SC6") + " C6 		ON ( C6_FILIAL          = C5_FILIAL         AND C6_NUM = C5_NUM AND C6.d_e_l_e_t_ = ' ' )"

				If MV_PAR09==1
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )
				ElseIf MV_PAR09==2
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'N' AND SF4.D_E_L_E_T_ = ' ' )
				else
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S'  AND SF4.D_E_L_E_T_ = ' ' )
				Endif

				_cQuery += " INNER   JOIN " + RetSqlName("SA1") + " A1      ON ( A1_COD             = C5_CLIENTE        AND A1_LOJA = C5_LOJACLI AND A1_GRPVEN <> 'ST' AND A1.D_E_L_E_T_ = ' ' )"

				If MV_PAR08 = 2  //Cerrado
					_cQuery += " INNER   JOIN " + RetSqlName("SF2") + " SF2     ON ( F2_FILIAL = C6_FILIAL AND F2_DOC 		= C6_NOTA 	AND F2_SERIE 	= C6_SERIE 	AND SF2.d_e_l_e_t_ = ' ' )"
					_cQuery += " INNER   JOIN " + RetSqlName("SD2") + " SD2     ON ( D2_FILIAL = C6_FILIAL AND D2_PEDIDO 	= C6_NUM 	AND D2_ITEMPV	= C6_ITEM	AND SD2.d_e_l_e_t_ = ' ' )"
				EndIf

				_cQuery += " LEFT    JOIN " + RetSqlName("SM2") + " M2      ON ( M2_DATA            = C5_EMISSAO        AND M2.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2      ON ( B2.B2_FILIAL       = C6_FILIAL         AND B2.B2_COD = C6_PRODUTO AND B2.B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_02   ON ( B2_02.B2_FILIAL    = C6_FILIAL         AND B2_02.B2_COD = C6_PRODUTO AND B2_02.B2_LOCAL = '02' AND B2_02.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_03   ON ( B2_03.B2_FILIAL    = C6_FILIAL         AND B2_03.B2_COD = C6_PRODUTO AND B2_03.B2_LOCAL = '03' AND B2_03.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB1") + " B1      ON ( B1_COD             = C6_PRODUTO        AND B1.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SBM") + " BM      ON ( B1_GRUPO           = BM_GRUPO          AND BM_FILIAL = '01' AND BM.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SA3") + " A3      ON ( C5_VEND1           = A3_COD            AND A3.D_E_L_E_T_ = ' ' )"
				_cQuery += " WHERE C5.d_e_l_e_t_ = ' '"
				_cQuery += " AND C5_EMISSAO BETWEEN '" 	+ 	dtos(MV_PAR04) +	"' AND '" 	+	dtos(MV_PAR05) + "' "
				_cQuery += " AND C5_CLIENTE BETWEEN '"	+	MV_PAR06	+		"' AND '"	+	MV_PAR07 + "' "
				_cQuery += " AND C5_VEND1 	BETWEEN '"	+	cVdDe	+		"' AND '"	+	cVdAte + "' "

				If MV_PAR08 = 1 //Em Aberto
					_cQuery += " AND C6.C6_NOTA = ' ' "
				ElseIf MV_PAR08 = 2 //Cerrado
					_cQuery += " AND C6.C6_NOTA <> ' ' "
				EndIf

				_cQuery += " AND C6_BLQ <> 'R'"
				_cQuery += " ORDER BY C5.C5_EMISSAO,C5.C5_NUM,C5.C5_CLIENTE,C5.C5_LOJACLI"

			ElseIf  MV_PAR08==3
  
				_cQuery := "SELECT "
				_cQuery += "    C5.C5_EMISSAO,C5.C5_CLIENTE ,C5_XTPED,C5.C5_LOJACLI,A1.A1_NOME,C5.C5_NUM, C6.C6_ITEM, C6.C6_PRODUTO, C6_TES,C6.C6_QTDVEN,"
				_cQuery += "    C6.C6_QTDENT,C6.C6_QTDVEN - C6.C6_QTDENT C6_QTDEMP, NVL(B2.B2_SALPEDI,0) B2_SALPEDI,"
				_cQuery += "    C5.C5_LIBEROK,C5.C5_NOTA,C5.C5_BLQ,C5.C5_LIBEROK,C5.C5_XUSRINC, C5.C5_XHRINC,"
				_cQuery += "    NVL(B2.B2_QATU,0) SLD01, NVL(B2_02.B2_QATU,0) SLD02, NVL(B2_03.B2_QATU,0) SLD03,"
				_cQuery += "    C6.C6_PRCVEN,C6.C6_VALOR,C6.C6_LOCAL, NVL(B1_DESC,' ') B1_DESC,"
				_cQuery += "    C5_XORDEM, C6_NOTA, C6_SERIE,"
                _cQuery += "    0 AS D2_QUANT, '' as F2_EMISSAO, '' as F2_XCOMPNF, "


				_cQuery += "    'AAAA' C5_XOBS, BM_DESC, A3_NOME, C5_MOEDA, NVL(M2_MOEDA2,0) TXMOEDA, C5.R_E_C_N_O_ RECSC5"
				_cQuery += " FROM " + RetSqlName("SC5") + " C5"
				_cQuery += " INNER   JOIN " + RetSqlName("SC6") + " C6 		ON ( C6_FILIAL          = C5_FILIAL         AND C6_NUM = C5_NUM AND C6.d_e_l_e_t_ = ' ' )"

				If MV_PAR09==1
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )
				ElseIf MV_PAR09==2
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'N' AND SF4.D_E_L_E_T_ = ' ' )
				else
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S'  AND SF4.D_E_L_E_T_ = ' ' )
				Endif

				_cQuery += " INNER   JOIN " + RetSqlName("SA1") + " A1      ON ( A1_COD             = C5_CLIENTE        AND A1_LOJA = C5_LOJACLI AND A1_GRPVEN <> 'ST' AND A1.D_E_L_E_T_ = ' ' )"

				If MV_PAR08 = 2  //Cerrado
					_cQuery += " INNER   JOIN " + RetSqlName("SF2") + " SF2     ON ( F2_FILIAL = C6_FILIAL AND F2_DOC 		= C6_NOTA 	AND F2_SERIE 	= C6_SERIE 	AND SF2.d_e_l_e_t_ = ' ' )"
					_cQuery += " INNER   JOIN " + RetSqlName("SD2") + " SD2     ON ( D2_FILIAL = C6_FILIAL AND D2_PEDIDO 	= C6_NUM 	AND D2_ITEMPV	= C6_ITEM	AND SD2.d_e_l_e_t_ = ' ' )"
				EndIf

				_cQuery += " LEFT    JOIN " + RetSqlName("SM2") + " M2      ON ( M2_DATA            = C5_EMISSAO        AND M2.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2      ON ( B2.B2_FILIAL       = C6_FILIAL         AND B2.B2_COD = C6_PRODUTO AND B2.B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_02   ON ( B2_02.B2_FILIAL    = C6_FILIAL         AND B2_02.B2_COD = C6_PRODUTO AND B2_02.B2_LOCAL = '02' AND B2_02.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_03   ON ( B2_03.B2_FILIAL    = C6_FILIAL         AND B2_03.B2_COD = C6_PRODUTO AND B2_03.B2_LOCAL = '03' AND B2_03.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB1") + " B1      ON ( B1_COD             = C6_PRODUTO        AND B1.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SBM") + " BM      ON ( B1_GRUPO           = BM_GRUPO          AND BM_FILIAL = '01' AND BM.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SA3") + " A3      ON ( C5_VEND1           = A3_COD            AND A3.D_E_L_E_T_ = ' ' )"
				_cQuery += " WHERE C5.d_e_l_e_t_ = ' '"
				_cQuery += " AND C5_EMISSAO BETWEEN '" 	+ 	dtos(MV_PAR04) +	"' AND '" 	+	dtos(MV_PAR05) + "' "
				_cQuery += " AND C5_CLIENTE BETWEEN '"	+	MV_PAR06	+		"' AND '"	+	MV_PAR07 + "' "
				_cQuery += " AND C5_VEND1 	BETWEEN '"	+	cVdDe	+		"' AND '"	+	cVdAte + "' "

		
				_cQuery += " AND C6.C6_NOTA = ' ' "
			
				_cQuery += " AND C6_BLQ <> 'R' "


               	_cQuery += " UNION ALL  "


				_cQuery += " SELECT "
				_cQuery += "    C5.C5_EMISSAO,C5.C5_CLIENTE ,C5_XTPED,C5.C5_LOJACLI,A1.A1_NOME,C5.C5_NUM, C6.C6_ITEM, C6.C6_PRODUTO, C6_TES,C6.C6_QTDVEN,"
				_cQuery += "    C6.C6_QTDENT,C6.C6_QTDVEN - C6.C6_QTDENT C6_QTDEMP, NVL(B2.B2_SALPEDI,0) B2_SALPEDI,"
				_cQuery += "    C5.C5_LIBEROK,C5.C5_NOTA,C5.C5_BLQ,C5.C5_LIBEROK,C5.C5_XUSRINC, C5.C5_XHRINC,"
				_cQuery += "    NVL(B2.B2_QATU,0) SLD01, NVL(B2_02.B2_QATU,0) SLD02, NVL(B2_03.B2_QATU,0) SLD03,"
				_cQuery += "    C6.C6_PRCVEN,C6.C6_VALOR,C6.C6_LOCAL, NVL(B1_DESC,' ') B1_DESC,"
				_cQuery += "    C5_XORDEM, C6_NOTA, C6_SERIE,"
                _cQuery += "    D2_QUANT, F2_EMISSAO, F2_XCOMPNF, "


				_cQuery += "    'AAAA' C5_XOBS, BM_DESC, A3_NOME, C5_MOEDA, NVL(M2_MOEDA2,0) TXMOEDA, C5.R_E_C_N_O_ RECSC5"
				_cQuery += " FROM " + RetSqlName("SC5") + " C5"
				_cQuery += " INNER   JOIN " + RetSqlName("SC6") + " C6 		ON ( C6_FILIAL          = C5_FILIAL         AND C6_NUM = C5_NUM AND C6.d_e_l_e_t_ = ' ' )"

				If MV_PAR09==1
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )
				ElseIf MV_PAR09==2
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'N' AND SF4.D_E_L_E_T_ = ' ' )
				else
					_cQuery += " INNER   JOIN " + RetSqlName("SF4") + " SF4     ON ( F4_CODIGO          = C6_TES            AND F4_TIPO = 'S' AND F4_DUPLIC = 'S'  AND SF4.D_E_L_E_T_ = ' ' )
				Endif

				_cQuery += " INNER   JOIN " + RetSqlName("SA1") + " A1      ON ( A1_COD             = C5_CLIENTE        AND A1_LOJA = C5_LOJACLI AND A1_GRPVEN <> 'ST' AND A1.D_E_L_E_T_ = ' ' )"
                _cQuery += " INNER   JOIN " + RetSqlName("SF2") + " SF2     ON ( F2_FILIAL = C6_FILIAL AND F2_DOC 		= C6_NOTA 	AND F2_SERIE 	= C6_SERIE 	AND SF2.d_e_l_e_t_ = ' ' )"
				_cQuery += " INNER   JOIN " + RetSqlName("SD2") + " SD2     ON ( D2_FILIAL = C6_FILIAL AND D2_PEDIDO 	= C6_NUM 	AND D2_ITEMPV	= C6_ITEM	AND SD2.d_e_l_e_t_ = ' ' )"

				_cQuery += " LEFT    JOIN " + RetSqlName("SM2") + " M2      ON ( M2_DATA            = C5_EMISSAO        AND M2.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2      ON ( B2.B2_FILIAL       = C6_FILIAL         AND B2.B2_COD = C6_PRODUTO AND B2.B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_02   ON ( B2_02.B2_FILIAL    = C6_FILIAL         AND B2_02.B2_COD = C6_PRODUTO AND B2_02.B2_LOCAL = '02' AND B2_02.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB2") + " B2_03   ON ( B2_03.B2_FILIAL    = C6_FILIAL         AND B2_03.B2_COD = C6_PRODUTO AND B2_03.B2_LOCAL = '03' AND B2_03.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SB1") + " B1      ON ( B1_COD             = C6_PRODUTO        AND B1.D_E_L_E_T_ = ' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SBM") + " BM      ON ( B1_GRUPO           = BM_GRUPO          AND BM_FILIAL = '01' AND BM.D_E_L_E_T_=' ' )"
				_cQuery += " LEFT    JOIN " + RetSqlName("SA3") + " A3      ON ( C5_VEND1           = A3_COD            AND A3.D_E_L_E_T_ = ' ' )"
				_cQuery += " WHERE C5.d_e_l_e_t_ = ' '"
				_cQuery += " AND C5_EMISSAO BETWEEN '" 	+ 	dtos(MV_PAR04) +	"' AND '" 	+	dtos(MV_PAR05) + "' "
				_cQuery += " AND C5_CLIENTE BETWEEN '"	+	MV_PAR06	+		"' AND '"	+	MV_PAR07 + "' "
				_cQuery += " AND C5_VEND1 	BETWEEN '"	+	cVdDe	+		"' AND '"	+	cVdAte + "' "
                _cQuery += " AND C6.C6_NOTA <> ' ' "
		

				_cQuery += " AND C6_BLQ <> 'R'"
				//_cQuery += " ORDER BY C5.C5_EMISSAO,C5.C5_NUM,C5.C5_CLIENTE,C5.C5_LOJACLI"
                _cQuery += " ORDER BY C5_EMISSAO,C5_NUM,C5_CLIENTE,C5_LOJACLI"

			Endif

			If Select("QRY") > 0
				Dbselectarea("QRY")
				QRY->(DbClosearea())
			EndIf

			TcQuery _cQuery New Alias "QRY"

			dbSelectArea("QRY")
			QRY->(dbGoTop())

			_nLin := 70

			DbSelectArea("SC5")

			While !QRY->(Eof())

				_cCliente := QRY->C5_CLIENTE

				While !QRY->(Eof()) .AND. QRY->C5_CLIENTE = _cCliente

					SC5->(DbGoTo(QRY->RECSC5))

					_oSecCab:Init()

					_oSecCab:Cell("C5_EMISSAO"):SetValue(Stod(QRY->C5_EMISSAO))
					_oSecCab:Cell("C5_CLIENTE"):SetValue(QRY->C5_CLIENTE)
					_oSecCab:Cell("C5_LOJACLI"):SetValue(QRY->C5_LOJACLI)
					_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
					_oSecCab:Cell("C5_NUM"):SetValue(QRY->C5_NUM)
					_oSecCab:Cell("C5_XTPED"):SetValue(QRY->C5_XTPED)
					_oSecCab:Cell("C6_ITEM"):SetValue(QRY->C6_ITEM)
					_oSecCab:Cell("C6_PRODUTO"):SetValue(QRY->C6_PRODUTO)
					_oSecCab:Cell("C6_QTDVEN"):SetValue(QRY->C6_QTDVEN)
					_oSecCab:Cell("C6_PRCVEN"):SetValue(QRY->C6_PRCVEN)
					_oSecCab:Cell("C6_VALOR"):SetValue(QRY->C6_VALOR)
					_oSecCab:Cell("C6_QTDENT"):SetValue(QRY->C6_QTDENT)
					_oSecCab:Cell("C6_QTDEMP"):SetValue(QRY->C6_QTDEMP)
					_oSecCab:Cell("B2_QATU"):SetValue(QRY->SLD01)
					_oSecCab:Cell("B2_QATU2"):SetValue(QRY->SLD02)
					_oSecCab:Cell("B2_QATU3"):SetValue(QRY->SLD03)
					_oSecCab:Cell("B2_SALPEDI"):SetValue(QRY->B2_SALPEDI)
					_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
					_oSecCab:Cell("C5_XORDEM"):SetValue(QRY->C5_XORDEM)
					_oSecCab:Cell("C5_XOBS"):SetValue(AllTrim(SC5->C5_XOBS))

					If MV_PAR08 = 2 .Or. MV_PAR08 = 3 //Faturado
						_oSecCab:Cell("F2_XCOMPNF"):SetValue(QRY->F2_XCOMPNF)
						_oSecCab:Cell("C6_NOTA"):SetValue(QRY->C6_NOTA)
						_oSecCab:Cell("C6_SERIE"):SetValue(QRY->C6_SERIE)
						_oSecCab:Cell("F2_EMISSAO"):SetValue(Stod(QRY->F2_EMISSAO))
						_oSecCab:Cell("D2_QUANT"):SetValue(QRY->D2_QUANT)
					EndIf

					_oSecCab:Cell("BM_DESC"):SetValue(QRY->BM_DESC)
					_oSecCab:Cell("A3_NOME"):SetValue(QRY->A3_NOME)

					If Empty(QRY->C5_LIBEROK).And.Empty(QRY->C5_NOTA) .And. Empty(QRY->C5_BLQ)
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta Abierto")
					ElseIf !Empty(QRY->C5_NOTA).Or.QRY->C5_LIBEROK=='E' .And. Empty(QRY->C5_BLQ)
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta facturado")
					ElseIf !Empty(QRY->C5_LIBEROK).And.Empty(QRY->C5_NOTA).And. Empty(QRY->C5_BLQ) //.And. Empty(QRY->C5_XSTAFIN)
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta aprobado")
					ElseIf QRY->C5_BLQ == '1'
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido Bloquedo por regra")
					ElseIF QRY->C5_BLQ == '2'
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido Bloquedo por verba")
					ElseIf AllTrim(QRY->C5_NOTA)=='REMITO'
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta remitido")
					ElseIf !Empty(QRY->C5_LIBEROK) .And. Empty(QRY->C5_NOTA) //.And. QRY->C5_XSTAFIN=='B'
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta en analice financieira")
					ElseIf !Empty(QRY->C5_LIBEROK) .And. Empty(QRY->C5_NOTA) //.And. QRY->C5_XSTAFIN=='R'
						_oSecCab:Cell("LEYENDA"):SetValue("Pedido de venta rechazado")
					EndIf

					_oSecCab:Cell("C5_XUSRINC"):SetValue(UsrRetName(QRY->C5_XUSRINC))
					_oSecCab:Cell("C5_XHRINC"):SetValue(QRY->C5_XHRINC)

					If QRY->C5_MOEDA == 2
						_cMoeda := "U$S"
						_oSecCab:Cell("C5_TXMOEDA"):SetValue(QRY->TXMOEDA)
					Else
						_cMoeda := "$"
						_oSecCab:Cell("C5_TXMOEDA"):SetValue(0)
					EndIf

					_oSecCab:Cell("MOEDA"):SetValue(_cMoeda)

					_oSecCab:PrintLine()

					_nLin += 15

					QRY->(DbSkip())

				EndDo

				_oReport:ThinLine()
				_cCliente := ""

			EndDo
			_oSecCab:Finish()
		Else
			//"Listado de Pedidos"
			_cQuery := "SELECT "
			_cQuery += "	C5_EMISSAO, C6_ENTREG, C5_NUM, C5_XTPED,C5_CLIENTE, C5_LOJACLI, A1_NOME,"
			_cQuery += "	C5_MOEDA, FB_ALIQ, SUM(C6_QTDVEN) C6_QTDVEN, SUM(C6_VALOR) C6_VALOR, "
			_cQuery += "	SUM(C6_VALDESC) C6_VALDESC, C5_XUSRINC, C5_XHRINC,"
			_cQuery += "    NVL(M2_MOEDA2,0) TXMOEDA"
			_cQuery += " FROM " + 			RetSqlName("SC5") + 	" C5"
			_cQuery += " INNER   JOIN " + 	RetSqlName("SC6") + 	" C6  ON ( C6_FILIAL = C5_FILIAL  AND C6_NUM = C5_NUM  AND C6.D_E_L_E_T_ = ' ' )"
			_cQuery += " LEFT    JOIN " + 	RetSqlName("SM2") + 	" M2  ON ( M2_DATA = C5_EMISSAO   AND M2.D_E_L_E_T_ = ' ' )"
			_cQuery += " INNER   JOIN " +	RetSqlName("SF4" ) +	" SF4 ON ( F4_CODIGO = C6_TES     AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )"
			_cQuery += " LEFT    JOIN " + 	RetSqlname("SFB" ) + 	" FB  ON ( FB.FB_FILIAL = ' '     AND FB_CODIGO = 'IVA' AND FB.D_E_L_E_T_ = ' ' )"
			_cQuery += " INNER   JOIN " + 	RetSqlName("SA1") + 	" A1  ON ( A1_COD = C5_CLIENTE    AND A1_LOJA = C5_LOJACLI AND A1_GRPVEN <> 'ST' AND A1.D_E_L_E_T_ = ' ' )"
			_cQuery += " WHERE C5.D_E_L_E_T_ = ' '"
			_cQuery += " AND C5.C5_EMISSAO BETWEEN '" + dtos(MV_PAR04) + "' AND '" + dtos(MV_PAR05) + "' "
			_cQuery += " AND C5_CLIENTE BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
			_cQuery += " AND C5_VEND1 	BETWEEN '"	+	cVdDe	+		"' AND '"	+	cVdAte + "' "

			If MV_PAR08 = 1 //Em Aberto
				_cQuery += " AND C5.C5_NOTA = ' ' "
			ElseIf MV_PAR08 = 2 //Cerrado
				_cQuery += " AND C5.C5_NOTA <> ' ' "
			EndIf

			_cQuery += " GROUP BY C5.C5_EMISSAO,C6.C6_ENTREG,C5.C5_NUM,C5.C5_CLIENTE ,C5.C5_LOJACLI,A1.A1_NOME,C5.C5_MOEDA,FB.FB_ALIQ, C5.C5_XUSRINC, C5.C5_XHRINC, M2_MOEDA2,C5_XTPED "
			_cQuery += " ORDER BY C5.C5_EMISSAO,C5.C5_NUM,C5.C5_CLIENTE,C5.C5_LOJACLI "

			If Select("QRY") > 0
				Dbselectarea("QRY")
				QRY->(DbClosearea())
			EndIf

			TcQuery _cQuery New Alias "QRY"

			dbSelectArea("QRY")
			QRY->(dbGoTop())

			_nLin := 70
			While !QRY->(Eof())

				_cCliente := QRY->C5_CLIENTE

				While !QRY->(Eof()) .AND. QRY->C5_CLIENTE = _cCliente

					_oSecCab:Init()

					_oSecCab:Cell("C5_EMISSAO"):SetValue(Stod(QRY->C5_EMISSAO))
					_oSecCab:Cell("C6_ENTREG"):SetValue(Stod(QRY->C6_ENTREG))
					_oSecCab:Cell("C5_NUM"):SetValue(QRY->C5_NUM)
					_oSecCab:Cell("C5_XTPED"):SetValue(QRY->C5_XTPED)
					_oSecCab:Cell("C5_CLIENTE"):SetValue(QRY->C5_CLIENTE)
					_oSecCab:Cell("C5_LOJACLI"):SetValue(QRY->C5_LOJACLI)
					_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)

					If QRY->C5_MOEDA == 2
						_cMoeda := "U$S"
						_oSecCab:Cell("C5_TXMOEDA"):SetValue(QRY->TXMOEDA)
					Else
						_cMoeda := "$"
						_oSecCab:Cell("C5_TXMOEDA"):SetValue(0)
					EndIf

					_oSecCab:Cell("MOEDA"):SetValue(_cMoeda)

					_oSecCab:Cell("C6_QTDVEN"):SetValue(QRY->C6_QTDVEN)
					_nTIVA  := ((QRY->C6_VALOR * QRY->FB_ALIQ)/100)
					_nTotal := _nTIVA+QRY->C6_VALOR
					_oSecCab:Cell("TIVA"):SetValue(_nTIVA)
					_oSecCab:Cell("C6_VALOR"):SetValue(QRY->C6_VALOR) //SubTotal
					_oSecCab:Cell("TOTAL"):SetValue(_nTotal)

					_oSecCab:Cell("C5_XUSRINC"):SetValue(UsrRetName(QRY->C5_XUSRINC))
					_oSecCab:Cell("C5_XHRINC"):SetValue(QRY->C5_XHRINC)
					_oSecCab:PrintLine()

					_nLin += 15

					QRY->(DbSkip())

				EndDo

				_cCliente := ""

			EndDo
			_oSecCab:Finish()

		EndIF
	EndIf

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
	AADD(_aRegs,{_cPerg,"01","Contenido?",				"Contenido? "		,"Contenido?  "	,"mv_ch1","N",01,0,0,"C","          ","mv_par01","Detallado","Detallado","Detallado","","","Geral","Geral","Geral","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Do Vendedor?",			"Do Vendedor? "	,	"Do Vendedor? ","mv_ch2","C",06,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Ate Vendedor?",			"Ate Vendedor? "	,"Ate Vendedor?","mv_ch3","C",06,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","De DT Emissao?",			"De Fch Emision "	,"Issue Date  "	,"mv_ch4","D",08,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","De DT Emissao?",			"Ate Fch Emision "	,"Issue Date  "	,"mv_ch5","D",08,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"06","Do Cliente?",				"Do Cliente? "		,"Do Cliente?"	,"mv_ch6","C",06,0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"07","Ate Cliente?",			"Ate Cliente? "	,	"Ate Cliente?"	,"mv_ch7","C",06,0,0,"G","          ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"08","Tipo ?",					"Tipo ? "			,"Tipo ?  "		,"mv_ch8","N",01,0,0,"C","          ","mv_par08","En Abierto","En Abierto","En Abierto","","","Facturado","Facturado","Facturado","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"09","Mostrar diferencias?",	"Mostrar diferencias?"		,"Mostrar diferencias?"	,"mv_ch9","N",01,0,0,"C","          ","mv_par09","Sim","Si","Yes","","","Não","No","Not","","","","","","","","","","","","","","","","","",""})

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
