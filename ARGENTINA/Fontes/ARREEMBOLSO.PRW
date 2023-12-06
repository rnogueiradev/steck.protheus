#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "TOTVS.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | ARREEMBOLSO       | Autor | GIOVANI.ZAGO             | Data | 19/05/2017 |
|=====================================================================================|
|Sintaxe   | ARREEMBOLSO                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico...................................|
|Adapta��o para utiliza na Argentina - Everson Santana - 15.10.2018					  |
\====================================================================================
*/
*----------------------------------*
User Function ARREEMBOLSO()
	*----------------------------------*
	Local oBrowse,oBrowse2
	//Private _UserMvc := GetMv('AR_STREEM',,'000000/000308/000210')
	Private _xSuper   := u_Super()
	Private _cFarol := .f.
	Private aHeader
	DbSelectArea("Z1O")
	Z1O->(DbSetOrder(1))
	Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or.   __cUserId $ _xSuper   },'Z1O->Z1O_USER = __cUserId  .Or.   __cUserId $ __xSuper  '))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1O")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("ARREEMBOLSO")				// Nome do fonte onde esta a fun��o MenuDef
	oBrowse:SetDescription("Solicita��o de Reembolso")   	// Descri��o do browse
	oBrowse2:AddLegend(" Z1O_STATUS = '1'   "  ,"GREEN"         ,"Em Aberto")
	oBrowse2:AddLegend(" Z1O_STATUS = '2'   "  ,"YELLOW"      	,"Aprovacao Gestor")
	oBrowse2:AddLegend(" Z1O_STATUS = '3'   "  ,"BLUE"        	,"Aprovacao Financeiro")
	oBrowse2:AddLegend(" Z1O_STATUS = '4'   "  ,"RED"      		,"Finalizado")
	oBrowse2:SetUseCursor(.T.)
	oBrowse:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      	   OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ARREEMBOLSO" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.ARREEMBOLSO" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.ARREEMBOLSO" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.ARREEMBOLSO" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.ARREEMBOLSO" OPERATION 8 ACCESS 0 //"Imprimir"
	ADD OPTION aRotina TITLE "ANEXOS"  	  ACTION "U_STANEX(.T.)" 	   OPERATION 4 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "MAPA"    ACTION "U_Navegador" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "Bloquear/Desbloquear"   ACTION "u_BXDES" OPERATION 8 ACCESS 0 //"Imprimir"


Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o do interface

@author Administrator

@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()

	Local oStr2:= FWFormStruct(2, 'Z1P')
	Local oStr5:= FWFormStruct(2, 'Z1O')


	Local oStr1:= FWCalcStruct( oModel:GetModel('CALC1') )

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:SetAfterOkButton(  {|oView| U_STREEVAL(oView)}   )
	oView:AddField('Z1O' , oStr5,'Z1O' )
	oView:AddGrid('Z1P' , oStr2,'Z1P')
	oView:AddField('FORM10', oStr1,'CALC1')

	oView:CreateHorizontalBox( 'BOX2', 49)
	oView:CreateFolder( 'FOLDER8', 'BOX2')

	oView:AddSheet('FOLDER8','SHEET12','Solicitante')


	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('Z1O','BOXFORM9')
	oView:CreateHorizontalBox( 'BOX1', 51)
	oView:CreateFolder( 'FOLDER5', 'BOX1')
	oView:AddSheet('FOLDER5','SHEET9','Itens')
	oView:CreateHorizontalBox( 'BOXFORM6', 67, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET9')
	oView:CreateHorizontalBox( 'BOX9', 33, /*owner*/, /*lPixel*/, 'FOLDER5', 'SHEET9')
	oView:CreateVerticalBox( 'BOXFORM10', 100, 'BOX9', /*lUsePixel*/, 'FOLDER5', 'SHEET9')
	oView:SetOwnerView('FORM10','BOXFORM10')
	oView:SetOwnerView('Z1P','BOXFORM6')

	oView:AddUserButton( 'Anexos', 'NOTE', {|oView| U_STANEX()} )


Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados

@author Administrator

@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel

	Local oStr1:= FWFormStruct(1,'Z1O')
	Local oStr2:= FWFormStruct(1,'Z1P')

	Local 	aAux := {}

	oModel := MPFormModel():New('Menu', /*bPre*/{|oX| U_xMenuPos(oX)},   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('Menu')

	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	//>> Ponto de Entrada - Everson Santana - 30/08/18
	//oModel	:=	MpFormModel():New("PEREEM",/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
	//<<

	aAux := FwStruTrigger(;
	'Z1O_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1O_BANCO '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'U_REBAN("1",M->Z1O_USER) ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'   ')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1O_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1O_NBANCO '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'U_REBAN("2",M->Z1O_USER) ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'   ')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1O_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1O_AGENCI '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'U_REBAN("3",M->Z1O_USER) ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'   ')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1O_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1O_CONTA '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'U_REBAN("4",M->Z1O_USER) ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'   ')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1P_KM'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1P_VALOR '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	' ' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'U_REKM()   ')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1P_TIPO'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1P_VALOR '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'0' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	' U_KGMET()')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	aAux := FwStruTrigger(;
	'Z1P_TIPO'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1P_KM '                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'0' ,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou nÃ£o antes da execuÃ§Ã£o do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	' U_KGMET()')  // CondiÃ§Ã£o para execuÃ§Ã£o do gatilho (Opcional)

	oStr2:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	oModel:addFields('Z1O',,oStr1)
	oModel:SetPrimaryKey({ 'Z1O_FILIAL', 'Z1O_COD' })


	//üoStr1:SetProperty("Z1O_USER"  	, MODEL_FIELD_WHEN,{|oModel| __CUSERID $ GetMv('ST_REELV',,'000243')})

	oStr2:SetProperty("Z1P_VALOR"  	, MODEL_FIELD_WHEN,{|oModel| u_whenZ1P(oModel,'2')})
	oStr2:SetProperty("Z1P_KM"  	, MODEL_FIELD_WHEN,{|oModel| u_whenZ1P(oModel,'1')})

	//oStr2:SetProperty('Z1P_KM',MODEL_FIELD_WHEN,FWBuildFeature( STRUCT_FEATURE_WHEN, "u_whenZ1P(oModel)"))
	oModel:addGrid('Z1P','Z1O',oStr2,/*bLinePre*/,{|oX| U_Z1PLINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('Z1P')
	oModel:GetModel('Z1P'):SetUniqueLine( { 'Z1P_FILIAL', 'Z1P_COD', 'Z1P_ITEM' } )

	oModel:SetRelation('Z1P', { { 'Z1P_FILIAL', 'Z1O_FILIAL' }, { 'Z1P_COD', 'Z1O_COD' } }, 'Z1P_FILIAL+Z1P_COD+Z1P_ITEM'   )

	oModel:getModel('Z1O'):SetDescription('Z1O')
	oModel:getModel('Z1P'):SetDescription('Z1P')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida��o para inicializador padr�o
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	oModel:AddCalc('CALC1', 'Z1O', 'Z1P', 'Z1P_VALOR', 'CALC1',  'FORMULA' ,,,'Adiantamento:',{|oModel| RetValor(oModel)} ,14,2) // "( A+B )"
	oModel:AddCalc('CALC1', 'Z1O', 'Z1P', 'Z1P_VALOR', 'CALC2', 'SUM',,,'Total Despesas:' )
	oModel:AddCalc('CALC1', 'Z1O', 'Z1P', 'Z1P_VALOR', 'CALC3',  'FORMULA' ,,,'Liquido:',{|oModel| oModel:GetValue("CALC1","CALC2")-oModel:GetValue("CALC1","CALC1") },14,2) // "( A+B )"

	bBloco := {|oModel| U_ARPEREEM(oModel)}
	oModel:SetActivate(bBloco)

Return oModel

User Function KGMET()
	Local oModel :=  FWMODELACTIVE()
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := oModel
	Local oModel4PH  := oModelPai:GetModel('Z1O')
	Local oModel5PH  := oModelPai:GetModel('Z1P')
	Local _nRet:= 0

	_cFarol := .T.

	oModel5PH:SetValue("Z1P_VALOR" , 0)
	oModel5PH:SetValue("Z1P_KM" , 0)

	_cFarol := .F.
Return .F.


User Function REKM()
	Local oModel		:=  FWMODELACTIVE()
	Local nOp  		:= (oModel:getOperation())
	Local oModelPai  	:= oModel
	Local oModel4PH  	:= oModelPai:GetModel('Z1O')
	Local oModel5PH  	:= oModelPai:GetModel('Z1P')
	Local _nRet:= 0
	//>> Chamado 006357 - Everson Santana 23.04.18
	Local _cAlias	:= GetNextAlias()
	Local _cQuery	:= ""
	Local _cTpKM	:= ""

	_cQuery := " SELECT Z1N_KM "
	_cQuery += " FROM " + RetSqlName("Z1N") + " Z1N "
	_cQuery += " WHERE Z1N_USER = '"+__cUserId+"' "
	_cQuery += " AND D_E_L_E_T_ = ' ' "

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_cAlias)

	_cTpKM := (_cAlias)->Z1N_KM

	If Empty(_cTpKM)
		_cTpKM := '8'
	EndIf
	//<< Chamado 006357

	_cFarol := .T.
	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	If 	SX5->(dbSeek(xFilial("SX5") + 'ZY'+_cTpKM))

		_nRet:= Val(ALLTRIM(SX5->X5_DESCRI))
		_nRet:=  _nRet* oModel5PH:GetValue(  'Z1P_KM' )
		If ValType(_nRet) = 'N'
			oModel5PH:SetValue("Z1P_VALOR" , _nRet)
		EndIf
	EndIf
	_cFarol := .F.
Return .F.

User Function whenZ1P(oModel,_cTip)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := oModel
	Local oModel4PH  := oModelPai:GetModel('Z1O')
	Local oModel5PH  := oModelPai:GetModel('Z1P')
	Local  _lRet 	 := .F.
	Local _CRET		 := ' '
	_CRET:= oModelPai:GetValue(  'Z1P_TIPO' )
	If _cTip = '1'
		If "8" = _CRET
			_lRet := .T.
		ElseIf   _cFarol
			_lRet := .T.
		EndIf
	Else
		If "8" <> _CRET
			_lRet := .T.
		ElseIf   _cFarol
			_lRet := .T.
		EndIf
	EndIf
Return (_lRet)


User Function STREEVAL(oView)
	Local _lRet:= .T.
	Local nOp  := oView:oModel:GetOperation()


	If nOp == 4 .Or. nOp == 3
		If !(nOp == 3 )
			If MsgYesNo("Deseja enviar anexo?")
				U_STANEX()
				U_STAPREM()
			EndIf
		EndIf
	EndIf

Return(_lRet)

Static Function RetValor(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := oModel
	Local oModel4PH  := oModelPai:GetModel('Z1O')
	Local oModel5PH  := oModelPai:GetModel('Z1P')
	Local  _nret := 0

	_nret:= oModelPai:GetValue( 'Z1O', 'Z1O_VALOR' )

Return (_nret)

User Function STVALZIO()

	Local oView		:= FwViewActive()
	Local oModel  	:= FWMODELACTIVE()
	Local oModelZ1O := oModel:GetModel('Z1O')
	Local oModelZ1P := oModel:GetModel('Z1P')
	Local  _nret 	:= 0

	oModel:SetValue("CALC1" ,"CALC1" ,oModel:GetValue( 'Z1O', 'Z1O_VALOR' ))

	oModel:SetValue("CALC1" ,"CALC3" ,oModel:GetValue("CALC1","CALC2")-oModel:GetValue("CALC1","CALC1"))

	//oView:Refresh()

Return(.F.)

Static Function IniPad(oModel)

	Local nOp  := oModel:GetOperation()
	Local lIni := .T.

	If nOp == MODEL_OPERATION_INSERT //Cópia também é reconhecida como inser��o

		//oModel:SetValue("Z1P_ITEM" , '001')

	EndIf

Return lIni

User Function STREITEM()
	/*
	Local _cItem	:= "000"
	Local _nItem	:= aScan(aHeader,{|w| AllTrim(w[2])=="Z1P_ITEM"})
	oModel:GetValue("Z1P_ITEM")
	If n >= 1
	_cItem	:= aCols[n,_nItem]
	Endif

	_cItem	:= Soma1(_cItem,3)
	*/
Return('   ')


User Function xMenuPos(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := FWMODELACTIVE()
	Local oModel4PH  := oModelPai:GetModel('Z1O')
	Local oModel5PH  := oModelPai:GetModel('Z1P')
	Local  _nTot	 := 0


	_nTot:= oModel:GetValue("CALC1","CALC2")

	oModel4PH:SetValue("Z1O_TOTAL" ,  _nTot )
	_cFarol    := .f.

Return .T.

User Function Z1PLINE(oModel5PH)
	Local nLine       := oModel5PH:getLine()
	Local nI
	Local lRet        := .T.
	Local ntTot    := 0

	If FwFldGet("Z1P_KM",nLine) == 0     .AND.  FwFldGet("Z1P_TIPO",nLine) = '8'
		Help( ,, 'Help',, 'Tipo Deslocamento, preencher o KM...!!!!!!!', 1, 0 )
		lRet := .F.
	ElseIf FwFldGet("Z1P_KM",nLine) <> 0     .AND.  FwFldGet("Z1P_TIPO",nLine) = '8'

		u_REKM()
	EndIf
	If FwFldGet("Z1P_TIPO",1) = '9'
		If nLine <> 1
			Help( ,, 'Help',, 'Utilize apenas Solicita��o de Adiantamento...!!!!!!!', 1, 0 )
			lRet := .F.
		EndIf
	EndIf
	If FwFldGet("Z1P_TIPO",nLine) = '9'
		If FwFldGet("Z1P_TIPO",1) <> '9'
			Help( ,, 'Help',, 'Utilize apenas Solicita��o de Adiantamento...!!!!!!!', 1, 0 )
			lRet := .F.
		EndIf
	EndIf
	//>> ticket 20190529000007 - Everson Santana - 040619
	If nLine >= 2
		If FwFldGet("Z1P_MOEDA",nLine) <> FwFldGet("Z1P_MOEDA",nLine-1)
			Help( ,, 'Help',, 'Utilize apenas Uma Moeda...!!!!!!!', 1, 0 )
			lRet := .F.
		EndIf
	EndIf
	//<<
	oModel5PH:SetValue("Z1P_ITEM" , PADL(nLine,3,'0')  )

Return lRet

user FUNCTION testTIBrowse()

	DEFINE DIALOG oDlg TITLE "Exemplo TIBrowser" FROM 180,180 TO 550,700 PIXEL

	oTIBrowser := TIBrowser():New(0,0,260,170, "https://www.google.com.br/maps/dir/03821-010+-+Vila+Silvia,+S%C3%A3o+Paulo+-+SP/07041-030+-+Vila+Itapegica,+Guarulhos+-+SP/@-23.4842194,-46.5589324,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x94ce6068e6069c91:0xd1b4fd9835083beb!2m2!1d-46.5009151!2d-23.4903828!1m5!1m1!1s0x94ce5f857b03a3bd:0x8471eeb6837f42b!2m2!1d-46.5500877!2d-23.4859365!3e0", oDlg )
	TButton():New( 172, 002, "Navigate", oDlg,;
	{|| oTIBrowser:Navigate( "https://www.google.com.br/maps/dir/03821-010+-+Vila+Silvia,+S%C3%A3o+Paulo+-+SP/07041-030+-+Vila+Itapegica,+Guarulhos+-+SP/@-23.4842194,-46.5589324,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x94ce6068e6069c91:0xd1b4fd9835083beb!2m2!1d-46.5009151!2d-23.4903828!1m5!1m1!1s0x94ce5f857b03a3bd:0x8471eeb6837f42b!2m2!1d-46.5500877!2d-23.4859365!3e0" ) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 172, 052, "GoHome", oDlg,;
	{|| oTIBrowser:GoHome() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 172, 102, "Print", oDlg,;
	{|| oTIBrowser:Print() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	// Dispon�vel apenas em vers�es superiores a 7.00.170117A - 17.2.0.2
	TButton():New( 172, 152, "GetURL", oDlg,;
	{|| MsgAlert(oTIBrowser:GetURL()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

Return



User Function Navegador()

	Private aPages := {}
	Private nPgVist := -1

	Private aSize := MsAdvSize()
	Private oDlg1, oTIBrw
	Private cNavegado := Space(80)
	Private lcont := .T.
	Private cGetMDe := Space(80)
	Private cGetMAte := Space(80)

	DEFINE MSDIALOG oDlg1 TITLE "Navegador" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	@ 010, 230 Button oBtnIr PROMPT "Ir" Size 40,10 Action( cNavegado:= "https://www.google.com.br/maps/dir/"+Alltrim(cGetMDe) +"/"+Alltrim(cGetMAte),Processa({||Navegar()},"Abrindo","Aguarde...")) Of oDlg1 Pixel
	//@ 010, 390 Button oBtnImp PROMPT "Imprimir" Size 40,10 Action oTIBrw:Print() Of oDlg1 Pixel

	@ 001, 010  Say "Inicio: " Pixel Of oDlg1
	@ 010, 010  MsGet cGetMDe valid !empty(cGetMDe) size 100,10 Picture "@!" pixel OF oDlg1

	@ 001, 120  Say "Termino: " Pixel Of oDlg1
	@ 010, 120  MsGet cGetMAte valid !empty(cGetMAte) size 100,10 Picture "@!" pixel OF oDlg1

	//@ 010, 430 Button oBtnAnte PROMPT "Anterior" Size 40,10 Action (Retorna()) Of oDlg1 Pixel
	@ 010, 470 Button oBtnDep PROMPT "Confirma" Size 40,10 Action(Processa({||Navegar()},"Abrindo","Aguarde...")) Of oDlg1 Pixel
	@ 010, 510 Button oBtnSair PROMPT "Sair" Size 40,10 Action(Sair('2')) Of oDlg1 Pixel

	cNavegado := "https://www.google.com.br/maps/dir/03821-010+-+Vila+Silvia,+S%C3%A3o+Paulo+-+SP/07041-030,+Guarulhos+-+SP/@-23.4788796,-46.5826004,12z/data=!3m1!4b1!4m13!4m12!1m5!1m1!1s0x94ce6068e6069c91:0xd1b4fd9835083beb!2m2!1d-46.5009151!2d-23.4903828!1m5!1m1!1s0x94ce5f857b03a3bd:0x8471eeb6837f42b!2m2!1d-46.5500877!2d-23.4859365"
	// cNavegado := "https://www.google.com.br/maps/dir/"+cGetMDe +"/"+cGetMAte

	oNav:= TGet():New(10,290,{|u| if(PCount()>0,cNavegado:=u,cNavegado)}, oDlg1,140,5,,,,,,,,.t.,,,,,,,,,,)
	oTIBrw:= TIBrowser():New( 025,010,aSize[5]-640, 270,  cNavegado, oDlg1 )

	aaDD(aPages, cNavegado)

	oNav:bLostFocus := { || Valido()}


	Activate MsDialog oDlg1 Centered

Return (.F.)

Static Function Valido()

	Ir()

Return .T.



Static Function Navegar()

	Ir()

Return


Static Function Ir()

	oTIBrw:Navigate(AllTrim(cNavegado),oDlg1)
	aaDD(aPages,AllTrim(cNavegado))
	nPgVist := Len(aPages)

Return



Static Function Avanca()

	if(Len(aPages) >      nPgVist .and. Len(aPages) > 1 )
		nPgVist++
		oTIBrw:Navigate(aPages[nPgVist],oDlg1)
		cNavegado := aPages[nPgVist]
		oNav:Refresh()
	EndIf

Return

Static Function Retorna()
	if(nPgVist>1)
		nPgVist--
		oTIBrw:Navigate(aPages[nPgVist],oDlg1)
		cNavegado := aPages[nPgVist]
		oNav:Refresh()
	EndIf

Return

Static Function Sair()
	oDlg1:End()
Return

User Function STANEX(_lT)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declara��o das Vari�veis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea       := GetArea()
	Local aArea1      := Z1O->(GetArea())

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
	Local cSolicit	  := 	Z1O->Z1O_COD

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\REEMBOLSO\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+Z1O->Z1O_XFIL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Grava��o do Reembolso...!!!!")
			Return()
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria��o das pastas para salvar os anexos das Solicitações de Compras no Servidor
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cFil
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

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

		DbSelectArea("Z1O")
		Z1O->(DbSetOrder(1))//Z1O_FILIAL+Z1O_COD+Z1O_ITEM
		If Z1O->(DbSeek(xFilial("Z1O")+Z1O->Z1O_STATUS+cSolicit))
			dDtEmiss   := Z1O->Z1O_EMISSA
			cNameSolic := Z1O->Z1O_NOME  //USRRETNAME(Z1O->Z1O_USER)

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("Z1O") when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Data SC" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "Nº SC" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Solicitante" COLOR CLR_BLACK   Of oDxlg Pixel
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
	Local aArea2    := Z1O->(GetArea())

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
					dbSelectArea("Z1O")
					Z1O->(dbGoTop())
					While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
						RecLock("Z1O", .F.)
						Z1O->Z1O_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
						Z1O->(MsUnlock())
						Z1O->( dbSkip() )
					End
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
	Local aArea2   := Z1O->(GetArea())

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
		dbSelectArea("Z1O")
		Z1O->(dbGoTop())
		While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
			RecLock("Z1O", .F.)
			Z1O->Z1O_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
			Z1O->(MsUnlock())
			Z1O->( dbSkip() )
		End
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
	Local _cStartPath1 := "REEMBOLSO\"
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

	_cLocalDir += _cEmp
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

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



