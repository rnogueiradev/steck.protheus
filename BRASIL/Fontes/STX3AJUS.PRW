#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STX3AJUS        | Autor | RENATO.OLIVEIRA           | Data | 30/07/2018  |
|=====================================================================================|
|Descrição | RETORNA VARIAVEL DE ACORDO COM O TIPO NO SX3                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STX3AJUS(_cCampo,_cVal)

	Local _aAreaSX3 := SX3->(GetArea())
	Local _xVal 	:= ""
	Default _cVal	:= ""

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(2))

	If SX3->(DbSeek(_cCampo))

		If SX3->X3_TIPO == 'C' .Or. SX3->X3_TIPO == 'M'
			
			//_xVal := AllTrim(_cVal)
			_xVal := _cVal

		ElseIf SX3->X3_TIPO == 'D'
			
			_xVal := StoD(_cVal)

		ElseIf SX3->X3_TIPO == 'N'
			
			_xVal := Val(_cVal)

		Else
			If _cVal := ".T."
				_xVal := .T.
			Else
				_xVal := .T.
			Endif
		EndIf

	EndIf

	RestArea(_aAreaSX3)

Return(_xVal)