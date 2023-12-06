#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIL   º Autor ³ SAULO CARVALHO     º Data ³  22/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PE para tratamento de pedidos do tipo retira.               º±±
±±º          ³Serah possivel filtrar somente os pedidos retira.           º±±
±±º          ³Ref: ITEM 4.6 513603 v3                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M460FIL()

	Local cRetFil		:= ""
	Local lAbort		:= .T.

	Processa( { || cRetFil := FilProce() },'Aguarde','Selecionando Registros...',@lAbort )

Return cRetFil

Static Function FilProce()

	Local _cFilSC9		:= ""
	Local _cPedido		:= ""
	Local _cItemPV		:= ""
	Local _cQuery		:= ""
	Local _aQuery		:= {}
	Local cMVXPGAVIS	:= SuperGetMV("MV_XPGAVIS",.F.,"501")
	Local cMVXSTCLI		:= SuperGetMV("MV_XSTCLI",.F.,"033467")		//Leo -> Verificacao se o cliente e' a propria STECK
	Local _cOrder  		:= '%ZZ2_PEDIDO%'
	Local _cErro		:= ""
	Local _lInc			:= .T.
	Local _cFa10Oper    :=  GetMv("ST_FAOPER",,'74')//Giovani zago 14/06/2013 Tipos de Operação que nao entram na separação
	Local _lTrocNf      := .F.//giovani zago 27/01/2014 troca de nf
	Local _cInvent      := .T. // Variavel para analisar se no pedido de venda existe algum item em inventario rotativo

	If cEmpAnt=="01"
		MsgAlert("Atenção, rotina desativada para São Paulo, verifique!")
		_cFilSC9 := " C9_FILIAL = 'XX'
		Return(_cFilSC9)
	EndIf

	If MsgBox('Deseja filtrar somente os pedidos de retira para os parâmetros informados?','Atenção','YESNO')

		BeginSql alias 'TRB01'
			SELECT DISTINCT ZZ2_PEDIDO
			FROM %table:ZZ2% ZZ2
			WHERE
			ZZ2_FILIAL = %xfilial:ZZ2% AND
			ZZ2_DTENTR = %exp:dDatabase% AND
			ZZ2_DTSAID = %exp:' '% AND
			ZZ2_OBS = %exp:' '% AND
			ZZ2.%notDel%
			ORDER BY %Exp:_cOrder%
		EndSql
		_aQuery := GETLastQuery()

		ProcRegua( 0 )

		dbSelectArea("TRB01")
		dbGoTop()
		While TRB01->(!Eof())

			If !_lInc
				MsgAlert(_cErro)
				_lInc := .T.
			EndIf

			_cErro := "O Pedido "+TRB01->ZZ2_PEDIDO+" possui divergencias: "

			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5")+TRB01->ZZ2_PEDIDO) .And. Empty(Alltrim(SC5->C5_TRANSP))//Giovani.Zago  24/05/2013
				_cErro += "Transportadora em Branco."
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			//Renato Nogueira - Bloquear faturamento para clientes bloqueados - Solicitação Rogério Martelo - 09092013
			DbSelectArea("SA1")
			DbSetOrder(1)
			If	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

				If SA1->A1_MSBLQL=="1"
					_cErro += "Cliente bloqueado"
					_lInc := .F.
					TRB01->(dbSkip())
					Loop
				EndIf
				// Giovani Zago 06/08/2015 chamado 002099
				If GetMv("ST_FINLIB",,.F.)
					If SA1->A1_XBLQFIN=="1"
						_cErro += "Cliente bloqueado Fin."
						_lInc := .F.
						TRB01->(dbSkip())
						Loop
					EndIf

				EndIf

				// Giovani Zago 27/07/2016 chamado 003740
				If GetMv("ST_FINLIB2",,.F.)
					If !(Empty(SA1->A1_XDTSERA)) .And. !( SC5->C5_CONDPAG $ ('501/599/FRC' )) .And. SA1->A1_TIPO <> 'X'
						If dDataBase > (SA1->A1_XDTSERA + getmv("ST_FINLIB3",,160) )
							_cErro += "Cliente bloqueado Fin.SERASA"
							_lInc := .F.
							TRB01->(dbSkip())
							Loop
						EndIf

					EndIf
				EndIf
			EndIf

			//Giovani Zago Não faturar 2 os e uma em aberto 14/04/14
			DbSelectArea('CB7')
			CB7->(DbSetOrder(2))
			CB7->(dbSeek(xFilial('CB7')+SC5->C5_NUM))
			While CB7->(!EOF()  .and. CB7_FILIAL+CB7_PEDIDO ==xFilial('CB7')+SC5->C5_NUM)

				If Val(CB7->CB7_STATUS) < 4
					_cErro += "OS em Aberto"
					_lInc := .F.
				EndIf
				If !VERIFCB9(CB7->CB7_FILIAL,CB7->CB7_ORDSEP)
					_cErro += "Volume aberto"
					_lInc  := .F.
				EndIf

				CB7->(dbSkip())
			End
			If !_lInc
				TRB01->(dbSkip())
				Loop
			EndIf

			//Giovani Zago Bloquear refatuamento de pedidos 26/08/13  -  solicitação Simone Soares
			If SC5->C5_ZREFNF  = "1"
				_cErro += "Refaturamento Bloqueado"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			//Chamado 003597 - Pedido triangular
			If !Empty(SC5->C5_XPEDTRI)
				MsgInfo("Atenção, pedido triangular referente ao pedido: "+SC5->C5_XPEDTRI,"Atenção")
			EndIf

			//________________________________________________________________________________
			If SC5->C5_XTNTFOB  = "1"
				_cErro += "Tnt/Fob Bloqueado"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			If !(SC5->C5_CLIENTE $ cMVXSTCLI)	  .And.   !(Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,"C6_OPER") $  _cFa10Oper ) .And. !_lTrocNf	//Leo -> Verificacao se o cliente e' a propria STECK  //Giovani Zago liberar tipos de operação// giovani zago troca de nota 28/01/14
				If SC5->C5_CONDPAG $ cMVXPGAVIS .And. SC5->C5_XLIBAVI <> "S"
					_cErro += "Condição de Pagamento a Vista."
					_lInc := .F.
					TRB01->(dbSkip())
					Loop
				EndIf

				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SC5->C5_NUM)
					If Posicione("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_ESTOQUE") == "S"
						SC9->(dbSeek(xFilial("SC9")+TRB01->C5_NUM))
						While !SC9->(Eof()) .And. SC9->C9_PEDIDO == TRB01->C5_NUM
							If Empty(SC9->C9_ORDSEP)
								_cErro += "Ordem de Separacao em Branco."
								_lInc := .F.
								Exit
							EndIf
							If dbSeek(xFilial("CB7")+SC9->C9_ORDSEP)
								If CB7->CB7_STATUS <> "4"
									_cErro += "Ordem de Separacao "+SC9->C9_ORDSEP+" pendente."
									_lInc := .F.
									Exit
								EndIf
							Else
								_cErro += "Ordem de Separacao "+SC9->C9_ORDSEP+" nao Localizada."
								_lInc := .F.
								Exit
							EndIf
							SC9->(dbSkip())
						EndDo
					EndIf
				EndIf
			EndIf

			If _lInc
				_cPedido += IIf(!Empty(_cPedido),"#","")+TRB01->ZZ2_PEDIDO
			Else
				MsgAlert(_cErro)
			EndIf

			_lInc := .T.

			TRB01->(dbSkip())
		EndDo

		//	DbEval({|| _cPedido += IIf(!Empty(_cPedido),"#","")+TRB01->ZZ2_PEDIDO}, {||.T. } )

		If !Empty(_cPedido)
			_cFilSC9 := " C9_FILIAL = '"+xFilial("SC9")+"' .AND. C9_PEDIDO $ '"+_cPedido+"' "
		Else
			_cFilSC9 := " C9_FILIAL = '"+xFilial("SC9")+"' .AND. C9_PEDIDO = '"+_cPedido+"' "
			MsgBox('Não há cliente para retirar pedido hoje('+Dtoc(dDatabase)+'). Verifique se a recepção apontou a entrada do cliente na empresa!','Atenção','INFO')
		Endif

		TRB01->(DbCloseArea("TRB01"))
	Else
		_cQuery := " SELECT * "
		_cQuery += " FROM "+RETSQLNAME("SC9")+" SC9"
		_cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"'"
		_cQuery += "   AND C9_PEDIDO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
		_cQuery += "   AND C9_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
		_cQuery += "   AND C9_LOJA BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
		_cQuery += "   AND C9_DATALIB BETWEEN '"+DtoS(MV_PAR11)+"' AND '"+DtoS(MV_PAR12)+"'"
		_cQuery += "   AND C9_NFISCAL = ' '"
		_cQuery += "   AND SC9.D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY C9_PEDIDO"

		TCQuery _cQuery New Alias "TRB01"

		ProcRegua( 0 )

		dbSelectArea("TRB01")
		dbGoTop()
		While TRB01->(!Eof())

			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(xFilial("SC5")+TRB01->C9_PEDIDO))

				_lTrocNf      := !Empty(Alltrim(SC5->C5_XTRONF))//giovani zago 27/01/2014 troca de nf
			EndIf

			dbSelectArea("CBA")
			CBA->(dbSetOrder(4))
			CBA->(dbGoTop())
			If CBA->(dbSeek(xFilial("CBA")+TRB01->C9_PRODUTO+"1"+TRB01->C9_LOCAL)) // Filtra itens do pedido de venda que estejam em inventario rotativo.
				while CBA->(!eof()) .and. TRB01->C9_PRODUTO == CBA->CBA_PROD .AND. CBA->CBA_XROTAT = "1" .AND. TRB01->C9_LOCAL == CBA->CBA_LOCAL

					if CBA->CBA_STATUS $ "1/2/3/4/6"

						MSGALERT("O item " +ALLTRIM(TRB01->C9_PRODUTO)+ " do pedido "+ TRB01->C9_PEDIDO + " está em inventario rotativo e não será liberado para faturar!")
						_lInc := .F.
						_cInvent := .F.
						TRB01->(dbSkip())
						Loop

					elseif CBA->CBA_STATUS = "5"

						dbSelectArea("SB7")
						SB7->(dbSetOrder(3))
						SB7->(dbGoTop())
						If SB7->(dbSeek(xFilial("SB7")+CBA->CBA_CODINV))

							if SB7->B7_STATUS = "1"
								MSGALERT("O item " +TRB01->C9_PRODUTO+ " do pedido "+ TRB01->C9_PEDIDO + "está em inventario rotativo e será liberado para faturar!")
								_lInc := .F.
								_cInvent := .F.
								TRB01->(dbSkip())
								Loop
							endif

						endif

					endif
					CBA->(dbSkip())
				end

			Endif

			If !_lInc
				MsgAlert(_cErro)
				_lInc := .T.
			EndIf

			_lInc := .T.
			_cErro := "O Pedido "+TRB01->C9_PEDIDO+" possui divergencias: "

			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5")+TRB01->C9_PEDIDO) .And. Empty(Alltrim(SC5->C5_TRANSP))//Giovani.Zago  24/05/2013
				_cErro += "Transportadora em Branco."
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			//Renato Nogueira - Bloquear faturamento para clientes bloqueados - Solicitação Rogério Martelo - 09092013
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			If SA1->(!Eof()) .And. SC5->C5_TIPO=="N"
				If SA1->A1_MSBLQL=="1"
					_cErro += "Cliente bloqueado"
					_lInc := .F.
					TRB01->(dbSkip())
					Loop
				EndIf
				// Giovani Zago 06/08/2015 chamado 002099
				If GetMv("ST_FINLIB",,.F.)
					If SA1->A1_XBLQFIN=="1"
						_cErro += "Cliente bloqueado Fin."
						_lInc := .F.
						TRB01->(dbSkip())
						Loop
					EndIf
				EndIf

				// Giovani Zago 27/07/2016 chamado 003740
				If GetMv("ST_FINLIB2",,.F.)
					If !(Empty(SA1->A1_XDTSERA)) .And. !( SC5->C5_CONDPAG $ ('501/599/FRC' )) .And. SA1->A1_TIPO <> 'X'
						If dDataBase > ( SA1->A1_XDTSERA + getmv("ST_FINLIB3",,160) )
							_cErro += "Cliente bloqueado Fin.SERASA"
							_lInc := .F.
							TRB01->(dbSkip())
							Loop
						EndIf

					EndIf
				EndIf
			EndIf

			//Giovani Zago Não faturar 2 os e uma em aberto 14/04/14
			DbSelectArea('CB7')
			CB7->(DbSetOrder(2))
			CB7->(dbSeek(xFilial('CB7')+SC5->C5_NUM))
			While CB7->(!EOF()  .and. CB7_FILIAL+CB7_PEDIDO ==xFilial('CB7')+SC5->C5_NUM)

				If Val(CB7->CB7_STATUS) < 4
					_cErro += "OS em Aberto"
					_lInc := .F.
				EndIf
				If !VERIFCB9(CB7->CB7_FILIAL,CB7->CB7_ORDSEP)
					_cErro += "Volume aberto"
					_lInc  := .F.
				EndIf

				CB7->(dbSkip())
			End
			If !_lInc
				TRB01->(dbSkip())
				Loop
			EndIf
			//Giovani Zago Bloquear refatuamento de pedidos 26/08/13  -  solicitação Simone Soares
			If SC5->C5_ZREFNF  = "1"
				_cErro += "Refaturamento Bloqueado"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			//Chamado 003597 - Pedido triangular
			If !Empty(SC5->C5_XPEDTRI)
				MsgInfo("Atenção, pedido triangular referente ao pedido: "+SC5->C5_XPEDTRI,"Atenção")
			EndIf

			If SC5->C5_XTNTFOB  = "1"
				_cErro += "Tnt/Fob Bloqueado"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf

			If !(Empty(Alltrim(SC5->C5_XALERTF)))

				MsgAlert(SC5->C5_XALERTF)
			EndIf

			If SC5->C5_XOPER32 = "2"
				_cErro += "Venda de Ativo, Solicite Liberação a Controladoria"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf
			//>>Ticket 20191107000028 - Everson Santana 08.11.2019
			If SC5->C5_XOPERCO = "2"
				_cErro += "Remessa de Comodato, Solicite Liberação do Fiscal"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf
			//<<Ticket 20191107000028 - Everson Santana 08.11.2019
			//________________________________________________________________________________

			If !SC5->C5_CLIENTE $ cMVXSTCLI	 .And.   !(Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,"C6_OPER") $  _cFa10Oper ).And. !_lTrocNf	//Leo -> Verificacao se o cliente e' a propria STECK
				If SC5->C5_CONDPAG $ cMVXPGAVIS .And. SC5->C5_XLIBAVI <> "S"
					_cErro += "Condição de Pagamento a Vista."
					_lInc := .F.
					TRB01->(dbSkip())
					Loop
				EndIf

				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SC5->C5_NUM)
					If Posicione("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_ESTOQUE") == "S"
						dbSelectArea("CB7")
						dbSetOrder(1)
						If Empty(TRB01->C9_ORDSEP)
							_cErro += "Ordem de Separacao em Branco."
							_lInc := .F.
							TRB01->(dbSkip())
							Loop
						EndIf
						If dbSeek(xFilial("CB7")+TRB01->C9_ORDSEP)
							If CB7->CB7_STATUS <> "4"
								_cErro += "Ordem de Separacao "+TRB01->C9_ORDSEP+" pendente."
								_lInc := .F.
								TRB01->(dbSkip())
								Loop
							EndIf
						Else
							_cErro += "Ordem de Separacao "+TRB01->C9_ORDSEP+" nao Localizada."
							_lInc := .F.
							TRB01->(dbSkip())
							Loop
						EndIf
					EndIf
				EndIf
			Endif
			//Chamado 002701 Abre
			IF SC5->C5_CLIENTE $ cMVXSTCLI	 .And.   (Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,"C6_OPER") $  SuperGetMV("ST_OPEREMB",.F.,"15")) .And. cFilAnt == '01'//Apenas para a Filial 01 de SP e AM
				_cErro += "Operação "+SuperGetMV("ST_OPEREMB",.F.,"15")+" deve ser faturada pela rotina de Embarque...!!!"
				_lInc := .F.
				TRB01->(dbSkip())
				Loop
			EndIf
			//Chamado 002701 Fecha

			If !TRB01->C9_PEDIDO $ _cPedido
				_cPedido += IIf(!Empty(_cPedido),"#","")+TRB01->C9_PEDIDO
			EndIf

			_cItemPV += IIf(!Empty(_cItemPV),"#","")+TRB01->C9_ITEM

			If !_lInc
				MsgAlert(_cErro)
				_lInc := .T.
			EndIf

			TRB01->(dbSkip())
		EndDo

		If !_lInc
			MsgAlert(_cErro)
		EndIf

		If !Empty(_cPedido)
			IF !_cInvent
				_cFilSC9 := " " // Caso um item do pedido de venda estiver em inventario Rotativo, não trazer nenhum item do pedido para faturar. - Robson Mazzarotto
			ELSE
				_cFilSC9 := " C9_FILIAL = '"+xFilial("SC9")+"' .AND. C9_PEDIDO $ '"+_cPedido+"' "// .AND. C9_ITEM $ '"+_cItemPV+"' " //Leonardo Flex -> comentado 18/04/13
			ENDIF
		Else
			_cFilSC9 := " C9_FILIAL = '"+xFilial("SC9")+"' .AND. C9_PEDIDO = '"+_cPedido+"' "
			//MsgBox('Não há cliente para retirar pedido hoje('+Dtoc(dDatabase)+'). Verifique se a recepção apontou a entrada do cliente na empresa!','Atenção','INFO')
		Endif

		TRB01->(DbCloseArea("TRB01"))
	Endif

	U_STDELPED(MV_PAR05,MV_PAR06) //Validação para verificar se o pedido tem mais de um vendedor igual - Comissões dobradas - Renato 02/10/2013

Return(_cFilSC9)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERIFCB9  ºAutor  ³Renato Nogueira     º Data ³  11/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se tem volume em aberto							  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VERIFCB9(_cFilial,_cOrdsep)

	Local _lRet		:= .T.
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	 := " SELECT FILIAL, ORDSEP, TOTALOS "
	cQuery1  += " ,(SELECT SUM(CB9_QTEEMB) FROM "+RetSqlName("CB9")+" B9 WHERE B9.D_E_L_E_T_=' '
	cQuery1	 += " AND CB9_FILIAL=FILIAL AND CB9_ORDSEP=ORDSEP) TOTALEMB "
	cQuery1  += " FROM ( "
	cQuery1	 += " SELECT CB8_FILIAL FILIAL, CB8_ORDSEP ORDSEP, SUM(CB8_QTDORI) TOTALOS "
	cQuery1  += " FROM "+RetSqlName("CB8")+" B8 "
	cQuery1	 += " WHERE B8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+_cFilial+"' AND CB8_ORDSEP='"+_cOrdsep+"' "
	cQuery1  += " GROUP BY CB8_FILIAL, CB8_ORDSEP ) "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->TOTALOS<>(cAlias1)->TOTALEMB
		_lRet	:= .F.
	EndIf

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery1  += " WHERE CB6.D_E_L_E_T_=' ' AND CB6_FILIAL='"+_cFilial+"' AND CB6_XORDSE='"+_cOrdsep+"' "
	cQuery1  += " AND CB6_XPESO=0 "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR>0
		_lRet	:= .F.
	EndIf

Return(_lRet)

