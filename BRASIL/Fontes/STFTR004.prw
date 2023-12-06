#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STFTR004()

Pedidos em Carteira     

@type function
@author Everson Santana
@since 06/03/2020
@version Protheus 12 - SigaFat

@history ,Ticket 20200306000879 ,

/*/

User Function STFTR004()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := " " //PadR ("STESTR06", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _oBreak

	//ValidPerg()

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

	_cTitulo := "Pedidos em Carteira"

	_oReport := TReport():New("STFTR004"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	//Pergunte("STESTR06",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "C6_NUM"		,,RetTitle("C6_NUM")	,PesqPict('SC6',"C6_NUM")		,TamSX3("C6_NUM")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "C6_PRODUTO"	,,RetTitle("C6_PRODUTO"),PesqPict('SC6',"C6_PRODUTO")	,TamSX3("C6_PRODUTO")[1],.F.,)//02
	TRCell():New( _oSecCab, "C6_QTDVEN"    	,,"Carteira"			,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1]	,.F.,)//03

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _nLin		  := 0

	_cQuery += " SELECT SC6.c6_num PEDIDO,SC6.c6_produto PRODUTO,(SC6.c6_qtdven - SC6.c6_qtdent) CARTEIRA "
	_cQuery += "	FROM   "+RetSqlName("SC6")+" SC6"
    _cQuery += "               inner join(SELECT * FROM "+RetSqlName("SC5")+") SC5"
    _cQuery += "                           ON SC5.c5_num = SC6.c6_num "
    _cQuery += "                          AND SC5.d_e_l_e_t_ = ' ' "
    _cQuery += "                          AND SC5.c5_filial = SC6.c6_filial "
    _cQuery += "  WHERE  SC6.d_e_l_e_t_ = ' ' "
    _cQuery += "               AND SC5.c5_xtronf = ' ' "
    _cQuery += "               AND SC6.c6_filial = '"+xFilial("SC6")+"' "
    _cQuery += "               AND SC6.c6_oper <> '38' "
    _cQuery += "               AND SC6.c6_oper <> '11' "
    _cQuery += "               AND SC6.c6_oper <> '95' "
    _cQuery += "               AND SC6.c6_oper <> '11' "
    _cQuery += "               AND SC6.c6_blq <> 'R' "
    _cQuery += "               AND NOT EXISTS(SELECT *"
    _cQuery += "                              FROM   "+RetSqlName("SC9")+" SC9 "
    _cQuery += "                              WHERE  SC9.d_e_l_e_t_ = ' ' "
    _cQuery += "                                     AND SC9.c9_pedido = SC6.c6_num "
    _cQuery += "                                     AND SC9.c9_blcred IN ( '01', '09' ) "
    _cQuery += "                                     AND SC9.c9_filial = SC6.c6_filial) "
    _cQuery += "               AND SC6.c6_qtdven - SC6.c6_qtdent > 0 "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("C6_NUM"):SetValue(QRY->PEDIDO)
		_oSecCab:Cell("C6_PRODUTO"):SetValue(QRY->PRODUTO)
		_oSecCab:Cell("C6_QTDVEN"):SetValue(QRY->CARTEIRA)
		
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