#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TBICONN.CH"

user function ARINV001()

	RpcSetType( 3 )
	RpcSetEnv("07","01",,,"COM")

	_cAlias1 := GetNextAlias()
	_cQuery1 := ""

	_cQuery1 += " SELECT *
	_cQuery1 += " FROM SBF070 BF
	_cQuery1 += " LEFT JOIN SB7070 B7
	_cQuery1 += " ON B7_FILIAL=BF_FILIAL AND B7_COD=BF_PRODUTO AND B7_LOCAL=BF_LOCAL
	_cQuery1 += " AND B7_LOTECTL=BF_LOTECTL AND B7.D_E_L_E_T_=' '
	_cQuery1 += " WHERE BF.D_E_L_E_T_=' ' AND B7_COD IS NULL AND BF_LOCAL='01'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SB7")
	DbSelectArea("SB1")
	SB1->(dBsEToRDER(1))

	While (_cAlias1)->(!eof())

		_cNum := GetSxeNum("SB7","B7_DOC")
		SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->BF_PRODUTO))

		SB7->(Reclock("SB7",.T.))
		SB7->B7_FILIAL := (_cAlias1)->BF_FILIAL
		SB7->B7_COD  := (_cAlias1)->BF_PRODUTO
		SB7->B7_LOCAL := (_cAlias1)->BF_LOCAL
		SB7->B7_TIPO  := SB1->B1_TIPO
		SB7->B7_DOC := _cNum
		SB7->B7_QUANT := 0
		SB7->B7_DATA := dATE()
		SB7->B7_LOTECTL := (_cAlias1)->BF_LOTECTL
		SB7->B7_DTVALID := DATE()
		SB7->B7_LOCALIZ := (_cAlias1)->BF_LOCALIZ
		SB7->B7_ORIGEM := "MATA270"
		SB7->B7_STATUS := "1"
		SB7->B7_NUMSERI := "MANUAL"
		SB7->(MsUnLock())

		SB7->(ConfirmSX8())

		(_cAlias1)->(DbSkip())
	EndDo

return