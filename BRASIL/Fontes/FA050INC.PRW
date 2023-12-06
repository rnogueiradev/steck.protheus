#Include "Protheus.ch"
#Include "RWMake.ch"
#Define CR chr(13) + chr(10)

/*/{Protheus.doc} FA050INC
(long_description) 
Chamado 006559
@type  Static Function
@author Everson Santana
@since 04/12/18
@version Protheus 12 - Financeiro
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
SE2->E2_XBLQ = 1;Bloqueado;2Rejeitado,Vazio Liberado
/*/

User Function FA050INC()

	Local _cAssunto		:= "Solicitação de Aprovação Contas a Pagar"
	Local _cEmail		:= ""
	Local _cCopia		:= ""
	Local aArea 		:= GetArea()
	Local cFuncSent		:= "FA050INC"
	Local cMsg			:= ""
	Local _nLin
	Local _aMsg			:= {}
	Local _cGPEUSR		:= GetMv('ST_GPEUSR',,'000722')//Usuario aprovador do RH
	Local _cFISUSR		:= GetMv('ST_FISUSR',,'000722')//Usuario aprovador do Fiscal
	Local _cMsgSave		:= ' '
	Local _FinAprov		:= GetMv('ST_FINAPRO',,.F.) //Parametro para bloquear a rotina de aprovação de Titulos
	Private nRetorno	:= .F.

	If (Alltrim(M->E2_NATUREZ) $ "24001/24002/24013/24019" .And. M->E2_RATEIO == "N")
		MsgAlert("PREENCHA O RATEIO - FA050INC")
		nRetorno := .F.
/*	ElseIf M->E2_FORNECE == "000392" .And. !(M->E2_PREFIXO $ "CMI/FIN")	// Alterado para considerar os dois Prefixos conforme Ticket 20210122001221 - Erro para lançar boletos com prefixo FIN - Eduardo Sigamat 26.01.2021
		MsgAlert("Para o fornecedor 000392 o prefixo deve ser CMI ou FIN")
		nRetorno := .F.						*/
//								Bloco retirado de acordo com Ticket  20220325006637 - Regra de negocio não exige mais o prefixo 
	Else
		nRetorno := .T.
	EndIf

	//>>Chamado 006559 - Everson Santana - 04/12/18
	If FunName() $ "STGERGUIA"
		N := "" 
	EndIf
	//If INCLUI .And. _FinAprov .And. Empty(N) Ajustado para geração do correta do Log chamado: 20220802015005
	If INCLUI .And. _FinAprov 
		If FunName() $ "FINA750#FINA050#GPEM670#FISA001#MATA952#MATA953#MATA996#STFIN004#STGERGUIA"
			If FunName() $ "GPEM670"
				M->E2_XAPROV := _cGPEUSR
				_cAssunto := "Solicitação de Aprovação Contas a Pagar - (Recursos Humanos)"
			EndIF
			If FunName() $ "FISA001#MATA952#MATA953#MATA996#STGERGUIA"
				M->E2_XAPROV :=  _cFISUSR
				_cAssunto := "Solicitação de Aprovação Contas a Pagar - (FISCAL)"
			EndIf
			If AllTrim(M->E2_TIPO) $ "PA"
				M->E2_XAPROV :=  AllTrim(GetMv("STFIN00402",,"000019"))
				_cAssunto := "Solicitação de Aprovação título PA"
			EndIf
			If  Alltrim(M->E2_ORIGEM) $ "SIGAEIC#SIGAEEC" .Or. AllTrim(M->E2_TIPO) $ "NF"
				M->E2_XBLQ 	 := "" 
				M->E2_XLOG 	 := ""
				M->E2_USRINC := ""
				M->E2_XAPROV := ""
				nRetorno := .T.
			Else
				If Empty(M->E2_XAPROV)
					MsgAlert("Seu usuário não está vinculado a um aprovador." + CR + CR + " Solicite o cadastro junto ao Financeiro. ","FA050INC")
					nRetorno := .F.
				Else
					_cMsgSave += "===================================" + CR
					_cMsgSave += "Titulo Incluido por. " + CR
					_cMsgSave += "Usuário: " + cUserName + CR
					_cMsgSave += "Em: " + DtoC(dDatabase) + " " + Time() + CR
					M->E2_XBLQ := "1" //Bloqueado
					M->E2_XLOG := _cMsgSave
					M->E2_USRINC := __cUserId
					If !FunName() $ "STFIN004"
						aAdd( _aMsg , { "Numero: "          , M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA } )
						aAdd( _aMsg , { "Nome: "    		, M->E2_NOMFOR } )
						aAdd( _aMsg , { "Valor: "    		, Transform((M->E2_VALOR)	,"@E 999,999,999.99")  } )
						aAdd( _aMsg , { "Emissao: "    		, DtoC(M->E2_EMISSAO) } )
						aAdd( _aMsg , { "Vencto Real : "    , DtoC(M->E2_VENCREA) } )
						aAdd( _aMsg , { "Data: "    		, DtoC(dDataBase) } )
						aAdd( _aMsg , { "Hora: "    		, Time() } )
						aAdd( _aMsg , { "Incluido por: "    , cUserName } )
						aAdd( _aMsg , { "Historico: "    	, Alltrim(M->E2_HIST) } )
						If ( Type("l410Auto") == "U" .Or. !l410Auto )
							// Definicao do cabecalho do e-mail
							cMsg := ""
							cMsg += '<html>'
							cMsg += '<head>'
							cMsg += '<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
							cMsg += '</head>'
							cMsg += '<body>'
							cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
							cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
							cMsg += '<Caption> <FONT COLOR=#000000 FACE="ARIAL" SIZE=5>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
							// Definicao do texto/detalhe do e-mail
							For _nLin := 1 to Len(_aMsg)
								If (_nLin/2) == Int( _nLin/2 )
									cMsg += '<TR BgColor=#B0E2FF>'
								Else
									cMsg += '<TR BgColor=#FFFFFF>'
								EndIf
								cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
								cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
							Next
							// Definicao do rodape do email
							cMsg += '</Table>'
							cMsg += '<P>'
							cMsg += '<Table align="center">'
							cMsg += '<tr>'
							cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(' + cFuncSent + ')</td>'
							cMsg += '</tr>'
							cMsg += '</Table>'
							cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
							cMsg += '</body>'
							cMsg += '</html>'
							_cEmail  := UsrRetMail(M->E2_XAPROV)
							U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
						EndIf
					EndIf
				EndIf
				N := "S"
				nRetorno := .T.
			EndIf
		ElseIf M->E2_ORIGEM $ "SIGAEIC#SIGAEEC#EICDI502"
			M->E2_XBLQ 	 := "" 
			M->E2_XLOG 	 := ""
			M->E2_USRINC := ""
			M->E2_XAPROV := ""
			nRetorno := .T.
		EndIf
	EndIf
	//<<Chamado 006559 - Everson Santana - 04/12/18

	RestArea(aArea)

Return nRetorno
