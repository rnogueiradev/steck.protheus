#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103CUST 	�Autor  �Giovani Zago        � Data �  15/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado Manipular Custo de Entrada	 			  ���
���          �										   				      ���
�������������������������������������������������������������������������͹��
���Parametro � 		                                                      ���
�������������������������������������������������������������������������ͼ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A103CUST ()

Local _aArea 		:= GetArea()
Local aRet 			:= PARAMIXB[1] // Conteudo do aRet// aRet[1,1] -> Custo de entrada na Moeda 1// aRet[1,2] -> Custo de entrada na Moeda 2// aRet[1,3] -> Custo de entrada na Moeda 3// aRet[1,4] -> Custo de entrada na Moeda 4// aRet[1,5] -> Custo de entrada na Moeda 5// Customizacoes do Cliente






RestArea(_aArea)
Return(aRet)