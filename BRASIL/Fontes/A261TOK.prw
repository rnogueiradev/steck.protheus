#include 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �A261TOK   �Autor  �Microsiga           � Data �  12/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pontdo entrada de validacao da transferencia  modelo 2      ���
���          �MATA261                           						  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A261TOK()   

	Local lRet := .F.

	/*|*************************************************************************|
	|*|Vari�vel _aAutSD3 � utilizada no fonte AcdSa01 respons�vel em converter  |
	|*|uma requisi��o ao armazem em um movimento de transferencia, portanto ele |
	|*|n�o vai chamar a afun��o STFSC10M - Eduardo Matias 30/10/18				|
	|*|***********************************************************************|*/

	If TYPE("_aAutSD3")!="A"
		lRet := U_STFSC10M()  // rotina para validar o saldo e a reserva na transferencia do produto (Mod 2)
	Else
		lRet :=	.T.
	EndIf

Return lRet