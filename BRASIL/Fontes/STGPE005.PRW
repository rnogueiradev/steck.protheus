#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'TbiConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGPE005   ºAutor  ³Richard N Cabral    º Data ³  20/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao Cadastro de % Atingimento x % Comissao           º±±
±±º          ³ por Segmento de Vendedores                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STGPE005()	//U_STGPE005()

	Local oBrowse

	Private aRotina := MenuDef()

//	DbSelectArea("SZL")
//	SZL->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZL")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Variáveis de Comissão")      // Descrição do browse

	//oBrowse:SetUseCursor(.F.)
	//oBrowse:DisableDetails()

	oBrowse:Activate()
	
Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.STGPE005"	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.STGPE005"	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.STGPE005"	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.STGPE005"	OPERATION 5 ACCESS 0
//	ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.STGPE005"	OPERATION 8 ACCESS 0
//	ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.STGPE005"	OPERATION 9 ACCESS 0
	
Return aRotina

Static Function ModelDef()

	Local oModel
	Local oStr1   := FWFormStruct(1,'SZL')
	Local oStr2   := FWFormStruct(1,'SZG')
	Local bCommit	:= { |oModel| U_ST001ProcComm( oModel ) }

	oModel := MPFormModel():New( "STGPE05", /*bPreVld*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ )

	oModel:SetDescription('Variaveis de Comissão')

	oModel:addFields('CABEC',,oStr1)
	oModel:addGrid('ITENS','CABEC',oStr2)

	oModel:SetRelation('ITENS', { { 'ZG_FILIAL', 'ZL_FILIAL' }, { 'ZG_CODTAB', 'ZL_CODTAB' } }, SZG->(IndexKey(1)) )

	//oModel:SetPrimaryKey({})
	oModel:SetPrimaryKey({ 'ZG_FILIAL', 'ZG_CODTAB' })

	oModel:GetModel('CABEC'):SetDescription('Cabecalho')
	oModel:GetModel('ITENS'):SetDescription('Itens')

Return oModel

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'SZL')
	Local oStr2:= FWFormStruct(2, 'SZG')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('CABEC' , oStr1,'CABEC' )
	oView:AddGrid('ITENS' , oStr2,'ITENS')
	oView:CreateHorizontalBox( 'BOXCABEC', 20)
	oView:CreateHorizontalBox( 'BOXITENS', 80)
	oView:SetOwnerView('ITENS','BOXITENS')
	oView:SetOwnerView('CABEC','BOXCABEC')

	//oView:AddIncrementField('ITENS', 'SZG_ITEM' )

Return oView

//Static Function ValModel(oModel)
//
//	Local nQtdLine	:= oModel:GetQtdLine()
//	Local nLine		:= 0
//
//Return(.T.)

