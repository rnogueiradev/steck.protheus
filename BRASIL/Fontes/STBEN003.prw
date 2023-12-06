#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} STBenped
Função para montar a tela de preenchimento da Transportador e Peso Liquido
@type function
@author Robson Mazzarotto
@since 22/12/2016
@version 1.0
/*/

User Function STBenped(cPedi,cTabPrcFor)
	Local aArea := GetArea()
	Private lRetorno := .T.

	Processa({|| lRetorno := NotaSBen(3,cPedi,cTabPrcFor)},'Gerando Nota .......')

	if lRetorno
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbGoTop()

		if dbSeek(xFilial("SC5")+cPedi)
			RecLock('SC5', .F.)
			SC5->C5_XPLAAPR	:= "S"
			SC5->C5_ZFATBLQ   := '1'
			SC5->(MsUnlock())
		Endif
	endif

	RestArea(aArea)

Return lRetorno



/*/{Protheus.doc} fVldUser
Função de validação da transportadora informada pelo usuario.
@type function
@author Robson Mazzarotto
@since 22/12/2016
@version 1.0
/*/
Static Function fVldUsr()

	Local cTraAux := Alltrim(cGetTra)

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbGoTop()

	if !dbSeek(xFilial("SA4")+cTraAux)
		cGetErr := "Tranportadora inválida!"
		oGetErr:Refresh()
		Return
	Else
		lRetorno := .T.
	Endif

	If lRetorno

		oDlgPvt:End()

	EndIf

Return

/*/{Protheus.doc} STLibP
Função de liberação do pedido de venda
@type function
@author Robson Mazzarotto
@since 22/12/2016
@version 1.0
/*/
User Function STLibP(cPedido)

	SC6->(DBSelectArea("SC6"))
	SC6->(DBSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+cPedido))

	Begin Transaction
		While SC6->C6_NUM == cPedido .AND. SC6->(!EOF())
			nRecno:=SC6->(RecNo())
			RecLock("SC6",.F.)
			MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN,.F.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
			SC6->C6_QTDLIB := SC6->C6_QTDVEN
			MaLiberOk({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))
			SC6->(dBSkip())
		EndDo

	End Transaction

Return .T.

/*/{Protheus.doc} NotaSBen
Função para gerar a nota fiscal de saida
@type function
@author Robson Mazzarotto
@since 22/12/2016
@version 1.0
/*/
Static Function NotaSBen(nOpc,_cPed,cTabPrcFor)
	Local cNumPed  := _cPed
	Local aPvlNfs  := {}
	Local _cNota   := ""
	Local _cSerie  := ""
	Local lRET     := .T.		// Valdemir Rabelo 24/07/2019
	//Local _cSerIbl := GETMV("SV_PCPA01",,'100')
	Local _cSerIbl := "001"
	Local _cPlanej := Posicione("SC5",1,xFilial("SC5")+_cPed,"C5_XPLAN")
	Local _cTpPla  := Posicione("ZZ8",1,xFilial("ZZ8")+_cPlanej,"ZZ8_TIPO")

	ProcRegua( 3 )
	PutMV("MV_INTGFE",.F.)

	IF _cTpPla <> "3"
		IncProc("Aguarde, Preparando dados para gerar solicitação de compra.")
		lRET := u_STGerPC(cNumPed,cTabPrcFor,_cPlanej)
		if !lRet
			Return lRet
		endif
	ENDIF

	PutMV("MV_INTGFE",.T.)

	SC9->(DbSetOrder(1))
	If SC9->(DbSeek(xFilial("SC9")+cNumPed))
		While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO == xFilial("SC9")+cNumPed)
			If SC9->C9_BLEST <> '10'
				Reclock("SC9",.F.)
				Replace C9_BLEST With ""
				Replace C9_BLCRED With ""
				MsUnlock()
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
						DbSelectArea("SE4")
						SE4->(DbSetOrder(1))
						If SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
							DbSelectArea("SB1")
							SB1->(DbSetOrder(1))
							If SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
								DbSelectArea("SB2")
								SB2->(DbSetOrder(1))
								If SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
									DbSelectArea("SF4")
									SF4->(DbSetOrder(1))
									If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
										Aadd(aPvlNfs,{;
										SC9->C9_PEDIDO,;
										SC9->C9_ITEM,;
										SC9->C9_SEQUEN,;
										SC9->C9_QTDLIB,;
										SC9->C9_PRCVEN,;
										SC9->C9_PRODUTO,;
										.F.,;
										SC9->(RecNo()),;
										SC5->(RecNo()),;
										SC6->(RecNo()),;
										SE4->(RecNo()),;
										SB1->(RecNo()),;
										SB2->(RecNo()),;
										SF4->(RecNo())})
										IncProc("Gerando Documento de Saída, Aguarde...")
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
			SC9->(Dbskip())
		EndDo
	Endif

	_cNota:=MaPvlNfs(aPvlNfs, _cSerIbl, .F., .F., .F., .T., .F., 0, 0, .F., .F.)
	_cNota	:= SF2->F2_DOC
	_cSerie	:= SF2->F2_SERIE

	If !Empty(Alltrim(_cNota))
	/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		dbSelectArea("SX1")
		If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"01")  // Busca a pergunta para mv_par03
			Reclock("SX1",.F.)
			Replace X1_CNT01 With SF2->F2_DOC
			MsUnlock()
		Endif
		If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"02")  // Busca a pergunta para mv_par03
			Reclock("SX1",.F.)
			Replace X1_CNT01 With SF2->F2_DOC
			MsUnlock()
		Endif
		If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"03")  // Busca a pergunta para mv_par03
			Reclock("SX1",.F.)
			Replace X1_CNT01 With _cSerie
			MsUnlock()
		Endif*/

		//	u_STGerPC(_cNota,_cSerie,cTabPrcFor,SC5->C5_XPLAN)
	Else
		MsgInfo("Nf Nao Gerada Verifique o Log.!!!")
		lRet := .F.
	EndIf

Return lRet

 
/*/{Protheus.doc} STGerPC
	Função para gerar o pedido de compra do beneficiamento
	@type function
	@author Robson Mazzarotto
	@since 23/12/2016
	@version 1.0
/*/
User Function STGerPC(cNumPV,cTabPre,cCodPla)

	//Local NumNota	:= cNota
	//Local NumSeri	:= cSerie
	Local lRet		:= .T.
	Local aCabSC7	:= {}
	Local aLinhaSC7	:= {}
	Local aItensSC1 := {}
	Local aItemSC7	:= {}
	Local aCabSC1	:= {}
	Local aLinhaSC1	:= {}
	Local aItemSC1	:= {}
	Local nopc		:= 3
	Local cNumPed	:= ""
	Local cDocSC1	:= ""
	Local aResult	:= {}
	Local nItem		:= 0
	Local nPreco	:= 0
	Local cOP       := ""
	Local cProdPai  := ""
	Local lErroSC	:= .F.
	Local aCodOp    := {}
	Local nLinOp
	Local aRegSD2:= {}
	Local aRegSE1:= {}
	Local aRegSE2:= {}
	Local lMostraCtb,lAglCtb,lContab,lCarteira
	//Local _cPedven := ""
	Local _cProdOP := ""
	Local _cDescPrd := ""
	Local _nContPOP := 1
	Local _cUsuaSol := ""
	Local _cOBSSOL  := ""
	Local _cUserSC7 := SuperGetMV("FS_USERSC7",.F.,"000039")

	Private lMsErroAuto := .F.

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGoTop()

	if dbSeek(xFilial("SC5")+cNumPV)

		Begin Transaction

			// Busca usuário Solicitante - Valdemir Rabelo 18/07/2019
			_cUsuaSol := Posicione("ZZ8",1,xFilial("ZZ8")+Alltrim(cCodPla),"ZZ8_USUARI") 		// Valdemir Rabelo 18/07/2019
			_cOBSSOL  := Posicione("ZZ8",1,xFilial("ZZ8")+Alltrim(cCodPla),"ZZ8_OBSERV") 		// Valdemir Rabelo 18/07/2019

			// Solicitação de Compra       
			cDocSC1 := GetSXENum("SC1","C1_NUM")
			SC1->(dbSetOrder(1))
			While SC1->(dbSeek(xFilial("SC1")+cDocSC1))
				ConfirmSX8()
				cDocSC1 := GetSXENum("SC1","C1_NUM")		// Trocado de cDOC para cDocSC1 - Valdemir Rabelo - 25/07/2019
			EndDo
			aadd(aCabSC1,{"C1_NUM"    	,cDocSC1})
			aadd(aCabSC1,{"C1_SOLICIT"	,UsrRetName( _cUsuaSol) })
			aadd(aCabSC1,{"C1_EMISSAO"	,dDataBase})
			aadd(aCabSC1,{"C1_USER"		,SC5->C5_XUSER})
		
			// Pedido de Compra            
			cNumPed := CriaVar("C7_NUM",.T.)

			AADD(aCabSC7,{"C7_FILIAL"	,xFilial("SC7") 																,Nil})
			AADD(aCabSC7,{"C7_NUM"		,cNumPed																		,Nil})
			AADD(aCabSC7,{"C7_EMISSAO"	,dDatabase																		,Nil})
			AADD(aCabSC7,{"C7_FORNECE"	,SC5->C5_CLIENTE  		  														,Nil})
			AADD(aCabSC7,{"C7_LOJA   "	,SC5->C5_LOJACLI   			  													,Nil})
			AADD(aCabSC7,{"C7_COND"		,U_STGetCond(SC5->C5_CLIENTE,SC5->C5_LOJACLI)									,Nil})
			AADD(aCabSC7,{"C7_CONTATO"	,Posicione("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A2_CONTATO"),Nil})
			AADD(aCabSC7,{"C7_FILENT"	,xFilial("SC7")																	,Nil})
			AADD(aCabSC7,{"C7_MOEDA"	,1																				,Nil})
			AADD(aCabSC7,{"C7_TXMOEDA"	,0																				,Nil})
			AADD(aCabSC7,{"C7_TIPO"		,1    																			,Nil})
			AADD(aCabSC7,{"C7_XPLAN"	,cCodPla        																,Nil}) // Codigo do Planejamento
			AADD(aCabSC7,{"C7_TPFRETE"  , "F" 																			,Nil})   // Valdemir Rabelo 17/02/2020

			dbSelectArea("SC6")
			dbSetOrder(1)
			dbGoTop()

			if dbSeek(xFilial("SC6")+cNumPV)

				WHILE !EOF() .AND. SC6->C6_NUM == cNumPV .AND. _nContPOP = 1
		
					aLinhaSC1	:= {}
					aLinhaSC7	:= {}
					nItem++

					IF Posicione("ZZ8",1,xFilial("ZZ8")+Alltrim(cCodPla),"ZZ8_TIPO") == '2' //Po OP
						_cProdOP  := Posicione("ZZ9",1,XFILIAL("ZZ9")+Alltrim(cCodPla), "ZZ9_OP")
						_cProdOP  := Posicione("SC2",1,XFILIAL("SC2")+Alltrim(_cProdOP), "C2_PRODUTO")
						cProdPai  := ALLTRIM(_cProdOP)+"SERV"
						cOP := Posicione("SC2",12,xFilial("SC2")+Alltrim(cCodPla)+ALLTRIM(_cProdOP), "C2_NUM+C2_ITEM+C2_SEQUEN")
						aAdd(aCodOp, {StrZero(nItem,len(SC1->C1_ITEM)), cOP}) //Gravar a Operacao no Final
						_nContPOP += 1
					ELSE
						_cProdOP := Alltrim(SC6->C6_PRODUTO)
						//cProdPai := Posicione("SG1",2,XFILIAL("SG1")+Alltrim(_cProdOP), "G1_COD")
						//cLotBen  := Posicione("SC6",1,XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+Alltrim(_cProdOP), "C6_XLOTBEN")
						cLotBen  := SC6->C6_XLOTBEN
						cOP := Posicione("SC2",13,xFilial("SC2")+Alltrim(cLotBen), "C2_NUM+C2_ITEM+C2_SEQUEN")
						aAdd(aCodOp, {StrZero(nItem,len(SC1->C1_ITEM)), cOP}) //Gravar a Operacao no Final
					ENDIF

					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+ALLTRIM(_cProdOP)+"SERV")

					_cDescPrd := SB1->B1_DESC

					// Valdemir Rabelo - 28/02/2020 - Ticket: 20200214000548 (Rotina de beneficamento) 
					dbSelectArea("SBZ")
					dbSetOrder(1)
					dbSeek(xFilial("SBZ")+ALLTRIM(_cProdOP)+"SERV")

					If Empty(cTabPre)
						nPreco := Posicione("SB2",1,xFilial("SB2")+ALLTRIM(_cProdOP)+"SERV"+SB1->B1_LOCPAD,"B2_CM1")
					Else
						nPreco := Posicione("AIB",2,xFilial("AIB")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+cTabPre+ALLTRIM(_cProdOP)+"SERV","AIB_PRCCOM")
					EndIf

					If nPreco == 0
						ApMsgInfo("Produto: " + ALLTRIM(_cProdOP)+"SERV sem preço na tabela de preços, verificar o pedido de compras.","Atenção")
						DisarmTransaction()
						lRet := .F.
						Exit
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//| Solicitação de Compra       |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aadd(aLinhaSC1,{"C1_ITEM"		,StrZero(nItem,len(SC1->C1_ITEM))	,Nil})
					aadd(aLinhaSC1,{"C1_PRODUTO"	,ALLTRIM(_cProdOP)+"SERV"			,Nil})
					aadd(aLinhaSC1,{"C1_QUANT"		,SC6->C6_QTDVEN						,Nil})
					aadd(aLinhaSC1,{"C1_MOTIVO"		,"IND"								,Nil})
					aadd(aLinhaSC1,{"C1_CC"			,"120208"							,Nil})
					aadd(aLinhaSC1,{"C1_FORNECE"	,SC5->C5_CLIENTE					,Nil})
					aadd(aLinhaSC1,{"C1_LOJA"		,SC5->C5_LOJACLI					,Nil})
					aadd(aLinhaSC1,{"C1_SOLICIT"	,_cUsuaSol  						,Nil})     // "paulo.cruz" - Valdemir Rabelo 18/07/2019
					aadd(aLinhaSC1,{"C1_USER"		,SC5->C5_XUSER						,Nil})
					aadd(aLinhaSC1,{"C1_OBS"		,_cOBSSOL							,Nil})	   // Valdemir Rabelo 18/07/2019
					aadd(aItensSC1,aLinhaSC1)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//| Pedido de Compra            |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aLinhaSC7,{"C7_ITEM"   	,StrZero(nItem,Len(SC7->C7_ITEM))												,Nil})
					AADD(aLinhaSC7,{"C7_PRODUTO" 	,ALLTRIM(_cProdOP)+"SERV"														,Nil})
					AADD(aLinhaSC7,{"C7_DESCRI" 	,_cDescPrd																		,Nil})
					AADD(aLinhaSC7,{"C7_QUANT"  	,SC6->C6_QTDVEN																	,Nil})
					AADD(aLinhaSC7,{"C7_COND"  		,U_STGetCond(SC5->C5_CLIENTE,SC5->C5_LOJACLI)									,Nil})
					AADD(aLinhaSC7,{"C7_CODTAB"  	,cTabPre																		,Nil})
					AADD(aLinhaSC7,{"C7_XPRCORC"  	,nPreco																			,Nil})
					AADD(aLinhaSC7,{"C7_PRECO"  	,nPreco																			,Nil})
					AADD(aLinhaSC7,{"C7_TOTAL"  	,ROUND((nPreco*SC6->C6_QTDVEN),2)												,Nil})
					AADD(aLinhaSC7,{"C7_MOTIVO"  	,"IND"																			,Nil})
					AADD(aLinhaSC7,{"C7_FILENT"  	,xFilial("SC7")																	,Nil})
					AADD(aLinhaSC7,{"C7_CC" 	 	,"120208"																		,Nil})
					AADD(aLinhaSC7,{"C7_XMODALI"	,"1"																			,Nil})
					AADD(aLinhaSC7,{"C7_DATPRF" 	,dDatabase+SBZ->BZ_PE  															,Nil})   // // Valdemir Rabelo 17/02/2020 - Confirmar se pega o PE DA SBZ Adicionado 28/02/2020
					AADD(aLinhaSC7,{"C7_UM"			,SB1->B1_UM																		,Nil})
					AADD(aLinhaSC7,{"C7_SEGUM"		,SB1->B1_SEGUM  																,Nil})  
					AADD(aLinhaSC7,{"C7_TOTAL"		,SC6->C6_QTDVEN * nPreco														,Nil})	 // Valdemir Rabelo 17/02/2020 - Confirmar
					AADD(aLinhaSC7,{"C7_IPI"		,0																				,Nil})
					AADD(aLinhaSC7,{"C7_LOCAL"		,SC6->C6_LOCAL																	,Nil})
					AADD(aLinhaSC7,{"C7_OBS"		,"Pedido gerado pela rotina de Planejamento de beneficiamento"					,Nil})
					AADD(aLinhaSC7,{"C7_FLUXO"		,"S"																			,Nil})
					AADD(aLinhaSC7,{"C7_TPFRETE"	,"C"																			,Nil})
					AADD(aLinhaSC7,{"C7_APROV"		,"000003"																		,Nil}) // Grupo de Aprovacao
					AADD(aLinhaSC7,{"C7_CONAPRO"	,"L"																			,Nil}) // Controle de Aprovacao
					AADD(aLinhaSC7,{"C7_USER"		,_cUserSC7																	,Nil}) // Codigo do Usuario
					AADD(aLinhaSC7,{"C7_NUMSC"		,cDocSC1																		,Nil})
					AADD(aLinhaSC7,{"C7_ITEMSC"		,StrZero(nItem,len(SC1->C1_ITEM))												,Nil})
					AADD(aItemSC7,aLinhaSC7)

					dbSelectArea("SC6")
					dbSkip()

				Enddo

				if !lRet
					Return lRet
				endif

			Endif

			IF len(aCabSC1) > 0
				IncProc("Gerando Solicitação de Compra: "+cDocSC1+", Aguarde...")
				MSExecAuto({|x,y| mata110(x,y)},aCabSC1,aItensSC1)

				SC1->(DbSetOrder(1))
				If SC1->(DbSeek(xFilial("SC1")+cDocSC1))
					lMsErroAuto := .F.
				Else
					lMsErroAuto := .T.
				EndIf

				If lMsErroAuto
					MostraErro()
					MsgAlert("Não foi possível gerar a solicitação de compra o processo de geração do pedido de compra será interrompido","Atenção")
					lErroSC := .T.
					DisarmTransaction()
					Return .F.
				Else
					SC1->(dbSetOrder(1))
					SC1->(dbSeek(xFilial("SC1") + cDocSC1))
					Do While !SC1->(EOF()) .And. SC1->C1_NUM == cDocSC1
						nLinOp := aScan(aCodOp, {|x| x[1] == SC1->C1_ITEM })
						SC1->(RecLock("SC1",.F.))
						SC1->C1_OP      := aCodOp[nLinOp, 2]
						SC1->C1_ZSTATUS := "3"
						SC1->C1_CODCOMP := ""
						SC1->(MsUnlock())
						SC1->(dbSkip())
					EndDo
				EndIf
			EndIf

			If !lErroSC
			
				IncProc("Gerando Pedido de Compra: "+cNumPed+", Aguarde...")

				IF len(aCabSC7) > 0 .And. !lMsErroAuto
				lMsErroAuto := .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ordena Cabeçalho e Itens Conforme Dicionário de Dados                 	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCabSC7		:= FWVetByDic(aCabSC7,"SC7",.F.)
				aItemSC7	:= FWVetByDic(aItemSC7,"SC7",.T.)

				MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabSC7,aItemSC7,3)

				Endif

				If lMsErroAuto
					MostraErro()
					Alert("Ocorreu um problema na geração de compra. Processo não será gravado, favor verifique.")
					DisarmTransaction()
					Return .F.					
				Else
					ConfirmSX8()

					cNumPed := SC7->C7_NUM

					SC7->(dbSetOrder(1))
					SC7->(dbSeek(xFilial("SC7") + cNumPed))
					Do While !SC7->(EOF()) .And. SC7->C7_NUM == cNumPed
						nLinOp := aScan(aCodOp, {|x| x[1] == SC7->C7_ITEM })
						SC7->(RecLock("SC7",.F.))
						SC7->C7_OP := aCodOp[nLinOp, 2]
						SC7->(MsUnlock())
						SC7->(dbSkip())
					EndDo


				/*
					Envia e-mail aos responsáveis informando a geração do pedido de vendas
					pelo planejamento de beneficiamento				
				*/
					U_ST001WFPed( "", AllTrim(SC5->C5_CLIENTE)+"/"+AllTrim(SC5->C5_LOJACLI), 2, cDocSC1, cNumPed )

					dbSelectAREA("SC1")
					SC1->(dbSetOrder(1))
					SC1->(dbGoTop())
					SC1->(dbSeek(xFilial("SC1") + cDocSC1))
					Do While !SC1->(EOF()) .And. SC1->C1_NUM == cDocSC1
						nLinOp := aScan(aCodOp, {|x| x[1] == SC1->C1_ITEM })
						SC1->(RecLock("SC1",.F.))
						SC1->C1_QUJE      := SC1->C1_QUANT
						SC1->(MsUnlock())
						SC1->(dbSkip())
					EndDo

				Endif

			Endif

		End Transaction

		if lRet
			Aviso('Atenção', 'Transacao Finalizada com Sucesso. Pedido de compra ' + cNumPed + ' incluido com Sucesso!' , {'OK'}, 03)
		endif

	Else
		FWMsgRun(, {|| Sleep(3000)},"Atenção!", "Pedido de Venda: "+Alltrim(cNumPV)+" não encontrado")
		lRET := .F.
	Endif

Return lRET


/*/{Protheus.doc} STGetTab
Função para retornar a tabela de preço ativa do fornecedor
@author Leonardo Kichitaro
@since 28/01/2016
/*/
User Function STGetTab(cCodFor,cLojFor)

	Local cRetTab		:= ""

	//Default cTabPreco	:= Space(TamSx3("AIA_CODTAB")[1])

	AIA->(dbSetOrder(1))	//AIA_FILIAL+AIA_CODFOR+AIA_LOJFOR+AIA_CODTAB
	AIA->(dbSeek(xFilial("AIA")+cCodFor+cLojFor))
	While !AIA->(Eof()) .And. AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR == xFilial("AIA")+cCodFor+cLojFor
		If dDataBase >= AIA->AIA_DATDE .And. dDataBase <= AIA->AIA_DATATE
			cRetTab := AIA->AIA_CODTAB
			Exit
		EndIf

		AIA->(dbSkip())
	EndDo

Return cRetTab

/*/{Protheus.doc} STGetTab
Função para retornar a tabela de preço ativa do fornecedor
@author Leonardo Kichitaro
@since 28/01/2016
/*/
User Function STGetCond(cCodFor,cLojFor)

	Local cRetTab		:= ""

	//Default cTabPreco	:= Space(TamSx3("AIA_CODTAB")[1])

	AIA->(dbSetOrder(1))	//AIA_FILIAL+AIA_CODFOR+AIA_LOJFOR+AIA_CODTAB
	AIA->(dbSeek(xFilial("AIA")+cCodFor+cLojFor))
	While !AIA->(Eof()) .And. AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR == xFilial("AIA")+cCodFor+cLojFor
		If dDataBase >= AIA->AIA_DATDE .And. dDataBase <= AIA->AIA_DATATE
			cRetTab := AIA->AIA_CONDPG
			Exit
		EndIf

		AIA->(dbSkip())
	EndDo

Return cRetTab
