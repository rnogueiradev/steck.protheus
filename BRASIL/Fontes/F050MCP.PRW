#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*/{Protheus.doc} F050MCP
(Alteração de Vencimentos Titulos Contas a Pagar Impostos)

@author jefferson.carlos
@since 26/12/2017
@version 1.0
@return ${return}, ${return_description}

/*/


User Function F050MCP()

	Local aCampos := PARAMIXB

	If   Alltrim(SE2->E2_TIPO) = "NF"
		AADD(aCampos,"E2_VENCTO")
		AADD(aCampos,"E2_VENCREA")
		AADD(aCampos,"E2_FORAGE")
		AADD(aCampos,"E2_FORCTA")
		AADD(aCampos,"E2_FORBCO")
		AADD(aCampos,"E2_FCTADV")
		AADD(aCampos,"E2_FAGEDV")


	Endif



Return aCampos