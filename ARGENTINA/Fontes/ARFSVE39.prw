#Include "Totvs.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/{Protheus.doc} ARFSVE39
(long_description) Monta tela de Markup do Pedido de Venda
@type  Static Function
@author Eduardo Pereira
@since 08/10/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function ARFSVE39(_lTela)	// ARFSVE39(_lTela,_lSua,_cTab)

Local aCampoEdit	:= {}
Local lSaida 		:= .T.
Local _aCols		:= {}
Local bOk 			:= {||(	lSaida := .F., lConfirma := .T., oDlg:End()) }
Local bCancel		:= {||(	lSaida := .F., oDlg:End()) }
Local aButtons		:= {}
Local oGet
Local _aStruTrb 	:= {} // Estrutura do temporario
Local oDlg
Local nValCusto		:= 0
Local _n01			:= 0
Local _n02			:= 0
Local nY 			:= 1
Local _lRet 		:= .T.
Local aRet			:= {}
Local aParam		:= {}
Default _lTela 		:= .T.

aAdd(aParam,{1, "Taxa China", 0, "@E 99.99", "", "", "", 40, .T.})
aAdd(aParam,{1, "Taxa Brasil", 0, "@E 99.99", "", "", "", 40, .T.})

If !_lTela
	Mv_Par01 := 1
Else
	If !ParamBox(aParam, "Informe o Percentual", @aRet,,, .T.,, 500)
		Return
	EndIf
EndIf

aAdd(_aStruTrb,{"Item"		,"ITEM"		,"@!"					,03, ,,,"C","","R",})
aAdd(_aStruTrb,{"Produto"	,"PRODUTO"	,"@!"					,15, ,,,"C","","R",})
aAdd(_aStruTrb,{"Descrição"	,"DESCRI"	,"@!"					,50, ,,,"C","","R",})
aAdd(_aStruTrb,{"QUANTIDADE","QUANT"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Preço"		,"PRECO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Custo NAC"	,"CUSTO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Custo FOB"	,"CUSTO2"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Markup"	,"MARKUP"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Prc.Tot."	,"PRC.TOT"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
aAdd(_aStruTrb,{"Cus.Tot"	,"CUSTO.TOT","@E 99,999,999,999.99"	,14,2,,,"N","","R",})

cQuery := " SELECT "	+ CRLF
cQuery += " 	C6_ITEM, C6_PRODUTO, B1_DESC, C6_QTDVEN, C6_PRCVEN, C6_LOCAL, B1_CLAPROD, B1_XPAIS "	+ CRLF
cQuery += " FROM " + RetSqlName("SC6") + " C6 "					+ CRLF
cQuery += " LEFT JOIN " + RetSqlName("SB1") + " B1 "			+ CRLF
cQuery += " ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ' ' "	+ CRLF
cQuery += " WHERE C6.D_E_L_E_T_ = ' ' "							+ CRLF
cQuery += " 	AND C6_FILIAL = '" + SC5->C5_FILIAL + "' "		+ CRLF
cQuery += " 	AND C6_NUM = '" + SC5->C5_NUM + "' "			+ CRLF
cQuery += " ORDER BY C6_ITEM "									+ CRLF

cAlias := GetNextAlias()
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

_nCustoTot := 0

While (cAlias)->( !Eof() )
	aAdd(_aCols,Array(Len(_aStruTrb) + 1))
	nValCusto := Posicione("SB2",1,xFilial("SB2") + (cAlias)->C6_PRODUTO + (cAlias)->C6_LOCAL,"B2_CMRP2")	// Iif((cAlias)->CUSTO>0,(cAlias)->CUSTO,U_STCUSTO((cAlias)->PRODUTO)/MV_PAR01)
	For nY := 1 To Len(_aStruTrb)
		Do Case
			Case AllTrim(_aStruTrb[nY][2]) == "ITEM"
				_aCols[Len(_aCols)][nY] := (cAlias)->C6_ITEM
			Case AllTrim(_aStruTrb[nY][2]) == "PRODUTO"
				_aCols[Len(_aCols)][nY] := (cAlias)->C6_PRODUTO
			Case AllTrim(_aStruTrb[nY][2]) == "DESCRI"
				_aCols[Len(_aCols)][nY] := Alltrim((cAlias)->B1_DESC)
			Case AllTrim(_aStruTrb[nY][2]) == "PRECO"
				_aCols[Len(_aCols)][nY] := (cAlias)->C6_PRCVEN
			Case AllTrim(_aStruTrb[nY][2]) == "QUANT"
				_aCols[Len(_aCols)][nY] := (cAlias)->C6_QTDVEN
			Case AllTrim(_aStruTrb[nY][2]) == "PRC.TOT"
				_aCols[Len(_aCols)][nY] := (cAlias)->C6_PRCVEN * (cAlias)->C6_QTDVEN
			Case AllTrim(_aStruTrb[nY][2]) == "CUSTO.TOT"
				_aCols[Len(_aCols)][nY] := nValCusto * (cAlias)->C6_QTDVEN
				_nCustoTot += _aCols[Len(_aCols)][nY]
			Case AllTrim(_aStruTrb[nY][2]) == "CUSTO"
				If UPPER(AllTrim((cAlias)->B1_XPAIS)) == "CHINA"
					_aCols[Len(_aCols)][nY] := nValCusto + ((aRet[1]/100) * nValCusto)
				Else
					_aCols[Len(_aCols)][nY] := nValCusto + ((aRet[2]/100) * nValCusto)
				EndIf
			Case AllTrim(_aStruTrb[nY][2]) == "CUSTO2"
				_aCols[Len(_aCols)][nY] := nValCusto
			Case AllTrim(_aStruTrb[nY][2]) == "MARKUP"
				If UPPER(AllTrim((cAlias)->B1_XPAIS)) == "CHINA"
					_aCols[Len(_aCols)][nY] := ((cAlias)->C6_PRCVEN - (nValCusto + ((aRet[1]/100) * nValCusto))) / (nValCusto + ((aRet[1]/100) * nValCusto))
				Else
					_aCols[Len(_aCols)][nY] := ((cAlias)->C6_PRCVEN - (nValCusto + ((aRet[2]/100) * nValCusto))) / (nValCusto + ((aRet[2]/100) * nValCusto))
				EndIf
				// Totalizadores
				_n01 += (cAlias)->C6_PRCVEN * (cAlias)->C6_QTDVEN
				_n02 += nValCusto * (cAlias)->C6_QTDVEN
		EndCase
	Next
	_aCols[Len(_aCols)][Len(_aStruTrb) + 1] := .F.
	(cAlias)->( dbSkip() )
EndDo

aAdd(_aCols,Array(Len(_aStruTrb) + 1))

_nMarkTot := (_n01 - _n02) / _n02

If _nMarkTot < 0.45
	_lRet := .F.
EndIf

_aCols[Len(_aCols)][02] := 'Total'
//_aCols[Len(_aCols)][07] := _nMarkTot
_aCols[Len(_aCols)][08] :=  _nMarkTot
_aCols[Len(_aCols)][09] :=  _n01
_aCols[Len(_aCols)][10] :=  _nCustoTot
_aCols[Len(_aCols)][Len(_aStruTrb) + 1] := .F.

aCampoEdit := {"OK"}

If _lTela
	While lSaida
		DEFINE MSDIALOG oDlg FROM 0,0 TO 570,1430/*500,1200*/ TITLE Alltrim(OemToAnsi('Markup')) Pixel //430,531
		oGet := MsNewGetDados():New( 035, 005, 280, 713, /*GD_UPDATE*/ ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,oDlg, _aStruTrb, _aCols )
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
	End
EndIf

Return _lRet
