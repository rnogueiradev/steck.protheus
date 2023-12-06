#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BUSCAORD  �Autor  �Renato Nogueira     � Data �  05/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa criado para acertar os empenhos incorretos         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BUSCAORD()
	
	Local lRet	:= .T.
	
	DbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+EE7->EE7_PEDFAT))
	
	While !SC9->(Eof()) .And. EE7->EE7_FILIAL+EE7->EE7_PEDFAT == SC9->C9_FILIAL+SC9->C9_PEDIDO
		
		If !Empty(SC9->C9_ORDSEP)
			lRet	:= .F.
		EndIf
		
		SC9->(DbSkip())
		
	EndDo
	
	If lRet==.F.
		MsgAlert("Este pedido j� possui ordem de separa��o amarrada e n�o pode ser alterado!")
	EndIf
	
Return(lRet)
