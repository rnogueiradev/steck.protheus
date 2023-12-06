#INCLUDE "PROTHEUS.CH"

User Function FFATECPR(cNumPedRp,lIniBrw)
Local cRetorno := ""
Default:= .F.
If lIniBrw // X3_INIBRW nao esta retornando a variavel INCLUI, ALTERA, EXCLUI...
	IF( !EMPTY(cNumPedRp) )

		//DE ACORDO COM O PEDIDO DE REPOSIÇÃO BUSCA A FATEC
			PC1->(DbSetOrder(6)) // Indice PC1_FILIAL+PC1_PEDREP
			PC1->(DbSeek(xFilial('PC1')+ cNumPedRp))
			IF PC1->(!Eof())
				cRetorno := PC1->PC1_NUMERO
	    	END
	    	PC1->(DbClosearea())
	ENDIF
Else
	/*
	if cEmpant = "03"
		INCLUI := .T.
	ENDIF
	*/
	If VALType(INCLUI) <> "U"
	If !INCLUI
		IF( !EMPTY(cNumPedRp) )

		//DE ACORDO COM O PEDIDO DE REPOSIÇÃO BUSCA A FATEC
			PC1->(DbSetOrder(6)) // Indice PC1_FILIAL+PC1_PEDREP
			PC1->(DbSeek(xFilial('PC1')+ cNumPedRp))
			IF PC1->(!Eof())
				cRetorno := PC1->PC1_NUMERO
	    	END
	    	PC1->(DbClosearea())
		ENDIF

	EndIF
	endif
EndIf


Return cRetorno
