#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} User Function JOBPTLRH
    (long_description)
    JOB para buscar funcionários com pendencias de aprovação de férias
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 09/10/2019
    @example
    (examples)
/*/
User Function JOBPTLRH()
    Local _aEmpresa := {}
    Local nX        := 0
    If Upper(GetEnvServ()) == "PROD" //Distribuiora
        aAdd(_aEmpresa, {'11','01'})
        aAdd(_aEmpresa, {'11','02'})
    Else
        aAdd(_aEmpresa, {'01','02'})
        aAdd(_aEmpresa, {'01','03'})
        aAdd(_aEmpresa, {'01','04'})
        aAdd(_aEmpresa, {'01','05'})
        aAdd(_aEmpresa, {'03','01'})       
    EndIf
    For nX := 1 to Len(_aEmpresa)
        ConOut( "*******************************************************************" )
        ConOut( "*    INICIO LEITURA EMPRESA:[ " +_aEmpresa[nX][01]+ " ] FILIAL: [ "+_aEmpresa[nX][02]+" ] - PROCURA DE REGISTROS SEM SIGAGPE VIA JOB    *" )
        ConOut( "*******************************************************************" )

        RpcClearEnv()
        RpcSetType(3)
        RpcSetEnv(_aEmpresa[nX][01],_aEmpresa[nX][02],,,,GetEnvServer(),{ "RH3","SRA","SQB","Z1A" } )
        SetModulo("SIGAGPE","GPE")

        // Efetua chamada da rotina...
        JOBRH001("1")
        JOBRH001("2")
        JOBRH001("3")
        JOBRH001("4")
        JOBRH001("5")
        JOBRH001("6")

        RpcClearEnv()

        ConOut( "*******************************************************************" )
        ConOut( "*    TERMINO LEITURA EMPRESA: [ "+_aEmpresa[nX][01]+" ] FILIAL: [ "+_aEmpresa[nX][02]+" ] JOB (JOBPTLRH)                               *" )
        ConOut( "*******************************************************************" )
    Next

Return .T.


/*/{Protheus.doc} User Function JOBRH001
    (long_description)
    Rotina filtra os registros conforme regra passada
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 09/10/2019
    @example
    (examples)
/*/
Static Function JOBRH001(pStatus)
    Local cQry     := MntQry(pStatus)
    Local _cCompl  := BscTit(pStatus)
    Local aAreaQry := GetArea()
    Local cAlias   := GetNextAlias()
    Local aDados   := {}
    Local aTMP     := {}
    Local nX       := 0
    Local cEmail   := ""
    Local _cNome    := ""
    Local _cAprov    := ""
    Local _cNomeSol  := ""
    Local _cAprovSol := ""
    Local cTitulo  := "SOLICITAÇÃO DE FÉRIAS - " + _cCompl + "            " + DTOC(DDATABASE) + " " + TIME()
    Local _cCopEmal  := SuperGetMV("STPLRHMAIL",.F.,"everson.santana@steck.com.br")

    dbSelectArea("SRA")
    dbSetOrder(1)
    dbSelectArea("RH3")
    dbSetOrder(2)
    dbSelectArea( "Z1A" )
    dbSetOrder(1)

    if Select(cAlias) > 0
        (cAlias)->( dbCloseArea() )
    Endif

    TcQuery cQry New Alias (cAlias)

    While (cAlias)->( !Eof() )

        if pStatus $ "1/2/3/4/5/6"

            If (cAlias)->(FILIAL+MATRICULA) = (cAlias)->(FILINI+APROVINI) .AND. !Empty((cAlias)->(FILRESP+APROVADOR))

                SRA->( !dbSeek((cAlias)->FILRESP+(cAlias)->APROVADOR))
                cEmail := ALLTRIM(SRA->RA_EMAIL)
                _cNome := ALLTRIM(SRA->RA_NOME)
                _cAprov := alltrim((cAlias)->APROVADOR)

            Elseif  (cAlias)->(FILIAL+MATRICULA) = (cAlias)->(FILINI+APROVINI) .AND. Empty((cAlias)->(FILRESP+APROVADOR))
                SRA->( !dbSeek((cAlias)->FILSQB+(cAlias)->MATRSQB))
                cEmail := ALLTRIM(SRA->RA_EMAIL)
                _cNome := ALLTRIM(SRA->RA_NOME)
                _cAprov := alltrim((cAlias)->MATRSQB)

            Elseif (cAlias)->(FILIAL+MATRICULA) <> (cAlias)->(FILINI+APROVINI) .AND. Empty((cAlias)->(FILRESP+APROVADOR))
                SRA->( !dbSeek((cAlias)->FILINI+(cAlias)->APROVINI))
                cEmail := ALLTRIM(SRA->RA_EMAIL)
                _cNome := ALLTRIM(SRA->RA_NOME)
                _cAprov := alltrim((cAlias)->APROVINI)

            Elseif (cAlias)->(FILIAL+MATRICULA) <> (cAlias)->(FILINI+APROVINI) .AND. !Empty((cAlias)->(FILRESP+APROVADOR))
                SRA->( !dbSeek((cAlias)->FILINI+(cAlias)->APROVINI))
                cEmail := ALLTRIM(SRA->RA_EMAIL)
                _cNomeSol := ALLTRIM(SRA->RA_NOME)
                _cAprovSol := alltrim((cAlias)->APROVINI)

                SRA->( !dbSeek((cAlias)->FILRESP+(cAlias)->APROVADOR))
                cEmail += ","+ALLTRIM(SRA->RA_EMAIL)
                _cNome := ALLTRIM(SRA->RA_NOME)
                _cAprov := alltrim((cAlias)->APROVADOR)

            EndIf

            if pStatus $ "2/3/4/5/6"
                if !Empty((cAlias)->EMAILMAT)
                    If !ALLTRIM((cAlias)->EMAILMAT) $ Alltrim(cEmail)
                        cEmail += ","+ALLTRIM((cAlias)->EMAILMAT)             // Funcionário
                    EndIf
                endif
            Endif

            nInc := aScan(aDados, {|X| alltrim(X[1])==_cAprov})
            if nInc==0
                aAdd(aDados, {_cAprov, cEmail,_cNome, {} })
                nInc := Len(aDados)
            endif

        EndIf
        aAdd(aTMP, {"Matricula:   ", (cAlias)->MATRICULA} )
        aAdd(aTMP, {"Nome:        ", (cAlias)->NOME}   )
        aAdd(aTMP, {"Período Férias:"," De: "+Dtoc(Ctod((cAlias)->DATAINI))+" Até: "+Dtoc(Ctod((cAlias)->DATAFIM))  }   )
        aAdd(aTMP, {"Depto:       ", (cAlias)->DEPTO}   )
        aAdd(aTMP, {"Descrição:   ", (cAlias)->DESCRICAO}   )
        aAdd(aTMP, {"Status:      ", (cAlias)->STATUS+" - "+_cCompl}   )
        aAdd(aTMP, {"Aprovador:   ", aDados[nInc][1]+" - "+aDados[nInc][3]}   )
        /*
        If !Empty(_cNomeSol)
            aAdd(aTMP, {"Solicitante:   ", _cAprovSol+" - "+_cNomeSol}   )
        EndIf
        */
        aAdd(aTMP, {"Registro:    ", (cAlias)->REG}   )
        aAdd(aDados[nInc][4], aTMP)
        aTMP := {}

        (cAlias)->( dbSkip() )
    EndDo

    if Select(cAlias) > 0
        (cAlias)->( dbCloseArea() )
    Endif

    if Len(aDados) > 0
        For nX := 1 to Len(aDados)
            StEmail(cTitulo, aDados[nX][2], aDados[nX][4], pStatus,_cCopEmal)
        Next
    Endif

    Restarea( aAreaQry )

Return


Static Function BscTit(pStatus)
    Local cRET := ""

    //1=Em processo de aprovação;2=Atendida;3=Reprovada;4=Aguardando Efetivação do RH
    if pStatus=="1"
        cRET := "PENDENTE DE APROVAÇÃO"  //ETAPA-1 PENDENTES DE APROVAÇÃO"
    elseif pStatus=="2"
        cRET := "APROVADO PELO GESTOR" //"ETAPA-2 APROVADO (AGUARDANDO RH)"
    elseif pStatus=="3"
        cRET := "REPROVADO PELO GESTOR" //"ETAPA-2 REPROVADO"
    elseif pStatus=="4"
        cRET := "APROVADO PELO GESTOR" //ETAPA-3 AGUARDANDO EFETIVAÇÃO DO RH"
    elseif pStatus=="5"
        cRET := "APROVADO PELO RH" //"ETAPA-4  EFETIVADO PELO RH"
    elseif pStatus=="6"
        cRET := "REPROVADO PELO RH" //"ETAPA-4  REPROVADO PELO RH"
    endif

Return cRET


/*/{Protheus.doc} User Function MntQry
    (long_description)
    Query para filtrar os registros
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 09/10/2019
    @example
    (examples)
/*/
Static Function MntQry(pSTATUS)
    Local cRET := ""
    Local cTrStatus := pSTATUS

    if pSTATUS=='5'
        cTrStatus := "2"
    elseif pSTATUS=='6'
        cTrStatus := "3"
    endif

    cRET := "SELECT DISTINCT A.RH3_STATUS STATUS, A.RH3_FILIAL FILIAL,A.RH3_MAT MATRICULA, B.RA_NOME NOME, B.RA_EMAIL EMAILMAT, B.RA_DEPTO DEPTO, C.QB_DESCRIC DESCRICAO, A.RH3_FILAPR FILRESP, " + CRLF "
    cRET += " A.RH3_MATAPR APROVADOR, A.RH3_FILINI FILINI, A.RH3_MATINI APROVINI, A.RH3_DTATEN DTATEND, A.R_E_C_N_O_ REG, C.QB_FILRESP FILSQB,C.QB_MATRESP MATRSQB, " + CRLF "
    cRET += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" WHERE RH4_CAMPO = 'R8_DATAINI' AND RH4_FILIAL = '"+xFilial("RH4")+"' AND RH4_CODIGO = RH3_CODIGO AND D_E_L_E_T_ = ' ') DATAINI, "
    cRET += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" WHERE RH4_CAMPO = 'R8_DATAFIM' AND RH4_FILIAL = '"+xFilial("RH4")+"' AND RH4_CODIGO =RH3_CODIGO AND D_E_L_E_T_ = ' ') DATAFIM "
    cRET += " FROM " + RETSQLNAME('RH3') + " A " + CRLF
    cRET += "INNER JOIN " + RETSQLNAME('SRA') + " B" + CRLF
    cRET += "ON A.RH3_FILIAL=B.RA_FILIAL AND A.RH3_MAT=B.RA_MAT AND B.D_E_L_E_T_ = ' '" + CRLF
    cRET += "INNER JOIN " + RETSQLNAME('SQB') + " C " + CRLF
    cRET += "ON C.QB_DEPTO=B.RA_DEPTO AND C.D_E_L_E_T_ = ' ' " + CRLF
    cRET += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
    if pSTATUS=='1'             // Pendente de Aprovacao
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN = ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH  = ' ' " + CRLF
    elseif pSTATUS=='2'             // Reprovado pelo Gestor
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN = ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'G' " + CRLF
    elseif pSTATUS=='3'             // Reprovado pelo Gestor
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN = ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'F' " + CRLF
    elseif pSTATUS=='4'             // Reprovado pelo Gestor
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN = ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'R' " + CRLF
    elseif pSTATUS=='5'         // Efetivado pelo RH
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN <> ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'F' " + CRLF
    elseif pSTATUS=='6'         // Reprovado pelo RH
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN <> ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'F' " + CRLF
    else
        cRET += "AND A.RH3_STATUS='" +cTrStatus+ "' " + CRLF
        cRET += "AND A.RH3_DTATEN = ' '  " + CRLF
        cRET += "AND A.RH3_XWFRH <> 'F' " + CRLF
    endif
    cRET += "AND A.RH3_FILIAL = '" +XFILIAL('RH3')+ "' " + CRLF
    cRET += "AND A.RH3_DTSOLI > '20181009' " + CRLF
    cRET += "AND A.RH3_TIPO IN ('B','O','P') " + CRLF //B = Férias,O = Saldo de Férias, P = Férias e Licença Prêmio (Tabela JQ - SX5)

Return cRET

Static Function  StEmail(_cTitulo,_cEmail,_aMsg, pStatus,_cCopEmal)

    Local aArea 	:= GetArea()
    Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
    Local _cAssunto:= _cTitulo
    Local cFuncSent:= "JOBPTLRH"
    Local i        := nCol := 0
    Local cArq     := ""
    Local cCorpo   := ""
    Local _nLin, nCol
    Local _cCaminho		:= "\arquivos\meurh\"
    Local _aAttach  	:= {}

    DEFAULT _cEmail     := "everson.santana@steck.com.br"
    DEFAULT _cCopEmal   := "everson.santana@steck.com.br"
    //>>Ticket 20200730004876 - Everson Santana - 30.07.2020
    // Definicao do cabecalho do email
    cCorpo := ""

    cCorpo += ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//PT"> '
    cCorpo += ' <html> '
    cCorpo += ' <head> '
    cCorpo += '     <meta content="text/html" ; charset="utf-8"> '
    cCorpo += '     <title>'+_cTitulo+'</title> '
    cCorpo += ' </head> '
    cCorpo += ' <body> '
    cCorpo += '     <table class="table table-hover table-responsive table-bordered"> '
    cCorpo += '         <tbody> '
    cCorpo += '             <tr> '
    cCorpo += '                 <td colspan="9" align="left" height="19" width="100%"> '
    cCorpo += '                     <font face="Verdana, Arial, Helvetica, sans-serif" size="2"> <strong> '
    cCorpo += '                             <h2>Olá,</h2> '

    //1=Em processo de aprovação;2=Atendida;3=Reprovada;4=Aguardando Efetivação do RH
    if pStatus=="1"
        cCorpo += '                             <b>Segue nova solicitação de férias, conforme abaixo; </b> ' //ETAPA-1 PENDENTES DE APROVAÇÃO"
    elseif pStatus=="2"
        cCorpo += '                             <b>Segue nova solicitação de férias, conforme abaixo; </b> '  //"ETAPA-2 APROVADO (AGUARDANDO RH)"
    elseif pStatus=="3"
        cCorpo += '                             <b>Sua solicitação de férias foi reprovada pelo seu gestor. </b> '  //"ETAPA-2 REPROVADO"
    elseif pStatus=="4"
        cCorpo += '                             <b>Sua solicitação de férias foi aprovada pelo seu gestor, agora será direcionado para aprovação final do RH. </b> '  //ETAPA-3 AGUARDANDO EFETIVAÇÃO DO RH"
    elseif pStatus=="5"
        cCorpo += '                             <b>Solicitação de férias aprovada pelo RH. </b> '  //"ETAPA-4  EFETIVADO PELO RH"
    elseif pStatus=="6"
        cCorpo += '                             <b>A Solicitação de férias abaixo foi reprovada pelo RH. </b> '  //"ETAPA-4  REPROVADO PELO RH"
    endif

    cCorpo += '                             <br/><br/> '

    // Definicao do texto/detalhe do email
    For _nLin := 1 to Len(_aMsg)

        For nCol := 1 to Len(_aMsg[nCol])
            if  alltrim(_aMsg[_nLin,nCol,1]) != "Registro:"

                cCorpo += '<span style="font-size: 10pt;">'+ _aMsg[_nLin,nCol,1] +'</span><span style="font-size: 08pt;">'+ _aMsg[_nLin,nCol,2] +'</span><br/>

            Else
                // Adicionado 15/10/2019 - Para Evitar de envios para caso de Reprovação
                RH3->( dbGoto(_aMsg[_nLin,nCol,2]) )
                RecLock("RH3",.F.)
                if pStatus $ '3/5/6'        // Reprovado
                    RH3->RH3_XWFRH := 'F'
                elseif pStatus=='1'         // Solicitação Enviado Gestor
                    RH3->RH3_XWFRH := 'S'
                elseif pStatus=='2'         // Solicitação Enviado ao RH quando Aprovado
                    RH3->RH3_XWFRH := 'G'
                elseif pStatus=='4'         // Ação do RH sendo 3=Rejeitado c/ Dt.Anted preenchida ou 2=Finalziado com Dt.Atend. Preenchida
                    RH3->RH3_XWFRH := 'R'
                endif
                MsUnlock()
            Endif
        Next
    Next
    cCorpo += '                            <br/><br/> '
    if pStatus=="1"
        cCorpo += '                            <p> <span style="font-size: 10pt;">Essa solicitação de férias requer sua aprovação, acesse o portal Meu RH conforme link abaixo;</span> </p> '
        If cempant = '01'
            cCorpo += '                            <p> <span style="font-size: 10pt;">https://meurh.steck.com.br:9101/01/#/login</span> </p> '
        ElseIF cempant = '03'
            cCorpo += '                            <p> <span style="font-size: 10pt;">https://meurh.steck.com.br:9103/03/#/login</span> </p> '
        EndIf'
        cCorpo += '                            <p> <span style="font-size: 10pt;">App para celular Meu RH, mesmo usuário e senha do portal, mas antes de colocar o usuário, precisa informar o QRCODE abaixo no aplicativo;</span> </p> '

        If cempant = '01'
            aadd( _aAttach  ,"QRCODESP.gif")
            cCorpo += ' <p><img src="arquivosmeurhQRCODESP.gif" alt="Smiley face" align="middle" height="250" width="250" ></p> '
        ElseIF cempant = '03'
            aadd( _aAttach  ,"QRCODEAM.gif")
            cCorpo += ' <p><img src="arquivosmeurhQRCODEAM.gif" alt="Smiley face" align="middle" height="250" width="250" ></p> '
        EndIf

        cCorpo += '                            <p> <span style="font-size: 10pt;">Menu/Gestor/Gestão Férias</span> </p> '
        cCorpo += '                            <br/><br/> '
        cCorpo += '                            <p> <font style="font-size: 10pt;font-style: italic; color: #f22222">Importante:</font> '
        cCorpo += '                                <span style="font-size: 10pt;"> Após sua aprovação, essa solicitação será direcionada automaticamente ao RH para aprovação final.</span> </p> '
    EndIf
    cCorpo += '                        </strong> </font> '
    cCorpo += '                </td> '
    cCorpo += '            </tr> '
    cCorpo += '        </tbody> '
    cCorpo += '    </table> <br/> <br /> <br /> '
    cCorpo += ' </body> '
    cCorpo += ' </html> '

    //<<Ticket 20200730004876

    /*
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
	//cCorpo += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

	// Definicao do texto/detalhe do email                                         
    For _nLin := 1 to Len(_aMsg)

        For nCol := 1 to Len(_aMsg[nCol])
            if  alltrim(_aMsg[_nLin,nCol,1]) != "Registro:"
                if  alltrim(_aMsg[_nLin,nCol,1])=="Matricula:"
                    cCorpo += '<TR BgColor=#B0E2FF>'   
                else
                    cCorpo += '<TR BgColor=#FFFFFF>'
                endif
                cCorpo += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,1] + ' </Font></B></TD>'
                cCorpo += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,2] + ' </Font></TD>'
                cCorpo += '</TR>'
            Else
                // Adicionado 15/10/2019 - Para Evitar de envios para caso de Reprovação
                RH3->( dbGoto(_aMsg[_nLin,nCol,2]) )
                RecLock("RH3",.F.)
                if pStatus $ '3/5/6'        // Reprovado
                    RH3->RH3_XWFRH := 'F'
                elseif pStatus=='1'         // Solicitação Enviado Gestor
                    RH3->RH3_XWFRH := 'S'
                elseif pStatus=='2'         // Solicitação Enviado ao RH quando Aprovado
                    RH3->RH3_XWFRH := 'G'
                elseif pStatus=='4'         // Ação do RH sendo 3=Rejeitado c/ Dt.Anted preenchida ou 2=Finalziado com Dt.Atend. Preenchida
                    RH3->RH3_XWFRH := 'R'  
                endif
                MsUnlock()
            Endif
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
	*/	

   // _cEmail := "everson.santana@steck.com.br"
    U_STMAILTES(_cEmail, _cCopEmal, _cAssunto, cCorpo, _aAttach , _cCaminho)

    RestArea(aArea)
Return()
