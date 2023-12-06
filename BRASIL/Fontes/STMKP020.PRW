#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STMKP020        | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição | Rotina criada para enviar os saldos para os marketplaces                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMKP020()

	Local _nX 		:= ""
	Local _cAlias1 		:= ""
	Local _aHeadOut 	:= {}
	Local _nTimeOut 	:= 60
	Local _cHeadRet 	:= ""
	Local _cUrl			:= ""
	Local oRestClient

	//RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")

	DbSelectArea("Z71")
	Z71->(DbSetOrder(1))

	_cEmail := GetMv("STMKP0201",,"renato.oliveira@steck.com.br")

	_cAlias1 := GetNextAlias()

	_cToken := AllTrim(GetMv("ST_TOKPREC",,"dFA2M0dXWUxzVklOSWljTDY6"))
	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "produtoLoja/saldo

	ConOut("[STMKP020]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	aAdd( _aHeadOut , "Authorization: Basic "+_cToken)
	aAdd( _aHeadOut , "Content-Type: application/json; charset=utf-8")

	oRestClient   := FWRest():New(_cUrl)

	oRestClient:setPath("/produtoLoja/saldo")

	_cJsReq := '{
	_cJsReq += '"produto":
	_cJsReq += '[

	_cQuery1 := " SELECT B1_COD, B1_GRUPO, B2_LOCAL, QTDE-EMPENHO-RESERVA SALDO
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT B1_COD, B1_GRUPO, B2_LOCAL, NVL(B2_QATU-B2_QACLASS,0) QTDE,
	_cQuery1 += " NVL((SELECT SUM(DC_QUANT) FROM "+RetSqlName("SDC")+" DC WHERE DC.D_E_L_E_T_=' ' AND DC_FILIAL=B2_FILIAL AND DC_PRODUTO=B2_COD AND DC_LOCAL=B2_LOCAL),0) EMPENHO,
	_cQuery1 += " NVL((SELECT SUM(PA2_QUANT) FROM "+RetSqlName("PA2")+" PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_FILRES=B2_FILIAL AND PA2_CODPRO=B2_COD),0) RESERVA
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB2")+" B2
	_cQuery1 += " ON B2_FILIAL='"+cFilAnt+"' AND B2_COD=B1_COD AND B2_LOCAL=B1_LOCPAD AND B2.D_E_L_E_T_=' '
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B1_XENVMKP='S'
	_cQuery1 += " ) XXX

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_nSaldo := (_cAlias1)->SALDO
		If Z71->(DbSeek(xFilial("Z71")+(_cAlias1)->B1_GRUPO))
			If Z71->Z71_PERC>0
				_nSaldo := Round(_nSaldo*(Z71->Z71_PERC/100),0)
			EndIf
		EndIf

		_cJsReq += '{
		_cJsReq += '"IdReferencia": "'+AllTrim((_cAlias1)->B1_COD)+'",
		_cJsReq += '"estoque":[{
		_cJsReq += '"filialSaldo": 1,
		_cJsReq += '"saldoReal": '+cValToChar(_nSaldo)+',
		_cJsReq += '"saldoDisponivel": '+cValToChar(_nSaldo)
		_cJsReq += '}]}

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			_cJsReq += ',
		EndIf

	EndDo

	_cJsReq += ']
	_cJsReq += '}

	_cJsReq := EncodeUTF8(_cJsReq)

	oRestClient:nTimeOut := 600

	If oRestClient:Put(_aHeadOut,_cJsReq)
		oInfo 	  	:= ""
		_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
	Else
		ConOut("PUT", oRestClient:GetLastError())
	EndIf

	_aErros := {}
	_lProc  := .F.

	If _lRet
		If Type("oInfo:PRODUTO")=="A"
			_aRet := oInfo:PRODUTO
			For _nX:=1 To Len(_aRet)
				If !AllTrim(oInfo:PRODUTO[_nX]:IDMENSAGEM)=="0"
					AADD(_aErros,{AllTrim(oInfo:PRODUTO[_nX]:IDREFERENCIA),AllTrim(oInfo:PRODUTO[_nX]:MENSAGEM)})
				Else
					_lProc := .T.
				EndIf
			Next
		EndIf
	Else
		_cErro := "Erro ao converter JSON"
	EndIf

	_cAssunto := "[MKP] - Envio de saldos"

	cMsg := ''
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<br>
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Mensagem</Font></B></TD>'
	cMsg += '</TR>'

	If Len(_aErros)==0
		AADD(_aErros,{"","Todos os produtos foram atualizados com sucesso."})
	EndIf

	For _nX:=1 To Len(_aErros)
		If (_nX/2) == Int(_nX/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aErros[_nX,1] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aErros[_nX,2] + ' </Font></TD>'
	Next

	cMsg += '</body>'
	cMsg += '</html>'

	//U_STMAILTES(_cEmail,"",_cAssunto,cMsg,{},"")

	ConOut("[STMKP020]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
