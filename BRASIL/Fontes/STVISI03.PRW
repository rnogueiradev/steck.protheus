#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)

*----- -----------------------------*
User Function STVISI03()
	*----------------------------------*
	Local oBrowse,oBrowse2
	Private _UserMvc := GetMv('ST_STREEM',,'000000/000308/000210')
	Private _xSuper   := u_Super(__cUserId)
	Private _cFarol := .f.
	DbSelectArea("Z1S")
	Z1S->(DbSetOrder(1))
	Z1S->(dbSetFilter({|| Z1S->Z1S_COD = Z1R->Z1R_COD    },' Z1S->Z1S_COD = Z1R->Z1R_COD '))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1S")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STVISI03")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Visitas")   	// Descrição do browse

	oBrowse:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      	   OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STVISI03" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STVISI03" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STVISI03" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STVISI03" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STVISI03" OPERATION 8 ACCESS 0 //"Imprimir"
	//ADD OPTION aRotina TITLE "ANEXO"  ACTION "U_STANEX" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "MAPA"    ACTION "U_Navegador" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "Bloquear/Desbloquear"   ACTION "u_BXDES" OPERATION 8 ACCESS 0 //"Imprimir"

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Administrator

@since 08/11/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'Z1S')

	Local oStr2:= FWFormStruct(2, 'Z1U')

	Local oStr3:= FWFormStruct(2, 'Z1T')

	Local oStr4:= Nil
	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM9' , oStr1,'FIELD1' )
	oView:AddGrid('FORM6' , oStr2,'REGISTRO')
	oView:AddGrid('FORM8' , oStr3,'AGENDAMENTO')

	oView:CreateHorizontalBox( 'BOX7', 50)
	oView:CreateHorizontalBox( 'BOX2', 50)

	oView:CreateFolder( 'FOLDER5', 'BOX2')
	oView:CreateFolder( 'FOLDER8', 'BOX7')
	oView:AddSheet('FOLDER8','SHEET9','Cliente da Visita')

	oView:AddSheet('FOLDER5','SHEET7','Registro de Visita')
	oView:AddSheet('FOLDER5','SHEET6','Agendamento de Visita')
	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET9')
	oView:SetOwnerView('FORM9','BOXFORM9')
	oView:CreateHorizontalBox( 'BOXFORM8', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET6')
	oView:SetOwnerView('FORM8','BOXFORM8')
	oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET7')
	oView:SetOwnerView('FORM6','BOXFORM6')

	//oView:SetNoDeleteLine('FORM8')

	//oView:SetNoDeleteLine('FORM6')

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Administrator

@since 08/11/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct(1,'Z1S')
	Local oStr2:= FWFormStruct(1,'Z1U')
	Local oStr3:= FWFormStruct(1,'Z1T')

	oModel := MPFormModel():New('GERAL',   {|oX| U_yMenuPos(oX)} ,  {|oModel|TUDOOK(oModel)} /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:addFields('FIELD1',,oStr1)
	oModel:SetPrimaryKey({ 'Z1S_FILIAL', 'Z1S_COD', 'Z1S_CLIENT', 'Z1S_LOJA','Z1S_CODVIS' })  //Chamado 006985 - Everon Santana 06.03.18

	oModel:addGrid('REGISTRO','FIELD1',oStr2,/*bLinePre*/,{|oX| U_Z1ULINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation('REGISTRO', { { 'Z1U_FILIAL', 'Z1S_FILIAL' }, { 'Z1U_COD', 'Z1S_COD' }, { 'Z1U_CLIENT', 'Z1S_CLIENT' }, { 'Z1U_LOJA', 'Z1S_LOJA' }, { 'Z1U_CODVIS', 'Z1S_CODVIS' } }, Z1U->(IndexKey(1)) ) //Chamado 006985 - Everon Santana 06.03.18

	oModel:GetModel('REGISTRO'):SetUniqueLine( { 'Z1U_FILIAL', 'Z1U_ITEM', 'Z1U_CLIENT', 'Z1U_LOJA', 'Z1U_COD','Z1U_CODVIS' } )

	oModel:addGrid('AGENDAMENTO','FIELD1',oStr3,/*bLinePre*/,{|oX| U_Z1TLINE(oX)},/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation('AGENDAMENTO', { { 'Z1T_FILIAL', 'Z1S_FILIAL' }, { 'Z1T_COD', 'Z1S_COD' }, { 'Z1T_CLIENT', 'Z1S_CLIENT' }, { 'Z1T_LOJA', 'Z1S_LOJA' }, { 'Z1T_CODVIS', 'Z1S_CODVIS' } }, Z1T->(IndexKey(1)) ) //Chamado 006985 - Everon Santana 06.03.18

	oModel:GetModel('AGENDAMENTO'):SetUniqueLine( { 'Z1T_FILIAL', 'Z1T_COD', 'Z1T_ITEM', 'Z1T_CLIENT', 'Z1T_LOJA','Z1T_CODVIS' } )
	oModel:SetDescription('RELATORIO')

Return oModel

User Function yMenuPos(oModel)
	Local nOp  		 := (oModel:getOperation())
	Local oModelPai  := FWMODELACTIVE()
	Local oModel4PH  := oModelPai:GetModel('Z1S')
	Local oModel5PH  := oModelPai:GetModel('Z1U')
	Local oModel6PH  := oModelPai:GetModel('Z1T')
	Local  _nTot	 := 0
	Local nI := 0
	If ValType(oModelPai) = 'O' .And. ValType(oModel5PH) = 'O' .And. ValType(oModel6PH) = 'O'
		For nI := 1 To oModel5PH:GetQtdLine()
			oModel5PH:GoLine( nI )
			oModel5PH:LoadValue('Z1U_COD'		,oModelPai:GetValue( 'Z1S', 'Z1S_COD' ))
			oModel5PH:LoadValue('Z1U_CLIENT'	,oModelPai:GetValue( 'Z1S', 'Z1S_CLIENT' ))
			oModel5PH:LoadValue('Z1U_LOJA'		,oModelPai:GetValue( 'Z1S', 'Z1S_LOJA' ))
			oModel5PH:LoadValue('Z1U_CODVIS'	,oModelPai:GetValue( 'Z1S', 'Z1S_CODVIS' )) //Chamado 006985 - Everon Santana 06.03.18
		Next nI

		For nI := 1 To oModel6PH:GetQtdLine()
			oModel6PH:GoLine( nI )
			oModel6PH:LoadValue('Z1T_COD'		,oModelPai:GetValue( 'Z1S', 'Z1S_COD' ))
			oModel6PH:LoadValue('Z1T_CLIENT'	,oModelPai:GetValue( 'Z1S', 'Z1S_CLIENT' ))
			oModel6PH:LoadValue('Z1T_LOJA'		,oModelPai:GetValue( 'Z1S', 'Z1S_LOJA' ))
			oModel6PH:LoadValue('Z1T_CODVIS'	,oModelPai:GetValue( 'Z1S', 'Z1S_CODVIS' )) //Chamado 006985 - Everon Santana 06.03.18
		Next nI
	EndIf

Return .T.

User Function Z1ULINE(oModel5PH)
	Local nLine       := oModel5PH:getLine()
	Local nI
	Local lRet        := .T.
	Local ntTot    	  := 0
	Local oModelPai   := FWMODELACTIVE()

	oModel5PH:SetValue("Z1U_ITEM" 		, PADL(nLine,3,'0')  )
	oModel5PH:SetValue("Z1U_COD" 		, M->Z1S_COD   )
	oModel5PH:SetValue("Z1U_CLIENT"		, M->Z1S_CLIENT   )
	oModel5PH:SetValue("Z1U_LOJA" 		, M->Z1S_LOJA   )
	oModel5PH:SetValue("Z1U_CODVIS" 	, M->Z1S_CODVIS   ) //Chamado 006985 - Everon Santana 06.03.18

Return lRet

User Function Z1TLINE(oModel6PH)
	Local nLine       := oModel6PH:getLine()
	Local nI
	Local lRet        := .T.
	Local ntTot    := 0
	//Local oModelPai   := FWMODELACTIVE()

	oModel6PH:SetValue("Z1T_ITEM" 		, PADL(nLine,3,'0')  )
	oModel6PH:SetValue("Z1T_CODVIS" 	, M->Z1S_CODVIS  ) //Chamado 006985 - Everon Santana 06.03.18

Return lRet

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc tudo ok
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.
	Local oModelForm1 	:= oModel:GetModel("FIELD1")
	Local cCliente 		:= oModelForm1:GetValue('Z1S_CLIENT')
	Local cLoja    		:= oModelForm1:GetValue('Z1S_LOJA')
	Local oModelSeq		:= oModel:GetModel('GRID1')
	Local cQuery1 		:= ""
	Local cAlias1 		:= GetNextAlias()

	If INCLUI

		cQuery1  := " SELECT COUNT(*) CONTADOR "
		cQuery1  += " FROM " +RetSqlName("Z1S")+ " Z1S "
		cQuery1  += " WHERE Z1S.D_E_L_E_T_=' ' AND Z1S_CLIENT='"+cCliente+"' AND Z1S_LOJA='"+cLoja+"'

		If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

		dbSelectArea(cAlias1)
		(cAlias1)->(dbGoTop())

		If (cAlias1)->CONTADOR>0
			_lRet := .F.
			MsgAlert("Atenção, cliente já cadastrado, favor utilizar o cadastro já existente!")
		EndIf

	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	If !SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
		_lRet := .F.
		MsgAlert("Atenção, cliente não encontrado, verifique!")
	EndIf

Return(_lRet)