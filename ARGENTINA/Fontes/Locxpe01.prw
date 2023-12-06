#INCLUDE "PROTHEUS.CH"

#DEFINE SnTipo      1

//===================================================================================================================================
/*/{Protheus.doc} Locxpe01
   Agrega botones de usuario en pantallas de la locxnf
   
   @type    User Function
   @author  Alejandro Perret
   @since   29/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function Locxpe01()
Local aRet := {}

If aCfgNF[SnTipo] == 4			// Nota de crédito cliente 
	AAdd(aRet ,	{'PEDIDO'   , {|| U_STACO30C()}, "Asistente para vincular Solicitudes de devolución", "Solicitudes de devolución", "3" })	
	AAdd(aRet ,	{'DESCUENTO', {|| U_STCO302H()}, "Asistente para vincular Descuentos Calculados"    , "Descuentos SELL OUT", "3" })	
EndIf

Return(aRet)
