#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} PEF062
@name PEF062
@type User Function
@desc portal do fornecedor - alterar campos
@author Renato Nogueira
@since 29/05/2018
/*/

User Function PEF062()

	Local aReturn := {}
	Local _nX     := 0

	For _nX:=1 To Len(httpSession->PWSF061HEADER[1][1])
		If _nX==2
			aAdd( aReturn,"C8_NUMPED")
		Else
			aAdd( aReturn, httpSession->PWSF061HEADER[1][1][_nX]:CHEADERFIELD )
		EndIf
	Next

Return(aReturn)