/*/{Protheus.doc} M465DORIFE
Para controlar que facturas requieren validacion de facturacion electróinica
@type function
@version 
@author Axel Diaz
@since 10/8/2020
@return return_type, return_description
/*/
User function M465DORIFE()
        Local lRet      := .F.
        Local cCRLF     := (chr(13) + chr(10) )
        Local cFilDoc   := PARAMIXB[1]              // Sucursal
        Local cNumDoc   := PARAMIXB[2]              // Número de Documento
        Local cSerieDoc := PARAMIXB[3]              // Serie
        Local cCodCli   := PARAMIXB[4]              // Código de Cliente
        Local cCodLoj   := PARAMIXB[5]              // Código de Tienda
// Crear parametro CO_SERTRFE y agregar series de factura electronica que requieren validación de transmisión en NCC/NCD.
//IF  !(cESPECIE$'RCD')
        IF  (cESPECIE$'NCC')     
                RETURN .F.
        ENDIF  
        If Alltrim(cSerieDoc) $ AllTrim(GetNewPar("CO_SERTRFE",""))     //"NCE|NDE|FVE"   Serie de factura seleccionada o relacionada.
                lRet := .T.
        EndIf

        If Alltrim(M->F1_SERIE) $ AllTrim(GetNewPar("CO_SERTRFE",""))   //  Serie de nota credito/debito seleccionada.
                lRet := .T.
        EndIf
//EndIf
//CESPECIE=='RCD' // Remito Devolucion
//CFUNNAME=='MATA102DN' // Remito Devolcion
//CFILD1D2=="F2_TIPODOC $ '61'"

Return .F.
