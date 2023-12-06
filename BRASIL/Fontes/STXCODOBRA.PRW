#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STXCODOBRA       | Autor | GIOVANI.ZAGO             | Data | 05/03/2013  |
|=====================================================================================|
|Descrição |  STXCODOBRA                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STXCODOBRA                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STXCODOBRA()
*-----------------------------*
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380")  .or. IsInCallSteck("U_STFSVE46")
	Private _cLoja        := IIF(_Lmomat ,"M->UA_LOJA"   ,"M->C5_LOJACLI")
	Private _cCliente     := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
   
//Giovani Zago 13/01/14 Alçada Comercial
	If "STZZI" $ FunName()
		Return(.F.)//
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+(&_cCliente)+(&_cLoja)))
			If Alltrim(SA1->A1_GRPVEN) <> 'EX' .And. Substr( Alltrim(Upper(SA1->A1_GRPVEN)),1,1) = 'E'
				lRet := .T.
			EndIf
		EndIf
	EndIf

	Restarea(aArea)
Return(lRet)



/*====================================================================================\
|Programa  | STXENDENTRE      | Autor | GIOVANI.ZAGO             | Data | 05/03/2013  |
|=====================================================================================|
|Descrição |  STXENDENTRE                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STXENDENTRE                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STXENDENTRE()
*-----------------------------*
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _cLoja        := IIF(_Lmomat ,"M->UA_LOJA"   ,"M->C5_LOJACLI")
	Private _cCliente     := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private	_oDlgDefault
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+&_cCliente+&_cLoja))
			If _Lmomat
				If Alltrim(SA1->A1_GRPVEN) = 'EX' .Or. Substr( Alltrim(Upper(SA1->A1_GRPVEN)),1,1) <> 'E'
					M->UA_ESTE    := SA1->A1_ESTE
					M->UA_ENDENT  := SA1->A1_ENDENT
					M->UA_BAIRROE := SA1->A1_BAIRROE
					M->UA_CEPE    := SA1->A1_CEPE
					M->UA_MUNE    := SA1->A1_MUNE
					M->UA_ZCODOBR := '      '
					M->UA_XCODMUN := SA1->A1_CODMUNE
				Else
					If Empty(Alltrim(M->UA_ZCODOBR))
						M->UA_ENDENT  := space(TamSx3("ZZ1_END")[1])  					// Endereço
						M->UA_BAIRROE := space(TamSx3("ZZ1_BAIRRO")[1])  				    // Bairro
						M->UA_MUNE    := space(TamSx3("ZZ1_MUN")[1])  					// CIdade
						M->UA_CEPE    := space(TamSx3("ZZ1_CEP")[1])  					// CEP
						M->UA_ESTE    := space(TamSx3("ZZ1_UF")[1]) 				// UF
						M->UA_XCODMUN := SA1->A1_CODMUNE
					Else
						DbSelectArea("ZZ1")
						ZZ1->(DbSetOrder(1))
						If	ZZ1->(DbSeek(xFilial("ZZ1") + M->UA_ZCODOBR)  )
							M->UA_ENDENT  := ZZ1->ZZ1_END					// Endereço
							M->UA_BAIRROE := ZZ1->ZZ1_BAIRRO				    // Bairro
							M->UA_MUNE    := ZZ1->ZZ1_MUN					// CIdade
							M->UA_CEPE    := ZZ1->ZZ1_CEP					// CEP
							M->UA_ESTE    := ZZ1->ZZ1_UF					// UF
						EndIf
					EndIf
				EndIf
			Else
				If Alltrim(SA1->A1_GRPVEN) = 'EX' .Or. Substr( Alltrim(Upper(SA1->A1_GRPVEN)),1,1) <> 'E'
					M->C5_ZESTE    := SA1->A1_ESTE
					M->C5_ZENDENT  := SA1->A1_ENDENT
					M->C5_ZBAIRRE  := SA1->A1_BAIRROE
					M->C5_ZCEPE    := SA1->A1_CEPE
					M->C5_ZMUNE    := SA1->A1_MUNE
					M->C5_ZCODOBR  := '      '
					M->C5_XCODMUN  := SA1->A1_CODMUNE
				Else
					If Empty(Alltrim(M->C5_ZCODOBR))
						M->C5_ZENDENT  := space(TamSx3("ZZ1_END")[1])  					// Endereço
						M->C5_ZBAIRRE  := space(TamSx3("ZZ1_BAIRRO")[1])  				    // Bairro
						M->C5_ZMUNE    := space(TamSx3("ZZ1_MUN")[1])  					// CIdade
						M->C5_ZCEPE    := space(TamSx3("ZZ1_CEP")[1])  					// CEP
						M->C5_ZESTE    := space(TamSx3("ZZ1_UF")[1]) 				// UF
					
					Else
						DbSelectArea("ZZ1")
						ZZ1->(DbSetOrder(1))
						If	ZZ1->(DbSeek(xFilial("ZZ1") + M->C5_ZCODOBR)  )
							M->C5_ZENDENT  := ZZ1->ZZ1_END					// Endereço
							M->C5_ZBAIRRE  := ZZ1->ZZ1_BAIRRO				    // Bairro
							M->C5_ZMUNE    := ZZ1->ZZ1_MUN					// CIdade
							M->C5_ZCEPE    := ZZ1->ZZ1_CEP					// CEP
							M->C5_ZESTE    := ZZ1->ZZ1_UF					// UF
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	
		If !(_Lmomat)
		
		                                                       
		//_oDlgDefault := GetWndDefault()                      //Jefferson Carlos retirado dia 25/11/2013 
		//	aEval(_oDlgDefault:aControls,{|x| x:Refresh()})    //jefferson Carlos retirado dia 25/11/2013 
		
		//	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//		oGetDad:oBrowse:Refresh()
		//	EndIf
			If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
				If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
					oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
					oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
				EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
			EndIf                                                  //Inserido Jefferson Carlos dia 25/11/2013
		
		
		
		Endif
	
	EndIf

	Restarea(aArea)
Return(lRet)


