#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT260TOK	�Autor  �Renato Nogueira     � Data �  05/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizado para validar informa��es 	      ���
���          �digitadas na transfer�ncia modelo 2    		  	 		  ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT260TOK()

Local _aArea  	:= GetArea()
Local _lRet		:= .T.

_lRet := U_STFSC10L()  // rotina para realizar a valida��o do saldo verificando a reserva na transferencias

If CLOCDEST $ "95#97#98"
	MsgAlert("Aten��o, para armaz�ns de destino da qualidade utilizar transfer�ncia modelo 2")
	_lRet	:= .F.
EndIf

Restarea(_aArea)

Return(_lRet)