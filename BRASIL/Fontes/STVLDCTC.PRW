#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDCTC	�Autor  �Renato Nogueira     � Data �  20/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte para validar o centro de custo nas requisi��es ao	    ���
���          �armaz�m							    				           ���
�������������������������������������������������������������������������͹��
���Parametro � 		                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDCTC()

	Local _aArea 			:= GetArea()
	Local _lRet				:= .T.
	
	If cEmpAnt=="03"
		If !Empty(M->CP_CC) .And. !((AllTrim(SB1->B1_TIPO)=="IC") .Or. SubStr(AllTrim(SB1->B1_COD),1,1)$"E#U") .And. ! (__cUserId $ GetMv("ST_USRCCRA"))
			_lRet	:= .F.
			MsgAlert("Aten��o, s� � permitido colocar CC quando o item for do tipo IC, U e E, favor procurar o coordenador log�stico!")
		EndIf
	EndIf

	RestArea(_aArea)

Return(_lRet)