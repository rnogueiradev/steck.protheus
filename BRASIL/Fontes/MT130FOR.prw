#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MT130FOR        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descrição | MT130FOR                                                                 |
|          | Valida fornecedor no gera cotação			                              |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MT130FOR                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT130FOR()

	Local _aArea    := GetArea()
	Local _nX		  := 0
	Local _aFornec  := {}

	DbSelectArea("SA5")
	SA5->(DbSetOrder(1))

	For _nX:=1 To Len(PARAMIXB)

		If SA5->(DbSeek(xFilial("SA5")+PARAMIXB[_nX][1]+PARAMIXB[_nX][2]+SC1->C1_PRODUTO))
			If !(AllTrim(SA5->A5_SITU)=="D") .And. U_STVLDSA2(PARAMIXB[_nX][1],PARAMIXB[_nX][2])
				AADD(_aFornec,{PARAMIXB[_nX][1],PARAMIXB[_nX][2],PARAMIXB[_nX][3],PARAMIXB[_nX][4],PARAMIXB[_nX][5],})
			EndIf
		EndIf

	Next

	RestArea(_aArea)

Return(_aFornec)