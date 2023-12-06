#Include 'Protheus.ch'
#INCLUDE "AP5MAIL.CH"
#INCLUDE "tbiconn.CH"

/*/{Protheus.doc}rel011
Criação de Campo em tempo real

@author Paulo Seno
@since 14/06/2014
@version MP11
/*/
User Function rel011()
	Private oProcess := MsNewProcess():New( { || u_rel011c() }, 'Atualizando...', 'Aguarde, atualizando ...', .F. )
	oProcess:Activate()
return

User Function rel011c()
	local nx,nxt
	Private aEmpresa := {}
	Private aRec := {}

	#IFDEF TOP
	TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
	#ENDIF

	if rel011b()

		Set Dele On

		Do While SM0->(!eof())
			If !Deleted()
				If aScan(aEmpresa, SM0->M0_CODIGO) == 0 //.and. SM0->M0_CODIGO $ "05/06"
					If SM0->M0_CODIGO=="09"
						aAdd(aEmpresa, SM0->M0_CODIGO)
						aAdd(aRec,SM0->(RecNo()))
					EndIF
				Endif
			EndIf

			SM0->(dbSkip())
		EndDo

		nxt := len(aEmpresa)

		oProcess:SetRegua1( nxt )

		for nx := 1 to nxt

			RpcClearEnv()

			if rel011b()

				SM0->(dbGoTo(aRec[nx]))

				Conout(SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)

				RpcSetType( 2 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

				u_rel011a()
			endif

			oProcess:IncRegua1( 'Empresa '+aEmpresa[nx])
		next

	else

		MsgInfo("SIGAMAT não exclusivo.")

	endif

	Alert("Fim")

	reset environment
Return

User Function rel011a()
	Local   cTexto    := ''
	Local   cFile     := ''
	Local   cFileLog  := ''
	Local   cAux      := ''
	Local   cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
	Local   nRecno    := 0
	Local   nI        := 0
	Local   nX        := 0
	Local   nPos      := 0
	Local   aRecnoSM0 := {}
	Local   aInfo     := {}
	Local   lOpen     := .F.
	Local   lRet      := .T.
	Local   oDlg      := NIL
	Local   oMemo     := NIL
	Local   oFont     := NIL

	Private aArqUpd   := {}

	FSAtuSX2()
	FSAtuSX3()
	FSAtuSIX()

	__SetX31Mode( .F. )

	For nX := 1 To Len( aArqUpd )

		If Select( aArqUpd[nx] ) > 0
			dbSelectArea( aArqUpd[nx] )
			(aArqUpd[nx])->(dbCloseArea())
		EndIf

		X31UpdTable( aArqUpd[nx] )

		If __GetX31Error()
			Alert( __GetX31Trace() )
			ApMsgStop( 'Ocorreu um erro desconhecido durante a atualização da tabela : ' + aArqUpd[nx] + '. Verifique a integridade do dicionário e da tabela.', 'ATENÇÃO' )
			cTexto += 'Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : ' + aArqUpd[nx] + CRLF
		else
			dbSelectArea(aArqUpd[nx])
			(aArqUpd[nx])->(dbCloseArea())
		EndIf

	Next nX

	FSAtuSX6()
	FSAtuSX7()
	FSAtuSXA()
	FSAtuSXB()
	FSAtuSX5()
	//FSAtuSX9()
	//FSAtuHlp()

return

/*/{Protheus.doc}rel011b
Efetua abertura da empresa -- SM0

@author Paulo Seno
@since 20/06/2014
@version MP11
/*/
Static Function rel011b()

	Local lSigaMat	:= .T.

	If Select("SM0") == 0
		dbUseArea(.T.,, 'SIGAMAT.EMP', 'SM0', .T., .F.)
	EndIf

	If !empty(Select('SM0'))
		dbSetIndex('SIGAMAT.IND')
	Else
		lSigaMat := .F.
	EndIf

Return lSigaMat

Static Function FSAtuSX2()
	Local aSX2      := {}
	Local aSX2Cpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX2' + CRLF + CRLF
	Local cPath     := ''
	Local cEmpr     := ''
	Local _x

	aEstrut := { 'X2_CHAVE', 'X2_PATH'   , 'X2_ARQUIVO', 'X2_NOME', 'X2_NOMESPA', 'X2_NOMEENG', 'X2_DELET'  , ;
	'X2_MODO' , 'X2_MODOUN' , 'X2_MODOEMP', 'X2_TTS' , 'X2_ROTINA' , 'X2_PYME'   , 'X2_UNICO'  , 'X2_MODULO' }

	dbSelectArea( 'SX2' )
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbGoTop() )
	cPath := SX2->X2_PATH
	cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

	//
	// Tabela PBP
	/*
	aAdd( aSX2, { ;
	'SZ1'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZ1'+cEmpr																, ; //X2_ARQUIVO
	'Operador Logistico'													, ; //X2_NOME
	'Operador Logistico'													, ; //X2_NOMESPA
	'Operador Logistico'													, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'E'																		, ; //X2_MODO
	'E'																		, ; //X2_MODOUN
	'E'																		, ; //X2_MODOEMP
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	0																		} ) //X2_MODULO
	*/

	if File('sx2_virada.dtc')

		conout('SX2_VIRADA')

		DbUseArea( .T., , 'sx2_virada.dtc', 'VIRASX2', .F., .F. )

		DbSelectArea("VIRASX2")
		DbGotop()
		While !Eof()

			addUpd(VIRASX2->X2_CHAVE)

			aSX2Cpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSX2Cpo,VIRASX2->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSX2,aSX2Cpo)

			DbSelectArea("VIRASX2")
			DbSkip()
		End

		DbCloseArea()

		oProcess:SetRegua2( Len( aSX2 ) )

		dbSelectArea( 'SX2' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSX2 )

			oProcess:IncRegua2( 'Atualizando Arquivos (SX2)...')

			If !SX2->( dbSeek( aSX2[nI][1] ) )

				If !( aSX2[nI][1] $ cAlias )
					cAlias += aSX2[nI][1] + '/'
					cTexto += 'Foi incluída a tabela ' + aSX2[nI][1] + CRLF
				EndIf

				RecLock( 'SX2', .T. )

			else

				If !( aSX2[nI][1] $ cAlias )
					cAlias += aSX2[nI][1] + '/'
					cTexto += 'Foi alterada a tabela ' + aSX2[nI][1] + CRLF
				EndIf

				RecLock( 'SX2', .F. )

			EndIf

			For nJ := 1 To Len( aSX2[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					If AllTrim( aEstrut[nJ] ) == 'X2_ARQUIVO'
						FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
					Else
						FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
					EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SX2' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSX3 º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSX3 - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSX3()
	Local aSX3      := {}
	Local aSX3Cpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX3->X3_CAMPO )
	Local cAlias    := ''
	Local cAliasAtu := ''
	Local cSeqAtu   := ''
	Local nSeqAtu   := 0
	Local _x        := 0
	Local cTexto    := 'Inicio da Atualizacao do SX3' + CRLF + CRLF

	aEstrut := { 'X3_ARQUIVO', 'X3_ORDEM'  , 'X3_CAMPO'  , 'X3_TIPO'   , 'X3_TAMANHO', 'X3_DECIMAL', ;
	'X3_TITULO' , 'X3_TITSPA' , 'X3_TITENG' , 'X3_DESCRIC', 'X3_DESCSPA', 'X3_DESCENG', ;
	'X3_PICTURE', 'X3_VALID'  , 'X3_USADO'  , 'X3_RELACAO', 'X3_F3'     , 'X3_NIVEL'  , ;
	'X3_RESERV' , 'X3_CHECK'  , 'X3_TRIGGER', 'X3_PROPRI' , 'X3_BROWSE' , 'X3_VISUAL' , ;
	'X3_CONTEXT', 'X3_OBRIGAT', 'X3_VLDUSER', 'X3_CBOX'   , 'X3_CBOXSPA', 'X3_CBOXENG', ;
	'X3_PICTVAR', 'X3_WHEN'   , 'X3_INIBRW' , 'X3_GRPSXG' , 'X3_FOLDER' , 'X3_PYME'   }

	//

	if File('sx3_virada.dtc')

		conout('SX3_VIRADA')

		DbUseArea( .T., , 'sx3_virada.dtc', 'VIRASX3', .F., .F. )

		DbSelectArea("VIRASX3")
		DbGotop()
		While !Eof()

			addUpd(VIRASX3->X3_ARQUIVO)

			aSX3Cpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSX3Cpo,VIRASX3->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSX3,aSX3Cpo)

			DbSelectArea("VIRASX3")
			DbSkip()
		End

		DbCloseArea()

		DbSelectArea("SX3")

		//
		// Tabela SZ1 - Operador Logistico
		/*
		aAdd( aSX3, { ;
		'SZ1'																	, ; //X3_ARQUIVO
		'01'																	, ; //X3_ORDEM
		'Z1_FILIAL'																, ; //X3_CAMPO
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
		''																		, ; //X3_GRPSXG
		''																		, ; //X3_FOLDER
		''																		} ) //X3_PYME

		//
		// Atualizando dicionário
		*/

		aSort( aSX3,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )

		oProcess:SetRegua2( Len( aSX3 ) )

		dbSelectArea( 'SX3' )
		dbSetOrder( 2 )
		cAliasAtu := ''

		For nI := 1 To Len( aSX3 )

			SX3->( dbSetOrder( 2 ) )

			If !SX3->( dbSeek( PadR( aSX3[nI][3], nTamSeek ) ) )

				addUpd(aSX3[nI][1])

				//
				// Busca ultima ocorrencia do alias
				//
				If ( aSX3[nI][1] <> cAliasAtu )
					cSeqAtu   := '00'
					cAliasAtu := aSX3[nI][1]

					dbSetOrder( 1 )
					SX3->( dbSeek( cAliasAtu + 'ZZ', .T. ) )
					dbSkip( -1 )

					If ( SX3->X3_ARQUIVO == cAliasAtu )
						cSeqAtu := SX3->X3_ORDEM
					EndIf

					nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
				EndIf

				nSeqAtu++
				cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

				RecLock( 'SX3', .T. )
				For nJ := 1 To Len( aSX3[nI] )
					If     nJ == 2    // Ordem
						FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )

					ElseIf FieldPos( aEstrut[nJ] ) > 0
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )

					EndIf
				Next nJ

				dbCommit()
				MsUnLock()

				cTexto += 'Criado o campo ' + aSX3[nI][3] + CRLF

			Else

				//
				// Verifica todos os campos
				//
				For nJ := 1 To Len( aSX3[nI] )

					//
					// Se o campo estiver diferente da estrutura
					//
					If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
					PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), ' ', '' ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , ' ', '' ), 250 ) .AND. ;
					AllTrim( SX3->( FieldName( nJ ) ) ) <> 'X3_ORDEM'

						cTexto += 'Alterado o campo ' + aSX3[nI][3] + CRLF
						cTexto += '   ' + PadR( SX3->( FieldName( nJ ) ), 10 ) + ' de [' + AllToChar( SX3->( FieldGet( nJ ) ) ) + ']' + CRLF
						cTexto += '            para [' + AllToChar( aSX3[nI][nJ] )          + ']' + CRLF + CRLF

						RecLock( 'SX3', .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
						dbCommit()
						MsUnLock()

						addUpd(aSX3[nI][1])

					EndIf

				Next

			EndIf

			oProcess:IncRegua2( 'Atualizando Campos de Tabelas (SX3)...' )

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SX3' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSIX º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSIX - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSIX()
	Local cTexto    := 'Inicio da Atualizacao do SIX' + CRLF + CRLF
	Local cAlias    := ''
	Local lDelInd   := .F.
	Local aSIX      := {}
	Local aSIXCpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local lAlt      := .F.
	Local cSeq      := ''
	Local _x

	aEstrut := { 'INDICE' , 'ORDEM' , 'CHAVE', 'DESCRICAO', 'DESCSPA'  , ;
	'DESCENG', 'PROPRI', 'F3'   , 'NICKNAME' , 'SHOWPESQ' }

	if File('six_virada.dtc')

		conout('Six_VIRADA')

		DbUseArea( .T., , 'six_virada.dtc', 'VIRASIX', .F., .F. )

		DbSelectArea("VIRASIX")
		DbGotop()
		While !Eof()

			addUpd(VIRASIX->INDICE)

			aSIXCpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSIXCpo,VIRASIX->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSIX,aSIXCpo)

			DbSelectArea("VIRASIX")
			DbSkip()
		End

		DbCloseArea()
		dbSelectArea( 'SIX' )

		oProcess:SetRegua2( Len( aSIX ) )

		dbSelectArea( 'SIX' )
		SIX->( dbSetOrder( 1 ) )

		For nI := 1 To Len( aSIX )
			lAlt := .F.

			If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
				RecLock( 'SIX', .T. )
				lDelInd := .F.
				cTexto += 'Índice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
			Else
				lDelInd := .F.
				If StrTran(Upper(AllTrim(SIX->CHAVE))," ","") <> StrTran(Upper(AllTrim(aSIX[nI][3]))," ","")
					If Empty(aSIX[nI][9]) //Nickname em branco
						lDelInd := .T.
						RecLock( 'SIX', .F. )
					Else
						//Pega a proxima sequencia de indice
						SIX->(dbGoTop())
						SIX->( dbSeek( aSIX[nI][1] ) )
						While SIX->(!Eof()) .And. SIX->INDICE == aSIX[nI][1]
							cSeq := SIX->ORDEM
							SIX->(dbSkip())
						EndDo
						cSeq := Soma1(cSeq)
						lDelInd := .F.

						aSIX[nI][2] := cSeq

						RecLock( 'SIX', .T. )
						lDelInd := .F.
						cTexto += 'Índice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
					EndIf
				Else
					lDelInd := .T.
					cTexto += 'Índice alterado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
					lAlt := .T.
				EndIf
			EndIf

			If StrTran( Upper( AllTrim( CHAVE )       ), ' ', '') <> StrTran( Upper( AllTrim( aSIX[nI][3] ) ), ' ', '' )

				addUpd(aSIX[nI][1])

				If !( aSIX[nI][1] $ cAlias )
					cAlias += aSIX[nI][1] + '/'
				EndIf

				For nJ := 1 To Len( aSIX[nI] )
					If FieldPos( aEstrut[nJ] ) > 0
						FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
					EndIf
				Next nJ

				dbCommit()
				MsUnLock()

				If lDelInd
					TcInternal( 60, RetSqlName( aSIX[nI][1] ) + '|' + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
				EndIf

			EndIf

			oProcess:IncRegua2( 'Atualizando índices...' )

		Next nI

	endif

	cTexto += CRLF + CRLF + 'Final da Atualizacao do SIX' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSX6 º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX6 - Parâmetros    ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSX6 - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSX6()
	Local aSX6      := {}
	Local aSX6Cpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX6' + CRLF + CRLF
	Local lReclock  := .T.
	Local lContinua := .T.
	Local _x

	aEstrut := { 'X6_FIL'    , 'X6_VAR'  , 'X6_TIPO'   , 'X6_DESCRIC', 'X6_DSCSPA' , 'X6_DSCENG' , 'X6_DESC1'  , 'X6_DSCSPA1',;
	'X6_DSCENG1', 'X6_DESC2', 'X6_DSCSPA2', 'X6_DSCENG2', 'X6_CONTEUD', 'X6_CONTSPA', 'X6_CONTENG', 'X6_PROPRI' }

	if File('sx6_virada.dtc')

		conout('SX6_VIRADA')

		DbUseArea( .T., , 'sx6_virada.dtc', 'VIRASX6', .F., .F. )

		DbSelectArea("VIRASX6")
		DbGotop()
		While !Eof()

			aSX6Cpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSX6Cpo,VIRASX6->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSX6,aSX6Cpo)

			DbSelectArea("VIRASX6")
			DbSkip()
		End

		DbCloseArea()

		oProcess:SetRegua2( Len( aSX6 ) )

		dbSelectArea( 'SX6' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSX6 )
			lContinua := .T.
			lReclock  := .T.

			If SX6->( dbSeek( PadR( aSX6[nI][1], LEN(cFilAnt) ) + PadR( aSX6[nI][2], Len( SX6->X6_VAR) ) ) )
				lReclock  := .F.

				If StrTran( SX6->X6_CONTEUD, ' ', '' ) <> StrTran( aSX6[nI][13], ' ', '' )
					lContinua :=  ApMsgNoYes( 'O parâmetro ' + aSX6[nI][2] + ' está com o conteúdo' + CRLF + ;
					'[' + RTrim( StrTran( SX6->X6_CONTEUD, ' ', '' ) ) + ']' + CRLF + ;
					', que é será substituido pelo NOVO conteúdo ' + CRLF + ;
					'[' + RTrim( StrTran( aSX6[nI][13]   , ' ', ''  ) ) + ']' + CRLF + ;
					'Deseja substituir ? ', 'Confirmar substituição de conteúdo' )

					If lContinua
						cTexto += 'Foi alterado o parâmetro ' + aSX6[nI][1] + aSX6[nI][2] + ' de [' + ;
						AllTrim( SX6->X6_CONTEUD ) + ']' + ' para [' + AllTrim( aSX6[nI][13] ) + ']' + CRLF
					EndIf

				Else
					lContinua := .F.
				EndIf

			Else
				cTexto += 'Foi incluído o parâmetro ' + aSX6[nI][1] + aSX6[nI][2] + ' Conteúdo [' + AllTrim( aSX6[nI][13] ) + ']'+ CRLF

			EndIf

			If lContinua

				If !( aSX6[nI][1] $ cAlias )
					cAlias += aSX6[nI][1] + '/'
				EndIf

				RecLock( 'SX6', lReclock )
				For nJ := 1 To Len( aSX6[nI] )
					If FieldPos( aEstrut[nJ] ) > 0
						FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
					EndIf
				Next nJ
				dbCommit()
				MsUnLock()

				oProcess:IncRegua2( 'Atualizando Arquivos (SX6)...')

			EndIf

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SX6' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSX7 º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX7 - Gatilhos      ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSX7 - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSX7()
	Local aSX7      := {}
	Local aSX7Cpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX7->X7_CAMPO )
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX7' + CRLF + CRLF
	Local _x

	aEstrut := { 'X7_CAMPO', 'X7_SEQUENC', 'X7_REGRA', 'X7_CDOMIN', 'X7_TIPO', 'X7_SEEK', ;
	'X7_ALIAS', 'X7_ORDEM'  , 'X7_CHAVE', 'X7_PROPRI', 'X7_CONDIC' }

	if File('sx7_virada.dtc')

		conout('SX7_VIRADA')

		DbUseArea( .T., , 'sx7_virada.dtc', 'VIRASX7', .F., .F. )

		DbSelectArea("VIRASX7")
		DbGotop()
		While !Eof()

			aSX7Cpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSX7Cpo,VIRASX7->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSX7,aSX7Cpo)

			DbSelectArea("VIRASX7")
			DbSkip()
		End

		DbCloseArea()

		oProcess:SetRegua2( Len( aSX7 ) )

		dbSelectArea( 'SX7' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSX7 )

			If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

				If !( aSX7[nI][1] $ cAlias )
					cAlias += aSX7[nI][1] + '/'
					cTexto += 'Foi incluído o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
				EndIf

				RecLock( 'SX7', .T. )
			Else

				If !( aSX7[nI][1] $ cAlias )
					cAlias += aSX7[nI][1] + '/'
					cTexto += 'Foi alterado o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
				EndIf

				RecLock( 'SX7', .F. )
			EndIf

			For nJ := 1 To Len( aSX7[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

			//Atualiza o X3_TRIGGER
			dbSelectArea('SX3')
			SX3->(dbSetOrder(2))
			If SX3->(dbSeek(aSX7[nI][1]))
				SX3->(RecLock('SX3',.F.))
				SX3->X3_TRIGGER := 'S'
				SX3->(MsUnlock())
			EndIf

			oProcess:IncRegua2( 'Atualizando Arquivos (SX7)...')

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SX7' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSXA º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SXA - Pastas        ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSXA - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSXA()
	Local aSXA      := {}
	Local aSXACpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SXA' + CRLF + CRLF
	Local _x

	aEstrut := { 'XA_ALIAS', 'XA_ORDEM', 'XA_DESCRIC', 'XA_DESCSPA', 'XA_DESCENG', 'XA_PROPRI' }

	if File('sxa_virada.dtc')

		conout('SXa_VIRADA')

		DbUseArea( .T., , 'sxa_virada.dtc', 'VIRASXA', .F., .F. )

		DbSelectArea("VIRASXA")
		DbGotop()
		While !Eof()

			aSXACpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSXACpo,VIRASXA->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSXA,aSXACpo)

			DbSelectArea("VIRASXA")
			DbSkip()
		End

		DbCloseArea()

		oProcess:SetRegua2( Len( aSXA ) )

		dbSelectArea( 'SXA' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSXA )

			If !SXA->( dbSeek( aSXA[nI][1] + aSXA[nI][2] ) )

				If !( aSXA[nI][1] $ cAlias )
					cAlias += aSXA[nI][1] + '/'
				EndIf

				RecLock( 'SXA', .T. )
				For nJ := 1 To Len( aSXA[nI] )
					If FieldPos( aEstrut[nJ] ) > 0
						FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
					EndIf
				Next nJ
				dbCommit()
				MsUnLock()

				cTexto += 'Foi incluída a pasta ' + aSXA[nI][1] + '/' + aSXA[nI][2]  + CRLF

				oProcess:IncRegua2( 'Atualizando Arquivos (SXA)...')

			EndIf

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SXA' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSXB º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SXB - Consultas Pad ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSXB - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSXB()
	Local aSXB      := {}
	Local aSXBCpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := 'Inicio da Atualizacao do SXB' + CRLF + CRLF
	Local cTexto    := ''
	Local _x

	aEstrut := { 'XB_ALIAS',  'XB_TIPO'   , 'XB_SEQ'    , 'XB_COLUNA' , ;
	'XB_DESCRI', 'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM' }

	if File('sxb_virada.dtc')

		conout('SXb_VIRADA')

		DbUseArea( .T., , 'sxb_virada.dtc', 'VIRASXB', .F., .F. )

		DbSelectArea("VIRASXB")
		DbGotop()
		While !Eof()

			aSXBCpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSXBCpo,VIRASXB->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSXB,aSXBCpo)

			DbSelectArea("VIRASXB")
			DbSkip()
		End

		DbCloseArea()

		oProcess:SetRegua2( Len( aSXB ) )

		dbSelectArea( 'SXB' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSXB )

			If !Empty( aSXB[nI][1] )

				If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

					If !( aSXB[nI][1] $ cAlias )
						cAlias += aSXB[nI][1] + '/'
						cTexto += 'Foi incluída a consulta padrão ' + aSXB[nI][1] + CRLF
					EndIf

					RecLock( 'SXB', .T. )

					For nJ := 1 To Len( aSXB[nI] )
						If !Empty( FieldName( FieldPos( aEstrut[nJ] ) ) )
							FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						EndIf
					Next nJ

					dbCommit()
					MsUnLock()

				Else

					//
					// Verifica todos os campos
					//
					For nJ := 1 To Len( aSXB[nI] )

						//
						// Se o campo estiver diferente da estrutura
						//
						If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
						StrTran( AllToChar( SXB->( FieldGet( nJ ) )  ), ' ', '' ) <> ;
						StrTran( AllToChar( aSXB[nI][nJ]             ), ' ', '' )

							If ApMsgNoyes( 'A consulta padrao ' + aSXB[nI][1] + ' está com o ' + SXB->( FieldName( nJ ) ) + ;
							' com o conteúdo' + CRLF + ;
							'[' + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
							', e este é diferente do conteúdo' + CRLF + ;
							'[' + RTrim( AllToChar( aSXB[nI][nJ] ) ) + ']' + CRLF +;
							'Deseja substituir ? ', 'Confirma substituição de conteúdo' )

								RecLock( 'SXB', .F. )
								FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
								dbCommit()
								MsUnLock()

								If !( aSXB[nI][1] $ cAlias )
									cAlias += aSXB[nI][1] + '/'
									cTexto += 'Foi Alterada a consulta padrao ' + aSXB[nI][1] + CRLF
								EndIf

							EndIf

						EndIf

					Next

				EndIf

			EndIf

			oProcess:IncRegua2( 'Atualizando Consultas Padroes (SXB)...' )

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SXB' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ FSAtuSX5 º Autor ³ Microsiga          º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX5 - Indices       ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSX5 - V.3.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSAtuSX5()
	Local cTexto    := 'Inicio Atualizacao SX5' + CRLF + CRLF
	Local cAlias    := ''
	Local aSX5      := {}
	Local aSX5Cpo   := {}
	Local aEstrut   := {}
	Local nI        := 0
	Local nJ        := 0
	Local _x

	aEstrut := { 'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE', 'X5_DESCRI', 'X5_DESCSPA', 'X5_DESCENG' }

	if File('sx5_virada.dtc')

		conout('SX5_VIRADA')

		DbUseArea( .T., , 'sx5_virada.dtc', 'VIRASX5', .F., .F. )

		DbSelectArea("VIRASX5")
		DbGotop()
		While !Eof()

			aSX5Cpo := {}

			For _x := 1 To Len(aEstrut)

				aadd(aSX5Cpo,VIRASX5->( FieldGet(FieldPos(aEstrut[_x]))) )

			Next _x

			aadd(aSX5,aSX5Cpo)

			DbSelectArea("VIRASX5")
			DbSkip()
		End

		DbCloseArea()

		//
		// Atualizando dicionário
		//
		oProcess:SetRegua2( Len( aSX5 ) )

		dbSelectArea( 'SX5' )
		SX5->( dbSetOrder( 1 ) )

		For nI := 1 To Len( aSX5 )

			oProcess:IncRegua2( 'Atualizando tabelas...' )

			If !SX5->( dbSeek( aSX5[nI][1] + aSX5[nI][2] + aSX5[nI][3]) )
				cTexto += 'Item da tabela criado. Tabela '   + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
				RecLock( 'SX5', .T. )
			Else
				cTexto += 'Item da tabela alterado. Tabela ' + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
				RecLock( 'SX5', .F. )
			EndIf

			For nJ := 1 To Len( aSX5[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
				EndIf
			Next nJ

			MsUnLock()

			//addUpd(aSX5[nI][1])

			If !( aSX5[nI][1] $ cAlias )
				cAlias += aSX5[nI][1] + '/'
			EndIf

		Next nI

	endif

	cTexto += CRLF + 'Final da Atualizacao do SX5' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto

Static Function addUpd(cAlias)

	if !Empty(cAlias) .and. aScan(aArqUpd,{|x| AllTrim(x) == AllTrim(cAlias)}) <= 0
		aadd(aArqUpd,Alltrim(cAlias))
	endif

Return
