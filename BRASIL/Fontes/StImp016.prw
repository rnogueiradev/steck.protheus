#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ StImp016 บAutorณ Jonathan Schmidt Alves บData ณ 11/04/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de Pedidos de Exportacao a partir de planilha CSV. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ ImpoPlan: Importacao .CSV                                  บฑฑ
ฑฑบ          ณ     LoadPlan: Carregamento da planilha .CSV                บฑฑ
ฑฑบ          ณ     AvalPlan: Avaliacao da planilha .CSV                   บฑฑ
ฑฑบ          ณ     LoadExps: Apresentacao em tela dos dados da planilha   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function StImp016()
Local _w1
Local nMsgPr := 2 // 2=AskYesNo
Local cTitDlg := "StImp016: Importacao Pedidos Exportacao"
Private nLineD1 := 1 // Linha colors
// Usuario logado
Private cCodUsr := RetCodUsr()
// Variaveis filiais
Private _cFilSB1 := xFilial("SB1") // Produtos
Private _cFilSBM := xFilial("SBM") // Grupos Produtos
Private _cFilSA1 := xFilial("SA1") // Clientes
Private _cFilEE7 := xFilial("EE7") // Cabec Ped Exportacao
Private _cFilEE8 := xFilial("EE8") // Itens Ped Exportacao
Private _cFilEE9 := xFilial("EE9") // Itens Embarque

Private _cFilEE5 := xFilial("EE5") // Embalagens
Private _cFilEEK := xFilial("EEK") // Relacao de Embalagens
Private _cFilSY6 := xFilial("SY6") // Condicoes de Pagamento
Private _cFilSYJ := xFilial("SYJ") // Incoterms

Private _cFilSYA := xFilial("SYA") // Paises
Private _cFilSYQ := xFilial("SYQ") // Vias de Transporte
Private _cFilSYR := xFilial("SYR") // Taxas de Frete
Private _cFilSY9 := xFilial("SY9") // Siglas Portos/Aeroportos

Private _cFilDA0 := xFilial("DA0") // Tabelas de Preco
Private _cFilDA1 := xFilial("DA1") // Itens da Tabela de Preco

// Cores Panels
Private nClrC21 := RGB(205,205,205)	// Cinza Mais Claro
Private nClrC22 := RGB(217,204,117) // Cinza Amarelado
Private nClrC23 := RGB(238,185,162) // Cinza Avermelhado Claro
Private nClrC24 := RGB(161,161,161) // Cinza Mais Escuro
// Cores GetDados 01
Private nClr111 := RGB(171,171,171)	// Cinza Padrao				*** 01: Incluido
Private nClr112 := RGB(151,151,151) // Cinza Mais Escuro        *** 01: Incluido Selecionado
Private nClr121 := RGB(217,204,117) // Cinza Amarelado          *** 02: Aguardando aprovacao
Private nClr122 := RGB(208,193,087) // Cinza Amarelado Escuro   *** 02: Aguardando aprovacao Selecionado
Private nClr131 := RGB(255,138,138) // Vermelho	Claro           *** 03: Reprovado
Private nClr132 := RGB(255,098,098) // Vermelho	Escuro          *** 03: Reprovado Selecionado
Private nClr141 := RGB(165,250,160) // Verde Claro				*** 04: Aprovado
Private nClr142 := RGB(090,245,082) // Verde Escuro             *** 04: Aprovado Selecionado
Private nClr151 := RGB(132,155,251) // Azul Claro				*** 05: Processado
Private nClr152 := RGB(109,140,245) // Azul Mais Escuro         *** 05: Processado Selecionado
// Cores GetDados 02, 03 e 04
Private nClr201 := RGB(171,171,171)	// Cinza Padrao
Private nClr202 := RGB(151,151,151) // Cinza Mais Escuro
Private nClr301 := RGB(217,204,117) // Cinza Amarelado
Private nClr302 := RGB(208,193,087) // Cinza Amarelado Escuro
Private nClr401 := RGB(238,185,162) // Cinza Avermelhado Claro
Private nClr402 := RGB(231,150,116) // Cinza Avermelhado Escuro 
// Objetos principais
Private oDlg01
Private oGetD1
Private oPnlGd1
Private oPnlBot
// Variaveis Objetos
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
Private aButtons := {}
// Montagem do aMolds01
Private aMolds01 := MntMolds("EXP", 0)
Private aRet := { .F., Array(0) }
// Abertura das tabelas
If cModulo == "EEC"
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
    DbSelectArea("SBM")
    SBM->(DbSetOrder(1)) // BM_FILIAL + BM_GRUPO
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
    DbSelectArea("EEC")
    EEC->(DbSetOrder(1)) // EEC_FILIAL + EEC_PREEMB
    DbSelectArea("EE7")
    EE7->(DbSetOrder(1)) // EE7_FILIAL + EE7_PEDIDO
    DbSelectArea("EE8")
    EE8->(DbSetOrder(1)) // EE8_FILIAL + EE8_PEDIDO + EE8_SEQUEN + EE8_COD_I
    DbSelectArea("EE9")
    EE9->(DbSetOrder(8)) // EE9_FILIAL + EE9_PREEMB + EE9_NCM + EE9_PRECO
    DbSelectArea("EE5")
    EE5->(DbSetOrder(1)) // EE5_FILIAL + EE5_CODEMB
    DbSelectArea("EEK")
    EEK->(DbSetOrder(1)) // EEK_FILIAL + EEK_TIPO + EEK_CODIGO + EEK_CODIGO + EEK_SEQ
    DbSelectArea("SY6")
    SY6->(DbSetOrder(1)) // Y6_FILIAL + Y6_COD + Str(Y6_DIAS_PA,3,0)
    DbSelectArea("SYJ")
    SYJ->(DbSetOrder(1)) // YJ_FILIAL + YJ_COD

    DbSelectArea("SYA")
    SYA->(DbSetOrder(1)) // YA_FILIAL + YA_CODGI
    
    DbSelectArea("SY9")
    SY9->(DbSetOrder(2)) // Y9_FILIAL + Y9_SIGLA

    DbSelectArea("SYQ")
    SYQ->(DbSetOrder(1)) // YQ_FILIAL + YQ_VIA

    DbSelectArea("SYR")
    SYR->(DbSetOrder(1)) // YR_FILIAL + YR_VIA + YR_ORIGEM + YR_DESTINO + YR_TIPTRAN

    DbSelectArea("DA0")
    DA0->(DbSetOrder(1)) // DA0_FILIAL + DA0_CODTAB
    DbSelectArea("DA1")
    DA1->(DbSetOrder(1)) // DA1_FILIAL + DA1_CODTAB + DA1_CODPRO + ...

    // Carregamento do Header conforme aMolds
    aHdr01 := {}
    For _w1 := 1 To Len(aMolds01) // Montagem do Header
        // 	         { 01-Titulo	      , 02-Campo		   , 03-Picture         , 04-Tamanho	     , 05-Decimal         , 06-Valid, 07-Usado         , 08-Tipo	        , 09-F3, 10-Contexto, 11-ComboBox, 12-Relacao, 13-When, 14-Visual, 15-Valid Usuario
        aAdd(aHdr01, { aMolds01[_w1,01,01], aMolds01[_w1,03,06], aMolds01[_w1,01,07], aMolds01[_w1,01,05], aMolds01[_w1,01,06],    ".F.", "€€€€€€€€€€€€€€ ", aMolds01[_w1,01,04],    "",         "R",          "",         "" })
        &("nP01" + SubStr(aHdr01[_w1,2],5,6)) := _w1
    Next
    aAdd(aHdr01,            { "Status",             "EE8_CODSTA",                 "",                 200,                  00,    ".F.", "€€€€€€€€€€€€€€ ",                 "C",    "",         "R",          "",         "" })  // Status Processamento
    nP01CodSta := _w1

    aRet := ImpoPlan( nMsgPr )

    If aRet[01] // .T.=Sucesso no carregamento/validacao/apresentacao
        DEFINE MSDIALOG oDlg01 FROM 010,165 TO 540,1490 TITLE cTitDlg Pixel
        // Panel
        oPnlGd1	:= TPanel():New(030,000,,oDlg01,,,,,nClrC22,742,210,.F.,.F.) // Panel do GetDados 01
        oPnlBot	:= TPanel():New(250,000,,oDlg01,,,,,nClrC21,742,012,.F.,.F.) // Panel do Rodape
        // GetDados 01
        oGetD1 := MsNewGetDados():New(015,002,195,660,Nil,"AllwaysTrue()",,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlGd1,aHdr01,aCls01)
        oGetD1:oBrowse:SetBlkBackColor({|| GetD1Clr(oGetD1:aCols, oGetD1:nAt, aHdr01) })
        oGetD1:bChange := {|| nLineD1 := oGetD1:nAt, oGetD1:Refresh() }
        oGetD1:oBrowse:lHScroll := .T.
        ACTIVATE MSDIALOG oDlg01 CENTERED ON INIT EnchoiceBar(oDlg01, {|| IncAP100() },{|| oDlg01:End() },, aButtons)
    EndIf
Else // Modulo invalido
    MsgStop("Modulo invalido para este processamento!" + Chr(13) + Chr(10) + ;
    "Voce deve estar no modulo EEC (Easy Export Control) para executar esta rotina!","StImp016")
EndIf
Return

Static Function GetD1Clr(aCols, nLine, aHdrs) // Cores GetDados 01
Local nClr := nClrC21 // Cinza Mais Claro
If Left(aCols[ nLine, nP01CodSta ],1) == "3" // "3??"=Ok
    nClr := Iif(nLineD1 == nLine, nClr142, nClr141) // Verde Claro/Escuro
ElseIf Left(aCols[ nLine, nP01CodSta ],1) == "5" // "5??"=Erro
    nClr := Iif(nLineD1 == nLine, nClr131, nClr132) // Vermelho Claro/Escuro
ElseIf Left(aCols[ nLine, nP01CodSta ],1) == "8" // "8??"=Processado
    nClr := Iif(nLineD1 == nLine, nClr151, nClr152) // Azul Claro/Escuro
EndIf
Return nClr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ImpoPlan บAutor ณ Jonathan Schmidt Alves บData ณ11/04/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao da planilha .CSV com os dados para peds export. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ImpoPlan(nMsgPr)
Local aRet := { .F., "", "", "", "" }
Local cArqRet := ""
Default nMsgPr := 2 // 2=AskYesNo
cArqRet := fAbrir("*.CSV")
If !Empty( cArqRet ) // Arquivo preenchido
    // Parte 01: Abrindo e validando dados do arquivo escolhido
    u_AskYesNo(3500,"LoadPlan","01/03 Carregando...","Carregando dados da planilha...","","","","PROCESSA",.T.,.F.,{|| aRet := LoadPlan(nMsgPr, cArqRet) }) // Carregamento
    If aRet[01] // .T.=Valido   // { .T., aDados }
        // Parte 02: Avaliacao dos dados da planilha
        u_AskYesNo(3500,"AvalPlan","02/03 Avaliando...","Avaliando dados...","","","","PROCESSA",.T.,.F.,{|| aRet := AvalPlan( nMsgPr, cArqRet, @aRet[02] ) }) // Gravando dados
        If aRet[01] // .T.=Valido   // { .T., aDados }
            // Parte 03: Apresentando em tela
            u_AskYesNo(3500,"ShowPlan","03/03 Apresentando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| aRet := ShowPlan( nMsgPr, cArqRet, aRet[02] ) }) // Apresentacao em tela
        EndIf
    EndIf
EndIf
Return aRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ LoadPlan บAutor ณ Jonathan Schmidt Alves บData ณ04/03/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregamento da planilha Excel com dados .CSV              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LoadPlan(nMsgPr, cArqRet) // Validacoes da planilha
Local _z1
Local _w1
Local nLin := 1
Local nLines := 0
Local cLines := ""
Local lVld := .T.
Local lVldLds := .T.
Local nLastUpdate := Seconds()
Local xDado
Local aDado := {}
Local aDados := {}
Local cBuffer := ""
Local nFldPlan := 0
Local nFldsPlan := 0
Private nItem := 1
ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := 12
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"01/03 Verificando...","", "", "", 80, "PROCESSA")
        Sleep(100)
    Next
EndIf
If !Empty(cArqRet) // Arquivo preenchido
    If FT_FUse(cArqRet) >= 0
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent,"01/03 Verificando...","Verificando os dados do arquivo...", "Arquivo: " + cArqRet, "", 80, "PROCESSA")
            Sleep(100)
        Next
        FT_FGotop()
        FT_FSkip() // Pula cabecalho
        nLines := FT_FLastRec()
        cLines := cValToChar(nLines)
        FT_FGotop()
        FT_FSkip()
        While (!FT_FEOF()) .And. lVld
            cBuffer := FT_FREADLN()
            While At(";;",cBuffer) > 0
                cBuffer := StrTran(cBuffer,";;"," ; ; ")
            End
            If Left(cBuffer,1) == ";"
                cBuffer := " " + cBuffer
            EndIf
            aDado := StrToKarr(cBuffer,";")
            nLin++
            nFldsPlan := 0
            aEVal(aMolds01, {|x|, Iif(x[01,03], nFldsPlan++, Nil) }) // Contador de fields obrigatorios planilha no aMolds
            If Len(aDado) == nFldsPlan // Colunas conforme aMolds01
                _aDados := {}
                lVldLds := .T. // Validacao de carregamento
                cStatus := "301=Ok"
                nFldPlan := 0
                For _w1 := 1 To Len( aMolds01 ) // Rodo nos campos
                    If aMolds01[ _w1, 01, 03 ] // Coluna da planilha
                        xDado := aDado[++nFldPlan] // Dado carregado da planilha
                    EndIf
                    If &(aMolds01[ _w1, 03, 02 ]) // Validacao pre-carregamento antes de carregar a variavel
                        xDado := &(aMolds01[ _w1, 03, 03 ]) // Origem da informacao (normalmente o proprio xDado)
                        If &(aMolds01[ _w1, 03, 04 ]) // Condicao para consideracao do campo apos carregar da origem
                            If !Empty( aMolds01[ _w1, 03, 05 ] ) // Tratamento da informacao apos carregar da origem
                                xDado := &(aMolds01[ _w1, 03, 05 ])
                            EndIf

                            If AllTrim(aMolds01[ _w1, 03, 6 ]) == "EE8_QE"
                                If xDado==0
                                    xDado := 1
                                EndIf
                                aAdd(_aDados, xDado) // Resultado
                            Else
                                aAdd(_aDados, xDado) // Resultado
                            EndIf

                        EndIf
                    Else // Invalido para processamento
                        If AllTrim(aMolds01[ _w1, 03, 6 ]) == "EE8_PRECO"
                            aAdd(_aDados, 0.00001) 
                        Else
                        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados invalidos na planilha! (Linha " + cValToChar(nLin) + ")")
                        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Campo: " + aMolds01[_w1, 03, 06 ])
                        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique os dados da planilha e tente novamente!")
                        cStatus := "501=Dados invalidos no carregamento da planilha!"
                        
                        // Mostrar MsgStop para a Cynthia ver erro a erro
                        MsgStop("Dados invalidos na planilha! (Linha " + cValToChar(nLin) + ")" + Chr(13) + Chr(10) + ;
                        "Campo: " + aMolds01[_w1, 03, 06 ] + Chr(13) + Chr(10) + ;
                        "Verifique os dados da planilha e tente novamente!","AvalPlan")

                        /*
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(nCurrent,"01/03 Carregando...","Dados invalidos na planilha! (Linha " + cValToChar(nLin) + ")", "Campo: " + aMolds01[_w1, 03, 06 ], "Verifique os dados da planilha e tente novamente!", 80, "PROCESSA")
                                Sleep(800)
                            Next
                        EndIf
                        */

                        lVldLds := .F.
                        EndIf
                    EndIf
                Next
                aAdd(_aDados, PadR(cStatus,200))   // Status
                aAdd(_aDados, .F.)          // Nao Apagado
                aAdd(aDados, aClone(_aDados))
                nItem++ // Item do pedido
                If lVldLds // Ainda valido
                    If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a ๚ltima atualiza็ใo da tela
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent,"01/03 Carregando...","Carregando dados da planilha... ", "Planilha: " + cArqRet + " Linha: " + cValToChar(nLin) + " / " + cLines, "", 80, "PROCESSA")
                                Sleep(050)
                            Next
                        EndIf
                        nLastUpdate := Seconds()
                    EndIf
                EndIf
            Else // Planilha com colunas invalidas (nao permite prosseguir)
                ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Qtde de colunas invalida! (Linha " + cValToChar(nLin) + ")")
                ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Colunas Planilha: " + cValToChar(Len(aDado)))
                ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique os dados da planilha e tente novamente!")
                If nMsgPr == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/03 Carregando...","Qtde de colunas invalida! (Linha " + cValToChar(nLin) + ")", "Colunas Planilha: " + cValToChar(Len(aDado)), "Verifique os dados da planilha e tente novamente!", 80, "UPDERROR")
                        Sleep(800)
                    Next
                EndIf
                lVld := .F.
            EndIf
            FT_FSkip() // Pula linha
        End
        FT_FUse() // Fecha o arquivo
    Else // Arquivo nao pode ser aberto
        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " A planilha nao pode ser aberta!")
        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Planilha: " + cArqRet)
        ConOut("LoadPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique se o arquivo nao esta aberto e tente novamente!")
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(++nCurrent,"01/03 Verificando...","A planilha nao pode ser aberta!", "Planilha: " + cArqRet, "Verifique se o arquivo nao esta aberto e tente novamente!", 80, "UPDERROR")
                Sleep(500)
            Next
        EndIf
        lVld := .F.
    EndIf
Else // Arquivo nao foi preenchido
    If nMsgPr == 2 // 2=AskYesNo
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent,"01/03 Verificando...","Arquivo nao foi preenchido para processamento!", "", "Escolha um arquivo e tente novamente!", 80, "UPDERROR")
            Sleep(500)
        Next
    EndIf
    lVld := .F.
EndIf
//     {  .T.,        }
Return { lVld, aDados }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ AvalPlan บAutor ณ Jonathan Schmidt Alves บData ณ11/04/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avaliacao dos dados da planilha Excel .CSV                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function AvalPlan(nMsgPr, cArqRet, aDados)
Local _w1
Local _w2
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cImg := ""
Local lVld := .T.
Local nLastUpdate := Seconds()
ConOut("AvalPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := 12
    For _w2 := 1 To 4
        u_AtuAsk09(++nCurrent,"02/03 Avaliando...","", "", "", 80, "PROCESSA")
        Sleep(100)
    Next
EndIf
// Parte 01: Avaliacao dos problemas
For _w1 := 1 To Len( aDados )
    // Importador
    cImport := aDados[ _w1, nP01Import ]                                // Importador
    cImLoja := aDados[ _w1, nP01ImLoja ]                                // Loja do Importador
    If SA1->(DbSeek( _cFilSA1 + cImport + cImLoja ))
        cImpoDe := SA1->A1_NOME                                         // Nome do Importador
        cCodImp := SA1->A1_PAIS                                         // Codigo do Pais do Importador
        If SYA->(!DbSeek( _cFilSYA + cCodImp )) // Pais do Importador nao encontrado no cadastro (SYA)
            aDados[ _w1, nP01CodSta ] := "502=Pais do Importador/Loja nao encontrado no cadastro (SYA): " + cCodImp
            lVld := .F.
        ElseIf Empty( SA1->A1_XTABEEC ) // Tabela do Cliente EEC nao preenchida
            aDados[ _w1, nP01CodSta ] := "561=Tabela de Preco para Exportacao do cliente nao preenchida (SA1): " + SA1->A1_COD + "/" + SA1->A1_LOJA
            lVld := .F.
        ElseIf DA0->(!DbSeek( _cFilDA0 + SA1->A1_XTABEEC )) // Tabela de Preco
            aDados[ _w1, nP01CodSta ] := "561=Tabela de Preco nao encontrada no cadastro (DA0): " + SA1->A1_XTABEEC
            lVld := .F.
        EndIf
    Else
        aDados[ _w1, nP01CodSta ] := "503=Importador/Loja nao encontrado no cadastro (SA1): " + cImport + "/" + cImLoja
        lVld := .F.
    EndIf
    // Fornecedor
    cFornec := aDados[ _w1, nP01Forn   ]                                // Fornecedor
    cFoLoja := aDados[ _w1, nP01FoLoja ]                                // Loja do Fornecedor
    If SA1->(DbSeek( _cFilSA1 + cImport + cImLoja ))
        cFornDe := SA1->A1_NOME                                         // Nome do Fornecedor
    ElseIf lVld
        aDados[ _w1, nP01CodSta ] := "511=Fornecedor/Loja nao encontrado no cadastro (SA1): " + cFornec + "/" + cFoLoja
    EndIf
    // Idioma
    cIdioma := aDados[ _w1, nP01Idioma ]                                // Idioma
    // Condicao de Pagamento
    cCondPa := aDados[ _w1, nP01CondPa ]                                // Condicao de Pagamento
    If SY6->(DbSeek( _cFilSY6 + cCondPa))
        cCondPa := SY6->Y6_COD
    ElseIf lVld
        aDados[ _w1, nP01CodSta ] := "521=Condicao de Pagamento nao encontrada no cadastro (SY6): " + cCondPa
    EndIf
    // Modalidade Pagamento
    cMsgExp := aDados[ _w1, nP01MsgExp ]                                // Modalidade Pagamento
    // Incoterm
    cIncote := aDados[ _w1, nP01Incote ]                                // Incoterm
    If SYJ->(DbSeek( _cFilSYJ + cIncote ))
        cFrppcc := SYJ->YJ_FRPPCC
    ElseIf lVld
        aDados[ _w1, nP01CodSta ] := "531=Incoterm nao encontrado no cadastro (SYJ): " + cIncote
    EndIf
    // Moeda
    cMoeda  := aDados[ _w1, nP01Moeda  ]                                // Moeda
    If cMoeda <> "US$"
        aDados[ _w1, nP01CodSta ] := "541=Moeda deve ser sempre 'US$'!"
    EndIf
    // Calculo Embalagem
    cCalCem := aDados[ _w1, nP01CalCem ]                                // Calculo Embalagem
    If cCalCem <> "1" // "1"=Volume
        aDados[ _w1, nP01CodSta ] := "551=Calculo Embalagem deve ser sempre '1'=Volume!"
    EndIf
    // Via de Transporte
    cVia := ""
    cViaTra := aDados[ _w1, nP01Via    ]                                // Via localizada
    SYQ->(DbGotop())
    While SYQ->(!EOF())
        If Val(SYQ->YQ_CODFIES) == Val(cViaTra)
            cVia := SYQ->YQ_VIA // SYQ->YQ_CODFIES // Via localizada
            Exit
        EndIf
        SYQ->(DbSkip())
    End
    If Empty(cVia)
        aDados[ _w1, nP01CodSta ] := "561=Via de Transporte nao encontrada no cadastro (SYQ->YQ_CODFIES): " + cVia
    Else // Ajuste na via
        aDados[ _w1, nP01Via    ] := cVia // Via adequada YQ_CODFIES -> YQ_VIA
    EndIf

    // Validacao da Origem/Destino e Via na SY9 e na SYR
    If SY9->(!DbSeek( _cFilSYR + aDados[ _w1, nP01Origem ] ))
        aDados[ _w1, nP01CodSta ] := "571=Origem nao encontrada no cadastro de Portos/Aeroportos (SY9): " + aDados[ _w1, nP01Origem ]
    ElseIf SY9->(!DbSeek( _cFilSYR + aDados[ _w1, nP01Dest ] ))
        aDados[ _w1, nP01CodSta ] := "572=Destino nao encontrado no cadastro de Portos/Aeroportos (SY9): " + aDados[ _w1, nP01Dest ]
    ElseIf SYR->(!DbSeek( _cFilSYR + cVia + aDados[ _w1, nP01Origem ] + aDados[ _w1, nP01Dest ] )) // Verificando VIA + ORIGEM + DESTINO no SYR
        aDados[ _w1, nP01CodSta ] := "573=Via + Origem + Destino nao encontrados no cadastro (SYR): " + cVia + "/" + aDados[ _w1, nP01Origem ] + "/" + aDados[ _w1, nP01Dest ]
    EndIf

    // Validacao do produto
    If .F.//lVld // Ainda valido
        If Empty( aDados[ _w1, nP01Cod_I ] ) // Produto nao preenchido
            aDados[ _w1, nP01CodSta ] := "571=Codigo do Produto nao preenchido na planilha!"
            lVld := .F.
        ElseIf SB1->(!DbSeek( _cFilSB1 + aDados[ _w1, nP01Cod_I ] )) // Produto nao encontrado no cadastro (SB1)
            aDados[ _w1, nP01CodSta ] := "572=Produto nao encontrado no cadastro (SB1): " + aDados[ _w1, nP01Cod_I ]
            lVld := .F.
        ElseIf SB1->B1_MSBLQL == "1" // Produto bloqueado no cadastro (SB1)
            aDados[ _w1, nP01CodSta ] := "573=Produto esta bloqueado no cadastro (SB1): " + SB1->B1_COD
            lVld := .F.
        ElseIf SB1->B1_PESO <= 0 // Sem peso
            aDados[ _w1, nP01CodSta ] := "574=Produto esta sem Peso Liquido preenchido no cadastro (B1_PESO): " + SB1->B1_COD
            lVld := .F.
        //ElseIf aDados[ _w1, nP01Preco ] <= 0 // Sem preco preenchido
            //aDados[ _w1, nP01CodSta ] := "575=Produto nao teve o preco obtido na tabela de preco! Tabela/Produto: " + SA1->A1_XTABEEC + "/" + SB1->B1_COD
            //lVld := .F.
            //aDados[ _w1, nP01Preco ] := 0.0000001
        EndIf
    EndIf
    If nMsgPr == 2 // 2=AskYesNo
        If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a ๚ltima atualiza็ใo da tela
            For _w2 := 1 To 4
                u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Avaliando dados da planilha... Concluido!", "Planilha: " + cArqRet, "", 80, "PROCESSA")
                Sleep(060)
            Next
        EndIf
        nLastUpdate := Seconds()
    EndIf
Next
// Parte 02: Validacoes planilha
If nMsgPr == 2 // 2=AskYesNo
    If lVld
        cMsg01 := "Avaliando os dados carregados...Sucesso!"
        cMsg02 := ""
        cMsg03 := ""
        cImg := "OK"
    Else
        cMsg01 := "Avaliando os dados carregados...Falha!"
        cMsg02 := ""
        cMsg03 := ""
        cImg := "UPDERROR"
    EndIf
    _oMeter:nTotal := Len(aDados)
    For _w2 := 1 To 4
        u_AtuAsk09(++nCurrent,"02/03 Avaliando...",cMsg01, cMsg02, cMsg03, 80, cImg)
        Sleep(080)
    Next
EndIf
//     {  .T.,        }
Return { lVld, aDados }

Static Function ShowPlan( nMsgPr, cArqRet, aDados )
Local lVld := .T.
aCls01 := aClone( aDados )
Return { lVld }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ MntMolds บAutor ณJonathan Schmidt Alvesบ Data ณ 11/04/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do layout de integracao (Planilha .CSV)           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ EE7_IMPORT                                                 บฑฑ
ฑฑบ          ณ EE7_IMLOJA                                                 บฑฑ
ฑฑบ          ณ EE7_CONDPA                                                 บฑฑ
ฑฑบ          ณ EE7_INCOTE                                                 บฑฑ
ฑฑบ          ณ EE7_CONSIG                                                 บฑฑ
ฑฑบ          ณ EE7_VIA                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ EE8_COD_I                                                  บฑฑ
ฑฑบ          ณ EE8_SLDINI                                                 บฑฑ
ฑฑบ          ณ EE8_DTENTR                                                 บฑฑ
ฑฑบ          ณ EE8_XPOCLI                                                 บฑฑ
ฑฑบ          ณ EE7_ORIGEM                                                 บฑฑ
ฑฑบ          ณ EE7_DEST                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Planilha .CSV - Geracao da planilha a partir da matriz     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cTipRg: Tipo dos registros                                 บฑฑ
ฑฑบ          ณ         Exemplo: "EXP"=Importacao de Pedidos Exportacao    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nMsgPr: Mensagem de processamento                          บฑฑ
ฑฑบ          ณ         Exemplo: 2=AskYesNo                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MntMolds(cTipRg, nMsgPr)
Local aMolds := {}
Local _z1
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Pedidos Exportacao)...", "", "", 80, "PROCESSA")
		Sleep(100)
	Next
EndIf
If cTipRg == "EXP" // Pedidos Exportacao (EE7/EE8)
    //           { { ###################################### L A Y O U T  C L I E N T E ################################################################ }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,             Regras de Integridade   ,                                 Field Plan, Tipo, Tam, Dec, Picture           }, { Variavel informacoes,		                                Validacao pre-carregamento,                    		                                                                                                                                                        Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,             Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                                                                    }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {        01,                                       02,                                         03,   04,  05,  06, 07                }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Pedido",                  "Pedido"                ,                                        .T.,  "C",  20,  00, ""                }, {	              "_",                                                           ".T.",                                                                                                                                                                                        "'004476/22'",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                               "PadL(xDado,20)",                               ".T.",                       "", "EE7_PEDIDO" } })
    aAdd(aMolds, { { "Import",                  "Import"                ,                                        .T.,  "C",  06,  00, ""                }, {	              "_",                                                           ".T.",                                                                                                                                                                                  "PadL(xDado,6,'0')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                           "SA1->(DbSeek( _cFilSA1 + PadL(xDado,06,'0')))",                                                  "SA1->A1_COD",                               ".T.",                       "", "EE7_IMPORT" } })
    aAdd(aMolds, { { "Import Loja",             "Import Loja"           ,                                        .T.,  "C",  02,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                  "PadL(xDado,2,'0')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,         "SA1->(!EOF()) .And. SA1->(DbSeek( _cFilSA1 + SA1->A1_COD + PadL(xDado,02,'0')))",                                                 "SA1->A1_LOJA",                               ".T.",                       "", "EE7_IMLOJA" } })
    aAdd(aMolds, { { "Nome",                    "Nome do Importador"    ,                                        .T.,  "C",  60,  00, "@!"              }, {                  "_",                                                           ".T.",                                                                                                                                                      "Iif(SA1->(!EOF()), SA1->A1_NREDUZ, Space(20))",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "ZRP_NOMFOR" } })
    aAdd(aMolds, { { "Forn",                    "Forn"                  ,                                        .T.,  "C",  06,  00, ""                }, {	              "_",                                                           ".T.",                                                                                                                                                                                  "PadL(xDado,6,'0')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                           "PadL(xDado,06,'0')",                               ".T.",                       "", "EE7_FORN  " } })
    aAdd(aMolds, { { "Forn Loja",               "Forn Loja"             ,                                        .T.,  "C",  02,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                  "PadL(xDado,2,'0')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                           "PadL(xDado,02,'0')",                               ".T.",                       "", "EE7_FOLOJA" } })
    aAdd(aMolds, { { "Idioma",                  "Idioma"                ,                                        .F.,  "C",  25,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                              "'INGLES-INGLES'",                               ".T.",                       "", "EE7_IDIOMA" } })
    aAdd(aMolds, { { "Payment Term",            "Condicao Pagamento"    ,                                        .T.,  "C",  05,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE7_CONDPA" } })
    aAdd(aMolds, { { "MsgExp",                  "MsgExp"                ,                                        .F.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "'003'",                               ".T.",                       "", "EE7_MSGEXP" } })
    aAdd(aMolds, { { "Incoterm",                "Incoterm"              ,                                        .T.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE7_INCOTE" } })
    aAdd(aMolds, { { "Frppcc",                  "Frppcc"                ,                                        .F.,  "C",  02,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                         "'CC'",                               ".T.",                       "", "EE7_FRPPCC" } })
    aAdd(aMolds, { { "Moeda",                   "Moeda"                 ,                                        .F.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "'US$'",                               ".T.",                       "", "EE7_MOEDA " } })
    aAdd(aMolds, { { "Calcem",                  "Calcem"                ,                                        .F.,  "C",  01,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                          "'1'",                               ".T.",                       "", "EE7_CALCEM" } })
    aAdd(aMolds, { { "Via",                     "Via"                   ,                                        .T.,  "C",  02,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE7_VIA   " } })

    aAdd(aMolds, { { "Origem",                  "Origem"                ,                                        .T.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE7_ORIGEM" } })
    aAdd(aMolds, { { "Destino",                 "Destino"               ,                                        .T.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE7_DEST  " } })

    // Itens
    aAdd(aMolds, { { "Sequen",                  "Sequencial"            ,                                        .F.,  "C",  06,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                              "PadL(SB1->B1_COD, 15)",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                     "PadL(cValToChar(_w1),06)",                               ".T.",                       "", "EE8_SEQUEN" } })
    aAdd(aMolds, { { "Item Code",               "Cod Produto"           ,                                        .T.,  "C",  15,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                              "PadL(SB1->B1_COD, 15)",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,              "Eval({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(_cFilSB1 + PadR(xDado,15))) })",                                                  "SB1->B1_COD",                               ".T.",                       "", "EE8_COD_I " } })
    aAdd(aMolds, { { "Desc",                    "Desc Produto"          ,                                        .F.,  "C",  40,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                              "PadL(SB1->B1_COD, 15)",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                           "SB1->(!EOF())",                                        "PadR(SB1->B1_DESC,40)",                               ".T.",                       "", "EE8_VM_DES" } })
    aAdd(aMolds, { { "Qty",                     "Saldo Inicial/Qtde"    ,                                        .T.,  "N",  12,  03, "@E 9,999,999.99" }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                   "Val(xDado)",                               ".T.",                       "", "EE8_SLDINI" } })
    aAdd(aMolds, { { "Embalagem",               "Embalagem"             ,                                        .F.,  "C",  20,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                       "'CX-008              '",                               ".T.",                       "", "EE8_EMBAL1" } })
    aAdd(aMolds, { { "Qtde Embalagem",          "Quantidade Embalagem"  ,                                        .F.,  "N",  05,  03, "@E 9,999,999.99" }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                   "SB1->B1_QE",                               ".T.",                       "", "EE8_QE    " } })
    aAdd(aMolds, { { "Preco",                   "Preco Unitario"        ,                                        .F.,  "N",  14,  07, "@E 9,999,999.9999999" }, {             "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,  "SA1->(!EOF()) .And. !Empty(SA1->A1_XTABEEC) .And. DA1->(DbSeek( _cFilDA1 + SA1->A1_XTABEEC + SB1->B1_COD))",                          "DA1->DA1_PRCVEN",                               ".T.",                       "", "EE8_PRECO " } })
    aAdd(aMolds, { { "Peso Liquido",            "Peso Liquido"          ,                                        .F.,  "N",  12,  08, "@E 999.99999999" }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                 "SB1->B1_PESO",                               ".T.",                       "", "EE8_PSLQUN" } })
    aAdd(aMolds, { { "Requested Delivery Date", "Data Entrega"          ,                                        .T.,  "D",  08,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                  "CtoD(xDado)",                               ".T.",                       "", "EE8_DTENTR" } })
    aAdd(aMolds, { { "TES",                     "TES"                   ,                                        .F.,  "C",  03,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "'676'",                               ".T.",                       "", "EE8_TES   " } })
    aAdd(aMolds, { { "NCM",                     "NCM"                   ,                                        .F.,  "C",  10,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                           "SB1->(!EOF())",                                               "SB1->B1_POSIPI",                               ".T.",                       "", "EE8_POSIPI" } })

    aAdd(aMolds, { { "Numero PO",               "Numero PO"             ,                                        .T.,  "C",  15,  00, ""                }, {                  "_",                                                           ".T.",                                                                                                                                                                                              "xDado",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                        "xDado",                               ".T.",                       "", "EE8_XPOCLI" } })


EndIf
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Pedidos Exportacao)... Sucesso!", "", "", 80, "OK")
		Sleep(100)
	Next
EndIf
Return aMolds

Static Function fAbrir(cExt)
Local cType := "Arquivo | " + cExt + "|"
Local cArq := ""
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo para importar"),0,,.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY)
If Empty(cArq)
	cArqRet := ""
Else
	cArqRet := cArq
EndIf
Return cArqRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ IncAP100 บAutor ณ Jonathan Schmidt Alves บData ณ11/04/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preparacao e processamento do ExecAuto EECAP100 para a     บฑฑ
ฑฑบ          ณ geracao do Pedido de Exportacao (EE7/EE8).                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function IncAP100()
Local _w1
Local _w2
// Montagem
Local nOpc := 3
Local aCabPed := {}
Local aItens := {}
Local aItem := {}
// Auxiliares
Local cPedido := Space(20)
Local cImport := Space(06)
Local cImLoja := Space(02)
Local cImpoDe := Space(40)
Local cFornec := Space(06)
Local cFoLoja := Space(02)
Local cIdioma := Space(20)
Local cCondPa := Space(05)
Local cMsgExp := Space(03)
Local cIncote := Space(03)
Local cFrppcc := Space(03)
Local cMoeda := Space(03)
Local cCalCem := Space(01)
Local cVia := Space(03)

Local cOrigem := Space(03)
Local cDest := Space(03)

Local nFnd := 0
Local lVld := .T.
Private lMsErroAuto  := .F.
Private lMsHelpAuto  := .T.

// Avaliando dados para integracao
If Len( oGetD1:aCols ) < 1 // Nao ha dados
    MsgStop("Nenhum registro para processamento identificado!" + Chr(13) + Chr(10) + ;
    "Verifique os dados carregados e tente novamente!","IncAP100")
    lVld := .F.
ElseIf ASCan( oGetD1:aCols, {|x|, Left(x[ nP01CodSta ],1) <> "3" }) > 0 // Algum elemento nao esta ok para processamento
    MsgStop("Registro com problemas identificado!" + Chr(13) + Chr(10) + ;
    "O processamento nao pode ser realizado!","IncAP100")
    lVld := .F.
ElseIf (nFnd := ASCan(oGetD1:aCols, {|x|, !Empty(x[ nP01Pedido ]) })) == 0 // Inclusao
    nOpc := 3 // 3=Inclusao
    If ASCan(oGetD1:aCols, {|x|, !Empty(x[ nP01Pedido ]) }) > 0
        MsgStop("Planilha possui dados para inclusao/alteracao!" + Chr(13) + Chr(10) + ;
        "O processamento deve ser de inclusao ou de alteracao!" + Chr(13) + Chr(10) + ;
        "Verifique os dados carregados e tente novamente!","IncAP100")
        lVld := .F.
    EndIf
Else // Alteracao
    nOpc := 4 // 4=Alteracao
    cPedido := oGetD1:aCols[ nFnd, nP01Pedido ] // Pedido alteracao
    If ASCan(oGetD1:aCols, {|x|, x[ nP01Pedido ] <> cPedido }) > 0
        MsgStop("Planilha possui dados para alteracao de mais de 1 pedido!" + Chr(13) + Chr(10) + ;
        "O processamento deve ser de alteracao de um mesmo pedido!" + Chr(13) + Chr(10) + ;
        "Verifique os dados carregados e tente novamente!","IncAP100")
        lVld := .F.
    EndIf
EndIf

If lVld // .T.=Ainda valido

    // Todos os EE7 devem ser exatamente iguais entre as linhas
    _w1 := 1
    While _w1 <= Len( oGetD1:aCols ) .And. lVld
        For _w2 := 1 To Len( oGetD1:aHeader ) // Rodo em todas as colunas
            If "EE7_" $ oGetD1:aHeader[ _w2, 02 ] // Cabecalho
                xDado := oGetD1:aCols[ _w1, _w2 ]
                If ASCan( oGetD1:aCols, {|x|, x[ _w2 ] <> xDado }, _w2 + 1, Nil) > 0 // Informacao diferente
                    MsgStop("Planilha possui dados de cabecalho divergentes!" + Chr(13) + Chr(10) + ;
                    "Dados de cabecalho do mesmo pedido devem ser exatamente iguais!" + Chr(13) + Chr(10) + ;
                    "Verifique os dados carregados e tente novamente!","IncAP100")
                    lVld := .F.
                    Exit
                EndIf
            EndIf
        Next
        _w1++
    End

    If lVld // .T.=Ainda valido

        DbSelectArea("SA1")
        SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
        DbSelectArea("SB1")
        SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
        DbSelectArea("EE7")
        EE7->(DbSetOrder(1)) // EE7_FILIAL + EE7_PEDIDO
        DbSelectArea("EE8")
        EE8->(DbSetOrder(1)) // EE8_FILIAL + EE8_PEDIDO + EE8_SEQUEN + EE8_COD_I
        DbSelectArea("EE9")
        EE9->(DbSetOrder(8)) // EE9_FILIAL + EE9_PREEMB + EE9_NCM + EE9_PRECO
        DbSelectArea("EE5")
        EE5->(DbSetOrder(1)) // EE5_FILIAL + EE5_CODEMB
        DbSelectArea("EEK")
        EEK->(DbSetOrder(1)) // EEK_FILIAL + EEK_TIPO + EEK_CODIGO + EEK_CODIGO + EEK_SEQ
        DbSelectArea("SY6")
        SY6->(DbSetOrder(1)) // Y6_FILIAL + Y6_COD + Str(Y6_DIAS_PA,3,0)
        DbSelectArea("SYJ")
        SYJ->(DbSetOrder(1)) // YJ_FILIAL + YJ_COD

        DbSelectArea("SYA")
        SYA->(DbSetOrder(1)) // YA_FILIAL + YA_CODGI

        DbSelectArea("SY9")
        SY9->(DbSetOrder(2)) // Y9_FILIAL + Y9_SIGLA

        DbSelectArea("SYQ")
        SYQ->(DbSetOrder(1)) // YQ_FILIAL + YQ_VIA
        DbSelectArea("SYR")
        SYR->(DbSetOrder(1)) // YR_FILIAL + YR_VIA + YR_ORIGEM + YR_DESTINO + YR_TIPTRAN

        If nOpc == 3 // 3=Inclusao

            cPedido := Space(20)
            nLoops := 0
            EE7->(DbSeek( _cFilEE7 + Replicate("Z",20), .T. )) // Ultimo pedido da filial
            EE7->(DbSkip( -1 ))
            If EE7->EE7_FILIAL == cFilAnt
                While EE7->(!BOF()) .And. nLoops < 10
                    If EE7->EE7_FILIAL == cFilAnt // Filial conforme
                        If Right( RTrim(EE7->EE7_PEDIDO), 3) == "/" + SubStr( DtoS(Date()), 3, 2)   // Ex: "/22"
                            cPedido := Left( EE7->EE7_PEDIDO, At("/",EE7->EE7_PEDIDO) - 1)          // Ex: "004502"
                            cPedido := StrZero( Val( cPedido ) + 1,6)                               // Ex: "004503"
                            cPedido += "/" + SubStr( DtoS(Date()), 3, 2)                            // Ex: "004503/22"
                            Exit
                        EndIf
                    EndIf
                    nLoops++
                    EE7->(DbSkip( -1 ))
                End
            EndIf
            If Empty( cPedido )
                cPedido := "000001" + "/" + SubStr( DtoS(Date()), 3, 2)                 // Ex: "000001/23"
            EndIf
            
            cImport := oGetD1:aCols[ 01, nP01Import ]                           // Importador
            cImLoja := oGetD1:aCols[ 01, nP01ImLoja ]                           // Loja do Importador
            If SA1->(DbSeek( _cFilSA1 + cImport + cImLoja ))
                cImpoDe := SA1->A1_NOME                                         // Nome do Importador
                cCodImp := SA1->A1_PAIS                                         // Codigo do Pais do Importador
            EndIf

            cFornec := oGetD1:aCols[ 01, nP01Forn   ]                           // Fornecedor
            cFoLoja := oGetD1:aCols[ 01, nP01FoLoja ]                           // Loja do Fornecedor
            If SA1->(DbSeek( _cFilSA1 + cImport + cImLoja ))
                cFornDe := SA1->A1_NOME                                         // Nome do Fornecedor
            EndIf
            
            cIdioma := oGetD1:aCols[ 01, nP01Idioma ]                           // Idioma
            cCondPa := oGetD1:aCols[ 01, nP01CondPa ]                           // Condicao de Pagamento
            If SY6->(DbSeek( _cFilSY6 + cCondPa))
                cCondPa := SY6->Y6_COD
            EndIf

            cMsgExp := oGetD1:aCols[ 01, nP01MsgExp ]                           // Modalidade Pagamento
            
            cIncote := oGetD1:aCols[ 01, nP01Incote ]                           // Incoterm
            If SYJ->(DbSeek( _cFilSYJ + cIncote ))
                cFrppcc := SYJ->YJ_FRPPCC
            EndIf

            cMoeda  := oGetD1:aCols[ 01, nP01Moeda  ]                           // Moeda
            cCalCem := oGetD1:aCols[ 01, nP01CalCem ]                           // Calculo Embalagem

            cVia := oGetD1:aCols[ 01, nP01Via    ]                              // Via localizada
            cOrigem := oGetD1:aCols[ 01, nP01Origem ]                           // Origem
            cDest := oGetD1:aCols[ 01, nP01Dest   ]                             // Destino

            aCabPed := {}
            aAdd(aCabPed,   { "EE7_FILIAL"      , cFilAnt                 , Nil })
            aAdd(aCabPed,   { "EE7_PEDIDO"      , cPedido                 , Nil }) // Sequencial automatico             Ex: "004476/22           "                  *** Branco                                                  (Com Coluna)
            aAdd(aCabPed,   { "EE7_IMPORT"      , cImport                 , Nil }) // Codigo do Importador              Ex: "098802"                                *** Importador                                              (Com Coluna)
            aAdd(aCabPed,   { "EE7_IMLOJA"      , cImLoja                 , Nil }) // Loja do Importador                Ex: "01"                                    *** Loja                                                    (Com Coluna)
            aAdd(aCabPed,   { "EE7_IMPODE"      , cImpoDe                 , Nil }) // Nome do Importador                Ex: "SCHNEIDER ELECTRIC COLOMBIA, S.A.S"    *** Nome do Importador                                      (Com Coluna Mas nao usa)
            aAdd(aCabPed,   { "EE7_FORN"        , cFornec                 , Nil }) // Fornecedor                        Ex: "005764"                                *** Fornecedor                                              (Com Coluna)
            aAdd(aCabPed,   { "EE7_FOLOJA"      , cFoLoja                 , Nil }) // Loja do Fornecedor                Ex: "05"                                    *** Loja                                                    (Com Coluna)
            aAdd(aCabPed,   { "EE7_IDIOMA"      , cIdioma                 , Nil }) // Idioma                            Ex: "INGLES-INGLES"                         *** Sempre "INGLES-INGLES" (Fixo)                           (Sem Coluna)
            aAdd(aCabPed,   { "EE7_CONDPA"      , cCondPa                 , Nil }) // Cond Pagamento                    Ex: "59   "                                 *** Payment Term                                            (Tem Coluna)
            aAdd(aCabPed,   { "EE7_MPGEXP"      , cMsgExp                 , Nil }) // Modalidade Pagamento              Ex: "003"                                   *** Deixar sempre "003" e depois vamos entender uma regra   (Sem Coluna)
            aAdd(aCabPed,   { "EE7_INCOTE"      , cIncote                 , Nil }) // Incoterm                          Ex: "EXW"                                   *** Incoterm                                                (Com Coluna)
            aAdd(aCabPed,   { "EE7_FRPPCC"      , cFrppcc                 , Nil }) // Tipo Frete                        Ex: "CC"                                    *** Deixar sempre "CC" por enquanto                         (Sem Coluna)
            
            aAdd(aCabPed,   { "EE7_PAISET"	    , cCodImp                 , Nil }) // Codigo do Pais do Importador      Ex: "158"                                   *** Conforme o pais do fornecedor                           (Sem Coluna)
            aAdd(aCabPed,   { "EE7_XTIPO"	    , "1"                     , Nil }) // Tipo                              Ex: "1"                                     *** Fixo                                                    (Sem Coluna)
            
            aAdd(aCabPed,   { "EE7_MOEDA"       , cMoeda                  , Nil }) // Moeda                             Ex: "US$"                                   *** Deixar sempre "US$"                                     (Sem Coluna)
            aAdd(aCabPed,   { "EE7_CALCEM"      , cCalCem                 , Nil }) // Calculo Embalagem                 Ex: 1=Volume 2=Quantidade                   *** Deixar sempre como 1=Volume                             (Sem Coluna)
            
            aAdd(aCabPed,   { "EE7_VIA"         , cVia                    , Nil }) // Via Transporte                    Ex: "07 "                                   *** SYQ->YQ_CODFIES Char 03                                 (Com Coluna)
            aAdd(aCabPed,   { "EE7_ORIGEM"      , cOrigem /*"VCP", "SSZ"*/, Nil }) // Origem                            Ex: "SSZ"                                   *** Origem
            aAdd(aCabPed,   { "EE7_DEST"        , cDest /*"CMX", "CTG"*/  , Nil }) // Destino                           Ex: "CTG"                                   *** Destino

            // Enviando o ATUEMB igual a S, o sistema realizarแ a integra็ใo automแtica do Embarque de Exporta็ใo.
            // aAdd(aCabPed,   { "ATUEMB"          , "S"                     , Nil })

            // Itens
            For _w1 := 1 To Len( oGetD1:aCols )
                If SB1->(DbSeek( _cFilSB1 + oGetD1:aCols[ _w1, nP01Cod_I   ] )) // Produto
                    If EE5->(DbSeek( _cFilEE5 + oGetD1:aCols[ _w1, nP01Embal1 ] )) // Embalagem
                        aAdd(aItem,     { "EE8_SEQUEN"      , Str(_w1,6)                        , Nil }) // Sequencial                        Ex: "     1", "    12", etc                 *** Sequencial                                              (Sem Coluna)
                        aAdd(aItem,     { "EE8_COD_I"       , SB1->B1_COD                       , Nil }) // Codigo Produto                    Ex: "S3B57210       "                       *** Item Code                                               (Com Coluna)
                        aAdd(aItem,     { "EE8_VM_DES"      , SB1->B1_DESC                      , Nil }) // Descricao do Produto              Ex: ?????                                   *** Puxa automatico do SB1                                  (Sem Coluna)
                        aAdd(aItem,     { "EE8_FORN"        , cFornec                           , Nil }) // Fornecedor                        Ex: "005764"                                *** Fornecedor                                              (Reaproveito do EE7)
                        aAdd(aItem,     { "EE8_FOLOJA"      , cFoLoja                           , Nil }) // Loja do Fornecedor                Ex: "05"                                    *** Loja                                                    (Reaproveito do EE7)
                        aAdd(aItem,     { "EE8_SLDINI"      , oGetD1:aCols[ _w1, nP01SldIni ]   , Nil }) // Saldo inicial                     Ex: 200.000                                 *** Qty                                                     (Com Coluna)
                        aAdd(aItem,     { "EE8_EMBAL1"      , EE5->EE5_CODEMB                   , Nil }) // Embalagem                         Ex: "S850LI              "                  *** Embalagem (A principio deixar como "CX008")             (Sem Coluna)
                        aAdd(aItem,     { "EE8_PSLQUN"      , oGetD1:aCols[ _w1, nP01PslQun ]   , Nil }) // Peso Liquido                      Ex: 0.0520000                               *** Puxar automatico                                        (Sem Coluna)
                        aAdd(aItem,     { "EE8_QE"          , oGetD1:aCols[ _w1, nP01QE     ]   , Nil }) // Quantidade Embalagem              Ex: 1.000                                   *** Deixar sempre 1                                         (Sem Coluna)
                        aAdd(aItem,     { "EE8_DTENTR"      , oGetD1:aCols[ _w1, nP01DtEntr ]   , Nil }) // Data Entrega                      Ex: 15/05/2022                              *** Requested Delivery Date                                 (Com Coluna)
                        aAdd(aItem,     { "EE8_TES"         , oGetD1:aCols[ _w1, nP01TES    ]   , Nil }) // TES                               Ex: "676"                                   *** Deixar sempre "676"                                     (Sem Coluna)
                        aAdd(aItem,     { "EE8_POSIPI"      , SB1->B1_POSIPI                    , Nil }) // NCM                               Ex: "39259090  "                            *** Automatico do produto                                   (Sem Coluna)
                        aAdd(aItem,     { "EE8_PRECO"       , oGetD1:aCols[ _w1, nP01Preco  ]   , Nil }) // Preco                             Ex: 0.3100000                               *** Deixar sempre 1 real                                    (Sem Coluna)

                        aAdd(aItem,     { "EE8_XPOCLI"      , oGetD1:aCols[ _w1, nP01XpoCli ]   , Nil }) // Numero do PO                      Ex: "4507104067     "                       *** Eh o numero do PO da Cynthia                            (Com Coluna)

                        // aAdd(aItem,     { "AUTDELETA"       , "N"                               , Nil }) // Auto Deletar
                        aAdd(aItens, aClone(aItem))
                        aItem := {}
                    EndIf
                EndIf
            Next

            // Execu็ใo Da rotina automแtica
            If MsgYesNo("Confirma geracao do Pedido de Exportacao?","StImp016")
                MsExecAuto({|x,y,z| EECAP100(x,y,z) }, aCabPed, aItens, nOpc)
                If lMsErroAuto // Erro
                    MostraErro()
                    lMsErroAuto := .F.
                Else // Sucesso
                    // Atualizacao do Numero do pedido gerado e status
                    For _w1 := 1 To Len( oGetD1:aCols )
                        If Empty(oGetD1:aCols[ _w1, nP01Pedido ])
                            oGetD1:aCols[ _w1, nP01Pedido ] := cPedido // Atualiza com o numero gerado
                            oGetD1:aCols[ _w1, nP01CodSta ] := PadR("801=Processado com sucesso!",200)
                        EndIf
                    Next
                    oGetD1:Refresh()
                    cAcao := iif( nOpc == 3 , " incluido",iif(nOpc==4," alterado"," excluido"))
                    MsgInfo("Pedido " + cAcao + " com sucesso!", "Aviso")
                EndIf
            EndIf

        EndIf
    EndIf

EndIf
Return
