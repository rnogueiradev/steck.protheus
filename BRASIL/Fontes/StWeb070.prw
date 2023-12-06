#INCLUDE "JSON.CH"
#INCLUDE "SHASH.CH"
#INCLUDE "AARRAY.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ STWEB070 ∫Autor≥ Jonathan Schmidt Alves ∫Data ≥ 07/02/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Geracao de Pedidos de Venda a partir de pedidos de compra. ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ STWEB070.PRW: Preparacao da chamada na origem              ∫±±
±±∫          ≥      StWeb071(): Inicio do processamento                   ∫±±
±±∫          ≥      StWeb072(): Montagem das matrizes aCabec/aItens       ∫±±
±±∫          ≥      StWeb073(): Chamada webservice Rest                   ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ STWEB080.PRW: Processamento da chamada no destino          ∫±±
±±∫          ≥      StWeb081(): Inicio do processamento                   ∫±±
±±∫          ≥      StWeb082(): Processamento do ExecAuto MATA410         ∫±±
±±∫          ≥      StWeb083(): Adequacoes ExecAuto no ambiente           ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StWeb071 ∫Autor≥ Jonathan Schmidt Alves ∫Data ≥ 07/02/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Inicio dos carregamentos para geracao do pedido de venda.  ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function StWeb070( nMsgPrc )
LOCAL aRetProc := {}
If nMsgPrc == 1 // 1=MsgStop
    aRetProc := StWeb071(1)
ElseIf nMsgPrc == 2 // 2=AskYesNo
    u_AskYesNo(3500,"StWeb070","Avaliando...","Verificando Pedido de Compra...","","","","PROCESSA",.T.,.F.,{|| StWeb071( nMsgPrc ) })
EndIf

Return aRetProc

Static Function StWeb071( nMsgPrc )
Local _z1
Local lVld := .T.
Local aResult := {}
Local aArea := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Private cUsrGerPv  := ""
ConOut("StWeb071: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPrc == 2 // 2=AskYesNo
    _oMeter:nTotal := 12
EndIf
// Parte 01: Validacoes gerais
If !(cEmpAnt $ "01/03/11/")
    cMsg01 := "Empresa invalida para esta operacao!"
    cMsg02 := "Esta funcionalidade esta disponivel apenas para as empresas 01/03!"
    cMsg03 := "Empresa: " + cEmpAnt
    If nMsgPrc == 1 // 1=MsgAlert
        MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
        cMsg02 + Chr(13) + Chr(10) + ;
        cMsg03,"StWeb071")
    ElseIf nMsgPrc == 2 // 2=AskYesNo
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, "", 80, "UPDERROR")
            Sleep(800)
        Next
    EndIf
Else // Empresa conforme
    If cEmpAnt == "03" // Somente na Manaus... verifico acesso
        cUsrGerPv := GetMv('ST_GPVUSER',,'000000')// Admin acesso full
        If !(__cUserId $ cUsrGerPv)
            cMsg01 := "Usuario sem acesso para esta operacao!"
            cMsg02 := "X6_CONTEUDO - ST_GPVUSER"
            cMsg03 := "Abrir chamado para liberaÁ„o!"
            If nMsgPrc == 1 // 1=MsgAlert
                MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
                cMsg02 + Chr(13) + Chr(10) + ;
                cMsg03,"StWeb071")
            ElseIf nMsgPrc == 2 // 2=AskYesNo
                For _z1 := 1 To 4
                    u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, "", 80, "UPDERROR")
                    Sleep(800)
                Next
            EndIf
            lVld := .F.
        EndIf
    EndIf
    If lVld // .T.=Valido para prosseguir
        If nMsgPrc == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(++nCurrent, "Montando dados do Pedido de Venda...", "", "", "", 80, "PROCESSA")
                Sleep(100)
            Next
        EndIf
        aRet := StWeb072( cEmpAnt, SC7->C7_FILIAL, SC7->C7_NUM, nMsgPrc ) // Montagem das matrizes aCabec/aItens
        // {   01,     02,     03,     04,     05,      06,      07,     08,     09,    10,    11 }
        // { lVld, cMsg01, cMsg02, cMsg03, cMsg04, cCodEmp, cCodFil, aCabec, aItens, aPrcs, cJson }
        If aRet[01] // .T.=Valido (matrizes ExecAuto carregadas)
            If nMsgPrc == 2 // 2=AskYesNo
                For _z1 := 1 To 4
                    u_AtuAsk09(nCurrent, "Montando dados do Pedido de Venda... Sucesso!", "", "", "", 80, "OK")
                    Sleep(100)
                Next
            EndIf
            If cEmpAnt == "11" // Logado "11"
                If aRet[06] == "03" .OR. aRet[06] == "01"// ExecAuto empresa 03"
                    If nMsgPrc == 2 // 2=AskYesNo
                        For _z1 := 1 To 4
                            u_AtuAsk09(++nCurrent, "Contatando WebService Rest...", "", "", "", 80, "GEO")
                            Sleep(100)
                        Next
                    EndIf
                    // Webservice (chamar o webservice passando a matriz completa)
                    aResult := StWeb073( aRet )
                    If !aResult[01] // .F.=Falha no processamento
                        If nMsgPrc == 1 // 1=MsgAlert
                            MsgStop(aResult[02] + Chr(13) + Chr(10) + ;
                            aResult[03] + Chr(13) + Chr(10) + ;
                            aResult[04],"StWeb071")
                        ElseIf nMsgPrc == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent, aResult[02], aResult[03], aResult[04], "", 80, "UPDERROR")
                                Sleep(800)
                            Next
                        EndIf
                    Else // .T.=Sucesso no processamento
                        If nMsgPrc == 1 // 1=MsgAlert
                            MsgInfo(aResult[02] + Chr(13) + Chr(10) + ;
                            aResult[03] + Chr(13) + Chr(10) + ;
                            aResult[04],"StWeb071")
                        ElseIf nMsgPrc == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent, "Contatando WebService Rest... Sucesso!", aResult[02], aResult[03], aResult[04], 80, "OK")
                                Sleep(500)
                            Next
                        EndIf
                    EndIf
                ElseIf aRet[06] == "11" // ExecAuto empresa "11" tambem
                    cMsg01 := "ExecAuto na empresa 11 a partir da empresa 11 ainda nao desenvolvido!"
                    If nMsgPrc == 1 // 1=MsgStop
                        MsgStop(cMsg01,"StWeb071")
                    ElseIf nMsgPrc == 2 // 2=AskYesNo
                        For _z1 := 1 To 4
                            u_AtuAsk09(++nCurrent, cMsg01, "", "", "", 80, "UPDERROR")
                            Sleep(800)
                        Next
                    EndIf
                EndIf
            ElseIf cEmpAnt == "03" // Logado "03" -> Gerar Ped Venda na 11/01 (nova)
                cMsg01 := "ExecAuto a partir da empresa 03 ainda nao desenvolvido!"
                If nMsgPrc == 1 // 1=MsgStop
                    MsgStop(cMsg01,"StWeb071")
                ElseIf nMsgPrc == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent, cMsg01, "", "", "", 80, "UPDERROR")
                        Sleep(800)
                    Next
                EndIf
            EndIf
        Else // Falha no carregamento
            If nMsgPrc == 1 // 1=MsgAlert
                MsgStop(aRet[02]  + Chr(13) + Chr(10) + ;
                aRet[03] + Chr(13) + Chr(10) + ;
                aRet[04] + Chr(13) + Chr(10) + ;
                aRet[05],"StWeb071")
            ElseIf nMsgPrc == 2 // 2=AskYesNo
                For _z1 := 1 To 4
                    u_AtuAsk09(++nCurrent, aRet[02], aRet[03], aRet[04], aRet[05], 80, "UPDERROR")
                    Sleep(800)
                Next
            EndIf
        EndIf
    EndIf
EndIf
ConOut("StWeb071: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
RestArea(aAreaSC7)
RestArea(aArea)
Return aResult

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StWeb072 ∫Autor≥ Jonathan Schmidt Alves ∫Data ≥ 07/02/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Montagem das matrizes para os execautos conforme a empresa ∫±±
±±∫          ≥ logada e opcao de empresa/filial a gerar o pedido de venda.∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ 1) Matrizes mestres de montagem aCabs e Itns.              ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ A montagem vai respeitar as matrizes mestres de montagem   ∫±±
±±∫          ≥ para montagem do Cabecalho e tambem dos Itens.             ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ 2) Ordenacao para processamento do ExecAuto:               ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Apos essa montagem ocorre a ordenacao dos campos em uso de ∫±±
±±∫          ≥ acordo com a empresa onde o ExecAuto sera disparado.       ∫±±
±±∫          ≥ Como cada empresa pode ter estrutura de dados diferente e  ∫±±
±±∫          ≥ tambem ordem dos engatilhamentos diferente, funcionando    ∫±±
±±∫          ≥ dessa forma generica sera possivel na propria configuracao ∫±±
±±∫          ≥ destas matrizes mestes definirmos como o ExecAuto deve ser ∫±±
±±∫          ≥ criado e processado no ambiente desejado.                  ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ 3) Blocos de Codigo:                                       ∫±±
±±∫          ≥ Na montagem do ExecAuto e tambem do Json a possibilidade   ∫±±
±±∫          ≥ de processamentos no ambiente destino sao configuradas     ∫±±
±±∫          ≥ nos blocos de codigo. Dessa forma certos processamentos    ∫±±
±±∫          ≥ podem ser disparados apenas quando ja no ambiente destino. ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ 4) Validacoes dinamicas:                                   ∫±±
±±∫          ≥ Podemos realizar validacoes e retornos das validacoes de   ∫±±
±±∫          ≥ forma dinamica com o uso das matrizes mestres auxiliares   ∫±±
±±∫          ≥ aPrcs, onde configuramos as validacoes desejadas e tambem  ∫±±
±±∫          ≥ os retornos, apresentando mensagens para o usuario.        ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ 4) Preparacao do Json para comunicacao com Amb Web Rest:   ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Para a comunicacao com outro ambiente temos o envio dos    ∫±±
±±∫          ≥ dados preparados em Json.                                  ∫±±
±±∫          ≥ Os dados recebidos pelo ambiente de processamento Rest     ∫±±
±±∫          ≥ serao 'desempacotados' novamente para matrizes onde entao  ∫±±
±±∫          ≥ o ExecAuto sera disparado.                                 ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ cEmpAnt: Empresa logada                                    ∫±±
±±∫          ≥ cFilCom: Filial do pedido de compra                        ∫±±
±±∫          ≥ cPedCom: Numero do pedido de compra                        ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫          ≥ Retorno:                                                   ∫±±
±±∫          ≥ { lVld, cMsg01, cMsg02, cMsg03, cMsg04, cCodEmp, cCodFil,  ∫±±
±±∫          ≥         aCabec, aItens, aPrcs, cJson }                     ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ lVld     .T.=Dados carregados com sucesso para o ExecAuto  ∫±±
±±∫          ≥ cMsg01   Mensagem 01 de falha no carregamento              ∫±±
±±∫          ≥ cMsg02   Mensagem 02 de falha no carregamento              ∫±±
±±∫          ≥ cMsg03   Mensagem 03 de falha no carregamento              ∫±±
±±∫          ≥ cMsg04   Mensagem 04 de falha no carregamento              ∫±±
±±∫          ≥ cCodEmp  Empresa geracao do Pedido de Venda                ∫±±
±±∫          ≥ cCodFil  Filial geracao do Pedido de Venda                 ∫±±
±±∫          ≥ aCabec   Matriz cabecalho SC5 carregada                    ∫±±
±±∫          ≥ aItens   Matriz itens SC6 carregada                        ∫±±
±±∫          ≥ aPrcs    Processamentos/validacoes execauto webservice     ∫±±
±±∫          ≥ cJson    Json montado para integracao webservice           ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StWeb072( cEmpAnt, cFilCom, cPedCom, nMsgPrc )
Local _w1
Local _w2
// Retornos
Local lVld := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
// Matrizes montagem execauto
Local aCabs := {}
Local aItns := {}
Local aPrcs := {}
Local cJson := ""
// Matrizes auxiliares
Local cItNum := "00"
Local aItPed := {}
Local aItTab := {}
// Matrizes resultado
Local aCabec := {}
Local aItens := {}
// Opcoes Empresa/Filial
Local cCodEmp := ""
Local cCodFil := ""
Local nEmpLog := Val( cEmpAnt ) // Empresa logado
Local nEmpPrc := 0              // Empresa Gerar pedido
Local nFilPrc := 0              // Filial Gerar pedido
// Empresa/Filial
Local cEmpGer     := Space(40)
//>>
Local cTransfPrice  := ""                
Local _cEmail       := ""
Local _cCopia       := ""
Local _cAssunto     := ""
Local _aAttach      := {}
Local _cCaminho     := ""
Local _cMsg         := ""
Local _nx           := 0
//<<

//               { {         Opcoes Empresa 01         },      {                        Opcoes Empresa 03                         } }
// Local aEmpGer := { { "03/01=Manaus", "01/04=Sao Paulo" }, Nil, { "01/02=Filial SP 02", "01/04=Filial SP 04", "01/05=Filial SP 05" } }[ nEmpLog ]

//               {                           Logado 01 },  02, {                   Logado 03 },  04,  05,  06,  07,  08,  09,  10, {                                Logado 11 }
Local aEmpGer := { { "03/01=Manaus", "01/04=Sao Paulo" }, Nil, { "11/01=Filial SP 02 (nova)" }, Nil, Nil, Nil, Nil, Nil, Nil, Nil, { "03/01=Manaus", "01/05=Filial Guararema" } }[ nEmpLog ]

// Variaveis filiais
Private _cFilSB1 := xFilial("SB1")
Private _cFilSC7 := xFilial("SC7")
// Variaveis tela
Private oDlgUnd
Private nOpcao := 0
ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")

IF nMsgPrc = 2 
  DEFINE MSDIALOG oDlgUnd Title "DestinaÁ„o do Pedido" FROM 010,010 TO 150,200 PIXEL
  @010,010 COMBOBOX cEmpGer ITEMS aEmpGer SIZE 080,080
  DEFINE SBUTTON FROM 030,030 TYPE 1 ACTION Iif(!Empty(cEmpGer), (nOpcao := 1, oDlgUnd:End() ), MsgStop("Selecione uma Unidade","StWeb072")) ENABLE OF oDlgUnd
  ACTIVATE DIALOG oDlgUnd CENTERED
ELSE
  //// Filial Guararema
  IF SC7->C7_FORNECE = "005764"
    cEmpGer := "01/05"
    cTransfPrice := AllTrim(GetMv("STPRICE",,"T08"))
  //// Filial Manaus
  ELSEIF SC7->C7_FORNECE = "005866"
    cEmpGer := "03/01"
    cTransfPrice := AllTrim(GetMv("STPRICE",,"T02"))
  ENDIF
  nOpcao := 1
ENDIF

If nOpcao == 1 // 1=Confirmado
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Empresa/Filial logado: " + cEmpAnt + "/" + cFilAnt)
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Empresa/Filial Geracao do Ped Venda: " + cEmpGer)
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando matrizes mestres aCabs/aItns/aPrcs...")
    nEmpPrc := Val(cCodEmp := Left(cEmpGer,2))      // Empresa Gerar pedido
    nFilPrc := Val(cCodFil := SubStr(cEmpGer,4,2))  // Filial Gerar pedido
    // Field Montagem             { ########################################### Logado Empresa 01 ############################################# }   { ############################################### Logado Empresa 03 ######################################### },,,,,,,, { ################################################ Logado Empresa 11 ######################################## } } }
    //          {        Field, { { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto },, { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto },,,,,,,, { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto } } }
    //          {           01, { { 02.01.01,                                                                          02.01.02,       02.01.03 },, { 03.01.01,                                                                          03.01.02,       03.01.03 },,,,,,,, { 11.01.01,                                                                          11.01.02,       11.01.03 } } }
    aAdd(aCabs, { "C5_CLIENTE", { { { { Nil, Nil, Nil, Nil, "033467" }, Nil, { "033467" } }[ nEmpPrc, nFilPrc ],            .T.,             01 },, { "033467",                                                                               .T.,             01 },,,,,,,, { { { Nil, Nil, Nil, Nil,"033467" }, Nil, { "033467" } }[ nEmpPrc, nFilPrc ],             .T.,             01 } } })
    aAdd(aCabs, { "C5_LOJACLI", { { Iif(cFilAnt == "04", "03", xFilial("SC7")),                                             .T.,             02 },, { "01",                                                                                   .T.,             02 },,,,,,,, { { { Nil, Nil, Nil, Nil, "06" }, Nil, { "06" } }[ nEmpPrc, nFilPrc ],                    .T.,             02 } } })
    aAdd(aCabs, { "C5_CLIENT",  { { "033467",                                                                               .T.,             03 },, { "033467",                                                                               .T.,             03 },,,,,,,, { { { Nil, Nil, Nil, Nil, "033467" }, Nil, { "033467" } }[ nEmpPrc, nFilPrc ],            .T.,             00 } } })
    aAdd(aCabs, { "C5_LOJAENT", { { Iif(cFilAnt == "04", "03", xFilial("SC7")),                                             .T.,             04 },, { "01",                                                                                   .T.,             04 },,,,,,,, { { { Nil, Nil, Nil, Nil, "06" }, Nil, { "06" } }[ nEmpPrc, nFilPrc ],                    .T.,             00 } } })
    aAdd(aCabs, { "C5_TIPOCLI", { { { { Nil,Nil,Nil,Nil,"F"}, Nil, {"R", Nil, Nil, Nil, Nil}}[ nEmpPrc, nFilPrc ],          .T.,             05 },, { "R",                                                                                    .T.,             05 },,,,,,,, { { { Nil, Nil, Nil, Nil, "F" }, Nil, { "R" } }[ nEmpPrc, nFilPrc ],                      .T.,             00 } } })
    aAdd(aCabs, { "C5_CONDPAG", { { "502" /*Space(03)*/,                                                                    .T.,             06 },, { "502",                                                                                  .T.,             06 },,,,,,,, { { { Nil, Nil, Nil, Nil, "608" }, Nil, { "511" } }[ nEmpPrc, nFilPrc ],                  .T.,             00 } } })
    aAdd(aCabs, { "C5_EMISSAO", { { dDatabase,                                                                              .T.,             07 },, { dDatabase,                                                                              .T.,             07 },,,,,,,, { dDatabase,                                                                              .T.,             00 } } })
    aAdd(aCabs, { "C5_ZCONDPG", { { "502" /*Space(03)*/,                                                                    .T.,             08 },, { "502",                                                                                  .T.,             08 },,,,,,,, { { { Nil, Nil, Nil, Nil, "608" }, Nil, { "511" } }[ nEmpPrc, nFilPrc ],                  .T.,             04 } } })
    aAdd(aCabs, { "C5_TABELA",  { { cTransfPrice,                                                                           .T.,             09 },, { cTransfPrice,                                                                           .T.,             09 },,,,,,,, { cTransfPrice,                                                                           .T.,             09 } } })
    aAdd(aCabs, { "C5_VEND1",   { { Space(06),                                                                              .T.,             10 },, { "E00006",                                                                               .T.,             10 },,,,,,,, { Space(06),                                                                              .T.,             00 } } })
    aAdd(aCabs, { "C5_TPFRETE", { { "C",                                                                                    .T.,             11 },, { "C",                                                                                    .T.,             11 },,,,,,,, { "C",                                                                                    .T.,             05 } } })
    aAdd(aCabs, { "C5_TRANSP",  { { {{Nil, Nil, Nil, Nil, "10000" },Nil,{"100000",Nil,Nil,Nil,Nil}}[nEmpPrc,nFilPrc],       .T.,             12 },, { "004024",                                                                               .T.,             12 },,,,,,,, { { { Nil, Nil, Nil, Nil, "004064" }, Nil, { "002730" } }[ nEmpPrc, nFilPrc ],            .T.,             06 } } })
    aAdd(aCabs, { "C5_XTIPO",   { { "2",                                                                                    .T.,             13 },, { "2", /* Tipo Entrega: 1=Retira;2=Entrega */                                             .T.,             13 },,,,,,,, { "2",                                                                                    .T.,             07 } } })
    aAdd(aCabs, { "C5_XTIPF",   { { "1",                                                                                    .T.,             14 },, { "2", /* Tipo Fatura: 1=Total;2=Parcial */                                               .T.,             14 },,,,,,,, { "1",                                                                                    .T.,             08 } } })
    aAdd(aCabs, { "C5_ZOBS",    { { "" ,                                                                                    .T.,             15 },, { "",                                                                                     .T.,             15 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZBLOQ",   { { "2",                                                                                    .T.,             16 },, { "2", /* Status Pedido: 1=Bloqueado;2=Liberado */                                        .T.,             16 },,,,,,,, { "2",                                                                                    .T.,             00 } } })
    aAdd(aCabs, { "C5_XORDEM",  { { "",                                                                                     .T.,             17 },, { "",                                                                                     .T.,             17 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZENDENT", { { "",                                                                                     .T.,             18 },, { "",                                                                                     .T.,             18 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZBAIRRE", { { "",                                                                                     .T.,             19 },, { "",                                                                                     .T.,             19 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZCEPE",   { { "",                                                                                     .T.,             20 },, { "",                                                                                     .T.,             20 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZESTE",   { { "",                                                                                     .T.,             21 },, { "",                                                                                     .T.,             21 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZMUNE",   { { "",                                                                                     .T.,             22 },, { "",                                                                                     .T.,             22 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_XCODMUN", { { "",                                                                                     .T.,             23 },, { "",                                                                                     .T.,             23 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aCabs, { "C5_ZCONSUM", { { { { Nil, Nil, Nil, Nil, "2" }, Nil, { "1", Nil, Nil, Nil, Nil } }[ nEmpPrc, nFilPrc ],            .T.,             24 },, { "2",                                                                                    .T.,             24 },,,,,,,, { "2",                                                                          .T.,             00 } } })
    aAdd(aCabs, { "C5_ZMESPC",  { { {|| SC7->C7_XMESMRP },                                                                  .T.,             25 },, { {|| SC7->C7_XMESMRP },                                                                  .T.,             25 },,,,,,,, { {|| SC7->C7_XMESMRP },                                                                  .T.,             00 } } })
    aAdd(aCabs, { "C5_ZANOPC",  { { {|| SC7->C7_XANOMRP },                                                                  .T.,             26 },, { {|| SC7->C7_XANOMRP },                                                                  .T.,             26 },,,,,,,, { {|| SC7->C7_XANOMRP },                                                                  .T.,             00 } } })
    aAdd(aCabs, { "C5_ZNUMPC",  { { cPedCom,                                                                                .T.,             27 },, { cPedCom,                                                                                .T.,             27 },,,,,,,, { cPedCom,                                                                                .T.,             00 } } })
    // Field Montagem             { ########################################### Logado Empresa 01 ############################################# }   { ############################################### Logado Empresa 03 ######################################### },,,,,,,, { ################################################ Logado Empresa 11 ######################################## } } }
    //          {        Field, { { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto },, { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto },,,,,,,, { Conteudo para processamento,                                  Abre agora ou no destino Rest, Ordem ExecAuto } } }
    //          {           01, { { 02.01.01,                                                                          02.01.02,       02.01.03 },, { 03.01.01,                                                                          03.01.02,       03.01.03 },,,,,,,, { 11.01.01,                                                                          11.01.02,       11.01.03 } } }
    aAdd(aItns, { "C6_ITEM",    { { {|| cItNum := Soma1(cItNum) },                                                          .T.,             01 },, { {|| cItNum := Soma1(cItNum) },                                                          .T.,             01 },,,,,,,, { {|| cItNum := Soma1(cItNum) },                                                          .T.,             01 } } })
    aAdd(aItns, { "C6_PRODUTO", { { {|| SB1->B1_COD },                                                                      .T.,             02 },, { {|| SB1->B1_COD },                                                                      .T.,             02 },,,,,,,, { {|| SB1->B1_COD },                                                                      .T.,             02 } } })
    aAdd(aItns, { "C6_UM",      { { {|| SC7->C7_UM },                                                                       .T.,             03 },, { {|| SC7->C7_UM },                                                                       .T.,             03 },,,,,,,, { {|| SC7->C7_UM },                                                                       .T.,             00 } } })
    aAdd(aItns, { "C6_CLI",     { { "033467",                                                                               .T.,             04 },, { "033467",                                                                               .T.,             04 },,,,,,,, { { { Nil, Nil, Nil, Nil, "033467" }, Nil, { "033467" } }[ nEmpPrc, nFilPrc ],            .T.,             00 } } })
    aAdd(aItns, { "C6_LOJA",    { { {|| Iif(cFilAnt == "04", "03", xFilial("SC7")) },                                       .T.,             05 },, { "01",                                                                                   .T.,             05 },,,,,,,, { { { Nil, Nil, Nil, Nil, "06" }, Nil, { "06" } }[ nEmpPrc, nFilPrc ],                    .T.,             00 } } })
    aAdd(aItns, { "C6_QTDVEN",  { { {|| SC7->C7_QUANT - SC7->C7_QUJE },                                                     .T.,             06 },, { {|| SC7->C7_QUANT - SC7->C7_QUJE },                                                     .T.,             06 },,,,,,,, { {|| SC7->C7_QUANT - SC7->C7_QUJE },                                                     .T.,             04 } } })
    aAdd(aItns, { "C6_PRCVEN",  { { {|| SC7->C7_PRECO },                                                                    .T.,             07 },, { {|| SC7->C7_PRECO },                                                                    .T.,             07 },,,,,,,, { {|| SC7->C7_PRECO },                                                                    .T.,             11 } } })
    aAdd(aItns, { "C6_PRUNIT",  { { {|| SC7->C7_PRECO },                                                                    .T.,             08 },, { {|| SC7->C7_PRECO },                                                                    .T.,             08 },,,,,,,, { {|| SC7->C7_PRECO },                                                                    .T.,             12 } } })
    aAdd(aItns, { "C6_ZPRCPSC", { { {|| SC7->C7_PRECO },                                                                    .T.,             09 },, { {|| SC7->C7_PRECO },                                                                    .T.,             09 },,,,,,,, { {|| SC7->C7_PRECO },                                                                    .T.,             00 } } })
    aAdd(aItns, { "C6_VALOR",   { { {|| Round(SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE),2) },                          .T.,             10 },, { {|| Round(SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE),2) },                          .T.,             10 },,,,,,,, { {|| Round(SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE),2) },                          .T.,             13 } } })
    aAdd(aItns, { "C6_OPER",    { { { { Nil, Nil, Nil, Nil, "94" }, Nil, { "15", Nil, Nil, Nil, Nil } }[ nEmpPrc, nFilPrc ],          .T.,             11 },, { "85",                                                                                   .T.,             11 },,,,,,,, { { { Nil, Nil, Nil, Nil, "01" }, Nil, { "15", Nil, Nil, Nil, Nil } }[ nEmpPrc, nFilPrc ],          .T.,             03 } } })
    aAdd(aItns, { "C6_TES",     { { Space(03),                                                                              .T.,             12 },, { Space(03),                                                                              .T.,             12 },,,,,,,, { "501",                                                                                  .T.,             15 } } })
    aAdd(aItns, { "C6_ENTREG",  { { {|| SC7->C7_DATPRF },                                                                   .T.,             13 },, { {|| SC7->C7_DATPRF },                                                                   .T.,             13 },,,,,,,, { {|| SC7->C7_DATPRF },                                                                   .T.,             21 } } })
    aAdd(aItns, { "C6_ENTRE1",  { { {|| SC7->C7_DATPRF },                                                                   .T.,             14 },, { {|| SC7->C7_DATPRF },                                                                   .T.,             14 },,,,,,,, { {|| SC7->C7_DATPRF },                                                                   .T.,             23 } } })
    aAdd(aItns, { "C6_ZMOTPC",  { { {|| SC7->C7_MOTIVO },                                                                   .T.,             15 },, { {|| SC7->C7_MOTIVO },                                                                   .T.,             15 },,,,,,,, { {|| SC7->C7_MOTIVO },                                                                   .T.,             22 } } })
    aAdd(aItns, { "C6_LOCAL",   { { "15",                                                                                   .T.,             16 },, { {|| SB1->B1_LOCPAD },                                                                   .F.,             16 },,,,,,,, { "15",                                                                                   .F.,             31 } } })
    aAdd(aItns, { "C6_CLASFIS", { { "",                                                                                     .T.,             17 },, { "",                                                                                     .T.,             17 },,,,,,,, { "",                                                                                     .T.,             00 } } })
    aAdd(aItns, { "C6_NUMPCOM", { { {|| SC7->C7_NUM },                                                                      .T.,             18 },, { Nil,                                                                                    .T.,             18 },,,,,,,, { {|| SC7->C7_NUM },                                                                      .T.,             32 } } })
    aAdd(aItns, { "C6_ITEMPC",  { { {|| SC7->C7_ITEM },                                                                     .T.,             19 },, { Nil,                                                                                    .T.,             19 },,,,,,,, { {|| SC7->C7_ITEM },                                                                     .T.,             33 } } })
    // "BF"=Before field    Processado antes do carregamento do campo
    // "AF"=After field     Processado depois do carregamento do campo
    // "AA"=After all       Processado depois de todos os campos carregados/processados
    // Processamentos/Carregamentos/Validacoes antes do ExecAuto por campo
    //          {           01, {  02.01, 02.02,                                                                                           02.03,                             02.04,                                                     02.05 } }
    aAdd(aPrcs, { "C5_LOJACLI", {   "03",  "01", {|| SA1->(DbSetOrder(1)), SA1->(DbSeek( xFilial("SA1") + &("C5_CLIENTE") + &("C5_LOJACLI") )) },                              "AF", "Cliente nao encontrado no cadatro (SA1)!"                } })
    aAdd(aPrcs, { "C6_PRODUTO", {   "03",  "01", {|| SB1->(DbSetOrder(1)), SB1->(DbSeek( xFilial("SB1") + &("C6_PRODUTO") )) },                                                "AF", "Produto nao encontrado no cadastro (SB1)!"               } })
    aAdd(aPrcs, { "C5_TRANSP",  {   "03",  "01", {|| SA4->(DbSetOrder(1)), SA4->(DbSeek( xFilial("SA4") + C5_TRANSP )) },                                                      "AA", "Transportadora nao encontrada no cadastro (SA4)!"        } })
    aAdd(aPrcs, { "C5_LOJACLI", {   "01",  "05", {|| SA1->(DbSetOrder(1)), SA1->(DbSeek( xFilial("SA1") + &("C5_CLIENTE") + &("C5_LOJACLI") )) },                              "AF", "Cliente nao encontrado no cadatro (SA1)!"                } })
    aAdd(aPrcs, { "C6_PRODUTO", {   "01",  "05", {|| SB1->(DbSetOrder(1)), SB1->(DbSeek( xFilial("SB1") + &("C6_PRODUTO") )) },                                                "AF", "Produto nao encontrado no cadastro (SB1)!"               } })
    aAdd(aPrcs, { "C5_TRANSP",  {   "01",  "05", {|| SA4->(DbSetOrder(1)), SA4->(DbSeek( xFilial("SA4") + C5_TRANSP )) },                                                      "AA", "Transportadora nao encontrada no cadastro (SA4)!"        } })
    aAdd(aPrcs, { "C6_TES",     {   "00",  "01", {|| !Empty( C6_TES := u_SXRetTES( C6_OPER, C6_CLI, C6_LOJA, C6_PRODUTO, "502", "TES", .F., C5_TIPOCLI, C5_ZCONSUM ) ) },      "AA", "TES nao carregada para o item!"                          } })
    aAdd(aPrcs, { "C6_CLASFIS", {   "00",  "01", {|| SF4->(DbSetOrder(1)), SF4->(DbSeek( xFilial("SF4") + C6_TES )), !Empty(C6_CLASFIS := SB1->B1_ORIGEM + SF4->F4_SITTRIB) }, "AA", "Classificacao Fiscal nao carregada para o item!"         } })
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando matrizes mestres aCabs/aItns/aPrcs... Concluido!")
    // Ordenacoes dos Fields
    aSort(aCabs,,, {|x,y|, x[ 02, nEmpLog, 03] < y[ 02, nEmpLog, 03] }) // Ordenacao pelo 3ro elemento (Ordem ExecAuto)
    aSort(aItns,,, {|x,y|, x[ 02, nEmpLog, 03] < y[ 02, nEmpLog, 03] }) // Ordenacao pelo 3ro elemento (Ordem ExecAuto)
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Preparando aCabec/aItens...")
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DbSelectArea("SC7")
    SC7->(DbSetOrder(1)) // C7_FILIAL + C7_NUM
    If SC7->(DbSeek( cFilCom + cPedCom ))

        If SC7->C7_FORNECE $ "005866/005764/" // Verificar se È intra grupo     // "033467"
            For _w1 := 1 To Len( aCabs )
                If aCabs[_w1, 02, nEmpLog, 03 ] > 0 // Ordem ExecAuto em Uso
                    If ValType( aCabs[ _w1, 02, nEmpLog, 01 ] ) == "B"
                        If ValType( aCabs[ _w1, 02, nEmpLog, 01 ] ) == "U"
                            Loop
                        ElseIf aCabs[ _w1, 02, nEmpLog, 02 ] // .T.=Abrir dados agora
                            cOrigem := Eval( aCabs[ _w1, 02, nEmpLog, 01 ] )
                        Else // Abrir dados na hora do execauto
                            cOrigem := aCabs[ _w1, 02, nEmpLog, 01 ] // Mantem o bloco de codigo
                        EndIf
                    Else // Nao eh bloco de codigo
                        cOrigem := aCabs[ _w1, 02, nEmpLog, 01 ]
                    EndIf
                    //           {        Field SC5, Origem da informacao,              Gatilho }
                    aAdd(aCabec, { aCabs[ _w1, 01 ],              cOrigem,                  Nil })
                EndIf
            Next
            While SC7->(!EOF()) .And. SC7->C7_FILIAL + SC7->C7_NUM == cFilCom + cPedCom
              /***************************************************************************************************************************************
              <<AlteraÁ„o>>
              AÁ„o......: Verifica se o item do pedido de compra j· foi integrado atravÈs do campo C7_XPEDVEN.
              ..........: Caso o item j· possua um n˙mero de pedido de venda n„o entra no vetor
              Analista..: Marcelo Klopfer Leme - SIGAMAT
              Data......: 29/09/2022
              Chamado...:  20220928018282
              ***************************************************************************************************************************************/
              IF EMPTY(SC7->C7_XPEDVEN)

                If .T. // Empty(SC7->C7_XPEDGER) // Pedido de Venda ainda nao foi gerado para este pedido de compras
                    If SC7->C7_QUANT - SC7->C7_QUJE > 0 // Quantidade a entregar
                        If SB1->(DbSeek(_cFilSB1 + SC7->C7_PRODUTO))
                            aItPed := {}
                            For _w1 := 1 To Len( aItns )
                                If aItns[_w1, 02, nEmpLog, 03 ] > 0 // Ordem ExecAuto em Uso
                                    If ValType( aItns[ _w1, 02, nEmpLog, 01 ] ) == "U"
                                        Loop
                                    ElseIf ValType( aItns[ _w1, 02, nEmpLog, 01 ] ) == "B"
                                        If aItns[ _w1, 02, nEmpLog, 02 ] // .T.=Abrir dados agora
                                            cOrigem := Eval( aItns[ _w1, 02, nEmpLog, 01 ] )
                                        Else // Abrir dados na hora do execauto
                                            cOrigem := aItns[ _w1, 02, nEmpLog, 01 ] // Mantem o bloco de codigo
                                        EndIf
                                    Else // Nao eh bloco de codigo
                                        cOrigem := aItns[ _w1, 02, nEmpLog, 01 ]
                                    EndIf
                                    //           {        Field SC6, Origem da informacao,              Gatilho }
                                    aAdd(aItPed, { aItns[ _w1, 01 ],              cOrigem,                  Nil })
                                EndIf
                            Next
                            aAdd(aItens, aClone( aItPed ))
                        Else // Produto nao encontrado no cadastro (SB1)
                            cMsg01 := "Produto nao encontrado no cadastro (SB1)!"
                            cMsg02 := "Produto: " + SC7->C7_PRODUTO
                            lRet := .F.
                            Exit
                        EndIf
                    EndIf
                Else // Pedido de Venda ja foi gerado
                    cMsg01 := "Pedido de Venda ja gerado para este Item do Pedido de Compras!"
                    cMsg02 := "Pedido de Venda: " + SC7->C7_ZNUMPV
                    lVld := .F.
                    Exit
                EndIf
              ENDIF
              SC7->(DbSkip())
            End
            If lVld .And. Len( aItens ) == 0 // Nenhum item com saldo
                cMsg01 := "Esse pedido nao possui nenhum item com saldo para gerar pedido de venda!"
                cMsg02 := "Verifique os saldos do pedido de compra e tente novamente!"
                lVld := .F.
            EndIf
        Else // Fornecedor nao eh do grupo
            cMsg01 := "Essa rotina sÛ deve ser utilizada para pedidos intra grupo!"
            cMsg02 := "Verifique o Fornecedor do pedido de compra e tente novamente!"
            cMsg02 := "Fornecedores: " + "005866/005764/"
            lVld := .F.
        EndIf
    Else // Pedido de Compra nao localizado (SC7)
        cMsg01 := "Pedido de Compra nao localizado (SC7)!"
        cMsg02 := "Filial/Pedido: " + cFilCom + "/" + cPedCom
        lVld := .F.
    EndIf
Else // Cancelado
    cMsg01 := "Operacao cancelada pelo usuario!"
    lVld := .F.
EndIf

// Montagem de Json a partir das matrizes
If lVld // .T.=Sucesso
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando Json para comunicacao webservice...")
    cJson += '{' + Chr(13) + Chr(10) // Inicial
    cJson += '"Emp": "' + cCodEmp + '",' + Chr(13) + Chr(10)
    cJson += '"Fil": "' + cCodFil + '",' + Chr(13) + Chr(10)
    // Cabec
    cJson += '"Cabec": [{' + Chr(13) + Chr(10) // Abro Cabec
    For _w1 := 1 To Len( aCabec )
        cJson += '"' + aCabec[_w1,01] + '": '
        If ValType( aCabec[_w1,02] ) == "D" // Data
            cJson += '"' + DtoS( aCabec[_w1,02] ) + '"'
        ElseIf ValType( aCabec[_w1,02] ) == "N" // Numerico
            cJson += cValToChar(aCabec[_w1,02])
        ElseIf ValType( aCabec[_w1,02] ) == "C" // Char
            cJson += '"' + aCabec[_w1,02] + '"'
        EndIf
        cJson += Iif(_w1 < Len( aCabec ), ',', '') + Chr(13) + Chr(10)
    Next
    cJson += '}],' + Chr(13) + Chr(10) // Fecho Cabec
    // Itens
    cJson += '"Itens": [{' + Chr(13) + Chr(10) // Abro Itens
    For _w1 := 1 To Len( aItens )
        cJson += '"item' + Alltrim(aItens[_w1,01,02]) + '": {' + Chr(13) + Chr(10)
        For _w2 := 1 To Len( aItens[ _w1 ] )
            cJson += '"' + aItens[_w1,_w2,01] + '": '
            If ValType( aItens[_w1,_w2,02] ) == "D" // Data
                cJson += '"' + DtoS( aItens[_w1,_w2,02] ) + '"'
            ElseIf ValType( aItens[_w1,_w2,02] ) == "N" // Numerico
                cJson += cValToChar(aItens[_w1,_w2,02])
            ElseIf ValType( aItens[_w1,_w2,02] ) == "C" // Char
                cJson += '"' + aItens[_w1,_w2,02] + '"'
            EndIf
            cJson += Iif(_w2 < Len( aItens[_w1] ), ',', '') + Chr(13) + Chr(10)
        Next
        cJson += '}' + Iif(_w1 < Len( aItens ), ',', '') + Chr(13) + Chr(10)
    Next
    cJson += '}],' + Chr(13) + Chr(10) // Fecho Itens
    // Procs
    _w2 := 1
    cJson += '"Procs": [{' + Chr(13) + Chr(10) // Abro Procs
    For _w1 := 1 To Len( aPrcs )
        If aPrcs[_w1,02,01] + "/" + aPrcs[_w1,02,02] == cEmpGer // Empresa/Filial conforme
            cJson += '"proc' + StrZero(_w2++,2) + '": {' + Chr(13) + Chr(10)
            cJson += '"Field": "' + aPrcs[_w1,01] + '",' + Chr(13) + Chr(10)
            cJson += '"Block": "' + StrTran(GetCbSource(aPrcs[_w1,02,03]),'"',"'") + '",' + Chr(13) + Chr(10)
            cJson += '"Tipo": "' + aPrcs[_w1,02,04] + '",' + Chr(13) + Chr(10)
            cJson += '"Msg": "' + aPrcs[_w1,02,05] + '"' + Chr(13) + Chr(10)
            cJson += '}' + Iif(ASCan(aPrcs, {|x|, x[02,01] + "/" + x[02,02] == cEmpGer }, _w1 + 1) > 0, ',', '') + Chr(13) + Chr(10)
        EndIf
    Next
    cJson += '}]' + Chr(13) + Chr(10) // Fecho Procs
    cJson += '}' + Chr(13) + Chr(10) // Final
    ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando Json para comunicacao webservice... Concluido!")
EndIf
ConOut("StWeb072: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
//     {   01,     02,     03,     04,     05,      06,      07,     08,     09,    10,    11 }
Return { lVld, cMsg01, cMsg02, cMsg03, cMsg04, cCodEmp, cCodFil, aCabec, aItens, aPrcs, cJson }

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StWeb073 ∫Autor≥ Jonathan Schmidt Alves ∫Data ≥ 16/02/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Chamada webservice.                                        ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ aRet[ 01 ]   .T.=Sucesso no processamento .F.=Falha        ∫±±
±±∫          ≥     [ 02 ]   Mensagem 01 da falha                          ∫±±
±±∫          ≥     [ 03 ]   Mensagem 02 da falha                          ∫±±
±±∫          ≥     [ 04 ]   Mensagem 03 da falha                          ∫±±
±±∫          ≥     [ 05 ]   Mensagem 04 da falha                          ∫±±
±±∫          ≥     [ 06 ]   Empresa para processamento  Ex: "03"          ∫±±
±±∫          ≥     [ 07 ]   Filial para processamento   Ex: "01"          ∫±±
±±∫          ≥     [ 08 ]   Matriz cabecalho ExecAuto MATA410             ∫±±
±±∫          ≥     [ 09 ]   Matriz itens ExecAuto MATA410                 ∫±±
±±∫          ≥     [ 10 ]   Matriz de adequacoes na base                  ∫±±
±±∫          ≥     [ 11 ]   Json montado para integracao webservice       ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StWeb073( aRet )
Local _w1
Local lRet := .T.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
// Dados para conexao e obtencao do Token
Local cUrl := ""
Local cUsrNam := SUPERGETMV("STWEB70N",,"rest.interno")
Local cPasswd := SUPERGETMV("STWEB70P",,"steck@22")
Local cToken := Encode64(cUsrNam + ":" + cPasswd)
// Header
Local aHeadOut := {}
// Objeto Rest
Private oRest
ConOut("STWEB073: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Conexao conforme a empresa destino onde o Pedido de Venda deve ser incluido
If aRet[06] + "/" + aRet[07] == "01/05"
    cUrl := SuperGetMv("STWEB07301", .F., "http://rest-p12.steck.com.br:9998/rest") // cUrl := "http://10.152.10.8:10003/rest"

ElseIf aRet[06] + "/" + aRet[07] == "03/01" // Chamada base empresa 01/05 ou 03/01 
    cUrl := SuperGetMv("STWEB07305", .F., "http://rest-p12.steck.com.br:9998/rest") // cUrl := "http://10.152.10.8:10003/rest"

ElseIf aRet[06] + "/" + aRet[07] == "11/01" // Chamada base empresa 11/01
    cUrl := SuperGetMv("STWEB07311", .F., "rest-p12.steck.com.br:9997/rest") // cUrl := "rest-p12.steck.com.br:9997/rest"

EndIf
// Montagem do Header
aAdd(aHeadOut, "Content-Type: application/json")
aAdd(aHeadOut, "Authorization: Basic " + cToken)
aAdd(aHeadOut, "TenantId:"+aRet[6]+","+aRet[7] )
// Montagem do Objeto
oRest := FWRest():New(cUrl)
oRest:SetPath("/StWeb081")
oRest:SetPostParams( aRet[11] ) // Json
// Chamada Rest
If oRest:Post(aHeadOut, aRet[11] ) // .T.=Sucesso
    oInfo := ""
    lRet := FWJsonDeserialize(oRest:GetResult(),@oInfo) // Retorno do processamento
    If lRet // .T.=Sucesso na obtencao da resposta
        oJson := FromJson( oRest:GetResult() )
        // Carregamento dos resultados
        For _w1 := 1 To Len(oJson:aData)
            If oJson:aData[ _w1, 01 ] == "Result"
                lRet := Iif( oJson:aData[ _w1, 02 ] == 0, .T., .F.)
            ElseIf Left(oJson:aData[ _w1, 01 ],3) == "Msg"
                &("cMsg" + Right(oJson:aData[ _w1, 01 ],2)) := oJson:aData[ _w1, 02 ]
            EndIf
        Next
    Else // .F.=Falha
        cMsg01 := "Falha no recebimento da resposta Rest!"
        cMsg02 := "Nao foi possivel receber o resultado do processamento!"
    EndIf
Else // .F.=Falha
    cMsg01 := "Falha na comunicacao webservice Rest!"
    cMsg02 := oRest:GetLastError()
    lRet := .F.
EndIf
ConOut("StWeb073: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return { lRet, cMsg01, cMsg02, cMsg03 }
