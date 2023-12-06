/*/{Protheus.doc} LXDORIG
Para modificar los ítems de una NCC a partir de un documento origen, existe el punto de entrada LXDORIG. Este punto de entrada fue habilitado para permitir modificar los ítems de una NCC cuando es registrada a partir de un documento origen.
Para el punto de entrada LXDORIG se recomienda tener las siguientes consideraciones:
- El punto de entrada es detona por cada ítem del documento origen.
- El punto de entrada no recibe ningún parámetro y tampoco retorna algún valor.
- Para identificar el ítem que será modificado, se recomiendo usar la función LEN(). Ejemplo: Len(aCols).
@type function
@version  
@author AxelDiaz
@since 7/7/2021
@return variant, return_description
/*/
User function LXDORIG()

Local aArea    := GetArea()   
Local aAreaSF2 := SF2->(GetArea())
Local nX       := 0   
Local nPosSer  := GdFieldPos( "D1_SERIORI", aHeader )       
Local nPosDoc  := GdFieldPos( "D1_NFORI", aHeader )       
Local nPosCli  := GdFieldPos( "D1_FORNECE", aHeader )       
Local nPosLoj  := GdFieldPos( "D1_LOJA", aHeader )       
Local cDocum   := aCols[1,nPosDoc]
Local cSer     := aCols[1,nPosSer]
Local cCliFor  := aCols[1,nPosCli]
Local cLoja    := aCols[1,nPosLoj]
/*/
// traer campos especificos STECK de Factura para NCC
If nTipo == 4 
        SF2->(DbSetOrder(1))   
        IF SF2->(MsSeek(xFilial("SF2")+cDocum+cSer+cCliFor+cLoja))
                M->F1_XFORNEC:= SF2->F2_XFORNEC
                M->F1_XLOJA  := SF2->F2_XLOJA
                M->F1_XDOC   := SF2->F2_XDOC
                M->F1_XSERIE := SF2->F2_XSERIE
                M->F1_XTPED  := SF2->F2_XTPED        
        ENDIF
ENFIF
/*/
RestArea(aArea)                 
RestArea(aAreaSF2)
return
