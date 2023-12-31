#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLCOMP	�Autor  �Renato Nogueira     � Data �  23/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para validar pre-estrutura e estrutura      ���
���          �									    				      ���
�������������������������������������������������������������������������͹��
���Parametro � B1_COD                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�GICO                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLCOMP(_cCod)

Local _aArea	:= GetArea()
Local _lRet		:= .T.

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbGoTop())
SB1->(DbSeek(xFilial("SB1")+_cCod))

If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC"
	
	//_lRet	:= .F.
	//MsgAlert("Item de consumo n�o utilizar em estrutura")
	
EndIf

RestArea(_aArea)

Return(_lRet)