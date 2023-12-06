#Include "Protheus.ch"

/*/{Protheus.doc} MT116GRV
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para manipular as informa��es na
importa��o do Conhecimento de Transporte via MATA116. Respons�vel tamb�m pela gera��o da a��o do ERP
e atualiza��o da situa��o do XML ao excluir o lan�amento.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return Nil, Nulo
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT116GRV()
    
    //If
	//	Regra existente
	//	[...]
	//EndIf

    // Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
    U_GTPE008()
    
Return Nil
