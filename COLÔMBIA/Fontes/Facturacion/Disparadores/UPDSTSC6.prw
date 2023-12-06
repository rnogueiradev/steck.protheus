#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | UPDSTSC6        | Autor | FABIO MOURA               | Data | 17/10/2022  |
|=====================================================================================|
|Descrição | Gatilho para atualizar os itens do pedido de vendas a partir de um       |
|          | campo no SC5                                                             |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function UPDSTSC6()

Local i         := 0
Local nPosDT    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"	} )

If valtype(ACOLS) # "U"
    For i:=1 to Len(ACOLS)
        ACOLS[ i , nPosDT] := M->C5_FECENT
    NEXT
ENDIF

GETDREFRESH()
SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
oGetDad:Refresh()
A410LinOk(oGetDad)

Return(M->C5_FECENT)
