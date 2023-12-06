#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110FIL     ºAutor  ³Joao Rinaldi    º Data ³  16/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada utilizado Antes da apresentaçao da        º±±
±±º          ³ interface da Mbrowse no inicio da rotina, possibilita      º±±
±±º          ³ compor um string contendo uma expressão de Filtro          º±±
±±º          ³ da tabela SC1 para ser passada para MBrowse.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ MATA110.PRX                                                º±±
±±ºNome      ³ Solicitação de Compra                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110FIL()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SAI->(GetArea())
	Local aArea4    := SY1->(GetArea())
	Local cFiltro   := ''
	Local _cFilTi   := ''
	Local _lComp    := .F.
	Local _lSolic   := .F.
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If DbSeek(xFilial("SY1")+__cUserId)
		_lComp := .T.
	Endif
	
	If !(_lComp)
		DbSelectArea("SAI")
		SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
		SAI->(DbGoTop())
		If DbSeek(xFilial("SAI")+__cUserId)
			_lSolic := .T.
		Endif
	Endif
	
	If _lComp
		cFiltro   := ''
	ElseIf _lSolic
	
		If __cUserId $ "000172" //Chamado 007399 - 000172 - willian.borges
		//000597 - rafael.reis
		//000342 - felipe.souza
		//000880 - bruno.saimon
		//001053 - paulo.sousa
		//001057 - jonas.silva              
		_cFilTi := "000597#000342#000880#001053#001057#000172"	
		cFiltro := "       C1_USER   $ '" + _cFilTi      + "'"
		cFiltro += " .AND. C1_FILIAL == '" + xFilial("SC1") + "'"
		
		
		Else
		
		cFiltro := "       C1_USER   == '" + __cUserId      + "'"
		cFiltro += " .AND. C1_FILIAL == '" + xFilial("SC1") + "'"
		
		EndIf
		

	Else
		cFiltro := "       C1_USER   == '" + "ABC"          + "'"
		cFiltro += " .AND. C1_FILIAL == '" + "99"           + "'"
	Endif
	
	
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return (cFiltro)
