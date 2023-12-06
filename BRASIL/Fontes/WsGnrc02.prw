#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc02 ºAutor ³Jonathan Schmidt Alves º Data ³06/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Notificacoes:                                              º±±
±±º          ³                                                            º±±
±±º          ³ WsRc2101: Obtencao das Notificacoes                        º±±
±±º          ³ WsRc2104: Atualizacao de Status das Notificacoes           º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                   WsGnrc02 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc2101 ºAutor ³Jonathan Schmidt Alves º Data ³08/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtencao das Notificacoes (Import/Export) C O N S U L T A  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Objetivo: Consultar todas as notificacoes e gravar no ZTN. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ ID Interface no In-Out: ?????                       Z T N  º±±
±±º          ³ API: ?????                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "?????"                                                 º±±
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

User Function WsRc2101()
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
// Variaveis Consultas Notificacoes
Local aConsults := {}
Local cCodEvent := ""
Local cDesEvent := ""
Local cCodStats := ""
Local cCodSiste := ""
Local cPkNumber := ""
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,                   02,                                                                03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Importacao", "Nota Fiscal",                                                                   "6002",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Transito e Compromisso",                                                        "6059",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento",            "6060",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Emissao de Pagamento/Adiantamento/Prestacao de Contas",                         "6062",     "1",         "9",,,,,   .T. })
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,            02,                                                                       03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Exportacao", "Nota Fiscal (Senf)",                                                            "6004",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Adiantamento de Despesas",                                                      "5055",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Pagamento",                                                                     "5054",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Prestacao de Contas",                                                           "5016",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Atualizacao de Vencimentos",                                                    "9001",     "1",         "2",,,,,   .T. })
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,            02,                                                                       03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Cambio Imp", "Notificacao Cambio Importacao",                                                 "6012",     "1",        "10",,,,,   .T. })
            aAdd(aConsults, { "Cambio Exp", "Notificacao Cambio Exportacao",                                                 "6011",     "1",        "11",,,,,   .T. })
            For _w1 := 1 To Len(aConsults)
                If aConsults[ _w1, 10 ] // .T.=Consulta Ativa, .F.=Consulta Inativa
                    If Empty(cIntPrcPsq) .Or. cIntPrcPsq == aConsults[ _w1, 03 ] // Todos os eventos ou evento especifico (chamada via tela)
                        // Posicionamentos Notificacoes:
                        aRecTab := { { "SM0", Array(0) } }
                        aAdd(aRecTab[01,02], SM0->(Recno()))    // Recno SM0
                        cCodEvent := aConsults[ _w1, 03 ]                                   // Codigo do Evento         Ex: "6002", "6059", "6060", etc
                        cDesEvent := aConsults[ _w1, 01 ] + " " + aConsults[ _w1, 02 ]      // Descricao do Evento      Ex: "Importacao Nota Fiscal"
                        cCodStats := aConsults[ _w1, 04 ]                                   // Codigo do Status         Ex: "1"=Pendente    "3"=Em Processamento  "4"=Processado com Erro   "2"=Processado com Sucesso
                        cCodSiste := aConsults[ _w1, 05 ]                                   // Codigo do Sistema        Ex: "9"=Tudo para importacao    "2"=Tudo para exportacao
                        cPkNumber := ""                                                     // PKNumber                 Ex: "" (nao usado)
                        // ###################### NOTIFICACOES #############################
                        //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,          Titulo Integracao,                               Msg Processamento }
                        //            {        01,                      02,      03,             04,         05,         06,              07,              08,                         09,                                              10 }
                        aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Consulta de Notificacoes", "Evento: " + cCodEvent + " " + RTrim(cDesEvent) })
                        aParams := {}
                        aAdd(aParams, { { "cCodEvent", "'" + cCodEvent + "'" }, { "cCodStats", "'" + cCodStats + "'" }, { "cCodSiste", "'" + cCodSiste + "'" }, { "cPkNumber", "'" + cPkNumber + "'" } }) // Variaveis auxiliares
                        aAdd(aTail(aMethds)[06], aClone(aParams))
                    EndIf // Todos os eventos ou evento especifico
                EndIf // Consulta "ativa"
            Next // Consultas
        EndIf // Tipo de integracao
    EndIf // Tipo de integracao
EndIf // Mensagens processamento
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsRc2104 ºAutor ³Jonathan Schmidt Alves º Data ³08/08/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao de Status das Notificacoes.   A T U A L I Z A  º±±
±±º          ³                                                            º±±
±±º          ³ ID Interface no In-Out: ?????                              º±±
±±º          ³ API: ?????                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Objetivo: Atualizar status de todas as notificacoes que ja º±±
±±º          ³ foram gravadas no ZTN e atualizar no Thomson para "3" para º±±
±±º          ³ que nao sejam mais enviadas.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01]: Nome da Api chamada                          º±±
±±º          ³    "?????"                                                 º±±
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

User Function WsRc2104()
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
// Variaveis auxiliares
Local cCodStats := ""
Local cMensa202 := ""
Local cMensa203 := ""
Local cMensa204 := ""
Local cMensa205 := ""
Local cMensa206 := ""
Local cMensa210 := ""
// Variaveis processamento
Local cNomApi := PARAMIXB[01]
Local cTipInt := PARAMIXB[02]
Local cTipReg := PARAMIXB[03]
Local nMsgPrc := PARAMIXB[04]
If nMsgPrc >= 0 // Mensagens processamento
    If !Empty(cTipInt) // Tipo de Integracao
        If cTipReg == "P" // "P"=Registro posicionado
            aConsults := {}
            // IdEven Codigos dos processos         Ex: "6059"=Transito e Compromisso   "6002"=Importacao (Nota Fiscal),  "6060"=Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento     "6062"=Emissao de Pagamento/Adiantamento/Prestacao de Contas
            // Status Status da notificacao         Ex: "1"=Pendente "3"=Em processamento Totvs "2"=Sucesso "4"=Erro
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,            02,                                                                       03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Importacao", "Nota Fiscal Entrada",                                                           "6002",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Nota Fiscal Entrada",                                                           "6002",     "3",         "9",,,,,   .T. })            
            aAdd(aConsults, { "Importacao", "Transito e Compromisso",                                                        "6059",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Transito e Compromisso",                                                        "6059",     "3",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento",            "6060",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Baixa do Transito/Abertura do Contas a Pagar/Baixa do Adiantamento",            "6060",     "3",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Emissao de Pagamento/Adiantamento/Prestacao de Contas",                         "6062",     "1",         "9",,,,,   .T. })
            aAdd(aConsults, { "Importacao", "Emissao de Pagamento/Adiantamento/Prestacao de Contas",                         "6062",     "3",         "9",,,,,   .T. })
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,                   02,                                                                03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Exportacao", "Nota Fiscal (Senf)",                                                            "6004",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Nota Fiscal (Senf)",                                                            "6004",     "3",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Adiantamento de Despesas",                                                      "5055",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Pagamento",                                                                     "5054",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Pagamento",                                                                     "5054",     "3",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Prestacao de Contas",                                                           "5016",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Inclusao de Titulos Receber Faturamento",                                       "9001",     "1",         "2",,,,,   .T. })
            aAdd(aConsults, { "Exportacao", "Inclusao de Titulos Receber Faturamento",                                       "9001",     "3",         "2",,,,,   .T. })
            //              {     Processo, Descricao da Notificacao,                                               Codigo Processo,  Status, Cod Sistema,,,,, Ativo }
            //              {           01,            02,                                                                       03,      04,          05,,,,,    10 }
            aAdd(aConsults, { "Cambio Imp", "Notificacao Cambio Importacao",                                                 "6012",     "1",        "10",,,,,   .T. })
            aAdd(aConsults, { "Cambio Imp", "Notificacao Cambio Importacao",                                                 "6012",     "3",        "10",,,,,   .T. })
            aAdd(aConsults, { "Cambio Exp", "Notificacao Cambio Exportacao",                                                 "6011",     "1",        "11",,,,,   .T. })
            aAdd(aConsults, { "Cambio Exp", "Notificacao Cambio Exportacao",                                                 "6011",     "3",        "11",,,,,   .T. })
            DbSelectArea("ZTN")
            ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
            For _w1 := 1 To Len(aConsults)
                If aConsults[ _w1, 10 ] // .T.=Ativado
                    If Empty(cIntPrcPsq) .Or. cIntPrcPsq == aConsults[ _w1, 03 ] // Todos os eventos ou evento especifico
                        If ZTN->(DbSeek( _cFilZTN + aConsults[ _w1, 03 ] + aConsults[ _w1, 04 ]))
                            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + aConsults[ _w1, 03 ] + aConsults[ _w1, 04 ]
                                If .T. // ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                                    If ZTN->ZTN_TIPTRA $ "1/2/" // Considerar apenas essas transacoes (Robson)
                                        cCodEvent := ZTN->ZTN_IDEVEN                                    // Codigo do Evento         Ex: "6002", "6059", "6060", etc
                                        cDesEvent := aConsults[ _w1, 01 ] + " " + aConsults[ _w1, 02 ]  // Descricao do Evento      Ex: "Importacao Nota Fiscal"
                                        cIdTransa := ZTN->ZTN_IDTRAN                                    // Id da transacao          Ex: "2120", "2735", "2800", "2736", "2281", etc
                                        cCodSiste := aConsults[ _w1, 05 ]                               // Codigo do Sistema        Ex: "9"=Tudo para importacao    "2"=Tudo para exportacao
                                        cPkNumber := RTrim(ZTN->ZTN_NUMB01)                             // Number Id                Ex: "10", "11", "13", etc
                                        cCodStats := ""
                                        cMensa202 := ""
                                        cMensa203 := ""
                                        cMensa204 := ""
                                        cMensa205 := ""
                                        cMensa206 := ""
                                        cMensa210 := ""
                                        // Atualiza Status das Notificacoes:
                                        If ZTN->ZTN_STATOT == "01" // "01"=Pendente                    
                                            cCodStats := "3"                                            // Status da notificacao    Ex: "1"=Pendente, "3"=Em Processamento Totvs    "4"=Processado com Erro     "2"=Processado com Sucesso
                                            cMensa210 := "Em processamento Totvs"
                                        ElseIf ZTN->ZTN_STATOT == "06" // "06"=Nota de Entrada gerada com sucesso no Totvs
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Pre-Nota/Nota de Entrada processada com sucesso!"
                                            ElseIf aConsults[ _w1, 03 ] $ "6004/"
                                                cCodStats := "2" //  "2"=Processado com Sucesso no Totvs
                                                cMensa202 := "Capa Atualizada"
                                            EndIf
                                        ElseIf ZTN->ZTN_STATOT == "07" // "07"=Sucesso processamento no Totvs
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Nota de Entrada transmitida com sucesso!" // Nota transmitida
                                            EndIf

                                        ElseIf ZTN->ZTN_STATOT == "08" // "08"=Sucesso processamento no Totvs
                                            
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                If !Empty( ZTN->ZTN_DETPR2 ) .And. (nChvPos := At(" ", RTrim(ZTN->ZTN_DETPR2))) > 0
                                                    cChvDoc := SubStr( ZTN->ZTN_DETPR2, nChvPos + 1, 25 ) // Chave da nota SF1
                                                    If !Empty( cChvDoc ) .And. cEmpAnt == Left( cChvDoc, 2)
                                                        DbSelectArea("SF1")
                                                        SF1->(DbSetOrder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
                                                        If SF1->(DbSeek( SubStr(cChvDoc,3,23) ))
                                                            If !Empty(SF1->F1_CHVNFE) .And. !("Sefaz" $ ZTN->ZTN_DETPR1) // Nota transmitida
                                                                cCodStats := "2" //  "2"=Processado com Sucesso no Totvs
                                                                cMensa202 := "Nota de importacao transmitida Sefaz (notificado Thomson)"
                                                            EndIf
                                                        EndIf
                                                    EndIf
                                                EndIf

                                            ElseIf aConsults[ _w1, 03 ] $ "6004/"
                                                cCodStats := "2" //  "2"=Processado com Sucesso no Totvs
                                                cMensa202 := "Senf enviada com sucesso!"
                                            ElseIf aConsults[ _w1, 03 ] $ "6011/" // Cambio Export
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa202 := "Titulo processado com sucesso!"
                                                DbSelectArea("ZTX")
                                                ZTX->(DbSetOrder(2)) // ZTX_FILIAL + ZTX_IDELAN
                                                If ZTX->(DbSeek( _cFilZTX + PadR(ZTN->ZTN_NUMB01,10) ))
                                                    If !Empty( ZTX->ZTX_CHVADT ) // Adiantamento
                                                        cMensa202 := "Adto " + Left(ZTX->ZTX_CHVADT,14)
                                                    ElseIf !Empty(ZTX->ZTX_CHVDES) // Titulo Receber
                                                        cMensa202 := "Tit. " + Left(ZTX->ZTX_CHVDES,14)
                                                    ElseIf !Empty(ZTX->ZTX_CHVBXA) // Titulo Baixado
                                                        cMensa202 := "Bxa. " + Left(ZTX->ZTX_CHVBXA,14)
                                                    EndIf
                                                EndIf
                                            ElseIf aConsults[ _w1, 03 ] $ "6012/" // Cambio Import
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                DbSelectArea("ZTY")
                                                ZTY->(DbSetOrder(2)) // ZTY_FILIAL + ZTY_IDELAN
                                                cMensa202 := "Titulo processado com sucesso!"
                                                If ZTY->(DbSeek( _cFilZTY + PadR(ZTN->ZTN_NUMB01,10) ))
                                                    If !Empty( ZTY->ZTY_CHVADT ) // Adiantamento
                                                        cMensa202 := "Adto " + Left(ZTY->ZTY_CHVADT,14)
                                                    ElseIf !Empty(ZTY->ZTY_CHVDES) // Titulo Pagar
                                                        cMensa202 := "Tit. " + Left(ZTY->ZTY_CHVDES,14)
                                                    ElseIf !Empty(ZTY->ZTY_CHVBXA) // Titulo Baixado
                                                        cMensa202 := "Bxa. " + Left(ZTY->ZTY_CHVBXA,14)
                                                    EndIf
                                                EndIf
                                            ElseIf aConsults[ _w1, 03 ] $ "6059/" // Transito (Lancamentos Contabeis CT2)
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := ZTN->ZTN_DETPR2 // Data: 21/09/2021 Doc: 990002
                                            ElseIf aConsults[ _w1, 03 ] $ "6060/" // Compromisso
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa202 := ZTN->ZTN_PVC202 // NF ou Compromisso
                                                cMensa203 := "Lanc Contabil gerado com sucesso: " + ZTN->ZTN_DETPR2 // Data: 21/09/2021 Doc: 990004
                                                cMensa205 := "Titulo gerado com sucesso: " + ZTN->ZTN_DETPR3 // "Titulos a Pagar gerados com sucesso!"
                                            ElseIf aConsults[ _w1, 03 ] $ "6062/" // Adiant/Despesas Importacao
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := ZTN->ZTN_DETPR1
                                            ElseIf aConsults[ _w1, 03 ] $ "5054/" // Inclusao Titulos Pagar Exportacao
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := ZTN->ZTN_DETPR1
                                            ElseIf aConsults[ _w1, 03 ] $ "9001/" // Inclusao Titulo Receber Faturamento
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := ZTN->ZTN_DETPR1
                                                cMensa204 := ZTN->ZTN_DETPR2
                                            EndIf
                                        ElseIf ZTN->ZTN_STATOT == "09" // "09"=Retorno NF processado com sucesso
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Retorno NF processado com sucesso!"
                                            EndIf
                                            
                                        ElseIf ZTN->ZTN_STATOT == "10" // "10"=Sucesso processamento no Totvs
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Sucesso no retorno XML Thomson (notificado Thomson)"
                                            ElseIf aConsults[ _w1, 03 ] $ "6004/" //ElseIf aConsults[ _w1, 03 ] $ "6004/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Nota de Saida enviada com sucesso!"
                                            EndIf

                                        ElseIf ZTN->ZTN_STATOT == "11" // "11"=Sucesso processamento no Totvs
                                            If aConsults[ _w1, 03 ] $ "6002/"
                                                cCodStats := "2" // "2"=Processado com Sucesso no Totvs
                                                cMensa203 := "Materiais da Nota de Entrada recebidos com sucesso!" // Materiais recebidos
                                            EndIf
                                        ElseIf ZTN->ZTN_STATOT == "41" // "41"=Falha no processamento XML no Totvs
                                            cCodStats := "4" // "4"=Processado com Falha no Totvs
                                            If aConsults[ _w1, 03 ] $ "6059/" // Inclusao Lancamento Contabil Transito
                                                cMensa202 := "Erro na geracao do lancamento contabil!" // Erro enviar no 2
                                            ElseIf aConsults[ _w1, 03 ] $ "6062/" // Adiant/Despesas Importacao
                                                cMensa202 := "Erro no processamento!"                                            
                                            ElseIf aConsults[ _w1, 03 ] $ "9001/" // Inclusao Titulo Receber Faturamento
                                                cMensa203 := ZTN->ZTN_DETPR1
                                                cMensa204 := ZTN->ZTN_DETPR2
                                            Else // Outros
                                                cMensa202 := ZTN->ZTN_DETPR1
                                                cMensa203 := ZTN->ZTN_DETPR2
                                            EndIf
                                        EndIf

                                        If !Empty(cCodStats) // Status atualizado
                                            // Posicionamentos Notificacoes:
                                            aRecTab := { { "ZTN", Array(0) } }
                                            aAdd(aRecTab[01,02], ZTN->(Recno()))    // Recno ZTN
                                            // ###################### ATUALIZA STATUS NOTIFICACOES #############################
                                            //            { Interface,                Nome Api, End Url, Tipo Interface,   Ambiente, Parametros,          Recnos,         aRepets,             Titulo Integracao,                               Msg Processamento }
                                            //            {        01,                      02,      03,             04,         05,         06,              07,              08,                            09,                                              10 }
                                            aAdd(aMethds, {        "",                 cNomApi,      "",        cTipInt,         "",   Array(0), aClone(aRecTab), aClone(aRepets), "Atualizacao de Notificacoes", "" })
                                            aParams := {}
                                            aAdd(aParams, { { "cCodEvent", "'" + cCodEvent + "'" }, { "cIdTransa", "'" + cIdTransa + "'" }, { "cCodStats", "'" + cCodStats + "'" }, { "cCodSiste", "'" + cCodSiste + "'" }, { "cMensa202", "'" + cMensa202 + "'" },;
                                            { "cMensa203", "'" + cMensa203 + "'" }, { "cMensa204", "'" + cMensa204 + "'" }, { "cMensa205", "'" + cMensa205 + "'" }, { "cMensa206", "'" + cMensa206 + "'" }, { "cMensa210", "'" + cMensa210 + "'" } }) // Variaveis auxiliares
                                            aAdd(aTail(aMethds)[06], aClone(aParams))
                                        EndIf

                                    EndIf // Transacao conforme
                                EndIf // Empresa/Filial conforme
                                ZTN->(DbSkip())
                            End
                        EndIf // ZTN posicionado
                    EndIf // Todos os eventos ou evento especifico
                EndIf // Consulta "ativa"
            Next // Consultas
        EndIf // "P"=Registro posicionado
    EndIf // Tipo de integracao
EndIf // Mensagens processamento
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04, aMethds }
