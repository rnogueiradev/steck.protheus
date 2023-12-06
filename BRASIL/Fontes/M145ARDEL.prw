#Include "Protheus.ch"

/*/{Protheus.doc} M145ARDEL
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para retornar a situa��o do XML para n�o
importado ap�s a exclus�o do aviso de recebimento
@author Conex�oNF-e
@since 11/07/2022
@version 1.0
@return Nil, Nulo
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function M145ARDEL()
Local lRet := .T.

    // Ponto de chamada Conex�oNF-e sempre como primeira instru��o 
    lRet := U_GTPE018()

    //If
    //    Regra existente
    //    [...]
    //EndIf

Return lRet
