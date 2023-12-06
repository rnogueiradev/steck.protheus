#Include "Totvs.ch"

/*/{Protheus.doc} CH_V_PED
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
aCabec = Vetor com cabeçalho do execauto
aItens = Vetor com item do execauto
*/

User Function CH_V_PED(oPedido,aCabec,aItens)

Local cAlias    := GetNextAlias()
Local cCodigoErp:= ""

Local nPosTipo  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_TIPO"})
Local nPosCli   := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_CLIENTE"})
Local nPosLoja  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_LOJACLI"})
Local nPosEcom  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_PEDECOM"})
Local cTipo     := aCabec[nPosTipo][2]
Local cCliente  := aCabec[nPosCli][2]
Local cLoja     := aCabec[nPosLoja][2]
Local cPedEcomm := aCabec[nPosEcom][2]

//inicia query
BeginSql Alias cAlias
SELECT  SC5.C5_NUM, SC5.C5_FILIAL
FROM    %table:SC5% SC5
WHERE 	SC5.C5_FILIAL   = %xFilial:SC5%
    AND	SC5.C5_TIPO     = %Exp:cTipo%
    AND	SC5.C5_PEDECOM  = %Exp:cPedEcomm%
    AND	SC5.C5_CLIENTE  = %Exp:cCliente%
    AND SC5.C5_LOJACLI  = %Exp:cLoja%
    AND	SC5.C5_NOTA     = ''
    AND	SC5.%NotDel%
EndSql
//verifica se obteve retorno de pedidos
(cAlias)->(dbGoTop())
//verifica se teeve retorno
If (cAlias)->(!EoF())
    cCodigoErp := (cAlias)->C5_NUM
EndIf
(cAlias)->(dbCloseArea())

Return cCodigoErp
