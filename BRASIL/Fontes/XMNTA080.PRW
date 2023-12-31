#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XMNTA080	�Autor  �Renato Nogueira     � Data �  05/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para montar filtro antes de abrir a rotina  ���
���          �							   			    				      ���
�������������������������������������������������������������������������͹��
���Parametro � 		                                                      ���
�������������������������������������������������������������������������ͼ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function XMNTA080()

	Local _aArea 	:= GetArea()
	Local _oBrowse	:= GetMBrowse()
	Local _cFiltro	:= ""
	Local _aGrupos

	Private aRotina := meDMnudef()		//Menudef()
	Private _cAlias := "ST9"

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	If _aGrupos[1][10][1] $ "000211#000210#000209#000000"
		_cFiltro	+= " T9_XTI = 'S' "
	Else
		_cFiltro	+= " T9_XTI = ' ' .Or. T9_XTI = 'N' "
	EndIf

	DbSelectArea(_cAlias)
 
	Set Filter To &(_cFiltro)
	(_cAlias)->(dbGoTop())

	MNTA080()

	RestArea(_aArea)

Return()

Static Function meDMnudef()

Return fwLoadMenudef("MNTA080")

