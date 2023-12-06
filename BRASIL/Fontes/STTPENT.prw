#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTPENT   ºAutor  ³Renato Nogueira     º Data ³  16/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validar tipo de entrega									  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTPENT(cTransp,cTipo)
	Local aArea     := GetArea()
	Local lRet		:= .T.
	Local cTipoEnt	:= ""
	Local lNovaR    := GETMV("STREGRAFT",.F.,.T.) .AND. (cEmpAnt=="01")             // Ticket: 20210811015405 - 24/08/2021
	Default cTransp := ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If cTipo=="P"
			cTipoEnt	:= M->C5_XTIPO
			IF lNovaR .and. (cEmpAnt=="01")
			   M->C5_TPFRETE := IF(cTipoEnt=='1',"F","C")
			ENDIF 
		ElseIf cTipo=="O"
			cTipoEnt	:= M->UA_XTIPOPV
			IF lNovaR .and. (cEmpAnt=="01")
			   M->UA_TPFRETE := IF(cTipoEnt=='1',"F","C")
			ENDIF 
		EndIf
		
		if !Empty(cTransp)
			DbSelectArea("SA4")
			DbSetOrder(1)
			DbSeek(xFilial("SA4")+cTransp)
			
			If SA4->(!Eof()) .And. A4_XSTEENT=="N" .And. cTipoEnt<>"1"
				
				MsgAlert("Atenção, o tipo de entrega nesse caso deve ser retira, qualquer problema contate o departamento de Transportes")
				lRet	:= .F.
				
			EndIf
		endif 

	EndIf

	RestArea(aArea)
	
Return(lRet)
