#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650I   �Autor  �Microsiga           � Data �  08/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos a grava��o do SC2 (OP)	              ���
���          � (MATA650) 						                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA650I()

	U_STFSC11C() //Funcao gravar o xlote na tabela SC2 e gravar o registro na tabela PA0
	
	U_STPCE001()

Return 