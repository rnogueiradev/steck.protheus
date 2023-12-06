#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDPED  ºAutor  ³Renato Nogueira     º Data ³  30/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para fazer validar tipo de operacao, faltaº±±
±±º          ³ e reserva do pedido                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//--------------------------------------------------------------------------//
//FR - 15/01/2022 - ALTERAÇÃO - Integração CRM - Cotações  
//Adequar msg de retorno quando a chamada vier do POST STCRM003
//--------------------------------------------------------------------------//
User Function STVLDPED(cOrd,cPedido)
	
	Local aArea     := GetArea()
	Local aAreaSC5  := SC5->(GetArea())
	Local aAreaSC6  := SC6->(GetArea())
	Local aAreaSUA  := SUA->(GetArea())
	Local aAreaSUB  := SUB->(GetArea())
	Local aPA1Area 	:= PA1->(GetArea())
	Local aPA2Area 	:= PA2->(GetArea())
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYTEMP2"
	Local lRet		:= .T.
	Local cErro		:= ""
	Local _cEmail   := "everson.santana@steck.com.br"
	Local _cCopia   := ""
	Local _cAssunto := 'Problema em pedido'
	Local cMsg	    := ""
	//Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cOerFalRes   := GetMv("ST_OPRESFA",,"94")
	Local lTemFalta 	:= .f.
	Local lTemDF		:= .f.
	Local lTemReserva := .f.
	Local _CRLF:= CHR(13)+CHR(10)
	Local _cItem	:= ""
	Local cRet 		:= "" //FR - 03/02/2022 - retorno para a api STCRM003
	
	If !(Empty(Alltrim(cPedido)))
		
		//validar se todos os tipos de operacao foram preenchidos
		
		cQuery	:= " SELECT COUNT(*) CONT "
		cQuery  += " FROM " +RetSqlName("SC6")+ " C6 "
		cQuery  += " WHERE D_E_L_E_T_=' ' AND C6_NUM='"+cPedido+"' AND C6_OPER=' ' "
		
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		
		If (cAlias)->(CONT)>0
			lRet	:= .F.
			cErro	+= "Tipo de operação não carregado!"
		EndIf
		
		cQuery2	 := " SELECT C6_FILIAL, C6_NUM NUM, C6_ITEM ITEM, C6_PRODUTO PROD, C6_OPER OPER, C6_QTDVEN-C6_QTDENT AS SALDO "
		cQuery2  += " FROM " +RetSqlName("SC6")+ " C6 "
		cQuery2  += " LEFT JOIN " +RetSqlName("SC5")+ " C5 "
		cQuery2  += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA "
		cQuery2  += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_NUM='"+cPedido+"' "
		
		If !Empty(Select(cAlias2))
			DbSelectArea(cAlias2)
			(cAlias2)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)
		
		dbSelectArea(cAlias2)
		(cAlias2)->(dbGoTop())
		
		While !(cAlias2)->(Eof())
			
			If !((cAlias2)->OPER $ _cOerFalRes) //Verificar se tem falta, reserva ou DF
				
				DbSelectArea("PA1")
				PA1->(DbSetOrder(3))
				PA1->(DbGoTop())
				
				lTemFalta 	:= PA1->(DBSeek(xFilial('PA1')+(cAlias2)->NUM+(cAlias2)->ITEM))
				
				DbSelectArea("PA2")
				PA2->(DbSetOrder(4))
				PA2->(DbGoTop())
				
				lTemDF		:= PA2->(DBSeek(xFilial('PA2')+"02"+(cAlias2)->NUM+(cAlias2)->ITEM))
				
				PA2->(DbGoTop())
				
				lTemReserva := PA2->(DBSeek(xFilial('PA2')+"01"+(cAlias2)->NUM+(cAlias2)->ITEM))
				
				If !lTemFalta .And. !lTemDF .And. !lTemReserva
					lRet	:= .F.
					cErro	+= "Não carregou falta, reserva ou DF"
				EndIf
				
			EndIf
			
			(cAlias2)->(DbSkip())
			
		EndDo
		
		If !lRet
			_cAssunto := 'Problema com pedido - '+cPedido
			cMsg	  := "Ocorreu algum problema no pedido (Tipo de operação, falta ou reserva não foram gravadas)"
			
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			
		EndIf
		
		RestArea(aPA1Area)
		RestArea(aPA2Area)
		RestArea(aAreaSC5)
		RestArea(aAreaSC6)
		RestArea(aAreaSUA)
		RestArea(aAreaSUB)
		RestArea(aArea)
		
	EndIf
	
	If !(Empty(Alltrim(cPedido)))
		//

		/****************************************
		Ação.........: Tratamento para não retornar a Mensagem quando vier do CRM ou WSEXECUTE
		Desenvolvedor: Marcelo Klopfer Leme
		Data.........: 22/08/2022
		Chamado......: 20220727014715 - Integração de Cotações
		****************************************/
		If !IsInCallStack("WSEXECUTE") .and. !IsInCallStack("POST") .and. !IsInCallStack("U_STCADCOT") .AND. !IsInCallStack("U_STCRM08A")
			AVISO('Pedido Gerado !',;
				'Sr(a).' + ALLTRIM(Substr(cUsuario,7,15)) + ', foi gerado o pedido de número: ' + _CRLF + _CRLF +;
				SC5->C5_NUM ,{'OK'},2,"")		
		EndIf
		
		//FR - 15/01/2022 - Alteração
		If IsInCallStack("POST") .OR. IsInCallStack("U_STCADCOT") .OR. IsInCallStack("U_STCRM08A")
			//AutoGrLog('Pedido Gerado ! Sr(a).' + ALLTRIM(Substr(cUsuario,7,15)) + ', foi gerado o pedido de numero: ' + SC5->C5_NUM )		
			cRet := "OK"  //o autogrlog retornava a msg acima para a api , e no caso não precisa, pois lá já tem as tratativas de retorno
		Endif 
		//FR - 15/01/2022 - Alteração
		
		//				Alert("Foi gerado o pedido de número " + SC5->C5_NUM + " !")
		///////// Fim Alteracao Donizeti
		
		//Chamado 003486
		cQuery	:= " SELECT COUNT(*) CONT "
		cQuery  += " FROM " +RetSqlName("ZZI")+ " ZZI "
		cQuery  += " WHERE ZZI_FILANT='"+SUA->UA_FILIAL+"' AND ZZI_TIPO='ORÇAMENTO' "
		cQuery  += " AND ZZI_NUM='"+SUA->UA_NUM+"' "
		
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		
		If (cAlias)->(CONT)>0
			_cAssunto := '[WFPROTHEUS] - Orçamento: '+SUA->UA_NUM+' virou pedido: '+cPedido+' alçada '
			cMsg	  := ""
			_cCopia	  := ""
			_cEmail	  := "" //Ticket 20201029009696
			
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			
			
			//Chamado 003699
			DbSelectArea("ZZY")
			ZZY->(DbSetOrder(1)) //ZZY_FILIAL+ZZY_NUM+ZZY_ITEM
			ZZY->(DbGoTop())
			If ZZY->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))
				While ZZY->(!Eof()) .And. ZZY->(ZZY_FILIAL+ZZY_NUM)==SUA->(UA_FILIAL+UA_NUM)
					_cItem	:= ZZY->ZZY_ITEM
					ZZY->(DbSkip())
				EndDo
			Else
				_cItem	:= "00"
			EndIf
			
			ZZY->(RecLock("ZZY",.T.))
			ZZY->ZZY_FILIAL	:= SUA->UA_FILIAL
			ZZY->ZZY_NUM	:= SUA->UA_NUM
			ZZY->ZZY_ITEM	:= Soma1(_cItem)
			ZZY->ZZY_MOTIVO	:= "3"
			ZZY->ZZY_OBS	:= cPedido
			ZZY->ZZY_VEND	:= SUA->UA_VEND
			ZZY->ZZY_NVEND	:= Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
			ZZY->ZZY_DTINCL	:= Date()
			ZZY->ZZY_HORA	:= Time()
			ZZY->ZZY_CUSERI	:= __cUserId
			ZZY->(MsUnLock())
			
		EndIf
		
	EndIf
	
	
	
	
	If !(Empty(Alltrim(cPedido)))
		
		If SC5->C5_ZVALLIQ >= 25000
			//U_LVPED(SC5->C5_NUM,"  ORÇAMENTO")// desabilitei pois foi uma solicitação do luis valente(queria ver os pedidos que entrava do edi acima de 25k), o klecios pediu para tirar, eu acompanhei durante um tempo pois é bom para ver se ospedidos edi estao entrando normalmente, so descomenta e adiciona o email abaixo. Giovani zago 25/10/2020
		EndIf
		
	EndIf
	
	
	
	
	
	
Return()

User Function LVPED(cPedido,_cOrig)
	
	
	Local aArea 	:= GetArea()
	//Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "LVPED"
	//Local i        := 0
	//Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	//Local cAttach  := ' '
	//Local _cEmaSup := ' '
	//Local _nCam    := 0
	Local _aMsg    := {}
	Local _cEmail  :=  ' '//'klecios.souza@steckgroup.com'
	Local _cCop  	:= ' '
	Local _cAssunto := ' '
	
	If _cOrig = 'GIO'// coloque aqui o email para acompanhar os pedidos edi saber se estao funcionando. #dica
		_cEmail  :=  ' '
		_cCop  	:=   ' '
	EndIf
	
	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))
	If SC5->(dbSeek(xFilial('SC5')+cPedido))
		
		_cAssunto := 'P.V.: '+SC5->C5_NUM+" Valor: R$ "+transform((SC5->C5_ZVALLIQ)	,"@E 999,999,999.99")+"   Ori.:"+_cOrig
		
		
		
		
		Aadd( _aMsg , { "Numero: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome: "    		, SC5->C5_XNOME } )
		Aadd( _aMsg , { "Emissao: "    		, dtoc(SC5->C5_EMISSAO) } )
		Aadd( _aMsg , { "Valor: "    		, transform((SC5->C5_ZVALLIQ)	,"@E 999,999,999.99")  } )
		//Aadd( _aMsg , { "Hora: "    		, time() } )
		
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
			For _nLin := 1 to Len(_aMsg)
				If (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf
				
				
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				
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
			cMsg += '</body>'
			cMsg += '</html>'
			
			U_STMAILTES(_cEmail, _cCop, _cAssunto, cMsg,,,' ')
			
			
		EndIf
	EndIf
	RestArea(aArea)
	
	
	
	
Return()





/*/{Protheus.doc} 
	description
	Rotina para validar a mudança para pedido parcial , pedidos home-center não permitido. 
	@type function
	@version  
	@author Antonio Cordeiro. 
	@since 02/10/2023
/*/

User Function VLDTPFAT(cCliente,cLoja,cTipoFat,cPedido,nOpc1)

LOCAL lRet:=.T.
LOCAL aAreaSA1:=SA1->(GETAREA())
LOCAL aAreaCB7:=CB7->(GETAREA())
LOCAL CanalHome:=GetMv("ST_CANHOME",,"('D3')")
LOCAL CliHome  :=GetMv("ST_CLIHOME",,"('038134','036970')")
LOCAL cTpFat   := ""
LOCAL lCodOk   :=.T.

IF ALLTRIM(readvar()) == 'M->C5_XTIPF'
   cTpFat :='2'
ELSE    
   cTpFat := 'Parcial'
ENDIF 

IF alltrim(cTipoFat)==cTpFat  // Mudança para parcial valida canal do cliente. 
   SA1->(DBSETORDER(1))
   IF SA1->(DBSEEK(XFILIAL('SA1')+cCliente+cLoja))
      IF !Empty(CliHome)
	     IF ALLTRIM(SA1->A1_COD) $ CliHome
		    lCodOk:=.F.
	     ELSE 
		    lCodOk:=.T. 
		 ENDIF
	  ENDIF	 			
	  IF ALLTRIM(SA1->A1_GRPVEN) $ CanalHome .AND. ! lCodOk
         CB7->(DBSETORDER(2))
	     IF CB7->(DBSEEK(XFILIAL('CB7')+cPedido))
		    MsgAlert("Não é permitido alterar o tipo para Parcial para Home Center Canal Venda: "+CanalHome+" quando ja houve 1 entrega deste mesmo pedido. "+chr(10)+chr(13)+" Este saldo deve sofrer eliminação de residuo !!! ","Atenção")
		    lRet:=.F.
		 ENDIF    
      ENDIF 
   ENDIF	  		 
ENDIF

RestArea(aAreaSA1)
RestArea(aAreaCB7)

Return(lRet)
