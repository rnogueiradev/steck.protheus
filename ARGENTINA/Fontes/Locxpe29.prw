#INCLUDE "PROTHEUS.CH"

#DEFINE SnTipo      1

//===================================================================================================================================
/*/{Protheus.doc} Locxpe29
   Actualizaciones al eliminar un documento de la locxnf
   
   @type    User Function
   @author  Alejandro Perret
   @since   29/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function Locxpe29()
Local aArea    := Getarea()

If aCfgNF[SnTipo] == 4			// Nota de crédito cliente 
   U_STACO30D('A', '', '')  //Actualiza el estado de la solicitud de devolución vinculada a la NCC.
   U_STCO302T('C', '', '', SF1->F1_XSELOUT) //Actualiza el estado Periodo de venta SELL OUT (ZD6) inculada a la NCC.
EndIf

Restarea(aArea)
Return()
