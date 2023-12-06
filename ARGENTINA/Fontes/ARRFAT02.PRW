#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} ARRFAT02

Detalle de Presupuestos

@type function
@author Everson Santana
@since 10/09/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARRFAT02()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT02", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTipo1	 := ""
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

	If MV_PAR01 == 1
		_cTitulo := "Detalle de Presupuesto"
	Else
		_cTitulo := "Listado de Presupuesto"
	EndIF

	If MV_PAR08 = 1 //A=Abierto;B=Aprobado;C=Anulado;D=No Presupuestado                                                                               
		_cTipo  := "Abierto"
		_cTipo1 := "A" 
	ElseIf MV_PAR08 = 2
		_cTipo  := "Aprobado"
		_cTipo1	:= "B"
	ElseIf MV_PAR08 = 3
		_cTipo 	:= "Anulado"
		_cTipo1	:= "C"
	ElseIf MV_PAR08 = 4
		_cTipo 	:= "No Presupuestado"
		_cTipo1	:= "D"	
	EndIf
	//_oReport:SetLandScape(.T.)
	_oReport := TReport():New("ARRFAT02",_cTitulo+" "+_cTipo+" - "+Alltrim(aPergunta[4][1])+" : "+dtoc(MV_PAR04)+" "+Alltrim(aPergunta[5][1])+" : "+dtoc(MV_PAR05),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo+" "+_cTipo)

	If MV_PAR01 == 1

		_oSecCab := TRSection():New( _oReport , "Detalle de Presupuesto", {"QRY"} )

		TRCell():New( _oSecCab, "CJ_EMISSAO"	,,"Fecha 		" ,PesqPict('SCJ',"CJ_EMISSAO")	,TamSX3("CJ_EMISSAO")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_NUM"    	,,"Presupuesto" ,PesqPict('SCJ',"CJ_NUM")		,TamSX3("CJ_NUM")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_CLIENTE"	,,"Cliente 		" ,PesqPict('SCJ',"CJ_CLIENTE")	,TamSX3("CJ_CLIENTE")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_LOJA"		,,"Loja			" ,PesqPict('SCJ',"CJ_LOJA")	,TamSX3("CJ_LOJA")[1],.F.,)
		TRCell():New( _oSecCab, "A1_NOME"  		,,"Nombre       " ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]	,.F.,)		
		TRCell():New( _oSecCab, "A1_VEND"  		,,"Vendedor     " ,PesqPict('SA1',"A1_VEND")	,TamSX3("A1_VEND")[1]	,.F.,)
		TRCell():New( _oSecCab, "NOMBRE"  		,,"Nombre Vend  " ,PesqPict('SA3',"A3_NOME")	,TamSX3("A3_NOME")[1]	,.F.,)
		TRCell():New( _oSecCab, "CK_PRODUTO"   	,,"Producto     " ,PesqPict('SCK',"CK_PRODUTO")	,TamSX3("CK_PRODUTO")[1]	,.F.,)
		TRCell():New( _oSecCab, "CK_QTDVEN"   	,,"Cantidad     " ,PesqPict('SCK',"CK_QTDVEN")	,TamSX3("CK_QTDVEN")[1]	,.F.,)
		//TRCell():New( _oSecCab, "CJ_MOEDA"   	,,"Moeda     	" ,PesqPict('SCJ',"CJ_MOEDA")	,TamSX3("CJ_MOEDA")[1]	,.F.,)
		TRCell():New( _oSecCab, "MOEDA"   		,,"Moneda     	" ,"@!"							,3					,.F.,)
		TRCell():New( _oSecCab, "CK_PRCVEN"   	,,"Vlr Unitario " ,PesqPict('SCK',"CK_PRCVEN")	,TamSX3("CK_PRCVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "CK_VALOR"   	,,"Total     	" ,PesqPict('SCK',"CK_VALOR")	,TamSX3("CK_VALOR")[1]	,.F.,)
		
		TRFunction():New(_oSecCab:Cell("CK_VALOR"),NIL,"SUM",,,,,.F.,.T.)
		
		Else

		_oSecCab := TRSection():New( _oReport , "Listado de Presupuesto ", {"QRY"} )

		TRCell():New( _oSecCab, "CJ_EMISSAO"	,,"Emision 		" ,PesqPict('SCJ',"CJ_EMISSAO")	,TamSX3("CJ_EMISSAO")[1],.F.,)
		TRCell():New( _oSecCab, "CK_ENTREG"		,,"Entrega 		" ,PesqPict('SCK',"CK_ENTREG")	,TamSX3("CK_ENTREG")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_NUM"    	,,"Presupuesto  " ,PesqPict('SCJ',"CJ_NUM")		,TamSX3("CJ_NUM")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_CLIENTE"	,,"Cliente 		" ,PesqPict('SCJ',"CJ_CLIENTE")	,TamSX3("CJ_CLIENTE")[1],.F.,)
		TRCell():New( _oSecCab, "CJ_LOJA"		,,"Loja			" ,PesqPict('SCJ',"CJ_LOJA")	,TamSX3("CJ_LOJA")[1],.F.,)
		TRCell():New( _oSecCab, "A1_NOME"  		,,"Nombre       " ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]	,.F.,)
		TRCell():New( _oSecCab, "MOEDA"   		,,"Moneda     	" ,"@!"							,3					,.F.,)
		TRCell():New( _oSecCab, "CK_QTDVEN"   	,,"Cantidad     " ,PesqPict('SCK',"CK_QTDVEN")	,TamSX3("CK_QTDVEN")[1]	,.F.,)
		TRCell():New( _oSecCab, "CK_VALOR"		,,"SubTotal	    " ,PesqPict('SCK',"CK_VALOR")	,TamSX3("CK_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "TIVA"			,,"Total IVA    " ,PesqPict('SCK',"CK_VALOR")	,TamSX3("CK_VALOR")[1]	,.F.,)
		TRCell():New( _oSecCab, "TOTAL"     	,,"Total        " ,PesqPict('SCK',"CK_VALOR")	,TamSX3("CK_VALOR")[1]	,.F.,) 

		TRFunction():New(_oSecCab:Cell("CK_VALOR"),NIL,"SUM",,,,,.F.,.T.)
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
	//Pergunte(_cPerg,.F.)

	If MV_PAR01 == 1

		_cQuery += " SELECT CJ.CJ_EMISSAO,CJ.CJ_NUM,CJ.CJ_CLIENTE ,CJ.CJ_LOJA,A1.A1_NOME,A1.A1_VEND,CK.CK_PRODUTO,CK.CK_QTDVEN,CK.CK_PRCVEN,CK.CK_VALOR,CJ.CJ_STATUS,CJ.CJ_MOEDA  "
		_cQuery += " FROM " + RetSqlName("SCJ") + " CJ "
		_cQuery += "  LEFT JOIN " + RetSqlName("SCK") + " CK "
		_cQuery += "  	ON CK.CK_FILIAL = CJ.CJ_FILIAL "
		_cQuery += "  	AND CK.CK_NUM = CJ.CJ_NUM "
		_cQuery += "  	AND CK.D_E_L_E_T_ = ' ' "
		_cQuery += "  LEFT JOIN " + RetSqlName("SB2") + " B2 "
		_cQuery += " 	ON B2.B2_FILIAL = CK.CK_FILIAL "
		_cQuery += " 	AND B2.B2_COD = CK.CK_PRODUTO "
		_cQuery += " 	AND B2.B2_LOCAL = CK.CK_LOCAL "
		_cQuery += " 	AND B2.D_E_L_E_T_ = ' ' ""
		_cQuery += "  LEFT JOIN "+ RetSqlName("SA1") +" A1 "
		_cQuery += "	ON A1.A1_COD = CJ.CJ_CLIENTE "
		_cQuery += "	AND A1.A1_LOJA = CJ.CJ_LOJA "
		_cQuery += "	AND A1.D_E_L_E_T_ = ' ' "
		_cQuery += " WHERE A1.A1_VEND BETWEEN '"+MV_PAR02+" ' AND '"+MV_PAR03+"' "
		_cQuery += "	AND CJ.CJ_EMISSAO BETWEEN '"+dtos(MV_PAR04)+"' AND '"+dtos(MV_PAR05)+"' "
		_cQuery += "	AND CJ.CJ_CLIENTE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
		_cQuery += "	AND CK.CK_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
		_cQuery += "    AND CJ.CJ_STATUS = '"+_cTipo1+"' " 
		_cQuery += " 	AND CJ.D_E_L_E_T_ = ' ' "
		_cQuery += " ORDER BY CJ.CJ_EMISSAO,CJ.CJ_NUM,CJ.CJ_CLIENTE,CJ.CJ_LOJA "

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery _cQuery New Alias "QRY"

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		_nLin := 70
		While !QRY->(Eof())

			_cCliente := QRY->CJ_CLIENTE

			While !QRY->(Eof()) .AND. QRY->CJ_CLIENTE = _cCliente

				_oSecCab:Init()

				_oSecCab:Cell("CJ_EMISSAO"):SetValue(Stod(QRY->CJ_EMISSAO))
				_oSecCab:Cell("CJ_NUM"):SetValue(QRY->CJ_NUM)
				_oSecCab:Cell("CJ_CLIENTE"):SetValue(QRY->CJ_CLIENTE)
				_oSecCab:Cell("CJ_LOJA"):SetValue(QRY->CJ_LOJA)
				_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)				
				_oSecCab:Cell("A1_VEND"):SetValue(QRY->A1_VEND)
				_oSecCab:Cell("NOMBRE"):SetValue(POSICIONE("SA3", 1, xFilial("SA3") + QRY->A1_VEND, "A3_NOME"))				
				_oSecCab:Cell("CK_PRODUTO"):SetValue(QRY->CK_PRODUTO)
				_oSecCab:Cell("CK_QTDVEN"):SetValue(QRY->CK_QTDVEN)
				If QRY->CJ_MOEDA == 2
					_cMoeda := "U$S"
				Else
					_cMoeda := "$"
				EndIf
		
				_oSecCab:Cell("MOEDA"):SetValue(_cMoeda)
				_oSecCab:Cell("CK_PRCVEN"):SetValue(QRY->CK_PRCVEN)
				_oSecCab:Cell("CK_VALOR"):SetValue(QRY->CK_VALOR)
				
				_oSecCab:PrintLine()

				_nLin += 15

				QRY->(DbSkip())

			EndDo
			_oReport:ThinLine()
			_cCliente := ""

		EndDo
		_oSecCab:Finish()
	Else

		_cQuery += " SELECT CJ.CJ_EMISSAO,CK.CK_ENTREG,CJ.CJ_NUM,CJ.CJ_CLIENTE ,CJ.CJ_LOJA,A1.A1_NOME,CJ.CJ_MOEDA,FB.FB_ALIQ,SUM(CK.CK_QTDVEN) CK_QTDVEN,SUM(CK.CK_VALOR) CK_VALOR "// ,SUM(C6.C6_VALDESC) C6_VALDESC "
		_cQuery += " FROM " + RetSqlName("SCJ") + " CJ "
		_cQuery += "  LEFT JOIN " + RetSqlName("SCK") + " CK "
		_cQuery += "  	ON CK.CK_FILIAL = CJ.CJ_FILIAL "
		_cQuery += "  	AND CK.CK_NUM = CJ.CJ_NUM "
		_cQuery += "  	AND CK.D_E_L_E_T_ = ' ' "
		_cQuery += "  LEFT JOIN " + RetSqlName("SFB") + " FB "
		_cQuery += " 	ON FB.FB_FILIAL = ' ' "
		_cQuery += " 	AND FB.FB_CODIGO = 'IVA' "
		_cQuery += " 	AND FB.D_E_L_E_T_ = ' ' ""
		_cQuery += "  LEFT JOIN "+ RetSqlName("SA1") +" A1 "
		_cQuery += "	ON A1.A1_COD = CJ.CJ_CLIENTE "
		_cQuery += "	AND A1.A1_LOJA = CJ.CJ_LOJA "
		_cQuery += "	AND A1.D_E_L_E_T_ = ' ' "
		_cQuery += " WHERE A1.A1_VEND BETWEEN '"+MV_PAR02+" ' AND '"+MV_PAR03+"' "
		_cQuery += "	AND CJ.CJ_EMISSAO BETWEEN '"+dtos(MV_PAR04)+"' AND '"+dtos(MV_PAR05)+"' "
		_cQuery += "	AND CJ.CJ_CLIENTE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
		_cQuery += "       And CJ.CJ_STATUS = '"+_cTipo1+"' "
		_cQuery += " 	AND CJ.D_E_L_E_T_ = ' ' "
		_cQuery += " GROUP BY CJ.CJ_EMISSAO,CK.CK_ENTREG,CJ.CJ_NUM,CJ.CJ_CLIENTE ,CJ.CJ_LOJA,A1.A1_NOME,CJ.CJ_MOEDA,FB.FB_ALIQ "
		_cQuery += " ORDER BY CJ.CJ_EMISSAO,CJ.CJ_NUM,CJ.CJ_CLIENTE,CJ.CJ_LOJA "

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery _cQuery New Alias "QRY"

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		_nLin := 70
		While !QRY->(Eof())

			_cCliente := QRY->CJ_CLIENTE

			While !QRY->(Eof()) .AND. QRY->CJ_CLIENTE = _cCliente

				_oSecCab:Init()

				_oSecCab:Cell("CJ_EMISSAO"):SetValue(Stod(QRY->CJ_EMISSAO))
				_oSecCab:Cell("CK_ENTREG"):SetValue(Stod(QRY->CK_ENTREG))
				_oSecCab:Cell("CJ_NUM"):SetValue(QRY->CJ_NUM)
				_oSecCab:Cell("CJ_CLIENTE"):SetValue(QRY->CJ_CLIENTE)
				_oSecCab:Cell("CJ_LOJA"):SetValue(QRY->CJ_LOJA)
				_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
				If QRY->CJ_MOEDA == 2
					_cMoeda := "U$S"
				Else
					_cMoeda := "$"
				EndIf
				_oSecCab:Cell("MOEDA"):SetValue(_cMoeda)
				_oSecCab:Cell("CK_QTDVEN"):SetValue(QRY->CK_QTDVEN)
				_nTIVA  := ((QRY->CK_VALOR * QRY->FB_ALIQ)/100)
				_nTotal := _nTIVA+QRY->CK_VALOR 
				_oSecCab:Cell("TIVA"):SetValue(_nTIVA)
				_oSecCab:Cell("CK_VALOR"):SetValue(QRY->CK_VALOR) //SubTotal
				_oSecCab:Cell("TOTAL"):SetValue(_nTotal)

				_oSecCab:PrintLine()

				_nLin += 15

				QRY->(DbSkip())

			EndDo
			
			_cCliente := ""

		EndDo
		_oSecCab:Finish()


	EndIF


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
	AADD(_aRegs,{_cPerg,"01","Contenido?  	 "	,"Contenido? "		,"Contenido?  "	,"mv_ch1","N",01,0,0,"C","          ","mv_par01","Detallado","Detallado","Detallado","","","Geral","Geral","Geral","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Do Vendedor?   "	,"Do Vendedor? "	,"Do Vendedor? ","mv_ch2","C",06,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Ate Vendedor?	 "	,"Ate Vendedor? "	,"Ate Vendedor?","mv_ch3","C",06,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","De DT Emissao? "	,"De Fch Emision "	,"Issue Date  "	,"mv_ch4","D",08,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","De DT Emissao? "	,"Ate Fch Emision "	,"Issue Date  "	,"mv_ch5","D",08,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"06","Do Cliente?	 "	,"Do Cliente? "		,"Do Cliente?"	,"mv_ch6","C",06,0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"07","Ate Cliente?	 "	,"Ate Cliente? "	,"Ate Cliente?"	,"mv_ch7","C",06,0,0,"G","          ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"08","Tipo ?  	 	 "	,"Tipo ? "			,"Tipo ?  "		,"mv_ch8","N",01,0,0,"C","          ","mv_par08","En Abierto","En Abierto","En Abierto","","","Cerrado","Cerrado","Cerrado","","","Ambos","Ambos","Ambos","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"09","Produto ?  	 "	,"Produto ? "		,"Produto ?  "	,"mv_ch9","C",15,0,0,"C","          ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"10","Produto ?  	 "	,"Produto ? "		,"Produto ?  "	,"mv_chA","C",15,0,0,"C","          ","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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