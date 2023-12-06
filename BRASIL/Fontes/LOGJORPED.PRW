#Include "Protheus.ch"

/*/{Protheus.doc} LOGJORPED
Gravao de Logs jornada do pedido
@type function
@version  1.0
@author Kleber Ribeiro - CRM Services 
@since 30/05/2022
/*/
USER FUNCTION LOGJORPED(cTab,cEtapa,cProd,cItem,cCod,cSer,cProc,nVal)
Local aArea    := GetArea()

DbSelectArea("Z05")
RecLock("Z05", .T.)
    Z05_FILIAL      := xFilial("Z05")
    Z05_TABELA      := cTab
    Z05_ETAPA       := cEtapa
    Z05_PEDIDO  := cCod
 /*   IF cTab == "SUB"
        Z05_ORCAMENTO := cCod
    ELSEIF cTab $ "SC6|SC9|ZZI|PA1"
        Z05_PEDIDO  := cCod
    ELSEIF cTab == "CB8"
        Z05_OS      := cCod
    ELSEIF cTab == "SD2"
        Z05_DOC     := cCod
        Z05_SERIE   := cSer
    ENDIF*/
    Z05_PRODUTO     := cProd
    Z05_ITEM        := cItem
    Z05_DATA        := Date()
    Z05_HORA        := Time()
    Z05_USUARIO     := cUsername
    Z05_PROCESS     := cProc
    Z05_ROTINA      := FUNNAME()
    IF nVal > 0
        Z05_VALOR   := nVal
    ENDIF
MsUnlock()

RestArea(aArea)

RETURN
