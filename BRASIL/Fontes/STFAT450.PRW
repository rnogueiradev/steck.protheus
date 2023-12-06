#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT450        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
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

User Function STFAT450()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "02"

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT B1.R_E_C_N_O_ RECSB1
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B1_GRUPO='40F'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SB1")

	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		SB1->(DbGoTo((_cAlias1)->RECSB1))

		If SB1->(!Eof())

			If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
				SB5->(RecLock("SB5",.F.))
			Else
				SB5->(RecLock("SB5",.T.))
			EndIf
			
			SB5->B5_COD 	:= SB1->B1_COD
			SB5->B5_CEME	:= SB1->B1_DESC
			SB5->B5_UMIND   := "1"
			SB5->B5_INSPAT 	:= "1"
			SB5->B5_CODATIV := "99999999"    
			SB5->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	MsgAlert("Finalizado")

Return()
