#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STBONUS           | Autor | GIOVANI.ZAGO             | Data | 28/01/2016 |
|=====================================================================================|
|Sintaxe   | STBONUS                                                                  |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STBONUS()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_STBONUS',,'000000/000308/000210')
	Private _lPartic := .T.
	DbSelectArea("PH4")
	DbSelectArea("PH5")
	DbSelectArea("PH6")
	DbSelectArea("PH7")
	DbSelectArea("PH8")
	DbSelectArea("PH9")
	DbSelectArea("PHA")
	DbSelectArea("PHB")
	PH4->(DbSetOrder(1))
	
	
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cUserId))
		If  (Empty(Alltrim(SA3->A3_SUPER))) .And. !(Empty(Alltrim(SA3->A3_GEREN)))
			_cVen := SA3->A3_COD
			
		EndIf
	EndIf
	
	
	
	
	If 	!(__cUserId $ _UserMvc)
		PH4->(dbSetFilter({|| PH4->PH4_COORD =  _cVen },'PH4->PH4_COORD =   _cVen '))
	EndIF
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("PH4")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STBONUS")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Grupo De Clientes")   	// Descrição do browse
	oBrowse:AddLegend(" PH4_BLQ = '1'   "  ,"RED"        ,"Bloqueado")
	oBrowse:AddLegend(" PH4_BLQ = '2'   "  ,"GREEN"        ,"Liberado")
	oBrowse:Activate()
	
Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_STBONUS',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STBONUS" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STBONUS" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STBONUS" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STBONUS" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STBONUS" OPERATION 8 ACCESS 0 //"Imprimir"
	
	ADD OPTION aRotina TITLE "Bloquear/Desbloquear"   ACTION "u_BXDES" OPERATION 8 ACCESS 0 //"Imprimir"
	
	
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
	
	
	
	
	Local oStr2:= FWFormStruct(2, 'PH5')
	
	Local oStr3:= FWFormStruct(2, 'PH6')
	
	
	
	Local oStr5:= FWFormStruct(2, 'PH4')
	
	Local oStr6:= FWFormStruct(2, 'PH7')
	
	Local oStr7:= FWFormStruct(2, 'PH8')
	
	Local oStr8:= FWFormStruct(2, 'PH9')
	
	Local oStr9:= FWFormStruct(2, 'PHA')
	
	
	Local oStr1:= FWFormStruct(2, 'PHB')
	oStr2:RemoveField( 'PH5_ITEM' )
	/*
	oStr2:RemoveField( 'PH5_NUM' )
	oStr3:RemoveField( 'PH6_NUM' )
	oStr6:RemoveField( 'PH7_NUM' )
	oStr7:RemoveField( 'PH8_NUM' )
	oStr8:RemoveField( 'PH9_NUM' )
	oStr9:RemoveField( 'PHA_NUM' )
	oStr1:RemoveField( 'PHB_NUM' )
	*/
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('FORM9' , oStr5,'PH4' )
	
	
	oView:AddGrid('PH5' , oStr2,'PH5')
	oView:AddGrid('PH6' , oStr3,'PH6')
	oView:AddGrid('PH7' , oStr6,'PH7')
	oView:AddGrid('PH8' , oStr7,'PH8')
	oView:AddGrid('PH9' , oStr8,'PH9')
	oView:AddGrid('PHA' , oStr9,'PHA')
	oView:AddGrid('PHB' , oStr1,'PHB')
	
	oView:CreateHorizontalBox( 'BOX2', 29)
	
	
	
	oView:CreateHorizontalBox( 'BOX1', 71)
	
	oView:CreateFolder( 'FOLDER5', 'BOX1')
	
	oView:CreateFolder( 'FOLDER8', 'BOX2')
	oView:AddSheet('FOLDER8','SHEET12','Grupo de Clientes')
	
	oView:AddSheet('FOLDER5','SHEET9','Grupo X Clientes')
	oView:AddSheet('FOLDER5','SHEET8','Grupo x Metas')
	oView:AddSheet('FOLDER5','SHEET7','Bonus Escalonado')
	oView:AddSheet('FOLDER5','Bonus Condicional','Bonus Marketing')
	
	
	
	oView:AddSheet('FOLDER5','SHEET6','Bonus Incondicional')
	oView:AddSheet('FOLDER5','SHEET11','Ação Marketing')
	oView:AddSheet('FOLDER5','SHEET10','Ação Comercial')
	oView:CreateHorizontalBox( 'BOXFORM19', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'Bonus Condicional')
	oView:SetOwnerView('PHB','BOXFORM19')
	
	oView:CreateHorizontalBox( 'BOXFORM17', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET6')
	oView:SetOwnerView('PHA','BOXFORM17')
	oView:CreateHorizontalBox( 'BOXFORM15', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET10')
	oView:SetOwnerView('PH9','BOXFORM15')
	oView:CreateHorizontalBox( 'BOXFORM13', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET11')
	oView:SetOwnerView('PH8','BOXFORM13')
	oView:CreateHorizontalBox( 'BOXFORM11', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET7')
	oView:SetOwnerView('PH7','BOXFORM11')
	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('FORM9','BOXFORM9')
	oView:CreateHorizontalBox( 'BOXFORM8', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET8')
	oView:SetOwnerView('PH6','BOXFORM8')
	oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET9')
	oView:SetOwnerView('PH5','BOXFORM6')
	
	
	
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
	
	
	Local oStr1:= FWFormStruct(1,'PH4')
	
	Local oStr2:= FWFormStruct(1,'PH5')
	
	Local oStr3:= FWFormStruct(1,'PH6')
	
	Local oStr4:= FWFormStruct(1,'PH7')
	
	Local oStr5:= FWFormStruct(1,'PH8')
	
	Local oStr6:= FWFormStruct(1,'PH9')
	
	Local oStr7:= FWFormStruct(1,'PHA')
	Local 	aAux := {}
	
	
	Local oStr8:= FWFormStruct(1,'PHB')
	aAux := FwStruTrigger(;
		'PH4_COORD'                    					,; // Campo de Domínio (tem que existir no Model)
	'PH4_NOMEC'                						,; // Campo de Contradomínio (tem que existir no Model)
	'Substr(Posicione("SA3", 1, xFilial("SA3") + FwFldGet("PH4_COORD"), "A3_NOME"),1,25)' 											,; // Regra de Preenchimento
	.F.                          					,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	)  // Condição para execução do gatilho (Opcional)
	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	
	aAux := FwStruTrigger(;
		'PH5_CLIENT'                    					,; // Campo de Domínio (tem que existir no Model)
	'PH5_NOME'                						,; // Campo de Contradomínio (tem que existir no Model)
	'Substr(Posicione("SA1", 1, xFilial("SA1") + FwFldGet("PH5_CLIENT"), "A1_NOME"),1,25)' 											,; // Regra de Preenchimento
	.F.                          					,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	)  // Condição para execução do gatilho (Opcional)
	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	aAux := FwStruTrigger(;
		'PH5_CLIENT'                    					,; // Campo de Domínio (tem que existir no Model)
	'PH5_LOJA'                						,; // Campo de Contradomínio (tem que existir no Model)
	' ' 											,; // Regra de Preenchimento
	.F.                          					,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	)  // Condição para execução do gatilho (Opcional)
	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	
	aAux := FwStruTrigger(;
		'PH6_ANO'                    					,; // Campo de Domínio (tem que existir no Model)
	'PH6_FATURA'                						,; // Campo de Contradomínio (tem que existir no Model)
	'U_PH6FATURA()' 											,; // Regra de Preenchimento
	.F.                          					,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (Obrigatório se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (Obrigatório se lSeek = .T)
	)  // Condição para execução do gatilho (Opcional)
	oStr3:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])
	
	
	
	
	
	
	
	
	oModel := MPFormModel():New('BONUS', /*bPre*/{|oX| U_BonusPos(oX)},   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('BONUS')
	oModel:addFields('PH4',,oStr1)
	oModel:SetPrimaryKey({ 'PH4_FILIAL', 'PH4_NUM' })
	
	
	oModel:addGrid('PH5','PH4',oStr2,/*bLinePre*/,{|oX| U_PH5LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('PH5'):SetUniqueLine( { 'PH5_FILIAL', 'PH5_NUM', 'PH5_CLIENT', 'PH5_LOJA' } )
	
	oModel:addGrid('PH6','PH4',oStr3,/*bLinePre*/,{|oX| U_PH6LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('PH6'):SetUniqueLine( { 'PH6_FILIAL', 'PH6_ANO' } )
	
	oModel:addGrid('PH7','PH4',oStr4,/*bLinePre*/,{|oX| U_PH7LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:addGrid('PH8','PH4',oStr5,/*bLinePre*/,{|oX| U_PH8LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:addGrid('PH9','PH4',oStr6,/*bLinePre*/,{|oX| U_PH9LINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:addGrid('PHA','PH4',oStr7,/*bLinePre*/,{|oX| U_PHALINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:addGrid('PHB','PH4',oStr8,/*bLinePre*/,{|oX| U_PHBLINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	
	
	oModel:SetRelation('PHB', { { 'PHB_NUM', 'PH4_NUM' }, { 'PHB_FILIAL', 'PH4_FILIAL' } }, PHB->(IndexKey(1)) )
	oModel:SetRelation('PHA', { { 'PHA_FILIAL', 'PH4_FILIAL' }, { 'PHA_NUM', 'PH4_NUM' } }, PHA->(IndexKey(1)) )
	oModel:SetRelation('PH9', { { 'PH9_FILIAL', 'PH4_FILIAL' }, { 'PH9_NUM', 'PH4_NUM' } }, PH9->(IndexKey(1)) )
	oModel:SetRelation('PH8', { { 'PH8_FILIAL', 'PH4_FILIAL' }, { 'PH8_NUM', 'PH4_NUM' } }, PH8->(IndexKey(1)) )
	oModel:SetRelation('PH7', { { 'PH7_FILIAL', 'PH4_FILIAL' }, { 'PH7_NUM', 'PH4_NUM' } }, PH7->(IndexKey(1)) )
	oModel:SetRelation('PH6', { { 'PH6_FILIAL', 'PH4_FILIAL' }, { 'PH6_NUM', 'PH4_NUM' } }, PH6->(IndexKey(1)) )
	oModel:SetRelation('PH5', { { 'PH5_FILIAL', 'PH4_FILIAL' }, { 'PH5_NUM', 'PH4_NUM' } }, PH5->(IndexKey(1)) )
	
	
	oModel:getModel('PH4'):SetDescription('PH4')
	oModel:getModel('PH5'):SetDescription('PH5')
	oModel:getModel('PH6'):SetDescription('PH6')
	oModel:getModel('PH7'):SetDescription('PH7')
	oModel:getModel('PH8'):SetDescription('PH8')
	oModel:getModel('PH9'):SetDescription('PH9')
	oModel:getModel('PHA'):SetDescription('PHA')
	oModel:getModel('PHB'):SetDescription('PHB')
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação para inicializador padrão
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// oModel:SetActivate( {|oMod| IniPad(oMod)} )
	
Return oModel


Static Function IniPad(oModel)
	
	Local nOp  := oModel:GetOperation()
	Local lIni := .T.
	
	If nOp == MODEL_OPERATION_INSERT //Cópia também é reconhecida como inserção
		
		oModel:SetValue("ITENS", "ZI_ITEM" , '001')
		
	EndIf
	
Return lIni



User Function BonusPos(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := FWMODELACTIVE()
	Local oModel4PH  := oModelPai:GetModel('PH4')
	Local oModel5PH  := oModelPai:GetModel('PH5')
	Local oModel6PH  := oModelPai:GetModel('PH6')
	Local oModel7PH  := oModelPai:GetModel('PH7')
	Local oModel8PH  := oModelPai:GetModel('PH8')
	Local oModel9PH  := oModelPai:GetModel('PH9')
	Local oModelAPH  := oModelPai:GetModel('PHA')
	Local oModelBPH  := oModelPai:GetModel('PHB')
	Local ni		 := 0
	
	For nI := 1 To oModel5PH:GetQtdLine()
		oModel5PH:GoLine( nI )
		oModel5PH:LoadValue('PH5_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModel6PH:GetQtdLine()
		oModel6PH:GoLine( nI )
		oModel6PH:LoadValue('PH6_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModel7PH:GetQtdLine()
		oModel7PH:GoLine( nI )
		oModel7PH:LoadValue('PH7_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModel8PH:GetQtdLine()
		oModel8PH:GoLine( nI )
		oModel8PH:LoadValue('PH8_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModel9PH:GetQtdLine()
		oModel9PH:GoLine( nI )
		oModel9PH:LoadValue('PH9_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModelAPH:GetQtdLine()
		oModelAPH:GoLine( nI )
		oModelAPH:LoadValue('PHA_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	For nI := 1 To oModelBPH:GetQtdLine()
		oModelBPH:GoLine( nI )
		oModelBPH:LoadValue('PHB_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	Next nI
	
	
	
	
	
	
	
Return .T.



User Function PH6FATURA()
	Local oModelPai  := FWMODELACTIVE()
	Local oModel5PH  := oModelPai:GetModel('PH5')
	Local oModel6PH  := oModelPai:GetModel('PH6')
	Local _nRet		 := 0
	Local _nRet2	 := 0
	Local cAliasGWN  := 'PH6FATURA'
	Local cQuery 	 := ' '
	Local _cClie  	 := ' '
	Local _cAno  	 := ' '
	Local nAtuLn    := oModel6PH:GetLine()
	Local ni		:= 0
	For nI := 1 To oModel5PH:GetQtdLine()
		oModel5PH:GoLine( nI )
		If !oModel5PH:IsDeleted()
			If nI = 1
				_cClie := "('"+ FwFldGet("PH5_CLIENT",nI)
			Else
				_cClie += "','"+ FwFldGet("PH5_CLIENT",nI)
			EndIf
			
		EndIf
	Next nI
	_cClie += "')"
	oModel6PH:GoLine( nAtuLn )
	_cAno  	 := FwFldGet("PH6_ANO",nAtuLn)
	_cAno  	 := tira1(_cAno)
	
	cQuery := " SELECT NVL( SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ),0)
	cQuery += ' "VALOR"
	cQuery += " FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"+_cAno+"'   AND D2_CLIENTE IN "+_cClie
	
	cQuery := ChangeQuery(cQuery)
	
	
	If !Empty(Select(cAliasGWN))
		DbSelectArea(cAliasGWN)
		(cAliasGWN)->(dbCloseArea())
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWN, .F., .T.)
	
	dbSelectArea((cAliasGWN))
	(cAliasGWN)->( dbGoTop() )
	
	_nRet:=(cAliasGWN)->VALOR
	
	cQuery := " SELECT NVL( SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ),0)
	cQuery += ' "VALOR"
	cQuery += " FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"+_cAno+"'   AND D2_CLIENTE IN "+_cClie
	
	cQuery := ChangeQuery(cQuery)
	
	
	If !Empty(Select(cAliasGWN))
		DbSelectArea(cAliasGWN)
		(cAliasGWN)->(dbCloseArea())
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWN, .F., .T.)
	
	dbSelectArea((cAliasGWN))
	(cAliasGWN)->( dbGoTop() )
	
	_nRet:= _nRet + (cAliasGWN)->VALOR
	
	
	
	
	
	
	cQuery2 :=	"SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery2 += ' "VALOR"
	cQuery2 += " FROM  SD1010  SD1  INNER JOIN(SELECT * FROM   SA1010 )SA1  ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery2 += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '"+_cAno+"'  AND SA1.A1_COD  IN  "+_cClie
	
	
	cQuery2 := ChangeQuery(cQuery2)
	
	
	If !Empty(Select(cAliasGWN))
		DbSelectArea(cAliasGWN)
		(cAliasGWN)->(dbCloseArea())
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery2),cAliasGWN, .F., .T.)
	
	dbSelectArea((cAliasGWN))
	(cAliasGWN)->( dbGoTop() )
	
	_nRet2:=(cAliasGWN)->VALOR
	
	cQuery2 :=	"SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery2 += ' "VALOR"
	cQuery2 += " FROM  SD1030  SD1  INNER JOIN(SELECT * FROM   SA1010 )SA1  ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery2 += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '"+_cAno+"'  AND SA1.A1_COD  IN  "+_cClie
	
	
	cQuery2 := ChangeQuery(cQuery2)
	
	
	If !Empty(Select(cAliasGWN))
		DbSelectArea(cAliasGWN)
		(cAliasGWN)->(dbCloseArea())
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery2),cAliasGWN, .F., .T.)
	
	dbSelectArea((cAliasGWN))
	(cAliasGWN)->( dbGoTop() )
	
	_nRet2:= _nRet2+ (cAliasGWN)->VALOR
	
	
	_nRet:= (_nRet - _nRet2)
	
Return (_nRet)




User Function PH5LINE(oModel5PH)
	Local nLine       := oModel5PH:getLine()
	Local nI
	Local lRet        := .T.
	Local cClient	  := FwFldGet("PH5_CLIENT",nLine)
	Local cLoja		  := FwFldGet("PH5_LOJA",nLine)
	Local oModelPai   := FWMODELACTIVE()
	
	
	
	
	For nI := 1 To oModel5PH:GetQtdLine()
		oModel5PH:GoLine( nI )
		
		//Validação de chave duplicada
		If FwFldGet("PH5_CLIENT",nI) == cClient  .AND. FwFldGet("PH5_LOJA",nI) == cLoja    .AND. nLine != nI
			Help( ,, 'Help',, 'Cliente/Loja Já Cadastrado', 1, 0 )
			lRet := .F.
		EndIf
		
	Next nI
	
	
	
	oModel5PH:LoadValue('PH5_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet


User Function PH6LINE(oModel6PH)
	Local nLine       := oModel6PH:getLine()
	Local nI
	Local lRet        := .T.
	Local cAno		  := FwFldGet("PH6_ANO",nLine)
	Local oModelPai   := FWMODELACTIVE()
	
	
	
	
	For nI := 1 To oModel6PH:GetQtdLine()
		oModel6PH:GoLine( nI )
		
		//Validação de chave duplicada
		If FwFldGet("PH6_ANO",nI) == cAno   .AND. nLine != nI
			Help( ,, 'Help',, 'Ano Já Cadastrado', 1, 0 )
			lRet := .F.
		EndIf
		
	Next nI
	
	
	
	oModel6PH:LoadValue('PH6_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function PH7LINE(oModel7PH)
	Local nLine       := oModel7PH:getLine()
	Local nI
	Local lRet        := .T.
	Local cAno		  := FwFldGet("PH7_TARGET",nLine)
	Local oModelPai   := FWMODELACTIVE()
	
	
	
	
	For nI := 1 To oModel7PH:GetQtdLine()
		oModel7PH:GoLine( nI )
		
		//Validação de chave duplicada
		If FwFldGet("PH7_TARGET",nI) == cAno   .AND. nLine != nI
			Help( ,, 'Help',, 'TARGET Já Cadastrado', 1, 0 )
			lRet := .F.
		EndIf
		
	Next nI
	
	
	
	oModel7PH:LoadValue('PH7_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function PH8LINE(oModel8PH)
	Local nLine       := oModel8PH:getLine()
	Local nI
	Local lRet        := .T.
	Local oModelPai   := FWMODELACTIVE()
	
	oModel8PH:LoadValue('PH8_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function PH9LINE(oModel9PH)
	Local nLine       := oModel9PH:getLine()
	Local nI
	Local lRet        := .T.
	Local oModelPai   := FWMODELACTIVE()
	
	oModel9PH:LoadValue('PH9_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function PHALINE(oModelAPH)
	Local nLine       := oModelAPH:getLine()
	Local nI
	Local lRet        := .T.
	Local oModelPai   := FWMODELACTIVE()
	
	oModelAPH:LoadValue('PHA_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function PHBLINE(oModelBPH)
	Local nLine       := oModelBPH:getLine()
	Local nI
	Local lRet        := .T.
	Local oModelPai   := FWMODELACTIVE()
	
	oModelBPH:LoadValue('PHB_NUM',oModelPai:GetValue( 'PH4', 'PH4_NUM' ))
	
	
Return lRet

User Function BXDES()
	
	If __cuserid $ GetMv("ST_BBX",,'000000/000645/000294')+	'/000000/000645/000294'
		
		If PH4->PH4_BLQ = '1'
			
			
			If MsgYesNo("Deseja Desbloquear ?")
				PH4->(RecLock('PH4',.F.))
				PH4->PH4_BLQ = '2'
				PH4->(MsUnlock())
				PH4->( DbCommit() )
			EndIf
		Else
			If MsgYesNo("Deseja Bloquear ?")
				PH4->(RecLock('PH4',.F.))
				PH4->PH4_BLQ = '1'
				PH4->(MsUnlock())
				PH4->( DbCommit() )
			EndIf
		EndIf
	Else
		MsgInfo("Usuario nao Autorizado")
	EndIf
Return()

