#include "totvs.ch"
#include "FwMvcDef.ch"
#include "tbiConn.ch"
#include "TopConn.ch"

/*/{Protheus.doc} BeConfig
description
@type function
@version  
@author Administrador
@since 08/01/2022
@return variant, return_description
/*/
User Function BeConfig()

Private oBrowse := FwMBrowse():New()

dbSelectArea("Z9A")
dbSetOrder(1)

oBrowse:SetAlias("Z9A")
oBrowse:SetDescription("Parâmetros de Integração do sistema 4MDG")
oBrowse:AddLegend( "Z9A_ATIVO == 'S'", "GREEN"	, "Integração Sistema 4MDG Ativo")
oBrowse:AddLegend( "Z9A_ATIVO == 'N'", "RED"	, "Integração Sistema 4MDG Inativo")
oBrowse:Activate()

Return

Static Function MenuDef()

Local aMenu := {}

ADD OPTION aMenu TITLE 'Pesquisar' 	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BeConfig'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir'	ACTION 'VIEWDEF.BeConfig'	OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar'	ACTION 'VIEWDEF.BeConfig'	OPERATION 4 ACCESS 0
//ADD OPTION aMenu TITLE 'Excluir'	ACTION 'VIEWDEF.BeConfig'	OPERATION 5 ACCESS 0

Return( aMenu )

Static Function ModelDef()

Local oStruct := FwFormStruct(1,"Z9A")
Local oModel

oModel	:= MpFormModel():New("PeBeConfig",/*Pre-Validacao*/,/*Pós-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields("ID_ENCH_CONMDG",/*cOwner*/,oStruct,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)

oStruct:SetProperty( 'Z9A_ATIVO'  , MODEL_FIELD_WHEN ,{|| INCLUI })

oModel:SetPrimaryKey( {"Z9A_FILIAL","Z9A_ATIVO","Z9A_URLAPI"} )

oModel:SetDescription("Parâmetros de Configuração API Server 4MDG")
oModel:GetModel("ID_ENCH_CONMDG"):SetDescription("Parâmetros de Configuração API Server 4MDG")

Return(oModel)

Static Function ViewDef()

Local oStruct 	:= FwFormStruct(2,"Z9A")
Local oModel 	:= FwLoadModel("BeConfig")
Local oView		:= FwFormView():New()

oView:SetModel(oModel)
oView:AddField("ID_VIEW_CONMDG", oStruct, "ID_ENCH_CONMDG")
oView:CreateHorizontalBox("ID_HBOX", 100)
oView:SetOwnerView("ID_VIEW_CONMDG", "ID_HBOX")
oView:EnableTitleView("ID_VIEW_CONMDG")

Return( oView )
