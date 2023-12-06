#Include "Protheus.ch"

/*/{Protheus.doc} MT140CAB
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para carregar os campos de totais de despesa, frete e seguro
na importa��o da pr�-nota.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return lRet, .T.
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT140CAB()
Local lRet := .T.

    //If
    //	Regra existente
    //	[...]
    //EndIf

    // Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
    If lRet
        lRet := U_GTPE009()	 
    EndIf
    
Return lRet
