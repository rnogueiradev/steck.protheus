#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#include "Fileio.ch"

/*====================================================================================\
|Programa  | STRESTS0        | Autor | RENATO.OLIVEIRA           | Data | 22/08/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL STRESTS0 DESCRIPTION "Retornar pedido de compra em pdf"

WSDATA cPed As String

WSMETHOD Get DESCRIPTION "Retornar pedido em pdf" WSSYNTAX "/rest/strests0"

END WSRESTFUL

WSMETHOD Get WSRECEIVE cPed WSSERVICE strests0

	Local cResp 	:= ""
	Local aFiles := {}
	Local aSizes := {}
	Local _cJsonRet := ""

	::SetContentType("application/json")

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	SC7->(DbGoTop())
	If SC7->(DbSeek(cFilAnt+Self:cPed))
		_cArq := U_RSTFAT92(.T.)
	EndIf

	ADir(_cArq, aFiles, aSizes)//Verifica o tamanho do arquivo, parâmetro exigido na FRead.

	nHandle := fopen(_cArq , FO_READWRITE + FO_SHARED )
	cString := ""
	FRead( nHandle, cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo.

	cTexto := Encode64(cString) //Converte o arquivo para BASE64

	fclose(nHandle)

	_cJsonRet := cTexto

	::SetResponse(_cJsonRet)

Return .T.
