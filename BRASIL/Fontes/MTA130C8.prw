#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)

/*====================================================================================\
|Programa  | MTA130C8        | Autor | Robson Mazzarott           | Data | 06/02/2018 |
|=====================================================================================|
|Descrição | MTA130C8                                                                 |
|          | Envia WorkFlow de informação para o fornecedor entrar no portal          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MTA130C8                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MTA130C8(_lJob)

	Local _aAreaSC8 := SC8->(GetArea())
	Local _aArea    := GetArea()
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local _aAttach  := {}
	Local _cCaminho := ""
	Local _cQuery1  := ""
	Local _cAlias1  := "MTA130C8001"
	Local _cQuery2  := ""
	Local _cAlias2  := "MTA130C8002"
	Local _nDias 	:= SuperGetMv("ST_COM0001",.F.,5)
	Default _lJob   := .F.

	// Robson Mazzarotto - 06/02/2018 -  Envio de cotação para os Fornecedores preencherem pelo portal.

	_cEmail := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_EMAIL")
	//_cCopia := SuperGetMv("ST_COM0003",.F.,"fernando.torres@steck.com.br;renato.oliveira@steck.com.br;susan.paiva@steck.com.br")

	_cQuery2 := " SELECT DISTINCT Y1_EMAIL
	_cQuery2 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery2 += " LEFT JOIN "+RetSqlName("SC1")+" C1
	_cQuery2 += " ON C1_FILIAL=C8_FILIAL AND C1_NUM=C8_NUMSC AND C1_ITEM=C8_ITEMSC
	_cQuery2 += " LEFT JOIN "+RetSqlName("SY1")+" Y1
	_cQuery2 += " ON Y1_COD=C1_CODCOMP
	_cQuery2 += " WHERE C8.D_E_L_E_T_=' ' AND C1.D_E_L_E_T_=' ' AND Y1.D_E_L_E_T_=' '
	_cQuery2 += " AND C8.R_E_C_N_O_="+CVALTOCHAR(SC8->(Recno()))

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())
		_cCopia := (_cAlias2)->Y1_EMAIL
	EndIf

	_cCopia += ";"+AllTrim(SuperGetMv("ST_COM0004",.F.,""))

	_cAssunto:= '[STECK] - Processo de Cotação No. '+SC8->C8_NUM

	cMsg := ' <html><head><title>Cotação - Steck</title></head>
	cMsg += ' <body>
	cMsg += ' <img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
	cMsg += ' <br><font size="5" color=#ff0000>Processo de Cotação No. <b>'+SC8->C8_NUM+'</b></font>
	cMsg += ' <br><br>
	cMsg += ' <font size="3" face="Arial" size="4" bgcolor=#afeeee background="">
	cMsg += ' Você está participando do processo de cotação da STECK.<br>
	cMsg += ' Empresa: '+AllTrim(SA2->A2_NOME)+'<br>Login: '+SA2->A2_CGC+'<br>
	cMsg += ' Você pode cadastrar os preços para essa cotação até o dia '+DTOC(Date()+_nDias)+'<br>'

	U_STCOMA21("","",.F.,SC8->C8_FORNECE,SC8->C8_LOJA)  //Verifica se o fornecedor já está criado

	_cQuery1 := " SELECT AI3_PSW, AI5_CODFOR, AI5_LOJFOR
	_cQuery1 += " FROM "+RetSqlName("AI3")+" AI3
	_cQuery1 += " LEFT JOIN "+RetSqlName("AI5")+" AI5
	_cQuery1 += " ON AI3_FILIAL=AI5_FILIAL AND AI3_CODUSU=AI5_CODUSU
	_cQuery1 += " WHERE AI3.D_E_L_E_T_=' ' AND AI5.D_E_L_E_T_=' '
	_cQuery1 += " AND AI5_CODFOR='"+SC8->C8_FORNECE+"' AND AI5_LOJFOR='"+SC8->C8_LOJA+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		If AllTrim((_cAlias1)->AI3_PSW)==AllTrim((_cAlias1)->(AI5_CODFOR+AI5_LOJFOR))
			cMsg += '<b>Sua senha de acesso inicial é <u>'+AllTrim((_cAlias1)->AI3_PSW)+'</u>, favor alterar a senha após realizar o login.</b><br>
		EndIf
	EndIf

	cMsg += ' Pedimos a gentileza de entrar no portal
	cMsg += ' clicando no link abaixo para preencher as informações da cotação.
	cMsg += ' </font><br><br>
	/*
	If SM0->M0_CODIGO=="01"
	Do Case
	Case SC8->C8_FILIAL=="01"
	cMsg += ' <a href="http://200.171.223.154:8352/sp01/w_pwsx010.apw">Clique aqui para acessar o portal</a>
	Case SC8->C8_FILIAL=="02"
	cMsg += ' <a href="http://200.171.223.154:8354/sp02/w_pwsx010.apw">Clique aqui para acessar o portal</a>
	Case SC8->C8_FILIAL=="03"
	cMsg += ' <a href="http://200.171.223.154:8355/sp03/w_pwsx010.apw">Clique aqui para acessar o portal</a>
	Case SC8->C8_FILIAL=="04"
	cMsg += ' <a href="http://200.171.223.154:8356/sp04/w_pwsx010.apw">Clique aqui para acessar o portal</a>
	EndCase
	ElseIf SM0->M0_CODIGO=="03"
	cMsg += ' <a href="http://200.171.223.154:8353/am/w_pwsx010.apw">Clique aqui para acessar o portal</a>
	EndIf
	*/

	If SM0->M0_CODIGO=="01" .Or. SM0->M0_CODIGO=="11"
		_cEmpresa := "São Paulo / Filial "+SC8->C8_FILIAL
	Else
		_cEmpresa := "Manaus / Filial "+SC8->C8_FILIAL
	EndIf

	cMsg += ' Empresa: <b>'+_cEmpresa+'</b><br>'
	cMsg += ' <a href="https://portalfornecedor.steck.com.br/login.php">Clique aqui para acessar o portal</a>

	//cMsg += ' <br>
	//cMsg += ' <br>
	//cMsg += ' <a href="http://steck.hospedagemdesites.ws/manual_fornecedor.pdf">Clique aqui para baixar o manual</a>
	cMsg += ' <br><br>
	cMsg += ' <font size="3" face="Arial" size="4" bgcolor=#afeeee background="">
	cMsg += ' <b>Muito obrigado!</b>
	cMsg += ' </font><br><br>
	cMsg += ' Esta é uma mensagem automática. Por favor, não responda este e-mail

	_cQuery1 := " SELECT COUNT(*) CONTADOR
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	//_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+SC8->C8_FILIAL+"'
	_cQuery1 += " WHERE C8_FILIAL='"+SC8->C8_FILIAL+"'" //Retirado o delet para não enviar 2x
	_cQuery1 += " AND C8_NUM='"+SC8->C8_NUM+"' AND C8_FORNECE='"+SC8->C8_FORNECE+"'
	_cQuery1 += " AND C8_LOJA='"+SC8->C8_LOJA+"' AND C8_XENVMAI='S'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->CONTADOR==0

		//_cCopia += ";renato.oliveira@steck.com.br

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			Conout("Problemas no envio de email!"+" - Cotação: "+SC8->C8_NUM)
		Else
			SC8->(RecLock("SC8",.F.))
			SC8->C8_XENVMAI := "S"
			SC8->(MsUnLock())
		EndIf

	Else

		_cQuery7 := " UPDATE "+RetSqlName("SC8")+" C8
		_cQuery7 += " SET C8.C8_XENVMAI='S'
		_cQuery7 += " WHERE C8.C8_FILIAL='"+SC8->C8_FILIAL+"'"
		_cQuery7 += " AND C8.C8_NUM='"+SC8->C8_NUM+"' AND C8.C8_FORNECE='"+SC8->C8_FORNECE+"'
		_cQuery7 += " AND C8.C8_LOJA='"+SC8->C8_LOJA+"'

		TcSqlExec(_cQuery7)

	EndIf

	//_cFilial	:= SC8->C8_FILIAL
	//_cNum 		:= SC8->C8_NUM

	//SC8->(DbSetOrder(1))
	//SC8->(DbGoTop())
	//SC8->(DbSeek(_cFilial+_cNum))

	//While SC8->(!Eof()) .And. SC8->(C8_FILIAL+C8_NUM)==_cFilial+_cNum

	If !_lJob
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
	EndIf

	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+SC8->C8_PRODUTO))

		SC8->(RecLock("SC8",.F.))
		SC8->C8_XDESENH := SB1->B1_XDESENH
		SC8->(MsUnLock())

	EndIf

	//SC8->(DbSkip())
	//EndDo

	SC8->(RecLock("SC8",.F.))
	SC8->C8_VALIDA 	:= Date()+_nDias
	SC8->C8_XENDENT	:= AllTrim(SM0->M0_ENDENT)
	SC8->C8_XCIDENT := AllTrim(SM0->M0_CIDENT)
	SC8->C8_XNOMENT := AllTrim(SM0->M0_NOME)+" - "+AllTrim(SM0->M0_FILIAL)
	SC8->C8_XCEPENT := SM0->M0_CEPENT
	SC8->C8_XCGCFOR := SA2->A2_CGC
	SC8->C8_XNOMFOR := SA2->A2_NOME
	SC8->C8_XENDFOR := SA2->A2_END

	If Empty(SC8->C8_TPFRETE)
		SC8->C8_TPFRETE := "C"
	EndIf

	SC8->(MsUnLock())

	If !_lJob
		DbSelectArea("SC1")
		SC1->(DbSetOrder(1)) //C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
	EndIf

	SC1->(DbGoTop())
	If SC1->(DbSeek(SC8->(C8_FILIAL+C8_NUMSC+C8_ITEMSC)))

		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		SZ1->(DbGoTop())
		If SZ1->(DbSeek(xFilial("SZ1")+SC1->C1_MOTIVO))

			If SZ1->Z1_DIASVLD>0
				SC8->(RecLock("SC8",.F.))
				SC8->C8_VALIDA := Date()+SZ1->Z1_DIASVLD
				SC8->(MsUnLock())
			EndIf

		EndIf

	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSC8)

Return

 


