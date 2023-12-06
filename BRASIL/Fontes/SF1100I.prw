#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SF1100I  บAutor  ณ Ricardo Posman     บ Data ณ  17/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava "Ref. a NF N.: XXXXXX" no campo E2_HIST              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF1100I()

	Local _cArea   := GetArea()
	Local _cAreaSD1 := SD1->(GetArea())
	Local _cAreaSF1 := SF1->(GetArea())
	Local _cFluxoP := ""
	Local _cFluxoR := ""

	//>> 20190514000011 - Everson Santana 30.07.2019

	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "SF1100I"
	Local cMsg     := ""
	Local _nLin
	Local _cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar"
	Local _cSemPed	:= .f.
	Local _nTipo  	:= ""
	Local _cEmail  	:= ""
	Local _cPara	:= "Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br"
	Local _cCopia 	:= " "
	Local _cMsgSave := ""
	Local _cMsgJur	:= ""
	Local _aMsg		:= {}
	Local _lOk := .F.
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprova็ใo de Titulos
	Local _TesInd 	:= GetMv('ST_TESIND',,.f.) //TES utilizada no processo de industrializa็ใo nใo precisa do processo de aprova็ใo de tํtulos. //>> Ticket 20200625003379 - Everson Santana - 29.06.2020
	Local _cParc	:= ""
	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	private oDlg
	private oBtn1,oBtn2,oBtn3,oDlg
	private _cAprov := Space(6)

	DEFAULT _aCols := {}
	//<<

	dbselectarea("SE2")
	dbSetOrder(6)            // For+Loja+Pref+Num
	IF dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)

		While SE2->E2_FORNECE = SF1->F1_FORNECE .AND. SE2->E2_LOJA = SF1->F1_LOJA .AND. SE2->E2_PREFIXO = SF1->F1_PREFIXO .AND. SE2->E2_NUM = SF1->F1_DOC

			reclock("SE2",.f.)
			SE2->E2_HIST    := "Ref. a NF N.: "+alltrim(SF1->F1_DOC)
			msUnlock()
			DbSKip()

		END
	ENDIF

	IF  SF1->F1_TIPO = "N"
		_cFluxoP := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_FLUXO")

		IF _cFluxoP == "N"

			dbselectarea("SE2")
			dbSetOrder(6)            // For+Loja+Pref+Num
			IF dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)

				While SE2->E2_FORNECE = SF1->F1_FORNECE .AND. SE2->E2_LOJA = SF1->F1_LOJA .AND. SE2->E2_PREFIXO = SF1->F1_PREFIXO .AND. SE2->E2_NUM = SF1->F1_DOC

					RECLOCK("SE2",.F.)
					SE2->E2_FLUXO    := _cFluxoP
					MSUNLOCK()
					DbSKip()
				END
			ENDIF
		ENDIF

	ELSEIF SF1->F1_TIPO $ "D"
		_cFluxoR := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_FLUXO")

		IF _cFluxoR == "N"

			dbselectarea("SE1")
			dbSetOrder(2)            // cli+Loja+Pref+Num
			IF dbSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)

				While SE1->E1_CLIENTE = SF1->F1_FORNECE .AND. SE1->E1_LOJA = SF1->F1_LOJA .AND. SE1->E1_PREFIXO = SF1->F1_PREFIXO .AND. SE1->E1_NUM = SF1->F1_DOC

					RECLOCK("SE1",.F.)
					SE1->E1_FLUXO    := _cFluxoR
					MSUNLOCK()
					DbSKip()
				END
			ENDIF
		ENDIF
	ENDIF

	//Adiciona dados da DI se complemento
	If SF1->F1_FORMUL = 'S' .And.  SF1->F1_EST = 'EX' .And. Empty(SF1->F1_HAWB)
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		SD1->(DbGoTop())
		If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				If Empty(SD1->D1_TIPO_NF) .And. !Empty(SD1->D1_NFORI)
					Reclock("SD1",.F.)
					SD1->D1_TIPO_NF := "6" //Nf Complementar
					MsUnlock()
				EndIf
				SD1->(DbSkip())
			End
		EndIf
	EndIf

	//>> Ticket 20190514000011 - Everson Santana - 30.07.2019

	If _FinAprov

		If cEmpAnt == "01"
			If SF1->F1_FORNECE $ "005866"

				RestArea(_cAreaSD1)
				RestArea(_cAreaSF1)
				RestArea(_cArea)

				Return

			EndIf

		ElseIf cEmpAnt == "03"

			If SF1->F1_FORNECE $ "005764"

				RestArea(_cAreaSD1)
				RestArea(_cAreaSF1)
				RestArea(_cArea)

				Return

			EndIf
		EndIf

		If SF1->F1_ESPECIE = 'CTE'

			RestArea(_cAreaSD1)
			RestArea(_cAreaSF1)
			RestArea(_cArea)

			Return
		EndIf

		cQuery := " SELECT D1_TES,D1_PEDIDO FROM "+RetSqlName("SD1")+ " SD1  "
		cQuery += " WHERE D1_FILIAL = '"+SF1->F1_FILIAL+"' "
		cQuery += " AND D1_DOC = '"+SF1->F1_DOC+" ' AND D1_SERIE = '"+SF1->F1_SERIE+" ' AND D1_FORNECE = '"+SF1->F1_FORNECE+" ' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_PEDIDO = ' ' AND D_E_L_E_T_ = ' '  "
		cQuery += " AND NOT EXISTS( SELECT * FROM "+RetSqlName("ZZS")+" WHERE ZZS_FILIAL = '"+SF1->F1_FILIAL+"' AND ZZS_NF = '"+SF1->F1_DOC+"' AND ZZS_SERIE = '"+SF1->F1_SERIE+" ' AND ZZS_FORNEC = '"+SF1->F1_FORNECE+" ' AND ZZS_LOJA = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ = ' ' ) " //Ticket  20201120010891 - Everson Santana - 26.11.2020

		If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

		dbSelectArea(cAlias1)
		(cAlias1)->(dbGoTop())

		While !EOF()

			//>> Ticket 20200625003379 - Everson Santana - 29.06.2020
			If Alltrim((cAlias1)->D1_TES) $ _TesInd

				_cSemPed	:= .F.

			else
				//<< Ticket 20200625003379 - Everson Santana - 29.06.2020
				If Posicione("SF4",1,xFilial("SF4")+(cAlias1)->D1_TES,"F4_DUPLIC") $ "S"

					If Len(_aCols) > 0 //Variavel plublica do fonte STMULTPC utilizo para validar se ้ multiplos PC - Ticket 20210122001198  
						_cSemPed	:= .F.
					else
						_cSemPed	:= .T.
					endIf

				EndIf

			EndIf //>> Ticket 20200625003379 - Everson Santana - 29.06.2020

			(cAlias1)->(dbSkip())

		End

		/*
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		SD1->(DbGoTop())
		If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				If Empty(SD1->D1_PEDIDO) //.and. !_cSemPed
		_cSemPed	:= .T.
				EndIf
		SD1->(DbSkip())
			End
		End
		*/

		If _cSemPed

			DEFINE MSDIALOG oDlg FROM 50,100 TO 150,300 TITLE "Informe o Aprovador" STYLE DS_MODALFRAME PIXEL
			@ 06,008 SAY "Informe o Aprovador para o titulo" SIZE 122,9 Of oDlg PIXEL
			@ 20,008 SAY "Aprovador" SIZE 30,9 Of oDlg PIXEL
			@ 20,050 MSGET _cAprov VALID !Empty(_cAprov) SIZE 45,10 F3 "Z41" Of oDlg PIXEL
			@ 35,050 BUTTON oBut1 PROMPT "&Ok"       SIZE 45,12 Of oDlg PIXEl Action (lOk:=.T.,oDlg:End())

			ACTIVATE MSDIALOG oDlg

			If lOk

				_cParc := ""
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Titulo Incluido por. " +CR
				_cMsgSave += "Usuแrio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

				dbselectarea("SE2")
				dbSetOrder(6)            // For+Loja+Pref+Num
				IF dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)

					While SE2->E2_FORNECE = SF1->F1_FORNECE .AND. SE2->E2_LOJA = SF1->F1_LOJA .AND. SE2->E2_PREFIXO = SF1->F1_PREFIXO .AND. SE2->E2_NUM = SF1->F1_DOC

						RECLOCK("SE2",.F.)
						SE2->E2_XAPROV	:= _cAprov
						SE2->E2_XBLQ	:= "1"
						SE2->E2_USRINC	:= __cUserId
						SE2->E2_XLOG := _cMsgSave
						MSUNLOCK()

						If Empty(_cParc)
							_cParc := SE2->E2_PARCELA
						Else
							_cParc := _cParc+"/"+SE2->E2_PARCELA
						EndIf

						DbSKip()
					END

				ENDIF

				Aadd( _aMsg , { "Numero: "          , SE2->E2_PREFIXO+SE2->E2_NUM+" - "+_cParc } )
				Aadd( _aMsg , { "Nome: "    		, SE2->E2_NOMFOR } )
				Aadd( _aMsg , { "Valor: "    		, transform((SE2->E2_VALOR)	,"@E 999,999,999.99")  } )
				Aadd( _aMsg , { "Emissao: "    		, dtoc(SE2->E2_EMISSAO) } )
				Aadd( _aMsg , { "Vencto Real : "    , dtoc(SE2->E2_VENCREA) } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )
				Aadd( _aMsg , { "Incluido por : "	, cUserName } )

				If ( Type("l410Auto") == "U" .OR. !l410Auto )

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Definicao do cabecalho do email                                             ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					cMsg := ""
					cMsg += '<html>'
					cMsg += '<head>'
					cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
					cMsg += '</head>'
					cMsg += '<body>'
					cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
					cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
					cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Definicao do texto/detalhe do email                                         ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					For _nLin := 1 to Len(_aMsg)
						If (_nLin/2) == Int( _nLin/2 )
							cMsg += '<TR BgColor=#B0E2FF>'
						Else
							cMsg += '<TR BgColor=#FFFFFF>'
						EndIf

						cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

					Next

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Definicao do rodape do email                                                ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					cMsg += '</Table>'
					cMsg += '<P>'
					cMsg += '<Table align="center">'
					cMsg += '<tr>'
					cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
					cMsg += '</tr>'
					cMsg += '</Table>'
					cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
					cMsg += '</body>'
					cMsg += '</html>'

					_cEmail  	:= UsrRetMail(SE2->E2_XAPROV)

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

				EndIF

			EndIf

		EndIf
	EndIF
	//<<
	RestArea(_cAreaSD1)
	RestArea(_cAreaSF1)
	RestArea(_cArea)

Return()
