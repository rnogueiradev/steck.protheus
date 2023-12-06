#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc03 ºAutor ³Jonathan Schmidt Alves º Data ³03/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao/Cambio:                                         º±±
±±º          ³                                                            º±±
±±º          ³ WsRc3303: Inclusao da Ordem de Importacao               OK º±±
±±º          ³ WsRc3501: Consulta Notificacoes 6059 (Transito)         OK º±±
±±º          ³ WsRc3503: Inclusao de Lancamentos Contabeis (Tran/Bxa)  OK º±±
±±º          ³ WsRc3504: Atualizacao Data do Compromisso               OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc3701: Consulta Notificacoes 6002 (Baixa Xml da NF)  OK º±±
±±º          ³ WsRc3703: Inclusao da Nota Fiscal Entrada               OK º±±
±±º          ³ WsRc3707: Retorno Nota Fiscal Entrada                   OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc3801: Consulta Notificacoes Cambio (ZTY)            OK º±±
±±º          ³ WsRc3803: Incl/Baixa Tit Pag Camb Imp (ZTY)             OK º±±
±±º          ³                                                            º±±
±±º          ³ WsRc3901: Consulta Nofif Desp Adto 6062 (Pgto/Adto/Pres)OK º±±
±±º          ³ WsRc3905: Inclusao Tits Desp/Adto/Pgto                  OK º±±
±±º          ³ WsRc3908: Recebimentos dos Materiais                    OK º±±
±±º          ³                                                   WsGnrc03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3303 ºAutor ³Jonathan Schmidt Alves º Data ³03/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao Ordem de Importacao.           I N C L U S A O  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: ORDENS                             º±±
±±º          ³ API: PKG_IS_API_ORDEM_IMPORTACAO.PRC_IS_PROCESSA_ORDEM_IMP º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_IS_API_ORDEM_IMPORTACAO.PRC_IS_PROCESSA_ORDEM_IMP" º±±
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
±±º          ³ Envia a Ordem de Importacao do Totvs para o Thomson.       º±±
±±º          ³ Tabelas Totvs: SW2                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3303()
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
Local aRecTab2 := {}
Local aRepets2 := {}
// Variaveis auxiliares repeticao
Local aTabs := {}
Local aVars := {}
Local aReps := {}
Local aTabs2 := {}
Local aVars2 := {}
Local aReps2 := {}
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
            If SW2->(DbSeek(_cFilSW2 + cIntPrcPsq))
                If SA2->(DbSeek(_cFilSA2 + SW2->W2_FORN + SW2->W2_FORLOJ))
                    If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                        If !Empty( SA2->A2_PAIS ) // Pais preenchido
                            If SYA->(DbSeek( _cFilSYA + SA2->A2_PAIS )) // Pais encontrado
                                If Len(AllTrim(SYA->YA_SIGLA)) == 2 // Sigla do pais onforme Thomson
                                    // Posicionamentos Pais Destino:
                                    aRecTab := { { "SA2", Array(0) }, { "SYA", Array(0) } }
                                    aAdd(aRecTab[01,02], SA2->(Recno()))         // Recno SA2
                                    aAdd(aRecTab[02,02], SYA->(Recno()))         // Recno SYA
                                    // ###################### PAISES DE ORIGEM #############################
                                    //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,    Titulo Integracao,                                     Msg Processamento }
                                    //            {        01,                      02,      03,             04,         05,         06,              07,              08,                   09,                                                    10 }
                                    aAdd(aMethds, {        "", "PKG_SFW_PAIS.PRC_PAIS",      "",           "03",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Paises", "Pais: " + SYA->YA_CODGI + " " + RTrim(SYA->YA_DESCR) })
                                    aParams := {}
                                    aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "10" } }) // Variaveis auxiliares
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
                                    //            { Interface,                        Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,                      Titulo Integracao,                                                               Msg Processamento }
                                    //            {        01,                              02,      03,             04,         05,         06,              07,              08,                                     09,                                                                              10 }
                                    aAdd(aMethds, {        "", "PKG_SFW_PARCEIRO.PRC_PARCEIRO",      "",           "13",         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Inclusao de Parceiros (Fornecedores)", "Fornecedor: " + SA2->A2_COD + "/" + SA2->A2_LOJA + " " + RTrim(SA2->A2_NREDUZ) })
                                    aParams := {}
                                    aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "10" } }) // Variaveis auxiliares
                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                    If SYQ->(DbSeek( _cFilSYQ + SW2->W2_TIPO_EM )) // Via de Transporte     4=Aerea 1=Maritimo B=Courier 7=Rodoviaria
                                        If SYR->(DbSeek( _cFilSYR + SW2->W2_TIPO_EM + SW2->W2_ORIGEM + SW2->W2_DEST )) // Via + Origem + Destino
                                            If SY6->(DbSeek( _cFilSY6 + SW2->W2_COND_PA )) // Condicao Pgto SY6
                                                If SW3->(DbSeek( _cFilSW3 + SW2->W2_PO_NUM )) // Itens do pedido
                                                    // Posicionamentos:
                                                    aRecTab2 := { { "SW2", Array(0) }, { "SW3", Array(0) }, { "SA2", Array(0) }, { "SYA", Array(0) }, { "SYQ", Array(0) }, { "SYR", Array(0) }, { "SC7", Array(0) } }
                                                    aAdd(aRecTab2[01,02], SW2->(Recno()))    // Recno SW2
                                                    aAdd(aRecTab2[02,02], SW3->(Recno()))    // Recno SW3 (usado para dados do cabecalho no ZT2 como do primeiro item)
                                                    aAdd(aRecTab2[03,02], SA2->(Recno()))    // Recno SA2
                                                    aAdd(aRecTab2[04,02], SYA->(Recno()))    // Recno SYA
                                                    aAdd(aRecTab2[05,02], SYQ->(Recno()))    // Recno SYQ
                                                    aAdd(aRecTab2[06,02], SYR->(Recno()))    // Recno SYR
                                                    aAdd(aRecTab2[07,02], 0)                 // Recno SC7
                                                    While SW3->(!EOF()) .And. SW3->W3_FILIAL + SW3->W3_PO_NUM == _cFilSW3 + SW2->W2_PO_NUM // Itens do Pedido
                                                        If !Empty(SW3->W3_NR_CONT) // Registro unico
                                                            If SB1->(DbSeek( _cFilSB1 + SW3->W3_COD_I ))
                                                                If !Empty(SB1->B1_POSIPI) // Ncm preenchida
                                                                    If SBM->(DbSeek( _cFilSBM + SB1->B1_GRUPO ))
                                                                        If SAH->(DbSeek( _cFilSAH + SB1->B1_UM ))
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
                                                                                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "10" } }) // Variaveis auxiliares
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
                                                                                aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "10" } }) // Variaveis auxiliares
                                                                                aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                                aAdd(aProds, SB1->B1_COD) // Incluo o produto como ja considerado
                                                                            EndIf
                                                                            // ###################### PEDIDOS IMPORTACAO #############################
                                                                            // Repeticoes
                                                                            aTabs2 := {}
                                                                            aAdd(aTabs2, { "SW3", SW3->(Recno()) })
                                                                            aAdd(aTabs2, { "SB1", SB1->(Recno()) })
                                                                            aAdd(aTabs2, { "SAH", SAH->(Recno()) })
                                                                            aAdd(aReps2, aClone( aTabs2 ))
                                                                            aAuxs2 := {}
                                                                            aAdd(aVars2, aClone( aAuxs2 ))
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
                                                            Else // Produto nao encontrado no cadastro (SB1)
                                                                cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                cMsg02 := "Produto nao encontrado no cadastro (SB1)!"
                                                                cMsg03 := "Produto: " + SW3->W3_COD_I
                                                                cMsg04 := ""
                                                                lRet := .F.
                                                            EndIf
                                                        EndIf
                                                        SW3->(DbSkip())
                                                    End
                                                    If lRet // .T.=Valido
                                                        //             { Repeticao,  Tabelas/Recnos,   Variaveis Aux }
                                                        aAdd(aRepets2, {      "10", aClone( aReps2 ), aClone( aVars2 ) })
                                                        // ###################### PEDIDOS IMPORTACAO #############################
                                                        //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,           Recnos,          aRepets,        Titulo Integracao,                                            Msg Processamento }
                                                        //            {        01,                      02,      03,             04,         05,         06,               07,               08,                       09,                                                           10 }
                                                        aAdd(aMethds, {        "",                 cNomApi,      "",           "03",         "",   Array(0), aClone(aRecTab2), aClone(aRepets2), "Inclusao de Importacao", "Importacao: " + SW2->W2_PO_NUM + " " + RTrim(SYA->YA_DESCR) })
                                                        aParams := {}
                                                        // aAdd(aParams, { { "cTstVarC", "'Conteudo variavel char'" }, { "nTstVarN", "10" } }) // Variaveis auxiliares
                                                        aAdd(aTail(aMethds)[06], aClone(aParams))
                                                    EndIf
                                                Else // Itens da Importacao (SW3) nao encontrados
                                                    cMsg01 := "Itens da Importacao nao encontrados no cadastro (SW3)!"
                                                    cMsg02 := "Verifique os dados da importacao e tente novamente!"
                                                    cMsg03 := "Importacao: " + SW2->W2_PO_NUM
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Condicao de Pagamento nao encontrada (SY6)
                                                cMsg01 := "Condicao de Pagamento nao encontrada no cadastro (SY6)!"
                                                cMsg02 := "Verifique os dados da importacao e tente novamente!"
                                                cMsg03 := "Importacao: " + SW2->W2_PO_NUM
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Via + Origem + Destino nao encontrada (SYR)
                                            cMsg01 := "Via Origem Destino nao encontrada no cadastro (SYR)!"
                                            cMsg02 := "Verifique o cadastro de vias e tente novamente!"
                                            cMsg03 := "Via/Origem/Destino: " + SW2->W2_TIPO_EM + "/" + SW2->W2_ORIGEM + "/" + SW2->W2_DEST
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
                                Else // Sigla do Pais nao conforme (2 caracteres Thomson)
                                    cMsg01 := "Sigla do Pais do nao conforme para integracoes Thomson (SYA)!"
                                    cMsg02 := "Verifique o cadastro do pais e tente novamente!"
                                    cMsg03 := "Pais/Nome: " + SYA->YA_CODGI + "/" + SYA->YA_DESCR
                                    cMsg04 := "Sigla Pais: " + SYA->YA_SIGLA
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
                    Else // Fornecedor esta bloqueado no cadastro (SA2)
                        cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                        cMsg02 := "Verifique o fornecedor e tente novamente!"
                        cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Fornecedor nao encontrado no cadastro (SA2)
                    cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                    cMsg02 := "Verifique o fornecedor e tente novamente!"
                    cMsg03 := "Fornecedor/Loja: " + SW2->W2_FORN + "/" + SW2->W2_FORLOJ
                    cMsg04 := ""
                    lRet := .F.  
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3501 ºAutor ³Jonathan Schmidt Alves º Data ³14/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Notificacoes (Transito Import)   C O N S U L T A  º±±
±±º          ³                                               6059 e 6060  º±±
±±º          ³ ID Interface no In-Out: PKG_PRC_FATURA_IMP                 º±±
±±º          ³ API: PKG_PRC_FATURA_IMP                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_PRC_FATURA_IMP"                                    º±±
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
±±º          ³ Consulta notificacoes de Transito/Compromisso no Thomson.  º±±
±±º          ³ Tabelas Totvs: ZTN                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3501()
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
            If ZTN->(DbSeek( _cFilZTN + "6059" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6059" + "3" // "6059"=Transito
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                            If ZTN->ZTN_STATOT == "03" // "03"=Em Processamento Totvs
                                // Posicionamentos Transito:
                                aRecTab := { { "ZTN", Array(0) } }
                                aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                                // ###################### PROCESSO TRANSITO #############################
                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,         Titulo Integracao, Msg Processamento }
                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                        09,                10 }
                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta Transito Import",     "Processo: " })
                                aParams := {}
                                aAdd(aParams, { { "cIdLanc", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cCodSiste", "'9'" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
                            EndIf
                        EndIf
                    EndIF
                    ZTN->(DbSkip())
                End
            EndIf
            If ZTN->(DbSeek( _cFilZTN + "6060" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6060" + "3" // "6060"=Compromisso
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa conforme
                        If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                            If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                                // Posicionamentos Compromisso:
                                aRecTab := { { "ZTN", Array(0) } }
                                aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                                // ###################### PROCESSO COMPROMISSO #############################
                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,             Titulo Integracao, Msg Processamento }
                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                            09,                10 }
                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta Compromisso Import",     "Processo: " })
                                aParams := {}
                                aAdd(aParams, { { "cIdLanc", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cCodSiste", "'9'" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
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
±±ºPrograma  ³ WsRc3503 ºAutor ³Jonathan Schmidt Alves º Data ³21/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao Lanc Contabil (Transito Import)  P R O C E S S A  º±±
±±º          ³                        (Baixa Transito)              6059  º±±
±±º          ³                                                            º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera lancamentos contabeis no Totvs para Transito e para   º±±
±±º          ³ Baixa do Transito (inverso).                               º±±
±±º          ³ Tabelas Totvs: CT2                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3503()
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Variaveis Loop
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
Local aTits := {}
Local aXmls := {}
Local aDados := {}
Local nOpc := 3 // 3=Inclusao
// Variaveis retorno
Local aRet := { .F., Nil, "" }
Local cError := ""
Local cWarning := ""
Local cRetXml := ""
// Variaveis filiais (Lcto Contabil)
Local _cFilCT1 := xFilial("CT1")
Local _cFilCT2 := xFilial("CT2")
Local _cFilSA2 := xFilial("SA2")
Local _cFilCTD := xFilial("CTD")
// Variaveis filiais (Tits Pagar)
Local _cFilSE2 := xFilial("SE2")
Local _cFilSED := xFilial("SED")
Local cItmCtb := ""
// Matriz carregamentos
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETISAPIFATURAIMPRESPONSE", "" }, { "NS2_ISAPIFATURAIMP", "" }, { "NS2_FATEMPRESA", cEmpAnt + cFilAnt } })
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETISAPIFATURAIMPRESPONSE", "" }, { "NS2_ISAPIFATURAIMP", "" }, { "NS2_ISAPIITEMFATURAIMPCOLLECTION", "" }, { "NS2_ISAPIITEMFATURAIMP", "" }, { "NS2_ITFATEMPRESA", cEmpAnt + cFilAnt } })
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETISAPIFATURAIMPRESPONSE", "" }, { "NS2_ISAPIFATURAIMP", "" }, { "NS2_ISAPIPARCPRAZOSFATURACOLLECTION", "" }, { "NS2_ISAPIPARCPRAZOSFATURA", "" }, { "NS2_ISAPIITEMPARCPRAZOSFATCOLLECTION", "" }, { "NS2_ISAPIITEMPARCPRAZOSFAT", "" }, { "NS2_PARCELAVALORPARCELA", "", "AllwaysTrue()" } })
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
If ZTN->(DbSeek( _cFilZTN + "6059" + "3", .T. ))
    While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN $ "6059/6060/" // "6059"=Transito "6060"=Baixa Transito/Compromisso
        If ZTN->ZTN_STATHO == "3" // "3"=Em processamento
            If ZTN->ZTN_STATOT == "05" // "05"=Xml Baixado
                If ZTN->ZTN_IDEVEN == "6059" .Or. (ZTN->ZTN_IDEVEN == "6060" .And. "NF" $ ZTN->ZTN_PVC202)          // Compromisso ou NF (Baixa do Transito)
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                            lRet := .T.
                            aDados := { Array(0), Array(0), Array(0) }
                            aRet := { .F., Nil, "" }
                            cMsg01 := ""
                            cMsg02 := ""
                            cMsg03 := ""
                            cMsg04 := ""
                            // Parte 01: Carregamento dos dados do XML
                            cRetXml := ZTN->ZTN_XMLRET // Xml da nota fiscal
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
                                                If (!Empty(aXml[_w1,02]) .And. Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02]) .Or. (Len(aXml[_w1]) >= 3 .And. &(aXml[_w1,03])) // .T.=Sucesso

                                                    /*
                                                    itFatFlexField1 -> Conta TRANSITO       Conta Debito
                                                    itFatFlexField2 -> Conta Fornecedor     Conta Credito
                                                    itFatFlexField3 -> 
                                                    itFatFlexField4
                                                    itFatFlexField5
                                                    */

                                                    // ############## TRANSITO #################
                                                    oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                                    If ValType(oXml2) == "O"
                                                        If _w0 == 1 // Cabecalho
                                                            aFlds := { { "NS2_FATEMPRESA", "", "" },;           // 01   <ns2:fatEmpresa>0102</ns2:fatEmpresa>                   Ex: 0102
                                                                { "NS2_FATDATAFATURA", "", "" },;               // 02   <ns2:fatDataFatura>2021-08-21T00:00:00Z                 Ex: 2021-08-21T00:00:00Z
                                                                { "NS2_FATCODEXPORTADOR", "", "" },;            // 03   <ns2:fatCodExportador>F0101939001                       Ex: F0101939001
                                                                { "NS2_FATCODMOEDA", "", "" },;                 // 04   <ns2:fatCodMoeda>USD</ns2:fatCodMoeda>                  Ex: USD
                                                                { "NS2_FATTAXADI", "", "" },;                   // 05   <ns2:fatTaxaDi>5.2239</ns2:fatTaxaDi>                   Ex: 5.2239
                                                                { "NS2_FATCODPROCESSO", "", "" } }              // 06   <ns2:fatCodProcesso>05-0003/21</ns2:fatCodProcesso>     Ex: 05-0003/21
                                                        ElseIf _w0 == 2 // Itens
                                                            aFlds := { { "NS2_ITFATFLEXFIELD1", "", "" },;      // 01   <ns2:itfatFlexField1>114001035</ns2:itfatFlexField1>    Ex: 114001035
                                                                { "NS2_ITFATFLEXFIELD2", "", "" },;             // 02   <ns2:itfatFlexField2>210101010</ns2:itfatFlexField2>    Ex: 210101010
                                                                { "NS2_ITFATFLEXFIELD3", "", "" },;             // 03   <ns2:itfatFlexField3>122001050</ns2:itfatFlexField3>    Ex: 122001050
                                                                { "NS2_ITFATFLEXFIELD4", "", "" },;             // 04   <ns2:itfatFlexField4>114001035</ns2:itfatFlexField4>    Ex: 113001035
                                                                { "NS2_ITFATFLEXFIELD5", "", "" },;             // 05   <ns2:itfatFlexField5>N</ns2:itfatFlexField5>            Ex: N
                                                                { "NS2_ITFATQUANTIDADE", "", "" },;             // 06   <ns2:itfatQuantidade>90000</ns2:itfatQuantidade>        Ex: 90000
                                                                { "NS2_ITFATPRECO", "", "" },;                  // 07   <ns2:itfatPreco>0.37</ns2:itfatPreco>                   Ex: 0.37
                                                                { "NS2_ITFATVMCVUNITARIOMACROITEM", "", "" },;  // 08   <ns2:itfatVmcvUnitarioMacroItem>0.39957566667           Ex: 0.3995756666666666666666666666666666666667
                                                                { "NS2_NFITEIACODEXTERNOCFOP", "", "" },;       // 09   <nfIteIaCodExternoCfop>                                 Ex: 444 - IMPORTACAO REVENDA
                                                                { "NS2_NFITEOBSERVACAO", "", "" },;             // 10   <nfIteObservacao>                                       Ex: Pedido NÂº0102.058178 ObservaÃ§Ã£o NF do Import SYS :...
                                                                { "NS2_ITFATCODEXPORTADOR", "", "" },;          // 11   <ns2:itfatCodExportador>F0101570901                     Ex: F0101570901
                                                                { "NS2_ITFATTAXAFATURA", "", "" },;             // 12   ns2:itfatTaxaFatura>6.2558</ns2:itfatTaxaFatura>        Ex: 6.2558
                                                                { "NS2_ITFATTAXADI", "", "" } }                 // 13   <ns2:itfatTaxaDi>6.3409</ns2:itfatTaxaDi>               Ex: 6.3409
                                                        ElseIf _w0 == 3 // Faturas Pagar
                                                            aFlds := { { "NS2_PARCELAVALORPARCELA", "", "" },;  // 01   ns2:parcelaValorParcela>52112.21                        Ex: 52112.21
                                                                 { "NS2_PARCELADATAVENCIMENTO", "", "" } }      // 02   <ns2:parcelaDataVencimento>2021-12-29T00:00:00Z         Ex: 2021-12-29T00:00:00Z
                                                        EndIf
                                                        For _w4 := 1 To XMLChildCount(oXml2)
                                                            cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                            If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                                aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                            EndIf
                                                        Next
                                                        aDadosItens := {}
                                                        aDadosPgtos := {}
                                                        For _w4 := 1 To Len( aFlds )
                                                            If _w0 == 1 // Cabecalho
                                                                aAdd(aDados[01], { aFlds[_w4,01], aFlds[_w4,02] })
                                                            ElseIf _w0 == 2 // Gravacao dos Itens
                                                                aAdd(aDadosItens, { aFlds[_w4,01], aFlds[_w4,02] })
                                                            ElseIf _w0 == 3 // Pagamentos
                                                                aAdd(aDadosPgtos, { aFlds[_w4,01], aFlds[_w4,02] })
                                                            EndIf
                                                        Next
                                                        If _w0 == 2 // Itens
                                                            aAdd(aDados[_w0], aClone(aDadosItens) )
                                                        ElseIf _w0 == 3 // Pagamentos
                                                            aAdd(aDados[_w0], aClone(aDadosPgtos) )
                                                        EndIf
                                                    EndIf
                                                    // ############## TRANSITO #################
                                                    If !Empty( cHldObj ) // Matriz de objetos
                                                        If _w3 < Len( &(cHldObj) )
                                                            cObj := cHldOld // Volto o objeto antigo (antes da matriz)
                                                            _w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
                                                        Else // Ja processou todos
                                                            aRet[01] := .T.
                                                        EndIf
                                                    EndIf
                                                    If aRet[01] // .T.=Ja concluido
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
                                If Len(aDados) > 0 .And. Len(aDados[01]) > 0 .And. Len(aDados[02]) > 0 .And. Len(aDados[03]) > 0 // Dados carregados
                                    cEmpFil := aDados[01,01,02]                                             // Empresa/Filial   Ex: "0102"
                                    dDatLan := Date()                                                       // Data Lancamento  Ex: "2021-08-21T00:00:00Z"  // StoD(StrTran(Left(aDados[01,02,02],10),"-","")) // Data Lanc Contabil data do sistema (Rafael Ctb)
                                    cLotLan := "008010"                                                     // Lote Lancamento  Ex: "008010"
                                    cSubLan := "001"                                                        // SubLote Lancam   Ex: "001"
                                    cDocLan := "990001"                                                     // Doc Lancamento   Ex: "990001"
                                    nTpLanc := Iif( "NF" $ ZTN->ZTN_PVC202, 2, 1)                           // Tipo Lancamento  Ex: 1=Transito 2=Baixa do Transito
                                    If cEmpFil == cEmpAnt + cFilAnt // Empresa/Filial conforme
                                        DbSelectArea("CT2")
                                        CT2->(DbSetOrder(1)) // CT2_FILIAL + DtoS(CT2_DATA) + CT2_LOTE + CT2_SBLOTE + CT2_DOC + CT2_LINHA + ...
                                        While CT2->(DbSeek( _cFilCT2 + DtoS(dDatLan) + cLotLan + cSubLan + cDocLan ))
                                            cDocLan := Soma1(cDocLan,6)
                                            CT2->(DbSkip())
                                        End
                                        aCab := { { "DDATALANC",        dDatLan,        Nil },; // Data
                                        { "CLOTE",                      "008010",       Nil },; // Lote
                                        { "CSUBLOTE",                   "001",          Nil },; // SubLote
                                        { "CDOC",                       cDocLan,        Nil },; // Doc
                                        { "CPADRAO",                    "",             Nil },;
                                        { "NTOTINF",                    0,              Nil },;
                                        { "NTOTINFLOT",                 0,              Nil } }

                                        // FlexField1: Conta Contabil Transito                  Ex: "114001035" MERCADORIAS EM TRANSITO             -> Vai no Debito (sem discussao)

                                        // Contas do Fornecedor:
                                        // FlexField2: Conta Contabil Fornecedor                Ex: "210101010" FORNECEDORES ESTRANGEIROS           -> Teste (verificar deppis)
                                        // FlexField3: Conta Contabil Fornecedor Ativo          Ex: "122001050" ATIVO EM CURSO FORN ESTRANGEIRO     -> Teste (verificar deppis)

                                        // FlexField4: Conta Contabil Fornecedor Extrangeiro    Ex: "113001035" ADIANTAMENTO FORN ESTRANGEIRO       -> Nao usa agora

                                        // FlexField5: "N"                                      Ex: "S"=Do Grupo "N"=Nao do Grupo                   -> Nao usado por enquanto

                                        aItens := {}
                                        For _w2 := 1 To Len(aDados[02])
                                            If lRet // .T.=Ainda valido
                                                cCodForn := SubStr( aDados[02,_w2,11,02], 04, 06 )      // Codigo Fornecedor
                                                cLojForn := SubStr( aDados[02,_w2,11,02], 10, 02 )      // Loja Fornecedor
                                                DbSelectArea("SA2")
                                                SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                                                If SA2->(DbSeek( _cFilSA2 + cCodForn + cLojForn ))
                                                    If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                                                        nTaxClc := Val( Iif(nTpLanc == 1, aDados[02,_w2,12,02], aDados[02,_w2,13,02]) ) // Transito usa Taxa da Fatura, Baixa do Transito usa Taxa da DI
                                                        nVlrLan := Val(aDados[02,_w2,06,02]) * Val(aDados[02,_w2,08,02]) * nTaxClc      // NS2_ITFATQUANTIDAD x NS2_ITFATVMCVUNITARIOMACROITEM x (NS2_ITFATTAXAFATURA ou NS2_ITFATTAXADI)
                                                        If nVlrLan > 0 // Valor valido
                                                            cDebCre := aDados[02,_w2,01,02]                                                                 // Conta Debito
                                                            cCreDeb := aDados[02,_w2,02,02]                                                                 // Conta Credito (verificar depois com Eduardo Contabil)
                                                            cItmCre := ""                                                                                   // Item Contabil
                                                            DbSelectArea("CT1")
                                                            CT1->(DbSetOrder(1)) // CT1_FILIAL + CT1_CONTA
                                                            If CT1->(DbSeek( _cFilCT1 + cDebCre )) // Conta Debito
                                                                If CT1->(DbSeek( _cFilCT1 + cCreDeb )) // Conta Debito/Credito
                                                                    If CT1->CT1_ITOBRG == "1" // "1"=Item Contabil Obrigatorio

                                                                        DbSelectArea("CTD")
                                                                        CTD->(DbSetOrder(1)) // CTD_FILIAL + CTD_ITEM
                                                                        If CTD->(DbSeek( _cFilCTD + "2" + SA2->A2_COD + SA2->A2_LOJA ))
                                                                            cItmCtb := CTD->CTD_ITEM            // Item Contabil Credito
                                                                        Else // Item Contabil nao encontrado no cadastro (CTD)!
                                                                            cMsg01 := "Item Contabil " + {"Credito","Debito"}[nTpLanc] + " nao encontrada no cadastro (CTD)!"
                                                                            cMsg02 := "Item Contabil: " + "2" + SA2->A2_COD + SA2->A2_LOJA
                                                                            cMsg03 := ""
                                                                            cMsg04 := ""
                                                                            lRet := .F.
                                                                        EndIf

                                                                        cItmCtb := "299999999" // Temporario Eduardo
                                                                        
                                                                    EndIf
                                                                    aAdd(aItens, Array(0))
                                                                    aAdd(aTail(aItens), { "CT2_LINHA",                                      StrZero(_w2,3),                         Nil }) // *** OK    Linha do Lancamento
                                                                    aAdd(aTail(aItens), { "CT2_MOEDLC",                                               "01",                         Nil }) // *** OK    "01"=Moeda Real
                                                                    aAdd(aTail(aItens), { "CT2_DC",                                                    "3",                         Nil }) // *** OK    3=Partida Dobrada
                                                                    aAdd(aTail(aItens), { Iif(nTpLanc == 1,"CT2_DEBITO","CT2_CREDIT"),             cDebCre,                         Nil }) // *** OK    Debito Mercadoria em Transito
                                                                    aAdd(aTail(aItens), { Iif(nTpLanc == 1,"CT2_CREDIT","CT2_DEBITO"),             cCreDeb,                         Nil }) // *** OK    Credito Contra Fornecedor
                                                                    If !Empty(cItmCtb) // Item Contabil
                                                                        aAdd( aTail(aItens), { Iif(nTpLanc == 1, "CT2_ITEMC", "CT2_ITEMD"),  CTD->CTD_ITEM,                         Nil }) // *** OK     Item Contabil
                                                                    EndIf
                                                                    aAdd( aTail(aItens), { "CT2_VALOR",                                            nVlrLan,                         Nil }) // *** OK     Valor Lancamento
                                                                    aAdd( aTail(aItens), { "CT2_ORIGEM",                      "Thomson " + DtoC(dDatabase),                         Nil }) // *** OK
                                                                    aAdd( aTail(aItens), { "CT2_HP",                                                    "",                         Nil }) // *** OK
                                                                    aAdd( aTail(aItens), { "CT2_HIST",                                         "HISTORICO",                         Nil }) // *** OK
                                                                Else // Conta Contabil Credito nao encontrada no cadastro (CT1)
                                                                    cMsg01 := "Conta Contabil " + {"Credito","Debito"}[nTpLanc] + " nao encontrada no cadastro (CT1)!"
                                                                    cMsg02 := "Conta: " + cCreDeb
                                                                    cMsg03 := ""
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                            Else // Conta Contabil Debito nao encontrada no cadastro (CT1)
                                                                cMsg01 := "Conta Contabil " + {"Debito","Credito"}[nTpLanc] + " nao encontrada no cadastro (CT1)!"
                                                                cMsg02 := "Conta: " + cDebCre
                                                                cMsg03 := ""
                                                                cMsg04 := ""
                                                                lRet := .F.
                                                            EndIf
                                                        Else // Valor calculado invalido
                                                            cMsg01 := "Valor calculado no lancamento contabil invalido!"
                                                            cMsg02 := "Verifique no XML se os dados estao corretos e tente novamente!"
                                                            cMsg03 := "Qtde: " + aDados[02,_w2,06,02] + " Vlr Unit: " + aDados[02,_w2,08,02]
                                                            cMsg04 := "Taxa Moeda: " + cValToChar(nTaxClc)
                                                            lRet := .F.
                                                        EndIf
                                                    Else // Fornecedor esta bloqueado no cadastro (SA2)
                                                        cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                        cMsg02 := "Verifique o fornecedor e tente novamente!"
                                                        cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Fornecedor nao encontrado no cadastro (SA2)
                                                    cMsg01 := "Fornecedor/Loja nao encontrado no cadastro (SA2)!"
                                                    cMsg02 := "Forn/Loja: " + cCodForn + "/" + cLojForn
                                                    cMsg03 := ""
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            EndIf
                                        Next
                                        If lRet // Ainda valido
                                            If Len(aCab) == 0 // Dados do Cabecalho nao foram carregados
                                                cMsg01 := "Dados do Cabecalho nao foram carregados!"
                                                cMsg02 := "O lancamento contabil nao pode ser realizado!"
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                            ElseIf Len( aItens ) == 0
                                                cMsg01 := "Dados dos Itens nao foram carregados!"
                                                cMsg02 := "O lancamento contabil nao pode ser realizado!"
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                            If lRet // .T.=Valido para geracao lancamento contabil

                                                If nTpLanc == 2 // 2=Baixa do Transito gera titulo pagar

                                                    DbSelectArea("SA2")
                                                    SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                                                    If SA2->(DbSeek( _cFilSA2 + SubStr(aDados[01,03,02],4,6) + SubStr(aDados[01,03,02],10,2) ))
                                                        // Montagem das variaveis para geracao dos titulos a pagar
                                                        cNumPar := "AAA"
                                                        For _w4 := 1 To Len( aDados[03] ) // Rodo nos Pagamentos
                                                            cPrfTit := "THO"                                                                // 01 Prefixo do titulo         Ex: "THO"
                                                            cNumTit := "000000001"                                                          // 02 Numero do titulo          Ex: "000476398"
                                                            cNumPar := Iif( _w4 > 1, Soma1( cNumPar, 3 ), cNumPar)                          // 03 Numero da Parcela         Ex: "AAA", "AAB", "AAC", etc
                                                            cTipTit := "INV"                                                                // 04 Tipo do titulo            Ex: "INV"
                                                            cCodFor := SA2->A2_COD                                                          // 05 Codigo do fornecedor      Ex: "069785"
                                                            cLojFor := SA2->A2_LOJA                                                         // 06 Loja do fornecedor        Ex: "01"
                                                            cNatTit := "21002     "                                                         // 07 Natureza do titulo        Ex: "21002" (fixa)
                                                            dEmissa := Min( Date(), StoD(StrTran(Left(aDados[03,_w4,02,02],10),"-","")) )   // 08 Data de emissao           Ex: 20/10/2021
                                                            dVencto := StoD(StrTran(Left(aDados[03,_w4,02,02],10),"-",""))                  // 09 Data do vencimento        Ex: "2021-12-29T00:00:00Z"
                                                            nVlrMoe := Round(Val(aDados[03,_w4,01,02]),2)                                   // 10 Valor moeda estrangeira   Ex: 52112.21
                                                            nCodMoe := Iif(aDados[01,04,02] == "USD",2,4)                                   // 11 Moeda                     Ex: 2=Dolar 4=Euro
                                                            nTaxMoe := Val(aDados[01,05,02])                                                // 12 Taxa da Moeda             Ex: 5.2239
                                                            cHisTit := "Thomson " + aDados[01,06,02]                                        // 13 Historico do titulo       Ex: "Thomson 05-0003/21"

                                                            cProTho := aDados[01,06,02]                                                     // 21 Numero do Processo        Ex: 05-0003/21

                                                            //           {      01,      02,      03,      04,      05,      06,      07,      08,      09,      10,      11,      12,      13,,,,,,,,      21 }
                                                            aAdd( aTits, { cPrfTit, cNumTit, cNumPar, cTipTit, cCodFor, cLojFor, cNatTit, dEmissa, dVencto, nVlrMoe, nCodMoe, nTaxMoe, cHisTit,,,,,,,, cProTho })

                                                        Next
                                                        // Geracao dos Titulo a Pagar (usar a Taxa da DI)
                                                        For _w1 := 1 To Len( aTits )
                                                            If lRet // Ainda valido
                                                                DbSelectArea("SE2")
                                                                SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
                                                                SE2->(DbSeek( _cFilSE2 + aTits[_w1,01] + "999999999", .T. ))
                                                                SE2->(DbSkip(-1))
                                                                If SE2->E2_PREFIXO == aTits[_w1,01]
                                                                    aTits[_w1,02] := Soma1(SE2->E2_NUM,9)
                                                                EndIf
                                                                DbSelectArea("SA2")
                                                                SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                                                                DbSelectArea("SED")
                                                                SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                                                                If SED->(!DbSeek(_cFilSED + aTits[_w1,07]))
                                                                    cMsg01 := "Natureza nao encontrada no cadastro (SED)!"
                                                                    cMsg02 := "Natureza: " + aTits[_w1,07]
                                                                    cMsg03 := ""
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                ElseIf SA2->(!DbSeek(_cFilSA2 + aTits[_w1,05] + aTits[_w1,06] ))
                                                                    cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                                                                    cMsg02 := "Fornecedor/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                                                                    cMsg03 := ""
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                ElseIf SA2->A2_MSBLQL == "1" // Fornecedor bloqueado
                                                                    cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                                    cMsg02 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                                    cMsg03 := ""
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                            EndIf
                                                        Next

                                                    EndIf
                                                    // Fim das validacoes Geracao dos Titulos Pagar
                                                EndIf

                                                If lRet // Titulos a pagar validos para processamento ou nao serao gerados titulos

                                                    // Parte 01: Geracao Lancamento Contabil
                                                    lMsErroAuto := .F.
                                                    lMsHelpAuto := .T.
                                                   // MsExecAuto({|x,y,z|, CTBA102(x,y,z) }, aCab, aItens, nOpc) // 3=Inclusao CT2
                                                    
                                                    If !lMsErroAuto // Sucesso

                                                        // Parte 02: Geracao dos Titulos a Pagar
                                                        If nTpLanc == 2 // 2=Baixa do Transito gera titulo pagar
                                                            cChvTit := ""
                                                            For _w1 := 1 To Len( aTits )
                                                                aTitulo := { { "E2_PREFIXO",    aTits[_w1,01],                          Nil },;
                                                                        { "E2_NUM",             aTits[_w1,02],                          Nil },;
                                                                        { "E2_PARCELA",         aTits[_w1,03],                          Nil },;
                                                                        { "E2_TIPO",            aTits[_w1,04],                          Nil },;
                                                                        { "E2_FORNECE",         aTits[_w1,05],                          Nil },;
                                                                        { "E2_LOJA",            aTits[_w1,06],                          Nil },;
                                                                        { "E2_EMISSAO",         aTits[_w1,08],                          Nil },;
                                                                        { "E2_EMIS1",           aTits[_w1,08],                          Nil },;
                                                                        { "E2_VENCTO",          aTits[_w1,09],                          Nil },;
                                                                        { "E2_VENCREA",         DataValida(aTits[_w1,09]),              Nil },;
                                                                        { "E2_MOEDA",           aTits[_w1,11],                          Nil },;
                                                                        { "E2_TXMOEDA",         aTits[_w1,12],                          Nil },;
                                                                        { "E2_VALOR",           aTits[_w1,10],                          Nil },;
                                                                        { "E2_VLCRUZ",          Round(aTits[_w1,10] * aTits[_w1,12],2), Nil },;
                                                                        { "E2_NATUREZ",         aTits[_w1,07],                          Nil },;
                                                                        { "E2_HIST",            aTits[_w1,13],                          Nil } } // ,;
                                                                        // { "E2_XPROTHO",         aTits[_w1,21],                          Nil } } // Processo Thomson

                                                                Pergunte("FIN050",.F.)
                                                                Mv_Par01 := 1                   // Mostra Lancamento Contabil       1=Sim 2=Nao
                                                                Mv_Par03 := 1                   // Contabiliza On-Line              1=Sim 2=Nao
                                                                lMsErroAuto := .F.
                                                                lExibeLanc := .F.
                                                                lOnline := .F.
                                                                MsExecAuto({|x,y|, FINA050(x,y) }, aTitulo, nOpc,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao      3,, /*aDadosBco*/ Nil, lExibeLanc, lOnline)
                                                                If lMsErroAuto // Falha
                                                                    ConOut("WsRc3503: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                                                    cMsg01 := "Falha no ExecAuto (FINA050)"
                                                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                    MostraErro()
                                                                    Exit
                                                                Else // Sucesso
                                                                    RecLock("SE2",.F.)
                                                                    SE2->E2_XBLQ := "" // Deixo o titulo "desbloqueado"
                                                                    SE2->(MsUnlock())
                                                                    If Empty(cChvTit)
                                                                        cChvTit := cEmpAnt + cFilAnt + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
                                                                    EndIf
                                                                EndIf
                                                            Next
                                                        EndIf

                                                        If lRet // .T.Processamento realizado com suceso (Lanc Contabil + Titulos Pagar qdo baixa transito)
                                                            RecLock("ZTN",.F.)
                                                            ZTN->ZTN_STATOT := "08" // "08"=Lancamento Contabil gerado com sucesso e Titulos Pagar gerados com sucesso
                                                            ZTN->ZTN_DETPR1 := "Lancamento Contabil gerado com sucesso!"
                                                            ZTN->ZTN_DETPR2 := "Data: " + DtoC(CT2->CT2_DATA) + " Doc: " + CT2->CT2_DOC
                                                            If nTpLanc == 2 // 2=Baixa do Transito gera titulo pagar
                                                                ZTN->ZTN_DETPR3 := "Emp/Fil/Pref/Num/Parc/Tipo/Fornecedor/Loja: " + cChvTit
                                                            EndIf
                                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                                            ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                                            ZTN->(MsUnlock())
                                                        EndIf
                                                    Else // Erro
                                                        MostraErro()
                                                    EndIf
                                                EndIf

                                            EndIf // Valido para geracao do lancamento contabil
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
        ZTN->(DbSkip())
    End
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3504 ºAutor ³Jonathan Schmidt Alves º Data ³15/10/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza Data do Compromisso. (Import)    P R O C E S S A  º±±
±±º          ³                                                      6060  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Atualiza datas do compromisso a partir de dados carregados º±±
±±º          ³ no XML do evento 6060 "COMPROMISSO" da ZTN.                º±±
±±º          ³ Tabelas Totvs: SW3                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3504()
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Variaveis retorno
Local aRet := { .F., Nil, "" }
Local cError := ""
Local cWarning := ""
Local cRetXml := ""
Local aXmls := {}
Local aDados := {}
// Variaveis filiais
Local _cFilSW2 := xFilial("SW2")
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETISAPIFATURAIMPRESPONSE", "" }, { "NS2_ISAPIFATURAIMP", "" }, { "NS2_FATEMPRESA", cEmpAnt + cFilAnt } })
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "NS2_GETISAPIFATURAIMPRESPONSE", "" }, { "NS2_ISAPIFATURAIMP", "" }, { "NS2_ISAPIITEMFATURAIMPCOLLECTION", "" }, { "NS2_ISAPIITEMFATURAIMP", "" }, { "NS2_ITFATEMPRESA", cEmpAnt + cFilAnt } })
DbSelectArea("SW2")
SW2->(DbSetOrder(1)) // W2_FILIAL + W2_PO_NUM
DbSelectArea("SW3")
SW3->(DbSetOrder(8)) // W3_FILIAL + W3_PO_NUM + W3_POSICAO
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
If ZTN->(DbSeek( _cFilZTN + "6060" + "3" ))
    While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6060" + "3" // "6060"=Compromisso
        If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
            If ZTN->ZTN_STATOT == "05" // "3"=Em Processamento Totvs "05"=Em Processamento Totvs (Xml Baixado)
                If "COMPROMISSO" $ Upper(ZTN->ZTN_PVC202)
                    // Parte 01: Carregamento dos dados do XML
                    cRetXml := ZTN->ZTN_XMLRET // Xml da nota fiscal
                    oXml := XmlParser(cRetXml, "_", @cError, @cWarning)
                    If XMLChildCount(oXml) > 0
                        lRet := .T.
                        aDados := { Array(0), Array(0) }
                        aRet := { .F., Nil, "" }
                        cMsg01 := ""
                        cMsg02 := ""
                        cMsg03 := ""
                        cMsg04 := ""
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
                                        If !Empty(aXml[_w1,02])
                                            If Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02] // .T.=Sucesso
                                                // ############## COMPROMISSO #################
                                                oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                                If ValType(oXml2) == "O"
                                                    If _w0 == 1 // Cabecalho
                                                        aFlds := { { "NS2_FATEMPRESA", "", "" },;           // 01   <ns2:fatEmpresa>0102</ns2:fatEmpresa>                   Ex: 0102
                                                            { "NS2_FATDATAFATURA", "", "" },;               // 02   <ns2:fatDataFatura>2021-08-21T00:00:00Z                 Ex: 2021-08-21T00:00:00Z
                                                            { "NS2_FATDATAPREVISAOSAIDA", "", "" },;        // 03   <ns2:fatDataPrevisaoSaida>2021-09-05T00:00:00Z          Ex: 2021-09-05T00:00:00Z
                                                            { "NS2_FATDATAPREVISAOCHEGADA", "", "" },;      // 04   <ns2:fatDataPrevisaoChegada>2021-10-07T00:00:00Z        Ex: 2021-10-07T00:00:00Z
                                                            { "NS2_FATCODPROCESSO", "", "" } }              // 05   <ns2:fatCodProcesso>02-0016/21</ns2:fatCodProcesso>     Ex: 02-0016/21
                                                    ElseIf _w0 == 2 // Itens
                                                        aFlds := { { "NS2_ITFATFLEXFIELD1", "", "" },;      // 01   <ns2:itfatFlexField1>114001035</ns2:itfatFlexField1>    Ex: 114001035
                                                            { "NS2_ITFATFLEXFIELD2", "", "" },;             // 02   <ns2:itfatFlexField2>210101010</ns2:itfatFlexField2>    Ex: 210101010
                                                            { "NS2_ITFATFLEXFIELD3", "", "" },;             // 03   <ns2:itfatFlexField3>122001050</ns2:itfatFlexField3>    Ex: 122001050
                                                            { "NS2_ITFATFLEXFIELD4", "", "" },;             // 04   <ns2:itfatFlexField4>114001035</ns2:itfatFlexField4>    Ex: 113001035
                                                            { "NS2_ITFATFLEXFIELD5", "", "" },;             // 05   <ns2:itfatFlexField5>N</ns2:itfatFlexField5>            Ex: N
                                                            { "NS2_ITFATQUANTIDADE", "", "" },;             // 06   <ns2:itfatQuantidade>90000</ns2:itfatQuantidade>        Ex: 90000
                                                            { "NS2_ITFATPRECO", "", "" },;                  // 07   <ns2:itfatPreco>0.37</ns2:itfatPreco>                   Ex: 0.37
                                                            { "NS2_ITFATVMCVUNITARIOMACROITEM", "", "" },;  // 08   <ns2:itfatVmcvUnitarioMacroItem>0.39957566667           Ex: 0.3995756666666666666666666666666666666667
                                                            { "NS2_NFITEIACODEXTERNOCFOP", "", "" },;       // 09   <nfIteIaCodExternoCfop>                                 Ex: 444 - IMPORTACAO REVENDA
                                                            { "NS2_NFITEOBSERVACAO", "", "" },;             // 10   <nfIteObservacao>                                       Ex: Pedido NÂº0102.058178 ObservaÃ§Ã£o NF do Import SYS :...
                                                            { "NS2_ITFATCODEXPORTADOR", "", "" },;          // 11   <ns2:itfatCodExportador>F0101570901                     Ex: F0101570901
                                                            { "NS2_ITFATTAXAFATURA", "", "" },;             // 12   ns2:itfatTaxaFatura>6.2558</ns2:itfatTaxaFatura>        Ex: 6.2558
                                                            { "NS2_ITFATTAXADI", "", "" },;                 // 13   <ns2:itfatTaxaDi>6.3409</ns2:itfatTaxaDi>               Ex: 6.3409
                                                            { "NS2_ITFATNUMORDEM", "", "" },;               // 14   <ns2:itfatNumOrdem>0102.059924</ns2:itfatNumOrdem>      Ex: 0102.059924
                                                            { "NS2_ITFATNUMITEMORDEM", "", "" },;           // 15   <ns2:itfatNumItemOrdem>1</ns2:itfatNumItemOrdem>        Ex: 1
                                                            { "NS2_ITFATDATAPREVISAOCHEGADA", "", "" },;    // 16   <ns2:itfatDataPrevisaoChegada>2021-09-19T00:00:00Z      Ex: 2021-09-19T00:00:00Z
                                                            { "NS2_ITFATDATACHEGADA", "", "" } }            // 17   <ns2:itfatDataChegada>2021-09-20T00:00:00Z              Ex: 2021-09-20T00:00:00Z
                                                    EndIf
                                                    For _w4 := 1 To XMLChildCount(oXml2)
                                                        cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                        If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                            aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                        EndIf
                                                    Next
                                                    aDadosItens := {}
                                                    For _w4 := 1 To Len( aFlds )
                                                        If _w0 == 1 // Cabecalho
                                                            aAdd(aDados[01], { aFlds[_w4,01], aFlds[_w4,02] })
                                                        ElseIf _w0 == 2 // Gravacao dos Itens
                                                            aAdd(aDadosItens, { aFlds[_w4,01], aFlds[_w4,02] })
                                                        EndIf
                                                    Next
                                                    If _w0 == 2 // Itens
                                                        aAdd(aDados[_w0], aClone(aDadosItens) )
                                                    EndIf
                                                EndIf
                                                // ############## COMPROMISSO #################
                                                If !Empty( cHldObj ) // Matriz de objetos
                                                    If _w3 < Len( &(cHldObj) )
                                                        cObj := cHldOld // Volto o objeto antigo (antes da matriz)
                                                        _w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
                                                    Else // Ja processou todos
                                                        aRet[01] := .T.
                                                    EndIf
                                                EndIf
                                            EndIf
                                            If aRet[01] // .T.=Ja concluido
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
                        If Len(aDados) > 0 .And. Len(aDados[01]) > 0 .And. Len(aDados[02]) > 0 // Dados carregados
                            
                            //aAreaZTN := ZTN->(GetArea())
                            //ZTN->(DbSetOrder(5)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_PVC201 + ZTN_PVC202
                            
                            // If ZTN->(DbSeek(_cFilZTN + "6002" + aDados[01,05,02])) // Localizo o Processo no ZTN 6002
                            For _w1 := 1 To Len(aDados[02]) // Rodo nos itens
                                If SW2->(DbSeek(_cFilSW2 + SubStr(aDados[02,_w1,14,02],6,6))) // PO localizado
                                    If SW3->(DbSeek( SW2->W2_FILIAL + SW2->W2_PO_NUM + StrZero( Val(aDados[02,_w1,15,02]),4)))
                                        While SW3->(!EOF()) .And. SW3->W3_FILIAL + SW3->W3_PO_NUM + SW3->W3_POSICAO == SW2->W2_FILIAL + SW2->W2_PO_NUM + StrZero( Val(aDados[02,_w1,15,02]),4) // Atualizo todos os itens
                                            RecLock("SW3",.F.)
                                            SW3->W3_DT_EMB  := StoD(StrTran(Left(aDados[02,_w1,16,02],10),"-",""))      // Previsao Saida       W3_DT_EMB        ETD Estimated Date Delivery
                                            SW3->W3_DT_ENTR := StoD(StrTran(Left(aDados[02,_w1,17,02],10),"-",""))      // Previsao Chegada     W3_DT_ENTR       ETA Estimated Date Arrived
                                            SW3->(MsUnlock())
                                            SW3->(DbSkip())
                                        End
                                        // RestArea(aAreaZTN)
                                        RecLock("ZTN",.F.)
                                        ZTN->ZTN_STATOT := "08" // "08"=Compromisso processado com sucesso
                                        ZTN->ZTN_DETPR1 := "Compromisso processado com sucesso!"
                                        ZTN->ZTN_DETPR2 := "Datas do Compromisso atualizadas!"
                                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                        ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                        ZTN->(MsUnlock())
                                    Else // SW3 nao encontrado
                                        cMsg01 := "Itens do Pedido de Importacao nao encontrados no cadastro (SW3)!"
                                        cMsg02 := "Pedido de Importacao: " + SW2->W2_PO_NUM
                                        cMsg03 := ""
                                        cMsg04 := ""
                                        lRet := .F.
                                    EndIf
                                Else // SW2 nao encontrado
                                    cMsg01 := "Pedido de Importacao nao encontrado no cadastro (SW2)!"
                                    cMsg02 := "Pedido de Importacao: " + aDados[01,05,02]
                                    cMsg03 := ""
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                            Next
                            
                            //Else // Processo nao localizado (ZTN 6002)
                            //    cMsg01 := "Processo nao localizado (ZTN)!"
                            //    cMsg02 := "O processo deve ser encontrado no evento 6002!"
                            //    cMsg03 := "Processo: " + aDados[01, 05 ,02]
                            //    cMsg04 := ""
                            //    lRet := .F.
                            //EndIf
                            
                            // RestArea(aAreaZTN)
                        Else // Dados do XML nao carregados
                            cMsg01 := "Dados do XML nao foram carregados!"
                            cMsg02 := "Sem os dados o compromisso nao pode ser atualizado!"
                            cMsg03 := "Verifique o processamento e tente novamente!"
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    EndIf // Objeto XML carregado
                EndIf // Registro de "COMPROMISSO"
            EndIf // ZTN conforme "05"=Em Processamento Totvs (Xml Baixado)
        EndIf // Recno ZTN especifico (tela) ou todos
        ZTN->(DbSkip())
    End // While do ZTN
EndIf // ZTN 6060
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3701 ºAutor ³Jonathan Schmidt Alves º Data ³12/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Notificacao (NFiscal Import)     C O N S U L T A  º±±
±±º          ³                                                      6002  º±±
±±º          ³ ID Interface no In-Out: PKG_SFW_NOTAFISCAL_NFENFC          º±±
±±º          ³ API: N/A                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    N/A                                                     º±±
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
±±º          ³ Carrega o XML da nota fiscal para o ZTN.                   º±±
±±º          ³ Tabelas Totvs: ZTN                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3701()
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
            If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6002" + "3" // "6002"=NFiscal Import
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                            // Consulta Importacao:
                            cCodEvent := ZTN->ZTN_IDEVEN            // Codigos do evento
                            cDesEvent := "Importacao"
                            cNfeNfcId := RTrim(ZTN->ZTN_NUMB01)     // Id Number
                            cCodSiste := "9"                        // Tudo para importacao
                            // Posicionamentos Notificacoes:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            // ###################### NOTIFICACAO NOTA IMP #############################
                            //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,          Titulo Integracao,                               Msg Processamento }
                            //            {        01,                      02,      03,             04,         05,         06,              07,              08,                         09,                                              10 }
                            aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta de Notificacoes", "Evento: " + cCodEvent + " " + RTrim(cDesEvent) })
                            aParams := {}
                            aAdd(aParams, { { "cNfeNfcId", "'" + cNfeNfcId + "'" }, { "cCodSiste", "'" + cCodSiste + "'" } }) // Variaveis auxiliares
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
±±ºPrograma  ³ WsRc3703 ºAutor ³Jonathan Schmidt Alves º Data ³12/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento Nota de Entrada. (Import)   P R O C E S S A  º±±
±±º          ³                                                      6002  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera a Pre-Nota de Entrada (MATA140) ou a Nota Fiscal de   º±±
±±º          ³ Entrada (MATA103) a partir do XML baixado no ZTN.          º±±
±±º          ³ Tabelas Totvs: SF1/SD1/CD5/ZTN                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3703()
Local _w0
Local _w1
Local _w2
Local _w3
Local _w4
Local aXmls := {}
Local cRetXml := "" // XML Nota de Entrada
Local cError := ""
Local cWarning := ""
// Retorno
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Validacao Xml
Local aRet := { lRet, Nil, "" }
Local aCabec := {}
Local aItem := {}
Local aItens := {}
Local nOpc := 3 // 3=Inclusao
Local lPreNota := .T. // .T.=Gerar Pre-Nota (MATA140) .F.=Gerar Nota Entrada (MATA103)
Local lFilhote := .F.
Local nTotSD1 := 0
//              { Cabecalh,  ItensNf,  Volumes }
Local aDados := { Array(0), Array(0), Array(0) }
// Variaveis Filiais
Local _cFilZTN := xFilial("ZTN")
Local _cFilSB1 := xFilial("SB1")
Local _cFilSA2 := xFilial("SA2")

Local _cFilSA5 := xFilial("SA5")

Local _cFilSA4 := xFilial("SA4")
Local _cFilSC7 := xFilial("SC7")
Local _cFilCT1 := xFilial("CT1")
Local _cFilCTT := xFilial("CTT")
Local _cFilSW2 := xFilial("SW2")
Local _cFilSY6 := xFilial("SY6")
Local _cFilSE4 := xFilial("SE4")
Local _cFilSF4 := xFilial("SF4")
Local _cFilCD5 := xFilial("CD5")
Local _cFilSD1 := xFilial("SD1")
// Recnos
Local aRecnos := { { "SA2", Array(0) }, { "SA4", Array(0) }, { "SB1", Array(0) }, { "SC7", Array(0) }, { "CT1", Array(0) }, { "CTT", Array(0) }, { "SW2", Array(0) }, { "SY6", Array(0) }, { "SE4", Array(0) }, { "SF4", Array(0) } }

Local _cQuery1 := ""
Local _cAlias1 := GetNextAlias()

aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETNOTAFISCALRESPONSE", "" }, { "BSAPINFENFC", "" }, { "NFEMPRESA", cEmpAnt + cFilAnt } })
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETNOTAFISCALRESPONSE", "" }, { "BSAPINFENFC", "" }, { "BSAPIITEMNFENFCCOLLECTION", "" }, { "BSAPIITEMNFENFC", "" }, { "NFITEEMPRESA", cEmpAnt + cFilAnt } })
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETNOTAFISCALRESPONSE", "" }, { "BSAPINFENFC", "" }, { "BSAPIITEMNFENFC", "" }, { "BSAPINFENFCMULTVOLUMESCOLLECTION", "" }, { "BSAPINFENFCMULTVOLUMES", "" }, { "NFVOLNFID", "", "AllwaysTrue()" } })
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
ZTN->(DbSeek(_cFilZTN + "6002" + "3"))
While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
        If ZTN->ZTN_STATOT == "05" // "05"=XML Baixado
            If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                aDados := { Array(0), Array(0), Array(0) }
                // Parte 01: Carregamento dos dados do XML
                cRetXml := ZTN->ZTN_XMLRET // Xml da nota fiscal
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
                                    If (!Empty(aXml[_w1,02]) .And. Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02]) .Or. (Len( aXml[_w1] ) >= 3 .And. &(aXml[_w1,03]) ) // .T.=Sucesso
                                        // ############## NOTA FISCAL ENTRADA #################
                                        If .T. // "PRC_IT_CE_OUT_TXT" $ ZT1->ZT1_NOMAPI
                                            oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                            If ValType(oXml2) == "O"
                                                If _w0 == 1 // Cabecalho
                                                    aFlds := { { "NFEMPRESA", "", "" },;            // 01   <nfEmpresa>02</nfEmpresa>                               Ex: 0102
                                                        { "NFNUMNF", "", "" },;                     // 02   <nfNumnf>1</nfNumnf>                                    Ex: 9
                                                        { "NFSERIE", "", "" },;                     // 03   <nfSerie>1</nfSerie>                                    Ex: 1
                                                        { "NFDTEMIS", "", "" },;                    // 04   <nfDtemis>2021-07-08T17:59:17Z</nfDtemis>               Ex: 2021-09-16T16:23:08Z
                                                        { "NFCLIFOR", "", "" },;                    // 05   <nfClifor>018545</nfClifor>                             Ex: F0101460301
                                                        { "NFNFESEFAZCHAVEACESSO", "", "" },;       // 06   <nfNfeSefazChaveAcesso>                                 Ex: 35210905890658000210550010000000090000001082
                                                        { "NFNFESEFAZCNPJ", "", "" },;              // 07   <nfNfeSefazCnpj>05890658000210</nfNfeSefazCnpj>         Ex: 05890658000210
                                                        { "NFVRFRETE", "", "" },;                   // 08   <nfVrfrete>33821.58</nfVrfrete>                         Ex: 33821.58
                                                        { "NFVRSEGURO", "", "" },;                  // 09   <nfVrseguro>112.1</nfVrseguro>                          Ex: 112.1
                                                        { "NFVRDESPESA", "", "" },;                 // 10   nfVrdespesa>8889.3799</nfVrdespesa>                     Ex: 8889.3799
                                                        { "NFOBSERVACAO", "", "" },;                // 11   <nfObservacao>                                          Ex:
                                                        { "NFESPECIEVOLUMEDESCRICAO", "", "" },;    // 12   <nfEspecieVolumeDescricao>BAU DE METAL                  Ex: BAU DE METAL
                                                        { "NFCNPJTRANSPLOCAL", "", "" },;           // 13   <nfCnpjTranspLocal>58128174000203</nfCnpjTranspLocal>   Ex: 58128174000203
                                                        { "NFRAZAOSOCIALTRANSPLOCAL", "", "" },;    // 14   <nfRazaoSocialTranspLocal>BANDEIRANTES DEICMAR LOG      Ex: BANDEIRANTES DEICMAR LOGISTICA INTEGRADA
                                                        { "NFENDERECOTRANSPLOCAL", "", "" },;       // 15   <nfEnderecoTranspLocal>AV EDUARDO P GUINLE, SN          Ex: AV EDUARDO P GUINLE, SN
                                                        { "NFCIDADETRANSPLOCAL", "", "" },;         // 16   <nfCidadeTranspLocal>SANTOS</nfCidadeTranspLocal>       Ex: SANTOS
                                                        { "NFNFESEFAZNUMERO", "", "" },;            // 17   <nfNfeSefazNumeroNf>000000017</nfNfeSefazNumeroNf>      Ex: 000000017
                                                        { "NFNUMERODI", "", "" },;                  // 18   <nfNumeroDi>2113427060</nfNumeroDi>                     Ex: 2113427060
                                                        { "NFTIPODI", "", "" },;                    // 19   <nfTipoDi>N</nfTipoDi>                                  Ex: N
                                                        { "NFTAXADI", "", "" },;                    // 20   <nfTaxaDi>5.088</nfTaxaDi>                              Ex: 5.088
                                                        { "NFDATAREGISTRODI", "", "" },;            // 21   <nfDataRegistroDi>2021-10-07T00:00:00Z                  Ex: 2021-10-07T00:00:00Z
                                                        { "NFDATADESEMBARACO", "", "" },;           // 22   <nfDataDesembaraco>2021-10-07T00:00:00Z                 Ex: 2021-10-07T00:00:00Z
                                                        { "NFDICODURFENTRADA", "", "" },;           // 23   <nfDiCodUrfEntrada>0817800</nfDiCodUrfEntrada>          Ex: 0817800
                                                        { "NFDICODURFDESPACHO", "", "" },;          // 24   <nfDiCodUrfDespacho>0817800</nfDiCodUrfDespacho>        Ex: 0817800
                                                        { "NFEMBARQUE", "", "" },;                  // 25   <nfEmbarque>02-0016</nfEmbarque>                        Ex: 02-0016
                                                        { "NFEMBARQUEANO", "", "" },;               // 26   <nfEmbarqueAno>2021</nfEmbarqueAno>                     Ex: 2021
                                                        { "NFDILOCALURFDESPACHO", "", "" },;        // 27   <nfDiLocalUrfDespacho>PORTO DE SANTOS                   Ex: PORTO DE SANTOS
                                                        { "NFDICODIBGEURFDESPACHO", "", "" },;      // 28   <nfDiCodIbgeUrfDespacho>3548500                         Ex: 3548500
                                                        { "NFDIUFURFDESPACHO", "", "" },;           // 29   <nfDiUfUrfDespacho>SP</nfDiUfUrfDespacho>               Ex: SP
                                                        { "NFDICODIBGEIMPORTADOR", "", "" },;       // 30   <nfDiCodIbgeImportador>3503901</nfDiCodIbgeImportador>  Ex: 3503901
                                                        { "NFMOEDA", "", "" } }                     // 31   <nfMoeda>USD</nfMoeda>                                  Ex: USD
                                                ElseIf _w0 == 2 // Itens
                                                    aFlds := { { "NFITENUMITE", "", "" },;          // 01   <nfIteNumite>1</nfIteNumite>                            Ex: 1
                                                        { "NFITECODPROD", "", "" },;                // 02   nfIteCodprod>N3056</nfIteCodprod>                       Ex: SFT1305
                                                        { "NFITEPEDIDO", "", "" },;                 // 03   <nfItePedido>0102.058178</nfItePedido>                  Ex: 0102.058178
                                                        { "NFITEITEMPED", "", "" },;                // 04   <nfIteItemPed>1</nfIteItemPed>                          Ex: 1
                                                        { "NFITECLAFIS", "", "" },;                 // 05   <nfIteClafis>39191020</nfIteClafis>                     Ex: 39191020
                                                        { "NFITEUNIDA", "", "" },;                  // 06   <nfIteUnida>UN</nfIteUnida>                             Ex: UN
                                                        { "NFITEQTDE", "", "" },;                   // 07   <nfIteQtde>10000</nfIteQtde>                            Ex: 115200
                                                        { "NFITEPRUNIT", "", "" },;                 // 08   <nfItePrunit>91.71843</nfItePrunit>                     Ex: 0.4002175267
                                                        { "NFITEIACODEXTERNOCFOP", "", "" },;       // 09   <nfIteIaCodExternoCfop>                                 Ex: 444 - IMPORTACAO REVENDA 
                                                        { "NFITEBASEICMS", "", "" },;               // 10   <nfIteBaseicms>1400147.02</nfIteBaseicms>               Ex: 71388.68
                                                        { "NFITEPERICMS", "", "" },;                // 11   <nfItePericms>18</nfItePericms>                         Ex: 18
                                                        { "NFITEVRICMS", "", "" },;                 // 12   <nfIteVricms>252026.4636</nfIteVricms>                  Ex: 71388.68
                                                        { "NFITEBASEIPI", "", "" },;                // 13   <nfIteBaseipi>917184.25</nfIteBaseipi>                  Ex: 46105.06
                                                        { "NFITEPERIPI", "", "" },;                 // 14   <nfItePeripi>15</nfItePeripi>                           Ex: 15
                                                        { "NFITEVRIPI", "", "" },;                  // 15   <nfIteVripi>137577.63792</nfIteVripi>                   Ex: 6915.7588613
                                                        { "NFITEBASEPIS", "", "" },;                // 16   <nfIteBasepis>39745.74</nfIteBasepis>                   Ex: 39745.74
                                                        { "NFITEALIQPIS", "", "" },;                // 17   <nfIteAliqPis>2.1</nfIteAliqPis>                        Ex: 2.1
                                                        { "NFITEVRPIS", "", "" },;                  // 18   <nfIteVrpis>16604.19768</nfIteVrpis>                    Ex: 834.660552231091828118
                                                        { "NFITEBASECOFINS", "", "" },;             // 19   <nfIteBasecofins>39745.74</nfIteBasecofins>             Ex: 39745.74
                                                        { "NFITEALIQCOFINS", "", "" },;             // 20   <nfIteAliqCofins>9.65</nfIteAliqCofins>                 Ex: 9.65
                                                        { "NFITEVRCOFINS", "", "" },;               // 21   <nfIteVrcofins>76300.24172</nfIteVrcofins>              Ex: 3835.46396620477911492
                                                        { "NFITEBASEII", "", "" },;                 // 22   <nfIteBaseIi>790676.08</nfIteBaseIi>                    Ex: 39745.7405824329441961387670357593612235
                                                        { "NFITEALIQII", "", "" },;                 // 23   <nfIteAliqIi>16</nfIteAliqIi>                           Ex: 16
                                                        { "NFITEVRII", "", "" },;                   // 24   <nfIteVrii>126508.1728</nfIteVrii>                      Ex: 6359.31849318927107138
                                                        { "NFITEVLFRETERATEADO", "", "" },;         // 25   nfIteVlFreteRateado>5232.8</nfIteVlFreteRateado>        Ex: 3734.72221
                                                        { "NFITEVLSEGURORATEADO", "", ""},;         // 26   <nfIteVlSeguroRateado>10.6885975</nfIteVlSeguroRateado> Ex: 10.6885975
                                                        { "NFITEVRDESPESA", "", "" },;              // 27   <nfIteVrdespesa>861.192074</nfIteVrdespesa>             Ex: 861.192074
                                                        { "NFITEEMPRESA", "", "" },;                // 28   <nfIteEmpresa>0102</nfIteOrganizacao>                   Ex: 0102
                                                        { "NFITEPESOLI", "", "" },;                 // 29   <nfItePesoLi>2304</nfItePesoLi>                         Ex: 2304
                                                        { "NFITEOBSERVACAO", "", "" },;             // 30   <nfIteObservacao>                                       Ex: Pedido NÂº0102.058178 ObservaÃ§Ã£o NF do Import SYS :...
                                                        { "NFITECFOPINTERFACE", "", "" },;          // 31   <nfIteCfopInterface>045</nfIteCfopInterface>            Ex: 045
                                                        { "NFITENMADICAO", "", "" },;               // 32   <nfIteNmAdicao>1</nfIteNmAdicao>                        Ex: 1
                                                        { "NFITEINFCODEXTERNOCFOP", "", "" } }      // 33   <nfIteInfCodExternoCfop>425- IMPORTACAO OUTRAS EM       Ex: 425- IMPORTACAO OUTRAS EM
                                                ElseIf _w0 == 3 // Volumes
                                                    aFlds := { { "NFVOLPESOBRUTOVOLUME", "", "" },; // 01   <nfVolPesoBrutoVolume>15932.325</nfVolPesoBrutoVolume>  Ex: 15932.325
                                                        { "NFVOLPESOLIQUIDOVOLUME", "", "" },;      // 02   <nfVolPesoLiquidoVolume>15030</nfVolPesoLiquidoVolume>  Ex: 15030
                                                        { "NFVOLNFEMBQTDE", "", "" },;              // 03   <nfVolNfEmbQtde>1</nfVolNfEmbQtde>                      Ex: 1
                                                        { "NFVOLESPECIEVOLUME", "", "" } }          // 04   <nfVolEspecieVolume>BAU DE METAL</nfVolEspecieVolume>   Ex: BAU DE METAL
                                                EndIf
                                                For _w4 := 1 To XMLChildCount(oXml2)
                                                    cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                    If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                        aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                    EndIf
                                                Next
                                                aDadosItens := {}
                                                aDadosVolum := {}
                                                For _w4 := 1 To Len( aFlds )
                                                    If _w0 == 1 // Cabecalho
                                                        aAdd(aDados[01], { aFlds[_w4,01], aFlds[_w4,02] })
                                                    ElseIf _w0 == 2 // Gravacao dos Itens
                                                        aAdd(aDadosItens, { aFlds[_w4,01], aFlds[_w4,02] })
                                                    ElseIf _w0 == 3 // Volumes
                                                        aAdd(aDadosVolum, { aFlds[_w4,01], aFlds[_w4,02] })
                                                    EndIf
                                                Next
                                                If _w0 == 2 // Itens
                                                    aAdd(aDados[_w0], aClone(aDadosItens) )
                                                ElseIf _w0 == 3 // Volumes
                                                    aDados[_w0] := aClone(aDadosVolum)
                                                    If Len(aDados[_w0]) >= 3 // Dados dos volumes carregados... conversao de descricoes (Thomson x Totvs)
                                                        aEspecies := {} // Tratamento para reduzir a Descricao Especia do Thomson para o F1_ESPECIE do Totvs (conforme tabela Cleber)
                                                        //              {  COD, DESCRICAO COPLETA,                  DESCRICAO CURTA     }
                                                        aAdd(aEspecies, {  "1", "AMARRADO/ATADO/FEIXE",             "AMARRADO"          })
                                                        aAdd(aEspecies, {  "2", "BARRICA DE FERRO",                 "BARRICA"           })
                                                        aAdd(aEspecies, {  "3", "BARRICA DE FIBRA DE VIDRO",	    "BARRICA"           })
                                                        aAdd(aEspecies, {  "4", "BARRICA DE PAPELAO",               "BARRICA"           })
                                                        aAdd(aEspecies, {  "5", "BARRICA DE PLASTICO",	            "BARRICA"           })
                                                        aAdd(aEspecies, {  "6", "BARRICA DE OUTROS MATERIAIS",	    "BARRICA"           })
                                                        aAdd(aEspecies, {  "7", "BAU DE MADEIRA",	                "BAU MADEIRA"       })
                                                        aAdd(aEspecies, {  "8", "BAU DE METAL",	                    "BAU METAL"         })
                                                        aAdd(aEspecies, {  "9", "BAU DE OUTROS MATERIAIS",	        "BAU OUTROS"        })
                                                        aAdd(aEspecies, { "10", "BIG BAG",	                        "BIG BAG"           })
                                                        aAdd(aEspecies, { "11", "BLOCO",	                        "BLOCO"             })
                                                        aAdd(aEspecies, { "12", "BOBINA",	                        "BOBINA"            })
                                                        aAdd(aEspecies, { "13", "BOMBONA",	                        "BOMBONA"           })
                                                        aAdd(aEspecies, { "14", "BOTIJAO",	                        "BOTIJAO"           })
                                                        aAdd(aEspecies, { "15", "CAIXA CORRUGADA",	                "CX CORRUGADA"      })
                                                        aAdd(aEspecies, { "16", "CAIXA DE ISOPOR",	                "CX ISOPOR"         })
                                                        aAdd(aEspecies, { "17", "CAIXA DE MADEIRA",	                "CX MADEIRA"        })
                                                        aAdd(aEspecies, { "18", "CAIXA DE METAL",	                "CX METAL"          })
                                                        aAdd(aEspecies, { "19", "CAIXA DE PAPELAO",	                "CX PAPELAO"        })
                                                        aAdd(aEspecies, { "20", "CAIXA DE PLASTICO",	            "CX PLASTICO"       })
                                                        aAdd(aEspecies, { "21", "CAIXA DE OUTROS MATERIAIS",	    "CX"                })
                                                        aAdd(aEspecies, { "22",	"CANUDO",	                        "CANUDO"            })
                                                        aAdd(aEspecies, { "23",	"CARRETEL",	                        "CARRETEL"          })
                                                        aAdd(aEspecies, { "24",	"CILINDRO",	                        "CILINDRO"          })
                                                        aAdd(aEspecies, { "25",	"CINTADO",	                        "CINTADO"           })
                                                        aAdd(aEspecies, { "26",	"ENGRADADO DE MADEIRA",	            "ENGRADADO"         })
                                                        aAdd(aEspecies, { "27",	"ENGRADADO DE PLASTICO",	        "ENGRADADO"         })
                                                        aAdd(aEspecies, { "28",	"ENGRADADO DE OUTROS MATERIAIS",    "ENGRADADO"         })
                                                        aAdd(aEspecies, { "29",	"ENVELOPE",                         "ENVELOPE"          })
                                                        aAdd(aEspecies, { "30",	"ESTOJO",                           "ESTOJO"            })
                                                        aAdd(aEspecies, { "31",	"ESTRADO",                          "ESTRADO"           })
                                                        aAdd(aEspecies, { "32",	"FARDO",                            "FARDO"             })
                                                        aAdd(aEspecies, { "33",	"FRASCO",                           "FRASCO"            })
                                                        aAdd(aEspecies, { "34",	"GALAO DE METAL",                   "GALAO METAL"       })
                                                        aAdd(aEspecies, { "35",	"GALAO DE PLASTICO",                "GALAO PLASTICO"    })
                                                        aAdd(aEspecies, { "36",	"GALAO DE OUTROS MATERIAIS",        "GALAO"             })
                                                        aAdd(aEspecies, { "37",	"GRANEL",                           "GRANEL"            })
                                                        aAdd(aEspecies, { "38",	"LATA",                             "LATA"              })
                                                        aAdd(aEspecies, { "39",	"MALA",                             "MALA"              })
                                                        aAdd(aEspecies, { "40",	"MALETA",                           "MALETA"            })
                                                        aAdd(aEspecies, { "41",	"PACOTE",                           "PACOTE"            })
                                                        aAdd(aEspecies, { "42",	"PECA",                             "PECA"              })
                                                        aAdd(aEspecies, { "43",	"QUARTOLA",                         "QUARTOLA"          })
                                                        aAdd(aEspecies, { "44",	"ROLO",                             "ROLO"              })
                                                        aAdd(aEspecies, { "45",	"SACA",                             "SACA"              })
                                                        aAdd(aEspecies, { "46",	"SACO DE ANIAGEM",                  "SACO ANIAGEM"      })
                                                        aAdd(aEspecies, { "47",	"SACO DE COURO",                    "SACO COURO"        })
                                                        aAdd(aEspecies, { "48",	"SACO DE LONA",                     "SACO LONA"         })
                                                        aAdd(aEspecies, { "49",	"SACO DE NYLON",                    "SACO NYLON"        })
                                                        aAdd(aEspecies, { "50",	"SACO DE PAPEL",                    "SACO PAPEL"        })
                                                        aAdd(aEspecies, { "51",	"SACO DE PAPELAO",                  "SACO PAPELAO"      })
                                                        aAdd(aEspecies, { "52",	"SACO DE PLASTICO",                 "SACO PLASTICO"     })
                                                        aAdd(aEspecies, { "53",	"SACO DE OUTROS MATERIAIS",         "SACO"              })
                                                        aAdd(aEspecies, { "54",	"SACOLA",                           "SACOLA"            })
                                                        aAdd(aEspecies, { "55",	"SAN BAG",                          "SAN BAG"           })
                                                        aAdd(aEspecies, { "56",	"TAMBOR DE METAL",                  "TAMBOR METAL"      })
                                                        aAdd(aEspecies, { "57",	"TAMBOR DE PAPELAO",                "TAMBOR PAPELAO"    })
                                                        aAdd(aEspecies, { "58",	"TAMBOR DE PLASTICO",               "TAMBOR PLASTICO"   })
                                                        aAdd(aEspecies, { "59",	"TAMBOR DE OUTROS MATERIAIS",       "TAMBOR"            })
                                                        aAdd(aEspecies, { "60",	"PALLETS",                          "PALLETS"           })
                                                        aAdd(aEspecies, { "99", "OUTROS",                           "OUTROS"            })
                                                        If (nFnd := ASCan(aEspecies, {|x|, x[02] == AllTrim(Upper(aDados[_w0,04,02])) })) > 0 // Se a Especie do Thomson estiver na tabela...
                                                            aDados[_w0,04,02] := aEspecies[nFnd,03] // Atualizo para a Especie Curta (limitacao do D1_ESPECIE)
                                                        EndIf
                                                    EndIf
                                                EndIf
                                            EndIf
                                        EndIf
                                        // ############## NOTA FISCAL ENTRADA #################
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
                                    If aRet[01] // .T.=Ja concluido
                                        _w1 := Len(aXml) + 1
                                    EndIf
                                    Exit
                                EndIf
                                _w2++
                            End
                            _w1++
                        End
                    Next
                    // Parte 02: Validacoes dos dados carregados
                    If Len(aDados[01]) > 0 // Cabecalho carregado
                        DbSelectArea("SA4")
                        SA4->(DbSetOrder(3)) // A4_FILIAL + A4_CGC
                        DbSelectArea("SA2")
                        SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA

                        DbSelectArea("SA5")
                        SA5->(DbSetOrder(1)) // A5_FILIAL + A5_FORNECE + A5_LOJA + A5_PRODUTO + ...

                        DbSelectArea("SB1")
                        SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
                        DbSelectArea("SC7")
                        SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM + C7_ITEM
                        DbSelectArea("CT1")
                        CT1->(DbSetOrder(1)) // CT1_FILIAL + CT1_CONTA
                        DbSelectArea("CTT")
                        CTT->(DbSetOrder(1)) // CTT_FILIAL + CTT_CUSTO
                        DbSelectArea("SW2")
                        SW2->(DbSetOrder(1)) // W2_FILIAL + W2_PO_NUM
                        DbSelectArea("SY6")
                        SY6->(DbSetOrder(1)) // Y6_FILIAL + Y6_COD + Str(Y6_DIAS_PA,3,0)
                        DbSelectArea("SE4")
                        SE4->(DbSetOrder(1)) // E4_FILIAL + E4_CODIGO
                        DbSelectArea("SF4")
                        SF4->(DbSetOrder(1)) // F4_FILIAL + F4_CODIGO

                        If SA2->(DbSeek( _cFilSA2 + SubStr( aDados[01,05,02],4,8) )) // Codigo do Fornecedor + Loja         // Cod/Forn: Errado: "063274" "01" -> ""
                            If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                                If SA4->(DbSeek( _cFilSA4 + aDados[ 01, 13, 02 ] )) // CNPJ da Transportadora
                                    If Len(aDados[02]) > 0 // Itens carregados
                                        If Len(aDados[03]) > 0 // Volumes carregados
                                            If aDados[01,01,02] == cEmpAnt + cFilAnt // Empresa/Filial conforme

                                                lFilhote := Left(aDados[02,01,33,02],3) == "425" .And. MsgYesNo("Confirma processamento Nota Filhote?","WsRc3703") // TES "425" confirma se eh filhote
                                                

                                                For _w1 := 1 To Len( aDados[02] )
                                                    If SB1->(DbSeek( _cFilSB1 + aDados[02,_w1,02,02] )) // Produto encontrado
                                                        If SB1->B1_MSBLQL <> "1" // Produto nao bloqueado
                                                            If SB1->B1_UM == aDados[02,_w1,06,02] // Unidade de Medida conforme
                                                                If RTrim(SB1->B1_POSIPI) == aDados[02,_w1,05,02] // NCM conforme                                        
                                                                    If !Empty(aDados[02,_w1,03,02]) // Pedido de Compra

                                                                        _cQuery1 := " SELECT C7.R_E_C_N_O_ RECSC7
                                                                        _cQuery1 += " FROM "+RetSqlName("SC7")+" C7
                                                                        _cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+_cFilSC7+"' AND 
                                                                        _cQuery1 += " C7_PO_EIC='"+SubStr(aDados[02,_w1,03,02],6,6)+"' AND
                                                                        _cQuery1 += " C7_ITEM='"+PadL(aDados[02,_w1,04,02],4,"0")+"'

                                                                        If !Empty(Select(_cAlias1))
                                                                            DbSelectArea(_cAlias1)
                                                                            (_cAlias1)->(dbCloseArea())
                                                                        Endif

                                                                        dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

                                                                        dbSelectArea(_cAlias1)
                                                                        (_cAlias1)->(dbGoTop())

                                                                        _nRecSC7 := (_cAlias1)->RECSC7

                                                                        SC7->(DbGoTo(_nRecSC7))

                                                                        //If SC7->(DbSeek( _cFilSC7 + SubStr(aDados[02,_w1,03,02],6,6) + PadL(aDados[02,_w1,04,02],4,"0") ))
                                                                        If SC7->(!Eof())
                                                                            If SW2->(DbSeek( _cFilSW2 + SC7->C7_PO_EIC )) // Pedido Importacao
                                                                                If SY6->(DbSeek( _cFilSY6 + SW2->W2_COND_PA )) // Cond Pgto EIC
                                                                                    If !Empty(SY6->Y6_SIGSE4) // Tem condicao SE4
                                                                                        If SE4->(DbSeek( _cFilSE4 + SY6->Y6_SIGSE4 ))
                                                                                            If lFilhote .Or. SC7->C7_RESIDUO <> "S" // Pedido nao teve elim residuo
                                                                                                If SC7->C7_FORNECE + SC7->C7_LOJA == SA2->A2_COD + SA2->A2_LOJA // Fornecedor confere
                                                                                                    If SC7->C7_PRODUTO == SB1->B1_COD // Produto confere com pedido/item
                                                                                                        If SC7->C7_QUANT >= Val(aDados[02,_w1,07,02]) // Quantidade conforme
                                                                                                            If lFilhote .Or. SC7->C7_QUANT - SC7->C7_QUJE >= Val(aDados[02,_w1,07,02]) // Quantidade conforme
                                                                                                                If lFilhote .Or. SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA >= Val(aDados[02,_w1,07,02]) // Quantiade conforme (nao classificada)
                                                                                                                    If CT1->(DbSeek( _cFilCT1 + SC7->C7_CONTA )) // Conta Contabil
                                                                                                                        If CTT->(DbSeek( _cFilCTT + SC7->C7_CC )) // Centro de Custo
                                                                                                                            If CTT->CTT_CLASSE == "2" // "2"=Analitico
                                                                                                                                If CTT->CTT_BLOQ == "2" // "2"=Nao Bloqueado
                                                                                                                                    If lPreNota .Or. SF4->(DbSeek( _cFilSF4 + Left(aDados[02,_w1,31,02],3) )) // Tipo de Entrada e Saida
                                                                                                                                        If lPreNota .Or. SF4->F4_MSBLQL <> "1" // Nao bloqueada
                                                                                                                                            If lPreNota .Or. SF4->F4_DUPLIC == "N" // Nao pode gerar duplicata (duplica)
                                                                                                                                                aAdd(aRecnos[01,02], SA2->(Recno()) )
                                                                                                                                                aAdd(aRecnos[02,02], SA4->(Recno()) )
                                                                                                                                                aAdd(aRecnos[03,02], SB1->(Recno()) )
                                                                                                                                                aAdd(aRecnos[04,02], SC7->(Recno()) )
                                                                                                                                                aAdd(aRecnos[05,02], CT1->(Recno()) )
                                                                                                                                                aAdd(aRecnos[06,02], CTT->(Recno()) )
                                                                                                                                                aAdd(aRecnos[07,02], SW2->(Recno()) )
                                                                                                                                                aAdd(aRecnos[08,02], SY6->(Recno()) )
                                                                                                                                                aAdd(aRecnos[09,02], SE4->(Recno()) )
                                                                                                                                                aAdd(aRecnos[10,02], Iif( lPreNota, 0, SF4->(Recno()) ))
                                                                                                                                            Else // TES gera duplicada (nao permitir senao duplica) (SF4)
                                                                                                                                                cMsg01 := "TES gera duplicata (SF4)!"
                                                                                                                                                cMsg02 := "A TES de importacao nao deve gerar duplicatas!"
                                                                                                                                                cMsg03 := "A geracao sera feita via Thomson posteriormente!"
                                                                                                                                            EndIf
                                                                                                                                        Else // TES esta bloqueada no cadastro (SF4)
                                                                                                                                            cMsg01 := "TES esta bloqueada no cadastro (SF4)!"
                                                                                                                                            cMsg02 := "Codigo TES: " + Left(aDados[02,_w1,09,02],3)
                                                                                                                                        EndIf
                                                                                                                                    Else // TES nao encontrada no cadastro (SF4)
                                                                                                                                        cMsg01 := "TES nao encontrada no cadastro (SF4)!"
                                                                                                                                        cMsg02 := "Codigo TES: " + Left(aDados[02,_w1,09,02],3)
                                                                                                                                        cMsg93 := "A TES enviada pelo Thomson nao existe no cadastro!"
                                                                                                                                    EndIf
                                                                                                                                Else // Centro de Custo Bloqueado (CTT)
                                                                                                                                    cMsg01 := "Centro de Custo esta bloqueado (CTT)!"
                                                                                                                                    cMsg02 := "CCusto: " + SC7->C7_CC
                                                                                                                                    cMsg03 := "Verifique o centro de custo do pedido de compra e tente novamente!"
                                                                                                                                    cMsg04 := "Pedido Compra/Item: " + SC7->C7_NUM + "/" + SC7->C7_ITEM
                                                                                                                                EndIf
                                                                                                                            Else // Centro de Custo Sintetico (CTT)
                                                                                                                                cMsg01 := "Centro de Custo nao pode ser sintetico (CTT)!"
                                                                                                                                cMsg02 := "CCusto: " + SC7->C7_CC
                                                                                                                                cMsg03 := "Verifique o centro de custo do pedido de compra e tente novamente!"
                                                                                                                                cMsg04 := "Pedido Compra/Item: " + SC7->C7_NUM + "/" + SC7->C7_ITEM
                                                                                                                            EndIf
                                                                                                                        Else // Centro de Custo nao encontrado (CTT)
                                                                                                                            cMsg01 := "Centro de Custo nao encontrado no cadastro (CTT)!"
                                                                                                                            cMsg02 := "CCusto: " + SC7->C7_CC
                                                                                                                            cMsg03 := "Verifique o pedido de compra e tente novamente!"
                                                                                                                            cMsg04 := "Pedido Compra/Item: " + SC7->C7_NUM + "/" + SC7->C7_ITEM
                                                                                                                        EndIf
                                                                                                                    Else // Conta Contabil nao encontrada (CT1)
                                                                                                                        cMsg01 := "Conta Contabil nao encontrada no cadastro (CT1)!"
                                                                                                                        cMsg02 := "Conta Contabil: " + SC7->C7_CONTA
                                                                                                                        cMsg03 := "Verifique o pedido de compra e tente novamente!"
                                                                                                                    EndIf
                                                                                                                Else // Quantidade pendente de atendimento insuficiente (SC7) devido a pre-nota
                                                                                                                    cMsg01 := "Quantidade pendente ainda nao classificada insuf no Pedido/Item de Compra (SC7)!"
                                                                                                                    cMsg02 := "Pedido/Item: " + SubStr(aDados[02,_w1,03,02],6,6) + "/" + PadL(aDados[02,_w1,04,02],4,"0")
                                                                                                                    cMsg03 := "Qtde Xml: " + aDados[02,_w1,07,02]
                                                                                                                    cMsg04 := "Qtde pendente Pedido/Item: " + cValToChar(SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA)
                                                                                                                EndIf
                                                                                                            Else // Quantidade pendente de atendimento insuficiente (SC7)
                                                                                                                cMsg01 := "Quantidade pendente de atendimento insuficiente no Pedido/Item de Compra (SC7)!"
                                                                                                                cMsg02 := "Pedido/Item: " + SubStr(aDados[02,_w1,03,02],6,6) + "/" + PadL(aDados[02,_w1,04,02],4,"0")
                                                                                                                cMsg03 := "Qtde Xml: " + aDados[02,_w1,07,02]
                                                                                                                cMsg04 := "Qtde pendente Pedido/Item: " + cValToChar(SC7->C7_QUANT - SC7->C7_QUJE)
                                                                                                            EndIf
                                                                                                        Else // Quantidade insuficiente no pedido (SC7)
                                                                                                            cMsg01 := "Quantidade insuficiente no Pedido/Item de Compra (SC7)!"
                                                                                                            cMsg02 := "Pedido/Item: " + SubStr(aDados[02,_w1,03,02],6,6) + "/" + PadL(aDados[02,_w1,04,02],4,"0")
                                                                                                            cMsg03 := "Qtde Xml: " + aDados[02,_w1,07,02]
                                                                                                            cMsg04 := "Qtde Pedido/Item: " + cValToChar(SC7->C7_QUANT)
                                                                                                        EndIf
                                                                                                    Else // Produto nao confere com pedido/item (SB1 x SC7)
                                                                                                        cMsg01 := "Produto do pedido nao confere com Xml!"
                                                                                                        cMsg02 := "Produto Xml: " + SB1->B1_COD
                                                                                                        cMsg03 := "Produto Pedido/Item: " + SC7->C7_PRODUTO
                                                                                                    EndIf
                                                                                                Else // Fornecedor/Loja Xml nao confere com Fornecedor/Loja do Pedido de Compra (SA2 x SC7)
                                                                                                    cMsg01 := "Fornecedor/Loja do pedido nao confere com Xml!"
                                                                                                    cMsg02 := "Fornecedor/Loja Xml: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                                                                    cMsg03 := "Fornecedor/Loja Pedido: " + SC7->C7_FORNECE + "/" + SC7->C7_LOJA
                                                                                                EndIf
                                                                                            Else // Pedido teve elim residuo (SC7)
                                                                                                cMsg01 := "Pedido ja teve eliminacao de residuo (SC7)!"
                                                                                                cMsg02 := "Pedido: " + SC7->C7_NUM
                                                                                                cMsg03 := "Verifique o pedido de compra e tente novamente!" 
                                                                                            EndIf
                                                                                        Else // Cond Pgto nao encontrada no cadastro (SE4)
                                                                                            cMsg01 := "Condicao de Pagamento nao encontrada no cadastro (SE4)!"
                                                                                            cMsg02 := "Cond Pgto: " + SY6->Y6_SIGSE4
                                                                                            cMsg03 := "Verifique o cadastro da condicao de pagamento!"
                                                                                        EndIf
                                                                                    Else // Condicao Pgto SE4 nao preenchida
                                                                                        cMsg01 := "Condicao de Pagamento nao tem referencia SE4 (SY6)!"
                                                                                        cMsg02 := "Cond Pgto: " + SY6->Y6_COD
                                                                                        cMsg03 := "Verifique o cadastro da condicao de pagamento no SigaEIC!"
                                                                                    EndIf
                                                                                Else // Condicao de Pagamento EIC nao encontrada (SY6)
                                                                                    cMsg01 := "Condicao de Pagamento nao encontrada no cadastro (SY6)!"
                                                                                    cMsg02 := "Cond Pgto: " + SW2->W2_COND_PA
                                                                                    cMsg03 := "Verifique o cadastro da condicao de pagamento no SigaEIC!"
                                                                                EndIf
                                                                            Else // Pedido de Importacao nao encontrado (SW2)
                                                                                cMsg01 := "Pedido de Importacao nao encontrado no cadastro (SW2)!"
                                                                                cMsg02 := "Pedido de Importacao: " + SC7->C7_NUM
                                                                            EndIf
                                                                        Else // Pedido/Item de Compra nao encontrado no cadastro (SC7)
                                                                            cMsg01 := "Pedido/Item de Compra nao encontrado no cadastro (SC7)!"
                                                                            cMsg02 := "Pedido/Item: " + SubStr(aDados[02,_w1,03,02],6,6) + "/" + PadL(aDados[02,_w1,04,02],4,"0")
                                                                        EndIf
                                                                    Else // Nao tem pedido de compra
                                                                        cMsg01 := "Pedido de compra da nota nao existe! (SC7)"
                                                                        cMsg02 := "Verifique o pedido de compra e tente novamente!"
                                                                    EndIf
                                                                Else // NCM nao conforme (SB1)
                                                                    cMsg01 := "NCM nao conforme!"
                                                                    cMsg02 := "Item/Produto: " + aDados[02,_w1,01,02] + "/" + aDados[02,_w1,02,02]
                                                                EndIf
                                                            Else // Unidade de Medida nao conforme (SB1)
                                                                cMsg01 := "Unidade de Medida nao conforme!"
                                                                cMsg02 := "Item/Produto: " + aDados[02,_w1,01,02] + "/" + aDados[02,_w1,02,02]
                                                            EndIf
                                                        Else // Produto bloqueado no cadastro (SB1)
                                                            cMsg01 := "Produto esta bloqueado no cadastro (SB1)!"
                                                            cMsg02 := "Produto: " + SB1->B1_COD
                                                        EndIf
                                                    Else // Produto nao encontrado no cadastro (SB1)
                                                        cMsg01 := "Produto nao encontrado no cadastro (SB1)!"
                                                        cMsg02 := "Item/Produto: " + aDados[02,_w1,01,02] + "/" + aDados[02,_w1,02,02]
                                                    EndIf
                                                    If !Empty(cMsg01) // Mensagem de erro
                                                        Exit
                                                    EndIf
                                                Next
                                            EndIf // Empresa/Filial nao conforme
                                        Else // Volumes nao foram localizados no XML
                                            cMsg01 := "Volumes nao foram localizados no XML (Thomson)!"
                                            cMsg02 := "Verifique no XML os dados dos volumes e tente novamente!"
                                        EndIf
                                    EndIf // Itens carregados na matriz
                                Else // Transportadora nao encontrada (SA4)
                                    cMsg01 := "Transportadora nao encontrada no cadastro (SA4)!"
                                    cMsg02 := "CNPJ: " + aDados[01,13,02]
                                EndIf
                            Else // Fornecedor esta bloqueado no cadastro (SA2)
                                cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        Else // Fornecedor nao encontrado no cadastro (SA2)
                            cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                            cMsg02 := "Cod + Loja: " + SubStr(aDados[01,05,02],4,8)
                        EndIf
                    EndIf
                    If Empty( cMsg01 ) // Nenhum mensagem de erro carregada
                        If Len(aRecnos[01,02]) > 0 .And. Len(aRecnos[01,02]) == Len(aDados[02]) // Todos os recnos carregados com sucesso
                            cObsIte := ""
                            For _w1 := 1 To Len(aRecnos[01,02]) // Rodo nos recnos
                                For _w2 := 1 To Len( aRecnos )
                                    cTab := aRecnos[_w2,01]                     // Tabela posicionamento
                                    (cTab)->(DbGoto( aRecnos[_w2,02,_w1] ))     // Recno posicionamento
                                Next
                                If _w1 == 1 // Primeiro item, carrego cabecalho
                                    cNum := NxtSX5Nota("001") // GetSxeNum("SF1","F1_DOC")
                                    // Cabecalho
                                    aAdd(aCabec, { "F1_TIPO",       "N",                                                                                                                Nil })
                                    aAdd(aCabec, { "F1_FORMUL",     "S",                                                                                                                Nil }) // Formulario Proprio: Sim
                                    aAdd(aCabec, { "F1_EMISSAO",    StoD(StrTran(Left(aDados[01,04,02],10),"-","")),                                                                    Nil })
                                    aAdd(aCabec, { "F1_DESPESA",    Val(aDados[01,10,02]),                                                                                              Nil }) // Valor Despesas
                                    aAdd(aCabec, { "F1_DTDIGIT",    dDatabase,                                                                                                          Nil })
                                    aAdd(aCabec, { "F1_FORNECE",    SA2->A2_COD,                                                                                                        Nil })
                                    aAdd(aCabec, { "F1_LOJA",       SA2->A2_LOJA,                                                                                                       Nil })
                                    aAdd(aCabec, { "F1_ESPECIE",    "SPED",                                                                                                             Nil })
                                    aAdd(aCabec, { "F1_COND",       SE4->E4_CODIGO,                                                                                                     Nil })
                                    aAdd(aCabec, { "F1_MOEDA",      1,                                                                                                                  Nil })
                                    aAdd(aCabec, { "F1_TXMOEDA",    1,                                                                                                                  Nil })
                                    aAdd(aCabec, { "F1_STATUS",     "A",                                                                                                                Nil })
                                    aAdd(aCabec, { "F1_DOC",        cNum,                                                                                                               Nil })
                                    aAdd(aCabec, { "F1_SERIE",      "001",                                                                                                              Nil })
                                    // Veiculo/Transportadora/Volumes
                                    aAdd(aCabec, { "F1_PLACA",      "ABC1234",                                                                                                          Nil })  // Fixa "ABC1234"
                                    aAdd(aCabec, { "F1_TRANSP",     SA4->A4_COD,                                                                                                        Nil })  // Codigo da Transportadora
                                    aAdd(aCabec, { "F1_ESPECI1",    aDados[03,04,02],                                                                                                   Nil })  // "BAU METAL"
                                    // Pesos/Volumes
                                    aAdd(aCabec, { "F1_PBRUTO",     Val(aDados[03,01,02]),                                                                                              Nil })  // 15932.325
                                    aAdd(aCabec, { "F1_PLIQUI",     Val(aDados[03,02,02]),                                                                                              Nil })  // 15030
                                    aAdd(aCabec, { "F1_VOLUME1",    Val(aDados[03,03,02]),                                                                                              Nil })  // 1
                                    // Moeda Estrangeira
                                    aAdd(aCabec, { "F1_MOEDA",      Iif(aDados[01,31,02] == "USD", 2, 4),                                                                               Nil })  // Moeda Estrangeira    2=Dolar 4=Euro
                                    aAdd(aCabec, { "F1_TXMOEDA",    Val(aDados[01,20,02]),                                                                                              Nil })  // Taxa DI Moeda Estrangeira
                                EndIf
                                // Itens
                                aItem := {}
                                aAdd(aItem, { "D1_ITEM",        StrZero(_w1,4),                                                                                                         Nil })
                                aAdd(aItem, { "D1_COD",         SB1->B1_COD,                                                                                                            Nil })
                                aAdd(aItem, { "D1_UM",          SB1->B1_UM,                                                                                                             Nil })
                                If !lFilhote
                                    aAdd(aItem, { "D1_PEDIDO",      SC7->C7_NUM,                                                                                                        Nil }) // Pedido de Compra
                                    aAdd(aItem, { "D1_ITEMPC",      SC7->C7_ITEM,                                                                                                       Nil }) // Item do Pedido de Compra
                                EndIf

                                If SA5->(DbSeek( _cFilSA5 + SA2->A2_COD + SA2->A2_LOJA + SB1->B1_COD )) .And. SA5->A5_SITU == "A" .And. SA5->A5_SKPLOT == "28"
                                    aAdd(aItem, { "D1_LOCAL",       "03",                                                                                                               Nil }) // Armazem "03"
                                Else
                                    aAdd(aItem, { "D1_LOCAL",       "98",                                                                                                               Nil }) // Armazem "98"=CQ
                                EndIf

                                aAdd(aItem, { "D1_QUANT",       Val(aDados[02,_w1,07,02]),                                                                                              Nil }) // Quantidade
                                aAdd(aItem, { "D1_VUNIT",       Val(aDados[02,_w1,08,02]),                                                                                              Nil }) // Valor Unitario - Valor do II
                                aAdd(aItem, { "D1_TOTAL",       Val(aDados[02,_w1,07,02]) * Val(aDados[02,_w1,08,02]),                                                                  Nil }) // Valor Total
                                If !lPreNota // .F.=Gerar Nota (MATA103) .T.=Gerar Pre-Nota (MATA140)
                                    aAdd(aItem, { "D1_TES",         SF4->F4_CODIGO,                                                                                                     Nil }) // TES
                                EndIf
                                // ICMS
                                aAdd(aItem, { "D1_BASEICM",     Val(aDados[02,_w1,10,02]),                                                                                              Nil }) // Base ICMS
                                aAdd(aItem, { "D1_PICM",        Val(aDados[02,_w1,11,02]),                                                                                              Nil }) // Aliq ICMS
                                aAdd(aItem, { "D1_VALICM",      Val(aDados[02,_w1,12,02]),                                                                                              Nil }) // Valor ICMS
                                // IPI
                                aAdd(aItem, { "D1_BASEIPI",     Val(aDados[02,_w1,13,02]),                                                                                              Nil }) // Base IPI
                                aAdd(aItem, { "D1_IPI",         Val(aDados[02,_w1,14,02]),                                                                                              Nil }) // Aliq IPI
                                aAdd(aItem, { "D1_VALIPI",      Val(aDados[02,_w1,15,02]),                                                                                              Nil }) // Valor IPI
                                // PIS
                                aAdd(aItem, { "D1_BASIMP6",     Val(aDados[02,_w1,16,02]),                                                                                              Nil }) // Base PIS
                                aAdd(aItem, { "D1_ALQIMP6",     Val(aDados[02,_w1,17,02]),                                                                                              Nil }) // Aliq PIS
                                aAdd(aItem, { "D1_VALIMP6",     Val(aDados[02,_w1,18,02]),                                                                                              Nil }) // Valor PIS
                                // COFINS
                                aAdd(aItem, { "D1_BASIMP5",     Val(aDados[02,_w1,19,02]),                                                                                              Nil }) // Base COFINS
                                aAdd(aItem, { "D1_ALQIMP5",     Val(aDados[02,_w1,20,02]),                                                                                              Nil }) // Aliq COFINS
                                aAdd(aItem, { "D1_VALIMP5",     Val(aDados[02,_w1,21,02]),                                                                                              Nil }) // Valor COFINS
                                // II
                                aAdd(aItem, { "D1_ALIQII",      Val(aDados[02,_w1,23,02]),                                                                                              Nil }) // Aliq II
                                aAdd(aItem, { "D1_II",          Val(aDados[02,_w1,24,02]),                                                                                              Nil }) // Base II
                                // Outros
                                aAdd(aItem, { "D1_RATEIO",  "2",                                                                                                                        Nil }) // Rateio Nao
                                aAdd(aItem, { "D1_PESO",    Val(aDados[02,_w1,29,02]),                                                                                                  Nil }) // Peso Liquido
                                aAdd(aItem, { "D1_CC",      CTT->CTT_CUSTO,                                                                                                             Nil }) // Centro de Custo
                                aAdd(aItem, { "D1_CONTA",   CT1->CT1_CONTA,                                                                                                             Nil }) // Conta Contabil
                                aAdd(aItem, { "D1_TEC",     SB1->B1_POSIPI,                                                                                                             Nil }) // NCM
                                // Observacoes
                                cObsIte += aDados[02,_w1,30,02] + Chr(13) + Chr(10)
                                aAdd(aItens, aClone(aItem))

                                // Alteracao 19/04/2022 (Campo total dos itens no SF1 Cristiano/Thiago para contabilizacao)
                                nTotSD1 += Val(aDados[02,_w1,07,02]) * Val(aDados[02,_w1,08,02])
                            Next
                            
                            aAdd(aCabec, { "F1_DESCONT",    0,                                                                                                                          Nil }) // Valor Desconto
                            aAdd(aCabec, { "F1_MENNOTA",    RTrim(aDados[01,18,02]) + " " + RTrim(aDados[01,21,02]) + " " + RTrim(aDados[01,11,02]),                                    Nil }) // Numero da DI + Data da DI + Observacoes da Nota
                            aAdd(aCabec, { "F1_OBSDES",     aDados[01,11,02] + Chr(13) + Chr(10) + cObsIte,                                                                             Nil }) // Observacoes da Nota (Memo)
                            If lPreNota // .T.=Pre-Nota
                                aAdd(aCabec, { "F1_STATUS",     "",                                                                                                                     Nil })  // Nota a classificar
                            EndIf
                            lMsErroAuto := .F. // MsExecAuto({|x,y,z,a,b|, MATA103(x,y,z) }, aCabec, aItens, nOpc, aItensRat, aCodRet) //3-Inclusão / 4-Classificação / 5-Exclusão
                            If lPreNota // .T.=Gerar Pre-Nota
                                MsExecAuto({|x,y,z,a,b|, MATA140(x,y,z,a,b) }, aCabec, aItens, nOpc,,)  // Pre-Nota de Entrada
                            Else // .F.=Gerar Nota Fiscal de Entrada
                                MsExecAuto({|x,y,z,a,b|, MATA103(x,y,z) }, aCabec, aItens, nOpc)        // Nota de Entrada
                            EndIf
                            If !lMsErroAuto // .F.=Sucesso

                                RecLock("SF1",.F.)
                                SF1->F1_FOB_R := nTotSD1 // Total do SD1_TOTAL para contabilizacao (Cristiano/Thiago 19/04/2022)
                                SF1->(MsUnlock())

                                RecLock("ZTN",.F.)
                                ZTN->ZTN_STATOT := "06"                         // "06"=Nota Gerada com Sucesso!
                                ZTN->ZTN_DETPR1 := Iif(lPreNota, "Pre-Nota", "Nota") + " de Entrada gerada com sucesso!"
                                ZTN->ZTN_DETPR2 := "Emp/Fil/Doc/Serie/Fornecedor/Loja/Tipo: " + cEmpAnt + SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO
                                ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                ZTN->(MsUnlock())
                                lRet := .T.
                                // Gravacoes CD5 (CD5 sera gravado para geracao de Notas de Entrada e tambem Pre-Notas de Entrada)
                                SD1->(DbSetOrder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_TIPO
                                If SD1->(DbSeek( _cFilSD1 + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))
                                    nSeq := 0
                                    While SD1->(!EOF()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == _cFilSD1 + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
                                        If SD1->D1_TIPO == SF1->F1_TIPO // Tipo conforme
                                            nSeq += 1
                                            DbSelectArea("CD5")
                                            CD5->(DbSetOrder(4)) // CD5_FILIAL + CD5_DOC + CD5_SERIE + CD5_FORNEC + CD5_LOJA + CD5_DOCIMP + CD5_NADIC
                                            lLock := CD5->(!DbSeek(_cFilCD5 + SF1->F1_DOC + SF1->F1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM))
                                            If RecLock("CD5",lLock)
                                                CD5->CD5_FILIAL		:= _cFilCD5
                                                CD5->CD5_DOC 		:= SD1->D1_DOC
                                                CD5->CD5_SERIE		:= SD1->D1_SERIE
                                                CD5->CD5_ESPEC		:= SF1->F1_ESPECIE
                                                CD5->CD5_FORNECE    := SD1->D1_FORNECE
                                                CD5->CD5_LOJA		:= SD1->D1_LOJA
                                                CD5->CD5_ITEM		:= SD1->D1_ITEM
                                                CD5->CD5_TPIMP		:= "0"
                                                CD5->CD5_DOCIMP		:= aDados[01,18,02]                                     // Numero da DI                         <nfNumeroDi>2113427060</nfNumeroDi>
                                                // Impostos
                                                CD5->CD5_BSPIS		:= Val(aDados[02,nSeq,16,02]) // SD1->D1_BASIMP6
                                                CD5->CD5_ALPIS		:= Val(aDados[02,nSeq,17,02]) // SD1->D1_ALQIMP6
                                                CD5->CD5_VLPIS		:= Val(aDados[02,nSeq,18,02]) // SD1->D1_VALIMP6
                                                CD5->CD5_BSCOF		:= Val(aDados[02,nSeq,19,02]) // SD1->D1_BASIMP5
                                                CD5->CD5_ALCOF		:= Val(aDados[02,nSeq,20,02]) // SD1->D1_ALQIMP5
                                                CD5->CD5_VLCOF		:= Val(aDados[02,nSeq,21,02]) // SD1->D1_VALIMP5
                                                CD5->CD5_LOCAL 		:= "0"
                                                CD5->CD5_CODFAB		:= SD1->D1_FORNECE
                                                CD5->CD5_LOJFAB		:= SD1->D1_LOJA
                                                CD5->CD5_CODEXP 	:= SD1->D1_FORNECE
                                                CD5->CD5_LOJEXP		:= SD1->D1_LOJA
                                                CD5->CD5_VLRII		:= Val(aDados[02,nSeq,24,02]) // SD1->D1_II
                                                CD5->CD5_BCIMP		:= Val(aDados[02,nSeq,16,02]) // SD1->D1_BASIMP6
                                                // Despesa
                                                CD5->CD5_DSPAD		:= SD1->D1_DESPESA
                                                // DI
                                                CD5->CD5_NDI		:= aDados[01,18,02]                                     // Numero da DI                         <nfNumeroDi>2113427060</nfNumeroDi>
                                                CD5->CD5_LOCDES		:= aDados[01,27,02]                                     // Local de Desembarque                 <nfDiLocalUrfDespacho>PORTO DE SANTOS</nfDiLocalUrfDespacho>
                                                CD5->CD5_UFDES 		:= aDados[01,29,02]                                     // UF de Desembarque                    <nfDiUfUrfDespacho>SP</nfDiUfUrfDespacho>
                                                If !Empty( CD5->CD5_NDI )
                                                    CD5->CD5_NADIC	:= StrZero(Val(aDados[02, nSeq, 32, 02]),3)             // Numero da Adicao                     <nfIteNmAdicao>1</nfIteNmAdicao>
                                                    CD5->CD5_SQADIC	:= StrZero(nSeq,3)                                      // Sequencial da Adicao
                                                Else // Sem DI
                                                    CD5->CD5_NADIC	:= "999"                                                // Numero da Adicao
                                                    CD5->CD5_SQADIC	:= "999"                                                // Sequencial da Adicao
                                                EndIf
                                                CD5->CD5_VTRANS		:= "1"                                                  // Base Steck (Vazio/1)
                                                // DI
                                                CD5->CD5_DTDI		:= StoD(StrTran(Left(aDados[01,21,02],10),"-",""))      // Data da DI (Registro da DI))         <nfDataRegistroDi>2021-10-07T00:00:00Z</nfDataRegistroDi>
                                                CD5->CD5_DTDES		:= StoD(StrTran(Left(aDados[01,22,02],10),"-",""))      // Data do Desembarque/Desembaraco      <nfDataDesembaraco>2021-10-07T00:00:00Z</nfDataDesembaraco>
                                                If Empty( CD5->CD5_DTDES ) // Se nao tem desembarque, data da DI
                                                    CD5->CD5_DTDES := CD5->CD5_DTDI                                         // Data do Desembarque/Desembaraco      Se nao tem, a data sera a mesma da DI
                                                EndIf
                                                CD5->CD5_DTPPIS		:= StoD(StrTran(Left(aDados[01,21,02],10),"-",""))      // IIF(!Empty(SD1->D1_DTDI)             <nfDataRegistroDi>2021-10-07T00:00:00Z</nfDataRegistroDi>
                                                CD5->CD5_DTPCOF		:= StoD(StrTran(Left(aDados[01,21,02],10),"-",""))      // IIF(!Empty(SD1->D1_DTDI)             <nfDataRegistroDi>2021-10-07T00:00:00Z</nfDataRegistroDi>
                                                // Incoterm
                                                CD5->CD5_INTERM		:= "1"
                                                CD5->CD5_CNPJAE		:= SM0->M0_CGC
                                                CD5->CD5_UFTERC		:= "SP"
                                                CD5->(MsUnlock())
                                            EndIf
                                        EndIf
                                        SD1->(DbSkip())
                                    End
                                EndIf
                                MsgInfo("Documento gerado com Sucesso! " + SF1->F1_DOC,"WsRc3703")
                            Else // Erro ExecAuto
                                MostraErro()
                                cMsg01 := "Erro no processamento da nota de entrada (ExecAuto)!"
                                cMsg02 := ""
                                cMsg03 := ""
                                cMsg04 := ""
                                lRet := .F.
                            EndIf
                        EndIf
                    Else // Erro nas validacoes
                        lRet := .F.
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
    ZTN->(DbSkip())
End
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04 }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3707 ºAutor ³Jonathan Schmidt Alves º Data ³12/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno da Nota de Entrada (Import)       I N C L U S A O  º±±
±±º          ³                                                      6002  º±±
±±º          ³ ID Interface no In-Out:                                    º±±
±±º          ³ API: PKG_BS_API_RETORNO_NFPKG_BS_API_RETORNO_NF            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_BS_API_RETORNO_NF"                                 º±±
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
±±º          ³ Envia para o Thomson os dados da entrada processada no     º±±
±±º          ³ Totvs via Pre-Nota (MATA140) ou Doc Entrada (MATA103) a    º±±
±±º          ³ partir do XML baixado no ZTN.                              º±±
±±º          ³ Tabelas Totvs: SA2/SF1/SD1/ZTN                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3707()
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
// Variaveis
Local cChvDoc := ""
Local cEmpDoc := ""
Local cFilDoc := ""
Local cNumDoc := ""
Local cSerDoc := ""
Local cForDoc := ""
Local cLojDoc := ""
Local cTipDoc := ""
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_STATOT == "08" // "08"=Nota de entrada transmitida Sefaz com sucesso (notificado Thomson)
                            If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                                If !Empty(ZTN->ZTN_DETPR2) .And. At(" ",ZTN->ZTN_DETPR2) < Len(AllTrim(ZTN->ZTN_DETPR2)) // Detalhes da nota gerada (Chave)
                                    cChvDoc := RTrim(SubStr(ZTN->ZTN_DETPR2, At(" ",ZTN->ZTN_DETPR2) + 1, Len(ZTN->ZTN_DETPR2)))      // Chave        Ex: "010200047642400101570901N"
                                    cEmpDoc := SubStr( cChvDoc, 01, 02 )            // Empresa          Ex: "01"
                                    cFilDoc := SubStr( cChvDoc, 03, 02 )            // Filial           Ex: "02"
                                    cNumDoc := SubStr( cChvDoc, 05, 09 )            // Numero Doc       Ex: "000476424"
                                    cSerDoc := SubStr( cChvDoc, 14, 03 )            // Serie Doc        Ex: "001"
                                    cForDoc := SubStr( cChvDoc, 17, 06 )            // Fornecedor Doc   Ex: "015709"
                                    cLojDoc := SubStr( cChvDoc, 23, 02 )            // Loja Doc         Ex: "01"
                                    cTipDoc := SubStr( cChvDoc, 25, 01 )            // Tipo Doc         Ex: "N"
                                    If cEmpDoc + cFilDoc == cEmpAnt + cFilAnt // Empresa/Filial conforme
                                        If SA2->(DbSeek(_cFilSA2 + cForDoc + cLojDoc)) // A2_FILIAL + A2_COD + A2_LOJA
                                            If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                                                If SF1->(DbSeek( _cFilSF1 + cNumDoc + cSerDoc + SA2->A2_COD + SA2->A2_LOJA + cTipDoc )) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
                                                    If !Empty(SF1->F1_CHVNFE) // Apenas notas transmitidas
                                                        // Retorno NF Importacao:
                                                        aRecTab := { { "SA2", Array(0) }, { "SF1", Array(0) }, { "ZTN", Array(0) } }
                                                        aAdd(aRecTab[01,02], SA2->(Recno()))    // Recno SA2
                                                        aAdd(aRecTab[02,02], SF1->(Recno()))    // Recno SF1
                                                        aAdd(aRecTab[03,02], ZTN->(Recno()))    // Recno ZTN
                                                        // ###################### RETORNO NF IMPORTACAO #############################
                                                        //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,       Titulo Integracao, Msg Processamento }
                                                        //            {        01,                      02,      03,             04,         05,         06,              07,              08,                      09,                10 }
                                                        aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Retorno NF Importacao",      "Processo: " })
                                                        aParams := {}
                                                        aAdd(aParams, { { "cStatSefaz", "'Aprovada - SEFAZ.'" }, { "cCodSiste", "'9'" }, { "cDescric", "'Aprovada'" }, { "cDateProc", "'" + DtoS(Date()) + "'" } }) // Variaveis auxiliares
                                                        aAdd(aTail(aMethds)[06], aClone(aParams))
                                                    Else // Documento/Serie ainda nao foi transmitido
                                                        cMsg01 := "Documento/Serie nao foi ainda transmitido Sefaz!"
                                                        cMsg02 := "Documento/Serie/Forn/Loja/Tipo: " + cNumDoc + "/" + cSerDoc + "/" + SA2->A2_COD + "/" + SA2->A2_LOJA + "/" + cTipDoc
                                                        cMsg03 := "Verifique se a nota foi transmitida e tem a chave preenchida (F1_CHVNFE)"
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Documento/Serie nao encontrado no cadastro (SF1)
                                                    cMsg01 := "Documento/Serie nao encontrado no sistema (SF1)!"
                                                    cMsg02 := "Documento/Serie/Forn/Loja/Tipo: " + cNumDoc + "/" + cSerDoc + "/" + SA2->A2_COD + "/" + SA2->A2_LOJA + "/" + cTipDoc
                                                    cMsg03 := ""
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Fornecedor esta bloqueado no cadastro (SA2)
                                                cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                cMsg02 := "Verifique o fornecedor e tente novamente!"
                                                cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Fornecedor do documento nao encontrado no cadastro (SA2)
                                            cMsg01 := "Fornecedor do documento nao encontrado no cadastro (SA2)!"
                                            cMsg02 := "Fornecedor/Loja: " + cForDoc + "/" + cLojDoc
                                            cMsg03 := ""
                                            cMsg04 := ""
                                            lRet := .F.
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf
                        EndIf
                    EndIf // Recno especifico tela ou todos
                    ZTN->(DbSkip())
                End
            EndIf // ZTN conforme 6002
        EndIf // "P"=Registro Posicionado
    EndIf // TipInt preenchido
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3801 ºAutor ³Jonathan Schmidt Alves º Data ³30/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Notificacoes (Cambio Import)     C O N S U L T A  º±±
±±º          ³                                                      6012  º±±
±±º          ³ ID Interface no In-Out: PRC_IT_CI_OUT_TXT                  º±±
±±º          ³ API: PRC_IT_CI_OUT_TXT                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PRC_IT_CI_OUT_TXT"                                     º±±
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
±±º          ³ Processa os dados na ZTN e gera dados na ZTY (Cambio Imp). º±±
±±º          ³ 6012 Contrato Cambio Import                                º±±
±±º          ³ Tabelas Totvs: ZTY                                         º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3801()
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
            aEveCtb := { { "01", "Adiantamento", "1" } , { "02", "Baixa do Titulo Material", "2" } }
            // "2"=Variacao Cambial + Compensacao da RA gerada anteriormente (vai estar no valor batido)
            // "3"=Variacao Cambial + Baixa Receber do titulo gerado (vai estar no valor batido)
            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            If ZTN->(DbSeek( _cFilZTN + "6012" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6012" + "3" // "6012"=Contrato Cambio Import
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                            // Posicionamentos:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            For _w1 := 1 To 2 // Adiantamento / Baixa
                                cEveCtb := aEveCtb[ _w1, 03 ]
                                
                                // idEventoContabil     "1"=Adiantamento (PA)           Gerar PA no Financeiro  FINA040
                                // idEventoContabil     "2"=Baixa do Titulo Material    Baixar o titulo no financeiro

                                // idEventoContabil     "3"=Baixa Servico               *** Steck
                                // idEventoContabil     "4"=Imposto Renda Serv          *** Steck
                                // idEventoContabil     "5"=Outros Impostos Serv        *** Steck

                                // ###################### PROCESSO CAMBIO IMPORTACAO #############################
                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,        Titulo Integracao, Msg Processamento }
                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                       09,                10 }
                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta Cambio Import",      "Processo: " })
                                aParams := {}
                                aAdd(aParams, { { "cIdLanc", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cEveCtb", "'" + cEveCtb + "'" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))

                            Next
                        EndIf // "03"=Em Processamento Totvs
                    EndIf // Recno conforme tela ou todos
                    ZTN->(DbSkip())
                End // ZTN conforme 6012
            End // ZTN localizado 6012
        EndIf // Registro posicionado
    EndIf // Tipo de integracao
EndIf // Mensangens processamento
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3803 ºAutor ³Jonathan Schmidt Alves º Data ³30/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao/Baixa Titulos Pagar (Cambio Imp) P R O C E S S A  º±±
±±º          ³                                                  ZTY 6012  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera os titulos de Adiantamento a Pagar (PA) via Rotina de º±±
±±º          ³ inclusao (FINA050) ou faz busca do titulo relacionado ao   º±±
±±º          ³ processo para a Baixa a Pagar via Rotina (FINA070) na moedaº±±
±±º          ³ estrangeira original conforme Thomson.                     º±±
±±º          ³ Tabelas Totvs: SE2/ZTY                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3803()
Local _w1
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local nChvPos := 0
Local nOpc := 3 // 3=Baixa
// Variaveis Filiais
Local _cFilZTN := xFilial("ZTN")
Local _cFilSE2 := xFilial("SE2")
Local _cFilSA2 := xFilial("SA2")
Local _cFilSA6 := xFilial("SA6")
DbSelectArea("ZTN")
ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
DbSelectArea("ZTY")
ZTY->(DbSetOrder(2)) // ZTY_FILIAL + ZTY_IDELAN
ZTY->(DbGotop())
While ZTY->(!EOF())
    If ZTY->ZTY_STATOT == "01" // "01"=Pendente
        If Left(ZTY->ZTY_EMPRES,04) == cEmpAnt + cFilAnt // Empresa e Filial conforme
            If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTY->(Recno()) == nRecTabPos) // Recno especifico
                If RTrim(ZTY->ZTY_IDECTB) $ "1/2/" // "1"=Adiantamento (PA)     "2"=Baixa do Titulo relacionado ao pgto da nota de importacao
                    If ZTN->(DbSeek( _cFilZTN + ZTY->ZTY_IDEVEN + ZTY->ZTY_IDELAN ))
                        cMsg01 := ""
                        cMsg02 := ""
                        cMsg03 := ""
                        cMsg04 := ""
                        nOpc :=  3 // 3=Inclusao
                        aTits := {}
                        aBxs := {}
                        lRet := .T.
                        _cFilSE2 := SubStr(ZTY->ZTY_EMPRES,03,02)
                        If RTrim(ZTY->ZTY_TIPDOC) == "PA" // Pagamento Antecipado

                            //          { Prefx,      Numero,   Parcela,  Tipo,           Codigo Fornecedor,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,                               Moeda,           Taxa Moeda,                                                                   Historico,,,,,,,,       Processo Thomson }
                            //          {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,                                  11,                   12,                                                                          13,,,,,,,,                     21 }
                            aAdd(aTits, { "THO", "000000001", Space(03), "PA ", SubStr(ZTY->ZTY_CODPAR,4,6), SubStr(ZTY->ZTY_CODPAR,10,2), PadR(ZTY->ZTY_FLEXF6,10), StoD(StrTran(Left(ZTY->ZTY_DATEMI,10),"-","")), StoD(StrTran(Left(ZTY->ZTY_DATCON,10),"-","")), Val(ZTY->ZTY_VALRME), Iif(ZTY->ZTY_NMOEDA == "USD", 2, 4), Val(ZTY->ZTY_TXMOED), "Thomson " + Iif(!Empty(ZTY->ZTY_REFER1), ZTY->ZTY_REFER1, ZTY->ZTY_REFER2),,,,,,,, RTrim(ZTY->ZTY_REFER2) })

                        ElseIf RTrim(ZTY->ZTY_TIPDOC) == "D" // Baixa Pagar (localizar o titulo pelo ZTY_REFER2)

                            If !Empty(ZTY->ZTY_FLEXF8) // Flex 08 contem o ID do 6060 para localizacao do Transito (Jonathan/Cleber 15/02/2022) correcao

                                aAreaZTN := ZTN->(GetArea())
                                ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01 // ZTN->(DbSetOrder(5)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_PVC201 + ZTN_PVC202
                                If ZTN->(DbSeek( _cFilZTN + "6060" + PadR(ZTY->ZTY_FLEXF8,10) )) // ZTN->(DbSeek( _cFilZTN + "6059" + ZTY->ZTY_REFER2 )) // Localizo o Transito (titulo gerado)      *** VERIFICAR "6060" ou "6059"
                                    
                                    While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_NUMB01 == _cFilZTN + "6060" + PadR(ZTY->ZTY_FLEXF8,10) .And. Len( aBxs ) == 0
                                        If ( "NF" $ ZTN->ZTN_PVC202 .And. !Empty(ZTN->ZTN_DETPR3) )   .OR.   ( "COMPROMISSO" $ Upper(ZTN->ZTN_PVC202) .And. !Empty(ZTN->ZTN_DETPR3) ) // If !Empty(ZTN->ZTN_FATNUM) .And. RTrim(ZTN->ZTN_FATNUM) $ ZTY->ZTY_TEXTIT // Fatura conforme ZTN x ZTY

                                            If ZTN->ZTN_STATOT == "02" // "02"=Lancamento Contabil gerado com sucesso! (e tambem Baixa do Transito)
                                                If !Empty( ZTN->ZTN_DETPR3 ) .And. (nChvPos := At(" ", RTrim(ZTN->ZTN_DETPR3))) > 0 // Chave do Titulo a Pagar preenchido
                                                    cChvSE2 := SubStr( ZTN->ZTN_DETPR3, nChvPos + 1, 30 ) // Chave do Titulo SE2        0102THO000000047AAANF 01570901
                                                    cEmpSE2 := SubStr( cChvSE2, 01, 2 )                         // Empresa
                                                    cFilSE2 := SubStr( cChvSE2, 03, 2 )                         // Filial
                                                    cPrfSE2 := SubStr( cChvSE2, 05, 3 )                         // Prefixo
                                                    cNumSE2 := SubStr( cChvSE2, 08, 9 )                         // Numero
                                                    cParSE2 := SubStr( cChvSE2, 17, 3 )                         // Parcela
                                                    cTipSE2 := SubStr( cChvSE2, 20, 3 )                         // Tipo
                                                    cForSE2 := SubStr( cChvSE2, 23, 6 )                         // Fornecedor
                                                    cLojSE2 := SubStr( cChvSE2, 29, 2 )                         // Loja
                                                    // Banco
                                                    cBcoSA6 := PadR(ZTY->ZTY_FLEXF5,03)                         // Banco
                                                    cAgeSA6 := PadR(ZTY->ZTY_COCON1,05)                         // Agencia
                                                    cConSA6 := PadR(ZTY->ZTY_COCON2,10)                         // Conta
                                                    // Baixa moeda estrangeira
                                                    dDatBxa := StoD(StrTran(Left(ZTY->ZTY_DATCON,10),"-",""))   // Data Baixa
                                                    nMoeEst := Iif(ZTY->ZTY_NMOEDA == "USD", 2, 4)              // Moeda Estrangeira 2=Dolar 4=Euro
                                                    nTaxMoe := Val(ZTY->ZTY_TXMOED)                             // Taxa da Moeda Estrangeira
                                                    cCodPrc := RTrim(ZTY->ZTY_REFER2)                           // Codigo do Processo
                                                    nVlrPag := Val(ZTY->ZTY_VALRME)                             // Valor Pagar Moeda Estrangeira

                                                    cProTho := RTrim(ZTY->ZTY_REFER2)                           // Processo Thomson

                                                    If !Empty(ZTY->ZTY_NMOEDA) // Moeda preenchida
                                                        If nTaxMoe > 0 // Taxa preenchida
                                                            DbSelectArea("SA6")
                                                            SA6->(DbSetOrder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
                                                            If SA6->(DbSeek( _cFilSA6 + cBcoSA6 + cAgeSA6 + cConSA6 ))
                                                                DbSelectArea("SA2")
                                                                SA2->(DbSetOrder(1)) // A2_FILAIL + A2_COD + A2_LOJA
                                                                If SA2->(DbSeek( _cFilSA2 + cForSE2 + cLojSE2 ))
                                                                    If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloquado
                                                                        DbSelectArea("SE2")
                                                                        SE2->(DbSetOrder(6)) // E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
                                                                        If SE2->(DbSeek( _cFilSE2 + SA2->A2_COD + SA2->A2_LOJA + cPrfSE2 + cNumSE2 ))
                                                                            While SE2->(!EOF()) .And. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == _cFilSE2 + SA2->A2_COD + SA2->A2_LOJA + cPrfSE2 + cNumSE2
                                                                                If Empty(SE2->E2_XBLQ) // Titulo desbloqueado
                                                                                    RestArea(aAreaZTN)
                                                                                    If SE2->E2_SALDO >= nVlrPag // Saldo suficiente para a baixa
                                                                                        aAdd(aBxs, { SE2->(Recno()), ZTN->(Recno()), ZTY->(Recno()), SA6->(Recno()) })
                                                                                        Exit
                                                                                    EndIf
                                                                                EndIf
                                                                                SE2->(DbSkip())
                                                                            End
                                                                            If Len(aBxs) == 0 // Nenhum titulo liberado para baixa (SE2)
                                                                                cMsg01 := "Nenhum dos titulos localizados liberado para baixa (SE2)!"
                                                                                cMsg02 := "Fornecedor/Loja/Pref/Num: " + SE2->E2_FORNECE + "/" + SE2->E2_LOJA + "/" + SE2->E2_PREFIXO + "/" + SE2->E2_NUM
                                                                                cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                                                cMsg04 := ""
                                                                                lRet := .F.
                                                                            EndIf
                                                                        Else // Titulo(s) nao encontrado(s)
                                                                            cMsg01 := "Titulos a Pagar nao encontrados (SE2)!"
                                                                            cMsg02 := "Fornecedor/Loja: " + cForSE2 + cLojSE2
                                                                            cMsg03 := "Pref/Num: " + cPrfSE2 + "/" + cNumSE2
                                                                            cMsg04 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                                            lRet := .F.
                                                                        EndIf
                                                                    Else // Fornecedor esta bloqueado no cadastro (SA2)
                                                                        cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                                        cMsg02 := "Verifique o fornecedor e tente novamente!"
                                                                        cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                                        cMsg04 := ""
                                                                        lRet := .F.
                                                                    EndIf
                                                                Else // Fornecedor/Loja nao encontrado no cadastro (SA2)
                                                                    cMsg01 := "Fornecedor/Loja nao encontrado no cadastro (SA2)!"
                                                                    cMsg02 := "Fornecedor/Loja: " + cForSE2 + "/" + cLojSE2
                                                                    cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
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
                                                        Else // Taxa da Moeda Estrangeira nao preenchida (ZTY)
                                                            cMsg01 := "Taxa da Moeda Estrangeira nao preenchida (ZTY)!"
                                                            cMsg02 := "Processo: " + ZTY->ZTY_REFER2
                                                            cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                            cMsg04 := ""
                                                            lRet := .F.
                                                        EndIf
                                                    Else // Moeda Estrangeira nao preenchida (ZTY)
                                                        cMsg01 := "Moeda Estrangeira nao preenchida (ZTY)!"
                                                        cMsg02 := "Processo: " + ZTY->ZTY_REFER2
                                                        cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Chave do titulo nao preenchida
                                                    cMsg01 := "Chave do(s) titulo(s) a pagar nao preenchidas (ZTN)!"
                                                    cMsg02 := "Verifique na Baixa do Transito a chave do(s) titulo(s)!"
                                                    cMsg03 := "Processo: " + ZTY->ZTY_REFER2
                                                    cMsg04 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                    lRet := .F.
                                                EndIf
                                            Else // Baixa do Transito ainda nao realizada (ZTN)
                                                cMsg01 := "Baixa do Transito nao processada (ZTN)!"
                                                cMsg02 := "A baixa do transito deve ser realizada antes do(s) pgto(s)!"
                                                cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf


                                        EndIf
                                        ZTN->(DbSkip())
                                    End
                                Else // Baixa do Transito nao encontrada (ZTN)
                                    cMsg01 := "Baixa do Transito para este processo nao localizada (ZTN)!"
                                    cMsg02 := "Processo: " + ZTY->ZTY_REFER2
                                    cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                    cMsg04 := ""
                                    lRet := .F.
                                EndIf
                                RestArea(aAreaZTN)

                            Else // Flex 8 nao alimentado
                                cMsg01 := "Informacao Flex 8 nao alimentada para localizacao do Transito! (ZTY)"
                                cMsg02 := "Processo: " + ZTY->ZTY_REFER2
                                cMsg03 := "Nao sera possivel realizar a(s) baixa(s)!"
                                lRet := .F.
                                cMsg04 := ""
                            EndIf

                        EndIf
                        If lRet // Valido
                            If Len(aTits) > 0 // Titulos carregados para processamento
                                For _w1 := 1 To Len(aTits)
                                    If aTits[_w1,04] == "PA " // Adiantamento
                                        DbSelectArea("SE2")
                                        SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
                                        SE2->(DbSeek( _cFilSE2 + aTits[_w1,01] + "999999999", .T. ))
                                        SE2->(DbSkip(-1))
                                        If SE2->E2_PREFIXO == aTits[_w1,01]
                                            aTits[_w1,02] := Soma1(SE2->E2_NUM,9)
                                        EndIf
                                        _cFilSED := xFilial("SED")
                                        DbSelectArea("SED")
                                        SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                                        If SED->(DbSeek(_cFilSED + aTits[_w1,07]))
                                            _cFilSA2 := xFilial("SA2")
                                            DbSelectArea("SA2")
                                            SA2->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
                                            If SA2->(DbSeek( _cFilSA2 + aTits[_w1,05] + aTits[_w1,06] ))
                                                If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                                                    aTitulo := { { "E2_PREFIXO",        aTits[_w1,01],              Nil },;
                                                                { "E2_NUM",             aTits[_w1,02],              Nil },;
                                                                { "E2_TIPO",            aTits[_w1,04],              Nil },;
                                                                { "E2_FORNECE",         aTits[_w1,05],              Nil },;
                                                                { "E2_LOJA",            aTits[_w1,06],              Nil },;
                                                                { "E2_NOMCLI",          SA2->A2_NREDUZ,             Nil },;
                                                                { "E2_EMISSAO",         aTits[_w1,08],              Nil },;
                                                                { "E2_EMIS1",           aTits[_w1,08],              Nil },;
                                                                { "E2_VENCTO",          aTits[_w1,09],              Nil },;
                                                                { "E2_VENCREA",         DataValida(aTits[_w1,09]),  Nil },;
                                                                { "E2_MOEDA",           aTits[_w1,11],              Nil },;
                                                                { "E2_TXMOEDA",         aTits[_w1,12],              Nil },;
                                                                { "E2_VALOR",           aTits[_w1,10],              Nil },;
                                                                { "E2_VLCRUZ",          aTits[_w1,10],              Nil },;
                                                                { "E2_NATUREZ",         aTits[_w1,07],              Nil },;
                                                                { "E2_HIST",            aTits[_w1,13],              Nil } } //,;
                                                                // { "E2_XPROTHO",         aTits[_w1,21],              Nil } } // Processo Thomson

                                                    If aTits[_w1,04] == "PA " // Adiantamento
                                                        aAdd(aTitulo, { "AUTBANCO",     RTrim(ZTY->ZTY_FLEXF5),     Nil })  // "341"            // 341
                                                        aAdd(aTitulo, { "AUTAGENCIA",   RTrim(ZTY->ZTY_COCON1),     Nil })  // "8712"           // 0073 
                                                        aAdd(aTitulo, { "AUTCONTA",     RTrim(ZTY->ZTY_COCON2),     Nil })  // "015844"         // 083867    
                                                    EndIf

                                                    Pergunte("FIN050",.F.)
                                                    Mv_Par01 := 2       // Mostra lanc contabil?        1=Sim 2=Nao
                                                    Mv_Par02 := 2       // Contab. Tit Provisorio?      1=Sim 2=Nao
                                                    Mv_Par03 := 1       // Inf. Ctas no rateio?         1=Sim 2=Nao
                                                    Mv_Par04 := 2       // Contabiliza On-line?         1=Sim 2=Nao
                                                    Mv_Par05 := 2       // Gerar Chq p/Adiant?          1=Sim 2=Nao
                                                    Mv_Par06 := 2       // Rateia Valor?                1=Bruto 2=Liquido
                                                    Mv_Par07 := 2       // Aglutina Lancamento Contabil 1=Sim 2=Nao
                                                    Mv_Par08 := 1       // Mostra rateio exclusao?      1=Sim 2=Nao
                                                    Mv_Par09 := 1       // Mov.Banc.sem Cheque?         1=Sim 2=Nao
                                                    Mv_Par10 := 1       // Gera Rateio?                 1=Titulo Titulo/Impostos
                                                    Mv_Par11 := 2       // Valores Acessorios Inclusao? 1=Sim 2=Nao

                                                    lMsErroAuto := .F.
                                                    lExibeLanc := .F.
                                                    lOnline := .F.
                                                    MsExecAuto({|x,y|, FINA050(x,y) }, aTitulo, nOpc,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao      3,, /*aDadosBco*/ Nil, lExibeLanc, lOnline)
                                                    If lMsErroAuto // Falha
                                                        ConOut("WsRc3803: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                                        MostraErro()
                                                    Else // Sucesso
                                                        lRet := .T.
                                                        RecLock("SE2",.F.)
                                                        SE2->E2_XBLQ := "" // Deixo o titulo "desbloqueado"
                                                        SE2->(MsUnlock())
                                                        cChvTit := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
                                                        
                                                        RecLock("ZTY",.F.)
                                                        ZTY->ZTY_STATOT := "02" // "02"=Processado com sucesso
                                                        If aTits[_w1,04] == "PA "
                                                            ZTY->ZTY_CHVADT := cChvTit
                                                        Else
                                                            ZTY->ZTY_CHVDES := cChvTit
                                                        EndIf
                                                        ZTY->ZTY_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                        ZTY->ZTY_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                        ZTY->(MsUnlock())

                                                        RecLock("ZTN",.F.)
                                                        ZTN->ZTN_STATOT := "08" // "08"=Titulos gerados com Sucesso!
                                                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                                        ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                                        ZTN->(MsUnlock())

                                                        // Correcao temporaria para tratar E5_TIPODOC incorreto devido a parametros (login LILIA.LIMA)
                                                        If SE2->E2_TIPO == "PA "
                                                            If SE5->E5_NUMERO == SE2->E2_NUM // Numero conforme
                                                                If SE5->E5_TIPODOC <> "PA "
                                                                    RecLock("SE5",.F.)
                                                                    SE5->E5_TIPODOC := "PA "
                                                                    SE5->(MsUnlock())
                                                                EndIf
                                                            EndIf
                                                        EndIf
                                                        // Fim da correcao

                                                        ConOut("WsRc3803: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                                    EndIf
                                                    ConOut("WsRc3803: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
                                                    If lMsErroAuto
                                                        cMsg01 := "Falha no ExecAuto"
                                                        Exit
                                                    EndIf
                                                Else // Fornecedor esta bloqueado no cadastro (SA2)
                                                    cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                    cMsg02 := "Verifique o fornecedor e tente novamente!"
                                                    cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Fornecedor nao encontrado no cadastro (SA2)
                                                cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                                                cMsg02 := "Verifique o fornecedor e tente novamente!"
                                                cMsg03 := "Fornecedor/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        Else // Natureza Financeira nao encontrada no cadastro (SED)
                                            cMsg01 := "Natureza Financeira nao encontrada no cadastro (SED)!"
                                            cMsg02 := "Verifique a natureza e tente novamente!"
                                            cMsg03 := "Natureza: " + aTits[_w1,07]
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
                                        SE2->(DbGoto(aBxs[_w1,01]))
                                        ZTN->(DbGoto(aBxs[_w1,02]))
                                        ZTY->(DbGoto(aBxs[_w1,03]))
                                        SA6->(DbGoto(aBxs[_w1,04]))
                                        If SE2->(!EOF())
                                            aBaixa := { { "E2_FILIAL",      SE2->E2_FILIAL,		    Nil },;
                                            { "E2_PREFIXO",	                SE2->E2_PREFIXO,        Nil },;
                                            { "E2_NUM",						SE2->E2_NUM,            Nil },;
                                            { "E2_PARCELA",					SE2->E2_PARCELA,        Nil },;
                                            { "E2_FORNECE",					SE2->E2_FORNECE,        Nil },;
                                            { "E2_LOJA",					SE2->E2_LOJA,           Nil },;
                                            { "E2_TIPO",					SE2->E2_TIPO,           Nil },;
                                            { "AUTMOTBX",					"DEB",                  Nil },; // Motivo de baixa "DEB"
                                            { "AUTBANCO",                   SA6->A6_COD,            Nil },; // "745"
                                            { "AUTAGENCIA",                 SA6->A6_AGENCIA,        Nil },; // "001"
                                            { "AUTCONTA",                   SA6->A6_NUMCON,         Nil },; // "34619933"
                                            { "AUTDTBAIXA",					dDatBxa,                Nil },; // Data de baixa
                                            { "AUTDTCREDITO",				dDatBxa,                Nil },; // Data de credito
                                            { "AUTTXMOEDA",                 nTaxMoe,                Nil },; // Taxa da moeda estrangeira na baixa
                                            { "AUTHIST",					"Thomson " + cCodPrc,   Nil },; // Historico
                                            { "AUTVLRPG",                   nVlrPag,                Nil } } // Valor Pagar na moeda estrangeira
                                            Pergunte("FIN080",.F.) // Contabilizacao deve ser pelo LP 520 Sequenciais 061/062/063
                                            Mv_Par01 := 1				// Mostra Lancamento Contabil?		1=Sim 2=Nao
                                            Mv_Par02 := 2				// Aglutina Lancamento Contabil?	1=Sim 2=Nao
                                            Mv_Par03 := 1 // 1			// Contabiliza On Line?				1=Sim 2=Nao
                                            Mv_Par04 := 2				// Permite Baixa Bord?	        	1=Sim 2=Nao
                                            Mv_Par05 := 3				// Replica Rateio?					1=Inclusao 2=Baixa 3=Nao Replicar
                                            Mv_Par06 := 2				// Utiliza banco anterior?			1=Sim 2=Nao
                                            lOnline := .F.
                                            lExibeLanc := .F.
                                            lMsErroAuto := .F.

                                            dHldDbase := dDatabase // Hold da database
                                            dDatabase := dDatBxa // Altero a database para a mesma da baixa
                                            MsExecAuto({|a,b,c,d,e,f,|, FINA080(a,b,c,d,e,f) }, aBaixa, nOpc, .F., Nil, lExibeLanc, lOnline) // MsExecAuto({|x,y|, FINA080(x,y) }, aBaixa, nOpc)
                                            dDatabase := dHldDbase // Retorno a database original

                                            If lMsErroAuto // Falha no ExecAuto FINA080
                                                cMsg01 := "Erro no processamento da baixa a pagar (ExecAuto)!"
                                                cMsg02 := ""
                                                cMsg03 := ""
                                                cMsg04 := ""
                                                lRet := .F.
                                                MostraErro()
                                                Exit
                                            Else // Sucesso na baixa pagar
                                                RecLock("ZTY",.F.)
                                                ZTY->ZTY_STATOT := "02" // "02"=Processado com sucesso
                                                ZTY->ZTY_CHVBXA := SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_CLIFOR + SE5->E5_LOJA // Chave da Baixa
                                                ZTY->ZTY_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                                ZTY->ZTY_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                                ZTY->(MsUnlock())
                                                RecLock("ZTN",.F.)
                                                ZTN->ZTN_STATOT := "08" // "08"=Titulo(s) baixado(s) com Sucesso!
                                                ZTN->ZTN_DETPR1 := "Titulo(s) baixado(s) com Sucesso!"
                                                ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                                ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                                ZTN->(MsUnlock())
                                                ConOut("WsRc3803: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                            EndIf
                                        EndIf
                                    Next
                                EndIf
                            EndIf
                        EndIf
                    EndIf

                ElseIf .F. // "3"

                EndIf

            EndIf // Recno tela conforme ou todos

        EndIf // Empresa/Filial conforme
    EndIf // ZTY pendente de processamento
    ZTY->(DbSkip())
End
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3901 ºAutor ³Jonathan Schmidt Alves º Data ³16/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Notific (Desp/Adto/Pgto Imp)     C O N S U L T A  º±±
±±º          ³                                                      6062  º±±
±±º          ³ ID Interface no In-Out: PKG_PRC_ADIANT_DESPESA             º±±
±±º          ³ API: PKG_PRC_ADIANT_DESPESA                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_PRC_ADIANT_DESPESA"                                º±±
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
±±º          ³ Consulta dados no Thomson e faz a geracao de dados na ZTF. º±±
±±º          ³ A ZTF na sequencia gera Titulos de Pagamento, Adiantamento º±±
±±º          ³ ou a Prestacao de Contas.                                  º±±
±±º          ³ Tabelas Totvs: ZTF                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3901()
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
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            
            // Posicionamentos:
            aRecTab := { { "ZTN", Array(0) } }
            // <spTipo>01</spTipo>          // 01=AD        Adiantamento
            // <spTipo>01</spTipo>          // 03=PG        Pagamento
            // <spTipo>01</spTipo>          // 02=PC        Prestacao de Contas

            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            If ZTN->(DbSeek( _cFilZTN + "6062" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6062" + "3" // "6062"=Emissao de Pagamento/Adiantamento/Prestacao de Contas
                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                        If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                            // Posicionamentos Notificacoes:
                            aRecTab := { { "ZTN", Array(0) } }
                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                            For _w1 := 1 To 3 // So Pagamento por enquanto
                                cTipo := { { "AD", "Adiantamento", "01" } , { "PC", "Prestacao", "02" }, { "PG", "Pagamento", "03" } } [ _w1, 03 ]
                                // ###################### PROCESSO ADTO DESP #############################
                                //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,         Titulo Integracao, Msg Processamento }
                                //            {        01,                      02,      03,             04,         05,         06,              07,              08,                        09,                10 }
                                aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta Desp/Adto/Pgto",      "Processo: " })
                                aParams := {}
                                aAdd(aParams, { { "cCodId", "'" + RTrim(ZTN->ZTN_NUMB01) + "'" }, { "cTipo", "'" + cTipo + "'" }, { "cCodProce", "'" + RTrim(ZTN->ZTN_PVC201) + "'" } }) // Variaveis auxiliares
                                aAdd(aTail(aMethds)[06], aClone(aParams))
                                // Retorno FlexField1: Service (gera titulos PA/Desp/etc) Service NF/CTE (gera Solicitacao Compras)
                                // <spdSFlexField1>Service</spdSFlexField1>
                                // <spdSFlexField1>Service NF</spdSFlexField1>
                            Next
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
±±ºPrograma  ³ WsRc3905 ºAutor ³Jonathan Schmidt Alves º Data ³16/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao Titulos (Desp/Adto/Pgto Import)  P R O C E S S A  º±±
±±º          ³                                                  ZTF 6062  º±±
±±º          ³ Processamento Totvs sem integracao Thomson.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Geracao dos Titulos a Pagar via Rotina de Inclusao de      º±±
±±º          ³ Titulos (FINA050) para os registros que foram carregados   º±±
±±º          ³ na ZTF.                                                    º±±
±±º          ³ Geracao de Solicitacoes de Compra via Rotina Padrao de     º±±
±±º          ³ Solicitacoes (MATA110) para registros que terao Documento  º±±
±±º          ³ Fiscal iniciando o processo via Nota de Entrada.           º±±
±±º          ³ Tabelas Totvs: ZTF/SE2/SC1                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3905()
Local _w1
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
Local aSols := {}
Local aTits := {}
Local nOpc :=  3 // 3=Inclusao
Local cChvTit := ""
Local cChvUnq := ""
// Banco/Agencia/Conta padrao
Local cBcoPad := ""
Local cAgePad := ""
Local cConPad := ""
Private _cFilSA6 := xFilial("SA6")
Private _cFilZTF := xFilial("ZTF")
Private _cFilZTN := xFilial("ZTN")
Private _cFilSA2 := xFilial("SA2")
Private _cFilSED := xFilial("SED")
Private _cFilSC1 := xFilial("SC1")
Private _cFilCTT := xFilial("CTT")
Private _cFilSB1 := xFilial("SB1")
DbSelectArea("ZTF")
ZTF->(DbSetOrder(1)) // ZTF_FILIAL + ZTF_CDSPID + ZTF_PROCES + ZTF_IDEPRO
ZTF->(DbGotop())
While ZTF->(!EOF())
    If ZTF->ZTF_STATOT == "01" // "01"=Pendente
        If !Empty(ZTF->ZTF_DATEMI) // Data de Emissao preenchida
            If Left(ZTF->ZTF_SPORGA,02) == cEmpAnt .And. SubStr(ZTF->ZTF_SPORGA,04,02) == cFilAnt // Empresa/Filial conforme
                If SubStr(ZTF->ZTF_CREDO1,2,2) == cEmpAnt // Cod Empresa do Fornecedor conforme

                    If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTF->(Recno()) == nRecTabPos) .Or. (ZTF->ZTF_PROCESS + Left(ZTF->ZTF_SPTIPO,2) == cChvUnq) // Recno especifico

                        If "SERV" $ Upper(ZTF->ZTF_FLEXF3) .And. "NF" $ Upper(ZTF->ZTF_FLEXF3) // Gerar Solicitacao de Compras (SC1)
                            // Gerar solicitacao de compras

                            //          {      Numero,         Produto,  Quantidade, Reservado,           Codigo Fornecedor,                  Codigo Loja, Reservado,                                        Emissao,     Centro de Custo, Reservado, Reservado,                                       Observacoes,,,,,,,,      Recno ZTF,       Processo Thomson }
                            //          {          01,              02,          03,        04,                          05,                           06,        07,                                             08,                  09,        10,        11,                                                12,,,,,,,,             20,                     21 }
                            aAdd(aSols, { "000000001", ZTF->ZTF_FLEXF4,           1,       Nil, SubStr(ZTF->ZTF_CREDO1,4,6), SubStr(ZTF->ZTF_CREDO1,10,2),       Nil, StoD(StrTran(Left(ZTF->ZTF_DATEMI,10),"-","")),     ZTF->ZTF_FLEXF5,       Nil,       Nil, RTrim(ZTF->ZTF_DESPES) + " R$ " + ZTF->ZTF_ADIDES,,,,,,,, ZTF->(Recno()), RTrim(ZTF->ZTF_PROCES) })

                        Else // Gerar Titulos Pagar Financeiro (SE2)
                            _cFilSE2 := SubStr(ZTF->ZTF_SPORGA,04,02)
                            If "01" $ ZTF->ZTF_SPTIPO // 01: Adiantamento      *** Gerar PA apenas
                                If Empty( ZTF->ZTF_CHVADT ) // Ainda nao gerou

                                    cChvUnq := ZTF->ZTF_PROCESS + Left(ZTF->ZTF_SPTIPO,2) // Chave Unica
                                    cChvTit := "THO" + "000000001" + Space(03) + "PA " + SubStr(ZTF->ZTF_CREDO1,4,6) + SubStr(ZTF->ZTF_CREDO1,10,2) + StrTran(Left(ZTF->ZTF_DATEMI,10),"-","")

                                    If (nFnd := ASCan( aTits, {|x|, x[01] + x[02] + x[03] + x[04] + x[05] + x[06] + DtoS(x[08]) == cChvTit })) == 0 // Se a natureza for diferente, sera respeitada a 1ra natureza do adiantamento
                                        //          { Prefx,      Numero,   Parcela,  Tipo,           Codigo Fornecedor,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,         Despesa,,,,,,,,,      Recno ZTF,       Processo Thomson }
                                        //          {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,              11,,,,,,,,,             20,                     21 }
                                        aAdd(aTits, { "THO", "000000001", Space(03), "PA ", SubStr(ZTF->ZTF_CREDO1,4,6), SubStr(ZTF->ZTF_CREDO1,10,2), PadR(ZTF->ZTF_FLEXF1,10), StoD(StrTran(Left(ZTF->ZTF_DATEMI,10),"-","")), StoD(StrTran(Left(ZTF->ZTF_DATVEN,10),"-","")), Val(ZTF->ZTF_ADIDES), ZTF->ZTF_DESPES,,,,,,,,, ZTF->(Recno()), RTrim(ZTF->ZTF_PROCES) })
                                    Else
                                        aAdd(aTits, Array(21))
                                        aTail(aTits)[04] := "PA "                   // Adiantamento
                                        aTail(aTits)[20] := ZTF->(Recno())          // Recno ZTF
                                        aTail(aTits)[21] := RTrim(ZTF->ZTF_PROCES)  // Processo
                                        aTits[nFnd,10] += Val(ZTF->ZTF_ADIDES)      // Incremento valor
                                    EndIf

                                EndIf
                            ElseIf "02" $ ZTF->ZTF_SPTIPO // 02: Prestacao		*** Gerar o titulo a pagar
                                //              { Prefx,      Numero,   Parcela,  Tipo,           Codigo Fornecedor,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,         Despesa,,,,,,,,,      Recno ZTF,       Processo Thomson }
                                //              {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,              11,,,,,,,,,             20,                     21 }
                                If Empty( ZTF->ZTF_CHVDES ) // Ainda nao gerou
                                    aAdd(aTits, { "THO", "000000001", Space(03), "NF ", SubStr(ZTF->ZTF_CREDO1,4,6), SubStr(ZTF->ZTF_CREDO1,10,2), PadR(ZTF->ZTF_FLEXF1,10), StoD(StrTran(Left(ZTF->ZTF_DATEMI,10),"-","")), StoD(StrTran(Left(ZTF->ZTF_DATVEN,10),"-","")), Val(ZTF->ZTF_READES), ZTF->ZTF_DESPES,,,,,,,,, ZTF->(Recno()), RTrim(ZTF->ZTF_PROCES) })
                                EndIf
                            ElseIf "03" $ ZTF->ZTF_SPTIPO // 03: Pagamento      *** Despesa sem Adiantamento
                                //              { Prefx,      Numero,   Parcela,  Tipo,           Codigo Fornecedor,                  Codigo Loja,                 Natureza,                                        Emissao,                                     Vencimento,                Valor,         Despesa,,,,,,,,,      Recno ZTF,       Processo Thomson }
                                //              {    01,          02,        03,    04,                          05,                           06,                       07,                                             08,                                             09,                   10,              11,,,,,,,,,             20,                     21 }
                                If Empty( ZTF->ZTF_CHVDES ) // Ainda nao gerou
                                    aAdd(aTits, { "THO", "000000001", Space(03), "NF ", SubStr(ZTF->ZTF_CREDO1,4,6), SubStr(ZTF->ZTF_CREDO1,10,2), PadR(ZTF->ZTF_FLEXF1,10), StoD(StrTran(Left(ZTF->ZTF_DATEMI,10),"-","")), StoD(StrTran(Left(ZTF->ZTF_DATVEN,10),"-","")), Val(ZTF->ZTF_READES), ZTF->ZTF_DESPES,,,,,,,,, ZTF->(Recno()), RTrim(ZTF->ZTF_PROCES) })
                                EndIf
                            EndIf // FFTHO000000000___TIP00000099 // 28 caracteres
                        EndIf

                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
    ZTF->(DbSkip())
End
If Len(aTits) > 0 // Titulos para processar
    lRet := .T.
    For _w1 := 1 To Len(aTits)
        If lRet // .T.=Ainda valido para processamento

            If !Empty(aTits[_w1,01])  // Tem Prefixo
                
                DbSelectArea("SE2")
                SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
                SE2->(DbSeek( _cFilSE2 + aTits[_w1,01] + "999999999", .T. ))
                SE2->(DbSkip(-1))
                If SE2->E2_PREFIXO == aTits[_w1,01]
                    aTits[_w1,02] := Soma1(SE2->E2_NUM,9)
                EndIf
                DbSelectArea("SED")
                SED->(DbSetOrder(1)) // ED_FILIAL + ED_CODIGO
                If SED->(DbSeek( _cFilSED + aTits[_w1,07] ))
                    DbSelectArea("SA2")
                    SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                    If SA2->(DbSeek(_cFilSA2 + aTits[_w1,05] + aTits[_w1,06]))    // { "SPCODCREDOR", "", "ZTF_CREDO1" }  *** Esta vindo "FORNECEDOR"
                        If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                            
                            cBcoPad := PadR( { "341",       Nil, "341"      ,,,,,,,, "745"          }[ Val(cEmpAnt) ], 03)
                            cAgePad := PadR( { "8712",      Nil, "8712"     ,,,,,,,, "001 "         }[ Val(cEmpAnt) ], 05)
                            cConPad := PadR( { "105116",    Nil, "015844"   ,,,,,,,, "090019242"    }[ Val(cEmpAnt) ], 10)

                            DbSelectArea("SA6")
                            SA6->(DbSetOrder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
                            If aTits[_w1,04] <> "PA " .Or. SA6->(DbSeek(_cFilSA6 + cBcoPad + cAgePad + cConPad))

                                aTitulo := { { "E2_PREFIXO",            aTits[_w1,01],                          Nil },;
                                                { "E2_NUM",             aTits[_w1,02],                          Nil },;
                                                { "E2_TIPO",            aTits[_w1,04],                          Nil },;
                                                { "E2_FORNECE",         aTits[_w1,05],                          Nil },;
                                                { "E2_LOJA",            aTits[_w1,06],                          Nil },;
                                                { "E2_NOMFOR",          SA2->A2_NREDUZ,                         Nil },;
                                                { "E2_EMISSAO",         aTits[_w1,08],                          Nil },;
                                                { "E2_EMIS1",           aTits[_w1,08],                          Nil },;
                                                { "E2_VENCTO",          aTits[_w1,09],                          Nil },;
                                                { "E2_VENCREA",         DataValida(aTits[_w1,09]),              Nil },;
                                                { "E2_VALOR",           aTits[_w1,10],                          Nil },;
                                                { "E2_VLCRUZ",          aTits[_w1,10],                          Nil },;
                                                { "E2_NATUREZ",         aTits[_w1,07],                          Nil },;
                                                { "E2_HIST",            "Thomson " + aTits[_w1,21],             Nil } }
                                                // { "E2_CCD",             "115109   ",                            Nil },; // Centro de Custo "IMPORTACAO"
                                                // { "E2_XPROTHO",         aTits[_w1,21],                          Nil } } // Processo Thomson
                                
                                If aTits[_w1,04] == "PA " // Adiantamento
                                    aAdd(aTitulo, { "AUTBANCO",         cBcoPad,        Nil }) // Banco: "341"
                                    aAdd(aTitulo, { "AUTAGENCIA",       cAgePad,        Nil }) // Agencia: "8712"
                                    aAdd(aTitulo, { "AUTCONTA",         cConPad,        Nil }) // Conta: "105116"
                                EndIf

                                Pergunte("FIN050",.F.)
                                Mv_Par01 := 2       // Mostra lanc contabil?        1=Sim 2=Nao
                                Mv_Par02 := 2       // Contab. Tit Provisorio?      1=Sim 2=Nao
                                Mv_Par03 := 1       // Inf. Ctas no rateio?         1=Sim 2=Nao
                                Mv_Par04 := 2       // Contabiliza On-line?         1=Sim 2=Nao
                                Mv_Par05 := 2       // Gerar Chq p/Adiant?          1=Sim 2=Nao
                                Mv_Par06 := 2       // Rateia Valor?                1=Bruto 2=Liquido
                                Mv_Par07 := 2       // Aglutina Lancamento Contabil 1=Sim 2=Nao
                                Mv_Par08 := 1       // Mostra rateio exclusao?      1=Sim 2=Nao
                                Mv_Par09 := 1       // Mov.Banc.sem Cheque?         1=Sim 2=Nao
                                Mv_Par10 := 1       // Gera Rateio?                 1=Titulo Titulo/Impostos
                                Mv_Par11 := 2       // Valores Acessorios Inclusao? 1=Sim 2=Nao

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
                                    ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                    MostraErro()
                                Else // Sucesso
                                    cChvTit := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA

                                    RecLock("SE2",.F.)
                                    SE2->E2_XBLQ := "" // Deixo o titulo "desbloqueado"
                                    SE2->(MsUnlock())

                                    ZTF->(DbGoto(aTits[_w1,20])) // Reposiciono ZTF
                                    RecLock("ZTF",.F.)
                                    ZTF->ZTF_STATOT := "02" // "02"=Processado com sucesso
                                    If SE2->E2_TIPO == "PA "
                                        ZTF->ZTF_CHVADT := cChvTit
                                    Else
                                        ZTF->ZTF_CHVDES := cChvTit
                                    EndIf
                                    ZTF->ZTF_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                    ZTF->ZTF_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                    ZTF->(MsUnlock())
                                    ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")

                                    // Avaliacao ZTF todo gerado com sucesso ZTF -> ZTN
                                    cCodZTF := ZTF->ZTF_CDSPID // Codigo unico
                                    lAllZTF := .T.
                                    If ZTF->(DbSeek(_cFilZTF + cCodZTF))
                                        While ZTF->(!EOF()) .And. ZTF->ZTF_FILIAL + ZTF->ZTF_CDSPID == _cFilZTF + cCodZTF
                                            If !(lAllZTF := ZTF->ZTF_STATOT == "02") // "02"=Titulo gerado com sucesso!
                                                Exit
                                            EndIf
                                            ZTF->(DbSkip())
                                        End
                                    EndIf

                                    If lAllZTF // .T.=Gerados "todos" os ZTF necessarios
                                        DbSelectArea("ZTN")
                                        ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
                                        If ZTN->(DbSeek( _cFilZTN + "6062" + cCodZTF ))
                                            RecLock("ZTN",.F.)
                                            ZTN->ZTN_STATOT := "08" // "08"=Todos os titulos ZTF desta notificacao gerados com sucesso!
                                            ZTN->ZTN_DETPR1 := "Sucesso na geracao do(s) titulo(s)!"
                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                            ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                            ZTN->(MsUnlock())
                                        EndIf
                                    EndIf

                                EndIf
                                ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")

                            ElseIf aTits[_w1,04] == "PA " // Se foi PA, entao o banco nao existe

                                cMsg01 := "Banco Agencia Conta nao existe no cadastro (SA6)!"
                                cMsg02 := "Banco/Agencia/Conta: " + cBcoPad + "/" + cAgePad + "/" + cConPad
                                cMsg03 := ""
                                cMsg04 := ""
                                lRet := .F.

                            EndIf // SA6 nao necessario ou conforme

                        Else // Fornecedor esta bloqueado no cadastro (SA2)
                            cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                            cMsg02 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                            cMsg03 := ""
                            cMsg04 := ""
                            lRet := .F.
                        EndIf

                    Else // Fornecedor nao encontrado no cadastro (SA2)
                        cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                        cMsg02 := "Fornecedor/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                        cMsg03 := "O fornecedor deve estar cadastrado no Totvs!"
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Natureza nao encontrada no cadastro (SED)
                    cMsg01 := "Natureza nao encontrada no cadastro (SED)!"
                    cMsg02 := "Natureza: " + aTits[_w1,07]
                    cMsg03 := "A natureza do titulo vem do Thomson e deve existir no Totvs!"
                    cMsg04 := "Verifique o codigo da natureza no Thomson e tente novamente!"
                    lRet := .F.
                EndIf

            Else // Nao Tem Prefixo (Sao titulos Aglutinados Adiant)

                ZTF->(DbGoto(aTits[_w1,20])) // Reposiciono ZTF
                RecLock("ZTF",.F.)
                ZTF->ZTF_STATOT := "02" // "02"=Processado com sucesso
                If aTits[_w1,04] == "PA "
                    ZTF->ZTF_CHVADT := cChvTit
                Else
                    ZTF->ZTF_CHVDES := cChvTit
                EndIf
                ZTF->ZTF_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                ZTF->ZTF_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                ZTF->(MsUnlock())
                ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")

                // Avaliacao ZTF todo gerado com sucesso ZTF -> ZTN
                cCodZTF := ZTF->ZTF_CDSPID // Codigo unico
                lAllZTF := .T.
                If ZTF->(DbSeek(_cFilZTF + cCodZTF))
                    While ZTF->(!EOF()) .And. ZTF->ZTF_FILIAL + ZTF->ZTF_CDSPID == _cFilZTF + cCodZTF
                        If !(lAllZTF := ZTF->ZTF_STATOT == "02") // "02"=Titulo gerado com sucesso!
                            Exit
                        EndIf
                        ZTF->(DbSkip())
                    End
                EndIf

                If lAllZTF // .T.=Gerados "todos" os ZTF necessarios
                    DbSelectArea("ZTN")
                    ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
                    If ZTN->(DbSeek( _cFilZTN + "6062" + cCodZTF ))
                        RecLock("ZTN",.F.)
                        ZTN->ZTN_STATOT := "08" // "08"=Todos os titulos ZTF desta notificacao gerados com sucesso!
                        ZTN->ZTN_DETPR1 := "Sucesso na geracao do(s) titulo(s)!"
                        ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                        ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                        ZTN->(MsUnlock())
                    EndIf
                EndIf

            EndIf
        EndIf
    Next
EndIf

If Len( aSols ) // Solicitacoes de Compra
    lRet := .T.
    For _w1 := 1 To Len( aSols )
        If lRet // .T.=Ainda valido para processamento
            DbSelectArea("SA2")
            SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
            If SA2->(DbSeek(_cFilSA2 + aSols[_w1,05] + aSols[_w1,06]))
                If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                    DbSelectArea("SB1")
                    SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
                    If SB1->(DbSeek( _cFilSB1 + PadR(aSols[_w1,02],15) ))

                        If SB1->B1_MSBLQL <> "1" // Produto nao bloqueado

                            DbSelectArea("CTT")
                            CTT->(DbSetOrder(1)) // CTT_FILIAL + CTT_CUSTO // CTT->(DbSetOrder(4)) // CTT_FILIAL + CTT_DESC01
                            If CTT->(DbSeek( _cFilCTT + PadR(Upper(aSols[_w1,09]), 100) ))
                                
                                cCodComp := "087" // Administrador na empresa 11
                                cHldUsrId := __cUserId
                                __cUserId := "000000"
                                DbSelectArea("SC1")
                                SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
                                cDocSC1 := GetSXENum("SC1","C1_NUM")
                                While SC1->(DbSeek( _cFilSC1 + cDocSC1 ))
                                    ConfirmSX8()
                                    cDocSC1 := GetSXENum("SC1","C1_NUM")            // SZH, SZI, SZJ (Cadastros de Aprovadores x Centros de Custo)
                                End
                                aCabec := { { "C1_NUM",             cDocSC1,                    Nil },; // Numero Solicitacao
                                            { "C1_EMISSAO",         Date(),                     Nil },;
                                            { "C1_SOLICIT",         cUserName,                  Nil } }

                                aItem := { { { "C1_ITEM",           "0001",                     Nil },; // Numero do Item
                                            { "C1_PRODUTO",         SB1->B1_COD,                Nil },; // Codigo do Produto
                                            { "C1_QUANT",           aSols[_w1,03],              Nil },; // Quantidade
                                            { "C1_MOTIVO",          "CND",                      Nil },; // Motivo
                                            { "C1_CC",              CTT->CTT_CUSTO,             Nil },; // Centro de Custo
                                            { "C1_CONTA",           Space(20),                  Nil },; // Conta Contabil
                                            { "C1_SOLICIT",         "Administrador",            Nil },; // Solicitante
                                            { "C1_OBS",             "Thomson " + aSols[_w1,21], Nil },; // Observacoes
                                            { "C1_ZSTATUS",         "3",                        Nil },;
                                            { "C1_CODCOMP",         cCodComp,                   Nil },;
                                            { "C1_DATPRF",          Date() + 30,                Nil } } } // ,;
                                            // { "C1_XPROTHO",         aSols[_w1,21],              Nil } } // Processo Thomson

                                lMsErroAuto := .F.
                                MsExecAuto({|v,x,y|, MATA110(v,x,y) }, aCabec, aItem, nOpc)

                                __cUserId := cHldUsrId // Retorno UserId
                                DbSelectArea("SC1")
                                SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
                                If SC1->(DbSeek( _cFilSC1 + cDocSC1 )) // Sucesso
                                    cChvSol := SC1->C1_FILIAL + SC1->C1_NUM + SC1->C1_ITEM
                                    ZTF->(DbGoto(aSols[_w1,20])) // Reposiciono ZTF
                                    RecLock("ZTF",.F.)
                                    ZTF->ZTF_STATOT := "02" // "02"=Processado com sucesso
                                    ZTF->ZTF_CHVSOL := cChvSol
                                    ZTF->ZTF_DTHRLG := DtoC(Date()) + " " + Time()     // Ex: 08/08/2021 12:00:03
                                    ZTF->ZTF_USERLG := cUserName                       // Ex: "jonathan.sigamat"
                                    ZTF->(MsUnlock())
                                    ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Sucesso!")
                                    // Avaliacao ZTF todo gerado com sucesso ZTF -> ZTN
                                    cCodZTF := ZTF->ZTF_CDSPID // Codigo unico
                                    lAllZTF := .T.
                                    If ZTF->(DbSeek(_cFilZTF + cCodZTF))
                                        While ZTF->(!EOF()) .And. ZTF->ZTF_FILIAL + ZTF->ZTF_CDSPID == _cFilZTF + cCodZTF
                                            If !(lAllZTF := ZTF->ZTF_STATOT == "02") // "02"=Titulo gerado com sucesso!
                                                Exit
                                            EndIf
                                            ZTF->(DbSkip())
                                        End
                                    EndIf
                                    If lAllZTF // .T.=Gerados "todos" os ZTF necessarios
                                        DbSelectArea("ZTN")
                                        ZTN->(DbSetOrder(4)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_NUMB01
                                        If ZTN->(DbSeek( _cFilZTN + "6062" + cCodZTF ))
                                            RecLock("ZTN",.F.)
                                            ZTN->ZTN_STATOT := "08" // "08"=Todos os registros ZTF desta notificacao gerados com sucesso!
                                            ZTN->ZTN_DETPR1 := "Sucesso na geracao do(s) registro(s)!"
                                            ZTN->ZTN_DTHRLG := DtoC(Date()) + " " + Time()  // Data Hora Log
                                            ZTN->ZTN_USERLG := cUserName                    // Usuario Log
                                            ZTN->(MsUnlock())
                                        EndIf
                                    EndIf

                                Else // Falha
                                    cMsg01 := "Falha no ExecAuto (MATA110)"
                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                    cMsg03 := "A solicitacao de compras nao foi incluida no sistema!"
                                    cMsg04 := ""
                                    lRet := .F.
                                    ConOut("WsRc3905: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02 + " Falha!")
                                    MostraErro()

                                EndIf

                            Else // Centro de Custo nao encontrado no cadastro (CTT)
                                cMsg01 := "Centro de Custo nao encontrado no cadastro (CTT)!"
                                cMsg02 := "CCusto: " + Upper(aSols[_w1,09])
                                cMsg03 := ""
                                cMsg04 := "Ex: '112105'"
                                lRet := .F.
                            EndIf
                        Else // Produto bloqueado no cadastro (SB1)
                            cMsg01 := "Produto esta bloqueado no cadastro (SB1)!"
                            cMsg02 := "Produto: " + aSols[_w1,02]
                            cMsg03 := ""
                            cMsg04 := ""
                            lRet := .F.
                        EndIf
                    Else // Produto nao encontrado no cadastro (SB1)
                        cMsg01 := "Produto nao encontrado no cadastro (SB1)!"
                        cMsg02 := "Produto: " + aSols[_w1,02]
                        cMsg03 := ""
                        cMsg04 := ""
                        lRet := .F.
                    EndIf
                Else // Fornecedor esta bloqueado no cadastro (SA2)
                    cMsg01 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                    cMsg02 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                    cMsg03 := ""
                    cMsg04 := ""
                    lRet := .F.
                EndIf
            Else // Fornecedor nao encontrado no cadastro (SA2)
                cMsg01 := "Fornecedor nao encontrado no cadastro (SA2)!"
                cMsg02 := "Fornecedor/Loja: " + aTits[_w1,05] + "/" + aTits[_w1,06]
                cMsg03 := "O fornecedor deve estar cadastrado no Totvs!"
                cMsg04 := ""
                lRet := .F.
            EndIf
        EndIf
    Next
EndIf
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, Nil }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc3908 ºAutor ³Jonathan Schmidt Alves º Data ³18/10/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebimento dos Materiais. (Import)       I N C L U S A O  º±±
±±º          ³                                                      6002  º±±
±±º          ³ ID Interface no In-Out: IS_AVISO_RECEBIMENTO               º±±
±±º          ³ API: PKG_IS_API_RECEBIMENTO.PRC_IS_PROCESSA_RECEBIMENTO    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "PKG_IS_API_RECEBIMENTO.PRC_IS_PROCESSA_RECEBIMENTO"    º±±
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
±±º          ³ Envia para o Thomson os Itens da Nota/Pedido de Compra com º±±
±±º          ³ as quantidades e as datas dos recebimentos.                º±±
±±º          ³ Tabelas Totvs:  SA2/SF1/SD1/SB1/SC7/SDA/ZTN                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsRc3908()
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
// Variaveis
Local cChvDoc := ""
Local cEmpDoc := ""
Local cFilDoc := ""
Local cNumDoc := ""
Local cSerDoc := ""
Local cForDoc := ""
Local cLojDoc := ""
Local cTipDoc := ""
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
// Variaveis retorno
Local aRet := { .F., Nil, "" }
Local cError := ""
Local cWarning := ""
Local cRetXml := ""
Local aXmls := {}
aAdd(aXmls, { { "S_ENVELOPE", "" }, { "S_BODY", "" }, { "GETNOTAFISCALRESPONSE", "" }, { "BSAPINFENFC", "" }, { "NFEMPRESA", cEmpAnt + cFilAnt } })
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
                While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
                    If ZTN->ZTN_STATOT == "10" // "10"=Retorno NF processado com sucesso (notificado Thomson)
                        If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                            If Type("nRecTabPos") == "U" .Or. (Type("nRecTabPos") == "N" .And. nRecTabPos > 0 .And. ZTN->(Recno()) == nRecTabPos) // Recno especifico
                                // Parte 01: Carregamento dos dados do XML
                                cRetXml := ZTN->ZTN_XMLRET // Xml da nota fiscal
                                oXml := XmlParser(cRetXml, "_", @cError, @cWarning)
                                If XMLChildCount(oXml) > 0
                                    lRet := .T.
                                    aDados := { Array(0) }
                                    aRet := { .F., Nil, "" }
                                    cMsg01 := ""
                                    cMsg02 := ""
                                    cMsg03 := ""
                                    cMsg04 := ""
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
                                                    If !Empty(aXml[_w1,02])
                                                        If Upper(Rtrim(&(cObj):Text)) == aXml[_w1,02] // .T.=Sucesso
                                                            // ############## RECEBIMENTO MATERIAIS NOTA ENTRADA #################
                                                            oXml2 := &( Left(cObj, Rat(":",cObj) - 1) )
                                                            If ValType(oXml2) == "O"
                                                                aFlds := { { "NFEMPRESA", "", "" },;            // 01   <nfEmpresa>0102</nfEmpresa>                             Ex: 0102
                                                                    { "NFNUMNF", "", "" },;                     // 02   <nfNumnf>17</nfNumnf>                                   Ex: 17
                                                                    { "NFSERIE", "", "" } }                     // 03   <nfSerie>1</nfSerie>                                    Ex: 1
                                                                For _w4 := 1 To XMLChildCount(oXml2)
                                                                    cChk := Upper(StrTran(XMLGetChild(oXml2,_w4):RealName,":","_"))
                                                                    If (nFnd := ASCan(aFlds, {|x|, x[01] == cChk })) > 0 // Informacao localizada
                                                                        aFlds[nFnd,02] := XMLGetChild(oXml2,_w4):Text
                                                                    EndIf
                                                                Next
                                                                For _w4 := 1 To Len( aFlds )
                                                                    aAdd(aDados[01], { aFlds[_w4,01], aFlds[_w4,02] })
                                                                Next
                                                            EndIf
                                                            // ############## RECEBIMENTO MATERIAIS NOTA ENTRADA #################
                                                            If !Empty( cHldObj ) // Matriz de objetos
                                                                If _w3 < Len( &(cHldObj) )
                                                                    cObj := cHldOld // Volto o objeto antigo (antes da matriz)
                                                                    _w1 -= 2 // Volto 2 (tem um _w1++ abaixo e preciso voltar 1 elemento)
                                                                Else // Ja processou todos
                                                                    aRet[01] := .T.
                                                                EndIf
                                                            EndIf
                                                        EndIf
                                                        If aRet[01] // .T.=Ja concluido
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
                                    If Len(aDados[01]) > 0 // Dados do cabecalho carregados
                                        cDocTho := aDados[01,02,02]
                                        cSerTho := aDados[01,03,02]
                                        If !Empty( ZTN->ZTN_DETPR2 ) .And. (nChvPos := At(" ", RTrim(ZTN->ZTN_DETPR2))) > 0 // Chave da Nota de Entrada preenchida
                                            cChvDoc := SubStr( ZTN->ZTN_DETPR2, nChvPos + 1, 25 ) // Chave da nota SF1
                                            cEmpDoc := SubStr( cChvDoc, 01, 02 )            // Empresa          Ex: "01"
                                            cFilDoc := SubStr( cChvDoc, 03, 02 )            // Filial           Ex: "02"
                                            cNumDoc := SubStr( cChvDoc, 05, 09 )            // Numero Doc       Ex: "000476424"
                                            cSerDoc := SubStr( cChvDoc, 14, 03 )            // Serie Doc        Ex: "001"
                                            cForDoc := SubStr( cChvDoc, 17, 06 )            // Fornecedor Doc   Ex: "015709"
                                            cLojDoc := SubStr( cChvDoc, 23, 02 )            // Loja Doc         Ex: "01"
                                            cTipDoc := SubStr( cChvDoc, 25, 01 )            // Tipo Doc         Ex: "N"
                                            If SA2->(DbSeek( _cFilSA2 + cForDoc + cLojDoc )) // A2_FILIAL + A2_COD + A2_LOJA
                                                If SA2->A2_MSBLQL <> "1" // Fornecedor nao bloqueado
                                                    If SF1->(DbSeek( _cFilSF1 + cNumDoc + cSerDoc + SA2->A2_COD + SA2->A2_LOJA + cTipDoc )) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
                                                        If SD1->(DbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))
                                                            While SD1->(!EOF()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
                                                                If SB1->(DbSeek( _cFilSB1 + SD1->D1_COD ))
                                                                    If !Empty( SD1->D1_PEDIDO ) // Pedido de compra
                                                                        If SC7->(DbSeek( _cFilSC7 + SD1->D1_PEDIDO + SD1->D1_ITEMPC ))
                                                                            If SDA->(DbSeek( _cFilSDA + SB1->B1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ))
                                                                                
                                                                                If !Empty( SDA->DA_XDATA ) // Data do recebimento

                                                                                    cDatRec := DtoS(SDA->DA_XDATA)

                                                                                    // Retorno NF Importacao:
                                                                                    aRecTab := { { "SA2", Array(0) }, { "SF1", Array(0) }, { "SD1", Array(0) }, { "SB1", Array(0) }, { "SC7", Array(0) }, { "SDA", Array(0) }, { "ZTN", Array(0) } }
                                                                                    aAdd(aRecTab[01,02], SA2->(Recno()))    // Recno SA2
                                                                                    aAdd(aRecTab[02,02], SF1->(Recno()))    // Recno SF1
                                                                                    aAdd(aRecTab[03,02], SD1->(Recno()))    // Recno SD1
                                                                                    aAdd(aRecTab[04,02], SB1->(Recno()))    // Recno SB1
                                                                                    aAdd(aRecTab[05,02], SC7->(Recno()))    // Recno SC7
                                                                                    aAdd(aRecTab[06,02], SDA->(Recno()))    // Recno SDA
                                                                                    aAdd(aRecTab[07,02], ZTN->(Recno()))    // Recno ZTN
                                                                                    // ###################### RETORNO NF IMPORTACAO #############################
                                                                                    //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,       Titulo Integracao, Msg Processamento }
                                                                                    //            {        01,                      02,      03,             04,         05,         06,              07,              08,                      09,                10 }
                                                                                    aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Retorno NF Importacao",      "Processo: " })
                                                                                    aParams := {}
                                                                                    aAdd(aParams, { { "cDocTho", "'" + cDocTho + "'" }, { "cSerTho", "'" + cSerTho + "'" }, { "cDatRec", "'" + cDatRec + "'" } }) // Variaveis auxiliares
                                                                                    aAdd(aTail(aMethds)[06], aClone(aParams))
                                                                                EndIf
                                                                            Else // Doc/Item nao possui controle de baixa CQ
                                                                                cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                                cMsg02 := "Item da Nota nao possui controle de baixa CQ (SDA)!"
                                                                                cMsg03 := "Verifique o item da nota e tente novamente!"
                                                                                cMsg04 := "Serie/Doc/Item: " + SD1->D1_SERIE + "/" + SD1->D1_DOC + "/" + SD1->D1_ITEM
                                                                                lRet := .F.
                                                                            EndIf
                                                                        Else // Pedido/Item nao encontrado (SC7)
                                                                            cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                            cMsg02 := "Pedido de compra da nota/item nao encontrado (SC7)!"
                                                                            cMsg03 := "Verifique o pedido de compra e tente novamente!"
                                                                            cMsg04 := "Serie/Doc/Item: " + SD1->D1_SERIE + "/" + SD1->D1_DOC + "/" + SD1->D1_ITEM
                                                                            lRet := .F.
                                                                        EndIf
                                                                    Else // Item da nota nao tem pedido de compra
                                                                        cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                        cMsg02 := "Item da Nota nao possui pedido de compra (SC7)!"
                                                                        cMsg03 := "Verifique o item da nota e tente novamente!"
                                                                        cMsg04 := "Serie/Doc/Item: " + SD1->D1_SERIE + "/" + SD1->D1_DOC + "/" + SD1->D1_ITEM
                                                                        lRet := .F.
                                                                    EndIf
                                                                Else // Produto nao encontrado (SB1)
                                                                    cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                                    cMsg02 := "Produto nao encontrado no cadastro (SB1)!"
                                                                    cMsg03 := "Produto: " + SW3->W3_COD_I
                                                                    cMsg04 := ""
                                                                    lRet := .F.
                                                                EndIf
                                                                SD1->(DbSkip())
                                                            End
                                                        EndIf
                                                    Else // Nota de entrada nao encontrada (SF1)
                                                        cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                        cMsg02 := "Documento/Serie nao encontrado no sistema (SF1)!"
                                                        cMsg03 := "Documento/Serie/Forn/Loja/Tipo: " + cNumDoc + "/" + cSerDoc + "/" + SA2->A2_COD + "/" + SA2->A2_LOJA + "/" + cTipDoc
                                                        cMsg04 := ""
                                                        lRet := .F.
                                                    EndIf
                                                Else // Fornecedor esta bloqueado no cadastro (SA2)
                                                    cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                    cMsg02 := "Fornecedor esta bloqueado no cadastro (SA2)!"
                                                    cMsg03 := "Fornecedor/Loja: " + SA2->A2_COD + "/" + SA2->A2_LOJA
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                EndIf
                                            Else // Fornecedor nao encontrado no cadastro (SA2)
                                                cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
                                                cMsg02 := "Fornecedor do documento nao encontrado no cadastro (SA2)!"
                                                cMsg03 := "Fornecedor/Loja: " + cForDoc + "/" + cLojDoc
                                                cMsg04 := ""
                                                lRet := .F.
                                            EndIf
                                        EndIf // Chave da Nota Entrada
                                    EndIf // Dados do cabecalho carregados
                                EndIf // Objeto montado
                            EndIf // Registro ZTN
                        EndIf // Empresa/Filial
                    EndIf // Status Totvs "09"
                    ZTN->(DbSkip())
                End
            EndIf // ZTN
        EndIf // "P"=Registro Posicionado
    EndIf // TipInt preenchido
EndIf // Mensagens processamento
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }
