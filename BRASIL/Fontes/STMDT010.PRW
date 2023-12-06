#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#define CLRF Chr(13)+Chr(10)

/*
|Programa  | STMDT010        | Autor | RENATO.OLIVEIRA           | Data | 01/06/2023  |
|=====================================================================================|
|Descrição | Gerar arquivos csv master data                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
*/

User Function STMDT001()
	U_STMDT010("01","05")
Return
User Function STMDT003()
	U_STMDT010("03","01")
Return
User Function STMDT011()
	U_STMDT010("11","01")
Return

User Function STMDT010(_cEmp,_cFil)

	Local cCaminho := ""
	Local cEmpresa := ""
	Local aRet := {}
	Local aButtons := {}
	Local aPergs := {}
	Local oFile
	Local aCampos := {}
	Local _cQuery := ""
	Local _cAlias := ""
	Local _nX := 0

	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil

	_cAlias := GetNextAlias()

	ConOut(CRLF + "[STMDT010]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	AADD( aPergs ,{6,"Arquivo:",cCaminho,"","","",80,.T.,"Arquivo TXT|*.txt"})
	AADD(aPergs, {2, "Sub negocio?",      2, {"1=Sim", "2=Não"},090, ".T.", .F.})
	AADD(aPergs, {2, "Bloqueado?",      2, {"1=Sim", "2=Não", "3=Sem filtro"},090, ".T.", .F.})

	If ParamBox(aPergs ,"Informe os Dados",@aRet,,aButtons,,,,,,.F.)

		oFile := FWFileReader():New(AllTrim(MV_PAR01))

		If (oFile:Open())
			While (oFile:hasLine())
				aCampos := Separa(oFile:GetLine(),";")
			End
			oFile:Close()
		EndIf

	EndIf

	_cQuery := " SELECT B1.R_E_C_N_O_ REC,
	_cQuery += " NVL(B111.B1_COD,' ') COD11,
	_cQuery += " NVL(B101.B1_COD,' ') COD01,
	_cQuery += " NVL(B103.B1_COD,' ') COD03
	_cQuery += " FROM "+RetSqlName("SB1")+" B1
	_cQuery += " LEFT JOIN UDBD11.SB1110 B111
	_cQuery += " ON B111.B1_COD=B1.B1_COD AND B111.D_E_L_E_T_=' '
	_cQuery += " LEFT JOIN UDBP12.SB1010 B101
	_cQuery += " ON B101.B1_COD=B1.B1_COD AND B101.D_E_L_E_T_=' '
	_cQuery += " LEFT JOIN UDBP12.SB1030 B103
	_cQuery += " ON B103.B1_COD=B1.B1_COD AND B103.D_E_L_E_T_=' '
	_cQuery += " WHERE B1.D_E_L_E_T_=' '
	_cQuery += " AND B1.B1_TIPO IN ('PA')
	
	If cValToChar(MV_PAR03)=="2"
		_cQuery += " AND B1.B1_MSBLQL<>'1' AND B1.B1_SELO <> '2'
	ElseIf cValToChar(MV_PAR03)=="1"
		_cQuery += " AND B1.B1_MSBLQL='1' OR B1.B1_SELO = '2'
	EndIf

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	DbSelectArea("SB1")

	_cArqSaida := ""

	cPasta := "C:\arquivos_protheus\"
	cArquivo := StrTran(Time(),":")+".csv"

	oFWriter := FWFileWriter():New(cPasta+cArquivo, .T.)
	oFWriter:Create()

	_cSep := "#"

	_cArqSaida += "B1_COD"+_cSep+"EMPRESA"+_cSep

	For _nX:=1 To Len(aCampos)
		_cArqSaida += aCampos[_nX]+_cSep
	Next

	_cArqSaida += chr(13)+chr(10)

	While (_cAlias)->(!Eof())

		SB1->(DbGoTo((_cAlias)->REC))
		If SB1->(!Eof())

			_cArqSaida += AllTrim(SB1->B1_COD)+_cSep

			If AllTrim(cValToChar(MV_PAR02))=="1"
				_cArqSaida += cEmpAnt
			Else
				If !Empty((_cAlias)->COD11)
					_cArqSaida += "11|"
				EndIf
				If !Empty((_cAlias)->COD01)
					_cArqSaida += "01|"
				EndIf
				If !Empty((_cAlias)->COD03)
					_cArqSaida += "03|"
				EndIf
			EndIf

			_cArqSaida += _cSep

			For _nX:=1 To Len(aCampos)
				_cArqSaida += Arruma(SB1->&(aCampos[_nX]),TamSx3(aCampos[_nX])[3],aCampos[_nX])+_cSep
			Next

			_cArqSaida += chr(13)+chr(10)
			oFWriter:Write(_cArqSaida)
			_cArqSaida := ""
		EndIf

		(_cAlias)->(DbSkip())
	EndDo

	oFWriter:Close()

	ShellExecute("OPEN", cArquivo, "", cPasta, 1 )

	(_cAlias)->(DbCloseArea())

	ConOut(CRLF + "[STMDT010]["+ FWTimeStamp(2) +"] Fim do processamento.")

	Reset Environment

Return()

Static Function Arruma(_xVal,_cTipo,_cCampo)

	Local _cVal 	:= ""

	If _cTipo == 'C' .Or. _cTipo == 'M'
		_cVal := _xVal

		If AllTrim(_cCampo)=="B1_DESC_I"
			_cVal := MSMM(SB1->B1_DESC_I)
		EndIf

		_cVal := StrTran(_cVal,chr(13)+chr(10))
		_cVal := AllTrim(_cVal)

	ElseIf _cTipo == 'D'
		_cVal := DtoC(_xVal)
	ElseIf _cTipo == 'N'
		_cVal := StrTran(StrTran(CVALTOCHAR(_xVal),",",""),".",",")
	Else
		If _xVal == .T.
			_cVal := ".T."
		Else
			_cVal := ".F."
		Endif
	EndIf

Return(_cVal)
