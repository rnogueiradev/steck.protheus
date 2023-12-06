#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFAT_3_5_A      | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Adiciona menu de troca de vendedor no Ponto de Entrada    A410Cons      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFAT_3_5_A                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STFAT35A()
	*---------------------------------------------------*
	local aRetBot:={}
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If (Empty(SA3->A3_SUPER)   .Or. Empty(SA3->A3_GEREN)) .Or. __cUserId $ GetMv("ST_TRCVEND")
			aAdd(aRetBot,{"POSCLI"  , {|| U_STFAT35B()} ,"Troca Vendedor"})
		EndIf
	EndIf

	aAdd(aRetBot,{"POSCLI"  , {|| U_STMENGAP07("1") } ,"Aplicar Desconto"})//gap 07

	aAdd(aRetBot,{"POSCLI"  , {|| U_STMENGAP07("2")} ,"Aplicar Acrescimo"})//gap 07

	aAdd(aRetBot,{"POSCLI"  , {|| U_STOCNO() } ,"Aplicar Ordem de Compra"})//gap 07



	aRetBot:= aclone(aRetBot)
	Return ( aRetBot )


	/*====================================================================================\
	|Programa  | STFAT35B            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  Troca de Vendedor                                                       |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFAT35B                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
User Function STFAT35B()
	*---------------------------------------------------*

	Local cVendMemory :=  M->C5_VEND1
	Local cVendNew    :=  M->C5_VEND1
	Local cVend2      :=  M->C5_VEND2
	Local cVendNew2   :=  M->C5_VEND2

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Vendedor") From 1,0 To 16,25 OF oMainWnd

	@ 05,04 SAY "Vendedor1:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid(existcpo("SA3",cVendNew)  .Or. Empty(cVendNew))
	@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail

	@ 05+40,04 SAY "Vendedor2:" PIXEL OF oDlgEmail
	@ 15+40,04 MSGet cVendNew2 	F3 'SA3INT'	  Size 35,012  PIXEL OF oDlgEmail Valid ((existcpo("SA3",cVendNew2) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_TPVEND")="I") .Or. Empty(cVendNew2))
	@ 35+40,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
	@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		M->C5_VEND1    := cVendNew
		M->C5_VEND2    := cVendNew2
		M->C5_XHISVEN := SUBSTR(Alltrim(cusername),1,28)+' / '+dtoc(date())+' / '+Time()

		//LIMPA O RATEIO CASO EXISTA
		M->C5_VEND3   :=  ''
		M->C5_VEND4   :=  ''
		M->C5_VEND5   :=  ''
		M->C5_XRATEI1 :=  0
		M->C5_XRATEI3 :=  0
		M->C5_XRATEI4 :=  0
		M->C5_XRATEI5 :=  0
		M->C5_XVALRA1 :=  0
		M->C5_XVALRA3 :=  0
		M->C5_XVALRA4 :=  0
		M->C5_XVALRA5 :=  0
		U_STFATI3_7_1('371B') //RECALCULA COMISSAO

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Pedido: </b>'+Alltrim(M->C5_NUM)+'<br><b>Usuário: </b>'+Alltrim(cUserName)+'<br>'
		cMsg += '<b>Vendedor1 de: </b>'+M->C5_VEND1+'<br>'
		cMsg += '<b>Vendedor1 para: </b>'+cVendNew+'<br>'
		cMsg += '<b>Vendedor2 de: </b>'+M->C5_VEND2+'<br>'
		cMsg += '<b>Vendedor2 para: </b>'+cVendNew2+'<br>'
		cMsg += '</body></html>'

	Else
		M->C5_VEND  := cVendMemory
		M->C5_VEND2 := cVend2
	Endif

	Return()





	/*====================================================================================\
	|Programa  | STCARTRO            | Autor | GIOVANI.ZAGO          | Data | 07/08/2015 |
	|=====================================================================================|
	|Descrição |  Troca de carteira de vendedor                                           |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCARTRO                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
User Function STCARTRO()
	*---------------------------------------------------*

	Local cVendMemory :=  Space(6)
	Local cVendNew    :=  Space(6)
	Local cVend2      :=  Space(6)
	Local cVendNew2   :=  Space(6)

	If __cUserId $ GetMv("ST_CARTRO",,"000000")+"000000/000645/000196"

		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Troca de Carteira") From 1,0 To 16,25 OF oMainWnd

		@ 05,04 SAY "Vendedor de:" PIXEL OF oDlgEmail
		@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid(  Empty(cVendNew) .Or. existcpo("SA3",cVendNew) )
		@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail

		@ 05+40,04 SAY "Vendedor Para:" PIXEL OF oDlgEmail
		@ 15+40,04 MSGet cVendNew2 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid ( Empty(cVendNew2) .Or. existcpo("SA3",cVendNew2) )
		@ 35+40,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
		@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
		@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


		nOpca:=0

		ACTIVATE MSDIALOG oDlgEmail CENTERED

		If nOpca == 1
			If  !(Empty(Alltrim(cVendNew2)))  .And.  !(Empty(Alltrim(cVendNew)))
				cQry := " UPDATE SA1010 SET A1_VEND = '"+cVendNew2+"' WHERE A1_VEND = '"+cVendNew+"' "
				TcSQLExec(cQry)

				cQry := " UPDATE SUA010 SET UA_VEND = '"+cVendNew2+"' WHERE UA_VEND = '"+cVendNew+"' "
				TcSQLExec(cQry)

				cQry := " UPDATE SUA010 SET UA_VEND2 = '"+cVendNew2+"' WHERE UA_VEND2 = '"+cVendNew+"' "
				TcSQLExec(cQry)

				cQry := " UPDATE PP7010 SET PP7_REPRES = '"+cVendNew2+"' WHERE PP7_REPRES = '"+cVendNew+"'"
				TcSQLExec(cQry)

				STTROCAR(cVendNew,cVendNew2)
				MsgInfo("Troca Realizada...!!!!!!!!!!!!")
			Else
				MsgInfo("Preencha o Vendedor....!!!! Troca Não Realizada...")
			Endif
		Endif
	Else
		MsgInfo("Usuario Nao Autorizado.......")
	Endif
	Return()

	/*====================================================================================\
	|Programa  | MailPrev         | Autor | GIOVANI.ZAGO             | Data | 07/08/2015  |
	|=====================================================================================|
	|Descrição | MailPrev                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | MailPrev                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  STTROCAR(cVendNew,cVendNew2)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Troca de Carteira'
	Local cFuncSent:= "MailPrev"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _cEmail  :=  ' '
	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := " daniel.santos@steck.com.br"

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Vendedor de"       , cVendNew + " - " + substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)} ) // chamado 005504 - Robson Mazzarotto
		Aadd( _aMsg , { "Vendedor para"     , cVendNew2 + " - " + substr(Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_NOME"),1,30)} ) // chamado 005504 - Robson Mazzarotto
		Aadd( _aMsg , { "Usuario"  			, cUserName } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) 

	EndIf
	RestArea(aArea)
Return()



User Function STOCNO()

	Local cVendMemory :=  Space(6)
	Local cVendNew    :=  Space(16)
	Local cVend2      :=  Space(6)
	Local cVendNew2   :=  Space(6)
	Local _nPosCamp	    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_NUMPCOM"})
	Local i:= 0

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Ordem de Compra") From 1,0 To 16,25 OF oMainWnd

	@ 05,04 SAY "Ordem de Compra:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	 	  Size 35,012  PIXEL OF oDlgEmail

	@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		If    !(Empty(Alltrim(cVendNew)))



			For i:=1 To Len(Acols)

				aCols[i][_nPosCamp]	  := cVendNew

			next i

			MsgInfo("Ordem de Compra Realizada...!!!!!!!!!!!!")
		Else
			MsgInfo("Preencha o Campo....!!!!   Não Realizada...")
		Endif
	Endif



	Return




	*---------------------------------------------------*
User Function STTRVEN()
	*---------------------------------------------------*

	Local cVendMemory :=  SC5->C5_VEND1
	Local cVendNew    :=  SC5->C5_VEND1
	Local cVend2      :=  SC5->C5_VEND2
	Local cVendNew2   :=  SC5->C5_VEND2

	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If (Empty(SA3->A3_SUPER)   .Or. Empty(SA3->A3_GEREN)) .Or. __cUserId $ GetMv("ST_TRCVEND")

		Else
			MsgInfo('Usuario sem acesso.....!!!!!')
			Return()
		EndIf
	EndIf





	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Vendedor") From 1,0 To 16,25 OF oMainWnd

	@ 05,04 SAY "Vendedor1:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid(existcpo("SA3",cVendNew)  .Or. Empty(cVendNew))
	@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail

	@ 05+40,04 SAY "Vendedor2:" PIXEL OF oDlgEmail
	@ 15+40,04 MSGet cVendNew2 	F3 'SA3INT'	  Size 35,012  PIXEL OF oDlgEmail Valid ((existcpo("SA3",cVendNew2) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_TPVEND")="I") .Or. Empty(cVendNew2))
	@ 35+40,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
	@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		RecLock("SC5", .F.)
		SC5->C5_VEND1    := cVendNew
		SC5->C5_VEND2    := cVendNew2
		SC5->C5_XHISVEN := SUBSTR(Alltrim(cusername),1,28)+' / '+dtoc(date())+' / '+Time()
		SC5->(MsUnlock())

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Pedido: </b>'+Alltrim(SC5->C5_NUM)+'<br><b>Usuário: </b>'+Alltrim(cUserName)+'<br>'
		cMsg += '<b>Vendedor1 de: </b>'+SC5->C5_VEND1+'<br>'
		cMsg += '<b>Vendedor1 para: </b>'+cVendNew+'<br>'
		cMsg += '<b>Vendedor2 de: </b>'+SC5->C5_VEND2+'<br>'
		cMsg += '<b>Vendedor2 para: </b>'+cVendNew2+'<br>'
		cMsg += '</body></html>'

	Endif

Return()








