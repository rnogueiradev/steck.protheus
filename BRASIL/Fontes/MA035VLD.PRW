#include 'Protheus.ch'
#include 'RwMake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA035VLD	�Autor  �Renato Nogueira     � Data �  04/05/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizar LT dos produto										   	���
��																					���	    					    		   	 				        
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA035VLD()

	Local _lRet		:= .T.
	Local _aArea	:= GetArea()
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ''
	Local cMsg	      	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''

//Processa({|| U_STUPDPE(SBM->BM_GRUPO) 	},'Atualizando produtos...')
	If INCLUI .OR. ALTERA

		_cEmail   := GetMv("ST_MAILLOG")
		_cAssunto := '[PROTHEUS] - Grupo: '+M->BM_GRUPO+' incluido/alterado'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Grupo: '+M->BM_DESC+'</b></body></html>'
	
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				

	EndIf

	RestArea(_aArea)
Return(_lRet)