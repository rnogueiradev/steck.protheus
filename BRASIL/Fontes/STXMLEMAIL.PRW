#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "XMLXFUN.CH"
#include "FILEIO.CH"



user function tstGetAttach()
	Local oServer
	Local oMessage
	Local nAttach := 0
	Local nMessages := 0
	Local cAttach := "", cName := ""
	Local aAttInfo := {}
	Local xRet
	Local nI := 0
	Local j := 0
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	oServer := tMailManager():New()
	writePProString( "Mail", "Protocol", "POP3", getsrvininame() )
	
	oServer:SetUseSSL( .T. )
	xRet := oServer:Init( GetMV("MV_RELSERV",,"smtp.servername.com.br"), "", "cte", "#steck@2017", 995, 0 )
	if xRet <> 0
		conout( "Could not initialize mail server: " + oServer:GetErrorString( xRet ) )
		return
	endif
	
	xRet := oServer:POPConnect()
	if xRet <> 0
		conout( "Could not connect on POP3 server: " + oServer:GetErrorString( xRet ) )
		return
	endif
	
	oServer:GetNumMsgs( @nMessages )
	conout( "Number of messages: " + cValToChar( nMessages ) )
	for j := 1 to nMessages
		oMessage := TMailMessage():New()
		oMessage:Clear()
		
		conout( "Receiving newest message" )
		xRet := oMessage:Receive( oServer, j )
		if xRet <> 0
			conout( "Could not get message " + cValToChar( j ) + ": " + oServer:GetErrorString( xRet ) )
			return
		endif
		
		nAttach := oMessage:GetAttachCount()
		for nI := 1 to nAttach
			aAttInfo := oMessage:GetAttachInfo( nI )
			cName := "\arquivos\XML_CTE\"
			
			if aAttInfo[1] == ""
				cName += "message." + SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			else
				cName += aAttInfo[1]
			endif
			
			conout( "Saving attachment " + cValToChar( nI ) + ": " + cName )
			
			cAttach := oMessage:GetAttach( nI )
			xRet := MemoWrite( cName, cAttach )
			if !xRet
				conout( "Could not save attachment " + cValToChar( nI ) )
			endif
		next nI
	Next j
	for j := 1 to nMessages
		oServer:DeleteMsg( j )
	Next j
	xRet := oServer:POPDisconnect()
	if xRet <> 0
		conout( "Could not disconnect from POP3 server: " + oServer:GetErrorString( xRet ) )
	endif
	
return







User Function STXMLEMAIL()
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados da conta POP ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cData          := DtoC(Date())
	Local cHora          := Time()
	Local cPathTmp       := "\arquivos\XML_CTE\"
	Local cPath          := "\arquivos\XML_CTE\CTE\"
	Local nTotMsg        := 0
	Local cServer        := ' '//GetMV("MV_RELSERV",,"smtp.servername.com.br")
	Local cAccount       := "CTE"
	Local cPassword 	 := "#steck@2017"
	Local lConectou 	 := .f.
	Local cBody      	 :=""
	Local cTO            :=""
	Local cFrom          :=""
	Local cCc            :=""
	Local cBcc           :=""
	Local cSubject       :=""
	Local cCmdEnv        :=""
	Local nX        	  := 0
	Local w        	  := 0
	Private oBrowse115
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	cServer        := GetMV("MV_RELSERV",,"smtp.servername.com.br")
	u_tstGetAttach()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Conectado ao servidor POP ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONNECT POP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
	POP MESSAGE COUNT nTotMsg
	
	
	If lConectou
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recebendo emails ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For w:=1 to nTotMsg
			aFiles:={}
			
			
			RECEIVE MAIL MESSAGE w FROM cFrom TO cTo CC cCc BCC cBcc SUBJECT cSubject BODY cBody ATTACHMENT aFiles SAVE IN (cPathTmp) DELETE
			
			/*
			For i:=1 to len(aFiles)
				If Right(aFiles[i,1],4) $ "#.xml#.XML#"
					Private nHdl := FOpen("\XML_CTE\LOGCTE.txt",0,,.F.)
					cLog := StrTran(aFiles[i,1]," ","",1)+" "+cData+" "+cHora
					Acalog("\XML_CTE\LOGCTE.txt",cLog)
					
					// xFile := STRTRAN(lower(StrTran(aFiles[i,1], " " ,"",1)),cPathTmp,cPath)
					xFile := cPathTmp
					COPY FILE &aFiles[i,1] TO &xFile
					xFile :=   cPath
					COPY FILE &aFiles[i,1] TO &xFile
					nX++
					//FErase(aFiles[i,1])desabilitado ater ter a conta aficial
				Else
					Private nHdl := FOpen("\XML_CTE\LOGCTE_ERR.txt",0,,.F.)
					cLog := aFiles[i,1]+" "+cData+" "+cHora
					Acalog("\XML_CTE\LOGCTE_ERR.txt",cLog)
					//FErase(aFiles[i,1])desabilitado ater ter a conta aficial
				EndIf
				
			Next
			*/
		Next
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconectando ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lConectou
		DISCONNECT POP SERVER Result lDisConectou
	Else
		u_tstGetAttach()
		
	EndIf
	STTXTXML()
//	GFEA118IMP()
//	U_STXMLROMAN() //RECALCULAR ROMANEIOS
	//U_STXMLOCORRE()//OCORRENCIAS
	//U_STXMLPROCES('3')
	
Return

Static Function STTXTXML()
	
	Local aDirTxt 		:= {}
	Local aDirXml 		:= {}
	Local aDirPdf 		:= {}
	Local aDirDat 		:= {}
	Local aDirJpg 		:= {}
	Local aDirLog 		:= {}
	Local cDiretorio 	:= '\arquivos\XML_CTE'
	Local cDirOco		:= '\arquivos\XML_CTE\OCORRENCIAS'
	Local cDirFat 		:= '\arquivos\XML_CTE\FATURAS'
	Local cDirEmb 		:= '\arquivos\XML_CTE\EMBARCADOS'
	Local cDirPdf 		:= '\arquivos\XML_CTE\PDF'
	Local cDirCte 		:= '\arquivos\XML_CTE\CTE'
	Local cDirLog 		:= '\arquivos\XML_CTE\CTE\CTE'
	Local cNomeArq 		:= ' '
	Local t        	  := 0
	aDirLog := DIRECTORY(cDirLog + "\*" )
	
	For t:=1  To Len(aDirLog)
		cNomeArq := aDirLog[t][1]
		FRename(cDirLog + "\" + cNomeArq, cDiretorio + "\" + cNomeArq)
	Next t
	
	
	aDirTxt := DIRECTORY(cDiretorio + "\*.TXT" )
	aDirXml := DIRECTORY(cDiretorio + "\*.XML" )
	aDirPdf := DIRECTORY(cDiretorio + "\*.PDF" )
	aDirDat := DIRECTORY(cDiretorio + "\*.DAT" )
	aDirJpg := DIRECTORY(cDiretorio + "\*.JPG" )
	
	
	For t:=1  To Len(aDirTxt)
		
		cNomeArq := aDirTxt[t][1]
		
		If     Upper('emb') $ Upper(cNomeArq)
			FRename(cDiretorio + "\" + cNomeArq, cDirEmb + "\" + cNomeArq)
		ElseIf Upper('oco') $ Upper(cNomeArq)
			FRename(cDiretorio + "\" + cNomeArq, cDirOco + "\" + cNomeArq)
		ElseIf Upper('fat') $ Upper(cNomeArq)
			FRename(cDiretorio + "\" + cNomeArq, cDirFat + "\" + cNomeArq)
		EndIf
	Next t
	
	For t:=1  To Len(aDirXml)
		cNomeArq := aDirXml[t][1]
		FRename(cDiretorio + "\" + cNomeArq, cDirCte + "\" + cNomeArq)
	Next t
	
	
	For t:=1  To Len(aDirPdf)
		cNomeArq := aDirPdf[t][1]
		FRename(cDiretorio + "\" + cNomeArq, cDirPdf + "\" + cNomeArq)
	Next t
	For t:=1  To Len(aDirDat)
		cNomeArq := aDirDat[t][1]
		FErase(cDiretorio + "\" + cNomeArq)
	Next t
	For t:=1  To Len(aDirJpg)
		cNomeArq := aDirJpg[t][1]
		FErase(cDiretorio + "\" + cNomeArq)
	Next t
	
Return









//PONTO DE ENTRADA PARA DEFINIR A TES DE ENTRADA DO CTE
User Function GFEA0652()
	Local cRet:= '104'
	Local cTpImp   := Posicione("GVT", 1, xFilial("GVT") + GW3->GW3_CDESP, "GVT_TPIMP")
	If cTpImp = '1'
		cRet := '104'
	ElseIf cTpImp = '2'
		cRet := '105'
	EndIf
Return cRet





User Function GFEA0655()
	
	//Recebe os arrays enviados pelo MSEXECAUTO
	Local aDocFrete := ParamIXB[1]
	Local aItemDoc := ParamIXB[2]
	//Array de Retorno
	Local aRet := {}
	Local nPos
	Local cLoja
	
	//Trocando o valor de um valor que já existe no array.
	//aDocFrete [1] Nome do Campo integrado
	// [2] Valor que está sendo enviado
	// [3] Compatibilidade
	/*	nPos := aScan( aDocFrete, {|x| x[1] == "F1_LOJA" } )
	If !Empty(nPos) .Or. nPos <> 0
		cLoja := aDocFrete[nPos][2]
		aDocFrete[nPos][2] := "29"
	EndIf
	*/
	//Adiciona um novo campo para integração dos itens
	Aadd(aItemDoc[1], {"D1_CONTA" , "410130086" , Nil} )
	Aadd(aItemDoc[1], {"D1_CC" , "114102" , Nil} )
	/*O retorno do ponto de entrada, aguarda um array com duas posições
	A primeira contendo o array com as informações do Documento de Frete
	E a segunda contendo o array com as informações dos Itens*/
	Aadd(aRet, {aDocFrete, aItemDoc})
	
Return aRet



#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "XMLXFUN.CH"
#include "FILEIO.CH"

/*====================================================================================\
|Programa  | GFEA1183          | Autor | GIOVANI.ZAGO             | Data | 01/01/2016 |
|=====================================================================================|
|Sintaxe   | GFEA1183   Ponto de entrada na importação do xml-altera romaneio de carga|
|          | de acordo com a quantidade de nfs                                        |
|=====================================================================================|
|Uso       | Especifico La Pastina                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*------------------------*
User Function GFEA1183()
	*------------------------*
	Local oCTe	 	:= PARAMIXB[1]
	Local aNFe		:= {}
	Local nCont		:= 0
	Local aAreaGW1
	Local oInfNFE
Return .T.
oInfNFE := oCTe:_INFCTE:_INFCTENORM:_INFDOC
//Verifica as informações da nota vinculada
If ValType(XmlChildExN(oInfNFE,"_INFNFE")) == "O"
	XmlNode2Arr( oInfNFE:_INFNFE  , "_INFNFE" )
EndIf
aNFe := oInfNFE:_INFNFE


If  Len(aNFe) > 1
	dbSelectArea("GW1")
	GW1->(dbSetOrder(12)) //indice da chave da NFe
	For nCont := 1 To Len(aNFe)
		If GW1->(dbSeek(aNFe[nCont]:_CHAVE:TEXT))
			dbSelectArea("GWN")
			GWN->(dbSetOrder(1))
			If GWN->(dbSeek(xFilial("GWN")+GW1->GW1_NRROM))
				
				//reabrir romaneio
				If GWN->GWN_SIT = "3"	// Liberado
					GFEA050REA(.T.)
				EndIf
				
				//(lValid, lOcor) Função para eliminar os Cálculos do Documento de Carga  Requere que o Documento de Carga já esteja posicionado(GW1).
				If GFEA44DELC(.t.,.f.)
					
					// Elimina do Romaneio o Documento de Carga escolhido
					RecLock("GW1",.F.)
					GW1->GW1_NRROM 	:= ""
					GW1->GW1_SIT 	:= "3" // Liberado
					MsUnLock("GW1")
					_cRoman:= GWN->GWN_NRROM
				EndIf
			EndIf
			
			
		EndIf
	Next nCont
	
	dbSelectArea("GW1")
	GW1->(dbSetOrder(12)) //indice da chave da NFe
	For nCont := 1 To Len(aNFe)
		If GW1->(dbSeek(aNFe[nCont]:_CHAVE:TEXT))
			
			// Elimina do Romaneio o Documento de Carga escolhido
			RecLock("GW1",.F.)
			GW1->GW1_NRROM 	:= _cRoman
			GW1->GW1_SIT 	:= "4" // Liberado
			MsUnLock("GW1")
			
		EndIf
	Next nCont
	dbSelectArea("GWN")
	GWN->(dbSetOrder(1))
	If GWN->(dbSeek(xFilial("GWN")+_cRoman))
		
		GFE050CALC()
		
		If (GWN->GWN_SIT = '1' .Or. GWN->GWN_SIT = '2')
			GFEA050LIB(.T., ' ',DDATABASE+1,TIME())
		Endif
		
		
	EndIf
	
EndIf
Return .T.

User Function xA118EMIT(cTipo, cIDFED, aGXH)
	Local cEmit		:= ""
	Local lFound		:= .F.
	Local cIdFedTmp	:= ""
	Default cIDFED	:= ""
	Default aGXH		:= {}
	
	// Busca informações de emitentes pelo primeiro documento de carga
	If Len(aGXH) > 0
		dbSelectArea("GW1")
		
		If !Empty(aGXH[1][7])
			GW1->(dbSetOrder(12))
			lFound := GW1->(dbSeek(aGXH[1][7]))
		Else
			GW1->(dbSetOrder(1))
			lFound := GW1->(dbSeek(	PadR(cValToChar(aGXH[1][1]),TamSX3("GW1_FILIAL")[1]," ")+;
				PadR(cValToChar(aGXH[1][6]),TamSX3("GW1_CDTPDC")[1]," ")+;
				PadR(cValToChar(aGXH[1][3]),TamSX3("GW1_EMISDC")[1]," ")+;
				PadR(cValToChar(aGXH[1][4]),TamSX3("GW1_SERDC")[1]," ")	+;
				PadR(cValToChar(aGXH[1][5]),TamSX3("GW1_NRDC")[1]," ")		))
		EndIf
		
		If lFound
			Do Case
			Case cTipo == "1" // 1=Emitente
				// Busca o transportador dos trechos do doc carga com o CNPJ informado no CT-e
				dbSelectArea("GWU")
				GWU->(dbSetOrder(1))
				If GWU->(dbSeek(GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC))
					While 	GWU->(!Eof()) .And.;
							GWU->GWU_FILIAL == GW1->GW1_FILIAL .And.;
							GWU->GWU_CDTPDC == GW1->GW1_CDTPDC .And.;
							GWU->GWU_EMISDC == GW1->GW1_EMISDC .And.;
							GWU->GWU_SERDC  == GW1->GW1_SERDC  .And.;
							GWU->GWU_NRDC   == GW1->GW1_NRDC
						
						cIdFedTmp := Posicione("GU3",1,xFilial("GU3")+GWU->GWU_CDTRP,"GU3_IDFED")
						
						If AllTrim(cIdFedTmp) == AllTrim(cIDFED)
							cEmit := GWU->GWU_CDTRP
							Exit
						EndIf
						
						GWU->(dbSkip())
					EndDo
				EndIf
				
			Case cTipo == "2" // 2=Remetente
				cEmit := GW1->GW1_CDREM
				
			Case cTipo == "3" // 3=Destinatário
				cEmit := GW1->GW1_CDDEST
				
			EndCase
		EndIf
	EndIf
	
	//
	// Se não encontrar transportador pela nota, busca transportador ativo
	// na GU3 com o CNPJ informado no CT-e
	//
	If Empty(cEmit) .And. cTipo == "1"
		cEmit := ValidEmis(11,xFilial("GU3")+cIDFED)
	EndIf
Return cEmit



