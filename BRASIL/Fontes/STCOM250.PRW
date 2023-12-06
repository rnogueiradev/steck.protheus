#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOM250
@name STCOM250
@type User Function
@desc gerar pedidos do MRP pela SC
@author Renato Nogueira
@since 13/04/2021
/*/

User Function STCOM250()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STCOM250",.F.,.F.,.T.)
		ConOut("[STCOM250]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STCOM250]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01" .And. SM0->M0_CODFIL$"05"
			ConOut(CRLF + "[STCOM251]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STCOM251",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOM251]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STCOM250]["+ FWTimeStamp(2) +"] Fim do processamento")

	UnLockByName("STCOM250",.F.,.F.,.T.)

	Reset Environment

Return

/*/{Protheus.doc} STCOM051
@name STCOM051
@type User Function
@desc 
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM251(cNewEmp,cNewFil)

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()
	Local _cCopia  	:= ""
	Local _aAttach 	:= {}
	Local _cCaminho	:= ""
	Local _nLin
	Private lMsErroAuto := .F.
	Private _cMesMrp	:= ""
	Private _cAnoMrp    := ""
	Default cNewEmp := "01"
	Default cNewFil := "05"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 1 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	cUserName := "Administrador"
	__cUserId := "000000"

	Conout("Usuário logado: "+__cUserId)

	_cQuery1 := " SELECT C1.*, B1SP.B1_CLAPROD CLASP, B1AM.B1_CLAPROD CLAAM
	_cQuery1 += " FROM SC1"+cNewEmp+"0 C1
	_cQuery1 += " LEFT JOIN SB1010 B1SP
	_cQuery1 += " ON B1SP.B1_COD=C1_PRODUTO AND B1SP.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN SB1030 B1AM
	_cQuery1 += " ON B1AM.B1_COD=C1_PRODUTO AND B1AM.D_E_L_E_T_=' '
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' '
	_cQuery1 += " AND C1_FILIAL='"+cNewFil+"'
	_cQuery1 += " AND C1_TPOP='F' AND C1_PEDIDO=' '
	_cQuery1 += " AND B1SP.B1_CLAPROD='C' AND B1AM.B1_CLAPROD='F'
	_cQuery1 += " AND C1_ZDTAPRO<>' ' AND C1_ZSTATUS='3' AND C1_SEQMRP<>' '
	_cQuery1 += " ORDER BY C1_FILIAL, C1_NUM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_aCabec 	:= {}
	_cNumSc 	:= ""
	_cItem  	:= "0000"
	_aItens 	:= {}
	_cFornece 	:= "005866"
	_cLoja	  	:= "01"

	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))

	_aSemPrc := {}

	DbSelectArea("SA5")
	SA5->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
	SA5->(DbGoTop())

	While (_cAlias1)->(!Eof())

		If !DA1->(DbSeek(xFilial("DA1")+'T02'+(_cAlias1)->C1_PRODUTO))
			AADD(_aSemPrc,(_cAlias1)->C1_PRODUTO)
			(_cAlias1)->(DbSkip())
			Loop
		EndIf

		If !SA5->(DbSeek(xFilial("SA5")+_cFornece+_cLoja+(_cAlias1)->C1_PRODUTO))
			SA5->(RecLock("SA5",.T.))
			SA5->A5_FORNECE := _cFornece
			SA5->A5_LOJA 	:= _cLoja
			SA5->A5_NOMEFOR	:= "STECK INDUSTRIA ELETRICA LTDA"
			SA5->A5_PRODUTO := (_cAlias1)->C1_PRODUTO
			SA5->(MsUnLock())
		EndIf

		_cItem 		:= Soma1(_cItem)
		_cNumSc := (_cAlias1)->C1_NUM

		_aItem :=   {	{"C7_ITEM"   	,_cItem    								,nil},;
			{"C7_PRODUTO"				,(_cAlias1)->C1_PRODUTO					,nil},;
			{"C7_QUANT" 				,(_cAlias1)->C1_QUANT				 	,nil},;
			{"C7_MOTIVO" 				,"SSP"								 	,nil},;
			{"C7_NUMSC" 				,(_cAlias1)->C1_NUM					 	,nil},;
			{"C7_ITEMSC" 				,(_cAlias1)->C1_ITEM				 	,nil},;
			{"C7_DATPRF" 				,STOD((_cAlias1)->C1_DATPRF)		 	,nil}}

		aadd(_aItens,_aItem)

		(_cAlias1)->(DbSkip())
	EndDo

	_cNumPc := GetSXENum("SC7","C7_NUM")
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	While .T.
		If SC7->(DbSeek(xFilial("SC7")+_cNumPc))
			SC7->(ConfirmSX8())
			_cNumPc := GetSXENum("SC7","C7_NUM")
		Else
			Exit
		EndIf
	EndDo

	_aCabec:= {{"C7_NUM"           		,_cNumPc 			,nil},;
		{"C7_EMISSAO"                   ,dDataBase			,nil},;
		{"C7_FORNECE"                   ,_cFornece			,nil},;
		{"C7_LOJA"                      ,_cLoja    			,nil},;
		{"C7_COND"                   	,"007"				,nil},;
		{"C7_MOEDA"                   	,1					,nil}}

	_cEmail := GetMv("STCOM250",,"rodrigo.ferreira@steck.com.br")
	_cCopia := ""

	If Len(_aSemPrc)>0

		_cAssunto := "[WFPROTHEUS] - Erro ao inserir pedido de compra do MRP

		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		cMsg += '<TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Produtos sem preço</Font></B></TD></TR>

		For _nLin := 1 to Len(_aSemPrc)
			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aSemPrc[_nLin] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(STCOM250)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,{},"")
		//Return
	EndIf

	If Len(_aItens)==0
		Return
	EndIf

	lMsErroAuto := .F.
	MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCabec,_aItens,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		_cAssunto := "[WFPROTHEUS] - Erro ao inserir pedido de compra do MRP"
		cMsg 	  := _cErro
		_aAttach  := {}
		_cCaminho := ""
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	Else
		_cAssunto := "[WFPROTHEUS] - Pedido de compra "+SC7->C7_NUM+" do MRP incluído com sucesso"
		cMsg	  := ""
		_aAttach  := {}
		_cCaminho := ""
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		_cNumSC7 := SC7->C7_NUM

		aItens := {}
		_cItemSC6 := "00"

		DbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+SC7->C7_NUM))
		While SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM)==xFilial("SC7")+_cNumSC7

			_cItemSC6 := Soma1(_cItemSC6)

			Aadd(aItens ,{{"C6_ITEM"		,_cItemSC6							       ,Nil},;
				{"C6_PRODUTO"				,SC7->C7_PRODUTO					       ,Nil},;
				{"C6_OPER"					,"15"									   ,Nil},;
				{"C6_TES"					,"701"									   ,Nil},;
				{"C6_QTDVEN"				,SC7->C7_QUANT							   ,Nil},;
				{"C6_PRCVEN"				,SC7->C7_PRECO							   ,Nil},;
				{"C6_PRUNIT"				,SC7->C7_PRECO							   ,Nil},;
				{"C6_VALOR"					,SC7->C7_TOTAL	     						,Nil},;
				{"C6_NUMPCOM"				,SC7->C7_NUM	     						,Nil},;
				{"C6_ITEMPC"				,SC7->C7_ITEM	     						,Nil},;
				{"C6_ENTREG"				,SC7->C7_DATPRF	     						,Nil}})

			SC7->(DbSkip())
		EndDo

		//Inserir pedido de venda
		_aRet := StartJob("U_STCOM252",GetEnvServer(),.T.,"03","01",aItens)

		If _aRet[1][1]=="ERRO"
			_cAssunto := "[WFPROTHEUS] - Erro ao inserir pedido de venda MRP"
			cMsg 	  := _aRet[1][2]
			_aAttach  := {}
			_cCaminho := ""
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		Else
			_cAssunto := "[WFPROTHEUS] - Pedido de venda MRP inserido com sucesso ("+_aRet[1][2]+")"
			cMsg 	  := ""
			_aAttach  := {}
			_cCaminho := ""
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		EndIf

	EndIf

	Reset Environment

Return

/*/{Protheus.doc} STCOM252
@name STCOM252
@type User Function
@desc 
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM252(cNewEmp,cNewFil,aItens)

	Local aCabec := {}
	Local _aRet	 := {}
	Private lMsErroAuto := .F.

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	aAdd(aCabec, {"C5_TIPO"		,"N"												,Nil}) // Tipo do Pedido
	aAdd(aCabec, {"C5_CLIENTE"	,"033467"											,Nil}) // Codigo do Cliente
	aAdd(aCabec, {"C5_LOJACLI"	,"05"												,Nil}) // Loja do Cliente
	aAdd(aCabec, {"C5_CLIENT"	,"033467"											,Nil}) // Codigo do Cliente para entrega
	aAdd(aCabec, {"C5_LOJAENT"	,"05"										 		,Nil}) // Loja para entrega
	aAdd(aCabec, {"C5_TRANSP"	,"100000"									 		,Nil}) // Loja para entrega
	aAdd(aCabec, {"C5_TIPOCLI"	,"R"												,Nil}) // Tipo do Cliente
	aAdd(aCabec, {"C5_CONDPAG"	,"502"												,Nil})
	aAdd(aCabec, {"C5_TABELA"	,"001"												,Nil})
	aAdd(aCabec, {"C5_TPFRETE"	,"F"												,Nil})
	aAdd(aCabec, {"C5_XTIPO"	,"2"												,Nil})
	aAdd(aCabec, {"C5_XTIPF"	,"1"												,Nil})
	aAdd(aCabec, {"C5_ZBLOQ"	,"2"												,Nil})
	aAdd(aCabec, {"C5_ZCONSUM"	,"1"												,Nil})
	aAdd(aCabec, {"C5_ZCONDPG"	,"502"												,Nil})

	MsExecAuto({|x, y, z| MATA410(x, y, z)},aCabec,aItens,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		AADD(_aRet,{"ERRO",_cErro})
	Else
		AADD(_aRet,{"OK",SC5->C5_NUM})
	EndIf

	Reset Environment

Return(_aRet)
