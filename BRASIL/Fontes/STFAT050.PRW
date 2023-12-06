#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT050        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Tela para manutenção das campanhas internas de vendas                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT050()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	DbSelectArea("Z22")
	Z22->(DbSetOrder(1))

	DbSelectArea("Z30")
	Z30->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Controle campanhas internas")
	oBrowse1:SetAlias("Z22")

	oBrowse1:AddLegend("!Empty(Z22->Z22_GRUPO)"	,"GREEN"	,"Ativa")

	oBrowse1:SetUseCursor(.F.)

	oBrowse1:Activate()

Return()

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT050" 	OPERATION 2  ACCESS 0
	If __cUserId $ GetMv("STFAT0501",,"")
		ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STFAT050" 	OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STFAT050" 	OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STFAT050" 	OPERATION 5  ACCESS 0
		ADD OPTION aRotina TITLE "Copiar"    				ACTION "U_STFAT051" 	OPERATION 2  ACCESS 0
	EndIf
	ADD OPTION aRotina TITLE "Relatório"   				ACTION "U_RSTFATC8" 		OPERATION 10 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z22')
	Local oStr2:= FWFormStruct(1,'Z30')
	Local oStr3:= FWFormStruct(1,'Z40')
	Local _aRel	:= {}
	Local _aRel1	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)
	oModel:addGrid('GRID2','FIELD1',oStr3,,)

	aAdd(_aRel, { 'Z30_FILIAL'	, 'Z22_FILIAL' } )
	aAdd(_aRel, { 'Z30_CODIGO'	, 'Z22_CODIGO' } )

	oModel:SetRelation('GRID1', _aRel , Z30->(IndexKey(1)) )

	aAdd(_aRel1, { 'Z40_FILIAL'	, 'Z22_FILIAL' } )
	aAdd(_aRel1, { 'Z40_CODIGO'	, 'Z22_CODIGO' } )

	oModel:SetRelation('GRID2', _aRel1 , Z40->(IndexKey(1)) )

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')
	oModel:getModel('GRID1'):SetDescription('Itens')
	oModel:getModel('GRID2'):SetDescription('Grupo')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'Z22')
	Local oStr2:= FWFormStruct(2, 'Z30')
	Local oStr3:= FWFormStruct(2, 'Z40')
	Local oModel     := FWLoadModel("STFAT050")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')
	oView:AddGrid('FORM4' , oStr3,'GRID2')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 40)
	oView:CreateHorizontalBox( 'BOXFORM4', 30)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM4','BOXFORM4')

	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableTitleView('FORM3','Itens')
	oView:EnableTitleView('FORM4','Grupos')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp         := oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT051
@name STFAT051
@type User Function
@desc copiar campanha
@author Renato Nogueira
@since 12/09/2016
/*/

User Function STFAT051()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	Local _cCodBas := Z22->Z22_CODIGO

	If !MsgYesNo("Confirma cópia da campanha: "+Z22->Z22_CODIGO+"?")
		Return
	EndIf

	DbSelectArea("Z30")
	DbSelectArea("Z40")

	Begin Transaction

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("Z22")+" Z22
		_cQuery1 += " LEFT JOIN "+RetSqlName("Z30")+" Z30
		_cQuery1 += " ON Z22_FILIAL=Z30_FILIAL AND Z22_CODIGO=Z30_CODIGO
		_cQuery1 += " WHERE Z22.D_E_L_E_T_=' ' AND Z30.D_E_L_E_T_=' ' 
		_cQuery1 += " AND Z22_CODIGO='"+_cCodBas+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())

			_cCodigo := GetSx8Num("Z22","Z22_CODIGO")
			Z22->(ConfirmSX8())

			Z22->(RecLock("Z22",.T.))
			Z22->Z22_FILIAL := xFilial("Z22")
			Z22->Z22_CODIGO := _cCodigo
			Z22->Z22_GRUPO  := (_cAlias1)->Z22_GRUPO
			Z22->Z22_ANO	:= (_cAlias1)->Z22_ANO
			Z22->Z22_MESINI := (_cAlias1)->Z22_MESINI
			Z22->Z22_MESFIM := (_cAlias1)->Z22_MESFIM
			Z22->Z22_OBS	:= (_cAlias1)->Z22_OBS
			Z22->Z22_TIPO   := (_cAlias1)->Z22_TIPO
			Z22->Z22_STATUS := (_cAlias1)->Z22_STATUS
			Z22->(MsUnLock())

		EndIf

		While (_cAlias1)->(!Eof())

			Z30->(RecLock("Z30",.T.))
			Z30->Z30_FILIAL := xFilial("Z30")
			Z30->Z30_CODIGO := _cCodigo
			Z30->Z30_VEND   := (_cAlias1)->Z30_VEND
			Z30->Z30_NOME	:= (_cAlias1)->Z30_NOME
			Z30->Z30_OBJETI	:= (_cAlias1)->Z30_OBJETI
			Z30->(MsUnLock())

			(_cAlias1)->(DbSkip())
		EndDo

		_cQuery2 := " SELECT *
		_cQuery2 += " FROM "+RetSqlName("Z22")+" Z22
		_cQuery2 += " LEFT JOIN "+RetSqlName("Z40")+" Z40
		_cQuery2 += " ON Z22_FILIAL=Z40_FILIAL AND Z22_CODIGO=Z40_CODIGO
		_cQuery2 += " WHERE Z22.D_E_L_E_T_=' ' AND Z40.D_E_L_E_T_=' ' 
		_cQuery2 += " AND Z22_CODIGO='"+_cCodBas+"'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)

		(_cAlias2)->(dbGoTop())

		While (_cAlias2)->(!Eof())

			Z40->(RecLock("Z40",.T.))
			Z40->Z40_FILIAL := xFilial("Z40")
			Z40->Z40_CODIGO := _cCodigo
			Z40->Z40_GRUPO	:= (_cAlias2)->Z40_GRUPO
			Z40->Z40_DESCG	:= (_cAlias2)->Z40_DESCG
			Z40->(MsUnLock())

			(_cAlias2)->(DbSkip())
		EndDo

	End Transaction
	
	MsgAlert("Cópia finalizada com sucesso para o código: "+_cCodigo)

Return()