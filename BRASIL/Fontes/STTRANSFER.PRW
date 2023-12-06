#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTRANSFER       | Autor | GIOVANI.ZAGO             | Data | 17/07/2014  |
|=====================================================================================|
|Descrição |  STTRANSFER tabela de transfer price                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRANSFER                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTRANSFER()
*-----------------------------*
Local aArea     := GetArea()
Local _cUsers   := GetMv("ST_TRANSPR",,"000000")+'/000000'
Private _cTrasfer	:= " "

_cTrasfer	:= GetMv("STTRANSFER",,"T01#T02#T03#T04#T05#T06#T08#GUA#EXP#EXP1") //Ticket 20211208026286

If __cUserId $ _cUsers
	DbSelectArea("DA0")
	DA0->(DbSetOrder(1))
	
	//DA0->(dbSetFilter({||DA0->DA0_CODTAB = 'T06' .OR. DA0->DA0_CODTAB = 'T01' .Or. DA0->DA0_CODTAB = 'SCH' .Or. DA0->DA0_CODTAB = 'T02' .Or. DA0->DA0_CODTAB = 'T03' .Or. DA0->DA0_CODTAB = 'T04'  .Or. DA0->DA0_CODTAB = 'T05' .OR. DA0->DA0_CODTAB = 'GUA' .OR. DA0->DA0_CODTAB = 'EXP' .OR. DA0->DA0_CODTAB = 'EX1'  }," DA0->DA0_CODTAB = 'T06' .Or. DA0->DA0_CODTAB = 'T01' .Or. DA0->DA0_CODTAB = 'SCH' .Or. DA0->DA0_CODTAB = 'T02' .Or. DA0->DA0_CODTAB = 'T03' .Or. DA0->DA0_CODTAB = 'T04'  .Or. DA0->DA0_CODTAB = 'T05' .OR. DA0->DA0_CODTAB = 'GUA' .OR. DA0->DA0_CODTAB = 'EXP' .OR. DA0->DA0_CODTAB = 'EX1' "))
	DA0->(dbSetFilter({||DA0->DA0_CODTAB $ _cTrasfer },"DA0->DA0_CODTAB $ _cTrasfer"))
	
	OMSA010()
	
	DA0->(DbClearFilter())
Else
	MsgInfo("Usuario sem Acesso...!!!")
EndIf        

Restarea(aArea)
Return()
             
/*====================================================================================\
|Programa  | STTRANSFER       | Autor | GIOVANI.ZAGO             | Data | 17/07/2014  |
|=====================================================================================|
|Descrição |  STTRANSFER tabela de transfer price                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRANSFER                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTRANSAM()
*-----------------------------*
Local aArea          := GetArea()
Local _cUsers        := GetMv("ST_TRANSAM",,"000000")+'/000000'

If __cUserId $ _cUsers
	DbSelectArea("DA0")
	DA0->(DbSetOrder(1))
	
	DA0->(dbSetFilter({||DA0->DA0_CODTAB = 'T02'}," DA0->DA0_CODTAB = 'T02' "))
	OMSA010()
	
	DA0->(DbClearFilter())
Else
	MsgInfo("Usuario sem Acesso...!!!")
EndIf        

Restarea(aArea)
Return()
	
	
/*====================================================================================\
|Programa  | STTRANSFER       | Autor | GIOVANI.ZAGO             | Data | 17/07/2014  |
|=====================================================================================|
|Descrição |  STTRANSFER tabela de transfer price   MEXICO                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRANSFER                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTRANSMEX()
*-----------------------------*
Local aArea          := GetArea()
Local _cUsers        := GetMv("ST_TRANSMX",,"000000")+'/000000'

If __cUserId $ _cUsers
	DbSelectArea("DA0")
	DA0->(DbSetOrder(1))
	
	DA0->(dbSetFilter({||DA0->DA0_CODTAB = 'T03' }," DA0->DA0_CODTAB = 'T03'  "))
	OMSA010()
	
	DA0->(DbClearFilter())
Else
	MsgInfo("Usuario sem Acesso...!!!")
EndIf        

Restarea(aArea)
Return()
	