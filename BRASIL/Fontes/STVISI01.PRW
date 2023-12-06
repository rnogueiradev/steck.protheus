#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STVISI01       | Autor | GIOVANI.ZAGO             | Data | 09/10/2017    |
|=====================================================================================|
|Sintaxe   | STVISI01                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STVISI01()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_VISI01',,'000000/000645/000210')
	Private _lPartic := .T.
	Private _xSuper   := Z1RSu(__cUserId)
	DbSelectArea("Z1R")

	Z1R->(DbSetOrder(1))
	Z1R->(dbSetFilter({|| Z1R->Z1R_USER = __cUserId .Or.   Z1R->Z1R_VEND $ _xSuper   },'Z1R->Z1R_USER = __cUserId  .Or.   Z1R->Z1R_VEND $ _xSuper  '))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1R")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STVISI01")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Usuarios Visitas")   	// Descrição do browse
	oBrowse:Activate()

Return(Nil)

Static Function Z1RSu(_cUsz)
	Local _cCod  := ''
	Local _cSup  := ''

	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cUserId)) .And. SUBSTR(SA3->A3_COD,1,1) = 'S'
		_cSup := SA3->A3_COD

		DbSelectArea('SA3')
		SA3->(DbSetOrder(1))
		SA3->(DbGoTop())
		While SA3->(!eof())
			If SA3->A3_SUPER = _cSup

				_cCod+= SA3->A3_COD+"/"

			EndIf
			SA3->(Dbskip())
		End

	EndIf

return(_cCod)

Static Function MenuDef()
	Local aRotina := {}

	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	//ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      	OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "VISITAS"    ACTION "U_STVISI02()" 	OPERATION 4 ACCESS 0 //"Incluir" STVISI02
	//ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STVISI01" OPERATION 2 ACCESS 0 //"Visualizar"
	//ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STVISI01" OPERATION 4 ACCESS 0 //"Alterar"
	//ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STVISI01" OPERATION 5 ACCESS 0 //"Excluir"
	//ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STVISI01" OPERATION 3 ACCESS 0 //"Incluir"

Return aRotina

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr5:= FWFormStruct(2, 'Z1R')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('Z1R' , oStr5,'Z1R' )
	oView:CreateHorizontalBox( 'BOX2', 100)
	oView:CreateFolder( 'FOLDER8', 'BOX2')
	oView:AddSheet('FOLDER8','SHEET12','Usuario')
	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('Z1R','BOXFORM9')

Return oView

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct(1,'Z1R')
	Local 	aAux := {}

	oModel := MPFormModel():New('Menu', /*bPre {|oX| U_xMenuPos(oX)}*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('Menu')

	aAux := FwStruTrigger(;
	'Z1R_USER'                     					,; // Campo de DomÃ­nio (tem que existir no Model)
	'Z1R_NOME'                  						,; // Campo de ContradomÃ­nio (tem que existir no Model)
	'UsrFullName(M->Z1R_USER)' 							,; // Regra de Preenchimento
	.F.                          						,; // Se posicionara ou não antes da execução do gatilhos (Opcional)
	,; // Alias da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Ordem da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T.)
	,; // Chave de busca da tabela a ser posicionada (ObrigatÃ³rio se lSeek = .T)
	'')  // Condição para execução do gatilho (Opcional)
	oStr1:AddTrigger( aAux[1], aAux[2], aAux[3], aAux[4])

	oModel:addFields('Z1R',,oStr1)
	oModel:SetPrimaryKey({ 'Z1R_FILIAL', 'Z1R_COD' })
	oModel:getModel('Z1R'):SetDescription('Z1R')

Return oModel

User Function Z1RUPD()

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("Z1R")
	Z1R->(DbSetOrder(2))

	DbSelectArea('SA3')
	SA3->(dbgotop())
	While !SA3->(Eof())

		If !('ENCERRADO' $ SA3->A3_NOME) .And. SubStr(SA3->A3_COD,1,1)=="E" .And. !Empty(SA3->A3_CODUSR)

			If !Z1R->(DbSeek(xFilial("Z1R")+SA3->A3_COD))

				Z1R->(RecLock('Z1R',.T.))
				Z1R->Z1R_COD  :=  GETSXENUM("Z1R","Z1R_COD")
				Z1R->Z1R_USER :=  SA3->A3_CODUSR
				Z1R->Z1R_NOME :=  SA3->A3_NOME
				Z1R->Z1R_VEND :=  SA3->A3_COD
				Z1R->(MsUnlock())
				Z1R->(DbCommit())
				ConfirmSX8()

			EndIf

			//Prospect 1
			If !SA1->(DbSeek(xFilial("SA1")+SA3->A3_COD+"01"))

				SA1->(RecLock("SA1",.T.))
				SA1->A1_COD 	:= SA3->A3_COD
				SA1->A1_LOJA 	:= "01"
				SA1->A1_NOME	:= "PROSPECT - "+SA3->A3_NOME
				SA1->(MsUnLock())

			EndIf

			//Prospect 2
			If !SA1->(DbSeek(xFilial("SA1")+SA3->A3_COD+"02"))

				SA1->(RecLock("SA1",.T.))
				SA1->A1_COD 	:= SA3->A3_COD
				SA1->A1_LOJA 	:= "02"
				SA1->A1_NOME	:= "HOME OFFICE - "+SA3->A3_NOME
				SA1->(MsUnLock())

			EndIf

		EndIf
		SA3->(dbSkip())
	End

Return()