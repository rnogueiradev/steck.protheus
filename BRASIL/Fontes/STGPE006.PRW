#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGPE006   ºAutor  ³Richard N Cabral    º Data ³  20/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao Cadastro de Segmento de Vendedores               º±±
±±º          ³ Tabela Z8 - SX5                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STGPE006()	//U_STGPE006()

	Local lRet := .T.
	Local aArea := SX5->(GetArea())

	Private oBrowse
	Private cChaveAux := ""

	//Iniciamos a construção básica de um Browse.
	oBrowse := FWMBrowse():New()

	//Definimos a tabela que será exibida na Browse utilizando o método SetAlias
	oBrowse:SetAlias("SX5")

	//Definimos o título que será exibido como método SetDescription
	oBrowse:SetDescription("Segmentos de Vendedores")
	
	//Adiciona um filtro ao browse
	oBrowse:SetFilterDefault( "X5_TABELA == 'Z8'" )
	
	//Desliga a exibição dos detalhes
	//oBrowse:DisableDetails()
	
	//Ativamos a classe
	oBrowse:Activate()
	RestArea(aArea)
Return

//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.STGPE006"	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.STGPE006"	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.STGPE006"	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.STGPE006"	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.STGPE006"	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.STGPE006"	OPERATION 9 ACCESS 0

Return aRotina

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'SX5')
	
	// Cria o objeto de View
	oView := FWFormView():New()
	
	// Define qual o Modelo de dados será utilizado
	oView:SetModel(oModel)
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField('Formulario' , oStr1,'CamposSX5' )

        //Remove os campos que não irão aparecer	
	oStr1:RemoveField( 'X5_DESCENG' )
	oStr1:RemoveField( 'X5_DESCSPA' )
	
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'PAI', 100)
	
	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView('Formulario','PAI')
	oView:EnableTitleView('Formulario' , 'Segmentos de Vendedores' )
	oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return oView

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct( 1, 'SX5', /*bAvalCampo*/,/*lViewUsado*/ ) // Construção de uma estrutura de dados
	
	//Cria o objeto do Modelo de Dados
	//Irie usar uma função GPE006V que será acionada quando eu clicar no botão "Confirmar"
	oModel := MPFormModel():New('SegmentosVendedores', /*bPreValidacao*/, { | oModel | GPE006V( oModel ) } , /*{ | oMdl | GPE006C( oMdl ) }*/ ,, /*bCancel*/ )

	oModel:SetDescription('Segmentos de Vendedores')
	
	//Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'Z8'} )

	//Abaixo irei bloquear/liberar os campos para edição
	oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })

	//Podemos usar as funções INCLUI ou ALTERA
	//oStr1:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })

	//Ou usar a propriedade GetOperation que captura a operação que está sendo executada
	oStr1:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	
	oStr1:RemoveField( 'X5_DESCENG' )
	oStr1:RemoveField( 'X5_DESCSPA' )
	oStr1:RemoveField( 'X5_FILIAL' )
	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:addFields('CamposSX5',,oStr1,{|oModel| GPE006T(oModel)},,)
	
	//Define a chave primaria utilizada pelo modelo
	oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE' })
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:getModel('CamposSX5'):SetDescription('TabelaSX5')
	
Return oModel


//Esta função será executada no inicio do carregamento da tela, neste exemplo irei
//apenas armazenar numa variável o conteudo de um campo
Static Function GPE006T( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposSX5' )
	
	cChaveAux := SX5->X5_CHAVE
 
Return(lRet)

//-------------------------------------------------------------------
// Validações ao salvar registro
// Input: Model
// Retorno: Se erros foram gerados ou não
//-------------------------------------------------------------------
Static Function GPE006V( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposSX5' )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()

	//Capturar o conteudo dos campos
	Local cChave	:= oModelSX5:GetValue('X5_CHAVE')
	Local cTabela	:= oModelSX5:GetValue('X5_TABELA')
	Local cDescri	:= oModelSX5:GetValue('X5_DESCRI')
	
	Begin Transaction
		
		if nOpc == 3 .or. nOpc == 4
			if Empty(cTabela)
				oModelSX5:SetValue('X5_TABELA','Z8')
			Endif
			
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbGoTop())
			If(SX5->(dbSeek(xFilial("SX5")+cTabela+cChave)))
				if cChaveAux != cChave
					SFCMsgErro("A chave "+Alltrim(cChave)+" ja foi informada!","GPE006")
					lRet := .F.
				Endif
			Endif

			if Empty(cChave)
				SFCMsgErro("O campo chave é obrigatório!","GPE006")
				lRet := .F.
			Endif
			
			if Empty(cDescri)
				SFCMsgErro("O campo descrição é obrigatório!","GPE006")
				lRet := .F.
			Endif
			
		Endif
		
		if !lRet
			DisarmTransaction()
		Endif
		
	End Transaction
	
	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet
