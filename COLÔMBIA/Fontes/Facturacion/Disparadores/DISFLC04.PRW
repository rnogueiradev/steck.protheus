/*/{Protheus.doc} DISFTC04
disparador que cambia el precio de la lista de precios tomando en cuenta el descuento interno en linea y de emcabezado
@type function
@version  
@author AxelDiaz
@since 20/6/2021
@param nPrcLst, numeric, param_description
@param nDescST, numeric, param_description
@return return_type, return_description
/*/
USER FUNCTION DISFTC04(nPrcLst,nDescST)  //Precio Venta Sin Descuento, Descuento Steck Interno en Linea
    Local nVal := 0
    nVal:=nPrcLst *( ( 100 - M->CJ_XDESCUE ) / 100);
                  *( ( 100 - nDescST       ) / 100)
RETURN nVal
