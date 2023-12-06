#Include "Protheus.ch"

/*/{Protheus.doc} MT140SAI
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para gera��o das a��es do ERP sendo ela
a flag do ERP ao importar uma pr�-nota, tamb�m atualiza a situa��o do XML ao 
excluir uma pr�-nota, voltado o XML para pendente de importa��o.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return Nil, Nulo
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT140SAI()

    // Ponto de chamada Conex�oNF-e sempre como primeira instru��o 
    U_GTPE016()

    //If
    //    Regra existente
    //    [...]
    //EndIf

Return Nil 
