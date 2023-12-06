
#INCLUDE "Protheus.ch"
#INCLUDE "APVT100.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACDGCB9E �Autor  �Sandro              � Data �  18/06/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para gravacao do lote especifico           ���
�������������������������������������������������������������������������͹��
���Uso       �STECK	                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */ 
User Function ACDGCB9E()
	Local cOrdSep 	:= If(!Empty(CB7->CB7_XOSPAI),CB7->CB7_XOSPAI,CB7->CB7_ORDSEP)
	Local cLoteX 	:= U_RetLoteX()
	Local nQtde		:= ParamIxb[1]

	PA0->(DbSetOrder(1))
	If PA0->(DbSeek(xFilial("PA0")+cOrdSep+CB8->CB8_ITEM+CB8->CB8_PROD+cLoteX))
		PA0->(RecLock("PA0",.F.))
		PA0->PA0_QTDE  -= nQtde
		If PA0->PA0_QTDE <= 0
			PA0->(DbDelete())
		Endif
		PA0->(MsUnLock())
	Endif

	CB7->(RecLock("CB7",.F.))
	CB7->CB7_STATUS := "1"
	CB7->(MsUnlock())
Return