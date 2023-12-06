#include "Totvs.ch"

/*
 * Customizacao para aprovacao de SC1 no Aprovador
 */

// User Function chamada pelo Aprovador para buscar documentos pendentes
// Parametros:
//   - dSinceDate.....: data a partir de quando as pendencias serao buscadas.
//   - nLastId........: [Paginacao] RECNO da ultima SC retornada pela pesquisa anterior.
//   - nLimit.........: [Paginacao] Quantidade maxima de registros a serem retornados.
//   - @nRefLastId....: [Paginacao] Deve ser setado com o ultimo RECNO encontrado na pesquisa.
//   - @cRefError.....: caso ocorra algum erro na funcao, deve ser setado nesta variavel.
//   - Return aDocRets: array com dados das SCs a serem enviadas para o Aprovador.
User Function ZAPVSC1L(dSinceDate, nLastId, nLimit, nRefLastId, cRefError)
    Local cSql, aArea, cAlias, aRecnos
    Local aDocsRet := {}
    Local aDoc     := {}
    Local aMdata   := {}
    Local aItens   := {}
    Local aItem    := {}
    Local aMdataIt := {}
    Local cTxtMsg, cTxtFrom, cTxtValue, cCurrentId, cDocId, cRecnos

    cRefError := ""

    // Busca RECNOS pendentes da SC1
    aRecnos := fGetRecnos(dSinceDate, nLastId, nLimit, @nRefLastId)
    
    If Len(aRecnos) == 0
        Return aDocsRet
    EndIf

    // Cria aDocs com SC1 pendentes
    aArea  := GetArea()
    cAlias := GetNextAlias()

    cSql := " SELECT SC1.R_E_C_N_O_ RECNOSC1, SC1.C1_FILIAL, SC1.C1_NUM, SC1.C1_ITEM, SC1.C1_PRODUTO, SC1.C1_DESCRI, SC1.C1_SOLICIT, SC1.C1_QUANT, SC1.C1_CONTA, SC1.C1_CC, SC1.C1_EMISSAO, SC1.C1_TOTAL, " 
    cSql += "        SC1.C1_OBS, CTT.CTT_DESC01, SC1.C1_ZAPROV, SC1.C1_DATPRF, "
    cSql += "        SB1.B1_DESC, SB1.B1_UM " 
    cSql += "   FROM " + RetSQLTab("SC1") 
    cSql += "   INNER JOIN " + RetSQLTab("SB1") 
    cSql += "      ON SB1.B1_FILIAL      = " + ValToSQL(xFilial("SB1"))
    cSql += "     AND SB1.B1_COD         = SC1.C1_PRODUTO "
    cSql += "     AND SB1.D_E_L_E_T_ = ' ' "
    cSql += "   LEFT JOIN " + RetSQLTab("CTT")
    cSql += "      ON CTT_FILIAL     = " + ValToSQL(xFilial("CTT"))
    cSql += "     AND CTT_CUSTO      = SC1.C1_CC "
    cSql += "     AND CTT.D_E_L_E_T_ = ' '"
    cSql += "   WHERE SC1.R_E_C_N_O_ IN (" + StrTran(ArrTokStr(aRecnos), "|", ",") + ")"
    cSql += " ORDER BY SC1.R_E_C_N_O_"

    DBUseArea(.T., "TOPCONN", TCGenQry(,,cSql), cAlias, .F., .T.)
    TCSetField(cAlias, "C1_EMISSAO", "D")

    If !(cAlias)->(EOF())
        Do while !(cAlias)->(EOF())

            cCurrentId := CValToChar((cAlias)->C1_FILIAL) + "#" + CValToChar((cAlias)->C1_NUM) 

            If !(cCurrentId == cDocId)
                If !Empty(cDocId)

                    aDoc[1,1] := cRecnos

                    // Colecoes
                    AAdd(aDoc, aItens)

                    // Anexos
                    AAdd(aDoc, {})

                    // Tags
                    AAdd(aDoc, {"Aprovação de SC"}) 

                    AAdd(aDocsRet, aDoc)
                End

                // Novo Doc
                aDoc    := {}
                aItens  := {}
                aItem   := {}
                cRecnos := cValToChar((cAlias)->RECNOSC1)

                cTxtMsg := "Filial " + (cAlias)->C1_FILIAL + ". Numero " + (cAlias)->C1_NUM + ". " 

                If !Empty((cAlias)->C1_OBS)
                    cTxtMsg += CRLF + "Observações: " + AllTrim((cAlias)->C1_OBS)
                EndIf

                /* confirmar */
                cTxtFrom  := IIF( Empty((cAlias)->C1_SOLICIT), "-", (cAlias)->C1_SOLICIT )
                cTxtValue := IIF( Empty((cAlias)->C1_TOTAL), "-", cValToChar((cAlias)->C1_TOTAL) )

                // Cabecalho
                AAdd(aDoc, {"",;                                             // 1  R_E_C_N_O_
                            cFilAnt,;                                        // 2  FILIAL
                            "ZAPVSC1",;                                      // 3  ID da customizacao no Aprovador Conector
                            fGetAprovs(cAlias),;                             // 4  aprovadorUsers (array com e-mail dos aprovadores)
                            "Esp_Steck_SC",;                                 // 5  layoutId
                            "",;                                             // 6  companyName 
                            FWTimeStamp(5, (cAlias)->C1_EMISSAO, "00:00"),;  // 7  creationDate
                            "",;                                             // 8  dueDate
                            cTxtFrom,;                                       // 9  textFrom
                            "Aprovação de SC",;                              // 10 textSubject
                            cTxtMsg,;                                        // 11 textMessage
                            cTxtValue,;                                      // 12 textValue
                            "Valor",;                                        // 13 labelValue
                            (cAlias)->C1_NUM})                               // 14 textId

                // Metadados
                aMdata := {{"RECNOSC1"  , "", "", cValToChar((cAlias)->RECNOSC1)},;
                           {"C1_FILIAL" , "", "", AllTrim((cAlias)->C1_FILIAL)},;
                           {"C1_NUM"    , "", "", AllTrim((cAlias)->C1_NUM)},;
                           {"C1_ITEM"   , "", "", AllTrim((cAlias)->C1_ITEM)},;
                           {"C1_PRODUTO", "", "", AllTrim((cAlias)->C1_PRODUTO)},;
                           {"C1_DESCRI" , "", "", AllTrim((cAlias)->C1_DESCRI)},;
                           {"C1_DATPRF" , "", "", AllTrim((cAlias)->C1_DATPRF)},;
                           {"C1_SOLICIT", "", "", AllTrim((cAlias)->C1_SOLICIT)},;
                           {"C1_QUANT"  , "", "", cValToChar((cAlias)->C1_QUANT)},;
                           {"C1_CONTA"  , "", "", AllTrim((cAlias)->C1_CONTA)},;
                           {"C1_CC"     , "", "", AllTrim((cAlias)->C1_CC)},;
                           {"C1_EMISSAO", "", "", cValToChar((cAlias)->C1_EMISSAO)},;
                           {"C1_TOTAL"  , "", "", cValToChar((cAlias)->C1_TOTAL)},;
                           {"C1_OBS"    , "", "", AllTrim((cAlias)->C1_OBS)},;
                           {"CTT_DESC01", "", "", AllTrim((cAlias)->CTT_DESC01)},;
                           {"C1_ZAPROV"  , "", "", AllTrim((cAlias)->C1_ZAPROV)},;
                           {"B1_DESC"   , "", "", AllTrim((cAlias)->B1_DESC)},;
                           {"B1_UM"     , "", "", AllTrim((cAlias)->B1_UM)}}

                AAdd(aDoc, aMdata)
            EndIf

            If cDocId == cCurrentId
                //cRecnos += "#" + cValToChar((cAlias)->RECNOSC1)
            EndIf

            cDocId  := cCurrentId

            aMdataIt := {{"RECNOSC1"  , "", "", cValToChar((cAlias)->RECNOSC1)},;
                         {"C1_FILIAL" , "", "", AllTrim((cAlias)->C1_FILIAL)},;
                         {"C1_NUM"    , "", "", AllTrim((cAlias)->C1_NUM)},;
                         {"C1_ITEM"   , "", "", AllTrim((cAlias)->C1_ITEM)},;
                         {"C1_PRODUTO", "", "", AllTrim((cAlias)->C1_PRODUTO)},;
                         {"C1_DESCRI" , "", "", AllTrim((cAlias)->C1_DESCRI)},;
                         {"C1_DATPRF" , "", "", AllTrim((cAlias)->C1_DATPRF)},;
                         {"C1_SOLICIT", "", "", AllTrim((cAlias)->C1_SOLICIT)},;
                         {"C1_QUANT"  , "", "", cValToChar((cAlias)->C1_QUANT)},;
                         {"C1_EMISSAO", "", "", cValToChar((cAlias)->C1_EMISSAO)},;
                         {"C1_TOTAL"  , "", "", cValToChar((cAlias)->C1_TOTAL)},;
                         {"C1_ZAPROV"  , "", "", AllTrim((cAlias)->C1_ZAPROV)},;
                         {"B1_DESC"   , "", "", AllTrim((cAlias)->B1_DESC)},;
                         {"B1_UM"     , "", "", AllTrim((cAlias)->B1_UM)},;
                         {"C1_CONTA"  , "", "", AllTrim((cAlias)->C1_CONTA)},;
                         {"C1_CC"     , "", "", AllTrim((cAlias)->C1_CC)},;
                         {"C1_OBS"    , "", "", AllTrim((cAlias)->C1_OBS)},;
                         {"CTT_DESC01", "", "", AllTrim((cAlias)->CTT_DESC01)}}
            
            aItem := {"",;
                      AllTrim((cAlias)->C1_PRODUTO),; 
                      AllTrim((cAlias)->B1_DESC)}
            
            AAdd(aItem, aMdataIt)
            AAdd(aItens, aItem)
              
            (cAlias)->(DBSkip())
        EndDo

        aDoc[1,1] := cRecnos

        // Colecoes
        AAdd(aDoc, aItens)

        // Anexos
        AAdd(aDoc, {})

        // Tags
        AAdd(aDoc, {"Aprovação de SC"}) 

        AAdd(aDocsRet, aDoc)
    EndIF

    RestArea(aArea)
Return aDocsRet

Static Function fGetRecnos(dSinceDate, nLastId, nLimit, nRefLastId)
    Local cSql    := ""
    Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
    Local aRecnos := {}
    Local cDoc    := ""
    Local aRecnosDoc := {}
    Local nI, cCurrentId, nCont   

    Default nLastId    := 0
    Default nRefLastId := 0

    If nLastId == 0
        cSql := " SELECT * FROM ("
        cSql += " SELECT R_E_C_N_O_ RECNOSC1 FROM " + RETSQLTAB("SC1")
        cSql += " WHERE SC1.C1_EMISSAO >= '" + DtoS(dSinceDate) + "'""
        cSql += "   AND SC1.D_E_L_E_T_  = ' '
        cSql += " ORDER BY SC1.R_E_C_N_O_"
        cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

        DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
        TCSetfield(cAlias, "RECNOSC1", "N", 10, 0)  

        If !(cAlias)->(EOF())
            nLastId := (cAlias)->RECNOSC1
        EndIf

        nLastId -= 1

        (cAlias)->(DBCloseArea())
        RestArea(aArea)
    EndIF

    cSql := " SELECT * FROM ("
    cSql += " SELECT R_E_C_N_O_ RECNOSC1, SC1.C1_NUM FROM " + RETSQLTAB("SC1")
    cSql += " WHERE SC1.C1_FILIAL  = '" + xFilial("SC1") + "'"
    cSql += "   AND SC1.R_E_C_N_O_ > " + cValToChar(nLastId) 
    cSql += "   AND SC1.C1_ZSTATUS IN ('1','2')
    cSql += "   AND C1_TPOP <> 'P'
    cSql += "   AND SC1.D_E_L_E_T_  = ' '
    cSql += " ORDER BY SC1.R_E_C_N_O_"
    cSql += " ) WHERE ROWNUM <= " + cValToChar(nLimit)

    DBUseArea(.T., "TOPCONN", TCGENQRY(,,cSql), cAlias, .F., .T.)
    TCSetfield(cAlias, "RECNOSC1", "N", 10, 0)   

    If !(cAlias)->(EOF())
        cDoc  := (cAlias)->C1_NUM
        nCont := 0
        
        Do while !(cAlias)->(EOF())
            cCurrentId := (cAlias)->C1_NUM

            If cDoc == cCurrentId
                AAdd(aRecnosDoc, (cAlias)->RECNOSC1)
            Else 
                For nI := 1 To Len(aRecnosDoc)
                    AAdd(aRecnos, aRecnosDoc[nI])
                Next    
                nRefLastId := aRecnosDoc[Len(aRecnosDoc)]
                aRecnosDoc := {(cAlias)->RECNOSC1}
                cDoc       := (cAlias)->C1_NUM
            EndIf
            nCont += 1
            (cAlias)->(DBSkip())
        EndDo

        If nCont > 0 .AND. nCont < nLimit
            For nI := 1 To Len(aRecnosDoc)
                    AAdd(aRecnos, aRecnosDoc[nI])
            Next    
            nRefLastId := aRecnosDoc[Len(aRecnosDoc)]
        EndIf
    EndIF

    (cAlias)->(DBCloseArea())
    RestArea(aArea)
Return aRecnos

Static Function fGetAprovs(cAlias)
    Local c1Aprov := (cAlias)->C1_ZAPROV
    
    // lista de aprovadores que sera enviada para o Aprovador
    Local aRet 
    
    // lista de Id dos aprovadores parametrizados na C1_ZAPROV
    Local aIDs

    ConOut("fGetAprovs")
    ConOut("C1_FILIAL: " + (cAlias)->C1_FILIAL)
    ConOut("C1_NUM: " + (cAlias)->C1_NUM)
    ConOut("C1_ZAPROV: " + (cAlias)->C1_ZAPROV)

    aIDs := {AllTrim(c1Aprov)}

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
User Function ZAPVSC1P(aDoc, cRefError)
    Local aArea    := GetArea()
    Local _aBkpUsr := {__cUserId, cUserName}
    Local aAprova  := {}
    Local nOpca, cObsRep, aRecnos, nI

    cRefError := ""
    aRecnos   := StrTokArr(aDoc[1], "#")

    DBSelectArea("SC1")

    For nI := 1 To Len(aRecnos)
        SC1->(DBGoTo(Val(aRecnos[nI])))

        If ! SC1->(EOF()) .AND. ! SC1->(Deleted())
            AAdd(aAprova,{aRecnos[nI], SC1->C1_FILIAL, SC1->C1_NUM, SC1->C1_ITEM, SC1->C1_ITEMGRD})
        EndIf
    Next

    If Empty(aAprova)
        cRefError := "Registro SC1 nao encontrado ou deletado."
    Else
        nOpca    := IIF(aDoc[4] == "approved", 3, 4)
        cObsRep := aDoc[5]

        // Seta variaveis de login para o usuario que aprovou/reprovou
        __cUserId  := aDoc[3, 1] // ID do usuario
        cUserName  := aDoc[3, 2] // Login do usuario
    EndIf

    SC1->(DBCloseArea())
    RestArea(aArea)

    // Se nao ocorreu erro acima, processa a aprovacao e volta o login anterior.
    If Empty(cRefError)
        U_STCOM018(nOpcA, aAprova, cObsRep, @cRefError)

        // Volta login
        __cUserId  := _aBkpUsr[1]
        cUserName  := _aBkpUsr[2]
    EndIf
Return
