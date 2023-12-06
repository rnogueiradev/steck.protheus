#INCLUDE "PROTHEUS.CH"

//===================================================================================================================================
/*/{Protheus.doc} FILTRREM
   Filtro para transmisi�n de remitros electr�nicos. Usado en espec�fico de transmisi�n masiva.
   
   @type    User FunctionS
   @author  Alejandro Perret
   @since   27/06/22
   @version 1.0
/*/
//===================================================================================================================================

User Function FILTRREM()

Local cQuery    := ParamIxb[1]

If FwIsInCallStack("U_STACO310") .And. (Type("_aRecnosRem") == 'A') .And. !Empty(_aRecnosRem)    // Espec�fico de Transmisi�n Masiva de Remitos (STACO310.prw)
    cQuery := U_STACO311(cQuery)  // Filtro en consulta de transmisi�n de remitos para que devuelva �nicamente los registros seleccionados en el MarkBrowse.
EndIf

Return(cQuery)
