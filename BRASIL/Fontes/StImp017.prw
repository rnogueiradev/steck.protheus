#INCLUDE "PROTHEUS.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StImp017 ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Tela de processamento de Titulos Receber Schneider.        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function StImp017() // Tela de apresentacao
Local w
Local cTitle := "StImp017: Processamento de Titulos Receber Schneider"
// Variaveis filiais
Private _cFilSE1 := xFilial("SE1")
Private _cFilSA6 := xFilial("SA6")
Private _cFilSA1 := xFilial("SA1")
Private _cSqlSE1 := RetSqlName("SE1")
// Cores GetDados
Private nClrC20 := RGB(199,199,199)	// Cinza Padrao Claro		*** Panel Top e Cores GetDados 03 (apagado)
Private nClrC21 := RGB(161,161,161)	// Cinza Padrao Claro		*** Panel Top e Cores GetDados 03 (apagado)
Private nClrC22 := RGB(217,204,117) // Cinza Amarelado			*** Cores GetDados 03
Private nClrC23 := RGB(234,167,138) // Cinza Avermelhado		*** Panel Bottom
Private nClrCV1 := RGB(165,250,160) // Verde Claro				***
Private nClrCV2 := RGB(026,207,005) // Verde Escuro				***
Private nClrCE2 := RGB(255,111,111) // Vermelho					*** Get2 Titulos a Receber
Private nClrCA1 := RGB(249,255,164) // Amarelo Claro			***
Private nClrCA2 := RGB(185,185,000) // Amarelo Escuro			***
Private nClrCV4 := RGB(132,155,251) // Azul Claro				*** Get2 Pedidos de Venda
// Inicio Linha
Private nIniLin := 4
// Carregamentos
Private aDados := {}
Private aFound := {}
Private aRelacio := {}
Private aMolds01 := {}
Private aMolds02 := {}
//             {    01,           02,              03,        04,  05,  06,                  07,                                 08,                                                                    09,                     10,                                    11 }
//             { Ordem,   Nome Field,    Titulo Field, Tipo Dado, Tam, Dec,             Picture,                             Origem,                                                         Options Field, Condicao Processamento, Processamento anterior/posicionamento }
aAdd(aMolds01, {    01, "FIN_DATPGT", "[ Data Pgto ]",       "D",  08,  00,                  "",                      "CtoD(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    02, "FIN_HISTOR", "[ Historico ]",       "C",  40,  00,                  "",                   "AllTrim(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    03, "FIN_DOCUME", "[ Documento ]",       "C",  40,  00,                  "",                   "AllTrim(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    04, "FIN_VLRMOV",     "[ Valor ]",       "N",  12,  02, "@E 999,999,999.99",               "&(aRelacio[w2,05])",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    05, "FIN_SLDFIM",     "[ Pago ]",       "N",  12,  02, "@E 999,999,999.99",               "&(aRelacio[w2,05])",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    06, "FIN_CLIENT",   "[ Cliente ]",       "C",  06,  00, 				 "",                   "AllTrim(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    07, "FIN_VLJURO",     "[ Juros ]",       "N",  12,  02, "@E 999,999,999.99",               "&(aRelacio[w2,05])",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds01, {    08, "FIN_VLDESC",  "[ Desconto ]",       "N",  12,  02, "@E 999,999,999.99",               "&(aRelacio[w2,05])",                                                                    "",        "AllwaysTrue()",                                    "" })
//             {    01,           02,              03,        04,  05,  06,                  07,                                 08,                                                                    09,                     10,                                    11 }
//             { Ordem,   Nome Field,    Titulo Field, Tipo Dado, Tam, Dec,             Picture,                             Origem,                                                         Options Field, Condicao Processamento, Processamento anterior/posicionamento }
aAdd(aMolds02, {    01, "FIN_PREFIX",       "Prefixo",       "C",  03,  00,                  "",                  "SE1->E1_PREFIXO",                                                                    "",        "aFound[w] > 0",          "SE1->(DbGoto( aFound[w] ))" })
aAdd(aMolds02, {    02, "FIN_NUMTIT",        "[Numero]",       "C",  09,  00,                  "",                      "AllTrim(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds02, {    03, "FIN_PARCEL",       "[Parcela]",       "C",  02,  00,                  "",                  "AllTrim(xDado)",                                                                    "",       "AllwaysTrue()",                                    "" })
aAdd(aMolds02, {    04, "FIN_TIPTIT",          "Tipo",       "C",  03,  00,                  "",                     "SE1->E1_TIPO",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    05, "FIN_CODCLI",        "CodCli",       "C",  06,  00,                  "",                  "SE1->E1_CLIENTE",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    06, "FIN_LOJCLI",          "Loja",       "C",  02,  00,                  "",                     "SE1->E1_LOJA",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    07, "FIN_NOMFOR",       "Cliente",       "C",  40,  00,                  "",                   "SE1->E1_NOMCLI",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    08, "FIN_NOMSA2",     "Razao Soc",       "C",  40,  00,                  "",                     "SA1->A1_NOME",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    09, "FIN_VLRTIT",         "Valor",       "N",  12,  02, "@E 999,999,999.99",                    "SE1->E1_VALOR",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    10, "FIN_SLDTIT",         "Saldo",       "N",  12,  02, "@E 999,999,999.99",                    "SE1->E1_SALDO",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    11, "FIN_EMISSA",       "Emissao",       "D",  08,  00,                  "",                  "SE1->E1_EMISSAO",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    12, "FIN_VENCTO",        "Vencto",       "D",  08,  00,                  "",                   "SE1->E1_VENCTO",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    13, "FIN_VENCREA",     "VencReal",       "D",  08,  00,                  "",                  "SE1->E1_VENCREA",                                                                    "",        "aFound[w] > 0",                                    "" })
aAdd(aMolds02, {    14, "FIN_STAPRC",        "StaPrc",       "C",  02,  00,                  "", "StrZero(Val(Left(cStaReg,1)),02)",    "02=Nao Processar;03=Processar;04=Nao Localizado;05=Ja Processado",        "AllwaysTrue()",                                    "" })
aAdd(aMolds02, {    15, "FIN_STAREG",        "StaReg",       "C", 100,  00,                  "",                          "cStaReg",                                                                    "",        "AllwaysTrue()",                                    "" })
aAdd(aMolds02, {    16, "FIN_CREDITO",        "Credito",       "C", 15,  00,                  "",                          "AllTrim(xDado)",                                                                    "",        "AllwaysTrue()",                                    "" })
// Objetos
Private oDlg11
Private oGetD1
Private aHdr01 := {}
Private aFldsAlt01 := {}
Private aGetMotBxa := ReadMotBx()
// Banco
Private oSayCodBco
Private oGetCodBco
Private cGetCodBco := Space(TamSX3("A6_COD")[01])
// Agencia
Private oSayCodAge
Private oGetCodAge
Private cGetCodAge := Space(TamSX3("A6_AGENCIA")[01])
// Conta
Private oSayNumCon
Private oGetNumCon
Private cGetNumCon := Space(TamSX3("A6_NUMCON")[01])
// Nome Banco
Private oSayNomBco
Private oGetNomBco
Private cGetNomBco := Space(TamSX3("A6_NOME")[01])
// Motivo Baixa
Private oSayMotBxa
Private oGetMotBxa
Private cGetMotBxa := Space(03)
// Atalhos
SetKey(VK_F8,   {|| MarkRegs() })                   // Marcar/Desmarcar processamentos
SetKey(VK_F12,  {|a,b| AcessaPerg("FIN080",.T.) })  // Perguntas
DEFINE MSDIALOG oDlg11 FROM 050,165 TO 742,1443 TITLE cTitle Pixel
// Panel
oPnlTop	:= TPanel():New(002,002,,oDlg11,,,,,nClrC21,635,053,.F.,.F.)
oPnlMid	:= TPanel():New(055,002,,oDlg11,,,,,nClrC23,635,280,.F.,.F.)
oPnlBot	:= TPanel():New(283,002,,oDlg11,,,,,nClrC22,635,060,.F.,.F.)

// Logo Schneider
//@001,494 BitMap Size 260,050 File "LogoIntegrance.jpg" Of oPnlTop Pixel Stretch Noborder

@006,006 SAY	oSayCodBco PROMPT "Banco:" SIZE 040,010 OF oPnlTop PIXEL
@004,030 MSGET	oGetCodBco VAR cGetCodBco SIZE 025,008 OF oPnlTop PICTURE "@!" F3 "SA6" PIXEL HASBUTTON Valid VldBco01()
@006,072 SAY	oSayCodAge PROMPT "Agencia:" SIZE 040,010 OF oPnlTop PIXEL
@004,100 MSGET	oGetCodAge VAR cGetCodAge SIZE 030,008 OF oPnlTop PICTURE "@!" PIXEL READONLY
@006,142 SAY	oSayNumCon PROMPT "Conta:" SIZE 040,010 OF oPnlTop PIXEL
@004,165 MSGET	oGetNumCon VAR cGetNumCon SIZE 050,008 OF oPnlTop PICTURE "@!" PIXEL READONLY
@006,230 SAY	oSayNomBco PROMPT "Nome:" SIZE 040,010 OF oPnlTop PIXEL
@004,250 MSGET	oGetNomBco VAR cGetNomBco SIZE 080,008 OF oPnlTop PICTURE "@!" PIXEL READONLY
@006,360 SAY	oSayMotBxa PROMPT "Motivo Baixa:" SIZE 040,010 OF oPnlTop PIXEL
@004,400 MSCOMBOBOX oGetMotBxa VAR cGetMotBxa ITEMS aGetMotBxa SIZE 105,011 OF oPnlTop Pixel Valid VldMot01()
// Carregar o DEB no motivo da baixa
If (nFind := ASCan(aGetMotBxa, {|x|, Left(x,03) == "NOR" })) > 0
	oGetMotBxa:nAt := nFind
EndIf
// Inativando objetos
aObjInac := { "oGetCodAge", "oGetNumCon", "oGetNomBco" }
aEVal(aObjInac, {|x|, &(x):lActive := .F. })
@032,505 BUTTON "Carregar Excel"	Size 047,012 Pixel Of oDlg11 Action(StImp021()) // Carregar Excel
@032,570 BUTTON "Processar"			Size 047,012 Pixel Of oDlg11 Action(StImp031()) // Processar
@044,505 SAY	oSayHlpF8	PROMPT "F8 = Marca/Desmarca" SIZE 120,010 OF oPnlTop PIXEL
@044,575 SAY	oSayHlpF12	PROMPT "F12 = Parametros Baixa" SIZE 120,010 OF oPnlTop PIXEL
aHdr01 := LoadHder() // Criacao do Header
For w := 1 To Len(aHdr01)
	&("nP01" + SubStr(aHdr01[w,2],5,6)) := w
Next
aCls01 := ClearCls(aHdr01) // Montagem em branco do aCols
aFldsAlt01 := {}
oGetD1 := MsNewGetDados():New(001,001,203,635,Nil,"AllwaysTrue()", "AllwaysTrue()" ,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlMid,@aHdr01,@aCls01)
oGetD1:oBrowse:lVisible := .F.
oGetD1:oBrowse:lHScroll := .F.
oGetD1:oBrowse:SetBlkBackColor({|| GetD1Clr(oGetD1:aCols, oGetD1:nAt, aHdr01) })
// oGetD1:oBrowse:bChange := {|| ShowDets() }
ACTIVATE MSDIALOG oDlg11 CENTERED
SetKey(VK_F8,   {|| Nil })          // Desativo atalho marcar registros processar/nao processar
SetKey(VK_F12,  {|| Nil })          // Desativo atalho parametros F12 Baixa Receber (FINA070)
Return

Static Function GetD1Clr(aCols, nLine, aHdrs) // Cores GetDados 01
Local nClr := nClrC21 // Cinza Padrao
If !Empty(aCols[nLine, nP01NumTit]) // Registro localizado
	If Left(aCols[nLine, nP01StaReg],1) == "5" // Ja baixado
		nClr := nClrCV4		// Azul Claro
	ElseIf Left(aCols[nLine, nP01StaReg],3) >= "310" // Precisao '10' ou maior
		If aCols[nLine, nP01StaPrc] == "03" // "03=Processar
			nClr := nClrCV2 // Verde Escuro
		Else
			//nClr := nClrCV1 // Verde Claro
			nClr := nClrCE2
		EndIf
	ElseIf Left(aCols[nLine, nP01StaReg],3) > "300" .And. Left(aCols[nLine, nP01StaReg],3) <= "309" // Precisao 'intermediaria'
		If aCols[nLine, nP01StaPrc] == "03" // "03=Processar
			nClr := nClrCA2 // Amarelo Escuro
		Else
			nClr := nClrCA1 // Amarelo Claro
		EndIf
	EndIf
ElseIf Left(aCols[nLine, nP01StaReg],1) == "4" // Nao Localizado
	If Left(aCols[nLine, nP01StaReg],3) $ "401/403/" // Nao localizado pq nao tem valor (receber) ou nao tem documento (tarifa/etc na Planilha 03=Totvs)
		//nClr := nClrC20 	// Cinza padrao
		nClr := nClrCE2
	Else
		nClr := nClrCE2 	// Vermelho
	EndIf
EndIf


Return nClr

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StImp021 ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao que recebe a matriz de dados para localizacoes.     ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Estrutura da matriz:                                       ∫±±
±±∫          ≥ [01] Data da baixa/movimento                               ∫±±
±±∫          ≥ [02] Historico                                             ∫±±
±±∫          ≥ [03] Numero documento/identificacao                        ∫±±
±±∫          ≥ [04] Valor da baixa/movimento                              ∫±±
±±∫          ≥ [05] Saldo                                                 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StImp021()
Private lOk := .T.
Private cArquivo := ""
Private cDrive := ""
Private cDir := ""
Private cFile := ""
Private cExten := ""
If Empty(cArquivo)
	cArquivo := fAbrir() // "C:\TEMP\RETORNOCONCILIA_PAGAMENTO_1443725046558_MOD.CSV"
EndIf
If Empty(cArquivo)
	MsgStop("Arquivo nao informado!","StImp021")
	Return
ElseIf !File(cArquivo)
	MsgStop("Arquivo nao encontrado!" + Chr(13) + Chr(10) + ;
	cArquivo,"StImp021")
	Return
Else
	SplitPath(cArquivo, @cDrive, @cDir, @cFile, @cExten)
EndIf
nOpc := Aviso("Layout Extrato Excel","Informe o Layout do arquivo Excel!", { "7=Schneider" /*"1=Sicoob", "2=Itau", "3=Totvs"*/ })
// Abertura Tabelas
DbSelectArea("SE1")
SE1->(DbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
// Private aMolds01 := { { 01, "FIN_DATPGT", "[ Data ]", "D", 08, 00, "", "CtoD(xDado)" }, { 02, "FIN_HISTOR", "[ Historico ]", "C", 40, 00, "", "AllTrim(xDado)" },;
// { 03, "FIN_DOCUME", "[ Documento ]", "C", 40, 00, "", "AllTrim(xDado)" }, { 04, "FIN_VLRMOV", "[ Valor ]", "N", 12, 02, "@E 999,999,999.99", "&(aRelacio[w2,05])" },;
// { 05, "FIN_SLDFIM", "[ Saldo ]", "N", 12, 02, "@E 999,999,999.99", "&(aRelacio[w2,05])" } }
If nOpc == 1 // Schneider Ex: DATA PAGAMENTO;C”D CLIENTE;NF;Parcela;Vencimento;Valor Sistema (R$);Valor Pago (R$);Juros;Desconto;Saldo;HistÛrico
	// aMolds: Data, Historico, Documento, Valor, Saldo
	nIniLin := 2 // Schneider inicia na 2da linha
	//            { Coluna Origem Excel, Coluna conforme aMolds01,      Titulo, Localiz,                                                             Tratamento dif propagado pro aMolds01, Linhas duplas }
	aRelacio := { {                  01,                       01, "Data Pgto",     .F.,                                                                                                "",           .F. },;
	{                                11,                       02, "Historico",     .F.,                                                                                                "",           .F. },;
	{                                03,                       03, "Documento",     .T.,                                                                                                "",           .F. },;
	{                                06,                       04, "Valor"    ,     .T., "Val(StrTran(StrTran(StrTran(StrTran(StrTran(xDado,'(R$)',''),'R$',''),'.',''),',','.'),' ',''))",           .F. },;
	{                                07,                       05, "Pago"    ,     .F., "Val(StrTran(StrTran(StrTran(StrTran(StrTran(xDado,'(R$)',''),'R$',''),'.',''),',','.'),' ',''))",           .F. },;
	{                                02,                       06, "Cliente"  ,     .T.,                                                                                                "",           .F. },;
	{                                08,                       07, "Juros"    ,     .F., "Val(StrTran(StrTran(StrTran(StrTran(StrTran(xDado,'(R$)',''),'R$',''),'.',''),',','.'),' ',''))",           .F. },;
	{                                09,                       08, "Desconto" ,     .F., "Val(StrTran(StrTran(StrTran(StrTran(StrTran(xDado,'(R$)',''),'R$',''),'.',''),',','.'),' ',''))",           .F. },;
	{                                03,                       10, "Numero" ,       .F., "",                                                                                                            .F. },;
	{                                04,                       11, "Parcela" ,      .F., "",                                                                                                           .F. },;
	{                                12,                       24, "Credito" ,      .F., "",                                                                                                           .F. }}
EndIf
/*
If nOpc == 1 // Sicoob Ex: "DATA;DOCUMENTO;HIST”RICO;VALOR"
	//            { Coluna Origem Excel, Coluna conforme aMolds01,      Titulo, Localiz, Tratamento dif propagado pro aMolds01, Linhas duplas }
	aRelacio := { {                  01,                       01, "Data Pgto",     .F.,                                    "",           .F. },;
	{                                02,                       03, "Historico",     .T.,                                    "",           .T. },;
	{                                03,                       02, "Documento",     .F.,                                    "",           .F. },;
	{                                04,                       04, "Valor"    ,     .T., "Val(StrTran(StrTran(StrTran(StrTran(xDado,'R$',''),'.',''),',','.'),' ',''))", .F. },;
	{                                05,                       05, "Saldo"    ,     .F., "Val(StrTran(StrTran(StrTran(StrTran(xDado,'R$',''),'.',''),',','.'),' ',''))", .F. } }
ElseIf nOpc == 2 // Itau Ex: " ;DATA;LAN«AMENTO;;DEBITO;CREDITO;SALDO R$;;"
	//            { Coluna Origem Excel, Coluna conforme aMolds01,      Titulo, Localiz, Tratamento dif propagado pro aMolds01, Linhas duplas }
	aRelacio := { {                  02,                       01, "Data Pgto",     .F.,                                    "",           .F. },;
	{                                03,                       02, "Historico",     .F.,                                    "",           .T. },;
	{                                04,                       03, "Documento",     .T.,                                    "",           .F. },;
	{                                05,                       04, "Valor"    ,     .T., "Val(StrTran(StrTran(StrTran(xDado,'R$',''),',',''),' ',''))", .F. },;
	{                                06,                       05, "Saldo"    ,     .F., "Val(StrTran(StrTran(StrTran(xDado,'R$',''),',',''),' ',''))", .F. } }
ElseIf nOpc == 3 // Santander (Extrato Totvs) Data CrÈdito; Num. Cheque; OperaÁ„o; Documento; Pessoa; Categoria; Entradas; Saidas; Saldo
	nIniLin := 2 // Santander Petrofer inicia da linha 2
	//            { Coluna Origem Excel, Coluna conforme aMolds01,      Titulo, Localiz, Tratamento dif propagado pro aMolds01, Linhas duplas }
	aRelacio := { {                  01,                       01, "Data Pgto",     .F.,                                    "",           .F. },;
	{                                05,                       02, "Historico",     .F.,                                    "",           .T. },;
	{                                04,                       03, "Documento",     .T.,                                    "",           .F. },;
	{                                08,                       04, "Valor"    ,     .T., "Val(StrTran(StrTran(StrTran(StrTran(xDado,'R$',''),'.',''),',','.'),' ',''))" , .F. },; // "Val(StrTran(StrTran(StrTran(StrTran(xDado,'R$',''),'.',''),',','.'),' ',''))"*/ /*"Val(StrTran(StrTran(StrTran(xDado,'R$',''),',',''),' ',''))"
	{                                09,                       05, "Saldo"    ,     .F., "Val(StrTran(StrTran(StrTran(StrTran(xDado,'R$',''),'.',''),',','.'),' ',''))" , .F. } } // "Val(StrTran(StrTran(StrTran(xDado,'R$',''),',',''),' ',''))"
EndIf
*/
aSort(aRelacio,,, {|x,y|, x[02] < y[02] }) // Ordenar o aRelacio na ordem das colunas do aMolds01
u_AskYesNo(1200,"Carregando","Carregando dados do arquivo...",cArquivo,"","","","NOTE",.T.,.F.,{|| lOk := LoadData(cArquivo,nIniLin) }) // Leitura dos dados no arquivo .CSV
If !lOk // Invalido
	MsgStop("Carregamento do arquivo com resultado invalido!","StImp021")
Return
ElseIf Len(aDados) == 0
	MsgStop("Nenhuma linha foi carregada do arquivo!","StImp021")
Return
EndIf
aCls01 := ClearCls(aHdr01) // Montagem em branco do aCols
u_AskYesNo(1200,"Processando","Processando dados do arquivo...",cArquivo,"","","","NOTE",.T.,.F.,{|| lOk := ProcData() }) // Leitura dos dados no arquivo .CSV
If !lOk
	MsgStop("Processamento do arquivo com resultado invalido!","StImp021")
Return
Else // Sucesso
	oGetD1:oBrowse:lVisible := Len(aCls01) > 0
	If Len(aCls01) == 0
		aCls01 := ClearCls(aHdr01) // Montagem em branco do aCols
	EndIf
	oGetD1:aCols := aClone(aCls01)
	oGetD1:Refresh()
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadData ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento de dados da planilha.                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadData(cArquivo, nIniLin) // , aMolds)
Local w
Local z
Local lRet := .T.
Local nLastUpdate := Seconds()
Local cBuffer := ""
Local nLenCols := 4
FT_FUse(cArquivo)
FT_FGOTOP()
nLines := FT_FLASTREC()
cLines := cValToChar(nLines)
aDado := {} // Dados de cada linha
aDados := {} // Detalhes de Dados
nLine := 0 // Linha inicial
// Posicionando na linha inicial
For w := 1 To nIniLin -1
	FT_FSkip()
	nLine++
	nCurrent++
Next
_oMeter:nTotal := nLines
While (!FT_FEOF()) .And. lRet
	nCurrent++
	nLine++
	If (Seconds() - nLastUpdate) > 2 // Se passou 2 segundos desde a ˙ltima atualizaÁ„o da tela
		u_AtuAsk09(nCurrent,"Lendo linha... " + cValToChar(nLine) + " / " + cLines,"","","",80)
		nLastUpdate := Seconds()
	EndIf
	cBuffer := FT_FREADLN()
	While ";;" $ cBuffer
		cBuffer := StrTran(cBuffer,";;","; ;")
	End
	aDado := StrToKarr(cBuffer,";")
	If Len(aDado) >= nLenCols .And. !Empty(aDado[ nP01DatPgt ]) // Minimo de colunas
		aAdd(aDados, aClone(aDado)) // Inclusao do elemento
	Else // Colunas incompletas
		// Trecho Linha dupla (os historicos no Excel/CSV as vezes tem 2 linhas, esse trecho identifica e trata isso)
		For z := 1 To Len(aDado) // Rodo nas colunas complementares carregadas
			If !Empty(aDado[z])
				nColExcel := ASCan(aRelacio, {|x|, x[01] == z })
				If aRelacio[nColExcel,06] // .T.=Coluna Excel com possibilidade de linha dupla
					If nColExcel > 0 // Coluna Excel
						nColMolds := aRelacio[nColExcel,02] // Coluna aMolds01
						If nColMolds > 0 // Coluna no aMolds01
							aDados[ Len(aDados), nColMolds ] += " " + aDado[z] // Inclui linha complementar
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		// Fim do trecho linha dupla
	EndIf
	FT_FSkip()
End
FT_FUse() // Fecha o arquivo .CSV
Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ProcData ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processamento dos dados carregados da planilha.            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ProcData()
Local w
Local w2
Local lRet := .T.
Private aCompars := {}
Private aChecks := {}
aAdd(aChecks, { "aCompars[w4,01] <= _aCls01[ nP01DatPgt ]",						.F., 03 }) // Data pagamento de acordo							Menor ou igual
aAdd(aChecks, { "aCompars[w4,02] <= aCompars[w4,02]",							.F., 03 }) // Vencimento de acordo								Titulo ainda nao vencido
aAdd(aChecks, { "aCompars[w4,03] <= aCompars[w4,03]",							.F., 02 }) // Vencimento Real de acordo							Ainda nao vencido
aAdd(aChecks, { "aCompars[w4,04] == aCompars[w4,05]",							.F., 02 }) // Valor igual ao saldo								Em aberto
// aAdd(aChecks, { "AllTrim(Upper(aCompars[w4,06])) $ Upper(_aCls01[nP01Histor])", .F., 04 }) // Nome Reduzido do Fornecedor confere com historico
// aAdd(aChecks, { "AllTrim(Upper(aCompars[w4,07])) $ Upper(_aCls01[nP01Histor])", .F., 04 }) // Razao Social do Fornecedor confere com historico
aCls01 := {}
aFound := {}
For w := 1 To Len(aDados) // Rodo nos registros
	_aCls01 := {}
	// Tratamento das colunas aMolds01 (Excel)
	For w2 := 1 To Len(aRelacio) // Rodo nos relacionamentos (colunas do Excel com o elemento do aMolds01)
		nColExcel := aRelacio[w2,01] // Coluna Origem Excel
		nColRelac := aRelacio[w2,02] // Coluna de relacionamento
		If nColRelac > 0 // Existe coluna de relacionamento no aMolds01
			nColMolds := ASCan(aMolds01, {|x|, x[01] == nColRelac }) // Encontro a coluna com os tratamentos no aMolds01
			If nColMolds > 0 // Encontrada a coluna de relacionamento
				If nColExcel <= Len(aDados[w]) // A coluna esta no Excel
					xDado := aDados[w,nColExcel] // Origem da informacao no aDados
					If !Empty(aMolds01[nColMolds,08]) // Tem tratamento
						xDado := &( aMolds01[nColMolds,08] ) // Evaluate do tratamento em xDado
					EndIf
					aAdd(_aCls01, xDado)
				Else // Coluna nao esta no Excel
					If aMolds01[nColMolds,04] == "C"
						xDado := Space( aMolds01[w2,05] )
					ElseIf aMolds01[nColMolds,04] == "D"
						xDado := CtoD("")
					ElseIf aMolds01[nColMolds,04] == "N"
						xDado := 0
					EndIf
					aAdd(_aCls01, xDado)
				EndIf
			EndIf
		EndIf
	Next
	cStaReg := IntFin13() // Localizacoes SE1
	// Trecho novo
	For w2 := 1 To Len(aMolds02)
		xDado := Nil
		If !Empty(aMolds02[w2,10]) // 10=Condicao para processamento
			If &(aMolds02[w2,10]) .And. !Empty(aMolds02[w2,08]) // 10=Condicao valida e tem 08=Origem
				If !Empty(aMolds02[w2,11]) // 11=Processamento anterior/posicionamento
					xProc := &(aMolds02[w2,11]) // Processo o posicionamento
				ElseIf aMolds02[w2,2]$"FIN_NUMTIT" 
				    xDado := aDados[w,aRelacio[9,01]] 
				ElseIf  aMolds02[w2,2]$"FIN_PARCEL"
				    xDado := aDados[w,aRelacio[10,01]]
				ElseIf  aMolds02[w2,2]$"FIN_CREDITO"
				    xDado := aDados[w,aRelacio[11,01]]	 
				EndIf
				xDado := &(aMolds02[w2,08]) // Dado origem no SE1
			EndIf
		EndIf
		If ValType(xDado) == "U" // xDado nao foi carregado/Condicao nao preenchida
			If aMolds02[w2,04] == "C"
				xDado := Space(aMolds02[w2,05])
			ElseIf aMolds02[w2,04] == "D"
				xDado := CtoD("")
			ElseIf aMolds02[w2,04] == "N"
				xDado := 0
			EndIf
		EndIf
		aAdd(_aCls01, xDado)
	Next
	// Fim
	aAdd(_aCls01, .F.) // Nao apagado
	aAdd(aCls01, aClone(_aCls01))
Next
Return lRet

Static Function IntFin13() // Localizacoes
Local w2
Local w3
Local w4
Local w5
cStaReg := ""
nVlrProc := 0 // Valor para processamento
aDocsInf := {} // Matriz de dados do documento
If !Empty(_aCls01[nP01VlrMov]) // Valor existe
	nVlrProc := _aCls01[nP01VlrMov] // Valor do processamento (positivo/negativo)
	If nVlrProc > 0 // Valor identificado
		If !Empty(StrTran(_aCls01[nP01Docume],"-","")) // Se tem o Numero do Documento
			// Pesquisa no SE1
			cQrySE1 := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_SALDO, R_E_C_N_O_ "
			cQrySE1 += "FROM " + _cSqlSE1 + " WHERE "
			cQrySE1 += "E1_FILIAL = '" + _cFilSE1 + "' AND "							// Empresa/Filial conforme
			cQrySE1 += "E1_TIPO <> 'RA'                AND "
			cQrySE1 += "E1_SALDO = " + cValToChar(Abs(nVlrProc)) + " AND "				// Saldo em aberto no momento do processamento conforme
			cQrySE1 += "E1_CLIENTE LIKE '%" + AllTrim(_aCls01[nP01Client]) + "%' AND "	// Cliente conforme
			cQrySE1 += "E1_EMISSAO <= '" + DtoS(_aCls01[nP01DatPgt]) + "' AND "			// Emissao conforme
			cQrySE1 += "E1_TIPO <> 'PA ' AND "											// Nao processar adiantamentos
			If (nFind := ASCan(aRelacio, {|x|, "DOCUMENTO" $ Upper(x[03]) })) > 0 .And. aRelacio[ nFind, 04 ] // Like por Documento									*** Em uso na Schneider
				If !Empty(_aCls01[nP01Docume]) // Documento existe
					aDocsInf := StrToKarr( RTrim(Left(_aCls01[nP01Docume],09)), "%")
					If Len(aDocsInf) > 0 // Dados do documento, etc
						cQrySE1 += Iif(Len(aDocsInf) > 1,"(","")
						For w2 := 1 To Len(aDocsInf)
							cQrySE1 += "E1_NUM LIKE '%" + AllTrim(aDocsInf[w2]) + "%'"
							If w2 < Len(aDocsInf)
								cQrySE1 += " OR "
							ElseIf w2 > 1 .And. w2 == Len(aDocsInf) // Ultimo
								cQrySE1 += ") "
							EndIf
						Next
						cQrySE1 += " AND "
					EndIf
				EndIf
			ElseIf (nFind := ASCan(aRelacio, {|x|, "HISTORICO" $ Upper(x[03]) })) > 0 .And. aRelacio[ nFind, 04 ] // Like por Documento // Like por Historico		*** Desativado na Schneider
				If !Empty(_aCls01[nP01Histor]) // Documento existe
					aDocsInf := StrToKarr( _aCls01[nP01Histor], " ")
					For w3 := Len(aDocsInf) To 1 Step -1
						If Val(aDocsInf[w3]) == 0 // Nao eh numero (nota/titulo/etc)
							aDel(aDocsInf,w3) // Removo elemento
							aSize(aDocsInf, Len(aDocsInf) - 1) // Reduzo matriz
						EndIf
					Next
					If Len(aDocsInf) > 0 // Dados do documento, etc
						cQrySE1 += Iif(Len(aDocsInf) > 1,"(","")
						For w2 := 1 To Len(aDocsInf)
							cQrySE1 += "E1_NUM LIKE '%" + AllTrim(aDocsInf[w2]) + "%'"
							If w2 < Len(aDocsInf)
								cQrySE1 += " OR "
							ElseIf w2 > 1 .And. w2 == Len(aDocsInf) // Ultimo
								cQrySE1 += ") "
							EndIf
						Next
						cQrySE1 += " AND "
					EndIf
				EndIf
			EndIf
			cQrySE1 += "D_E_L_E_T_ = ' '"											// Nao apagado
			If Select("QRYSE1") > 0
				QRYSE1->(DbCloseArea())
			EndIf
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE1),"QRYSE1",.F.,.T.)
			Count To nRecsSE1
			If nRecsSE1 > 0 // Registros encontrados
				QRYSE1->(DbGotop())
				aCompars := {}
				While QRYSE1->(!EOF())
					SE1->(DbGoto( QRYSE1->R_E_C_N_O_ )) // Posiciono no SE1
					SA1->(DbSeek(_cFilSA1 + SE1->E1_CLIENTE + SE1->E1_LOJA)) // Posiciono SA1 tambem
					//If nRecsSE1 >= 1 // Tem mais de 1 na query...
					//             {              01,             02,              03,            04,            05,             06,           07,,,             10,,,,,,,,,,           20 }
					//             {         Emissao,     Vencimento,     Vencto Real,  Valor Titulo,  Saldo Aberto,  Nome Reduzido, Razao Social,,,      Recno SE1,,,,,,,,,, Localizacoes }
					aAdd(aCompars, { SE1->E1_EMISSAO, SE1->E1_VENCTO, SE1->E1_VENCREA, SE1->E1_VALOR, SE1->E1_SALDO, SE1->E1_NOMCLI, SA1->A1_NOME,,, SE1->(Recno()),,,,,,,,,,            0 })
					//Else // Exato
					//	cStaReg := "310=Registro localizado (precisao '10')"
					//	aAdd(aFound, SE1->(Recno()))
					//EndIf
					QRYSE1->(DbSkip())
				End
				If Len(aCompars) > 0 // Tem mais de 1 registro (comparacoes)
					/*
					aAdd(aChecks, { "aCompars[w4,01] <= _aCls01[ nP01DatPgt ]",						.F. }) // Data de pagamento
					aAdd(aChecks, { "aCompars[w4,02] <= aCompars[w4,02]",							.F. }) // Vencimento de acordo (nao vencido)
					aAdd(aChecks, { "aCompars[w4,03] <= aCompars[w4,03]",							.F. }) // Vencimento Real de acordo (nao vencido)
					aAdd(aChecks, { "aCompars[w4,04] == aCompars[w4,05]",							.F. }) // Valor igual ao saldo (aberto)
					aAdd(aChecks, { "AllTrim(Upper(aCompars[w4,06])) $ Upper(_aCls01[nP01Histor])", .F. }) // Nome do Fornecedor confere com historico
					*/
aSort(aCompars,,, {|x,y|, x[01] < y[01] }) // Ordenacao pela maior emissao
// Cada um dos SE1 localizados faco as comparacoes
For w4 := 1 To Len(aCompars)
	aEVal(aChecks, {|x|, x[02] := .F. }) // Reseto os .T. todos para .F.
	For w5 := 1 To Len(aChecks) // Faco as conferencias
		If &(aChecks[w5,01]) // .T.=De acordo .F.=Nao de acordo
			aChecks[w5,02] := .T.
			aCompars[w4,20] += aChecks[w5,03] // Incremento pontuacao de acordos conforme o nivel de precisao em aChecks
		EndIf
	Next
Next
aSort(aCompars,,, {|x,y|, x[20] > y[20] }) // Ordeno pelo que tem mais de acordos
If aCompars[01,20] > 0 // Alguma coisa de acordo
	cStaReg := "3" + StrZero(aCompars[01,20],02) + "=Registro localizado (precisao '" + StrZero(aCompars[01,20],02) + "')"
	aAdd(aFound, aCompars[01,10]) // Recno do SE1 q mais se aproxima
Else // Sem precisao
	cStaReg := "403=Registro localizado mas sem precisao"
	aAdd(aFound, 0) // Nada parecido
EndIf
EndIf
If aTail(aFound) > 0 // Achou SE1... vejo se ja esta baixado ou nao
	SE1->(DbGoto( aTail(aFound) )) // Posiciono no SE1
	SA1->(DbSeek(_cFilSA1 + SE1->E1_CLIENTE + SE1->E1_LOJA)) // Posiciono SA1 tambem
	If SE1->E1_SALDO == 0 // Ja totalmente baixado
		cStaReg := "501=Titulo ja foi totalmente baixado (" + cStaReg + ")"
	ElseIf SE1->E1_SALDO <> Abs(nVlrProc) // Ja tem baixas
		cStaReg := "401=Titulo nao tem saldo correto para a baixa (" + cStaReg + ")"
	EndIf
EndIf
Else // Nao achou nada na query SE1
	cStaReg := "402=Registro nao localizado (query)"
	aAdd(aFound, 0) // Por enquanto 0
EndIf
Else
	cStaReg := "403=Registro nao localizado (documento nao identificado)"
	aAdd(aFound, 0) // Por enquanto 0
EndIf
Else // Sem valor identificado (receber)
	cStaReg := "402=Registro nao localizado (query)"
	aAdd(aFound, 0) // Por enquanto 0
EndIf
Else // Nao tem valor, nao tem como achar

	If UPPER(SubStr(_aCls01[2],1,7))=="CREDITO"
		cStaReg := "3"
		aAdd(aFound, 4) // Recno do SE1 q mais se aproxima
	ElseIf  UPPER(SubStr(_aCls01[2],1,5))=="JUROS"
	    	cStaReg := "3"
		   aAdd(aFound, 4) // Recno do SE1 q mais se aproxima
	Else
		cStaReg := "401=Registro nao localizado (valor nao identificado)"
		aAdd(aFound, 0) // Por enquanto 0
	Endif
EndIf
Return cStaReg

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ StImp031 ∫Autor ≥Jonathan Schmidt Alves ∫Data ≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa as baixas localizadas.                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StImp031()
Local nRecsProc := 0
Local dDataFin := GetMv("MV_DATAFIN")
AEVal(oGetD1:aCols, {|x|, Iif(x[nP01StaPrc] == "03", nRecsProc++, Nil) })	// Contador de registros a processar
If nRecsProc > 0 // Registros a processar
	If (nFind := ASCan(oGetD1:aCols, {|x|, x[nP01StaPrc] == "03" .And. x[nP01DatPgt] < dDataFin })) > 0 // Algum registro Marcado para Processamento e Com Data Antes do MV_DATAFIN
		MsgStop("Periodo financeiro esta fechado (MV_DATAFIN)!" + Chr(13) + Chr(10) + ;
		"Verifique a liberacao do periodo e tente novamente!" + Chr(13) + Chr(10) + ;
		"Data Fechamento: " + DtoC(dDataFin) + Chr(13) + Chr(10) + ;
		"Data Pagamento: " + oGetD1:aCols[nFind,nP01DatPgt],"IntFin31")
	Else // Prossegue com as baixas
		cMotBaixa := Left(cGetMotBxa,3)						// Motivo da Baixa			E5_MOTBX
		cBcoBaixa := cGetCodBco								// Banco					E5_BANCO
		cAgeBaixa := cGetCodAge								// Agencia					E5_AGENCIA
		cConBaixa := cGetNumCon								// Numero da Conta			E5_NUMCON
		DbSelectArea("SA6")
		SA6->(DbSetOrder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
		If SA6->(DbSeek(_cFilSA6 + cBcoBaixa + cAgeBaixa + cConBaixa))
			If u_AskYesNo(2500,"ConfBxas","Confirma processamento das baixas?","","","","Cancelar","UPDINFORMATION")
				u_AskYesNo(3500,"Processando baixas","Baixas receber...","Processando...","","","","NOTE",.T.,.F.,{|| ConfBxas(nRecsProc) })
			EndIf
		Else // Banco nao encontrado (SA6)
			MsgStop("Banco/Agencia/Conta nao encontrados no cadastro (SA6)!" + Chr(13) + Chr(10) + ;
			"Banco/Agencia/Conta: " + cBcoBaixa + "/" + cAgeBaixa + "/" + cConBaixa,"IntFin31")
		EndIf
	EndIf
EndIf
Return

Static Function ConfBxas(nRecsProc)
Local _w
Local w5
Local aBaixa := {}
Local _nDif  := 0
Local nOpc := 3 // 3=Inclusao

_oMeter:nTotal := nRecsProc
For w5 := 1 To Len(oGetD1:aCols) // Rodo nos registros

     _nDif := 0
	If oGetD1:aCols[ w5, nP01StaPrc ] == "03"   // "03"=Processar
		SE1->(DbGoto(aFound[ w5 ])) // Posiciono nos titulos a receber
		++nCurrent
		For _w := 1 To 3
			u_AtuAsk09(nCurrent,"Processando baixas... " + cValToChar(nCurrent) + " / " + cValToChar(nRecsProc),"Baixas receber... " + SE1->E1_PREFIXO + "/" + SE1->E1_NUM, "Processando... " + SE1->E1_NOMCLI, "",80,"PROCESSA")
		Next
		dDatBaixa := oGetD1:aCols[w5,nP01DatPgt]			// Data Baixa				E5_DATA
		dDatCredi := oGetD1:aCols[w5,nP01DatPgt]			// Data Disponivel			E5_DTDISPO
		cHisBaixa := FTAcento(oGetD1:aCols[w5,nP01Histor])	// Historico Baixa			E5_HISTOR
		nVlrPagto := oGetD1:aCols[w5,nP01VlrMov]			// Valor Pagamento			E5_VALOR
		nVlrJuros := oGetD1:aCols[w5,nP01VlJuro]			// Valor Juros				E5_VLJUROS
		nVlrDesco := oGetD1:aCols[w5,nP01VlDesc]			// Valor Desconto			E5_VLDESCO
		cNumTit   := oGetD1:aCols[w5,aRelacio[9,02]]        // Num Titulo               E5_NUMERO
		cParTit   := oGetD1:aCols[w5,aRelacio[10,02]]        // Parcela                 E5_PARCELA
		_nPago    := oGetD1:aCols[w5,aRelacio[5,02]]
		_cCred    :=  oGetD1:aCols[w5,aRelacio[11,01]]


	    SE1->(DbSetorder(1))
		If SE1->(DbSeek(xFilial("SE1")+oGetD1:aCols[w5,9]+StrZero(Val(oGetD1:aCols[w5,aRelacio[9,02]]),9)+oGetD1:aCols[w5,aRelacio[10,02]]))
                 If SE1->E1_SALDO < _nPago .And. nVlrJuros <= 0
                    _nDif := _nPago-SE1->E1_SALDO
					_nPago := SE1->E1_SALDO
				 Endif
		Endif


		If  _nDif > 0 .And. UPPER(SubStr(oGetD1:aCols[w5,2],1,7))<>"CREDITO" .And. UPPER(SubStr(oGetD1:aCols[w5,2],1,5))<>"JUROS"

		 DbSelectArea("SE1")
		 DbSetOrder(1)
		If !DbSeek(xFilial("SE1")+Space(3)+oGetD1:aCols[w5,3]+Space(3)+"RA ")
        
		  aTitulo := { { "E1_PREFIXO",    SE1->E1_PREFIXO,                          Nil },; // Fixo                 Ex: "THO"
                     { "E1_NUM",             SE1->E1_NUM,                          Nil },; // Numero do titulo     Ex: "000476398"
                     { "E1_PARCELA",         '',                          Nil },; // Parcela do titulo    Ex: "AAA"
                     { "E1_TIPO",            'RA',                          Nil },; // Tipo                 Ex: "NF "
                     { "E1_CLIENTE",         SE1->E1_CLIENTE,                          Nil },; // Codigo do Cliente    Ex: "069785"
                     { "E1_LOJA",            SE1->E1_LOJA,                          Nil },; // Loja do Cliente      Ex: "01"
                     { "E1_EMISSAO",         dDatBaixa,                          Nil },; // Emissao do Titulo    Ex: 
                     { "E1_EMIS1",           dDatBaixa,                          Nil },; // Emissao do Titulo    Ex: 
                     { "E1_VENCTO",          dDatBaixa,                          Nil },; // Vencimento           Ex:
                     { "E1_VENCREA",         dDatBaixa,              Nil },; // Vencimento Real      Ex: 
                     { "E1_MOEDA",           01,                          Nil },; // Moeda Estrangeira    Ex: 2=Dolar 4=Euro
                     { "E1_TXMOEDA",         1,                          Nil },; // Taxa Moeda           Ex: 5.3
                     { "E1_VALOR",            _nDif,                          Nil },; // Valor do Titulo      Ex: 144
                     { "E1_VLCRUZ",           _nDif, Nil },; // Valor Cruzado        Ex: 
                     { "E1_NATUREZ",         '23502',                          Nil },; // Natureza             Ex: "10102     "
					 { "CBCOAUTO"    , "745"             , NIL },;
                     { "CAGEAUTO", "001"           , NIL },;
                    { "CCTAAUTO"    , "090019242"        , NIL },;
                     { "E1_HIST",            "Pagamento a maior",                          Nil } } //,; // Historico            Ex: "Thomson "

					 Pergunte("FIN040",.F.)
                     Mv_Par01 := 2                  // Mostra Lancamento Contabil       1=Sim 2=Nao
                     Mv_Par03 := 2                   // Contabiliza On-Line              1=Sim 2=Nao

                    lMsErroAuto := .F.
                    lExibeLanc := .T.
                    lOnline := .T.
                    MsExecAuto({|x,y|, FINA040(x,y) }, aTitulo, nOpc) // ,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao
                    
					If lMsErroAuto // Falha
                                                    ConOut("Depositos autom·ticos: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha!")
                                                    cMsg01 := "Falha no ExecAuto (FINA040)"
                                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                    MostraErro()
                                                   // Exit
					Endif

		Endif
		elseIf UPPER(SubStr(oGetD1:aCols[w5,2],1,7))=="CREDITO"

                      DbSelectArea("SE1")
					  DbSetOrder(1)
			If !DbSeek(xFilial("SE1")+Space(3)+oGetD1:aCols[w5,3]+Space(3)+"RA ")

					  aTitulo := { { "E1_PREFIXO",    Space(3),                          Nil },; // Fixo                 Ex: "THO"
                     { "E1_NUM",             oGetD1:aCols[w5,3],                          Nil },; // Numero do titulo     Ex: "000476398"
                     { "E1_PARCELA",         '',                          Nil },; // Parcela do titulo    Ex: "AAA"
                     { "E1_TIPO",            'RA',                          Nil },; // Tipo                 Ex: "NF "
                     { "E1_CLIENTE",         StrZero(Val(oGetD1:aCols[w5,6]),6),                          Nil },; // Codigo do Cliente    Ex: "069785"
                     { "E1_LOJA",            "01",                          Nil },; // Loja do Cliente      Ex: "01"
                     { "E1_EMISSAO",         dDatBaixa,                          Nil },; // Emissao do Titulo    Ex: 
                     { "E1_EMIS1",           dDatBaixa,                          Nil },; // Emissao do Titulo    Ex: 
                     { "E1_VENCTO",          dDatBaixa,                          Nil },; // Vencimento           Ex:
                     { "E1_VENCREA",         dDatBaixa,              Nil },; // Vencimento Real      Ex: 
                     { "E1_MOEDA",           01,                          Nil },; // Moeda Estrangeira    Ex: 2=Dolar 4=Euro
                     { "E1_TXMOEDA",         1,                          Nil },; // Taxa Moeda           Ex: 5.3
                     { "E1_VALOR",            oGetD1:aCols[w5,5],                          Nil },; // Valor do Titulo      Ex: 144
                     { "E1_VLCRUZ",           oGetD1:aCols[w5,5], Nil },; // Valor Cruzado        Ex: 
                     { "E1_NATUREZ",         '23502',                          Nil },; // Natureza             Ex: "10102     "
					 { "CBCOAUTO"    , "745"             , NIL },;
                     { "CAGEAUTO", "001"           , NIL },;
                    { "CCTAAUTO"    , "090019242"        , NIL },;
                     { "E1_HIST",            "Credito antecipado",                          Nil } } //,; // Historico            Ex: "Thomson "

					 Pergunte("FIN040",.F.)
                     Mv_Par01 := 2                  // Mostra Lancamento Contabil       1=Sim 2=Nao
                     Mv_Par03 := 2                   // Contabiliza On-Line              1=Sim 2=Nao

                    lMsErroAuto := .F.
                    lExibeLanc := .T.
                    lOnline := .T.
                    MsExecAuto({|x,y|, FINA040(x,y) }, aTitulo, nOpc) // ,, /*aDadosBco*/ Nil, lExibeLanc, lOnline) // 3=Inclusao 4=Alteracao 5=Exclusao
                    
					If lMsErroAuto // Falha
                                                    ConOut("Depositos autom·ticos: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha!")
                                                    cMsg01 := "Falha no ExecAuto (FINA040)"
                                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                    MostraErro()
                                                   // Exit
                   Endif
                   
				   If !lMsErroAuto
				   oGetD1:aCols[w5,nP01StaPrc] := "05" // 05=Ja Processados
			       oGetD1:aCols[w5,nP01StaReg] := "502=Titulo gerado! " + "(" + oGetD1:aCols[w5,nP01StaReg] + ")"
				   	oGetD1:Refresh()
				   Endif

			Endif
		
		elseIf UPPER(SubStr(oGetD1:aCols[w5,2],1,5))=="JUROS"

		        lMsErroAuto := .F.
                lExibeLanc := .T.
                lOnline := .T.

		        aTitulo  := { {"E5_DATA" ,dDatBaixa ,Nil},;
                            {"E5_MOEDA" ,"01" ,Nil},;
                            {"E5_VALOR" ,oGetD1:aCols[w5,5] ,Nil},;
                            {"E5_NATUREZ" ,"10501" ,Nil},;
							{"E5_BANCO" ,"745" ,Nil},;
                            {"E5_AGENCIA" ,"001" ,Nil},;
                            {"E5_CONTA" ,"090019242" ,Nil},;
                            {"E5_HISTOR" ,"JUROS ANTECIPADO" ,Nil}}

               MSExecAuto({|x,y,z| FinA100(x,y,z)},0, aTitulo,4)

            If lMsErroAuto // Falha
                                                    ConOut("Depositos autom·ticos: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha!")
                                                    cMsg01 := "Falha no ExecAuto (FINA100)"
                                                    cMsg02 := "Contate o suporte Totvs apresentando esta mensagem!"
                                                    cMsg03 := "O titulo a pagar nao foi incluido no sistema!"
                                                    cMsg04 := ""
                                                    lRet := .F.
                                                    MostraErro()
                                                   // Exit
            Endif

			 If !lMsErroAuto
				   oGetD1:aCols[w5,nP01StaPrc] := "05" // 05=Ja Processados
			       oGetD1:aCols[w5,nP01StaReg] := "502=Titulo gerado! " + "(" + oGetD1:aCols[w5,nP01StaReg] + ")"
				   	oGetD1:Refresh()
			 Endif
	
		Endif
		

        If UPPER(SubStr(oGetD1:aCols[w5,2],1,7))<>"CREDITO" .And. UPPER(SubStr(oGetD1:aCols[w5,2],1,5))<>"JUROS"

		SE1->(DbSetorder(1))
		SE1->(DbSeek(xFilial("SE1")+oGetD1:aCols[w5,9]+StrZero(Val(oGetD1:aCols[w5,aRelacio[9,02]]),9)+oGetD1:aCols[w5,aRelacio[10,02]]))


		
		// Montagem do ExecAuto
		aBaixa := {}
		aAdd(aBaixa, {"E1_FILIAL",		SE1->E1_FILIAL,		Nil})
		aAdd(aBaixa, {"E1_PREFIXO",		SE1->E1_PREFIXO,	Nil})
		aAdd(aBaixa, {"E1_NUM",			SE1->E1_NUM,		Nil})
		aAdd(aBaixa, {"E1_PARCELA",		SE1->E1_PARCELA,	Nil})
		aAdd(aBaixa, {"E1_TIPO",		SE1->E1_TIPO,		Nil})
		aAdd(aBaixa, {"E1_CLIENTE",		SE1->E1_CLIENTE,	Nil})
		aAdd(aBaixa, {"E1_LOJA",		SE1->E1_LOJA,		Nil})
		aAdd(aBaixa, {"AUTMOTBX",		cMotBaixa,			Nil})
		aAdd(aBaixa, {"AUTBANCO",		cBcoBaixa,			Nil})
		aAdd(aBaixa, {"AUTAGENCIA",		cAgeBaixa,			Nil})
		aAdd(aBaixa, {"AUTCONTA",		cConBaixa,			Nil})
		aAdd(aBaixa, {"AUTDTBAIXA",		dDatBaixa,			Nil})
		aAdd(aBaixa, {"AUTDTCREDITO",	dDatCredi,			Nil})
		aAdd(aBaixa, {"AUTHIST",		cHisBaixa,			Nil})
		aAdd(aBaixa, {"AUTVALREC",		_nPago  ,			Nil})
		aAdd(aBaixa, {"AUTJUROS",		nVlrJuros,			Nil})
		aAdd(aBaixa, {"AUTDESCONT",		nVlrDesco,			Nil})
		// Perguntas do processamento
		AcessaPerg("FIN070",.F.)	// Contabilizacao deve ser pelo LP 520
		Mv_Par01 := 2				// Mostra Lancamento Contabil?		1=Sim 2=Nao
		Mv_Par02 := 2				// Aglutina Lancamento Contabil?	1=Sim 2=Nao
		Mv_Par03 := 2				// Abate Desc/Decres Comissao?		1=Sim 2=Nao
		Mv_Par04 := 2				// Contabiliza On Line?				1=Sim 2=Nao
		Mv_Par05 := 2				// Cons.Juros/Acres Comissao?		1=Sim 2=Nao
		Mv_Par06 := 1				// Destacar Abatimentos?			1=Sim 2=Nao
		Mv_Par07 := 3				// Replica Rateio?					1=Inclusao 2=Baixa 3=Nao Replicar
		Mv_Par08 := 1				// Gera cheque p/ Adiantamento? 	1=Sim 2=Nao
		Mv_Par09 := 1				// Considera Retenc‰o Bancaria?		1=Sim 2=Nao
		Mv_Par10 := 2				// Utiliza banco anterior?			1=Sim 2=Nao
		// Preparacao
		lMsErroAuto := .F.
		dHldDtbase := dDatabase	// Hold do dDatabase
		dDatabase := dDatBaixa	// Database fica conforme data da baixa
		
		MsExecAuto({|x,y| FINA070(x,y)}, aBaixa, 3)
		
		dDatabase := dHldDtbase // Retorno dDatabase conforme era antes

		If lMsErroAuto // Erro ExecAuto
			For _w := 1 To 3
				u_AtuAsk09(nCurrent,"Processando baixas receber... " + cValToChar(nCurrent) + " / " + cValToChar(nRecsProc),"Baixas receber... " + SE1->E1_PREFIXO + "/" + SE1->E1_NUM + " Falha!", "Processando... " + SE1->E1_NOMCLI, "",80,"UPDERROR")
				Sleep(010)
			Next
			MostraErro()
			//Return .F.
		Else // Processamento com sucesso
			For _w := 1 To 3
				u_AtuAsk09(nCurrent,"Processando baixas receber... " + cValToChar(nCurrent) + " / " + cValToChar(nRecsProc),"Baixas receber... " + SE1->E1_PREFIXO + "/" + SE1->E1_NUM + " Sucesso!", "Processando... " + SE1->E1_NOMCLI, "",80,"OK")
				Sleep(050)
			Next
			oGetD1:aCols[w5,nP01StaPrc] := "05" // 05=Ja Processados
			oGetD1:aCols[w5,nP01StaReg] := "502=Titulo foi agora baixado! " + "(" + oGetD1:aCols[w5,nP01StaReg] + ")"
			// AtuRodap() // Atualizacao do Rodape
			oGetD1:Refresh()
		EndIf

       Endif
    Endif
Next
Return .T.

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadHder ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para recarregamento do Header.                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadHder()
Local w
aHdr01 := {}
For w := 1 To Len(aMolds01)
	aAdd(aHdr01, { aMolds01[w,03],							aMolds01[w,02],	aMolds01[w,07],						aMolds01[w,05], aMolds01[w,06], ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", aMolds01[w,04], "",		"R", aMolds01[w,09], "" }) // 01
Next
For w := 1 To Len(aMolds02)
	aAdd(aHdr01, { aMolds02[w,03],							aMolds02[w,02],	aMolds02[w,07],						aMolds02[w,05], aMolds02[w,06], ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", aMolds02[w,04], "",		"R", aMolds02[w,09], "" }) // 01
Next
Return aHdr01

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ ClearCls ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento do aCols conforme padrao do aHdr01 passado.   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ClearCls(aHdr01) // Criador de aCols
Local z
Local aCls := {}
Local _aCls := {}
For z := 1 To Len(aHdr01)
	If aHdr01[z,08] == "C" // Char
		aAdd(_aCls, Space(aHdr01[z,04]))
	ElseIf aHdr01[z,08] == "N" // Num
		aAdd(_aCls, 0)
	ElseIf aHdr01[z,08] == "D" // Data
		aAdd(_aCls, CtoD(""))
	EndIf
Next
aAdd(_aCls, .F.) // Nao apagado
aAdd(aCls, _aCls)
Return aCls

Static Function fAbrir()
Local cType := "Arquivo CSV. | *.CSV|"
Local cArqRet := cGetFile(cType, OemToAnsi("Selecione o arquivo para importar"),0,,.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY)
Return cArqRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ MarkRegs ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 28/04/2022 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Marca/Desmarca registros para processamento.               ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Status de Processamento:                                   ∫±±
±±∫          ≥ 02=Nao Processar                                           ∫±±
±±∫          ≥ 03=Processar                                               ∫±±
±±∫          ≥ 04=Nao Localizado                                          ∫±±
±±∫          ≥ 05=Ja Processado                                           ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function MarkRegs()
Local nLin := oGetD1:nAt
If nLin > 0 .And. nLin <= Len(oGetD1:aCols)

    If oGetD1:aCols[ nLin, nP01StaPrc ] == "02"  // 02=Nao Processar 03=Processar
		oGetD1:aCols[ nLin, nP01StaPrc ] := "03"
	ElseIf oGetD1:aCols[ nLin, nP01StaPrc ] == "03" // 03=Processar
		oGetD1:aCols[ nLin, nP01StaPrc ] := "02"
	EndIf
	oGetD1:Refresh()
EndIf
Return

Static Function VldBco01() // Validacao Banco
Local lRet := .T.
If Empty(cGetCodBco) // Sem banco preenchido
	cGetCodAge := Space(Len(cGetCodAge))
	cGetNumCon := Space(Len(cGetNumCon))
Else // Banco preenchido
	DbSelectArea("SA6")
	SA6->(DbSetOrder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
	If SA6->(!EOF()) .And. SA6->A6_COD <> cGetCodBco // Se ja estiver posicionado, respeito a posicao da consulta padrao
		If SA6->(DbSeek(_cFilSA6 + cGetCodBco)) // Tudo preenchido
			cGetCodAge := SA6->A6_AGENCIA
			cGetNumCon := SA6->A6_NUMCON
			cGetNomBco := SA6->A6_NOME
		Else
			MsgStop("Banco nao encontrado no cadastro (SA6)!" + Chr(13) + Chr(10) + ;
			"Banco: " + cGetCodBco,"VldBco01")
			lRet := .F.
		EndIf
	EndIf
EndIf
oGetCodAge:Refresh()
oGetNumCon:Refresh()
oGetNomBco:Refresh()
Return lRet

Static Function VldMot01() // Validacao Motivo da Baixa
Local lRet := .F.
If Left(cGetMotBxa,03) $ "NOR/DAC/DEB/"
	lRet := ASCan(aGetMotBxa, {|x|, Left(x,03) == Left(cGetMotBxa,03) }) > 0 // Ascan(aMotBx,{|e| AllTrim(Upper(cMotBx))==AllTrim(Upper(Substr(e,1,3)))})
EndIf
Return lRet
