#include 'totvs.ch'
#Include 'protheus.ch'
#Include 'topconn.ch'
#Include "RestFul.CH"
#Include 'parmtype.ch'


Static aRET := { {"00","SALVO COM SUCESSO"},{"02","HORARIO INDISPONIVEL"},{"99","ERRO AO CONVERTER O JASON"},{"10","PROTOCOLO NAO ENCONTRADO"}, {"20","PROTOCOLO JA RETIRADO"}, {"30","NAO FOI INFORMADO PROTOCOLO"}}

User Function APIAGEPD()
Return

/*/{Protheus.doc} AGENDAMENTO
Definição da estrutura do webservice
@author Victor Andrade
@since 13/04/2017
@type class
/*/
	WSRESTFUL AGENDAMENTO DESCRIPTION "Serviço REST para manipulação de AGENDAMENTO"  FORMAT APPLICATION_JSON

		WSDATA PROTOCOLO As String          //String que recebe o protocolo

		WSMETHOD GET  DESCRIPTION "Retorna Informações Referente ao Agendamento"  WSSYNTAX "/REST/AGENDAMENTO/{PROTOCOLO}"
		WSMETHOD POST DESCRIPTION 'Inclusão de Agendas do Portal'                 WSSYNTAX '/REST/AGENDAMENTO'
		WSMETHOD PUT  DESCRIPTION "Atualiza Informações Referente ao Agendamento" WSSYNTAX "/REST/AGENDAMENTO/{PROTOCOLO}"

	END WSRESTFUL

/*/{Protheus.doc} GET
Processa as informações do Agendamento/Pedido e retorna o json
@author Valdemir Rabelo
@since 19/03/2021
@version undefined
@type Method
/*/
WSMETHOD GET WSRECEIVE PROTOCOLO WSSERVICE AGENDAMENTO
	Local cProtocolo := Self:PROTOCOLO
	Local aArea		 := GetArea()
	Local oObjAg	 := Nil
	Local cJson		 := ""
	Local _cEmp      := "01"
	Local _cFil      := '02'
	Local cToken     := ""
	Local aDataLogin := {}

	RpcClearEnv()
	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	// define o tipo de retorno do método
	::SetContentType("application/json")
	cToken  := Substr(Self:GetHeader('Authorization'),7,Len(Self:GetHeader('Authorization')))

	aDataLogin	:= Separa(DECODE64(cToken),":")
	If Len(aDataLogin) > 0
		cUsuario	:= aDataLogin[1]
		cSenha		:= aDataLogin[2]
	EndIf

	if Empty(cProtocolo)
		cResp := '{"CODRET":"'+aRET[6,1]+'","DESCRET":"'+aRET[6,2]+'"}'
		::SetResponse(cResp)
		Return .T.
	Endif

	DbSelectArea("ZS3")
	ZS3->( DbSetOrder(1) )
	If ZS3->( DbSeek( xFilial("ZS3") + cProtocolo ) )
		oObjAg := ItensPedidoProtocolo():New(cProtocolo)            //Cria um objeto da classe AGENDAMENTO para fazer a serialização na função FWJSONSerialize
		if (oObjAg:Status=="R")
			cResp := '{"CODRET":"'+aRET[4,1]+'","DESCRET":"'+aRET[4,2]+'"}'
			::SetResponse(cResp)
			Return .T.
		Endif
	else
		//::SetRestFault(500, EncodeUTF8('Não existem dados para serem apresentados'))
		cResp := '{"CODRET":"'+aRET[4,1]+'","DESCRET":"'+aRET[4,2]+'"}'
		::SetResponse(cResp)
		Return .T.
	endif

	// --> Transforma o objeto de AGENDAMENTO em uma string json
	cJson := FWJsonSerialize(oObjAg)

	// --> Envia o JSON Gerado para a aplicação Client
	::SetResponse(cJson)

	RestArea(aArea)

Return(.T.)



/*/{Protheus.doc} POST
description
Metodo para realizar a gravação
@type function
@version  1.00
@author Valdemir Jose
@since 19/03/2021
/*/
WSMETHOD POST WSSERVICE  AGENDAMENTO

	Local cResp 	:= ""
	Local cLink     := ""
	Local _cEmp     := "01"
	Local _cFil     := '02'
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _nX
	Local lAtivaKA  := .F.

	RpcClearEnv()
	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	oParseJson := ""
	lAtivaKA   := GetMV("ST_ATIVAKA",.F.,.T.)

	ConOut("[AGENDAMENTO]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[AGENDAMENTO]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType("application/json")
	cToken  := Substr(Self:GetHeader('Authorization'),7,Len(Self:GetHeader('Authorization')))

	aDataLogin	:= Separa(DECODE64(cToken),":")
	If Len(aDataLogin) > 0
		cUsuario	:= aDataLogin[1]
		cSenha		:= aDataLogin[2]
	EndIf

	_lRet := FWJsonDeserialize(_cXmlRec, @oParseJson)

	If !_lRet
		cResp := '{"CODRET":"'+aRET[3,1]+'","DESCRET":"'+aRET[3,2]+'"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	// Valido a informação recebida
	dbSelectArea("ZS3")
	dbSetOrder(1)
	if dbSeek(xFilial("ZS3")+oParseJson:PROTOCOLO)
		// Validar Horario para data
		lValid := getVldAG(oParseJson)
		if lValid

			RecLock("ZS3", .F.)
			ZS3->ZS3_DATAGE := CTOD(oParseJson:DATAAGE)
			ZS3->ZS3_HORAGE := oParseJson:HORAAGE
			ZS3->ZS3_CPF    := oParseJson:CPF
			ZS3->ZS3_VEICUL := oParseJson:VEICULO
			ZS3->ZS3_PLACA  := oParseJson:PLACA
			ZS3->ZS3_MOTORI := oParseJson:MOTORISTA
			ZS3->ZS3_TIPORT := IIF(UPPER(oParseJson:TIPO)=="CLIENTE","C","T")
			ZS3->ZS3_TRANSP := oParseJson:TRANSPORT
			ZS3->ZS3_STATUS := 'A'
			MsUnlock()

			// Envia informações a Key Access
			if lAtivaKA
				cLink := u_PostKAce(oParseJson:PROTOCOLO)
			Endif

			cResp := '{"CODRET":"'+aRET[1,1]+'","DESCRET":"'+aRET[1,2]+'","LINK":"'+cLink+'"}'     // Salvo com Sucesso
			::SetResponse(cResp)

			// Fazer envio e-mail do agendamento para Kleber - Valdemir Rabelo 19/04/2021
			U_EnviaWF('', 'ZS3', 'X',,,,cLink)
			Return .T.
		else
			cResp := '{"CODRET":"'+aRET[2,1]+'","DESCRET":"'+aRET[2,2]+'"}'     // horario Indisponivel
			::SetResponse(cResp)
			Return .T.
		endif

	Else
		cResp := '{"CODRET":"'+aRET[4,1]+'","DESCRET":"'+aRET[4,2]+'"}'     // Protocolo não encontrado
		::SetResponse(cResp)
		Return .T.

	Endif

Return .T.


/*/{Protheus.doc} PUT
description
Metodo para Atualizar os Dados
@type function
@version  1.00
@author Valdemir Jose
@since 19/03/2021
/*/
WSMETHOD PUT WSRECEIVE PROTOCOLO WSSERVICE  AGENDAMENTO
	Local cProtocolo := Self:PROTOCOLO
	Local cResp 	 := ""
	Local cLink      := ""
	Local _cEmp      := "01"
	Local _cFil      := '02'
	Local _cXmlRec 	 := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local aMuda      := {}
	Local lAtivaKA   := .F.
	Local _nX

	RpcClearEnv()
	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	oParseJson := ""
	lAtivaKA   := GetMV("ST_ATIVAKA",.F.,.T.)

	ConOut("[AGENDAMENTO]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[AGENDAMENTO]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType("application/json")
	_lRet := FWJsonDeserialize(_cXmlRec, @oParseJson)

	If !_lRet
		cResp := '{"CODRET":"'+aRET[3,1]+'","DESCRET":"'+aRET[3,2]+'"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	// Valido a informação recebida
	dbSelectArea("ZS3")
	dbSetOrder(1)
	if dbSeek(xFilial("ZS3")+cProtocolo)
		// Validar Horario para data
		lValid := getVldAG(oParseJson)
		if lValid
			// Verifico se houve alteração
			if (ZS3->ZS3_DATAGE <> CTOD(oParseJson:DATAAGE))
				aAdd(aMuda, {'ZS3_DATAGE', CTOD(oParseJson:DATAAGE)})
			endif
			if (ZS3->ZS3_HORAGE <> oParseJson:HORAAGE)
				aAdd(aMuda, {'ZS3_HORAGE', oParseJson:HORAAGE})
			endif
			if (ZS3->ZS3_CPF <> oParseJson:CPF)
				aAdd(aMuda, {'ZS3_CPF', oParseJson:CPF})
			endif
			if (ZS3->ZS3_VEICUL <> oParseJson:VEICULO)
				aAdd(aMuda, {'ZS3_VEICUL', oParseJson:VEICULO})
			endif
			if (ZS3->ZS3_PLACA  <> oParseJson:PLACA)
				aAdd(aMuda, {'ZS3_PLACA', oParseJson:PLACA})
			endif
			if (ZS3->ZS3_MOTORI <> oParseJson:MOTORISTA)
				aAdd(aMuda, {'ZS3_MOTORI', oParseJson:MOTORISTA})
			endif
			if (ZS3->ZS3_TRANSP <> oParseJson:TRANSPORT)
				aAdd(aMuda, {'ZS3_TRANSP', oParseJson:TRANSPORT})
			endif

			RecLock("ZS3", .F.)
			ZS3->ZS3_DATAGE := CTOD(oParseJson:DATAAGE)
			ZS3->ZS3_HORAGE := oParseJson:HORAAGE
			ZS3->ZS3_CPF    := oParseJson:CPF
			ZS3->ZS3_VEICUL := oParseJson:VEICULO
			ZS3->ZS3_PLACA  := oParseJson:PLACA
			ZS3->ZS3_MOTORI := oParseJson:MOTORISTA
			ZS3->ZS3_TIPORT := IIF(UPPER(oParseJson:TIPO)=="CLIENTE","C","T")
			ZS3->ZS3_TRANSP := oParseJson:TRANSPORT
			ZS3->ZS3_STATUS := 'A'
			MsUnlock()

			// Envia informações a Key Access
			if lAtivaKA
				cLink := u_PostKAce(oParseJson:PROTOCOLO)
			Endif

			cResp := '{"CODRET":"'+aRET[1,1]+'","DESCRET":"'+aRET[1,2]+'","LINK":"'+cLink+'"}'     // Salvo com Sucesso
			::SetResponse(cResp)

			// Fazer envio e-mail do agendamento para Kleber - Valdemir Rabelo 19/04/2021
			U_EnviaWF('', 'ZS3', 'X', aMuda,,,cLink)

			Return .T.
		else
			cResp := '{"CODRET":"'+aRET[2,1]+'","DESCRET":"'+aRET[2,2]+'"}'     // horario Indisponivel
			::SetResponse(cResp)
			Return .T.
		endif

	Else
		cResp := '{"CODRET":"'+aRET[4,1]+'","DESCRET":"'+aRET[4,2]+'"}'     // Protocolo não encontrado
		::SetResponse(cResp)
		Return .T.

	Endif

Return .T.


/*/{Protheus.doc} ADDAGEPD
description
Rotina que irá adicionar o registro no controle de agendamento
@type function
@version  1.00
@author Valdemir Jose
@since 16/03/2021
@return return_type, return_description
/*/
User Function ADDAGEPD()
	Local aZS3  := GetArea()
	Local lAdic := .T.
	Local lNovo := .T.

	dbSelectArea("ZS3")
	dbSetOrder(2)

	lAdic := (!dbSeek(xFilial("ZS3")+SC5->C5_NUM))      // Se não encontrou, deve criar o agendamento

	if !lAdic
		// Verificar se o pedido é parcial ou uma alteração de dados
		lNovo := getSC6New()
		U_GrvZS3(lNovo)
	else
		U_GrvZS3(lAdic)
	endif

	RestArea( aZS3 )

Return


/*/{Protheus.doc} getSC6New
description
Rotina Verifica se o pedido tem saldo
@type function
@version  1.00
@author Valdemir Jose
@since 16/03/2021
@return return_type, return_description
/*/
Static Function getSC6New()
	Local lRET := .F.
	Local cQry := ""

	cQry := "SELECT C5_NUM PEDIDO, B.C6_ENTREG DTENTREGA, SUM(B.C6_QTDVEN)-SUM(B.C6_QTDENT) SALDO  " + CRLF
	cQry += "FROM "+ RETSQLNAME("SC5") + " A         " + CRLF
	cQry += "INNER JOIN " + RETSQLNAME("SC6") + " B  " + CRLF
	cQry += "ON B.C6_FILIAL=A.C5_FILIAL AND B.C6_NUM=A.C5_NUM AND B.D_E_L_E_T_ = ' ' " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND A.C5_FILIAL='" +XFILIAL('SC5')+ "' " + CRLF
	cQry += " AND A.C5_NUM='" +SC5->C5_NUM+ "'       " + CRLF
	cQry += "GROUP BY C5_NUM, C6_ENTREG " + CRLF

	if Select("TC5") > 0
		TC5->( dbCloseArea() )
	endif

	tcQuery cQry New Alias "TC5"

	if TC5->( ! EOF() )
		lRET := (TC5->SALDO > 0) .AND. (STOD(TC5->DTENTREGA) > dDATABASE)
	Endif

	if Select("TC5") > 0
		TC5->( dbCloseArea() )
	endif

Return lRET

/*/{Protheus.doc} getSC6New
description
Rotina para salvar registro
@type function
@version  1.00
@author Valdemir Jose
@since 16/03/2021
@return return_type, return_description
/*/
User Function GrvZS3(lSit)
	Local cProxReg := getZS3Prx()
	Local cEmlCli  := ""
	Local lAtiva   := GetMV("ST_ATINPUT",.F.,.T.)

	RecLock('ZS3', lSit)
	if lSit
		ZS3->ZS3_FILIAL := XFILIAL("ZS3")
		ZS3->ZS3_CODIGO := cProxReg
	Endif
	ZS3->ZS3_TIPORT := ""                      // Tipo Retirada C=Cliente / T=Transporte
	ZS3->ZS3_PEDIDO := SC5->C5_NUM
	ZS3->ZS3_DATAGE := ctod("")
	ZS3->ZS3_HORAGE := ""
	ZS3->ZS3_MOTORI := ""
	ZS3->ZS3_CPF    := ""
	ZS3->ZS3_VEICUL := ""
	ZS3->ZS3_PLACA  := ""
	ZS3->ZS3_USUARI := cUserName
	ZS3->ZS3_DATA   := dDatabase
	ZS3->ZS3_HORA   := Time()
	MsUnlock()

	SA1-( dbSetOrder(1) )
	IF SA1->( dbSeek(xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI) ) )
		cEmlCli :=  ALLTRIM(SA1->A1_EMAIL)
		if lAtiva
		    if !FWIsIncall("U_SXGERSC5")
				If !IsBlind()
			   		cEmlCli := FWInputBox("Informe o(s) e-mail(s) para envio do WF", cEmlCli)
			    EndIf
			endif 
		Endif
		if !Empty(SC5->C5_VEND1)    // Adicionado Valdemir Rabelo - 17/06/2021
			cEmlCli += "," + Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")))
		Endif
		if !Empty(SC5->C5_VEND2)
			cEmlCli += "," + Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL")))
		Endif
		if !Empty(SC5->C5_TRANSP)    // Adicionado 30/06/2021
			cEmlCli += "," + Alltrim(Lower(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_EMAIL")))
		Endif

		IF SC5->( FIELDPOS('C5_XEMAILR') > 0)
			if !Empty(cEmlCli)
				RecLock("SC5",.F.)
				SC5->C5_XEMAILR := cEmlCli
				MsUnlock()
			endif
		ELSE
			MsgInfo("Campo C5_XEMAILR não foi criado. Favor informar o TI","Atenção!")
		ENDIF
	ENDIF

Return


/*/{Protheus.doc} getZS3Prx
description
Rotina para gerar o proximo código
@type function
@version  1.00
@author Valdemir Jose
@since 17/03/2021
@return return_type, return_description
/*/
Static Function getZS3Prx()
	Local cRET := dtos(dDatabase)+'001'
	Local cQry := ""

	cQry += "SELECT MAX(Substr(ZS3_CODIGO,1,8)) UltData, COUNT(*)+1 SEQ" + CRLF
	cQry += "FROM " + RETSQLNAME("ZS3") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND  Substr(A.ZS3_CODIGO,1,8) = '"+dtos(dDatabase)+"' " + CRLF

	if Select("TSEQ") > 0
		TSEQ->( dbCloseArea() )
	endif

	TcQuery cQry New Alias "TSEQ"

	if TSEQ->( !Eof() )
		if Empty(TSEQ->UltData)
			cRET := dtos(dDatabase)+StrZero(TSEQ->SEQ,3)
		else
			cRET := TSEQ->UltData+StrZero(TSEQ->SEQ,3)
		endif
	endif

	if Select("TSEQ") > 0
		TSEQ->( dbCloseArea() )
	endif

Return cRET

/*/{Protheus.doc} U_EnviaWF
description
Rotina para envio de WF com Protocolo
@type function
@version  1.00
@author Valdemir Jose
@since 18/03/2021
@param pcEmlCli, param_type, param_description
@param pZS3, param_type, param_description
@return return_type, return_description
/*/

USER Function EnviaWF(pcEmlCli, pZS3, pAgend, aMuda, paArquivo, pCaminho, pcLINK)
	Local aArea       := GetArea()
	Local _cFrom      := "protheus@steck.com.br"
	Local _cAssunto   := 'PROTOCOLO DE AGENDAMENTO DE RETIRADA-Pedido: ' +(pZS3)->ZS3_PEDIDO
	Local cFuncSent   := "MailTI"
	Local _aMsg       := {}
	Local i           := 0
	Local cArq        := ""
	Local cMsg        := ""
	Local _nLin
	Local _cCopia     := ''
	Local cAttach     := ''
	Local cCodBS64    := Encode64((pZS3)->ZS3_CODIGO)
	DEFAULT pAgend    := ""
	DEFAULT aMuda     := {}
	DEFAULT paArquivo := {}
	DEFAULT pCaminho  := ""

	if Empty(pAgend)
		_cEmail  := pcEmlCli
	else
		aAreaC5 := GetArea()
		dbSelectArea("SA4")
		SA4->( dbSetOrder(1) )
		dbSelectArea("SC5")
		SC5->( dbSetOrder(1) )
		if SC5->( dbSeek(xFilial('SC5')+(pZS3)->ZS3_PEDIDO) )
			_cEmail  := SC5->C5_XEMAILR
		Endif
		if !Empty(SC5->C5_TRANSP)    // Adicionado 30/06/2021
			if SA4->( dbSeek(xFilial('SA4')+SC5->C5_TRANSP) )
			   if !Empty(SA4->A4_EMAIL)
			      _cEmail += ";" 
				  _cEmail += Alltrim(Lower(SA4->A4_EMAIL))
			   endif 
			endif
		Endif
		_cEmail  += ';kleber.braga@steck.com.br'
		RestArea( aAreaC5 )
	Endif

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
		_cEmail  := 'valdemir.rabelo@sigamat.com.br'
	EndIf

	Aadd( _aMsg , { "Protocolo: "       , (pZS3)->ZS3_CODIGO } )
	if !Empty(pAgend)
		aadd(_aMsg, {getAlt( 'ZS3_CPF' ,aMuda)+"CPF: "         , (pZS3)->ZS3_CPF})
		aadd(_aMsg, {getAlt( 'ZS3_MOTORI' ,aMuda)+"Motorista: ", (pZS3)->ZS3_MOTORI})
		aadd(_aMsg, {getAlt( 'ZS3_VEICUL' ,aMuda)+"Veiculo: "  , (pZS3)->ZS3_VEICUL})
		aadd(_aMsg, {getAlt( 'ZS3_PLACA' ,aMuda)+"Placa: "     , (pZS3)->ZS3_PLACA})
		IF !Empty((pZS3)->ZS3_TRANSP)
			Aadd( _aMsg , { getAlt('ZS3_TRANSP',aMuda)+"Transportadora: ", (pZS3)->ZS3_TRANSP } )
		Endif
	endif
	Aadd( _aMsg , { "Pedido: "          , (pZS3)->ZS3_PEDIDO } )
	Aadd( _aMsg , { "Nota Fiscal: "     , (pZS3)->ZS3_NOTAFI } )
	Aadd( _aMsg , { "Status: "    		, if(Empty(pAgend),"Pendente Agendamento",'Agendado') } )
	if Empty(pAgend)
		aAdd( _aMsg , { "Link"              ,"<a href='https://portalcliente.steck.com.br/recepcao_digital/agenda_retirada.php?codigo="+cCodBS64+"'> Clique aqui para abrir o protocolo </a>" })
	else
		aAdd( _aMsg , { "Link Checkin"      ,"<a href='" +pcLink+ "'>"+pcLink+"</a>" })
		Aadd( _aMsg , { "Data Agendamento: ", dtoc((pZS3)->ZS3_DATAGE) } )
		Aadd( _aMsg , { "Hora Agendamento: ", (pZS3)->ZS3_HORAGE } )
	endif

	// Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

	// Definicao do texto/detalhe do email                                         ï¿½
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + EncodeUTF8(_aMsg[_nLin,1],'cp1252') + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + EncodeUTF8(_aMsg[_nLin,2],'cp1252') + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	// Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'


	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg, paArquivo, pCaminho)

	RestArea(aArea)

Return .T.



//===================================================================================================================

	Class ItensPedidoProtocolo

		Data Protocolo	As String
		Data Pedido	  	As String
		DATA Cliente    AS string
		Data Tipo 	    As String
		DATA CPF        AS String
		DATA Motorista  AS String
		DATA Veiculo    AS String
		DATA Placa      As String
		Data Emissao    As String
		Data CondPag    As String
		Data Status     As String
		DATA DataAge    AS String
		DATA HoraAge    AS String
		Data Itens      As Array
		Data DataDisp   As Array
		Data Transport  AS String

		Method New(Protocolo) Constructor

	EndClass


Method New(Protocolo) class ItensPedidoProtocolo
	Local aAreaZS3 := GetArea()
	Local cAliasT  := ""
	Local cDatDisp := ""
	Local nD

	dbSelectArea('ZS3')
	dbSetOrder(1)
	if dbSeek(xFilial('ZS3')+Protocolo)
		::Protocolo	:= ZS3->ZS3_CODIGO
		::Pedido	:= ZS3->ZS3_PEDIDO
		::Tipo 	    := IIF(!EMPTY(ZS3->ZS3_TIPORT),IIF(ZS3->ZS3_TIPORT=="C","CLIENTE","TRANSPORTADORA"),"")
		::Emissao   := if(!Empty(ZS3->ZS3_DATA),dtoc(ZS3->ZS3_DATA), "")
		::CondPag   := ""
		::Cliente   := ""
		::Motorista := ALLTRIM(ZS3->ZS3_MOTORI)
		::Veiculo   := ALLTRIM(ZS3->ZS3_VEICUL)
		::Placa     := ALLTRIM(ZS3->ZS3_PLACA)
		::CPF       := ALLTRIM(ZS3->ZS3_CPF)
		::DataAge   := if(!Empty(ZS3->ZS3_DATAGE), DTOC(ZS3->ZS3_DATAGE), "")
		::HoraAge   := ALLTRIM(ZS3->ZS3_HORAGE)
		::Itens     := {}
		::DataDisp  := {}
		::Transport := ALLTRIM(ZS3->ZS3_TRANSP)

		if ZS3->ZS3_STATUS == "R"
			::Status    := "RETIRADO"
		ELSEif ZS3->ZS3_STATUS == "A"
			::Status    := "AGENDADO"
		ELSE
			::Status    := "PENDENTE AGENDAMENTO"
		endif

		IF !(ZS3->ZS3_STATUS $ "R")
			dbSelectArea("SC5")
			dbSetOrder(1)
			if dbSeek(xFilial('SC5')+ZS3->ZS3_PEDIDO)
				::CondPag   := posicione('SE4',1,xFilial('SE4')+SC5->C5_CONDPAG,"E4_DESCRI")
				::Cliente   := posicione("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
				dbSelectArea("SC6")
				dbSetOrder(1)
				if dbSeek(xFilial("SC6")+ZS3->ZS3_PEDIDO)
					While SC6->( !Eof() ) .and. ( SC6->C6_NUM==ZS3->ZS3_PEDIDO )
						aAdd(::Itens, ItemPedidos():New() )
						::Itens[Len(::Itens)]:ITEM       := SC6->C6_ITEM
						::Itens[Len(::Itens)]:CODIGO     := ALLTRIM(SC6->C6_PRODUTO)
						::Itens[Len(::Itens)]:DESCRICAO  := ALLTRIM(POSICIONE("SB1",1,XFILIAL('SB1')+SC6->C6_PRODUTO, "B1_DESC"))
						::Itens[Len(::Itens)]:QUANTIDADE := SC6->C6_QTDVEN
						SC6->( dbSkip() )
					EndDo
				endif
			endif

			For nD := 0 to 89 // 90 dias
				if !(cValToChar(Dow(dDatabase+nD)) $ "7/1")
					if cDatDisp != dtoc(dDatabase+nD)
						cDatDisp := dtoc(dDatabase+nD)
						aHoras   := getZS3AG(@cDatDisp)
						aAdd(::DataDisp, DataDispProt():New(cDatDisp, aHoras) )
					endif
				endif
			Next
		ELSE
			aAdd(::Itens, ItemPedidos():New() )
		ENDIF
	endif
	RestArea( aAreaZS3 )

Return



	Class ItemPedidos
		DATA ITEM       AS CHARACTER
		DATA CODIGO     AS CHARACTER
		DATA DESCRICAO  AS CHARACTER
		DATA QUANTIDADE AS CHARACTER

		METHOD New() Constructor
	EndClass

METHOD NEW() CLASS ItemPedidos
	::ITEM       := ""
	::CODIGO     := ""
	::DESCRICAO  := ""
	::QUANTIDADE := ""
Return

	Class DataDispProt
		DATA DATA AS CHARACTER
		DATA HORARIODISP AS ARRAY

		METHOD New() Constructor
	EndClass

METHOD New(cData, aHoras) CLASS DataDispProt
	::DATA        := cData
	::HORARIODISP := aHoras
Return .T.

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------


/*/{Protheus.doc} getZS3AG
description
Rotina que irá montar os horarios correspondentes a data
@type function
@version  1.00
@author Valdemir Jose
@since 19/03/2021
@param pData, param_type, param_description
@return return_type, return_description
/*/
Static Function getZS3AG(pData)
	Local cRET   := GetNextAlias()
	Local aRET   := {}
	Local cQry   := ""
	Local nAchou := 0
	Local nH     := 0
	Local nIni   := 0
	Local nFim   := 0
	Local lAlt   := .F.

	cQry += "SELECT * " + CRLF
	cQry += "FROM " + RETSQLNAME("ZS3") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND A.ZS3_DATAGE = '" + DTOS(CTOD(pData)) + "' " + CRLF
	cQry += "ORDER BY ZS3_DATAGE, ZS3_HORAGE "

	if ctod(pData) == dDatabase
		if VAL(Left(Time(),2)) <= 12
			nIni := 13
			nFim := 15
		else
			pData := dtoc(ctod(pData)+1)
			nIni  := 08
			nFim  := 11
			lAlt  := .T.
		endif
	else
		if VAL(Left(Time(),2)) <= 12
			nIni := 13
			nFim := 15
		else
			nIni  := 08
			nFim  := 11
		endif
		lAlt  := .T.
	endif

	IF SELECT(cRET) > 0
		(cRET)->( dbCloseArea() )
	Endif

	TcQuery cQry New Alias (cRET)

	if (cRET)->( !Eof() )
		While (cRET)->( !Eof() )
			For nH := nIni to nFim
				aAdd(aRET, StrZero(nH,2)+":00")
			Next
			if ctod(pData) != dDatabase
				if nIni == 08
					nIni := 13
					nFim := 15
				else
					nIni  := 08
					nFim  := 11
				endif
				For nH := nIni to nFim
					aAdd(aRET, StrZero(nH,2)+":00")
				Next
			endif
			aSort(aRET)
			(cRET)->( dbSkip() )
		EndDo
	else
		if lAlt
			if ctod(pData) == dDatabase
				For nH := nIni to nFim
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif
				Next
			else
				For nH := 8 to 11
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif
				Next
				For nH := 13 to 15
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif
				Next
			endif
			aSort(aRET)
		else
			if ctod(pData) == dDatabase
				For nH := nIni to nFim
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif

				Next
			else
				For nH := 8 to 11
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif
				Next
				For nH := 13 to 15
					if Len(aRET)==0
						aAdd(aRET, StrZero(nH,2)+":00")
					else
						nAchou := 0
						aEval(aRET, {|X| if(X==StrZero(nH,2)+":00",nAchou++,0)})
						if (nAchou==0)
							aAdd(aRET, StrZero(nH,2)+":00")
						endif
					endif
				Next
			endif
			aSort(aRET)
		Endif
	endif

	IF SELECT(cRET) > 0
		(cRET)->( dbCloseArea() )
	Endif

Return aRET

/*/{Protheus.doc} getVldAG
description
Rotina que valida Data e Horario Recebido
@type function
@version  1.00
@author Valdemir Jose
@since 22/03/2021
@param poParseJson, param_type, param_description
@return return_type, return_description
/*/
Static Function getVldAG(poParseJson)
	Local lRET := .T.
	Local cQry := ""
	Local aAreaVld := GetArea()

	cQry += "SELECT ZS3_CODIGO REG " + CRLF
	cQry += "FROM " + RETSQLNAME("ZS3") + " Z " + CRLF
	cQry += "WHERE Z.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND Z.ZS3_FILIAL = '" + XFILIAL('ZS3') + "' "
	cQry += " AND Z.ZS3_DATAGE='" + DTOS(CTOD(poParseJson:DATAAGE)) + "' " + CRLF
	cQry += " AND Z.ZS3_HORAGE='" + poParseJson:HORAAGE + "' " + CRLF

	if Select("TZS3") > 0
		TZS3->( dbCloseArea() )
	endif
	tcQuery cQry New Alias "TZS3"

	if TZS3->( ! Eof() )
		lRET := !EMPTY(TZS3->REG) .AND. (TZS3->REG == poParseJson:PROTOCOLO)
	Endif

	if Select("TZS3") > 0
		TZS3->( dbCloseArea() )
	endif

	RestArea( aAreaVld )

Return lRET




User Function GETZS3NUM()
Return getZS3Prx()


/*/{Protheus.doc} getAlt
description
Rotina para verificar se ocorreu alteração
@type function
@version  1.00
@author Valdemir Jose
@since 19/04/2021
@param pCampo, param_type, param_description
@param aMuda, array, param_description
@return return_type, return_description
/*/
Static Function getAlt(pCampo, aMuda)
	Local cRET := ""
	if Len(aMuda) > 0
		if aScan(aMuda, { |X| Alltrim(X[1])==Alltrim(pCampo)})
			cRET := "<B>* </B>"
		endif
	Endif
Return cRET


/*/{Protheus.doc} PostKAce
description
Rotina que fará a chamada do metodo Post da KeyAccess
@type function
@version  1.00
@author Valdemir Jose
@since 19/04/2021
@return return_type, return_description
/*/
User Function PostKAce(pProtocolo)
	Local lAtivaPrd     := GETMV("ST_KAURL",.f.,.f.)		// Ativa Produção .T. - .F. = Homologação
	Local _cUrlhml      := "https://api-homol.visitantes.online"
	Local _cUrlPrd      := "https://api.visitantes.online"
	Local _cHmlID       := "companyhomollogistic01steck"
	Local _cPrdID       := "companygrdsteck"
	Local _cUrlEnt      := if(lAtivaPrd,_cUrlPrd,_cUrlhml)+"/api/logistics/"+if(lAtivaPrd,_cPrdID,_cHmlID)
	Local _cJson		:= ""
	Local aHeadOut      := {}
	Local _aRet         := {}
	Local _aProc        := {}
	Local oJson
	Local nTimeOut      := 60
	Local cRET          := ""
	Local cMsg			:= ""
	Local cHeadRet 		:= ""
	Local cTokenBare    := ""
	Local cACCESS_TOKEN := ""
	Local cRETAPI       := ""
	Local cEXPIRES_IN   := 0
	Local cSCOPE        := ""
	Local cData         := Left(dtos(ZS3->ZS3_DATAGE),4)+"-"+Substr(dtos(ZS3->ZS3_DATAGE),5,2)+"-"+Right(dtos(ZS3->ZS3_DATAGE),2)
	Local oPost
	Local cHoraFim      := StrZero(Val(Left(Alltrim(ZS3->ZS3_HORAGE),2))+2,2)+":"+Right(Alltrim(ZS3->ZS3_HORAGE),2)
	Local oRestClient
	Local cNomCli       := ""
	Local nHRefID       := cValToChar(getUsuStk())
	Local _cEmail       := getmv("ST_EMLKYAC",.f.,"kleber.braga@steck.com.br;carlos.nagano@keyaccess.com.br")
	Local jJSON
	/*
           Adicionado para realizar os testes
	dbSelectArea("ZS3")
	dbSetOrder(1)
	dbSeek(xFilial('ZS3')+pProtocolo)
	*/
	cData         := Left(dtos(ZS3->ZS3_DATAGE),4)+"-"+Substr(dtos(ZS3->ZS3_DATAGE),5,2)+"-"+Right(dtos(ZS3->ZS3_DATAGE),2)
	cHoraFim      := StrZero(Val(Left(Alltrim(ZS3->ZS3_HORAGE),2))+2,2)+":"+Right(Alltrim(ZS3->ZS3_HORAGE),2)

	// Efetua Login
	oJson := LoginKAC()

	if !empty(oJson)
	    /*
			se o horario de entrada é das 08 as 18 horas do horario de brasilia (ou seja UTC-3)
			no json vc envia 
			"startAt": "2021-05-26T11:00:00Z", 
			"endAt": "2021-05-26T21:00:00Z"		
		*/
		aAreaF2 := GetArea()
		dbSelectArea("SF2")
		dbSetOrder(1)
		if dbSeek(xFilial("SF2")+Alltrim(ZS3->ZS3_NOTAFI))
			cNomCli := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME"))
		endif
		RestArea( aAreaF2 )
		_cJson := '{ ' + CRLF
		if (ZS3->ZS3_EVNTID > 0)   // Se existe código será uma alteração
			_cJson += '"id": '+cValToChar(ZS3->ZS3_EVNTID)+', ' + CRLF
		Endif
		_cJson += '"title": "NF ' +Alltrim(ZS3->ZS3_NOTAFI)+ '-'+cNomCli+'", ' + CRLF
		_cJson += '"startAt": "' +cData+"T11:00:00Z"+ '", ' + CRLF
		_cJson += '"endAt": "' +cData+"T21:00:00Z"+ '", ' + CRLF
		_cJson += '"behavior": "ENTRY", ' + CRLF
		_cJson += '"target": "LOGISTIC", ' + CRLF
		_cJson += '"autoRelease": false, ' + CRLF
		_cJson += '"hostRefId": '+nHRefID+' ' +CRLF
		_cJson += '} '
/*		
		_cJson += '"driver": {  '+ CRLF
		if (ZS3->ZS3_EVNTID > 0)   // Se existe código será uma alteração
			_cJson += '         	"eventId": '+cValToChar(ZS3->ZS3_EVNTID)+', '+ CRLF
		Endif
		_cJson += '             "fullName": "' +ALLTRIM(ZS3->ZS3_MOTORI)+ '", '+ CRLF
		_cJson += '             "document": "' +ALLTRIM(ZS3->ZS3_CPF)+ '", '+CRLF
		_cJson += '             "licensePlateOne": "' +ALLTRIM(ZS3->ZS3_PLACA)+ '", ' + CRLF
		_cJson += '             "onFoot": false } '+CRLF
*/
		// Carregando informações para Registrar KeyAccess
		cTokenBare    := oJson:TOKEN_TYPE
		cACCESS_TOKEN := oJson:ACCESS_TOKEN
		cEXPIRES_IN   := oJson:EXPIRES_IN
		cSCOPE        := oJson:SCOPE

		// Prepara mensagem, caso ocorra algum erro
		cMsg := "Ocorreu um problema no Protocolo: "+Alltrim(ZS3->ZS3_CODIGO)+CRLF+CRLF
		cMsg += _cJson


		// Executando Metodo Post
		aAdd( aHeadOut,"Content-Type: application/json")
		aAdd( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )

		if (ZS3->ZS3_EVNTID > 0)

			_cJson := EncodeUTF8(_cJson)

			oRestClient   := FWRest():New(_cUrlEnt)
			oRestClient:setPath("/events")
			oRestClient:nTimeOut := 600

			If oRestClient:Put(aHeadOut,_cJson)
				oPost 	  	:= ""
				cRETAPI   	:= FWJsonDeserialize(oRestClient:GetResult(),@oPost)
				lRET := cRETAPI
			Else
				ConOut("PUT", oRestClient:GetLastError())
			EndIf

		else
			cRETAPI := HttpPost(_cUrlEnt+"/events",,_cJson, nTimeOut, aHeadOut, @cHeadRet)
			if (!empty(cRETAPI)) .and. (!("<html>" $ cRETAPI))
			   FWJsonDeserialize(cRETAPI, @oPost)
			   if (!("<html>" $ cRETAPI))
			      lRET := (oPost != nil)
			   else 
			      lRET := .F.
			   endif 
			endif 
		endif

		if lRET
			
			if ValType(oPost:Status)=="N"
				lOK := .F.
			else
				lOK := .T.
			endif
			if lOK
				conout("HttpPost Ok")
				if lRET
					cRET := oPost:fullPathLocator
					RecLock("ZS3",.F.)
					ZS3->ZS3_EVNTID := oPost:id
					MsUnlock()
				endif
			else
				conout("HttpPost Ocorreu um problema Key Access")
				U_STMAILTES(_cEmail, "", "WF - Erro no envio KeyAccess Protocolo: "+Alltrim(ZS3->ZS3_CODIGO), cMsg, "")
			endif
		else
			conout("HttpPost Failed.")
			varinfo("Header", cHeadRet)
			U_STMAILTES(_cEmail, "", "WF - Erro no envio KeyAccess Protocolo: "+Alltrim(ZS3->ZS3_CODIGO), cMsg, "")
		Endif

	Endif

Return cRET


/*/{Protheus.doc} LoginKAC
description
Rotina que fará o login para acessar Key Access
@type function
@version  1.00
@author Valdemir Jose
@since 19/04/2021
@return return_type, return_description
/*/
Static Function LoginKAC()
	Local nTimeOut 		:= 60
	Local aHeadOut 		:= {}
	Local cHeadRet 		:= ""
	Local sPostRet      := ""
	Local lAtivaPrd     := GETMV("ST_KAURL",.f.,.f.)				// Ativa Produção .T. - .F. = Homologação
	Local _cHmlID       := "companyhomollogistic01steck"
	Local _cPrdID       := "companygrdsteck"
	Local cHmlSecre     := "a6fd71e79f5926a18c89fd2a5"
	Local cPrdSecre     := GETMV("ST_IDSKACE", .F., "86d8e5cf653fad321f7bce3ad")
	Local _cUrlHml 		:= "https://h.visitantes.online/auth/login/client"
	Local _cUrlPrd 		:= "https://visitantes.online/auth/login/client"
	Local _cUrl 		:= if(lAtivaPrd,_cUrlPrd,_cUrlHml)
	Local _cJson		:= ""
	Local cClientID     := ""
	Local cCliSecre     := ""
	Local _lRet
	Local oRET

	if lAtivaPrd
		cClientID := _cPrdID
		cCliSecre := cPrdSecre
	Else
		cClientID := _cHmlID
		cCliSecre := cHmlSecre
	Endif

	// Efetuando o Login
	aAdd( aHeadOut,"Content-Type: application/json;charset=utf-8")
	aAdd( aHeadOut,"Authorization: Basic " + Encode64( cClientID + ":" + cCliSecre )  )

	_cJson += '{"grant_type":"client_credentials", "scope":"cloud-system-rw"}'

	sPostRet := HttpPost(_cUrl,,_cJson, nTimeOut, aHeadOut, @cHeadRet)
	_lRet    := FWJsonDeserialize(sPostRet, @oRET)

	if !empty(sPostRet)
		conout("HttpPost Ok")
	else
		conout("HttpPost Failed.")
		varinfo("Header", cHeadRet)
	Endif

Return oRET

/*/{Protheus.doc} getUsuStk
description
Rotina API que retornará o Id do usuário
@type function
@version  
@author Valdemir Jose
@since 15/06/2021
@return return_type, return_description
/*/
Static Function getUsuStk()
	Local oLogin        := LoginKAC()
	Local oGET
	Local lAtivaPrd     := GETMV("ST_KAURL",.f.,.f.) // Ativa Produção .T. - .F. = Homologação
	Local _cHmlID       := "companyhomollogistic01steck"
	Local _cPrdID       := "companygrdsteck"
	Local _cUrlHml      := "https://api-homol.visitantes.online/api/people/"+_cHmlID+"/gf?&sort=name,asc&size=1000&name.contains=&platformStatus.equals=IDENTIFIED&name.contains="
	Local _cUrlPrd      := "https://api.visitantes.online/api/people/"+_cPrdID+"/gf?&sort=name,asc&size=1000&name.contains=&platformStatus.equals=IDENTIFIED&name.contains="
	Local _cUrl         := if(lAtivaPrd, _cUrlPrd, _cUrlHml)
	Local cToken        := ""
	Local cTokenBare    := ""
	Local cACCESS_TOKEN := ""
	Local cHeadRet
	Local cEXPIRES_IN
	Local cSCOPE
	Local nTimeOut      := 60
	Local aHeadOut      := {}
	Local cRET          := ""
	Local nX
	
	if !empty(oLogin)
		// Carregando informações para Registrar KeyAccess
		cTokenBare    := oLogin:TOKEN_TYPE
		cACCESS_TOKEN := oLogin:ACCESS_TOKEN
		cEXPIRES_IN   := oLogin:EXPIRES_IN
		cSCOPE        := oLogin:SCOPE

		// Executando Metodo Post
		aAdd( aHeadOut,"Content-Type: application/json")
		aAdd( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )

		oRestClient := FWRest():New(_cUrl)
		oRestClient:setPath("")
		oRestClient:nTimeOut := 600
		If oRestClient:Get(aHeadOut)
			conout("HttpPost Ok")
			lRET := FWJsonDeserialize(oRestClient:GetResult(), @oGET)
			if lRET
				if Len(oGET) > 0
					For nX := 1 to Len(oGet)
						cRET := oGET[nX]:REFID
						Exit
					Next
				else
					cRET := oGET:refId
				endif
			endif
		else
			conout("HttpPost Failed.")
			varinfo("Header", cHeadRet)
		Endif
	endif

Return cRET
