#Include "Totvs.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} MTA105OK
(long_description) Ao confirmar a solicitação ao almoxarifado. Pode ser utilizado para confirmar ou nao a gravacao da Solicitacao ao Almoxarifado.
Ponto de Entrada utilizado para validar se os itens estão com informação do Centro de Custo.
Caso não esteja apresentará a mensagem informando qual o item esta em BRANCO e não permitirá finalizar a Solicitação ao Armazém enquanto não for preenchido.
@type  Static Function
@author Eduardo Pereira - Sigamat
@since 11/01/2021
@version version 12.1.25
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references) https://tdn.totvs.com/pages/releaseview.action?pageId=6087792
/*/


User Function MTA105OK()
Local lRet  := .T.
/*
Local aArea := GetArea()
Local cItem := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_ITEM"})
Local cCC   := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_CC"})

Local nX    := 0

For nX := 1 To Len(aCols)
    If Empty(aCols[nX,cCC])
        MsgAlert("Item: <FONT COLOR=RED SIZE=4><b>" + aCols[nX,cItem] + "</b></FONT> com Centro de Custo em BRANCO, favor preencher e Confirmar.")
        lRet := .F.
    EndIf
Next nX

RestArea(aArea)
*/
Return lRet
