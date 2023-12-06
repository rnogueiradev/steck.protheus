#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    STVALTRANSPº Autor ³ Giovani.Zago       º Data ³  03/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida transportadora frete cif                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STVALTRANSP(_cMsgRet)

	Local lRest			  := .F.		//FR - 13/10/2021 - rest para cadastro cotações
	Local cResponsavel    := ""			//FR - 04/04/2022 - ALTERAÇÃO - parâmetro para conter responsável pelo cadastro

	Private aArea         := GetArea()
	Private lRet          := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .Or. IsInCallSteck("U_STFSVE46")
	Private _cTransp      := Iif(_Lmomat ,"M->UA_TRANSP"     ,"M->C5_TRANSP")
	Private _cTpFrete     := Iif(_Lmomat ,"M->UA_TPFRETE"	 ,"M->C5_TPFRETE")

	//FR - 04/04/2022 - ALTERAÇÃO para quando chamada vier do Rest Cotações
	If IsInCallStack("POST")
		lRest := .T.		
	Endif	
	//FR - 04/04/2022 - rest para cadastro cotações

	If ( Type("l410Auto") == "U" .Or. !l410Auto ) .And. lRet
		If SA1->A1_COD == "038134" .And. !(&_cTransp == "004064") //Chamado 002211

			lRet	:= .F.

			If !lRest
				MsgInfo("Atenção, transportadora diferente de 004064 para cliente Leroy!")
			Endif 

			_cMsgRet := "Atenção, transportadora diferente de 004064 para cliente Leroy!"

		EndIf
		If GetMv("ST_SA4VAL",,.F.)

			dbSelectArea("SA4")
			SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD

			If SA4->( dbSeek(xFilial("SA4") + &_cTransp) )

				If (SA4->A4_XVALIDA + 365) < ddatabase	// alterado de 365 para 90 conforme Ticket 20201118010750 --- Eduardo Sigamat 22.12.2020
					
					lRet := .F.
					//MsgInfo("Transportadora sem utilização nos últimos 12 meses, atualizar cadastro, Solicite a Atualização do Cadastro Junto a Thais/Aricleia...!!!!!!")
					
					//FR - 04/04/2022 - ALTERAÇÃO - Colocar o nome Thais / Aricleia em parâmetro para quando trocar a responsável só alterar no parâmetro
					cResponsavel := GetNewPar("STVALTRANS" , "Silvana Silva - Email: cadastro@steck.com.br")  //cadastro@steck.com.br
					//MsgInfo("Atualizar dados da Transportadora, Solicite a Atualização do Cadastro Junto a Thais/Aricleia...!!!!!!")
					If !lRest
						MsgInfo("Atualizar dados da Transportadora, "+ CRLF + "Solicite a Atualização do Cadastro Junto a: " + cResponsavel + " ...!!!!!!")
					Endif

					//_cMsgRet := "Atualizar dados da Transportadora, Solicite a Atualização do Cadastro Junto a Thais/Aricleia...!!!!!!"
					_cMsgRet := "Atualizar dados da Transportadora, Solicite a Atualização do Cadastro Junto a: " + cResponsavel + "...!!!!!!"
					//FR - 04/04/2022 - ALTERAÇÃO - Colocar o nome Thais / Aricleia em parâmetro para quando trocar a responsável só alterar no parâmetro

				EndIf

			EndIf
		EndIf
		If Alltrim(&_cTpFrete) == 'C' .And. !(Empty(Alltrim(&_cTransp)))
			dbSelectArea("SA4")
			SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD

			If SA4->( dbSeek(xFilial("SA4") + &_cTransp) )

				If SA4->A4_XCIF == '2' .Or. Empty(Alltrim(SA4->A4_XCIF))

					lRet := .F.
					If !lRest		//FR - 04/04/2022 - ALTERAÇÃO
						MsgInfo("Transportadora Não Cadastrada Com Frete CIF...!!!!!!")
					Endif 

					_cMsgRet := "Transportadora Não Cadastrada Com Frete CIF...!!!!!!"

				EndIf
				
			EndIf

		ElseIf Empty(Alltrim(&_cTpFrete))

			lRet := .F.
			If !lRest	//FR - 04/04/2022 - ALTERAÇÃO
				MsgInfo("Preencha o Tipo de Frete ...!!!!!!")
			Endif 

			_cMsgRet := "Preencha o Tipo de Frete ...!!!!!!"

		EndIf
	EndIf

	Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    STCABTRANSP  Autor ³ Giovani.Zago       º Data ³  07/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida transportadora frete cif                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STCABTRANSP(cTransp,cTpFrete)

	Private aArea	:= GetArea()
	Private lRet	:= .T.

	If ( Type("l410Auto") == "U" .Or. !l410Auto ) .And. lRet
		If Substr(Alltrim(cTpFrete),1,1) == 'C' .And. !(Empty(Alltrim(cTransp)))
			dbSelectArea("SA4")
			SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD
			If SA4->( dbSeek(xFilial("SA4") + cTransp) )
				If SA4->A4_XCIF == '2' .Or. Empty(Alltrim(SA4->A4_XCIF))
					lRet := .F.
					MsgInfo("Transportadora Não Cadastrada Com Frete CIF...!!!!!!")
				EndIf
			EndIf
			//>> Tiket 20200619003179 - Everson Santana - 19.06.2020
			//If !Alltrim(cTransp) $ '000163#004064' .And. lRet  LG - 20230404004017
			If !Alltrim(cTransp) $ AllTrim(GetMv('ST_TRACIF',,'000163#004064')) .And. lRet
				If !__cUserId $ AllTrim(GetMv("ST_GRUCIF"))
					If !AllTrim(SC5->C5_TIPOCLI) == "X"
						lRet := .F.
						MsgInfo("Tipo de Frete CIF não é permitido trocar a Transportadora...!!!!!!")
					EndIf
				EndIf
			EndIf
			//<< Tiket 20200619003179 - Everson Santana - 19.06.2020
		ElseIf Empty(Alltrim(cTpFrete))
			lRet := .F.
			MsgInfo("Preencha o Tipo de Frete ...!!!!!!")
		EndIf
	EndIf

Return lRet
