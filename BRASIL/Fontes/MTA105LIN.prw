#include 'protheus.ch'
#include 'parmtype.ch'

/*Ponto-de-Entrada: MTA105LIN - Valida os dados na linha da solicita��o ao almoxarifado digitada*/

User Function MTA105LIN()

	Local aAreaSCP 	:= GetArea()
	Local lRet		:= .T.
	LOcal nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2])="CP_PRODUTO"})
	Local cProduto	:= aCols[n,nPosProd]
	Local cTpProd	:= "" 
	Local nX		:= 0
	For nX:= 1 To Len(aCols)
		If !(aCols[nX,Len(aHeader)+1])
			SB1->(dbSeek(xFilial("SB1")+aCols[nX][nPosProd]))
			cTpProd := SB1->B1_TIPO
			Exit
		EndIf
	Next

	If !Empty(cTpProd)
		For nX:= 1 To Len(aCols)
			If !(aCols[nX,Len(aHeader)+1])

				SB1->(dbSeek(xFilial("SB1")+aCols[nX][nPosProd]))

				If cTpProd != SB1->B1_TIPO
					msgStop("N�o � permitido solicita��o com produtos de apropria��o indireta diferentes, exclua o item para prosseguir.","Valida��o")
					lRet := .F.
				EndIf

			EndIf
		Next
	EndIf

	RestArea(aAreaSCP)

Return(lRet)