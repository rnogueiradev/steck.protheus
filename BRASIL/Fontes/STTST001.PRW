#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STTST001
@name STTST001
@type User Function
@desc fonte genérico para realizar exportações diversas
@author Renato Nogueira
@since 06/09/2018
/*/

User Function STTST001()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	//RpcSetType( 3 )
	//RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	
	_cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM PH3010 PH3
	_cQuery1 += " WHERE PH3.D_E_L_E_T_=' ' AND PH3_ANO='2018' AND PH3_USERID NOT IN (
	_cQuery1 += " SELECT PH3_USERID
	_cQuery1 += " FROM PH3010 PH3
	_cQuery1 += " WHERE PH3.D_E_L_E_T_=' ' AND PH3_ANO='2019')

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	aDados := {}

	While (_cAlias1)->(!Eof())
		AAdd(aDados, {UsrRetName((_cAlias1)->PH3_USERID)})
		(_cAlias1)->(DbSkip())
	EndDo

	aCabec := {"Usuário"}

	DlgToExcel({ {"ARRAY", "USUARIOS", aCabec, aDados} })

Return