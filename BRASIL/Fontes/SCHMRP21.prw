#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchMrp21 ºAutor ³Jonathan Schmidt Alvesº Data ³ 03/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de importacao de dados do calculo do MRP modificado   º±±
±±º          ³ ou aprovacao dos dados ja importados.                      º±±
±±º          ³                                                            º±±
±±º          ³ Funcionamento:                                             º±±
±±º          ³ Esta funcao devera ser chamada sempre que for necessaria a º±±
±±º          ³ importacao de resultados do calculo MRP de planilha com    º±±
±±º          ³ valores modificados ou quando usuario aprovador desejar    º±±
±±º          ³ aprovar ou reprovar dados recarregados apos recalculos.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchMrp21()
Local _w1
Local _w2
Local nMsgPr := 2 // 2=AskYesNo
Local cTitDlg := "SchMrp21: Recalculo MRP"
// Usuario logado
Private cCodUsr := RetCodUsr()
// Usuarios aprovadores recalculo MRP
Private cUsrApr := SuperGetMv("ST_USRMRP1",.F.,"")  // 000000/001334/001478 Administrador/Fernanda/jonathan.sigamat
Private lUsrApr := .F.
Private cStaPad := Space(02)
Private cGetCodLog := cCodUsr
Private cGetNomLog := UsrRetName(cCodUsr)
Private cAccessUsr := ""
// Variaveis linhas objetos
Private nLineZG1 := 1
Private nHoldZG1 := 1
Private nLineZG2 := 1
Private nLineZG3 := 1
Private nLineZG4 := 1
// ToolTips GetDados 4
Private aTtipZG2 := {}
Private aTtipZG3 := {}
Private aTtipZG4 := {}
// Variaveis filiais
Private _cFilSB1 := xFilial("SB1")
Private _cFilSBM := xFilial("SBM")
Private _cFilSA2 := xFilial("SA2")
Private _cFilZRP := xFilial("ZRP")
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
Private oGetD2
Private oPnlGd1
Private oPnlGd2
Private oPnlGd3
Private oPnlBot
// Variaveis Objetos
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
Private aButtons := {}
Private aHdr02 := {}
Private aCls02 := {}
Private aFldsAlt02 := {}
Private aHdr03 := {}
Private aCls03 := {}
Private aFldsAlt03 := {}
Private aHdr04 := {}
Private aCls04 := {}
Private aFldsAlt04 := {}
// Combo MRP
Private oCmbCodMRP
Private aCmbCodMRP := { "Todos" }
Private cCmbCodMRP := "Todos"
// Check Recalculos
Private oChkStatus
Private lChkStatus := .F.
// Reprocessa Regras
Private oChkReaReg
Private lChkReaReg := .F.
// Relatorio Automatico Inconsistencias
Private oChkRelAut
Private lChkRelAut := .T.
// Radio Box Aglutinacao
Private nRadAglu := 1
Private aRadAglu := { "Fornecedor", "Grupo de Produtos", "Agrupamentos" }
// Montagem do aMolds01
Private aMolds01 := u_MntMolds("MRP", 0) //StaticCall (SCHMRP17, MntMolds, "MRP", 0)
// Montagem do aMolds02 (Aglutinacao Fornecedor)
Private aMolds02 := u_MntMolds("FOR", 0)//StaticCall (SCHMRP17, MntMolds, "FOR", 0)
// Montagem do aMolds02 (Aglutinacao Grupo Produtos)
Private aMolds03 := u_MntMolds("GRU", 0)
// Montagem do aMolds02 (Aglutinacao Agrupamento)
Private aMolds04 := u_MntMolds("AGR", 0)
ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Identificacao do acesso do usuario
lUsrApr := cCodUsr $ cUsrApr // Usuario Aprovador

//If cCodUsr $ "000000/001478/" //  Teste troca empresa/filial // Administrador/jonathan.sigamat
//    _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
//    _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
//    u_UPDEMPFIL("03","01",_aTabsSX,_aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
//EndIf

If cCodUsr $ "000000/001478/" .And. lUsrApr // Administrador/jonathan.sigamat como aprovador ou usuario normal manipulador
    lUsrApr := !u_AskYesNo(3000,"SchMrp21","Acessar como Aprovador?", "", "", "", "Sim", "UPDINFORMATION")
EndIf

cStaPad := Iif(lUsrApr, "02/03/04", "01")
If Len(aMolds01) > 0
    // Montagem dos Headers
    ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando aHeader...")
    aAdd(aHdr01,            { "Codigo",                          "ZRP_CODIGO",                   "",                 06,              00, ".F.",			  "€€€€€€€€€€€€€€ ", SX3->X3_TIPO,    "",    SX3->X3_CONTEXTO, "",                                                                                                              "" })  // ??
    DbSelectArea("SX3")
    SX3->(DbSetOrder(2)) // X3_CAMPO
    For _w1 := 1 To Len(aMolds01)
        If SX3->(DbSeek(aMolds01[_w1,03,06])) // Campo
            aAdd(aHdr01,    { aMolds01[ _w1, 01, 01 ],    aMolds01[ _w1, 03, 06 ],      SX3->X3_PICTURE,    SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F.",              "€€€€€€€€€€€€€€ ", SX3->X3_TIPO,    "",    SX3->X3_CONTEXTO, "",                                                                                                          "" })  // ??
        EndIf
    Next
    SX3->(DbSetOrder(1)) // X3_ARQUIVO + X3_ORDEM
    aAdd(aHdr01,            { "Obs Inclusao",                   "ZRP_OBSUSR",                   "",                100,              00, "u_VlObsU23()",  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })  // ??
    aAdd(aHdr01,            { "Obs Aprovacao",                  "ZRP_OBSAPR",                   "",                100,              00, "u_VlObsA23()",  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })  // ??
    aAdd(aHdr01,            { "Inclusao",                       "ZRP_LOGINC",                   "",                 30,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })  // ??
    aAdd(aHdr01,            { "Alteracao",                      "ZRP_LOGALT",                   "",                 30,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })  // ??
    aAdd(aHdr01,            { "Status",                         "ZRP_CODSTA",                   "",                 02,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "01=01: Recalculo;02=02: Aguardando Aprovacao;03=03: Reprovado;04=04: Aprovado;05=05: Processado",                   "" })  // ??
    aAdd(aHdr01,            { "Regra",                          "ZRP_CREGRA",                   "",                 02,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "01=01: Fabricacao Guararema SP;02=02: Fabricacao Manaus AM;03=03: Importacao;04=04: Compra Centro de Distribuicao", "" })  // ??
    aAdd(aHdr01,            { "Processamento 01",               "ZRP_PROC01",                   "",                100,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })
    aAdd(aHdr01,            { "Log Processamento 01",           "ZRP_LOGP01",                   "",                100,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })
    aAdd(aHdr01,            { "Processamento 02",               "ZRP_PROC02",                   "",                100,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })
    aAdd(aHdr01,            { "Log Processamento 02",           "ZRP_LOGP02",                   "",                100,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                                                                                                                  "" })
    aAdd(aHdr01,            { "Recno ZRP",                      "ZRP_RECZRP",                   "",                 06,              00, ".F.",			  "€€€€€€€€€€€€€€ ",          "N",    "",                 "R", "",                                                                                                                  "" })
    // Preparacao das posicoes do Header 01
    For _w1 := 1 To Len(aHdr01)
        &("nP01" + SubStr(aHdr01[_w1,2],5,6)) := _w1
    Next
    For _w1 := 2 To 4 // Aglutinacao por Fornecedor, Grupo e Agrupamento
        aHdr := {}
        aMld := aClone( &("aMolds" + StrZero(_w1,2)) )
        For _w2 := 1 To Len(aMld) // Montagem do Header 02, 03 e 04
            aAdd(aHdr, { aMld[_w2,01,01], aMld[_w2,03,06], aMld[_w2,01,06], aMld[_w2,01,04], aMld[_w2,01,05], ".F.", "€€€€€€€€€€€€€€ ", aMld[_w2,01,03], "", "R", "", "" })
            &("nP" + StrZero(_w1,2) + SubStr(aHdr[_w2,2],5,6)) := _w2
        Next
        &("aHdr" + StrZero(_w1,2)) := aClone( aHdr )
    Next
    ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Montando aHeader... Concluido!")
    ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo dialog...")
    DEFINE MSDIALOG oDlg01 FROM 010,165 TO 850,1490 TITLE cTitDlg Pixel
    // Panel
    oPnlGd1	:= TPanel():New(030,000,,oDlg01,,,,,nClrC22,742,210,.F.,.F.) // Panel do GetDados 01 Registros ZRP
    oPnlGd2	:= TPanel():New(240,000,,oDlg01,,,,,nClrC23,742,170,.F.,.F.) // Panel do GetDados 02 Algutinacoes
    oPnlBot	:= TPanel():New(410,000,,oDlg01,,,,,nClrC21,742,012,.F.,.F.) // Panel do Rodape
    // Codigos de importacoes
	@004,005 SAY	oSayCodMRP PROMPT "Codigo Importacao:" SIZE 080,010 OF oPnlGd1 PIXEL
	@002,060 MSCOMBOBOX oCmbCodMRP VAR cCmbCodMRP ITEMS aCmbCodMRP SIZE 050,011 OF oPnlGd1 Pixel
    oCmbCodMRP:bChange := {|| u_AskYesNo(3500,"LoadMrps","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadMrps( nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), oCmbCodMrp:nAt ) }) }
    If !lUsrApr // .F.=Usuario Manipulador
        aFldsAlt01 := { "ZRP_OBSUSR" }
        // Botao F4 Enviar para Aprovacao
        @002,260 BUTTON oBtnEnvApr PROMPT "Enviar p/ Aprovacao" SIZE 070,010 Action( ApRpPlan(nMsgPr, "02") ) Pixel Of oPnlGd1
        // Botao F9 Retornar para Recalculo
        @002,340 BUTTON oBtnRetClc PROMPT "Retornar p/ Recalculo" SIZE 070,010 Action( ApRpPlan(nMsgPr, "01") ) Pixel Of oPnlGd1
        // Botao F10 Importar Planilha
        @002,420 BUTTON oBtnImpPla PROMPT "Importar Planilha .CSV" SIZE 070,010 Action( ImpoPlan(nMsgPr) ) Pixel Of oPnlGd1
        // Botao F7 Excluir Planilha
        @002,500 BUTTON oBtnExcPla PROMPT "Excluir Planilha" SIZE 070,010 Action( ApDlPlan(nMsgPr) ) Pixel Of oPnlGd1
        // Botao F11 Processar
        @002,580 BUTTON oBtnPrcApr PROMPT "Processar" SIZE 070,010 Action( ApRpPlan(nMsgPr, "05") ) Pixel Of oPnlGd1
        // Atalhos F's
        SetKey(VK_F4,   {|| ApRpPlan(nMsgPr, "02") })   // Enviar para Aprovacao Planilha .CSV importada       "04"=Aprovar
        SetKey(VK_F9,   {|| ApRpPlan(nMsgPr, "01") })   // Retornar para Recalculo
        SetKey(VK_F10,  {|| ImpoPlan(nMsgPr) })         // Importar Planilha .CSV
        SetKey(VK_F7,   {|| ApDlPlan(nMsgPr) })         // Remover planilha
        // Helps de Atalhos
        @002,016 SAY	oSayAtaF4   PROMPT "F4 = Enviar p/ Aprovacao"       SIZE 070,010 OF oPnlBot PIXEL
        @002,106 SAY	oSayAtaF9   PROMPT "F9 = Retornar p/ Recalculo"     SIZE 070,010 OF oPnlBot PIXEL
        @002,196 SAY	oSayAtaF10  PROMPT "F10 = Importar Planilha .CSV"   SIZE 100,010 OF oPnlBot PIXEL
        @002,286 SAY	oSayAtaF7   PROMPT "F7 = Excluir Planilha"          SIZE 070,010 OF oPnlBot PIXEL
        @002,360 SAY	oSayAtaF11  PROMPT "F11 = Processar"                SIZE 070,010 OF oPnlBot PIXEL
        If RetCodUsr() $ "000000/001478/" // Admin/jonathan.sigamat
            SetKey(VK_F11,  {|| ApRpPlan(nMsgPr, "05") })   // Processamento MRP (sem os ExecAutos etc)                 "05"=Processado
        EndIf
    Else // .T.=Usuario Aprovador
        aFldsAlt01 := { "ZRP_OBSAPR" }
        // Botao F4 Aprovar
        @002,260 BUTTON oBtnAprova PROMPT "Aprovar" SIZE 070,010 Action( ApRpPlan(nMsgPr, "04") ) Pixel Of oPnlGd1
        // Botao F7 Reprovar
        @002,340 BUTTON oBtnReprov PROMPT "Reprovar" SIZE 070,010 Action( ApRpPlan(nMsgPr, "03") ) Pixel Of oPnlGd1
        // Botao F9 Retornar para Em Aprovacao
        @002,420 BUTTON oBtnRetApr PROMPT "Retornar p/ Em Aprovacao" SIZE 070,010 Action( ApRpPlan(nMsgPr, "02") ) Pixel Of oPnlGd1
        // Atalhos F's
        SetKey(VK_F4,   {|| ApRpPlan(nMsgPr, "04") })   // Aprovar Planilha .CSV importada                          "04"=Aprovar
        SetKey(VK_F7,   {|| ApRpPlan(nMsgPr, "03") })   // Reprovar Planilha .CSV importada                         "03"=Reprovar
        SetKey(VK_F9,   {|| ApRpPlan(nMsgPr, "02") })   // Retornar para Em Aprovacao Planilha .CSV importada       "02"=Aguardando Aprovacao
        SetKey(VK_F11,  {|| ApRpPlan(nMsgPr, "05") })   // Processamento MRP                                        "05"=Processado
        // Helps de Atalhos
        @002,026 SAY	oSayAtaF4   PROMPT "F4 = Aprovar Planilha"          SIZE 070,010 OF oPnlBot PIXEL
        @002,126 SAY	oSayAtaF7   PROMPT "F7 = Reprovar Planilha"         SIZE 070,010 OF oPnlBot PIXEL
        @002,226 SAY	oSayAtaF9   PROMPT "F9 = Retornar p/ Em Aprovacao"  SIZE 120,010 OF oPnlBot PIXEL
    EndIf
    SetKey(VK_F6,   {|| GeraEx00(nMsgPr) }) // Gerar Planilha .CSV
    @002,426 SAY	oSayAtaF6   PROMPT "F6 = Gerar Planilha .CSV"           SIZE 070,010 OF oPnlBot PIXEL
    // GetDados 01: Registros ZRP
    oGetD1 := MsNewGetDados():New(015,002,195,660,GD_UPDATE,"AllwaysTrue()",,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlGd1,aHdr01,aCls01)
    oGetD1:oBrowse:lHScroll := .T.
    oGetD1:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD1:aCols, oGetD1:nAt, aHdr01, 1) })
    oGetD1:bChange := {|| nHoldZG1 := nLineZG1, nLineZG1 := oGetD1:nAt, oGetD1:Refresh(), LdsAglut( nHoldZG1, nLineZG1, nMsgPr ) }
    // Mostrar todos os status
	@200,325 CHECKBOX oChkStatus VAR lChkStatus PROMPT "Mostrar todos os status" SIZE 090,008 OF oPnlGd1 PIXEL ON CHANGE u_AskYesNo(3500,"LoadMrps","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadMrps( nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), oCmbCodMrp:nAt ) })
    oChkStatus:cVariable := "lChkStatus"
    // Reavalia regras
	@200,400 CHECKBOX oChkReaReg VAR lChkReaReg PROMPT "Reavaliar regras" SIZE 100,008 OF oPnlGd1 PIXEL
    oChkReaReg:cVariable := "lChkReaReg"
    // Relatorio automatico inconsistencias
    @200,480 CHECKBOX oChkRelAut VAR lChkRelAut PROMPT "Relatorio automatico inconsistencias" SIZE 160,008 OF oPnlGd1 PIXEL
    oChkRelAut:cVariable := "lChkRelAut"

    // Aglutinacao
    @004,005 SAY	oSayTipAgl   PROMPT "Visao por:"       SIZE 060,010 OF oPnlGd2 PIXEL
	oRadAglu := TRadMenu():New(002,050,aRadAglu, {|u| Iif(PCount() == 0, nRadAglu, nRadAglu := u) }, oPnlGd2,, {|| LdsAglut(0, 0, nMsgPr) },,,,.T.,,200,12,,,,.T.)
	oRadAglu:lHoriz := .T.
    // GetDados 02: Aglutinacao Fornecedor
    oGetD2 := MsNewGetDados():New(013,002,168,660,Nil,"AllwaysTrue()",,,aFldsAlt02,,,,,"AllwaysTrue()",oPnlGd2,aHdr02,aCls02)
    oGetD2:oBrowse:lHScroll := .T.
    oGetD2:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD2:aCols, oGetD2:nAt, aHdr02, 2) })
    oGetD2:bChange := {|| nLineZG2 := oGetD2:nAt, oGetD2:oBrowse:cToolTip := aTtipZG2[ nLineZG2 ], oGetD2:Refresh() }
    // GetDados 03: Aglutinacao Grupo Produto
    oGetD3 := MsNewGetDados():New(013,002,168,660,Nil,"AllwaysTrue()",,,aFldsAlt03,,,,,"AllwaysTrue()",oPnlGd2,aHdr03,aCls03)
    oGetD3:oBrowse:lHScroll := .T.
    oGetD3:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD3:aCols, oGetD3:nAt, aHdr03, 3) })
    oGetD3:bChange := {|| nLineZG3 := oGetD3:nAt, oGetD3:oBrowse:cToolTip := aTtipZG3[ nLineZG3 ], oGetD3:Refresh() }
    oGetD3:oBrowse:lVisible := .F.
    // GetDados 04: Aglutinacao Agrupamentos
    oGetD4 := MsNewGetDados():New(013,002,168,660,Nil,"AllwaysTrue()",,,aFldsAlt04,,,,,"AllwaysTrue()",oPnlGd2,aHdr04,aCls04)
    oGetD4:oBrowse:lHScroll := .T.
    oGetD4:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD4:aCols, oGetD4:nAt, aHdr04, 4) })
    oGetD4:bChange := {|| nLineZG4 := oGetD4:nAt, oGetD4:oBrowse:cToolTip := aTtipZG4[ nLineZG4 ], oGetD4:Refresh() }
    oGetD4:oBrowse:lVisible := .F.

	// Usuario logado
	@002,516 SAY	oSayCodLog PROMPT "Usuario Logado:" SIZE 040,010 OF oPnlBot PIXEL
	@000,561 MSGET  oGetCodLog VAR cGetCodLog SIZE 020,008 OF oPnlBot PIXEL READONLY
	@000,590 MSGET  oGetNomLog VAR cGetNomLog SIZE 070,008 OF oPnlBot PIXEL READONLY
	oGetCodLog:cToolTip := "Acessos:" + Chr(13) + Chr(10) + Iif(lUsrApr, "Aprovacao de Recalculos", "Inclusao/Alteracao de Recalculos" + Chr(13) + Chr(10) + "Geracao de Solicitacoes/Pedidos de Recalculos Aprovados")

    // Carregamento do aCls01
    u_AskYesNo(3500,"LoadMrps","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadMrps(nMsgPr, Iif(lChkStatus,"01/02/03/04/05/", cStaPad), 1) })
    ACTIVATE MSDIALOG oDlg01 CENTERED ON INIT EnchoiceBar(oDlg01, {|| Nil },{|| oDlg01:End() },, aButtons)
    If !lUsrApr // Usuario manipulador
        SetKey(VK_F4,   {|| Nil })      // Desativo Enviar para Aprovacao
        SetKey(VK_F9,   {|| Nil })      // Desativa Retorno para Recalculo
        SetKey(VK_F10,  {|| Nil })      // Desativa Importar Planilha .CSV
        SetKey(VK_F7,   {|| Nil })      // Desativa Exclusao
    Else // .T.=Usuario aprovador
        SetKey(VK_F4,   {|| Nil })      // Desativa Aprovacao
        SetKey(VK_F7,   {|| Nil })      // Desativa Reprovacao
        SetKey(VK_F9,   {|| Nil })      // Desativa Retorno para Recalculo
        SetKey(VK_F11,  {|| Nil })      // Processamento SchMrp23
    EndIf

    If RetCodUsr() == "000000/001478/" // Administrador
        SetKey(VK_F10,  {|| u_SchMrp21() }) // Atalho rapido
        SetKey(VK_F11,  {|| u_JobMrp23() })	// Job MRP
    EndIf

Else // Dados nao carregados aMolds01
    ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados para montagem da tela nao foram carregados para processamento!")
    ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Consulte o suporte Totvs apresentando esta mensagem!")
    If nMsgPr == 2 // 2=AskYesNo
        u_AskYesNo(6000, "SchMrp21", "Dados para montagem da tela nao foram carregados para processamento!", "Consulte o suporte Totvs apresentando esta mensagem!", "", "", "UPDERROR")
    EndIf
EndIf
ConOut("SchMrp21: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

Static Function GetDXClr(aCols, nLine, aHdrs, nObj) // Cores GetDados 01
Local nClr := nClrC21 // Cinza Mais Claro
If nLine <= Len(aCols) .And. !Empty(aCols[ nLine, 01 ]) // Dados carregados
    nClr := &("nClr" + cValToChar(nObj) + Iif(nObj == 1, Right(aCols[ nLine, nP01CodSta ],1), "0") + Iif( &("nLineZG" + cValToChar(nObj)) == nLine,"2","1"))
EndIf
Return nClr

Static Function LoadMrps(nMsgPr, cSttsMrp, nLinMrp) // Carregamento
Local _w1
Local _z1
Local cCodMrp := oCmbCodMrp:aItems[ nLinMrp ]
aCls01 := {}
ConOut("LoadMrps: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := 8
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"Carregando dados em tela...","Status: " + cSttsMrp, "", "", 80, "PROCESSA")
        Sleep(030)
    Next
EndIf
ConOut("LoadMrps: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando dados em tela... Status: " + cSttsMrp + ")")
DbSelectArea("SBM")
SBM->(DbSetOrder(1)) // BM_FILIAL + BM_GRUPO
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("ZRP")
If Upper(cCodMrp) <> "TODOS" // Se for por Codigo
    ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + ZRP_PERIOD
    ZRP->(DbSeek(_cFilZRP + cCodMrp))
Else // Por Status
    aCmbCodMRP := { "Todos" }
    ZRP->(DbSetOrder(1)) // ZRP_FILIAL + ZRP_CODSTA + ZRP_CODIGO + ZRP_CODPRO + ZRP_PERIOD
    ZRP->(DbSeek(_cFilZRP + Left(cSttsMrp,2),.T.)) // "01"=Recalculo      "02"=Aguardando Aprovacao       "03"=Reprovado       "04"=Aprovado      "05"=Processado
EndIf
While ZRP->(!EOF()) .And. ZRP->ZRP_FILIAL == _cFilZRP .And. Iif( Upper(cCodMrp) <> "TODOS", ZRP->ZRP_CODIGO == cCodMrp, ZRP->ZRP_CODSTA $ cSttsMrp ) // Filial e Status conforme
    If ZRP->ZRP_CODSTA $ cSttsMrp // Status conforme
        If lChkReaReg .Or. Empty(ZRP->ZRP_CREGRA) // .T.=Reavaliar regras .F.=Nao Reavaliar
            If SB1->(DbSeek( _cFilSB1 + ZRP->ZRP_CODPRO ))
                RecLock("ZRP",.F.)
                ZRP->ZRP_DESCRI := SB1->B1_DESC
                ZRP->ZRP_CODGRU := SB1->B1_GRUPO
                If !Empty( SB1->B1_GRUPO ) .And. SBM->(DbSeek( _cFilSBM + SB1->B1_GRUPO ))
                    ZRP->ZRP_DESGRU := RTrim(Upper(SBM->BM_DESC))
                    If !Empty( SBM->BM_XAGRUP ) // Agrupamento
                        aGrp := FwGetSX5("ZZ", SBM->BM_XAGRUP)
                        ZRP->ZRP_AGRUPA := RTrim(aGrp[01,04])
                    Else
                        ZRP->ZRP_AGRUPA := ""
                    EndIf
                Else
                    ZRP->ZRP_DESGRU := ""
                    ZRP->ZRP_AGRUPA := ""
                EndIf
                ZRP->ZRP_ORIGEM := SB1->B1_CLAPROD
                ZRP->ZRP_ESTSEG := SB1->B1_ESTSEG
                ZRP->ZRP_CUSUNI := SB1->B1_UPRC
                ZRP->ZRP_CURABC := SB1->B1_XABC
                ZRP->(MsUnlock())
                If ZRP->ZRP_CODSTA == "01" .Or. Empty(ZRP->ZRP_CREGRA) // Status "01" ou ainda nao identificada a regra
                    RecLock("ZRP",.F.)
                    ZRP->ZRP_PROC01 := Space(100)
                    ZRP->ZRP_LOGP01 := Space(100)
                    ZRP->ZRP_PROC02 := Space(100)
                    ZRP->ZRP_LOGP02 := Space(100)
                    ZRP->ZRP_RECZRP := ZRP->(Recno())
                    ZRP->(MsUnlock())
                    aRetRegra := u_FndRegra( ZRP->ZRP_CODPRO ) // Regra atualizada do produto
                    If aRetRegra[01] <> ZRP->ZRP_CREGRA .Or. aRetRegra[02] + aRetRegra[03] <> ZRP->ZRP_CODFOR + ZRP->ZRP_LOJFOR // Regra, Fornecedor ou Loja diferentes... regravo
                        RecLock("ZRP",.F.)
                        ZRP->ZRP_CREGRA := aRetRegra[01]
                        ZRP->ZRP_CODFOR := aRetRegra[02]
                        ZRP->ZRP_LOJFOR := aRetRegra[03]
                        ZRP->ZRP_NOMFOR := aRetRegra[04]
                        ZRP->ZRP_RECZRP := ZRP->(Recno())
                        ZRP->(MsUnlock())
                    EndIf
                EndIf
            EndIf
        EndIf
        _aCls01 := {}
        aAdd(_aCls01, ZRP->ZRP_CODIGO)                  // 01: Codigo
        For _w1 := 1 To Len(aMolds01)
            aAdd(_aCls01, &(aMolds01[ _w1, 03, 06 ]))   // Evaluate
        Next
        aAdd(_aCls01, ZRP->ZRP_OBSUSR)                  // 23: Observacao Usuario
        aAdd(_aCls01, ZRP->ZRP_OBSAPR)                  // 24: Observacao Aprovacao
        aAdd(_aCls01, ZRP->ZRP_LOGINC)                  // 25: Inclusao
        aAdd(_aCls01, ZRP->ZRP_LOGALT)                  // 26: Alteracao
        aAdd(_aCls01, ZRP->ZRP_CODSTA)                  // 27: Status
        aAdd(_aCls01, ZRP->ZRP_CREGRA)                  // 28: Regra
        aAdd(_aCls01, ZRP->ZRP_PROC01)                  // 29: Processamento 01
        aAdd(_aCls01, ZRP->ZRP_LOGP01)                  // 30: Log Processamento 01
        aAdd(_aCls01, ZRP->ZRP_PROC02)                  // 31: Processamento 02
        aAdd(_aCls01, ZRP->ZRP_LOGP02)                  // 32: Log Processamento 02
        aAdd(_aCls01, ZRP->(Recno()))                   // 33: Recno ZRP
        aAdd(_aCls01, .F.)                              // 34: Nao Apagado
        aAdd(aCls01, aClone(_aCls01))
        If Upper(cCodMrp) == "TODOS" // Se nao for por Codigo... recarrego
            If ASCan(aCmbCodMRP, {|x|, x == ZRP->ZRP_CODIGO }) == 0
                aAdd(aCmbCodMRP, ZRP->ZRP_CODIGO) // Inclusao do Codigo MRP
            EndIf
        EndIf
    EndIf
    ZRP->(DbSkip())
End
ConOut("LoadMrps: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando dados em tela... (Status: " + cSttsMrp + ") Concluido!")
nCurrent := 8
For _z1 := 1 To 4
    u_AtuAsk09(nCurrent,"Carregando dados em tela... Concluido!","Status: " + cSttsMrp, "", "", 80, "OK")
    Sleep(030)
Next
If Len(aCls01) == 0 .Or. Empty(aCls01[01,nP01Codigo]) // Dados nao carregados
	aCls01 := u_ClearCls(aHdr01)
EndIf
If Type("oGetD1") == "O"
    aSort( aCls01,,, {|x,y|, x[ nP01Codigo ] + x[ nP01CodPro ] + DtoS(x[ nP01Period ]) < y[ nP01Codigo ] + y[ nP01CodPro ] + DtoS(y[ nP01Period ]) }) // Ordenacao por Codigo + Produto + Periodo
	oGetD1:aCols := aClone(aCls01)
	oGetD1:Refresh()
    If Upper(cCmbCodMrp) == "TODOS" // Se nao for por Codigo... atualizo
        aSort(aCmbCodMrp,2,Nil, {|x,y|, x < y }) // Ordenar por Codigo
        oCmbCodMRP:aItems := aClone(aCmbCodMrp)
        oCmbCodMRP:bChange := {|| u_AskYesNo(3500,"LoadMrps","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadMrps(nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), oCmbCodMrp:nAt) }) }
        oCmbCodMRP:Refresh()
    EndIf
    LdsAglut( 0, 0, nMsgPr )
EndIf
ConOut("LoadMrps: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsAglut ºAutor ³ Jonathan Schmidt Alves ºData ³12/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento dos dados aglutinados.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsAglut( nHoldZG1, nLineZG1, nMsgPr )
Local _w
Local _w1
Local aCls := {}
Local nResul := 0
Local aTtipZG0 := {}
Local aTipsZG1 := {}
Private aMolds := aClone( &("aMolds" + StrZero(nRadAglu + 1,2)) )   // aMolds conforme tipo de aglutinacao
Private xDado := Nil
Private _n1 := 0
Private aResul := {}

If nLineZG1 == 0 .Or. nHoldZG1 == 0 .Or. nLineZG1 > Len(oGetD1:aCols) .Or. nHoldZG1 > Len(oGetD1:aCols) .Or. oGetD1:aCols[ nHoldZG1, nP01Codigo ] <> oGetD1:aCols[ nLineZG1, nP01Codigo ] // Mudou Codigo Importacao... recalculo

    DbSelectArea("SBM")
    SBM->(DbSetOrder(1)) // BM_FILIL + BM_GRUPO
    DbSelectArea("SA2")
    SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
    RfshStat( nMsgPr, oGetD1:nAt ) // Refresh do status
    While (_n1 := ASCan( oGetD1:aCols, {|x|, x[ nP01Codigo ] == oGetD1:aCols[ oGetD1:nAt, nP01Codigo ] }, _n1 + 1, Nil)) > 0 // Codigo conforme
        aAdd(aResul, Array(0))
        nResul++
        For _w := 1 To Len(aMolds)
            // Elenento 02: Validacao pre-carregamento
            If &(aMolds[ _w, 02, 02 ]) // Validacao pre-carregamento                Ex: "SB1->(!EOF())
                // Elemento 03: Montagem da variavel temporaria 'xDado' a partir da Origem da Informacao
                xDado := &(aMolds[ _w, 02, 03 ]) // Variavel temporaria             Ex: "SB1->B1_COD"
                // Elemento 04: Condicao para consideracao do campo ja carregado em 'xDado'
                If &(aMolds[ _w, 02, 04 ]) // Condicao
                    // Elemento 05: Tratamento da informacao em 'xDado'             Ex: "PadR(xDado,nTam)
                    If !Empty( aMolds[ _w, 02, 05 ] )
                        xDado := &(aMolds[ _w, 02, 05 ])
                    EndIf
                    // Elemento 06: Questao das Aspas Duplas (acho q nao sera usado)
                    If &(aMolds[ _w, 02, 06 ]) // Aspas Duplas                      Ex: ".F."
                        xDado := '"' + xDado + '"'
                    EndIf
                    // Carregamento finalizado na variavel
                    &(aMolds[ _w, 02, 01 ]) := xDado
                EndIf
                aAdd(aResul[nResul], &(aMolds[ _w, 02, 01 ])) // Inclusao de cada elemento processado na matriz resultado
            Else // Nao valido pre-carregamento, entao registro sera carregado com dado vazio
                ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Validacao pre-carregamento nao atendida em: " + aMolds[ _w, 02, 02 ])
                xDado := u_ClearCls( &("aHdr" + StrZero(nRadAglu + 1,2)), _w)[01]
                aAdd(aResul[nResul], xDado) // Inclusao de cada elemento processado na matriz resultado
            EndIf
        Next
        aAdd(aTipsZG1, { _n1, "Custo Uni x Qtde Recalc: " + u_Tr3(TransForm(oGetD1:aCols[ _n1, nP01CusUni ],"@E 999,999,999.99999")) + " x " + u_Tr3(TransForm(oGetD1:aCols[ _n1, nP01QtdRec ],"@E 999,999,999.99")) + " = R$ " + u_Tr3(TransForm(oGetD1:aCols[ _n1, nP01CusUni ] * oGetD1:aCols[ _n1, nP01QtdRec ], "@E 999,999,999.99")) })
    End
    // Rodo na matriz resultado
    For _w1 := 1 To Len( aResul )
        If nRadAglu == 1 // 1=Fornecedor
            If (nFnd := ASCan( aCls, {|x|, x[ nP02CodFor ] + x[ nP02LojFor ] + DtoS(x[ nP02Period ]) == aResul[ _w1, nP02CodFor ] + aResul[ _w1, nP02LojFor ] + DtoS(aResul[ _w1, nP02Period ]) })) == 0 // Fornecedor + Loja ainda + Periodo ainda nao considerado 
                aAdd(aCls, aClone( aResul[ _w1 ] ))
                aAdd(aTail(aCls), .F.)
                nFnd := Len(aCls)
            Else // Fornecedor ja existe
                aCls[ nFnd, nP02QtdRec ] += aResul[ _w1, nP02QtdRec ] // Incremento qtde recalculada
                aCls[ nFnd, nP02PrcCom ] += aResul[ _w1, nP02PrcCom ] // Incremento preco total da compra
            EndIf
        ElseIf nRadAglu == 2 // 2=Grupo Produto
            If (nFnd := ASCan( aCls, {|x|, x[ nP03CodGru ] + DtoS(x[ nP03Period ]) == aResul[ _w1, nP03CodGru ] + DtoS(aResul[ _w1, nP03Period ]) })) == 0 // Cod Grupo + Periodo ainda nao considerado 
                aAdd(aCls, aClone( aResul[ _w1 ] ))
                aAdd(aTail(aCls), .F.)
                nFnd := Len(aCls)
            Else // Grupo ja existe
                aCls[ nFnd, nP03QtdRec ] += aResul[ _w1, nP03QtdRec ] // Incremento qtde recalculada
                aCls[ nFnd, nP03PrcCom ] += aResul[ _w1, nP03PrcCom ] // Incremento preco total da compra
            EndIf
        ElseIf nRadAglu == 3 // 3=Agrupamento
            If (nFnd := ASCan( aCls, {|x|, x[ nP04Agrupa ] + DtoS(x[ nP04Period ]) == aResul[ _w1, nP04Agrupa ] + DtoS(aResul[ _w1, nP04Period ]) })) == 0 // Agrupamento + Periodo ainda nao considerado 
                aAdd(aCls, aClone( aResul[ _w1 ] ))
                aAdd(aTail(aCls), .F.)
                nFnd := Len(aCls)
            Else // Agrupamento ja existe
                aCls[ nFnd, nP04QtdRec ] += aResul[ _w1, nP04QtdRec ] // Incremento qtde recalculada
                aCls[ nFnd, nP04PrcCom ] += aResul[ _w1, nP04PrcCom ] // Incremento preco total da compra
            EndIf
        EndIf
        If nFnd > Len( aTtipZG0 )
            aAdd(aTtipZG0, "Composicao Custo: " + Chr(13) + Chr(10) + aTipsZG1[ _w1, 02 ])
        Else
            aTtipZG0[ nFnd ] += Chr(13) + Chr(10) + aTipsZG1[ _w1, 02 ]
        EndIf
    Next
    // Inclusao do total do custo no final da composicao
    For _w1 := 1 To Len( aCls )
        aTtipZG0[ _w1 ] += Chr(13) + Chr(10) + Space(95) + "R$ " + u_Tr3(TransForm( aCls[ _w1, &("nP" + StrZero(nRadAglu + 1,2) + "PrcCom") ],"@E 999,999,999.99"))
    Next
    &("aTtipZG" + cValToChar(nRadAglu + 1)) := aClone( aTtipZG0 )
    For _w := 2 To 4 // Rodo nos Get
        If _w == nRadAglu + 1
            &("oGetD" + cValToChar(nRadAglu + 1)):aCols := aClone( aCls )
        Else // Limpo os Tips dos outros objetos que nao estao visiveis
            aAdd(&("aTtipZG" + cValToChar(_w)), "")
        EndIf
        &("oGetD" + cValToChar(_w)):oBrowse:lVisible := _w == nRadAglu + 1
        &("oGetD" + cValToChar(_w)):Refresh()
    Next
    ChksButs() // Botoes conforme o status
EndIf
Return

User Function VlObsU23() // Validacao Obs do usuario
Local lRet := .T.
Local nLin := oGetD1:nAt
Local cReadVar := ReadVar()
If oGetD1:aCols[ nLin, nP01CodSta ] <> "01" // "01"=Em Recalculo
    u_AskYesNo(2000, "VlObsU23", "Observacao do Usuario so pode ser preenchida em registros com status '01'=Em Recalculo!", "Status: " + oGetD1:aCols[ nLin, nP01CodSta ], "", "", "UPDERROR")
    lRet := .F.
EndIf
If lRet // Valido
    If oGetD1:aCols[ nLin, nP01RecZRP ] > 0 // Recno ZRP
        ZRP->(DbGoto( oGetD1:aCols[ nLin, nP01RecZRP ] ))
        RecLock("ZRP",.F.)
        ZRP->ZRP_OBSUSR := &(cReadVar)
        ZRP->(MsUnlock())
    EndIf
EndIf
Return lRet

User Function VlObsA23() // Validacao Obs do aprovador
Local lRet := .T.
Local nLin := oGetD1:nAt
Local cReadVar := ReadVar()
If oGetD1:aCols[ nLin, nP01CodSta ] <> "02" // "02"=Aguardando Aprovacao
    u_AskYesNo(2000, "VlObsA23", "Observacao do Aprovador so pode ser preenchida em registros com status '02'=Aguardando Aprovacao!", "Status: " + oGetD1:aCols[ nLin, nP01CodSta ], "", "", "UPDERROR")
    lRet := .F.
EndIf
If lRet // Valido
    If oGetD1:aCols[ nLin, nP01RecZRP ] > 0 // Recno ZRP
        ZRP->(DbGoto( oGetD1:aCols[ nLin, nP01RecZRP ] ))
        RecLock("ZRP",.F.)
        ZRP->ZRP_OBSAPR := &(cReadVar)
        ZRP->(MsUnlock())
    EndIf
EndIf
Return lRet

Static Function RfshStat( nMsgPr, nLin ) // Refresh do status
Local _w1
Local aFlds := { "CODSTA", "PROC01", "LOGP01", "PROC02", "LOGP02" }
If nLin > 0 .And. nLin <= Len( oGetD1:aCols ) .And. oGetD1:aCols[ nLin, nP01RecZRP ] > 0 // Recno
    ZRP->(DbGoto( oGetD1:aCols[ nLin, nP01RecZRP ] ))
    If ZRP->(EOF()) // Recarrego tudo
        LoadMrps( nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), oCmbCodMrp:nAt )
    Else // Atualizo procs, logs e status
        For _w1 := 1 To Len( aFlds )
            If &("ZRP->ZRP_" + aFlds[_w1]) <> oGetD1:aCols[ nLin, &("nP01" + aFlds[_w1]) ] // Algo mudou... atualizo
                oGetD1:aCols[ nLin, &("nP01" + aFlds[_w1]) ] := &("ZRP->ZRP_" + aFlds[_w1])
            EndIf
        Next
        oGetD1:Refresh()
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ChksButs ºAutor ³ Jonathan Schmidt Alves ºData ³11/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Botoes conforme os status dos registros.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChksButs()
Local _w1
Local aObjects
Local nLin := oGetD1:nAt
If nLin > 0 .And. nLin <= Len(oGetD1:aCols)
    If !lUsrApr // .F.=Usuario Manipulador
        oBtnEnvApr:lActive := oGetD1:aCols[ nLin, nP01CodSta ] == "01"      // "01"=Recalculo
        oBtnRetClc:lActive := oGetD1:aCols[ nLin, nP01CodSta ] $ "02/03/04" // "02"=Em Aprovacao "03"=Reprovado "04"=Aprovado
        oBtnExcPla:lActive := oGetD1:aCols[ nLin, nP01CodSta ] == "01"      // "01"=Recalculo
        oBtnPrcApr:lActive := oGetD1:aCols[ nLin, nP01CodSta ] == "04"      // "04"=Aprovado
    Else // .T.=Usuario Aprovador
        oBtnAprova:lActive := oGetD1:aCols[ nLin, nP01CodSta ] == "02"      // "02"=Em Aprovacao
        oBtnReprov:lActive := oGetD1:aCols[ nLin, nP01CodSta ] == "02"      // "02"=Em Aprovacao
        oBtnRetApr:lActive := oGetD1:aCols[ nLin, nP01CodSta ] $ "03/04"    // "03"=Reprovado "04"=Aprovado
    EndIf
Else // Desativar botoes
    aObjects := { "oBtnEnvApr", "oBtnRetClc", "oBtnImpPla", "oBtnExcPla", "oBtnAprova", "oBtnReprov", "oBtnRetApr", "oBtnPrcApr" } // Botoes
	For _w1 := 1 To Len(aObjects) // Inativo botoes
		&(aObjects[ _w1 ]):lActive := .F.
		&(aObjects[ _w1 ]):Refresh()
	Next
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ImpoPlan ºAutor ³ Jonathan Schmidt Alves ºData ³03/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao da planilha .CSV com os recalculos MRP.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpoPlan(nMsgPr)
Local aRet := {}
Local cArqRet := ""
Local nLinMrp := 0
Default nMsgPr := 2 // 2=AskYesNo
cArqRet := fAbrir("*.CSV")
If !Empty( cArqRet ) // Arquivo preenchido
    // Parte 01/02: Abrindo e validando dados do arquivo escolhido
    u_AskYesNo(3500,"ImpoPlan","01/03 Verificando...","","","","","PROCESSA",.T.,.F.,{|| aRet := VldsPlan(nMsgPr, cArqRet) })
    If aRet[01] // .T.=Valido   // { .T., 3, "000001", aDados }
        lVld := u_AskYesNo(5000,"ImpoPlan","Confirma " + { "inclusao", "atualizacao" }[ aRet[02] - 2 ] + " dos dados da planilha?","Importacao: " + aRet[03],"","","Cancelar", /*"UPDINFORMATION"*/ { "BMPINCLUIR", "BMPTABLE" }[ aRet[02] - 2 ] )
        If !lVld .And. aRet[02] == 3 // Nao confirmada inclusao
            RollBackSX8()
        ElseIf lVld // Confirmada inclusao/alteracao
            // Parte 03: Processamento da planilha
            u_AskYesNo(3500,"ImpoPlan","03/03 Gravando...","Gravando dados nas tabelas...","","","","PROCESSA",.T.,.F.,{|| ProcPlan(nMsgPr, aRet[04], aRet[02], aRet[03] ) }) // Gravando dados
            // Parte 04: Recarregamento em tela
            If (nLinMrp := ASCan( aCmbCodMrp, {|x|, x == aRet[03] })) == 0 // Verifico se ah inclusao
                aAdd(aCmbCodMrp, aRet[03])
                nLinMrp := Len( aCmbCodMrp )
                oCmbCodMrp:aItems := aClone( aCmbCodMrp )
                oCmbCodMrp:nAt := nLinMrp
                oCmbCodMrp:Refresh()
            Else // Alteracao
                nLinMrp := oCmbCodMrp:nAt
                u_AskYesNo(3500,"LoadMrps","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadMrps(nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), nLinMrp) }) // Carregamento do aCls01
            EndIf
        EndIf
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldsPlan ºAutor ³ Jonathan Schmidt Alves ºData ³04/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento e validacao da planilha .CSV com dados MRP.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldsPlan(nMsgPr, cArqRet) // Validacoes da planilha
Local _z1
Local _w1
Local nLin := 1
Local nLines := 0
Local cLines := ""
Local nFnd
Local lVld := .T.
Local aRecsAval := {}
Local nProc := 3
Local cCodZRP := Space(06)
Local nLastUpdate := Seconds()
Local xDado
Local aDado := {}
Local aDados := {}
Local cBuffer := ""
ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
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
            aDado := StrToKarr(cBuffer,";")
            nLin++
            If Len(aDado) >= Len(aMolds01) // Colunas  conforme aMolds01
                _aDados := {}
                aAdd(_aDados, Space(06)) // Importacao
                For _w1 := 1 To Len( aMolds01 ) // Rodo nos campos
                    If lVld // Ainda valido
                        If &(aMolds01[ _w1, 03, 02 ]) // Validacao pre-carregamento antes de carregar a variavel
                            xDado := &(aMolds01[ _w1, 03, 03 ])   // Origem da informacao
                            If &(aMolds01[ _w1, 03, 04 ]) // Condicao para consideracao do campo apos carregar da origam
                                If !Empty( aMolds01[ _w1, 03, 05 ] ) // Tratamento da informacao apos carregar da origam
                                    xDado := &(aMolds01[ _w1, 03, 05 ])
                                EndIf
                                aAdd(_aDados, xDado) // Resultado
                            EndIf
                        Else // Coluna invalida
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados invalidos na planilha! (Linha " + cValToChar(nLin) + ")")
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Conteudo: " + aDado[_w1])
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique os dados da planilha e tente novamente!")
                            If nMsgPr == 2 // 2=AskYesNo
                                For _z1 := 1 To 4
                                    u_AtuAsk09(nCurrent,"01/03 Carregando...","Dados invalidos na planilha! (Linha " + cValToChar(nLin) + ")", "Conteudo: " + aDado[_w1], "Verifique os dados da planilha e tente novamente!", 80, "PROCESSA")
                                    Sleep(800)
                                Next
                            EndIf
                            lVld := .F.
                        EndIf
                    EndIf
                Next
                If lVld // Ainda valido
                    aAdd(_aDados, Space(02))    // Status
                    aAdd(_aDados, Space(100))   // Observacao Inclusao
                    aAdd(_aDados, Space(100))   // Observacao Aprovacao
                    aAdd(_aDados, Space(20))    // Inclusao
                    aAdd(_aDados, Space(20))    // Alteracao
                    aAdd(_aDados, Space(02))    // Codigo da Regra      Ex: "01", "02", "03" ou "04"
                    aAdd(_aDados, Space(100))    // Processamento 01     Ex: "SC7 001020/0001"
                    aAdd(_aDados, Space(100))    // Log Proces 01
                    aAdd(_aDados, Space(100))    // Processamento 02     Ex: "SC6 001020/0001"
                    aAdd(_aDados, Space(100))    // Log Proces 02
                    aAdd(_aDados, 0)            // Recno ZRP
                    aAdd(_aDados, Space(02))
                    aAdd(_aDados, .F.)          // Nao Apagado
                    aAdd(aDados, aClone(_aDados))
                    If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a última atualização da tela
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent,"01/03 Carregando...","Carregando dados da planilha... ", "Planilha: " + cArqRet + " Linha: " + cValToChar(nLin) + " / " + cLines, "", 80, "PROCESSA")
                                Sleep(050)
                            Next
                        EndIf
                        nLastUpdate := Seconds()
                    EndIf
                EndIf
            Else // Planilha com colunas invalidas
                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Qtde de colunas invalida! (Linha " + cValToChar(nLin) + ")")
                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Colunas Planilha: " + cValToChar(Len(aDado)))
                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique os dados da planilha e tente novamente!")
                If nMsgPr == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/03 Carregando...","Qtde de colunas invalida! (Linha " + cValToChar(nLin) + ")", "Colunas Planilha: " + cValToChar(Len(aDado)), "Verifique os dados da planilha e tente novamente!", 80, "PROCESSA")
                        Sleep(800)
                    Next
                EndIf
                lVld := .F.
            EndIf
            FT_FSkip() // Pula linha
        End
        FT_FUse() // Fecha o arquivo
        If lVld // Ainda valido
            If Len(aDados) == 0
                If nMsgPr == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/03 Carregando...","Dados da planilha nao foram carregados!", "Planilha: " + cArqRet, "Verifique se o arquivo nao esta aberto e tente novamente!", 80, "UPDERROR")
                        Sleep(800)
                    Next
                EndIf
                lVld := .F.
            Else // Dados carregados
                If nMsgPr == 2 // 2=AskYesNo
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/03 Carregando...","Carregando dados da planilha... Concluido!", "Planilha: " + cArqRet, "", 80, "OK")
                        Sleep(100)
                    Next
                EndIf
                // PARTE 02: Validacoes planilha
                If lVld
                    If nMsgPr == 2 // 2=AskYesNo
                        _oMeter:nTotal := Len(aDados)
                        For _z1 := 1 To 4
                            u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Avaliando os dados carregados...", "", "", 80, "PROCESSA")
                            Sleep(080)
                        Next
                    EndIf
                    //           {  Grv ZRP, Nao ZRP  }
                    aRecsAval := { Array(0), Array(0) }
                    For _w1 := 1 To Len( aDados )
                        // Verifico se o produto + periodo nao esta repetido na planilha
                        If ASCan(aDados, {|x|, x[ nP01CodPro ] + DtoS(x[ nP01Period ]) == aDados[ _w1, nP01CodPro ] + DtoS(aDados[ _w1, nP01Period ]) }, _w1 + 1, Nil) > 0
                            If nMsgPr == 2 // 2=AskYesNo
                                For _z1 := 1 To 4
                                    u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Planilha possui linhas duplicadas!", "Produto/Periodo: " + aDados[ _w1, nP01CodPro ] + " / " + DtoC(aDados[ _w1, nP01Period ]), "", 80, "UPDERROR")
                                    Sleep(800)
                                Next
                            EndIf
                            lVld := .F.
                        Else // Avaliar quanto a tabela ZRP
                            // Validacao de Produto + Periodo na base ZRP
                            DbSelectArea("ZRP")
                            ZRP->(DbSetOrder(2)) // ZRP_FILIAL + ZRP_CODPRO + ZRP_PERIOD
                            If Upper(cCmbCodMRP) <> "TODOS" // Codigo especifico, entao eh atualizacao
                                If ZRP->(DbSeek(_cFilZRP + aDados[ _w1, nP01CodPro ] + DtoS( aDados[ _w1, nP01Period ] ) ))
                                    While ZRP->(!EOF()) .And. ZRP->ZRP_FILIAL + ZRP->ZRP_CODPRO + DtoS(ZRP->ZRP_PERIOD) == _cFilZRP + aDados[ _w1, nP01CodPro ] + DtoS( aDados[ _w1, nP01Period ] ) // Filial + Produto
                                        If ZRP->ZRP_CODIGO == cCmbCodMRP // Codigo MRP conforme
                                            aAdd(aRecsAval[01], { ZRP->(Recno()), ZRP->ZRP_CODIGO, ZRP->ZRP_CODSTA })
                                            If Empty(cCodZRP)
                                                cCodZRP := ZRP->ZRP_CODIGO
                                            EndIf
                                            Exit
                                        EndIf
                                        ZRP->(DbSkip())
                                    End
                                EndIf
                            Else // Nao encontrado
                                aAdd(aRecsAval[02], { 0, "" })
                            EndIf
                        EndIf
                    Next
                    // Avaliacao dos resultados
                    // Ou nao existe nenhum registro da planilha com Produto + Periodo ou todos existem e estao com status "01"=Recalculo
                    If lVld // Ainda valido
                        If Len(aRecsAval[01]) == 0 // Nenhum existe
                            nProc := 3 // 3=Inclusao
                            ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + DtoS(ZRP_PERIOD)
                            While ZRP->(DbSeek(_cFilZRP + (cCodZRP := GetSXENum("ZRP","ZRP_CODIGO")) ))
                                ConfirmSX8()
                            End
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados da planilha ainda nao foram gravados ZRP... gerando nova importacao...")
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Importacao: " + cCodZRP)
                        ElseIf Len( aRecsAval[01] ) > 0 .And. Len( aRecsAval[02] ) > 0 // Existem dados gravados e outros ainda nao gravados
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Planilha possui registros importados e tambem registros ainda nao importados!")
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " A planilha deve deve respeitar a importacao original!")
                            ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Importacao: " + ZRP->ZRP_CODIGO)
                            If nMsgPr == 2 // 2=AskYesNo
                                For _z1 := 1 To 4
                                    u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Planilha possui registros importados e tambem registros ainda nao importados!", "A planilha deve deve respeitar a importacao original!", "Importacao: " + ZRP->ZRP_CODIGO, 80, "UPDERROR")
                                    Sleep(800)
                                Next
                            EndIf
                            lVld := .F.
                        ElseIf Len(aRecsAval[01]) == Len(aDados) // Todos existem e estao gravados
                            If (nFnd := ASCan( aRecsAval[01], {|x|, x[03] <> "01" })) > 0 // Existem dados que nao estao com status "01"=Recalculo
                                ZRP->(DbGoto( aRecsAval[01,nFnd,01] )) // Posiciono no ZRP
                                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Planilha possui registros que estao com status diferente de '01'=Recalculo!")
                                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " A planilha nao pode atualizar dados que ja estao em aprovacao ou apos esse status!")
                                ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Importacao: " + ZRP->ZRP_CODIGO)
                                If nMsgPr == 2 // 2=AskYesNo
                                    For _z1 := 1 To 4
                                        u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Planilha possui registros que estao com status diferente de '01'=Recalculo!", "A planilha nao pode atualizar dados que ja estao em aprovacao ou apos esse status!", "Importacao: " + ZRP->ZRP_CODIGO, 80, "UPDERROR")
                                        Sleep(800)
                                    Next
                                EndIf
                                lVld := .F.
                            Else
                                nProc := 4 // 4=Alteracao
                                // Existem dados que estao em uma Importacao, e outros dados em outra Importacao
                                For _w1 := 1 To Len(aRecsAval[02])
                                    If (nFnd := ASCan( aRecsAval[02], {|x|, x[02] <> aRecsAval[02,_w1,02] })) > 0 // Importacao diferente
                                        ZRP->(DbGoto( aRecsAval[01,_w1,01] )) // Posiciono no ZRP
                                        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Planilha possui registros que estao com Importacao diferentes")
                                        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " A planilha nao pode atualizar dados que ja estao em aprovacao ou apos esse status!")
                                        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Importacoes: " + ZRP->ZRP_CODIGO + "/" + aRecsAval[02,nFnd,02])
                                        If nMsgPr == 2 // 2=AskYesNo
                                            For _z1 := 1 To 4
                                                u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Planilha possui registros que estao com Importacoes diferentes!", "Verifique as improtacoes e tente novamente!", "Importacoes: " + ZRP->ZRP_CODIGO + "/" + aRecsAval[02,nFnd,02], 80, "UPDERROR")
                                                Sleep(800)
                                            Next
                                        EndIf
                                        lVld := .F.
                                    EndIf
                                Next
                            EndIf
                        EndIf
                        If lVld // .T.=Planilha eh valida
                            If nMsgPr == 2 // 2=AskYesNo
                                For _z1 := 1 To 4
                                    u_AtuAsk09(++nCurrent,"02/03 Avaliando...","Avaliando os dados carregados... Concluido!", "Planilha tem dados validos!", "", 80, "OK")
                                    Sleep(200)
                                Next
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    Else // Arquivo nao pode ser aberto
        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " A planilha nao pode ser aberta!")
        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Planilha: " + cArqRet)
        ConOut("ImpoPlan: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Verifique se o arquivo nao esta aberto e tente novamente!")
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
//     {  .T.,     3, "000001",        }
Return { lVld, nProc,  cCodZRP, aDados }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ProcPlan ºAutor ³ Jonathan Schmidt Alves ºData ³04/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento dos dados carregados gravando no ZRP.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ProcPlan(nMsgPr, aDados, nProc, cCodZRP)
Local _w1
Local _w2
Local _z1
Local nLastUpdate := Seconds()
DbSelectArea("ZRP")
ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + DtoS(ZRP_PERIOD)
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := Len(aDados) + 12
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"03/03 Gravando...","Gravando dados nas tabelas...", "", "", 80, "SALVAR")
        Sleep(100)
    Next
EndIf
For _w1 := 1 To Len(aDados)
    If nProc == 3 // Codigo inclusao
        RecLock("ZRP",.T.)
        ZRP->ZRP_FILIAL := _cFilZRP
        ZRP->ZRP_CODIGO := cCodZRP
        ZRP->ZRP_LOGINC := DtoC(Date()) + " " + Time() + " " + cUserName    // Inclusao
        ZRP->ZRP_CODSTA := "01"                             // Status
        ZRP->ZRP_CREGRA := Space(02)                        // Regra
        ZRP->ZRP_PROC01 := Space(100)                       // Processamento 01
        ZRP->ZRP_LOGP01 := Space(100)                       // Log Proces 01
        ZRP->ZRP_PROC02 := Space(100)                       // Processamento 02
        ZRP->ZRP_LOGP02 := Space(100)                       // Log Proces 02
        ZRP->ZRP_RECZRP := ZRP->(Recno())                   // Recno do ZRP
    ElseIf ZRP->(DbSeek(_cFilZRP + cCodZRP + aDados[ _w1, nP01CodPro ] + DtoS( aDados[ _w1, nP01Period ] ) )) // ZRP atualizacao
        RecLock("ZRP",.F.)
        ZRP->ZRP_LOGALT := DtoC(Date()) + " " + Time() + " " + cUserName    // Alteracao
        ZRP->ZRP_RECZRP := ZRP->(Recno())
    EndIf
    For _w2 := 1 To Len(aMolds01) // Rodo nos campos
        &(aMolds01[ _w2, 03, 06 ]) := aDados[ _w1, _w2 + 1 ]
    Next
    ZRP->(MsUnlock())
    ++nCurrent
    If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a última atualização da tela
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"03/03 Gravando...","Gravando dados nas tabelas...","Registro: " + cValToChar(_w1) + "/" + cValToChar(Len(aDados)), "", 80, "SALVAR")
                Sleep(050)
            Next
        EndIf
        nLastUpdate := Seconds()
    EndIf
Next
If nProc == 3 // Inclusao concluida
    ConfirmSX8()
EndIf
If nMsgPr == 2 // 2=AskYesNo
    nCurrent := 12
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"03/03 Gravando...","Gravando dados nas tabelas... Concluido!","Registro: " + cValToChar(_w1 - 1) + "/" + cValToChar(Len(aDados)), "", 80, "OK")
        Sleep(100)
    Next
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ApDlPlan ºAutor ³ Jonathan Schmidt Alves ºData ³10/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusao dos dados posicionados no ZRP.                    º±±
±±º          ³ Sempre ocorre em todos os itens da importacao posicionada. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ApDlPlan(nMsgPr)
Local aRet := { .F., Space(02), Space(06), Array(0) } // { lRet, cStaUni, cCodImp, aRcsZRP }
Local nLin := oGetD1:nAt
Local cCodImp := Space(06)
Local nOperac := 7 // 7=Exclusao
If nLin > 0 .And. nLin <= Len( oGetD1:aCols ) // Linha conforme
    cCodImp := oGetD1:aCols[ nLin, nP01Codigo ]
    If u_AskYesNo(5000,"ApDlPlan","Confirma exclusao?","Importacao: " + cCodImp,"","","Cancelar", "UPDINFORMATION")
        u_AskYesNo(3500,"ApDlPlan","01/02 Avaliando...","","","","","PROCESSA",.T.,.F.,{|| aRet := aRet := VlApPlan( nMsgPr, "01" ) }) // Valida dados da planilha em tela para exclusao
        If aRet[01] // .T.=Valido para exclusao
            If Len(aRet[04]) > 0 // Recnos carregados
                u_AskYesNo(3500,"ApDlPlan","02/02 Excluindo...","","","","","PROCESSA",.T.,.F.,{|| AtApPlan( nMsgPr, aRet[03], aRet[04], Space(02), nOperac ) }) // Excluindo e recarregando dados em tela
            EndIf
        EndIf
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ApRpPlan ºAutor ³ Jonathan Schmidt Alves ºData ³09/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprovacao/Reprovacao dos dados posicionados no ZRP.        º±±
±±º          ³ Sempre ocorre em todos os itens da importacao posicionada. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³                                                            º±±
±±º          ³ cNewSta: Novo status para gravacao                         º±±
±±º          ³          Ex: "02"=Aguardando Aprovacao                     º±±
±±º          ³              "03"=Reprovar                                 º±±
±±º          ³              "04"=Aprovar                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Status existentes:                                         º±±
±±º          ³ 01=Recalculo                                               º±±
±±º          ³ 02=Aguardando Aprovacao                                    º±±
±±º          ³ 03=Reprovado                                               º±±
±±º          ³ 04=Aprovado                                                º±±
±±º          ³ 05=Processado                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ApRpPlan(nMsgPr, cNewSta)
Local nFnd := 0
Local nFnd2 := 0
Local aRet := { .F., Space(02), Space(06), Array(0) } // { lRet, cStaUni, cCodImp, aRcsZRP }
Local aRelacs := {}
Local nOperac := 0
If lUsrApr // Usuario aprovador
    //            { Novo,      Valid, {                       Detalhes das Operacoes                         } } }
    aAdd(aRelacs, { "02",    "03/04", { { "03", "Cancelar reprovacao",  6 }, { "04", "Cancelar aprovacao", 5 } } })
    aAdd(aRelacs, { "03",       "02", { { "02", "Reprovacao",           4 } } })
    aAdd(aRelacs, { "04",       "02", { { "02", "Aprovacao",            3 } } })
Else // Usuario manipulador
    aAdd(aRelacs, { "01", "02/03/04", { { "02", "Em recalculo",         1 }, { "03", "Em recalculo",        1 }, { "04", "Em recalculo",        1 } } })
    aAdd(aRelacs, { "02",       "01", { { "01", "Em aprovacao",         2 } } })
EndIf
If (nFnd := ASCan(aRelacs, {|x|, x[01] == cNewSta })) > 0 // Localizo a situacao
    If nMsgPr == 2 // 2=AskYesNo
        u_AskYesNo(3500,"ApRpPlan","01/02 Avaliando...","","","","","PROCESSA",.T.,.F.,{|| aRet := VlApPlan( nMsgPr, aRelacs[ nFnd, 02 ], cNewSta ) }) // "03/04"=Reprovado/Aprovado ou "02"=Aguardando Aprovacao
        // aRet { lRet, cStaUni, cCodImp, aRcsZRP }
        If aRet[01] // .T.=Valido para processamento
            If (nFnd2 := ASCan( aRelacs[ nFnd, 03 ], {|x|, x[01] == aRet[02] })) > 0 // Localizo a situacao
                nOperac := aRelacs[ nFnd, 03, nFnd2, 03 ] // Situacao de processamento      1=Aprovacao 2=Reprovacao    3=Cancelamento de Aprovacao     4=Cancelamento de Reprovacao
                If aRet[01] // .T.=Valido
                    If u_AskYesNo(5000,"ApRpPlan","Confirma " + { "retorno para recalculo", "envio para aprovacao", "aprovacao", "reprovacao", "cancelamento da aprovacao", "cancelamento da reprovacao" } [ nOperac ] + "?","Importacao: " + aRet[03],"","","Cancelar", "UPDINFORMATION")
                        u_AskYesNo(3500,"ApRpPlan","02/02 " + { "Retorno para Recalculo", "Aguardando Aprovacao", "Aprovando", "Reprovando", "Cancelando Aprovacao", "Cancelando Reprovacao" } [ nOperac ] + "...","","","","","PROCESSA",.T.,.F.,{|| AtApPlan( nMsgPr, aRet[03], aRet[04], cNewSta, nOperac ) })
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
ElseIf cNewSta == "05" // "05"=Processado
    If nMsgPr == 2 // 2=AskYesNo
        u_AskYesNo(3500,"ApRpPlan","Avaliando Processamento...","","","","","PROCESSA",.T.,.F.,{|| u_LdsMrp23( oGetD1:aCols[ oGetD1:nAt, nP01Codigo ], nMsgPr, 3, 0, lChkRelAut ) })
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VlApPlan ºAutor ³ Jonathan Schmidt Alves ºData ³09/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao para aprovacao/reprovacao da planilha.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³                                                            º±±
±±º          ³ cStaAtu: Codigo atual de status dos registros a processar  º±±
±±º          ³          Ex: "02"=Aguardando Aprovacao  (em aprov/reprov)  º±±
±±º          ³              "03"=Reprovado             (em reavaliacao)   º±±
±±º          ³              "04"=Aprovado              (em reavaliacao)   º±±
±±º          ³                                                            º±±
±±º          ³ cNewSta: Novo status para gravacao                         º±±
±±º          ³          Ex: "02"=Aguardando Aprovacao                     º±±
±±º          ³              "03"=Reprovar                                 º±±
±±º          ³              "04"=Aprovar                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VlApPlan( nMsgPr, cStaAtu, cNewSta )
Local _z1
Local lRet := .F.
Local nIni := 0
Local nLin := oGetD1:nAt
Local cCodImp := Space(06)
Local cStaUni := Space(02)
Local aRcsZRP := {}
Local lObsApr := .F.
If nLin > 0 .And. nLin <= Len( oGetD1:aCols ) // Linha conforme
    RfshStat( nMsgPr, nLin ) // Refresh do status
    cCodImp := oGetD1:aCols[ nLin, nP01Codigo ]
    If nMsgPr == 2 // 2=AskYesNo
        _oMeter:nTotal := 8
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados...","Importacao: " + cCodImp, "", 80, "PROCESSA")
            Sleep(080)
        Next
    EndIf
    If oGetD1:aCols[ nLin, nP01CodSta ] $ cStaAtu // Status atual
        cStaUni := oGetD1:aCols[ nLin, nP01CodSta ]
        If (nIni := ASCan( oGetD1:aCols, {|x|, x[nP01Codigo] == cCodImp })) > 0
            lRet := .T.
            DbSelectArea("ZRP")
            ZRP->(DbSetOrder(3)) // ZRP_FILIAL + ZRP_CODIGO + ZRP_CODPRO + DtoS(ZRP_PERIOD)
            While nIni <= Len( oGetD1:aCols ) .And. oGetD1:aCols[ nIni, nP01Codigo ] == cCodImp
                If ZRP->(DbSeek(_cFilZRP + cCodImp + oGetD1:aCols[ nIni, nP01CodPro ] + DtoS(oGetD1:aCols[ nIni, nP01Period ])))
                    If ZRP->ZRP_CODSTA <> cStaUni // Problema nos status dos registros
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados... Falha!","Importacao: " + cCodImp, "Registros possuem status diferentes na importacao! Prod/Period: " +  oGetD1:aCols[ nIni, nP01CodPro ] + "/" + oGetD1:aCols[ nIni, nP01Period ], 80, "UPDERROR")
                                Sleep(500)
                            Next
                        EndIf
                        lRet := .F.
                        Exit
                    ElseIf cNewSta == "03" // "03"=Reprovado
                        // Verifico se algum dos registros da planilha tem observacao preenchida
                        If !Empty(ZRP->ZRP_OBSAPR)
                            lObsApr := .T.
                        EndIf
                    EndIf
                    aAdd(aRcsZRP, ZRP->(Recno()))
                Else // Registro nao encontrado
                    If nMsgPr == 2 // 2=AskYesNo
                        For _z1 := 1 To 4
                            u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados... Falha!","Importacao: " + cCodImp, "Registro nao foi encontrado no cadastro (ZRP): Prod/Period: " +  oGetD1:aCols[ nIni, nP01CodPro ] + "/" + oGetD1:aCols[ nIni, nP01Period ], 80, "UPDERROR")
                            Sleep(500)
                        Next
                    EndIf
                    lRet := .F.
                    Exit
                EndIf
                nIni++
            End
            If lRet // Ainda valido
                If cNewSta == "02" // "02"=Aguardando Aprovacao, entao vamos avaliar a planilha no SchMrp23
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados...","Importacao: " + cCodImp, "Avaliando montagem/processamento dos registros...", 80, "PROCESSA")
                        Sleep(050)
                    Next
                    // Avaliacao do processamento (se nao estiver tudo valido, nao eh enviado para aprovacao)
                    lRet := u_LdsMrp23(cCodImp, nMsgPr, 2, 0, lChkRelAut)
                ElseIf cNewSta == "03" .And. !lObsApr // "03"=Reprovado e sem mensagem do aprovador, nao permitir...
                    For _z1 := 1 To 4
                        u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados... Falha!","Importacao: " + cCodImp, "Para reprovar a planilha algum item deve ter preechida a Observacao do Aprovador!", 80, "UPDERROR")
                        Sleep(500)
                    Next
                    lRet := .F.
                EndIf
                If lRet // Ainda valido
                    If Len(aRcsZRP) > 0 // Registros carregados
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Avaliando dados... Sucesso!","Importacao: " + cCodImp, "", 80, "OK")
                                Sleep(100)
                            Next
                        EndIf
                    Else // Registros nao carregados
                        If nMsgPr == 2 // 2=AskYesNo
                            For _z1 := 1 To 4
                                u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Dados nao carregados para processamento!","Importacao: " + cCodImp, "", 80, "UPDERROR")
                                Sleep(150)
                            Next
                        EndIf
                        lRet := .F.
                    EndIf
                EndIf
            EndIf
        EndIf
    Else // Status nao conforme operacao
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(++nCurrent,"01/02 Avaliando...","Status do registro invalido para processamento!","Importacao: " + cCodImp, "", 80, "UPDERROR")
                Sleep(150)
            Next
        EndIf
    EndIf
EndIf
Return { lRet, cStaUni, cCodImp, aRcsZRP }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ AtApPlan ºAutor ³ Jonathan Schmidt Alves ºData ³09/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprovacao/Reprovacao dos registros ZRP alterando status.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr:  Mensagens de processamento                        º±±
±±º          ³                                                            º±±
±±º          ³ cCodImp: Codigo da importacao                              º±±
±±º          ³          Ex: "000015", "000021", etc                       º±±
±±º          ³                                                            º±±
±±º          ³ aRcsZRP: Matriz com os registros da ZRP para atualizacao   º±±
±±º          ³                                                            º±±
±±º          ³ cStaNew: Codigo novo de status dos registros a processar   º±±
±±º          ³          Ex: "02"=Aguardando Aprovacao                     º±±
±±º          ³              "03"=Reprovado                                º±±
±±º          ³              "04"=Aprovado                                 º±±
±±º          ³                                                            º±±
±±º          ³ nOperac: Numero da operacao para apresentar mensagens      º±±
±±º          ³          Ex: 1, 2.. 5                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AtApPlan(nMsgPr, cCodImp, aRcsZRP, cStaNew, nOperac)
Local _w1
Local _z1
_oMeter:nTotal := 8
If nMsgPr == 2 // 2=AskYesNo
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"02/02 " + { "Retorno para Recalculo", "Enviando para Aprovacao", "Aprovando", "Reprovando", "Cancelando Aprovacao", "Cancelando Reprovacao", "Excluindo" } [ nOperac ] + "...","","Importacao: " + cCodImp, "", 80, "PROCESSA")
        Sleep(080)
    Next
EndIf
For _w1 := 1 To Len( aRcsZRP )
    ZRP->(DbGoto( aRcsZRP[ _w1 ] ))
    RecLock("ZRP",.F.)
    If nOperac == 7 // 7=Exclusao
        ZRP->(DbDelete())
    Else
        ZRP->ZRP_CODSTA := cStaNew // "03"=Reprovado "04"=Aprovado
    EndIf
    ZRP->(MsUnlock())
Next
For _z1 := 1 To 4
    u_AtuAsk09(++nCurrent,"02/02 " + { "Retornando para Recalculo", "Enviando para aprovacao", "Aprovando", "Reprovando", "Cancelando Aprovacao", "Cancelando Reprovacao", "Excluindo" } [ nOperac ] + "... Concluido!","","Importacao: " + cCodImp, "", 80, "OK")
    Sleep(100)
Next
LoadMrps(nMsgPr, Iif(lChkStatus, "01/02/03/04/05/", cStaPad), oCmbCodMrp:nAt) // Recarregamento em tela
Return

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

User Function Tr3(cValor,l160)
Local cValor2 := AllTrim(cValor)
Default l160 := .F.
cValor2 := Replicate(" ",24 - (Len(cValor2) * 2)) + cValor2
If Len(AllTrim(cValor2)) >= 12
	cValor2 := Replicate(" ",26 - (Len(AllTrim(cValor)) * 2)) + AllTrim(cValor)
ElseIf Len(AllTrim(cValor2)) >= 8
	cValor2 := " " + Replicate(" ",24 - (Len(cValor2) * 2)) + cValor2
EndIf
If l160 // Char 160
	cValor2 := StrTran(cValor2," ",Chr(160))
EndIf
Return cValor2

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GeraEx00 ºAutor ³ Jonathan Schmidt Alves ºData ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Excel da tela de dados carregados no GetD1.     º±±
±±º          ³ Atalho F6                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraEx00( nMsgPr ) // Atalho F6
Local w, w2

Local aCabec := {}
Local aDados := {}
Local nExcLines := 0
Local lAuto := .F.
Local aColsSoma := {}

Local aCls01 := aClone(oGetD1:aCols)
Local cArqGer := "C:\TEMP\SchMrp21_EXL_" + StrTran(DtoC(Date()),"/","-") + "_" + StrTran(Left(Time(),6),":","") + ".CSV"
If Len(oGetD1:aCols) > 0
	// Parte 01: Carregando configuracoes de perguntas
	aAdd(aCabec, { "SchMrp21: Recalculo MRP" })
	aAdd(aCabec, { "Data:", DtoC(Date()) }) // Data atual
	// Parte 02: Colunas de impressao
	aHeaders := {}
	For w := 1 To Len(aHdr01)
		aAdd(aHeaders, aHdr01[w,01])
	Next
	// Parte 03: Dados
	aDados := {}
	For w := 1 To Len(aCls01)
		aDado := {}
		For w2 := 1 To Len(aHdr01)
            If aHdr01[w2,08] == "N" // Numerico
                xDado := AllTrim(TransForm(aCls01[w,w2], "@E 999999.99"))
            ElseIf aHdr01[w2,08] == "D" // Data
                xDado := DtoC( aCls01[w,w2] )
            Else // Char
                xDado := aCls01[w,w2]
                If !Empty(aHdr01[w2,11]) // Existe Options no aHeader
                    If Type( "aOpc" + SubStr(aHdr01[w2,02],5,6) ) == "U"
                        &("aOpc" + SubStr(aHdr01[w2,02],5,6)) := StrToKarr( aHdr01[w2,11], ";")
                    EndIf
                    If (nFind := ASCan( &("aOpc" + SubStr(aHdr01[w2,02],5,6)), {|x|, Left(x,2) == xDado })) > 0
                        xDado := &("aOpc" + SubStr(aHdr01[w2,02],5,6))[ nFind ]
                    EndIf
                EndIf
            EndIf
        	aAdd(aDado, xDado)
		Next
		aAdd(aDados, aClone(aDado))
	Next
	// Parte 04: Gerando Excel
	u_AskYesNo(1200,"GeraExcel","Gerando Excel...","","","","","PROCESSA",.T.,.F.,{|| u_GeraExcl(aCabec, aHeaders, aDados, aColsSoma, nExcLines, lAuto, cArqGer, nMsgPr) })
EndIf
Return
