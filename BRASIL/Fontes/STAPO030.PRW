#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STAPO030        | Autor | RENATO.OLIVEIRA           | Data | 12/01/2022  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STAPO030()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea("SC5")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND SUBSTR(C5_EMISSAO,1,4)='2021'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	DbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
		If SC5->(!Eof())
			SC5->(RecLock("SC5",.F.))
			SC5->C5_EMISSAO := cToD(FWLeUserlg("C5_USERLGI", 2))
			SC5->(MsUnLock())
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()
