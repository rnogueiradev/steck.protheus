#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103BCLA	�Autor  �Renato Nogueira     � Data �  15/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na chamada da classifica��o da nota		  ���
���          �	    							 	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103BCLA()

	Local _aArea		:= GetArea()
	Local _aRet		:= {}

	If cEmpAnt=="03" .Or. CUFORIG=="EX"
		Return
	EndIf

	U_STTESENT()

	RestArea(_aArea)

Return()