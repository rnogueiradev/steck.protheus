#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STLOGFIN  ºAutor  ³Renato Nogueira     º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravar log de liberações financeiras						  º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno	 ³ Nulo	                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STLOGFIN(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja,_nPrcVen,_nQtdVen,_lCredito,_lAuto,lINCLUI)

	Local _aArea    := GetArea()
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg		  := ""
	//Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cEmailV	:= ""

	Default lINCLUI := .F.	//FR - 09/11/2022 - Define se a chamada é por inclusão de pedido (inclusão = .T. , alteração = .F. )

	DbSelectArea("SZA")
	
	SZA->(RecLock("SZA",.T.))
	
	SZA->ZA_FILIAL 		:= _cFilial
	SZA->ZA_ITEM   		:= _cItem
	SZA->ZA_PRODUTO   	:= _cProduto
	SZA->ZA_QTDVEN    	:= _nQtdVen
	SZA->ZA_PRCVEN     	:= _nPrcVen
	SZA->ZA_CLIENTE		:= _cCliente
	SZA->ZA_LOJA		:= _cLoja
	SZA->ZA_STATUS		:= IIf(_lCredito,"L","B")
	SZA->ZA_APROV  		:= IIf(_lAuto,"A","M")
	SZA->ZA_DATA   		:= Date()
	SZA->ZA_HORA   		:= Time()
	SZA->ZA_USUARIO		:= IIf(!_lAuto,cUserName,"")
	SZA->ZA_PEDIDO 		:= _cNum
	If lINCLUI 
		SZA->ZA_DTEMI   := Date()
		SZA->ZA_HREMI   := Time()
	Endif 
	
	SAZ->(MsUnLock())
	
	If _lCredito
		If STENVMAIL(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja)

			_cEmailV := AllTrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,_cFilial+_cNum,"C5_VEND2"),"A3_EMAIL"))
			If Empty(Alltrim( _cEmailV))
				_cEmailV := AllTrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,_cFilial+_cNum,"C5_VEND1"),"A3_EMAIL"))
			EndIf

			_cEmail	:= ' '//AllTrim(Posicione("SA1",1,XFILIAL("SA1")+_cCliente+_cLoja,"A1_EMAIL"))
			If SubStr(Posicione("SC5",1,_cFilial+_cNum,"C5_VEND2"),1,1)<>"R"
				_cEmail += ";"+_cEmailV //Chamado 003040 - Adicionar email do vendedor 2
			EndIf
			_cAssunto := "[STECK] - Pedido "+AllTrim(_cNum)+" aprovado pelo financeiro"
			cMsg := ""
			cMsg += '<html><head><title></title></head><body>'
			cMsg += '<b>Pedido: </b>'+Alltrim(_cNum)+' aprovado pelo financeiro</body></html>'
	
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		 
	
		EndIf
	EndIf

	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STENVMAIL  ºAutor  ³Renato Nogueira     º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificar se é o último item e enviar email ao cliente  	  º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno	 ³ Nulo	                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STENVMAIL(_cFilial,_cNum,_cItem,_cProduto,_cCliente,_cLoja)

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
