#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STMVC2             | Autor | GIOVANI.ZAGO             | Data | 26/04/2017 |
|=====================================================================================|
|Sintaxe   | STMVC2                                                                    |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STMVC2()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	Private _lPartic := .T.

	DbSelectArea("PH1")
	PH1->(DbSetOrder(3))
	If 	!(__cUserId $ _UserMvc)
		PH1->(dbSetFilter({|| PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId },'PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId'))
	EndIF

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("PH1")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STMVC2")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("AVALIA��O")   	// Descrição do browse

	If 	!(__cUserId $ _UserMvc)
		oBrowse:SetFilterDefault( 'PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId' )
	EndIF

	oBrowse:SetUseCursor(.F.)

	oBrowse:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STMVC2" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Avaliar"    ACTION "VIEWDEF.STMVC2" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STMVC2" OPERATION 5 ACCESS 0 //"Excluir"
	If __cUserId $ _UserMvc
		ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STMVC2" OPERATION 3 ACCESS 0 //"Incluir"
	EndIf

	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STMVC2"   OPERATION 8 ACCESS 0 //"Imprimir"

Return aRotina

User Function GatMvc()
	Local oModelPai  := FWMODELACTIVE()
	Local oModel1PH  := oModelPai:GetModel('PH1')
	Local oModel3PH  := oModelPai:GetModel('PH3')

	oModel3PH:SetValue('PH3_ANO' 	,FwFldGet('PH1_ANO') )
	oModel3PH:SetValue('PH3_USERID' ,FwFldGet('PH1_USER') )

	If !(Empty(Alltrim(FwFldGet('PH1_USER'))))
		oModel1PH:SetValue('PH1_ADMISS' 	,  Posicione("SRA",1,FwFldGet('PH1_USER') ,"RA_ADMISSA",'USERCFG')) 
		oModel1PH:SetValue('PH1_SETOR' 	, Alltrim(Posicione("CTT",1,xFilial("CTT")+ Alltrim(Posicione("SRA",1,FwFldGet('PH1_USER') ,"RA_CC",'USERCFG')),"CTT_DESC01"))  )
		oModel1PH:SetValue('PH1_CARGO' 	, Alltrim(Posicione("SQB",1,xFilial("SQB")+ Alltrim(Posicione("SRA",1,FwFldGet('PH1_USER') ,"RA_DEPTO",'USERCFG')),"QB_DESCRIC")))   
	EndIf    

Return (.F.)

User Function LIDMVC()
	Local _r := ' '
Return((PH1->PH1_LID = 'Sim'))

User Function MvcPos(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := FWMODELACTIVE()
	Local oModel1PH  := oModelPai:GetModel('PH1')
	Local oModel3PH  := oModelPai:GetModel('PH3')

	If nOp == MODEL_OPERATION_INSERT .OR. nOp == MODEL_OPERATION_UPDATE

		oModel3PH:SetValue('PH3_ANO' 	,FwFldGet('PH1_ANO') )
		oModel3PH:SetValue('PH3_USERID' ,FwFldGet('PH1_USER') )

	EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Administrator

@since 13/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'PH1')
	Local oStr2:= FWFormStruct(2, 'PH3')

	oStr1:AddGroup('PH1', 'Participante', '1', 2)

	oStr1:SetProperty('PH1_ANO'	  , MVC_VIEW_GROUP_NUMBER, 'PH1')
	oStr1:SetProperty('PH1_USER'  , MVC_VIEW_GROUP_NUMBER, 'PH1')
	oStr1:SetProperty('PH1_NOME'  , MVC_VIEW_GROUP_NUMBER, 'PH1')

	oStr1:AddGroup('PHA', 'Cargo', '2', 2)

	oStr1:SetProperty('PH1_SETOR'	, MVC_VIEW_GROUP_NUMBER, 'PHA')
	oStr1:SetProperty('PH1_ADMISS'  , MVC_VIEW_GROUP_NUMBER, 'PHA')
	oStr1:SetProperty('PH1_CARGO'   , MVC_VIEW_GROUP_NUMBER, 'PHA')


	oStr1:AddGroup('PHB', 'Liderança', '3', 2)

	oStr1:SetProperty('PH1_SUP'  	, MVC_VIEW_GROUP_NUMBER, 'PHB')
	oStr1:SetProperty('PH1_LID'      , MVC_VIEW_GROUP_NUMBER, 'PHB')

	oStr2:AddGroup('GrpPar', 'Participante', '7', 2)

	oStr2:SetProperty('PH3_COME02', MVC_VIEW_GROUP_NUMBER, 'GrpPar')
	oStr2:SetProperty('PH3_AVPA'  , MVC_VIEW_GROUP_NUMBER, 'GrpPar')

	oStr2:AddGroup('GrpAva', 'Avaliador', '7', 2)

	oStr2:SetProperty('PH3_COME01', MVC_VIEW_GROUP_NUMBER, 'GrpAva')
	oStr2:SetProperty('PH3_AVAV'  , MVC_VIEW_GROUP_NUMBER, 'GrpAva')
	oStr2:SetProperty('PH3_AVPER'  , MVC_VIEW_GROUP_NUMBER, 'GrpAva')


	oStr2:AddGroup('GrpPat', 'Participante' , '6', 2)
	oStr2:AddGroup('GrpAvt', 'Avaliador'	, '6', 2)

	If 	U_LIDMVC()
		oStr2:SetProperty('PH3_AC1' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC2' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC3' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC4' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC12' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC5' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		//oStr2:SetProperty('PH3_AC6' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')

		oStr2:SetProperty('PH3_PC1' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC2' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC3' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC4' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC5' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC12' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')

		oStr2:RemoveField( 'PH3_AC7' )
		oStr2:RemoveField( 'PH3_AC8' )
		oStr2:RemoveField( 'PH3_AC9' )
		oStr2:RemoveField( 'PH3_AC10')
		oStr2:RemoveField( 'PH3_AC11')
		//oStr2:RemoveField( 'PH3_AC12')

		oStr2:RemoveField( 'PH3_PC7' )
		oStr2:RemoveField( 'PH3_PC8' )
		oStr2:RemoveField( 'PH3_PC9' )
		oStr2:RemoveField( 'PH3_PC10')
		oStr2:RemoveField( 'PH3_PC11')
		//oStr2:RemoveField( 'PH3_PC12')


	Else
		oStr2:SetProperty('PH3_AC7' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC8' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC9' , MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC10', MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		oStr2:SetProperty('PH3_AC11', MVC_VIEW_GROUP_NUMBER, 'GrpPat')
		//oStr2:SetProperty('PH3_AC12', MVC_VIEW_GROUP_NUMBER, 'GrpPat')

		oStr2:SetProperty('PH3_PC7' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC8' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC9' , MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC10', MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		oStr2:SetProperty('PH3_PC11', MVC_VIEW_GROUP_NUMBER, 'GrpAvt')
		//oStr2:SetProperty('PH3_PC12', MVC_VIEW_GROUP_NUMBER, 'GrpAvt')

		oStr2:RemoveField( 'PH3_AC1' )
		oStr2:RemoveField( 'PH3_AC2' )
		oStr2:RemoveField( 'PH3_AC3' )
		oStr2:RemoveField( 'PH3_AC4' )
		oStr2:RemoveField( 'PH3_AC12' )
		oStr2:RemoveField( 'PH3_AC5' )
		//	oStr2:RemoveField( 'PH3_AC6' )

		oStr2:RemoveField( 'PH3_PC1' )
		oStr2:RemoveField( 'PH3_PC2' )
		oStr2:RemoveField( 'PH3_PC3' )
		oStr2:RemoveField( 'PH3_PC4' )
		oStr2:RemoveField( 'PH3_PC5' )
		//	oStr2:RemoveField( 'PH3_PC6' )
		oStr2:RemoveField( 'PH3_PC12' )

	EndIf

	oStr2:AddGroup('META5', 'META 05', '5', 2)

	oStr2:SetProperty('PH3_M5'    , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_T5'    , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_MI5'   , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_MA5'   , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_OBSA5' , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_OBSP5' , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_A5' 	  , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_B5' 	  , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_B5PER' , MVC_VIEW_GROUP_NUMBER, 'META5')
	oStr2:SetProperty('PH3_C5' 	  , MVC_VIEW_GROUP_NUMBER, 'META5')

	oStr2:AddGroup('META4', 'META 04', '4', 2)

	oStr2:SetProperty('PH3_M4'    , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_T4'    , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_MI4'   , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_MA4'   , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_OBSA4' , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_OBSP4' , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_A4' 	  , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_B4' 	  , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_B4PER' , MVC_VIEW_GROUP_NUMBER, 'META4')
	oStr2:SetProperty('PH3_C4' 	  , MVC_VIEW_GROUP_NUMBER, 'META4')

	oStr2:AddGroup('META3', 'META 03', '3', 2)

	oStr2:SetProperty('PH3_M3'    , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_T3'    , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_MI3'   , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_MA3'   , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_OBSA3' , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_OBSP3' , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_A3' 	  , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_B3' 	  , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_B3PER' , MVC_VIEW_GROUP_NUMBER, 'META3')
	oStr2:SetProperty('PH3_C3' 	  , MVC_VIEW_GROUP_NUMBER, 'META3')

	oStr2:AddGroup('META2', 'META 02', '2', 2)

	oStr2:SetProperty('PH3_M2'    , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_T2'    , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_MI2'   , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_MA2'   , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_OBSA2' , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_OBSP2' , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_A2' 	  , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_B2' 	  , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_B2PER' , MVC_VIEW_GROUP_NUMBER, 'META2')
	oStr2:SetProperty('PH3_C2' 	  , MVC_VIEW_GROUP_NUMBER, 'META2')

	oStr2:AddGroup('META1', 'META 01', '1', 2)

	oStr2:SetProperty('PH3_M1'    , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_T1'    , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_MI1'   , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_MA1'   , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_OBSA1' , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_OBSP1' , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_A1' 	  , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_B1' 	  , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_B1PER' , MVC_VIEW_GROUP_NUMBER, 'META1')
	oStr2:SetProperty('PH3_C1' 	  , MVC_VIEW_GROUP_NUMBER, 'META1')


	oStr2:SetProperty( "PH3_DESV", MVC_VIEW_TITULO, 'Descreva aqui um breve resumo da sua conversa referente ao desenvolvimento da carreira do colaborador.' )

	oStr2:SetProperty( "PH3_C1", MVC_VIEW_TITULO, 'Calibra��o Realizada?' )
	oStr2:SetProperty( "PH3_C2", MVC_VIEW_TITULO, 'Calibra��o Realizada?' )
	oStr2:SetProperty( "PH3_C3", MVC_VIEW_TITULO, 'Calibra��o Realizada?' )
	oStr2:SetProperty( "PH3_C4", MVC_VIEW_TITULO, 'Calibra��o Realizada?' )
	oStr2:SetProperty( "PH3_C5", MVC_VIEW_TITULO, 'Calibra��o Realizada?' )
	//oStr2:SetProperty( "PH3_PDI01", MVC_VIEW_TITULO, 'Digite Seu Nome Completo' )
	//oStr2:SetProperty( "PH3_PDI02", MVC_VIEW_TITULO, 'Qual seu departamento' )
	oStr2:SetProperty( "PH3_PDI03", MVC_VIEW_TITULO, 'Qual o pr�ximo cargo almejado na sua carreira?' )
	oStr2:SetProperty( "PH3_PDI04", MVC_VIEW_TITULO, 'Voc� possui interesse e disponibilidade para ser transferido (a) para outra cidade/estado ou pa�s?' )
	oStr2:SetProperty( "PH3_PDI05", MVC_VIEW_TITULO, 'Quais s�o seus pontos fortes?'+CR+' [considere pontos fortes, aqueles que te fortalecem para assumir a posi��o almejada].' )
	oStr2:SetProperty( "PH3_PDI06", MVC_VIEW_TITULO, 'Quais s�o seus pontos a desenvolver?'+CR+' [considere os pontos a desenvolver que s�o essenciais para assumir a posi��o almejada].' )

	oStr2:SetProperty( "PH3_PDI07", MVC_VIEW_TITULO, 'Nome da meta 01' )
	oStr2:SetProperty( "PH3_PDI08", MVC_VIEW_TITULO, 'Descri��o da meta 01' )
	oStr2:SetProperty( "PH3_PDI09", MVC_VIEW_TITULO, 'Data Inicial da meta 01' )
	oStr2:SetProperty( "PH3_PDI10", MVC_VIEW_TITULO, 'Data de conclus�o prevista meta 01' )
	oStr2:SetProperty( "PH3_PDI11", MVC_VIEW_TITULO, 'Categoria meta 01' )

	oStr2:SetProperty( "PH3_PDI12", MVC_VIEW_TITULO, 'Nome da meta 02' )
	oStr2:SetProperty( "PH3_PDI13", MVC_VIEW_TITULO, 'Descri��o da meta 02' )
	oStr2:SetProperty( "PH3_PDI14", MVC_VIEW_TITULO, 'Data Inicial da meta 02' )
	oStr2:SetProperty( "PH3_PDI15", MVC_VIEW_TITULO, 'Data de conclus�o prevista meta 02' )
	oStr2:SetProperty( "PH3_PDI16", MVC_VIEW_TITULO, 'Categoria meta 02' )

	oStr2:SetProperty( "PH3_PDI17", MVC_VIEW_TITULO, 'Nome da meta 03' )
	oStr2:SetProperty( "PH3_PDI18", MVC_VIEW_TITULO, 'Descri��o da meta 03' )
	oStr2:SetProperty( "PH3_PDI19", MVC_VIEW_TITULO, 'Data Inicial da meta 03' )
	oStr2:SetProperty( "PH3_PDI20", MVC_VIEW_TITULO, 'Data de conclus�o prevista meta 03' )
	oStr2:SetProperty( "PH3_PDI21", MVC_VIEW_TITULO, 'Categoria meta 03' )

	oStr2:SetProperty( "PH3_PDI22", MVC_VIEW_TITULO, 'Nome da meta 04' )
	oStr2:SetProperty( "PH3_PDI23", MVC_VIEW_TITULO, 'Descri��o da meta 04' )
	oStr2:SetProperty( "PH3_PDI24", MVC_VIEW_TITULO, 'Data Inicial da meta 04' )
	oStr2:SetProperty( "PH3_PDI25", MVC_VIEW_TITULO, 'Data de conclus�o prevista meta 04' )
	oStr2:SetProperty( "PH3_PDI26", MVC_VIEW_TITULO, 'Categoria meta 04' )

	oStr2:SetProperty( "PH3_PDI27", MVC_VIEW_TITULO, 'Nome da meta 05' )
	oStr2:SetProperty( "PH3_PDI28", MVC_VIEW_TITULO, 'Descri��o da meta 05' )
	oStr2:SetProperty( "PH3_PDI29", MVC_VIEW_TITULO, 'Data Inicial da meta 05' )
	oStr2:SetProperty( "PH3_PDI30", MVC_VIEW_TITULO, 'Data de conclus�o prevista meta 05' )
	oStr2:SetProperty( "PH3_PDI31", MVC_VIEW_TITULO, 'Categoria meta 05' )

	oStr2:SetProperty( "PH3_PDI32", MVC_VIEW_TITULO, 'Caso queira, utilize este espa�o para inserir informa��es adicionais ao seu plano de desenvolvimento.' )

	oStr2:SetProperty( "PH3_PD133", MVC_VIEW_TITULO, 'Descreva sua forma��o.' )


	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM3' , oStr1,'PH1' )


	oView:AddField('FORM5' , oStr2,'PH3' )

	oView:CreateHorizontalBox( 'BOX2', 21)
	oView:CreateHorizontalBox( 'BOX1', 79)
	oView:CreateVerticalBox( 'BOXFORM3', 100, 'BOX2')

	//oStr2:SetProperty('PH3_ANO',MVC_VIEW_INIBROW,'M->PH1_ANO')
	oView:CreateVerticalBox( 'BOXFORM5', 100, 'BOX1')
	oView:SetOwnerView('FORM5','BOXFORM5')

	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetViewProperty('FORM3' , 'SETCOLUMNSEPARATOR', {10})
	oView:SetCloseOnOk({||.t.})

	oView:setUseCursor(.F.)


Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Administrator

@since 13/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local aAux := {}

	Local oStr1:= FWFormStruct(1,'PH1')

	Local oStr2:= FWFormStruct(1,'PH3')


	oModel := MPFormModel():New('EAA', /*bPre*/, {|oX| U_MvcPos(oX)} /*bPost*/, /*bCommit*/, /*bCancel*/)

	aAux := FwStruTrigger(;
	'PH1_ANO'                     					,; // Campo de Domínio (tem que existir no Model)
	'PH1_ANO'                  						,; // Campo de Contradomínio (tem que existir no Model)
	' ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	'u_GatMvc()')  // Condição para execução do gatilho (Opcional)
	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	aAux := FwStruTrigger(;
	'PH1_USER'                     					,; // Campo de Domínio (tem que existir no Model)
	'PH1_USER'                  						,; // Campo de Contradomínio (tem que existir no Model)
	' ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	'u_GatMvc()')  // Condição para execução do gatilho (Opcional)
	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])



	//oStr2:SetProperty("PH3_ANO", MODEL_FIELD_INIT , FwBuildFeature( STRUCT_FEATURE_INIPAD, "''" ))

	If Participante()
		oStr1:setProperty('*'	,MODEL_FIELD_WHEN,{|| .F.})
		oStr2:setProperty('*'	,MODEL_FIELD_WHEN,{|| .F.})
		oStr2:setProperty('PH3_OBSP1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP5'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_A1'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_A2'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_A3'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_A4'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_A5'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_COME02'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_AVPA'	,MODEL_FIELD_WHEN,{|| .T.})


		//oStr2:setProperty('PH3_PDI01'	,MODEL_FIELD_WHEN,{|| .T.})
		//oStr2:setProperty('PH3_PDI02'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI03'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI04'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI05'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI06'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI07'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI08'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI09'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI10'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI11'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI12'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI13'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI14'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI15'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI16'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI17'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI18'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI19'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI20'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI21'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI22'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI23'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI24'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI25'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI26'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI27'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI28'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI29'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI30'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI31'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_PDI32'	,MODEL_FIELD_WHEN,{|| .T.})

		If U_LIDMVC()
			oStr2:setProperty('PH3_AC1'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC2'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC3'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC4'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC12',MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC5'	,MODEL_FIELD_WHEN,{|| .T.})
			//	oStr2:setProperty('PH3_AC6'	,MODEL_FIELD_WHEN,{|| .T.})

		Else
			oStr2:setProperty('PH3_AC7'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC8'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC9'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC10',MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_AC11',MODEL_FIELD_WHEN,{|| .T.})
			//oStr2:setProperty('PH3_AC12',MODEL_FIELD_WHEN,{|| .T.})
		EndIf

	Else
		oStr1:setProperty('PH1_ANO'		,MODEL_FIELD_WHEN,{|| INCLUI })
		oStr1:setProperty('PH1_NOME'	,MODEL_FIELD_WHEN,{|| .F.})
		oStr1:setProperty('PH1_USER'	,MODEL_FIELD_WHEN,{|| INCLUI })
		oStr2:setProperty('*'	,MODEL_FIELD_WHEN,{|| .F.})
		oStr2:setProperty('PH3_OBSA1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSA2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSA3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSA4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSA5'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B1'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B1PER'	,MODEL_FIELD_WHEN,{|| .T.})	
		oStr2:setProperty('PH3_B2'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B2PER'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B3'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B3PER'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B4'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B4PER'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B5'		,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_B5PER'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_COME01'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_AVAV'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_AVPER'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_OBSP1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_OBSP5'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_COME02'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_AVPA'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_T1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MI1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MA1'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_T2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MI2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MA2'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_T3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MI3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MA3'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_T4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MI4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MA4'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_T5'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MI5'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_MA5'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_C1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_C2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_C3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_C4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_C5'	,MODEL_FIELD_WHEN,{|| .T.})

		oStr2:setProperty('PH3_DESV'	,MODEL_FIELD_WHEN,{|| .T.})

		If U_LIDMVC()
			oStr2:setProperty('PH3_PC1'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC2'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC3'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC4'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC5'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC12',MODEL_FIELD_WHEN,{|| .T.})

		Else
			oStr2:setProperty('PH3_PC7'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC8'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC9'	,MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC10',MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC11',MODEL_FIELD_WHEN,{|| .T.})
			oStr2:setProperty('PH3_PC12',MODEL_FIELD_WHEN,{|| .T.})

		EndIf
		oStr2:setProperty('PH3_M1'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_M2'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_M3'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_M4'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('PH3_M5'	,MODEL_FIELD_WHEN,{|| .T.})

	EndIf

	If __cUserId $ _UserMvc
		oStr1:setProperty('*'	,MODEL_FIELD_WHEN,{|| .T.})
		oStr2:setProperty('*'	,MODEL_FIELD_WHEN,{|| .T.})
	EndIF

	oModel:addFields('PH1',,oStr1)

	oModel:Addfields('PH3','PH1',oStr2)
	oModel:SetRelation('PH3', { { 'PH3_FILIAL', 'PH1_FILIAL' }, { 'PH3_USERID', 'PH1_USER' }, { 'PH3_ANO', 'PH1_ANO' } }, PH3->(IndexKey(1)) )
	oModel:SetPrimaryKey({ 'PH1_FILIAL', 'PH1_USER', 'PH1_ANO' })
	oModel:getModel('PH1'):SetDescription('PH1')
	oModel:SetDescription('EAA')
	oModel:getModel('PH3'):SetDescription('PH3')

	/*
	oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )ou oBrowse:SetFilterDefault( "Empty(ZA0_DTAFAL)" )
	oBrowse:DisableDetails()
	*/

Return oModel


Static Function Participante()
	Local _lRet := .T.

	If !(PH1->PH1_USER = __cUserId )
		_lRet := .F.
	EndIf

Return(_lRet)



User Function PH3INS()

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	Processa({|| 	carr()},'Aguarde...!!!!')

return()


Static Function carr()
	Local _nCod  := 0

	DbSelectArea('PH1')
	PH1->(DbSetOrder(1))
	_nCod := PH1->(RECCOUNT())
	ProcRegua(_nCod)


	While PH1->(!eof())
		_nCod--
		IncProc(cvaltochar(_nCod))
		If PH1->PH1_ANO = '2020'
			/*
			PH1->(RecLock('PH1',.F.))
			PH1->PH1_SETOR := Alltrim(Posicione("CTT",1,xFilial("CTT")+ Alltrim(Posicione("SRA",1,PH1->PH1_USER  ,"RA_CC",'USERCFG')),"CTT_DESC01"))
			PH1->PH1_CARGO:=  Alltrim(Posicione("SQB",1,xFilial("SQB")+ Alltrim(Posicione("SRA",1,PH1->PH1_USER  ,"RA_DEPTO",'USERCFG')),"QB_DESCRIC"))
			PH1->(MsUnLock())
			PH1->(DbCommit())
			 
			PH3->(RecLock('PH3',.T.))
			PH3->PH3_FILIAL := PH1->PH1_FILIAL
			PH3->PH3_USERID	:= PH1->PH1_USER
			PH3->PH3_ANO	:= '2020'
			PH3->(MsUnLock())
			PH3->(DbCommit())
			*/
		EndIf
		PH1->(Dbskip())
	End

return()

User function UsrUltLog(cUsrID)

	Local aReturn := FWUsrUltLog(cUsrID)
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	MsgAlert("Data ultimo logon " + dtoc(aReturn[1]) + " hora: " + aReturn[2] + " com o IP: " +aReturn[3] + " m�quina: " + aReturn[4] + " User SO: " + aReturn[5] )

Return


User Function STANEXMVC(_lT)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declara��o das Vari�veis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea       := GetArea()
	Local aArea1      := PH1->(GetArea())

	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _nLin       := 000
	Local cSolicit	  := PH1->PH1_USER

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\eea\"
	Private _cAno       := ""+PH1->PH1_ANO+"\"
	//Private _cFil       := ""+xFilial("PH1")+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.

	/*
	If !_lT
	If Inclui
	MsgInfo("Anexo so pode ser incluido apos a Grava��o do Reembolso...!!!!")
	Return()
	EndIf
	EndIf
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria��o das pastas para salvar os anexos das Solicitações de Compras no Servidor
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cAno
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	/*
	_cServerDir += _cFil
	If MakeDir (_cServerDir) == 0
	MakeDir(_cServerDir)
	Endif
	*/
	_cServerDir += _cNUm
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	If ExistDir(_cServerDir)

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(2,6)+".mzp")) = 1
			_cAne02 := Strzero(2,6)+".mzp"
		Else
			_cAne02 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(3,6)+".mzp")) = 1
			_cAne03 := Strzero(3,6)+".mzp"
		Else
			_cAne03 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(4,6)+".mzp")) = 1
			_cAne04 := Strzero(4,6)+".mzp"
		Else
			_cAne04 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(5,6)+".mzp")) = 1
			_cAne05 := Strzero(5,6)+".mzp"
		Else
			_cAne05 := space(90)
		Endif

		DbSelectArea("PH1")
		PH1->(DbSetOrder(1))
		If PH1->(DbSeek(xFilial("PH1")+cSolicit))
			dDtEmiss   := PH1->PH1_ADMISS
			cNameSolic := PH1->PH1_NOME

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("PH1") when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Data Admiss�o" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "Codigo Usuario" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Nome" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20

				DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg
				//DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

		EndIf

	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return()



Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 2
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o �rvore do servidor || .F. = n�o apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := PH1->(GetArea())

	//Local nOpcoes   := GETF_LOCALHARD
	// Opções permitidas
	//GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
	//GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
	//GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
	//GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
	//GETF_RETDIRECTORY   // Retorna apenas o diretório e n�o o nome do arquivo

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - Título da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho m�ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("J� existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Aten��o")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Copio o arquivo original da m�quina do usu�rio para o servidor
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realizo a compacta��o do arquivo para a extens�o .mzp
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apago o arquivo original do servidor
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
					,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					dbSelectArea("PH1")
					PH1->(dbGoTop())
					/*
					While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
					RecLock("Z1O", .F.)
					Z1O->Z1O_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
					Z1O->(MsUnlock())
					Z1O->( dbSkip() )
					End
					*/
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' n�o foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
					,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extens�o do Anexo"; //01 - cTitulo - Título da janela
				,"A Extens�o "+cExtensao+" é inv�lida para anexar junto ao reembolso."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
				,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := PH1->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa a��o o arquivo n�o ficar� mais disponível para consulta.","Aten��o")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - Título da janela
		,"N�o existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		/*
		dbSelectArea("Z1O")
		Z1O->(dbGoTop())
		While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
		RecLock("Z1O", .F.)
		Z1O->Z1O_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
		Z1O->(MsUnlock())
		Z1O->( dbSkip() )
		End
		*/
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "EEA\"
	Local _lUnzip     := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria��o das pastas para salvar os anexos das Solicitações de Compras na m�quina Local do usu�rio
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cAno
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif
	/*
	_cLocalDir += _cFil
	If MakeDir (_cLocalDir) == 0
	MakeDir(_cLocalDir)
	Endif
	*/
	_cLocalDir += _cNUm
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		_cOpen   := Strzero(_nOpen,6)+".mzp"
		cZipFile := _cServerDir+_cOpen
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
			_lUnzip := MsDecomp( _cLocalDir+_cOpen , _cLocalDir )
			If _lUnzip
				Ferase  ( _cLocalDir+_cOpen)
				ShellExecute("open", _cLocalDir, "", "", 1)
			Else
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - Título da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
				,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inv�lido"; //01 - cTitulo - Título da janela
			,"N�o existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - Título da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

Return (_cOpen)

