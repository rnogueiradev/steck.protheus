#INCLUDE "STFINR03.CH"
#INCLUDE "PROTHEUS.CH"

Static lFWCodFil := .T.
Static cConta := NIL

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STFINR03  ³ Autor ³Marcel Borges Ferreira ³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Borderos para cobranca / pagamentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ STFINR03                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STFINR03()

Local oReport

oReport:=ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Marcel Borges Ferreira º Data ³  15/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das          º±±
±±º          ³ secoes que serao utilizadas.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 													                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 												                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local cReport 	:= "STFINR03" 				// Nome do relatorio
Local cDescri 	:= STR0001 +;       		//"Este programa tem a funçäo de emitir os borderos de cobrança"
						" " + STR0002   		//"ou pagamentos gerados pelo usuario."
Local cTitulo 	:= STR0006 					//"Emiss„o de Borderos de Pagamentos"
Local cPerg		:= "STFINR03"					// Nome do grupo de perguntas
Local cPictTit := PesqPict("SE2","E2_VALOR")

Pergunte("STFINR03",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01        	// Carteira (R/P)                          ³
//³ mv_par02        	// Numero do Bordero Inicial               ³
//³ mv_par03        	// Numero do Bordero Final                 ³
//³ mv_par04        	// considera filial                        ³
//³ mv_par05        	// da filial                               ³
//³ mv_par06        	// ate a filial                            ³
//³ mv_par07        	// moeda                                   ³
//³ mv_par08        	// imprime outras moedas                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri)
oReport:SETUSEGC(.F.)
oReport:HideHeader()		//Oculta o cabecalho do relatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01 -				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Cabecalho",("TRB","SA6"))
TRCell():New(oSection1, "A6_NOME","SA6",STR0024,,32,,)
oSection1:Cell("A6_NOME"):SetCellBreak()
TRCell():New(oSection1,"A6_AGENCIA","SA6",STR0016,,20,,)
TRCell():New(oSection1,"EA_NUMCON","SEA",STR0017,,15,,)
oSection1:Cell("EA_NUMCON"):SetCellBreak()
TRCell():New(oSection1,"A6_BAIRRO","SA6",,,15,,)
TRCell():New(oSection1,"A6_MUN","SA6",,,20,,)
TRCell():New(oSection1,"A6_EST","SA6",,,5,,)
oSection1:Cell("A6_EST"):SetCellBreak()
//TRCell():New(oSection1,STR0018,,"Texto 'Bordero nro'",,12,,{|| STR0018}) // BORDERO NRO
TRCell():New(oSection1,"EA_NUMBOR","SEA",STR0018,,15,,)
//TRCell():New(oSection1,STR0039,,"Texto 'Emitido em:'",,12,,{|| STR0039}) //
TRCell():New(oSection1,"EA_DATABOR","SEA",STR0039,PesqPict("SEA","EA_DATABOR"),10,,)
oSection1:Cell("EA_DATABOR"):SetCellBreak()
//RECEBER
TRCell():New(oSection1,STR0019,,"",,Len(STR0019),,{|| STR0019}) //"Solicitamos proceder o recebimento das duplicatas abaixo relacionadas"
oSection1:Cell(STR0019):SetCellBreak()
TRCell():New(oSection1,STR0020,,"",,Len(STR0020),,{|| STR0020}) //"CREDITANDO-NOS os valores correspondentes."
oSection1:Cell(STR0020):SetCellBreak()
//PAGAR
TRCell():New(oSection1,STR0021,,"",,Len(STR0021),,{|| STR0021}) //"Solicitamos proceder o pagamento das duplicatas abaixo relacionadas"
oSection1:Cell(STR0021):SetCellBreak()
TRCell():New(oSection1,STR0022,,"",,Len(STR0022),,{|| STR0022}) //"DEBITANDO-NOS os valores correspondentes."
oSection1:Cell(STR0022):SetCellBreak()
//Linhas complementares
TRCell():New(oSection1,"Linha complementar"+" 1",,"",,70,,)
oSection1:Cell("Linha complementar"+" 1"):SetCellBreak()
TRCell():New(oSection1,"Linha complementar"+" 2",,"",,70,,)
oSection1:Cell("Linha complementar"+" 2"):SetCellBreak()
TRCell():New(oSection1,"Linha complementar"+" 3",,"",,70,,)
oSection1:Cell("Linha complementar"+" 3"):SetCellBreak()

oSection1:SetCharSeparator("")
oSection1:SetLineStyle()
oSection1:SetHeaderSection(.F.)	//Nao imprime o cabecalho da secao
oSection1:SetPageBreak(.T.)		//Salta a pagina na quebra da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02 -              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Titulos",{"TRB","SA1","SA2","SE1","SE2"})
TRCell():New(oSection2,"EA_PREFIXO","SEA",STR0040,,15,,)//"NUM"
TRCell():New(oSection2,"EA_NUM","SEA",STR0041,,15,,)//DUPLIC
TRCell():New(oSection2,"EA_PARCELA","SEA",STR0042,,15,,)//P
//RECEBER
TRCell():New(oSection2,"E1_CLIENTE"	,"SE1",STR0043,,TamSx3("E1_CLIENTE"	)[1],,)//CODIGO
TRCell():New(oSection2,"A1_NOME"	,"SA1",STR0044,,TamSx3("A1_NOME"	)[1],,)//RAZAO SOCIAL
TRCell():New(oSection2,"E1_VENCTO"	,"SE1",STR0045,PesqPict("SE1","E1_VENCTO"),10,,)//VENCTO

// PAGAR
TRCell():New(oSection2,"E2_FORNECE"	,"SE2",STR0043,,TamSx3("E2_FORNECE"	)[1],,)//CODIGO
TRCell():New(oSection2,"E2_NOMFOR"	,"SA2",STR0044,,TamSx3("E2_NOMFOR"	)[1],,)//RAZAO SOCIAL
TRCell():New(oSection2,"E2_VENCTO"	,"SE2",STR0045,PesqPict("SE2","E2_VENCTO"),10,,)//VENCTO

TRCell():New(oSection2,"VALOR","",STR0046,cPictTit,TamSx3("E2_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT") //VALOR

oSection2:SetNoFilter({"TRB","SA1","SA2","SE1","SE2"})
oSection2:SetTotalText("")


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³+ ºAutor ³Marcel Borges Ferreira ºData ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o objeto oReport definido na funcao ReportDef.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                           º±±
±±º          ³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local nOpca := 0
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cAliasQry := "TRB"
Local cFilialSEA
Local cFilialSA6
Local cTableDel
Local cSE
Local cSA
Local cPrefixo
Local cNum
Local cParcela
Local cTipo
Local cCampos
Local cComple1 := Space(79)
Local cComple2 := Space(79)
Local cComple3 := Space(79)
Local cFil := ""
Local cLayoutSM0 := FWSM0Layout()
Local cFilialSA := ""
Local lGestao	 := Substr(cLayoutSM0,1,1) $ "E|U"
Local aSelFil	:= {}
Local cTmpSAFil := ""
Local cTmpSEAFil:= ""
Local cTmpSA6Fil:= ""
Local lAutomato := FunName() == "RPC"
Local cVldFilSA6 := ""
Local cVldFilSA := ""
Local cModoSEA	:= FWModeAccess("SEA",1)+FWModeAccess("SEA",2)+FWModeAccess("SEA",3)
Local cModoSA6	:= FWModeAccess("SA6",1)+FWModeAccess("SA6",2)+FWModeAccess("SA6",3)
Local cCondBco	:= ""

//Caso nao seja informada nenhuma moeda, considerar moeda 1
If mv_par07 == 0
	mv_par07 := 1
Endif	

If MV_PAR01==1
	oSection1:Cell(STR0021):Disable()
	oSection1:Cell(STR0022):Disable()
	oSection2:Cell("E2_FORNECE"):Disable()
    oSection2:Cell("E2_NOMFOR"):Disable()
	oSection2:Cell("E2_VENCTO"):Disable()
Else
	oSection1:Cell(STR0019):Disable()
	oSection1:Cell(STR0020):Disable()
	oSection2:Cell("E1_CLIENTE"):Disable()
	oSection2:Cell("A1_NOME"):Disable()
	oSection2:Cell("E1_VENCTO"):Disable()
EndIf

If !lAutomato

	If lGestao
		nRegSM0 := SM0->(Recno())
		aSelFil := FwSelectGC()
		SM0->(DbGoTo(nRegSM0))
		Asort(aSelFil)
	Else
		aSelFil := AdmGetFil(.F.,.T.,"SEA")
	EndIf

	If(Empty(aSelFil))
		aSelFil := {cFilAnt}
	EndIf


	DEFINE MSDIALOG oDlg FROM  92,70 TO 221,463 TITLE OemToAnsi(STR0009) PIXEL  //  "Mensagem Complementar"
	@ 09, 02 SAY STR0036 SIZE 24, 7 OF oDlg PIXEL  //"Linha 1"
	@ 24, 02 SAY STR0037 SIZE 25, 7 OF oDlg PIXEL  //"Linha 2"
	@ 38, 03 SAY STR0038 SIZE 25, 7 OF oDlg PIXEL  //"Linha 3"
	@ 07, 31 MSGET cComple1 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
	@ 21, 31 MSGET cComple2 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
	@ 36, 31 MSGET cComple3 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL

	DEFINE SBUTTON FROM 50, 139 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1,oDlg:End())
	DEFINE SBUTTON FROM 50, 167 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED
Else
	nOpca := 1
	aSelFil := {cFilAnt}
EndIf

If nOpca#1
	cComple1 := ""
	cComple2 := ""
	cComple3 := ""
EndIf

cAliasQry := GetNextAlias()
MakeSqlExpr(oReport:uParam)

oSection1:BeginQuery()

If MV_PAR04 == 1 //Considera Filial?
  	cFilialSEA := "EA_FILIAL " + GetRngFil( aSelFil, "SEA", .T., @cTmpSEAFil ) + " "
Else
	cFilialSEA := "EA_FILIAL = '" + xFilial("SEA") + "' "
EndIf

cFilialSEA := "%"+cFilialSEA+"%"

If MV_PAR04 == 1 //Considera Filial?
    cFilialSA6 := "A6_FILIAL " + GetRngFil( aSelFil, "SA6", .T., @cTmpSA6Fil ) + " "
Else
	cFilialSA6 := "A6_FILIAL = '" + xFilial("SA6")+"' "
EndIf

cVldFilSA6 := R170SETFIL("SA6")
cFilialSA6 := "%"+cFilialSA6+"%"
//Tratamento para banco compartilhado ou bordero compartilhado e banco exclusivo.
//Para não duplicar na query e imprimir titulos duplicados. 
If cModoSA6 = "CCC" .OR. (cModoSEA == "CCC" .And. cModoSA6 = "EEE")
	cCondBco := "%" + " SA6.R_E_C_N_O_ = 
	cCondBco += "(SELECT MIN(R_E_C_N_O_) FROM "+ RetSqlName("SA6") + " SA6B"
	cCondBco +=	"	WHERE SA6B.A6_COD = SEA.EA_PORTADO AND SA6B.A6_AGENCIA = SEA.EA_AGEDEP " 
	cCondBco +=	"	AND SA6B.A6_NUMCON = SEA.EA_NUMCON AND  SA6B.D_E_L_E_T_ = ' ' )" + "%""
Else
	cCondBco := "%" + " SA6.A6_COD = SEA.EA_PORTADO " + "%"
Endif

If MV_PAR01 ==1 //Carteira (R/P)
	cTableSE  := "%" + RetSqlName("SE1") + " SE1" + "%"
	cTableSA  := "%" + RetSqlName("SA1") + " SA1" + "%"
	cTableDel := "%" + "SE1.D_E_L_E_T_='' AND SA1.D_E_L_E_T_=''" + "%"
	cOrdem    := "%" + "E1_CLIENTE" + "%"
	cCond	  := "%" + "A1_COD = E1_CLIENTE" + "%"
	cLoja     := "%" + "A1_LOJA = E1_LOJA" + "%"
	cSE       := "E1_"
	cSA       := "%" + "A1_NOME" + "%"
	cCampos   := "%" + "E1_CLIENTE, E1_LOJA, E1_VENCTO, E1_MOEDA, SE1.R_E_C_N_O_ RECALIAS" + "%"
	cCart     := "R"
	
	If MV_PAR04 == 1
		cFilialSA := "A1_FILIAL  " + GetRngFil( aSelFil, "SA1", .T., @cTmpSAFil ) + " "
	Else
		cFilialSA := "A1_FILIAL = '" + xFilial("SA1") +"' "
	Endif		 

	cVldFilSA := R170SETFIL("SA1")
	cFilialSA := "%"+cFilialSA+"%"
Else
	cTableSE  := "%" + RetSqlName("SE2") + " SE2" + "%"
	cTableSA  := "%" + RetSqlName("SA2") + " SA2" + "%"
	cTableDel := "%" + "SE2.D_E_L_E_T_='' AND SA2.D_E_L_E_T_=''" + "%"
	cOrdem    := "%" + "E2_FORNECE" + "%"
	cCond     := "%" + "A2_COD = E2_FORNECE  AND E2_FORNECE = EA_FORNECE" + "%"
	cLoja     := "%" + "A2_LOJA = E2_LOJA AND E2_LOJA = EA_LOJA" + "%"
	cSE       := "E2_"
	cSA       := "%" + "E2_NOMFOR" + "%"
    cCampos   := "%" + "E2_FORNECE, E2_LOJA, E2_VENCTO, E2_MOEDA, SE2.R_E_C_N_O_ RECALIAS" + "%"
	cCart     := "P"
	
	If MV_PAR04 == 1
		cFilialSA := "A2_FILIAL  " + GetRngFil( aSelFil, "SA2", .T., @cTmpSAFil ) + " "
	Else
		cFilialSA := "A2_FILIAL = '" + xFilial("SA2")+"' "
	Endif		 
	cVldFilSA := R170SETFIL("SA2")
	cFilialSA := "%"+cFilialSA+"%"
EndIf

//Considerar Filial também para a filial de origem.
If mv_par04 == 1
	cFil := MV_PAR05
Else
	cFil := xFilial("SEA")
EndIf

cNumBor    := "%"+cSE+"NUMBOR"+"%"
cPrefixo   := "%"+cSE+"PREFIXO"+"%"
cNum 	   := "%"+cSE+"NUM"+"%"
cParcela   := "%"+cSE+"PARCELA"+"%"
cTipo	   := "%"+cSE+"TIPO"+"%"


BeginSql Alias cAliasQry

	SELECT DISTINCT EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_FILIAL, EA_PORTADO, EA_AGEDEP, EA_NUMCON, EA_DATABOR,   
		A6_COD, A6_NOME,A6_AGENCIA, A6_BAIRRO, A6_MUN, A6_EST, 
        %Exp:cSA%,
		%Exp:cCampos%

	FROM %table:SEA% SEA
		INNER JOIN %table:SA6% SA6
		ON %exp:cVldFilSA6% AND SA6.A6_COD = SEA.EA_PORTADO
			AND SA6.A6_AGENCIA = SEA.EA_AGEDEP AND SA6.A6_NUMCON = SEA.EA_NUMCON AND %Exp:cCondBco% 			
		INNER JOIN %Exp:cTableSE%
		ON  EA_NUMBOR = %Exp:cNumbor% AND EA_PREFIXO = %Exp:cPrefixo%  AND EA_NUM = %Exp:cNum% AND EA_PARCELA = %Exp:cParcela%
			AND EA_TIPO = %Exp:cTipo%
		INNER JOIN %Exp:cTableSA% 
		ON %exp:cVldFilSA% AND %Exp:cCond% AND %Exp:cLoja%
	WHERE %Exp:cFilialSEA% AND
		EA_NUMBOR BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% AND
		EA_CART = %Exp:cCart% AND
		SEA.%NotDel% AND SA6.%NotDel%	 AND %Exp:cTableDel%
	ORDER BY EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, %Exp:cOrdem%

EndSql

oSection1:EndQuery()
If mv_par01 == 1
	TRPosition():New(oSection2,"SA1",1,{|| xFilial("SA1")+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA})
Else
	TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2")+(cAliasQry)->E2_FORNECE+(cAliasQry)->E2_LOJA})
EndIf

oSection2:SetParentQuery( .T. )
oSection2:SetParentFilter({|cParam| (cAliasQry)->EA_NUMBOR = cParam},{|| (cAliasQry)->EA_NUMBOR})

oSection1:Cell("Linha complementar"+" 1"):SetBlock({||cComple1})
oSection1:Cell("Linha complementar"+" 2"):SetBlock({||cComple2})
oSection1:Cell("Linha complementar"+" 3"):SetBlock({||cComple3})
oSection2:Cell("VALOR"):SetBlock({||R170ValorTit((cAliasQry)->RECALIAS)})

//Totalizadores

If mv_par01==1
	oSection2:SetLineCondition({||(mv_par08 == 1 .OR. (mv_par08 == 2 .AND. (cAliasQRY)->E1_MOEDA = mv_par07))})
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"SUM", /*oBreak */,STR0047,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"COUNT", /*oBreak */,STR0049,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
Else
	oSection2:SetLineCondition({||(mv_par08 == 1 .OR. (mv_par08 == 2 .AND. (cAliasQRY)->E2_MOEDA = mv_par07))})
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"SUM", /*oBreak */,STR0048,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"COUNT", /*oBreak */,STR0049,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
EndIf

oReport:OnPageBreak({|| R170Header(oReport)})

If cConta != xFilial("SA6",(cAliasQRY)->EA_FILIAL)+(cAliasQRY)->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)
	SA6->(DbSetOrder(1))
	If SA6->(MsSeek(xFilial("SA6",(cAliasQRY)->EA_FILIAL)+(cAliasQRY)->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)))
		cConta := SA6->(A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON)
	Endif
Endif

oSection1:Print()

If Select("TRB") > 0
	TRB->(dbCloseArea())
	Ferase(cArq+GetDBExtension())      // Elimina arquivos de Trabalho
	Ferase(cArq+OrdBagExt())			  // Elimina arquivos de Trabalho
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³R170Header   ºAutor ³Marcel Borges Ferreira ºData ³   /  /      º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³Monta o cabecalho do relatorio.						                 º±±
±±º         ³ 						                                    	        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ 	                                                	           º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R170Header(oReport)
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cLogo			:= cStartPath + "LGRL" + SM0->M0_CODIGO + IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) + ".BMP" 	// Empresa+Filial

If !File( cLogo )
	cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + ".BMP"
endif

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:FatLine()
oReport:SkipLine()
oReport:SayBitmap (oReport:Row(),005,cLogo,291,057)
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:FatLine()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³R170ValorTit ºAutor ³Marcel Borges Ferreira ºData ³   /  /      º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³Calcula valor.       						                          º±±
±±º         ³ 						                                    	        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ 	                                                	           º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R170ValorTit(nAliasRec)
Local nValor := 0
Local nAbat  := 0
Local ndecs  := Msdecimais(mv_par07)
Local cBusca
Local aAux		 := {}
Local aValor	:= {}

If MV_PAR01==1
	//Posiciona SE1
	SE1->(dbGoto(nAliasRec))

	If(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ +IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
		nValor:= xMoeda(SE1->E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,mv_par07,,ndecs+1)
		If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
			nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
		EndIf
	Else				
		aValor:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA)
		nValor:= xMoeda(IIF(SE1->E1_SALDO == 0, Iif(aValor[2] != SE1->E1_DESCONT .Or. aValor[3] != SE1->E1_JUROS .Or. aValor[4] != SE1->E1_MULTA,SE1->E1_VALOR - aValor[2] + (aValor[3] + aValor[4]),IIF(SE1->E1_SDACRES == 0 .And. SE1->E1_ACRESC > 0, SE1->(E1_VALOR+E1_ACRESC)-SE1->E1_DESCONT, SE1->E1_VALOR-SE1->E1_DESCONT)), SE1->E1_SALDO)-SE1->E1_SDDECRE+SE1->E1_SDACRES,SE1->E1_MOEDA,mv_par07,,ndecs+1)				
	EndIf

  	// Template GEM
	If HasTemplate("LOT") .And. !Empty(SE1->E1_NCONTR)
		aAux := CMDtPrc( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_VENCTO )
		nValor += aAux[2] + aAux[3]
	EndIf

	cBusca := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
   SE1->(dbSeek(xFilial("SE1")+cBusca))
	While !Eof() .and. SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
		If SE1->E1_TIPO $ MVABATIM
			nAbat += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par07,,ndecs+1)
		Endif
		SE1->(dbSkip())
	EndDo

Else
	//Posiciona SE2
	SE2->(dbGoto(nAliasRec))
	If(cPaisLoc<>"BRA" .And. SE2->E2_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
		nValor:=xMoeda(SE2->E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE,SE2->E2_MOEDA,mv_par07,,ndecs+1)
		If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
			nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
		EndIf
	Else
		aValor:=Baixas(SE2->E2_NATUREZ,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_MOEDA,"P",SE2->E2_FORNECE,dDataBase,SE2->E2_LOJA)
		nValor:=xMoeda(IIF(SE2->E2_SALDO == 0, Iif(aValor[2] != SE2->E2_DESCONT .Or. aValor[3] != SE2->E2_JUROS .Or. aValor[4] != SE2->E2_MULTA,SE2->E2_VALOR - aValor[2] + (aValor[3] + aValor[4]),SE2->E2_VALOR-SE2->E2_DESCONT+SE2->E2_ACRESC), SE2->E2_SALDO)-SE2->E2_SDDECRE+SE2->E2_SDACRES,SE2->E2_MOEDA,mv_par07,,ndecs+1, SE2->E2_TXMOEDA ,&("SM2->M2_MOEDA" + STR(mv_par07,1)))
	EndIf

	cBusca := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
	SE2->(dbSeek(xFilial("SE2")+cBusca))
	While !Eof() .and. SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA) == cBusca
		If SE2->E2_TIPO $ MVABATIM .AND. SEA->EA_FORNECE==SE2->E2_FORNECE
			nAbat += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par07,,ndecs+1)
		Endif
		SE2->(dbSkip())
	EndDo
Endif

nValor := nValor-nAbat

Return nValor


//-------------------------------------
/*/{Protheus.doc}R170SETFIL
Monta trecho de validacao referente as 
filiais das tabelas SA6 e SA2/SA1 com a 
tabela SEA, para tratar compartilhamentos.

@author Vinicius do Prado
@since  12/09/2019
@version 12
/*/
//-------------------------------------
Static function R170SETFIL(cAlias as Character) as Character

	Local cValFil 	as Character
	Local nTamSEA 	as Numeric 
	Local nSE     	as Numeric
	Local nTamALIAS as Numeric
	Local nTamFilSEA as Numeric
	Local nTamFilAli as Numeric
	Local nTamanho	as Numeric
	Local cBDname   as Character
	Local cSubs     as Character

	nSE     := 1
	cValFil := ""
	nTamSEA := TAMSX3("EA_FILIAL")[1]
	nTamALIAS := Len(xFilial(cAlias))
	cBDname   := Upper( TCGetDB() )
	cSubs     := "SUBSTRING"
	nTamFilSEA := Len(Alltrim(xFilial("SEA")))
	nTamFilAli := Len(Alltrim(xFilial(cAlias)))
	
	If cAlias == "SA2"
		nSE := 2
	EndIf

	If cBDname $ "ORACLE|DB2|POSTGRES|INFORMIX"
		cSubs 	:= "SUBSTR"
	EndIf
	
	If nTamFilAli > nTamFilSEA
		nTamanho	:= nTamFilSEA
	Else
		nTamanho	:= nTamFilAli
	EndIf

	cValFil := "%"
	cValFil += "ISNULL("+cSubs + " ( SA"+cValToChar(nSE)+".A"+cValToChar(nSE)+"_FILIAL ,1 ,"+cValToChar(nTamanho)+" ),'" + Space(nTamSEA) + "')  = ISNULL("+ cSubs +  "( SEA.EA_FILORIG ,1 ," + cValToChar(nTamanho)+" ),'" + Space(nTamSEA) + "')"
	
	If cAlias == "SA6"
		cValFil := "%"
		cValFil  += "ISNULL("+cSubs + "  ( SA6.A6_FILIAL ,1 ," + cValToChar(nTamanho)+" ),'" + Space(nTamSEA) + "') = ISNULL(" + cSubs + "  ( SEA.EA_FILIAL ,1 ," + cValToChar(nTamanho)+" ),'" + Space(nTamSEA) + "') "
	EndIf
	
	cValFil += "%"

Return cValFil