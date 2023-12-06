#INCLUDE "FILEIO.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

#INCLUDE "PROTHEUS.CH"

#ifdef SPANISH
		#DEFINE STR0001 "Informe o CEP"
		#DEFINE STR0002 "Encontre-me"
		#DEFINE STR0003 "Consultar Novo CEP?"
		#DEFINE STR0004 "I hope to see you again"
		#DEFINE STR0005 "bye bye"
		#DEFINE STR0006 "Você me Encontrou. Deseja Salvar-me?"
		#DEFINE STR0007 "Atenção"
		#DEFINE STR0008 "Problemas com a Conexão Internet. Impossível Conectar-se"
#else
	#ifdef ENGLISH
		#DEFINE STR0001 "Informe o CEP"
		#DEFINE STR0002 "Encontre-me"
		#DEFINE STR0003 "Consultar Novo CEP?"
		#DEFINE STR0004 "I hope to see you again"
		#DEFINE STR0005 "bye bye"
		#DEFINE STR0006 "Você me Encontrou. Deseja Salvar-me?"
		#DEFINE STR0007 "Atenção"
		#DEFINE STR0008 "Problemas com a Conexão Internet. Impossível Conectar-se"
	#else
		#DEFINE STR0001 "Informe o CEP"
		#DEFINE STR0002 "Encontre-me"
		#DEFINE STR0003 "Consultar Novo CEP?"
		#DEFINE STR0004 "I hope to see you again"
		#DEFINE STR0005 "bye bye"
		#DEFINE STR0006 "Você me Encontrou. Deseja Salvar-me?"
		#DEFINE STR0007 "Atenção"
		#DEFINE STR0008 "Problemas com a Conexão Internet. Impossível Conectar-se"
	#endif
#endif

#DEFINE	__FINDME_FILE__			"D:\TOTVS12\Microsiga\Protheus\PROTHEUS_DATA\findfind-me.csv"
#DEFINE	__FINDME_CFG_FILE__		"D:\TOTVS12\Microsiga\Protheus\PROTHEUS_DATA\findfind-me.cfg"

Static __oCFG
Static __aFindMe
Static __aCEPAsc
Static __aCEPDesc
Static __nCEP

/*/
	Funcao: FindMe
	Autor:	Marinaldo de Jesus
	Data:	12/10/2010
	Uso:	Encontre-me
/*/
User Function FindMe()

	Local lNewApp	:= ( ( Select( "SM0" ) == 0 ) .or. !( Type( "oApp" ) == "O" ) )

	IF ( lNewApp )

		MsApp():New( "SIGAESP" )
		//oApp:lMenu      := .F.
		oApp:lMdimenuinfo      := .F.
		//oApp:lShortCut	:= .F.
		oApp:cInternet  := NIL
		oApp:cModDesc	:= OemToAnsi( STR0002 )	//"Encontre-me"
		oApp:bMainInit  := { || FindMe( lNewApp ) }

		SetFunName( "U_FINDME" )
		PtSetTheme( "OCEAN"    )

		oApp:CreateEnv()
		oApp:RunApp( .T. )

	Else

		FindMe( lNewApp )

	EndIF

Return NIL

/*/
	Funcao: FindMe
	Autor:	Marinaldo de Jesus
	Data:	12/10/2010
	Uso:	Localizar o Endereco mais proximo de acordo com as opcoes passadas e o CEP digitado
/*/
Static Function FindMe( lNewApp )

	Local aPerg			:= {}
	Local aFound		:= {}

	Local cURL			:= "http://maps.google.com/maps?f=q&hl=pt-BR&q="
	Local cGMQry
	Local cHttpGet
	Local cHtmlFile
	Local cTempPath		:= GetTempPath()

	Local cCEP			:= ""
	Local cPais			:= ""
	Local cNome			:= ""
	Local cBairro		:= ""
	Local cEstado		:= ""
	Local cCidade		:= ""
	Local cNumero		:= ""
	Local cLogradouro	:= ""
	Local cComplemento	:= ""

	Local lSaveHtml		:= .F.

	Local nBL
	Local nEL

	Local nCEP
	Local nPais
	Local nNome
	Local nBairro
	Local nEstado
	Local nCidade
	Local nNumero
	Local nLogradouro
	Local nComplemento

	DEFAULT __oCFG		:= TFINI():New( __FINDME_CFG_FILE__ )

	BEGIN SEQUENCE

		nCEP			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "CEP" , "0" ) )
		IF ( nCEP == 0 )
			BREAK
		EndIF

		IF ( __nCEP != nCEP )
			__aFindMe			:= FileToArr( __FINDME_FILE__ , nCEP )
			DEFAULT __aCEPAsc	:= {}
			DEFAULT __aCEPDesc	:= {}
			aSize( __aCEPAsc  , 0 )
			aSize( __aCEPDesc , 0 )
			aEval( __aFindMe[ 2 ] , { |aElem,nIndex|								;
										cCEP := StrTran( aElem[nCEP] , "-" , "" ),	;
										(											;
											aAdd( __aCEPAsc , aClone( aElem ) ),	;
											__aCEPAsc[nIndex][nCEP] := cCEP			;
										 ),											;
										 (											;
										 	aAdd( __aCEPDesc , aClone( aElem ) ),	;
										 	__aCEPDesc[nIndex][nCEP] := cCEP		;
										 )											;	
								 	 }												;
				 )
			aSort( __aCEPAsc  , NIL , NIL , { |cep_x,cep_y| cep_x[nCEP] < cep_y[nCEP] } )
			aSort( __aCEPDesc , NIL , NIL , { |cep_x,cep_y| cep_x[nCEP] > cep_y[nCEP] } )
		EndIF

		aAdd( aPerg , { 1 , OemToAnsi( STR0001 ) , Space(9) , "99999-999" , ".T." , "" , ".T." , 8 , .T. } ) //"Informe o CEP"

		IF ParamBox( @aPerg , OemToAnsi( STR0002 ) , NIL , NIL , NIL , .T. )	//"Encontre-me"

			cCEP			:= StrTran( MV_PAR01 , "-" , "" )

			nPais			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Pais"			, "0" ) )	
			nNome			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Nome"			, "0" ) )
			nBairro			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Bairro"		, "0" ) )	
			nEstado			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Estado"		, "0" ) )
			nCidade			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Cidade"		, "0" ) )
			nNumero			:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Numero"		, "0" ) )
			nLogradouro		:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Logradouro"	, "0" ) )
			nComplemento	:= Val( __oCFG:GetPropertyValue( "FIELDS" , "Complemento"	, "0" ) )

			IF ( ( nEL := Find_Me( @aFound , @nCEP , @cCEP , @__aCEPAsc , @__aCEPDesc ) ) > 0 )
				lSaveHtml	:= MsgYesNo( OemToAnsi( STR0006 ) , ProcName() +  " :: " + OemToAnsi( STR0007 ) ) //"Você me Encontrou. Deseja Salvar-me?"###"Atenção"
				For nBL := 1 To nEL
					cGMQry		:= ""
					IF ( nLogradouro > 0 )
						cLogradouro	:= FormatGMap( aFound[nBL][nLogradouro] )
						IF !Empty( cLogradouro )
							cGMQry	+= cLogradouro
						EndIF	
					EndIF	
					IF ( nNumero > 0 )
						cNumero	:= FormatGMap( aFound[nBL][nNumero] ) 
						IF !Empty( cNumero )
							cGMQry	+= "+"+cNumero
						EndIF	
					EndIF	
					IF ( nComplemento > 0 )
						cComplemento	:= FormatGMap( aFound[nBL][nComplemento] ) 
						IF !Empty( cComplemento )
							cGMQry	+= "+"+cComplemento
						EndIF	
					EndIF	
					IF ( nBairro > 0 )
						cBairro	:= FormatGMap( aFound[nBL][nBairro] ) 
						IF !Empty( cBairro )
							cGMQry	+= "+"+cBairro
						EndIF	
					EndIF	
					IF ( nCidade > 0 )
						cCidade	:= FormatGMap( aFound[nBL][nCidade] ) 
						IF !Empty( cCidade )
							cGMQry	+= "+"+cCidade
						EndIF
					EndIF
					IF ( nEstado > 0 )
						cEstado	:= FormatGMap( aFound[nBL][nEstado] ) 
						IF !Empty( cEstado )
							cGMQry	+= "+"+cEstado
						EndIF	
					EndIF	
					cCEP	:= FormatGMap( aFound[nBL][nCEP] ) 
					IF !Empty( cCEP )
						cGMQry	+= "+"+cCEP
					EndIF	
					IF ( nPais > 0 )
						cPais	:= FormatGMap( aFound[nBL][nPais] ) 
						IF !Empty( cPais )
							cGMQry	+= "+"+cPais
						EndIF	
					EndIF	
					IF ( nNome > 0 )
						cNome	:= FormatGMap( aFound[nBL][nNome] )
						IF !Empty( cNome )
							cGMQry	+= "+("
							cGMQry	+= cNome
							IF !Empty( cLogradouro )
								cGMQry	+= "+" + cLogradouro
							EndIF	
							IF !Empty( cNumero )
								cGMQry	+= "+" + cNumero
							EndIF	
							IF !Empty( cComplemento )
								cGMQry	+= "+" + cComplemento
							EndIF	
							IF !Empty( cBairro )
								cGMQry	+= "+" + cBairro
							EndIF	
							IF !Empty( cCidade )
								cGMQry	+= "+" + cCidade
							EndIF	
							IF !Empty( cEstado )
								cGMQry	+= "+" + cEstado
							EndIF	
							IF !Empty( cPais )
								cGMQry	+= "+" + cPais
							EndIF	
							IF !Empty( cCEP )
								cGMQry	+= "+" + cCEP
							EndIF	
							cGMQry	+=")"
						EndIF
					EndIF
					IF !Empty( cGMQry )                                                                 
						cHttpGet	:= cURL
						cHttpGet	+= cGMQry
						IF (;
								( lSaveHtml );
								.and.;
								!( HttpGet( "http://www.google.com.br" ) == NIL );
							)
							cHttpGet	+= "&layer=&ie=ISO-8859-1&z=10&om=1&iwloc=addr"
							cHttpGet 	:= HttpGet( cHttpGet )
							IF ( cHttpGet == NIL )
								MsgInfo( OemToAnsi( STR0008 ) , ProcName() +  " :: " + OemToAnsi( STR0007 ) ) //"Problemas com a Conexão Internet. Impossível Conectar-se"###"Atenção!"
								BREAK
							EndIF
							IF !( SubStr( cTempPath , -1 ) == "\" )
								cTempPath += "\"
							EndIF
							cHtmlFile	:= ( cTempPath + CriaTrab( NIL , .F. ) + ".html" )
							While File( cHtmlFile )
								cHtmlFile	:= ( cTempPath + CriaTrab( NIL , .F. ) + ".html" )	
							End While
							IF MemoWrite( cHtmlFile , cHttpGet )
								ShellExecute( "Open", cHtmlFile , "" , cTempPath , SW_SHOWMAXIMIZED )
							EndIF
						Else
							cHttpGet	+= "&layer=&ie=UTF8&z=10&om=1&iwloc=addr"
							cHttpGet	:= EncodeUTF8( cHttpGet )
							ShellExecute( "Open", cHttpGet , "" , cTempPath , SW_SHOWMAXIMIZED )
						EndIF	
					EndIF
				Next nBL
			EndIF

 			IF !( MsgNoYes( OemToAnsi( STR0003 ) , ProcName() ) )
				BREAK
			EndIF

			FindMe( lNewApp )

		EndIF

	END SEQUENCE

	DEFAULT lNewApp		:= .F.
	IF ( lNewApp )
		Final( OemToAnsi( STR0004 ) , OemToAnsi( STR0005 ) ) //"I hope to see you again"###"bye bye"
	EndIF	

Return( .T. )

/*/
	Funcao: 	Find_Me
	Autor:		Marinaldo de Jesus
	Data:		12/10/2010
	Uso:		Localizar o Endereco mais proximo de acordo com as opcoes passadas e o CEP digitado
	Baseado em:	http://www.correios.com.br/servicos/cep/cep_estrutura.cfm
/*/
Static Function Find_Me( aFound , nATCEP , cCEP , aCEPAsc , aCEPDesc , nMaxAsc , nMaxDesc )

	Local bFound		:= { |nATCEP,cAT,nAT,aCEP,nFound| ( ( nFound := aScan( aCEP , { |x| ( SubStr( x[nATCEP] , 1 , nAT ) == cAT ) } , ++nFound ) ) > 0 ) }

	Local cAT			:= ""
	
	Local lExit			:= .F.
	Local lFoundAsc		:= .F.
	Local lFoundDesc	:= .F.
	
	Local nAT			:= Len( cCEP )
	Local nMax			:= 0
	Local nCount		:= 0
	Local nFoundAsc		:= 0
	Local nCountAsc		:= 0
	Local nCountDesc	:= 0
	Local nFoundDesc	:= 0

	DEFAULT nMaxAsc		:= 3
	DEFAULT nMaxDesc	:= 3

	IF ( ValType( aFound ) == "A" )
		aSize( aFound , 0 )
	Else
		aFound			:= {}
	EndIF

	nMax				:= ( nMaxAsc + nMaxDesc )

	While ( nAT > 0 )
		cAT			:= SubStr( cCEP , 1 , nAT )
		lFoundAsc	:= Eval( bFound , @nATCEP , @cAT , @nAT , @aCEPAsc  , @nFoundAsc  )
		lFoundDesc	:= Eval( bFound , @nATCEP , @cAT , @nAT , @aCEPDesc , @nFoundDesc )
		While ( lFoundAsc .or. lFoundDesc )
			IF ( lFoundAsc .and. ( nCountAsc <= nMaxAsc ) )
				IF ( aScan( aFound , { |x| x[ nATCEP ] == aCEPAsc[ nFoundAsc ][ nATCEP] } ) == 0 )
					aAdd( aFound , aCEPAsc[ nFoundAsc ] )
					++nCount
					++nCountAsc
				EndIF
			EndIF
			IF ( lFoundDesc .and. ( nCountDesc <= nMaxDesc ) )
				IF ( aScan( aFound , { |x| x[ nATCEP ] == aCEPDesc[ nFoundDesc ][ nATCEP] } ) == 0 )
					aAdd( aFound , aCEPDesc[ nFoundDesc ] )
					++nCount
					++nCountDesc
				EndIF
			EndIF
			lExit	:= ( nCount >= nMax )
			IF ( lExit )
				Exit
			EndIF
			lFoundAsc	:= Eval( bFound , @nATCEP , @cAT , @nAT , @aCEPAsc  , @nFoundAsc  )
			lFoundDesc	:= Eval( bFound , @nATCEP , @cAT , @nAT , @aCEPDesc , @nFoundDesc )
		End While
		IF ( lExit )
			Exit
		EndIF
		--nAT
		nFoundAsc	:= 0
		nFoundDesc	:= 0
	End While

Return( nCount )

/*/
	Funcao: FileToArr
	Autor:	Marinaldo de Jesus
	Data:	12/10/2010
	Uso:	Carrega o arquivo de Enderecos em Memoria
/*/
Static Function FileToArr( cFile , nCEP )

	Local aCab   	:= {}
	Local aDet   	:= {}
	Local aLine
	
	Local cLine   	:= ""
	Local cToken  	:= "|"
	Local cRddName	:= "DBFCDXADS" //"TOPCONN"

	Local lPrepEnv	:= ( !( cRddName == "DBFCDXADS" ) .and. ( Select( "SM0" ) == "0" ) )
     
	Local nCab
	
	Local ofTdb	:= fTdb():New()
	
	IF ( lPrepEnv )
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIF
	
	BEGIN SEQUENCE
	 
		ofTdb:ft_fSetRddName( cRddName )
	   
		IF ( ofTdb:ft_fUse( cFile ) <= 0 )
			ofTdb:ft_fUse()
			BREAK
		EndIF

		While !( ofTdb:ft_fEof() )
			IncProc()
			cLine   	:= ofTdb:ft_fReadLn()
			//StrTokArr() nao trata string Nula ""... Vamos Ajuda-la
			While ( "||" $ cLine )
				cLine	:= StrTran( cLine , "||" , "| |" )	//Carrego um espaço em branco
			End While
			cLine		:= OemToAnsi( cLine )
			ConOut( cLine )
			IF ( ofTdb:ft_fRecno() == 1 )
				aCab	:= StrTokArr( cLine , cToken )		//A primeira Linha contem o Cabeçalho dos campos
				nCab	:= Len( aCab )
				IF ( nCab < nCEP )
					nCab := -1
				EndIF
			Else
				aLine	:= StrTokArr( cLine , cToken )
				IF ( Len( aLine ) == nCab )
					aAdd( aDet , StrTokArr( cLine , cToken ) )	//As demais linhas sao os Detalhes
				EndIF	
			EndIF
			cLine		:= "" 
			ofTdb:ft_fSkip()
		End While

		ofTdb:ft_fUse()

	END SEQUENCE

	IF ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

Return( { aCab , aDet } )

/*/
	Funcao: FormatGMap
	Autor:	Marinaldo de Jesus
	Data:	12/10/2010
	Uso:	Tratamento de String para o GMap
/*/
Static Function FormatGMap( cPStr )

	Local cSpc2		:= Space( 2 )
	Local cSpc1		:= Space( 1 ) 
	Local cGMStr	:= ""

	cGMStr			:= ClearChar( cPStr )

	IF !Empty( cGMStr )

		While ( cSpc2 $ cGMStr )
			cGMStr := StrTran( cGMStr , cSpc2 , cSpc1 )
		End While
	
		While ( cSpc1 $ cGMStr )
			cGMStr := StrTran( cGMStr , cSpc1 , "+" )
		End While

		While ( "," $ cGMStr )
			cGMStr := StrTran( cGMStr , "," , "+" )
		End While

	EndIF

Return( cGMStr )

/*/
	Funcao: ClearChar
	Autor:	Marinaldo de Jesus
	Data:	12/10/2010
	Uso:	Retira os Acentos
/*/
Static Function ClearChar( cStr )
	cStr := AllTrim( cStr )
	cStr := NoAcento( ftAcento( AnsitoOem( cStr ) ) )
	cStr := NoAcento( ftAcento( OemToAnsi( cStr ) ) )
	cStr := StrTran( cStr , Chr(13) , "" )
	cStr := StrTran( cStr , Chr(10) , "" )
	cStr := AllTrim( cStr )
Return( cStr )
