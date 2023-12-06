#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � ZZG_INTE � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de update dos dicion�rios para compatibiliza��o     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � ZZG_INTE   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZZG_INTE( cEmpAmb, cFilAmb )
	
	Local   aSay      := {}
	Local   aButton   := {}
	Local   aMarcadas := {}
	Local   cTitulo   := "ATUALIZA��O DE DICION�RIOS E TABELAS"
	Local   cDesc1    := "Esta rotina tem como fun��o fazer  a atualiza��o  dos dicion�rios do Sistema ( SX?/SIX )"
	Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n�o podem haver outros"
	Local   cDesc3    := "usu�rios  ou  jobs utilizando  o sistema.  � extremamente recomendav�l  que  se  fa�a um"
	Local   cDesc4    := "BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para que caso "
	Local   cDesc5    := "ocorra eventuais falhas, esse backup seja ser restaurado."
	Local   cDesc6    := ""
	Local   cDesc7    := ""
	Local   lOk       := .F.
	Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )
	
	Private oMainWnd  := NIL
	Private oProcess  := NIL
	
	#IFDEF TOP
		TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
	#ENDIF
	
	__cInterNet := NIL
	__lPYME     := .F.
	
	Set Dele On
	
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	//aAdd( aSay, cDesc6 )
	//aAdd( aSay, cDesc7 )
	
	// Botoes Tela Inicial
	aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
	aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )
	
	If lAuto
		lOk := .T.
	Else
		FormBatch(  cTitulo,  aSay,  aButton )
	EndIf
	
	If lOk
		If lAuto
			aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
		Else
			aMarcadas := EscEmpresa()
		EndIf
		
		If !Empty( aMarcadas )
			If lAuto .OR. MsgNoYes( "Confirma a atualiza��o dos dicion�rios ?", cTitulo )
				oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
				oProcess:Activate()
				
				If lAuto
					If lOk
						MsgStop( "Atualiza��o Realizada.", "ZZG_INTE" )
						dbCloseAll()
					Else
						MsgStop( "Atualiza��o n�o Realizada.", "ZZG_INTE" )
						dbCloseAll()
					EndIf
				Else
					If lOk
						Final( "Atualiza��o Conclu�da." )
					Else
						Final( "Atualiza��o n�o Realizada." )
					EndIf
				EndIf
				
			Else
				MsgStop( "Atualiza��o n�o Realizada.", "ZZG_INTE" )
				
			EndIf
			
		Else
			MsgStop( "Atualiza��o n�o Realizada.", "ZZG_INTE" )
			
		EndIf
		
	EndIf
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSTProc  � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da grava��o dos arquivos           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSTProc( lEnd, aMarcadas )
	Local   aInfo     := {}
	Local   aRecnoSM0 := {}
	Local   cAux      := ""
	Local   cFile     := ""
	Local   cFileLog  := ""
	Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
	Local   cTCBuild  := "TCGetBuild"
	Local   cTexto    := ""
	Local   cTopBuild := ""
	Local   lOpen     := .F.
	Local   lRet      := .T.
	Local   nI        := 0
	Local   nPos      := 0
	Local   nRecno    := 0
	Local   nX        := 0
	Local   oDlg      := NIL
	Local   oFont     := NIL
	Local   oMemo     := NIL
	
	Private aArqUpd   := {}
	
	If ( lOpen := MyOpenSm0(.T.) )
		
		dbSelectArea( "SM0" )
		dbGoTop()
		
		While !SM0->( EOF() )
			// So adiciona no aRecnoSM0 se a empresa for diferente
			If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
					.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
				aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
			EndIf
			SM0->( dbSkip() )
		End
		
		SM0->( dbCloseArea() )
		
		If lOpen
			
			For nI := 1 To Len( aRecnoSM0 )
				
				If !( lOpen := MyOpenSm0(.F.) )
					MsgStop( "Atualiza��o da empresa " + aRecnoSM0[nI][2] + " n�o efetuada." )
					Exit
				EndIf
				
				SM0->( dbGoTo( aRecnoSM0[nI][1] ) )
				
				RpcSetType( 3 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
				
				lMsFinalAuto := .F.
				lMsHelpAuto  := .F.
				
				cTexto += Replicate( "-", 128 ) + CRLF
				cTexto += "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF + CRLF
				
				oProcess:SetRegua1( 8 )
				
				//����������������������������������Ŀ
				//�Atualiza o dicion�rio SX2         �
				//������������������������������������
				oProcess:IncRegua1( "Dicion�rio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				FSAtuSX2( @cTexto )
				
				//����������������������������������Ŀ
				//�Atualiza o dicion�rio SX3         �
				//������������������������������������
				FSAtuSX3( @cTexto )
				
				//����������������������������������Ŀ
				//�Atualiza o dicion�rio SIX         �
				//������������������������������������
				oProcess:IncRegua1( "Dicion�rio de �ndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				FSAtuSIX( @cTexto )
				
				oProcess:IncRegua1( "Dicion�rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				oProcess:IncRegua2( "Atualizando campos/�ndices" )
				
				// Alteracao fisica dos arquivos
				__SetX31Mode( .F. )
				
				If FindFunction(cTCBuild)
					cTopBuild := &cTCBuild.()
				EndIf
				
				For nX := 1 To Len( aArqUpd )
					
					If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
						If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
								!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
							TcInternal( 25, "CLOB" )
						EndIf
					EndIf
					
					If Select( aArqUpd[nX] ) > 0
						dbSelectArea( aArqUpd[nX] )
						dbCloseArea()
					EndIf
					
					X31UpdTable( aArqUpd[nX] )
					
					If __GetX31Error()
						Alert( __GetX31Trace() )
						MsgStop( "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion�rio e da tabela.", "ATEN��O" )
						cTexto += "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " + aArqUpd[nX] + CRLF
					EndIf
					
					If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
						TcInternal( 25, "OFF" )
					EndIf
					
				Next nX
				
				//����������������������������������Ŀ
				//�Atualiza o dicion�rio SX7         �
				//������������������������������������
				oProcess:IncRegua1( "Dicion�rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				FSAtuSX7( @cTexto )
				
				//����������������������������������Ŀ
				//�Atualiza o dicion�rio SX5         �
				//������������������������������������
				oProcess:IncRegua1( "Dicion�rio de tabelas sistema" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				FSAtuSX5( @cTexto )
				
				RpcClearEnv()
				
			Next nI
			
			If MyOpenSm0(.T.)
				
				cAux += Replicate( "-", 128 ) + CRLF
				cAux += Replicate( " ", 128 ) + CRLF
				cAux += "LOG DA ATUALIZACAO DOS DICION�RIOS" + CRLF
				cAux += Replicate( " ", 128 ) + CRLF
				cAux += Replicate( "-", 128 ) + CRLF
				cAux += CRLF
				cAux += " Dados Ambiente" + CRLF
				cAux += " --------------------"  + CRLF
				cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
				cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
				cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
				cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
				cAux += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
				cAux += " Environment........: " + GetEnvServer()  + CRLF
				cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
				cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
				cAux += " Versao.............: " + GetVersao(.T.)  + CRLF
				cAux += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
				cAux += " Computer Name......: " + GetComputerName() + CRLF
				
				aInfo   := GetUserInfo()
				If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
					cAux += " "  + CRLF
					cAux += " Dados Thread" + CRLF
					cAux += " --------------------"  + CRLF
					cAux += " Usuario da Rede....: " + aInfo[nPos][1] + CRLF
					cAux += " Estacao............: " + aInfo[nPos][2] + CRLF
					cAux += " Programa Inicial...: " + aInfo[nPos][5] + CRLF
					cAux += " Environment........: " + aInfo[nPos][6] + CRLF
					cAux += " Conexao............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF
				EndIf
				cAux += Replicate( "-", 128 ) + CRLF
				cAux += CRLF
				
				cTexto := cAux + cTexto + CRLF
				
				cTexto += Replicate( "-", 128 ) + CRLF
				cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
				cTexto += Replicate( "-", 128 ) + CRLF
				
				cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )
				
				Define Font oFont Name "Mono AS" Size 5, 12
				
				Define MsDialog oDlg Title "Atualizacao concluida." From 3, 0 to 340, 417 Pixel
				
				@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont
				
				Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
				Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
					MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel
				
				Activate MsDialog oDlg Center
				
			EndIf
			
		EndIf
		
	Else
		
		lRet := .F.
		
	EndIf
	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX2 � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX2 - Arquivos      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX2( cTexto )
	Local aEstrut   := {}
	Local aSX2      := {}
	Local cAlias    := ""
	Local cEmpr     := ""
	Local cPath     := ""
	Local nI        := 0
	Local nJ        := 0
	
	cTexto  += "Inicio da Atualizacao" + " SX2" + CRLF + CRLF
	
	aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"  , "X2_NOMESPA", "X2_NOMEENG", ;
		"X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
		"X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }
	
	dbSelectArea( "SX2" )
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbGoTop() )
	cPath := SX2->X2_PATH
	cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
	cEmpr := Substr( SX2->X2_ARQUIVO, 4 )
	
	//
	// Tabela ZZG
	//
	aAdd( aSX2, { ;
		'ZZG'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZZG'+cEmpr																, ; //X2_ARQUIVO
	'METAS INTERNOS'														, ; //X2_NOME
	'METAS INTERNOS'														, ; //X2_NOMESPA
	'METAS INTERNOS'														, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO
	
	//
	// Atualizando dicion�rio
	//
	oProcess:SetRegua2( Len( aSX2 ) )
	
	dbSelectArea( "SX2" )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX2 )
		
		oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )
		
		If !SX2->( dbSeek( aSX2[nI][1] ) )
			
			If !( aSX2[nI][1] $ cAlias )
				cAlias += aSX2[nI][1] + "/"
				cTexto += "Foi inclu�da a tabela " + aSX2[nI][1] + CRLF
			EndIf
			
			RecLock( "SX2", .T. )
			For nJ := 1 To Len( aSX2[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
						FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
					Else
						FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
					EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()
			
		Else
			
			If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
				If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ", "TOPCONN") //adicionado o driver TOPCONN \Ajustado
					TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
					cTexto += "Foi alterada chave unica da tabela " + aSX2[nI][1] + CRLF
				Else
					cTexto += "Foi criada   chave unica da tabela " + aSX2[nI][1] + CRLF
				EndIf
			EndIf
			
		EndIf
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX3 � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX3 - Campos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX3( cTexto )
	Local aEstrut   := {}
	Local aSX3      := {}
	Local cAlias    := ""
	Local cAliasAtu := ""
	Local cMsg      := ""
	Local cSeqAtu   := ""
	Local lTodosNao := .F.
	Local lTodosSim := .F.
	Local nI        := 0
	Local nJ        := 0
	Local nOpcA     := 0
	Local nPosArq   := 0
	Local nPosCpo   := 0
	Local nPosOrd   := 0
	Local nPosSXG   := 0
	Local nPosTam   := 0
	Local nSeqAtu   := 0
	Local nTamSeek  := Len( SX3->X3_CAMPO )
	
	cTexto  += "Inicio da Atualizacao" + " SX3" + CRLF + CRLF
	
	aEstrut := { "X3_ARQUIVO", "X3_ORDEM"  , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", ;
		"X3_TITULO" , "X3_TITSPA" , "X3_TITENG" , "X3_DESCRIC", "X3_DESCSPA", "X3_DESCENG", ;
		"X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO", "X3_F3"     , "X3_NIVEL"  , ;
		"X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" , ;
		"X3_CONTEXT", "X3_OBRIGAT", "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", ;
		"X3_PICTVAR", "X3_WHEN"   , "X3_INIBRW" , "X3_GRPSXG" , "X3_FOLDER" , "X3_PYME"   }
	
	//
	// Tabela ZZG
	//
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZZG_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZZG_MES'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mes'																	, ; //X3_TITULO
	'Mes'																	, ; //X3_TITSPA
	'Mes'																	, ; //X3_TITENG
	'Mes'																	, ; //X3_DESCRIC
	'Mes'																	, ; //X3_DESCSPA
	'Mes'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZU'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	'U_zMETAVALID()'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	'01=Janeiro;02=Fevereiro;03=Marco;04=Abril;05=Maio;06=Junho;07=Julho;08=Agosto;09=Setembro;10=Outubro;11=Novembro;12=Dezembro', ; //X3_CBOXSPA
	'01=Janeiro;02=Fevereiro;03=Marco;04=Abril;05=Maio;06=Junho;07=Julho;08=Agosto;09=Setembro;10=Outubro;11=Novembro;12=Dezembro', ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'INCLUI'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZZG_ANO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ano'																	, ; //X3_TITULO
	'Ano'																	, ; //X3_TITSPA
	'Ano'																	, ; //X3_TITENG
	'Ano'																	, ; //X3_DESCRIC
	'Ano'																	, ; //X3_DESCSPA
	'Ano'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZV'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	'U_zMETAVALID()'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	'2013;2014;2015;2016;2017;2018;2019;2020;2021;2022;2023;2024;2025;2026;2027;2028;2029;2030', ; //X3_CBOXSPA
	'2013;2014;2015;2016;2017;2018;2019;2020;2021;2022;2023;2024;2025;2026;2027;2028;2029;2030', ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'INCLUI'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZZG_VEND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod.Vendedor'															, ; //X3_TITULO
	'Cod.Vendedor'															, ; //X3_TITSPA
	'Cod.Vendedor'															, ; //X3_TITENG
	'Cod.Vendedor'															, ; //X3_DESCRIC
	'Cod.Vendedor'															, ; //X3_DESCSPA
	'Cod.Vendedor'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA3'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZZG_NVEND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Vendedor'																, ; //X3_TITULO
	'Vendedor'																, ; //X3_TITSPA
	'Vendedor'																, ; //X3_TITENG
	'Vendedor'																, ; //X3_DESCRIC
	'Vendedor'																, ; //X3_DESCSPA
	'Vendedor'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZZG_GRUPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Grp.Produto'															, ; //X3_TITULO
	'Grp.Produto'															, ; //X3_TITSPA
	'Grp.Produto'															, ; //X3_TITENG
	'Grp.Produto'															, ; //X3_DESCRIC
	'Grp.Produto'															, ; //X3_DESCSPA
	'Grp.Produto'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SBM'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZZG_NGRUPO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc. Grupo'															, ; //X3_TITULO
	'Desc. Grupo'															, ; //X3_TITSPA
	'Desc. Grupo'															, ; //X3_TITENG
	'Desc. Grupo'															, ; //X3_DESCRIC
	'Desc. Grupo'															, ; //X3_DESCSPA
	'Desc. Grupo'															, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZZG_QTD'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Quantidade'															, ; //X3_TITSPA
	'Quantidade'															, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Quantidade'															, ; //X3_DESCSPA
	'Quantidade'															, ; //X3_DESCENG
	'@E 999,999,999,999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	aAdd( aSX3, { ;
		'ZZG'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZZG_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Meta'																	, ; //X3_TITULO
	'Meta'																	, ; //X3_TITSPA
	'Meta'																	, ; //X3_TITENG
	'Meta'																	, ; //X3_DESCRIC
	'Meta'																	, ; //X3_DESCSPA
	'Meta'																	, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'�'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	//
	// Atualizando dicion�rio
	//
	
	nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ARQUIVO" } )
	nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ORDEM"   } )
	nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == "X3_CAMPO"   } )
	nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == "X3_TAMANHO" } )
	nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == "X3_GRPSXG"  } )
	
	aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )
	
	oProcess:SetRegua2( Len( aSX3 ) )
	
	dbSelectArea( "SX3" )
	dbSetOrder( 2 )
	cAliasAtu := ""
	
	For nI := 1 To Len( aSX3 )
		
		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( aSX3[nI][nPosSXG] )
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto += "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF
					cTexto += "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
				EndIf
			EndIf
		EndIf
		
		SX3->( dbSetOrder( 2 ) )
		
		If !( aSX3[nI][nPosArq] $ cAlias )
			cAlias += aSX3[nI][nPosArq] + "/"
			aAdd( aArqUpd, aSX3[nI][nPosArq] )
		EndIf
		
		If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )
			
			//
			// Busca ultima ocorrencia do alias
			//
			If ( aSX3[nI][nPosArq] <> cAliasAtu )
				cSeqAtu   := "00"
				cAliasAtu := aSX3[nI][nPosArq]
				
				dbSetOrder( 1 )
				SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
				dbSkip( -1 )
				
				If ( SX3->X3_ARQUIVO == cAliasAtu )
					cSeqAtu := SX3->X3_ORDEM
				EndIf
				
				nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
			EndIf
			
			nSeqAtu++
			cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )
			
			RecLock( "SX3", .T. )
			For nJ := 1 To Len( aSX3[nI] )
				If     nJ == nPosOrd  // Ordem
					FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )
					
				ElseIf FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					
				EndIf
			Next nJ
			
			dbCommit()
			MsUnLock()
			
			cTexto += "Criado o campo " + aSX3[nI][nPosCpo] + CRLF
			
		Else
			
			//
			// Verifica se o campo faz parte de um grupo e ajsuta tamanho
			//
			If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
				SXG->( dbSetOrder( 1 ) )
				If SXG->( MSSeek( SX3->X3_GRPSXG ) )
					If aSX3[nI][nPosTam] <> SXG->XG_SIZE
						aSX3[nI][nPosTam] := SXG->XG_SIZE
						cTexto +=  "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
						cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF
						cTexto +=  "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
					EndIf
				EndIf
			EndIf
			
			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSX3[nI] )
				
				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
						PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
						PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
						AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"
					
					cMsg := "O campo " + aSX3[nI][nPosCpo] + " est� com o " + SX3->( FieldName( nJ ) ) + ;
						" com o conte�do" + CRLF + ;
						"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
						"que ser� substituido pelo NOVO conte�do" + CRLF + ;
						"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
						"Deseja substituir ? "
					
					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SX3" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )
						
						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SX3 e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
						EndIf
						
						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SX3 que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
						EndIf
						
					EndIf
					
					If nOpcA == 1
						cTexto += "Alterado o campo " + aSX3[nI][nPosCpo] + CRLF
						cTexto += "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + " de [" + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF
						cTexto += "            para [" + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF
						
						RecLock( "SX3", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
						dbCommit()
						MsUnLock()
					EndIf
					
				EndIf
				
			Next
			
		EndIf
		
		oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSIX � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SIX - Indices       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSIX( cTexto )
	Local aEstrut   := {}
	Local aSIX      := {}
	Local lAlt      := .F.
	Local lDelInd   := .F.
	Local nI        := 0
	Local nJ        := 0
	
	cTexto  += "Inicio da Atualizacao" + " SIX" + CRLF + CRLF
	
	aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
		"DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }
	
	//
	// Tabela ZZG
	//
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_MES+ZZG_ANO+ZZG_VEND'									, ; //CHAVE
	'Mes+Ano+Cod.Vendedor'													, ; //DESCRICAO
	'Mes+Ano+Cod.Vendedor'													, ; //DESCSPA
	'Mes+Ano+Cod.Vendedor'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_ANO+ZZG_MES+ZZG_VEND'									, ; //CHAVE
	'Ano+Mes+Cod.Vendedor'													, ; //DESCRICAO
	'Ano+Mes+Cod.Vendedor'													, ; //DESCSPA
	'Ano+Mes+Cod.Vendedor'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_VEND+ZZG_ANO+ZZG_MES'									, ; //CHAVE
	'Cod.Vendedor+Ano+Mes'													, ; //DESCRICAO
	'Cod.Vendedor+Ano+Mes'													, ; //DESCSPA
	'Cod.Vendedor+Ano+Mes'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_VEND+ZZG_MES+ZZG_ANO'									, ; //CHAVE
	'Cod.Vendedor+Mes+Ano'													, ; //DESCRICAO
	'Cod.Vendedor+Mes+Ano'													, ; //DESCSPA
	'Cod.Vendedor+Mes+Ano'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_GRUPO+ZZG_MES+ZZG_ANO'									, ; //CHAVE
	'Grp.Produto+Mes+Ano'													, ; //DESCRICAO
	'Grp.Produto+Mes+Ano'													, ; //DESCSPA
	'Grp.Produto+Mes+Ano'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	aAdd( aSIX, { ;
		'ZZG'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'ZZG_FILIAL+ZZG_GRUPO+ZZG_VEND'											, ; //CHAVE
	'Grp.Produto+Cod.Vendedor'												, ; //DESCRICAO
	'Grp.Produto+Cod.Vendedor'												, ; //DESCSPA
	'Grp.Produto+Cod.Vendedor'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	
	//
	// Atualizando dicion�rio
	//
	oProcess:SetRegua2( Len( aSIX ) )
	
	dbSelectArea( "SIX" )
	SIX->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSIX )
		
		lAlt    := .F.
		lDelInd := .F.
		
		If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
			cTexto += "�ndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
		Else
			lAlt := .T.
			aAdd( aArqUpd, aSIX[nI][1] )
			If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
					StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
				cTexto += "Chave do �ndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
				lDelInd := .T. // Se for alteracao precisa apagar o indice do banco
			Else
				cTexto += "Indice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
			EndIf
		EndIf
		
		RecLock( "SIX", !lAlt )
		For nJ := 1 To Len( aSIX[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
			EndIf
		Next nJ
		MsUnLock()
		
		dbCommit()
		
		If lDelInd
			TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
		EndIf
		
		oProcess:IncRegua2( "Atualizando �ndices..." )
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX7 � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX7 - Gatilhos      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX7   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX7( cTexto )
	Local aEstrut   := {}
	Local aSX7      := {}
	Local cAlias    := ""
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX7->X7_CAMPO )
	
	cTexto  += "Inicio da Atualizacao" + " SX7" + CRLF + CRLF
	
	aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
		"X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }
	
	//
	// Campo ZZG_GRUPO
	//
	aAdd( aSX7, { ;
		'ZZG_GRUPO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ALLTRIM(POSICIONE(' + DUPLAS  + 'SBM' + DUPLAS  + ',1,xFilial(' + SIMPLES + 'SBM' + SIMPLES + ')+ ZZG_GRUPO,' + DUPLAS  + 'BM_DESC' + DUPLAS  + '))', ; //X7_REGRA
	'ZZG_NGRUPO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC
	
	//
	// Campo ZZG_VEND
	//
	aAdd( aSX7, { ;
		'ZZG_VEND'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Alltrim(Posicione("SA3",1,xFilial("SA3")+M->ZZG_VEND,"A3_NOME"))'		, ; //X7_REGRA
	'ZZG_NVEND'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC
	
	//
	// Atualizando dicion�rio
	//
	oProcess:SetRegua2( Len( aSX7 ) )
	
	dbSelectArea( "SX7" )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX7 )
		
		If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )
			
			If !( aSX7[nI][1] $ cAlias )
				cAlias += aSX7[nI][1] + "/"
				cTexto += "Foi inclu�do o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
			EndIf
			
			RecLock( "SX7", .T. )
			For nJ := 1 To Len( aSX7[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
				EndIf
			Next nJ
			
			dbCommit()
			MsUnLock()
			
		EndIf
		oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX5 � Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX5 - Indices       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX5   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX5( cTexto )
	Local aEstrut   := {}
	Local aSX5      := {}
	Local cAlias    := ""
	Local nI        := 0
	Local nJ        := 0
	
	cTexto  += "Inicio Atualizacao SX5" + CRLF + CRLF
	
	aEstrut := { "X5_FILIAL", "X5_TABELA", "X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG" }
	
	//
	// Tabela 00
	//
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'00'																	, ; //X5_TABELA
	'ZU'																	, ; //X5_CHAVE
	'MESES'																	, ; //X5_DESCRI
	'MESES'																	, ; //X5_DESCSPA
	'MESES'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'00'																	, ; //X5_TABELA
	'ZV'																	, ; //X5_CHAVE
	'ANO'																	, ; //X5_DESCRI
	'ANO'																	, ; //X5_DESCSPA
	'ANO'																	} ) //X5_DESCENG
	
	//
	// Tabela ZU
	//
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'01'																	, ; //X5_CHAVE
	'JANEIRO'																, ; //X5_DESCRI
	'JANEIRO'																, ; //X5_DESCSPA
	'JANEIRO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'02'																	, ; //X5_CHAVE
	'FEVEREIRO'																, ; //X5_DESCRI
	'FEVEREIRO'																, ; //X5_DESCSPA
	'FEVEREIRO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'03'																	, ; //X5_CHAVE
	'MARCO'																	, ; //X5_DESCRI
	'MARCO'																	, ; //X5_DESCSPA
	'MARCO'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'04'																	, ; //X5_CHAVE
	'ABRIL'																	, ; //X5_DESCRI
	'ABRIL'																	, ; //X5_DESCSPA
	'ABRIL'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'05'																	, ; //X5_CHAVE
	'MAIO'																	, ; //X5_DESCRI
	'MAIO'																	, ; //X5_DESCSPA
	'MAIO'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'06'																	, ; //X5_CHAVE
	'JUNHO'																	, ; //X5_DESCRI
	'JUNHO'																	, ; //X5_DESCSPA
	'JUNHO'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'07'																	, ; //X5_CHAVE
	'JULHO'																	, ; //X5_DESCRI
	'JULHO'																	, ; //X5_DESCSPA
	'JULHO'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'08'																	, ; //X5_CHAVE
	'AGOSTO'																, ; //X5_DESCRI
	'AGOSTO'																, ; //X5_DESCSPA
	'AGOSTO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'09'																	, ; //X5_CHAVE
	'SETEMBRO'																, ; //X5_DESCRI
	'SETEMBRO'																, ; //X5_DESCSPA
	'SETEMBRO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'10'																	, ; //X5_CHAVE
	'OUTUBRO'																, ; //X5_DESCRI
	'OUTUBRO'																, ; //X5_DESCSPA
	'OUTUBRO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'11'																	, ; //X5_CHAVE
	'NOVEMBRO'																, ; //X5_DESCRI
	'NOVEMBRO'																, ; //X5_DESCSPA
	'NOVEMBRO'																} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZU'																	, ; //X5_TABELA
	'12'																	, ; //X5_CHAVE
	'DEZEMBRO'																, ; //X5_DESCRI
	'DEZEMBRO'																, ; //X5_DESCSPA
	'DEZEMBRO'																} ) //X5_DESCENG
	
	//
	// Tabela ZV
	//
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZV'																	, ; //X5_TABELA
	'2013'																	, ; //X5_CHAVE
	'2013'																	, ; //X5_DESCRI
	'2013'																	, ; //X5_DESCSPA
	'2013'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZV'																	, ; //X5_TABELA
	'2014'																	, ; //X5_CHAVE
	'2014'																	, ; //X5_DESCRI
	'2014'																	, ; //X5_DESCSPA
	'2014'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZV'																	, ; //X5_TABELA
	'2015'																	, ; //X5_CHAVE
	'2015'																	, ; //X5_DESCRI
	'2015'																	, ; //X5_DESCSPA
	'2015'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZV'																	, ; //X5_TABELA
	'2016'																	, ; //X5_CHAVE
	'2016'																	, ; //X5_DESCRI
	'2016'																	, ; //X5_DESCSPA
	'2016'																	} ) //X5_DESCENG
	
	aAdd( aSX5, { ;
		'  '																	, ; //X5_FILIAL
	'ZV'																	, ; //X5_TABELA
	'2017'																	, ; //X5_CHAVE
	'2017'																	, ; //X5_DESCRI
	'2017'																	, ; //X5_DESCSPA
	'2017'																	} ) //X5_DESCENG
	
	//
	// Atualizando dicion�rio
	//
	oProcess:SetRegua2( Len( aSX5 ) )
	
	dbSelectArea( "SX5" )
	SX5->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSX5 )
		
		oProcess:IncRegua2( "Atualizando tabelas..." )
		
		If !SX5->( dbSeek( aSX5[nI][1] + aSX5[nI][2] + aSX5[nI][3]) )
			cTexto += "Item da tabela criado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF
			RecLock( "SX5", .T. )
		Else
			cTexto += "Item da tabela alterado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF
			RecLock( "SX5", .F. )
		EndIf
		
		For nJ := 1 To Len( aSX5[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
			EndIf
		Next nJ
		
		MsUnLock()
		
		aAdd( aArqUpd, aSX5[nI][1] )
		
		If !( aSX5[nI][1] $ cAlias )
			cAlias += aSX5[nI][1] + "/"
		EndIf
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �ESCEMPRESA�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Generica para escolha de Empresa, montado pelo SM0_ ���
���          � Retorna vetor contendo as selecoes feitas.                 ���
���          � Se nao For marcada nenhuma o vetor volta vazio.            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EscEmpresa()
	//��������������������������������������������Ŀ
	//� Parametro  nTipo                           �
	//� 1  - Monta com Todas Empresas/Filiais      �
	//� 2  - Monta so com Empresas                 �
	//� 3  - Monta so com Filiais de uma Empresa   �
	//�                                            �
	//� Parametro  aMarcadas                       �
	//� Vetor com Empresas/Filiais pre marcadas    �
	//�                                            �
	//� Parametro  cEmpSel                         �
	//� Empresa que sera usada para montar selecao �
	//����������������������������������������������
	Local   aSalvAmb := GetArea()
	Local   aSalvSM0 := {}
	Local   aRet     := {}
	Local   aVetor   := {}
	Local   oDlg     := NIL
	Local   oChkMar  := NIL
	Local   oLbx     := NIL
	Local   oMascEmp := NIL
	Local   oMascFil := NIL
	Local   oButMarc := NIL
	Local   oButDMar := NIL
	Local   oButInv  := NIL
	Local   oSay     := NIL
	Local   oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local   oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local   lChk     := .F.
	Local   lOk      := .F.
	Local   lTeveMarc:= .F.
	Local   cVar     := ""
	Local   cNomEmp  := ""
	Local   cMascEmp := "??"
	Local   cMascFil := "??"
	
	Local   aMarcadas  := {}
	
	
	If !MyOpenSm0(.F.)
		Return aRet
	EndIf
	
	
	dbSelectArea( "SM0" )
	aSalvSM0 := SM0->( GetArea() )
	dbSetOrder( 1 )
	dbGoTop()
	
	While !SM0->( EOF() )
		
		If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
			aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
		EndIf
		
		dbSkip()
	End
	
	RestArea( aSalvSM0 )
	
	Define MSDialog  oDlg Title "" From 0, 0 To 270, 396 Pixel
	
	oDlg:cToolTip := "Tela para M�ltiplas Sele��es de Empresas/Filiais"
	
	oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza��o"
	
	@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
	oLbx:SetArray(  aVetor )
	oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
		aVetor[oLbx:nAt, 2], ;
		aVetor[oLbx:nAt, 4]}}
	oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
	oLbx:cToolTip   :=  oDlg:cTitle
	oLbx:lHScroll   := .F. // NoScroll
	
	@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos"   Message  Size 40, 007 Pixel Of oDlg;
		on Click MarcaTodos( lChk, @aVetor, oLbx )
	
	@ 123, 10 Button oButInv Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Inverter Sele��o" Of oDlg
	
	// Marca/Desmarca por mascara
	@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
	@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
		Message "M�scara Empresa ( ?? )"  Of oDlg
	@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Marcar usando m�scara ( ?? )"    Of oDlg
	@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Desmarcar usando m�scara ( ?? )" Of oDlg
	
	Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Sele��o"  Enable Of oDlg
	Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Sele��o" Enable Of oDlg
	Activate MSDialog  oDlg Center
	
	RestArea( aSalvAmb )
	dbSelectArea( "SM0" )
	dbCloseArea()
	
Return  aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �MARCATODOS�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para marcar/desmarcar todos os itens do    ���
���          � ListBox ativo                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI
	
	oLbx:Refresh()
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �INVSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para inverter selecao do ListBox Ativo     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
	Next nI
	
	oLbx:Refresh()
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �RETSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar que monta o retorno com as selecoes        ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RetSelecao( aRet, aVetor )
	Local  nI    := 0
	
	aRet := {}
	For nI := 1 To Len( aVetor )
		If aVetor[nI][1]
			aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
		EndIf
	Next nI
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � MARCAMAS �Autor  � Ernani Forastieri  � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para marcar/desmarcar usando mascaras               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
	Local cPos1 := SubStr( cMascEmp, 1, 1 )
	Local cPos2 := SubStr( cMascEmp, 2, 1 )
	Local nPos  := oLbx:nAt
	Local nZ    := 0
	
	For nZ := 1 To Len( aVetor )
		If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
			If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
				aVetor[nZ][1] :=  lMarDes
			EndIf
		EndIf
	Next
	
	oLbx:nAt := nPos
	oLbx:Refresh()
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � VERTODOS �Autor  � Ernani Forastieri  � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para verificar se estao todos marcardos    ���
���          � ou nao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue := .T.
	Local nI     := 0
	
	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
	Next nI
	
	lChk := IIf( lTTrue, .T., .F. )
	oChkMar:Refresh()
	
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � MyOpenSM0� Autor � TOTVS Protheus     � Data �  27/11/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento abertura do SM0 modo exclusivo     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MyOpenSM0(lShared)
	
	Local lOpen := .F.
	Local nLoop := 0
	
	For nLoop := 1 To 20
		dbUseArea( .T.,"TOPCONN", "SIGAMAT.EMP", "SM0", lShared, .F. ) //adicionado o driver TOPCONN \Ajustado
		
		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
		
		Sleep( 500 )
		
	Next nLoop
	
	If !lOpen
		MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
			IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
	EndIf
	
Return lOpen


/////////////////////////////////////////////////////////////////////////////






 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  03/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function NOVO2
	
	
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Private oLeTxt
	
	Private cString := ""
	
	dbSelectArea("")
	dbSetOrder(1)
	
	//���������������������������������������������������������������������Ŀ
	//� Montagem da tela de processamento.                                  �
	//�����������������������������������������������������������������������
	
	@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
	@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
	@ 26,018 Say "                                                            "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
	
	Activate Dialog oLeTxt Centered
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  03/04/17   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt
	
	//���������������������������������������������������������������������Ŀ
	//� Abertura do arquivo texto                                           �
	//�����������������������������������������������������������������������
	
	Private cArqTxt := "D:\TOTVSDESEN\Microsiga\Protheus\bin\smartclient\ARQUIVO.TXT"
	Private nHdl    := fOpen(cArqTxt,68)
	
	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Return
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Inicializa a regua de processamento                                 �
	//�����������������������������������������������������������������������
	
	Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  03/04/17   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont
	
	Local nTamFile, nTamLin, cBuffer, nBtLidos
	
	//�����������������������������������������������������������������ͻ
	//� Lay-Out do arquivo Texto gerado:                                �
	//�����������������������������������������������������������������͹
	//�Campo           � Inicio � Tamanho                               �
	//�����������������������������������������������������������������Ķ
	//� ??_FILIAL     � 01     � 02                                    �
	//�����������������������������������������������������������������ͼ
	
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nTamLin  := 2+Len(cEOL)
	cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
	
	ProcRegua(nTamFile) // Numero de registros a processar
	
	While nBtLidos >= nTamLin
		
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		
		IncProc()
		
		
		//���������������������������������������������������������������������Ŀ
		//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
		//�����������������������������������������������������������������������
		
		dbSelectArea(cString)
		RecLock(cString,.T.)
		
		//->??_FILIAL := Substr(cBuffer,01,02)
		
		MSUnLock()
		
		//���������������������������������������������������������������������Ŀ
		//� Leitura da proxima linha do arquivo texto.                          �
		//�����������������������������������������������������������������������
		
		nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
		
		dbSkip()
	EndDo
	
	//���������������������������������������������������������������������Ŀ
	//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
	//� cao anterior.                                                       �
	//�����������������������������������������������������������������������
	
	fClose(nHdl)
	Close(oLeTxt)
	
Return

