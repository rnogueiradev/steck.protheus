#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchMrp15 ºAutor ³Jonathan Schmidt Alvesº Data ³ 26/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de exportacao de dados do calculo do MRP para .CSV  º±±
±±º          ³                                                            º±±
±±º          ³ Funcionamento:                                             º±±
±±º          ³ Esta funcao devera ser chamada sempre que for necessaria a º±±
±±º          ³ exportacao de resultados do calculo MRP para planilha com  º±±
±±º          ³ possibilidade de manipulacao de dados e recarregamento.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Tipos de Registro:                                         º±±
±±º          ³ 					1 Saldo Inicial                           º±±
±±º          ³ 					2 Entrada                                 º±±
±±º          ³ 					3 Saida                                   º±±
±±º          ³ 					4 Saida pela Estrutura                    º±±
±±º          ³ 					5 Saldo                                   º±±
±±º          ³ 					6 Necessidade                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchMrp15(nMsgPr)
If nMsgPr == 2 // 2=AskYesNo
    u_AskYesNo(3500,"Processando","Carregando dados para a planilha...","Carregando...","","","","PROCESSA",.T.,.F.,{|| aRcTab := LoadsMRP( nMsgPr ) })
Else
    aRcTab := LoadsMRP( nMsgPr )
EndIf
Return

Static Function LoadsMRP( nMsgPr )
Local _w1 ; Local _z1
Local nFind1
Local nFind2
Local nFind3
Local aRcTab := {}
Local nRecTmp := 0
Local cArqTmp := ArqTmp15() // Arquivo temporario resultado
Local nLastUpdate := Seconds()
Private _cFilSB1 := xFilial("SB1")
Private _cFilSBM := xFilial("SBM")
Private _cFilSA2 := xFilial("SA2")
Private nTamB1Cod := TamSX3("B1_COD")[01]
Private aDados := {}
Private aMolds := {}
// Parte 01: Carregamento de dados do arquivo temporario para aDados
If !Empty(cArqTmp) // Arquivo temporario identificado
    (cArqTmp)->(DbGotop())
    If nMsgPr == 2 // 2=AskYesNo
        _oMeter:nTotal := (cArqTmp)->(RecCount())
        cTotTmp := cValToChar(_oMeter:nTotal)
        For _z1 := 1 To 4
            u_AtuAsk09(nCurrent,"Carregando dados para a planilha...","Carregando...", "", "", 80, "PROCESSA")
            Sleep(050)
        Next
    EndIf
    (cArqTmp)->(DbGotop())
    While (cArqTmp)->(!EOF())
        For _w1 := 1 To Len(aPeriodos)
            If (nFind1 := ASCan(aDados, {|x|, x[ 01 ] == (cArqTmp)->PRODUTO })) > 0 // Produto ja existe..
                If (nFind2 := ASCan(aDados[ nFind1, 02 ], {|x|, x[01] == (cArqTmp)->TIPO })) > 0 // Tipo ja existe...
                    If (nFind3 := ASCan(aDados[ nFind1, 02, nFind2, 03 ], {|x|, x[01] == aPeriodos[_w1] })) > 0 // Periodo ja existe...
                        //                                             {    02.??.03.01,                           02.??.03.02 }
                        aAdd(aDados[ nFind1, 02, nFind2, 03, nFind3 ], { aPeriodos[_w1], &(cArqTmp + "->PER" + StrZero(_w1,3)) })
                    Else // Periodo ainda nao existe, crio o periodo e o valor
                        //                                     {    02.??.03.01,                           02.??.03.02 }
                        aAdd(aDados[ nFind1, 02, nFind2, 03 ], { aPeriodos[_w1], &(cArqTmp + "->PER" + StrZero(_w1,3)) })
                    EndIf
                Else // Tipo ainda nao existe
                    //                         {        02.??.01,         02.??.02, { {    02.??.03.01,                           02.??.03.02 } } }
                    aAdd(aDados[ nFind1, 02 ], { (cArqTmp)->TIPO, (cArqTmp)->TEXTO, { { aPeriodos[_w1], &(cArqTmp + "->PER" + StrZero(_w1,3)) } } })
                EndIf
            Else // Cria novo
                //           {                 01, { {        02.??.01,         02.??.02, { {    02.??.03.01,                           02.??.03.02 } } } } }
                aAdd(aDados, { (cArqTmp)->PRODUTO, { { (cArqTmp)->TIPO, (cArqTmp)->TEXTO, { { aPeriodos[_w1], &(cArqTmp + "->PER" + StrZero(_w1,3)) } } } } })
            EndIf
        Next
        ++nRecTmp
        If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a última atualização da tela
            nLastUpdate := Seconds()
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"Carregando dados para a planilha...","Carregando...", "Registro: " + cValToChar(nRecTmp) + " / " + cTotTmp, "", 80, "PROCESSA")
                Sleep(050)
            Next
        EndIf
        (cArqTmp)->(DbSkip())
    End
EndIf
// Parte 02: Carregando dos posicionamentos aRcTab a partir da aDados
If Len(aDados) > 0
    If nMsgPr == 2 // 2=AskYesNo
        For _z1 := 1 To 4
            u_AtuAsk09(nCurrent,"Carregando dados para a planilha...","Carregando... Concluido!", "", "", 80, "OK")
            Sleep(100)
        Next
    EndIf
    // Parte 03: Processando aRcTab
    aRcTab := LoadRecs()
    If Len(aRcTab[01,02]) > 0 // Dados carregados
        // Chamada mestre de processamento (MntMolds, LoadDads e GrvDados serao chamados nesse disparo)
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"Processando dados para a planilha...","Processando...", "", "", 80, "PROCESSA")
                Sleep(100)
            Next
        EndIf
        u_SchMrp17(nMsgPr, aRcTab)
    EndIf
EndIf
Return

Static Function ArqTmp15() // Identificacao do arquivo temporario montado no MATA712
Local _w1 := 1
Local _w2 := 20
Local _w3
Local aTabs := {}
Local cArqTmp := ""
Local aCampos := { "TIPO", "TEXTO", "PRODSHOW", "OPCSHOW", "REVSHOW" }
Local aArea := GetArea()
While !Empty(Alias(_w1))
    aAdd(aTabs, Alias(_w1++))
End
While --_w1 > 0 .And. _w2 > 0
    If Len(aTabs[ _w1 ]) > 3 .And. Left(aTabs[ _w1 ],2) == "SC" // Arquivo temporario
        DbSelectArea(aTabs[_w1])
        aStruct := DbStruct() // Estrutura do arquivo
        lVld := .T.
        For _w3 := 1 To Len(aCampos)
            If ASCan(aStruct, {|x|, x[01] == aCampos[_w3] }) == 0 // Nao achou campo
                lVld := .F.
                Exit
            EndIf
        Next
        If lVld // .T.=Valido
            cArqTmp := aTabs[_w1]
            Exit
        EndIf
    EndIf
    _w2--
End
RestArea(aArea)
Return cArqTmp

Static Function LoadRecs() // Montador aRcTab
Local _w1
Local aRcTab := { { "SB1", Array(0) }, { "SBM", Array(0) }, { "SA2", Array(0) } }
Local aRetRegra := {}
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILAIL + A2_COD + A2_LOJA
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
For _w1 := 1 To Len(aDados)
    If SB1->(DbSeek(_cFilSB1 + aDados[_w1,01]))
        aAdd(aRcTab[01,02], SB1->(Recno()))
        If !Empty(SB1->B1_GRUPO)
            If SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO))
                aAdd(aRcTab[02,02], SBM->(Recno()))
            EndIf
        Else // Sem Grupo
            aAdd(aRcTab[02,02], 0)
        EndIf
        // Posicionamento SA2 conforme Regras
        SA2->(DbGoto(0)) // Desposiciono
        aRetRegra := u_FndRegra( SB1->B1_COD )
        If aRetRegra[01] $ "01/02/" .And. !Empty(aRetRegra[02])
            If SA2->(DbSeek( _cFilSA2 + aRetRegra[02] + aRetRegra[03] ))
                aAdd(aRcTab[03,02], SA2->(Recno()))
            Else // Sem fornecedor identificado
                aAdd(aRcTab[03,02], 0)
            EndIf
        Else // Sem fornecedor identificado
            aAdd(aRcTab[03,02], 0)
        EndIf
    EndIf
Next
Return aRcTab

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ FndRegra ºAutor ³Jonathan Schmidt Alvesº Data ³ 24/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de identificacao da regra para o produto.           º±±
±±º          ³                                                            º±±
±±º          ³ Regra 01: Fabricacao Guararema SP                          º±±
±±º          ³ B1_CLAPROD == "F"                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 02: Fabricacao Manaus AM                             º±±
±±º          ³ B1_CLAPROD == "C" .And. B1_PROC == "005866"                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 03: Importacao                                       º±±
±±º          ³ B1_CLAPROD == "I"                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Regra 04: Compra Centro de Distribuicao                    º±±
±±º          ³ "C" na empresa "01" e "C" tambem na "03" -> Comprado       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Tipos de Registro:                                         º±±
±±º          ³ 					1 Saldo Inicial                           º±±
±±º          ³ 					2 Entrada                                 º±±
±±º          ³ 					3 Saida                                   º±±
±±º          ³ 					4 Saida pela Estrutura                    º±±
±±º          ³ 					5 Saldo                                   º±±
±±º          ³ 					6 Necessidade                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FndRegra(cCodPro)
Local aArea := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local cCRegra := Space(02)
Local cCodFor := Space(06)
Local cLojFor := Space(02)
Local cNomFor := Space(40)
Local cQrySB1_03 := ""
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
If SB1->(DbSeek(_cFilSB1 + cCodPro))
    If SB1->B1_CLAPROD == "F"           // Fabricacao Guararema SP
        cCRegra := "01"                 // Regra 01: Fabricacao Guararema SP
        cCodFor := "005764"             // Codigo Fornecedor
        cLojFor := "05"                 // Loja Fornecedor
    ElseIf SB1->B1_CLAPROD == "C" .And. SB1->B1_PROC == "005866"        // Fabricacao Manaus AM
        cCRegra := "02"                                                 // Regra 02: Fabricacao Manaus AM
        cCodFor := "005866"                                             // Codigo Fornecedor
        cLojFor := "01"                                                 // Loja Fornecedor
    ElseIf SB1->B1_CLAPROD == "I"       // Importacao
        cCRegra := "03"                 // Regra 03: Importacao
        cCodFor := SB1->B1_PROC                                         // Codigo Fornecedor
        cLojFor := Iif( !Empty(SB1->B1_LOJPROC), SB1->B1_LOJPROC, "")   // Loja Fornecedor
    ElseIf SB1->B1_CLAPROD == "C"       // Compra Centro de Distribuicao
        cQrySB1_03 := "SELECT B1_COD, B1_CLAPROD "
        cQrySB1_03 += "FROM " + "SB1030" + " WHERE "
        cQrySB1_03 += "B1_COD = '" + SB1->B1_COD + "' AND "
        cQrySB1_03 += "D_E_L_E_T_ = ' '"
        If Select("TRBSB1_03") > 0
            TRBSB1_03->(DbCloseArea())
        EndIf
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySB1_03),"TRBSB1_03",.F.,.F.)
        If TRBSB1_03->(!EOF())
            If TRBSB1_03->B1_CLAPROD == "C"
                cCRegra := "04"                                 // Regra 04: Compra Centro de Distribuicao
            EndIf
        Else // Se nao encontrar
            cCRegra := "04"                                     // Regra 04: Compra Centro de Distribuicao
        EndIf
        TRBSB1_03->(DbCloseArea())
    EndIf
    // Validacao do fornecedor no ambiente
    If !Empty( cCodFor )
        DbSelectArea("SA2")
        SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
        If SA2->(DbSeek(_cFilSA2 + cCodFor + cLojFor))
            cLojFor := SA2->A2_LOJA
            cNomFor := SA2->A2_NREDUZ
        Else // Fornecedor invalido
            cCRegra := Space(02)
            cCodFor := Space(06)
            cLojFor := Space(02)
        EndIf
    EndIf
EndIf
RestArea(aAreaSA2)
RestArea(aAreaSB1)
RestArea(aArea)
Return { cCRegra, cCodFor, cLojFor, cNomFor }
