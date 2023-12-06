#include 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �STVLDOF   �Autor  �Renato Nogueira     � Data �  18/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar se o produto da OP � do grupo 999       ���
���          �  		                           					      ���
���          � 									     				      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDOF(_cProduto)

Local _lRet		:= .T.

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+_cProduto))

If !SB1->(Eof())
	
	DO CASE
		CASE Empty(SB1->B1_ZCODOL) .And. SB1->B1_TIPO $ "PA#PI"
			MsgAlert("Aten��o, produto sem classifica��o de oferta log�stica, verifique!")
			_lRet		:= .F.
        /*
		CASE Empty(SB1->B1_XFMR)
			MsgAlert("Aten��o, produto sem classifica��o FMR, verifique!")
			_lRet		:= .F.
		*/
	ENDCASE
	
Else
	MsgAlert("Produto n�o encontrado!")
EndIf

Return(_lRet) 