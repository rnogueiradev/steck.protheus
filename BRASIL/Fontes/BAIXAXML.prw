#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BAIXAXML	ºAutor  ³Renato Nogueira     º Data ³  03/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para instanciar os objetos do webservice	  º±±
±±º          ³e baixar arquivo xml do site da sefaz   				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BAIXAXML(cChave,cUf,cCnpj)
	
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
	Local _sXML			:= ""
	Local _lRet			:= .F.
	Local _oWSTeste1
	Local _cIdEnt		:= ""
	Local _cPass		:= ""
	
	/*
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
		SX6->X6_CONTEUD	:= "1" //Inicia com producao
		SX6->(MsUnLock())
		
	EndIf
	*/
	If AllTrim(GetMv("FS_TPAMBNF"))=="2" //Homologação
		_oWSTeste1 := WSNFEDOWNNFHML():New()
	ElseIf AllTrim(GetMv("FS_TPAMBNF"))=="1" //Producao
		_oWSTeste1 := WSNfeDownloadNF():New()
	EndIf
	
	_cIdEnt := U_XGETIND(cCnpj,"1")
	_cPass  := U_XGETIND(cCnpj,"2")
	
	_oWSTeste1:_CERT			:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_all.pem"
	_oWSTeste1:_PRIVKEY		:= "D:\TOTVS\TSS2\certs\"+_cIdEnt+"_key.pem"
	_oWSTeste1:_PASSPHRASE	:= _cPass
	
	cSchema	:= '<downloadNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'
	cSchema	+= '<tpAmb>'+AllTrim(GetMv("FS_TPAMBNF"))+'</tpAmb>'
	cSchema	+= '<xServ>DOWNLOAD NFE</xServ>'
	cSchema	+= '<CNPJ>'+cCnpj+'</CNPJ>'
	cSchema += '<chNFe>'+cChave+'</chNFe>'
	cSchema	+= '</downloadNFe>'
	
	//oXml := XmlParser(cSchema,"_",@cErro,@cAviso)
	
	_oWSTeste1:cversaoDados	:= "1.00"
	_oWSTeste1:ccUF			:= cUf
	_oWSTeste1:oWS			:= cSchema
	
	If _oWSTeste1:nfeDownloadNF()
		// Método executado com sucesso.
		_lRet	:= .T.
	Else
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2) // Soap Fault Code
		cSoapFDescr := GetWSCError(3) // Soap Fault Description
		MsgStop('Problema de execução')
		_lRet		:= .F.
		Return()
	EndIf
	
	If _lRet .And. AllTrim(_oWSTeste1:OWS:_RETDOWNLOADNFE:_RETNFE:_CSTAT:TEXT) $ "138#139#140"
		
		cArquivo	:= cChave+"-nfe.xml"
		cAnexo		:= cDir+cArquivo
		
		_sXML := "<nfeProc"
		_sXML += XMLSaveStr (_oWSTeste1:oWs:_RetDownloadNfe:_RetNfe:_ProcNfe:_NfeProc)
		_sXML += "</nfeProc>"
		
		DbSelectArea("SZ9")
		SZ9->(DbGoTop())
		SZ9->(DbSetOrder(1))
		If SZ9->(DbSeek(cFilAnt+cChave))
			SZ9->(Reclock("SZ9",.F.))
			SZ9->Z9_XML		:= _sXML
			If SZ9->Z9_STATUSA=="Sem Manifestacao                   "
				SZ9->Z9_STATUSA := 'Ciencia'
			EndIf
			SZ9->(Msunlock())
		EndIf
		
		If !File(cAnexo)
			nHdlXml   := FCreate(cAnexo,0)
			If nHdlXml > 0
				FWrite(nHdlXml,_sXML)
				FClose(nHdlXml)
			Endif
		EndIf
		
	Else
		
		MsgAlert(_oWSTeste1:OWS:_RETDOWNLOADNFE:_RETNFE:_XMOTIVO:TEXT)
		
	EndIf
	
Return()


User Function   STXMLMONITOR()
	
	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")
	
	aAreaSM0	:= GetArea("SM0")
	aArea		:= GetArea()
	
	//Abrir threads por empresa da função conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())
	
	While SM0->(!Eof())
		
		
		If (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="03") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="04") .Or.;
				(SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
			//If SM0->M0_CODFIL=="04"
			StartJob("U_XMLSCAN",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			//U_XMLSCAN(SM0->M0_CODIGO,SM0->M0_CODFIL)
			//EndIf
		EndIf
		SM0->(DbSkip())
		
	EndDo
	
	RestArea(aArea)
	RestArea(aAreaSM0)
	
	
Return




User function XMLSCAN(cNewEmp,cNewFil)
	Local cAviso := ""
	Local cErro  := ""
	Local oNfe
	
	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	
	//PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil
	conout(cNewEmp+cNewFil+time())
	DbSelectArea("SZ9")
	SZ9->(DbGoTop())
	SZ9->(DbSetOrder(3))
	
	While !(SZ9->(Eof()))
		_cXml:= Alltrim(SZ9->Z9_XML)
		If 		!(AllTrim(UPPER(SZ9->Z9_STATUSA)) == "NF CANCELADA") .And. Empty(Alltrim(_cXml)) .And. !(Empty(Alltrim(SZ9->Z9_CHAVE)))
			cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
			cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")
			U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)
			//conout("baixou: "+SZ9->Z9_CHAVE)
		Endif
		If cNewFil = SZ9->Z9_FILIAL .And. !("STECK" $ SZ9->Z9_NOMFOR) .And. !(Empty(Alltrim(SZ9->Z9_CHAVE))) //.And. SZ9->Z9_CHAVE = '35161196495650000124550010000182011001563218'
			
			If  (AllTrim(UPPER(SZ9->Z9_STATUSA))=="CIENCIA" .OR. AllTrim(UPPER(SZ9->Z9_STATUSA))=="CIÊNCIA")
				
				cAviso := ""
				cErro  := ""
				_cXml  := ""
				_cXml:= Alltrim(SZ9->Z9_XML)
				_cXml:= FwCutOff(_cXml, .t.)
				oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)
				
				If VALType(oNFe) <> "U"
					If valtype(oNFe:_NfeProc) = 'O'
						oNF := oNFe:_NFeProc:_NFe
						If !(oNFe == NIL )
							VALIDXML(oNFe,oNF)
						EndIf
					Else
						If valtype(oNFe:_NFe)= 'O'
							oNF := oNFe:_NFe
							If !(oNF == NIL )
								VALIDXML(oNFe,oNF)
							EndIf
						Else
							CONOUT("Não foi possível abrir o arquivo XML, provavel falha em sua estrutura. Por favor substitua o arquivo "+SZ9->Z9_CHAVE)
							SZ9->(RecLock("SZ9",.F.))
							SZ9->Z9_XML	:= ' '
							SZ9->(MsUnLock())
							cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
							cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")
							U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)
							conout("baixou: "+SZ9->Z9_CHAVE)
							
						Endif
					Endif
				Else
					CONOUT("Não foi possível abrir o arquivo XML, provavel falha em sua estrutura. Por favor substitua o arquivo "+SZ9->Z9_CHAVE)
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_XML	:= ' '
					SZ9->(MsUnLock())
					cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
					cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")
					U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)
					conout("baixou: "+SZ9->Z9_CHAVE)
					
				Endif
				
				
			EndIf
		Endif
		
		SZ9->(DbSkip())
		
	EndDo
	
	conout(cNewFil+" STXMLMONITOR fim: "+dtoc(date())+' - '+time())
Return()


Static Function VALIDXML(oNfe,oNF)
	Local nX := 0
	Local _aErro	:= {}
	Local _cTiponf  := ''
	Local _cNorm	:= getmv("ST_CFNORM",,"1949/2949/5101/5102/5405/5911/5949/6101/6949/5909/6102/6933")
	Local _cDev 	:= getmv("ST_CFDEV" ,,"1201/1202/2202/2411/5201/5202/5411/5556/5916/6202/6411/6556")
	Local _cBene	:= getmv("ST_CFBENE",,"1901/5124/5902")
	Local lAchou  	:= .f.
	Local cProduto := ' '
	
	AAdd(_aErro,{"FILIAL","CHAVE NF-e","FORNECEDOR","DATA NF-e","MOTIVO","CONTEUDO","OBS."})
	
	//VERIFICA SE O XML É VALIDO
	//oNF := oNFe
	oNFChv := oNFe:_NFeProc:_protNFe
	
	oEmitente  := oNF:_InfNfe:_Emit
	oIdent     := oNF:_InfNfe:_IDE
	oDestino   := oNF:_InfNfe:_Dest
	oTotal     := oNF:_InfNfe:_Total
	oTransp    := oNF:_InfNfe:_Transp
	oDet       := oNF:_InfNfe:_Det
	cChvNfe    := oNFChv:_INFPROT:_CHNFE:TEXT
	cTpNf	   := oNf:_INFNFE:_IDE:_TPNF:TEXT
	
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_CNPJ:TEXT))	,ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))
	cIe  := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_IE:TEXT))	,ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))
	cCfop:= ALLTRIM(oDet[1]:_PROD:_CFOP:TEXT)
	//Conout(cCfop+" - "+cChvNfe)
	If cTpNf <> '1'
		//AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"NF ENTRADA",cCgc})
	Else
		
		If cCfop $ _cNorm
			_cTiponf  := 'N'
		ElseIf cCfop $ _cDev
			_cTiponf  := 'D'
		ElseIf cCfop $ _cBene
			_cTiponf  := 'B'
		Else
			Conout( cCfop )
		EndIf
		
		
		Conout(_cTiponf+cChvNfe)
		
		
		
	EndIf
	
	
	
	
	If 	_cTiponf  = 'N' // Nota Normal Fornecedor
		dbselectarea("SA2")
		//dbSetOrder(3)
		SA2->(DbOrderNickName("CGCINSCR2"))
		SA2->(dbSeek(xFilial("SA2")+cCgc+cIe))
		do while !lAchou .and. !eof() .and. (xFilial("SA2") = SA2->A2_FILIAL) .AND. (TRIM(SA2->A2_CGC) == cCgc) .AND. (TRIM(SA2->A2_INSCR) == cIe)
			IF FieldPos("A2_MSBLQL") > 0
				IF !(SA2->A2_MSBLQL == "1")
					lAchou := .t.
					EXIT
				endif
			else
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA2')
			dbskip()
		enddo
	Else
		dbselectarea("SA1")
		//dbSetOrder(3)
		SA1->(DbOrderNickName("CGCINSCR1"))
		SA1->(dbSeek(xFilial("SA1")+cCgc+cIe))
		do while !lAchou .and. !eof() .and. (xFilial("SA1") = SA1->A1_FILIAL) .AND. (TRIM(SA1->A1_CGC) == cCgc) .AND. (TRIM(SA1->A1_INSCR) == cIe)
			IF FieldPos("A1_MSBLQL") > 0
				IF !(SA1->A1_MSBLQL == "1")
					lAchou := .t.
					EXIT
				endif
			else
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA1')
			dbskip()
		enddo
	Endif
	If !lAchou
				AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"CNPJ/IE NÃO LOCALIZADO",cCgc+" / "+cIe,SZ9->Z9_OBS})
	Endif
	
	
	If 	_cTiponf  = 'N'
		cProds := ''
		aPedIte:= {}
		
		For nX := 1 To Len(oDet)
			
			cProduto:= PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])
			xProduto:=cProduto
			
			oAux := oDet[nX]
			cNCM :=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			
			DbSelectArea("SA5")
			SA5->(DbOrderNickName("FORPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			If !SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
				conout ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
				AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"PRODUTO SEM AMARRAÇÃO",cProduto,SZ9->Z9_OBS})
				
			EndIf
		Next nX
	Endif
	
	
	
	
	
	
	
	
	
	
	
	
	If len(_aErro) > 1
		XMLMAIL(_aErro)
	EndIf
	/*
	?	NF. com pedido não liberado ( disponível para recebimento);
		?	NF. sem pedido;
		?	NF. com divergência de Valor  em relação ao pedido;
		?	NF. com divergência de quantidade em relação ao pedido;
		?	NF.com Unidade de medida do produto diferente;
		?	Item não localizado nos pedidos;
		?	Divergência nos impostos;
		*/
Return






Static Function AJUSTSTR(cStr)
	
	Local nY		:= 0
	Local cNewStr	:= ""
	
	For nY:=1 To Len(cStr)
		
		If asc(substr(cStr,nY,1))<>10
			cNewStr		+= substr(cStr,nY,1)
		EndIf
		
	Next
	
Return(cNewStr)



Static Function XMLMAIL(_aMsg)
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Monitoramento de NF-e'+' - Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt
	Local cFuncSent:= "XMLMAIL"
	Local _nLMai   := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _cEmail  := 'clayton.braga@steck.com.br;EDVALDO.FERREIRA@steck.com.br'//'clayton.braga@steck.com.br '
	
	
	
	If __cuserid = '000000'
		//	_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>'  + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			
			
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]   	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,4]  	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,6]   	+ ' </Font></B></TD>'
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,7]   	+ ' </Font></B></TD>'
			cMsg += '</TR>'
			
			
			
			
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
		
		
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)
		
	EndIf
	RestArea(aArea)
	
Return()
