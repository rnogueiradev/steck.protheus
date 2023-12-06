#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} User Function JOBNFIMP
    (long_description)
    JOB para validar Endereçamento Nota Fiscal Entrada de Importação
    Ticket: 20200214000549
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 01/04/2020
    @example
    (examples)
/*/
USER FUNCTION JOBNFIMP()
    Local _aEmpresa := {}
    Local nX        := 0

    // Empresas / Filiais que deverão ser validada
    aAdd(_aEmpresa, {'01','02'})
    //aAdd(_aEmpresa, {'01','04'})


    For nX := 1 to Len(_aEmpresa)
        ConOut( "*******************************************************************" )
        ConOut( "*    INICIO LEITURA EMPRESA:[ " +_aEmpresa[nX][01]+ " ] FILIAL: [ "+_aEmpresa[nX][02]+" ] - VIA JOB  (JOBNFIMP)  *" )
        ConOut( "*******************************************************************" )    
        
        RpcClearEnv()	
        RpcSetType(3)
        RpcSetEnv(_aEmpresa[nX][01],_aEmpresa[nX][02],,,,GetEnvServer(),{ "SC7","SF1","SD1","SB1","SDA","SDB","Z1A" } )
        SetModulo("SIGACOM","COM")

        // Efetua chamada da rotina... 
        JOBNF001()

        RpcClearEnv()

        ConOut( "*******************************************************************" )
        ConOut( "*    TERMINO LEITURA EMPRESA: [ "+_aEmpresa[nX][01]+" ] FILIAL: [ "+_aEmpresa[nX][02]+" ] JOB (JOBNFIMP)                               *" )
        ConOut( "*******************************************************************" )
    Next    


RETURN .T.


/*/{Protheus.doc} User Function JOBNF001
    (long_description)
    JOB para validar Endereçamento Nota Fiscal Entrada de Importação
    Ticket: 20200214000549
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 01/04/2020
    @example
    (examples)
/*/
Static Function JOBNF001()
    Local cQry    := MntQuery()
    Local aAreaNF := GetArea()
    Local cAliaNF := GetNextAlias()
    Local cCHVSDA := ""
    Local cCHVSDB := ""
    Local aDados  := {}
    Local cNotaF  := ""
    Local cCHVNF  := ""
    Local lOK     := .T.
    Local cEmail  := SuperGetMV("ST_JOBNF01",.F.,"valdemir.rabelo@sigamat.com.br")

    dbSelectArea("SF1")
    dbSetOrder(1)
    dbSelectArea("SD1")
    dbSetOrder(1)
    dbSelectArea("SDA")
    dbSetOrder(1)
    dbSelectArea("SDB")
    dbSetOrder(1)
    dbSelectArea("SB1")
    dbSetOrder(1)

    if Select(cAliaNF) > 0
       (cAliaNF)->( dbCloseArea() )
    endif

    TcQuery cQry New Alias (cAliaNF)

    While (cAliaNF)->( !Eof() )
        lOK := .T.
        // Posiciono as tabelas
        cCHVNF := (cAliaNF)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
        SF1->( dbGoto( (cAliaNF)->REGSF1 ) )
        While (cAliaNF)->( !Eof() ) .And. ( cCHVNF == (cAliaNF)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) )
            SD1->( dbGoto( (cAliaNF)->REGSD1 ) )
            cCHVSDA := SD1->( xFilial("SDA")+D1_COD+D1_LOCAL+D1_NUMSEQ+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA )
            SB1->( dbSeek(xFilial('SB1')+SD1->D1_COD) )
            lAchou := getSDA(cCHVSDA)
            IF !lAchou              //SDA->( !dbSeek( cCHVSDA ) )          // Não encontrou SDA
                IF lOK
                    aAdd(aDados, {"", ""} )
                    aAdd(aDados, {"FILIAL", SD1->D1_FILIAL} )
                    aAdd(aDados, {"NOTA FISCAL", SD1->D1_DOC} )
                    aAdd(aDados, {"SERIE",       SD1->D1_SERIE} )
                Endif
                aAdd(aDados, {"TABELA: SDA", "* * * DADOS NÃO ENCONTRADO * * *"} )
                aAdd(aDados, {"ITEM",       SD1->D1_ITEM} )
                aAdd(aDados, {"PRODUTO",    SD1->D1_COD} )
                aAdd(aDados, {"DESCRIÇÃO",  SB1->B1_DESC} )
                aAdd(aDados, {"ARMAZEM",    SD1->D1_LOCAL} )
                aAdd(aDados, {"NUM.SEQ.",   SD1->D1_NUMSEQ} )
                aAdd(aDados, {"FORNECEDOR", SD1->D1_FORNECE} )
                aAdd(aDados, {"LOJA",       SD1->D1_LOJA} )
                lOK := .F.
            ENDIF
            (cAliaNF)->( dbSkip() )
        EndDo
        IF lOK                      // Se não encontrou inconsistencia marca verdadeiro na validação
            Reclock("SF1", .F.)
            SF1->F1_XJOBVLD := .T.
            MsUnlock()
        Endif

    EndDo

    if Select(cAliaNF) > 0
       (cAliaNF)->( dbCloseArea() )
    endif

    // Dispara WF, caso tenha registros em aDados
    if Len(aDados) > 0
       EnvMail(cEmail, aDados)
    Endif

    RestArea( aAreaNF )

Return



/*/{Protheus.doc} User Function MntQuery
    (long_description)
    Monta Query que retorna registros conforme condição
    Ticket: 20200214000549
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 01/04/2020
    @example
    (examples)
/*/
Static Function MntQuery()
    Local cRET := ""

    cRET := "SELECT SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_LOCAL,SD1.D1_NUMSEQ,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA, SF1.R_E_C_N_O_ AS REGSF1,  SD1.R_E_C_N_O_ AS REGSD1 " + CRLF 
    cRET += "FROM "+RETSQLNAME("SF1") + " SF1 " + CRLF 
    cRET += "INNER JOIN " + RETSQLNAME("SD1") + " SD1 " + CRLF 
    cRET += "ON SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.D1_DOC=SF1.F1_DOC AND SD1.D1_SERIE=SF1.F1_SERIE AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D_E_L_E_T_ = '  '" + CRLF 
    cRET += "INNER JOIN " + RETSQLNAME("SF4") + " SF4 " + CRLF 
    cRET += "ON SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ = '  ' " + CRLF 
    cRET += "WHERE SF1.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += " AND SF4.F4_ESTOQUE='S' " + CRLF
    cRET += " AND SF1.F1_FILIAL = '" +XFILIAL('SF1') + "' " + CRLF 
    cRET += " AND SF1.F1_XJOBVLD = 'F' " + CRLF 
    cRET += "ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_COD " + CRLF 

Return cRET



/*/{Protheus.doc} User Function getSDB
    (long_description)
    Rotina retorna se existe o registro dentro da condição
    Ticket: 20200214000549
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 01/04/2020
    @example
    (examples)
/*/
Static Function getSDA(pcCHVSDA)
    Local lRET    := .F.
    Local cQry    := ""
    Local aAreaDB := GetArea()
    Local cAliaDA := GetNextAlias()

    cQry := "SELECT COUNT(*) REG " + CRLF 
    cQry += "FROM " + RETSQLNAME("SDA") + " SDA " + CRLF 
    cQry += "WHERE SDA.D_E_L_E_T_ = '  ' " + CRLF 
    cQry += " AND DA_FILIAL || DA_PRODUTO || DA_LOCAL || DA_NUMSEQ || DA_DOC || DA_SERIE || DA_CLIFOR || DA_LOJA = '"+pcCHVSDA+"' " + CRLF 

    if Select(cAliaDA) > 0
        (cAliaDA)->( dbCloseArea() )
    endif

    tcQuery cQry New Alias (cAliaDA)

    if (cAliaDA)->( !Eof() )
       lRET := ((cAliaDA)->REG > 0)
    endif

    if Select(cAliaDA) > 0
        (cAliaDA)->( dbCloseArea() )
    endif

    RestArea( aAreaDB )

Return lRET



//-------------------------------------------------------------------
// Monta e envia e-mail conforme status do registro
// Nome: Valdemir Rabelo
// Data: 31/03/2020
// Retorno: nil
//-------------------------------------------------------------------
Static Function EnvMail(cEmail, _aMsg)
	Local aArea     := Getarea()
	Local cMsgSt    := ""
	Local cMsg      := ""
	Local cCC       := ""
	Local _cAssunto := "AVISO DE NOTAS SEM ENDERECAMENTOS"
	Local cSubject  := _cAssunto
	Local _nLin

	//A Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//A Definicao do texto/detalhe do email                                         
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
        if _aMsg[_nLin,1] == "NOTA FISCAL"
            cColor := "#0000FF"
        elseif  (_aMsg[_nLin,1] == "TABELA: SDA") .OR. (_aMsg[_nLin,1] == "TABELA: SDB")
            cColor := "#8B0000"
        else 
            cColor := "#000000"
        endif

		cMsg += '<TD><B><Font Color='+cColor+' Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color='+cColor+' Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email                                               
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return



