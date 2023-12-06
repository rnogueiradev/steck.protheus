#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT060        | Autor | RENATO.OLIVEIRA           | Data | 14/01/2019  |
|=====================================================================================|
|Descrição | Tela para acompanhamento de pedidos/orçamentos sem custo                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT060()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	DbSelectArea("Z23")
	Z23->(DbSetOrder(1))

	DbSelectArea("Z24")
	Z24->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Pedidos/Orçamentos sem custo/preço")
	oBrowse1:SetAlias("Z23")

	oBrowse1:AddLegend("Z23->Z23_STATUS=='1'"	,"RED"		,"Aguardando custo/preço")
	oBrowse1:AddLegend("Z23->Z23_STATUS=='2'"	,"GREEN"	,"Custo/preço cadastrado")

	oBrowse1:SetUseCursor(.F.)

	oBrowse1:Activate()

Return()

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT050" 	OPERATION 2  ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z23')
	Local oStr2:= FWFormStruct(1,'Z24')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)

	aAdd(_aRel, { 'Z24_FILIAL'	, 'Z23_FILIAL' } )
	aAdd(_aRel, { 'Z24_TIPO'	, 'Z23_TIPO' } )
	aAdd(_aRel, { 'Z24_NUM'		, 'Z23_NUM' } )

	oModel:SetRelation('GRID1', _aRel , Z24->(IndexKey(1)) )

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')
	oModel:getModel('GRID1'):SetDescription('Itens')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'Z23')
	Local oStr2:= FWFormStruct(2, 'Z24')
	Local oModel     := FWLoadModel("STFAT060")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 30)
	oView:CreateHorizontalBox( 'BOXFORM3', 70)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM3','BOXFORM3')

	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
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

	Local lGrv				:= .T.
	Local nOp         := oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT061
@name STFAT061
@type User Function
@desc verifica se existem produtos sem custo
@author Renato Nogueira
@since 14/01/2019
/*/

User Function STFAT061(_cTipo)

	Local _aArea 	:= GetArea()
	Local _aItens	:= {}
	Local _cFilial	:= ""
	Local _cNumero	:= ""
	Local _cCliente	:= ""
	Local _cLoja	:= ""
	Local _aItens	:= {}
	Local _aItens1	:= {}
	Local _cAssunto := ""
	Local _cEmail 	:= ""
	Local _cCopia	:= AllTrim(GetMv("STFAT0611",,"reinaldo.franca@steck.com.br;jadson.silva@steck.com.br;gisele.jesus@steck.com.br;rosely.moraes@steck.com.br"))
	Local cAttach	:= ""
	Local _lEnvia	:= .F.
	Local _nX 		:= 0
	Local _lProdAM  := .F.

	_cTipo := AllTrim(_cTipo)

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))

	DbSelectArea("SU7")
	SU7->(DbSetOrder(1))

	Do Case
		Case _cTipo=="1" //Orçamento

		_cFilial 	:= SUA->UA_FILIAL
		_cNumero 	:= SUA->UA_NUM
		_cCliente	:= SUA->UA_CLIENTE
		_cLoja		:= SUA->UA_LOJA

		SA1->(DbSeek(xFilial("SUA")+SUA->(UA_CLIENTE+UA_LOJA)))

		If SU7->(DbSeek(xFilial("SU7")+SUA->UA_OPERADO))
			If SA3->(DbSeek(xFilial("SA3")+SU7->U7_CODVEN))
				_cEmail := AllTrim(SA3->A3_EMAIL)+";"
			EndIf
		EndIf

		If SA3->(DbSeek(xFilial("SA3")+SA3->A3_SUPER))
			_cEmail := AllTrim(SA3->A3_EMAIL)
			If 	SA3->A3_SUPER = 'S00010' .Or. 	SA3->A3_SUPER = 'A00001'

				_cCopia += ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR'
			EndIf
			If 	SA3->A3_SUPER = 'S00012'

				_cCopia += ';marcelo.oliveira@steck.com.br'

			EndIf
		EndIf

		DbSelectArea("SUB")
		SUB->(DbSetOrder(1))
		SUB->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))

		While SUB->(!Eof()) .And. SUA->(UA_FILIAL+UA_NUM)==SUB->(UB_FILIAL+UB_NUM)

			If SB1->(DbSeek(xFilial("SB1")+SUB->UB_PRODUTO))
				If U_STCUSTO(SUB->UB_PRODUTO)<=0 .And. !(AllTrim(SUB->UB_PRODUTO)=="SCONSULTA")
					AADD(_aItens,{SUB->UB_ITEM,SUB->UB_PRODUTO,SB1->B1_DESC,SUB->UB_QUANT,SB1->B1_CLAPROD})
					If U_STGETORI(SUB->UB_PRODUTO,"03")=="F"
						_lProdAM := .T.
					EndIf
				EndIf
				If SUB->UB_VRUNIT <= 0.01 .And. !(AllTrim(SUB->UB_PRODUTO)=="SCONSULTA")
					AADD(_aItens1,{SUB->UB_ITEM,SUB->UB_PRODUTO,SB1->B1_DESC,SUB->UB_QUANT,SB1->B1_CLAPROD})
				EndIf

			EndIf

			SUB->(DbSkip())
		EndDo

		Case _cTipo=="2" //Pedido

		_cFilial 	:= SC5->C5_FILIAL
		_cNumero 	:= SC5->C5_NUM
		_cCliente	:= SC5->C5_CLIENTE
		_cLoja		:= SC5->C5_LOJACLI

		SA1->(DbSeek(xFilial("SC5")+SUA->(C5_CLIENTE+C5_LOJACLI)))

		_cEmail := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(SC5->(C5_FILIAL+C5_CLIENTE)))

		While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)

			If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				If U_STCUSTO(SC6->C6_PRODUTO)<=0 .And. !(AllTrim(SC6->C6_PRODUTO)=="SCONSULTA")
					AADD(_aItens,{SC6->C6_ITEM,SC6->C6_PRODUTO,SB1->B1_DESC,SC6->C6_QTDVEN,SB1->B1_CLAPROD})
					If U_STGETORI(SUB->UB_PRODUTO,"03")=="F"
						_lProdAM := .T.
					EndIf
				EndIf
				If SC6->C6_PRCVEN <= 0.01 .And. !(AllTrim(SC6->C6_PRODUTO)=="SCONSULTA")
					AADD(_aItens1,{SC6->C6_ITEM,SC6->C6_PRODUTO,SB1->B1_DESC,SC6->C6_QTDVEN,SB1->B1_CLAPROD})
				EndIf
			EndIf

			SC6->(DbSkip())
		EndDo

	EndCase

	If Len(_aItens)>0 .Or. Len(_aItens1)>0

		If Len(_aItens)>0
			If _cTipo=="1"
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XBLOQ 	:= "1"
				If !("CUS" $ AllTrim(SUA->UA_XDESBLQ))
					SUA->UA_XDESBLQ	:= AllTrim(SUA->UA_XDESBLQ)+"CUS/"
				EndIf
				SUA->(MsUnLock())
			ElseIf _cTipo=="2"
				SC5->(RecLock("SC5",.F.))
				SC5->C5_ZBLOQ 	:= "1"
				If !("CUS" $ AllTrim(SC5->C5_ZMOTBLO))
					SC5->C5_ZMOTBLO	:= AllTrim(SC5->C5_ZMOTBLO)+"CUS/"
				EndIf
				SC5->(MsUnLock())
			EndIf
		EndIf

		DbSelectArea("Z24")
		Z24->(DbSetOrder(1))

		DbSelectArea("Z23")
		Z23->(DbSetOrder(1))
		If !Z23->(DbSeek(_cFilial+_cTipo+_cNumero))

			_lEnvia := .T.

			Z23->(RecLock("Z23",.T.))
			Z23->Z23_FILIAL := _cFilial
			Z23->Z23_TIPO	:= _cTipo
			Z23->Z23_NUMERO	:= _cNumero
			Z23->Z23_CLIENT := _cCliente
			Z23->Z23_LOJA 	:= _cLoja
			Z23->Z23_DATA	:= Date()
			Z23->Z23_HORA	:= Time()
			Z23->Z23_STATUS	:= "1"

			If Len(_aItens1)>0
				Z23->Z23_TPBLOQ := "PRECO"
				_cAssunto := "[WFPROTHEUS] - Acompanhamento de produtos sem preço - PENDENTE - "+Z23->Z23_NUMERO
				_cCopia   := ""
			Else
				Z23->Z23_TPBLOQ := "CUSTO"
				_cAssunto := "[WFPROTHEUS] - Acompanhamento de produtos sem custo - PENDENTE - "+Z23->Z23_NUMERO
			EndIf

			Z23->(MsUnLock())

		EndIf

		For _nX:=1 To Len(_aItens)
			If !Z24->(DbSeek(_cFilial+_cTipo+_cNumero+_aItens[_nX][1]))
				Z24->(RecLock("Z24",.T.))
				Z24->Z24_FILIAL := _cFilial
				Z24->Z24_TIPO	:= _cTipo
				Z24->Z24_NUMERO	:= _cNumero
				Z24->Z24_ITEM	:= _aItens[_nX][1]
				Z24->Z24_PROD	:= _aItens[_nX][2]
				Z24->Z24_DESC	:= _aItens[_nX][3]
				Z24->Z24_QTDE	:= _aItens[_nX][4]
				Z24->(MsUnLock())
			EndIf
		Next

		If _lEnvia

			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>'  + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
			cMsg += '<tr><td><b>Filial</b></td><td><b>Tipo</b></td><td><b>Número</b></td><td><b>Item</b></td><td><b>Produto</b></td><td><b>Origem</b></td></tr>'

			If Len(_aItens1)>0
				_aItens := aClone(_aItens1)
			EndIf

			For _nX:=1 To Len(_aItens)

				If (_nX/2) == Int(_nX/2 )
					cMsg += '<TR BgColor=#FFFFFF>'
				Else
					cMsg += '<TR BgColor=#B0E2FF>'
				EndIf

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _cFilial	+ ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ IIf(_cTipo=="1","Orçamento","Pedido")	+ ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _cNumero 	+ ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _aItens[_nX][1]  	+ ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _aItens[_nX][2]	+ ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _aItens[_nX][5]	+ ' </Font></TD>'
				cMsg += '</TR>'

			Next

			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STFAT060.PRW)</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'

			If _lProdAM .And. AllTrim(Z23->Z23_TPBLOQ)=="CUSTO"
				_cCopia += ";mateus.ferreira@steck.com.br; silvana.silva@steck.com.br"
			EndIf

			U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)

		EndIf

	EndIf

	RestArea(_aArea)

Return()

/*/{Protheus.doc} STFAT062
@name STFAT062
@type User Function
@desc verifica se existem produtos sem custo
@author Renato Nogueira
@since 14/01/2019
/*/

User Function STFAT062()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local cNewEmp 	:= "01"
	Local cNewFil	:= "02"
	Local _cFilial	:= ""
	Local _cNumero	:= ""
	Local _cCliente	:= ""
	Local _cLoja	:= ""
	Local _aItens	:= {}
	Local _aItens1	:= {}
	Local _cAssunto := ""
	Local _cEmail 	:= "renato.oliveira@steck.com.br"
	Local _cCopia	:= ""
	Local cAttach	:= ""
	Local _lEnvia	:= .F.
	Local _nX		:= 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	DbSelectArea("Z23")

	_cTipo := Z23->Z23_TIPO

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))

	_cQuery1 := " SELECT Z23.R_E_C_N_O_ RECZ23
	_cQuery1 += " FROM "+RetSqlName("Z23")+" Z23
	_cQuery1 += " WHERE Z23.D_E_L_E_T_=' ' AND Z23_STATUS='1'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_aItens	:= {}

		Z23->(DbGoTo((_cAlias1)->RECZ23))

		If Z23->(!Eof())

			Do Case
				Case AllTrim(Z23->Z23_TIPO)=="1"

				_cFilial 	:= SUA->UA_FILIAL
				_cNumero 	:= SUA->UA_NUM
				_cCliente	:= SUA->UA_CLIENTE
				_cLoja		:= SUA->UA_LOJA

				SA1->(DbSeek(xFilial("SUA")+SUA->(UA_CLIENTE+UA_LOJA)))

				_cEmail := Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")

				DbSelectArea("SUB")
				SUB->(DbSetOrder(1))
				SUB->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))

				While SUB->(!Eof()) .And. SUA->(UA_FILIAL+UA_NUM)==SUB->(UB_FILIAL+UB_NUM)

					If SB1->(DbSeek(xFilial("SB1")+SUB->UB_PRODUTO))
						If U_STCUSTO(SUB->UB_PRODUTO)<=0 .And. !(AllTrim(SUB->UB_PRODUTO)=="SCONSULTA")
							AADD(_aItens,{SUB->UB_ITEM,SUB->UB_PRODUTO,SB1->B1_DESC,SUB->UB_QUANT})
						EndIf
						If SUB->UB_VRUNIT <= 0.01 .And. !(AllTrim(SUB->UB_PRODUTO)=="SCONSULTA")
							AADD(_aItens1,{SUB->UB_ITEM,SUB->UB_PRODUTO,SB1->B1_DESC,SUB->UB_QUANT})
						EndIf
					EndIf

					SUB->(DbSkip())
				EndDo

				Case AllTrim(Z23->Z23_TIPO)=="2"

				_cFilial 	:= SC5->C5_FILIAL
				_cNumero 	:= SC5->C5_NUM
				_cCliente	:= SC5->C5_CLIENTE
				_cLoja		:= SC5->C5_LOJACLI

				SA1->(DbSeek(xFilial("SC5")+SUA->(C5_CLIENTE+C5_LOJACLI)))

				_cEmail := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")

				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				SC6->(DbSeek(SC5->(C5_FILIAL+C5_CLIENTE)))

				While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)

					If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
						If U_STCUSTO(SC6->C6_PRODUTO)<=0 .And. !(AllTrim(SC6->C6_PRODUTO)=="SCONSULTA")
							AADD(_aItens,{SC6->C6_ITEM,SC6->C6_PRODUTO,SB1->B1_DESC,SC6->C6_QTDVEN})
						EndIf
						If SC6->C6_PRCVEN <= 0.01 .And. !(AllTrim(SC6->C6_PRODUTO)=="SCONSULTA")
							AADD(_aItens1,{SC6->C6_ITEM,SC6->C6_PRODUTO,SB1->B1_DESC,SC6->C6_QTDVEN})
						EndIf
					EndIf

					SC6->(DbSkip())
				EndDo

			EndCase

		EndIf

		If (Len(_aItens)==0 .And. AllTrim(Z23->Z23_TPBLOQ)=="CUSTO") .Or.;
		(Len(_aItens1)==0 .And. AllTrim(Z23->Z23_TPBLOQ)=="PRECO")

			If AllTrim(Z23->Z23_TPBLOQ)=="PRECO"
				_cAssunto := "[WFPROTHEUS] - Acompanhamento de produtos sem preço - OK - "+Z23->Z23_NUMERO
			Else
				_cAssunto := "[WFPROTHEUS] - Acompanhamento de produtos sem custo - OK - "+Z23->Z23_NUMERO
			EndIf

			Z23->(RecLock("Z23",.F.))
			Z23->Z23_STATUS := "2"
			Z23->(MsUnLock())

			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>'  + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
			cMsg += '<tr><td><b>Filial</b></td><td><b>Tipo</b></td><td><b>Número</b></td></tr>'

			cMsg += '<TR BgColor=#B0E2FF>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _cFilial	+ ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ IIf(_cTipo=="1","Orçamento","Pedido")	+ ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' 	+ _cNumero 	+ ' </Font></TD>'
			cMsg += '</TR>'

			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STFAT060.PRW)</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'

			//_cEmail 	:= "renato.oliveira@steck.com.br"

			U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return