#include 'totvs.ch'



/*/{Protheus.doc} B0001001
Alerta de inclusão de ordem compra
duplicado no pedido de venda.
Utilizado na validação do campo C5_XORDEM
Ticket# 20220830016760
@type function
@version  1.0
@author marcio.katsumata
@since 13/10/2022
@return logical, sempre .T.
/*/
user function B0001001()

    local cAliasOrd as character
    local cMsgOrd   as character

    cMsgOrd   := ""
    cAliasOrd := getNextAlias()

    beginSql alias cAliasOrd
        SELECT C5_FILIAL,C5_NUM 
        FROM %table:SC5% SC5
        WHERE SC5.C5_XORDEM  = %exp:M->C5_XORDEM%  AND
              SC5.C5_CLIENTE = %exp:M->C5_CLIENTE% AND
              SC5.%notDel%
    endSql

    if (cAliasOrd)->(!eof())
        cMsgOrd += "Existe(m) pedido(s) de venda(s) com a ordem de compra ["+M->C5_XORDEM+"] para o cliente selecionado no pedido de venda."+CRLF+CRLF+;
                   "Segue(m) abaixo o(s) pedido(s): "+CRLF
        while (cAliasOrd)->(!eof())
            cMsgOrd += "Filial: "+(cAliasOrd)->C5_FILIAL +" - Código Pedido :"+(cAliasOrd)->C5_NUM+CRLF
            (cAliasOrd)->(dbSkip())
        enddo
    endif

    (cAliasOrd)->(dbCloseArea())

    if !empty(cMsgOrd) .and. !isBlind()
        
        EECView(cMsgOrd,"[Alerta] Ordem de compra","[Alerta]",,,,.T.)

    endif


return .T.
