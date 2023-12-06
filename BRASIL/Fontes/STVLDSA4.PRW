#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STVLDSA4        | Autor | RENATO.OLIVEIRA           | Data | 04/12/19    |
|=====================================================================================|
|Descrição | Rotina para validar regras de transportadora                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STVLDSA4(_cTpFrete,_cTransp)

	Local _lRet := .T.

	_cTpFrete := AllTrim(_cTpFrete)
	_cTransp  := AllTrim(_cTransp)

	If cEmpAnt=="03"
		Return(.T.)
	EndIf

	Do Case
		Case _cTpFrete=="C"
		If !(_cTransp $ "000001#000163")
			MsgAlert("Para frete CIF a transportadora só pode ser Steck ou TNT")
			_lRet := .F.
		EndIf
		Case _cTpFrete=="F"
		_lRet := .T.
	EndCase

Return(_lRet)