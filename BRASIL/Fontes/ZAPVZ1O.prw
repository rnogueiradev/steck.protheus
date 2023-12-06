#include "Totvs.ch"

/*
 * Customizacao para aprovacao de Reembolso de despesas no Aprovador
 */

// User Function chamada pelo Aprovador para buscar documentos pendentes
// Parametros:
//   - dSinceDate.....: data a partir de quando as pendencias serao buscadas.
//   - nLastId........: [Paginacao] RECNO da ultima Reembolso de despesa retornada pela pesquisa anterior.
//   - nLimit.........: [Paginacao] Quantidade maxima de registros a serem retornados.
//   - @nRefLastId....: [Paginacao] Deve ser setado com o ultimo RECNO encontrado na pesquisa.
//   - @cRefError.....: caso ocorra algum erro na funcao, deve ser setado nesta variavel.
//   - Return aDocRets: array com dados das SCs a serem enviadas para o Aprovador.
User Function ZAPVZ1OL(dSinceDate, nLastId, nLimit, nRefLastId, cRefError)
    Local cSql, aArea, cAlias, aRecnos
    Local aDocsRet := {}
    Local aDoc     := {}
    Local aMdata   := {}
    Local aItens   := {}
    Local aItem    := {}
    Local aMdataIt := {}
    Local cTxtMsg, cTxtFrom, cCurrentId, cDocId, nTextValue

    cRefError := ""

    // Busca RECNOS pendentes da Z1O
    aRecnos := fGetRecRD(dSinceDate, nLastId, nLimit, @nRefLastId)
    
    If Len(aRecnos) == 0
        Return aDocsRet
    EndIf
  
    // Cria aDocs com Z1O pendentes
    aArea  := GetArea()
    cAlias := GetNextAlias()

    cSql := " SELECT Z1O.R_E_C_N_O_ RECNOZ1O, Z1O.Z1O_COD, Z1O.Z1O_NOME, Z1O.Z1O_EMISSA, Z1P.Z1P_ITEM, Z1P.Z1P_TIPO, Z1P.Z1P_DESC, Z1P.Z1P_DATA, Z1P.Z1P_VALOR, "
    cSql += "        Z1M.Z1M_APRO "
    cSql += "   FROM " + RetSQLTab("Z1O") 
    cSql += "   INNER JOIN " + RetSQLTab("Z1P") 
    cSql += "      ON Z1P.Z1P_COD = Z1O.Z1O_COD "
    cSql += "     AND Z1P.D_E_L_E_T_ = ' ' "
    cSql += "   INNER JOIN " + RetSQLTab("Z1N") 
    cSql += "      ON Z1N.Z1N_USER = Z1O.Z1O_USER "
    cSql += "     AND Z1N.D_E_L_E_T_ = ' ' "
    cSql += "   INNER JOIN " + RetSQLTab("Z1M")
    cSql += "      ON Z1M_COD = Z1N_COD "
    cSql += "     AND Z1M.D_E_L_E_T_ = ' '"
    cSql += "   WHERE Z1O.R_E_C_N_O_ IN (" + StrTran(ArrTokStr(aRecnos), "|", ",") + ")"
    cSql += " ORDER BY Z1O.R_E_C_N_O_"

    DBUseArea(.T., "TOPCONN", TCGenQry(,,cSql), cAlias, .F., .T.)
    TCSetField(cAlias, "Z1O_EMISSA", "D")
    TCSetfield(cAlias, "Z1P_VALOR", "N", 10, 2)
    TCSetField(cAlias, "Z1P_DATA", "D")

    If !(cAlias)->(EOF())
        Do while !(cAlias)->(EOF())
            cCurrentId := cValToChar((cAlias)->Z1O_COD) 

            If !(cCurrentId == cDocId)
                If(!Empty(cDocId))
                    // TextValue
                    aDoc[1,12] := cValToChar(nTextValue)
                
                    // Colecoes
                    AAdd(aDoc, aItens)

                    // Anexos
                    AAdd(aDoc, {})

                    // Tags
                    AAdd(aDoc, {"Aprovação de Reembolso de Despesa"}) 

                    AAdd(aDocsRet, aDoc)
                EndIf

                // Novo Doc
                aDoc    := {}
                aItens  := {}
                aItem   := {}
                
                cTxtMsg  := "Codigo: " + (cAlias)->Z1O_COD + ". Nome: " +  AllTrim((cAlias)->Z1O_NOME) + ". "
                cTxtFrom := IIF( Empty((cAlias)->Z1O_NOME), "-", AllTrim((cAlias)->Z1O_NOME))

                /* ira acumular os valores dos itens */
                nTextValue := 0

                // Cabecalho
                AAdd(aDoc, {cValToChar((cAlias)->RECNOZ1O),;                 // 1  R_E_C_N_O_
                            cFilAnt,;                                        // 2  FILIAL
                            "ZAPVZ1O",;                                      // 3  ID da customizacao no Aprovador Conector
                            fGetAprRD(cAlias),;                              // 4  aprovadorUsers (array com e-mail dos aprovadores)
                            "Esp_Steck_RD",;                                 // 5  layoutId
                            "",;                                             // 6  companyName 
                            FWTimeStamp(5, (cAlias)->Z1O_EMISSA, "00:00"),;  // 7  creationDate
                            "",;                                             // 8  dueDate
                            cTxtFrom,;                                       // 9  textFrom
                            "Aprovação de Reembolso de Despesas",;           // 10 textSubject
                            cTxtMsg,;                                        // 11 textMessage
                            "",;                                             // 12 textValue
                            "Valor",;                                        // 13 labelValue
                            (cAlias)->Z1O_COD})                              // 14 textId

                // Metadados
                aMdata := {{"RECNOZ1O"  , "", "", cValToChar((cAlias)->RECNOZ1O)},;
                           {"Z1O_COD"   , "", "", AllTrim((cAlias)->Z1O_COD)},;
                           {"Z1O_EMISSA", "", "", AllTrim(DToC((cAlias)->Z1O_EMISSA))},;
                           {"Z1O_NOME"  , "", "", AllTrim((cAlias)->Z1O_NOME)}}

                AAdd(aDoc, aMdata)
            EndIf

            nTextValue += (cAlias)->Z1P_VALOR
            cDocId     := cCurrentId

            aMdataIt := {{"Z1P_ITEM" , "", "", AllTrim((cAlias)->Z1P_ITEM)},;
                         {"Z1P_TIPO" , "", "", AllTrim((cAlias)->Z1P_TIPO)},;
                         {"Z1P_DESC" , "", "", AllTrim((cAlias)->Z1P_DESC)},;
                         {"Z1P_DATA" , "", "", AllTrim(DToC((cAlias)->Z1P_DATA))},;
                         {"Z1P_VALOR", "", "", cValToChar((cAlias)->Z1P_VALOR)}}
            
            aItem := {"",;
                      AllTrim((cAlias)->Z1P_ITEM),; 
                      AllTrim((cAlias)->Z1P_DESC)}
            
            AAdd(aItem, aMdataIt)
            AAdd(aItens, aItem)
              
            (cAlias)->(DBSkip())
        EndDo

        aDoc[1,12] := cValToChar(nTextValue)

        // Colecoes
        AAdd(aDoc, aItens)

        // Anexos
        AAdd(aDoc, {})

        // Tags
        AAdd(aDoc, {"Aprovação de Reembolso de despesas"}) 

        AAdd(aDocsRet, aDoc)
    EndIF

    (cAlias)->(DBCloseArea())
    RestArea(aArea)
Return aDocsRet

Static Function fGetRecRD(dSinceDate, nLastId, nLimit, nRefLastId)
    Local cSql    := ""
    Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
    Local aRecnos := {}  

    Default nLastId    := 0
    Default nRefLastId := 0

    If nLastId == 0
        cSql := " SELECT * FROM ("
        cSql += " SELECT R_E_C_N_O_ RECNOZ1O FROM " + RETSQLTAB("Z1O")
        cSql += " WHERE Z1O.Z1O_EMISSA >= '" + DtoS(dSinceDate) + "'""
        cSql += "   AND Z1O.D_E_L_E_T_  = ' '
        cSql += " ORDER BY Z1O.R_E_C_N_O_"
        cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

        DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
        TCSetfield(cAlias, "RECNOZ1O", "N", 10, 0)  

        If !(cAlias)->(EOF())
            nLastId := (cAlias)->RECNOZ1O
        EndIf

        nLastId -= 1

        (cAlias)->(DBCloseArea())
        RestArea(aArea)
    EndIF

    cSql := " SELECT * FROM ("
    cSql += " SELECT R_E_C_N_O_ RECNOZ1O FROM " + RETSQLTAB("Z1O") 
    cSql += " WHERE Z1O.R_E_C_N_O_ > " + cValToChar(nLastId) 
    cSql += "   AND Z1O.Z1O_STATUS = '2'
    cSql += "   AND Z1O.D_E_L_E_T_  = ' '
    cSql += " ORDER BY Z1O.R_E_C_N_O_"
    cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

    DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
    TCSetfield(cAlias, "RECNOZ1O", "N", 10, 0)   

    If !(cAlias)->(EOF())
        Do while !(cAlias)->(EOF())

            AAdd(aRecnos, (cAlias)->RECNOZ1O)
            nRefLastId := (cAlias)->RECNOZ1O
            
            (cAlias)->(DBSkip())
        EndDo
    EndIf

    (cAlias)->(DBCloseArea())
    RestArea(aArea)
Return aRecnos

Static Function fGetAprRD(cAlias)
    Local Z1MAprov := (cAlias)->Z1M_APRO
    
    // lista de aprovadores que sera enviada para o Aprovador
    Local aRet 
    
    // lista de Id dos aprovadores parametrizados na Z1M_APRO
    Local aIDs

    If !Empty(AllTrim(GetMv("ZAPVZ1O001",,"")))
        If !Z1MAprov $ AllTrim(GetMv("ZAPVZ1O001",,""))
            Z1MAprov := ""
        EndIf
    EndIf

    ConOut("fGetAprovs")
    ConOut("Z1O_COD: "  + (cAlias)->Z1O_COD)
    ConOut("Z1M_APRO: " + (cAlias)->Z1M_APRO)

    aIDs := {AllTrim(Z1MAprov)}

    // Formato do array aprovadorUsers:
    // [1]: array de e-mail dos aprovadores (opcional)
    // [2]: array de ids dos aprovadores (opcional)
    // [3]: array de login dos aprovadores (opcional)
    aRet := {, aIDs}

    ConOut("aRet: " + ArrTokStr(aRet))
    ConOut("---" + CRLF)
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
User Function ZAPVZ1OP(aDoc, cRefError)
    Local aArea    := GetArea()
    Local _aBkpUsr := {__cUserId, cUserName}
    Local aAprova  := {}
    Local cObsRep, cRecno

    cRefError := ""
    cRecno    := aDoc[1]

    DBSelectArea("Z1O")

    Z1O->(DBGoTo(Val(cRecno)))

    If ! Z1O->(EOF()) .AND. ! Z1O->(Deleted())
        AAdd(aAprova, cRecno)
        AAdd(aAprova, Z1O->Z1O_COD)
    EndIf

    Z1O->(DBCloseArea())
    RestArea(aArea)
    
    If Empty(aAprova)
        cRefError := "Registro Z1O nao encontrado ou deletado."
    Else
        cObsRep := aDoc[5]

        // Seta variaveis de login para o usuario que aprovou/reprovou
        __cUserId  := aDoc[3, 1] // ID do usuario
        cUserName  := aDoc[3, 2] // Login do usuario
    EndIf

    // Se nao ocorreu erro acima, processa a aprovacao e volta o login anterior.
    If Empty(cRefError)
        If aDoc[4] == "approved"
            U_STAPREM(aAprova, cObsRep, @cRefError)
        Else
            U_STREREM(aAprova, cObsRep, @cRefError)
        EndIf

        // Volta login
        __cUserId  := _aBkpUsr[1]
        cUserName  := _aBkpUsr[2]
    EndIf 
Return
