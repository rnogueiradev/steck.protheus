#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | MVIEWSB2SL      | Autor | RENATO.OLIVEIRA           | Data | 17/12/2018  |
|=====================================================================================|
|Descri��o | Manipulacao do saldo dispon�vel                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MVIEWSB2SL()

	Local _nSaldo := 0

	If AllTrim(PARAMIXB[2]) $ AllTrim(GetMv("ST_ARMDISP",,"01#04"))
		_nSaldo := PARAMIXB[3]
	EndIf

Return(_nSaldo)