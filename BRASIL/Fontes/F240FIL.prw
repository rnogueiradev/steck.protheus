#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240FIL   บAutor  ณVitor Merguizo      บData  ณ03/03/16	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE para filtrar tํtulos na sele็ใo do arquivo cnab.		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSteck                                             		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F240FIL()

	Local aArea := GetArea()
	Local cFiltro := ""
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprova็ใo de Titulos

	If cModPgto = "13"
		cFiltro := " E2_CODBAR <> '"+Space(48)+"' "
	ElseIf cModPgto = "30"
		cFiltro := " SUBSTR(E2_CODBAR,1,3) = '"+cPort240+"' "
	ElseIf cModPgto = "31"
		cFiltro := " SUBSTR(E2_CODBAR,1,3) <> '"+cPort240+"' .AND. E2_CODBAR <> '"+Space(48)+"' "
	ElseIf cModPgto $ "01|02|03|04|05|08|10|41|43"
		cFiltro := " E2_CODBAR = '"+Space(48)+"' "
	EndIf

	// Ticket 20191205000010 - Zeca - 19/08/2020
	// Acrescentar no filtro o modelo de pagamento do titulo
	
	If Empty(cFiltro)
		cFiltro += " ( E2_FORMPAG ='" + cModPgto + "' .OR. E2_FORMPAG = '  ')"
	Else
		cFiltro += " .AND. ( E2_FORMPAG ='" + cModPgto + "' .OR. E2_FORMPAG = '  ')"
	EndIf

	//>> //>>Chamado 006559 - Everson Santana - 04/12/18
	If _FinAprov

		If Empty(cFiltro)
			cFiltro := " Empty(E2_XBLQ) "
		Else
			cFiltro += " .AND. Empty(E2_XBLQ) "
		EndIf

	EndIf
	//<<

	RestArea(aArea)

Return cFiltro