#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STCOM060        | Autor | RENATO.OLIVEIRA           | Data | 30/07/2018  |
|=====================================================================================|
|Descri��o | RETORNA VARIAVEL COMO TEXTO			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STX3TSTR(_cCampo,_xVal)

	Local _aAreaSX3 := SX3->(GetArea())
	Local _cVal 	:= ""

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(2))

	If SX3->(DbSeek(_cCampo))

		If SX3->X3_TIPO == 'C' .Or. SX3->X3_TIPO == 'M'
			
			//_cVal := AllTrim(_xVal)
			_cVal := _xVal

		ElseIf SX3->X3_TIPO == 'D'
			
			_cVal := DtoC(_xVal)

		ElseIf SX3->X3_TIPO == 'N'
			
			_cVal := CVALTOCHAR(_xVal)

		Else
			If _xVal == .T.
				_cVal := ".T."
			Else
				_cVal := ".F."
			Endif
		EndIf

	EndIf

	RestArea(_aAreaSX3)

Return(_cVal)