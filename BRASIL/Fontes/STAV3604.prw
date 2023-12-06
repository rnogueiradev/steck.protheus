#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Include 'FWEditPanel.ch'

#Define ALIASM		"Z33" //Alias Master
#Define MDLTITLE	"Avaliar"
#Define MDLDATA 	"MDLAV3604"
#Define MDLMASTER	"Z33_MASTER"

/*/{Protheus.doc} STAV3604

Cadastros de Participantes FEEDBACK 360

@type function
@author Everson Santana
@since 07/08/17
@version Protheus 12 - Gestão de Pessoal

@history , ,

/*/

User Function STAV3604()

	Local aArea1    := GetArea()
	Local _oBrowse := FWMBrowse():New()
	Local _cFiltro  := " "

	DbSelectArea("Z33")
	Z33->(DbSetOrder(1))

	If __cUserId $ "000952"

		Z33->(dbSetFilter({|| Z33->Z33_USRAVA = __cUserId .OR. Z33->Z33_USRAVA = "001256" },'Z33->Z33_USRAVA = __cUserId .OR. Z33->Z33_USRAVA = "001256"' ))

	Else

		Z33->(dbSetFilter({|| Z33->Z33_USRAVA = __cUserId },'Z33->Z33_USRAVA = __cUserId' ))

	EndIf

	_oBrowse:SetAlias("Z33")
	_oBrowse:SetWalkThru(.F.)
	_oBrowse:SetAmbiente(.F.)
	_oBrowse:SetUseFilter(.T.)
	_oBrowse:SetDescription(MDLTITLE)
	_oBrowse:SetFilterDefault( _cFiltro )
	//Legendas do Browse
	_oBrowse:AddLegend( "Z33_STATUS == '2'", "GREEN", "Aguardando FEEDBACK"  )
	_oBrowse:AddLegend( "Z33_STATUS == '1'", "RED"  , "Avaliado" )
	_oBrowse:DisableDetails()
	_oBrowse:Activate()

	RestArea(aArea1)

Return Nil
/*
Define o menu da rotina
*/
Static Function MenuDef()

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _aRotina := {}

	/*>> Everson Santana - 08/08/2017
	OPERATION
	1 - Pesquisa
	2 - Visualizar
	3 - Incluir
	4 - Alterar
	5 - Exclui
	<<*/
	If !Empty(_cProgram)
	//ADD OPTION _aRotina TITLE "Pesquisar"  ACTION "PesqBrw"         OPERATION 1 ACCESS 0
	ADD OPTION _aRotina TITLE "Resultado" ACTION "U_STAV360R" OPERATION 3 ACCESS 0
	//ADD OPTION _aRotina TITLE "Incluir"    ACTION "VIEWDEF.STAV360"	OPERATION 3 ACCESS 0
	//ADD OPTION _aRotina TITLE "Alterar"    ACTION "VIEWDEF.STAV360"	OPERATION 4 ACCESS 0
	//ADD OPTION _aRotina TITLE "Excluir"    ACTION "VIEWDEF.STAV360" OPERATION 5 ACCESS 0
	ADD OPTION _aRotina TITLE "Avaliar"    ACTION "U_STAV3605" OPERATION 4 ACCESS 0
	EndIf
Return _aRotina
/*
Define o modelo da rotina
*/
Static Function ModelDef()

	Local _oStrut	:= FWFormStruct(1,'Z33',{|X|ALLTRIM(X)$"Z33_ANO,Z33_MAT,Z33_NOMFU,Z33_XFILFU,Z33_XEMPFU,Z33_USER"})
	Local _oStrut2	:= FWFormStruct(1,'Z34') //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local _oModel

	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	//>> Ponto de Entrada
	_oModel	:=	MpFormModel():New("PESTAV360",/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
	//<<

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	_oModel:AddFields('M_Z33', /*cOwner*/, _oStrut, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	_oModel:SetDescription(MDLTITLE)

	//Adiciona um Modelo de Grid similar à MsNewGetDados, BrGetDb
	_oModel:AddGrid( 'M_Z34', 'M_Z33', _oStrut2,  /*bLinePre*/ , /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	_oModel:SetRelation( 'M_Z34', {	{ 'Z34_FILIAL'	, 'xFilial( "Z34")' },;
		{ 'Z34_ANO' 	, 'Z33_ANO'  },;
		{ 'Z34_MAT' 	, 'Z33_MAT'  },;
		{ 'Z34_XEMPFU' 	, 'Z33_XEMPFU'},;
		{ 'Z34_XFILFU' 	, 'Z33_XFILFU'} ,;
		{ 'Z34_USER' 	, 'Z33_USER'}} ,;
		'Z34_ANO+Z34_MAT+Z34_XEMPFU+Z34_XFILFU' )

	//Liga o controle de não repetição de Linha
	_oModel:GetModel( 'M_Z33' ):SetPrimaryKey( { 'Z33_FILIAL','Z33_ANO','Z33_MAT' } )

	//Adiciona Descricao dos Componentes do Modelo de Dados
	_oModel:GetModel( 'M_Z33' ):SetDescription( 'Avalidado' )
	_oModel:GetModel( 'M_Z34' ):SetDescription( 'Participantes Respostas' )

Return _oModel
/*
Define a view da rotina
*/
Static Function ViewDef()

	Local _oStrut 	:= FWFormStruct(2,'Z33',{|X|ALLTRIM(X)$"Z33_ANO,Z33_MAT,Z33_NOMFU,Z33_XFILFU,Z33_XEMPFU,Z33_USER"})
	Local _oStrut2	:= FWFormStruct(2,'Z34',{|X|ALLTRIM(X)$"Z34_USRAVA,Z34_MATAVA,Z34_XFILIA,Z34_XEMP,Z34_QUESTA,Z34_RESTP1,Z34_RESTP2,Z34_RESTP3"}) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local _oModel   	 	:= FWLoadModel("STAV3604")
	Local _oView		 	:= FWFormView():New()

	//Define o Preenchimento da Janela
	_oView:CreateHorizontalBox( 'ID_HBOX_SUPERIOR',25)
	_oView:CreateHorizontalBox( 'ID_HBOX_INFERIOR',75)

	_oView:SetModel(_oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	_oView:AddField('V_Z33'  , _oStrut ,'M_Z33' )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	_oView:AddGrid(  'V_Z34', _oStrut2, 'M_Z34')

	// Relaciona o ID da View com o "box" para exibicao
	_oView:SetOwnerView( 'V_Z33' , 'ID_HBOX_SUPERIOR' 	)
	_oView:SetOwnerView( 'V_Z34' , 'ID_HBOX_INFERIOR' 		)

	_oView:SetCloseOnOk({|| .T.})

Return _oView




