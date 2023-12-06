#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} STCO300M
PE para Rutina de Solicitudes de devolucion
	
@author Alejandro Perret	
@since 21/06/2016
@version 1.0		
/*/

User Function STCO300M()
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
Local nI 		:= 0

If aParam <> NIL
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	
	lIsGrid := (Len(aParam) > 3)

	Do Case
		Case cIdPonto == 'MODELPOS'

		Case cIdPonto == 'FORMPRE'
			If lIsGrid .And. (aParam[5] == "UNDELETE")
				nQtdLinhas := oObj:GetQtdLine()
				nLinha := aParam[4]

				cItAtu := FWFldGet("ZD2_ITEORI", nLinha)
				If !Empty(cItAtu)
					For nI := 1 To nQtdLinhas
						If nI == nLinha
							Loop
						EndIf

						If !oObj:IsDeleted(nI) .And. cItAtu == FWFldGet("ZD2_ITEORI", nI)
							xRet := .F.
							Help(NIL, NIL, "No se permite reactivar la línea.", NIL, "Esta línea esta vinculada a un ítem de factura " + ;
							"ya vinculado en este documento. Vínculo existente en el ítem: " + FWFldGet("ZD2_ITEM", nI), 1, 0)
							Exit
						EndIf
					Next
				EndIf
			EndIf

		Case cIdPonto == 'FORMPOS'

		Case cIdPonto == 'FORMLINEPRE'

		Case cIdPonto == 'FORMLINEPOS'

		Case cIdPonto == 'MODELCOMMITTTS'		// no espera retorno

		Case cIdPonto == 'MODELCOMMITNTTS'		// no espera retorno

		Case cIdPonto == 'FORMCOMMITTTSPRE' 	// no espera retorno
		
		Case cIdPonto == 'FORMCOMMITTTSPOS'		// no espera retorno
		
		Case cIdPonto == 'MODELCANCEL'
			
		Case cIdPonto == 'MODELVLDACTIVE'		

		Case cIdPonto == 'BUTTONBAR'			// espera un array 
		
	EndCase
EndIf
Return(xRet)
