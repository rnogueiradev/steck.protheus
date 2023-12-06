#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STVLDCLI ³Autor  ³ Renato Nogueira       ³ Data ³29.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Avalia a colocacao do cliente         				       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDCLI(_cCliente,_cLoja,_cTipo)

	Local aArea     := GetArea()
	Local _lRet		:= .T.
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ''
	Local cMsg	    := ""
	Local _aAttach  := {}
	Local _cCaminho := ''

	Local cPerg 		:= "STVLDCLI"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAlias20   	:= cPerg+cHora+ cMinutos+cSegundos
	Local cAlias21   	:= GetNextAlias()

	Local cQuery    := ' '
	Local cQuery1   := ' '
	Local _nDifDate  := 0
	Default _cTipo	:= "N"

	If Empty(_cLoja)
		_cLoja := "01"
	EndIf

	If _cTipo <> "B" //Chamado 009121 - Everson Santana - 20.02.2019 - Esta validação é apenas para nao beneficiamento.

		If   ( Type("l410Auto") == "U" .OR. !l410Auto )
			DbSelectArea("SA1")
			DbSetOrder(1)
			dbGoTop()
			DbSeek(xFilial("SA1")+_cCliente+_cLoja)
			If !(__cUserId $ GetMv("ST_SUPCORV",,"000380#000088#000391#000366#000378#000641"))
				DbSelectArea('SA3')
				SA3->(DbSetOrder(7))
				If SA3->(dbSeek(xFilial('SA3')+__cUserId))
					If SA1->A1_XMATRIZ <> ' ' .And. SA3->A3_COD <> SA1->A1_XMATRIZ .And. SA3->A3_COD <> SA1->A1_VEND
						MsgInfo("Cliente Bloqueado...Procure um Supervisor de Vendas.....!!!!!")
						_lRet:= .F.
					EndIf
				EndIf
			EndIf

			//>>Ticket 20201105010045 - Everson Santana - 10.11.2020

			cQuery1 := " SELECT MAX(C5_EMISSAO) C5_EMISSAO FROM "+RetSqlName("SC5")
			cQuery1 += "  WHERE C5_CLIENTE = '"+_cCliente+"'
			cQuery1 += "   AND C5_LOJACLI = '"+_cLoja+"'
			cQuery1 += " AND D_E_L_E_T_ = ' '"

			If Select(cAlias21) > 0
				(cAlias21)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias21)

			dbSelectArea(cAlias21)
			(cAlias21)->(dbgotop())
			If  Select(cAlias21) > 0

			_nDifDate := DateDiffMonth( Stod((cAlias21)->C5_EMISSAO) , dDataBase )

			EndIf

			//<<Ticket 20201105010045

			If GetMv("ST_VDCLI",,.F.)

				DbSelectArea("SA1")
				DbSetOrder(1)
				dbGoTop()
				DbSeek(xFilial("SA1")+_cCliente+_cLoja)

				If ( Type("l410Auto") == "U" .OR. !l410Auto )

					If SA1->(!Eof()) .And. !_cTipo$"D#B"
						If (AllTrim(SA1->A1_ATIVIDA)$"CA#99") .Or. (AllTrim(SA1->A1_GRPVEN)$"CA#99") 
						   _lRet := (Left(SA1->A1_CGC,8) == Left(SM0->M0_CGC,8))     // Valdemir Rabelo 20/01/2021 Ticket: 20210118000931						      
						   if !_lRet
							 MsgAlert("Cliente não pode ser utilizado, código de atividade ou grupo de vendas preenchido com CA ou 99")
						   endif 
						EndIf
					EndIf

					If SA1->(!Eof()) .And. !_cTipo$"D#B"
						//If AllTrim((cAlias20)->A1_ATIVIDA)$"I1#I2#I3#I4$I5" .And. (cAlias20)->A1_XREVISA<>"S" //Renato Nogueira - 26/11/2013 - Chamado 000054
						If  (cAlias20)->A1_XREVISA <> "S" .and. _nDifDate > 6 //giovani zago 06/11/2020

							If !IsInCallStack("U_STFSVE47")

								_lRet	:= .F.
								MsgAlert("Cliente não pode ser utilizado,  não está revisado!")
								_cEmail	  := "Carla.lodetti@steck.com.br;cadastro@steck.com.br"
								_cAssunto := 'Cliente - '+(cAlias20)->A1_COD+(cAlias20)->A1_LOJA+' - sem revisão feita'
								cMsg	  := "Cliente sem revisão feita"

								U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

							EndIf

						EndIf
					EndIf

					IF SUBSTR(SA3->A3_COD,1,1) $ "E/R"
						If  SA1->A1_TIPO <> 'X'
							If  SA1->A1_VEND <> SA3->A3_COD

								_lRet := .F.
								Alert("Este cliente não pertence a sua carteira!","Atenção" )

							EndIF
						EndIF
					ENDIF



				EndIf

			Else

				cQuery := " SELECT
				cQuery += "   *
				cQuery += "   FROM "+RetSqlName("SA1")+" SA1
				cQuery += "   WHERE SA1.D_E_L_E_T_  = ' '
				cQuery += "   AND A1_COD = '"+_cCliente+"' AND A1_LOJA = '"+_cLoja+"'

				If Select(cAlias20) > 0
					(cAlias20)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias20)

				dbSelectArea(cAlias20)
				(cAlias20)->(dbgotop())
				If  Select(cAlias20) > 0

					If (cAlias20)->(!Eof()) .And. !_cTipo$"D#B"
						If AllTrim((cAlias20)->A1_ATIVIDA)$"CA#99" .Or. AllTrim((cAlias20)->A1_GRPVEN)$"CA#99"
						   _lRet := (Left((cAlias20)->A1_CGC,8) == Left(SM0->M0_CGC,8))     // Valdemir Rabelo 20/01/2021 Ticket: 20210118000931						      
						   if !_lRet
							MsgAlert("Cliente não pode ser utilizado, código de atividade ou grupo de vendas preenchido com CA ou 99")
						   endif 
						EndIf
					EndIf

					If (cAlias20)->(!Eof()) .And. !_cTipo$"D#B"
						//If AllTrim((cAlias20)->A1_ATIVIDA)$"I1#I2#I3#I4$I5" .And. (cAlias20)->A1_XREVISA<>"S" //Renato Nogueira - 26/11/2013 - Chamado 000054
						If  (cAlias20)->A1_XREVISA <> "S" .and. _nDifDate > 6 //giovani zago 06/11/2020

							If !IsInCallStack("U_STFSVE47")

								_lRet	:= .F.
								MsgAlert("Cliente não pode ser utilizado,  não está revisado!")
								_cEmail	  := "Carla.lodetti@steck.com.br;cadastro@steck.com.br"
								_cAssunto := 'Cliente - '+(cAlias20)->A1_COD+(cAlias20)->A1_LOJA+' - sem revisão feita'
								cMsg	  := "Cliente sem revisão feita"

								U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

							EndIf
						EndIf
					EndIf

					IF SUBSTR(SA3->A3_COD,1,1) $ "E/R"
						If  (cAlias20)->A1_TIPO <> 'X'
							If  (cAlias20)->A1_VEND <> SA3->A3_COD

								_lRet := .F.
								Alert("Este cliente não pertence a sua carteira!","Atenção" )

							EndIF

						ENDIF

					EndIf
				EndIf
				
				If Select(cAlias20) > 0
					(cAlias20)->(dbCloseArea())
				EndIf
			EndIf
		EndIf
	Endif

	RestArea(aArea)

Return(_lRet)

User Function CLEARSA1()
	Public _cXCodVen361 := ' '

	If GetMv("ST_CLEARS",,.T.)
		DbSelectArea('SA1')
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cUserId))
			If !(__cUserId $ Getmv("ST_UCLEAR",,"000000/000645")+"/000000/000645")
				If SA3->A3_TPVEND <> 'I'
					_cXCodVen361:= SA3->A3_COD
					SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
				EndIf
			EndIf
		EndIf

	EndIf

Return

