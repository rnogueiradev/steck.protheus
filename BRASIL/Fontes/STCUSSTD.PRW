#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCUSSTD        | Autor | RENATO.OLIVEIRA           | Data | 14/01/2019  |
|=====================================================================================|
|Descrição | Tela para acompanhamento de pedidos/orçamentos sem custo                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCUSSTD(aArray1,aArray2)

	Local _aArea1 := {}
	Local _nX := 0
	Local _nW := 0
	Local _nWY := 0

	_nTotMP 	:= 0
	_nTotMOD 	:= 0
	_nTotMOM	:= 0
	_nTotBn		:= 0
	_lZerPerc 	:= .F.

	_aArea1 := GetArea()
	SB1->(DbSetOrder(1))

	For _nX:=2 To Len(aArray1[2])

		SB1->(DbSeek(xFilial("SB1")+aArray1[2][_nX][4]))

		If AllTrim(aArray1[2][_nX][4])=="MOD120121"
			aArray1[2][_nX][9] := "BN"
			aArray1[2][_nX][5] := aArray1[2][_nX-1][5]
		EndIf

		If !("---" $ aArray1[2][_nX][2])
			If AllTrim(UPPER(aArray1[2][_nX][9]))=="MO"
				If "DVC" $ aArray1[2][_nX][4]
					_nTotMOD += aArray1[2][_nX][6]
				Else
					_nTotMOM += aArray1[2][_nX][6]
				EndIf
			ElseIf (AllTrim(UPPER(aArray1[2][_nX][9])))=="BN"
				_nTotBN += aArray1[2][_nX][6]
				//ElseIf !(AllTrim(UPPER(aArray1[2][_nX][9])))$"PA#PI"
			ElseIf SB1->B1_CLAPROD=="C" .Or. SB1->B1_CLAPROD=="I"
				_nTotMP += aArray1[2][_nX][6]
			EndIf
		EndIf

		If "MATERIA PRIMA" $ aArray1[2][_nX][3]
			aArray1[2][_nX][6] := _nTotMP
			aArray1[2][_nX][7] := (_nTotMP/(_nTotMP+_nTotMOD+_nTotMOM+_nTotBN))*100
		EndIf
		If "BENEFICIAMENTO" $ aArray1[2][_nX][3]
			aArray1[2][_nX][6] := _nTotBN
			aArray1[2][_nX][7] := (_nTotBN/(_nTotMP+_nTotMOD+_nTotMOM+_nTotBN))*100
		EndIf
		If IsInCallStack("MATC010")
			If "MAO DE OBRA" $ aArray2[2][_nX][3]
				aArray1[2][_nX][6] := _nTotMOM
				aArray1[2][_nX][7] := (_nTotMOM/(_nTotMP+_nTotMOD+_nTotMOM+_nTotBN))*100
			EndIf
		Else
			If "MAO DE OBRA" $ aArray1[2][_nX][3]
				aArray1[2][_nX][3] := "TOTAL DE MAO DE OBRA DVC"
				aArray1[2][_nX][6] := _nTotMOD
				aArray1[2][_nX][7] := (_nTotMOD/(_nTotMP+_nTotMOD+_nTotMOM+_nTotBN))*100
			EndIf
			If "GASTOS GERAIS" $ aArray1[2][_nX][3]
				aArray1[2][_nX][3] := "TOTAL DE MAO DE OBRA MBC"
				aArray1[2][_nX][6] := _nTotMOM
				aArray1[2][_nX][7] := (_nTotMOM/(_nTotMP+_nTotMOD+_nTotMOM+_nTotBN))*100
			EndIf
		EndIf
		If "CUSTO TOTAL DO PRODUTO" $ aArray1[2][_nX][3]
			aArray1[2][_nX][6] := _nTotMOD+_nTotMOM+_nTotMP+_nTotBN
		EndIf
		If "PRECO DE VENDA SUGERIDO" $ aArray1[2][_nX][3]
			aArray1[2][_nX][6] := _nTotMOD+_nTotMOM+_nTotMP+_nTotBN
		EndIf
		If "QUANTIDADE BASICA...." $ aArray1[2][_nX][3]
			_lZerPerc := .T.
		EndIf
		If _lZerPerc
			aArray1[2][_nX][7] := 0
		EndIf

	Next

	aArray1[2][1][6] := _nTotMOD+_nTotMOM+_nTotMP+_nTotBN
	//aAuxCusto[1] := Round(aArray1[2][1][6]/aArray1[2][1][5],5)
	aAuxCusto[1] := aArray1[2][1][6]

	//VALORES ORIGINAIS

	_nCusOri := 0

	For _nWy:=1 To Len(aArray2[2])

		_nCusOri := 0

		For _nW:=1 To Len(_aCusOri)
			If AllTrim(_aCusOri[_nW][1])==AllTrim(aArray2[2][_nWy][04])
				_nCusOri := _aCusOri[_nW][2]
				Exit
			EndIf
		Next

		If _nCusOri > 0

			aArray2[2][_nWy][06] := _nCusOri*aArray2[2][_nWy][05]

		EndIf

		If SubStr(AllTrim(aArray2[2][_nWy][04]),1,3)=="DVC" .Or. SubStr(AllTrim(aArray2[2][_nWy][04]),1,3)=="MBC"

			_aArea := GetArea()

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			If SB1->(DbSeek(xFilial("SB1")+aArray2[2][_nWy][18]))

				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				SB2->(DbGoTop())
				If SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))

					aArray2[2][_nWy][06] := SB2->B2_CM1/2*aArray2[2][_nWy][05]

				EndIf

			EndIf

			RestArea(_aArea)

		EndIf

	Next

	_nTotMP1 	:= 0
	_nTotMOD1 	:= 0
	_nTotMOM1	:= 0
	_nTotBN1	:= 0
	_lZerPerc1 	:= .F.

	//If UPPER(aPar[12])=="S"
	For _nX:=2 To Len(aArray2[2])

		SB1->(DbSeek(xFilial("SB1")+aArray2[2][_nX][4]))

		If AllTrim(aArray2[2][_nX][4])=="MOD120121"
			aArray2[2][_nX][9] := "BN"
			aArray2[2][_nX][5] := aArray2[2][_nX-1][5]
		EndIf

		If !("---" $ aArray2[2][_nX][2])
			If AllTrim(UPPER(aArray2[2][_nX][9]))=="MO"
				If "DVC" $ aArray2[2][_nX][4]
					_nTotMOD1 += aArray2[2][_nX][6]
				Else
					_nTotMOM1 += aArray2[2][_nX][6]
				EndIf
			ElseIf (AllTrim(UPPER(aArray2[2][_nX][9])))=="BN"
				_nTotBN1 += aArray2[2][_nX][6]
				//ElseIf !(AllTrim(UPPER(aArray2[2][_nX][9])))$"PA#PI"
			ElseIf SB1->B1_CLAPROD=="C" .Or. SB1->B1_CLAPROD=="I"
				_nTotMP1 += aArray2[2][_nX][6]
			EndIf
		EndIf

		If "MATERIA PRIMA" $ aArray2[2][_nX][3]
			aArray2[2][_nX][6] := _nTotMP1
			aArray2[2][_nX][7] := (_nTotMP1/(_nTotMP1+_nTotMOD1+_nTotMOM1+_nTotBN1))*100
		EndIf
		If "BENEFICIAMENTO" $ aArray2[2][_nX][3]
			aArray2[2][_nX][6] := _nTotBN1
			aArray2[2][_nX][7] := (_nTotBN1/(_nTotMP1+_nTotMOD1+_nTotMOM1+_nTotBN1))*100
		EndIf
		If IsInCallStack("MATC010")
			If "MAO DE OBRA" $ aArray2[2][_nX][3]
				aArray2[2][_nX][6] := _nTotMOM1
				aArray2[2][_nX][7] := (_nTotMOM1/(_nTotMP1+_nTotMOD1+_nTotMOM1+_nTotBN1))*100
			EndIf
		Else
			If "MAO DE OBRA" $ aArray2[2][_nX][3]
				aArray2[2][_nX][3] := "TOTAL DE MAO DE OBRA DVC"
				aArray2[2][_nX][6] := _nTotMOD1
				aArray2[2][_nX][7] := (_nTotMOD1/(_nTotMP1+_nTotMOD1+_nTotMOM1+_nTotBN1))*100
			EndIf
			If "GASTOS GERAIS" $ aArray2[2][_nX][3]
				aArray2[2][_nX][3] := "TOTAL DE MAO DE OBRA MBC"
				aArray2[2][_nX][6] := _nTotMOM1
				aArray2[2][_nX][7] := (_nTotMOM1/(_nTotMP1+_nTotMOD1+_nTotMOM1+_nTotBN1))*100
			EndIf
		EndIf
		If "CUSTO TOTAL DO PRODUTO" $ aArray2[2][_nX][3]
			aArray2[2][_nX][6] := _nTotMOD1+_nTotMOM1+_nTotMP1+_nTotBN1
		EndIf
		If "PRECO DE VENDA SUGERIDO" $ aArray1[2][_nX][3]
			aArray2[2][_nX][6] := _nTotMOD1+_nTotMOM1+_nTotMP1+_nTotBN1
		EndIf
		If "QUANTIDADE BASICA...." $ aArray2[2][_nX][3]
			_lZerPerc := .T.
		EndIf
		If _lZerPerc
			aArray2[2][_nX][7] := 0
		EndIf

	Next

	aArray2[2][1][6] := _nTotMOD1+_nTotMOM1+_nTotMP1+_nTotBN1
	//aAuxCusto[1] := Round(aArray2[2][1][6]/aArray2[2][1][5],5)

	//EndIf

	RestArea(_aArea1)

Return(aArray1)