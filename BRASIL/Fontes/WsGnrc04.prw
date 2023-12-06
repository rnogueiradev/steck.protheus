#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc04 ºAutor ³Jonathan Schmidt Alves º Data ³03/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacao/Cambio:                                         º±±
±±º          ³                                                            º±±
±±º          ³ WsRc4303: Inclusao da Ordem de Venda                    OK º±±
±±º          ³ WsRc4403: Inclusao do Processo de Exportacao            OK º±±
±±º          ³ WsRc4503: Inclusao das Embalagens (Pallets/Caixas)      OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc4601: Consulta Notificacao NF Export 6004 (Bx XML)  OK º±±
±±º          ³ WsRc4703: Atualizacao Proc Exportacao                   OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc4801: Consulta Notif Adto/Pgto/Prest 6011 (ZTX)     OK º±±
±±º          ³ WsRc4803: Inclusao da NF Exportacao (Senf)              OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc4903: Incl/Baixa Tit Rec Camb Exp (ZTX)             OK º±±
±±º          ³ WsRc4905: Consulta Notif Pagamento (ZTP)                OK º±±
±±º          ³ WsRc4906: Inclusao Titulos Financeiro (ZTP)             OK º±±
±±º          ³ WsRc4907: Inclusao Titulos Receb Fatur                  OK º±±
±±º          ³                                                            º±±
±±º          ³                                                   WsGnrc04 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4303 ºAutor ³Jonathan Schmidt Alves º Data ³19/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Ordem de Venda. (Exportacao)   I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: ORDENS                             º±±
±±º          ³ API: PKG_ES_GEN_ORDEM_VALIDA.PRC_ORDEM_HEADER              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_ES_GEN_ORDEM_VALIDA.PRC_ORDEM_HEADER"              º±±
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
±±º          ³ Inclui a Ordem de Venda do Totvs para o Thomson iniciando  º±±
±±º          ³ o fluxo de Exportacao.                                     º±±
±±º          ³ Tabelas Totvs: EE7/SA1/SYA/EE3                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4303()
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
// Variaveis auxiliares repeticao
Local aTabs := {}
Local aVars := {}
Local aReps := {}
// Controle de integracoes ja consideradas
Local aUnids := {}
Local aProds := {}
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If EE7->(DbSeek(_cFilEE7 + cIntPrcPsq))
                If !Empty(EE7->EE7_CONSIG)
                    If SA1->(DbSeek(_cFilSA1 + EE7->EE7_CONSIG + EE7->EE7_COLOJA)) // Consignatario
                        If SA1->A1_MSBLQL <> "1" // Cliente Consignatario nao bloqueado
                            If !Empty(SA1->A1_PAIS) // Pais Cliente
                                If SYA->(DbSeek(_cFilSYA + SA1->A1_PAIS)) // Pais do Consignatario
                                    If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais onforme Thomson
                                        // Posicionamentos Pais Destino:
                                        aRecTab := { { "SA1", Array(0) }, { "SYA", Array(0) } }
                                        aAdd(aRecTab[01,02], SA1->(Recno()))         // Recno SA1
                                        aAdd(aRecTab[02,02], SYA->(Recno()))         // Recno SYA
                                        // ###################### PAISES DE DESTINO #############################
                                        //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                                        //            {        01,                      02,      03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                                        aAdd(aMethds, {        "", "PKG_SFW_PAIS.PRC_PAIS",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                                        aParams := {}
                                        aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                        aAdd(aTail(aMethds)[06], aClone(aParams))
                                        // #################### PARCEIROS ############################
                                        // Repeticoes
                                        aFuncs := { "EXCO" } // aFuncs := { "EXEM", "EXPG", "EXRM", "EXRF", "EXN1", "EXCO" }
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
                                        // #################### PARCEIROS ############################
                                        //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                        aAdd(aRepets, {      "20", aClone( aReps ), aClone( aVars ) })
                                        //            { Interface,                        Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                       Titulo Integracao,                                                            Msg Processamento }
                                        //            {        01,                              02,      03,             04,         05,         06,              07,              08,                                      09,                                                                           10 }
                                        aAdd(aMethds, {        "", "PKG_SFW_PARCEIRO.PRC_PARCEIRO",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Parceiros (Consignatario)", "Cliente: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " " + RTrim(SA1->A1_NREDUZ) })
                                        aParams := {}
                                        aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                        aAdd(aTail(aMethds)[06], aClone(aParams))
                                    Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                        cMsg01 := "Sigla do Pais do consignatario nao conforme para integracoes Thomson (SYA)!"
                                        cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                        cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf                                        
                                Else // Pais Destino nao encontrado no cadastro (SYA)
                                    cMsg01 := "Codigo do Pais do consignatario nao encontrado no cadastro (SYA)!"
                                    cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                    cMsg03 := "Pais: " + SA2->A2_PAIS
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Else // Pais do consignatario nao preenchido (SA1)
                                cMsg01 := "Codigo do Pais nao preenchido (A1_PAIS)!"
                                cMsg02 := "Verifique o cadastro do cliente e tente novamente!"
                                cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Cliente esta bloqueado no cadastro (SA1)
                            cMsg01 := "Cliente Consignatario esta bloqueado no cadastro (SA1)!"
                            cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                            cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                        cMsg01 := "Cliente nao encontrado no cadastro (SA2)!"
                        cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                        cMsg03 := "Cliente/Loja: " + EE7->EE7_IMPORT + "/" + EE7->EE7_IMLOJA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                EndIf // Nao tem Consignatario
                If lRet // .T.=Ainda valido
                    aParams := {}
                    aRecTab := {}
                    aRepets := {}
                    aTabs := {}
                    aVars := {}
                    aReps := {}
                    If SA1->(DbSeek(_cFilSA1 + EE7->EE7_IMPORT + EE7->EE7_IMLOJA)) // Cliente
                        If SA1->A1_MSBLQL <> "1" // Cliente nao bloqueado
                            If !Empty(SA1->A1_PAIS) // Pais Cliente
                                If SYQ->(DbSeek(_cFilSYQ + EE7->EE7_VIA)) // Via de Transporte     4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                    If !Empty(SYQ->YQ_CODFIES) // Codigo da Via de Transporte no Thomson
                                        If SYR->(DbSeek(_cFilSYR + EE7->EE7_VIA + EE7->EE7_ORIGEM + EE7->EE7_DEST)) // Via + Origem + Destino
                                            If SYA->(DbSeek(_cFilSYA + SYR->YR_PAIS_DE)) // Pais do Destino
                                                If Len(AllTrim(SYA->YA_SIGLA)) == 2 // .Or. SYA->YA_SIGLA == "BRA" // Sigla do pais conforme Thomson
                                                    // Posicionamentos Pais Destino:
                                                    aRecTab := { { "SA1", Array(0) }, { "SYA", Array(0) } }
                                                    aAdd(aRecTab[01,02], SA1->(Recno()))         // Recno SA1
                                                    aAdd(aRecTab[02,02], SYA->(Recno()))         // Recno SYA
                                                    // ###################### PAISES DE DESTINO #############################
                                                    //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                                                    //            {        01,                      02,      03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                                                    aAdd(aMethds, {        "", "PKG_SFW_PAIS.PRC_PAIS",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                                                    aParams := {}
                                                    aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                                    If SYA->(DbSeek(_cFilSYA + SA1->A1_PAIS)) // Pais do Cliente
                                                        If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais onforme Thomson
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

                                                            aAdd(aRepets, {      "10", aClone( aReps ), aClone( aVars ) }) // TESTE

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
                                                            // #################### PARCEIROS ############################
                                                            //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                            aAdd(aRepets, {      "20", aClone( aReps ), aClone( aVars ) })
                                                            //            { Interface,                        Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                  Titulo Integracao,                                                            Msg Processamento }
                                                            //            {        01,                              02,      03,             04,         05,         06,              07,              08,                                 09,                                                                           10 }
                                                            aAdd(aMethds, {        "", "PKG_SFW_PARCEIRO.PRC_PARCEIRO",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Parceiros (Clientes)", "Cliente: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " " + RTrim(SA1->A1_NREDUZ) })
                                                            aParams := {}
                                                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                            aAdd(aTail(aMethds)[06], aClone(aParams))
                                                            // #################### COND PGTO ############################
                                                            // Desativado
                                                            // #################### COND PGTO ############################
                                                            aReps2 := {}
                                                            aVars2 := {}
                                                            If SYA->(DbSeek( _cFilSYA + SYR->YR_PAIS_DE)) // Pais do Destino
                                                                If EE8->(DbSeek(_cFilEE8 + EE7->EE7_PEDIDO))
                                                                    While EE8->(!EOF()) .And. EE8->EE8_FILIAL + EE8->EE8_PEDIDO == _cFilEE8 + EE7->EE7_PEDIDO // Itens da Ordem
                                                                        If SB1->(DbSeek(_cFilSB1 + EE8->EE8_COD_I)) // Produto
                                                                            If !Empty(SB1->B1_POSIPI) // NCM preenchida
                                                                                If SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO))
                                                                                    If SAH->(DbSeek(_cFilSAH + SB1->B1_UM)) // Unid Medida
                                                                                        // Posicionamentos Unid Medida/Produtos:
                                                                                        aRecTab := { { "SB1", Array(0) }, { "SBM", Array(0) }, { "SAH", Array(0) } }
                                                                                        aAdd(aRecTab[01,02], SB1->(Recno()))         // Recno SB1
                                                                                        aAdd(aRecTab[02,02], SBM->(Recno()))         // Recno SBM
                                                                                        aAdd(aRecTab[03,02], SAH->(Recno()))         // Recno SAH
                                                                                        If ASCan( aUnids, {|x|, x == SAH->AH_UNIMED }) == 0 // Unidade ainda nao considerada
                                                                                            // #################### UNID MEDIDA ############################
                                                                                            aRepets := {}
                                                                                            //            { Interface,                                    Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                Titulo Integracao,                Msg Processamento }
                                                                                            //            {        01,                                          02,      03,             04,         05,         06,              07,              08,                               09,                               10 }
                                                                                            aAdd(aMethds, {        "", "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA",      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Unidades de Medida", "Unid Medida: " + SAH->AH_UNIMED })
                                                                                            aParams := {}
                                                                                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                                                            aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                                            aAdd(aUnids, SAH->AH_UNIMED) // Incluo a unidade como ja considerada
                                                                                        EndIf
                                                                                        If ASCan( aProds, {|x|, x == SB1->B1_COD }) == 0 // Produto ainda nao considerado
                                                                                            // #################### PRODUTOS ############################
                                                                                            // Repeticoes
                                                                                            aRepets := {} // B1_DESC, B1_DESC_I, B1_XDESESP
                                                                                            aReps := {}
                                                                                            aVars := {}
                                                                                            For _w1 := 0 To 2 // Apenas no idioma PORTUGUES/ESPANHOL/INGLES
                                                                                                If !Empty( { SB1->B1_DESC, RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) } [ _w1 + 1 ] )
                                                                                                    aTabs := {}
                                                                                                    aAdd(aTabs, { "SB1", SB1->(Recno()) })
                                                                                                    aAdd(aReps, aClone( aTabs ))
                                                                                                    aAuxs := {}
                                                                                                    aAdd(aAuxs, { "cIdioma", cValToChar(_w1) })
                                                                                                    //                                  {                  01,                    02,                     30 }
                                                                                                    aAdd(aAuxs, { "cDesIdi", EncodeUTF8({ RTrim(SB1->B1_DESC), RTrim(SB1->B1_DESC_I), RTrim(SB1->B1_XDESESP) } [ _w1 + 1 ]) })
                                                                                                    aAdd(aVars, aClone( aAuxs ))
                                                                                                EndIf
                                                                                            Next
                                                                                            //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                                                            aAdd(aRepets, {      "01", aClone( aReps ), aClone( aVars ) })
                                                                                            // Fim
                                                                                            //            { Interface,                       Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,      Titulo Integracao,                                     Msg Processamento }
                                                                                            //            {        01,                             02,      03,             04,         05,         06,              07,              08,                     09,                                                    10 }
                                                                                            aAdd(aMethds, {        "", "PKG_SFW_PRODUTOS.PRC_PRODUTO",      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Produtos", "Produto: " + SB1->B1_COD + " " + RTrim(SB1->B1_DESC) })
                                                                                            aParams := {}
                                                                                            aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                                                            aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                                            aAdd(aProds, SB1->B1_COD) // Incluo o produto como ja considerado
                                                                                        EndIf
                                                                                        // #################### ORDEM VENDA ############################
                                                                                        // Repeticoes:
                                                                                        aTabs := {}
                                                                                        aAdd(aTabs, { "EE8", EE8->(Recno()) })  // Recno EE8
                                                                                        aAdd(aTabs, { "SB1", SB1->(Recno()) })  // Recno SB1
                                                                                        aAdd(aTabs, { "SBM", SBM->(Recno()) })  // Recno SBM
                                                                                        aAdd(aTabs, { "SAH", SAH->(Recno()) })  // Recno SAH
                                                                                        aAdd(aReps2, aClone( aTabs ))
                                                                                        aAuxs := {}
                                                                                        aAdd(aVars2, aClone( aAuxs ))
                                                                                    Else // Unid Medida nao encontrada no cadastro (SAH)
                                                                                        cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                                        cMsg02 := "Unidade de Medida nao encontrada no cadastro (SAH)!"
                                                                                        cMsg03 := "Unid Medida: " + "KG"
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
                                                                                cMsg02 := "NCM do Produto nao preenchida no cadastro (SB1)!"
                                                                                cMsg03 := "Produto: " + SB1->B1_COD
                                                                                cMsg04 := ""
                                                                                lRet := .F.
                                                                            EndIf
                                                                        Else // Produto nao encontrado no cadastro (SB1)
                                                                            cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                            cMsg02 := "Produto nao encontrado no cadastro (SB1)!"
                                                                            cMsg03 := "Produto: " + EE8->EE8_COD_I
                                                                            cMsg04 := ""
                                                                            lRet := .F.
                                                                        EndIf
                                                                        EE8->(DbSkip())
                                                                    End
                                                                Else // Itens do Pedido (EE8) nao encontrados
                                                                    cMsg01 := "Itens do Pedido nao encontrados no cadastro (EE8)!"
                                                                    cMsg02 := "Verifique o cadastro do embarque e tente novamente!"
                                                                    cMsg03 := "Pedido: " + EE7->EE7_PEDIDO
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                                If lRet // .T.=Sucesso nas integracoes compostas
                                                                    // #################### ORDEM VENDA ############################
                                                                    // Posicionamentos Ordem de Venda:
                                                                    aRecTab := { { "EE7", Array(0) }, { "SA1", Array(0) }, { "SYA", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) } }
                                                                    // Posicionamentos Ordem de Venda:
                                                                    aAdd(aRecTab[01,02], EE7->(Recno()))         // Recno EE7
                                                                    aAdd(aRecTab[02,02], SA1->(Recno()))         // Recno SA1
                                                                    aAdd(aRecTab[03,02], SYA->(Recno()))         // Recno SYA
                                                                    aAdd(aRecTab[04,02], SYQ->(Recno()))         // Recno SYQ
                                                                    aAdd(aRecTab[05,02], SYR->(Recno()))         // Recno SYR
                                                                    // Repeticoes
                                                                    aReps := {}
                                                                    aVars := {}
                                                                    aFuncs := { "EXEM", "EXPG", "EXRM", "EXRF", "EXN1" } // Cliente
                                                                    For _w1 := 1 To Len(aFuncs) // Funcoes do Cliente
                                                                        aTabs := {}
                                                                        aAdd(aTabs, { "SA1", SA1->(Recno()) })
                                                                        aAdd(aReps, aClone( aTabs ))
                                                                        aAuxs := {}
                                                                        aAdd(aAuxs, { "cFuncParc", aFuncs[_w1] })
                                                                        aAdd(aVars, aClone( aAuxs ))
                                                                    Next
                                                                    If !Empty(EE7->EE7_CONSIG) // Tem Consignatario
                                                                        If SA1->(DbSeek(_cFilSA1 + EE7->EE7_CONSIG + EE7->EE7_COLOJA)) // Consignatario (reposicionamento)
                                                                            aFuncs := { "EXCO" } // Consignatario
                                                                            For _w1 := 1 To Len(aFuncs) // Funcoes do Cliente
                                                                                aTabs := {}
                                                                                aAdd(aTabs, { "SA1", SA1->(Recno()) })
                                                                                aAdd(aReps, aClone( aTabs ))
                                                                                aAuxs := {}
                                                                                aAdd(aAuxs, { "cFuncParc", aFuncs[_w1] })
                                                                                aAdd(aVars, aClone( aAuxs ))
                                                                            Next
                                                                        EndIf
                                                                    EndIf
                                                                    //            { Repeticao,   Tabelas/Recnos,    Variaveis Aux }
                                                                    aRepets := {}
                                                                    aAdd(aRepets, {      "10", aClone( aReps2 ), aClone( aVars2 ) })
                                                                    aAdd(aRepets, {      "20", aClone( aReps ), aClone( aVars ) })
                                                                    // Fim
                                                                    //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,            Titulo Integracao,           Msg Processamento }
                                                                    //            {        01,       02,      03,             04,         05,         06,              07,              08,                           09,                          10 }
                                                                    aAdd(aMethds, {        "",  cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao da Ordem de Venda", "Ordem: " + EE7->EE7_PEDIDO })
                                                                    aParams := {}
                                                                    aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                EndIf
                                                            EndIf // Reposiciono SYA do fornecedor
                                                        Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                                            cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                                                            cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                                            cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                                                            cMsg04 := ""
                                                            lRet := .F.
                                                        EndIf                                        
                                                    Else // Pais Destino nao encontrado no cadastro (SYA)
                                                        cMsg01 := "Codigo do Pais do cliente nao encontrado no cadastro (SYA)!"
                                                        cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                                        cMsg03 := "Pais: " + SA2->A2_PAIS
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                                    cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                                                    cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                                    cMsg03 := "Pais/Nome: " + SYA->YA_CODGI + "/" + SYA->YA_DESCR
                                                    cMsg04 := "Sigla Pais: " + SYA->YA_SIGLA
                                                    lRet := .F.
                                                EndIf
                                            Else // Codigo Pais Destino nao encontrado
                                                cMsg01 := "Codigo do Pais destino nao encontrado (SYA)!"
                                                cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                                                cMsg03 := "Pais Destino: " + SYR->YR_PAIS_DE
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Via + Origem + Destino nao encontrada (SYR)
                                            cMsg01 := "Via Origem Destino nao encontrada no cadastro (SYR)!"
                                            cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                            cMsg03 := "Via/Origem/Destino: " + EE7->EE7_VIA + "/" + EE7->EE7_ORIGEM + "/" + EE7->EE7_DEST
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    Else // Codigo de via de transporte (SYQ)
                                        cMsg01 := "Codigo da Via de Transporte nao preenchida no cadastro (SYQ)!"
                                        cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                        cMsg03 := "Codigo da Via: " + SYQ->YQ_CODFIES
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf
                                Else // Via de Transporte nao encontrada (SYQ)  4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                    cMsg01 := "Tipo de Via de Transporte nao encontrada no cadastro (SYQ)!"
                                    cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                    cMsg03 := "Tipo de Via: " + EE7->EE7_VIA
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Else // Pais do cliente nao preenchido (A2_PAIS)
                                cMsg01 := "Codigo do Pais nao preenchido (A1_PAIS)!"
                                cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                                cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Cliente esta bloqueado no cadastro (SA1)
                            cMsg01 := "Cliente esta bloqueado no cadastro (SA1)!"
                            cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                            cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Cliente nao encontrado no cadastro (SA2)
                        cMsg01 := "Cliente nao encontrado no cadastro (SA2)!"
                        cMsg02 := "Verifique o fornecedor da importacao e tente novamente!"
                        cMsg03 := "Cliente/Loja: " + EE7->EE7_IMPORT + "/" + EE7->EE7_IMLOJA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                EndIf
            Else // EE7 nao encontrado
                cMsg01 := "Registro nao encontrado na pesquisa (EE7)!"
                cMsg02 := "Verifique o preenchimento e tente novamente!"
                cMsg03 := "Pesquisa: " + cGetPrcPsq
                cMsg04 := ""
                lRet := .F.
            EndIf // EE7 posicionado
        EndIf // "P"=Registro Posicionado
    EndIf // TipInt preenchido
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4403 ºAutor ³Jonathan Schmidt Alves º Data ³13/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Processo. (Exportacao)         I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: PROCESSO                           º±±
±±º          ³ API: PKG_ES_GEN_PROCESSO                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_ES_GEN_PROCESSO"                                   º±±
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
±±º          ³ Gera o Processo de Exportacao no Thomson a partir dos dadosº±±
±±º          ³ do Totvs continuando o fluxo iniciado na Ordem de Venda.   º±±
±±º          ³ Tabelas Totvs: EEC/EE7/SA1/SYQ/SYR/SYA/ZZA/EE9/SB1/SBM/SAH º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4403()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Local _w0
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            aParams := {}
            aRecTab := {}
            aRepets := {}
            aTabs := {}
            aVars := {}
            aReps := {}
            cMsg01 := ""
            cMsg02 := ""
            cMsg03 := ""
            cMsg04 := ""
            // Posicionamentos Processo Exportacao:
            aRecTab := { { "SM0", Array(0) } }
            aAdd(aRecTab[01,02], SM0->(Recno()))    // Recno SM0
            If EEC->(DbSeek( _cFilEEC + PadR( cIntPrcPsq,20 ) )) // Partir do EEC (EEC_PEDREF = 003705) ele vai ter 5 EEC_PREEMB                 // 004039/21, 004041/21, 004043/21, 004046/21
                While EEC->(!EOF()) .And. EEC->EEC_FILIAL + EEC->EEC_PEDREF == _cFilEEC + PadR( cIntPrcPsq,20 ) // "004043/21           "
                    If EE7->(DbSeek( _cFilEE7 + EEC->EEC_PEDREF)) // Pedido // "003858/21           "
                        If SA1->(DbSeek(_cFilSA1 + EE7->EE7_IMPORT + EE7->EE7_IMLOJA)) // Cliente
                            If SA1->A1_MSBLQL <> "1" // Nao bloqueado
                                If !Empty(SA1->A1_PAIS) // Pais Cliente
                                    If SYQ->(DbSeek(_cFilSYQ + EE7->EE7_VIA)) // Via de Transporte  4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                        If !Empty(SYQ->YQ_CODFIES) // Codigo da Via de Transporte no Thomson\
                                            If SYR->(DbSeek(_cFilSYR + EE7->EE7_VIA + EE7->EE7_ORIGEM + EE7->EE7_DEST)) // Via + Origem + Destino
                                                If SYA->(DbSeek(_cFilSYA + SYR->YR_PAIS_DE)) // Pais do Destino
                                                    If Len(AllTrim(SYA->YA_SIGLA)) == 2 // .Or. SYA->YA_SIGLA == "BRA" // Sigla do pais conforme Thomson
                                                        If ZZA->(DbSeek( _cFilZZA + EEC->EEC_PREEMB )) // Pallets/Volumes do pedido no Packing List
                                                            // Repeticoes
                                                            aRepets := {} // B1_DESC, B1_DESC_I, B1_XDESESP
                                                            aReps := {}
                                                            aVars := {}
                                                            If EE9->(DbSeek(_cFilEE9 + EEC->EEC_PREEMB))
                                                                While EE9->(!EOF()) .And. EE9->EE9_FILIAL + EE9->EE9_PREEMB == _cFilEE9 + EEC->EEC_PREEMB // Itens do Processo (Embarque)
                                                                    If SB1->(DbSeek(_cFilSB1 + EE9->EE9_COD_I)) // Produto
                                                                        If !Empty(SB1->B1_POSIPI) // NCM preenchida
                                                                            If SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO))
                                                                                If SAH->(DbSeek(_cFilSAH + SB1->B1_UM)) // Unid Medida
                                                                                    // #################### PRODUTOS ############################
                                                                                    aTabs := {}
                                                                                    aAdd(aTabs, { "SB1", SB1->(Recno()) })
                                                                                    aAdd(aTabs, { "SBM", SBM->(Recno()) })
                                                                                    aAdd(aTabs, { "EE9", EE9->(Recno()) })
                                                                                    aAdd(aReps, aClone( aTabs ))
                                                                                    aAuxs := {}
                                                                                    aAdd(aVars, aClone( aAuxs ))
                                                                                Else // Unid Medida nao encontrada no cadastro (SAH)
                                                                                    cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                                    cMsg02 := "Unidade de Medida nao encontrada no cadastro (SAH)!"
                                                                                    cMsg03 := "Unid Medida: " + "KG"
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
                                                                    Else // Produto nao encontrado no cadastro (SB1)
                                                                        cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                        cMsg02 := "Produto nao encontrado no cadastro (SB1)!"
                                                                        cMsg03 := "Produto: " + EE8->EE8_COD_I
                                                                        cMsg04 := ""
                                                                        lRet := .F.
                                                                    EndIf
                                                                    EE9->(DbSkip())
                                                                End
                                                                // #################### PROCESSO EXPORTACAO ############################
                                                                // Posicionamentos Processo Exportacao:
                                                                aRecTab := { { "EEC", Array(0) }, { "EE7", Array(0) }, { "SA1", Array(0) }, { "SYA", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) } }
                                                                // Posicionamentos Ordem de Venda:
                                                                aAdd(aRecTab[01,02], EEC->(Recno()))         // Recno EEC
                                                                aAdd(aRecTab[02,02], EE7->(Recno()))         // Recno EE7
                                                                aAdd(aRecTab[03,02], SA1->(Recno()))         // Recno SA2
                                                                aAdd(aRecTab[04,02], SYA->(Recno()))         // Recno SYA
                                                                aAdd(aRecTab[05,02], SYQ->(Recno()))         // Recno SYQ
                                                                aAdd(aRecTab[06,02], SYR->(Recno()))         // Recno SYR
                                                                //            { Repeticao,   Tabelas/Recnos,    Variaveis Aux }
                                                                aRepets := {}
                                                                aAdd(aRepets, {      "10", aClone( aReps ), aClone( aVars ) })
                                                                //            { Interface, Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,              Titulo Integracao,              Msg Processamento }
                                                                //            {        01,       02,      03,             04,         05,         06,              07,              08,                             09,                             10 }
                                                                aAdd(aMethds, {        "",  cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao Processo Exportacao", "Processo: " + EE7->EE7_PEDIDO })
                                                                aParams := {}
                                                                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "99" } }) // Variaveis auxiliares
                                                                aAdd(aTail(aMethds)[06], aClone(aParams))
                                                            Else // Itens do Pedido (EE8) nao encontrados
                                                                cMsg01 := "Itens do Pedido nao encontrados no cadastro (EE9)!"
                                                                cMsg02 := "Verifique o cadastro do embarque e tente novamente!"
                                                                cMsg03 := "Pedido: " + EE7->EE7_PEDIDO
                                                                cMsg04 := ""
                                                                lRet := .F.
                                                            EndIf
                                                        Else // Embalagens ainda nao montadas (ZZA) nao enviar
                                                            // cMsg01 := "Dados do Packing List ainda nao preenchidos (ZZA)!"
                                                            // cMsg02 := "Verifique o preenchimento e tente novamente!"
                                                            // lRet := .F.
                                                        EndIf
                                                    Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                                        cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                                                        cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                                        cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Codigo Pais Destino nao encontrado
                                                    cMsg01 := "Codigo do Pais destino nao encontrado (SYA)!"
                                                    cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                                                    cMsg03 := "Pais Destino: " + SYR->YR_PAIS_DE
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Via + Origem + Destino nao encontrada (SYR)
                                                cMsg01 := "Via Origem Destino nao encontrada no cadastro (SYR)!"
                                                cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                                cMsg03 := "Via/Origem/Destino: " + EE7->EE7_VIA + "/" + EE7->EE7_ORIGEM + "/" + EE7->EE7_DEST
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Codigo de via de transporte (SYQ)
                                            cMsg01 := "Codigo da Via de Transporte nao preenchida no cadastro (SYQ)!"
                                            cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                            cMsg03 := "Codigo da Via: " + SYQ->YQ_CODFIES
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    Else // Via de Transporte nao encontrada (SYQ)  4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                        cMsg01 := "Tipo de Via de Transporte nao encontrada no cadastro (SYQ)!"
                                        cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                        cMsg03 := "Tipo de Via: " + SW2->W2_TIPO_EM
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf
                                Else // Pais do fornecedor nao preenchido (A2_PAIS)
                                    cMsg01 := "Codigo do Pais nao preenchido (A2_PAIS)!"
                                    cMsg02 := "Verifique o cadastro do fornecedor e tente novamente!"
                                    cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Else // Cliente esta bloqueado no cadastro (SA1)
                                cMsg01 := "Cliente esta bloqueado no cadastro (SA1)!"
                                cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                                cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Fornecedor nao encontrado no cadastro (SA2)
                            cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                            cMsg02 := "Verifique o fornecedor da importacao e tente novamente!"
                            cMsg03 := "Fornecedor/Loja: " + EE7->EE7_FORN + "/" + EE7->EE7_FOLOJA
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    EndIf
                    EEC->(DbSkip())
                End
            EndIf // EE7 posicionado
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4503 ºAutor ³Jonathan Schmidt Alves º Data ³16/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Embalagem. (Exportacao)        I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: EMBALAGEM                          º±±
±±º          ³ API: PKG_EMBALAGEM                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_ES_GEN_EMBALAGEM_VALIDA.PRC_EMBALAGEM_FINALIZA"    º±±
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
±±º          ³ Gera o Processo de Embalagem dos materiais seguindo o fluxoº±±
±±º          ³ da Ordem de Exportacao e do Processo de Exportacao.        º±±
±±º          ³ Tabelas Totvs: EEC/EE7/SA1/SYQ/SYR/SYA/ZZA/EE9/CB6/EX9/CB3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4503()
Local _w1
Local _w2
Local _w3
Local _w4
Local lRet := .T.
// Variaveis montagens
Local aPals := {}
Local nPal := 0
Local aVols := {}
Local nVol := 0
// Variaveis mensagens
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If EEC->(DbSeek(_cFilEEC + PadR(cIntPrcPsq,20))) // Embarque
                If EE7->(DbSeek(_cFilEE7 + EEC->EEC_PEDREF)) // Pedido
                    If SA1->(DbSeek(_cFilSA1 + EE7->EE7_IMPORT + EE7->EE7_IMLOJA)) // Cliente
                        If SA1->A1_MSBLQL <> "1" // Nao bloqueado
                            If !Empty(SA1->A1_PAIS) // Pais Cliente
                                If SYQ->(DbSeek(_cFilSYQ + EE7->EE7_VIA)) // Via de Transporte     4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                    If !Empty(SYQ->YQ_CODFIES) // Codigo da Via de Transporte no Thomson
                                        If SYR->(DbSeek(_cFilSYR + EE7->EE7_VIA + EE7->EE7_ORIGEM + EE7->EE7_DEST)) // Via + Origem + Destino
                                            If SYA->(DbSeek(_cFilSYA + SYR->YR_PAIS_DE)) // Pais do Destino
                                                If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais conforme Thomson
                                                    If ZZA->(DbSeek(_cFilZZA + EEC->EEC_PREEMB)) // Pallets/Volumes do pedido
                                                        aPals := {} // Pallets
                                                        aVols := {} // Volumes sem Pallet
                                                        nVol := 0

                                                        While ZZA->(!EOF()) .And. ZZA->ZZA_FILIAL + ZZA->ZZA_PREEMB == _cFilZZA + EEC->EEC_PREEMB
                                                            If EE9->(DbSeek( _cFilEE9 + ZZA->ZZA_PREEMB + ZZA->ZZA_SEQEMB ))
                                                                If CB6->(DbSeek( _cFilCB6 + RTrim(ZZA->ZZA_ORDSEP) + RTrim(ZZA->ZZA_VOLUME) )) // Volume


                                                                    // Pallet
                                                                    nPal := 0
                                                                    If !Empty(ZZA->ZZA_PALLET) // Tem Pallet
                                                                        If EX9->( DbSeek(_cFilEX9 + ZZA->ZZA_PREEMB + ZZA->ZZA_CONTNR))
                                                                            If (nPal := ASCan(aPals, {|x|, x[01] == ZZA->ZZA_PALLET })) == 0 // Pallet ainda nao considerado
                                                                                //                  {   Codigo Pallet,                                  Numero do Pallet (Sequen),          Descricao do Pallet, Peso Liq do Pallet, Peso Bruto do Pallet, Peso do Pallet (Embalagem),  Peso das Caixas (Embalagem),,,      Recno ZZA,      Recno EE9,      Recno CB6,      Recno EX9,,,,,,, Volumes }
                                                                                //                  {              01,                                                         02,                           03,                 04,                   05,                         06,                            0,,,             10,             11,             12,             13,,,,,,,      20 }
                                                                                aAdd(aPals,         { ZZA->ZZA_PALLET, RTrim(EEC->EEC_PREEMB) + "PL-" + StrZero(Len(aPals) + 1, 3 /*2*/),                    "",                  0,                    0,                          0,                            0,,, ZZA->(Recno()), EE9->(Recno()), CB6->(Recno()), EX9->(Recno()),,,,,,,      {} })
                                                                                nPal := Len(aPals)
                                                                                aPals[nPal,05] += EX9->EX9_XPSPAL // Peso Bruto do Pallet (Digitado EX9)
                                                                                aPals[nPal,06] += EX9->EX9_XPSPAL // Peso do Pallet (Digitado EX9)
                                                                            EndIf
                                                                        EndIf
                                                                    EndIf
                                                                    // Volumes
                                                                    nVol++
                                                                    If nPal > 0 // Volume esta em Pallet (entao eh nesse ultimo)
                                                                        // Verificando se o volume ja nao foi considerado... (mesmo volume com 2 ou mais itens)
                                                                        If (nFndVol := ASCan(aPals[ nPal, 20 ], {|x|, x[01] == ZZA->ZZA_VOLUME })) == 0 // Volume ainda nao foi considerado...
                                                                            //                      {   Codigo Volume,                                 Codigo do Volume,                    Descricao do Volume, Peso Liq do Volume, Peso Bruto do Volume, Peso da Embalagem,      Quantidade,,,      Recno ZZA, Recno EE9,      Recno CB6,      Recno EX9,,,,,,, Volumes }
                                                                            //                      {              01,                                               02,                                     03,                 04,                   05,                06,              07,,,             10,        11,             12,             13,,,,,,,      20 }
                                                                            aAdd(aPals[nPal,20],    { ZZA->ZZA_VOLUME, RTrim(EEC->EEC_PREEMB) + "CX-" + StrZero(nVol, 3 /*2*/),                              "",                  0,                    0,                 0, ZZA->ZZA_QTEEMB,,, ZZA->(Recno()),  Array(0), CB6->(Recno()), EX9->(Recno()),,,,,,,      {} })
                                                                            nFndVol := Len( aPals[nPal,20] )
                                                                        EndIf
                                                                        aPals[nPal,20,nFndVol,04] += ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN                          // Incremento peso liquido do volume


                                                                        If (nFndUni := ASCan(aPals[nPal,20,nFndVol,11], {|x|, x[10] + x[11] == ZZA->ZZA_SEQUEN + ZZA->ZZA_PROD })) == 0 // Ainda nao tem Squencial + Produto
                                                                            //                              {             01,             02,,,,,,,,              10,            11,              12 }
                                                                            aAdd(aPals[nPal,20,nFndVol,11], { EE9->(Recno()), ZZA->(Recno()),,,,,,,, ZZA->ZZA_SEQUEN, ZZA->ZZA_PROD, ZZA->ZZA_QTEEMB }) // Inclusao do Recno EE9
                                                                        Else
                                                                            aPals[nPal,20,nFndVol,11,nFndUni,12] += ZZA->ZZA_QTEEMB // Incremento quantidade
                                                                        EndIf


                                                                        aPals[nPal,04] += ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN                                     // Incremento peso liquido do pallet (soma das caixas etc)
                                                                        If aPals[nPal,20,nFndVol,05] == 0 // Volume ainda nao existia, somo o peso da embalagem
                                                                            aPals[nPal,20,nFndVol,05] += CB6->CB6_XPESO                                         // Incremento peso bruto do volume
                                                                            aPals[nPal,20,nFndVol,06] += CB6->CB6_XPESO - (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)   // Peso da Embalagem (Caixa calculado CB6 x EE9)

                                                                            aPals[nPal,05] += CB6->CB6_XPESO - (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)              // Incremento peso bruto do pallet (soma das caixas etc)
                                                                            aPals[nPal,07] += CB6->CB6_XPESO - (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)              // Incremento peso das embalagens que estao no pallet (soma do peso das caixas etc)

                                                                        Else // Volume ja existia, somar apenas pesos liquidos
                                                                            aPals[nPal,20,nFndVol,06] -= (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)
                                                                            aPals[nPal,20,nFndVol,07] += ZZA->ZZA_QTEEMB

                                                                            aPals[nPal,05] -= (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)
                                                                            aPals[nPal,07] -= (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)

                                                                        EndIf



                                                                    Else // Volume nao esta em Pallet (Volume sem Pallet eh na aVols)
                                                                        If (nFndVol := ASCan(aVols, {|x|, x[01] == ZZA->ZZA_VOLUME })) == 0 // Volume ainda nao foi considerado...
                                                                            //                      {   Codigo Volume,                                 Codigo do Volume,                    Descricao do Volume, Peso Liq do Volume, Peso Bruto do Volume, Peso da Embalagem,       Quantidade,,,      Recno ZZA,                   Recno EE9,      Recno CB6,      Recno EX9,,,,,,, Volumes }
                                                                            //                      {              01,                                               02,                                     03,                 04,                   05,                06,               07,,,             10,                          11,             12,             13,,,,,,,      20 }
                                                                            aAdd(aVols,             { ZZA->ZZA_VOLUME, RTrim(EEC->EEC_PREEMB) + "CX-" + StrZero(nVol, 3 /*2*/),                              "",                  0,                    0,                 0,  ZZA->ZZA_QTEEMB,,, ZZA->(Recno()), /*EE9->(Recno())*/ Array(0), CB6->(Recno()),              0,,,,,,,      {} })
                                                                            nFndVol := Len(aVols)
                                                                        EndIf
                                                                        aVols[nFndVol,04] += ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN                              // Incremento peso liquido do volume
                                                                        aVols[nFndVol,05] += CB6->CB6_XPESO                                                 // Incremento peso bruto do volume
                                                                        aVols[nFndVol,06] += CB6->CB6_XPESO - (ZZA->ZZA_QTEEMB * EE9->EE9_PSLQUN)           // Peso da Embalagem (Caixa calculado CB6 x EE9)



                                                                        //                      {             01,             02 }
                                                                        aAdd(aVols[nFndVol,11], { EE9->(Recno()), ZZA->(Recno()) }) // Inclusao do Recno EE9



                                                                    EndIf
                                                                EndIf
                                                            EndIf

                                                            ZZA->(DbSkip())
                                                        End
                                                        // Recnos dos Pallets/Volumes
                                                        // Recnos dos Volumes Sem Pallet
                                                        If Len(aPals) > 0
                                                            For _w1 := 1 To Len(aPals)
                                                                If CB3->(DbSeek(_cFilCB3 + "950")) // Pallet Padrao
                                                                    
                                                                    ZZA->(DbGoto(aPals[_w1,10])) // Reposiciono ZZA // EE9->(DbGoto(aPals[_w1,11])) // Reposiciono EE9
                                                                    CB6->(DbGoto(aPals[_w1,12])) // Reposiciono CB6
                                                                    EX9->(DbGoto(aPals[_w1,13])) // Reposiciono EX9
                                                                    
                                                                    // Posicionamentos Pallets:
                                                                    aRecTab := { { "EEC", Array(0) }, { "EE7", Array(0) }, { "CB3", Array(0) }, { "SA1", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) }, { "SYA", Array(0) }, { "CB6", Array(0) }, { "EX9", Array(0) }, { "EE9", Array(0) }, { "ZZA", Array(0) } }
                                                                    aAdd(aRecTab[01,02], EEC->(Recno()))    // Recno EEC
                                                                    aAdd(aRecTab[02,02], EE7->(Recno()))    // Recno EE7
                                                                    aAdd(aRecTab[03,02], CB3->(Recno()))    // Recno CB3
                                                                    aAdd(aRecTab[04,02], SA1->(Recno()))    // Recno SA1
                                                                    aAdd(aRecTab[05,02], SYQ->(Recno()))    // Recno SYQ
                                                                    aAdd(aRecTab[06,02], SYR->(Recno()))    // Recno SYR
                                                                    aAdd(aRecTab[07,02], SYA->(Recno()))    // Recno SYA
                                                                    aAdd(aRecTab[08,02], CB6->(Recno()))    // Recno CB6
                                                                    aAdd(aRecTab[09,02], EX9->(Recno()))    // Recno EX9
                                                                    aAdd(aRecTab[10,02], 0)                 // Recno EE9
                                                                    aAdd(aRecTab[11,02], ZZA->(Recno()))    // Recno ZZA

                                                                    // ###################### EMBALAGENS PALLETS #############################
                                                                    //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,  Titulo Integracao, Msg Processamento }
                                                                    //            {        01,                      02,      03,             04,         05,         06,              07,              08,                 09,                10 }
                                                                    aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao Pallets",      "Processo: " })
                                                                    // Variaveis auxiliares
                                                                    aParams := {}
                                                                    aAdd(aParams, { { "cCodEmb", "'" + cEmpAnt + cFilAnt + aPals[_w1,02] + "'" },;          // Codigo da Embalagem      Ex: 0102004043APL-01                (Empresa + Filial + Processo + CX/PL- + Sequencial)
                                                                    { "cDesEmb", "'" + CB3->CB3_DESCRI + "'" },;                                            // Descricao Embalagem      Ex: PALLET EXP ou CX 222 - 060722   (CB3)
                                                                    { "cTipEmb", "'" + cEmpAnt + cFilAnt + CB3->CB3_CODEMB + "'" },;                        // Tipo da Embalagem        Ex: 0102222                         (Empresa + Filial + CB3)
                                                                    { "cNivEmb", "'1'" },;                                                                  // Nivel da Embalagem       Ex: 0=Pallet ou 1=Caixas            (CB3)
                                                                    { "cEmbOri", "'" + StrZero(_w1,3) + "-" + RTrim(CB3->CB3_CODEMB) + "'" },;              // Embalagem Original       Ex: 002-222                         (Sequencial + CB3)
                                                                    { "cEmbPai", "''" },;                                                                   // Embalagem Pai            Ex: Vazio
                                                                    { "nPesLiq", "'" + cValToChar(aPals[_w1,04]) + "'" },;                                  // Peso Liquido Pallet      Ex: 1.0
                                                                    { "nPesBru", "'" + cValToChar(aPals[_w1,05]) + "'" },;                                  // Peso Bruto Pallet        Ex: 1.2
                                                                    { "nPesEmb", "'" + cValToChar(aPals[_w1,06]) + "'" },;                                  // Peso Embalagem Pallet    Ex: 0.2
                                                                    { "nPesCxs", "'" + cValToChar(aPals[_w1,07]) + "'" },;                                  // Peso Caixas do Pallet    Ex: 6.0
                                                                    { "nQtdEmb", "'0'" },;                                                                  // Quantidade no Pallet     Ex: 0 (no pallet eh zero)
                                                                    { "nQtdIte", "'0'" } })                                                                 // Quantidade de Itens      Ex: 0 (no pallet eh zero)
                                                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                    // Verificando se o Pallet tem Volumes
                                                                    If Len(aPals[_w1,20]) > 0
                                                                        For _w2 := 1 To Len(aPals[_w1,20])
                                                                            
                                                                            // EE9->(DbGoto(aPals[_w1,20,_w2,11])) // Reposiciono EE9
                                                                            
                                                                            ZZA->(DbGoto(aPals[_w1,20,_w2,10])) // Reposiciono ZZA

                                                                            CB6->(DbGoto(aPals[_w1,20,_w2,12])) // Reposiciono CB6
                                                                            If CB3->(DbSeek(_cFilCB3 + CB6->CB6_TIPVOL)) // Tipo do Volume
                                                                                // Posicionamentos Embalagens:
                                                                                aRecTab := { { "EEC", Array(0) }, { "EE7", Array(0) }, { "CB3", Array(0) }, { "SA1", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) }, { "SYA", Array(0) }, { "CB6", Array(0) }, { "EX9", Array(0) }, { "EE9", Array(0) }, { "ZZA", Array(0) } }
                                                                                aAdd(aRecTab[01,02], EEC->(Recno()))    // Recno EEC
                                                                                aAdd(aRecTab[02,02], EE7->(Recno()))    // Recno EE7
                                                                                aAdd(aRecTab[03,02], CB3->(Recno()))    // Recno CB3
                                                                                aAdd(aRecTab[04,02], SA1->(Recno()))    // Recno SA1
                                                                                aAdd(aRecTab[05,02], SYQ->(Recno()))    // Recno SYQ
                                                                                aAdd(aRecTab[06,02], SYR->(Recno()))    // Recno SYR
                                                                                aAdd(aRecTab[07,02], SYA->(Recno()))    // Recno SYA
                                                                                aAdd(aRecTab[08,02], CB6->(Recno()))    // Recno CB6
                                                                                aAdd(aRecTab[09,02], EX9->(Recno()))    // Recno EX9
                                                                                aAdd(aRecTab[10,02], 0)                 // Recno EE9
                                                                                aAdd(aRecTab[11,02], ZZA->(Recno()))    // Recno ZZA


                                                                                // ##### REPETS ITENS #####
                                                                                aTabs := {}
                                                                                aVars := {}
                                                                                aReps := {}
                                                                                For _w3 := 1 To Len( aPals[_w1,20,_w2,11] ) // Rodo nos itens

                                                                                    aTabs := {}
                                                                                    aAdd(aTabs, { "EE9", aPals[_w1,20,_w2,11,_w3,01] }) // Recno EE9
                                                                                    aAdd(aTabs, { "ZZA", aPals[_w1,20,_w2,11,_w3,02]  }) // Recno ZZA

                                                                                    aAdd(aReps, aClone( aTabs ))

                                                                                    aAuxs := {}
                                                                                    aAdd(aAuxs, { "cSequen", ZZA->ZZA_SEQUEN })
                                                                                    aAdd(aAuxs, { "cCodPro", ZZA->ZZA_PROD })
                                                                                    aAdd(aAuxs, { "nQtdTot", aPals[_w1,20,_w2,11,_w3,12] })     // Quantidade somada

                                                                                    aAdd(aVars, aClone( aAuxs ))

                                                                                Next

                                                                                //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                                                aRepets := {}
                                                                                aAdd(aRepets, {      "10", aClone( aReps ), aClone( aVars ) })


                                                                                // ###################### EMBALAGENS CAIXAS #############################
                                                                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,     Titulo Integracao, Msg Processamento }
                                                                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                    09,                10 }
                                                                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao Embalagens",      "Processo: " })
                                                                                // Variaveis auxiliares                                                                                
                                                                                aParams := {}
                                                                                aAdd(aParams, { { "cCodEmb", "'" + cEmpAnt + cFilAnt + aPals[_w1,20,_w2,02] + "'" },;                       // Codigo da Embalagem      Ex: 0102004043ACX-02
                                                                                { "cDesEmb", "'" + CB3->CB3_DESCRI + "'" },;                                                                // Descricao da Embalagem   Ex: 
                                                                                { "cTipEmb", "'" + cEmpAnt + cFilAnt + CB3->CB3_CODEMB + "'" },;                                            // Tipo da Embalagem        Ex: 
                                                                                { "cNivEmb", "'0'" },;                                                                                      // Nivel da Embalagem       Ex: 
                                                                                { "cEmbOri", "'" + StrZero(Val( Right(CB6->CB6_VOLUME,4) ),3) + "-" + RTrim(CB3->CB3_CODEMB) + "'" },;      // Embalagem Original       Ex: 
                                                                                { "cEmbPai", "'" + cEmpAnt + cFilAnt + aPals[_w1,02] + "'" },;                                              // Embalagem Pai            Ex: 0102004043APL-02
                                                                                { "nPesLiq", "'" + cValToChar(aPals[_w1,20,_w2,04]) + "'" },;                                               // Peso Liquido Volume      Ex: 45.0
                                                                                { "nPesBru", "'" + cValToChar(aPals[_w1,20,_w2,05]) + "'" },;                                               // Peso Bruto Volume        Ex: 65.0
                                                                                { "nPesEmb", "'" + cValToChar(aPals[_w1,20,_w2,06]) + "'" },;                                               // Peso Embalagem Volume    Ex: 20.0
                                                                                { "nPesCxs", "''" },;                                                                                       // Peso Caixas do Pallet    Ex: 0
                                                                                { "nQtdEmb", "'" + cValToChar(aPals[_w1,20,_w2,07]) + "'" },;                                               // Quantidade no Embalagem  Ex: 144
                                                                                { "nQtdIte", "'" + cValToChar(Len( aPals[_w1,20,_w2,11] )) + "'" } })                                       // Quantidade Itens         Ex: 3

                                                                                aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                            Else // Tipo do Volume nao encontrado (CB3)
                                                                                cMsg01 := "O Pallet padrao nao foi encontrado (CB3)!"
                                                                                cMsg02 := "Verifique os dados e tente novamente!"
                                                                                cMsg03 := "Filial/Tipo Volume: " + _cFilCB3 + "/" + CB6->CB6_TIPVOL
                                                                                cMsg04 := ""
                                                                                lRet := .F.
                                                                            EndIf
                                                                        Next
                                                                    EndIf
                                                                Else // Cadastro do Pallet Padrao nao encontrado (CB3)
                                                                    cMsg01 := "O Pallet padrao nao foi encontrado (CB3)!"
                                                                    cMsg02 := "Verifique os dados e tente novamente!"
                                                                    cMsg03 := "Filial/Cod Pallet: " + _cFilCB3 + "/" + "950"
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                            Next // Pallets
                                                        EndIf
                                                        If Len(aVols) > 0 // Volumes sem Pallet
                                                            For _w2 := 1 To Len(aVols)

                                                                ZZA->(DbGoto(aVols[_w2,10])) // Reposiciono ZZA

                                                                // EE9->(DbGoto(aVols[_w2,11])) // Reposiciono EE9
                                                                CB6->(DbGoto(aVols[_w2,12])) // Reposiciono CB6
                                                                If CB3->(DbSeek(_cFilCB3 + CB6->CB6_TIPVOL)) // Tipo do Volume
                                                                    // Posicionamentos Embalagens:
                                                                    aRecTab := { { "EEC", Array(0) }, { "EE7", Array(0) }, { "CB3", Array(0) }, { "SA1", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) }, { "SYA", Array(0) }, { "CB6", Array(0) }, { "EX9", Array(0) }, { "EE9", Array(0) }, { "ZZA", Array(0) } }
                                                                    aAdd(aRecTab[01,02], EEC->(Recno()))    // Recno EEC
                                                                    aAdd(aRecTab[02,02], EE7->(Recno()))    // Recno EE7
                                                                    aAdd(aRecTab[03,02], CB3->(Recno()))    // Recno CB3
                                                                    aAdd(aRecTab[04,02], SA1->(Recno()))    // Recno SA2
                                                                    aAdd(aRecTab[05,02], SYQ->(Recno()))    // Recno SYQ
                                                                    aAdd(aRecTab[06,02], SYR->(Recno()))    // Recno SYR
                                                                    aAdd(aRecTab[07,02], SYA->(Recno()))    // Recno SYA
                                                                    aAdd(aRecTab[08,02], CB6->(Recno()))    // Recno CB6
                                                                    aAdd(aRecTab[09,02], 0)                 // Recno EX9
                                                                    aAdd(aRecTab[10,02], 0)                 // Recno EE9
                                                                    aAdd(aRecTab[11,02], ZZA->(Recno()))    // Recno ZZA

                                                                    // ##### REPETS ITENS #####
                                                                    aTabs := {}
                                                                    aVars := {}
                                                                    aReps := {}
                                                                    For _w3 := 1 To Len( aVols[_w2,11] ) // Rodo nos itens
                                                                        aTabs := {}
                                                                        aAdd(aTabs, { "EE9", aVols[_w2,11,_w3,01] }) // Recno EE9
                                                                        aAdd(aTabs, { "ZZA", aVols[_w2,11,_w3,02] }) // Recno ZZA

                                                                        aAdd(aReps, aClone( aTabs ))

                                                                        aAuxs := {}
                                                                        aAdd(aVars, aClone( aAuxs ))

                                                                    Next

                                                                    //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                                    aRepets := {}
                                                                    aAdd(aRepets, {      "10", aClone( aReps ), aClone( aVars ) })


                                                                    // ###################### EMBALAGENS CAIXAS #############################
                                                                    //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,     Titulo Integracao, Msg Processamento }
                                                                    //            {        01,                      02,      03,             04,         05,         06,              07,              08,                    09,                10 }
                                                                    aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao Embalagens",      "Processo: " })
                                                                    // Variaveis auxiliares
                                                                    aParams := {}
                                                                    aAdd(aParams, { { "cCodEmb", "'" + cEmpAnt + cFilAnt + aVols[_w2,02] + "'" },;                              // Codigo da Embalagem      Ex: 0102004043ACX-02
                                                                    { "cDesEmb", "'" + CB3->CB3_DESCRI + "'" },;                                                                // Descricao da Embalagem   Ex: 
                                                                    { "cTipEmb", "'" + cEmpAnt + cFilAnt + CB3->CB3_CODEMB + "'" },;                                            // Tipo da Embalagem        Ex: 
                                                                    { "cNivEmb", "'0'" },;                                                                                      // Nivel da Embalagem       Ex: 0=Volume
                                                                    { "cEmbOri", "'" + StrZero(Val( Right(CB6->CB6_VOLUME,4) ),3) + "-" + RTrim(CB3->CB3_CODEMB) + "'" },;      // Embalagem Original       Ex: 
                                                                    { "cEmbPai", "''" },;                                                                                       // Embalagem Pai            Ex: Vazio (Eh Volume sem Pallet)
                                                                    { "nPesLiq", "'" + cValToChar(aVols[_w2,04]) + "'" },;                                                      // Peso Liquido Volume      Ex: 45.0
                                                                    { "nPesBru", "'" + cValToChar(aVols[_w2,05]) + "'" },;                                                      // Peso Bruto Volume        Ex: 65.0
                                                                    { "nPesEmb", "'" + cValToChar(aVols[_w2,06]) + "'" },;                                                      // Peso Embalagem Volume    Ex: 20.0
                                                                    { "nPesCxs", "''" },;                                                                                       // Peso Caixas do Pallet    Ex: 0
                                                                    { "nQtdEmb", "'" + cValToChar(aVols[_w2,07]) + "'" },;                                                      // Quantidade no Embalagem  Ex: 144
                                                                    { "nQtdIte", "'" + cValToChar(Len( aVols[_w2,11] )) + "'" } })                                              // Quantidade Itens         Ex: 3
                                                                    
                                                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                Else // Tipo do Volume nao encontrado (CB3)
                                                                    cMsg01 := "O Tipo do Volume nao foi encontrado (CB3)!"
                                                                    cMsg02 := "Verifique os dados e tente novamente!"
                                                                    cMsg03 := "Filial/Tipo Volume: " + _cFilCB3 + "/" + CB6->CB6_TIPVOL
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                            Next
                                                        EndIf // Volumes Sem Pallet
                                                    Else // ZZA nao encontrado (Pallet/Volumes)
                                                        cMsg01 := "Pallets/Volumes nao encontrados (ZZA)!"
                                                        cMsg02 := "Verifique os dados e tente novamente!"
                                                        cMsg03 := "Pedido: " + EEC->EEC_PREEMB
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                                    cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                                                    cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                                    cMsg03 := "Sigla Pais: " + SYA->YA_SIGLA
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Codigo Pais Destino nao encontrado
                                                cMsg01 := "Codigo do Pais destino nao encontrado (SYA)!"
                                                cMsg02 := "Verifique o cadastro do cliente e tente novamente!"
                                                cMsg03 := "Pais Destino: " + SYR->YR_PAIS_DE
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Via + Origem + Destino nao encontrada (SYR)
                                            cMsg01 := "Via Origem Destino nao encontrada no cadastro (SYR)!"
                                            cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                            cMsg03 := "Via/Origem/Destino: " + EE7->EE7_VIA + "/" + EE7->EE7_ORIGEM + "/" + EE7->EE7_DEST
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    Else // Codigo de via de transporte (SYQ)
                                        cMsg01 := "Codigo da Via de Transporte nao preenchida no cadastro (SYQ)!"
                                        cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                        cMsg03 := "Codigo da Via: " + SYQ->YQ_CODFIES
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf
                                Else // Via de Transporte nao encontrada (SYQ)  4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                    cMsg01 := "Tipo de Via de Transporte nao encontrada no cadastro (SYQ)!"
                                    cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                    cMsg03 := "Tipo de Via: " + SW2->W2_TIPO_EM
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Else // Pais do fornecedor nao preenchido (A1_PAIS)
                                cMsg01 := "Codigo do Pais nao preenchido (A1_PAIS)!"
                                cMsg02 := "Verifique o cadastro do cliente e tente novamente!"
                                cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Cliente esta bloqueado no cadastro (SA1)
                            cMsg01 := "Cliente esta bloqueado no cadastro (SA1)!"
                            cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                            cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Cliente nao encontrado no cadastro (SA1)
                        cMsg01 := "Cliente nao encontrado no cadastro (SA1)!"
                        cMsg02 := "Verifique o fornecedor da importacao e tente novamente!"
                        cMsg03 := "Cliente/Loja: " + EE7->EE7_IMPORT + "/" + EE7->EE7_IMLOJA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                EndIf // EE7
            EndIf // EEC
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4601 ºAutor ³Jonathan Schmidt Alves º Data ³01/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Notificacoes (NFiscal Export)  C O N S U L T A  º±±
±±º          ³                                                      6004  º±±
±±º          ³ ID Interface no In-Out: N/A                                º±±
±±º          ³ API: PKG_ES_GEN_SENF_ATUALIZA                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_ES_GEN_SENF_ATUALIZA"                              º±±
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
±±º          ³ Carrega o XML da nota fiscal de exportacao para o ZTN.     º±±
±±º          ³ Esse XML sera usado na sequencia para atualizar a capa.    º±±
±±º          ³ Tabelas Totvs: ZTN                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4601()
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            If ZTN->(DbSeek(_cFilZTN + "6004" + "3"))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6004" + "3" // "6002"=NFiscal Export
                    If Left(ZTN->ZTN_PVC201,4) == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        If ZTN->ZTN_STATOT == "03" // ZTN->(Recno()) == 20 // Nota: 0105003997-01                 // ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                            // Consulta Exportacao:
                            cCodEvent := ZTN->ZTN_IDEVEN            // Codigos dos processos        Ex: "6059"=Transito e Compromisso   "6002"=Importacao (Nota Fiscal),  "6060"=Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento     "6062"=Emissao de Pagamento/Adiantamento/Prestacao de Contas
                            cDesEvent := "Export"
                            cNumSenf  := ZTN->ZTN_PVC201            // Id Number
                            cCodSiste := "2"                        // Tudo para exportacao
                            // Posicionamentos Notificacoes:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            // ###################### NOTIFICACOES #############################
                            //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,          Titulo Integracao,                               Msg Processamento }
                            //            {        01,                      02,      03,             04,         05,         06,              07,              08,                         09,                                              10 }
                            aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta de Notificacoes", "Evento: " + cCodEvent + " " + RTrim(cDesEvent) })
                            aParams := {}
                            aAdd(aParams, { { "cNumSenf", "'" + cNumSenf + "'" }, { "cCodSiste", "'" + cCodSiste + "'" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                        EndIf
                    EndIf
                    ZTN->(DbSkip())
                End
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4703 ºAutor ³Jonathan Schmidt Alves º Data ³01/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao da Capa Export (Retorno Senf) P R O C E S S A  º±±
±±º          ³                                                      6004  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Atualiza dados do Embarque/Pedido de Venda/Nota de Saida   º±±
±±º          ³ no Totvs conforme XML carregado na notificacao.            º±±
±±º          ³ Tabelas Totvs: EEC/SYQ/SYR/EE7/EE8/EE9/EXL/SC5/SC6         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4703( nMsgPrc )
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
Local aXmls := {}
Local aDados := {}
Local lVld := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local cError := ""
Local cWarning := ""
Private _cFilEEC := xFilial("EEC")
Private _cFilEXL := xFilial("EXL")
Private _cFilSYR := xFilial("SYR")
Private _cFilEE7 := xFilial("EE7")
Private _cFilEE8 := xFilial("EE8")
Private _cFilEE9 := xFilial("EE9")
Private _cFilSC5 := xFilial("SC5")
Private _cFilSC6 := xFilial("SC6")
Default nMsgPrc := 0
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
If ZTN->(DbSeek(_cFilZTN + "6004" + "3"))
    While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN == "6004" .And. ZTN->ZTN_STATHO == "3"
        If ZTN->ZTN_STATOT == "05" // "05"=Em Processamento Totvs (com Xml baixado)
            If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa e Filial conforme
                If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                    aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETESSENFRESPONSE", "" }, { "ESSENFHEADER", "" }, { "NUMPROCESSO", "", "AllwaysTrue()" } })
                    aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETESSENFRESPONSE", "" }, { "ESSENFHEADER", "" }, { "ESSENFITEMCOLLECTION", "" }, { "ESSENFITEM", "" }, { "NCM", "", "AllwaysTrue()" } })
                    aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETESSENFRESPONSE", "" }, { "ESSENFHEADER", "" }, { "ESSENFDESPESACOLLECTION", "" }, { "ESSENFDESPESA", "", "" }, { "NUMSENF", "", "AllwaysTrue()" } })
                    cRetXml := ZTN->ZTN_XMLRET // Xml completo da nota Senf Export
                    aDados := { Array(0), Array(0), Array(0) }
                    cMsg01 := "Processo Exportacao: " + ZTN->ZTN_PVC201             // Ex: "0105003997-01"
                    cMsg02 := ""
                    cMsg03 := ""
                    cMsg04 := ""
                    If Len(aXmls) > 0 // Matriz carregada para localizacoes
                        oXml := XmlParser(cRetXml, "_", @cError, @cWarning)
                        If XMLChildCount(oXml) > 0
                            For _w0 := 1 To Len( aXmls )
                                aXml := aXmls [ _w0 ]
                                cObj := "oXml"
                                cHldObj := ""
                                cHldOld := ""
                                _w1 := 1
                                _w3 := 0
                                While _w1 <= Len(aXml)
                                    _w2 := 1
                                    While _w2 <= XMLChildCount(&(cObj))
                                        cChk := ""
                                        If ValType( XMLGetChild(&(cObj),_w2) ) == "A" // Se for matriz
                                            _w3++
                                            If _w3 <= Len( XMLGetChild(&(cObj),_w2) ) // Rodo nas duas/tres/etc notificacoes
                                                cChk := Upper(StrTran( XMLGetChild(&(cObj),_w2)[ _w3 ]:RealName,":","_"))
                                                _w2--
                                            EndIf
                                        Else // Se ja eh objeto
                                            cChk := Upper(StrTran(XMLGetChild(&(cObj),_w2):RealName,":","_"))
                                        EndIf
                                        If !Empty(cChk) .And. cChk == aXml[_w1,01] // Noh conforme
                                            If ValType( &(cObj + ":_" + cChk) ) == "A"
                                                cHldOld := cObj
                                                cObj += ":_" + cChk
                                                cHldObj := cObj // Hold do objeto
                                                cObj += "[" + cValToChar(_w3) + "]"
                                            Else
                                                cObj += ":_" + cChk
                                            EndIf
                                            If !Empty(aXml[_w1,02]) .And. Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02] .Or. (Len( aXml[_w1] ) >= 3 .And. !Empty( aXml[_w1,03] ) .And. &(aXml[_w1,03])) // .T.=Sucesso
                                                // ############## SENF EXPORT #################
                                                If .T. // PKG_ES_GEN_SENF_ATUALIZA // "OIFEXPORT" $ ZT1->ZT1_NOMAPI // Consultas Notificacoes
                                                    oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                                    If ValType(oXml2) == "O"
                                                        If _w0 == 1 // Cabecalho
                                                            aFlds := { { "NUMPROCESSO", "" },;              // 01   <numProcesso>0105003997</numProcesso>
                                                                    { "NUMINVOICE", "" },;                  // 02   <numInvoice>0105003997-01</numInvoice>
                                                                    { "CODPARCEIROIMPORTADOR", "" },;       // 03   <codParceiroImportador>C0109709401</codParceiroImportador>
                                                                    { "NOMEPARCEIROIMPORTADOR", "" },;      // 04   <nomeParceiroImportador>INGCER S.A.</nomeParceiroImportador>
                                                                    { "CODVIATRANSPORTE", "" },;            // 04   <codViaTransporte>11</codViaTransporte>                             SYR Via Transporte
                                                                    { "CODPORTOEMBARQUE", "" },;            // 05   <codPortoEmbarque>VCP</codPortoEmbarque>                            SYR Origem
                                                                    { "CODPORTODESTINO", "" },;             // 06   <codPortoDestino>STG</codPortoDestino>                              SYR Destino
                                                                    { "CODPARCEIROTRANSPORTADORA", "" },;   // 07   codParceiroTransportadora
                                                                    { "CODNATUREZAOPERACAO", "" },;         // 08   codNaturezaOperacao
                                                                    { "DESCNATUREZAOPERACAO", "" },;        // 09   <descNaturezaOperacao>Venda de produção do estabelecimento
                                                                    { "TAXAMOEDACONVERSAOSENF", "" },;      // 10   <taxaMoedaConversaoSenf>5.3019</taxaMoedaConversaoSenf>             Ex: 5.3019
                                                                    { "MOEDAMEGOCIADA", "" },;              // 11   <moedaMegociada>USD</moedaMegociada>
                                                                    { "SATRIBFLEX18", "" },;                // 12   <sAtribFlex18>CAIXAS</sAtribFlex18>                                 Ex: "CAIXAS", "PALLET", "VOLUME", etc
                                                                    { "NATRIBFLEX1", "" } }                 // 13   <nAtribFlex1>1</nAtribFlex1>                                        Ex: 1

                                                        ElseIf _w0 == 2 // Itens
                                                            aFlds := { { "NUMSENF", "" },;                  // 01   <numSenf>0105003997-01</numSenf>
                                                                    { "SEQITEMSENF", "" },;                 // 02   <seqItemSenf>1</seqItemSenf>
                                                                    { "PARTNUMBER", "" },;                  // 03   <partNumber>SDD61C10</partNumber>
                                                                    { "ORDEM", "" },;                       // 04   <ordem>0105003997/21</ordem>
                                                                    { "ORDEMITEM", "" },;                   // 05   <ordemItem>1</ordemItem>
                                                                    { "NUMPROCESSO", "" },;                 // 06   <numProcesso>0105003997</numProcesso>
                                                                    { "SEQITEMPROCESSO", "" },;             // 07   <seqItemProcesso>1</seqItemProcesso>
                                                                    { "NUMINVOICE", "" },;                  // 08   <numInvoice>0105003997-01</numInvoice>
                                                                    { "SEQITEMINVOICE", "" },;              // 09   <seqItemInvoice>1</seqItemInvoice>
                                                                    { "VALORUNITVMCVITEM", "" },;           // 10   EE9_PRECO    EE8_PRECO
                                                                    { "VALORUNITVMLEITEM", "" },;           // 11
                                                                    { "PESOLIQUNIT", "" },;                 // 12   EE9_PSLQUN   EE8_PSLQUN
                                                                    { "PESOBRUTOUNIT", "" } }               // 13   EE9_PSBRUN   EE8_PSBRUN
                                                        ElseIf _w0 == 3 // Despesa
                                                            aFlds := { { "NUMSENF", "" },;                  // 01   <numSenf>0105003997-01</numSenf>
                                                                    { "CODAREANEGOCIO", "" },;              // 02   <codAreaNegocio>STECK FABRICA</codAreaNegocio>
                                                                    { "DESCAREANEGOCIO", "" },;             // 03   <descAreaNegocio>STECK FABRICA</descAreaNegocio>
                                                                    { "CODDESPESA", "" },;                  // 04   <codDespesa>FRETE</codDespesa>                                      FRETE, SEGURO, OUTRAS DESPESAS
                                                                    { "DESCDESPESA", "" },;                 // 05   <descDespesa>Frete Internacional</descDespesa>
                                                                    { "VALORDESPESAPREVISTA", "" },;        // 06   <valorDespesaPrevista>120</valorDespesaPrevista>
                                                                    { "CODMOEDAPREVISTA", "" },;            // 07   <codMoedaPrevista>USD</codMoedaPrevista>
                                                                    { "VALORDESPESAREAL", "" },;            // 08   <valorDespesaReal>120</valorDespesaReal>                            EXL_MDFR Moeda do Frete   EXL_VDFR   Valor do Frete     EXL_MDSE Moeda do Seguro      EXL_VDSE Valor do Seguro
                                                                    { "MOEDADESPESAREAL", "" },;            // 09   <moedaDespesaReal>USD</moedaDespesaReal>
                                                                    { "CODPARCEIROCREDOR", "" },;           // 10   <codParceiroCredor>F0101964501</codParceiroCredor>
                                                                    { "DESCPARCEIROCREDOR", "" } }          // 11   <descParceiroCredor>MAERSK LOGISTICS SERVICES BRASIL LTDA
                                                        EndIf
                                                        For _w4 := 1 To XMLChildCount(oXml2)
                                                            cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                            If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                                aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                            EndIf
                                                        Next
                                                        aDadosItens := {}
                                                        aDadosDesps := {}
                                                        For _w4 := 1 To Len( aFlds )
                                                            If _w0 == 1 // Cabecalho
                                                                aAdd(aDados[01], { aFlds[_w4,01], aFlds[_w4,02] })
                                                            ElseIf _w0 == 2 // Gravacao dos Itens
                                                                aAdd(aDadosItens, { aFlds[_w4,01], aFlds[_w4,02] })
                                                            ElseIf _w0 == 3 // Despesas
                                                                aAdd(aDadosDesps, { aFlds[_w4,01], aFlds[_w4,02] })
                                                            EndIf
                                                        Next
                                                        If _w0 == 2 // Itens
                                                            aAdd(aDados[_w0], aClone(aDadosItens) )
                                                        ElseIf _w0 == 3 // Despesas
                                                            aAdd(aDados[_w0], aClone(aDadosDesps) )
                                                        EndIf
                                                    EndIf
                                                EndIf
                                                // ############## SENF EXPORT #################
                                                If !Empty( cHldObj ) // Matriz de objetos
                                                    If _w3 < Len( &(cHldObj) )
                                                        cObj := cHldOld // Volto o objeto antigo (antes da matriz)
                                                        _w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
                                                    Else // Ja processou todos
                                                        // aRet[01] := .T.
                                                    EndIf
                                                Else // Nao tem matriz de objetos
                                                    // aRet[01] := .T.
                                                EndIf
                                                If .F. // aRet[01] // .T.=Ja concluido
                                                    _w1 := Len(aXml) + 1
                                                EndIf
                                            EndIf
                                            Exit
                                        EndIf
                                        _w2++
                                    End
                                    _w1++
                                End
                            Next
                        EndIf
                    EndIf
                    // Atualizar dados no Totvs com os dados carregados (Matriz aDados)
                    If Len(aDados[01]) > 0 .And. Len(aDados[02]) > 0 // Cabecalho e Itens carregados
                        DbSelectArea("EEC")
                        EEC->(DbSetOrder(1)) // EEC_FILIAL + EEC_PREEMB
                        DbSelectArea("SYQ")
                        SYQ->(DbSetOrder(1)) // YQ_FILIAL + YQ_VIA
                        DbSelectArea("SYR") // Via Origem Destino
                        SYR->(DbSetOrder(1)) // YR_FILIAL + YR_VIA + YR_ORIGEM + YR_DESTINO + YR_TIPTRAN
                        DbSelectArea("EE7")
                        EE7->(DbSetOrder(1)) // EE7_FILIAL + EE7_PEDIDO
                        DbSelectArea("EE8")
                        EE8->(DbSetOrder(1)) // EE8_FILIAL + EE8_PEDIDO + EE8_SEQUEN + EE8_COD_I
                        DbSelectArea("EE9")
                        EE9->(DbSetOrder(2)) // EE9_FILIAL + EE9_PREEMB + EE9_PEDIDO + EE9_SEQUEN
                        DbSelectArea("EXL")
                        EXL->(DbSetOrder(1)) // EXL_FILIAL + EXL_PREEMB
                        DbSelectArea("SC5")
                        SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
                        DbSelectArea("SC6")
                        SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
                        If EEC->(DbSeek( _cFilEEC + PadR(SubStr(aDados[ 01, 01, 02 ],5,20),TamSX3("EEC_PREEMB")[01]) ))
                            // Atualizacao Via + Origem + Destino
                            If !Empty( aDados[ 01, 05, 02 ] ) .And. !Empty( aDados[ 01, 06, 02 ] ) .And. !Empty( aDados[ 01, 07, 02 ] ) // Via + Origem + Destino (SYR)
                                SYQ->(DbGotop())
                                While SYQ->(!EOF())
                                    If SYQ->YQ_CODFIES == aDados[ 01, 05, 02 ] .Or. Val(SYQ->YQ_CODFIES) == Val(aDados[ 01, 05, 02 ]) // Codigo Via confere
                                        If SYR->(DbSeek( _cFilSYR + SYQ->YQ_VIA + aDados[ 01, 06, 02 ] + aDados[ 01, 07, 02 ] ))
                                            If aDados[ 01, 05, 02 ] <> SYR->YR_VIA .Or. aDados[ 01, 06, 02 ] <> SYR->YR_ORIGEM .Or. aDados[ 01, 07, 02 ] <> SYR->YR_DESTINO // Algum mudou... regravo
                                                RecLock("EEC",.F.)
                                                EEC->EEC_VIA    := SYR->YR_VIA          // Via atualizada           Ex: "11"
                                                EEC->EEC_ORIGEM := SYR->YR_ORIGEM       // Origem atualizada        Ex: "VCP" Viracopos
                                                EEC->EEC_DEST   := SYR->YR_DESTINO      // Destino atualizado       Ex: "STG" Santiago
                                                EEC->(MsUnlock())
                                            EndIf
                                        EndIf
                                        Exit
                                    EndIf
                                    SYQ->(DbSkip())
                                End
                            EndIf

                            // Atualizacao Capa no EE7
                            If EE7->(DbSeek(_cFilEE7 + EEC->EEC_PEDREF))
                                If SC5->(DbSeek(_cFilSC5 + EE7->EE7_PEDFAT))

                                    // Atualizacao Especie e Volumes (Jonathan 02/12/2021)
                                    RecLock("SC5",.F.)
                                    If !Empty( aDados[ 01, 12, 02 ] ) // Volume
                                        SC5->C5_ESPECI1  := aDados[ 01, 12, 02 ] // Volume              Ex: "CAIXAS", "PALLET", etc
                                    EndIf
                                    If !Empty( aDados[ 01, 13, 02 ] ) // Qtde de Volumes
                                        SC5->C5_VOLUME1 := Val(aDados[ 01, 13, 02 ]) // Qtde de volumes       Ex: 1
                                    EndIf
                                    SC5->(MsUnlock())

                                    For _w1 := 1 To Len(aDados[03])
                                        If aDados[03,_w1,09,02] == aDados[01,12,02] // Moeda confere com a moeda da Senf (obrigatorio)
                                            If aDados[03,_w1,04,02] == "FRETE"
                                                RecLock("EE7",.F.)
                                                EE7->EE7_FRPREV := Val(aDados[03,_w1,08,02]) * Val(aDados[01,11,02])  // Frete calculado na taxa enviada pelo Thomson
                                                EE7->(MsUnlock())

                                                RecLock("SC5",.F.)
                                                SC5->C5_FRETE := EE7->EE7_FRPREV
                                                SC5->(MsUnlock())

                                            ElseIf aDados[03,_w1,04,02] == "SEGURO"
                                                RecLock("EE7",.F.)
                                                EE7->EE7_TIPSEG := "2"                                      // 2=Fixo
                                                EE7->EE7_SEGPRE := Val(aDados[03,_w1,08,02]) * Val(aDados[01,11,02])  // Seguro calculado na taxa enviada pelo Thomson
                                                EE7->(MsUnlock())

                                                RecLock("SC5",.F.)
                                                SC5->C5_SEGURO := EE7->EE7_SEGPRE
                                                SC5->(MsUnlock())

                                            ElseIf aDados[03,_w1,04,02] == "DESCONTO"
                                                RecLock("EE7",.F.)
                                                EE7->EE7_XDESCO := Val(aDados[03,_w1,08,02]) * Val(aDados[01,11,02])  // Desconto calculado na taxa enviada pelo Thomson
                                                EE7->EE7_XDESC := Val(aDados[03,_w1,08,02]) // Valor em dolar
                                                EE7->(MsUnlock())

                                                RecLock("SC5",.F.)
                                                SC5->C5_DESCONT := EE7->EE7_XDESCO
                                                SC5->(MsUnlock())

                                            EndIf
                                        EndIf
                                    Next

                                    // Atualizacao Itens da Exportacao
                                    For _w1 := 1 To Len( aDados[02] ) // Rodo nos itens
                                        If SC6->(DbSeek( _cFilSC6 + SC5->C5_NUM + PadL( aDados[ 02, _w1, 07, 02 ], 02,"0") ))
                                            If EE8->(DbSeek( _cFilEE8 + EEC->EEC_PEDREF + PadL( aDados[ 02, _w1, 07, 02 ], 06) + PadL( aDados[ 02, _w1, 03, 02 ], 06) ))
                                                RecLock("EE8",.F.)
                                                EE8->EE8_PRECO := Val(aDados[ 02, _w1, 10, 02 ])
                                                EE8->(MsUnlock())
                                            EndIf
                                            If EE9->(DbSeek( _cFilEE9 + EEC->EEC_PREEMB + EEC->EEC_PEDREF + PadL( aDados[ 02, _w1, 07, 02 ], 06) ))
                                                RecLock("EE9",.F.)
                                                EE9->EE9_PRECO := Val(aDados[ 02, _w1, 10, 02 ])
                                                EE9->(MsUnlock())
                                            EndIf
                                        EndIf
                                    Next
                                EndIf

                            EndIf

                            // Atualizacao Despesas da Exportacao
                            For _w1 := 1 To Len( aDados[03] ) // Rodo nas despesas
                                If EXL->(DbSeek( _cFilEXL + EEC->EEC_PREEMB ))
                                    If "FRETE" $ aDados[ 03, _w1, 04, 02 ] // Atualizacao do
                                        RecLock("EXL",.F.)
                                        EXL->EXL_VDFR := Val(aDados[ 03, _w1, 08, 02 ]) // Valor do Frete
                                        EXL->(MsUnlock())
                                    ElseIf "SEGURO" $ aDados[ 03, _w1, 04, 02 ] // Atualizacao do Seguro
                                        RecLock("EXL",.F.)
                                        EXL->EXL_VDSE := Val(aDados[ 03, _w1, 08, 02 ]) // Valor do Seguro
                                        EXL->(MsUnlock())
                                    EndIf
                                EndIf
                            Next
                        Else // EEC nao encontrado no cadastro
                            cMsg01 := "Embarque nao encontrado no cadastro (EEC)!"
                            cMsg02 := "Empresa/Filial/Embarque: " + Left( aDados[ 01, 01, 02 ], 2) + "/" + SubStr(aDados[ 01, 01, 02 ],3,2) + "/" + SubStr(aDados[ 01, 01, 02 ],5,20)
                            cMsg03 := "A atualizacao nao pode ser processada!"
                            cMsg04 := ""
                            lVld := .F.
                        EndIf
                    Else // Dados nao carregados
                        cMsg01 := "Dados nao foram carregados (XML)!"
                        cMsg02 := "Processo Exportacao: " + ZTN->ZTN_PVC201             // Ex: "0105003997-01"
                        cMsg03 := "A atualizacao nao pode ser processada!"
                        cMsg04 := ""
                        lVld := .F.
                    EndIf
                    If lVld // .T.=Valido
                        RecLock("ZTN",.F.)
                        ZTN->ZTN_STATOT := "06" // "06"=Capa atualizada com sucesso (pendente enviar Thomson)
                        ZTN->ZTN_DETPR1 := "Capa atualizada com sucesso!"
                        ZTN->ZTN_DETPR2 := ""
                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                        ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                        ZTN->(MsUnlock())
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processo Exportacao realizado com sucesso!")
                        cMsg02 := "Processo Exportacao realizado com sucesso!"
                        // Processamento realizado com sucesso!
                        If nMsgPrc == 2 // 2=AskYesNo
                            u_AskYesNo(3500,"WsRc1603",cMsg01,cMsg02,cMsg03,cMsg04,"","OK")
                        ElseIf nMsgPrc == 1 // 1=MsgInfo
                            MsgInfo(cMsg01 + Chr(13) + Chr(10) + ;
                            cMsg02 + Chr(13) + Chr(10) +  ;
                            cMsg03 + Chr(13) + Chr(10) + ;
                            cMsg04,"WsRc1603")
                        EndIf
                    Else // .F.=Invalido
                        RecLock("ZTN",.F.)
                        ZTN->ZTN_STATOT := "41" // "41"=Processado XML com falha (pendente enviar Thomson)
                        ZTN->ZTN_DETPR1 := "Erro ao Atualizar a Capa"               // Mensagem simplificada
                        ZTN->ZTN_DETPR2 := cMsg02 + " " + cMsg03 + " " + cMsg04     // Mensagem detalhada da falha
                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()              // Ex: 08/08/2021 12:00:03
                        ZTN->ZTN_USERLG := cUserName                                // Ex: "jonathan.sigamat"
                        ZTN->(MsUnlock())
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha:")
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg01)
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg03)
                        ConOut("WsRc1603: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg04)
                        If nMsgPrc == 2 // 2=AskYesNo
                            u_AskYesNo(3500,"WsRc1603",cMsg01,cMsg02,cMsg03,cMsg04,"","UPDERROR")
                        ElseIf nMsgPrc == 1 // 1=MsgStop
                            MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
                            cMsg02 + Chr(13) + Chr(10) +  ;
                            cMsg03 + Chr(13) + Chr(10) + ;
                            cMsg04,"WsRc1603")
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
        ZTN->(DbSkip())
    End
EndIf
Return { lVld, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*/
---------------------------------------------------------------------------
{Protheus.doc} retUn2UM
Retorna a unidade da 2a. Unidade de Medida 

@author Sergio S. Fuzinaka
@since 12.07.2017
@version 1.0  
---------------------------------------------------------------------------
/*/
Static Function retUn2UM( lNoImp2UM, cCFOPExp, cCFOP, cUMDIPI, cUM)

Local cReturn := ""

// Tratamento para operacoes dentro do País
If lNoImp2UM
    If ( Left(cCFOP,1) $ "3-7" ) .Or. ( cCFOP $ cCFOPExp )
        If !Empty( cUMDIPI )
            cReturn := cUMDIPI
        Else
            cReturn := cUM
        Endif
    Else
        cReturn := cUM
    Endif
Else
    If !Empty( cUMDIPI )
        cReturn := cUMDIPI
    Else
        cReturn := cUM
    Endif
Endif

Return( cReturn )

/*/
---------------------------------------------------------------------------
{Protheus.doc} retQtd2UM
Retorna a quantidade da 2a. Unidade de Medida

@author Sergio S. Fuzinaka
@since 12.07.2017
@version 1.0  
---------------------------------------------------------------------------
/*/
Static Function retQtd2UM( lNoImp2UM, cCFOPExp, cCFOP, nCONVDIP, nQUANT)

Local nReturn := 0

// Tratamento para operacoes dentro do País
If lNoImp2UM
    If ( Left(cCFOP,1) $ "3-7" ) .Or. ( cCFOP $ cCFOPExp )
        If nCONVDIP > 0
            nReturn := ( nCONVDIP * nQUANT )
        Else
            nReturn := nQUANT
        Endif
    Else
        nReturn := nQUANT
    Endif
Else
    If nCONVDIP > 0
        nReturn := ( nCONVDIP * nQUANT )
    Else
        nReturn := nQUANT
    Endif
Endif

//O valor é limitado a 4 casas deciamais 
//porque o Schema(.XSD) da Sefaz nao aceita mais que 4 casas
nReturn := NoRound(nReturn,4)

Return( nReturn )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4801 ºAutor ³Jonathan Schmidt Alves º Data ³16/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Notificacoes (Cambio Exportacao) C O N S U L T A  º±±
±±º          ³                                                  ZTX 6011  º±±
±±º          ³ ID Interface no In-Out: PRC_IT_CE_OUT_TXT                  º±±
±±º          ³ API: PRC_IT_CE_OUT_TXT                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PRC_IT_CE_OUT_TXT"                                     º±±
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
±±º          ³ Consulta notificacoes para na sequencia gerar dados na ZTX º±±
±±º          ³ (Contrato Cambio Exp) que sao os dados do evento 6011.     º±±
±±º          ³ Tabelas Totvs: ZTN                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4801()
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado

            aEveCtb := { { "01", "Adiantamento", "1" } , { "02", "Prestacao", "2" }, { "03", "Pagamento", "3" } }

            // "2"=Variacao Cambial + Compensacao da RA gerada anteriormente (vai estar no valor batido)
            // "3"=Variacao Cambial + Baixa Receber do titulo gerado (vai estar no valor batido)

            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            If ZTN->(DbSeek( _cFilZTN + "6011" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6011" + "3" // "6011"=Contrato Cambio Export
                    If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                        If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                            // Posicionamentos:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            For _w1 := 1 To 3
                                cEveCtb := aEveCtb[ _w1, 03 ]
                                
                                // idEventoContabil     "1"=Adiantamento (RA)       Gerar RA no Financeiro  FINA040
                                // idEventoContabil     "2"=Compensacao             Compensar 1 RA com 1 Pgto
                                // idEventoContabil     "3"=Manutencao Cambio       Gerar Manutencao Cambio (rotina do EEC)

                                // ###################### PROCESSO CAMBIO EXPORTACAO #############################
                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,        Titulo Integracao, Msg Processamento }
                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                       09,                10 }
                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta Cambio Export",      "Processo: " })
                                aParams := {}
                                aAdd(aParams, { { "cIdLanc", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cEveCtb", "'" + cEveCtb + "'" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
                            Next
                        EndIf
                    EndIf
                    ZTN->(DbSkip())
                End
            End
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4803 ºAutor ³Jonathan Schmidt Alves º Data ³02/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao/Envio da Senf Exportacao.      I N C L U S A O  º±±
±±º          ³                                                      6004  º±±
±±º          ³ ID Interface no In-Out: ORDENS                             º±±
±±º          ³ API: PKG_ES_GEN_NF_ATUALIZA                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_ES_GEN_NF_ATUALIZA"                                º±±
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
±±º          ³ Envia para o Thomson os dados da Nota Fiscal de Exportacao º±±
±±º          ³ que foi transmitida para a Sefaz no Totvs.                 º±±
±±º          ³ Tabelas Totvs: EEC/EE9/SF2/SA1/SD2/SC6/SB1/SB5             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4803()
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            // Posicionamentos:
            aRecTab := { { "EEC", Array(0) }, { "SF2", Array(0) }, { "SM2", Array(0) }, { "SA1", Array(0) }, { "ZTN", Array(0) } }
            If ZTN->(DbSeek(_cFilZTN + "6004" + "3"))
                While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6004" + "3"
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_STATOT == "07" // "07"=Capa atualizada com sucesso! (notificado Thomson)
                            If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                                //        {      Cabec,    Itens }
                                aDados := { Array(0), Array(0) }
                                aRepets := {}
                                aParams := {}
                                aReps := {}
                                aVars := {}
                                cError := ""
                                cWarning := ""
                                oXml := XmlParser(ZTN->ZTN_XMLRET, "_", @cError, @cWarning)
                                aXmls := {}
                                aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETESSENFRESPONSE", "" }, { "ESSENFHEADER", "" }, { "CODTIPOEXPORTACAO", "", "AllwaysTrue()" } })
                                aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETESSENFRESPONSE", "" }, { "ESSENFHEADER", "" }, { "ESSENFITEMCOLLECTION", "" }, { "ESSENFITEM", "" }, { "TIPOREGIME", "EXPORTACAO" } })
                                aFlds := {}
                                If XMLChildCount(oXml) > 0
                                    For _w0 := 1 To Len( aXmls )
                                        aXml := aXmls [ _w0 ]
                                        cObj := "oXml"
                                        cHldObj := ""
                                        cHldOld := ""
                                        _w1 := 1
                                        _w3 := 0
                                        While _w1 <= Len(aXml)
                                            _w2 := 1
                                            While _w2 <= XMLChildCount(&(cObj))
                                                cChk := ""
                                                If ValType( XMLGetChild(&(cObj),_w2) ) == "A" // Se for matriz
                                                    _w3++
                                                    If _w3 <= Len( XMLGetChild(&(cObj),_w2) ) // Rodo nas duas/tres/etc notificacoes
                                                        cChk := Upper(StrTran( XMLGetChild(&(cObj),_w2)[ _w3 ]:RealName,":","_"))
                                                        _w2--
                                                    EndIf
                                                Else // Se ja eh objeto
                                                    cChk := Upper(StrTran(XMLGetChild(&(cObj),_w2):RealName,":","_"))
                                                EndIf
                                                If !Empty(cChk) .And. cChk == aXml[_w1,01] // Noh conforme
                                                    If ValType( &(cObj + ":_" + cChk) ) == "A"
                                                        cHldOld := cObj
                                                        cObj += ":_" + cChk
                                                        cHldObj := cObj // Hold do objeto
                                                        cObj += "[" + cValToChar(_w3) + "]"
                                                    Else
                                                        cObj += ":_" + cChk
                                                    EndIf
                                                    If _w1 == Len( aXml ) // Chegou no ultimo elemento // .T. // !Empty(aXml[_w1,02])
                                                        If Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02] .Or. (Len(aXml[_w1]) >= 3 .And. &(aXml[_w1,03])) // .T.=Sucesso
                                                            // ############## getEsSenfResponse #################
                                                            If .T. // "OIFEXPORT" $ ZT1->ZT1_NOMAPI // Consultas Notificacoes
                                                                oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                                                If ValType(oXml2) == "O"
                                                                    If _w0 == 1 // Cabecalho
                                                                        aFlds := { { "NUMPROCESSO", "", "" },;      // 01   <numProcesso>0102004059</numProcesso>                           Ex: 0102004059
                                                                        { "NUMINVOICE", "", "" },;                  // 02   <numInvoice>0102004059-01</numInvoice>                          Ex: 0102004059-01
                                                                        { "NUMSENF", "", "" },;                     // 03   <numSenf>0102004059-01</numSenf>                                Ex: 0102004059-01
                                                                        { "TAXAMOEDACONVERSAOSENF", "", "" } }      // 04   <taxaMoedaConversaoSenf>5.4605</taxaMoedaConversaoSenf> }       Ex: 5.4605
                                                                    ElseIf _w0 == 2 // Itens
                                                                        aFlds := { { "ORDEM", "", "" }, { "ORDEMITEM", "", "" }, { "PARTNUMBER", "", "" }, { "QTDEITEM", "", "" },;
                                                                        { "SEQITEMINVOICE", "", "" }, { "SEQITEMPROCESSO", "", "" }, { "SEQITEMSENF", "", "" } }
                                                                    EndIf
                                                                    For _w4 := 1 To XMLChildCount(oXml2)
                                                                        cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                                        If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                                            aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                                        EndIf
                                                                    Next
                                                                    If _w0 == 1 // Cabecalho
                                                                        For _w4 := 1 To Len( aFlds )
                                                                            aAdd(aDados[ 01 ], aFlds[_w4,02]) // Inclusao do resultado no aDados
                                                                        Next
                                                                    Else // Itens
                                                                        aDado := {}
                                                                        For _w4 := 1 To Len( aFlds )
                                                                            aAdd(aDado, aFlds[_w4,02]) // Inclusao do resultado no aDados
                                                                        Next
                                                                        aAdd(aDados[02], aClone(aDado))
                                                                    EndIf
                                                                EndIf
                                                                // ############## getEsSenfResponse #################
                                                            EndIf
                                                            If !Empty( cHldObj ) // Matriz de objetos
                                                                If _w3 < Len( &(cHldObj) )
                                                                    cObj := cHldOld // Volto o objeto antigo (antes da matriz)
                                                                    _w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
                                                                Else // Ja processou todos
                                                                    // aRet[01] := .T.
                                                                EndIf
                                                            Else // Nao tem matriz de objetos
                                                                // aRet[01] := .T.
                                                            EndIf
                                                        EndIf
                                                    EndIf
                                                EndIf
                                                _w2++
                                            End
                                            _w1++
                                        End
                                    Next
                                    If Len(aDados[01]) > 0 .And. Len(aDados[02]) > 0 // Dados carregados (Cabecalho/Item) Len( aFlds ) > 0 .And. !Empty(aFlds[ 01, 02 ]) // Numero Senf carregado etc
                                        aDadosFat := {}
                                        nPesLiqTot := 0 // Peso liquido total
                                        nPesBruTot := 0 // Peso bruto total
                                        
                                        nTaxMoeda := Val(aDados[ 01, 04 ]) // Taxa Moeda
                                        
                                        If nTaxMoeda > 0 // Taxa moeda estrangeira carregada (usado no ZT2 pra calculo em reais)
                                            
                                            cCFOPUni := ""
                                            If EEC->(DbSeek( _cFilEEC + SubStr(aDados[ 01,01 ],5,20) )) // EEC_PREEMB
                                                If EE9->(DbSeek( _cFilEE9 + EEC->EEC_PREEMB )) // Identificacao dos itens EE9 do embarque que ja foram faturados
                                                    While EE9->(!EOF()) .And. EE9->EE9_FILIAL + EE9->EE9_PREEMB == _cFilEE9 + EEC->EEC_PREEMB // Pedido conforme
                                                        If !Empty( EE9->EE9_NF ) // Nota faturada
                                                            aAdd(aDadosFat, { EE9->EE9_NF, EE9->EE9_SERIE, EE9->EE9_COD_I, EE9->(Recno()) })
                                                        EndIf
                                                        EE9->(DbSkip())
                                                    End
                                                EndIf
                                                If Len( aDadosFat ) > 0 // Dados carregados
                                                    For _w1 := 1 To Len( aDadosFat ) // Rodo nos doc saida
                                                        EE9->(DbGoto( aDadosFat[_w1,04] )) // Reposiciono EE9
                                                        If SF2->(DbSeek( _cFilSF2 + aDadosFat[_w1,01] + aDadosFat[_w1,02] ))
                                                            If !Empty( SF2->F2_CHVNFE ) // Nota ja transmitida
                                                            
                                                                If SA1->(DbSeek( _cFilSA1 + SF2->F2_CLIENTE + SF2->F2_LOJA ))

                                                                    // Taxa da moeda conforme o faturamento SF2 (usado no ZT2 pra calculo em reais)
                                                                    If _w1 == 1
                                                                        nTaxMoeda := 0
                                                                        SM2->(DbSeek( DtoS(SF2->F2_EMISSAO), .T. ))
                                                                        While SM2->(!BOF()) .And. nTaxMoeda == 0
                                                                            If EEC->EEC_MOEDA == "US$" // 2=Dolar
                                                                                nTaxMoeda := SM2->M2_MOEDA2
                                                                            Else // 4=Euro
                                                                                nTaxMoeda := SM2->M2_MOEDA4
                                                                            EndIf
                                                                            SM2->(DbSkip(-1))
                                                                        End
                                                                    EndIf

                                                                    If nTaxMoeda > 0 // Taxa carregada
                                                                        If SD2->(DbSeek( _cFilSD2 + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + aDadosFat[_w1,03] + StrZero(_w1,2) ))
                                                                            If .T. // SD2->D2_PREEMB == EEC->EEC_PREEMB // Preemb conforme
                                                                                If SC6->(DbSeek( _cFilSC6 + SD2->D2_PEDIDO + SD2->D2_ITEMPV )) // Item do Pedido conforme
                                                                                    If SB1->(DbSeek( _cFilSB1 + SD2->D2_COD ))
                                                                                        If _w1 == 1
                                                                                            aAdd(aRecTab[01,02], EEC->(Recno()))    // Recno EEC
                                                                                            aAdd(aRecTab[02,02], SF2->(Recno()))    // Recno SF2
                                                                                            aAdd(aRecTab[03,02], SM2->(Recno()))    // Recno SM2
                                                                                            aAdd(aRecTab[04,02], SA1->(Recno()))    // Recno SA1
                                                                                            aAdd(aRecTab[05,02], ZTN->(Recno()))    // Recno ZTN
                                                                                        EndIf
                                                                                        If (nFind := ASCan(aDados[02], {|x|, PadR(x[03],15) == SD2->D2_COD .And. Val(x[04]) == SD2->D2_QUANT })) > 0 // Item no aDados[02]
                                                                                            // Repets Itens
                                                                                            aTabs := {}
                                                                                            aAdd(aTabs, { "EE9", EE9->(Recno()) })      // Recno EE9
                                                                                            aAdd(aTabs, { "SD2", SD2->(Recno()) })      // Recno SD2
                                                                                            aAdd(aTabs, { "SC6", SC6->(Recno()) })      // Recno SC6
                                                                                            aAdd(aTabs, { "SB1", SB1->(Recno()) })      // Recno SB1
                                                                                            If SB5->(DbSeek( _cFilSB5 + SD2->D2_COD ))
                                                                                                aAdd(aTabs, { "SB5", SB5->(Recno()) })  // Recno SB5
                                                                                            Else
                                                                                                aAdd(aTabs, { "SB5", 0 })               // Recno SB5
                                                                                            EndIf
                                                                                            aAdd(aReps, aClone( aTabs ))
                                                                                        
                                                                                            // Obtencao da Unidade e Quantidade Tributavel (Robson)
                                                                                            // <pkg:piAtribFlexVcString1>?</pkg:piAtribFlexVcString1>       cUTrib
                                                                                            // <pkg:piAtribFlexNumber1>?</pkg:piAtribFlexNumber1>           cQTrib

                                                                                            // Parametro Logico - Define se sera impresso a 2a. Unidade de Medida para operacoes dentro do País - Opcoes: [.T.]-Não Imprime ou [.F.]-Imprime (Default)
                                                                                            lNoImp2UM := GetNewPar("MV_NIMP2UM",.F.)

                                                                                            //Relacao de CFOP's vinculadas a exportacao - NT 2016.001
                                                                                            cCFOPExp := "1501-2501-5501-5502-5504-5505-6501-6502-6504-6505"

                                                                                            cUTrib := RetUn2UM( lNoImp2UM, cCFOPExp, Alltrim(SD2->D2_CF), SB5->B5_UMDIPI, SB1->B1_UM )
                                                                                            cQTrib := RetQtd2UM( lNoImp2UM, cCFOPExp, Alltrim(SD2->D2_CF), SB5->B5_CONVDIP, SD2->D2_QUANT )

                                                                                            aAuxs := {}
                                                                                            aAdd(aAuxs, { "cItemInvoi", aDados[02,nFind,05] })
                                                                                            aAdd(aAuxs, { "cItemProce", aDados[02,nFind,06] })
                                                                                            aAdd(aAuxs, { "cItemSenf",  aDados[02,nFind,07] })
                                                                                            aAdd(aAuxs, { "cUTrib",     cUTrib              })
                                                                                            aAdd(aAuxs, { "cQTrib",     cValToChar(cQTrib)  })
                                                                                            aAdd(aVars, aClone( aAuxs ))
                                                                                            
                                                                                            nPesLiqTot += SD2->D2_QUANT /*EE9->EE9_SLDINI*/ * EE9->EE9_PSLQUN // SB1->B1_PESO * SD2->D2_QUANT
                                                                                            nPesBruTot += SD2->D2_PESO // SB1->B1_PESBRU * SD2->D2_QUANT
                                                                                            If Empty(cCFOPUni)
                                                                                                cCFOPUni := RTrim(SD2->D2_CF)
                                                                                            EndIf
                                                                                        EndIf
                                                                                    EndIf
                                                                                EndIf
                                                                            EndIf
                                                                        EndIf
                                                                    EndIf

                                                                EndIf

                                                            Else // Documento/Serie ainda nao foi transmitido
                                                                cMsg01 := "Documento/Serie nao foi ainda transmitido Sefaz!"
                                                                cMsg02 := "Documento/Serie/Cli/Loja/Tipo: " + SF2->F2_DOC + "/" + SF2->F2_SERIE + "/" + SF2->F2_CLIENTE + "/" + SF2->F2_LOJA + "/" + SF2->F2_TIPO
                                                                cMsg03 := "Verifique se a nota foi transmitida e tem a chave preenchida (F2_CHVNFE)"
                                                                cMsg04 := ""
                                                                lRet := .F.

                                                            EndIf
                                                        EndIf
                                                    Next
                                                    If Len(aReps) > 0
                                                        //            { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                        aAdd(aRepets, {      "10", aClone( aReps ), aClone( aVars ) })
                                                    EndIf
                                                    If Len(aRepets) > 0 // Recnos carregados
                                                        // ###################### NOTA FISCAL EXPORTACAO #############################
                                                        //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,        Titulo Integracao, Msg Processamento }
                                                        //            {        01,                      02,      03,             04,         05,         06,              07,              08,                       09,                10 }
                                                        aAdd(aMethds, {        "",                 cNomApi,      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Envio da NF Exportacao", "Exportacao: "    })
                                                        aParams := {}
                                                        aAdd(aParams, { { "cNumProc", "'" + aDados[ 01, 01 ] + "'" }, { "cNumInvoi", "'" + aDados[ 01, 02 ] + "'" }, { "cNumSenf", "'" + aDados[ 01, 03 ] + "'" }, { "cCFOPUni", "'" + cCFOPUni + "'" }, { "nTaxMoeda", cValToChar(nTaxMoeda) }, { "nPesLiqTot", cValToChar(nPesLiqTot) }, { "nPesBruTot", cValToChar(nPesBruTot) } }) // Variaveis auxiliares
                                                        aAdd(aTail(aMethds)[06], aClone(aParams))
                                                    EndIf
                                                Else // Notas sem EE9_NF preenchido (usuario)
                                                    cMsg01 := "Documento de Saida nao preenchido no Embarque (EE9_NF)!"
                                                    cMsg02 := "Verifique o preenchimento e tente novamente!"
                                                    cMsg03 := "Embarque: " + EEC->EEC_PREEMB
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            EndIf // Embarque conforme (EEC)

                                        EndIf // Taxa moeda carregada
                                    EndIf
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                    ZTN->(DbSkip())
                End
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4903 ºAutor ³Jonathan Schmidt Alves º Data ³27/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao/Baixa Titulos Receb (Cambio Exp) P R O C E S S A  º±±
±±º          ³                                                  ZTX 6011  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera Titulos, Baixas Processar os dados gerados na ZTX.    º±±
±±º          ³ Os processos poderao ser Incl de Titulos a Pagar, Baixa de º±±
±±º          ³ Titulos a Pagar ou Compensacoes                            º±±
±±º          ³ Tabelas Totvs: ZTX                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4903()
Local _w1
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local nOpc := 3 // 3=Inclusao
Local _cFilZTN := xFilial("ZTN")
Local _cFilSE1 := xFilial("SE1")
Local _cFilSA1 := xFilial("SA1")
// Local _cFilSF2 := xFilial("SF2")
Local _cFilSA6 := xFilial("SA6")
DbSelectArea("ZTN")
ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
DbSelectArea("ZTX")
ZTX->(DbGotop())
While ZTX->(!EOF())
    If ZTX->ZTX_STATOT == "01" // "01"=Pendente
        If Left(ZTX->ZTX_EMPRES,04) == cEmpAnt + cFilAnt // Empresa e Filial conforme
            If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTX->(Recno()) == nRecTabPos) // Recno especifico
                If RTrim(ZTX->ZTX_IDECTB) $ "1/3/" // "1"=Adiantamento (RA)       Gerar RA no Financeiro  FINA040       "3"=Recebimento     Baixa do Titulo Financeiro (FINA070, etc)
                    If ZTN->(DbSeek(_cFilZTN + ZTX->ZTX_IDEVEN + ZTX->ZTX_IDELAN))
                        cMsg01 := ""
                        cMsg02 := ""
                        cMsg03 := ""
                        cMsg04 := ""
                        aTits := {}
                        aBxs := {}
                        lRet := .T.
                        _cFilSE1 := SubStr(ZTX->ZTX_EMPRES,03,02)
                        If RTrim(ZTX->ZTX_TIPDOC) == "RA" // Recebimento Antecipado
                            //          { Prefx,      Numero,   Parcela,  Tipo,              Codigo Cliente,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,                   Moeda Estrangeira,        Taxa da Moeda,                    Historico,,,,,,,,       Processo Thomson }
                            //          {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,                                  11,                   12,                           13,,,,,,,,                     21 }
                            aAdd(aTits, { "THO", "000000001", Space(03), "RA ", SubStr(ZTX->ZTX_CODPAR,4,6), SubStr(ZTX->ZTX_CODPAR,10,2), PadR(ZTX->ZTX_FLEXF6,10), StoD(StrTran(Left(ZTX->ZTX_DATEMI,10),"-","")), StoD(StrTran(Left(ZTX->ZTX_DATCON,10),"-","")), Val(ZTX->ZTX_VALRME), Iif(ZTX->ZTX_NMOEDA == "USD", 2, 4), Val(ZTX->ZTX_TXMOED), "Thomson " + ZTX->ZTX_REFER2,,,,,,,, RTrim(ZTX->ZTX_REFER2) })
                        ElseIf RTrim(ZTX->ZTX_TIPDOC) == "R" // "R"=Cambio a Receber (Baixa Receber (localizar o titulo pelo ZTX_REFER2))
                            aAreaZTN := ZTN->(GetArea())
                            ZTN->(DbSetOrder(5)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_PVC201 + ZTN_PVC202
                            If ZTN->(DbSeek(_cFilZTN + "6004" + ZTX->ZTX_REFER1)) // "0102004059-01"
                                If ZTN->ZTN_STATOT $ "08/09/02/" // "08"=Senf enviada com sucesso! "09"=Senf Enviada com sucesso (enviado pro Thomson) "02"=Processo concluido com sucesso! 
                                    If ZTN->(DbSeek(_cFilZTN + "9001" + ZTX->ZTX_REFER1)) // "0102004059-01"
                                        If ZTN->ZTN_STATOT == "02" // Titulos gerados com sucesso
                                            If !Empty(ZTN->ZTN_DETPR2) // Chave do titulo a receber preenchida
                                                cChvSE1 := ZTN->ZTN_DETPR2                                  // Chave do Titulo SE1        THO000476454001
                                                cEmpSE1 := SubStr( ZTN->ZTN_ERPORI, 01, 2 )                 // Empresa
                                                cFilSE1 := SubStr( ZTN->ZTN_ERPORI, 03, 2 )                 // Filial
                                                cPrfSE1 := SubStr( cChvSE1, 01, 3 )                         // Prefixo
                                                cNumSE1 := SubStr( cChvSE1, 04, 9 )                         // Numero
                                                cParSE1 := SubStr( cChvSE1, 13, 3 )                         // Parcela
                                                // Banco
                                                cBcoSA6 := PadR(ZTX->ZTX_FLEXF5,03)                         // Banco        Ex: "745"
                                                cAgeSA6 := PadR(ZTX->ZTX_COCON1,05)                         // Agencia      Ex: "001"
                                                cConSA6 := PadR(ZTX->ZTX_COCON2,10)                         // Conta        Ex: "34619933"
                                                // Baixa Moeda Estrangeira
                                                dDatBxa := StoD(StrTran(Left(ZTX->ZTX_DATCON,10),"-",""))   // Data Baixa
                                                nMoeEst := Iif(ZTX->ZTX_NMOEDA == "USD", 2, 4)              // Moeda Estrangeira 2=Dolar 4=Euro
                                                nTaxMoe := Val(ZTX->ZTX_TXMOED)                             // Taxa da Moeda Estrangeira
                                                cCodPrc := RTrim(ZTX->ZTX_REFER2)                           // Codigo do Processo
                                                nVlrRec := Val(ZTX->ZTX_VALRME)                             // Valor Receber Moeda Estrangeira
                                                DbSelectArea("SA6")
                                                SA6->(DbSetOrder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
                                                If SA6->(DbSeek(_cFilSA6 + cBcoSA6 + cAgeSA6 + cConSA6))
                                                    RestArea(aAreaZTN) // Retorno o ZTN para o origem
                                                    DbSelectArea("SE1")
                                                    SE1->(DbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
                                                    If SE1->(DbSeek(_cFilSE1 + cPrfSE1 + cNumSE1))
                                                        While SE1->(!EOF()) .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == _cFilSE1 + cPrfSE1 + cNumSE1
                                                            aAdd(aBxs, { SE1->(Recno()), ZTN->(Recno()), ZTX->(Recno()), SA6->(Recno()) })
                                                            SE1->(DbSkip())
                                                        End
                                                    Else // Duplicatas nao foi localizada
                                                        cMsg01 := "Nenhum titulo a receber foi localizado (SE1)!"
                                                        cMsg02 := "Filial/Pref/Num: " + _cFilSE1 + "/" + cPrfSE1 + "/" + cNumSE1
                                                        cMsg03 := ""
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Banco/Agencia/Conta nao encontrados no cadastro (SA6)
                                                    cMsg01 := "Banco/Agencia/Conta nao encontrados no cadastro (SA6)!"
                                                    cMsg02 := "Bco/Age/Con: " + cBcoSA6 + "/" + cAgeSA6 + "/" + cConSA6
                                                    cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Nota de saida nao encontrada (SF2)
                                                cMsg01 := "Chave do titulo a receber nao preenchida (ZTN)!"
                                                cMsg02 := "Processo: " + ZTX->ZTX_REFER1
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Titulos nao gerados ainda
                                            cMsg01 := "Titulo(s) a receber ainda nao foram gerado(s) (ZTN)!"
                                            cMsg02 := "Processo: " + ZTX->ZTX_REFER1
                                            cMsg03 := ""
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    Else // Evento 9001 nao encontrado
                                        cMsg01 := "Evento 9001 para identificacao do titulo a receber nao localizado (ZTN)!"
                                        cMsg02 := "Processo: " + ZTX->ZTX_REFER1
                                        cMsg03 := ""
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf
                                Else // Senf ainda nao foi processada
                                    cMsg01 := "Senf do processo ainda nao foi processada (ZTN)!"
                                    cMsg02 := "Processo: " + ZTX->ZTX_REFER1
                                    cMsg03 := ""
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Else // Evento 6004 nao encontrado
                                cMsg01 := "Evento 6004 para identificacao do processo nao localizado (ZTN)!"
                                cMsg02 := "Processo: " + ZTX->ZTX_REFER1
                                cMsg03 := ""
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                            RestArea(aAreaZTN)
                        EndIf
                        If lRet // Valido
                            If Len(aTits) > 0 // Titulos carregados para geracao
                                lRet := .T.
                                For _w1 := 1 To Len(aTits)
                                    If lRet // Ainda valido... prossegue
                                        DbSelectArea("SE1")
                                        SE1->(DbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA
                                        SE1->(DbSeek(_cFilSE1 + aTits[_w1,01] + "999999999", .T.))
                                        SE1->(DbSkip(-1))
                                        If SE1->E1_PREFIXO == aTits[_w1,01]
                                            aTits[_w1,02] := Soma1(SE1->E1_NUM,9)
                                        EndIf
                                        _cFilSED := xFilial("SED")
                                        DbSelectArea("SED")
                                        SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                                        If SED->(DbSeek(_cFilSED + aTits[_w1,07]))
                                            _cFilSA1 := xFilial("SA1")
                                            DbSelectArea("SA1")
                                            SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
                                            If SA1->(DbSeek(_cFilSA1 + aTits[_w1,05] + aTits[_w1,06]))
                                                If SA1->A1_MSBLQL <> "1" // Cliente nao bloqueado

                                                    aTitulo := { { "E1_PREFIXO",        aTits[_w1,01],                          Nil },;
                                                                { "E1_NUM",             aTits[_w1,02],                          Nil },;
                                                                { "E1_TIPO",            aTits[_w1,04],                          Nil },;
                                                                { "E1_CLIENTE",         aTits[_w1,05],                          Nil },;
                                                                { "E1_LOJA",            aTits[_w1,06],                          Nil },;
                                                                { "E1_NOMCLI",          SA1->A1_NREDUZ,                         Nil },;
                                                                { "E1_EMISSAO",         aTits[_w1,08],                          Nil },;
                                                                { "E1_EMIS1",           aTits[_w1,08],                          Nil },;
                                                                { "E1_VENCTO",          aTits[_w1,09],                          Nil },;
                                                                { "E1_VENCREA",         DataValida(aTits[_w1,09]),              Nil },;
                                                                { "E1_MOEDA",           aTits[_w1,11],                          Nil },;
                                                                { "E1_TXMOEDA",         aTits[_w1,12],                          Nil },;
                                                                { "E1_VALOR",           aTits[_w1,10],                          Nil },;
                                                                { "E1_VLCRUZ",          Round(aTits[_w1,10] * aTits[_w1,12],2), Nil },;
                                                                { "E1_NATUREZ",         aTits[_w1,07],                          Nil },;
                                                                { "E1_HIST",            "Thomson " + aTits[_w1,21],             Nil } } //,;
                                                                // { "E1_XPROTHO",         aTits[_w1,21],                          Nil } } // Processo Thomson

                                                    // Adiantamento
                                                    If aTits[_w1,04] == "RA "
                                                        aAdd(aTitulo, { "CBCOAUTO",     RTrim(ZTX->ZTX_FLEXF5),     Nil })  // "341"
                                                        aAdd(aTitulo, { "CAGEAUTO",     RTrim(ZTX->ZTX_COCON1),     Nil })  // "8712"
                                                        aAdd(aTitulo, { "CCTAAUTO",     RTrim(ZTX->ZTX_COCON2),     Nil })  // "105116"
                                                    EndIf
                                                    Pergunte("FIN040",.F.)
                                                    Mv_Par01 := 1                   // Mostra Lancamento Contabil       1=Sim 2=Nao
                                                    Mv_Par03 := 1                   // Contabiliza On-Line              1=Sim 2=Nao
                                                    lMsErroAuto := .F.
                                                    lExibeLanc := .T.
                                                    lOnline := .T.
                                                    MsExecAuto({|x,y|, FINA040(x,y) }, aTitulo, nOpc) // ,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao
                                                    If lMsErroAuto // Falha
                                                        ConOut("WsRc4903: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                                        MostraErro()
                                                    Else // Sucesso
                                                        lRet := .T.
                                                        cChvTit := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA
                                                        RecLock("ZTX",.F.)
                                                        ZTX->ZTX_STATOT := "02" // "02"=Processado com sucesso
                                                        If aTits[_w1,04] == "RA "
                                                            ZTX->ZTX_CHVADT := cChvTit
                                                        Else
                                                            ZTX->ZTX_CHVDES := cChvTit
                                                        EndIf
                                                        ZTX->ZTX_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                        ZTX->ZTX_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                        ZTX->(MsUnlock())
                                                        RecLock("ZTN",.F.)
                                                        ZTN->ZTN_STATOT := "08"
                                                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                        ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                        ZTN->(MsUnlock())
                                                        ConOut("WsRc4903: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                                    EndIf
                                                    ConOut("WsRc4903: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
                                                    If lMsErroAuto
                                                        cMsg01 := "Falha no ExecAuto (FINA040)"
                                                        cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                        cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Cliente esta bloqueado no cadastro (SA1)
                                                    cMsg01 := "Cliente esta bloqueado no cadastro (SA1)!"
                                                    cMsg02 := "Verifique o cliente da importacao e tente novamente!"
                                                    cMsg03 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Cliente nao encontrado no cadastro (SA1)
                                                cMsg01 := "Cliente nao encontrado no cadastro (SA1)!"
                                                cMsg02 := "Cliente/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Natureza nao encontrada no cadastro (SED)
                                            cMsg01 := "Natureza nao encontrada no cadastro (SED)!"
                                            cMsg02 := "Natureza: " + aTits[_w1,07]
                                            cMsg03 := ""
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    EndIf
                                Next
                            EndIf
                            If lRet
                                If Len(aBxs) > 0 // Titulos paga baixa
                                    For _w1 := 1 To Len(aBxs)
                                        // Reposiciono os registros
                                        SE1->(DbGoto(aBxs[_w1,01]))
                                        ZTN->(DbGoto(aBxs[_w1,02]))
                                        ZTX->(DbGoto(aBxs[_w1,03]))
                                        SA6->(DbGoto(aBxs[_w1,04]))
                                        If SE1->(!EOF())
                                            aBaixa := { { "E1_FILIAL",      SE1->E1_FILIAL,         Nil },;
                                            { "E1_PREFIXO",	                SE1->E1_PREFIXO,        Nil },;
                                            { "E1_NUM",						SE1->E1_NUM,            Nil },;
                                            { "E1_PARCELA",					SE1->E1_PARCELA,        Nil },;
                                            { "E1_CLIENTE",					SE1->E1_CLIENTE,        Nil },;
                                            { "E1_LOJA",					SE1->E1_LOJA,           Nil },;
                                            { "E1_TIPO",					SE1->E1_TIPO,           Nil },;
                                            { "AUTMOTBX",				    "DEB",                  Nil },; // Motivo de baixa "DEB"
                                            { "AUTBANCO",					SA6->A6_COD,            Nil },;
                                            { "AUTAGENCIA",					SA6->A6_AGENCIA,        Nil },;
                                            { "AUTCONTA",					SA6->A6_NUMCON,         Nil },;
                                            { "AUTDTBAIXA",					dDatBxa,                Nil },; // Data de baixa
                                            { "AUTDTCREDITO",				dDatBxa,                Nil },; // Data de credito
                                            { "AUTTXMOEDA",                 nTaxMoe,                Nil },; // Taxa da moeda estrangeira na baixa
                                            { "AUTHIST",					"Thomson " + cCodPrc,   Nil },; // Historico
                                            { "AUTVLRME",                   nVlrRec,                Nil } } // Valor Receber na moeda estrangeira
                                            Pergunte("FIN070",.F.) // Contabilizacao deve ser pelo LP 520 Sequenciais 061/062/063
                                            Mv_Par01 := 1				// Mostra Lancamento Contabil?		1=Sim 2=Nao
                                            Mv_Par02 := 2				// Aglutina Lancamento Contabil?	1=Sim 2=Nao
                                            Mv_Par03 := 2				// Abate Desc/Decres Comissao?		1=Sim 2=Nao
                                            Mv_Par04 := 1 // 1			// Contabiliza On Line?				1=Sim 2=Nao
                                            Mv_Par05 := 2				// Cons.Juros/Acres Comissao?		1=Sim 2=Nao
                                            Mv_Par06 := 1				// Destacar Abatimentos?			1=Sim 2=Nao
                                            Mv_Par07 := 3				// Replica Rateio?					1=Inclusao 2=Baixa 3=Nao Replicar
                                            Mv_Par08 := 1				// Gera cheque p/ Adiantamento? 	1=Sim 2=Nao
                                            Mv_Par09 := 1				// Considera Retencäo Bancaria?		1=Sim 2=Nao
                                            Mv_Par10 := 2				// Utiliza banco anterior?			1=Sim 2=Nao
                                            lMsErroAuto := .F.
                                            MsExecAuto({|x,y|, FINA070(x,y) }, aBaixa, nOpc)
                                            If lMsErroAuto // Falha no ExecAuto FINA070
                                                cMsg01 := "Erro no processamento da baixa a receber (ExecAuto)!"
                                                cMsg02 := ""
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                                MostraErro()
                                                Exit
                                            Else // Sucesso na baixa receber
                                                lRet := .T.
                                                cChvTit := SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_CLIFOR + SE5->E5_LOJA // Chave da Baixa
                                                RecLock("ZTX",.F.)
                                                ZTX->ZTX_STATOT := "02" // "02"=Processado com sucesso
                                                ZTX->ZTX_CHVBXA := cChvTit
                                                ZTX->ZTX_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                ZTX->ZTX_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                ZTX->(MsUnlock())
                                                RecLock("ZTN",.F.)
                                                ZTN->ZTN_STATOT := "08"
                                                ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                ZTN->(MsUnlock())
                                                ConOut("WsRc4903: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                            EndIf
                                        EndIf
                                    Next
                                EndIf
                            EndIf
                        EndIf
                    EndIf

                ElseIf .F. // "2"=Compensacao             Compensar 1 RA com 1 Pgto

                ElseIf .F. // "3"=Manutencao Cambio       Gerar Manutencao Cambio (rotina do EEC)

                EndIf
            EndIf // Recno tela conforme ou todos
        EndIf // Empresa/Filial conforme
    EndIf // ZTX pendente processamento
    ZTX->(DbSkip())
End
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4905 ºAutor ³Jonathan Schmidt Alves º Data ³30/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Pagamentos (Exportacao)          C O N S U L T A  º±±
±±º          ³                                                  ZTP 5054  º±±
±±º          ³ ID Interface no In-Out: N/A                                º±±
±±º          ³ API: PKG_GEN_PAGAMENTO                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_GEN_PAGAMENTO"                                     º±±
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
±±º          ³ Consulta no Thomson pagamentos para gravar o XML na ZTN e  º±±
±±º          ³ na etapa seguinte gravar os dados na ZTP.                  º±±
±±º          ³ Tabelas Totvs: ZTN                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4905()
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
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If ZTN->(DbSeek(_cFilZTN + "5054" + "3")) // "3"=Em Processamento Totvs
                While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "5054" + "3"
                    If ZTN->ZTN_STATOT == "03" // "03"=Processamento Totvs
                        If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                            // Posicionamentos:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            // Consulta:
                            cCodEvent := ZTN->ZTN_IDEVEN            // Codigos dos processos        Ex: "6059"=Transito e Compromisso   "6002"=Importacao (Nota Fiscal),  "6060"=Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento     "6062"=Emissao de Pagamento/Adiantamento/Prestacao de Contas
                            cDesEvent := "Export"
                            cCodSiste := "2"                        // Tudo para exportacao
                            // ###################### PAGAMENTO EXPORTACAO #############################
                            //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,      Titulo Integracao, Msg Processamento }
                            //            {        01,                      02,      03,             04,         05,         06,              07,              08,                     09,                10 }
                            aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Pagamento Exportacao", "Pagamento: "     })
                            aParams := {}
                            aAdd(aParams, { { "cIdLanc", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cCodSiste", "'" + cCodSiste + "'" } }) // Variaveis auxiliares
                            aAdd(aTail(aMethds)[06], aClone(aParams))
                        EndIf
                    EndIf
                    ZTN->(DbSkip())
                End
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4906 ºAutor ³Jonathan Schmidt Alves º Data ³01/10/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao de Tits de Pagamentos (Export)   P R O C E S S A  º±±
±±º          ³                                                  ZTP 5054  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera os titulos a pagar a partir dos registros da ZTP.     º±±
±±º          ³ Tabelas Totvs: ZTP/SA2/SE2/SED                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4906()
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local _w1
Local nOpc := 3 // 3=Inclusao
Local cChvTit := ""
Local aPgts := {}
// Variaveis Filiais
Local _cFilZTP := xFilial("ZTP")
Local _cFilSA2 := xFilial("SA2")
Local _cFilSE2 := xFilial("SE2")
Local _cFilSED := xFilial("SED")
DbSelectArea("ZTP")
ZTP->(DbGotop())
While ZTP->(!EOF())
    If ZTP->ZTP_STATOT == "01" // "01"=Pendente
        If !Empty(ZTP->ZTP_DATASP) // Data de Emissao preenchida
            If Left(ZTP->ZTP_NUMDOC,02) == cEmpAnt .And. SubStr(ZTP->ZTP_NUMDOC,03,02) == cFilAnt // Empresa/Filial conforme
                _cFilSE2 := SubStr(ZTP->ZTP_NUMDOC,03,02)
                If "PG" $ ZTP->ZTP_TIPOSP // 01: Adiantamento      *** Gerar PA apenas
                    If Empty( ZTP->ZTP_CHVDES ) // Ainda nao gerou
                        //          { Prefx,      Numero,   Parcela,  Tipo,           Codigo Fornecedor,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,         Despesa,,,,,,,,,      Recno ZTP, Processo Thomson }
                        //          {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,              11,,,,,,,,,             20,               21 }
                        aAdd(aPgts, { "THO", "000000001", Space(03), "NF ", SubStr(ZTP->ZTP_CREDOR,4,6), SubStr(ZTP->ZTP_CREDOR,10,2),         PadR("24023",10), StoD(StrTran(Left(ZTP->ZTP_DATASP,10),"-","")), StoD(StrTran(Left(ZTP->ZTP_VENCTO,10),"-","")), Val(ZTP->ZTP_VLRPGT),             Nil,,,,,,,,, ZTP->(Recno()),        Space(15) })
                    EndIf
                EndIf
                If Len(aPgts) > 0 // Titulos para processar
                    lRet := .T.
                    For _w1 := 1 To Len(aPgts)
                        ZTP->(DbGoto(aPgts[_w1,20])) // Reposiciono ZTP
                        DbSelectArea("SE2")
                        SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
                        SE2->(DbSeek( _cFilSE2 + aPgts[_w1,01] + "999999999", .T. ))
                        SE2->(DbSkip(-1))
                        If SE2->E2_PREFIXO == aPgts[_w1,01]
                            aPgts[_w1,02] := Soma1(SE2->E2_NUM,9)
                        EndIf
                        DbSelectArea("SED")
                        SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                        If SED->(DbSeek( _cFilSED + aPgts[_w1,07] ))
                            DbSelectArea("SA2")
                            SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                            If SA2->(DbSeek(_cFilSA2 + aPgts[_w1,05] + aPgts[_w1,06]))

                                aTitulo := { { "E2_PREFIXO",            aPgts[_w1,01],                          Nil },;
                                                { "E2_NUM",             aPgts[_w1,02],                          Nil },;
                                                { "E2_TIPO",            aPgts[_w1,04],                          Nil },;
                                                { "E2_FORNECE",         aPgts[_w1,05],                          Nil },;
                                                { "E2_LOJA",            aPgts[_w1,06],                          Nil },;
                                                { "E2_NOMFOR",          SA2->A2_NREDUZ,                         Nil },;
                                                { "E2_EMISSAO",         aPgts[_w1,08],                          Nil },;
                                                { "E2_EMIS1",           aPgts[_w1,08],                          Nil },;
                                                { "E2_VENCTO",          aPgts[_w1,09],                          Nil },;
                                                { "E2_VENCREA",         DataValida(aPgts[_w1,09]),              Nil },;
                                                { "E2_VALOR",           aPgts[_w1,10],                          Nil },;
                                                { "E2_VLCRUZ",          aPgts[_w1,10],                          Nil },;
                                                { "E2_NATUREZ",         aPgts[_w1,07],                          Nil },;
                                                { "E2_HIST",            "Thomson " + ZTP->ZTP_DOCTO,            Nil } } //,;
                                                // { "E2_XPROTHO",         aPgts[_w1,21],                          Nil } } // Processo Thomson

                                lMsErroAuto := .F.
                                lExibeLanc := .F.
                                lOnline := .F.
                                MsExecAuto({|x,y,z|, FINA050(x,y,z) }, aTitulo, Nil, nOpc) // Inclusao/Exclusao
                                If lMsErroAuto // Falha
                                    cMsg01 := "Falha no ExecAuto (FINA050)"
                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                    cMsg04 := ""
                                    lRet := .F.
                                    ConOut("WsRc4906: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                    MostraErro()
                                Else // Sucesso
                                    cChvTit := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
                                    RecLock("ZTP",.F.)
                                    ZTP->ZTP_STATOT := "02" // "02"=Processado com sucesso
                                    If aPgts[_w1,04] == "PA "
                                        ZTP->ZTP_CHVADT := cChvTit
                                    Else
                                        ZTP->ZTP_CHVDES := cChvTit
                                    EndIf
                                    ZTP->ZTP_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                    ZTP->ZTP_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                    ZTP->(MsUnlock())
                                    ConOut("WsRc4906: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                    // Avaliacao ZTP todo gerado com sucesso ZTP -> ZTN
                                    cCodZTP := ZTP->ZTP_CDIDSP // Codigo unico
                                    lAllZTP := .T.
                                    If ZTP->(DbSeek(_cFilZTP + cCodZTP))
                                        While ZTP->(!EOF()) .And. ZTP->ZTP_FILIAL + ZTP->ZTP_CDIDSP == _cFilZTP + cCodZTP
                                            If !(lAllZTP := ZTP->ZTP_STATOT == "02") // "02"=Titulo gerado com sucesso!
                                                Exit
                                            EndIf
                                            ZTP->(DbSkip())
                                        End
                                    EndIf
                                    If lAllZTP // .T.=Gerados "todos" os ZTP necessarios
                                        DbSelectArea("ZTN")
                                        ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
                                        If ZTN->(DbSeek( _cFilZTN + "5054" + cCodZTP ))
                                            RecLock("ZTN",.F.)
                                            ZTN->ZTN_STATOT := "08" // "08"=Todos os titulos ZTP desta notificacao gerados com sucesso!
                                            ZTN->ZTN_DETPR1 := "Sucesso na geracao do(s) titulo(s)!"
                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                            ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                            ZTN->(MsUnlock())
                                        EndIf
                                    EndIf
                                EndIf
                            Else // Fornecedor nao encontrado no cadastro (SA2)
                                cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                                cMsg02 := "Fornecedor/Loja: " + aPgts[_w1,05] + "/" + aPgts[_w1,06]
                                cMsg03 := "O fornecedor deve estar cadastrado no Totvs!"
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Natureza nao encontrada no cadastro (SED)
                            cMsg01 := "Natureza nao encontrada no cadastro (SED)!"
                            cMsg02 := "Natureza: " + aPgts[_w1,07]
                            cMsg03 := "A natureza do titulo deve existir no Totvs!"
                            cMsg04 := "Verifique o codigo da natureza e tente novamente!"
                            lRet := .F.
                        EndIf
                    Next
                EndIf // Pagamentos para processar

            EndIf // Empresa/Filial conforme
        EndIf // Data de emissao preenchida
    EndIf // Status ZTP conforme
    ZTP->(DbSkip())
End

Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc4907 ºAutor ³Jonathan Schmidt Alves º Data ³22/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao Titulos Receb do Fatur (Export)  P R O C E S S A  º±±
±±º          ³                                                      9001  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gerar os titulos a receber no Totvs a partir dos dados     º±±
±±º          ³ disponibilizados pelo Thomson no final do processo conformeº±±
±±º          ³ o evento 9001.                                             º±±
±±º          ³ Tabelas Totvs: ZTN/EEC/EE9/SF2/SED/SA1/SE1                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc4907()
Local _w1
Local lRet := .F.
Local nOpc := 3 // 3=Inclusao
Local aTits := {}
Local cChvTit := ""
// Variaveis mensagens
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Variaveis filiais
Local _cFilEE9 := xFilial("EE9")
Local _cFilSF2 := xFilial("SF2")
Local _cFilSA1 := xFilial("SA1")
Local _cFilSE1 := xFilial("SE1")
Local _cFilSED := xFilial("SED")
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
If ZTN->(DbSeek(_cFilZTN + "9001" + "3"))
    While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "9001" + "3" // "9001"=Envio de Datas e Valores de Parcela (Receber)
        If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
            If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                    If !Empty(ZTN->ZTN_PVC201) // Numero da Invoice
                        lRet := .T.
                        cNumInv := ZTN->ZTN_PVC201                              // Numero da Invoice
                        cNumSnf := ZTN->ZTN_PVC202                              // Numero da Senf
                        nTaxSnf := Val(ZTN->ZTN_NUMB07)                         // Taxa da Moeda da Senf
                        cFilEEC := SubStr(cNumInv,3,2)                          // Filial
                        cNumInv := SubStr(cNumInv,5,Rat("-",cNumInv) - 1 - 4)   // Numero da Invoice (menos o -01, -02, etc)
                        DbSelectArea("EEC")
                        EEC->(DbSetOrder(1)) // EEC_FILIAL + EEC_PREEMB
                        If EEC->(DbSeek(cFilEEC + cNumInv)) // 004059
                            // Identificacao dos itens EE9 do embarque que ja foram faturados
                            aDadosFat := {}
                            DbSelectArea("EE9")
                            EE9->(DbSetOrder(2)) // EE9_FILIAL + EE9_PREEMB + EE9_PEDIDO + EE9_SEQUEN
                            If EE9->(DbSeek(_cFilEE9 + EEC->EEC_PREEMB))
                                While EE9->(!EOF()) .And. EE9->EE9_FILIAL + EE9->EE9_PREEMB == _cFilEE9 + EEC->EEC_PREEMB // Pedido conforme
                                    If !Empty(EE9->EE9_NF) // Nota faturada
                                        aAdd(aDadosFat, { EE9->EE9_NF, EE9->EE9_SERIE, EE9->EE9_COD_I })
                                    EndIf
                                    EE9->(DbSkip())
                                End
                            EndIf
                            If Len(aDadosFat) // Alguma nota identificada

                                DbSelectArea("SF2")
                                SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE
                                If SF2->(DbSeek(_cFilSF2 + aDadosFat[ 01, 01 ] + aDadosFat[ 01, 02 ]))
                                    
                                      If nTaxSnf > 0 // Taxa obtida
                                        // Montagem das variaveis para geracao dos titulos a receber
                                        cNumPar := "001"
                                        For _w1 := 1 To 6 // Maximo de titulos por processo
                                            If !Empty(&("ZTN->ZTN_NUMB" + StrZero(_w1,02))) .And. !Empty(&("ZTN->ZTN_DATE" + StrZero(_w1,02)))
                                                cPrfTit := "THO"                                                                    // 01 Prefixo do titulo         Ex: "THO"
                                                cNumTit := "000000001"                                                              // 02 Numero do titulo          Ex: "000476398"
                                                cNumPar := Iif( _w1 > 1, Soma1( cNumPar, 3 ), cNumPar)                              // 03 Numero da Parcela         Ex: "001", "002", "003", etc
                                                cTipTit := "NF "                                                                    // 04 Tipo do titulo            Ex: "NF "
                                                cCodCli := SF2->F2_CLIENTE                                                          // 05 Codigo do cliente         Ex: "069785"
                                                cLojCli := SF2->F2_LOJA                                                             // 06 Loja do cliente           Ex: "01"
                                                cNatTit := "10102     "                                                             // 07 Natureza do titulo        Ex: "10101     "
                                                dEmissa := StoD(StrTran(Left( ZTN->ZTN_DATRAN, 10 ),"-",""))                        // 08 Data de emissao           Ex: 06/10/2021
                                                dVencto := StoD(StrTran(Left( &("ZTN->ZTN_DATE" + StrZero(_w1,02)), 10 ),"-",""))   // 09 Data da parcela           Ex: 16/10/2021
                                                nVlrMoe := Round(Val(&("ZTN->ZTN_NUMB" + StrZero(_w1,02))),2)                       // 10 Valor moeda estrangeira   Ex: 144
                                                nCodMoe := Iif(EEC->EEC_MOEDA == "US$",2,4)                                         // 11 Moeda                     Ex: 2=Dolar 4=Euro
                                                nTaxMoe := nTaxSnf                                                                  // 12 Taxa moeda estrangeira    Ex: 5.3
                                                cHisTit := "Thomson " + cNumInv                                                     // 13 Historico do titulo       Ex: "Thomson 0102004059"
                                                
                                                //           {      01,      02,      03,      04,      05,      06,      07,      08,      09,      10,      11,      12,      13,,,,,,,,        21 }
                                                aAdd( aTits, { cPrfTit, cNumTit, cNumPar, cTipTit, cCodCli, cLojCli, cNatTit, dEmissa, dVencto, nVlrMoe, nCodMoe, nTaxMoe, cHisTit,,,,,,,, Space(15) })

                                            EndIf
                                        Next

                                        // Geracao dos Titulo a Receber (usar a Taxa da Senf)
                                        For _w1 := 1 To Len( aTits )
                                            If lRet // Ainda valido
                                                DbSelectArea("SE1")
                                                SE1->(DbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA
                                                SE1->(DbSeek(_cFilSE1 + aTits[_w1,01] + "999999999", .T.))
                                                SE1->(DbSkip(-1))
                                                If SE1->E1_PREFIXO == aTits[_w1,01]
                                                    aTits[_w1,02] := Soma1(SE1->E1_NUM,9)
                                                EndIf
                                                DbSelectArea("SA1")
                                                SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
                                                DbSelectArea("SED")
                                                SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                                                If SED->(!DbSeek(_cFilSED + aTits[_w1,07]))
                                                    cMsg01 := "Natureza nao encontrada no cadastro (SED)!"
                                                    cMsg02 := "Natureza: " + aTits[_w1,07]
                                                    cMsg03 := ""
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                ElseIf SA1->(!DbSeek(_cFilSA1 + aTits[_w1,05] + aTits[_w1,06]))
                                                    cMsg01 := "Cliente nao encontrado no cadastro (SA1)!"
                                                    cMsg02 := "Cliente/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                                                    cMsg03 := ""
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                ElseIf SA1->A1_MSBLQL == "1"
                                                    cMsg01 := "Cliente esta bloqueado no cadastro (SA1)!"
                                                    cMsg02 := "Cliente/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA
                                                    cMsg03 := ""
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            EndIf
                                        Next

                                        If lRet // Titulos a pagar validos para processamento

                                            // Parte 01: Geracao dos titulos a Receber
                                            cChvTit := ""
                                            For _w1 := 1 To Len(aTits)
                                                aTitulo := { { "E1_PREFIXO",    aTits[_w1,01],                          Nil },; // Fixo                 Ex: "THO"
                                                        { "E1_NUM",             aTits[_w1,02],                          Nil },; // Numero do titulo     Ex: "000476398"
                                                        { "E1_PARCELA",         aTits[_w1,03],                          Nil },; // Parcela do titulo    Ex: "AAA"
                                                        { "E1_TIPO",            aTits[_w1,04],                          Nil },; // Tipo                 Ex: "NF "
                                                        { "E1_CLIENTE",         aTits[_w1,05],                          Nil },; // Codigo do Cliente    Ex: "069785"
                                                        { "E1_LOJA",            aTits[_w1,06],                          Nil },; // Loja do Cliente      Ex: "01"
                                                        { "E1_EMISSAO",         aTits[_w1,08],                          Nil },; // Emissao do Titulo    Ex: 
                                                        { "E1_EMIS1",           aTits[_w1,08],                          Nil },; // Emissao do Titulo    Ex: 
                                                        { "E1_VENCTO",          aTits[_w1,09],                          Nil },; // Vencimento           Ex:
                                                        { "E1_VENCREA",         DataValida(aTits[_w1,09]),              Nil },; // Vencimento Real      Ex: 
                                                        { "E1_MOEDA",           aTits[_w1,11],                          Nil },; // Moeda Estrangeira    Ex: 2=Dolar 4=Euro
                                                        { "E1_TXMOEDA",         aTits[_w1,12],                          Nil },; // Taxa Moeda           Ex: 5.3
                                                        { "E1_VALOR",           aTits[_w1,10],                          Nil },; // Valor do Titulo      Ex: 144
                                                        { "E1_VLCRUZ",          Round(aTits[_w1,10] * aTits[_w1,12],2), Nil },; // Valor Cruzado        Ex: 
                                                        { "E1_NATUREZ",         aTits[_w1,07],                          Nil },; // Natureza             Ex: "10102     "
                                                        { "E1_HIST",            aTits[_w1,13],                          Nil } } //,; // Historico            Ex: "Thomson "
                                                        // { "E1_XPROTHO",         aTits[_w1,21],                          Nil } } // Processo Thomson
                                                        
                                                Pergunte("FIN040",.F.)
                                                Mv_Par01 := 1                   // Mostra Lancamento Contabil       1=Sim 2=Nao
                                                Mv_Par03 := 1                   // Contabiliza On-Line              1=Sim 2=Nao

                                                lMsErroAuto := .F.
                                                lExibeLanc := .T.
                                                lOnline := .T.
                                                MsExecAuto({|x,y|, FINA040(x,y) }, aTitulo, nOpc) // ,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao
                                                If lMsErroAuto // Falha
                                                    ConOut("WsRc4907: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha!")
                                                    cMsg01 := "Falha no ExecAuto (FINA040)"
                                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                    MostraErro()
                                                    Exit
                                                Else // Sucesso
                                                    cChvTit += SE1->E1_PREFIXO + SE1->E1_NUM + "/" + SE1->E1_PARCELA + "/" // SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA
                                                    ConOut("WsRc4907: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Sucesso!")
                                                EndIf
                                            Next
                                        EndIf

                                        If lRet // Sucesso nos ExecAutos
                                            If Right( cChvTit,1) == "/"
                                                cChvTit := Left( cChvTit, Len( cChvTit ) - 1 )
                                            EndIf
                                            RecLock("ZTN",.F.)
                                            ZTN->ZTN_STATOT := "08" // "08"=Processado com sucesso
                                            ZTN->ZTN_DETPR1 := "Titulo(s) gerado(s) com sucesso!"       // 203
                                            ZTN->ZTN_DETPR2 := RTrim(cChvTit)                           // 204
                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                            ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                            ZTN->(MsUnlock())
                                        Else // Falha nos ExecAutos
                                            RecLock("ZTN",.F.)
                                            ZTN->ZTN_STATOT := "41" // "41"=Falha no processamento
                                            ZTN->ZTN_DETPR1 := cMsg03                                   // Cabecalho do erro
                                            ZTN->ZTN_DETPR2 := cMsg04                                   // Detalhe do erro
                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                            ZTN->ZTN_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                            ZTN->(MsUnlock())
                                        EndIf
                                    EndIf

                                Else // Nota nao encontrada (SF2)

                                EndIf

                            Else // Nenhuma nota identificada (SF2)

                            EndIf

                        Else // Embarque nao encontrado (EEC)

                        EndIf

                    EndIf
                EndIf

            EndIf // Empresa/Filial conforme

        EndIf // "03"=Em processamento Totvs
        ZTN->(DbSkip())
    End
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }
