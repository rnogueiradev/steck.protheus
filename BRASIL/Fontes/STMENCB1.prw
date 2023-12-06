#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA010NC	�Autor  �Renato Nogueira     � Data �  28/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para restringir os campos que ser�o copiados���
���          �na fun��o de copia de produto		  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Array com campos que ser�o exclu�dos da c�pia              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STMENCB1()

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
                     
If cEmpAnt == "01"
	If msgyesno("Deseja copiar o produto para a empresa Manaus?")
		U_STCOPIAB1() //Copiar produto para AM
	EndIf
EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return()