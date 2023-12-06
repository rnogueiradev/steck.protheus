#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF1100I  �Autor  � Ricardo Posman     � Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava "Ref. a NF N.: XXXXXX" no campo E2_HIST              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA040ALT()

Local lRet 		:= .T.
Local _cFluxoR	:= Posicione("SA1",1,xFilial("SA1")+M->E1_CLIENTE+M->E1_LOJA,"A1_FLUXO")

IF M->E1_FLUXO <> _cFluxoR

	If MsgYesNo("Este cliente esta configurado para que seus titulos nao entre no Fluxo de Caixa. Confirma a alteracao?","Atencao")
		lRet:= .T.	
 
	Else 
		lRet:= .F.
	Endif


ENDIF
            
Return(lRet)                                                           
