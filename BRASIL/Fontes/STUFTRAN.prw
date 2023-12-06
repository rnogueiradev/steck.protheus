#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} STUFTRAN
description
Rotina que irá apresentar a interface para informar os 
Estados por Transportadora
Ticket: 20210811015405
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@return variant, return_description
/*/
USER FUNCTION STUFTRAN()
	Local _cTitulo		:= "UFs por Transportadora"
	Local _lRetMod2Ok	:= .F.
	Local _nx			:= 0
	Local _lAchou		:= .F.
	Local _aCpoCab		:= {}
	Local _aCpoRod		:= {}
	Local _aCoord		:= {}
	Local _aTamWnd		:= {}
	Local _cLinhaOk 	:= "u_VLDTOKFT()"
	Local _cTudoOk  	:= ".T."
	Local _nRecno		:= 0
	Local _nOrder		:= Z89->( IndexOrd() )
	Local _cAlias       := "Z89"
	Local _nOPCGRID     := 4
	Local aButtons      := {}
	Local bF4           := {|| .T. }

	Private _nOpcX      := 4
	Private _aGetSD     := {'Z89_UF'}
	Private _bWhile		:= { || xFilial("Z89") == Z89->Z89_FILIAL .and. _cCONTRO == Z89->Z89_TRANSP }
	Private _cCONTRO	:= SA4->A4_COD
	Private _cNOMSOL    := SA4->A4_NOME
	Private _oObj       := nil
	Private aHeader 	:= {}
	Private aCols   	:= {}
	Private aRotina     := {}
	Private _cCpoExc	:= Padr( "Z89_TRANSP",10)+"/"+PadR("Z89_NOME",10)  	/*	Campo que nao devera aparecer na Getdados mesmo estando marcado como 'browse' no SX3 sempre com tamanho 10 */

	dbSelectArea( "Z89" )
	dbSetOrder( 1 )
	_nOpcX      := IF(!dbSeek(xFilial("Z89")+SA4->A4_COD),3,4)
	INCLUI := (_nOpcX==3)

	// Carrega aHeader do Alias a ser usado na Getdados
	aHeader := CargaHeader( _cAlias, _cCpoExc )

	If _nOpcX == 3
		aCols := CarIncCols( _cAlias, aHeader, "", 4, _cCpoExc )
	else
		aCols := CargaCols( aHeader, _cAlias, 1, xFilial( "Z89" ) + _cCONTRO, _bWhile, _cCpoExc )
	ENDIF

	// Monta Cabeçalho
	MntCabec(@_aCpoCab)

	// Coordenadas
	_aCoord := { C(070), C(005), C(118), C(315) }
	_aTamWnd:= { C(100), C(100), C(400), C(750) }

    /*
        Exibe tela estilo modelo2. Parametros:

        cTitulo  = Titulo da Janela
        aC       =  Array com campos do Cabecalho
        aR       =  Array com campos do Rodape
        aCGD     =  Array com coordenadas da Getdados
        nOpcx    =  Modo de Operacao
        cLineOk  =  Validacao da linha do Getdados
        cAllOk   =  Validacao de toda Getdados
        aGetSD   =  Array com gets editaveis
        bF4      =  Bloco de codigo para tecla F4
        cIniCpos =  String com nome dos campos que devem ser inicializados ao teclar seta para baixo
        lDelGetD =  Determina se as linhas da Getdados podem ser deletadas ou nao.
    */

	_lRetMod2Ok := Modelo2( _cTitulo, _aCpoCab , _aCpoRod, _aCoord, _nOPCGRID, _cLinhaOk, _cTudoOk,_aGetSD, bF4, "", 9999, _aTamWnd,,.T.,aButtons )

	If _lRetMod2Ok

		Begin Transaction
			// Realiza a gravação / atualização
			grvZ89()

		End Transaction

		dbSelectArea( "Z89" )

	Endif

	Z89->( dbSetOrder( _nOrder ) )

RETURN


/*/{Protheus.doc} User Function MntCabec
    (long_description)
    Monta Cabecalho
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function MntCabec(_aCpoCab)

    /*
    Array para get no cabecalho da Tela estilo modelo2. Parametros:
    aC[n,1] =  Nome da Variavel Ex.:"cCliente"
    aC[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL
    aC[n,3] =  Titulo do Campo
    aC[n,4] =  Picture
    aC[n,5] =  Nome da funcao para validacao do campo
    aC[n,6] =  F3
    aC[n,7] =  Se campo e' editavel .t. se nao .f.
    */
	AADD( _aCpoCab,{ "_cCONTRO"   	,{ C(15), C(010) } , OemToAnsi("Transp.")	    , "@!", '.T.' , ""	, .F.})
	AADD( _aCpoCab,{ "_cNOMSOL"   	,{ C(15), C(130) } , OemToAnsi("Nome")	        , "@!", ""    , ""	, .F.})

Return


/*/{Protheus.doc} User Function CargaCols
    (long_description)
    Rotina para carregar os dados de um determinado alias ( baseado no
    Header ) para a Getdados usada ( alteracao, exclusao, visual )
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CargaCols( _aHeader, _cAlias, _nIndice, _cChave, _bWhile, _cCpoExc  )
	Local _aArea	:= GetArea()
	Local _nUsado	:= 0
	Local _nCnt		:= 0
	Local _aCols	:= {}

	aAreaZ89 := GetArea()


	dbSelectArea( _cAlias )
	dbSetOrder( _nIndice )
	dbSeek( _cChave )

	Do While Eval( _bWhile )

		aAdd( _aCols, Array( Len( _aHeader ) +2 ) )
		_nCnt++
		_nUsado := 0
		dbSelectArea( "SX3" )
		dbSeek( _cAlias )

		Do While !Eof() .and. X3_ARQUIVO == _cAlias


			If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( Alltrim(X3_CAMPO) $ _cCpoExc )
				_nUsado++
				_cVarTemp := _cAlias + "->" + ( X3_CAMPO )
				If X3_CONTEXT # "V"
					_aCols[ _nCnt, _nUsado ] := &_cVarTemp
				Elseif X3_CONTEXT == "V" .and. !Empty(SX3->X3_INIBRW)
					_aCols[ _nCnt, _nUsado ] := Eval( &( "{|| " + _cAlias + "->(" + SX3->X3_INIBRW + ") }" ) )
				Endif
			Endif

			DBSkip()

		Enddo

		_aCols[ _nCnt, Len(_aCols[_nCnt]) ]   := .F.
		dbSelectArea( _cAlias )
		dbSkip()

	Enddo

	aSort(_aCols,,,{|X,Y| X[ Len(_aCols[1])-1] < Y[Len(_aCols[1])-1] })

	RestArea( _aArea )

Return( _aCols )


/*/{Protheus.doc} grvZ89
description
Rotina para efetuar a gravação
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@param paCols, variant, param_description
@return variant, return_description
/*/
Static Function grvZ89(paCols)
	Local nX      := 0
	Local nAberto := 0
	Local nOpcLote:= 0
	Local aAreaZ  := GetArea()
	Local lInclui := .F.
	Local cAguard := ""
	Local cAddLot := ""

	// Atualizo o Cabecalho
	dbSelectArea("Z89")
	dbSetOrder(1)
	lInclui := (!dbSeek(xFilial("Z89")+_cCONTRO))

	For nX := 1 to Len(aCols)
		lInclui := (!dbSeek(xFilial("Z89")+_cCONTRO+aCols[nX][1]))
		if !aCols[nX][Len(aCols[nX])]  // Verifico se está deletado
			if !Empty(aCols[nX][GDFieldPos("Z89_UF")])
				RecLock('Z89',lInclui)
				if lInclui
					Z89->Z89_FILIAL := XFILIAL('Z89')
					Z89->Z89_TRANSP := _cCONTRO
					Z89->Z89_NOME   := _cNOMSOL
				endif
				Z89->Z89_UF := aCols[nX][GDFieldPos("Z89_UF")]
				Z89->( MsUnlock() )
			endif
		else
			if !lInclui
				RecLock('Z89',lInclui)
				Z89->( dbDelete() )
				Z89->( MsUnlock() )
			Endif
		Endif
	Next
	dbCommitAll()

	RestArea( aAreaZ )

Return



/*/{Protheus.doc} User Function CargaHeader
    (long_description)
    retorna Array com cabecalho para os itens
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CargaHeader( _cAlias, _cCpoExc )
	Local _aHeader 	:= {}
	Local _nUsado	:= 0
//_oObj := CallMod2Obj()
//_oObj:oBrowse:lUseDefaultColors := .F.
//_oObj:SetBlkBackColor({|| GETDCLR(_oObj:nAt,8421376)})

	dbSelectArea( "SX3" )
	dbSetOrder(1)
	dbSeek( _cAlias )

	While !Eof() .and. X3_ARQUIVO == _cAlias

		If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )
			_nUsado++
			AADD( _aHeader, { 	Trim( X3Titulo() ),;
				X3_CAMPO    ,;
				X3_PICTURE  ,;
				X3_TAMANHO  ,;
				X3_DECIMAL  ,;
				X3_VALID    ,;
				X3_USADO    ,;
				X3_TIPO     ,;
				X3_ARQUIVO  ,;
				X3_CONTEXT  } )
		Endif

		dbSkip()

	Enddo

Return( _aHeader )



/*/{Protheus.doc} User Function CarIncCols
    (long_description)
    Rotina que carrega a variavel array aCols com valores iniciais na
    Inclusão de Registro
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CarIncCols( _cAlias, _aHeader, _cCpoItem, _nTamCpoItem, _cCpoExc )
	Local _aArea			:= GetArea()
	Local _nUsado			:= 0
	Local _aCols			:= {}

	Default _cCpoItem		:= ""
	Default _nTamCpoItem	:= 3

	dbSelectArea( "SX3" )
	dbSeek( _cAlias )
	aAdd( _aCols, Array( Len( _aHeader ) +1 ) )

	Do While !Eof() .and. X3_ARQUIVO == _cAlias

		If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )

			_nUsado++
			If X3_TIPO == "C"
				If Trim(aHeader[_nUsado][2]) == _cCpoItem
					_aCols[ 1, _nUsado ] := StrZero( 1, _nTamCpoItem )
				Else
					_aCols[ 1, _nUsado ] := Space( X3_TAMANHO )
				Endif
			Elseif X3_TIPO == "N"
				_aCols[ 1, _nUsado ] := 0
			Elseif X3_TIPO == "D"
				_aCols[ 1, _nUsado ] := dDataBase
			Elseif X3_TIPO == "M"
				_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
			Else
				_aCols[ 1, _nUsado ] := .F.
			Endif
			If X3_CONTEXT == "V"
				_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
			Endif

		Endif

		dbSkip()

	Enddo

	_aCols[ 1, _nUsado +1 ] := .F.

	RestArea( _aArea )

Return( _aCols )


/*/{Protheus.doc} VLDTudo
description
Rotina para validar os dados
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@return variant, return_description
/*/
User Function VLDTOKFT()
	Local lRET := .T.
	Local cTMP := ""
	Local nX   := 0
	Local nY   := 0

	if Len(aCols ) > 1
		For nX := 1 to Len(aCols )
			IF !aCols[nX][LEN(aCOLS[nX])]
				cTMP := aCols[nX][1]
				For nY := nX+1 To Len(aCols)
					IF !aCols[nY][LEN(aCOLS[nY])]
						if (cTMP==aCols[nY][1])
							lRET := .F.
						endif
					Endif
				Next
			endif
		Next
	Endif
	if !lRET
		FWMsgRun(,{|| Sleep(3000)},"Informativo","Estado só pode ser informado 1 vez.")
	Endif

Return lRET


/*/{Protheus.doc} VLDUFCPO
description
Rotina que valida o campo da tabela
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@return variant, return_description
/*/
User Function VLDUFCPO()
	Local lRET   := .T.
	Local aUF    := {}

	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

	lRET := !Empty(M->Z89_UF)
	if lRET
		lRET := (aScan(aUF, {|X| X[1]==M->Z89_UF}) > 0)
		if lRET
			lRET := (aScan(aCols,{|X| ALLTRIM(X[1]) == ALLTRIM(M->Z89_UF)})==0)
			if !lRET
				FWMsgRun(,{|| sleep(3000)},"Informativo","O UF: "+M->Z89_UF+" já consta na lista.")
			Endif
		else
			FWMsgRun(,{|| sleep(3000)},"Informativo","O UF: "+M->Z89_UF+" não foi encontrado")
		endif
	else
		FWMsgRun(,{|| sleep(3000)},"Informativo","O campo UF não pode ser vazio.")
	endif

Return lRET

/*/{Protheus.doc} getUFTRAN
description
Rotina para efetuar validação no processo
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@param pUF, variant, param_description
@return variant, return_description
/*/
User Function getUFTRAN(pUF)
	Local aZ89 := GetArea()
	Local aRET := {}

	dbSelectArea("Z89")
	dbSetOrder(2)
	if dbSeek(xFilial("Z89")+pUF)
		aRET := {Z89->Z89_TRANSP, ALLTRIM(Z89->Z89_NOME)}
	else
		aRET := {'ERR',"(Z89) Estado não cadastrado no controle validação (<b>Estados por Transportadora</b>)"}
	endif

	RestArea( aZ89)

Return aRET



/*/{Protheus.doc} RetUFTRAN
description
Valida informação do estado, retorna código transportadora
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@param pUF, variant, param_description
@return variant, return_description
/*/
Static Function RetUFTRAN(pUF)
Return U_getUFTRAN(pUF) //StaticCall (STUFTRAN, getUFTRAN, pUF)


/*/{Protheus.doc} SeekUFTRAN
description
Rotina que localiza registro Estado / Transportadora
Ticket: 20210811015405
@type function
@version  
@author Valdemir Jose
@since 17/08/2021
@param pTransp, variant, param_description
@param pUF, variant, param_description
@return variant, return_description
/*/
User Function LocUFTRA(pTransp, pUF, pcampo)
	Local aAreaUF := GetArea()
	Local aUFTRAN := {}
	Local lRet    := .T.
	Default pCampo:= ""
	// ------ Ticket: 20210811015405 - Valdemir Rabelo 17/08/2021 --------
	dbSelectArea("Z89")
	dbSetOrder(1)
	lRet := dbSeek(xFilial("Z89")+pTransp+pUF)
	if !lRet
		aUFTRAN := RetUFTRAN(pUF)
		if (aUFTRAN[1] != "ERR")		    
			cMsg := "Atenção, para este estado deve-se utilizar a transportadora: "+CRLF+;
				aUFTRAN[1]+" - <B>"+aUFTRAN[2]+"</B>"+CRLF+;
				" O campo será atualizado."
			lRET := .T.
			MsgInfo(cMsg, "Atenção!")	
			if lRET
				&pCampo := aUFTRAN[1]
			endif 		
		Else
			MsgInfo(aUFTRAN[2],"Informativo")
		Endif
	Endif
	// --------------

	RestArea( aAreaUF )
Return lRET
