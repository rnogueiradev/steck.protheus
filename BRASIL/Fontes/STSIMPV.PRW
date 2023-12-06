// Bibliotecas necessárias
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#Include "TopConn.ch"

Static cCaminho    := "C:\Temp\"

/*/{Protheus.doc} STSIMPV
    Simulação de pedidos de venda.
    Projeto Simulação PV
    @type Function
    @version 12.1.33
    @author Valdemir Rabelo
    @since 31/08/2022
    @return Variant, Retorno nulo fixado
/*/
User Function STSIMPV() As Variant
    // Variáveis locais
    Local oBrowse As Object // Navegador de registros herdado da função estática BrowseDef()

    If Upper(GetEnvserv())=="PROD"
        MsgAlert("Rotina não pode ser utilizada no ambiente oficial")
        Return
    EndIf
    
    if !ExistDir(cCaminho)
       MAKEDIR( cCaminho )
    endif

    // Inicialização de variáveis
    oBrowse := FwLoadBrw("STSIMPV")

    // Inicializa o browser
    oBrowse:Activate()

    // Remove o browser da memória
    oBrowse:Deactivate()
    oBrowse:Destroy()
    FwFreeObj(oBrowse)
Return (NIL)

/*/{Protheus.doc} BrowseDef
    Define as regras de exibição do navegador de registros.
    @type Function
    @version 12.1.33
    @author Valmir Rabelo
    @since 31/08/2022
    @return Object, Navegador da rotina
/*/
Static Function BrowseDef() As Object
    // Variáveis locais
    Local oBrowse As Object // Navegador de registros

    // Inicialização de variáveis
    oBrowse := FwMBrowse():New()

    // Define as opções do browser
    oBrowse:SetAlias("ZAA")
    oBrowse:SetMenuDef("STSIMPV")
    oBrowse:SetDescription("Simulação de Pedido de Vendas")
    oBrowse:DisableDetails()

    // Adiciona legendas no browser
    oBrowse:AddLegend("Empty(ZAA_STATUS)",  "GREEN", "Aguardando geração")
    oBrowse:AddLegend("!Empty(ZAA_NUMNF)  .AND. ZAA_STATUS == 'G'", "RED",   "Pedido e Nota Gerado")
    oBrowse:AddLegend("!Empty(ZAA_STATUS) .AND. ZAA_STATUS=='B' ",  "BLUE",  "PV Gerado e Bloqueado (Estoque/Credito)")
Return (oBrowse)

/*/{Protheus.doc} MenuDef
    Define as operações que a rotina irá executar.
    @type Function
    @version 12.1.33
    @author Valmir Rabelo
    @since 31/08/2022
    @return Array, Vetor de operações da rotina
/*/
Static Function MenuDef() As Array
    // Variáveis locais
    Local aMenu As Array // Vetor de operações da rotina

    // Inicialização de variáveis
    aMenu := FwMVCMenu("STSIMPV")

    // Adiciona novas operações
    ADD OPTION aMenu TITLE "Gerar PV/NF"  ACTION "U_STmrkPV('')"  OPERATION 1 ACCESS 0
    ADD OPTION aMenu TITLE "Limpa Status" ACTION "U_STmrkPV('1')" OPERATION 1 ACCESS 0
    ADD OPTION aMenu TITLE "Histor Erro"  ACTION "U_STmrErr"      OPERATION 1 ACCESS 0

Return (aMenu)

/*/{Protheus.doc} ModelDef
    Define as regras de negócio envolvidas no processo.
    @type Function
    @version 12.1.33
    @author Valmir Rabelo
    @since 31/08/2022
    @return Object, Modelo de dados contendo as regras de validação e persistência
/*/
Static Function ModelDef() As Object
    // Variáveis locais
    Local oModel As Object // Modelo de dados (regras de negócio)
    Local oZAA   As Object // Estrutura da tabela ZAA
    Local oZAB   As Object // Estrutura da tabela ZAB
	Local aAux1 := CreateTrigger(1) // Cliente
	Local aAux2 := CreateTrigger(2) // CNPJ
	Local aAux3 := CreateTrigger(3) // Preço
    Local bPre  := { |oModel| AntValid(oModel) }
    Local bPos  := { |oModel| PosValid(oModel) }

    // Inicialização de variáveis
    oModel := MPFormModel():New("MSTSIMPV", bPre, bPos)
    oZAA   := FwFormStruct(1, "ZAA")
    oZAB   := FwFormStruct(1, "ZAB")

	//iniciar o campo o conteudo da sub-tabela
	oZAA:SetProperty('ZAA_NUMOC', MODEL_FIELD_INIT, {|| GtPrxNum(oModel) } )

	//oStruPai:SetProperty('ZAA_FILIAL', MODEL_FIELD_WHEN,{|| .F. })

	// Executo os gatilhos sem a utilização do arquivo SX7
	oZAA:AddTrigger( ;
	aAux1[1] , ;// [01] Id do campo de origem
	aAux1[2] , ;// [02] Id do campo de destino
	aAux1[3] , ;// [03] Bloco de codigo de validação da execução do gatilho
	aAux1[4] )  // [04] Bloco de codigo de execução do gatilho

	oZAA:AddTrigger( ;
	aAux2[1] , ;// [01] Id do campo de origem
	aAux2[2] , ;// [02] Id do campo de destino
	aAux2[3] , ;// [03] Bloco de codigo de validação da execução do gatilho
	aAux2[4] )  // [04] Bloco de codigo de execução do gatilho

	oZAB:AddTrigger( ;
	aAux3[1] , ;// [01] Id do campo de origem
	aAux3[2] , ;// [02] Id do campo de destino
	aAux3[3] , ;// [03] Bloco de codigo de validação da execução do gatilho
	aAux3[4] )  // [04] Bloco de codigo de execução do gatilho


    // Vincula a estrutura da ZAA ao submodelo
    oModel:AddFields("MD_MASTERZAA", NIL, oZAA)
    oModel:AddGrid("MD_DETAILZAB", "MD_MASTERZAA", oZAB)

    // Definições extras do modelo
    oModel:SetDescription("Simulação de Pedido de Vendas")

    // Descrição do submodelo
    oModel:GetModel("MD_MASTERZAA"):SetDescription("Cabeçalho da Simulação")
    oModel:GetModel("MD_DETAILZAB"):SetDescription("Itens da Simulação")

    // Define o relacionamento entre os submodelos
    oModel:SetRelation("MD_DETAILZAB", {{"ZAB_FILIAL", "FwXFilial('ZAA')"}, {"ZAB_NUMOC", "ZAA_NUMOC"}}, ZAB->(IndexKey(1)))

    // Definição de chave primária
    oModel:SetPrimaryKey({"ZAA_FILIAL", "ZAA_NUMOC"})

Return (oModel)

/*/{Protheus.doc} ViewDef
    Define as regras de exibição da rotina.
    @type Function
    @version 12.1.33
    @author Valmir Rabelo
    @since 31/08/2022
    @return Object, Modelo de visualização contendo as regras de exibição da rotina
/*/
Static Function ViewDef() As Object
    // Variáveis locais
    Local oModel As Object // Modelo de dados (regras de negócio)
    Local oView  As Object // Definições de visualização
    Local oZAA   As Object // Estrutura da tabela ZAA
    Local oZAB   As Object // Estrutura da tabela ZAB

    // Inicialização de variáveis
    oModel := FwLoadModel("STSIMPV")
    oView  := FwFormView():New()
    oZAA   := FwFormStruct(2, "ZAA")
    oZAB   := FwFormStruct(2, "ZAB")

    // Define o modelo de dados da view
    oView:SetModel(oModel)

    //Removendo campos
	oZAB:RemoveField("ZAB_FILIAL")
	oZAB:RemoveField("ZAB_NUMOC")
	oZAB:RemoveField("ZAB_CLIENT")
	oZAB:RemoveField("ZAB_LOJA")

    // Cria as subviews da view atual
    oView:AddField("VW_MASTERZAA", oZAA, "MD_MASTERZAA")
    oView:AddGrid("VW_DETAILZAB", oZAB, "MD_DETAILZAB")

    // Cria os boxes e vincula as subviews aos mesmos
    oView:CreateHorizontalBox("TOP", 40)
    oView:CreateHorizontalBox("BOTTOM", 60)
    oView:SetOwnerView("VW_MASTERZAA", "TOP")
    oView:SetOwnerView("VW_DETAILZAB", "BOTTOM")

    // Define os títulos das subviews
    oView:EnableTitleView("VW_MASTERZAA", "CABEÇALHO")
    oView:EnableTitleView("VW_DETAILZAB", "LISTA DE ITENS")

    // Adicionando campo incremental na grid
	oView:AddIncrementField("VW_DETAILZAB", "ZAB_ITEMP")

Return (oView)


/*/{Protheus.doc} GtPrxNum
Rotina para proximo registro
@type function
@version  12.1.33
@author valdemir rabelo
@since 30/08/2022
@return variant, String
/*/
Static Function GtPrxNum()
	Local cRET := StrZero(1,15)
	Local cQry := ""

	cQry += "SELECT MAX(ZAA_NUMOC) REG " + CRLF 
	cQry += "FROM " + RETSQLNAME('ZAA') + " " + CRLF 
	if select("TPRX") > 0
	   TPRX->( dbCloseArea() )
	endif 
	tcQuery cQry New Alias "TPRX"

	if TPRX->( !EOF() .and. !Empty(TPRX->REG) )
	   cRET := StrZero(val(TPRX->REG)+1, 15)
	endif 

Return cRET



Static Function CreateTrigger(_nTrigger)	
	Local aAux := {}
	
	If _nTrigger == 1
		aAux := FwStruTrigger(;
		"ZAA_CLIENT",;                // Campo Dominio
		"ZAA_NOME",;                  // Campo de Contradominio
		"POSICIONE('SA1',1,XFilial('SA1')+M->ZAA_CLIENT,'A1_NOME')",; // Regra de Preenchimento
		.F. ,;                        // Se posicionara ou nao antes da execucao do gatilhos
		"" ,;                         // Alias da tabela a ser posicionada
		0 ,;                          // Ordem da tabela a ser posicionada
		"" ,;                         // Chave de busca da tabela a ser posicionada
		NIL ,;                        // Condicao para execucao do gatilho
		"01" )                        // Sequencia do gatilho (usado para identificacao no caso de erro)
		
	ElseIf _nTrigger == 2
		aAux := FwStruTrigger(;
		"ZAA_CLIENT",;                // Campo Dominio
		"ZAA_CNPJ",;                  // Campo de Contradominio
		"POSICIONE('SA1',1,XFilial('SA1')+M->ZAA_CLIENT,'A1_CGC')",; // Regra de Preenchimento
		.F. ,;                        // Se posicionara ou nao antes da execucao do gatilhos
		"" ,;                         // Alias da tabela a ser posicionada
		0 ,;                          // Ordem da tabela a ser posicionada
		"" ,;                         // Chave de busca da tabela a ser posicionada
		NIL ,;                        // Condicao para execucao do gatilho
		"02" )                        // Sequencia do gatilho (usado para identificacao no caso de erro)

	ElseIf _nTrigger == 3
		aAux := FwStruTrigger(;
		"ZAB_PRODUT",;                // Campo Dominio
		"ZAB_PRECO",;                 // Campo de Contradominio
		"SB1->B1_PRV1",; 			  // Regra de Preenchimento
		.T. ,;                        // Se posicionara ou nao antes da execucao do gatilhos
		"SB1",;                       // Alias da tabela a ser posicionada
		1 ,;                          // Ordem da tabela a ser posicionada
		"XFilial('SB1')+M->ZAB_PRODUT" ,;  // Chave de busca da tabela a ser posicionada
		NIL ,;                        // Condicao para execucao do gatilho
		"01" )                        // Sequencia do gatilho (usado para identificacao no caso de erro)

	Endif

Return aAux

/*/{Protheus.doc} PosValid
Rotina que valida dados
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/08/2022
@param oModel, object, Objecto
@return variant, Lógico
/*/
Static Function PosValid(oModel)
	Local lRET 		 := .T. 
	Local oModelPai  := oModel:GetModel("MD_MASTERZAA")
	Local aAreaSA1   := FWGetArea()
	Local cChave     := oModelPai:GetValue("ZAA_CLIENT")+oModelPai:GetValue("ZAA_LOJA")
	//Local nOperation := oModel:GetOperation()

	dbSelectArea("SA1")
	DbSetOrder(1)
	lRET := MsSeek(xFilial('SA1')+cChave )
	if !lRET
	   Help(,, 'Help',, "Cliente não encontrado, por favor verifique.", 1, 0)
	endif 
	oModelPai:SetValue("ZAA_NOME", SA1->A1_NOME) 
	oModelPai:SetValue("ZAA_CNPJ", SA1->A1_CGC) 

	FWRestArea( aAreaSA1 )

Return lRET


/*/{Protheus.doc} STmrErr
Rotina para ler erro do registro, caso exista
@type function
@version  12.1.33
@author valdemir rabelo
@since 04/09/2022
@return variant, Nil
/*/
User Function STmrErr
    Local cArquivo := 'STMRKPV_'+ZAA->ZAA_NUMOC+'.txt'

    if File(cCaminho+cArquivo)
       WinExec('explorer.exe  '+cCaminho+cArquivo)
    else 
      FWMsgRun(,{|| Sleep(3000)},'Informativo','Não foi encontrado histórico de erro para o registro selecionado.')
    endif 


Return 


Static Function AntValid(oModel)
	Local lRET 		 := .T. 
	Local oModelPai  := oModel:GetModel("MD_MASTERZAA")
	Local aAreaSA1   := FWGetArea()
	Local cStatus    := oModelPai:GetValue("ZAA_STATUS")

    lRET := (cStatus != "G")

    if !lRET 
       FWAlertInfo("O registro não pode ser alterado, pois já existe nota gerada.","Informativo")
    endif 

    FWRestArea( aAreaSA1 )

Return lRET
