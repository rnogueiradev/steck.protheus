#Include "Protheus.ch"

/*/{Protheus.doc} A103CND2
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para alterar a condi��o de pagamento 
na importa��o do CTe em lote.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return aDuplic, Array com a nova condi��o de pagamento 
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function A103CND2()
Local aDuplic := PARAMIXB

    //If
    //    Regra existente
    //    [...]
    //EndIf

    // Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
    aDuplic := U_GTPE001()
    
Return aDuplic
