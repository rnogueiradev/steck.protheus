#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | GP670CPO        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | PE apos gerar titulos do RH                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function GP670CPO()


DbSelectarea("CTT")
DbSetOrder(1)
If DbSeek(xFilial("CTT")+RC1->RC1_CC) .And. Rtrim(RC1->RC1_TIPO)=="RES" .And. !Empty(RC1->RC1_CC)  .And. Rtrim(SE2->E2_NATUREZ)=='22510'
	
	If RTRIM(CTT->CTT_REFCTA)=="1"
		
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CONTAD := "210110015"
		SE2->E2_CCUSTO := RC1->RC1_CC
		SE2->(MsUnLock())
	ElseIf RTRIM(CTT->CTT_REFCTA)=="2"
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CONTAD := "210110015"
		SE2->E2_CCUSTO :=  RC1->RC1_CC
		SE2->(MsUnLock())
	ElseIf RTRIM(CTT->CTT_REFCTA)=="3"
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CONTAD := "210110015"
		SE2->E2_CCUSTO := RC1->RC1_CC
		SE2->(MsUnLock())
	ElseIf RTRIM(CTT->CTT_REFCTA)=="4"
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CONTAD := "210110015"
		SE2->E2_CCUSTO := RC1->RC1_CC
		SE2->(MsUnLock())
	Endif
	
Endif



Return
