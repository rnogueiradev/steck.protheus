#INCLUDE "PROTHEUS.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  FQNCGRPPRO  � Autor � Felipe Santos        � Data �22/02/2013���
�������������������������������������������������������������������������Ĵ��
���Descricao �REALIZA A INCLUS�O DO GRUPO DE PRODUTOS NO CADASTRO DE      ���
���OCORRENCIAS DE N�O CONFORMIDADE										  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �STECK                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */

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
  


