#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STBEMTI          | Autor | GIOVANI.ZAGO             | Data | 30/10/2014 |
|=====================================================================================|
|Descrição | STBEMTI                                                                 |
|          |  																	      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STBEMTI                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*----------------------------------* 
User Function STBEMTI()
*----------------------------------* 

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ST9")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("STBEMTI")					// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Bens T.I.")   	// Descrição do browse //"Alíquotas de ICMS"
	oBrowse:Activate()

Return(Nil)

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	Local _cUser := GetMv("ST_STBEMTI",,"000000/000645")+"000000/000645"
	
//-------------------------------------------------------
// Adiciona botões do browse
//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"        OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STBEMTI" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STBEMTI" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STBEMTI" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STBEMTI" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.STBEMTI" OPERATION 9 ACCESS 0 //"Copiar"
 	ADD OPTION aRotina TITLE "Cad.SoftWare"    ACTION "u_STCADSOF()" OPERATION 3 ACCESS 0 //"Incluir"
 

 
Return aRotina

 
 
Static Function ModelDef()
// Cria as estruturas a serem usadas no Modelo de Dados
Local oStruZA1 := FWFormStruct( 1, 'ST9' )
Local oStruZA2 := FWFormStruct( 1, 'STB' )
Local oStruZZK := FWFormStruct( 1, 'ZZK' )
Local oModel // Modelo de dados construído
// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'xzx' )
// Adiciona ao modelo um componente de formulário
oModel:AddFields( 'ZA1MASTER', /*cOwner*/, oStruZA1 )
 
// Adiciona ao modelo uma componente de grid
oModel:AddGrid( 'ZA2DETAIL', 'ZA1MASTER', oStruZA2 )
// Adiciona ao modelo uma componente de grid
oModel:AddGrid( 'ZZKDETAIL', 'ZA1MASTER', oStruZZK )
// Faz relacionamento entre os componentes do model
oModel:SetRelation( 'ZA2DETAIL', { { 'TB_FILIAL', 'xFilial( "STB" )' }, { 'TB_CODBEM', 'T9_CODBEM' } }, STB->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZZKDETAIL', { { 'ZZK_FILIAL', 'xFilial( "ZZK" )' }, { 'ZZK_CODBEM', 'T9_CODBEM' } }, ZZK->( IndexKey( 1 ) ) )
// Adiciona a descrição do Modelo de Dados
oModel:SetDescription( 'Bens T.I.' )
// Adiciona a descrição dos Componentes do Modelo de Dados
oModel:GetModel( 'ZA1MASTER' ):SetDescription( 'Ativo' )
oModel:GetModel( 'ZA2DETAIL' ):SetDescription( 'Hardware' )
oModel:GetModel( 'ZZKDETAIL' ):SetDescription( 'SoftWare' )
// Retorna o Modelo de dados
Return oModel
 
 
 Static Function ViewDef()
// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
Local oModel := FWLoadModel( 'STBEMTI' )
// Cria as estruturas a serem usadas na View
Local oStruZA1 := FWFormStruct( 2, 'ST9' )
Local oStruZA2 := FWFormStruct( 2, 'STB' )
Local oStruZZK := FWFormStruct( 2, 'ZZK' )
// Interface de visualização construída
Local oView
// Cria o objeto de View
oView := FWFormView():New()
// Define qual Modelo de dados será utilizado
oView:SetModel( oModel )
// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
oView:AddField( 'VIEW_ZA1', oStruZA1, 'ZA1MASTER' )
//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
oView:AddGrid( 'VIEW_ZA2', oStruZA2, 'ZA2DETAIL' )
//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
oView:AddGrid( 'VIEW_ZZK', oStruZZK, 'ZZKDETAIL' )

 // Cria Folder na view
oView:CreateFolder( 'PASTAS' )
// Cria pastas nas folders
oView:AddSheet( 'PASTAS', 'ABA01', 'Ativo' )
oView:AddSheet( 'PASTAS', 'ABA02', 'Hardware' )
oView:AddSheet( 'PASTAS', 'ABA03', 'Software' )
// Cria um "box" horizontal para receber cada elemento da view

oView:CreateHorizontalBox( 'GERAL' , 100,,, 'PASTAS', 'ABA01' )
oView:CreateHorizontalBox( 'CORPO' , 100,,, 'PASTAS', 'ABA02' )
oView:CreateHorizontalBox( 'VAGINA' , 100,,, 'PASTAS', 'ABA03' )
// Relaciona o identificador (ID) da View com o "box" para exibição
oView:SetOwnerView( 'VIEW_ZA1', 'GERAL' )
oView:SetOwnerView( 'VIEW_ZA2', 'CORPO' )
oView:SetOwnerView( 'VIEW_ZZK', 'VAGINA' )
// Retorna o objeto de View criado
Return oView
 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
            