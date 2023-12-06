#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STEDIZZ6           | Autor | GIOVANI.ZAGO            | Data | 28/01/2016 |
|=====================================================================================|
|Sintaxe   | STEDIZZ6                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STEDIZZ6()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_EDIZZ6',,'000380/000391/000366')+'/000000/000654/000009'
	Private _lPartic := .T.

	DbSelectArea("ZZ6")
	DbSelectArea("ZZ7")
	
	If !(__cuserid $ _UserMvc)
		MsgInfo("Usuario nao autorizado")
		Return()
	ENdIf
	
	ZZ6->(DbSetOrder(1))
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZ6")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STEDIZZ6")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Manutenção EDI Steck")   	// Descrição do browse
	oBrowse:AddLegend(" ZZ6_STATUS = '1'"  ,"RED"   ,"Aguardando")
	oBrowse:AddLegend(" ZZ6_STATUS = '2'"  ,"GREEN" ,"Importado")
	oBrowse:AddLegend(" ZZ6_STATUS = '3'"  ,"BLACK" ,"Erro")
	oBrowse:AddLegend(" ZZ6_STATUS = '4'"  ,"YELLOW","Aguardando Integração")
	oBrowse:AddLegend(" ZZ6_STATUS = '5'"  ,"BLUE"  ,"Integração Finalizada")
	oBrowse:Activate()
	
Return(Nil)


Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_STEDIZZ6',,'000000/000308/000210')

	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	//	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar"  		ACTION "VIEWDEF.STEDIZZ6" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"     		ACTION "VIEWDEF.STEDIZZ6" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"     		ACTION "VIEWDEF.STEDIZZ6" OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Gerar P.V."  		ACTION "U_xSTEDIPV(ZZ6->ZZ6_NUMOC)" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Aprovar" 			ACTION "U_REENAPI('A')"  OPERATION 2 ACCESS 0 
	ADD OPTION aRotina TITLE "Reprovar" 		ACTION "U_REENAPI('C')"  OPERATION 2 ACCESS 0 
	ADD OPTION aRotina TITLE "Mostra Erro" 		ACTION "U_STZZ6ERR()" 	 OPERATION 8 ACCESS 0 //"Imprimir"
	
	//ADD OPTION aRotina TITLE "Bloquear/Desbloquear"   ACTION "u_BXDES" OPERATION 8 ACCESS 0 //"Imprimir"
	
Return aRotina


User Function STZZ6PV()
	
	StartJob("U_xSTEDIPV",GetEnvServer(), .F. , ZZ6->ZZ6_NUMOC)
	
Return

User Function STZZ6ERR()
	
	MostraErro("LOGS",AllTrim(ZZ6->ZZ6_NUMOC)+"PED.log")
		
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface
@author Administrator
@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr2:= FWFormStruct(2, 'ZZ7')
	Local oStr5:= FWFormStruct(2, 'ZZ6')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('ZZ6' , oStr5,'ZZ6' )
	oView:AddGrid('ZZ7' , oStr2,'ZZ7')
	oView:CreateHorizontalBox( 'BOX2', 29)
	oView:CreateFolder( 'FOLDER8', 'BOX2')
	oView:AddSheet('FOLDER8','SHEET12','Cabeçalho')
	oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER8', 'SHEET12')
	oView:SetOwnerView('ZZ6','BOXFORM9')
	oView:CreateHorizontalBox( 'BOX1', 71)
	
	oView:CreateFolder( 'FOLDER5', 'BOX1')
	oView:AddSheet('FOLDER5','SHEET9','Itens')
	
	oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER5', 'SHEET9')
	oView:SetOwnerView('ZZ7','BOXFORM6')
	
Return oView



//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Administrator

@since 29/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1 := FWFormStruct(1, 'ZZ6' )
	Local oStr2 := FWFormStruct(1, 'ZZ7' )
	Local aAux  := {}
	
	oModel := MPFormModel():New('Menu', /*bPre*//*{|oX| U_MenuPos(oX)}*/,   /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription('Menu')
	oModel:addFields('ZZ6',,oStr1)
	oModel:SetPrimaryKey({ 'ZZ6_FILIAL', 'ZZ6_NUMOC', 'ZZ6_CLIENT', 'ZZ6_LOJA' })
	
	oModel:addGrid('ZZ7','ZZ6',oStr2,/*bLinePre*/,/*{|oX| U_ZZ7LINE(oX)}*/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:GetModel('ZZ7')
	oModel:GetModel('ZZ7'):SetUniqueLine( { 'ZZ7_FILIAL', 'ZZ7_NUMOC', 'ZZ7_CLIENT', 'ZZ7_LOJA' , 'ZZ7_ITEMP' } )
	
	oModel:SetRelation('ZZ7', { { 'ZZ7_FILIAL', 'ZZ6_FILIAL' }, { 'ZZ7_NUMOC', 'ZZ6_NUMOC' } , { 'ZZ7_CLIENT', 'ZZ6_CLIENT' }, { 'ZZ7_LOJA', 'ZZ6_LOJA' }}, 'ZZ7_FILIAL+ZZ7_NUMOC+ZZ7_CLIENT+ZZ7_LOJA'   )
	
	oModel:getModel('ZZ6'):SetDescription('ZZ6')
	oModel:getModel('ZZ7'):SetDescription('ZZ7')
	
Return oModel


/*/{Protheus.doc} REENAPI
Rotina para Reenvio da API
@type function
@version  12.1.33
@author valdemir rabelo
@since 10/10/2022
@return variant, Nil
/*/
USER FUNCTION REENAPI(pStatus)
	Local _cQuery3 := ""
	Local _cAlias3 := "TMPSC5"
	Local aAreaC5  := GetArea()
	Local _cJson   := ""
	Local cClient  := GetMV("FS_CLIPORT",.F.,"03740001/04325217/04325206/09804801/04325204/04325238/04325213") // Cliente+Loja
	Local _cUser   := Alltrim(SuperGetMV("MV_USERSLU",.F.,"api_steck")) // Valdemir Rabelo 20/09/2022
	Local _cSenha  := Alltrim(SuperGetMV("MV_PSWSLUC",.F.,"api@steck@edi")) // Valdemir Rabelo 20/09/2022
	Local cMsgMot  := 'Item será entregue na data informada'

	SA1->( dbSetOrder(1))
	SA1->( msSeek(xFilial('SA1')+ZZ6->ZZ6_CLIENT+ZZ6->ZZ6_LOJA) )

	if SA1->A1_XCONEDI .Or. ((ZZ6->ZZ6_CLIENT+ZZ6->ZZ6_LOJA $ cClient) .OR. ;
	   (Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'))
		if pStatus=="C"
		cMsgMot  := ""
		While Empty(cMsgMot)
			cMsgMot := 'Item não será entregue, pois foi recusado/cancelado'
			cMsgMot := FWInputBox("Por favor, Entre com o motivo da Recusa", cMsgMot)
				
				if Empty(cMsgMot)
					FWMsgRun(,{|| Sleep(3000)},"Informativo","Não pode deixar o motivo em branco.")
				Endif 
				
		EndDo
		endif 

		_cQuery3 := " SELECT C5_NUM
		_cQuery3 += " FROM "+RetSqlName("SC5")+" C5
		_cQuery3 += " WHERE C5.D_E_L_E_T_=' ' AND C5.C5_FILIAL='"+xFilial("SC5")+"'
		_cQuery3 += " AND C5.C5_XORDEM='"+AllTrim(ZZ6->ZZ6_NUMOC)+"'
		_cQuery3 += " ORDER BY C5_NUM DESC

		DbSelectArea("SC5")
		dbSetOrder(1)

		If !Empty(Select(_cAlias3))
			DbSelectArea(_cAlias3)
			(_cAlias3)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

		While (_cAlias3)->( !Eof() )

			// Posiciono no pedido conforme registro temporario (query)
			SC5->( MsSeek(xFilial('SC5')+(_cAlias3)->C5_NUM) )

//			if (!Empty(SA1->A1_XCONEDI) .And. SA1->A1_XCONEDI) .Or. (SC5->C5_CLIENTE+SC5->C5_LOJACLI $ cClient) .OR. ;
			if (SC5->C5_CLIENTE+SC5->C5_LOJACLI $ cClient) .OR. ;
	   (Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV')   // Se o cliente faz parte da regra continuo
				SC6->( dbSetOrder(1) )
				SC6->( MsSeek(xFilial("SC6")+SC5->C5_NUM) )
				_cJson := '['
				nPed   := 0
				While SC6->(!Eof() .and. C6_NUM==SC5->C5_NUM .AND. C6_FILIAL==SC5->C5_FILIAL)
					if nPed > 0
					_cJson += ','
					endif 
					cDatEnt := LEFT(DTOS(SC5->C5_ZDTCLI),4)+"-"+Substr(DTOS(SC5->C5_ZDTCLI),5,2)+"-"+RIGHT(DTOS(SC5->C5_ZDTCLI),2)
					_cJson += '{'
					_cJson += '"CNPJCliente": "'+ZZ6->ZZ6_CNPJ+'",'
					_cJson += '"CNPJFornecedor": "'+SM0->M0_CGC+'",'
					_cJson += '"NumeroDocumento": "'+alltrim(ZZ6->ZZ6_NUMOC)+'",'
					_cJson += '"NumeroDocumentoVenda": "'+alltrim(""/*SC5->C5_NUM*/)+'",'					
					_cJson += '"NItemPed": "'+SC6->C6_ITEM+'",'
					_cJson += '"DataEntrega": "'+cDatEnt+'T00:00:00.00",'
					_cJson += '"Justificativa": "'+cMsgMot+'",'
					_cJson += '"Status": "'+pStatus+'"'
					_cJson += '}'
					nPed++
					if pStatus=="C"
						SC6->( MaResDoFat(nil, .T., .F.,) )
					endif 
					SC6->( dbSkip() )
				EndDo
				_cJson += ']'
				If Len(_cJson) > 2
					oApiPortal := USolucoes():NEW(_cUser, _cSenha)
					oApiPortal:ConfirmacaoPedido(_cJson)
				Endif 
			else 
			FWMsgRun(,{|| Sleep(3000)},'Informativo','Cliente não faz parte do envio. Verifique parâmetro: FS_CLIPORT')
			Endif 
			// --------------		
			(_cAlias3)->( dbSkip() )
		EndDo

	else 
		FWMsgRun(,{|| Sleep(3500)},"Informativo","Cliente não necessita de aprovação/Rejeição.")
	endif 


	RestArea( aAreaC5 )

RETURN 
