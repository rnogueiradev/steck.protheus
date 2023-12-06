#INCLUDE "PROTHEUS.CH"

//===================================================================================================================================
/*/{Protheus.doc} FILTRREM
   Filtro para transmisión de remitros electrónicos. Usado en específico de transmisión masiva.
   
   @type    User FunctionS
   @author  Alejandro Perret
   @since   27/06/22
   @version 1.0
/*/
//===================================================================================================================================

User Function FILTRREM()

Local cQuery    := ParamIxb[1]

If FwIsInCallStack("U_STACO310") .And. (Type("_aRecnosRem") == 'A') .And. !Empty(_aRecnosRem)    // Específico de Transmisión Masiva de Remitos (STACO310.prw)
    cQuery := U_STACO311(cQuery)  // Filtro en consulta de transmisión de remitos para que devuelva únicamente los registros seleccionados en el MarkBrowse.
EndIf

Return(cQuery)
