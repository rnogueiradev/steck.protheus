#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTE0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL getAprovacao DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Buscar detalhamento da aprovação" WSSYNTAX "/rest/getAprovacao"

END WSRESTFUL

WSMETHOD POST WSSERVICE getAprovacao

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cUsuario	:= ""
	Local cAprovacao:= ""

	ConOut("[STRESTE0]["+ FWTimeStamp(2) +"] - Usuario "+AllTrim(UsrRetName(__cUserId))+" realizou o acesso.")
	ConOut("[STRESTE0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cUsuario := AllTrim(UsrRetName(__cUserId))

	Reset Environment

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp 	:= "ERRO"
		::SetResponse(cResp)
		Return .T.
	EndIf

	cAprovacao := oInfo:INFORMACOES:APROVACAO

	RpcSetType( 3 )
	RpcSetEnv(Substr(cAprovacao,1,2),Substr(cAprovacao,3,2),,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT C1_FILIAL, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_NUM, C1_SOLICIT,
	_cQuery1 += " NVL((SELECT AVG(C8_PRECO)
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL=C1.C1_FILIAL AND C8_PRODUTO=C1.C1_PRODUTO AND C8_XPORTAL='S' AND C8_PRECO>0
	_cQuery1 += " ),0) PRCMED, B1_UPRC
	_cQuery1 += " FROM "+RetSqlName("SC1")+" C1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=C1_PRODUTO
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND C1_FILIAL='"+Substr(cAprovacao,3,2)+"'
	_cQuery1 += " AND C1_NUM='"+Substr(cAprovacao,6,6)+"' AND C1_ZSTATUS='3' AND C1_COTACAO=' '
	_cQuery1 += " AND (
	_cQuery1 += " (C1_XAPROV1='"+_cUsuario+"' AND C1_XDTAP1=' ' AND C1_XSTAP1='P')
	_cQuery1 += " OR
	_cQuery1 += " (C1_XAPROV2='"+_cUsuario+"' AND C1_XDTAP2=' ' AND C1_XSTAP2='P')
	_cQuery1 += " )

	ConOut("[STRESTE0]["+ FWTimeStamp(2) +"] - Resposta: "+_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	cResp := '{
	cResp += '"aprovacao":{

	If (_cAlias1)->(!Eof())

		cResp += '"empresa": "'+AllTrim(SM0->M0_NOME)+" - "+AllTrim(SM0->M0_FILIAL)+'",
		cResp += '"codigo": "'+(_cAlias1)->C1_NUM+'",
		cResp += '"solicitante": "'+AllTrim((_cAlias1)->C1_SOLICIT)+'",
		cResp += '"produtos": [

		_nTotal := 0

		While (_cAlias1)->(!Eof())

			_nPrTot := 0
			If (_cAlias1)->PRCMED>0
				_nPrTot := (_cAlias1)->PRCMED*(_cAlias1)->C1_QUANT
			ElseIf (_cAlias1)->B1_UPRC>0
				_nPrTot := (_cAlias1)->B1_UPRC*(_cAlias1)->C1_QUANT
			Else
				_nPrTot := 0
			EndIf
			
			_nTotal += _nPrTot

			cResp += '{
			cResp += '"codigo": "'+(_cAlias1)->C1_PRODUTO+'",
			cResp += '"descricao": "'+U_STTIRAGR((_cAlias1)->C1_DESCRI)+'",
			cResp += '"qtde": "'+cValToChar((_cAlias1)->C1_QUANT)+'",
			cResp += '"valor": "R$ '+cValToChar(_nPrTot)+'"
			cResp += '}

			(_cAlias1)->(DbSkip())

			If (_cAlias1)->(!Eof())
				cResp += ',
			EndIf

		EndDo

		cResp += '],
		cResp += '"total": "R$ '+cValToChar(_nTotal)+'"
		cResp += '}}

	Else
		cResp += 'ERRO'
	EndIf

	ConOut("[STRESTE0]["+ FWTimeStamp(2) +"] - Resposta: "+cResp)

	::SetResponse(cResp)

Return .T.