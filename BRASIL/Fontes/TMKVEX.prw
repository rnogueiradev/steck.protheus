#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKVEX    �Autor  �Microsiga           � Data �  02/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para permitir ou nao o cancelamento do     ���
���          �orcamento no TELEVENDAS                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKVEX()
Local lRet	:= .T.

lRet := U_STFSVE61()

Return lRet