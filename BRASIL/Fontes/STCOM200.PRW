#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM200        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM200()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Fornecedores")
	oBrowse1:SetAlias("SA2")

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

	ADD OPTION aRotina TITLE "Pesquisar"  					ACTION "AxPesqui"        	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 					ACTION "VIEWDEF.STCOM200" 	OPERATION 2   ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    					ACTION "VIEWDEF.STCOM200" 	OPERATION 4   ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'SA2')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})
	oModel:SetDescription('Main')
	oModel:addFields('FIELD1',,oStr1,)
	oModel:SetPrimaryKey({})
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SA2"))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SA2"
		If X3USO(AllTrim(SX3->X3_CAMPO))
			oStr1:SetProperty(AllTrim(SX3->X3_CAMPO),MODEL_FIELD_OBRIGAT, .F.)
		EndIf
		SX3->(DbSkip())
	EndDo

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView		:= NIL
	Local oStr1		:= FWFormStruct(2, 'SA2')
	Local oModel    := FWLoadModel("STCOM200")

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SA2"))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SA2"
		If !(AllTrim(SX3->X3_CAMPO) $ "A2_BANCO#A2_AGENCIA#A2_X_DVAGE#A2_NUMCON#A2_X_DVCTA#")
			oStr1:RemoveField(AllTrim(SX3->X3_CAMPO))
		EndIf
		SX3->(DbSkip())
	EndDo

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
	Local nOp         := oModel:GetOperation()
	Local _cCod			:= SA2->A2_COD

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

	If !MsgYesNo("Deseja replicar para todas as filiais?")
		Return
	EndIf

	cBANCO 		:= SA2->A2_BANCO
	cAGENCIA	:= SA2->A2_AGENCIA
	cXDVAGE		:= SA2->A2_X_DVAGE
	cNUMCON		:= SA2->A2_NUMCON
	cXDVCTA		:= SA2->A2_X_DVCTA

	_aAreaSA2 := SA2->(GetArea())

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+SA2->A2_COD))
	While SA2->(!Eof()) .And. AllTrim(SA2->A2_COD)==AllTrim(_cCod)

		SA2->(RecLock("SA2",.F.))
		SA2->A2_BANCO		:= cBANCO
		SA2->A2_AGENCIA		:= cAGENCIA
		SA2->A2_X_DVAGE		:= cXDVAGE
		SA2->A2_NUMCON		:= cNUMCON
		SA2->A2_X_DVCTA		:= cXDVCTA
		SA2->(MsUnLock())

		SA2->(DbSkip())
	EndDo

	RestArea(_aAreaSA2)

	MsgAlert("Dados atualizados com sucesso, obrigado!")

Return lGrv