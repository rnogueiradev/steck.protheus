//#INCLUDE "updacd01.ch"
#INCLUDE 'PROTHEUS.CH'
#Include "FILEIO.CH"
#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 ) 

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ UPDACD01 ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de update dos dicion·rios para compatibilizaÁ„o     ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ UPDACD01                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function UPD10PC3()

	Local   aSay     := {}
	Local   aButton  := {}
	Local   aMarcadas:= {}
	Local   cTitulo  := 'ATUALIZA«√O DE DICION¡RIOS E TABELAS'
	Local   cDesc1   := 'Esta rotina tem como funÁ„o fazer  a atualizaÁ„o  dos dicion·rios do Sistema ( SX?/SIX )'
	Local   cDesc2   := 'Este processo deve ser executado em modo EXCLUSIVO, ou seja n„o podem haver outros'
	Local   cDesc3   := 'usu·rios  ou  jobs utilizando  o sistema.  … extremamente recomend·vel  que  se  faÁa um'
	Local   cDesc4   := 'BACKUP  dos DICION¡RIOS  e da  BASE DE DADOS antes desta atualizaÁ„o, para que em caso '
	Local   cDesc5   := 'de eventuais falhas, o backup possa ser restaurado'
	Local   cDesc6   := ''
	Local   cDesc7   := ''
	Local   lOk      := .F.

	Private oMainWnd  := NIL
	Private oProcess  := NIL
	/*
	TABELA QUE SERA UTILIZADA PELA ROTINA
	*/
	Private cTabPad		:= 'PC3'

	#IFDEF TOP
	TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
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

	FormBatch(  cTitulo,  aSay,  aButton )

	If lOk
		aMarcadas := EscEmpresa()

		If !Empty( aMarcadas )
			If  ApMsgNoYes( 'Confirma a atualizaÁ„o dos dicion·rios ?', cTitulo ) //'Confirma a atualizaÁ„o dos dicion·rios ?'
				oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. ) //'Atualizando'###'Aguarde, atualizando ...'
				oProcess:Activate()

				If lOk
					Final( 'AtualizaÁ„o ConcluÌda.' ) //'AtualizaÁ„o ConcluÌda.'
				Else
					Final( 'AtualizaÁ„o n„o Realizada.' ) //'AtualizaÁ„o n„o Realizada.'
				EndIf

			Else
				Final( 'AtualizaÁ„o n„o Realizada.' ) //'AtualizaÁ„o n„o Realizada.'

			EndIf

		Else
			Final( 'AtualizaÁ„o n„o Realizada.' ) //'AtualizaÁ„o n„o Realizada.'

		EndIf

	EndIf

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSTProc  ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravaÁ„o dos arquivos           ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSTProc                                                    ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function FSTProc( lEnd, aMarcadas )
	Local   cTexto    := ''
	Local   cFile     := ''
	Local   cFileLog  := ''
	Local   cAux      := ''
	Local   cFileSys  := CriaTrab( , .F. )
	Local   cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
	Local   nRecno    := 0
	Local   nI        := 0
	Local   nX        := 0
	Local   nPos      := 0
	Local   aRecnoSM0 := {}
	Local   aInfo     := {}
	Local   aTextos   := {}
	Local   lOpen     := .F.
	Local   lRet      := .T.
	Local   oDlg      := NIL
	Local   oMemo     := NIL
	Local   oFont     := NIL
	Local   cTopBuild := ''
	Local   cTCBuild  := 'TCGetBuild'

	//Private   aTextos   := {}

	Private aArqUpd   := {}

	If ( lOpen := MyOpenSm0Ex() )

		dbSelectArea( 'SM0' )
		dbGoTop()

		While !SM0->( EOF() )
			// So adiciona no aRecnoSM0 se a empresa for diferente
			If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
			.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
				aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
			EndIf
			SM0->( dbSkip() )
		End

		If lOpen

			For nI := 1 To Len( aRecnoSM0 )

				SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

				RpcSetType( 2 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

				lMsFinalAuto := .F.
				lMsHelpAuto  := .F.

				cTexto += Replicate( '-', 128 ) + CRLF
				cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF

				oProcess:SetRegua1( 8 )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX1         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( 'Dicion·rio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de arquivos - '
				//AtuSx1ACD( @aTextos)

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX2         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				oProcess:IncRegua1( 'Dicion·rio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de arquivos - '
				AtuSX2ACD( @aTextos, nI )
				AjustaSX2()

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX3         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				AtuSX3ACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SIX         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				oProcess:IncRegua1( 'Dicion·rio de Ìndices - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de Ìndices - '
				AtuSIXACD( @aTextos, nI )

				oProcess:IncRegua1( 'Dicion·rio de dados - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de dados - '
				oProcess:IncRegua2( 'Atualizando campos/Ìndices') //'Atualizando campos/Ìndices'


				// Alteracao fisica dos arquivos
				__SetX31Mode( .F. )

				If FindFunction(cTCBuild)
					cTopBuild := &cTCBuild.()
				EndIf

				For nX := 1 To Len( aArqUpd )

					If cTopBuild >= '20090811' .AND. TcInternal( 89 ) == 'CLOB_SUPPORTED'
						If ( ( aArqUpd[nX] >= 'NQ ' .AND. aArqUpd[nX] <= 'NZZ' ) .OR. ( aArqUpd[nX] >= 'O0 ' .AND. aArqUpd[nX] <= 'NZZ' ) ) .AND.;
						!aArqUpd[nX] $ 'NQD,NQF,NQP,NQT'
							TcInternal( 25, 'CLOB' )
						EndIf
					EndIf

					If Select( aArqUpd[nX] ) > 0
						dbSelectArea( aArqUpd[nX] )
						dbCloseArea()
					EndIf

					X31UpdTable( aArqUpd[nX] )

					If __GetX31Error()
						Alert( __GetX31Trace() )
						ApMsgStop( 'Ocorreu um erro desconhecido durante a atualizaÁ„o da tabela : ' + aArqUpd[nX] + 'Verifique a integridade do dicion·rio e da tabela.', 'ATEN«√O' ) //'Ocorreu um erro desconhecido durante a atualizaÁ„o da tabela : '###'. Verifique a integridade do dicion·rio e da tabela.'###'ATEN«√O'
						cTexto += 'Ocorreu um erro desconhecido durante a atualizaÁ„o da estrutura da tabela : ' + aArqUpd[nX] + CRLF //'Ocorreu um erro desconhecido durante a atualizaÁ„o da estrutura da tabela : '
					EndIf

					If cTopBuild >= '20090811' .AND. TcInternal( 89 ) == 'CLOB_SUPPORTED'
						TcInternal( 25, 'OFF' )
					EndIf

				Next nX

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX6         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( "Dicion·rio de par‚metros -" + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de par‚metros - '
				//AtuSX6ACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX7         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( STR0022 + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de gatilhos - '
				//AtuSX7ACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SXA         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( STR0023 + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de pastas - '
				//AtuSXAACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SXB         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( 'Dicion·rio de consultas padr„o -' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de consultas padr„o - '
				//AtuSXBACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX5         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( STR0025  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de tabelas sistema - '
				//AtuSX5ACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza o dicion·rio SX9         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( STR0026  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Dicion·rio de relacionamentos - '
				//AtuSX9ACD( @aTextos, nI )

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Atualiza os helps                 ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//oProcess:IncRegua1( STR0027  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' ) //'Helps de Campo - '
				//AtuHlpACD( @aTextos, nI )

				RpcClearEnv()

				If !( lOpen := MyOpenSm0Ex() )
					Exit
				EndIf

			Next nI

			If lOpen

				cAux += Replicate( '-', 128 ) + CRLF
				cAux += Replicate( ' ', 128 ) + CRLF
				cAux += 'LOG DA ATUALIZACAO DOS DICION¡RIOS' + CRLF //'LOG DA ATUALIZACAO DOS DICION¡RIOS'
				cAux += Replicate( ' ', 128 ) + CRLF
				cAux += Replicate( '-', 128 ) + CRLF
				cAux += CRLF
				cAux += ' Dados Ambiente'        + CRLF
				cAux += ' --------------------'  + CRLF
				cAux += ' Empresa / Filial...: ' + cEmpAnt + '/' + cFilAnt  + CRLF
				cAux += ' Nome Empresa.......: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_NOMECOM', cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
				cAux += ' Nome Filial........: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_FILIAL' , cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
				cAux += ' DataBase...........: ' + DtoC( dDataBase )  + CRLF
				cAux += ' Data / Hora........: ' + DtoC( Date() ) + ' / ' + Time()  + CRLF
				cAux += ' Environment........: ' + GetEnvServer()  + CRLF
				cAux += ' StartPath..........: ' + GetSrvProfString( 'StartPath', '' )  + CRLF
				cAux += ' RootPath...........: ' + GetSrvProfString( 'RootPath', '' )  + CRLF
				cAux += ' Versao.............: ' + CRLF
				cAux += ' Modulo.............: ' + CRLF
				cAux += ' Usuario Microsiga..: ' + __cUserId + ' ' +  cUserName + CRLF
				cAux += ' Computer Name......: ' + GetComputerName()  + CRLF

				aInfo   := GetUserInfo()
				If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
					cAux += ' '  + CRLF
					cAux += ' Dados Thread' + CRLF
					cAux += ' --------------------'  + CRLF
					cAux += ' Usuario da Rede....: ' + aInfo[nPos][1] + CRLF
					cAux += ' Estacao............: ' + aInfo[nPos][2] + CRLF
					cAux += ' Programa Inicial...: ' + aInfo[nPos][5] + CRLF
					cAux += ' Environment........: ' + aInfo[nPos][6] + CRLF
					cAux += ' Conexao............: ' + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), '' ), Chr( 10 ), '' ) )  + CRLF
				EndIf
				cAux += Replicate( '-', 128 ) + CRLF
				cAux += CRLF

				For nI := 1 To Len(aTextos)
					aTextos[nI] := cAux + aTextos[nI]
				Next nI	

				AtuLogFile(cFileSys + '.log',"",aTextos)

				Define Font oFont Name 'Mono AS' Size 5, 12

				Define MsDialog oDlg Title 'Atualizacao concluida.' From 3, 0 to 340, 417 Pixel //'Atualizacao concluida.'

				@ 5, 5 Get oMemo Var MemoRead(cFileSys + '.log') Memo Size 200, 145 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont

				Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
				Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, '' ), If( cFile == '', .T., ;
				AtuLogFile(cFile, MemoRead(cFileSys + '.log')) ) ) Enable Of oDlg Pixel // Salva e Apaga //'Salvar Como...'

				Activate MsDialog oDlg Center

			EndIf

		EndIf

	Else

		lRet := .F.

	EndIf

Return lRet


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX2ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX2 - Arquivos       ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX2ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function AtuSX2ACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSX2      := {}
	Local cAlias    := ''
	Local cEmpr     := ''
	Local cPath     := ''
	Local nI        := 0
	Local nJ        := 0

	Local cTexto  := 'Inicio da Atualizacao do SX2' + CRLF + CRLF //'Inicio da Atualizacao do SX2'

	aEstrut := { 'X2_CHAVE', 'X2_PATH', 'X2_ARQUIVO', 'X2_NOME', 'X2_NOMESPA', 'X2_NOMEENG', 'X2_DELET', ;
	'X2_MODO' , 'X2_MODOUN','X2_MODOEMP','X2_TTS' , 'X2_ROTINA' , 'X2_PYME', 'X2_UNICO'  , 'X2_MODULO' }

	dbSelectArea( 'SX2' )
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbGoTop() )
	cPath := SX2->X2_PATH
	cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

	//
	// Tabela CB0
	//
	aAdd( aSX2, { ;
	cTabPad																	, ; //X2_CHAVE
	cPath																			, ; //X2_PATH
	cTabPad+cEmpr															, ; //X2_ARQUIVO
	'Reg Alt SG1'																, ; //X2_NOME
	'Reg Alt SG1'																, ; //X2_NOMESPA
	'Reg Alt SG1'																, ; //X2_NOMEENG
	0																				, ; //X2_DELET
	'E'																				, ; //X2_MODO
	'E'																				, ; //X2_MODOUN
	'E'																				, ; //X2_MODOEM
	'N'																			, ; //X2_TTS
	''																				, ; //X2_ROTINA
	''																				, ; //X2_PYME
	''														, ; //X2_UNICO
	0																				} ) //X2_MODULO


	//
	// Atualizando dicion·rio
	//
	oProcess:SetRegua2( Len( aSX2 ) )

	dbSelectArea( 'SX2' )
	dbSetOrder( 1 )

	For nI := 1 To Len( aSX2 )

		oProcess:IncRegua2( 'Atualizando Arquivos (SX2)...')

		If !SX2->( dbSeek( aSX2[nI][1] ) )

			If !( aSX2[nI][1] $ cAlias )
				cAlias += aSX2[nI][1] + '/'
				cTexto += 'Foi incluÌda a tabela ' + aSX2[nI][1] + '/' + aSX2[nI][4] + CRLF
			EndIf

			RecLock( 'SX2', .T. )
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

		Else

			If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), ' ', '' ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), ' ', '' ) )
				If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + '_UNQ', "TOPCONN"  )	// adicionado o driver TOPCONN \Ajustado
					TcInternal( 60, RetSqlName( aSX2[nI][1] ) + '|' + RetSqlName( aSX2[nI][1] ) + '_UNQ' )
					cTexto += 'Foi alterada chave unica da tabela ' + aSX2[nI][1] + '/' + aSX2[nI][4] + CRLF
				Else
					cTexto += 'Foi criada   chave unica da tabela ' + aSX2[nI][1] + '/' + aSX2[nI][4] + CRLF
				EndIf
			EndIf

		EndIf

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SX2' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aAdd(aTextos,cTexto)

Return aClone( aSX2 )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX3ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX3 - Campos         ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX3ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSX3ACD( aTextos, nEmp )
	Local aEstrut   	:= {}
	Local aSX3      	:= {}
	Local cAlias    	:= ''
	Local cAliasAtu 	:= ''
	Local cMsg      	:= ''
	Local cSeqAtu   	:= ''
	Local lTodosNao 	:= .F.
	Local lTodosSim 	:= .F.
	Local nI        	:= 0
	Local nJ        	:= 0
	Local nOpcA     	:= 0
	Local nPosArq   	:= 0
	Local nPosCpo   	:= 0
	Local nPosOrd   	:= 0
	Local nPosSXG   	:= 0
	Local nPosTam   	:= 0
	Local nSeqAtu  	 	:= 0
	Local nTamSeek  	:= Len( SX3->X3_CAMPO )
	Local nTamFilial	:= 2
	Local nTamCliFor    := 6
	Local nTamLojaclifor:= 2
	Local nTamCC        := 9
	Local nTamDoc       := 6
	Local nTamArm       := 2
	Local nTamProd      := 15
	Local nB1_COD       := TamSX3("B1_COD")[1]
	Local cOrdem		:=	'01'

	Local cTexto  := 'Inicio da Atualizacao do SX3' + CRLF + CRLF

	aEstrut := { 'X3_ARQUIVO', 'X3_ORDEM'  , 'X3_CAMPO'  , 'X3_TIPO'   , 'X3_TAMANHO', 'X3_DECIMAL', ;
	'X3_TITULO' , 'X3_TITSPA' , 'X3_TITENG' , 'X3_DESCRIC', 'X3_DESCSPA', 'X3_DESCENG', ;
	'X3_PICTURE', 'X3_VALID'  , 'X3_USADO'  , 'X3_RELACAO', 'X3_F3'     , 'X3_NIVEL'  , ;
	'X3_RESERV' , 'X3_CHECK'  , 'X3_TRIGGER', 'X3_PROPRI' , 'X3_BROWSE' , 'X3_VISUAL' , ;
	'X3_CONTEXT', 'X3_OBRIGAT', 'X3_VLDUSER', 'X3_CBOX'   , 'X3_CBOXSPA', 'X3_CBOXENG', ;
	'X3_PICTVAR', 'X3_WHEN'   , 'X3_INIBRW' , 'X3_GRPSXG' , 'X3_FOLDER' , 'X3_PYME'   }

	//
	// Tabela CB0
	//   

	// Atualiza o tamanho do Codigo Cliente/Fornecedor de acordo com o arquivo SXG
	If SXG->(DbSeek("001"))
		nTamCliFor:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho da Loja Cliente/Fornecedor de acordo com o arquivo SXG
	If SXG->(DbSeek("002"))
		nTamLojaclifor:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho do Centro de Custo de acordo com o arquivo SXG
	If SXG->(DbSeek("004"))
		nTamCC:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho do Documento de entrada/saida de acordo com o arquivo SXG
	If SXG->(DbSeek("018"))
		nTamDoc:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho do Cædigo de Armaz⁄m de acordo com o arquivo SXG
	If SXG->(DbSeek("024"))
		nTamArm:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho do Produto de acordo com o arquivo SXG
	If SXG->(DbSeek("030"))
		nTamProd:= SXG->XG_SIZE
	EndIf
	// Atualiza o tamanho da filial de acordo com o arquivo SXG
	If SXG->(DbSeek("033"))
		nTamFilial:= SXG->XG_SIZE
	EndIf

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_FILIAL'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	nTamFilial																, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial'																, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_COD'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("G1_COD")[1]																			, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'															, ; //X3_TITULO
	'Codigo'															, ; //X3_TITSPA
	'Codigo'															, ; //X3_TITENG
	'Codigo'															, ; //X3_DESCRIC
	'Codigo'															, ; //X3_DESCSPA
	'Codigo'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)											, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	' '																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_COMP'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("G1_COD")[1]																			, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Componente'																, ; //X3_TITULO
	'Componente'																, ; //X3_TITSPA
	'Componente'																, ; //X3_TITENG
	'Componente'																, ; //X3_DESCRIC
	'Componente'																, ; //X3_DESCSPA
	'Componente'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	''														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_QUANT'												, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	TamSX3("G1_QUANT")[1]																		, ; //X3_TAMANHO
	TamSX3("G1_QUANT")[2]																		, ; //X3_DECIMAL
	'Quantidade'																, ; //X3_TITULO
	'Quantidade'																, ; //X3_TITSPA
	'Quantidade'																, ; //X3_TITENG
	'Quantidade'																, ; //X3_DESCRIC
	'Quantidade'																, ; //X3_DESCSPA
	'Quantidade'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	''														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''													, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_DTALT'														, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	08																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt.Alteracao'																, ; //X3_TITULO
	'Dt.Alteracao'																, ; //X3_TITSPA
	'Dt.Alteracao'																, ; //X3_TITENG
	'Dt.Alteracao'																, ; //X3_DESCRIC
	'Dt.Alteracao'																, ; //X3_DESCSPA
	'Dt.Alteracao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(131) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_HORA'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	05																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora'																, ; //X3_TITULO
	'Hora'																, ; //X3_TITSPA
	'Hora'																, ; //X3_TITENG
	'Hora'																, ; //X3_DESCRIC
	'Hora'																, ; //X3_DESCSPA
	'Hora'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(131) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	/*
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176) Obrigatorio
	*/

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_USRALT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Usuario'															, ; //X3_TITULO
	'Usuario'															, ; //X3_TITSPA
	'Usuario'															, ; //X3_TITENG
	'Usuario'															, ; //X3_DESCRIC
	'Usuario'															, ; //X3_DESCSPA
	'Usuario'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	/*cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_FORCLI'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("A2_COD")[1]														, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'For/Cli'																, ; //X3_TITULO
	'For/Cli'																, ; //X3_TITSPA
	'For/Cli'																, ; //X3_TITENG
	'For/Cli'																, ; //X3_DESCRIC
	'For/Cli'																, ; //X3_DESCSPA
	'For/Cli'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_LOJA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("A2_LOJA")[1]													, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Loja'																	, ; //X3_TITULO
	'Loja'																	, ; //X3_TITSPA
	'Loja'																	, ; //X3_TITENG
	'Loja'																	, ; //X3_DESCRIC
	'Loja'																	, ; //X3_DESCSPA
	'Loja'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_NOME'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("A2_NOME")[1]													, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome'																	, ; //X3_TITULO
	'Nome'																	, ; //X3_TITSPA
	'Nome'																	, ; //X3_TITENG
	'Nome'																	, ; //X3_DESCRIC
	'Nome'																	, ; //X3_DESCSPA
	'Nome'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_DOC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	09																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Documento'																, ; //X3_TITULO
	'Documento'																, ; //X3_TITSPA
	'Documento'																, ; //X3_TITENG
	'Documento'																, ; //X3_DESCRIC
	'Documento'																, ; //X3_DESCSPA
	'Documento'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_SERIE'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	03																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Serie'																	, ; //X3_TITULO
	'Serie'																	, ; //X3_TITSPA
	'Serie'																	, ; //X3_TITENG
	'Serie'																	, ; //X3_DESCRIC
	'Serie'																	, ; //X3_DESCSPA
	'Serie'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_TIPO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	01																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo Doc'																, ; //X3_TITULO
	'Tipo Doc'																, ; //X3_TITSPA
	'Tipo Doc'																, ; //X3_TITENG
	'Tipo Doc'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_VALOR'														, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	TamSX3("F1_VALBRUT")[1]													, ; //X3_TAMANHO
	TamSX3("F1_VALBRUT")[2]													, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	'Valor'																	, ; //X3_TITSPA
	'Valor'																	, ; //X3_TITENG
	'Valor'																	, ; //X3_DESCRIC
	'Valor'																	, ; //X3_DESCSPA
	'Valor'																	, ; //X3_DESCENG
	PesqPict("SF1","F1_VALBRUT")											, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_CNPJ'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("A1_CGC")[1]														, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'CNPJ'																	, ; //X3_TITULO
	'CNPJ'																	, ; //X3_TITSPA
	'CNPJ'																	, ; //X3_TITENG
	'CNPJ'																	, ; //X3_DESCRIC
	'CNPJ'																	, ; //X3_DESCSPA
	'CNPJ'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_CHAVE'														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	TamSX3("F2_CHVNFE")[1]													, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Chave'																	, ; //X3_TITULO
	'Chave'																	, ; //X3_TITSPA
	'Chave'																	, ; //X3_TITENG
	'Chave'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_NSU'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod NSU'																, ; //X3_TITULO
	'Cod NSU'																, ; //X3_TITSPA
	'Cod NSU'																, ; //X3_TITENG
	'Cod NSU'																, ; //X3_DESCRIC
	'Cod NSU'																, ; //X3_DESCSPA
	'Cod NSU'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	' '																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_XML'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'XML'																	, ; //X3_TITULO
	'XML'																	, ; //X3_TITSPA
	'XML'																	, ; //X3_TITENG
	'XML Doc'																, ; //X3_DESCRIC
	'XML Doc'																, ; //X3_DESCSPA
	'XML Doc'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ;	//CBOX
	''																		, ;	//CBOX SPA
	''																		, ;	//CBOX ENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

	cOrdem:=Soma1(cOrdem)

	aAdd( aSX3, { ;
	cTabPad																	, ; //X3_ARQUIVO
	cOrdem																	, ; //X3_ORDEM
	cTabPad+'_OK'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'OK'																	, ; //X3_TITULO
	'OK'																	, ; //X3_TITSPA
	'OK'																	, ; //X3_TITENG
	'OK'																	, ; //X3_DESCRIC
	'OK'																	, ; //X3_DESCSPA
	'OK'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(146) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'S'																		, ; //X3_VISUAL
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
	'1'																		, ; //X3_FOLDER
	''																		} ) //X3_PYME*/

	//
	// Atualizando dicion·rio
	//

	nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ARQUIVO' } )
	nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ORDEM'   } )
	nPosTit := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_TITULO'  } )
	nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_CAMPO'   } )
	nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_TAMANHO' } )
	nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_GRPSXG'  } )

	aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

	oProcess:SetRegua2( Len( aSX3 ) )

	dbSelectArea( 'SX3' )
	dbSetOrder( 2 )

	// - Verifica se o Campo B1_CODBAR possui grupo 
	If SX3->(dbSeek("B1_CODBAR")) .And. (SX3->X3_GRPSXG <> "030" .Or. SX3->X3_TAMANHO <> nB1_COD)
		/* Removido\Ajustado - N„o executa mais RecLok na X3 
		RecLock("SX3")
		Replace X3_GRPSXG WITH "030"
		If SX3->X3_TAMANHO <> nB1_COD         	
			Replace X3_TAMANHO WITH nB1_COD
			Aadd(aSX3,{"SB1"})
		EndIf
		dbCommit()    */
	EndIf 

	cAliasAtu := ''

	For nI := 1 To Len( aSX3 )

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( aSX3[nI][nPosSXG] )
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto += 'O tamanho do campo ' + aSX3[nI][nPosCpo] +'/'+ aSX3[nI][nPosTit] + ' nao atualizado e foi mantido em ['
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + ']'+ CRLF
					cTexto += '   por pertencer ao grupo de campos [' + SX3->X3_GRPSXG + ']' + CRLF + CRLF
				EndIf
			EndIf
		EndIf

		SX3->( dbSetOrder( 2 ) )

		If !( aSX3[nI][nPosArq] $ cAlias )
			cAlias += aSX3[nI][nPosArq] + '/'
			aAdd( aArqUpd, aSX3[nI][nPosArq] )
		EndIf

		If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

			//
			// Busca ultima ocorrencia do alias
			//
			If ( aSX3[nI][nPosArq] <> cAliasAtu )
				cSeqAtu   := '00'
				cAliasAtu := aSX3[nI][nPosArq]

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

			cTexto += 'Criado o campo ' + aSX3[nI][nPosCpo] +'/'+ aSX3[nI][nPosTit] + CRLF

		Else

			//
			// Verifica se o campo faz parte de um grupo e ajsuta tamanho
			//
			If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
				SXG->( dbSetOrder( 1 ) )
				If SXG->( MSSeek( SX3->X3_GRPSXG ) )
					If aSX3[nI][nPosTam] <> SXG->XG_SIZE
						aSX3[nI][nPosTam] := SXG->XG_SIZE
						cTexto += 'O tamanho do campo ' + aSX3[nI][nPosCpo] +'/'+ aSX3[nI][nPosTit] + ' nao atualizado e foi mantido em ['
						cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + ']'+ CRLF
						cTexto += '   por pertencer ao grupo de campos [' + SX3->X3_GRPSXG + ']' + CRLF + CRLF
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
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), ' ', '' ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , ' ', '' ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> 'X3_ORDEM'

					cMsg := 'O campo ' + aSX3[nI][nPosCpo] + ' est· com o ' + SX3->( FieldName( nJ ) ) + ;
					' com o conte˙do' + CRLF + ;
					'[' + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
					'que ser· substituido pelo NOVO conte˙do' + CRLF + ;
					'[' + RTrim( AllToChar( aSX3[nI][nJ] ) ) + ']' + CRLF + ;
					'Deseja substituir ? '

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( 'ATUALIZA«√O DE DICION¡RIOS E TABELAS', cMsg, { 'Sim', 'N„o', 'Sim p/Todos', 'N„o p/Todos' }, 3,'DiferenÁa de conte˙do - SX3' )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := ApMsgNoYes( 'Foi selecionada a opÁ„o de REALIZAR TODAS alteraÁıes no SX3 e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma a aÁ„o [Sim p/Todos] ?' )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := ApMsgNoYes( 'Foi selecionada a opÁ„o de N√O REALIZAR nenhuma alteraÁ„o no SX3 que esteja diferente da base e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma esta aÁ„o [N„o p/Todos]?' )
						EndIf

					EndIf

					If nOpcA == 1
						cTexto += 'Alterado o campo ' + aSX3[nI][nPosCpo] + CRLF
						cTexto += '   ' + PadR( SX3->( FieldName( nJ ) ), 10 ) + ' de [' + AllToChar( SX3->( FieldGet( nJ ) ) ) + ']' + CRLF
						cTexto += '            para [' + AllToChar( aSX3[nI][nJ] )          + ']' + CRLF + CRLF

						RecLock( 'SX3', .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
						dbCommit()
						MsUnLock()

					EndIf

				EndIf

			Next

		EndIf

		oProcess:IncRegua2( 'Atualizando Campos de Tabelas (SX3)...' )

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SX3' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	//aTextos[nEmp] := aTextos[nEmp] + cTexto
	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSX3 )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSIXACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SIX - Indices       ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSIXACD                                                  ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSIXACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSIX      := {}
	Local lAlt      := .F.
	Local lDelInd   := .F.
	Local nI        := 0
	Local nJ        := 0

	Local cTexto    := 'Inicio da Atualizacao do SIX' + CRLF + CRLF

	aEstrut := { 'INDICE' , 'ORDEM' , 'CHAVE', 'DESCRICAO', 'DESCSPA'  , ;
	'DESCENG', 'PROPRI', 'F3'   , 'NICKNAME' , 'SHOWPESQ' }

	//
	// Tabela CB0
	//
	aAdd( aSIX, { ;
	cTabPad																	, ; //INDICE
	'1'																		, ; //ORDEM
	cTabPad+'_FILIAL+'+cTabPad+'_COD+'+cTabPad+'_COMP'										, ; //CHAVE
	'Chave'																	, ; //DESCRICAO
	'Chave'																	, ; //DESCSPA
	'Chave'																	, ; //DESCENG
	''																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	/*
	aAdd( aSIX, { ;
	cTabPad																	, ; //INDICE
	'2'																		, ; //ORDEM
	cTabPad+'_FILIAL+'+cTabPad+'_NSU'										, ; //CHAVE
	'NSU'																	, ; //DESCRICAO
	'NSU'																	, ; //DESCSPA
	'NSU'																	, ; //DESCENG
	''																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

	aAdd( aSIX, { ;
	cTabPad																	, ; //INDICE
	'3'																		, ; //ORDEM
	cTabPad+'_FILIAL+'+cTabPad+'_CNPJ'										, ; //CHAVE
	'CNPJ'																	, ; //DESCRICAO
	'CNPJ'																	, ; //DESCSPA
	'CNPJ'																	, ; //DESCENG
	''																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
	*/
	//
	// Atualizando dicion·rio
	//
	oProcess:SetRegua2( Len( aSIX ) )

	dbSelectArea( 'SIX' )
	SIX->( dbSetOrder( 1 ) )

	For nI := 1 To Len( aSIX )

		lAlt := .F.

		If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
			RecLock( 'SIX', .T. )
			lDelInd := .F.
			cTexto += 'Õndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
		Else
			lAlt := .F.
			RecLock( 'SIX', .F. )
		EndIf

		If !StrTran( Upper( AllTrim( CHAVE )       ), ' ', '') == ;
		StrTran( Upper( AllTrim( aSIX[nI][3] ) ), ' ', '' )
			aAdd( aArqUpd, aSIX[nI][1] )

			If lAlt
				lDelInd := .T.  // Se for alteracao precisa apagar o indice do banco
				cTexto += 'Õndice alterado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
			EndIf

			For nJ := 1 To Len( aSIX[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
				EndIf
			Next nJ

			If lDelInd
				TcInternal( 60, RetSqlName( aSIX[nI][1] ) + '|' + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
			EndIf

		EndIf

		dbCommit()
		MsUnLock()

		oProcess:IncRegua2( 'Atualizando Ìndices...' )

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SIX' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSIX )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX6ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX6 - Par‚metros     ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX6ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSX6ACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSX6      := {}
	Local cAlias    := ''
	Local cMsg      := ''
	Local lContinua := .T.
	Local lReclock  := .T.
	Local lTodosNao := .F.
	Local lTodosSim := .F.
	Local nI        := 0
	Local nJ        := 0
	Local nOpcA     := 0
	Local nTamFil   := Len( SX6->X6_FIL )
	Local nTamVar   := Len( SX6->X6_VAR )

	Local cTexto    := 'Inicio da Atualizacao do SX6' + CRLF + CRLF

	aEstrut := { 'X6_FIL'    , 'X6_VAR'  , 'X6_TIPO'   , 'X6_DESCRIC', 'X6_DSCSPA' , 'X6_DSCENG' , 'X6_DESC1'  , 'X6_DSCSPA1',;
	'X6_DSCENG1', 'X6_DESC2', 'X6_DSCSPA2', 'X6_DSCENG2', 'X6_CONTEUD', 'X6_CONTSPA', 'X6_CONTENG', 'X6_PROPRI' , 'X6_PYME' }

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MNF_TABPAD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tabela padrao manifesto'												, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PA1'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MNF_ULTNSU'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ultimo NSU manifesto'													, ; //X6_DESCRIC
	'Ultimo NSU manifesto'													, ; //X6_DSCSPA
	'Ultimo NSU manifesto'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000000000000001'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MNF_TPAMB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ambiente Sefaz utilizado? Prod=1 / Homolog=2'							, ; //X6_DESCRIC
	'Ambiente Sefaz utilizado? Prod=1 / Homolog=2'							, ; //X6_DSCSPA
	'Ambiente Sefaz utilizado? Prod=1 / Homolog=2'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MNF_ULTPRC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data/Hora ultimo processamento AAAAMMDDHHMM'							, ; //X6_DESCRIC
	'Data/Hora ultimo processamento AAAAMMDDHHMM'							, ; //X6_DSCSPA
	'Data/Hora ultimo processamento AAAAMMDDHHMM'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	/*
	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ACDCHKS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Alias a ignorar no update para atualizar'								, ; //X6_DESCRIC
	'Alias a ignorar en el update para actualizar'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	"a estrutura, devem ser serapados por ','."								, ; //X6_DESC1
	"la estructura, deben ser separados por ','."							, ; //X6_DSCSPA1
	'update. It must be separated by `,¥.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ACDSERI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Serie da nota fiscal de saida, utilizada na'							, ; //X6_DESCRIC
	'Serie de la Factura de Salida usada en la'								, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'distribuicao de volumes.'												, ; //X6_DESC1
	'distribucion de bultos.'												, ; //X6_DSCSPA1
	'volumes distribution.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'UNI'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ACDVERS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informa a versao atual do modulo SIGAACD'								, ; //X6_DESCRIC
	'Indica la version actual del modulo SIGAACD'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'9'																		, ; //X6_CONTSPA
	'9'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ALTENDI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ajusta o endereco no inventario'										, ; //X6_DESCRIC
	'Ajusta la ubicacion en el inventario'									, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-Sim'															, ; //X6_DESC1
	'0-No 1-Si'																, ; //X6_DSCSPA1
	'0-Nao 1-Sim'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ANAINV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite a analise do inventario pelo Coletor'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'(1-Sim,2-Nao)'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ATVCONS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ativa/Desativa a consulta VT100 (CTRL+C)'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'(1-Sim,2-Nao)'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CB0ALFA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite a utilizacao de caracteres alfanumericos'						, ; //X6_DESCRIC
	'Permite la utilizacion de caracteres alfanumericos'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'na composicao do codigo interno (0-Nao,1-Sim)'							, ; //X6_DESC1
	'en la composicion del codigo interno (0-No,1-Si)'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBAJUQE'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite ao usuario ajustar a Quantidade por Embala'					, ; //X6_DESCRIC
	'Permite que el usuario ajuste la Cantidad por'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'gem na rotina de impressao de etiquetas produtos'						, ; //X6_DESC1
	'Embalaje en rutina de impresion etiq. de productos'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBARMPD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informa o codigo do armazem padrao que sera usado'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'no Envio e Retorno do Processo quando nao e utiliz'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'ado codigo interno'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBATUD4'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se deve ser feito o empenho dos lotes no'						, ; //X6_DESCRIC
	'Indica si debe hacerse reserva de lotes al inicio'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'inicio da operacao na producao PCP MOD1 e 2 do ACD'					, ; //X6_DESC1
	'de la operacion en produccion PCP MOD1 y 2 del ACD'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'1=Sim;2=Nao'															, ; //X6_DESC2
	'1=Si;2=No'																, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBCALEN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parametro onde e informado o calendario padrao que'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'deve ser utilizado'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBCFSD4'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Confere se o produto a ser requisitado pertence ao'					, ; //X6_DESCRIC
	'Verifica si el producto a solicitarse pertenece a'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'empenho da Ordem de Producao - 1=Sim; 2=Nao'							, ; //X6_DESC1
	'reserva de Orden de Produccion - 1=Si; 2=No'							, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBCFSG1'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Confere se o produto a ser requistado pertence a'						, ; //X6_DESCRIC
	'Verifica si el producto a solicitarse pertenece a'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'estrutura do PI ou PA a ser produzido'									, ; //X6_DESC1
	'estructura de PI o PA a producirse'									, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'1=Sim;2=Nao'															, ; //X6_DESC2
	'1=Si;2=No'																, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBCLABC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Ativa o controle de classificacao ABC para analise'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de mestre de invetario'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBCQEND'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco padrao para enderecamento automatico dos'						, ; //X6_DESCRIC
	'Posicion estandar para Ubicacion automatica de los'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'produtos enviados para C.Q atraves da rotina de'						, ; //X6_DESC1
	'productos enviados a C.Q. por medio de rutina'							, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'recebimento Mod2'														, ; //X6_DESC2
	'recepcion Mod2'														, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBEMPRQ'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Considera o saldo SBF com empenho na rotina de'						, ; //X6_DESCRIC
	'Considera el saldo SBF con reserva en la rutina de'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'requisicao do ACD'														, ; //X6_DESC1
	'solicitud del ACD'														, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBENDCQ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Valida os enderecos para C.Q'											, ; //X6_DESCRIC
	'Valida las ubicaciones para el C.Q.'									, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'separados por ;'														, ; //X6_DESC1
	"separados por ';'"														, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'INSPECAO'															, ; //X6_CONTEUD
	'INSPECAO'															, ; //X6_CONTSPA
	'INSPECAO'															, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBEXCNF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Exclui nota fiscal (0-Protheus, 1-RF)'									, ; //X6_DESCRIC
	'Borra Factura (0-Protheus, 1-RF)'										, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBFCQTD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Forca o foco na quantidade inventariada toda vez'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'que estiver inventariando um produto. 1-Ativado;2-'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'Desativado'															, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBINVMD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Modelo do inventario 1-contagens batidas 2-estoque'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBIXBNF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do ponto de entrada para emissao de nota'							, ; //X6_DESCRIC
	'Nombre punto de entrada para emision de Factura'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'fiscal de saida para expedicao RF'										, ; //X6_DESC1
	'de salida para despacho RF'											, ; //X6_DSCSPA1
	'issuing in RF shipment'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'NFEXAMP'																, ; //X6_CONTEUD
	'NFEXAMP'																, ; //X6_CONTSPA
	'NFEXAMP'																, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBNEWID'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Novo ID utilizando soma1 no cbproxcod'									, ; //X6_DESCRIC
	'Nuevo ID utilizando soma1 en cbproxcod'								, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBOSPRC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite ou nao gerar Ordens de Separacoes parciais'					, ; //X6_DESCRIC
	'Permite generar las ordenes de separacion parcial'						, ; //X6_DSCSPA
	'Allows generate partial orders of separation'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPAJIM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite o ajuste dos impostos antes da geracao da'						, ; //X6_DESCRIC
	'Permite ajustar impuestos antes de generar la'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Nota Fiscal de Entrada atraves da rotina de'							, ; //X6_DESC1
	'Factura de entrada por medio de la rutina'								, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'recebimento Mod2 - 1=Sim;2=Nao'										, ; //X6_DESC2
	'recepcion Mod2 - 1=Si;2=No'											, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE001'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template SF2520E'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template SF2520E'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE002'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template A140EXC'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template A140EXC'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE003'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template A175GRV'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template A175GRV'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE004'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template A250ENOK'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template A250ENOK'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE005'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template M460FIL'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template M460FIL'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE006'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template M460FIM'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template M460FIM'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE007'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MSD2460'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MSD2460'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE008'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MSD2520'							, ; //X6_DESCRIC
	'Habiliat el Punto de Entrada Template MSD2520'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE009'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT100AGR'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT100AGR'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE010'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT175ATU'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT175ATU'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE011'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT250GREST'						, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT250GREST'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE012'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT340D3'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT340D3'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE013'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT460EST'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT460EST'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE014'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT680GREST'						, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT680GREST'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE015'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MT682GREST'						, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MT682GREST'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE016'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MTA265E'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MTA265E'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE017'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MTA650E'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MTA650E'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE018'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template SD3250I'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template SD3250I'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE019'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template SF1100E'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template SF1100E'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE020'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template A100DEL'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template A100DEL'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE021'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de entrada Template MS520VLD'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MS520VLD'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE022'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de Entrada Template MTA440C9'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template MTA440C9'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPE023'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita o Ponto de Entrada Template M410ACDL'							, ; //X6_DESCRIC
	'Habilita el Punto de Entrada Template M410ACDL'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBPESO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verifica se deve informar o peso do produto no ato'					, ; //X6_DESCRIC
	'Verifica si debe informar peso de producto en la'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'do recebimento atraves da rotina de receb. Mod2'						, ; //X6_DESC1
	'recepcion por medio de la rutina de Recep. Mod2'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'1=Sim; 2=Nao'															, ; //X6_DESC2
	'1=Si; 2=No'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBREQD3'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo do movimento para requisicao da ordem de'							, ; //X6_DESCRIC
	'Tipo de movimiento para requerimiento de orden de'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'separacao para producao RF'											, ; //X6_DESC1
	'separacion para produccion RF'											, ; //X6_DSCSPA1
	'order for RF production'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'501'																	, ; //X6_CONTEUD
	'501'																	, ; //X6_CONTSPA
	'501'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBRQEST'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Considera a Estrutura do Produto x Saldo na'							, ; //X6_DESCRIC
	'Considera la Estructura del Producto x Saldo en la'					, ; //X6_DSCSPA
	'Considers the Structure of the Product x Balance'						, ; //X6_DSCENG
	'geracao da Ordem de Separacao'											, ; //X6_DESC1
	'geracao de la Orden de Separacao'										, ; //X6_DSCSPA1
	'in the generation of the Order of Separation'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBSA5'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite a pesquisa do cod.barras na rotina de rece'					, ; //X6_DESCRIC
	'Permite busqueda de cod.barras en rutina de'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'bimento do ACD atraves da amarracao produto x forn'					, ; //X6_DESC1
	'Recepcion ACD por vinculo producto vs proveedor'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'ecedor (SA5)'															, ; //X6_DESC2
	'(SA5)'																	, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBV2UM'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite a validacao da 2.a Unidade de Medida na ro'					, ; //X6_DESCRIC
	'Permite validar la 2a Unidad de Medida en la'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'tina de recebimento do ACD'											, ; //X6_DESC1
	'rutina de Recepcion de ACD'											, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBVLAPI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se deve validar a quantidade a ser apontada'					, ; //X6_DESCRIC
	'Indica si debe validar la cantidad a apuntarse'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'com a quantidade informada no inicio da operacao'						, ; //X6_DESC1
	'con cantidad informada al inicio de la operacion'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'rotina PCP MOD 1 e 2 ACD - 1=Sim;2=Nao'								, ; //X6_DESC2
	'rutina PCP MOD 1 y 2 ACD - 1=Si;2=No'									, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBVLDOS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite o Embarque simultaneo de Ordens de'							, ; //X6_DESCRIC
	'Permite el Embarque simultaneo de Ordenes de'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'separacao diferentes 1=Sim;2=Nao'										, ; //X6_DESC1
	'separacion diferentes 1=Si;2=No'										, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBVLDTR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Valida a transportadora na rotina de embarque'							, ; //X6_DESCRIC
	'Valida la transportadora en la rutina de embarque'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'1=Sim; 2=Nao'															, ; //X6_DESC1
	'1=Si; 2=No'															, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBVLPAJ'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Valor maximo permitido no ajuste dos impostos'							, ; //X6_DESCRIC
	'Valor maximo permitido en el ajuste de impuestos'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'antes da geracao da Nota Fiscal de Entrada pela'						, ; //X6_DESC1
	'antes de generar Factura de entrada por medio de'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'rotina de recebimento Mod2'											, ; //X6_DESC2
	'rutina de Recepcion Mod2'												, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0.03'																	, ; //X6_CONTEUD
	'0.03'																	, ; //X6_CONTSPA
	'0.03'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CBVQEOP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Valida a quantidade a ser iniciada com o saldo da'						, ; //X6_DESCRIC
	'Valida la cantidad a iniciarse con el saldo de la'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'operacao disponivel para o apontamento da Producao'					, ; //X6_DESC1
	'operacion disponible para apunte de la Produccion'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'e/ou perda-ACD Producao PCP MOD1 e 2 - 1=Sim;2=Nao'					, ; //X6_DESC2
	'y/o perdida-ACD Produccion PCP MOD1 y 2 -1=Si;2=No'					, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CFENDIG'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Confere endereco igual para produto diferente'							, ; //X6_DESCRIC
	'Verifica ubicacion igual para productos diferentes'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'na expedicao do RF 1-sim 0-nao'										, ; //X6_DESC1
	'en el despacho del RF 1-si 0-no'										, ; //X6_DSCSPA1
	'in RF dispatch 1-yes 0-no'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CHKQEMB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Confere quantidade de produto granel na embalagem'						, ; //X6_DESCRIC
	'Verifica cantidad de producto granel en embalaje'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'RF para codigo interno 1-sim 0-nao'									, ; //X6_DESC1
	'RF para codigo interno 1-si 0-no'										, ; //X6_DSCSPA1
	'for internal code 1-yes 0-no'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CODCB0'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo de indentificacao de codigo de barras'							, ; //X6_DESCRIC
	'Codigo de identificacion de codigo de barras'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0000000000'															, ; //X6_CONTEUD
	'0000000000'															, ; //X6_CONTSPA
	'0000000000'															, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME
	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CONFEND'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Confere o endereco na expedicao RF'									, ; //X6_DESCRIC
	'Verifica ubicacion en el despacho RF'									, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-SIM'															, ; //X6_DESC1
	'0-No 1-SI'																, ; //X6_DSCSPA1
	'0-No 1-YES'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CONFFIS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ativa no sistema a conferencia fisica'									, ; //X6_DESCRIC
	'Activa la Verificacion Fisica en el sistema'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_DIVERPV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da divergencia considerada para acerto do'						, ; //X6_DESCRIC
	'Codigo de divergencia considerada para ajuste de'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'pedido vendas da Ordem de Separacao'									, ; //X6_DESC1
	'pedido ventas de Orden de Separacion'									, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ENDPROC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco padrao para o enderecamento automatico no'					, ; //X6_DESCRIC
	'Posicion estandar para Ubicacion automatica en el'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'armazem de processos (99)'												, ; //X6_DESC1
	'deposito de procesos (99)'												, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IACD01'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do tipo de impressao usado no programa'							, ; //X6_DESCRIC
	'Codigo de tipo de impresion usado en el programa'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'expedicao, no modulo ACD, este'										, ; //X6_DESC1
	'despacho, en el modulo ACD, este'										, ; //X6_DSCSPA1
	'dispatch, module ACD. It refers to'									, ; //X6_DSCENG1
	'codigo se refere a tabela CB5.'										, ; //X6_DESC2
	'codigo se refiere a la tabla CB5.'										, ; //X6_DSCSPA2
	'table CB5.'															, ; //X6_DSCENG2
	'Z03'																	, ; //X6_CONTEUD
	'Z03'																	, ; //X6_CONTSPA
	'Z03'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IACD02'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do tipo de impressao usado no programa'							, ; //X6_DESCRIC
	'Codigo de tipo de impresion usado en el programa'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Pedido de compra e/ou recebimento de materiais'						, ; //X6_DESC1
	'de Pedido de Compra y/o Recepcion de Materiales'						, ; //X6_DSCSPA1
	'for Purchase Order and/or goods receiving'								, ; //X6_DSCENG1
	'Este codigo se refere a tabela CB5'									, ; //X6_DESC2
	'Este codigo se refiere a la tabla CB5'									, ; //X6_DSCSPA2
	'This code refers to table CB5'											, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IACD03'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do tipo de impressao usado no programa'							, ; //X6_DESCRIC
	'Codigo de tipo de impresion usado en el programa'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Identificacao de produto'											, ; //X6_DESC1
	'de Identificacion de producto'											, ; //X6_DSCSPA1
	'in product identification'												, ; //X6_DSCENG1
	'Este codigo se refere a tabela CB5'									, ; //X6_DESC2
	'Este codigo se refiere a la tabla CB5'									, ; //X6_DSCSPA2
	'This code refers to table CB5'											, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IACD04'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do tipo de impressao usado no programa'							, ; //X6_DESCRIC
	'Codigo de tipo de impresion usado en el programa'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Identificacao de produto na producao'								, ; //X6_DESC1
	'de Identificacion de producto en la produccion'						, ; //X6_DSCSPA1
	'to identificar the product in production'								, ; //X6_DSCENG1
	'Este codigo se refere a tabela CB5'									, ; //X6_DESC2
	'Este codigo se refiere a la tabla CB5'									, ; //X6_DSCSPA2
	'This code refers to table CB5'											, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IMETREQ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verifica se deve imprimir etiquetas na requisicao'						, ; //X6_DESCRIC
	'Verifica si debe imprimir etiquetas en solicitud'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'1-Sim, 2-Nao'															, ; //X6_DESC1
	'1-Si, 2-No'															, ; //X6_DSCSPA1
	'1-Sim, 2-Nao'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IMPIP'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Como imprime etiqueta de identificacao do produto'						, ; //X6_DESCRIC
	'Como imprime etiqueta de identificacion producto'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'1-Pedido 2- Recebimento 3-Nao Imprime 4 - Nota'						, ; //X6_DESC1
	'1- Pedido 2- Recepcion 3-No Imprime  4 - Factura'						, ; //X6_DSCSPA1
	'1-Order 2-Receiving 3-Do Not Print  4-Invoice'							, ; //X6_DSCENG1
	"O parametro e utilizado se o campo A2_IMPIP='0'"						, ; //X6_DESC2
	"El parametro se utiliza si el campo A2_IMPIP='0'"						, ; //X6_DSCSPA2
	'This parameter is used when A2_IMPIP=`0¥'								, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IMPIPOP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Como imprime etiqueta de identificacao do produto'						, ; //X6_DESCRIC
	'Como imprime etiqueta de identificacion producto'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-Imprime na producao'											, ; //X6_DESC1
	'0-No 1-Imprime en la produccion'										, ; //X6_DSCSPA1
	'0-No 1-Print during production'										, ; //X6_DSCENG1
	'O parametro na producao'												, ; //X6_DESC2
	'El parametro en la produccion'											, ; //X6_DSCSPA2
	'The parameter in production'											, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INFQEIN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se deve ser informada a quantidade no'							, ; //X6_DESCRIC
	'Indica si debe informarse la cantidad al inicio de'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'inicio da operacao na producao PCP MOD1 e 2 do ACD'					, ; //X6_DESC1
	'la operacion en la produccion PCP MOD1 y 2 del ACD'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'1=Sim;2=Nao'															, ; //X6_DESC2
	'1=Si;2=No'																, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INTACD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Integra ACD'															, ; //X6_DESCRIC
	'Integra ACD'															, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-SIM'															, ; //X6_DESC1
	'0-No 1-SI'																, ; //X6_DSCSPA1
	'0-Nao 1-SIM'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INVAUT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Executa o acerto automatico do Inventario'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-Coletor 2-Monitor 3-Ambos'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'0=Nao;1=Coletor;2=Monitor;3=Ambos'										, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LOGACD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Log SIGAACD'															, ; //X6_DESCRIC
	'Log SIGAACD'															, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'* Todos ou 01,02,03,04...'												, ; //X6_DESC1
	'* Todos o 01,02,03,04...'												, ; //X6_DSCSPA1
	'* Todos ou 01,02,03,04...'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'*'																		, ; //X6_CONTEUD
	'*'																		, ; //X6_CONTSPA
	'*'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MULTOPS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verifica se a requisicao aceita multiplas OPs'							, ; //X6_DESCRIC
	'Verifica si la solicitud acepta OP multiples'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'1-Sim, 2-Nao'															, ; //X6_DESC1
	'1-Si, 2-No'															, ; //X6_DSCSPA1
	'1-Sim, 2-Nao'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NLOGACD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'NoLog Sigaacd'															, ; //X6_DESCRIC
	'NoLog SIGAACD'															, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Informar o codigo do envento que nao tera o log'						, ; //X6_DESC1
	'Informe el codigo de evento que no tendra el log'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_OSEP2UN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Na Ordem de separacao o programa utiliza a 2 U.M.'						, ; //X6_DESCRIC
	'En Orden de Separacion el programa usa la 2a U.M.'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'caso a qtde a separar seja menor que a 2 U.M o'						, ; //X6_DESC1
	'si la cantidad a separar es menor que la 2a U.M.'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'sistema utilizar a 1 U.M. 0-nao utiliza 1-utiliza'						, ; //X6_DESC2
	'0-no utiliza 1-utiliza'												, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_REGVOL'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Regista volume  entrada 0-nao registra 1-registra'						, ; //X6_DESCRIC
	'Registra bulto entrada 0-no registra 1-registra'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_REMIEMB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parametro que informa se a etiqueta do produto'						, ; //X6_DESCRIC
	'Parametro que informa si la etiqueta del producto'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'sera re-emitida no processo de embalagem (ACD)'						, ; //X6_DESC1
	'se emitira de nuevo en proceso de embalaje (ACD)'						, ; //X6_DSCSPA1
	'will be re-issued in packing process (ACD)'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ROTV170'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define o ultimo processo da expedicao a ser execu-'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'tado ligado(ACDV170): 01=SEPARACAO, 2=EMBALAGEM,'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'03=GERA NFS,04=IMPR.NFS,05=IMPR.VOL,06=EMBARQUE'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01*02*03*04*05*06*'													, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SELVAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite ao usuario poder escolher a opcao para'						, ; //X6_DESCRIC
	'Permite que el usuario elija la opcion para digi-'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'digitar uma quantidade variavel (0-Nao exibe opcao'					, ; //X6_DESC1
	'tar una cantidad variable (0=No muestra opcion,'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	', 1-Exibe a opcao)'													, ; //X6_DESC2
	'1-Muestra opcion)'														, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SGQTDOP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sugere como inicializacao do get o saldo da OP'						, ; //X6_DESCRIC
	'Sugiere inicializar el get con el saldo de la OP'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a ser apontado para a operacao nas rotinas de'							, ; //X6_DESC1
	'a apuntarse para la operacion en las rutinas de'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'Producao PCP MOD1 e MOD2 do ACD - 1=Sim;2=Nao'							, ; //X6_DESC2
	'Produccion PCP MOD1 y MOD2 del ACD - 1=Si;2=No'						, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SGQTDRE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sugere como inicializacao do get da quantidade'						, ; //X6_DESCRIC
	'Sugiere como valor inicial del get de Cantidad'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'nas rotinas de requisicao/devolucao a quantidade'						, ; //X6_DESC1
	'en rutinas de solicitud/devolucion la cantidad'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'da etiqueta; 1=Sim; 2=Nao'												, ; //X6_DESC2
	'de la etiqueta 1=Si; 2=No'												, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SOLOPEA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Solicita  operador no apontamento de producao ACD'						, ; //X6_DESCRIC
	'(1-Sim, 2-Nao)'														, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMCBDP'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de movimentacao para Devolucao de Processo'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMCBRP'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de movimentacao para Requisicao de Processo'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_USUINV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do inventario mestre por usuario'								, ; //X6_DESCRIC
	'Codigo de inventario maestro por usuario'								, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000000'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VLDEVAI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Trata devolucao c/ OP p/ produto de aprop indireta'					, ; //X6_DESCRIC
	'Trata devolucion c/OP p/prod. de imputacion indir.'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'1=Aceita qtd maior que a requisitada;2=Nao aceita'						, ; //X6_DESC1
	'1=Acepta cantidad mayor que solicitada;2=No acepta'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'qtd maior que a requisitada;3=Permite escolha'							, ; //X6_DESC2
	'cantidad mayor que solicitada;3=Permite elegir'						, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VLDREQ'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verifica se valida a  quantidade a ser produzida'						, ; //X6_DESCRIC
	'Verifica si valida la cantidad a producirse con la'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'com a quantidade requisitada p/ a O.P; 1= Valida'						, ; //X6_DESC1
	'cantidad solicitada para la OP; 1=Valida en la 1a'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'na 1¶ operacao; 2= valida na ultima operacao'							, ; //X6_DESC2
	'operacion; 2=Valida en la ultima operacion'							, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VLDTINV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Bloqueio por data'														, ; //X6_DESCRIC
	'Bloqueo por fecha'														, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0-Nao 1-Sim'															, ; //X6_DESC1
	'0-No 1-Si'																, ; //X6_DSCSPA1
	'0-Nao 1-Sim'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VQTDINV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite a entrada da quantidade no inventario'							, ; //X6_DESCRIC
	'Permite la entrada de la cantidad en inventario'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'quanto utiliza CB0. (0=Nao 1=Sim)'										, ; //X6_DESC1
	'cuando utiliza CB0. (0=No 1=Si)'										, ; //X6_DSCSPA1
	'inventory when using CB0. (0=No 1=Yes)'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_EANP2'		   														, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite utilizar a segunda parte da etiqueta.'				  			, ; //X6_DESCRIC
	'Permite utilizar la segunda parte de la etiqueta'						, ; //X6_DSCSPA
	'It enables you to use the second part of the label.'					, ; //X6_DSCENG
	''									   									, ; //X6_DESC1
	''									  									, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME  

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CFEMBS'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Permite a conferÍncia da Nota Fiscal de Saida'			  				, ; //X6_DESCRIC
	'Permite a conferÍncia da Nota Fiscal de Saida'							, ; //X6_DSCSPA
	'Permite a conferÍncia da Nota Fiscal de Saida'							, ; //X6_DSCENG
	'atraves do Monitor de Embarque Simples do Protheus'					, ; //X6_DESC1
	'atravÈs do Monitor de Embarque Simples do Protheus'					, ; //X6_DSCSPA1
	'atravÈs do Monitor de Embarque Simples do Prothesu'					, ; //X6_DSCENG1
	'(1=Nao;2=Sim)'															, ; //X6_DESC2
	'(1=Nao;2=Sim)'															, ; //X6_DSCSPA2
	'(1=Nao;2=Sim)'															, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

	aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IMPAUT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Imprime etiqueta no Pedido de Compras' 								, ; //X6_DESCRIC
	'Imprime la etiqueta en la Orden de Compra'								, ; //X6_DSCSPA
	'Prints label on the Purchase Order'									, ; //X6_DSCENG
	'/Aut. de Entrega quando se utiliza rotina automatica'					, ; //X6_DESC1
	'/Aut. de entrega cuando se utiliza de rutina automatica'  				, ; //X6_DSCSPA1
	'/Aut. delivery cuando using routine automatic'			 				, ; //X6_DSCENG1
	'0-Nunca imprime 1-Pergunta 2-Sempre'							   		, ; //X6_DESC2
	'0- No imprima nunca 1-Pregunta 2-Siempre impresiones'					, ; //X6_DSCSPA2
	'0- Never print 1-Question 2-Always'									, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME
	*/

	//
	// Atualizando dicion·rio
	//
	oProcess:SetRegua2( Len( aSX6 ) )

	dbSelectArea( 'SX6' )
	dbSetOrder( 1 )

	For nI := 1 To Len( aSX6 )
		lContinua := .T.
		lReclock  := .T.

		If SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
			lReclock  := .F.

			If !StrTran( SX6->X6_CONTEUD, ' ', '' ) == StrTran( aSX6[nI][13], ' ', '' )

				cMsg := 'O par‚metro ' + aSX6[nI][2] + ' est· com o conte˙do' + CRLF + ;
				'[' + RTrim( StrTran( SX6->X6_CONTEUD, ' ', '' ) ) + ']' + CRLF + ;
				', que È ser· substituido pelo NOVO conte˙do ' + CRLF + ;
				'[' + RTrim( StrTran( aSX6[nI][13]   , ' ', '' ) ) + ']' + CRLF + ;
				'Deseja substituir ? '

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( 'ATUALIZA«√O DE DICION¡RIOS E TABELAS', cMsg, { 'Sim', 'N„o', 'Sim p/Todos', 'N„o p/Todos' }, 3,'DiferenÁa de conte˙do - SX6' )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := ApMsgNoYes( 'Foi selecionada a opÁ„o de REALIZAR TODAS alteraÁıes no SX6 e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma a aÁ„o [Sim p/Todos] ?' )
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := ApMsgNoYes( 'Foi selecionada a opÁ„o de N√O REALIZAR nenhuma alteraÁ„o no SX6 que esteja diferente da base e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma esta aÁ„o [N„o p/Todos]?' )
					EndIf

				EndIf

				lContinua := ( nOpcA == 1 )

				If lContinua
					cTexto += 'Foi alterado o par‚metro ' + aSX6[nI][1] + aSX6[nI][2] + ' de [' + ;
					AllTrim( SX6->X6_CONTEUD ) + ']' + ' para [' + AllTrim( aSX6[nI][13] ) + ']' + CRLF
				EndIf

			Else
				lContinua := .F.
			EndIf

		Else
			cTexto += 'Foi incluÌdo o par‚metro ' + aSX6[nI][1] + aSX6[nI][2] + ' Conte˙do [' + AllTrim( aSX6[nI][13] ) + ']'+ CRLF

		EndIf

		If lContinua

			If !( aSX6[nI][1] $ cAlias )
				cAlias += aSX6[nI][1] + '/'
			EndIf

			RecLock( 'SX6', lReclock)
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

	cTexto += CRLF + 'Final da Atualizacao do SX6' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSX6 )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX7ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX7 - Gatilhos       ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX7ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSX7ACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSX7      := {}
	Local cAlias    := ''
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX7->X7_CAMPO )

	Local cTexto    := 'Inicio da Atualizacao do SX7' + CRLF + CRLF

	aEstrut := { 'X7_CAMPO', 'X7_SEQUENC', 'X7_REGRA', 'X7_CDOMIN', 'X7_TIPO', 'X7_SEEK', ;
	'X7_ALIAS', 'X7_ORDEM'  , 'X7_CHAVE', 'X7_PROPRI', 'X7_CONDIC' }

	//
	// Campo CBH_OPERAC
	//
	aAdd( aSX7, { ;
	'CBH_OPERAC'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'A080DesRot(M->CBH_OP,M->CBH_OPERAC)'									, ; //X7_REGRA
	'CBH_DESOPE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	'SG2'																	, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

	//
	// Campo CBH_TRANSA
	//
	aAdd( aSX7, { ;
	'CBH_TRANSA'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CBI->CBI_TIPO'															, ; //X7_REGRA
	'CBH_TIPO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CBI'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CBI")+M->CBH_TRANSA'											, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

	aAdd( aSX7, { ;
	'CBH_TRANSA'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'CBI->CBI_DESCRI'														, ; //X7_REGRA
	'CBH_DESCRI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CBI'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CBI")+M->CBH_TRANSA'											, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

	aAdd( aSX7, { ;
	'CBH_TRANSA'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CB080DTHR()'															, ; //X7_REGRA
	'CBH_DTINI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	''																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

	//
	// Atualizando dicion·rio
	//
	oProcess:SetRegua2( Len( aSX7 ) )

	dbSelectArea( 'SX7' )
	dbSetOrder( 1 )

	For nI := 1 To Len( aSX7 )

		If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

			If !( aSX7[nI][1] $ cAlias )
				cAlias += aSX7[nI][1] + '/'
				cTexto += 'Foi incluÌdo o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
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

		oProcess:IncRegua2( 'Atualizando Arquivos (SX7)...')

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SX7' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSX7 )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSXAACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SXA - Pastas         ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSXAACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSXAACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSXA      := {}
	Local cAlias    := ''
	Local nI        := 0
	Local nJ        := 0

	Local cTexto    := 'Inicio da Atualizacao do SXA' + CRLF + CRLF

	aEstrut := { 'XA_ALIAS', 'XA_ORDEM', 'XA_DESCRIC', 'XA_DESCSPA', 'XA_DESCENG', 'XA_PROPRI' }

	//
	// Tabela CB0
	//
	aAdd( aSXA, { ;
	'PC5'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'Dados Gerais'															, ; //XA_DESCRIC
	''																		, ; //XA_DESCSPA
	''																		, ; //XA_DESCENG
	'S'																		} ) //XA_PROPRI

	aAdd( aSXA, { ;
	'PC5'																	, ; //XA_ALIAS
	'2'																		, ; //XA_ORDEM
	'Entrada'																, ; //XA_DESCRIC
	''																		, ; //XA_DESCSPA
	''																		, ; //XA_DESCENG
	'S'																		} ) //XA_PROPRI

	aAdd( aSXA, { ;
	'PC5'																	, ; //XA_ALIAS
	'3'																		, ; //XA_ORDEM
	'Saida'																	, ; //XA_DESCRIC
	''																		, ; //XA_DESCSPA
	''																		, ; //XA_DESCENG
	'S'																		} ) //XA_PROPRI

	//
	// Tabela SB5
	//
	aAdd( aSXA, { ;
	'SB5'																	, ; //XA_ALIAS
	'7'																		, ; //XA_ORDEM
	'ACD'																	, ; //XA_DESCRIC
	'ACD'																	, ; //XA_DESCSPA
	'ACD'																	, ; //XA_DESCENG
	'S'																		} ) //XA_PROPRI

	//
	// Atualizando dicion·rio
	//
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

			cTexto += 'Foi incluÌda a pasta ' + aSXA[nI][1] + '/' + aSXA[nI][2]  + CRLF

			oProcess:IncRegua2( 'Atualizando Arquivos (SXA)...')

		EndIf

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SXA' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSXA )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSXBACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SXB - Consultas Pad  ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSXBACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSXBACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSXB      := {}
	Local cMsg      := ''
	Local cAlias    := ''
	Local lTodosNao := .F.
	Local lTodosSim := .F.
	Local nI        := 0
	Local nJ        := 0
	Local nOpcA     := 0

	Local cTexto    := 'Inicio da Atualizacao do SXB' + CRLF + CRLF

	aEstrut := { 'XB_ALIAS',  'XB_TIPO'   , 'XB_SEQ'    , 'XB_COLUNA' , ;
	'XB_DESCRI', 'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM' }

	//
	// Consulta CB0
	//
	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'COD+NOME'																, ; //XB_DESCRI
	'COD+NOME'																, ; //XB_DESCSPA
	'COD+NOME'																, ; //XB_DESCENG
	'SA4'																	} ) //XB_CONTEM

	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	''																		} ) //XB_CONTEM

	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	'A4_COD'																} ) //XB_CONTEM

	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Nome'																	, ; //XB_DESCRI
	'Nome'																	, ; //XB_DESCSPA
	'Nome'																	, ; //XB_DESCENG
	'A4_NOME'																} ) //XB_CONTEM

	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SA4->A4_COD'															} ) //XB_CONTEM

	aAdd( aSXB, { ;
	'SA4X'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SA4->A4_COD'															} ) //XB_CONTEM

	//
	// Atualizando dicion·rio
	//
	oProcess:SetRegua2( Len( aSXB ) )

	dbSelectArea( 'SXB' )
	dbSetOrder( 1 )

	//Verificar se a consulta CBW ja existe   
	If SXB->(dbSeek("CBW"))
		While !EOF() .and. Trim(XB_ALIAS) == "CBW"
			RecLock("SXB",.F.)
			dbDelete()
			MsUnLock()
			DbSkip()
		End
	EndIf

	For nI := 1 To Len( aSXB )

		If !Empty( aSXB[nI][1] )

			If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

				If !( aSXB[nI][1] $ cAlias )
					cAlias += aSXB[nI][1] + '/'
					cTexto += 'Foi incluÌda a consulta padr„o ' + aSXB[nI][1] + CRLF
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
					!StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), ' ', '' ) == ;
					StrTran( AllToChar( aSXB[nI][nJ]            ), ' ', '' )

						cMsg := 'A consulta padrao ' + aSXB[nI][1] + ' est· com o ' + SXB->( FieldName( nJ ) ) + ;
						' com o conte˙do' + CRLF + ;
						'[' + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
						', e este È diferente do conte˙do' + CRLF + ;
						'[' + RTrim( AllToChar( aSXB[nI][nJ] ) ) + ']' + CRLF +;
						'Deseja substituir ? '

						If      lTodosSim
							nOpcA := 1
						ElseIf  lTodosNao
							nOpcA := 2
						Else
							nOpcA := Aviso( 'ATUALIZA«√O DE DICION¡RIOS E TABELAS', cMsg, { 'Sim', 'N„o', 'Sim p/Todos', 'N„o p/Todos' }, 3,'DiferenÁa de conte˙do - SXB' )
							lTodosSim := ( nOpcA == 3 )
							lTodosNao := ( nOpcA == 4 )

							If lTodosSim
								nOpcA := 1
								lTodosSim := ApMsgNoYes( 'Foi selecionada a opÁ„o de REALIZAR TODAS alteraÁıes no SXB e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma a aÁ„o [Sim p/Todos] ?' )
							EndIf

							If lTodosNao
								nOpcA := 2
								lTodosNao := ApMsgNoYes( 'Foi selecionada a opÁ„o de N√O REALIZAR nenhuma alteraÁ„o no SXB que esteja diferente da base e N√O MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma esta aÁ„o [N„o p/Todos]?' )
							EndIf

						EndIf

						If nOpcA == 1
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

	cTexto += CRLF + 'Final da Atualizacao do SXB' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSXB )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX5ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX5 - Indices        ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX5ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSX5ACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSX5      := {}
	Local cAlias    := ''
	Local nI        := 0
	Local nJ        := 0

	Local cTexto    := 'Inicio Atualizacao SX5' + CRLF + CRLF

	aEstrut := { 'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE', 'X5_DESCRI', 'X5_DESCSPA', 'X5_DESCENG' }

	//
	// Tabela 00
	//
	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'00'																	, ; //X5_TABELA
	'J0'																	, ; //X5_CHAVE
	'Dispositivos de movimentacao'											, ; //X5_DESCRI
	'Dispositivos de movimiento'											, ; //X5_DESCSPA
	'Transaction Devices'													} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'00'																	, ; //X5_TABELA
	'J2'																	, ; //X5_CHAVE
	'Eventos LOG'															, ; //X5_DESCRI
	'Eventos LOG'															, ; //X5_DESCSPA
	'Eventos LOG'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'00'																	, ; //X5_TABELA
	'J3'																	, ; //X5_CHAVE
	'Fila Impressao'														, ; //X5_DESCRI
	'Fila Impresion'														, ; //X5_DESCSPA
	'Fila Impressao'														} ) //X5_DESCENG

	//
	// Tabela J0
	//
	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J0'																	, ; //X5_TABELA
	'001'																	, ; //X5_CHAVE
	'Carrinho 1 mt'															, ; //X5_DESCRI
	'Carrito 1 mt'															, ; //X5_DESCSPA
	'Cart-1 mt'																} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J0'																	, ; //X5_TABELA
	'002'																	, ; //X5_CHAVE
	'Carrinho 1,5 mt'														, ; //X5_DESCRI
	'Carrito 1,5 mt'														, ; //X5_DESCSPA
	'Cart-1.5 mt'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J0'																	, ; //X5_TABELA
	'003'																	, ; //X5_CHAVE
	'Cesta'																	, ; //X5_DESCRI
	'Cesta'																	, ; //X5_DESCSPA
	'Basket'																} ) //X5_DESCENG

	//
	// Tabela J2
	//
	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'01'																	, ; //X5_CHAVE
	'Enderecamento'															, ; //X5_DESCRI
	'Ubicacion'																, ; //X5_DESCSPA
	'Enderecamento'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'02'																	, ; //X5_CHAVE
	'Transferencia'															, ; //X5_DESCRI
	'Transferencia'															, ; //X5_DESCSPA
	'Transferencia'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'03'																	, ; //X5_CHAVE
	'Baixa CQ'																, ; //X5_DESCRI
	'Baja CQ'																, ; //X5_DESCSPA
	'Baixa CQ'																} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'04'																	, ; //X5_CHAVE
	'Inventario'															, ; //X5_DESCRI
	'Inventario'															, ; //X5_DESCSPA
	'Inventario'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'05'																	, ; //X5_CHAVE
	'Conferencia'															, ; //X5_DESCRI
	'Verificacion'															, ; //X5_DESCSPA
	'Conferencia'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'06'																	, ; //X5_CHAVE
	'Requisicao'															, ; //X5_DESCRI
	'Requerimiento'															, ; //X5_DESCSPA
	'Requisicao'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'07'																	, ; //X5_CHAVE
	'Divisao Etiqueta'														, ; //X5_DESCRI
	'Division Etiqueta'														, ; //X5_DESCSPA
	''																		} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'08'																	, ; //X5_CHAVE
	'Preparacao Enderecamento'												, ; //X5_DESCRI
	'Preparacion Ubicacion'													, ; //X5_DESCSPA
	''																		} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J2'																	, ; //X5_TABELA
	'09'																	, ; //X5_CHAVE
	'Expedicao'																, ; //X5_DESCRI
	'Despacho'																, ; //X5_DESCSPA
	''																		} ) //X5_DESCENG

	//
	// Tabela J3
	//
	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J3'																	, ; //X5_TABELA
	'01'																	, ; //X5_CHAVE
	'Recebimento'															, ; //X5_DESCRI
	'Recepcion'																, ; //X5_DESCSPA
	'Recebimento'															} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J3'																	, ; //X5_TABELA
	'02'																	, ; //X5_CHAVE
	'Producao'																, ; //X5_DESCRI
	'Produccion'															, ; //X5_DESCSPA
	'Producao'																} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J3'																	, ; //X5_TABELA
	'03'																	, ; //X5_CHAVE
	'Embalagem'																, ; //X5_DESCRI
	'Embalaje'																, ; //X5_DESCSPA
	'Embalagem'																} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J3'																	, ; //X5_TABELA
	'04'																	, ; //X5_CHAVE
	'Expedicao'																, ; //X5_DESCRI
	'Despacho'																, ; //X5_DESCSPA
	'Expedicao'																} ) //X5_DESCENG

	aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'J3'																	, ; //X5_TABELA
	'05'																	, ; //X5_CHAVE
	'C.Q.'																	, ; //X5_DESCRI
	'C.Q.'																	, ; //X5_DESCSPA
	'C.Q.'																	} ) //X5_DESCENG

	//
	// Atualizando dicion·rio
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

		aAdd( aArqUpd, aSX5[nI][1] )

		If !( aSX5[nI][1] $ cAlias )
			cAlias += aSX5[nI][1] + '/'
		EndIf

	Next nI

	cTexto += CRLF + 'Final da Atualizacao do SX5' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSX5 )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuSX9ACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX9 - Relacionament  ≥±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuSX9ACD                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuSX9ACD( aTextos, nEmp )
	Local aEstrut   := {}
	Local aSX9      := {}

	Local cTexto    := 'Inicio da Atualizacao do SX9' + CRLF + CRLF

	aEstrut := { 'X9_DOM'   , 'X9_IDENT'  , 'X9_CDOM'   , 'X9_EXPDOM', 'X9_EXPCDOM' ,'X9_PROPRI', ;
	'X9_LIGDOM', 'X9_LIGCDOM', 'X9_CONDSQL', 'X9_USEFIL', 'X9_ENABLE' }

	cTexto += CRLF + 'Final da Atualizacao do SX9' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return aClone( aSX9 )


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ AtuHlpACD ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao dos Helps de Campos    ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ AtuHlpACD                                                  ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AtuHlpACD( aTextos, nEmp )
	Local cTexto    := 'Inicio da Atualizacao ds Helps de Campos' + CRLF + CRLF

	cTexto += CRLF + 'Final da Atualizacao dos Helps de Campos' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aTextos[nEmp] := aTextos[nEmp] + cTexto

Return {}


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ESCEMPRESA∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Generica para escolha de Empresa, montado pelo SM0_ ∫±±
±±∫          ≥ Retorna vetor contendo as selecoes feitas.                 ∫±±
±±∫          ≥ Se nao For marcada nenhuma o vetor volta vazio.            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function EscEmpresa()
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Parametro  nTipo                           ≥
	//≥ 1  - Monta com Todas Empresas/Filiais      ≥
	//≥ 2  - Monta so com Empresas                 ≥
	//≥ 3  - Monta so com Filiais de uma Empresa   ≥
	//≥                                            ≥
	//≥ Parametro  aMarcadas                       ≥
	//≥ Vetor com Empresas/Filiais pre marcadas    ≥
	//≥                                            ≥
	//≥ Parametro  cEmpSel                         ≥
	//≥ Empresa que sera usada para montar selecao ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
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
	Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
	Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
	Local   lChk     := .F.
	Local   lOk      := .F.
	Local   lTeveMarc:= .F.
	Local   cVar     := ''
	Local   cNomEmp  := ''
	Local   cMascEmp := '??'
	Local   cMascFil := '??'

	Local   aMarcadas  := {}


	If !MyOpenSm0Ex()
		ApMsgStop( 'N„o foi possÌvel abrir SM0 exclusivo.' ) //'N„o foi possÌvel abrir SM0 exclusivo.'
		Return aRet
	EndIf


	dbSelectArea( 'SM0' )
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

	Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel

	oDlg:cToolTip := 'Tela para M˙ltiplas SeleÁıes de Empresas/Filiais' //'Tela para M˙ltiplas SeleÁıes de Empresas/Filiais'

	oDlg:cTitle := 'Selecione a(s) Empresa(s) para AtualizaÁ„o' //'Selecione a(s) Empresa(s) para AtualizaÁ„o'

	@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Empresa' Size 178, 095 Of oDlg Pixel //'Empresa'
	oLbx:SetArray(  aVetor )
	oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
	aVetor[oLbx:nAt, 2], ;
	aVetor[oLbx:nAt, 4]}}
	oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
	oLbx:cToolTip   :=  oDlg:cTitle
	oLbx:lHScroll   := .F. // NoScroll

	@ 112, 10 CheckBox oChkMar Var  lChk Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg; //'Todos'###'Marca / Desmarca Todos'
	on Click MarcaTodos( lChk, @aVetor, oLbx )

	@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
	Message 'Inverter SeleÁ„o' Of oDlg //'Inverter SeleÁ„o'

	// Marca/Desmarca por mascara
	@ 113, 51 Say  oSay Prompt 'Empresa' Size  40, 08 Of oDlg Pixel //'Empresa'
	@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
	Message 'M·scara Empresa ( ?? )'  Of oDlg //'M·scara Empresa ( ?? )'
	@ 123, 50 Button oButMarc Prompt '&Marcar'    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
	Message 'Marcar usando m·scara ( ?? )'    Of oDlg //'Marcar usando m·scara ( ?? )'
	@ 123, 90 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
	Message 'Desmarcar usando m·scara ( ?? )' Of oDlg //'Desmarcar usando m·scara ( ?? )'

	Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a SeleÁ„o' Enable Of oDlg //'Confirma a SeleÁ„o'
	Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop 'Abandona a SeleÁ„o' Enable Of oDlg //'Abandona a SeleÁ„o'
	Activate MSDialog  oDlg Center

	RestArea( aSalvAmb )
	dbSelectArea( 'SM0' )
	dbCloseArea()

Return  aRet


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥MARCATODOS∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar para marcar/desmarcar todos os itens do    ∫±±
±±∫          ≥ ListBox ativo                                              ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI

	oLbx:Refresh()

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥INVSELECAO∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar para inverter selecao do ListBox Ativo     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
	Next nI

	oLbx:Refresh()

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥RETSELECAO∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar que monta o retorno com as selecoes        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ MARCAMAS ∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  20/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao para marcar/desmarcar usando mascaras               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
	Local cPos1 := SubStr( cMascEmp, 1, 1 )
	Local cPos2 := SubStr( cMascEmp, 2, 1 )
	Local nPos  := oLbx:nAt
	Local nZ    := 0

	For nZ := 1 To Len( aVetor )
		If cPos1 == '?' .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
			If cPos2 == '?' .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
				aVetor[nZ][1] :=  lMarDes
			EndIf
		EndIf
	Next

	oLbx:nAt := nPos
	oLbx:Refresh()

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ VERTODOS ∫Autor  ≥ Ernani Forastieri  ∫ Data ≥  20/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao auxiliar para verificar se estao todos marcardos    ∫±±
±±∫          ≥ ou nao                                                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ MyOpenSM ∫ Autor ≥ Microsiga          ∫ Data ≥  19/05/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento abertura do SM0 modo exclusivo     ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ MyOpenSM                                                   ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MyOpenSM0Ex()

	Local lOpen := .F.
	Local nLoop := 0

	For nLoop := 1 To 20
		dbUseArea( .T.,"TOPCONN" , 'SIGAMAT.EMP', 'SM0', .F., .F. ) //Adicionado o driver "TOPCONN" \Ajustado

		If !Empty( Select( 'SM0' ) )
			lOpen := .T.
			dbSetIndex( 'SIGAMAT.IND' )
			Exit
		EndIf

		Sleep( 500 )

	Next nLoop

	If !lOpen
		ApMsgStop( 'N„o foi possÌvel a abertura da tabela ' + ;
		'de empresas de forma exclusiva.', 'ATEN«√O' )
	EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥AtuSx1    ≥ Autor ≥ Aecio Ferreira Gomes  ≥ Data ≥20/05/2010≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriáao ≥Adicionar pergunte e help                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Atualizacao ACD                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function AtuSx1ACD(aTextos)
	Local cPerg    := ""   
	Local cTexto   := 'Inicio da Atualizacao do SX1' + CRLF + CRLF //'Inicio da Atualizacao do SX1'

	cPerg:="ACD100"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Ordem de Sep. De  ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CB7",,,"mv_par01")
		PutSx1( cPerg, "02", "Ordem de Sep. Ate ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CB7",,,"mv_par02",,,,"ZZZZZZ")
		PutSx1( cPerg, "03", "Data de Emissao De ?", " ", " ", "mv_ch3" , "D", 8,0,0,"G","","",,,"mv_par03",,,,"'01/01/01'")
		PutSx1( cPerg, "04", "Data de Emissao Ate?", " ", " ", "mv_ch4" , "D", 8,0,0,"G","","",,,"mv_par04",,,,"'31/12/07'")
		PutSx1( cPerg, "05", "Cons.Sep.Encerradas?", " ", " ", "mv_ch5" , "N", 1,0,1,"C","","",,,"mv_par05","Sim",,,,"Nao")
		PutSx1( cPerg, "06", "Imprime Cod.Barras ?", " ", " ", "mv_ch6" , "N", 1,0,1,"C","","",,,"mv_par06","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF //'Foi incluso o grupo de perguntas '
	EndIf
	cPerg:="ACDA80"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Da Data            ?", " ", " ", "mv_ch1" , "D", 8,0,0,"G","","",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate Data           ?", " ", " ", "mv_ch2" , "D", 8,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Da OP              ?", " ", " ", "mv_ch3" , "C", 13,0,0,"G","","SC2",,,"mv_par03")
		PutSx1( cPerg, "04", "Ate OP             ?", " ", " ", "mv_ch4" , "C", 13,0,0,"G","","SC2",,,"mv_par04")
		PutSx1( cPerg, "05", "Da Transacao       ?", " ", " ", "mv_ch5" , "C", 2,0,0,"G","","CBI",,,"mv_par05")
		PutSx1( cPerg, "06", "Ate Transacao      ?", " ", " ", "mv_ch6" , "C", 2,0,0,"G","","CBI",,,"mv_par06")
		PutSx1( cPerg, "07", "Do Operador        ?", " ", " ", "mv_ch7" , "C", 6,0,0,"G","","CB1",,,"mv_par07")
		PutSx1( cPerg, "08", "Ate Operador       ?", " ", " ", "mv_ch8" , "C", 6,0,0,"G","","CB1",,,"mv_par08")
		PutSx1( cPerg, "09", "Ordem de Impressao ?", " ", " ", "mv_ch9" , "N", 1,0,1,"C","","",,,"mv_par09","Ordem 1",,,,"Ordem 2",,,"Ordem 3",,,"Ordem 4",,,"Ordem 5")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="ACDB80"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Tipo de Producao   ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","PCP MOD1",,,,"PCP MOD2")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA030"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Almoxarifado de    ?", " ", " ", "mv_ch1" , "C", 2,0,0,"G","","",,,"mv_par01")
		PutSx1( cPerg, "02", "Almoxarifado ate   ?", " ", " ", "mv_ch2" , "C", 2,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Endereco de        ?", " ", " ", "mv_ch3" , "C", 15,0,0,"G","","SBE",,,"mv_par03")
		PutSx1( cPerg, "04", "Endereco ate       ?", " ", " ", "mv_ch4" , "C", 15,0,0,"G","","SBE",,,"mv_par04")
		PutSx1( cPerg, "05", "Numero de contagens?", " ", " ", "mv_ch5" , "N", 1,0,0,"G","(mv_par05 > 0)","",,,"mv_par05")
		PutSx1( cPerg, "06", "Data               ?", " ", " ", "mv_ch6" , "D", 8,0,0,"G","naovazio()","",,,"mv_par06")
		PutSx1( cPerg, "07", "Classe A           ?", " ", " ", "mv_ch7" , "N", 1,0,0,"C","","",,,"mv_par07","Sim",,,,"Nao")
		PutSx1( cPerg, "08", "Classe B           ?", " ", " ", "mv_ch8" , "N", 1,0,0,"C","","",,,"mv_par08","Sim",,,,"Nao")
		PutSx1( cPerg, "09", "Classe C           ?", " ", " ", "mv_ch9" , "N", 1,0,0,"C","","",,,"mv_par09","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA031"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Tipo Geracao       ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Produto",,,,"Endereco")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf	
	cPerg:="AIA032"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Armazem            ?", " ", " ", "mv_ch1" , "C", 2,0,0,"G","","",,,"mv_par01")
		PutSx1( cPerg, "02", "Do Produto         ?", " ", " ", "mv_ch2" , "C", 15,0,0,"G","","SB1",,,"mv_par02")
		PutSx1( cPerg, "03", "Ate o Produto      ?", " ", " ", "mv_ch3" , "C", 15,0,0,"G","","SB1",,,"mv_par03")
		PutSx1( cPerg, "04", "Numero de contagens?", " ", " ", "mv_ch4" , "N", 1,0,0,"G","(mv_par05 > 0)","",,,"mv_par04")
		PutSx1( cPerg, "05", "Data               ?", " ", " ", "mv_ch5" , "D", 8,0,0,"G","","",,,"mv_par05")
		PutSx1( cPerg, "06", "Cons. Periodicidade?", " ", " ", "mv_ch6" , "D", 1,0,0,"C","","",,,"mv_par06","Sim",,,,"Nao")
		PutSx1( cPerg, "07", "Classe A           ?", " ", " ", "mv_ch7" , "N", 1,0,0,"C","","",,,"mv_par07","Sim",,,,"Nao")
		PutSx1( cPerg, "08", "Classe B           ?", " ", " ", "mv_ch8" , "N", 1,0,0,"C","","",,,"mv_par08","Sim",,,,"Nao")
		PutSx1( cPerg, "09", "Classe C           ?", " ", " ", "mv_ch9" , "N", 1,0,0,"C","","",,,"mv_par09","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA033"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Geracao Automatica ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Gera Mestre",,,,"Excluir Mestre",,,"Gera Lanc.Inv.",,,"Exclusao Lanc.")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA034"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Mestre De?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CBX",,,"mv_par01")
		PutSx1( cPerg, "02", "Mestre Ate?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","NaoVazio()","CBX",,,"mv_par02")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA035"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Mestre De?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CBX",,,"mv_par01")
		PutSx1( cPerg, "02", "Mestre Ate?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","NaoVazio()","CBX",,,"mv_par02")
		PutSx1( cPerg, "03", "Status?", " ", " ", "mv_ch3" , "N", 1,0,1,"C","","",,,"mv_par03","Todos",,,,"Em Andamento",,,"Finalizados")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA036"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Mestre de          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CBX",,,"mv_par01")
		PutSx1( cPerg, "02", "Mestre ate         ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","NaoVazio()","CBX",,,"mv_par02")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA037"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Mestre de          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CBX",,,"mv_par01")
		PutSx1( cPerg, "02", "Mestre ate         ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","NaoVazio()","CBX",,,"mv_par02")
		PutSx1( cPerg, "03", "Armazem de    	 ?", " ", " ", "mv_ch3" , "C", 2,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Armazem ate   	 ?", " ", " ", "mv_ch4" , "C", 2,0,0,"G","","",,,"mv_par04")
		PutSx1( cPerg, "05", "Do Produto         ?", " ", " ", "mv_ch5" , "C", 15,0,0,"G","Vazio() .or. ExistCpo('SB1')","SLV",,,"mv_par05")
		PutSx1( cPerg, "06", "Ate o Produto      ?", " ", " ", "mv_ch6" , "C", 15,0,0,"G","NaoVazio()","SLV",,,"mv_par06")
		PutSx1( cPerg, "07", "Endereco de        ?", " ", " ", "mv_ch7" , "C", 15,0,0,"G","","SBE",,,"mv_par07")
		PutSx1( cPerg, "08", "Endereco ate       ?", " ", " ", "mv_ch8" , "C", 15,0,0,"G","NaoVazio()","SBE",,,"mv_par08")
		PutSx1( cPerg, "09", "Da Data            ?", " ", " ", "mv_ch9" , "D", 8,0,0,"G","","",,,"mv_par09")
		PutSx1( cPerg, "10", "Ate Data           ?", " ", " ", "mv_ch10" , "D", 8,0,0,"G","","",,,"mv_par10")
		PutSx1( cPerg, "11", "Status             ?", " ", " ", "mv_ch11" , "N", 1,0,0,"C","","",,,"mv_par11","Em Andamento",,,,"Contado",,,"Finalizado",,,"Processado",,,"Todos")
		PutSx1( cPerg, "12", "Tipo do Inventario ?", " ", " ", "mv_ch12" , "N", 1,0,0,"C","","",,,"mv_par12","Por Produto",,,,"Por Endereco",,,"Todos",,,"Processado",,,"Todos")
		PutSx1( cPerg, "13", "Listar Etiquetas   ?", " ", " ", "mv_ch13" , "N", 1,0,0,"C","","",,,"mv_par13","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA100"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Separador          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","Vazio() .or. ExistCpo('CB1')","CB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Pedido de          ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Pedido ate         ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Cliente de         ?", " ", " ", "mv_ch4" , "C", 6,0,0,"G","","SA1",,,"mv_par04")
		PutSx1( cPerg, "05", "Cliente de         ?", " ", " ", "mv_ch5" , "C", 6,0,0,"G","","SA1",,,"mv_par05")
		PutSx1( cPerg, "06", "Loja cliente de    ?", " ", " ", "mv_ch6" , "C", 2,0,0,"G","","",,,"mv_par06")
		PutSx1( cPerg, "07", "Loja cliente ate   ?", " ", " ", "mv_ch7" , "C", 2,0,0,"G","","",,,"mv_par07")
		PutSx1( cPerg, "08", "Data liberacao de  ?", " ", " ", "mv_ch8" , "D", 8,0,0,"G","","",,,"mv_par08")
		PutSx1( cPerg, "09", "Data liberacao ate ?", " ", " ", "mv_ch9" , "D", 8,0,0,"G","","",,,"mv_par09")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA101"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Opcao              ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Pedido Venda",,,,"Nota Fiscal",,,"Ordem Producao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA102"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Separador          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","Vazio() .or. ExistCpo('CB1')","CB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Pedido de          ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CBL",,,"mv_par02")
		PutSx1( cPerg, "03", "Pedido ate         ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","CBL",,,"mv_par03")
		PutSx1( cPerg, "04", "Cliente de         ?", " ", " ", "mv_ch4" , "C", 6,0,0,"G","","SA1",,,"mv_par04")
		PutSx1( cPerg, "05", "Loja cliente de    ?", " ", " ", "mv_ch5" , "C", 2,0,0,"G","","",,,"mv_par05")
		PutSx1( cPerg, "06", "Cliente ate        ?", " ", " ", "mv_ch6" , "C", 6,0,0,"G","","SA1",,,"mv_par06")
		PutSx1( cPerg, "07", "Loja cliente ate   ?", " ", " ", "mv_ch7" , "C", 2,0,0,"G","","",,,"mv_par07")
		PutSx1( cPerg, "08", "Data liberacao de  ?", " ", " ", "mv_ch8" , "D", 8,0,0,"G","","",,,"mv_par08")
		PutSx1( cPerg, "09", "Data liberacao ate ?", " ", " ", "mv_ch9" , "D", 8,0,0,"G","","",,,"mv_par09")
		PutSx1( cPerg, "10", "Pre-Separacao      ?", " ", " ", "mv_ch10" , "N", 1,0,2,"C","","",,,"mv_par10","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA103"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Separador          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","Vazio() .or. ExistCpo('CB1')","CB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Nota de            ?", " ", " ", "mv_ch2" , "C", 9,0,0,"G","","CBM",,,"mv_par02")
		PutSx1( cPerg, "03", "Serie de           ?", " ", " ", "mv_ch3" , "C", 3,0,0,"G","","CBM",,,"mv_par03")
		PutSx1( cPerg, "04", "Nota ate           ?", " ", " ", "mv_ch4" , "C", 9,0,0,"G","","CBM",,,"mv_par04")
		PutSx1( cPerg, "05", "Serie ate          ?", " ", " ", "mv_ch5" , "C", 3,0,0,"G","","CBM",,,"mv_par05")
		PutSx1( cPerg, "06", "Cliente de         ?", " ", " ", "mv_ch6" , "C", 6,0,0,"G","","SA1",,,"mv_par06")
		PutSx1( cPerg, "07", "Loja cliente de    ?", " ", " ", "mv_ch7" , "C", 2,0,0,"G","","",,,"mv_par07")
		PutSx1( cPerg, "08", "Cliente ate        ?", " ", " ", "mv_ch8" , "C", 6,0,0,"G","","SA1",,,"mv_par08")
		PutSx1( cPerg, "09", "Loja cliente ate   ?", " ", " ", "mv_ch9" , "C", 2,0,0,"G","","",,,"mv_par09")
		PutSx1( cPerg, "10", "Data emissao de    ?", " ", " ", "mv_ch10" , "D", 8,0,0,"G","","",,,"mv_par10")
		PutSx1( cPerg, "11", "Data emissao ate   ?", " ", " ", "mv_ch11" , "D", 8,0,0,"G","","",,,"mv_par11")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA104"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Separador          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","Vazio() .or. ExistCpo('CB1')","CB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Op de              ?", " ", " ", "mv_ch2" , "C", 11,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Op de              ?", " ", " ", "mv_ch3" , "C", 11,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Data emissao de    ?", " ", " ", "mv_ch4" , "D", 8,0,0,"G","","",,,"mv_par04")
		PutSx1( cPerg, "05", "Data emissao ate   ?", " ", " ", "mv_ch5" , "D", 8,0,0,"G","","",,,"mv_par05")
		PutSx1( cPerg, "06", "Pre-Separacao      ?", " ", " ", "mv_ch6" , "N", 1,0,0,"C","","",,,"mv_par06","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA106"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Confere lote       ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par1","Sim",,,,"Nao")
		PutSx1( cPerg, "02", "Embal. simultanea  ?", " ", " ", "mv_ch2" , "N", 1,0,0,"C","","",,,"mv_par2","Sim",,,,"Nao")
		PutSx1( cPerg, "03", "Embalagem          ?", " ", " ", "mv_ch3" , "N", 1,0,0,"C","","",,,"mv_par3","Sim",,,,"Nao")
		PutSx1( cPerg, "04", "Gera Nota          ?", " ", " ", "mv_ch4" , "N", 1,0,0,"C","","",,,"mv_par4","Sim",,,,"Nao")
		PutSx1( cPerg, "05", "Imprime Nota       ?", " ", " ", "mv_ch5" , "N", 1,0,0,"C","","",,,"mv_par5","Sim",,,,"Nao")
		PutSx1( cPerg, "06", "Imprime Etiq.Volume?", " ", " ", "mv_ch6" , "N", 1,0,0,"C","","",,,"mv_par6","Sim",,,,"Nao")
		PutSx1( cPerg, "07", "Embarque           ?", " ", " ", "mv_ch7" , "N", 1,0,0,"C","","",,,"mv_par7","Sim",,,,"Nao")
		PutSx1( cPerg, "08", "Aglutina Pedido    ?", " ", " ", "mv_ch8" , "N", 1,0,0,"C","","",,,"mv_par8","Sim",,,,"Nao")
		PutSx1( cPerg, "09", "Aglutina Armazem   ?", " ", " ", "mv_ch9" , "N", 1,0,0,"C","","",,,"mv_par9","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA107"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Embal. simultanea  ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Sim",,,,"Nao")
		PutSx1( cPerg, "02", "Embalagem          ?", " ", " ", "mv_ch2" , "N", 1,0,0,"C","","",,,"mv_par02","Sim",,,,"Nao")
		PutSx1( cPerg, "03", "Imprime Nota       ?", " ", " ", "mv_ch3" , "N", 1,0,0,"C","","",,,"mv_par03","Sim",,,,"Nao")
		PutSx1( cPerg, "04", "Imprime Etiq.Volume?", " ", " ", "mv_ch4" , "N", 1,0,0,"C","","",,,"mv_par04","Sim",,,,"Nao")
		PutSx1( cPerg, "05", "Embarque           ?", " ", " ", "mv_ch5" , "N", 1,0,0,"C","","",,,"mv_par05","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA108"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Requisita material ?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Sim",,,,"Nao")
		PutSx1( cPerg, "02", "Aglutina Armazem   ?", " ", " ", "mv_ch2" , "N", 1,0,0,"C","","",,,"mv_par02","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII010"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Opcao              ?", " ", " ", "mv_ch1" , "C", 1,0,0,"C","","",,,"mv_par01","Produto",,,,"Recebimento",,,"Pedido",,,"Despacho",,,"Caixa")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII011"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do Produto         ?", " ", " ", "mv_ch1" , "C", 15,0,0,"G","","SB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate o Produto      ?", " ", " ", "mv_ch2" , "C", 15,0,0,"G","","SB1",,,"mv_par02")
		PutSx1( cPerg, "03", "Armazem            ?", " ", " ", "mv_ch3" , "C", 2,0,0,"G","","SBF",,,"mv_par03")
		PutSx1( cPerg, "04", "Endereco           ?", " ", " ", "mv_ch4" , "C", 15,0,0,"G","","SBE",,,"mv_par04")
		PutSx1( cPerg, "05", "Armazem Original   ?", " ", " ", "mv_ch5" , "C", 2,0,0,"G","","SBF",,,"mv_par05")
		PutSx1( cPerg, "06", "Quantidade         ?", " ", " ", "mv_ch6" , "N", 5,0,0,"G","","",,,"mv_par06")
		PutSx1( cPerg, "07", "Numero de Copias   ?", " ", " ", "mv_ch7" , "N", 4,0,0,"G","","",,,"mv_par07")
		PutSx1( cPerg, "08", "Local de Impressao ?", " ", " ", "mv_ch8" , "C", 6,0,0,"G","","CB5",,,"mv_par08")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII012"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Fornecedor de      ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","SA2",,,"mv_par01")
		PutSx1( cPerg, "02", "Loja de            ?", " ", " ", "mv_ch2" , "C", 2,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Fornecedor ate     ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","SA2",,,"mv_par03")
		PutSx1( cPerg, "04", "Loja ate           ?", " ", " ", "mv_ch4" , "C", 2,0,0,"G","","",,,"mv_par04")
		PutSx1( cPerg, "05", "Nota de            ?", " ", " ", "mv_ch5" , "C", 9,0,0,"G","","",,,"mv_par05")
		PutSx1( cPerg, "06", "Nota ate           ?", " ", " ", "mv_ch6" , "C", 9,0,0,"G","","",,,"mv_par06")
		PutSx1( cPerg, "07", "Serie de           ?", " ", " ", "mv_ch7" , "C", 3,0,0,"G","","",,,"mv_par07")
		PutSx1( cPerg, "08", "Serie ate          ?", " ", " ", "mv_ch8" , "C", 3,0,0,"G","","",,,"mv_par08")
		PutSx1( cPerg, "09", "Local de Impressao ?", " ", " ", "mv_ch9" , "C", 6,0,0,"G","","CB5",,,"mv_par09")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII013"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Pedido de          ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","SC7",,,"mv_par01")
		PutSx1( cPerg, "02", "Pedido ate         ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","SC7",,,"mv_par02")
		PutSx1( cPerg, "03", "Local de Impressao ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","CB5",,,"mv_par03")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII014"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do Produto         ?", " ", " ", "mv_ch1" , "C", 15,0,0,"G","","SB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate o Produto      ?", " ", " ", "mv_ch2" , "C", 15,0,0,"G","","SB1",,,"mv_par02")
		PutSx1( cPerg, "03", "Quantidade         ?", " ", " ", "mv_ch3" , "N", 4,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Unidade Despacho   ?", " ", " ", "mv_ch4" , "C", 1,0,0,"G","","",,,"mv_par04")
		PutSx1( cPerg, "05", "Local de Impressao ?", " ", " ", "mv_ch5" , "C", 6,0,0,"G","","CB5",,,"mv_par05")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII015"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do Produto         ?", " ", " ", "mv_ch1" , "C", 15,0,0,"G","","SB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate o Produto      ?", " ", " ", "mv_ch2" , "C", 15,0,0,"G","","SB1",,,"mv_par02")
		PutSx1( cPerg, "03", "Armazem            ?", " ", " ", "mv_ch3" , "C", 2,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Endereco           ?", " ", " ", "mv_ch4" , "C", 15,0,0,"G","","SBE",,,"mv_par04")
		PutSx1( cPerg, "05", "Quantidade         ?", " ", " ", "mv_ch5" , "N", 4,0,0,"G","","",,,"mv_par05")
		PutSx1( cPerg, "06", "Local de Impressao ?", " ", " ", "mv_ch6" , "C", 6,0,0,"G","","CB5",,,"mv_par06")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf	
	cPerg:="AII020"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do Almoxarifado    ?", " ", " ", "mv_ch1" , "C", 2,0,0,"G","","",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate Almoxarifado   ?", " ", " ", "mv_ch2" , "C", 2,0,0,"G","","",,,"mv_par02")
		PutSx1( cPerg, "03", "Do Endereco        ?", " ", " ", "mv_ch3" , "C", 15,0,0,"G","","SBE",,,"mv_par03")
		PutSx1( cPerg, "04", "Ate Endereco       ?", " ", " ", "mv_ch4" , "C", 15,0,0,"G","","SBE",,,"mv_par04")
		PutSx1( cPerg, "05", "Local de Impressao ?", " ", " ", "mv_ch5" , "C", 6,0,0,"G","","CB5",,,"mv_par05")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII030"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do Dispositivo     ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CB2",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate Dispositivo    ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CB2",,,"mv_par02")
		PutSx1( cPerg, "03", "Local de Impressao ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","CB5",,,"mv_par03")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII040"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Quantidade         ?", " ", " ", "mv_ch1" , "N", 4,0,0,"G","","",,,"mv_par01")
		PutSx1( cPerg, "02", "Local de Impressao ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CB5",,,"mv_par02")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII050"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Da transportadora  ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","SA4",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate transportadora ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","SA4",,,"mv_par02")
		PutSx1( cPerg, "03", "Local de Impressao ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","CB5",,,"mv_par03")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII060"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Do operador        ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CB1",,,"mv_par01")
		PutSx1( cPerg, "02", "Ate operador       ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CB1",,,"mv_par02")
		PutSx1( cPerg, "03", "Local de Impressao ?", " ", " ", "mv_ch3" , "C", 6,0,0,"G","","CB5",,,"mv_par03")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AII070"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Recurso de         ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","SH1",,,"mv_par01")
		PutSx1( cPerg, "02", "Recurso ate        ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","SH1",,,"mv_par02")
		PutSx1( cPerg, "03", "Numero de Copias   ?", " ", " ", "mv_ch3" , "N", 4,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Local de Impressao ?", " ", " ", "mv_ch4" , "C", 6,0,0,"G","","CB5",,,"mv_par04")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf       
	cPerg:="AII080"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Transacao de       ?", " ", " ", "mv_ch1" , "C", 6,0,0,"G","","CBI",,,"mv_par01")
		PutSx1( cPerg, "02", "Transacao ate      ?", " ", " ", "mv_ch2" , "C", 6,0,0,"G","","CBI",,,"mv_par02")
		PutSx1( cPerg, "03", "Numero de Copias   ?", " ", " ", "mv_ch3" , "N", 4,0,0,"G","","",,,"mv_par03")
		PutSx1( cPerg, "04", "Local de Impressao ?", " ", " ", "mv_ch4" , "C", 6,0,0,"G","","CB5",,,"mv_par04")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cPerg:="AIA105"
	If !SX1->(DbSeek(cPerg))
		PutSx1( cPerg, "01", "Exibe eti. qtd zero?", " ", " ", "mv_ch1" , "N", 1,0,0,"C","","",,,"mv_par01","Sim",,,,"Nao")
		cTexto += 'Foi incluso o grupo de perguntas ' + cPerg + CRLF
	EndIf
	cTexto += CRLF + 'Final da Atualizacao do SX1' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

	aAdd(aTextos,cTexto)
Return 


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AjustaSX2 ≥Autor ≥ Ricardo Berti          ≥ Data ≥15/03/11  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Ajusta dicionario SX2.                                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ updacd01                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/    
Static Function AjustaSx2()
	Local aArea   := GetArea()   

	dbSelectArea("SX2")
	dbSetOrder(1)

	If SX2->(dbSeek("CBC")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf
	If SX2->(dbSeek("CBM")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf
	If SX2->(dbSeek("CBG")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf
	If SX2->(dbSeek("CBE")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf
	If SX2->(dbSeek("CB9")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf

	If SX2->(dbSeek("CB8")) .And. !Empty(SX2->X2_UNICO)
		RecLock("SX2", .F.)
		X2_UNICO := ""
		MsUnlock()
	EndIf

	RestArea(aArea)
Return .T.

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AtuLogFile≥Autor ≥ Isaias Florencio       ≥ Data ≥13/11/2014∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Atualiza arquivo de log                                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ updacd01                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/ 

Static Function AtuLogFile(cFileName, cTexto, aTextos)
	Local nI := 0
	Default cTexto  := ""
	Default aTextos := {}

	If Len(aTextos) > 0
		For nI := 1 To Len(aTextos)
			WriteFile(cFileName, aTextos[nI])
		Next nI
	ElseIf !Empty(cTexto)
		WriteFile(cFileName, cTexto)
	EndIf	

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥WriteFile ≥Autor ≥ TOTVS                  ≥ Data ≥13/11/2014∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Escreve arquivo                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ updacd01                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/ 

Static Function WriteFile(cFileName,cTexto)
	Local nHandle	:= 0	 
	Local cCRLF		:= Chr(13) + Chr(10)

	If ! File( cFileName )

		nHandle := FCreate( cFileName, FC_NORMAL )  

		If FError() =  0   	
			FSeek( nHandle, 0, 2 )  //-- Posiciona no final do arquivo.
			FWrite( nHandle, cTexto + cCRLF )
			FClose( nHandle )
		EndIf

	Else	

		nHandle := FOpen( cFileName, FO_READWRITE )

		If FError() = 0	
			FSeek( nHandle, 0, 2 )  //-- Posiciona no final do arquivo.
			FWrite( nHandle, cTexto + cCRLF )
			FClose( nHandle )		
		EndIf

	EndIf

Return Nil
