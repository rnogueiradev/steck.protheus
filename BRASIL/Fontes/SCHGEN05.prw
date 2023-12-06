#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SCHGEN05 ºAutor ³Jonathan Schmidt Alves º Data ³26/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fluxo de aprovacao Salary Review.                          º±±
±±º          ³                                                            º±±
±±º          ³ Parametro usuarios Presidencia: ST_USRPR05                 º±±
±±º          ³                                                            º±±
±±º          ³ Parametro usuarios Recursos Humanos: ST_USRRH05            º±±
±±º          ³                                                            º±±
±±º          ³ KARINA ALMEIDA MARTINEZ          Cod Usr Protheus: 000952  º±±
±±º          ³ CAMILE TACIANE FABRI DE PAULA    Cod Usr Protheus: 000975  º±±
±±º          ³ MICHELE MOREIRA FLORENCIO        Cod Usr Protheus: 000915  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SCHGEN05()
Local _w1
Local lRet := .T.
Local lDemit := .F.
Private cDepto := ""
Private cCodUsr := RetCodUsr() // "000084" // "000645" // "000952" // "001292" // "000645" // RetCodUsr() // "000952" // "000645" //   // "001292" // "000645"                       // TESTE "GIOVANI LEANDRO ZAGO"

Private cUsrPre := SuperGetMv("ST_USRPR05",.F.,"")
Private cUsrRec := SuperGetMv("ST_USRRH05",.F.,"")
Private aAreaSM0 := {}
// Variaveis linhas objetos
Private nLineZS1 := 1
Private nLineZS2 := 1
// Cores Usuarios
Private nClrCP0 := RGB(171,171,171)	// Cinza Padrao				*** P0: Sem pendencias
Private nClrCP1 := RGB(165,250,160) // Verde Claro				*** P1: Pendencias
// Cores Acesso Gestor
Private nClrCA0 := RGB(255,255,255) // Branco					*** A0: Nao Identificado
Private nClrCA1 := RGB(171,171,171)	// Cinza Padrao				*** A1: -> Incluir Solicitacao (Gestor)
Private nClrCA2 := RGB(165,250,160) // Verde Claro				*** A2: Solicitacao Incluida
Private nClrCA3 := RGB(026,207,005) // Verde Escuro				*** A3: -> Enviar Solicitacao para Analise (Gestor -> Recursos Humanos)
Private nClrCA4 := RGB(255,111,111) // Vermelho	Claro           *** A4: Solicitacao Reprovada (Recursos Humanos)
Private nClrCA5 := RGB(255,168,125) // Laranja Claro            *** A5: -> Reavaliar Solicitacao Reprovada (Gestor)
Private nClrCA6 := RGB(200,191,231) // Roxo	Claro				*** A6: -> Abandonar Solicitacao (Gestor)
Private nClrCA7 := RGB(255,168,125) // Laranja Claro            *** A7: -> Retornar Solicitacao (Recursos Humanos -> Gestor)
Private nClrCA8 := RGB(255,168,125) // Laranja Claro            *** A7: -> Retornar Solicitacao Abandonada (Gestor)
Private nClrCA9 := RGB(188,121,255) // Roxo Escuro  			*** A9: Solicitacao Abandonada (Gestor)
// Cores Acesso Recursos Humanos
Private nClrCB1 := RGB(249,255,164) // Amarelo Claro			*** B1: Solicitacao Aguardando Analise (Recursos Humanos)
Private nClrCB2 := RGB(185,185,000) // Amarelo Escuro			*** B2: -> Analisar Solicitacao (Recursos Humanos)
Private nClrCB3 := RGB(171,171,171)	// Azul Esverdeado Claro    *** B3: Solicitacao em Analise (Recursos Humanos)
Private nClrCB4 := RGB(211,044,044) // Vermelho	Escuro			*** B4: Solicitacao Reprovada (Presidencia)
Private nClrCB5 := RGB(255,111,111) // Vermelho	Claro			*** B5: -> Reprovar Solicitacao (Recursos Humanos -> Gestor)
Private nClrCB6 := RGB(132,155,251) // Azul Claro				*** B6: -> Aprovar Solicitacao (Recursos Humanos -> Presidencia)
Private nClrCB7 := RGB(211,044,044) // Cinza Padrao			    *** B7: -> Retornar Solicitacao (Presidencia -> Recursos Humanos)
Private nClrCB8 := RGB(255,111,111) // Vermelho	Claro			*** B8: -> Reprovar Solicitacao (Recursos Humanos -> Gestor)
Private nClrCB9 := RGB(217,204,117) // Cinza Amarelado          *** B9: -> Reanalisar Solicitacao (Recursos Humanos)
// Cores Acesso Presidencia
Private nClrCC1 := RGB(132,155,251) // Azul Claro				*** C1: Solicitacao Aguardando Analise (Presidencia)
Private nClrCC2 := RGB(116,125,245) // Azul Mais Escuro			*** C2: -> Analisar Solicitacao (Presidencia)
Private nClrCC3 := RGB(217,204,117) // Cinza Amarelado          *** C3: Solicitacao em Analise (Presidencia)
Private nClrCC4 := RGB(238,185,162) // Cinza Avermelhado Claro  *** C4: -> Reprovar Solicitacao (Presidencia)
Private nClrCC5 := RGB(155,221,164) // Cinza Esverdeado Claro   *** C5: -> Aprovar Solicitacao (Presidencia)
Private nClrCC9 := RGB(255,168,125) // Laranja Claro            *** C9: -> Reanalisar Solicitacao (Presidencia)
// Cores Acesso Recursos Humanos
Private nClrCD1 := RGB(165,250,160) // Verde Claro				*** D1: Solicitacao Aprovada (Presidencia)
Private nClrCD2 := RGB(200,191,231) // Roxo	Claro				*** D2: -> Processar Alteracao Salarial (Recursos Humanos)
Private nClrCD3 := RGB(132,155,251) // Azul Claro				*** D3: Alteracao Salarial Processada (Recursos Humanos)
// Variaveis de Filiais
Private _cFilSRA := xFilial("SRA")
Private _cFilSQB := xFilial("SQB")
Private _cFilCTT := xFilial("CTT")
Private _cFilZS1 := xFilial("ZS1")
Private _cFilZS2 := xFilial("ZS2")
Private _cFilPH1 := xFilial("PH1")
Private _cFilPH3 := xFilial("PH3")
Private _cFilSRJ := xFilial("SRJ")
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
// Matrizes de Processamento
Private aFilFuncs := {} // Filiais de processamento
Private aAllDepts := {} // Todos os Departamentos (SQB)
Private aGesDepts := {} // Todos os Departamentos (SQB) em que o usuario eh gestor
Private aUsrDepts := {} // Todos os Funcionarios (SRA) que estao em Departamentos (SQB) em que o usuario eh gestor
Private aUsrSolic := {} // Todos os Funcionarios (SRA) que possuem Solicitacoes
Private aButtons := {} // Outras Acoes
// Focus
Private cObjFoc := "oGetD1"
// Objetos principais
Private oDlg01
Private oGetD1
Private oGetD2
Private oGetD3
Private oPnlGd1
Private oPnlGd2
Private oPnlGd3
Private oPnlBot
Private oFolder
Private oFolEAA
Private oRadAnos
Private oCmbPrcUsr
// Variaveis Acessos/Pesquisa
Private cGetPsqMat := Space(06)
Private cGetPsqNom := Space(40)
Private cAccessUsr := "Acessos do Usuario:" // Acessos do usuario (tooltip)
// Variaveis Checkbox pesquisa
Private oChkPenden
Private lChkPenden := .T.
Private cCmbGestor := Space(40)
Private aCmbGestor := { "TODOS" }
Private aUsrGestor := {}
// Ainda nao usado
Private oChkAllSol
Private lChkAllSol := .F.
Private aCmbPrcUsr := {}
Private cCmbPrcUsr := ""
Private cAllPrcUsr := ""
// Variaveis Usuarios dos Departamentos
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
Private cTitDlg := "SchGen05: Solicitacoes Salary Review"
// Variaveis Solicitacoes em Andamento
Private aHdr02 := {}
Private aCls02 := {}
Private aFldsAlt02 := {}
// Variaveis Historicos Salariais
Private aHdr03 := {}
Private aCls03 := {}
// Variaveis Folders
Private aFolder := { "EAA", "Alteracoes Salariais" }
Private aFolEAA := { "Meta 01", "Meta 02", "Meta 03", "Meta 04", "Meta 05", "Avaliacao Comportamental", "Avaliacao Final", "Desenv Funcionarios", "PDI", "Formacao Academica", "PPM" }
// Radio Box Anos Metas
Private nRadAnos := 1
Private aRadAnos := {}
// Meta 01
Private cGetMeta01 := Space(800)
Private cGetObsP01 := Space(800)
Private cGetAval01 := Space(800)
Private cGetTarg01 := ""
Private cGetMini01 := ""
Private cGetMaxi01 := ""
Private lChkCali01 := .F.
Private nGetPerc01 := 0
Private cCmbPerA01 := ""
Private cCmbPerB01 := ""
// Meta 02
Private cGetMeta02 := Space(800)
Private cGetObsP02 := Space(800)
Private cGetAval02 := Space(800)
Private cGetTarg02 := ""
Private cGetMini02 := ""
Private cGetMaxi02 := ""
Private lChkCali02 := .F.
Private nGetPerc02 := 0
Private cCmbPerA02 := ""
Private cCmbPerB02 := ""
// Meta 03
Private cGetMeta03 := Space(800)
Private cGetObsP03 := Space(800)
Private cGetAval03 := Space(800)
Private cGetTarg03 := ""
Private cGetMini03 := ""
Private cGetMaxi03 := ""
Private lChkCali03 := .F.
Private nGetPerc03 := 0
Private cCmbPerA03 := ""
Private cCmbPerB03 := ""
// Meta 04
Private cGetMeta04 := Space(800)
Private cGetObsP04 := Space(800)
Private cGetAval04 := Space(800)
Private cGetTarg04 := ""
Private cGetMini04 := ""
Private cGetMaxi04 := ""
Private lChkCali04 := .F.
Private nGetPerc04 := 0
Private cCmbPerA04 := ""
Private cCmbPerB04 := ""
// Meta 05
Private cGetMeta05 := Space(800)
Private cGetObsP05 := Space(800)
Private cGetAval05 := Space(800)
Private cGetTarg05 := ""
Private cGetMini05 := ""
Private cGetMaxi05 := ""
Private lChkCali05 := .F.
Private nGetPerc05 := 0
Private cCmbPerA05 := ""
Private cCmbPerB05 := ""
// Avaliacao Comportamental
// Participante
Private cCmbPClien := Space(01)
Private cCmbPSerDi := Space(01)
Private cCmbPAgeDo := Space(01)
Private cCmbPDisRu := Space(01)
Private cCmbPApren := Space(01)
// Avaliador
Private cCmbAClien := Space(01)
Private cCmbASerDi := Space(01)
Private cCmbAAgeDo := Space(01)
Private cCmbADisRu := Space(01)
Private cCmbAApren := Space(01)
// Avaliacao Final
// Participante
Private cGetCome02 := ""
Private cCmbAvPart := Space(01)
// Avaliador
Private cGetCome01 := ""
Private cCmbAvAval := Space(01)
Private nGetAvPerc := 0
// Desenv Funcionario
Private cGetDesenv := ""
// PDI
Private cGetProxCa := Space(100)
Private cGetPontFo := Space(100)
Private cCmbTransf := ""
Private cGetPontDe := Space(100)
Private cGetInfAdi := ""
// Meta 01
Private cGetNoMt01 := Space(100)
Private cGetDsMt01 := ""
Private cCmbCgMt01 := ""
Private dGetInMt01 := CtoD("")
Private dGetFiMt01 := CtoD("")
// Meta 02
Private cGetNoMt02 := Space(100)
Private cGetDsMt02 := ""
Private cCmbCgMt02 := ""
Private dGetInMt02 := CtoD("")
Private dGetFiMt02 := CtoD("")
// Meta 03
Private cGetNoMt03 := Space(100)
Private cGetDsMt03 := ""
Private cCmbCgMt03 := ""
Private dGetInMt03 := CtoD("")
Private dGetFiMt03 := CtoD("")
// Meta 04
Private cGetNoMt04 := Space(100)
Private cGetDsMt04 := ""
Private cCmbCgMt04 := ""
Private dGetInMt04 := CtoD("")
Private dGetFiMt04 := CtoD("")
// Meta 05
Private cGetNoMt05 := Space(100)
Private cGetDsMt05 := ""
Private cCmbCgMt05 := ""
Private dGetInMt05 := CtoD("")
Private dGetFiMt05 := CtoD("")
// Formacao Academica
Private cGetFormAc := ""

// PPM
/*
Private cGetFlds01 := Space(050)
Private cGetFlds02 := Space(030)
Private cGetFlds03 := Space(030)
Private cGetFlds04 := Space(030)
Private dGetFlds05 := CtoD("")
Private dGetFlds06 := CtoD("")
Private cGetFlds07 := Space(800)
Private cGetFlds08 := Space(800)
Private cGetFlds09 := Space(001)
Private cGetFlds10 := Space(001)
Private cGetFlds11 := Space(001)
Private cGetFlds12 := Space(001)
Private cGetFlds13 := Space(001)

Private cGetCurso1 := Space(120)
Private cGetCurso2 := Space(120)
Private cGetCurso3 := Space(120)
Private cGetCurso4 := Space(120)
Private cGetCurso5 := Space(120)
*/
	Private cGetNotaFm := Space(020)

// Atalhos e Usr Logado
	Private cGetCodLog := cCodUsr
	Private cGetNomLog := UsrRetName(cCodUsr)
// Montagem de Combos
// Combos Avaliacao Final
	Private aAvalPart := {}
	Private aAvalAval := {}
// Combos Performance
	Private aPerformsA := {}
	Private aPerformsB := {}
// Combos Avaliacao Comportamental (Participante)
	Private aPCliente := {}
	Private aPSerDive := {}
	Private aPAgeIDon := {}
	Private aPDisRupt := {}
	Private aPAprendi := {}
// Combos Avaliacao Comportamental (Avaliador)
	Private aACliente := {}
	Private aASerDive := {}
	Private aAAgeIDon := {}
	Private aADisRupt := {}
	Private aAAprendi := {}
// Combos PDI
	Private aTransferi := {}
// Combos PDI metas
	Private aCategMt01 := {}
	Private aCategMt02 := {}
	Private aCategMt03 := {}
	Private aCategMt04 := {}
	Private aCategMt05 := {}
// Carregamento de combos (Performance, Avaliacao Comportamental, etc)
// Combos Avaliacao Comportamental
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // X3_CAMPO
	aLdsCombos := { { "PH3_A1", "aPerFormsA" }, { "PH3_B1", "aPerFormsB" },;
		{ "PH3_PC7", "aPCliente" }, { "PH3_PC9", "aPSerDive" }, { "PH3_AC11", "aPAgeIDon" }, { "PH3_PC8", "aPDisRupt" }, { "PH3_PC10", "aPAprendi" },;
		{ "PH3_AC7", "aACliente" }, { "PH3_AC9", "aASerDive" }, { "PH3_AC11", "aAAgeIDon" }, { "PH3_AC8", "aADisRupt" }, { "PH3_AC10", "aAAprendi" },;
		{ "PH3_AVPA", "aAvalPart" }, { "PH3_AVAV", "aAvalAval" },;
		{ "PH3_PDI04", "aTransferi" }, { "PH3_PDI11", "aCategMt01" }, { "PH3_PDI16", "aCategMt02" }, { "PH3_PDI21", "aCategMt03" }, { "PH3_PDI26", "aCategMt04" }, { "PH3_PDI31", "aCategMt05" } }
	For _w1 := 1 To Len( aLdsCombos )
		If SX3->(DbSeek( aLdsCombos[ _w1, 01 ] ))
			&(aLdsCombos[ _w1, 02 ]) := StrToKarr( SX3->X3_CBOX, ";")
		EndIf
	Next
// Parte 01: Abertura das tabelas
	DbSelectArea("ZS1") // Usuarios Solicitacoes Salary Review
	ZS1->(DbSetOrder(1)) // ZS1_FILIAL + ZS1_MATFIL + ZS1_MATFUN
	DbSelectArea("ZS2") // Solicitacoes Salary Review
	ZS2->(DbSetOrder(1)) // ZS2_FILIAL + ZS2_CODSOL
	DbSelectArea("SQB") // Departamentos
	SQB->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
	DbSelectArea("SRA") // Funcionarios
	SRA->(DbOrderNickName("USERCFG")) // RA_XUSRCFG
	DbSelectArea("PH1") // Usuarios EAA
	PH1->(DbSetOrder(1)) // PH1_FILIAL + PH1_USER + PH1_SUP
	DbSelectArea("PH3")
	PH3->(DbSetOrder(1)) // PH3_FILIAL + PH3_USERID + PH3_ANO
	DbSelectArea("SRJ") // Funcoes
	SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
// Carregamento das filiais
	aAreaSM0 := SM0->(GetArea())
	SM0->(DbSetOrder(1)) // M0_FILIAL + M0_CODIGO + M0_CODFIL
	SM0->(DbGotop())
	While SM0->(!EOF())
		If SM0->M0_CODIGO == cEmpAnt // Empresa logada
			aAdd(aFilFuncs, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CODFIL + ": " + RTrim(SM0->M0_FILIAL) })
		EndIf
		SM0->(DbSkip())
	End
	RestArea(aAreaSM0)
// Usuarios ZS1
//          StatsChg(     "M1",    Acessos, Obtencao de Desc Status, Obtencao da Cor Status, Status para montagem)
	cStats01 := StatsChg( "oGetD1", cAllPrcUsr,                     Nil,                    Nil, "P0/P1/") // Montagem dos Status
	aAdd(aHdr01, { "Filial",            "ZS1_MATFIL", "",                               02,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 01
	aAdd(aHdr01, { "Matricula",         "ZS1_MATFUN", "",                               06,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 02
	aAdd(aHdr01, { "Nome Func",         "ZS1_NOMFUN", "",                               40,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 03
	aAdd(aHdr01, { "Cod Depto",         "ZS1_CODDEP", "",                               09,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 04
	aAdd(aHdr01, { "Nome Depto",        "ZS1_NOMDEP", "",                               30,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 05
	aAdd(aHdr01, { "Admissao",          "ZS1_ADMISS", "",                               08,  00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "",                    "" })  // 06
	aAdd(aHdr01, { "Salario",           "ZS1_SALARI", "@E 999,999,999.99",              12,  02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 07
	aAdd(aHdr01, { "Status",            "ZS1_STATRG", "",                               02,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", cStats01,              "" })  // 08
// Solicitacoes ZS2
//          StatsChg(     "M1",    Acessos, Obtencao de Desc Status, Obtencao da Cor Status, Status para montagem)
	cStats02 := StatsChg( "oGetD2", cAllPrcUsr,                     Nil,                    Nil, "A0/ A1/A2/A3/A4/A5/A6/A7/A8/A9/ B1/B2/B3/B4/B5/B6/B7/B8/B9/ C1/C2/C3/C4/C5/C6/ D1/D2/D3/") // Montagem dos Status
	aAdd(aHdr02, { "Solicit",           "ZS2_CODSOL", "",                               06,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 01
	aAdd(aHdr02, { "Emissao",           "ZS2_DATEMI", "",                               08,  00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "",                    "" })  // 02
	aAdd(aHdr02, { "Filial",            "ZS2_MATFIL", "",                               02,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 03
	aAdd(aHdr02, { "Nome Fil",          "ZS2_NOMFIL", "",                               20,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 04
	aAdd(aHdr02, { "Matricula",         "ZS2_MATFUN", "",                               06,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 05
	aAdd(aHdr02, { "Nome",              "ZS2_NOMFUN", "",                               40,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 06
	aAdd(aHdr02, { "Funcao Atual",      "ZS2_FUNCAO", "",                               05,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 07
	aAdd(aHdr02, { "Desc Funcao Atual", "ZS2_DESATU", "",                               30,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 08
	aAdd(aHdr02, { "Salario Atual",     "ZS2_SALARI", "@E 999,999,999.99",              12,  02, ".F.",             "€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 09
	aAdd(aHdr02, { "Alter %",           "ZS2_SALPER", "@E 999.99",                      06,  02, "u_VlSalPer()",    "€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 10
	aAdd(aHdr02, { "Alter Valor",       "ZS2_SALALT", "@E 999,999,999.99",              12,  02, "u_VlSalAlt()",    "€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 11
	aAdd(aHdr02, { "Salario Atualiz",   "ZS2_SALATU", "@E 999,999,999.99",              12,  02, ".F.",             "€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 12
	aAdd(aHdr02, { "Motivo Alt",        "ZS2_MOTALT", "",                               06,  00, "u_VlMotAlt()",    "€€€€€€€€€€€€€€ ", "C", "41",   "R", "",                    "" })  // 13
	aAdd(aHdr02, { "Descricao Motivo",  "ZS2_DESALT", "",                               30,  00, ".F.",             "€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 14

//aAdd(aHdr02, { "Nova Funcao",       "ZS2_CODFUN", "",                               05,  00, "u_VlCodFun()",    "€€€€€€€€€€€€€€ ", "C", "SRJ",  "R", "",                    "" })  // 15
	aAdd(aHdr02, { "Desc Funcao",       "ZS2_DESFUN", "",                               20,  00, ".T."         ,    "€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 16

	aAdd(aHdr02, { "Data Desejada",     "ZS2_DATDES", "",                               08,  00, "u_VlDatDes()",    "€€€€€€€€€€€€€€ ", "D", "",		"R", "",                    "" })  // 17
	aAdd(aHdr02, { "Data Efetivacao",   "ZS2_DATEFE", "",                               08,  00, "u_VlDatEfe()",    "€€€€€€€€€€€€€€ ", "D", "",		"R", "",                    "" })  // 18
	aAdd(aHdr02, { "Obs Gestor",        "ZS2_OBSGES", "",                               10,  00, ".F.",             "€€€€€€€€€€€€€€ ", "M", "",		"R", "",                    "" })  // 19
	aAdd(aHdr02, { "Obs Rec Humanos",   "ZS2_OBSREC", "",                               10,  00, ".F.",             "€€€€€€€€€€€€€€ ", "M", "",		"R", "",                    "" })  // 20
	aAdd(aHdr02, { "Obs Presidencia",   "ZS2_OBSPRE", "",                               10,  00, ".F.",             "€€€€€€€€€€€€€€ ", "M", "",		"R", "",                    "" })  // 21
	aAdd(aHdr02, { "CCusto",            "ZS2_CODCUS", "",                               09,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 22
	aAdd(aHdr02, { "Desc Custo",        "ZS2_DESCUS", "",                               30,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 23
	aAdd(aHdr02, { "Status",            "ZS2_STATRG", "",                               02,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", cStats02,              "" })  // 24

// Historico de Alteracoes Salariais ZS3
	aAdd(aHdr03, { "Filial",            "ZS3_MATFIL", "",                               02,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 01
	aAdd(aHdr03, { "Matricula",         "ZS3_MATFUN", "",                               06,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 02
	aAdd(aHdr03, { "Nome Func",         "ZS3_NOMFUN", "",                               40,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 03
	aAdd(aHdr03, { "Data",              "ZS3_DATALT", "",                               08,  00, ".F.",             "€€€€€€€€€€€€€€ ", "D", "",		"R", "",                    "" })  // 04
	aAdd(aHdr03, { "Motivo",            "ZS3_MOTALT", "",                               02,  00, ".F.",             "€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 05
	aAdd(aHdr03, { "Desc Motivo",       "ZS3_DESALT", "",                               20,  00, ".F.",             "€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 06
	aAdd(aHdr03, { "Cod Funcao",        "ZS3_CODFUN", "",                               05,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 07
	aAdd(aHdr03, { "Desc Funcao",       "ZS3_DESFUN", "",                               20,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 08
	aAdd(aHdr03, { "Categoria",         "ZS3_CODCAT", "",                               01,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 09
	aAdd(aHdr03, { "Desc Categ",        "ZS3_DESCAT", "",                               10,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 10
	aAdd(aHdr03, { "Desc Verba",        "ZS3_DESVER", "",                               20,  00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "",                    "" })  // 11
	aAdd(aHdr03, { "Salario",           "ZS3_SALARI", "@E 999,999,999.99",              12,  02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "",                    "" })  // 12
// Preparacao das posicoes do Header 01
	For _w1 := 1 To Len(aHdr01)
		&("nP01" + SubStr(aHdr01[_w1,2],5,6)) := _w1
	Next
// Preparacao das posicoes do Header 02
	For _w1 := 1 To Len(aHdr02)
		&("nP02" + SubStr(aHdr02[_w1,2],5,6)) := _w1
	Next
// Preparacao das posicoes do Header 03
	For _w1 := 1 To Len(aHdr03)
		&("nP03" + SubStr(aHdr03[_w1,2],5,6)) := _w1
	Next
// Parte 02: Carregamento dos Departamentos
	aAllDepts := LdsDpAll()
// Parte 03: Identificacao do acesso do usuario e seus Departamentos
	If cCodUsr $ cUsrPre // Usuario da Presidencia
		aAdd(aCmbPrcUsr, "3=Presidencia")
		cCmbPrcUsr := "3"
		cAllPrcUsr += "3/"
		aAdd(aFldsAlt02, "ZS2_OBSGES")
		aAdd(aFldsAlt02, "ZS2_OBSREC")
		aAdd(aFldsAlt02, "ZS2_OBSPRE")
		LdsUsers("3", Nil, Nil, lChkPenden, lChkAllSol)
	EndIf
	If cCodUsr $ cUsrRec // Usuario do Recursos Humanos
		// Carregamento dos Acessos do Usuario    "1"=Acesso Gestor  "2"=Acesso Recursos Humanos "3"=Acesso Presidencia
		aAdd(aCmbPrcUsr, "2=Recursos Humanos")
		cAllPrcUsr += "2/"
		If ASCan(aCmbPrcUsr, {|x|, x == "3" }) == 0 // Nao tem acesso 3=Presidencia (inclui os campos)
			aAdd(aFldsAlt02, "ZS2_OBSGES")
			aAdd(aFldsAlt02, "ZS2_OBSREC")
			aAdd(aFldsAlt02, "ZS2_OBSPRE")
		EndIf
		aAdd(aFldsAlt02, "ZS2_MOTALT")

		//    aAdd(aFldsAlt02, "ZS2_CODFUN") // Codigo da Funcao (Nova Funcao)
		aAdd(aFldsAlt02, "ZS2_DESFUN") // Descrição da Funcao (Nova Funcao)

		aAdd(aFldsAlt02, "ZS2_DATEFE") // Data Efetivacao apenas Recursos Humanos
		If Len( aCls01 ) == 0 // Ainda sem dados carregados... vamos ver como Recursos Humanos entao
			cCmbPrcUsr := "2"
			LdsUsers("2", Nil, Nil, lChkPenden, lChkAllSol)
		EndIf
	EndIf
	SRA->(DbOrderNickName("USERCFG")) // RA_XUSRCFG
	If SRA->(DbSeek( cCodUsr )) // Verificando se Usuario Gestor
		lDemit := .F.
		While SRA->(!EOF()) .And. SRA->RA_XUSRCFG == cCodUsr
			If Empty(SRA->RA_DEMISSA) // Usuario nao demitido

				If cCodUsr $ cUsrPre
					cDepto := "000000011" // Depto "000000011" Superio dos Geretes deve ser apresentado para o Presidente Como Gestor
				Else
					cDepto := "000000030" // Usuario obrigatoriamente deve estar no Depto "000000030"=GERENCIA
				EndIf

				If SRA->RA_DEPTO == Alltrim(cDepto)

					aGesDepts := LdsDpMat( SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_DEPTO )
					If Len(aGesDepts) > 0 // Monto usuarios dos departamentos em que sou gestor
						// Salario apenas Gestor inclui/altera, Recursos Humanos aceita ou recusa
						aAdd(aFldsAlt02, "ZS2_SALPER")
						aAdd(aFldsAlt02, "ZS2_SALALT")
						If ASCan(aFldsAlt02, {|x|, x == "ZS2_MOTALT" }) == 0 // Ainda nao tem esse acesso
							aAdd(aFldsAlt02, "ZS2_MOTALT")
						EndIf
						aAdd(aFldsAlt02, "ZS2_DATDES") // Data Desejada apenas Gestor

						//aAdd(aFldsAlt02, "ZS2_CODFUN") // Codigo da Funcao (Nova Funcao)
						aAdd(aFldsAlt02, "ZS2_DESFUN") // Descrição da Funcao (Nova Funcao)

						If ASCan(aCmbPrcUsr, {|x|, x $ "2/3/" }) == 0 // Nao tem acesso 2=Recursos Humanos ou 3=Presidencia (inclui os campos)
							aAdd(aFldsAlt02, "ZS2_OBSGES")
							aAdd(aFldsAlt02, "ZS2_OBSREC")
							aAdd(aFldsAlt02, "ZS2_OBSPRE")
						EndIf
						// Carregamento dos Acessos do Usuario    "1"=Acesso Gestor  "2"=Acesso Recursos Humanos "3"=Acesso Presidencia
						aAdd(aCmbPrcUsr, "1=Gestor")
						cAllPrcUsr += "1/"
						If Len( aCls01 ) == 0 // Ainda sem dados carregados... vamos ver como Gestor entao
							cCmbPrcUsr := "1"
							LdsUsers("1", Nil, Nil, lChkPenden, lChkAllSol)
						ElseIf Len(aCmbPrcUsr) == 0 // Nao foram encontrados funcionarios nos departamentos do gestor
							u_AskYesNo(4000,"SchGen05","Nao foram encontrados funcionarios nos departamentos relacionados!","Verifique os funcionarios/departamentos relacionados ao seu usuario e tente novamente (SBQ/SRA)!","Matricula: " + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME),"Cod Usr: " + cCodUsr,"","UPDERROR")
							lRet := .F.
						EndIf
					ElseIf Len(aCmbPrcUsr) == 0 // Nao tem nenhum outro acesso e tambem nao tem departamentos
						u_AskYesNo(4000,"SchGen05","Nao foram encontrados departamentos relacionados!","Verifique os departamentos relacionados ao seu usuario e tente novamente (SBQ)!","Matricula: " + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME),"Cod Usr: " + cCodUsr,"","UPDERROR")
						lRet := .F.
					EndIf
				ElseIf Len(aCmbPrcUsr) == 0 // Usuario nao pertence a Gerencia e tambem nao tem nenhum outro acesso (Rec Humanos/Presidencia)
					u_AskYesNo(4000,"SchGen05","Usuario nao identificado como Gestor (Depto Gerencia: '000000030')!","Verifique seus acessos e tente novamente! Depto Usuario: " + SRA->RA_DEPTO + " (RA_DEPTO)","Matricula: " + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME),"Cod Usr: " + cCodUsr,"","UPDERROR")
					lRet := .F.
				EndIf
				lDemit := .F.
				Exit
			Else // Usuario esta demitido no cadastro (SRA)
				lDemit := .T.
			EndIf
			SRA->(DbSkip())
		End
		If lDemit // Usuario demitido
			u_AskYesNo(4000,"SchGen05","Usuario esta demitido no cadastro (SRA)!","Verifique sua situacao no Depto Recursos Humanos e tente novamente!","","Cod Usr: " + cCodUsr,"","UPDERROR")
			lRet := .F.
		EndIf
	ElseIf Len(aCmbPrcUsr) == 0 // Usuario nao encontrado no Cadastro de Funcionarios (SRA) e tambem nao tem mais nenhum acesso
		u_AskYesNo(4000,"SchGen05","Usuario nao encontrado no Cadastro de Funcionarios (SRA)!","Verifique os cadastros relacionados ao seu usuario e tente novamente (SRA)!","Cod Usr: " + cCodUsr,"","","UPDERROR")
		lRet := .F.
	EndIf
	If lRet // Acessos validos
		// Carregamento dos Tooltips acessos usuario logado
		aEVal(aCmbPrcUsr, {|x| cAccessUsr += Chr(13) + Chr(10) + x })
		cAccessUsr += Chr(13) + Chr(10) + Chr(13) + Chr(10) + "Departamentos:"
		aEval(aGesDepts, {|x|, cAccessUsr += Chr(13) + Chr(10) + x[02] + ": " + RTrim(x[03]) })
		aSort(aCmbPrcUsr,,, {|x,y|, x < y }) // Ordenacao dos Acessos

		SetKey(VK_F7,{|| __QUIT() }) // Sair

		SetKey(VK_F5,{|| GravSoli( cCmbPrcUsr, "oGetD2" ) })    // Salvar Solicitacoes
		SetKey(VK_F8,{|| StatsChg( cObjFoc, cCmbPrcUsr ) }) // Mudanca de Status
		SetKey(VK_F10,{|| GeraSoli( cCmbPrcUsr ) }) // Gerar Solicitacao

		SetKey(VK_F11,{|| u_AskYesNo(1200,"SchRel05","Carregando dados para impressao...","","","","","PROCESSA",.T.,.F.,{|| u_SchRel05( .T., 2 ) }) }) // Imprime Carta Proposta

		//DEFINE MSDIALOG oDlg01 FROM 050,165 TO 888,1642 TITLE cTitDlg Pixel
		DEFINE MSDIALOG oDlg01 FROM 010,165 TO 888,1490 TITLE cTitDlg Pixel
		// Panel
		oPnlGd1	:= TPanel():New(030,000,,oDlg01,,,,,nClrC21,742,110,.F.,.F.) // GetDados 01 Usuarios
		oPnlGd2	:= TPanel():New(140,000,,oDlg01,,,,,nClrC23,742,070,.F.,.F.) // GetDados 02 Solicitacoes
		oPnlGd3	:= TPanel():New(210,000,,oDlg01,,,,,nClrC22,742,210,.F.,.F.) // GetDados 03 Dados Recursos Humanos
		oPnlBot	:= TPanel():New(410,000,,oDlg01,,,,,nClrC21,742,012,.F.,.F.) // Rodape (Atalhos)
		// Pesquisa Matricula Func
		@004,003 SAY	oSayPsqMat PROMPT "Psq Matric:" SIZE 040,010 OF oPnlGd1 PIXEL
		@002,033 MSGET  oGetPsqMat VAR cGetPsqMat SIZE 020,008 OF oPnlGd1 /*F3 "SRA01"*/ PIXEL PICTURE "999999" HASBUTTON
		oGetPsqMat:bGetKey := {|x,y| u_VlPsqMat(x,y) }
		// Pesquisa Nome Func
		@004,063 SAY	oSayPsqNom PROMPT "Psq Nome:" SIZE 040,010 OF oPnlGd1 PIXEL
		@002,093 MSGET  oGetPsqNom VAR cGetPsqNom SIZE 070,008 OF oPnlGd1 PIXEL PICTURE "@!" HASBUTTON
		oGetPsqNom:bGetKey := {|x,y| u_VlPsqNom(x,y) }
		// Mostrar apenas pendencias
		@004,165 CHECKBOX oChkPenden VAR lChkPenden PROMPT "Mostrar apenas pendencias" SIZE 100,008 OF oPnlGd1 PIXEL ON CHANGE LdsUsers( cCmbPrcUsr, cGetPsqMat, cGetPsqNom, lChkPenden, lChkAllSol )
		// Mostrar por gestor
		@004,255 SAY	oSayGestor PROMPT "Gestor:" SIZE 080,010 OF oPnlGd1 PIXEL
		@002,277 MSCOMBOBOX oCmbGestor VAR cCmbGestor ITEMS aCmbGestor SIZE 110,011 OF oPnlGd1 Pixel
		oCmbGestor:bChange := {|| LdsUsers( cCmbPrcUsr, cGetPsqMat, cGetPsqNom, lChkPenden, lChkAllSol, oCmbGestor:nAt ) }

		// Mostrar todas (desativado)
		// @004,280 CHECKBOX oChkAllSol VAR lChkAllSol PROMPT "Mostrar todas as solicitacoes" SIZE 100,008 OF oPnlGd1 PIXEL

		// Acessos
		@004,395 SAY	oSayPrcUsr PROMPT "Acessos:" SIZE 080,010 OF oPnlGd1 PIXEL
		@002,425 MSCOMBOBOX oCmbPrcUsr VAR cCmbPrcUsr ITEMS aCmbPrcUsr SIZE 070,011 OF oPnlGd1 Pixel ON CHANGE LdsUsers( cCmbPrcUsr, cGetPsqMat, cGetPsqNom, lChkPenden, lChkAllSol )
		oCmbPrcUsr:cToolTip := "Escolha do acesso de processamento conforme acessos do usuario" + Chr(13) + Chr(10) + "Gestor, Recursos Humanos ou Presidencia"
		// Botao Incluir Solicitacao F10
		@002,500 BUTTON oBtnGerSol PROMPT "Incluir Solicitacao" SIZE 050,010 Action( GeraSoli( cCmbPrcUsr ) ) Pixel Of oPnlGd1
		oBtnGerSol:cToolTip := "Incluir uma nova solicitacao"
		// Botao Gravara Solicitacoes F5
		@002,555 BUTTON oBtnGrvSol PROMPT "Salvar Solicitacao" SIZE 050,010 Action( GravSoli( cCmbPrcUsr, "oGetD2" ) ) Pixel Of oPnlGd1
		oBtnGrvSol:cToolTip := "Salvar a solicitacao nova incluida ou gravar alteracao de status de solicitacao"
		// Botao Mudanca Status Solicitacao F8
		@002,610 BUTTON oBtnStaSol PROMPT "Alt. Status Solic." SIZE 050,010 Action( StatsChg( cObjFoc, cCmbPrcUsr ) ) Pixel Of oPnlGd1
		oBtnStaSol:cToolTip := "Alterar status da solicitacao tomando uma decisao ou enviando para analise de outro departamento (Recursos Humanos/Presidencia)"
		// GetDados 01: Usuarios dos Departamentos
		oGetD1 := MsNewGetDados():New(015,002,105,660,Nil,"AllwaysTrue()",,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlGd1,aHdr01,aCls01)
		oGetD1:oBrowse:lHScroll := .T.
		oGetD1:oBrowse:SetBlkBackColor({|| GetD1Clr(oGetD1:aCols, oGetD1:nAt, aHdr01) })
		oGetD1:bChange := {|| ChangGet( cObjFoc, cCmbPrcUsr ) }
		oGetD1:oBrowse:bGotFocus := {|| cObjFoc := "oGetD1" }
		// GetDados 02: Solicitacoes
		oGetD2 := MsNewGetDados():New(002,002,070,660, GD_UPDATE ,"AllwaysTrue()",,,aFldsAlt02,,,,,"AllwaysTrue()",oPnlGd2,aHdr02,aCls02)
		oGetD2:oBrowse:lHScroll := .T.
		oGetD2:oBrowse:SetBlkBackColor({|| GetD2Clr(oGetD2:aCols, oGetD2:nAt, aHdr02) })
		oGetD2:bChange := {|| nLineZG2 := oGetD2:nAt, oGetD2:Refresh() }
		oGetD2:oBrowse:bGotFocus := {|| cObjFoc := "oGetD2" }

		// Folder EAA / Alteracoes Salariais
		oFolder := TFolder():New(002,002,aFolder,,oPnlGd3,,,,.T.,,665,195) // EAA, Alteracoes Salariais

		// Folder Metas, Avaliacoes, etc
		oFolEAA := TFolder():New(012,000,aFolEAA,,oFolder:aDialogs[01],,,,.T.,,660,165)

		// Anos Metas
		oRadAnos := TRadMenu():New (002,005,aRadAnos, {|u| Iif(PCount() == 0, nRadAnos, nRadAnos := u) }, oFolder:aDialogs[ 01 ],, {|| LdsMetas( oGetD1:aCols[ oGetD1:nAt, nP01MatFil ], oGetD1:aCols[ oGetD1:nAt, nP01MatFun ], aRadAnos[ oRadAnos:nOption ] ) },,,,.T.,,100,12,,,,.T.)
		oRadAnos:lHoriz := .T.

		// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ PPM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		// Linha 01

		@003,006 SAY	oSayNotaFm PROMPT "Nota:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
		@001,036 MSGET	oGetNotaFm VAR cGetNotaFm SIZE 120,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY

	/*
    @003,006 SAY	oSayFlds01 PROMPT "Nome:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@001,036 MSGET	oGetFlds01 VAR cGetFlds01 SIZE 200,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @003,266 SAY	oSayFlds02 PROMPT "" SIZE 060,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@001,296 MSGET	oGetFlds02 VAR cGetFlds02 SIZE 140,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @003,526 SAY	oSayFlds09 PROMPT "09:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@001,556 MSGET	oGetFlds09 VAR cGetFlds09 SIZE 020,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    // Linha 02
    @016,006 SAY	oSayFlds03 PROMPT "Depto:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@014,036 MSGET	oGetFlds03 VAR cGetFlds03 SIZE 140,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @016,266 SAY	oSayFlds04 PROMPT "Usuario:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@014,296 MSGET	oGetFlds04 VAR cGetFlds04 SIZE 040,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @016,526 SAY	oSayFlds10 PROMPT "10:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@014,556 MSGET	oGetFlds10 VAR cGetFlds10 SIZE 020,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    // Linha 03
    @029,006 SAY	oSayFlds05 PROMPT "Data Ini:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@027,036 MSGET	oGetFlds05 VAR dGetFlds05 SIZE 035,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @029,106 SAY	oSayFlds06 PROMPT "Data Fim:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@027,136 MSGET	oGetFlds06 VAR dGetFlds06 SIZE 035,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    @029,526 SAY	oSayFlds11 PROMPT "11:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@027,556 MSGET	oGetFlds11 VAR cGetFlds11 SIZE 020,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    // Linha 04
    @042,006 SAY	oSayFlds07 PROMPT "Memo 07:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@040,036 GET	oGetFlds07 VAR cGetFlds07 SIZE 220,075 OF oFolEAA:aDialogs[ 11 ] MULTILINE PIXEL READONLY
    @042,266 SAY	oSayFlds08 PROMPT "Memo 08:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@040,296 GET	oGetFlds08 VAR cGetFlds08 SIZE 220,075 OF oFolEAA:aDialogs[ 11 ] MULTILINE PIXEL READONLY
    @042,526 SAY	oSayFlds12 PROMPT "12:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@040,556 MSGET	oGetFlds12 VAR cGetFlds12 SIZE 020,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
    // Linha 05
    @055,526 SAY	oSayFlds13 PROMPT "13:" SIZE 040,010 OF oFolEAA:aDialogs[ 11 ] PIXEL
	@053,556 MSGET	oGetFlds13 VAR cGetFlds13 SIZE 020,008 OF oFolEAA:aDialogs[ 11 ] PIXEL READONLY
	*/
		// Linha 06


		// ########################### Target 01 ###########################
		@003,006 SAY	oSayTarg01 PROMPT "Target 01:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@001,036 MSGET	oGetTarg01 VAR cGetTarg01 SIZE 040,008 OF oFolEAA:aDialogs[ 01 ] PIXEL READONLY
		// Calibracao Realizada?
		@003,086 CHECKBOX oChkCali01 VAR lChkCali01 PROMPT "Calibracao Realizada?" SIZE 100,008 OF oFolEAA:aDialogs[ 01 ] PIXEL
		// %
		@003,176 SAY	oSayPerc01 PROMPT "%:" SIZE 020,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@001,186 MSGET	oGetPerc01 VAR nGetPerc01 SIZE 020,008 OF oFolEAA:aDialogs[ 01 ] PICTURE "@E 999.99" PIXEL READONLY
		// Minimo 05
		@016,006 SAY	oSayMini01 PROMPT "Minimo 01:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@014,036 MSGET	oGetMini01 VAR cGetMini01 SIZE 040,008 OF oFolEAA:aDialogs[ 01 ] PIXEL READONLY
		// Maximo 05
		@016,086 SAY	oSayMaxi01 PROMPT "Maximo 01:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@014,116 MSGET	oGetMaxi01 VAR cGetMaxi01 SIZE 040,008 OF oFolEAA:aDialogs[ 01 ] PIXEL READONLY
		// Meta 05
		@029,006 SAY	oSayMeta01 PROMPT "Meta 01:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@041,006 GET	oGetMeta01 VAR cGetMeta01 SIZE 220,075 OF oFolEAA:aDialogs[ 01 ] MULTILINE PIXEL READONLY
		// Performance A
		@016,246 MSCOMBOBOX oCmbPerA01 VAR cCmbPerA01 ITEMS aPerformsA SIZE 125,011 OF oFolEAA:aDialogs[ 01 ] Pixel
		// Obs Part. 5
		@029,246 SAY	oSayObsP01 PROMPT "Obs Part. 1:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@041,246 GET	oGetObsP01 VAR cGetObsP01 SIZE 220,075 OF oFolEAA:aDialogs[ 01 ] MULTILINE PIXEL READONLY
		// Performance B
		@016,486 MSCOMBOBOX oCmbPerB01 VAR cCmbPerB01 ITEMS aPerformsB SIZE 125,011 OF oFolEAA:aDialogs[ 01 ] Pixel
		// Avaliador
		@029,486 SAY	oSayAval01 PROMPT "Avaliador:" SIZE 040,010 OF oFolEAA:aDialogs[ 01 ] PIXEL
		@041,486 GET	oGetAval01 VAR cGetAval01 SIZE 220,075 OF oFolEAA:aDialogs[ 01 ] MULTILINE PIXEL READONLY
		// ########################### Target 02 ###########################
		@003,006 SAY	oSayTarg02 PROMPT "Target 02:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@001,036 MSGET	oGetTarg02 VAR cGetTarg02 SIZE 040,008 OF oFolEAA:aDialogs[ 02 ] PIXEL READONLY
		// Calibracao Realizada?
		@003,086 CHECKBOX oChkCali02 VAR lChkCali02 PROMPT "Calibracao Realizada?" SIZE 100,008 OF oFolEAA:aDialogs[ 02 ] PIXEL
		// %
		@003,176 SAY	oSayPerc02 PROMPT "%:" SIZE 020,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@001,186 MSGET	oGetPerc02 VAR nGetPerc02 SIZE 020,008 OF oFolEAA:aDialogs[ 02 ] PICTURE "@E 999.99" PIXEL READONLY
		// Minimo 02
		@016,006 SAY	oSayMini02 PROMPT "Minimo 02:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@014,036 MSGET	oGetMini02 VAR cGetMini02 SIZE 040,008 OF oFolEAA:aDialogs[ 02 ] PIXEL READONLY
		// Maximo 02
		@016,086 SAY	oSayMaxi02 PROMPT "Maximo 02:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@014,116 MSGET	oGetMaxi02 VAR cGetMaxi02 SIZE 040,008 OF oFolEAA:aDialogs[ 02 ] PIXEL READONLY
		// Meta 02
		@029,006 SAY	oSayMeta02 PROMPT "Meta 02:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@041,006 GET	oGetMeta02 VAR cGetMeta02 SIZE 220,075 OF oFolEAA:aDialogs[ 02 ] MULTILINE PIXEL READONLY
		// Performance A
		@016,246 MSCOMBOBOX oCmbPerA02 VAR cCmbPerA02 ITEMS aPerformsA SIZE 125,011 OF oFolEAA:aDialogs[ 02 ] Pixel
		// Obs Part. 2
		@029,246 SAY	oSayObsP02 PROMPT "Obs Part. 2:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@041,246 GET	oGetObsP02 VAR cGetObsP02 SIZE 220,075 OF oFolEAA:aDialogs[ 02 ] MULTILINE PIXEL READONLY
		// Performance B
		@016,486 MSCOMBOBOX oCmbPerB02 VAR cCmbPerB02 ITEMS aPerformsB SIZE 125,011 OF oFolEAA:aDialogs[ 02 ] Pixel
		// Avaliador
		@029,486 SAY	oSayAval02 PROMPT "Avaliador:" SIZE 040,010 OF oFolEAA:aDialogs[ 02 ] PIXEL
		@041,486 GET	oGetAval02 VAR cGetAval02 SIZE 220,075 OF oFolEAA:aDialogs[ 02 ] MULTILINE PIXEL READONLY
		// ########################### Target 03 ###########################
		@003,006 SAY	oSayTarg03 PROMPT "Target 03:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@001,036 MSGET	oGetTarg03 VAR cGetTarg03 SIZE 040,008 OF oFolEAA:aDialogs[ 03 ] PIXEL READONLY
		// Calibracao Realizada?
		@003,086 CHECKBOX oChkCali03 VAR lChkCali03 PROMPT "Calibracao Realizada?" SIZE 100,008 OF oFolEAA:aDialogs[ 03 ] PIXEL
		// %
		@003,176 SAY	oSayPerc03 PROMPT "%:" SIZE 020,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@001,186 MSGET	oGetPerc03 VAR nGetPerc03 SIZE 020,008 OF oFolEAA:aDialogs[ 03 ] PICTURE "@E 999.99" PIXEL READONLY
		// Minimo 03
		@016,006 SAY	oSayMini03 PROMPT "Minimo 03:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@014,036 MSGET	oGetMini03 VAR cGetMini03 SIZE 040,008 OF oFolEAA:aDialogs[ 03 ] PIXEL READONLY
		// Maximo 03
		@016,086 SAY	oSayMaxi03 PROMPT "Maximo 03:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@014,116 MSGET	oGetMaxi03 VAR cGetMaxi03 SIZE 040,008 OF oFolEAA:aDialogs[ 03 ] PIXEL READONLY
		// Meta 03
		@029,006 SAY	oSayMeta03 PROMPT "Meta 03:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@041,006 GET	oGetMeta03 VAR cGetMeta03 SIZE 220,075 OF oFolEAA:aDialogs[ 03 ] MULTILINE PIXEL READONLY
		// Performance A
		@016,246 MSCOMBOBOX oCmbPerA03 VAR cCmbPerA03 ITEMS aPerformsA SIZE 125,011 OF oFolEAA:aDialogs[ 03 ] Pixel
		// Obs Part. 3
		@029,246 SAY	oSayObsP03 PROMPT "Obs Part. 3:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@041,246 GET	oGetObsP03 VAR cGetObsP03 SIZE 220,075 OF oFolEAA:aDialogs[ 03 ] MULTILINE PIXEL READONLY
		// Performance B
		@016,486 MSCOMBOBOX oCmbPerB03 VAR cCmbPerB03 ITEMS aPerformsB SIZE 125,011 OF oFolEAA:aDialogs[ 03 ] Pixel
		// Avaliador
		@029,486 SAY	oSayAval03 PROMPT "Avaliador:" SIZE 040,010 OF oFolEAA:aDialogs[ 03 ] PIXEL
		@041,486 GET	oGetAval03 VAR cGetAval03 SIZE 220,075 OF oFolEAA:aDialogs[ 03 ] MULTILINE PIXEL READONLY
		// ########################### Target 04 ###########################
		@003,006 SAY	oSayTarg04 PROMPT "Target 04:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@001,036 MSGET	oGetTarg04 VAR cGetTarg04 SIZE 040,008 OF oFolEAA:aDialogs[ 04 ] PIXEL READONLY
		// Calibracao Realizada?
		@003,086 CHECKBOX oChkCali04 VAR lChkCali04 PROMPT "Calibracao Realizada?" SIZE 100,008 OF oFolEAA:aDialogs[ 04 ] PIXEL
		// %
		@003,176 SAY	oSayPerc04 PROMPT "%:" SIZE 020,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@001,186 MSGET	oGetPerc04 VAR nGetPerc04 SIZE 020,008 OF oFolEAA:aDialogs[ 04 ] PICTURE "@E 999.99" PIXEL READONLY
		// Minimo 04
		@016,006 SAY	oSayMini04 PROMPT "Minimo 04:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@014,036 MSGET	oGetMini04 VAR cGetMini04 SIZE 040,008 OF oFolEAA:aDialogs[ 04 ] PIXEL READONLY
		// Maximo 04
		@016,086 SAY	oSayMaxi04 PROMPT "Maximo 04:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@014,116 MSGET	oGetMaxi04 VAR cGetMaxi04 SIZE 040,008 OF oFolEAA:aDialogs[ 04 ] PIXEL READONLY
		// Meta 04
		@029,006 SAY	oSayMeta04 PROMPT "Meta 04:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@041,006 GET	oGetMeta04 VAR cGetMeta04 SIZE 220,075 OF oFolEAA:aDialogs[ 04 ] MULTILINE PIXEL READONLY
		// Performance A
		@016,246 MSCOMBOBOX oCmbPerA04 VAR cCmbPerA04 ITEMS aPerformsA SIZE 125,011 OF oFolEAA:aDialogs[ 04 ] Pixel
		// Obs Part. 4
		@029,246 SAY	oSayObsP04 PROMPT "Obs Part. 4:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@041,246 GET	oGetObsP04 VAR cGetObsP04 SIZE 220,075 OF oFolEAA:aDialogs[ 04 ] MULTILINE PIXEL READONLY
		// Performance B
		@016,486 MSCOMBOBOX oCmbPerB04 VAR cCmbPerB04 ITEMS aPerformsB SIZE 125,011 OF oFolEAA:aDialogs[ 04 ] Pixel
		// Avaliador
		@029,486 SAY	oSayAval04 PROMPT "Avaliador:" SIZE 040,010 OF oFolEAA:aDialogs[ 04 ] PIXEL
		@041,486 GET	oGetAval04 VAR cGetAval04 SIZE 220,075 OF oFolEAA:aDialogs[ 04 ] MULTILINE PIXEL READONLY
		// ########################### Target 05 ###########################
		@003,006 SAY	oSayTarg05 PROMPT "Target 05:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@001,036 MSGET	oGetTarg05 VAR cGetTarg05 SIZE 040,008 OF oFolEAA:aDialogs[ 05 ] PIXEL READONLY
		// Calibracao Realizada?
		@003,086 CHECKBOX oChkCali05 VAR lChkCali05 PROMPT "Calibracao Realizada?" SIZE 100,008 OF oFolEAA:aDialogs[ 05 ] PIXEL
		// %
		@003,176 SAY	oSayPerc05 PROMPT "%:" SIZE 020,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@001,186 MSGET	oGetPerc05 VAR nGetPerc05 SIZE 020,008 OF oFolEAA:aDialogs[ 05 ] PICTURE "@E 999.99" PIXEL READONLY
		// Minimo 05
		@016,006 SAY	oSayMini05 PROMPT "Minimo 05:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@014,036 MSGET	oGetMini05 VAR cGetMini05 SIZE 040,008 OF oFolEAA:aDialogs[ 05 ] PIXEL READONLY
		// Maximo 05
		@016,086 SAY	oSayMaxi05 PROMPT "Maximo 05:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@014,116 MSGET	oGetMaxi05 VAR cGetMaxi05 SIZE 040,008 OF oFolEAA:aDialogs[ 05 ] PIXEL READONLY
		// Meta 05
		@029,006 SAY	oSayMeta05 PROMPT "Meta 05:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@041,006 GET	oGetMeta05 VAR cGetMeta05 SIZE 220,075 OF oFolEAA:aDialogs[ 05 ] MULTILINE PIXEL READONLY
		// Performance A
		@016,246 MSCOMBOBOX oCmbPerA05 VAR cCmbPerA05 ITEMS aPerformsA SIZE 125,011 OF oFolEAA:aDialogs[ 05 ] Pixel
		// Obs Part. 5
		@029,246 SAY	oSayObsP05 PROMPT "Obs Part. 5:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@041,246 GET	oGetObsP05 VAR cGetObsP05 SIZE 220,075 OF oFolEAA:aDialogs[ 05 ] MULTILINE PIXEL READONLY
		// Performance B
		@016,486 MSCOMBOBOX oCmbPerB05 VAR cCmbPerB05 ITEMS aPerformsB SIZE 125,011 OF oFolEAA:aDialogs[ 05 ] Pixel
		// Avaliador
		@029,486 SAY	oSayAval05 PROMPT "Avaliador:" SIZE 040,010 OF oFolEAA:aDialogs[ 05 ] PIXEL
		@041,486 GET	oGetAval05 VAR cGetAval05 SIZE 220,075 OF oFolEAA:aDialogs[ 05 ] MULTILINE PIXEL READONLY
		// ###########################
		// Avaliacao Comportamental
		// Participante
		tGroup():New(002, 002, 090, 200, "Participante:", oFolEAA:aDialogs[ 06 ],,,.T.)
		@013,006 SAY	oSayClien1 PROMPT "Cliente 1º:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@011,066 MSCOMBOBOX oCmbPClien VAR cCmbPClien ITEMS aPCliente SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@026,006 SAY	oSaySerDiv PROMPT "Ser Diverso:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@024,066 MSCOMBOBOX oCmbPSerDi VAR cCmbPSerDi ITEMS aPSerDive SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@039,006 SAY	oSayAgeDon PROMPT "Age=Dono:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@037,066 MSCOMBOBOX oCmbPAgeDo VAR cCmbPAgeDo ITEMS aPAgeIDon SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@052,006 SAY	oSayDisRup PROMPT "Disruptivo:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@050,066 MSCOMBOBOX oCmbPDisRu VAR cCmbPDisRu ITEMS aPDisRupt SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@065,006 SAY	oSayAprend PROMPT "Aprendizagem:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@063,066 MSCOMBOBOX oCmbPApren VAR cCmbPApren ITEMS aPAprendi SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		// Avaliador
		tGroup():New(002, 212, 090, 410, "Avaliador:", oFolEAA:aDialogs[ 06 ],,,.T.)
		@013,216 SAY	oSayClien1 PROMPT "Cliente 1º:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@011,276 MSCOMBOBOX oCmbAClien VAR cCmbAClien ITEMS aACliente SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@026,216 SAY	oSaySerDiv PROMPT "Ser Diverso:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@024,276 MSCOMBOBOX oCmbASerDi VAR cCmbASerDi ITEMS aASerDive SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@039,216 SAY	oSayAgeDon PROMPT "Age=Dono:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@037,276 MSCOMBOBOX oCmbAAgeDo VAR cCmbAAgeDo ITEMS aAAgeIDon SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@052,216 SAY	oSayDisRup PROMPT "Disruptivo:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@050,276 MSCOMBOBOX oCmbADisRu VAR cCmbADisRu ITEMS aADisRupt SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		@065,216 SAY	oSayAprend PROMPT "Aprendizagem:" SIZE 040,010 OF oFolEAA:aDialogs[ 06 ] PIXEL
		@063,276 MSCOMBOBOX oCmbAApren VAR cCmbAApren ITEMS aAAprendi SIZE 125,011 OF oFolEAA:aDialogs[ 06 ] Pixel
		// Avaliacao Final
		// Participante
		tGroup():New(002, 002, 118, 235, "Participante:", oFolEAA:aDialogs[ 07 ],,,.T.)
		@013,006 SAY	oSayAvPart PROMPT "Avaliacao:" SIZE 040,010 OF oFolEAA:aDialogs[ 07 ] PIXEL
		@011,046 MSCOMBOBOX oCmbAvPart VAR cCmbAvPart ITEMS aAvalPart SIZE 125,011 OF oFolEAA:aDialogs[ 07 ] Pixel
		@026,006 SAY	oSayCome02 PROMPT "Comentarios:" SIZE 040,010 OF oFolEAA:aDialogs[ 07 ] PIXEL
		@038,006 GET	oGetCome02 VAR cGetCome02 SIZE 220,075 OF oFolEAA:aDialogs[ 07 ] MULTILINE PIXEL READONLY
		// Avaliador
		tGroup():New(002, 242, 118, 480, "Avaliador:", oFolEAA:aDialogs[ 07 ],,,.T.)
		@013,246 SAY	oSayAvAval PROMPT "Avaliacao:" SIZE 040,010 OF oFolEAA:aDialogs[ 07 ] PIXEL
		@011,286 MSCOMBOBOX oCmbAvAval VAR cCmbAvAval ITEMS aAvalAval SIZE 125,011 OF oFolEAA:aDialogs[ 07 ] Pixel
		@013,422 SAY	oSayAvPerc PROMPT "% Final:" SIZE 020,010 OF oFolEAA:aDialogs[ 07 ] PIXEL
		@011,446 MSGET	oGetAvPerc VAR nGetAvPerc SIZE 020,008 OF oFolEAA:aDialogs[ 07 ] PICTURE "@E 999.99" PIXEL READONLY
		@026,246 SAY	oSayCome01 PROMPT "Comentarios:" SIZE 040,010 OF oFolEAA:aDialogs[ 07 ] PIXEL
		@038,246 GET	oGetCome01 VAR cGetCome01 SIZE 220,075 OF oFolEAA:aDialogs[ 07 ] MULTILINE PIXEL READONLY
		// Desenv Funcionario
		@003,006 SAY	oSayDesenv PROMPT "Descreva aqui um breve resumo da sua conversa referente ao desenvolvimento da carreira do colaborador:" SIZE 340,010 OF oFolEAA:aDialogs[ 08 ] PIXEL
		@015,006 GET	oGetDesenv VAR cGetDesenv SIZE 280,075 OF oFolEAA:aDialogs[ 08 ] MULTILINE PIXEL READONLY
		// PDI
		oScrPDI := TScrollBox():New( oFolEAA:aDialogs[ 09 ], 003, 003, 120, 720, .T., .T., .T.)
		// PH3_PDI03 Char 100
		@003,006 SAY	oSayProxCa PROMPT "Qual o proximo cargo almejado na sua carreira?" SIZE 140,010 OF oScrPDI PIXEL
		@011,006 MSGET	oGetProxCa VAR cGetProxCa SIZE 220,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI05 Char 100
		@024,006 SAY	oSayPonto1 PROMPT "Quais sao seus pontos fortes?" SIZE 090,010 OF oScrPDI PIXEL
		@030,006 SAY    oSayPonto2 PROMPT "[considere pontos fortes, aqueles que te fortalecem para assumir a posicao almejada]" SIZE 260,010 OF oScrPDI PIXEL
		@038,006 MSGET	oGetPontFo VAR cGetPontFo SIZE 220,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI04 Combo
		@051,006 SAY	oSayTransf PROMPT "Voce possui interesse e disponibilidade para ser transferido (a) para outra cidade/estado ou pais?" SIZE 260,010 OF oScrPDI PIXEL
		@059,006 MSCOMBOBOX oCmbTransf VAR cCmbTransf ITEMS aTransferi SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI06 Char 100
		@072,006 SAY	oSayPontD1 PROMPT "Quais sao seus pontos a desenvolver?" SIZE 160,010 OF oScrPDI PIXEL
		@078,006 SAY	oSayPontD2 PROMPT "[considere os pontos a desenvolver que sao essenciais para assumir a posicao almejada]" SIZE 260,010 OF oScrPDI PIXEL
		@086,006 MSGET	oGetPontDe VAR cGetPontDe SIZE 220,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI32 Memo
		@003,276 SAY	oSayInfAdi PROMPT "Caso queira, utilize este espaco para inserir informacoes adicionais ao seu plano de desenvolvimento." SIZE 300,010 OF oScrPDI PIXEL
		@011,276 GET	oGetInfAdi VAR cGetInfAdi SIZE 250,080 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI07 Char 100
		@099,006 SAY	oSayNoMt01 PROMPT "Nome da meta 01:" SIZE 140,010 OF oScrPDI PIXEL
		@107,006 MSGET	oGetNoMt01 VAR cGetNoMt01 SIZE 120,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI08 Memo
		@099,146 SAY	oSayDsMt01 PROMPT "Descricao da meta 01:" SIZE 140,010 OF oScrPDI PIXEL
		@107,146 GET	oGetDsMt01 VAR cGetDsMt01 SIZE 180,075 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI11 Combo
		@120,006 SAY	oSayCgMt01 PROMPT "Categoria da meta 01:" SIZE 140,010 OF oScrPDI PIXEL
		@128,006 MSCOMBOBOX oCmbCgMt01 VAR cCmbCgMt01 ITEMS aCategMt01 SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI09 Data
		@141,006 SAY	oSayInMt01 PROMPT "Data Inicial da meta 01:" SIZE 140,010 OF oScrPDI PIXEL
		@149,006 MSGET	oGetInMt01 VAR dGetInMt01 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI10 Data
		@162,006 SAY	oSayFiMt01 PROMPT "Data de conclusao prevista meta 01:" SIZE 140,010 OF oScrPDI PIXEL
		@170,006 MSGET	oGetFiMt01 VAR dGetFiMt01 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI12 Char 100
		@099,366 SAY	oSayNoMt02 PROMPT "Nome da meta 02:" SIZE 140,010 OF oScrPDI PIXEL
		@107,366 MSGET	oGetNoMt02 VAR cGetNoMt02 SIZE 120,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI13 Memo
		@099,506 SAY	oSayDsMt02 PROMPT "Descricao da meta 02:" SIZE 140,010 OF oScrPDI PIXEL
		@107,506 GET	oGetDsMt02 VAR cGetDsMt02 SIZE 180,075 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI16 Combo
		@120,366 SAY	oSayCgMt02 PROMPT "Categoria da meta 02:" SIZE 140,010 OF oScrPDI PIXEL
		@128,366 MSCOMBOBOX oCmbCgMt02 VAR cCmbCgMt02 ITEMS aCategMt02 SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI14 Data
		@141,366 SAY	oSayInMt02 PROMPT "Data Inicial da meta 02:" SIZE 140,010 OF oScrPDI PIXEL
		@149,366 MSGET	oGetInMt02 VAR dGetInMt02 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI15 Data
		@162,366 SAY	oSayFiMt02 PROMPT "Data de conclusao prevista meta 02:" SIZE 140,010 OF oScrPDI PIXEL
		@170,366 MSGET	oGetFiMt02 VAR dGetFiMt02 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI17 Char 100
		@199,006 SAY	oSayNoMt03 PROMPT "Nome da meta 03:" SIZE 140,010 OF oScrPDI PIXEL
		@207,006 MSGET	oGetNoMt03 VAR cGetNoMt03 SIZE 120,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI18 Memo
		@199,146 SAY	oSayDsMt03 PROMPT "Descricao da meta 03:" SIZE 140,010 OF oScrPDI PIXEL
		@207,146 GET	oGetDsMt03 VAR cGetDsMt03 SIZE 180,075 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI21 Combo
		@220,006 SAY	oSayCgMt03 PROMPT "Categoria da meta 03:" SIZE 140,010 OF oScrPDI PIXEL
		@228,006 MSCOMBOBOX oCmbCgMt03 VAR cCmbCgMt03 ITEMS aCategMt03 SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI19 Data
		@241,006 SAY	oSayInMt03 PROMPT "Data Inicial da meta 03:" SIZE 140,010 OF oScrPDI PIXEL
		@249,006 MSGET	oGetInMt03 VAR dGetInMt03 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI20 Data
		@262,006 SAY	oSayFiMt03 PROMPT "Data de conclusao prevista meta 03:" SIZE 140,010 OF oScrPDI PIXEL
		@270,006 MSGET	oGetFiMt03 VAR dGetFiMt03 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI22 Char 100
		@199,366 SAY	oSayNoMt04 PROMPT "Nome da meta 04:" SIZE 140,010 OF oScrPDI PIXEL
		@207,366 MSGET	oGetNoMt04 VAR cGetNoMt04 SIZE 120,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI23 Memo
		@199,506 SAY	oSayDsMt04 PROMPT "Descricao da meta 04:" SIZE 140,010 OF oScrPDI PIXEL
		@207,506 GET	oGetDsMt04 VAR cGetDsMt04 SIZE 180,075 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI26 Combo
		@220,366 SAY	oSayCgMt04 PROMPT "Categoria da meta 04:" SIZE 140,010 OF oScrPDI PIXEL
		@228,366 MSCOMBOBOX oCmbCgMt04 VAR cCmbCgMt04 ITEMS aCategMt04 SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI24 Data
		@241,366 SAY	oSayInMt04 PROMPT "Data Inicial da meta 04:" SIZE 140,010 OF oScrPDI PIXEL
		@249,366 MSGET	oGetInMt04 VAR dGetInMt04 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI25 Data
		@262,366 SAY	oSayFiMt04 PROMPT "Data de conclusao prevista meta 04:" SIZE 140,010 OF oScrPDI PIXEL
		@270,366 MSGET	oGetFiMt04 VAR dGetFiMt04 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI27 Char 100
		@299,006 SAY	oSayNoMt05 PROMPT "Nome da meta 05:" SIZE 140,010 OF oScrPDI PIXEL
		@307,006 MSGET	oGetNoMt05 VAR cGetNoMt05 SIZE 120,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI28 Memo
		@299,146 SAY	oSayDsMt05 PROMPT "Descricao da meta 05:" SIZE 140,010 OF oScrPDI PIXEL
		@307,146 GET	oGetDsMt05 VAR cGetDsMt05 SIZE 180,075 OF oScrPDI MULTILINE PIXEL READONLY
		// PH3_PDI31 Combo
		@320,006 SAY	oSayCgMt05 PROMPT "Categoria da meta 05:" SIZE 140,010 OF oScrPDI PIXEL
		@328,006 MSCOMBOBOX oCmbCgMt05 VAR cCmbCgMt05 ITEMS aCategMt05 SIZE 125,011 OF oScrPDI Pixel
		// PH3_PDI29 Data
		@341,006 SAY	oSayInMt05 PROMPT "Data Inicial da meta 05:" SIZE 140,010 OF oScrPDI PIXEL
		@349,006 MSGET	oGetInMt05 VAR dGetInMt05 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// PH3_PDI30 Data
		@362,006 SAY	oSayFiMt05 PROMPT "Data de conclusao prevista meta 05:" SIZE 140,010 OF oScrPDI PIXEL
		@370,006 MSGET	oGetFiMt05 VAR dGetFiMt05 SIZE 035,008 OF oScrPDI PIXEL READONLY
		// Formacao Academica
		@003,006 SAY	oSayFormAc PROMPT "Formacao Academica:" SIZE 140,010 OF oFolEAA:aDialogs[ 10 ] PIXEL
		@011,006 GET	oGetFormAc VAR cGetFormAc SIZE 220,075 OF oFolEAA:aDialogs[ 10 ] MULTILINE PIXEL READONLY
		// GetDados 03: Historico de Alteracoes Salariais
		oGetD3 := MsNewGetDados():New(002,002,160,660, Nil,"AllwaysTrue()",,,Nil,,,,,"AllwaysTrue()",oFolder:aDialogs[02],aHdr03,aCls03)
		oGetD3:oBrowse:lHScroll := .T.
		oGetD3:oBrowse:SetBlkBackColor({|| GetD3Clr(oGetD3:aCols, oGetD3:nAt, aHdr03) })
		oGetD3:oBrowse:bGotFocus := {|| cObjFoc := "oGetD3" }
		// Atalhos F's
		@002,056 SAY	oSayAtaF5   PROMPT "F5 = Salvar Solicitacao" SIZE 060,010 OF oPnlBot PIXEL
		@002,166 SAY	oSayAtaF8   PROMPT "F8 = Alterar status da solicitacao" SIZE 120,010 OF oPnlBot PIXEL
		@002,276 SAY	oSayAtaF10  PROMPT "F10 = Incluir Solicitacao" SIZE 060,010 OF oPnlBot PIXEL
		@002,386 SAY	oSayAtaF10  PROMPT "F11 = Impressao da Carta Proposta" SIZE 120,010 OF oPnlBot PIXEL
		// Usuario logado
		@002,486 SAY	oSayCodLog PROMPT "Usuario Logado:" SIZE 040,010 OF oPnlBot PIXEL
		@000,541 MSGET  oGetCodLog VAR cGetCodLog SIZE 020,008 OF oPnlBot PIXEL READONLY
		@000,567 MSGET  oGetNomLog VAR cGetNomLog SIZE 080,008 OF oPnlBot PIXEL READONLY
		oGetCodLog:cToolTip := cAccessUsr
		aObjects := { "oCmbPerA01", "oCmbPerA02", "oCmbPerA03", "oCmbPerA04", "oCmbPerA05", "oCmbPerB01", "oCmbPerB02", "oCmbPerB03", "oCmbPerB04", "oCmbPerB05" } // Combos
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lReadOnly := .T.
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		aObjects := { "oChkCali01", "oChkCali02", "oChkCali03", "oChkCali04", "oChkCali05" } // CheckBox
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		aObjects := { "oCmbPClien", "oCmbPSerDi", "oCmbPAgeDo", "oCmbPDisRu", "oCmbPApren", "oCmbAClien", "oCmbASerDi", "oCmbAAgeDo", "oCmbADisRu", "oCmbAApren" } // Combos Avaliacao Comportamental
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lReadOnly := .T.
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		aObjects := { "oCmbAvPart", "oCmbAvAval" } // Combos Avaliacao Final
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lReadOnly := .T.
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		aObjects := { "oCmbCgMt01", "oCmbCgMt02", "oCmbCgMt03", "oCmbCgMt04", "oCmbCgMt05" } // Combos PDI
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lReadOnly := .T.
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		aObjects := { "oGetCodLog", "oGetNomLog" } // Usuario Logado
		For _w1 := 1 To Len(aObjects)
			&(aObjects[ _w1 ]):lActive := .F.
			&(aObjects[ _w1 ]):Refresh()
		Next
		oGetD1:oBrowse:SetFocus()

		aAdd(aButtons, { "IMPRESSAO", {||    u_AskYesNo(1200,"SchRel05","Carregando dados para impressao...","","","","","PROCESSA",.T.,.F.,{|| u_SchRel05( .T., 2 ) })       }, "# Impressão Carta Proposta (F11)", "# Imp Carta Proposta", {|| .T. } })

		ACTIVATE MSDIALOG oDlg01 CENTERED ON INIT EnchoiceBar(oDlg01, {|| Nil },{|| oDlg01:End()},, aButtons)
		SetKey(VK_F5,{|| Nil })                 // Desativar Salvar Solicitacoes
		SetKey(VK_F8,{|| Nil })                 // Desativar Mudanca de Status
		SetKey(VK_F10,{|| Nil })                // Desativar Gerar Solicitacao
		SetKey(VK_F11,{|| Nil })                // Desativar Impressao Carta Proposta

		SetKey(VK_F7,{|| u_SCHGEN05() })		// Programa SALARY REVIEW (Fluxo Aprovacoes)	Atalho SCHGEN05 no Desenvolvimento			*** Remover depois
	EndIf
Return

Static Function GetD1Clr(aCols, nLine, aHdrs) // Cores GetDados 01
	Local nClr := nClrCA0   // Branco       *** Nao Identificado
	If nLine <= Len(aCols)
		nClr := StatsChg("oGetD1", Nil, Nil, aCols[nLine,nP01StatRg], Nil, Nil)
	EndIf
Return nClr

Static Function GetD2Clr(aCols, nLine, aHdrs) // Cores GetDados 02
	Local nClr := nClrCA0 // Branco         *** Nao Identificado
	If nLine <= Len(aCols)
		nClr := StatsChg("oGetD2", Nil, Nil, aCols[nLine,nP02StatRg], Nil, Nil)
	EndIf
Return nClr

Static Function GetD3Clr(aCols, nLine, aHdrs) // Cores GetDados 03
	Local nClr := nClrCA1 // Cinza Padrao
Return nClr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsDpAll ºAutor ³Jonathan Schmidt Alves º Data ³26/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de departamentos (SQB).             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsDpAll() // Carregamento dos Departamentos
Local aAllDepts := {}
SQB->(DbGotop())
	While SQB->(!EOF())
	//              {   Filial Depto,    Cod  Depto,      Nome Depto, Cod CCusto, Depto Superior,          Chave,,,     Filial Resp,  Matricula Resp }
	//              {             01,            02,              03,         04,             05,             06,,,              09,              10 }
	aAdd(aAllDepts, { SQB->QB_FILIAL, SQB->QB_DEPTO, SQB->QB_DESCRIC, SQB->QB_CC, SQB->QB_DEPSUP, SQB->QB_KEYINI,,, SQB->QB_FILRESP, SQB->QB_MATRESP })
	SQB->(DbSkip())
	End
Return aAllDepts

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsDpMat ºAutor ³Jonathan Schmidt Alves º Data ³26/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de departamentos do usuario (SQB).  º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cFilSRA: Filial do funcionario no SRA                      º±±
±±º          ³ cMatSRA: Matricula do funcionario no SRA                   º±±
±±º          ³ cDepSRA: Departamento do funcionario no SRA                º±±
±±º          ³          Se o departamento nao for '000000030' gerencia    º±±
±±º          ³          nao fazemos o carregamento do 1ro nivel pois no   º±±
±±º          ³          caso da presidencia apenas o nivel imediatamente  º±±
±±º          ³          abaixo deve ser considerado (gerentes).           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsDpMat(cFilSRA, cMatSRA, cDepSRA) // Carregamento dos Departamentos do Responsavel
Local _w1
Local _w3
Local nIni := 0
Local aGesDepts := {}
//>>Everson Santana
Local _aDepSupN3 := {}
Local _aDepSupN4 := {}
Local _aDepSupN5 := {}
Local _aDepSupN6 := {}
Local _aDepSupN7 := {}
//<<
aSort(aAllDepts,,, {|x,y|, x[09] + x[10] < y[09] + y[10] }) // Ordenacao por Filial + Matricula do Responsavel Departamento
	While (nIni := ASCan(aAllDepts, {|x|, x[09] + x[10] == SRA->RA_FILIAL + SRA->RA_MAT }, nIni + 1, Nil)) > 0
	//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,,,, }
	//              {                    01,                    02,                    03,                    04,                    05,                    06,,,, }
	aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
	End
// Trecho complementar de inclusao de departamentos que estao 1 nivel abaixo dos carregados
	If cDepSRA $ "000000030/" // Se for Gerente, considera 1 nivel abaixo
		For _w1 := Len( aGesDepts ) To 1 Step -1
			While (nIni := ASCan(aAllDepts, {|x|, x[05] == aGesDepts[ _w1, 02 ] }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
			//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,,,, }
			//              {                    01,                    02,                    03,                    04,                    05,                    06,,,, }
			aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
			
			Aadd(_aDepSupN3,{aAllDepts[ nIni, 02 ]})
			
			End
		//>>
			If Len(_aDepSupN3) > 0
				For _w3 := 1 To Len(_aDepSupN3)
					While (nIni := ASCan(aAllDepts, {|x|, x[05] == _aDepSupN3[ _w3, 01 ]  }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
					//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,        Nome,Nivel,, }
					//              {                    01,                    02,                    03,                    04,                    05,                    06,          07,   08,, }
					aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
					Aadd(_aDepSupN4,{aAllDepts[ nIni, 02 ]})
					End
				NEXT
			EndIf
		
		_aDepSupN3 := {}
			If Len(_aDepSupN4) > 0
				For _w3 := 1 To Len(_aDepSupN4)
					While (nIni := ASCan(aAllDepts, {|x|, x[05] == _aDepSupN4[ _w3, 01 ]  }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
					//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,        Nome,Nivel,, }
					//              {                    01,                    02,                    03,                    04,                    05,                    06,          07,   08,, }
					aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
					Aadd(_aDepSupN5,{aAllDepts[ nIni, 02 ]})
					End
				NEXT
			EndIf
		
		_aDepSupN4 := {}
		
			If Len(_aDepSupN5) > 0
				For _w3 := 1 To Len(_aDepSupN5)
					While (nIni := ASCan(aAllDepts, {|x|, x[05] == _aDepSupN5[ _w3, 01 ]  }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
					//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,        Nome,Nivel,, }
					//              {                    01,                    02,                    03,                    04,                    05,                    06,          07,   08,, }
					aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
					Aadd(_aDepSupN6,{aAllDepts[ nIni, 02 ]})
					End
				NEXT
			EndIf
		
		_aDepSupN5 := {}
		
			If Len(_aDepSupN6) > 0
				For _w3 := 1 To Len(_aDepSupN6)
					While (nIni := ASCan(aAllDepts, {|x|, x[05] == _aDepSupN6[ _w3, 01 ]  }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
					//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,        Nome,Nivel,, }
					//              {                    01,                    02,                    03,                    04,                    05,                    06,          07,   08,, }
					aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
					Aadd(_aDepSupN7,{aAllDepts[ nIni, 02 ]})
					End
				NEXT
			EndIf
		
		_aDepSupN6 := {}
		
			If Len(_aDepSupN7) > 0
				For _w3 := 1 To Len(_aDepSupN7)
					While (nIni := ASCan(aAllDepts, {|x|, x[05] == _aDepSupN7[ _w3, 01 ]  }, nIni + 1, Nil)) > 0 // Se algum departamento em que sou gestor, eh um departamento superior de outro, trago tbm (apenas nivel 1)
					//              {   Filial Departamento,     Cod  Departamento,     Nome Departamento,   Cod Centro de Custo,        Depto Superior,                 Chave,        Nome,Nivel,, }
					//              {                    01,                    02,                    03,                    04,                    05,                    06,          07,   08,, }
					aAdd(aGesDepts, { aAllDepts[ nIni, 01 ], aAllDepts[ nIni, 02 ], aAllDepts[ nIni, 03 ], aAllDepts[ nIni, 04 ], aAllDepts[ nIni, 05 ], aAllDepts[ nIni, 06 ],,,, })
					//Aadd(_aDepSupN6,{aAllDepts[ nIni, 02 ]})
					End
				
				NEXT
			EndIf
		
		_aDepSupN7 := {}
		//<<
		Next
	EndIf
aSort(aGesDepts,,, {|x,y|, x[01] + x[02] < y[01] + y[02] }) // Ordenacao conforme Cod Departamento (compartilhado)
Return aGesDepts

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsUsers ºAutor ³Jonathan Schmidt Alves º Data ³27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento dos usuarios conforme tipo de processamento.  º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ cTpLoad: Tipo de carregamento                              º±±
±±º          ³                      Ex: "1"=Gestor                        º±±
±±º          ³                          "2"=Recursos Humanos              º±±
±±º          ³                          "3"=Presidencia                   º±±
±±º          ³ cPsqMatFun: Pesquisa matricula                  (opcional) º±±
±±º          ³ cPsqNomFun: Pesquisa nome                       (opcional) º±±
±±º          ³ lChkPenden: Mostra apenas pendencias                       º±±
±±º          ³ lChkAllSol: Mostra todas as solicitacoes                   º±±
±±º          ³ nSelGestor: Item selecionado no combo de gestores          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsUsers(cTpLoad, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol, nSelGestor )
Default cPsqMatFun := ""
Default cPsqNomFun := ""
Default nSelGestor := 0
aCls01 := {}
	If cTpLoad == "1" // Carregamento dos Usuarios dos departamentos em que sou gestor
	SRA->(DbOrderNickName("USERCFG")) // RA_XUSRCFG
		If SRA->(DbSeek(cCodUsr)) // Posiciono pelo Cod Protheus
			While SRA->(!EOF()) .And. SRA->RA_XUSRCFG == cCodUsr
				If Empty(SRA->RA_DEMISSA) // Nao demitido
				aUsrDepts := LdsFuDep( cTpLoad, SRA->RA_FILIAL, SRA->RA_MAT, aGesDepts, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol )
				EndIf
			SRA->(DbSkip())
			End
		EndIf
	ElseIf cTpLoad $ "2/3/" // Carregamento dos Usuarios que possuem Solicitacoes 2=Recursos Humanos 3=Presidencia
	aUsrSolic := LdsFuSol( cTpLoad, Space(02), Space(06), Nil, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol, .T., nSelGestor )
	EndIf
cObjFoc := "oGetD1"
	If Type("oGetD1") == "O"
	oChkPenden:Refresh()
	EVal(oGetD1:bChange) // Atualizacao do GetDados 1 chamando carregamento das Solicitacoes e Metas
	EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ChangGet ºAutor ³Jonathan Schmidt Alves º Data ³27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento de dados relacionados.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChangGet(cObjFoc, cTpLoad)
Local oObj := &(cObjFoc)
	If cObjFoc == "oGetD1" // Getdados de Usuario
	RollBackSX8()
	nLineZG1 := oObj:nAt
	
	// oGetD1:oBrowse:cToolTip := "Funcionario: " + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ] + " " + oGetD1:aCols[ oGetD1:nAt, nP01NomFun ]
	
	LdsSolic(cTpLoad, oGetD1:aCols[ oGetD1:nAt, nP01MatFil ], oGetD1:aCols[ oGetD1:nAt, nP01MatFun ], lChkPenden, lChkAllSol )      // Recarrega Solicitacoes
	LdsMetas(oGetD1:aCols[ oGetD1:nAt, nP01MatFil ], oGetD1:aCols[ oGetD1:nAt, nP01MatFun ], Nil)                                   // Recarrega Metas
	LdsHisto(oGetD1:aCols[ oGetD1:nAt, nP01MatFil ], oGetD1:aCols[ oGetD1:nAt, nP01MatFun ])                                        // Recarrega Historico de Alteracoes Salariais
	
	EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsFuDep ºAutor ³Jonathan Schmidt Alves º Data ³26/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de funcionarios dos departamentos   º±±
±±º          ³ do gestor.                                                 º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTpLoad:     Tipo de carregamento                          º±±
±±º          ³                          1=Gestor                          º±±
±±º          ³                          2=Recursos Humanos                º±±
±±º          ³                          3=Presidencia                     º±±
±±º          ³                                                            º±±
±±º          ³ cFilGes:     Filial do gestor no SRA                       º±±
±±º          ³ cMatGes:     Matricula do gestor no SRA                    º±±
±±º          ³ aGesDepts:   Departamentos em que o usuario eh gestor      º±±
±±º          ³ cPsqMatFun:  Pesquisa matricula do funcionario             º±±
±±º          ³ cPsqNomFun:  Pesquisa nome do funcionario                  º±±
±±º          ³ lChkPenden: Mostra apenas pendencias                       º±±
±±º          ³ lChkAllSol: Mostra todas as solicitacoes                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsFuDep(cTpLoad, cFilGes, cMatGes, aGesDepts, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol )
Local _w1
Local _w2
Local cStatUsr := Space(02)
Local aUsrDepts := {}

DbSelectArea("SRA")
SRA->(DbSetOrder(21)) // RA_FILIAL + RA_DEPTO + RA_MAT
	For _w1 := 1 To Len(aGesDepts) // Rodo nos departamentos
		For _w2 := 1 To Len(aFilFuncs)
			If SRA->(DbSeek(aFilFuncs[ _w2, 02 ] + aGesDepts[ _w1, 02 ]))
				While SRA->(!EOF()) .And. SRA->RA_FILIAL + SRA->RA_DEPTO == aFilFuncs[ _w2, 02 ] + aGesDepts[ _w1, 02 ]
					If Empty(SRA->RA_DEMISSA) // Nao demitido
						If (Empty( cPsqMatFun ) .Or. AllTrim( cPsqMatFun ) $ SRA->RA_MAT) .And. (Empty( cPsqNomFun ) .Or. AllTrim( cPsqNomFun ) $ SRA->RA_NOME) // Sem pesquisa de matricula/nome ou matricula/nome conforme pesquisa
						// So vou mostrar funcionario se ele tiver pendencia ou nao quiser ver so pendencia
							If !lChkPenden .Or. Len( LdsFuSol( cTpLoad, SRA->RA_FILIAL, SRA->RA_MAT, aGesDepts, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol, .F., 0 ) ) > 0 // Funcionario tem solicitacoes conforme parametros... entao mostro funcionario
							cStatUsr := Iif( StatsUsr( cTpLoad, SRA->RA_FILIAL, SRA->RA_MAT ), "P1", "P0")
							//              {    Filial Func,    Mat Func,    Nome Func,     Cod Depto,           Nome Depto,   Data Admissao,         Salario,   Status }
							//              {             01,          02,           03,            04,                   05,              06,              07,       08 }
							aAdd(aUsrDepts, { SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_NOME, SRA->RA_DEPTO, aGesDepts[ _w1, 03 ], SRA->RA_ADMISSA, SRA->RA_SALARIO, cStatUsr })
							EndIf
						EndIf
					EndIf
				SRA->(DbSkip())
				End
			EndIf
		Next
	Next
	If Len(aUsrDepts) > 0 // Dados carregados
	aSort(aUsrDepts,,, {|x,y|, x[ nP01NomFun ] < y[ nP01NomFun ] }) // Ordenacao por Nome Funcionario
	aCls01 := aClone(aUsrDepts) // Carregamento dos Usuarios
	aEVal(aCls01, {|x|, aSize(x, Len(x) + 1), x[ Len(x) ] := .F. })
	Else
	aCls01 := u_ClearCls(aHdr01)
	EndIf
// Montagem da matriz de gestores
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
	If SRA->(DbSeek( cFilGes + cMatGes ))
	aCmbGestor := { SRA->RA_NOME }
	aUsrGestor := { SRA->RA_FILIAL, SRA->RA_MAT }
		If Type("oGetD1") == "O"
		oCmbGestor:aItems := aClone(aCmbGestor)
		oCmbGestor:bChange := {|| LdsUsers( cCmbPrcUsr, cGetPsqMat, cGetPsqNom, lChkPenden, lChkAllSol, oCmbGestor:nAt ) }
		oCmbGestor:Refresh()
		EndIf
	EndIf
	If Type("oGetD1") == "O"
	oGetD1:aCols := aClone(aCls01)
	oGetD1:Refresh()
	EndIf
Return aUsrDepts

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsFuSol ºAutor ³Jonathan Schmidt Alves º Data ³26/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de funcionarios que possuem         º±±
±±º          ³ solicitacoes.                                              º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTpLoad:     Tipo de carregamento                          º±±
±±º          ³                          1=Gestor                          º±±
±±º          ³                          2=Recursos Humanos                º±±
±±º          ³                          3=Presidencia                     º±±
±±º          ³                                                            º±±
±±º          ³ cFilFun:    Filial Funcionario a procurar solicitacoes     º±±
±±º          ³ cMatFun:    Matricula Funcionario a procurar solicitacoes  º±±
±±º          ³ aGesDepts:  Nao utilizado (mantido por compatibilidade)    º±±
±±º          ³ cPsqMatFun: Pesquisa matricula do funcionario              º±±
±±º          ³ cPsqNomFun: Pesquisa nome do funcionario                   º±±
±±º          ³ lChkPenden: Mostra apenas pendencias                       º±±
±±º          ³ lChkAllSol: Mostra todas as solicitacoes (ainda nao usado) º±±
±±º          ³ lLdsUser:   Carregamento apenas de usuario                 º±±
±±º          ³ nSelGestor: Item selecionado no combo com o Gestor         º±±
±±º          ³                                                            º±±
±±º          ³ Pendencias Gestor:               "A2/A4/"                  º±±
±±º          ³ Pendencias Recursos Humanos:     "B1/B3/B4/ D1/"           º±±
±±º          ³ Pendencias Presidencia:          "C1/C3/"                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsFuSol(cTpLoad, cFilFun, cMatFun, aGesDepts, cPsqMatFun, cPsqNomFun, lChkPenden, lChkAllSol, lLdsUser, nSelGestor)
Local _w2
Local cStatUsr := Space(02)
Local aUsrSolic := {}
Local aAreaSRA := SRA->(GetArea())
	If nSelGestor == 0 // Carregamento
	aCmbGestor := {}
	aUsrGestor := {}
	EndIf
DbSelectArea("SRA")
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
DbSelectArea("SQB") // Departamentos
SQB->(DbSetOrder(1)) // QB_FILIAL + QB_DEPTO
DbSelectArea("ZS2") // Solicitacoes Salary Review
ZS2->(DbSetOrder(2)) // ZS2_FILIAL + ZS2_MATFIL + ZS2_MATFUN
	For _w2 := 1 To Len(aFilFuncs)
		If Empty(cFilFun) .Or. cFilFun == aFilFuncs[ _w2, 02 ] // Todas as filiais ou so a filial desejada
		ZS2->(DbSeek( _cFilZS2 + aFilFuncs[ _w2, 02 ] + Iif(!Empty(cMatFun), cMatFun, "")))
			While ZS2->(!EOF()) .And. ZS2->ZS2_FILIAL + ZS2->ZS2_MATFIL == _cFilZS2 + aFilFuncs[ _w2, 02 ] .And. (Empty(cMatFun) .Or. cMatFun == ZS2->ZS2_MATFUN) // Filial + Matricula conforme
				If SRA->(DbSeek(ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN))
					If (Empty( cPsqMatFun ) .Or. AllTrim( cPsqMatFun ) $ SRA->RA_MAT) .And. (Empty( cPsqNomFun ) .Or. AllTrim( cPsqNomFun ) $ SRA->RA_NOME) // Sem pesquisa de matricula/nome ou matricula/nome conforme pesquisa
						If !lChkPenden .Or. ZS2->ZS2_STATRG $ { "A2/A4/", "B1/B3/B4/ D1/", "C1/C3/" } [ Val(cTpLoad) ] // Nao mostrar apenas pendencias ou se mostrar pendencias o registro esta de acordo
						cCodDepto := SRA->RA_DEPTO
						cDesDepto := Space(30)
							If Empty(SRA->RA_DEMISSA) // Nao demitido
								If !Empty(cCodDepto) .And. SQB->(DbSeek(_cFilSQB + cCodDepto))
								cDesDepto := SQB->QB_DESCRIC
								EndIf
							cStatUsr := Iif( StatsUsr( cTpLoad, SRA->RA_FILIAL, SRA->RA_MAT ), "P1", "P0")
							
								If !Empty( cCodDepto ) .And. SQB->(DbSeek( _cFilSQB + cCodDepto ))
								
								aAreaSRA := SRA->(GetArea())
									While SQB->(!EOF())
										If !Empty(SQB->QB_FILRESP + SQB->QB_MATRESP) // Responsavel
											If SRA->(DbSeek( SQB->QB_FILRESP + SQB->QB_MATRESP ))
												If Alltrim(SRA->RA_DEPTO) $ "000000030#000000011" // Usuario obrigatoriamente deve estar no Depto "000000030"=GERENCIA
												Exit
												ElseIf !Empty( SQB->QB_DEPSUP ) // Subo nivel do departamento
												SQB->(DbSeek( _cFilSQB + SQB->QB_DEPSUP))
												EndIf
											EndIf
										ElseIf !Empty( SQB->QB_DEPSUP ) // Subo nivel do departamento
										SQB->(DbSeek( _cFilSQB + SQB->QB_DEPSUP))
										Else
										Exit
										EndIf
									End
								
									If !Empty( SQB->QB_FILRESP + SQB->QB_MATRESP ) // Gestor do departamento
									
										If nSelGestor <= Len( aUsrGestor ) .And. ( nSelGestor == 0 .Or. Len(aUsrGestor[ nSelGestor ]) == 0 .Or. aUsrGestor[ nSelGestor, 01 ] + aUsrGestor[ nSelGestor, 02 ] ==  SQB->QB_FILRESP + SQB->QB_MATRESP)
										
										// aAreaSRA := SRA->(GetArea())
											If SRA->(DbSeek( SQB->QB_FILRESP + SQB->QB_MATRESP ))
											
												If ASCan( aCmbGestor, {|x|, x == SRA->RA_NOME }) == 0 // Gestor ainda nao considerado
												aAdd(aCmbGestor, SRA->RA_NOME)
												aAdd(aUsrGestor, { SRA->RA_FILIAL, SRA->RA_MAT })
												EndIf
											
											RestArea(aAreaSRA)
											//              {    Filial Func,    Mat Func,    Nome Func,     Cod Depto,      Nome Depto,   Data Admissao,         Salario,   Status }
											//              {             01,          02,           03,            04,              05,              06,              07,       08 }
											aAdd(aUsrSolic, { SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_NOME,    cCodDepto,        cDesDepto, SRA->RA_ADMISSA, SRA->RA_SALARIO, cStatUsr })
												If !Empty( cMatFun ) // Ja carregou funcionario unico, ja sai
												Exit // Pode sair logo
												Else // Varios usuarios
													If lLdsUser // Se eh carregamento de funcionarios, e ja carregou esse, vai pro proximo Func
													ZS2->(DbSeek(_cFilZS2 + aFilFuncs[ _w2, 02 ] + Soma1(ZS2->ZS2_MATFUN,6), .T.))
													Loop
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								
								
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			ZS2->(DbSkip())
			End
		EndIf
	Next
	If Len(aUsrSolic) > 0 // Usuarios com Solicitacoes
	aCls01 := aClone(aUsrSolic) // Carregamento dos Usuarios
	aEVal(aCls01, {|x|, aSize(x, Len(x) + 1), x[ Len(x) ] := .F. })
	Else
	aCls01 := u_ClearCls(aHdr01)
	EndIf
	If nSelGestor == 0 // Carregamento geral de dados
		If Len(aCmbGestor) > 1
		aSize( aCmbGestor, Len(aCmbGestor) + 1) // Aumento a matriz
		aIns( aCmbGestor, 1)    // Incluo elemento no comeco
		aCmbGestor[01] := "TODOS"
		aSize( aUsrGestor, Len(aUsrGestor) + 1) // Aumento matriz
		aIns( aUsrGestor, 1)    // Incluo elemento no comeco
		aUsrGestor[01] := {}
		EndIf
	EndIf
	If Type("oGetD1") == "O"
		If nSelGestor == 0
		oCmbGestor:aItems := aClone(aCmbGestor)
		oCmbGestor:bChange := {|| LdsUsers( cCmbPrcUsr, cGetPsqMat, cGetPsqNom, lChkPenden, lChkAllSol, oCmbGestor:nAt ) }
		oCmbGestor:Refresh()
		EndIf
	oGetD1:aCols := aClone(aCls01)
	oGetD1:Refresh()
	EndIf
RestArea(aAreaSRA)
Return aUsrSolic

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GereDept ºAutor ³Jonathan Schmidt Alves º Data ³12/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtencao do registro conforme gerente do departamento SQB. º±±
±±º          ³ Retorna o SQB posicionado com o FILRESP e MATRESP do       º±±
±±º          ³ Gerente do depart conforme hierarquia (QB_DEPSUP, etc)     º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cCodDepto:   Codigo do Departamento do funcionario         º±±
±±º          ³                                                            º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ lRet:        .T.=Caso o posicionamento ocorra com sucesso  º±±
±±º          ³              .F.=Caso o posicionamento nao ocorra          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GereDept( cCodDepto )
Local lRet := .F.
Local aArea := GetArea()
Local aAreaSRA := SRA->(GetArea())
	If SQB->(DbSeek( _cFilSQB + cCodDepto ))
		While SQB->(!EOF())
			If !Empty(SQB->QB_FILRESP + SQB->QB_MATRESP) // Responsavel
				If SRA->(DbSeek( SQB->QB_FILRESP + SQB->QB_MATRESP ))
					If Alltrim(SRA->RA_DEPTO) $ "000000030#000000011" // Usuario obrigatoriamente deve estar no Depto "000000030"=GERENCIA
					lRet := .T.
					Exit
					ElseIf !Empty( SQB->QB_DEPSUP ) // Subo nivel do departamento
					SQB->(DbSeek( _cFilSQB + SQB->QB_DEPSUP))
					EndIf
				EndIf
			ElseIf !Empty( SQB->QB_DEPSUP ) // Subo nivel do departamento
			SQB->(DbSeek( _cFilSQB + SQB->QB_DEPSUP))
			Else
			Exit
			EndIf
		End
	EndIf
RestArea(aAreaSRA)
	If aArea[01] <> "SQB"
	RestArea(aArea)
	EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ StatsUsr ºAutor ³Jonathan Schmidt Alves º Data ³01/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o status do usuario em relacao carregamento em telaº±±
±±º          ³ nostrando se o usuario tem pendencias ou nao.              º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTpLoad:     Tipo de carregamento                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ lRet         .F.=Sem Pendencias                            º±±
±±º          ³              .T.=Com Pendencias                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function StatsUsr( cTpLoad, cMatFil, cMatFun )
Local lRet := .F.
Local aAreaZS2 := ZS2->(GetArea())
DbSelectArea("ZS2")
ZS2->(DbSetOrder(2)) // ZS2_FILIAL + ZS2_MATFIL + ZS2_MATFUN
	If ZS2->(DbSeek( _cFilZS2 + cMatFil + cMatFun))
		While ZS2->(!EOF()) .And. ZS2->ZS2_FILIAL + ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN == _cFilZS2 + cMatFil + cMatFun
			If ZS2->ZS2_STATRG $ { "A2/A4/", "B1/B3/B4/ D1/", "C1/C3/" } [ Val(cTpLoad) ]
			lRet := .T.
			Exit
			EndIf
		ZS2->(DbSkip())
		End
	EndIf
RestArea(aAreaZS2)
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsMetas ºAutor ³Jonathan Schmidt Alves º Data ³27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento das metas do funcionario (PH1/PH3).           º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cMatFil: Filial do funcionario                             º±±
±±º          ³ cMatFun: Funcionario para carregamento das solicitacoes    º±±
±±º          ³ cAnoFun: Ano do carregamento (opcional)                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsMetas(cMatFil, cMatFun, cAnoFun)
Local _w1 := 1
Local _w2 := 1
Local xDado := Nil
Local aRelacs01 := {}
Local aRelacs02 := {}
Local aRelacs11 := {}
Local cCodUsr := Space(06)
Local lRadChg := .F.
Local aRadLoad := {}
Local _cQuery1 := ""
Default cAnoFun := Space(04)

// cMatFil := "03"
// cMatFun := "000464"

DbSelectArea("SRA")
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
	If SRA->(DbSeek( cMatFil + cMatFun ))
	DbSelectArea("PH1") // Usuarios EAA
	PH1->(DbSetOrder(1)) // PH1_FILIAL + PH1_USER + PH1_SUP
	DbSelectArea("PH3")
	PH3->(DbSetOrder(1)) // PH3_FILIAL + PH3_USERID + PH3_ANO
	//	If !Empty( SRA->RA_XUSRCFG ) // Usuario Protheus
		If PH1->(DbSeek(_cFilPH1 + SRA->RA_XUSRCFG ))
			While PH1->(!EOF()) .And. PH1->PH1_FILIAL + PH1->PH1_USER == _cFilPH1 + SRA->RA_XUSRCFG
				If PH1->PH1_ANO <= Left(DtoS(dDatabase),4) // Ano mais atual conforme dDatabase
					cCodUsr := PH1->PH1_USER
				EndIf
				PH1->(DbSkip())
			End
			
            
			If !Empty( cCodUsr )
				If PH3->(DbSeek(_cFilPH3 + cCodUsr))
					If Empty( cAnoFun ) // Carregar os periodos
						While PH3->(!EOF()) .And. PH3->PH3_FILIAL + PH3->PH3_USERID == _cFilPH3 + cCodUsr
							If Empty(cAnoFun) .And. Year(dDatabase) - Val(PH3->PH3_ANO) <= 3 // No maximo 3 anos atras do EAA
								If Val(PH3->PH3_ANO) < Year( Date() ) // Ano deve ser apenas anos anteriores
									aAdd(aRadLoad, PH3->PH3_ANO) // aAdd(aRadAnos, PH3->PH3_ANO)
								EndIf
							EndIf
							PH3->(DbSkip())
						End
						If Len(aRadLoad) > 0
							PH3->(DbSeek(_cFilPH3 + cCodUsr + aRadLoad[Len(aRadLoad)]))
						Else
							PH3->(DbSkip(-1)) // Volto para o ultimo ano PH3
						EndIf
					Else // Carregar dados do periodo em questao
						PH3->(DbSeek(_cFilPH3 + cCodUsr + cAnoFun))
					EndIf
					If PH3->(!EOF()) .And. (!Empty(cAnoFun) .Or. Len(aRadLoad) > 0)
						If PH3->PH3_FILIAL + PH3->PH3_USERID == _cFilPH3 + cCodUsr

							If oFolEAA:nOption == 11 // Se estava no PPM, recarrego
								For _w1 := Len( aFolEAA ) To 1 Step -1
									If aFolEAA[_w1] == "PPM"
                                        oFolEAA:HidePage(_w1)
									Else
                                        oFolEAA:ShowPage(_w1)
									EndIf
								Next
							EndIf

							aRelacs01 := { { "M1", "cGetMeta01", "NoAcento(xDado)" }, { "T1", "cGetTarg01", "" }, { "MI1", "cGetMini01", "" }, { "MA1", "cGetMaxi01", "" }, { "C1", "lChkCali01", "" }, { "B1PER", "nGetPerc01", "" }, { "OBSP1","cGetObsP01", "" }, { "A1", "cCmbPerA01", "" }, { "OBSA1","cGetAval01", "" }, { "B1", "cCmbPerB01", "" },;
							{ "M2", "cGetMeta02", "NoAcento(xDado)" }, { "T2", "cGetTarg02", "" }, { "MI2", "cGetMini02", "" }, { "MA2", "cGetMaxi02", "" }, { "C2", "lChkCali02", "" }, { "B2PER", "nGetPerc02", "" }, { "OBSP2","cGetObsP02", "" }, { "A2", "cCmbPerA02", "" }, { "OBSA2","cGetAval02", "" }, { "B2", "cCmbPerB02", "" },;
							{ "M3", "cGetMeta03", "NoAcento(xDado)" }, { "T3", "cGetTarg03", "" }, { "MI3", "cGetMini03", "" }, { "MA3", "cGetMaxi03", "" }, { "C3", "lChkCali03", "" }, { "B3PER", "nGetPerc03", "" }, { "OBSP3","cGetObsP03", "" }, { "A3", "cCmbPerA03", "" }, { "OBSA3","cGetAval03", "" }, { "B3", "cCmbPerB03", "" },;
							{ "M4", "cGetMeta04", "NoAcento(xDado)" }, { "T4", "cGetTarg04", "" }, { "MI4", "cGetMini04", "" }, { "MA4", "cGetMaxi04", "" }, { "C4", "lChkCali04", "" }, { "B4PER", "nGetPerc04", "" }, { "OBSP4","cGetObsP04", "" }, { "A4", "cCmbPerA04", "" }, { "OBSA4","cGetAval04", "" }, { "B4", "cCmbPerB04", "" },;
							{ "M5", "cGetMeta05", "NoAcento(xDado)" }, { "T5", "cGetTarg05", "" }, { "MI5", "cGetMini05", "" }, { "MA5", "cGetMaxi05", "" }, { "C5", "lChkCali05", "" }, { "B5PER", "nGetPerc05", "" }, { "OBSP5","cGetObsP05", "" }, { "A5", "cCmbPerA05", "" }, { "OBSA5","cGetAval05", "" }, { "B5", "cCmbPerB05", "" } }
							// Carrego todos os dados das Metas 01 a 05
							For _w1 := 1 To Len(aRelacs01)
								xDado := &("PH3->PH3_" + aRelacs01[ _w1, 01 ])        // Variavel recebe Field
								If !Empty (aRelacs01[ _w1, 03 ]) // Processamento
									&(aRelacs01[ _w1, 03 ])
								EndIf
								&(aRelacs01[ _w1, 02 ]) := xDado
								If Type("oDlg01") == "O"
									&(Stuff( aRelacs01[ _w1, 02 ], 1,1, "o")):Refresh()                 // Refresh no objeto
								EndIf
							Next
							// Carrego todos os dados de Avaliacao Comportamental, Avaliacao Final, Desenv Funcionario, PDI
							aRelacs02 := { { "PC7", "cCmbPClien", "" }, { "PC9", "cCmbPSerDiv", "" }, { "PC11", "cCmbPAgeDo", "" }, { "PC8", "cCmbPDisRu", "" }, { "PC10", "cCmbPApren", "" },;
							{ "AC7", "cCmbAClien", "" }, { "AC9", "cCmbASerDiv", "" }, { "AC11", "cCmbAAgeDo", "" }, { "AC8", "cCmbADisRu", "" }, { "AC10", "cCmbAApren", "" },;
							{ "COME02", "cGetCome02", "" }, { "AVPA", "cCmbAvPart", "" },;
							{ "COME01", "cGetCome01", "" }, { "AVAV", "cCmbAvAval", "" }, { "AVPER", "cGetAvPerc", "" },;
							{ "DESV", "cGetDesenv", "" },;
							{ "PDI03", "cGetProxCa", "" }, { "PDI05", "cGetPontFo", "" }, { "PDI04", "cCmbTransf", "" }, { "PDI06", "cGetPontDe", "" }, { "PDI32", "cGetInfAdi", "" },;
							{ "PDI07", "cGetNoMt01", "" }, { "PDI08", "cGetDsMt01", "" }, { "PDI11", "cCmbCgMt01", "" }, { "PDI09", "dGetInMt01", "" }, { "PDI10", "dGetFiMt01", "" },;
							{ "PDI12", "cGetNoMt02", "" }, { "PDI13", "cGetDsMt02", "" }, { "PDI16", "cCmbCgMt02", "" }, { "PDI14", "dGetInMt02", "" }, { "PDI15", "dGetFiMt02", "" },;
							{ "PDI17", "cGetNoMt03", "" }, { "PDI18", "cGetDsMt03", "" }, { "PDI21", "cCmbCgMt03", "" }, { "PDI19", "dGetInMt03", "" }, { "PDI20", "dGetFiMt03", "" },;
							{ "PDI22", "cGetNoMt04", "" }, { "PDI23", "cGetDsMt04", "" }, { "PDI26", "cCmbCgMt04", "" }, { "PDI24", "dGetInMt04", "" }, { "PDI25", "dGetFiMt04", "" },;
							{ "PDI27", "cGetNoMt05", "" }, { "PDI28", "cGetDsMt05", "" }, { "PDI31", "cCmbCgMt05", "" }, { "PDI29", "dGetInMt05", "" }, { "PDI30", "dGetFiMt05", "" },;
							{ "PD133", "cGetFormAc", "" } }
							// Carrego todos os dados das Metas 01 a 05
							For _w1 := 1 To Len(aRelacs02)
								xDado := &("PH3->PH3_" + aRelacs02[ _w1, 01 ])        // Variavel recebe Field
								If !Empty (aRelacs02[ _w1, 03 ]) // Processamento
									&(aRelacs02[ _w1, 03 ])
								EndIf
								&(aRelacs02[ _w1, 02 ]) := xDado
								If Type("oDlg01") == "O"
									&(Stuff( aRelacs02[ _w1, 02 ], 1,1, "o")):Refresh()                 // Refresh no objeto
								EndIf
							Next

						EndIf
					EndIf
				EndIf
			EndIf

		Else // Se nao tem PH1/PH3, entao vamos olhar o PPM

			For _w1 := Len( aFolEAA ) To 1 Step -1
				If aFolEAA[_w1] <> "PPM"
                    oFolEAA:HidePage(_w1)
				Else
                    oFolEAA:ShowPage(_w1)
				EndIf
			Next

            // If SRA->(DbSeek( "03" + "000464" )) // Teste

			//>> Everson Santana

			_cQuery1 += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_DEPTO,RA_ADMISSA,RA_SALARIO "
    		_cQuery1 += " FROM "+RetSqlName("SRA")+ " SRA "
    		_cQuery1 += " WHERE RA_CIC = '"+SRA->RA_CIC+"' "
    		_cQuery1 += " AND D_E_L_E_T_ = ' ' "

			If Select("QRG") > 0
        		Dbselectarea("QRG")
        		QRG->(DbClosearea())
			EndIf

    		TcQuery _cQuery1 New Alias "QRG"

		    dbSelectArea("QRG")
    		QRG->(dbGoTop())

			While !QRG->(Eof())
					//>>
            		DbSelectArea("PPM")
            		PPM->(DbSetOrder(3)) // PPM_FILIAL + PPM_EMP + PPM_MAT + PPM_ANO
				If PPM->(DbSeek( QRG->RA_FILIAL + cEmpAnt + QRG->RA_MAT ))

					If Empty( cAnoFun ) // Carregar os periodos
                
						While PPM->(!EOF()) .And. PPM->PPM_FILIAL + PPM->PPM_EMP + PPM->PPM_MAT == QRG->RA_FILIAL + cEmpAnt + QRG->RA_MAT
							If Empty( cAnoFun ) .And. Year(dDatabase) - Val(PPM->PPM_ANO) <= 3 // No maximo 3 anos atras do EAA
								If .T. // Val(PPM->PPM_ANO) < Year( Date() ) // Ano deve ser apenas anos anteriores
                                aAdd(aRadLoad, PPM->PPM_ANO)
								EndIf
							EndIf
                        	PPM->(DbSkip())
						End
						If Len(aRadLoad) > 0
                        	PPM->(DbSeek( QRG->RA_FILIAL + cEmpAnt + QRG->RA_MAT + aRadLoad[Len(aRadLoad)]))
						Else
                        	PPM->(DbSkip(-1)) // Volto para o ultimo ano PPM
						EndIf

					Else // Carregar dados do periodo em questao
                    		PPM->(DbSeek( QRG->RA_FILIAL + cEmpAnt + QRG->RA_MAT + cAnoFun))

					EndIf

					If PPM->(!EOF()) .And. (!Empty(cAnoFun) .Or. Len(aRadLoad) > 0)

						If PPM->PPM_FILIAL + PPM->PPM_EMP + PPM->PPM_MAT == QRG->RA_FILIAL + cEmpAnt + QRG->RA_MAT
                        
						/*
                        aRelacs11 := { { "01", "cGetFlds01", "Upper(xDado)" }, { "02", "cGetFlds02", "" }, { "03", "cGetFlds03", "" }, { "04", "cGetFlds04", "" }, { "05", "cGetFlds05", "" },;
                                    { "06", "cGetFlds06", "" }, { "07","cGetFlds07", "" }, { "08", "cGetFlds08", "" }, { "09", "cGetFlds09", "" }, { "10", "cGetFlds10", "" },;
                                    { "11", "cGetFlds11", "" }, { "12","cGetFlds12", "" }, { "13", "cGetFlds13", "" },;
                                    { "CURSO1", "cGetCurso1", "" }, { "CURSO2","cGetCurso2", "" }, { "CURSO3", "cGetCurso3", "" }, { "CURSO4", "cGetCurso4", "" }, { "CURSO5", "cGetCurso5", "" },;
                                    { "NOTA", "cGetNotaFm", "" } }
						*/

							aRelacs11 := {{  "NOTA", "cGetNotaFm", "" } }

							// Carrego todos os dados do PPM
							For _w1 := 1 To Len(aRelacs11)
								xDado := &("PPM->PPM_" + aRelacs11[ _w1, 01 ])        // Variavel recebe Field
								//>> Ticket 20200826006370 - Everson Santana - 26.02.2021
								If xDado == "1"
									xDado := "Alta Performance"
								ElseIf xDado == "2"
									xDado := "Performance"
								ElseIf xDado == "3"
									xDado := "Competente"
								ElseIf xDado == "4"
									xDado := "Baixa Performance"
								else
									xDado := "Sem Nota"
								EndIf
								//<< Ticket 20200826006370

								If !Empty (aRelacs11[ _w1, 03 ]) // Processamento
									&(aRelacs11[ _w1, 03 ])
								EndIf
								&(aRelacs11[ _w1, 02 ]) := xDado
								If Type( Stuff( aRelacs11[ _w1, 02 ], 1,1, "o") ) == "O" // Type("oDlg01") == "O"
									&(Stuff( aRelacs11[ _w1, 02 ], 1,1, "o")):Refresh()                 // Refresh no objeto
								EndIf
							Next
						EndIf
					EndIf
				EndIf
				QRG->(DbSkip())
			End
		EndIf

		// Teste
		If Empty(cAnoFun) .And. Len(aRadLoad) > 0 // Carregamento os Anos Todos
			aSort(aRadLoad,,, {|x,y|, x < y })  // Ordenacao dos anos
			If Len( aRadLoad ) <> Len( oRadAnos:aItems )
				lRadChg := .T.
			Else // Mesmo tamanho
				For _w2 := 1 To Len(aRadLoad)
					If aRadLoad [ _w2 ] <> oRadAnos:aItems [ _w2 ] // Anos diferentes
						lRadChg := .T.
					EndIF
				Next
			EndIf
			If !lRadChg // Nao mudou nada.. so atualizo se mudou o selecionado
				If oRadAnos:nOption <> Len(aRadLoad)
					lRadChg := .T.
				EndIf
			EndIf
			If lRadChg // Alguma diferenca
				oRadAnos:bChange := {|| Nil } // Desativo bChange
				oRadAnos:aItems := aClone(aRadLoad) // Anos de dados
				oRadAnos:nOption := Len(aRadLoad) // Posiciono no ultimo ano
				oRadAnos:Refresh()
				oRadAnos:bChange := {|| LdsMetas(oGetD1:aCols[ oGetD1:nAt, nP01MatFil ], oGetD1:aCols[ oGetD1:nAt, nP01MatFun ], aRadAnos[ oRadAnos:nOption ] )} // Reativo bChange
				aRadAnos := aClone(aRadLoad)
			EndIf
		EndIf
		//EndIf
	EndIf
	If Empty(cAnoFun) // Montagem do aRadAnos
		oRadAnos:lVisible := Len(aRadLoad) > 0
		oRadAnos:Refresh()
	EndIf
	oFolEAA:lVisible := oRadAnos:lVisible
	oFolEAA:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsHisto ºAutor ³Jonathan Schmidt Alves º Data ³02/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento dos historicos de alteracoes salariais.       º±±
±±º          ³ SR3/SR7                                                    º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cMatFil: Filial do funcionario                             º±±
±±º          ³ cMatFun: Funcionario para carregamento dos historicos      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsHisto(cMatFil, cMatFun)
Local aCatFun := {}
Local cDesCat := Space(20)
Local cDesMot := Space(20)
aCls03 := {}
DbSelectArea("SRA") // Funcionarios
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
DbSelectArea("SRJ") // Funcoes
SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
DbSelectArea("SR3") // Rais
SR3->(DbSetOrder(1)) // R3_FILIAL + R3_MAT + DtoS(R3_DATA) + R3_TIPO + R3_PD
DbSelectArea("SR7") // Historico de Alteracoes Salariais
SR7->(DbSetOrder(1)) // R7_FILIAL + R7_MAT + DtoS(R7_DATA) + R7_TIPO
	If SRA->(DbSeek( cMatFil + cMatFun ))
		If SR7->(DbSeek( cMatFil + cMatFun ))
			While SR7->(!EOF()) .And. SR7->R7_FILIAL + SR7->R7_MAT == cMatFil + cMatFun
				If SR3->(DbSeek(SR7->R7_FILIAL + SR7->R7_MAT + DtoS(SR7->R7_DATA) + SR7->R7_TIPO))
				cDesCat := Space(20)
				aCatFun := FwGetSX5("28", SR7->R7_CATFUNC ) // Categoria
					If Len(aCatFun) > 0
					cDesCat := aCatFun[ 01, 04 ]
					EndIf
				cDesMot := Space(20)
				aMotAlt := FwGetSX5("41", SR7->R7_TIPO ) // Motivo alteracao
					If Len(aMotAlt) > 0
					cDesMot := aMotAlt[ 01, 04 ]
					EndIf
				aAdd( aCls03, { SR7->R7_FILIAL, SRA->RA_MAT, SRA->RA_NOME, SR7->R7_DATA, SR7->R7_TIPO, cDesMot, SR7->R7_FUNCAO, SR7->R7_DESCFUN, SR7->R7_CATFUNC, cDesCat, /*SR7->R7_CARGO, SR7->R7_DESCCAR,*/ SR3->R3_DESCPD, SR3->R3_VALOR, .F. })
				EndIf
			SR7->(DbSkip())
			End
		EndIf
	EndIf
	If Len(aCls03) == 0
	aCls01 := u_ClearCls(aHdr03)
	EndIf
	If Type("oGetD1") == "O"
	oGetD3:aCols := aClone(aCls03)
	oGetD3:Refresh()
	EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsSolic ºAutor ³Jonathan Schmidt Alves º Data ³27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de solicitacoes do funcionario que  º±±
±±º          ³ esta posicionado dos departamentos  do gestor.             º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTpLoad: Tipo de carregamento                              º±±
±±º          ³                      Ex: "1"=Gestor                        º±±
±±º          ³                          "2"=Recursos Humanos              º±±
±±º          ³                          "3"=Presidencia                   º±±
±±º          ³                                                            º±±
±±º          ³ cMatFil: Filial do funcionario                             º±±
±±º          ³ cMatFun: Funcionario para carregamento das solicitacoes    º±±
±±º          ³ lChkPenden: Mostra apenas pendencias                       º±±
±±º          ³ lChkAllSol: Mostra todas as solicitacoes                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsSolic(cTpLoad, cMatFil, cMatFun, lChkPenden, lChkAllSol)
Local _w1
Local aDados := {}
Local aMnts := { { "CODSOL", "", "", Nil }, { "DATEMI", "", "", Nil }, { "MATFIL", "", "cNomFil := Iif( (nFind := ASCan(aFilFuncs, {|x|, x[01] + x[02] == cEmpAnt + aTail(aDado) })) > 0, aFilFuncs[ nFind, 03 ], '')", Nil },;
{ "", "cNomFil", "", Nil }, { "MATFUN", "", "", 0 }, { "", "Posicione('SRA',1, Left(aDado[ Len( aDado ) - 1 ],2) + aTail( aDado ), 'RA_NOME')", "", 0 },;
{ "FUNCAO", "", "", Nil }, { "", "Posicione('SRJ',1,_cFilSRJ + aTail(aDado),'RJ_DESC')", Nil, Nil },;
{ "SALARI", "", "", Nil }, { "SALPER", "", "", Nil }, { "SALALT", "", "", Nil }, { "SALATU", "", "", Nil },;
{ "MOTALT", "", "", Nil }, { "", "Iif(!Empty(aTail(aDado)), FwGetSX5('41',aTail(aDado))[01,04], Space(30))", "", Nil },;                // Motivo Alteracao
{ "DESFUN", "", "", Nil },;
{ "DATDES", "", "", Nil }, { "DATEFE", "", "", Nil },;                                                                                  // Data Desejada e Data Efetiva
{ "OBSGES", "", "", Nil }, { "OBSREC", "", "", Nil }, { "OBSPRE", "", "", Nil },;                                                       // Observacoes Gestor, Recursos Humanos e Presidencia
{ "CODCUS", "", "", Nil }, { "", "Posicione('CTT',1,_cFilCTT + aTail(aDado),'CTT_DESC01')", "", Nil }, { "STATRG", "", "", Nil } }

//{ "CODFUN", "", "", Nil }, { "", "Iif(!Empty(aTail(aDado)), Posicione('SRJ',1,_cFilSRJ + aTail(aDado),'RJ_DESC'), '')", "", Nil },;     // Nova Funcao e Descricao da Funcao

Local nLenMnts := Len(aMnts)
Private aDado := {}
DbSelectArea("ZS2") // Solicitacoes
ZS2->(DbSetOrder(2)) // ZS2_FILIAL + ZS2_MATFIL + ZS2_MATFUN
	If ZS2->(DbSeek(_cFilZS2 + cMatFil + cMatFun))
		While ZS2->(!EOF()) .And. ZS2->ZS2_FILIAL + ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN == _cFilZS2 + cMatFil + cMatFun
			If !lChkPenden .Or. ZS2->ZS2_STATRG $ { "A2/A4/", "B1/B3/B4/ D1/", "C1/C3/" } [ Val(cTpLoad) ] // Nao mostrar apenas pendencias ou se mostrar pendencias o registro esta de acordo
			aDado := {}
				For _w1 := 1 To nLenMnts // Rodo nos elementos da montagem
					If !Empty(aMnts[_w1,01]) // Tem campo, evaluate do campo
					aAdd(aDado, &("ZS2->ZS2_" + aMnts[_w1,01]))
					ElseIf !Empty(aMnts[_w1,02]) // Evaluate do 2do elemento
					aAdd(aDado, &(aMnts[_w1,02]))
					Else // Monto conforme aHeader
					aAdd(aDado, u_ClearCls(aHdr02,_w1)[1])
					EndIf
					If !Empty(aMnts[_w1,03]) // Se tem processamento.. faco
					&(aMnts[_w1,03])
					EndIf
				Next
				While _w1 <= Len(aHdr02)
				aAdd(aDado, u_ClearCls(aHdr02,_w1)[1])
				_w1++
				End
			aAdd(aDado, .F.) // Nao apagado
			aAdd(aDados, aClone(aDado)) // Inclusao do elemento
			EndIf
		ZS2->(DbSkip())
		End
	EndIf
oGetD2:oBrowse:lVisible := Len(aDados) > 0
	If Len(aDados) == 0 // Nao tem nada
	aDados := u_ClearCls(aHdr02)
	EndIf
oGetD2:aCols := aClone(aDados)
oGetD2:Refresh()
Return

User Function VlPsqMat(oObj, cGetPsqMat) // Pesquisa por Matricula
Local lRet := .T.
LdsUsers(cCmbPrcUsr, cGetPsqMat, cGetPsqNom)
Return lRet

User Function VlPsqNom(oObj, cGetPsqNom) // Pesquisa por Nome
Local lRet := .T.
LdsUsers(cCmbPrcUsr, cGetPsqMat, cGetPsqNom)
Return lRet

User Function VlSalPer() // Validacao do Perc Salario
Local lRet := .T.
Local nSalario := oGetD2:aCols[ oGetD2:nAt, nP02Salari ]
Local nChkPerAlt := &(ReadVar())
	If cCmbPrcUsr == "1" // "1"=Gestor
		If oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "A1/A2/" // "A1"=-> Incluir Solicitacao (Gestor) ou "A2"=Solicitacao Incluida (Gestor)
		DbSelectArea("SRA")
		SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
			If SRA->(DbSeek( oGetD1:aCols[ oGetD1:nAt, nP01MatFil ] + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ] ))
			oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ] := nSalario * nChkPerAlt / 100                                   // Valor de alteracao
			oGetD2:aCols[ oGetD2:nAt, nP02SalAtu ] := Round(nSalario + oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ],2)    // Calculo do salario atualizado
			// Arredondar para nao deixar centavos (Round com 0)
				If !(SRA->RA_CATFUNC $ "G/H/") // "G"=Estagiario Horista "H"=Horista
				oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ] := oGetD2:aCols[ oGetD2:nAt, nP02SalAtu ] - nSalario                     // Valor da alteracao (recalculado)
				oGetD2:aCols[ oGetD2:nAt, nP02SalPer ] := Round(oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ] / nSalario * 100, 2)     // Percentual Salario (recalculado arredondado 2 decimais)
				&(ReadVar()) := oGetD2:aCols[ oGetD2:nAt, nP02SalPer ]
				EndIf
			oGetD2:Refresh()
			Else // Funcionario nao encontrado (SRA)
			u_AskYesNo(4000,"VlSalAlt","Funcionario nao encontrado no cadastro (SRA)!","Filial/Matricula: " + oGetD1:aCols[ oGetD1:nAt, nP01MatFil ] + "/" + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ],"Verifique os cadastros e tente novamente!","","","UPDERROR")
			lRet := .F.
			EndIf
		Else // So permitida alteracao em "A1"=Solicitacao Incluida (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)
		u_AskYesNo(4000,"VlSalPer","Alteracao de percentual de salario so deve ser realizada em registros","'A1'=-> Incluir Solicitacao (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)","Em outros status o salario desejado nao podera ser alterado!","","","UPDERROR")
		lRet := .F.
		EndIf
	Else // Acesso deve ser "1"=Gestor
	u_AskYesNo(4000,"VlSalAlt","Alteracao de salario so deve ser realizada com acesso","'1'=Gestor","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf
Return lRet

User Function VlSalAlt() // Validacao do Valor Alteracao Salario
Local lRet := .T.
Local nSalario := oGetD2:aCols[ oGetD2:nAt, nP02Salari ]
Local nChkSalAlt := &(ReadVar())
	If cCmbPrcUsr == "1" // "1"=Gestor
		If oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "A1/A2/" // "A1"=-> Incluir Solicitacao (Gestor) ou "A2"=Solicitacao Incluida (Gestor)
		DbSelectArea("SRA")
		SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
			If SRA->(DbSeek( oGetD1:aCols[ oGetD1:nAt, nP01MatFil ] + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ] ))
			oGetD2:aCols[ oGetD2:nAt, nP02SalPer ] := Round(nChkSalAlt / nSalario * 100, 2)                 // Percentual Salario (arredondado)
			oGetD2:aCols[ oGetD2:nAt, nP02SalAtu ] := Round(nSalario + nChkSalAlt,2)                        // Calculo do salario atualizado
			// Arredondar para nao deixar centavos (Round com 0)
				If !(SRA->RA_CATFUNC $ "G/H/") // "G"=Estagiario Horista "H"=Horista
				oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ] := oGetD2:aCols[ oGetD2:nAt, nP02SalAtu ] - nSalario                     // Valor da alteracao (recalculado)
				oGetD2:aCols[ oGetD2:nAt, nP02SalPer ] := Round(oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ] / nSalario * 100, 2)     // Percentual Salario (recalculado arredondado 2 decimais)
				&(ReadVar()) := oGetD2:aCols[ oGetD2:nAt, nP02SalAlt ]
				EndIf
			oGetD2:Refresh()
			Else // Funcionario nao encontrado (SRA)
			u_AskYesNo(4000,"VlSalAlt","Funcionario nao encontrado no cadastro (SRA)!","Filial/Matricula: " + oGetD1:aCols[ oGetD1:nAt, nP01MatFil ] + "/" + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ],"Verifique os cadastros e tente novamente!","","","UPDERROR")
			lRet := .F.
			EndIf
		Else // So permitida alteracao em "A1"=Solicitacao Incluida (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)
		u_AskYesNo(4000,"VlSalAlt","Alteracao de salario so deve ser realizada em registros","'A1'=-> Incluir Solicitacao (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)","Em outros status o salario desejado nao podera ser alterado!","","","UPDERROR")
		lRet := .F.
		EndIf
	Else // Acesso deve ser "1"=Gestor
	u_AskYesNo(4000,"VlSalAlt","Alteracao de salario so deve ser realizada com acesso","'1'=Gestor","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf
Return lRet

User Function VlMotAlt() // Validacao do Motivo Alteracao
Local lRet := .T.
Local cChkMotAlt := &(ReadVar())
	If cCmbPrcUsr == "1" // "1"=Gestor
		If oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "A1/A2/" // "A1"=-> Incluir Solicitacao (Gestor) ou "A2"=Solicitacao Incluida (Gestor)
			If !Empty( cChkMotAlt )
			aSX5 := FwGetSX5("41", cChkMotAlt)
				If Len( aSX5 ) > 0 // Carregado
				oGetD2:aCols[ oGetD2:nAt, nP02DesAlt ] := aSX5[01,04]       // Descricao do Motivo Alteracao
				oGetD2:Refresh()
				Else // Motivo nao encontrado no cadastro (SX5 Tabela 41)
				u_AskYesNo(4000,"VlMotAlt","Motivo de Alteracao nao encontrado no cadastro (SX5: Tabela 41)!","Verifique o codigo preenchido e tente novamente!","","","","UPDERROR")
				lRet := .F.
				EndIf
			Else // Nao preenchida (limpar)
			oGetD2:aCols[ oGetD2:nAt, nP02DesAlt ] := Space(30)
			oGetD2:Refresh()
			EndIf
		Else // So permitida alteracao em "A1"=Solicitacao Incluida (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)
		u_AskYesNo(4000,"VlMotAlt","Alteracao de Motivo de Alteracao so deve ser realizada em registros","'A1'=-> Incluir Solicitacao (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)","Em outros status o motivo nao podera ser alterado!","","","UPDERROR")
		lRet := .F.
		EndIf
	Else // Acesso deve ser "1"=Gestor
	u_AskYesNo(4000,"VlMotAlt","Alteracao de Motivo de Alteracao so deve ser realizada com acesso","'1'=Gestor","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf
Return lRet


User Function VlCodFun() // Validacao do Codigo da Nova Funcao (SRJ)
Local lRet := .T.
Local cChkCodFun := &(ReadVar())
DbSelectArea("SRJ")
SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
	If cCmbPrcUsr == "1" // "1"=Gestor
		If oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "A1/A2/" // "A1"=-> Incluir Solicitacao (Gestor) ou "A2"=Solicitacao Incluida (Gestor)
			If !Empty( cChkCodFun )
			
				If SRJ->(DbSeek( _cFilSRJ + cChkCodFun ))
				oGetD2:aCols[ oGetD2:nAt, nP02DESFUN ] := SRJ->RJ_DESC       // Descricao da Funcao
				oGetD2:Refresh()
				Else // Funcao nao encontrada no cadastro (SRJ)
				u_AskYesNo(4000,"VlCodFun","Funcao nao encontrada no cadastro (SRJ)!","Verifique o codigo preenchido e tente novamente!","","","","UPDERROR")
				lRet := .F.
				EndIf
			
			Else // Nao preenchida (limpar)
			oGetD2:aCols[ oGetD2:nAt, nP02DESFUN ] := Space(20)
			oGetD2:Refresh()
			EndIf
		Else // So permitida alteracao em "A1"=Solicitacao Incluida (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)
		u_AskYesNo(4000,"VlCodFun","Alteracao de Nova Funcao so deve ser realizada em registros","'A1'=-> Incluir Solicitacao (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)","Em outros status a funcao nao podera ser alterada!","","","UPDERROR")
		lRet := .F.
		EndIf
	
	ElseIf cCmbPrcUsr == "2" // "2"=Recursos Humanos
	
		If oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] <> "D3" // "D3"=Alteracao Salarial Processada (Recursos Humanos)
		
			If !Empty( cChkCodFun )
			
				If SRJ->(DbSeek( _cFilSRJ + cChkCodFun ))
				oGetD2:aCols[ oGetD2:nAt, nP02DESFUN ] := SRJ->RJ_DESC       // Descricao da Funcao
				oGetD2:Refresh()
				Else // Funcao nao encontrada no cadastro (SRJ)
				u_AskYesNo(4000,"VlCodFun","Funcao nao encontrada no cadastro (SRJ)!","Verifique o codigo preenchido e tente novamente!","","","","UPDERROR")
				lRet := .F.
				EndIf
			
			Else // Nao preenchida (limpar)
			oGetD2:aCols[ oGetD2:nAt, nP02DESFUN ] := Space(20)
			oGetD2:Refresh()
			EndIf
		
		Else // So permitida alteracao em "D3"=Alteracao Salarial Processada (Recursos Humanos)
		u_AskYesNo(4000,"VlCodFun","Alteracao de Nova Funcao so deve ser realizada em registros","diferentes de 'D3'=Alteracao Salarial Processada (Recursos Humanos)","Em outros status a funcao podera ser alterada!","","","UPDERROR")
		lRet := .F.
		EndIf
	
	Else // Acesso deve ser "1"=Gestor
	u_AskYesNo(4000,"VlCodFun","Alteracao de Motivo de Alteracao so deve ser realizada com acesso","'1'=Gestor","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf

Return lRet

User Function VlDatDes() // Validacao da Data Desejada
Local lRet := .T.
Local dChkDatDes := &(ReadVar())
	If cCmbPrcUsr == "1" // "1"=Gestor
		If !(oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "A1/A2/") // "A1"=-> Incluir Solicitacao (Gestor) ou "A2"=Solicitacao Incluida (Gestor)
		u_AskYesNo(4000,"VlDatDes","Alteracao da Data Desejada so deve ser realizada em registros","'A1'=-> Incluir Solicitacao (Gestor) ou 'A2'=Solicitacao Incluida (Gestor)","Em outros status a data nao podera ser alterada!","","","UPDERROR")
		lRet := .F.
		ElseIf dChkDatDes < Date() // Data Desejada invalida
		u_AskYesNo(4000,"VlDatDes","Data Desejada nao pode ser menor que hoje!","Verifique a data digitada e tente novamente!","Data: " + DtoC(dChkDatDes),"","","UPDERROR")
		lRet := .F.
		EndIf
	Else // Acesso deve ser "1"=Gestor
	u_AskYesNo(4000,"VlDatDes","Alteracao da Data Desejada so deve ser realizada com acesso","'1'=Gestor","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf
Return lRet

User Function VlDatEfe() // Validacao da Data Efetiva
Local lRet := .T.
Local dChkDatEfe := &(ReadVar())
	If cCmbPrcUsr == "2" // "2"=Recursos Humanos
		If !(oGetD2:aCols[ oGetD2:nAt, nP02StatRg ] $ "B3/D1/") // B3=Solicitacao em Analise (Recursos Humanos) ou D1=Solicitacao Aprovaca (Presidencia)
		u_AskYesNo(4000,"VlDatEfe","Alteracao da Data Efetiva so deve ser realizada em registros","'B3'=Solicitacao em Analise (Recursos Humanos) ou 'D1'=Solicitacao Aprovaca (Presidencia)","Em outros status a data nao podera ser alterada!","","","UPDERROR")
		lRet := .F.
		ElseIf dChkDatEfe < Date() // Data Efetiva invalida
		u_AskYesNo(4000,"VlDatEfe","Data Efetiva nao pode ser menor que hoje!","Verifique a data digitada e tente novamente!","Data: " + DtoC(dChkDatEfe),"","","UPDERROR")
		lRet := .F.
		EndIf
	Else // Acesso deve ser "2"=Recursos Humanos
	u_AskYesNo(4000,"VlDatDes","Alteracao da Data Desejada so deve ser realizada com acesso ","'2'=Recursos Humanos","Verifique o acesso selecionado e tente novamente!","","","UPDERROR")
	lRet := .F.
	EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ StatsChg ºAutor ³Jonathan Schmidt Alves ºData ³ 27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamentos de Status e processos relacionados.            º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ cObj: Objeto para tratamento do controle de status.        º±±
±±º          ³       M1: Projetos Master                                  º±±
±±º          ³       M2: Projetos Micro Sintetico                         º±±
±±º          ³       K1: Projetos Micro Analitico                         º±±
±±º          ³       K2: Contas Contabeis                                 º±±
±±º          ³       K3: Transferencias                                   º±±
±±º          ³ cAcesso: Acesso do usuario conforme objeto oCmbPrcUsr.     º±±
±±º          ³          0=Visualizacao (nao permite alterar status)       º±±
±±º          ³          1=Elaboracao                                      º±±
±±º          ³          2=Coordenacao                                     º±±
±±º          ³          3=Financeiro                                      º±±
±±º          ³          4=Diretoria                                       º±±
±±º          ³ cGetNam: Apenas obtencao do nome do status para mensagens. º±±
±±º          ³ cGetCor: Apenas obtencao da cor do status para getdados.   º±±
±±º          ³ cGetSts: Apenas obtencao dos status para montagem msnewget.º±±
±±º          ³ cGetSvr: Retornar o status para gravacao em base de dados. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function StatsChg( cObj, cAcesso, cGetNam, cGetCor, cGetSts, cGetSvr ) // F8: Muda status da solicitacao
Local _w2
Local _w3
Local xRet := Nil
Local oObj := Nil
Local nLine := 0
Local nFind := 0
Local nFind2 := 0
Local nPStatus := 0
Local cStatAtu := ""
Local cStatChk := ""
Local cJumpOpt := ""
Local cJumpBut := ""
Local aStats := {} // Status
Local aValid := {} // Validacao adicional mudanca de status
Local nAcesso := 0
Default cAcesso := "1" // 1=Visualizacao 2=Coordenacao 3=Financeiro 4=Diretoria
Default cGetNam := "" // Apresentacao do nome do status
Default cGetSts := "" // Apresentacao dos options dos status no newgetdados
	If (nPosC := ASCan({ "oGetD1", "oGetD2" }, {|x|, x == cObj })) > 0 // Acho o Objeto
		If nPosC == 1 // 1=Usuarios
		//           {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
		aAdd(aStats, {    "P0", "Sem pendencias"                                                              ,  nClrCP0, "Cinza Padrao",       "", {      "",            "",             "" } })
		aAdd(aStats, {    "P1", "Pendencias"                                                                  ,  nClrCP1, "Verde Claro",        "", {      "",            "",             "" } })
		ElseIf nPosC == 2 // 2=Solicitacoes
		// Gestor    {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
		aAdd(aStats, {    "A1", "-> Incluir Solicitacao (Gestor)"                                             ,  nClrCA1, "Cinza Padrao",     "A2", {      "",            "",             "" } })
		aAdd(aStats, {    "A2", "Solicitacao incluida (Gestor)"                                               ,  nClrCA2, "Verde Claro",      "A2", {    "A3",            "",             "" } })
		aAdd(aStats, {    "A3", "-> Enviar Solicitacao para Analise (Gestor -> Recursos Humanos)"             ,  nClrCA3, "Verde Escuro", /*"B1"*/"B3", {    "A6",            "",             "" } })
		aAdd(aStats, {    "A4", "Solicitacao Reprovada (Recursos Humanos/Presidencia)"                        ,  nClrCA4, "Vermelho	Claro",   "A4", {    "A5",            "",             "" } })
		aAdd(aStats, {    "A5", "-> Reavaliar Solicitacao Reprovada (Gestor)"                                 ,  nClrCA5, "Vermelho Claro",   "A2", {    "A4",            "",             "" } })
		aAdd(aStats, {    "A6", "-> Abandonar Solicitacao (Gestor)"                                           ,  nClrCA6, "Roxo	Claro",       "A9", {    "A2",            "",             "" } })
		aAdd(aStats, {    "A7", "-> Retornar Solicitacao (Recursos Humanos -> Gestor)"                        ,  nClrCA7, "Laranja Claro",    "A2", {    "B1",            "",             "" } })
		aAdd(aStats, {    "A8", "-> Retornar Solicitacao Abandonada (Gestor)"                                 ,  nClrCA8, "Laranja Claro",    "A2", {    "A9",            "",             "" } })
		aAdd(aStats, {    "A9", "Solicitacao Abandonada (Gestor)"                                             ,  nClrCA9, "Roxo Claro",       "A9", {    "A8",            "",             "" } })
		// RecsHuman {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
		aAdd(aStats, {    "B1", "Solicitacao Aguardando Analise (Recursos Humanos)"                           ,  nClrCB1, "Amarelo Claro", /*"B1"*/ "B3", {    "A7",          "B2",             "" } })
		aAdd(aStats, {    "B2", "-> Analisar Solicitacao (Recursos Humanos)"                                  ,  nClrCB2, "Amarelo Escuro",   "B3", {      "",          "B1",             "" } })
		aAdd(aStats, {    "B3", "Solicitacao em Analise (Recursos Humanos)"                                   ,  nClrCB3, "Azul Esverd Claro","B3", {      "",          "B6",             "" } })
		aAdd(aStats, {    "B4", "Solicitacao Reprovada (Presidencia)"                                         ,  nClrCB4, "Vermelho Escuro",  "B4", {      "",          "B5",             "" } })
		aAdd(aStats, {    "B5", "-> Reprovar Solicitacao (Recursos Humanos/Presidencia -> Gestor)"            ,  nClrCB5, "Vermelho Claro",   "A4", {      "",          "B9",             "" } })
		aAdd(aStats, {    "B6", "-> Aprovar Solicitacao (Recursos Humanos -> Presidencia)"                    ,  nClrCB6, "Azul Claro", /*"C1"*/ "C3", {      "",          "B8",             "" } })
		aAdd(aStats, {    "B7", "-> Retornar Solicitacao (Presidencia -> Recursos Humanos)"                   ,  nClrCB7, "Laranja Claro",    "B3", {      "",          "C1",             "" } })
		aAdd(aStats, {    "B8", "-> Reprovar Solicitacao (Recursos Humanos -> Gestor)"                        ,  nClrCB8, "Vermelho	Claro",   "A4", {      "",          "B3",             "" } })
		aAdd(aStats, {    "B9", "-> Reanalisar Solicitacao (Recursos Humanos)"                                ,  nClrCB9, "Laranja Claro",    "B3", {      "",          "B4",             "" } })
		// Presidenc {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
		aAdd(aStats, {    "C1", "Solicitacao Aguardando Analise (Presidencia)"                                ,  nClrCC1, "Azul Claro", /*"C1"*/"C3", {      "",          "B7",           "C2" } })
		aAdd(aStats, {    "C2", "-> Analisar Solicitacao (Presidencia)"                                       ,  nClrCC2, "Azul Mais Escuro", "C3", {      "",            "",           "C1" } })
		aAdd(aStats, {    "C3", "Solicitacao em Analise (Presidencia)"                                        ,  nClrCC3, "Cinza Amarelado",  "C3", {      "",            "",           "C5" } })
		aAdd(aStats, {    "C4", "-> Reprovar Solicitacao (Presidencia)"                                       ,  nClrCC4, "Cinza Averm Claro","B4", {      "",            "",           "C3" } })
		aAdd(aStats, {    "C5", "-> Aprovar Solicitacao (Presidencia -> Recursos Humanos)"                    ,  nClrCC5, "Cinza Esver Claro","D1", {      "",            "",           "C4" } })
		aAdd(aStats, {    "C9", "-> Reanalisar Solicitacao (Presidencia)"                                     ,  nClrCC9, "Laranja Claro",    "C3", {      "",            "",           "D1" } })
		// RecsHuman {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
		aAdd(aStats, {    "D1", "Solicitacao Aprovada (Presidencia)"                                          ,  nClrCD1, "Verde Claro",      "D1", {      "",          "D2",           "C9" } })
		aAdd(aStats, {    "D2", "-> Processar Alteracao Salarial (Recursos Humanos)"                          ,  nClrCD2, "Roxo Claro",       "D3", {      "",          "D1",             "" } })
		aAdd(aStats, {    "D3", "Alteracao Salarial Processada (Recursos Humanos)"                            ,  nClrCD3, "Azul Claro",       "D3", {      "",            "",             "" } })
		// Envio para Analise do Depto Recursos Humanos
		aAdd(aValid, { "A2", "A3", "!Empty(oGetD2:aCols[ oGetD2:nAt, nP02MotAlt ])",                                                "Motivo da alteracao salarial nao preenchido!"                              }) // Validacao de change
		aAdd(aValid, { "A2", "A3", "oGetD2:aCols[ oGetD2:nAt, nP02SalAtu ] <> oGetD2:aCols[ oGetD2:nAt, nP02Salari ]",              "Salario nao teve atualizacao!"                                             }) // Validacao de change
		// Reprovacao do Depto Recursos Humanos
		aAdd(aValid, { "B6", "B8", "!Empty(oGetD2:aCols[ oGetD2:nAt, nP02ObsRec ])",                                                "Observacoes do departamento de Recursos Humanos deve estar preenchida!"    }) // Validacao de change
		aAdd(aValid, { "D1", "D2", "!Empty(oGetD2:aCols[ oGetD2:nAt, nP02DatEfe ])",                                                "Data da efetivacao da alteracao deve estar preenchida!"                    }) // Validacao de change
		EndIf
		If !Empty(cGetNam) // So obtencao do nome do Status
		xRet := ""
			If (nPosS := ASCan(aStats, {|x|, x[01] == cGetNam })) > 0 // Localizando Status
			xRet := aStats[nPosS,02] // Nome do Status
			EndIf
		ElseIf !Empty(cGetCor) // So carregamento de cores
		xRet := 0
			If (nPosS := ASCan(aStats, {|x|, x[01] == cGetCor })) > 0 // Localizando Status
			xRet := aStats[nPosS,03] // Cor do Status
			EndIf
		ElseIf !Empty(cGetSts) // So montagem dos Status (cBox do MsNewGetDados)
		xRet := ""
			For _w2 := 1 To Len(aStats)
				If Empty(cGetSts) .Or. aStats[_w2,01] $ cGetSts // Status contido.. faco a montagem
				xRet += aStats[_w2,01] + "=" + aStats[_w2,01] + ":" + aStats[_w2,02] + ";"
				EndIf
			Next
		Else // Tratamento de mudanca de status
		oObj := &( cObj )                                                       // Objeto
		nLine := oObj:nAt														// Linha posicionada
		nPStatus := &("nP0" + Right(cObj,1) + "StatRg")                         // Posicao da coluna de status
			If Empty(cGetSvr)
			cStatAtu := oObj:aCols[ nLine, nPStatus ]	// Status Atual do registro
			Else // Se for uma obtencao do Status Salvando
			cStatAtu := cGetSvr							// Status Salvando
			EndIf
			If nLine <= Len(oObj:aCols)
				If (nPosS := ASCan(aStats, {|x|, x[01] == cStatAtu })) > 0	// Localizando Status Atual do registro
					If !Empty(cGetSvr) // Obtencao do Status para salvar
					xRet := aStats[nPosS,05]
					Else // Alteracao de Status mesmo (em tela)
					nAcesso := Val(cAcesso)
						If nAcesso > 0 .And. nAcesso <= Len(aStats[ nPosS, 06]) // Acesso conforme o 6to elemento { Gestor, Recursos Humanos, Presidencia }
						cNewStat := aStats[nPosS, 06, nAcesso]		// Esquema de Status Novo
							If !Empty(cNewStat) // Status novo carregado com sucesso
							lLibAlts := .T. // .T.=Alteracoes liberadas .F.=Alteracoes nao liberadas
							cHldStat := oObj:aCols [ nLine, nPStatus ]		// Hold do status
							cStatChk := cHldStat
							_w3 := 1
								While _w3 <= Len(aValid)
									If aValid[_w3,01] == cStatChk .And. aValid[_w3,02] == cNewStat // Alteracao conforme
										If !(&(aValid[_w3,03])) // Evaluate da validacao esta .F.=Invalido
											If (nFind := ASCan(aStats, {|x|, x[01] == cNewStat })) > 0 // Tento a proxima opcao
												If "->" $ aStats[nFind,02] // Se eh ainda status "de transicao"... vou verificando os proximos de transicao se algum permite
													If (nFind2 := ASCan(aStats, {|x|, x[ 01 ] == aStats[ nFind, 06, nAcesso ] })) > 0
													cJumpOpt := ""
													cJumpBut := ""
														If aStats[ nFind2, 01 ] <> cHldStat // Se a opcao eh diferente da atual
														cJumpOpt := "Deseja avaliar a opcao " + aStats[ nFind2, 02 ] + "?"
														cJumpBut := "Sim"
														EndIf
														If !u_AskYesNo(6000,"StatsChg","Alteracao de Status nao permitida!", aValid[_w3,04] + " Status: " + cStatChk + " -> " + cNewStat, cJumpOpt, "", cJumpBut,"UPDERROR")
														cStatChk := cNewStat
														cNewStat := aStats[ nFind, 06, nAcesso ] // Proxima transicao
														_w3 := 1
														Loop
														EndIf
													EndIf
												EndIf
											EndIf
										lLibAlts := .F.
										Exit
										EndIf
									EndIf
								_w3++
								End
								If lLibAlts // Alteracao liberada
								oObj:aCols [ nLine, nPStatus ] := cNewStat		// Status Novo
								oObj:Refresh()
								Else // Nao identificada alteracao possivel
								oObj:aCols [ nLine, nPStatus ] := cHldStat		// Status retorno o do Hold
								oObj:Refresh()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return xRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GeraSoli ºAutor ³Jonathan Schmidt Alves ºData ³ 27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Solicitacoes em tela.                           º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTpLoad: Tipo de carregamento                              º±±
±±º          ³                      Ex: "1"=Gestor                        º±±
±±º          ³                          "2"=Recursos Humanos              º±±
±±º          ³                          "3"=Presidencia                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraSoli( cTpLoad ) // F10: Geracao de Solicitacoes Salary Review
Local lRet := .T.
Local nLinD1 := oGetD1:nAt
// Montagem da Solicitacao
Local cCodSol := GetSXENum("ZS2","ZS2_CODSOL")          // Solicitacao Salary Review
Local dDatEmi := Date()                                 // Data de Emissao
Local cCodFil := oGetD1:aCols[ nLinD1, nP01MatFil ]     // Filial do Funcionario
Local cNomFil := Space(20)                              // Nome Filial do Funcionario
Local cMatFun := oGetD1:aCols[ nLinD1, nP01MatFun ]     // Matricula do Funcionario
Local cNomFun := oGetD1:aCols[ nLinD1, nP01NomFun ]     // Nome do Funcionario
Local cCodDep := oGetD1:aCols[ nLinD1, nP01CodDep ]     // Codigo Departamento
Local cNomDep := oGetD1:aCols[ nLinD1, nP01NomDep ]     // Nome do Departamento
Local nSalari := oGetD1:aCols[ nLinD1, nP01Salari ]     // Salario Atual
Local nSalPer := 0.00                                   // Alter %
Local nSalAlt := 0.00                                   // Alter Valor
Local nSalAtu := oGetD1:aCols[ nLinD1, nP01Salari ]     // Salario Atualiz
Local cMotAlt := Space(06)                              // Motivo Alt
Local cDesAlt := Space(30)                              // Descricao Motivo da Alteracao

Local cCodFun := Space(05)                              // Codigo da Nova Funcao
Local cDESFUN := Space(20)                              // Descricao da Nova Funcao
//>>Everson Santana - 20200826006370 - 17.02.2020
Local cFuncao := Space(05)                              // Codigo da Funcao Atual
Local cDesAtu := Space(20)                              // Descricao da Funcao Atual
//<<
Local dDatDes := CtoD("")                               // Data Desejada
Local dDatEfe := CtoD("")                               // Data Efetivacao
Local cObsGes := ""                                     // Observacao Gestor
Local cObsRec := ""                                     // Observacao Recursos Humanos
Local cObsPre := ""                                     // Observacao Presidencia
Local cCodCus := Space(09)                              // Centro de Custo
Local cDesCus := Space(30)                              // Descricao Centro de Custo
Local cStatRg := "A1"                                   // Status da Solicitacao
	If cTpLoad == "1" // "1"=Gestor (apenas gestor pode incluir solicitacoes)
	// Solicitacao em Andamento: Status diferente de A9/D3
		If (nFind := ASCan( oGetD2:aCols, {|x|, x[ nP02StatRg ] $ "A1" })) == 0 // So permite incluir se nao tem nenhum ainda em processo de inclusao (em tela)
		DbSelectArea("ZS2") // Solicitacoes
		ZS2->(DbSetOrder(2)) // ZS2_FILIAL + ZS2_MATFIL + ZS2_MATFUN
			If ZS2->(DbSeek(_cFilZS2 + oGetD1:aCols[ nLinD1, nP01MatFil ] + oGetD1:aCols[ nLinD1, nP01MatFun ]))
				While ZS2->(!EOF()) .And. ZS2->ZS2_FILIAL + ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN == _cFilZS2 + oGetD1:aCols[ nLinD1, nP01MatFil ] + oGetD1:aCols[ nLinD1, nP01MatFun ]
					If !(ZS2->ZS2_STATRG $ "A9/D3/") // Se nao for "A9"=Solicitacao Abandonada (Gestor) ou "D3"=Alteracao Salarial Processada (Recursos Humanos)
					u_AskYesNo(4000,"GeraSoli","Inclusao nao pode ser realizada pois funcionario ja possui processo em andamento!","Verifique status de solicitacao do funcionario e tente novamente!","Solicitacao: " + ZS2->ZS2_CODSOL,"Status: " + ZS2->ZS2_STATRG,"","UPDERROR")
					lRet := .F.
					Exit
					EndIf
				ZS2->(DbSkip())
				End
			EndIf
			If lRet // Valido para processamento
				If (nFind := ASCan(aFilFuncs, {|x|, x[01] + x[02] == cEmpAnt + oGetD1:aCols[ nLinD1, nP01MatFil ] })) > 0  // Empresa + Filial do Funcionario (SRA)
				cNomFil := aFilFuncs[nFind,03] // Nome da Filial
				DbSelectArea("SRA")
				SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
					If SRA->(DbSeek( cCodFil + cMatFun ))
					//>> Everson Santana - 20200826006370 - 17.02.2021
					cFuncao := SRA->RA_CODFUNC
						If !Empty( cFuncao ) // Função Atual
						DbSelectArea("SRJ")
						SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
							If SRJ->(DbSeek(_cFilSRJ + cFuncao))
							cDesAtu := SRJ->RJ_DESC
							EndIf
						EndIf
					//<<
						If !Empty( cCodDep ) // Departamento
						DbSelectArea("SQB")
						SQB->(DbSetOrder(1)) // QB_FILIAL + QB_DEPTO
							If SQB->(DbSeek(_cFilSQB + cCodDep))
							cNomDep := SQB->QB_DESCRIC
								If !Empty( SQB->QB_CC )
								DbSelectArea("CTT")
								CTT->(DbSetOrder(1)) // CTT_FILIAL + CTT_CUSTO
									If CTT->(DbSeek(_cFilCTT + SQB->QB_CC))
									cCodCus := CTT->CTT_CUSTO
									cDesCus := CTT->CTT_DESC01
									EndIf
								EndIf
							EndIf
						EndIf
						While Len(oGetD2:aCols) > 0 .And. Empty(oGetD2:aCols[ 01, nP02CodSol ])
						aDel(oGetD2:aCols,01)                       // Removo elemento vazio
						aSize(oGetD2:aCols, Len(oGetD2:aCols) - 1)  // Reduzo tamanho da matriz
						End
					// Inclusao da solicitacao em tela
					//                 {      01,      02,      03,      04,      05,      06,      07,      08,      09,      10,      11,      12,      13,      14,      15,      16,      17,      18,      19,      20,      21,      22,      23, .F. }
					aAdd(oGetD2:aCols, { cCodSol, dDatEmi, cCodFil, cNomFil, cMatFun, cNomFun, cFuncao, cDesAtu, nSalari, nSalPer, nSalAlt, nSalAtu, cMotAlt, cDesAlt,  cDESFUN, dDatDes, dDatEfe, cObsGes, cObsRec, cObsPre, cCodCus, cDesCus, cStatRg, .F. })
					
					//                 {      01,      02,      03,      04,      05,      06,      07,      08,      09,      10,      11,      12,      13,      14,      15,      16,      17,      18,      19,      20,      21,      22,      23,      24, .F. }
					// aAdd(oGetD2:aCols, { cCodSol, dDatEmi, cCodFil, cNomFil, cMatFun, cNomFun, cFuncao, cDesAtu, nSalari, nSalPer, nSalAlt, nSalAtu, cMotAlt, cDesAlt, cCodFun, cDESFUN, dDatDes, dDatEfe, cObsGes, cObsRec, cObsPre, cCodCus, cDesCus, cStatRg, .F. })
					oGetD2:oBrowse:lVisible := .T.
					oGetD2:Refresh()
					EndIf
				EndIf
			EndIf
		Else // Ja possui solicitacao em tela
		u_AskYesNo(4000,"GeraSoli","Inclusao nao pode ser realizada pois funcionario ja possui processo em andamento!","Verifique status de solicitacao do funcionario e tente novamente!","Solicitacao: " + oGetD2:aCols[ nFind, nP02CodSol ],"Status: A1","","UPDERROR")
		lRet := .F.
		EndIf
	EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GravSoli ºAutor ³Jonathan Schmidt Alves ºData ³ 27/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Solicitacoes em tela.                           º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cObj: Objeto de gravacao                                   º±±
±±º          ³                      Ex: "oGetD2"                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GravSoli( cTpLoad, cObj ) // Salvar solicitacoes GetD2
Local _w1
Local lRet := .T.
// Variavel situacao atual solicitacao
Local cHldStat := Space(02)
// Variaveis envio e-mail
Local cMail := ""
Local cMails := ""
Local cCopia := ""
Local cAssunto := ""
Local cMsg := ""
Local aRelat := {}
Local aCodUsr := {}
Local nFind := 0
Local cFuncSent := "GravSoli"

// Objeto
Local oObj := &( cObj )                                 // Objeto Obj
Local nPStatRg := &("nP0" + Right(cObj,1) + "StatRg")   // Posicao coluna status
	For _w1 := 1 To Len(oObj:aCols)
		If oObj:aCols[_w1, nPStatRg] == "A1" // "A1"=Em Criacao
		RecLock("ZS2",.T.)
		ZS2->ZS2_FILIAL := _cFilZS2
		ZS2->ZS2_CODSOL := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodSol") ]		// Solicitacao
		ZS2->ZS2_DATEMI := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatEmi") ]       // Data de Emissao
		ZS2->ZS2_MATFIL := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MatFil") ]       // Filial da Matricula
		ZS2->ZS2_MATFUN := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MatFun") ]       // Matricula do Funcionario
		//ZS2->ZS2_CODDEP := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodDep") ]       // Departamento
		//>>
		ZS2->ZS2_FUNCAO := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "FUNCAO") ]       // Codigo da Funcao Atual
		//<<
		// Campos de Salario
		ZS2->ZS2_SALARI := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "Salari") ]       // Salario Atual
		ZS2->ZS2_SALPER := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalPer") ]       // Percentual Alteracao
		ZS2->ZS2_SALALT := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalAlt") ]       // Alteracao Salario
		ZS2->ZS2_SALATU := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalAtu") ]       // Salario Atualizado
		// Motivo Alteracao e Observacoes
		ZS2->ZS2_MOTALT := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MotAlt") ]       // Motivo Alteracao
		
		// ZS2->ZS2_CODFUN := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodFun") ]       // Codigo da Nova Funcao
		ZS2->ZS2_DESFUN := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DESFUN") ]       // Descrição da Nova Função
		
		ZS2->ZS2_OBSGES := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsGes") ]       // Observacao Gestor
		ZS2->ZS2_OBSREC := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsRec") ]       // Observacao Recursos Humanos
		ZS2->ZS2_OBSPRE := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsPre") ]       // Observacao Presidencia
		// Data Desejada e Efetiva
		ZS2->ZS2_DATDES := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatDes") ]       // Data Desejada
		ZS2->ZS2_DATEFE := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatEfe") ]       // Data Efetiva
		// Centro de Custo
		ZS2->ZS2_CODCUS := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodCus") ]       // Centro de Custo
		ZS2->ZS2_STATRG := StatsChg(cObj,     Nil,     Nil,     Nil,     Nil,    oObj:aCols[ _w1, nPStatRg ])
		ZS2->(MsUnlock())
		ConfirmSX8()
		oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "StatRg") ] := ZS2->ZS2_STATRG 		// Atualizacao do GetDados
		oObj:Refresh()
		Else // Outros Status
			If oObj:aCols[_w1, nPStatRg] == "D2" // -> Processar Alteracao Salarial (Recursos Humanos)
			SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
				If SRA->(DbSeek( oGetD1:aCols[ oGetD1:nAt, nP01MatFil ] + oGetD1:aCols[ oGetD1:nAt, nP01MatFun ]))
				nVlrSalari := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalAtu") ]    // Salario Atualizado
				dDatAltSal := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatEfe") ]    // Data Efetivacao Salario
				
				cTipAltSal := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MotAlt") ]    // Motivo Alteracao
				
				cFilPos    := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MatFil") ]   // Filial Posicionada
				cMatPos    := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MatFun") ]    // Matricula Posicionada
				
				lRet := .T. //GP010AUT( nVlrSalari, dDatAltSal, cTipAltSal, cFilPos, cMatPos)
				
				EndIf
			EndIf
			If lRet // .T.=Prosseguir
			DbSelectArea("ZS2")
			ZS2->(DbSetOrder(1)) // ZS2_FILIAL + ZS2_CODSOL
				If ZS2->(DbSeek( _cFilZS2 + oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodSol") ] ))		// Solicitacao
				
				cHldStat := ZS2->ZS2_STATRG // Situacao anterior da Solicitacao
				
				RecLock("ZS2",.F.)
				// Campos de Salario
				ZS2->ZS2_SALPER := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalPer") ]       // Percentual Alteracao
				ZS2->ZS2_SALALT := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalAlt") ]       // Alteracao Salario
				ZS2->ZS2_SALATU := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "SalAtu") ]       // Salario Atualizado
				// Motivo Alteracao e Observacoes
				ZS2->ZS2_MOTALT := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "MotAlt") ]       // Motivo Alteracao
				
				//ZS2->ZS2_CODFUN := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodFun") ]       // Codigo da Nova Funcao
				ZS2->ZS2_DESFUN := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DESFUN") ]       // Descrição da Nova Função
				
				ZS2->ZS2_OBSGES := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsGes") ]       // Observacao Gestor
				ZS2->ZS2_OBSREC := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsRec") ]       // Observacao Recursos Humanos
				ZS2->ZS2_OBSPRE := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "ObsPre") ]       // Observacao Presidencia
				// Data Desejada e Efetiva
				ZS2->ZS2_DATDES := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatDes") ]       // Data Desejada
				ZS2->ZS2_DATEFE := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "DatEfe") ]       // Data Efetiva
				// Centro de Custo
				ZS2->ZS2_CODCUS := oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "CodCus") ]       // Centro de Custo
				ZS2->ZS2_STATRG := StatsChg(cObj,     Nil,     Nil,     Nil,     Nil,    oObj:aCols[ _w1, nPStatRg ])
				ZS2->(MsUnlock())
				oObj:aCols[ _w1, &("nP0" + Right(cObj,1) + "StatRg") ] := ZS2->ZS2_STATRG 		// Atualizacao do GetDados
				oObj:Refresh()
				EndIf
			EndIf
		EndIf
	// Atualizacao do Status do Usuario conforme as solicitacoes pendentes/nao pendentes
	cStatUsr := Iif( StatsUsr( cTpLoad, SRA->RA_FILIAL, SRA->RA_MAT ), "P1", "P0")
	oGetD1:aCols[ oGetD1:nAt, nP01StatRg ] := cStatUsr
	oObj:Refresh()
	
	// Envio de e-mails
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
		If SRA->(DbSeek( ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN )) // Posiciono no Funcionario
		DbSelectArea("SQB") // Departamentos
		SQB->(DbSetOrder(1)) // QB_FILIAL + QB_DEPTO
			If SQB->(DbSeek(_cFilSQB + oGetD1:aCols[ oGetD1:nAt, nP01CodDep ] )) // Departamento do funcionario posicionado
				If u_GereDept( SQB->QB_DEPTO ) // Funcionario responsavel pelo departamento (Gestor) (aqui o SQB eh reposicionado conforme Depto do Gestor (Gerente))
				
					If SRA->(DbSeek( SQB->QB_FILRESP + SQB->QB_MATRESP )) // Reposiciono SRA no Gestor do Depto (Gerente)
					
					//        { {         Nivel 1 Gestor     }, {    Nivel 2 Rec Humanos   }, {  Nivel 3 Presidencia } }
					aRelat := { {     "A4/", SRA->RA_XUSRCFG }, { "B1/B3/B4/ D1/", cUsrRec }, {    "C1/C3/", cUsrPre } }
						If (nFind := ASCan(aRelat, {|x|, ZS2->ZS2_STATRG $ x[01] })) > 0 // Nivel identificado
						aCodUsr := StrToKarr( aRelat[ nFind, 02 ], "/" )
						cMails := ""
							For _w1 := 1 To Len( aCodUsr )
							cMail := UsrRetMail( aCodUsr[ _w1 ] )
								If !Empty( cMail )
								cMails += Iif(!Empty(cMails),";","") + AllTrim(Lower(cMail))
								EndIf
							Next
						
						cAssunto := "Salary Review - Gerente: " + RTrim(SRA->RA_NOME) // Nome do Gestor
						//cCopia := "everson.santana@steck.com.br"
						
						cMsg := ""
						cMsg += '<html>'
						cMsg += '<head>'
						cMsg += '<title>' + cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
						cMsg += '</head>'
						cMsg += '<body>'
						cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
						cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=80%>'
						cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Definicao do texto/detalhe do email                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Solicitacao: ' + ZS2->ZS2_CODSOL + ' </Font></B></TD>'
						cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Funcionario: ' + ZS2->ZS2_MATFUN + " " + RTrim(oObj:aCols[ oObj:nAt, &("nP0" + Right(cObj,1) + "NomFun") ]) + ' </Font></B></TD>'
						cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Status: Sua solicitação está em análise do RH </Font></B></TD>'
						//cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> TESTE:'+Alltrim(cMails)+'  </Font></B></TD>'
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Definicao do rodape do email                                                ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cMsg += '</Table>'
						cMsg += '<P>'
						cMsg += '<Table align="center">'
						cMsg += '<tr>'
						cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
						cMsg += '</tr>'
						cMsg += '</Table>'
						cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
						cMsg += '</body>'
						cMsg += '</html>'
						
						//                        cMsg := "Solicitacao: " + ZS2->ZS2_CODSOL + Chr(13) + Chr(10)
						//                        cMsg += "Funcionario: " + ZS2->ZS2_MATFUN + " " + RTrim(oObj:aCols[ oObj:nAt, &("nP0" + Right(cObj,1) + "NomFun") ]) + Chr(13) + Chr(10)
						
						// ENVIO 01: Envio de e-mail para o responsavel pela pendencia (Gestor, Recursos Humanos ou Presidencia)
							If !Empty(cMails) // E-mails carregados
							/*
								If .T. // TESTES EVERSON (mostra os e-mails que receberiam para validacao)
							//cMsg += "E-mails: " + cMails
							//cMails := cCopia
							cCopia := ""
								EndIf
							*/
								//cMails := "everson.santana@steck.com.br;camile.paula@steck.com.br"
								//lRet := u_STMAILTES(cMails, cCopia, cAssunto, cMsg, Nil, Nil, Space(03))

							EndIf

							// ENVIO 02: Envio da situacao da Solicitacao para o Gestor
							cMsg1 := ""
							cMails := ""
							If !Empty( SRA->RA_XUSRCFG ) .And. !Empty(cMails := UsrRetMail( SRA->RA_XUSRCFG )) // E-mail do Gestor

								If ZS2->ZS2_STATRG $ "B1/B3" // "B1"=Solicitacao Aguardando Analise (Recursos Humanos)     "B3"=Solicitacao Em Analise (Recursos Humanos)
									cMsg1 += "Sua Solicitacao esta em avaliacao pelo RH"
								ElseIf ZS2->ZS2_STATRG $ "B6/" // B6: -> Aprovar Solicitacao (Recursos Humanos -> Presidencia)
									cMsg1 += "Sua solicitação foi aprovada pelo o RH e encaminhada para a aprovação da Presidência. "
								ElseIf ZS2->ZS2_STATRG $ "C1/" // "C1"=Solicitacao Aguardando Analise (Presidencia)      "C3"=Solicitacao em Analise (Presidencia)
									cMsg1 += "Sua solicitação está em análise da Presidência "
								ElseIf ZS2->ZS2_STATRG $ "A4/" // "A4"=Solicitacao Reprovada (Recursos Humanos/Presidencia)
									If cHldStat == "B4" // Se estava em "B4"=Solicitacao Reprovada (Presidencia)
										cMsg1 += "Sua solicitação foi reprovada pela a Presidência"
									Else // Recursos Humanos
										cMsg1 += "Sua Solicitacao foi reprovada pelo RH"
									EndIf
								ElseIf ZS2->ZS2_STATRG $ "D1/" // "D1"=Solicitacao Aprovada (Presidencia)
									cMsg1 += "Sua solicitação foi aprovada pela a Presidência"
								ElseIf ZS2->ZS2_STATRG $ "D3/" // D3: Alteracao Salarial Processada (Recursos Humanos)
									cMsg1 += "Sua solicitação foi efetivada"
								EndIf

								If !Empty(cMsg1)

									cMsg := ""
									cMsg += '<html>'
									cMsg += '<head>'
									cMsg += '<title>' + cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
									cMsg += '</head>'
									cMsg += '<body>'
									cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
									cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=80%>'
									cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Definicao do texto/detalhe do email                                         ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

									cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Solicitacao: ' + ZS2->ZS2_CODSOL + ' </Font></B></TD>'
									cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Funcionario: ' + ZS2->ZS2_MATFUN + " " + RTrim(oObj:aCols[ oObj:nAt, &("nP0" + Right(cObj,1) + "NomFun") ]) + ' </Font></B></TD>'
									cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Status: '+Alltrim(cMsg1)+' </Font></B></TD>'
									//cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> TESTE:'+Alltrim(cMails)+'  </Font></B></TD>'

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Definicao do rodape do email                                                ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									cMsg += '</Table>'
									cMsg += '<P>'
									cMsg += '<Table align="center">'
									cMsg += '<tr>'
									cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
									cMsg += '</tr>'
									cMsg += '</Table>'
									cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
									cMsg += '</body>'
									cMsg += '</html>'


									//     cMsg := "Solicitacao: " + ZS2->ZS2_CODSOL + Chr(13) + Chr(10) + ;
										//         "Funcionario: " + ZS2->ZS2_MATFUN + " " + RTrim(oObj:aCols[ oObj:nAt, &("nP0" + Right(cObj,1) + "NomFun") ]) + Chr(13) + Chr(10) + ;
										//         cMsg

								/*
									If .T. // TESTES EVERSON (mostra os e-mails que receberiam para validacao)
								cMsg += "E-mails: " + cMails // So o e-mail do gestor nesse caso
								cMails := cCopia
								cCopia := ""
									EndIf
								*/
									//cMails := "everson.santana@steck.com.br;camile.paula@steck.com.br"
									lRet := u_STMAILTES(cMails, cCopia, cAssunto, cMsg, Nil, Nil, Space(03))

								EndIf

							EndIf

						EndIf

					EndIf
				EndIf
			EndIf
		EndIf
	Next
Return

Static Function GP010AUT( nVlrSalari, dDatAltSal, cTipAltSal, cFilPos, cMatPos )
	Local lRet := .T.
//Local aCabec := {}
///Local nPos := 0
	Private lMsErroAuto := .F.

//  ExecBlock("MODELGPEA250",.F.,.F.)


/*
/*
DbSelectArea("SX3")
DbSetOrder(1)
SX3->(MsSeek("SRA"))

	While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SRA"

		If  SX3->X3_CONTEXT <> "V"

			If !Alltrim(SX3->X3_CAMPO) $ "RA_SALARIO#RA_TIPOALT#RA_DATAALT"

aAdd(aCabec,{ SX3->X3_CAMPO, SRA->&(SX3->X3_CAMPO)					,Nil })

			EndIf

		Endif
SX3->(DbSkip())
	EndDo
*/

	DbSelectArea("SRA")
	DbSetorder(1)
	DbGotop()
	If DbSeek(cFilPos+cMatPos )

		aAdd(aCabec,{ "RA_FILIAL",       SRA->RA_FILIAL					,Nil })
		aAdd(aCabec,{ "RA_MAT",          SRA->RA_MAT                    ,Nil })
		//aAdd(aCabec,{ "RA_SALARIO",      nVlrSalari                     ,Nil })
		//aAdd(aCabec,{ "RA_TIPOALT",      cTipAltSal                     ,Nil })
		//aAdd(aCabec,{ "RA_DATAALT",      dDatAltSal                     ,Nil })


		//aDel(aCabec,1) //RA_FILIAL
		//aSize(aCabec,Len(aCabec)-1)
	/*
		If(aCabec[60,2] != SRA->RA_SALARIO)
	aAdd(aCabec,{'RA_TIPOALT',cTipAltSal,NIL})
	aAdd(aCabec,{'RA_DATAALT',dDatAltSal,NIL})
		else
			if((nPos := aScan(aCabec,{|x|x[1] == 'RA_SALARIO'}))> 0)
	aDel(aCabec,nPos)
	aSize(aCabec,Len(aCabec)-1)
			endIf
		EndIf
	*/

	EndIf

	MsExecAuto({|x,y,k,w| GPEA010(x,y,k,w) }, Nil, Nil, aCabec, 4)  // Alteracao

	If lMsErroAuto
		MostraErro()
		lRet := .F.
	EndIf


// Retorno atalhos
	SetKey(VK_F5,{|| GravSoli( cCmbPrcUsr, "oGetD2" ) }) // Salvar Solicitacoes
	SetKey(VK_F8,{|| StatsChg( cObjFoc, cCmbPrcUsr ) }) // Mudanca de Status
	SetKey(VK_F10,{|| GeraSoli( cCmbPrcUsr ) }) // Gerar Solicitacao


Return lRet
