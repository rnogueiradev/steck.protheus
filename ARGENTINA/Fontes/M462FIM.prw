/*/{Protheus.doc} M468MKB

Filtra a TES 553 que não gera financeiro

@type function
@author Everson Santana
@since 18/04/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190412000112 ,

/*/

User Function M462FIM()

	Local _aArea := GetArea()
	Local _aRet  := PARAMIXB[01]
	Local _n 	 := 0
	Local cTesMkt	:= GetMV("ST_TESMKT",,"553#552")

	For _n := 1 to len(_aRet)

		DbSelectArea("SD2")
		DbSetOrder(3)
		DbGotop()
		DbSeek(xFilial("SD2")+_aRet[_n][2])

		If SD2->D2_TES $ cTesMkt

		SD2->(RecLock("SD2",.F.))

		SD2->D2_XMKT := "S"

		SD2->(MsUnlock())

		EndIF

	Next

	RestArea(_aArea)

Return