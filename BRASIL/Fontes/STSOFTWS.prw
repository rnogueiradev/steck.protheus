#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STSOFTWS
@name STSOFTWS
@type User Function
@desc tela para cadastro de softwares
@author Renato Nogueira
@since 12/09/2016
/*/  

User Function STSOFTWS()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("ZZQ")
	ZZQ->(DbSetOrder(1))

	DbSelectArea("ZZR")
	ZZR->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZQ")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro de softwares")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	//oBrowse:AddLegend("PC5_STATUS=='A'"  ,"GREEN"      ,"Ativo")
	//oBrowse:AddLegend("PC5_STATUS=='I'"  ,"BLACK"      ,"Inativo")
	//oBrowse:DisableDetails()
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STSOFTWS" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STSOFTWS" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STSOFTWS"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STSOFTWS"	OPERATION 3  ACCESS 0 //"Incluir"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc monta model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'ZZQ')
	Local oStr2:= FWFormStruct(1,'ZZR')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,{|oModel,nLine|VLDLIN(oModel,nLine)})

	aAdd(_aRel, { 'ZZR_FILIAL', 'ZZQ_FILIAL' } )
	aAdd(_aRel, { 'ZZR_CODIGO', 'ZZQ_CODIGO' } )

	oModel:SetRelation('GRID1', _aRel , ZZR->(IndexKey(1)) )
	oModel:GetModel('GRID1'):SetUniqueLine({"ZZR_MICRO"})

	//oModel:SetPrimaryKey({"PC6_FILIAL","PC6_CODIGO","PC6_ITEM"})
	oModel:SetPrimaryKey({})

	oModel:getModel('GRID1'):SetDescription('Itens')
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc monta view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	//Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZZQ')
	Local oStr2:= FWFormStruct(2, 'ZZR')
	Local oModel     := FWLoadModel("STSOFTWS")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 70)

	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM1','BOXFORM1')

	//Habilitando título
	oView:EnableTitleView('FORM3','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

	// habilita a barra de controle
	oView:EnableControlBar(.T.)

	//verificar se a janela deve ou não ser fechada após a execução do botão OK
	oView:SetCloseOnOk({|| .T.})

	//Campo sequencial
	//oView:AddIncrementField( 'FORM3', 'PC6_ITEM' )


Return oView

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc tudo ok do pedido de venda
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc valida alteração do pv
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc valida troca de linha
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

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv