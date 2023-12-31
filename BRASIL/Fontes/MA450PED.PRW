#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA450PED  �Autor  �Renato Nogueira     � Data �  27/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s libera��o autom�tica financeira		  ���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Parametros� Pedido                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno	 � Nulo	                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA450PED(cPedido)

	Local _aArea     := GetArea()

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ))
		
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
			U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,.T.,.F.)
			SC6->(DbSkip())
		End

	EndIf

	RestArea(_aArea)

Return()