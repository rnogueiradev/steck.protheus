#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} STCO302M
PE para Rutina de Descuento Sell Out
	
@author Alejandro Perret	
@since 21/06/2016
@version 1.0		
/*/

User Function STCO302M()
Local aParam	:= PARAMIXB
Local xRet 		:= .T.
Local oObj 		:= ''
Local cIdPonto 	:= ''
Local cIdModel 	:= ''
Local lIsGrid 	:= .F.
Local nLinha 	:= 0
Local nQtdLinhas:= 0
Local cMsg 		:= ''
Local cAccion	:= ""

If aParam <> NIL
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	
	lIsGrid := (Len(aParam) > 3)

	Do Case
		Case cIdPonto == 'MODELPOS'
			// MsgInfo("MODELPOS")

		Case cIdPonto == 'FORMPRE'


		Case cIdPonto == 'FORMPOS'
			// MsgInfo("FORMPOS")

		Case cIdPonto == 'FORMLINEPRE'
			// MsgInfo("FORMLINEPRE")

		Case cIdPonto == 'FORMLINEPOS'
			// MsgInfo("FORMLINEPOS")

		Case cIdPonto == 'MODELCOMMITTTS'		// no espera retorno
			If Type('_lCalcDesc') == 'L' .And. _lCalcDesc
				U_STCO302G()	// Actualizacion del estado del periodo (Calculo efectuado)
			EndIf
		Case cIdPonto == 'MODELCOMMITNTTS'		// no espera retorno
			// MsgInfo("MODELCOMMITNTTS")

		Case cIdPonto == 'FORMCOMMITTTSPRE' 	// no espera retorno
			// MsgInfo("FORMCOMMITTTSPRE")
		
		Case cIdPonto == 'FORMCOMMITTTSPOS'		// no espera retorno
			// MsgInfo("FORMCOMMITTTSPOS")
		
		Case cIdPonto == 'MODELCANCEL'
			// MsgInfo("MODELCANCEL")
			
		Case cIdPonto == 'MODELVLDACTIVE'		
			// MsgInfo("MODELVLDACTIVE")

		Case cIdPonto == 'BUTTONBAR'			// espera un array 
			If /*aParam[3] == "ZD5DETAIL" .And.*/ Type('_lCalcDesc') == 'L' .And. _lCalcDesc .And. !FWIsInCallStack("ADDLINE")
				U_STCO302F()	// Función de cálculo de descuentos 
				xRet := {}
			EndIf
		
	EndCase
EndIf
Return(xRet)
