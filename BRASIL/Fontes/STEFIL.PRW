#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} STEFIL
(Função para gravar Cnpj de origem do titulo a pagar financeiro)

@author jefferson.carlos
@since 05/09/2017
@version 1.0
@return ${return}, ${return_description}

/*/

User Function  STEFIL()

	Local cCnpj	:=""

	If cempant = "01"

		If !Empty(AllTrim(SE2->E2_XCNPJ))
			cCNPJ := SE2->E2_XCNPJ
	
		ElseIf SEA->EA_FILORIG='01'
			cCnpj='05890658000130'
		ElseIf SEA->EA_FILORIG='02'
			cCnpj='05890658000210'
		ElseIf SEA->EA_FILORIG='03'
			cCnpj='05890658000300'
		ElseIf SEA->EA_FILORIG='04'
			cCnpj='05890658000482'
		ElseIf SEA->EA_FILORIG='05'
		   cCnpj='05890658000563'
		EndIf
	elseif cempant = "11"

	   If !Empty(AllTrim(SE2->E2_XCNPJ))
			cCNPJ := SE2->E2_XCNPJ
	   ElseIf SEA->EA_FILORIG='01'
			cCnpj='44415136000138'
	   ElseIf SEA->EA_FILORIG='02'
	        cCnpj='44415136000219'
	   Endif
	elseif cempant = "03"
   
		If !Empty(AllTrim(SE2->E2_XCNPJ))
			cCNPJ := SE2->E2_XCNPJ
	
		ElseIf SEA->EA_FILORIG='01'
			cCnpj='06048486000114'

		EndIf
	EndIf
	
Return(cCnpj)
	
	