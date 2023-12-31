#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STALTCB7	   �Autor  �Jefferson Carlos� Data �  09/12/15    ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para alterar o status da ordem de separa��o  	      ���
���          � 					 		                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP  Chamado 002853                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STALTCB7(_cOs)

	Local _aArea	:= CB7->(GetArea())
	
	If !__cUserId $ GetMv("ST_USRFCB7")
		MsgAlert("Aten��o, usu�rio sem acesso, verifique!")
		Return
	EndIf

	CB7->(DbSelectArea("CB7"))
	CB7->(DbSetOrder(1)) //CB7_FILIAL+CB7_ORDSEP
	If !CB7->(DbSeek(xFilial("CB7")+_cOs))
		MsgAlert('Os n�o encontrada verifique !')
		Return
	EndIf
	
	If MsgYesNo("Deseja alterar Status da OS: "+Alltrim(CB7->CB7_ORDSEP)+"?")
		
		CB7->(Reclock("CB7",.F.))
		CB7->CB7_STATUS	:= "4"
		CB7->(MsUnLock())
			
		MsgAlert("Status alterado com sucesso")
	
	EndIf

	RestArea(_aArea)

Return()