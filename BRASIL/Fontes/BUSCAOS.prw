#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BUSCAOS  �Autor  �Renato Nogueira     � Data �  05/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �													          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BUSCAOS()

Local lRet	:= .T.
Local _cFil, _cOp, _cCod, _cLocal   
Local aArea := {}

aArea	:= GetArea()

DbSelectArea("SD4")
DbSetOrder(2)
SD4->(DbSeek(xFilial('SD4')+Alltrim(D4_OP+D4_COD+D4_LOCAL)))

_cFil	:= SD4->D4_FILIAL
_cOp	:= SD4->D4_OP
_cCod	:= SD4->D4_COD
_cLocal	:= SD4->D4_LOCAL

While SD4->(!Eof() .And. Alltrim(D4_FILIAL+D4_OP+D4_COD+D4_LOCAL) == _cFil+_cOp+_cCod+_cLocal)
	If !Empty(SD4->D4_XORDSEP)
	     lRet	:= .F.
	EndIf
	SD4->(DbSkip())
Enddo                

If lRet==.F.
MsgAlert("Este empenho possui ordem de separa��o, n�o ser� poss�vel alterar!")
Endif       

restarea(aArea)

Return(lRet)