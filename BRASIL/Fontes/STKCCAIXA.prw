#Include "PROTHEUS.Ch"
#include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STKCCAIXA³ Autor ³ Vitor Merguizo        ³ Data ³ 24/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³ Funcao utilizada no Lancamentos Padrões 572 para carregar  ³±±
±±³          ³ a conta contábil da natureza utilizada no adiantamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ STECK			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STKCCAIXA()
	
	Local _cConta	:= "" // Conta Contábil
	Local cQuery	:= ""
	Local cAlias	:= 'xxxtemp'
	Local aArea		:= {SEU->(GetArea("SEU")), GetArea()}
	Local nA := 0
	IF !EMPTY(SEU->EU_NROADIA)
		If Select( cAlias ) > 0
			DbSelectArea( cAlias )
			(cAlias)->(DbCloseArea())
		Endif
		
		cQuery += " SELECT ED_CONTA AS CONTA"
		cQuery += " FROM "+RETSQLNAME("SEU")
		cQuery += " LEFT JOIN "+RETSQLNAME("SED")+" ON ED_FILIAL = ' ' AND ED_CODIGO = EU_X_NATUR"
		cQuery += " WHERE EU_FILIAL = '"+SEU->EU_FILIAL+"' AND EU_NUM = '"+SEU->EU_NROADIA+"' AND EU_CAIXA = '"+SEU->EU_CAIXA+"' AND "+RETSQLNAME("SEU")+".D_E_L_E_T_ = ' '"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		While !(cAlias)->(Eof())
			_cConta := (cAlias)->CONTA
			(cAlias)->(dbSkip())
		EndDo
		
		(cAlias)->(DbCloseArea())
		
	Else
		_cConta := "110101001"
	Endif
	
	For nA := 1 to Len(aArea)
		RestArea(aArea[nA])
	Next
	
Return(_cConta)
