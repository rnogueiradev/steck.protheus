#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STWSPC02         | Autor | giovani.zago          | Data | 11/09/2015  |
|=====================================================================================|
|Descri��o | WS para envio de pedido de compra para a �nica								  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STWSPC02                                                                 |
|=====================================================================================|
|Uso       | Compras											                              |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STWSPC02()

	Local _oWsPedido		:= ""
	Local _cSchema			:= ""
	Local _cFilCobranc		:= GetMv("ST_FILCOBR")
	Local _aFilCobranc
	Local _aAreaSM0			:= SM0->(GetArea())
	Local _aTotais			:= {}
	Local _aVencto			:= {}
	Local _nX				:= 1
	Local _nItem			:= 0
	Local _cLog				:= ""
	Local _oXml
	Local cErro    			:= ""
	Local cAviso   			:= ""
	Private _cMsg			:= ""
	Private _cNumPed		:= ""
	Private _cQuery1 		:= ""
	Private _cAlias1 		:= "QRYTEMP1"
	
	//MsgAlert("Rotina indispon�vel")
	//Return
	
	If JAENVIADO()
		MsgAlert(AllTrim(_cMsg))
		Return
	EndIf

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
		
	If !SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
		MsgAlert("Aten��o, fornecedor n�o encontrado, verifique!")
		Return
	EndIf
		
	If !(SA2->A2_COD $ GetMv("ST_FORNUNIC"))
		MsgAlert("Aten��o, fornecedor n�o cadastrado para usar EDI, verifique!")
		Return
	EndIF

	_oWsPedido := WSws_uniconnect():New()
	_oWsPedido:oWsOUsuario	:= ws_uniconnect_UsuariosComunic():New()
	_oWsPedido:oWsOArquivo	:= ws_uniconnect_Arquivo():New()

//Preencher informa��es de acesso ao ws
	_oWsPedido:oWsOUsuario:cTxtSenha				:= "UniSteck1409!#"
	_oWsPedido:oWsOUsuario:cStrLogin				:= "ws_steck"
	_oWsPedido:oWsOUsuario:cStrCnpjUsuario			:= "05890658000130"
	_oWsPedido:oWsOUsuario:nintIdUsuarioComunic	:= 0
	_oWsPedido:oWsoLog:cDtTimeStamp					:= DTOC(DDATABASE)

//Preencher informa��es do pedido de compra que ser� enviado

	_cSchema	:= '<PEDIDO>'
	_cSchema	+= '<TIPO_DOC>I</TIPO_DOC>'
	_cSchema	+= '<TIPO_PED>1</TIPO_PED>'
	_cSchema	+= '<NUM_PED>'+SC7->C7_NUM+'</NUM_PED>'
	_cSchema	+= '<DT_PEDIDO>'+DTOC(SC7->C7_EMISSAO)+'</DT_PEDIDO>'
	_cSchema	+= '<DT_ENTREGA>'+DTOC(SC7->C7_DATPRF)+'</DT_ENTREGA>'
		
	_cSchema	+= '<COMPRADOR>'
	_cSchema	+= '<CNPJ>'+SM0->M0_CGC+'</CNPJ>'
	_cSchema	+= '<RAZAO_SOCIAL>'+AllTrim(SM0->M0_NOMECOM)+'</RAZAO_SOCIAL>'
	_cSchema	+= '</COMPRADOR>'
		
	_cSchema	+= '<ENTREGA>'
	_cSchema	+= '<CNPJ>'+SM0->M0_CGC+'</CNPJ>'
	_cSchema	+= '<ENDERECO>'+SM0->M0_ENDENT+'</ENDERECO>'
	_cSchema	+= '<BAIRRO>'+SM0->M0_BAIRENT+'</BAIRRO>'
	_cSchema	+= '<CIDADE>'+SM0->M0_CIDENT+'</CIDADE>'
	_cSchema	+= '<EST>'+SM0->M0_ESTENT+'</EST>'
	_cSchema	+= '<PAIS>BRASIL</PAIS>'
	_cSchema	+= '<CEP>'+SM0->M0_CEPENT+'</CEP>'
	_cSchema	+= '</ENTREGA>'

	_aFilCobranc	:= FWArrFilAtu(cEmpAnt,_cFilCobranc)
		
	_cSchema	+= '<COBRANCA>'
	_cSchema	+= '<CNPJ>'+_aFilCobranc[18]+'</CNPJ>'
	_cSchema	+= '<ENDERECO>'+SM0->M0_ENDCOB+'</ENDERECO>'
	_cSchema	+= '<BAIRRO>'+SM0->M0_BAIRCOB+'</BAIRRO>'
	_cSchema	+= '<CIDADE>'+SM0->M0_CIDCOB+'</CIDADE>'
	_cSchema	+= '<EST>'+SM0->M0_ESTCOB+'</EST>'
	_cSchema	+= '<PAIS>BRASIL</PAIS>'
	_cSchema	+= '<CEP>'+SM0->M0_CEPCOB+'</CEP>'
	_cSchema	+= '</COBRANCA>'
		
	_cSchema	+= '<FORNECEDOR>'
	_cSchema	+= '<CNPJ>'+SA2->A2_CGC+'</CNPJ>'
	_cSchema	+= '<RAZAO_SOCIAL>'+AllTrim(SA2->A2_NOME)+'</RAZAO_SOCIAL>'
	_cSchema	+= '<CONTATO>'+AllTrim(SA2->A2_CONTATO)+'</CONTATO>'
	_cSchema	+= '<DDD>'+SA2->A2_DDD+'</DDD>'
	_cSchema	+= '<TELEFONE>'+SA2->A2_TEL+'</TELEFONE>'
	_cSchema	+= '<EMAIL>'+AllTrim(SA2->A2_EMAIL)+'</EMAIL>'
	_cSchema	+= '<ENDERECO>'+AllTrim(SA2->A2_END)+'</ENDERECO>'
	_cSchema	+= '<BAIRRO>'+AllTrim(SA2->A2_BAIRRO)+'</BAIRRO>'
	_cSchema	+= '<CIDADE>'+AllTrim(SA2->A2_MUN)+'</CIDADE>'
	_cSchema	+= '<EST>'+SA2->A2_EST+'</EST>'
	_cSchema	+= '<PAIS>'+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR"))+'</PAIS>'
	_cSchema	+= '<CEP>'+SA2->A2_CEP+'</CEP>'
	_cSchema	+= '</FORNECEDOR>'
		
	_cSchema	+= '<TRANSPORTADORA>'
	_cSchema	+= '<CNPJ>05890658000210</CNPJ>'
	_cSchema	+= '<RAZAO_SOCIAL>STECK INDUSTRIA ELETRICA LTDA.</RAZAO_SOCIAL>'
	_cSchema	+= '<FRETE>C</FRETE>'
	_cSchema	+= '</TRANSPORTADORA>'
		
	_aTotais	:= STGETTOTAIS()
		
	_cSchema	+= '<VALORES_TOTAIS>'
	_cSchema	+= '<VL_TOTAL>'+CVALTOCHAR(_aTotais[1][1])+'</VL_TOTAL>'
	_cSchema	+= '<VL_ICMS_SUB>'+CVALTOCHAR(_aTotais[2][1])+'</VL_ICMS_SUB>'
	_cSchema	+= '<VL_ICMS>'+CVALTOCHAR(_aTotais[3][1])+'</VL_ICMS>'
	_cSchema	+= '<VL_IPI>'+CVALTOCHAR(_aTotais[4][1])+'</VL_IPI>'
	_cSchema	+= '</VALORES_TOTAIS>'
		
	_cSchema	+= '<CONDICAO_PAGAMENTO>'
	_cSchema	+= '<DESCRICAO_CP>'+Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")+'</DESCRICAO_CP>'
	_cSchema	+= '<PARCELAS>'
		
	_aVencto	:= Condicao(_aTotais[1][1],SC7->C7_COND,_aTotais[4][1],DDATABASE,_aTotais[2][1])
		
	For _nX:=1 To Len(_aVencto)
		
		_cSchema	+= '<PARCELA>'
		_cSchema	+= '<ITEM>'+CVALTOCHAR(_nX)+'</ITEM>'
		_cSchema	+= '<VALOR>'+CVALTOCHAR(_aVencto[_nX][2])+'</VALOR>'
		_cSchema	+= '<VENCTO>'+DTOC(_aVencto[_nX][1])+'</VENCTO>'
		_cSchema	+= '</PARCELA>'
		
	Next

	_cSchema	+= '</PARCELAS>'
	_cSchema	+= '</CONDICAO_PAGAMENTO>'
	_cSchema	+= '<ITEM_PEDIDO>'
		
	STGETPEDIDO()
		
	While (_cAlias1)->(!Eof())
		
		_nItem++
		
		_cSchema	+= '<ITEM>'
		_cSchema	+= '<ID_SEQ>'+CVALTOCHAR(_nItem)+'</ID_SEQ>'
		_cSchema	+= '<COD_PRODUTO>'+(_cAlias1)->C7_PRODUTO+'</COD_PRODUTO>'
		_cSchema	+= '<COD_EAN>'+(_cAlias1)->B1_CODBAR+'</COD_EAN>'
		_cSchema	+= '<DESCRICAO>'+(_cAlias1)->B1_DESC+'</DESCRICAO>'
		_cSchema	+= '<QT_PEDIDA>'+CVALTOCHAR((_cAlias1)->C7_QUANT)+'</QT_PEDIDA>'
		_cSchema	+= '<UNIDADE>'+(_cAlias1)->B1_UM+'</UNIDADE>'
		_cSchema	+= '<QT_EMBAL>'+CVALTOCHAR((_cAlias1)->B1_QE)+'</QT_EMBAL>'
		_cSchema	+= '<VL_UNIT_BRUTO>'+CVALTOCHAR((_cAlias1)->(C7_PRECO+C7_VALIPI+C7_ICMSRET))+'</VL_UNIT_BRUTO>'
		_cSchema	+= '<VL_UNIT_LIQ>'+CVALTOCHAR((_cAlias1)->C7_PRECO)+'</VL_UNIT_LIQ>'
		_cSchema	+= '</ITEM>'
	
		(_cAlias1)->(DbSkip())
	EndDo
		
	_cSchema	+= '</ITEM_PEDIDO>'
	_cSchema	+= '</PEDIDO>'
	
	_oXml		:= XmlParser(_cSchema,"_",@cErro,@cAviso)
	//_cSchema	:= Encode64(_cSchema)
	
	_oWsPedido:oWsOArquivo:cbConteudoArquivo	:= _cSchema
	_oWsPedido:oWsOArquivo:cstrNmArquivo		:= AllTrim(_cNumPed)+".xml"
	/*
	If !File("C:\"+_cNumPed+".xml")
		nHdlXml   := FCreate("C:\"+_cNumPed+".xml",0)
		If nHdlXml > 0
			FWrite(nHdlXml,_cSchema)
			FClose(nHdlXml)
		EndIf
	EndIf
	*/
	If _oWsPedido:recebeArquivo()
	
		_cLog	:= "Pedido enviado dia "+DTOC(DDATABASE)+" as "+Time()+" por "+cUserName
		
		_cQuery := " UPDATE "+RetSqlName("SC7")+" C7 "
		_cQuery += " SET C7.C7_XLOGWS='"+_cLog+"' "
		_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+SC7->C7_FILIAL+"' AND C7_NUM='"+SC7->C7_NUM+"' "

		nErrQry := TCSqlExec( _cQuery )

		If nErrQry <> 0
			Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATEN��O')
		EndIf

		MsgAlert('Pedido enviado com sucesso!')

	Else
		MsgAlert('Erro de Execu��o: '+GetWSCError())
	Endif

Return()

/*====================================================================================\
|Programa  | STGETTOTAIS      | Autor | giovani.zago          | Data | 11/09/2015  |
|=====================================================================================|
|Descri��o | WS para envio de pedido de compra para a �nica								  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STWSPC02                                                                 |
|=====================================================================================|
|Uso       | Compras											                              |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

Static Function STGETTOTAIS()

	Local _aTotais	:= {}
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"

	_cQuery  := " SELECT SUM(C7_TOTAL) VL_TOTAL, SUM(C7_VALICM) VL_ICMS, SUM(C7_VALIPI) VL_IPI, SUM(C7_ICMSRET) VL_ICMS_SUB "
	_cQuery  += " FROM "+RetSqlName("SC7")+" C7 "
	_cQuery  += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+SC7->C7_FILIAL+"' AND C7_NUM='"+SC7->C7_NUM+"' "
	
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
	
	If (_cAlias)->(!Eof())
		AADD(_aTotais,{(_cAlias)->VL_TOTAL})
		AADD(_aTotais,{(_cAlias)->VL_ICMS_SUB})
		AADD(_aTotais,{(_cAlias)->VL_ICMS})
		AADD(_aTotais,{(_cAlias)->VL_IPI})
	EndIf

Return(_aTotais)

/*====================================================================================\
|Programa  | STGETPEDIDO      | Autor | giovani.zago          | Data | 11/09/2015  |
|=====================================================================================|
|Descri��o | WS para envio de pedido de compra para a �nica								  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STWSPC02                                                                 |
|=====================================================================================|
|Uso       | Compras											                              |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

Static Function STGETPEDIDO()

	_cQuery1  := " SELECT C7_NUM, C7_PRODUTO, B1_CODBAR, B1_DESC, C7_QUANT, B1_UM, B1_QE, C7_PRECO, "
	_cQuery1  += " C7_IPI, C7_VALIPI, C7_PICM, C7_VALICM, C7_TOTAL, C7_ICMSRET "
	_cQuery1  += " FROM "+RetSqlName("SC7")+" C7 "
	_cQuery1  += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	_cQuery1  += " ON B1_COD=C7_PRODUTO "
	_cQuery1  += " WHERE B1.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+SC7->C7_FILIAL+"' AND C7_NUM='"+SC7->C7_NUM+"' "
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
	
	_cNumPed	:= (_cAlias1)->C7_NUM
	
Return()

/*====================================================================================\
|Programa  | JAENVIADO        | Autor | giovani.zago          | Data | 11/09/2015  |
|=====================================================================================|
|Descri��o | Verificar se o pedido j� foi enviado para a �nica							  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | JAENVIADO                                                                |
|=====================================================================================|
|Uso       | Compras											                              |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

Static Function JAENVIADO()

	Local _lRet		:= .F.
	Local _cQuery2	:= ""
	Local _cAlias2	:= "QRYTEMP2"

	_cQuery2  := " SELECT C7_XLOGWS "
	_cQuery2  += " FROM SC7010 C7 "
	_cQuery2  += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+SC7->C7_FILIAL+"' AND C7_NUM='"+SC7->C7_NUM+"' AND C7_XLOGWS<>' ' "
	
	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)
	
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())
	
	If (_cAlias2)->(!Eof())
		_lRet	:= .T.
		_cMsg	:= (_cAlias2)->C7_XLOGWS
	EndIf

Return(_lRet)