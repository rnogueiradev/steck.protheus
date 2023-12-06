#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#define CLRF Chr(13)+Chr(10)

/*====================================================================================\
|Programa  | STRH0020        | Autor | RENATO.OLIVEIRA           | Data | 13/07/2022  |
|=====================================================================================|
|Descrição | Gerar arquivos csv propay                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STRH0020()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _aTabs   := {}
	Local _nX 	   := 0
	Local _nY 	   := 0

	RpcSetType( 3 )
	RpcSetEnv( "01", "01" ,,,"FAT")

	ConOut(CRLF + "[STRH0020]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	AADD(_aTabs,'CTT')
	AADD(_aTabs,'SRV')
	AADD(_aTabs,'SA6')
	AADD(_aTabs,'SI3')
	AADD(_aTabs,'SR0')
	AADD(_aTabs,'SR1')
	AADD(_aTabs,'SR2')
	AADD(_aTabs,'SR3')
	AADD(_aTabs,'SR4')
	AADD(_aTabs,'SR5')
	AADD(_aTabs,'SR6')
	AADD(_aTabs,'SR7')
	AADD(_aTabs,'SR8')
	AADD(_aTabs,'SR9')
	AADD(_aTabs,'SRA')
	AADD(_aTabs,'SRB')
	AADD(_aTabs,'SRC')
	AADD(_aTabs,'SRD')
	AADD(_aTabs,'SRE')
	AADD(_aTabs,'SRF')
	AADD(_aTabs,'SRG')
	AADD(_aTabs,'SRH')
	AADD(_aTabs,'SRI')
	AADD(_aTabs,'SRJ')
	AADD(_aTabs,'SRK')
	AADD(_aTabs,'SRL')
	AADD(_aTabs,'SRM')
	AADD(_aTabs,'SRN')
	AADD(_aTabs,'SRO')
	AADD(_aTabs,'SRP')
	AADD(_aTabs,'SRQ')
	AADD(_aTabs,'SRR')
	AADD(_aTabs,'SRS')
	AADD(_aTabs,'SRT')
	AADD(_aTabs,'SRU')
	AADD(_aTabs,'SRW')
	AADD(_aTabs,'SRX')
	AADD(_aTabs,'SRY')
	AADD(_aTabs,'SRZ')
	AADD(_aTabs,'SYP')
	AADD(_aTabs,'RHQ')
	AADD(_aTabs,'RGW')
	AADD(_aTabs,'RGX')
	AADD(_aTabs,'RGZ')
	AADD(_aTabs,'RGY')
	AADD(_aTabs,'RHK')
	AADD(_aTabs,'RHL')
	AADD(_aTabs,'RHM')
	AADD(_aTabs,'RHN')
	AADD(_aTabs,'RHO')
	AADD(_aTabs,'RHP')
	AADD(_aTabs,'RHR')
	AADD(_aTabs,'RHS')
	AADD(_aTabs,'RHH')
	AADD(_aTabs,'RF1')
	AADD(_aTabs,'RFC')
	AADD(_aTabs,'RFI')
	AADD(_aTabs,'RFR')
	AADD(_aTabs,'RFS')
	AADD(_aTabs,'RAE')
	AADD(_aTabs,'RFX')
	AADD(_aTabs,'RFY')
	AADD(_aTabs,'RFZ')
	AADD(_aTabs,'RI1')
	AADD(_aTabs,'SX5')

	For _nX:=1 To Len(_aTabs)

		ConOut(CRLF + "[STRH0020]["+ FWTimeStamp(2) +"] Inicio tabela "+_aTabs[_nX])

		cArquivo := _aTabs[_nX]+cEmpAnt+".csv"

		If File("\arquivos\bpo_folha\" + cArquivo)
			Loop
		EndIf

		oFWriter := FWFileWriter():New("\arquivos\bpo_folha\" + cArquivo, .T.)

		oFWriter:Create()

		_cLinha := ""

		aStruct := (_aTabs[_nX])->( dbStruct() )

		For _nY:=1 To Len(aStruct)
			_cLinha += aStruct[_nY][1]+";"
		Next

		_cLinha += CLRF

		oFWriter:Write(_cLinha)

		_cLinha := ""

		DbSelectArea(_aTabs[_nX])

		While (_aTabs[_nX])->(!Eof())

			For _nY:=1 To Len(aStruct)
				_cLinha += Arruma((_aTabs[_nX])->&(aStruct[_nY][1]),aStruct[_nY][2])+";"
			Next

			_cLinha += CLRF
			oFWriter:Write(_cLinha)

			_cLinha := ""

			(_aTabs[_nX])->(DbSkip())
		EndDo

		oFWriter:Close()

		DbCloseArea(_aTabs[_nX])

		ConOut(CRLF + "[STRH0020]["+ FWTimeStamp(2) +"] Fim tabela "+_aTabs[_nX])

	Next

	ConOut(CRLF + "[STRH0020]["+ FWTimeStamp(2) +"] Fim do processamento.")

	Reset Environment

Return()

Static Function Arruma(_xVal,_cTipo)

	Local _cVal 	:= ""

	If _cTipo == 'C' .Or. _cTipo == 'M'
		_cVal := _xVal
	ElseIf _cTipo == 'D'
		_cVal := DtoC(_xVal)
	ElseIf _cTipo == 'N'
		_cVal := CVALTOCHAR(_xVal)
	Else
		If _xVal == .T.
			_cVal := ".T."
		Else
			_cVal := ".F."
		Endif
	EndIf

Return(_cVal)
