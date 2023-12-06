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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTNFS03	บAutor  ณGiovani Zago     บ Data ณ  15/05/17      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณnfse sao paulo 											  บฑฑ
ฑฑบ          ณ   													      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STNFS02( )//cte
	Local oXml
	Local _oWS
	Local cNewEmp 		:= '01'
	Local cNewFil		:= '01'
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
	Local l			:= 0
	Local i			:= 0
	Local k			:= 0
	Private cErro, cAviso,_cIdEnt ,_cPass,_cXml,cNom
	//	Aadd(_aEmp,{'01','01'})
	Aadd(_aEmp,{'01','02'})
	//	Aadd(_aEmp,{'01','04'})
	//Aadd(_aEmp,{'03','01'})
	
	//Inicia outra Thread com outra empresa e filial
	
	For k:=1 To Len(_aEmp)
		cNewEmp 	:= _aEmp[k,1]
		cNewFil		:= _aEmp[k,2]
		
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,)
		cCnpj	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_CGC")
		cIm 	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_INSCM")
		cNom	:=  Posicione("SM0",1,cNewEmp+cNewFil,"M0_NOMECOM")
		
		_cIdEnt :=  U_XGETIND(cCnpj,"1")
		_cPass  :=  U_XGETIND(cCnpj,"2")
		
		_cDtIni:= dtos(ddatabase-30)
		_cDtFim:= dtos(ddatabase)
		_cDtIni:= substr(_cDtIni,1,4)+"-"+ substr(_cDtIni,5,2)+"-"+ substr(_cDtIni,7,2)
		_cDtFim:= substr(_cDtFim,1,4)+"-"+ substr(_cDtFim,5,2)+"-"+ substr(_cDtFim,7,2)
		
		
		Do While !lSaida
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
			
			
			
			
			
			cMensagemXML  	:= U_STNFSASS('3550308',EncodeUtf8(Alltrim(cMensagemXML)),"p:distDFeInt","",_cIdEnt, '', "001","","")
			
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
						DbSelectArea("Z1J")
						Z1J->(DbSetOrder(2))
						If !(Z1J->(DbSeek(xFilial("Z1J")+ padr(_cCgc,TamSX3("Z1J_REMETE")[1]," ")+ padr(_cInscM,TamSX3("Z1J_INSCM")[1]," ")+ padr(_cNumNf,TamSX3("Z1J_NFSE")[1]," ") )))
							
							
							
							Z1J->(RecLock("Z1J",.T.))
							
							Z1J->Z1J_FIL 	:= cNewFil
							Z1J->Z1J_CGC 	:= cCnpj
							Z1J->Z1J_NOME 	:= cNom
							Z1J->Z1J_DTBAIX := DATE()
							Z1J->Z1J_TIME 	:= SUBSTR(TIME(),1,5)
							Z1J->Z1J_STATUS := '0'
							Z1J->Z1J_SERIE 	:= ''
							Z1J->Z1J_NOTA  	:= ''
							Z1J->Z1J_LOG    := ''
							Z1J->Z1J_XML   	:= VARINFO ('XML', oXml:_RETORNOCONSULTA:_NFE[i]  ,  , .F. ,   )
							Z1J->Z1J_DEPART := ' '
							//Z1J->Z1J_ERRO   := ' '
							Z1J->Z1J_REMETE := _cCgc
							Z1J->Z1J_INSCM 	:= _cInscM
							
							Z1J->Z1J_N01  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_ALIQUOTASERVICOS:TEXT)
							Z1J->Z1J_N02  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORCREDITO:TEXT)
							Z1J->Z1J_N03  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORISS:TEXT)
							Z1J->Z1J_N04  	:= Val(oXml:_RETORNOCONSULTA:_NFE[i]:_VALORSERVICOS:TEXT)
							
							
							DbSelectArea("SA2")
							SA2->(DbOrderNickName("CGCINSCR2"))
							If SA2->(DbSeek(xFilial("SA2")+_cCgc))
								Z1J->Z1J_COD    := SA2->A2_COD
								Z1J->Z1J_LOJA   := SA2->A2_LOJA
								Z1J->Z1J_NFOR  	:= SA2->A2_NOME
								
								_cMsgErro  := ' '
								_aRet:= StQuery(SA2->A2_COD,SA2->A2_LOJA,Z1J->Z1J_N04 )
								If Len(_aRet) = 1
									Z1J->Z1J_PEDIDO := _aRet[1,1]
									Z1J->Z1J_SOLICI := _aRet[1,2]
								ElseIf Len(_aRet) > 1
									_cMsgErro  := Alltrim(_cMsgErro)+Cr+Cr+"Encontrado mais de um Pedido de Compras:"+Cr
									For l:=1 To Len(_aRet)
										_cMsgErro   := Alltrim(_cMsgErro)+Cr+_aRet[l,1]
									Next l
								ElseIf Len(_aRet) = 0
									_cMsgErro  := Alltrim(_cMsgErro)+Cr+Cr+"Nใo Encontrado Pedido de Compras."+Cr
								EndIf
								
								_aRet:= {}
								_cinf :=  ''
							EndIf
							Z1J->Z1J_ERRO   := _cMsgErro
							Z1J->Z1J_NFSE  	:= _cNumNf
							Z1J->Z1J_CHAVE  := ''
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE,"_CODIGOVERIFICACAO" )
							If _cinf <> NIL
								Z1J->Z1J_CODVER := Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CHAVENFE:_CODIGOVERIFICACAO:TEXT)
							EndIf
							Z1J->Z1J_DTEMIS := STOD(STRTRAN(SUBSTR(oXml:_RETORNOCONSULTA:_NFE[i]:_DATAEMISSAONFE:TEXT,1,10),'-',''))
							Z1J->Z1J_HORA   := SUBSTR(oXml:_RETORNOCONSULTA:_NFE[i]:_DATAEMISSAONFE:TEXT,12,08)
							
							mlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_DISCRIMINACAO" )
							If _cinf <> NIL
								Z1J->Z1J_DESC 	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_DISCRIMINACAO:TEXT)
							EndIf
							
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_CODIGOSERVICO" )//5
							If _cinf <> NIL
								Z1J->Z1J_C01  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_CODIGOSERVICO:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_EMAILPRESTADOR" )
							If _cinf <> NIL
								Z1J->Z1J_C02 	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_EMAILPRESTADOR:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_ENDERECOPRESTADOR" )
							If _cinf <> NIL
								Z1J->Z1J_C03  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_BAIRRO:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_ENDERECOPRESTADOR" )
							If _cinf <> NIL
								Z1J->Z1J_C04  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_CEP:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_CIDADE" )
							If _cinf <> NIL
								Z1J->Z1J_C05  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_CIDADE:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_LOGRADOURO" )
							If _cinf <> NIL
								Z1J->Z1J_C06  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_LOGRADOURO:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_NUMEROENDERECO" )
							If _cinf <> NIL
								Z1J->Z1J_C07  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_NUMEROENDERECO:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_TIPOLOGRADOURO" )
							If _cinf <> NIL
								Z1J->Z1J_C08  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_TIPOLOGRADOURO:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR,"_UF" )
							If _cinf <> NIL
								Z1J->Z1J_C09  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_ENDERECOPRESTADOR:_UF:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_OPCAOSIMPLES" )
							If _cinf <> NIL
								Z1J->Z1J_C10  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_OPCAOSIMPLES:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_RAZAOSOCIALPRESTADOR" )
							If _cinf <> NIL
								Z1J->Z1J_C11  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_RAZAOSOCIALPRESTADOR:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_STATUSNFE" )
							If _cinf <> NIL
								Z1J->Z1J_C12  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_STATUSNFE:TEXT)
							EndIf
							_cinf :=  XmlChildEx ( oXml:_RETORNOCONSULTA:_NFE[i],"_TRIBUTACAONFE" )
							If _cinf <> NIL
								Z1J->Z1J_C13  	:= Alltrim(oXml:_RETORNOCONSULTA:_NFE[i]:_TRIBUTACAONFE:TEXT)
							EndIf
							
							
							Z1J->(MsUnlock())
							Z1J->(DbCommit())
							
							
							
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
				Conout(GetWSCError())  // Resumo do erro
				lSaida := .T.
			EndIf
			
			
			
			
		EndDo
		RpcClearEnv()
		lSaida:= .F.
	Next k
Return()
