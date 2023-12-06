
/*/{Protheus.doc} STDTOSS
Recibe una Fecha y devuelve "YYYY-MM-DD"
@type function
@version 
@author AxelDiaz
@since 22/11/2020
@param dFecha, date, param_description
@return return_type, return_description
dISPARADORES
C5_XORDEM -> "ORDC/"+ALLTRIM(M->C5_XORDEM)+"/"+U_STDTOSS(M->C5_XDTORDC) -> C5_UUIDREL
C5_XDTORDC -> "ORDC/"+ALLTRIM(M->C5_XORDEM)+"/"+U_STDTOSS(M->C5_XDTORDC) -> C5_UUIDREL
/*/
User Function STDTOSS(dFecha)
Local cFecha:=DTOS(dFecha)
Return cfecha:=LEFT(cFecha,4)+"-"+SUBSTR(cFecha,5,2)+"-"+RIGHT(cFecha,2)
