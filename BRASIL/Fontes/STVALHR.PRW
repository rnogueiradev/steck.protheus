#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |STVALHR     �Autor  �Jo�o Victor       � Data �  21/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o de hor�rio para qualquer campo do    ���
���          � tipo hora                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVALHR ()

	Local _cArea    := getarea()
	Local _cCampo   := SX3->X3_CAMPO
	Local _lRet     := .T.
	Local _cX3Tit   := ''

	DbSelectArea("SX3")
	DbSetOrder(2)
	lGrava := .T.
	SX3->(DbGotop())
	If  SX3->(DbSeek(_cCampo))
		_cX3Tit := SX3->X3_TITULO
	Endif

	
	If !(Len(Alltrim(&(_cCampo))) = 5)
		_lRet := .F.
		MSGSTOP( "Favor informar um tempo v�lido para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma n�o ser� poss�vel confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Tempo Inv�lido")

	ElseIf Substr(&(_cCampo),1,2) > '23'
		_lRet := .F.
		MSGSTOP( "Favor informar hora v�lida para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma n�o ser� poss�vel confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Hora Inv�lida")
	ElseIf Substr(&(_cCampo),4,2) > '59'
		_lRet := .F.
		MSGSTOP( "Favor informar minuto v�lido para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma n�o ser� poss�vel confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Minuto Inv�lido")
	Endif
	
	RestArea(_cArea)

Return (_lRet)