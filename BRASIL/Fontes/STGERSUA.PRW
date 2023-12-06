#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)

/*====================================================================================\
|Programa  | STGERSUA        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | GERAR ORÇAMENTOS VINDOS DO PORTAL DO CLIENTE                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STGERSUA()

	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _cEmp    	:= "01"
	Local _cFil    	:= "02"
	Local aCabec    := {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Private lMsErroAuto := .F.

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")
	
	__cUserId := "000000"
	
	_cAlias1  := GetNextAlias()

	If !LockByName("STGERSUA",.F.,.F.,.T.)
		ConOut("[STGERSUA]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut("[STGERSUA]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cQuery1  := " SELECT * "
	_cQuery1  += " FROM " +RetSqlName("SZT")+ " SZT "
	_cQuery1  += " WHERE SZT.D_E_L_E_T_=' ' AND ZT_STATUS='0'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SZT")
	DbSelectArea("SZU")
	SZU->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		lMsErroAuto := .F.
		aCabec := {}
		aItens := {}
		aLinha := {}

		SZT->(DbGoTop())
		SZT->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		If SZT->(!Eof())
		
			DbSelectArea("AC8")
			AC8->(DbSetOrder(2))
			AC8->(DbGoTop())
			AC8->(DbSeek(xFilial("AC8")+"SA1"+xFilial("AC8")+SZT->(ZT_CLIENTE+ZT_LOJA)))

			AADD(aCabec,{"UA_CLIENTE"   ,SZT->ZT_CLIENTE           ,Nil})
			AADD(aCabec,{"UA_LOJA"   ,SZT->ZT_LOJA           ,Nil})
			AADD(aCabec,{"UA_CODCONT"   ,AC8->AC8_CODCON           ,Nil})
			AADD(aCabec,{"UA_TRANSP"   ,SZT->ZT_TRANSP           ,Nil})
			AADD(aCabec,{"UA_TPFRETE"   ,SZT->ZT_TPFRETE           ,Nil})
			AADD(aCabec,{"UA_CONDPG"   ,SZT->ZT_COND           ,Nil})
			AADD(aCabec,{"UA_XCONDPG"   ,SZT->ZT_COND           ,Nil})
			AADD(aCabec,{"UA_XTIPOPV"   ,SZT->ZT_TPENT           ,Nil})
			AADD(aCabec,{"UA_XTIPFAT"   ,SZT->ZT_TPFAT           ,Nil})
			AADD(aCabec,{"UA_OPER"   ,SZT->ZT_OPER           ,Nil})
			AADD(aCabec,{"UA_ZOBS"   ,SZT->ZT_OBS           ,Nil})
			
			SZU->(DbGoTop())
			SZU->(DbSeek(SZT->(ZT_FILIAL+ZT_NUM)))
			While SZU->(!Eof()) .And. SZU->(ZU_FILIAL+ZU_NUM)==SZT->(ZT_FILIAL+ZT_NUM)

				aLinha := {}

				aadd(aLinha,{"UB_ITEM"  	,SZU->ZU_ITEM  ,Nil})
				aadd(aLinha,{"UB_PRODUTO"  	,SZU->ZU_PROD  ,Nil})
				aadd(aLinha,{"UB_QUANT"  	,SZU->ZU_QUANT  ,Nil})
				//aadd(aLinha,{"UB_VRUNIT"  	,SZU->ZU_PRECO  ,Nil})
				aadd(aLinha,{"UB_NUMPCOM"  	,SZU->ZU_OC  ,Nil})
				aadd(aLinha,{"UB_ITEMPC"  	,SZU->ZU_ITEMOC  ,Nil})
				aadd(aItens,aLinha)

				SZU->(DbSkip())
			EndDo

			cRotina := "2"

			TMKA271(aCabec,aItens,3,cRotina)

			If !lMsErroAuto
				ConOut("Atendimento incluído com sucesso! ")

				SZT->(RecLock("SZT",.F.))
				SZT->ZT_STATUS := "1"
				//SZT->ZT_ORC	   := ""
				SZT->(MsUnLock())

			Else
				ConOut("Erro na inclusão!")
				Mostraerro()
				DisarmTransaction()
			Endif

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STGERSUA",.F.,.F.,.T.)

	ConOut("[STGERSUA]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

