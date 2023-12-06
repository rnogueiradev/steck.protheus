#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT020        | Autor | RENATO.OLIVEIRA           | Data | 11/10/2018  |
|=====================================================================================|
|Descrição | Rotina para manutenção de novos prazos			                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 003058																		  |
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT020()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("Z15")
	Z15->(DbSetOrder(1))

	DbSelectArea("Z16")
	Z16->(DbSetOrder(2))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z15")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro de novos prazos")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:AddLegend("Z15_STATUS=='0'"  ,"GREEN"      ,"Pendente")
	oBrowse:AddLegend("Z15_STATUS=='1'"  ,"BLACK"      ,"Analisado")
	//oBrowse:DisableDetails()
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT020" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STFAT020" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STFAT020"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STFAT020"	OPERATION 3  ACCESS 0 //"Incluir"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc monta model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z15')
	Local oStr2:= FWFormStruct(1,'Z16')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,{|oModel,nLine|VLDLIN(oModel,nLine)})

	aAdd(_aRel, { 'Z16_FILIAL', 'Z15_FILIAL' } )
	aAdd(_aRel, { 'Z16_DOC', 'Z15_DOC' } )

	oModel:SetRelation('GRID1', _aRel , Z16->(IndexKey(2)) )
	oModel:GetModel('GRID1'):SetUniqueLine({"Z16_ITEM"})

	oModel:SetPrimaryKey({})

	oModel:getModel('GRID1'):SetDescription('Itens')
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc monta view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	//Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'Z15')
	Local oStr2:= FWFormStruct(2, 'Z16')
	Local oModel     := FWLoadModel("STFAT020")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 70)

	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM1','BOXFORM1')

	//Habilitando título
	oView:EnableTitleView('FORM3','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

	// habilita a barra de controle
	oView:EnableControlBar(.T.)

	//verificar se a janela deve ou não ser fechada após a execução do botão OK
	oView:SetCloseOnOk({|| .T.})

	//Campo sequencial
	//oView:AddIncrementField( 'FORM3', 'PC6_ITEM' )

Return oView

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc tudo ok do pedido de venda
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.
	Local nOp         := oModel:GetOperation()
	Local oModelItens := oModel:GetModel( "GRID1" )
	Local _nK
	If cValtochar(nOp) $ '4'

		For _nK := 1 To oModelItens:Length()
			oModelItens:GoLine( _nK )
			_cProd 		:= oModelItens:GetValue('Z16_PROD')
			_cItem 		:= oModelItens:GetValue('Z16_ITEM')
			_dDtSug		:= oModelItens:GetValue('Z16_DTSUG')
			_dDtNov		:= oModelItens:GetValue('Z16_NOVADT')
			_cAtende	:= oModelItens:GetValue('Z16_ATENDE')
			_dPrev		:= oModelItens:GetValue('Z16_DTPREV')
			If !(oModelItens:IsDeleted())
				If Empty(_cAtende)
					Help(,,'Help',,"Item: "+_cItem+" - não foi preenchido o campo Atende?, verifique!",1,0)
					_lRet := .F.
				Else
					If _cAtende=="S"
						If _dDtNov>_dPrev
							Help(,,'Help',,"Nova data do item "+_cItem+" - está menor que a data de previsão atual, verifique!",1,0)
							_lRet := .F.
						EndIf
					EndIf
				Endif
				If Empty(_cProd)
					Help(,,'Help',,"Produto da linha "+CVALTOCHAR(_nK)+" não está preenchido, verifique!",1,0)
					_lRet := .F.
				EndIf
			Else
				Help(,,'Help',,"Item: "+_cItem+" - foi deletado, verifique!",1,0)
				_lRet := .F.
			Endif
		Next _nK
	EndIf

Return(_lRet)

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc valida alteração do pv
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc valida troca de linha
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv		:= .T.
	Local _nQtdIte	:= 0
	Local _nQtdAlt	:= 0
	Local _aItens	:= {}
	Local _cAssunto := ""
	Local cFuncSent := "STFAT020"
	Local _aMsg     := {}
	Local i         := 0
	Local cArq      := ""
	Local cMsg      := ""
	Local _nLin
	Local _cCopia  := ""
	Local cAttach  := ""
	Local _cEmail  := "renato.oliveira@steck.com.br"

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

	Z16->(DbSeek(Z15->(Z15_FILIAL+Z15_DOC)))

	While Z16->(!Eof()) .And. Z15->(Z15_FILIAL+Z15_DOC)==Z16->(Z16_FILIAL+Z16_DOC)
		_nQtdIte++
		If !Empty(Z16->Z16_ATENDE)
			_nQtdAlt++
		EndIf
		Z16->(DbSkip())
	EndDo

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	Begin Transaction

		If _nQtdIte==_nQtdAlt

			Z15->(RecLock("Z15",.F.))
			Z15->Z15_STATUS := "1"
			Z15->(MsUnLock())

			Z16->(DbSeek(Z15->(Z15_FILIAL+Z15_DOC)))

			While Z16->(!Eof()) .And. Z15->(Z15_FILIAL+Z15_DOC)==Z16->(Z16_FILIAL+Z16_DOC)
				If SC6->(DbSeek(Z15->(Z15_FILIAL+Z15_PEDIDO)+Z16->Z16_ITEM))
					If Z16->Z16_ATENDE=="S"
						SC6->(RecLock("SC6",.F.))
						SC6->C6_ZENTRE2 := Z16->Z16_NOVADT
						SC6->(MsUnLock())
					EndIf
					AADD(_aItens,{Z16->Z16_ITEM,Z16->Z16_PROD,Z16->Z16_DESC,Z16->Z16_QTD,Z16->Z16_ATENDE,Z16->Z16_NOVADT,Z16->Z16_OBSRET})
				EndIf
				Z16->(DbSkip())
			EndDo

			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(Z15->(Z15_FILIAL+Z15_PEDIDO)))

			//MsgAlert("Previsões alteradas com sucesso, obrigado!")

			_cAssunto := "[WFPROTHEUS] - Solicitação de novo prazo - "+Z15->Z15_DOC

			cMsg := ''
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			cMsg += '<br>
			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Filial</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Pedido</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Cliente</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Loja</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Nome</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Emissão</Font></B></TD>'
			cMsg += '</TR>'
			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_FILIAL+'</Font></TD>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_NUM+'</Font></TD>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_CLIENTE+'</Font></TD>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_LOJACLI+'</Font></TD>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")+'</Font></TD>'
			cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+DTOC(SC5->C5_EMISSAO)+'</Font></TD>'
			cMsg += '</TR>'
			cMsg += '</Table>'
			cMsg += '<br>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Descrição</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Qtde</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Status</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Nova data</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Observação</Font></B></TD>'
			cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Usuário</Font></B></TD>'
			cMsg += '</TR>'

			For _nLin := 1 to Len(_aItens)
				If (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(_aItens[_nLin,4]) + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + IIf(_aItens[_nLin,5]=="S","Aprovado","Rejeitado") + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + DTOC(_aItens[_nLin,6]) + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cUserName + ' </Font></TD>'
				cMsg += '</TR>'

			Next

			cMsg += '</body>'
			cMsg += '</html>'

			If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
				MsgInfo("Email não Enviado..!!!!")
			EndIf

		EndIf

	End Transaction

Return lGrv