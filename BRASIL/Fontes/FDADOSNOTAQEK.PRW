#INCLUDE "PROTHEUS.CH"


User Function FDADOSNOTAQEK(cNFISCAL, cITEM, cFORNEC, cPROD,cTIPO)
//cTIPO -> 1 : RETORNA VALOR MERCADORIA
//cTIPO -> 2 : RETORNO VALOR FRETE
Local cRetorno := ""
 
SD1->(DbSetOrder(1)) // Indice D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
SD1->(DbSeek(xFilial('SD1')+ cNFISCAL+cSERIE+cFORNEC+cLOJA+cPROD+cITEM))
While SD1->(!Eof() .and. D1_FILIAL+D1_DOC+D1_COD+D1_ITEM == xFilial("SD1")+cNFISCAL+cPROD+cITEM) 	

	IF SD1->(!Eof()) 
		IF(cTIPO=="1")						
			cRetorno := SD1->D1_TOTAL
		ELSEIF(cTIPO=="2")	
			cRetorno := SD1->D1_VALFRE			
		ENDIF
		
    END
    SD1->(DbClosearea())  
	SD1->(dbSkip())
EndDo  			
SD1->(DbClosearea()) 			
      
Return cRetorno