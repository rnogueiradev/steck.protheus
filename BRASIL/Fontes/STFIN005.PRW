#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} STFIN005

Cadastro de Aprovados/Solicitante de Pagamentos

@type function
@author Everson Santana
@since 01/03/19
@version Protheus 12 - Financeiro

@history ,Chamado 006559 ,

/*/

*----------------------------------*
User Function STFIN005()
	*----------------------------------*
	Local oBrowse
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprovação de Titulos
	//Private _UserMvc := GetMv('ST_STREEM',,'000000/000308/000210')
	Private _lPartic := .T.

	If _FinAprov

		DbSelectArea("Z41")
		DbSelectArea("Z42")

		Z41->(DbSetOrder(1))

		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("Z41")					// Alias da tabela utilizada
		oBrowse:SetMenuDef("STFIN005")				// Nome do fonte onde esta a função MenuDef
		oBrowse:SetDescription("Solicitantes de Aprovação")   	// Descrição do browse
		oBrowse:Activate()

	Else

		MsgAlert("Processo desativado."+CR+CR+" Verifique com o Admistrador do Sistema. ","STFIN005")

	EndIf

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//Private _UserMvc := GetMv('ST_STREEM',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      	  OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STFIN005" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STFIN005" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STFIN005" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STFIN005" OPERATION 3 ACCESS 0 //"Incluir"
	//	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STFIN005" OPERATION 8 ACCESS 0 //"Imprimir"

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

	Local oStr2:= FWFormStruct(2, 'Z42')
	Local oStr5:= FWFormStruct(2, 'Z41')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('Z41' , oStr5,'Z41' )
	oView:AddGrid('Z42' , oStr2,'Z42')

	oView:CreateHorizontalBox( 'BOX2', 35)
	oView:CreateFolder( 'FOLDER8', 'BOX2')
	oView:AddSheet('FOLDER8','SHEET12','Aprovador')

	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('Z41','BOXFORM9')
	oView:CreateHorizontalBox( 'BOX1', 65)
	oView:CreateFolder( 'FOLDER5', 'BOX1')
	oView:AddSheet('FOLDER5','SHEET9','Solicitantes')
	oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET9')

	oView:SetOwnerView('Z42','BOXFORM6')

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
	Local oStr1:= FWFormStruct(1,'Z41')
	Local oStr2:= FWFormStruct(1,'Z42')
	Local 	aAux := {}

	oModel := MPFormModel():New('Menu', /*bPre {|oX| U_xMenuPos(oX)}*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('Menu')

	aAux := FwStruTrigger(;
	'Z41_APRO'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z41_NOME'                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'UsrFullName(M->Z41_APRO)' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'')  // Condição para execução do gatilho (Opcional)
	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z42_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z42_NOME'                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'UsrFullName(M->Z42_USER)' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'')  // Condição para execução do gatilho (Opcional)
	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	oModel:addFields('Z41',,oStr1)
	oModel:SetPrimaryKey({ 'Z41_FILIAL', 'Z41_COD' })

	oModel:addGrid('Z42','Z41',oStr2,/*bLinePre*/,{|oX| U_Z42LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('Z42')
	oModel:GetModel('Z42'):SetUniqueLine( { 'Z42_FILIAL', 'Z42_COD', 'Z42_USER' } )

	oModel:SetRelation('Z42', { { 'Z42_FILIAL', 'Z41_FILIAL' }, { 'Z42_COD', 'Z41_COD' } }, 'Z42_FILIAL+Z42_COD+Z42_USER'   )

	oModel:getModel('Z41'):SetDescription('Z41')
	oModel:getModel('Z42'):SetDescription('Z42')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação para inicializador padrão
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

Return oModel

Static Function RetValor(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := oModel
	Local oModel4PH  := oModelPai:GetModel('Z41')
	Local oModel5PH  := oModelPai:GetModel('Z42')
	Local  _nret := 0

	_nret:= oModelPai:GetValue( 'Z41', 'Z41_VALOR' )

Return (_nret)

Static Function IniPad(oModel)

	Local nOp  := oModel:GetOperation()
	Local lIni := .T.

	If nOp == MODEL_OPERATION_INSERT //Cópia também é reconhecida como inserção

		//oModel:SetValue("Z42_ITEM" , '001')

	EndIf

Return lIni

User Function Z42LINE(oModel5PH)
	Local nLine       := oModel5PH:getLine()
	Local nI
	Local lRet        := .T.
	/*
	Local cClient	  := FwFldGet("Z42_FUNCAO",nLine)
	Local oModelPai   := FWMODELACTIVE()




	For nI := 1 To oModel5PH:GetQtdLine()
	oModel5PH:GoLine( nI )

	//Validação de chave duplicada
	If FwFldGet("Z42_FUNCAO",nI) == cClient     .AND. nLine != nI
	Help( ,, 'Help',, 'Rotina Já Cadastrada', 1, 0 )
	lRet := .F.
	EndIf

	Next nI



	oModel5PH:LoadValue('Z42_COD',oModelPai:GetValue( 'Z41', 'Z41_COD' ))
	*/

Return lRet
