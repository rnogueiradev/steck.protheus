#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STMKP040        | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição | Rotina criada para enviar status de aceite				                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMKP040()

	Local _nX
	Local _cQuery1		:= ""
	Local _cAlias1 		:= ""
	Local _cQuery2		:= ""
	Local _cAlias2 		:= ""
	Local _aHeadOut 	:= {}
	Local _nTimeOut 	:= 60
	Local _cHeadRet 	:= ""
	Local _cUrl			:= ""
	Local oRestClient
	Local _aRet			:= {}
	Local _cJsonEnv		:= ""
	Local _lRet			:= .F.

	If !IsInCallStack("U_STMKP030")

		RpcSetType( 3 )
		RpcSetEnv("01","02",,,"FAT")

		DbSelectArea("ZH2")
		ZH2->(DbSetOrder(3))

	EndIf

	_cEmail := GetMv("STMKP0401",,"renato.oliveira@steck.com.br")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cToken := AllTrim(GetMv("ST_TOKPREC",,"dFA2M0dXWUxzVklOSWljTDY6"))
	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "erp/aceite

	ConOut("[STMKP040]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	aAdd( _aHeadOut , "Authorization: Basic "+_cToken)
	aAdd( _aHeadOut , "Content-Type: application/json; charset=utf-8")

	//Enviar status aceite
	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("ZH2")+" ZH2
	_cQuery1 += " WHERE ZH2.D_E_L_E_T_=' ' AND ZH2_DTENV=' ' AND ZH2_TIPO='1'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cJsonEnv := ' {"pedido": [

	While (_cAlias1)->(!Eof())

		_cJsonEnv += ' {
		_cJsonEnv += ' "codigoPedido": '+AllTrim((_cAlias1)->ZH2_PEDMKP)+',
		_cJsonEnv += ' "numeroPedidoERP": "'+AllTrim((_cAlias1)->ZH2_PEDERP)+'"
		_cJsonEnv += ' }

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			_cJsonEnv += ' ,
		EndIf

	EndDo

	_cJsonEnv += ']}

	_cJsonEnv := EncodeUTF8(_cJsonEnv)

	oRestClient   := FWRest():New(_cUrl)

	oRestClient:setPath("/erp/aceite")

	oRestClient:nTimeOut := 600

	If oRestClient:Put(_aHeadOut,_cJsonEnv)
		oInfo 	  	:= ""
		_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
	Else
		ConOut("PUT", oRestClient:GetLastError())
	EndIf

	If _lRet
		If Type("oInfo:PEDIDO")=="A"
			_aRet := oInfo:PEDIDO
			For _nX:=1 To Len(_aRet)
				If oInfo:PEDIDO[_nX]:IDRETORNO==0
					If ZH2->(DbSeek(xFilial("ZH2")+PADR(AllTrim(oInfo:PEDIDO[_nX]:NUMEROPEDIDO),TamSx3("ZH2_PEDMKP")[1])+"1"))
						ZH2->(RecLock("ZH2",.F.))
						ZH2->ZH2_DTENV := Date()
						ZH2->ZH2_HRENV := Time()
						ZH2->(MsUnLock())
					EndIf
				EndIf
			Next
		EndIf
	Else
		_cErro := "Erro ao converter JSON"
	EndIf

	//Enviar status nf

	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "erp/faturamento

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("ZH2")+" ZH2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SF2")+" F2
	_cQuery1 += " ON F2_FILIAL=ZH2_FILIAL AND F2_DOC=ZH2_DOC AND F2_SERIE=ZH2_SERIE
	_cQuery1 += " WHERE ZH2.D_E_L_E_T_=' ' AND F2.D_E_L_E_T_=' '
	_cQuery1 += " AND ZH2_DTENV=' ' AND ZH2_TIPO='2' AND F2_CHVNFE<>' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	//StaticCall (SPEDNFE,IsReady,,,,.F.)
	cIdEnt := ""//StaticCall (SPEDNFE,GetIdEnt,.F.)

	_cCaminho := '\arquivos\marketplaces\'

	While (_cAlias1)->(!Eof())

		//StaticCall (SPEDNFE,SpedPExp,cIdEnt,(_cAlias1)->F2_SERIE,(_cAlias1)->F2_DOC,(_cAlias1)->F2_DOC,_cCaminho,.T.,CTOD("01/01/2000"),CTOD("31/12/2040"),"              ","zzzzzzzzzzzzzz",1,,)

		_cXml := ""

		oFT   := fT():New()
		oFT:ft_fUse( _cCaminho+(_cAlias1)->F2_CHVNFE+"-nfe.xml" )

		While !( oFT:ft_fEof() )
			_cXml += oFT:ft_fReadLn()
		 oFT:ft_fSkip()
		End While

		oFT:ft_fUse()

		_cXml := Encode64(_cXml)
		
		_cJsonEnv := ' {"pedido": [
		_cJsonEnv += ' {
		_cJsonEnv += ' "codigoPedido": '+AllTrim((_cAlias1)->ZH2_PEDMKP)+',
		_cJsonEnv += ' "chaveNF": "'+AllTrim((_cAlias1)->F2_CHVNFE)+'",
		_cJsonEnv += ' "xml": "'+AllTrim(_cXml)+'"
		_cJsonEnv += ' }
		_cJsonEnv += ']}

		_cJsonEnv := EncodeUTF8(_cJsonEnv)

		oRestClient   := FWRest():New(_cUrl)
		oRestClient:setPath("/erp/faturamento")
		oRestClient:nTimeOut := 600

		If oRestClient:Put(_aHeadOut,_cJsonEnv)
			oInfo 	  	:= ""
			_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
		Else
			ConOut("PUT", oRestClient:GetLastError())
		EndIf

		If _lRet
			If Type("oInfo:PEDIDO")=="A"
			_aRet := oInfo:PEDIDO
				For _nX:=1 To Len(_aRet)
					If oInfo:PEDIDO[_nX]:IDRETORNO==0
						If ZH2->(DbSeek(xFilial("ZH2")+PADR(AllTrim(oInfo:PEDIDO[_nX]:NUMEROPEDIDO),TamSx3("ZH2_PEDMKP")[1])+"2"))

							ZH2->(RecLock("ZH2",.F.))
							ZH2->ZH2_DTENV := Date()
							ZH2->ZH2_HRENV := Time()
							ZH2->(MsUnLock())

							_cEmail := GetMv("STMKP0401",,"renato.oliveira@steck.com.br;kleber.braga@steck.com.br")

							_cMsg := ""
							_cMsg += '<html>
							_cMsg += '<head>
							_cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>
							_cMsg += '</head>
							_cMsg += '<body>
							_cMsg += '<b>IMPRIMIR ETIQUETA DO MERCADO LIVRE</b>
							_cMsg += '</body>
							_cMsg += '</html>

							U_STMAILTES(_cEmail,"","[MKP] - Envio de XML feito com sucesso para o pedido "+ZH2->ZH2_PEDERP,_cMsg,{},"")

						EndIf
					EndIf
				Next
			EndIf
		Else
			_cErro := "Erro ao converter JSON"
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	//Enviar status despachado
	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "erp/envio

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("ZH2")+" ZH2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
	_cQuery1 += " ON C5_FILIAL=ZH2_FILIAL AND C5_NUM=ZH2_PEDERP
	_cQuery1 += " WHERE ZH2.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' 
	_cQuery1 += " AND ZH2_DTENV=' ' AND ZH2_TIPO='3' AND C5_XDTETIQ<>' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cJsonEnv := ' {"pedido": [

	While (_cAlias1)->(!Eof())

		_cJsonEnv += ' {
		_cJsonEnv += ' "codigoPedido": '+AllTrim((_cAlias1)->ZH2_PEDMKP)+',
		_cJsonEnv += ' "protocoloCorreio": ""
		_cJsonEnv += ' }

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			_cJsonEnv += ' ,
		EndIf

	EndDo

	_cJsonEnv += ']}

	_cJsonEnv := EncodeUTF8(_cJsonEnv)

	oRestClient   := FWRest():New(_cUrl)
	oRestClient:setPath("/erp/envio")
	oRestClient:nTimeOut := 600

	If oRestClient:Put(_aHeadOut,_cJsonEnv)
		oInfo 	  	:= ""
		_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
	Else
		ConOut("PUT", oRestClient:GetLastError())
	EndIf

	If _lRet
		If Type("oInfo:PEDIDO")=="A"
			_aRet := oInfo:PEDIDO
			For _nX:=1 To Len(_aRet)
				If oInfo:PEDIDO[_nX]:IDRETORNO==0
					If ZH2->(DbSeek(xFilial("ZH2")+PADR(AllTrim(oInfo:PEDIDO[_nX]:NUMEROPEDIDO),TamSx3("ZH2_PEDMKP")[1])+"3"))
						ZH2->(RecLock("ZH2",.F.))
						ZH2->ZH2_DTENV := Date()
						ZH2->ZH2_HRENV := Time()
						ZH2->(MsUnLock())
					EndIf
				EndIf
			Next
		EndIf
	Else
		_cErro := "Erro ao converter JSON"
	EndIf

	ConOut("[STMKP040]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"ok"},3)
	EndIf

RestArea(aArea)
Return(cIdEnt)
