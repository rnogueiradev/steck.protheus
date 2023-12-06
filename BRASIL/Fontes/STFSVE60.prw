#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE60  บAutor  ณMicrosiga           บ Data ณ  02/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcesso de cancelamento de orcamentos                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVE60()
	Local aCores2    := {{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" 	, "BR_VERDE"	},;// Faturamento - VERDE
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))"	, "BR_VERMELHO"},;// Faturado - VERMELHO
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"                				, "BR_AZUL"   	},;// Orcamento - AZUL
	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"                				, "BR_MARRON"	},;// Atendimento - MARRON
	{"(!EMPTY(SUA->UA_CODCANC))"																			,"BR_PRETO"   }}	// Cancelado
	
	Local cFiltro := "UA_FILIAL = '"+xFilial("SUA")+"' AND UA_XBLOQ= '3' AND UA_CODCANC= ' '"
	Private cCadastro	 := "Atendimento"
	Private aRotina      := {}
	Private lTk271Auto   := .F.
	Private cAliasAuto   := "" // Alias para identificar qual sera a rotina de atendimento para entrada automatica
	Private aAutoCab     := {} // Campos de Cabecalho utilizados na rotina automatica
	Private aAutoItens   := {} // Campos dos Itens utilizados na rotina automatica
	Public cAutorizaCanc := "N"
	
	aRotina	:= 		{	{"Pesquisar" 	,"AxPesqui"				,0,1 },;
		{ "Visualizar"	,"TK271CallCenter"		,0,2 },;
		{ "Legenda"		,"TK271Legenda"     	,0,2 },;
		{ "Autorizar"	,"U_STFSVE65"			,0,4 }}
	
	MBrowse(,,,,"SUA",,,,,,aCores2,,,,,,,,cFiltro,3000,{|| o:=GetObjBrow(),o:Refresh()})
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE61  บAutor  ณMicrosiga           บ Data ณ  02/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se permite o cancelamento do orcamento ou nao        บฑฑ
ฑฑบ          ณchamado pelo P.E. TMKVEX                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVE61()
	Local lMonCan	:= IsInCallSteck("U_STFSVE60")
	Local nOpcCan	:= 0
	Local cCM		:= Space(6)
	Local dDtRet	:= dDatabase + 1
	Local cDescCM	:= ""
	Local cObs		:= MSMM(SUA->UA_CODCANC,TamSx3("UA_OBSCANC")[1])
	Local aRotAnt	:= aClone(aRotina)
	Local oDlg, oCM, oOBs,oDescCM, oDtRet
	Local oTelaAtu
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local _cEmail   := "everson.santana@steck.com.br"
	Local _cCopia   := ""
	Local _cAssunto := 'Problema em pedido'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	
	If !lMonCan .and. !ALTERA .and. !(SUA->UA_OPER == "1")
		MsgStop("Para cancelar o or็amento selecione a op็ใo ALTERAR!","Cancelamento nใo permitido")
		Return .F.
	Endif
	
	If SUA->UA_XBLOQ == "3" .and. !lMonCan
		MsgStop("Este or็amento encontra-se em anแlise de cancelamento! Entre em contato com o/a supervisor(a) e solicite a a็ใo desejada",;
			"Cancelamento nใo permitido")
		Return .F.
	Endif
	
	DbSelectArea("ZZY")
	ZZY->(DbSetOrder(1))
	ZZY->(DbGoTop())
	If ZZY->(DbSeek(xFilial("ZZY")+SUA->UA_NUM))
		
		MsgStop("Este or็amento encontra-se cadastrado na Agenda do Operador! cancelamento permitido apenas na agenda do operador",;
			"Cancelamento nใo permitido")
		Return .F.
		
	EndIf
	
	
	
	If SUA->UA_XBLOQ == "3" .and. lMonCan
		nOpcao := Aviso("Cancelamento de Orcamento","Cancelar Or็amento?",{"Cancela","Estorna"})
		If nOpcao == 3
			Return .F.
		ElseIf nOpcao == 1
			cObs := MSMM(SUA->UA_XCODCAN,TamSx3("UA_XMSGCAN")[1])
			SUA->(RecLock("SUA",.F.))
			SUA->UA_XBLOQ := "1" //Deixa o orcamento bloqueado para forcar a analise pela rotina padrao.
			MSMM(SUA->UA_CODOBS,,,Upper(Alltrim(cObs)),	1,,,"SUA","UA_CODOBS",,.T.)
			SUA->(MsUnlock())
			oTelaAtu	:= GetWndDefault()
			oTelaAtu:End()
			Return .T.
		Else
			
			DEFINE MSDIALOG oDlg FROM 05,10 TO 270,350 TITLE "Posicionamento de Cancelamento" OF oMainWnd PIXEL
			
			@ 015,005 Say "Data de Retorno:" PIXEL of oDlg
			@ 015,045 MsGet oDtRet Var dDtRet PIXEL of oDlg SIZE 060,08 VALID fValDTR(dDtRet,oDtRet)
			@ 030,005 Say "Texto:" PIXEL of oDlg
			@ 040,005 GET oObs VAR cObs OF oDlg MEMO SIZE 160,90 PIXEL Valid !Empty(cObs)
			
			ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| nOpcCan:=1,oDlg:End()} , {|| oDlg:End() },, )
			
			If !(nOpcCan == 1)
				Return .F.
			Endif
			
			If Empty(M->UA_CODCONT)
				Alert("Selecione um contato do cliente para que seja possํvel realizar o posicionamento!")
				aRotina	:= {{"Pesquisar","AxPesqui",0,1},{ "Visualizar"  ,"TK271CallCenter" ,0,2 },{ "Incluir"  ,"TK271CallCenter" ,0,3 },;
					{ "Alterar"  ,"TK271CallCenter" ,0,4 },{ "Legenda"  ,"TK271Legenda"	  ,0,2 },{ "Copiar"  ,"TK271Copia"	  ,0,6 } }
				
				While !TkContatos()
					Alert("A escolha de um contato ้ obrigat๓ria para realizar o posicionamento!")
				End
				aRotina := aClone(aRotAnt)
				M->UA_CODCONT	:= SU5->U5_CODCONT
				M->UA_DESCNT	:= SU5->U5_CONTAT
			Endif
			
			M->UA_PROXLIG := dDtRet
			SUA->(RecLock("SUA",.F.))
			//Deixa o orcamento bloqueado para forcar a analise pela rotina padrao.
			SUA->UA_XBLOQ := "1"
			//Forca a gravacao do contato caso o orcamento nao tivesse um
			SUA->UA_CODCONT:= M->UA_CODCONT
			SUA->UA_DESCNT	:= M->UA_DESCNT
			//Grava a data de retorno da ligacao
			SUA->UA_PROXLIG:= dDtRet
			MSMM(SUA->UA_CODOBS,,,Upper(Alltrim(cObs)),	1,,,"SUA","UA_CODOBS",,.T.)
			
			SUA->(MsUnlock())
			TKGrvSU4(M->UA_CODCONT,IF(lProspect,"SUS","SA1"),(M->UA_CLIENTE+M->UA_LOJA),M->UA_OPERADO,"2",M->UA_NUM,M->UA_PROXLIG,M->UA_HRPEND,.F.)
			
			oTelaAtu	:= GetWndDefault()
			oTelaAtu:End()
			oBrwAtu	:= GetObjBrow()
			Eval(oBrwAtu:BGoTop)
			oBrwAtu:Refresh()
			Return .F.
		Endif
	Endif
	
	If !(SUA->UA_XBLOQ == "3") //Muda o status para pre-cancelado
	
		If __cUserId $ GetMv("ST_CANCORC")
			nOpcao := Aviso("Cancelamento de Orcamento","Deseja cancelar este or็amento?",{"Sim","Nใo"})
			If nOpcao == 2
				Return .F.
			Endif
		
			DEFINE MSDIALOG oDlg FROM 05,10 TO 270,350 TITLE "Motivo de Cancelamento" OF oMainWnd PIXEL
		
			@ 015,005 Say "Cod. Motivo:" PIXEL of oDlg
			@ 015,043 MsGet oCM Var cCM  PIXEL of oDlg SIZE 060,08 VALID fValCM(oCM,oDescCM) F3 'PA3FSW'
			@ 028,005 MsGet oDescCM Var cDescCM  PIXEL of oDlg SIZE 100,08 When .F.
			@ 040,005 Say "Observa็ใo:" PIXEL of oDlg
			@ 050,005 GET oObs VAR cObs OF oDlg MEMO SIZE 113,45 PIXEL Valid !Empty(cObs)
		
			ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| nOpcCan:=1,oDlg:End()} , {|| oDlg:End() },, )
		
			If nOpcCan == 1
				M->UA_XMSGCAN :=	"Solicitante: " + cUserName+CRLF+;
					"Solicita็ใo em " + DtoC(dDatabase) + " เs " + Time() + CRLF +;
					"Motivo do Cancelamento: "+ Upper(Alltrim(cDescCM))+CRLF+;
					"Descri็ใo da Solicita็ใo: " + CRLF + Upper(Alltrim(cObs))
				M->UA_XDESCMC	:= Upper(cDescCM)
				M->UA_XCODMCA	:= cCM
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XBLOQ := "3"
				SUA->UA_XCODMCA := cCM
				MSMM(SUA->UA_XCODCAN,,,M->UA_XMSGCAN,1,,,"SUA", "UA_XCODCAN",,.T.)
				SUA->(MsUnlock())
			
			
				DbSelectArea('ZZI')
				ZZI->(DbGoTop())
				ZZI->(DbSetOrder(3))
				If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
					If ZZI->ZZI_BLQ = '2'
						ZZI->(RecLock('ZZI',.F.))
						ZZI->(DbDelete())
						ZZI->(MsUnlock())
						ZZI->( DbCommit())
					Endif
				Endif
			//Chamado 003486
				cQuery	:= " SELECT COUNT(*) CONT "
				cQuery  += " FROM " +RetSqlName("ZZI")+ " ZZI "
				cQuery  += " WHERE ZZI_FILANT='"+SUA->UA_FILIAL+"' AND ZZI_TIPO='ORวAMENTO' "
				cQuery  += " AND ZZI_NUM='"+SUA->UA_NUM+"' "
			
				If !Empty(Select(cAlias))
					DbSelectArea(cAlias)
					(cAlias)->(dbCloseArea())
				Endif
			
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
			
				dbSelectArea(cAlias)
				(cAlias)->(dbGoTop())
			
				If (cAlias)->(CONT)>0
					_cAssunto := '[WFPROTHEUS] - Or็amento: '+SUA->UA_NUM+' baixado, motivo: '+AllTrim(Posicione("PA3",1,xFilial("PA3")+SUA->UA_XCODMCA,"PA3_DESCRI"))+" "+Upper(Alltrim(cObs))
					cMsg	  := ""
					_cCopia	  := ""
					_cEmail	  := ""// Ticket 20201029009696
				
					DbSelectArea('SA3')
					SA3->(DbSetOrder(1))
					If SA3->(dbSeek(xFilial('SA3')+SUA->UA_VEND))
						DbSelectArea('SA3')
						SA3->(DbSetOrder(1))
						If SA3->(dbSeek(xFilial('SA3')+SA3->A3_SUPER))
						
							_cEmail:= "  ; "+SA3->A3_EMAIL
						
						EndIf
					
					EndIf
				
					If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
						VtAlert("Problemas no envio de email!")
					EndIf
				EndIf
			
				oTelaAtu	:= GetWndDefault()
				oTelaAtu:End()
			
				Return .F.
			Endif
	
		else
			MSGALERT("Cancelamento s๓ pode ser efetuado na agenda do Operador!")
			Return .F.
		ENDIF
	Endif
	
	
Return .F.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE60  บAutor  ณMicrosiga           บ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao no codigo do motivo do cancelamento               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValCM(oCM,oDescCM)
	Local aPA3Area	:= PA3->(GetArea())
	Local lRet		:= .T.
	
	PA3->(DbSetOrder(1)) //PA3_FILIAL+PA3_CODIGO
	If !PA3->(DbSeek(xFilial("PA3")+oCM:cText))
		oDescCM:cText:= ""
		lRet:=.F.
	Endif
	oDescCM:cText:= PA3->PA3_DESCRI
	
	RestArea(aPA3Area)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE60  บAutor  ณMicrosiga           บ Data ณ  02/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidaca da data de retorno antes do cancelamento           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValDtR(dDtRet,oDtRet)
	Local lRet		:= .T.
	Local nDiasLim	:= GetMV("FS_DIASLIM",.F.,20)
	Local dDtLim	:= dDatabase+nDiasLim
	
	If Empty(dDtRet) .or. dDtRet < dDatabase .or. dDtRet > dDtLim
		Alert("Data de retorno menor ou maior do que o limite de "+Alltrim(Str(nDiasLim))+" dias! A mesma serแ alterada")
		oDtRet:cText := dDtLim
		lRet := .F.
	Endif
	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE60  บAutor  ณMicrosiga           บ Data ณ  02/17/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para exibir ou nao a mensagem no fechamento da tela  บฑฑ
ฑฑบ          ณdo CALL CENTER (P.E. TMKOUT)                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVE63(lMsg,cAutorizaCanc)//giovani.zago coloquei o default pois estava dando erro 19/03/13 e 21/03/13
	default cAutorizaCanc := 'N'//giovani.zago coloquei o default pois estava dando erro 19/03/13 e 21/03/13
	If SUA->UA_XBLOQ == "3"
		lMsg := .F.
	Endif
	
	//CASO TENHA AUTORIZADO CANCELAMENTO
	IF( EMPTY(SUA->UA_CODCANC))
		
		IF(cAutorizaCanc == "S")
			
			cAutorizaCanc := "N"
			IF(! EMPTY(SUA->UA_XCODMCA))
				SUA->(RecLock("SUA",.F.))
				SUA->UA_CODCANC := SUA->UA_XCODMCA
				SUA->UA_CANC   := "S"
				SUA->(MsUnlock())
				
				MSGINFO("Autoriza็ใo efetuada com sucesso")
			ELSE
				MSGINFO("Nใo poderแ ser realizado uma autoriza็ใo de cancelamento. Motivo de cancelamento inexistente")
				Return
			ENDIF
		ENDIF
		
	ELSE
		MSGINFO("Cancelamento jแ autorizado")
		//Return - Excluํdo em 12/08/2015 por Joใo Victor - Nunca foi utilizado o cancelamento de Cota็ใo pela Steck
	ENDIF
	
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE64  บAutor  ณMicrosiga           บ Data ณ  02/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de motivos de cancelamento                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVE64()
	AxCadastro("PA3","Motivos de Cancelamento")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVE65  บAutor  ณMicrosiga           บ Data ณ  14/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de motivos de cancelamento                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿tot฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVE65(cAlias,nReg,nOpc)
	
	cAutorizaCanc := "S"
	
	TK271CallCenter(cAlias,nReg,2)
	
	
Return

