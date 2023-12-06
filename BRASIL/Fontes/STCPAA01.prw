#Include "Protheus.CH"
#include "fwmvcdef.ch"

/*/{Protheus.doc} User Function STCPAA01
    (long_description)
    Cadastro de Usuários / Setores
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
User Function STCPAA01()
    Local oBrowse   := FWMBrowse():New()
    Local cUsuCad   := SuperGetMV("FS_STPAA01",.F.,"000138/000000/001036")
    Private aRotina := Menudef()
    Private cTitulo := "Cadastro Usuários / Setores"

    if !(__cUserid $ cUsuCad)
        MsgInfo("Usuário não tem permissão para entrar nesta rotina","Atenção!")
        Return
    endif

    oBrowse:SetAlias("Z47")
    oBrowse:SetDescription(cTitulo)  
    oBrowse:Activate() 

Return .T.


/*/{Protheus.doc} User Function MenuDef
    (long_description)
    Monta MenuDef
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
Static Function MenuDef()
    Local aMenu := {}

    // Monta menu.
    ADD OPTION aMenu TITLE 'Pesquisar'     ACTION 'PesqBrw'          OPERATION OP_PESQUISAR           ACCESS 0
    ADD OPTION aMenu TITLE 'Visualizar'    ACTION 'VIEWDEF.STCPAA01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0
    ADD OPTION aMenu TITLE 'Incluir'       ACTION 'VIEWDEF.STCPAA01' OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aMenu TITLE 'Alterar'       ACTION 'VIEWDEF.STCPAA01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aMenu TITLE 'Excluir'       ACTION 'VIEWDEF.STCPAA01' OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aMenu


/*/{Protheus.doc} User Function ModelDef
    (long_description)
    Monta ModelDef
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
Static Function ModelDef()
    Local oStruZ47 := FWFormStruct(1, 'Z47')        // Cria as estruturas a serem usadas no modelo de dados.
    Local oModel

    // Cria o objeto do modelo de dados.
    oModel := MPFormModel():New('Z47Model', /*bPreValid*/, /*bPosValid*/, /*bCommitPos*/, /*bCancel*/)

    // Adiciona a descrição do modelo de dados.
    oModel:SetDescription(cTitulo)

    // Adiciona ao modelo um componente de formulário.
    oModel:AddFields('Z47MASTER', /*cOwner*/, oStruZ47, /*bPreValid*/, /*bPosValid*/, /*bLoad*/)
    oModel:GetModel('Z47MASTER'):SetDescription(cTitulo)

    // Configura chave primária.
    oModel:SetPrimaryKey({"Z47_FILIAL", "Z47_USUARI", "Z47_DEPTO"})

// Retorna o Modelo de dados.
Return oModel


/*/{Protheus.doc} User Function ViewDef
    (long_description)
    Monta ViewDef
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
Static Function ViewDef()
    Local oModel     := FWLoadModel('STCPAA01')         // Cria um objeto de modelo de dados baseado no ModelDef do fonte informado.
    Local oStruZC2   := FWFormStruct(2, 'Z47')          // Cria as estruturas a serem usadas na View
    Local oView      := FWFormView():New()              // Cria o objeto de View

    // Define qual Modelo de dados será utilizado
    oView:SetModel(oModel)

    // Define que a view será fechada após a gravação dos dados no OK.
    oView:bCloseOnOk := {|| .T.}

    // Adiciona no nosso view um controle do tipo formulário (antiga enchoice).
    oView:AddField('VIEW_Z47', oStruZC2, 'Z47MASTER')

    // Cria um "box" horizontal para receber cada elemento da view.
    oView:CreateHorizontalBox('SUPERIOR', 100)

    // Relaciona o identificador (ID) da view com o "box" para exibição.
    oView:SetOwnerView('VIEW_Z47', 'SUPERIOR')

Return oView


/*/{Protheus.doc} User Function Z47Model
    (long_description)
    Rotina para futuras validações e situações após gravação
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
User Function Z47Model
    Local uRet       := .T.
    Local aParam     := PARAMIXB
    Local nOper      := 0
    Local oObj       := aParam[1]
    Local cIdPonto   := upper(aParam[2])

    If cIdPonto == "BUTTONBAR"

    ElseIf cIdPonto == "FORMPRE"

    ElseIf cIdPonto == "MODELVLDACTIVE"
        nOper := oObj:getOperation()
        If nOper == MODEL_OPERATION_UPDATE

        Endif

    ElseIf cIdPonto == "MODELCANCEL" .or. cIdPonto == "FORMCOMMITTTSPOS"

    Endif

Return uRet

