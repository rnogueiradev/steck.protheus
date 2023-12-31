#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/��������������������������������������������������������������������������
���Fun��o    STVALTRANSP� Autor � Giovani.Zago       � Data �  03/12/14   ���
�������������������������������������������������������������������������͹��
���Descri��o � Valida transportadora frete cif                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
���������������������������������������������������������������������������*/

User Function STVALTRANSP(_cMsgRet)

	Local lRest			  := .F.		//FR - 13/10/2021 - rest para cadastro cota��es
	Local cResponsavel    := ""			//FR - 04/04/2022 - ALTERA��O - par�metro para conter respons�vel pelo cadastro

	Private aArea         := GetArea()
	Private lRet          := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .Or. IsInCallSteck("U_STFSVE46")
	Private _cTransp      := Iif(_Lmomat ,"M->UA_TRANSP"     ,"M->C5_TRANSP")
	Private _cTpFrete     := Iif(_Lmomat ,"M->UA_TPFRETE"	 ,"M->C5_TPFRETE")

	//FR - 04/04/2022 - ALTERA��O para quando chamada vier do Rest Cota��es
	If IsInCallStack("POST")
		lRest := .T.		
	Endif	
	//FR - 04/04/2022 - rest para cadastro cota��es

	If ( Type("l410Auto") == "U" .Or. !l410Auto ) .And. lRet
		If SA1->A1_COD == "038134" .And. !(&_cTransp == "004064") //Chamado 002211

			lRet	:= .F.

			If !lRest
				MsgInfo("Aten��o, transportadora diferente de 004064 para cliente Leroy!")
			Endif 

			_cMsgRet := "Aten��o, transportadora diferente de 004064 para cliente Leroy!"

		EndIf
		If GetMv("ST_SA4VAL",,.F.)

			dbSelectArea("SA4")
			SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD

			If SA4->( dbSeek(xFilial("SA4") + &_cTransp) )

				If (SA4->A4_XVALIDA + 365) < ddatabase	// alterado de 365 para 90 conforme Ticket 20201118010750 --- Eduardo Sigamat 22.12.2020
					
					lRet := .F.
					//MsgInfo("Transportadora sem utiliza��o nos �ltimos 12 meses, atualizar cadastro, Solicite a Atualiza��o do Cadastro Junto a Thais/Aricleia...!!!!!!")
					
					//FR - 04/04/2022 - ALTERA��O - Colocar o nome Thais / Aricleia em par�metro para quando trocar a respons�vel s� alterar no par�metro
					cResponsavel := GetNewPar("STVALTRANS" , "Silvana Silva - Email: cadastro@steck.com.br")  //cadastro@steck.com.br
					//MsgInfo("Atualizar dados da Transportadora, Solicite a Atualiza��o do Cadastro Junto a Thais/Aricleia...!!!!!!")
					If !lRest
						MsgInfo("Atualizar dados da Transportadora, "+ CRLF + "Solicite a Atualiza��o do Cadastro Junto a: " + cResponsavel + " ...!!!!!!")
					Endif

					//_cMsgRet := "Atualizar dados da Transportadora, Solicite a Atualiza��o do Cadastro Junto a Thais/Aricleia...!!!!!!"
					_cMsgRet := "Atualizar dados da Transportadora, Solicite a Atualiza��o do Cadastro Junto a: " + cResponsavel + "...!!!!!!"
					//FR - 04/04/2022 - ALTERA��O - Colocar o nome Thais / Aricleia em par�metro para quando trocar a respons�vel s� alterar no par�metro

				EndIf

			EndIf
		EndIf
		If Alltrim(&_cTpFrete) == 'C' .And. !(Empty(Alltrim(&_cTransp)))
			dbSelectArea("SA4")
			SA4->( dbSetOrder(1) )	// A4_FILIAL + A4_COD

			If SA4->( dbSeek(xFilial("SA4") + &_cTransp) )

				If SA4->A4_XCIF == '2' .Or. Empty(Alltrim(SA4->A4_XCIF))

					lRet := .F.
					If !lRest		//FR - 04/04/2022 - ALTERA��O
						MsgInfo("Transportadora N�o Cadastrada Com Frete CIF...!!!!!!")
					Endif 

					_cMsgRet := "Transportadora N�o Cadastrada Com Frete CIF...!!!!!!"

				EndIf
				
			EndIf

		ElseIf Empty(Alltrim(&_cTpFrete))

			lRet := .F.
			If !lRest	//FR - 04/04/2022 - ALTERA��O
				MsgInfo("Preencha o Tipo de Frete ...!!!!!!")
			Endif 

			_cMsgRet := "Preencha o Tipo de Frete ...!!!!!!"

		EndIf
	EndIf

	Return lRet

/*���������������������������������������������������������������������������
���Fun��o    STCABTRANSP  Autor � Giovani.Zago       � Data �  07/01/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � Valida transportadora frete cif                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
���������������������������������������������������������������������������*/

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
					MsgInfo("Transportadora N�o Cadastrada Com Frete CIF...!!!!!!")
				EndIf
			EndIf
			//>> Tiket 20200619003179 - Everson Santana - 19.06.2020
			//If !Alltrim(cTransp) $ '000163#004064' .And. lRet  LG - 20230404004017
			If !Alltrim(cTransp) $ AllTrim(GetMv('ST_TRACIF',,'000163#004064')) .And. lRet
				If !__cUserId $ AllTrim(GetMv("ST_GRUCIF"))
					If !AllTrim(SC5->C5_TIPOCLI) == "X"
						lRet := .F.
						MsgInfo("Tipo de Frete CIF n�o � permitido trocar a Transportadora...!!!!!!")
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
