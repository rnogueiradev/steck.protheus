#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} STEST008

Posição do Estoque por Endereço com Custo Unitário

@type function
@author Everson Santana
@since 22/02/19
@version Protheus 12 - Estoque/Custos

@history , ,

/*/

User Function STEST008()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STEST008", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""

	ValidPerg()

	//Pergunte(_cPerg,.T.)

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

	_cTitulo := "Posicao do Estoque por Endereço com Custo Unitario"

	_oReport := TReport():New("STEST008",_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	_oSecCab := TRSection():New( _oReport , "_cTitulo", {"QRY"} )

	TRCell():New( _oSecCab, "BF_FILIAL"		,,"Filial 		" ,PesqPict('SBF',"BF_FILIAL")	,TamSX3("BF_FILIAL")[1],.F.,)
	TRCell():New( _oSecCab, "BF_PRODUTO"	,,"Codigo		" ,PesqPict('SBF',"BF_PRODUTO")	,TamSX3("BF_PRODUTO")[1],.F.,)
	TRCell():New( _oSecCab, "B1_DESC"		,,"Descrição	" ,PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1],.F.,)
	TRCell():New( _oSecCab, "BF_LOCAL"  	,,"Local	    " ,PesqPict('SBF',"BF_LOCAL")	,TamSX3("BF_LOCAL")[1]	,.F.,)
	TRCell():New( _oSecCab, "BF_LOCALIZ"   	,,"Enderço      " ,PesqPict('SBF',"BF_LOCALIZ")	,TamSX3("BF_LOCALIZ")[1],.F.,)
	TRCell():New( _oSecCab, "BF_QUANT"   	,,"Saldo   		" ,PesqPict('SBF',"BF_QUANT")	,TamSX3("BF_QUANT")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_CMFIM1"   	,,"Vlr Unitario " ,PesqPict('SB2',"B2_CMFIM1")	,TamSX3("B2_CMFIM1")[1]	,.F.,)

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

	_cQuery += " SELECT SBF.BF_FILIAL,SBF.BF_PRODUTO,SB1.B1_DESC,SBF.BF_LOCAL,SBF.BF_LOCALIZ,SBF.BF_QUANT,SB2.B2_CMFIM1   
	_cQuery += " FROM "+RetSqlName("SBF")+" SBF 
	_cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1
	_cQuery += " ON SB1.B1_COD = SBF.BF_PRODUTO
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '
	_cQuery += " LEFT JOIN "+RetSqlName("SB2")+" SB2 
	_cQuery += " ON SB2.B2_COD = SBF.BF_PRODUTO
	_cQuery += " AND SB2.B2_LOCAL = SBF.BF_LOCAL
	_cQuery += " AND SB2.D_E_L_E_T_ = ' '
	_cQuery += " WHERE SBF.BF_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	_cQuery += " AND SBF.BF_LOCAL BETWEEN '"+MV_PAR03+" ' AND '"+MV_PAR04+"'
	_cQuery += " AND SBF.BF_LOCALIZ BETWEEN '"+MV_PAR05+" ' AND '"+MV_PAR06+"'
	_cQuery += " AND SBF.D_E_L_E_T_ = ' '

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	_nLin := 70
	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("BF_FILIAL"):SetValue(QRY->BF_FILIAL)
		_oSecCab:Cell("BF_PRODUTO"):SetValue(QRY->BF_PRODUTO)
		_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		_oSecCab:Cell("BF_LOCAL"):SetValue(QRY->BF_LOCAL)
		_oSecCab:Cell("BF_LOCALIZ"):SetValue(QRY->BF_LOCALIZ)
		_oSecCab:Cell("BF_QUANT"):SetValue(QRY->BF_QUANT)
		_oSecCab:Cell("B2_CMFIM1"):SetValue(QRY->B2_CMFIM1)

		_oSecCab:PrintLine()

		_nLin += 15

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

	AADD(_aRegs,{_cPerg,"01","Da Produto?  	 "	,"Da Produto? "		,"Da Produto?  ","mv_ch1","C",15,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(_aRegs,{_cPerg,"02","Ate Produto?   "	,"Ate Produto? "	,"Ate Produto? ","mv_ch2","C",15,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(_aRegs,{_cPerg,"03","Do Local?	 "		,"Do Local? "		,"Do Local?"	,"mv_ch3","C",02,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Ate Local? "		,"Ate Local? "		,"Ate Local?"	,"mv_ch4","C",02,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","Do Endereço?	 "	,"Do Endereço? "	,"Do Endereço?"	,"mv_ch5","C",15,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})
	AADD(_aRegs,{_cPerg,"06","Ate Endereço? "	,"Ate Endereço? "	,"Ate Endereço?","mv_ch6","C",15,0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})

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