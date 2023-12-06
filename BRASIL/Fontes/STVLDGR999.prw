#include 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �STVLDGR999 �Autor  �Renato Nogueira     � Data �  18/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar se o produto da OP � do grupo 999       ���
���          �  		                           					      ���
���          � 									     				      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDGR999(_cProduto)

	Local _cGrupo
	Local _lRet		:= .T.

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !SB1->(Eof())
			_cGrupo := SB1->B1_GRUPO
			If AllTrim(SB1->B1_MSBLQL)=="1" .And. !Empty(SB1->B1_XCODNEW) //Chamado 001250
				MsgInfo("C�DIGO SUBSTITU�DO POR: "+SB1->B1_XCODNEW)
			EndIf
		Else
			MsgAlert("Produto n�o encontrado!")
		EndIf
	
		If _cGrupo = "999" .And. !(Alltrim(SB1->B1_COD) = 'SUNICOM')
			MsgAlert("Este produto est� cadastrado no grupo 999 e n�o poder� ser utilizado!")
			_lRet	:= .F.
		EndIf
	EndIf
Return(_lRet)
