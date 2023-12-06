#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function STEMVC1()
	
	Local oBrowse
	Private aRotina := MenuDef()
	DbSelectArea("PPJ")
	PPJ->(DbSetOrder(1))
	
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("PPJ")                        // Alias da tabela utilizada
	//oBrowse:SetMenuDef("STTST2")                       // Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("AVALIAÇÃO")      // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:AddLegend("!EMPTY(PPJ_PEDVEN)"  ,"RED"        ,"Gerado")
	oBrowse:AddLegend("EMPTY(PPJ_PEDVEN)"   ,"GREEN"     ,"Não gerado")
	//oBrowse:DisableDetails()
	oBrowse:Activate()
	
Return

Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STEMVC1" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STEMVC1" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STEMVC1" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STEMVC1" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STEMVC1" OPERATION 8 ACCESS 0 //"Imprimir"
	
Return aRotina


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author renato.oliveira

@since 28/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	
	
	Local oStr1:= FWFormStruct(1,'PPJ')
	
	Local oStr2:= FWFormStruct(1,'PPL')
	oModel := MPFormModel():New("STEMVC1")
	oModel:SetDescription('Main')
	oModel:addFields('FIELD1',,oStr1)
	oModel:addGrid('GRID1','FIELD1',oStr2)
	
	
	
	oModel:SetRelation('GRID1', { { 'PPL_FILIAL', 'PPJ_FILIAL' }, { 'PPL_NUM', 'PPJ_NUM' } }, PPL->(IndexKey(1)) )
	
	
	
	
	
	
	
	
	
	oModel:SetPrimaryKey({ 'PPJ_FILIAL', 'PPJ_NUM' })
	oModel:getModel('GRID1'):SetDescription('itens')
	oModel:getModel('FIELD1'):SetDescription('cabeçalho')
	
	
	
	
	
	
	
	
Return oModel


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author renato.oliveira

@since 28/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	Local oStr1:= FWFormStruct(2, 'PPJ')
	
	Local oStr2:= FWFormStruct(2, 'PPL')
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')
	oView:CreateHorizontalBox( 'BOXFORM1', 50)
	oView:CreateHorizontalBox( 'BOXFORM3', 50)
	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM1','BOXFORM1')
	
Return oView
