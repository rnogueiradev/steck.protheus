#INCLUDE "PROTHEUS.CH"

#DEFINE SnTipo      1

//===================================================================================================================================
/*/{Protheus.doc} Locxpe16
   Validaci�n de Todo Ok en pantallas de la locxnf
   
   @type    User Function
   @author  Alejandro Perret
   @since   29/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function Locxpe16()
Local aArea    := Getarea()
Local lRet     := .T.

If aCfgNF[SnTipo] == 4		// Nota de cr�dito cliente 
   lRet := U_STACO30E()       // Antes de grabar la NCC valida que la solicitud de devoluc�on no haya cambiado de estado (concurrencia).         
EndIf

Restarea(aArea)
Return(lRet)
