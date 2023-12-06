#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchMrp17 ºAutor ³Jonathan Schmidt Alvesº Data ³ 01/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao mestre de integracao SCHMRP17.       M. R. P.       º±±
±±º          ³                                                            º±±
±±º          ³ Funcionamento:                                             º±±
±±º          ³ Esta funcao devera ser chamada sempre que for necessaria a º±±
±±º          ³ exportacao de resultados do calculo MRP para planilha com  º±±
±±º          ³ objetivo de manipulacao de dados e recarregamento.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Nome do Arquivo segue o padrao:                            º±±
±±º          ³ STECK_YYYYMMDD_HHMMSS.CSV                                  º±±
±±º          ³                                                            º±±
±±º          ³ STECK: Fixo Steck                                          º±±
±±º          ³ YYYY: Ano da geracao                                       º±±
±±º          ³ MM: Mes da geracao                                         º±±
±±º          ³ DD: Dia da geracao                                         º±±
±±º          ³ HH: Hora da geracao                                        º±±
±±º          ³ MM: Minuto da geracao                                      º±±
±±º          ³ SS: Segundos da geracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr: Mensagem de processamento                          º±±
±±º          ³         Exemplo: 2=AskYesNo                                º±±
±±º          ³                                                            º±±
±±º          ³ aRcTab: Tabela e os recnos da tabela para posicionamento.  º±±
±±º          ³         [01,01]: Tabela de posicionamento. Ex: "SB1"       º±±
±±º          ³         [01,02]: Matriz de recnos. Ex: { 10, 11, 12, 13 }  º±±
±±º          ³                                                            º±±
±±º          ³         Exemplo: { { "SB1", { 10, 11, 12, 13 } } }         º±±
±±º          ³                                                            º±±
±±º          ³         Exemplo: { { "SB1", { 101, 102, 103, 104 } }       º±±
±±º          ³                    { "SBM", {   0,  10,  11,  12 } } }     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchMrp17(nMsgPr, aRcTab)
Local cDtHrP := DtoS(Date()) + "_" + StrTran(Time(),":","")         // Data + Hora + Minuto + Segundo Processamento         Ex: "20201812_152473"
Local cArqDs := "C:\TEMP\" + "STECK_" + cDtHrP + ".CSV"             // Arquivo de Processamento                             Ex: "STECK_20201812_1524735.CSV"
Local aResul := {}
Default nMsgPr := 2 // 2=AskYesNo
// Chamada 01: Montagem da matriz molde
aMolds := u_MntMolds("MRP", nMsgPr)
// Chamada 02: Carregamento dos dados
aResul := LoadDads(nMsgPr, aRcTab, aMolds)
// Chamada 03: Gravacao dos dados carregados em arquivo .CSV
GrvsDads(nMsgPr, "", cArqDs, aResul, aMolds, cDtHrP)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MntMolds ºAutor ³Jonathan Schmidt Alvesº Data ³ 26/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem do layout de integracao (Planilha .CSV)           º±±
±±º          ³                                                            º±±
±±º          ³ Planilha .CSV - Geracao da planilha a partir da matriz     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTipRg: Tipo dos registros                                 º±±
±±º          ³         Exemplo: "MRP"=Calculo do MRP                      º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPr: Mensagem de processamento                          º±±
±±º          ³         Exemplo: 2=AskYesNo                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MntMolds(cTipRg, nMsgPr)
Local aMolds := {}
Local _z1
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Calculo M.R.P.)...", "", "", 80, "PROCESSA")
		Sleep(100)
	Next
EndIf
If cTipRg == "MRP" // Calculo MRP
    //           { { ########################## L A Y O U T  C L I E N T E ##################################### }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,           Regras de Integridade ,                                   Detalhes }, { Variavel informacoes,		                                 Validacao pre-carregamento,                    		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                             }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {        01,                                   02,                                         03 }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Produto",              "Codigo do Produto"    ,                                      "   " }, {	               "_",                                                           ".T.",                                                                                                                                                                                        "SB1->B1_COD",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,          "Eval({|| SB1->(DbSetOrder(1)), SB1->(DbSeek(_cFilSB1 + PadR(aDado[01],15))) })",                                           "PadR(aDado[01],15)",                               ".T.",                       "", "ZRP_CODPRO" } })
    aAdd(aMolds, { { "Descricao",            "Descricao do Produto" ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                "RTrim(SB1->B1_DESC)",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[02]))",                               ".T.",                       "", "ZRP_DESCRI" } })
    aAdd(aMolds, { { "Grupo",                "Grupo do Produto"     ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                      "SB1->B1_GRUPO",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                            "PadR(aDado[03],4)",                               ".T.",                       "", "ZRP_CODGRU" } })
    aAdd(aMolds, { { "Descricao Grupo",      "Descricao do Grupo"   ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                 "Iif(SBM->(!EOF()), RTrim(Upper(SBM->BM_DESC)), '')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[04]))",                               ".T.",                       "", "ZRP_DESGRU" } })
    aAdd(aMolds, { { "Agrupamento",          "Agrupamento"          ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                   "Iif(SBM->(!EOF()) .And. Len(aGrp := FwGetSX5('ZZ', SBM->BM_XAGRUP)) > 0, RTrim(aGrp[01,04]), '')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[05]))",                               ".T.",                       "", "ZRP_AGRUPA" } })
    aAdd(aMolds, { { "Origem",               "Origem"               ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "SB1->B1_CLAPROD",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRP_ORIGEM" } })
    aAdd(aMolds, { { "Est. Segur.",          "Est. Segur."          ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                     "TransForm(SB1->B1_ESTSEG, '@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.", /*"Val(StrTran(aDado[07],',','.'))"*/  "u_AjstVlrs(aDado[07])",                               ".T.",                       "", "ZRP_ESTSEG" } })
    aAdd(aMolds, { { "Previsao de Vendas",   "Previsao de Vendas."  ,                                      "   " }, {                  "_",                                                           ".T.", "TransForm( Eval({||, Iif((nFnd := ASCan(aTotais[01], {|x|, PadR(x[01],nTamB1Cod) + x[02] + x[03] == SB1->B1_COD + StrZero(_n2,3) + 'SC4' })) > 0, aTotais[01,nFnd,04], 0) }), '@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.", /*"Val(StrTran(aDado[08],',','.'))"*/  "u_AjstVlrs(aDado[08])",                               ".T.",                       "", "ZRP_PRVVEN" } })
    aAdd(aMolds, { { "Custo UM. 1ª moeda",   "Custo UM. 1ª moeda"   ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                         "TransForm(SB1->B1_UPRC,'@E 999,999.99999')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.", /*"Val(StrTran(aDado[09],',','.'))"*/  "u_AjstVlrs(aDado[09])",                               ".T.",                       "", "ZRP_CUSUNI" } })
    aAdd(aMolds, { { "ABC",                  "ABC"                  ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XABC",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                    "aDado[10]",                               ".T.",                       "", "ZRP_CURABC" } })
    aAdd(aMolds, { { "FMR",                  "FMR"                  ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SB1->B1_XFMR",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                    "aDado[11]",                               ".T.",                       "", "ZRP_CODFRM" } })
    aAdd(aMolds, { { "Fornecedor",           "Fornecedor"           ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                "Iif(SA2->(!EOF()), SA2->A2_COD, '')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                    "aDado[12]",                               ".T.",                       "", "ZRP_CODFOR" } })
    aAdd(aMolds, { { "Loja",                 "Loja"                 ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                               "Iif(SA2->(!EOF()), SA2->A2_LOJA, '')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                    "aDado[13]",                               ".T.",                       "", "ZRP_LOJFOR" } })
    aAdd(aMolds, { { "Nome",                 "Nome do Fornecedor"   ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                             "Iif(SA2->(!EOF()), SA2->A2_NREDUZ, '')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                                    "aDado[14]",                               ".T.",                       "", "ZRP_NOMFOR" } })    
    aAdd(aMolds, { { "Data Da rodada M.R.P.","Data da rodada M.R.P.",                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "DtoC(Date())",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                 "!Empty(CtoD(aDado[15]))",                                              "CtoD(aDado[15])",                               ".T.",                       "", "ZRP_DATMRP" } })
    aAdd(aMolds, { { "Periodo Necessidade",  "Periodo Necessidade"  ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                                            "DtoC(aDados[ _n, 02, 01, 03, _n2, 01 ])",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                 "!Empty(CtoD(aDado[16]))",                                              "CtoD(aDado[16])",                               ".T.",                       "", "ZRP_PERIOD" } })
    aAdd(aMolds, { { "Saldo Inicial",        "Saldo Inicial"        ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                   "TransForm(aDados[ _n, 02, 01, 03, _n2, 02 ],'@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",/*"Val(StrTran(aDado[17],',','.'))"*/   "u_AjstVlrs(aDado[17])",                               ".T.",                       "", "ZRP_QTDINI" } })
    aAdd(aMolds, { { "Entradas",             "Entradas"             ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                   "TransForm(aDados[ _n, 02, 02, 03, _n2, 02 ],'@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",/*"Val(StrTran(aDado[18],',','.'))"*/   "u_AjstVlrs(aDado[18])",                               ".T.",                       "", "ZRP_QTDENT" } })
    aAdd(aMolds, { { "Saidas",               "Saidas"               ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                   "TransForm(aDados[ _n, 02, 03, 03, _n2, 02 ],'@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",/*"Val(StrTran(aDado[19],',','.'))"*/   "u_AjstVlrs(aDado[19])",                               ".T.",                       "", "ZRP_QTDSAI" } })
    aAdd(aMolds, { { "Qtde Necessidade",     "Qtde Necessidade"     ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                   "TransForm(aDados[ _n, 02, 06, 03, _n2, 02 ],'@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",/*"Val(StrTran(aDado[20],',','.'))"*/   "u_AjstVlrs(aDado[20])",                               ".T.",                       "", "ZRP_QTDNES" } })
    aAdd(aMolds, { { "Qtde Recalculada",     "Qtde Recalculada"     ,                                      "   " }, {                  "_",                                                           ".T.",                                                                                                                                   "TransForm(aDados[ _n, 02, 06, 03, _n2, 02 ],'@E 999,999,999.99')",                                                     ".T.",                                              "AllTrim(xDado) + ';'",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",/*"Val(StrTran(aDado[21],',','.'))"*/   "u_AjstVlrs(aDado[21])",                               ".T.",                       "", "ZRP_QTDREC" } })
ElseIf cTipRg == "FOR" // Aglutinacao por Fornecedor
    //           { { ########################## L A Y O U T  C L I E N T E ##################################### }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,           Regras de Integridade , Tipo, Tam, Dec,            Picture,     Dets }, { Variavel informacoes,		                                 Validacao pre-carregamento,                    		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                             }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {            01,                               02,  03,   04,  05,                  06,    07 }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Cod Forn",              "Codigo do Fornecedor", "C",   06,  00,                  "", "   " }, {	               "_",   "SB1->(DbSeek( _cFilSB1 + oGetD1:aCols[ _n1, nP01CodPro ] ))",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01CodFor ]",                                           "SA2->(!EOF())",                                                    "AllTrim(xDado)",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_CODFOR" } })
    aAdd(aMolds, { { "Loj Forn",              "Loja do Fornecedor",   "C",   02,  00,                  "", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01LojFor ]",                                           "SA2->(!EOF())",                                                    "AllTrim(xDado)",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_LOJFOR" } })
    aAdd(aMolds, { { "Nome Forn",             "Nome do Fornecedor",   "C",   40,  00,                  "", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01NomFor ]",                                           "SA2->(!EOF())",                                                    "AllTrim(xDado)",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_NOMFOR" } })
    aAdd(aMolds, { { "Periodo Necessidade",   "Periodo Necessidade",  "D",   08,  00,                  "", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01Period ]",                                           "SA2->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_PERIOD" } })
    aAdd(aMolds, { { "Qtde Recalculada",      "Qtde Recalculada",     "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01QtdRec ]",                                           "SA2->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_QTDREC" } })
    aAdd(aMolds, { { "Valor Total",           "Valor Total",          "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                   "oGetD1:aCols[ _n1, nP01CusUni ] *oGetD1:aCols[ _n1, nP01QtdRec ]",                                           "SA2->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRF_PRCCOM" } })
ElseIf cTipRg == "GRU" // Aglutinacao por Grupo de Produto
    //           { { ########################## L A Y O U T  C L I E N T E ##################################### }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,           Regras de Integridade , Tipo, Tam, Dec,            Picture,   Dets }, { Variavel informacoes,		                                 Validacao pre-carregamento,                    		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                             }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {            01,                               02,  03,   04,  05,                  06,    07 }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Cod Grupo",             "Codigo do Grupo",      "C",   04,  00,                  "", "   " }, {	               "_",   "SB1->(DbSeek( _cFilSB1 + oGetD1:aCols[ _n1, nP01CodPro ] ))",                                                                             "Iif(SB1->(!EOF()) .And. !Empty(SB1->B1_GRUPO) .And. SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO)), SBM->BM_GRUPO, Space(04))",                                           "SBM->(!EOF())",                                                    "AllTrim(xDado)",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRG_CODGRU" } })
    aAdd(aMolds, { { "Desc Grupo",            "Descricao do Grupo",   "C",   20,  00,                  "", "   " }, {	               "_",                                                 "SBM->(!EOF())",                                                                                                                                                                                       "SBM->BM_DESC",                                           "SBM->(!EOF())",                                                    "AllTrim(xDado)",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRG_CODGRU" } })
    aAdd(aMolds, { { "Periodo Necessidade",   "Periodo Necessidade",  "D",   08,  00,                  "", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01Period ]",                                           "SBM->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRG_PERIOD" } })
    aAdd(aMolds, { { "Qtde Recalculada",      "Qtde Recalculada",     "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01QtdRec ]",                                           "SBM->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRG_QTDREC" } })
    aAdd(aMolds, { { "Valor Total",           "Valor Total",          "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                  "oGetD1:aCols[ _n1, nP01CusUni ] * oGetD1:aCols[ _n1, nP01QtdRec ]",                                           "SBM->(!EOF())",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRG_PRCCOM" } })
ElseIf cTipRg == "AGR" // Aglutinacao por Agrupamento
    //           { { ########################## L A Y O U T  C L I E N T E ##################################### }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,           Regras de Integridade , Tipo, Tam, Dec,            Picture,   Dets }, { Variavel informacoes,		                                 Validacao pre-carregamento,                    		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                             }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {            01,                               02,  03,   04,  05,                  06,    07 }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Agrupamento",           "Agrupamento",          "C",   20,  00,                  "", "   " }, {                  "_",   "SB1->(DbSeek( _cFilSB1 + oGetD1:aCols[ _n1, nP01CodPro ] ))",     "Iif(SB1->(!EOF()) .And. !Empty(SB1->B1_GRUPO) .And. SBM->(!EOF()) .And. SBM->(DbSeek(_cFilSBM + SB1->B1_GRUPO)) .And. Len(aGrp := FwGetSX5('ZZ', SBM->BM_XAGRUP)) > 0, RTrim(aGrp[01,04]), '')",                                                     ".T.",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRA_AGRUPA" } })
    aAdd(aMolds, { { "Periodo Necessidade",   "Periodo Necessidade",  "D",   08,  00,                  "", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01Period ]",                      "!Empty( aResul[ Len(aResul), 01] )",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRA_PERIOD" } })
    aAdd(aMolds, { { "Qtde Recalculada",      "Qtde Recalculada",     "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                                                    "oGetD1:aCols[ _n1, nP01QtdRec ]",                      "!Empty( aResul[ Len(aResul), 01] )",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRA_QTDREC" } })
    aAdd(aMolds, { { "Valor Total",           "Valor Total",          "N",   12,  02, "@E 999,999,999.99", "   " }, {	               "_",                            "!Empty( aResul[ Len(aResul), 01] )",                                                                                                                                  "oGetD1:aCols[ _n1, nP01CusUni ] * oGetD1:aCols[ _n1, nP01QtdRec ]",                      "!Empty( aResul[ Len(aResul), 01] )",                                                             "xDado",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRA_PRCCOM" } })
EndIf
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Calculo M.R.P.)... Sucesso!", "", "", 80, "OK")
		Sleep(100)
	Next
EndIf
Return aMolds

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LoadDads ºAutor ³Jonathan Schmidt Alvesº Data ³ 01/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento dos registros (posicionado/parametrizados).   º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nMsgPr: Tipo de mensagem de processamento                  º±±
±±º          ³       Exemplo: 2=AskYesNo                                  º±±
±±º          ³                                                            º±±
±±º          ³ aRcTab: Tabela e os recnos da tabela para posicionamento.  º±±
±±º          ³         [01]: Tabela de posicionamento. Ex: "SB1"          º±±
±±º          ³         [02]: Matriz de recnos. Ex: { 10, 11, 12, 13 }     º±±
±±º          ³                                                            º±±
±±º          ³         Exemplo: { { "SB1", { 10, 11, 12, 13 } } }         º±±
±±º          ³         Exemplo: { { "SD1", { 101, 102, 103, 104 } } }     º±±
±±º          ³         Exemplo: { { "SD1", { 101, 102, 103, 104 } }       º±±
±±º          ³                    { "SZA", {   0,  10,  11,  12 } } }     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ aMolds: Matriz mestre de moldes.                           º±±
±±º          ³         Estrutura segue os layouts de cada integracao.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LoadDads(nMsgPr, aRcTab, aMolds)
Local _w
Local _z1
Local cTab := Space(03)
Local aAreaTab := {}
Local aArea := GetArea()
Local aResul := {}
Local nResul := 0
Local _n2,_n
ConOut("")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Parametros recebidos:")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aRcTab: (matriz de registros para carregamento)")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aMolds: (matriz de moldes layout)")
If Len(aRcTab) > 0 // Recnos alimentados
	If nMsgPr == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent,"02/03 Gerando...","Gerando dados...", "", "", 80, "PROCESSA")
			Sleep(100)
		Next
	EndIf
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Avaliando dados para carregamento...")
    cTab := aRcTab[01,01]				// Tabela principal de posicionamento
    aAreaTab := (cTab)->(GetArea())
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Tabela Principal: " + cTab)
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Recnos para posicionamento: " + cValToChar(Len(aRcTab[01,02])))
    For _n := 1 To Len(aRcTab[01,02]) // Recnos para posicionamentos	(SB1/SD1,etc)
        (cTab)->(DbGoto( aRcTab[01,02,_n] )) // Posiciono tabela pincipal
        // Posicionamento das demais tabelas
        For _n2 := 2 To Len(aRcTab)
        	If aRcTab[_n2,02,_n] > 0 // Recno para posicionamento
        		(aRcTab[_n2,01])->(DbGoto( aRcTab[_n2,02,_n] ))
        	Else
        		(aRcTab[_n2,01])->(DbGobottom())
        		(aRcTab[_n2,01])->(DbSkip()) // Deixo em EOF
        	EndIf
        Next
        If (cTab)->(!EOF())
            For _n2 := 1 To Len( aDados[ _n, 02, 01, 03 ] ) // Qtde de periodos     Ex: 01/03/2021, 01/04/2021
                // Rodo nos tipos   Ex: 1=Saldo Inicial     2=Entradas      3=Saidas        4=Saidas por estrutura      5=Saldo final       6=Necessidade
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
                    Else // Nao valido pre-carregamento, entao registro sera desconsiderado
                        ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Validacao pre-carregamento nao atendida em: " + aMolds[ _w, 02, 02 ])
                        aSize(aResul, --nResul) // Removo este ultimo elemento (desconsiderado)
                        Exit
                    EndIf
                Next
            Next
        EndIf
    Next
	If nMsgPr == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent,"02/03 Gerando...","Gerando dados... Sucesso!", "", "", 80, "OK")
			Sleep(100)
		Next
	EndIf
    RestArea(aAreaTab)
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros carregados: " + cValToChar(Len(aResul)))
EndIf
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("")
RestArea(aArea)
Return aResul

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GrvsDads ºAutor ³Jonathan Schmidt Alvesº Data ³ 01/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacoes dos resultados nos arquivos para integracao com  º±±
±±º          ³ geracao dos Logs de processamento.                         º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³ Esta funcao faz a gravacao de arquivos magneticos e tambem º±±
±±º          ³ faz a gravacao dos arquivos de logs de processamento.      º±±
±±º          ³                                                            º±±
±±º          ³ Nos arquivos de log de processamento podemos identificar   º±±
±±º          ³ os tipos de registros, as datas+horas de disparo bem como  º±±
±±º          ³ sucesso ou falha na concretizacao dos processamentos.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPr: Tipo de mensagem de processamento                  º±±
±±º          ³         Exemplo: 2=AskYesNo                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ cTabLg: Tabela de Logs conforme o processo em questao.     º±±
±±º          ³         Exemplo: "ZT2", etc                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ cArqDs: Arquivo destino onde serao gravados os dados.      º±±
±±º          ³                                                            º±±
±±º          ³         Exemplo: "PRDDMM_HHMMSS.TXT"                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ aResul: Matriz de resultados montados (dados gravacoes).   º±±
±±º          ³         Estrutura preparada em Linhas + Colunas.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ aMolds: Matriz mestre de moldes.                           º±±
±±º          ³         Estrutura segue os layouts de cada integracao.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ cDtHrP: Data + Hora de Processamento                       º±±
±±º          ³         Data e Hora do processamento do arquivo e log      º±±
±±º          ³         Exemplo: "1905_202000"                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ cStats: Codigo de Status detalhado de processamento        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ cArqOr: Arquivo origem onde estao sendo lidos os dados.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GrvsDads(nMsgPr, cTabLg, cArqDs, aResul, aMolds, cDtHrP)
Local lRet := .T.
Local _w1
Local _w2
Local _w3
Local _z1
Local nHdl := Nil
Local cDado := ""
Local nLines := 0
Local aRgsLg := {}
ConOut("")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Parametros recebidos:")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cTabLg: " + cTabLg)
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cArqDs: " + cArqDs)
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aResul: (matriz de resutados para gravacao)")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aMolds: (matriz de moldes layout)")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cDtHrP: " + cDtHrP)
If Len(aResul) > 0 // Dados para gravacao
	If nMsgPr == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent,"03/03 Gravando...","Gravando dados...", "", "", 80, "PROCESSA")
			Sleep(100)
		Next
	EndIf
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Avaliando dados para gravacao...")
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros: " + cValToChar(Len(aResul)))
    If !File("C:\TEMP")	// Verifico se o diretorio existe
        MakeDir("C:\TEMP") // Cria a pasta local
    EndIf
    If lRet // Dados todos validos... iniciar a gravacao
        ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados todos validos... iniciando gravacoes... (arquivo/logs)")
        // Gravacao do arquivo e dos logs
        nHdl := fCreate(cArqDs, Nil, Nil, .F.) // Cria arquivo txt
        If nHdl >= 0 // Sucesso na criacao do arquivo
            // Gravacao do cabecalho conforme aMolds
            cDado := ""
            For _w1 := 1 To Len( aMolds )
                cDado += aMolds[_w1, 01, 01] + ";" // Concatenando sempre (tudo como char mesmo)
            Next
            cDado := Left(cDado, Len(cDado) - 1) + Chr(13) + Chr(10) // Pula linha
            fWrite(nHdl, cDado, Len(cDado)) // Gravo cabecalho no arquivo
            // Gravacao dos dados
            For _w1 := 1 To Len(aResul) // Rodo em cada linha montada no aResul
                If !Empty(cTabLg)
                    RecLock( cTabLg, .T. )
                    &( cTabLg + "->" + cTabLg + "_FILIAL" ) := xFilial(cTabLg)
                EndIf
                cDado := ""
                For _w2 := 1 To Len(aResul[_w1]) // Conferencia nos tamanhos
                    cDado += aResul[_w1,_w2] // Concatenando sempre (tudo como char mesmo)
                    If !Empty(cTabLg)
                        &( cTabLg + "->" + aMolds[_w2,02,08]) := aResul[_w1,_w2] // Gravando campos de Logs
                    EndIf
                Next
                cDado += Chr(13) + Chr(10) // Pula linha
                fWrite(nHdl, cDado, Len(cDado)) // Gravo dados no arquivo
                If !Empty(cTabLg)
                    &( cTabLg + "->" + cTabLg + "_DTHRLG" ) := cDtHrP       // Data + Hora do Processamento                 Ex: "1905_202000"
                    &( cTabLg + "->" + cTabLg + "_STATLG" ) := "1"          // Status da geracao do log                     Ex: "1"=Em Geracao "2"=Gerado com sucesso
                    ( cTabLg ) ->(MsUnlock())
                    aAdd(aRgsLg, (cTabLg ) ->(Recno()) ) // Inclusao dos registros para marcadao de "2"=Gerado com sucesso no final
                EndIf
            Next
            fClose(nHdl) // Finaliza processo e fecha arquivo
            // Concretizacao dos logs como "2"=Gerados (evitando erros no meio das geracoes)
            If !Empty(cTabLg)
                ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concretizando logs...")
                For _w3 := 1 To Len(aRgsLg)
                    ( cTabLg ) -> (DbGoto( aRgsLg[_w3] ))
                    RecLock( cTabLg, .F.)
                    &( cTabLg + "->" + cTabLg + "_ARQPRC" ) := SubStr(cArqDs, Rat( "\", cArqDs ) + 1, 20)	// Obtencao do nome do arquivo       // Arquivo de processamento                     Ex: "PR1905_202000.TXT"
                    &( cTabLg + "->" + cTabLg + "_STATLG" ) := "2"          								// Status da geracao do log                     Ex: "2"=Gerado com sucesso
                    ( cTabLg ) ->(MsUnlock())
                Next
                ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concretizando logs... Concluido!")
            EndIf
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados todos validos... iniciando gravacoes... (arquivo/logs) Concluido!")
        Else // Falha na criacao do arquivo
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na criacao do arquivo (fCreate)!")
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Detalhe da falha:")
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + AllTrim(Ferror()))
        EndIf
		If nMsgPr == 2 // 2=AskYesNo
			For _z1 := 1 To 4
				u_AtuAsk09(nCurrent,"03/03 Gravando...","Gravando dados... Sucesso!", "", "", 80, "OK")
				Sleep(100)
			Next
		EndIf
    EndIf
Else // Dados nao disponibilizados para gravacao
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados nao disponibilizados para geracao do arquivo!")
    MsgStop("Dados nao disponibilizados para geracao do arquivo!","GrvsDads")
    lRet := .F.
EndIf
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("")
Return { lRet, nLines }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ AjstVlrs ºAutor ³Jonathan Schmidt Alvesº Data ³ 10/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta valores numericos em formato char para formatacao   º±±
±±º          ³ conforme para conversao em Val().                          º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cVlrPrc: Valor para processamento                          º±±
±±º          ³ lChgVal: .T.=Altera o resultado para valor numerico        º±±
±±º          ³          .F.=Mantem a informacao com char, mas ajusta a    º±±
±±º          ³              formatacao normalmente                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Exemplos:                                                  º±±
±±º          ³   Entrada    ->    Saida                                   º±±
±±º          ³                                                            º±±
±±º          ³    550,00    ->   550.00                                   º±±
±±º          ³  1.550,00    ->  1550.00                                   º±±
±±º          ³  1,550.00    ->  1550.00                                   º±±
±±º          ³   1550.00    ->  1550.00                                   º±±
±±º          ³   1550,00    ->  1550.00                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AjstVlrs(cVlrPrc, lChgVal)
Local _w1 := Len(cVlrPrc)
Local lDec := .F.
Local xVlrPrc := cVlrPrc
Default lChgVal := .T.
While _w1 > 0
    If SubStr(xVlrPrc,_w1,1) $ ".," // Ponto ou Virgula
        If !lDec
            xVlrPrc := Stuff(xVlrPrc,_w1,1,".")
            lDec := .T.
        Else
            xVlrPrc := Stuff(xVlrPrc,_w1,1,"")
        EndIf
    EndIf
    _w1--
End
If Empty(xVlrPrc) // Vazio
    xVlrPrc := "0"
EndIf
If lChgVal // .T.=Muda pra valor
    xVlrPrc := Val(xVlrPrc)
EndIf
Return xVlrPrc
