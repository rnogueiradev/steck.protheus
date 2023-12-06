#include "totvs.ch"
#include "FwMvcDef.ch"
#include "tbiConn.ch"
#include "TopConn.ch"

User Function BeLayout()

Private oBrowse := FwMBrowse():New()
oBrowse:SetAlias("Z9B")
oBrowse:SetDescription("Cadastro de Layout de Integração 4MDG")
oBrowse:Activate()

Return

Static Function MenuDef()

Local aMenu := {}

ADD OPTION aMenu TITLE 'Pesquisar' 	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BeLayout'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir' 	ACTION 'VIEWDEF.BeLayout'	OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar' 	ACTION 'VIEWDEF.BeLayout'	OPERATION 4 ACCESS 0
ADD OPTION aMenu TITLE 'Excluir' 	ACTION 'VIEWDEF.BeLayout'	OPERATION 5 ACCESS 0

Return( aMenu )

Static Function ModelDef()

Local oStruZ9B := FwFormStruct(1,"Z9B")
Local oStruZ9C := FwFormStruct(1,"Z9C")
Local oModel

oModel	:= MpFormModel():New("PEBeLayout",/*Pre-Validacao*/,/*Pós-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields("ID_ENCH_COLAB",/*cOwner*/,oStruZ9B,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)

oModel:AddGrid( 'ID_ENCH_CARTA', 'ID_ENCH_COLAB', oStruZ9C )

oModel:SetRelation( 'ID_ENCH_CARTA', { { 'Z9C_FILIAL', 'xFilial( "Z9C" )' }, { 'Z9C_CADAST', 'Z9B_CADAST' } }, Z9C->( IndexKey( 1 ) ) )

oModel:GetModel( 'ID_ENCH_CARTA' ):SetUniqueLine( { 'Z9C_LINHA' } )

oModel:SetPrimaryKey( {"Z9B_FILIAL","Z9B_CADAST"} )
oModel:SetDescription("Layout Integração")
oModel:GetModel("ID_ENCH_COLAB"):SetDescription("Layout Integração API 4DMG")
oModel:GetModel("ID_ENCH_CARTA"):SetDescription("Linhas do Layout Integração API 4DMG")
oModel:GetModel("ID_ENCH_CARTA"):SetNoInsertLine( .F. ) // Permite inserir linhas...
oModel:GetModel("ID_ENCH_CARTA"):SetNoUpdateLine( .F. ) // Permite alterar linhas...
oModel:GetModel("ID_ENCH_CARTA"):SetNoDeleteLine( .F. ) // Permite deletar linhas...
oModel:GetModel("ID_ENCH_CARTA"):SetOptional( .T. )     // Não exige existência de linhas...

oStruZ9C:SetProperty('Z9C_CADAST',MODEL_FIELD_INIT ,{|o| M->Z9B_CADAST .And. !INCLUI })

Return(oModel)

Static Function ViewDef()

Local oStruZ9B 	:= FwFormStruct(2,"Z9B")
Local oStruZ9C 	:= FwFormStruct(2,"Z9C")
Local oModel 	:= FwLoadModel("BeLayout")
Local oView		:= FwFormView():New()

oView:SetModel(oModel)
oView:AddField("ID_VIEW_COLAB", oStruZ9B, "ID_ENCH_COLAB")

oStruZ9C:RemoveField( 'Z9C_CADAST' )

oView:AddGrid("ID_VIEW_CARTA", oStruZ9C, "ID_ENCH_CARTA")
 
oView:AddIncrementField( "ID_VIEW_CARTA", 'Z9C_LINHA')

oView:CreateHorizontalBox( 'SUPERIOR', 40 ) 
oView:CreateHorizontalBox( 'INFERIOR', 60 ) 
oView:SetOwnerView( "ID_VIEW_COLAB", 'SUPERIOR' ) 
oView:SetOwnerView( "ID_VIEW_CARTA", 'INFERIOR' ) 

oView:EnableTitleView("ID_VIEW_COLAB")
oView:EnableTitleView("ID_VIEW_CARTA")

Return( oView )
