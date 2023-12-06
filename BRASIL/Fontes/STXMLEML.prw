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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STXMLNFE	ºAutor  ³Giovani Zago        º Data ³  07/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³															  º±±
±±º          ³ 				 											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STXMLEML()

	Local cDiretorio 		:= '\arquivos\xmls_entrada\1101\pendentes'
	Local _nX		 		:= 0
	Local cAviso 	 		:= ""
	Local cErro 	 		:= ""
	Local oFile

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea("QES")

	aDirXml := DIRECTORY(cDiretorio + "\*.XML" )

	DbSelectArea("SZ9")
	SZ9->(DbGoTop())
	SZ9->(DbSetOrder(1))

	For _nX:=1  To Len(aDirXml)

		oNfe := XmlParserFile(cDiretorio+"\"+aDirXml[_nX][1],"_",@cAviso,@cErro)

		_cStu		:= '0'
		cStatusAtu	:= "Ciencia"

		If Type("oNfe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT")=="C"
			If !(SZ9->(DbSeek(cFilAnt+Alltrim(oNfe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT))))

				SZ9->(RecLock("SZ9",.T.))
				SZ9->Z9_STATUS	:= _cStu
				SZ9->Z9_STATUSA	:= cStatusAtu
				_lWf14:= .T.
				SZ9->Z9_DATA	:= DATE()
				SZ9->Z9_HORA	:= TIME()
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

				//SZ9->Z9_NSU	 	:= Alltrim(oXml:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT)

				oFile := FWFileReader():New(cDiretorio+"\"+aDirXml[_nX][1])

				_cXml := ""

				if (oFile:Open())
					while (oFile:hasLine())
						_cXml += oFile:GetLine()
					end
					oFile:Close()
				endif

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

			EndIf
		EndIf

	Next

	Reset Environment

Return()
