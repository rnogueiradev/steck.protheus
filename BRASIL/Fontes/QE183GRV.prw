#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QE183GRV  �Autor  �Renato Nogueira     � Data �  02/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para preencher o numero da fatec dos itens que       ���
���          �cairem na rotina de importacao                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function QE183GRV()

Local cArea 	:= getArea()
Local aQEKArea	:= QEK->(GetArea())

If Empty(QEK->QEK_XFATEC)
	
	If !Empty(SD1->D1_XFATEC) .And. QEK->(!Eof())
		
		QEK->(RecLock('QEK',.F.))
		QEK->QEK_XFATEC := SD1->D1_XFATEC
		QEK->(MsUnLock())
		
	EndIf
	
EndIf

RestArea(aQEKArea)
RestArea(cArea)

Return()