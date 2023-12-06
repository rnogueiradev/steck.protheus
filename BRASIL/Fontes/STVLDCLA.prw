#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDCLA  �Autor  �Renato Nogueira     � Data �  16/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o utilizada na altera��o da classifica��o do produto���
���          �impedindo a altera��o para comprado ou fabricado se possuir ���
���          �estrutura cadastrada									      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDCLA(cProduto,cClaProd)

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local lRet		:= .T.

If ALTERA
	
	If cClaProd=="C" .Or. cClaProd=="I"
		
		DbSelectArea("SG1")
		DbSetOrder(1) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT
		
		If DbSeek(xFilial("SG1")+cProduto)
			
			lRet	:= .F.
			MsgInfo("N�o ser� poss�vel alterar essa classifica��o pois ele j� possui pr�-estrutura cadastrada!","Erro")
			
		EndIf
		
	EndIf
	
EndIF

RestArea(aAreaSB1)
RestArea(aArea)

Return(lRet)