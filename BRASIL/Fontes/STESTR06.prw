#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STESTR06()

Itens da NF de Importação     

@type function
@author Everson Santana
@since 04/12/18
@version Protheus 12 - SigaEst

@history ,Ticket 20200113000019 ,

/*/

User Function STESTR06()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STESTR06", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _oBreak

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

	_cTitulo := "Itens da NF de Importação"

	_oReport := TReport():New("STESTR06"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("STESTR06",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "WN_FILIAL"		,,RetTitle("WN_FILIAL")	,PesqPict('SWN',"WN_FILIAL")	,TamSX3("WN_FILIAL")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "WN_HAWB"		,,RetTitle("WN_HAWB") 	,PesqPict('SWN',"WN_HAWB")		,TamSX3("WN_HAWB")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "WN_DOC"    	,,RetTitle("WN_DOC") 	,PesqPict('SWN',"WN_DOC")		,TamSX3("WN_DOC")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "WN_SERIE"    	,,RetTitle("WN_SERIE") 	,PesqPict('SWN',"WN_SERIE")		,TamSX3("WN_SERIE")[1]	,.F.,)//04
	TRCell():New( _oSecCab, "WN_TEC"    	,,RetTitle("WN_TEC") 	,PesqPict('SWN',"WN_TEC")		,TamSX3("WN_TEC")[1]	,.F.,)//04  
	TRCell():New( _oSecCab, "D1_EMISSAO"	,,RetTitle("D1_EMISSAO"),PesqPict('SD1',"D1_EMISSAO")	,TamSX3("D1_EMISSAO")[1],.F.,)//05
	TRCell():New( _oSecCab, "D1_DTDIGIT"	,,RetTitle("D1_DTDIGIT"),PesqPict('SD1',"D1_DTDIGIT")	,TamSX3("D1_DTDIGIT")[1],.F.,)//05
	TRCell():New( _oSecCab, "D1_CF"			,,RetTitle("D1_CF")		,PesqPict('SD1',"D1_CF")		,TamSX3("D1_CF")[1],.F.,)//05
	TRCell():New( _oSecCab, "WN_PRODUTO"    ,,RetTitle("WN_PRODUTO"),PesqPict('SWN',"WN_PRODUTO")	,TamSX3("WN_PRODUTO")[1],.F.,)//06
	TRCell():New( _oSecCab, "WN_QUANT"    	,,RetTitle("WN_QUANT")	,PesqPict('SWN',"WN_QUANT")		,TamSX3("WN_QUANT")[1]	,.F.,)//08
	TRCell():New( _oSecCab, "WN_VALOR"  	,,RetTitle("WN_VALOR")	,PesqPict('SWN',"WN_VALOR")		,TamSX3("WN_VALOR")[1]	,.F.,)//07
	TRCell():New( _oSecCab, "WN_VALIPI"    	,,RetTitle("WN_VALIPI")	,PesqPict('SWN',"WN_VALIPI")	,TamSX3("WN_VALIPI")[1]	,.F.,)//09
	TRCell():New( _oSecCab, "WN_VALICM"   	,,RetTitle("WN_VALICM")	,PesqPict('SWN',"WN_VALICM")	,TamSX3("WN_VALICM")[1]	,.F.,)//10
	TRCell():New( _oSecCab, "WN_PRECO"   	,,RetTitle("WN_PRECO")	,PesqPict('SWN',"WN_PRECO")		,TamSX3("WN_PRECO")[1]	,.F.,)//10	  
	TRCell():New( _oSecCab, "WN_UNI"   		,,RetTitle("WN_UNI")	,PesqPict('SWN',"WN_UNI")		,TamSX3("WN_UNI")[1]	,.F.,)//11
	TRCell():New( _oSecCab, "WN_IIVAL"   	,,RetTitle("WN_IIVAL")	,PesqPict('SWN',"WN_IIVAL")		,TamSX3("WN_IIVAL")[1]	,.F.,)//12
	TRCell():New( _oSecCab, "WN_CIF"		,,RetTitle("WN_CIF")	,PesqPict('SWN',"WN_CIF")		,TamSX3("WN_CIF")[1]	,.F.,)//13
	TRCell():New( _oSecCab, "WN_SEGURO"		,,RetTitle("WN_SEGURO")	,PesqPict('SWN',"WN_SEGURO")	,TamSX3("WN_SEGURO")[1]	,.F.,)//14
	TRCell():New( _oSecCab, "WN_FRETE"    	,,RetTitle("WN_FRETE")	,PesqPict('SWN',"WN_FRETE")		,TamSX3("WN_FRETE")[1]	,.F.,)//15
	TRCell():New( _oSecCab, "WN_FORNECE"    ,,RetTitle("WN_FORNECE"),PesqPict('SWN',"WN_FORNECE")	,TamSX3("WN_FORNECE")[1],.F.,)//16
	TRCell():New( _oSecCab, "WN_LOJA"    	,,RetTitle("WN_LOJA") 	,PesqPict('SWN',"WN_LOJA")		,TamSX3("WN_LOJA")[1]	,.F.,)//17
	TRCell():New( _oSecCab, "WN_INVOICE"   	,,RetTitle("WN_INVOICE"),PesqPict('SWN',"WN_INVOICE")	,TamSX3("WN_INVOICE")[1],.F.,)//18
	TRCell():New( _oSecCab, "WN_VLRPIS"   	,,RetTitle("WN_VLRPIS")	,PesqPict('SWN',"WN_VLRPIS")	,TamSX3("WN_VLRPIS")[1]	,.F.,)//18
	TRCell():New( _oSecCab, "WN_VLRCOF"   	,,RetTitle("WN_VLRCOF") ,PesqPict('SWN',"WN_VLRCOF")	,TamSX3("WN_VLRCOF")[1]	,.F.,)//18	
	TRCell():New( _oSecCab, "WN_FOB_R"   	,,RetTitle("WN_FOB_R")  ,PesqPict('SWN',"WN_FOB_R")		,TamSX3("WN_FOB_R")[1]	,.F.,)//18
	TRCell():New( _oSecCab, "WN_DESPICM"   	,,RetTitle("WN_DESPICM"),PesqPict('SWN',"WN_DESPICM")	,TamSX3("WN_DESPICM")[1],.F.,)//18
	TRCell():New( _oSecCab, "WN_DESPADU"   	,,RetTitle("WN_DESPADU"),PesqPict('SWN',"WN_DESPADU")	,TamSX3("WN_DESPADU")[1],.F.,)//18
	TRCell():New( _oSecCab, "WN_VLCOFM"   	,,RetTitle("WN_VLCOFM")	,PesqPict('SWN',"WN_VLCOFM")	,TamSX3("WN_VLCOFM")[1]	,.F.,)//18

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _nLin		  := 0

	_cQuery += " SELECT WN_FILIAL,WN_HAWB,WN_DOC,WN_SERIE,WN_TEC,D1.D1_EMISSAO,D1.D1_DTDIGIT,D1.D1_CF,WN_PRODUTO,WN_QUANT,WN_VALOR,WN_VALIPI,WN_VALICM,WN_UNI,WN_IIVAL,WN_CIF,WN_SEGURO,WN_FRETE,WN_FORNECE,WN_LOJA,WN_INVOICE, "
	_cQuery += " WN_VLRPIS,WN_VLRCOF,WN_FOB_R,WN_DESPICM,WN_DESPADU,WN_VLCOFM,WN_PRECO "
	_cQuery += " FROM "+RetSqlName("SWN")+" WN "
	_cQuery += " LEFT JOIN "+RetSqlName("SD1")+" D1 "
	_cQuery += " ON D1.D1_FILIAL = WN.WN_FILIAL "
	_cQuery += "    AND D1.D1_FORNECE = WN.WN_FORNECE "
	_cQuery += "    AND D1.D1_LOJA = WN.WN_LOJA "
	_cQuery += "    AND D1.D1_COD = WN.WN_PRODUTO "
	_cQuery += "    AND D1.D1_DOC = WN.WN_DOC "
	_cQuery += "    AND D1.D1_SERIE = WN.WN_SERIE " 
	_cQuery += "    AND D1.D1_ITEM = LPAD(WN.WN_LINHA,4,0) "
	_cQuery += "    AND D1.D_E_L_E_T_ = ' ' "        
	_cQuery += " WHERE WN.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D1.D1_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("WN_FILIAL"):SetValue(QRY->WN_FILIAL)
		_oSecCab:Cell("WN_HAWB"):SetValue(QRY->WN_HAWB)
		_oSecCab:Cell("WN_DOC"):SetValue(QRY->WN_DOC)
		_oSecCab:Cell("WN_SERIE"):SetValue(QRY->WN_SERIE)
		_oSecCab:Cell("WN_TEC"):SetValue(QRY->WN_TEC)
		_oSecCab:Cell("D1_EMISSAO"):SetValue(Stod(QRY->D1_EMISSAO))
		_oSecCab:Cell("D1_DTDIGIT"):SetValue(Stod(QRY->D1_DTDIGIT))
		_oSecCab:Cell("D1_CF"):SetValue(QRY->D1_CF)
		_oSecCab:Cell("WN_PRODUTO"):SetValue(QRY->WN_PRODUTO)
		_oSecCab:Cell("WN_QUANT"):SetValue(QRY->WN_QUANT)
		_oSecCab:Cell("WN_VALOR"):SetValue(QRY->WN_VALOR)
		_oSecCab:Cell("WN_VALIPI"):SetValue(QRY->WN_VALIPI)
		_oSecCab:Cell("WN_VALICM"):SetValue(QRY->WN_VALICM)
		_oSecCab:Cell("WN_PRECO"):SetValue(QRY->WN_PRECO)		
		_oSecCab:Cell("WN_UNI"):SetValue(QRY->WN_UNI)
		_oSecCab:Cell("WN_IIVAL"):SetValue(QRY->WN_IIVAL)
		_oSecCab:Cell("WN_CIF"):SetValue(QRY->WN_CIF)
		_oSecCab:Cell("WN_SEGURO"):SetValue(QRY->WN_SEGURO)
		_oSecCab:Cell("WN_FRETE"):SetValue(QRY->WN_FRETE)
		_oSecCab:Cell("WN_FORNECE"):SetValue(QRY->WN_FORNECE)
		_oSecCab:Cell("WN_LOJA"):SetValue(QRY->WN_LOJA)
		_oSecCab:Cell("WN_INVOICE"):SetValue(QRY->WN_INVOICE)
		_oSecCab:Cell("WN_VLRPIS"):SetValue(QRY->WN_VLRPIS)
		_oSecCab:Cell("WN_VLRCOF"):SetValue(QRY->WN_VLRCOF)
		_oSecCab:Cell("WN_FOB_R"):SetValue(QRY->WN_FOB_R)
		_oSecCab:Cell("WN_DESPICM"):SetValue(QRY->WN_DESPICM)
		_oSecCab:Cell("WN_DESPADU"):SetValue(QRY->WN_DESPADU)
		_oSecCab:Cell("WN_VLCOFM"):SetValue(QRY->WN_VLCOFM)

		_oSecCab:PrintLine()

		QRY->(DbSkip())

	EndDo

	_oReport:ThinLine()

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
	AADD(_aRegs,{_cPerg,"01","De Dt Emissao? "	,"De Dt Emissao "	,"De Dt Emissao  "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ate Dt Emissao? "	,"Ate Dt Emissao "	,"De Dt Emissao  "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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