#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STMKP030        | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição | Rotina criada para baixar os pedidos aprovados da precode                |
|          | .                                                                        |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//FR - Tickets: 
//      #20211028023112 - solicitante Caroline pede receber o aviso WF
//      #20211027023017 - corrigir transportadora no pedido (precisa ser 004405)
//-------------------------------------------------------------------------------------//
User Function STMKP030()

	Local _cAlias1 		:= ""
	Local _aHeadOut 	:= {}
	Local _nTimeOut 	:= 60
	Local _cHeadRet 	:= ""
	Local _cUrl			:= ""
	Local oRestClient
	Local _aRet			:= {}
	Local _nY
	Local _nX
	Local _aPedidos 	:= {}
	Local _aPedFinal	:= {}

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STMKP030",.F.,.F.,.T.)
		ConOut("[STMKP030]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	DbSelectArea("SC5")
	SC5->(DbOrderNickName("STWEBPED"))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("ZH2")
	ZH2->(DbSetOrder(3))
	DbSelectArea("PA2")
	PA2->(DbSetOrder(2)) //PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES
	DbSelectArea("Z76")
	Z76->(DbSetOrder(1)) //Z76_FILIAL+Z76_PEDPAI+Z76_PEDFIL

	_cEmail := GetMv("STMKP0301",,"renato.oliveira@steck.com.br")

	_cAlias1 := GetNextAlias()

	_cToken := AllTrim(GetMv("ST_TOKPREC",,"dFA2M0dXWUxzVklOSWljTDY6"))
	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "erp/aprovado

	ConOut("[STMKP030]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	aAdd( _aHeadOut , "Authorization: Basic "+_cToken)
	aAdd( _aHeadOut , "Content-Type: application/json; charset=utf-8")

	_aProc := {}
	_lRet  := .F.

	oRestClient   := FWRest():New(_cUrl)
	oRestClient:setPath("/erp/aprovado")
	oRestClient:nTimeOut := 600
	If oRestClient:Get(_aHeadOut)
		oInfo 	  	:= ""
		_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
	Else
		AADD(_aRet,{"","Erro de chamada do REST: "+AllTrim(oRestClient:GetLastError()),"ERRO"})
		AADD(_aProc,_aRet)
	EndIf

	If _lRet
		_nPags := oInfo:PAGINAS
		FreeObj(oRestClient)
		FreeObj(oInfo)
		For _nX:=1 To _nPags
			oRestClient   := FWRest():New(_cUrl+"/"+cValToChar(_nX))
			oRestClient:setPath("/erp/aprovado")
			oRestClient:nTimeOut := 600
			If oRestClient:Get(_aHeadOut)
				If FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
					If Type("oInfo:PEDIDO")=="A"
						For _nY:=1 To Len(oInfo:PEDIDO)
							//_aRet := PROCESSAR(oInfo:PEDIDO[_nY])
							//AADD(_aProc,_aRet)
							If oInfo:PEDIDO[_nY]:CODIGOCARRINHOCOMPRAS==NIL
								oInfo:PEDIDO[_nY]:CODIGOCARRINHOCOMPRAS := oInfo:PEDIDO[_nY]:CODIGOPEDIDO
							EndIf
							AADD(_aPedidos,oInfo:PEDIDO[_nY])
						Next
					EndIf
				EndIf
			EndIf
			FreeObj(oRestClient)
			FreeObj(oInfo)
		Next
		
		If Len(_aPedidos)>0
			For _nX:=1 To Len(_aPedidos)
			
				_nPosFinal := 0
				
				For _nY:=1 To Len(_aPedFinal)
					If AllTrim(cValToChar(_aPedidos[_nX]:CODIGOCARRINHOCOMPRAS))==AllTrim(cValToChar(_aPedFinal[_nY]:CODIGOCARRINHOCOMPRAS))
						_nPosFinal := _nY
					EndIf
				Next
				
				If _nPosFinal==0
					AADD(_aPedFinal,_aPedidos[_nX])
					_aPedFinal[Len(_aPedFinal)]:TIPOPEDIDO := cValToChar(_aPedidos[_nX]:CODIGOPEDIDO)
				Else
					For _nY:=1 To Len(_aPedidos[_nX]:ITENS)
						AADD(_aPedFinal[_nPosFinal]:ITENS,_aPedidos[_nX]:ITENS[_nY])
						_aPedFinal[_nPosFinal]:TIPOPEDIDO += "#"+cValToChar(_aPedidos[_nX]:CODIGOPEDIDO)
					Next
				EndIf
				
			Next
		EndIf
		
	Else
		AADD(_aRet,{"","Erro de conversão do retorno JSON","ERRO"})
		AADD(_aProc,_aRet)
	EndIf
	
	For _nX:=1 To Len(_aPedFinal)
		_aRet := PROCESSAR(_aPedFinal[_nX])
		AADD(_aProc,_aRet)
	Next

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<TR BgColor=#FFFFFF>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Pedido</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Mensagem</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Status</Font></B></TD>
	cMsg += '</TR>

	For _nX:=1 To Len(_aProc)

		_cColor := "white"

		If AllTrim(_aProc[_nX][1][3])=="ERRO"
			cMsg += '<TR BgColor=#FF0000>
			_cColor := "white"
		Else
			cMsg += '<TR BgColor=#00FF00>
			_cColor := "black"
		EndIf

		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][1])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][2])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][3])+'</Font></B></TD>
		cMsg += '</TR>

	Next

	cMsg += '</body></html>'

	//_cEmail := GetMv("STMKP0301",,"renato.oliveira@steck.com.br;caroline.atouguia@steck.com.br;marcelo.oliveira@steck.com.br ")
	
	//-----------------------------------------------------------------------------------------//
	//FR - 04/11/2021 - Tickets: 
	//      #20211028023112 - solicitante Caroline pede receber o aviso WF
	//      #20211027023017 - corrigir transportadora no pedido (precisa ser 004405) 
	//-----------------------------------------------------------------------------------------//
	_cEmail := GetNewPar("STMKP0301" , "veronica.brandao@steck.com.br;marcelo.oliveira@steck.com.br;caroline.atouguia@steck.com.br")
	
	//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br;"				//FR - TESTE RETIRAR
	//_cEmail += "caroline.atouguia@steck.com.br"								//FR - TESTE RETIRAR

	If Len(_aProc)>0
		U_STMAILTES(_cEmail,"","[MKP] - Resumo de processamento dos pedidos aprovados",cMsg,{},"")
		//FRSendMail(_cEmail, "", "[MKP] - Resumo de processamento dos pedidos aprovados", cMsg, "" )  //FR - TESTE RETIRAR
	EndIf

	U_STMKP040() //Enviar status de aceite

	U_STMKP050() //Baixar reservas

	U_STMKP070() //Baixar pedidos cancelados

	U_STMKP020() //Enviar saldos

	UnLockByName("STMKP030",.F.,.F.,.T.)

	ConOut("[STMKP030]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

/*====================================================================================\
|Programa  | PROCESSAR       | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSAR(_oPedido)

	Local _aRet 	:= {}
	Local aCabec	:= {}
	Local aItens	:= {}
	Local _nX
	Local _cTpfrete := ""		//FR - #Ticket 20211027023017
	Local _cTpEntreg:= ""		//FR - #Ticket 20211027023017
	Private lMsErroAuto  := .F.

	//Verificar se cliente existe
	SA1->(DbSetOrder(3))
	If !SA1->(DbSeek(xFilial("SA1")+PADR(_oPedido:DADOSCLIENTE:CPFCNPJ,13)))
		_cRet := CriaSA1(_oPedido)
		If !Empty(_cRet)
			AADD(_aRet,{_oPedido:CODIGOCARRINHOCOMPRAS,"Erro ao criar o cliente: "+_cRet,"ERRO"})
			Return(_aRet)
		EndIf
	EndIf
	
	_cPedWeb := PADR(AllTrim(cValToChar(_oPedido:CODIGOCARRINHOCOMPRAS)),TamSx3("C5_XNUMWEB")[1]) 

	//Verificar se pedido existe
	If SC5->(DbSeek(xFilial("SC5")+"2"+_cPedWeb))
		AADD(_aRet,{_cPedWeb,"Pedido já incluído.","ERRO"})
		Return(_aRet)
	EndIf

	//FR - #Ticket 20211027023017
	_cTransp  := GetNewPar("ST_TMKP030" , "004405" ) //"004405"
	_cTpfrete := GetNewPar("STMKP030F"  , "F"      ) //tipo frete : F-Fob, C-Cif; para os pedidos mercado livre é Fob
	_cTpEntreg:= GetNewPar("STMKP030E"  , "1"      ) //tipo entrega : 1=Retira;2=Entrega para os pedidos mercado livre é Retira
	//FR - #Ticket 20211027023017                                                                                                             

	aAdd(aCabec, {"C5_TIPO"		,"N"												,Nil}) // Tipo do Pedido
	aAdd(aCabec, {"C5_CLIENTE"	,SA1->A1_COD										,Nil}) // Codigo do Cliente
	aAdd(aCabec, {"C5_LOJACLI"	,SA1->A1_LOJA										,Nil}) // Loja do Cliente
	aAdd(aCabec, {"C5_CLIENT"	,SA1->A1_COD										,Nil}) // Codigo do Cliente para entrega
	aAdd(aCabec, {"C5_LOJAENT"	,SA1->A1_LOJA								 		,Nil}) // Loja para entrega
	aAdd(aCabec, {"C5_TIPOCLI"	,"F"												,Nil}) // Tipo do Cliente
	aAdd(aCabec, {"C5_CONDPAG"	,"501"												,Nil}) // Condicao de pagamanto
	aAdd(aCabec, {"C5_ZCONDPG"	,"501"												,Nil}) // COND PG
	aAdd(aCabec, {"C5_VEND1"	,""												   	,Nil}) //VENDEDOR 1
	//aAdd(aCabec, {"C5_TPFRETE"	,"C"												,Nil}) // Frete //FR - #Ticket 20211027023017
	aAdd(aCabec, {"C5_TPFRETE"	, _cTpfrete											,Nil}) // Frete
	aAdd(aCabec, {"C5_FRETE"	,_oPedido:valorFrete								,Nil}) // Transportadora
	//aAdd(aCabec, {"C5_XTIPO"	,"2"												,Nil}) //Tipo Entrega //FR - #Ticket 20211027023017
	aAdd(aCabec, {"C5_XTIPO"	,_cTpEntreg											,Nil}) //Tipo Entrega
	aAdd(aCabec, {"C5_XTIPF"	,"1"												,Nil}) // Moeda C5_XTIPO   C5_XTIPF
	aAdd(aCabec, {"C5_XORIG"	,"2"												,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XCANAL"	,Upper(AllTrim(_oPedido:canal))						,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XIDAFIL"	,Upper(AllTrim(cvaltochar(_oPedido:idAfiliado)))	,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XNMAFIL"	,Upper(AllTrim(_oPedido:nomeAfiliado))				,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XDISP"	,Upper(AllTrim(_oPedido:dispositivo))				,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XDTEN"	,STOD(AllTrim(StrTran(_oPedido:previsaoEntrega,"-","")))	,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XBLQFMI"	,"N"												,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XLIBAVI"	,"S"												,Nil}) // Moeda C5_XTIPO
	aAdd(aCabec, {"C5_XNUMWEB"	,_cPedWeb											,Nil}) // Moeda C5_XTIPO   C5_XTIPF
	aAdd(aCabec, {"C5_XWEB"		,AllTrim(_oPedido:pedidoParceiro)					,Nil}) // Moeda C5_XTIPO   C5_XTIPF
	aAdd(aCabec, {"C5_XALERTF"	,"PEDIDO DE INTERNET"								,Nil})
	aAdd(aCabec, {"C5_XOBSEXP"	,"PEDIDO DE INTERNET"								,Nil})

	//20201201011555
	//If !AllTrim(SA1->A1_CEP)==AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:CEP)
		aAdd(aCabec, {"C5_ZCEPE" ,AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:CEP),Nil})
		aAdd(aCabec, {"C5_ZENDENT" ,UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:ENDERECO+", "+_oPedido:DADOSCLIENTE:DADOSENTREGA:NUMERO)),Nil})
		aAdd(aCabec, {"C5_ZBAIRRE" ,UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:BAIRRO)),Nil})
		aAdd(aCabec, {"C5_XCODMUN" ,SubStr(_oPedido:DADOSCLIENTE:DADOSENTREGA:CODIGOIBGE,3,5),Nil})
		aAdd(aCabec, {"C5_ZMUNE" ,UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:CIDADE)),Nil})
		aAdd(aCabec, {"C5_ZESTE" ,UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:UF)),Nil})
	//EndIf
	
	_nTotSIPI := 0
	
	For _nX:=1 To Len(_oPedido:ITENS)

		If !SB1->(DbSeek(xFilial("SB1")+PADR(AllTrim(_oPedido:ITENS[_nX]:REFERENCIALOJA),TamSx3("B1_COD")[1])))
			AADD(_aRet,{_cPedWeb,"Produto "+AllTrim(_oPedido:ITENS[_nX]:REFERENCIALOJA)+" não encontrado!","ERRO"})
			Return(_aRet)
		EndIf

		_nPreco 	:= _oPedido:ITENS[_nX]:VALORUNITARIO
		_nPDesc		:= 0
		_nPrcSIPI 	:= Round((_nPreco*(1-_nPDesc))/(1+(SB1->B1_IPI/100)),2)
		_nTotSIPI   += _nPrcSIPI

	Next

	For _nX:=1 To Len(_oPedido:ITENS)

		If !SB1->(DbSeek(xFilial("SB1")+PADR(AllTrim(_oPedido:ITENS[_nX]:REFERENCIALOJA),TamSx3("B1_COD")[1])))
			AADD(_aRet,{_cPedWeb,"Produto "+AllTrim(_oPedido:ITENS[_nX]:REFERENCIALOJA)+" não encontrado!","ERRO"})
			Return(_aRet)
		EndIf

		//20201113010559
		If AllTrim(SB1->B1_GRUPO) $ "128"
			_cTransp := "002053"
		EndIf

		cTesPad := U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,"501",'TES',.F.,SA1->A1_TIPO,"")
		
		_nPreco 	:= _oPedido:ITENS[_nX]:VALORUNITARIO
		_nPDesc		:= 0
		_nPrcSIPI 	:= Round((_nPreco*(1-_nPDesc))/(1+(SB1->B1_IPI/100)),2)

		If _nPrcSIPI<_oPedido:valorFrete
			_nPrcSFret  := _nPrcSIPI
		Else
			_nPerFret   := _nPrcSIPI/_nTotSIPI
			_nPrcSFret	:= Round(_nPrcSIPI-(_oPedido:valorFrete*_nPerFret),2)			
		EndIf

		_nValLiqPrd := 0
		_nValLiqPrd := STLiq(_nPrcSFret*_oPedido:ITENS[_nX]:QUANTIDADE,SB1->B1_COD,_oPedido:ITENS[_nX]:QUANTIDADE,cTesPad)

		Aadd(aItens ,{{"C6_ITEM"		,PADL(_nX,2,"0")							   ,Nil},;
		{"C6_PRODUTO"				,SB1->B1_COD								       ,Nil},;
		{"C6_OPER"					,"01"											   ,Nil},;
		{"C6_TES"					,cTesPad										   ,Nil},;
		{"C6_QTDVEN"				,_oPedido:ITENS[_nX]:QUANTIDADE					   ,Nil},;
		{"C6_PRCVEN"				,_nPrcSFret										   ,Nil},;
		{"C6_PRUNIT"				,_nPrcSFret										   ,Nil},;
		{"C6_VALOR"					,Round(_oPedido:ITENS[_nX]:QUANTIDADE*_nPrcSFret,2)			,Nil},;
		{"C6_ZVALLIQ"	,_nValLiqPrd													,Nil}})

	Next

	//aAdd(aCabec, {"C5_TRANSP"	,"004405"					,Nil}) // Transportadora
	aAdd(aCabec, {"C5_TRANSP"	,_cTransp					,Nil}) // Transportadora		//FR - 05/11/2021 - Ticket #20211027023017

	MsExecAuto({|x, y, z| MATA410(x, y, z)},aCabec,aItens,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		AADD(_aRet,{_cPedWeb,"Erro ao inserir pedido "+_cErro,"ERRO"})
		Return(_aRet)
	Else

		AADD(_aRet,{_cPedWeb,"Pedido incluído com sucesso, número ERP "+SC5->C5_NUM,"OK"})
		
		_cPedPai := _cPedWeb
		
		_aPeds := StrTokArr(AllTrim(_oPedido:TIPOPEDIDO),"#")

		For _nX:=1 To Len(_aPeds)
			_cPedFil := PADR(AllTrim(_aPeds[_nX]),TamSx3("Z76_PEDFIL")[1])
			If !Z76->(DbSeek(xFilial("Z76")+_cPedPai+_cPedFil))
				Z76->(RecLock("Z76",.T.))
				Z76->Z76_FILIAL := xFilial("Z76")
				Z76->Z76_PEDPAI := _cPedPai
				Z76->Z76_PEDFIL := _cPedFil
				Z76->(MsUnLock())
			EndIf
		Next

		ZH2->(DbSetOrder(3))
		Z76->(DbSeek(xFilial("Z76")+_cPedPai))
		While Z76->(!Eof()) .And. Z76->(Z76_FILIAL+Z76_PEDPAI)==xFilial("Z76")+_cPedPai

			//Matar reserva
			//PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES
			PA2->(DbSeek(xFilial("PA2")+"1"+PADR("MKP"+AllTrim(Z76->Z76_PEDFIL),TamSx3("PA2_DOC")[1])))
			While PA2->(!Eof()) .And. PA2->(PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_FILRES)==;
			xFilial("PA2")+"1"+PADR("MKP"+AllTrim(Z76->Z76_PEDFIL),TamSx3("PA2_DOC")[1])+cFilAnt
	
				PA2->(RecLock("PA2",.F.))
				PA2->(DbDelete())
				PA2->(MsUnLock())
	
				PA2->(DbSkip())
				EndDo

			If !ZH2->(DbSeek(xFilial("ZH2")+Z76->Z76_PEDFIL+"1"))
				ZH2->(RecLock("ZH2",.T.))
				ZH2->ZH2_FILIAL := xFilial("ZH2")
				ZH2->ZH2_DTINS	:= Date()
				ZH2->ZH2_HRINS  := Time()
				ZH2->ZH2_TIPO 	:= "1"
				ZH2->ZH2_PEDMKP	:= Z76->Z76_PEDFIL
				ZH2->ZH2_PEDERP := SC5->C5_NUM
				ZH2->(MsUnLock())
			EndIf
			
			Z76->(DbSkip())
		EndDo

		Return(_aRet)
	EndIf

Return(_aRet)

/*====================================================================================\
|Programa  | CriaSA1         | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function CriaSA1(_oPedido)

	Local _cRet 	:= ""
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _cCliente := ""
	Private lMsErroAuto := .F.

	_cQuery1 := " SELECT MAX(A1_COD) CODIGO
	_cQuery1 += " FROM SA1010 A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A1_COD NOT IN (
	_cQuery1 += " '909709',
	_cQuery1 += " '909695',
	_cQuery1 += " '900886',
	_cQuery1 += " '900001',
	_cQuery1 += " '900000',
	_cQuery1 += " '122246',
	_cQuery1 += " '122246',
	_cQuery1 += " '111131',
	_cQuery1 += " '111125',
	_cQuery1 += " '111125',
	_cQuery1 += " '101161',
	_cQuery1 += " '101161',
	_cQuery1 += " '1',
	_cQuery1 += " '099001'
	_cQuery1 += " ) AND A1_PESSOA<>' '
	_cQuery1 += " ORDER BY A1_COD DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cCliente := Soma1((_cAlias1)->CODIGO)
	EndIf

	If Len(AllTrim(_oPedido:DADOSCLIENTE:CPFCNPJ))==11
		_cTpPessoa := "F"
		_cGrpVen   := "C3"
	Else
		_cTpPessoa := "J"
		_cGrpVen   := "C1"
	EndIf

	aCliente :={{"A1_PESSOA"		, _cTpPessoa           				, Nil},;
	{"A1_CGC"		, _oPedido:DADOSCLIENTE:CPFCNPJ           				, Nil},;
	{"A1_COD"		, _cCliente						  						, Nil},;
	{"A1_LOJA"		, "01"							  						, Nil},;
	{"A1_NOME"		, UPPER(AllTrim(_oPedido:DADOSCLIENTE:NOMERAZAO))		, Nil},;
	{"A1_NREDUZ"	, UPPER(AllTrim(_oPedido:DADOSCLIENTE:FANTASIA))	    , Nil},;
	{"A1_END"		, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:ENDERECO+", "+_oPedido:DADOSCLIENTE:DADOSENTREGA:NUMERO))		    , Nil},;
	{"A1_TIPO"		, "F"		   											, Nil},;
	{"A1_EST"		, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:UF))					, Nil},;
	{"A1_COD_MUN"	, SubStr(_oPedido:DADOSCLIENTE:DADOSENTREGA:CODIGOIBGE,3,5)			, Nil},;
	{"A1_BAIRRO"	, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:BAIRRO))				, Nil},;
	{"A1_CEP"		, _oPedido:DADOSCLIENTE:DADOSENTREGA:CEP				, Nil},;
	{"A1_PAIS"		, "105"													, Nil},;
	{"A1_EMAIL"		, _oPedido:DADOSCLIENTE:EMAIL							, Nil},;
	{"A1_CODPAIS"	, "01058"												, Nil},;
	{"A1_CONTRIB"	, "2"													, Nil},;
	{"A1_RISCO"		, "A"													, Nil},;
	{"A1_DDD"		, "0"+SubStr(_oPedido:DADOSCLIENTE:TELEFONES:RESIDENCIAL,1,2)			, Nil},;
	{"A1_TEL"		, SubStr(_oPedido:DADOSCLIENTE:TELEFONES:RESIDENCIAL,3,9)			, Nil},;
	{"A1_VEND"		, "R00099"			, Nil},;
	{"A1_ATIVIDA"	, _cGrpVen			, Nil},;
	{"A1_GRPVEN"	, _cGrpVen			, Nil},;
	{"A1_ESTC"	, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:UF))			, Nil},;
	{"A1_MUNC"	, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:CIDADE))			, Nil},;
	{"A1_CEPC"	, _oPedido:DADOSCLIENTE:DADOSENTREGA:CEP			, Nil},;
	{"A1_ENDCOB"	, UPPER(AllTrim(_oPedido:DADOSCLIENTE:DADOSENTREGA:ENDERECO+", "+_oPedido:DADOSCLIENTE:DADOSENTREGA:NUMERO))			, Nil},;
	{"A1_NATUREZ"	, "10101"												, Nil}}

	MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //3- Inclusão

	If lMsErroAuto
		_cRet := MostraErro("arquivos\logs",dtos(date())+time()+".log")
	EndIf

Return(_cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STLiq³ 	  Autor ³ Giovani Zago          ³ Data ³13/03/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retornar valor liquido							          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STLiq(_nValor,_cProduto,_nQuant,_cTesA)

	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	//DbSelectArea("SA1")
	//SA1->(dbSetOrder(1))
	//SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'

	//dbSelectArea("SB1")
	//dbSetOrder(1)
	//DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	//_cTes:=U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')	// u_LcStOper()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof + nValCmp + nValDif)

Return(round(_nValor,2))

//FR TESTES
/*
User Function fContinua()
Local nLoop := 0

While nLoop <= 10
	U_STMKP030()
	SLEEP(10000)
	nLoop++
Enddo

MSGALERT("FIM PROCESSO !!!")

RETURN
*/

/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
//FUNÇÃO FR PARA TESTES
/*
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
*/
