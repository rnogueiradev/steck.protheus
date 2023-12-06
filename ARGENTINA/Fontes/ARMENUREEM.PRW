#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | ARMENUREEM       | Autor | GIOVANI.ZAGO             | Data | 19/05/2017 |
|=====================================================================================|
|Sintaxe   | ARMENUREEM                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
|Adaptação para utiliza na Argentina - Everson Santana - 15.10.2018					  |
\====================================================================================
*/
*----------------------------------*
User Function ARMENUREEM()
	*----------------------------------*
	Local oBrowse
	//Private _UserMvc := GetMv('AR_STREEM',,'000000/000308/000210')
	//Private _lPartic := .T.
	DbSelectArea("Z1M")
	DbSelectArea("Z1N")
	
	Z1M->(DbSetOrder(1))
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1M")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("ARMENUREEM")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Reembolsos de usuario")   	// Descrição do browse
	oBrowse:Activate()
	
Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//Private _UserMvc := GetMv('AR_STREEM',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  	ACTION "AxPesqui"      	  OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ARMENUREEM" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Modificar"    ACTION "VIEWDEF.ARMENUREEM" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Anular"    	ACTION "VIEWDEF.ARMENUREEM" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.ARMENUREEM" OPERATION 3 ACCESS 0 //"Incluir"
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Administrator

@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr2Ar:= FWFormStruct(2, 'Z1N')
	Local oStr5Ar:= FWFormStruct(2, 'Z1M')
	
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('Z1M' , oStr5Ar,'Z1M' )
	oView:AddGrid('Z1N' , oStr2Ar,'Z1N')
	
	oView:CreateHorizontalBox( 'BOX2', 35)
	oView:CreateFolder( 'FOLDER8', 'BOX2')
	
	oView:AddSheet('FOLDER8','SHEET12','Solicitante')
	
	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('Z1M','BOXFORM9')
	oView:CreateHorizontalBox( 'BOX1', 65)
	oView:CreateFolder( 'FOLDER5', 'BOX1')
	oView:AddSheet('FOLDER5','SHEET9','Itens')
	oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET9')
	
	oView:SetOwnerView('Z1N','BOXFORM6')
	
Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Administrator

@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1Ar:= FWFormStruct(1,'Z1M')
	Local oStr2Ar:= FWFormStruct(1,'Z1N')
	Local aAux := {}

	oModel:= MPFormModel():New('ArMenu', /*bPre {|oX| U_xMenuPos(oX)}*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('ArMenu')
	
	aAux := FwStruTrigger(;
		'Z1M_APRO'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1M_NOME'                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'UsrFullName(M->Z1M_APRO)' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'')  // Condição para execução do gatilho (Opcional)
	
	oStr1Ar:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	
	aAux := FwStruTrigger(;
		'Z1N_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1N_NOME'                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'UsrFullName(M->Z1N_USER)' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'')  // Condição para execução do gatilho (Opcional)
	oStr2Ar:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	
	oModel:addFields('Z1M',,oStr1Ar)
	oModel:SetPrimaryKey({ 'Z1M_FILIAL', 'Z1M_COD' })
	
	oModel:addGrid('Z1N','Z1M',oStr2Ar,/*bLinePre*/,{|oX| U_Z1NLINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('Z1N')
	oModel:GetModel('Z1N'):SetUniqueLine( { 'Z1N_FILIAL', 'Z1N_COD', 'Z1N_USER' } )
	
	oModel:SetRelation('Z1N', { { 'Z1N_FILIAL', 'Z1M_FILIAL' }, { 'Z1N_COD', 'Z1M_COD' } }, 'Z1N_FILIAL+Z1N_COD+Z1N_USER'   )
	
	oModel:getModel('Z1M'):SetDescription('Z1M')
	oModel:getModel('Z1N'):SetDescription('Z1N')
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação para inicializador padrão
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetActivate( {|oMod| IniPad(oMod)} )
	
Return oModel

Static Function RetValor(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := oModel
	Local oModel4PH  := oModelPai:GetModel('Z1M')
	Local oModel5PH  := oModelPai:GetModel('Z1N')
	Local  _nret := 0
	
	_nret:= oModelPai:GetValue( 'Z1M', 'Z1M_VALOR' )
Return (_nret)

Static Function IniPad(oModel)
	Local nOp  := oModel:GetOperation()
	Local lIni := .T.
	
	If nOp == MODEL_OPERATION_INSERT //Cópia também é reconhecida como inserção
		//oModel:SetValue("Z1N_ITEM" , '001')
	EndIf
Return lIni

User Function WMenuPos(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := FWMODELACTIVE()
	Local oModel4PH  := oModelPai:GetModel('Z1M')
	Local oModel5PH  := oModelPai:GetModel('Z1N')
	/*
	For nI := 1 To oModel5PH:GetQtdLine()
		oModel5PH:GoLine( nI )
		oModel5PH:LoadValue('Z1N_COD',oModelPai:GetValue( 'Z1M', 'Z1M_COD' ))
	Next nI
	*/
	
Return .T.

User Function Z1NLINE(oModel5PH)
	Local nLine       := oModel5PH:getLine()
	Local nI
	Local lRet        := .T.
	/*
	Local cClient	  := FwFldGet("Z1N_FUNCAO",nLine)
	Local oModelPai   := FWMODELACTIVE()
	
	
	
	
	For nI := 1 To oModel5PH:GetQtdLine()
		oModel5PH:GoLine( nI )
		
		//Validação de chave duplicada
		If FwFldGet("Z1N_FUNCAO",nI) == cClient     .AND. nLine != nI
			Help( ,, 'Help',, 'Rotina Já Cadastrada', 1, 0 )
			lRet := .F.
		EndIf
		
	Next nI
	
	
	
	oModel5PH:LoadValue('Z1N_COD',oModelPai:GetValue( 'Z1M', 'Z1M_COD' ))
	*/
	
Return lRet
