#include 'FWMVCDEF.ch'
#include 'TOTVS.ch'
#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  STZ2B     ºAutor  ³Giovani Zago    º Data ³  03/03/20     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		MVC PADRAO PARA CADASTRO SIMPLES 1 TABELA              º
±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STZ2B()

	Local aArea1    := GetArea()
	Local aArea2    := Z2B->(GetArea())
	Local _cAlias1  := "Z2B"
	Local _cFiltro  := " "
	Private cTitle  := "Clientes sem Reajuste"
	Private _cCID   := "MODZ2B"
	Private _cSSID  := "STZ2B"
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Opções padrões do MVC
	// 1 para Pesquisar
	// 2 para Visualizar
	// 3 para Incluir
	// 4 para Alterar
	// 5 para Excluir
	// 6 para Imprimir
	// 7 para Copiar
	// 8 Opções Customizadas
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"         OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STZ2B" OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.STZ2B" OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STZ2B" OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.STZ2B" OPERATION 5  ACCESS 0
	Endif
Return aRotina

Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "Z2B")// Construção de estrutura de dados
	Local oModel
	Local _cTitulo   := cTitle
	Local _cCabec    := cTitle
	Local _aRet		 := {}
	Local _aRetx	 := {}
	Local i			 := 0

	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	//_aRet := oStruCabec:GetFields()

	//	For i:=1 To Len(_aRet)
	//	oStruCabec:SetProperty(Alltrim(_aRet[i,3])  , MODEL_FIELD_WHEN,{|| .F. })
	//Next i

	//oStruCabec:SetProperty(Alltrim( "Z2B_XSTATU") 	, MODEL_FIELD_WHEN,{|| .T. })
	//oStruCabec:SetProperty(Alltrim( "Z2B_OBS") 		, MODEL_FIELD_WHEN,{|| .T. })

	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)

	oModel:SetPrimaryKey({})
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel

Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "Z2B")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView
	Local _aRet		 := {}
	Local _aRetx	 := {}
	Local i			 := 0

	oView := FWFormView():New()
	oView:SetModel(oModel)

	_aRet := oStruCabec:GetFields()

	For i:=1 To Len(_aRet)
	//If !( Alltrim(_aRet[i,1]) $  'Z2B_XSTATU/Z2B_OBS')
	Aadd(_aRetx,{ Alltrim(_aRet[i,1]) ,' '})
	//EndIf
	Next i

	For i:=1 To Len(_aRetx)
	//	oStruCabec:RemoveField( Alltrim(_aRetx[i,1]))
	Next i

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

User Function STXZ2B(_cCod,_cLoja)
	Local _cRet := '001'

	DbSelectArea("Z2B")
	Z2B->(DbSetOrder(1))
	If Z2B->(DbSeek(xFilial("Z2B")+_cCod+_cLoja) )  .Or. Z2B->(DbSeek(xFilial("Z2B")+_cCod+'XX') )
	If dDataBase <= Z2B->Z2B_DATA
	If !(Empty(Alltrim(Z2B->Z2B_CODTAB)))
	_cRet:= Alltrim(Z2B->Z2B_CODTAB)
	Else
		_cRet:= '911'
	EndIf
	EndIf
	EndIf
Return(_cRet)
//  U_STXZ2B(M->UA_CLIENTE,M->UA_LOJA)
//  Iif( __cUserId $ '000645/000231',U_STXZ2B(M->UA_CLIENTE,M->UA_LOJA),'001')

