#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTLOGFIN  บAutor  ณRenato Nogueira     บ Data ณ  04/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGravar log de libera็๕es financeiras						  บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณAjustado para utilizar na Argentina - Everson Santana       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno	 ณ Nulo	                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ARLOGFIN(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja,_nPrcVen,_nQtdVen,_lCredito,_lAuto)

	Local _aArea    := GetArea()
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg		  := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cEmailV	:= ""
	Local _aMsg    	:={}
	Local _nLin
	Local cFuncSent	:= "ARLOGFIN"

	DbSelectArea("SZA")

	SZA->(RecLock("SZA",.T.))

	SZA->ZA_FILIAL 		:= _cFilial
	SZA->ZA_ITEM   		:= _cItem
	SZA->ZA_PRODUTO   	:= _cProduto
	SZA->ZA_QTDVEN    	:= _nQtdVen
	SZA->ZA_PRCVEN     	:= _nPrcVen
	SZA->ZA_CLIENTE		:= _cCliente
	SZA->ZA_LOJA			:= _cLoja
	SZA->ZA_STATUS		:= IIf(_lCredito,"L","B")
	SZA->ZA_APROV  		:= IIf(_lAuto,"A","M")
	SZA->ZA_DATA   		:= Date()
	SZA->ZA_HORA   		:= Time()
	SZA->ZA_USUARIO		:= IIf(!_lAuto,cUserName,"")
	SZA->ZA_PEDIDO 		:= _cNum

	SZA->(MsUnLock())

	If _lCredito
		If ARENVMAIL(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja)

			_cEmailV := AllTrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,_cFilial+_cNum,"C5_VEND2"),"A3_EMAIL"))

			_cCopia := GetMv("ST_NOTEMAI",,"everson.santana@steck.com.br") //Chamado 008755 - Everson Santana - 11.01.2019

			_cEmail	:= ' '//AllTrim(Posicione("SA1",1,XFILIAL("SA1")+_cCliente+_cLoja,"A1_EMAIL"))
			If SubStr(Posicione("SC5",1,_cFilial+_cNum,"C5_VEND2"),1,1)<>"R"
				_cEmail += ";"+_cEmailV //Chamado 003040 - Adicionar email do vendedor 2
			EndIf
			_cAssunto := "[WFPROTHEUS] - Pedido "+AllTrim(_cNum)+" aprobado por el financiero"

			Aadd( _aMsg , { "Pedido: "          , _cNum } )
			Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
			Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_NOME"),1,35)  } )
			Aadd( _aMsg , { "Avalista: "    	, IIf(!_lAuto,cUserName+" "+DTOC(DDATABASE)+" "+TIME(),"") } ) //chamado 008899 - Everson Santana - 23.01.219

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

			U_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)


		EndIf
	EndIf

	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARENVMAIL  บAutor  ณRenato Nogueira     บ Data ณ  04/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerificar se ้ o ๚ltimo item e enviar email ao cliente  	  บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณAjustado para utilizar na Argentina - Everson Santana       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno	 ณ Nulo	                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ARENVMAIL(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja)

	Local _lRet	:= .F.
	Local cQuery1	:= ""
	Local cAlias1	:= "QRYTEMP"

	cQuery1  := " SELECT C6_ITEM "
	cQuery1  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery1  += " WHERE D_E_L_E_T_=' ' AND C6_FILIAL='"+_cFilial+"' AND C6_NUM='"+_cNum+"' "
	cQuery1  += " AND C6_CLI='"+_cCliente+"' AND C6_LOJA='"+_cLoja+"' "
	cQuery1  += " ORDER BY C6_ITEM DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If AllTrim(_cItem)==AllTrim((cAlias1)->C6_ITEM)
		_lRet	:= .T.
	EndIf

Return(_lRet)