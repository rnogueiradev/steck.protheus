#include 'Protheus.ch'
#include 'RwMake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STREM38	�Autor  �Renato Nogueira     � Data �  04/05/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloqueio de remessa pra conserto    						   	���
��																					���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STREM38()

	Local _lRet		:= .T.
	Local _nPosProd	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
	Local _aAreaSC6	:= SC6->(GetArea())
	Local _aAreaSB1	:= SB1->(GetArea())
	Local _aArea		:= GetArea()
	Local nX:=1
	
	For nX:=1 To Len(aCols)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+aCols[nX][_nPosProd]))

		If AllTrim(SB1->B1_TIPO)=="AI" .Or. AllTrim(SB1->B1_TIPO)=="ME"
			_lRet	:= .T.
		Else
			_lRet	:= .F.
		EndIF

	Next

	If !_lRet
		MsgAlert("Aten��o, para esse tipo de opera��o s� � permitido o tipo de produto AI ou ME!")
	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSB1)
	RestArea(_aAreaSC6)

Return(_lRet)
