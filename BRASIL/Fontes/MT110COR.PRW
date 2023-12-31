#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110COR     �Autor  �Joao Rinaldi    � Data �  02/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado para manipular o Array com as   ���
���          � regras para apresenta��o das cores dos estatus na Mbrowse. ���
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
User Function MT110COR()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aNewCores := aClone(PARAMIXB[1])
	Local _nI
	
	For _nI := 1 to Len(aNewCores)
		aNewCores[_nI][1] := aNewCores[_nI][1] + " .And. (C1_ZSTATUS == '3' .Or. C1_ZSTATUS == ' ' .Or. C1_ZSTATUS == '6')"
	Next _nI
	
	//aAdd(aNewCores,{ "C1_ZSTATUS == ' '" , "WEB"})//Sem Aprova��o - Antes da implanta��o da Melhoria
	//aAdd(aNewCores,{ "C1_ZSTATUS == '3'" , "TRIUP"})//Aprovado
	
	aAdd(aNewCores,{ "C1_ZSTATUS == '1'" , "WARNING"})//Pendente de Aprova��o pelo Gestor
	aAdd(aNewCores,{ "C1_ZSTATUS == '2'" , "OK_15"})//Analisado pelo Gestor
	aAdd(aNewCores,{ "C1_ZSTATUS == '4'" , "XCLOSE"})//Rejeitado pelo Gestor
	aAdd(aNewCores,{ "C1_ZSTATUS == '5'" , "BR_MARRON"})//Rejeitado por Compras
	
	RestArea(aArea2)
	RestArea(aArea1)
	
Return (aNewCores)
