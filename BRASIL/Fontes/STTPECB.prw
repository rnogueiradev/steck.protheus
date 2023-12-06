#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTPECB   �Autor  �Renato Nogueira     � Data �  16/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar tipo de entrega - Cabe�alho PV					  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STTPECB(cTransp,cTipo)

Local aArea     := GetArea()
Local lRet		:= .T.
Local cTipoEnt	:= ""

DbSelectArea("SA4")
DbSetOrder(1)
DbSeek(xFilial("SA4")+cTransp)

If SA4->(!Eof()) .And. A4_XSTEENT=="N" .And. cTipo<>"R"
	
	MsgAlert("Aten��o, o tipo de entrega nesse caso deve ser retira, qualquer problema contate o departamento de Transportes")
	lRet	:= .F.
	
EndIf

RestArea(aArea)

Return(lRet)