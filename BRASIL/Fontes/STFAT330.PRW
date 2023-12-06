#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT330        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
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

User Function STFAT330()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _nCount	:= 0
	Local _cData	:= ""
	Local _cDados   := ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT Z1A.R_E_C_N_O_ RECZ1A, Z1A_DATA
	_cQuery1 += " FROM "+RetSqlName("Z1A")+" Z1A
	_cQuery1 += " WHERE Z1A.D_E_L_E_T_=' ' AND Z1A_DATA BETWEEN '20191201' AND '20191231'
	_cQuery1 += " AND Z1A_Q1=1 AND Z1A_Q2=1
	_cQuery1 += " ORDER BY Z1A_DATA

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("Z1A")

	While (_cAlias1)->(!Eof())

		Z1A->(DbGoTo((_cAlias1)->RECZ1A))

		_cData := DTOC(Z1A->Z1A_DATA)

		_nCount += Len(StrToArray(Z1A->Z1A_PARA,";"))
		_nCount += Len(StrToArray(Z1A->Z1A_CC,";"))
		_nCount += Len(StrToArray(Z1A->Z1A_CCO,";"))

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			If !(_cData==DTOC(STOD((_cAlias1)->Z1A_DATA)))
				_cDados += _cData+";"+cValToChar(_nCount)+CHR(13)+CHR(10)
				_nCount := 0
			EndIf
		Else
			_cDados += _cData+";"+cValToChar(_nCount)+CHR(13)+CHR(10)
		EndIf

	EndDo

Return()