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
|........................................Hist�rico....................................|
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
	oBrowse:SetMenuDef("gModific")                 // Nome do fonte onde esta a fun��o MenuDef
	oBrowse:SetDescription("Grupo X Modificador")         // Descri��o do browse
	
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
	// Adiciona bot�es do browse
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
	Local oStruCabec := FWFormStruct(1, "SBM")// Constru��o de estrutura de dados
	Local oStruItens := FWFormStruct(1, "ZZ5")// Constru��o de estrutura de dados
	Local oModel
	Local _cTitulo   := "Grupo X Modificador"
	Local _cCabec    := "Grupo X Modificador"
	Local _cItens    := "Modificadores"
	Local _aRel      := {}
	//Local aAux1      := CreateTrigger(1)
	//������������������������������������������������������������������������Ŀ
	//� Executo os gatilhos sem a utiliza��o do arquivo Z.
	//��������������������������������������������������������������������������
	//oStruItens:AddTrigger( ;
		//aAux1[1] , ;// [01] Id do campo de origem
	//aAux1[2] , ;// [02] Id do campo de destino
	//aAux1[3] , ;// [03] Bloco de codigo de valida��o da execu��o do gatilho
	//aAux1[4] )  // [04] Bloco de codigo de execu��o do gatilho
	//������������������������������������������������������������������������Ŀ
	//� Cria o objeto do Modelo de Dados
	//� Irie usar uma fun��o VldTOK que ser� acionada quando eu clicar no bot�o "Confirmar"
	//� Irie usar uma fun��o GrvTOK que ser� acionada ap�s a confirma��o do bot�o "Confirmar"
	//��������������������������������������������������������������������������
	//oModel := MPFormModel():New("gModific"  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	oModel := MPFormModel():New('gModific', /*bPre*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)
	//������������������������������������������������������������������������Ŀ
	//� Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )
	//������������������������������������������������������������������������Ŀ
	//� Abaixo irei bloquear/liberar os campos para edi��o
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty('BN_FILIAL'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_APROVP'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTFIMAP' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_STATUS'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_APROVS'  , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTINIAS' , MODEL_FIELD_WHEN,{|| .F. })
	//oStruCabec:SetProperty('ZH_DTFIMAS' , MODEL_FIELD_WHEN,{|| .F. })
	//������������������������������������������������������������������������Ŀ
	//� Podemos usar as fun��es INCLUI ou ALTERA
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//������������������������������������������������������������������������Ŀ
	//� Ou usar a propriedade GetOperation que captura a opera��o que est� sendo executada
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	//������������������������������������������������������������������������Ŀ
	//� Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	//��������������������������������������������������������������������������
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	oModel:AddGrid("ITENS","CABECALHO", oStruItens)//,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre o Cabe�alho e Item
	//��������������������������������������������������������������������������
	aAdd(_aRel, {'BM_FILIAL' , 'ZZ5_FILIAL'} )
	aAdd(_aRel, {'BM_GRUPO' , 'ZZ5_GRUPO'} )
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre os compomentes do model
	//��������������������������������������������������������������������������
	oModel:SetRelation('ITENS', _aRel, ZZ5->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordena��o e depois filtrado
	//������������������������������������������������������������������������Ŀ
	//� Fazendo a valida��o para n�o permitir linha duplicada
	//��������������������������������������������������������������������������
	oModel:GetModel('ITENS'):SetUniqueLine({"ZZ5_NUM"})  //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	//������������������������������������������������������������������������Ŀ
	//� Define a chave primaria utilizada pelo modelo
	//��������������������������������������������������������������������������
	oModel:SetPrimaryKey({})
	//oModel:SetPrimaryKey({"ZI_CC"})
	//������������������������������������������������������������������������Ŀ
	//� Adiciona a descricao do Componente do Modelo de Dados
	//��������������������������������������������������������������������������
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:GetModel("ITENS"):SetDescription(_cItens)
	//������������������������������������������������������������������������Ŀ
	//� Valida��o para inicializador padr�o
	//��������������������������������������������������������������������������
	//oModel:SetActivate( {|oMod| IniPad(oMod)} )
	//������������������������������������������������������������������������Ŀ
	//� Valida��o da ativa��o do modelo
	//��������������������������������������������������������������������������
	//oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )
Return oModel

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef      �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o ViewDef define como o ser� a interface e portanto ���
���          � como o usu�rio interage com o modelo de dados (Model)      ���
���          � recebendo os dados informados pelo usu�rio, fornecendo     ���
���          � ao modelo de dados (definido na ModelDef) e apresentando   ���
���          � o resultado.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
	Local oStruCabec := FWFormStruct(2, "SBM")
	Local oStruItens := FWFormStruct(2, "ZZ5")
	Local oModel     := FWLoadModel("gModific")
	Local oView
	//������������������������������������������������������������������������Ŀ
	//� Cria o objeto de View
	//��������������������������������������������������������������������������
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//������������������������������������������������������������������������Ŀ
	//� Remove os campos que n�o ir�o aparecer
	//��������������������������������������������������������������������������
	//oStruCabec:RemoveField("ZH_CC")
	//oStruCabec:RemoveField("ZH_FILIAL")
	//oStruItens:RemoveField("ZJ_FILIAL")
	//oStruItens:RemoveField("ZJ_APROVP")
	//������������������������������������������������������������������������Ŀ
	//� Adicionando os campos do cabe�alho e o grid dos itens
	//��������������������������������������������������������������������������
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")
	//������������������������������������������������������������������������Ŀ
	//� Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//��������������������������������������������������������������������������
	oView:CreateHorizontalBox("SUPERIOR", 40)
	oView:CreateHorizontalBox("INFERIOR", 60)
	//������������������������������������������������������������������������Ŀ
	//� Amarrando a view com as box
	//��������������������������������������������������������������������������
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	oView:SetOwnerView("VIEW_ITENS", "INFERIOR")
	//������������������������������������������������������������������������Ŀ
	//� For�a o fechamento da janela na confirma��o
	//��������������������������������������������������������������������������
	oView:SetCloseOnOk({||.T.})
	//������������������������������������������������������������������������Ŀ
	//� Habilitando t�tulo
	//��������������������������������������������������������������������������
	oView:EnableTitleView("VIEW_CABEC")
	oView:EnableTitleView("VIEW_ITENS")
Return oView


