#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#DEFINE CRLF chr(13)+chr(10)
#DEFINE LF chr(10)

/*/{Protheus.doc} Impust
Lee la salida de Impuyestos para facturacion Eletrónica y quita los impuestos que tiene 0 CERO
Revisa impuesto de ICA y envia el porcentaje sobre 1000s
Esta funcion es llamada desde los Archivos .INI en \system\cfd\INICOLS\
@type function
@version 
@author Axel Diaz
@since 25/10/2020
@param atemp3, array, param_description
@return return_type, return_description
/*/
User function Impust(atemp3)
    Local cText     := ''
    Local atemp4
    Local aTemp5    := {}
    Local aTemp6    := {}
    Local lDentro   := .f.
    Local lImpCero  := .f.
    Local nX        := 0
    Local nY        :=0

    //atemp1:=   fGetTaxDet('0000000000040','SET','9000592385   ','2301','501','NF')
    //atemp2:=   fGetTaxDet('0000000000040','SET','9000592385   ','2301','502','NF')
    //atemp3:=   fGetTaxas('0000000000040' ,'SET','9000592385   ','2301','NF ')

    atemp4:= StrTokArr(atemp3[1], CRLF)
    for  nX:=1 to len(atemp4)

        if AT("<fe:WithholdingTaxTotal>",atemp4[nX])>0
            lDentro:=.t.
        EndIf

        if lDentro
            aAdd(aTemp6,atemp4[nX])
        EndIf

        if AT("</fe:WithholdingTaxTotal>",atemp4[nX])>0
            lDentro:=.f.
            aTemp6:= RevImp(aTemp6)
            aTemp6:= RevIca(aTemp6)
            if len(aTemp6)>0
                lImpCero  := .f.
            else
                lImpCero  := .T.
            EndIf
        EndIf

        If !lDentro
            if len(aTemp6)>0
                For nY:=1 to len(aTemp6)
                    aAdd(aTemp5, atemp6[nY])
                Next
                aTemp6:={}
            else
                If !lImpCero 
                    aAdd(aTemp5, atemp4[nX])
                else
                    lImpCero:=.F.
                EndIf
            EndIf
        EndIf
    Next

    For nX:=1 to len(aTemp5)
        cText +=  atemp5[nX]+CRLF
    Next
    atemp3[1]:=cText
Return atemp3
/*/{Protheus.doc} RevImp
Revisa la session de impuestos y devuelve un arreglo el arrelo intacto coando si hay calculo de impuesto mayor a CERO
@type function
@version 
@author Axel Diaz
@since 25/10/2020
@param aImp, array, param_description
@return return_type, return_description
/*/
static function RevImp(aImp)
    Local nX:= 0
    Local lImpCero:=.F.
    For nX:= 1 to len(aImp)
        if AT('<cbc:TaxAmount currencyID="COP">0.00</cbc:TaxAmount>',aImp[nX])>0
            lImpCero:=.T.
        EndIf
    Next
    if lImpCero
        aImp:={}
    EndIf
Return aImp
/*/{Protheus.doc} RevIca
Revisa el Porcentaje de ICA a transmitris
@type function
@version  
@author AxelDiaz
@since 14/5/2021
@param aImp, array, param_description
@return return_type, return_description
/*/
static function RevIca(aImp)
    Local nX      := 0
    Local lImpIca := .F.
    Local nTotal  := 0
    Local nBase   := 0
    Local nPorc   := 0
    Local nLargo  := 0
    Local cPorc   := ""
    Local cBase   := ""
    Local cTotal  := ""

    For nX:= 1 to len(aImp)
        if AT('<cbc:ID>07</cbc:ID>',aImp[nX])>0
            lImpIca:=.T.
            Exit
        EndIf
    Next
    If lImpIca
        For nX:= 1 to len(aImp)

            If AT('<cbc:TaxableAmount currencyID="COP">',aImp[nX])>0
                nLargo:= nLargo:= AT('>',aImp[nX])+1
                cBase:=substr(substr(aImp[nX],nLargo),1)
                nLargo:= AT('</cbc:TaxableAmount>',cBase)-1
                cBase:=substr(cBase,1,nLargo)
                nBase:=Val(cBase)
            EndIf

            If AT('<cbc:TaxAmount currencyID="COP">',aImp[nX])>0
                nLargo:= nLargo:= AT('>',aImp[nX])+1
                cTotal:=substr(substr(aImp[nX],nLargo),1)
                nLargo:= AT('</cbc:TaxAmount>',cTotal)-1
                cTotal:=substr(cTotal,1,nLargo)
                nTotal:=VAL(cTotal)
            EndIf

            If AT('<cbc:Percent>',aImp[nX])>0
                nLargo:=nLargo:= AT('>',aImp[nX])+1
                cPorc:=substr(substr(aImp[nX],nLargo),1)
                nLargo:= AT('</cbc:Percent>',cPorc)-1
                cPorc:=substr(cPorc,1,nLargo)
                nPorc:=Val(cPorc)
            EndIf 

            //'<cbc:TaxableAmount currencyID="COP">13575582.00</cbc:TaxableAmount>'
            //'<cbc:TaxAmount currencyID="COP">339389.55</cbc:TaxAmount>'
            //'<cbc:Percent>2.50</cbc:Percent>'
            IF nBase>0 .AND. nTotal>0 .AND. nPorc>0
                If round(nBase*nPorc/100,2)==round(nTotal,2)
                    lImpIca:=.F.
                    exit
                else
                    nPorc:=nPorc/10
                    if round(nBase*nPorc/100,2)==round(nTotal,2)
                        lImpIca:=.T.
                        Exit  // Se sale con el Nuevo Porcentaje
                    else
                        lImpIca:=.T.
                        Exit
                    EndIf
                EndIF
            EndIf
        Next
    EndIf
    If lImpIca
        For nX:= 1 to len(aImp)
            If AT('<cbc:Percent>',aImp[nX])>0
                
                aImp[nX]:=STRTRAN(aImp[nX], cPorc, CVALTOCHAR(nPorc))
                
            EndIf 
        Next
    EndIf   
Return aImp


