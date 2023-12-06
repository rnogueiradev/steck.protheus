#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'TBICONN.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | gModific          | Autor | Genivaldo.Reis           | Data | 01/01/2016 |
|=====================================================================================|
|Sintaxe   | gModific                                                                 |
|=====================================================================================|
|Uso       | Treinamento Genivaldo                                                    |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================
*/
*----------------------------------*
User Function gModific() // u_gModific()
	*----------------------------------*
	Local oBrowse
	//     Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210') //
	Private _lPartic := .T.
	
	//     PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
	
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SBM")                               // Alias da tabela utilizada
	oBrowse:SetMenuDef("gModific")                 // Nome do fonte onde esta a funГЦo MenuDef
	oBrowse:SetDescription("Grupo X Modificador")         // DescriГЦo do browse
	
	/*
	If     !(__cUserId $ _UserMvc)
		oBrowse:SetFilterDefault( 'PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId' )
	EndIF
	*/
	
	oBrowse:Activate()
	
	//     RESET ENVIRONMENT
Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botУes do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.gModific"    OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.gModific"    OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.gModific"    OPERATION 2 ACCESS 1 //"Visualizar"
	//ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STMVC"            OPERATION 8 ACCESS 0 //"Imprimir"
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"                   OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	//     ADD OPTION aRotina TITLE "Vwww" ACTION "VIEWDEF.STMVC" OPERATION 2 ACCESS 1 //"Visualizar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.gModific"    OPERATION 5 ACCESS 0 //"Excluir"
	
Return aRotina


Static Function ModelDef()
	Local oStruCabec := FWFormStruct(1, "SBM")// ConstruГЦo de estrutura de dados
	Local oStruItens := FWFormStruct(1, "ZZ5")// ConstruГЦo de estrutura de dados
	Local oModel
	Local _cTitulo   := "Grupo X Modificador"
	Local _cCabec    := "Grupo X Modificador"
	Local _cItens    := "Modificadores"
	Local _aRel      := {}
	//Local aAux1      := CreateTrigger(1)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executo os gatilhos sem a utilizaГЦo do arquivo Z.
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruItens:AddTrigger( ;
		//aAux1[1] , ;// [01] Id do campo de origem
	//aAux1[2] , ;// [02] Id do campo de destino
	//aAux1[3] , ;// [03] Bloco de codigo de validaГЦo da execuГЦo do gatilho
	//aAux1[4] )  // [04] Bloco de codigo de execuГЦo do gatilho
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Cria o objeto do Modelo de Dados
	//Ё Irie usar uma funГЦo VldTOK que serА acionada quando eu clicar no botЦo "Confirmar"
	//Ё Irie usar uma funГЦo GrvTOK que serА acionada apСs a confirmaГЦo do botЦo "Confirmar"
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oModel := MPFormModel():New("gModific"  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	oModel := MPFormModel():New('gModific', /*bPre*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Abaixo irei bloquear/liberar os campos para ediГЦo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruCabec:SetProperty('BN_FILIAL'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_APROVP'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTFIMAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_STATUS'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_APROVS'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAS' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTFIMAS' , MODEL_FIELD_WHEN,{|| .F. })
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Podemos usar as funГУes INCLUI ou ALTERA
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ou usar a propriedade GetOperation que captura a operaГЦo que estА sendo executada
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Adiciona ao modelo uma estrutura de formulАrio de ediГЦo por campo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	oModel:AddGrid("ITENS","CABECALHO", oStruItens)//,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fazendo o relacionamento entre o CabeГalho e Item
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aAdd(_aRel, {'BM_FILIAL' , 'ZZ5_FILIAL'} )
	aAdd(_aRel, {'BM_GRUPO' , 'ZZ5_GRUPO'} )
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fazendo o relacionamento entre os compomentes do model
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oModel:SetRelation('ITENS', _aRel, ZZ5->(IndexKey(1))) //IndexKey -> quero a ordenaГЦo e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordenaГЦo e depois filtrado
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fazendo a validaГЦo para nЦo permitir linha duplicada
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oModel:GetModel('ITENS'):SetUniqueLine({"ZZ5_NUM"})  //NЦo repetir informaГУes ou combinaГУes {"CAMPO1","CAMPO2","CAMPOX"}
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Define a chave primaria utilizada pelo modelo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oModel:SetPrimaryKey({})
	//oModel:SetPrimaryKey({"ZI_CC"})
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Adiciona a descricao do Componente do Modelo de Dados
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:GetModel("ITENS"):SetDescription(_cItens)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё ValidaГЦo para inicializador padrЦo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oModel:SetActivate( {|oMod| IniPad(oMod)} )
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё ValidaГЦo da ativaГЦo do modelo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )
Return oModel

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё ViewDef      ╨Autor  ЁJoao Rinaldi    ╨ Data Ё  15/12/2015 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё A funГЦo ViewDef define como o serА a interface e portanto ╨╠╠
╠╠╨          Ё como o usuАrio interage com o modelo de dados (Model)      ╨╠╠
╠╠╨          Ё recebendo os dados informados pelo usuАrio, fornecendo     ╨╠╠
╠╠╨          Ё ao modelo de dados (definido na ModelDef) e apresentando   ╨╠╠
╠╠╨          Ё o resultado.                                               ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Steck Industria Eletrica Ltda.                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╨Rotina    Ё STCOM010.prw                                               ╨╠╠
╠╠╨Nome      Ё Cadastro de Aprovadores de SolicitaГЦo de Compras          ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ViewDef()
	Local oStruCabec := FWFormStruct(2, "SBM")
	Local oStruItens := FWFormStruct(2, "ZZ5")
	Local oModel     := FWLoadModel("gModific")
	Local oView
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Cria o objeto de View
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Remove os campos que nЦo irЦo aparecer
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//oStruCabec:RemoveField("ZH_CC")
	//oStruCabec:RemoveField("ZH_FILIAL")
	//oStruItens:RemoveField("ZJ_FILIAL")
	//oStruItens:RemoveField("ZJ_APROVP")
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Adicionando os campos do cabeГalho e o grid dos itens
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView:CreateHorizontalBox("SUPERIOR", 40)
	oView:CreateHorizontalBox("INFERIOR", 60)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Amarrando a view com as box
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	oView:SetOwnerView("VIEW_ITENS", "INFERIOR")
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё ForГa o fechamento da janela na confirmaГЦo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView:SetCloseOnOk({||.T.})
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Habilitando tМtulo
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oView:EnableTitleView("VIEW_CABEC")
	oView:EnableTitleView("VIEW_ITENS")
Return oView


