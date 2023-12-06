#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TBIConn.ch"
#Include "AP5Mail.ch"
#Include 'FWMVCDef.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STGERSC5	ºAutor  ³Renato Nogueira     º Data ³  25/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para gerar pedidos de venda através de um  º±±
±±º          ³pedido de compras					    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STGERSC5()

	Local _aArea		:= GetArea()
	Local aCabec    	:= {}
	Local aSC6			:= {}
	Local cQuery 		:= ""
	Local _cQuery		:= ""
	Local cAlias 		:= "QRYTEMP"
	//Local aOpenTable  := {"SC5","SA1","SC6","SB1","SC7"}
	Local cStartPath    := '\logs\'
	Local _lxRet        := .T.
	Local _cDirRel      := GetMV("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Local _cNumsc7      := SC7->C7_NUM
	Local _cMes         := SC7->C7_XMESMRP // vem pelo P.E MT120GRV
	Local _cAno         := SC7->C7_XANOMRP // vem pelo P.E MT120GRV
	Local _cX			:= "00"
	//>>Chamado 007659 -Everson Santana - 12/12/2018
	Local aItems 		:= {"1 - Manaus ","2 - São Paulo"}
	Local cItem 		:= Space(20)
	Local _cFil			:= ""
	Local _cEmp			:= ""
	Local _cTransp 		:= ""
	Local _cOper		:= ""
	Local nOpcao 		:= 0
	Local _cTES			:= ""
	//<<
	//>> Ticket 20190723000097
	Local _cAssunto 	:= "Aviso de Emissão Pedido de Venda para Manaus "
	Local _cEmail  		:=  GetMv('ST_GERSC5',,"everson.santana@steck.com.br")
	Local _cCopia  		:= ""
	//Local aArea 		:= GetArea()
	//Local _cFrom   	:= "protheus@steck.com.br"
	Local cFuncSent		:= "STGERPVAM"
	//Local i        	:= 0
	//Local cArq     	:= ""
	Local cMsg     		:= ""
	Local _nLin
	//Local cAttach  	:= ' '
	//Local _cEmaSup 	:= ' '
	//Local _nCam    	:= 0
	Local _aMsg    		:= {}
	//<<
	Private cNumPed   	:= ""
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lInserido	:= .F.

	_cTpClient := "F"
	_cConsum   := "2"

	If (cEmpAnt $ "01/03")
		If (cEmpAnt == "03")
			U_STGERPVAM()
			Return
		EndIf
	Else
		MsgAlert("Atenção, essa funcionalidade só está liberada para as empresas 01 e 03, verifique!")
		Return
	EndIf

	//>>Chamado 007659 - Everson Santana - 12/12/2018
	Define msDialog oDxlg Title "Destinação do Pedido" From 10,10 TO 150,200 Pixel
	@ 010,010 COMBOBOX cItem ITEMS aItems SIZE 80,80
	Define SButton From 030,030 TYPE 1 ACTION If(!Empty(Alltrim(cItem)),(lSaida := .T., nOpcao := 1, oDxlg:End()), MsgInfo("Selecione uma Unidade","Atenção")) ENABLE OF oDxlg
	Activate Dialog oDxlg Centered

	If nOpcao == 1
		If Substr(cItem,1,1) == '1' // Manaus
			_cFil 		:= "01"
			_cEmp 		:= "03"
			_cTransp 	:= "100000"//
			_cOper      := "15"
			_cTES 		:= ""
			_cTpClient := "R"
			_cConsum   := "1"
		Else	// São Paulo
			_cFil 		:= "04"
			_cEmp 		:= "01"
			_cTransp 	:= "10000"
			_cOper      := "94"
			//Private _cTipoCli 	:= IIF(_Lmomat ,"M->UA_XTIPO"  ,"M->C5_TIPOCLI")
			_cTES 		:= ""
		EndIf
	EndIf
	//<<
	If !Empty(SC7->C7_XPEDGER)
		MsgAlert("Atenção, Pedido de Venda já gerado para a empresa 03 - Steck da Amazônia" + Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"Pedido de Venda nº: " + SC7->C7_ZNUMPV + Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"Verifique...!!!")
		Return
	EndIf

	If SC7->C7_FORNECE $ "005866#005764" //Verificar se é intra grupo
		aAdd(aCabec, {"C5_TIPO"   , "N"                                      , Nil}) // Tipo do Pedido
		aAdd(aCabec, {"C5_CLIENTE", "033467"                                 , Nil}) // Codigo do Cliente
		aAdd(aCabec, {"C5_LOJACLI", Iif(cFilant == '04', '03',xFilial("SC7")), Nil}) // Loja do Cliente
		aAdd(aCabec, {"C5_CLIENT" , "033467"                                 , Nil}) // Codigo do Cliente para entrega
		aAdd(aCabec, {"C5_LOJAENT", Iif(cFilant == '04', '03',xFilial("SC7")), Nil}) // Loja para entrega
		aAdd(aCabec, {"C5_TIPOCLI", _cTpClient                               , Nil}) // Tipo do Cliente
		aAdd(aCabec, {"C5_CONDPAG", "502"                                    , Nil}) // Condicao de pagamanto
		aAdd(aCabec, {"C5_EMISSAO", dDatabase                                , Nil}) // Data de Emissao
		aAdd(aCabec, {"C5_ZCONDPG", "502"                                    , Nil}) // COND PG
		aAdd(aCabec, {"C5_TABELA" , "T02"                                    , Nil}) // TABELA
		aAdd(aCabec, {"C5_VEND1"  , ""                                       , Nil}) //VENDEDOR 1
		aAdd(aCabec, {"C5_TPFRETE", "C"                                      , Nil}) // Frete -- Ticket 20211109024029 - Pedidos vendas de Manaus para o CD ( erro no tipo de entrega ) -- Eduardo Pereira Sigamat -- 11.11.2021 - alterado de F para C
		aAdd(aCabec, {"C5_TRANSP" , _cTransp                                 , Nil}) // Transportadora
		aAdd(aCabec, {"C5_XTIPO"  , "2"               						 , Nil}) // Tipo Entrega -- Ticket 20211109024029 - Pedidos vendas de Manaus para o CD ( erro no tipo de entrega ) -- Eduardo Pereira Sigamat -- 11.11.2021 - alterado de Iif(cEmpAnt == "01","2","1") para 2
		aAdd(aCabec, {"C5_XTIPF"  , "1"                                      , Nil}) // Tipo Fatura
		aAdd(aCabec, {"C5_ZOBS"   , ""                                       , Nil}) // Observação
		aAdd(aCabec, {"C5_ZBLOQ"  , "2"                                      , Nil}) // Bloqueio
		aAdd(aCabec, {"C5_XORDEM" , ""                                       , Nil}) // Pedido do cliente
		aAdd(aCabec, {"C5_ZENDENT", ""                                       , Nil}) // End entrega
		aAdd(aCabec, {"C5_ZBAIRRE", ""                                       , Nil}) // Bairro entrega
		aAdd(aCabec, {"C5_ZCEPE"  , ""                                       , Nil}) // CEP entrega
		aAdd(aCabec, {"C5_ZESTE"  , ""                                       , Nil}) // Estado entrega
		aAdd(aCabec, {"C5_ZMUNE"  , ""                                       , Nil}) // Mun entrega
		aAdd(aCabec, {"C5_XCODMUN", ""                                       , Nil}) // Codigo mun entrega
		aAdd(aCabec, {"C5_ZCONSUM", _cConsum                                 , Nil}) // Consumo
		aAdd(aCabec, {"C5_ZMESPC" , _cMes                                    , Nil}) // Mes PC
		aAdd(aCabec, {"C5_ZANOPC" , _cAno                                    , Nil}) // Ano PC
		aAdd(aCabec, {"C5_ZNUMPC" , _cNumsc7                                 , Nil}) // Pedido de Compra SP

		cQuery	:= " SELECT * "
		cQuery  += " FROM " + RetSqlName("SC7") + " C7 "
		cQuery  += " WHERE C7.D_E_L_E_T_= ' ' "
		cQuery  += " 	AND C7_FILIAL = '" + xFilial("SC7") + "' "
		cQuery  += " 	AND C7_NUM = '" + SC7->C7_NUM + "' "
		cQuery  += " ORDER BY C7_ITEM "
		If !Empty(Select(cAlias))
			dbSelectArea(cAlias)
			(cAlias)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		While (cAlias)->( !Eof() )
			If (cAlias)->C7_QUANT-(cAlias)->C7_QUJE > 0
				dbSelectArea("SB1")
				SB1->( dbSetOrder(1) )
				SB1->( dbGoTop() )
				SB1->( dbSeek(xFilial("SB1") + (cAlias)->C7_PRODUTO) )
				_cX	:= Soma1(_cX)
				// Ticket: 20210202001729
				If cEmpAnt == "03"
					aAdd(aSC6 ,{{"C6_ITEM"		,_cX						 			 							,Nil},; // Numero do Item no Pedido
								{"C6_PRODUTO"	,(cAlias)->C7_PRODUTO												,Nil},; // Codigo do Produto
								{"C6_UM"   		,SC7->C7_UM		  													,Nil},; // Unidade de Medida Primar.
								{"C6_CLI"		,"033467"															,Nil},; // Cliente
								{"C6_LOJA" 		,Iif(cFilant='04','03',xFilial("SC7"))                         		,Nil},; // Loja
								{"C6_QTDVEN"	,(cAlias)->C7_QUANT-(cAlias)->C7_QUJE								,Nil},; // Quantidade Vendida
								{"C6_PRCVEN"	,(cAlias)->C7_PRECO													,Nil},; // Preco Venda
								{"C6_PRUNIT"	,(cAlias)->C7_PRECO													,Nil},; // Preco Unitario
								{"C6_ZPRCPSC"	,(cAlias)->C7_PRECO													,Nil},; // Preco Venda
								{"C6_VALOR"		,Round((cAlias)->C7_PRECO*((cAlias)->C7_QUANT-(cAlias)->C7_QUJE),2)	,Nil},; // Valor Total do Item
								{"C6_OPER"		,_cOper															    ,Nil},; // OPERAÇÃO
								{"C6_TES"		,''																	,Nil},; // Tipo de Entrada/Saida do Item
								{"C6_ENTRE1"	,dDataBase			                                 				,Nil},; // Data de Entrega
								{"C6_ZMOTPC"	,(cAlias)->C7_MOTIVO                                 				,Nil},; //Motivo de Compra
								{"C6_LOCAL"		,'15'																,Nil},; // Almoxarifado
								{"C6_CLASFIS"	,""																    ,Nil},;
								{"C6_NUMPCOM"	,(cAlias)->C7_NUM													,Nil},;
								{"C6_ITEMPC"	,(cAlias)->C7_ITEM													,Nil},;
								{"C6_ENTREG"	,(cAlias)->C7_DATPRF												,Nil},;
								{"C6_ENTRE1"	,(cAlias)->C7_DATPRF												,Nil}})
				Else
					aAdd(aSC6 ,{{"C6_ITEM"		,_cX						 			 							,Nil},; // Numero do Item no Pedido
								{"C6_PRODUTO"	,(cAlias)->C7_PRODUTO												,Nil},; // Codigo do Produto
								{"C6_UM"   		,SC7->C7_UM		  													,Nil},; // Unidade de Medida Primar.
								{"C6_CLI"		,"033467"															,Nil},; // Cliente
								{"C6_LOJA" 		,Iif(cFilant='04','03',xFilial("SC7"))                         		,Nil},; // Loja
								{"C6_QTDVEN"	,(cAlias)->C7_QUANT-(cAlias)->C7_QUJE								,Nil},; // Quantidade Vendida
								{"C6_PRCVEN"	,(cAlias)->C7_PRECO													,Nil},; // Preco Venda
								{"C6_PRUNIT"	,(cAlias)->C7_PRECO													,Nil},; // Preco Unitario
								{"C6_ZPRCPSC"	,(cAlias)->C7_PRECO													,Nil},; // Preco Venda
								{"C6_VALOR"		,Round((cAlias)->C7_PRECO*((cAlias)->C7_QUANT-(cAlias)->C7_QUJE),2)	,Nil},; // Valor Total do Item
								{"C6_OPER"		,_cOper															    ,Nil},; // OPERAÇÃO
								{"C6_TES"		,'701'																	,Nil},; // Tipo de Entrada/Saida do Item
								{"C6_ENTRE1"	,dDataBase			                                 				,Nil},; // Data de Entrega
								{"C6_ZMOTPC"	,(cAlias)->C7_MOTIVO                                 				,Nil},; //Motivo de Compra
								{"C6_LOCAL"		,'15'																,Nil},; // Almoxarifado
								{"C6_CLASFIS"	,'5101'																    ,Nil},;
								{"C6_NUMPCOM"	,(cAlias)->C7_NUM													,Nil},;
								{"C6_ITEMPC"	,(cAlias)->C7_ITEM													,Nil}})
				EndIf
			EndIf
			(cAlias)->( dbSkip() )
		EndDo

		If Len(aSC6) > 0 //Só gera o pedido quando tiver saldo
			// Valdemir Rabelo 15/09/2021
			//aCabec := FWVetByDic(aCabec, "SC5", .F.)
			//aSC6   := FWVetByDic(aSC6, "SC6", .T.)
			cNumPed	:= StartJob("U_SXGERSC5",GetEnvServer(), .T.,"03","01",.T.,aCabec,aSC6,_cNumsc7,_cTpClient,_cConsum)
			// Valdemir cNumPed	:= U_SXGERSC5("03","01",.T.,aCabec,aSC6,_cNumsc7,_cTpClient,_cConsum)
			//cNumPed	:= StartJob("U_SXGERSC5",GetEnvServer(), .T.,_cEmp,_cFil,.T.,aCabec,aSC6,_cNumsc7)
			If !Empty(cNumPed)
				_cQuery := " UPDATE " + RetSqlName("SC7") + " C7 "
				_cQuery += " SET C7.C7_XPEDGER = 'S', C7.C7_ZNUMPV = '" + cNumPed + "' "
				_cQuery += " WHERE C7.D_E_L_E_T_ = ' ' "
				_cQuery += " 	AND C7_FILIAL = '" + SC7->C7_FILIAL + "' "
				_cQuery += " 	AND C7_NUM = '" + SC7->C7_NUM + "' "
				nErrQry := TCSqlExec( _cQuery )
				If nErrQry <> 0
					Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
				EndIf
				//>> Ticket 20190723000097
				aAdd( _aMsg , { "Numero: "          , cNumPed } )
				//aAdd( _aMsg , { "Nome: "    		, M->E2_NOMFOR } )
				//aAdd( _aMsg , { "Valor: "    		, transform((M->E2_VALOR)	,"@E 999,999,999.99")  } )
				//aAdd( _aMsg , { "Emissao: "    	, dtoc(M->E2_EMISSAO) } )
				//aAdd( _aMsg , { "Vencto Real : "  , dtoc(M->E2_VENCREA) } )
				//aAdd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				//aAdd( _aMsg , { "Hora: "    		, time() } )
				If ( Type("l410Auto") == "U" .Or. !l410Auto )
					// Definicao do cabecalho do email
					cMsg := ""
					cMsg += '<html>'
					cMsg += '<head>'
					cMsg += '<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
					cMsg += '</head>'
					cMsg += '<body>'
					cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
					cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
					cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
					// Definicao do texto/detalhe do email
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
					cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ DtoC(Date()) + '-' + Time() + '  - <font color="red" size="1">(' + cFuncSent + ')</td>'
					cMsg += '</tr>'
					cMsg += '</Table>'
					cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
					cMsg += '</body>'
					cMsg += '</html>'
					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
				EndIf
				//<<
			Else
				MsgAlert("Pedido não gerado, verifique!")
				If ExistDir(_cDirRel)
					_lxRet := .T.
				Else
					If MakeDir(_cDirRel) == 0
						MakeDir(_cDirRel)
						_lxRet := .T.
					Else
						Aviso("Erro na Criação de Pasta","Para visualizar o log de erro de geração de Pedido de Venda é necessário que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
							CHR(10)+CHR(13)+;
							"Favor entrar em contato com o TI para que a criação da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
							CHR(10)+CHR(13)+;
							{"OK"},3)
						_lxRet := .F.
					EndIf
				EndIf
				If _lxRet
					fErase(_cDirRel + "PC" + _cNumsc7 + ".log")
					CpyS2T(cStartPath + 'PC' + _cNumsc7 + '.log',_cDirRel,.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
					ShellExecute("open",_cDirRel + "PC" + _cNumsc7 + ".log", "", "", 1)
				EndIf
			EndIf
		Else
			MsgAlert("Atenção, esse pedido não possui saldo para gerar um pedido de venda")
		EndIf
	Else
		MsgAlert("Atenção, essa rotina só deve ser utilizada para pedidos intra grupo, verifique!")
	EndIf

	If !Empty(cNumPed)
		MsgAlert("Pedido: " + cNumPed + " inserido com sucesso")
	EndIf

	RestArea(_aArea)

Return

User Function STGERPVAM()

	Local _aArea		:= GetArea()
	Local aCabec    	:= {}
	Local aSC6			:= {}
	Local cQuery 		:= ""
	Local _cQuery		:= ""
	Local cAlias 		:= "QRYTEMP"
	//Local aOpenTable  := {"SC5","SA1","SC6","SB1","SC7"}
	Local cStartPath    := '\logs\'
	Local _lxRet        := .T.
	Local _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Local _cNumsc7      := SC7->C7_NUM
	Local _cMes         := SC7->C7_XMESMRP
	Local _cAno         := SC7->C7_XANOMRP
	Local _cX			:= "00"
	Local cCodB1030		:= ""
	Local oDxlg
	Local aItems 		:= {"1 - Filial/SP 02","2 - Filial/SP 04","3 - Filial/SP 05"}
	Local cItem 		:= space(20)
	Local _cFil			:= ""
	Local nOpcao 		:= 0

	Private _cUserGerPv := GetMv('ST_GPVUSER',,'000000')// Admin acesso full
	Private cNumPed   	:= ""
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lInserido	:= .F.

	Define msDialog oDxlg Title "Destinação do Pedido" From 10,10 TO 150,200 Pixel
	@ 010,010 COMBOBOX cItem ITEMS aItems SIZE 80,80
	Define SButton From 030,030 TYPE 1 ACTION If(!Empty(Alltrim(cItem)),(lSaida := .T., nOpcao := 1, oDxlg:End()), MsgInfo("Selecione uma Filial","Atenção")) ENABLE OF oDxlg
	Activate Dialog oDxlg Centered

	If nOpcao == 1
		If Substr(cItem,1,1) == '1'
			_cFil := "02"
		ElseIf Substr(cItem,1,1) == '2'
			_cFil := "04"
		Else
			_cFil := "05"
		EndIf
	EndIf

	// Validação de acesso a rotina pelo X6 - Somente Steck AM
	If !(__cuserid $ _cUserGerPv)
		MsgAlert("ATENÇÃO!  Usuario sem acesso!"+ Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"X6_CONTEUDO - ST_GPVUSER"+ Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"Abrir chamado para liberação!")
		Return
	EndIf

	If !Empty(SC7->C7_XPEDGER)
		MsgAlert("Atenção, Pedido de Venda já gerado para a empresa 01/04 - Steck SP" + Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"Pedido de Venda nº: " + SC7->C7_ZNUMPV + Chr(10) + Chr(13);
			+ Chr(10) + Chr(13) +;
			"Verifique...!!!")
		Return
	EndIf

	If SC7->C7_FORNECE == "005764"
		aAdd(aCabec, {"C5_TIPO"		, "N"							,Nil}) // Tipo do Pedido
		aAdd(aCabec, {"C5_CLIENTE"	, "035444"						,Nil}) // Codigo do Cliente
		aAdd(aCabec, {"C5_LOJACLI"	, "01"							,Nil}) // Loja do Cliente
		aAdd(aCabec, {"C5_CLIENT"	, "035444"						,Nil}) // Codigo do Cliente para entrega
		aAdd(aCabec, {"C5_LOJAENT"	, "01"							,Nil}) // Loja para entrega
		aAdd(aCabec, {"C5_TIPOCLI"	, "R"							,Nil}) // Tipo do Cliente
		aAdd(aCabec, {"C5_CONDPAG"	, "502"							,Nil}) // Condicao de pagamanto
		aAdd(aCabec, {"C5_EMISSAO"	, dDatabase						,Nil}) // Data de Emissao
		aAdd(aCabec, {"C5_ZCONDPG"	, "502"							,Nil}) // COND PG
		aAdd(aCabec, {"C5_TABELA"	, "001"						 	,Nil}) // TABELA
		aAdd(aCabec, {"C5_VEND1"	, "E00006"						,Nil}) //VENDEDOR 1
		aAdd(aCabec, {"C5_TPFRETE"	, "F"							,Nil}) // Frete
		aAdd(aCabec, {"C5_TRANSP"	, "004024"						,Nil}) // Transportadora
		aAdd(aCabec, {"C5_XTIPO"	, Iif(cEmpAnt == "01","2","1")	,Nil}) // Tipo Entrega  1=Retira;2=Entrega - estava "2" alterado por Valdemir Rabelo 15/09/2021
		aAdd(aCabec, {"C5_XTIPF"	, "1"							,Nil}) // Tipo Fatura 1=Total;2=Parcial
		aAdd(aCabec, {"C5_ZOBS"		, ""							,Nil}) // Observação
		aAdd(aCabec, {"C5_ZBLOQ"	, "2"							,Nil}) // Bloqueio
		aAdd(aCabec, {"C5_XORDEM"	, ""							,Nil}) // Pedido do cliente
		aAdd(aCabec, {"C5_ZENDENT"	, ""							,Nil}) // End entrega
		aAdd(aCabec, {"C5_ZBAIRRE"	, ""							,Nil}) // Bairro entrega
		aAdd(aCabec, {"C5_ZCEPE"	, ""							,Nil}) // CEP entrega
		aAdd(aCabec, {"C5_ZESTE"	, ""							,Nil}) // Estado entrega
		aAdd(aCabec, {"C5_ZMUNE"	, ""							,Nil}) // Mun entrega
		aAdd(aCabec, {"C5_XCODMUN"	, ""							,Nil}) // Codigo mun entrega
		aAdd(aCabec, {"C5_ZCONSUM"	, "2"							,Nil}) // Consumo
		aAdd(aCabec, {"C5_ZMESPC"	, _cMes        					,Nil}) // Mes PC
		aAdd(aCabec, {"C5_ZANOPC"	, _cAno  						,Nil}) // Ano PC
		aAdd(aCabec, {"C5_ZNUMPC"	, _cNumsc7     					,Nil}) // Pedido de Compra SP

		cQuery	:= " SELECT  C7_FILIAL,C7_ITEM,C7_PRODUTO,C7_UM,C7_QUANT,C7_PRECO,C7_QUJE,C7_MOTIVO "
		cQuery  += " FROM " + RetSqlName("SC7") + " C7 "
		cQuery  += " WHERE C7.D_E_L_E_T_ = ' ' "
		cQuery  += " 	AND C7_FILIAL = '" + xFilial("SC7") + "' "
		cQuery  += " 	AND C7_NUM = '" + SC7->C7_NUM + "' "
		cQuery  += " ORDER BY C7_ITEM "
		If !Empty(Select(cAlias))
			dbSelectArea(cAlias)
			(cAlias)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		While (cAlias)->( !Eof() )
			If (cAlias)->C7_QUANT - (cAlias)->C7_QUJE > 0
				dbSelectArea("SB1")
				SB1->( dbSetOrder(1) )
				SB1->( dbGoTop() )
				SB1->( dbSeek(xFilial("SB1") + (cAlias)->C7_PRODUTO) )
				cCodB1030 := (cAlias)->C7_PRODUTO
				cLocPad   := u_GetB1LocPad(cCodB1030) // Busca o Armazem padrao da Matriz 01/04
				_cX	:= Soma1(_cX)
				aAdd(aSC6 ,{{"C6_ITEM"		,_cX						 			 							, Nil},; // Numero do Item no Pedido
							{"C6_PRODUTO", (cAlias)->C7_PRODUTO                                              	, Nil},; // Codigo do Produto
							{"C6_UM"     , (cAlias)->C7_UM                                                   	, Nil},; // Unidade de Medida Primar.
							{"C6_CLI"    , "035444"                                                          	, Nil},; // Cliente
							{"C6_LOJA"   , "01"                                                             	, Nil},; // Loja
							{"C6_QTDVEN" , (cAlias)->C7_QUANT-(cAlias)->C7_QUJE                              	, Nil},; // Quantidade Vendida
							{"C6_PRCVEN" , (cAlias)->C7_PRECO                                                	, Nil},; // Preco Venda
							{"C6_PRUNIT" , (cAlias)->C7_PRECO                                                	, Nil},; // Preco Unitario
							{"C6_ZPRCPSC", (cAlias)->C7_PRECO                                                	, Nil},; // Preco Venda
							{"C6_VALOR"  , round((cAlias)->C7_PRECO*((cAlias)->C7_QUANT-(cAlias)->C7_QUJE),2)	, Nil},; // Valor Total do Item
							{"C6_OPER"   , '85'                                                              	, Nil},; // OPERAÇÃO
							{"C6_TES"    , ''                                                                	, Nil},; // Tipo de Entrada/Saida do Item
							{"C6_ENTRE1" , dDataBase                                                         	, Nil},; // Data de Entrega
							{"C6_ZMOTPC" , (cAlias)->C7_MOTIVO                                               	, Nil},; //Motivo de Compra
							{"C6_LOCAL"  , cLocPad                                                           	, Nil},; // Almoxarifado
							{"C6_CLASFIS", ""                                                                	, Nil}})
							//{"C6_OPER" , GetMv("ST_LOCESC")													,Nil},; // OPERAÇÃO
							//{"C6_TES"	 , "701"																,Nil},; // Tipo de Entrada/Saida do Item
			EndIf
			(cAlias)->( dbSkip() )
		EndDo

		If Len(aSC6) > 0 //Só gera o pedido quando tiver saldo
			// Valdemir Rabelo 15/09/2021
			aCabec := aClone(FWVetByDic(aCabec, "SC5", .F.))
			//aSC6   := FWVetByDic(aSC6, "SC6", .T.)
			cNumPed	:= StartJob("U_SXGERSC5",GetEnvServer(), .T.,"01",_cFil,.T.,aCabec,aSC6,_cNumsc7,"R","1")
			//cNumPed	:= StartJob("U_SXGERSC5",GetEnvServer(), .T.,"01",_cFil,.T.,aCabec,aSC6,_cNumsc7)
			//U_SXGERSC5("01",_cFil,,aCabec,aSC6,_cNumsc7)
			If !Empty(cNumPed)
				_cQuery := " UPDATE "+RetSqlName("SC7") + " C7 "
				_cQuery += " SET C7.C7_XPEDGER = 'S', C7.C7_ZNUMPV = '" + cNumPed + "' "
				_cQuery += " WHERE C7.D_E_L_E_T_ = ' ' "
				_cQuery += " 	AND C7_FILIAL = '" + SC7->C7_FILIAL + "' "
				_cQuery += " 	AND C7_NUM = '" + SC7->C7_NUM + "' "
				nErrQry := TCSqlExec( _cQuery )
				If nErrQry <> 0
					Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
				EndIf
			Else
				MsgAlert("Pedido não gerado, verifique!")
				If ExistDir(_cDirRel)
					_lxRet := .T.
				Else
					If MakeDir(_cDirRel) == 0
						MakeDir(_cDirRel)
						_lxRet := .T.
					Else
						Aviso("Erro na Criação de Pasta","Para visualizar o log de erro de geração de Pedido de Venda é necessário que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
							CHR(10)+CHR(13)+;
							"Favor entrar em contato com o TI para que a criação da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
							CHR(10)+CHR(13)+;
							{"OK"},3)
						_lxRet := .F.
					EndIf
				EndIf
				If _lxRet
					fErase(_cDirRel + "\PED" + _cNumsc7 + ".log")
					CpyS2T(cStartPath + 'PED' + _cNumsc7 + '.log',_cDirRel,.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
					__CopyFile(cStartPath + 'PED' + _cNumsc7 + '.log', _cDirRel)
					ShellExecute("open",_cDirRel + "PED" + _cNumsc7 + ".log", "", "", 1)
				EndIf
			EndIf
		Else
			MsgAlert("Atenção, esse pedido não possui saldo para gerar um pedido de venda")
		EndIf
	Else
		MsgAlert("Atenção, essa rotina só deve ser utilizada para pedidos intra grupo, verifique!")
	EndIf

	If !Empty(cNumPed)
		MsgAlert("Pedido: " + cNumPed + " inserido com sucesso")
	EndIf

	RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³SXGERSC5	ºAutor  ³Renato Nogueira     º Data ³  25/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para gerar pedidos de venda através de um  º±±
±±º          ³pedido de compras					    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SXGERSC5(cNewEmp, cNewFil,lRpc03,aCabec,aSC6,_cNumsc7,_cTipoCli,_cZconsum)
//User Function SXGERSC5(cNewEmp, cNewFil,lRpc03,aCabec,aSC6,_cNumsc7)

	Local _nI
	Local _cTespd		:= ''
	Local nCount

	Private lMsErroAuto := .F.
	Private lInserido   := .F.
	Private cNumPed     := ""
	Default lRPC03 		:= .F. // cEmp 03
	Default cNewEmp		:= ""
	Default cNewFil		:= ""
	//Inicia outra Thread com outra empresa e filial

	If lRPC03
		RpcSetType(3)
		RpcSetEnv(cNewEmp,cNewFil,,,"FAT")
	Else
		RpcSetType(3)
		RpcSetEnv(cNewEmp,cNewFil,,,"FAT")
	EndIf
	
	/*
	If lRPC03
		PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil TABLES "SA1", "SC5", "SC6"
	Else
		PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil TABLES "SA1", "SC5", "SC6"
	EndIf
	SA1->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	*/

	dbSelectArea("SF4")
	SF4->( dbsetOrder(1) )

	dbSelectArea("SB2")
	SB2->( dbSetOrder(1) )	// B2_FILIAL + B2_COD + B2_LOCAL

	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )

	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )

	//Begin Transaction
		cARQLOG := '\arquivos\logs\detalhe_' + DtoS(dDatabase) + ".log"    // Valdemir Rabelo 20/01/2020
		If File(cArqLog)
		   FErase(cArqlog)
		EndIf 
		For _nI := 1 to Len(aSC6)
			SB2->( dbGoTop() )
			SA1->( dbGoTop() )
			If !dbSeek( xFilial("SB2") + aSc6[_nI][2][2] + aSc6[_nI][14][2] )
				CriaSb2(aSc6[_nI][2][2],"15" )
			EndIf
		Next _nI
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aSC6,3)
	//End Transaction

	//LjWriteLog( cARQLOG, "  " )

//_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")

	cError   := ""
	cLogErro := ""
	aErroAuto:= {}
	If lMsErroAuto
		MsgAlert("Erro ao inserir o pedido via execauto11111")
					MostraErro("LOGS","PC"+AllTrim(_cNumsc7)+".log")
					DisarmTransaction()
					RollBackSX8()
	Else
		ConOut("Pedido gerado: " + SC5->C5_NUM)
		lInserido	:= .T.
		cNumPed		:= SC5->C5_NUM
		ConfirmSX8()
	EndIf

	RpcClearEnv() //volta a empresa anterior

Return cNumPed

/*/{Protheus.doc} GetB1LocPad
Busca o armazem padrão da Matriz 010
@type function
@author thiago.fonseca
@since 02/12/2016
@version 1.0
@return ${return}, ${return_description}
/*/
User Function GetB1LocPad(cCodB1010)

	Local _aArea 		:= GetArea()
	Private cQrySB1 	:= ""
	Private cAlias 		:= "QRYSB1" + cEmpAnt + "0"
	Default cCodB1010	:= ""

	If cEmpAnt == "03"
		Begin Transaction
			cQrySB1 := " SELECT B1_COD, B1_DESC, B1_LOCPAD "
			cQrySB1 += " FROM SB1" + Iif(cEmpAnt == "03", "010", "030") + " B1 "
			cQrySB1 += " WHERE B1_COD = '" + cCodB1010 + "' "
			cQrySB1 += " 	AND B1.D_E_L_E_T_ = ' ' "
			If !Empty(Select(cAlias))
				dbSelectArea(cAlias)
				(cAlias)->( dbCloseArea() )
			EndIf
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySB1),cAlias,.T.,.T.)
			dbSelectArea(cAlias)
			(cAlias)->( dbGoTop() )
			While (cAlias)->( !Eof() )
				cLocPad010 := (cAlias)->B1_LOCPAD
				(cAlias)->( dbSkip() )
			EndDo
			//MsgAlert("Armazem Padrão: "+cLocPad010)
		End Transaction
	EndIf

	RestArea(_aArea)

Return cLocPad010
