#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} STCTB003
@name STCTB003
@type User Function
@desc tela para cadastrar o custo dos beneficiamentos
@author Renato Nogueira
@since 03/04/2018
/*/

User Function STCTB003()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("SZW")
	SZW->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Custos de beneficiamento")
	oBrowse1:SetAlias("SZW")

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

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STCTB003" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STCTB003" 	OPERATION 3  ACCESS 0 //"Inclusao"
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STCTB003" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STCTB003" 	OPERATION 5  ACCESS 0 //"Alterar"

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
	Local oStr1:= FWFormStruct(1,'SZW')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

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
	Local oStr1:= FWFormStruct(2, 'SZW')
	Local oModel     := FWLoadModel("STCTB003")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )

	oView:CreateHorizontalBox( 'BOXFORM1', 100)

	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:EnableTitleView('FORM1','Cabeçalho')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração
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
	Local _cQuery1 		:= ""

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

/*/{Protheus.doc} STCTB013
@name STCTB013
@type User Function
@desc verifica se produto já existe
@author Renato Nogueira
@since 12/09/2016
/*/

User Function STCTB013(_cProd)

Local _lRet := .T.

	If SZW->(DbSeek(xFilial("SZW")+_cProd))
		_lRet := .F.
		MsgAlert("Atenção, produto já cadastrado!")
	EndIf

Return(_lRet)