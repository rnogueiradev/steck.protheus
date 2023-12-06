#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | ARPRCPC         | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | CARREGA PRECO NO PEDIDO DE COMPRA		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARPRCPC(_cProduto)

	Local _nPreco 	:= 0
	Local _cQuery1 	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local lSaida    := .F.
	Local nOpcao    := 1

	if IsInCallStack("U_STKIMP")
		Return(_nPreco)
	endif

	If !IsInCallStack("U_ARCOM010")
		If SubStr(_cProduto,1,1)$"E#U" //Produtos de uso/consumo

			Do While !lSaida

				Define msDialog oDxlg Title "Digite o preço" From 10,10 TO 150,200 Pixel

				@ 010,010 say "Preço:  "  Of oDxlg Pixel
				@ 010,030 get _nPreco picture "@E 999,999,999.99"  when .T. size 050,08  Of oDxlg Pixel
				@ 030,030 Button "&Confirma" size 40,14  action ((lSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel

				Activate dialog oDxlg centered

			EndDo		

		Else

			_cQuery1 := " SELECT *
			_cQuery1 += " FROM UDBP12.DA1010 DA1
			_cQuery1 += " WHERE DA1.D_E_L_E_T_=' ' AND DA1_CODPRO='"+_cProduto+"' AND DA1_CODTAB='T04'

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(Eof())
				MsgAlert("Atención, precio no encontrado en la tabla T04, compruebe!")
				Return(0)
			EndIf

			_nPreco := (_cAlias1)->DA1_PRCVEN

		EndIf
	EndIf

	//M->C7_PRECO := _nPreco
	//M->C7_TOTAL := NoRound(M->C7_PRECO*M->C7_QUANT,TamSX3("C7_TOTAL")[2])                               
	//M->C7_TOTAL := If(A120Trigger("C7_TOTAL"),M->C7_TOTAL,0)                                            

Return(_nPreco)

/*====================================================================================\
|Programa  | ARPRCPC1        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | CARREGA PRECO NO PEDIDO DE COMPRA		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARPRCPC1()

	Local _nTotal 	:= 0
	Local _nPosQtd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
	Local _nPosPrc 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
	Local _nPosTot 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})

	if IsInCallStack("U_STKIMP")
		Return(_nTotal)
	endif
	
	aCols[n][_nPosTot] := NoRound(aCols[n][_nPosQtd]*aCols[n][_nPosPrc],2)
	_nTotal := aCols[n][_nPosTot]
	M->C7_TOTAL := _nTotal
	oObj := GetObjBrow()
	oObj:Refresh()
	
	A120Trigger("C7_PRECO")
	A120Trigger("C7_QUANT")
	MaFisAlt("IT_VALMERC",NoRound(aCols[n][_nPosPrc]*aCols[n][_nPosQtd],2),n)
	A120Refresh(aValores)
	aObj:= Array(24)
	A120FRefresh(aObj)

Return(_nTotal)
