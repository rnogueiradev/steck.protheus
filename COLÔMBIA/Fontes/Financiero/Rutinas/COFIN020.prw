#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STFIN020         | Autor | RENATO.OLIVEIRA          | Data | 12/12/2019  |
|=====================================================================================|
|Descrição | Fonte para integar com o MyDso (Schneider)                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User Function COFIN020()

	Local _cQuery1  := "" 
	Local _cAlias1  := ""
	Local _cAlias2  := ""
	Local cNewEmp 	:= "09"
	Local cNewFil	:= "01"
	Local _cItems   := ""
	Local _cClients := ""
	Local cDir		:= ""
	Local _aEmpStk  := {}
	Local _cEmpStk	:= ""
	Local _nX

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil ,,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	//FR - 07/12/20220 - Ticket #20221006018802 - David Souza disse precisa excluir do extrator estes clientes Inter Company (Steck)
	//códigos de clientes Steck da Colômbia:
	_aEmpStk := StrTokArr(GetMv("STDSOCLIST",,"8903118751#6048486000114#44415136000138#5890658000210#9013185883"),"#")
	
	For _nX := 1 To Len(_aEmpStk)
		_cEmpStk += "'" + AllTrim(_aEmpStk[_nX]) + "'"
		If !(_nX == Len(_aEmpStk))
			_cEmpStk += ","
		EndIf
	Next

	ConOut(CRLF + "[STFIN020][" + FWTimeStamp(2) + "] Inicio do processamento.")

	cDir := GetMv("STMYDSO",,"\arquivos\mydso\")

	cServer := GetMv("STDSOFTP1",,"schneider.mydsomanager.com")
	nPorta  := GetMv("STDSOFTP2",,21)
	cUser   := GetMv("STDSOFTP3",,"c90ee6d287b61d6e34b6c209506a9d7e")
	cPass	:= GetMv("STDSOFTP4",,"dc69f330f8c2c9ef81fc9574c405a235")

	//Exportar títulos em aberto
	_cQuery1 := " SELECT E1_CLIENTE CLIENTE,
	_cQuery1 += " 	E1_VALOR,
	_cQuery1 += " 	E1_SALDO,
	_cQuery1 += " 	E1_MOEDA,
	_cQuery1 += " 	E1_VENCREA,
	_cQuery1 += " 	E1_EMISSAO,
	_cQuery1 += " 	E1_TIPO,
	_cQuery1 += " 	E1_NUMBCO,
	_cQuery1 += " 	E1_FILIAL||E1_PREFIXO||E1_NUM||E1_PARCELA NUMERO,
	_cQuery1 += " 	E1_PEDIDO,
	_cQuery1 += " 	E1_TIPO, 
	_cQuery1 += " 	E1_PARCELA
	_cQuery1 += " FROM " + RetSqlName("SE1") + " E1
	_cQuery1 += " LEFT JOIN " + RetSqlName("SA1") + " A1
	_cQuery1 += " 	ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_ = ' '
	_cQuery1 += " 	AND A1.A1_COD NOT IN (" + _cEmpStk + ") "

	_cQuery1 += " WHERE E1.D_E_L_E_T_ = ' ' 
	_cQuery1 += " 	AND E1_FILIAL = '" + cNewFil + "' 
	_cQuery1 += " 	AND E1_SALDO > 0
	_cQuery1 += " 	AND A1_TIPO NOT IN ('X')
	_cQuery1 += " 	AND E1_TIPO IN ('NCC','NF','RA')
	_cQuery1 += " 	AND E1_CLIENTE NOT IN (" + _cEmpStk + ") "
	_cQuery1 += "  ORDER BY E1_CLIENTE, E1_LOJA "

	MemoWrite("C:\QUERY\COL_ITEMS.TXT" , _cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->( dbGoTop() )

	_cItems := '"client_code";
	_cItems += '"item_amount_initial_inc_tax";
	_cItems += '"item_amount_remaining_inc_tax";
	_cItems += '"item_currency";
	_cItems += '"item_date_due";
	_cItems += '"item_date_issue";
	_cItems += '"item_erp_type";
	_cItems += '"item_file_number";
	_cItems += '"item_number";
	_cItems += '"item_order_number";
	_cItems += '"item_type";
	_cItems += CHR(13) + CHR(10)

	While (_cAlias1)->( !Eof() )
		_cNegat := ""
		If AllTrim((_cAlias1)->E1_TIPO) $ "NCC#RA" //Negativos
			_cNegat := "-"
		EndIf
		_cItems += '"' + AllTrim((_cAlias1)->CLIENTE) + '";'
		_cItems += '"' + _cNegat+cValToChar((_cAlias1)->E1_VALOR) + '";'
		_cItems += '"' + _cNegat+cValToChar((_cAlias1)->E1_SALDO) + '";'
		_cItems += '"' + GetMoeda((_cAlias1)->E1_MOEDA) + '";'
		_cItems += '"' + (_cAlias1)->E1_VENCREA + '";'
		_cItems += '"' + (_cAlias1)->E1_EMISSAO + '";'
		_cItems += '"' + AllTrim((_cAlias1)->E1_TIPO) + '";'
		_cItems += '"' + AllTrim((_cAlias1)->E1_NUMBCO) + '";'
		_cNumero := AllTrim((_cAlias1)->NUMERO)
		If Empty((_cAlias1)->E1_PARCELA)
			_cNumero := _cNumero + "AAA"
		EndIf
		_cItems += '"' + _cNumero + '";'
		_cItems += '"' + AllTrim((_cAlias1)->E1_PEDIDO) + '";'
		_cItems += '"' + AllTrim((_cAlias1)->E1_TIPO) + '";'
		_cItems += CHR(13) + CHR(10)
		(_cAlias1)->( dbSkip() )
	EndDo

	_cArqItems  := "items_" + Dtos(Date()) + ".txt"    // Removido col_ por estar apresentando problemas - Valdemir Rabelo 04/01/2023
	_cItems 	:= EncodeUtf8(_cItems)
	_cFile 		:= cDir + _cArqItems

	If File(_cFile)
		FErase(_cFile)
	EndIf

	nHdlXml	:= FCreate(_cFile,0)

	If nHdlXml > 0
		FWrite(nHdlXml,_cItems)
		FClose(nHdlXml)
	EndIf

	//para testes
	/*
	_cEmail := "flah.rocha@sigamat.com.br;flah.rocha@gmail.com"
	_cCopia := "" 
	_cAssunto := "MYDSO - COLÔMBIA"
	cMsg      := "MYDSO - COLÔMBIA"
	cAnexo    := _cFile

	lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
	MemoWrite("C:\TEMP\"+_cArqItems, _cItems)
	*/
	//para testes


	//Exportar clientes
	_cQuery1 := " SELECT DISTINCT A1.R_E_C_N_O_ RECSA1, "
	_cQuery1 += " 	A1.A1_MUN, "
	_cQuery1 += " 	A1.A1_PAIS, "
	_cQuery1 += " 	A1.A1_EST, "
	_cQuery1 += " 	A1.A1_END, "
	_cQuery1 += " 	A1.A1_CEP, "
	_cQuery1 += " 	A1.A1_MSBLQL, "
	_cQuery1 += " 	A1.A1_NOME, "
	_cQuery1 += " 	A1.A1_COD CLIENTE, "
	_cQuery1 += " 	A3_EMAIL, "
	_cQuery1 += " 	A3_NOME, "
	_cQuery1 += " 	A3_DDD||A3_TEL TEL1, "
	_cQuery1 += " 	A1M.A1_LC, "
	_cQuery1 += " 	A1.A1_EMAIL, "
	_cQuery1 += " 	' ' A1_XSEGVAL, "
	_cQuery1 += " 	A1.A1_RISCO, "
	_cQuery1 += " 	A1.A1_CGC, "
	_cQuery1 += " 	A1.A1_SALPED, "
	_cQuery1 += " 	A1.A1_COND, "
	_cQuery1 += " 	A1.A1_TEL TEL2, "
	_cQuery1 += " 	A1.A1_NREDUZ, "
	_cQuery1 += " 	A1.A1_HPAGE, "
	_cQuery1 += " 	' ' A1_XCOBRAD, "
	_cQuery1 += " 	RTRIM(A1.A1_GRPVEN)||'-'||ACY_DESCRI A1_GRPVEN, "
	_cQuery1 += " 	(CASE WHEN A1.A1_RISCO = 'A' THEN 'A-OTIMO' WHEN A1.A1_RISCO = 'B' THEN 'B-BOM' WHEN A1.A1_RISCO = 'C' THEN 'C-LEGAL'  "
	_cQuery1 += " 	WHEN A1.A1_RISCO = 'D' THEN 'D-REGULAR' WHEN A1.A1_RISCO = 'E' THEN 'E-ATENCAO' END) DESCRISK, "
	_cQuery1 += " 	A1.A1_OBSERV, "
	_cQuery1 += " 	A1.A1_VENCLC, "
	_cQuery1 += " 	' ' A1_XAVSEML, "
	_cQuery1 += " 	' ' A1_XBLOQF "
	_cQuery1 += " FROM " + RetSqlName("SE1") + " E1 "
	_cQuery1 += " LEFT JOIN " + RetSqlName("SA1") + " A1 "
	_cQuery1 += " 	ON A1.A1_COD = E1_CLIENTE AND A1.A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_ = ' ' "
	_cQuery1 += " 	AND A1.A1_COD NOT IN (" + _cEmpStk + ") "

	_cQuery1 += " LEFT JOIN " + RetSqlName("SA3") + " A3 "
	_cQuery1 += " 	ON A3_COD = A1.A1_VEND AND A3.D_E_L_E_T_ = ' ' "
//	_cQuery1 += " LEFT JOIN " + RetSqlName("CCH") + " CCH
//	_cQuery1 += " 	ON CCH_CODIGO = A1.A1_CODPAIS AND CCH.D_E_L_E_T_ = ' '
	_cQuery1 += " LEFT JOIN " + RetSqlName("ACY") + " ACY  "
	_cQuery1 += " 	ON ACY_GRPVEN = A1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' '  "
	_cQuery1 += " LEFT JOIN " + RetSqlName("SA1") + " A1M "
	_cQuery1 += " 	ON A1M.A1_COD = E1_CLIENTE AND A1M.A1_LOJA = '01' AND A1M.D_E_L_E_T_ = ' '  "
	_cQuery1 += " WHERE E1.D_E_L_E_T_ = ' ' "
	_cQuery1 += " 	AND E1_FILIAL = '" + cNewFil + "' "
	_cQuery1 += " 	AND E1_SALDO > 0 "
	_cQuery1 += " 	AND A1.A1_TIPO NOT IN ('X') "
	_cQuery1 += " 	AND E1_CLIENTE NOT IN (" + _cEmpStk + ") "

	MemoWrite("C:\QUERY\COL_CLIENTS.TXT" , _cQuery1)

	If !Empty(Select(_cAlias1))
		dbSelectArea(_cAlias1)
		(_cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->( dbGoTop() )

	_cClients := '"client_address_city";
	_cClients += '"client_address_country";
	_cClients += '"client_address_state";
	_cClients += '"client_address_street";
	_cClients += '"client_address_zip";
	_cClients += '"client_blocked";
	_cClients += '"client_business_name";
	_cClients += '"client_code";
	_cClients += '"client_comments";
	_cClients += '"client_commercial_email";
	_cClients += '"client_commercial_firstname";
	_cClients += '"client_commercial_phone";
	_cClients += '"client_credit_limit";
	_cClients += '"client_email";
	_cClients += '"client_guarantee_insurer";
	_cClients += '"client_guarantee_score";
	_cClients += '"client_id";
	_cClients += '"client_order_backlog";
	_cClients += '"client_payment_term";
	_cClients += '"client_phone";
	_cClients += '"client_trading_name";
	_cClients += '"client_url";
	_cClients += '"legal_id";
	_cClients += '"vat_number";
	_cClients += '"collector";
	_cClients += '"group";
	_cClients += '"risk_cat";
	_cClients += '"info";
	_cClients += '"next_internal_review";
	_cClients += '"email";
	_cClients += '"fone";
	_cClients += CHR(13) + CHR(10)

	dbSelectArea("SA1")

	While (_cAlias1)->( !Eof() )
		// SA1->( dbGoTo((_cAlias1)->RECSA1) )
		_cClients += '"' + AllTrim((_cAlias1)->A1_MUN) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_PAIS) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_EST) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_END) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_CEP) + '";'
		//_cClients += '"' + AllTrim(IIF((_cAlias1)->A1_XBLOQF=="B","1","0")) + '";'
		/****************************************************
		Ação............: Tratamento tratamento para clientes bloqueados
		................: Quando o Cliente estiver bloqueado no sistema retorna "1", liberado "0"
		Desenvolvedor...: Marcelo Klopfer Leme
		Data............: 10/08/2022
		Chamado.........: 20220809015472
		****************************************************/
		IF AllTrim((_cAlias1)->A1_MSBLQL) <> "1"
			//_cClients += '"1";'
			_cClients += '"0";'		//FR - 07/12/20220 - Ticket #20221006018802 - David Souza disse que precisa ser 0 
		ELSE
			//_cClients += '"0";'
			_cClients += '"1";'		//FR - 07/12/20220 - Ticket #20221006018802
		ENDIF		
		_cClients += '"' + AllTrim((_cAlias1)->A1_NOME) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->CLIENTE) + '";'
		_cClients += '"";'
		_cClients += '"' + AllTrim(GetEmail((_cAlias1)->A3_EMAIL)) + '";'
		_cClients += '"' + AllTrim(StrTran((_cAlias1)->A3_NOME,"GENERICO - ")) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->TEL1) + '";'
		_cClients += '"' + cValToChar((_cAlias1)->A1_LC) + '";'
		_cClients += '"' + AllTrim(GetEmail((_cAlias1)->A1_EMAIL)) + '";'
		_cClients += '"' + cValToChar((_cAlias1)->A1_XSEGVAL) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_RISCO) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_CGC) + '";'
		_cClients += '"' + cValToChar((_cAlias1)->A1_SALPED) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_COND) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->TEL2) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_NREDUZ) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_HPAGE) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->CLIENTE) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_CGC) + '";'
		_cClients += '"' + AllTrim(StrTran((_cAlias1)->A1_XCOBRAD,"."," ")) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_GRPVEN) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->DESCRISK) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->A1_OBSERV) + '";'
		_cClients += '"' + (_cAlias1)->A1_VENCLC + '";'
		_cClients += '"' + AllTrim(GetEmail((_cAlias1)->A1_XAVSEML)) + '";'
		_cClients += '"' + AllTrim((_cAlias1)->TEL2) + '";'
		_cClients += CHR(13) + CHR(10)
		(_cAlias1)->( dbSkip() )
	EndDo

	_cArqClient := "clients_" + Dtos(Date()) + ".txt"      // Removido col_ por estar apresentando problemas - Valdemir Rabelo 04/01/2023
	_cClients 	:= EncodeUtf8(_cClients)
	_cFile 		:= cDir + _cArqClient

	If File(_cFile)
		FErase(_cFile)
	EndIf

	nHdlXml	:= FCreate(_cFile,0)

	If nHdlXml > 0
		FWrite(nHdlXml,_cClients)
		FClose(nHdlXml)
	EndIf

	//para testes
	/*
	_cEmail := "flah.rocha@sigamat.com.br;flah.rocha@gmail.com"
	_cCopia := "" 
	_cAssunto := "MYDSO - COLÔMBIA"
	cMsg      := "MYDSO - COLÔMBIA"
	cAnexo    := _cFile

	lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
	MemoWrite("C:\TEMP\"+_cArqClient, _cClients)
	*/
	//para testes


	ConOut(CRLF + "[STFIN020]["+ FWTimeStamp(2) +"] Fim do processamento.")

	Reset Environment

Return

/*/Protheus.doc GetEmail
@name GetEmail
@desc ajusta email
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GetEmail(_cEmail)

	Local _cRet := ""

	Local _nCont := ""

	_nCont := At(";",_cEmail)-1

	If _nCont > 0
	_cRet := SubStr(_cEmail,1,_nCont)
	else
	_cRet := _cEmail
	EndIf

Return _cRet

/*/Protheus.doc GetMoeda
@name GetMoeda
@desc devolve descrição da moeda
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GetMoeda(_nMoeda)

	Do Case
		Case _nMoeda == 1
			_cRet := "COP"
		Case _nMoeda == 2
			_cRet := "USD"
		Case _nMoeda == 3
			_cRet := "UFIR"
		Case _nMoeda == 4
			_cRet := "EUR"
	EndCase

Return _cRet


//FUNÇÃO PARA TESTES APENAS
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


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

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
