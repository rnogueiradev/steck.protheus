#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT240        | Autor | RENATO.OLIVEIRA           | Data | 21/10/2019  |
|=====================================================================================|
|Descrição | Tela para reprocessar fatec				                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT240()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1))
	
	SZ9->(dbSetFilter({|| !Empty(SZ9->Z9_DTVLDDV) .And. Empty(SZ9->Z9_FATEC) }," !Empty(SZ9->Z9_DTVLDDV) .And. Empty(SZ9->Z9_FATEC) "))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Reprocessamento de FATEC")
	oBrowse1:SetAlias("SZ9")

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
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT240" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Reprocessar" 				ACTION "U_STFAT241" 		OPERATION 2  ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'SZ9')
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
	Local oStr1:= FWFormStruct(2, 'SZ9')
	Local oModel     := FWLoadModel("STFAT240")

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
	Local nOp         		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT241
@name STFAT241
@type User Function
@desc reprocessar fatec
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT241()

	SZ9->(RecLock("SZ9",.F.))
	SZ9->Z9_DTVLDDV := CTOD("  /  /    ")
	SZ9->(MsUnLock())
	
Return()