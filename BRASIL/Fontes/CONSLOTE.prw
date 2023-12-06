#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBSRV.CH"

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

User Function CONSLOTE(cNewEmp,cNewFil)

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
	Local lSF1          := .F.


	_nHix         :=   val(cHora+cMinutos+cSegundos)
	If cMinutos = '59'
		_nHfx         := _nHix+4110
	Else
		_nHfx         := _nHix+110
		If _nHfx >= 235959
			_nHfx := 000100
		EndIf
	EndIf


	If dtos(date())>("20190229")
		Conout("Atenção, o tempo de uso da funcionalidade expirou, entre em contato com o Administrador!")
		Return()
	EndIf

	//Conout ("Iniciando consulta de lote da empresa: "+cNewEmp+" filial: "+cNewFil+" - "+dtoc(date())+" - "+time())

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	//PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil TABLES "SPED001" MODULO "FAT"
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSelectArea("SD1")
	dbSetOrder(1)
	/*Ajustado - Não executa mais RecLock na X6, a criação/alteração de parâmetros deve ser realizada no configurador
	DbSelectArea("SX6")
	SX6->(DbSetOrder(1))

	SX6->(DbGoTop())
	SX6->(DbSeek("  "+"FS_TPAMBNF"))

	If SX6->(Eof())

		SX6->(RecLock("SX6",.T.))
		SX6->X6_FIL		:= ""
		SX6->X6_VAR		:= "FS_TPAMBNF"
		SX6->X6_TIPO	:= "C"
		SX6->X6_DESCRIC	:= "Tipo de ambiente - 1=Prod;2=Homol"
		SX6->X6_CONTEUD	:= "1"
		SX6->(MsUnLock())

	EndIf

	SX6->(DbGoTop())
	SX6->(DbSeek(cNewFil+"FS_ULTTHRE"))

	If SX6->(Eof())

		SX6->(RecLock("SX6",.T.))
		SX6->X6_FIL		:= cNewFil
		SX6->X6_VAR		:= "FS_ULTTHRE"
		SX6->X6_TIPO	:= "N"
		SX6->X6_DESCRIC	:= "Guardar ultimo ID da thread"
		SX6->(MsUnLock())

	EndIf

	If SX6->(!Eof())
		If SimpleLock()
			SX6->(RecLock("SX6",.F.))
			lContinua	:= .T.
		Else
			lContinua	:= .F.
		EndIf
	EndIf*/

	If lContinua //Pode continuar se não tiver outra thread rodando

		//PutMv("FS_ULTTHRE",Threadid())

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
		cUltNsu		:= GETMV("ST_NSU",,"0")//STRETNSU()
		//CONOUT("XXXXX"+cUltNsu )
		cProxTent0	:= PROXTENT(_nHTent0,_nMTent0)
		cProxTent1	:= PROXTENT(_nHTent1,_nMTent1)

		While _lRet
			cTime         := Time()
			cHora         := SUBSTR(cTime, 1, 2)
			cMinutos      := SUBSTR(cTime, 4, 2)
			cSegundos     := SUBSTR(cTime, 7, 2)
			_nHix         :=   val(cHora+cMinutos+cSegundos)
			If _nHix >= _nHfx
				//	conout("SAIDA Empresa: "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time())
				RETURN()
			EndIf
			//ConOut("Teste - Empresa: "+cEmpAnt+" - Filial: "+cFilAnt+" Tentativa0: "+cProxTent0+" Tentativa1 "+cProxTent1+" indcount "+AllTrim(cInd))

			If (Time()>cProxTent1 .And. nCount==15)
				nCount	:= 0
			EndIf

			If (Time()>cProxTent0 .And. AllTrim(cInd)=="0") .Or. (AllTrim(cInd)=="1" .And. nCount<15)  //Possui mais notas

				nCount	+= 1

				//ConOut("Iniciando consulta de xmls - Empresa: "+cEmpAnt+" - Filial: "+cFilAnt+" - "+cCnpj+" - "+dtoc(date())+" - "+time())

				If AllTrim(GetMv("FS_TPAMBNF"))=="2" //Homologação
					_oWsTeste := WSNFeConsultaDHml():New()
				ElseIf AllTrim(GetMv("FS_TPAMBNF"))=="1" //Producao
					_oWsTeste := WSNFeConsultaDest():New()
				EndIf

				_cIdEnt := U_XGETIND(cCnpj,"1")
				_cPass  := U_XGETIND(cCnpj,"2")
				//\\10.152.4.7\d$\TOTVS\TSS2\certs
				_oWsTeste:_CERT			:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_all.pem"
				_oWsTeste:_PRIVKEY		:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_key.pem"
				_oWsTeste:_PASSPHRASE	:= _cPass
				//ConOut("certificado!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				//ConOut( _oWsTeste:_CERT	+"- Empresa: "+cEmpAnt+" - Filial: "+cFilAnt+" - "+cCnpj+" - "+dtoc(date())+" - "+time())


				cSchema	:= '<consNFeDest xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">'
				cSchema	+= '<tpAmb>'+AllTrim(GetMv("FS_TPAMBNF"))+'</tpAmb>'
				cSchema	+= '<xServ>CONSULTAR NFE DEST</xServ>'
				cSchema	+= '<CNPJ>'+cCnpj+'</CNPJ>'
				cSchema += '<indNFe>0</indNFe>'
				cSchema += '<indEmi>0</indEmi>'
				cSchema += '<ultNSU>'+cUltNsu+'</ultNSU>'
				cSchema	+= '</consNFeDest>'
				//ConOut("schema")
				//			ConOut( cSchema + " - Empresa: "+cEmpAnt+" - Filial: "+cFilAnt+" - "+cCnpj+" - "+dtoc(date())+" - "+time())

				oXml := XmlParser(cSchema,"_",@cErro,@cAviso)

				_oWSTeste:cversaoDados	:= "1.01"
				_oWSTeste:ccUF			:= cUf
				_oWSTeste:oWS			:= cSchema

				If _oWSTeste:nfeConsultaNFDest()
					// Método executado com sucesso.
				Else
					cSvcError   := GetWSCError()  // Resumo do erro
					cSoapFCode  := GetWSCError(2) // Soap Fault Code
					cSoapFDescr := GetWSCError(3) // Soap Fault Description
					Conout(cNewEmp+" - "+cNewFil+" - "+cSvcError+" - Verifique sua conexão com a internet e se o certificado digital está configurado corretamente")
					Return()
				EndIf

				//	ConOut("Empresa: "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()+" - "+AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_CSTAT:TEXT)+" "+AllTrim(_oWSTeste:OWS:_RETCONSNFEDEST:_XMOTIVO:TEXT)+;
					//		" - nsu: "+_oWSTeste:OWS:_RETCONSNFEDEST:_ULTNSU:TEXT)

				/*
				If 	ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT) <> "C"
					ConOut("_INDCONT diferente de caracter - "+ValType(_oWSTeste:OWS:_RETCONSNFEDEST:_INDCONT:TEXT))
					Return()
				EndIf
				*/
				_cinf :=  ''
				_cinf :=  XmlChildEx ( _oWSTeste:OWS:_RETCONSNFEDEST,"_INDCONT" )
				If _cinf = NIL
					ConOut("_INDCONT diferente de caracter - ")
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
									AADD(aDados,{"4",aChaves[nX][1]})
									Processa( {|lEnd| U_EXEMANIF(aDados,cCnpj,cUf,1,@lEnd,2)}, "Aguarde...","Executando manifesto.", .T. )
									aDados	:= {}
								EndIf

							Else

								SZ9->(RecLock("SZ9",.F.))
								SZ9->Z9_STATUSA	:= cStatusAtu

								dbSelectArea("SF1")
								SF1->(DbSetOrder(8))
								lSF1 := SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))   // Valdemir Rabelo 15/07/2021
								If  lSF1
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

								// Valdemir Rabelo 15/07/2021 - Ticket: 20210707011905
								If (AllTrim(aChaves[nX][5])$"99") .and. lSF1
									U_UPDTESF1(SF1->F1_DOC)
								Endif
								// --------------------------------------

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

			EndIf

		EndDo

		SX6->(MsUnLock())

	EndIf

	RpcClearEnv() //volta a empresa anterior

Return

/*/{Protheus.doc} UPDTESF1
@description
Rotina que fará a exclusao da pre nota, caso venha o status da SefaZ
de Nota Cancelada
Ticket: 20210707011905

Fontes Envolvidos Chamado
CONSLOTE
STXMLVLD
STXMLNFE
JOBXMLBX

@type function
@version 1.00
@author Valdemir Jose
@since 15/07/2021
@param cNumDoc, character, param_description
@return variant, return_description
/*/
User Function UPDTESF1(cNumDoc)
	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}

	if Empty(SF1->F1_STATUS)

		aadd(aCabec,{"F1_TIPO"   ,SF1->F1_TIPO   ,Nil,Nil})
		aadd(aCabec,{"F1_XFATEC" ,SF1->F1_XFATEC ,Nil,Nil})
		aadd(aCabec,{"F1_FORMUL" ,SF1->F1_FORMUL ,Nil,Nil})
		aadd(aCabec,{"F1_DOC"    ,SF1->F1_DOC    ,Nil,Nil})
		aadd(aCabec,{"F1_SERIE"  ,SF1->F1_SERIE  ,Nil,Nil})
		aadd(aCabec,{"F1_EMISSAO",SF1->F1_EMISSAO,Nil,Nil})
		aadd(aCabec,{"F1_FORNECE",SF1->F1_FORNECE,Nil,Nil})
		aadd(aCabec,{"F1_LOJA"   ,SF1->F1_LOJA   ,Nil,Nil})
		aadd(aCabec,{"F1_ESPECIE",SF1->F1_ESPECIE,Nil,Nil})
		aadd(aCabec,{"F1_CHVNFE" ,SF1->F1_CHVNFE ,Nil,Nil})

		If SD1->(MsSeek(xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			While SD1->( !Eof())  .And. ( SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) )
				aLinha := {}
				aadd(aLinha,{"D1_COD"    ,SD1->D1_COD    , Nil, Nil})
				aadd(aLinha,{"D1_PEDIDO" ,SD1->D1_PEDIDO , Nil, Nil})
				aadd(aLinha,{"D1_ITEMPC" ,SD1->D1_ITEMPC , Nil, Nil})
				aadd(aLinha,{"D1_QUANT"  ,SD1->D1_QUANT  , Nil, Nil})
				aadd(aLinha,{"D1_VUNIT"  ,SD1->D1_VUNIT  , Nil, Nil})
				aadd(aLinha,{"D1_TOTAL"  ,SD1->D1_TOTAL  , Nil, Nil})
				aadd(aLinha,{"D1_VALDESC",SD1->D1_VALDESC, Nil, Nil})
				aadd(aLinha,{"D1_CLASFIS",SD1->D1_CLASFIS, Nil, Nil})
				aadd(aLinha,{"D1_OP"	 ,SD1->D1_OP     , NIL, Nil})
				aadd(aLinha,{"D1_CC"	 ,SD1->D1_CC     , NIL, Nil})
				aadd(aLinha,{"D1_UM"	 ,SD1->D1_UM     , NIL, Nil})
				aadd(aLinha,{"D1_CONTA"	 ,SD1->D1_CONTA  , NIL, Nil})
				aadd(aLinha,{"D1_XFATEC" ,SD1->D1_XFATEC , Nil, Nil})
				aadd(aLinha,{"D1_VALFRE" ,SD1->D1_VALFRE , NIL, Nil})
				aadd(aItens, aLinha)
				SD1->( dbSkip() )
			EndDo
		Endif

		lMsErroAuto := .f.
		lMsHelpAuto := .f.
		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,5)
		IF lMsErroAuto
			Conout("PRE NOTA: "+cNumDoc+" OCORREU PROBLEMA AO EXCLUIR. POR FAVOR, VERIFIQUE...")
		ELSE
			Conout("PRE NOTA: "+cNumDoc+" EXCLUÍDA COM SUCESSO")
		ENDIF
	else
		Conout("NOTA FISCAL: "+cNumDoc+" NÃO PODE SER EXCLUÍDA POR ESTAR CLASSIFICADA")
	endif

Return


User Function XGETIND(_cCnpj,_cTipo)

	Local _cRet	:= ""
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1  := " SELECT * "
	cQuery1  += " FROM SPED001 "
	cQuery1  += " WHERE D_E_L_E_T_=' ' AND CNPJ='"+_cCnpj+"' AND PASSCERT<>' ' "
	If SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01"
		cQuery1  += " AND ID_ENT = '000004'
	ElseIf SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="02"
		cQuery1  += " AND ID_ENT = '000009'
	EndIf
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		If _cTipo=="1"
			_cRet	:= (cAlias1)->ID_ENT
		ElseIf _cTipo=="2"
			_cRet	:= AllTrim((cAlias1)->PASSCERT)
		EndIf
	EndIf

Return(_cRet)

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

//GIOVANI ZAGO 01/11/16 REALIZA A MANIFESTAÇÃO AUTOMATICA APOS A REALIZAÇÃO DA PRE-NOTA JOB
User Function CONSNFE(cNewEmp,cNewFil)
	Local cCnpj	 := ''
	Local cUf	 := ''
	Local cPerg       := 'CONSNFE'
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAlias      := cPerg+cHora+ cMinutos+cSegundos
	Local _cRet       := '0'
	Local cQuery 	  := ""
	Local _aCols := {}
	Local _cChave:= ' '

	//Local cNewEmp := "01"
	//Local cNewFil := "04"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	ConOut("[CONSLOTE]["+ FWTimeStamp(2) +"] - Inicio do processamento - Empresa: "+cNewEmp+cNewFil)

	cAlias      := cPerg+cHora+ cMinutos+cSegundos
	cPerg       := 'CONSNFE'+cNewFil
	cCnpj	    := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	cUf	 	    := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")


	// REALIZA A CONFIRMAÇÃO DA OPERAÇÃO
	cQuery:= " SELECT * FROM "+RetSqlName("SZ9")+" SZ9 WHERE SZ9.D_E_L_E_T_ = ' ' AND Z9_FILIAL = '"+cNewFil+"'
	cQuery+= " AND (substr(Z9_STATUSA,4,4) = 'ncia' or Z9_STATUS   = '7')  AND Z9_ORIGEM = 'NF-E'
	//cQuery+= " AND Z9_CHAVE='35181009076952000163550010000039101122006261'
	cQuery += " ORDER BY Z9_DTEMIS

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	_nc:=0
	While (cAlias)->(!Eof())
		_cChave:= (cAlias)->Z9_CHAVE

		dbSelectArea("SF1")
		SF1->(DbSetOrder(8))
		If  SF1->(DbSeek((cAlias)->Z9_FILIAL+_cChave)) .Or. (cAlias)->Z9_STATUS = '7'

			dbSelectArea("SD1")
			SD1->(DbSetOrder(1))
			If SD1->(dbSeek((cAlias)->Z9_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)	)
				If !(Empty(Alltrim(SD1->D1_TES)))
					_nc ++
					aadd(_aCols,{'1',_cChave,"",(cAlias)->Z9_FILIAL})

					cCnpj	 	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
					cUf	 		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

					U_EXEMANIF(_aCols,cCnpj,cUf,1,.t.,2)

					_aCols := {}
				EndIf
			EndIf
		EndIf

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())
	//FECHA A CONFIRMAÇÃO DA OPREÇÃO

	//>>REALIZA O DESCONHECIMENTO DA OPERAÇÃO

	cQuery:= " SELECT * FROM "+RetSqlName("SZ9")+" SZ9 WHERE SZ9.D_E_L_E_T_ = ' ' AND Z9_FILIAL = '"+cNewFil+"'
	cQuery+= " AND  Z9_STATUS   = '8'  AND Z9_ORIGEM = 'NF-E'     ORDER BY Z9_DTEMIS


	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
		_cChave:= (cAlias)->Z9_CHAVE

		aadd(_aCols,{'2',_cChave,"",(cAlias)->Z9_FILIAL})

		cCnpj	 	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
		cUf	 		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

		U_EXEMANIF(_aCols,cCnpj,cUf,1,.t.,2)


		_aCols := {}

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())


	//<<REALIZA O DESCONHECIMENTO DA OPERAÇÃO

	//>>OPERAÇÃO NÃO REALIZADA

	cQuery:= " SELECT Z9_FILIAL,Z9_CHAVE,R_E_C_N_O_ REC FROM "+RetSqlName("SZ9")+" SZ9 WHERE SZ9.D_E_L_E_T_ = ' ' AND Z9_FILIAL = '"+cNewFil+"'
	cQuery+= " AND  Z9_STATUS   = '9'  AND Z9_ORIGEM = 'NF-E'    ORDER BY Z9_DTEMIS

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	dbSelectArea("SZ9")
	SZ9->(dbGoTop())

	While (cAlias)->(!Eof())
		SZ9->(DbGoTo((cAlias)->REC))
		_cChave:= (cAlias)->Z9_CHAVE

		aadd(_aCols,{'3',_cChave,Alltrim(SZ9->Z9_DESC),(cAlias)->Z9_FILIAL})

		cCnpj	 	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
		cUf	 		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

		U_EXEMANIF(_aCols,cCnpj,cUf,1,.t.,2)

		_aCols := {}

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())

	ConOut("[CONSLOTE]["+ FWTimeStamp(2) +"] - Fim do processamento - Empresa: "+cNewEmp+cNewFil)

	//<< OPERAÇÃO NÃO REALIZADA

Return()

