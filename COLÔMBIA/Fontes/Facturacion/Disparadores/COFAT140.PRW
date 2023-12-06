#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | COFAT140        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COFAT140()
	Local _cObs := ""
	_cObs := "Cnt "+AllTrim(M->C5_XNOMECT)+" Tel "+AllTrim(M->C5_XTEL)+" Hr "+AllTrim(M->C5_XHORA)+CHR(13)+CHR(10)
	_cObs += "Dir "+AllTrim(M->C5_XENDENT)+" - "+AllTrim(M->C5_XMUN)+" - "+AllTrim(Posicione("SX5",1,xFilial("SX5")+"12"+M->C5_XCIUD,"X5_DESCSPA"))+CHR(13)+CHR(10)
	//_cObs += "Céd "+M->C5_XCED+CHR(13)+CHR(10)
Return(_cObs)
