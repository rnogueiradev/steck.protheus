#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110LEG     �Autor  �Joao Rinaldi    � Data �  02/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado Ap�s a montagem do Array        ���
���          � contendo as legendas da tabela SC1 e antes da execu��o da  ���
���          � fun��o Brwlegenda que monta a dialog com as legendas,      ���
���          � utilizado para adicionar legendas na dialog. Deve ser usado���
���          � em conjunto com o ponto MT110COR que manipula o Array com  ���
���          � as regras para apresenta��o das cores dos estatus na       ���
���          � Mbrowse                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA110.PRX                                                ���
���Nome      � Solicita��o de Compra                                      ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110LEG()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aNewLegenda  := aClone(PARAMIXB[1])
	
	aAdd(aNewLegenda,{'WARNING'         ,'Pendente de Aprova��o pelo Gestor' })
	aAdd(aNewLegenda,{'OK_15'           ,'Analisado pelo Gestor' })
	aAdd(aNewLegenda,{'XCLOSE'          ,'Rejeitado pelo Gestor' })
	aAdd(aNewLegenda,{'BR_MARRON' ,'Rejeitado por Compras' })
	
	RestArea(aArea2)
	RestArea(aArea1)
	
Return(aNewLegenda)

