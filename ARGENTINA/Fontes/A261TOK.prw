#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} A261TOK

Ponto de entrada para validar se o campo lote de destino está preenchido

@type function
@author Everson Santana
@since 07/03/19
@version Protheus 12 - Estoque/Custos

@history ,Chamado 009277 ,

/*/

User Function A261TOK()

	Local lRet := .T.
	Local _nLotDest := aScan(aHeader,{|x| AllTrim(x[1]) == "Lote Destino"})
	Local _nProd	:= aScan(aHeader,{|x| AllTrim(x[1]) == "Prod.Destino"})
	Local _cRasto	:= ""
	Local _n	:= 0

	For _n := 1 to Len(aCols)

		_cRasto := Posicione("SB1",1,xFilial('SB1')+aCols[_n][_nProd],"B1_RASTRO")

		If _cRasto $ "l#L"

			If Empty(aCols[_n][_nLotDest])

				lRet :=	.F.

			EndIf
		EndIf

	Next _n

	If !lRet

		MsgAlert("Compruebe el campo de lote de destino.","A261TOK")

	EndIf

Return lRet