#include "Totvs.ch"

/*
 * Customizacao para aprovacao de titulos no Aprovador
 */

// User Function chamada pelo Aprovador para buscar documentos pendentes
// Parametros:
//   - dSinceDate.....: data a partir de quando as pendencias serao buscadas.
//   - nLastId........: [Paginacao] RECNO da ultima SC retornada pela pesquisa anterior.
//   - nLimit.........: [Paginacao] Quantidade maxima de registros a serem retornados.
//   - @nRefLastId....: [Paginacao] Deve ser setado com o ultimo RECNO encontrado na pesquisa.
//   - @cRefError.....: caso ocorra algum erro na funcao, deve ser setado nesta variavel.
//   - Return aDocRets: array com dados das SCs a serem enviadas para o Aprovador.
User Function ZAPVAT1L(dSinceDate, nLastId, nLimit, nRefLastId, cRefError)
    Local cSql, aArea, cAlias, aRecnos
    Local aDocsRet := {}
    Local aDoc     := {}
    Local aMdata   := {}
    Local cTxtMsg, cTxtValue, cCurrentId, cDocId, cRecnos, cValor, cSaldo, cNome, nPos, aUsers

    cRefError := ""

    // Busca RECNOS pendentes da SE2
    aRecnos := fGetRecAT(dSinceDate, nLastId, nLimit, @nRefLastId)
    
    If Len(aRecnos) == 0
        Return aDocsRet
    EndIf

    // Cria aDocs com SE2 pendentes
    aArea  := GetArea()
    cAlias := GetNextAlias()

    cSql := " SELECT SE2.R_E_C_N_O_ RECNOSE2, SE2.E2_FILIAL, SE2.E2_FILORIG, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, " 
    cSql += " SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NOMFOR, SE2.E2_EMISSAO, SE2.E2_VENCTO, SE2.E2_VENCREA, SE2.E2_VALOR, "
    cSql += " SE2.E2_HIST, SE2.E2_SALDO, SE2.E2_TIPO, SE2.E2_ORIGEM, SE2.E2_XAPROV, SE2.E2_MOEDA, SE2.E2_USRINC " 
    cSql += "   FROM " + RetSQLTab("SE2")
    cSql += "   WHERE SE2.R_E_C_N_O_ IN (" + StrTran(ArrTokStr(aRecnos), "|", ",") + ")"
    cSql += " ORDER BY SE2.R_E_C_N_O_"

    DBUseArea(.T., "TOPCONN", TCGenQry(,,cSql), cAlias, .F., .T.)
    TCSetField(cAlias, "E2_EMISSAO", "D")
    TCSetField(cAlias, "E2_VENCTO" , "D")
    TCSetField(cAlias, "E2_VENCREA", "D")
    
    If !(cAlias)->(EOF())
        Do while !(cAlias)->(EOF())

            cCurrentId := cValToChar((cAlias)->E2_NUM) + "#" + cValToChar((cAlias)->E2_PARCELA) 

            If !(cCurrentId == cDocId)
                If !Empty(cDocId)

                    // Colecoes
                    AAdd(aDoc, {})

                    // Anexos
                    AAdd(aDoc, {})

                    // Tags
                    AAdd(aDoc, {"Aprovação de Título"}) 

                    AAdd(aDocsRet, aDoc)
                End

                // Novo Doc
                aDoc      := {}
                cRecnos   := cValToChar((cAlias)->RECNOSE2)
                cTxtMsg   := IIF((cAlias)->E2_HIST <> "",  (cAlias)->E2_HIST, "-")
                cTxtValue := AllTrim(Transform((cAlias)->E2_VALOR, "@E 99,999,999,999.99"))

                // Cabecalho
                AAdd(aDoc, {cValToChar((cAlias)->RECNOSE2),;                 // 1  R_E_C_N_O_
                            cFilAnt,;                                        // 2  FILIAL
                            "ZAPVSE2",;                                      // 3  ID da customizacao no Aprovador Conector
                            fGetAprovs(cAlias),;                             // 4  aprovadorUsers (array com e-mail dos aprovadores)
                            "Esp_Steck_AT",;                                 // 5  layoutId
                            "",;                                             // 6  companyName 
                            FWTimeStamp(5, (cAlias)->E2_EMISSAO, "00:00"),;  // 7  creationDate
                            "",;                                             // 8  dueDate
                            "-",;                                            // 9  textFrom
                            "Aprovacao de Titulo",;                          // 10 textSubject
                            cTxtMsg,;                                        // 11 textMessage
                            cTxtValue,;                                      // 12 textValue
                            "Valor",;                                        // 13 labelValue
                            cValToChar((cAlias)->E2_NUM)})                   // 14 textId

                // Metadados

                If (cAlias)->E2_MOEDA == 1
                    cValor := "R$ " + AllTrim(Transform((cAlias)->E2_VALOR, "@E 99,999,999,999.99"))
                    cSaldo := "R$ " + AllTrim(Transform((cAlias)->E2_SALDO, "@E 99,999,999,999.99"))
                Else
                    cValor := Transform((cAlias)->E2_VALOR, "@E 99,999,999,999.99")
                    cSaldo := Transform((cAlias)->E2_SALDO, "@E 99,999,999,999.99")
                EndIf

                If ! Empty((cAlias)->E2_USRINC)
                    aUsers := FWSFAllUsers()
                    nPos   := AScan(aUsers, {|x| Lower(AllTrim(x[2])) == Lower(AllTrim((cAlias)->E2_USRINC))})
            
                    If nPos > 0
                        cNome := AllTrim(aUsers[nPos, 4])
                    EndIf
                EndIf
                
                aMdata := {{"RECNOSE2"  , "", "", cValToChar((cAlias)->RECNOSE2)},;
                           {"E2_FILIAL" , "", "", AllTrim((cAlias)->E2_FILIAL)},;
                           {"E2_PREFIXO"    , "", "", AllTrim((cAlias)->E2_PREFIXO)},;
                           {"E2_NUM"   , "", "", AllTrim((cAlias)->E2_NUM)},;
                           {"E2_PARCELA", "", "", AllTrim((cAlias)->E2_PARCELA)},;
                           {"E2_FORNECE" , "", "", AllTrim((cAlias)->E2_FORNECE)},;
                           {"E2_LOJA" , "", "", AllTrim((cAlias)->E2_LOJA)},;
                           {"E2_NOMFOR", "", "", AllTrim((cAlias)->E2_NOMFOR)},;
                           {"E2_EMISSAO"  , "", "", cValToChar((cAlias)->E2_EMISSAO)},;
                           {"E2_HIST"  , "", "", AllTrim((cAlias)->E2_HIST)},;
                           {"E2_SALDO"     , "", "", AllTrim(cSaldo)},;
                           {"E2_VALOR"     , "", "", AllTrim(cValor)},;
                           {"E2_VENCTO", "", "", cValToChar((cAlias)->E2_VENCTO)},;
                           {"E2_VENCREA"  , "", "", cValToChar((cAlias)->E2_VENCREA)},;
                           {"E2_TIPO"    , "", "", AllTrim((cAlias)->E2_TIPO)},;
                           {"E2_USRINC", "", "", AllTrim(cNome)},;
                           {"E2_ORIGEM", "", "", AllTrim((cAlias)->E2_ORIGEM)}}

                AAdd(aDoc, aMdata)
            EndIf

            cDocId := cValToChar((cAlias)->E2_NUM) + "#" + cValToChar((cAlias)->E2_PARCELA)

            (cAlias)->(DBSkip())
        EndDo

        // Colecoes
        AAdd(aDoc, {})

        // Anexos
        AAdd(aDoc, {})

        // Tags
        AAdd(aDoc, {"Aprovação de Titulo"}) 

        AAdd(aDocsRet, aDoc)
    EndIF

    RestArea(aArea)
Return aDocsRet

Static Function fGetRecAT(dSinceDate, nLastId, nLimit, nRefLastId)
    Local cSql    := ""
    Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
    Local aRecnos := {}

    Default nLastId    := 0
    Default nRefLastId := 0

    If nLastId == 0
        cSql := " SELECT * FROM ("
        cSql += " SELECT R_E_C_N_O_ RECNOSE2 FROM " + RETSQLTAB("SE2")
        cSql += " WHERE SE2.E2_EMISSAO >= '" + DtoS(dSinceDate) + "'""
        cSql += "   AND SE2.D_E_L_E_T_  = ' '
        cSql += " ORDER BY SE2.R_E_C_N_O_"
        cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

        DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
        TCSetfield(cAlias, "RECNOSE2", "N", 10, 0)  

        If !(cAlias)->(EOF())
            nLastId := (cAlias)->RECNOSE2
        EndIf

        nLastId -= 1

        (cAlias)->(DBCloseArea())
        RestArea(aArea)
    EndIF

    cSql := " SELECT * FROM ("
    cSql += " SELECT R_E_C_N_O_ RECNOSE2 FROM " + RETSQLTAB("SE2")
    cSql += " WHERE SE2.E2_FILIAL  = '" + xFilial("SE2") + "'"
    cSql += "   AND SE2.R_E_C_N_O_ > " + cValToChar(nLastId) 
    cSql += "   AND SE2.E2_XBLQ IN ('1','5','6')
    cSql += "   AND SE2.D_E_L_E_T_  = ' '
    cSql += " ORDER BY SE2.R_E_C_N_O_"
    cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

    DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
    TCSetfield(cAlias, "RECNOSE2", "N", 10, 0)   

    If !(cAlias)->(EOF())
        Do while !(cAlias)->(EOF())
            
            nRefLastId := (cAlias)->RECNOSE2
            AAdd(aRecnos, (cAlias)->RECNOSE2)
            
            (cAlias)->(DBSkip())
        EndDo
    EndIF

    (cAlias)->(DBCloseArea())
    RestArea(aArea)
Return aRecnos

Static Function fGetAprovs(cAlias)
    Local E2Aprov := (cAlias)->E2_XAPROV
    
    // lista de aprovadores que sera enviada para o Aprovador
    Local aRet 
    
    // lista de Id dos aprovadores parametrizados na C1_ZAPROV
    Local aIDs

    /*ConOut("fGetAprovs")
    ConOut("E2_FILIAL: "  + (cAlias)->E2_FILIAL)
    ConOut("E2_PREFIXO: " + (cAlias)->E2_PREFIXO)
    ConOut("E2_NUM: "     + (cAlias)->E2_NUM)
    ConOut("E2_XAPROV: "  + (cAlias)->E2_XAPROV)*/

    aIDs := {AllTrim(E2Aprov)}

    // Formato do array aprovadorUsers:
    // [1]: array de e-mail dos aprovadores (opcional)
    // [2]: array de ids dos aprovadores (opcional)
    // [3]: array de login dos aprovadores (opcional)
    aRet := {, aIDs}

    /*ConOut("aRet: " + ArrTokStr(aRet))
    ConOut("---" + CRLF)*/
Return aRet

// User Function chamada pelo Aprovador para processar as aprovacoes
// Parametros:
//   - aDoc: array com informacoes do documento a ser processado:
//       [1]: R_E_C_N_O 
//       [2]: FILIAL
//       [3]: Array aUser:
//         [1]: ID do usuario com 6 caracteres
//         [2]: login do usuario
//       [4]: cStatus: com os possiveis valores:
//         "approved": documento aprovado
//         "rejected": documento reprovado
//       [5]: cObs: observação digitada na aprovacao/reprovacao
//   - cRefError: se ocorrer alum erro no processamento, deve ser preenchida. 
//                Erro sera exibido para o usuario no Aprovador.
User Function ZAPVAT1P(aDoc, cRefError)
    Local aArea    := GetArea()
    Local _aBkpUsr := {__cUserId, cUserName}
    Local aAprova  := {}
    Local nOpca, cObsRep, cRecno

    cRefError := ""
    cRecno    := aDoc[1]

    DBSelectArea("SE2")

    SE2->(DBGoTo(Val(cRecno)))

    If ! SE2->(EOF()) .AND. ! SE2->(Deleted())
        AAdd(aAprova,{Val(cRecno), SE2->E2_FILIAL, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA})
    EndIf

    If Empty(aAprova)
        cRefError := "Registro SE2 nao encontrado ou deletado."
    Else
        nOpca    := IIF(aDoc[4] == "approved", 3, 2)
        cObsRep := aDoc[5]

        // Seta variaveis de login para o usuario que aprovou/reprovou
        __cUserId  := aDoc[3, 1] // ID do usuario
        cUserName  := aDoc[3, 2] // Login do usuario
    EndIf

    SE2->(DBCloseArea())
    RestArea(aArea)

    // Se nao ocorreu erro acima, processa a aprovacao e volta o login anterior.
    If Empty(cRefError)
        U_FIN004A(nOpca, aAprova, cObsRep, @cRefError)

        // Volta login
        __cUserId  := _aBkpUsr[1]
        cUserName  := _aBkpUsr[2]
    EndIf
Return
