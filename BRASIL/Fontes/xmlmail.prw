#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STXMLEMAIL          | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição | Importa Cte do E-mail						                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STXMLEMAIL                                                               |
|=====================================================================================|
|Uso       | EspecIfico La Pastina                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------*
User Function xSTXMLEMAIL()
	*-------------------------------*
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados da conta POP ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cData          := DtoC(Date())
	Local cHora          := Time()
	Local cBaseName      := ''
	Local nPortImap      := 0
	Local cPath          := "\arquivos\XML_CTE\"
	Local nTotMsg        := 0
	Local cServer        := ' '
	Local cAccount       := ''
	Local cPassword 	 := ''
	Local lConectou 	 := .f.
	Local cBody      	 :=""
	Local cTO            :=""
	Local cFrom          :=""
	Local cCc            :=""
	Local cBcc           :=""
	Local cSubject       :=""
	Local cCmdEnv        :=""
	Local nX        	  := 0
	Local nMessages        	  := 0
	local natach			:= 0
	local npopresult   		:= 0
	local nmessages 		:= 0
	local nmessage			:= 0
	local nmessagedown		:= 0
	local natachdown		:= 0
	local nhandle			:= 0
	local ncount        	:= .f.
	local lmessagedown		:= .f.
	local opopserver
	local omessage
	local nindex		 	:= 1
	local acorpomensagem 	:= {}
	local aheaders 			:= {}
	local nnummsg 			:= 0
	local nAttach 			:= 0
	Local ni        	  := 0
	Local j        	  := 0
	Local aAttInfo := {}
	Local cBaseName := "", cName := ""
	Local xRet
	Private oBrowse115
	Private opopserver
	Private oMessage
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	
	cServer        := "imap.gmail.com"   //Endereço do servidor de email imap
	cAccount       :=  "frete01@realcomercial.com.br" // usuario do email
	cPassword 	   :=   "freteembarcador" // SENHA do email
	nPortImap      := 993 //porta de acesso imap
	
	If MakeDir("\arquivos\XML_CTE") == 0
		MakeDir("\arquivos\XML_CTE")
	EndIf
	If MakeDir("\arquivos\XML_CTE\CTE") == 0
		MakeDir("\arquivos\XML_CTE\CTE")
	EndIf
	
	cBaseName := GetSrvProfString( "RootPath", "" )
	
	If Right( cBaseName, 1 ) <> '\'
		
		cBaseName += '\'
		
	EndIf
	
	cBaseName += cPath
	cName := cBaseName
	
	opopserver := tmailmanager():new()
	opopserver:setusessl(.t.)
	//opopserver:setusetls(.t.)
	
	
	opopserver:init(cServer, "", cAccount, cPassword, nPortImap,)
	nerror := opopserver:imapconnect()
	If nerror <> 0
		conout(opopserver:geterrorstring(nerror))
		return msgstop(opopserver:geterrorstring(nerror), "opopserver:imapconnect")
	EndIf
	opopserver:startgetallmsgheader( "folder", { "from", "subject", "to" } )
	while (!opopserver:Endgetallmsgheader( @aheaders ))
		sleep( 5 )
	Enddo
	
	
	opopserver:GetNumMsgs( @nMessages )
	
	conout( "Number of messages: " + cValToChar( nMessages ) )
	
	For j:=1 To nMessages
		oMessage := TMailMessage():New()
		
		oMessage:Clear()
		
		
		
		conout( "Receiving newest message "+ cvaltochar(j) )
		
		xRet := oMessage:Receive( opopserver, j )
		
		If xRet <> 0
			
			conout( "Could not get message " + cValToChar( j ) + ": " + opopserver:GetErrorString( xRet ) )
			
			return
			
		EndIf
		nAttach := oMessage:GetAttachCount()
		
		for nI := 1 to nAttach
			cBaseName:=	cName
			aAttInfo := oMessage:GetAttachInfo( nI )
			
			varinfo( "", aAttInfo )
			
			If aAttInfo[1] == ""
				cBaseName += "message." + SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			else
				cBaseName += aAttInfo[1]
			EndIf
			conout( "Saving attachment " + cValToChar( nI ) + ": " + cBaseName )
			xRet := oMessage:SaveAttach( nI, cBaseName )
			If xRet == .F.
				conout( "Could not save attachment " + cBaseName  )
				loop
			EndIf
			
		next nI
	next j
	//quantidade de mensagens
	/*
	opopserver:getnummsgs( @nnummsg )
	ntam := nnummsg
	
	for ni := 1 to ntam
		opopserver:DeleteMsg(nI)
	next
	
	nerror := opopserver:imapdisconnect()
	If nerror <> 0
		conout(opopserver:geterrorstring(nerror))
		return ()
	EndIf
	*/
	//STTXTXML()
	//GFEA118IMP()
	
Return

/*====================================================================================\
|Programa  | STTXTXML            | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição | Importa Cte do E-mail						                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTXTXML                                                                 |
|=====================================================================================|
|Uso       | EspecIfico La Pastina                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------*
Static Function STTXTXML()
	*-------------------------------*
	Local aDirTxt 		:= {}
	Local aDirXml 		:= {}
	Local aDirPdf 		:= {}
	Local aDirDat 		:= {}
	Local aDirJpg 		:= {}
	Local cDiretorio 	:= '\arquivos\XML_CTE'
	Local cDirOco		:= '\arquivos\XML_CTE\OCORRENCIAS'
	Local cDirFat 		:= '\arquivos\XML_CTE\FATURAS'
	Local cDirEmb 		:= '\arquivos\XML_CTE\EMBARCADOS'
	Local cDirPdf 		:= '\arquivos\XML_CTE\PDF'
	Local cDirCte 		:= '\arquivos\XML_CTE\CTE'
	Local cNomeArq 		:= ' '
	Local t        	  := 0
	
	If MakeDir(cDiretorio) == 0
		MakeDir(cDiretorio)
	EndIf
	If MakeDir(cDirOco) == 0
		MakeDir(cDirOco)
	EndIf
	If MakeDir(cDirFat) == 0
		MakeDir(cDirFat)
	EndIf
	If MakeDir(cDirEmb) == 0
		MakeDir(cDirEmb)
	EndIf
	If MakeDir(cDirPdf) == 0
		MakeDir(cDirPdf)
	EndIf
	If MakeDir(cDirCte) == 0
		MakeDir(cDirCte)
	EndIf
	
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


