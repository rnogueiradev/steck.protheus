#Include "Protheus.ch"

/*/{Protheus.doc} MT100LOK
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para limpar a vari�vel __cInterNet e for�ar 
a apresenta��o dos alertas customizados durante a importa��o.
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return lRet, .T.
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT140LOK()
Local lRet := .T.

	// Ponto de chamada Conex�oNF-e sempre como primeira instru��o.
	lRet := U_GTPE012()
	
	If lRet .And. !FwIsInCallStack('U_GATI001') .Or. !l103Auto
		//If
		//	Regra existente
		//	[...]
		//EndIf
	EndIf

Return lRet
