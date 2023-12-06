#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁMT103FIM	╨Autor  ЁRenato Nogueira     ╨ Data Ё  17/03/15   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁPonto de entrada apСs a inclusЦo do documento de entrada	  ╨╠╠
╠╠╨          Ё	    							 	 				      ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Parametro Ё Nenhum	                                                  ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╨Retorno   Ё Nenhum                                                     ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/ 

User Function MT103FIM()

	Local _aArea				:= GetArea()
	Local nCusto				:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_CC"})
	Local _nFatec				:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_XFATEC"})
	Local _lCusTi   			:= .F.
	Local _lFatec   			:= .F.
	Local nOpcao 	:= PARAMIXB[1]   // OpГЦo Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operaГЦo de gravaГЦo
	Local _nQtdSub			:= 0
	Local _cNumFatec			:= ""
	Local aAreaSD1	:= SD1->(GetArea())
	Local  ny:= 0
	Local  _nZ:= 0
	ZZ8->(dbSetOrder(1))	//ZZ8_FILIAL+ZZ8_REGIST
	SC7->(dbSetOrder(1))	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

	// Ponto de chamada ConexЦoNF-e sempre como primeira instruГЦo.
    U_GTPE002()
	
	If nConfirma == 1
		If nOpcao == 4
			SD1->(dbSetOrder(1))
			If SD1->(MsSeek( cChave := xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
				While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChave
					If SC7->(dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
						RecLock("SF1",.F.)
						SF1->F1_XPLAN := SC7->C7_XPLAN
						SF1->(MsUnlock())

						If ZZ8->(dbSeek(xFilial("ZZ8")+SC7->C7_XPLAN))
							RecLock("ZZ8",.F.)
							ZZ8->ZZ8_STATUS := 'B'
							ZZ8->(MsUnlock())
						EndIf

						EXIT
					EndIf
					SD1->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf

	If INCLUI .And. nConfirma==1

		For ny:=1 to len(aCols)

			If Alltrim(aCols[ny][nCusto]) = '112104'
				_lCusTi := .T.
			EndIf

			If !Empty(Alltrim(aCols[ny][_nFatec]))
				_lFatec := .T.
				_cNumFatec	:= Alltrim(aCols[ny][_nFatec])
			EndIf

		Next ny

		If _lCusTi
			MailTI()
		EndIf

		If cEmpAnt = '03'
			MailAMLogist()
		EndIf

		If _lFatec
			MailExp(_cNumFatec)
		EndIf

		// Processo do Avelino (Compensacao Thomson x Totvs ZTF - Jonathan 17/02/2022)
		
		If SF1->F1_ESPECIE == "CTE  " .And. !("GFE" $ FunName()) // CTE e nao processado a partir do GFE
			
			If ExistBlock( "PRESTTHO" )
				
				u_PrestTho() // Tela/Gravacao ZTG (Prestacao Thomson para Compensacao)
			EndIf
		EndIf

	EndIf

	/* Inibido por Emerson Holanda 04/09/23 - A Baixa do saldo sera efetuada pelas rotina padrУes.
	If nConfirma==1 .And. TYPE("_aCols")=="A" //gravar multiplos pedidos e mata os saldos

		If Len(_aCols)>0

			For _nZ:=1 To Len(_aCols)

				If _aCols[_nZ][5]>0

					DbSelectArea("SC7")
					SC7->(DbGoTop())
					SC7->(DbGoTo(_aCols[_nZ][7]))

					If SC7->(!Eof())

						SC7->(RecLock("SC7",.F.))
						SC7->C7_QUJE	:= SC7->C7_QUJE+_aCols[_nZ][5]
						SC7->(MsUnLock())

						DbSelectArea("ZZS")
						ZZS->(DbSetOrder(1)) //ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA+ZZS_PEDCOM+ZZS_ITEMPC+ZZS_ITEMNF
						ZZS->(DbGoTop())
						If !ZZS->(DbSeek(_aCols[_nZ][8]+_aCols[_nZ][9]+_aCols[_nZ][10]+_aCols[_nZ][11]+_aCols[_nZ][12]+SC7->(C7_NUM+C7_ITEM)+_aCols[_nZ][13]))

							ZZS->(RecLock("ZZS",.T.))
							ZZS->ZZS_FILIAL	:=	_aCols[_nZ][8]
							ZZS->ZZS_NF		:=	_aCols[_nZ][9]
							ZZS->ZZS_SERIE	:=	_aCols[_nZ][10]
							ZZS->ZZS_FORNEC	:=	_aCols[_nZ][11]
							ZZS->ZZS_LOJA		:=	_aCols[_nZ][12]
							ZZS->ZZS_PEDCOM	:=	SC7->C7_NUM
							ZZS->ZZS_ITEMPC	:=	SC7->C7_ITEM
							ZZS->ZZS_ITEMNF	:=	_aCols[_nZ][13]
							ZZS->ZZS_QTDNF	:=	_aCols[_nZ][4]
							ZZS->ZZS_QTDPC	:=	SC7->C7_QUANT
							ZZS->ZZS_QTDSUB	:=	_aCols[_nZ][5]
							ZZS->(MsUnLock())

						EndIf

					EndIf

				EndIf

			Next

		EndIf

		If Len(_aCols)>0
			_aCols	:= Nil
		Endif

	ElseIf nConfirma==0 .And. TYPE("_aCols")=="A"

		If Len(_aCols)>0
			_aCols	:= Nil
		EndIf

	EndIf
	*/

	RestArea(aAreaSD1)
	RestArea(_aArea)

Return()

Static Function MailAMLogist()

	Local aArea 	:= GetArea()
	Local _cFrom   := "wf.protheus@steck.com.br"
	Local _cAssunto:= 'NF DE ENTRADA MAO'
	Local cFuncSent:= "MailAMLogist"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  :=  getmv('ST_LGMAIL',,'willians.silva@steck.com.br;GIOVANI.ZAGO@STECK.COM.BR')

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))


		Aadd( _aMsg , { "NF Num: "          , SF1->F1_DOC } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Status: "    		, "inclusao" } )
		If 	SA2->(DbSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA ))
			Aadd( _aMsg , { "Forncedor: "  		, SA2->A2_COD+SA2->A2_LOJA + '-'+SA2->A2_NREDUZ } )
		EndIf
		Aadd( _aMsg , { "Usuario: " 	 	, cUserName } )


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
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

	/*====================================================================================\
	|Programa  | MailTI           | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
	|=====================================================================================|
	|DescriГЦo | MailTI                                                                   |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | MailTI                                                                   |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................HistСrico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  MailTI()
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'NF DE ENTRADA COM CC DE T.I.'
	Local cFuncSent:= "MailTI"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'GIOVANI.ZAGO@STECK.COM.BR '
	Local cAttach  := ''

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := 'GIOVANI.ZAGO@STECK.COM.BR'

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))


		Aadd( _aMsg , { "NF Num: "          , SF1->F1_DOC } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Status: "    		, "inclusao" } )
		Aadd( _aMsg , { "CC: "    			, '112104' } )
		If 	SA2->(DbSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA ))
			Aadd( _aMsg , { "Forncedor: "  		, SA2->A2_COD+SA2->A2_LOJA + '-'+SA2->A2_NREDUZ } )
		EndIf
		Aadd( _aMsg , { "Usuario: " 	 	, cUserName } )


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
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

	/*====================================================================================\
	|Programa  | MailExp           | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
	|=====================================================================================|
	|DescriГЦo | MailExp                                                                   |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | MailExp                                                                   |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................HistСrico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  MailExp(_cFatec)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'NF DE ENTRADA DE FATEC'
	Local cFuncSent:= "MailExp"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ''
	Local cAttach  := ''

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := 'Marcelo.Galera@steck.com.br'

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))


		Aadd( _aMsg , { "NF Num: "          , SF1->F1_DOC } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Status: "    		, "inclusao" } )
		Aadd( _aMsg , { "Fatec: "    		, _cFatec } )

		If 	SA2->(DbSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA ))
			Aadd( _aMsg , { "Fornecedor: "  		, SA2->A2_COD+SA2->A2_LOJA + '-'+SA2->A2_NREDUZ } )
		EndIf
		Aadd( _aMsg , { "Usuario: " 	 	, cUserName } )


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
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
