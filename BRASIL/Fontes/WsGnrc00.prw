#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc00 ºAutor ³Jonathan Schmidt Alves º Data ³29/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao mestre de comunicacao webservice Thomson.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cNomApi: Nome da Api                                       º±±
±±º          ³         Ex: "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA"    º±±
±±º          ³             "PKG_SFW_PRODUTOS.PRC_PRODUTO"                 º±±
±±º          ³                                                            º±±
±±º          ³ cTipInt: Tipo de Interface                                 º±±
±±º          ³         Ex: "01"=IN (Entrada)                              º±±
±±º          ³             "02"=OUT (Saida)                      WsGnrc00 º±±
±±º          ³                                                            º±±
±±º          ³ cTipReg: Tipo de Registro                                  º±±
±±º          ³         Ex: "P"=Registro posicionado                       º±±
±±º          ³             "C"=Consulta/Tela                              º±±
±±º          ³                                                            º±±
±±º          ³ cIntAmb: Integracao no Ambiente                            º±±
±±º          ³         Ex: "TST"=Ambiente de testes (QA)                  º±±
±±º          ³             "DSV"=Ambiente de desenvolvimento (PRJ)        º±±
±±º          ³             "PRD"=Ambiente de producao (PRO)               º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPrc: Mensagem de processamento                         º±±
±±º          ³         Ex: 0=Sem interface                                º±±
±±º          ³             1=MsgStop, MsgAlert, MsgInfo                   º±±
±±º          ³             2=AskYesNo                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Pontos de Entrada chamadas:                                º±±
±±º          ³                                                            º±±
±±º          ³ MTA010MNU: Cadastro de Produtos                            º±±
±±º          ³ MA030ROT: Cadastro de Clientes                             º±±
±±º          ³ MA020ROT: Cadastro de Fornecedores                         º±±
±±º          ³ MTA360MNU: Cadastro de Condicoes de Pagamento    *** Remov º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsGnrc00(cNomApi, cTipInt, cTipReg, cIntAmb, nMsgPrc)
Local lVld := .F.
Local aReturn := { .F., "", "", "", "" }
Local cMsg01 := "Integracao Totvs -> Thomson "
Local cMsg02 := "API: " + cNomApi
Local cMsg03 := "Tipo Interface: " + cTipInt
Local cMsg04 := "Tipo Registro: " + cTipReg
Local nTamZT1Nom := TamSX3("ZT1_NOMAPI")[01]
// Variaveis filiais
Private _cFilZT1 := xFilial("ZT1")
Private _cFilZT2 := xFilial("ZT2")
Private _cFilZTL := xFilial("ZTL")
Private _cFilZTN := xFilial("ZTN")
ConOut("")
ConOut("#################### WsGnrc00: Integracao Ws Thomson ####################")
ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Abertura das tabelas
ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tabelas...")
DbSelectArea("ZTN") // Notificacoes
ZTN->(DbSetOrder(1)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_IDTRAN + ZTN_STATHO + ZTN_STATOT + ZTN_DTHRLG
DbSelectArea("ZTL") // Logs Integracoes
ZTL->(DbSetOrder(1)) // ZTL_FILIAL + ZTL_CODIGO
DbSelectArea("ZT1") // Integracoes Thomson
ZT1->(DbSetOrder(3)) // ZT1_FILIAL + ZT1_TIPINT + ZT1_NOMAPI
DbSelectArea("ZT2") // Integracoes Thomson Itens
ZT2->(DbSetOrder(1)) // ZT2_FILIAL + ZT2_CODIGO
DbSelectArea("ZT1") // Integracoes Thomson
ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tabelas... Concluido!")
If Upper(Left(cNomApi,2)) <> "WS" // Por Nome da Api
    If ZT1->(DbSeek(_cFilZT1 + cTipInt + cNomApi))
        While ZT1->(!EOF()) .And. ZT1->ZT1_FILIAL + ZT1->ZT1_TIPINT + ZT1->ZT1_NOMAPI == _cFilZT1 + cTipInt + PadR(cNomApi,nTamZT1Nom)
            If ZT1->ZT1_CODSTA == "01" // "01"=Ativa
                If !Empty( &("ZT1->ZT1_URL" + cIntAmb) ) // URL conforme ambiente preenchida
                    lVld := .T.
                    Exit
                EndIf
            EndIf
            ZT1->(DbSkip())
        End
        If !lVld // .F.=ZT1 ativo nao encontrado
            cMsg01 := "Integracao ativa nao identificada (ZT1_CODSTA)!"
            cMsg02 := "Rotina: " + cNomApi
        EndIf
    Else // ZT1 nao encontrado
        cMsg01 := "Integracao nao identificada (ZT1)!"
        cMsg02 := "Rotina: " + cNomApi
    EndIf
Else // Por Rotina
    ZT1->(DbSetOrder(4)) // ZT1_FILIAL + ZT1_ROTINT
    If ZT1->(DbSeek(_cFilZT1 + cNomApi))
        If ZT1->ZT1_CODSTA == "01" // Ativado
            If ExistBlock( ZT1->ZT1_ROTINT ) // Rotina existe no RPO
                aReturn := ExecBlock( &("ZT1->ZT1_ROTINT"),.F.,.F.,{ cNomApi, cTipInt, cTipReg, nMsgPrc })
                lVld := aReturn[01] // .T.=Sucesso .F.=Falha
                If !lVld // .F.=Falha
                    cMsg01 := aReturn[02] // Mensagem 01
                    cMsg02 := aReturn[03] // Mensagem 02
                    cMsg03 := aReturn[04] // Mensagem 03
                    cMsg04 := aReturn[05] // Mensagem 04
                EndIf
            Else
                cMsg01 := "Rotina nao esta compilada (ZT1_NOMAPI)!"
                cMsg02 := "Rotina: " + cNomApi
            EndIf
        Else // Rotina nao ativada
            cMsg01 := "Rotina nao esta ativada (ZT1)!"
            cMsg02 := "Rotina: " + cNomApi
        EndIf
    Else // Rotina nao identificada
        cMsg01 := "Rotina nao identificada (ZT1_NOMAPI)!"
        cMsg02 := "Rotina: " + cNomApi
    EndIf
EndIf
If lVld // .T.=Valido ZT1 localizado
    If Upper(Left(cNomApi,2)) <> "WS" // Se nao for rotina
        ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Integracao ZT1: " + ZT1->ZT1_TIPINT + " " + RTrim(ZT1->ZT1_NOMAPI))
        // Parte 01: Carregamento dos Recnos e preparacao dos metodos
        If nMsgPrc == 2 // 2=AskYesNo
            u_AskYesNo(3500,"WsGnrc00",cMsg01 + ZT1->ZT1_INTERF,"","","","","PROCESSA",.T.,.F.,{|| aReturn := WsPrep01(cNomApi, cTipInt, cTipReg, cIntAmb, nMsgPrc) })
        Else
            aReturn := WsPrep01(cNomApi, cTipInt, cTipReg, cIntAmb, nMsgPrc)
        EndIf
    EndIf
Else // .F.=Invalido
    ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha:")
    ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg01)
    ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
    ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg03)
    ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg04)
    If nMsgPrc == 2 // 2=AskYesNo
        u_AskYesNo(6000,"WsGnrc00",cMsg01,cMsg02,cMsg03,cMsg04,"","UPDERROR")
    ElseIf nMsgPrc == 1 // 1=MsgStop
        MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
        cMsg02 + Chr(13) + Chr(10) +  ;
        cMsg03 + Chr(13) + Chr(10) + ;
        cMsg04,"WsGnrc00")
    EndIf
EndIf
ConOut("WsGnrc00: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("############################################################")
ConOut("")
Return aReturn // { .T./.F., cMsg01, cMsg01, cMsg01, cMsg01, aMethds }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsPrep01 ºAutor ³Jonathan Schmidt Alves º Data ³06/07/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preparacao para montagem aMethds (Recnos, Params, etc).    º±±
±±º          ³                                                            º±±
±±º          ³ 1) Processamento das rotinas de montagem em ZT1_ROTINT.    º±±
±±º          ³ 2) Processamento das montagens realizadas em WsGnrc14().   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cNomApi: Nome da Api                                       º±±
±±º          ³         Ex: "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA"    º±±
±±º          ³             "PKG_SFW_PRODUTOS.PRC_PRODUTO"                 º±±
±±º          ³                                                            º±±
±±º          ³ cTipInt: Tipo de Interface                                 º±±
±±º          ³         Ex: "01"=IN (Entrada)                              º±±
±±º          ³             "02"=OUT (Saida)                               º±±
±±º          ³                                                            º±±
±±º          ³ cTipReg: Tipo de Registro                                  º±±
±±º          ³         Ex: "P"=Registro posicionado                       º±±
±±º          ³             "C"=Consulta/Tela                              º±±
±±º          ³                                                            º±±
±±º          ³ cIntAmb: Integracao no Ambiente                            º±±
±±º          ³         Ex: "TES"=Ambiente de testes (QA)                  º±±
±±º          ³             "DES"=Ambiente de desenvolvimento (PRJ)        º±±
±±º          ³             "PRO"=Ambiente de producao (PRO)               º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPrc: Mensagem de processamento                         º±±
±±º          ³         Ex: 0=Sem interface                                º±±
±±º          ³             1=MsgStop, MsgAlert, MsgInfo                   º±±
±±º          ³             2=AskYesNo                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function WsPrep01(cNomApi, cTipInt, cTipReg, cIntAmb, nMsgPrc)
Local lRet := .T.
Local _w1
Local _z1
Local nDiv
Local cTab
// Methods/Params/Tabelas
Local aMethds := {}
Local aTabInd := {}
// Mensagens processamento
Private cMsg01 := "Integracao Totvs -> Thomson " + ZT1->ZT1_INTERF
Private cMsg02 := "Carregando..."
Private cMsg03 := "Abrindo tabelas..."
Private cMsg04 := ""
_oMeter:nTotal := 24
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPrc == 2 // 2=AskYesNo
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "PROCESSA")
        Sleep(030)
    Next
EndIf
// Abertura das tabelas, indices, filiais tabelas
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abertura das tabelas/indices...")
aTabInd := StrToKarr(RTrim(ZT1->ZT1_TABIND),"/") // SA1-1/SA2-2/SA3-1/etc
For _w1 := 1 To Len(aTabInd)
    nDiv := At("-",aTabInd[_w1])
    cTab := Left(aTabInd[_w1], nDiv - 1)
    DbSelectArea(cTab)                                                      // Abertura da tabela
    If (nOrder := Val(RTrim(SubStr( aTabInd[_w1], nDiv + 1, 20 )))) > 0
        (cTab)->(DbSetOrder( nOrder )) // Indice por numero
    Else // Indice por nickname
        cNick := RTrim(SubStr( aTabInd[_w1], nDiv + 1, 20 ))
        (cTab)->(DbOrderNickName( cNick )) // Indice por nickname
    EndIf
    &("_cFil" + cTab) := xFilial( cTab )                                    // Filial tabela
Next
cMsg03 := "Abrindo tabelas... Concluido!"
If nMsgPrc == 2 // 2=AskYesNo
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "PROCESSA")
        Sleep(030)
    Next
EndIf
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abertura das tabelas/indices... Concluido!")
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando chamadas para comunicacao com Thomson...")
cMsg02 := "Montando chamadas..."
cMsg03 := "Montando chamadas para comunicacao com Thomson..."
If nMsgPrc == 2 // 2=AskYesNo
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "PROCESSA")
        Sleep(030)
    Next
EndIf
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montagem: " + &("ZT1->ZT1_ROTINT"))
If ExistBlock( ZT1->ZT1_ROTINT ) // Rotina existe no RPO
    aReturn := ExecBlock( &("ZT1->ZT1_ROTINT"),.F.,.F.,{ cNomApi, cTipInt, cTipReg, nMsgPrc })
    lRet := aReturn[01]     // .T.=Sucesso na montagem .F.=Falha na montagem
    cMsg01 := aReturn[02]   // Mensagem de falha 01
    cMsg02 := aReturn[03]   // Mensagem de falha 02
    cMsg03 := aReturn[04]   // Mensagem de falha 03
    cMsg04 := aReturn[05]   // Mensagem de falha 04
    aMethds := aReturn[06]  // Metodos montados
    If lRet // .T.=Sucesso na montagem
        If Len( aMethds ) > 0 // Dados carregados
            cMsg01 := "Integracao Totvs -> Thomson"
            cMsg02 := aMethds[01,09] // Titulo da Integracao
            If Len(aMethds[01,07]) > 0 .And. Len(aMethds[01,07,01,02]) > 0 // Recnos carregados
                aEval(aMethds, {|x|, x[05] := cIntAmb }) // Ambiente Integracao TES=Teste DES=Desenv PRO=Producao
                Sleep(100)
                cMsg03 := aMethds[01,10] // Mensagem de processamento
                cMsg04 := ""
                If nMsgPrc == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "PROCESSA")
                        Sleep(100)
                    Next
                EndIf
                // Parte 02: Montagens ZT1/ZT2, chamadas de Processamento, etc
                u_WsGnrc14( aMethds, 2 )
            Else // Recnos nao carregados
                cMsg03 := "Falha: Dados nao foram carregados!"
                ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
                lRet := .F.
            EndIf
        Else // Dados nao carregados
            cMsg03 := "Falha: Dados nao foram carregados!"
            ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
            lRet := .F.
        EndIf
    EndIf
Else // Rotina nao encontrada
    cMsg03 := "Falha: Rotina de montagem nao encontrada: " + ZT1->ZT1_ROTINT
    cMsg04 := "Verifique se a funcao esta compilada e tente novamente!"
    lRet := .F.
EndIf
If !lRet // Falha
    ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha:")
    ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg01)
    ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
    ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg03)
    ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg04)
    If nMsgPrc == 2 // 2=AskYesNo
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "UPDERROR")
            Sleep(1200)
        Next
    ElseIf nMsgPrc == 1 // 1=MsgStop
        MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
        cMsg02 + Chr(13) + Chr(10) + ;
        cMsg03 + Chr(13) + Chr(10) + ;
        cMsg04,"WsGnrc00")
    EndIf
EndIf
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando chamadas para comunicacao... Concluido!")
ConOut("WsPrep01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return { lRet, cMsg01, cMsg02, cMsg03, cMsg04 }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ CodEIbge ºAutor ³Jonathan Schmidt Alves º Data ³10/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Codigo da UF IBGE conforme Siga do Estado.                 º±±
±±º          ³                                                            º±±
±±º          ³ Exemplos:                                                  º±±
±±º          ³ Sigla Estado: "SP" -> Codigo UF IBGE: "35"                 º±±
±±º          ³               "SC" -> Codigo UF IBGE: "42"                 º±±
±±º          ³               "MS" -> Codigo UF IBGE: "50"                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CodEIbge(cUF)
Local cCodUF := Space(02)
Local aRelac := { { 11, "RO" }, { 12, "AC" }, { 13, "AM" }, { 14, "RR" }, { 15, "PA" }, { 16, "AP" }, { 17, "TO" },;                // Estados do Norte
{ 21, "MA" }, { 22, "PI" }, { 23, "CE" }, { 24, "RN" }, { 25, "PB" }, { 26, "PE" }, { 27, "AL" }, { 28, "SE" }, { 29, "BA" },;      // Estados do Nordeste
{ 31, "MG" }, { 32, "ES" }, { 33, "RJ" }, { 35, "SP" },;                                                                            // Estados do Sudeste
{ 41, "PR" }, { 42, "SC" }, { 43, "RS" },;                                                                                          // Estados do Sul
{ 50, "MS" }, { 51, "MT" }, { 52, "GO" }, { 53, "DF" } }                                                                            // Estados do Centro Oeste
If (nFnd := ASCan(aRelac, {|x|, x[02] == cUF })) > 0 // Localizo o Estado pela Sigla
    cCodUF := cValToChar(aRelac[nFnd,01]) // Obtenho o Codigo UF IBGE
EndIf
Return cCodUF // Retorno Codigo UF IBGE
