#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TSSNFSEOperation.CH"
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
±±ºDesc.     ³nfse sao paulo 											  º±±
±±º          ³   													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STNFS00( )//cte

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	//StartJob("U_STNFS03",GetEnvServer(), .F.,"01","02")


	//Abrir threads por empresa da função conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())


	If  (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
	(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
	(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="03") .Or.;
	(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="04")

	StartJob("U_STNFS03",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)


	EndIf


	SM0->(DbSkip())

	EndDo

	Reset Environment

Return()


User Function STNFSAM( )//cte

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	//Abrir threads por empresa da função conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())


		If  SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01"
			StartJob("U_STNFS03",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
		EndIf


		SM0->(DbSkip())

	EndDo

	Reset Environment
Return()


/*******************************************
Ação...........: Job específico para empresa NewCo Distribuidora.
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: VIRADA APOEMA NEWCO DISTRIBUIDORA
*******************************************/
USER FUNCTION STNFSDIS()

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	StartJob("U_STNFS03",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)

	Reset Environment
RETURN

User Function STNFS03(cNewEmp,cNewFil )//nfse sao paulo
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
	Local _aRet			:= {}
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos      := SUBSTR(cTime, 4, 2)
	Local cSegundos     := SUBSTR(cTime, 7, 2)
	Local _nHix         := 0
	Local _nHfx         := 0
	Local l         := 0
	Local i         := 0
	Local k         := 0
	//Local cCnpj		:= ""
	//Local cIm		:= ""
	//Local cNom		:= ""

	Private cErro, cAviso,_cIdEnt ,_cPass,_cXml,cNom,cCnpj,cIm
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
		//cNewEmp 	:= _aEmp[k,1]
		//cNewFil		:= _aEmp[k,2]

		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,)
		//RpcSetEnv( "01", "02",,,"FAT")

		cCnpj	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_CGC") //"05890658000210" //
		cIm 	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_INSCM")//"36974919" //"149885489113" //
		cNom	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_NOMECOM") //"STECK IND ELETRICA LTDA" //

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

			cMensagemXML:='<?xml version="1.0" encoding="UTF-8"?>'
			cMensagemXML+='<p:PedidoConsultaNFePeriodo '
			cMensagemXML+='xmlns:p="http://www.prefeitura.sp.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			cMensagemXML+='<Cabecalho Versao="1">'
			cMensagemXML+='<CPFCNPJRemetente>'
			cMensagemXML+='<CNPJ>'+ Alltrim(cCnpj)+'</CNPJ>'
			cMensagemXML+='</CPFCNPJRemetente>'
			cMensagemXML+='<CPFCNPJ>'
			cMensagemXML+='<CNPJ>'+ Alltrim(cCnpj)+'</CNPJ>'
			cMensagemXML+='</CPFCNPJ>'
			cMensagemXML+='<Inscricao>'+ Alltrim(cIm)+'</Inscricao>'
			cMensagemXML+='<dtInicio>'+ Alltrim(_cDtIni)+'</dtInicio>'
			cMensagemXML+='<dtFim>'+ Alltrim(_cDtFim)+'</dtFim>'
			cMensagemXML+='<NumeroPagina>'+ cValTochar(_nPag)+'</NumeroPagina>'
			cMensagemXML+='</Cabecalho>'
			cMensagemXML+='</p:PedidoConsultaNFePeriodo>'

			cMensagemXML  	:= U_STNFSASS('3550308',EncodeUtf8(Alltrim(cMensagemXML)),"p:PedidoConsultaNFePeriodo","",_cIdEnt, '', "001","","")

			_oWS := WSLoteNFe():New()

			_oWS:nVersaoSchema  := 1
			_oWS:cMensagemXML   := cMensagemXML

			If _oWS:ConsultaNFeRecebidas()
				///("funcionou")

				_cXml:=  EncodeUtf8(Alltrim(_oWS:CRETORNOXML))
				_cXml := (StrTran(_cXml,"&lt;/","</"))
				_cXml := (StrTran(_cXml,"/&gt;","/>"))
				_cXml := (StrTran(_cXml,"&lt;","<"))
				_cXml := (StrTran(_cXml,"&gt;",">"))
				_cXml := (StrTran(_cXml,"<![CDATA[[ ","<![CDATA["))
				cAviso:= ' '
				cErro:= ' '
				oXml := XmlParser(_cXml,"_",@cErro,@cAviso)
				if AttIsMemberOf( oXml:_RETORNOCONSULTA, "_NFE", .F. )   // Adicionado 18/03/2022 - 20220307005266 - Valdemir Rabelo - Devido a erro por não encontrar a propriedade _NFE
					If	oXml:_RETORNOCONSULTA:_CABECALHO:_SUCESSO:TEXT = 	"true" .And. Len(oXml:_RETORNOCONSULTA:_NFE) > 0
						For i:=1 To Len(oXml:_RETORNOCONSULTA:_NFE)
							_cCgc:= ' '
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CPFCNPJPRESTADOR,"_CNPJ" )
							If _cinf <> NIL
								_cCgc:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CPFCNPJPRESTADOR:_CNPJ:TEXT)
							Else
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CPFCNPJPRESTADOR,"_CPF" )
								If _cinf <> NIL
									_cCgc:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CPFCNPJPRESTADOR:_CPF:TEXT)
								Else
									_cCgc := ' '
								EndIf
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE,"_INSCRICAOPRESTADOR" )
							If _cinf <> NIL
								_cInscM	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE:_INSCRICAOPRESTADOR:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE,"_NUMERONFE" )
							If _cinf <> NIL
								_cNumNf  	:= Padl(Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE:_NUMERONFE:TEXT),9,'0')
							EndIf

							cNom	:= ' '
							DbSelectArea("SA2")
							SA2->(DbOrderNickName("CGCINSCR2"))
							If SA2->(DbSeek(xFilial("SA2")+_cCgc))
								cNom	:= SA2->A2_NOME
							EndIf
							DbSelectArea("SZ9")
							SZ9->(DbSetOrder(6))
							If !(SZ9->(DbSeek(xFilial("SZ9")+ padr(_cCgc,TamSX3("Z9_REMETE")[1]," ")+ padr(_cInscM,TamSX3("Z9_INSCM")[1]," ")+ padr(_cNumNf,TamSX3("Z9_NFSE")[1]," ") )))

								DbSelectArea("SZ9")
								SZ9->(DbGoTop())
								SZ9->(DbSetOrder(1))
								SZ9->(RecLock("SZ9",.T.))
								SZ9->Z9_STATUS	:= "0"
								SZ9->Z9_STATUSA	:= "Ciencia"
								SZ9->Z9_NOMFOR  := cNom
								SZ9->Z9_NFOR  	:= cNom
								SZ9->Z9_FILIAL	:= cFilAnt
								SZ9->Z9_VALORNF	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORSERVICOS:TEXT)
								SZ9->Z9_CHAVE	:= ' '
								SZ9->Z9_SERORI	:= ' '
								SZ9->Z9_NFEORI	:= _cNumNf
								SZ9->Z9_DTEMIS	:= STOD(STRTRAN(SUBSTR(oXml:_RETORNOCONSULTA:_NFE[i]:_DATAEMISSAONFE:TEXT,1,10),'-',''))
								SZ9->Z9_CNPJ	:= _cCgc
								SZ9->Z9_DATA	:= DATE()
								SZ9->Z9_HORA	:= TIME()
								SZ9->Z9_NSU	 	:= ' '
								SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CR+"INCLUINDO Xml Chave: "+SZ9->Z9_CHAVE+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
								SZ9->Z9_XML		:= VARINFO ('XML', oXml:_RETORNOCONSULTA:_NFE[i]  ,  , .F. ,   )
								SZ9->Z9_ORIGEM	:= 'NFS-E'

								SZ9->Z9_FIL 	:= cNewFil

								SZ9->Z9_STATUS := '0'
								SZ9->Z9_SERIE 	:= ''
								SZ9->Z9_NOTA  	:= ''
								SZ9->Z9_LOG    := ''
								SZ9->Z9_XML   	:= VARINFO ('XML', oXml:_RETORNOCONSULTA:_NFE[i]  ,  , .F. ,   )
								SZ9->Z9_DEPART := ' '
								//SZ9->Z9_ERRO   := ' '
								SZ9->Z9_REMETE := _cCgc
								SZ9->Z9_INSCM 	:= _cInscM

								SZ9->Z9_N01  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_ALIQUOTASERVICOS:TEXT)
								SZ9->Z9_N02  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORCREDITO:TEXT)
								SZ9->Z9_N03  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORISS:TEXT)
								SZ9->Z9_N04  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORSERVICOS:TEXT)
								
								_cMsgErro := ""

								DbSelectArea("SA2")
								SA2->(DbOrderNickName("CGCINSCR2"))
								If SA2->(DbSeek(xFilial("SA2")+_cCgc))
									SZ9->Z9_COD    := SA2->A2_COD
									SZ9->Z9_LOJA   := SA2->A2_LOJA
									SZ9->Z9_NFOR  	:= SA2->A2_NOME

									_cMsgErro  := ' '
									_aRet:= StQuery(SA2->A2_COD,SA2->A2_LOJA,SZ9->Z9_N04 )
									If Len(_aRet) = 1
										SZ9->Z9_PEDIDO := _aRet[1,1]
										SZ9->Z9_SOLICI := _aRet[1,2]
									ElseIf Len(_aRet) > 1
										_cMsgErro  := Alltrim(_cMsgErro)+Cr+Cr+"Encontrado mais de um Pedido de Compras:"+Cr
										For l:=1 To Len(_aRet)
											_cMsgErro   := Alltrim(_cMsgErro)+Cr+_aRet[l,1]
										Next l
									ElseIf Len(_aRet) = 0
										_cMsgErro  := Alltrim(_cMsgErro)+Cr+Cr+"Não Encontrado Pedido de Compras."+Cr
									EndIf

									_aRet:= {}
									_cinf :=  ''
								EndIf
								SZ9->Z9_ERRO   := _cMsgErro
								SZ9->Z9_NFSE   := _cNumNf
								SZ9->Z9_CHAVE  := ''
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE,"_CODIGOVERIFICACAO" )
								If _cinf <> NIL
									SZ9->Z9_CODVER := Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE:_CODIGOVERIFICACAO:TEXT)
								EndIf
								SZ9->Z9_DTEMIS := STOD(STRTRAN(SUBSTR(oXml:_RETORNOCONSULTA:_NFE[i]:_DATAEMISSAONFE:TEXT,1,10),'-',''))
								SZ9->Z9_HORA   := SUBSTR(oXml:_RETORNOCONSULTA:_NFE[i]:_DATAEMISSAONFE:TEXT,12,08)

								XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_DISCRIMINACAO" )
								If _cinf <> NIL
									SZ9->Z9_DESC 	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_DISCRIMINACAO:TEXT)
								EndIf

								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_CODIGOSERVICO" )//5
								If _cinf <> NIL
									SZ9->Z9_C01  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CODIGOSERVICO:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_EMAILPRESTADOR" )
								If _cinf <> NIL
									SZ9->Z9_C02 	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_EMAILPRESTADOR:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_ENDERECOPRESTADOR" )
								If _cinf <> NIL
									SZ9->Z9_C03  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_BAIRRO:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_ENDERECOPRESTADOR" )
								If _cinf <> NIL
									SZ9->Z9_C04  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_CEP:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_CIDADE" )
								If _cinf <> NIL
									SZ9->Z9_C05  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_CIDADE:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_LOGRADOURO" )
								If _cinf <> NIL
									SZ9->Z9_C06  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_LOGRADOURO:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_NUMEROENDERECO" )
								If _cinf <> NIL
									SZ9->Z9_C07  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_NUMEROENDERECO:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_TIPOLOGRADOURO" )
								If _cinf <> NIL
									SZ9->Z9_C08  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_TIPOLOGRADOURO:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_UF" )
								If _cinf <> NIL
									SZ9->Z9_C09  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_UF:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_OPCAOSIMPLES" )
								If _cinf <> NIL
									SZ9->Z9_C10  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_OPCAOSIMPLES:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_RAZAOSOCIALPRESTADOR" )
								If _cinf <> NIL
									SZ9->Z9_C11  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_RAZAOSOCIALPRESTADOR:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_STATUSNFE" )
								If _cinf <> NIL
									SZ9->Z9_C12  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_STATUSNFE:TEXT)
								EndIf
								_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_TRIBUTACAONFE" )
								If _cinf <> NIL
									SZ9->Z9_C13  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_TRIBUTACAONFE:TEXT)
								EndIf

								SZ9->(MsUnlock())
								SZ9->(DbCommit())

							EndIf

						Next i

						If Len(oXml:_RETORNOCONSULTA:_NFE) < 50
							lSaida := .T.
						Else
							_nPag++
						EndIf
					Else
						lSaida := .T.
						Conout(oXml:_RETORNOCONSULTA)
					EndIf
				Else 
					lSaida := .T.
					Conout(oXml:_RETORNOCONSULTA)
				Endif

			Else
				Conout(GetWSCError())  // Resumo do erro
				lSaida := .T.
			EndIf

		EndDo
		RpcClearEnv()
		lSaida:= .F.
	Next k
Return()

	*-----------------------------*
Static Function  StQuery(_cFr,_cLj,_nTt)
	*-----------------------------*

	Local cQuery     := ' '
	Local _aRet      := {}
	Local cPerg 	 := "NFSE03"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+ cMinutos+cSegundos

	cQuery := " SELECT C7_NUM, C7_NUMSC, C7_CONTATO
	cQuery += " FROM "+RetSqlName("SC7")+" SC7 "
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_FORNECE = '"+_cFr+"'
	cQuery += " AND SC7.C7_LOJA = '"+_cLj+"'
	cQuery += " AND C7_TOTAL = "+ cValToChar(_nTt)


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			Aadd(_aRet,{ (cAliasLif)->C7_NUM, (cAliasLif)->C7_NUMSC, (cAliasLif)->C7_CONTATO})
			(cAliasLif)->(dbskip())
		End
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

Return(_aRet)

User Function STZ1J()

	Private cCadastro := "NOTAS FISCAIS DE SERVIÇO"
	Private cAlias := "Z1J"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
	{ "Visualizar" , "AxVisual" , 0 , 2 },;
	{ "Incluir"    , "AxInclui" , 0 , 3 },;
	{ "Gerar pre-nota" 		, "U_STSF1" 	, 0 , 3 },;
	{ "Alterar"    , "AXaltera" , 0 , 4 },;
	{ "Excluir"    , "AxDeleta" , 0 , 5 }}

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return()


User Function STSF1()

	Local	aCabec := {}
	Local	aItens := {}
	Local  _cRET := '0'
	Private _aHeader	:= {}
	Private _aCols	:= {}
	Private cEdit1 := Space(15)
	Private oEdit1 := ' '
	Private _DESCdigit := ' '
	Private _NCMdigit := ' '
	Private _oDlg
	nStyle := 0
	aSize    := MsAdvSize(, .F., 400)
	aInfo 	 := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	aObjects := {{100, 100,.T.,.T. }}
	aPosObj := MsObjSize( aInfo, aObjects,.T. )

	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	SF1->(DbGoTop())
	If !(SF1->(DbSeek(xFilial("SF1") + PadR(SZ9->Z9_NFSE,TamSx3("F1_DOC")[1]) + PadR('1',TamSx3("F1_SERIE")[1]) + PadR(SZ9->Z9_COD ,TamSx3("F1_FORNECE")[1]) + Padr(SZ9->Z9_LOJA,TamsX3("F1_LOJA")[1]) + "N")))


		aadd(aCabec,{"F1_TIPO"   ,"N"})
		aadd(aCabec,{"F1_FORMUL" ," "})
		aadd(aCabec,{"F1_DOC"    ,PadR(SZ9->Z9_NFSE,TamSx3("F1_DOC")[1])})
		aadd(aCabec,{"F1_SERIE"  ,'1'})
		aadd(aCabec,{"F1_EMISSAO",SZ9->Z9_DTEMIS })
		aadd(aCabec,{"F1_FORNECE",PadR(SZ9->Z9_COD ,TamSx3("F1_FORNECE")[1])})
		aadd(aCabec,{"F1_LOJA"   ,Padr(SZ9->Z9_LOJA,TamsX3("F1_LOJA")[1])})
		aadd(aCabec,{"F1_ESPECIE", "NFS"})
		aadd(aCabec,{"F1_EST",SZ9->Z9_C09 })
		aadd(aCabec,{"F1_COND","001"})


		aLinha := {}
		cProduto:= Space(15)

		ST_aHeader(Padr(SZ9->Z9_CNPJ,TamsX3("A2_CGC")[1]),;
		PadR(SZ9->Z9_COD ,TamSx3("F1_FORNECE")[1]),;
		Padr(SZ9->Z9_LOJA,TamsX3("F1_LOJA")[1]))
		DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL OF _oDlg

		// Cria as Groups do Sistema
		@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

		// Cria Componentes Padroes do Sistema

		@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
		@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(_cRET:= '1',_oDlg:End())
		@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_cRET:= '0',_oDlg:End())
		oEdit1:SetFocus()

		oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+100,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nStyle,;
		"AllWaysTrue","AllWaysTrue","",/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg,_aHeader,_aCols)

		// 1,1,257,651
		ACTIVATE MSDIALOG _oDlg CENTERED

		If _cRET = '0'
			MsgInfo("Inclusao Abortada!!!!")
			Return()
		EndIf

		aadd(aLinha,{"D1_COD",cEdit1,Nil})
		aadd(aLinha,{"D1_UM" ,"UN",NIL})
		aadd(aLinha,{"D1_QUANT",1,Nil})
		aadd(aLinha,{"D1_VUNIT",SZ9->Z9_N04  ,Nil})
		aadd(aLinha,{"D1_TOTAL",SZ9->Z9_N04  ,Nil})
		If !(Empty(SZ9->Z9_PEDIDO))
			aadd(aLinha,{"D1_PEDIDO",SZ9->Z9_PEDIDO  ,Nil})
			aadd(aLinha,{"D1_ITEMPC",'0001'  ,Nil})
		EndIf

		aadd(aItens,aLinha)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Inclusao                                            |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		//return()
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)


		If lMsErroAuto  //se der erro

			MostraErro()
			lMsErroAuto := .F.

		Else

			MsgAlert("Pre-nota Gerada com sucesso!","Atenção.")

			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_DOC := SF1->F1_DOC
			SZ9->(MsUnLock())

		EndIf
	EndIf

Return()
Static Function ValProd()
	_DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
	_NCMdigit=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")
	Return(ExistCpo("SB1"))


	/*====================================================================================\
	|Programa  | ST_a01Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST_a01Header                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ST_aHeader(_cCgc,_cCod,_cLoj)
	*-----------------------------*
	Local cPerg       := 'ST_aHeader'
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAlias      := cPerg+cHora+ cMinutos+cSegundos
	Local cQuery 	  := ""


	_aHeader:= {}
	//TamSx3("B1_DESC")[1]
	aAdd(_aHeader,{"Produto",		"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Descricao",		"XX_DESC"	,"@!",30					,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Qtd.",	   		"XX_QTD"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_aHeader,{"Prc.",	   		"XX_PRC"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_aHeader,{"Ord.Compra",	"XX_ORD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})


	_aCols:= {}

	cQuery:= " 	SELECT
	cQuery+= " SC7.C7_PRODUTO,
	cQuery+= " SC7.C7_DESCRI,
	cQuery+= " SC7.C7_QUANT-SC7.C7_QUJE
	cQuery+= ' "C7_QUANT",
	cQuery+= " SC7.C7_PRECO,
	cQuery+= " SC7.C7_NUM
	cQuery+= " FROM "+RetSqlName("SC7")+"  SC7
	cQuery+= " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery+= " AND SC7.C7_FILIAL = '"+cFilAnt+"'
	cQuery+= " AND SC7.C7_FORNECE =  '"+_cCod+"'
	cQuery+= " AND SC7.C7_LOJA = '"+_cLoj+"'
	cQuery+= " AND SC7.C7_RESIDUO = ' '
	cQuery+= " AND SC7.C7_QUANT   > SC7.C7_QUJE


	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())



		Aadd(_aCols,{(cAlias)->C7_PRODUTO,;
		(cAlias)->C7_DESCRI	,;
		(cAlias)->C7_QUANT	,;
		(cAlias)->C7_PRECO	,;
		(cAlias)->C7_NUM	,;
		.f.   })


		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())


	If Len(_aCols) = 0
		Aadd(_aCols,{' ',' ',0,0,' ',.f.   })
	EndIf
Return()

