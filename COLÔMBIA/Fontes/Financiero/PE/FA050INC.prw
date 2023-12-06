#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC    ºAutor  ³Jorge Mendoza       ºFecha ³  25/01/07 º±±
±±º                       ºValid  ³Karlo Zumaya        ºFecha ³  11/03/09 º±±
±±º                       ºModif  ³Wheelock Orozco     ºFecha ³  06/07/09 º±±
±±º                       ºValid  ³Karlo Zumaya        ºFecha ³  10/07/09 º±±
±±º                       ºModif  ³Eloisa Jimenez      ºFecha ³  12/06/14 º±±
±±º                       ºModif  ³EDUAR ANDIA         ºFecha ³  19/07/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Reporte para impresión de comprobantes contables.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()


	Local lRet := .T.

	If FunName()=="FINA677" .and. Inclui
		//_cNumTit := ProxTitulo("SE2","REE")
		E2_NUM := FLF->FLF_PRESTA 

		DbSelectArea("FO7")
		DbSetOrder(1)
		If DbSeek(xFilial("FO7")+FLF->FLF_TIPO+FLF->FLF_PRESTA )
		       FO7->FO7_TITULO := FLF->FLF_PRESTA 
		Endif
   Endif

return(lRet)
