#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)

/*====================================================================================\
|Programa  | STGERPED        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | GERAR PEDIDOS VINDOS DO PORTAL DO CLIENTE                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STGERPED()

	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _cEmp    	:= "01"
	Local _cFil    	:= "02"
	Local aCabec    := {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Private lMsErroAuto := .F.
	Private cZConsumo		:= ""

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	__cUserId := "000000"

	_cAlias1  := GetNextAlias()

	If !LockByName("STGERPED",.F.,.F.,.T.)
		ConOut("[STGERPED]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut("[STGERPED]["+ FWTimeStamp(2) +"] Inicio do processamento.")

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
		cZConsumo := ""

		SZT->(DbGoTop())
		SZT->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		If SZT->(!Eof())

			SA1->(DbSeek(xFilial("SA1")+SZT->(ZT_CLIENTE_ZT_LOJA)))

			If (SA1->A1_TIPO $ 'R' .And. SA1->A1_CONTRIB = '1'  .And. (alltrim(SA1->A1_GRPVEN) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(SA1->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(SA1->A1_INSCR))))
				cZConsumo := "1"
			EndIf

			AADD(aCabec,{"C5_TIPO"   	,"N"           			,Nil})
			AADD(aCabec,{"C5_CLIENTE"   ,SA1->A1_COD	        ,Nil})
			AADD(aCabec,{"C5_LOJACLI"   ,SA1->A1_LOJA           ,Nil})
			aAdd(aCabec,{"C5_CLIENT"	,SA1->A1_COD			,Nil}) // Codigo do Cliente para entrega
			aAdd(aCabec,{"C5_LOJAENT"	,SA1->A1_LOJA			,Nil}) // Loja para entrega
			aAdd(aCabec,{"C5_TIPOCLI"	,SA1->A1_TIPO			,Nil}) // Tipo do Cliente
			AADD(aCabec,{"C5_ZCONDPG"   ,SZT->ZT_COND           ,Nil})
			AADD(aCabec,{"C5_TPFRETE"   ,SZT->ZT_TPFRETE        ,Nil})
			AADD(aCabec,{"C5_TRANSP"    ,SZT->ZT_TRANSP         ,Nil})
			AADD(aCabec,{"C5_XTIPO"	    ,SZT->ZT_TPENT          ,Nil})
			AADD(aCabec,{"C5_XTIPF"	    ,SZT->ZT_TPFAT          ,Nil})
			AADD(aCabec,{"C5_ZOBS"  	,SZT->ZT_OBS            ,Nil})
			aAdd(aCabec,{"C5_ZCONSUM"	,cZConsumo				,Nil}) // Consumo
			aAdd(aCabec,{"C5_XNUMWEB"	,SZT->ZT_NUM			,Nil}) // Consumo

			SZU->(DbGoTop())
			SZU->(DbSeek(SZT->(ZT_FILIAL+ZT_NUM)))
			While SZU->(!Eof()) .And. SZU->(ZU_FILIAL+ZU_NUM)==SZT->(ZT_FILIAL+ZT_NUM)

				SB1->(DbSeek(xFilial("SB1")+SZU->ZU_PROD))

				cTesPad := U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,SZT->ZT_COND,'TES',.T.)

				Aadd(aItens ,{{"C6_ITEM"		,SZU->ZU_ITEM																			,Nil},; // Numero do Item no Pedido
				{"C6_PRODUTO"	,AllTrim(SZU->ZU_PROD)																			,Nil},; // Codigo do Produto
				{"C6_UM"   		,SB1->B1_UM		  																				,Nil},; // Unidade de Medida Primar.
				{"C6_QTDVEN"	,SZU->ZU_QUANT																				,Nil},; // Quantidade Vendida
				{"C6_PRCVEN"	,SZU->ZU_PRECO																					,Nil},; // Preco Venda
				{"C6_PRUNIT"	,SZU->ZU_PRECO																					,Nil},; // Preco Unitario
				{"C6_VALOR"		,round(SZU->ZU_PRECO*SZU->ZU_QUANT,2)															,Nil},; // Valor Total do Item
				{"C6_LOCAL"		,SB1->B1_LOCPAD																					,Nil},; // Almoxarifado
				{"C6_CLI"		,SA1->A1_COD																					,Nil},; // Cliente
				{"C6_OPER"		,"01"																						,Nil},; // OPERAÇÃO
				{"C6_TES"		,cTesPad																					,Nil},; // Tipo de Entrada/Saida do Item
				{"C6_ITEMPC"	,SZU->ZU_ITEMOC	,Nil},; // Item do pedido de compra
				{"C6_NUMPCOM"	,AllTrim(SZU->ZU_OC)																	,Nil}})

				SZU->(DbSkip())
			EndDo

			MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,3)

			If !lMsErroAuto

				ConOut("Pedido incluído com sucesso! ")

				SZT->(RecLock("SZT",.F.))
				SZT->ZT_STATUS := "1"
				SZT->ZT_NUMSC5 := SC5->C5_NUM
				SZT->(MsUnLock())

			Else
				ConOut("Erro na inclusão!")
				Mostraerro()
				DisarmTransaction()
			Endif

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STGERPED",.F.,.F.,.T.)

	ConOut("[STGERPED]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

