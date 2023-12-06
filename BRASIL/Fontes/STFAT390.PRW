#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} STFAT390
@name STFAT390
@type User Function
@desc manutenção de contratos de vendas
@author Renato Nogueira
@since 12/06/2023
/*/

User Function STFAT390()

	Local oBrowse
	Private aRotina := MenuDef()
	PRIVATE BSTAFUN001 := {||STFAT390A()}
	PRIVATE BSTAFUN002 := {||STFAT390C()}

	DbSelectArea("Z73")
	Z73->(DbSetOrder(1))

	DbSelectArea("Z74")
	Z74->(DbSetOrder(1))

	If !(__cUserId $ GetMv("STFAT3901",,"000000#000010#000641"))
		MsgAlert("Usuário sem acesso!")
		Return
	EndIf

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z73")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro de contratos")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  							ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 							ACTION "VIEWDEF.STFAT390" OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    							ACTION "VIEWDEF.STFAT390" OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    							ACTION "VIEWDEF.STFAT390"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    							ACTION "VIEWDEF.STFAT390"	OPERATION 3  ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imp. NOVA Planilha"				ACTION "Eval(BSTAFUN001)"	OPERATION 9  ACCESS 0
	ADD OPTION aRotina TITLE "Atualizar Planilha"				ACTION "Eval(BSTAFUN002)"	OPERATION 9  ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()
	Local oStr1:= FWFormStruct(1,'Z73')
	Local oStr2:= FWFormStruct(1,'Z74')
	Local _aRel	:= {}
	PRIVATE oModel

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})
	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)

	aAdd(_aRel, { 'Z74_FILIAL'	, 'Z73_FILIAL' } )
	aAdd(_aRel, { 'Z74_CODIGO'	, 'Z73_CODIGO' } )

	oModel:SetRelation('GRID1', _aRel , Z74->(IndexKey(1)) )

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')
	oModel:getModel('GRID1'):SetDescription('Itens')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()
	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'Z73')
	Local oStr2:= FWFormStruct(2, 'Z74')
	Local oModel     := FWLoadModel("STFAT390")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 70)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM3','BOXFORM3')

	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	//Local nOp := oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	//Local nOp         := oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT391
@name STFAT391
@type User Function
@desc consulta dos contratos
@author Renato Nogueira
@since 12/06/2023
/*/

User Function STFAT391(_cCliente,_cLoja,_cProduto)

	//Local _cAlias1 	:= "STFAT391"
	//Local _cQuery1 	:= ""
	Local aRetorno   := {}
	Local nTot       := 0
	Local cTabQry    := GetNextAlias()
	Local cQuery     := ""
	Local cQryFim    := ""
	Local oStateZ74
	Local aComb      :={}
	Local aCpos      :={}
	Local nx         :=0
	Local ny         :=0
	Local cQryAdd    :=""
	Local cGrupo     :=""
	Local cFamilia   :=""

	SB1->(DBSETORDER(1))
	IF SB1->(DBSEEK(XFILIAL('SB1')+_cProduto))
		cGrupo:=SB1->B1_GRUPO
		SBM->(DBSETORDER(1))
		IF SBM->(DBSEEK(XFILIAL('SBM')+SB1->B1_GRUPO))
			cFamilia:=SBM->BM_XAGRUP2
		ENDIF
	ENDIF

	cQuery := " SELECT Z73_CODIGO,Z74_PRECO,Z74_DESCON
	cQuery += " FROM "+RetSqlName("Z73")+" Z73
	cQuery += " LEFT JOIN "+RetSqlName("Z74")+" Z74
	cQuery += " ON Z73_FILIAL=Z74_FILIAL AND Z73_CODIGO=Z74_CODIGO
	cQuery += " WHERE Z73.D_E_L_E_T_=' ' AND Z74.D_E_L_E_T_=' '
	cQuery += " AND Z73_CODCLI='"+_cCliente+"' AND Z73_LOJCLI='"+_cLoja+"'
	cQuery += " AND '"+DTOS(Date())+"' BETWEEN Z73_DTDE AND Z73_DTATE
	cQuery += " AND (Z74_PROD = '"+_cProduto+"' OR Z74_PROD = ' ')
	cQuery += " AND (Z74_GRUPO = '"+cGrupo+"' OR Z74_GRUPO = ' ')
	cQuery += " AND (Z74_FAMILI = '"+cFamilia+"' OR Z74_FAMILI = ' ')
	cQuery += " ORDER BY Z74_PROD DESC ,Z74_GRUPO DESC ,Z74_FAMILI DESC

	oStateZ74 := FWPreparedStatement():New()
	oStateZ74:SetQuery(cQuery)
	cQryFim    := oStateZ74:getFixQuery()
	MPSysOpenQuery(cQryFim,cTabQry)
	oStateZ74:Destroy()
	nTot := Contar(cTabQry,"!Eof()")
	(cTabQry)->(DbGoTop())
	If nTot > 0
		AADD(aRetorno,{(cTabQry)->Z74_PRECO,(cTabQry)->Z74_DESCON,(cTabQry)->Z73_CODIGO})
	Endif
	(cTabQry)->(DbCloseArea())

Return (aRetorno)



STATIC FUNCTION STFAT390A()
	PRIVATE oBtOk
	PRIVATE oBtSair
	PRIVATE oCodCli
	PRIVATE cCodCli := SPACE(06)
	PRIVATE oLoja
	PRIVATE cLoja := SPACE(02)
	PRIVATE oNomCli
	PRIVATE cNomCli := SPACE(100)
	PRIVATE oDtIni
	PRIVATE cDtIni := STOD("")
	PRIVATE oDtFim
	PRIVATE cDtFim := STOD("")
	PRIVATE oComboBo2
	PRIVATE nComboBo2 := 1
	PRIVATE oListBox1
	PRIVATE nListBox1 := 1
	PRIVATE oObs
	PRIVATE cObs := SPACE(1000)
	STATIC oDlg1

	DEFINE MSDIALOG oDlg1 TITLE "Importação de Contratos" FROM 000, 000  TO 360, 700 PIXEL

	@ 025, 010 SAY "Código do Cliente:" SIZE 045, 007 OF oDlg1 PIXEL
	@ 023, 060 MSGET oCodCli VAR cCodCli SIZE 030, 010 VALID(STFAT390D("cCodCli")) OF oDlg1 F3 "SA1"  PIXEL
	@ 023, 104 MSGET oLoja   VAR cLoja   SIZE 014, 010 VALID(STFAT390D("cLoja"))   OF oDlg1 PIXEL
	@ 023, 128 MSGET oNomCli VAR cNomCli SIZE 208, 010 OF oDlg1 PIXEL WHEN .F.
	@ 040, 010 SAY "Vigência De:" SIZE 034, 007 OF oDlg1 PIXEL
	@ 038, 044 MSGET oDtIni VAR cDtIni SIZE 040, 010 VALID(STFAT390D("cDtIni")) OF oDlg1 PIXEL
	@ 040, 095 SAY "Vigência Até:" SIZE 034, 007 OF oDlg1 PIXEL
	@ 038, 129 MSGET oDtFim VAR cDtFim SIZE 040, 010 VALID(STFAT390D("cDtFim")) OF oDlg1 PIXEL
	@ 040, 182 SAY "Obrigatório:" SIZE 031, 007 OF oDlg1 PIXEL
	@ 038, 215 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS {"Não","Sim"} SIZE 032, 010 OF oDlg1 PIXEL
	@ 057, 010 GET oObs VAR cObs SIZE 329, 065 OF oDlg1 PIXEL
	@ 135, 029 BUTTON oBtSair PROMPT "Fechar"    SIZE 037, 012 OF oDlg1 ACTION(oDlg1:End()) PIXEL
	@ 135, 086 BUTTON oBtOk   PROMPT "Confirmar" SIZE 037, 012 OF oDlg1 ACTION(IIF(STFAT390B()=.T.,oDlg1:End(),""))PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

RETURN

STATIC FUNCTION STFAT390B()
	LOCAL lRet := .F.
	LOCAL lContinua := .T.
	LOCAL cCodCon := ""

	IF EMPTY(cCodCli)
		MSGALERT("Código do Cliente não informado!")
		lContinua := .F.
	ENDIF
	IF EMPTY(cDtIni)
		MSGALERT("Início da vigência não informado!")
		lContinua := .F.
	ENDIF

	IF EMPTY(cDtFim)
		MSGALERT("Fim da vigência não informado!")
		lContinua := .F.
	ENDIF

	IF lContinua = .T.
		IF MSGYESNO("Deseja Incluir e importar a tabela de preço")
			cCodCon := GetSX8Num("Z73","Z73_CODIGO")
			Z73->(DBSETORDER(1))
			RECLOCK("Z73",.T.)
			Z73->Z73_FILIAL := XFILIAL("Z73")
			Z73->Z73_CODIGO := cCodCon
			Z73->Z73_CODCLI := cCodcli
			Z73->Z73_LOJCLI := cLoja
			Z73->Z73_NOMCLI := cNomCli
			Z73->Z73_DTDE   := cDtIni
			Z73->Z73_DTATE  := cDtFim
			Z73->Z73_OBS    := cObs
			Z73->Z73_CONTRA := IIF(oComboBo2:NAT = 1,"N","S")
			Z73->(MSUNLOCK())
			CONFIRMSX8()
			U_STFATZ74(cCodCon)
			lRet := .T.
		ENDIF
	ENDIF
RETURN lRet

STATIC FUNCTION STFAT390C()

	IF MSGYESNO("Deseja Atualizar a tabela de preço")
		U_STFATZ74(Z73->Z73_CODIGO)
	ENDIF
RETURN

STATIC FUNCTION STFAT390D(cCampo)
	LOCAL lRet := .T.

	IF cCampo = "cCodCli"
		IF EMPTY(cCodCli)
			MSGALERT("Código do Cliente não Cadastrado!")
			cCodCli := SPACE(06)
			lRet := .F.
		ELSE
			SA1->(DBSETORDER(1))
			IF !SA1->(DBSEEK(XFILIAL("SA1")+cCodCli))
				MSGALERT("Código do Cliente não Cadastrado!")
				cCodCli := SPACE(06)
				lRet := .F.
			ENDIF
		ENDIF
	ELSEIF cCampo = "cLoja"
		IF EMPTY(cLoja)
			MSGALERT("Loja do Cliente não Cadastrado!")
			cLoja := SPACE(02)
			lRet := .F.
		ELSE
			SA1->(DBSETORDER(1))
			IF !SA1->(DBSEEK(XFILIAL("SA1")+cCodCli+cLoja))
				MSGALERT("Código / Loja do Cliente não Cadastrado!")
				lRet := .F.
			ELSE
				cNomCli := SA1->A1_NOME
			ENDIF

		ENDIF
	ELSEIF cCampo = "cDtIni"
		IF EMPTY(cDtIni)
			MSGALERT("Informe a Data de Início da vigência")
			lRet := .F.
		ENDIF
	ELSEIF cCampo = "cDtFim"
		IF EMPTY(cDtFim)
			MSGALERT("Informe a Data de Encerramento da vigência")
			lRet := .F.
		ENDIF
	ENDIF

	oCodCli:REFRESH()
	oLoja:REFRESH()
	oNomCli:REFRESH()
	oDtIni:REFRESH()
	oDtFim:REFRESH()

RETURN
