#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "STR.CH"
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STCOMPRO       | Autor | GIOVANI.ZAGO               | Data | 27/03/2015  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro   Compromisso de entrega da fabrica/importado     |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCOMPRO                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOMPRO()
	Local oBrowse
	Private _cAlias	:= "ZZJ"
	Private _cRot	:= "U_STCOMPRO"
	Private _cTit	:= "Compromisso de Entrega"

	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias(_cAlias )			// Alias da tabela utilizada
	oBrowse:SetMenuDef(_cRot)			// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription(_cTit)		// Descrição do browse


	oBrowse:AddLegend("DTOS(ZZJ_DATA) >= '"+DTOs(DATE())+ "' .and. Empty(Alltrim(ZZJ_CANCEL))", "GREEN", "PRETO") //"Recebido"
	oBrowse:AddLegend("DTOS(ZZJ_DATA) < '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL)) ", "RED"  , STR0003) //"Bloqueado"
	oBrowse:AddLegend("!Empty(Alltrim(ZZJ_CANCEL))", "BLUE" , STR0005) //"Aprovado pelo Usuário"

	// oBrowse:SetFilterDefault(" C7_QUANT > C7_QUJE .And. C7_RESIDUO == ' ' .And. C7_FILIAL = '02'" )

	oBrowse:Activate()
Return(Nil)

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE STR0002   ACTION "AxPesqui"        OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0003   ACTION "VIEWDEF.STCOMPRO" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0004   ACTION "VIEWDEF.STCOMPRO" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0005   ACTION "VIEWDEF.STCOMPRO" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0006   ACTION "VIEWDEF.STCOMPRO" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE STR0007   ACTION "VIEWDEF.STCOMPRO" OPERATION 6 ACCESS 0 //"Facilitador"
	ADD OPTION aRotina TITLE STR0008   ACTION "VIEWDEF.STCOMPRO" OPERATION 7 ACCESS 0 //"Ambiente"
	ADD OPTION aRotina TITLE "Alt.Massa" ACTION "U_COMALT(ZZJ->ZZJ_OP)" OPERATION 8 ACCESS 0  

Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStructZZJ := FWFormStruct(1,"ZZJ")


	// cID     Identificador do modelo 
	// bPre    Code-Block de pre-edição do formulário de edição. Indica se a edição esta liberada
	// bPost   Code-Block de validação do formulário de edição
	// bCommit Code-Block de persistência do formulário de edição
	// bCancel Code-Block de cancelamento do formulário de edição
	oModel := MPFormModel():New("STCOMPRO", /*bPre*/, /*bPost*/, /*bCommit*/, /*bCancel*/)
	// cId          Identificador do modelo
	// cOwner       Identificador superior do modelo
	// oModelStruct Objeto com  a estrutura de dados
	// bPre         Code-Block de pré-edição do formulário de edição. Indica se a edição esta liberada
	// bPost        Code-Block de validação do formulário de edição
	// bLoad        Code-Block de carga dos dados do formulário de edição
	oModel:AddFields("STCOMPRO_ZZJ", Nil, oStructZZJ,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetPrimaryKey({"ZZJ_NUM", "ZZJ_COD"})




Return oModel



Static Function ViewDef()

	Local oModel := FWLoadModel("STCOMPRO")
	Local oView  := Nil

	oView := FWFormView():New()
	// Objeto do model a se associar a view.
	oView:SetModel(oModel)
	// cFormModelID - Representa o ID criado no Model que essa FormField irá representar
	// oStruct - Objeto do model a se associar a view.
	// cLinkID - Representa o ID criado no Model ,Só é necessári o caso estamos mundando o ID no View.
	oView:AddField( "STCOMPRO_ZZJ" , FWFormStruct(2,"ZZJ"), /*cLinkID*/ )	//
	// cID		  	Id do Box a ser utilizado 
	// nPercHeight  Valor da Altura do box( caso o lFixPixel seja .T. é a qtd de pixel exato)
	// cIdOwner 	Id do Box Vertical pai. Podemos fazer diversas criações uma dentro da outra.
	// lFixPixel	Determina que o valor passado no nPercHeight é na verdade a qtd de pixel a ser usada.
	// cIDFolder	Id da folder onde queremos criar o o box se passado esse valor, é necessário informar o cIDSheet
	// cIDSheet     Id da Sheet(Folha de dados) onde queremos criar o o box.
	oView:CreateHorizontalBox( "MASTER" , 100,/*cIDOwner*/,/*lFixPixel*/,/*cIDFolder*/,/*cIDSheet*/ )
	// Associa um View a um box
	oView:SetOwnerView( "STCOMPRO_ZZJ" , "MASTER" )

Return oView




User Function COMALT(_cNuPed)
	Local cString	:= 'ZZJ'
	Local _cLog  	:= ' '
	Local lSaida  := .F.
	Local dGetMot := ZZJ->ZZJ_DATA
	Local nOpcao 	:= 0

	If MsgYesNO("Deseja Informar a Data de Chegada ?")
		If ZZJ->ZZJ_TRANSP <> '3'
			MsgInfo("Opção disponivel apenas para Itens Importados..!!!!!!")
			Return()
		EndIf


		While !lSaida

			Define msDialog oDlg Title "PO: "+ZZJ->ZZJ_OP From 10,10 TO 20,65 Style DS_MODALFRAME

			@ 000,001 Say "Data: " Pixel Of oDlg
			@ 010,003 MsGet dGetMot valid !empty(dGetMot) size 200,10 Picture "@!" pixel OF oDlg
			DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION (nOpcao:=1,lSaida:=.T.,oDlg:End()) ENABLE OF oDlg

			Activate dialog oDlg centered

		End

		If nOpcao = 1
			DbSelectArea("ZZJ")
			ZZJ->(DbSetOrder(4))
			ZZJ->(dbGoTop())
			If ZZJ->(DbSeek(xFilial("ZZJ")+Alltrim(_cNuPed)))
				While ZZJ->(!Eof()).And. ZZJ->ZZJ_FILIAL= xFilial("ZZJ") .And. ZZJ->ZZJ_OP = Alltrim(_cNuPed)
					If ZZJ->ZZJ_FILIAL+Alltrim(ZZJ->ZZJ_OP) == xFilial("ZZJ")+Alltrim(_cNuPed)
						RecLock("ZZJ",.F.)
						ZZJ->ZZJ_DATA 	:= dGetMot
						_cLog:= DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+' Data: '+ dtoc(dGetMot)
						ZZJ->ZZJ_MHISTO :=	Alltrim(ZZJ->ZZJ_MHISTO) + CR + _cLog
						ZZJ->(MsUnlock())
						ZZJ->(DbCommit())

					EndIf
					ZZJ->(DbSkip())
				End
			EndIf


		EndIf

	EndIf

Return



