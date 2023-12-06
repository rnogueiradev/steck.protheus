#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT410        | Autor | RENATO.OLIVEIRA           | Data | 31/10/2019  |
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

User Function STFAT410()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STFAT410",.F.,.F.,.T.)
		ConOut("[STFAT410]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT410]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cAlias1 := GetNextAlias()

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	_cQuery1 := " SELECT C5_FILIAL, C5_NUM, C5.R_E_C_N_O_ RECSC5, COUNT(D2_PEDIDO) FAT
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
	_cQuery1 += " ON D2_FILIAL=C5_FILIAL AND D2_PEDIDO=C5_NUM AND D2.D_E_L_E_T_=' '
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_ZFATBLQ='1'
	_cQuery1 += " GROUP BY C5_FILIAL, C5_NUM, C5.R_E_C_N_O_
	_cQuery1 += " HAVING COUNT(D2_PEDIDO)=0
	_cQuery1 += " ORDER BY C5_FILIAL, C5_NUM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
	
		If SC5->(!Eof())
	
			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZFATBLQ := "2"
			SC5->(MsUnLock())
	
		EndIf
	
		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STFAT410",.F.,.F.,.T.)
	
	ConOut("[STFAT410]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment
	
Return()