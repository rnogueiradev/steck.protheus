#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTB0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL getAprovacoes DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Buscar aprovações pendentes" WSSYNTAX "/rest/getAprovacoes"

END WSRESTFUL

WSMETHOD POST WSSERVICE getAprovacoes

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cUsuario	:= ""

	ConOut("[STRESTB0]["+ FWTimeStamp(2) +"] - Usuario "+AllTrim(UsrRetName(__cUserId))+" realizou o acesso.")
	ConOut("[STRESTB0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cUsuario := AllTrim(UsrRetName(__cUserId))

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT '01' EMPRESA, C1_FILIAL, C1_NUM, SUM(PRCMED) PRCMED, MAX(C1_OBS) OBS
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS,
	_cQuery1 += " (CASE WHEN PRCMED>0 THEN PRCMED*C1_QUANT ELSE TOTAL END) PRCMED
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS , TOTAL
	_cQuery1 += " ,NVL((
	_cQuery1 += " SELECT AVG(C8_PRECO)
	_cQuery1 += " FROM SC8010 C8
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL=WWW.C1_FILIAL AND C8_PRODUTO=WWW.C1_PRODUTO AND C8_XPORTAL='S' AND C8_PRECO>0
	_cQuery1 += " ),0) PRCMED
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, CASE WHEN C1_OBS=' ' THEN 'SEM OBSERVACAO' ELSE C1_OBS END C1_OBS,
	_cQuery1 += " SUM(C1_QUANT)*SUM(B1_UPRC) TOTAL
	_cQuery1 += " FROM SC1010 C1
	_cQuery1 += " LEFT JOIN SB1010 B1
	_cQuery1 += " ON B1_COD=C1_PRODUTO
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' 
	_cQuery1 += " AND C1_ZSTATUS='3' AND C1_COTACAO=' '
	_cQuery1 += " AND (
	_cQuery1 += " (C1_XAPROV1='"+_cUsuario+"' AND C1_XDTAP1=' ' AND C1_XSTAP1='P')
	_cQuery1 += " OR
	_cQuery1 += " (C1_XAPROV2='"+_cUsuario+"' AND C1_XDTAP2=' ' AND C1_XSTAP2='P')
	_cQuery1 += " )
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS
	_cQuery1 += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM
	_cQuery1 += " ) WWW
	_cQuery1 += " ) ZZZ
	_cQuery1 += " ) AAA
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM
	_cQuery1 += " UNION
	_cQuery1 += " SELECT '03' EMPRESA, C1_FILIAL, C1_NUM, SUM(PRCMED) PRCMED, MAX(C1_OBS) OBS
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS,
	_cQuery1 += " (CASE WHEN PRCMED>0 THEN PRCMED*C1_QUANT ELSE TOTAL END) PRCMED
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS , TOTAL
	_cQuery1 += " ,NVL((
	_cQuery1 += " SELECT AVG(C8_PRECO)
	_cQuery1 += " FROM SC8030 C8
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL=WWW.C1_FILIAL AND C8_PRODUTO=WWW.C1_PRODUTO AND C8_XPORTAL='S' AND C8_PRECO>0
	_cQuery1 += " ),0) PRCMED
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, CASE WHEN C1_OBS=' ' THEN 'SEM OBSERVACAO' ELSE C1_OBS END C1_OBS,
	_cQuery1 += " SUM(C1_QUANT)*SUM(B1_UPRC) TOTAL
	_cQuery1 += " FROM SC1030 C1
	_cQuery1 += " LEFT JOIN SB1030 B1
	_cQuery1 += " ON B1_COD=C1_PRODUTO
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' 
	_cQuery1 += " AND C1_XSTAPRO='P' AND C1_ZSTATUS='3' AND C1_COTACAO=' '
	_cQuery1 += " AND (
	_cQuery1 += " (C1_XAPROV1='"+_cUsuario+"' AND C1_XDTAP1=' ')
	_cQuery1 += " OR
	_cQuery1 += " (C1_XAPROV2='"+_cUsuario+"' AND C1_XDTAP2=' ')
	_cQuery1 += " )
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM, C1_ITEM, C1_QUANT, C1_PRODUTO, C1_OBS
	_cQuery1 += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM
	_cQuery1 += " ) WWW
	_cQuery1 += " ) ZZZ
	_cQuery1 += " ) AAA
	_cQuery1 += " GROUP BY C1_FILIAL, C1_NUM	

	ConOut("[STRESTB0]["+ FWTimeStamp(2) +"] - Resposta: "+_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	cResp := '{
	cResp += '"lista":{

	If (_cAlias1)->(!Eof())

		cResp += '"aprovacoes": [

		While (_cAlias1)->(!Eof())

			cResp += '{
			cResp += '"aprovacao": "'+(_cAlias1)->(EMPRESA+C1_FILIAL)+"_"+(_cAlias1)->C1_NUM+'",
			cResp += '"descricao": "'+AllTrim(U_STTIRAGR((_cAlias1)->OBS))+'",
			cResp += '"valor": "R$ '+AllTrim(CVALTOCHAR(Round((_cAlias1)->PRCMED,2)))+'"'
			cResp += '}

			(_cAlias1)->(DbSkip())

			If (_cAlias1)->(!Eof())
				cResp += ',
			EndIf

		EndDo

		cResp += ']

	EndIf

	cResp += '}}

	ConOut("[STRESTB0]["+ FWTimeStamp(2) +"] - Resposta: "+cResp)

	::SetResponse(cResp)

Return .T.
