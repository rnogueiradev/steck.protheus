#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc01 ºAutor ³Jonathan Schmidt Alves º Data ³06/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados masters.                                             º±±
±±º          ³                                                            º±±
±±º          ³ WsRc1203: Inclusao de Unidade de Medida                    º±±
±±º          ³ WsRc1301: Consulta de Produtos                             º±±
±±º          ³ WsRc1303: Inclusao de Produtos                             º±±
±±º          ³ WsRc1503: Inclusao de Paises                               º±±
±±º          ³ WsRc1703: Inclusao de Parceiros (Clientes)                 º±±
±±º          ³ WsRc1713: Inclusao de Parceiros (Fornecedores)             º±±
±±º          ³ WsRc1903: Atualizacao de Taxas de Moedas                   º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                   WsGnrc01 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1203 ºAutor ³Jonathan Schmidt Alves º Data ³29/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Unidade de Medida.             I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_UNM                            º±±
±±º          ³ API: PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³      Ex: "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA"       º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1203()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If SAH->(DbSeek( _cFilSAH + "KG" ))
                // Posicionamentos Unid Medida:
                aMethds := {}
                aRecTab := { { "SAH", Array(0) } }
                aAdd(aRecTab[01,02], SAH->(Recno()))         // Recno SAH
                If Len( aRecTab[01,02] ) > 0 // Recnos carregados
                    // #################### UNID MEDIDA ############################
                    //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                Titulo Integracao,                Msg Processamento }
                    //            {        01,        02,     03,             04,         05,         06,              07,              08,                               09,                               10 }
                    aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Unidades de Medida", "Unid Medida: " + SAH->AH_UNIMED })
                    aParams := {}
                    aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                    aAdd(aTail(aMethds)[06], aClone(aParams))
                EndIf
            Else // Unidade de Med nao encontrada (SAH)
                cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                cMsg02 := "Unidade de Medida nao encontrada no cadastro (SAH)!"
                cMsg03 := "Unid Medida: " + "KG"
                cMsg04 := ""
                lRet := .F.
            EndIf
        EndIf
    EndIf
EndIF
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1301 ºAutor ³Jonathan Schmidt Alves º Data ³29/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Produtos.                      C O N S U L T A  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_PRO                            º±±
±±º          ³ API: PKG_SFW_PRODUTOS.PRC_PRODUTO                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_PRODUTOS.PRC_PRODUTO"                    º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1301()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local _w1
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If SB1->(!EOF())
                // Posicionamentos Produtos:
                aRecTab := { { "SB1", Array(0) }, { "SBM", Array(0) }, { "SAH", Array(0) } }
                aAdd(aRecTab[01,02], SB1->(Recno()))         // Recno SB1
                aAdd(aRecTab[02,02], SBM->(Recno()))         // Recno SBM
                aAdd(aRecTab[03,02], SAH->(Recno()))         // Recno SAH
                // #################### PRODUTOS ############################
                // Repeticoes
                aRepets := {} // B1_DESC, B1_DESC_I, B1_XDESESP
                For _w1 := 0 To 2 // Apenas no idioma PORTUGUES/ESPANHOL/INGLES
                    If !Empty({ SB1->B1_DESC, RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) } [_w1 + 1])
                        aTabs := {}
                        aAdd(aTabs, { "SB1", SB1->(Recno()) })
                        aAdd(aReps, aClone( aTabs ))
                        aAuxs := {}
                        aAdd(aAuxs, { "cIdioma", cValToChar(_w1) })
                        //                       {                  01,                    02,                     30 }
                        aAdd(aAuxs, { "cDesIdi", { RTrim(SB1->B1_DESC), RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) } [_w1 + 1] })
                        aAdd(aVars, aClone( aAuxs ))
                    EndIf
                Next
                //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                aAdd(aRepets, {      "01", aClone( aReps ), aClone( aVars ) })
                // #################### PRODUTOS ############################
                //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,      Titulo Integracao,                                     Msg Processamento }
                //            {        01,        02,     03,             04,         05,         06,              07,              08,                     09,                                                    10 }
                aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta de Produtos", "Produto: " + SB1->B1_COD + " " + RTrim(SB1->B1_DESC) })
                aParams := {}
                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                aAdd(aTail(aMethds)[06], aClone(aParams))
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1303 ºAutor ³Jonathan Schmidt Alves º Data ³29/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Produtos.                      I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_PRO                            º±±
±±º          ³ API: PKG_SFW_PRODUTOS.PRC_PRODUTO                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_PRODUTOS.PRC_PRODUTO"                    º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1303()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local _w1
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis auxiliares repeticao
Local aTabs := {}
Local aVars := {}
Local aReps := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If SB1->(!EOF())
                If !Empty(SB1->B1_POSIPI) // NCM preenchida
                    If SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO))
                        If SAH->(DbSeek(_cFilSAH + SB1->B1_UM))
                            // Posicionamentos Unid Medida / Produtos:
                            aRecTab := { { "SB1", Array(0) }, { "SBM", Array(0) }, { "SAH", Array(0) } }
                            aAdd(aRecTab[01,02], SB1->(Recno()))         // Recno SB1
                            aAdd(aRecTab[02,02], SBM->(Recno()))         // Recno SBM
                            aAdd(aRecTab[03,02], SAH->(Recno()))         // Recno SAH
                            // #################### UNID MEDIDA ############################
                            //            { Interface,                                    Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,        aRepets,                Titulo Integracao,                 Msg Processamento }
                            //            {        01,                                          02,     03,             04,         05,         06,              07,              08,                               09,                                10 }
                            aAdd(aMethds, {        "", "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA",     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Unidades de Medida", "Unid Medida: " + SAH->AH_UNIMED })
                            aParams := {}
                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                            // #################### PRODUTOS ############################
                            // Repeticoes
                            aRepets := {} // B1_DESC, B1_DESC_I, B1_XDESESP
                            For _w1 := 0 To 2 // Apenas no idioma PORTUGUES/ESPANHOL/INGLES
                                If !Empty({ SB1->B1_DESC, RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) }[_w1 + 1])
                                    aTabs := {}
                                    aAdd(aTabs, { "SB1", SB1->(Recno()) })
                                    aAdd(aReps, aClone( aTabs ))
                                    aAuxs := {}
                                    aAdd(aAuxs, { "cIdioma", cValToChar(_w1) })
                                    //                       {                  01,                    02,                     30 }
                                    aAdd(aAuxs, { "cDesIdi", { RTrim(SB1->B1_DESC), RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) }[_w1 + 1]})
                                    aAdd(aVars, aClone( aAuxs ))
                                EndIf
                            Next
                            //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                            aAdd(aRepets, {      "01", aClone( aReps ), aClone( aVars ) })
                            // #################### PRODUTOS ############################
                            //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,      Titulo Integracao,                                     Msg Processamento }
                            //            {        01,        02,     03,             04,         05,         06,              07,              08,                     09,                                                    10 }
                            aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Produtos", "Produto: " + SB1->B1_COD + " " + RTrim(SB1->B1_DESC) })
                            aParams := {}
                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                        Else // Unidade de Med nao encontrada (SAH)
                            cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                            cMsg02 := "Unidade de Medida nao encontrada no cadastro (SAH)!"
                            cMsg03 := "Unid Medida: " + SB1->B1_UM
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Grupo do Produto nao encontrado (SBM)
                        cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                        cMsg02 := "Grupo do Produto nao encontrado no cadastro (SBM)!"
                        cMsg03 := "Grupo do Produto: " + SB1->B1_GRUPO
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // NCM nao preenchida (SB1)
                    cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                    cMsg02 := "NCM do Produto nao preenchida no cadastro (SBM)!"
                    cMsg03 := "Produto: " + SB1->B1_COD
                    cMsg04 := ""
                    lRet := .F.
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1503 ºAutor ³Jonathan Schmidt Alves º Data ³13/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Paises.                        I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_PAIS                           º±±
±±º          ³ API: PKG_SFW_PAIS.PRC_PAIS                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_PAIS.PRC_PAIS"                           º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1503()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            cCodPais := Iif( cTipInt == "03", SA1->A1_PAIS, SA2->A2_PAIS )
            If !Empty( cCodPais ) // Codigo do pais preenchido
                If SYA->(DbSeek( _cFilSYA + cCodPais)) // "03"=Clientes "13"=Fornecedores
                    If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais onforme Thomson
                        // Posicionamentos:
                        aRecTab := { { "SYA", Array(0) } }
                        aAdd(aRecTab[01,02], SYA->(Recno()))         // Recno SYA
                        If Len( aRecTab[01,02] ) > 0 // Recnos carregados
                            // #################### PAISES ############################
                            //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                            //            {        01,        02,     03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                            aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                            aParams := {}
                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                        EndIf
                    Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                        cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                        cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                        cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Pais nao encontrado no cadastro
                    cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                    cMsg02 := "Pais nao encontrado no cadastro (SYA)!"
                    cMsg03 := "Codigo Pais: " + cCodPais
                    cMsg04 := ""
                    lRet := .F.
                EndIf
            Else // Sem codigo do pais
                cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                cMsg02 := "Pais nao preenchido no cadastro!"
                cMsg03 := "Sem o codigo do pais a entidade nao pode ser integrada!"
                cMsg04 := ""
                lRet := .F.
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1703 ºAutor ³Jonathan Schmidt Alves º Data ³12/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Parceiros (Clientes).          I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_PARCEIRO                       º±±
±±º          ³ API: PKG_SFW_PARCEIRO.PRC_PARCEIRO                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_PARCEIRO.PRC_PARCEIRO"                   º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1703()
Local lRet := .T.
Local _w1
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis auxiliares repeticao
Local aTabs := {}
Local aVars := {}
Local aReps := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If SA1->(!EOF())
                // Posicionamentos:
                aMethds := {}
                aRecTab := { { "SA1", Array(0) }, { "SYA", Array(0) } }
                If Empty( SA1->A1_PAIS ) // Sem pais preenchido
                    cMsg01 := "Codigo do Pais nao preenchido (A1_PAIS)!"
                    cMsg02 := "Verifique o cadastro do cliente e tente novamente!"
                    cMsg03 := ""
                    cMsg04 := ""
                    lRet := .F.
                ElseIf SYA->(DbSeek( _cFilSYA + SA1->A1_PAIS ))
                    If Len(AllTrim(SYA->YA_SIGLA)) == 2 // .Or. SYA->YA_SIGLA == "BRA" // Sigla do pais onforme Thomson
                        aAdd(aRecTab[01,02], SA1->(Recno()))         // Recno SA1
                        aAdd(aRecTab[02,02], SYA->(Recno()))         // Recno SYA
                        If Len( aRecTab[01,02] ) > 0 // Recnos carregados
                            // ###################### PAISES #############################
                            //            { Interface,                  Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                            //            {        01,                        02,      03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                            aAdd(aMethds, {        "",   "PKG_SFW_PAIS.PRC_PAIS",      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                            aParams := {}
                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                            // #################### PARCEIROS ############################
                            // Repeticoes
                            aFuncs := { "EXEM", "EXPG", "EXRM", "EXRF", "EXN1" }
                            For _w1 := 1 To Len(aFuncs) // Funcoes do Cliente
                                aTabs := {}
                                aAdd(aTabs, { "SA1", SA1->(Recno()) })
                                aAdd(aReps, aClone( aTabs ))
                                aAuxs := {}
                                aAdd(aAuxs, { "cFuncParc", aFuncs[_w1] })
                                aAdd(aVars, aClone( aAuxs ))
                            Next
                            //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                            aAdd(aRepets, {      "20", aClone( aReps ), aClone( aVars ) })
                            // Fim
                            // Repeticoes "30"=Contatos do Cliente
                            aReps := {}
                            aVars := {}
                            For _w1 := 1 To 3 // { "X", "I", "E" }
                                If EE3->(DbSeek( _cFilEE3 + { "X", "I", "E" }[_w1] + PadR(SA1->A1_COD,TamSX3("EE3_CONTAT")[01]) + PadR(SA1->A1_LOJA,TamSX3("EE3_COMPL")[01]) ))
                                    While EE3->(!EOF()) .And. EE3->EE3_FILIAL + EE3->EE3_CODCAD + EE3->EE3_CONTAT + EE3->EE3_COMPL == _cFilEE3 + { "X", "I", "E" }[_w1] + PadR(SA1->A1_COD,TamSX3("EE3_CONTAT")[01]) + PadR(SA1->A1_LOJA,TamSX3("EE3_COMPL")[01]) // Contatos do Cliente
                                        aTabs := {}
                                        aAdd(aTabs, { "EE3", EE3->(Recno()) })      // Recno EE3 Amarracao Cliente x Contatos
                                        aAdd(aReps, aClone( aTabs ))
                                        aAuxs := {}
                                        aAdd(aAuxs, { "cContParc", EE3->EE3_NOME })
                                        aAdd(aVars, aClone( aAuxs ))
                                        EE3->(DbSkip())
                                    End
                                    If Len( aReps ) > 0
                                        //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                        aAdd(aRepets, {      "30", aClone( aReps ), aClone( aVars ) })
                                    EndIf
                                EndIf
                            Next
                            //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                  Titulo Integracao,                                                            Msg Processamento }
                            //            {        01,        02,     03,             04,         05,         06,              07,              08,                                 09,                                                                           10 }
                            aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Parceiros (Clientes)", "Cliente: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " " + RTrim(SA1->A1_NREDUZ) })
                            aParams := {}
                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                        EndIf
                    Else // Sigla do pais nao preenchida (YA_SIGLA)
                        cMsg01 := "Sigla do Pais nao conforme para integracao Thomson (SYA)!"
                        cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                        cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Pais nao encontrado (SYA)
                    cMsg01 := "Codigo do Pais nao encontrado no cadastro (SYA)!"
                    cMsg02 := "Verifique o cadastro do cliente e tente novamente!"
                    cMsg03 := "Pais: " + SA1->A1_PAIS
                    cMsg04 := ""
                    lRet := .F.
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1713 ºAutor ³Jonathan Schmidt Alves º Data ³17/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Parceiros (Fornecedores).      I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: SFW_PARCEIRO                       º±±
±±º          ³ API: PKG_SFW_PARCEIRO.PRC_PARCEIRO                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_PARCEIRO.PRC_PARCEIRO"                   º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1713()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local _w1
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis auxiliares repeticao
Local aTabs := {}
Local aVars := {}
Local aReps := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty( cTipInt ) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If SA2->(!EOF())
                // Posicionamentos:
                aMethds := {}
                aRecTab := { { "SA2", Array(0) }, { "SYA", Array(0) } }
                If !Empty( SA2->A2_PAIS )
                    If SYA->(DbSeek( _cFilSYA + SA2->A2_PAIS ))
                        If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais onforme Thomson
                            aAdd(aRecTab[01,02], SA2->(Recno()))         // Recno SA2
                            aAdd(aRecTab[02,02], SYA->(Recno()))         // Recno SYA
                            If Len( aRecTab[01,02] ) > 0 // Recnos carregados
                                // ###################### PAISES #############################
                                //            { Interface,                  Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                                //            {        01,                        02,      03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                                aAdd(aMethds, {        "",   "PKG_SFW_PAIS.PRC_PAIS",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                                aParams := {}
                                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
                                // #################### PARCEIROS ############################
                                // Repeticoes "20"=Funcoes do Fornecedor
                                aReps := {}
                                aVars := {}
                                aFuncs := {}
                                // Transportador: "EXAG", "EXTR", "IMAG", "IMTR"
                                // Agente de carga (SY4): "IMAG", "EXAG"
                                // Y4_FILIAL + Y4_FORN + Y4_LOJA
                                If SY4->(DbSeek( _cFilSY4 + SA2->A2_COD + SA2->A2_LOJA ))
                                    aAdd(aFuncs, "IMAG")
                                    aAdd(aFuncs, "EXAG")
                                    aAdd(aFuncs, "IMTR")
                                    aAdd(aFuncs, "EXTR")
                                EndIf
                                // Despachante (SY5): "IMDP", "EXDP", "IMAG", "EXAG"                            
                                If SY5->(DbSeek( _cFilSY5 + SA2->A2_COD + SA2->A2_LOJA ))
                                    aAdd(aFuncs, "IMDP")
                                    aAdd(aFuncs, "EXDP")
                                    If ASCan(aFuncs, {|x|, x == "IMAG" }) == 0
                                        aAdd(aFuncs, "IMAG")
                                    EndIf
                                    If ASCan(aFuncs, {|x|, x == "EXAG" }) == 0
                                        aAdd(aFuncs, "EXAG")
                                    EndIf
                                EndIf
                                // Outros: "IMPT"
                                If Len( aFuncs ) == 0
                                    If SA2->A2_PAIS == "105" // Brasil
                                        aAdd(aFuncs, "IMPT")
                                    Else // Estrangeiro precisa esses 4 codigos
                                        aAdd(aFuncs, "IMEX")
                                        aAdd(aFuncs, "IMFB")
                                        aAdd(aFuncs, "IMFV")
                                    EndIf
                                EndIf
                                // aFuncs := { "IMEX", "IMFB", "IMFV" } // { "EXEM", "EXPG", "EXRM", "EXRF" }
                                For _w1 := 1 To Len(aFuncs) // Funcoes do Fornecedor
                                    aTabs := {}
                                    aAdd(aTabs, { "SA2", SA2->(Recno()) })
                                    aAdd(aReps, aClone( aTabs ))
                                    aAuxs := {}
                                    aAdd(aAuxs, { "cFuncParc", aFuncs[_w1] })
                                    aAdd(aVars, aClone( aAuxs ))
                                Next
                                If Len( aReps ) > 0
                                    //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                    aAdd(aRepets, {      "20", aClone( aReps ), aClone( aVars ) })
                                EndIf
                                // Repeticoes "30"=Contatos do Fornecedor
                                aReps := {}
                                aVars := {}
                                If AC8->(DbSeek( _cFilAC8 + "SA2" + _cFilAC8 + SA2->A2_COD + SA2->A2_LOJA ))
                                    While AC8->(!EOF()) .And. AC8->AC8_FILIAL + AC8->AC8_ENTIDA + AC8->AC8_FILENT + AC8->AC8_CODENT == _cFilAC8 + "SA2" + _cFilAC8 + PadR(SA2->A2_COD + SA2->A2_LOJA,TamSX3("AC8_CODENT")[01]) // Contatos do Fornecedor
                                        If SU5->(DbSeek( _cFilSU5 + AC8->AC8_CODCON ))
                                            aTabs := {}
                                            aAdd(aTabs, { "AC8", AC8->(Recno()) })      // Recno AC8 Amarracao Fornecedor x Contatos
                                            aAdd(aTabs, { "SU5", SU5->(Recno()) })      // Recno SU5 Contatos
                                            If !Empty(SU5->U5_FUNCAO) .And. SUM->(DbSeek( _cFilSUM + SU5->U5_FUNCAO )) // Funcao do Cargo (SUM)
                                                aAdd(aTabs, { "SUM", SUM->(Recno()) })  // Recno SUM Funcao do Contato
                                            Else
                                                aAdd(aTabs, { "SUM", 0 })               // Recno SUM Funcao do Contato
                                            EndIf
                                            aAdd(aReps, aClone( aTabs ))
                                            aAuxs := {}
                                            aAdd(aAuxs, { "cContParc", SU5->U5_CONTAT })
                                            aAdd(aVars, aClone( aAuxs ))
                                        EndIf
                                        AC8->(DbSkip())
                                    End
                                    If Len( aReps ) > 0
                                        //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                        aAdd(aRepets, {      "30", aClone( aReps ), aClone( aVars ) })
                                    EndIf
                                EndIf
                                //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                      Titulo Integracao,                                                               Msg Processamento }
                                //            {        01,        02,     03,             04,         05,         06,              07,              08,                                     09,                                                                              10 }
                                aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Parceiros (Fornecedores)", "Fornecedor: " + SA2->A2_COD + "/" + SA2->A2_LOJA + " " + RTrim(SA2->A2_NREDUZ) })
                                aParams := {}
                                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
                            EndIf
                        Else // Sigla do pais nao preenchida (YA_SIGLA)
                            cMsg01 := "Sigla do Pais nao conforme para integracao Thomson (SYA)!"
                            cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                            cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Pais nao encontrado (SYA)
                        cMsg01 := "Codigo do Pais nao encontrado no cadastro (SYA)!"
                        cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                        cMsg03 := "Pais: " + SA2->A2_PAIS
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Sem pais preenchido
                    cMsg01 := "Codigo do Pais nao preenchido (A2_PAIS)!"
                    cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                    cMsg03 := ""
                    cMsg04 := ""
                    lRet := .F.
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc1903 ºAutor ³Jonathan Schmidt Alves º Data ³26/10/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Taxas de Moedas (Dolar/Euro).  I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: BG - IN - TXT - Moedas             º±±
±±º          ³ API: PKG_SFW_MOEDA.PRC_MOEDA_TAXA                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³          "PKG_SFW_MOEDA.PRC_MOEDA_TAXA"                    º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[02]: Tipo de Interface                            º±±
±±º          ³      Ex: "01"=IN (Entrada)                                 º±±
±±º          ³          "02"=OUT (Saida)                                  º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[03]: Tipo de registro                             º±±
±±º          ³      Ex: "P"=Registro posicionado                          º±±
±±º          ³          "C"=Consulta/Tela de integracao                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc1903()
Local _w1
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Methods/Params/Tabelas
Local aMethds := {}
Local aParams := {}
Local aRecTab := {}
Local aRepets := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
// Variaveis taxas
Local cDtIniTax := ""
Local cDtFimTax := ""
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            // Posicionamentos:
            aMethds := {}
            For _w1 := 1 To 2 // Dolar/Euro
                aRecTab := { { "SM0", Array(0) } }
                aAdd(aRecTab[01,02], SM0->(Recno()))         // Recno SM0
                cCodMoeda := { "USD", "EUR" }[_w1]                                          // USD=Dolar EUR=Euro
                cCodCateg := "04"                                                           // Categoria    01=Comercial Compra     02=Paralelo     03=Import Fiscal        04=Comercial Venda
                cDtIniTax := TransForm( DtoS(dDatabase - 5), "@R 9999-99-99" )              // Data Inicio Atualizacao
                cDtFimTax := TransForm( DtoS(Max(dDatabase, Date())), "@R 9999-99-99" )     // Data Fim Atualizacao
                //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                Titulo Integracao,                                                  Msg Processamento }
                //            {        01,        02,     03,             04,         05,         06,              07,              08,                               09,                                                                 10 }
                aAdd(aMethds, {        "",   cNomApi,     "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Atualizacao de Taxas de Moedas", "Moeda: " + cCodMoeda + " Datas: " + cDtIniTax + " a " + cDtFimTax })
                aParams := {}
                aAdd(aParams, { { "cCodCateg", "'" + cCodCateg + "'" }, { "cCodMoeda", "'" + cCodMoeda + "'" }, { "cDtIniTax", "'" + cDtIniTax + "'" }, { "cDtFimTax", "'" + cDtFimTax + "'" } }) // Variaveis auxiliares
                aAdd(aTail(aMethds)[06], aClone(aParams))
            Next
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

