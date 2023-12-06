/*/{Protheus.doc} DISFTCO01
Disparador para Precio de Venta en PEdidos de Venta
@type function
@version 000 
@author AxelDiaz
@since 18/6/2021
@param nPrcVen, numeric, Precio Venta Sin Descuento
@param nDescST, numeric, Descuento Steck Interno
@param nDescPr, numeric, Descuento Estandar Protheus
@return return_type, Precio Venta
// (DA1->DA1_PRCVEN*(100-M->C5_DESC1)*(100-M->C6_DESCONT)*(100-M->C5_XDESCUE))/1000000
// U_DISFTCO01(DA1->DA1_PRCVEN,M->C6_XDESCUE,M->C6_DESCONT)
/*/
USER FUNCTION DISFTC01(nPrcLst,nDescST,nDescPr)  //Precio Venta Sin Descuento, Descuento Steck Interno y Descuento Estandar Protheus
    Local nVal := 0
    nVal:=nPrcLst*( ( 100 - M->C5_XDESCUE ) / 100 );
                 *( ( 100 - M->C5_DESC1   ) / 100 );
                 *( ( 100 - M->C5_DESC2   ) / 100 );
                 *( ( 100 - M->C5_DESC3   ) / 100 );
                 *( ( 100 - M->C5_DESC4   ) / 100 );
                 *( ( 100 - nDescPr       ) / 100 );
                 *( ( 100 - nDescST       ) / 100 )
RETURN nVal
