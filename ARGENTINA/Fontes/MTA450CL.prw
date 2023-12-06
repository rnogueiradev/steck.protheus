#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA450CL  �Autor  �Everson Santana     � Data �  19/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s libera��o manual financeira por pedido���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Parametros� Ajustado para utilizar na Argentina - Everson Santana      ���
�������������������������������������������������������������������������ͼ��
���Retorno	 � Nulo	                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA450CL()

	Local _aArea     := GetArea()
	Local nOpca 	 := PARAMIXB[1]

	If nOpca == 1 .AND. FUNNAME() <> 'MATA455'
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))

		IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ))

			While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
				U_ARLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,.T.,.F.)
				SC6->(DbSkip())
			End

		EndIf
	EndIf

	RestArea(_aArea)

Return()
