#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKMCA    �Autor  �Microsiga           � Data �  01/19/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada no call center para alterar a tela de      ���
���          �consulta de produto                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKMCA(cAtend,cEnt,cChave,cCodCont,cCodOper)
Local nPProd	:= aPosicoes[3][2]
Local cProduto	:= aCols[n][nPProd]

If Empty(cProduto)
	Help(" ",1,"SEM PRODUT" )
	Return
Endif

SB1->(DbSetOrder(1))
If !SB1->(DbSeek(xFilial("SB1") + cProduto))
	Help(" ",1,"SEM PRODUT" )
	Return
Endif
	
U_STFSVE50(SB1->B1_COD)

Return