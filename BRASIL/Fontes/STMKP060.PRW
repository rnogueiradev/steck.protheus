#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STMKP060        | Autor | RENATO.OLIVEIRA           | Data | 31/03/2020  |
|=====================================================================================|
|Descrição | Rotina criada para gerenciar os cancelamentos                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMKP060()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	DbSelectArea("Z69")
	Z69->(DbSetOrder(1))

	DbSelectArea("Z70")
	Z70->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Gestão de cancelamentos dos marketplaces")
	oBrowse1:SetAlias("Z69")

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
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STMKP060" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 					ACTION "VIEWDEF.STMKP060" 	OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" 					ACTION "VIEWDEF.STMKP060" 	OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 					ACTION "VIEWDEF.STMKP060" 	OPERATION 5  ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'Z69')
	Local oStr2:= FWFormStruct(1,'Z70')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)

	aAdd(_aRel, { 'Z70_FILIAL'	, 'Z69_FILIAL' } )
	aAdd(_aRel, { 'Z70_PROT'	, 'Z69_PROT' } )

	oModel:SetRelation('GRID1', _aRel , Z70->(IndexKey(1)) )
	oModel:GetModel('GRID1'):SetUniqueLine({"Z70_ITEM"})

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')
	oModel:getModel('GRID1'):SetDescription('Itens')

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
	Local oStr1:= FWFormStruct(2, 'Z69')
	Local oStr2:= FWFormStruct(2, 'Z70')
	Local oModel     := FWLoadModel("STMKP060")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 70)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM3','BOXFORM3')

	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

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