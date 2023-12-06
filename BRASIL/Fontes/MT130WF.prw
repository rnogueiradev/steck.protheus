#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MT130WF        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descri��o | MT130WF                                                                 |
|          | Ao final da gera��o das cota��es			                              |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MT130WF                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT130WF()

	Local _nX 		:= 0
	Local _aAreaSC8 := SC8->(GetArea())
	Local aCots		:= PARAMIXB

	DbSelectArea("SC8")
	SC8->(DbSetOrder(1))

	For _nX:=1 To Len(aCots[2])

		SC8->(DbSeek(xFilial("SC8")+aCots[2][_nX]))

		While SC8->(!Eof()) .And. SC8->(C8_FILIAL+C8_NUM)==xFilial("SC8")+aCots[2][_nX]

			SC8->(RecLock("SC8",.F.))
			SC8->C8_BASEIPI := 0
			SC8->C8_ALIIPI  := 0
			SC8->C8_VALIPI  := 0
			SC8->C8_BASEICM := 0
			SC8->C8_PICM 	:= 0
			SC8->C8_VALICM  := 0
			SC8->C8_PRAZO   := 0
			SC8->(MsUnLock())

			SC8->(DbSkip())
		EndDo

	Next

	RestArea(_aAreaSC8)

Return()