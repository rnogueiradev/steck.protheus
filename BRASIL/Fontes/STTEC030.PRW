#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STTEC030        | Autor | RENATO.OLIVEIRA           | Data | 31/01/2019  |
|=====================================================================================|
|Descrição | Nova rotina de chamados                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STTEC030()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Rotina de chamados")
	oBrowse1:SetAlias("SZ0")

	oBrowse1:AddLegend("SZ0->Z0_STATUS == '1'"	,"GREEN"	,"Aguardando aprov. supervisor")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '2'"	,"RED"		,"Aprovado pelo supervisor")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '3'"	,"BLUE"		,"Alocado para analista")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '4'"	,"GRAY"		,"Em desenvolvimento")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '5'"	,"WHITE"	,"Aguardando interação do usuário")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '6'"	,"PINK"		,"Aprovado pelo usuário")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '7'"	,"ORANGE"	,"Liberado para produção")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '8'"	,"BLACK"	,"Concluído")
	oBrowse1:AddLegend("SZ0->Z0_STATUS == '9'"	,"YELLOW"	,"Cancelado")

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
	ADD OPTION aRotina TITLE "Visualizar" 					ACTION "VIEWDEF.STTEC030" 	OPERATION 2   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    					ACTION "VIEWDEF.STTEC030" 	OPERATION 3   ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    					ACTION "VIEWDEF.STTEC030" 	OPERATION 4   ACCESS 0
	ADD OPTION aRotina TITLE "Abrir chamado (analista)"		ACTION "U_STTEC031" 		OPERATION 10  ACCESS 0
	ADD OPTION aRotina TITLE "Interagir"					ACTION "U_STTEC032" 		OPERATION 11  ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'SZ0')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})
	oModel:SetDescription('Main')
	oModel:addFields('FIELD1',,oStr1,)
	oModel:SetPrimaryKey({})
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

	oStr1:SetProperty('Z0_USUARIO',MODEL_FIELD_WHEN, {||IsInCallStack("U_STTEC031")})
	
	oStr1:SetProperty('Z0_SOLUCAO',MODEL_FIELD_OBRIGAT, If(IsInCallStack("U_STTEC031"),.T.,.F.))
	oStr1:SetProperty('Z0_ROTINA',MODEL_FIELD_OBRIGAT,  If(IsInCallStack("U_STTEC031"),.T.,.F.))
	oStr1:SetProperty('Z0_RPOHML',MODEL_FIELD_OBRIGAT,  If(IsInCallStack("U_STTEC031"),.T.,.F.))
	oStr1:SetProperty('Z0_HRTOTAL',MODEL_FIELD_OBRIGAT, If(IsInCallStack("U_STTEC031"),.T.,.F.))
	oStr1:SetProperty('Z0_PROCEDE',MODEL_FIELD_OBRIGAT, If(IsInCallStack("U_STTEC031"),.T.,.F.))
	
	oStr1:SetProperty('Z0_STATUS',MODEL_FIELD_INIT, {||If(IsInCallStack("U_STTEC031"),"8","1")})

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
	Local oStr1:= FWFormStruct(2, 'SZ0')
	Local oModel     := FWLoadModel("STTEC030")
	
	//oStr1:RemoveField('Z0_STATUS')
	
	If IsInCallStack("U_STTEC031")
		oStr1:RemoveField('Z0_TIPO')
		oStr1:RemoveField('Z0_NALTPRD')
		oStr1:RemoveField('Z0_DTENTRE')
		oStr1:RemoveField('Z0_STATUS2')
		oStr1:RemoveField('Z0_CONSULT')
	EndIf

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

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STTEC031
@name STTEC031
@type User Function
@desc abrir chamado como analista
@author Renato Nogueira
@since 31/01/2019
/*/

User Function STTEC031()

	Local oView	 := NIL
	Local oStr1	 := FWFormStruct(2, 'SZ0')
	Local oModel := FWLoadModel("STTEC030")

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	If !SX5->(DbSeek("  "+"_1"+__cUserId))
		MsgAlert("Atenção, este usuário não está cadastrado como analista, verifique!")
		Return
	EndIf

	FWExecView('Apontamento analista','STTEC030',3,,{ || .T. } )

Return()

/*/{Protheus.doc} STTEC032
@name STTEC032
@type User Function
@desc interação
@author Renato Nogueira
@since 31/01/2019
/*/

User Function STTEC032()

	Local _cAnalista := ""
	Local _lContinua := .F.

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	If SX5->(DbSeek("  "+"_1"+__cUserId))
		_cAnalista := __cUserId
	EndIf

	If !Empty(_cAnalista) .And. SZ0->Z0_STATUS $ "3#4"
		_lContinua := .T.
	ElseIf Empty(_cAnalista) .And. SZ0->Z0_STATUS $ "5"
		_lContinua := .T.
	EndIf

	If !_lContinua
		MsgAlert("Você não pode realizar interações neste chamado, verifique!")
		Return
	EndIf

Return()