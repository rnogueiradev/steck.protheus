#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT102BUT    �Autor  �Cristiano Pereira  � Data �  01/15/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adicionar op��es no aRotina das lanc contabeis             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CT102BUT()

	_aArea:= GetArea()

	If cusername$GetMV("ST_APCTBN1")

		aAdd(ParamIXB,{"Aprova��es Lan�amentos","CTBA350()", 0, 2, 0, Nil })
	Endif

	RestArea(_aArea)

Return ParamIXB