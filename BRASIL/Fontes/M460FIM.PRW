#include "PROTHEUS.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �Microsiga           � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada apos o faturamento da nota fiscal de saida ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIM()
U_STFS71F2()	//Atualiza informacoes de Nota/Serie em PE1
//U_STFS71F3()	//Grava a Pre-Nota na empresa destino // desabilitado por giovani zago 01/07/15 pre-nota esta sendo gerada pela importa��o do xml.
U_STFSVE91("+")	//Atualiza quantidade (frequencia) de notas fiscais emitidas para o cliente
U_STFS71F5()	//Atualiza informacao de Nota/Serie em CB7/ACD - Leonardo Flex -> 13/03/2013
U_STFS71F6()	//Atualiza informacao do pedido caso nao tenha sido atendido totalmente - Leonardo Flex -> 13/03/2013 
U_STLEG410()    // Atualiza SC5 tratamento de legenda   GIOVANI.ZAGO 25/03/13  
U_STGUIAREC()   // Atualiza SF2 tratamento de GUIA DE RECOLHIMENTO   GIOVANI.ZAGO 16/01/14 
U_STREGPER()	//	Fonte utilizado para verificar se a nota � referente a extravio de mercadoria pela transportadora - Eduardo Matias 18/02/19
U_STFS71DT()    // Atualiza a data de entrega C6_ZDTENRE para os pedidos retira 
Return
