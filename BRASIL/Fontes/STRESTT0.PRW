#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#include "Fileio.ch"

/*====================================================================================\
|Programa  | STRESTT0        | Autor | RENATO.OLIVEIRA           | Data | 22/08/2021  |
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

WSRESTFUL STRESTT0 DESCRIPTION "Retornar danfe em pdf"

WSDATA cChave As String

WSMETHOD Get DESCRIPTION "Retornar danfe em pdf" WSSYNTAX "/rest/strestt0"

END WSRESTFUL

WSMETHOD Get WSRECEIVE cChave WSSERVICE strestt0

	Local cResp 	:= ""
	Local aFiles := {}
	Local aSizes := {}
	Local _cJsonRet := '{"pdf":"

	::SetContentType("application/json")

	U_STXPRTNF(::cChave,.T.)

	cDir := GetMv("ST_FTPPRC1",,"\arquivos\xml_nfe\"+cEmpAnt+"\"+::cChave+".pdf")

	ADir(cDir, aFiles, aSizes)//Verifica o tamanho do arquivo, parâmetro exigido na FRead.

	nHandle := fopen(cDir , FO_READWRITE + FO_SHARED )
	cString := ""
	FRead( nHandle, cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo.

	cTexto := Encode64(cString) //Converte o arquivo para BASE64

	fclose(nHandle)

	_cJsonRet += cTexto+'"}'
	_cJsonRet := cTexto

	::SetResponse(_cJsonRet)

Return .T.
