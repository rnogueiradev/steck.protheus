#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCCPRD  ºAutor  ³Microsiga           º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para carregar a conta específica do produto         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCCGAT(cCC,cTab)

Local cRet := ""
Local aArea := GetArea()
Local nPosPrd := IIF(cTab$"SC7/SD1/SC1",Ascan(aHeader,{|x| AllTrim(x[2]) == IIF(cTab="SC1","C1_PRODUTO",IIF(cTab="SC7","C7_PRODUTO","D1_COD")) }),0)

If nPosPrd > 0
	If !Empty(aCols[n][nPosPrd])
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + aCols[n][nPosPrd]))
	EndIf
EndIf

cRet := SB1->B1_CONTA

If !Empty(cCC)
	dbSelectArea("CTT")
	CTT->(dbSetOrder(1))
	CTT->(dbSeek(xFilial("CTT") + cCC))
	If CTT->CTT_REFCTA = "2" .And. !Empty(SB1->B1_XCONTA1) //Vendas
		cRet := SB1->B1_XCONTA1
	ElseIf CTT->CTT_REFCTA = "5" .And. !Empty(SB1->B1_XCONTA3) //Ativo
		cRet := SB1->B1_XCONTA3
	ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SB1->B1_XCONTA2) //Custo
		cRet := SB1->B1_XCONTA2
	EndIf
EndIf

RestArea(aArea)

Return(cRet)
