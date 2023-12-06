#include "protheus.ch"                               
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA103BUT  �Autor  �Luiz Enrique        � Data �  12/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na MATA103, Nota Fiscal de Entrada que tem���
���          � como finalidade, incluir um Botao na enchoiceBar que tem a ��� 
���          � acao de Chamar a funcao de Recebimento FATEC					  ���
�������������������������������������������������������������������������͹��
���Uso       � STECK						                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function MA103BUT() 

Local aBotao:={} 

aBotao := U_GTPE014()

//aadd(aBotao, {'HISTORIC',{||U_STFSRE10()},"Recebimento FATEC","Recebimento FATEC"})		
aadd(aBotao, {'HISTORIC',{||U_STSCH001()},"Pre�o Rem Schneider","Pre�o Rem Schneider"})		
Return aBotao 

