#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"
#Define CR chr(13)+ chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCOM020     ºAutor  ³Joao Rinaldi    º Data ³  01/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para envio de e-mail na Inclusão,      º±±
±±º          ³ Alteração e 2ª via de aprovação da SC                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 20210701011385															±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STCOM020(_cName,_cDat,_cHora,_aItens,_cNumSC,_nOpc,cAPROVP,_cSolic)

	Local aArea 	  := GetArea()
	Local _cAssunto := ""
	Local cFuncSent := "STCOM020"
	Local _aMsg     := {}
	Local cMsg      := ""
	Local _cEmail   := ""
	Local _cEmlSub	:= ""
	Local _cCopia   := ""
	Local cAttach   := ""
	Local _nLin
	Local _nItens
	Local _nMsg
	Local _cOpc     := ""
	Local _aGrpAprov:= {}
	Local _aGrpSolic:= {}
	Local cNameAprov:= ""
	Local cNameSolic:= ""
	Local _cCopia2  := GETMV("ST_COM020")//ticket Nº 20190809000031 - 20/08/2019

	PswOrder(1)
	If PswSeek(cAPROVP,.T.)
		_aGrpAprov := PswRet()
		_cEmail    := _aGrpAprov[1][14]
		_cEmlSub   := UsrRetMail(Posicione("SZH",1,xFilial("SZH")+cAPROVP,"ZH_APROVS")) //Chamado 003657
		If !Empty(_cEmlSub)
			_cEmail    += ";"+_cEmlSub
		EndIf
		cNameAprov := Alltrim(_aGrpAprov[1][2])
	Endif

	PswOrder(1)
	If PswSeek(_cSolic,.T.)
		_aGrpSolic := PswRet()
		cNameSolic := Alltrim(_aGrpSolic[1][2])
		_cCopia    := _aGrpSolic[1][14]
	Endif

	//_cEmail   := "joao.rinaldi@steck.com.br"
	//_cCopia   := "joao.rinaldi@steck.com.br"

	If Empty(Alltrim(_cEmail))
		Aviso("Conta de E-mail Aprovador"; //01 - cTitulo - Título da janela
		,"O E-mail do Aprovador "+(cNameAprov)+" não está cadastrado em seu usuário do ERP Protheus."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Solicite o cadastro junto ao TI Steck."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"O E-mail não será enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
		Return()
	Endif

	If Empty(Alltrim(_cCopia))
		Aviso("Conta de E-mail Solicitante"; //01 - cTitulo - Título da janela
		,"O E-mail do Solicitante "+(cNameSolic)+" não está cadastrado em seu usuário do ERP Protheus."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Solicite o cadastro junto ao TI Steck."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"O E-mail não será enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
		//Return()
	Endif

	If (Len(_aItens)>0) .and. (AllTrim(Posicione("CTT",4,xFilial("CTT")+AllTrim(_aItens[1][7]),"CTT_CUSTO"))=="112104")//ticket Nº 20190809000031 - 20/08/2019

		_cCopia    += ";" + _cCopia2

	EndIf

	ProcRegua(Len(_aItens))
	If _nOpc == 1
		_cOpc := 'Inclusão de '
	ElseIf _nOpc == 2
		_cOpc := 'Alteração de '
	Elseif _nOpc == 3
		_cOpc := 'Exclusão de '
	Elseif _nOpc == 4
		_cOpc := '2ª Via de '
	Elseif _nOpc == 5
		_cOpc := 'Rejeição de '
	Endif

	_cAssunto := _cOpc + "Solicitação de Compra nº "+_cNumSC+" na Empresa: "+ cEmpAnt+" - Filial: "+ cFilAnt+" - Solicitante: "+_cName + " - Dia: "+_cDat+" às: "+_cHora


	Aadd( _aMsg , {Alltrim(RetTitle("C1_ITEM")),;
		Alltrim(RetTitle("C1_PRODUTO")),;
		Alltrim(RetTitle("C1_DESCRI")),;
		Alltrim(RetTitle("C1_UM")),;
		Alltrim(RetTitle("C1_QUANT")),;
		Alltrim(RetTitle("C1_MOTIVO")),;
		Alltrim(RetTitle("C1_ZDESCCC")),;
		Alltrim(RetTitle("C1_OBS")),;
		'MOT.',;
		Alltrim(RetTitle("C1_XVALOR")) })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + '</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
	//cMsg += '<TR>'
	//cMsg += '<TH><FONT COLOR=#000000 FACE= "ARIAL" SIZE=5 Align=Centered>'+_cAssunto+'</FONT></TH>'
	//cMsg += '</TR>'
	//cMsg += '</Table>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	For _nMsg := 1 to Len(_aMsg[1])
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,_nMsg] + ' </Font></B></TD>'
	Next _nMsg

	For _nLin := 1 to Len(_aItens)
		IncProc("Enviando e-mail para o Aprovador: "+cNameAprov)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#FFFFFF>'
		Else
			cMsg += '<TR BgColor=#66FF66>'
		EndIF

		For _nItens := 1 to Len(_aItens[1])
			If     ValType(_aItens[_nLin,_nItens]) = "C"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,_nItens]             + ' </Font></TD>'
			ElseIf ValType(_aItens[_nLin,_nItens]) = "N"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aItens[_nLin,_nItens]) + ' </Font></TD>'
			ElseIf ValType(_aItens[_nLin,_nItens]) = "D"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + DTOC(_aItens[_nLin,_nItens])       + ' </Font></TD>'
			Endif
		Next _nItens

		cMsg += '</TR>'
	Next _nLin
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nOpc = 1 .Or. _nOpc = 2 .Or. _nOpc = 4
		If cAPROVP $ GetMv("ST_20APRSC",,'000645')

			Dbselectarea("SC1")
			SC1->(Dbsetorder(1))
			If SC1->(dbseek(xfilial("SC1")+_cNumSC))
				While SC1->(!EOF()) .And. _cNumSC = SC1->C1_NUM .And. SC1->C1_FILIAL = xfilial("SC1")

					Reclock("SC1",.F.)
					SC1->C1_ZSTATUS:= '3'
					SC1->C1_ZDTAPRO := Ddatabase
					SC1->C1_ZHRAPRO := Time()
					SC1->C1_ZLOG    := 'Aprovado automaticamente '+dtoc(ddatabase) +CR+ Alltrim(SC1->C1_XLOGAP)
					SC1->C1_ZMARKBR :='lQ'
					SC1->(MsUnlock())

					SC1->(dBSkip())
				End
			EndIf



			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">Solicitação aprovada automaticamente pelo sistema, de acordo pelo ByPass de compras.</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'





		EndIf
	EndIf
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

	If !(  U_STMAILTES(_cEmail, _cCopia , _cAssunto, cMsg,cAttach) )
		Aviso("E-mail não enviado"; //01 - cTitulo - Título da janela
		,"Favor verificar se os e-mails abaixo são válidos."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"E-mail Aprovador: "+ _cEmail+;
			CHR(10)+CHR(13)+;
			"E-mail Solicitante: "+_cCopia+;
			CHR(10)+CHR(13)+;
			"O E-mail não será enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	EndIf

	RestArea(aArea)

Return()
