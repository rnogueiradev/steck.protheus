#INCLUDE 'PROTHEUS.CH'
/*
�������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������Ŀ��
���Fun��o    � M410AGRV � Autor � FABRICA DE SOFTWARE    	 								  � Data � 09/11/09 ���
���������������������������������������������������������������������������������������������������������������Ĵ��
���Descri��o � PE apos a confirmacao da gravacao do pedido.				                                           ���
���������������������������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Tipo Array																						���
���������������������������������������������������������������������������������������������������������������Ĵ��
���Cliente   � Especifico cliente Steck  													 			 		���
����������������������������������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������
*/
User Function M410AGRV()

	//>> Ticket 20190821000025 - Everson Santana - 18.09.2019
	Local _cAssunto := "Aviso de Emiss�o Pedido de Venda para Manaus "
	Local _cEmail  :=  GetMv('ST_GERSC5',,"everson.santana@steck.com.br")
	Local _cCopia  := ""
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "M410AGRV"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}
	Local _cMotPc:= ' '
	_nPosMOTPC  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ZMOTPC"})
	//<< Ticket 20190821000025 - Everson Santana - 18.09.2019

	U_STFS71F1()  //Limpa o status da tabela PE1 (Expedicao Manaus)
	U_STMAILC5()  //Chamado 001494

	If M->C5_TIPO $ "D#B"

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If !SA1->(DbSeek(xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI)))

			SA1->(RecLock("SA1",.T.))
			SA1->A1_COD 	:= M->C5_CLIENTE
			SA1->A1_LOJA	:= M->C5_LOJACLI
			SA1->A1_NOME	:= "XXXXX"
			SA1->(MsUnLock())

		EndIf

	EndIf

	//>> Ticket 20190821000025 - Everson Santana - 18.09.2019

	If cEmpAnt == '03'

		Aadd( _aMsg , { "Numero: "          , M->C5_NUM } )

		If Empty(aCols[01][_nPosMOTPC])
			Aadd( _aMsg , { "Motivo: "          ,"N�o Informado" } )
		Else
			Aadd( _aMsg , { "Motivo: "          ,aCols[01][_nPosMOTPC] } )
		EndIf

		If ( Type("l410Auto") == "U" .OR. !l410Auto )

			//�����������������������������������������������������������������������������Ŀ
			//� Definicao do cabecalho do email                                             �
			//�������������������������������������������������������������������������������
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//�����������������������������������������������������������������������������Ŀ
			//� Definicao do texto/detalhe do email                                         �
			//�������������������������������������������������������������������������������
			For _nLin := 1 to Len(_aMsg)
				If (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			Next

			//�����������������������������������������������������������������������������Ŀ
			//� Definicao do rodape do email                                                �
			//�������������������������������������������������������������������������������
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

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		EndIf

	EndIf

	//<< Ticket 20190821000025 - Everson Santana - 18.09.2019


Return