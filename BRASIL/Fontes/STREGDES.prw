#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STREGDES          | Autor | GIOVANI.ZAGO             | Data | 30/10/2014 |
|=====================================================================================|
|Descrição | STREGDES                                                                 |
|          |  																	      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STREGDES                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*----------------------------------* 
User Function STREGDES()
*----------------------------------* 

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ACO")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("STREGDES")					// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("REGRA DE DESCONTO")   	// Descrição do browse //"Alíquotas de ICMS"
	oBrowse:Activate()

Return(Nil)

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	Local _cUser := GetMv("ST_FATA080",,"000000/000645/000231")+"000000/000645"
	
//-------------------------------------------------------
// Adiciona botões do browse
//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"        OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STREGDES" OPERATION 2 ACCESS 0 //"Visualizar"
	//ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STREGDES" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STREGDES" OPERATION 4 ACCESS 0 //"Alterar"
	//ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STREGDES" OPERATION 5 ACCESS 0 //"Excluir"
	//ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.STREGDES" OPERATION 9 ACCESS 0 //"Copiar"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STREGDES" OPERATION 8 ACCESS 0 //"Imprimir"

 

	If __cuserid $ _cUser
		ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STREGDES" OPERATION 4 ACCESS 0 //"Alterar"
		ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STREGDES" OPERATION 5 ACCESS 0 //"Excluir"
		ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STREGDES" OPERATION 3 ACCESS 0 //"Incluir"
	EndIf

Return aRotina

//-------------------------------------------------------
//Função ModelDef
//-------------------------------------------------------

Static Function ModelDef()

	Local oModel
	Local oStructACO := FWFormStruct(1,"ACO")
	Local oStructACP := FWFormStruct(1,"ACP")


	oStructACP:RemoveField( "ACP_FILIAL" )
	oStructACP:RemoveField( "ACP_CODREG" )
	//oStructACO:SetProperty( "ACO_CODTAB"  , MVC_VIEW_CANCHANGE ,.F.)
	//oStructACO:SetProperty( "*"  , MVC_VIEW_CANCHANGE ,.F.)
	

// cID     Identificador do modelo 
// bPre    Code-Block de pre-edição do formulário de edição. Indica se a edição esta liberada
// bPost   Code-Block de validação do formulário de edição
// bCommit Code-Block de persistência do formulário de edição
// bCancel Code-Block de cancelamento do formulário de edição
	oModel := MPFormModel():New("REGDES", /*bPre*/,{|oX| GFEA13POS(oX)}, /*bPost*/, /*bCommit*/, /*bCancel*/)
	oStructACO:setProperty("*",MODEL_FIELD_WHEN,{||INCLUI})
// cId          Identificador do modelo
// cOwner       Identificador superior do modelo
// oModelStruct Objeto com  a estrutura de dados
// bPre         Code-Block de pré-edição do formulário de edição. Indica se a edição esta liberada
// bPost        Code-Block de validação do formulário de edição
// bLoad        Code-Block de carga dos dados do formulário de edição
	oModel:AddFields("STREGDES_ACO", Nil, oStructACO,/*bPre*/,/*bPost*/,/*bLoad*/)
//oModel:SetPrimaryKey({"ACO_FILIAL", "ACO_UF"})  

	oModel:AddGrid("STREGDES_ACP","STREGDES_ACO",oStructACP,/*bLinePre*/,/*{ | oX | ValideItem( oX ) }*/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation("STREGDES_ACP",{{"ACP_FILIAL",'xFilial("ACP")'},{"ACP_CODREG","ACO_CODREG"}},"ACP_FILIAL+ACP_CODREG+ACP_ITEM")
	oModel:SetPrimaryKey({"ACO_FILIAL", "ACO_CODREG"})
	oModel:GetModel("STREGDES_ACP"):SetDelAllLine(.T.)

	oModel:SetOptional("STREGDES_ACP", .T. )
//oModel:GetModel("STREGDES_ACP"):SetNoDeleteLine(.t.)

	//oModel:GetModel("STREGDES_ACP"):SetNoUpdateLine( .T. )

//oModel:GetModel("STREGDES_ACP"):SetUniqueLine({"ACP_ITEM"})
//ACP_CODREG+ACP_ITEM+ACP_DESPRO   

Return oModel

//-------------------------------------------------------
//Função viewDef
//-------------------------------------------------------

static Function ViewDef()

	Local oModel := FWLoadModel("STREGDES")
	Local oView
	Local oStructACP := FWFormStruct(2,"ACP")

	oStructACP:RemoveField( "ACP_FILIAL" )
	oStructACP:RemoveField( "ACP_CODREG"     )

 
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField( "STREGDES_ACO" , FWFormStruct(2,"ACO") )
	oView:AddGrid( "STREGDES_ACP" , oStructACP )


	oView:CreateHorizontalBox( "MASTER" , 22 )
	oView:CreateHorizontalBox( "DETAIL" , 78 )

	oView:CreateFolder("IDFOLDER","DETAIL")
	oView:AddSheet("IDFOLDER","IDSHEET01","Itens") //"Exceções"


	oView:CreateHorizontalBox( "DETAILEXE"  , 100,,,"IDFOLDER","IDSHEET01" )


	oView:SetOwnerView( "STREGDES_ACO" , "MASTER" )
	oView:SetOwnerView( "STREGDES_ACP" , "DETAILEXE" )


Return oView


Static Function GFEA13POS(oModel)

	Local oModelACP := oModel:GetModel("STREGDES_ACP")
	Local nAtuLn    := oModelACP:GetLine()
	Local nLine
Return .T.
For nLine := 1 To oModelACP:GetQtdLine()
	oModelACP:GoLine(nLine)
	If !oModelACP:IsDeleted()
		If FwFldGet("ACP_TPTRIB",nLine) == "5" .And. FwFldGet("ACP_PCREIC",nLine) == 0
			Help( ,, 'HELP',, StrTran(" ","[line]",AllTrim(Str(nLine))), 1, 0)
			Return .F.
		EndIf
		If FwFldGet("ACP_ITEM",nLine) == " "
			oModelACP:SetValue("ACP_ITEM" , PADL(nLine,'0',3)  )
		EndIf
	EndIf
Next nLine

oModelACP:GoLine(nAtuLn)

Return .T.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
            