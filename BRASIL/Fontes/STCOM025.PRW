#Include "Protheus.ch"
#Include 'FWMVCDef.ch'
#Include "RWMake.ch"
#Include "TBIConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ STCOM025     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±º          ³ Tela desenvolvida em MVC Modelo 3                          º±±
±±º          ³ Obrigatório o uso de 2 tabelas                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFunções   ³ ModelDef: Contém a regra de negocio                        º±±
±±º          ³ ViewDef: Contém a interface                                º±±
±±º          ³ MenuDef: Opções do menu (aRotina)                          º±±
±±º          ³ IniPad: Inicializador Padrão                               º±±
±±º          ³ VldAcess: Validação de Acesso                              º±±
±±º          ³ VldTOK: Validação na Confirmação                           º±±
±±º          ³ GrvTOK: Validação após a Confirmação                       º±±
±±º          ³ StQuery1: Query 1 do relatório                             º±±
±±º          ³ STCOM011: Sequêncial do Item                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STCOM025()

	Local aArea1      := GetArea()
	Local aArea2      := SZK->( GetArea() )
	Local aArea3      := SAI->( GetArea() )
	Local aArea4      := SY1->( GetArea() )
	Local _cAlias1    := "SZK"
	Local _aGrupos    := {}
	Private cTitle    := "Pré Cadastro de Produto"
	Private _cCID     := "MOD3025"
	Private _cSSID    := "STCOM025"
	Private aRotina   := MenuDef(_cSSID)
	Private oBrowse
	Private _cGrprEng := GetMv("ST_PRECAD",,'000035/000083/000000/000216') //Ticket 20210705011633
	Private _cGrupo   := ''
	Private _lEng     := .F.
	Private _lComp    := .F.
	Private _lSolic   := .F.
	Private _cOpcEng  := '1/2'
	Private _cOpcSol  := '1/3'
	Private _cGeraPrd := '2/3'
	Private _cStatus  := ''

	//Validação de acesso a rotina
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
		_cGrupo   := _aGrupos[1][10][1]
	EndIf

	If _cGrupo $ _cGrprEng
		_lEng := .T.
	EndIf

	If !(_lEng)
		dbSelectArea("SY1")
		SY1->( dbSetOrder(3) )	// Y1_FILIAL + Y1_USER
		SY1->( dbGoTop() )
		If dbSeek(xFilial("SY1") + __cUserId)
			_lComp := .T.
		EndIf
		If !(_lComp)
			dbSelectArea("SAI")
			SAI->( dbSetOrder(2) )	// AI_FILIAL + AI_USER
			SAI->( dbGoTop() )
			If dbSeek(xFilial("SAI") + __cUserId)
				_lSolic := .T.
			EndIf
		EndIf
	EndIf

	If !(_lEng .Or. _lComp .Or. _lSolic)
		Help( ,, 'Help',, "Usuário sem permissão para a rotina de " + cTitle + ".";
			+ Chr(10) + Chr(13) +;
			"Ação não permitida.";
			+ Chr(10) + Chr(13) +;
			"Favor Verificar.",;
			1, 0 )
		Return
	EndIf

	// Construção básica de um Browse
	oBrowse := FWMBrowse():New()
	//Definição da tabela que será exibida na Browse utilizando o método SetAlias
	oBrowse:SetAlias(_cAlias1)
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	//Definição do título que será exibido como método SetDescription
	oBrowse:SetDescription(cTitle)
	//Definição do filtro ao browse
	//oBrowse:SetFilterDefault( "X5_TABELA == '21'" )
	//Definição das legendas do browse
	oBrowse:AddLegend("ZK_STATUS == '1'"  ,"RED"   ,"Pendente de Análise")
	oBrowse:AddLegend("ZK_STATUS == '2'"  ,"BLUE"  ,"Análise Engenharia")
	oBrowse:AddLegend("ZK_STATUS == '3'"  ,"YELLOW","Engenharia Solicita Informacao")
	oBrowse:AddLegend("ZK_STATUS == '4'"  ,"BLACK" ,"Rejeitado pela Engenharia")
	oBrowse:AddLegend("ZK_STATUS == '5'"  ,"GREEN" ,"Produto Gerado")
	//Desliga a exibição dos detalhes
	oBrowse:DisableDetails()
	//Ativação da classe
	oBrowse:Activate()

	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MenuDef      ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função MenuDef define as opções (Menu) que estarão       º±±
±±º          ³ disponíveis ao usuário                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MenuDef(_cSSID)

	Local _cProgram := Alltrim(Upper(FunName()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Opções padrões do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Opções Customizadas
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"          OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STCOM025" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.STCOM025" OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STCOM025" OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Gera Produto" ACTION "U_STCOM026('1')"  OPERATION 10 ACCESS 0
		ADD OPTION aRotina TITLE "Rejeitar"     ACTION "U_STCOM026('2')"  OPERATION 10 ACCESS 0
	EndIf

Return aRotina

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ModelDef     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função ModelDef define a regra de negócios propriamente  º±±
±±º          ³ dita onde são definidas:                                   º±±
±±º          ³ 1) Todas as entidades (tabelas) que farão parte do modelo  º±±
±±º          ³ de dados (Model)                                           º±±
±±º          ³ 2) Regras de dependência entre as entidades                º±±
±±º          ³ 3) Validações (de campos e aplicação)                      º±±
±±º          ³ 4) Persistência dos dados (gravação)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ModelDef()

	Local oModel
	Local oStr1      := FWFormStruct(1,'SZK')
	//Local _aRel      := {}

	oStr1:AddTrigger( ;
					"ZK_XGATCL" , ;// [01] Id do campo de origem
					"ZK_POSIPI" , ;// [02] Id do campo de destino
					{||.T.} , ;// [03] Bloco de codigo de validação da execução do gatilho
					{||GATINFOS(1,oModel)} )

	oStr1:AddTrigger( ;
					"ZK_UM" , ;// [01] Id do campo de origem
					"ZK_UMRES" , ;// [02] Id do campo de destino
					{||.T.} , ;// [03] Bloco de codigo de validação da execução do gatilho
					{||GATINFOS(2,oModel)} )

	oStr1:AddTrigger( ;
					"ZK_GRUPO" , ;// [01] Id do campo de origem
					"ZK_DESGRP" , ;// [02] Id do campo de destino
					{||.T.} , ;// [03] Bloco de codigo de validação da execução do gatilho
					{||GATINFOS(3,oModel)} )

	oStr1:AddTrigger( ;
					"ZK_TIPO" , ;// [01] Id do campo de origem
					"ZK_DESTIP" , ;// [02] Id do campo de destino
					{||.T.} , ;// [03] Bloco de codigo de validação da execução do gatilho
					{||GATINFOS(4,oModel)} )

	// Executo os gatilhos sem a utilização do arquivo SX7.
	//oStruCabec:AddTrigger( ;
	//						aAux1[1] , ;// [01] Id do campo de origem
	//						aAux1[2] , ;// [02] Id do campo de destino
	//						aAux1[3] , ;// [03] Bloco de codigo de validação da execução do gatilho
	//						aAux1[4] )  // [04] Bloco de codigo de execução do gatilho

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o objeto do Modelo de Dados
	//³ Irie usar uma função VldTOK que será acionada quando eu clicar no botão "Confirmar"
	//³ Irie usar uma função GrvTOK que será acionada após a confirmação do botão "Confirmar"
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)
	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )

	// Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	// oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )

	// Abaixo irei bloquear/liberar os campos para edição
	oStr1:SetProperty('ZK_DESC'    , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_XGATCL'  , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_CLAPROD' , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_UM'      , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_GRUPO'   , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_INFSOLI' , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })
	oStr1:SetProperty('ZK_XDESEXD' , MODEL_FIELD_WHEN,{|| IIf((_lComp .Or. _lSolic),.T.,.F.) })

	oStr1:SetProperty('ZK_DESC'    , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_COD'     , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_ORIGEM'  , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_APROPRI' , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_TIPO'    , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_INFOENG' , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })
	oStr1:SetProperty('ZK_VM_I'    , MODEL_FIELD_WHEN,{|| IIf((_lEng),.T.,.F.) })

	// Podemos usar as funções INCLUI ou ALTERA Ou usar a propriedade GetOperation que captura a operação que está sendo executada
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:addFields('SZK',,oStr1)

	// Fazendo o relacionamento entre o Cabeçalho e Item
	//aAdd(_aRel, {'ZI_FILIAL' , 'ZH_FILIAL'} )
	//aAdd(_aRel, {'ZI_APROVP' , 'ZH_APROVP'} )

	// Fazendo o relacionamento entre os compomentes do model
	//oModel:SetRelation('ITENS', _aRel, SZI->(IndexKey(2))) //IndexKey -> quero a ordenação e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordenação e depois filtrado

	// Fazendo a validação para não permitir linha duplicada
	//oModel:GetModel('ITENS'):SetUniqueLine({"ZI_CC"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}

	// Define a chave primaria utilizada pelo modelo
	//oModel:SetPrimaryKey({})
	oModel:SetPrimaryKey({ 'ZK_FILIAL', 'ZK_CODIGO' })

	// Adiciona a descricao do Componente do Modelo de Dados
	//oModel:SetDescription(_cTitulo)
	//oModel:SetDescription(_cCID)
	oModel:getModel('SZK'):SetDescription('SZK')
	//oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	//oModel:GetModel("ITENS"):SetDescription(_cItens)

	// Validação para inicializador padrão
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	// Validação da ativação do modelo
	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ViewDef      ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função ViewDef define como o será a interface e portanto º±±
±±º          ³ como o usuário interage com o modelo de dados (Model)      º±±
±±º          ³ recebendo os dados informados pelo usuário, fornecendo     º±±
±±º          ³ ao modelo de dados (definido na ModelDef) e apresentando   º±±
±±º          ³ o resultado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ViewDef()

	Local oView
	Local oModel := FWLoadModel(_cSSID)
	Local oStr1  := FWFormStruct(2, 'SZK')
	Local oStr2  := FWFormStruct(2, 'SZK')
	Local oStr3  := FWFormStruct(2, 'SZK')

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'SZK' )
	oView:AddField('FORM2' , oStr2,'SZK' )
	oView:AddField('FORM3' , oStr3,'SZK' )
	oView:CreateFolder( 'PASTA1')

	oView:AddSheet('PASTA1','ABA1','Dados da Solicitação')
	oView:AddSheet('PASTA1','ABA2','Dados do Pré Cadastro')
	oView:AddSheet('PASTA1','ABA3','Dados da Engenharia')

	oView:CreateHorizontalBox( 'BOXFORM1', 100, /*owner*/, /*lUsePixel*/, 'PASTA1', 'ABA1')
	oView:SetOwnerView('FORM1','BOXFORM1')

	oStr1:RemoveField( 'ZK_COD' )
	oStr1:RemoveField( 'ZK_ORIGEM' )
	oStr1:RemoveField( 'ZK_APROPRI' )
	oStr1:RemoveField( 'ZK_TIPO' )
	oStr1:RemoveField( 'ZK_GRUPO' )
	oStr1:RemoveField( 'ZK_UM' )
	oStr1:RemoveField( 'ZK_CLAPROD' )
	oStr1:RemoveField( 'ZK_XGATCL' )
	oStr1:RemoveField( 'ZK_DESC' )
	oStr1:RemoveField( 'ZK_POSIPI' )
	oStr1:RemoveField( 'ZK_UMRES' )
	oStr1:RemoveField( 'ZK_DESGRP' )
	oStr1:RemoveField( 'ZK_DESTIP' )
	oStr1:RemoveField( 'ZK_VM_I' )	// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021

	oStr2:RemoveField( 'ZK_HRSOLIC' )
	oStr2:RemoveField( 'ZK_DATASOL' )
	oStr2:RemoveField( 'ZK_NOMESOL' )
	oStr2:RemoveField( 'ZK_SOLICIT' )
	oStr2:RemoveField( 'ZK_CODIGO' )
	oStr2:RemoveField( 'ZK_STATUS' )
	oStr2:RemoveField( 'ZK_COD' )
	oStr2:RemoveField( 'ZK_ORIGEM' )
	oStr2:RemoveField( 'ZK_APROPRI' )
	oStr2:RemoveField( 'ZK_TIPO' )
	oStr2:RemoveField( 'ZK_USERENG' )
	oStr2:RemoveField( 'ZK_NOMEENG' )
	oStr2:RemoveField( 'ZK_INFSOLI' )
	oStr2:RemoveField( 'ZK_INFOENG' )
	oStr2:RemoveField( 'ZK_DATAENG' )
	oStr2:RemoveField( 'ZK_HORAENG' )
	oStr2:RemoveField( 'ZK_DATAFIM' )
	oStr2:RemoveField( 'ZK_HORAFIM' )
	oStr2:RemoveField( 'ZK_DESC' )
	oStr2:RemoveField( 'ZK_DESTIP' )
	oStr2:RemoveField( 'ZK_VM_I' )	// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021

	oStr3:RemoveField( 'ZK_STATUS' )
	oStr3:RemoveField( 'ZK_HRSOLIC' )
	oStr3:RemoveField( 'ZK_DATASOL' )
	oStr3:RemoveField( 'ZK_NOMESOL' )
	oStr3:RemoveField( 'ZK_SOLICIT' )
	oStr3:RemoveField( 'ZK_CODIGO' )
	oStr3:RemoveField( 'ZK_GRUPO' )
	oStr3:RemoveField( 'ZK_UM' )
	oStr3:RemoveField( 'ZK_CLAPROD' )
	oStr3:RemoveField( 'ZK_XGATCL' )
	oStr3:RemoveField( 'ZK_USERENG' )
	oStr3:RemoveField( 'ZK_NOMEENG' )
	oStr3:RemoveField( 'ZK_INFSOLI' )
	oStr3:RemoveField( 'ZK_INFOENG' )
	oStr3:RemoveField( 'ZK_DATAENG' )
	oStr3:RemoveField( 'ZK_HORAENG' )
	oStr3:RemoveField( 'ZK_DATAFIM' )
	oStr3:RemoveField( 'ZK_HORAFIM' )
	oStr3:RemoveField( 'ZK_POSIPI' )
	oStr3:RemoveField( 'ZK_UMRES' )
	oStr3:RemoveField( 'ZK_DESGRP' )

	//oView:SetViewProperty('FORM2', "SIZEMEMO", {ZK_XDESEXD , {9, 300}})
	oView:CreateHorizontalBox( 'BOXFORM2', 100, /*owner*/, /*lUsePixel*/, 'PASTA1', 'ABA2')
	oView:SetOwnerView('FORM2','BOXFORM2')
	oView:CreateHorizontalBox( 'BOXFORM3', 100, /*owner*/, /*lUsePixel*/, 'PASTA1', 'ABA3')
	oView:SetOwnerView('FORM3','BOXFORM3')

	oView:AddUserButton('Visualizar Info','BR_AMARELO',{|oModel|MemoInfo(oModel)})
	oView:AddUserButton('Gerar Código U' ,'BR_VERDE'  ,{|oView|STNEXTU(oView,'U',oModel)})
	oView:AddUserButton('Gerar Código E' ,'BR_AZUL'   ,{|oView|STNEXTU(oView,'E',oModel)})

	oView:EnableTitleView('FORM2' , 'Dados do Pré Cadastro' )
	oView:EnableTitleView('FORM1' , 'Dados da Solicitação' )
	oView:EnableTitleView('FORM3' , 'Dados da Engenharia' )

	// Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})

Return oView

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ IniPad       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função IniPad define os campos e conteúdos a serem       º±±
±±º          ³ exibidos como Inicializador Padrão                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function IniPad(oModel)

	Local nOp      := oModel:GetOperation()
	Local oModel1  := oModel:GetModel( "SZK" )
	Local cInfSoli := oModel1:GetValue('ZK_INFSOLI')
	Local cInfoEng := oModel1:GetValue('ZK_INFOENG')
	Local lIni     := .T.

	If nOp == 3 .Or. nOp == 4
		If (_lComp .Or. _lSolic)
			oModel:SetValue("SZK", "ZK_INFSOLI" , cInfSoli + Space(1))
		ElseIf _lEng
			oModel:SetValue("SZK", "ZK_INFOENG" , cInfoEng + Space(1))
		EndIf
	EndIf

Return lIni

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldAcess     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função VldAcess define as permissões de acesso aos botõesº±±
±±º          ³ da rotina                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldAcess(oModel)

	Local lAcess    := .T.
	//Local _aGrupos  := {}
	Local nOp       := oModel:GetOperation()
	Local _cValue   := SZK->ZK_STATUS

	_cStatus := ZKSTATUS(_cValue)

	// Validação de Grupo de Usuário para acesso aos botões da rotina - Inclusão
	If nOp == 3
		dbSelectArea("SY1")
		SY1->( dbSetOrder(3) )	// Y1_FILIAL + Y1_USER
		SY1->( dbGoTop() )
		If dbSeek(xFilial("SY1") + __cUserId)
			_lComp := .T.
		EndIf
		If !(_lComp)
			dbSelectArea("SAI")
			SAI->( dbSetOrder(2) )	// AI_FILIAL + AI_USER
			SAI->( dbGoTop() )
			If DbSeek(xFilial("SAI") + __cUserId)
				_lSolic := .T.
			EndIf
		EndIf
		If !(_lComp .Or. _lSolic)
			Help( ,, 'Help',, "Usuário da Engenharia sem permissão para a Inclusão na rotina de " + cTitle + ".";
				+ Chr(10) + Chr(13) +;
				"Ação não permitida.";
				+ Chr(10) + Chr(13) +;
				"Favor Verificar.",;
				1, 0 )
			lAcess := .F.
		EndIf
		// Validação de Grupo de Usuário para acesso aos botões da rotina - Alteração
	ElseIf nOp == 4
		If _lEng
			If !(SZK->ZK_STATUS $ _cOpcEng)
				Help( ,, 'Help',, "O " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " está com Status " + _cStatus + ".";
				+ Chr(10) + Chr(13) +;
				"Ação não permitida.";
				+CHR(10)+CHR(13)+;
				"Favor Verificar.",;
				1, 0 )
				lAcess := .F.
			ElseIF (SZK->ZK_USERENG <> __cUserID) .And. !Empty(SZK->ZK_USERENG)
				Help( ,, 'Help',, Alltrim(RetTitle("ZK_CODIGO")) +": " + SZK->ZK_CODIGO +" está em análise da Engenharia pelo usuário: " + USRRETNAME(SZK->ZK_USERENG) + ".";
					+ Chr(10) + Chr(13) +;
					"Ação não permitida.";
					+ Chr(10) + Chr(13) +;
					"Favor Verificar.",;
					1, 0 )
				lAcess := .F.
			ElseIF Empty(SZK->ZK_USERENG) .And. SZK->ZK_STATUS == '1'
				If ApMsgYesNo("Deseja assumir a análise do " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + "?";
					+ Chr(10) + Chr(13) +;
					"",;
					"Análise Engenharia")
					SZK->ZK_STATUS  := '2'
					SZK->ZK_USERENG := __cUserId
					SZK->ZK_NOMEENG := USRRETNAME(RETCODUSR())
					SZK->ZK_DATAENG := DDATABASE
					SZK->ZK_HORAENG := SUBSTR(TIME(),1,5)
					Help( ,, 'Help',, Alltrim(RetTitle("ZK_CODIGO")) +": " + SZK->ZK_CODIGO +" está em análise pela engenharia pelo usuário "+ SZK->ZK_NOMEENG +".",;
					1, 0 )
				Else
					Help( ,, 'Help',, Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " ficará pendente de análise por parte da Engenharia.",;
					1, 0 )
					lAcess := .F.
				EndIf
			EndIf
		ElseIf (_lComp .Or. _lSolic)
			If (SZK->ZK_SOLICIT <> __cUserID)
				Help( ,, 'Help',, "Você não é o Solicitante do " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + ".";
					+ Chr(10) + Chr(13) +;
					"Ação não permitida.";
					+ Chr(10) + Chr(13) +;
					"Favor Verificar.",;
					1, 0 )
				lAcess := .F.
			ElseIf !(SZK->ZK_STATUS $ _cOpcSol)
				Help( ,, 'Help',, "O " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " está com Status " + _cStatus + ".";
					+ Chr(10) + Chr(13) +;
					"Ação não permitida.";
					+ Chr(10) + Chr(13) +;
					"Favor Verificar.",;
					1, 0 )
				lAcess := .F.
			EndIf
		EndIf
	EndIf

Return lAcess

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldTOK       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função VldTOK é acionada no botão Confirmar e valida     º±±
±±º          ³ se as informações digitadas estão corretas                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldTOK( oModel )

	Local lVld        := .T.
	Local nOp         := oModel:GetOperation()
	Local oModelTOK   := oModel:GetModel( "SZK" )
	Local cInfSoli    := oModelTOK:GetValue('ZK_INFSOLI')
	Local cInfoEng    := oModelTOK:GetValue('ZK_INFOENG')
	Local cCodigo     := oModelTOK:GetValue('ZK_CODIGO ')
	Local _cValue     := oModelTOK:GetValue('ZK_STATUS ')
	Local cUsereng    := oModelTOK:GetValue('ZK_USERENG ')
	Local cSolicit    := oModelTOK:GetValue('ZK_SOLICIT ')
	Local oModelTOK2  := FWLoadView("STCOM025")
	Local _nK
	Local _cCAmpo     := ''
	Local _cFolder    := ''
	Local lSaida      := .F.
	Local cGetMotivo  := Space(100)
	//Local nOpcao      := 0
	Local _cMsg       := ''

	_cStatus := ZKSTATUS(_cValue)
	// Validação para que todos os campos da segunda aba sejam preenchidos pelo solicitante
	If (_lComp .Or. _lSolic)
		_cFolder := 'FORM2'
		For _nK := 1 To Len(oModelTOK2:GetListFields())
			If _cFolder == oModelTOK2:GetListFields()[_nK][1]
				_cCAmpo := oModelTOK2:GetListFields()[_nK][2]
				If Empty(Alltrim(oModelTOK:GetValue(_cCAmpo)))
					Help( ,, 'Help',, "O campo "+Alltrim(RetTitle(_cCAmpo)) + " não foi preenchido.";
						+ Chr(10) + Chr(13) +;
						"Esse é um campo obrigatório.";
						+ Chr(10) + Chr(13) +;
						"Favor realizar o preenchimento.",;
						1, 0 )
					lVld := .F.
					Exit
				EndIf
			EndIf
		Next _nK
		If lVld
			If nOp == 3
				Processa({||STMAIL(cUsername,DtoC(Date()),Time(),cCodigo,_cStatus,cSolicit,cUsereng,cInfSoli,cInfoEng),"Enviando E-mail." })
			ElseIf nOp == 4 .And. _cValue == '3'
				If ApMsgYesNo("Deseja retornar com informações a Engenharia referente ao " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + cCodigo + "?";
					+ Chr(10) + Chr(13) +;
					"",;
					"Retorno de Informações")
					Help( ,, 'Help',, "Deseja retornar com informações a Engenharia referente ao " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + cCodigo + "?",;
					1, 0 )
					Do While !lSaida
						Define msDialog oDxlg Title "Retorno de Informações" From 10,10 TO 250,400 Pixel
						@ 020,010 say "Preencha as Informações para a Engenharia:" COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 030,010 get cGetMotivo  size 165,08  Of oDxlg Pixel
						@ 090,085 Button "OK"    Size 28,12 Action Eval({||If(!Empty(Alltrim(cGetMotivo)), (lSaida := .T., oDxlg:End()),msgInfo("Informação não preenchida","Atenção"))}) OF oDxlg Pixel
						Activate Dialog oDxlg Centered
					EndDo
					_cMsg += "===================================" + Chr(13) + Chr(10)
					_cMsg += "Solicitante retorna com informações: " + Chr(13) + Chr(10)
					_cMsg += "Usuário: " + cUserName + Chr(13) + Chr(10)
					_cMsg += "Em: " + DtoC(dDatabase) + " " + Time() + Chr(13) + Chr(10)
					_cMsg += "Observação: " + cGetMotivo + Chr(13) + Chr(10)
					oModel:SetValue( 'SZK', 'ZK_STATUS' , '2' )
					oModel:SetValue( 'SZK', 'ZK_INFSOLI', cInfSoli + Chr(13) + Chr(10) + _cMsg )
					_cValue     := oModelTOK:GetValue('ZK_STATUS ')
					_cStatus    := ZKSTATUS(_cValue)
					Processa({||STMAIL(cUsername,DtoC(Date()),Time(),cCodigo,_cStatus,cSolicit,cUsereng,cInfSoli + Chr(13) + Chr(10) + _cMsg,cInfoEng),"Enviando E-mail." })
				EndIf
			EndIf
		EndIf
	ElseIf _lEng
		If ApMsgYesNo("Deseja solicitar informações ao Solicitante referente ao " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + cCodigo + "?";
			+ Chr(10) + Chr(13) +;
			"",;
			"Análise Engenharia")
			Help( ,, 'Help',, "Deseja solicitar informações ao Solicitante referente ao " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + cCodigo + "?",;
			1, 0 )
			Do While !lSaida
				Define msDialog oDxlg Title "Solicitar Informações" From 10,10 TO 250,400 Pixel
				@ 020,010 say "Preencha as Informações para o Solicitante:" COLOR CLR_HBLUE  Of oDxlg Pixel
				@ 030,010 get cGetMotivo  size 165,08  Of oDxlg Pixel
				@ 090,085 Button "OK"    Size 28,12 Action Eval({||If(!Empty(Alltrim(cGetMotivo)),(lSaida := .T., oDxlg:End()),msgInfo("Informação não preenchida","Atenção"))}) OF oDxlg Pixel
				Activate Dialog oDxlg Centered
			EndDo
			_cMsg += "===================================" + Chr(13) + Chr(10)
			_cMsg += "Engenharia solicita informações: " + Chr(13) + Chr(10)
			_cMsg += "Usuário: " + cUserName + Chr(13) + Chr(10)
			_cMsg += "Em: " + DtoC(dDatabase) + " " + Time() + Chr(13) + Chr(10)
			_cMsg += "Observação: " + cGetMotivo + Chr(13) + Chr(10)
			oModel:SetValue( 'SZK', 'ZK_STATUS' , '3' )
			oModel:SetValue( 'SZK', 'ZK_INFOENG', cInfoEng + Chr(13) + Chr(10) + _cMsg )
			_cValue     := oModelTOK:GetValue('ZK_STATUS ')
			_cStatus    := ZKSTATUS(_cValue)
			Processa({||STMAIL(cUsername,DtoC(Date()),Time(),cCodigo,_cStatus,cSolicit,cUsereng,cInfSoli,cInfoEng + Chr(13) + Chr(10) + _cMsg),"Enviando E-mail." })
		EndIf
		// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021 - Inicio
		If Empty(oModelTOK:GetValue('ZK_VM_I   '))
			Help( ,, 'Help',, "O campo " + Alltrim(RetTitle("ZK_VM_I")) + " não foi preenchido.";
					+ Chr(10) + Chr(13) +;
					"Esse é um campo obrigatório.";
					+ Chr(10) + Chr(13) +;
					"Favor realizar o preenchimento.",;
					1, 0 )
			lVld := .F.
		EndIf
		// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021 - Fim
	EndIf

Return lVld

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GrvTOK       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função GrvTOK é acionada após a confirmação do botão     º±±
±±º          ³ Confirmar                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GrvTOK( oModel )

	Local lGrv	:= .T.

	FWFormCommit( oModel )

Return lGrv

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ STCOM026     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função STCOM026 é utilizada para realizar as seguintes   º±±
±±º          ³ operações. Opções de _cOpc:                                º±±
±±º          ³ 1) Gera Produto                                            º±±
±±º          ³ 2) Rejeita                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STCOM026(_cOpc)

	Local aArea1        := GetArea()
	Local aArea2        := SZK->( GetArea() )
	Local aArea3        := SB1->( GetArea() )
	Local aAreaExec
	Local aRotAuto      := {}
	Local _lGeraProd    := .T.
	Local _cStatus      := ''
	Local oModelTOK2    := FWLoadView("STCOM025")
	Local _cValue       := SZK->ZK_STATUS
	Local _nK
	Local _cCAmpo       := ''
	Local _cFolder      := ''
	Local _cInfo        := ''
	Local lSaida        := .F.
	Local cGetMotivo    := Space(100)
	Local cMensag		:= ""
	Local _cMsg         := ''
	Private lMsErroAuto := .F.
	Private lMsHelpAuto	:= .F.
	Private _cDirRel    := "C:\ARQUIVOS_PROTHEUS"
	Private _cFile      :=''
	Private cStartPath 	:= '\arquivos\PRE_CADASTRO\'

	If _cOpc == '1'
		_cInfo := 'Gera Produto'
	ElseIf _cOpc == '2'
		_cInfo := 'Rejeitar'
	EndIf

	// Criação da Pasta de Log no Servidor
	If MakeDir (cStartPath) == 0
		MakeDir (cStartPath)
	EndIf

	// Criação da Pasta de Log na máquina Local do Usuário
	If MakeDir(_cDirRel) == 0
		MakeDir(_cDirRel)
	EndIf

	_cDirRel += (cStartPath)
	If MakeDir (_cDirRel) == 0
		MakeDir(_cDirRel)
	EndIf

	// Retorna o Status do Pré-Cadastro
	_cStatus := ZKSTATUS(_cValue)

	// Validação para a geração do Cadastro do Produto
	If _lEng
		_cFolder := 'FORM3'
		If !(SZK->ZK_STATUS $ _cOpcEng)
			Aviso(	_cInfo; //01 - cTitulo - Título da janela
					,"O " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " está com Status " + _cStatus + "."+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
			_lGeraProd := .F.
		ElseIf (SZK->ZK_USERENG <> __cUserID) .And. !Empty(SZK->ZK_USERENG)
			Aviso(	_cInfo; //01 - cTitulo - Título da janela
					,Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " está em análise da Engenharia pelo usuário: " + UsrRetName(SZK->ZK_USERENG) + "." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
			_lGeraProd := .F.
		ElseIf Empty(SZK->ZK_USERENG)
			Aviso(	_cInfo; //01 - cTitulo - Título da janela
					,Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " sem engenheiro vinculado para análise." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar."+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
			_lGeraProd := .F.
		ElseIf cEmpAnt $ "03x05" .And. Empty(SZK->ZK_XPAIS)
			_cCAmpo := "Pais etiquet"
			Aviso(	_cInfo; 
					,"O campo " + _cCAmpo + " não foi preenchido." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Esse é um campo obrigatório." + Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor realizar o preenchimento.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
			_lGeraProd := .F.
		ElseIf !Empty(SZK->ZK_USERENG) .And. (SZK->ZK_STATUS $ _cGeraPrd)
			// 1) Opção para a Geração do Código do Produto
			If _cOpc == '1'
				// Validação para que todos os campos da terceira aba sejam preenchidos pela engenharia
				For _nK := 1 To Len(oModelTOK2:GetListFields())
					If _cFolder == oModelTOK2:GetListFields()[_nK][1]
						_cCAmpo := oModelTOK2:GetListFields()[_nK][2]
						//_cValue := GetValue(oModelTOK2:GetListFields()[_nK][2])
						//If Empty(Alltrim(oModelTOK:GetValue(_cCAmpo)))
						If Empty(Alltrim(&(_cCAmpo)))
							Aviso(	_cInfo; //01 - cTitulo - Título da janela
									,"O campo " + Alltrim(RetTitle(_cCAmpo)) + " não foi preenchido." + Chr(10) + Chr(13) +;
									Chr(10) + Chr(13) +;
									"Esse é um campo obrigatório." + Chr(10) + Chr(13) +;
									Chr(10) + Chr(13) +;
									"Favor realizar o preenchimento.",; //02 - cMsg - Texto a ser apresentado na janela.
									{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
									,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
									,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
									,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
									,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
									,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
									,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
									,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
									)
							_lGeraProd := .F.
							Exit
						EndIf
					EndIf
				Next _nK
				If _lGeraProd
					If ApMsgYesNo("Deseja realizar a Geração do Produto de código " + Alltrim(SZK->ZK_COD) + " referente ao " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + (SZK->ZK_CODIGO) + "?" ;
						+ Chr(10) + Chr(13) +;
						"",;
						_cInfo)
						aRotAuto := {	{'B1_COD',		SZK->ZK_COD,		Nil},;
										{'B1_DESC',		SZK->ZK_DESC,		Nil},;
										{'B1_CLAPROD',	SZK->ZK_CLAPROD,	Nil},;
										{'B1_UM',		SZK->ZK_UM,			Nil},;
										{'B1_GRUPO',	SZK->ZK_GRUPO,		Nil},;
										{'B1_ORIGEM',	SZK->ZK_ORIGEM,		Nil},;
										{'B1_APROPRI',	SZK->ZK_APROPRI,	Nil},;
										{'B1_TIPO',		SZK->ZK_TIPO,		Nil},;
										{'B1_XGATCL',	SZK->ZK_XGATCL,		Nil},;
										{'B1_XDESEXD',	SZK->ZK_XDESEXD,	Nil} }						
						//{'B1_XGATCL',	SZK->ZK_XGATCL ,Nil},; --> Zeca, devolver 19/02/2021
						//{'B1_XPAIS'   ,SZK->ZK_XPAIS  ,Nil}}
						aAreaExec := GetArea()
						//cAliasExec := Alias()
						dbSelectArea("SB1")
						SB1->( dbSetOrder(1) )
						SB1->( dbGoTop() )
						If !SB1->( dbSeek(xFilial("SB1") + SZK->ZK_COD) )
							Begin Transaction
								MSExecAuto({|x,y| MATA010(x,y)},aRotAuto,3)
								If lMsErroAuto	
									MsgStop("Erro na gravação.")	
									MostraErro()
									_lGeraProd := .F.
								Else
									If SB1->( dbSeek(xFilial("SB1") + SZK->ZK_COD) )
										SB1->(RecLock("SB1",.F.))
										SB1->B1_XPAIS 	:= SZK->ZK_XPAIS
										SB1->B1_XGATCL	:= SZK->ZK_XGATCL
										// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021 - Inicio
										If !Empty(SB1->B1_DESC_I)
											cMensag := CRLF + Alltrim(SZK->ZK_VM_I)
										Else
											cMensag := SZK->ZK_VM_I
										EndIf
										MSMM(SB1->B1_DESC_I,,,cMensag,1,,,"SB1", "B1_DESC_I",,.T.)
										// Ticket 20210610009797 - Incluir novo campo obrigatório da SB1 na rotina de Pré Cadastro - Eduardo Pereira Sigamat - 29.06.2021 - Fim
										SB1->( MsUnLock() )
									Else
										MsgStop("Ocorreu algum erro na gravação.")
									EndIf
								EndIf
							End Transaction
						EndIf
						RestArea(aAreaExec)
						If _lGeraProd
							dbSelectArea("SB1")
							SB1->( dbSetOrder(1) )
							SB1->( dbGoTop() )
							SB1->( dbSeek(xFilial("SB1") + SZK->ZK_COD) )
							RecLock("SZK",.F.)
							SZK->ZK_STATUS := '5'
							SZK->ZK_DATAFIM := dDatabase
							SZK->ZK_HORAFIM := Substr(Time(),1,5)
							SZK->( MsUnLock() )
							_cValue   := SZK->ZK_STATUS
							_cStatus  := ZKSTATUS(_cValue)
							Processa({||STMAIL(cUsername,DtoC(Date()),Time(),SZK->ZK_CODIGO,_cStatus,SZK->ZK_SOLICIT,SZK->ZK_USERENG,SZK->ZK_INFSOLI,SZK->ZK_INFOENG),"Enviando E-mail." })							
							Aviso(	_cInfo; //01 - cTitulo - Título da janela
									,"Produto de código " + Alltrim(SZK->ZK_COD) + " gerado com sucesso." + Chr(10) + Chr(13) +;
									Chr(10) + Chr(13) +;
									"O mesmo já está disponível para utilização." + Chr(10) + Chr(13) +;
									Chr(10) + Chr(13) +;
									"Acesse o cadastro de produtos para visualizá-lo.",; //02 - cMsg - Texto a ser apresentado na janela.
									{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
									,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
									,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
									,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
									,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
									,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
									,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
									,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
									)
							If MsgYesNo("Deseja copiar o produto para a empresa Manaus?")
								DbSelectArea("SB1")
								U_STCOPIAB1() //Copiar produto para AM
							EndIf
						EndIf
					Else
						Aviso(_cInfo; //01 - cTitulo - Título da janela
							,Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " ficará pendente de análise por parte da Engenharia." + Chr(10) + Chr(13) +;
							"",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
						_lGeraProd := .F.
					EndIf
				EndIf
				// 2) Opção para a Rejeição do Pré-Cadastro
			ElseIf _cOpc == '2'
				If ApMsgYesNo("Deseja realizar a Rejeição referente ao "+Alltrim(RetTitle("ZK_CODIGO")) +": " + (SZK->ZK_CODIGO) +"?" + Chr(10) + Chr(13) + "", _cInfo)
					Do While !lSaida
						Define msDialog oDxlg Title "Informar a Rejeição" From 10,10 TO 250,400 Pixel
						@ 020,010 say "Preencha as Informações referente a Rejeição:" COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 030,010 get cGetMotivo  size 165,08  Of oDxlg Pixel
						@ 090,085 Button "OK"    Size 28,12 Action Eval({||If(!Empty(Alltrim(cGetMotivo)),(lSaida := .T.,oDxlg:End()),msgInfo("Informação da Rejeição não preenchida","Atenção"))}) OF oDxlg Pixel
						Activate Dialog oDxlg Centered
					EndDo
					_cMsg += "===================================" + Chr(13) + Chr(10)
					_cMsg += "Engenharia rejeitou a solicitação: " + Chr(13) + Chr(10)
					_cMsg += "Usuário: " + cUserName + Chr(13) + Chr(10)
					_cMsg += "Em: " + DtoC(dDatabase) + " " + Time() + Chr(13) + Chr(10)
					_cMsg += "Observação: " + cGetMotivo + Chr(13) + Chr(10)
					SZK->(RecLock("SZK",.F.))
					SZK->ZK_STATUS := '4'
					SZK->ZK_DATAFIM := dDatabase
					SZK->ZK_HORAFIM := Substr(Time(),1,5)
					SZK->ZK_INFOENG := SZK->ZK_INFOENG + Chr(13) + Chr(10) + _cMsg
					SZK->( MsUnLock() )
					_cValue   := SZK->ZK_STATUS
					_cStatus  := ZKSTATUS(_cValue)
					Processa({||STMAIL(cUsername,DtoC(Date()),Time(),SZK->ZK_CODIGO,_cStatus,SZK->ZK_SOLICIT,SZK->ZK_USERENG,SZK->ZK_INFSOLI,SZK->ZK_INFOENG),"Enviando E-mail." })
					Aviso(	_cInfo; //01 - cTitulo - Título da janela
							, + Alltrim(RetTitle("ZK_CODIGO")) + ": " + (SZK->ZK_CODIGO) + " rejeitado com sucesso." + Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Um e-mail foi enviado ao solicitante notificando o mesmo.",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
				Else
					Aviso(	_cInfo; //01 - cTitulo - Título da janela
							,Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " ficará pendente de análise por parte da Engenharia." + Chr(10) + Chr(13) +;
							"",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
					_lGeraProd := .F.
				EndIf
			EndIf
		Else
			Aviso(	_cInfo; //01 - cTitulo - Título da janela
					,Alltrim(RetTitle("ZK_CODIGO")) + ": " + SZK->ZK_CODIGO + " ficará pendente de análise por parte da Engenharia." + Chr(10) + Chr(13) +;
					"",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
			_lGeraProd := .F.
		EndIf
	Else
		Aviso(	_cInfo; //01 - cTitulo - Título da janela
				,"Usuário sem acesso a rotina de " + _cInfo + "." + Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Favor Verificar." + Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
		_lGeraProd := .F.
	EndIf

	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)

Return _lGeraProd

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ZKSTATUS     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função ZKSTATUS é utilizada para retornar a descrição do º±±
±±º          ³ Status do Pré Cadastro                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ZKSTATUS(_cValue)

	Local _cStatus := ''

	If _cValue == '1'
		_cStatus := 'Pendente de Análise'
	ElseIf _cValue == '2'
		_cStatus := 'Análise Engenharia'
	ElseIf _cValue == '3'
		_cStatus := 'Engenharia Solicita Informação'
	ElseIf _cValue == '4'
		_cStatus := 'Rejeitado pela Engenharia'
	ElseIf _cValue == '5'
		_cStatus := 'Produto Gerado'
	EndIf

Return _cStatus

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ STMAIL       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função STMAIL é utilizada para realizar o envio do e-mailº±±
±±º          ³ de acordo com cada Status do Pré Cadastro                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function STMAIL(_cName,_cDat,_cHora,cCodigo,_cStatus,_cUserPara,_cUserCopia,cInfSoli,cInfoEng)

	Local _cAssunto := ''
	Local _cMsg     := ''
	Local _cEmail   := ''
	Local _cCopia   := ''
	Local cMailCop := SuperGetMV("ST_MPRECA",.F.,"fabio.barros@steck.com.br;felipe.silva@steck.com.br;felipe.falconi@steck.com.br")

	If Empty(Alltrim(_cUserCopia))
//ticket 20220713013853
//		_cCopia  := "marlon.banchini@steck.com.br;gabriel.alcantara@steck.com.br" //Ticket 20200727004728
		_cCopia  := cMailCop
	Else
		_cCopia  := UsrRetMail(_cUserCopia)
	EndIf

	_cEmail  := UsrRetMail(_cUserPara)

	_cAssunto := cTitle + " - " + Alltrim(RetTitle("ZK_CODIGO")) + ": " + cCodigo + " está com Status: " + _cStatus
	_cMsg += '<b>Solicitante: </b>'
	_cMsg += '<pre>' + UsrRetName(Alltrim(_cUserPara)) + '</pre>'
	_cMsg += '<b>Descrição Solicitante: </b>'
	_cMsg += '<pre>' + Alltrim(cInfSoli) + '</pre>'
	_cMsg += '<pre>' + Replicate(" ",100) + '</pre>'
	_cMsg += '<pre>' + Replicate("=",100) + '</pre>'
	_cMsg += '<pre>' + Replicate("=",100) + '</pre>'

	_cMsg += '<b>Engenharia: </b>'
	_cMsg += '<pre>' + UsrRetName(Alltrim(_cUserCopia)) + '</pre>'
	_cMsg += '<b>Descrição Engenharia: </b>'
	_cMsg += '<pre>' + Alltrim(cInfoEng) + '</pre>'
	_cMsg += '<pre>' + Replicate(" ",100) + '</pre>'
	_cMsg += '<pre>' + Replicate("=",100) + '</pre>'
	_cMsg += '<pre>' + Replicate("=",100) + '</pre>'

	If AllTrim(Upper(_cStatus)) == "PRODUTO GERADO"
		_cMsg += '<b>Código: </b>'
		_cMsg += '<pre>' + SB1->B1_COD + '</pre>'
		_cMsg += '<b>Descrição: </b>'
		_cMsg += '<pre>' + SB1->B1_DESC + '</pre>'
		_cMsg += '<b>Descrição extendida: </b>'
		_cMsg += '<pre>' + SB1->B1_XDESEXD + '</pre>'
		_cMsg += '<pre>' + Replicate(" ",100) + '</pre>'
		_cMsg += '<pre>' + Replicate("=",100) + '</pre>'
		_cMsg += '<pre>' + Replicate("=",100) + '</pre>'
	EndIf

	If !(U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg)) //,cAttach) )
		Aviso(	"E-mail não enviado"; //01 - cTitulo - Título da janela
				,"Favor verificar se os e-mails abaixo são válidos." + Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"E-mail Para: " + _cEmail +;
				Chr(10) + Chr(13) +;
				"E-mail Cópia: "+_cCopia+;
				Chr(10) + Chr(13) +;
				"O E-mail não será enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
	EndIf

Return

Static Function MemoInfo(oModel)

	Local lMemo       := .T.
	Local oModelTOK   := oModel:GetModel( "SZK" )
	Local cInfSoli    := oModelTOK:GetValue('ZK_INFSOLI')
	Local cInfoEng    := oModelTOK:GetValue('ZK_INFOENG')
	Local cInfoExd    := oModelTOK:GetValue('ZK_XDESEXD')

	Aviso(	RetTitle("ZK_INFSOLI");	//01 - cTitulo - Título da janela
			,cInfSoli,;       		//02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};           		//03 - aBotoes - Array com as opções dos botões.
			,3;               		//04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                		//05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                		//06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                		//07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;             		//08 - lEdit - Determina se permite a edição do campo memo
			,;                		//09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                		//10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)

	Aviso(	RetTitle("ZK_INFOENG");	//01 - cTitulo - Título da janela
			,cInfoEng,;             //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                 //03 - aBotoes - Array com as opções dos botões.
			,3;                     //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                      //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                      //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                      //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                   //08 - lEdit - Determina se permite a edição do campo memo
			,;                      //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                      //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)

	Aviso(	RetTitle("ZK_XDESEXD");	//01 - cTitulo - Título da janela
			,cInfoExd,;             //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                 //03 - aBotoes - Array com as opções dos botões.
			,3;                     //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                      //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                      //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                      //07 - cBitmap - Nome do bitmap a ser apresentado
			,.T.;                   //08 - lEdit - Determina se permite a edição do campo memo
			,;                      //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                      //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)

Return lMemo

Static Function STNEXTU(oView,_cCod,oModel)

	Local cPerg        := "STNEXTU"
	Local cTime        := Time()
	Local cHora        := Substr(cTime, 1, 2)
	Local cMinutos     := Substr(cTime, 4, 2)
	Local cSegundos    := Substr(cTime, 7, 2)
	Local cAliasLif    := cPerg + cHora + cMinutos + cSegundos
	Local cQuery       := ""
	Local cAlias       := cAliasLif
	Local aCods        := {}
	Local cNextCod     := ""
	Local nNextNum     := 0
	//Local lMemo        := .T.
	Local nOp          := oModel:GetOperation()

	If nOp == 4
		If _lEng
			cQuery	:= " SELECT * FROM (  " //Ticket 20200615002993 - Everson Santana - 15.06.2020
			cQuery	+= " SELECT SUBSTR(B1_COD,2,99999999999999999999999999) SEQ " // CHAMADO 005592 - Robson Mazzarotto
			//cQuery	+= " FROM "+RetSqlName("SB1")+" B1 "
			cQuery	+= " FROM  SB1010 SB1 "
			cQuery 	+= " WHERE SB1.D_E_L_E_T_ = ' ' "
			cQuery 	+= " 	AND B1_COD LIKE 'U%' "
			cQuery 	+= " 	AND B1_MSBLQL <> 1 "
			//cQuery	+= " ORDER BY B1_COD " Ticket 20200615002993 - Everson Santana - 15.06.2020
			cQuery += "UNION ALL "
			cQuery	+= " SELECT SUBSTR(B1_COD,2,99999999999999999999999999) SEQ "
			//cQuery	+= " FROM "+RetSqlName("SB1")+" B1 "
			cQuery	+= " FROM  SB1030 SB13 "
			cQuery 	+= " WHERE SB13.D_E_L_E_T_ = ' ' "
			cQuery 	+= " 	AND B1_COD LIKE 'U%' "
			cQuery 	+= " 	AND B1_MSBLQL <> 1 "
			//cQuery	+= " ORDER BY B1_COD " Ticket 20200615002993 - Everson Santana - 15.06.2020
			cQuery 	+= " ) TMP " //Ticket 20200615002993 - Everson Santana - 15.06.2020
			cQuery 	+= "  ORDER BY TMP.SEQ " // Ticket 20200615002993 - Everson Santana - 15.06.2020
			If !Empty(Select(cAlias))
				debSelectArea(cAlias)
				(cAlias)->( dbCloseArea() )
			EndIf
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
			dbSelectArea(cAlias)
			(cAlias)->( dbGoTop() )
			While (cAlias)->( !Eof() )
				aAdd(aCods,{Val((cAlias)->SEQ)})
				(cAlias)->( dbSkip() )
			EndDo
			aSort(aCods,,,{|x,y| (x[1]) < (y[1])})
			nNextNum	:= (aCods[len(aCods)][1])+1
			cNextCod	:= _cCod + CValToChar(nNextNum)
			oView:GetModel():GetModel("SZK"):SetValue("ZK_COD" , cNextCod)
		Else
			Help( ,, 'Help',, "Usuário sem permissão para a rotina de 'Gerar Código " + _cCod + "'." + Chr(10) + Chr(13) + "Ação não permitida." + Chr(10) + Chr(13) + "Favor Verificar.", 1, 0 )
			Return
		EndIf
	Else
		Help( ,, 'Help',, "Função disponível apenas para a opção 'Alterar'." + Chr(10) + Chr(13) + "Ação não permitida." + Chr(10) + Chr(13) + "Favor Verificar.", 1, 0 )
		Return
	EndIf

Return .T.

User Function STGERSB1(_cEmp,_cFil,aRotAuto)

	Local _aRet 		:= {}
	Private lMsErroAuto := .F.
	Private nOpc 		:= 3

	RpcSetType( 3 )
	RpcSetEnv( _cEmp, _cFil,,,"FAT")

	MSExecAuto({|x,y| MATA010(x,y)},aRotAuto,3)

	If lMsErroAuto
		aAdd(_aRet,.T.)
		aAdd(_aRet,MostraErro())
	Else
		aAdd(_aRet,.F.)
		aAdd(_aRet,"")
	EndIf

Return _aRet

Static Function GATINFOS(_nTipo,oModel)

	Local _cRet := ""
	Local _cGet := ""	//oModel:GetValue("SZK","ZK_XGATCL")

	Do Case
		Case _nTipo == 1
			_cGet := oModel:GetValue("SZK","ZK_XGATCL")
			dbSelectArea("SZ4")
			SZ4->( dbSetOrder(1) )
			If SZ4->( dbSeek(xFilial("SZ4") + _cGet) )
				_cRet := SZ4->Z4_POSIPI
			EndIf
		Case _nTipo == 2
			_cGet := oModel:GetValue("SZK","ZK_UM")
			dbSelectArea("SAH")
			SAH->( dbSetOrder(1) )
			If SAH->( dbSeek(xFilial("SAH") + _cGet) )
				_cRet := SAH->AH_UMRES
			EndIf
		Case _nTipo == 3
			_cGet := oModel:GetValue("SZK","ZK_GRUPO")
			dbSelectArea("SBM")
			SBM->( dbSetOrder(1) )
			If SBM->( dbSeek(xFilial("SBM") + _cGet) )
				_cRet := SBM->BM_DESC
			EndIf
		Case _nTipo == 4
			_cGet := oModel:GetValue("SZK","ZK_TIPO")
			dbSelectArea("SX5")
			SX5->( dbSetOrder(1) )
			If SX5->( dbSeek(xFilial("SBM") + "02" + _cGet) )
				_cRet := SX5->X5_DESCRI
			EndIf
	EndCase

Return _cRet
