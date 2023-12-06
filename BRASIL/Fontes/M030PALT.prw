#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "RPTDEF.CH" 
#INCLUDE 'DBTREE.CH'
#INCLUDE 'TBICONN.CH'
#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030PALT	ºAutor  ³Renato Nogueira     º Data ³  16/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este ponto de entrada realiza validação de usuário, 	      º±±
±±º          ³após a confirmação da alteração do cliente.			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ .T.   										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M030PALT()
	
	Local aArea			:= GetArea()
	Local aAreaSA1		:= GetArea("SA1")
	Local _cMsg			:= ""
	Local _lAlterado	:= .F.

	Local cCampNS		:= "A1_XNSEG"
	Local cContNS		:= SA1->A1_XNSEG
	Local cTituNS		:= ""
	Local cHistNS		:= ""

	Local cCampBF		:= "A1_XBLQFIN"
	Local cContBF		:= SA1->A1_XBLQFIN
	Local cTituBF		:= ""
	Local cHistBF		:= ""

	Local cCampBP		:= "A1_XBLOQF"
	Local cContBP		:= SA1->A1_XBLOQF
	Local cTituBP		:= ""
	Local cHistBP		:= ""

	Local cCliInc		:= SA1->A1_COD
	Local cLojInc		:= SA1->A1_LOJA

	_cMsg	+= "Usuário: "+cUserName+CHR(13) +CHR(10)
	_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
	_cMsg	+= "Campo | Anterior | Novo "+CHR(13) +CHR(10)
	
	If !(AllTrim(_cA1VEND)==AllTrim(SA1->A1_VEND))
		_cMsg		+= "A1_VEND"+" | "+_cA1VEND+" | "+SA1->A1_VEND+CHR(13) +CHR(10)
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(_cA1ATIVIDA)==AllTrim(SA1->A1_ATIVIDA))
		_cMsg		+= "A1_ATIVIDA"+" | "+_cA1ATIVIDA+" | "+SA1->A1_ATIVIDA+CHR(13) +CHR(10)
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(_cA1GRPVEN)==AllTrim(SA1->A1_GRPVEN))
		_cMsg		+= "A1_GRPVEN"+" | "+_cA1GRPVEN+" | "+SA1->A1_GRPVEN+CHR(13) +CHR(10)
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(_cA1TIPO)==AllTrim(SA1->A1_TIPO))
		_cMsg		+= "A1_TIPO"+" | "+_cA1TIPO+" | "+SA1->A1_TIPO+CHR(13) +CHR(10)
		_lAlterado	:= .T.
	EndIf
	
	If !(AllTrim(_cA1HISTOR) == AllTrim( MSMM(SA1->A1_XCODMC)))
		_cMsg		+= "A1_XHISTOR"+" | "+ Alltrim(_cA1HISTOR)+" | "+ Alltrim(SA1->A1_XCODMC)+CHR(13) +CHR(10)
		_lAlterado	:= .T.
	EndIf
	
	If _lAlterado
		SA1->(RecLock("SA1",.F.))
		SA1->A1_XHISTVE	:= SA1->A1_XHISTVE+CHR(13)+CHR(10)+_cMsg
		SA1->(MsUnlock())
	EndIf

	If _cA1NSEG <> SA1->A1_XNSEG		// Grava  historico caso seja alterada a informacao do campo A1_XNSEG - Richard - 24/04/18
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampNS))
		cTituNS := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistNS := "Usuário: " + cUserName + " - Alterado em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituNS) + " - Conteúdo Anterior / Atual: " + _cA1NSEG + " / " + Alltrim(SA1->A1_XNSEG) + CRLF + SA1->A1_XHISTOR
		RecLock("SA1",.F.)
		SA1->A1_XHISTOR := cHistNS 	
		SA1->(MsUnlock())
		U_AtuCliNS(cCliInc,cLojInc,cContNS,cHistNS,"NS")	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 24/04/18
	EndIf

	If _cA1BLQFIN <> SA1->A1_XBLQFIN		// Grava  historico caso seja alterada a informacao do campo A1_XBLQFIN - Richard - 04/05/18 - Chamado 007309 
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampBF))
		cTituBF := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistBF := "Usuário: " + cUserName + " - Alterado em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituBF) + " - Conteúdo Anterior / Atual: " + _cA1BLQFIN + " / " + Alltrim(SA1->A1_XBLQFIN) + CRLF + SA1->A1_XHISTOR
		RecLock("SA1",.F.)
		SA1->A1_XHISTOR := cHistBF
		SA1->(MsUnlock())
		U_AtuCliNS(cCliInc,cLojInc,cContBF,cHistBF,"BF")	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 04/05/18 - Chamado 007309 
	EndIf

	If _cA1BLOQF <> SA1->A1_XBLOQF		// Grava  historico caso seja alterada a informacao do campo A1_XBLOQF - Richard - 04/05/18 - Chamado 007309 
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampBP))
		cTituBP := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistBP := "Usuário: " + cUserName + " - Alterado em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituBP) + " - Conteúdo Anterior / Atual: " + _cA1BLOQF + " / " + Alltrim(SA1->A1_XBLOQF) + CRLF + SA1->A1_XHISTOR
		RecLock("SA1",.F.)
		SA1->A1_XHISTOR := cHistBP 	
		SA1->(MsUnlock())
		U_AtuCliNS(cCliInc,cLojInc,cContBP,cHistBP,"BP")	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 04/05/18 - Chamado 007309 
	EndIf

	RestArea(aArea)
	RestArea(aAreaSA1)
	
Return(.T.)
