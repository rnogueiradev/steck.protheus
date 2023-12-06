#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//===================================================================================================================================
/*/{Protheus.doc} CRM980MDef
   PE para agregar botones al browse de Clientes
   
   @type    User Function
   @author  Alejandro Perret
   @since   31/05/21
   @version 1.0
/*/
//===================================================================================================================================

User Function CRM980MDef()
Local aRet := {}

AAdd(aRet,{"Aprobaciones",{{"Aprobar","U_STACO305(.T.)" , 0 , 2,0 ,NIL},{"Rechazar","U_STACO305(.F.)" , 0 , 2,0 ,NIL}} , 0 , 2,0 ,NIL})	// "Boton Aprobaciones"
AAdd(aRet,{"Historial Aprobaciones","U_STCO305H()" , 0 , 2,0 ,NIL})

Return(aRet)
