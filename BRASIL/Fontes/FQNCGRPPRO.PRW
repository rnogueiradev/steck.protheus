#INCLUDE "PROTHEUS.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  FQNCGRPPRO  ³ Autor ³ Felipe Santos        ³ Data ³22/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³REALIZA A INCLUSÃO DO GRUPO DE PRODUTOS NO CADASTRO DE      ³±±
±±³OCORRENCIAS DE NÃO CONFORMIDADE										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

User Function FQNCGRPPRO(cCodPro)

Local cRetorno := ""
 
SB1->(DbSetOrder(1)) // Indice FILIAL + PRODUTO
SB1->(DbSeek(xFilial('SB1')+ cCodPro))
While SB1->(!Eof() .and. B1_FILIAL+B1_COD == xFilial("SB1")+cCodPro) 
	
	IF( !EMPTY(SB1->B1_GRUPO) )
	
		SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO                                                 
		SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))
			IF SBM->(!Eof()) 		
				cRetorno := SBM->BM_DESC	
		    END
		    SBM->(DbClosearea())  
	ENDIF                                                                   
	    
	SB1->(dbSkip())
EndDo  			
SB1->(DbClosearea())
	                         
Return cRetorno     
                       



User Function FFATECDSCGRPPRO(cCodPro)

Local cRetorno := ""
 
SB1->(DbSetOrder(1)) // Indice FILIAL + PRODUTO
SB1->(DbSeek(xFilial('SB1')+ cCodPro))
While SB1->(!Eof() .and. B1_FILIAL+B1_COD == xFilial("SB1")+cCodPro) 
	
	IF( !EMPTY(SB1->B1_GRUPO) )
	
		SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO
		SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))
			IF SBM->(!Eof()) 		
				cRetorno := SBM->BM_DESC
		    END
		    SBM->(DbClosearea())  
	ENDIF
	    
	SB1->(dbSkip())
EndDo  			
SB1->(DbClosearea())
	                         
Return cRetorno 
  


