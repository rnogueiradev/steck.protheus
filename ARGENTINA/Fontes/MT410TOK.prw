#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT410TOK³ Autor ³ Everson Santana        ³ Data ³26/07/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria o botão na tela de Pedido de Venda para 		      ³±±
±±³          ³ realizar a impressão									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT410TOK()

	Local _lRet := .T.
	Local _nA := 0
	Local _aArea := SC6->(GetArea())

	//Liberação automatica do pedido
	If !IsInCallStack("A410Deleta") .Or. !IsInCallStack("Ma410Resid")

		_nQTDENT := 0

		nPos1 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_QTDVEN"})
		nPos3 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_QTDLIB"})
		nPos5 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_ITEM"})
		nPos6 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_PRODUTO"})
		nPos7 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_PROVENT"})

		If nPos3 > 0 .And. nPos5 > 0 .And. nPos6 > 0

			DbSelectArea("SC6")
			SC6->(DbGoTop())
			SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

			For _nA := 1 to len(aCols)

				If nPos7>0
					aCols[_nA,nPos7] := ""
				EndIf

				_nQTDENT  := 0

				If SC6->(DbSeek(xFilial("SC6")+M->C5_NUM+aCols[_nA,nPos5]))
					_nQTDENT  := SC6->C6_QTDENT
				Endif

				If AllTrim(M->C5_XLIB)=="S"
					aCols[_nA,nPos3] := aCols[_nA,nPos1]-(_nQTDENT)
				Else
					aCols[_nA,nPos3] := 0
				EndIf

			Next _nA

		EndIf

	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	If M->C5_TIPO=="N"
		If SA1->(DbSeek(xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI)))
			If AllTrim(SA1->A1_EST)=="TF" .And. Empty(M->C5_INCOTER)
				MsgAlert("Atención, cliente de tierra de fuego y campo de incoterm no llenado, verifique!")
				Return(.F.)
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)

Return(_lRet)