#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ WsGnrc15 บAutor ณ Jonathan Schmidt Alves บData ณ29/06/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Customizacao para chamada HttpPost do webservice Thomson.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                   WsGnrc15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cNomApi: Nome da Api                                       บฑฑ
ฑฑบ          ณ          Ex: "PKG_SFW_PRODUTOS.PRC_PRODUTO"                บฑฑ
ฑฑบ          ณ              "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA"   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cEndUrl: Endereco integracao                               บฑฑ
ฑฑบ          ณ          Ex: https://gtmqa-steck.onesourcelogin.com/       บฑฑ
ฑฑบ          ณ          sfw-generic-ws/PrcProdutoWSImpl?wsdl              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cTipAmb: Integracao no Ambiente                            บฑฑ
ฑฑบ          ณ          Ex: "TST"=Ambiente de testes (QA)                 บฑฑ
ฑฑบ          ณ              "DSV"=Ambiente de desenvolvimento (PRJ)       บฑฑ
ฑฑบ          ณ              "PRD"=Ambiente de producao (PRO)              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cMntXml: Montagem do Xml para envio                        บฑฑ
ฑฑบ          ณ          Ex:                                               บฑฑ
ฑฑบ          ณ <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap    บฑฑ
ฑฑบ          ณ .org/soap/ envelope/" xmlns:pkg="http://pkgsfwprodutos     บฑฑ
ฑฑบ          ณ .generic.service.sfw.com.br/">                             บฑฑ
ฑฑบ          ณ <soapenv:Header/>                                          บฑฑ
ฑฑบ          ณ <soapenv:Body>                                             บฑฑ
ฑฑบ          ณ <pkg:getSfwProduto>                                        บฑฑ
ฑฑบ          ณ <pkg:filterPrcProduto>                                     บฑฑ
ฑฑบ          ณ <pkg:pIdProduto></pkg:pIdProduto>                          บฑฑ
ฑฑบ          ณ <pkg:pPartNumber></pkg:pPartNumber>                        บฑฑ
ฑฑบ          ณ <pkg:pCodOrganizacao></pkg:pCodOrganizacao>                บฑฑ
ฑฑบ          ณ </pkg:filterPrcProduto>                                    บฑฑ
ฑฑบ          ณ </pkg:getSfwProduto>                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nMsgPrc: Mensagem de processamento                         บฑฑ
ฑฑบ          ณ          Ex: 0=Sem Interface                               บฑฑ
ฑฑบ          ณ          Ex: 1=MsgInfo, MsgAlert, MsgStop                  บฑฑ
ฑฑบ          ณ          Ex: 2=AskYesNo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function WsGnrc15(cNomApi, cEndUrl, cTipAmb, cMntXml, nMsgPrc)
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
Local _z1
Local aRet := { .F., Nil, "" }
Local cMsg01 := "Integracao Totvs -> Thomson"
Local cMsg02 := "Contatando webservice..."
Local cMsg03 := ""
Local cMsg04 := ""
// Xml retorno
Local oXml
Local aXml := {}
Local aXmls := {}
Local cObj := ""
Local cChk := ""
Local cError := ""
Local cWarning := ""
// Variaveis HttpPost
Local cUsrNam := ""
Local cPasswd := ""
Local nTimeOut := 360
Local aHeadOut := {}
Local cHeadRet := ""
Local cRetXml := ""
Local nWbSrv := 2 // 1=Producao 2=Homologacao
Local _cFlex8 := ""
Local nDiasToler:=SuperGetMV("ST_DTOLTHO",.F.,60)
ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPrc == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "GEO")
		Sleep(050)
	Next
EndIf
// Autenticacao Usuario/Senha Thomson
If nWbSrv == 1 // 1=Producao
	cUsrNam := "INT_TRADE"
	cPasswd := "Welcome@1"
Else // 2=Homologacao
	cUsrNam := "INT_TRADE"
	cPasswd := "Welcome@1"
EndIf
// Comunicacao Webservice
aAdd(aHeadOut, "Content-Type: text/xml")
aAdd(aHeadOut, "Authorization: Basic " + Encode64(cUsrNam + ":" + cPasswd))
// Chamada Http
ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Integrando (HttpPost)...")
cRetXml := HttpPost(cEndUrl, Nil, cMntXml, nTimeOut, aHeadOut, @cHeadRet)
ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Integrando (HttpPost)... Concluido!")
// Logs ZTL
ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Gravando logs de processamento (ZTL)...")

RecLock("ZTL",.T.)
ZTL->ZTL_FILIAL := _cFilZTL                     // Filial
ZTL->ZTL_TIPINT := ZT1->ZT1_TIPINT              // Tipo Interface
ZTL->ZTL_CODIGO := ZT1->ZT1_CODIGO              // Codigo
ZTL->ZTL_NOMAPI := ZT1->ZT1_NOMAPI              // Nome API
ZTL->ZTL_XMLENV := cMntXml                      // XML Envio
ZTL->ZTL_XMLRET := cRetXml                   	// XML Retorno
ZTL->ZTL_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
ZTL->ZTL_USERLG := cUserName                    // Usuario Log
ZTL->(MsUnlock())

ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Gravando logs de processamento (ZTL)... Concluido!")
If !Empty(cRetXml) // Retorno
	// #############################################################
	// ######################### CONSULTA ##########################
	// #############################################################
	If ZT1->ZT1_TIPINT == "01" // "01"=Consulta
		If "OIFEXPORT" $ ZT1->ZT1_NOMAPI // Consulta de Notificacoes
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETSFWOIFEXPORTRESPONSE", "" }, { "SFWOIFEXPORT", "" }, { "STATUS", "1" } })
		ElseIf "PKG_SFW_NOTAFISCAL_NFENFC" $ ZT1->ZT1_NOMAPI // Consulta de Nota Fiscal Importacao
			If Len( cRetXml ) > 1000
				RecLock("ZTN",.F.) // ZTN ja vem posicionado
				ZTN->ZTN_XMLENV := cMntXml								// XML Envio
				ZTN->ZTN_XMLRET := cRetXml          					// XML Retorno
				ZTN->ZTN_STATOT := "05"             					// Status Totvs         "01"=Pendente  "05"=Em Processamento Totvs (com Xml baixado)
				ZTN->ZTN_DETPR1 := "Aguardando processamento Totvs (Xml baixado)"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			EndIf
			aRet[01] := .T.
		ElseIf "PKG_ES_GEN_SENF_ATUALIZA" $ ZT1->ZT1_NOMAPI // Consulta de Nota Fiscal Exportacao
			If Len( cRetXml ) > 1000
				RecLock("ZTN",.F.) // ZTN ja vem posicionado
				ZTN->ZTN_XMLENV := cMntXml          					// XML Envio
				ZTN->ZTN_XMLRET := cRetXml          					// XML Retorno
				ZTN->ZTN_STATOT := "05"             					// Status Totvs         "01"=Pendente  "05"=Em Processamento Totvs (com Xml baixado)
				ZTN->ZTN_DETPR1 := "Aguardando processamento Totvs (Xml baixado)"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			EndIf
			aRet[01] := .T.
		ElseIf "PKG_PRC_ADIANT_DESPESA" $ ZT1->ZT1_NOMAPI // Consulta de Adiantamento/Despesas/Pagamentos
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETDESPESASRESPONSE", "" }, { "ISAPISPDESP", "" }, { "SPSTATUS", "F" } })
		ElseIf "PKG_GEN_PAGAMENTO" $ ZT1->ZT1_NOMAPI // Consulta de Pagamentos Exportacao (Robson 30/09/2021)
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETPAGAMENTORESPONSE", "" }, { "ESPAGAMENTO", "" }, { "STATUS", "L" } })
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETPAGAMENTORESPONSE", "" }, { "ESPAGAMENTO", "" }, { "ESADIANTDESPESASDETALHESCOLLECTION", "" }, { "ESADIANTDESPESASDETALHES", "" }, { "NUMDOCUMENTO", "", "AllwaysTrue()" } })
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETPAGAMENTORESPONSE", "" }, { "ESPAGAMENTO", "" }, { "ESADIANTAMENTOPGTOSTIPOSCOLLECTION", "" }, { "ESADIANTAMENTOPGTOSTIPOS", "" }, { "CODTIPOPAGTO", "", "AllwaysTrue()" } })
		ElseIf "PRC_IT_CE_OUT_TXT" $  ZT1->ZT1_NOMAPI // Consulta de Cambio Exportacao
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETCONTABILIZACAORESPONSE", "" }, { "CECTBHEADER", "" }, { "NS2_IDEVENTOOIFEXPORT", "6011" } })
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETCONTABILIZACAORESPONSE", "" }, { "CECTBHEADER", "" }, { "NS2_CECTBITEMCOLLECTION", "" }, { "NS2_CECTBITEM", "" }, { "NS2_CHAVELANCAMENTO", "IT" } })
		ElseIf "PRC_IT_CI_OUT_TXT" $  ZT1->ZT1_NOMAPI // Consulta de Cambio Importacao
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETCONTABILIZACAORESPONSE", "" }, { "CICTBHEADER", "" }, { "IDEVENTOOIFEXPORT", "6012" } })
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETCONTABILIZACAORESPONSE", "" }, { "CICTBHEADER", "" }, { "CICTBITEMCOLLECTION", "" }, { "CICTBITEM", "" }, { "CHAVELANCAMENTO", "IT" } })
		ElseIf "PKG_PRC_FATURA_IMP" $ ZT1->ZT1_NOMAPI // Consulta de Transito Importacao (Pechula 14/09/2021)
			If Len( cRetXml ) > 400
				RecLock("ZTN",.F.) // ZTN ja vem posicionado
				ZTN->ZTN_XMLENV := cMntXml								// XML Envio
				ZTN->ZTN_XMLRET := cRetXml          					// XML Retorno
				ZTN->ZTN_STATOT := "05"             					// Status Totvs         "01"=Pendente  "05"=Em Processamento Totvs (com Xml baixado)
				ZTN->ZTN_DETPR1 := "Em processamento Totvs"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			EndIf
			aRet[01] := .T.
		EndIf
	// #############################################################
	// ######################### INCLUSAO ##########################
	// #############################################################
	ElseIf ZT1->ZT1_TIPINT == "03" // "03"=Inclusao
		If "PKG_SFW_MOEDA.PRC_MOEDA_TAXA" $ ZT1->ZT1_NOMAPI // Atualizacao Taxas de Moedas
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETSFWMOEDATAXAPTAXRESPONSE", "" }, { "SFWMOEDATAXA", "", "" }, { "CODMOEDAORIGEM", "", "AllwaysTrue()" } })
		ElseIf "PKG_BS_API_RETORNO_NF" $ ZT1->ZT1_NOMAPI // Nota de Entrada transmitida Sefaz com sucesso
			If ZTN->ZTN_STATOT == "08" // "08"=Nota de entrada transmitida Sefaz com sucesso (notificado Thomson)
				RecLock("ZTN",.F.) // ZTN ja vem posicionado
				ZTN->ZTN_STATOT := "09"             					// Status Totvs         "09"=Retorno NF processado com sucesso
				ZTN->ZTN_DETPR1 := "Retorno NF processado com sucesso"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
				aRet[01] := .T.
			EndIf
		ElseIf "PKG_IS_API_RECEBIMENTO.PRC_IS_PROCESSA_RECEBIMENTO" $ ZT1->ZT1_NOMAPI // Recebimento dos Materiais
			If ZTN->ZTN_STATOT == "10" // "10"=Sucesso no retorno XML Thomson (notificado Thomson)
				RecLock("ZTN",.F.)
				ZTN->ZTN_STATOT := "11"             					// Status Totvs         "01"=Pendente  "12"=Materiais recebidos no Totvs com sucesso
				ZTN->ZTN_DETPR1 := "Materiais recebidos no Totvs com sucesso"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
				aRet[01] := .T.
			EndIf
		ElseIf "PKG_ES_GEN_NF_ATUALIZA" $ ZT1->ZT1_NOMAPI // Envio da Senf Exportacao
			If ZTN->ZTN_STATOT == "07" // "07"=Capa processada com sucesso
				RecLock("ZTN",.F.) // ZTN ja vem posicionado
				ZTN->ZTN_STATOT := "08"             					// Status Totvs         "01"=Pendente  "05"=Em Processamento Totvs (com Xml baixado) "07"=Capa Atualizaca com sucesso "08"=Senf Enviada com Sucesso
				ZTN->ZTN_DETPR1 := "Em processamento Totvs"
				ZTN->ZTN_DETPR2 := "Emp/Fil/Doc/Serie: " + cEmpAnt + SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
				aRet[01] := .T.
			EndIf
		Else // Processamento do retorno quando 03=Inclusao
			aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_PROCESSAINTERFACERESPONSE", "" }, { "RETURN", "" }, { "STATUS", "SUCCESS" } })
		EndIf
	// #############################################################
	// ######################### ATUALIZA ##########################
	// #############################################################
	ElseIf ZT1->ZT1_TIPINT == "04" // "04"=Atualizacao
		If "OIFEXPORT" $ ZT1->ZT1_NOMAPI // Atualizacao de Status de Notificacoes
			If ZTN->ZTN_STATOT == "01"									// "01"=Pendente
				RecLock("ZTN",.F.)
				ZTN->ZTN_STATOT := "03"									// "03"=Em Processamento Totvs
				ZTN->ZTN_STATHO := "3"									// "3"=Em Processamento Totvs
				ZTN->ZTN_DETPR1 := "Notificacao em processamento no Totvs (notificado Thomson)"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			ElseIf ZTN->ZTN_STATOT == "05"								// "05"=Processado Totvs
				If ZTN->ZTN_IDEVEN $ "6011/6012/" // 6011=Geracao RA (ZTX) 6012=Geracao PA (ZTY)
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "02"								// "02"=Em Processamento Totvs
					ZTN->ZTN_STATHO := "2"								// "2"=Processado com sucesso
					ZTN->ZTN_DETPR1 := "Dados preparados no Totvs (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				EndIf
			ElseIf ZTN->ZTN_STATOT == "06" // "06"=Entrada de Nota processada com sucesso
				If ZTN->ZTN_IDEVEN $ "6002/"
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "07"             				// "07"=Retorno NF Entrada Importacao realizado com sucesso
					ZTN->ZTN_DETPR1 := "Pre-Nota de Entrada gerada com sucesso! (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				ElseIf ZTN->ZTN_IDEVEN $ "6004/"
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "07"								// "07"=Sucesso na atualizacao da Capa
					ZTN->ZTN_DETPR1 := "Capa atualizada com sucesso! (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				ElseIf ZTN->ZTN_IDEVEN $ "6059/" // "06"=Transito processado com suceso
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "07"             				// "07"=Transito processado com sucesso
					ZTN->ZTN_DETPR1 := "Transito processado com sucesso! (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				EndIf
			ElseIf ZTN->ZTN_STATOT == "07" // "07"=Nota de Entrada processada
				If ZTN->ZTN_IDEVEN $ "6002/"
					RecLock("ZTN",.F.) // ZTN ja vem posicionado
					ZTN->ZTN_STATOT := "08"             				// Status Totvs         "08"=Nota de Entrada processada com sucesso
					ZTN->ZTN_DETPR1 := "Nota de entrada processada com sucesso (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
					aRet[01] := .T.
				EndIf
			ElseIf ZTN->ZTN_STATOT == "08" // "08"=Sucesso
				If ZTN->ZTN_IDEVEN $ "6002/"
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "08" // TESTE					// "08"=Sucesso na transmissao Sefaz nota de importacao
					ZTN->ZTN_DETPR1 := "Nota de importacao transmitida Sefaz (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				ElseIf ZTN->ZTN_IDEVEN $ "6004/"
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "09"								// "09"=Senf enviada com sucesso
					ZTN->ZTN_DETPR1 := "Senf enviada com sucesso (notificado Thomson)"
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				Else
					RecLock("ZTN",.F.)
					ZTN->ZTN_STATOT := "02"								// "02"=Sucesso no processamento
					ZTN->ZTN_DETPR1 := "Processamento concluido com sucesso! (notificado Thomson)"
					ZTN->ZTN_STATHO := "2"								// "2"=Sucesso no processamento
					ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
					ZTN->ZTN_USERLG := cUserName						// Ex: "jonathan.sigamat"
					ZTN->(MsUnlock())
				EndIf
			ElseIf ZTN->ZTN_STATOT == "09" // "09"=Sucesso
				RecLock("ZTN",.F.)
				If ZTN->ZTN_IDEVEN $ "6002/"
					ZTN->ZTN_STATOT := "10"								// "10"=Sucesso no retorno XML
					ZTN->ZTN_DETPR1 := "Sucesso no retorno XML Thomson (notificado Thomson)"
					ZTN->ZTN_STATHO := "3"								// "3"=Sucesso no processamento
				EndIf
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			ElseIf ZTN->ZTN_STATOT == "11" // "11"=Sucesso
				RecLock("ZTN",.F.)
				If ZTN->ZTN_IDEVEN $ "6002/"
					ZTN->ZTN_STATOT := "02"								// "02"=Sucesso no recebimento dos materiais (notificado Thomson)
					ZTN->ZTN_DETPR1 := "Sucesso no recebimento dos materiais (notificado Thomson)"
				EndIf
				ZTN->ZTN_STATHO := "2"									// "2"=Sucesso no processamento
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			ElseIf ZTN->ZTN_STATOT == "41" // "41"=Falha
				RecLock("ZTN",.F.)
				ZTN->ZTN_STATOT := "04"									// "04"=Falha no processamento Totvs
				ZTN->ZTN_STATHO := "4"									// "4"=Falha no processamento
				ZTN->ZTN_DETPR1 := "Dados processados com falha!"
				ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()			// Ex: 08/08/2021 12:00:03
				ZTN->ZTN_USERLG := cUserName							// Ex: "jonathan.sigamat"
				ZTN->(MsUnlock())
			EndIf
			aRet[01] := .T.
			// Caso a data da transa็ใo seja acima de x dias (60) considera transa็ใo encerrada 
			IF ZTN->ZTN_STATHO == '3' // Ainda nใo baixado. 
			   IF CTOD(SUBSTR(ZTN->ZTN_DATRAN,9,2)+'/'+SUBSTR(ZTN->ZTN_DATRAN,6,2)+'/'+SUBSTR(ZTN->ZTN_DATRAN,1,4))<DATE()-nDiasToler
                  ZTN->(RecLock("ZTN",.F.))
				  ZTN->ZTN_STATHO:='2'
                  ZTN->ZTN_FATDAT:='Prz Excedido: '+alltrim(str(ndiasToler,5))+' dias.'
				  ZTN->(MsUnlock())
			   ENDIF 	  
		    ENDIF 
		
		EndIf
	Else // Outros retornos
		aRet[01] := .T.
	EndIf
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	// @@@@@@@@@@@@@@@@@@@@@@@ PROCESSAMENTO @@@@@@@@@@@@@@@@@@@@@@@
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	If Len(aXmls) > 0 // Matriz carregada para localizacoes
		oXml := XmlParser(cRetXml, "_", @cError, @cWarning)
		If XMLChildCount(oXml) > 0
			For _w0 := 1 To Len( aXmls )
				aXml := aXmls [ _w0 ]
				cObj := "oXml"
				cHldObj := ""
				cHldOld := ""
				_w1 := 1
				_w3 := 0
				While _w1 <= Len(aXml)
					_w2 := 1
					While _w2 <= XMLChildCount(&(cObj))
						cChk := ""
						If ValType( XMLGetChild(&(cObj),_w2) ) == "A" // Se for matriz
							_w3++
							If _w3 <= Len( XMLGetChild(&(cObj),_w2) ) // Rodo nas duas/tres/etc notificacoes
								cChk := Upper(StrTran( XMLGetChild(&(cObj),_w2)[ _w3 ]:RealName,":","_"))
								_w2--
							EndIf
						Else // Se ja eh objeto
							cChk := Upper(StrTran(XMLGetChild(&(cObj),_w2):RealName,":","_"))
						EndIf
						If !Empty(cChk) .And. cChk == aXml[_w1,01] // Noh conforme
							If ValType( &(cObj + ":_" + cChk) ) == "A"
								cHldOld := cObj
								cObj += ":_" + cChk
								cHldObj := cObj // Hold do objeto
								cObj += "[" + cValToChar(_w3) + "]"
							Else
								cObj += ":_" + cChk
							EndIf
							If (!Empty(aXml[_w1,02]) .And. Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02]) .Or. (Len(aXml[_w1]) >= 3 .And. &(aXml[_w1,03])) // .T.=Sucesso
								// ############## OIFEXPORT #################
								If "OIFEXPORT" $ ZT1->ZT1_NOMAPI // Consultas Notificacoes
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										aFlds := { { "IDTRANSACAO", "", "ZTN_IDTRAN" }, { "IDEVENTO", "", "ZTN_IDEVEN" }, { "IDPARCEIRO", "", "ZTN_IDPARC" }, { "DATATRANSACAO", "", "ZTN_DATRAN" },;
										{ "STATUS", "", "ZTN_STATHO" }, { "TIPOTRANSACAO", "", "ZTN_TIPTRA" },;
										{ "PKVC201", "", "ZTN_PVC201" }, { "PKVC202", "", "ZTN_PVC202" }, { "PKVC203", "", "ZTN_PVC203" }, { "PKVC204", "", "ZTN_PVC204" },;
										{ "PKVC205", "", "ZTN_PVC205" }, { "PKVC206", "", "ZTN_PVC206" }, { "PKVC210", "", "ZTN_PVC210" },;
										{ "PKNUMBER01", "", "ZTN_NUMB01" }, { "PKNUMBER02", "", "ZTN_NUMB02" }, { "PKNUMBER03", "", "ZTN_NUMB03" },;
										{ "PKNUMBER04", "", "ZTN_NUMB04" }, { "PKNUMBER05", "", "ZTN_NUMB05" }, { "PKNUMBER06", "", "ZTN_NUMB06" }, { "PKNUMBER07", "", "ZTN_NUMB07" }, { "PKNUMBER10", "", "ZTN_NUMB10" },;
										{ "PKDATE01", "", "ZTN_DATE01" }, { "PKDATE02", "", "ZTN_DATE02" }, { "PKDATE03", "", "ZTN_DATE03" },;
										{ "PKDATE04", "", "ZTN_DATE04" }, { "PKDATE05", "", "ZTN_DATE05" }, { "PKDATE06", "", "ZTN_DATE06" }, { "PKDATE10", "", "ZTN_DATE10" },;
										{ "USERNAME", "", "ZTN_USERNA" }, { "CODERPORIGEM", "", "ZTN_ERPORI" }, { "CODSISTEMA", "", "ZTN_CODSIS" },;
										{ "FATNUMFATURA", "", "ZTN_FATNUM" }, { "FATTIPOFATURA", "", "ZTN_FATTIP" }, { "FATDATAFATURA", "", "ZTN_FATDAT" } }
										For _w4 := 1 To XMLChildCount(oXml2)
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next

										If ASCan( aFlds, {|x|, x[01] == "CODERPORIGEM" .And. Left(x[02],2) == cEmpAnt }) > 0 // Empresa conforme empresa logada (6012 vem vazio) // "CODERPORIGEM"

											ZTN->(DbSetOrder(1)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_IDTRAN + ZTN_STATHO + ZTN_STATOT + ZTN_DTHRLG
											If ZTN->(!DbSeek( _cFilZTN + aFlds[02,02] + aFlds[01,02] )) // Ainda nao existe
												RecLock("ZTN",.T.)
												ZTN->ZTN_FILIAL := _cFilZTN
												ZTN->ZTN_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
											ElseIf ZTN->ZTN_STATOT == "01" // Se ainda nao houve nenhum processamento no Totvs, regravo
												RecLock("ZTN",.F.)
											EndIf
											If ZTN->ZTN_STATOT $ "01/" // 03/" // Apenas gravacao se for "01"=Pendente processamento Totvs ou "03"=Em Processamento Totvs
												For _w4 := 1 To Len( aFlds )
													&("ZTN->" + aFlds[_w4,03]) := aFlds[_w4,02] // Gravacoes
												Next
												ZTN->ZTN_XMLENV := cMntXml          // XML Envio
												ZTN->ZTN_XMLRET := cRetXml          // XML Retorno
												ZTN->ZTN_DETPR1 := "Dados carregados com sucesso (ZTN)"
												ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
												ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
												ZTN->(MsUnlock())
											EndIf

										EndIf

									EndIf
									// ############## OIFEXPORT #################
									// ############## PKG_PRC_ADIANT_DESPESA #################
								ElseIf "PKG_PRC_ADIANT_DESPESA" $ ZT1->ZT1_NOMAPI
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										aFlds := { { "SPID", "", "ZTF_CDSPID" }, { "SPCODPROCESSO", "", "ZTF_PROCES" }, { "SPDIDDESPESAPROCESSO", "", "ZTF_IDEPRO" },;
										{ "SPAREANEGOCIO", "", "ZTF_AREANE" }, { "SPCCODIGOCREDOR", "", "ZTF_CODCRE" },;
										{ "SPCDATAEMISSAO", "", "ZTF_DATEMI" }, { "SPCODCREDOR", "", "ZTF_CREDO1" }, { "SPCODCREDORDESPESA", "", "ZTF_CREDES" }, { "SPCODDESPESA", "", "ZTF_DESPES" },;
										{ "SPCODMOEDA", "", "ZTF_CMOEDA" }, { "SPDATACADASTRO", "", "ZTF_CADAST" }, { "SPDATALIBERACAO", "", "ZTF_DATLIB" },;
										{ "SPDATAVENCIMENTO", "", "ZTF_DATVEN" }, { "SPDCODIGOCREDORDESPESA", "", "ZTF_CREDOR" },;
										{ "SPDSFLEXFIELD1", "", "ZTF_FLEXF1" }, { "SPEMBARQUENUM", "", "ZTF_EMBNUM" }, { "SPEMPRESA", "", "ZTF_SPEMPR" }, { "SPFORMAPAGTO", "", "ZTF_FORPGT" },;
										{ "SPNUMDOCUMENTO", "", "ZTF_NUMDOC" }, { "SPORGANIZACAO", "", "ZTF_SPORGA" }, { "SPRAZAOESPECIAL", "", "ZTF_RAZESP" },;
										{ "SPSTATUS", "", "ZTF_STATUS" }, { "SPTIPO", "", "ZTF_SPTIPO" }, { "SPVRADIANTADODESPESA", "", "ZTF_ADIDES" },;
										{ "SPVRAPAGARDESPESA", "", "ZTF_PAGDES" }, { "SPVRPREVISTODESPESA", "", "ZTF_PRVDES" }, { "SPVRREALDESPESA", "", "ZTF_READES" },;
										{ "SPFLEXFIELD2", "", "ZTF_FLEXF2" }, { "SPFLEXFIELD3", "", "ZTF_FLEXF3" }, { "SPCSFLEXFIELD4", "", "ZTF_FLEXF4" }, { "SPCSFLEXFIELD5", "", "ZTF_FLEXF5" } }
										For _w4 := 1 To XMLChildCount(oXml2)
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next
										ZTF->(DbSetOrder(1)) // ZTF_FILIAL + ZTF_CDSPID + ZTF_PROCES + ZTF_IDEPRO
										If ZTF->(!DbSeek( _cFilZTF + PadR(aFlds[01,02],TamSX3("ZTF_CDSPID")[01]) + PadR(aFlds[02,02],TamSX3("ZTF_PROCES")[01]) + PadR(aFlds[03,02],TamSX3("ZTF_IDEPRO")[01]))) // Ainda nao existe
											RecLock("ZTF",.T.)
											ZTF->ZTF_FILIAL := _cFilZTF
											ZTF->ZTF_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
										ElseIf ZTF->ZTF_STATOT == "01" // Se ainda nao houve nenhum processamento no Totvs, regravo
											RecLock("ZTF",.F.)
										EndIf
										If ZTF->ZTF_STATOT $ "01/03/" // Apenas gravacao se for "01"=Pendente processamento Totvs ou "03"=Em Processamento Totvs
											For _w4 := 1 To Len( aFlds )
												&("ZTF->" + aFlds[_w4,03]) := aFlds[_w4,02] // Gravacoes
											Next
											ZTF->ZTF_XMLENV := cMntXml          // XML Envio
											ZTF->ZTF_XMLRET := cRetXml          // XML Retorno
											ZTF->ZTF_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
											ZTF->ZTF_USERLG := cUserName                       // Ex: "jonathan.sigamat"
											ZTF->(MsUnlock())
										EndIf
										RecLock("ZTN",.F.)
										ZTN->ZTN_STATOT := "05" // "05"=Geracao ZTF realizada com sucesso!
										ZTN->ZTN_DETPR1 := "Dados carregados com sucesso (ZTF)"
										ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
										ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
										ZTN->(MsUnlock())
									EndIf
									// ############## PKG_PRC_ADIANT_DESPESA #################
									// ############## PKG_GEN_PAGAMENTO ######################
								ElseIf "PKG_GEN_PAGAMENTO" $ ZT1->ZT1_NOMAPI 
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										If _w0 == 1 // Cabecalho
											aFlds := { { "IDSP", "", "ZTP_CDIDSP" }, { "NUMADIANTAMENTO", "", "ZTP_ADIANT" }, { "CODENTIDADE", "", "ZTP_CODENT" },;
											{ "CODMOEDA", "", "ZTP_CODMOE" }, { "TIPOSP", "", "ZTP_TIPOSP" },;
											{ "IDCFORMAPAGTO", "", "ZTP_IDCFOR" }, { "DATASP", "", "ZTP_DATASP" }, { "STATUS", "", "ZTP_STATUS" }, { "CODTIPOPAGTO", "", "ZTP_CODTIP" },;
											{ "CREDOR", "", "ZTP_CREDOR" }, { "NUMDOCUMENTO", "", "ZTP_DOCTO" }, { "CODAREA", "", "ZTP_CODARE" },;
											{ "DTEMISSAO", "", "ZTP_EMISSA" }, { "DTLIBERACAO", "", "ZTP_LIBERA" },;
											{ "DATAVENCIMENTO", "", "ZTP_VENCTO" }, { "VALORPAGAR", "", "ZTP_VLRPAG" }, { "VLRPAGO", "", "ZTP_VLPAGO" }, { "CONCLUIDO", "", "ZTP_CONCLU" },;
											{ "SATRIBFLEXVCSTRING1", "", "ZTP_FLEXS1" }, { "SATRIBFLEXVCSTRING2", "", "ZTP_FLEXS2" },;
											{ "DATRIBFLEXDATE1", "", "ZTP_FLEXD1" }, { "DATRIBFLEXDATE2", "", "ZTP_FLEXD2" } }
										ElseIf _w0 == 2 // Adiant Despesas Detalhes Collection
											aFlds := { { "IDSP", ZTP->ZTP_CDIDSP, "ZTP_CDIDSP" },;
											{ "SEQADIANTAMENTO", "", "ZTP_SEQADT" }, { "NUMDOCUMENTO", "", "ZTP_NUMDOC" }, { "CREDOR", "", "ZTP_CODCRE" },;
											{ "CODDESPESA", "", "ZTP_CODDES" }, { "VALORPREVISTO", "", "ZTP_VLRPRV" }, { "VALORREAL", "", "ZTP_VLRREA" },;
											{ "VALORADIANTADO", "", "ZTP_VLRADI" }, { "VALORPAGAR", "", "ZTP_VLRPGT" } }
										ElseIf _w0 == 3 // Adiantamento Pgtos Tipos Collection
											aFlds := { { "IDSP", ZTP->ZTP_CDIDSP, "ZTP_CDIDSP" },;
											{ "CODTIPOPAGTO", "", "ZTP_CTPGTO" }, { "DESCRICAO", "", "ZTP_DSPGTO" } }
										EndIf
										For _w4 := 1 To XMLChildCount(oXml2)
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next
										ZTP->(DbSetOrder(1)) // ZTP_FILIAL + ZTP_CDIDSP
										If ZTP->(!DbSeek( _cFilZTP + PadR(aFlds[01,02],TamSX3("ZTP_CDIDSP")[01]) )) // Ainda nao existe
											RecLock("ZTP",.T.)
											ZTP->ZTP_FILIAL := _cFilZTP
											ZTP->ZTP_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
										ElseIf ZTP->ZTP_STATOT == "01" // Se ainda nao houve nenhum processamento no Totvs, regravo
											RecLock("ZTP",.F.)
										EndIf
										If ZTP->ZTP_STATOT $ "01/03/" // Apenas gravacao se for "01"=Pendente processamento Totvs ou "03"=Em Processamento Totvs
											For _w4 := 1 To Len( aFlds )
												&("ZTP->" + aFlds[_w4,03]) := aFlds[_w4,02] // Gravacoes
											Next
											ZTP->ZTP_XMLENV := cMntXml          				// XML Envio
											ZTP->ZTP_XMLRET := cRetXml          				// XML Retorno
											ZTP->ZTP_DTHRLG := DtoC(Date()) + " " + Time()		// Ex: 08/08/2021 12:00:03
											ZTP->ZTP_USERLG := cUserName						// Ex: "jonathan.sigamat"
											ZTP->(MsUnlock())
										EndIf
										RecLock("ZTN",.F.)
										ZTN->ZTN_STATOT := "05" // "05"=Geracao ZTP realizada com sucesso!
										ZTN->ZTN_DETPR1 := "Dados carregados com sucesso (ZTP)"
										ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
										ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
										ZTN->(MsUnlock())
									EndIf
									// ############## PKG_GEN_PAGAMENTO ######################
									// ############## PRC_IT_CE_OUT_TXT #################
								ElseIf "PRC_IT_CE_OUT_TXT" $ ZT1->ZT1_NOMAPI
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										If _w0 == 1 // Cabecalho
											aFlds := { { "NS2_IDEVENTOCONTABIL", "", "ZTX_IDECTB" }, { "NS2_IDLANCAMENTO", "", "ZTX_IDELAN" },;
											{ "NS2_EMPRESA",  			"", "ZTX_EMPRES" }, { "NS2_DTCONTABIL",			"", "ZTX_DATCON" },;
											{ "NS2_IDEVENTOOIFEXPORT",  "", "ZTX_IDEVEN" }, { "NS2_DTEMISSAODOC",		"", "ZTX_DATEMI" }, { "NS2_TIPODOC",            "", "ZTX_TIPDOC" },;	
											{ "NS2_TEXTODOC",           "", "ZTX_TEXDOC" }, { "NS2_TEXTOCOMPLEMENTAR",	"", "ZTX_TEXCOM" },;
											{ "NS2_MOEDA",				"", "ZTX_NMOEDA" }, { "NS2_TAXACONVERSAO",		"", "ZTX_TXMOED" } }
										ElseIf _w0 == 2 // Itens
											aFlds := { { "NS2_IDEVENTOCONTABIL", ZTX->ZTX_IDECTB, "ZTX_IDECTB" }, { "IDLANCAMENTO", ZTX->ZTX_IDELAN, "ZTX_IDELAN" },;
											{ "NS2_CODPARCEIRO",        "", "ZTX_CODPAR" },;	
											{ "NS2_CONTACONTABIL1",     "", "ZTX_COCON1" }, { "NS2_CONTACONTABIL2",    "", "ZTX_COCON2" },;
											{ "NS2_FLEX1",              "", "ZTX_FLEXF1" }, { "NS2_FLEX2",             "", "ZTX_FLEXF2" }, { "NS2_FLEX3",              "", "ZTX_FLEXF3" },;
											{ "NS2_FLEX4",              "", "ZTX_FLEXF4" }, { "NS2_FLEX5",             "", "ZTX_FLEXF5" },;
											{ "NS2_FLEX6",              "", "ZTX_FLEXF6" }, { "NS2_FLEX7",             "", "ZTX_FLEXF7" },;
											{ "NS2_REFERENCIA1",        "", "ZTX_REFER1" }, { "NS2_REFERENCIA2",       "", "ZTX_REFER2" },;
											{ "NS2_TEXTOITEM",          "", "ZTX_TEXTIT" }, { "NS2_VALORME",           "", "ZTX_VALRME" }, { "NS2_VALORMN",            "", "ZTX_VALRMN" },;
											{ "NS2_MOEDA",              "", "ZTX_MOEDAE" }, { "NS2_TAXACONVERSAO",     "", "ZTX_TAXAMO" } }
										EndIf
										For _w4 := 1 To XMLChildCount(oXml2)
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next
										ZTX->(DbSetOrder(1)) // ZTX_FILIAL + ZTX_IDECTB + ZTX_IDELAN + ZTX_STATOT + ZTX_DTHRLG
										If ZTX->(!DbSeek( _cFilZTX + PadR(aFlds[01,02], 10) + PadR(aFlds[02,02], 10) )) // Ainda nao existe
											RecLock("ZTX",.T.)
											ZTX->ZTX_FILIAL := _cFilZTX
											ZTX->ZTX_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
										ElseIf ZTX->ZTX_STATOT == "01" // Se ainda nao houve nenhum processamento no Totvs, regravo
											RecLock("ZTX",.F.)
										EndIf
										If ZTX->ZTX_STATOT $ "01/03/" // Apenas gravacao se for "01"=Pendente processamento Totvs ou "03"=Em Processamento Totvs
											For _w4 := 1 To Len( aFlds )
												&("ZTX->" + aFlds[_w4,03]) := aFlds[_w4,02] // Gravacoes
											Next
											ZTX->ZTX_XMLENV := cMntXml          // XML Envio
											ZTX->ZTX_XMLRET := cRetXml          // XML Retorno
											ZTX->ZTX_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
											ZTX->ZTX_USERLG := cUserName                       // Ex: "jonathan.sigamat"
											ZTX->(MsUnlock())
										EndIf
										If _w0 == 2 // Gravacao completa
											RecLock("ZTN",.F.)
											ZTN->ZTN_STATOT := "05" // "05"=Geracao ZTX realizada com sucesso!
											ZTN->ZTN_DETPR1 := "Dados carregados com sucesso (ZTX)"
											ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
											ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
											ZTN->(MsUnlock())
										EndIf
									EndIf
									// ############## PRC_IT_CE_OUT_TXT #################
									// ############## PRC_IT_CI_OUT_TXT #################
								ElseIf "PRC_IT_CI_OUT_TXT" $ ZT1->ZT1_NOMAPI
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										If _w0 == 1 // Cabecalho
											
											aFlds := { { "IDEVENTOCONTABIL", "", "ZTY_IDECTB" }, { "IDLANCAMENTO", "", "ZTY_IDELAN" },;
											{ "EMPRESA",  			"", "ZTY_EMPRES" }, { "DTCONTABIL",			"", "ZTY_DATCON" },;
											{ "IDEVENTOOIFEXPORT",  "", "ZTY_IDEVEN" }, { "DTEMISSAODOC",		"", "ZTY_DATEMI" }, { "TIPODOC",            "", "ZTY_TIPDOC" },;	
											{ "TEXTODOC",           "", "ZTY_TEXDOC" }, { "TEXTOCOMPLEMENTAR",	"", "ZTY_TEXCOM" },;
											{ "MOEDA",				"", "ZTY_NMOEDA" }, { "TAXACONVERSAO",		"", "ZTY_TXMOED" },;
											{ "FLEX8",				"", "ZTY_FLEXF8" } }

										ElseIf _w0 == 2 // Itens
											aFlds := { { "IDEVENTOCONTABIL",	ZTY->ZTY_IDECTB, "ZTY_IDECTB" }, { "IDLANCAMENTO",	ZTY->ZTY_IDELAN, "ZTY_IDELAN" },;
											{ "EMPRESA",						ZTY->ZTY_EMPRES, "ZTY_EMPRES" }, { "DTCONTABIL",	ZTY->ZTY_DATCON, "ZTY_DATCON" },;
											{ "IDEVENTOOIFEXPORT",  			ZTY->ZTY_IDEVEN, "ZTY_IDEVEN" }, { "DTEMISSAODOC",	ZTY->ZTY_DATEMI, "ZTY_DATEMI" },;
											{ "TIPODOC",            			ZTY->ZTY_TIPDOC, "ZTY_TIPDOC" }, { "TEXTODOC",      ZTY->ZTY_TEXDOC, "ZTY_TEXDOC" },;
											{ "TEXTOCOMPLEMENTAR",				ZTY->ZTY_TEXCOM, "ZTY_TEXCOM" },;
											{ "ITEMDOC",			"", "ZTY_ITEDOC" },;
											{ "CODPARCEIRO",        "", "ZTY_CODPAR" },;	
											{ "CONTACONTABIL1",     "", "ZTY_COCON1" }, { "CONTACONTABIL2",    "", "ZTY_COCON2" },;
											{ "FLEX1",              "", "ZTY_FLEXF1" }, { "FLEX2",             "", "ZTY_FLEXF2" }, { "FLEX3",              "", "ZTY_FLEXF3" },;
											{ "FLEX4",              "", "ZTY_FLEXF4" }, { "FLEX5",             "", "ZTY_FLEXF5" },;
											{ "FLEX6",              "", "ZTY_FLEXF6" }, { "FLEX7",             "", "ZTY_FLEXF7" },; // { "FLEX8",				"", "_cFlex8" },;
											{ "REFERENCIA1",        "", "ZTY_REFER1" }, { "REFERENCIA2",       "", "ZTY_REFER2" },;
											{ "TEXTOITEM",          "", "ZTY_TEXTIT" }, { "VALORME",           "", "ZTY_VALRME" }, { "VALORMN",            "", "ZTY_VALRMN" },;
											{ "MOEDA",              "", "ZTY_MOEDAE" }, { "TAXACONVERSAO",     "", "ZTY_TAXAMO" },;
											{ "MOEDA",							ZTY->ZTY_NMOEDA, "ZTY_NMOEDA" }, { "TAXACONVERSAO",	ZTY->ZTY_TXMOED, "ZTY_TXMOED" } }

										EndIf
										For _w4 := 1 To XMLChildCount(oXml2)
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next

										ZTY->(DbSetOrder(1)) // Chave Nova: ZTY_FILIAL + ZTY_IDECTB + ZTY_IDELAN + ZTY_ITEDOC + ZTY_STATOT + ZTY_DTHRLG
										// Chave Antiga: ZTY_FILIAL + ZTY_IDECTB + ZTY_IDELAN + ZTY_STATOT + ZTY_DTHRLG
										If _w0 == 1 // Gravacao do cabecalho ZTY

											If ZTY->(!DbSeek( _cFilZTY + PadR(aFlds[01,02], 10) + PadR(aFlds[02,02], 20) )) // Ainda nao existe
												RecLock("ZTY",.T.)
												ZTY->ZTY_FILIAL := _cFilZTY
												ZTY->ZTY_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
											ElseIf ZTY->ZTY_STATOT == "01" // Se ainda nao houve nenhum processamento no Totvs, regravo
												RecLock("ZTY",.F.)
											EndIf

										Else // Gravacao dos detalhes ZTY (itens/etc)
											If ZTY->(DbSeek( _cFilZTY + PadR(aFlds[01,02], 10) + PadR(aFlds[02,02], 20) + PadR(aFlds[10,02], 04))) // Ja existe o Item Doc
												RecLock("ZTY",.F.)
											ElseIf ZTY->(DbSeek( _cFilZTY + PadR(aFlds[01,02], 10) + PadR(aFlds[02,02], 20) + Space(04) )) // Gravou apenas cabecalho ZTY
												RecLock("ZTY",.F.)
											Else
												RecLock("ZTY",.T.)
												ZTY->ZTY_FILIAL := _cFilZTY
												ZTY->ZTY_STATOT := "01"             // "01"=Pendente processamento Totvs      "03"=Em Processamento Totvs      "04"=Falha no processamento Totvs   "02"=Sucesso
											EndIf
										EndIf

										If ZTY->ZTY_STATOT $ "01/03/" // Apenas gravacao se for "01"=Pendente processamento Totvs ou "03"=Em Processamento Totvs
											For _w4 := 1 To Len( aFlds )
												&("ZTY->" + aFlds[_w4,03]) := aFlds[_w4,02] // Gravacoes
											Next
											ZTY->ZTY_XMLENV := cMntXml          // XML Envio
											ZTY->ZTY_XMLRET := cRetXml          // XML Retorno
											ZTY->ZTY_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
											ZTY->ZTY_USERLG := cUserName                       // Ex: "jonathan.sigamat"
											ZTY->(MsUnlock())
										EndIf
										
										If _w0 == 2 .And. ZTY->ZTY_STATOT $ "01/03/" // Gravacao completa
											RecLock("ZTN",.F.)
											ZTN->ZTN_STATOT := "05" // "05"=Geracao ZTY realizada com sucesso!
											ZTN->ZTN_DETPR1 := "Dados carregados com sucesso (ZTY)"
											ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
											ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
											ZTN->(MsUnlock())
										EndIf
										
										_cFlex8 := ""
										
									EndIf
									// ############## PRC_IT_CI_OUT_TXT #################
									// ############## PKG_SFW_MOEDA.PRC_MOEDA_TAXA #################
								ElseIf "PKG_SFW_MOEDA.PRC_MOEDA_TAXA" $ ZT1->ZT1_NOMAPI
									oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
									If ValType(oXml2) == "O"
										If _w0 == 1 // Itens
											aFlds := { { "CODMOEDAORIGEM", "", "" }, { "CODMOEDADESTINO", "", "" }, { "CODCATEGORIA", "", "" },;
													   { "DATAVIGENCIAINICIAL", "", "" }, { "DATAVIGENCIAFINAL", "", "" }, { "TAXACONVERSAO", "", "" } }
										EndIf
										For _w4 := 1 To XMLChildCount(oXml2) // Rodo nos campos
											cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
											If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
												aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
											EndIf
										Next
										SM2->(DbSetOrder(1)) // DtoS(M2_DATA)
										If SM2->(DbSeek( StrTran(Left(aFlds[ 04, 02 ],10),"-","") )) // Atualizar SM2
											RecLock("SM2",.F.)
										Else // Criar SM2
											RecLock("SM2",.T.)
											SM2->M2_DATA := StrTran(Left(aFlds[ 04, 02 ],10),"-","")
										EndIf
										If aFlds[01,02] == "USD" // Dolar
											SM2->M2_MOEDA2 := Val(aFlds[ 06, 02 ])
										Else // Euro
											SM2->M2_MOEDA4 := Val(aFlds[ 06, 02 ])
										EndIf
										SM2->(MsUnlock())
									EndIf
									// ############## PKG_SFW_MOEDA.PRC_MOEDA_TAXA #################
								EndIf
								If !Empty( cHldObj ) // Matriz de objetos
									If _w3 < Len( &(cHldObj) )
										cObj := cHldOld // Volto o objeto antigo (antes da matriz)
										_w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
										
										If "PRC_IT_CI_OUT_TXT" $ ZT1->ZT1_NOMAPI // Teste
											Exit
										EndIf

									Else // Ja processou todos
										If _w0 >= Len( aXmls ) // TESTE
											aRet[01] := .T.
										EndIf
									EndIf
								Else // Nao tem matriz de objetos		If _w0 == Len( aXmls )
									aRet[01] := .T.
								EndIf
								If aRet[01] // .T.=Ja concluido
									_w1 := Len(aXml) + 1
								EndIf
							EndIf
							Exit
						EndIf
						_w2++
					End
					_w1++
				End
			Next
		EndIf
	EndIf
	If "OIFEXPORT" $ ZT1->ZT1_NOMAPI .Or. "PKG_PRC_ADIANT_DESPESA" $ ZT1->ZT1_NOMAPI .Or. "PRC_IT_CE_OUT_TXT" $ ZT1->ZT1_NOMAPI .Or. "PRC_IT_CI_OUT_TXT" $ ZT1->ZT1_NOMAPI // Consultas de notificacoes, mesmo vazias retorno sempre .T.
		aRet[01] := .T. // Sempre retorno .T. (sem nao tiver nada nao retornar .F.)
	EndIf
	aRet[03] := cRetXml
	If aRet[01] // .T.=Sucesso
		cMsg02 += " Sucesso!"
	Else
		cMsg02 += " Falha!"
	EndIf
	cMsg03 := cRetXml
	If nMsgPrc == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, Iif(aRet[01], "OK", "UPDERROR"))
			Sleep(Iif(aRet[01], 200, 800))
		Next
	EndIf
	ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Integrando (HttpPost)... Sucesso!")
	VarInfo("WebPage", cRetXml)
Else // Sem retorno
	ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Integrando (HttpPost)... Retorno nao identificado!")
	VarInfo("Header", cRetXml)
EndIf
ConOut("WsGnrc15: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return aRet // { .T./.F., Nil, cPostRet }



User Function ReproZTY() // Reprocessamento temporario do ZTY corrigindo FLEX8 conforme XML
Local nErr := 0
Local nDif := 0
Local nCor := 0

DbSelectArea("ZTY")
ZTY->(DbSetOrder(1)) // ZTY_FILIAL + ZTY_IDECTB + ZTY_IDELAN + ZTY_IDEDOC + ZTY_STATOT + ZTY_DTHRLG
ZTY->(DbGotop())

/*
<?xml version='1.0' encoding='UTF-8'?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><getContabilizacaoResponse xmlns="http://pkgcicontabilizacao.cambiosys.service.sfw.com.br">
<CiCtbHeader><dataHoraLancamento>2022-08-29T15:33:27Z</dataHoraLancamento><dtContabil>2022-08-26T00:00:00Z</dtContabil>
<dtEmissaoDoc>2022-08-26T00:00:00Z</dtEmissaoDoc><dtEnvio>2022-08-29T18:33:27Z</dtEnvio><dtTransacao>2022-08-26T00:00:00Z</dtTransacao><empresa>1101</empresa>
<entidade>Contrato</entidade><estorno>N</estorno><flex1>186</flex1><flex8>284</flex8><idChave>186</idChave><idEventoContabil>2</idEventoContabil>
<idEventoOifExport>6012</idEventoOifExport><idGrupoLancamento>444</idGrupoLancamento><idLancamento>224</idLancamento><mesExercicio>08</mesExercicio><moeda>USD</moeda>
<referencia1>201</referencia1><referencia2>02-0047/22</referencia2><taxaConversao>5.119</taxaConversao><textoComplementar>Contrato de Cรขmbio </textoComplementar>
<textoDoc>CONTRATO</textoDoc><tipoDoc>D</tipoDoc><tipoRegistro>10</tipoRegistro><tipoTransacao>I</tipoTransacao><ciCtbItemCollection><ciCtbItem><chaveLancamento>IT</chaveLancamento>
<codParceiro>F1107088001</codParceiro><contaContabil1>001</contaContabil1><contaContabil2>090019242</contaContabil2><empresa>1101</empresa><entidade>PARCELA</entidade>
<flex1>STECK CD</flex1><flex2>1107</flex2><flex3>186</flex3><flex5>745</flex5><flex7>1101.000201</flex7><flex8>1101</flex8><idEntidade>1401</idEntidade><idLancamento>224</idLancamento>
<itemDoc>1</itemDoc><referencia1>201</referencia1><referencia2>02-0047/22</referencia2><textoItem>FATURA: 201</textoItem><tipoRegistro>20</tipoRegistro><valorMe>15322.83</valorMe>
<valorMn>78437.57</valorMn></ciCtbItem><ciCtbItem><chaveLancamento>IT</chaveLancamento><codParceiro>F1107088001</codParceiro><contaContabil1>001</contaContabil1>
<contaContabil2>090019242</contaContabil2><empresa>1101</empresa><entidade>PARCELA</entidade><flex1>STECK CD</flex1><flex2>1107</flex2><flex3>186</flex3><flex5>745</flex5>
<flex7>1101.000232</flex7><flex8>1101</flex8><idEntidade>1402</idEntidade><idLancamento>224</idLancamento><itemDoc>2</itemDoc><referencia1>201</referencia1>
<referencia2>02-0047/22</referencia2><textoItem>FATURA: 201</textoItem><tipoRegistro>20</tipoRegistro><valorMe>4691.24</valorMe><valorMn>24014.46</valorMn></ciCtbItem><ciCtbItem>
<chaveLancamento>IT</chaveLancamento><codParceiro>F1107088001</codParceiro><contaContabil1>001</contaContabil1><contaContabil2>090019242</contaContabil2><empresa>1101</empresa>
<entidade>PARCELA</entidade><flex1>STECK CD</flex1><flex2>1107</flex2><flex3>186</flex3><flex5>745</flex5><flex7>1101.000277</flex7><flex8>1101</flex8><idEntidade>1403</idEntidade>
<idLancamento>224</idLancamento><itemDoc>3</itemDoc><referencia1>201</referencia1><referencia2>02-0047/22</referencia2><textoItem>FATURA: 201</textoItem><tipoRegistro>20</tipoRegistro>
<valorMe>884799.62</valorMe><valorMn>4529289.25</valorMn></ciCtbItem><ciCtbItem><chaveLancamento>IT</chaveLancamento><codParceiro>F1107088001</codParceiro><contaContabil1>001</contaContabil1>
<contaContabil2>090019242</contaContabil2><empresa>1101</empresa><entidade>PARCELA</entidade><flex1>STECK CD</flex1><flex2>1107</flex2><flex3>186</flex3><flex5>745</flex5><flex7>1101.000298</flex7>
<flex8>1101</flex8><idEntidade>1404</idEntidade><idLancamento>224</idLancamento><itemDoc>4</itemDoc><referencia1>201</referencia1><referencia2>02-0047/22</referencia2><textoItem>FATURA: 201</textoItem>
<tipoRegistro>20</tipoRegistro><valorMe>8317.01</valorMe><valorMn>42574.77</valorMn></ciCtbItem><ciCtbItem><chaveLancamento>IT</chaveLancamento><codParceiro>F1107088001</codParceiro>
<contaContabil1>001</contaContabil1><contaContabil2>090019242</contaContabil2><empresa>1101</empresa><entidade>PARCELA</entidade><flex1>STECK CD</flex1><flex2>1107</flex2><flex3>186</flex3>
<flex5>745</flex5><flex7>1101.000303</flex7><flex8>1101</flex8><idEntidade>1405</idEntidade><idLancamento>224</idLancamento><itemDoc>5</itemDoc><referencia1>201</referencia1><referencia2>02-0047/22</referencia2>
<textoItem>FATURA: 201</textoItem><tipoRegistro>20</tipoRegistro><valorMe>22558.84</valorMe><valorMn>115478.7</valorMn></ciCtbItem></ciCtbItemCollection></CiCtbHeader></getContabilizacaoResponse>
</S:Body></S:Envelope>
*/

While ZTY->(!EOF())
	If ZTY->ZTY_STATOT == "01" // "01"=Pendente de processamento
		If ZTY->ZTY_TIPDOC == PadR("D",20) // "D"=Despesa
			If Empty(ZTY->ZTY_CHVADT) .And. Empty(ZTY->ZTY_CHVDES) .And. Empty(ZTY->ZTY_CHVBXA) // Nenhuma chave de registro gravada
				If .T. // ZTY->ZTY_FLEXF8 == PadR("1101",20) // Gravado incorretamente a EMPRESA + FILIAL
					cXML := ZTY->ZTY_XMLRET
					If (nFnd := At("<FLEX8>",Upper(cXML))) > 0 // Encontro o primeiro '<Flex8>'
						nFnd2 := At("</FLEX8>",Upper(SubStr(cXML,nFnd,20)))
						cDado := SubStr(cXML,nFnd + 7,nFnd2 - 8)
						If cDado == "1101" // Flex08 do cabecalho nao existe ou esta errado
							nErr++
							RecLock("ZTY",.F.)
							ZTY->ZTY_FLEXF8 := cDado
							ZTY->(MsUnlock())
						Else
							If PadR(cDado,20) <> ZTY->ZTY_FLEXF8 // Flex8 diferente
								nDif++
								RecLock("ZTY",.F.)
								ZTY->ZTY_FLEXF8 := cDado
								ZTY->(MsUnlock())
							Else // Ja estava correto
								nCor++
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	ZTY->(DbSkip())
End
MsgInfo("Avaliacoes:" + Chr(13) + Chr(10) + ;
"Cabec Errado (1101): " + cValToChar(nErr) + Chr(13) + Chr(10) + ;
"Diferentes: " + cValToChar(nDif) + Chr(13) + Chr(10) + ;
"Corretos: " + cValToChar(nCor),"ReproZTY")
Return
