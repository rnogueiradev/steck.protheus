#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDSA5	�Autor  �Renato Nogueira     � Data �  09/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar se produto tem amarra��o na SA5			          ���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDSA5(_cProduto)

Local _aArea     := GetArea()
Local _aAreaSC7  := SC7->(GetArea())
Local _lRet		:= .T.

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbGoTop())
SB1->(DbSeek(xFilial("SB1")+_cProduto))

DbSelectArea("SA5")
SA5->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
SA5->(DbGoTop())

If !SA5->(DbSeek(xFilial("SA5")+CA120FORN+CA120LOJ+_cProduto)) .And. AllTrim(SB1->B1_TIPO)=="MP"
	MsgAlert("Aten��o, este produto n�o possui amarra��o com este fornecedor, verifique!") //Chamado 000923
	_lRet	:= .F.
EndIf

RestArea(_aAreaSC7)
RestArea(_aArea)

Return(_lRet)