#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STENG010        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA ENCERRAR PRE CADASTROS DE PRODUTO SEM INTERACAO              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado 007763																		  |
\====================================================================================*/

User Function STENG010()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	
	ConOut("[STENG010]["+ FWTimeStamp(2) +"] - Iniciando processamento.")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT ZK.R_E_C_N_O_ RECSZK
	_cQuery1 += " FROM "+RetSqlName("SZK")+" ZK
	_cQuery1 += " WHERE ZK.D_E_L_E_T_=' ' AND ZK_STATUS='3' AND ZK_DATAENG<'"+DTOS(Date()-30)+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SZK")

	While (_cAlias1)->(!Eof())

		SZK->(DbGoTo((_cAlias1)->RECSZK))
		If SZK->(!Eof())

			SZK->(RecLock("SZK",.F.))
			SZK->ZK_STATUS := "4"
			SZK->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo
	
	ConOut("[STENG010]["+ FWTimeStamp(2) +"] - Processamento encerrado.")

Return