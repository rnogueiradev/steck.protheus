#Include "Protheus.ch"

/*/{Protheus.doc} MT103IP2
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para limpar a vari�vel __cInterNet e for�ar 
a apresenta��o dos alertas customizados durante a importa��o.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return Nil, Nulo
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT103IP2()
    
    // Ponto de chamada Conex�oNF-e sempre como primeira instru��o.
    U_GTPE007() 

    //If
	//	Regra existente
	//	[...]
	//EndIf
    
Return Nil
