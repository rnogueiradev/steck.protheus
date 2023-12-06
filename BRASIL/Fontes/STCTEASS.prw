#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TSSNFSEOperation.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
Static __nOperation

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³STNFSASS ³ Autor ³GIOVANI ZAGO             ³ Data ³09.05.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de assinatura de um XML no padrao X.509              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: String                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: String com o XML que sera assinado                   ³±±
±±³          ³ExpC2: Tag que sera assinada                                ³±±
±±³          ³ExpC3: Tag que contem o ID                                  ³±±
±±³          ³ExpC4: Id da entidade                                       ³±±
±±³          ³ExpC5: Finalidade do Certificado                            ³±±
±±³          ³ExpC6: Modelo do WS Utilizado                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STCTEASS(cCodMun,cXML,cTag,cAttID,cIdEnt, cUso, cModelo,cPassword,cURI)
	
	Local cXmlToSign  := ""
	Local cDir        := IIf(IsSrvUnix(),"CERTIFICADOS/", "CERTIFICADOS\")
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
	Local cTipoSig    := "1"
	Default cURI      := ""
	If !Empty(Select("SPED001"))
		DbSelectArea("SPED001")
		("SPED001")->(dbCloseArea())
	Endif
	
	USE &("SPED001") ALIAS &("SPED001") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED001")
	DBSETINDEX("SPED00101")
	
	MsSeek(_cIdEnt)
	
	If !Empty(Select("SPED000"))
		DbSelectArea("SPED000")
		("SPED000")->(dbCloseArea())
	Endif
	
	USE &("SPED000") ALIAS &("SPED000") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED000")
	DBSETINDEX("SPED00001")
	
	cPassCert   := Iif( !Empty(cPassword), Decode64(AllTrim(cPassword)),Decode64(AllTrim(SPED001->PASSCERT)))
	
	
	cModelo   := Iif(Empty(cModelo),"001",cModelo)
	
	cRootPath  := StrTran(cRootPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Assina a NFSe                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("EVPPrivSign")
		
		If cModelo $ "001"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Canoniza o XML                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cXmlToSign := XmlC14N(cXml, "", @cError, @cWarning)
			
			cXmlToSign := (StrTran(cXmlToSign,"&lt;/","</"))
			cXmlToSign := (StrTran(cXmlToSign,"/&gt;","/>"))
			cXmlToSign := (StrTran(cXmlToSign,"&lt;","<"))
			cXmlToSign := (StrTran(cXmlToSign,"&gt;",">"))
			cXmlToSign := (StrTran(cXmlToSign,"<![CDATA[[ ","<![CDATA["))
			
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
				
				cNameSpace := ' xmlns:ns1="http://localhost:8080/WsNFe2/lote"'
				cNameSpace += ' xmlns:tipos="http://localhost:8080/WsNFe2/tp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
				
				If ( cCodMun == "3550308" .or. cCodMun == "2611606" .or. cCodMun == "1302603"   )
					cNameSpace := " "
				EndIf
				cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +cNameSpace)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o DigestValue da assinatura                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cDigest := (StrTran(cDigest,"&lt;/","</"))
				cDigest :=  (StrTran(cDigest,"/&gt;","/>"))
				cDigest := (StrTran(cDigest,"&lt;","<"))
				cDigest := (StrTran(cDigest,"&gt;",">"))
				cDigest := (StrTran(cDigest,"<![CDATA[[ ","<![CDATA["))
				
				cDigest := XmlC14N(cDigest, "", @cError, @cWarning)
				cMacro  := "EVPDigest"
				
				cDigest := Encode64(&cMacro.( cDigest , 3 ))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o SignedInfo  da assinatura                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSignInfo := GetSignInfo(cUri,cDigest, cTipoSig, cNameSpace, cCodMun)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Assina o XML                                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMacro     := "EVPPrivSign"
				
				cSignature := &cMacro.(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_key.pem" , XmlC14N(cSignInfo, "", @cError, @cWarning) , 3 , cPassCert , @cError)
				cSignature := Encode64(cSignature)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Envelopa a assinatura                                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cTipoSig =="1"
					cXmlToSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
					If ( cCodMun == "3550308" .or. cCodMun == "2611606" )
						cXmltoSign += cSignInfo
					Else
						cXmltoSign += StrTran(cSignInfo,cNameSpace,"")
					EndIf
					cXmlToSign += '<SignatureValue>'+cSignature+'</SignatureValue>'
					cXmlToSign += '<KeyInfo>'
					cXmlToSign += '<X509Data>'
					cXmlToSign += '<X509Certificate>'+GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_cert.pem",.F.,cIdEnt)+'</X509Certificate>'
					cXmlToSign += '</X509Data>'
					cXmlToSign += '</KeyInfo>'
					cXmlToSign += '</Signature>'
					
					cXmlToSign := cIniXML+cXmlToSign+cFimXML
					
					//					cXmlToSign := StrTran(cXmlToSign,"</"+cTag+">","")
					//					cXmlToSign := cXmlToSign + "</"+cTag+">"
					
				ElseIf cTipoSig =="2"
					cXmlToSign += '<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">'
					cXmltoSign += cSignInfo
					cXmlToSign += '<ds:SignatureValue>'+cSignature+'</ds:SignatureValue>'
					cXmltoSign += '<ds:KeyInfo>'
					cXmltoSign += '<ds:X509Data>'
					cXmltoSign += '<ds:X509Certificate>'+GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_cert.pem",.F.,cIdEnt)+'</ds:X509Certificate>'
					cXmltoSign += '</ds:X509Data>'
					cXmltoSign += '</ds:KeyInfo>'
					cXmltoSign += '</ds:Signature>'
					
					cXmlToSign := cIniXML+cXmlToSign+cFimXML
					
					//					cXmlToSign := StrTran(cXmlToSign,"</"+cTag+">","")
					//					cXmlToSign := cXmlToSign + "</"+cTag+">"
				EndIf
				//If ( cCodMun == "3550308" .or. cCodMun == "3509502" )
					cXmlToSign := StrTran(cXmlToSign,"</"+cTag+">","")
					cXmlToSign := cXmlToSign+"</"+cTag+">"
			//	EndIf
			Else
				cXmlToSign := cXml
				ConOut("Sign Error thread: "+cError+"/"+cWarning)
			EndIf
			
		ElseIf cModelo $ "002" .Or. cCodMun == "9999999"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtenho a URI                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cUri := SpedNfeId(cXML,cAttId)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Canoniza o XML                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cXmlToSign := XmlC14N(cXml, "", @cError, @cWarning)
			cXmlToSign := 	cXml
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para troca de caracter referente ao xml da ANFAVEA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cXmlToSign := (StrTran(cXmlToSign,"&lt;/","</"))
			cXmlToSign = (StrTran(cXmlToSign,"/&gt;","/>"))
			cXmlToSign = (StrTran(cXmlToSign,"&lt;","<"))
			cXmlToSign = (StrTran(cXmlToSign,"&gt;",">"))
			cXmlToSign = (StrTran(cXmlToSign,"<![CDATA[[ ","<![CDATA["))
			
			cError:=' '
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
				nAtver := At("versao",cNameSpace) // Pode ter um atributo versao Ex. ( xmlns="http://" versao="1.01")
				If nAtver > 0
					cNameSpace := SubStr(cNameSpace, 1, nAtver-1) // -2 por causa do espaco
					cNameSpace := RTrim(cNameSpace)
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o DigestValue da assinatura                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cCodMun $ "3547809-3115300-2704302"	// Santo Andre e Cataguases e Maceio
					cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +" ")
				Else
					cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +" "+cNameSpace+" ")
				EndIF
				cDigest := XmlC14N(cDigest, "", @cError, @cWarning)
				cMacro  := "EVPDigest"
				cDigest := Encode64(&cMacro.( cDigest , 3 ))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o SignedInfo  da assinatura                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cCodMun $ "3547809-3115300-2704302"	//Santo Andre e Cataguases e Maceio
					Do Case
					Case  '</EnviarLoteRpsEnvio>' $ cXmlToSign
						cNameSpace:=' xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:tipos="http://www.ginfes.com.br/tipos_v03.xsd"'
					Case '</ConsultarLoteRpsEnvio>' $ cXmlToSign  .Or. '</ConsultarNfseRpsEnvio>' $ cXmlToSign .Or. '</ConsultarNfseEnvio>' $ cXmlToSign
						cNameSpace:=' xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:n2="http://www.altova.com/samplexml/other-namespace" xmlns:tipos="http://www.ginfes.com.br/tipos_v03.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
					Case '</tns:CancelarNfseEnvio>' $ cXmlToSign
						cNameSpace:=' xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:n1="http://www.altova.com/samplexml/other-namespace" xmlns:tipos="http://www.ginfes.com.br/tipos" xmlns:tns="http://www.ginfes.com.br/servico_cancelar_nfse_envio" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
					EndCase
				EndIf
				cSignInfo := NfseSigInf(cUri,cDigest,cTipoSig,cNameSpace,cCodMun)
				cSignInfo := XmlC14N(cSignInfo, "", @cError, @cWarning)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Assina o XML                                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SpedGetMv("MV_HSM",cIdEnt)=="0"
					cMacro   := "EVPPrivSign"
					cSignature := &cMacro.(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_key.pem" , cSignInfo , 3 , cPassCert , @cError)
				Else
					If GetBuild() >= '7.00.081215P-20090626'
						cMacro   := "HSMPrivSign"
						cSignature := &cMacro.("slot_"+SpedGetMv("MV_HSMSLOT",cIdEnt)+"-label_"+SpedGetMv("MV_KEYLABE",cIdEnt), cSignInfo , 3 , @cError, cPassCert)
					Else
						cMacro   := "HSMPrivSign"
						cSignature := &cMacro.("slot_"+SpedGetMv("MV_HSMSLOT",cIdEnt)+"-label_"+SpedGetMv("MV_KEYLABE",cIdEnt), cSignInfo , 3 , @cError)
					EndIf
				EndIf
				If cCodMun $ "3547809-3115300-2704302"	// Santo Andre e Cataguases e Maceio
					If '</tns:CancelarNfseEnvio>' $ cXmlToSign
						cDsig := "ds:"
					Else
						cDsig := "dsig:"
					EndIF
				Else
					cDsig := ""
				EndIf
				cSignature := Encode64(cSignature)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Envelopa a assinatura                                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cNewFunc := "PemInfo"
				aInfo := &cNewFunc.(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_cert.pem",cPassCert)
				
				cXmlToSign += '<'+cDsig+'Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
				cXmltoSign += cSignInfo
				cXmlToSign += '<SignatureValue>'+cSignature+'</SignatureValue>'
				cXmltoSign += '<KeyInfo>'
				cXmltoSign += '<X509Data>'
				If !(cCodMun $ "3547809-3304557-3115300-3106200-3501608-2704302")
					cXmltoSign += '<X509SubjectName>'+aInfo[1][2]+'</X509SubjectName>'
				EndIf
				cXmltoSign += '<X509Certificate>'+GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_cert.pem",SpedGetMv("MV_HSM",cIdEnt)=="1",cIdEnt)+'</X509Certificate>'
				cXmltoSign += '</X509Data>'
				
				/*SP-Americana, MG-Belo Horizonte, RJ-Rio de Janeiro*/
				If !(cCodMun $ "3304557-3106200-3501608")
					cNewFunc  := "RSAModulus"
					cModulus  := &cNewFunc.(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_key.pem",.F.,cPassCert)
					
					cNewFunc  := "RSAExponent"
					cExponent := &cNewFunc.(IIf(IsSrvUnix(),"/", "\")+cDir+cUso+cIdEnt+"_key.pem",.F.,cPassCert)
					
					If !cCodMun $ "3547809-3115300-2704302"
						cXmltoSign += '<KeyValue>'
						cXmltoSign += '<RSAKeyValue>'
						cXmltoSign += '<Modulus>'+Encode64(cModulus)+'</Modulus>'
						cXmltoSign += '<Exponent>'+Encode64(cExponent)+'</Exponent>'
						cXmltoSign += '</RSAKeyValue>'
						cXmltoSign += '</KeyValue>'
					EndIf
				Endif
				
				cXmltoSign += '</KeyInfo>'
				cXmltoSign += '</'+cDsig+'Signature>'
				
				If cCodMun $ "3547809-3115300-2704302" //Acerto XML no Final para bater o Digest de Santo Andre e Cataguases
					Do Case
					Case '</EnviarLoteRpsEnvio>' $ cXmltoSign
						cXmltoSign:= StrTran(cXmltoSign,"</EnviarLoteRpsEnvio>","")
						cFimXml:= "</EnviarLoteRpsEnvio>"
					Case '</ConsultarLoteRpsEnvio>' $ cXmltoSign
						cXmltoSign:= StrTran(cXmltoSign,"</ConsultarLoteRpsEnvio>","")
						cFimXml:= "</ConsultarLoteRpsEnvio>"
					Case '</ConsultarNfseRpsEnvio>' $ cXmltoSign
						cXmltoSign:= StrTran(cXmltoSign,"</ConsultarNfseRpsEnvio>","")
						cFimXml:= "</ConsultarNfseRpsEnvio>"
					Case '</ConsultarNfseEnvio>' $ cXmltoSign
						cXmltoSign:= StrTran(cXmltoSign,"</ConsultarNfseEnvio>","")
						cFimXml:= "</ConsultarNfseEnvio>"
					Case '</tns:CancelarNfseEnvio>' $ cXmltoSign
						cXmltoSign:= StrTran(cXmltoSign,"</tns:CancelarNfseEnvio>","")
						cFimXml:= "</tns:CancelarNfseEnvio>"
					EndCase
				EndIf
				
				cXmlToSign := cIniXML+cXmlToSign+cFimXML
			Else
				cXmlToSign := cXml
				ConOut("Sign Error thread: "+cError+"/"+cWarning)
			EndIf
		Else
			ConOut("Falha ao tentar assinar NFSE.","Modelo não homologado.")
		EndIf
		
	Else
		cXmlToSign := "Falha"
		ConOut("Falha ao tentar assinar NFSE.","Necessario Build " + GetBuild() + " ou superior.")
	EndIf
	
Return(cXmlToSign)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |GetSignInfo| Autor ³Roberto Souza         ³ Data ³11.11.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera o envelopamento da tag SignedInfo para a assinatura.   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TSS - Totvs Multimarcas                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSignInfo(cUri,cDigest, cTipoSig,cNameSpace,cCodMun)
	Local cSignedInfo	:= ""
	Local nOperation	:= 0
	
	DEFAULT cTipoSig 	:= "2"
	DEFAULT cNameSpace 	:= ""
	If ( Empty(cNameSpace) )
		cNameSpace	:= getSignNameSpc( cCodMun )
	EndIf
	
	If cTipoSig =="1"
		cSignedInfo += '<SignedInfo '+cNameSpace+'>'
		cSignedInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
		cSignedInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />'
		If Empty(cUri)
			cSignedInfo += '<Reference URI="'+ cUri +'">'
		Else
			cSignedInfo += '<Reference URI="#'+ cUri +'">'
		EndIf
		cSignedInfo += '<Transforms>'
		cSignedInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />'
		//If ( !(cCodMun $ "3550308|2611606") .or. ( cCodMun $ "3550308|2611606" .And. nOperation == 9 ) )
		cSignedInfo += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
		//	EndIf
		cSignedInfo += '</Transforms>'
		cSignedInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />'
		cSignedInfo += '<DigestValue>' + cDigest + '</DigestValue>'
		cSignedInfo += '</Reference>'
		cSignedInfo += '</SignedInfo>'
		
		
	ElseIf cTipoSig=="2"
		
		cSignedInfo += '<ds:SignedInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">'
		cSignedInfo += '<ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></ds:CanonicalizationMethod>'
		cSignedInfo += '<ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></ds:SignatureMethod>'
		If Empty(cUri)
			cSignedInfo += '<ds:Reference URI="'+ cUri +'">'
		Else
			cSignedInfo += '<ds:Reference URI="#lote:'+ cUri +'">'
		EndIf
		cSignedInfo += '<ds:Transforms>'
		cSignedInfo += '<ds:Transform Algorithm="http://www.w3.org/TR/1999/REC-xpath-19991116">'
		cSignedInfo += '<ds:XPath>not(ancestor-or-self::ds:Signature)</ds:XPath>'
		cSignedInfo += '</ds:Transform>'
		cSignedInfo += '<ds:Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments"></ds:Transform>'
		cSignedInfo += '</ds:Transforms>'
		cSignedInfo += '<ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></ds:DigestMethod>'
		cSignedInfo += '<ds:DigestValue>' + cDigest + '</ds:DigestValue>'
		cSignedInfo += '</ds:Reference>'
		cSignedInfo += '</ds:SignedInfo>'
	EndIf
	
Return(cSignedInfo)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |NfseSigInf| Autor  ³Roberto Souza         ³ Data ³11.11.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera o envelopamento da tag SignedInfo para a assinatura.   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TSS - Totvs Multimarcas                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NfseSigInf(cUri,cDigest,cTipoSig,cNameSpace,cCodMun)
	Local cSignedInfo := ""
	Do Case
		
	Case cCodMun $ "3547809-3115300-2704302" // Santo Andre
		cSignedInfo += '<SignedInfo'+cNameSpace+'>'
		cSignedInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
		cSignedInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />'
		cSignedInfo += '<Reference URI="">'
		cSignedInfo += '<Transforms>'
		cSignedInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />'
		cSignedInfo += '</Transforms>'
		cSignedInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />'
		cSignedInfo += '<DigestValue>' + cDigest + '</DigestValue>'
		cSignedInfo += '</Reference>'
		cSignedInfo += '</SignedInfo>'
		
	OtherWise
		
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
		
	EndCase
Return(cSignedInfo)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |GetCertificate     ³Roberto Souza         ³ Data ³11.11.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna os dados do certificado.                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TSS - Totvs Multimarcas                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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
		Conout("Certificado nao encontrado no diretorio Certs - Realizar a configuracao do certificado para entidade "+cIdEnt+" !")
	EndIf
	
Return(cCertificado)


//-------------------------------------------------------------------
/*/{Protheus.doc} GetSignNameSpc
Retorna o namespace para o SignInfo de acordo com a operação que esta
esta sendo executada (Consulta, Cancelamento ou Envio) e o município.

@author Henrique de Souza Brugugnoli
@since 24/06/2010
@version 1.0

@param	cCodMun	Código do município

@return	cReturn	Namespace específico por operação e município
/*/
//-------------------------------------------------------------------

Static  Function getSignNameSpc( cCodMun )

Local cNameSpace	:= ""

Local nOperation	:= 0

If ( nOperation == 0 )
	/*São Paulo*/
	If ( cCodMun == "3550308" )
	
	cNameSpace := 'xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:p="http://www.prefeitura.sp.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
		
		
/*campinas*/
	ElseIf ( cCodMun == "2611606" )
		cNameSpace := 'xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:p1="http://www.recife.pe.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
	ElseIf ( cCodMun == "1302603" )
		cNameSpace := 'xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns="http://www.ginfes.com.br/servico_consultar_nfse_envio_v03.xsd" xmlns="http://www.ginfes.com.br/tipos_v03.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
		EndIf
	
EndIf

If ( Empty(cNameSpace) )
	cNameSpace := 'xmlns="http://www.w3.org/2000/09/xmldsig#"'
EndIf

cReturn := cNameSpace

Return cReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} setOperation
Função para atribuir a operação que esta sendo executada pelo JOB.

@author Henrique de Souza Brugugnoli
@since 24/06/2010
@version 1.0

@param	nOperation	Operação que esta sendo executada de acordo com
o conteúdo:
CONSULTAR -> 1
CANCELAR  -> 2
ENVIAR 	  -> 3

@return	__nOperation	Operação que foi atribuída
/*/
//-------------------------------------------------------------------

Static Function setOperation( nOperation )
	
	DEFAULT nOperation	:= 0
	
	/*Verifica se a mesma operação ja foi atribuida e se é válida*/
	If ( nOperation <> __nOperation .And. nOperation <> 0 )
		__nOperation	:= nOperation
	EndIf
	
Return __nOperation

