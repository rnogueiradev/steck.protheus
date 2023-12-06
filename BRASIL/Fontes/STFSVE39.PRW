#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STFSVE39         | Autor | RENATO.NOGUEIRA          | Data | 23/11/2015  |
|=====================================================================================|
|Descrição |Monta tela de markup do orçamento										  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\=====================================================================================
*/

//   iif(_cuserid='000645',iif(ZZI->ZZI_TIPO ='ORÇAMENTO',U_STFSVE39(.F.,.T.) , ZZI->ZZI_MARKUP),ZZI->ZZI_MARKUP)

User Function STFSVE39(_lTela,_lSua,_cTab)

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local aCampoEdit	:= {}
	Local lSaida 		:= .T.
	Local _aCols		:= {}
	Local bOk 			:= {||(	lSaida:=.f., lConfirma:=.T.,oDlg:End()) }
	Local bCancel		:= {||(	lSaida:=.f.,oDlg:End()) }
	Local aButtons	:= {}
	Local oGet
	Local _aStruTrb 	:= {} //estrutura do temporario
	Local oDlg
	Local _lCriou
	Local oOk   	   	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	      	:= LoadBitmap( GetResources(), "LBNO" )
	Local oLbx
	Local nValCusto		:= 0
	Local nY		:= 0
	Local _nMkpFinal := 0
	Local _cCampo := ""
	Default _cTab := "SUA"
	Default _lTela := .T.
	Default _lSua	:= .T.

	If _lTela
		If ! __cUserId $ GetMv("ST_MKPORCA")
			MsgAlert("Usuário sem acesso a rotina de markup")
			Return()
		EndIf
	EndIf

	//Define campos do TRB

	AADD(_aStruTrb,{"Item"		,"ITEM"	,"@!"						,03, ,,,"C","","R",})
	AADD(_aStruTrb,{"Produto"	,"PRODUTO"	,"@!"						,15, ,,,"C","","R",})
	AADD(_aStruTrb,{"Descrição"	,"DESCRI"	,"@!"						,50, ,,,"C","","R",})
	AADD(_aStruTrb,{"Qtde"		,"QTDE"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Preço"		,"PRECO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Custo"		,"CUSTO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Markup"		,"MARKUP"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})

	If AllTrim(_cTab)=="SUA"

		cQuery := " SELECT UB_ITEM, UB_PRODUTO, B1_DESC, UB_QUANT, UB_XCUSTO, UB_ZVALLIQ
		cQuery += " FROM "+RetSqlName("SUB")+" UB "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
		cQuery += " ON B1_COD=UB_PRODUTO "
		cQuery += " WHERE UB.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND UB_FILIAL='"+SUA->UA_FILIAL+"'
		cQuery += " AND UB_NUM='"+Iif(_lSua,SUA->UA_NUM,ZZI->ZZI_NUM)+"' "
		cQuery += " ORDER BY UB_ITEM "

		_cCampo := "UB_"

	Else

		cQuery := " SELECT C6_ITEM, C6_PRODUTO, B1_DESC, C6_QTDVEN, C6_XCUSTO, C6_ZVALLIQ
		cQuery += " FROM "+RetSqlName("SC6")+" C6 "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
		cQuery += " ON B1_COD=C6_PRODUTO "
		cQuery += " WHERE C6.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND C6_FILIAL='"+SC5->C5_FILIAL+"'
		cQuery += " AND C6_NUM='"+SC5->C5_NUM+"' "
		cQuery += " ORDER BY C6_ITEM "

		_cCampo := "C6_"

	EndIf

	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)
	_nTotCus:=0
	_nTotPrc:=0
	While (cAlias)->(!Eof())

		AADD(_aCols,Array(Len(_aStruTrb)+1))

		For nY := 1 To Len(_aStruTrb)

			nValCusto	:= IIF((cAlias)->&(_cCampo+"XCUSTO") <> 0,(cAlias)->&(_cCampo+"XCUSTO") ,U_STCUSTO((cAlias)->&(_cCampo+"PRODUTO")) )

			_nQuant := 0
			If AllTrim(_cTab)=="SUA"
				_nQuant := (cAlias)->UB_QUANT
			Else
				_nQuant := (cAlias)->C6_QTDVEN
			EndIf

			DO CASE
				CASE AllTrim(_aStruTrb[nY][2]) =  "ITEM"
				_aCols[Len(_aCols)][nY] := (cAlias)->&(_cCampo+"ITEM")
				CASE AllTrim(_aStruTrb[nY][2]) =  "PRODUTO"
				_aCols[Len(_aCols)][nY] := (cAlias)->&(_cCampo+"PRODUTO")
				CASE AllTrim(_aStruTrb[nY][2]) =  "DESC"
				_aCols[Len(_aCols)][nY] := (cAlias)->B1_DESC
				CASE AllTrim(_aStruTrb[nY][2]) =  "QTDE"
				_aCols[Len(_aCols)][nY] := _nQuant
				CASE AllTrim(_aStruTrb[nY][2]) =  "CUSTO"
				_aCols[Len(_aCols)][nY] := nValCusto
				CASE AllTrim(_aStruTrb[nY][2]) =  "PRECO"
				_aCols[Len(_aCols)][nY] := ((cAlias)->&(_cCampo+"ZVALLIQ")/_nQuant)
				CASE AllTrim(_aStruTrb[nY][2]) =  "MARKUP"
				_aCols[Len(_aCols)][nY] := ((cAlias)->&(_cCampo+"ZVALLIQ")/_nQuant)/nValCusto
			ENDCASE

		Next

		_nTotCus+=	nValCusto
		_nTotPrc+=	(cAlias)->&(_cCampo+"ZVALLIQ")/_nQuant

		_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.

		(cAlias)->(DbSkip())
	EndDo

	AADD(_aCols,Array(Len(_aStruTrb)+1))
	For nY := 1 To Len(_aStruTrb)
		DO CASE
			CASE AllTrim(_aStruTrb[nY][2]) =  "PRODUTO"
			_aCols[Len(_aCols)][nY] := "TOTAL"
			CASE AllTrim(_aStruTrb[nY][2]) =  "MARKUP"
			_aCols[Len(_aCols)][nY] := _nTotPrc/_nTotCus
			_nMkpFinal := _aCols[Len(_aCols)][nY]
		ENDCASE
	Next
	_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.

	aCampoEdit := {"OK"}

	If _lTela
		While lSaida
			DEFINE MSDIALOG oDlg FROM 0,0 TO 500,1100/*500,1200*/ TITLE Alltrim(OemToAnsi('Markup')) Pixel //430,531

			oGet	:= MsNewGetDados():New( 50,  0,  225,550, /*GD_UPDATE*/ ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,oDlg, _aStruTrb, _aCols )

			//@ 90,00 PSAY "Total markup: "+CVALTOCHAR(SUA->UA_ZVALLIQ/SUA->UA_XCUSTO)

			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
		End
	EndIf

Return(_nMkpFinal)
