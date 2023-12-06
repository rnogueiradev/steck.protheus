#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMLOCOP   �Autor  �Jo�o Rinaldi        � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado gatilhar o Armaz�m que ser� utilizado no    ���
���          �momento da gera��o da OP a partir do campo SC2->C2_ZDESTIN  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AMLOCOP()

	Local _aArea     := GetArea()
	Local aSB1Area   := SB1->(GetArea())
	Local aSC2Area   := SC2->(GetArea())
	Local _lRet	   := .T.
	Local _cLocpad   := ""

//1=S�o Paulo;2=Argentina;3=M�xico;4=Local;5=F�brica

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+M->C2_PRODUTO))
		_cLocpad := SB1->B1_LOCPAD
	EndIf

	Do Case
	Case M->C2_ZDESTIN = '1'
		_cLocpad := '15'
	Case M->C2_ZDESTIN = '2'
		//_cLocpad := '01'
	Case M->C2_ZDESTIN = '3'
		//_cLocpad := '01'
	Case M->C2_ZDESTIN = '4'
		//_cLocpad := '01'
	Case M->C2_ZDESTIN = '5'
		//_cLocpad := '01'
	EndCase

	RestArea(aSB1Area)
	RestArea(aSC2Area)
	RestArea(_aArea)

Return(_cLocpad)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMVLD2DEST�Autor  �Jo�o Rinaldi        � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado valida��o do campo SC2->C2_ZDESTIN          ���
���          �X3_VLDUSER                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AMVLD2DEST ()

	Local _lRet := .T.
	Local _cLocpad := ""
	Local _aArea     := GetArea()
	Local aSB1Area   := SB1->(GetArea())
	Local aSC2Area   := SC2->(GetArea())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+M->C2_PRODUTO))
		_cLocpad := SB1->B1_LOCPAD
		_cTipo   := SB1->B1_TIPO
	EndIf

	If !EMPTY(_cLocpad)

		If !IsInCallStack("MATA712")
			If (M->C2_ZDESTIN $ '2/3/4' .And. !_cLocpad $ '03') .OR. (M->C2_ZDESTIN = '5' .And. !_cLocpad $ '01')
				If !Msgyesno ("Existem diverg�ncias entre o Armaz�m do Produto e o destino informado...!!!"+ Chr(10) + Chr(13)+;
						"Deseja Continuar...???",;
						"Confima��o")
					_lRet := .F.
				Endif
			ElseIf M->C2_ZDESTIN = '1' .And. !_cTipo $ 'PA'
				If !Msgyesno ("Voc� est� enviando para S�o Paulo um produto que n�o � acabado...!!!"+ Chr(10) + Chr(13)+;
						"Deseja Continuar...???",;
						"Confima��o")
					_lRet := .F.

				Endif
			Endif
		EndIf
	Else
		MSGSTOP("Produto n�o possui armaz�m cadastrado...!!!"+ Chr(10) + Chr(13) +;
			"Favor verificar junto a Engenharia...!!!"+ Chr(10) + Chr(13) +;
			"N�o ser� poss�vel incluir a Ordem de Produ��o...!!!")
		_lRet := .F.
	Endif

	RestArea(aSB1Area)
	RestArea(aSC2Area)
	RestArea(_aArea)

Return(_lRet)









/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMVLDPROD �Autor  �Jo�o Rinaldi        � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para inibir altera��o ap�s o preenchimento  ���
���          �do c�digo do Produto no campo SC2->C2_PRODUTO               ���
���          �X3_WHEN                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function AMVLDPROD ()

	Local _aArea     := GetArea()
	Local aSC2Area   := SC2->(GetArea())

	Local _lRet := .T.

	IF !(EMPTY(M->C2_PRODUTO))
		_lRet := .F.
	Endif

	RestArea(aSC2Area)
	RestArea(_aArea)

Return(_lRet)










/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMVLDDEST �Autor  �Jo�o Rinaldi        � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para inibir altera��o ap�s o preenchimento  ���
���          �do destino da OP no campo SC2->C2_ZDESTIN                   ���
���          �X3_WHEN                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function AMVLDDEST()

	Local _aArea     := GetArea()
	Local aSC2Area   := SC2->(GetArea())
	Local _lRet := .T.


	IF (EMPTY(M->C2_PRODUTO)) .OR. !(EMPTY(M->C2_ZDESTIN))
		_lRet := .F.
	Endif

	RestArea(aSC2Area)
	RestArea(_aArea)

Return(_lRet)
