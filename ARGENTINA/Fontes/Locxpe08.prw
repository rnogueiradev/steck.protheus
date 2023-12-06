#INCLUDE "PROTHEUS.CH"

#DEFINE SnTipo      1

//===================================================================================================================================
/*/{Protheus.doc} Locxpe08
   Realiza grabaciones adicionales en documentos de la locxnf
   
   @type    User Function
   @author  Alejandro Perret
   @since   29/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function Locxpe08()
Local aArea := Getarea()

If aCfgNF[SnTipo] == 4			// Nota de crédito cliente 
   U_STACO30D('N', SF1->F1_SERIE, SF1->F1_DOC)  //Actualiza el estado de la solicitud de devolución vinculada a la NCC.
   U_STCO302S('F', SF1->F1_SERIE, SF1->F1_DOC, SF1->F1_XSELOUT) //Actualiza el estado de SELL OUT (ZD6) vinculada la NCC.

EndIf

Restarea(aArea)
Return()
