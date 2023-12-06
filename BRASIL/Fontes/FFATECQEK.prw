#INCLUDE "PROTHEUS.CH"

User Function FFATECQEK(cNFISCAL,cSERIE, cFORNEC, cLOJA, cPROD, cITEM,cTIPO)
//cTIPO -> 1 : RETORNA COD.FATEC
//cTIPO -> 2 : RETORNO COD.MOTIVO FATEC
Local cRetorno := ""
 
SD1->(DbSetOrder(1)) // Indice D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
SD1->(DbSeek(xFilial('SD1')+ cNFISCAL+cSERIE+cFORNEC+cLOJA+cPROD+cITEM))
While SD1->(!Eof() .And. D1_FILIAL+D1_DOC+D1_COD+D1_ITEM == xFilial("SD1")+cNFISCAL+cPROD+cITEM)
	
	IF( !EMPTY(SD1->D1_XFATEC) )
	   
		//DE ACORDO COM A FATEC BUSCA O MOTIVO
		PC1->(DbSetOrder(1)) // Indice PC1_FILIAL+PC1_NUMERO                                                                                                                                           
		PC1->(DbSeek(xFilial('PC1')+ SD1->D1_XFATEC))
			IF PC1->(!Eof()) 
				IF(cTIPO=="1")						
					cRetorno := PC1->MOTIVO
				ELSEIF(cTIPO=="2")	
					cRetorno := PC1->PC1_NUMERO				
				ENDIF
				
		    END
		    PC1->(DbClosearea())  
	ENDIF
	    
	SD1->(dbSkip())
EndDo  			
SD1->(DbClosearea())
	                         
Return cRetorno


