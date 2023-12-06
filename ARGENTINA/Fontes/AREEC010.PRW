#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PROTHEUS.CH"

/*====================================================================================\
|Programa  | AREEC010        | Autor | RENATO.OLIVEIRA           | Data | 01/08/2018  |
|=====================================================================================|
|Descrição | GERAR PV/EEC NO BRASIL					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function AREEC010()

	Local _aAreaSM0 := SM0->(GetArea())
	Local _cEmpPed	:= ""
	Local _cFilPed	:= ""
	Local _lAchou 	:= .F.
	Local _aCabec	:= {}
	Local _aItens	:= {}
	Local _cAlias1  := GetNextAlias()
	Local _cQuery1  := ""
	Local _cAlias2  := GetNextAlias()
	Local _cQuery2  := ""
	Local _cAlias3  := GetNextAlias()
	Local _cQuery3  := ""
	Local _nCount 	:= 0
	Local _aRetorno := {}
	Local _cOrigem  := ""
	Local _cDest	:= ""
	Local _cVia		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local _nX		:= 0
	Local _nY		:= 0
	Local lInseriu  := .F.

	dbSelectArea("SB1")
	dbSetOrder(1)

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	If !SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
		MsgAlert("Fornecedor não encontrado, verifique!")
		Return()
	EndIf

	If !Empty(SC7->C7_XNUMPED)
		MsgAlert("PV já gerado para esse PC, verifique!")
		Return
	EndIf

	_aAreaSM0 := SM0->(GetArea())

	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())

		If AllTrim(SA2->A2_CGC)==AllTrim(SM0->M0_CGC) .And. AllTrim(SA2->A2_INSCR)==AllTrim(SM0->M0_INSC)
			_lAchou 	:= .T.
			_cEmpPed	:= SM0->M0_CODIGO
			_cFilPed	:= SM0->M0_CODFIL
		EndIf

		SM0->(DbSkip())
	EndDo

	RestArea(_aAreaSM0)

	If !_lAchou
		MsgAlert("Atenção, fornecedor não é Steck, verifique!")
		Return
	EndIf
	
	If _cEmpPed=="01"
		_cOrigem := "GRU"
		_cDest	 := "BUE"
		_cVia	 := "03"
		_cTpTra	 := "1"
	ElseIf _cEmpPed=="03"
		_cOrigem := "MAO"
		_cDest	 := "BUE"
		_cVia	 := "03"
		_cTpTra	 := "4"
	EndIf
	
	_cQuery1 := " SELECT DISTINCT C7_COND, C7_PRODUTO, C7_QUANT,
	_cQuery1 += " B1_PESO, B1_QE, C7_PRECO, C7_ITEM, C7_PRECO
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" A2
	_cQuery1 += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA
	//_cQuery1 += " LEFT JOIN SYR"+_cEmpPed+"0 YR
	//_cQuery1 += " ON YR_VIA='"+_cVia+"' AND YR_ORIGEM='"+_cOrigem+"' AND YR_DESTINO='"+_cDest+"'
	//_cQuery1 += " AND YR.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN SB1"+_cEmpPed+"0 B1
	_cQuery1 += " ON B1_COD=C7_PRODUTO AND B1.D_E_L_E_T_=' '
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '
	_cQuery1 += " AND C7_FILIAL='"+SC7->C7_FILIAL+"' AND C7_NUM='"+SC7->C7_NUM+"'
	_cQuery1 += " ORDER BY C7_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		MsgAlert("Dados não encontrados, revise o cadastro de fornecedor!")
		Return
	EndIf

	_cQuery2 := " SELECT Y6_COD, Y6_MDPGEXP, Y6_DIAS_01 DIAS
	_cQuery2 += " FROM SY6"+_cEmpPed+"0 Y6
	_cQuery2 += " WHERE Y6.D_E_L_E_T_=' ' AND Y6_SIGSE4='511'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(Eof())
		MsgAlert("Condição de pagamento não encontrada!")
		Return
	EndIf
	
	_cQuery3 := " SELECT YR_VIA, YR_ORIGEM, YR_DESTINO, YR_PAIS_DE, YR_TIPTRAN
	_cQuery3 += " FROM SYR"+_cEmpPed+"0 YR
	_cQuery3 += " WHERE YR.D_E_L_E_T_=' ' 
	_cQuery3 += " AND YR_VIA='"+_cVia+"' AND YR_ORIGEM='"+_cOrigem+"' AND YR_DESTINO='"+_cDest+"'

	If !Empty(Select(_cAlias3))
		DbSelectArea(_cAlias3)
		(_cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

	dbSelectArea(_cAlias3)
	(_cAlias3)->(dbGoTop())

	If (_cAlias3)->(Eof())
		MsgAlert("Rota de transporte não cadastrada, verifique!!")
		Return
	EndIf
	
	aAdd(_aCabec, {"EE7_FILIAL"	,_cFilPed										,Nil})
	aAdd(_aCabec, {"EE7_IMPORT"	,"033833"										,Nil})
	aAdd(_aCabec, {"EE7_IMLOJA"	,"01"											,Nil})
	aAdd(_aCabec, {"EE7_FORN"	,"005764"										,Nil})
	aAdd(_aCabec, {"EE7_FOLOJA"	,"02"											,Nil})
	aAdd(_aCabec, {"EE7_IDIOMA"	,"INGLES-INGLES"								,Nil})
	aAdd(_aCabec, {"EE7_CONDPA"	,(_cAlias2)->Y6_COD								,Nil})   	
	aAdd(_aCabec, {"EE7_DIASPA"	,(_cAlias2)->DIAS						    	,Nil})   // Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_DESCPA"	,'COND.PAGAMENTO'								,Nil})   // Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_MPGEXP"	,(_cAlias2)->Y6_MDPGEXP							,Nil})
	aAdd(_aCabec, {"EE7_DSCMPE"	,'COBRANCA'										,Nil})   // Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_INCOTE"	,"FOB"											,Nil})
	aAdd(_aCabec, {"EE7_MOEDA"	,"US$"											,Nil})
	aAdd(_aCabec, {"EE7_FRPPCC"	,"CC"											,Nil})
	aAdd(_aCabec, {"EE7_VIA"	,(_cAlias3)->YR_VIA								,Nil})
	aAdd(_aCabec, {"EE7_VIA_DE"	,'VIA TRANSP'									,Nil})	// Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_ORIGEM"	,(_cAlias3)->YR_ORIGEM							,Nil})
	aAdd(_aCabec, {"EE7_DSCORI"	,'ACEGUA-RS'									,Nil})	// Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_DEST"	,(_cAlias3)->YR_DESTINO			  				,Nil})
	aAdd(_aCabec, {"EE7_DSCORI"	,'VITORIA-ES'									,Nil})	// Valdemir Rabelo 20/08/2019
	aAdd(_aCabec, {"EE7_PAISET"	,(_cAlias3)->YR_PAIS_DE							,Nil})
	aAdd(_aCabec, {"EE7_TIPTRA"	,(_cAlias3)->YR_TIPTRAN							,Nil})
	aAdd(_aCabec, {"EE7_XTIPO"	,"1"											,Nil})
	aAdd(_aCabec, {"EE7_CONSIG"	,"033833"										,Nil})  // Valdemir Rabelo 21/08/2019

	While (_cAlias1)->(!Eof())
			
		SB1->( dbSeek(XFilial('SB1')+(_cAlias1)->C7_PRODUTO))
		cDESPROD := SB1->B1_DESC
						
		_nCount++
		// Adicionar EE8_DESC - Aguardando Jefferson falar com a Usuária
		Aadd(_aItens ,{;
			{"EE8_COD_I"				,(_cAlias1)->C7_PRODUTO										,Nil},;
			{"EE8_SEQUEN"				,cValToChar(_nCount)										,Nil},;
			{"EE8_VM_DES"   			,cDESPROD													,Nil},;
			{"EE8_FORN"   				,"005764"													,Nil},;
			{"EE8_FOLOJA"				,"02"														,Nil},;
			{"EE8_SLDINI"				,(_cAlias1)->C7_QUANT										,Nil},;
			{"EE8_EMBAL1"				,"S850LI"													,Nil},;
			{"EE8_QE"					,IIf((_cAlias1)->B1_QE>0,(_cAlias1)->B1_QE,1)				,Nil},;
			{"EE8_QTDM1"				,SB1->B1_QE													,Nil},;
			{"EE8_PSLQUN"				,SB1->B1_PESO												,Nil},;
			{"EE8_PRECO"				,(_cAlias1)->C7_PRECO										,Nil},;
			{"EE8_TES"					,"728"														,Nil},;
			{"EE8_CF"					,"7102"														,Nil}})

			//{"EE8_POSIPI"				,SB1->B1_POSIPI												,Nil},;

		(_cAlias1)->(DbSkip())
	EndDo

	//----------------------- Valdemir Rabelo 20/08/2019 ------------------------------------------
	oRpcSrv   := nil
	cAmbiente := "P12_JE"
	cServer   := '10.152.4.7'
	nPorta    := 12003
	lConnSrv  := .f.
	oRpcSrv := TRpc():New( AllTrim(cAmbiente) )
	If ( oRpcSrv:Connect( cServer, nPorta ) )
		lConnSrv := .T.
	EndIf
	If lConnSrv
		_aRetorno := oRpcSrv:CallProc("U_STEEC010",_cEmpPed,_cFilPed,_aCabec,_aItens)
	Endif
	If lConnSrv
		oRpcSrv:Disconnect()
	EndIf
			
    // Retorno da Rotina processada no ambiente Brasil
	lInseriu := _aRetorno[1]
	_cERROR  := _aRetorno[2]
	_cNumPed := _aRetorno[3]

	//------------------------------------------------------------------------------------

	If  lInseriu			

		MsgAlert("Pedido gerado com sucesso, número: "+_cNumPed)

		_aAreaSC7 := SC7->(GetArea())
		_cFilial  := SC7->C7_FILIAL
		_cNumSC7  := SC7->C7_NUM

		SC7->(DbSetOrder(1))
		SC7->(DbSeek(SC7->(C7_FILIAL+C7_NUM)))
		While SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM)==_cFilial+_cNumSC7

			SC7->(RecLock("SC7",.F.))
			SC7->C7_XFILPED := _cFilPed
			SC7->C7_XNUMPED := _cNumPed
			SC7->(MsUnLock())

			SC7->(DbSkip())
		EndDo

		RestArea(_aAreaSC7)

	Else
		// Valdemir Rabelo 20/08/2019
		Aviso("Atenção!!!"; 				//01 - cTitulo - TÃƒÂ­tulo da janela
			,"Houve inconsistência na geração do registro"+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			_cERROR,; 						 //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,'Problemas MSExecAuto';         //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
			,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
			)				 

	EndIf

Return()

/*====================================================================================\
|Programa  | AREEC011        | Autor | RENATO.OLIVEIRA           | Data | 26/07/2018  |
|=====================================================================================|
|Descrição | GERAR PV/EEC NO BRASIL					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function AREEC011(_cXml)

	Local _aRet 	:= {}
	Local _cNumPed 	:= ""
	Private lMsErroAuto := .F.

	//RpcSetType(3)
	RpcSetEnv(_cEmpPed,_cFilPed,,,"EEC")

	_cNumPed := GETSX8NUM("EE7","EE7_PEDIDO")

	aAdd(_aCabec, {"EE7_PEDIDO"	,_cNumPed	,Nil})

	lMsErroAuto	:= .F.
	MsExecAuto({|x, y, z| EECAP100(x, y, z)}, _aCabec, _aItens,3)

	If lMsErroAuto

		_cErro := MostraErro()

		AADD(_aRet,.F.)
		AADD(_aRet,_cErro)
		AADD(_aRet,"")

		EE7->(RollBackSX8())

	Else

		AADD(_aRet,.T.)
		AADD(_aRet,"")
		AADD(_aRet,EE7->EE7_PEDIDO)

		EE7->(ConfirmSX8())

	EndIf

	Reset Environment

Return(_aRet)