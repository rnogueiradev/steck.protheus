#include 'Protheus.ch'
#include 'RwMake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKRA	ºAutor  ³Renato Nogueira     º Data ³  14/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida transportadora  						  		   	º±±
±±																		º±±	    					    		   	 				        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKTRA()

	Local aArea	:= GetArea()
	Local _lRet	:= .T.

	_lRet	:= U_STCHKTRP("O")

	RestArea(aArea)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCHKTRP	ºAutor  ³Renato Nogueira     º Data ³  14/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida transportadora  						  		   	º±±
±±																		º±±	    					    		   	 				        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Tipo                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Lógico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCHKTRP(_cTipo)

	Local _aArea	:= GetArea()
	Local _lRet		:= .T.

	DbSelectArea("CC2")
	CC2->(DbSetOrder(1))
	CC2->(DbGoTop())

	Do Case
	Case _cTipo=="O"
		
		If !Empty(M->UA_XCODMUN)
		
			CC2->(DbSeek(xFilial("CC2")+M->UA_ESTE+M->UA_XCODMUN))
			
			If AllTrim(M->UA_TPFRETE)=="C" .And. AllTrim(M->UA_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516 
				_lRet	:= .F.
				MsgAlert("Atenção, para essa situação a transportadora deve ser BrasPress")
			EndIf
			
		Else

			CC2->(DbSeek(xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN)))

			If AllTrim(M->UA_TPFRETE)=="C" .And. AllTrim(M->UA_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Atenção, para essa situação a transportadora deve ser BrasPress")
			EndIf

		EndIf
		

	Case _cTipo=="P"
		
		If !Empty(M->C5_XCODMUN)

			CC2->(DbSeek(xFilial("CC2")+M->C5_ZESTE+M->C5_XCODMUN))

			If AllTrim(M->C5_TPFRETE)=="C" .And. AllTrim(M->C5_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Atenção, para essa situação a transportadora deve ser Braspress")
			EndIf

		Else

			CC2->(DbSeek(xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN)))

			If AllTrim(M->C5_TPFRETE)=="C" .And. AllTrim(M->C5_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Atenção, para essa situação a transportadora deve ser Braspress")
			EndIf

		EndIf
		
	EndCase

	RestArea(_aArea)

Return(_lRet)
