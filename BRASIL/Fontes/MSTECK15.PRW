/*********************************************************************************************************************** 
Fonte........: MSTECK15
ação.........: Função para cálculo dos dias da entrega progamada do Orçamento
.............: Chamado através dos Fontes TK271BOK
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 29/04/2022
Chamado......: 20220429009114 - Oferta Logística

MV_DIASENT...: Parâmetro de dias mínimos de entraga.
***********************************************************************************************************************/
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOTVS.CH'
#DEFINE CRLF CHR(13)+CHR(10)


USER FUNCTION MSTECK15(lAltCab,_dDtProg)
LOCAL i := 0
LOCAL lRet   := .T.
LOCAL _nPosOper := 0
LOCAL _nPosDEnt := 0
LOCAL _nPosEnt1 := 0
LOCAL _nPosProd := 0 
LOCAL _nPosLT   := 0 
LOCAL nDiasGrp  := 0
LOCAL nDiasLT   := 0 
LOCAL aAreaSB1  := GETAREA("SB1")
LOCAL nDiasTra  := 0
LOCAL nDiasFin  := 0
LOCAL nDiasCom  := 0
LOCAL nDiasLog  := 0
LOCAL nDiasExp  := 0
LOCAL nDiasOpe  := 0
LOCAL nDiaBase  := 0
LOCAL nSaldo    := 0
LOCAL _cArmVen  := GetMv("ST_ARMVEN",,"01/03")
LOCAL aRetArray := {}

/********************
lAltCab = Varirável para saber se a chamada está vindo da rotina de Alteração de Cabeçaho do Pedido de Venda Fonte STFSXFUN.PRW
********************/
DEFAULT lAltCab := .F.
DEFAULT _dDtProg  := STOD("")

/*********************************
Verifica se a chamada é feita pelo orçamento
*********************************/
IF IsInCallStack("U_STFSVE47") = .T.
	IF (INCLUI = .T. .OR. ALTERA = .T.) .AND. !EMPTY(M->UA_XDTENPR) .AND. cEmpAnt = "11"
		
		/*********************************************
		Se o orçamento possui Entrega Programada a cidade de entrega deverá
		possuir o tempo de translado cadastrado na tabela CC2
		*********************************************/
		CC2->(DBSETORDER(1))
		IF CC2->(DBSEEK(XFILIAL("CC2")+SA1->A1_EST+SA1->A1_COD_MUN))
			/*IF CC2->CC2_XTNT = 0
				/***************************
				Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
				***************************/
				/*AutoGrLog( "ERRO - Orcamento com 'Entrega Programada'!"+CRLF+;
				"O Municipio "+SA1->A1_COD_MUN+" nao possui cadastro na tabela CC2")
				MSGALERT( "ERRO - Orcamento com 'Entrega Programada'!"+CRLF+;
				"O Municipio "+SA1->A1_COD_MUN+" nao possui cadastro na tabela CC2")
				lRet := .F.
			ENDIF*/
			
			/************************************
			Passou pela validação de tempo de translado CC2
			*************************************/
			IF lRet = .T.
				_nPosOper := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_OPER"})
				_nPosDEnt := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_DTENTRE"})
				_nPosProd := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_PRODUTO"})
				_nPosLT   := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_XLEADT"})
				
				/************************************
				Verifica se TODOS os produtos do orçamento são  MTS "Produto de Estoque"
				Se todos os itens no pedido forem de Estoque não considera o Lead Time do produto
				Se algum dos produtos for MTO "Produto a ser fabricado/comprado" a rotina irá buscar o MAIOR Lead Time informado e
				a data de entrega deverá considerar o Lead Time mais o Tempo de Operação mais o Tempo de Translado
				*************************************/
				nDiasGrp   := 0
				nDiasLT    := 0
				FOR i := 1 TO LEN (aCols)
					IF (aCols[i,_nPosOper] = "01" .OR. aCols[i,_nPosOper] = "93") .AND. aCols[i,(LEN(aHeader)+1)] = .F.
						SB1->(DBSETORDER(1))
						IF SB1->(DBSEEK(XFILIAL("SB1")+aCols[i,_nPosProd]))
							IF ALLTRIM(SB1->B1_XMTO) = "MTO"
								nDiasGrp := U_STLDGRUP(SB1->B1_COD)
								IF nDiasGrp > nDiasLT
									nDiasLT := nDiasGrp
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				NEXT
				RESTAREA(aAreaSB1)
				
				/******************************************************
				Encontrou algum produto MTO
				Calcula a nova data programada baseando-se na maior data de Lead Time mais 05 dias de operação e mais o tempo de translado.
				*******************************************************/
				IF nDiasLT > 0
					/*IF M->UA_XDTENPR < (DATE() + nDiasLT)
						/***************************
						Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
						***************************/
						/*AutoGrLog( "ERRO - Orcamento com 'Entrega Programada'!"+CRLF+;
						"Existem produtos do tipo MTO por tanto  "+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						MSGALERT(  "ERRO - Orcamento com 'Entrega Programada'!"+CRLF+;
						"Existem produtos do tipo MTO por tanto  "+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						lRet := .F.
						
					ELSE*/
						/************************************
						Carrega os dias necessários para a operação: 

						Parâmetros para o tempo total de operação do produto 
						STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
						STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
						STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
						STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
						*************************************/
						//// Dias de Translado para a entrega Tabela CC2
						nDiasTra := CC2->CC2_XTNT
						
						//// Dias de operação para o Financeiro
						nDiasFin := GetNewPar("STDIASFIN",2)

						//// Dias de operação para o Comercial
						nDiasCom := GetNewPar("STDIASCOM",0)

						//// Dias de operação para a Logistica 
						nDiasLog := GetNewPar("STDIASLOG",4)
						
						//// Dias de operação para a Expedição
						nDiasExp := GetNewPar("STDIASEXP",2)

						//// Soma os dias que compõe a opreação total 
						nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

						/********************************************
						Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
						Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
						A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
						Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
						********************************************/
						//// Data da Entrega Programada
						nDiaBase := M->UA_XDTENPR

						FOR i := 1 TO nDiasOpe
							nDiaBase := DataValida((nDiaBase - 1),.F.)
						NEXT

						/************************************
						Verifica se passou na regra.
						Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
						Somente se o tipo de operação for "01" / "93"
						************************************/
						FOR i := 1 TO LEN (aCols)
							IF (aCols[i,_nPosOper] = "01" .OR. aCols[i,_nPosOper] = "93") .AND. aCols[i,(LEN(aHeader)+1)] = .F.
								aCols[i,_nPosDEnt] := nDiaBase
								IF SB1->(DBSEEK(XFILIAL("SB1")+aCols[i,_nPosProd]))
									IF ALLTRIM(SB1->B1_XMTO) = "MTO"
										aCols[i,_nPosLT]   := U_STLDGRUP(aCols[i,_nPosProd])
									ENDIF
								ENDIF
								oGetTlv:oBrowse:Refresh()
							ENDIF
						NEXT
						RESTAREA(aAreaSB1)
					//ENDIF
				ELSE
					/************************************
					Produtos MTS - Peordutos em Estoque
					Verifica se a data de entrega é maior que a definida no parâmetro MV_DIASENT
					************************************/
					nDiasLT := GETMV("MV_DIASENT",,45)
					/*IF M->UA_XDTENPR < (DATE()+nDiasLT)
						AutoGrLog( "ERRO - Orçamento com 'Entrega Programada'!"+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						MSGALERT(  "ERRO - Orçamento com 'Entrega Programada'!"+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						lRet := .F.
					ELSE*/

						/************************************
						Carrega os dias necessários para a operação: 

						Parâmetros para o tempo total de operação do produto 
						STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
						STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
						STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
						STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
						*************************************/
						//// Dias de Translado para a entrega Tabela CC2
						nDiasTra := CC2->CC2_XTNT
						
						//// Dias de operação para o Financeiro
						nDiasFin := GetNewPar("STDIASFIN",2)

						//// Dias de operação para o Comercial
						nDiasCom := GetNewPar("STDIASCOM",0)

						//// Dias de operação para a Logistica 
						nDiasLog := GetNewPar("STDIASLOG",4)
						
						//// Dias de operação para a Expedição
						nDiasExp := GetNewPar("STDIASEXP",2)

						//// Soma os dias que compõe a opreação total 
						nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

						/********************************************
						Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
						Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
						A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
						Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
						********************************************/
						//// Data da Entrega Programada
						nDiaBase := M->UA_XDTENPR

						FOR i := 1 TO nDiasOpe
							nDiaBase := DataValida((nDiaBase - 1),.F.)
						NEXT

						/************************************
						Verifica se passou na regra.
						Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
						Somente se o tipo de operação for "01" / "93"
						*************************************/
						FOR i := 1 TO LEN (aCols)
							IF (aCols[i,_nPosOper] = "01" .OR. aCols[i,_nPosOper] = "93") .AND. aCols[i,(LEN(aHeader)+1)] = .F.
								aCols[i,_nPosDEnt] := nDiaBase
								aCols[i,_nPosLT]   := 0
								oGetTlv:oBrowse:Refresh()
							ENDIF
						NEXT
					//ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

/****************************
Quando chamado pela rotina de "ALTERAÇÃO DE CABEÇALHO"
****************************/
ELSEIF lAltCab = .T. .AND. !EMPTY(_dDtProg)

	IF !EMPTY(_dDtProg) .AND. cEmpAnt = "11"
		
		/*********************************************
		Se o Pedido de Venda  possui Entrega Programada a cidade de entrega deverá
		possuir o tempo de translado cadastrado na tabela CC2
		*********************************************/
		SA1->(DBSETORDER(1))
		SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

		CC2->(DBSETORDER(1))
		IF CC2->(DBSEEK(XFILIAL("CC2")+SA1->A1_EST+SA1->A1_COD_MUN))
			IF CC2->CC2_XTNT = 0
				/***************************
				Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
				***************************/
				AutoGrLog( "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
				"O Municipio "+SA1->A1_COD_MUN+" nao possui cadastro na tabela CC2")
				MSGALERT( "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
				"O Municipio "+SA1->A1_COD_MUN+" nao possui cadastro na tabela CC2")
				lRet := .F.
			ENDIF
			
			/************************************
			Passou pela validação de tempo de translado CC2
			*************************************/
			IF lRet = .T.

				/************************************
				Verifica se TODOS os produtos do Pedido de Venda são  MTS "Produto de Estoque"
				Se todos os itens no pedido forem de Estoque não considera o Lead Time do produto
				Se algum dos produtos for MTO "Produto a ser fabricado/comprado" a rotina irá buscar o MAIOR Lead Time informado e
				a data de entrega deverá considerar o Lead Time mais o Tempo de Operação mais o Tempo de Translado
				*************************************/
				nDiasGrp   := 0
				nDiasLT    := 0
				cQuery := "SELECT C6.R_E_C_N_O_ AS C6REC FROM "+RetSqlName("SC6")+" C6 "+CRLF
				cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CRLF
				cQuery += "AND C6.C6_NUM = '"+SC5->C5_NUM+"' "+CRLF
				cQuery += "GROUP BY C6.R_E_C_N_O_ "+CRLF
				cQuery += "ORDER BY C6.R_E_C_N_O_"+CRLF
				cQuery := ChangeQuery(cQuery)
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)
				WHILE TSC6->(!EOF())

					SC6->(DBSETORDER(1))
					SC6->(DBGOTO(TSC6->C6REC))

					SB1->(DBSETORDER(1))
					IF SB1->(DBSEEK(XFILIAL("SB1")+SC6->C6_PRODUTO))
						IF ALLTRIM(SB1->B1_XMTO) = "MTO"
							nDiasGrp := U_STLDGRUP(SB1->B1_COD)
							IF nDiasGrp > nDiasLT
								nDiasLT := nDiasGrp
							ENDIF
						ENDIF
					ENDIF
				TSC6->(DBSKIP())
				ENDDO
				
				/******************************************************
				Encontrou algum produto MTO
				Calcula a nova data programada baseando-se na maior data de Lead Time mais 05 dias de operação e mais o tempo de translado.
				*******************************************************/
				IF nDiasLT > 0
					/*IF _dDtProg < (DATE() + nDiasLT)
						/***************************
						Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
						***************************/
						/*AutoGrLog( "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
						"Existem produtos do tipo MTO por tanto  "+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						MSGALERT(  "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
						"Existem produtos do tipo MTO por tanto  "+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						lRet := .F.
					ELSE*/

						/************************************
						Carrega os dias necessários para a operação: 
						Parâmetros para o tempo total de operação do produto 
						STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
						STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
						STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
						STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
						*************************************/
						//// Dias de Translado para a entrega Tabela CC2
						nDiasTra := CC2->CC2_XTNT
						
						//// Dias de operação para o Financeiro
						nDiasFin := GetNewPar("STDIASFIN",2)

						//// Dias de operação para o Comercial
						nDiasCom := GetNewPar("STDIASCOM",0)

						//// Dias de operação para a Logistica 
						nDiasLog := GetNewPar("STDIASLOG",4)
						
						//// Dias de operação para a Expedição
						nDiasExp := GetNewPar("STDIASEXP",2)

						//// Soma os dias que compõe a opreação total 
						nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

						/********************************************
						Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
						Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
						A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
						Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
						********************************************/
						//// Data da Entrega Programada
						nDiaBase := _dDtProg

						FOR i := 1 TO nDiasOpe
							nDiaBase := DataValida((nDiaBase - 1),.F.)
						NEXT

						/************************************
						Verifica se passou na regra.
						Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
						*************************************/
						TSC6->(DBGOTOP())
						WHILE TSC6->(!EOF())

							SC6->(DBSETORDER(1))
							SC6->(DBGOTO(TSC6->C6REC))
							
							RECLOCK("SC6",.F.)
							SC6->C6_XDTRERE := STOD("")
							SC6->C6_ENTREG := nDiaBase
							SC6->C6_ENTRE1 := nDiaBase
							IF SB1->(DBSEEK(XFILIAL("SB1")+SC6->C6_PRODUTO))
								IF ALLTRIM(SB1->B1_XMTO) = "MTO"
									SC6->C6_XLEADT := U_STLDGRUP(SC6->C6_PRODUTO)
								ENDIF
							ENDIF
							SC6->(MSUNLOCK())
							TSC6->(DBSKIP())
						ENDDO
					//ENDIF
				ELSE
				
					/************************************
					Produtos MTS - Peordutos em Estoque
					Veriifa se a data de entrega é maior que a definida no parâmetro MV_DIASENT
					************************************/
					nDiasLT := GETMV("MV_DIASENT",,45) 
					/*IF _dDtProg < (DATE()+nDiasLT)
						AutoGrLog( "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						MSGALERT(  "ERRO - Pedido de Venda com 'Entrega Programada'!"+CRLF+;
						"A data mínima para entrega deverá ser "+DTOC((DATE() + nDiasLT)))
						lRet := .F.
					ELSE*/

						/************************************
						Carrega os dias necessários para a operação: 

						Parâmetros para o tempo total de operação do produto 
						STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
						STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
						STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
						STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
						*************************************/
						//// Dias de Translado para a entrega Tabela CC2
						nDiasTra := CC2->CC2_XTNT
						
						//// Dias de operação para o Financeiro
						nDiasFin := GetNewPar("STDIASFIN",2)

						//// Dias de operação para o Comercial
						nDiasCom := GetNewPar("STDIASCOM",0)

						//// Dias de operação para a Logistica 
						nDiasLog := GetNewPar("STDIASLOG",4)
						
						//// Dias de operação para a Expedição
						nDiasExp := GetNewPar("STDIASEXP",2)

						//// Soma os dias que compõe a opreação total 
						nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

						/********************************************
						Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
						Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
						A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
						Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
						********************************************/
						//// Data da Entrega Programada
						nDiaBase := _dDtProg

						FOR i := 1 TO nDiasOpe
							nDiaBase := DataValida((nDiaBase - 1),.F.)
						NEXT

						/************************************
						Verifica se passou na regra.
						Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
						*************************************/
						TSC6->(DBGOTOP())
						WHILE TSC6->(!EOF())

							SC6->(DBSETORDER(1))
							SC6->(DBGOTO(TSC6->C6REC))

							RECLOCK("SC6",.F.)
							SC6->C6_ENTREG := nDiaBase
							SC6->C6_XDTRERE := STOD("")
							SC6->C6_XLEADT   := 0
							SC6->(MSUNLOCK())
							TSC6->(DBSKIP())
						ENDDO
					//ENDIF
				ENDIF
			ENDIF

			//Remover reservas e faltas
			TSC6->(DBGOTOP())
			WHILE TSC6->(!EOF())

				SC6->(DBSETORDER(1))
				SC6->(DBGOTO(TSC6->C6REC))

				U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
				U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
				U_STPriSC5()

				TSC6->(DBSKIP())
			ENDDO

		Else 

			MsgAlert("Não será possível colocar data programada pois não possui prazo cadastrado na tabela, procure a logística")
			lRet := .F.

		ENDIF
	ENDIF
/****************************
Quando chamado pela rotina de "ALTERAÇÃO DE CABEÇALHO" com a Data de Entraga Em Branco
****************************/
ELSEIF lAltCab = .T. .AND. EMPTY(_dDtProg)

	IF cEmpAnt = "11"
		
		cQuery := "SELECT C6.R_E_C_N_O_ AS C6REC FROM "+RetSqlName("SC6")+" C6 "+CRLF
		cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "AND C6.C6_NUM = '"+SC5->C5_NUM+"' "+CRLF
		cQuery += "GROUP BY C6.R_E_C_N_O_ "+CRLF
		cQuery += "ORDER BY C6.R_E_C_N_O_"+CRLF
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)
		WHILE TSC6->(!EOF())


			nSaldo := 0
			_cArmVen  := GetMv("ST_ARMVEN",,"01/03")
			aRetArray := {}
			aRetArray := (U_STFSVE50(SC6->C6_PRODUTO,,,.T.))

			IF aRetArray <> NIL
				FOR i := 1 TO LEN(aRetArray)
					IF Alltrim(aRetArray[i,2] ) $ _cArmVen
						nSaldo += aRetArray[i,3]
					ENDIF
				NEXT
			ENDIF

			SC6->(DBSETORDER(1))
			SC6->(DBGOTO(TSC6->C6REC))
			RECLOCK("SC6",.F.)
			SC6->C6_ENTREG := U_ATUDTENTRE(nSaldo,SC6->C6_PRODUTO,(SC6->C6_QTDVEN - SC6->C6_QTDENT))
			SC6->C6_XDTRERE := STOD("")
			SC6->C6_XLEADT   := 0
			SC6->(MSUNLOCK())
			U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
			U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
			U_STPriSC5()  // grava prioridade
			TSC6->(DBSKIP())
		ENDDO
	ENDIF
ENDIF

//// Verifica se a tabela temporária está aberta
IF SELECT("TSC6") > 0 
	TSC6->(DBCLOSEAREA())
ENDIF

RETURN lRet
