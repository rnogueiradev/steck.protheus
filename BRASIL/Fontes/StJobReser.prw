#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"


/*====================================================================================\
|Programa  | JOBATU           | Autor | GIOVANI.ZAGO             | Data | 22/01/2013  |
|=====================================================================================|
|Descrição | JOBATU      JOB limpa reserva e falta                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | JOBATU                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function StJobReser()
*-----------------------------*
Local cNumPed 	:= ''//SC5->C5_NUM
Local aArea 	:= GetArea()
Local aSC6Area	:= SC6->(GetArea())
Local cItemPed  := ''
Local cProduto  := ''
Local nQtde	    := 0

DbSelectArea("PA1")
PA1->(DbSetOrder(2))
PA1->(DbSeek(xFilial('PA1')+'1'))
DbSelectArea("SC6")
SC6->(DbSetOrder(1))
Do While PA1->(!Eof()) .And. PA1->PA1_TIPO = '1'
	
	
	If SC6->(DbSeek(xFilial('SC6')+ALLTRIM(PA1->PA1_DOC)))
		
		If AvalTes(SC6->C6_TES,'S')
			cItemPed := SC6->C6_ITEM
			cProduto := SC6->C6_PRODUTO
			nQtde	 := SC6->C6_QTDVEN-SC6->C6_QTDENT
		EndIf
		
		
	   //	U_STGrvSt(SC6->C6_PRODUTO,SC5->C5_XTIPF=="2")  // analisa e grava o status
	   //	U_STPriSC5()  // grava prioridade
	EndIf
	PA1->(DbSkip())
End
Return()

