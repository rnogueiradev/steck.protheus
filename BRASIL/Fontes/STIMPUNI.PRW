#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STIMPUNI  ºAutor  ³Renato Nogueira     º Data ³  13/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relátorio de impressão de unicon 							    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STIMPUNI()

	Local 	_aRet 		:= {}
	Local 	_aParamBox 	:= {}
	Local 	_cQuery		:= ""
	Local 	_cAlias		:= "QRYTEMP"
	Local 	_cItens		:= ""
	Private _lPreco		:= .T.

	AADD(_aParamBox,{1,"Unicon",Space(6),"","","","",0,.F.})

	If ParamBox(_aParamBox,"Relatório de Unicon",@_aRet,,,.T.,,500)

		DbSelectArea("PP7")
		PP7->(DbSetOrder(1))
		PP7->(DbGoTop())

		If PP7->(DbSeek(xFilial("PP7")+_aRet[1]))

			If Empty(Alltrim(PP7->PP7_TRAVA))
				MsgInfo("Orçamento aguardando Valores!!!!!")
				Return()
			EndIf

			_cQuery :=	" SELECT PP8_ITEM ITEM "
			_cQuery += " FROM "+RetSqlName("PP8")+" P8 "
			_cQuery += " WHERE P8.D_E_L_E_T_=' ' AND PP8_FILIAL='"+PP7->PP7_FILIAL+"' AND PP8_CODIGO='"+PP7->PP7_CODIGO+"' "

			If !Empty(Select(_cAlias))
				DbSelectArea(_cAlias)
				(_cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

			dbSelectArea(_cAlias)
			(_cAlias)->(dbGoTop())

			While (_cAlias)->(!Eof())

				_cItens	+= "/"+AllTrim((_cAlias)->ITEM)

				(_cAlias)->(DbSkip())

			EndDo

			u_ORCUNICON(_cItens,_lPreco)

		EndIf

	EndIf

Return()