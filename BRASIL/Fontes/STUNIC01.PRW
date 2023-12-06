
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
±±ºPrograma  ³STUNIC01	ºAutor  ³Giovani Zago     º Data ³  18/08/17      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³UNICOM		 											  º±±
±±º          ³   													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STUNIC03(_cNum)
	Local _aEmail 	:= {}
	Local _cMsgSave := ' '
	Local _lEnv		:= .F.
	aadd(_aEmail,{"Pedido","Emissão","Produto","Descrição","Quantidade"})
	
	If MsgYesNo("Deseja Solicitar prazo para os Itens de Unicom?")
		DbSelectArea('SC5')
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+_cNum))
			SC6->(DbSetOrder(1))
			If	SC6->(DbSeek(xFilial('SC6')+_cNum))
				While SC6->(! Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+_cNum)
					DbSelectArea('SB1')
					SB1->(DbSetOrder(1))
					If 	SB1->(dbSeek(xFilial('SB1')+SC6->C6_PRODUTO))
						
						If Empty(Alltrim(SC6->C6_XOBSUNI)) .And. Empty(Alltrim(SC6->C6_XDTUNI)) .And.  Alltrim(SB1->B1_GRUPO) $ GetMv("ST_STUNIC",,'041/042/999/122')
							aadd(_aEmail,{SC6->C6_NUM,DTOC(SC5->C5_EMISSAO),SC6->C6_PRODUTO,Alltrim(SB1->B1_DESC),Transform(SC6->C6_QTDVEN-SC6->C6_QTDENT,"@E 999,999,999.99")  })
							_cMsgSave := __cuserid + CR
							_cMsgSave += "===================================" +CR
							_cMsgSave += "Solicitado Prazo. " +CR
							_cMsgSave += "Usuário: "+cUserName+CR
							_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
							
							RecLock("SC6", .F.)
							SC6->C6_XOBSUNI    :=   _cMsgSave + CR + Alltrim(SC6->C6_XOBSUNI)
							SC6->(MsUnlock())
							SC6->(DbCommit())
							_cMsgSave:= ' '
						Else
							_lEnv:= .T.
						EndIf
						
					EndIf
					SC6->(DbSkip())
				End
				
			EndIf
			If _lEnv
				MsgInfo("Solicitação ja Enviada Anteriormente, Verifique o Pedido..!!!")
			EndIf
		EndIf
		
		
		If Len(_aEmail) > 1
			STUNIC02(_aEmail)
		EndIf
	EndIf
	
Return()

Static Function STUNIC02(_aMsg)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Solicitação de Prazo Unicom - Pedido: '+SC5->C5_NUM
	Local cFuncSent:= "STUNIC02"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :=  UsrRetMail(__cUserId)
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _cEmail  :=  "filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br" //+ GetMv("ST_UNICMA",,' ')
	
	Dbselectarea('SB1')
	SB1->(dbsetorder(1))
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1
				
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				/*
				
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'
				*/
				
				
			Else
				
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				/*
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
				*/
			EndIf
			
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
		
		
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
		
		
	EndIf
	RestArea(aArea)
Return()




*-----------------------------*
User Function STUNIC01()
	*-----------------------------*
	
	
	Private _nOpcao 	:= 3
	Private aFields 	:= {}
	Private aCols   	:= {}
	Private	aHeader     := {}
	Private aCpoEnch	:= {}
	Private aTam  		:= {}
	Private _cStPed  	:= ' '
	Private h 			:=1
	Private aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Private _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	Private aCpoEnch	:= {}
	Private aPos	  	:= {010,000,115,460}
	Private aButtons 	:= {}
	Private nOpcA		:= 0
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private oChk
	Private lRetorno    := .F.
	Private lChk	 	:= .F.
	Private aVetor	 	:= {}
	Private oLbx
	Private lInverte 	:= .F.
	Private nContLin 	:= 0
	Private lLote    	:= .F.
	Private oDlg
	Private _cnum    	:= ' '
	Private aSize    	:= MsAdvSize(.F.)
	Private lMark   	:=  .F.
	Private aVetor 		:= {}
	Private lSaida  	:= .F.
	Private cPerg       := 'STUNIC01'
	Private cTime       := time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private oGetDad
	Public n := 1
	
	
	If __cuserid $ _cCodAut
		AjustaSX1(cPerg)           // Verifica perguntas. Se nao existe INCLUI.
		
		
		If Pergunte(cPerg,.T.)     // Solicita parametros
			
			Processa({|| 	STQUERY()},'Selecionando Registros')
			
			Processa({|| 	CompMemory()},'Validando Regras Fiscais')
			
			If len(aVetor) > 0
				MonTaSlec()// monta a tela
			Else
				MsgInfo("Não Existe Dirgências Fiscais !!!!!")
			EndIf
			
			(cAliasLif)->(dbCloseArea())
			
		EndIf
	Else
		msginfo('Usuario sem Acesso')
	EndIf
	
	Msunlockall()
	
	DBCloseArea()
Return ()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
	*-----------------------------*
	Local cQuery     := ''
	
	cQuery := "  SELECT SC6.C6_NUM||SC6.C6_ITEM AS REC  FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO IN ('041','042','999','122')
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_QTDVEN>C6_QTDENT
	cQuery += " AND C6_FILIAL = '02'
	cQuery += " AND C6_XDTUNI = ' '
	cQuery += " AND trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C6_XOBSUNI, 3200,1))) <> ' '
	
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)
	
	
Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |    crio o aheader, acols, regtomemory                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
	*-----------------------------*
	Local _ni:=1
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	ProcRegua(RecCount()) // Numero de registros a processar
	
	While !(cAliasLif)->(Eof())
		
		IncProc()
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+(cAliasLif)->C6_NUM))
			
			_cStPed :=(cAliasLif)->C6_NUM
			
			_cnum  :=_cStPed
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria aHeader e aCols da GetDados                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nUsado:=0
			
			
			//				  1-Campo      , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		            	, 6-Validacao  											, 7-ComboBox
			aTam := TamSX3 ("C6_PRODUTO")
			AAdd( aFields, { 'C6_PRODUTO'  , 'C'	, aTam[1]	, 0		, 'PRODUTO'			   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_DESCRI')
			AAdd( aFields, { 'C6_DESCRI'   , 'C'	, aTam[1]	, 0		, 'DESCRIÇÃO'		   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_ITEM')
			AAdd( aFields, { 'C6_ITEM' 	   , 'C'	, aTam[1]	, 0		, 'ITEM	 '  		   		, " "													, ''				  					} )
			AAdd( aFields, { 'RECNO' 	   , 'N'	, 20   		, 0		, 'RECNO'   				, " "	  							   					, ''  									} )
			aTam := TamSX3 ('C6_QTDVEN')
			AAdd( aFields, { 'C6_QTDVEN'  , 'N'	, aTam[1]	, 2		, 'C6_QTDVEN'			   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_QTDENT')
			AAdd( aFields, { 'C6_QTDENT'  , 'N'	, aTam[1]	, 2		, 'C6_QTDENT'			   		, " "													, ''				  					} )
			
			
			aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
			// 	01-Titulo  			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''   			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''  			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, '' 			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, ''		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, ''		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			
			
			nUsado:=len(aHeader)
			aCols:={}
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial()+_cStPed)
			While !eof().and.C6_NUM==_cStPed
				AADD(aCols,Array(nUsado+1))
				For _ni:=1 to nUsado
					If aHeader[_ni,2] = 'TES'
						aCols[Len(aCols),_ni]:=SC6->C6_TES
					ElseIf aHeader[_ni,2] = 'CFOP'
						aCols[Len(aCols),_ni]:=SC6->C6_CF
					ElseIf aHeader[_ni,2] = 'TPOPER'
						aCols[Len(aCols),_ni]:=SC6->C6_OPER
					ElseIf aHeader[_ni,2] = 'CLASSI'
						aCols[Len(aCols),_ni]:=SC6->C6_CLASFIS
					ElseIf aHeader[_ni,2] = 'CFOP_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_CF
					ElseIf aHeader[_ni,2] = 'TPOPER_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_OPER
					ElseIf aHeader[_ni,2] = 'CLASSI_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_CLASFIS
					ElseIf aHeader[_ni,2] = 'RECNO'
						aCols[Len(aCols),_ni]:=SC6->(RECNO())
					Else
						aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
					EndIf
				Next _ni
				aCols[Len(aCols),nUsado+1]:=.F.
				dbSkip()
			End
		EndIF
		
		If Len(aCols)>0
			TESSTT(aCols[1,4]) //passo o tipo de operação  aCols[1,4]
		EndIf
		(cAliasLif)->(dbSkip())
	End
	
	If Len(aCols) = 0
		
		MsgInfo("Não Existe Registros !!!!!!!"+CR+CR+"Verifique os Parametros")
	EndIF
	
	
Return()
/*====================================================================================\
|Programa  | TESSTT           | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |  Chamo a rotina de tes inteligente para avaliar a tes o cfop e a sit.trib|
|          |  Carrego o array   aVetor                                                |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TESSTT                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function TESSTT(_cOper)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= n
	Local _nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == 'TPOPER'        })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'    })
	Local _nPosITEM     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_ITEM'    })
	Local _nPosTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES'           })
	Local _nPosClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI'        })
	Local _nPosCFO      := aScan(aHeader, { |x| Alltrim(x[2]) == 'CFOP'    		 })
	Local _nPoWTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES_NOVA'      })
	Local _nPoWClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI_NOVA'   })
	Local _nPoWCFO      := aScan(aHeader, { |x| Alltrim(x[2]) == 'CFOP_NOVA'     })
	Local _nPoRECN      := aScan(aHeader, { |x| Alltrim(x[2]) == 'RECNO'         })
	Local _nPosQTD     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDVEN'    })
	Local _nPosENT     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDENT'    })
	Local i:=1
	For i:=1 To Len(Acols)
		n:=i
		//	aCols[i,_nPosOper]:= _cOper
		If aCols[i][_nPosQTD] > aCols[i][_nPosENT]
			u_STTESINTELIGENTE()
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
				
				DbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE	 + SC5->C5_LOJACLI	 ))
				
				dbSelectArea("SF4")
				SF4->(dbsetOrder(1))
				If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))
					aCols[i][_nPosClas]:=SB1->B1_ORIGEM+SF4->F4_SITTRIB
				EndIf
				
				If( aCols[i][_nPosClas] <> aCols[i][_nPoWClas] .or. aCols[i][_nPoWCFO] <> aCols[i][_nPosCFO] .or. aCols[i][_nPosTES] <> aCols[i][_nPoWTES]   ) .and.   !Empty(Alltrim(aCols[i][_nPoSTES]))
					
					aadd(aVetor ,{ lMark ,; //01
					SC5->C5_CLIENTE		 ,;	//02   Cod. Cliente
					SC5->C5_LOJACLI		 ,;	//03   Loja Cliente
					SA1->A1_EST			 ,;	//04   ESTADO
					SC5->C5_NUM			 ,;	//05   Pedido
					aCols[i][_nPosProd]  ,;	//06   PRODUTO
					aCols[i][_nPosITEM]  ,;	//07   ITEM
					aCols[i][_nPoWTES]   ,;	//08   Tes do pedido
					aCols[i][_nPoSTES]   ,;	//09   Tes Atualizada
					aCols[i][_nPoWCFO]   ,;	//10   Cfop Do Pedido
					aCols[i][_nPoSCFO]   ,;	//11   Cfop Atualizada
					aCols[i][_nPoWClas]  ,;	//12   Class. Do Pedido
					aCols[i][_nPoSClas]  ,;	//13   Class. Atualizada
					aCols[i][_nPoRECN]   ,; //14   Recno do Item SC6
					SA1->A1_GRPTRIB  	 ,;	//15   GRUPO CLIENTE
					SB1->B1_GRUPO		  ; //16   GRP PRODUTO
					})
					
					_lRet   := .T.
				EndIf
				
			EndIf
			
		EndIf
	Next i
	
	n:= _nOld
	
	
	
Return  (_lRet)

Static Function MonTaSlec()
	
	Do While !lSaida
		nOpcao := 0
		
		Define msDialog odlg title "TESTE" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
		
		cLinOk    :="AllwaysTrue()"
		cTudoOk   :="AllwaysTrue()"//'STxGRV()'
		aCpoEnchoice:={'NOUSER','C5_NUM','C5_CLIENTE','C5_LOJACLI','C5_TIPOCLI','C5_ZCONSUM'}
		aAltEnchoice := {}
		
		Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
			bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
		Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
		
		
		//Cria a listbox
		@ 000,000 listbox oLbx fields header " ", "CLIENTE",'LOJA',"ESTADO", "PEDIDO","PRODUTO","ITEM", "TES ","TES ATUAL", "CFOP ","CFOP ATUAL", "CLASSI", "CLASSI ATUAL","GRP.CLIENTE","GRP.PROD."  size  aSize[3]-05,aSize[4]-29 of oDlg pixel on dbLclick(u_Medlista(oLbx:nat))//iif(u_edlista(oLbx:nat),oDlg:End() ,oDlg:End() ))
		
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
			aVetor[oLbx:nAt,2],;
			aVetor[oLbx:nAt,3],;
			aVetor[oLbx:nAt,4],;
			aVetor[oLbx:nAt,5],;
			aVetor[oLbx:nAt,6],;
			aVetor[oLbx:nAt,7],;
			aVetor[oLbx:nAt,8],;
			aVetor[oLbx:nAt,9],;
			aVetor[oLbx:nAt,10],;
			aVetor[oLbx:nAt,11],;
			aVetor[oLbx:nAt,12],;
			aVetor[oLbx:nAt,13],;
			aVetor[oLbx:nAt,15],;
			aVetor[oLbx:nAt,16];
			}}
		
		@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
			ON CLICK(aEval(aVetor,{|x| x[1]:=lChk}),oLbx:Refresh())
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()},{|| nOpca := 0,lSaida:=.t.,oDlg:End()})
		
	End
	If nOpca =1
		STxGRV()
	EndIf
Return()

/*====================================================================================\
|Programa  | STxGRV           | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STxGRV                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STxGRV()
	*-----------------------------*
	Local i
	Local _lRet   := .F.
	
	
	If MsgYesNo('Confirma Atualização dos Itens Marcados ?')
		For i:=1 To Len(aVetor)
			If	aVetor	[i,1]
				DbSelectArea("SC6")
				SC6->(DbGoTop())
				SC6->(DbGoTo(aVetor[i,14]))
				If 	SC6->(recno()) = aVetor[i,14]
					SC6->(RecLock("SC6",.F.))
					SC6->C6_TES      := aVetor[i,9]
					SC6->C6_CF       := aVetor[i,11]
					SC6->C6_CLASFIS  := aVetor[i,13]
					SC6->(Msunlock("SC6"))
					SC6->(DbCommit())
				EndIF
			EndIF
		Next i
		MsgInfo('Atualização Realizada Com Sucesso..!!!!!!!!')
	EndIF
	
Return  ()

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MEdLista(nPos)
	*-----------------------------*
	
	aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
	oLbx:Refresh()
	
Return (.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALIDPERG ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
	Local i := 0
	Local j := 0
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	aRegs:={}
	//------------ Grupo/Ordem/Pergunta/PERGING/PERGESP/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	AADD(aRegs,{cPerg,"01","Data de    ?","","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data até   ?","","","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Pedido de  ?","","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"04","Pedido até ?","","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"05","Item de    ?","","","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Item até   ?","","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Cliente de  ?","","","mv_ch7","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"08","Cliente até ?","","","mv_ch8","C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"09","Loja de    ?","","","mv_ch9","C",02,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Loja até   ?","","","mv_cha","C",02,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Estado(Cliente) de   ?","","","mv_chb","C",02,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Estado(Cliente) até  ?","","","mv_chc","C",02,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","TES de  ?","","","mv_chd","C",03,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
	AADD(aRegs,{cPerg,"14","TES até ?","","","mv_che","C",03,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
	AADD(aRegs,{cPerg,"15","Grp. Produto de?","","","mv_chf","C",03,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cPerg,"16","Grp. Produto até?","","","mv_chg","C",03,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cPerg,"17","Grp. Trib. (Cliente) de?","","","mv_chh","C",03,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"18","Grp. Trib. (Cliente) até?","","","mv_chi","C",03,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return

//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************




