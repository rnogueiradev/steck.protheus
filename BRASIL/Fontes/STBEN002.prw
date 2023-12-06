#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#define enter chr(13)+chr(10) 

/*/{Protheus.doc} STBEN002
Função para Aprovar / Faturar o pedido de beneficiamento.
@author Robson Mazzarotto
@since 19/12/2016
@version 1.0
/*/
 
User Function STBEN002()
 
Local oBrowse 
Private aRotina := Menudef()
 
oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SC5")  
oBrowse:SetDescription("Aprovar/Faturar Beneficiamento")
oBrowse:AddLegend( "SC5->C5_XPLAAPR == 'S' .And. SC5->C5_ZFATBLQ == '3'", "GREEN", "Pedido liberado para faturamento" )
oBrowse:AddLegend( "SC5->C5_XPLAAPR == 'N' .And. SC5->C5_ZFATBLQ == '3' .AND. EMPTY(SC5->C5_NOTA)", "RED",   "Pedido bloqueado para faturamento" )  
oBrowse:AddLegend( "SC5->C5_XPLAAPR == 'S' .And. !EMPTY(SC5->C5_NOTA)", "BLACK", "Pedido faturado" )  
oBrowse:AddLegend( "SC5->C5_XPLAAPR == 'R' .And. SC5->C5_ZFATBLQ == '3' ", "BR_MARRON",   "Pedido Rejeitado" )  
//Browse:AddLegend( "('XXXXXXXXX' $ SC5->C5_NOTA) .And. SC5->C5_ZFATBLQ == '3' .AND. SC5->C5_XPLAAPR == 'N'", "BR_MARRON", "Pedido faturado" )
oBrowse:AddLegend( "('XXXX' $ SC5->C5_NOTA) .And. SC5->C5_ZFATBLQ $ '1/2'"	, "BR_LARANJA", "Eliminado Residuo" )

oBrowse:SetFilterDefault( "!Empty(C5_XPLAAPR)" )
oBrowse:Activate()
    
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Robson Mazzarotto                                            |
 | Data:  19/12/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar" 	ACTION 'ViewDef.STBEN002' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Aprovar"    	ACTION 'u_STAPROVAR' 	  OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE "Rejeitar"    	ACTION 'u_STFREJEIT'      OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE "Faturar"    	ACTION 'u_STFATURAR'      OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'      ACTION 'u_STBEN2LEG'      OPERATION 6 ACCESS 0 

Return aRotina 


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados
@author Robson Mazzarotto
@since 19/12/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()

Local oModel

Local oStr2:= FWFormStruct(1,'SC5')
Local oStr3:= FWFormStruct(1,'SC6')

oModel := MPFormModel():New('STBEN02')
oModel:addFields('FIELD1',,oStr2)

oModel:addGrid('GRID1','FIELD1',oStr3)

oModel:SetRelation('GRID1', { { 'C6_FILIAL', 'C5_FILIAL' }, { 'C6_NUM', 'C5_NUM' } }, SC6->(IndexKey(1)) )

oModel:getModel('FIELD1'):SetDescription('Cabec')
oModel:getModel('GRID1'):SetDescription('Itens')

Return oModel


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface
@author Robson Mazzarotto
@since 19/12/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()

Local oView
Local oModel := ModelDef()
Local oStr1:= FWFormStruct(2, 'SC5')
Local oStr2:= FWFormStruct(2, 'SC6')

oView := FWFormView():New()

oView:SetModel(oModel)

oView:AddField('FORM1' , oStr1,'FIELD1' )
oView:AddGrid('FORM3' , oStr2,'GRID1')  

oView:CreateHorizontalBox( 'BOXFORM1', 50)
oView:CreateHorizontalBox( 'BOXFORM3', 50)

oView:SetOwnerView('FORM3','BOXFORM3')
oView:SetOwnerView('FORM1','BOXFORM1')

Return oView


User Function STBEN2LEG()
Local aLegenda := {}
     
    AADD(aLegenda,{"BR_VERDE",      "Pedido liberado para faturamento"  })
    AADD(aLegenda,{"BR_VERMELHO",   "Pedido bloqueado para faturamento"})
    AADD(aLegenda,{"BR_PRETO",      "Pedido faturado"})
 	AADD(aLegenda,{"BR_MARRON",     "Pedido Rejeitado"})
 	AADD(aLegenda,{"BR_LARANJA",     "Eliminado Residuo"})

    BrwLegenda("Aprovar/Faturar", "Beneficiamento", aLegenda)
Return

/*
	Autor:		Valdemir Rabelo
	Data:		26/07/2019
	Descrição:	Rejeita o Pedido
*/
User Function STFREJEIT()
	Local lRet       := .T.
	Local cArea      := GetArea()
	Local cAprov     := getmv("ST_XAPROV")
	Private cNumOP   := cNumPed := ""

	   
	If RetCodUsr() $ cAprov
		
		if SC5->C5_XPLAAPR == "S" .and. Empty(SC5->C5_NOTA)
			
			FWMsgRun(, {|| Sleep(3000)},'Atenção', 'Este Pedido já está aprovado!')
			
		Elseif SC5->C5_XPLAAPR == 'S' .And. !EMPTY(SC5->C5_NOTA)

			FWMsgRun(, {|| Sleep(3000)},'Atenção', 'Este Pedido já foi faturado!')
			
		Elseif Empty(SC5->C5_NOTA) .And. SC5->C5_ZFATBLQ == '3' .AND. SC5->C5_XPLAAPR == 'R'

			FWMsgRun(, {|| Sleep(3000)},'Atenção', 'Este Pedido já esta Rejeitado!')
		Else
			lRet := MsgYesNo("Deseja Realmente Rejeitar este pedido?", "Atenção")
			
			if lRet 
				dbSelectArea("ZZ8")
				ZZ8->( dbSetOrder(1) )
				IF !ZZ8->( dbSeek(xFilial("ZZ8")+SC5->C5_XPLAN) )   // Posiciono o Registro ZZ8
					FWMsgRun(, {|| u_STBENEST(.T.)},,"Problemas ao tentar localizar o Beneficamento da Tabela: ZZ8")
					Return
				ENDIF
				cPedido := SC5->C5_NUM
				// Realizando Estorno do processo de Beneficiamento
				FWMsgRun(, {|| lRet := u_STBENEST(.T.)},,"Aguarde, Rejeição em andamento")
				
				if lRet
					// Marco a SC5 como Rejeitado
					RecLock('SC5', .F.)
					C5_XPLAAPR := "R"
					SC5->(MsUnlock())

					// Envio workflow de Rejeição - Valdemir Rabelo 26/07/2019
					EMailRej()
				Endif
			Endif
			
		Endif

	else

		lRet := .F.
		FWMsgFun(, {|| Sleep(3000)},'Atenção', 'Usuário não tem permissão para aprovar o Pedido!')

	Endif

	RestArea(cArea)

Return lRet



User Function STAPROVAR()
  
Local lRet       := .T.
Local cArea      := GetArea()
Local cAprov     := getmv("ST_XAPROV")
     
   
If RetCodUsr() $ cAprov
	
	if SC5->C5_XPLAAPR == "S"
		
		Aviso('Atenção', 'Este Pedido já está aprovado!', {'OK'}, 03)
		
	Elseif SC5->C5_XPLAAPR == "F"
	
		Aviso('Atenção', 'Este Pedido já foi faturado!', {'OK'}, 03)
		
	Elseif 'XXXXXXXXX' $ SC5->C5_NOTA .And. SC5->C5_ZFATBLQ == '3' .AND. SC5->C5_XPLAAPR == 'N'
	
		Aviso('Atenção', 'Este Pedido está cancelado e não pode ser aprovado!', {'OK'}, 03)
	
	Else
		lRet := MsgYesNo("Deseja Aprovar este pedido?", "Atenção")
		
		if lRet = .T.
			RecLock('SC5', .F.)
			C5_XPLAAPR := "S"
			SC5->(MsUnlock())
		Endif
		
	Endif
	
else
	
	lRet := .F.
	Aviso('Atenção', 'Usuário não tem permissão para aprovar o Pedido!', {'OK'}, 03)
	
Endif

RestArea(cArea)

Return lRet



User Function STFATURAR()
  
Local lRet       := .T.
Local cArea      := GetArea()
Local cFat       := getmv("ST_XFATURA")
Local cPedido    := ""   
   
If RetCodUsr() $ cFat
	
	if SC5->C5_XPLAAPR == "N" .AND. SC5->C5_ZFATBLQ == '3'
		
		Aviso('Atenção', 'Este Pedido ainda não foi aprovado para Faturamento!', {'OK'}, 03)
	
	Elseif SC5->C5_XPLAAPR == "F"
	
		Aviso('Atenção', 'Este Pedido já foi faturado!', {'OK'}, 03)
	
	Elseif 'XXXXXXXXX' $ SC5->C5_NOTA .And. SC5->C5_ZFATBLQ == '3' .AND. SC5->C5_XPLAAPR == 'N'
	
		Aviso('Atenção', 'Este Pedido foi cancelado e não pode ser faturado!', {'OK'}, 03)
			
	Else
		lRet := MsgYesNo("Deseja Realizar o faturamento deste pedido?", "Atenção")
		
		if lRet = .T.
			cPedido		:= SC5->C5_NUM
			
			//Busca Tabela de Preço do Fornecedor
			//cTabPrcFor	:= Posicione("AIB",1,xFilial("AIB")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"AIB_CODTAB")
			
			//Valida tabela de preço para verificar se está vigente
			cTabPrcFor	:= U_STGetTab(SC5->C5_CLIENTE,SC5->C5_LOJACLI)

			//If Empty(cTabPrcFor)
			//	MsgAlert("Não existe tabela de preço vigente para o fornecedor informado para geração do pedido de compra","Atenção")
			//EndIf

			u_STBenped(cPedido,cTabPrcFor)
			
		Endif
		
	Endif
	
else
	
	lRet := .F.
	Aviso('Atenção', 'Usuário não tem permissão para realizar faturamento!', {'OK'}, 03)
	
Endif

RestArea(cArea)

Return lRet


/*
	Autor:		Valdemir Rabelo
	Data:		26/07/2019
	Descrição:	Envio de e-mail para Rejeitado
*/
Static Function EMailRej()
	Local lResult			:= .F.
	Local cAccount		:= SuperGetMV( "MV_RELAUSR",, ""  ) // Conta dominio 	Ex.: Teste@email.com.br
	Local cPassword		:= SuperGetMV( "MV_RELAPSW",,  ""  ) // Pass da conta 	Ex.: Teste123
	Local cServer		:= SuperGetMV( "MV_RELSERV",, ""  ) // Smtp do dominio	Ex.: smtp.email.com.br
	Local cFrom   		:= UsrRetMail( ZZ8->ZZ8_USUARI )    // E-mail do usuário solicitante
	Local cCC   		:= SuperGetMV( "ST_MAILREJ",, ""  ) // "gerente01@email.com.br"
	Local lRelauth  	:= SuperGetMv( "MV_RELAUTH",, .T. ) // Utiliza autenticação
	Local cBody			:= ST002MntMsg()
	local lAut			:= .F.
	Local cSubject		:= ""

	U_STMAILTES(cFrom, cCC, cSubject, cBody,{},"")

Return

/*
	Autor		:	Valdemir Rabelo
	Data		:	29/07/2019
	Descrição	:	Prepara o corpo do e-mail
*/
Static Function ST002MntMsg(  )
	Local cMsg      := ""
	Local cCaminho	:= ""
	Local nVlTot    := 0
	Local _aMsg     := {}
	Local _cAssunto := 'Pedido de venda de Beneficiamento < REJEITADO >'
	Local _nLin
	
	SC6->( dbSeek(xFilial('SC6')+SC5->C5_NUM))
	SC6->( dbEVal( {|| nVlTot += C6_VALOR},, {|| !Eof() .and. SC6->C6_FILIAL==SC5->C5_FILIAL .and. SC6->C6_NUM==SC5->C5_NUM } ))

	cNome := Posicione("SA2",1,xFilial('SA2')+SC5->C5_CLIENTE, 'A2_NOME')
	IF Empty(cNome)
		cNome := Posicione("SA1",1,xFilial('SA1')+SC5->C5_CLIENTE, 'A1_NOME')
	Endif
	Aadd( _aMsg , { "Numero Pedido: "   , SC5->C5_NUM } )
	Aadd( _aMsg , { "Planejamento: "    , ZZ8->ZZ8_REGIST } )
	Aadd( _aMsg , { "Nome: "    		, cNome } )
	Aadd( _aMsg , { "Total: "    		, transform(nVlTot	,"@E 999,999,999.99")  } )
	Aadd( _aMsg , { "Emissao: "    		, dtoc(SC5->C5_EMISSAO) } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	Aadd( _aMsg , { "Observação : "     , "Aprovação Rejeitada - Registros associado ao planejamento serão estornados" } )

	//A Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//A Definicao do texto/detalhe do email                                         
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email                                               
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
Return cMsg















/*
cMsg := ' <html>'
	cMsg += ' <head>'
	cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	cMsg += '<title>Pedido de venda de Beneficiamento < REJEITADO ></title>'
	cMsg += '<style type="text/css">'
	cMsg += '<!--'
	cMsg += 'body{'
	cMsg += 'margin:0;'
	cMsg += '	padding:0;'
	cMsg += 'background-color:#c7e4ec;'
	cMsg += '}'
	cMsg += '-->'
	cMsg += '</style>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<table cellpadding="0" cellspacing="0" border="0" width="100%" style="width:100%;background-color:#c7e4ec;width:100%" bgcolor="#c7e4ec">'
	cMsg += '	<tr>'
	cMsg += '		<td>'
	cMsg += '			<table cellpadding="0" cellspacing="0" border="0" width="600px" align="center" style="width:600px;font-family:Verdana, Helvetica, sans-serif;color:#333333;font-size:13px;line-height:150%">'
	cMsg += '				<tr>'
	cMsg += '					<td style="border-top:5px #5db9cf solid;border-bottom:5px #5db9cf solid" >'
	cMsg += '						<img src="'+cCaminho+'" style="display:block" border="0" />' //cCaminho = Definir o caminho da imagem que será apresentada no e-mail
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#FFFFFF" valign="top" align="center" style="padding:10px;color:#212121;font-size:15px;font-weight:bold" >'
	cMsg += '						Beneficiamento não aprovado'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#FFFFFF" style="padding:20px;padding-bottom:0px;color:#212121" align="center">'
	cMsg += '						Prezado(a),'
	cMsg += '						<br></br>'
	cMsg += '						Informamos que o Pedido do beneficiamento mencionado neste não foi aprovado. O pedido de venda e a ordem de produção serão estornadas'
	cMsg += '						<br></br>'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#5db9cf" valign="top" align="left" style="font-family:Arial Narrow, Arial, Helvetica, sans-serif;font-size:18px; font-weight:bold;color:#ffffff;">'
	cMsg += '					&nbsp; &nbsp; Dados do Pedido:'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '                    <td colspan="2" bgcolor="#FFFFFF" "font-family:Arial Narrow, Arial, Helvetica, sans-serif; font-size:14px; color:#212121;">'
	cMsg += '					<br></br>'
	cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Número do Pedido: </span> ' +SC5->C5_NUM
	cMsg += '                   <br></br>'
	cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Planejamento: </span> ' +ZZ8->ZZ8_REGIST
	cMsg += '                   <br></br>'
	cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Ordem de Produção: </span> ' +ZZ8->ZZ8_OP
	cMsg += '                   <br></br>'
	cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Custo Total: </span> ' +CValToChar( nVlTot )
	cMsg += '                   <br></br>'
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Fornecedor: </span> ' +SC5->C5_CLIENTE
	cMsg += '                        <br></br>'
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Data: </span> ' +DtoC( Date() )
	cMsg += '                        <br></br>'
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Hora: </span> ' +Time()
	cMsg += '                        <br></br>'
	cMsg += '						<br></br>'
	cMsg += '					</td>'
	cMsg += '                </tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" style="padding-top:10px;font-size:11px">'
	cMsg += '						<i>'
	cMsg += '						Você esté recebendo esta mensagem porque está cadastrado como responsável. Caso não deseje receber esse tipo de mensagem, por favor, entre em contato com o Administrador do sistema.'
	cMsg += '						</i>'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '			</table>'
	cMsg += '		</td>'
	cMsg += '	</tr>'
	cMsg += '</table>'
	cMsg += '</body>'
	cMsg += '</html>'
*/