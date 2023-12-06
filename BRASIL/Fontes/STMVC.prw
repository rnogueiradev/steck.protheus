#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STEAANEW          | Autor | GIOVANI.ZAGO             | Data | 01/01/2016 |
|=====================================================================================|
|Sintaxe   | STEAANEW                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STMVC()
	*----------------------------------*
	Local oBrowse2
	Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	Private _lPartic := .T.

	DbSelectArea("PH1")
	PH1->(DbSetOrder(3))
	If 	!(__cUserId $ _UserMvc)
		PH1->(dbSetFilter({|| PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId },'PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId'))
	EndIF

	oBrowse2 := FWMBrowse():New()
	oBrowse2:SetAlias("PH1")					// Alias da tabela utilizada
	oBrowse2:SetMenuDef("STMVC")				// Nome do fonte onde esta a função MenuDef
	oBrowse2:SetDescription("AVALIA��O")   	// Descrição do browse

	If 	!(__cUserId $ _UserMvc)
		oBrowse2:SetFilterDefault( 'PH1->PH1_USER = __cUserId .Or. PH1->PH1_SUP = __cUserId' )
	EndIF

	oBrowse2:SetUseCursor(.F.)

	oBrowse2:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_STMVC',,'000000/000308/000210')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	//ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "U_MVC2VI" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Avaliar"    ACTION "U_MVC2AL" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "U_MVC2EX" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "ANEXOS"  	  ACTION "U_STANEXMVC(.T.)" OPERATION 4 ACCESS 0 //"Anexos"
	If __cUserId $ _UserMvc
		ADD OPTION aRotina TITLE "Incluir"    ACTION "U_MVC2IN" OPERATION 3 ACCESS 0 //"Incluir"
	EndIf
	//ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STMVC" OPERATION 8 ACCESS 0 //"Imprimir"

Return aRotina

User Function MVC2IN()

	FWExecView("INCLUIR",'STMVC2', MODEL_OPERATION_INSERT, , {|| .T. },{|| .T.},,,{|| .T.})

Return

User Function MVC2AL()

	FWExecView("AVALIAR",'STMVC2', MODEL_OPERATION_UPDATE, , {|| .T. },{|| .T.},,,{|| .T.})

Return

User Function MVC2EX()

	FWExecView("EXCLUIR",'STMVC2', MODEL_OPERATION_DELETE, , {|| .T. },{|| .T.},,,{|| .T.})

Return

User Function MVC2VI()

	FWExecView("VISUALIZAR",'STMVC2', MODEL_OPERATION_VIEW, , {|| .T. },{|| .T.},,,{|| .T.})

Return
