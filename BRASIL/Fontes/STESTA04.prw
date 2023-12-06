#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STESTA04
@name STESTA04
@type User Function
@desc rotina para endereçamento automática
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STESTA04()

	Local aCabEnd  		:= {}
	Local aItensEnd		:= {}
	Local aParamBox		:= {}
	Local aRet			:= {}
	Private lMsErroAuto := .F.
	Private _cQuery1 		:= ""
	Private _cAlias1 		:= GetNextAlias()
	Private _cQuery2 		:= ""
	Private _cAlias2 		:= GetNextAlias()

	AADD(aParamBox,{1,"Documento" 				,Space(TamSx3("DA_DOC")[1]),"@!","","","",50,.F.})
	AADD(aParamBox,{1,"Série" 					,Space(TamSx3("DA_SERIE")[1]),"@!","","","",50,.F.})
	AADD(aParamBox,{1,"Cliente/Fornecedor" 		,Space(TamSx3("DA_CLIFOR")[1]),"@!","","SA1","",50,.F.})
	AADD(aParamBox,{1,"Loja" 					,Space(TamSx3("DA_LOJA")[1]),"@!","","","",50,.F.})
	AADD(aParamBox,{1,"Endereço"				,Space(TamSx3("DB_LOCALIZ")[1]),"@!","","SBE","",50,.F.})

	If !ParamBox(aParamBox,"Preencha as informações",aRet,{||VLDDADOS()})
		Return
	EndIf

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		aCabEnd 	:= {}
		aItensEnd 	:= {}
		lMsErroAuto := .F.

		_cItem := "0001"

		_cQuery2 := " SELECT DB_ITEM
		_cQuery2 += " FROM "+RetSqlName("SDB")+" DB
		_cQuery2 += " WHERE DB.D_E_L_E_T_=' ' AND DB_FILIAL='"+xFilial("SDB")+"'
		_cQuery2 += " AND DB_PRODUTO='"+(_cAlias1)->DA_PRODUTO+"'
		_cQuery2 += " AND DB_LOCAL='"+(_cAlias1)->DA_LOCAL+"'
		_cQuery2 += " AND DB_DOC='"+(_cAlias1)->DA_DOC+"'
		_cQuery2 += " ORDER BY DB_ITEM DESC

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		If (_cAlias2)->(!Eof())
			_cItem := Soma1((_cAlias2)->DB_ITEM)
		EndIf

		aCabEnd   :=   { {"DA_PRODUTO", (_cAlias1)->DA_PRODUTO    , Nil},;
			{"DA_LOCAL"  , (_cAlias1)->DA_LOCAL , Nil},;
			{"DA_NUMSEQ" , (_cAlias1)->DA_NUMSEQ , Nil},;
			{"DA_DOC"    , (_cAlias1)->DA_DOC    , Nil}}

		aItensEnd := { { {"DB_ITEM"   , _cItem        , Nil},;
			{"DB_PRODUTO", (_cAlias1)->DA_PRODUTO    , Nil},;
			{"DB_LOCAL" , (_cAlias1)->DA_LOCAL , Nil},;
			{"DB_LOCALIZ", MV_PAR05    , Nil},;
			{"DB_QUANT" , (_cAlias1)->DA_SALDO , Nil},;
			{"DB_DATA"   , Date() , Nil},;
			{"DB_DOC"    , (_cAlias1)->DA_DOC    , Nil}}}

		MSExecAuto({|x,y,z,w| Mata265(x,y,z,w)},aCabEnd,aItensEnd,3,.T.)

		If lMsErroAuto
			Mostraerro()
			If MsgYesNo("Deseja finalizar o processamento?")
				Return
			EndIf
		endif

		(_cAlias1)->(DbSkip())
	EndDo

	MsgAlert("Endereçamento finalizado com sucesso, obrigado!")

Return()

/*/{Protheus.doc} VLDDADOS
@name VLDDADOS
@type Static Function
@desc validar dados digitados
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function VLDDADOS()

	Local _lRet := .T.

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SDA")+" DA
	_cQuery1 += " WHERE DA.D_E_L_E_T_=' ' AND DA_FILIAL='"+xFilial("SDA")+"'
	_cQuery1 += " AND DA_DOC='"+MV_PAR01+"' AND DA_SERIE='"+MV_PAR02+"'
	_cQuery1 += " AND DA_CLIFOR='"+MV_PAR03+"' AND DA_LOJA='"+MV_PAR04+"'
	_cQuery1 += " AND DA_SALDO>0

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_lRet := .F.
		MsgAlert("Nenhum registro foi encontrado com esses parâmetros, verifique!")
	Else

		DbSelectArea("SBE")
		SBE->(DbSetOrder(1))
		SBE->(DbGoTop())
		If !SBE->(DbSeek(xFilial("SBE")+(_cAlias1)->DA_LOCAL+MV_PAR05))
			_lRet := .F.
			MsgAlert("Endereço digitado não encontrado, verifique!")
		EndIf

	EndIf

Return(_lRet)
