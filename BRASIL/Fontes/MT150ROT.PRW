#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MT150ROT
@name MT150ROT
@type User Function
@desc adicionar novas rotinas no atualiza cotações
@author Renato Nogueira
@since 17/05/2018
/*/

User Function MT150ROT()

	AAdd( aRotina , { 'Reabrir cotação'			, 'U_STALTSC8', 0, 4 } )
	AAdd( aRotina , { 'Fechar cotações vencidas', 'U_STCOMA30', 0, 1 } )
	AAdd( aRotina , { "Reenviar Cotação"		,"U_STLIMPCOT", 0, 6 } )

Return(aRotina)

/*/{Protheus.doc} STALTSC8
@name STALTSC8
@type User Function
@desc alterar validade da cotação
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STALTSC8()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _cNumSC8		:= ""
	Local _cFilial		:= ""
	Local _cFornece		:= ""
	Local _cLojFor		:= ""
	Local _aAreaSC8 	:= SC8->(GetArea())

	If !Empty(SC8->C8_NUMPED) .And. !(Substr(SC8->C8_NUMPED,1,1)=="X")
		MsgAlert("Atenção, essa cotação não pode ser reaberta pois já tem pedido gerado!")
		Return
	EndIf

	_cFilial := SC8->C8_FILIAL
	_cNumSC8 := SC8->C8_NUM
	_cFornece:= SC8->C8_FORNECE
	_cLojFor := SC8->C8_LOJA

	AADD(_aParamBox,{1,"Dt. Validade",DDataBase,"99/99/9999","","","",50,.F.})

	If ParamBox(_aParamBox,"Alterar validade",@_aRet,{||VLDINFOS()},,.T.,,500)
		If MsgYesNo("Confirma a alteração da data de validade da cotação "+SC8->C8_NUM+" para "+DTOC(MV_PAR01)+"?")

			SC8->(DbSetOrder(1))
			SC8->(DbGoTop())
			SC8->(DbSeek(_cFilial+_cNumSC8))
			While SC8->(!Eof()) .And. SC8->(C8_FILIAL+C8_NUM)==_cFilial+_cNumSC8

				If SC8->(C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA)==_cFilial+_cNumSC8+_cFornece+_cLojFor
					If Empty(SC8->C8_NUMPED) .Or. Substr(SC8->C8_NUMPED,1,1)=="X"
						SC8->(RecLock("SC8",.F.))
						SC8->C8_VALIDA := MV_PAR01
						SC8->C8_NUMPED := ""
						SC8->C8_ITEMPED:= ""
						SC8->(MsUnLock())
					EndIf
				EndIf

				SC8->(DbSkip())
			EndDo

			MsgAlert("Alteração feita com sucesso, obrigado!")
		EndIf
	EndIf

	RestArea(_aAreaSC8)

Return

/*/{Protheus.doc} VLDINFOS
@name VLDINFOS
@type Static Function
@desc validar data digitada
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function VLDINFOS()

	Local _lRet := .T.

	If MV_PAR01<DDataBase
		MsgAlert("Atenção, data digitada menor que a data atual, verifique!")
		_lRet := .F.
	EndIf

Return(_lRet)