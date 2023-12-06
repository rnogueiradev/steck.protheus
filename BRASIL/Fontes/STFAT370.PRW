#INCLUDE "TBICONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT370        | Autor | RENATO.OLIVEIRA           | Data | 26/03/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT370(_lTela,_cTipo)

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _lRet := .F.
	Local _oDlg
	Local oEdit1
	Local _cEmail := Space(100)
	Local _lEst := .T.
	Default _lTela  := .F.
	Default _cTipo  := "G"

	If _cTipo=="C"

		DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Automático de E-Mail") FROM C(330),C(243) TO C(449),C(721) PIXEL

		// Cria Componentes Padroes do Sistema
		@ C(008),C(009) Say "Envia e-mail para cliente listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(021),C(010) MsGet oEdit1 Var _cEmail Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
		@ C(044),C(137) Button OemtoAnsi("Envia") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
		@ C(044),C(185) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())

		ACTIVATE MSDIALOG _oDlg CENTERED

		If !_lRet
			MsgAlert("Envio cancelado!")
		EndIf

	EndIf

	If !_lTela
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	EndIf

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT370]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cQuery1 := " SELECT A1.R_E_C_N_O_ SA1REC
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' '
	If _cTipo=="C"
		_cQuery1 += " AND A1_COD='"+SA1->A1_COD+"' AND A1_LOJA='"+SA1->A1_LOJA+"'
	Else
		_cQuery1 += " AND A1_XENVTBP='S' AND A1_XENVTBE<>' ' 
		//_cQuery1 += " AND A1_COD IN ('000116','000174')
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	DbSelectArea("SA1")

	If _lTela .And. (_cAlias1)->(Eof())
		MsgAlert("Atenção, dados de cadastro incompletos, favor verificar!")
		Return
	EndIf

	If _cTipo=="C"
		If (SA1->A1_TIPO $ 'R' .And. SA1->A1_CONTRIB = '1'  .And. !(alltrim(SA1->A1_ATIVIDA) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(SA1->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(SA1->A1_INSCR)))) .Or. ;
		(SA1->A1_TIPO $ 'F' .And. SA1->A1_CONTRIB = '1'  .And. (!Empty(ALLTRIM(SA1->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(SA1->A1_INSCR))) .and. _lEst )
				If Empty(SA1->A1_XDESTP)
					MsgAlert("Atenção, preencha a destinação do produto na aba outros!")
				Return
			EndIf
		EndIf
	EndIf

	While (_cAlias1)->(!Eof())

		SA1->(DbGoTo((_cAlias1)->SA1REC))

		If _cTipo=="G"
			StartJob("U_STFAT373",GetEnvServer(),.F.,SA1->A1_COD,SA1->A1_LOJA)
		EndIf

		If _cTipo=="C"
			_cArq := U_RSTFAT08()
		EndIf

		If _cTipo=="C"

			_aAttach    := {}
			_cCopia 	:= Alltrim(GetMv("STFAT3701",,""))
			_cAssunto   := "[WFPROTHEUS] - Lista de preços Steck
			cMsg		:= ""
			aadd( _aAttach  , _cArq )
			_cCaminho := "\arquivos\listaprecos\"

			cMsg := '<html><head><title>stkSales</title></head>
			cMsg += '<body>
			cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
			cMsg += '<br><br>Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
			cMsg += 'Você está recebendo a lista de preços da da Steck!<br>
			cMsg += 'Qualquer dúvida entre em contato com os nossos vendedores.<br>'
			cMsg += 'Obrigado!<br><br>'
			cMsg += 'Atenciosamente,<br>
			cMsg += 'Steck Indústria Elétrica Ltda
			cMsg += '</body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	If !_lTela
		ConOut("[STFAT370]["+ FWTimeStamp(2) +"] Fim do processamento")
	Else
		MsgAlert("Processamento finalizado!")
	EndIf

	If !_lTela
		Reset Environment
	EndIf

Return()

/*====================================================================================\
|Programa  | STFAT372        | Autor | RENATO.OLIVEIRA           | Data | 26/03/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT372()

_cQry := "UPDATE "+RetSqlName("SA1")+" SET A1_XDTENVP=' ' WHERE D_E_L_E_T_=' ' AND A1_XDTENVP<>' '
TcSqlExec(_cQry)
MsgAlert("Limpeza finalizada, obrigado!")

Return()

User Function STFAT374()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _nX 	   := 0

	RpcSetType( 3 )
	RpcSetEnv( "11", "01" ,,,"FAT")

	ConOut(CRLF + "[STFAT374]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_nX := GetMv("STFAT3703",,11) //Número de disparos simultaneos

	_cAlias1 := GetNextAlias()

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	_cQuery1 := " SELECT A1_COD, A1_LOJA
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' '
	_cQuery1 += " AND A1_XENVTBP='S' AND A1_XENVTBE<>' ' AND A1_XDTENVP=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		Sleep(20000) //aguardar alguns segundos para dar tempo de chamar o job antes de começar o proximo cliente

		aInfo := GetUserInfoArray()

		If Len(aInfo)>=_nX
			Return()
		EndIf

		If SA1->(DbSeek(xFilial("SA1")+(_cAlias1)->(A1_COD+A1_LOJA)))
			StartJob("U_STFAT373",GetEnvServer(),.F.,SA1->A1_COD,SA1->A1_LOJA)
		EndIf

		(_cAlias1)->(DbSkip())

	EndDo

	ConOut(CRLF + "[STFAT374]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

User Function STFAT373(_cCliente,_cLoja,_cLockBy)

	Private oExcel := FwMsExcelXlsx():New()

	RpcSetType( 3 )
	RpcSetEnv( "11", "01" ,,,"FAT")

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))

			_cLockBy := "ST"+SA1->A1_COD+SA1->A1_LOJA

			If !LockByName(_cLockBy,.F.,.F.,.F.)	
				ConOut(CRLF + "[STFAT373]["+ FWTimeStamp(2) +"] Já está rodando --> "+_cLockBy)			
				Return()
			EndIf

			_aAreaSA1 := SA1->(GetArea())
			_cArq := U_RSTFAT08()
			RestArea(_aAreaSA1)
			If SA1->A1_XEDI=="S" //Gera preços EDI e envia para única
				U_RSTFATDG(oExcel)
			EndIf
			RestArea(_aAreaSA1)

			If GetMv("STFAT3704",,.T.)
				_cEmail := AllTrim(SA1->A1_XENVTBE)
			Else
				_cEmail := Alltrim(GetMv("STFAT3701",,""))
			EndIf

			_aAttach    := {}
			_cCopia 	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_EMAIL"))
			_cCopia 	+= ";"+Alltrim(GetMv("STFAT3705",,"renato.oliveira@steck.com.br"))
			_cAssunto   := "[WFPROTHEUS] - Lista de preços Steck - "+Alltrim(SA1->A1_NOME)
			cMsg		:= ""
			aadd( _aAttach  , _cArq )
			_cCaminho := "\arquivos\listaprecos\"

			cMsg := '<html><head><title>stkSales</title></head>
			cMsg += '<body>
			cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
			cMsg += '<br><br>Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
			cMsg += 'Você está recebendo a lista de preços da da Steck!<br>
			cMsg += 'Qualquer dúvida entre em contato com os nossos vendedores.<br>'
			cMsg += 'Obrigado!<br><br>'
			cMsg += 'Atenciosamente,<br>
			cMsg += 'Steck Indústria Elétrica Ltda
			cMsg += '</body></html>'

			If GetMv("STFAT3706",,.F.)
				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			EndIf

			SA1->(RecLock("SA1",.F.))
			SA1->A1_XDTENVP := Date()
			SA1->(MsUnLock())

			UnLockByName(_cLockBy,.F.,.F.,.F.)

			EndIf

Return()
