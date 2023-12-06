/*/{Protheus.doc} DISFTCO02
Disparador para nuevo precio de Lista con descuentos internos en PEdidos de Venta
@type function
@version  
@author AxelDiaz
@since 18/6/2021
@param nPrcLst, numeric, Descuentoi Interno Encabezado
@param nDescST, numeric, Descuento Interno por Linea
@return return_type, return_description
DA1->DA1_PRCVEN*(100-M->C5_XDESCUE)/100 
/*/
USER FUNCTION DISFTC02(nPrcLst,nDescST)  //Precio Venta Sin Descuento, Descuento Steck Interno en Linea
    Local nVal := 0
    nVal:=nPrcLst *( ( 100 - M->C5_XDESCUE ) / 100);
                  *( ( 100 - nDescST       ) / 100)
RETURN nVal

