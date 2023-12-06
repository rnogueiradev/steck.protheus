#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
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

User Function FA050ALT()

	Local lRet 		:= .T.
	Local _cFluxoP	:= Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,"A2_FLUXO")

	Local _cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar - MULTA/JUROS"
	Local _cEmail  := UsrRetMail(M->E2_XAPROV)
	Local _cCopia  := ""
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "FIN004B"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}
	Local _lCont   := .F.
	Local _lClas   := .F.
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprova็ใo de Titulos
	Local _cGPEUSR := GetMv('ST_GPEUSR',,'000722')//Usuario aprovador do RH
	Local _cEICUSR := GetMv('ST_EICUSR',,'000722')//Usuario aprovador do SigaEic/Eec
	Local _cFISUSR := GetMv('ST_FISUSR',,'000722')//Usuario aprovador do Fiscal

	Local _cMsgSave := ""
	Local _nVlrJur 	:= GetMv('ST_VLRJUR',,10)
	Private _UsrClas := GetMv('ST_USRCLAS',,'000000/000279')

	IF SE2->E2_FLUXO <> _cFluxoP

		If MsgYesNo("Este fornecedor esta configurado para que seus titulos nao entre no Fluxo de Caixa. Confirma a alteracao?","Atencao")
			lRet:= .T.

		Else
			lRet:= .F.
		Endif

	ENDIF
	//>>Chamado 006559 - Everson Santana - 04/12/18
	If lRet

		If _FinAprov

			//If FunName() $ "FINA750#FINA050#GPEM670#SIGAEIC#SIGAEEC#FISA001#MATA952#MATA953#MATA996"
			If FunName() $ "FINA750#FINA050#GPEM670#FISA001#MATA952#MATA953#MATA996"

				If Empty(M->E2_XAPROV)

					If FunName()  $ "GPEM670" //Alltrim(M->E2_ORIGEM)
						M->E2_XAPROV := _cGPEUSR
						_lCont := .t.
						_cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar - (Recursos Humanos)"
					EndIF
					/*
					If Alltrim(M->E2_ORIGEM) $ "SIGAEIC#SIGAEEC"
					M->E2_XAPROV :=  _cEICUSR
					_lCont := .t.
					_cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar - (EIC/EEC)"
					EndIf
					*/
					If FunName() $ "FISA001#MATA952#MATA953#MATA996#STGERGUIA" //Alltrim(M->E2_ORIGEM)
						M->E2_XAPROV :=  _cFISUSR
						_lCont := .t.
						_cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar - (FISCAL)"
					EndIf

					If AllTrim(M->E2_TIPO) $ "PA"
						M->E2_XAPROV :=  AllTrim(GetMv("STFIN00402",,"000019"))
						_cAssunto := "Solicita็ใo de Aprova็ใo tํtulo PA"
					EndIf


					If 	_lCont

						If  Alltrim(M->E2_ORIGEM) $ "SIGAEIC#SIGAEEC" .Or. AllTrim(M->E2_TIPO) $ "NF" //Alltrim(M->E2_ORIGEM) (20230215001853)

							M->E2_XBLQ 	 := "" 
							M->E2_XLOG 	 := ""
							M->E2_USRINC := ""
							M->E2_XAPROV := ""

							RestArea(aArea)
							lRet := .T.

						Else

							_cMsgSave += "===================================" +CR
							_cMsgSave += "Titulo Incluido por. " +CR
							_cMsgSave += "Usuแrio: "+cUserName+CR
							_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

							M->E2_XBLQ 	 := "1" //Bloqueado
							M->E2_XLOG 	 := _cMsgSave
							M->E2_USRINC := __cUserId

						EndIf	

					Else

						MsgAlert("Seu usuแrio nใo estแ vinculado a um aprovador."+CR+CR+" Solicite o cadastro junto ao Financeiro. ","FA050ALT")

						lRet := .F.
					EndIf
				Else
					If M->E2_ACRESC > _nVlrJur

						If M->E2_ACRESC > SE2->E2_ACRESC  //Juros e Multa alimentam este campo

							//M->E2_XBLQOLD	:= SE2->E2_XBLQ
							M->E2_XBLQ 		:= "6" //Bloqueado por Multa e Juros

							_lCont := .T.

							_cMsgSave += "===================================" +CR
							_cMsgSave += "Bloqueado por Multa e Juros por: " +CR
							_cMsgSave += "Usuแrio: "+cUserName+CR
							_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

							M->E2_XLOG  := _cMsgSave + CR +SE2->E2_XLOG

						EndIf
					EndIf

				EndIf

			EndIF

			If SE2->E2_XAPROV <> M->E2_XAPROV

				_cAssunto := "Solicita็ใo de Aprova็ใo Contas a Pagar"
				_lCont := .T.

			EndIf 

			If _lCont

				Aadd( _aMsg , { "Numero: "          , M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA } )
				Aadd( _aMsg , { "Nome: "    		, M->E2_NOMFOR } )
				Aadd( _aMsg , { "Valor: "    		, transform((M->E2_VALOR)	,"@E 999,999,999.99")  } )
				Aadd( _aMsg , { "Multa/Juros: "		, transform((M->E2_ACRESC)	,"@E 999,999,999.99")  } )
				Aadd( _aMsg , { "Emissao: "    		, dtoc(M->E2_EMISSAO) } )
				Aadd( _aMsg , { "Vencto Real : "    , dtoc(M->E2_VENCREA) } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )
				Aadd( _aMsg , { "Incluido por: "    , cUserName } )
				Aadd( _aMsg , { "Historico: "    	, Alltrim(M->E2_HIST) } )

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

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

				EndIf

				RestArea(aArea)

				lRet := .T.
			// 2. Ticket 20211201025720 - STATUS DO TITULO - FINANCEIRO -- Eduardo Pereira - Sigamat -- 03.12.2021 -- Inclui #MATA100#FINA050 
			//Retirado da rotina - devido solicita็ใo da lilial chamado : 20220802014996 - Retirado #MATA100#FINA050
			ElseIf Alltrim(M->E2_ORIGEM) $ "SIGAEIC#SIGAEEC#EICDI502"	

				M->E2_XBLQ 	 := "" 
				M->E2_XLOG 	 := ""
				M->E2_USRINC := ""
				M->E2_XAPROV := ""

				RestArea(aArea)
				nRetorno := .T.	

			EndIf

		EndIf

	EndIf
	//<<

Return(lRet)



User Function xFA240NAR()

	Local _cRec:= "\CNAB\SAIDA\"
	//+Paramixb
	If !( _cRec $  Paramixb )
		_cRec:= "\CNAB\SAIDA\"+Paramixb
	EndIf


Return (Paramixb)

//iif((MV_PAR04:="\CNAB\SAIDA\"+MV_PAR04)= 'X',.T.,.T.)
//F240BR
//AFI150


User Function xF150ARQ()

	Local _cRec:= "\CNAB\SAIDA\"
	//+Paramixb

	If !( _cRec $  Paramixb )
		_cRec:= "\CNAB\SAIDA\"+Paramixb
	EndIf

Return (Paramixb)




