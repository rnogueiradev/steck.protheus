#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSLOTE	ºAutor  ³Renato Nogueira     º Data ³  03/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para verificar as notas emitidas contra o	  º±±
±±º          ³cliente que ainda não foram manifestadas 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*******************************************
<<< ALTERAÇÃO >>> 
Ação...........: Receber via parâmetro a Empresa e Filial.
...............: Lembrar de incluir na chamada do appserver.ini a empresa e a filial. 
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: VIRADA APOEMA NEWCO DISTRIBUIDORA
*******************************************/
User Function STNFS01(_xcEmp,_xcFil)
	Local cXml			:= ""
	Local cSchema		:= ""
	Local cErro			:= ""
	Local cAviso		:= ""
	Local cSvcError		:= ""
	Local cSoapFCode	:= ""
	Local cSoapFDescr	:= ""
	Local lRet			:= .F.
	Local cAnexo		:= ""
	Local cDir	  		:= GetSrvProfString("startpath","")+"xml\"
	Local aRet 			:= {}
	Local aParamBox 	:= {}
	Local aCombo 		:= {}
	Local _oWSTeste
	Local cDir	  		:= GetSrvProfString("startpath","")+"xml\"
	Local nCount		:= 0
	Local aChaves		:= {}
	Local nX			:= 0
	Local nY			:= 0
	Local cCnpjCor		:= ""
	Local cUfCor		:= ""
	Local aArea			:= {}
	Local aMonitor		:= {}
	Local lContinua		:= .T.
	Local nCount		:= 0
	Local aDados		:= {}
	Local cStatusAtu	:= ""
	Local _cIdEnt		:= ""
	Local _cPass		:= ""
	Local _nHTent0		:= 1
	Local _nMTent0		:= 10
	Local _nHTent1		:= 0
	Local _nMTent1		:= 5
	Local _lRet			:= .T.
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos      := SUBSTR(cTime, 4, 2)
	//Local cMinutos      := Iif(VAL(SUBSTR(cTime, 4, 2))+2 > 59, '02', strzero((VAL(SUBSTR(cTime, 4, 2))+2),2))
	Local cSegundos     := SUBSTR(cTime, 7, 2)
	Local _nHix         := 0
	Local _nHfx         := 0

	/*******************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Receber via parâmetro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: VIRADA APOEMA NEWCO DISTRIBUIDORA
	Local cNewEmp := '01'
	Local cNewFil	:= '04'
	*******************************************/
	LOCAL cNewEmp := _xcEmp
	LOCAL cNewFil	:= _xcFil

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	aArea	:= GetArea()

	cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

	RestArea(aArea)

	DO CASE
	CASE cUf=="AC"
		cUf	:= "12"
	CASE cUf=="AL"
		cUf	:= "27"
	CASE cUf=="AM"
		cUf	:= "13"
	CASE cUf=="AP"
		cUf	:= "16"
	CASE cUf=="BA"
		cUf	:= "29"
	CASE cUf=="CE"
		cUf	:= "23"
	CASE cUf=="DF"
		cUf	:= "53"
	CASE cUf=="ES"
		cUf	:= "32"
	CASE cUf=="GO"
		cUf	:= "52"
	CASE cUf=="MA"
		cUf	:= "21"
	CASE cUf=="MG"
		cUf	:= "31"
	CASE cUf=="MS"
		cUf	:= "50"
	CASE cUf=="MT"
		cUf	:= "51"
	CASE cUf=="PA"
		cUf	:= "15"
	CASE cUf=="PB"
		cUf	:= "25"
	CASE cUf=="PE"
		cUf	:= "26"
	CASE cUf=="PI"
		cUf	:= "22"
	CASE cUf=="PR"
		cUf	:= "41"
	CASE cUf=="RJ"
		cUf	:= "33"
	CASE cUf=="RN"
		cUf	:= "24"
	CASE cUf=="RO"
		cUf	:= "11"
	CASE cUf=="RR"
		cUf	:= "14"
	CASE cUf=="RS"
		cUf	:= "43"
	CASE cUf=="SC"
		cUf	:= "42"
	CASE cUf=="SE"
		cUf	:= "28"
	CASE cUf=="SP"
		cUf	:= "35"
	CASE cUf=="TO"
		cUf	:= "17"
	ENDCASE

	cInd		:= "1"
	cUltNsu		:= '' //GETMV("ST_NSU",,"0")//STRETNSU()
	//CONOUT("XXXXX"+cUltNsu )
	cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
	cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)
	_oWsTeste := WSNFsConsultaDest():New()

	_cIdEnt := U_XGETIND(cCnpj,"1")
	_cPass  := U_XGETIND(cCnpj,"2")

	/*******************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Buscar no parâmetro MV_XCERTS o endereço do Certificado.
	...............: Anteriormente estava chumbado.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: VIRADA APOEMA NEWCO DISTRIBUIDORA
	_oWsTeste:_CERT			:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_all.pem"
	_oWsTeste:_PRIVKEY		:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_key.pem"
	*******************************************/
	_oWsTeste:_CERT				:= GETMV("MV_XCERTS")+_cIdEnt+"_all.pem"
	_oWsTeste:_PRIVKEY		:= GETMV("MV_XCERTS")+_cIdEnt+"_key.pem"
	_oWsTeste:_PASSPHRASE	:= _cPass

	If msgyesno("baixa?")
		//cSchema	:= '<?xml version="1.0" encoding="UTF-8"?>'
		cSchema	+= '<p1:PedidoConsultaNFePeriodo xmlns:p1="http://www.prefeitura.sp.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		cSchema	+= '<Cabecalho Versao="1">
		cSchema	+= '<CPFCNPJRemetente>
		cSchema	+= '<CNPJ>05890658000482</CNPJ>
		cSchema	+= '</CPFCNPJRemetente>
		cSchema	+= '<CPFCNPJ>
		cSchema	+= '<CNPJ>45587763000119</CNPJ>
		cSchema	+= '</CPFCNPJ>
		cSchema	+= '<Inscricao>44756283</Inscricao>
		cSchema	+= '<dtInicio>2017-03-01</dtInicio>
		cSchema	+= '<dtFim>2017-03-31</dtFim>
		cSchema	+= '<NumeroPagina>1</NumeroPagina>
		cSchema	+= '</Cabecalho>
		cSchema	+= '</p1:PedidoConsultaNFePeriodo>
		cSchema	:=	u_xSignXMLA1(cSchema,'p1:PedidoConsultaNFePeriodo',"Id",_cIdEnt)
		cSchema	+= '</p1:PedidoConsultaNFePeriodo>
	Else
		//cSchema	:= '<?xml version="1.0" encoding="UTF-8"?>
		cSchema	+= '<p1:PedidoConsultaCNPJ xmlns:p1="http://www.prefeitura.sp.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		cSchema	+= '<Cabecalho Versao="1">
		cSchema	+= '<CPFCNPJRemetente>
		cSchema	+= '<CNPJ>05890658000482</CNPJ>
		cSchema	+= '</CPFCNPJRemetente>
		cSchema	+= '</Cabecalho>
		cSchema	+= '<CNPJContribuinte>
		cSchema	+= '<CNPJ>05890658000482</CNPJ>
		cSchema	+= '</CNPJContribuinte>
		cSchema	+= '</p1:PedidoConsultaCNPJ>
		cSchema	:=	u_xSignXMLA1(cSchema,'p1:PedidoConsultaCNPJ',"Id",_cIdEnt)
		cSchema	+= '</p1:PedidoConsultaCNPJ>
	EndIf




	oXml := XmlParser(cSchema,"_",@cErro,@cAviso)

	_oWSTeste:cversaoDados	:= "1.01"
	_oWSTeste:ccUF			:= cUf
	_oWSTeste:oWS			:= cSchema

	If _oWSTeste:nfSConsultaNFDest()
		// Método executado com sucesso.
	Else
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2) // Soap Fault Code
		cSoapFDescr := GetWSCError(3) // Soap Fault Description
		Conout(cNewEmp+" - "+cNewFil+" - "+cSvcError+" - Verifique sua conexão com a internet e se o certificado digital está configurado corretamente")
		Return()
	EndIf
Return()
//	ConOut("Empresa: "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()+" - "+AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT)+" "+AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_XMOTIVO:TEXT)+;
	//		" - nsu: "+_oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT)

If 	ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT) <> "C"
	ConOut("_INDCONT diferente de caracter - "+ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT))
Return()
EndIf
If   AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT)=="0" //Não possui mais notas
	//ConOut("SEM NF Empresa: "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time())
	_lRet	:= .F.

ElseIf AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT)=="656"  //Aguardar uma hora

	cInd := 0
	cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
	cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)

ElseIf AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT) $ "138#139#140"

	DO CASE

	CASE ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_RET)<>"A"

		cPropObj	:= XMLSaveStr (_oWSTeste:OWS:_RETCONSNFEDEST:_RET, .T., .T.)

		If "RESNFE" $ UPPER(cPropObj)

			cChave	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESNFE:_CHNFE:TEXT
			cForn	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESNFE:_XNOME:TEXT
			cValor	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESNFE:_VNF:TEXT
			cEmis	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESNFE:_DEMI:TEXT
			cStatus	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESNFE:_CSITCONF:TEXT

			cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
			PUTMV("ST_NSU",cUltNsu)
			//ConOut("nsu:"+cUltNsu+" - chave: "+cChave)
			AADD(aChaves,{cChave,cForn,cValor,cEmis,cStatus,cUltNsu})

			//cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT

		ElseIf "RESCANC" $ UPPER(cPropObj) //Cancelamento

			cChave	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESCANC:_CHNFE:TEXT
			cForn	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESCANC:_XNOME:TEXT
			cValor	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESCANC:_VNF:TEXT
			cEmis	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET:_RESCANC:_DEMI:TEXT
			cStatus	:= "99"

			cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
			PUTMV("ST_NSU",cUltNsu)
			//ConOut("nsu:"+cUltNsu+" - chave: "+cChave)
			AADD(aChaves,{cChave,cForn,cValor,cEmis,cStatus,cUltNsu})

			//cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT

		EndIf

	CASE ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_RET)=="A"

		For nX:=1 To Len(_oWSTeste:OWS:_RETCONSNFEDEST:_RET)

			cPropObj	:= XMLSaveStr (_oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX], .T., .T.)

			If "RESNFE" $ UPPER(cPropObj)

				cChave	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESNFE:_CHNFE:TEXT
				cForn	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESNFE:_XNOME:TEXT
				cValor	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESNFE:_VNF:TEXT
				cEmis	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESNFE:_DEMI:TEXT
				cStatus	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESNFE:_CSITCONF:TEXT

				cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
				PUTMV("ST_NSU",cUltNsu)
				//ConOut("nsu:"+cUltNsu+" - chave: "+cChave)
				AADD(aChaves,{cChave,cForn,cValor,cEmis,cStatus,cUltNsu})

				//cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT

			ElseIf "RESCANC" $ UPPER(cPropObj)

				cChave	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESCANC:_CHNFE:TEXT
				cForn	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESCANC:_XNOME:TEXT
				cValor	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESCANC:_VNF:TEXT
				cEmis	:= _oWSTeste:OWS:_RETCONSNFEDEST:_RET[nX]:_RESCANC:_DEMI:TEXT
				cStatus	:= "99"

				cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
				PUTMV("ST_NSU",cUltNsu)
				//ConOut("nsu:"+cUltNsu+" - chave: "+cChave)
				AADD(aChaves,{cChave,cForn,cValor,cEmis,cStatus,cUltNsu})

				//cUltNsu	:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT

			EndIf

		Next

	ENDCASE

	If len(aChaves)>0

		For nX:=1 To Len(aChaves)

			DO CASE
			CASE AllTrim(aChaves[nX][5])=="0"
				cStatusAtu	:= "Ciencia"//"Sem Manifestacao"
			CASE AllTrim(aChaves[nX][5])=="1"
				cStatusAtu	:= "Confirmada Operacao"
			CASE AllTrim(aChaves[nX][5])=="2"
				cStatusAtu	:= "Desconhecida"
			CASE AllTrim(aChaves[nX][5])=="3"
				cStatusAtu	:= "Operacao nao Realizada"
			CASE AllTrim(aChaves[nX][5])=="4"
				cStatusAtu	:= "Ciencia"
			CASE AllTrim(aChaves[nX][5])=="99"
				cStatusAtu	:= "Nf cancelada"
			ENDCASE


			DbSelectArea("SZ9")
			SZ9->(DbGoTop())
			SZ9->(DbSetOrder(1))
			If !SZ9->(DbSeek(cFilAnt+aChaves[nX][1]))
				/*
				.And.;
					CTOD(SubStr(aChaves[nX][4],9,2)+"/"+SubStr(aChaves[nX][4],6,2)+"/"+SubStr(aChaves[nX][4],1,4))<=CTOD("10/09/2014")
				*/
				SZ9->(RecLock("SZ9",.T.))
				SZ9->Z9_FILIAL	:= cFilAnt
				SZ9->Z9_NOMFOR	:= aChaves[nX][2]
				SZ9->Z9_VALORNF	:= Val(aChaves[nX][3])
				SZ9->Z9_CHAVE	:= aChaves[nX][1]
				SZ9->Z9_SERORI	:= SubStr(aChaves[nX][1],23,3)
				SZ9->Z9_NFEORI	:= SubStr(aChaves[nX][1],26,9)
				SZ9->Z9_DTEMIS	:= CTOD(SubStr(aChaves[nX][4],9,2)+"/"+SubStr(aChaves[nX][4],6,2)+"/"+SubStr(aChaves[nX][4],1,4))

				SZ9->Z9_CNPJ	:= SUBSTR(aChaves[nX][1],7,14)
				SZ9->Z9_DATA	:= DATE()
				SZ9->Z9_HORA	:= TIME()

				SZ9->Z9_NSU	 	:= aChaves[nX][6]
				SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"INCLUINDO Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()

				DO CASE
				CASE AllTrim(aChaves[nX][5])$"0#4"
					SZ9->Z9_STATUS	:= "0"
				CASE AllTrim(aChaves[nX][5])$"2#3#99"
					SZ9->Z9_STATUS	:= "3"
				CASE AllTrim(aChaves[nX][5])$"1"
					SZ9->Z9_STATUS	:= "1"
				ENDCASE

				If AllTrim(aChaves[nX][5])$"99"
					SZ9->Z9_XML	:= "Nota fiscal cancelada"
				EndIf

				SZ9->Z9_STATUSA	:= cStatusAtu
				SZ9->(MsUnlock())

				If AllTrim(aChaves[nX][5])$"1#4#0" .And. Empty(SZ9->Z9_XML)
					U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)
				EndIf

				If AllTrim(aChaves[nX][5])=="0"
					AADD(aDados,{"4",aChaves[nX][1],"",cFilAnt})
					Processa( {|lEnd| U_EXEMANIF(aDados,cCnpj,cUf,1,@lEnd,2)}, "Aguarde...","Executando manifesto.", .T. )
					aDados	:= {}
				EndIf

			Else

				SZ9->(RecLock("SZ9",.F.))
				SZ9->Z9_STATUSA	:= cStatusAtu

				dbSelectArea("SF1")
				SF1->(DbSetOrder(8))
				If  SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))
					If SZ9->Z9_DOC <> Alltrim(SF1->F1_DOC) .Or. SZ9->Z9_SERIE <> SF1->F1_SERIE
						SZ9->Z9_SERIE	:= Alltrim(SF1->F1_SERIE)
						SZ9->Z9_DOC		:= Alltrim(SF1->F1_DOC)
						//SZ9->Z9_ORIGEM	:= 'S'
						SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"ATUALI. SF1 Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
					EndIf
				EndIf
				If AllTrim(aChaves[nX][5])$"99"
					SZ9->Z9_XML	:= "Nota fiscal cancelada"
				EndIf
				SZ9->Z9_LOG := Alltrim(SZ9->Z9_LOG)+CR+"ATUALIZANDO Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()

				SZ9->(MsUnlock())

				If AllTrim(aChaves[nX][5])$"1#4#0" .And. Empty(SZ9->Z9_XML)
					U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)
				EndIf
				Conout("Atualizando Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()+' - '+dtoc( SZ9->Z9_DTEMIS))
			EndIf

		Next

		aChaves	:= {}

	EndIf

	cInd		:= _oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT
	cUltNsu		:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
	PUTMV("ST_NSU",cUltNsu)
	cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
	cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)

ElseIf AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT) $ "593"

	//ConOut("Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()+" - "+AllTrim(_oWsTeste:OWS:_RETCONSNFEDEST:_XMOTIVO:TEXT))
Return

ElseIf AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT) $ "137" .And. AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT)=="0"

	cInd		:=	_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT
	cUltNsu		:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
	PUTMV("ST_NSU",cUltNsu)
	cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
	cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)

Else

	cInd		:= _oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT
	cUltNsu		:= _oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT
	PUTMV("ST_NSU",cUltNsu)
	cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
	cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)

EndIf


RpcClearEnv() //volta a empresa anterior

Return

Static Function PROXTENT(_nHora,_nMin)

	Local _cProxTent

	_cProxTent	:= IncTime(time(),_nHora,_nMin) //Tempo,horas,minutos

	DO CASE
	CASE SubStr(_cProxTent,1,2)=="24"
		_cProxTent	:= "00"+SubStr(_cProxTent,3,6)
	CASE SubStr(_cProxTent,1,2)=="25"
		_cProxTent	:= "01"+SubStr(_cProxTent,3,6)
	CASE SubStr(_cProxTent,1,2)=="26"
		_cProxTent	:= "02"+SubStr(_cProxTent,3,6)
	CASE SubStr(_cProxTent,1,2)=="27"
		_cProxTent	:= "03"+SubStr(_cProxTent,3,6)
	ENDCASE

	/*
	If Len(StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":"))==4
		_cProxTent	:= "0"+StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":")+":00"
	ElseIf Len(StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":"))==3
		_cProxTent	:= "0"+StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":")+"0:00"
	ElseIf Len(StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":"))==1
		_cProxTent	:= "0"+StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":")+":00:00"
	Else
		_cProxTent	:= StrTran(cValToChar(SomaHoras(time(),_nTime)),".",":")+":00"
	EndIf

	DO CASE
	CASE SubStr(_cProxTent,1,2)=="24"
		_cProxTent	:= "00:"+SubStr(_cProxTent,3,6)
	CASE SubStr(_cProxTent,1,2)=="25"
		_cProxTent	:= "01:"+SubStr(_cProxTent,3,6)
	CASE SubStr(_cProxTent,1,2)=="26"
		_cProxTent	:= "02:"+SubStr(_cProxTent,3,6)
	ENDCASE
	*/

Return(_cProxTent)


Static Function STRETNSU()
	Local cPerg       := 'STRETNSU'+cFilAnt
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAlias      := cPerg+cHora+ cMinutos+cSegundos
	Local _cRet       := '0'
	Local cQuery 	  := ""



	cQuery:= "SELECT NVL(MAX(Z9_NSU),'0') NSU  FROM "+RetSqlName("SZ9")+" SZ9 WHERE SZ9.D_E_L_E_T_ = ' ' AND Z9_FILIAL = '"+cFilAnt+"'



	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	_cRet     := Alltrim((cAlias)->NSU)
	(cAlias)->(dbCloseArea())

Return( _cRet )



User Function xSignXMLA1(cXML,cTag,cAttID,cIdEnt)

	Local cXmlToSign  := ""
	Local cURI        := ""
	Local cDir        := IIf(IsSrvUnix(),"certificados/", "certificados\")
	Local cRootPath   := StrTran(GetSrvProfString("RootPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	Local cStartPath  := StrTran(cRootPath+IIf(!IsSrvUnix(),"\","/")+GetSrvProfString("StartPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	Local cArqXML     := Lower(CriaTrab(,.F.))
	Local cMacro      := ""
	Local cError      := ""
	Local cWarning    := ""
	Local cDigest     := ""
	Local cSignature  := ""
	Local cSignInfo   := ""
	Local cIniXml     := ""
	Local cFimXml     := ""
	Local cNameSpace  := ""
	Local cNewTag     := ""
	Local nAt         := 0

	cRootPath  := StrTran(cRootPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))



	If !Empty(Select("SPED001"))
		DbSelectArea("SPED001")
		("SPED001")->(dbCloseArea())
	Endif

	USE &("SPED001") ALIAS &("SPED001") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED001")
	DBSETINDEX("SPED00101")

	MsSeek(cIdEnt)

	If !Empty(Select("SPED000"))
		DbSelectArea("SPED000")
		("SPED000")->(dbCloseArea())
	Endif

	USE &("SPED000") ALIAS &("SPED000") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED000")
	DBSETINDEX("SPED00001")


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Assina a NFe                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case  FindFunction("EVPPrivSign")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Canoniza o XML                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cXmlToSign := XmlC14N(cXml, "", @cError, @cWarning)
		If Empty(cError) .And. Empty(cWarning)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retira a Tag anterior a tag de assinatura                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nAt := At("<"+cTag,cXmlToSign)
			cIniXML    := SubStr(cXmlToSign,1,nAt-1)
			cXmlToSign := SubStr(cXmlToSign,nAt)
			nAt := At("</"+cTag+">",cXmltoSign)
			cFimXML    := SubStr(cXmltoSign,nAt+Len(cTag)+3)
			cXmlToSign := SubStr(cXmlToSign,1,nAt+Len(cTag)+2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Descobre o namespace complementar da tag de assinatura                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNewTag := AllTrim(cIniXml)
			cNewTag := SubStr(cIniXml,2,At(" ",cIniXml)-2)
			cNameSpace := StrTran(cIniXml,"<"+cNewTag,"")
			cNameSpace := AllTrim(StrTran(cNameSpace,">",""))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o DigestValue da assinatura                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +" "+cNameSpace+" ")
			cDigest := XmlC14N(cDigest, "", @cError, @cWarning)
			cMacro  := "EVPDigest"
			//	         cDigest := Encode64(&cMacro.( cDigest , 3 ))
			cDigest := Encode64(cDigest)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o SignedInfo  da assinatura                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSignInfo := GetSignInfo(cUri,cDigest)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Assina o XML                                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMacro   := "EVPPrivSign"
			//cSignature := &cMacro.(IIf(IsSrvUnix(),"/", "\")+cDir+"P"+cIdEnt+"_key.pem" , cSignInfo , 3 , AllTrim(GetNewPar("MV_PSWNFD","SENHA123")) , @cError)
			cSignature := &cMacro.(IIf(IsSrvUnix(),"/", "\")+cDir+cIdEnt+"_key.pem" , cSignInfo , 3 , Decode64(AllTrim(SPED001->PASSCERT)) , @cError)

			cSignature := Encode64(cSignature)




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Envelopa a assinatura                                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+"P"+cIdEnt+"_cert.pem",.F.,cIdEnt)
			cCert := GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+cIdEnt+"_cert.pem",SpedGetMv("MV_HSM",cIdEnt)=="1",cIdEnt)

			cXmlToSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
			cXmltoSign += cSignInfo
			cXmlToSign += '<SignatureValue>'+cSignature+'</SignatureValue>'
			cXmltoSign += '<KeyInfo>'
			cXmltoSign += '<X509Data>'
			cXmltoSign += '<X509Certificate>'+cCert+'</X509Certificate>'
			cXmltoSign += '</X509Data>'
			cXmltoSign += '</KeyInfo>'
			cXmltoSign += '</Signature>'

			cXmlToSign := cIniXML+cXmlToSign+cFimXML
		Else
			cXmlToSign := cXml
			ConOut("Sign Error thread: "+cError+"/"+cWarning)
		EndIf
	EndCase

	("SPED001")->(DbCloseArea())
	("SPED000")->(DbCloseArea())
Return(cXmlToSign)




Static Function GetSignInfo(cUri,cDigest)
	Local cSignedInfo := ""
	cSignedInfo += '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#">'
	cSignedInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></CanonicalizationMethod>'
	cSignedInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></SignatureMethod>'
	cSignedInfo += '<Reference URI="#'+ cUri +'">'
	cSignedInfo += '<Transforms>'
	cSignedInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></Transform>'
	cSignedInfo += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform>'
	cSignedInfo += '</Transforms>'
	cSignedInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod>'
	cSignedInfo += '<DigestValue>' + cDigest + '</DigestValue></Reference></SignedInfo>'
Return(cSignedInfo)





Static Function GetCertificate(cFile,lHSM,cIdEnt)
	Local cCertificado := cFile
	Local nAT          := 0
	Local nRAT         := 0
	Local nHandle      := 0
	Local nBuffer      := 0

	If file(cfile)
		lDirCert  := .T.
		nHandle      := FOpen( cFile, 0 )
		nBuffer      := FSEEK(nHandle,0,FS_END)


		FSeek( nHandle, 0 )
		FRead( nHandle , cCertificado , nBuffer )
		FClose( nHandle )

		nAt := AT("BEGIN CERTIFICATE", cCertificado)
		If (nAt > 0)
			nAt := nAt + 22
			cCertificado := substr(cCertificado, nAt)
		EndIf
		nRat := AT("END CERTIFICATE", cCertificado)
		If (nRAt > 0)
			nRat := nRat - 6
			cCertificado := substr(cCertificado, 1, nRat)
		EndIf
		cCertificado := StrTran(cCertificado, Chr(13),"")
		cCertificado := StrTran(cCertificado, Chr(10),"")
		cCertificado := StrTran(cCertificado, Chr(13)+Chr(10),"")
	Else
		lDirCert  := .F.
		MsgAlert("Certificado não encontrado.")
	EndIf

Return(cCertificado)


User Function stnfs0x()
	Local oWsdl
	Local xRet
	Local aOps := {}, aComplex := {}, aSimple := {}

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()

	// Faz o parse de uma URL
	xRet := oWsdl:ParseURL( "http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws?wsdl" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	aOps := oWsdl:ListOperations()

	if Len( aOps ) == 0
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	varinfo( "", aOps )

	// Define a operação
	xRet := oWsdl:SetOperation( "consultarNota" )
	//xRet := oWsdl:SetOperation( aOps[1][1] )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	aComplex := oWsdl:NextComplex()
	varinfo( "", aComplex )

	aSimple := oWsdl:SimpleInput()
	varinfo( "", aSimple )

	// Define o valor de cada parâmeto necessário
	xRet := oWsdl:SetValue( 0, "90210" )
	//xRet := oWsdl:SetValue( aSimple[1][1], "90210" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	// Exibe a mensagem que será enviada
	conout( oWsdl:GetSoapMsg() )

	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	// Pega a mensagem de resposta
	conout( oWsdl:GetSoapResponse() )

	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif
Return

