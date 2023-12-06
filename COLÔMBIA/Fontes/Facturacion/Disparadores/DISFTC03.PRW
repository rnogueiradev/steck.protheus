/*/{Protheus.doc} DISFTC03
disparador que cambia el precio de la lista de precios tomando en cuenta el descuento interno en linea y de emcabezado
@type function
@version  
@author AxelDiaz
@since 20/6/2021
@param nPrcLst, numeric, param_description
@param nDescST, numeric, param_description
@param nDescPr, numeric, param_description
@return return_type, return_description
(M->CK_QTDVEN*DA1->DA1_PRCVEN*(100-M->CJ_DESC1)*(100-M->CK_DESCONT)*(100-M->CJ_XDESCUE)/1000000)   
U_DISFTC03(DA1->DA1_PRCVEN,TMP1->CK_XDESCUE,TMP1->CK_DESCONT)
/*/
USER FUNCTION DISFTC03(nPrcLst,nDescST,nDescPr)  //Precio Venta Sin Descuento, Descuento Steck Interno y Descuento Estandar Protheus
    Local nVal := 0
    nVal:=nPrcLst*( ( 100 - M->CJ_XDESCUE ) / 100 );
                 *( ( 100 - M->CJ_DESC1   ) / 100 );
                 *( ( 100 - M->CJ_DESC2   ) / 100 );
                 *( ( 100 - M->CJ_DESC3   ) / 100 );
                 *( ( 100 - M->CJ_DESC4   ) / 100 );
                 *( ( 100 - nDescPr       ) / 100 );
                 *( ( 100 - nDescST       ) / 100 )
RETURN nVal
