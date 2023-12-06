#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_ARFATR06()

 informe cantidad de bultos por separacion y remito de venta

@type function
@author Everson Santana
@since 01/07/2021
@version Protheus 12 - SigaFat

@history ,Ticket 20210520008306 ,

/*/

User Function ARFATR06()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARFATR06", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Informe cantidad de bultos por separacion y remito de venta"

	_oReport := TReport():New("ARFATR06"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("ARFATR06",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "CB7_DTEMIS"	,,RetTitle("CB7_DTEMIS")	,PesqPict('CB7',"CB7_DTEMIS")	,TamSX3("CB7_DTEMIS")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "CB7_NOTA"		,,RetTitle("CB7_NOTA") 		,PesqPict('CB7',"CB7_NOTA")		,TamSX3("CB7_NOTA")[1]		,.F.,)//02
	TRCell():New( _oSecCab, "CB6_XORDSE"    ,,RetTitle("CB6_XORDSE") 	,PesqPict('CB7',"CB6_XORDSE")	,TamSX3("CB6_XORDSE")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "SOMA"    		,,"Soma" 					,"@!"							,10							,.F.,)//04
	TRCell():New( _oSecCab, "CB6_XPESO"    	,,RetTitle("CB6_XPESO") 	,PesqPict('CB6',"CB6_XPESO")	,TamSX3("CB6_XPESO")[1]		,.F.,)//04  
	
Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += " SELECT DISTINCT CB7.CB7_DTEMIS, CB7.CB7_NOTA , CB6_XORDSE,
	_cQuery += " (SELECT COUNT(*) FROM CB6070 "+RetSqlName("CB6")+" WHERE CB7_ORDSEP = CB6_XORDSE AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' AND CB6.D_E_L_E_T_ = ' ' ) SOMA,
 	_cQuery += " (SELECT SUM(CB6.CB6_XPESO) FROM "+RetSqlName("CB6")+" CB6 WHERE CB7_ORDSEP = CB6_XORDSE AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' AND CB6.D_E_L_E_T_ = ' ' ) PESO
	_cQuery += " FROM "+RetSqlName("CB7")+" CB7
	_cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("CB6")+") CB6
	_cQuery += " ON CB7_ORDSEP = CB6_XORDSE AND CB6.D_E_L_E_T_ = ' ' AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"'
	_cQuery += " WHERE CB7.D_E_L_E_T_ = ' ' AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' AND CB7.CB7_SERIE = 'R'
	_cQuery += " AND CB7_DTEMIS BETWEEN  '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("CB7_DTEMIS"):SetValue(Stod(QRY->CB7_DTEMIS))
		_oSecCab:Cell("CB7_NOTA"):SetValue(QRY->CB7_NOTA)
		_oSecCab:Cell("CB6_XORDSE"):SetValue(QRY->CB6_XORDSE)
		_oSecCab:Cell("SOMA"):SetValue(QRY->SOMA)
		_oSecCab:Cell("CB6_XPESO"):SetValue(QRY->PESO)
		
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