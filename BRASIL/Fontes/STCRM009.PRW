#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STCRM009         | Autoria: Flávia Rocha              | Data | 15/12/2021|
|=====================================================================================|
|Descrição | Webservice para cancelar cotação                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
/------------------------------------------------------------------------------------*/
WSRESTFUL cancelacot DESCRIPTION "Cancela Cotação"

WSMETHOD POST DESCRIPTION "Cancela Cotação" WSSYNTAX "/rest/cancelacot"

END WSRESTFUL


WSMETHOD POST WSSERVICE cancelacot

	Local _cXml     := "" 
	Local oXml	
	
	Local _cRetorno	:= ""
	Local _nX		:= 0
	Local aData		:= {}
	Local aCabec    := {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local lOKSUA	:= .T.
	Local lTemC5    := .F.
	Local lUACANC   := .F.
	Local lUACodcan := .F.
	Local lUAXBloq  := .F.
	Local lTUDOK    := .T.
	Local cCodMotivo:= ""
	Local cObsCanc  := ""
	Local cCodConcor:= ""
	Local lNovoZZY  := .F.

	
	Private lMsErroAuto := .F.
	
	__cUserId := '000000'  				//"001168"

	
	Conout("[STCRM009][CANCELACOT]"+FWTimeStamp(2)+" - Inicio do cancela cotação !")
	
	//------------------------------------------//
	//recebe o conteúdo do Postman (array Json)
	//------------------------------------------//
	_cXml := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")  
	_cXml := FwCutOff(_cXml,.T.)

	oXml := ""
	_lRet := FWJsonDeserialize(FwNoAccent(_cXml),@oXml)

	//ARRAYS PARA TESTE NO FINAL DESTE FONTE

	//----------------------//
	//Valida o Json
	//----------------------//
	If !_lRet
		_cRetorno := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(_cRetorno)
		Return .T.
	EndIf

	aData := ClassDataArr(oXml)						//transforma o objeto vindo do ws, em um array
	//aData := FWVetByDic ( aData, "SUA", .F. /*lItens */, 1 /*nCpoPos*/ )
	Asort(aData,,,{ | x,y | x[3] < y[3] } )

	aCabec := {}
				
	lMsErroAuto := .F.
	aItens := {}
	aLinha := {}
		
	//-----------------------------//
	//VALIDA CABEÇALHO
	//-----------------------------//
	/*
	tabela ZZY - cancelamento de cotação
	status cancelamento é tudo diferente de 8
	deleta alçada desconto ZZI
	envia por email (ver se precisa)


	array recebido: 
	cotação
	motivo cancelamento
	observação
	concorrente só se for motivo = 5
	//1-SOMENTE CUSTO; 2-OUTRO COMPROU; 3-ITENS INCL PEDIDO; 4-COMP NO DISTR; 5-PERD. CONCORRENTE; 6-PERDEU COT; 7-AUTOMATICO; 8-COBRAR NOVAMENTE

	{
    "UA_NUM": "759626",
    "ZZY_MOTIVO": "1",		//1-SOMENTE CUSTO; 2-OUTRO COMPROU; 3-ITENS INCL PEDIDO; 4-COMP NO DISTR; 5-PERD. CONCORRENTE; 6-PERDEU COT; 7-AUTOMATICO; 8-COBRAR NOVAMENTE
    "ZZY_OBS": "CLIENTE NAO FECHOU",
	"ZZY_CODCON": "007"  //007-TRAMONTINA - CODIGO CONCORRENTE //SÓ SE MOTIVO = 5	
    }	
	*/

		
	For _nX:=1 To Len(aData)
		If SubStr(aData[_nX][1],1,3)=="UA_"

			If AllTrim(aData[_nX][1])=="UA_NUM"

				cUANUM := aData[_nX][2]
				//valida se existe o orçamento passado
				SUA->(OrdSetFocus(1))
				If !SUA->(DbSeek(xFilial("SUA") + cUANUM ))					
					lOKSUA := .F.
				else
					//cQuery += " AND   SUA.UA_NUMSC5 = ' '
					//cQuery += " AND   SUA.UA_CANC = ' '
					//cQuery += " AND   SUA.UA_CODCANC = ' '
					//cQuery += " AND   SUA.UA_XBLOQ<>'3'
					If !Empty(SUA->UA_NUMSC5)
						lTemC5 := .T.
					Endif 

					If !Empty(SUA->UA_CANC)
						lUACANC := .T.
					Endif

					If !Empty(SUA->UA_CODCANC)
						lUACodcan := .T.
					Endif

					If SUA->UA_XBLOQ == '3'	//Status orçamento: 1=Bloqueado;2=Liberado;3=Cancelado
						lUAXBloq := .T.
					Endif

				Endif 

			Endif 

		Elseif AllTrim(aData[_nX][1]) == "ZZY_MOTIVO"
			cCodMotivo := aData[_nX][2]
		Elseif AllTrim(aData[_nX][1]) == "ZZY_OBS" 
			cObsCanc   := aData[_nX][2]
		Elseif AllTrim(aData[_nX][1]) == "ZZY_CODCON" 
			cCodConcor   := aData[_nX][2]				
		EndIf		
		
	Next

	If !lOKSUA 			
		_cRetorno := '{"CODRET":"03","DESCRET":"ORCAMENTO NAO LOCALIZADO"}'
		::SetResponse(_cRetorno)
		Return .t.	
	Endif

	If lTemC5
		_cRetorno := '{"CODRET":"03","DESCRET":"PEDIDO DE VENDA GERADO, NAO PERMITIDO CANCELAR"}'
		::SetResponse(_cRetorno)
		Return .t.	
	Endif 

	If lUACANC
		_cRetorno := '{"CODRET":"03","DESCRET":"ORCAMENTO JA CANCELADO"}'
		::SetResponse(_cRetorno)
		Return .t.
	Endif 

	If lUACodcan
		_cRetorno := '{"CODRET":"03","DESCRET":"ORCAMENTO JA CANCELADO"}'
		::SetResponse(_cRetorno)
		Return .t.
	Endif 

	If lUAXBloq
		_cRetorno := '{"CODRET":"03","DESCRET":"ORCAMENTO BLOQUEADO"}'
		::SetResponse(_cRetorno)
		Return .t.
	Endif 


	If cCodMotivo == "8"
		_cRetorno := '{"CODRET":"03","DESCRET":"MOTIVO = 8 NAO CANCELA"}'
		::SetResponse(_cRetorno)
		Return .t.

	Elseif cCodMotivo == "5" //perdeu para concorrência, precisa ter o código do concorrente
		If Empty(cCodConcor)
			_cRetorno := '{"CODRET":"03","DESCRET":"MOTIVO = 5 PRECISA PREENCHER CODIGO CONCORRENTE (ZZY_CODCON) "}'
			::SetResponse(_cRetorno)
			Return .t.
		Endif 
		
	Else //se motivo diferente de '8', verificar na ZZY se já tem registro deste orçamento e se há data retorno preenchida, aí não pode cancelar

		ZZY->(OrdSetFocus(1))		//ZZY_FILIAL + ZZY_NUM
		If ZZY->(Dbseek(xFilial("ZZY") + cUANUM ))
			lNovoZZY := .F.
			If !Empty(ZZY->ZZY_RETORN) 
				If ZZY->ZZY_RETORN >= Date()

					_cRetorno := '{"CODRET":"03","DESCRET":"ORCAMENTO COM DATA RETORNO AGENDADA, NAO PODE CANCELAR (ZZY_RETORN >= Data Hoje) "}'
					::SetResponse(_cRetorno)
					Return .t.

				Endif 
			Endif 
		Else
			lNovoZZY := .T.
		Endif

	Endif

	If Empty(cObsCanc)
		_cRetorno := '{"CODRET":"03","DESCRET":"OBSERVACAO PRECISA SER PREENCHIDA (ZZY_OBS) "}'
		::SetResponse(_cRetorno)
		Return .t.
	Endif 	 
/*
	{
    "UA_NUM": "759626",
    "ZZY_MOTIVO": "1",		//1-SOMENTE CUSTO; 2-OUTRO COMPROU; 3-ITENS INCL PEDIDO; 4-COMP NO DISTR; 5-PERD. CONCORRENTE; 6-PERDEU COT; 7-AUTOMATICO; 8-COBRAR NOVAMENTE
    "ZZY_OBS": "CLIENTE NAO FECHOU",
	"ZZY_CODCON": CODIGO CONCORRENTE //SÓ SE MOTIVO = 5	
    }
*/

	 

	
lTUDOK := GravaDados(cCodMotivo,cObsCanc,cCodConcor)
	
	
//If lTUDOK
	//Prepara arquivo de log de gravação ou erro de gravação:	
	cNArq  := "STCRM009_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"  //nome do arquivo de log
	cDir    := "\arquivos\logs\"

	If !ExistDir(cDir)
		Makedir(cDir)
	EndIf
	
	If lTUDOK  //!lMsErroAuto

		_cRetorno := '{"CODRET":"OK","DESCRET":"Orcamento Cancelado com Sucesso",'+;
		   	          '"ORCAMENTO":' + '"' + cUANUM + '"' + '}'		
	Else
		_cRetorno := '{"CODRET":"00","DESCRET":"Erro ao Cancelar Orcamento",'+;
		   	          '"ORCAMENTO":' + '"' + cUANUM + '"' + '}'		
	Endif

	_cErro := _cRetorno		

	//----------------------------------//
	//grava o arquivo de log na pasta:
	//----------------------------------//
	_cFile := cDir+ cNArq  //diretório mais nome do arquivo
			
	nHdlXml:= FCreate(_cFile,0)		//Cria o arquivo no diretorio (cria o nome.extensao na pasta apenas)

	If nHdlXml > 0
						
		FWrite(nHdlXml,_cErro)	//aqui grava o conteudo no arquivo acima gravado na pasta
		FClose(nHdlXml)

	Endif
	

	Conout("[STCRM009][cancelacot]"+ FWTimeStamp(2)+" - Fim do cancela cotacao")

	::SetResponse(_cRetorno)

//Endif 

Return .T.

/*====================================================================================\
|Programa  | GravaDados       | Autoria: Flávia Rocha              | Data | 16/12/2021|
|=====================================================================================|
|Descrição | Gravação dos dados nas tabelas ZZY e ZZI                                 |
|          |                                                                          |
|=====================================================================================|
/------------------------------------------------------------------------------------*/
Static Function GravaDados(cCodMotivo,cObsCanc,cCodConcor)	
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= 'Novo chamado ERP'
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local _cSpur    	:= ''
	Local lOK			:= .F.

	_cEmail				:= GetNewPar("ST_CRM006" , "flah.rocha@sigamat.com.br;flah.rocha@gmail.com;vanderlei.silva@nectarconsulting.com.br")

	
	DbSelectArea("ZZY")
	ZZY->(DbSetOrder(1))	//ZZY_FILIAL + ZZY_NUM + ZZY_ITEM
	ZZY->(DbGoTop())
	//If ZZY->(DbSeek(cFilAnt+aVetor[oLbx:nAt,3]+oGetDados2:aCols[_nx][_nPosItem]))
	If ZZY->(DbSeek(xFilial("SUA") + cUANUM ))

		ZZY->(RecLock("ZZY",.F.))
		ZZY->ZZY_MOTIVO	:= cCodMotivo //oGetDados2:aCols[_nx][_nPosMotivo]

		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial("SA3")+__cUserId))
			ZZY->ZZY_VEND 		:= SA3->A3_COD
			ZZY->ZZY_NVEND 		:= SA3->A3_NOME
		EndIf

		ZZY->ZZY_DTINCL	:= Date()
		ZZY->ZZY_HORA	:= SubStr(TIME(), 1, 5)
		ZZY->ZZY_CUSERI	:= __cUserId
		ZZY->ZZY_CODCON	:= cCodConcor //oGetDados2:aCols[_nx][_nPosCodCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
		ZZY->ZZY_NOMCON	:= Posicione("ZA1",1,xFilial("ZA1") + cCodConcor,"ZA1_NOME")    //oGetDados2:aCols[_nx][_nPosNomCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
		ZZY->ZZY_OBS	:= cObsCanc //oGetDados2:aCols[_nx][_nPosObs]
		//If !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
		//	ZZY->ZZY_RETORN	:= oGetDados2:aCols[_nx][_nPosDtRet]
		//EndIf
		lOk := .T.
		ZZY->(MsUnLock())

	Else
		ZZY->(RecLock("ZZY",.T.))
		ZZY->ZZY_FILIAL	:= cFilAnt
		ZZY->ZZY_NUM	:= cUANUM //oLbx:aArray[oLbx:nAt,3]
		ZZY->ZZY_ITEM	:= "01" //oGetDados2:aCols[_nx][_nPosItem]
		ZZY->ZZY_MOTIVO	:= cCodMotivo //oGetDados2:aCols[_nx][_nPosMotivo]

		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial("SA3")+__cUserId))
			ZZY->ZZY_VEND 		:= SA3->A3_COD
			ZZY->ZZY_NVEND 		:= SA3->A3_NOME
		EndIf

		ZZY->ZZY_DTINCL	:= Date()
		ZZY->ZZY_HORA	:= SubStr(TIME(), 1, 5)
		ZZY->ZZY_CUSERI	:= __cUserId
		ZZY->ZZY_CODCON	:= cCodConcor //oGetDados2:aCols[_nx][_nPosCodCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
		ZZY->ZZY_NOMCON	:= Posicione("ZA1",1,xFilial("ZA1") + cCodConcor,"ZA1_NOME") //oGetDados2:aCols[_nx][_nPosNomCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
		ZZY->ZZY_OBS	:= cObsCanc //oGetDados2:aCols[_nx][_nPosObs]
	
		lOK := .T.
		ZZY->(MsUnLock())

	EndIf

	//Cancelar orçamento automáticamente e tirar da lista
	If Alltrim(cCodMotivo) <> '8'

		DbSelectArea("SUA")
		SUA->(DbSetOrder(1))
		SUA->(DbGoTop())
		//If SUA->(DbSeek(xFilial("SUA")+aVetor[oLbx:nAt,3]))
		If SUA->(DbSeek(xFilial("SUA")+ cUANUM ))
			SUA->(RecLock("SUA",.F.))
			SUA->UA_XBLOQ	:= "3"
			
			//MONTA MSG DE ENVIO POR EMAIL:
			_cMsgCan 		:=	"Solicitante: " + cUserName+CRLF+;
			"Solicitação em " + DtoC(dDatabase) + " às " + Time() + CRLF +;
			"Motivo do Cancelamento: "+ Upper(PADL(Alltrim(cCodMotivo),6,"0"))+CRLF+; //Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0"))+CRLF+;
			"Descrição da Solicitação: " + CRLF + Upper( Alltrim(cObsCanc) ) //Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
			SUA->UA_XCODMCA := PADL(Alltrim(cCodMotivo),6,"0") //PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")
			
			SUA->(MsUnLock())
			SUA->(RecLock("SUA",.F.))
			MSMM(SUA->UA_XCODCAN,,,_cMsgCan,1,,,"SUA", "UA_XCODCAN",,.T.)
			SUA->(MsUnLock())


			DbSelectArea('ZZI')
			ZZI->(DbGoTop())
			ZZI->(DbSetOrder(3))
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
				If ZZI->ZZI_BLQ = '2'
					ZZI->(RecLock('ZZI',.F.))
					ZZI->(DbDelete())
					ZZI->(MsUnlock())
					ZZI->( DbCommit() )
				Endif
			Endif


		EndIf

		//Chamado 003486
		//_cAssunto	:= "[WFPROTHEUS] - Orçamento: "+SUA->UA_NUM+" baixado, motivo: "+AllTrim(Posicione("PA3",1,xFilial("PA3")+Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")),"PA3_DESCRI"))+" "+Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
		_cAssunto	:= "[WFPROTHEUS] - Orçamento: "+SUA->UA_NUM+" baixado, motivo: "+AllTrim(Posicione("PA3",1,xFilial("PA3")+Upper(PADL(Alltrim(cCodMotivo),6,"0")),"PA3_DESCRI"))+;
		" "+Upper(Alltrim(cObsCanc))
		_cOrc:=SUA->UA_VEND

		DbSelectArea('SA3')
		SA3->(DbSetOrder(1))
		If SA3->(dbSeek(xFilial('SA3')+_cOrc))
			_cSpur:=SA3->A3_SUPER
			DbSelectArea('SA3')
			SA3->(DbSetOrder(1))
			If SA3->(dbSeek(xFilial('SA3')+_cSpur))
				_cEmail+= ";"+ Alltrim(SA3->A3_EMAIL)
			EndIf
		EndIf

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsgCan, _aAttach,_cCaminho)  //voltar
		//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
		///FRSendMail(_cEmail, "", _cAssunto, _cMsgCan, "" )  //FR - TESTE RETIRAR  

		//oGetDados2:aCols	:= {}

	EndIf

	//MsgAlert("Gravação efetuada com sucesso!")

Return(lOk)

Static Function STASSUNT(_cOrc)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= ' '
	Local cFuncSent:= "STASSUNT"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _aMsg := {}

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	If SUA->(DbSeek(xFilial("SUA")+_cOrc))

		Aadd( _aMsg , { "Posicionado: "     , cusername } )
		Aadd( _aMsg , { "Cliente: "    		, SUA->UA_XNOME } )
		Aadd( _aMsg , { "Vendedor1: "    		, SUA->UA_VEND+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")) } )
		Aadd( _aMsg , { "Vendedor2: "    		, SUA->UA_VEND2+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_NOME")) } )
		Aadd( _aMsg , { "Valor: "    		,TRANSFORM(SUA->UA_ZVALLIQ ,"@E 99,999,999,999.99")	  } )
		Aadd( _aMsg , { "Emissão: "    		,	dtoc(SUA->UA_EMISSAO)  } )
		DbSelectArea("ZZY")
		ZZY->(DbSetOrder(1))
		ZZY->(DbGoTop())
		If ZZY->(DbSeek(cFilAnt+_cOrc))
			While !(ZZY->(Eof())) .And. ZZY->ZZY_NUM = _cOrc
				_cMtzzy:= ' '
				If ZZY->ZZY_MOTIVO ='1'
					_cMtzzy:= 'SOMENTE CUSTO'
				ElseIf ZZY->ZZY_MOTIVO ='2'
					_cMtzzy:= 'OUTRO COMPROU'
				ElseIf ZZY->ZZY_MOTIVO ='3'
					_cMtzzy:= 'ITENS INCL. PEDIDO'
				ElseIf ZZY->ZZY_MOTIVO ='4'
					_cMtzzy:= 'COMPROU NO DISTRIBUIDOR'
				ElseIf ZZY->ZZY_MOTIVO ='5'
					_cMtzzy:= 'PERDEU CONCORRENTE'
				ElseIf ZZY->ZZY_MOTIVO ='6'
					_cMtzzy:= 'PERDEU COTAÇÃO'
				ElseIf ZZY->ZZY_MOTIVO ='7'
					_cMtzzy:= 'CANC MASSA'
				ElseIf ZZY->ZZY_MOTIVO ='8'
					_cMtzzy:= 'COBRAR NOVAMENTE'
				EndIf

				Aadd( _aMsg , { "Nº Alteração: " +ZZY->ZZY_ITEM   		, 	_cMtzzy } )

				ZZY->(dbSkip())
			End



		EndIf
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
		cMsg += '</body>'
		cMsg += '</html>'


	EndIf
	RestArea(aArea)



Return(cMsg)

/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
//FUNÇÃO FR PARA TESTES

Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


//Local cAccount	:= GetMV( "MV_RELACNT" )
//Local cPassword 	:= GetMV( "MV_RELPSW"  )
//Local cServer		:= GetMV( "MV_RELSERV" )
//Local cFrom		:= GetMV( "MV_RELACNT" )   


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"


//Local cAccount	:= "nfe_teste@hfbr.com.br" 	//GetMV( "MV_RELACNT" )    //nfe_teste@hfbr.com.br
//Local cPassword := "hfbr2030" 				//GetMV( "MV_RELPSW"  )    //hfbr2030
//Local cServer	:= "smtp.hfbr.com.br:587"	//GetMV( "MV_RELSERV" )
//Local cFrom		:= "nfe_teste@hfbr.com.br" //GetMV( "MV_RELACNT" )   //relatorio@premierpescados.com.br                                     


//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )

