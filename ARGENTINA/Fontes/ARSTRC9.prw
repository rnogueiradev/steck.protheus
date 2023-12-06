#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARSTRSPV  �Autor  �Everson Santana     � Data �  09/08/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte para preencher no campo virtual C9_XNOME a Raz�o    ���
���          �Social do Cliente ou Fornecedor, de acordo com o Tipo do    ���
���          �Pedido de Venda para utiliza��o no X3_RELACAO e X3_INIBRW   ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ARSTRC9(lIniBrw)

	Local _cDescr    := ""
	Default lIniBrw := .F.

	dbselectarea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+ SC9->C9_CLIENTE + SC9->C9_LOJA ))
	_cDescr := SA1->A1_NOME

Return(_cDescr)

