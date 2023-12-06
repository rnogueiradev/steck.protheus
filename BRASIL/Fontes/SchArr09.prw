#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchArr09 ºAutor ³Jonathan Schmidt Alvesº Data ³ 07/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamentos de Arrumacao Locais (ACD)                     º±±
±±º          ³                                                            º±±
±±º          ³ Tabelas de processamento principais:                       º±±
±±º          ³ ZR1: Cadastro de Arrumacao                                 º±±
±±º          ³ ZR2: Arrumacoes x Enderecos x Operadores                   º±±
±±º          ³ ZR3: Arrumacoes processadas                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchArr09()
Local _w1
Local lEndOk := .T.
Local lZR2Seek := .F.
Local aAreaSBF := {}
Local nArrFnd := 0
Local nArrPrc := 0
// Opcoes Operador/Auditor
Local aHdr01 := { "Status Arrumacao:" }
Local aCls01 := { { "A1=Adequado" }, { "D1=Nao Encontrado" } }
Local aSze01 := { 40 }
Local nPos01 := 1
// Variaveis Filiais
Private _cFilZR1 := xFilial("ZR1")
Private _cFilZR2 := xFilial("ZR2")
Private _cFilZR3 := xFilial("ZR3")
Private _cFilSB1 := xFilial("SB1")
Private _cFilNNR := xFilial("NNR")
Private _cFilSBE := xFilial("SBE")
Private _cFilSBF := xFilial("SBF")
Private _cFilCB1 := xFilial("CB1")
// Codigo Arrumacao
Private cCodArr := Space(04)
Private cCodLoc := Space(02)
Private cCodEnd := Space(15)
// Abertura tabelas
DbSelectArea("ZR1") // Cadastro de Arrumacoes
ZR1->(DbSetOrder(1)) // ZR1_FILIAL + ZR1_ARRUMA
DbSelectArea("ZR2") // Arrumacoes x Operadores
ZR2->(DbSetOrder(4)) // ZR2_FILIAL + ZR2_CODSTA + ZR2_CODOPE + ZR2_CODEND + ZR2_CODLOC + ZR2_ARRUMA
DbSelectArea("ZR3") // Processamentos Arrumacoes
ZR3->(DbSetOrder(2)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_CODOPE + ZR3_CODLOC + ZR3_CODEND + ZR3_CODPRO
DbSelectArea("SB1") // Produtos
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("NNR") // Armazens
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
DbSelectArea("SBE") // Enderecos
SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
DbSelectArea("SBF") // Saldos por Endereco
SBF->(DbSetOrder(1)) // BF_FILIAL + BF_LOCAL + BF_LOCALIZ + BF_PRODUTO + BF_NUMSERI + BF_LOTECTL + BF_NUMLOTE
DbSelectArea("CB1") // Operadores
CB1->(DbSetOrder(2)) // CB1_FILIAL + CB1_CODUSR
If CB1->(!DbSeek(_cFilCB1 + __cUserID))
    VTAlert("Usuario nao encontrado no cadastro de operadores (CB1)!" + Chr(13) + Chr(10) + "Cod Usuario: " + __cUserID,"[-]",.T.,1500)
Else // Operador encontrado
    While .T.
        If !Empty(cCodArr) // Ja fez uma arrumacao
            If !CBYesNo("Deseja realizar uma nova arrumacao?",".:AVISO:.",.T.)
                Exit
            EndIf
            cCodArr := Space(04)
        EndIf
        VTAlert("Carregando Arrumacoes do Operador... Aguarde...","[-]",.T.,1500)
        nArrFnd := 0 // Arrumacoes ZR2 encontradas
        nArrPrc := 0 // Arrumacoes ZR2 processadas no armazem
        For _w1 := 3 To 1 Step -1 // 01=Agendado 02=Em Arrumacao 03=Em Processamento
            If ZR2->(DbSeek(_cFilZR2 + StrZero( _w1, 2) + CB1->CB1_CODOPE))
                While ZR2->(!EOF()) .And. ZR2->ZR2_FILIAL + ZR2->ZR2_CODSTA + ZR2->ZR2_CODOPE == _cFilZR2 + StrZero( _w1, 2) + CB1->CB1_CODOPE // Amarracoes Arrumacao x Operador
                    lZR2Seek := .F.
                    If Empty(cCodArr) .Or. cCodArr == ZR2->ZR2_ARRUMA // Arrumacao conforme
                        cCodArr := ZR2->ZR2_ARRUMA
                        If ZR1->(DbSeek( _cFilZR1 + ZR2->ZR2_ARRUMA ))
                            nArrFnd++ // Arrumacoes encontradas
                            If SoftLock("ZR2") // .T.=Registro travado (pode estar ja sendo arrumado por outro operador)
                                If ZR2->ZR2_CODSTA <> "03" // 03=Em Processamento
                                    RecLock("ZR2",.F.)
                                    ZR2->ZR2_CODSTA := "03" // 03=Em Processamento
                                    ZR2->(MsUnlock())
                                ElseIf ZR3->(DbSeek( _cFilZR3 + ZR2->ZR2_ARRUMA )) .And. ZR3->ZR3_CODOPE <> ZR2->ZR2_CODOPE // Mas tem algum operador do Armazem + Endereco e nao sou eu... abandona
                                    ZR2->(MsUnlock())
                                    ZR2->(DbSkip())
                                    Loop
                                EndIf
                                // Confirmacao do endereco onde o operador esta
                                If SoftLock("ZR2") // .T.=Registro travado (pode estar ja sendo arrumado por outro operador)
                                    VTCLEARBUFFER()
                                    VTCLEAR
                                    cCodEnd := Space(15)
                                    @00,00 VTSAY PadR("Arrumacao: " + ZR1->ZR1_ARRUMA,VTMaxCol())                           // Arrumacao
                                    @01,00 VTSAY PadR(DtoC(ZR1->ZR1_PRVINI) + " a " + DtoC(ZR1->ZR1_PRVFIM),VTMaxCol())     // Inicio Fim
                                    @02,00 VTSAY PadR("Armazem: " + ZR2->ZR2_CODLOC,VTMaxCol())                             // Armazem
                                    @03,00 VTSAY PadR("Endereco: " + ZR2->ZR2_CODEND,VTMaxCol())                            // Endereco
                                    @04,00 VTGET cCodEnd PICTURE "@!" VALID VlCodEnd(ZR2->ZR2_CODLOC, ZR2->ZR2_CODEND, cCodEnd)
                                    VTREAD
                                    If VTLastKey() == 27 // Esc
                                        If CBYesNo("Confirma saida?",".:AVISO:.",.T.)
                                            _w1 := 0 // Forca saida do For Next
                                            Exit
                                        EndIf
                                    EndIf
                                    // Carregar quais produtos estao nesse Armazem + Endereco no exato momento (SBF)
                                    If SBE->(DbSeek( _cFilSBE + ZR2->ZR2_CODLOC + ZR2->ZR2_CODEND ))
                                        If SBF->(DbSeek( _cFilSBF + SBE->BE_LOCAL + SBE->BE_LOCALIZ ))
                                            While SBF->(!EOF()) .And. SBF->BF_FILIAL + SBF->BF_LOCAL + SBF->BF_LOCALIZ == _cFilSBF + SBE->BE_LOCAL + SBE->BE_LOCALIZ
                                                If SB1->(DbSeek( _cFilSB1 + SBF->BF_PRODUTO ))
                                                    If ZR3->(!DbSeek( _cFilZR3 + ZR2->ZR2_ARRUMA + SBE->BE_LOCAL + SBF->BF_LOCALIZ + ZR2->ZR2_CODOPE + SB1->B1_COD ))
                                                        VTCLEARBUFFER()
                                                        VTCLEAR
                                                        @00,00 VTSAY PadR( { "Produto: ","Prod: ", "" } [ Int((Len(AllTrim(SB1->B1_COD)) / 6) + 1)] + SB1->B1_COD,VTMaxCol())   // Codigo do Produto
                                                        @01,00 VTSAY PadR(SB1->B1_DESC,VTMaxCol())                                                                              // Descricao do Produto
                                                        nPos01 := VTaBrowse(02,00,,,aHdr01, aCls01, aSze01, "u_ProcDvgc()", nPos01 := 1)                                        // Browse Status Arrumacao
                                                        If nPos01 > 0 // Executa Selecao da linha
                                                            RecLock("ZR3",.T.)
                                                            ZR3->ZR3_FILIAL := _cFilZR3                         // Filial
                                                            ZR3->ZR3_ARRUMA := ZR2->ZR2_ARRUMA                  // Arrumacao
                                                            ZR3->ZR3_CODLOC := ZR2->ZR2_CODLOC                  // Armazem
                                                            ZR3->ZR3_CODEND := ZR2->ZR2_CODEND                  // Endereco
                                                            ZR3->ZR3_CODOPE := ZR2->ZR2_CODOPE                  // Operador
                                                            ZR3->ZR3_CODPRO := SB1->B1_COD                      // Produto
                                                            ZR3->ZR3_DTEXEC := Date()                           // Data Execucao        Ex: 07/06/2021
                                                            ZR3->ZR3_HREXEC := StrTran(Time(),":","")           // Hora Execucao        Ex: "210332"
                                                            ZR3->ZR3_STAOPE := Left( aCls01[ nPos01, 01 ], 02)  // Status Operador      Ex: "D1"=Divergencia produto nao encontrado
                                                            ZR3->ZR3_STAAUD := "N0" // "N0"=Nao Auditado
                                                            ZR3->(MsUnlock())
                                                            nArrPrc++
                                                            // Verifico se terminou arrumacao do endereco
                                                            lEndOk := .T.
                                                            aAreaSBF := SBF->(GetArea())
                                                            If SBF->(DbSeek( _cFilSBF + SBE->BE_LOCAL + SBE->BE_LOCALIZ ))
                                                                While SBF->(!EOF()) .And. SBF->BF_FILIAL + SBF->BF_LOCAL + SBF->BF_LOCALIZ == _cFilSBF + SBE->BE_LOCAL + SBE->BE_LOCALIZ
                                                                    If ZR3->(!DbSeek( _cFilZR3 + ZR2->ZR2_ARRUMA + SBE->BE_LOCAL + SBF->BF_LOCALIZ + ZR2->ZR2_CODOPE + SBF->BF_PRODUTO ))
                                                                        lEndOk := .F. // Algum produto ainda nao considero no ZR3... mantem como pendente
                                                                        Exit
                                                                    EndIf
                                                                    SBF->(DbSkip())
                                                                End
                                                            EndIf
                                                            RestArea(aAreaSBF)
                                                            If lEndOk // .T.=Endereco concluido (todos os SBF existem no ZR3)
                                                                // Conclui o Endereco (ZR2), verifica situacao da Arrumacao (ZR1), mostra mensagens
                                                                lZR2Seek := SchCnc07(_w1, "12")
                                                                Exit
                                                            EndIf
                                                        EndIf
                                                    EndIf // Fecha o ZR3
                                                EndIf // Fecha o SB1
                                                SBF->(DbSkip())
                                            End
                                        Else // Nenhum produto mais no endereco
                                            // Entao vamos marcar como concluido o armazem/endereco
                                            VTAlert("Nenhum produto com saldo encontrado neste endereco!","[-]",.T.,2000)
                                            lZR2Seek := SchCnc07(_w1, "2")
                                        EndIf // Fecha o SBF
                                    EndIf // Fecha o SBE
                                EndIf // Fecha o SoftLock ZR2
                            EndIf // Fecha o SoftLock ZR2
                        EndIf // Fecha o ZR1
                        ZR2->(MsUnlock()) // Destrava SoftLock do ZR2 (caso tenha travado)
                    EndIf // ZR1 (Arrumacao conforme)
                    If !lZR2Seek // .F.=Nao houve DbSeek() ZR2 ou nao com sucesso, entao... DbSkip()
                        ZR2->(DbSkip())
                    EndIf
                End
            EndIf
        Next
        If nArrFnd == 0 // Nenhuma Arrumacao ZR2 encontrada para o armazem
            VTAlert("Nenhuma arrumacao pendente encontrada!","[-]",.T.,2500)
        ElseIf nArrPrc > 0  // Arrumacoes ZR2 processadas
            VTAlert("Arrumacao concluida!","[-]",.T.,2500)
        EndIf
        Exit
    End
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchCnc07 ºAutor ³Jonathan Schmidt Alvesº Data ³ 09/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera status do endereco para "04"=Concluido              º±±
±±º          ³                                                            º±±
±±º          ³ Verifica se todos os produtos do endereco estao concluidos º±±
±±º          ³ e atualiza o ZR1 como "04"=Concluido                       º±±
±±º          ³                                                            º±±
±±º          ³ Mostra as mensagens de alerta conforme parametro cMsgs     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SchCnc07(_w1, cMsgs) // Conclui arrumacao do endereco
Local lArrOk := .T.
Local cCodPro := Space(15)
RecLock("ZR2",.F.)
ZR2->ZR2_CODSTA := "04" // 04=Concluido
ZR2->(MsUnlock())
ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
If ZR2->(DbSeek(_cFilZR2 + ZR1->ZR1_ARRUMA + SBE->BE_LOCAL))
    While ZR2->(!EOF()) .And. ZR2->ZR2_FILIAL + ZR2->ZR2_ARRUMA + ZR2->ZR2_CODLOC == _cFilZR2 + ZR1->ZR1_ARRUMA + SBE->BE_LOCAL
        If ZR2->ZR2_CODEND == SBE->BE_LOCALIZ // Mesmo endereco
            RecLock("ZR2",.F.)
            ZR2->ZR2_CODSTA := "04" // 04=Concluido
            ZR2->(MsUnlock())
        ElseIf lArrOk
            If ZR2->ZR2_CODSTA <> "04" // Outros enderecos ainda nao concluidos
                lArrOk := .F.
            EndIf
        ElseIf ZR2->ZR2_CODEND > SBE->BE_LOCALIZ // Se ja passou pelo cCodEnd, e existem enderecos pendentes, ja pode sair do loop
            Exit
        EndIf
        ZR2->(DbSkip())
    End
EndIf                                 

While CBYesNo("Existem produtos a mais no endereco?",".:AVISO:.",.T.)
    VTCLEARBUFFER()
    VTCLEAR
    cCodPro := Space(30)
    @00,00 VTSAY PadR("Arrumacao: " + ZR1->ZR1_ARRUMA,VTMaxCol())           // Arrumacao
    @01,00 VTSAY PadR("Armazem: " + SBE->BE_LOCAL,VTMaxCol())               // Armazem
    @02,00 VTSAY PadR("Endereco: " + SBE->BE_LOCALIZ,VTMaxCol())            // Endereco
    @03,00 VTSAY PadR("Produto: ",VTMaxCol())                               // Produto
    @04,00 VTGET cCodPro PICTURE "@!" VALID VlCodPro(cCodPro)
    VTREAD
    If VTLastKey() == 27 // Esc
        If CBYesNo("Encerra produtos a mais?",".:AVISO:.",.T.)
            Exit
        EndIf
    Else // Gravar produto a mais ZR3
        If ZR3->(DbSeek(_cFilZR3 + ZR1->ZR1_ARRUMA + SBE->BE_LOCAL + SBE->BE_LOCALIZ + CB1->CB1_CODOPE + SB1->B1_COD))
            RecLock("ZR3",.F.)
        Else
            RecLock("ZR3",.T.)
            ZR3->ZR3_FILIAL := _cFilZR3                     // Filial
            ZR3->ZR3_ARRUMA := ZR1->ZR1_ARRUMA              // Arrumacao
            ZR3->ZR3_CODLOC := SBE->BE_LOCAL                // Armazem
            ZR3->ZR3_CODEND := SBE->BE_LOCALIZ              // Endereco
            ZR3->ZR3_CODOPE := CB1->CB1_CODOPE              // Operador
            ZR3->ZR3_CODPRO := SB1->B1_COD                  // Produto
        EndIf
        ZR3->ZR3_DTEXEC := Date()                           // Data Execucao        Ex: 07/06/2021
        ZR3->ZR3_HREXEC := StrTran(Time(),":","")           // Hora Execucao        Ex: "210332"
        ZR3->ZR3_STAOPE := "D2"                             // Status Operador      Ex: "D2"=Divergencia produto a mais
        ZR3->ZR3_CODAUD := Space(06)
        ZR3->ZR3_DATAUD := CtoD("")
        ZR3->ZR3_HORAUD := ""
        ZR3->ZR3_STAAUD := "N0" // "N0"=Nao Auditado
        ZR3->ZR3_OBSLIV := Space(200)
        ZR3->ZR3_OBSAUD := Space(02)
        ZR3->(MsUnlock())
        VTAlert("Produto a mais gravado com sucesso!","[-]",.T.,1500)
    EndIf
End

// Verificar a situacao da Arrumacao inteira no ZR2
// Se ja foi concluida, atualizo o ZR1
If lArrOk // .T.=Arrumacao inteira concluida
    RecLock("ZR1",.F.)
    ZR1->ZR1_CODSTA := "04" // 04=Concluido
    ZR1->(MsUnlock())
    If cMsgs $ "2" // 2=Mostra mensagens de armazem
        VTAlert("Arrumacao concluida!" + Chr(13) + Chr(10) + "O processo sera reiniciado!","[-]",.T.,2500)
    EndIf
Else
    If ZR1->ZR1_CODSTA <> "02" // "02"=Em Arrumacao
        RecLock("ZR1",.F.)
        ZR1->ZR1_CODSTA := "02"
        ZR1->(MsUnlock())
    EndIf
    If cMsgs $ "1" // 1=Mostra mensagem de endereco
        VTAlert("Arrumacao do endereco concluida!" + Chr(13) + Chr(10) + "O processo sera reiniciado!","[-]",.T.,1500)
    EndIf
EndIf
ZR2->(DbSetOrder(3)) // ZR2_FILIAL + ZR2_CODSTA + ZR2_CODOPE + ZR2_CODLOC + ZR2_CODEND + ZR2_ARRUMA
Return ZR2->(DbSeek(_cFilZR2 + StrZero( _w1, 2) + CB1->CB1_CODOPE + SBE->BE_LOCAL))

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ProcDvgc ºAutor ³Jonathan Schmidt Alves º Data ³07/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento de teclas no VTaBrowse.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ProcDvgc(nModo, nElem, nElemW)
If nModo == 1 // Topo da lista
    VTBeep(3)
ElseIf nModo == 2 // Fim da lista
    VTBeep(3)
Else
    If VTLastkey() == 27 // Esc
        VTBeep(3)
        Return 0 // 0=Aborta selecao
    ElseIf VTLastkey() == 13 // Enter
        VtBeep(1)
        Return 1 // 1=Executa selecao
    EndIf
EndIf
Return 2 // 2=Continua VtaBrowse

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VlCodLoc ºAutor ³Jonathan Schmidt Alves º Data ³08/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do armazem.                                      º±±
±±º          ³                                                            º±±
±±º          ³ O armazem deve existir no cadastro de armazens NNR.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VlCodLoc(cCodLoc)
Local lRet := .T.
DbSelectArea("NNR")
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
If NNR->(!DbSeek(_cFilNNR + cCodLoc))
    VTAlert("Armazem nao encontrado no cadastro (NNR)!" + Chr(13) + Chr(10) + "Armazem: " + cCodLoc,"[-]",.T.,1500)
    lRet := .F.
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VlCodEnd ºAutor ³Jonathan Schmidt Alvesº Data ³ 08/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do endereco.                                     º±±
±±º          ³                                                            º±±
±±º          ³ O endereco deve ser o mesmo apresentado em tela conforme   º±±
±±º          ³ o ZR2_CODEND, para confirmar que via coletor o endereco    º±±
±±º          ³ em que o operador/auditor se encontra esta correto.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ cCodLoc: Armazem correto                                   º±±
±±º          ³ cCodEnd: Endereco correto que deve ser validado            º±±
±±º          ³ cEndVld: Codigo do endereco via coletor (Armaz + Ender)    º±±
±±º          ³          que deve ser comparado com cCodEnd                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VlCodEnd(cCodLoc, cCodEnd, cEndVld)
Local lRet := .F.
DbSelectArea("SBE")
SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
If RTrim(cCodEnd) == RTrim(cEndVld) // Preenchido exatamente o Endereco
    cEndVld := PadR(cEndVld,15) // _cLocDig := AllTrim(cLocaliz)
    lRet := .T.
ElseIf AllTrim(SubStr(cEndVld,3,Len(cEndVld))) == AllTrim(cCodEnd) // Preenchido Armazem + Endereco
    cEndVld := AllTrim(SubStr(cEndVld,3,Len(cEndVld)))
    lRet := .T.
Else // Endereco invalido
    VTAlert("Endereco preenchido incorreto!" + Chr(13) + Chr(10) + "Endereco: " + cEndVld,"[-]",.T.,1500)
    lRet := .F.
EndIf
If lRet // .T.=Valido
    If SBE->(!DbSeek(_cFilSBE + cCodLoc + cEndVld))
        VTAlert("Endereco nao encontrado no cadastro (SBE)!" + Chr(13) + Chr(10) + "Endereco: " + cEndVld,"[-]",.T.,1500)
        lRet := .F.
    EndIf
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VlCodEnd ºAutor ³Jonathan Schmidt Alvesº Data ³ 23/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do produto.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VlCodPro(cCodigo)
Local lRet := .T.
Local aBarras := {}
If At("=",cCodigo) > 0 .Or. At("|",cCodigo) > 0
    If At("=",cCodigo) > 0
        aBarras := StrTokArr( cCodigo, '=' )
    ElseIf At("|",cCodigo) > 0
        aBarras := StrTokArr( cCodigo, '|' )
    EndIf
    If Len(aBarras) < 3
        VTAlert("Codigo de barras Steck invalido!","[-]",.T.,1500)
        lRet := .F.
    Else
        cProduto 	:= Padr(aBarras[1], Len(SB1->B1_COD))
        cLote		:= Padr(aBarras[2], Len(SD3->D3_LOTECTL))
        nQtde		:= Val(aBarras[3]) / 1
        cCodigo     := cProduto
    EndIf
EndIf
If lRet // Valido
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
    If SB1->(!DbSeek(_cFilSB1 + PadR(cCodigo,15)))
        VTAlert("Produto nao encontrado no cadastro (SB1)!","[-]",.T.,1500)
        lRet := .F.
    EndIf
EndIf
Return lRet
