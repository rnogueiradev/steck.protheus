#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | LOCXPE32         | Autor | RENATO.OLIVEIRA           | Data | 06/12/2018  |
|=====================================================================================|
|Descrição | PE para ajustar numeracao de nota de credito                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
| Ticket - 20210528008864 - 														  |	
\====================================================================================*/

User Function LOCXPE32()

    Local _cFiltro := ""

    If ISINCALLSTACK("MATA465N")
    	If SX2->X2_CHAVE == "SD1"
	    	If Alltrim(M->F1_ESPECIE) =="NCC"
	    		Do Case
	    			Case M->F1_PV == "0003"
	    				SX5->(dbSetFilter({|| SX5->(Recno())=9650 }," SX5->(Recno())=9650 "))
	    			Case M->F1_PV == "0008"
	    				SX5->(dbSetFilter({|| SX5->(Recno())=9984 }," SX5->(Recno())=9984 "))
	    		EndCase
	    	Endif
	    Else
	    	If Alltrim(M->F2_ESPECIE) =="NDC"
	    		If M->F2_PV == "0003" 
	    			SX5->(dbSetFilter({|| SX5->(Recno())=9651 }," SX5->(Recno())=9651 "))
	    		Endif
	    	Endif
	    EndIf
    EndIf

Return(_cFiltro)