#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT310        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT310()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("Z63")
	Z63->(DbSetOrder(1))

	DbSelectArea("Z64")
	Z64->(DbSetOrder(1))

	DbSelectArea("Z65")
	Z65->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z63")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro de solicitações de verbas")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:AddLegend("Z63_STATUS=='1'"  ,"BLACK"      	,"Pendente MKT (Análise)")
	oBrowse:AddLegend("Z63_STATUS=='2'"  ,"RED"      	,"Pendente cliente (Comprovante)")
	oBrowse:AddLegend("Z63_STATUS=='3'"  ,"ORANGE"      ,"Pendente MKT (Comprovante)")
	oBrowse:AddLegend("Z63_STATUS=='4'"  ,"BLUE"      	,"Pendente financeiro")
	oBrowse:AddLegend("Z63_STATUS=='5'"  ,"GREEN"      	,"Finalizado")
	//oBrowse:DisableDetails()
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

	ADD OPTION aRotina TITLE 'Pesquisar'  							ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 							ACTION "VIEWDEF.STFAT310" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    							ACTION "VIEWDEF.STFAT310" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    							ACTION "VIEWDEF.STFAT310"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    							ACTION "VIEWDEF.STFAT310"	OPERATION 3  ACCESS 0 //"Incluir"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc monta model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z63')
	Local oStr2:= FWFormStruct(1,'Z64')
	Local oStr3:= FWFormStruct(1,'Z65')
	Local _aRel	:= {}
	Local _aRel1	:= {}

	oModel := MPFormModel():New("MOD03XFORM",/*{|oModel|VLDALT(oModel)}*/,{|oModel|TUDOOK(oModel)}/*,{|oModel|PC8INC(oModel)}*/)

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)
	oModel:addGrid('GRID2','FIELD1',oStr3,,)

	aAdd(_aRel, { 'Z64_FILIAL', 'Z63_FILIAL' } )
	aAdd(_aRel, { 'Z64_NUMERO', 'Z63_NUMERO' } )

	oModel:SetRelation('GRID1', _aRel , Z64->(IndexKey(1)) )
	oModel:GetModel('GRID1'):SetUniqueLine({"Z64_CODIGO"})

	aAdd(_aRel1, { 'Z65_FILIAL'	, 'Z64_FILIAL' 	} )
	aAdd(_aRel1, { 'Z65_NUMERO'	, 'Z64_NUMERO' 	} )
	aAdd(_aRel1, { 'Z65_ACAO'  	, 'Z64_ACAO' 	} )

	oModel:SetRelation('GRID2', _aRel1 , Z65->(IndexKey(3)) )
	oModel:GetModel('GRID2'):SetUniqueLine({"Z65_ACAO","Z65_ITEM"})

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Solicitação')
	oModel:getModel('GRID1'):SetDescription('Ações')
	oModel:getModel('GRID2'):SetDescription('Itens')

	//oStr2:SetProperty('PC9_SEQDES',MODEL_FIELD_INIT,"")
	//oStr2:SetProperty('PC9_ITEM',MODEL_FIELD_INIT,"")

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc monta view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	//Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'Z63')
	Local oStr2:= FWFormStruct(2, 'Z64')
	Local oStr3:= FWFormStruct(2, 'Z65')
	Local oModel     := FWLoadModel("STFAT310")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')
	oView:AddGrid('FORM2' , oStr3,'GRID2')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 35)
	oView:CreateHorizontalBox( 'BOXFORM2', 35)

	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM2','BOXFORM2')

	//Habilitando título
	oView:EnableTitleView('FORM3','Ações')
	oView:EnableTitleView('FORM1','Solicitação')
	oView:EnableTitleView('FORM2','Itens')

	// habilita a barra de controle
	oView:EnableControlBar(.T.)

	//verificar se a janela deve ou não ser fechada após a execução do botão OK
	oView:SetCloseOnOk({|| .T.})

	//Campo sequencial
	//oView:AddIncrementField( 'FORM3', 'PC9_ITEM' )

Return oView

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc tudo ok do pedido de venda
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)
