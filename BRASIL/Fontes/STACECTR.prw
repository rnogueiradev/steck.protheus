#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDef.ch'

#DEFINE CR    chr(13)+chr(10)

#Define ALIASM		"Z78" //Alias Master
#Define MDLTITLE	"Controle de Acesso aos Relatorios STFATR03/STFLRE02"
#Define MDLDATA 	"MDLACECT"
#Define MDLMASTER	"Z78_MASTER"

/*/{Protheus.doc} STACECTR

Controle de Acesso aos Relatorios STFATR03/STFLRE02

@type function
@author Everson Santana
@since 08/02/19
@version Protheus 12 - Faturamento

@history ,Ticket 20200812005610 ,

/*/

User Function STACECTR()

    Local _oBrowse := FWMBrowse():New()
    
    _oBrowse:SetAlias(ALIASM)
    _oBrowse:SetDescription(MDLTITLE)

    //Legendas do Browse
    _oBrowse:AddLegend( "Z78_MSBLQL == '2'", "GREEN", "Acesso Liberado"  )
    _oBrowse:AddLegend( "Z78_MSBLQL == '1'", "RED"  , "Acesso Bloqueado" )

    _oBrowse:Activate()

Return Nil

Static Function MenuDef()
    Local _aRotina := {}

	/*>> Everson Santana - 08/08/2017
	OPERATION
	1 - Pesquisa
	2 - Visualizar
	3 - Incluir
	4 - Alterar
	5 - Exclui
	<<*/

	ADD OPTION _aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"         	OPERATION 1 ACCESS 0
	ADD OPTION _aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.STACECTR" 	OPERATION 2 ACCESS 0
	ADD OPTION _aRotina TITLE "Incluir"    		ACTION "VIEWDEF.STACECTR"	OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Alterar"    		ACTION "VIEWDEF.STACECTR"	OPERATION 4 ACCESS 0
	ADD OPTION _aRotina TITLE "Excluir"    		ACTION "VIEWDEF.STACECTR" 	OPERATION 5 ACCESS 0
    //ADD OPTION _aRotina TITLE "Excluir"    		ACTION "VIEWDEF.STACECTR" 	OPERATION 6 ACCESS 0

Return _aRotina
 
Static Function ModelDef()
    Local _oStrutMaster	:= FWFormStruct(1, ALIASM, /**/, /*lViewUsado*/)
	Local _oModel 		:= MPFormModel():New(MDLDATA, /*bPreValidacao*/, /*bPost*/,/*bCommit*/, /*bCancel*/)
	
	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	//>> Ponto de Entrada
	_oModel	:=	MpFormModel():New("PESTACECTR",/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
	//<<

	_oModel:AddFields(MDLMASTER, /*cOwner*/, _oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	_oModel:GetModel(MDLMASTER):SetDescription("Cadastro")
	_oModel:SetDescription(MDLTITLE)
	_oModel:SetPrimaryKey({ "Z78_FILIAL","Z78_ROTINA","Z78_CODUSR"})

Return _oModel
 
 
Static Function ViewDef()

    Local _oStrutMaster 	:= FWFormStruct(2, ALIASM, /**/)
	Local _oModel   	 	:= FWLoadModel("STACECTR")
	Local _oView		 	:= FWFormView():New()

	_oView:SetModel(_oModel)
	_oView:AddField("VIEW_MASTER", _oStrutMaster, MDLMASTER)
	_oView:SetCloseOnOk({|| .T.})

Return _oView