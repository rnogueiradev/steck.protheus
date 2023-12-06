#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} PEF053
@name PEF053
@type User Function
@desc portal do fornecedor - alterar campos dos itens (pedido)
@author Renato Nogueira
@since 29/05/2018
/*/

User Function PEF053()

	Local cParam  := PARAMIXB[1]
	Local aReturn := {}
	Local _nX	  := 0

	Do Case
		Case cParam == 1 // Cabecalho
		Case cParam == 2 //Itens

		For _nX:=1 To Len(httpSession->PWSF051HEADER[2])
			//aAdd( aReturn, { httpSession->PWSF051HEADER[2][_nX]:CHEADERFIELD , httpSession->PWSF051HEADER[2][_nX]:CHEADERTYPE , httpSession->PWSF051HEADER[2][_nX]:NHEADERDEC , httpSession->PWSF051HEADER[2][_nX]:LHEADEROBLIG } )
			aAdd( aReturn, httpSession->PWSF051HEADER[2][_nX]:CHEADERFIELD )
		Next

		aAdd( aReturn,"C7_XDATPRF")
		aAdd( aReturn,"C7_TPFRETE")

	EndCase

Return(aReturn)