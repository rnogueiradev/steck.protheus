#Include 'Protheus.ch' 

/*/{Protheus.doc} ATUDTPRO
Atualiza data programada nos itens, baseado no preenchimento no cabeçalho (orçamento e pedido)
@type function
@version  1.0
@author Kleber Ribeiro - CRM Services 
@since 30/05/2022
/*/

USER FUNCTION ATUDTPRO()
LOCAL cRet      := ''
LOCAL nPEntPro  := aScan(aHeader, {|X| ALLTRIM(X[2])=="C6_ZENTREP"})
LOCAL nEntSUA   := aScan(aHeader, {|X| ALLTRIM(X[2])=="UB_ZENTREP"})
LOCAL nX        := 0

FOR nX := 1 TO Len(aCols)
    //IF EMPTY(SC6->C6_ZENTREP)
    IF FUNNAME() == 'STFSVE47'
        aCols[nX][nEntSUA] := M->UA_XDTENPR
        cRet := M->UA_XDTENPR
    ELSEIF FUNNAME() == 'MATA410'
        aCols[nX][nPEntPro] := M->C5_XDTENPR    
        cRet := M->C5_XDTENPR
    ENDIF
Next

GETDREFRESH()

IF FUNNAME() == 'STFSVE47' //call steck
    SetFocus(oGetTLV:oBrowse:hWnd) // Atualizacao por linha
    oGetTLV:Refresh()
ELSEIF FUNNAME() == 'MATA410' //pedido de venda
    SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
    oGetDad:Refresh()
    //A410LinOk(oGetDad)
ENDIF


Return cRet
