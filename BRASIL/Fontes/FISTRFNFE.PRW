#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | FISTRFNFE        | Autor | Renato Nogueira            | Data | 30/10/2018|
|=====================================================================================|
|Descrição | Incluir botões na tela da nota fiscal eletrônica                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck.														  |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado                                                                              |
\====================================================================================*/

User Function FISTRFNFE()

	aadd(aRotina,{'Ajustar infos','U_STFAT010',0,10,0,NIL})
	aadd(aRotina,{'Imp. CCE','U_CCEII()' , 0 , 3,0,NIL})//Impressao da carta de correcao eletronica
	aadd(aRotina,{'Realizar entrada Arujá','U_STFAT510',0,10,0,NIL})

Return

/*====================================================================================\
|Programa  | STFAT010        | Autor | Renato Nogueira            | Data | 30/10/2018|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck.														  |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado                                                                              |
\====================================================================================*/

User Function STFAT010()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}

	AADD(_aParamBox,{1,"Espécie" 	,Space(6)	,"@!"				,"","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Volumes" 	,0			,"999999"			,"","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Peso Bruto" ,0			,"@E 999999.9999"	,"","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Peso Liq" 	,0			,"@E 999999.9999"	,"","",".T.",50,.T.})

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())
	If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())
		If SC5->(DbSeek(SD2->(D2_FILIAL+D2_PEDIDO)))

			If SC5->C5_XTRONF=="1"

				If ParamBox(_aParamBox,"Ajustar informações",@_aRet,,,.T.,,500)

					SF2->(RecLock("SF2",.F.))
					SF2->F2_ESPECI1 := MV_PAR01
					SF2->F2_VOLUME1 := MV_PAR02
					SF2->F2_PBRUTO  := MV_PAR03
					SF2->F2_PLIQUI  := MV_PAR04
					SF2->(MsUnLock())

					MsgAlert("Informações ajustadas com sucesso!")

				EndIf

			Else
				MsgAlert("Função habilitada somente para troca de nota, verifique!")
			EndIf

		EndIf

	EndIf

Return
