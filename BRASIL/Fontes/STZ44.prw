#include 'FWMVCDEF.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  STZ44     บAutor  ณGiovani Zago    บ Data ณ  18/07/19    	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		MVC PADRAO PARA CADASTRO SIMPLES 1 TABELA             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STZ44()

	Local aArea1    := GetArea()
	Local aArea2    := Z44->(GetArea())
	Local _cAlias1  := "Z44"
	Local _cFiltro  := " "
	Private cTitle  := "Dados Logisticos Clientes"
	Private cChaveAux := ""
	Private _cGrp   := ' '
	Private _cCID   := "MODZ44"
	Private _cSSID  := "STZ44"
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias(_cAlias1)

	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDescription(cTitle)

	oBrowse:SetFilterDefault( _cFiltro )

	//oBrowse:AddLegend("ZH_STATUS=='1'" ,"BLUE"  ,"Inativo")

	oBrowse:DisableDetails()

	oBrowse:Activate()

	RestArea(aArea2)
	RestArea(aArea1)

Return


Static Function MenuDef(_cSSID)

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOp็๕es padr๕es do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Op็๕es Customizadas
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"         OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STZ44" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.STZ44" OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STZ44" OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.STZ44" OPERATION 5  ACCESS 0 
	Endif
Return aRotina


Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "Z44")// Constru็ใo de estrutura de dados
	Local oModel
	Local _cTitulo   := cTitle
	Local _cCabec    := cTitle

	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)

	oModel:SetPrimaryKey({})
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel


Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "Z44")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")

	oView:CreateHorizontalBox("SUPERIOR", 100)

	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")

	oView:SetCloseOnOk({||.T.})

	oView:EnableTitleView("VIEW_CABEC")


Return oView



Static Function IniPad(oModel)

	Local lIni := .T.

Return lIni


Static Function VldAcess(oModel)

	Local lAcess    := .T.




Return (lAcess)


Static Function VldTOK( oModel )

	Local lVld        := .T.


Return lVld


Static Function GrvTOK( oModel )

	Local nOp         := oModel:GetOperation()
	Local lGrv        := .T. 

	FWFormCommit( oModel )


Return lGrv



