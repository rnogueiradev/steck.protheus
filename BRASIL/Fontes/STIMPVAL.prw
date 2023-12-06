#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#include "tbiconn.ch"
#include "topconn.ch"


STATIC nPosProd := 5

/*/{Protheus.doc} STIMPVAL
description
  Importa arquivo XLS
@type function
@version 
@author Valdemir Jose
@since 01/07/2020
@return return_type, return_description
/*/
User Function STIMPVAL(cCamArq, cArquiv, cPathDes, cPathErr, plJOB)

	Local nLinCab  := 3
	Local lVisTela := .F.
	Local cTipoRet := "A"    // A=Array, "C"=Arquivo CSV
	Local aTMP     := {}
    Local aCabec   := {}
    Local cChave   := ""
    Local lAchou   := .F.
    Local nLin     := 0
	Local nX       := 0
    Local nCol     := 0
	Local nConta   := 0
	Local cArmz    := SuperGetMV("ST_AMZFORC",.F.,"03")
	Local _cPath   := "\Schneider\Forecast\pendentes\"
    
	Conout("|XLS-Forecast-Inicio | " + DTOC(DATE()) + " " + TIME() + " Gravacao")

    aTMP := U_STIMPXLS(cArquiv,cCamArq,nLinCab,lVisTela,cTipoRet)

	if Len(aTMP) > 0
	   if file(_cPath+cArquiv)
	      fRename(_cPath+cArquiv,_cPath+cArquiv+".old")
	   endif 
	endif 

    if Len(aTMP) > 0
       aCabec := getCabec(cArquiv) 
	   For nX := 1 to Len(aCabec)
	       if EMPTY(aCabec[nX])
		      aDel(aCabec, nX)
			  nConta += 1
		   endif 
	   Next 
	   if nConta > 0
   	      aSize(aCabec, Len(aCabec)-nConta)
	   endif 
	   
       //Tratando cabecalho
       For nX := 12 to Len(aCabec)
	       IF Substr(aCabec[nX],12,1)=="F"
           	  aCabec[nX] := Left(aCabec[nX],8)
		   Endif 
       Next

	   // Trata Dados
	   For nX := 1 to Len(aTMP)    // Total de Linhas
	       if Len(aTMP[nX]) > Len(aCabec)
		      nConta := 0
		      For nCol := Len(aCabec)+1 to Len(aTMP[nX])
			      aDel(aTMP[nX],nCol)
			      nConta += 1
			  Next 
			  if nConta > 0
			     aSize(aTMP[nX], Len(aTMP[nX])-nConta)
			  endif 
		   endif 
	   Next 
	   
	   if !plJOB
	   	  ProcRegua(Len(aTMP))
	   endif 

	   dbSelectArea("SB1")
	   dbSetOrder(1)

       dbSelectArea("SC4")
       dbSetOrder(1)
      
       For nLin := 1 to Len(aTMP)
	        if !plJOB
			  ProcessMessages()
	          IncProc("Gravando: "+cValToChar(nLin)+" registros da planilha...")
			endif 
            For nCol := 12 To Len(aTMP[nLin])
			   Memowrite("C:\Temp\ImpVal.txt","Linha: "+cValToChar(nLin)+" Coluna: "+cValToChar(nCol)+" Total Colunas: "+cValToChar(aTMP[nLin]))
			   if Len(aCabec[nCol])==8
			        if Empty(aTMP[nLin][nPosProd])
					   AADD(_aEmlErr,{'Vazio',aCabec[nCol],'Código Produto em branco no arquivo Linha:'+cValToChar(nLin)})
					endif 
			        if Empty(Right(aCabec[nCol],4))
					   AADD(_aEmlErr,{'Vazio',aCabec[nCol],'Data em branco no arquivo Linha:'+cValToChar(nLin)})
					endif 
					cData  := Right(aCabec[nCol],4)+GetMes(Left(aCabec[nCol],3))+'20'
					cChave := PadR(aTMP[nLin][nPosProd],TamSX3('C4_PRODUTO')[1])+cData
					if SB1->( dbSeek(xFilial("SB1")+PadR(aTMP[nLin][nPosProd],TamSX3('C4_PRODUTO')[1])) )
					    if !Empty(Left(dtoc(stod(cData)),2))
							// Va lidação 
							lAchou := SC4->( !dbSeek(xFilial('SC4')+cChave) )
							RecLock('SC4',lAchou)
							if lAchou   // Gravo chave para adicionar registro
								SC4->C4_FILIAL  := XFILIAL("SC4")
								SC4->C4_PRODUTO := aTMP[nLin][nPosProd]
								SC4->C4_DATA    := stod(cData)
							endif 
							SC4->C4_LOCAL   := cArmz
							SC4->C4_QUANT	:= Val(StrTran(aTMP[nLin][nCol],".",""))
							SC4->C4_OBS		:= cArquiv
							SC4->C4_DOC		:= Left(dtos(dDatabase),6)
							MsUnlock()
							//AADD(_aEmail,{SC4->C4_PRODUTO,dtoc(SC4->C4_DATA),SC4->C4_QUANT,SC4->C4_DOC,cArquiv})
						Endif
					else 
					   // Enviar WF com inconsistência
					   AADD(_aEmlErr,{aTMP[nLin][nPosProd],aCabec[nCol],'Produto não encontrado (SB1) Linha:'+cValToChar(nLin)})
					Endif
               endif
            Next			            
       Next
	   CompSC4(aTMP)
    endif 

Return



Static Function CompSC4(aTMP)
	Local nLin := 0
	Local nCol := 0
	Local cQry := ""
	Local cDOC := Left(dtos(dDatabase-30),6)

	cQry += "SELECT R_E_C_N_O_ REG " + CRLF 
	cQry += "FROM " + RETSQLNAME("SC4") + " SC4 " + CRLF 
	cQry += "WHERE SC4.D_E_L_E_T_ = ' ' " + CRLF 
	cQry += " AND C4_DOC = '"+cDOC+"' " + CRLF 

	if Select("TSC4") > 0
       TSZN->( dbCloseArea() )
	endif 

	TcQuery cQry New Alias "TSC4"

	while TSC4->( !Eof() )
	  SC4->( dbGoto(TSC4->REG) )
	  cData  := DTOS(SC4->C4_DATA)
	  cChave := PadR(SC4->C4_PRODUTO,TamSX3('C4_PRODUTO')[1])+cData
	  lAchou := SC4->( dbSeek(xFilial('SC4')+cChave) )
	  IF lAchou
		RecLock('SC4')	
		C4_QUANT := 0  
		MsUnlock()
	  ENDIF 
	  TSC4->( dbSkip() )
	end

	if Select("TSC4") > 0
       TSC4->( dbCloseArea() )
	endif 	

Return

/*/{Protheus.doc} STXLSIMP
description
   Chamada da rotina via JOB
@type function
@version 
@author Valdemir Jose
@since 13/07/2020
@param plJOB, param_type, param_description
@return return_type, return_description
u_STXLSIMP
/*/
User Function STXLSIMP()
	
	Local cNewEmp   := "01"
	Local cNewFil   := "05"

	Local cArquiv   := 'Forecast-01-02.xlsx'
	Local cCamArq   := 'C:\Temp\Scheneider'
	Local cPathDes  := ''
	Local cPathErr  := ''
	Local plJOB     := .T.			// ************* ALTERAR QUANDO FOR COLOCA-LO COMO JOB ****************
	PRIVATE _aEmail := {}
	PRIVATE _aEmlErr:= {}
	
	if plJOB
		RpcClearEnv()

		RpcSetEnv( cNewEmp , cNewFil )
	Endif
	Conout("|XLSX-Forcast-EMAIl| " + DTOC(DATE()) + " " + TIME() + SM0->M0_CODIGO + " - " + SM0->M0_CODFIL)
	if !GetEmail(plJOB)	
		if !plJOB
			FWMsgRun(,{|| sleep(4000)},'Informativo','ocorreu um problema, verifique o Log')
		else 
		  Conout("ocorreu um problema, verifique o Log")
		Endif 	   
	endif 
	Conout("|XLSX-Forcast-Grava| " + DTOC(DATE()) + " " + TIME() + " FINALIZADO")
	
	if plJOB
	   RESET ENVIRONMENT
	else 
       FWMsgRun(,{|| sleep(4000)},'Informativo','Processo concluído')
	Endif 

Return 

/*/{Protheus.doc} GetEmail
description
Chama rotina de leitura de e-mail e inicio de processo
@type function
@version 
@author Valdemir Jose
@since 13/07/2020
@return return_type, return_description
/*/
Static Function GetEmail(plJOB)

	Local oServer
	Local oMessage
	Local aAttInfo     := {}
	Local aArquivos    := {}
	Local cIniFile     := ""
	Local cIniConf     := ""
	Local cMsg         := ""
	Local cProtocol    := ""
	Local cPath        := GetSrvProfString("Rootpath","")+AllTrim(SuperGETMV("FS_FORECPE",.f.,"\Schneider\Forecast\pendentes\"))
	Local _cPath       := AllTrim(SuperGETMV("FS_FORECPE",.f.,"\Schneider\Forecast\pendentes\"))
	Local cPathDes     := GetSrvProfString("Rootpath","")+AllTrim(SuperGETMV("FS_FORECPR",.f.,"\Schneider\Forecast\processados\"))
	Local _cPathDes    := AllTrim(SuperGETMV("FS_FORECPR",.f.,"\Schneider\Forecast\processados\"))
	Local cPathErr     := GetSrvProfString("Rootpath","")+AllTrim(SuperGETMV("FS_FORECER",.f.,"\Schneider\Forecast\erro\"))
	Local _cPathErr	   := AllTrim(SuperGETMV("FS_FORECER",.f.,"\Schneider\Forecast\erro\"))
	Local cRecvSrv     := AllTrim(SuperGETMV("FS_FORPOP3",,"outlook.office365.com"))
	Local cUser        := AllTrim(SuperGETMV("FS_FORMAIL",.f.,"wfprotheus10@steck.com.br"))
	Local _cEmail      := AllTrim(SuperGETMV("FS_EMLFIS",.f.,"wfprotheus10@steck.com.br"))
	Local cPass        := AllTrim(SuperGETMV("FS_FORPWD" ,.f.,"Teste123"))
	Local lIsPop       := SuperGETMV("FS_FORIPOP" ,.f.,.T.) 	// define as .T. if POP protocol, instead of IMAP
	Local lRecvSec     := SuperGETMV("FS_FORSCON" ,.f.,.T.) 	// define as .T. if the server uses secure connection
	Local lConnected   := .F.
	Local lSave        := .F.
	Local nTimeout     := 60 									// define the timout to 60 seconds
	Local nAtach       := 0
	Local nI           := 0
	Local nRecv        := 0
	Local nMessages    := 0
	Local nMessageDown := 0	
	Local _nLin		   := 0
	Local xRet
	Local lRET         := .T.
	Private _aEmail    := {}

	if !EXISTDIR( _cPath )
		FWMakeDir(_cPath)
	endif 
	if !EXISTDIR( _cPathDes )
		FWMakeDir(_cPathDes)
	endif
	if !EXISTDIR( _cPathErr )
		FWMakeDir(_cPathErr)	
	endif 
	
	If lIsPop == .T.
		cProtocol := "POP3"
		If lRecvSec == .T.
			nRecv := 995 //default port for POPS protocol
			//nRecv := 110 //default port for POP protocol
		EndIf
	Else
		cProtocol := "IMAP"
		If lRecvSec == .T.
			nRecv := 993 //default port for IMAPS protocol
		Else
			nRecv := 143 //default port for IMAP protocol
		EndIf
	EndIf
	
	cIniFile := GetSrvIniName()
	//cIniConf := GetPvProfString( "MAIL", "Protocol", "", cIniFile )
	xRet := WritePProString( "MAIL", "Protocol", cProtocol, cIniFile )
	
	If xRet == .F.
		cMsg := "Não foi possível definir " + cProtocol + " on " + cIniFile + CRLF
		Conout( cMsg )
		lRET := .F.
	EndIf
	
	oServer := TMailManager():New()
	
	If lRecvSec == .T.
		oServer:SetUseSSL( .T. )    
	Else
		oServer:SetUseSSL( .F. )
	EndIf
	oServer:SetUseTLS( .T. )     
	
	// once it will only receives messages, the SMTP server will be passed as ""
	// and the SMTP port number won't be passed, once it is optional
	xRet := oServer:Init( cRecvSrv, "smtp.office365.com" , cUser, cPass, nRecv, 587 ) 
	
	If xRet != 0
		cMsg := "Não foi possível inicializar o servidor de email: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		RestoreConf( cIniConf, cIniFile )
		lRET := .F.
	EndIf
	
	// the method works for POP and IMAP, depending on the INI configuration
	xRet := oServer:SetPOPTimeout( 320 )
	
	If xRet != 0
		cMsg := "Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout )
		conout( cMsg )
	EndIf
	
	If lIsPop == .T.
		xRet := oServer:POPConnect()
	Else
		xRet := oServer:IMAPConnect()
	EndIf
	
	If xRet <> 0
		cMsg := "Não foi possível conectar " + cProtocol + " servidor: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		lConnected := .F.
		lRET := .F.
	Else
		lConnected := .T.
	EndIf
	
	If lConnected
		xRet := oServer:GetNumMsgs( @nMessages )
		cMsg := "Número de mensagens: " + cValToChar( nMessages )
		conout( cMsg )
		If nMessages > 0
			oMessage := TMailMessage():New()
			For nI := 1 to nMessages
				cMsg := "Recebendo mensagem " + cValToChar( nI )
				conout( cMsg )
				oMessage:Clear()
				xRet := oMessage:Receive( oServer, nI )
				If xRet <> 0
					cMsg := "Não foi possível obter a mensagem " + cValToChar( nI ) + ": " + oServer:GetErrorString( xRet )
					conout( cMsg )
					If xRet == 6 // error code for "No Connection"
						RestoreConf( cIniConf, cIniFile )
						lRET := .F.
					EndIf
				Else
					xRet := oMessage:getAttachCount()
					If xRet > 0
						lSave := .T.
						//Verifica todos anexos da mensagem e os salva
						For nAtach := 1 to xRet
							aAttInfo := oMessage:getAttachInfo(nAtach)
							If UPPER(RIGHT(aAttInfo[1],4))=="XLSX"
								oMessage:SaveAttach(nAtach, cPath+aAttInfo[1])
								If !File(cPath+aAttInfo[1],1,.F.)
									lSave := .F.
								EndIf
								nMessageDown++
							EndIf
						Next
						If lSave
							//Deleta mensagem
							oServer:DeleteMsg(nI)
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		If lIsPop == .T.
			xRet := oServer:POPDisconnect()
		Else
			xRet := oServer:IMAPDisconnect()
		EndIf
		
		If xRet <> 0
			cMsg := "Não foi possível desconectar do " + cProtocol + " servidor: " + oServer:GetErrorString( xRet )
			conout( cMsg )
			lRET := .F.
		EndIf
		
		//RestoreConf( cIniConf, cIniFile )
		
	EndIf
	
	aArquivos := {}
	aArquivos := Directory(_cPath+"*.xlsx")
	if (Len(aArquivos)==0)
	   if !plJOB
		if MsgYesNo("Não encontrou arquivo na pasta, Deseja selecionar?")
			cNovoArq := cGetFile("Arquivos xlsx  (*.xlsx)  | *.xlsx  ", "Selecione o Arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)			
			if CPYT2S(cNovoArq, _cPath, .T.)
				aArquivos := Directory(_cPath+"*.xlsx")
			endif 
		endif
	   Endif 
	endif 
	If Len(aArquivos) > 0
		For nI := 1 To Len(aArquivos)
			Conout("|XLSX-Forcast-Email| - processando arquivo: "+aArquivos[nI][1])
			Conout("|XLSX-Forcast-Grava| - antes chamada função STIMPVAL: "+aArquivos[nI][1])
			if !plJOB
            	Processa( {|| U_STIMPVAL(cPath, aArquivos[nI][1], cPathDes, cPathErr, plJOB)}, "Aguarde...", "Gravando registros da planilha...",.F.)
			else
				U_STIMPVAL(cPath, aArquivos[nI][1], cPathDes, cPathErr, plJOB)
		 	endif 
			
			// Copia o Arquivo para Processados
			cOrigem := Substr(cPath+aArquivos[nI][1], At('Schneider',cPath+aArquivos[nI][1])-1, Len(cPath+aArquivos[nI][1]))
			cDestin := Substr(cPathDes+aArquivos[nI][1], At('Schneider',cPathDes+aArquivos[nI][1])-1, Len(cPathDes+aArquivos[nI][1]))
			if __COPYFILE(cOrigem, cDestin)
				// Exclui o arquivo já processado da pasta original
				FErase(cOrigem)
			endif
			
		Next
	EndIf
	
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</FONT> </Caption>'
	cMsg += '<TR><TD><B>PRODUTO</B></TD><TD><B>DATA</B></TD><TD><B>QUANTIDADE</B></TD><TD><B>DOCUMENTO</B></TD><TD><B>OBSERVACAO</B></TD></TR>'

	For _nLin := 1 to Len(_aEmail)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aEmail[_nLin,3]) + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,4] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,5] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(PCEMLCTE.PRW)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	If Len(_aEmail)>0
		U_STMAILTES(_cEmail,"","[WFPROTHEUS] - Previsão de Vendas processados",cMsg)
	EndIf


	// Verifica se ocorreu inconsistências
	if Len(_aEmlErr) > 0
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</FONT> </Caption>'
		cMsg += '<TR><TD><B>CAMPO</B></TD><TD><B>DOCUMENTO</B></TD><TD><B>DESCRICAO</B></TD></TR>'

		For _nLin := 1 to Len(_aEmlErr)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmlErr[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmlErr[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmlErr[_nLin,3] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(PCEMLCTE.PRW)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail,"","[WFPROTHEUS] - (INCONSISTÊNCIAS) Previsão de Vendas processados",cMsg)
	Endif

Return lRET


Static Function getCabec(cArquiv)
	Local aRET    := {}
	Local nLin    := 1
	Local cArqX   := Left(cArquiv, At(".",cArquiv)-1)+".CSV"
	Local cArqTMP := GetTempPath()+cArqX
	Local XBUFFER
	Local cTMP    := ""

	IF FT_FUSE( cArqTMP ) == -1
		MSGINFO("Falha na abertura do arquivo!")
		RETURN()
	ENDIF

	WHILE !FT_FEOF()              
		XBUFFER		:= FT_FREADLN()
		if ((Left(XBUFFER,11)=="Vendor Code") .or. (Left(XBUFFER,6)=="R 2021") .and. Len(XBUFFER) <= 242)
		   cTMP += XBUFFER
		elseif (Left(XBUFFER,11) != "Vendor Code") .and. (Left(XBUFFER,6) != "R 2021") .and.  (nLin > 4)
			if (Left(XBUFFER, 2)=="T ")
			   cTMP += XBUFFER
			else 
				aRET := Separa(cTMP,";")
				Exit
			endif 
		Endif
		nLin++
		FT_FSKIP()
	ENDDO

	FErase(cArqTMP)

Return aRET



Static Function GetMes(pMes, pTipo)
	Local aMES    := {'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'}
	Local cRET    := StrZero(aScan(aMES, {|X| X==pMes}),2)
	Default pTipo := ""

	if (pTipo=="1")
	   cRET := aMes[aScan(aMES, {|X| X==pMes})]
	Endif 

Return cRET
