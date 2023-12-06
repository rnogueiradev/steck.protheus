#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTD0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL setCheckSup DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Gravar aprovação da supervisão" WSSYNTAX "/rest/setCheckSup"

END WSRESTFUL

WSMETHOD POST WSSERVICE setCheckSup

	Local cResp 	:= "Romaneio nao encontrado, entre em contato com o TI!"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _nX 		:= 0
	Local _cUser 	:= __cUserId
	Local _cCheck	:= ""
	Local _cStatus	:= ""

	ConOut("[STRESTD0]["+ FWTimeStamp(2) +"] - Usuario "+_cUser+" realizou o acesso.")
	ConOut("[STRESTD0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	If !(_cUser $ GetMv("STRESTD01",,"000677"))
		cResp := 'Seu usuario nao esta cadastrado como supervisor e nao sera possivel liberar o romaneio!'
		::SetResponse(cResp)
		ConOut("[STRESTD0]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)
		Return .T.
	EndIf

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	DbSelectArea("PD1")
	PD1->(DbSetOrder(1))

	If _lRet

		If PD1->(DbSeek(xFilial("PD1")+oInfo:INFORMACOES:ROMANEIO))
		
			_cCheck    := AllTrim(PD1->PD1_XCHKV)
			_cCheckO   := AllTrim(PD1->PD1_XCHKVO)

			PD1->(RecLock("PD1",.F.))
			If AllTrim(oInfo:INFORMACOES:STATUS)=="A"
			
				_cStatus := "aprovado"
				
				PD1->PD1_XCONF 	:= Date()
				PD1->PD1_XCONFH := Time()
				PD1->PD1_XUSCH3 := UsrRetName(_cUser)
				PD1->PD1_STATUS := "4" //em rota

				DbSelectArea("PD2")
				PD2->(DbSetOrder(1))
				PD2->(DbGoTop())
				If PD2->(DbSeek(PD1->(PD1_FILIAL+PD1_CODROM)))
					While PD2->(!Eof()) .And. PD1->(PD1_FILIAL+PD1_CODROM)==PD2->(PD2_FILIAL+PD2_CODROM)
						PD2->(RecLock("PD2",.F.))
						PD2->PD2_STATUS := "3"
						PD2->(MsUnLock())
						PD2->(DbSkip())
					EndDo				
				EndIf

			Else
			
				_cStatus := "reprovado"
				
				PD1->PD1_XDTCH1 := CTOD("  /  /    ")
				PD1->PD1_XHRCH1 := ""
				PD1->PD1_XUSCH1 := ""
				PD1->PD1_XDTCH2 := CTOD("  /  /    ")
				PD1->PD1_XHRCH2 := ""
				PD1->PD1_XUSCH2 := ""
				PD1->PD1_XCHKV	:= ""
				PD1->PD1_XCHKVO	:= ""
				PD1->PD1_XCONF 	:= CTOD("  /  /    ")
				PD1->PD1_XCONFH := ""
				PD1->PD1_XUSCH3 := ""
			EndIf
			PD1->(MsUnLock())

			_cEmail   := SuperGetMv("STRESTC01",.F.,"renato.oliveira@steck.com.br")
			_cCopia	  := ""
			_cAssunto := "[PROTHEUS] - Romaneio "+PD1->PD1_CODROM+" "+_cStatus 
			_aAttach  := {}
			_cCaminho := ""

			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Romaneio: </b>'+PD1->PD1_CODROM+'<br>'
			cMsg += '<b>Data alerta: </b>'+DTOC(Date())+'<br>'
			cMsg += '<b>Hora alerta: </b>'+Time()+'<br>'
			cMsg += '<b>Usuário: </b>'+UsrRetName(_cUser)+'<br>'
			cMsg += '<b>Placa: </b>'+PD1->PD1_PLACA+'<br>'

			_cAlertasD := ""

			For _nX := 1 to Len(_cCheck)

				If SubStr(_cCheck,_nX,1)=="F"
					Do Case
						Case _nX==1
						_cAlertasD += "Cinto de seguranca / "
						Case _nX==2
						_cAlertasD += "Retrovisores / "
						Case _nX==3
						_cAlertasD += "Limpeza externa/interna / "
						Case _nX==4
						_cAlertasD += "Farois / "
						Case _nX==5
						_cAlertasD += "Setas e buzina / "
						Case _nX==6
						_cAlertasD += "Freio / "
						Case _nX==7
						_cAlertasD += "Freio de mao / "
						Case _nX==8
						_cAlertasD += "Limpador de para-brisas / "
						Case _nX==9
						_cAlertasD += "Lampadas internas / "
						Case _nX==10
						_cAlertasD += "Ruidos anormais / "
						Case _nX==11
						_cAlertasD += "Funcionamento painel / "
						Case _nX==12
						_cAlertasD += "Estado das portas / "
						Case _nX==13
						_cAlertasD += "Estados dos vidros / "
						Case _nX==14
						_cAlertasD += "Nivel agua e oleo motor/radiador / "
						Case _nX==15
						_cAlertasD += "Lacre das placas / "
						Case _nX==16
						_cAlertasD += "Estepe/chave de roda/triangulo / "
						Case _nX==17
						_cAlertasD += "Calibragem dos pneus / "
						Case _nX==18
						_cAlertasD += "Suspensao/molas/amortecedor / "
						Case _nX==19
						_cAlertasD += "Estado da direcao e oleo / "
						Case _nX==20
						_cAlertasD += "Bancos e estofados / "
						Case _nX==21
						_cAlertasD += "Nivel do arla / "
						Case _nX==22
						_cAlertasD += "Estado do carrinho de mao / "
						Case _nX==23
						_cAlertasD += "Capacetes/colete/capa de chuva / "
						Case _nX==24
						_cAlertasD += "Teclado positron/gps/mensagem / "
						Case _nX==25
						_cAlertasD += "Disco de tacografo / "
					EndCase
				EndIf					

			Next

			//_cAlertasD += AllTrim(PD1->PD1_XCHKVO)

			cMsg += '<b>Alertas da lista: </b>'+_cAlertasD+'<br><br>'
			cMsg += '<b>Outros alertas: </b>'+_cCheckO
			cMsg += '</body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			cResp := 'OK'

		EndIf

	Else

		cResp := 'Erro ao converter o JSON, entre em contato com o TI'

	EndIf

	ConOut("[STRESTD0]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.
