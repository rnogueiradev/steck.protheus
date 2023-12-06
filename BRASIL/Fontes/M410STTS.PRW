#INCLUDE 'PROTHEUS.CH'
#DEFINE CR    chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410STTS  บAutor  ณMicrosiga           บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste ponto de entrada pertence เ rotina de pedidos de venda,บฑฑ
ฑฑบ          ณMATA410(). Estแ em todas as rotinas de altera็ใo, inclusใo, บฑฑ
ฑฑบ          ณexclusใo e devolu็ใo de compras. Executado ap๓s todas as    บฑฑ
ฑฑบ          ณaltera็๕es no arquivo de pedidos terem sido feitas.         บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gravar falta/reserva na alteracao do pedido de  บฑฑ
ฑฑบ          ณvenda MATA410                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M410STTS()

	Local _Lmomat 		:= IsInCallSteck("U_STFAT15")
	Local _aArea  		:= GetArea()
	Local _aArea1
	Local _lret   		:= Altera
	Local _cOerFalRes   := GetMv("ST_OPRESFA",,"94/74")
	Local _cXPed  		:= ''
	//Local lCredito      := .F.
	Local _cConPag      := GetMv("ST_STTS01",,"501/599/FRC")
	Local _cTpOper      := GetMv("ST_STTS02",, '36/37')
	Local _aGrupos		:= {}
	Local _lEnvGrp		:= .F.
	Local _STCLITRA 	:= SuperGetMV("ST_CLITRAN",.F.,"03346703") // Chamado 005430 - Robson Mazzarotto
	Local _cSeekSc6		:= ' '
	Local aItens        :={}
	Local nx            :=0
	Local lBloqPed      :=.F.
	//Local _aProduto     := {}
	Local lAgPortal     := GetMv("STADDAGEPD",,.T.) // Valdemir Rabelo 16/03/2021 - Chamado: 20210211002338
	Private _lTrocNf    := ! Empty(Alltrim(SC5->C5_XTRONF))//giovani zago 27/01/2014 troca de nf
	Private lINCLUI     := INCLUI		//FR - 09/11/2022 - indica se ้ inclusใo do pedido de venda, usado na fun็ใo STLOGFIN para gravar a data emissใo e hora emissใo

	If !_Lmomat
		U_STDESALC(Inclui,Altera)//Giovani Zago 18/12/13 Al็ada Comercial
		DbSelectArea('SC6')
		SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

			if cFilAnt = "04" // Adicionado por Robson Mazzarotto para tratar os pedidos de transferencia entre filials somente do CD para a Fabrica
				_cOerFalRes += ",94"
			Endif

			STFSCDel() // Funcao para Deletar registros do PA1 e PA2 que nao possuem SC6 referente.

			If (_lRet  .And.  !(SC6->C6_OPER $ _cOerFalRes)   .And.  !_lTrocNf )

				_cSeekSc6:= ' '
				DbSelectArea('SC6')
				SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

				If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

					do While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

						// FMT - CONSULTORIA - INICIO
						// GRAVAR O LOCAL DESTINO CONFORME O CLIENTE - PROJETO MRP

						SA1->(DBSEEK(XFILIAL("SA1") + SC6->C6_CLI + SC6->C6_LOJA ))

						IF !EMPTY(SA1->A1_XDESTIN) .AND. (SC6->C6_LOCAL # SA1->A1_XDESTIN)
							RecLock("SC6",.F.)
							SC6->C6_LOCAL := SA1->A1_XDESTIN
							SC6->(MsUnlock())
						Endif

						IF !SB2->(DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
							CriaSb2(SC6->C6_PRODUTO,SC6->C6_LOCAL) //Cria saldo zero na SB2
						Endif

						// FMT - CONSULTORIA - FIM

						_cSeekSc6:= xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM
						dbSelectArea("SC9")
						SC9->(	dbSetOrder(1) )
						SC9->(	dbGoTop( ) )
						If	!(SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)))
							MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,.F.,.T.,.F.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
							MaLiberOk({SC6->C6_NUM},.F.)
							MsUnLockall()
							dbcommitall()
						EndIf
						If  _cSeekSc6  <> xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM
							SC6->(DbSeek(_cSeekSc6))
						Endif

						dbSelectArea("SC9")
						SC9->(	dbSetOrder(1) )
						SC9->(	dbGoTop( ) )
						If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))

							While SC9->(!Eof()) .And. SC9->C9_PEDIDO==SC6->C6_NUM .And. SC9->C9_ITEM==SC6->C6_ITEM .And. SC9->C9_FILIAL==SC6->C6_FILIAL //Ajustado em 29/05/2014 - Nใo estava fazendo while na SC9

								If	Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)

									a460estorna()

								Else

									SC9->(DbSkip())
									Loop

								EndIf

								SC9->(DbSkip())

							End

						EndIf

						// Robson Mazzarotto - chamado 006181

						if SC5->C5_CLIENTE+SC5->C5_LOJACLI $ _STCLITRA
							//lCredito := .T.
							lBloqPed:=.F. //  Nใo bloqueia o pedido. 
						ElseIf AllTrim(SC5->C5_XORIG)=="2" //Pedido marketplace jแ desce pago
							//lCredito := .T.
                            lBloqPed:=.F. //  Nใo bloqueia o pedido. 
						elseIf  SC5->C5_TIPO $ "DB"//Chamado 001768
							lBloqPed:=.F. //  Nใo bloqueia o pedido. 
							//lCredito := .T.
							//giovani zago bloquear pedido sem serasa e serasa vencido 17/08/18 007862
						ElseIf !(Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA")));
							.AND.  dDataBase > (Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA") + getmv("ST_FINLIB3",,160) )
							lBloqPed:=.T.
						ElseIf  Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA"))
							lBloqPed:=.T. // Data do serasa vazia bloqueia o pedido. 
							//lCredito := .F.
							////////////////////////
						ElseIf SC5->C5_CONDPAG $ _cConPag .or. SC5->C5_ZCONDPG $ _cConPag
							//lCredito := .F.
						    lBloqPed:=.T. // Estas condi็๕es de Pagamento Bloqueia o Pedido. 
						ElseIf SC6->C6_OPER $ _cTpOper
							//lCredito := .T.
						    lBloqPed:=.F. // Estas opera็๕es nใo bloqueia o pedido. 
						ElseIf !Empty(SC5->C5_PEDEXP)
							//lCredito := .F.
                            lBloqPed:=.F. // Pedido exporta็ใo nใo bloqueia. 
						Else  // Caso nใo tenha passado nas condi็๕es acima avalia o credito conforme as regras. 
						    IF ALLTRIM(SA1->A1_RISCO) $ 'A/B/C'
							   lBloqPed := VerCred(SC6->C6_CLI,SC6->C6_VALOR)
							ELSEIF ALLTRIM(SA1->A1_RISCO) $ 'D/E'
                               lBloqPed := .T. // Sempre Bloqueia para libera็ใo manual 
							ELSE 
							   lBloqPed := .T. // Outros riscos tb. bloquea sempre 
							ENDIF  
							//lCredito := MaAvalCred(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_VALOR,SC5->C5_MOEDA,.F.) //u_XMaAvalCred VERIFICA A libera็ใo
						EndIf

						//----------------------------------------------------------------------------------------------------------------------------------------//
						//FR - 09/11/2022 - TICKET #20220622012634 - Solicita que seja mostrada a hora de emissใo do pedido de venda
						//a variแvel lINCLUI indica se o pedido no momento a ser gravado ้ por inclusใo ou altera็ใo
						//se inclusใo, lINCLUI = .T. , se altera็ใo, lINCLUI = .F.
						//com isso, quando for gravar na tabela SZA, irแ gravar os campos ZA_DTEMI e ZA_HREMI quando for inclusใo, a fim de saber a data e hora
						//da inclusใo do pedido de Venda
						//----------------------------------------------------------------------------------------------------------------------------------------//
						U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,!lBloqPed,.T.,lINCLUI)
						u_LOGJORPED("SC6","1",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Inclusao/Alteracao Pedido")

						MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,!lBloqPed,.T.,.F.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
						MaLiberOk({SC6->C6_NUM},.F.)
						MsUnLockall()
						dbcommitall()

						If  _cSeekSc6  <> xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM
							SC6->(DbSeek(_cSeekSc6))
						Endif

						SC6->(DbSkip())

					Enddo

					If !lBloqPed
						u_STC9LIB('','',cusername,dtoc(date()),time(),'')
					EndIf

					_aArea1 := GetArea()	//Renato 040713 - Ajuste unidade de medida

					If Empty(SC6->C6_UM)
						DbSelectArea("SB1")
						DbSetOrder(1) //B1_FILIAL+B1_COD
						DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
						If !SB1->(Eof())
							RecLock("SC6",.F.)
							SC6->C6_UM	:= SB1->B1_UM
							MsUnLock()
						EndIf
					EndIf

					RestArea(_aArea1)    	//Renato 040713 - Ajuste unidade de medida

				Endif

				//	ElseIf 	(SC6->C6_OPER $ _cOerFalRes .And. xFilial("SC6") = '01') .or. SC6->C6_OPER $ '74'
			ElseIf 	(SC6->C6_OPER $ _cOerFalRes ) .Or. _lTrocNf

				If	_lTrocNf
					DbSelectArea('SC6')
					SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)) .And. SC6->C6_LOCAL = '60'
						If !IsInCallStack("EECAP100")
							FatPed(SC5->C5_NUM)
						EndIf
					Endif
				Endif
				DbSelectArea('SC6')
				DbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				DbGotop()
				If DbSeek(xFilial("SC6")+SC5->C5_NUM)
					While !Eof() .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

						// FMT - CONSULTORIA - INICIO
						// GRAVAR O LOCAL DESTINO CONFORME O CLIENTE - PROJETO MRP

						SA1->(DBSEEK(XFILIAL("SA1") + SC6->C6_CLI + SC6->C6_LOJA ))

						IF !EMPTY(SA1->A1_XDESTIN) .AND. (SC6->C6_LOCAL # SA1->A1_XDESTIN)
							RecLock("SC6",.F.)
							SC6->C6_LOCAL := SA1->A1_XDESTIN
							SC6->(MsUnlock())
						Endif

						IF !SB2->(DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
							CriaSb2(SC6->C6_PRODUTO,SC6->C6_LOCAL) //Cria saldo zero na SB2
						Endif

						// FMT - CONSULTORIA - FIM

						_cSeekSc6:= xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM

						dbSelectArea("SC9")
						dbSetOrder(1)
						DbGotop()
						If	dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
							a460estorna()
						EndIf
						DbSelectArea('SC6')
						MaLiberOk({SC6->C6_NUM},.F.)
						MsUnLockall()

						STSDCExc(SC6->C6_NUM,SC6->C6_PRODUTO,'03',SC6->C6_QTDVEN-SC6->C6_QTDENT,SC6->(RECNO()),{},'')

						dbSelectArea("SC9")
						dbSetOrder(1)
						dbGotop()
						If	dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
							DbSelectArea("SDC")
							DbSetOrder(1)
							If DbSeek(xFilial("SDC")+SC6->C6_PRODUTO+SC6->C6_LOCAL+'SC6'+SC6->C6_NUM+SC6->C6_ITEM)

								SC9->(RecLock("SC9",.F.))
								SC9->C9_BLEST   := ' '
								SC9->C9_BLcred  := ' '
								SC9->(MsUnlock())
								SC9->(DbCommit())
								DbSelectArea('SC6')
								MaLiberOk({SC6->C6_NUM},.F.)
								MsUnLockall()
							Endif
						Endif

						//If  _cSeekSc6  <> xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM
						//	SC6->(DbSeek(_cSeekSc6))
						//	Endif
						//DbSelectArea('SC6')
						//DbSkip()

						//_aArea1 := GetArea()		//Renato 040713 - Ajuste unidade de medida
						DbSelectArea('SC6')

						If Empty(SC6->C6_UM)
							DbSelectArea("SB1")
							DbSetOrder(1) //B1_FILIAL+B1_COD
							DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
							If !SB1->(Eof())
								RecLock("SC6",.F.)
								SC6->C6_UM	:= SB1->B1_UM
								MsUnLock()
							EndIf
						EndIf

						//RestArea(_aArea)			//Renato 040713 - Ajuste unidade de medida

						DbSelectArea('SC6')
						DbSkip()

					End
				Endif
			ElseIf (!_lRet  .And.  !(SC6->C6_OPER $ _cOerFalRes)   .And.  !_lTrocNf )

				DbSelectArea('SC6')
				SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
					While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

						// FMT - CONSULTORIA - INICIO
						// GRAVAR O LOCAL DESTINO CONFORME O CLIENTE - PROJETO MRP

						SA1->(DBSEEK(XFILIAL("SA1") + SC6->C6_CLI + SC6->C6_LOJA ))

						IF !EMPTY(SA1->A1_XDESTIN) .AND. (SC6->C6_LOCAL # SA1->A1_XDESTIN)
							RecLock("SC6",.F.)
							SC6->C6_LOCAL := SA1->A1_XDESTIN
							SC6->(MsUnlock())
						Endif

						IF !SB2->(DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
							CriaSb2(SC6->C6_PRODUTO,SC6->C6_LOCAL) //Cria saldo zero na SB2
						Endif

						// FMT - CONSULTORIA - FIM

						_cSeekSc6:= xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM

						dbSelectArea("SC9")
						SC9->(	dbSetOrder(1) )
						If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))

							While SC9->(!Eof()) .And. SC9->C9_PEDIDO==SC6->C6_NUM .And. SC9->C9_ITEM==SC6->C6_ITEM .And. SC9->C9_FILIAL==SC6->C6_FILIAL //Ajustado em 29/05/2014 - Nใo estava fazendo while na SC9

								If	Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)

									a460estorna()

								Else

									SC9->(DbSkip())
									Loop

								EndIf

								SC9->(DbSkip())

							EndDo

						EndIf


						If AllTrim(SC5->C5_XORIG)=="2" //Pedido marketplace jแ desce pago
							//lCredito := .T.
                            lBloqPed:=.F. //  Nใo bloqueia o pedido. 
						elseIf  SC5->C5_TIPO $ "DB"//Chamado 001768
							lBloqPed:=.F. //  Nใo bloqueia o pedido. 
							//lCredito := .T.
							//giovani zago bloquear pedido sem serasa e serasa vencido 17/08/18 007862
						ElseIf !(Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA")));
							.AND.  dDataBase > (Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA") + getmv("ST_FINLIB3",,160) )
							lBloqPed:=.T.
						ElseIf  Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA"))
							lBloqPed:=.T. // Data do serasa vazia bloqueia o pedido. 
							//lCredito := .F.
							////////////////////////
						ElseIf SC5->C5_CONDPAG $ _cConPag .or. SC5->C5_ZCONDPG $ _cConPag
							//lCredito := .F.
						    lBloqPed:=.T. // Estas condi็๕es de Pagamento Bloqueia o Pedido. 
						ElseIf SC6->C6_OPER $ _cTpOper
							//lCredito := .T.
						    lBloqPed:=.F. // Estas opera็๕es nใo bloqueia o pedido. 
						ElseIf !Empty(SC5->C5_PEDEXP)
							//lCredito := .F.
                            lBloqPed:=.F. // Pedido exporta็ใo nใo bloqueia. 
						Else  // Caso nใo tenha passado nas condi็๕es acima avalia o credito conforme as regras. 
						    IF ALLTRIM(SA1->A1_RISCO) $ 'A/B/C'
							   lBloqPed := VerCred(SC6->C6_CLI)
							ELSEIF ALLTRIM(SA1->A1_RISCO) $ 'D/E'
                               lBloqPed := .T. // Sempre Bloqueia para libera็ใo manual 
							ELSE 
							   lBloqPed := .T. // Outros riscos tb. bloquea sempre 
							ENDIF  
							//lCredito := MaAvalCred(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_VALOR,SC5->C5_MOEDA,.F.) //u_XMaAvalCred VERIFICA A libera็ใo
						EndIf

						U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,!lBloqPed,.T.,lINCLUI)
						u_LOGJORPED("SC6","1",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Inclusao/Alteracao Pedido")

						If !lBloqPed
							u_STC9LIB('','',cusername,dtoc(date()),time(),'')
						EndIf

						MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,!lBloqPed,.T.,.F.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
						MaLiberOk({SC6->C6_NUM},.F.)
						MsUnLockall()
						dbcommitall()

						If  _cSeekSc6  <> xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM
							SC6->(DbSeek(_cSeekSc6))
						Endif

						SC6->(DbSkip())

					End
				EndIf

			Endif
		Endif
		_cXPed:= SC5->C5_NUM
		DbSelectArea('SC6')
		SC6->(DbSetOrder(1))
		If cEmpant = '01' .And. cfilant = '01' .And. SC6->(DbSeek("01"+_cXPed)) .and. SC6->C6_OPER = '01'
			u_STxIBLMAIL('','',cusername,dtoc(date()),time(),'')
		Endif

	Endif

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

			// FMT - CONSULTORIA - INICIO
			// GRAVAR O LOCAL DESTINO CONFORME O CLIENTE - PROJETO MRP

			SA1->(DBSEEK(XFILIAL("SA1") + SC6->C6_CLI + SC6->C6_LOJA ))

			IF !EMPTY(SA1->A1_XDESTIN) .AND. (SC6->C6_LOCAL # SA1->A1_XDESTIN)
				RecLock("SC6",.F.)
				SC6->C6_LOCAL := SA1->A1_XDESTIN
				SC6->(MsUnlock())
			Endif

			IF !SB2->(DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
				CriaSb2(SC6->C6_PRODUTO,SC6->C6_LOCAL) //Cria saldo zero na SB2
			Endif

			// FMT - CONSULTORIA - FIM

			If !(SC6->C6_OPER $ _cOerFalRes)
				If !_lTrocNf
					/*************************************************************
					<<< ALTERAวรO >>> 
					A็ใo...........: Nใo efetuar mais a reserva para a empresa 11 - Distribuidora somente quando o Tipo de Opera็ใo for "DIFERENTE" de "01"
					...............: A reserva irแ ser gerada atrav้s de um novo JOB
					Regra..........: Se o Tipo de Opera็ใo for "IGUAL A 01 NรO EFETUA A RESERVA" 
					...............: Se o Tipo de Opera็ใo for "DIFERENTE DE 01 EFETUA A RESERVA" 
					Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
					Data...........: 29/04/2022
					Chamado........: 20220429009114 - OFERTA LOGISTICA
					*************************************************************/				
					If ALTERA
						U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO) //Deleta falta e reserva
						U_STDELZ96(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,.F.) // Deleta Z96 e atualiza ZA6_CONSUM se for importado. 
					EndIf
				EndIf
			EndIf

			If SC5->C5_CLIENTE = '006596' .And.;
					( Alltrim(SC6->C6_PRODUTO) == 'S4506DJ' .or.;
					Alltrim(SC6->C6_PRODUTO) == 'S3006D02' .or.;
					Alltrim(SC6->C6_PRODUTO) == 'S4506D15' .or.;
					Alltrim(SC6->C6_PRODUTO) == 'S4506D24')

				cMsg:= ' '
				cMsg:= 'Pedido: '+SC5->C5_NUM+' da Nortel possui o Produto: '+Alltrim(SC6->C6_PRODUTO)
				U_STMAILTES('marcelo.oliveira@steck.com.br', '', cMsg, cMsg,'')

			EndIf
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				If AllTrim(SB1->B1_GRUPO) $ "039#040#041#042#047" //aqui
					AADD(_aGrupos,{SB1->B1_COD,SB1->B1_GRUPO})
					_lEnvGrp	:= .T.
				EndIf
			EndIf

			dbSelectArea("SC9")
			SC9->(	dbSetOrder(1) )
			If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))

				If	_lTrocNf
					SC9->(RecLock("SC9",.F.))
					SC9->C9_BLEST   := ' '
					SC9->C9_BLcred  := ' '
					SC9->(MsUnlock())
					SC9->(DbCommit())
				ElseIf Posicione("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_DUPLIC") == "N" .And. Empty(Alltrim(SC5->C5_PEDEXP))
					If !SC5->C5_CONDPAG $ _cConPag //Ticket 20201030009774 - Everson Santana - 04.11.2020
						SC9->(RecLock("SC9",.F.))
						SC9->C9_BLcred  := ' '
						SC9->(MsUnlock())
						SC9->(DbCommit())
					Endif
				EndIF
			Endif
			SC6->(DbSkip())
		End
		
		// Ao final valida se ficaram itens pendente para este pedido na tabela Z96 devido a exclusใo de item 
	    If !_lTrocNf .AND. ALTERA
           aItens:=BuscaDelSC6(SC5->C5_NUM)
           FOR NX:=1 TO LEN(aItens)
               If !(aItens[nx,4] $ _cOerFalRes)
                  U_STDELZ96(SC5->C5_FILIAL,aItens[nx,1],aItens[nx,2],.T.) 
			   ENDIF	  	 
   		   NEXT    
		ENDIF   
	Endif

	/*
	If	_lTrocNf
	RecLock("SC5",.F.)
	SC5->C5_ZBLOQ        := "2"
	SC5->C5_ZMOTBLO      := ' '
	SC5->(MsUnLock())
	Endif
	*/
					If	(SC5->C5_TPFRETE = 'F' .Or. SC5->C5_TPFRETE = 'C' .And. SC5->C5_XTIPO = '1') .And. SC5->C5_TRANSP = '000163' // BLOQUEAR TNT/FOB CHAMADO     GIOVANI ZAGO 09/09/2015
						RecLock("SC5",.F.)
						SC5->C5_XTNTFOB  := "1"
						SC5->(MsUnLock())
					Endif

					If _lEnvGrp
						U_STEMLGRP("PEDIDO",SC5->C5_NUM,_aGrupos,SC5->C5_VEND1)
					EndIf

					U_STOFERLG(SC5->C5_FILIAL,SC5->C5_NUM,.T.) //Carregar informa็๕es da oferta logํstica - Renato Nogueira - 28/05/2014

					//Chamado 008952
					If SC5->C5_TIPO=="N" .And. cEmpAnt=="01"
						DbSelectArea("SA1")
						SA1->(DbSetOrder(1))
						If SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
							If AllTrim(SA1->A1_XEAN14O)=="S"
								SC5->(RecLock("SC5",.F.))
								SC5->C5_XOBSEXP  := "EAN14"
								SC5->(MsUnLock())
							EndIf

							//20190507000024
							If !U_STFAT340("4","T")
								SC5->(RecLock("SC5",.F.))
								SC5->C5_XREAN14  := "1"
								SC5->(MsUnLock())
							EndIf

						EndIf
					EndIf
					//>> Ticket 20200522002403
					If ! IsInCallSteck("EECAP100")
						SC5->(RecLock("SC5",.F.))
						U_STFAT150()
						SC5->(MsUnLock())

						//Ticket 20191111000018
						SC5->(RecLock("SC5",.F.))
						SC5->C5_EMISSAO := DataValida(SC5->C5_EMISSAO)
						SC5->(MsUnLock())
					EndIf
					//<< 20200522002403

					if lAgPortal .and. (SC5->C5_XTIPO=='1') .And. IsBlind() // Valdemir Rabelo 16/03/2021 - Ticket: 20210211002338
						U_ADDAGEPD()
					endif

					//20200703003709
					U_STFAT190()

					// ---- Valdemir Rabelo 30/03/2020 - ticket Nบ 20191218000007 ----------------------------
					IF INCLUI .or. ALTERA
						U_STVLDZ68("SC5", "SC6", INCLUI, ALTERA)
					Endif
					// ----------------------------------------------------------------------------------------

					SC5->(RecLock("SC5",.F.))
					SC5->C5_XVENDA := U_STAVALVD()
					SC5->(MsUnLock())

					If cEmpAnt=="01" .And. SC5->C5_FILIAL=="05" .And. SC5->C5_XVENDA=="N" //20220614012140
						SC5->(RecLock("SC5",.F.))
						SC5->C5_ZBLOQ 	:= "2"
						SC5->C5_ZMOTBLO := ""
						SC5->(MsUnLock())
					EndIf

					RestArea(_aArea)

					Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSCDel  บAutor  ณVitor Merguizo      บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Deleta compara reserva ou falta com pedido e deleta        บฑฑ
ฑฑบ          ณ Registros que nao possuem itens do pedido                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STFSCDel()

	Local _aAreaSC5	:= SC5->(GetArea())
	Local _aAreaPA1	:= PA1->(GetArea())
	Local _aAreaPA2	:= PA2->(GetArea())
	Local cQuery	:= ""
	Local cAlias	:= "QRYDELPA"

	//Cria Query
	cQuery := " SELECT 'PA1' PA_TAB,PA1_FILIAL FILIAL,PA1_CODPRO CODPRO,PA1_DOC DOC,'' FILRES "
	cQuery += " FROM "+RetSqlName("PA1")+" PA1 "
	cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6 ON PA1_FILIAL=C6_FILIAL AND PA1_CODPRO=C6_PRODUTO AND "
	cQuery += " SUBSTR(PA1_DOC,1,"+cValtochar(Len(SC5->C5_NUM))+")=C6_NUM AND "
	cQuery += " SUBSTR(PA1_DOC,"+cValtochar(Len(SC5->C5_NUM)+1)+","+cValtochar(Len(SC6->C6_ITEM))+")=C6_ITEM AND SC6.D_E_L_E_T_= ' ' "
	cQuery += " WHERE "
	cQuery += " PA1_FILIAL = '"+xFilial("PA1")+"' AND "
	cQuery += " SUBSTR(PA1_DOC,1,"+cValtoChar(Len(SC5->C5_NUM))+") = '"+SC5->C5_NUM+"' AND "
	cQuery += " PA1_TIPO = '1' AND "
	cQuery += " PA1.D_E_L_E_T_ = ' ' AND "
	cQuery += " C6_NUM IS NULL "
	cQuery += " UNION ALL "
	cQuery += " SELECT 'PA2' PA_TAB,PA2_FILIAL FILIAL,PA2_CODPRO CODPRO,PA2_DOC DOC,PA2_FILRES FILRES "
	cQuery += " FROM "+RetSqlName("PA2")+" PA2 "
	cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6 ON PA2_FILRES=C6_FILIAL AND PA2_CODPRO=C6_PRODUTO AND "
	cQuery += " SUBSTR(PA2_DOC,1,"+cValtochar(Len(SC5->C5_NUM))+")=C6_NUM AND "
	cQuery += " SUBSTR(PA2_DOC,"+cValtochar(Len(SC5->C5_NUM)+1)+","+cValtochar(Len(SC6->C6_ITEM))+")=C6_ITEM AND SC6.D_E_L_E_T_= ' ' "
	cQuery += " WHERE "
	cQuery += " PA2_FILIAL = '"+xFilial("PA2")+"' AND "
	cQuery += " PA2_FILRES = '"+SC5->C5_FILIAL+"' AND "
	cQuery += " SUBSTR(PA2_DOC,1,"+cValtochar(Len(SC5->C5_NUM))+") = '"+SC5->C5_NUM+"' AND "
	cQuery += " PA2_TIPO = '1' AND "
	cQuery += " PA2.D_E_L_E_T_ = ' ' AND "
	cQuery += " C6_NUM IS NULL "

	cQuery := ChangeQuery(cQuery)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha Alias se estiver em Uso ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta Area de Trabalho executando a Query ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
		If (cAlias)->PA_TAB = "PA1"
			DbSelectArea("PA1")
			PA1->(DbSetOrder(2))
			If PA1->(DbSeek((cAlias)->FILIAL+"1"+(cAlias)->(DOC+CODPRO)))
				RecLock("PA1", .F.)
				PA1->(dbDelete())
				PA1->(MsUnLock())
			EndIf
		ElseIf (cAlias)->PA_TAB = "PA2"
			DbSelectArea("PA2")
			PA2->(DbSetOrder(2))
			If PA2->(DbSeek((cAlias)->FILIAL+"1"+(cAlias)->(DOC+CODPRO+FILRES)))
				RecLock("PA2", .F.)
				PA2->(dbDelete())
				PA2->(MsUnLock())
			EndIf
		EndIf
		(cAlias)->(dbSkip())
	End

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha Alias se estiver em Uso ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	RestArea(_aAreaSC5)
	RestArea(_aAreaPA1)
	RestArea(_aAreaPA2)

Return

	/*====================================================================================\
	|Programa  | STSDCExc         | Autor | GIOVANI.ZAGO             | Data | 08/05/2013  |
	|=====================================================================================|
	|Descri็ใo | STSDCExc                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STSDCExc                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------------------------------------------------*
Static Function STSDCExc(cDoc,cProduto,cArm,nReserva,nRecno,aSD4,cOrdSep)
	*-----------------------------------------------------------------------*
	Local cTipDoc 	:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aSaldos	:= {}
	Local lUsaVenc	:= SuperGetMv('MV_LOTVENC')=='S'

	SC6->(DbGoto(nRecno))

	aSaldos := {{ "","",SC6->C6_LOCALIZ,"",nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),Ctod(""),"","","",SC6->C6_LOCAL,0}}
	//Chamado 002701
	If SC6->C6_OPER $ SuperGetMV("ST_OPEREMB",.F.,"15") .And. cFilAnt == '01'//Apenas para a Filial 01 de SP e AM para nใo gerar empenho (SDC) no armaz้m 15
		MaLibDoFat(SC6->(RecNo()),nReserva,.F.,.T.,.F.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
		MaLiberOk({SC6->C6_NUM},.F.)
		MsUnLockall()
		SC6->(DbGoto(nRecno))
	Else
		MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.F.,.F.,Nil,{||SC9->C9_ORDSEP:= " " },aSaldos,Nil,Nil,Nil)
		MaLiberOk({SC6->C6_NUM},.F.)
		MsUnLockall()
		SC6->(DbGoto(nRecno))
	Endif

	Return
	/*====================================================================================\
	|Programa  | StLibFinMail     | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
	|=====================================================================================|
	|Descri็ใo | StLibFinMail                                                             |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StLibFinMail                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function  STxIBLMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Faturamento - Libera็ใo do Pedido de Venda('+SC5->C5_NUM +') na Filial 01'
	Local cFuncSent:= "STxIBLMAIL"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ''
	Local cAttach  := ''

	_cEmail  := " simone.mara@steck.com.br;fernanda.bereki@steck.com.br;kleber.braga@steck.com.br"

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Dt. Emissใo : "    , DTOC(SC5->C5_EMISSAO)})
		Aadd( _aMsg , { "Dt. Libera็ใo: "    , _cDat  } )
		Aadd( _aMsg , { "Liberado: "    	, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
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
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()

Static Function FatPed(_cNuPed)
	Local aArea 	:= GetArea()
	Local oDlgEmail
	Local _cVal       :=  Space(6)
	Local lSaida      := .F.
	Local nOpca       :=  0

	Do While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Associa็ใo de Fatec") From  1,0 To 80,200 Pixel OF oMainWnd

		@ 02,04 SAY "Fatec:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _cVal f3 "PC1FSW"  Size 55,013 Valid(ExistCpo('PC1',_cVal)) PIXEL OF oDlgEmail
		@ 12,62 Button "Ok"      Size 28,13 Action Iif(ExistCpo('PC1',_cVal),Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),MsgInfo("Selecione a Fatec!!!!"))  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

	If nOpca = 1
		DbSelectArea("PC1")
		PC1->(DbGoTop())
		PC1->(DbSetOrder(6))
		If	PC1->(DbSeek(xFilial('PC1')+ _cNuPed))

			If MsgYesNo("Ja Existe Fatec Associada a Este Pedido de Venda"+CR+CR+"Deseja Alterar ?")

				PC1->(RecLock("PC1",.F.))
				PC1->PC1_PEDREP   := _cNuPed
				PC1->(MsUnlock())

			EndIf
		Else
			DbSelectArea("PC1")
			PC1->(DbGoTop())
			PC1->(DbSetOrder(1)) // Indice PC1_FILIAL+PC1_NUMERO
			If	PC1->(DbSeek(xFilial('PC1')+ _cVal))

				PC1->(RecLock("PC1",.F.))
				PC1->PC1_PEDREP   := _cNuPed
				PC1->(MsUnlock())

			EndIf
		EndIf
	EndIf
	RestArea(aArea)
	Return()
	/*====================================================================================\
	|Programa  | StLibFinMail     | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
	|=====================================================================================|
	|Descri็ใo | StLibFinMail                                                             |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StLibFinMail                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function  STC9LIB(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Faturamento - Libera็ใo automatica do Pedido de Venda('+SC5->C5_NUM +') '
	Local cFuncSent:= "STC9LIB"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ''
	Local cAttach  := ''

	return()//desabilitado 03/07/2014 a pedido do marco do financeiro
	_cEmail  := ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Dt. Emissใo : "    , DTOC(SC5->C5_EMISSAO)})
		Aadd( _aMsg , { "Dt. Libera็ใo: "    , _cDat  } )
		Aadd( _aMsg , { "Liberado: "    	, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
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

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()

User Function STAVALVD()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cVenda  := "N"

	_cQuery1 := " SELECT COUNT(*) CONTADOR
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' 
	_cQuery1 += " AND C5_FILIAL='"+SC5->C5_FILIAL+"' AND C5_NUM='"+SC5->C5_NUM+"'
	_cQuery1 += " AND C6_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->CONTADOR>0
		if cFilAnt == "02"    // Adicionado Valdemir Rabelo 13/07/2021 Ticket: 20210607009515
		   _cVenda := "S"
		else
		   _cVenda := "N"
		endif
	EndIf

Return(_cVenda)

/*====================================================================================\
|Programa  | STDELZ96        | Autor | RENATO.OLIVEIRA           | Data | 22/12/2022  |
|=====================================================================================|
|Descri็ใo |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STDELZ96(cFil,cNum,cItem,lDelSC6)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _aArea   :=GETAREA()
	Local _aAreaZ96:=Z96->(GETAREA())
	Local _aAreaPA1:=PA1->(GETAREA())

	DbSelectArea("Z96")
	DbSelectArea("PA1")

	_cQuery1 := " SELECT Z96.R_E_C_N_O_ RECZ96
	_cQuery1 += " FROM "+RetSqlName("Z96")+" Z96
	_cQuery1 += " WHERE Z96.D_E_L_E_T_=' ' AND Z96_FILIAL='"+cFil+"' AND Z96_PA1DOC='"+cNum+cItem+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		Z96->(DbGoTo((_cAlias1)->RECZ96))
		If Z96->(!Eof())

			PA1->(DBSETORDER(3))
			If PA1->(DBSEEK(XFILIAL("PA1")+Z96->Z96_PA1DOC+Z96->Z96_PROD))
				PA1->(RECLOCK("PA1",.F.))
				PA1->PA1_SALDO +=  Z96->Z96_QTDATE
				PA1->(MsUnLock())
			EndIf
            IF Z96->Z96_TIPREG=='PO'
               ZA6->(DBSETORDER(2))
			   IF ZA6->(DBSEEK(XFILIAL("ZA6")+Z96->Z96_PEDCOM+Z96->Z96_ITECOM+Z96->Z96_PROD))
			      ZA6->(RECLOCK('ZA6',.F.))
				  IF ZA6->ZA6_CONSUM>=Z96->Z96_QTDATE 
				     ZA6->ZA6_CONSUM-=Z96->Z96_QTDATE 
		 		  ENDIF	 
				  ZA6->(MSUNLOCK('ZA6'))
			   ENDIF 	  
            ENDIF
			Z96->(RecLock("Z96",.F.))
			Z96->(DbDelete())
			Z96->(MsUnLock())
			
		EndIf
        IF ! lDelSC6
		   SC6->(RecLock("SC6",.F.))
		   SC6->C6_ZENTRE2 := STOD("")
		   SC6->(MsUnLock())
		ENDIF   

		(_cAlias1)->(DbSkip())
	EndDo

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

    RestArea(_aAreaPA1)
    RestArea(_aAreaZ96)
    RestArea(_aArea)


Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaDelSC6บAutor  ณAntonio Moura      บ Data ณ  11/10/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca os Registros Deletados para exluir tb a Z96          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function BuscaDelSC6(cPedido)

Local aDados:={}
Local cAlias:=""
Local aArea:=GetArea()

cAlias := GetNextAlias()

cQuery := " SELECT C6_NUM NUM,C6_ITEM ITEM ,C6_PRODUTO PRODUTO,C6_OPER OPER "
cQuery += " FROM "+RetSqlName("SC6")+ " SC6 "
cQuery += " INNER JOIN "+RetSqlName("Z96")+ " Z96 ON Z96.Z96_FILIAL = SC6.C6_FILIAL AND Z96.Z96_PA1DOC = SC6.C6_NUM||SC6.C6_ITEM AND Z96.Z96_PROD = SC6.C6_PRODUTO "
cQuery += " AND Z96.D_E_L_E_T_ = ' ' "

cQuery += " WHERE SC6.C6_FILIAL = '"+XFILIAL('SC6')+"' " 
cQuery += "  AND SC6.C6_NUM = '"+cPedido+"' "
cQuery += "  AND SC6.D_E_L_E_T_ = '*' "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)

IF (cAlias)->( ! Eof())
   While ! (cAlias)->( Eof())
      AADD(aDados,{(cAlias)->NUM,(cAlias)->ITEM,(cAlias)->PRODUTO,(cAlias)->OPER})   
      (cAlias)->(DBSKIP())
   ENDDO   
ENDIF

(cAlias)->( DbcloseArea())
RestArea(aArea)

Return(aDados)



/*====================================================================================\
|Programa  | VerCred          | Autor | Antonio Cordeiro         | Data | 14/11/2023  |
|=====================================================================================|
|Descri็ใo | Avalia credito do cliente com base no Risco e Limite                     |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

Static Function VerCred(cCli,nValItem)

Local nAberto1:=0
Local cAlias:=""
Local cMax:=""
Local nAtrMax:=0
Local cRisco:=""
Local nRiscoB:=0
Local nRiscoC:=0
Local lBloqPed:=.F.
Local aArea:=GetArea()
Local cQuery:=""
Local aAreaSA1:=SA1->(GETAREA())

Default nValItem:=0

SA1->(DBSETORDER(1))
IF ! SA1->(DBSEEK(XFILIAL('SA1')+cCli+'01')) // Busca sempre a loja padrใo 01
   Return(.T.) // se a loja 01 nใo existe abandona e bloqueia o pedido. 
ELSE 
   RiscoCli:=SA1->A1_RISCO 
   nLimite :=SA1->A1_LC 
ENDIF    

nRiscoA:=Getmv( "ST_RISCOA",, 9999999999 ) 
nRiscoB:=Getmv( "ST_RISCOB",, 30 ) 
nRiscoC:=Getmv( "ST_RISCOC",, 15 ) 

IF RiscoCli $ 'A/B/C'
   cRisco:='nRisco'+alltrim(RiscoCli)
   nAtrMax:=&cRisco
ENDIF
      

cAlias := GetNextAlias()

//Titulos tipo NF em aberto. 
cQuery += " SELECT SUM(SALDO) SALDO,SUM(DIF) DIF FROM ( "+CRLF
cQuery += " SELECT SUM(E1_SALDO) SALDO,MIN(TO_DATE(SE1.E1_VENCREA,'YYYYMMDD') - TO_DATE('"+DTOS(dDataBase)+"','YYYYMMDD')) DIF "+CRLF
cQuery += " FROM "+RetSqlName("SE1")+ " SE1 "+CRLF
cQuery += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery += "   AND SE1.E1_FILIAL = '"+XFILIAL('SE1')+"' "+CRLF
cQuery += "   AND SE1.E1_TIPO  = 'NF' "+CRLF
cQuery += "   AND SE1.E1_CLIENTE  = '"+cCli+"' "
cQuery += "   AND SE1.E1_SALDO >0  "

//Pedidos em aberto. 
cQuery += " UNION ALL "+CRLF
cQuery += " SELECT SUM(C9_QTDLIB*C9_PRCVEN) SALDO,0 DIF  "+CRLF
cQuery += " FROM "+RetSqlName("SC9")+ " SC9 "+CRLF
//cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 ON SC6.C6_FILIAL = SC9.C9_FILIAL AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM "+CRLF
cQuery += " WHERE SC9.D_E_L_E_T_ = ' '  "+CRLF  
cQuery += " AND SC9.C9_FILIAL = '"+XFILIAL('SC9')+"' " 
cQuery += " AND SC9.C9_CLIENTE  = '"+cCli+"' "+CRLF
cQuery += " AND SC9.C9_BLCRED = '  '  ) "+CRLF


DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   IF (cAlias)->SALDO+nValItem > nLimite // Saldo em aberto maior que o liminte de credito. 
      lBloqPed:=.T. 
   ENDIF 
   IF (cAlias)->DIF < 0 .and. nAtrMax > 0
      IF (cAlias)->DIF*-1 > nAtrMax // Se o superar o atraso maximo permitido para o Risco bloqueia. 
         lBloqPed:=.T. 	  
	  ENDIF
   ENDIF	  	 

ENDIF

(cAlias)->( DbcloseArea())

RestArea(aAreaSA1)
RestArea(aArea)

Return(lBloqPed)
