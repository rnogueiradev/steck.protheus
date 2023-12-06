#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEST040        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | Rotina para carregar inicializares padrão no produto                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST040(_cCampo)

	Local _xRet := 0

	Return(.T.)

	If ISINCALLSTACK("MC050Con")
		Return(_xRet)
	EndIf

	_cCampo := Alltrim(_cCampo)


	Do Case
		Case _cCampo=="B1_XPESMAS"
		_xRet := ((M->B1_XQTEAN2/M->B1_XQTEAN1)*M->B1_XPESCOL)+GetAdvFVal("CB3","CB3_PESO",xFilial("CB3")+M->B1_XEMBMAS,1,0)
	EndCase

Return(_xRet)