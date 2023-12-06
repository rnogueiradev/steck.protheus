#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} User Function JOBPTLRH
    (long_description)
    JOB para buscar funcionários com pendencias de aprovação de férias
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 02/12/2019
    @example
    (examples)
/*/
User Function JOBRH049()
    Local _aEmpresa := {}
    Local nX        := 0

    //aAdd(_aEmpresa, {'01','02'})
    //aAdd(_aEmpresa, {'01','03'})
    aAdd(_aEmpresa, {'01','04'})
    //aAdd(_aEmpresa, {'03','01'})

    For nX := 1 to Len(_aEmpresa)
        ConOut( "*******************************************************************" )
        ConOut( "*    INICIO LEITURA EMPRESA:[ " +_aEmpresa[nX][01]+ " ] FILIAL: [ "+_aEmpresa[nX][02]+" ] - PROCURA DE REGISTROS SEM SIGAGPE VIA JOB    *" )
        ConOut( "*******************************************************************" )    
        
        RpcClearEnv()	
        RpcSetType(3)
        RpcSetEnv(_aEmpresa[nX][01],_aEmpresa[nX][02],,,,GetEnvServer(),{ "RH3","SRA","SQB","Z1A" } )
        SetModulo("SIGAGPE","GPE")

        // Efetua chamada da rotina... 
        JOBRH49A()

        RpcClearEnv()

        ConOut( "*******************************************************************" )
        ConOut( "*    TERMINO LEITURA EMPRESA: [ "+_aEmpresa[nX][01]+" ] FILIAL: [ "+_aEmpresa[nX][02]+" ] JOB (JOBRH049)                               *" )
        ConOut( "*******************************************************************" )
    Next

Return .T.

/*/{Protheus.doc} User Function JOBRH49A
    (long_description)
    Rotina que valida se o usuário cadastrado está no prazo de avaliação
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 02/12/2019
    @example
    (examples)
/*/
Static Function JOBRH49A()
    Local cRespRH   := GETMV("ST_RSPJB49")
    Local nDiasAvi  := SuperGetMV("ST_DIASAVA",.F.,150)
    Local cQry      := MntQry()
    Local aAreaJ    := GetArea()
    Local aRegistro := {}
    Local _cAssunto := "Funcionários em avaliação com mais de "+cValToChar(nDiasAvi)+" dias"
    Local _cEmail   := SuperGetMV("ST_EMAILJB",.F.,'valdemir.rabelo@sigamat.com.br')
    Local _cCopia   := ""

    cUserName       := "JOBRH049"

    if Select("TabJob") > 0
       TabJob->( dbCloseArea() )
    Endif

    tcQuery cQry new Alias "TabJob"

    While TabJob->( !Eof() )
        if STOD(TabJob->Z49_DATA)+nDiasAvi >= dDATABASE
           aAdd(aRegistro, {;
                dtoc(stod(TabJob->Z49_DATA)),;
                TabJob->Z49_NOME,; 
                TabJob->Z49_MAT,; 
                TabJob->Z49_COD;
           })
        Endif
        TabJob->( dbSkip() )
    EndDo

    TabJob->( dbCloseArea() )

    // Caso tenha Envio, será disparado
    if Len(aRegistro) > 0
        STWF49(_cAssunto,_cEmail,_cCopia, aRegistro )
    endif

    RestArea( aAreaJ )

Return



/*/{Protheus.doc} User Function MntQry
    (long_description)
    Rotina trazer apenas registros pendente de avaliação
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 02/12/2019
    @example
    (examples)
/*/
Static Function MntQry()
    Local cRET := ""

    cRET += "SELECT Z49_DATA, Z49_NOME, Z49_MAT, Z49_COD " + CRLF
    cRET += "FROM " + RETSQLNAME("Z49") + " A " + CRLF
    cRET += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
    cRET += " AND Z49_STATUS='1' " + CRLF
    
Return cRET


/*/{Protheus.doc} User Function STWF49
    (long_description)
    Rotina de montagem do WF para informar RH
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 02/12/2019
    @example
    (examples)
/*/
Static Function STWF49(_cAssunto,_cEmail,_cCopia, aRegistro )

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "STWF49"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin    := 0
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
    Local nX       := 0
    Local nCol     := 0
	Local _aMsg    :={}
    Local _aTMP    := {}


    For nX := 1 to Len(aRegistro)
        _aTMP    := {}
        Aadd( _aTMP , { "Nome: "            , aRegistro[nX][2] } )
        Aadd( _aTMP , { "Data Cadastro: "	, aRegistro[nX][1] } )
        Aadd( _aTMP , { "Matricula: " 		, aRegistro[nX][3] } )
        Aadd( _aTMP , { "Data: "    		, dtoc(dDataBase) } )
        Aadd( _aTMP , { "Hora: "    		, time() } )
        aAdd(_aMsg, _aTMP)        
    Next

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

        For nCol := 1 to Len(_aMsg[_nLin])
            if  alltrim(_aMsg[_nLin,nCol,1])=="Nome:"
                cMsg += '<TR BgColor=#B0E2FF>'
            Else
                cMsg += '<TR BgColor=#FFFFFF>'
            EndIf

            cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,1] + ' </Font></B></TD>'
            cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,2] + ' </Font></TD>'
        Next

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

	RestArea(aArea)
Return()
