#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"


/*====================================================================================\
|Programa  | STFAT130        | Autor        | RENATO.OLIVEIRA    | Data | 15/05/2019  |
|Programa  | STFAT130        | Adaptado por | FLÁVIA ROCHA       | Data | 16/11/2021  |
|=====================================================================================|
|Descrição | Enviar wf de romaneios parados				                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//FR - 16/11/2021 - Ticket #20210817016002 - CRIAR WF Para Romaneios da Braspress

User Function STFAT130()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	//Local cNewEmp  := "01"
	//Local cNewFil  := "02"
	Local cParTransp := "" 
	Local cPlaca     := ""


	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	cParTransp := GetNewPar("STFAT130" , "004064" ) //código da Braspress

	SA4->(OrdSetFocus(1)) //A4_FILIAL + A4_COD
	If SA4->(Dbseek(xFilial("SA4") + cParTransp))
		cPlaca := UPPER(Alltrim(SA4->A4_NREDUZ)) //"BRASPRESS"
	Endif 

	_cQuery1 := " SELECT PD1_CODROM, PD1_DTEMIS, PD1_HRROM, PD1_PLACA, PD1_QTDVOL, PD1_PBRUTO, COUNT(PD2_NFS) QTDNOTAS, PD1_STATUS " + CRLF
	_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1 " + CRLF
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2 " + CRLF
	_cQuery1 += " ON PD1_FILIAL= PD2_FILIAL AND PD1_CODROM=PD2_CODROM " + CRLF
	_cQuery1 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '  " + CRLF
	//_cQuery1 += " AND PD1_FILIAL='02' AND PD1_STATUS IN ('0','1') AND PD1_PLACA='TNT'

	//FR - 16/11/2021 - Ticket #20210817016002 - CRIAR WF Para Romaneios da Braspress
	_cQuery1 += " AND PD1_FILIAL = '" + xFilial("PD1") + "' " + CRLF
	_cQuery1 += " AND PD1_STATUS IN ('0','1') "  + CRLF
	If !Empty(cPlaca)
		_cQuery1 += " AND ( PD1_PLACA = '" + cPlaca + "' OR PD1_PLACA LIKE '" + Substr(cPlaca,1,8)+"%' )" +  CRLF
	Else 
		_cQuery1 += " AND (PD1_PLACA = 'BRASPRESS' OR PD1_PLACA LIKE 'BRASPRES%' ) "+CRLF
	Endif 

	_cQuery1 += " GROUP BY PD1_CODROM, PD1_DTEMIS, PD1_HRROM, PD1_PLACA, PD1_QTDVOL, PD1_PBRUTO, PD1_STATUS "+CRLF
	_cQuery1 += " ORDER BY PD1_CODROM DESC "

	//MemoWrite("D:\QUERY\STFAT130.SQL" , _cQuery1)

	_cQuery1 := ChangeQuery(_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cEmail	  := GetNewPar("STFAT1301","wellington.gamas@steck.com.br;francisco.smania@steck.com.br;vanessa.bezerra@steck.com.br;raphaella.silva@steck.com.br;expedição.steck@steck.com.br")
		//_cEmail	  := "wellington.gamas@steck.com.br;francisco.smania@steck.com.br;vanessa.bezerra@steck.com.br;raphaella.silva@steck.com.br"  //FR TESTE RETIRAR
		_cCopia   := "flah.rocha@sigamat.com.br;flah.rocha@gmail.com"  //FR TESTE RETIRAR

		If !Empty(cPlaca)
			_cAssunto := "[WFPROTHEUS] - Romaneios " + cPlaca + "  não iniciados"
		Else 
			_cAssunto := "[WFPROTHEUS] - Romaneios BRASPRESS  não iniciados"
		Endif 
		_aAttach  := {}
		_cCaminho := ""

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'

		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Cod.Romaneio</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Dt.Emissão</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Hr Romaneio</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Sts Romaneio</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Placa Veículo</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Qtde volumes</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Peso bruto</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Qtde notas</Font></B></TD>'
		cMsg += '</TR>'

		While (_cAlias1)->(!Eof())

			cMsg += '<TR BgColor=#66FF66>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD1_CODROM+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+DTOC(STOD((_cAlias1)->PD1_DTEMIS))+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD1_HRROM+'</Font></B></TD>'

			_cStatus := ""
			Do Case
				Case AllTrim((_cAlias1)->PD1_STATUS)=="0"
				_cStatus := "Não iniciado"
				Case AllTrim((_cAlias1)->PD1_STATUS)=="1"
				_cStatus := "Em andamento"
			EndCase

			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_cStatus+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD1_PLACA+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->PD1_QTDVOL)+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->PD1_PBRUTO)+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->QTDNOTAS)+'</Font></B></TD>'
			cMsg += '</TR>'

			(_cAlias1)->(DbSkip())
		EndDo

		cMsg += '</Table>'
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		//FRSendMail(_cEmail, _cCopia, _cAssunto, cMsg, "" )  //FR - TESTE RETIRAR

		(_cAlias1)->(DbSkip())
	EndDo

Return()


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
