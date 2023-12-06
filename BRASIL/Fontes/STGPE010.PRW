#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STGPE010
@name STGPE010
@type User Function
@desc ajustar cadastros portal RH
@author Renato Nogueira
@since 31/07/2019
/*/

User Function STGPE010()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"
	Local _cQuery1 	:= ""

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cQuery1 := " UPDATE "+RetSqlName("RD0")
	_cQuery1 += " SET RD0_LOGIN=RD0_CIC
	_cQuery1 += " WHERE D_E_L_E_T_=' ' AND RD0_MSBLQL='2' AND RD0_LOGIN<>RD0_CIC

	TcSqlExec(_cQuery1)

	Reset Environment

Return