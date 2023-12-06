#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STNFS03	ºAutor  ³Giovani Zago     º Data ³  15/05/17      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³cte sao paulo 											  º±±
±±º          ³   													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STCTE00( )//cte

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	//Abrir threads por empresa da função conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())


		If  (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
		(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="05") //.Or.;
		//(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02")
			StartJob("U_STCTE01",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
		EndIf

		SM0->(DbSkip())

	EndDo

	Reset Environment
Return()

User Function STCTEAM( )//cte

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	//Abrir threads por empresa da função conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())


		If  (SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
			StartJob("U_STCTE01",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
		EndIf

		SM0->(DbSkip())

	EndDo

	Reset Environment
Return()


/*******************************************
Ação...........: Job específico para empresa NewCo Distribuidora.
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: 
*******************************************/
USER FUNCTION STCTEDIS()//cte

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	StartJob("U_STCTE01",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
	//U_STCTE01("11","01")

	RESET ENVIRONMENT

RETURN

User Function STCTE01(cNewEmp,cNewFil )//cte
	Local oXml
	Local _oWS
	//Local cNewEmp 		:= '01'
	//Local cNewFil		:= '02'
	Local nVersaoSchema := 1
	Local cMensagemXML 	:= ' '
	Local lSaida 		:= .F.
	Local _nPag			:= 1
	Local _aEmp			:= {}
	Local _cDtIni		:= ''
	Local _cDtFim		:= ''
	Local _cInscM		:= ''
	Local _cNumNf		:= ''
	Local _CCGC			:= ''
	Local cEst			:= '35'
	Local _aRet			:= {}
	Local _cUltNsu		:= ''
	Local _cCoun		:= '01'
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos      := SUBSTR(cTime, 4, 2)
	Local cSegundos     := SUBSTR(cTime, 7, 2)
	Local _nHix         := 0
	Local _nHfx         := 0
	Local k		:= 0
	Local _nX  := 0
	Private cErro, cAviso,_cIdEnt ,_cPass,_cXml,cNom,__XMLHeadRet
	Default cNewEmp		:= '01'
	Default cNewFil		:= '02'

	Aadd(_aEmp,{cNewEmp,cNewFil})

	_nHix         :=   val(cHora+cMinutos+cSegundos)
	If cMinutos = '59'
		_nHfx         := _nHix+4210
	Else
		_nHfx         := _nHix+210
		If _nHfx >= 235959
			_nHfx := 000200
		EndIf
	EndIf


	For k:=1 To Len(_aEmp)
		cNewEmp 	:= _aEmp[k,1]
		cNewFil		:= _aEmp[k,2]
		conout("E"+cNewEmp+'/'+cNewFil+' - '+time())
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,)
		cEmpAnt := cNewEmp
		cFilAnt := cNewFil
		//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
		cCnpj	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_CGC")
		cIm 	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_INSCM")
		cNom	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_NOMECOM")
		cEst	:=  Substr(Posicione("SM0",1,cNewEmp+cNewFil,"M0_CODMUN"),1,2)
		_cIdEnt :=  U_XGETIND(cCnpj,"1")
		_cPass  :=  U_XGETIND(cCnpj,"2")

		_cDtIni:= dtos(ddatabase-30)
		_cDtFim:= dtos(ddatabase)
		_cDtIni:= substr(_cDtIni,1,4)+"-"+ substr(_cDtIni,5,2)+"-"+ substr(_cDtIni,7,2)
		_cDtFim:= substr(_cDtFim,1,4)+"-"+ substr(_cDtFim,5,2)+"-"+ substr(_cDtFim,7,2)


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

			_cNsu:= Alltrim(GetMv("ST_NSUCTE",,'000000000'))

			cMensagemXML:='<distDFeInt xmlns="http://www.portalfiscal.inf.br/cte" versao="1.00">
			cMensagemXML+='<tpAmb>1</tpAmb>
			cMensagemXML+='<cUFAutor>'+ cEst +'</cUFAutor>
			cMensagemXML+='<CNPJ>'+ Alltrim(cCnpj)+'</CNPJ>
			cMensagemXML+='<consNSU>
			cMensagemXML+='<NSU>'+_cNsu+'</NSU>
			cMensagemXML+='</consNSU>
			cMensagemXML+='</distDFeInt>


			_oWS := WSCTeDistribuicaoDFe():New()

			_oWS:_CERT			:= "D:\TOTVS\TSS30\certs\"+_cIdEnt+"_all.pem"
			_oWS:_PRIVKEY		:= "D:\TOTVS\TSS30\certs\"+_cIdEnt+"_key.pem"
			_oWS:_PASSPHRASE	:= _cPass
			_oWS:oWScteDadosMsg   := cMensagemXML

			If _oWS:cteDistDFeInteresse()

				oXml:=  _oWS:oWScteDistDFeInteresseResult

				If Alltrim(	oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '137'
					//_cUltNsu	:= oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT
					_cUltNsu	:=Soma1(_cNsu )
					PUTMV("ST_NSUCTE", (_cUltNsu))
					Loop
				EndIf

				If Alltrim(	oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT)	 $ '138'
					_nLenComp:=0

					_cZip:=	  Decode64( oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT )
					_nLenComp := Len( _cZip )

					_cXml := ""
					_nLenUncomp := 0
					_lRet := .F.
					_lRet := GzStrDecomp( _cZip, _nLenComp, @_cXml )
					_cXml:= '<?xml version="1.0" encoding="UTF-8"?>'+Alltrim(_cXml)

					If _lRet
						cAviso := ' '
						cErro  := ' '
						_nHandle:=0
						oCte:= XmlParser(_cXml,'_',@cErro,@cAviso)
						If Empty(cErro) .And. Empty(cAviso)
							_nLenUncomp := Len( _cXml )
							_cinf :=  XmlChildEx ( oCte,"_PROCEVENTOCTE" )
							If _cinf <> NIL
								_cChv	:= Alltrim(oCte:_PROCEVENTOCTE:_EVENTOCTE:_INFEVENTO:_CHCTE:TEXT)
								_nHandle := FCreate( "\arquivos\XML_CTE\WEB\"+cNewEmp+cNewFil+"_EVENTO_"+oCte:_PROCEVENTOCTE:_EVENTOCTE:_INFEVENTO:_CHCTE:TEXT+".xml" )
							EndIf
							_cinf :=  XmlChildEx ( oCte,"_CTEPROC" )
							If _cinf <> NIL .And. _nHandle = 0
								_cChv	:= Alltrim(oCte:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
								_nHandle := FCreate( "\arquivos\XML_CTE\WEB\"+cNewEmp+cNewFil+"_"+Alltrim(oCte:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)+".xml" )


								//_cChv	:= Alltrim(oCte:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
								cNom	:= ' '
								_cCgc 	:= ' '
								_cInscM	:= ' '
								_cNumNf := ' '
								_cCgc 	:= Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
								cNom	:= Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT)

								If valtype(_cCgc) <> 'C'
									_cUltNsu	:=Soma1(_cNsu )

									PUTMV("ST_NSUCTE",_cUltNsu)
									LOOP
								EndIf

								DbSelectArea("SZ9")
								SZ9->(DbGoTop())
								SZ9->(DbSetOrder(1))
								If !(SZ9->(DbSeek(cFilAnt+ Alltrim(_cChv))))


									DbSelectArea("Z1L")
									Z1L->(DbSetOrder(1))
									Z1L->(RecLock("Z1L",.T.))
									Z1L->Z1L_FILIAL := cNewFil
									Z1L->Z1L_CHAVE 	:= _cChv
									Z1L->Z1L_XML 	:= _cXml
									Z1L->Z1L_FIL 	:= cNewFil
									Z1L->Z1L_CGC 	:= cCnpj
									Z1L->Z1L_NOME 	:= cNom
									Z1L->Z1L_DTBAIX := DATE()
									Z1L->Z1L_TIME 	:= SUBSTR(TIME(),1,5)
									Z1L->Z1L_STATUS := '0'
									Z1L->Z1L_SERIE 	:= ''
									Z1L->Z1L_NOTA  	:= ''
									Z1L->Z1L_LOG    := ''
									Z1L->Z1L_DEPART := ' '
									Z1L->Z1L_REMETE := _cCgc
									Z1L->Z1L_INSCM 	:= _cInscM

									Z1L->Z1L_N01  	:= Val(Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT))

									DbSelectArea("SA2")
									SA2->(DbOrderNickName("CGCINSCR2"))
									If SA2->(DbSeek(xFilial("SA2")+_cCgc))
										Z1L->Z1L_COD    := SA2->A2_COD
										Z1L->Z1L_LOJA   := SA2->A2_LOJA
										Z1L->Z1L_NFOR  	:= SA2->A2_NOME
									EndIf
									Z1L->Z1L_ERRO   := ' '
									Z1L->Z1L_NFSE  	:= _cNumNf
									Z1L->Z1L_DTEMIS := STOD(STRTRAN(SUBSTR(Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT),1,10),'-',''))
									Z1L->Z1L_HORA   := SUBSTR(Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT),12,08)
									Z1L->(MsUnlock())
									Z1L->(DbCommit())


								EndIf
								cNom	:= ' '
								_cCgc 	:= ' '
								_cInscM	:= ' '
								_cNumNf := ' '
								_cCgc 	:= Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
								cNom	:= Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT)


								DbSelectArea("SZ9")
								SZ9->(DbGoTop())
								SZ9->(DbSetOrder(1))
								If !(SZ9->(DbSeek(cFilAnt+ Alltrim(_cChv))))
									SZ9->(RecLock("SZ9",.T.))
									SZ9->Z9_STATUS	:= "0"
									SZ9->Z9_STATUSA	:= "Ciencia"
								Else
									SZ9->(RecLock("SZ9",.F.))
								EndIf


								SZ9->Z9_NFOR  	:= cNom
								SZ9->Z9_NOMFOR  := cNom
								SZ9->Z9_FILIAL	:= cFilAnt
								SZ9->Z9_VALORNF	:= Val(Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT))
								SZ9->Z9_CHAVE	:= Alltrim(_cChv)
								SZ9->Z9_SERORI	:= ' '
								SZ9->Z9_NFEORI	:= ' '
								SZ9->Z9_DTEMIS	:= STOD(STRTRAN(SUBSTR(Alltrim(oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT),1,10),'-',''))
								SZ9->Z9_CNPJ	:= _cCgc
								SZ9->Z9_DATA	:= DATE()
								SZ9->Z9_HORA	:= TIME()
								SZ9->Z9_NSU	 	:= _cNsu
								SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"INCLUINDO Xml Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
								SZ9->Z9_XML		:= _cXml
								SZ9->Z9_ORIGEM	:= 'CT-E'
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

								_aImpostos := {}
								_nPesoD	   := 0
								_cTomad    := ""

								Do Case

									Case Type("oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ")=="A"
									For _nX:=1 To Len(oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ)
										If UPPER(AllTrim(oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ[_nX]:_TPMED:TEXT))=="PESO DECLARADO"
											_nPesoD := Val(oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ[_nX]:_QCARGA:TEXT)
										EndIf
									Next
									Case Type("oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ")=="O"
									If UPPER(AllTrim(oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ:_TPMED:TEXT))=="PESO DECLARADO"
										_nPesoD := Val(oCte:_CTEPROC:_CTE:_INFCTE:_infCTeNorm:_infCarga:_infQ:_QCARGA:TEXT)
									EndIf
								EndCase

								Do Case

									Case Type("oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP")=="A"
									For _nX:=1 To Len(oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP)
										_cnCT 	:= oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT
										_cDesc	:= oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[_nX]:_XNOME:TEXT
										_nValor	:= oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[_nX]:_VCOMP:TEXT
										If Type("oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT")=="C"
											_cTomad := oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
										EndIf
										AADD(_aImpostos,{_cnCT,_cDesc,_nValor,_cTomad,_nPesoD})
									Next
									GRVIMPCTE(_aImpostos)

									Case Type("oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP")=="O"
									_cnCT 	:= oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT
									_cDesc	:= oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT
									_nValor	:= oCte:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT
									If Type("oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT")=="C"
										_cTomad := oCte:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
									EndIf
									AADD(_aImpostos,{_cnCT,_cDesc,_nValor,_cTomad,_nPesoD})
									GRVIMPCTE(_aImpostos)

								EndCase

							EndIf

							If  _nHandle = 0
								conout("nhandle")
							Else
								FWrite( _nHandle, _cXml, _nLenUncomp )
								FClose( _nHandle )
							EndIf

							If _cCgc = '95591723003800' .And. cNewFil = '02'
								_nHandle := 0
								_nHandle := FCreate( "\arquivos\XML_CTE\CTE\SP\"+cNewEmp+cNewFil+"_"+ Alltrim(_cChv)+".xml" )

								If  _nHandle = 0
									conout("nhandle")
								Else
									FWrite( _nHandle, _cXml, _nLenUncomp )
									FClose( _nHandle )
								EndIf
							ElseIf cNewEmp = '03'
								_nHandle := 0
								_nHandle := FCreate( "\arquivos\XML_CTE\CTE\AM\"+cNewEmp+cNewFil+"_"+ Alltrim(_cChv)+".xml" )

								If  _nHandle = 0
									conout("nhandle")
								Else
									FWrite( _nHandle, _cXml, _nLenUncomp )
									FClose( _nHandle )
								EndIf
							EndIf

							_cCgc := ' '

							If oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT = _cNsu
								_cUltNsu	:= oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT
							Else
								_cUltNsu	:=Soma1(_cNsu )
							EndIf
							PUTMV("ST_NSUCTE",_cUltNsu)
						Else
							Msginfo("Erro no Parser!!!! NSU: "+_cNsu)
							//>> Ticket 20200619003190 - Everson Santana
							_cUltNsu	:=Soma1(_cNsu ) 
							PUTMV("ST_NSUCTE",_cUltNsu)
							//<< Ticket 20200619003190 - Everson Santana
						EndIf
					Else
						Msginfo("Erro na descompactamento!!!!")
					EndIf
				EndIf
				If !(Alltrim(oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT) $ '138/137')
					Msginfo("xxx!!!!")
				EndIf

				If oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT = oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
					lSaida := .T.
				EndIf

				If Tira1(oXml:_CTEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_MAXNSU:TEXT) = _cNsu
					lSaida := .T.
				EndIf

			Else
				Conout(GetWSCError())  // Resumo do erro
				lSaida := .T.
			EndIf




		EndDo
		conout("S"+cNewEmp+'/'+cNewFil+' - '+time())
		RpcClearEnv()
		lSaida:= .F.
	Next k
Return()






User Function STAI3( )//cte

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	//Abrir threads por empresa da função conslote
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	SRA->(DbGoTop())

	While SRA->(!Eof())


		DbSelectArea("AI3")
		AI3->(DbGoTop())

		AI3->(RecLock("AI3",.T.))


		AI3->AI3_CODUSU := GetSxeNum("AI3","AI3_CODUSU")
		AI3->AI3_CODUSU := cNom
		AI3->AI3_CODUSU	:=  ''


		AI3->(MsUnlock())
		AI3->(DbCommit())


		SRA->(DbSkip())

	EndDo

	Reset Environment
	Return()

















	#INCLUDE "PROTHEUS.CH"

	#INCLUDE "FWMVCDEF.CH"

	#DEFINE CRMARCA 1
	#DEFINE CRNOTA 2
	#DEFINE CRSERIE 3
	#DEFINE CRCLIENTE 4
	#DEFINE CRLOJA 5
	#DEFINE CRTENTA 6
	#DEFINE CRMEMO 7
	#DEFINE CRCHAVE 8
	#DEFINE CRDESMEM 9

//-----------------------------------------------------
/*/ Idem OMSM010 restrio ao SIGAGFE
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
User Function xOMSM012()
	Local aSize     := {}
	Local aObjects  := {}
	Local aListBox  := {}
	Local aInfo     := {}
	Local aPosObj   := {}

	Local oBtn01
	Local oBtn02
	Local lAtiva := .T.
	Local lIntGFE
	Local cIntGFE2
	Local cIntNFS

	Private oOk
	Private oNo
	Private oListBox	:= Nil
	Private oDlg		:= Nil
	Private oQtdDoc	:= Nil
	Private oQtdMrk	:= Nil
	Private nQtdDoc	:= 0
	Private nQtdMrk	:= 0
	Private lExecAuto	:= .F.

	//-- Checkbox
	Private lAllMark:= .F.   // Usado para o controle da marca de todos os documentos
	//-- Rotinas Marcadas
	Private aRotMark:= {}






	lIntGFE := SuperGetMv("MV_INTGFE",.F.,.F.)
	cIntGFE2 := SuperGetMv("MV_INTGFE2",.F.,"2")
	cIntNFS := SuperGetMv("MV_GFEI11",.F.,"2")

	oOk       := LoadBitMap(GetResources(),"LBOK")
	oNo       := LoadBitMap(GetResources(),"LBNO")


	If lIntGFE <> .T.
		Help( ,, '',,'', 1, 0) //"Atenção"##"ERP não possui integração com SIGAGFE (MV_INTGFE)."
		lAtiva := .F.
	Else
		If !cIntGFE2 $ "1"
			Help( ,, '',,'', 1, 0) //"Atenção"##"A integração direta, sem o uso de EAI e TOTVSESB, não está ativa (MV_INTGFE2). Utilize o programa de Carga Inicial (OMSM010)."
			lAtiva := .F.
		ElseIf cIntNFS == "2"
			Help( ,, '',,"Integração com Documento de Saída não está ativa (MV_GFEI11).", 1, 0) //"Atenção"##"Integração com Documento de Saída não está ativa (MV_GFEI11)."
			lAtiva := .F.
		EndIf
	EndIf

	If lAtiva

		lAtiva := SelDados(@aListBox,,.F.)

		If lAtiva

			aSize    := MsAdvSize(.F. )
			aObjects := {}

			AAdd( aObjects, { 100, 020, .T., .F., .T.  } )
			AAdd( aObjects, { 100, 100, .T., .T. } )
			AAdd( aObjects, { 100, 020, .F., .F. } )

			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3, .T.  }
			aPosObj := MsObjSize( aInfo, aObjects, .T. )

			DEFINE MSDIALOG oDlg TITLE "Notas Fiscais de Saída Pendentes" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL //"Notas Fiscais de Saída Pendentes"

			oPanel := TPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,CLR_WHITE,(aPosObj[1,3]), (aPosObj[1,4]), .T.,.T.)

			@ 005,005 CHECKBOX oAllMark VAR lAllMark PROMPT '' SIZE 168, 08; //-- Marca/Desmarca Todos
			ON CLICK(OsM012All(aListBox)) OF oPanel PIXEL

			//-- Cabecalho dos campos do Monitor.
			@ aPosObj[2,1],aPosObj[2,2] LISTBOX oListBox Fields HEADER;
			"","Numero","Serie","Cliente","Loja","Tentativas","Mensagem" SIZE aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] PIXEL

			oListBox:SetArray( aListBox )
			oListBox:bLDblClick := { |x,nCol| IIF(nCol == 7, FIELDMEMO(aListBox[oListBox:nAT][CRDESMEM]), OsM012Mrk(aListBox) ) }
			oListBox:bLine      := { || {	Iif(aListBox[ oListBox:nAT,CRMARCA ] == '1',oOk,oNo),;
			aListBox[ oListBox:nAT,CRNOTA ],;
			aListBox[ oListBox:nAT,CRSERIE],;
			aListBox[ oListBox:nAT,CRCLIENTE],;
			aListBox[ oListBox:nAT,CRLOJA],;
			aListBox[ oListBox:nAT,CRTENTA],;
			aListBox[ oListBox:nAT,CRMEMO]}}

			//-- Botoes da tela do monitor.
			@ aPosObj[3,1],aPosObj[3,4] - 100 BUTTON oBtn01 	PROMPT '' ACTION Iif(MsgYesNo('',''),;        //--"Confirma o Processamento",Carga Inicial
			Processa( { || OsM012Proc(aListBox), IIF( SelDados(@aListBox,oListBox,.T.),,oDlg:End() ) }, , '', .T. ),'')       OF oDlg PIXEL SIZE 035,011 //"Transmitindo para o SIGAGFE"
			@ aPosObj[3,1],aPosObj[3,4] - 060 BUTTON oBtn04 	PROMPT '' ACTION oDlg:End()  OF oDlg PIXEL SIZE 035,011 //-- "Sair"

			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf

	Endif

Return ( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ OsM012Mrk³  Autor ³ Leandro Paulino      ³ Data ³05.05.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca as rotinas no listbox                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OsM012Mrk()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ OMSM012                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OsM012Mrk(aListBox,nItem,lRefresh,lUmItem,lRetMark)
	Local   nPosMrk := 0
	Local	  nDocMrk := 0

	Default nItem   := oListBox:nAt
	Default lRefresh:= .T.
	Default lUmItem := .T.
	Default lRetMark:= .F.

	If lUmItem
		aListBox[nItem,CRMARCA] := Iif(aListBox[nItem,CRMARCA] == '1','2','1')
		If(aListBox[nItem,CRMARCA]) == '1'
			nQtdMrk += 1
		ElseIf(aListBox[nItem,CRMARCA]) == '2'
			nQtdMrk -= 1
		EndIf
	Else
		If lAllMark
			aListBox[nItem,CRMARCA] := '1'
			nQtdMrk += 1
		Else
			aListBox[nItem,CRMARCA] := '2'
			nQtdMrk := 0
		EndIf
	EndIf
	nPosMrk := Ascan(aRotMark,{ | e | e[1]+e[2] == aListBox[nItem,CRNOTA]+aListBox[nItem,CRCLIENTE] })
	If nPosMrk == 0
		Aadd(aRotMark,{ aListBox[nItem,CRCLIENTE], aListBox[nItem,CRNOTA], '' })
		nPosMrk := Len(aRotMark)
	EndIf
	aRotMark[nPosMrk,3] := aListBox[nItem,CRMARCA]
	If lRefresh
		oListBox:Refresh()
	EndIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ OsM012All³  Autor ³ Leandro Paulino     ³ Data ³05.05.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca/Desmarca todas as rotinas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OsM012All()    		                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ OMSM012                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OsM012All(aListBox)
	Local nI      := 0
	Local lRefresh:= .T.
	Local lUmItem := .F.

	CursorWait()
	nQtdMrk := 0

	For nI := 1 To Len(aListBox)
		OsM012Mrk(aListBox,nI,lRefresh,lUmItem)
	Next nI

	CursorArrow()

	oListBox:Refresh()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³OsM012Proc  ³ Autor ³Leandro Paulino      ³ Data ³15.04.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel por enviar as tabelas para MaEnvEAI      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array contendo as rotinas da tela                ³±±
±±³         ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OsM012Proc(aListBox)
	Local nI			:= 0
	Local aCargaIni	:= {}
	Local aGetArea	:= GetArea()
	Local ArqvLog   := GFELog():New('', ''+" - "+'', SuperGetMV('MV_GFEEDIL',.F.,'1')) //"Carga_Inicial_GFE"##"Carga Inicial GFE - Relatório de Erros de Integração"
	Local cFiltro := ""

	Local cDrtLog := SuperGetMv("MV_DRTLOG",.F.,"")

	Default aListBox  := {}

	aCargaIni := OsM012Rot(aListBox)

	ArqvLog:Add("------------------------------------------------------------------------------------------------------------------------")
	ArqvLog:Add("| "+''+" |              "+''+"              | "+''+" |                         "+''+"                        ")//"ROTINA"##"CAMPOS CHAVE"##"CAMPO GFE"##"PROBLEMA"
	ArqvLog:Add("------------------------------------------------------------------------------------------------------------------------")

	For nI := 1 To Len(aCargaIni)

		dbSelectArea("SF2")
		dbGoTop()

		cIndAlias := CriaTrab( Nil, .F. )

		cFiltro := "F2_DOC=='"+PadR(aCargaIni[nI][CRNOTA],TamSX3("F2_DOC")[1] )+"' .AND. "
		cFiltro += "F2_SERIE=='"+PadR(aCargaIni[nI][CRSERIE], TamSX3("F2_SERIE")[1] )+"' .AND. "
		cFiltro += "F2_CLIENTE=='"+PadR(aCargaIni[nI][CRCLIENTE], TamSX3("F2_CLIENTE")[1] )+"' .AND. "
		cFiltro += "F2_LOJA=='"+PadR(aCargaIni[nI][CRLOJA], TamSX3("F2_LOJA")[1] )+"'"

		IndRegua("SF2", cIndAlias, IndexKey(), , cFiltro ,"Selecionando Registros...") //--"Selecionando Registros..."

		nIndAlias := RetIndex("SF2")

		DbSetOrder( nIndAlias + 1 )
		ProcRegua( SF2->( RecCount() ) )
		While (!SF2->(Eof()))

			If aCargaIni[nI,CRNOTA] == "SF2"
				If Empty(SF2->F2_FILIAL) .OR. SF2->F2_FILIAL == xFilial("SF2")
					lFilial := .T.
				Else
					lFilial := .F.
				EndIf
			Else
				lFilial := .T.
			EndIf

			If lFilial
				IncProc()

				OMSM011IPG("SF2",ArqvLog)

				SF2->(dbSkip())
			EndIf

		EndDo

		If	File( cIndAlias + OrdBagExt() )
			DbSelectArea("SF2")
			DbClearFilter()
			Ferase( cIndAlias + OrdBagExt() )
		EndIf

		RetIndex("SF2")

	Next nI

	ArqvLog:EndLog()

	MsgInfo(''+": "+cDrtLog) //"Visualizar arquivo log"

	RestArea(aGetArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³OsM012Rot ³ Autor ³ Leandro Paulino       ³ Data ³05.05.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparar rotinas para processamento                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Retorna as rotinas selecionadas.                           ³±±
±±³          ³ Array dos documentos                                       ³±±
±±³          ³ [1] - Marca/Desmarca                                       ³±±
±±³          ³ [2] - Cor Legenda    		                                ³±±
±±³          ³ [3] - Alias                                                ³±±
±±³          ³ [4] - Nome do Alias                                        ³±±
±±³          ³ [5] - Rotina                                               ³±±
±±³          ³ [6] - Model        			                                ³±±
±±³          ³ [7] - Filtro       			                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OsM012Rot(aListBox)
	Local   nI         := 0
	Local   aRotProc 	 := {}

	For nI := 1 To Len(aListBox)
		If aListBox[nI,CRMARCA] == '1'
			Aadd(aRotProc, {aListBox[nI,CRMARCA],aListBox[nI][CRNOTA],aListBox[nI][CRSERIE], aListBox[nI][CRCLIENTE], aListBox[nI][CRLOJA] } )
		EndIf
	Next nI

Return ( aRotProc )

Static Function FIELDMEMO(cTexto)
	Local oDlg

	DEFINE MSDIALOG oDlg TITLE "Mensagem do Model" From 0,0 To 18,70 OF oMainWnd
	@ 4, 006 SAY "Mensagem de retorno do SIGAGFE:" SIZE 130,7 PIXEL OF oDlg

	oTMultiget1 := TMultiget():New(13,06,{|u|If(Pcount()>0,cTexto:=u,cTexto)},;
	oDlg,265,105,,,,,,.T.,,,,,,.T.)

	oButtonOK   := tButton():New(125,5,'OK',oDlg,{|| oDlg:End()},25,10,,,,.T.)

	ACTIVATE MSDIALOG oDlg CENTER

Return
//-----------------------------------------------------
/*/Monta a lista de notas fiscais que nao foram integradas
@author Felipe Machado de Oliveira
@version P11
@since 17/07/2013
/*/
//------------------------------------------------------
Static Function MontaList(aListBox)
	Local aAreaGW0 := GW0->( GetArea() )
	Local nTenta := 1
	Local cNota := ""
	Local cSerie := ""
	Local cCliente := ""
	Local cLoja := ""

	aListBox := {}

	dbSelectArea("GW0")
	GW0->( dbSetOrder(1) )
	GW0->( dbSeek(xFilial("SF2")+PadR( "F2PEND", TamSX3("GW0_TABELA")[1] )) )
	While !GW0->( EOF() ) .And. GW0->GW0_FILIAL == xFilial("SF2") ;
	.And. AllTrim(GW0->GW0_TABELA) == "F2PEND"

		nTenta := PadR( GW0->GW0_NUM01 , 3 )
		cNota := PadR( GW0->GW0_CHAR01 , TamSX3("F2_DOC")[1] )
		cSerie := PadR( GW0->GW0_CHAR02 , TamSX3("F2_SERIE")[1] )
		cCliente := PadR( GW0->GW0_CHAR03 , TamSX3("F2_CLIENTE")[1] )
		cLoja := PadR( GW0->GW0_CHAR04 , TamSX3("F2_LOJA")[1] )
		/*
		Aadd(aListBox,{CRMARCA := '2',;
		CRNOTA := cNota,;
		CRSERIE := cSerie,;
		CRCLIENTE := cCliente,;
		CRLOJA := cLoja,;
		CRTENTA := nTenta,;
		CRMEMO := "MEMO",;
		CRCHAVE := GW0->GW0_CHAVE,;
		CRDESMEM := GW0->GW0_MEMO01})
		*/
		GW0->( dbSkip() )
	EndDo

	RestArea( aAreaGW0 )

Return
//-----------------------------------------------------
/*/ Seleciona as notas fiscais de saida
@author Felipe Machado de Oliveira
@version P11
@since 17/07/2013
/*/
//------------------------------------------------------
Static Function SelDados(aListBox,oListBox,lRefresh)
	Local lRet := .T.

	//-- Array com as notas a serem integradas no GFE
	CursorWait()
	MontaList(@aListBox)
	CursorArrow()

	If Empty(aListBox)
		Help( ,, '',,"Não há Notas Fiscais de Saída pendentes.", 1, 0) //"Atenção"##"Não há Notas Fiscais de Saída pendentes."
		lRet := .F.
	EndIf

	If lRefresh
		oListBox:SetArray( aListBox )
		oListBox:bLine      := { || {	Iif(aListBox[ oListBox:nAT,CRMARCA ] == '1',oOk,oNo),;
		aListBox[ oListBox:nAT,CRNOTA ],;
		aListBox[ oListBox:nAT,CRSERIE ],;
		aListBox[ oListBox:nAT,CRCLIENTE ],;
		aListBox[ oListBox:nAT,CRLOJA ],;
		aListBox[ oListBox:nAT,CRTENTA ],;
		aListBox[ oListBox:nAT,CRMEMO ]}}
		oListBox:Refresh()
	EndIf

Return lRet












User Function CadGW6() // u_CadGW6

	Private cAlias := "GW6"
	Private aRotina   := {}
	Private aSubRotina := {}
	Private lRefresh  := .T.
	Private cCadastro := "CONFERIR"


	aAdd( aRotina, {"CONFERIR"   ,'U_XCadGW6( )',0,3} )
	aAdd( aRotina, {"dados da conferencia"   ,'U_GFEA070CF( )',0,3} )

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return



User Function XCadGW6()
	dbSelectArea("GW3")
	GW3->( dbSetOrder(8) )
	If GW3->( dbSeek(GW6->GW6_FILIAL + GW6->GW6_EMIFAT + '0    004714187       ') )
		//GW3->( dbSeek(GW6->GW6_FILIAL + GW6->GW6_EMIFAT + GW6->GW6_SERFAT + GW6->GW6_NRFAT ) )

		If GW6->GW6_SITAPR $ "3/4"
			Help( ,, 'Help',, "Não é possivel conferir a fatura se a mesma já estiver aprovada.", 1, 0 ) //"Não é possivel conferir a fatura se a mesma já estiver aprovada."
			Return .F.
		Else

			xGFECTBFATD(GW6->GW6_FILIAL, GW6->GW6_EMIFAT, GW6->GW6_SERFAT, GW6->GW6_NRFAT, GW6->GW6_DTEMIS)

			xGFEA071RA(.T.)
		EndIf
	EndIf
Return




static Function xGFEA071RA(lFlag)
	Local lVCP, lVVF, lRet := .T., lVDF := .F., lDocFreteBloq := .F.
	Local cTemp
	Local nVlImpRet := 0
	Local nVlDif := 0
	Local lDifImpRet := .F.
	Private cMotBloqVVF := '', cMotBloqVDF := '', cMotBloqVCP := ''
	Private dDtVencM, dDtVencC
	Private lExcept := .F.

	If !lFlag .Or. ( lFlag .And. GetNewPar('MV_CFCONPG', 'N') $ "1S")
		lVCP := GFEA071CP(lFlag) //validação de condição de pagamento
	EndIf

	lVVF := GFEA071VF(lFlag) //validação de valor da Fatura

	If !lFlag .Or. ( lFlag .And. GetNewPar('MV_CFAGRUP', 'N') $ "1S")
		lVDF := GFEA071AG() //Validação de agrupamento de Doc Frete
	EndIf

	If lFlag .And. lRet
		// Início Ponto de Entrada Britania
		If ExistBlock("XGFEAPRF")
			lExecBlock := ExecBlock("XGFEAPRF",.f.,.f.,{GW6->GW6_FILIAL, GW6->GW6_EMIFAT, GW6->GW6_SERFAT, GW6->GW6_NRFAT, GW6->GW6_DTEMIS})
			if lExecBlock == .F.
				lRet := .F.
			EndIf
		EndIf
		// Fim Ponto de Entrada Britania
	Endif

	If lFlag .And. lRet

		cTemp := ""

		RecLock("GW6", .F.)
		GW6->GW6_MOTBLO := ""
		GW6->( MsUnlock() )

		//Verifica se há um Doc Frete bloqueado vinculado a Fatura
		dbSelectArea("GW3")
		GW3->( dbSetOrder(6) )
		GW3->( dbSeek(GW6->GW6_FILIAL + GW6->GW6_EMIFAT + GW6->GW6_SERFAT + GW6->GW6_NRFAT + DToS(GW6->GW6_DTEMIS)) )
		While !GW3->( Eof() ) .And. GW3->GW3_FILFAT + GW3->GW3_EMIFAT + GW3->GW3_SERFAT + GW3->GW3_NRFAT + DToS(GW3->GW3_DTEMFA) == ;
		GW6->GW6_FILIAL + GW6->GW6_EMIFAT + GW6->GW6_SERFAT + GW6->GW6_NRFAT + DToS(GW6->GW6_DTEMIS)

			If GW3->GW3_SIT == '2'
				lDocFreteBloq := .T.
			EndIf

			If GW3->GW3_TRBIMP $ "3;7" //3=Subs Tributaria; 7=Presumido
				nVlImpRet += GW3->GW3_IMPRET
			EndIf

			GW3->( dbSkip() )
		EndDo

		If lDocFreteBloq

			RecLock("GW6", .F.)
			cTemp           := GW6->GW6_MOTBLO
			GW6->GW6_MOTBLO := cTemp + CRLF + "Fatura de Frete está vinculada a Doc Frete com situação 'Bloqueada'." //"Fatura de Frete está vinculada a Doc Frete com situação 'Bloqueada'."
			GW6->( MsUnlock() )

		EndIf

		If (GW6->GW6_VLICRE + GW6->GW6_VLISRE)  != nVlImpRet
			lDifImpRet := .T.
			nVlDif:= (GW6->GW6_VLICRE + GW6->GW6_VLISRE) - nVlImpRet
		EndIf

		If !lVCP .AND. GetNewPar('MV_CFCONPG', 'N') $ "1S"

			RecLock("GW6",.F.)
			cTemp           := GW6->GW6_MOTBLO
			GW6->GW6_MOTBLO := cTemp + CRLF + cMotBloqVVF
			MsUnLock("GW6")

		EndIf

		If (!lVVF .And. GETNEWPAR('MV_CFVLFAT', 'N') $ "1S") .Or. lExcept

			RecLock("GW6", .F.)
			cTemp           := GW6->GW6_MOTBLO
			GW6->GW6_MOTBLO := cTemp + CRLF + cMotBloqVCP
			GW6->( MsUnlock() )

		EndIf

		If !lVDF .And. GetNewPar('MV_CFAGRUP', 'N') $ "1S"

			RecLock("GW6", .F.)
			cTemp           := GW6->GW6_MOTBLO
			GW6->GW6_MOTBLO := cTemp + CRLF + cMotBloqVDF
			GW6->( MsUnlock() )

		EndIf

		If (!lVCP .AND. GETNEWPAR('MV_CFCONPG', 'N') $ "1S") .Or. (!lVVF .And. GetNewPar('MV_CFVLFAT', 'N') $ "1S") .Or. (!lVDF .And. GetNewPar('MV_CFAGRUP', 'N') $ "1S") .Or. lDocFreteBloq .Or. lExcept
			RecLock("GW6", .F.)
			GW6->GW6_SITAPR := "2"
			GW6->GW6_DTBLOQ := dDataBase
			GW6->GW6_HRBLOQ := Time()
			GW6->GW6_USUBLO := cUserName
			GW6->GW6_DTAPR  := SToD("")
			GW6->GW6_HRAPR  := ""
			GW6->( MsUnlock() )

			If !IsInCallStack("GFEA65GFAT") .And. !IsInCallStack("GFEA116PRO")
				If lDifImpRet
					MsgInfo("Fatura Bloqueada." + CRLF + GW6->GW6_MOTBLO + CRLF + CRLF + "Informação da conferência:" + CRLF + CRLF + "Valor total dos impostos retidos da fatura não confere com o somatório dos valores de ICMS ou ISS Retido dos conhecimentos."+ CRLF + "Total da Diferença: R$ " + AllTrim(str(nVlDif)) )
				Else
					MsgInfo("Fatura Bloqueada." + CRLF + GW6->GW6_MOTBLO) //"Fatura Bloqueada."
				Endif
			EndIf
		Else

			RecLock("GW6", .F.)
			GW6->GW6_SITAPR := "3" //APROVADA PELO SISTEMA
			GW6->GW6_DTAPR  := dDataBase
			GW6->GW6_HRAPR  := Time()
			GW6->( MsUnlock() )

			// Criação dos movimentos contábeis para a fatura
			If (GW6->GW6_SITFIN == "1" .Or. GW6->GW6_SITFIN == "3") .AND. GetMv("MV_TPGERA",,"1") == "1"
				GFECTBFATC(GW6->GW6_FILIAL, GW6->GW6_EMIFAT, GW6->GW6_SERFAT, GW6->GW6_NRFAT, GW6->GW6_DTEMIS)
			EndIf

			If !IsInCallStack("GFEA65GFAT") .And. !IsInCallStack("GFEA116PRO") //não deve apresentar a mensagem de fatura aprovada se a fatura foi gerada automaticamente
				If lDifImpRet
					MsgInfo("Fatura Aprovada" + CRLF + CRLF + "Informação da conferência:" + CRLF + CRLF + "Valor total dos impostos retidos da fatura não confere com o somatório dos valores de ICMS ou ISS Retido dos conhecimentos."+ CRLF + "Total da Diferença: R$ " + AllTrim(STR(nVlDif)))//"Fatura Aprovada"
				Else
					MsgInfo("Fatura Aprovada") //"Fatura Aprovada"
				EndIf
			EndIf

			/* Atualização automática da fatura de frete no financeiro */
			If SuperGetMV('MV_GFEI16',, '1') == '2'
				GFEA070X(.T.)
			EndIf

		EndIf

	EndIf

Return lRet




Static Function xGFECTBFAT(cFilFat, cEmiFat, cSerFat, cNrFat, dDtEmis, cOperacao)

	Local cTrans // Transação
	Local aAreaGW6    := GW6->( GetArea() )
	Local aAreaGW3    := GW3->( GetArea() )
	Local aAreaGWM    := GWM->( GetArea() )
	Local aAreaGWA    := GWA->( GetArea() )
	Local nSeq        := 0
	Private LogCtbFat
	Default cOperacao := "C"

	LogCtbFat := GFELog():New("Contabilizacao_Fatura", "Contabilização da Fatura", If(cOperacao == "C", "2", "1"))

	LogCtbFat:Add("Filial.....: " + cValToChar(cFilFat))
	LogCtbFat:Add("Emitente...: " + cValToChar(cEmiFat))
	LogCtbFat:Add("Série......: " + cValToChar(cSerFat))
	LogCtbFat:Add("Nr. Fatura.: " + cValToChar(cNrFat))
	LogCtbFat:Add("Data Emiss.: " + DToC(dDtEmis))
	LogCtbFat:NewLine()

	// Busca a fatura
	dbSelectArea("GW6")
	GW6->( dbSetOrder(1) )
	If GW6->( dbSeek( cFilFat + cEmiFat + cSerFat + cNrFat + DToS(dDtEmis)) ) .Or. GW6->( dbSeek( xFilial("GW6") + cEmiFat + cSerFat + cNrFat) )

		If cOperacao == "D"
			dbSelectArea("GW7")
			GW7->( dbSetOrder(2) )
			GW7->( dbSeek(cFilFat + cEmiFat + cSerFat + cNrFat + DToS(dDtEmis)) )
			While !GW7->( Eof() ) .And. GW7->GW7_FILIAL == cFilFat .And. GW7->GW7_EMIFAT == cEmiFat .And. GW7->GW7_SERFAT == cSerFat .And. ;
			GW7->GW7_NRFAT == cNrFat .And. GW7->GW7_DTEMIS == dDtEmis

				RecLock("GW7", .F. )
				dbDelete()
				MsUnLock("GW7")

				GW7->( dbSkip() )
			EndDo

		ElseIf cOperacao == "C"
			LogCtbFat:Add("Buscando Documentos de Frete da Fatura")

			// Busca todos os Documento de Frete relacionados a fatura
			dbSelectArea("GW3")
			GW3->( dbSetOrder(6) )
			If GW3->( dbSeek( GW6->GW6_FILIAL + GW6->GW6_EMIFAT + GW6->GW6_SERFAT + GW6->GW6_NRFAT + DToS(GW6->GW6_DTEMIS) ) )

				While !GW3->( Eof() ) .AND. ;
				GW3->GW3_FILFAT == GW6->GW6_FILIAL .AND. ;
				GW3->GW3_EMIFAT == GW6->GW6_EMIFAT .AND. ;
				GW3->GW3_SERFAT == GW6->GW6_SERFAT .AND. ;
				GW3->GW3_NRFAT  == GW6->GW6_NRFAT  .AND. ;
				DTOS(GW3->GW3_DTEMFA) == DTOS(GW6->GW6_DTEMIS)

					LogCtbFat:Add("> Filial: " + GW3->GW3_FILIAL + ", Série: " + GW3->GW3_SERDF + ", Número: " + AllTrim(GW3->GW3_NRDF) + ", Espécie: " + AllTrim(GW3->GW3_CDESP) + ", Emissor: " + AllTrim(GW3->GW3_EMISDF) + ", Data Emissão: " + cValToChar(GW3->GW3_DTEMIS))
					dbSelectArea("GWA")
					GWA->( dbSetOrder(2) )
					If GWA->( dbSeek(GW3->GW3_FILIAL + "2" + GW3->GW3_CDESP + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF + DTOS(GW3->GW3_DTEMIS)) )

						LogCtbFat:Add(" - Movimentos contábeis:")
						While !GWA->( Eof() ) .And. ;
						GW3->GW3_FILIAL == GWA->GWA_FILIAL .AND. ;
						GWA->GWA_CDESP  == GW3->GW3_CDESP  .AND. ;
						GWA->GWA_CDEMIT == GW3->GW3_EMISDF .AND. ;
						GWA->GWA_SERIE  == GW3->GW3_SERDF  .AND. ;
						GWA->GWA_NRDOC  == GW3->GW3_NRDF   .AND. ;
						GWA->GWA_DTEMIS == GW3->GW3_DTEMIS .AND. ;
						GWA->GWA_TPDOC  == "2"

							LogCtbFat:Add("> Seq: " + AllTrim(GWA->GWA_SEQ) + ", Transação: " + AllTrim(GWA->GWA_CDTRAN) + ", Conta Deb: " + AllTrim(GWA->GWA_CTADEB) + ", Conta Cred: " + AllTrim(GWA->GWA_CCDEB) + ", Valor: " + cValToChar(GWA->GWA_VLMOV), 1)

							Do Case
								Case GWA->GWA_CDTRAN == PadR("310", 10)
								cTrans := "1"
								Case GWA->GWA_CDTRAN == PadR("311", 10)
								cTrans := "2"
								Case GWA->GWA_CDTRAN == PadR("312", 10)
								cTrans := "3"
								Case GWA->GWA_CDTRAN == PadR("313", 10)
								cTrans := "4"
							EndCase

							LogCtbFat:Add("Contabilizando:", 1)
							GFEAGRVGW7(cFilFat, cEmiFat, cSerFat, cNrFat, dDtEmis, GWA->GWA_CTADEB, GWA->GWA_CCDEB, GWA->GWA_VLMOV, "1", cTrans, @nSeq, GWA->GWA_UNINEG)

							LogCtbFat:NewLine()

							GWA->( dbSkip() )
						EndDo
					Else
						LogCtbFat:Add("** Nenhum movimento contábil encontrado para o documento de frete.", 1)
					EndIf

					GW3->( dbSkip() )

					If !GW3->( Eof() )
						LogCtbFat:Add(Replicate("-", 30))
					EndIf
				EndDo
			Else
				LogCtbFat:Add("** Não foi encontrado nenhum Documento de Frete para esta fatura.")
			EndIf
		EndIf
	Else
		LogCtbFat:Add("** Fatura não encontrada.")
	Endif

	LogCtbFat:EndLog()

	RestArea( aAreaGWA )
	RestArea( aAreaGWM )
	RestArea( aAreaGW3 )
	RestArea( aAreaGW6 )

Return








User Function gerrom()


	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	dbSelectArea("GW1")
	GW1->( dbSetOrder(8) )
	GW1->( dbSeek(xFilial("GW1") ) )
	While !GW1->( Eof() )


		If  GW1->GW1_NRROM = ' '  .aND. GW1->GW1_NRDC > '000240000'

			dbSelectArea("GWN")
			RecLock("GWN", .T. )

			GWN->GWN_FILIAL	:= '02'
			GWN->GWN_NRROM 	:=  GETSXENUM("GWN","GWN_NRROM")
			GWN->GWN_CDTPOP	:= 'FRETE'
			GWN->GWN_CDTRP	:= '95591723003800'
			GWN->GWN_SIT 	:= '1'
			GWN->GWN_DTIMPL	:= DDATABASE
			GWN->GWN_CALC	:= '2'

			MsUnLock("GWN")

			ConfirmSX8()


			RecLock("GW1", .F. )

			GW1->GW1_NRROM 	:= 	GWN->GWN_NRROM

			MsUnLock("GWN")

		Endif

		GW1->( dbSkip() )

	EndDo



Return

/*/{Protheus.doc} GRVIMPCTE
@name GRVIMPCTE
@type Static Function
@desc gravar valor dos impostos 
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GRVIMPCTE(_aImpostos)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cNCT    := ""
	Local _nX := 0

	_cNCT := PADL(_aImpostos[1][1],9,"0")

	_cQuery1 += " SELECT GWI.R_E_C_N_O_ GWIREC, GW3.R_E_C_N_O_ GW3REC, GWI_CDCOMP
	_cQuery1 += " FROM "+RetSqlName("GW3")+" GW3
	_cQuery1 += " LEFT JOIN "+RetSqlName("GW4")+" GW4
	_cQuery1 += " ON GW4_FILIAL=GW3_FILIAL AND GW4_EMISDF=GW3_EMISDF AND GW4_CDESP=GW3_CDESP AND GW4_NRDF=GW3_NRDF AND GW4_SERDF=GW3_SERDF
	_cQuery1 += " LEFT JOIN "+RetSqlName("GWH")+" GWH
	_cQuery1 += " ON GWH_FILIAL=GW4_FILIAL AND GWH_NRDC=GW4_NRDC AND GWH_EMISDC=GW4_EMISDC AND GWH_SERDC=GW4_SERDC
	_cQuery1 += " LEFT JOIN "+RetSqlName("GWI")+" GWI
	_cQuery1 += " ON GWI_FILIAL=GWH_FILIAL AND GWI_NRCALC=GWH_NRCALC
	_cQuery1 += " WHERE GW3.D_E_L_E_T_=' ' AND GW4.D_E_L_E_T_=' ' AND GWH.D_E_L_E_T_=' ' AND GWI.D_E_L_E_T_=' '  
	_cQuery1 += " AND GW3_FILIAL='"+xFilial("GW3")+"' AND GW3_CDESP='CTE' 
	//_cQuery1 += " AND GW3_EMISDF='95591723003800' 
	_cQuery1 += " AND GW3_SERDF='0' 
	_cQuery1 += " AND GW3_NRDF='"+_cNCT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		DbSelectArea("GW3")
		GW3->(DbGoTop())
		GW3->(DbGoTo((_cAlias1)->GW3REC))
		If GW3->(!Eof())
			GW3->(RecLock("GW3",.F.))
			GW3->GW3_PESOD := _aImpostos[1][5]
			GW3->GW3_TOMAD := _aImpostos[1][4]
			GW3->(MsUnLock())
		EndIf
	EndIf

	While (_cAlias1)->(!Eof())

		For _nX:=1 To Len(_aImpostos)
			If UPPER(AllTrim((_cAlias1)->GWI_CDCOMP))==UPPER(AllTrim(_aImpostos[_nX][2]))

				DbSelectArea("GWI")
				GWI->(DbGoTop())
				GWI->(DbGoTo((_cAlias1)->GWIREC))
				If GWI->(!Eof())
					GWI->(RecLock("GWI",.F.))
					GWI->GWI_VLCTE := Val(_aImpostos[_nX][3])
					GWI->(MsUnLock())
				EndIf

			EndIf
		Next

		(_cAlias1)->(DbSkip())
	EndDo

Return()
