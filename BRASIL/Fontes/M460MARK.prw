#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Tbiconn.ch"
#INCLUDE "Topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Rdmake    ³M460MARK  ³Autor  ³Leonardo Kichitaro     ³Data  ³28/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³PE utilizado para validar os pedidos marcados e esta        ³±±
±±³          ³localizado no inicio da função a460Nota (endereça rotinas   ³±±
±±³          ³para a geração dos arquivos SD2/SF2).Sera informado no      ³±±
±±³          ³terceiro parametro a serie selecionada na geracao da nota   ³±±
±±³          ³e o numero da nota fiscal podera ser verificado pela        ³±±
±±³          ³variavel private cNumero.                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M460MARK()

Local lRet		:= .T.
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
Local aAreaCB7	:= CB7->(GetArea())
Local aAreaCB8	:= CB8->(GetArea())
Local cMarca	:= PARAMIXB[1]
Local lInverte	:= PARAMIXB[2]
Local _lMarcado	:= .F.
Local cQuery	:= ""
Local cQryTab	:= ""
Local nQRegSC9	:= 0
Local nQtdISC9	:= 0
Local nQRegCB8	:= 0
Local nQtdICB8	:= 0

cQuery += " SELECT * "
cQuery += " FROM " + RetSQLName("SC9") + " SC9 "
cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' "
cQuery += " 	AND C9_NFISCAL = ' ' "
//cQuery += "   AND C9_ORDSEP <> ' ' "			//Leonardo Flex -> dependendo do que for definido comentar essa linha
cQuery += " 	AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "		AND C9_BLEST = ' ' "
cQuery += "		AND C9_BLCRED = ' ' "

TCQuery cQuery New Alias "TMP"

dbSelectArea("TMP")
dbGoTop()
While TMP->( !Eof() )
	_lMarcado := (TMP->C9_OK == cMarca .And. lInverte) .Or. (TMP->C9_OK == cMarca .And. !lInverte)
	If _lMarcado
		// Função para validar se a CB8 contem a mesma quantidade de itens na SC9
		dbSelectArea("SC5")
		dbSetOrder(1)	// C5_FILIAL + C5_NUM
		If dbSeek(xFilial("SC5") + TMP->C9_PEDIDO) .And. Empty(SC5->C5_TRANSP)
			MsgAlert("Pedido " + AllTrim(TMP->C9_PEDIDO) + " sem transportadora informada.")
			lRet := .F.
			Exit
		EndIf
		If !EMPTY(SC5->C5_XPLAAPR)
			Alert("Este pedido não pode ser faturado manualmente, pois trata-se de um pedido de remessa de beneficiamento!")
			lRet := .F.
			Exit
		EndIf	
		SC6->( dbSetOrder(1) )	// C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
		If dbSeek(xFilial("SC6") + SC5->C5_NUM)
			If Posicione("SF4", 1, xFilial("SF4") + SC6->C6_TES, "F4_ESTOQUE") == "S"
				CB7->( dbSetOrder(1) )	// CB7_FILIAL + CB7_ORDSEP
				If Empty(TMP->C9_ORDSEP) .And. TMP->C9_LOCAL $ "01/03"
					MsgAlert("Pedido " + AllTrim(SC5->C5_NUM) + " utiliza TES que movimento estoque e não existe ordem de separação vinculada.")
					u_STWFFOSBE(TMP->C9_PEDIDO) // Chamada da função para envio do WorkFlow
					lRet := .F.
					Exit
				EndIf
				If SC6->C6_OPER == "35" // Chamado 004509 - Robson Mazzarotto
					PC1->( dbSetOrder(6) )	// PC1_FILIAL + PC1_PEDREP
					If dbSeek(xFilial("PC1") + SC5->C5_NUM)
						If PC1->PC1_STATUS <> "5"
							MsgAlert("Pedido " + AllTrim(SC5->C5_NUM) + " é referente a Fatec " + AllTrim(SC5->C5_NUM) + " que não foi finalizada, portanto não será permitido o faturamento.")
							lRet := .F.
							Exit
						EndIf
					EndIf
				EndIf
				If CB7->(dbSeek(xFilial("CB7") + TMP->C9_ORDSEP))// 20201222012726 - Everson Santana - 22.12.2020
					// Filtro a quantidade de registro e liberacao da Tabela SC9
					If Select("TMPC9") > 0
						TMPC9->( dbCloseArea() )
					EndIf
					cQryTab	:= " SELECT COUNT(*) QTD_REGC9, SUM(C9_QTDLIB) QTD_LIBC9 "
					cQryTab	+= " FROM " + RetSQLName("SC9")
					cQryTab	+= " WHERE D_E_L_E_T_ = ' ' "
					cQryTab	+= " 	AND C9_FILIAL = '" + xFilial("SC9") + "' "
					cQryTab	+= "	AND C9_ORDSEP = '" + TMP->C9_ORDSEP + "' "
					cQryTab	+= "	AND C9_PEDIDO = '" + TMP->C9_PEDIDO + "' "
					TCQuery cQryTab New Alias "TMPC9"
					nQRegSC9 := TMPC9->QTD_REGC9
					nQtdISC9 := TMPC9->QTD_LIBC9
					// Filtro a quantidade de registro e separacao da Tabela CB8
					If Select("TMPCB8") > 0
						TMPCB8->( dbCloseArea() )
					EndIf
					cQryTab	:= " SELECT COUNT(*) QTD_REGCB8, SUM(CB8_QTDORI) QTD_LIBCB8 "
					cQryTab	+= " FROM " + RetSQLName("CB8")
					cQryTab	+= " WHERE D_E_L_E_T_ = ' ' "
					cQryTab	+= "	AND CB8_FILIAL = '" + xFilial("CB8") + "' "
					cQryTab	+= "	AND CB8_ORDSEP = '" + TMP->C9_ORDSEP + "' "
					cQryTab	+= "	AND CB8_PEDIDO = '" + TMP->C9_PEDIDO + "' "
					TCQuery cQryTab New Alias "TMPCB8"
					nQRegCB8 := TMPCB8->QTD_REGCB8
					nQtdICB8 := TMPCB8->QTD_LIBCB8
					If nQRegSC9 != nQRegCB8 .Or. nQtdISC9 != nQtdICB8
						MsgAlert("Pedido: " + AllTrim(TMP->C9_PEDIDO) + Chr(10) + Chr(13) +;
								 "OS " + AllTrim(TMP->C9_ORDSEP) + Chr(10) + Chr(13) +;
								 "Com divergência entre as Tabelas SC9 x CB8.")
						lRet := .F.
						Exit
					EndIf
					If CB7->CB7_STATUS <> "4"
						MsgAlert("OS " + AllTrim(TMP->C9_ORDSEP) + " não foi embalada.")
						lRet := .F.
						Exit
					EndIf
				Else
					MsgAlert("OS " + AllTrim(TMP->C9_ORDSEP) + " não encontrada na tabela de ordem de separação.")
					lRet := .F.
					Exit
				EndIf
			EndIf
		EndIf
	EndIf
	dbSelectArea("TMP")
	TMP->( dbSkip() )
EndDo

TMP->( dbCloseArea() )

RestArea(aAreaCB8)
RestArea(aAreaCB7)
RestArea(aAreaSC9)
RestArea(aAreaSC6)
RestArea(aAreaSC5)

Return lRet
