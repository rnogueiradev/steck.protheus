#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA010BUT	�Autor  �Renato Nogueira     � Data �  23/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para adicionar fun��es dentro da op��o 	  ���
���          �de incluir produtos				  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum 										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA010BUT()

	Local aButtons := {}

	AAdd(aButtons,{'NOTE',{| | U_STNEXTU() }, 'Gerar c�digo U','Gerar c�digo U' } ) 
	AAdd(aButtons,{'NOTE',{| | VISSB5() }, 'Complemento de produto','Complemento de produto' } )

Return (aButtons)

/*/{Protheus.doc} VISSB5
@name VISSB5
@type User Function
@desc abrir visualiza��o do cadastro na sb5
@author Renato Nogueira
@since 10/07/2018
/*/

Static Function VISSB5()

	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	SB5->(DbGoTop())
	If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
		Ma180Alt("SB5",SB5->(Recno()),2)
	Else
		MsgAlert("Complemento de produto n�o encontrado!")
	EndIf

Return()