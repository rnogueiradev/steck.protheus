#INCLUDE "PROTHEUS.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ SCHGEN03 ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Manutencao de rotinas menu.                                ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Configuracoes SX2:                                         ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Configuracoes SX3:                                         ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Configuracoes SIX:                                         ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Z1B: Indice 4:                                             ∫±±
±±∫          ≥ Z1B_FILIAL + Z1B_USUARIO + Z1B_ROTINA + DtoS(Z1B_DATA) +   ∫±±
±±∫          ≥ Z1B_HORA                                                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function SCHGEN03()
Local _w1
Local aAreaSM0 := {}
// Variaveis Sincronizacao ZG2
Private cDbfDtc := ".DTC"
Private cRDDs := "CTREECDX" /*"DBFCDXADS"*/
Private nLastUpdate := Seconds()
// Variaveis linhas objetos
Private nLineZG1 := 1
Private nLineZG2 := 1
Private nLineZG3 := 1
// Variaveis Usuario logado
Private cGetCodLog := RetCodUsr() // "001361" // "000010" renato.oliveira // RetCodUsr() // Codigo Usuario Logado
Private cGetNomLog := UsrRetName(cGetCodLog) // Nome do Usuario Logado
// Variaveis controle
Private aFlProc := {}
Private aAllUsr := {}
Private cObjFoc := "oGetD1"
Private aObjFoc := { "oGetD1", "01", "ZG1", "nP01StaPer" } // Objeto em foco
// Acessos
Private nFilsZ1B := 2   // 1=Apenas Filial logada   2=Todas as Filiais da Empresa
Private lCreaPer := .T. // .T.=Usuario com permissao para criar perfil
Private lAdmnPer := .T. // .T.=Usuario com permissao para administrar perfil
Private lBloqZG2 := .F. // .T.=Limpa usuarios bloqueados do cad usuarios do protheus no ZG2     .F.=Nao Limpa
Private nDaysZ1B := 90  // Dias para pesquisa retroativa no Z1B por menus usados pelos usuarios
// Filiais
Private _cFilZG1 := xFilial("ZG1")
Private _cFilZG2 := xFilial("ZG2")
Private _cFilZG3 := xFilial("ZG3")
Private _cFilZG7 := xFilial("ZG7")
Private _cFilZ1B := xFilial("Z1B")
Private _cFilZ1E := xFilial("Z1E")
Private _cFilZ1F := xFilial("Z1F")
// Cores GetDados
Private nClrC21 := RGB(205,205,205)	// Cinza Mais Claro
Private nClrC22 := RGB(217,204,117) // Cinza Amarelado
Private nClrC23 := RGB(238,185,162) // Cinza Avermelhado Claro
Private nClrC29 := RGB(231,150,116) // Cinza Avermelhado Escuro
Private nClrC24 := RGB(161,161,161) // Cinza Mais Escuro
Private nClrC25 := RGB(165,250,160) // Verde Claro
Private nClrC26 := RGB(090,245,082) // Verde Padrao
Private nClrC27 := RGB(132,155,251) // Azul Claro
Private nClrC28 := RGB(109,140,245) // Azul Mais Escuro
Private nClrC37 := RGB(176,179,244) // Cinza Azul Claro
Private nClrC38 := RGB(149,155,198) // Cinza Azul Mais Escuro
// Variaveis Pesquisa Usuario
Private lChkDepart := .T.
Private cGetCodUsr := Space(06)
Private cGetNomUsr := Space(40)
// Variaveis Inclusao Rotina
Private cGetNomRot := Space(15)
Private cGetDesRot := Space(40)
// Variaveis Perfis
Private oDlg01
Private oGetD1
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
Private cTitDlg := "SchGen03: Manutencao de Rotinas de Menu"
// GetDados 01: Perfil
Private oGetCodPer
Private cGetCodPer := Space(06)
Private oGetDesPer
Private cGetDesPer := Space(40)
// GetDados 02: Usuarios
Private oDlg02
Private oGetD2
Private aHdr02 := {}
Private aCls02 := {}
Private aFldsAlt02 := {}
// GetDados 03: Rotinas
Private oDlg03
Private oGetD3
Private aHdr03 := {}
Private aCls03 := {}
Private aFldsAlt03 := { "ZG3_CAGROT", "ZG3_CLSROT" }
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Headers
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando headers...")
// Perfis
aAdd(aHdr01, { "Perfil",    "ZG1_CODPER", "",                               06,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 01
aAdd(aHdr01, { "Descricao", "ZG1_DESPER", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 02
aAdd(aHdr01, { "Status",    "ZG1_STAPER", "",                               02,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "01=Perfil do Usuario;21=Outro Perfil;31=Perfil do Usuario Aprovado;32=Outro Perfil Aprovado",                     "" })  // 03
aAdd(aHdr01, { "Log Incl",  "ZG1_LGIPER", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 04
aAdd(aHdr01, { "Log Alter", "ZG1_LGAPER", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 05
aAdd(aHdr01, { "Log Aprov", "ZG1_LGLPER", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 06
aAdd(aHdr01, { "Log Gerac", "ZG1_LGGPER", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 07
// Usuarios
aAdd(aHdr02, { "Cod Usr",   "ZG2_CODUSR", "",                               06,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 01
aAdd(aHdr02, { "Nome",      "ZG2_NOMUSR", "@!",                             40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 02
aAdd(aHdr02, { "Status",    "ZG2_STAUSR", "",                               02,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "31=Usuario do Perfil;51=Outros Usuarios",                                                                         "" })  // 03
aAdd(aHdr02, { "Log Incl",  "ZG2_LGIUSR", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 04
// Rotinas
aAdd(aHdr03, { "Rotina",    "ZG3_NOMROT", "",                               15,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 01
aAdd(aHdr03, { "Descricao", "ZG3_DESROT", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 02
aAdd(aHdr03, { "Cod Agrup", "ZG3_CAGROT", "",                               03,  00, "u_VlAgrupa()",    "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "ZG7",  "R", "",                                                                                                                "" })  // 03
aAdd(aHdr03, { "Des Agrup", "ZG3_DAGROT", "",                               40,  00, ".F.",             "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",     "R", "",                                                                                                                "" })  // 04
aAdd(aHdr03, { "Classif",   "ZG3_CLSROT", "",                               01,  00, "u_VlClsRot()",    "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "I=Indefinida;C=Cadastros;R=Relatorios;P=Processamentos;D=Diversos",                                               "" })  // 05
aAdd(aHdr03, { "Status",    "ZG3_STAROT", "",                               02,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "01=Rotina Acessada;02=Rotina Incluida;61=Aguardando Aprovacao;62=Aguardando Aprovacao;71=Aprovada;72=Aprovada",   "" })  // 06
aAdd(aHdr03, { "Log Incl",  "ZG3_LGIROT", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 07
aAdd(aHdr03, { "Log Alter", "ZG3_LGAROT", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 08
aAdd(aHdr03, { "Log Aprov", "ZG3_LGLROT", "",                               40,  00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "",                                                                                                                "" })  // 09
// Preparacao das posicoes do Header 01
For _w1 := 1 To Len(aHdr01)
	&("nP01" + SubStr(aHdr01 [_w1,2],5,6)) := _w1
Next
// Preparacao das posicoes do Header 02
For _w1 := 1 To Len(aHdr02)
	&("nP02" + SubStr(aHdr02 [_w1,2],5,6)) := _w1
Next
// Preparacao das posicoes do Header 03
For _w1 := 1 To Len(aHdr03)
	&("nP03" + SubStr(aHdr03 [_w1,2],5,6)) := _w1
Next
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando headers... Concluido!")
// Carregamento das filiais para processamento
// Carregamento das filiais existentes
If nFilsZ1B == 1 // 1=Apenas Filial logada
    aAdd(aFlProc, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CODFIL + ": " + RTrim(SM0->M0_FILIAL) })
Else // 2=Todas as Filiais da Empresa
    aAreaSM0 := SM0->(GetArea())
    SM0->(DbSetOrder(1)) // M0_FILIAL + M0_CODIGO + M0_CODFIL
    SM0->(DbGotop())
    While SM0->(!EOF())
        If nFilsZ1B == 2 .And. SM0->M0_CODIGO == cEmpAnt // Apenas na Empresa logada
            aAdd(aFlProc, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CODFIL + ": " + RTrim(SM0->M0_FILIAL) })
        ElseIf nFilsZ1B == 3 // Todas as empresas/filiais
            aAdd(aFlProc, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CODFIL + ": " + RTrim(SM0->M0_FILIAL) })
        EndIf
        SM0->(DbSkip())
    End
    RestArea(aAreaSM0)
EndIf
// Abertura tabelas
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tabelas...")
DbSelectArea("ZG1") // Perfis
ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
DbSelectArea("ZG2") // Usuarios Perfil
ZG2->(DbSetOrder(1)) // ZG2_FILIAL + ZG2_CODPER
DbSelectArea("ZG3") // Rotinas Perfil
ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
DbSelectArea("ZG7") // Agrupamentos
ZG7->(DbSetOrder(1)) // ZG7_FILIAL + ZG7_CODAGR
DbSelectArea("Z1F") // Usuarios
Z1F->(DbSetOrder(1)) // Z1F_FILIAL + Z1F_COD
DbSelectArea("Z1B") // Acessos Rotinas
Z1B->(DbSetOrder(1)) // Z1B_FILIAL + Z1B_USUARI + Z1B_ROTINA
DbSelectArea("Z1E") // Cadastro de Rotinas
Z1E->(DbSetOrder(1)) // ZE1_FILIAL + Z1E_FUNCAO
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tabelas... Concluido!")

// Carregando Departamentos que o usuario logado pode manipular usuarios
aAllDepts := LdsDpAll() // Carregamento de todos os departamentos
aUsrDepts := UsrDepts( cGetCodLog, cGetNomLog ) // Usuarios conforme os departamentos

If Len(aUsrDepts) == 0 // Usuario logado sem acesso a Administrar Departamentos
    u_AskYesNo(2500,"LoadsZG1","Usuario nao cadastrado como administrador de perfil de departamento! (QB_XUSRSOD)!","Usuarios precisam antes estar cadastrados para entao administrar os perfis!","Usuario: " + cGetCodLog, cGetNomLog, "", "UPDERROR")
    Return
EndIf

// Carregamento dos dados
If Z1F->(DbSeek(_cFilZ1F + cGetCodLog))
    cGetCodUsr := Z1F->Z1F_COD
    cGetNomUsr := Z1F->Z1F_NOME
    u_AskYesNo(3500,"LoadsZG1","Carregando perfil...","Verificando...","","","","PROCESSA",.T.,.F.,{|| LoadsZG1(cGetCodLog) })
Else // Usuario nao encontrado no Z1F
    If !lCreaPer .And. !lAdmnPer // Usuario com permissao para Criar Perfil ou Administrar Perfil
        u_AskYesNo(2500,"LoadsZG1","Usuario nao encontrado no cadastro de usuarios (Z1F)!","Usuarios sem acessos especiais precisam estar cadastrados!","Usuario: " + cGetCodLog, cGetNomLog, "", "UPDERROR")
        Return
    EndIf
EndIf
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tela...")
DEFINE MSDIALOG oDlg01 FROM 050,165 TO 786,1242 TITLE cTitDlg Pixel
// Panel
oPnlGd1	:= TPanel():New(030,000,,oDlg01,,,,,nClrC21,542,110,.F.,.F.) // GetDados 01
oPnlGd2	:= TPanel():New(140,000,,oDlg01,,,,,nClrC23,542,110,.F.,.F.) // GetDados 02
oPnlGd3	:= TPanel():New(250,000,,oDlg01,,,,,nClrC22,542,110,.F.,.F.) // GetDados 03
oPnlBot	:= TPanel():New(360,000,,oDlg01,,,,,nClrC21,542,010,.F.,.F.) // Rodape (Atalhos)

// Considerar apenas usuarios dos departamentos
@005,195 CHECKBOX oChkDepart VAR lChkDepart PROMPT "Considerar apenas departamentos" SIZE 100,008 OF oPnlGd1 PIXEL ON CHANGE LoadsZG2()
oChkDepart:cToolTip := "Considera apenas os departamentos administrados pelo usuario logado ou mostra todos os usuarios"

// Usuario Logado / Acessos
@005,306 SAY	oSayCodLog PROMPT "Cod Usr Logado:" SIZE 060,010 OF oPnlGd1 PIXEL
@003,350 MSGET	oGetCodLog VAR cGetCodLog SIZE 020,008 OF oPnlGd1 PIXEL
@003,380 MSGET	oGetNomLog VAR cGetNomLog SIZE 100,008 OF oPnlGd1 PIXEL
oGetCodLog:cToolTip := "Acessos do Usuario: " + Chr(13) + Chr(10) + Iif(lCreaPer,"Criar perfis" + Chr(13) + Chr(10),"") + Iif(lAdmnPer,"Administrar Perfis" + Chr(13) + Chr(10),"") + "Administrar seu menu e suas rotinas"

// Criar novo perfil
@100,006 SAY	oSayCodPer PROMPT "Cod Pefil:" SIZE 040,010 OF oPnlGd1 PIXEL
@098,035 MSGET	oGetCodPer VAR cGetCodPer SIZE 020,008 OF oPnlGd1 PIXEL
@098,070 MSGET	oGetDesPer VAR cGetDesPer SIZE 100,008 OF oPnlGd1 PIXEL VALID VlDesPer()
@098,205 BUTTON oBtnNewPer PROMPT "Novo Perfil" SIZE 060,010 Action(ProcsPer()) Pixel Of oPnlGd1
// Usuario Pesquisa
@005,006 SAY	oSayCodUsr PROMPT "Cod Usuario:" SIZE 060,010 OF oPnlGd1 PIXEL
@003,040 MSGET	oGetCodUsr VAR cGetCodUsr SIZE 020,008 OF oPnlGd1 F3 "USR" PIXEL VALID VlCodUsr() HASBUTTON
@003,075 MSGET	oGetNomUsr VAR cGetNomUsr SIZE 100,008 OF oPnlGd1 PIXEL
// GetDados 01: Perfis
oGetD1 := MsNewGetDados():New(018,002,090,536,Nil,"AllwaysTrue()",,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlGd1,aHdr01,aCls01)
oGetD1:oBrowse:lHScroll := .F.
oGetD1:oBrowse:SetBlkBackColor({|| GetD1Clr(oGetD1:aCols, oGetD1:nAt, aHdr01) })
oGetD1:bChange := {|| nLineZG1 := oGetD1:nAt, oGetD1:Refresh(), LoadsZG2() }
oGetD1:oBrowse:bGotFocus := {|| cObjFoc := "oGetD1" }
oGetD1:oBrowse:SetFocus()
// GetDados 02: Usuarios
oGetD2 := MsNewGetDados():New(002,002,093,536,Nil,"AllwaysTrue()",,,aFldsAlt02,,,,,"AllwaysTrue()",oPnlGd2,aHdr02,aCls02)
oGetD2:oBrowse:lHScroll := .F.
oGetD2:oBrowse:SetBlkBackColor({|| GetD2Clr(oGetD2:aCols, oGetD2:nAt, aHdr02) })
oGetD2:bChange := {|| nLineZG2 := oGetD2:nAt, oGetD2:Refresh(), LoadsZG3() }
oGetD2:oBrowse:bGotFocus := {|| cObjFoc := "oGetD2" }
// GetDados 03: Rotinas
oGetD3 := MsNewGetDados():New(002,002,093,536,GD_UPDATE,"AllwaysTrue()",,,aFldsAlt03,,,,,"AllwaysTrue()",oPnlGd3,aHdr03,aCls03)
oGetD3:oBrowse:lHScroll := .F.
oGetD3:oBrowse:SetBlkBackColor({|| GetD3Clr(oGetD3:aCols, oGetD3:nAt, aHdr03) })
oGetD3:oBrowse:bChange := {|| nLineZG3 := oGetD3:nAt, oGetD3:Refresh() }
oGetD3:oBrowse:bGotFocus := {|| cObjFoc := "oGetD3" }
// Inclusao rotina
@098,006 SAY	oSayNomRot PROMPT "Rotina:" SIZE 040,010 OF oPnlGd3 PIXEL
@096,035 MSGET	oGetNomRot VAR cGetNomRot SIZE 040,008 OF oPnlGd3 PIXEL VALID VlNomRot()
@096,085 MSGET	oGetDesRot VAR cGetDesRot SIZE 100,008 OF oPnlGd3 PIXEL VALID VlDesRot()
@096,205 BUTTON oBtnNewRot PROMPT "Incluir Rotina" SIZE 060,010 Action(ProcsRot()) Pixel Of oPnlGd3
aObjects := { "oGetNomUsr", "oGetCodPer", "oGetCodLog", "oGetNomLog" }
For _w1 := 1 To Len(aObjects)
    &(aObjects[ _w1 ]):lReadOnly := .T.
    &(aObjects[ _w1 ]):lActive := .F.
    &(aObjects[ _w1 ]):Refresh()
Next
If !lAdmnPer // Nao tem acesso para administrar perfis
    // Entao nao fica mexendo nos perfis dos outros
    aObjects := { "oGetCodUsr" }
    For _w1 := 1 To Len(aObjects)
        &(aObjects[ _w1 ]):lActive := .F.
        &(aObjects[ _w1 ]):Refresh()
    Next
    // Atalhos
    @002,040 SAY	oSayAtaF8   PROMPT "F8 = Marcar/Desmarcar Rotinas" SIZE 080,010 OF oPnlBot PIXEL
Else // Acesso a administrar perfis
    // Atalhos
    @002,040 SAY	oSayAtaF8   PROMPT "F8 = Marcar/Desmarcar Usuarios/Rotinas" SIZE 080,010 OF oPnlBot PIXEL
    @002,140 SAY	oSayAtaF10  PROMPT "F10 = Deletar perfil" SIZE 080,010 OF oPnlBot PIXEL
    @002,240 SAY	oSayAtaF11  PROMPT "F11 = Clonar perfil" SIZE 080,010 OF oPnlBot PIXEL
    SetKey(VK_F10,{|| AjstPerf(5) }) // Deletar perfil
    SetKey(VK_F11,{|| AjstPerf(6) }) // Clonar perfil
EndIf
If !lCreaPer // Nao tem acesso para criar perfil
    // Se o usuario ainda nao tem perfil.. permite criar uma vez
    DbSelectArea("ZG2")
    ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
    If ZG2->(DbSeek(_cFilZG2 + cGetCodLog)) // Usuario ja tem um perfil... nao permite criar mais nada
        // Entao nao permite incluir/alterar o perfil ja criado
        aObjects := { "oSayCodPer", "oGetCodPer", "oGetDesPer", "oBtnNewPer" }
        For _w1 := 1 To Len(aObjects)
            &(aObjects[ _w1 ]):lActive := .F.
            &(aObjects[ _w1 ]):lVisible := .F.
            &(aObjects[ _w1 ]):Refresh()
        Next
    EndIf
EndIf
SetKey(VK_F8,{|| MarkRegs() }) // Marcar registros
ConOut("SCHGEN03: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo tela... Concluido!")
ACTIVATE MSDIALOG oDlg01 CENTERED ON INIT EnchoiceBar(oDlg01, {|| ProcPers() },{|| oDlg01:End()},, Nil)
SetKey(VK_F8,   {|| Nil }) // Desativar Marcar registros
SetKey(VK_F10,  {|| Nil }) // Desativar Deletar perfil
SetKey(VK_F11,  {|| Nil }) // Desativar Clonar perfil
u_AskYesNo(3500,"ZG2ToLoc","Sincronizacao ZG2...","Por favor, aguarde a sincronizacao terminar...","","","","PROCESSA",.T.,.F.,{|| ZG2ToLoc() }) // Atualizacao do ZG2 local com ZG2 banco
Return

Static Function GetD1Clr(aCols, nLine, aHdrs) // Cores GetDados 01
Local nClr := nClrC24 // Cinza Mais Escuro
If aCols[ nLine, nP01StaPer ] == "01" // "01"=Perfil do Usuario
    If nLineZG1 == nLine
        nClr := nClrC26 // Verde Padrao
    Else
        nClr := nClrC25 // Verde Claro
    EndIf
ElseIf aCols[ nLine, nP01StaPer ] == "21" // "21"=Outro Perfil
    If nLineZG1 == nLine 
        nClr := nClrC24 // Cinza Escuro
    Else
        nClr := nClrC21 // Cinza Claro
    EndIf
ElseIf aCols[ nLine, nP01StaPer ] == "31" // "31"=Perfil do Usuario Aprovado
    If nLineZG1 == nLine
        nClr := nClrC28 // Azul Mais Escuro
    Else
        nClr := nClrC27 // Azul Claro
    EndIf
ElseIf aCols[ nLine, nP01StaPer ] == "32" // "31"=Outro Perfil Aprovado
    If nLineZG1 == nLine
        nClr := nClrC38 // Cinza Azul Mais Escuro
    Else
        nClr := nClrC37 // Cinza Azul Claro
    EndIf
EndIf
Return nClr

Static Function GetD2Clr(aCols, nLine, aHdrs) // Cores GetDados 02
Local nClr := nClrC24 // Cinza Mais Escuro
If aCols[ nLine, nP02StaUsr ] == "31" // "31"=Usuarios do Perfil
    If nLineZG2 == nLine
        nClr := nClrC26 // Verde Padrao
    Else
        nClr := nClrC25 // Verde Claro
    EndIf
Else // "51"=Outros Usuarios
    If nLineZG2 == nLine
        nClr := nClrC24 // Cinza Escuro
    Else
        nClr := nClrC21 // Cinza Claro
    EndIf
EndIf
Return nClr

Static Function GetD3Clr(aCols, nLine, aHdrs) // Cores GetDados 03
Local nClr := nClrC24 // Cinza Mais Escuro
If aCols[ nLine, nP03StaRot ] $ "01/02/" // "01"=Rotina Acessada
    If nLineZG3 == nLine // Teste
        nClr := nClrC24 // Cinza Escuro
    Else
        nClr := nClrC21 // Cinza Claro
    EndIf
ElseIf aCols[ nLine, nP03StaRot ] $ "61/62/" // "61"=Aguardando Aprovacao       "62"=Aguardando Aprovacao
    If nLineZG3 == nLine
        nClr := nClrC29 // Cinza Avermelhado Escuro
    Else
        nClr := nClrC23 // Cinza Avermelhado Claro
    EndIf
ElseIf aCols[ nLine, nP03StaRot ] $ "71/72/" // "71"=Aprovada "72"=Aprovada
    If nLineZG3 == nLine // Teste
        nClr := nClrC38 // Cinza Azul Mais Escuro
    Else
        nClr := nClrC37 // Cinza Azul Claro
    EndIf
EndIf
Return nClr


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LdsDpAll ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/02/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento da matriz de departamentos (SQB).             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LdsDpAll() // Carregamento dos Departamentos
Local aAllDepts := {}
SQB->(DbGotop())
While SQB->(!EOF())
	//              {   Filial Depto,    Cod  Depto,      Nome Depto, Cod CCusto, Depto Superior,          Chave,    Admin Perfil,,     Filial Resp,  Matricula Resp }
	//              {             01,            02,              03,         04,             05,             06,              07,,              09,              10 }
	aAdd(aAllDepts, { SQB->QB_FILIAL, SQB->QB_DEPTO, SQB->QB_DESCRIC, SQB->QB_CC, SQB->QB_DEPSUP, SQB->QB_KEYINI, SQB->QB_XUSRSOD,, SQB->QB_FILRESP, SQB->QB_MATRESP })
	SQB->(DbSkip())
End
Return aAllDepts

Static Function UsrDepts( cGetCodLog, cGetNomLog ) // Usuarios conforme os departamentos
Local _w1
Local _w2
Local nIni := 0
Local aAdmDepts := {}
Local aUsrDepts := {}

aSort(aAllDepts,,, {|x,y|, x[07] < y[07] }) // Ordenacao por Administrador Perfil

While (nIni := ASCan(aAllDepts, {|x|, PadR(x[07],50) == PadR(cGetNomLog,50) }, nIni + 1, Nil)) > 0
	//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,,,, }
	//              {                    01,                    02,                    03,                    04,                    05,                    06,,,, }
	aAdd(aAdmDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
End

// Carregamento dos niveis abaixo
While _w1 <= Len( aAdmDepts )
    While (nIni := ASCan(aAllDepts, {|x|, x[05] == aAdmDepts[ _w1, 02 ] }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
        //              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,,,, }
        //              {                    01,                    02,                    03,                    04,                    05,                    06,,,, }
        aAdd(aAdmDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
    End
    _w1++
End

// Carregamento dos usuarios relacionados aos departamentos
DbSelectArea("SRA")
SRA->(DbSetOrder(21)) // RA_FILIAL + RA_DEPTO + RA_MAT

For _w1 := 1 To Len(aAdmDepts) // Rodo nos departamentos

    // aAdd(aFlProc, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CODFIL + ": " + RTrim(SM0->M0_FILIAL) })

	For _w2 := 1 To Len(aFlProc) // Rodo em todas as filiais
		If SRA->(DbSeek(aFlProc[ _w2, 02 ] + aAdmDepts[ _w1, 02 ]))

			While SRA->(!EOF()) .And. SRA->RA_FILIAL + SRA->RA_DEPTO == aFlProc[ _w2, 02 ] + aAdmDepts[ _w1, 02 ]
                If !Empty(SRA->RA_XUSRCFG) // Usuario CFG preenchido
                    If Empty(SRA->RA_DEMISSA) // Nao demitido

                        //              {    Filial Func,    Mat Func,    Nome Func,     Cod Depto,           Nome Depto,,,,, Cod Usuario Cfg }
                        //              {             01,          02,           03,            04,                   05,,,,,              10 }
                        aAdd(aUsrDepts, { SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_NOME, SRA->RA_DEPTO, aAdmDepts[ _w1, 03 ],,,,, SRA->RA_XUSRCFG })

                    EndIf
				EndIf
				SRA->(DbSkip())
			End

		EndIf
	Next
Next

Return aUsrDepts


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ MarkRegs ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Marcar/Desmarcar registros atalho F8                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function MarkRegs()
Local _w
Local nLin := 0
Local nCol := 0
Local cSta := Space(02)
Local aObjFoc := {}
// Variaveis checagem
Local cChkCodPer := Space(06)
Local cChkDesPer := Space(40)
Local cChkStaNew := Space(02)
// Variaveis Usuario em questao
Local cChkCodUsr := Space(06)
Local cChkNomUsr := Space(40)
// Variaveis Rotina
Local cChkNomRot := Space(15)
Local cChkDesRot := Space(40)
Local cChkCAgRot := Space(02)
Local cChkClsRot := Space(01)
// Variavel log
Local cChkLogReg := Space(40)
//            {       01,   02,    03,           04,                  05,              06, {                                                             07 }, {                                                                                                08 } }
aAdd(aObjFoc, { "oGetD1", "01", "ZG1", "nP01StaPer",       "01/21/31/32", "AllwaysTrue()", {                                                                }, {  { "01", "31" }, { "21", "32" },                                    { "31","01" }, { "32", "21" } } })  // Objeto em foco           "01"=Perfil do Usuario      "21"=Outro Perfil                   "31"=Perfil do Usuario Aprovado           "32"=Outro Perfil Aprovado"
aAdd(aObjFoc, { "oGetD2", "02", "ZG2", "nP02StaUsr",             "31/51", "AllwaysTrue()", {                                                                }, {                           { "31", "51" }, { "51", "31" }                                          } })  // Objeto em foco           "21"=Usuario do Perfil      "31"=Outros Usuarios Selecionados   "32"=Outros Usuarios Nao Selecionados
aAdd(aObjFoc, { "oGetD3", "03", "ZG3", "nP03StaRot", "01/02/61/62/71/72", "AllwaysTrue()", { { "01", "61" }, { "61", "01" }, { "02", "62" }, { "62", "02" } }, { { "01", "61" }, { "61", "71" }, { "71", "01" },    { "02", "62" }, { "62", "72" }, { "72", "02" } } })  // Objeto em foco           "01"=Disponivel             "61"=Bloqueado                      "62"=Bloqueado                            "71"=Liberado               "72"=Liberado
If (nObj := ASCan( aObjFoc, {|x|, x[ 01 ] == cObjFoc })) > 0 // Acho o objeto
    nLin := &(aObjFoc[ nObj, 01 ]):nAt                                              // Linha
    cSta := &(aObjFoc[ nObj, 01 ] + ":aCols[ nLin, " + aObjFoc[ nObj, 04 ] + " ]")  // Status do registro
    If cSta $ aObjFoc[ nObj, 05 ] // Status do registro permitidos para alteracao
        lVldMark := &(aObjFoc[ nObj, 06 ])              // Validacao adicional
        If lVldMark // Valido
            // Se for um usuario normal.. pode apenas trocar de "01"=Disponivel para "61"=Aguardando Aprovacao ou "02"=Disponivel para "62"=Aguardando Aprovacao
            nCol := Iif(lAdmnPer, 08, 07) // Usuario normal
            If Len(aObjFoc[ nObj, nCol ]) > 0 // Alteracoes possiveis
                If (nFind := ASCan( aObjFoc[ nObj, nCol ], {|x|, x[01] == cSta })) > 0 // Acho o Status Atual
                    cChkStaNew := aObjFoc[ nObj, nCol, nFind, 02 ] // Status Novo
                    cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
                    cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
                    If aObjFoc[ nObj, 01 ] == "oGetD1" // Perfis
                        cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
                        cChkDesPer := oGetD1:aCols[ oGetD1:nAt, nP01DesPer ]
                        // Verificar se o Perfil tem Usuario(s) relacionados e/ou Rotinas relacionadas
                        If cChkStaNew $ "31/32/" .And. ASCan(oGetD2:aCols, {|x|, x[ nP02StaUsr ] == "31" }) == 0 // Nao tem usuarios selecionados      "31"=Usuario do Perfil
                            u_AskYesNo(4000,"MarkRegs","O perfil nao pode ser aprovado pois nao possui usuarios!","Selecione usuarios para o perfil e tente novamente!","Perfil: " + cChkCodPer + " " + cChkDesPer,"","","UPDWARNING")
                        ElseIf cChkStaNew $ "31/32/" .And. ASCan(oGetD3:aCols, {|x|, x[ nP03StaRot ] $ "71/72/" }) == 0 .And. ASCan(oGetD3:aCols, {|x|, x[ nP03StaRot ] $ "61/62/" }) == 0 // Nao tem rotinas aprovadas nem aguardando aprovacao     "71"=Rotina Aprovada
                            u_AskYesNo(4000,"MarkRegs","O perfil nao pode ser aprovado pois nao possui rotinas aprovadas ou aguardando aprovacao!","Aprove rotinas para o perfil e tente novamente!","Perfil: " + cChkCodPer + " " + cChkDesPer,"","","UPDWARNING")
                        Else // Segue processamento
                            If cChkStaNew $ "31/32/" .And. ASCan(oGetD3:aCols, {|x|, x[ nP03StaRot ] $ "71/72/" }) == 0 .And. ASCan(oGetD3:aCols, {|x|, x[ nP03StaRot ] $ "61/62/" }) > 0
                                If u_AskYesNo(4000,"MarkRegs","Confirma aprovacao das rotinas que estao aguardando aprovacao?","Todas as rotinas serao aprovadas!","","","Confirmar","UPDINFORMATION")
                                    Return
                                Else // Aprovar as rotinas automaticamente
                                    // Aprovo todas as "61"=Aguardando Aprovacao
                                    For _w := 1 To Len( oGetD3:aCols )
                                        If oGetD3:aCols[ _w, nP03StaRot ] $ "61/62/" // "61"=Aguardando Aprovacao       "62"=Aguardando Aprovacao
                                            cChkNomRot := oGetD3:aCols[ _w, nP03NomRot ]
                                            cChkDesRot := oGetD3:aCols[ _w, nP03DesRot ]
                                            cChkClsRot := oGetD3:aCols[ _w, nP03ClsRot ]
                                            cChkCAgRot := oGetD3:aCols[ _w, nP03CAgRot ]
                                            ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
                                            If ZG3->(!DbSeek(_cFilZG3 + cChkCodPer + cChkNomRot)) // Inclusao
                                                RecLock("ZG3",.T.)
                                                ZG3->ZG3_FILIAL := _cFilZG3
                                                ZG3->ZG3_CODPER := cChkCodPer
                                                ZG3->ZG3_NOMROT := cChkNomRot
                                                ZG3->ZG3_DESROT := cChkDesRot
                                                ZG3->ZG3_CLSROT := cChkClsRot
                                                ZG3->ZG4_CAGROT := cChkCAgRot
                                                ZG3->ZG3_LGIROT := cChkLogReg
                                                oGetD3:aCols[ _w, nP03LgIRot ] := cChkLogReg
                                                oGetD3:aCols[ _w, nP03LgARot ] := Space(40)
                                            Else // Alteracao
                                                RecLock("ZG3",.F.)
                                                oGetD3:aCols[ _w, nP03LgLRot ] := cChkLogReg
                                                ZG3->ZG3_LGLROT := cChkLogReg
                                            EndIf
                                            ZG3->ZG3_STAROT := Iif(cSta == "01", "71", "72")                        // "71"=Rotina Aprovada
                                            ZG3->(MsUnlock())
                                            oGetD3:aCols[ _w, nP03StaRot ] := Iif(cSta == "01", "71", "72")         // "71"=Rotina Aprovada
                                            oGetD3:Refresh()
                                        EndIf
                                    Next
                                EndIf
                            EndIf
                            ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
                            If ZG1->(DbSeek(_cFilZG1 + cChkCodPer))
                                RecLock("ZG1",.F.)
                                If cChkStaNew $ "31/32/" // "01=Perfil do Usuario;21=Outro Perfil;31=Perfil do Usuario Aprovado;32=Outro Perfil Aprovado"
                                    ZG1->ZG1_STAPER := cChkStaNew
                                    oGetD1:aCols[ oGetD1:nAt, nP01StaPer ] := cChkStaNew
                                    ZG1->ZG1_LGLPER := cChkLogReg
                                    oGetD1:aCols[ oGetD1:nAt, nP01LgLPer ] := cChkLogReg
                                Else // Nao aprovado
                                    ZG1->ZG1_STAPER := cChkStaNew
                                    oGetD1:aCols[ oGetD1:nAt, nP01StaPer ] := cChkStaNew
                                    ZG1->ZG1_LGAPER := cChkLogReg
                                    oGetD1:aCols[ oGetD1:nAt, nP01LgAPer ] := cChkLogReg
                                    ZG1->ZG1_LGLPER := Space(40)
                                    oGetD1:aCols[ oGetD1:nAt, nP01LgLPer ] := Space(40)
                                EndIf
                                &(aObjFoc[ nObj, 01 ]):Refresh()
                            EndIf
                        EndIf
                    ElseIf aObjFoc[ nObj, 01 ] == "oGetD2" // Usuarios
                        cChkCodUsr := oGetD2:aCols[ oGetD2:nAt, nP02CodUsr ]
                        cChkNomUsr := oGetD2:aCols[ oGetD2:nAt, nP02NomUsr ]
                        ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
                        If ZG2->(!DbSeek(_cFilZG2 + cChkCodUsr + cChkCodPer))
                            RecLock("ZG2",.T.)
                            ZG2->ZG2_FILIAL := _cFilZG2
                            ZG2->ZG2_CODPER := cChkCodPer
                            ZG2->ZG2_CODUSR := cChkCodUsr
                            ZG2->ZG2_NOMUSR := cChkNomUsr
                            ZG2->ZG2_LGIUSR := cChkLogReg
                            oGetD2:aCols[ oGetD2:nAt, nP02LgIUsr ] := cChkLogReg
                        Else // Alteracao
                            RecLock("ZG2",.F.)
                            oGetD2:aCols[ oGetD2:nAt, nP02LgIUsr ] := Space(40)
                        EndIf
                        If cChkStaNew == "51" .And. ZG2->(!EOF())  // "51"=Outros Usuarios (entao apago)
                            ZG2->(DbDelete())
                        EndIf
                        ZG2->(MsUnlock())
                        &(aObjFoc[ nObj, 01 ] + ":aCols[ nLin, " + aObjFoc[ nObj, 04 ] + " ]") := cChkStaNew
                        &(aObjFoc[ nObj, 01 ]):Refresh()
                    Else // Rotinas
                        // Gravacoes ZG3
                        cChkNomRot := oGetD3:aCols[ oGetD3:nAt, nP03NomRot ]
                        cChkDesRot := oGetD3:aCols[ oGetD3:nAt, nP03DesRot ]
                        cChkCAgRot := oGetD3:aCols[ oGetD3:nAt, nP03CAgRot ]
                        cChkClsRot := oGetD3:aCols[ oGetD3:nAt, nP03ClsRot ]
                        If cChkClsRot == "I" // Rotina nao pode estar ainda "I"=Indefinida
                            u_AskYesNo(4000,"MarkRegs","Classificacao da rotina antes deve ser definida!","Verifique a classificacao da rotina e tente novamente!","Rotina: " + cChkNomRot + " " + cChkDesRot,"","","UPDERROR")
                        ElseIf Empty( cChkCAgRot ) // Rotina nao pode estar ainda sem Agrupamento
                            u_AskYesNo(4000,"MarkRegs","Agrupamento da rotina antes deve ser definido!","Verifique o agrupamento da rotina e tente novamente!","Rotina: " + cChkNomRot + " " + cChkDesRot,"","","UPDERROR")
                        Else // Prosseguir...
                            ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
                            If ZG3->(!DbSeek(_cFilZG3 + cChkCodPer + cChkNomRot)) // Inclusao
                                RecLock("ZG3",.T.)
                                ZG3->ZG3_FILIAL := _cFilZG3
                                ZG3->ZG3_CODPER := cChkCodPer
                                ZG3->ZG3_NOMROT := cChkNomRot
                                ZG3->ZG3_DESROT := cChkDesRot
                                ZG3->ZG3_CAGROT := cChkCAgRot
                                ZG3->ZG3_CLSROT := cChkClsRot
                                ZG3->ZG3_LGIROT := cChkLogReg
                                oGetD3:aCols[ oGetD3:nAt, nP03LgIRot ] := cChkLogReg
                                oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := Space(40)
                            Else // Alteracao
                                RecLock("ZG3",.F.)
                                If cChkStaNew $ "71/72/" // "71"=Aprovada   "72"=Aprovada
                                    oGetD3:aCols[ oGetD3:nAt, nP03LgLRot ] := cChkLogReg
                                    ZG3->ZG3_LGLROT := cChkLogReg
                                Else // Alteracao
                                    oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := cChkLogReg
                                    ZG3->ZG3_LGAROT := cChkLogReg
                                EndIf
                            EndIf
                            If cChkStaNew $ "01/02/" .And. ZG3->(!EOF()) // "01"=Disponivel (entao apago)
                                oGetD3:aCols[ oGetD3:nAt, nP03LgIRot ] := Space(40)
                                oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := Space(40)
                                oGetD3:aCols[ oGetD3:nAt, nP03LgLRot ] := Space(40)
                                ZG3->(DbDelete())
                            Else
                                ZG3->ZG3_CAGROT := cChkCAgRot
                                ZG3->ZG3_CLSROT := cChkClsRot
                                ZG3->ZG3_STAROT := cChkStaNew
                            EndIf
                            ZG3->(MsUnlock())
                            &(aObjFoc[ nObj, 01 ] + ":aCols[ nLin, " + aObjFoc[ nObj, 04 ] + " ]") := cChkStaNew
                            &(aObjFoc[ nObj, 01 ]):Refresh()
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlCodUsr ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao Codigo do Usuario.                               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function VlCodUsr()
Local lRet := .T.
Local cVlCodUsr := &(ReadVar())
ConOut("VlCodUsr: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("Z1F") // Usuarios
Z1F->(DbSetOrder(1)) // Z1F_FILIAL + Z1F_COD
If !Empty(cVlCodUsr) // Codigo preenchido
    If Z1F->(!DbSeek(_cFilZ1F + cVlCodUsr))
        ConOut("VlCodUsr: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Usuario nao encontrado no cadastro de usuarios (Z1F)!")
        ConOut("VlCodUsr: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Cod Usr: " + cVlCodUsr)
        MsgStop("Usuario nao encontrado no cadastro de usuarios (Z1F)!" + Chr(13) + Chr(10) + ;
        "Cod Usr: " + cVlCodUsr,"VlCodUsr")
        lRet := .F.
    Else // Codigo valido
        cGetNomUsr := Z1F->Z1F_NOME
        oGetNomUsr:Refresh()
        u_AskYesNo(3500,"LoadPers","Carregando perfil...","Verificando...","","","","PROCESSA",.T.,.F.,{|| LoadsZG1(Z1F->Z1F_COD) })
    EndIf
Else // Codigo nao preenchido
    If lCreaPer .Or. lAdmnPer // Acessos especiais
        cGetNomUsr := Space(40)
        oGetNomUsr:Refresh()
        u_AskYesNo(3500,"LoadPers","Carregando perfil...","Verificando...","","","","PROCESSA",.T.,.F.,{|| LoadsZG1( Space(06) ) }) // Carrego os meus dados + dados dos outros perfis
    EndIf
EndIf
ConOut("VlCodUsr: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlDesPer ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao Descricao do Perfil.                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function VlDesPer()
Local lRet := .T.
Local cVlDesPer := &(ReadVar())
Local cNxPer := Space(06)
ConOut("VlDesPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If !Empty(cVlDesPer) // Descricao preenchida
    DbSelectArea("ZG1")
    ZG1->(DbSetOrder(2)) // ZG1_FILIAL + ZG1_DESPER
    If ZG1->(DbSeek(_cFilZG3 + cVlDesPer))
        DbSelectArea("ZG2")
        ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
        If ZG2->(DbSeek(_cFilZG2 + cGetCodLog)) .Or. lAdmnPer // Se perfil eh do usuario ou usuario tem acesso especial para administrar perfil
            cGetCodPer := ZG1->ZG1_CODPER
            oGetCodPer:Refresh()
            oBtnNewPer:cCaption := "Atualizar Perfil"
            oBtnNewPer:Refresh()
        Else // Sem permissao
            ConOut("VlDesPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Ja existe perfil com essa descricao!")
            ConOut("VlDesPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Perfil: " + ZG1->ZG1_CODPER + " " + RTrim(ZG1->ZG1_DESPER))
            ConOut("VlDesPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Digite uma descricao diferente e tente novamente!")
            MsgStop("Ja existe perfil com essa descricao!" + Chr(13) + Chr(10) + ;
            "Perfil: " + ZG1->ZG1_CODPER + " " + ZG1->ZG1_DESPER + Chr(13) + Chr(10) + ;
            "Digite uma descricao diferente e tente novamente!","VlDesPer")
            lRet := .F.
        EndIf
    Else // Ainda nao existe
        If Empty(cGetCodPer) .Or. oBtnNewPer:cCaption == "Incluir Perfil" // Inclusao de Perfil
            cNxPer := "000000"
            ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
            ZG1->(DbGoBottom())
            If ZG1->(!EOF())
                cNxPer := ZG1->ZG1_CODPER
            EndIf
            cGetCodPer := Soma1(cNxPer)
        EndIf
    EndIf
Else // Vazio
    cGetCodPer := Space(06)
    oBtnNewPer:cCaption := "Novo Perfil"
    oBtnNewPer:Refresh()
EndIf
oGetCodPer:Refresh()
ConOut("VlDesPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlAgrupa ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥26/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao do Agrupamento da Rotina.                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function VlAgrupa()
Local lRet := .T.
Local cNomRot := Space(15)
Local cDesRot := Space(40)
Local cStaRot := Space(02)
Local cChkCodPer := Space(06)
Local cVlAgrupa := &(ReadVar())
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
ConOut("VlAgrupa: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("ZG7")
ZG7->(DbSetOrder(1)) // ZG7_FILIAL + ZG7_CODAGR
If oGetD3:nAt > 0 .And. oGetD3:nAt <= Len(oGetD3:aCols)
    cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
    cNomRot := oGetD3:aCols[ oGetD3:nAt, nP03NomRot ]
    cDesRot := oGetD3:aCols[ oGetD3:nAt, nP03DesRot ]
    cStaRot := oGetD3:aCols[ oGetD3:nAt, nP03StaRot ]
    If !lAdmnPer
        If cStaRot $ "71/72/" // Usuario ajustando rotina ja aprovada          "71"=Aprovada   "72"=Aprovada
            ConOut("VlAgrupa: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Usuario nao pode alterar rotina ja aprovada!")
            ConOut("VlAgrupa: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Modifique o status da rotina e tente novamente!")
            ConOut("VlAgrupa: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Rotina: " + cNomRot + "Desc: " + RTrim(cDesRot))
            u_AskYesNo(2500,"VlAgrupa","Usuario nao pode alterar rotina ja aprovada!","Modifique o status da rotina e tente novamente!","Rotina: " + cNomRot, "Desc: " + RTrim(cDesRot),"","UPDERROR")
            lRet := .F.
        ElseIf cStaRot $ "61/62/"// Alterada Agrupamento da Rotina         "61"=Aguardando aprovacao        "62"=Aguardando aprovacao
            oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := cChkLogReg
            oGetD3:Refresh()
        EndIf
    EndIf

    If lRet
        If !Empty( cVlAgrupa ) // Preenchido
            If ZG7->(!DbSeek( _cFilZG7 + cVlAgrupa))
                MsgStop("Agrupamento nao encontrado no cadastro (ZG7)!" + Chr(13) + Chr(10) + ;
                "Agrupamento: " + cVlAgrupa,"VlAgrupa")
                lRet := .F.
            Else // Valido
                oGetD3:aCols[ oGetD3:nAt, nP03DAgRot ] := ZG7->ZG7_DESAGR
            EndIf
        Else // Vazio
            oGetD3:aCols[ oGetD3:nAt, nP03DAgRot ] := Space(40)
        EndIf

        If lRet
            DbSelectArea("ZG3")
            ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
            If ZG3->(DbSeek(_cFilZG3 + cChkCodPer + cNomRot))
                RecLock("ZG3",.F.)
                ZG3->ZG3_CAGROT := cVlAgrupa
                ZG3->(MsUnlock())

                oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := cChkLogReg
                oGetD3:Refresh()

            Else // Ainda nao tem ZG3
                oGetD3:aCols[ oGetD3:nAt, nP03LgIRot ] := cChkLogReg
                oGetD3:Refresh()

            EndIf
        EndIf
    EndIf
EndIf
oGetD3:Refresh()
ConOut("VlAgrupa: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlClsRot ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥19/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao da Classificacao da Rotina.                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function VlClsRot()
Local lRet := .T.
Local cNomRot := Space(15)
Local cDesRot := Space(40)
Local cStaRot := Space(02)
Local cChkCodPer := Space(06)
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
ConOut("VlClsRot: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If oGetD3:nAt > 0 .And. oGetD3:nAt <= Len(oGetD3:aCols)
    cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
    cNomRot := oGetD3:aCols[ oGetD3:nAt, nP03NomRot ]
    cDesRot := oGetD3:aCols[ oGetD3:nAt, nP03DesRot ]
    cStaRot := oGetD3:aCols[ oGetD3:nAt, nP03StaRot ]
    If !lAdmnPer
        If cStaRot $ "71/72/" // Usuario ajustando rotina ja aprovada          "71"=Aprovada    "72"=Aprovada
            ConOut("VlClsRot: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Usuario nao pode alterar rotina ja aprovada!")
            ConOut("VlClsRot: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Modifique o status da rotina e tente novamente!")
            ConOut("VlClsRot: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Rotina: " + cNomRot + "Desc: " + RTrim(cDesRot))
            u_AskYesNo(2500,"VlClsRot","Usuario nao pode alterar rotina ja aprovada!","Modifique o status da rotina e tente novamente!","Rotina: " + cNomRot, "Desc: " + RTrim(cDesRot),"","UPDERROR")
            lRet := .F.
        ElseIf cStaRot $ "61/62/"// Alterada Classificacao da Rotina         "61"=Aguardando aprovacao "62"=Aguardando aprovacao
            oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := cChkLogReg
            oGetD3:Refresh()
        EndIf
    EndIf
    If lRet
        DbSelectArea("ZG3")
        ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
        If ZG3->(DbSeek(_cFilZG3 + cChkCodPer + cNomRot))
            RecLock("ZG3",.F.)
            ZG3->ZG3_CLSROT := &(ReadVar())
            ZG3->(MsUnlock())
            oGetD3:aCols[ oGetD3:nAt, nP03LgARot ] := cChkLogReg
            oGetD3:Refresh()
        Else // Ainda nao tem ZG3
            oGetD3:aCols[ oGetD3:nAt, nP03LgIRot ] := cChkLogReg
            oGetD3:Refresh()
        EndIf
    EndIf
EndIf
ConOut("VlClsRot: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ProcsPer ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Botao para criacao e atualizacao de Perfil.                ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ProcsPer()
Local _w1
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
ConOut("ProcsPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("ZG1")
ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
If !Empty(cGetCodPer) // Codigo preenchido
    If oBtnNewPer:cCaption == "Novo Perfil" // Criacao de Perfil
        If ZG1->(DbSeek(_cFilZG1 + cGetCodPer))
            ConOut("ProcsPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Ja existe perfil com essa descricao!")
            ConOut("ProcsPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Perfil: " + ZG1->ZG1_CODPER + " " + RTrim(ZG1->ZG1_DESPER))
            ConOut("ProcsPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Digite uma descricao diferente e tente novamente!")
            MsgStop("Ja existe perfil com essa descricao!" + Chr(13) + Chr(10) + ;
            "Perfil: " + ZG1->ZG1_CODPER + " " + ZG1->ZG1_DESPER + Chr(13) + Chr(10) + ;
            "Digite uma descricao diferente e tente novamente!","ProcsPer")
        Else // Perfil ainda nao existe
            RecLock("ZG1",.T.)
            ZG1->ZG1_FILIAL := _cFilZG1
            ZG1->ZG1_CODPER := cGetCodPer
            ZG1->ZG1_DESPER := cGetDesPer
            ZG1->ZG1_LGIPER := cChkLogReg
            ZG1->(MsUnlock())
            ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
            If !Empty(cGetCodUsr) .And. ZG2->(!DbSeek(_cFilZG2 + cGetCodUsr)) // Se nao tem acesso a criar perfil e ainda nao tem perfil, cria automatico amarrado
                RecLock("ZG2",.T.)
                ZG2->ZG2_FILIAL := _cFilZG2
                ZG2->ZG2_CODPER := ZG1->ZG1_CODPER
                ZG2->ZG2_CODUSR := cGetCodUsr
                ZG2->ZG2_NOMUSR := cGetNomUsr
                ZG2->ZG2_LGIUSR := cChkLogReg
                ZG2->(MsUnlock())
            EndIf
            cGetCodPer := Space(06)
            cGetDesPer := Space(40)
            u_AskYesNo(3500,"LoadPers","Carregando perfis...","Verificando...","","","","PROCESSA",.T.,.F.,{|| LoadsZG1(cGetCodUsr) })
            If !lCreaPer // Se o usuario nao tem acesso a criar perfil, foi o unico perfil criado
                // Entao nao permite incluir/alterar mais perfis
                aObjects := { "oSayCodPer", "oGetCodPer", "oGetDesPer", "oBtnNewPer" }
                For _w1 := 1 To Len(aObjects)
                    &(aObjects[ _w1 ]):lActive := .F.
                    &(aObjects[ _w1 ]):lVisible := .F.
                    &(aObjects[ _w1 ]):Refresh()
                Next
            EndIf
        EndIf
    ElseIf oBtnNewPer:cCaption == "Atualizar Perfil" // Atualizacao de Perfil
        If ZG1->(DbSeek(_cFilZG1 + cGetCodPer))
            RecLock("ZG1",.F.)
            ZG1->ZG1_DESPER := cGetDesPer
            ZG1->ZG1_LGAPER := cChkLogReg
            ZG1->(MsUnlock())
            If (nFind := ASCan( oGetD1:aCols, {|x|, x[ nP01CodPer ] == cGetCodPer })) > 0
                oGetD1:aCols[ nFind, nP01DesPer ] := cGetDesPer
                oGetD1:aCols[ nFind, nP01LgAPer ] := cChkLogReg
            EndIf
            cGetCodPer := Space(06)
            oGetCodPer:Refresh()
            cGetDesPer := Space(40)
            oGetDesPer:Refresh()
            oBtnNewPer:cCaption := "Incluir Perfil"
            oBtnNewPer:Refresh()
        EndIf
    EndIf
EndIf
ConOut("ProcsPer: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ AjstPerf ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Ajustar perfil via teclas de atalho F10/F11                ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ nTipPrc: Tipo de processamento                             ∫±±
±±∫          ≥          5=Excluir perfil                                  ∫±±
±±∫          ≥          6=Clonar perfil                                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function AjstPerf(nTipPrc)
Local _w1
Local aRecsZG2 := {}
Local aRecsZG3 := {}
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cChkCodPer := Space(06)
Local nUsrPer := 0
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
ConOut("AjstPerf: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If cObjFoc == "oGetD1" // Foco no get de Perfil
    If oGetD1:nAt > 0 .And. oGetD1:nAt <= Len(oGetD1:aCols)
        cMsg01 := "Deseja realmente " + Iif(nTipPrc == 5, "excluir", "clonar") + " o perfil?"
        cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
        cChkDesPer := oGetD1:aCols[ oGetD1:nAt, nP01DesPer ]
        cMsg02 := "Perfil: " + cChkCodPer + " " + RTrim(cChkDesPer)
        aEval(oGetD2:aCols, {|x|, Iif(x[ nP02StaUsr ] == "31", nUsrPer++, Nil) })
        If nUsrPer > 0
            cMsg03 := "Existem " + cValToChar(nUsrPer) + " usuarios neste perfil!"
        EndIf
        If !u_AskYesNo(3500,"AjstPerf",cMsg01,cMsg02,cMsg03,"","Confirmar","UPDINFORMATION") // Confirmacao
            DbSelectArea("ZG1") // Perfis
            ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
            DbSelectArea("ZG2") // Usuarios Perfil
            ZG2->(DbSetOrder(1)) // ZG2_FILIAL + ZG2_CODPER
            DbSelectArea("ZG3") // Rotinas Perfil
            ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
            If ZG1->(DbSeek(_cFilZG1 + cChkCodPer))
                If ZG2->(DbSeek(_cFilZG2 + cChkCodPer))
                    While ZG2->(!EOF()) .And. ZG2->ZG2_FILIAL + ZG2->ZG2_CODPER == _cFilZG2 + cChkCodPer                
                        If nTipPrc == 5 // Excluir
                            RecLock("ZG2",.F.)
                            ZG2->(DbDelete())
                            ZG2->(MsUnlock())
                        ElseIf nTipPrc == 6 // Clonar
                            // Clonar usuarios do perfil
                            aAdd(aRecsZG2, { ZG2->ZG2_CODUSR, ZG2->ZG2_NOMUSR })
                        EndIf
                        ZG2->(DbSkip())
                    End
                EndIf
                If ZG3->(DbSeek(_cFilZG3 + cChkCodPer))
                    While ZG3->(!EOF()) .And. ZG3->ZG3_FILIAL + ZG3->ZG3_CODPER == _cFilZG3 + cChkCodPer
                        If nTipPrc == 5 // Excluir
                            RecLock("ZG3",.F.)
                            ZG3->(DbDelete())
                            ZG3->(MsUnlock())
                        ElseIf nTipPrc == 6 // Clonar
                            // Clonar rotinas do perfil
                            aAdd(aRecsZG3, { ZG3->ZG3_NOMROT, ZG3->ZG3_DESROT, ZG3->ZG3_CAGROT, ZG3->ZG3_CLSROT, ZG3->ZG3_STAROT })
                        EndIf
                        ZG3->(DbSkip())
                    End
                EndIf
                If nTipPrc == 5 // Excluir
                    RecLock("ZG1",.F.)
                    ZG1->ZG1_LGAPER := cChkLogReg
                    ZG1->(DbDelete())
                ElseIf nTipPrc == 6 // Clonar
                    ZG1->(DbGoBottom())
                    If ZG1->(!EOF())
                        cNxPer := ZG1->ZG1_CODPER
                    EndIf
                    RecLock("ZG1",.T.)
                    ZG1->ZG1_FILIAL := _cFilZG1
                    ZG1->ZG1_CODPER := Soma1(cNxPer)
                    ZG1->ZG1_DESPER := AllTrim(cChkDesPer) + " (Copia de " + cChkCodPer + ")"
                    ZG1->ZG1_LGIPER := cChkLogReg
                    ZG1->(MsUnlock())
                    // Clonar usuarios do perfil
                    For _w1 := 1 To Len(aRecsZG2)
                        RecLock("ZG2",.T.)
                        ZG2->ZG2_FILIAL := _cFilZG2
                        ZG2->ZG2_CODPER := ZG1->ZG1_CODPER
                        ZG2->ZG2_CODUSR := aRecsZG2[ _w1, 01 ]
                        ZG2->ZG2_NOMUSR := aRecsZG2[ _w1, 02 ]
                        ZG2->ZG2_LGIUSR := cChkLogReg
                        ZG2->(MsUnlock())
                        // Remover os usuarios do perfil clonado (nao pode duplicar)
                        If ZG2->(DbSeek(_cFilZG2 + cChkCodPer + aRecsZG2[ _w1, 01 ] ))
                            RecLock("ZG2",.F.)
                            ZG2->(DbDelete())
                            ZG2->(MsUnlock())
                        EndIf
                    Next
                    // Clonar rotinas do perfil (ZG3)
                    For _w1 := 1 To Len(aRecsZG3)
                        RecLock("ZG3",.T.)
                        ZG3->ZG3_FILIAL := _cFilZG3
                        ZG3->ZG3_CODPER := ZG1->ZG1_CODPER
                        ZG3->ZG3_NOMROT := aRecsZG3[ _w1, 01 ]
                        ZG3->ZG3_DESROT := aRecsZG3[ _w1, 02 ]
                        ZG3->ZG3_CAGROT := aRecsZG3[ _w1, 03 ]
                        ZG3->ZG3_CLSROT := aRecsZG3[ _w1, 04 ]
                        ZG3->ZG3_STAROT := aRecsZG3[ _w1, 05 ]
                        ZG3->ZG3_LGIROT := cChkLogReg
                        ZG3->(MsUnlock())
                    Next
                EndIf
                ZG1->(MsUnlock())
            EndIf
            // Recarregar
            u_AskYesNo(3500,"LoadPers","Carregando perfil...","Verificando...","","","","PROCESSA",.T.,.F.,{|| LoadsZG1( cGetCodUsr ) }) // Carrego os meus dados + dados dos outros perfis
        EndIf
    EndIf
EndIf
ConOut("AjstPerf: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlNomRot ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥26/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao do nome da rotina.                               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function VlNomRot()
Local lRet := .T.
Local cVlNomRot := &(ReadVar())
If !Empty( cVlNomRot ) // Rotina preenchida
    If Upper(Left(cVlNomRot,2)) == "U_" // Rotina customizada
        If !ExistBlock( RTrim(SubStr(cVlNomRot,3, Len(cVlNomRot))) ) // Rotina customizada nao compilada
            MsgStop("Rotina customizada nao encontrada no repositorio!" + Chr(13) + Chr(10) + ;
            "Rotina: " + cVlNomRot + Chr(13) + Chr(10) + ;
            "Verifique o preenchimento e tente novamente!","VlNomRot")
            lRet := .F.
        EndIf
    Else // Rotina padrao
        If !FindFunction( RTrim(cVlNomRot) ) // Rotina padrao nao encontrada
            MsgStop("Rotina padrao nao encontrada no repositorio!" + Chr(13) + Chr(10) + ;
            "Rotina: " + cVlNomRot + Chr(13) + Chr(10) + ;
            "Verifique o preenchimento e tente novamente!","VlNomRot")
            lRet := .F.
        EndIf
    EndIf
Else // Vazio
    cGetDesRot := Space(40)
    oGetDesRot:Refresh()
EndIf
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ VlDesRot ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥26/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao da descricao da rotina.                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function VlDesRot()
Local lRet := .T.
Return lRet

Static Function ProcsRot() // Inclusao de Rotina
Local lRet := .T.
Local nFind := 0
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
If Empty(cGetNomRot) // Nome da rotina nao preenchido
    MsgStop("Nome da Rotina nao preenchido!" + Chr(13) + Chr(10) + ;
    "Verifique o preenchimento e tente novamente!","VlDesRot")
    lRet := .F.
ElseIf Empty(cGetDesRot) // Descricao Rotina nao preenchida
    MsgStop("Descricao da Rotina nao preenchida!" + Chr(13) + Chr(10) + ;
    "Verifique o preenchimento e tente novamente!","VlDesRot")
    lRet := .F.
Else // Nome da Rotina e Descricao Preenchidos
    If (nFind := ASCan(oGetD3:aCols, {|x|, AllTrim(Upper(x[ nP03NomRot ])) == AllTrim(Upper(cGetNomRot)) })) > 0 // Rotina ja esta listada
        MsgStop("Rotina ja esta listada na linha " + cValToChar(nFind) + Chr(13) + Chr(10) + ;
        "Rotina: " + cGetNomRot + Chr(13) + Chr(10) + ;
        "Verifique o preenchimento e tente novamente!","VlDesRot")
        lRet := .F.
    Else // Incluir
        aAdd(oGetD3:aCols, { cGetNomRot, cGetDesRot, Space(03), Space(40), "I", "02", cChkLogReg, Space(40), Space(40), .F. })
        cGetNomRot := Space(15)
        oGetNomRot:Refresh()
        cGetDesRot := Space(40)
        oGetDesRot:Refresh()
        oGetD3:GoTo(Len(oGetD3:aCols))
        oGetD3:oBrowse:SetFocus()
        oGetD3:Refresh()
    EndIf
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadsZG1 ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento dos dados na ZG1 (Perfis)                     ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ cChkCodUsr: Codigo do usuario                              ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadsZG1(cChkCodUsr)
Local _z1
Local _w1
Local cStaPer := Space(02)
_oMeter:nTotal := 12
ConOut("LoadsZG1: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("ZG1")
ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
DbSelectArea("ZG2")
ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
DbSelectArea("Z1B") // Log Usuarios x Acessos Rotinas
Z1B->(DbSetOrder(1)) // Z1B_FILIAL + Z1B_USUARI + Z1B_ROTINA
DbSelectArea("Z1F") // Cadastro de Usuarios
Z1F->(DbSetOrder(1)) // Z1F_FILIAL + Z1F_COD
aCls01 := {}
nLineZG1 := 1
If Len(aAllUsr) == 0
    aAdd(aAllUsr, { cGetCodLog, Upper(cGetNomLog) })
    _oMeter:nTotal += 8
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"Carregando lista de usuarios...","Ultimos " + cValToChar(nDaysZ1B) + " dias de acesso ao sistema!","","",80,"PROCESSA")
        Sleep(040)
    Next
    // Filtro Z1B
    DbSelectArea("Z1B")
    cFilter := "DtoS(Z1B_DATA) >= '" + DtoS(Date() - nDaysZ1B) + "'"
    Z1B->(DbSetFilter({|| &(cFilter) }, cFilter))
    Z1F->(DbGotop())
    While Z1F->(!EOF())
        LoadUsrs(Z1F->Z1F_COD, nDaysZ1B, @aAllUsr) // Carrega lista de usuarios
        Z1F->(DbSkip())
    End
    Z1B->(DbClearFilter()) // Limpo filtro
    aSort(aAllUsr,,, {|x,y|, x[02] < y[02] }) // Ordenacao dos usuarios por Nome
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent,"Carregando lista de usuarios... Concluido!","Ultimos " + cValToChar(nDaysZ1B) + " dias de acesso ao sistema!","","",80,"OK")
        Sleep(040)
    Next
    LocToZG2() // Sincronizacao Dados do ZG2 local -> Banco
EndIf
// Parte 01: Carregamento do Perfil ligado ao usuario
For _z1 := 1 To 4
    u_AtuAsk09(++nCurrent,"Carregando lista de usuarios...","","","",80,"PROCESSA")
    Sleep(040)
Next

If !Empty(cChkCodUsr)
    If ZG2->(DbSeek(_cFilZG2 + cChkCodUsr))
        While ZG2->(!EOF()) .And. ZG2->ZG2_FILIAL + ZG2->ZG2_CODUSR == _cFilZG2 + cChkCodUsr
            If ZG1->(DbSeek(_cFilZG1 + ZG2->ZG2_CODPER))
                If ZG1->ZG1_STAPER $ "31/32/" //                   "31"=Perfil Aprovado
                    cStaPer := "31" // "01"=Perfil do Usuario Aprovado
                Else //                                         "01"=Perfil do Usuario Nao Aprovado
                    cStaPer := "01" // "01"=Perfil do Usuario Nao Aprovado
                EndIf
                //           {      Cod Perfil, Descricao Perfil, Status Perfil,    Log Inclusao,   Log Alteracao,   Log Aprovacao,    Log Gravacao, .F. }
                aAdd(aCls01, { ZG1->ZG1_CODPER,  ZG1->ZG1_DESPER,       cStaPer, ZG1->ZG1_LGIPER, ZG1->ZG1_LGAPER, ZG1->ZG1_LGLPER, ZG1->ZG1_LGGPER, .F. })
            EndIf
            ZG2->(DbSkip())
        End
    // Verifico se o usuario ainda nao tem perfil
    Else
        If !lCreaPer // Nao tem acesso para criar perfil, mas tem acesso Admin Perfil
            If Type("oGetD1") == "O"
                // Entao nao permite incluir/alterar o perfil ja criado
                aObjects := { "oSayCodPer", "oGetCodPer", "oGetDesPer", "oBtnNewPer" }
                For _w1 := 1 To Len(aObjects)
                    &(aObjects[ _w1 ]):lActive := .T.
                    &(aObjects[ _w1 ]):lVisible := .T.
                    &(aObjects[ _w1 ]):Refresh()
                Next
            EndIf
        EndIf
    EndIf

Else // Carregar todos os perfis
    ZG1->(DbGotop())
    While ZG1->(!EOF())
        If ZG2->(DbSeek(_cFilZG2 + cChkCodUsr + ZG1->ZG1_CODPER))
            If ZG1->ZG1_STAPER $ "31/32/" //                   "31"=Perfil do Usuario Aprovado      "32"=Outro Perfil Aprovado
                cStaPer := "31" // "31"=Perfil do Usuario Aprovado
            Else // "21"=Outro Perfil "01"=Perfil do Usuario
                cStaPer := "01" // "01"=Perfil do Usuario
            EndIf
        Else // De outro usuario
            If ZG1->ZG1_STAPER $ "31/32/" //                   "31"=Perfil do Usuario Aprovado      "32"=Outro Perfil Aprovado
                cStaPer := "32" // "32"=Outro Perfil Aprovado
            Else //                                         "21"=Outro Perfil
                cStaPer := "21" // "21"=Outro Perfil
            EndIf
        EndIf
        //           {      Cod Perfil, Descricao Perfil, Status Perfil,    Log Inclusao,   Log Alteracao,   Log Aprovacao,    Log Gravacao, .F. }
        aAdd(aCls01, { ZG1->ZG1_CODPER,  ZG1->ZG1_DESPER,       cStaPer, ZG1->ZG1_LGIPER, ZG1->ZG1_LGAPER, ZG1->ZG1_LGLPER, ZG1->ZG1_LGGPER, .F. })
        ZG1->(DbSkip())
    End
EndIf

For _z1 := 1 To 4
    u_AtuAsk09(++nCurrent,"Carregando lista de usuarios... Concluido!","","","",80,"OK")
    Sleep(040)
Next
If Len(aCls01) == 0
    aCls01 := u_ClearCls(aHdr01)
EndIf
If Type("oGetD1") == "O"
    oGetD1:aCols := aClone(aCls01)
    Eval(oGetD1:oBrowse:bChange)
    oGetD1:Refresh()
EndIf
ConOut("LoadsZG1: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

Static Function LoadUsrs(cChkCodUsr, nDaysZ1B, aAllUsr) // Avalio as rotinas do usuario se ele tem acessos conforme nDaysZ1B
Local _w
Z1B->(DbSetOrder(4)) // Z1B_FILIAL + Z1B_USUARI + Z1B_ROTINA + DtoS(Z1B_DATA) + Z1B_HORA
For _w := 1 To Len(aFlProc)
    Z1B->(DbSeek( aFlProc[ _w, 02 ] + cChkCodUsr ))
    While Z1B->(!EOF()) .And. Z1B->Z1B_FILIAL + Z1B->Z1B_USUARI == aFlProc[ _w, 02 ] + PadR(cChkCodUsr,14)
        // Posiciono na ultima data + hora da rotina
        Z1B->(DbSeek(aFlProc[ _w, 02 ] + PadR(cChkCodUsr,14) + Z1B->Z1B_ROTINA + "99991231",.T.))
        Z1B->(DbSkip(-1))
        If Z1B->(!EOF()) .And. Left(Z1B->Z1B_USUARI,14) == PadR(cChkCodUsr,14) .And. Date() - Z1B->Z1B_DATA <= nDaysZ1B // Acesso a menos de ?? dias
            If ASCan(aAllUsr, {|x|, PadR(x[01],14) == Left(Z1B->Z1B_USUARI,14) }) == 0 // Usuario ainda nao considerado
                //            {              Cod Usuario,  Nome Usuario }
                aAdd(aAllUsr, { Left(Z1B->Z1B_USUARI,06), Z1B->Z1B_NOME })
                _w := Len(aFlProc) + 1
                Exit
            EndIf
        EndIf
        Z1B->(DbSkip())
    End
Next
Z1B->(DbSetOrder(1)) // Z1B_FILIAL + Z1B_USUARI + Z1B_ROTINA
Return aAllUsr

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadsZG2 ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento dos dados na ZG2 (Usuarios)                   ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ cChkCodUsr: Codigo do usuario                              ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadsZG2()
Local _w
Local cChkCodPer := Space(06)
Local nLenUsrZG2 := 0
ConOut("LoadsZG2: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("ZG2")
ZG2->(DbSetOrder(1)) // ZG2_FILIL + ZG2_CODPER + ZG2_CODUSR
aCls02 := {}
nLineZG2 := 1
If Type("oGetD2") == "O" .And. oGetD1:nAt > 0 .And. oGetD1:nAt <= Len(oGetD1:aCols)
    cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
    // Parte 02: Carregamento de todos os usuarios ligados ao perfil
    If !Empty(cChkCodPer)
        If ZG2->(DbSeek(_cFilZG2 + cChkCodPer))
            While ZG2->(!EOF()) .And. ZG2->ZG2_FILIAL + ZG2->ZG2_CODPER == _cFilZG2 + cChkCodPer
                If ZG2->ZG2_CODUSR == cGetCodLog .Or. lAdmnPer // Usuario em questao ou todos os usuarios ligados ao perfil se for administrador de perfis
                    //           {  Codigo Usuario,    Nome Usuario, Usuario do Perfil,    Log Inclusao, .F. }
                    aAdd(aCls02, { ZG2->ZG2_CODUSR, ZG2->ZG2_NOMUSR,              "31", ZG2->ZG2_LGIUSR, .F. })                    // "31"=Usuario do Perfil       "51"=Outros Usuarios
                EndIf
                ZG2->(DbSkip())
            End
        EndIf
        aSort(aCls02,,, {|x,y|, x[ nP02NomUsr ] < y[ nP02NomUsr ] }) // Ordenacao por Nome do Usuario
        nLenUsrZG2 := Len( aCls02 ) // Matriz dos usuarios na ZG2
        // Parte 03: Carregamento de todos os demais usuarios existentes
        If lAdmnPer // Administrador de perfis
            ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER        

            If !lChkDepart // .F.=Todos os usuarios .T.=Apenas usuarios dos departamentos

                For _w := 1 To Len(aAllUsr)
                    ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
                    If ZG2->(!DbSeek(_cFilZG2 + aAllUsr[ _w, 01 ])) // Tambem nao pode ser um usuario que ja possui algum perfil
                        //           {   Codigo Usuario,     Nome Usuario, Outros Usuarios, Log Inclusao, .F. }
                        aAdd(aCls02, { aAllUsr[ _w, 01], aAllUsr[ _w, 02],            "51",    Space(40), .F. })            // "51"=Outros Usuarios
                    EndIf
                Next

            EndIf

            For _w := 1 To Len(aUsrDepts) // Usuario conforme departamentos
                If ZG2->(!DbSeek(_cFilZG2 + aUsrDepts[ _w, 10 ])) // Tambem nao pode ser um usuario que ja possui algum perfil
                    If ASCan( aCls02, {|x|, x[01] == aUsrDepts[ _w, 10 ] }) == 0 // Usuario ainda nao considerado
                        //           {     Codigo Usuario,                   Nome Usuario, Outros Usuarios, Log Inclusao, .F. }
                        aAdd(aCls02, { aUsrDepts[ _w, 10], UsrRetName(aUsrDepts[ _w, 10]),            "51",    Space(40), .F. })            // "51"=Outros Usuarios
                    EndIf
                EndIf
            Next

            If Len(aCls02) > nLenUsrZG2
                aSort(aCls02, nLenUsrZG2 + 1, Len(aCls02), {|x,y|, x[ nP02NomUsr ] < y[ nP02NomUsr ] }) // Ordenacao por Nome do Usuario (dos outros usuarios que nao estao no ZG2)
            EndIf
        EndIf
    EndIf
EndIf
If Len(aCls02) == 0
    aCls02 := u_ClearCls(aHdr02)
EndIf
If Type("oGetD2") == "O"
    oGetD2:aCols := aClone(aCls02)
    Eval(oGetD2:oBrowse:bChange)
    oGetD2:Refresh()
EndIf
ConOut("LoadsZG2: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadsZG3 ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento de dados na ZG3 (Rotinas).                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadsZG3()
Local nLenRotZG3 := 0
Local cChkCodPer := Space(06)
Local cChkCodUsr := Space(06)
ConOut("LoadsZG3: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
aCls03 := {}
nLineZG3 := 1
If Type("oGetD1") == "O" .And. oGetD1:nAt > 0 .And. oGetD1:nAt <= Len(oGetD1:aCols)
    If Type("oGetD2") == "O" .And. oGetD2:nAt > 0 .And. oGetD2:nAt <= Len(oGetD2:aCols)
        cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
        cChkCodUsr := oGetD2:aCols[ oGetD2:nAt, nP02CodUsr ]
        // Carregamento das rotinas do perfil
        If !Empty( cChkCodPer ) .And. !Empty( cChkCodUsr )
            DbSelectArea("ZG7")
            ZG7->(DbSetOrder(1)) // ZG7_FILIAL + ZG7_CODAGR
            DbSelectArea("ZG3")
            ZG3->(DbSetOrder(1)) // ZG3_FILIAL + ZG3_CODPER + ZG3_NOMROT
            If ZG3->(DbSeek(_cFilZG3 + cChkCodPer))
                While ZG3->(!EOF()) .And. ZG3->ZG3_FILIAL + ZG3->ZG3_CODPER == _cFilZG3 + cChkCodPer
                    If ZG7->(DbSeek(_cFilZG7 + ZG3->ZG3_CAGROT))
                        //           {     Nome Rotina, Descricao Rotina, Cod Agrupamento, Des Agrupamento, Classif Rotina,   Status Rotina,    Log Inclusao,   Log Alteracao,   Log Aprovacao, .F. }
                        aAdd(aCls03, { ZG3->ZG3_NOMROT,  ZG3->ZG3_DESROT, ZG7->ZG7_CODAGR, ZG7->ZG7_DESAGR, ZG3->ZG3_CLSROT, ZG3->ZG3_STAROT, ZG3->ZG3_LGIROT, ZG3->ZG3_LGAROT, ZG3->ZG3_LGLROT, .F. })
                    EndIf
                    ZG3->(DbSkip())
                End
                aSort(aCls03,,, {|x,y|, x[ nP03DesRot ] < y[ nP03DesRot ] }) // Ordenacao por Descricao da Rotina
                nLenRotZG3 := Len( aCls03 ) // Matriz dos usuarios na ZG3
            EndIf
            // Carregamento de todas as rotinas executadas pelo usuario posicionado
            LoadRots(cChkCodUsr, @aCls03)
            If Len(aCls03) > nLenRotZG3
                aSort(aCls03, nLenRotZG3 + 1, Len(aCls03), {|x,y|, x[ nP03DesRot ] < y[ nP03DesRot ] }) // Ordenacao por Descricao da Rotina (das outras rotinas que nao estao na ZG3)
            EndIf
        EndIf
    EndIf
EndIf
If Len(aCls03) == 0
    aCls03 := u_ClearCls(aHdr03)
EndIf
If Type("oGetD3") == "O"
    oGetD3:aCols := aClone(aCls03)
    oGetD3:Refresh()
EndIf
ConOut("LoadsZG3: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

Static Function LoadRots(cChkCodUsr, aCls03) // Carrega lista de rotinas usadas pelo usuario
Local _w
DbSelectArea("Z1B")
Z1B->(DbSetOrder(4)) // Z1B_FILIAL + Z1B_USUARI + Z1B_ROTINA + DtoS(Z1B_DATA) + ...
For _w := 1 To Len(aFlProc)
    If Z1B->(DbSeek( aFlProc[ _w, 02 ] + PadR(cChkCodUsr,14)))
        While Z1B->(!EOF()) .And. Z1B->Z1B_FILIAL + Left(Z1B->Z1B_USUARI,14) == aFlProc[ _w, 02 ] + PadR(cChkCodUsr,14)
            If ASCan(aCls03, {|x|, x[01] == Z1B->Z1B_ROTINA }) == 0 // Rotina ainda nao considerada
                //            {     Nome Rotina, Descricao Rotina, Cod Agrupamento, Des Agrupamento, Classif Rotina, Status Rotina,    Log Inclusao,   Log Alteracao,   Log Aprovacao, .F. }
                aAdd( aCls03, { Z1B->Z1B_ROTINA,  Z1B->Z1B_NOMERO,       Space(03),       Space(40),            "I",          "01",       Space(40),       Space(40),       Space(40), .F. })
            EndIf
            Z1B->( DbSeek( aFlProc[ _w, 02 ] + PadR(cChkCodUsr,14) + Z1B->Z1B_ROTINA + DtoS(Date() + 1), .T. ))
        End
    EndIf
Next
Return aCls03

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ProcPers ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥20/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processamento do perfil aprovado que esta selecionado.     ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Consiste em 3 partes:                                      ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parte 01: Carregamento dos dados (Rotinas)                 ∫±±
±±∫          ≥ Parte 02: Avaliacao das rotinas (menus .XNU)               ∫±±
±±∫          ≥ Parte 03: Gravacao e envio para o servidor                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ProcPers()
Local aRet := {}
Local aItsMenu := {}
Local cArqMenu := ""
Local cDirMenu := "\MENUS_ZG1"
// Variaveis checagem
Local cChkCodPer := Space(06)
Local cChkDesPer := Space(40)
// Variaveis de mensagem
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
ConOut("ProcPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Parte 01: Carregamento dos dados (Rotinas) 
u_AskYesNo(1200,"LoadPers","Gravacao do perfil no servidor","Carregando dados...","","","","PROCESSA",.T.,.F.,{|| aRet := LoadPers() })
If aRet[01] // .T.=Valido
    If Len(aRet [ 03 ]) > 0 // Rotinas do menu carregadas
        cChkCodPer := aRet[02]
        cChkDesPer := aRet[03]
        aItsMenu := aRet[04]
        // Parte 02: Avaliacao das rotinas (menus .XNU)
        u_AskYesNo(1200,"ChksPers","Gravacao do perfil no servidor","Avaliando itens do menu...","","","","PROCESSA",.T.,.F.,{|| aRet := ChksPers(cChkCodPer, cChkDesPer, aItsMenu) })
        If aRet[01] // .T.=Valido
            If Len(aRet [ 02 ]) > 0 // Rotinas do menu carregadas
                aItsMenu := aRet[02]
                // Parte 03: Gravacao e envio para o servidor
                cArqMenu := cChkCodPer + ".XNU"
                If File(cDirMenu + "\" + cArqMenu) // Arquivo no servidor
                    cMsg01 := "Deseja 'sobrepor' o arquivo de menu do perfil selecionado?"
                Else
                    cMsg01 := "Deseja 'criar' o menu do perfil selecionado?"
                EndIf
                cMsg02 := "Arquivo de Menu no Servidor: " + cDirMenu + "\" + cArqMenu
                If !u_AskYesNo(4500,"GrvsPers",cMsg01,cMsg02,cMsg03,"","Confirmar","UPDINFORMATION") // Confirmacao
                    u_AskYesNo(1200,"GrvsPers","Gravacao do perfil no servidor","Gravando menu...","","","","PROCESSA",.T.,.F.,{|| GrvsPers(cChkCodPer, cChkDesPer, aItsMenu) })
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
ConOut("ProcPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadPers ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥20/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Parte 01: Carregamento dos dados (Rotinas)                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadPers()
Local z
Local _w1
Local _w2
Local _w3
Local aItsMenu := {}
// Variaveis de posicionamento
Local cChkCodPer := Space(06)
Local cChkDesPer := Space(40)
// Variaveis de agrupamento das rotinas
Local aAgrup := {}
// Variaveis de classificacao das rotinas
Local aClass := {}
Private cClass := ""
_oMeter:nTotal := 12
ConOut("LoadPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
For _w1 := 1 To 4
    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Avaliando itens do menu...", "", "", 80, "PROCESSA")
    Sleep(050)
Next
DbSelectArea("ZG1")
ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
If oGetD1:nAt > 0 .And. oGetD1:nAt <= Len(oGetD1:aCols) // Posicionamento conforme GetD1
    cChkCodPer := oGetD1:aCols[ oGetD1:nAt, nP01CodPer ]
    cChkDesPer := oGetD1:aCols[ oGetD1:nAt, nP01DesPer ]
    For z := 1 To 4
        u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Carregando itens do menu...", "", 80, "PROCESSA")
        Sleep(150)
    Next
    If oGetD1:aCols[ oGetD1:nAt, nP01StaPer ] $ "31/32/" // Perfil aprovado
        If ZG1->(DbSeek(_cFilZG1 + oGetD1:aCols[ oGetD1:nAt, nP01CodPer ])) // Posiciono ZG1
            cClass := oGetD3:aHeader[ nP03ClsRot, 11 ] // "I=Indefinida;C=Cadastros;R=Relatorios;P=Processamentos;D=Diversos"            
            If !Empty(oGetD3:aCols[ oGetD3:nAt, nP03CAgRot ]) .And. !Empty(cClass)
                aClass := StrToKarr(cClass,";")
                cClass := ""
                aEVal(aClass, {|x|, cClass += Left(x, At("=",x) - 1) + ";" })
                aClass := StrToKarr(cClass,";")
                DbSelectArea("ZG7")
                ZG7->(DbSetOrder(1)) // ZG7_FILIAL + ZG7_CODAGR
                ZG7->(DbGotop())
                While ZG7->(!EOF())
                    aAdd(aAgrup, { ZG7->ZG7_CODAGR, ZG7->ZG7_DESAGR })
                    ZG7->(DbSkip())
                End
                For _w1 := 1 To Len( aAgrup ) // Rodo nos agrupamentos
                    For _w2 := 1 To Len(aClass) // Rodo nas classificacoes
                        For _w3 := 1 To Len(oGetD3:aCols)
                            If oGetD3:aCols[ _w3, nP03StaRot ] $ "71/72/" // "71"=Rotina Aprovada   "72"=Rotina Aprovada
                                If oGetD3:aCols[ _w3, nP03CAgRot ] == aAgrup[ _w1, 01 ] // Agrupamento conforme
                                    If oGetD3:aCols[ _w3, nP03ClsRot ] == aClass[ _w2 ]     // Classificacao conforme
                                        //             {                  Nome da Rotina,             Descricao da Rotina,              Codigo Agrupamento,       Classif, Linhas do Item do menu }
                                        aAdd(aItsMenu, { oGetD3:aCols[ _w3, nP03NomRot ], oGetD3:aCols[ _w3, nP03DesRot ], oGetD3:aCols[ _w3, nP03CAgRot ], aClass[ _w2 ],               Array(0) })
                                    EndIf
                                EndIf
                            EndIf
                        Next
                    Next
                Next
            EndIf
        EndIf
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer, "Itens de menu carregados " + cValToChar(Len(aItsMenu)), "", 80, "PROCESSA")
            Sleep(150)
        Next
    Else // Perfil nao esta aprovado
        ConOut("LoadPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Este perfil ainda nao esta aprovado!")
        ConOut("LoadPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " So podera ser gerado menu para perfil aprovado!")
        ConOut("LoadPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Perfil: " + cChkCodPer + " " + cChkDesPer)
        For _w1 := 1 To 4
            u_AtuAsk09(nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer, "Este perfil ainda nao esta aprovado!", "So podera ser gerado menu para perfil aprovado!", 80, "UPDERROR")
            Sleep(150)
        Next
        Return { .F., cChkCodPer, cChkDesPer, aItsMenu }
    EndIf
EndIf
ConOut("LoadPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return { .T., cChkCodPer, cChkDesPer, aItsMenu }

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ChksPers ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥20/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Parte 02: Avaliacao das rotinas (menus .XNU)               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ChksPers(cChkCodPer, cChkDesPer, aItsMenu)
Local z
Local _w1
Local _w2
Local _w3
Local aChkMenu := {}
Local cChkMenu := ""
// Variaveis de checagem
Local cChkRoti := ""
Local cChkDesc := ""
Local cChkType := ""
// Variaveis de Diretorios
Local aChkDirs := { "\MENUS_ZG1", "\SYSTEM" }
Local cChkDirs := ""
_oMeter:nTotal := 12 + (Len(aItsMenu) * 4)
ConOut("ChksPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
For z := 1 To 4
    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Preparando gravacao do menu...", "", 80, "PROCESSA")
    Sleep(150)
Next
// Trecho de pesquisa de rotinas
_w1 := 1
While _w1 <= Len(aItsMenu)
    cChkRoti := RTrim(aItsMenu[ _w1, 01 ])  // Nome da Rotina
    cChkDesc := RTrim(aItsMenu[ _w1, 02 ])  // Descricao da Rotina
    If Upper(Left(cChkRoti,2)) == "U_"      // User Function
        cChkType := "03"
        cChkRoti := SubStr(cChkRoti,3,15)
    Else                                    // Rotina padrao
        cChkType := "01"
    EndIf
    For z := 1 To 4
        u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Procudando rotina: " + cChkRoti + " " + cChkDesc, "", 80, "PROCESSA")
        Sleep(050)
    Next
    // Carregando menus
    _w2 := 1
    While _w2 <= Len(aChkDirs) .And. Len(aItsMenu[_w1,05]) == 0 // Diretorios de checagem
        cChkDirs := aChkDirs[ _w2 ]
        aChkMenu := Directory(cChkDirs + "\*.XNU")
        If Len(aChkMenu) > 0
            aSort(aChkMenu,,, {|x,y|, DtoS(x[ 03 ]) + x[ 04 ] > DtoS(y[ 03 ]) + y[ 04 ] }) // Do mais recente ate o mais antigo
            _w3 := 1
            While _w3 <= Len(aChkMenu) .And. Len(aItsMenu[ _w1, 05 ]) == 0 // Rodo em cada arquivo de menu do diretorio
                // Avaliando rotinas de menu existentes no arquivo
                cChkMenu := cChkDirs + "\" + aChkMenu[ _w3, 01 ]
                If File(cChkMenu) // Arquivo existe
                    If Upper(aChkMenu[ _w3, 01 ]) <> Upper(ZG1->ZG1_CODPER + ".XNU") // Nao pode haver procura nele mesmo
                        nRet := FT_FUse(cChkMenu)
                        If nRet > 0 // Sucesso na abertura
                            FT_FGOTOP()
                            FT_FSkip() // Pula cabecalho
                            While (!FT_FEOF()) .And. Len(aItsMenu[ _w1, 05 ]) == 0 // Ainda nao encontado
                                cBuffer := FT_FREADLN()
                                If Upper("<Function>" + cChkRoti + "</Function>") $ Upper(cBuffer) // Localizo a funcao
                                    FT_FSkip() // Pula o Function
                                    cBuffer := FT_FREADLN()
                                    If Upper("<Type>" + cChkType + "</Type>") $ Upper(cBuffer) // Localizo a funcao
                                        // Rotina localizada
                                        aAdd(aItsMenu[ _w1, 05], '<MenuItem Status="Enable">')
                                        aAdd(aItsMenu[ _w1, 05], '<Title lang="pt">' + cChkDesc + '</Title>')
                                        aAdd(aItsMenu[ _w1, 05], '<Title lang="es">' + cChkDesc + '</Title>')
                                        aAdd(aItsMenu[ _w1, 05], '<Title lang="en">' + cChkDesc + '</Title>')
                                        aAdd(aItsMenu[ _w1, 05], '<Function>' + cChkRoti + '</Function>')
                                        aAdd(aItsMenu[ _w1, 05], '<Type>' + cChkType + '</Type>')
                                        FT_FSkip() // Pula o Type
                                        While (!FT_FEOF())
                                            cBuffer := FT_FREADLN()
                                            aAdd(aItsMenu[ _w1, 05], AllTrim( StrTran(cBuffer, Chr(09), "") ))
                                            If Upper("</MenuItem>") $ Upper(cBuffer)
                                                Exit
                                            EndIf
                                            FT_FSkip() // Pula
                                        End
                                        For z := 1 To 4
                                            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Rotina Localizada: " + cChkRoti + " " + cChkDesc, "Arquivo XNU: " + cChkMenu, 80, "BMPVISUAL")
                                            Sleep(100)
                                        Next
                                    EndIf
                                EndIf
                                FT_FSkip() // Pula
                            End
                            FT_FUse() // Fecha o arquivo
                        EndIf
                    EndIf
                EndIf
                _w3++
            End
        EndIf
        _w2++
    End
    // Verificando se o item do menu foi localizado
    If Len(aItsMenu[_w1,05]) == 0 // Dados nao carregados
        ConOut("ChksPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Item de Menu nao encontrado em nenhum dos menus procurados!")
        ConOut("ChksPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Item Menu: " + cChkRoti + " " + cChkDesc)
        For z := 1 To 4
            u_AtuAsk09(nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer, "Item de Menu nao encontrado em nenhum dos menus procurados!", "Item Menu: " + cChkRoti + " " + cChkDesc, 80, "UPDWARNING")
            Sleep(500)
        Next

        // Rotina incluida de forma generica
        aAdd(aItsMenu[ _w1, 05], '<MenuItem Status="Enable">')
        aAdd(aItsMenu[ _w1, 05], '<Title lang="pt">' + cChkDesc + '</Title>')
        aAdd(aItsMenu[ _w1, 05], '<Title lang="es">' + cChkDesc + '</Title>')
        aAdd(aItsMenu[ _w1, 05], '<Title lang="en">' + cChkDesc + '</Title>')
        aAdd(aItsMenu[ _w1, 05], '<Function>' + cChkRoti + '</Function>')
        aAdd(aItsMenu[ _w1, 05], '<Type>' + cChkType + '</Type>')

        aAdd(aItsMenu[ _w1, 05], '<Access>xxxxxxxxxx</Access>')
        aAdd(aItsMenu[ _w1, 05], '<Module>05</Module>')
        aAdd(aItsMenu[ _w1, 05], '<Owner>0</Owner>')
        aAdd(aItsMenu[ _w1, 05], '<KeyWord>')
        aAdd(aItsMenu[ _w1, 05], '<KeyWord lang="pt"></KeyWord>')
        aAdd(aItsMenu[ _w1, 05], '<KeyWord lang="es"></KeyWord>')
        aAdd(aItsMenu[ _w1, 05], '<KeyWord lang="en"></KeyWord>')
        aAdd(aItsMenu[ _w1, 05], '</KeyWord>')
        aAdd(aItsMenu[ _w1, 05], '</MenuItem>')

        // Return { .F., aItsMenu }
    EndIf
    _w1++
End
ConOut("ChksPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return { .T., aItsMenu }

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ GrvsPers ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥20/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Parte 03: Gravacao e envio para o servidor                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function GrvsPers(cChkCodPer, cChkDesPer, aItsMenu)
Local z
Local _w1
Local _w2
Local nRet := 0
Local aClsMenu := {}
// Variaveis de montagem
Local aLnsMenu := {}
Local aCabMenu := {}
Local aEndMenu := {}
// Variaveis de gravacao
Local cDirMenu := "\MENUS_ZG1"
Local cArqMenu := ZG1->ZG1_CODPER + ".XNU"
Local cLinMenu := ""
Local cChkLogReg := DtoC(Date()) + " " + Time() + " " + cUserName
_oMeter:nTotal := 12
ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
For z := 1 To 4
    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Gravando menu...", "", 80, "PROCESSA")
    Sleep(150)
Next
// Parte 01: Carregamento do cabecalho do menu:
/*
<ApMenu>
    <DocumentProperties>
        <Module></Module>
        <Version>10.1</Version>
    </DocumentProperties>
*/
aCabMenu := { '<ApMenu>', '<DocumentProperties>', '<Module></Module>', '<Version>10.1</Version>', '</DocumentProperties>' }
For _w1 := 1 To Len(aCabMenu)
    aAdd(aLnsMenu, aCabMenu[_w1])
Next
// Parte 02: Carregamento de cada conjunto de itens de menu conforme as classificacoes
cClass := oGetD3:aHeader[ nP03ClsRot, 11 ]
aClass := StrToKarr(cClass,";")
aAgrMenu := {}
aClsMenu := {}
For _w1 := 1 To Len(aItsMenu)
    If ASCan(aAgrMenu, {|x|, x == aItsMenu[ _w1, 03 ] }) == 0 // Agrupamento ainda nao considerado
        // Verificar se preciso fechar o agrupamento anterior
        If _w1 > 1 // Fechar a anterior
            aAdd(aLnsMenu, '</Menu>')   // Fecho a Classificacao anterior
            aAdd(aLnsMenu, '</Menu>')   // Fecho o menu anterior
        EndIf
        aAdd(aAgrMenu, aItsMenu[ _w1, 03 ])
        If ZG7->(DbSeek(_cFilZG7 + aItsMenu[ _w1, 03 ]))
            aAdd(aLnsMenu, '<Menu Status="Enable">')
            aAdd(aLnsMenu, '<Title lang="pt">&' + AllTrim(ZG7->ZG7_DESAGR) + '</Title>')
            aAdd(aLnsMenu, '<Title lang="es">&' + AllTrim(ZG7->ZG7_DESAGR) + '</Title>')
            aAdd(aLnsMenu, '<Title lang="en">&' + AllTrim(ZG7->ZG7_DESAGR) + '</Title>')
        EndIf
        aClsMenu := {} // Limpo Classificacoes pois eh um novo Modulo
    EndIf
    If ASCan(aClsMenu, {|x|, x == aItsMenu[ _w1, 04 ] }) == 0 // Classificacao ainda nao considerada
        // Verificar se preciso fechar a anterior
        If Len(aClsMenu) > 0 // Fechar a anterior
            aAdd(aLnsMenu, '</Menu>')
        EndIf
        // Parte 03: Carregamento dos fechamentos
        aAdd(aClsMenu, aItsMenu[ _w1, 04 ])
        If (nFind := ASCan(aClass, {|x|, Left(x,1) == aItsMenu[ _w1, 04 ] })) > 0 // Descricao da classificacao encontrada
            // Parte 04: Carregamento dos menus das classificacoes
            /*
            <Menu Status="Enable">
                <Title lang="pt">&AtualizaÁıes</Title>
                <Title lang="es">&Actualizaciones</Title>
                <Title lang="en">&Updates</Title>
            */
            aAdd(aLnsMenu, '<Menu Status="Enable">')
            aAdd(aLnsMenu, '<Title lang="pt">&' + AllTrim(SubStr(aClass[ nFind ], 3, Len(aClass[nFind]) )) + '</Title>')
            aAdd(aLnsMenu, '<Title lang="es">&' + AllTrim(SubStr(aClass[ nFind ], 3, Len(aClass[nFind]) )) + '</Title>')
            aAdd(aLnsMenu, '<Title lang="en">&' + AllTrim(SubStr(aClass[ nFind ], 3, Len(aClass[nFind]) )) + '</Title>')
        EndIf
    EndIf
    // Parte 05: Gravacao dos itens de menu ja trabalhados na aItsMenu
    For _w2 := 1 To Len(aItsMenu [ _w1, 05 ])
        aAdd(aLnsMenu, aItsMenu [ _w1, 05, _w2 ])
    Next
Next

// Parte 06: Fechamento do ultimo modulo e do ultimo menu carregado
aEndMenu := { '</Menu>', '</Menu>', '</ApMenu>' }
For _w1 := 1 To Len(aEndMenu)
    aAdd(aLnsMenu, aEndMenu[_w1])
Next
// Parte 07: Adequacoes de tabulacoes
nNiv := 0
For _w1 := 1 To Len(aLnsMenu)                        
    If At("</", aLnsMenu[ _w1 ]) == 0 // Se nao tem nenhum fechamento, sobe nivel e no prox sera o nivel novo
        aLnsMenu[ _w1 ] := Replicate( Chr(09), nNiv ) + aLnsMenu[ _w1 ]
        nNiv++
    ElseIf Left(aLnsMenu[ _w1 ],2) == "</"    // Ele ja inicia fechando, reduz nivel e ja ajusta
        nNiv--
        aLnsMenu[ _w1 ] := Replicate( Chr(09), nNiv ) + aLnsMenu[ _w1 ]
    Else // Mantem o nivel
        aLnsMenu[ _w1 ] := Replicate( Chr(09), nNiv ) + aLnsMenu[ _w1 ]
        nNiv := nNiv
    EndIf
Next
// Gravacoes dos dados nos arquivos
If !File("C:\TEMP")	// Verifico se o diretorio existe
    nRet := MakeDir("C:\TEMP") // Cria a pasta local
    If nRet < 0 // Falha na criacao do diretorio
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na criacao do diretorio local!")
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Diretorio: C:\TEMP\")
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha na criacao do diretorio local!", "Diretorio: C:\TEMP\", 80, "UPDERROR")
            Sleep(500)
        Next
        Return
    EndIf
EndIf
If File("C:\TEMP\" + cArqMenu)
    nRet := fErase("C:\TEMP\" + cArqMenu)
    If nRet < 0 // Falha na exclusao do arquivo
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na exclusao do arquivo local!")
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha na exclusao do arquivo local!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "UPDERROR")
            Sleep(500)
        Next
        Return
    EndIf
EndIf
ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Criando o arquivo de perfil...")
ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
For z := 1 To 4
    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Criando o arquivo do perfil...", "Arquivo: C:\TEMP\" + cArqMenu, 80, "PROCESSA")
    Sleep(150)
Next
nHdl := fCreate("C:\TEMP\" + cArqMenu) // Cria arquivo txt
If nHdl > 0 // Criado com sucesso
    For _w1 := 1 To Len(aLnsMenu)
        cLinMenu := aLnsMenu[ _w1 ] + Chr(13) + Chr(10)
        fWrite(nHdl, cLinMenu, Len(cLinMenu) )
    Next
    lRet := fClose(nHdl) // Fecha arquivo
    If lRet // .T.=Sucesso no fechamento
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Criando o arquivo do perfil... Concluido!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "OK")
            Sleep(150)
        Next
        cRootPath := GetSrvProfString ("ROOTPATH","") + cDirMenu    // Ex: D:\TOTVS\Microsiga\Protheus12\protheus_dataD03\MENUS_ZG1
        If !File(cDirMenu) // Diretorio no servidor ainda nao existe
            nRet := MakeDir(cDirMenu)
            If nRet < 0 // Falha na criacao do diretorio de menus no servidor
                ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na criacao do diretorio do arquivo no servidor!")
                ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Diretorio: " + cDirMenu)
                For z := 1 To 4
                    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha na criacao do diretorio do arquivo no servidor!", "Diretorio: " + cDirMenu, 80, "UPDERROR")
                    Sleep(500)
                Next
                Return
            EndIf
        EndIf
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Enviando arquivo gerado para o servidor...")
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: " + cDirMenu + "\" + cArqMenu)
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Enviando arquivo gerado para o servidor...", "Arquivo: " + cDirMenu + "\" + cArqMenu, 80, "PROCESSA")
            Sleep(150)
        Next
        // Envio do arquivo para o servidor
        lRet := CpyT2S("C:\TEMP\" + cArqMenu, cDirMenu, .F.)
        If lRet // Sucesso
            For z := 1 To 4
                u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Enviando arquivo gerado para o servidor... Sucesso!", "Arquivo: " + cDirMenu + "\" + cArqMenu, 80, "OK")
                Sleep(150)
            Next
            If !File( cDirMenu + "\" + cArqMenu ) // Falha no envio para o servidor
                ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha no envio do arquivo para o servidor!")
                ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
                For z := 1 To 4
                    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha no envio do arquivo para o servidor!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "UPDERROR")
                    Sleep(500)
                Next
            Else // Sucesso
                RecLock("ZG1",.F.)
                ZG1->ZG1_LGGPER := cChkLogReg
                ZG1->(MsUnlock())
                oGetD1:aCols[ oGetD1:nAt, nP01LgGPer ] := cChkLogReg
                oGetD1:Refresh()
                ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processo concluido com sucesso!")
                For z := 1 To 4
                    u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Processo concluido com Sucesso!", "Arquivo: " + cDirMenu + "\" + cArqMenu, 80, "OK")
                    Sleep(200)
                Next
            EndIf
        Else // Falha no envio para o servidor
            ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha no envio do arquivo para o servidor!")
            ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
            For z := 1 To 4
                u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha no envio do arquivo para o servidor!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "UPDERROR")
                Sleep(500)
            Next
        EndIf
    Else // Falha na gravacao do fechamento do arquivo
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na gravacao do fechamento do arquivo!")
        ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
        For z := 1 To 4
            u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha na gravacao do fechamento do arquivo!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "UPDERROR")
            Sleep(500)
        Next
    EndIf
Else // Falha na geracao do arquivo
    ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na geracao do arquivo!")
    ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: C:\TEMP\" + cArqMenu)
    For z := 1 To 4
        u_AtuAsk09(++nCurrent,"Gravacao do perfil no servidor","Perfil: " + cChkCodPer + " " + cChkDesPer,"Falha na geracao do arquivo!", "Arquivo: C:\TEMP\" + cArqMenu, 80, "UPDERROR")
        Sleep(500)
    Next
EndIf
ConOut("GrvsPers: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LocToZG2 ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥21/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Atualiza a ZG2 do banco com o ZG2 em CTree                 ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Este processamento deve ser realizado para manter as duas  ∫±±
±±∫          ≥ bases sincronizadas.                                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LocToZG2()
Local nOpcao := 0
Local cFileZG2 := "\SYSTEM\ZG20101_" + cDbfDtc
ConOut("LocToZG2: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If File(cFileZG2) // Arquivo existe
    If Select("TRBZG2") > 0
        TRBZG2->(DbCloseArea())
    EndIf
    Use &(cFileZG2) Shared New Alias "TRBZG2" VIA TOPCONN // adicionado o driver TOPCONN \Ajustado
    DbSelectArea("TRBZG2")
    TRBZG2->(DbGotop())
    DbSelectArea("ZG2") // Usuarios Perfil
    ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
    While TRBZG2->(!EOF())
        If ZG2->(!MsSeek(_cFilZG2 + TRBZG2->ZG2_CODUSR + TRBZG2->ZG2_CODPER))
            If nOpcao <> 2 .And. nOpcao <> 4
                nOpcao := Aviso("Transferencia ZG2 ",;
                "Transfere do arquivo DBFDTC para o ZG2 o usuario: " + TRBZG2->ZG2_CODUSR + "?" + Chr(13) + Chr(10) + ;
                "UserName: " + UsrRetName(TRBZG2->ZG2_CODUSR) + Chr(13) + Chr(10) + ;
                "Perfil: " + TRBZG2->ZG2_CODPER, { "Sim", "Sim Todos", "Nao", "Nao Todos" })
            EndIf
            If nOpcao == 1 .Or. nOpcao == 2 // 1=Sim 2=Sim Todos
                RecLock("ZG2",.T.)
                ZG2->ZG2_FILIAL := _cFilZG2
                ZG2->ZG2_CODPER := TRBZG2->ZG2_CODPER
                ZG2->ZG2_CODUSR := TRBZG2->ZG2_CODUSR
                ZG2->ZG2_NOMUSR := TRBZG2->ZG2_NOMUSR
                ZG2->ZG2_LGIUSR := TRBZG2->ZG2_LGIUSR
                ZG2->(MsUnlock())
            EndIf
        EndIf
        TRBZG2->(DbSkip())
    End
    If Select("TRBZG2") > 0
        TRBZG2->(DbCloseArea())
    EndIf
EndIf
ConOut("LocToZG2: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ZG2ToLoc ∫Autor ≥Jonathan Schmidt Alves ∫ Data ≥21/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Atualiza a ZG2 do CTree com o ZG2 do Banco                 ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Este processamento deve ser realizado para manter as duas  ∫±±
±±∫          ≥ bases sincronizadas.                                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ZG2ToLoc()
Local k
Local _z1
Local nRegsZG2 := 0
Local cDirDocs := "\SYSTEM" // Diretorio onde sera gerado o Arquivo no Servidor
Local cFileZG2 := "ZG2" + SM0->M0_CODIGO + "01_" + cDbfDtc // CriaTrab(,.F.)  //Cria Arquivo Temporario
Local _aStru := {{"ZG2_FILIAL"   , "C" , 02 , 00 },;
{"ZG2_CODPER" , "C" , TamSX3("ZG2_CODPER")[1], 00 },;
{"ZG2_CODUSR" , "C" , TamSX3("ZG2_CODUSR")[1], 00 },;
{"ZG2_NOMUSR" , "C" , TamSX3("ZG2_NOMUSR")[1], 00 },;
{"ZG2_LGIUSR" , "C" , TamSX3("ZG2_LGIUSR")[1], 00 }}
ConOut("ZG2ToLoc: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If File(cDirDocs + "\" + cFileZG2)
	fErase(cDirDocs + "\" + cFileZG2) // Apaga o arquivo no Servidor
EndIf
DbCreate(cDirDocs + "\" + cFileZG2,_aStru, cRDDs) // Cria o arquivo no servidor como DBF
DbUseArea(.T., /*"DBFCDXADS"*/ cRDDs, cDirDocs + "\" + cFileZG2, cFileZG2, .T.)
If lBloqZG2 // Limpa do ZG2 usuarios bloqueados no cad usuarios do Protheus
	aAllUsers := AllUsers()
	ZG2->(DbSetOrder(2)) // ZG2_FILIAL + ZG2_CODUSR + ZG2_CODPER
	For k := 1 To Len(aAllUsers)
        If aAllUsers[k,1,17] // .T.=Bloqueado, .F.=Desbloqueado
        	If ZG2->(MsSeek(_cFilZG2 + aAllUsers[k,1,1]))
                If MsgYesNo("Exclui do ZG2 usuario bloqueado?" + Chr(13) + Chr(10) + "UserName: " + UsrRetName(ZG2->ZG2_CODUSR),"ZG2ToLoc")
                	While ZG2->(!EOF()) .And. ZG2->ZG2_CODUSR == aAllUsers[k,1,1]
                        RecLock("ZG2",.F.)
						ZG2->(DbDelete())
						ZG2->(MsUnlock())
						ZG2->(DbSkip())
					End
				EndIf
			EndIf
		EndIf
	Next
EndIf
// Parte 02: Regravacao ZG2 banco
DbSelectArea("ZG1")
ZG1->(DbSetOrder(1)) // ZG1_FILIAL + ZG1_CODPER
DbSelectArea("ZG2")
ZG2->(DbGotop())
While ZG2->(!EOF())
    If ZG1->(DbSeek(_cFilZG1 + ZG2->ZG2_CODPER))
        If ZG1->ZG1_STAPER $ "31/32/" // Perfil Aprovado
            RecLock(cFileZG2,.T.)
            (cFileZG2)->ZG2_FILIAL := ZG2->ZG2_FILIAL
            (cFileZG2)->ZG2_CODPER := ZG2->ZG2_CODPER
            (cFileZG2)->ZG2_CODUSR := ZG2->ZG2_CODUSR
            (cFileZG2)->ZG2_NOMUSR := ZG2->ZG2_NOMUSR
            (cFileZG2)->ZG2_LGIUSR := ZG2->ZG2_LGIUSR
            (cFileZG2)->(MsUnlock())
            (cFileZG2)->(DbSkip())
            nRegsZG2++
            If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a ˙ltima atualizaÁ„o da tela
                nLastUpdate := Seconds()
                For _z1 := 1 To 4
                    u_AtuAsk09(nCurrent,"Sincronizacao ZG2...","Por favor, aguarde a sincronizacao terminar...", "Registro: " + cValToChar(nRegsZG2), "", 80, "PROCESSA")
                    Sleep(040)
                Next
            EndIf
        EndIf
    EndIf
	ZG2->(DbSkip())
End
(cFileZG2)->(DbCloseArea())
For _z1 := 1 To 4
    u_AtuAsk09(++nCurrent,"Sincronizacao ZG2...","Por favor, aguarde a sincronizacao terminar... Concluido!", "Registros sincronizados: " + cValToChar(nRegsZG2), "", 80, "OK")
    Sleep(200)
Next
ConOut("ZG2ToLoc: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Arquivo: " + cFileZG2 + " atualizado com sucesso na pasta \SYSTEM")
ConOut("ZG2ToLoc: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros atualizados: " + cValToChar(nRegsZG2))
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ClearCls ∫Autor ≥Jonathan Schmidt Alves ∫Data ≥ 18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para criacao de aCols limpo conforme aHeader.       ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ aHdr: Header modelo para montagem do aCols                 ∫±±
±±∫          ≥ nFld: 0=Montagem de todos os elementos ?=Montagem de 1     ∫±±
±±∫          ≥ lIni: Processa o inicializador do elemento                 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function ClearCls(aHdr, nFld, lIni)
Local aCls := {}
Local _z := 1
Local aMnt := {}
Default nFld := 0
Default lIni := .F.
For _z := Iif(nFld == 0, 1, nFld) To Iif(nFld == 0, Len(aHdr), nFld)
	If nFld == 0 .Or. nFld == _z // Todos os Elementos ou o Elemento que eu preciso
		If aHdr[_z,08] == "C"
			aAdd(aMnt, Space(aHdr[_z,04]))
		ElseIf aHdr[_z,08] == "N"
			aAdd(aMnt, 0)
		ElseIf aHdr[_z,08] == "D"
			aAdd(aMnt, CtoD(""))
        ElseIf aHdr[_z,08] == "M"
            aAdd(aMnt, Space(800))
		EndIf
	EndIf
	If lIni .And. !Empty(aHdr[_z,12])
		// aMnt[ Len(aMnt) ] := &(aHdr[_z,12]) // Abro a informacao
	EndIf
Next
If nFld == 0 // Montagem completa
	aAdd(aMnt, .F.) // Nao apagado
	aAdd(aCls, aClone(aMnt)) // Criacao do elemento
Else // So o campo
	aCls := aClone(aMnt)
EndIf
Return aCls

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ASKYESNO ∫Autor ≥ Jonathan Schmidt Alves ∫Data ≥18/01/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para apresentacao de tela temporaria de espera por  ∫±±
±±∫          ≥ decisao do usuario.                                        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Argumentos:                                                ∫±±
±±∫          ≥ _nWait: Tempo em milisegundos de existencia da tela        ∫±±
±±∫          ≥ _cTitulo: Titulo da janela                                 ∫±±
±±∫          ≥ _cMsg1: Texto da mensagem da linha 1                       ∫±±
±±∫          ≥ _cMsg2: Texto da mensagem da linha 2                       ∫±±
±±∫          ≥ _cMsg3: Texto da mensagem da linha 3                       ∫±±
±±∫          ≥ _cMsg4: Texto da mensagem da linha 4                       ∫±±
±±∫          ≥ _cTitBut: Titulo do botao de cancelamento                  ∫±±
±±∫          ≥ _xTpImg: Numero da imagem, codigo do nivel ou especifica   ∫±±
±±∫          ≥ _lIncrease: Apresenta e incrementa barra oMeter            ∫±±
±±∫          ≥ _lAutoIn: Auto incremento conforme tempo _nWait            ∫±±
±±∫          ≥ __xBlock: Bloco de codigo processamento                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function AskYesNo(_nWait,_cTitulo,_cMsg1,_cMsg2,_cMsg3,_cMsg4,_cTitBut,_xTpImg,_lIncrease,_lAutoInc, __xBlock )
Local aImgPads := { "UPDINFORMATION", "UPDWARNING", "UPDERROR", "OK", "CLIENTE" }
Local aImgFase := { {"01","BR_BRANCO"}	,{"02","BR_CINZA"}		,{"03","BR_AMARELO"}	,{"04","BR_LARANJA"}	,{"05","BR_AZUL"}		,{"06","BR_MARROM"}		,{"07","BR_PRETO"}				,{"08","BR_VERDE"}	,{"09","BR_PINK"}	,{"10","BR_VIOLETA"}	,{"11","BR_VERMELHO"}	,{"C_","BR_CANCEL" } }
Local aDescFas := { "Orcamento"			,"Pedido em Aprovacao"	,"Financeiro"			,"Pedido em Aprovacao"	,"Pedido em Aprovacao"	,"Pedido em Conferencia","Pedido Pendente Atendimento"	,"Pedido Conferido"	,"Pedido Faturado"	,"Despacho Solicitado"	,"Pedido Despachado"	,"Pedido Cancelado"}
Local cResource := ""
Local nCl := 0
Local nLn := 005
Private oTimer
Private oBtCancel
Private oDlgAsk
Private oTitCpo := TFont():New("Cambria",,018,,.T.,,,,,.F.,.F.)
Private oBmp99
Default _xTpImg := 0 // 0=Sem Imagem 1=Imagem informacao 2=Imagem alerta 3=Imagem erro
Default _nWait := 10000
Default _lIncrease := .F.
Default _lAutoInc := .F.
Default __xBlock := .F.
Private oMeter
Private nMeter := 0
Private nWait := _nWait
Private lIncrease := _lIncrease
Private lAutoInc := _lAutoInc
Private _bBlock := __xBlock
Public oSayMsg1
Public oSayMsg2
Public oSayMsg3
Public oSayMsg4
Public cTitulo := _cTitulo
Public cMsg1 := _cMsg1
Public cMsg2 := _cMsg2
Public cMsg3 := _cMsg3
Public cMsg4 := _cMsg4
Public _lButton := .T.
DEFINE MSDIALOG oDlgAsk FROM 0,0 TO 125,620 PIXEL TITLE cTitulo
If lIncrease
	Public _oMeter := tMeter():New(56,15,{|u| if(Pcount() > 0, nMeter := u, nMeter)},100,oDlgAsk, 210, 05,,.T.,,,,,,1000) // cria a rÈgua
	nCurrent := Eval(_oMeter:bSetGet) // pega valor corrente da rÈgua
EndIf
If !Empty(_xTpImg) // Exibir imagem
	If ValType(_xTpImg) == "N" .And. _xTpImg <= Len(aImgPads)
		cResource := aImgPads[_xTpImg]
	ElseIf ValType(_xTpImg) == "C"
		If (nPosX := ASCan(aImgFase, {|x|, x[1] == _xTpImg })) > 0 // Cores das Fases
			cResource := aImgFase[nPosX,2] // Resource da imagem
			cMsg1 := _xTpImg + " = " + aDescFas[nPosX] // Descricao da fase
			nCl := 008
			nLn := 002
		Else
			cResource := _xTpImg // Texto direto a imagem do GetResources
			nCl := 004
		EndIf
	EndIf
	If !Empty(cResource) // Imagem a apresentar
		@nLn,007 BitMap oBmp99 Resource cResource Size 80,80 Of oDlgAsk Pixel NoBorder
		
		If _cTitulo $ "Data Vencimento/Data Referencia/Replicacao" .And. Type("nProc") <> "U" .And. Type("nType") <> "U"
			oBmp99:bLClicked := {|| u_ChgTpRep(), oTimer:DeActivate(), oTimer:nInterval := nWait, oTimer:lActive := .T. }
		EndIf

		nCl := 020
		nLn := 001
	EndIf
EndIf
@nLn,005 + nCl SAY oSayMsg1 VAR cMsg1 SIZE 335,020 OF oDlgAsk FONT oTitCpo Pixel
@015,005 + nCl SAY oSayMsg2 VAR cMsg2 SIZE 335,020 OF oDlgAsk FONT oTitCpo Pixel
@025,005 + nCl SAY oSayMsg3 VAR cMsg3 SIZE 335,020 OF oDlgAsk FONT oTitCpo Pixel
@035,005 + nCl SAY oSayMsg4 VAR cMsg4 SIZE 335,020 OF oDlgAsk FONT oTitCpo Pixel
DEFINE SBUTTON oBtCancel FROM 045,165 TYPE 2 ACTION (AskWait9(.F.,.T.)) ENABLE OF oDlgAsk
DEFINE TIMER oTimer INTERVAL nWait ACTION AskWait9(.T.,.F.) OF oDlgAsk
If ValType(_bBlock) == "B" // !Empty(cFunction)
	DEFINE TIMER oTimer2 INTERVAL 10 ACTION AskWait7() OF oDlgAsk
EndIf
oDlgAsk:bLClicked := {|| oTimer:DeActivate(), oTimer:nInterval := nWait, oTimer:lActive := .T. }
If Empty(_cTitBut)
	oBtCancel:lVisible := .F.
Else
	oBtCancel:cCaption := _cTitBut
EndIf
ACTIVATE MSDIALOG oDlgAsk CENTERED ON INIT InitAsk9()
Return _lButton // .T.=Nao Cancelado .F.=Cancelado

Static Function InitAsk9() // Inicializador do Timer e do Meter se necessario
Local _nWait := 0
Local w := 1
If lIncrease // Incremento de regua
	If lAutoInc // Auto incremento
		oTimer:Activate()
		_nWait := nWait / 10 // 2000 divid 10 sao 10 incrementos a cada 200 milisegundos
		For w := 1 To 10
			If ValType(_oMeter) == "O" // Objeto ativo
				nCurrent += 10 // atualiza rÈgua
				_oMeter:Set(nCurrent)
				ProcessMessages()
				_oMeter:Refresh()
				Sleep(_nWait) // Espero 200 milisegundos, sao 10 rodadas
			Else
				Return
			EndIf
		Next
	ElseIf ValType(_bBlock) == "B" // !Empty(cFunction)
		oTimer2:Activate() // Ativa timer de processamento
	EndIf
Else // Sem incremento de regua
	oTimer:Activate()
EndIf
Return

Static Function AskWait7()
Eval(_bBlock)
oDlgAsk:End()
Return

Static Function AskWait9(__lButton,lClick)
If lClick
	_lButton := .F.
	oTimer:End()
EndIf
oBtCancel:SetDisabled()
oDlgAsk:Refresh()
SysRefresh()
If !__lButton
	oBtCancel:Refresh()
	Sleep(500)
EndIf
oDlgAsk:End()
Return

User Function AtuAsk09(nCurrent,cMsg1,cMsg2,cMsg3,cMsg4,nSleep,cPict) // Atualizacao do Objeto AskYesNo
Default nSleep := 0
Default cPict := ""
_oMeter:Set(nCurrent)
If Type("oSayMsg1") == "O"
	oSayMsg1:cCaption := cMsg1
	oSayMsg2:cCaption := cMsg2
	oSayMsg3:cCaption := cMsg3
	oSayMsg4:cCaption := cMsg4
	oSayMsg1:Refresh()
	oSayMsg2:Refresh()
	oSayMsg3:Refresh()
	oSayMsg4:Refresh()
	If !Empty(cPict)
		oBmp99:cResName := cPict
		oBmp99:lVisible := .T.
		oBmp99:Refresh()
	EndIf
EndIf
_oMeter:Refresh()
ProcessMessages()
Sleep(nSleep)
Return
