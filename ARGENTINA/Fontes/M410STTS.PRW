#INCLUDE 'PROTHEUS.CH'
#DEFINE CR    chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410STTS  �Autor  �Everson Santana     � Data �  31/07/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada pertence � rotina de pedidos de venda,���
���          �MATA410(). Est� em todas as rotinas de altera��o, inclus�o, ���
���          �exclus�o e devolu��o de compras. Executado ap�s todas as    ���
���          �altera��es no arquivo de pedidos terem sido feitas.         ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para gravar falta/reserva na alteracao do pedido de  ���
���          �venda MATA410                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410STTS()

	IF INCLUI .OR. ALTERA

		U_ARFAT02()

	EndIf

	U_ARLEGSC5(SC5->C5_FILIAL,SC5->C5_NUM)

Return

