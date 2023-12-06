#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ SchAcd27 บAutor ณJonathan Schmidt Alves บ Data ณ27/04/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Enderecamento de produtos conforme notas desejadas.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function SchAcd27()
Local _w1
Local _w2
// Notas Fiscais
Local aHdr01 := { "Documento", "Ser", "Nome Cli/For", "CliFor/Lj", "Data" }
Local aCls01
Local aSze01 := {          09,    03,             20,          09,     08 }
Local nPos01 := 1
// Variaveis Notas Fiscais
Local cCodPro := Space(15)
Local cNumDoc := Space(09)
Local cSerDoc := Space(03)
Local dEmiIni := CtoD("")
Local dEmiFim := CtoD("")
Local cOrigem := "SD1"
Local cArmLoc := Space(02)
// Produtos
Local aHdr02 := {}
Local aCls02
Local aTms02 := { { "PadR(AllTrim(xDado),nTam)", 05, 15 }, { "PadL(AllTrim(xDado),nTam)", 04, 10 }, { "PadR(AllTrim(xDado),nTam)", 10, 20 }, { "xDado", 02, 02 } }
Local aSze02 := {}
Local nPos02 := 1
// Variaveis Produtos
Local lProdut := .T.
// Enderecos
Local nQtdEnd := 0
Local cLocEnd := Space(TamSX3("BE_LOCALIZ")[01])
Local lEndere := .T.
Local cIteSDB := "0000"
Local cChvSDA := "SDA->DA_FILIAL + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ + SDA->DA_DOC + SDA->DA_SERIE + SDA->DA_CLIFOR + SDA->DA_LOJA"
Local cChvSDB := "SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ + SDB->DB_DOC + SDB->DB_SERIE + SDB->DB_CLIFOR + SDB->DB_LOJA"
// Troca modulo
Local nHldMod
// Consulta padrao Enderecos
Local _aHldSXB := {}
Local aHldSXB := {}
Local cF3_SBE := "SBE"
// Ajuste tamanhos
Private xDado
// Variaveis Filiais
Private _cFilSDA := xFilial("SDA")
Private _cFilSB1 := xFilial("SB1")
Private _cFilSB2 := xFilial("SB2")
Private _cFilSBE := xFilial("SBE")
Private _cFilNNR := xFilial("NNR")
Private _cFilSA1 := xFilial("SA1")
Private _cFilSA2 := xFilial("SA2")
Private _cSqlSDA := RetSqlName("SDA")
// Abertura das tabelas
DbSelectArea("SDA")
SDA->(DbSetOrder(1)) // DA_FILIAL + DA_PRODUTO + DA_LOCAL + DA_NUMSEQ + DA_DOC + DA_SERIE + DA_CLIFOR + DA_LOJA
DbSelectArea("SDB")
SDB->(DbSetOrder(1)) // DB_FILIAL + DB_PRODUTO + DB_LOCAL + DB_NUMSEQ + DB_DOC + DB_SERIE + DB_CLIFOR + DB_LOJA + DB_ITEM
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("SBE")
SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + B2_LOCALIZ
DbSelectArea("NNR")
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
While .T.
    VTCLEARBUFFER()
    VTCLEAR
    // #########################
    // ####### PRODUTO #########
    // #########################
    VTCLEARBUFFER()
    VTCLEAR
    @00,00 VTSAY "Produto?"
    @01,00 VTGET cCodPro            PICT "@!" Valid VldPro27(@cCodPro) F3 "SB1" // Validacao do Produto
    VTREAD
    If VTLastKey() == 27
        If CBYesNo("Confirma saida?",".:AVISO:.",.T.)
            Exit
        EndIf
    EndIf
    VTAlert("Carregando Notas Fiscais... Aguarde...","[-]",.T.,1500)
    aRegsSDA := SaldoSDA( cCodPro, cNumDoc, cSerDoc, dEmiIni, dEmiFim, cOrigem, cArmLoc ) // Carregamento de registros SDA
    If Len(aRegsSDA) > 0 // Dados carregados
        While .T.
            // #########################
            // ##### NOTAS FISCAIS #####
            // #########################
            VTCLEARBUFFER()
            VTCLEAR
            aCls01 := {}
            For _w1 := 1 To Len( aRegsSDA ) // Rodo nas notas
                //           {              Doc,            Serie,               Nome CliFor,                                 Clifor/Lj,                   Data }
                //           {                01,              02,                        03,                                        04,                     05 }
                aAdd(aCls01, { aRegsSDA[_w1,02], aRegsSDA[_w1,03], Left(aRegsSDA[_w1,06],20), aRegsSDA[_w1,04] + "/" + aRegsSDA[_w1,05], DtoC(aRegsSDA[_w1,07]) })
            Next
            nPos01 := VTaBrowse(,,,,aHdr01, aCls01, aSze01, "u_ProcItem()", nPos01)
            If nPos01 > 0 // Executa Selecao da linha
                lProdut := .T.
                While lProdut
                    // #########################
                    // ######## PRODUTOS #######
                    // #########################
                    VTCLEARBUFFER()
                    VTCLEAR
                    aCls02 := {}
                    For _w1 := 1 To Len( aRegsSDA[ nPos01, 20 ] ) // Rodo nos produtos
                        //           {                    Produto,                                              Saldo,                           Descricao,                    Armazem }
                        //           {                         01,                                                 02,                                  03,                         04 }
                        aAdd(aCls02, { aRegsSDA[nPos01,20,_w1,01], TransForm(aRegsSDA[nPos01,20,_w1,04],"9999999.99"), Left(aRegsSDA[nPos01,20,_w1,02],20), aRegsSDA[nPos01,20,_w1,03] })
                    Next
                    // Adequacao de tamanhos
                    aSze02 := {}
                    aHdr02 := { "Cod Produto", "Saldo", "Descricao", "Arm" }
                    For _w1 := 1 To Len( aTms02 ) // Rodo em cada coluna
                        nTam := aTms02[ _w1, 02 ] // Tamanho minimo
                        For _w2 := 1 To Len( aCls02 ) // Rodo em todas as linhas
                            nTam := Max( Len(AllTrim( aCls02[ _w2, _w1 ])), nTam )      // Tamanho do dado ou menor tamanho permitido
                        Next
                        nTam := Min( nTam, aTms02[ _w1, 03 ] ) // No maximo o tamanho maximo
                        // Tamanho da coluna recalculado
                        For _w2 := 1 To Len( aCls02 )
                            xDado := aCls02[_w2,_w1]
                            aCls02[_w2,_w1] := &(aTms02[ _w1, 01 ])
                        Next
                        aAdd(aSze02, nTam) // Tamanho do Header
                        aHdr02[_w1] := Left( aHdr02[_w1], nTam ) // Tamanho do texto
                    Next
                    nPos02 := VTaBrowse(,,,,aHdr02, aCls02, aSze02, "u_ProcItem()", nPos02)
                    If nPos02 > 0 // Executa Selecao da linha
                        lEndere := .T.
                        nQtdEnd := Val(aCls02[ nPos02, 02 ]) // Saldo total a enderecar
                        While lEndere
                            // #########################
                            // ####### ENDERECOS #######
                            // #########################
                            cF3_SBE := "SBE"
                            cArmNNR := aCls02[ nPos02, 04 ]
                            If NNR->(DbSeek( _cFilNNR + aCls02[ nPos02, 04 ] ))
                                cArmNNR := NNR->NNR_CODIGO + " " + RTrim(NNR->NNR_DESCRI)
                                DbSelectArea("SXB")
                                SXB->(DbSetOrder(1)) // XB_ALIAS + XB_TIPO + ...
                                If SXB->(!DbSeek( PadR("SBEACD", Len( SXB->XB_ALIAS) ))) // Consulta padrao ainda nao existe
                                    If SXB->(DbSeek( PadR("SBE", Len( SXB->XB_ALIAS) )))
                                        aStruct := SXB->(DbStruct())
                                        aHldSXB := {}
                                        While SXB->(!EOF()) .And. SXB->XB_ALIAS == PadR("SBE", Len( SXB->XB_ALIAS) )
                                            _aHldSXB := {}
                                            For _w1 := 1 To Len( aStruct )
                                                aAdd(_aHldSXB, &(aStruct[ _w1, 01 ]))
                                            Next
                                            aAdd(aHldSXB, aClone( _aHldSXB))
                                            SXB->(DbSkip())
                                        End
                                        If Len( aHldSXB ) > 0 // SXB Carregado
                                            For _w1 := 1 To Len( aHldSXB )
                                                RecLock("SXB",.T.)
                                                For _w2 := 1 To Len( aHldSXB[ _w1 ] )
                                                    &(aStruct[ _w2, 01 ]) := aHldSXB[ _w1, _w2 ]
                                                Next
                                                SXB->XB_ALIAS := "SBEACD"
                                                SXB->(MsUnlock())
                                            Next
                                            If SXB->XB_TIPO == "6" // Filtro (Amarro com a NNR)
                                                RecLock("SXB",.F.)
                                                SXB->XB_CONTEM := "NNR->NNR_CODIGO == SBE->BE_LOCAL"
                                                SXB->(MsUnlock())
                                            EndIf
                                            cF3_SBE := "SBEACD"
                                        EndIf
                                    EndIf
                                Else
                                    cF3_SBE := "SBEACD"
                                EndIf
                            EndIf
                            VTCLEARBUFFER()
                            VTCLEAR
                            @00,00 VTSAY PadR("Produto: " + aCls02[ nPos02, 03 ],VTMaxCol())        // Descricao do Produto
                            @01,00 VTSAY PadR("Armazem: " + cArmNNR,VTMaxCol())                     // Codigo e Descricao do Armazsem
                            @02,00 VTSAY "Qtde:"
                            @03,00 VTGET nQtdEnd            PICT "@E 9999999.99" Valid VldQtd27( nQtdEnd, Val(aCls02[ nPos02, 02 ]) ) // Validacao do Endereco no armazem
                            @04,00 VTSAY "Endereco?"
                            @05,00 VTGet cLocEnd            PICT "@!" Valid VldEnd27(aCls02[ nPos02, 04 ], @cLocEnd) F3 cF3_SBE // Validacao do Endereco no armazem
                            VTREAD
                            If VTLastKey() == 27 // Esc
                                Exit
                            EndIf
                            lEndere := !CBYesNo("Confirma enderecamento do item?",".:AVISO:.",.T.)
                        End
                        If !lEndere // .F.=Enderecar .T.=Continuar no loop
                            // Reposiciono SDA
                            SDA->(DbGotop())
                            SDA->(DbGoTo( aRegsSDA[ nPos01, 20, nPos02, 10 ] ))
                            // Item SDB
                            cIteSDB := "0000"
                            SDB->(DbSetOrder(1)) // DB_FILIAL + DB_PRODUTO + DB_LOCAL + DB_NUMSEQ + DB_DOC + DB_SERIE + DB_CLIFOR + DB_LOJA + DB_ITEM
                            If SDB->(DbSeek( &(cChvSDA) ))
                                While SDB->(!EOF()) .And. &(cChvSDA) == &(cChvSDB)
                                    cIteSDB := SDB->DB_ITEM
                                    SDB->(DbSkip())
                                End
                            EndIf
                            cIteSDB := Soma1(cIteSDB,4)
                            nHldMod := nModulo
                            nModulo := 4 // Forca o modulo de estoque
                            aCabEnd := { { "DA_PRODUTO",            SDA->DA_PRODUTO,        Nil },;
                                            { "DA_LOCAL",           SDA->DA_LOCAL,          Nil },;
                                            { "DA_NUMSEQ",          SDA->DA_NUMSEQ,         Nil },;
                                            { "DA_DOC",             SDA->DA_DOC,            Nil } }
                            aItensEnd := { { { "DB_ITEM",           cIteSDB,                Nil },;
                                            { "DB_LOCALIZ",         cLocEnd,                Nil },;
                                            { "DB_QUANT",           nQtdEnd,                Nil },;
                                            { "DB_DATA",            Date(),                 Nil } } }
                            lMsErroAuto := .F.
                            MsExecAuto({|x,y,z,w|, MATA265(x,y,z,w) }, aCabEnd, aItensEnd, 3, .T.)
                            nModulo := nHldMod
                            If lMsErroAuto // Erro
                                MostraErro()
                            Else // Sucesso
                                If nQtdEnd == aRegsSDA[ nPos01, 20, nPos02, 04 ] // Enderecando o saldo todo
                                    aDel( aRegsSDA[ nPos01, 20 ], nPos02 )
                                    aSize( aRegsSDA[ nPos01, 20 ], Len( aRegsSDA[ nPos01, 20 ] ) - 1)
                                    nPos02 := Min( Len( aRegsSDA[ nPos01, 20] ), nPos02)
                                    If Len( aRegsSDA[ nPos01, 20 ] ) == 0
                                        aDel( aRegsSDA, nPos01 )
                                        aSize( aRegsSDA, Len( aRegsSDA ) - 1)
                                        VTAlert("Carregando Notas Fiscais... Aguarde...","[-]",.T.,1500)
                                        lProdut := .F.
                                        nPos02 := 1
                                        nPos01 := Min( Len( aRegsSDA ), nPos01)
                                    EndIf
                                Else // Parcial
                                    aRegsSDA[ nPos01, 20, nPos02, 04 ] -= nQtdEnd // Subtraio qtde enderecada
                                EndIf
                            EndIf
                            VtClearGet("cLocEnd")
                        EndIf
                    ElseIf nPos02 == 0 // 0=Aborta Selecao
                        nPos02 := 1
                        Exit
                    EndIf
                End
            ElseIf nPos01 == 0 // 0=Aborta Selecao
                nPos01 := 1
                Exit
            EndIf
        End
    Else // Nenhum registro carregado na consulta
        VTAlert("Nenhum documento encontrado nos parametros!",".:AVISO:.",.T.)
    EndIf
End
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ VldPro27 บAutor ณJonathan Schmidt Alves บ Data ณ03/05/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do produto (SB1).                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Caractere especial separador:                              บฑฑ
ฑฑบ          ณ = separador China                                          บฑฑ
ฑฑบ          ณ : separador Nacional                                       บฑฑ
ฑฑบ          ณ ฆ separador Alienigena                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Exemplo: SDD61C20=51432=12                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ SDD61C20 ้ o c๓digo                                        บฑฑ
ฑฑบ          ณ 51432 ้ o lote                                             บฑฑ
ฑฑบ          ณ 12 ้ a quantidade                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function VldPro27( cCodPro )
Local lRet := .T.
Local _w1
For _w1 := 1 To Len( cCodPro )
    If !IsAlpha(SubStr(cCodPro,_w1,1)) .And. !(SubStr(cCodPro,_w1,1) $ "0123456789") // Caractere nao eh Alpha nem Numero
        cCodPro := PadR(Left( cCodPro, _w1 - 1 ),15)
        Exit
    EndIf
Next
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
If SB1->(!DbSeek(_cFilSB1 + cCodPro))
    SB1->(DbSetOrder(5)) // B1_FILIAL + B1_CODBAR
	If SB1->(!DbSeek(_cFilSB1 + cCodPro))
        VTAlert("Produto nao encontrado no cadastro! " + cCodPro,"[-]",.T.,2500)
        VTClearGet("cCodPro")
        lRet := .F.
	EndIf
EndIf
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
If lRet // .T.=Produto localizado
    cCodPro := SB1->B1_COD
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ VldQtd27 บAutor ณJonathan Schmidt Alves บ Data ณ03/05/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao da quantidade a enderecar.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function VldQtd27( nQtdEnd, nQtdSDA )
Local lRet := .T.
If nQtdEnd <= 0 .Or. nQtdEnd > nQtdSDA
    VTAlert("Quantidade invalida!","[-]",.T.,1500)
    lRet := .F.
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ VldEnd27 บAutor ณJonathan Schmidt Alves บ Data ณ27/04/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do Endereco (SBE).                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Inicia do 3ro caractere                                    บฑฑ
ฑฑบ          ณ A123: 03A123                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function VldEnd27( cLocArm, cLocEnd )
Local lRet := .T.
SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + B2_LOCALIZ
If Left(cLocEnd,2) == "03"
    cLocEnd := PadR(SubStr(cLocEnd,3,15),15)
    If SBE->(!DbSeek(_cFilSBE + cLocArm + cLocEnd))
        VTAlert("Endereco nao encontrado no cadastro para este armazem!","[-]",.T.,1500)
        VtClearGet("cLocEnd")
        lRet := .F.
    EndIf
ElseIf SBE->(!DbSeek(_cFilSBE + cLocArm + cLocEnd))
    VTAlert("Endereco nao encontrado no cadastro para este armazem!","[-]",.T.,1500)
    VtClearGet("cLocEnd")
    lRet := .F.
EndIf
If lRet // .T.=Endereco encontrado
    cLocEnd := SBE->BE_LOCALIZ
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ProcItem บAutor ณJonathan Schmidt Alves บ Data ณ27/04/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento de teclas no VTaBrowse.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ProcItem(nModo, nElem, nElemW)
If nModo == 1 // Topo da lista
    VTBeep(3)
Elseif nModo == 2 // Fim da lista
    VTBeep(3)
Else
    If VTLastkey() == 27 // Esc
        VTBeep(3)
        Return 0 // 0=Aborta selecao
    ElseIf VTLastkey() == 13 // Enter
        VtBeep(1)
        Return 1 // 1=Executa selecao
    Endif
EndIf
Return 2 // 2=Continua VtaBrowse

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ SaldoSDA บAutor ณJonathan Schmidt Alves บ Data ณ27/04/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta dos registros com saldo SDA                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SaldoSDA( cCodPro, cNumDoc, cSerDoc, dEmiIni, dEmiFim, cOrigem, cArmLoc )
Local cQrySDA := ""
Local nRecsSDA := 0
Local aRegsSDA := {}
Local cNomClf := Space(10)
cQrySDA	:= "SELECT R_E_C_N_O_ "
cQrySDA	+= "FROM " + _cSqlSDA + " SDA "
cQrySDA	+= "WHERE "
cQrySDA	+= "DA_FILIAL = '" + _cFilSDA + "' AND "            // Filial conforme
If !Empty( cCodPro )
    cQrySDA += "DA_PRODUTO = '" + cCodPro  + "' AND "       // Filtra produto
EndIf
If !Empty( cArmLoc )
    cQrySDA += "DA_LOCAL = '" + cArmLoc + "' AND "          // Filtra armazem da nota fiscal
EndIf
If !Empty( cNumDoc )
    cQrySDA += "DA_DOC = '" + cNumDoc + "' AND "            // Filtra documento da nota fiscal
EndIf
If !Empty( cSerDoc )
    cQrySDA += "DA_SERIE = '" + cSerDoc + "' AND "          // Filtra serie da nota fiscal
EndIf
cQrySDA	+= "DA_ORIGEM = '" + cOrigem + "' AND "             // Origem "SD1"=Nota Fiscal "SD3"=Movimentos
cQrySDA	+= "DA_SALDO > 0 AND "                              // Saldo pendente
cQrySDA	+= "D_E_L_E_T_ = ' ' "                              // Nao apagado
cQrySDA	+= "ORDER BY DA_DOC + DA_SERIE"                     // Ordenado por DOC + SERIE
cQrySDA	:= ChangeQuery(cQrySDA)
If Select("QRYSDA") > 0
    QRYSDA->(DbCloseArea())
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySDA),"QRYSDA", .F., .T.)
Count To nRecsSDA
If nRecsSDA > 0 // Registros encontrados
    QRYSDA->(DbGoTop())
    While QRYSDA->(!EOF())
        SDA->(DbGoto( QRYSDA->R_E_C_N_O_ ))
        SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
        If SB1->(DbSeek(_cFilSB1 + SDA->DA_PRODUTO))
            cNomClf := Space(20)
            If SDA->DA_TIPONF $ "D/B/"
                SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
                If SA1->(DbSeek(_cFilSA1 + SDA->DA_CLIFOR + SDA->DA_LOJA))
                    cNomClf := SA1->A1_NREDUZ
                EndIf
            Else
                SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
                If SA2->(DbSeek(_cFilSA2 + SDA->DA_CLIFOR + SDA->DA_LOJA))
                    cNomClf := SA2->A2_NREDUZ
                EndIf
            EndIf
            If (nPos := ASCan(aRegsSDA, {|x|, x[01] + x[02] + x[03] == SDA->DA_FILIAL + SDA->DA_DOC + SDA->DA_SERIE })) == 0 // Documento/Serie ainda nao considerado
                //             {             01,          02,            03,             04,           05,      06,           07,             08,                  20 }
                aAdd(aRegsSDA, { SDA->DA_FILIAL, SDA->DA_DOC, SDA->DA_SERIE, SDA->DA_CLIFOR, SDA->DA_LOJA, cNomClf, SDA->DA_DATA, SDA->DA_TIPONF,,,,,,,,,,,, Array(0) })
                nPos := Len(aRegsSDA)
            EndIf
            //                      {          01,           02,            03,            04,,,,,,             10 }
            aAdd(aRegsSDA[nPos,20], { SB1->B1_COD, SB1->B1_DESC, SDA->DA_LOCAL, SDA->DA_SALDO,,,,,, SDA->(Recno()) })
        EndIf
        QRYSDA->(DbSkip())
    End
EndIf
QRYSDA->(DbCloseArea())
Return aRegsSDA
