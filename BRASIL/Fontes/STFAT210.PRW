#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT210        | Autor | RENATO.OLIVEIRA           | Data | 13/09/2019  |
|=====================================================================================|
|Descrição | Gerar etiqueta TNT para processo de troca de NF                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT210()

	Local aParambox		:= {}
	Local aRet			:= {}
	Local _cQuery1 		:= ""
	Local _cAlias1		:= GetNextAlias()
	Local _cQuery2 		:= ""
	Local _cAlias2		:= GetNextAlias()
	Local _cQuery3 		:= ""
	Local _cAlias3		:= GetNextAlias()
	Local _cQuery4 		:= ""
	Local _cAlias4		:= GetNextAlias()
	Local cOrdSep		:= ""
	Local _cPedEnt		:= ""
	Local _cCliOri		:= ""
	Local _cLojOri		:= ""
	Local _cCliEnt		:= ""
	Local _cLojEnt		:= ""
	Local aPgs			:= {}
	Local aAux			:= {}
	Local nLimite 		:= 17  // quantide de produto que cabem na etiqueta
	Local nC			:= 0
	Local nX			:= 0

	aAdd(aParamBox,{1,"NF original"		,Space(9)		,"@!","","SF2"	,"" ,0,.T.})
	aAdd(aParamBox,{1,"NF entrega"		,Space(9)		,"@!","","SF2"	,"" ,0,.T.})
	aAdd(aParamBox,{1,"Impressora"		,Space(6)		,"@!","ExistCpo('CB5')","CB5"	,"" ,0,.T.})

	If !ParamBox(aParamBox,"Gerar etiquetas TNT",@aRet,,,,,,,,.f.)
		Return
	EndIf

	If !CB5SETIMP(MV_PAR03,IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return()
	EndIf

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())

	If !SF2->(DbSeek(xFilial("SF2")+MV_PAR01+"001"))
		MsgAlert("NF de origem não encontrada, verifique!")
		Return
	EndIf

	_cEspecie := SF2->F2_ESPECI1
	_nVolume  := SF2->F2_VOLUME1
	_nPLiq	  := SF2->F2_PLIQUI
	_nPBru	  := SF2->F2_PBRUTO

	If !SF2->(DbSeek(xFilial("SF2")+MV_PAR02+"001"))
		MsgAlert("NF de entrega não encontrada, verifique!")
		Return
	EndIf

	If MV_PAR02<MV_PAR01
		MsgAlert("Atenção, número da NF de entrega é menor que da NF original, verifique!")
		Return()
	EndIf

	SF2->(RecLock("SF2",.F.))
	SF2->F2_ESPECI1 := _cEspecie
	SF2->F2_VOLUME1 := _nVolume
	SF2->F2_PLIQUI	:= _nPLiq
	SF2->F2_PBRUTO  := _nPBru
	SF2->F2_XTRIAN	:= "S"
	SF2->(MsUnLock())

	If !SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		MsgAlert("NF de entrega não encontrada, verifique!")
		Return
	EndIf

	If !(SF2->F2_TRANSP=="000163")
		MsgAlert("Rotina somente para transportadora TNT, verifique!")
		Return
	EndIf

	_cQuery3 := " SELECT *
	_cQuery3 += " FROM "+RetSqlName("CB7")+" CB7
	_cQuery3 += " WHERE CB7.D_E_L_E_T_=' ' AND CB7_FILIAL='"+SF2->F2_FILIAL+"' AND CB7_NOTA='"+SF2->F2_DOC+"'
	_cQuery3 += " AND CB7_SERIE='"+SF2->F2_SERIE+"'

	If !Empty(Select(_cAlias3))
		DbSelectArea(_cAlias3)
		(_cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

	dbSelectArea(_cAlias3)

	(_cAlias3)->(dbGoTop())

	_cPedEnt := SD2->D2_PEDIDO
	_cCliEnt := SF2->F2_CLIENTE
	_cLojEnt := SF2->F2_LOJA

	If !SF2->(DbSeek(xFilial("SF2")+MV_PAR01+"001"))
		MsgAlert("NF de origem não encontrada, verifique!")
		Return
	EndIf

	_cCliOri := SF2->F2_CLIENTE
	_cLojOri := SF2->F2_LOJA

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("CB7")+" CB7
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB8")+" CB8
	_cQuery1 += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP
	_cQuery1 += " WHERE CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' '
	_cQuery1 += " AND CB7_FILIAL='"+SF2->F2_FILIAL+"' AND CB7_NOTA='"+SF2->F2_DOC+"' AND CB7_SERIE='"+SF2->F2_SERIE+"'
	_cQuery1 += " AND CB7_CLIENT='"+SF2->F2_CLIENTE+"' AND CB7_LOJA='"+SF2->F2_LOJA+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		MsgAlert("OS não encontrada para nota de origem, verifique!")
		Return
	EndIf

	If (_cAlias3)->(Eof()) //Caso não tenha OS gerada para nota triangular

		cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )
		CB7->(ConfirmSX8())

		CB7->(DbSetOrder(1))
		If !CB7->(DbSeek(xFilial("CB7")+cOrdSep))

			CB7->(RecLock( "CB7",.T.))
			CB7->CB7_FILIAL := (_cAlias1)->CB7_FILIAL
			CB7->CB7_ORDSEP := cOrdSep
			CB7->CB7_XAUTSE := (_cAlias1)->CB7_XAUTSE
			CB7->CB7_PEDIDO := _cPedEnt
			CB7->CB7_CLIENT := _cCliEnt
			CB7->CB7_LOJA   := _cLojEnt
			CB7->CB7_COND   := (_cAlias1)->CB7_COND
			CB7->CB7_LOJENT := _cLojEnt
			CB7->CB7_TRANSP := (_cAlias1)->CB7_TRANSP
			CB7->CB7_ORIGEM := (_cAlias1)->CB7_ORIGEM
			CB7->CB7_TIPEXP := (_cAlias1)->CB7_TIPEXP
			CB7->CB7_XPRIAN := (_cAlias1)->CB7_XPRIAN
			CB7->CB7_LOCAL  := (_cAlias1)->CB7_LOCAL
			CB7->CB7_DTEMIS := Date()
			CB7->CB7_HREMIS := Time()
			CB7->CB7_STATUS := (_cAlias1)->CB7_STATUS
			CB7->CB7_CODOPE := ""
			CB7->CB7_PRIORI := (_cAlias1)->CB7_PRIORI
			CB7->CB7_XSEP	:= (_cAlias1)->CB7_XSEP
			CB7->CB7_NOTA	:= MV_PAR02
			CB7->CB7_SERIE 	:= "001"
			CB7->(MsUnlock())

			//Vincular SC9
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			SC9->(DbGoTop())
			SC9->(DbSeek((_cAlias1)->CB7_FILIAL+_cPedEnt))
			While SC9->(!Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO)==(_cAlias1)->CB7_FILIAL+_cPedEnt

				SC9->(RecLock("SC9",.F.))
				SC9->C9_ORDSEP := cOrdSep
				SC9->(MsUnLock())

				SC9->(DbSkip())
			EndDo			

		EndIf

		//Criar CB8
		While (_cAlias1)->(!Eof())

			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := (_cAlias1)->CB8_FILIAL
			CB8->CB8_ORDSEP := cOrdSep
			CB8->CB8_PROD   := (_cAlias1)->CB8_PROD
			CB8->CB8_LOCAL  := (_cAlias1)->CB8_LOCAL
			CB8->CB8_ITEM   := (_cAlias1)->CB8_ITEM
			CB8->CB8_PEDIDO := _cPedEnt
			CB8->CB8_SEQUEN := (_cAlias1)->CB8_SEQUEN
			CB8->CB8_QTDORI := (_cAlias1)->CB8_QTDORI
			CB8->CB8_SALDOS := (_cAlias1)->CB8_SALDOS
			CB8->CB8_SALDOE := (_cAlias1)->CB8_SALDOE
			CB8->CB8_LCALIZ := (_cAlias1)->CB8_LCALIZ
			CB8->CB8_NUMSER := (_cAlias1)->CB8_NUMSER
			CB8->CB8_LOTECT := (_cAlias1)->CB8_LOTECT
			CB8->CB8_NUMLOT := (_cAlias1)->CB8_NUMLOT
			CB8->CB8_CFLOTE := (_cAlias1)->CB8_CFLOTE
			CB8->(MsUnLock())

			(_cAlias1)->(Dbskip())
		EndDo 

		(_cAlias1)->(dbGoTop())

		//Criar CB6
		_cQuery2 := " SELECT *
		_cQuery2 += " FROM "+RetSqlName("CB7")+" CB7
		_cQuery2 += " LEFT JOIN "+RetSqlName("CB6")+" CB6
		_cQuery2 += " ON CB7_FILIAL=CB6_FILIAL AND CB7_ORDSEP=CB6_XORDSE
		_cQuery2 += " WHERE CB7.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' '
		_cQuery2 += " AND CB7_FILIAL='"+(_cAlias1)->CB7_FILIAL+"' AND CB7_ORDSEP='"+(_cAlias1)->CB7_ORDSEP+"'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)

		(_cAlias2)->(dbGoTop())	

		While (_cAlias2)->(!Eof())

			CB6->(RecLock("CB6",.T.))
			CB6->CB6_FILIAL := (_cAlias2)->CB6_FILIAL
			CB6->CB6_VOLUME := cOrdSep+SubStr((_cAlias2)->CB6_VOLUME,7,4)
			CB6->CB6_PEDIDO := _cPedEnt
			CB6->CB6_TIPVOL	:= (_cAlias2)->CB6_TIPVOL
			CB6->CB6_STATUS := (_cAlias2)->CB6_STATUS
			CB6->CB6_CODEB1 := (_cAlias2)->CB6_CODEB1
			CB6->CB6_CODEB2 := (_cAlias2)->CB6_CODEB2
			CB6->CB6_XORDSE	:= cOrdSep
			CB6->CB6_XPESO  := (_cAlias2)->CB6_XPESO
			CB6->CB6_XDTINI := Date()
			CB6->CB6_XHINI  := Time()
			CB6->CB6_XDTFIN := Date()
			CB6->CB6_XHFIN  := Time()
			CB6->(MsUnLock())

			(_cAlias2)->(DbSkip())
		EndDo

		//Criar CB9
		_cQuery4 := " SELECT *
		_cQuery4 += " FROM "+RetSqlName("CB7")+" CB7
		_cQuery4 += " LEFT JOIN "+RetSqlName("CB9")+" CB9
		_cQuery4 += " ON CB7_FILIAL=CB9_FILIAL AND CB7_ORDSEP=CB9_ORDSEP
		_cQuery4 += " WHERE CB7.D_E_L_E_T_=' ' AND CB9.D_E_L_E_T_=' '
		_cQuery4 += " AND CB7_FILIAL='"+(_cAlias1)->CB7_FILIAL+"' AND CB7_ORDSEP='"+(_cAlias1)->CB7_ORDSEP+"'

		If !Empty(Select(_cAlias4))
			DbSelectArea(_cAlias4)
			(_cAlias4)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)

		dbSelectArea(_cAlias4)

		(_cAlias4)->(dbGoTop())	

		While (_cAlias4)->(!Eof())

			CB9->(RecLock("CB9",.T.))
			CB9->CB9_FILIAL := (_cAlias4)->CB9_FILIAL
			CB9->CB9_ORDSEP := cOrdSep
			CB9->CB9_PROD	:= (_cAlias4)->CB9_PROD
			CB9->CB9_VOLUME := cOrdSep+SubStr((_cAlias4)->CB9_VOLUME,7,4)
			CB9->CB9_SEQUEN := (_cAlias4)->CB9_SEQUEN
			CB9->CB9_QTESEP	:= (_cAlias4)->CB9_QTESEP
			CB9->CB9_ITESEP	:= (_cAlias4)->CB9_ITESEP
			CB9->CB9_CODEMB	:= (_cAlias4)->CB9_CODEMB
			CB9->CB9_CODSEP	:= (_cAlias4)->CB9_CODSEP
			CB9->CB9_STATUS	:= (_cAlias4)->CB9_STATUS
			CB9->CB9_QTEEMB	:= (_cAlias4)->CB9_QTEEMB
			CB9->CB9_LOTECT	:= (_cAlias4)->CB9_LOTECT
			CB9->CB9_LOCAL	:= (_cAlias4)->CB9_LOCAL
			CB9->CB9_LCALIZ	:= (_cAlias4)->CB9_LCALIZ
			CB9->CB9_PEDIDO	:= _cPedEnt
			CB9->(MsUnLock())

			(_cAlias4)->(DbSkip())
		EndDo

	Else

		cOrdSep := (_cAlias3)->CB7_ORDSEP

	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If !SC5->(DbSeek(xFilial("SC5")+_cPedEnt))
		MsgAlert("Pedido de entrega não encontrado, verifique")
		Return
	EndIf

	DbSelectArea("CB9")
	CB9->(DbSetOrder(4))

	DbSelectArea("CB6")
	CB6->(DbSetOrder(5))
	CB6->(DbSeek(xFilial("CB6")+cOrdSep))
	While CB6->(!Eof()) .And. xFilial("CB6")+cOrdSep==CB6->(CB6_FILIAL+CB6_XORDSE)

		aAux := {}
		aPgs := {}
		nc   := 0

		cVolume := CB6->CB6_VOLUME

		If Empty(CB6->CB6_XPESO)
			MsgAlert("Volume em aberto, não poderá ser impresso!!!","Atenção")
			Return
		EndIf
		
		CB9->(DbSetOrder(4))
		If CB9->(DbSeek(xFilial("CB9")+cVolume))
			While CB9->(CB9_FILIAL+CB9_VOLUME)==xFilial("CB9")+cVolume
				aadd(aAux,{CB9->CB9_PROD,Transform(CB9->CB9_QTEEMB,"999999") })
				nc++
				If nC > nLimite
					aadd(aPgs,aClone(aAux))
					aAux:={}
					nC:=0
				EndIf
				CB9->(DbSkip())
			End	
		EndIf	
		
		If ! Empty(aAux)
			aadd(aPgs,aClone(aAux))
		EndIf

		If Empty(aPgs)
			MsgAlert("Volume vazio!!!","Atenção")
			Return
		EndIf

		For nX:= 1 to len(aPgs)

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+(_cAlias3)->(CB7_CLIENT+CB7_LOJA)))

			SA4->(DbSetOrder(1))
			SA4->(DbSeek(xFilial("SA4")+(_cAlias3)->CB7_TRANSP))

			U_STIMGVOL(cVolume,aPgs[nX],CB5->CB5_CODIGO,CB5->CB5_CODIGO)

		Next

		CB6->(DbSkip())
	EndDo

Return()
