#include 'Protheus.ch'
#include 'RwMake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA035INC	�Autor  �Renato Nogueira     � Data �  04/05/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizar LT dos produto								   	���
��									 									���	    					    		   	 				        
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA035INC()

	Local _lRet		:= .T.
	Local _aArea	:= GetArea()
	Local cMsg 		:= " "
	Local _cAssunto	  := 'Novo Grupo de Produtos Criado:'+ ALLTRIM(SBM->BM_DESC)+' - '+SBM->BM_GRUPO
	Local _cCopia	  := ""
	Local _cEmail	  := '  thais.souza@steck.com.br '

//Processa({|| U_STUPDPE(SBM->BM_GRUPO) 	}, "Atualizando", "Processando aguarde...", .f.)


	cMsg := " "
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>GRUPO: </b>'+SBM->BM_GRUPO+'<br><b>DESCRI��O: </b>'+ ALLTRIM(SBM->BM_DESC)  +'<br>'
	cMsg += '</body></html>'

	If 	SBM->BM_XWF = '1'
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
	EndIf


	RestArea(_aArea)

Return(_lRet)
