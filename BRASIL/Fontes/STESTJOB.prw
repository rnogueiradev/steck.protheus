#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} User Function STESTJOB
    (long_description)
    JOB para coletar registros que não foram informado Roteiro
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 18/09/2019
    @example
    (examples)
/*/
User Function STESTJOB()
    Local _cEmpresa := '01'
    Local _cFilial  := '02'

	ConOut( "*******************************************************************" )
	ConOut( "*    INICIO LEITURA - PROCURA DE REGISTROS SEM ROTEIROS VIA JOB   *" )
	ConOut( "*******************************************************************" )    
    
    RpcClearEnv()	
    RpcSetType(3)
    RpcSetEnv(_cEmpresa,_cFilial,,,,GetEnvServer(),{ "PP8","SA1","SB1","SG2" } )
    SetModulo("SIGAEST","EST")

    // Efetua chamada da rotina... 
    STESTJ01()

    RpcClearEnv()

    ConOut( "*******************************************************************" )
	ConOut( "*    TERMINO LEITURA JOB (STESTJOB                                *" )
	ConOut( "*******************************************************************" )

Return .T.


/*/{Protheus.doc} User Function STESTJOB
    (long_description)
    JOB para coletar registros que não foram informado Roteiro
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 18/09/2019
    @example
    (examples)
/*/
Static Function STESTJ01()
    Local cQry     := MntQry()
    Local aAreaQry := GetArea()
    Local cAlias   := GetNextAlias()
    Local aDados   := {}
    Local aTMP     := {}
    Local cTitulo  := "UNICOM COM PENDÊNCIAS DE ROTEIRO - " + DTOC(DDATABASE) + " " + TIME()
    Local _cEmail  := SuperGetMV("STJ01EMAIL",.F.,"valdemir.rabelo@sigamat.com.br")

    dbSelectArea( "Z1A" )
    dbSetOrder(1)

    if Select(cAlias) > 0 
       (cAlias)->( dbCloseArea() )
    Endif 

    TcQuery cQry New Alias (cAlias)

    While (cAlias)->( !Eof() )
        aAdd(aTMP, {"Numero SD:   ", (cAlias)->PP8_CODIGO} )
        aAdd(aTMP, {"Item:        ", (cAlias)->PP8_ITEM}   )
        aAdd(aTMP, {"Produto:     ", (cAlias)->PP8_PROD}   )
        aAdd(aTMP, {"Descrição:   ", (cAlias)->PP8_DESCR}  )
        aAdd(aTMP, {"Cod.Desenho: ", (cAlias)->PP8_DESENH} )
        aAdd(aTMP, {"Grupo:       ", (cAlias)->PP8_GRUPO}  )
        aAdd(aTMP, {"Quantidade:  ", cValToChar((cAlias)->PP8_QUANT)}  )
        aAdd(aDados, aTMP)
        aTMP := {}            
        (cAlias)->( dbSkip() )
    EndDo 

    if Select(cAlias) > 0 
       (cAlias)->( dbCloseArea() )
    Endif 

    if Len(aDados) > 0
       StEmail(cTitulo, _cEmail, aDados)
    Endif 

    Restarea( aAreaQry )

Return 


Static Function MntQry()
    Local cRET := ""

    cRET := "SELECT * " + CRLF 
    cRET += "FROM " + RETSQLNAME("PP8") + " PP8 " + CRLF 
    cRET += "WHERE PP8.D_E_L_E_T_ = ' ' " + CRLF
    cRET += " AND PP8.PP8_DTENG <> ' ' " + CRLF 
    cRET += " AND PP8.PP8_ROTEIR = ' ' " + CRLF 

Return cRET




Static Function  StEmail(_cTitulo,_cEmail,_aMsg)
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= _cTitulo
	Local cFuncSent:= "StLibFinMail"
	Local i        := nCol := 0
	Local cArq     := ""
	Local cCorpo   := ""
	Local _nLin, nCol
	
	DEFAULT _cEmail  := "valdemir.rabelo@sigamat.com.br"
	

	// Definicao do cabecalho do email                                             
	cCorpo := ""
	cCorpo += '<html>'
	cCorpo += '<head>'
	cCorpo += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cCorpo += '</head>'
	cCorpo += '<body>'
	//cCorpo += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cCorpo += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cCorpo += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cCorpo += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

	// Definicao do texto/detalhe do email                                         
	For _nLin := 1 to Len(_aMsg)
/*
		IF (_nLin/2) == Int( _nLin/2 )
			cCorpo += '<TR BgColor=#B0E2FF>'
		Else
			cCorpo += '<TR BgColor=#FFFFFF>'
		EndIF
*/
        For nCol := 1 to Len(_aMsg[nCol])
            if  alltrim(_aMsg[_nLin,nCol,1])=="Numero SD:"    
                cCorpo += '<TR BgColor=#B0E2FF>'   
            else
                cCorpo += '<TR BgColor=#FFFFFF>'
            endif 
            cCorpo += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,1] + ' </Font></B></TD>'
            cCorpo += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,2] + ' </Font></TD>'
            cCorpo += '</TR>'
        Next 
	Next

	// Definicao do rodape do email                                                
	cCorpo += '</Table>'
	cCorpo += '<P>'
	cCorpo += '<Table align="center">'
	cCorpo += '<tr>'
	cCorpo += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
	cCorpo += '</tr>'
	cCorpo += '</Table>'
	cCorpo += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cCorpo += '</body>'
	cCorpo += '</html>'
		
	U_STMAILTES(_cEmail, "", _cAssunto, cCorpo, {} , "")
	
	RestArea(aArea)
Return()
