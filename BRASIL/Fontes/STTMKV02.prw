#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTMKV02     �Autor  �Renato Nogueira  � Data �  05/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o de campo tipo de frete     					  ���
���          �                       	                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 


User Function STTMKV02()
       
Local lRet := .T.

	DbSelectArea("SA1")
	DbSetOrder(1)
	
	If Dbseek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
	
		If Empty(A1_TRANSP)

			If (M->UA_TRANSP<>"10000 " .And. M->UA_TPFRETE<>"F")
			MsgAlert("Para transportadora diferente de carro pr�prio o tipo de frete deve ser FOB")
			lRet	:= .F. 
   			ElseIf (M->UA_TRANSP="10000" .And. M->UA_TPFRETE<>"C")
			MsgAlert("Para transportadora carro pr�prio o tipo de frete deve ser CIF")
			lRet	:= .F.
   			EndIf
   		EndIf
   EndIf
      
Return(lRet)