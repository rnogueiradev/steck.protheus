#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | TABVIGEN        | Autor | FABIO MOURA               | Data | 17/10/2022  |
|=====================================================================================|
|Descrição | Retorna a tabela vigente no campo C5_TABELA                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function TABVIGEN()

Local _cTAB  := ""
Local cQuery := "" 

cQuery := "SELECT DA0_CODTAB FROM "+RETSQLNAME("DA0")+" WHERE D_E_L_E_T_='' "
cQuery += "AND (DA0_DATDE <= '"+DToS(dDatabase)+"' AND DA0_DATATE >= '"+DToS(dDatabase)+"' ) "
cQuery += "AND DA0_CODTAB <> '099' " // TABELA 099 é para um cliente específico

cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TRB"
	
_cTAB := TRB->DA0_CODTAB

TRB->(DBCLOSEAREA())

Return(_cTAB)
