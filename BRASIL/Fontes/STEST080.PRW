#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STEST080         | Autor | Renato Nogueira            | Data | 15/07/2019|
|=====================================================================================|
|DescriÃ§Ã£o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................HistÃ³rico....................................|
\====================================================================================*/

User Function STEST080()

Local oBrowse
Private aRotina 	:= MenuDef()

oBrowse1 := FWmBrowse():New()
oBrowse1:SetDescription("Alocaçãoo da arrumação")
oBrowse1:SetAlias("Z43")

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

ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STEST080" 	OPERATION 2  ACCESS 0
ADD OPTION aRotina TITLE "Excluir"    		        ACTION "VIEWDEF.STEST080"	OPERATION 5  ACCESS 0

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
Local oStr1:= FWFormStruct(1,'Z43')
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
Local oStr1:= FWFormStruct(2, 'Z43')
Local oModel     := FWLoadModel("STEST080")

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
@desc validar alteraï¿½ï¿½o do pedido
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
@desc realiza gravaï¿½ï¿½o dos dados
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