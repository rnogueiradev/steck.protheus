#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STCOM090        | Autor | RENATO.OLIVEIRA           | Data | 19/11/2018  |
|=====================================================================================|
|Descrição | RETORNAR VALORES DA COTAÇÃO			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM090(_cCampo)

	Local _nPosCot := aScan(aHeader,{|x| AllTrim(x[2])==('C7_NUMCOT')})
	Local _nPosIte := aScan(aHeader,{|x| AllTrim(x[2])==('C7_ITEM')})
	Local _nValor  := 0

	DbSelectArea("SC8")
	SC8->(DbSetOrder(1))

	If SC8->(DbSeek(xFilial("SC8")+aCols[n][_nPosCot]+CA120FORN+CA120LOJ+aCols[n][_nPosIte]))
		_nValor := &("SC8->"+_cCampo)
	EndIf

Return(_nValor)