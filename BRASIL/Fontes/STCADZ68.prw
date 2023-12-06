#include "Totvs.ch"
#Include "Protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "TopConn.ch"

#Define cIDMODEL "Z68MASTER"
#Define cViewID "VIEW_Z68"

 /*/{Protheus.doc} STCADZ68()
    (long_description)
    Controle de Ger.Produto Desenvolvido
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    30/03/2020
    @example
	u_STCADZ68()
/*/
User Function STCADZ68()
	Local cFilterDefault := ""
	Private cCadastro 	 := "Cadastro Ger.Produtos Desenvolvidos"
	Private oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z68")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STCADZ68")			// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription(cCadastro)   	// Descrição do browse

	oBrowse:SetUseCursor(.T.)
	oBrowse:Activate()    

Return



//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina 		 := {}
	    
	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.STCADZ68" 	OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.STCADZ68" 	OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.STCADZ68" 	OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.STCADZ68"	OPERATION 2 ACCESS 0

Return aRotina



//-------------------------------------------------------------------
// Montando a tela
//-------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel 		:= FwLoadModel("STCADZ68")
	Local oStr1		    := FWFormStruct(2, 'Z68')
	Local nOperation    := oModel:GetOperation()
	
	// Cria o objeto de View
	oView := FWFormView():New()

	oView:Refresh()
	
	// Define qual o Modelo de dados será utilizado
	oView:SetModel(oModel)
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField(cViewID , oStr1, cIDMODEL )

    //Remove os campos que não irão aparecer	
	//oStr1:RemoveField( 'Z54_CONTRO' )

	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk( {|| .T.} )
	
Return oView




//-------------------------------------------------------------------
// Montando Modelo de Dados
//-------------------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local oStr1     := FWFormStruct( 1, 'Z68', /*bAvalCampo*/,/*lViewUsado*/ ) // Construção de uma estrutura de dados
	Local bCancel   := {|oModel| xClosed(oModel) }
	Local bPreValid := { |oModel| GetTela( oModel ) }
	
	//Cria o objeto do Modelo de Dados
   //função GRVCADZ68 que será acionada quando eu clicar no botão "Confirmar"
	oModel := MPFormModel():New(cIDMODEL, /*bPreValid*/, { | oModel | GRVCADZ68( oModel ) } , /*{ | oMdl | fEXPMVC1C( oMdl ) }*/ ,bCancel )
	oModel:SetDescription(cCadastro)

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields(cIDMODEL, /*cOwner*/, oStr1, /*bPreValid*/, /*bPosValid*/, /*bLoad*/)

	// Adiciona a STCADSA2 do Componente do Modelo de Dados
	oModel:getModel(cIDMODEL):SetDescription(cCadastro)
	
	//Define a chave primaria utilizada pelo modelo
	oModel:SetPrimaryKey({'Z68_FILIAL','Z68_PRODUT' })
		
Return oModel



//-------------------------------------------------------------------
// Salva registro
// Input: Model
// Retorno: Se erros foram gerados ou não
//-------------------------------------------------------------------
Static Function GRVCADZ68( oModel )
	Local lRet      := .T.
	Local oModelZ68 := oModel:GetModel( cIDMODEL )   
	Local oModView  := oModelZ68:GetModel(cViewID )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()
	Local lNovo     := .F.

	//Capturar o conteudo dos campos
	Local cChave	:= oModelZ68:GetValue('Z68_PRODUT')

	dbSelectArea("Z68")
	dbSetOrder(1)
	
	Begin Transaction
		
		if ((nOpc == 3) .or. (nOpc == 4)) 
            if (nOPC == 4)
               lRET := MsgYesNo("Deseja realmente salvar","Informação")
            endif
            if lRET
			    FWFormCommit( oModel )
            endif

		Elseif nOPC == 5

			if MsgNoYes("Deseja realmente excluir o registro?", "Atenção!")
				RecLock("Z68", .F.)
				dbDelete()
				MsUnlock()
			endif

		Endif
		
		if !lRet
			DisarmTransaction()
		Endif
		
	End Transaction

	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet

//-------------------------------------------------------------------
// Pressionado botão Cancelar
// Input: Model
// Retorno: Aplica o Rollback para voltar a numeração sequencial
//-------------------------------------------------------------------
Static Function xClosed(oModel)
	Local nOperation := oModel:GetOperation()
	Local lRet := .T.

	IF nOperation == 3
		RollbackSx8()
	Endif

Return .T.

