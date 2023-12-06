#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STREST70        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL baixaNf DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Baixar nota fiscal do romaneio" WSSYNTAX "/rest/baixaNf"

END WSRESTFUL

WSMETHOD POST WSSERVICE baixaNf

	Local cResp 	:= "ERRO"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cUser 	:= __cUserId
	Local _lErro   	:= .F.
	Local nTimeOut1 	:= 60
	Local aHeadOut1 	:= {}
	Local cHeadRet1 	:= ""
	Local _lFinaliz		:= .F.
	Local nTimeOut 	:= 120
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}
	Local cAviso	:= ""
	Local cErro		:= ""

	ConOut("[STREST70]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STREST70]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If _lRet

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT PD2.R_E_C_N_O_ RECPD2,
		_cQuery1 += " (
		_cQuery1 += " SELECT COUNT(*) CONTADOR
		_cQuery1 += " FROM "+RetSqlName("PD2")+" PD2
		_cQuery1 += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_NFS='"+oInfo:INFORMACOES:NOTA+"'
		_cQuery1 += " AND PD2_CODROM<>'"+oInfo:INFORMACOES:ROMANEIO+"'
		_cQuery1 += " ) CONTADOR
		_cQuery1 += " FROM "+RetSqlName("PD2")+" PD2
		_cQuery1 += " WHERE PD2.D_E_L_E_T_=' '
		_cQuery1 += " AND PD2_CODROM='"+oInfo:INFORMACOES:ROMANEIO+"' AND PD2_NFS='"+oInfo:INFORMACOES:NOTA+"'
		_cQuery1 += " ) XXX

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		DbSelectArea("PD2")

		If (_cAlias1)->(!Eof())

			PD2->(DbGoTo((_cAlias1)->RECPD2))

			If PD2->(!Eof())

				If AllTrim(PD2->PD2_STATUS)=="5" .And. (_cAlias1)->CONTADOR>0 //Não entregue
					_lErro := .T.
					cResp := "Nota nao entregue e consta em outro romaneio, entre em contato com a administracao!"
				EndIf

				_cTitulo := ""

				If !_lErro

					PD2->(RecLock("PD2",.F.))
					If AllTrim(oInfo:INFORMACOES:TIPO)=="1"
						PD2->PD2_STATUS := "4"
						PD2->PD2_MOTIVO := ""
						_cTitulo := "NF "+AllTrim(PD2->PD2_NFS)+" entregue com sucesso"
					ElseIf AllTrim(oInfo:INFORMACOES:TIPO)=="3"
						PD2->PD2_STATUS := "5"
						PD2->PD2_MOTIVO := oInfo:INFORMACOES:MOTIVO
						_cTitulo := "NF "+AllTrim(PD2->PD2_NFS)+" não foi entregue hoje

						If AllTrim(oInfo:INFORMACOES:MOTIVO)=="6. Outros"
							PD2->PD2_MOT2 := oInfo:INFORMACOES:MOTIVO2
						EndIf

						DbSelectArea("CB7")
						CB7->(DbSetOrder(4))
						If CB7->(DbSeek(PD2->(PD2_FILIAL+PD2_NFS+PD2_SERIES)))
							CB7->(RecLock("CB7",.F.))
							CB7->CB7_STATUS := "8"
							CB7->(MsUnLock())
						EndIf

					EndIf

					DbSelectArea("SD2")
					SD2->(DbSetOrder(3))
					If SD2->(DbSeek(PD2->(PD2_FILIAL+PD2_NFS+PD2_SERIES)))
						DbSelectArea("SC5")
						SC5->(DbSetOrder(1))
						If SC5->(DbSeek(SD2->(D2_FILIAL+D2_PEDIDO)))

							If !Empty(SC5->C5_XAVENT)

								_cEmail		:= AllTrim(SC5->C5_XAVENT)
								_cAssunto 	:= "[WFPROTHEUS] - "+_cTitulo

								cMsg := ""
								cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
								cMsg += '<b>Nota fiscal: </b>'+Alltrim(PD2->PD2_NFS)+'<br>
								cMsg += '<b>Motivo: </b>'+AllTrim(PD2->PD2_MOTIVO)+'<br>
								cMsg += '</body></html>'

								U_STMAILTES(_cEmail,"",_cAssunto, cMsg,{},"")

							EndIf

						EndIf
					EndIf

					PD2->PD2_XDTBX := Date()
					PD2->PD2_XHRBX := Time()
					PD2->PD2_XUSBX := UsrRetName(_cUser)
					PD2->PD2_XLAT	:= oInfo:INFORMACOES:LATITUDE
					PD2->PD2_XLON	:= oInfo:INFORMACOES:LONGITUDE
					PD2->(MsUnLock())

				EndIf

				//Se todas as notas foram bipadas, marcar como fechado
				DbSelectArea("PD1")
				PD1->(DbSetOrder(1))
				If PD1->(DbSeek(PD2->(PD2_FILIAL+PD2_CODROM)))

					_nTotNfs := 0
					_nTotEnt := 0

					PD2->(DbSetOrder(1))
					PD2->(DbSeek(PD1->(PD1_FILIAL+PD1_CODROM)))
					While PD2->(!Eof()) .And. PD2->(PD2_FILIAL+PD2_CODROM)==PD1->(PD1_FILIAL+PD1_CODROM)
						_nTotNfs++
						If AllTrim(PD2->PD2_STATUS)$"4#5"
							_nTotEnt++
						EndIf
						PD2->(DbSkip())
					EndDo

					If _nTotNfs==_nTotEnt

						_lFinaliz := .T.

						PD1->(RecLock("PD1",.F.))
						PD1->PD1_STATUS := "5"
						PD1->PD1_XDTRF	:= Date() //Rota finalizada
						PD1->PD1_XHRRF	:= Time()
						PD1->PD1_XLAT	:= oInfo:INFORMACOES:LATITUDE
						PD1->PD1_XLON	:= oInfo:INFORMACOES:LONGITUDE
						PD1->(MsUnLock())

						_cEmail   := GetMv("STREST701",.F.,"renato.oliveira@steck.com.br;kleber.braga@steck.com.br;")
						_cCopia	  := ""
						_cAssunto := "[PROTHEUS] - Romaneio "+PD1->PD1_CODROM+" com rota finalizada
						_aAttach  := {}
						_cCaminho := ""

						_cLocaliz := ""

						/*
						_cUrlGoog 	:= "https://maps.google.com/maps/api/geocode/json
						_cParam 	:= "latlng="+AllTrim(PD1->PD1_XLAT)+","+AllTrim(PD1->PD1_XLON)+"&key="+escape(AllTrim(GetMv("ST_KEYGOOG",,"")))
						_cParam 	:= EncodeUTF8(_cParam)
						cHttpGet1 	:= HttpSGet(_cUrlGoog,"","","",_cParam,nTimeOut1,aHeadOut1,@cHeadRet1)
						oInfo 	  	:= ""
						_lRet     	:= FWJsonDeserialize(cHttpGet1,@oInfo)

						If Type("oInfo:RESULTS[1]:FORMATTED_ADDRESS")=="C"
						_cLocaliz := oInfo:RESULTS[1]:FORMATTED_ADDRESS
						EndIf
						*/

						_cTicGeoP	:= AllTrim(GetMv("ST_TIKGEOP",,"9C6EC80A-CB87-46A6-8700-F772B6B96819"))
						cUrl := "https://www.geoportal.com.br/xgeocoder/xRevGeocode.aspx?Ticket="+_cTicGeoP+"&x="+AllTrim(PD1->PD1_XLON)+"&y="+AllTrim(PD1->PD1_XLAT)

						cHttpGet := HttpSGet(cUrl,"","","","",nTimeOut,aHeadOut,@cHeadRet)
						oXml := XmlParser(cHttpGet,"_",@cAviso,@cErro)

						If Type("oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_RUA:TEXT")=="C"
							_cLocaliz := AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_RUA:TEXT)+", "
							_cLocaliz += AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_NROPROX:TEXT)+" - "
							_cLocaliz += AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_BAIRRO:TEXT)+" - "
							_cLocaliz += AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_CIDADE:TEXT)+" - "
							_cLocaliz += AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_ESTADO:TEXT)+" - "
							_cLocaliz += AllTrim(oXml:_SERVGEOPORTAL:_SEGMENTO:_LOCALIDADE:_CEP:TEXT)
						EndIf

						cMsg := ""
						cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
						cMsg += '<b>Romaneio: </b>'+PD1->PD1_CODROM+'<br>'
						cMsg += '<b>Hora: </b>'+Time()+'<br>'
						cMsg += '<b>Qtde NFS: </b>'+cValToChar(_nTotNfs)+'<br>'
						cMsg += '<b>Placa: </b>'+PD1->PD1_PLACA+'<br>'
						cMsg += '<b>Motorista: </b>'+PD1->PD1_MOTORI+'<br>'
						cMsg += '<b>Ajudante1: </b>'+PD1->PD1_AJUDA1+'<br>'
						cMsg += '<b>Ajudante2: </b>'+PD1->PD1_AJUDA2+'<br>'
						cMsg += '<b>Rota: </b>'+PD1->PD1_XROTA+'<br>'
						cMsg += '<b>Localização: </b>'+_cLocaliz+'<br><br>'

						cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
						cMsg += '<TR BgColor=#91b1c4><B><TD>Nota Fiscal</TD><TD>Peso Bruto</TD><TD>Qtde Vol</TD><TD>Valor</TD><TD>Status</TD><TD>Motivo</TD><TD>Outros</TD></B></TR>'

						_nLin := 0

						PD2->(DbSeek(PD1->(PD1_FILIAL+PD1_CODROM)))
						While PD2->(!Eof()) .And. PD2->(PD2_FILIAL+PD2_CODROM)==PD1->(PD1_FILIAL+PD1_CODROM)

							_nLin++

							If (_nLin/2) == Int( _nLin/2 )
								cMsg += '<TR BgColor=#B0E2FF>'
							Else
								cMsg += '<TR BgColor=#FFFFFF>'
							EndIf

							cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + PD2->PD2_NFS + ' </Font></TD>'
							cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(PD2->PD2_PBRUTO) + ' </Font></TD>'
							cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cValToChar(PD2->PD2_QTDVOL) + ' </Font></TD>'
							cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cValToChar(Posicione("SF2",1,PD2->(PD2_FILIAL+PD2_NFS+PD2_SERIES+PD2_CLIENT+PD2_LOJCLI),"F2_VALBRUT")) + ' </Font></TD>'
							cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + GetStNf(PD2->PD2_STATUS) + ' </Font></TD>'
							cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + AllTrim(PD2->PD2_MOTIVO) + ' </Font></TD>'
							cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + AllTrim(PD2->PD2_MOT2) + ' </Font></TD>'
							cMsg += '</TR>'

							PD2->(DbSkip())
						EndDo

						cMsg += '</Table>'
						cMsg += '</body></html>'

						U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

					EndIf

				EndIf

			EndIf

		Else

			_lErro := .T.
			cResp := "Nota nao encontrada, entre em contato com o TI"

		EndIf

	Else

		_lErro := .T.
		cResp := "Erro ao converter Json, entre em contato com o TI"

	EndIf

	If !_lErro
		cResp := "OK"
		If _lFinaliz
			cResp := "FINALIZADA"
		EndIf
	EndIf

	ConOut("[STREST70]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.

Static Function GetStNf(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
		Case _cStatus=="3"
		_cDesc := "Pendente entrega"
		Case _cStatus=="4"
		_cDesc := "Entregue"
		Case _cStatus=="5"
		_cDesc := "Não entregue"
	EndCase

Return(_cDesc)