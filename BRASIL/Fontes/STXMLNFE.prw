#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTXMLNFE	บAutor  ณGiovani Zago        บ Data ณ  07/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ															  บฑฑ
ฑฑบ          ณ 				 											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STXMLNFE(pEmpAnt)
	Default pEmpAnt := "01"              // Valdemir Rabelo 10/03/2021 - 20220307005266

	//RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")

	If pEmpAnt = "11"

		PREPARE ENVIRONMENT EMPRESA pEmpAnt FILIAL "01"

		ConOut("[STXMLNFE]["+ FWTimeStamp(2) +"] - Inicio do processamento.")

		cQry := " UPDATE SB2110 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
		TcSQLExec(cQry)

		cQry := " UPDATE SB2110 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
		TcSQLExec(cQry)

	Else

		PREPARE ENVIRONMENT EMPRESA pEmpAnt FILIAL "01"

		ConOut("[STXMLNFE]["+ FWTimeStamp(2) +"] - Inicio do processamento.")

		cQry := " UPDATE SB2010 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
		TcSQLExec(cQry)

		cQry := " UPDATE SB2030 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
		TcSQLExec(cQry)

		cQry := " UPDATE SB2010 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
		TcSQLExec(cQry)

		cQry := " UPDATE SB2030 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
		//TcSQLExec(cQry)   Voltar depois

	EndIf 
	//Abrir threads por empresa da fun็ใo conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())

		If  (SM0->M0_CODIGO==pEmpAnt .And. SM0->M0_CODFIL=="01") .Or.;
			(SM0->M0_CODIGO==pEmpAnt .And. SM0->M0_CODFIL=="02") .Or.;
			(SM0->M0_CODIGO==pEmpAnt .And. SM0->M0_CODFIL=="03") .Or.;
			(SM0->M0_CODIGO==pEmpAnt .And. SM0->M0_CODFIL=="04") .Or.;
			(SM0->M0_CODIGO==pEmpAnt .And. SM0->M0_CODFIL=="05")
		
			//If (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="05")
			//If SM0->M0_CODFIL=="02"
			//u_CONSNFE(SM0->M0_CODIGO,SM0->M0_CODFIL)
			//u_STWSDLNFE(AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)

			StartJob("U_CONSNFE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			startJob("U_STWSDLNFE",GetEnvServer(), .F.,AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)
		EndIf

		SM0->(DbSkip())

	EndDo

	Reset Environment

	ConOut("[STXMLNFE]["+ FWTimeStamp(2) +"] - Fim do processamento.")

Return()

User Function AMSTXMLNFE()

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	//Abrir threads por empresa da fun็ใo conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())

		If  (SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
			//u_STWSDLNFE(AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)
			startJob("U_STWSDLNFE",GetEnvServer(), .F.,AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)
			StartJob("U_CONSNFE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
		EndIf

		SM0->(DbSkip())

	EndDo

	Reset Environment

Return()

/*******************************************
A็ใo...........: Job especํfico para empresa NewCo Distribuidora.
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: 
*******************************************/
USER FUNCTION DISTXMLNFE()

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	//startJob("U_STWSDLNFE",GetEnvServer(), .F.,AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)
	//StartJob("U_CONSNFE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
	U_STWSDLNFE(AllTrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL)
	U_CONSNFE(SM0->M0_CODIGO,SM0->M0_CODFIL)

	Reset Environment

RETURN


User Function STWSDLNFE(cCnpj,cNewEmp,cNewFil) // '05890658000210','01','02'

	Local cMensagemXML	:= ''
	Local _cNsu			:= ''
	Local _cUltNsu		:= ''
	Local oNfe
	Local lSaida 		:= .F.
	Local cEst			:= Iif(cNewEmp $'01#11','35','13')
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos      := SUBSTR(cTime, 4, 2)
	Local cSegundos     := SUBSTR(cTime, 7, 2)
	Local _nHix         := 0
	Local _nHfx         := 0
	Local i        	    := 0
	Local _lWf14		:= .f.
	Local lSF1          := .F.    // Valdemir Rabelo 15/07/2021
	Default cNewEmp 	:= "01"
	Default cNewFil 	:= "02"
	Default cCnpj		:= "05890658000210"

	ConOut("[STWSDLNFE]["+ FWTimeStamp(2) +"] - Inicio do processamento - Empresa: "+cNewEmp+cNewFil)

	_nHix         :=   val(cHora+cMinutos+cSegundos)
	If cMinutos = '59'
		_nHfx         := _nHix+4210
	Else
		_nHfx         := _nHix+210
		If _nHfx >= 235959
			_nHfx := 000200
		EndIf
	EndIf

	//cNewEmp := "11"
	//cNewFil := "01"
	//cCnpj := "44415136000138"

	//Inicia outra Thread com outra empresa e filial
	//RpcSetType( 3 )
	//RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil
	conout("ENV - PUBLIC"+cEmpAnt+'/'+cFilAnt+' - '+time())
	conout("ENV - RECEBIDA"+cNewEmp+'/'+cNewFil+' - '+time())
	
	_cAlias1 := GetNextAlias()

	Do While !lSaida
		cTime         := Time()
		cHora         := SUBSTR(cTime, 1, 2)
		cMinutos      := SUBSTR(cTime, 4, 2)
		cSegundos     := SUBSTR(cTime, 7, 2)
		_nHix         :=   val(cHora+cMinutos+cSegundos)
		If _nHix >= _nHfx
			//conout("tempo")
			lSaida := .T.
			loop
		EndIf
		_cNsu			:= Alltrim(GetMv("ST_NSUNFEW",,'000000000000001'))

		cMensagemXML:='<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">'
		cMensagemXML+='<tpAmb>1</tpAmb>'
		cMensagemXML+='<cUFAutor>'+ Alltrim(cEst)+'</cUFAutor>'
		cMensagemXML+='<CNPJ>'+ Alltrim(cCnpj)+'</CNPJ>'
		cMensagemXML+='<distNSU>'
		cMensagemXML+='<ultNSU>'+ Alltrim(_cNsu) +'</ultNSU>'
		cMensagemXML+='</distNSU>'
		cMensagemXML+='</distDFeInt>'

		_oWS := WSNFeDistribuicaoDFe():New()
		_oWS:oWSnfeDadosMsg   := cMensagemXML

		If _oWS:nfeDistDFeInteresse()

			oXml:=  _oWS:oWSnfeDistDFeInteresseResult

			If Alltrim(	oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '656'
				Conout("Rejei็ใo: 656 - Erro ao enviar nota: Consumo indevido "+cEmpAnt+'/'+cFilAnt+' - '+time())
				lSaida := .T.
				loop
			EndIf
			If Alltrim(	oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '215'
				Conout(Alltrim(	oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_XMOTIVO:TEXT)+" - "+ dToc(Date())+" - "+Time()	)
				lSaida := .T.
				loop
			EndIf
			_cUltNsu	:=   	oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
			//_cUltNsu:= Soma1(_cNsu)
			_cUltNsu:= _cUltNsu
			If  Alltrim(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '137'
				PUTMV("ST_NSUNFEW",_cUltNsu)
				If Alltrim(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT) == Alltrim(_cUltNsu)
					PUTMV("ST_NSUNFEW",'000000000000000')
					Exit					
				EndIf 
			EndIf

			If Alltrim(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '138'
				If VALTYPE(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP) = "A"
					_nDocs:= Len(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP)
				Else
					_nDocs:= 1
				EndIf

				For i:=1 To _nDocs
					_nLenComp:=0
					If _nDocs = 1
						_cZip:=	  Decode64( oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT )
					Else
						_cZip:=	  Decode64( oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[i]:TEXT )
					EndIf
					_nLenComp := Len( _cZip )

					_cXml := ""
					_nLenUncomp := 0
					_lRet := .F.
					_lRet := GzStrDecomp( _cZip, _nLenComp, @_cXml )
					_cXml:= '<?xml version="1.0" encoding="UTF-8"?>'+Alltrim(_cXml)

					If _lRet
						cAviso := ' '
						cErro  := ' '
						cStatus  := ' '
						_nHandle:=0
						oNfe:= XmlParser(_cXml,'_',@cErro,@cAviso)

						If Empty(cErro) .And. Empty(cAviso)
							_nLenUncomp := Len( _cXml )

							_cinf :=  XmlChildEx ( oNfe,"_PROCEVENTONFE" )//NFE XML
							If _cinf <> NIL
								_cinf :=  XmlChildEx ( oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO,"_CNPJDEST" )//NFE XML
								If _cinf <> NIL
									_nHandle := FCreate( "\arquivos\XMLNFE\evento - "+ Alltrim(oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CHNFE:TEXT)+".xml" )

									If  Alltrim(oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CNPJDEST:TEXT) = Alltrim(cCnpj)
										_cStu:= '210210'
										cStatusAtu	:= "Ciencia"

										_cStu:= Alltrim(oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT)
										/*
										210200 - Confirma็ใo da Opera็ใo

										210210 - Ci๊ncia da Opera็ใo

										210220 - Desconhecimento da Opera็ใo

										210240 - Opera็ใo nใo Realizada
										*/

										DO CASE
											CASE AllTrim(_cStu)=="210210"
											_cStu:='0'
											cStatusAtu	:= "Ciencia"//"Sem Manifestacao"
											CASE AllTrim(_cStu)=="210200"
											_cStu:='1'
											cStatusAtu	:= "Confirmada Operacao"
											CASE AllTrim(_cStu)=="210220"
											_cStu:='2'
											cStatusAtu	:= "Desconhecida"
											CASE AllTrim(_cStu)=="210240"
											_cStu:='3'
											cStatusAtu	:= "Operacao nao Realizada"
											CASE AllTrim(_cStu)=="110111"
											_cStu:='X'
											cStatusAtu	:= "Nf cancelada"
										ENDCASE

										DbSelectArea("SZ9")
										SZ9->(DbGoTop())
										SZ9->(DbSetOrder(1))
										If (SZ9->(DbSeek(cFilAnt+ Alltrim(oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CHNFE:TEXT))))
											SZ9->(RecLock("SZ9",.F.))
										Else
											SZ9->(RecLock("SZ9",.T.))
										EndIf'

										SZ9->Z9_STATUS	:= "0"

										If AllTrim(_cStu)$"X"
											SZ9->Z9_XML	:= "Nota fiscal cancelada"
											SZ9->Z9_STATUS	:= "X"
										EndIf
										SZ9->Z9_FILIAL	:= cFilAnt
										SZ9->Z9_CHAVE	:= Alltrim(oNfe:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CHNFE:TEXT)
										//SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"INCLUINDO Evento: "+cStatusAtu+" Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
										SZ9->Z9_STATUSA	:= cStatusAtu
										SZ9->Z9_ORIGEM	:= 'NF-E'

										dbSelectArea("SF1")
										SF1->(DbSetOrder(8))
										lSF1 := SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))
										If  lSF1 
											If SZ9->Z9_DOC <> Alltrim(SF1->F1_DOC) .Or. SZ9->Z9_SERIE <> SF1->F1_SERIE
												SZ9->Z9_SERIE	:= Alltrim(SF1->F1_SERIE)
												SZ9->Z9_DOC		:= Alltrim(SF1->F1_DOC)
											EndIf											
										EndIf

										SZ9->(MsUnlock())
										SZ9->(DbCommit())

										// Valdemir Rabelo 15/07/2021 - Ticket: 20210707011905
										if (AllTrim(_cStu)$"X") .and. lSF1
										   U_UPDTESF1(SF1->F1_DOC) //StaticCall (CONSLOTE, UPDTESF1, SF1->F1_DOC)
										endif 
									EndIf
								EndIf
							EndIf

							_cinf :=  XmlChildEx ( oNfe,"_NFEPROC" )//NFE XML
							If _cinf <> NIL
								_nHandle := FCreate( "\arquivos\XMLNFE\"+ Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT)+".xml" )
								If  _nHandle = 0
									MsgInfo("nhandle")
								EndIf

								FWrite( _nHandle, _cXml, _nLenUncomp )
								FClose( _nHandle )

								_cStu:= '0'
								cStatusAtu	:= "Ciencia"

								DbSelectArea("SZ9")
								SZ9->(DbGoTop())
								SZ9->(DbSetOrder(1))
								If !(SZ9->(DbSeek(cFilAnt+Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT))))
									SZ9->(RecLock("SZ9",.T.))
									SZ9->Z9_STATUS	:= _cStu
									SZ9->Z9_STATUSA	:= cStatusAtu
									_lWf14:= .T.
									SZ9->Z9_DATA	:= DATE()
									SZ9->Z9_HORA	:= TIME()
								Else
									SZ9->(RecLock("SZ9",.F.))
								EndIf

								SZ9->Z9_NFOR  	:= Upper(Alltrim(oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT))
								SZ9->Z9_FILIAL	:= cFilAnt
								SZ9->Z9_NOMFOR	:= Upper(Alltrim(oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT))
								SZ9->Z9_VALORNF	:= Val(Alltrim(oNfe:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT))
								SZ9->Z9_CHAVE	:= Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT)
								SZ9->Z9_SERORI	:= Padl(Alltrim(onfe:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT),3,'0')
								SZ9->Z9_NFEORI	:= Padl(Alltrim(onfe:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,'0')
								SZ9->Z9_DTEMIS	:= CTOD(SubStr(Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT),9,2)+"/"+SubStr(Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT),6,2)+"/"+SubStr(Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT),1,4))
								_cinf :=  XmlChildEx ( oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT,"_CNPJ" )//NFE XML
								If _cinf <> NIL

									SZ9->Z9_CNPJ	:= Alltrim(oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT,"_CPF" )//NFE XML
								If _cinf <> NIL

									SZ9->Z9_CNPJ	:= Alltrim(oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT)
								EndIf

								SZ9->Z9_NSU	 	:= Alltrim(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT)
								//SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"INCLUINDO Xml Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
								SZ9->Z9_XML		:= _cXml
								SZ9->Z9_ORIGEM	:= 'NF-E'

								_cinf :=  XmlChildEx ( onfe:_NFEPROC:_NFE:_INFNFE:_IDE,"_NFREF" )//NFE XML
								If _cinf <> NIL
									SZ9->Z9_C14	:=  'DEVOLUCAO'
								EndIf
								dbSelectArea("SF1")
								SF1->(DbSetOrder(8))
								If  SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))
									If SZ9->Z9_DOC <> Alltrim(SF1->F1_DOC) .Or. SZ9->Z9_SERIE <> SF1->F1_SERIE
										SZ9->Z9_SERIE	:= Alltrim(SF1->F1_SERIE)
										SZ9->Z9_DOC		:= Alltrim(SF1->F1_DOC)
									EndIf
								EndIf

								SZ9->(MsUnlock())
								SZ9->(DbCommit())

								If SubStr(Alltrim(SZ9->Z9_CNPJ) ,1,8) $ GetMv("ST_DEVHOM",,'01438784/01438784/03840986/63004030/10280765/03439316/23476033')
									If _lWf14
										StartJob("U_STWF14",GetEnvServer(), .F.,SZ9->(RECNO()))
									EndIf
									_lWf14:= .F.
								EndIf

							EndIf
						EndIf

					EndIf

				Next i
				PUTMV("ST_NSUNFEW",_cUltNsu)
			EndIf

		Else
			Conout(GetWSCError()+" - "+ dTos(Date())+" - "+Time())  // Resumo do erro
			lSaida := .T.
			loop
		EndIf

		If _cUltNsu = oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT .And. Val(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT) <> 0
			lSaida := .T.
			PUTMV("ST_NSUNFEW",'000000000000000')
			loop
		EndIf

	EndDo
	lSaida:= .F.

	//Reset Environment

	ConOut("[STWSDLNFE]["+ FWTimeStamp(2) +"] - Fim do processamento - Empresa: "+cNewEmp+cNewFil)

Return()

