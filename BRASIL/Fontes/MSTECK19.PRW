/****************************************
Ação.........: Rotina para efetuar a reserva do pedido de forma manual ignorando as regras de bloqueio
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 27/05/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK19()
LOCAL cUserLib := ALLTRIM(SuperGetMV("MSTECK19",.F.,"000000"))
LOCAL _lTrocNf    := .t.
LOCAL _cOerFalRes   := GetMv("ST_OPRESFA",,"94/74")
LOCAL _lProc := .F.

///DBSELECTAREA("SC5")

//// Verifica se o usuário logado está cadastrado no parâmetro
IF __cUserId $ cUserLib
	IF MSGYESNO("Deseja efetuar a reserva manualmente para este pedido?")
		cQuery := "SELECT C6.R_E_C_N_O_ AS C6REC FROM "+RetSqlName("SC6")+" C6 "+CL
		cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND (C6_QTDVEN - C6_QTDENT) > 0 AND C6_BLQ = ' ' "+CL
		cQuery += "AND C6.C6_NUM = '"+SC5->C5_NUM+"' "+CL
		cQuery += "GROUP BY C6.R_E_C_N_O_ "+CL
		cQuery += "ORDER BY C6.R_E_C_N_O_ "+CL
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)
		WHILE TSC6->(!EOF())
			
			//// Posiciona na SC6
			SC6->(DBSETORDER(1))
			SC6->(DBGOTO(TSC6->C6REC))
			
			IF SC5->(DBSEEK(SC6->(C6_FILIAL+C6_NUM)))
				
				cQuery1 := "SELECT COUNT(*) QTD "
				cQuery1 += "FROM "+RetSqlName("SC9")+" C9 "
				cQuery1 += "WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL='"+SC5->C5_FILIAL+"' "
				cQuery1 += "AND C9_PEDIDO='"+SC5->C5_NUM+"' "
				cQuery1 += "AND C9_ORDSEP<>' ' AND C9_NFISCAL = ' ' "
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), 'TSC61', .F., .T.)
				
				IF TSC61->(!EOF())
					IF TSC61->QTD = 0
						
						_lTrocNf := !Empty(Alltrim(SC5->C5_XTRONF))
						
						IF !(SC6->C6_OPER $ _cOerFalRes)
							IF !_lTrocNf
								
								_lProc := .T.
								
								U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
								U_STGrvFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN)
								U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
								U_STPriSC5()  // grava prioridade
								
								/************************************
								VerIFica se gravou na PA1 ou PA2 as informações
								************************************/
								cQuery := "SELECT PA1.PA1_DOC, PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
								cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
								cQuery := ChangeQuery(cQuery)
								DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
								IF !EMPTY(TPA1->PA1_DOC)

									/******************************************
									Achou o registro de Falta então alimenta o campo PA1_SALDO com a quantidade da falta
									Quando o job MSTECK18 que é a geração automática de Pedidos de Venda na Indíustria 
									este campo será utilizado para identificar se o pedido de compra atendeu totalmente ou parcialmente a necessidade do pedido.
									******************************************/
									PA1->(DBSETORDER(1))
									PA1->(DBGOTO(TPA1->PA1REC))
									RECLOCK("PA1",.F.)
									PA1->PA1_SALDO := SC6->C6_QTDVEN
									PA1->(MSUNLOCK())

									RECLOCK("SC6",.F.)
									SC6->C6_XDTRERE := DATE()
									SC6->(MSUNLOCK())
									
									SC5->(RecLock("SC5",.F.))
									SC5->C5_XUSRLR := cUserName
									SC5->(MsUnLock())
									
								ELSE
									cQuery := "SELECT PA2.PA2_DOC FROM "+RetSqlName("PA2")+" PA2 "+CL
									cQuery += "WHERE PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
									cQuery := ChangeQuery(cQuery)
									DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA2', .F., .T.)
									IF !EMPTY(TPA2->PA2_DOC)
										RECLOCK("SC6",.F.)
										SC6->C6_XDTRERE := DATE()
										SC6->(MSUNLOCK())
										
										SC5->(RecLock("SC5",.F.))
										SC5->C5_XUSRLR := cUserName
										SC5->(MsUnLock())
										
									ENDIF
									TPA2->(DBCLOSEAREA())
								ENDIF
								TPA1->(DBCLOSEAREA())
							ENDIF
						ENDIF
					ENDIF
				ENDIF
				TSC61->(DBCLOSEAREA())
			ENDIF
			TSC6->(DBSKIP())
		ENDDO
		TSC6->(DBCLOSEAREA())
		
		IF _lProc
			MsgAlert("Reserva/falta efetuadas com sucesso!")
		ENDIF
		
	ENDIF
ELSE
	MSGALERT("Usuário não liberado para esta rotina!")
ENDIF

RETURN
