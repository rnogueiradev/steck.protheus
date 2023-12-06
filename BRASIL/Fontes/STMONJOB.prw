#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
 
/*/{Protheus.doc} STMONJOB
Tela MVC para monitorar e reprocessar transferencias de Estoque -> Produção, exemplo de Modelo 1 em MVC
@author Natalia	
@since 18/07/2023
@version 1.0
    @return Nil, Função não tem retorno
/*/
User Function STMONJOB()

    Private oBrowse
        
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("CB7")

    oBrowse:SetDescription("Monitoramento de Transferência")

    //Adiciona um filtro ao browse
    oBrowse:SetFilterDefault( "CB7->CB7_XETAPA <> ' ' .AND. CB7->CB7_OP <> ' ' .AND. CB7->CB7_PEDIDO = ' ' " )

    //Legendas
    oBrowse:AddLegend( "CB7_XETAPA == '00' "                            , "GREEN"       ,      "Ordem de Separação Finalizada"      )
    oBrowse:AddLegend( "CB7_XETAPA == '01' "                            , "YELLOW"      ,      "Deletanto Empenho"   )
    oBrowse:AddLegend( "CB7_XETAPA == '02' .AND. CB7_XSTATU <> '3' "    , "BLUE"        ,      "Transfereindo Armazem"     )
    oBrowse:AddLegend( "CB7_XETAPA == '02' .AND. CB7_XSTATU == '3' "    , "BLACK"       ,      "Incluindo Empenho"  )
    oBrowse:AddLegend( "CB7_XETAPA == '03' " , "ORANGE"                 ,      "Incluindo Empenho"  )
    oBrowse:AddLegend( "CB7_XETAPA == '99' " , "RED"                    ,      "Finalizado"  )
   
 
    //Ativamos a classe
    oBrowse:Activate()
	
Return oBrowse

/*/{Protheus.doc} MenuDef
Criação do menu MVC 
@author Natalia	
@since 01/02/2023
@version 1.0
    @return Nil, Função não tem retorno
    @example
    MenuDef()
    @obs 
/*/
 
Static Function MenuDef()

     Local aRotina := {}
     
    Add OPTION aRotina TITLE 'Reprocessar'      ACTION 'U_STREPORD'         OPERATION 4 ACCESS 0
    Add OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.STMONJOB'   OPERATION 2 ACCESS 0
	Add OPTION aRotina TITLE 'Legenda'          ACTION 'U_zMVC01Leg'        OPERATION 6 ACCESS 0 
   

Return aRotina


/*/{Protheus.doc} ModelDef
Criação do modelo de dados MVC 
@author Natalia	
@since 01/02/2023
@version 1.0
    @return Nil, Função não tem retorno
    @example
    ModelDef()
    @obs 
/*/
Static Function ModelDef()

    Local oModel      := NIL
	Local oStCB7 := FWFormStruct(1, 'CB7')
    
	oModel      := MPFormModel():New("XSTMONJOB",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

	//Atribuindo formulários para o modelo
    oModel:AddFields("FORMCB7",/*cOwner*/,oStCB7)

	oModel:SetPrimaryKey({'CB7_FILIAL','CB7_ORDSEP'})

	//Adicionando descrição ao modelo
    oModel:SetDescription("Monitoramento de Transferência")
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMCB7"):SetDescription("Monitoramento de Transferência")
     

Return oModel

/*/{Protheus.doc} ViewDef
Criação da visão MVC 
@author Natalia	
@since 01/02/2023
@version 1.0
    @return Nil, Função não tem retorno
    @example
    ViewDef()
    @obs 
/*/
Static Function ViewDef()

	Local oModel := FWLoadModel("STMONJOB")
	Local oStCB7 := FWFormStruct(2, 'CB7')

	 Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_CB7", oStCB7, "FORMCB7")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_CB7', 'Monitoramento de Transferência' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_CB7","TELA")
Return oView

/*/{Protheus.doc} STREPORD
	Função para colocar ordem de separação com status de reprocessamento
	@type  Function
	@author user
	@since 19/07/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function STREPORD()

	If MSGNOYES( 'Deseja reprocessar a Ordem '+Alltrim(CB7->CB7_ORDSEP)+' ?', 'Repocessamento' )

	
		IF CB7->(DBSEEK(xFilial('CB7')+CB7->CB7_ORDSEP))
			
			RECLOCK( "CB7", .F. )
			    CB7->CB7_XSTATU := '1'
			MSUNLOCK()

		EndIf	

		MSGINFO( 'Ordem '+Alltrim(CB7->CB7_ORDSEP)+' Em reprocessamente', 'Repocessamento'  )

	EndIf	
	
Return 

/*/{Protheus.doc} zMVC01Leg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
@author Natalia
@since 19/06/2023
@version 1.0
    @example
    u_zMVC01Leg()
/*/
 
User Function zMVC01Leg()
    Local aLegenda := {}
     
    AADD(aLegenda,{"BR_VERDE",          "Ordem de Separação Finalizada"     })
	AADD(aLegenda,{"BR_AMARELO",        "Deletanto Empenho"                 })
	AADD(aLegenda,{"BR_AZUL",           "Transferindo Armazem"              })
    AADD(aLegenda,{"BR_PRETO",          "Transferindo com Erro"             })
	AADD(aLegenda,{"BR_LARANJA",        "Incluindo Empenho"                 })
    AADD(aLegenda,{"BR_VERMELHO",       "Finalizado"                        })
    
   
     
    BrwLegenda("Status", "Status", aLegenda)
Return
