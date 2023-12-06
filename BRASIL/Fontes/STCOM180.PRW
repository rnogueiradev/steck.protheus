#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM180        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
|=====================================================================================|
|Descrição | Enviar wf pedidos APU						                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM180()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "02"

	Reset Environment

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cQuery1 := " SELECT DISTINCT C7_FILIAL, C7_NUM
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" A2
	_cQuery1 += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '  
	_cQuery1 += " AND C7_MOTIVO='APU' AND C7_QUANT<>C7_QUJE AND C7_DATPRF='"+DTOS(Date())+"'
	_cQuery1 += " ORDER BY C7_FILIAL, C7_NUM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cEmail	  := GetMv("STCOM1801",,"renato.oliveira@steck.com.br;ulisses.almeida@steck.com.br;alex.lourenco@steck.com.br;ronaldo.fortunato@steck.com.br")

	While (_cAlias1)->(!Eof())

		_cCopia   := (_cAlias1)->A2_EMAIL
		_cAssunto := "[WFPROTHEUS] - Pedido de compra "+(_cAlias1)->C7_NUM+" com entrega na data de hoje
		_aAttach  := {}
		_cCaminho := ""

		_cQuery2 := " SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_FORNECE, C7_LOJA, A2_NOME, A2_EMAIL
		_cQuery2 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery2 += " LEFT JOIN "+RetSqlName("SA2")+" A2
		_cQuery2 += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA
		_cQuery2 += " WHERE C7.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '  
		_cQuery2 += " AND C7_FILIAL='"+(_cAlias1)->C7_FILIAL+"' AND C7_NUM='"+(_cAlias1)->C7_NUM+"'
		_cQuery2 += " ORDER BY C7_ITEM


		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Filial</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Pedido</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Fornecedor</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Loja</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Nome</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Código</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
		cMsg += '</TR>'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		While (_cAlias2)->(!Eof())

			cMsg += '<TR BgColor=#66FF66>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_FILIAL+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_NUM+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_FORNECE+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_LOJA+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->A2_NOME+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_ITEM+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_PRODUTO+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C7_DESCRI+'</Font></B></TD>'
			cMsg += '</TR>'

			(_cAlias2)->(DbSkip())
		EndDo

		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		(_cAlias1)->(DbSkip())
	EndDo

Return()