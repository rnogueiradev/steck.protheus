#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STEAANEW          | Autor | GIOVANI.ZAGO             | Data | 30/10/2014 |
|=====================================================================================|
|Descrição | STEAANEW                                                                 |
|          |  																	      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEAANEW                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*----------------------------------* 
User Function STEAANEW()
*----------------------------------* 

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("PH3")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("STEAANEW")					// Nome do fonte onde esta a função MenuDef
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STEAANEW" OPERATION 2 ACCESS 0 //"Visualizar"
	//ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STEAANEW" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STEAANEW" OPERATION 4 ACCESS 0 //"Alterar"
	//ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STEAANEW" OPERATION 5 ACCESS 0 //"Excluir"
	//ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.STEAANEW" OPERATION 9 ACCESS 0 //"Copiar"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STEAANEW" OPERATION 8 ACCESS 0 //"Imprimir"

 

	If __cuserid $ _cUser
		ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STEAANEW" OPERATION 4 ACCESS 0 //"Alterar"
		ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STEAANEW" OPERATION 5 ACCESS 0 //"Excluir"
		ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STEAANEW" OPERATION 3 ACCESS 0 //"Incluir"
	EndIf

Return aRotina

//-------------------------------------------------------
//Função ModelDef
//-------------------------------------------------------

Static Function ModelDef()

	Local oModel
	Local oStructPH3  := FWFormStruct(1,"PH3")
	
	//Local oStructACP := FWFormStruct(1,"ACP")


	//oStructPH3:RemoveField( "PH3_M2" )
	//oStructPH3:SetProperty( "PH3_CODTAB"  , MVC_VIEW_CANCHANGE ,.F.)
	//oStructPH3:SetProperty( "*"  , MVC_VIEW_CANCHANGE ,.F.)
	

// cID     Identificador do modelo 
// bPre    Code-Block de pre-edição do formulário de edição. Indica se a edição esta liberada
// bPost   Code-Block de validação do formulário de edição
// bCommit Code-Block de persistência do formulário de edição
// bCancel Code-Block de cancelamento do formulário de edição
	oModel := MPFormModel():New("xxx", /*bPre*/,{|oX| GFEA13POS(oX)}, /*bPost*/, /*bCommit*/, /*bCancel*/)
	//oStructPH3:setProperty("*",MODEL_FIELD_WHEN,{||INCLUI})
// cId          Identificador do modelo
// cOwner       Identificador superior do modelo
// oModelStruct Objeto com  a estrutura de dados
// bPre         Code-Block de pré-edição do formulário de edição. Indica se a edição esta liberada
// bPost        Code-Block de validação do formulário de edição
// bLoad        Code-Block de carga dos dados do formulário de edição
	oModel:AddFields("STEAANEW_PH3", Nil, oStructPH3,/*bPre*/,/*bPost*/,/*bLoad*/)
//oModel:SetPrimaryKey({"PH3_FILIAL", "PH3_UF"})  
//oModel:AddFields("STEAANEW_PH3", Nil, oStruct1PH3,/*bPre*/,/*bPost*/,/*bLoad*/)
	//oModel:AddGrid("STEAANEW_ACP","STEAANEW_PH3",oStructACP,/*bLinePre*/,/*{ | oX | ValideItem( oX ) }*/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	//oModel:SetRelation("STEAANEW_ACP",{{"ACP_FILIAL",'xFilial("ACP")'},{"ACP_CODREG","PH3_CODREG"}},"ACP_FILIAL+ACP_CODREG+ACP_ITEM")
	oModel:SetPrimaryKey({"PH3_FILIAL", "PH3_USERID"})
	//oModel:GetModel("STEAANEW_ACP"):SetDelAllLine(.T.)

	//oModel:SetOptional("STEAANEW_ACP", .T. )
//oModel:GetModel("STEAANEW_ACP"):SetNoDeleteLine(.t.)

	//oModel:GetModel("STEAANEW_ACP"):SetNoUpdateLine( .T. )

//oModel:GetModel("STEAANEW_ACP"):SetUniqueLine({"ACP_ITEM"})
//ACP_CODREG+ACP_ITEM+ACP_DESPRO   

Return oModel

//-------------------------------------------------------
//Função viewDef
//-------------------------------------------------------

static Function ViewDef()

	Local oModel := FWLoadModel("STEAANEW")
	Local oView
	Local oStructPH3 := FWFormStruct(2,"PH3")
	
 	oStructPH3:AddGroup("GrpDCF", "Geral", "5", 2)
//	oStructACP:RemoveField( "ACP_FILIAL" )
//	oStructACP:RemoveField( "ACP_CODREG"     )
	oStructPH3:SetProperty("PH3_USERID" , MVC_VIEW_GROUP_NUMBER, "GrpDCF")
	oStructPH3:SetProperty("PH3_ANO", MVC_VIEW_GROUP_NUMBER, "GrpDCF")
	//oStructPH3:SetProperty("GU3_CTE"   , MVC_VIEW_GROUP_NUMBER, "GrpDCF")
	//oStructPH3:SetProperty("GU3_FATAUT", MVC_VIEW_GROUP_NUMBER, "GrpDCF")
 
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField( "STEAANEW_PH3" , oStructPH3 )


	oView:CreateHorizontalBox( "MASTER" , 100 )
	//oView:CreateHorizontalBox( "DETAIL" , 78 )

	//oView:CreateFolder("IDFOLDER","DETAIL")
	//oView:AddSheet("IDFOLDER","IDSHEET01","Itens") //"Exceções"


	//oView:CreateHorizontalBox( "DETAILEXE"  , 100,,,"IDFOLDER","IDSHEET01" )


	oView:SetOwnerView( "STEAANEW_PH3" , "MASTER" )
	//oView:SetOwnerView( "PH3_01" , "DETAILEXE" )

 oView:SetCloseOnOk({||.T.})
 
Return oView


Static Function GFEA13POS(oModel)

	//Local oModelACP := oModel:GetModel("STEAANEW_ACP")
	//Local nAtuLn    := oModelACP:GetLine()
	 Local nLine := 0 
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
            