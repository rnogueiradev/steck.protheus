#Include "Protheus.ch"

/*/{Protheus.doc} MT103CWH
// Ponto de entrada utilizado pelo importador da Conex�oNF-e para bloquear o cabe�alho do documento de entrada 
durante a �ltima etapa da importa��o
@author Conex�oNF-e
@since 02/03/2022
@version 1.0
@return lRet, .T.
@see (https://atendimento.conexaonfe.com.br/kb/)
/*/
User Function MT103CWH()
Local lRet := .T.

	//If
	//	Regra existente
	//	[...]
	//EndIf

	If lRet
		// Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
		lRet := U_GTPE006() 
	EndIf

Return lRet
