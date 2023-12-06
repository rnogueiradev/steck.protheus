#INCLUDE "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MT500APO      �Autor  � Renato Nogueira  � Data �30.01.2014 ���
��������������������������������������������������������������������������Ĵ��
���          �Ponto de entrada ap�s a elimina��o do res�duo			       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function MT500APO()

Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local lResiduo  := PARAMIXB[1]

If SC5->(!Eof())
	
	SC5->(Reclock("SC5"),.F.)
	SC5->C5_ZBLOQ		:= "2"	//Renato Nogueira - Chamado 000144 - Campo limpo para sumir da tela de aprova��o e ficar com a legenda correta
	SC5->C5_ZMOTBLO		:= ' '
	SC5->(Msunlock())
	
EndIf


IF lResiduo // Residuo eliminado com sucesso grava o campo da data. 036659 
   SC6->(RECLOCK('SC6',.F.))
   SC6->C6_ZDTENRE:=DATE() // Grava data do sistema como entrega 
   SC6->(MSUNLOCK('SC6'))
ENDIF


RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aArea)

Return
