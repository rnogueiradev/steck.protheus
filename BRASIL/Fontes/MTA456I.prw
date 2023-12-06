#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA456I     �Autor  �Renato Nogueira  � Data �  02/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para acrescentar dias na data de entrega  ���
���          � do pedido de vendas                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/   

User Function MTA456I()  

Local _nPedido
Local _nQtDias   

_nPedido := C9_PEDIDO

DbSelectArea("SC5")
DbSetOrder(1)

If Dbseek(xFilial("SC5")+_nPedido)

	If DDATABASE<>SC5->C5_EMISSAO
	
		_nQtDias := (VAL(DTOS(DDATABASE)))-(VAL(DTOS(SC5->C5_EMISSAO)))  
		
		Reclock("SC5",.F.)
   		C5_FECENT		:= C5_FECENT+_nQtDias 
   		MSUNLOCK()

	EndIf
EndIf

Return()
