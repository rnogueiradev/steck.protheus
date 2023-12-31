#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT202PAI  �Autor  �Renato Nogueira     � Data �  04/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar o produto principal inserido na pre-estrutura       ���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Uso       �Steck                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT202PAI()

Local aArea     := GetArea()
Local aAreaSG1  := SG1->(GetArea())
Local aAreaSGG  := SGG->(GetArea())
Local _lRet		:= .T.
Local _cProduto := PARAMIXB

//PARAMIXB[1]

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+AllTrim(_cProduto))

If SB1->(!Eof())
	If SB1->B1_CLAPROD=="C" .Or. SB1->B1_CLAPROD=="I"
		MsgInfo("Este produto n�o pode ser utilizado nesta rotina pois � comprado ou importado!","Erro")
		_lRet	:= .F.
	EndIf
EndIf

If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC"
	
	//_lRet	:= .F.
	//MsgAlert("Item de consumo n�o utilizar em estrutura")
	
EndIf


RestArea(aAreaSG1)
RestArea(aAreaSGG)
RestArea(aArea)

Return(_lRet)