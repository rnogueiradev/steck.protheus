#include 'Totvs.ch'
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MT410TOK                                                                                      |
 | Desc:  Funcion que se ejecuta antes de confirmar a inclusion del Pedido de Venda                              |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MT410TOK()
    Local lRet:= .T.
    Local aArea    := GetArea()
    Local aAreaC9    := SC9->(GetArea())
    Local aAreaC5    := SC5->(GetArea())
    Local aAreaC6    := SC6->(GetArea())
     
        If INCLUI .OR. ALTERA
            DO CASE 
                CASE Empty(M->C5_PAQUET)
                    MsgStop("EL Campo PAQUETERIA no debe quedar en vacio", "Atencion")
                    lRet := .F.
                CASE Empty(M->C5_DESTINO)
                    MsgStop("EL Campo DESTINO no debe quedar en vacio", "Atencion")
                    lRet := .F.
                CASE Empty(M->C5_TIPOSER)
                    MsgStop("EL Campo TIPO DE SERVICIO no debe quedar en vacio", "Atencion")
                    lRet := .F.
                CASE Empty(M->C5_TIPOENT)
                    MsgStop("EL Campo TIPO DE ENTREGA no debe quedar en vacio", "Atencion")
                    lRet := .F.
                CASE Empty(M->C5_CONVENI)
                    MsgStop("EL Campo CONVENIO no debe quedar en vacio", "Atencion")
                    lRet := .F.
            ENDCASE    
        EndIf
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aAreaC9)
    RestArea(aArea)
Return lRet
