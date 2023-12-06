#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ JobMrp23 ºAutor ³ Jonathan Schmidt Alves ºData ³08/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do Job MRP.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Detalhes do funcionamento Job:                             º±±
±±º          ³                                                            º±±
±±º          ³ Esta funcao JobMrp23 deve ser chamada de x em x minutos    º±±
±±º          ³ conforme desejado. Evitar periodos muito curtos para       º±±
±±º          ³ evitar processamentos concorrentes.                        º±±
±±º          ³                                                            º±±
±±º          ³ Esta funcao avalia a tabela ZRP (Importacoes MRP) e faz os º±±
±±º          ³ processamentos da seguinte forma:                          º±±
±±º          ³                                                            º±±
±±º          ³ ZRP_FILIAL: Filial de processamento                        º±±
±±º          ³             Conforme a filial do processamento Ex: "02"    º±±
±±º          ³ ZRP_CODSTA: Codigo do Status do Registro                   º±±
±±º          ³             Apenas codigos "04"=Aprovados serao avaliados  º±±
±±º          ³ ZRP_QTDREC: Quantidade recalculada                         º±±
±±º          ³             Apenas quantidades positivas podem ser proces  º±±
±±º          ³                                                            º±±
±±º          ³ Sequencia de processamento:                                º±±
±±º          ³ 01: Periodos que nao possuem registros com problemas de    º±±
±±º          ³     validacao "VLD" ou problemas ExecAutos "ERR"           º±±
±±º          ³ 02: Periodos que possuem registros com problemas de        º±±
±±º          ³     validacao "VLD"                                        º±±
±±º          ³ 03: Periodos que possuem registros com problemas em        º±±
±±º          ³     ExecAutos "ERR"                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function JobMrp23()
Local _n1
Local _n2
Local _n3
Local nMsgPr := 0 // 0=Sem Mensagens (Job)
Local nTipPrc := 3 // 2=Validacao 3=Processar os ExecAutos
Local cQry := ""
Local cQryZRP := ""
Local nRecsZRP := 0
Local aQryOrd := {}
Local _cFilZRP := xFilial("ZRP")
Local _cSqlZRP := RetSqlName("ZRP")
Local aProcess := {} // Chamadas para processamento
ConOut("")
ConOut("")
ConOut("#################### JOBMRP23 Iniciando ####################")
ConOut("JobMrp23: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Query base
cQry := "SELECT DISTINCT ZRP_CODIGO, ZRP_PERIOD " + Chr(13) + Chr(10)
cQry += "FROM " + _cSqlZRP + " WHERE " + Chr(13) + Chr(10)
cQry += "ZRP_FILIAL = '" + _cFilZRP + "' AND " + Chr(13) + Chr(10)      // Filial conforme
cQry += "ZRP_CODSTA = '04' AND " + Chr(13) + Chr(10)                    // Status 04=Aprovado
cQry += "ZRP_QTDREC > 0 AND " + Chr(13) + Chr(10)                       // Quantidade Recalculada conforme
cQry += "D_E_L_E_T_ = ' ' AND " + Chr(13) + Chr(10)                     // Nao apagado
// 01: Processados com erros no ExecAuto
aAdd(aQryOrd, Array(0)) // Processados com erros de ExecAutos
aAdd(aQryOrd[01], {|| "ZRP_CREGRA = '" + StrZero(_n1,2) + "' AND "  })
aAdd(aQryOrd[01], {|| "(SUBSTR(ZRP_PROC01,1,3) = 'ERR' OR "         })
aAdd(aQryOrd[01], {|| "SUBSTR(ZRP_PROC02,1,3) = 'ERR') "            })
// 02: Processados com problemas de validacao
aAdd(aQryOrd, Array(0)) // Processados com problemas de validacao
aAdd(aQryOrd[02], {|| "ZRP_CREGRA = '" + StrZero(_n1,2) + "' AND "  })
aAdd(aQryOrd[02], {|| "(SUBSTR(ZRP_PROC01,1,3) = 'VLD' OR "         })
aAdd(aQryOrd[02], {|| "SUBSTR(ZRP_PROC02,1,3) = 'VLD') "            })
// 03: Ainda nao processados
aAdd(aQryOrd, Array(0)) // Ainda nao processados
aAdd(aQryOrd[03], {|| "ZRP_CREGRA = '" + StrZero(_n1,2) + "' AND "  })
aAdd(aQryOrd[03], {|| "ZRP_PROC01 = '" + Space(100) + "' AND "      })
aAdd(aQryOrd[03], {|| "ZRP_PROC02 = '" + Space(100) + "' "          })
For _n1 := 1 To 4 // Rodo em cada uma das 4 regras
    ConOut("JobMrp23: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Regra: " + StrZero(_n1,2))
    For _n2 := 1 To Len(aQryOrd) // Rodo nas 3 situacoes (Erros ExecAutos, Problemas Validacao, Nao processados)
        cQryZRP := cQry
        For _n3 := 1 To Len(aQryOrd[_n2]) // Rodo nos 3 complementos query
            cQryZRP += Eval(aQryOrd[_n2,_n3]) + Chr(13) + Chr(10) // Regra conforme
        Next
        cQryZRP += "ORDER BY ZRP_CODIGO"
        If Select("QRYZRP") > 0
            QRYZRP->(DbCloseArea())
        EndIf
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZRP),"QRYZRP",.F.,.F.)
        Count To nRecsZRP
        If nRecsZRP > 0 // Registros carregados
            QRYZRP->(DbGotop())
            While QRYZRP->(!EOF())
                If ASCan( aProcess, {|x|, x[04] == QRYZRP->ZRP_CODIGO .And. x[05] == StoD(QRYZRP->ZRP_PERIOD) }) == 0 // Importacao + Peridoo ainda nao considerado
                    //             {      Ordem Process,          Regra,       Situacao,  Codigo Importacao,    Periodo Processamento }
                    //             {                 01,             02,             03,                 04,                       05 }
                    aAdd(aProcess, { StrZero(4 - _n2,2), StrZero(_n1,2), StrZero(_n2,2), QRYZRP->ZRP_CODIGO, StoD(QRYZRP->ZRP_PERIOD) })
                EndIf
                QRYZRP->(DbSkip())
            End
        EndIf
    Next
Next
aSort(aProcess,,, {|x,y|, x[01] + x[04] + x[02] + DtoS(x[05]) < y[01] + y[04] + y[02] + DtoS(y[05]) }) // Ordenado por Ordem Processamento + Codigo Importacao + Regra + Periodo
For _n1 := 1 To Len(aProcess)
    ConOut("JobMrp23: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Codigo: " + aProcess[_n1,04] + " Periodo: " + DtoC(aProcess[_n1,05]) + "...")
    //      (   CodImportacao,  Periodo Process, MsgProc, Tipo Proc, Processamento, Relatorio Automatico)
    PrcMrp23(aProcess[_n1,04], aProcess[_n1,05],  nMsgPr,   nTipPrc,             0,                  .F.)
    ConOut("JobMrp23: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Codigo: " + aProcess[_n1,04] + " Periodo: " + DtoC(aProcess[_n1,05]) + "... Concluido!")
    Sleep(100)
Next
ConOut("JobMrp23: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut(" #################### JOBMRP23 Concluido ####################")
ConOut("")
ConOut("")
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsMrp23 ºAutor ³ Jonathan Schmidt Alves ºData ³08/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento via interface.                               º±±
±±º          ³                                                            º±±
±±º          ³ 1) Validacao Aprovacao:                                    º±±
±±º          ³ Para verificar se os registros da Importacao podem ser     º±±
±±º          ³ enviados para aprovacao (validando todos os registros)     º±±
±±º          ³                                                            º±±
±±º          ³ 2) Processamento                                           º±±
±±º          ³ Carregamento dos registros para procesar os ExecAutos      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ cCodImp: Codigo da importacao                              º±±
±±º          ³          Ex: "000013", "000016", etc                       º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³          Ex:0=Sem Mensagens (Job)                          º±±
±±º          ³             1=MsgStop                                      º±±
±±º          ³             2=AskYesNo                                     º±±
±±º          ³                                                            º±±
±±º          ³ nTipPrc: Tipo de processamento                             º±±
±±º          ³          Ex: 2=Validacao para aprovacao                    º±±
±±º          ³              3=Processamento dos execautos                 º±±
±±º          ³                                                            º±±
±±º          ³ nProc:   ExecAutos para processamento                      º±±
±±º          ³          Ex: 1=MATA120 nas regras 01 e 02                  º±±
±±º          ³              2=MATA410 nas regras 01 e 02                  º±±
±±º          ³                                                            º±±
±±º          ³              1=EICSI400 na regra 03 e MATA110 na regra 04  º±±
±±º          ³                                                            º±±
±±º          ³ lRelAut: Gera relatorio automatico                         º±±
±±º          ³          Ex: .T.=Gera automatico                           º±±
±±º          ³              .F.=Nao gera automatico                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function LdsMrp23(cCodImp, nMsgPr, nTipPrc, nProc, lRelAut)
Local y
Local _n1
Local lRet := .F.
Local lClear := .F.
Local aPeriod := {}
ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + ZRP_PERIOD
If ZRP->(DbSeek( _cFilZRP + cCodImp ))

    // Limpeza para reprocessamentos (Testes/Validacoes)
    If RetCodUsr() $ "000000/001478/" // Administrador/jonathan.sigamat
        If nMsgPr == 2 .And. nTipPrc == 3 .And. MsgYesNo("Limpa Logs/Procs ZRP?","SchMrp23")
            lClear := .T.
        EndIf
    EndIf

    While ZRP->(!EOF()) .And. ZRP->ZRP_FILIAL + ZRP->ZRP_CODIGO == _cFilZRP + cCodImp

        If lClear // .T.=Limpa
            RecLock("ZRP",.F.)
            ZRP->ZRP_CODSTA := "04"
            ZRP->ZRP_PROC01 := Space(100)
            ZRP->ZRP_LOGP01 := Space(100)
            ZRP->ZRP_PROC02 := Space(100)
            ZRP->ZRP_LOGP02 := Space(100)
            ZRP->(MsUnlock())
            If nMsgPr == 2 // 2=AskYesNo
                If (nLin := ASCan(oGetD1:aCols, {|x|, x[nP01RecZRP] == ZRP->(Recno()) })) > 0
                    oGetD1:aCols[nLin,nP01CodSta] := ZRP->ZRP_CODSTA
                    oGetD1:aCols[nLin,nP01Proc01] := ZRP->ZRP_PROC01
                    oGetD1:aCols[nLin,nP01LogP01] := ZRP->ZRP_LOGP01
                    oGetD1:aCols[nLin,nP01Proc02] := ZRP->ZRP_PROC02
                    oGetD1:aCols[nLin,nP01LogP02] := ZRP->ZRP_LOGP02
                    oGetD1:Refresh()
                EndIf
            EndIf
        EndIf
        // Alterado nTipPrc para 3=ExecAutos ou 2=Validacao
        If (ZRP->ZRP_CODSTA == "04" .And. (nTipPrc == 3 .Or. nTipPrc == 2)) .Or. (ZRP->ZRP_CODSTA == "01" .And. nTipPrc == 2) // Processamento e "04"=Aprovado ou Validacao para Aprovacao/Retorno
            If ZRP->ZRP_QTDREC > 0 .And. ASCan(aPeriod, {|x|, x == ZRP->ZRP_PERIOD }) == 0 // Quantidade Recalculada positiva e periodo ainda nao considerado
                aAdd(aPeriod, ZRP->ZRP_PERIOD)
            EndIf
        EndIf
        ZRP->(DbSkip())
    End
    If Len(aPeriod) > 0 // Periodos para processamento
        lRet := .T.
        _n1 := 1
        While _n1 <= Len(aPeriod) .And. lRet
            lRet := PrcMrp23(cCodImp, aPeriod[_n1], nMsgPr, nTipPrc, nProc, lRelAut)
            _n1++
        End
    Else // Nenhum periodo com dados para processamento
        If nMsgPr == 2 // 2=AskYesNo
            For y := 1 To 4
                u_AtuAsk09(nCurrent, "Nenhum periodo encontrado para validacao/processamento!", "", "", "" ,80, "UPDERROR")
                Sleep(800)
            Next
        ElseIf nMsgPr == 1 // 1=MsgStop
            MsgStop("Nenhum periodo encontrado para validacao/processamento!", "LdsMrp23")
        EndIf
    EndIf
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrcMrp23 ºAutor ³ Jonathan Schmidt Alves ºData ³17/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento dos periodos para processamentos dos MRP.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Empresas/Filiais:                                          º±±
±±º          ³                                                            º±±
±±º          ³ 01/02 CENTRO DE DISTRIBUICAO SP                            º±±
±±º          ³ 01/05 FABRICA GUARAREMA SP                                 º±±
±±º          ³ 03/01 FABRICA MANAUS AM                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 01: Fabricacao Guararema SP                          º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Pedido de Compra 01/02 CENTRO DE DISTRIBUICAO SP     º±±
±±º          ³ Fornecedor: 005764/05                                      º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Pedido de Venda 01/05 FABRICA GUARAREMA SP           º±±
±±º          ³ Cliente:	033467/02                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 02: Fabricacao Manaus AM                             º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Pedido de Compra 01/02 CENTRO DE DISTRIBUICAO SP     º±±
±±º          ³ Fornecedor: 005866/01                                      º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Pedido de Venda 03/01 FABRICA MANAUS AM              º±±
±±º          ³ Cliente:	033467/02                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 03: Solicitacao Importacao                           º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Solicitacao de Importacao 01/02 CENTRO DE DISTR SP   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 04: Compra Centro de Distribuicao                    º±±
±±º          ³                                                            º±±
±±º          ³ Gerar Solicitacao de Compras 01/02 CENTRO DE DISTR SP      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cCodImp: Codigo da planilha de importacao                  º±±
±±º          ³          Exemplo: "000001", "000002", etc                  º±±
±±º          ³                                                            º±±
±±º          ³ dPeriod: Periodo para o processamento                      º±±
±±º          ³          Exemplo: 01/05/2021                               º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³          Exemplo: 2=AskYesNo                               º±±
±±º          ³                                                            º±±
±±º          ³ nTipPrc: Tipo de Processamento                             º±±
±±º          ³          Exemplo: 2=Validacao do processamento             º±±
±±º          ³                   3=Validacao/Processamento dos ExecAutos  º±±
±±º          ³                                                            º±±
±±º          ³ nProc:   Processamento a avaliar                           º±±
±±º          ³          Exemplo: 0=Todos os processamentos                º±±
±±º          ³                   1=Processamento 01 (Ped Compra, Solicit) º±±
±±º          ³                   2=Processamento 02 (Ped Venda)           º±±
±±º          ³                                                            º±±
±±º          ³ lRelAut: Gera relatorio automatico                         º±±
±±º          ³          Ex: .T.=Gera automatico                           º±±
±±º          ³              .F.=Nao gera automatico                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PrcMrp23(cCodImp, dPeriod, nMsgPr, nTipPrc, nProc, lRelAut)
Local lRet := .T.
Local y
Local _w1
Local _w2
Local _w3
Local _w4
Local _w7
Local _w8
Local lVldPos := .T.
Local lVldExe := .T.
Local cMsVl01 := "Validando Processamento..."
Local cMsVl02 := ""
Local cMsVl03 := ""
Local cMsVl04 := ""
Local aProcs := {}
Local aRegra := {}
Local aExecs := {}
// Empresa Filial original
Local cEmpOrig := cEmpAnt
Local cFilOrig := cFilAnt
Local cDtHrPrc := DtoC(Date()) + " " + Time() + " " + cUserName // "20210330" + "113245"
Local nLastUpdate := Seconds()
// ##################################################
// ### Parte 01: Carregamento da matriz de regras ###
// ##################################################
aRegra := LdsRegra()
// ######################################
// ### Parte 02: Abertura das tabelas ###
// ######################################
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("SC5")
SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
DbSelectArea("SC6")
SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
DbSelectArea("SC7")
SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM + C7_ITEM
DbSelectArea("SC1")
SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
DbSelectArea("SW0")
SW0->(DbSetOrder(1)) // W0_FILIAL + W0_CC + W0_NUM
DbSelectArea("SW1")
SW1->(DbSetOrder(1)) // W1_FILIAL + W1_CC + W1_SI_NUM + W1_COD_I + ...
DbSelectArea("ZRP")
ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + ZRP_PERIOD
// Filiais compartilhadas
Private _cFilZRP := xFilial("ZRP")
Private _cFilSA2 := xFilial("SA2")
Private _cFilSE4 := xFilial("SE4")
Private _cFilSB1 := xFilial("SB1")
Private _cFilSB2 := xFilial("SB2")
Private _cFilSA1 := xFilial("SA1")
Private _cFilSA4 := xFilial("SA4")
Private _cFilCTT := xFilial("CTT")
Private _cFilDA1 := xFilial("DA1")
If nMsgPr == 2 // 2=AskYesNo
    For y := 1 To 4
        u_AtuAsk09(nCurrent, "Validando Processamento...", "Importacao: " + cCodImp, "", "", 80, "PROCESSA")
        Sleep(050)
    Next
EndIf
// ##############################################################
// ### Parte 03: Identificacao da regra e validacoes iniciais ###
// ##############################################################
DbSelectArea("ZRP")
ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + ZRP_PERIOD
If ZRP->(DbSeek( _cFilZRP + cCodImp ))
    While ZRP->(!EOF()) .And. ZRP->ZRP_FILIAL + ZRP->ZRP_CODIGO == _cFilZRP + cCodImp .And. lVldPos
        If ZRP->ZRP_PERIOD == dPeriod // Periodo conforme
            If ZRP->ZRP_QTDREC > 0 // Quantidade Recalculada nao zerada
                If nTipPrc == 2 .Or. (nTipPrc == 3 .And. ZRP->ZRP_CODSTA == "04") // "04"=Aprovado
                    If (_w1 := ASCan(aRegra, {|x|, x[01] == ZRP->ZRP_CREGRA })) > 0 // Regra identificada
                        For _w2 := 1 To Len( aRegra[ _w1, 10 ] ) // MATA110, MATA120, MATA410, etc
                            If (nFnd := ASCan( aProcs, {|x|, x[01] == ZRP->ZRP_CREGRA .And. x[02] + x[03] == aRegra[ _w1, 10, _w2, 01] + aRegra[ _w1, 10, _w2, 02] .And. x[04] == aRegra[ _w1, 10, _w2, 04] })) == 0
                                //           {              01,                        02,                        03,                        04, {             05 } }
                                aAdd(aProcs, { ZRP->ZRP_CREGRA, aRegra[ _w1, 10, _w2, 01], aRegra[ _w1, 10, _w2, 02], aRegra[ _w1, 10, _w2, 04], { ZRP->(Recno()) } })
                            Else
                                aAdd(aProcs[nFnd,05], ZRP->(Recno()))
                            EndIf
                        Next
                    EndIf
                EndIf
            EndIf
        EndIf
        ZRP->(DbSkip())
    End
EndIf
If Len( aProcs ) > 0 // Registros ZRP para avaliacao
    For _w7 := 1 To Len(aProcs) // Regras
        If (_w1 := ASCan(aRegra, {|x|, x[01] == aProcs[_w7,01] })) > 0 // Regra identificada
            If nMsgPr == 2 // 2=AskYesNo
                _oMeter:nTotal := Len(aProcs[ _w7, 05 ])
                cRegs := cValToChar(_oMeter:nTotal)
                nCurrent := 0
            EndIf
            If cEmpAnt + cFilAnt <> aProcs[ _w7, 02 ] + aProcs[ _w7, 03 ] // Empresa / Filial diferente
                _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED", "ZRP" } // Array contendo os Alias a serem abertos na troca de Emp/Fil
                _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
                u_UPDEMPFIL(aProcs[ _w7, 02 ], aProcs[ _w7, 03 ], _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
            EndIf
            For _w8 := 1 To Len( aProcs[ _w7, 05 ] ) // Recnos
                If nMsgPr == 2 // AskYesNo
                    nCurrent++
                EndIf
                If (_w2 := ASCan(aRegra[_w1,10], {|x|, x[04] == aProcs[_w7,04] })) > 0 // MATA110, MATA120, MATA410, etc
                    ZRP->(DbGoto( aProcs[ _w7,05,_w8 ] )) // Reposiciono ZRP
                    If lVldPos .Or. lRelAut // .T.=Valido processamento ou .T.=Relatorio Automatico (entao deixa prosseguir mesmo com erros)
                        cMsVl02 := ""
                        cMsVl03 := ""
                        cMsVl04 := ""
                        If SB1->(DbSeek(_cFilSB1 + ZRP->ZRP_CODPRO))
                            If SB1->B1_MSBLQL <> "1" // "1"=Bloqueado
                                If ZRP->ZRP_CUSUNI > 0 // Custo Unitario valido
                                    If lVldPos .Or. lRelAut // Ainda valido
                                        // Processamentos
                                        If nProc == 0 .Or. nProc == _w2 // Processamento conforme
                                            cMsVl02 := "Regra: " + aRegra[ _w1, 01] + " " + aRegra[ _w1, 02] + "     Processo: " + aRegra[ _w1, 10, _w2, 04 ]
                                            cMsVl03 := "Produto: " + RTrim(SB1->B1_COD) + " " + RTrim(SB1->B1_DESC)
                                            cMsVl04 := ""
                                            cProces := &("ZRP->ZRP_PROC" + StrZero(_w2,2))    // Processamento
                                            cLogPro := &("ZRP->ZRP_LOGP" + StrZero(_w2,2))    // Log de Processamento (Data+Hora)
                                            // Processamento ainda nao foi realizado com sucesso (nao realizado ou com alguma falha)
                                            If !Empty(cProces) .And. !Empty( cLogPro )
                                                cDatPro := DtoS(CtoD( Left(cLogPro, At(" ",cLogPro) - 1) ))             // Data processamento
                                                cHorPro := StrTran(SubStr( cLogPro, At(" ",cLogPro) + 1, 10),":","")    // Hora processamento
                                                If Left(cProces,3) == Left(aRegra[ _w1, 10, _w2, 05 ],3) // Ja foi processado com sucesso "SC1", "SC5, "SC7" ou "SW0"
                                                    cMsVl04 := "Registro ja foi processado! Produto: " + SB1->B1_COD
                                                    lVldPos := .F.
                                                ElseIf Left(cProces,3) == "PRC" .And. Val( DtoS(Date()) + StrTran(Time(),":","") ) - Val(cDatPro + cHorPro) < 1800 // Em preparacao para processamento...
                                                    cMsVl04 := "Preparacao para processamento identificada! Tente novamente em alguns minutos!"
                                                    lVldPos := .F.
                                                EndIf
                                            EndIf
                                            If lVldPos .Or. lRelAut // Ainda valido
                                                If nMsgPr == 2 // 2=AskYesNo
                                                    If (Seconds() - nLastUpdate) > 0 // Se passou 1 segundo desde a última atualização da tela
                                                        For y := 1 To 4
                                                            u_AtuAsk09(nCurrent, cMsVl01 + " " + cValToChar(nCurrent) + "/" + cRegs, cMsVl02, cMsVl03, "", 80, "PROCESSA")
                                                            Sleep(050)
                                                        Next
                                                        nLastUpdate := -10
                                                    EndIf
                                                EndIf
                                                // Validacoes Posicionamentos
                                                For _w3 := 1 To Len( aRegra[ _w1, 10, _w2, 11 ] )
                                                    If lVldPos .Or. lRelAut // .T.=Ainda valido
                                                        If !&(aRegra[ _w1, 10, _w2, 11, _w3, 02 ]) // Validacoes Posicionamentos
                                                            cMsVl04 := Eval(aRegra[ _w1, 10, _w2, 11, _w3, 03 ])
                                                            lVldPos := .F.
                                                        EndIf
                                                    EndIf
                                                Next
                                                // Posicionamentos
                                                If lVldPos // .T.=Ainda valido
                                                    For _w3 := 1 To Len(aRegra[_w1,10,_w2,12])
                                                        If (aRegra[_w1,10,_w2,12,_w3,01])->(!EOF())
                                                            aAdd(aRegra[_w1,10,_w2,12,_w3,02], (aRegra[_w1,10,_w2,12,_w3,01])->(Recno()))     // ZRP, SA2, SE4, SB1
                                                        Else
                                                            aAdd(aRegra[_w1,10,_w2,12,_w3,02], 0)
                                                        EndIf
                                                    Next
                                                EndIf
                                            EndIf
                                        EndIf
                                    EndIf
                                Else // Custo Unitario invalido
                                    cMsVl03 := "Produto: " + RTrim(SB1->B1_COD) + " " + RTrim(SB1->B1_DESC)
                                    cMsVl04 := "Custo Unitario invalido para o produto (ZRP_CUSUNI)!"
                                    lVldPos := .F.
                                EndIf
                            Else // Produto bloqueado no cadastro SB1
                                cMsVl03 := "Produto: " + RTrim(SB1->B1_COD) + " " + RTrim(SB1->B1_DESC)
                                cMsVl04 := "Produto esta bloqueado no cadastro (SB1)!"
                                lVldPos := .F.
                            EndIf
                        Else // Produto nao encontrado no cadastro SB1
                            cMsVl03 := "Produto: " + ZRP->ZRP_CODPRO
                            cMsVl04 := "Produto nao encontrado no cadastro (SB1): '" + ZRP->ZRP_CODPRO
                            lVldPos := .F.
                        EndIf
                    EndIf
                    If lVldPos // Regra identificada e tudo validado nos processamentos (MATA110, MATA120, MATA410
                        If nMsgPr == 2 // 2=AskYesNo
                            If nLastUpdate < 0 // Houve atualizacao
                                For y := 1 To 2
                                    u_AtuAsk09(nCurrent, cMsVl01 + " " + cValToChar(nCurrent) + "/" + cRegs + " Sucesso!", cMsVl02, cMsVl03, "", 80, "OK")
                                    Sleep(050)
                                Next
                                nLastUpdate := Seconds()
                            EndIf
                        EndIf
                    EndIf
                Else // Regra identificada
                    cMsVl03 := "Produto: " + RTrim(SB1->B1_COD) + " " + RTrim(SB1->B1_DESC)
                    cMsVl04 := "Nenhuma Regra foi identificada para o produto!"
                    lVldPos := .F.
                EndIf
                If !lVldPos // Invalido
                    If lRelAut // .T.=Relatorio automatico... vou armazenando as inconsistencias
                        // Mostro AskYesNo com cada um dos problemas
                        If nMsgPr == 2 // 2=AskYesNo
                            For y := 1 To 4
                                u_AtuAsk09(nCurrent, cMsVl01 + " Falha!", cMsVl02, cMsVl03, cMsVl04 ,80, "UPDERROR")
                                Sleep(1000)
                            Next
                        EndIf
                    Else
                        Exit
                    EndIf
                EndIf
            Next
        EndIf
    Next
    If !lVldPos .And. !Empty(cMsVl04) // Invalido com mensagem
        // Gravar mensagem de problema de validacao no ZRP
        RecLock("ZRP",.F.)
        &("ZRP->ZRP_PROC" + StrZero( Min( Max(_w2,1), 2) ,2)) := "VLD " + cMsVl04                                   // Processamento
        &("ZRP->ZRP_LOGP" + StrZero( Min( Max(_w2,1), 2) ,2)) := DtoC(Date()) + " " + Time() + " " + cUserName      // Log Processamento
        ZRP->(MsUnlock())
        If Type("oDlg01") == "O" .And. Type("oGetD1") == "O" // Chamado via tela
            If (nLin := ASCan( oGetD1:aCols, {|x|, x[nP01RecZRP] == ZRP->(Recno()) })) > 0
                oGetD1:aCols[ nLin, &("nP01Proc" + StrZero( Min( Max(_w2,1), 2) ,2)) ] := &("ZRP->ZRP_PROC" + StrZero( Min( Max(_w2,1), 2) ,2))
                oGetD1:aCols[ nLin, &("nP01LogP" + StrZero( Min( Max(_w2,1), 2) ,2)) ] := &("ZRP->ZRP_LOGP" + StrZero( Min( Max(_w2,1), 2) ,2))
                oGetD1:Refresh()
            EndIf
        EndIf
        If nTipPrc == 2 // 2=Validacao para processamento (Richely)
            MsgStop(cMsVl01 + Chr(13) + Chr(10) + ;
            cMsVl02 + Chr(13) + Chr(10) + ;
            cMsVl03 + Chr(13) + Chr(10) + ;
            cMsVl04,"PrcMrp23")
        Else
            If nMsgPr == 2 // 2=AskYesNo
                For y := 1 To 4
                    u_AtuAsk09(nCurrent, cMsVl01 + " Falha!", cMsVl02, cMsVl03, cMsVl04 ,80, "UPDERROR")
                    Sleep(1000)
                Next
            ElseIf nMsgPr == 1 // 1=MsgStop
                MsgStop(cMsVl01 + Chr(13) + Chr(10) + ;
                cMsVl02 + Chr(13) + Chr(10) + ;
                cMsVl03 + Chr(13) + Chr(10) + ;
                cMsVl04,"PrcMrp23")
            EndIf
        EndIf
    EndIf
    // ############################################################
    // ### Parte 04: Validacoes Gerais e Montagem dos ExecAutos ###
    // ############################################################
    If lVldPos // .T.=Valido
        cMsVl01 := "Preparando os ExecAutos para validacao..."
        cMsVl02 := "Periodo: " + DtoC(dPeriod)
        cMsVl03 := ""
        cMsVl04 := "" // Importacao: " + cCodImp
        If nTipPrc >= 2 // 2=Valida a Montagem dos ExecAutos
            If nTipPrc >= 3 // 3=Processamento dos ExecAutos... entao vamos marcar como "Em Processamento"
                cMsVl01 := "Preparando os ExecAutos para processamento..."
                For _w1 := 1 To Len(aRegra)
                    For _w2 := 1 To Len(aRegra[_w1,10]) // Rodo nos processos MATA120, MATA410, etc
                        // Controle de processamentos (Job/Tela) Verifico se nao foi iniciado algum processamento desta planilha
                        For _w4 := 1 To Len( aRegra[_w1,10,_w2,12,01,02] ) // Recnos ZRP
                            ZRP->(DbGoto( aRegra[_w1,10,_w2,12,01,02,_w4] ))
                            RecLock("ZRP",.F.)
                            &("ZRP->ZRP_PROC" + StrZero(_w2,2))  := "PRC Em Processamento..."   // Processamento
                            &("ZRP->ZRP_LOGP" + StrZero(_w2,2))  := cDtHrPrc                    // Log de Processamento (Data+Hora)
                            ZRP->(MsUnlock())
                            If Type("oDlg01") == "O" .And. Type("oGetD1") == "O" // Chamado via tela
                                If (nLin := ASCan(oGetD1:aCols, {|x|, x[nP01RecZRP] == aRegra[_w1,10,_w2,12,01,02,_w4] })) > 0
                                    ZRP->(DbGoto(aRegra[_w1,10,_w2,12,01,02,_w4])) // Reposiciono ZRP
                                    oGetD1:aCols[ nLin, nP01Proc01 ] := ZRP->ZRP_PROC01
                                    oGetD1:aCols[ nLin, nP01LogP01 ] := ZRP->ZRP_LOGP01
                                    oGetD1:aCols[ nLin, nP01Proc02 ] := ZRP->ZRP_PROC02
                                    oGetD1:aCols[ nLin, nP01LogP02 ] := ZRP->ZRP_LOGP02
                                    oGetD1:Refresh()
                                    Sleep(010)
                                EndIf
                            EndIf
                        Next
                    Next
                Next
            EndIf
            If nMsgPr == 2 // 2=AskYesNo
                For y := 1 To 4
                    u_AtuAsk09(nCurrent, cMsVl01, cMsVl02, "", "", 80, "PROCESSA")
                    Sleep(050)
                Next
            EndIf
            For _w1 := 1 To Len(aRegra) // Rodo nas regras
                For _w2 := 1 To Len( aRegra[ _w1, 10 ]) // Rodo nos processos MATA120, MATA410, etc
                    If ASCan( aRegra[ _w1, 10, _w2, 12 ], {|x|, Len(x[02]) > 0 }) > 0 // Registros de posicionamentos carregados
                        If lVldExe // ExecAutos todos montados com sucesso
                            If cEmpAnt + cFilAnt <> aRegra[ _w1, 10, _w2, 01 ] + aRegra[ _w1, 10, _w2, 02 ] // Empresa / Filial diferente
                                nRecZRP := ZRP->(Recno())
                                _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED", "ZRP" } // Array contendo os Alias a serem abertos na troca de Emp/Fil
                                _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
                                u_UPDEMPFIL(aRegra[_w1,10,_w2,01],aRegra[_w1,10,_w2,02],_aTabsSX,_aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
                                ZRP->(DbGoto( nRecZRP ))
                            EndIf
                            // Chamo montagem do ExecAuto passando os posicionamentos
                            If ExistBlock( aRegra[ _w1, 10, _w2, 05 ] ) // Funcao ja compilada
                                //                   Funcao Montagem ExecAuto  , .F., .F., { Registros Posicionamentos , Variaveis Auxiliares       }
                                aExecs := ExecBlock( aRegra[ _w1, 10, _w2, 05 ], .F., .F., { aRegra[ _w1, 10, _w2, 12 ], aRegra[ _w1, 10, _w2, 13 ] })
                                If lVldExe := (Len(aExecs) > 0) // ExecAuto(s) montado(s)
                                    aRegra[ _w1, 10, _w2, 14 ] := aClone( aExecs ) // Inclusao do(s) ExecAuto(s) montados
                                Else // Falha na montagem do ExecAuto
                                    cMsVl03 := "Processo: " + aRegra[ _w1, 01 ] + " " + aRegra[ _w1, 02 ]
                                    cMsVl04 := "Falha na preparacao do ExecAuto: " + aRegra[ _w1, 10, _w2, 04 ]
                                    If nTipPrc == 2 // 2=Validacao para Processamento (Richely)
                                        MsgStop(cMsVl01 + Chr(13) + Chr(10) + ;
                                        cMsVl02 + Chr(13) + Chr(10) + ;
                                        cMsVl03 + Chr(13) + Chr(10) + ;
                                        cMsVl04,"PrcMrp23")
                                    Else
                                        If nMsgPr == 2 // 2=AskYesNo
                                            For y := 1 To 4
                                                u_AtuAsk09(nCurrent, cMsVl01 + " Falha!", cMsVl02, cMsVl03, cMsVl04, 80, "UPDERROR")
                                                Sleep(500)
                                            Next
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                Next
            Next
            If nTipPrc >= 3 // 3=Processa os ExecAutos
                // #############################################
                // ### Parte 05: Processamento dos ExecAutos ###
                // #############################################
                If lVldExe // .T.=ExecAutos montados com sucesso
                    If nMsgPr == 2 // 2=AskYesNo
                        For y := 1 To 4
                            u_AtuAsk09(nCurrent, cMsVl01 + " Sucesso!", "", "", "", 80, "OK")
                            Sleep(100)
                        Next
                    EndIf
                    // Processamento dos ExecAutos montados (com Adequacoes de Blocos de Codigo dos ExecAutos)
                    For _w1 := 1 To Len(aRegra)
                        If lVldExe // Ainda valido
                            For _w2 := 1 To Len(aRegra[_w1,10]) // Rodo nos processos MATA120, MATA410, etc
                                // Controle de processamentos (Job/Tela) Verifico se nao foi iniciado algum processamento desta planilha
                                For _w4 := 1 To Len( aRegra[_w1,10,_w2,12,01,02] ) // Recnos ZRP
                                    ZRP->(DbGoto( aRegra[_w1,10,_w2,12,01,02,_w4] ))
                                    cProces := &("ZRP->ZRP_PROC" + StrZero(_w2,2))    // Processamento
                                    cLogPro := &("ZRP->ZRP_LOGP" + StrZero(_w2,2))    // Log de Processamento (Data+Hora)
                                    If Left(cProces,3) == "PRC" // Em processamento...
                                        cDatPro := DtoS(CtoD( Left(cLogPro, At(" ",cLogPro) - 1) ))             // Data processamento
                                        cHorPro := StrTran(SubStr( cLogPro, At(" ",cLogPro) + 1, 20),":","")    // Hora processamento
                                        If RTrim(cDtHrPrc) <> RTrim(cLogPro) // Nao eh o meu processamento... interromper
                                            
                                            // Ponto de seguranca para casos em que o Job pode estar rodando 2 ou mais vezes ao mesmo tempo
                                            If nMsgPr == 2 // 2=AskYesNo
                                                MsgYesNo("Prossegue com processamento?","SchMrp23")
                                            Else // Job
                                                lVldExe := .F.
                                            EndIf

                                        EndIf
                                    EndIf
                                Next
                                If lVldExe // .T.=Ainda valido
                                    aExecs := aRegra[_w1,10,_w2,14]
                                    For _w3 := 1 To Len(aExecs) // Rodo nos execautos montados
                                        If cEmpAnt + cFilAnt <> aRegra[_w1,10,_w2,01] + aRegra[_w1,10,_w2,02] // Empresa / Filial diferente
                                            nRecZRP := ZRP->(Recno())
                                            _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED", "ZRP" } // Array contendo os Alias a serem abertos na troca de Emp/Fil
                                            _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
                                            u_UPDEMPFIL(aRegra[_w1,10,_w2,01],aRegra[_w1,10,_w2,02],_aTabsSX,_aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
                                            ZRP->(DbGoto( nRecZRP ))
                                        EndIf
                                        If lVldExe // .T.=Valido para processamento
                                            If ExistBlock( aRegra[ _w1, 10, _w2, 06 ] ) // Funcao de Proc ExecAuto existe
                                                If aRegra[ _w1, 10, _w2, 04 ] == "MATA110"
                                                    // Carregamento do prox numero da solicitacao
                                                    _cFilSC1 := xFilial("SC1")
                                                    SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM
                                                    While SC1->(DbSeek(_cFilSC1 + (cSolCom := GetSXENum("SC1","C1_NUM")) )) // Verifico carregando
                                                        ConfirmSX8()
                                                    End
                                                    // Verificando maior numeracao
                                                    SC1->(DbSeek(_cFilSC1 + "ZZZZZZ",.T.))
                                                    If SC1->C1_FILIAL <> _cFilSC1
                                                        SC1->(DbSkip(-1))
                                                    EndIf 
                                                    If SC1->C1_FILIAL == _cFilSC1 .And. cSolCom <= SC1->C1_NUM
                                                        cSolCom := Soma1(SC1->C1_NUM,6)
                                                    EndIf
                                                    aExecs[ _w3, 02, 01, 02 ] := cSolCom // Numero da solicitacao compra
                                                ElseIf aRegra[ _w1, 10, _w2, 04 ] == "MATA120"
                                                    // Carregamento do prox numero do pedido
                                                    _cFilSC7 := xFilial("SC7")
                                                    SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM + C7_ITEM
                                                    While SC7->(DbSeek(_cFilSC7 + (cPedCom := GetSXENum("SC7")) )) // Verifico carregando
                                                        ConfirmSX8() // Confirmo uso
                                                    End
                                                    aExecs[ _w3, 02, 01, 02 ] := cPedCom // Numero do pedido obtido
                                                ElseIf aRegra[ _w1, 10, _w2, 04 ] == "EICSI400" // Importacao
                                                    // Carregamento do prox numero da Solicitacao // cNumSI:= NextNumEIC()
                                                    _cFilSW0 := xFilial("SW0")
                                                    SW0->(DbSetOrder(1)) // W0_FILIAL + W0_CC + W0_NUM
                                                    While SW0->(DbSeek(_cFilSW0 + (cSolImp := GetSXENum("SW0")) )) // Verifico carregando
                                                        ConfirmSX8() // Confirmo uso
                                                    End
                                                    aExecs[ _w3, 02, 01, 02 ] := cSolImp // Numero da solicitacao  importacao (Linha reativada 05/05/2021 Jonathan)
                                                EndIf
                                                If nMsgPr == 2 // 2=AskYesNo
                                                    For y := 1 To 4
                                                        u_AtuAsk09(nCurrent, aRegra[ _w1, 10, _w2, 08 ] + " (" + aRegra[ _w1, 10, _w2, 04 ] + ")...", "Emp/Fil: " + aRegra[ _w1, 10, _w2, 01 ] + "/" + aRegra[ _w1, 10, _w2, 02 ] + " " + aRegra[ _w1, 10, _w2, 03 ], "", "", 80, "PROCESSA")
                                                        Sleep(050)
                                                    Next
                                                EndIf

                                                If .F. // aRegra[ _w1, 10, _w2, 04 ] $ "MATA110/MATA120/MATA410/" // /EICSI400/"
                                                    aReturn := u_PrepExec(cEmpAnt, cFilAnt, nMsgPr, aRegra[ _w1, 10, _w2, 06 ], aRegra[ _w1, 10, _w2, 07 ], aRegra[ _w1, 10, _w2, 08 ], "Aguarde...", { aExecs[ _w3 ], aRegra[ _w1, 10, _w2, 12 ], aRegra[ _w1, 10, _w2, 13 ] })
                                                Else // Importacao
                                                    //                  Funcao Processamen ExecAuto , .F., .F., { Dados ExecAut, Registros Posicionamentos , Variaveis Auxiliares       }
                                                    aReturn := ExecBlock( aRegra[ _w1, 10, _w2, 06 ], .F., .F., { aExecs[ _w3 ], aRegra[ _w1, 10, _w2, 12 ], aRegra[ _w1, 10, _w2, 13 ] })
                                                EndIf
                                                
                                                If aReturn[01] == 1 // 1=Falha
                                                    For _w4 := 1 To Len(aExecs[ _w3, 04 ]) // Len( aRegra[ _w1, 10, _w2, 12, 01, 02 ] )
                                                        ZRP->(DbGoto( aRegra[ _w1, 10, _w2, 12, 01, 02, aExecs[ _w3, 04, _w4 ] ] )) // Reposiciono ZRP
                                                        RecLock("ZRP",.F.)
                                                        &("ZRP->ZRP_PROC" + StrZero(_w2,2)) := "ERR " + aRegra[ _w1, 10, _w2, 08 ]                                              // Processamento
                                                        &("ZRP->ZRP_LOGP" + StrZero(_w2,2)) := DtoC(Date()) + " " + Time() + " " + cUserName                                    // Log Processamento
                                                        ZRP->(MsUnlock())
                                                    Next
                                                    lVldExe := .F.
                                                Else // 2=Sucesso
                                                    If aRegra[ _w1, 10, _w2, 04 ] == "MATA110"
                                                        ConfirmSX8()
                                                    ElseIf aRegra[ _w1, 10, _w2, 04 ] == "MATA120"
                                                        ConfirmSX8()
                                                    EndIf
                                                    // Sucesso.. entao vamos atualizar o status do registro ZRP_CODSTA caso ja tenha realizado os 2 processamentos ou for apenas 1 e esse foi com sucesso
                                                    If _w2 == Len( aRegra[_w1,10] )
                                                        // Sucesso geral
                                                        For _w4 := 1 To Len(aExecs[ _w3, 04 ]) // Len( aRegra[ _w1, 10, _w2, 12, 01, 02 ] )
                                                            ZRP->(DbGoto( aRegra[ _w1, 10, _w2, 12, 01, 02, aExecs[ _w3, 04, _w4 ] ] )) // Reposiciono ZRP
                                                            RecLock("ZRP",.F.)
                                                            ZRP->ZRP_CODSTA := "05" // "05"=Processado
                                                            ZRP->(MsUnlock())
                                                            If Type("oDlg01") == "O" .And. Type("oGetD1") == "O" // Chamado via tela
                                                                If (nLin := ASCan( oGetD1:aCols, {|x|, x[nP01RecZRP] == ZRP->(Recno()) })) > 0
                                                                    oGetD1:aCols[ nLin, nP01CodSta ] := ZRP->ZRP_CODSTA
                                                                    oGetD1:Refresh()
                                                                EndIf
                                                            EndIf
                                                        Next
                                                    EndIf
                                                    If nMsgPr == 2 // 2=AskYesNo
                                                        For y := 1 To 4
                                                            u_AtuAsk09(nCurrent, aRegra[ _w1, 10, _w2, 08 ] + " (" + aRegra[ _w1, 10, _w2, 04 ] + ")... Sucesso!", "Emp/Fil: " + aRegra[ _w1, 10, _w2, 01 ] + "/" + aRegra[ _w1, 10, _w2, 02 ] + " " + aRegra[ _w1, 10, _w2, 03 ], "", "", 80, "OK")
                                                            Sleep(150)
                                                        Next
                                                    EndIf
                                                EndIf
                                                If nMsgPr == 2 // 2=AskYesNo
                                                    If Type("oDlg01") == "O" .And. Type("oGetD1") == "O" // Chamado via tela
                                                        For _w4 := 1 To Len(aExecs[ _w3, 04 ]) // Len( aRegra[ _w1, 10, _w2, 12, 01, 02 ] )
                                                            If (nLin := ASCan( oGetD1:aCols, {|x|, x[nP01RecZRP] == aRegra[ _w1, 10, _w2, 12, 01, 02, aExecs[ _w3, 04, _w4 ] ] })) > 0
                                                                ZRP->(DbGoto( aRegra[ _w1, 10, _w2, 12, 01, 02, aExecs[ _w3, 04, _w4 ] ] )) // Reposiciono ZRP
                                                                oGetD1:aCols[ nLin, nP01Proc01 ] := ZRP->ZRP_PROC01
                                                                oGetD1:aCols[ nLin, nP01LogP01 ] := ZRP->ZRP_LOGP01
                                                                oGetD1:aCols[ nLin, nP01Proc02 ] := ZRP->ZRP_PROC02
                                                                oGetD1:aCols[ nLin, nP01LogP02 ] := ZRP->ZRP_LOGP02
                                                                oGetD1:Refresh()
                                                            EndIf
                                                        Next
                                                    EndIf
                                                EndIf
                                            EndIf
                                        EndIf
                                    Next
                                EndIf
                            Next
                        EndIf
                    Next
                EndIf
            EndIf
        EndIf
    EndIf

EndIf
If cEmpAnt + cFilAnt <> cEmpOrig + cFilOrig // Restaura Empresa + Filial original
    nRecZRP := ZRP->(Recno())
    _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
    _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
    u_UPDEMPFIL(cEmpOrig, cFilOrig, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
    ZRP->(DbGoto( nRecZRP ))
EndIf
If nTipPrc == 2 // Se foi uma chamada para validacao de processamento e montagem dos execautos
    If !lVldPos .Or. !lVldExe // Mensagem da validacao (problema)
        If nMsgPr == 2 // 2=AskYesNo
            For y := 1 To 4
                u_AtuAsk09(++nCurrent, cMsVl01, cMsVl02, cMsVl03, cMsVl04, 80, "UPDERROR")
                Sleep(800)
            Next
        EndIf
        lRet := .F.
    Else // Valido para processamento
        If nMsgPr == 2 // 2=AskYesNo
            For y := 1 To 4
                u_AtuAsk09(++nCurrent, cMsVl01, "Validacao e montagem dos ExecAutos concluida com sucesso!", cMsVl03, cMsVl04, 80, "OK")
                Sleep(500)
            Next
        EndIf
    EndIf
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsRegra ºAutor ³Jonathan Schmidt Alvesº Data ³ 24/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento das regras.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsRegra()
Local aRegra := {}
// #########################################################
// ################### 01: STECK GUARAREMA SP ##############
// #########################################################
//           { Regra, Descricao da Regra                    ,,,,,,,, { Processamentos } }
//           {    01, 02                                    ,,,,,,,, {      10        } }
aAdd(aRegra, {  "01", "Fabricacao Guararema SP"             ,,,,,,,, {                } })
//                      {  Empresa,   Filial, Nome Filial                   , Rotina Base, Rotina Mnt , Rotina Prc, Modulo  , Processamento                     ,,, { Validacoes Posicionamentos }, { Registros Posicionamentos }, { Variaveis auxiliares }, { ExecAutos Montados } }
//                      { 10.??.01, 10.??.02, 10.??.03                      , 10.??.04   , 10.??.05   , 10.??.06  , 10.??.07, 10.??.08                          ,,, { 10.??.11                   }, { 10.??.12                  }, { 10.??.13             }, { 10.??.14           } }
aAdd(aTail(aRegra)[10], {     "01",     "02", "CENTRO DE DISTRIBUICAO SP"   , "MATA120"  , "SC7Mrp23" , "ExeAutC7",    "COM", "Gerando Pedido de Compra..."     ,,, {                            }, {                           }, {                      }, {                    } })
aAdd(aTail(aRegra)[10], {     "01",     "05", "FABRICA GUARAREMA SP"        , "MATA410"  , "SC5Mrp23" , "ExeAutC5",    "FAT", "Gerando Pedido de Venda..."      ,,, {                            }, {                           }, {                      }, {                    } })
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,01,11], { "SA2", "EVal({|| SA2->(DbSetOrder(1)), SA2->(DbSeek(xFilial('SA2') + '005764' + '05')) })",     {|| "Fornecedor nao encontrado no cadastro (SA2): " + "005764/05" } })                              // SA2: Fornecedor
aAdd(aTail(aRegra)[10,01,11], { "SA2", "SA2->A2_MSBLQL <> '1'",                                                                 {|| "Fornecedor esta bloqueado no cadastro (SA2): " + SA2->A2_COD + "/" + SA2->A2_LOJA } })         // SA2: Fornecedor Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "SE4", "EVal({|| SE4->(DbSetOrder(1)), SE4->(DbSeek(xFilial('SE4') + '007')) })",               {|| "Cond Pgto nao encotrada no cadastro (SE4): 007" } })                                           // SE4: Cond Pgto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(xFilial('SB1') + ZRP->ZRP_CODPRO)) })",     {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                             // SB1: Produto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                 {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                                 // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "DA1", "EVal({|| DA1->(DbSetOrder(1)), DA1->(DbSeek(xFilial('DA1') + 'T01' + SB1->B1_COD)) })", {|| "Produto nao cadastrado na tabela de Preco de Transferencia 'T01' (DA1): " + SB1->B1_COD } })   // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "SY1", "EVal({|| SY1->(DbSetOrder(3)), SY1->(DbSeek(xFilial('SY1') + '000000')) })",            {|| "Usuario Administrador nao cadastrado como comprador (SY1): " + "000000" } })                   // SY1: Compradores
aAdd(aTail(aRegra)[10,01,11], { "SY1", "EVal({|| !Iif(SuperGetMv('MV_RESTINC') == 'S',.T.,.F.) .Or. SY1->Y1_PEDIDO == '1' })",  {|| "Usuario Administrador sem acesso para incluir pedidos de compra (SY1): " + "000000" } })       // SY1: Compradores
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,01,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SA2", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SE4", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SY1", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,01,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,01,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP
aAdd(aTail(aRegra)[10,01,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,02,11], { "SA1", "EVal({|| SA1->(DbSetOrder(1)), SA1->(DbSeek(_cFilSA1 + '033467' + '02')) })",                                                   {|| "Cliente nao encontrado no cadastro (SA1): 033467/02" } })                              // SA1: Cliente
aAdd(aTail(aRegra)[10,02,11], { "SA1", "SA1->A1_MSBLQL <> '1'",                                                                                                         {|| "Cliente esta bloqueado no cadastro (SA1): " + SA1->A1_COD + "/" + SA1->A1_LOJA } })    // SA1: Cliente Bloqueado
aAdd(aTail(aRegra)[10,02,11], { "SE4", "EVal({|| SE4->(DbSetOrder(1)), SE4->(DbSeek(_cFilSE4 + '502')) })",                                                             {|| "Cond Pgto nao encotrada no cadastro (SE4): 502" } })                                   // SE4: Cond Pgto
aAdd(aTail(aRegra)[10,02,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(_cFilSB1 + ZRP->ZRP_CODPRO)) })",                                                   {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                     // SB1: Produto
aAdd(aTail(aRegra)[10,02,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                                                         {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                         // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,02,11], { "SA4", "EVal({|| SA4->(DbSetOrder(1)), SA4->(DbSeek(_cFilSA4 + '000001')) })",                                                          {|| "Transportadora nao encontrada no cadastro (SA4): 000001" } })                          // SA4: Transportadora
aAdd(aTail(aRegra)[10,02,11], { "SA4", "SA4->A4_MSBLQL <> '1'",                                                                                                         {|| "Transportadora esta bloqueada no cadastro (SA4): " + SA4->A4_COD } })                  // SA4: Transportadora bloqueada
aAdd(aTail(aRegra)[10,02,11], { "SC7", "EVal({|| SC7->(DbGoto(0)), .T. })",                                                                                             {|| "" } })                                                                                 // SC7: Pedidos de Compra
aAdd(aTail(aRegra)[10,02,11], { "SB1", "EVal({|| _nPrcMRP := u_STRETSST('94', SA1->A1_COD, SA1->A1_LOJA, SB1->B1_COD, SE4->E4_CODIGO, 'PRECO', .F., SA1->A1_TIPO, ''), Type('_nPrcMRP') == 'N' .And. _nPrcMRP > 0 })",  {|| "Preco de Venda nao pode ser obtido para o produto (SB1): " + SB1->B1_COD } })   // SB1: Sem Preco
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,02,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SA1", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SE4", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SA4", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SC7", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,02,13], { "_cConMRP",     "'2'" }) // Consumo Manaus "1", Sao Paulo "2"
aAdd(aTail(aRegra)[10,02,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,02,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP

aAdd(aTail(aRegra)[10,02,13], { "_bPedMRP",     "{|| SubStr(ZRP->ZRP_PROC01,11,06) }" }) // Pedido de Compra MRP

aAdd(aTail(aRegra)[10,02,13], { "_cOpeMRP",     "'94'" }) // Operacao Manaus "15", Sao Paulo "94"

aAdd(aTail(aRegra)[10,02,13], { "_cMotMRP",     "'MRP'" }) // Motivo da Compra
aAdd(aTail(aRegra)[10,02,13], { "_dPrfMRP",     "''" }) // Previsao Entrega        Manaus Preenchido   Sao Paulo Vazio

aAdd(aTail(aRegra)[10,02,13], { "_cTESMRP",     "'501'" })     // Tipo de Entrada e Saida
aAdd(aTail(aRegra)[10,02,13], { "_nPrcMRP",     "u_STRETSST(_cOpeMRP, SA1->A1_COD, SA1->A1_LOJA, SB1->B1_COD, SE4->E4_CODIGO, 'PRECO', .F., SA1->A1_TIPO, '')" })   // Preco do Produto
aAdd(aTail(aRegra)[10,02,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
// #########################################################
// ################### 02: STECK MANAUS AM #################
// #########################################################
//           { Regra, Descricao da Regra                    ,,,,,,,, { Processamentos } }
//           {    01, 02                                    ,,,,,,,, {      10        } }
aAdd(aRegra, {  "02", "Fabricacao Manaus AM"                ,,,,,,,, {                } })
//                      {  Empresa,   Filial, Nome Filial                   , Rotina Base, Rotina Mnt , Rotina Prc, Modulo  , Processamento                ,,, { Validacoes Posicionamentos }, { Registros Posicionamentos }, { Variaveis auxiliares }, { ExecAutos Montados } }
//                      { 10.??.01, 10.??.02, 10.??.03                      , 10.??.04   , 10.??.05   , 10.??.06  , 10.??.07, 10.??.08                     ,,, { 10.??.11                   }, { 10.??.12                  }, { 10.??.13             }, { 10.??.14           } }
aAdd(aTail(aRegra)[10], {     "01",     "02", "CENTRO DE DISTRIBUICAO SP"   , "MATA120"  , "SC7Mrp23" , "ExeAutC7",    "COM", "Gerando Pedido de Compra...",,, {                            }, {                           }, {                      }, {                    } })
aAdd(aTail(aRegra)[10], {     "03",     "01", "FABRICA MANAUS AM"           , "MATA410"  , "SC5Mrp23" , "ExeAutC5",    "FAT", "Gerando Pedido de Venda..." ,,, {                            }, {                           }, {                      }, {                    } })
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,01,11], { "SA2", "EVal({|| SA2->(DbSetOrder(1)), SA2->(DbSeek(xFilial('SA2') + '005866' + '01')) })",         {|| "Fornecedor nao encontrado no cadastro (SA2): 005764/05" } })                                   // SA2: Fornecedor
aAdd(aTail(aRegra)[10,01,11], { "SA2", "SA2->A2_MSBLQL <> '1'",                                                                     {|| "Fornecedor esta bloqueado no cadastro (SA2): " + SA2->A2_COD + "/" + SA2->A2_LOJA } })         // SA2: Fornecedor Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "SE4", "EVal({|| SE4->(DbSetOrder(1)), SE4->(DbSeek(xFilial('SE4') + '007')) })",                   {|| "Cond Pgto nao encotrada no cadastro (SE4): 007" } })                                           // SE4: Cond Pgto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(xFilial('SB1') + ZRP->ZRP_CODPRO)) })",         {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                             // SB1: Produto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                     {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                                 // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "DA1", "EVal({|| DA1->(DbSetOrder(1)), DA1->(DbSeek(xFilial('DA1') + 'T02' + SB1->B1_COD)) })",     {|| "Produto nao cadastrado na tabela de Preco de Transferencia 'T02' (DA1): " + SB1->B1_COD } })   // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "SY1", "EVal({|| SY1->(DbSetOrder(3)), SY1->(DbSeek(xFilial('SY1') + '000000')) })",                {|| "Usuario Administrador nao cadastrado como comprador (SY1): " + "000000" } })                   // SY1: Compradores
aAdd(aTail(aRegra)[10,01,11], { "SY1", "EVal({|| !Iif(SuperGetMv('MV_RESTINC') == 'S',.T.,.F.) .Or. SY1->Y1_PEDIDO == '1' })",      {|| "Usuario Administrador sem acesso para incluir pedidos de compra (SY1): " + "000000" } })       // SY1: Compradores
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,01,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SA2", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SE4", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SY1", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,01,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,01,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP
aAdd(aTail(aRegra)[10,01,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,02,11], { "SA1", "EVal({|| SA1->(DbSetOrder(1)), SA1->(DbSeek(xFilial('SA1') + '033467' + '02')) })",     {|| "Cliente nao encontrado no cadastro (SA1): 033467/02" } })                               // SA1: Cliente
aAdd(aTail(aRegra)[10,02,11], { "SA1", "SA1->A1_MSBLQL <> '1'",                                                                 {|| "Cliente esta bloqueado no cadastro (SA1): " + SA1->A1_COD + "/" + SA1->A1_LOJA } })     // SA1: Cliente Bloqueado
aAdd(aTail(aRegra)[10,02,11], { "SE4", "EVal({|| SE4->(DbSetOrder(1)), SE4->(DbSeek(xFilial('SE4') + '502')) })",               {|| "Cond Pgto nao encotrada no cadastro (SE4): 502" } })                                    // SE4: Cond Pgto
aAdd(aTail(aRegra)[10,02,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(xFilial('SB1') + ZRP->ZRP_CODPRO)) })",     {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                      // SB1: Produto
aAdd(aTail(aRegra)[10,02,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                 {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                          // SB1: Produto Bloqueado

aAdd(aTail(aRegra)[10,02,11], { "NNR", "EVal({|| NNR->(DbSetOrder(1)), NNR->(DbSeek(xFilial('NNR') + SB1->B1_LOCPAD)) })",      {|| "Armazem nao encontrado no cadastro (NNR): " + SB1->B1_LOCPAD } })                       // NNR: Armazens

aAdd(aTail(aRegra)[10,02,11], { "SA4", "EVal({|| SA4->(DbSetOrder(1)), SA4->(DbSeek(xFilial('SA4') + '100000')) })",            {|| "Transportadora nao encontrada no cadastro (SA4): 100000" } })                           // SA4: Transportadora
aAdd(aTail(aRegra)[10,02,11], { "SA4", "SA4->A4_MSBLQL <> '1'",                                                                 {|| "Transportadora esta bloqueada no cadastro (SA4): " + SA4->A4_COD } })                   // SA4: Transportadora bloqueada
aAdd(aTail(aRegra)[10,02,11], { "SC7", "EVal({|| SC7->(DbGoto(0)), .T. })",                                                     {|| "" } })                                                                                  // SC7: Pedidos de Compra
aAdd(aTail(aRegra)[10,02,11], { "SB1", "EVal({|| _nPrcMRP := u_STRETSST('94', SA1->A1_COD, SA1->A1_LOJA, SB1->B1_COD, SE4->E4_CODIGO, 'PRECO', .F., SA1->A1_TIPO, ''), Type('_nPrcMRP') == 'N' .And. _nPrcMRP > 0 })",  {|| "Preco de Venda nao pode ser obtido para o produto (SB1): " + SB1->B1_COD } })   // SB1: Sem Preco
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,02,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SA1", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SE4", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SA4", Array(0) })
aAdd(aTail(aRegra)[10,02,12], { "SC7", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,02,13], { "_cConMRP",     "'1'" }) // Consumo Manaus "1", Sao Paulo "2"
aAdd(aTail(aRegra)[10,02,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,02,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP

aAdd(aTail(aRegra)[10,02,13], { "_bPedMRP",     "{|| SubStr(ZRP->ZRP_PROC01,11,06) }" }) // Pedido de Compra MRP

aAdd(aTail(aRegra)[10,02,13], { "_cOpeMRP",     "'15'" }) // Operacao Manaus "15", Sao Paulo "94"

aAdd(aTail(aRegra)[10,02,13], { "_cMotMRP",     "'MRP'" }) // Motivo da Compra
aAdd(aTail(aRegra)[10,02,13], { "_dPrfMRP",     "''" }) // Previsao Entrega        Manaus Preenchido   Sao Paulo Vazio

aAdd(aTail(aRegra)[10,02,13], { "_cTESMRP",     "'701'" })     // Tipo de Entrada e Saida
aAdd(aTail(aRegra)[10,02,13], { "_nPrcMRP",     "u_STRETSST(_cOpeMRP, SA1->A1_COD, SA1->A1_LOJA, SB1->B1_COD, SE4->E4_CODIGO, 'PRECO', .F., SA1->A1_TIPO, '')" })   // Preco do Produto
aAdd(aTail(aRegra)[10,02,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
// #########################################################
// ############# 03: STECK IMPORTACOES #####################
// #########################################################
//           { Regra, Descricao da Regra                    ,,,,,,,, { Processamentos } }
//           {    01, 02                                    ,,,,,,,, {      10        } }
aAdd(aRegra, {  "03", "Importacao Centro Distribuicao SP"   ,,,,,,,, {                } })
//                      {  Empresa,   Filial, Nome Filial                   , Rotina Base, Rotina Mnt , Rotina Prc, Modulo  , Processamento                         ,,, { Validacoes Posicionamentos }, { Registros Posicionamentos }, { Variaveis auxiliares }, { ExecAutos Montados } }
//                      { 10.??.01, 10.??.02, 10.??.03                      , 10.??.04   , 10.??.05   , 10.??.06  , 10.??.07, 10.??.08                              ,,, { 10.??.11                   }, { 10.??.12                  }, { 10.??.13             }, { 10.??.14           } }
aAdd(aTail(aRegra)[10], {     "01",     "02", "CENTRO DE DISTRIBUICAO SP"   , "EICSI400" , "SW0Mrp23" , "ExeAutW0",    "COM", "Gerando Solicitacao de Importacao...",,, {                            }, {                           }, {                      }, {                    } })
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,01,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(xFilial('SB1') + ZRP->ZRP_CODPRO)) })",                                                     {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                                                             // SB1: Produto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                                                                 {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                                                                 // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "SB1", "EVal({|| !Empty(SB1->B1_PROC) })",                                                                                                      {|| "Produto nao possui fornecedor cadastrado (SB1): " + SB1->B1_COD } })                                                           // SB1: Produto sem fornecedor
aAdd(aTail(aRegra)[10,01,11], { "SA2", "EVal({|| SA2->(DbSetOrder(1)), SA2->(DbSeek(xFilial('SA2') + SB1->B1_PROC + Iif(!Empty(SB1->B1_LOJPROC), SB1->B1_LOJPROC, ''))) })",    {|| "Fornecedor nao encontrado no cadastro (SA2): " + SB1->B1_PROC + "/" + SB1->B1_LOJPROC } })                                     // SA2: Fornecedor
aAdd(aTail(aRegra)[10,01,11], { "SA2", "SA2->A2_MSBLQL <> '1'",                                                                                                                 {|| "Fornecedor esta bloqueado no cadastro (SA2): " + SA2->A2_COD + "/" + SA2->A2_LOJA } })                                         // SA2: Fornecedor Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "CTT", "EVal({|| CTT->(DbSetOrder(1)), CTT->(DbSeek(xFilial('CTT') + '120108')) })",                                                            {|| "Centro de Custo nao encontrado no cadastro (CTT): 120108" } })                                                                 // CTT: Centro de Custo
aAdd(aTail(aRegra)[10,01,11], { "SA5", "EVal({|| SA5->(DbSetOrder(1)), SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + SB1->B1_COD)) })",                            {|| "Produto nao amarrado ao fornecedor (SA5): Forn/Loja/Produto: " + SA2->A2_COD + "/" + SA2->A2_LOJA + "/" + SB1->B1_COD } })     // SA5: Amarracao Produto x Fornecedor
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,01,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SA2", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "CTT", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,01,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,01,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP
aAdd(aTail(aRegra)[10,01,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
// #########################################################
// ############# 04: STECK SOLICITACOES COMPRA #############
// #########################################################
//           { Regra, Descricao da Regra                    ,,,,,,,, { Processamentos } }
//           {    01, 02                                    ,,,,,,,, {      10        } }
aAdd(aRegra, {  "04", "Compra Centro Distribuicao SP"       ,,,,,,,, {                } })
//                      {  Empresa,   Filial, Nome Filial                   , Rotina Base, Rotina Mnt , Rotina Prc, Modulo  , Processamento                     ,,, { Validacoes Posicionamentos }, { Registros Posicionamentos }, { Variaveis auxiliares }, { ExecAutos Montados } }
//                      { 10.??.01, 10.??.02, 10.??.03                      , 10.??.04   , 10.??.05   , 10.??.06  , 10.??.07, 10.??.08                          ,,, { 10.??.11                   }, { 10.??.12                  }, { 10.??.13             }, { 10.??.14           } }
aAdd(aTail(aRegra)[10], {     "01",     "02", "CENTRO DE DISTRIBUICAO SP"   , "MATA110"  , "SC1Mrp23" , "ExeAutC1",    "COM", "Gerando Solicitacao de Compra...",,, {                            }, {                           }, {                      }, {                    } })
//                            Validacoes Posicionamentos
//                            10.??.11.??
aAdd(aTail(aRegra)[10,01,11], { "SB1", "EVal({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(xFilial('SB1') + ZRP->ZRP_CODPRO)) })",                             {|| "Produto nao encontrado no cadastro (SB1): " + ZRP->ZRP_CODPRO } })                           // SB1: Produto
aAdd(aTail(aRegra)[10,01,11], { "SB1", "SB1->B1_MSBLQL <> '1'",                                                                                         {|| "Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD } })                               // SB1: Produto Bloqueado
aAdd(aTail(aRegra)[10,01,11], { "CTT", "EVal({|| CTT->(DbSetOrder(1)), CTT->(DbSeek(xFilial('CTT') + '115108')) })",                                    {|| "Centro de Custo nao encontrado no cadastro (CTT): 115108" } })                               // CTT: Centro de Custo
//                            Registros Posicionamentos
//                            10.??.12.??
aAdd(aTail(aRegra)[10,01,12], { "ZRP", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SB1", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "SA2", Array(0) })
aAdd(aTail(aRegra)[10,01,12], { "CTT", Array(0) })
//                            Variaveis Auxiliares
//                            10.??.13.??
aAdd(aTail(aRegra)[10,01,13], { "_cMesMRP",     "StrZero(Month(ZRP->ZRP_PERIOD),2)" }) // Mes MRP
aAdd(aTail(aRegra)[10,01,13], { "_cAnoMRP",     "cValToChar(Year(ZRP->ZRP_PERIOD))" }) // Ano MRP
aAdd(aTail(aRegra)[10,01,13], { "_cOriZRP",     "'SchMrp23 Planilha: ' + ZRP->ZRP_CODIGO + ' ' + DtoC(Date()) + ' ' + Time() + ' Recno ZRP: ' + StrZero(ZRP->(Recno()),6)" }) // Log MRP
Return aRegra

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SC1Mrp23 ºAutor ³Jonathan Schmidt Alvesº Data ³ 22/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem das Solicitacos de Compra.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SC1Mrp23()
Local _w1
Local _w3
Local aExecs := {}
Private aExecSC1 := {}
Private aSC1Cabc := {}
Private aSC1Item := {}
Private aRecsPos := PARAMIXB[01] // Recnos Posicionamentos
Private aVarsAux := PARAMIXB[02] // Variaveis Auxiliares
Private _cFilSC1 := xFilial("SC1")
For _w1 := 1 To Len(aRecsPos[01,02]) // Rodo conforme a qtde de registros posicionaveis da primeira tabela
    // Reposiciono todos os recnos (Para montagem do Cabecalho)
    For _w3 := 1 To Len(aRecsPos) // Rodo nos recnos de posicionamento
        If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
            If _w1 <= Len(aRecsPos[_w3,02])
                (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02,_w1])) // Se for 0 vai pra EOF
            EndIf
        EndIf
    Next
    // Abertura das Variaveis Auxiliares
    For _w3 := 1 To Len(aVarsAux)
        &(aVarsAux[_w3,01]) := &(aVarsAux[_w3,02])
    Next
    If Type("aCab" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        aAdd(aExecSC1, "aCab" + "_" + StrZero(SA2->(Recno()),6))
        &(aTail(aExecSC1)) := Array(0)
    EndIf
    aSC1Cabc := &("aCab" + "_" + StrZero(SA2->(Recno()),6))
    If Type("aIte" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        &("aIte" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
        &("aBod" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
    EndIf
    If Len(aSC1Cabc) == 0 // Cabecalho ainda nao alimentado
        aAdd(aSC1Cabc, { "C1_NUM",      Space(06),          Nil }) // Numero Solicitacao
	    aAdd(aSC1Cabc, { "C1_EMISSAO",  Date(),             Nil })
	    aAdd(aSC1Cabc, { "C1_SOLICIT",  "administrador",    Nil })
    EndIf
    aSC1Item := {}
    
    //aAdd(aSC1Item, { "C1_ITEM",         StrZero(Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))) + 1,4),                        Nil }) // Item da Solicitacao
    aAdd(aSC1Item, { "C1_ITEM",         ItenSoma(Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))),4),                          Nil }) // Item da Solicitacao

    aAdd(aSC1Item, { "C1_PRODUTO",      SB1->B1_COD,                                                                            Nil }) // Codigo do Produto
    aAdd(aSC1Item, { "C1_QUANT",        ZRP->ZRP_QTDREC,                                                                        Nil }) // Quantidade
    aAdd(aSC1Item, { "C1_MOTIVO",       "MRP",                                                                                  Nil }) // Motivo Solicitacao
    aAdd(aSC1Item, { "C1_CC",           CTT->CTT_CUSTO,                                                                         Nil }) // Centro de Custo
    aAdd(aSC1Item, { "C1_SOLICIT",      "administrador",                                                                        Nil }) // NOVO
    aAdd(aSC1Item, { "AUTVLDCONT",      "N",                                                                                    Nil }) // NOVO
    aAdd(aSC1Item, { "C1_OBS",          _cOriZRP,                                                                               Nil }) // Observacoes

    aAdd(aSC1Item, { "C1_ZSTATUS",      "3",                                                                                    Nil }) // Customizado do fluxo Steck "3"=Compras

    aAdd( &("aIte" + "_" + StrZero(SA2->(Recno()),6)), aClone(aSC1Item))
    aAdd( &("aBod" + "_" + StrZero(SA2->(Recno()),6)), _w1) // Elementos da matriz de Posicionamento/Variaveis Auxiliares
Next
For _w1 := 1 To Len(aExecSC1) // Rodo nas montagens
    If Len(&(aExecSC1[_w1])) > 0 .And. Len(&(StrTran(aExecSC1[_w1],"Cab","Ite"))) > 0 // Cabecalho e Itens carregados
        //           {    01,                       02,                                    03,                                       04 }
        //           {   Tab,         Matriz Cabecalho,                          Matriz Itens,                    Elementos de Bodovsky }
        aAdd(aExecs, { "SC1", aClone(&(aExecSC1[_w1])), &(StrTran(aExecSC1[_w1],"Cab","Ite")), &(StrTran(aExecSC1[_w1],"Cab","Bod"))    })
    EndIf
Next
Return aExecs

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SC5Mrp23 ºAutor ³Jonathan Schmidt Alvesº Data ³ 18/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem dos Pedidos de Venda.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SC5Mrp23()
Local _w1
Local _w3
Local aExecs := {}
Private aExecSC5 := {}
Private aSC5Cabc := {}
Private aSC6Item := {}
Private aRecsPos := PARAMIXB[01] // Recnos Posicionamentos
Private aVarsAux := PARAMIXB[02] // Variaveis Auxiliares
Private _cFilSC5 := xFilial("SC5")
Private _cFilSA1 := xFilial("SA1")
Private _cFilSE4 := xFilial("SE4")
For _w1 := 1 To Len(aRecsPos[01,02]) // Rodo conforme a qtde de registros posicionaveis da primeira tabela
    // Reposiciono todos os recnos (Para montagem do Cabecalho)
    For _w3 := 1 To Len(aRecsPos) // Rodo nos recnos de posicionamento
        If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
            If _w1 <= Len(aRecsPos[_w3,02])
                (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02,_w1])) // Se for 0 vai pra EOF
            EndIf
        EndIf
    Next
    // Abertura das Variaveis Auxiliares
    For _w3 := 1 To Len(aVarsAux)
        &(aVarsAux[_w3,01]) := &(aVarsAux[_w3,02])
    Next
    If Type("aCab" + "_" + StrZero(SA1->(Recno()),6)) == "U"
        aAdd(aExecSC5, "aCab" + "_" + StrZero(SA1->(Recno()),6))
        &(aTail(aExecSC5)) := Array(0)
    EndIf
    aSC5Cabc := &("aCab" + "_" + StrZero(SA1->(Recno()),6))
    If Type("aIte" + "_" + StrZero(SA1->(Recno()),6)) == "U"
        &("aIte" + "_" + StrZero(SA1->(Recno()),6)) := Array(0)
        &("aBod" + "_" + StrZero(SA1->(Recno()),6)) := Array(0)
    EndIf
    If Len(aSC5Cabc) == 0 // Cabecalho ainda nao alimentado
    	aAdd(aSC5Cabc, { "C5_TIPO",         "N",                                    Nil }) // Tipo do Pedido
        aAdd(aSC5Cabc, { "C5_CLIENTE",      SA1->A1_COD,                            Nil }) // Codigo do Cliente                             VldUsr: U_STVLDCLI(M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TIPO)
        aAdd(aSC5Cabc, { "C5_LOJACLI",      SA1->A1_LOJA,                           Nil }) // Loja do Cliente                               Campo: A1_XREVISA       "Cliente nao pode ser utilizado, nao esta revisado!"
        aAdd(aSC5Cabc, { "C5_CLIENT",       SA1->A1_COD,                            Nil }) // Codigo do Cliente para entrega
        aAdd(aSC5Cabc, { "C5_LOJAENT",      SA1->A1_LOJA,                           Nil }) // Loja para entrega
        aAdd(aSC5Cabc, { "C5_TIPOCLI",      SA1->A1_TIPO,                           Nil }) // Tipo do Cliente
        aAdd(aSC5Cabc, { "C5_CONDPAG",      SE4->E4_CODIGO,                         Nil }) // Condicao de Pagamento             Char  03
        aAdd(aSC5Cabc, { "C5_EMISSAO",      dDatabase,                              Nil }) // Data de Emissao                   Dat   08
        aAdd(aSC5Cabc, { "C5_ZCONDPG",      SE4->E4_CODIGO,                         Nil }) // Cond Pg                           Char  03    VldUsr: IF(M->C5_ZCONDPG>="501",.T.,.F.) .And. U_STTMKA05(M->C5_ZCONDPG)
		aAdd(aSC5Cabc, { "C5_TABELA",       "001",                                  Nil }) // Tabela de Preco
		aAdd(aSC5Cabc, { "C5_VEND1",        Space(06),                              Nil }) // Vendedor 01
        aAdd(aSC5Cabc, { "C5_TPFRETE",      "F",                                    Nil }) // Tipo Frete                                                                                VldUsr: pertence("CF") .And. U_STVLDFRE(M->C5_TPFRETE,M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TRANSP,'2')   .and. u_STVALTRANSP( )
        aAdd(aSC5Cabc, { "C5_TRANSP",       SA4->A4_COD,                            Nil }) // Transportadora                    Manaus "100000", Sao Paulo "000001"                     VldUsr: u_STVALTRANSP( ) .And. If(Posicione("SA4",1,xFilial("SA4")+M->C5_TRANSP,"A4_XBLQ")=="2",.T.,(MsgInfo("Transp Bloq"),.F.))
		aAdd(aSC5Cabc, { "C5_XTIPO",        "2",                                    Nil }) // Tipo Entrega                      Char  01 Inic Pad: IIF(M->C5_TRANSP="000001","2","")    VldUsr: U_STTPENT(M->C5_TRANSP,"P")
		aAdd(aSC5Cabc, { "C5_XTIPF",        "1",                                    Nil }) // Tipo Fatura                       Char  01
		aAdd(aSC5Cabc, { "C5_ZBLOQ",        "2",                                    Nil }) // Bloqueio                          Char  01
		aAdd(aSC5Cabc, { "C5_ZCONSUM",      _cConMRP,                               Nil }) // Consumo Proprio Cliente           Char  01    Manaus "1", Sao Paulo "2"

        // Incluido 26/05 Jonathan
	    aAdd(aSC5Cabc, { "C5_ZNUMPC",       _bPedMRP,                               Nil }) // Numero Pedido de Compra SP MRP

        &("aCab" + "_" + StrZero(SA1->(Recno()),6)) := aClone(aSC5Cabc)
    EndIf
    aSC6Item := {}

    //aAdd(aSC6Item, { "C6_ITEM",         StrZero(Len(&("aIte" + "_" + StrZero(SA1->(Recno()),6))) + 1,2),                            Nil }) // Item no Pedido
    aAdd(aSC6Item, { "C6_ITEM",         ItenSoma(Len(&("aIte" + "_" + StrZero(SA1->(Recno()),6))),2),                               Nil }) // Item no Pedido

    aAdd(aSC6Item, { "C6_PRODUTO",      SB1->B1_COD,                                                                                Nil }) // Codigo do Produto                                     VldUsr: U_STPRODVAL() .AND. U_STCODDES(M->C6_PRODUTO) .And. U_STVLDGR999(M->C6_PRODUTO) .And. U_STVLDOF(M->C6_PRODUTO)
    aAdd(aSC6Item, { "C6_UM",           "UN",                                                                                       Nil }) // Unidade de Medida Primar.
    aAdd(aSC6Item, { "C6_QTDVEN",       ZRP->ZRP_QTDREC,                                                                            Nil }) // Quantidade Vendida                                    IIF(GETMV("ST_C6OPER",,.F.),U_STOPERER(),.T.) .And. U_STQTDVAL()
    aAdd(aSC6Item, { "C6_PRCVEN",       _nPrcMRP,                                                                                   Nil }) // Preco Venda    
    aAdd(aSC6Item, { "C6_PRUNIT",       _nPrcMRP,                                                                                   Nil }) // Preco Unitario
    aAdd(aSC6Item, { "C6_VALOR",        Round(ZRP->ZRP_QTDREC * _nPrcMRP,2),                                                        Nil }) // Valor Total do Item
    aAdd(aSC6Item, { "C6_LOCAL",        SB1->B1_LOCPAD,                                                                             Nil }) // Armazem
    aAdd(aSC6Item, { "C6_CLI",          SA1->A1_COD,                                                                                Nil }) // Cliente
    aAdd(aSC6Item, { "C6_OPER",         _cOpeMRP,                                                                                   Nil }) // Operacao                              Char  02        VldUsr: IIF(GETMV("ST_C6OPER",,.F.),U_STOPERER(),.T.)
    aAdd(aSC6Item, { "C6_TES",          _cTESMRP,                                                                                   Nil }) // TES

    aAdd(aSC6Item, { "C6_ZMOTPC",       _cMotMRP,                                                                                   Nil }) // Motivo de Compra

    aAdd( &("aIte" + "_" + StrZero(SA1->(Recno()),6)), aClone(aSC6Item))
    aAdd( &("aBod" + "_" + StrZero(SA1->(Recno()),6)), _w1) // Elementos da matriz de Posicionamento/Variaveis Auxiliares
Next
For _w1 := 1 To Len(aExecSC5) // Rodo nas montagens
    If Len(&(aExecSC5[_w1])) > 0 .And. Len(&(StrTran(aExecSC5[_w1],"Cab","Ite"))) > 0 // Cabecalho e Itens carregados
        //           {    01,                       02,                                    03,                                       04 }
        //           {   Tab,         Matriz Cabecalho,                          Matriz Itens,                    Elementos de Bodovsky }
        aAdd(aExecs, { "SC5", aClone(&(aExecSC5[_w1])), &(StrTran(aExecSC5[_w1],"Cab","Ite")), &(StrTran(aExecSC5[_w1],"Cab","Bod"))    })
    EndIf
Next
Return aExecs

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SC7Mrp23 ºAutor ³Jonathan Schmidt Alvesº Data ³ 17/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem dos Pedidos de Compra.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SC7Mrp23()
Local _w1
Local _w3
Local aExecs := {}
Private aExecSC7 := {}
Private aSC7Cabc := {}
Private aSC7Item := {}
Private aSC7Itns := {}
Private aRecsPos := PARAMIXB[01] // Recnos Posicionamentos
Private aVarsAux := PARAMIXB[02] // Variaveis Auxiliares
Private _cFilSC7 := xFilial("SC7")
Private _cFilSA2 := xFilial("SA2")
Private _cFilSE4 := xFilial("SE4")
For _w1 := 1 To Len(aRecsPos[01,02]) // Rodo conforme a qtde de registros posicionaveis da primeira tabela
    // Reposiciono todos os recnos (Para montagem do Cabecalho)
    For _w3 := 1 To Len(aRecsPos) // Rodo nos recnos de posicionamento
        If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
            If _w1 <= Len(aRecsPos[_w3,02])
                (aRecsPos[_w3,01] )->(DbGoto(aRecsPos[_w3,02,_w1])) // Se for 0 vai pra EOF
            EndIf
        EndIf
    Next
    // Abertura das Variaveis Auxiliares
    For _w3 := 1 To Len(aVarsAux)
        &(aVarsAux[_w3,01]) := &(aVarsAux[_w3,02])
    Next
    If Type("aCab" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        aAdd(aExecSC7, "aCab" + "_" + StrZero(SA2->(Recno()),6))
        &(aTail(aExecSC7)) := Array(0)
    EndIf
    aSC7Cabc := &("aCab" + "_" + StrZero(SA2->(Recno()),6))
    If Type("aIte" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        &("aIte" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
        &("aBod" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
    EndIf
    If Len(aSC7Cabc) == 0 // Cabecalho ainda nao alimentado
        aAdd(aSC7Cabc, { "C7_NUM",          Space(06),                              Nil })
        aAdd(aSC7Cabc, { "C7_EMISSAO",      dDatabase,                              Nil })
        aAdd(aSC7Cabc, { "C7_FORNECE",      SA2->A2_COD,                            Nil })
        aAdd(aSC7Cabc, { "C7_LOJA",         SA2->A2_LOJA,                           Nil })
        aAdd(aSC7Cabc, { "C7_COND",         SE4->E4_CODIGO,                         Nil })
        aAdd(aSC7Cabc, { "C7_MOEDA",        1,                                      Nil })
        aAdd(aSC7Cabc, { "C7_TXMOEDA",      0,                                      Nil })
        &("aCab" + "_" + StrZero(SA2->(Recno()),6)) := aClone(aSC7Cabc)
    EndIf
    aSC7Item := {}

    //aAdd(aSC7Item, { "C7_ITEM",         StrZero(Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))) + 1,4),        Nil })
    aAdd(aSC7Item, { "C7_ITEM",         ItenSoma( Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))),4),          Nil })

    aAdd(aSC7Item, { "C7_PRODUTO",      SB1->B1_COD,                                                            Nil })
    aAdd(aSC7Item, { "C7_QUANT",        ZRP->ZRP_QTDREC,                                                        Nil })
    aAdd(aSC7Item, { "C7_DATPRF",       dDatabase + 10,                                                         Nil })

    aAdd(aSC7Item, { "C7_MOTIVO",       "MRP",                                                                  Nil })
    
    aAdd( &("aIte" + "_" + StrZero(SA2->(Recno()),6)), aClone(aSC7Item))
    aAdd( &("aBod" + "_" + StrZero(SA2->(Recno()),6)), _w1) // Elementos da matriz de Posicionamento/Variaveis Auxiliares
Next
For _w1 := 1 To Len(aExecSC7) // Rodo nas montagens
    If Len(&(aExecSC7[_w1])) > 0 .And. Len(&(StrTran(aExecSC7[_w1],"Cab","Ite"))) > 0 // Cabecalho e Itens carregados
        //           {    01,                       02,                                    03,                                       04 }
        //           {   Tab,         Matriz Cabecalho,                          Matriz Itens,                    Elementos de Bodovsky }
        aAdd(aExecs, { "SC7", aClone(&(aExecSC7[_w1])), &(StrTran(aExecSC7[_w1],"Cab","Ite")), &(StrTran(aExecSC7[_w1],"Cab","Bod"))    })    
    EndIf
Next
Return aExecs

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SW0Mrp23 ºAutor ³Jonathan Schmidt Alvesº Data ³ 28/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem das Solicitacoes de Importacao.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SW0Mrp23()
Local _w1
Local _w3
Local aExecs := {}
Private aExecSW0 := {}
Private aSW0Cabc := {}
Private aSW0Item := {}
Private aSW0Itns := {}
Private aRecsPos := PARAMIXB[01] // Recnos Posicionamentos
Private aVarsAux := PARAMIXB[02] // Variaveis Auxiliares
Private _cFilSY1 := xFilial("SY1")
Private _cFilSY2 := xFilial("SY2")
Private _cFilSY3 := xFilial("SY3")
Private _cFilSW0 := xFilial("SW0")
Private _cFilSW1 := xFilial("SW1")
Private _cFilSA2 := xFilial("SA2")
Private _cFilSE4 := xFilial("SE4")
For _w1 := 1 To Len(aRecsPos[01,02]) // Rodo conforme a qtde de registros posicionaveis da primeira tabela
    // Reposiciono todos os recnos (Para montagem do Cabecalho)
    For _w3 := 1 To Len(aRecsPos) // Rodo nos recnos de posicionamento
        If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
            If _w1 <= Len(aRecsPos[_w3,02])
                (aRecsPos[_w3,01] )->(DbGoto(aRecsPos[_w3,02,_w1])) // Se for 0 vai pra EOF
            EndIf
        EndIf
    Next
    // Abertura das Variaveis Auxiliares
    For _w3 := 1 To Len(aVarsAux)
        &(aVarsAux[_w3,01]) := &(aVarsAux[_w3,02])
    Next
    If Type("aCab" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        aAdd(aExecSW0, "aCab" + "_" + StrZero(SA2->(Recno()),6))
        &(aTail(aExecSW0)) := Array(0)
    EndIf
    aSW0Cabc := &("aCab" + "_" + StrZero(SA2->(Recno()),6))
    If Type("aIte" + "_" + StrZero(SA2->(Recno()),6)) == "U"
        &("aIte" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
        &("aBod" + "_" + StrZero(SA2->(Recno()),6)) := Array(0)
    EndIf
    If Len(aSW0Cabc) == 0 // Cabecalho ainda nao alimentado
        aAdd(aSW0Cabc, { "W0__NUM",         Space(06),                                              Nil })      // Numero da Solicitacao
        aAdd(aSW0Cabc, { "W0__CC",          "002",                                                  Nil })      // "SY3"        "002"=STECK DA  AMAZONIA INDUSTRIA ELETRICA LTDA
        aAdd(aSW0Cabc, { "W0__DT",          Date(),                                                 Nil })
        aAdd(aSW0Cabc, { "W0__POLE",        "F5",                                                   Nil })      // "SY2"        "F5"=STECK INDUSTRIA ELETRICA LTDA 
        aAdd(aSW0Cabc, { "W0_COMPRA",       "081",                                                  Nil })      // "SY1"        Comprador
        aAdd(aSW0Cabc, { "W0_MOEDA",        "US$",                                                  Nil })      // Moeda
        aAdd(aSW0Cabc, { "W0_SOLIC",        "richely.lima",                                         Nil })      // Solicitante
        &("aCab" + "_" + StrZero(SA2->(Recno()),6)) := aClone(aSW0Cabc)
    EndIf
    aSW1Item := {}
    aAdd(aSW1Item, { "W1_COD_I",        SB1->B1_COD,                                                            Nil })
    aAdd(aSW1Item, { "W1_UM",           SB1->B1_UM,                                                             Nil }) // Campo Obrigatorio
    aAdd(aSW1Item, { "W1_FABR",         SA2->A2_COD,                                                            Nil }) // Campo Obrigatorio
    aAdd(aSW1Item, { 'W1_FABLOJ',       SA2->A2_LOJA,                                                           Nil })
    aAdd(aSW1Item, { "W1_CLASS",        "1",                                                                    Nil })
    aAdd(aSW1Item, { "W1_FORN",         SA2->A2_COD,                                                            Nil }) // Campo Obrigatorio Cod: 018545
    aAdd(aSW1Item, { "W1_FORLOJ",       SA2->A2_LOJA,                                                           Nil })
    aAdd(aSW1Item, { "W1_QTDE",         ZRP->ZRP_QTDREC,                                                        Nil })
    aAdd(aSW1Item, { "W1_PRECO",        100,                                                                    Nil }) // Campo Obrigatorio
    
    //aAdd(aSW1Item, { "W1_POSIT",        StrZero(Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))) + 1,4),        Nil }) // Item
    aAdd(aSW1Item, { "W1_POSIT",        ItenSoma( Len(&("aIte" + "_" + StrZero(SA2->(Recno()),6))),4),          Nil }) // Item

    aAdd(aSW1Item, { "W1_DTENTR_",      Date() + 30,                                                            Nil }) // Campo Obrigatorio
    aAdd(aSW1Item, { "W1_CTCUSTO",      CTT->CTT_CUSTO,                                                         Nil }) // Campo Obrigatorip
    aAdd( &("aIte" + "_" + StrZero(SA2->(Recno()),6)), aClone(aSW1Item))
    aAdd( &("aBod" + "_" + StrZero(SA2->(Recno()),6)), _w1) // Elementos da matriz de Posicionamento/Variaveis Auxiliares
Next
For _w1 := 1 To Len(aExecSW0) // Rodo nas montagens
    If Len(&(aExecSW0[_w1])) > 0 .And. Len(&(StrTran(aExecSW0[_w1],"Cab","Ite"))) > 0 // Cabecalho e Itens carregados
        //           {    01,                       02,                                    03,                                       04 }
        //           {   Tab,         Matriz Cabecalho,                          Matriz Itens,                    Elementos de Bodovsky }
        aAdd(aExecs, { "SW0", aClone(&(aExecSW0[_w1])), &(StrTran(aExecSW0[_w1],"Cab","Ite")), &(StrTran(aExecSW0[_w1],"Cab","Bod"))    })
    EndIf
Next
Return aExecs

Static Function ItenSoma(nIte,nTam)
Local nIni
Local cIte := Replicate("0",nTam)   // "00"
For nIni := 1 To nIte + 1
    cIte := Soma1(cIte,nTam)
Next
Return cIte

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrepExec ºAutor ³ Jonathan Schmidt Alves ºData³ 21/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao principal de preparacao dos diversos ExecAutos      º±±
±±º          ³ alterando o modulo conforme necessario no StartJob.        º±±
±±º          ³ Esta funcionalidade se faz necessaria para o correto       º±±
±±º          ³ processamento dos execautos de rotinas nativas dos modulos º±±
±±º          ³ Compras, Financeiro, Faturamento que sao processadas       º±±
±±º          ³ em sequencia a partir da Central de Reembolsos.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros:                                                º±±
±±º          ³ cEmp: Empresa                                              º±±
±±º          ³ cFil: Filial                                               º±±
±±º          ³ nMsgPr: Mensagens de processamento                         º±±
±±º          ³ cFunc: Funcao a ser executada (Execs)                      º±±
±±º          ³ cMod: Modulo a ser ajustado                                º±±
±±º          ³ cMsg01: Mensagem de processamento 01                       º±±
±±º          ³ cMsg02: Mensagem de processamento 02                       º±±
±±º          ³ aExecs: Matriz com os dados do ExecAuto                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Exemplo:                                                   º±±
±±º          ³ u_PrepExec("01", "02", 2, "FIN", "ExeAutED", "Gerando      º±±
±±º          ³ natureza...", "Natureza: XYZ", { 3, aGerNatu, {} }         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PrepExec(cEmp, cFil, nMsgPr, cFunc, cMod, cMsg01, cMsg02, aExecs)
Local y
Local nY
Local aTabs := {}
Local aTabsMod := {}
Private cCodUsr := RetCodUsr()
Private cMsg03 := ""
Private cMsg04 := ""
Default cMod := "FAT"
Default cFunc := ""
Default aExecs := {}
ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Iniciando...")
aAdd(aTabsMod, { "COM", { "SC7","SY1","SA2","SB1","SB2","SF4","SW0","SW1" } })
aAdd(aTabsMod, { "FAT", { "SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} })
aAdd(aTabsMod, { "FIN", { "SE1","SE2","SE5" } })
If Empty(cMod) // Modulo nao informado
	cButType := "UPDERROR"
	cMsg03 := "Modulo para carregamento ExecAuto nao informado!"
ElseIf Empty(cFunc) // Funcao nao informada
	cButType := "UPDERROR"
	cMsg03 := "Funcao para processamento ExecAuto nao informada!"
ElseIf Len(aExecs) == 0
	cButType := "UPDERROR"
	cMsg03 := "Dados para o ExecAuto nao informados!"
Else // Dados ok para processamento
    If nMsgPr == 2 // AskYesNo
        _oMeter:nTotal := 12
        For y := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "PROCESSA")
            Sleep(100)
        Next
    EndIf
	If (nPosT := ASCan(aTabsMod, {|x|, x[01] == cMod })) > 0 // Tabelas para abrir do modulo
		aTabs := aClone(aTabsMod[nPosT,02])
		ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Chamando CallExec...")
		ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Chamando StartJob... GetEnvServer: " + GetEnvServer())
		aRetFunc := StartJob("u_CallExec",GetEnvServer(),.T.,{ cEmp, cFil, cMod, aTabs, cCodUsr, cUserName, cFunc, aExecs })
		ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Chamando CallExec... Concluido!")
		If aRetFunc[1] == -1 // Nao for m identificados itens para geracao
			cButType := "UPDERROR"
			cMsg03 := "Nao foram identificados itens para geracao..."
			cMsg04 := "Consulte o suporte Totvs!"
		ElseIf aRetFunc[1] == 0 // Nao houve processamento
			cButType := "UPDERROR"
			cMsg03 := "Nao houve processamento..."
			cMsg04 := "Consulte o suporte Totvs!"
		ElseIf aRetFunc[1] == 1 // Falha
			cButType := "UPDERROR"
			cMsg03 := "Processamento realizado com falha!"
			cMsg04 := "Consulte o suporte Totvs!"
		ElseIf aRetFunc[1] == 2 // Sucesso
			cButType := "OK"
			cMsg03 := "Processamento realizado com sucesso!"
		Else // Retorno do processamento nao identificado
			cButType := "UPDERROR"
			cMsg03 := "Nao foi identificado o retorno do processamento!"
		EndIf
	EndIf
EndIf
// Apresentacao das mensagens em tela
ConOut("")
ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Apresentando retornos de processamento:")
If ValType(aRetFunc) == "A" .And. Len(aRetFunc) >= 4 // Mensagens na matriz
	For nY := 1 To Len(aRetFunc[04]) // Rodo nas mensagens carregadas
		ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " " + aRetFunc[04,nY,01] + " " + aRetFunc[04,nY,02] + " " + aRetFunc[04,nY,03] + " " + aRetFunc[04,nY,04])
        If nMsgPr == 2 // AskYesNo
            For y := 1 To 4
                u_AtuAsk09(nCurrent, aRetFunc[04,nY,01], aRetFunc[04,nY,02], aRetFunc[04,nY,03], aRetFunc[04,nY,04], aRetFunc[04,nY,05], aRetFunc[04,nY,06])
                Sleep(100)
            Next
        EndIf
	Next
	If aRetFunc[1] == 2 // Sucesso
		ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " " + cMsg01 + " " + cMsg02 + " " + cMsg03 + " " + cMsg04)
        If nMsgPr == 2 // AskYesNo
            For y := 1 To 4
                u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, cButType)
                Sleep(100)
            Next
        EndIf
	EndIf
EndIf
ConOut("PrepExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Concluido!")
ConOut("")
Return aRetFunc

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ CallExec ºAutor º Jonathan Schmidt Alves ³Data ³21/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao chamada via StartJob para a preparacao do ambiente  º±±
±±º          ³ e ExecBloc dos ExecAutos conforme necessario.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros da aParams:                                     º±±
±±º          ³ [01]: Codigo da empresa                                    º±±
±±º          ³ [02]: Codigo da filial                                     º±±
±±º          ³ [03]: Modulo para logar                                    º±±
±±º          ³ [04]: Tabelas para abertura                                º±±
±±º          ³ [05]: Usuario para log                                     º±±
±±º          ³ [06]: Nome do usuario para log                             º±±
±±º          ³ [07]: Funcao para processamento do ExecAuto                º±±
±±º          ³ [08]: Matriz com os dados para o ExecAuto                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Retorno da funcao e aRet:                                  º±±
±±º          ³ [1]: 1=Falha 2=Sucesso 0=Sem Processamento                 º±±
±±º          ³ [2]: Numero do registro gerado (titulo, pedido, etc)       º±±
±±º          ³ [3]: Recno do registro gerado para posicionamento          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CallExec(aParams)
Local aReturn := {}
Private cCodUsr := aParams[05] // Codigo Usuario Logado
Private cUserName := "" // Nome Usuario Logado
Private cFunc := aParams[07] // Funcao para processamento
Private aExecs := aParams[08] // Matrizes do ExecAuto
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Iniciando...")
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " RpcSetEnv...")
// RPCSetType(3)
RpcSetEnv(aParams[01],aParams[02],,,aParams[03],GetEnvServer(),aParams[04])
cUserName := aParams[06] // Nome Usuario Logado (chamador do CallExec)
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " RpcSetEnv... Concluido... Modulo: " + cModulo)
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Funcao para processamento: " + cFunc)
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " Tamanho da aExecs: " + cValToChar(Len(aExecs)))
aReturn := ExecBlock(cFunc,.F.,.F.,aExecs)
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " ClearEnv...")
RpcClearEnv()
ConOut("CallExec: " + DtoC(Date()) + " " + Time() + " " + cCodUsr + " " + cUserName + " ClearEnv... Concluido!")
Return aReturn

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ExeAutC1 ºAutor ³Jonathan Schmidt Alvesº Data ³ 23/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento ExecAuto MATA110 (Solicitacao de Compras)    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ExeAutC1()
Local _w1
Local _w3
Local _aRet := { 0, Space(06), 0, {}, {} }
// Processamento ExecAuto
Local nOpc := 3
Local aCabec := {}
Local aItens := {}
Local aBdvky := {}
// Controle de log ZRP
Local nIteSol := 0
Private _cFilSC1 := xFilial("SC1")
// Variaveis do aRegra
Private aRecsPos := {}
Private aVarsAux := {}
Private lMsErroAuto := .F.
aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Carregando...", "", "", 80, "PEDIDO" })
If Type("PARAMIXB") == "A" .And. Len(PARAMIXB) == 3
    aCabec  := aClone(PARAMIXB[01,02])      // Cabecalho SC1
    aItens  := aClone(PARAMIXB[01,03])      // Itens SC1
    aBdvky  := aClone(PARAMIXB[01,04])      // Elementos de Bodovsky
    aRecsPos := aClone(PARAMIXB[02])        // Recnos Posicionamentos
    If Len(aCabec) > 0 .And. Len(aItens) > 0
        // Bodovsky
        For _w1 := 1 To Len(aBdvky) // Rodo conforme a qtde de posicionamentos desse ExecAuto
            // Reposiciono todos os recnos
            For _w3 := 1 To Len(aRecsPos) // Rodo nas tabelas de recnos posicionamento
                If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
                    If aBdvky[ _w1 ] <= Len(aRecsPos[_w3,02])
                        (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02, aBdvky[ _w1 ] ])) // Se for 0 vai pra EOF
                    EndIf
                EndIf
            Next
            // Reprocessamento do Cabecalho/Itens caso exista Bloco de Codigo
            If _w1 == 1 // No primeiro item, reavalio o cabecalho
                For _w3 := 1 To Len(aCabec)
                    If ValType(aCabec[_w3,02]) == "B"
                        aCabec[_w3,02] := Eval(aCabec[_w3,02])
                    EndIf
                Next
            EndIf
            For _w3 := 1 To Len(aItens[_w1])
                If ValType(aItens[_w1,_w3,02]) == "B"
                    aItens[_w1,_w3,02] := Eval(aItens[_w1,_w3,02])
                EndIf
            Next
        Next
        DbSelectArea("SC1")
        SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
        aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Preparando ExecAuto MATA110...", "", "", 80, "PEDIDO" })
        MsExecAuto({|v,x,y| MATA110(v,x,y) }, aCabec, aItens, nOpc)
        If lMsErroAuto .Or. SC1->(EOF()) .Or. SC1->C1_NUM <> aCabec[01,02] // Erro
            aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Preparando ExecAuto MATA110... Falha!", "", "", 80, "UPDERROR" })
            _aRet[1] := 1 // 1=Erro
        Else // Sucesso
            _aRet[1] := 2 // 2=Sucesso
            _aRet[2] := SC1->C1_NUM
            aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Solicitacao: " +_aRet[2], "Preparando ExecAuto MATA110...", "", 80, "PEDIDO" })
            DbSelectArea("SC1")
            SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
            If SC1->(DbSeek( _cFilSC1 + _aRet[2] ))
                While SC1->(!EOF()) .And. SC1->C1_FILIAL + SC1->C1_NUM == _cFilSC1 + _aRet[2]
                    nIteSol++
                    If nIteSol <= Len( aBdvky ) // Itens conforme passado no ExecAuto
                        ZRP->(DbGoto( aRecsPos[01,02, aBdvky[ nIteSol ] ]))
                        RecLock("ZRP",.F.)
                        ZRP->ZRP_PROC01 := "SC1 " + cEmpAnt + "/" + cFilAnt + " " + SC1->C1_NUM + "/" + SC1->C1_ITEM        // Processamento
                        ZRP->ZRP_LOGP01 := DtoC(Date()) + " " + Time() + " " + cUserName                                    // Log Processamento
                        ZRP->(MsUnlock())
                        aAdd(_aRet[5], SC1->(Recno()))
                    EndIf
                    SC1->(DbSkip())
                End
                aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Solicitacao: " + _aRet[2], "Preparando ExecAuto MATA110... Sucesso!", "", 80, "OK" })
            Else // Solicitacao nao encontrada
                aAdd(_aRet[04], { "Gerando Solicitacao de Compra...", "Preparando ExecAuto MATA110... Falha!", "", "", 80, "UPDERROR" })
            EndIf
        EndIf
    EndIf
EndIf
Return _aRet // -1=Sem Itens a gerar 1=Falha 2=Sucesso

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ExeAutC5 ºAutor ³Jonathan Schmidt Alvesº Data ³ 22/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento ExecAuto MATA410 (Pedidos de Venda)          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ExeAutC5()
Local _w1
Local _w3
Local _aRet := { 0, Space(06), 0, {}, {} }
// Processamento ExecAuto
Local nOpc := 3
Local aCabec := {}
Local aItens := {}
Local aBdvky := {}
// Controle de log ZRP
Local nItePed := 0
Private _cFilSC5 := xFilial("SC5")
Private _cFilSC6 := xFilial("SC6")
// Variaveis do aRegra
Private aRecsPos := {}
Private aVarsAux := {}
Private lMsErroAuto := .F.
DbSelectArea("SF4")
SF4->(dbsetOrder(1)) // F4_FILIAL + F4_CODIGO
DbSelectArea("SB2")
SB2->(DbSetOrder(1)) // B2_FILIAL + B2_COD + B2_LOCAL
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
aAdd(_aRet[04], { "Gerando Pedido de Venda...", "Carregando...", "", "", 80, "PEDIDO" })
If Type("PARAMIXB") == "A" .And. Len(PARAMIXB) == 3
    aCabec  := aClone(PARAMIXB[01,02])          // Cabecalho SC5
    aItens  := aClone(PARAMIXB[01,03])          // Itens SC6
    aBdvky  := aClone(PARAMIXB[01,04])          // Elementos de Bodovsky
    aRecsPos := aClone(PARAMIXB[02])            // Recnos Posicionamentos
    If Len(aCabec) > 0 .And. Len(aItens) > 0
        // Bodovsky
        For _w1 := 1 To Len(aBdvky) // Rodo conforme a qtde de posicionamentos desse ExecAuto
            // Reposiciono todos os recnos
            For _w3 := 1 To Len(aRecsPos) // Rodo nas tabelas de recnos posicionamento
                If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
                    If aBdvky[ _w1 ] <= Len(aRecsPos[_w3,02])
                        (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02, aBdvky[ _w1 ] ])) // Se for 0 vai pra EOF
                    EndIf
                EndIf
            Next
            // Reprocessamento do Cabecalho/Itens caso exista Bloco de Codigo
            ConOut("ExeAutC5: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Reprocessamento dos Blocos de Codigo...")
            If _w1 == 1 // No primeiro item, reavalio o cabecalho
                For _w3 := 1 To Len(aCabec)
                    If ValType(aCabec[_w3,02]) == "B"

                        ConOut("ExeAutC5: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Bloco Codigo (cabec)!")

                        aCabec[_w3,02] := Eval(aCabec[_w3,02])
                    EndIf
                Next
            EndIf
            For _w3 := 1 To Len(aItens[_w1])
                If ValType(aItens[_w1,_w3,02]) == "B"

                    ConOut("ExeAutC5: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Bloco Codigo (itens)!")
                    aItens[_w1,_w3,02] := Eval(aItens[_w1,_w3,02])
                EndIf
            Next
            ConOut("ExeAutC5: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Reprocessamento dos Blocos de Codigo... Concluido!")
        Next
        DbSelectArea("SC5")
        SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
        DbSelectArea("SC6")
        SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
        aAdd(_aRet[04], { "Gerando Pedido de Venda...", "Preparando ExecAuto MATA410...", "", "", 80, "PEDIDO" })
        MsExecAuto({|x,y,z|, MATA410(x,y,z) }, aCabec, aItens, nOpc)
        If lMsErroAuto .Or. SC5->(EOF()) // Falha ou geracao com algum problema
            aAdd(_aRet[04], { "Gerando Pedido de Venda...", "Preparando ExecAuto MATA410... Falha!", "", "", 80, "UPDERROR" })
            _aRet[1] := 1 // 1=Falha
        Else // Sucesso
            aAdd(_aRet[04], { "Gerando Pedido de Venda...", "Preparando ExecAuto MATA410...", "", "", 80, "PEDIDO" })
            // Trecho de relacionamento SC6 x ZRP
            DbSelectArea("SC5")
            SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
            _aRet[1] := 2 // 2=Sucesso
            _aRet[2] := SC5->C5_NUM
            _aRet[3] := SC5->(Recno())
            DbSelectArea("SC6")
            SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
            If SC6->(DbSeek( _cFilSC6 + _aRet[2]))
                While SC6->(!EOF()) .And. SC6->C6_FILIAL + SC6->C6_NUM == _cFilSC6 + _aRet[2]
                    nItePed++
                    If nItePed <= Len( aBdvky ) // Itens conforme passado no ExecAuto
                        ZRP->(DbGoto(aRecsPos[01,02, aBdvky [ nItePed ] ]))
                        RecLock("ZRP",.F.)
                        ZRP->ZRP_PROC02 := "SC5 " + cEmpAnt + "/" + cFilAnt + " " + SC6->C6_NUM + "/" + SC6->C6_ITEM        // Processamento
                        ZRP->ZRP_LOGP02 := DtoC(Date()) + " " + Time() + " " + cUserName                                    // Log Processamento
                        ZRP->(MsUnlock())
                        aAdd(_aRet[5], SC6->(Recno()))
                    EndIf
                    SC6->(DbSkip())
                End
                aAdd(_aRet[04], { "Gerando Pedido de Venda...","Pedido de Venda: " + _aRet[2], "Preparando ExecAuto MATA410... Sucesso!", "", 80, "OK" })
            Else // Pedido nao encontrado
                aAdd(_aRet[04], { "Gerando Pedido de Venda...", "Preparando ExecAuto MATA410... Falha!", "", "", 80, "UPDERROR" })
            EndIf
        EndIf
    EndIf
EndIf
Return _aRet // -1=Sem Itens a gerar 1=Falha 2=Sucesso

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ExeAutC7 ºAutor ³Jonathan Schmidt Alvesº Data ³ 22/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento ExecAuto MATA120 (Pedidos de Compra)         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ExeAutC7()
Local _w1
Local _w3
Local _aRet := { 0, Space(06), 0, {}, {} }
// Processamento ExecAuto
Local nOpc := 3
Local aCabec := {}
Local aItens := {}
Local aBdvky := {}
// Controle de log ZRP
Local nItePed := 0
Private _cFilSC7 := xFilial("SC7")
Private __cZRPPed := Space(06)
// Variaveis do aRegra
Private aRecsPos := {}
Private aVarsAux := {}
Private lMsErroAuto := .F.
aAdd(_aRet[04], { "Gerando Pedido de Compra...", "Carregando...", "", "", 80, "PEDIDO" })
If Type("PARAMIXB") == "A" .And. Len( PARAMIXB ) == 3
    aCabec  := aClone(PARAMIXB[01,02])      // Cabecalho SC7
    aItens  := aClone(PARAMIXB[01,03])      // Itens SC7
    aBdvky  := aClone(PARAMIXB[01,04])      // Elementos de Bodovsky
    aRecsPos := aClone(PARAMIXB[02])        // Recnos Posicionamentos
    If Len(aCabec) > 0 .And. Len(aItens) > 0
        // Bodovsky
        For _w1 := 1 To Len(aBdvky) // Rodo conforme a qtde de posicionamentos desse ExecAuto
            // Reposiciono todos os recnos
            For _w3 := 1 To Len(aRecsPos) // Rodo nas tabelas de recnos posicionamento
                If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
                    If aBdvky[ _w1 ] <= Len(aRecsPos[_w3,02])
                        (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02, aBdvky[ _w1 ] ])) // Se for 0 vai pra EOF
                    EndIf
                EndIf
            Next
            // Reprocessamento do Cabecalho/Itens caso exista Bloco de Codigo
            If _w1 == 1 // No primeiro item, reavalio o cabecalho
                For _w3 := 1 To Len(aCabec)
                    If ValType(aCabec[_w3,02]) == "B"
                        aCabec[_w3,02] := Eval(aCabec[_w3,02])
                    EndIf
                Next
            EndIf
            For _w3 := 1 To Len(aItens[_w1])
                If ValType(aItens[_w1,_w3,02]) == "B"
                    aItens[_w1,_w3,02] := Eval(aItens[_w1,_w3,02])
                EndIf
            Next
        Next
        DbSelectArea("SC7")
        SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM
        aAdd(_aRet[04], { "Gerando Pedido de Compra...", "Preparando ExecAuto MATA120...", "", "", 80, "PEDIDO" })
        __cUserID := "000000"
        MsExecAuto({|u,v,x,y|, MATA120(u,v,x,y) }, 1, aCabec, aItens, nOpc)
        If lMsErroAuto .Or. SC7->(EOF()) // Falha ou geracao com algum problema
            _aRet[1] := 1 // 1=Falha
            aAdd(_aRet[04], { "Gerando Pedido de Compra...", "Preparando ExecAuto MATA120... Falha!", "", "", 80, "UPDERROR" })
        Else // Sucesso
            _aRet[1] := 2 // 2=Sucesso
            _aRet[2] := SC7->C7_NUM
            // Trecho de relacionamento SC7 x ZRP
            DbSelectArea("SC7")
            SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM + C7_ITEM
            If SC7->(DbSeek( _cFilSC7 + _aRet[2]))
                _aRet[1] := 2 // 2=Sucesso
                _aRet[3] := SC7->(Recno())
                While SC7->(!EOF()) .And. SC7->C7_FILIAL + SC7->C7_NUM == _cFilSC7 + _aRet[2]
                    nItePed++
                    If nItePed <= Len( aBdvky ) // Itens conforme passado no ExecAuto
                        ZRP->(DbGoto(aRecsPos[01,02, aBdvky[ nItePed ] ]))
                        RecLock("ZRP",.F.)
                        ZRP->ZRP_PROC01 := "SC7 " + cEmpAnt + "/" + cFilAnt + " " + SC7->C7_NUM + "/" + SC7->C7_ITEM        // Processamento
                        ZRP->ZRP_LOGP01 := DtoC(Date()) + " " + Time() + " " + cUserName                                    // Log Processamento
                        ZRP->(MsUnlock())
                        aAdd(_aRet[5], SC7->(Recno()))
                    EndIf
                    SC7->(DbSkip())
                End
                aAdd(_aRet[04], { "Gerando Pedido de Compra...","Pedido de Compra: " + _aRet[2], "Preparando ExecAuto MATA120... Sucesso!!", "", 80, "OK" })
            EndIf
        EndIf
    EndIf
EndIf
Return _aRet // -1=Sem Itens a gerar 1=Falha 2=Sucesso

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ExeAutW0 ºAutor ³Jonathan Schmidt Alvesº Data ³ 29/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento ExecAuto EICSI400 (Solicitacao Importacao)   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ExeAutW0()
Local _w1
Local _w3
Local _aRet := { 0, Space(06), 0, {}, {} }
// Processamento ExecAuto
Local nOpc := 3
Local aCabec := {}
Local aItens := {}
Local aBdvky := {}
// Controle de log ZRP
Local aIteSol := {}
Local nIteSol := 0
Private _cFilSW0 := xFilial("SW0")
Private _cFilSW1 := xFilial("SW1")
// Variaveis do aRegra
Private aRecsPos := {}
Private aVarsAux := {}
Private lMsErroAuto := .F.
DbSelectArea("SW0")
SW0->(DbSetOrder(1)) // W0_FILIAL + W0__CC + W0__NUM
DbSelectArea("SW1")
SW1->(DbSetOrder(1)) // W1_FILIAL + W1_CC + W1_SI_NUM + ...
DbSelectArea("SY1")
SY1->(DbSetOrder(1)) // Y1_FILIAL + Y1_CC + ...
DbSelectArea("SY2")
SY2->(DbSetOrder(1)) // Y2_FILIAL + Y2_SIGLA
DbSelectArea("SY3")
SY3->(DbSetOrder(1)) // Y3_FILIAL + Y3_COD
aAdd(_aRet[04], { "Gerando Solicitacao de Importacao...", "Carregando...", "", "", 80, "PEDIDO" })
If Type("PARAMIXB") == "A" .And. Len( PARAMIXB ) == 3
    aCabec  := aClone(PARAMIXB[01,02])      // Cabecalho SW0
    aItens  := aClone(PARAMIXB[01,03])      // Itens SW1
    aBdvky  := aClone(PARAMIXB[01,04])      // Elementos de Bodovsky
    aRecsPos := aClone(PARAMIXB[02])        // Recnos Posicionamentos
    If Len(aCabec) > 0 .And. Len(aItens) > 0
        // Bodovsky
        For _w1 := 1 To Len(aBdvky) // Rodo conforme a qtde de posicionamentos desse ExecAuto
            // Reposiciono todos os recnos
            For _w3 := 1 To Len(aRecsPos) // Rodo nas tabelas de recnos posicionamento
                If Len(aRecsPos[_w3,02]) > 0 // Do registro conforme _w1 (por item)
                    If aBdvky[ _w1 ] <= Len(aRecsPos[_w3,02])
                        (aRecsPos[_w3,01])->(DbGoto(aRecsPos[_w3,02, aBdvky[ _w1 ] ])) // Se for 0 vai pra EOF
                    EndIf
                EndIf
            Next
            // Reprocessamento do Cabecalho/Itens caso exista Bloco de Codigo
            If _w1 == 1 // No primeiro item, reavalio o cabecalho
                For _w3 := 1 To Len(aCabec)
                    If ValType(aCabec[_w3,02]) == "B"
                        aCabec[_w3,02] := Eval(aCabec[_w3,02])
                    EndIf
                Next
            EndIf
            For _w3 := 1 To Len(aItens[_w1])
                If ValType(aItens[_w1,_w3,02]) == "B"
                    aItens[_w1,_w3,02] := Eval(aItens[_w1,_w3,02])
                EndIf
            Next
        Next
        DbSelectArea("SW0")
        SW0->(DbSetOrder(1)) // W0_FILIAL + W0__CC + W0__NUM
        aAdd(_aRet[04], { "Gerando Solicitacao de Importacao...", "Preparando ExecAuto EICSI400...", "", "", 80, "PEDIDO" })
        MsExecAuto({|x,y,z|, EICSI400(x,y,z)}, aCabec, aItens, nOpc)
        If lMsErroAuto .Or. SW0->(EOF()) // Falha ou geracao com algum problema
            _aRet[1] := 1 // 1=Falha
            // MostraErro()
            // _cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
            // ConOut(_cErro)
        Else // Sucesso
            _aRet[1] := 2 // 2=Sucesso
            _aRet[2] := SW0->W0__NUM
            SW1->(DbSetOrder(1)) // W1_FILIAL + W1_CC + W1_SI_NUM + ...
            If SW1->(DbSeek( _cFilSW1 + SW0->W0__CC + _aRet[2]))
                While SW1->(!EOF()) .And. SW1->W1_FILIAL + SW1->W1_CC + SW1->W1_SI_NUM == _cFilSW1 + SW0->W0__CC + _aRet[2]
                    //            {      Recno SW1, Item Posicao  }
                    aAdd(aIteSol, { SW1->(Recno()), SW1->W1_POSIT })
                    SW1->(DbSkip())
                End
                If Len( aIteSol ) > 0 // Itens carregados
                    aSort( aIteSol,,, {|x,y|, x[ 02 ] < y[ 02 ] }) // Ordenado pelo Item (conforme foi passado no ExecAuto)
                    _aRet[3] := SW0->(Recno())
                    For _w1 := 1 To Len( aIteSol )
                        SW1->(DbGoto( aIteSol[ _w1, 01 ] )) // Posiciono SW1 na ordem W1_POSIT
                        If SW1->(!EOF())
                            nIteSol++
                            If nIteSol <= Len( aBdvky ) // Itens conforme passado no ExecAuto
                                ZRP->(DbGoto( aRecsPos[01,02, aBdvky[ nIteSol ] ]))
                                RecLock("ZRP",.F.)
                                ZRP->ZRP_PROC01 := "SW1 " + cEmpAnt + "/" + cFilAnt + " " + SW1->W1_SI_NUM + "/" + SW1->W1_POSIT    // Processamento
                                ZRP->ZRP_LOGP01 := DtoC(Date()) + " " + Time() + " " + cUserName                                    // Log Processamento
                                ZRP->(MsUnlock())
                                aAdd(_aRet[5], SW1->(Recno()))
                            EndIf
                        EndIf
                    Next
                    aAdd(_aRet[04], { "Gerando Solicitacao de Importacao...","Solicitacao de Importacao: " + _aRet[2], "Preparando ExecAuto EICSI400... Sucesso!!", "", 80, "OK" })
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return _aRet // -1=Sem Itens a gerar 1=Falha 2=Sucesso

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ UPDEMPFIL ºAutor³ Jonathan Schmidt Alvesº Data³ 22/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para alterar Empresa/Filial em tempo de execucao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Argumentos:                                                º±±
±±º          ³ _cEmp: Empresa a ser processada                            º±±
±±º          ³ _cFil: Filial a ser processada                             º±±
±±º          ³ _aTabsSX: Tabelas SX's                                     º±±
±±º          ³ _aTabsFile: Tabelas de arquivos SQL                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function UPDEMPFIL(_cEmp, _cFil, _aTabsSX, _aTabsFile)
FECH_ARQS(_cEmp,_cFil,_aTabsFile)
ABRE_SX(_cEmp,_cFil,_aTabsSX)
ABRE_ARQS(_cEmp,_cFil,_aTabsFile)
Return

Static Function FECH_ARQS(_cEmp, _cFil, _aTabs)
Local _nL
For _nL := 1 To Len(_aTabs)
	If Select(_aTabs[_nL]) > 0
		DbSelectArea(_aTabs[_nL])
		DbCloseArea()
	EndIf
Next
Return

Static Function ABRE_ARQS(_cEmp, _cFil, _aTabs)
Local _nL
For _nL := 1 To Len(_aTabs)
	If Select(_aTabs[_nL]) > 0
		DbSelectArea(_aTabs[_nL])
		DbCloseArea()
	EndIf
    If SX2->(DbSeek(_aTabs[_nL]))
	    _cModo := SX2->X2_MODO // If(Empty(_aTabs[_nL]),"C","E")
    EndIf
	xRet := EmpOpenFile(@_aTabs[_nL],@_aTabs[_nL],1,.T.,@_cEmp,@_cModo)
    If _cModo == "C" .And. At( _aTabs[_nL] + "E", cArqTab ) > 0 // Tabela agora eh compartilhada mas estava como exclusiva
        cArqTab := StrTran( cArqTab, _aTabs[_nL] + "E", _aTabs[_nL] + "C" )
    ElseIf _cModo == "E" .And. At( _aTabs[_nL] + "C", cArqTab ) > 0 // Tabela agora eh exclusiva mas estava como compartilhada
        cArqTab := StrTran( cArqTab, _aTabs[_nL] + "C", _aTabs[_nL] + "E" )
    EndIf
Next
Return


Static Function ABRE_SX(_cEmp, _cFil, _aTabs)
Local _nL
DbCloseAll() // Fecho todos os arquivos abertos
OpenSM0() // Abrir Tabela SM0 (Empresa/Filial)
DbSelectArea("SM0") // Abro a SM0
SM0->(DbSetOrder(1))
SM0->(DbSeek(_cEmp + _cFil,.T.)) // Posiciona Empresa
cEmpAnt := SM0->M0_CODIGO // Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt) // Abro a empresa que eu desejo trabalhar
OpenSxs() // abre o dicionário de dados
InitPublic() // inicia as variáveis públicas
SetsDefault() // configura os valores default (set dele, set century, etc)
For _nL := 1 To Len(_aTabs)
	If Select(_aTabs[_nL]) > 0
		DbSelectArea(_aTabs[_nL])
		DbCloseArea()
	EndIf
	_cTabela := _aTabs[_nL] + cEmpAnt + "0"
	DbUseArea(.T.,"TOPCONN", _cTabela,_aTabs[_nL], .T., .F.) // adcionado o drive "TOPCONN"
	DbSetIndex(_cTabela)
Next
Return
