#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STESTR07()

Relatorio com as Ultimas Movimentações no Estoque   

@type function
@author Everson Santana
@since 22/05/20
@version Protheus 12 - SigaEst

@history ,Ticket 20200515002235 ,

/*/

User Function STESTR07()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STESTR07", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Relatorio com as Ultimas Movimentações no Estoque"

	_oReport := TReport():New("STESTR07"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("STESTR07",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "B1_COD"		,,RetTitle("B1_COD")		,PesqPict('SB1',"B1_COD")		,TamSX3("B1_COD")[1]		,.F.,)//01
	TRCell():New( _oSecCab, "B1_DESC"		,,RetTitle("B1_DESC") 		,PesqPict('SB1',"B1_DESC")		,TamSX3("B1_DESC")[1]		,.F.,)//02
	TRCell():New( _oSecCab, "DB_LOCAL"    	,,RetTitle("DB_LOCAL") 		,PesqPict('SDB',"DB_LOCAL")		,TamSX3("DB_LOCAL")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "DB_LOCALIZ"    ,,RetTitle("DB_LOCALIZ") 	,PesqPict('SDB',"DB_LOCALIZ")	,TamSX3("DB_LOCALIZ")[1]	,.F.,)//04
	TRCell():New( _oSecCab, "DB_QUANT"    	,,"Qtd Ult Entrada"			,PesqPict('SDB',"DB_QUANT")		,TamSX3("DB_QUANT")[1]		,.F.,)//04  
	TRCell():New( _oSecCab, "DB_DATA"    	,,"Dt Ult Entrada" 			,PesqPict('SDB',"DB_DATA")		,TamSX3("DB_DATA")[1]		,.F.,)//04  
	TRCell():New( _oSecCab, "DB_QUANTSAI"  	,,"Qtd Ult Saida" 			,PesqPict('SDB',"DB_QUANT")		,TamSX3("DB_QUANT")[1]		,.F.,)//04  
	TRCell():New( _oSecCab, "DB_DATASAI"	,,"Dt Ult Saida"			,PesqPict('SDB',"DB_DATA")		,TamSX3("DB_DATA")[1],		.F.,)//05

	
Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	
	_cQuery += " SELECT B1.B1_COD, "
    _cQuery += "   B1.B1_DESC, "
    _cQuery += "   DBENT.DB_LOCAL, "
    _cQuery += "   DBENT.DB_LOCALIZ, "
    _cQuery += "   DBENT.DB_QUANT QTDENT, "
    _cQuery += "   DBENT.DB_DATA DTENT, "
    _cQuery += "   DBSAI.DB_QUANT QTDSAI, "
    _cQuery += "   DBSAI.DB_DATA DTSAI "
	_cQuery += " FROM "+RetSqlName("SB1")+" B1 "
 	_cQuery += " INNER JOIN "+RetSqlName("SDB")+" DBENT "
    _cQuery += " 	ON DBENT.DB_PRODUTO = B1.B1_COD "
    _cQuery += "    AND DBENT.DB_LOCAL = '"+MV_PAR01+"' "
    _cQuery += "    AND DBENT.DB_TM <= 499  " //-- Entrada
    _cQuery += "    AND DBENT.DB_DATA = (SELECT MAX(DB_DATA) FROM "+RetSqlName("SDB")+" DBENT1 "
	_cQuery += "            WHERE DBENT1.DB_PRODUTO =  DBENT.DB_PRODUTO "
    _cQuery += "            AND DBENT1.DB_LOCAL = '"+MV_PAR01+"' "
    _cQuery += "            AND DBENT1.DB_TM <= 499  " //-- Entrada
    _cQuery += "            AND DBENT1.D_E_L_E_T_ = ' ') "
    _cQuery += "    AND DBENT.D_E_L_E_T_ = ' ' "
  	_cQuery += " INNER JOIN "+RetSqlName("SDB")+" DBSAI "
    _cQuery += "	ON DBSAI.DB_PRODUTO = B1.B1_COD "
    _cQuery += "    AND DBSAI.DB_LOCAL = '"+MV_PAR01+"' "
    _cQuery += "    AND DBSAI.DB_TM >= 500  " //-- Saida
    _cQuery += "    AND DBSAI.DB_DATA = (SELECT MAX(DB_DATA) FROM "+RetSqlName("SDB")+" DBSAI1 "
    _cQuery += "        WHERE DBSAI1.DB_PRODUTO =  DBSAI.DB_PRODUTO "
    _cQuery += "            AND DBSAI1.DB_LOCAL = '"+MV_PAR01+"' "
    _cQuery += "            AND DBSAI1.DB_TM >= 500  " //-- Saida
    _cQuery += "            AND DBSAI1.D_E_L_E_T_ = ' ') "
    _cQuery += "    AND DBSAI.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE B1.B1_COD Between '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	_cQuery += " 	AND B1.B1_GRUPO Between '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	_cQuery += " AND B1.D_E_L_E_T_ = ' ' "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("B1_COD"):SetValue(QRY->B1_COD)
		_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		_oSecCab:Cell("DB_LOCAL"):SetValue(QRY->DB_LOCAL)
		_oSecCab:Cell("DB_LOCALIZ"):SetValue(QRY->DB_LOCALIZ)
		_oSecCab:Cell("DB_QUANT"):SetValue(QRY->QTDENT)
		_oSecCab:Cell("DB_DATA"):SetValue(Stod(QRY->DTENT))
		_oSecCab:Cell("DB_QUANTSAI"):SetValue(QRY->QTDSAI)
		_oSecCab:Cell("DB_DATASAI"):SetValue(Stod(QRY->DTSAI))

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
	AADD(_aRegs,{_cPerg,"01","Armazem ? "		,"Armazem ? "		,"Armazem ?  "		,"mv_ch1","C",02,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Do Produto ? "	,"Do Produto ? "	,"Do Produto ?  "	,"mv_ch2","C",15,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
	AADD(_aRegs,{_cPerg,"03","Ate Produto ? "	,"Ate Produto ? "	,"Ate Produto ?  "	,"mv_ch3","C",15,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
	AADD(_aRegs,{_cPerg,"04","Do Grupo ? "		,"Do Grupo ? "	 	,"Do Grupo ?  "		,"mv_ch4","C",03,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
	AADD(_aRegs,{_cPerg,"05","Ate Grupo ? "		,"Ate Grupo ? "	 	,"Ate Grupo ?  "	,"mv_ch5","C",03,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})

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