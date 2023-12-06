#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCADZ86        | Autor | MARCIO NISHIME            | Data | 30/04/2021    |
|=====================================================================================|
|Descrição | Tela para controle de notificações			                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCADZ86()
    Local _cFiltro := ""
    Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("Z86")
	Z86->(DbSetOrder(1))

	oBrowse:= FWmBrowse():New()
	oBrowse:SetDescription("Notificações")
	oBrowse:SetAlias("Z86")
    
    If (FunName() == "STCADSZR")
        _cFiltro := "Z86_COD IN (SELECT Z87_CODNOT FROM " + RetSqlName("Z87") + " WHERE Z87_EMAIL='" + SZR->ZR_EMAIL + "')"
        oBrowse:SetFilterDefault( "@" + _cFiltro )
    EndIf

	oBrowse:SetUseCursor(.F.)

	oBrowse:Activate()
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
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STCADZ86" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STCADZ86" 	OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STCADZ86" 	OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "U_STCADZ87"         OPERATION 3  ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'Z86')
	Local oStr2:= FWFormStruct(1,'Z87')
    Local aSB1Rel		:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('Z86MASTER',,oStr1)
    oModel:AddGrid('Z871DETAIL','Z86MASTER',oStr2,,,,,)

    aAdd(aSB1Rel, {'Z87_CODNOT','Z86_COD'} )

    oModel:SetRelation('Z871DETAIL', aSB1Rel, Z87->(IndexKey(1)))
	oModel:GetModel('Z871DETAIL'):SetUniqueLine({"Z87_CODNOT", "Z87_EMAIL"})
    

	oModel:SetPrimaryKey({})

	oModel:getModel('Z86MASTER'):SetDescription('Modelo Notificacoes')
	oModel:getModel('Z871DETAIL'):SetDescription('Modelo Relacionamento')

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
	Local oStr1:= FWFormStruct(2, 'Z86')
	Local oStr2:= FWFormStruct(2, 'Z87')
	Local oModel:= FWLoadModel("STCADZ86")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'Z86MASTER' )
	oView:AddGrid('GRID1' , oStr2,'Z871DETAIL' )

	oView:CreateHorizontalBox( 'BOXFORM1', 70)
	oView:CreateHorizontalBox( 'BOXGRID1', 30)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('GRID1','BOXGRID1')

	oView:EnableTitleView('FORM1','Notificação')
	oView:EnableTitleView('GRID1','Usuários')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

    oview:GetViewStruct('Z871DETAIL'):RemoveField("Z87_CODNOT")
    oview:GetViewStruct('Z871DETAIL'):RemoveField("Z87_COD")

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet := .T.
	Local nOp   := oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet := .T.

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

	Local lGrv	:= .T.
	Local nOp   := oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*====================================================================================\
|Programa  | STCADZ87       | Autor | MARCIO NISHIME            | Data | 06/05/2021   |
|=====================================================================================|
|Descrição | TELA PARA INCLUSÃO DE NOTIFICAÇÃO COM EMAIL PREENCHIDO		              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCADZ87()

    Local cEmail := ""
    Local cNome := ""
    Local cEmpresa := ""
    Local oModMsg
    Local oModAcesso

    oModMsg:= FWLoadModel("STCADZ86")

    If (FunName() == "STCADSZR")
        oModAcesso:= FWLoadModel("STCADSZR")
        oModAcesso:Activate()
        cEmail := oModAcesso:GetValue("FIELD1","ZR_EMAIL")
        cNome := oModAcesso:GetValue("FIELD1","ZR_NOMUSR")
        cEmpresa := oModAcesso:GetValue("FIELD1","ZR_NOME")
        oModAcesso:DeActivate()
    EndIF

    oModMsg:SetOperation(3)
    oModMsg:Activate()
    oModMsg:SetValue("Z871DETAIL","Z87_EMAIL", cEmail)
    oModMsg:SetValue("Z871DETAIL","Z87_NOMEUS", cNome)
    oModMsg:SetValue("Z871DETAIL","Z87_EMPRES", cEmpresa)
    nRet:= FWExecView("INCLUIR" , "STCADZ86", 3, , {|| .T. },,,,,,, oModMsg)
    oModMsg:DeActivate()

Return(nRet)
