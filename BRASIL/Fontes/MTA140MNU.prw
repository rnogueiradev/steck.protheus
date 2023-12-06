#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA140MNU sAutor  ³Vitor Merguizo      º Data ³  23/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para alterar o menu da rotina de           º±±
±±º           PRE NOTA de entrada                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA140MNU()

	AAdd(aRotina,{"NF Transferencia","U_PCMCMA01()",0,4,0,Nil})
	AAdd(aRotina,{"Notif. Recebimento", "U_STNOTREB", 0 , 5, 0, Nil})//Ticket - 20190412000053 - Everson Santana - 07.061.9
    AAdd(aRotina,{"Conf. recebimento", "U_STCONFREC", 0 , 5, 0, Nil})
Return(Nil)

//>>//Ticket - 20190412000053 - Everson Santana - 07.061.9

User Function STNOTREB()

	Local _aArea		:= GetArea()
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Notificação de Recebimento Físico de Mercadoria: NF ' + SF1->F1_DOC + IIF(!Empty(SF1->F1_SERIE), "/" + SF1->F1_SERIE,"") +" - "+POSICIONE("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")+ " " // Ticket - 20210629011069 - Everson Santana - 11.08.2021
	Local cFuncSent		:= "STNOTREB"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  		:= GetMv("ST_NOTREB",,"everson.santana@steck.com.br")
	Local _cCopia  		:= GetMv("ST_NOTREB1",,"everson.santana@steck.com.br")
	Local _cQry 		:= ""

	If cfilant ='05'
		_cEmail+= ' ;vanessa.dias@steck.com.br;jefferson.ferreira@steck.com.br  '
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cMsg += '<TR BgColor=#B0E2FF>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Nota Fiscal </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Serie </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Fornecedor </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Loja </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Nome </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Emissão </Font></B></TD>'

		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + SF1->F1_DOC + ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + SF1->F1_SERIE + ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + SF1->F1_FORNECE + ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + SF1->F1_LOJA + ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + POSICIONE("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME") + ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + DtoC(SF1->F1_EMISSAO) + ' </Font></B></TD>'

		//>> Ticket 20200911007175 - Everson Santana - 16.09.2020

		cMsg += '</Table><P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%><Caption> '
		cMsg += '</Caption><TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Pedido</Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Item</Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Codigo </Font></B>'
		cMsg += '</TD><TD><B><Font Color=#000000 Size="2" Face="Arial">Descrição </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Quantidade Solicitada </Font></B>'
		cMsg += '</TD><TD><B><Font Color=#000000 Size="2" Face="Arial">Quantidade Entregue </Font></B></TD>'

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_COD,B1.B1_DESC,D1.D1_EMISSAO,C7.C7_QUANT,D1.D1_QUANT,C7.C7_COMPSTK,Y1.Y1_EMAIL  "
		_cQry += " FROM "+RetSqlName("SD1")+" D1 "
		_cQry += " LEFT JOIN "+RetSqlName("SC7")+" C7 "
		_cQry += " ON C7.C7_FILIAL = D1.D1_FILIAL "
		_cQry += " AND C7.C7_NUM = D1.D1_PEDIDO "
		_cQry += " AND C7.C7_ITEM = D1.D1_ITEMPC "
		_cQry += " AND C7.D_E_L_E_T_ = ' ' "
		_cQry += " LEFT JOIN "+RetSqlName("SY1")+" Y1 "
		_cQry += " ON Y1.Y1_COD = C7.C7_COMPSTK "
		_cQry += "  AND Y1.D_E_L_E_T_ = ' ' "
		_cQry += " LEFT JOIN "+RetSqlName("SB1")+" B1"
		_cQry += " ON B1.B1_COD = D1.D1_COD"
		_cQry += "    AND B1.D_E_L_E_T_ = ' '"
		_cQry += " WHERE D1.D1_DOC = '"+SF1->F1_DOC+"' "
		_cQry += " AND D1.D1_SERIE = '"+SF1->F1_SERIE+"' "
		_cQry += " AND D1.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
		_cQry += " AND D1.D1_LOJA = '"+SF1->F1_LOJA+"' "
		_cQry += " AND D1.D_E_L_E_T_ = ' ' "
		_cQry += " ORDER BY D1_ITEMPC "

		TcQuery _cQry New Alias "TRD"

		TRD->(dbGoTop())

		While !EOF()

			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+TRD->D1_PEDIDO+' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+TRD->D1_ITEMPC+'</Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+TRD->D1_COD+'</Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+Alltrim(TRD->B1_DESC)+'</Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+Transform(TRD->C7_QUANT,"@E 999,999,999.99")+'</Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">'+Transform(TRD->D1_QUANT,"@E 999,999,999.99")+'</Font></B></TD>'

			If Empty(_cCopia) .and. !Empty(TRD->Y1_EMAIL)
				_cCopia := Alltrim(TRD->Y1_EMAIL)
			else
				If !Empty(TRD->Y1_EMAIL)
					If !Alltrim(TRD->Y1_EMAIL) $ _cCopia
						_cCopia += ";"+Alltrim(TRD->Y1_EMAIL)
					EndIf
				EndIf
			EndiF

			TRD->(dbSkip())

		END


		//<< Ticket 20200911007175

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'

		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'


		SF1->(RecLock("SF1",.F.))

		SF1->F1_XNOTREB := "S"
		SF1->F1_DTNOTIF := date() //DDATABASE

		SF1->(MsUnlock())

		//_cEmail := "everson.santana@steck.com.br"
		//_cCopia := ""
		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,' ')

	EndIf

	MsgAlert("Atenção, Notificação de Recebimento Enviada!")

	RestArea(_aArea)

Return()

//<<Ticket - 20190412000053 - Everson Santana - 07.061.9
