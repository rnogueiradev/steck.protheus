#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ STCOM019     ºAutor  ³Joao Rinaldi    º Data ³  14/12/2015 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Função desenvolvida para analisar os itens e seu respectivoº±±
±±º          ³ aprovador da Solicitação de Compras para envio por e-mail  º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±± 20210701011385															±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STCOM019(_cNumSC,_nOpc,_cSolic)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cPerg      := "STCOM019"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias1    := cAliasLif
	Local cQuery1    := ' '
	//Local lQuery     := .T.
	Local _aAprov    := {}
	Local _aItens    := {}
	Local _nI
	
	If _nOpc == 4
		If !(_cSolic == __cUserId)
			Aviso("Envio de E-Mail"; //01 - cTitulo - Título da janela
			,"Você não é o solicitante dessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			Return
		Endif
	Endif
	
	cQuery1 := " SELECT
	cQuery1 += " DISTINCT
	cQuery1 += " C1_ZAPROV
	
	cQuery1 += " FROM "+RetSqlName("SC1")+" SC1
	
	cQuery1 += " WHERE SC1.D_E_L_E_T_ = ' '
	cQuery1 += " AND C1_NUM     = '"+_cNumSC+"'
	cQuery1 += " AND C1_FILIAL  = '"+xFilial("SC1")+"'
	cQuery1 += " AND C1_ZSTATUS IN ('1','2','3')" // ACRESCENTADO O STATUS 3 PARA O CHAMADO 005827
	
	cQuery1 += " ORDER BY C1_ZAPROV
	
	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)
	
	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While 	(cAlias1)->(!Eof())
			aAdd(_aAprov,{ ((cAlias1)->C1_ZAPROV) })
			(cAlias1)->(dbskip())
		End
		(cAlias1)->(dbCloseArea())
	Endif
	
	If Len(_aAprov) > 0
		For _nI := 1 To Len(_aAprov)
			_aItens := STQUERY2(_aAprov[_nI][1],_cNumSC)
			Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,_aAprov[_nI][1],_cSolic),"Enviando E-mail." })
		Next _nI
	Else
		if !IsInCallStack("U_MATA712") .and. !IsInCallStack("U_JOBM712")   
			Aviso("Envio de E-Mail"; //01 - cTitulo - Título da janela
			,"Não existe Aprovador vinculado a Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
		Endif
	Endif
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ STQUERY2     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ A função STQUERY1 é acionada pela função VldTOK            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±ºRotina    ³ MATA110.PRX                                                º±±
±±ºNome      ³ Solicitação de Compra                                      º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STQUERY2(cAPROVP,_cNumSC)
	
	Local cPerg      := "STQUERY2"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias2    := cAliasLif
	Local cQuery2    := ""
	Local _aItens2   := {}
	
	cQuery2 := "  SELECT
	cQuery2 += "  C1_ITEM
	cQuery2 += " ,C1_PRODUTO
	cQuery2 += " ,C1_DESCRI
	cQuery2 += " ,C1_UM
	cQuery2 += " ,C1_QUANT
	cQuery2 += " ,C1_MOTIVO
	cQuery2 += " ,C1_CC
	cQuery2 += " ,C1_OBS
	cQuery2 += " ,C1_XVALOR
	
	cQuery2 += " FROM "+RetSqlName("SC1")+" SC1
	
	cQuery2 += " WHERE SC1.D_E_L_E_T_ = ' '
	cQuery2 += " AND C1_NUM     = '"+_cNumSC+"'
	cQuery2 += " AND C1_FILIAL  = '"+xFilial("SC1")+"'
	cQuery2 += " AND C1_ZAPROV  = '"+cAPROVP+"'
	cQuery2 += " AND C1_ZSTATUS IN ('1','2','3')" // ACRESCENTADO O STATUS 3 PARA O CHAMADO 005827
	
	cQuery2 += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM
	
	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)
	
	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0
		ProcRegua(RecCount())
		While 	(cAlias2)->(!Eof())
			aAdd(_aItens2,{ ((cAlias2)->C1_ITEM),;
				((cAlias2)->C1_PRODUTO),;
				((cAlias2)->C1_DESCRI),;
				((cAlias2)->C1_UM),;
				((cAlias2)->C1_QUANT),;
				((cAlias2)->C1_MOTIVO),;
				Posicione("CTT",1,xFilial("CTT")+((cAlias2)->C1_CC),"CTT_DESC01"),;
				((cAlias2)->C1_OBS),;
				' ',;
				((cAlias2)->C1_XVALOR)})
			(cAlias2)->(dbskip())
		End
		(cAlias2)->(dbCloseArea())
	Endif
	
Return (_aItens2)
