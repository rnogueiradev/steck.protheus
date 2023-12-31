#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA381GRV�Autor  � RVG                � Data �  12/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos a alteracao do empenho	 Modelo II    ���
���          � (MATA381) 						                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA381GRV
	
	Local _cArea     := getarea()
	Local _cOp       := SD4->D4_OP
	
	Dbselectarea("PA1")
	PA1->(DbSetOrder(3))
	DbSeek(xFilial('PA1')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
	Do While !eof() .and. alltrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)) == ALLTRIM(PA1->PA1_DOC)
		RecLock('PA1',.F.)
		DbDelete()
		MsUnlock()
		Dbskip()
	Enddo

	Dbselectarea("PA2")
	PA2->(DbSetOrder(3))
	DbSeek(xFilial('PA2')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
	Do While !eof() .and. alltrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)) == ALLTRIM(PA2->PA2_DOC)
		RecLock('PA2',.F.)
		DbDelete()
		MsUnlock()
		Dbskip()
	Enddo

	U_STFSC10D() //Funcao gera a falta (PA1) ou reserva (PA2)

	RestArea(_cArea)

Return


