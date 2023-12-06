#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  02/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monitor de Liberado de orcamentos bloqueados - TELEVENDAS   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center -> Especificos FSW -> Atendimento -> Aprovação  //
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE40()
	Local aCores2    := {{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" 	, "BR_VERDE"	},;// Faturamento - VERDE
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))"	, "BR_VERMELHO"},;// Faturado - VERMELHO
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"                				, "BR_AZUL"   	},;// Orcamento - AZUL
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"                				, "BR_MARRON"	},;// Atendimento - MARRON
	{"(!EMPTY(SUA->UA_CODCANC))"																			,"BR_PRETO"   }}	// Cancelado

	//---------------------------------------------------------------------------------------//
    //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
	//no browse da tela de liberaçao de pedidos, inibir a exibição dos pedidos bloqueados
	//por desconto, porque serão liberados em tela específica para liberar desconto
    //---------------------------------------------------------------------------------------//
	Local cFiltro    := ""  //" UA_FILIAL = '"+xFilial("SUA")+"' AND UA_XBLOQ = '1' AND UA_XCODMCA = ' '" 
	Local bFiltraBrw := {}		//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria
	Local aIndexSUA  := {}		//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria
	
	Private cCadastro		:= "Atendimento"
	Private aRotina      := {}
	Private lTk271Auto   := .F.
	Private cAliasAuto   := "" // Alias para identificar qual sera a rotina de atendimento para entrada automatica
	Private aAutoCab     := {} // Campos de Cabecalho utilizados na rotina automatica
	Private aAutoItens   := {} // Campos dos Itens utilizados na rotina automatica
	Public cAutorizaCanc := "N"

	aRotina	:= {	{"Pesquisar" 	,"AxPesqui"		,0,1 },;
	{"Visualizar"	,"U_STFSVE46"	,0,2 },;
	{ "Legenda"		,"TK271Legenda" ,0,2 },;
	{ "Liberar"		,"U_STFSVE46"	,0,4 },;
	{ "Rejeitar"	,"U_STFSVE48"	,0,3 }}

	DbSelectArea("SUA")
	//SC5->(dbOrderNickName("NICKSC58"))

	//SUA->(dbSetFilter({||  SUA->UA_FILIAL = xFilial("SUA").AND. SUA->UA_XBLOQ= '1' .AND. SUA->UA_XCODMCA = ' '}," SUA->UA_FILIAL = +xFilial('SUA').AND. SUA->UA_XBLOQ= '1' .AND. SUA->UA_XCODMCA = ' ' "))
	
	//---------------------------------------------------------------------------------------//
    //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
	//no browse da tela de liberaçao de pedidos, inibir a exibição dos pedidos bloqueados
	//por desconto, porque serão liberados em tela específica para liberar desconto
    //---------------------------------------------------------------------------------------//
	cFiltro := " UA_FILIAL = '"+xFilial("SUA")+"' .AND. UA_XBLOQ = '1' .AND. UA_XCODMCA = ' '" 
	cFiltro += " .AND. !'DESC' $ UA_XDESBLQ "
	bFiltraBrw := { || FilBrowse("SUA" , @aIndexSUA , @cFiltro )}
	
	If !Empty(cFiltro)
		Eval(bFiltraBrw)
	Endif 
	//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria

	//MBrowse(,,,,"SUA",,,,,,aCores2,,,,,,,,cFiltro)
	MBrowse(,,,,"SUA",,,,,,aCores2)

	If !Empty(cFiltro)
		EndFilBrw("SUA" ,aIndexSUA)
	Endif 
	//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria 
	
	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  05/13/10   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AProva Orçamento                                           º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function STFSVE46(cAlias,nReg,nOpc/*,cTipoNew*/)
	Local aSU7Area	:= SU7->(GetArea())
	Local aSA1Area	:= SA1->(GetArea())
	Local aArea		:= GetArea()
	Local cPerfAnt := fGetPerf()
	Local nRecSU7	:= 0
	Local nVlrItem	:= 0
	Local nVlrST    := 0
	Local nVlrIPI	:= 0
	Local cTipoNew  := "2"

	If Empty(cPerfAnt)
		SA1->(RestArea(aSA1Area))
		SU7->(RestArea(aSU7Area))
		RestArea(aArea)
		Return
	Endif

	nRecSU7 := SU7->(Recno())

	SU7->(RecLock("SU7",.F.))
	SU7->U7_TIPOATE := cTipoNew
	SU7->(MsUnlock())

	If nOpc == 4  //Renato Nogueira 02/07/2013
		If !Empty(SUA->UA_XMOTDES)
			MsgInfo(SUA->UA_XMOTDES,"Motivo do desconto")
		EndIf
		If "MSG" $ AllTrim(SUA->UA_XDESBLQ)
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
			If !Empty(SA1->A1_XMSG2)
				MsgInfo(SA1->A1_XMSG2,"Observação supervisão")
			EndIf

			/****************************************
			<<<<<<<<< ALTERAÇÃO >>>>>>>>>>>>>>>>
			Ação.........: Tratmento para retirar a regra de bloqueio para o campo A1_XCODMC
			Desenvolvedor: Marcelo Klopfer Leme
			Data.........: 19/09/2022
			Chamado......: 20220727014715 - Integração de Cotações
			If !Empty(SA1->A1_XCODMC)
				MsgInfo(MSMM(SA1->A1_XCODMC,43),"Mensagem cliente")
			EndIf
			****************************************/
		EndIf
	EndIf

	TK271CallCenter(cAlias,nReg,nOpc)

	SU7->(RecLock("SU7",.F.))
	SU7->U7_TIPOATE := Alltrim(cPerfAnt)
	SU7->(MsUnlock())

	If AllTrim(SUA->UA_XORIG)=="1" .And. AllTrim(SUA->UA_XBLOQ)=="2"

		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA)))

		_cEmail := AllTrim(SA1->A1_EMAIL)
		//_cEmail := "renato.oliveira@steck.com.br"
		_cCopia := "carla.lodetti@steck.com.br;filipe.nascimento@steck.com.br"

		_cAssunto := "[WFPROTHEUS] - Orçamento "+SUA->UA_NUM+" inserido via portal liberado para acesso

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg"><br><br>
		cMsg += 'Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
		cMsg += 'Obrigado por cotar pelo nosso portal!<br>
		cMsg += 'Seu orçamento foi liberado e você já pode acessá-lo novamente.<br><br>

		cMsg += 'Atenciosamente,<br>
		cMsg += 'Steck Indústria Elétrica Ltda

		cMsg += '</body></html>'

		cAttach := ""

		U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)	

	EndIf

	//FR - 03/06/2022 - Flávia Rocha - Sigamat Consultoria - revisão do retorno para api da Nectar com status orçamento
	If AllTrim(SUA->UA_XBLOQ) == "2"	 
		U_STFAT610("1")
	Endif 

	SA1->(RestArea(aSA1Area))
	SU7->(RestArea(aSU7Area))
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  05/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o perfil atual do usuario                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetPerf()
	Local cRet		:= ""

	SU7->(DbSetOrder(4)) //U7_FILIAL+U7_CODUSU
	SU7->(DbSeek(xFilial("SU7") + __cUserId))
	cRet := SU7->U7_TIPOATE

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  05/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de escolha de interface do CALL CENTER                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSVE47()
	Local oDlg, oButton
	Public _cXCodVen361 := ''

	If getmv("ST_47VE",,.F.)
		DEFINE MSDIALOG oDlg FROM 05,10 TO 270,350 TITLE "Call Center" OF oMainWnd PIXEL

		oButton:= TButton():New(40,36,"Telemarketing"	,oDlg,{|| fAbreTe("1")},100,20,,,,.T.)
		oButton:= TButton():New(80,36,"Televendas"		,oDlg,{|| fAbreTe("2")},100,20,,,,.T.)

		ACTIVATE MSDIALOG oDlg CENTERED
	Else

		DbSelectArea('SA1')
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cUserId))
			If !(__cUserId $ Getmv("ST_VE47FS",,"000000/000645")+"/000000/000645")
				If SA3->A3_TPVEND <> 'I'
					_cXCodVen361:= SA3->A3_COD
					SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
				EndIf
			EndIf
		EndIf
		fAbreTe("2")

		SA1->(DbClearFilter())
	EndIf

Return

Static Function fAbreTe(cTipoNew)
	Local aSU7Area	:= SU7->(GetArea())
	Local aArea		:= GetArea()
	Local cPerfAnt := fGetPerf()
	Local nRecSU7	:= 0

	If Empty(cPerfAnt)
		RestArea(aSU7Area)
		RestArea(aArea)
		MSGINFO('Operador não tem acesso a rotina selecionada. Consulte o cadastro de operadores')
		Return
	Endif

	//CASO A ROTINA CLICADA SEJA RELACIONADA AO U7_TIPOATE DO OPERADOR
	IF(cTipoNew == cPerfAnt  .OR. cPerfAnt == "4"  .OR. cPerfAnt == "5")

		TmkOperador()
		TMKA271()

	ELSE

		MSGINFO('Operador não tem acesso a rotina selecionada. Consulte o cadastro de operadores')

	ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE41  ºAutor  ³Microsiga           º Data ³  02/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para validar os bloqueios do orcamento no televendas º±±
±±º          ³P.E. TK271BOK                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSVE41()

	Local aArea 	:= GetArea()
	Local cMsg		:= ""
	Local lBloquei	:= .F.
	Local lCancel	:= .F.
	Local cBLQPSC	:= GetMv("FS_BLQPSC",.F.,"PSC"  )
	Local cBLQAPR	:= GetMv("FS_BLQAPR",.F.,"APR"  )
	Local cBLQMSG	:= GetMv("FS_BLQMSG",.F.,"MSG"  )
	Local cBLQVLR	:= GetMv("FS_BLQVLR",.F.,"VLR"  )
	Local cProdBLQ	:= GetMv("FS_PRODBLQ",.F.,"1020")
	Local cBLQMKP	:= GetMv("FS_BLQMKP",.F.,"MKP"  )
	Local lIsMon	:= IsInCallSteck("U_STFSVE40"   )
	Local lForcaBLQ	:= .F.
	Local cCodBloq	:= ""
	Local nVlrItem	:= 0
	Local lRet		:= .F.
	Local nI
	Local cBLCOND	:= GetMv("FS_BLCOND",.F.,"CONDPG")
	Local cBLDESC	:= GetMv("FS_BLDESC",.F.,"DESC"  )
	Local cBLACRE	:= GetMv("FS_BLATUA",.F.,"ATUA"  )
	Local cBLFret	:= GetMv("FS_BLFRET",.F.,"FRETE"  )
	Local _nVaCif	:= 0
	Local nVlrST	:= 0
	Local nVlrIPI	:= 0
	Local nVlrMkp	:= 0
	Local lBlqMkp	:= .F.
	Local _nMin		:= 0
	Local _nMax		:= 0

	If !(nFolder == 2)
		Return
	Endif

	lForcaBLQ:= M->UA_OPER == "1"

	If M->UA_OPER == "3"
		Return
	Endif

	For nI:= 1 to len(aCols)
		If aCols[nI,len(aHeader)+1]
			Loop
		Endif
		/*
		If "COND" $ UPPER(M->UA_XDESBLQ) .or. "DESC" $ UPPER(M->UA_XDESBLQ) .or. "ACRE" $ UPPER(M->UA_XDESBLQ)
		lBloquei := .T.
		cCodBloq :=M->UA_XDESBLQ
		Loop
		Endif
		*/
		cITEMBLQ := GDFieldGet("UB_XBLQITE",nI)
		nVlrItem	+= GDFieldGet("UB_VLRITEM",nI)
		nVlrST      +=  GDFieldGet("UB_QUANT",nI)*GDFieldGet("UB_ZVALIPI",nI)
		nVlrIPI     +=  GDFieldGet("UB_QUANT",nI)*GDFieldGet("UB_ZVALIST",nI)
		nVlrMkp     :=  GDFieldGet("UB_ZMARKUP",nI)
		/*
		If nVlrMkp<1.5 .And. !lBlqMkp
		lBlqMkp  := .T.
		cCodBloq += cBLQMKP + "/"
		lBloquei := .T.
		EndIf
		*/
		If Alltrim(cProdBLQ) == Alltrim(GDFieldGet("UB_PRODUTO",nI)) .and. !lIsMon
			lCancel	:= .T.
		Endif
		If !lIsMon .and. GDFieldGet("UB_VLRITEM",nI)  = 0.01
			cCodBloq += cBLQPSC + "/"
			lBloquei := .T.
		Endif
		If cITEMBLQ == "1"
			If !(cBLQPSC $ cCodBloq)
				cCodBloq += cBLQPSC + "/"
				lBloquei := .T.
			Endif
		ElseIf cITEMBLQ == "2"
			If lIsMon
				GDFieldPut( "UB_XPRCREF",GDFieldGet("UB_VLRITEM",nI)	,nI)
				GDFieldPut( "UB_XBLQITE", "3"	,nI)
			Else
				If !(cBLQAPR $ cCodBloq)
					cCodBloq += cBLQAPR + "/"
					lBloquei := .T.
				Endif
			Endif
		ElseIf cITEMBLQ == "4"
			If lIsMon
				//	GDFieldPut( "UB_XPRCREF",GDFieldGet("UB_VLRITEM",nI)	,nI)
				GDFieldPut( "UB_XBLQITE", "3"	,nI)
			Else
				If !(cBLCOND $ cCodBloq)
					cCodBloq += cBLCOND + "/"
					lBloquei := .T.

				Endif
			Endif
		ElseIf cITEMBLQ == "5"
			If lIsMon
				//	GDFieldPut( "UB_XPRCREF",GDFieldGet("UB_VLRITEM",nI)	,nI)
				GDFieldPut( "UB_XBLQITE", "3"	,nI)
			Else
				/*
				If !(cBLDESC $ cCodBloq)
				cCodBloq += cBLDESC + "/"
				lBloquei := .T.
				Endif
				*/
			Endif

			If lIsMon
				//	GDFieldPut( "UB_XPRCREF",GDFieldGet("UB_VLRITEM",nI)	,nI)

				GDFieldPut( "UB_XBLQITE", "3"	,nI)

			Else

				If	GDFieldGet("UB_VRUNIT ",nI) < GDFieldGet("UB_ZPRCTAB",nI)
					If !(cBLACRE $ cCodBloq)
						cCodBloq += cBLACRE + "/"
						lBloquei := .T.
					Endif
					GDFieldPut( "UB_XBLQITE", "2"	,nI)

				Else

				Endif
			Endif

		Endif
		If lIsMon
			//	GDFieldPut( "UB_XPRCREF",GDFieldGet("UB_VLRITEM",nI)	,nI)
			If  GDFieldGet("UB_VLRITEM",nI)  = 0.01
				GDFieldPut( "UB_XBLQITE", "1"	,nI)
				lBloquei := .T.
			Endif
		Endif

	Next

	If lIsMon
		If Empty(M->UA_XMSGCLI)
			M->UA_XLIMLIB := nVlrItem
		Else
			U_STFSGT43()
		Endif
		M->UA_XMSGCLI := ""
		/*
		DbSelectArea('SUB')
		SUB->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
		While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

		nVlrItem	+=  SUB->UB_VLRITEM
		nVlrST      +=  SUB->UB_QUANT * SUB->UB_ZVALIPI
		nVlrIPI     +=  SUB->UB_QUANT * SUB->UB_ZVALIST
		SUB->(DbSkip())
		End
		Endif
		*/
		If 'FRETE' $ M->UA_XDESBLQ
			M->UA_XCIF := (nVlrItem+nVlrIPI+nVlrST)
		Endif

	Else
		/****************************************
		<<<< ALTERAÇÃO >>>>>
		Ação.........: Bloqueio do Orçamento.
		.............: Retirado a trataiva para bloqueio do orçamento através do campo A1_XCODMC
		Desenvolvedor: Marcelo Klopfer Leme
		Data.........: 12/09/2022
		Chamado......: 20220727014715 - Integração de Cotações
		****************************************/
		////If !Empty(M->UA_XMSGCLI)
		////	If !(cBLQMSG $ cCodBloq)
		////		cCodBloq += cBLQMSG + "/"
		////		lBloquei := .T.
		////	Endif
		////Endif

		If nVlrItem < M->UA_XLIMLIB .AND. M->UA_OPER == "1"
			If !(cBLQVLR $ cCodBloq)
				cCodBloq += cBLQVLR + "/"
				lBloquei := .T.
			Endif
		Endif
		//Giovani Zago 16/04/14 Bloqueio Frete Cif
		_nVaCif:=	Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_XCIF")
		If M->UA_TPFRETE = 'C' .And.  _nVaCif > 0   .And. M->UA_XCIF < (nVlrItem+nVlrIPI+nVlrST)
			If (nVlrItem+nVlrIPI+nVlrST) < _nVaCif //.AND. M->UA_OPER == "1"
				MsgInfo("Atenção Cotação com frete Cif, Valor Menor que o permitido, verifique......!!!!!!")
				If MsgYesNo("Deseja alterar o Frete de CIF para FOB ?")
					M->UA_TPFRETE = 'F'
				Else
					If !(cBLFret $ cCodBloq)
						cCodBloq := cBLFret + "/" +cCodBloq
						lBloquei := .T.
					EndIf
				EndIf

			ElseIf  (nVlrItem+nVlrIPI+nVlrST) < _nVaCif .AND. M->UA_OPER == "2"
				MsgInfo("Atenção Cotação com frete Cif, Valor Menor que o permitido, verifique......!!!!!!")
				If MsgYesNo("Deseja alterar o Frete de CIF para FOB ?")
					M->UA_TPFRETE = 'F'
				EndIf
			Endif
		Endif

		//****************************************
	Endif

	If lCancel .and. Empty(M->UA_XMSGCLI)
		MsgAlert("O produto " +cProdBLQ+ " não pode estar no orçamento! Delete o item e tente salvar o orçamento novamente!")
		Return .F.
	Endif

	If M->UA_OPER == "1" .and. !Empty(M->UA_NUMSC5)
		If lBloquei
			cMsgBlq := "Este orçamento já tem o pedido venda nr. "+M->UA_NUMSC5+" gerado. Esta alteração está está deixando "
			cMsgBlq += "o orçamento bloqueado. Se desejar continuar, o pedido de venda será EXCLUÍDO e as reservas do(s) produto(s) "
			cMsgBlq += "será(ão) perdida(s). Deseja continuar?"
			If (Aviso("Bloqueio de orçamento",cMsgBlq,{"Sim","Não"}) ) == 1
				nRecSUA := SUA->(Recno())
				Processa({|| fAvalPV(@lRet) })
				If !lRet
					Return .F.
				Endif
				//Forca a gravacao da operacao para ORCAMENTO ja que o pedido de venda ja foi excluido
				SUA->(DbGoTo(nRecSUA))
				SUA->(RecLock("SUA",.F.))
				SUA->UA_OPER 		:= "2"
				SUA->UA_XDESBLQ	    := cCodBloq
				SUA->UA_XBLOQ		:= Iif(lBloquei,"1","2")
				SUA->UA_NUMSC5		:= ""
				SUA->(MsUnlock())
				lForcaBLQ := .F.
			Else
				Return .F.
			Endif
		Endif
	Endif

	If lIsMon

		If    ('DESC' $ ALLTRIM(SUA->UA_XDESBLQ))    .And. GetMv("ST_VE4001",,.F. )
			U_STDESALC(Inclui,Altera)//Giovani Zago 18/12/13 Alçada Comercial
			DbSelectArea('ZZI')
			ZZI->(DbGoTop())
			ZZI->(DbSetOrder(3))
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
				If	ZZI->ZZI_BLQ  =  '2' .Or. ZZI->ZZI_BLQ = '3'
					dbSelectArea("ZZH")
					ZZH->(dbSetOrder(1))
					If ZZH->(DbSeek(xFilial("ZZH")+__cUserId)) .or. __cUserId = '000000'
						//_nMin     := ZZH->ZZH_MIN
						//_nMax     := ZZH->ZZH_MAX
						If 	__cUserId = '000000'
							_nMin     := ZZH->ZZH_MIN
							_nMax     := 100
						Else
							_nMin     := ZZH->ZZH_MIN
							If ZZH->ZZH_DTDE <= ddatabase .And.  ZZH->ZZH_DTATE >= ddatabase .And. ZZH->ZZH_LIMITE > 0
								_nMax     := ZZH->ZZH_LIMITE
							Else
								_nMax     := ZZH->ZZH_MAX
							Endif
						Endif

						If ZZI->ZZI_DESC <= _nMax

							ZZI->(RecLock("ZZI",.F.))
							ZZI->ZZI_BLQ    :=  '1'
							ZZI->ZZI_USERAP := __cUserId+" - "+cUserName
							ZZI->ZZI_DTAPR  := dDataBase
							ZZI->(MsUnlock())
							ZZI->( DbCommit() )
							M->UA_XDESBLQ 	:= cCodBloq
							M->UA_XBLOQ		:= Iif(lBloquei,"1","2")
						Else
							MsgInfo("Desconto Fora da Alçada de Aprovação ...!!!!")
						EndIf
					Else

						MsgInfo("Usuario não Cadastrado Como Aprovador...!!!!")
					EndIf
				Else
					M->UA_XDESBLQ 	:= cCodBloq
					M->UA_XBLOQ		:= Iif(lBloquei,"1","2")
				Endif
			Else
				M->UA_XDESBLQ 	:= cCodBloq
				M->UA_XBLOQ		:= Iif(lBloquei,"1","2")
			EndIf
		Else
			M->UA_XDESBLQ 	:= cCodBloq
			M->UA_XBLOQ		:= Iif(lBloquei,"1","2")
		EndIf

	Else
		M->UA_XDESBLQ 	:= cCodBloq
		M->UA_XBLOQ		:= Iif(lBloquei,"1","2")
	Endif
	If lBloquei
		If (M->UA_XBLOQ == "1" )//.and. lForcaBLQ)Alteracao realizada em 16/03/2013 conforme solicitacao de Bruna Berte.
			cMsg := "O orçamento encontra-se bloqueado e portanto não será possível efetivá-lo, transformando-o em um pedido de venda e "
			cMsg += "realizando a reserva dos itens. Entre em contato com seu supervisor para que o mesmo libere este orçamento!"
			//MsgAlert(cMsg)
		Endif
		M->UA_OPER := "2"
	Endif

	RestArea(aArea)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  02/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao para habilitar/desabilitar o acols do Televendas º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE42()
	Local cProdBLQ	:= GetMv("FS_PRODBLQ",.F.,"1020")
	Local lIsMon	:= IsInCallSteck("U_STFSVE40")
	Local cObs		:= MSMM(SUA->UA_XCODANA)

	Local cLogAnali
	If IsInCallSteck("TMKA380")
		ALTERA := .T.
	Endif

	If lIsMon
		If ALTERA
			cLogAnali := "Analisado por(1) " + cUserName + CRLF + " em " + DtoC(dDatabase) +CRLF+" às " + Time()+ CRLF
			SUA->(RecLock("SUA",.F.))
			MSMM(SUA->UA_XCODANA,,,cLogAnali,1,,,"SUA", "UA_XCODANA",,.T.)
			SUA->(MsUnlock())
			M->UA_XMSGANA := cObs + cLogAnali
		Endif
	Endif

	If SUA->UA_OPER == "1"
		If !Empty(M->UA_NUMSC5) .and. HasCB7(M->UA_NUMSC5)
			Alert("Não será possível realizar alterações no orçamento " + SUA->UA_NUM + " pois o pedido de venda associado nr. " + SUA->UA_NUMSC5 + " já foi processado!")
			oGetTLV:Disable()
		Else
			oGetTLV:Enable()
		Endif
	ElseIf Alltrim(cProdBLQ) == Alltrim(GDFieldGet("UB_PRODUTO",1))
		If ALTERA .and. SUA->UA_XBLOQ == "1"
			oGetTLV:Disable()
		Else
			oGetTLV:Enable()
		Endif
	ElseIf SUA->UA_XBLOQ == "3"
		oGetTLV:Disable()
	Else
		oGetTLV:Enable()
	Endif
	oGetTlv:oBrowse:Refresh(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  02/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacao de campo memo personalizado na tela de televendas º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE43()

	Local aArea := GetArea()

	SUA->(RecLock("SUA",.F.))
	MSMM(SUA->UA_XCODMC,,,M->UA_XMSGCLI,1,,,"SUA", "UA_XCODMC",,.T.)
	SUA->(MsUnlock())

	//Libera o aCols caso estivesse bloqueada para edicao
	If !IsBlind()
		oGetTLV:Enable()
		oGetTlv:oBrowse:Refresh(.T.)
	EndIf

	RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  02/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a abertura da tela do TELEVENDAS chamada pelo        º±±
±±º          ³P.E. TK271ABR                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE44(nOrcamento)
	Local lMonCan	:= IsInCallSteck("U_STFSVE60")
	Local lRet := U_STTMKI80(nOrcamento)

	Local _cCod    := __cuserid

	If IsBlind()
		Return .T.
	EndIf

	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod)) .And. !("STFSVE40"  $ Upper(FunName()))
		If nOrcamento == 4 .Or. nOrcamento == 3
			If SUBSTR(SA3->A3_COD,1,1) =  GETMV("ST_361MN",,'S') .Or. SA3->A3_COD $ (getmv("ST_361MN1",,"I08072/I08009/I08011"))
				//MsgStop("Usuario sem acesso","Ação não permitida")
				Return .F.
			Endif
		Endif
	Endif
	If SUA->(Eof())
		Return .T.
	Endif

	If lMonCan
		Return .T.
	Endif

	If .f. //nOrcamento == 4 .and. SUA->UA_OPER == "1" .and. !(SUA->UA_STATUS == "CAN")
		MsgStop("Não é possível realizar alterações em orçamentos que já foram efetivados!","Alteração não permitida")
		Return .F.
	ElseIf nOrcamento == 4 .and. SUA->UA_XBLOQ == "3"
		MsgStop("Não é possível realizar alterações em orçamentos que estão em fase de cancelamento!","Alteração não permitida")
		Return .F.
	Endif

	If !(lRet)
		Return .F.
	Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE41  ºAutor  ³Microsiga           º Data ³  02/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho acionado no campo UB_PRODUTO                        º±±
±±º          ³Atualiza a os bloqueios e precos				                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSGT40()
	Local cRet 		:= &(ReadVar())
	Local cCodCli	:= M->UA_CLIENTE
	Local cLoja		:= M->UA_LOJA
	Local cTabPr	:= M->UA_TABELA
	Local cProduto	:= cRet
	Local aArea		:= GetArea()
	Local nPrcCon	:= U_STPRECON()
	Local cSuf		:= ""
	Local lIsMon	:= IsInCallSteck("U_STFSVE40")
	Local nI

	GDFieldPut( "UB_XPRCREF", GDFieldGet("UB_PRCTAB",n) , n)
	GDFieldPut( "UB_XBLQITE","3", n )

	//Verifica o preco unitario e faz a analise de preco sob consulta
	If GDFieldGet("UB_VRUNIT",n) == nPrcCon .and. !lIsMon
		GDFieldPut( "UB_XBLQITE","1", n )
	Endif

	//Carrega o preco e data da ultima compra para o item
	SA7->(DbSetOrder(1)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
	If SA7->(DbSeek(xFilial("SA7")+cCodCli+cLoja+cProduto))
		For nI := 12 TO 1 Step -1
			cSuf := StrZero(nI,2)
			If !Empty(SA7->(FieldGet(FieldPos("A7_DTREF"+cSuf))))
				GDFieldPut( "UB_XULTPRC",SA7->(FieldGet(FieldPos("A7_PRECO"+cSuf))), n )
				GDFieldPut( "UB_XULTCOM",SA7->(FieldGet(FieldPos("A7_DTREF"+cSuf))), n )

				If (Aviso("Atenção","O Preço atual é de: "+Transform(GDFieldGet("UB_PRCTAB",n),"@E 999,999.99")+chr(13)+chr(10)+". O Último preço é de: "+Transform(GDFieldGet("UB_XULTPRC",n),"@E 999,999.99")+chr(13)+chr(10)+". Deseja manter o último preço?",{"Sim","Não"})) == 1
					GDFieldPut( "UB_VRUNIT",SA7->(FieldGet(FieldPos("A7_PRECO"+cSuf))), n )
				Endif

				Exit
			Endif
		Next
	Else
		GDFieldPut( "UB_XULTPRC",0, n )
		GDFieldPut( "UB_XULTCOM",CtoD("  /  /  "), n )
	Endif

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE41  ºAutor  ³Microsiga           º Data ³  02/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho acionado no campo UA_CLIENTE                        º±±
±±º          ³Atualiza a Mensagem do Cadastro do Cliente                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSGT41()
	Local cRet 		:= &(ReadVar())
	Local cCodCli	:= M->UA_CLIENTE
	Local cLoja		:= M->UA_LOJA
	Local aArea		:= GetArea()
	Local cProdBLQ	:= GetMv("FS_PRODBLQ",.F.,"1020")
	Local cTesBLQ	:= GetMv("FS_TESBLQ",.F.,"501")
	Local nPrcCon	:= 0.02//U_STPRECON()
	Local aTMP		:= {}
	Local nI
	If M->UA_STATUS == "CAN"
		Return cRet
	Endif

	SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
	If !SA1->(DbSeek(xFilial("SA1")+cCodCli+cLoja))
		RestArea(aArea)
		Return cRet
	Endif
	
	/****************************************
	<<<< ALTERAÇÃO >>>>>
	Ação.........: Bloqueio do Orçamento.
	.............: Retirado a trataiva para bloqueio do orçamento através do campo A1_XCODMC
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 12/09/2022
	Chamado......: 20220727014715 - Integração de Cotações
	****************************************/
	cSaveMsg := MSMM(SA1->A1_XCODMC)
	IF !EMPTY(cSaveMsg)
		M->UA_XMSGCLI	:= cSaveMsg
		//M->UA_XBLOQ		:= "1"
		//M->UA_XDESBLQ := 	ALLTRIM(M->UA_XDESBLQ)+'MSG/'
		/******************************
		Caso a chamda não venha da Integração do CRM
		******************************/
		IF !Isincallstack("U_STCRM08A")
			msginfo(Alltrim(MSMM(SA1->A1_XCODMC,43)))
		ENDIF
	ENDIF

	U_STFSGT43()

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE42  ºAutor  ³Microsiga           º Data ³  02/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho acionado nos campos do SUB                          º±±
±±º          ³Atualiza a os bloqueios e precos				                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSGT42()
	Local cRet 		:= &(ReadVar())
	Local aArea		:= GetArea()
	Local nPrcCon	:= U_STPRECON()
	Local cTabPr	:= M->UA_TABELA
	Local lIsBloq	:= M->UA_XBLOQ == "1"
	Local lIsMon	:= IsInCallSteck("U_STFSVE40")

	If !Empty(M->UA_XMSGCLI) .and. lIsBloq .and. !lIsMon
		GDFieldPut( "UB_VRUNIT"		, nPrcCon , n)
		GDFieldPut( "UB_VLRITEM"	, GDFieldGet("UB_QUANT",n)*nPrcCon , n)
		GDFieldPut( "UB_PRCTAB"		, nPrcCon , n)
		GDFieldPut( "UB_XPRCREF"	, nPrcCon , n)
		M->UA_TABELA := ""

		If ReadVar() == "M->UB_PRODUTO"
			TKP000A(GDFieldGet("UB_PRODUTO",n),n,.F.)
		ElseIf ReadVar() == "M->UB_QUANT"
			TKP000B(GDFieldGet("UB_QUANT",n),n)
		ElseIf ReadVar() == "M->UB_VRUNIT"
			cRet := nPrcCon
			TKP000A(GDFieldGet("UB_PRODUTO",n),n,.F.)
		Endif
		M->UA_TABELA := cTabPr
	Else
		nVlrItem	:= GDFieldGet("UB_VRUNIT"  ,n)
		nVlrTab	:= GDFieldGet("UB_XPRCREF" ,n)
		If nVlrItem < nVlrTab .and. !lIsMon
			GDFieldPut( "UB_XBLQITE","2", n )
		Else
			If !lIsMon
				GDFieldPut( "UB_XBLQITE","3", n )
				If nVlrTab == nPrcCon
					If ReadVar() == "M->UB_VRUNIT"
						cRet := nPrcCon
						TKP000A(GDFieldGet("UB_PRODUTO",n),n,.F.)
						GDFieldPut( "UB_XBLQITE","1", n )
					Endif
					GDFieldPut( "UB_XBLQITE","1", n )
				Else
					GDFieldPut( "UB_XBLQITE","3", n )
				Endif
			Else
				If ReadVar() == "M->UB_VRUNIT"
					GDFieldPut( "UB_XPRCREF",nVlrItem, n )
					//TKP000A(GDFieldGet("UB_PRODUTO",n),n,.F.)
					GDFieldPut( "UB_XBLQITE","3", n )
				Endif
			Endif
		Endif
	Endif

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  02/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho acionado no campo UA_CONDPG                         º±±
±±º          ³Atualiza a os bloqueios e precos				                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSGT43()
	Local cRet 		:= &(ReadVar())
	Local aArea		:= GetArea()
	Local aSE4Area	:= SE4->(GetArea())

	SE4->(DbSetOrder(1)) //E4_FILIAL+E4_CODIGO
	If SE4->(DbSeek(xFilial("SE4")+M->UA_CONDPG))
		M->UA_XLIMLIB := SE4->E4_XVLRMIN
	Endif

	RestArea(aSE4Area)
	RestArea(aArea)
Return cRet

User Function STPRECON()
	Local nRet := 0.01
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE45  ºAutor  ³Microsiga           º Data ³  02/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizando no PE TMKVLD4                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSVE45(nOpc,cCondPag,oObj)
	If !Empty(M->UA_CONDPG) .and. !(M->UA_CONDPG == cCondPag)
		Alert("A condição de pagamento não pode ser manipulada nesta tela, devido às validações específicas da STECK !")
		oObj:cText := M->UA_CONDPG
		oObj:Refresh()
		oObj:SetFocus()
		Return .F.
	Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  03/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAvalPV(lRet)
	Local aArea 	:= GetArea()
	Local aSC5Area := SC5->(GetArea())
	Local aSC6Area	:= SC6->(GetArea())
	Local aSC5		:= {}
	Local aSC6		:= {}
	Local aItens	:= {}
	Local cNumPed	:= ""

	SC5->(DbSetOrder(1))
	If !SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
		MsgAlert("Pedido de venda não localizado! Impossível continuar com a alteração!!")
		RestArea(aSC5Area)
		RestArea(aArea)
		lRet := .F.
		Return
	Endif
	cNumPed := SC5->C5_NUM

	aAdd( aSC5,{"C5_FILIAL" ,SC5->C5_FILIAL	,Nil } )
	aAdd( aSC5,{"C5_NUM"		,SC5->C5_NUM		,Nil } )
	aAdd( aSC5,{"C5_TIPO"   ,SC5->C5_TIPO		,Nil } )
	aAdd( aSC5,{"C5_CLIENTE",SC5->C5_CLIENTE	,Nil } )
	aAdd( aSC5,{"C5_LOJACLI",SC5->C5_LOJACLI	,Nil } )
	aAdd( aSC5,{"C5_CLIENT" ,SC5->C5_CLIENT	,Nil } )
	aAdd( aSC5,{"C5_LOJAENT",SC5->C5_LOJAENT	,Nil } )
	aAdd( aSC5,{"C5_TIPOCLI",SC5->C5_TIPOCLI	,Nil } )
	aAdd( aSC5,{"C5_CONDPAG",SC5->C5_CONDPAG	,Nil } )
	aAdd( aSC5,{"C5_TABELA" ,SC5->C5_TABELA	,Nil } )
	aAdd( aSC5,{"C5_EMISSAO",SC5->C5_EMISSAO	,Nil } )

	SC6->(DbSetOrder(1))
	If !SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		MsgAlert("Item do pedido de venda não localizado! Impossível continuar com a alteração!!")
		RestArea(aSC6Area)
		RestArea(aSC5Area)
		RestArea(aArea)
		lRet := .F.
		Return
	Endif

	While SC6->(!EOF() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+SC5->C5_NUM)

		aAdd( aItens , {"C6_ITEM"		,SC6->C6_ITEM		,Nil } ) //Item Pedido: Obrigatorio
		aAdd( aItens , {"C6_NUM"		,SC6->C6_NUM		,Nil } ) //Unidade: Obrigatorio
		aAdd( aItens , {"C6_UM"			,SC6->C6_UM			,Nil } ) //Unidade: Obrigatorio
		aAdd( aItens , {"C6_CLI"		,SC6->C6_CLI		,Nil } ) //Codigo do Cliente: Obrigatorio
		aAdd( aItens , {"C6_LOJA"   	,SC6->C6_LOJA		,Nil } ) //Loja do Cliente: Obrigatorio
		aAdd( aItens , {"C6_DESCRI" 	,SC6->C6_DESCRI	,Nil } ) //Descricao
		aAdd( aItens , {"C6_PRODUTO"	,SC6->C6_PRODUTO	,Nil } ) //Produto: Obrigatorio
		aAdd( aItens , {"C6_QTDVEN" 	,SC6->C6_QTDVEN	,Nil } ) //Quantidade: Obrigatorio
		aAdd( aItens , {"C6_PRCVEN" 	,SC6->C6_PRCVEN	,Nil } ) //Preco da Venda
		aAdd( aItens , {"C6_PRUNIT" 	,SC6->C6_PRUNIT	,Nil } ) //Preco de Lista
		aAdd( aItens , {"C6_VALOR"  	,SC6->C6_VALOR		,Nil } ) //Valor Total: Obrigatorio
		aAdd( aItens , {"C6_DESCONT" 	,SC6->C6_DESCONT	,Nil } ) //Percentual do Desconto
		aAdd( aItens , {"C6_VALDESC"  ,SC6->C6_VALDESC	,Nil } ) //Valor do Desconto
		aAdd( aItens , {"C6_TES"    	,SC6->C6_TES	 	,Nil } ) //TES: Obrigatorio
		aAdd( aItens , {"C6_LOCAL"  	,SC6->C6_LOCAL		,Nil } ) //Almoxarifado Obrigatorio
		aAdd( aItens , {"C6_ENTRE1" 	,SC6->C6_ENTRE1	,Nil } ) //Data Entrega: Obrigatorio

		aAdd( aSC6,aItens)
		SC6->(RecLock("SC6",.F.))
		//SC6->C6_PEDCLI := Substr(SC6->C6_PEDCLI,4) - Renato Nogueira - Retirado por problema no portal
		SC6->(MsUnlock())
		SC6->( DbCommit() )
		SC6->(Dbskip())

	EndDo

	lRet := fDelPV(aSC5,aSC6,5)

	If !lRet
		//Volta TMK no C6_PEDCLI
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6")+cNumPed))
			While SC6->(!EOF() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+cNumPed)
				SC6->(RecLock("SC6",.F.))
				//SC6->C6_PEDCLI := "TMK" + SC6->C6_PEDCLI - Renato Nogueira - Retirado por problema no portal
				SC6->(MsUnlock())
				SC6->( DbCommit() )
				SC6->(Dbskip())
			EndDo
		Endif
		MsgAlert("Não foi possível realizar a exclusão do pedido de venda. Impossível continuar com a alteração!!")
	Endif

	RestArea(aSC6Area)
	RestArea(aSC5Area)
	RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  º Autor ³Microsiga           º Data ³  03/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para delecao de pedido de venda                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fDelPV(aCab,aItem)
	Private lMsErroAuto := .F.

	lMSErroAuto := .F.
	MsExecAuto({|x,y,z| mata410(x,y,z)},aCab,aItem,5)

	If lMsErroAuto
		Mostraerro()
		Return .F.
	EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE40  ºAutor  ³Microsiga           º Data ³  03/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function HasCB7(cPedido)
	Local aArea		:= GetArea()
	Local aCB7Area	:= CB7->(GetArea())
	Local lRet		:= .F.

	CB7->(DbSetorder(2))  //CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG
	If CB7->(DbSeek(xFilial('CB7')+cPedido))
		lRet:= .T.
	Endif

	RestArea(aCB7Area)
	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE47  ºAutor  ³Microsiga           º Data ³  20/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³   Funcão para rejeição                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE48()

	Local _cTitulo   := 'Rejeitar Orçamento - ' + ALLTRIM(UA_NUM)
	Local cLogAnali := "Analisado por(2) " + cUserName + CRLF + " em " + DtoC(dDatabase) +CRLF+" às " + Time()+ CRLF
	Local cObs		:= MSMM(SUA->UA_XCODANA)
	Local cLinha := SPACE(50)
	Local cTexto := ""
	Local oMemo
	Local cLinha1 :=10   //Criado variavel local Lobo Guara

	//DEFINE MSDIALOG oDlgRej TITLE OemToAnsi(_cTitulo) From 1,0 To 30,55 OF oMainWnd
	DEFINE MSDIALOG oDlgRej FROM 05,10 TO 260,340 TITLE _cTitulo OF oMainWnd PIXEL

	@ 05,04 SAY 'Analise de Bloq.' PIXEL OF oDlgRej	
	@ 15,04 MSGet cLinha1  VAR cLinha   Size 145,082  PIXEL OF oDlgRej
	//@ 15,04 GET oMemo VAR cTexto OF oDlgRej MEMO size 145,082 PIXEL OF oDlgRej
	@ 106, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgRej:End()})  Pixel
	@ 106, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgRej:End()})  Pixel
	nOpca:=0

	ACTIVATE MSDIALOG oDlgRej CENTERED

	If nOpca == 1

		SUA->(RecLock("SUA",.F.))
		SUA->UA_XDESBLQ := 'REJEITADO'
		MSMM(SUA->UA_XCODANA,,,cLogAnali + ' '+ cLinha,1,,,"SUA", "UA_XCODANA",,.T.)
		SUA->(MsUnlock())
		M->UA_XMSGANA := cObs + cTexto + cLogAnali
		u_STzzimail('',cLinha,cusername,dtoc(date()),time(),'')
		MSGINFO('Rejeição efetuada com sucesso')
	Endif

Return()

/*
//=============================================================================//
//Programa: STFSVE49  Autoria: Flávia Rocha - Sigamat Consultoria              //
//Data    : 20/10/2022                                                         //
//=============================================================================//
//Desc. Efetua carga de arquivo csv para povoar o campo %Desconto nos itens    //
//      do orçamento (chamado via botão lateral do pto entrada TMKBARLA)       //
//=============================================================================//
*/
User Function STFSVE49()

	Local _cLog    := ""
	Local lRet     := .F.

	//MSGINFO("CARGA DE DESCONTOS VIA CSV")
		
	_cLog:= "IMPORTAÇÃO DE ARQUIVO CSV: "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  
	
		MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[STFSVE49] - ATENCAO")
		
		Return
	Else
		//Conout( "Gerando Título a Pagar (PROPAY / SE2), aguarde...",, {|| FIMPSE2(cFil, cPasta , cArquivo)} )		
		MsgRun( "Atualizando Descontos, aguarde...",, {|| FIMPCSV(cArquivo)} )	
		//MsgInfo("Processo Atualiza Descontos Finalizado, OK")	
	EndIf


	
Return()

//==============================================================================//
//Função  : FIMPCSV
//Autoria : Flávia Rocha - Data: 20/10/2022 
//Objetivo:
//Função que um arquivo csv e faz a importação campo a campo e gravará no campo 
//UB_XPORDEC (Acionar o gatilho STGAP07 o qual recalcula os valores unitários
//            perante o desconto informado)
//==============================================================================//
Static Function FIMPCSV(cArquivo)
Local cLinha  	:= ""
Local i       	:= 0
Local lPrim   	:= .T.
Local aCampos 	:= {}
Local aDados  	:= {}
Local nValdesc  := 0
Local nVrunit   := 0 
Local nContaItens := 0
Local cUANUM    := SUA->UA_NUM
Local cUAFIL    := SUA->UA_FILIAL

FT_FUSE(cArquivo)                   // abrir arquivo
ProcRegua(FT_FLASTREC())             // quantos registros ler
FT_FGOTOP()                          // ir para o topo do arquivo
While !FT_FEOF()                     // faça enquanto não for fim do arquivo

	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()           // lendo a linha
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	FT_FSKIP()
EndDo

ProcRegua(Len(aDados))


SUB->(OrdSetfocus(1))  //UB_FILIAL + UB_NUM + UB_ITEM + UB_PRODUTO
If SUB->(Dbseek(cUAFIL + cUANUM  ))
	While !SUB->(Eof()) .and. SUB->UB_FILIAL == cUAFIL .and. SUB->UB_NUM == cUANUM
		nContaItens++
		SUB->(Dbskip())
	Enddo
Endif 

If nContaItens == Len(aDados)

	For i:=1 to Len(aDados)  //ler linhas da array

		/*
		cLinha := SUB->UB_FILIAL + ";"
		cLinha += SUB->UB_NUM + ";"
		cLinha += SUB->UB_ITEM + ";"
		cLinha += SUB->UB_PRODUTO + ";"
		cLinha += SUB->UB_QUANT + ";"
		cLinha += SUB->UB_VRUNIT + ";"
		cLinha += SUB->UB_XPORDEC + ";"    
		cLinha += SUB->UB_ZPRCTAB + ";"
		cLinha += CRLF
		*/
		
		
			cFili       := Alltrim(aDados[i,1])		
			cNumorc     := Alltrim(aDados[i,2])
			cItem       := Str(i)  //Alltrim(aDados[i,3])		
			cProd 		:= Alltrim(aDados[i,4])
			nQtd        := Val(aDados[i,5]) 
			nValor      := Val(StrTran(StrTran(aDados[i,6],".",","),",","."))  
			nDesc		:= Val(StrTran(StrTran(aDados[i,7],".",","),",","."))  
			nZPrcTab	:= Val(StrTran(StrTran(aDados[i,8],".",","),",","."))  
			
			//grava na SUB
			//STGAP07('1',Val(cItem),nDesc)
			/*
			aCols[_nRet,_nPosPrcven]   := aCols[_nRet,_nPosPrcven] + aCols[_nRet,_nPosXVALdesc]
			aCols[_nRet,_nPosXDesc]    :=_nValr  //Aqui guarda o percentual de desconto (Vai para o campo UB_XPORDEC)
			aCols[_nRet,_nPosXVALdesc] := Round(((	_nValr*aCols[_nRet,_nPosPrcven])/100),2)
			aCols[_nRet,_nPosPrcven]   := ROUND(aCols[_nRet,_nPosPrcven] - aCols[_nRet,_nPosXVALdesc],2)
			aCols[_nRet,_nPosTotItem]  := ROUND(aCols[_nRet,_nPosPrcven]*aCols[_nRet,_nPosQtdVen],2)
			aCols[_nRet,_nPosXPrCcon]  :=  aCols[_nRet,_nPosPrcven]
			aCols[_nRet,_nPosList]         := aCols[_nRet,_nPosPrcven]
			_nTotPed    += aCols[_nRet,_nPosTotItem]
			*/

			nValdesc := 0
			nVrunit  := 0 

			//SUB->(OrdSetfocus(1))  //UB_FILIAL + UB_NUM + UB_ITEM + UB_PRODUTO
			//If SUB->(Dbseek(xFilial("SUB") + cNumorc + cItem  + cProd ))
				//Reclock("SUB" , .F.)
				
				//atualiza o % desconto:
				//SUB->UB_XPORDEC := Round(nDesc,2)

				//atualiza valor desconto:
				//nValDesc := Round( ( SUB->UB_ZPRCTAB * (nDesc / 100)) , 2 ) 
				//SUB->UB_XVALDES := nValDesc
				
				//pega o preço de tabela e calcula o valor do desconto, depois subtrai = valor unitário já com desconto:
				//nVrunit := SUB->UB_ZPRCTAB - nValDesc
				//SUB->UB_VRUNIT  := nVrunit

				//atualiza o valor total do item:
				//SUB->UB_VLRITEM := SUB->UB_QUANT * nVrunit
				
				//SUB->(MsUnlock())
			//Endif 
			cTip 	:= '1'
			_nRet	:= i //Val(cItem)
			_nValr 	:= nDesc
			U_STGAP07(cTip,_nRet,_nValr)
		
	Next
Else 
	MsgAlert("O Arquivo Selecionado Possui Mais Itens que o Orçamento: " + cUANUM)
Endif 	
FT_FUSE()
	

//MsgInfo("Processo Finalizado, OK")
	

Return()




