#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STALTMOE  �Autor  �Renato Nogueira     � Data �  17/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa utilizado para trocar a moeda do campo WB_MOEDA   ���
���          � 					                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STALTMOE()

Local aArea   		:= GetArea()
Local _aRet 		:= {}
Local _aParamBox 	:= {}
Local _cMoeda		:= ""

AADD(_aParamBox,{1,"Moeda",Space(3),"","EXISTCPO('SYF')","SYF","",0,.F.})

If ParamBox(_aParamBox,"Alterar moeda",@_aRet,,,.T.,,500)
	
	_cMoeda	:= _aRet[1]
	
EndIf

RestArea(aArea)

Return(_cMoeda)