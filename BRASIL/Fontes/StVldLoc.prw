#include "Rwmake.ch"            


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STVLDLOC �Autor  � RVG Solucoes       � Data �  08/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Bloquear a escolha de armazem errado           ���
���          � incluir na validacao do usuario u_StVldLoc()               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function StVldLoc 
			
_cLocal := &(Readvar())
DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial("SX5")+"90"+_cLocal)
if eof()
    MsgStop("Armazem nao existe!, Verifique !!! ")
    _lRet := .f.
else
	_lRet :=  .t.
Endif                         
                                                               
Return _lret