#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT420        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
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

User Function STFAT420()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STFAT420",.F.,.F.,.T.)
		ConOut("[STFAT420]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT420]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A1_NOME, C6_ITEM, 
	_cQuery1 += " C6_PRODUTO, B1_DESC, C6_QTDVEN, C6_VALOR
	_cQuery1 += " FROM "+RetSqlName("SUA")+" UA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=UA_CLIENTE AND A1_LOJA=UA_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
	_cQuery1 += " ON C5_FILIAL=UA_FILIAL AND C5_NUM=UA_NUMSC5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON C6_PRODUTO=B1_COD
	_cQuery1 += " WHERE UA.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '  
	_cQuery1 += " AND UA_FILIAL='02' AND C5_EMISSAO='"+DTOS(Date()-1)+"'
	_cQuery1 += " AND UA_XORIG='1' 
	_cQuery1 += " AND A1_GRPVEN='F1' 
	_cQuery1 += " ORDER BY C5_NUM, C6_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cEmail   := GetMv("STFAT42001",.F.,"renato.oliveira@steck.com.br;daniel.santos@steck.com.br;sandra.gregorio@steck.com.br")
	_cCopia	  := ""
	_cAssunto := "[WFPROTHEUS] - Pedidos de funcionários
	_aAttach  := {}
	_cCaminho := ""

	If (_cAlias1)->(!Eof())

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#3bd245><B>
		cMsg += '<TD>Pedido</TD><TD>Emissão</TD><TD>Cliente</TD><TD>Loja</TD><TD>Nome</TD><TD>Item</TD>
		cMsg += '<TD>Produto</TD><TD>Descrição</TD><TD>Qtde</TD><TD>Valor</TD>
		cMsg += '</B></TR>'

			While (_cAlias1)->(!Eof())

			cMsg += '<TR BgColor=#ffffff>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->C5_NUM)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+DTOC(STOD((_cAlias1)->C5_EMISSAO))+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->C5_CLIENTE)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->C5_LOJACLI)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->A1_NOME)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->C6_ITEM)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->C6_PRODUTO)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+AllTrim((_cAlias1)->B1_DESC)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+cValToChar((_cAlias1)->C6_QTDVEN)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+cValToChar((_cAlias1)->C6_VALOR)+'</Font></TD>'
			cMsg += '</TR>'
		
			(_cAlias1)->(DbSkip())
			EndDo

		cMsg += '</Table>'
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf

	UnLockByName("STFAT420",.F.,.F.,.T.)
	
	ConOut("[STFAT420]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment
	
Return()
