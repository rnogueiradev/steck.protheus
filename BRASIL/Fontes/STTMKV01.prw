#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTMKV01     �Autor  �Renato Nogueira  � Data �  05/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o de campo transportadora     					  ���
���          �                       	                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 


User Function STTMKV01()
Local lNovaR          := GETMV("STREGRAFT",.F.,.T.)	    // Ticket: 20210811015405 - 24/08/2021       
Local lRet := .T.

	DbSelectArea("SA1")
	DbSetOrder(1)
	
	If Dbseek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
	
		If !Empty(A1_TRANSP)

			If M->UA_TPFRETE="F"
   				lRet	:= .T. 
   			ElseIf M->UA_TPFRETE="C"
   				lRet	:= .F.
  			EndIf
			
		EndIf    
	EndIf
	IF lNovaR    // Ticket: 20210811015405 - 24/08/2021 
		lRet	:= .T.
	ENDIF	
      
Return(lRet)

/*/{Protheus.doc} STTMKV09
description
Rotina para posicionar registro
Ticket: 20210811015405
@type function
@version  
@author Valdemir Jose
@since 31/08/2021
@return variant, return_description
/*/
User Function STTMKV09()

	M->UA_TPFRETE := If( M->UA_XTIPOPV=="2","C","F")
	
Return  
