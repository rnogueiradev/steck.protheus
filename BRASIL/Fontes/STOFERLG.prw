#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STOFERLG	ºAutor  ³Renato Nogueira     º Data ³  23/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para gravar informações logísticas no      º±±
±±º          ³pedido de venda					    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STOFERLG(_cFilial,_cPedido,_lCredito)

	Local _aAreaSC6	:= SC6->( GetArea() )
	Local _aArea1	:=	GetArea()

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )	// C5_FILIAL + C5_NUM
	SC5->( dbGoTop() )
	SC5->( dbSeek(_cFilial + _cPedido) )

	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )	// A1_FILIAL + A1_COD + A1_LOJA
	SA1->( dbGoTop() )
	SA1->( dbSeek(xFilial("SA1") + SC6->C6_CLI + SC6->C6_LOJA) )

	dbSelectArea('SC6')
	SC6->( dbSetOrder(1) )	// C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	SC6->( dbGoTop() )
	SC6->( dbSeek(_cFilial + _cPedido) )

	If SC5->( !Eof() ) .And. SA1->( !Eof() ) .And. SC6->( !Eof() )
		While SC6->( !Eof() ) .And. SC6->C6_FILIAL + SC6->C6_NUM == _cFilial + _cPedido
			SF4->( dbSetOrder(1) )
			SF4->( DbGoTop() )
			SF4->( dbSeek(xFilial("SF4") + SC6->C6_TES) )
		
			SB1->( dbSetOrder(1) )
			SB1->( dbGoTop() )
			SB1->( dbSeek(xFilial("SB1") + SC6->C6_PRODUTO) )
		
			ZZO->( dbSetOrder(1) )
			ZZO->( dbGoTop() )
			ZZO->( dbseek(xFilial("ZZO") + SB1->B1_ZCODOL) )
			If SF4->( !Eof() ) .And. SB1->( !Eof() )
				If SA1->A1_GRPVEN <> "ST" .And. SC5->C5_TIPO == "N" .And. SF4->F4_DUPLIC == "S" .And. SF4->F4_ESTOQUE == "S" .And. Empty(SC6->C6_ZDTEMIS);
				.And. Empty(SC6->C6_XVIRAOF)	// Grava data de emissão e prazo logistico		
					If ZZO->(!Eof())
						RecLock("SC6",.F.)
						SC6->C6_ZPROFL	:= ZZO->ZZO_PRAZO
						SC6->C6_ZDTEMIS	:= Date()
						MsUnLock()
					EndIf
				EndIf
				If SA1->A1_GRPVEN <> "ST" .And. SC5->C5_TIPO == "N" .And. SF4->F4_DUPLIC == "S" .And. SF4->F4_ESTOQUE == "S" .And. !Empty(SC6->C6_ZDTEMIS);
				.And. Empty(SC6->C6_XVIRAOF) .And. _lCredito .And. Empty(SC6->C6_ZDTLIBF)	// Caso já esteja com o financeiro liberado, grava liberação financeira				
					SC6->( RecLock("SC6",.F.) )
					SC6->C6_ZDTLIBF	:= Date()
					SC6->( MsUnlock() )
				EndIf
				If SA1->A1_GRPVEN <> "ST" .And. SC5->C5_TIPO == "N" .And. SF4->F4_DUPLIC == "S" .And. SF4->F4_ESTOQUE == "S" .And. !Empty(SC6->C6_ZDTEMIS) .And. !Empty(SC6->C6_ZPROFL);
				.And. !Empty(SC6->C6_ZDTLIBF) .And. SC6->(C6_QTDVEN-C6_QTDENT) > 0 .And. Empty(SC6->C6_BLQ) // Caso esteja com as datas, prazos logisticos e liberação financeira preenchida, coloca a data da oferta
				
					If AllTrim(SC5->C5_XTIPF) == "1" // Total
					//Fabio Lessa em 23/03/2015 
					//Se a data do novo item incluso for maior que a do pedido já gravado, devemos considerar essa nova data para todos os itens do pedido.
					//Se a data do novo item incluso for menor que a data do pedido já gravado, devemos considerar a data atual do pedido.
					//Com relação à data da liberação, a oferta deve contemplar o processo interno como um todo inclusive a análise de crédito do cliente. Portanto a data deve ser data de emissão + dias do maior item do pedido
					//Chamado 001546
						SC6->( RecLock("SC6",.F.) )
						SC6->C6_ZDTOL	:= DaySum(SC6->C6_ZDTLIBF,SC6->C6_ZPROFL)
						SC6->(MsUnlock())
						ATUOFLOG(SC5->C5_FILIAL,SC5->C5_NUM)
					ElseIf AllTrim(SC5->C5_XTIPF) == "2" // Parcial
						If !FWIsInCallStack("U_STTELPVL")
							If INCLUI
								SC6->( RecLock("SC6",.F.) )
								SC6->C6_ZDTOL	:= DaySum(SC6->C6_ZDTLIBF,SC6->C6_ZPROFL)
								SC6->( MsUnlock() )
								ATUOFLOG(SC5->C5_FILIAL,SC5->C5_NUM)
							Else
								If Empty(SC6->C6_ZDTOL)
									SC6->( RecLock("SC6",.F.) )
									SC6->C6_ZDTOL	:= DaySum(SC6->C6_ZDTLIBF,SC6->C6_ZPROFL)
									SC6->( MsUnlock() )
								EndIf
							EndIf
						Else
							If Empty(SC6->C6_ZDTOL)
								SC6->( RecLock("SC6",.F.) )
								SC6->C6_ZDTOL	:= DaySum(SC6->C6_ZDTLIBF,SC6->C6_ZPROFL)
								SC6->( MsUnlock() )
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			SC6->( dbSkip() )
		End
	EndIf

	RestArea(_aArea1)
	RestArea(_aAreaSC6)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ATUOFLOG	ºAutor  ³Renato Nogueira     º Data ³  26/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza data de oferta logística do pedido			      º±±
±±º          ³									    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ cFilial,cPedido                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ATUOFLOG(_cFilial,_cPedido)

	Local _aAreaSC6	:= SC6->( GetArea() )
	Local cQuery 	:= ""

	cQuery := " UPDATE " + RetSqlName("SC6") + " C6 "
	cQuery += " SET C6_ZDTOL = (SELECT MAX(C6_ZDTOL) DTOFLOG "
	cQuery += " 				FROM " + RetSqlName("SC6") + " C61 "
	cQuery += " 				WHERE C61.D_E_L_E_T_ = ' ' "
	cQuery += " 					AND C61.C6_FILIAL = '" + _cFilial + "' "
	cQuery += " 					AND C61.C6_NUM = '" + _cPedido + "') "
	cQuery += " WHERE C6.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND C6.C6_FILIAL = '" + _cFilial + "' "
	cQuery += " 	AND C6.C6_NUM = '" + _cPedido + "' "
	
	nErrQry := TCSqlExec( cQuery )

	If nErrQry <> 0
		MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
	EndIf
	
	RestArea(_aAreaSC6)

Return
