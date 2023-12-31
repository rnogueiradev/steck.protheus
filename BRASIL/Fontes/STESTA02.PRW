#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STESTA02	   �Autor  �Renato Nogueira  � Data �  23/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para alterar o status da pr�-estrutura			  ���
���          � 					 		                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STESTA02()

Local _cGgCod

If msgyesno("Deseja liberar a pr�-estrutura do produto "+Alltrim(SGG->GG_COD)+"?")
	
	DbSelectArea("SGG")
	DbSetOrder(1) //GG_FILIAL+GG_COD+GG_COMP+GG_TRT
	DbSeek(xFilial("SGG")+SGG->GG_COD)
	
	_cGgCod	:= Alltrim(SGG->GG_COD)
	
	While _cGgCod==Alltrim(SGG->GG_COD)
		
		If !SGG->(Eof())
			
			SGG->(Reclock("SGG",.F.))
			SGG->GG_STATUS	:= "1"
			SGG->(MsUnLock())
			
			SGG->(DbSkip())
			
		EndIf
		
	EndDo
	
	MsgAlert("Libera��o de pr�-estrutura feita com sucesso")
	
Else
	
	MsgAlert("Libera��o cancelada")
	
EndIf

Return()
