#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDIC	�Autor  �Renato Nogueira     � Data �  23/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para validar IC nas transferencias para o   ���
���          �armazem 90 						    				      ���
�������������������������������������������������������������������������͹��
���Parametro � LOCPAD                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�GICO                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDIC()

	Local _aArea	:= GetArea()
	Local _lRet		:= .T.

	If ( Type("lAutoma261") == "U" .OR. !lAutoma261 )

		DO CASE
			CASE IsInCallStack("MATA261") //Transfer�ncia modelo 2

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			SB1->(DbSeek(xFilial("SB1")+GDFIELDGET("D3_COD",N)))

			If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC" .And. Alltrim(M->D3_LOCAL)=="90"

				If cEmpAnt=="03" .And. AllTrim(UsrRetName(__cUserId)) $ GetMv("ST_VLDIC",,"rita.silva") //Chamado 008727
					_lRet	:= .T.
				Else
					_lRet	:= .F.
					MsgAlert("Item de consumo deve baixar o material para o centro de custo")
				EndIf

			EndIf

			CASE IsInCallStack("MATA260") //Transfer�ncia

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			SB1->(DbSeek(xFilial("SB1")+cCodDest))

			If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC" .And. Alltrim(cLocDest)=="90"

				If cEmpAnt=="03" .And. AllTrim(UsrRetName(__cUserId)) $ GetMv("ST_VLDIC",,"rita.silva") //Chamado 008727
					_lRet	:= .T.
				Else
					_lRet	:= .F.
					MsgAlert("Item de consumo deve baixar o material para o centro de custo")
				EndIf

			EndIf

		ENDCASE

	EndIf

	RestArea(_aArea)

Return(_lRet)