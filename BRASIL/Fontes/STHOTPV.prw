
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#Define CR chr(13)+ chr(10)

USER Function STHOTPV()
	Local oBrowse
	Public INCLUI := .f.
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SC5")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("STHOTPV")					// Nome do fonte onde esta a fun��o MenuDef
	oBrowse:SetDescription("PV")   	// Descri��o do browse //"Al�quotas de ICMS"
	oBrowse:Activate()
	
Return(Nil)

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona bot�es do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STHOTPV" OPERATION 4 ACCESS 0 //"Alterar"
	
	
Return aRotina

//-------------------------------------------------------
//Fun��o ModelDef
//-------------------------------------------------------

Static Function ModelDef()
	
	Local oModel
	Local oStructSC5 := FWFormStruct(1,"SC5")
	Local oStructSC6 := FWFormStruct(1,"SC6")
	
	
	oStructSC6:RemoveField( "C6_FILIAL" )
	
	
	// cID     Identificador do modelo
	// bPre    Code-Block de pre-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost   Code-Block de valida��o do formul�rio de edi��o
	// bCommit Code-Block de persist�ncia do formul�rio de edi��o
	// bCancel Code-Block de cancelamento do formul�rio de edi��o
	oModel := MPFormModel():New("STHOTPV", /*bPre*/,/*{|oX| GFEA13POS(oX)}*/, /*bPost*/, /*bCommit*/, /*bCancel*/)
	// cId          Identificador do modelo
	// cOwner       Identificador superior do modelo
	// oModelStruct Objeto com  a estrutura de dados
	// bPre         Code-Block de pr�-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost        Code-Block de valida��o do formul�rio de edi��o
	// bLoad        Code-Block de carga dos dados do formul�rio de edi��o
	oModel:AddFields("STHOTPV_SC5", Nil, oStructSC5,/*bPre*/,/*bPost*/,/*bLoad*/)
	//oModel:SetPrimaryKey({"SC5_FILIAL", "SC5_UF"})
	
	oModel:AddGrid("STHOTPV_SC6","STHOTPV_SC5",oStructSC6,/*bLinePre*/,/*{ | oX | ValideItem( oX ) }*/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation("STHOTPV_SC6",{{"C6_FILIAL",'xFilial("SC6")'},{"C6_NUM","SC5_NUM"}},"C6_FILIAL+C6_NUM+C6_ITEM")
	oModel:SetPrimaryKey({"C5_FILIAL", "C5_NUM"})
	oModel:GetModel("STHOTPV_SC6"):SetDelAllLine(.T.)
	
	oModel:SetOptional("STHOTPV_SC6", .T. )
	
	//oModel:GetModel("STHOTPV_SC6"):SetUniqueLine({/*"SC6_UFORIG",*/"SC6_UFDEST","SC6_TPITEM","SC6_CDTPOP","SC6_TPCLFR","SC6_TRIBT","SC6_TRTRAN","SC6_TRIBR","SC6_TRREM","SC6_TRIBD","SC6_TRDEST","SC6_USO","SC6_CICMS"})
	
	
Return oModel

//-------------------------------------------------------
//Fun��o viewDef
//-------------------------------------------------------




Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	
	Local oStructSC6 := FWFormStruct(2,"SC6")
	
	oStructSC6:RemoveField( "C6_FILIAL" )
	
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField( "STHOTPV_SC5" , FWFormStruct(2,"SC5") )
	oView:AddGrid( "STHOTPV_SC6" , oStructSC6 )
	
	
	oView:CreateHorizontalBox( "MASTER" , 22 )
	oView:CreateHorizontalBox( "DETAIL" , 78 )
	
	oView:CreateFolder("IDFOLDER","DETAIL")
	oView:AddSheet("IDFOLDER","IDSHEET01","ITENS") //"Exce��es"
	
	
	oView:CreateHorizontalBox( "DETAILEXE"  , 100,,,"IDFOLDER","IDSHEET01" )
	
	
	oView:SetOwnerView( "STHOTPV_SC5" , "MASTER" )
	oView:SetOwnerView( "STHOTPV_SC6" , "DETAILEXE" )
	
	
Return oView












