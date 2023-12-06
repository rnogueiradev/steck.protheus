#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | MT150SCR        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | ATUALIZAR INFORMAÇÕES DO PEDIDO DE COMPRA                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT150SCR()

	Local _nX := 1
	
	//Limpar campos de envio de email e etc quando for um novo participante

	If Empty(CA150FORN)

		For _nX:=1 To Len(aCols)

			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XPORTAL"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XENVMAI"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XENDENT"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XCIDENT"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XNOMENT"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XCEPENT"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XCGCFOR"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XNOMFOR"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XENDFOR"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf
			_nPos := Ascan(aHeader, {|x|UPPER(AllTrim(x[2])) == "C8_XWFPED"})
			If _nPos>0
				aCols[_nX][_nPos] := ""
			EndIf

		Next

	EndIf

Return()