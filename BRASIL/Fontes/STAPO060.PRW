#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STAPO060        | Autor | RENATO.OLIVEIRA           | Data | 12/01/2022  |
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

User Function STAPO060()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Private PARAMIXB
	Private Altera := .T.
	Private INCLUI := .F.

	RpcSetType( 3 )
	RpcSetEnv("01","05",,,"FAT")

	__cUserId := "001526"

	DbSelectArea("SC5")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND SUBSTR(C5_EMISSAO,1,4)='2022' 
	_cQuery1 += " AND C5_FILIAL='05'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	DbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		PARAMIXB := {4}


		SC5->(DbGoTo((_cAlias1)->RECSC5))
		If SC5->(!Eof())
			If U_Mt410Ace()
				U_M410STTS()
			EndIf
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()
