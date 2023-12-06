#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchRec06 ºAutor ³Jonathan Schmidt Alves º Data ³09/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de acessos Steck.                                 º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchRec06()
Local _w1
Private nMsgPr := 2 // 2=AskYesNo
// Usuarios que alteram ZRC (Cadastro de Acessos TI)
Private cCodUsr := RetCodUsr()
Private cUsrZRC := SuperGetMv("ST_USRSZRC",.F.,"")  // "000000/000172" Administrador/Willian Borges
// Filiais
Private _cFilZRA := xFilial("ZRA")
Private _cFilZRB := xFilial("ZRB")
Private _cFilZRC := xFilial("ZRC")
Private _cFilSRA := xFilial("SRA")
Private _cFilSQB := xFilial("SQB")
Private _cFilSRJ := xFilial("SRJ")
// Variaveis objetos
Private oDlg01
Private cTitDlg := "SchRec06: Controle de Acessos"
Private oGetD1
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
Private oGetD2
Private aHdr02 := {}
Private aCls02 := {}
Private aFldsAlt02 := {}
// Objetos
Private oChkShwDem
Private oSayShwOrd
Private oCmbShwOrd
Private cCmbShwOrd := ""
Private aCmbShwOrd := {}
// Filtro Empresa
Private aCmbEmpFil := { "00=STECK SP + STECK AM", "01=STECK SP", "03=STECK AM" }
Private cCmbEmpFil := "00=STECK SP + STECK AM"
// Departamentos Considerar
Private aToolDepto := {}
Private oSayDepPsq
Private oGetDepPsq
Private cGetDepPsq := Space(09)
Private cGetDepDes := Space(30)
Private oSayDepShw
Private oGetDepShw
Private cGetDepShw := Space(200)
// Funcionarios Considerar
Private aToolFunci := {}
Private oSayFunPsq
Private oGetFunPsq
Private cGetFunPsq := Space(06)
Private oGetFunNom
Private cGetFunNom := Space(40)
Private oSayFunShw
Private oGetFunShw
Private cGetFunShw := Space(200)
// Variaveis linhas objetos
Private nLineZG1 := 1
Private nLineZG2 := 1
Private lChkShwDem := .T. // .T.=Apenas funcionarios ativos
Private aAllDepts := {} // Matriz dos departamentos
Private aGerDeptos := {} // Deptos Gerentes (desempenho)
Private aOrdShow := {} // Ordenacoes
// Cores GetDados 01
Private nClr111 := RGB(171,171,171)	// Cinza Padrao				*** 01: 
Private nClr112 := RGB(151,151,151) // Cinza Mais Escuro        *** 01: 
Private nClr121 := RGB(217,204,117) // Cinza Amarelado          *** 02: 
Private nClr122 := RGB(208,193,087) // Cinza Amarelado Escuro   *** 02: 
Private nClr131 := RGB(238,185,162) // Cinza Avermelhado Claro  *** 03: 
Private nClr132 := RGB(231,150,116) // Cinza Avermelhado Escuro *** 03: 
Private nClr141 := RGB(255,138,138) // Vermelho	Claro           *** 04: 
Private nClr142 := RGB(255,098,098) // Vermelho	Escuro          *** 04: 
Private nClr151 := RGB(165,250,160) // Verde Claro				*** 05: 
Private nClr152 := RGB(090,245,082) // Verde Escuro             *** 05: 
Private nClr161 := RGB(132,155,251) // Azul Claro				*** 06: 
Private nClr162 := RGB(109,140,245) // Azul Mais Escuro         *** 06: 
// Cores GetDados 02
Private nClr211 := RGB(171,171,171)	// Cinza Padrao				*** 01: 
Private nClr212 := RGB(151,151,151) // Cinza Mais Escuro        *** 01: 
Private nClr231 := RGB(238,185,162) // Cinza Avermelhado Claro  *** 03: 
Private nClr232 := RGB(231,150,116) // Cinza Avermelhado Escuro *** 03: 
// Cores Panels
Private nClrC21 := RGB(205,205,205)	// Cinza Mais Claro
Private nClrC22 := RGB(217,204,117) // Cinza Amarelado
Private nClrC23 := RGB(238,185,162) // Cinza Avermelhado Claro
Private nClrC24 := RGB(151,151,151) // Cinza Mais Escuro
// Montagem dos moldes (sem nMsgPr)
Private aMolds := MntMolds("ZRA", 0)
// Carregamento do aHeader (GetDados 01: a partir do aMolds)
For _w1 := 1 To Len(aMolds)
    //              {            Titulo,            Field ZRC,           Picture,           Tamanho,           Decimal,         Validacao,                      Reservado,              Tipo,            PesqF3,      Campo,            Option,           Ini Pad }
    aAdd(aHdr01,    { aMolds[_w1,01,01],    aMolds[_w1,03,06], aMolds[_w1,01,06], aMolds[_w1,01,04], aMolds[_w1,01,05], aMolds[_w1,01,10],				"€€€€€€€€€€€€€€ ", aMolds[_w1,01,03], aMolds[_w1,01,09],		"R", aMolds[_w1,01,07], aMolds[_w1,01,08] })  // 01
Next
// Preparacao das posicoes do Header 01
For _w1 := 1 To Len(aHdr01)
	&("nP01" + SubStr(aHdr01 [_w1,2],5,6)) := _w1
Next
// Carregamento do aHeader (GetDados 02)
aAdd(aHdr02,    { "Codigo",         "ZRC_CODIGO",                   "",                04,              00, "u_VlCodigo()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 01
aAdd(aHdr02,    { "Descricao",      "ZRC_DESCRI",                   "",                20,              00, "u_VlDescri()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 02
aAdd(aHdr02,    { "Ordem",          "ZRC_ORDFLD",                   "",                02,              00, "u_VlOrdFld()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 03
aAdd(aHdr02,    { "Tipo Campo",     "ZRC_TIPFLD",                   "",                01,              00, "u_VlTipFld()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "C=Char;D=Data;N=Numerico;",   "" })  // 04
aAdd(aHdr02,    { "Tamanho",        "ZRC_TAMFLD",                 "99",                02,              00, "u_VlTamFld()",         "€€€€€€€€€€€€€€ ",          "N",    "",                 "R", "",                            "" })  // 05
aAdd(aHdr02,    { "Decimal",        "ZRC_DECFLD",                 "99",                02,              00, "u_VlDecFld()",         "€€€€€€€€€€€€€€ ",          "N",    "",                 "R", "",                            "" })  // 06
aAdd(aHdr02,    { "Picture",        "ZRC_PICFLD",                   "",                20,              00, "u_VlPicFld()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 07
aAdd(aHdr02,    { "Opcoes",         "ZRC_OPTION",                   "",                50,              00, "u_VlOption()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 08
aAdd(aHdr02,    { "Inic Padrao",    "ZRC_INIPAD",                   "",                50,              00, "u_VlIniPad()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 09
aAdd(aHdr02,    { "Consulta F3",    "ZRC_PSQFLD",                   "",                06,              00, "u_VlPsqFld()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 10
aAdd(aHdr02,    { "Validacao",      "ZRC_VLDFLD",                   "",                50,              00, "u_VlVldFld()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "",                            "" })  // 11
aAdd(aHdr02,    { "Status",         "ZRC_STAACE",                   "",                02,              00, "u_VlStaAce()",         "€€€€€€€€€€€€€€ ",          "C",    "",                 "R", "01=Ativo;02=Inativo",     "'02'" })  // 12
// Preparacao das posicoes do Header 02
For _w1 := 1 To Len(aHdr02)
	&("nP02" + SubStr(aHdr02 [_w1,2],5,6)) := _w1
Next
// Montagem das Ordenacoes
aAdd(aOrdShow, { "01=Emp + Fil + Mat",          {|x,y|, x[nP01CodEmp] + x[nP01FilEmp] + x[nP01CodMat] < y[nP01CodEmp] + y[nP01FilEmp] + y[nP01CodMat] } })
aAdd(aOrdShow, { "02=Emp + Fil + Nome",         {|x,y|, x[nP01CodEmp] + x[nP01FilEmp] + x[nP01NomFun] < y[nP01CodEmp] + y[nP01FilEmp] + y[nP01NomFun] } })
aAdd(aOrdShow, { "03=Emp + Fil + Depto + Mat",  {|x,y|, x[nP01CodEmp] + x[nP01FilEmp] + x[nP01CodDep] + x[nP01CodMat] < y[nP01CodEmp] + y[nP01FilEmp] + y[nP01CodDep] + y[nP01CodMat] } })
aAdd(aOrdShow, { "04=Emp + Fil + Super",        {|x,y|, x[nP01CodEmp] + x[nP01FilEmp] + x[nP01CodSup] < y[nP01CodEmp] + y[nP01FilEmp] + y[nP01CodSup] } })
aAdd(aOrdShow, { "05=Emp + Fil + Geren",        {|x,y|, x[nP01CodEmp] + x[nP01FilEmp] + x[nP01CodGer] < y[nP01CodEmp] + y[nP01FilEmp] + y[nP01CodGer] } })
For _w1 := 1 To Len( aOrdShow )
    aAdd(aCmbShwOrd, aOrdShow[_w1,01])
Next
cCmbShwOrd := PadR(aOrdShow[01,01],30)
// Carregamento das empresas SM0
aAreaSM0 := GetArea()
SM0->(DbGotop())
While SM0->(!EOF())
    If SM0->M0_CODIGO $ "01/03/" // Empresas 01 e 03
        aAdd(aCmbEmpFil, SM0->M0_CODIGO + "/" + SM0->M0_CODFIL + " " + Upper(RTrim(SM0->M0_FILIAL)))
    EndIf
    SM0->(DbSkip())
End
RestArea(aAreaSM0)
// Usuario com permissao para alterar o ZRC
If cCodUsr $ cUsrZRC
    aFldsAlt02 := { "ZRC_CODIGO", "ZRC_ORDFLD", "ZRC_DESCRI", "ZRC_TIPFLD", "ZRC_TAMFLD", "ZRC_DECFLD", "ZRC_PICFLD", "ZRC_OPTION", "ZRC_INIPAD", "ZRC_PSQFLD", "ZRC_VLDFLD", "ZRC_STAACE" }
EndIf
// Abertura das tabelas
DbSelectArea("ZRA") // Funcionarios Customizados
ZRA->(DbSetOrder(1)) // ZRA_FILIAL + ZRA_CODEMP + ZRA_FILEMP + ZRA_CODMAT
DbSelectArea("ZRB") // Acessos Customizados
ZRB->(DbSetOrder(1)) // ZRB_FILIAL + ZRB_CODEMP + ZRB_FILEMP + ZRB_CODMAT + ZRB_CODACE
DbSelectArea("ZRC") // Cadastro de Acessos
ZRC->(DbSetOrder(1)) // ZRC_FILIAL + ZRC_CODIGO
DbSelectArea("SRA") // Funcionarios
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT + RA_NOME
DbSelectArea("SQB") // Departamentos
SQB->(DbSetOrder(1)) // QB_FILIAL + QB_DEPTO + QB_DESCRIC
DbSelectArea("SRJ") // Funcoes
SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
If nMsgPr == 2 // 2=AskYesNo // PrepDads( nMsgPr, lReload, lChkShwDem, cGetDepShw, lLoadZRC )
    u_AskYesNo(3500,"Processando","Carregando...","","","","","PROCESSA",.T.,.F.,{|| PrepDads( nMsgPr, .T., lChkShwDem, Nil, .T. ) })
Else // Sem interface
    PrepDads( nMsgPr, .T., lChkShwDem, Nil, .T. )
EndIf
SetKey(VK_F10, {|| GeraEx00( nMsgPr ) }) // Atalho Gera Excel
DEFINE MSDIALOG oDlg01 FROM 050,165 TO 766,1242 TITLE cTitDlg Pixel
// Panel
oPnlTop	:= TPanel():New(030,000,,oDlg01,,,,,nClrC21,542,040,.F.,.F.) // Top
oPnlGd1	:= TPanel():New(070,000,,oDlg01,,,,,nClrC23,542,185,.F.,.F.) // GetDados 01
oPnlGd2	:= TPanel():New(255,000,,oDlg01,,,,,nClrC21,542,100,.F.,.F.) // GetDados 02
oPnlBot	:= TPanel():New(350,000,,oDlg01,,,,,nClrC24,542,010,.F.,.F.) // Bottom
// Linha 01 Empresa filtro
@004,006 SAY	oSayEmpFil PROMPT "Empresa filtro:" SIZE 050,010 OF oPnlTop PIXEL
@002,045 MSCOMBOBOX oCmbEmpFil VAR cCmbEmpFil ITEMS aCmbEmpFil SIZE 155,011 OF oPnlTop PIXEL
oCmbEmpFil:bChange := {|| ChEmpFil( Nil, Nil, cCmbEmpFil ) }
@002,215 BUTTON "Filtrar" SIZE 050,010 PIXEL OF oPnlTop Action( u_AskYesNo(3500,"Processando","Carregando...","","","","","PROCESSA",.T.,.F.,{|| PrepDads( nMsgPr, .T., lChkShwDem, cGetDepShw ) })) // Filtrar
// Mostrar apenas funcionarios ativos
@004,290 CHECKBOX oChkShwDem VAR lChkShwDem PROMPT "Mostrar apenas funcionarios ativos" SIZE 100,008 OF oPnlTop PIXEL ON CHANGE u_AskYesNo(3500,"Processando","Carregando...","","","","","PROCESSA",.T.,.F.,{|| PrepDads( nMsgPr, .T., lChkShwDem, Nil, .F. ) })
oChkShwDem:cVariable := "lChkShwDem"
// Ordenacoes
@004,410 SAY	oSayShwOrd PROMPT "Ordem:" SIZE 050,010 OF oPnlTop PIXEL
@002,435 MSCOMBOBOX oCmbShwOrd VAR cCmbShwOrd ITEMS aCmbShwOrd SIZE 100,011 OF oPnlTop PIXEL
oCmbShwOrd:bChange := {|| u_AskYesNo(3500,"Processando","Carregando...","","","","","PROCESSA",.T.,.F.,{|| PrepDads( nMsgPr, .F., lChkShwDem, Nil, .F. ) }) }
// Linha 02 Departamentos
@017,006 SAY	oSayDepPsq PROMPT "Departamento:" SIZE 100,010 OF oPnlTop PIXEL
@015,045 MSGET	oGetDepPsq VAR cGetDepPsq SIZE 025,008 OF oPnlTop F3 "SQB" PIXEL Valid VldDep04() HASBUTTON
@015,095 MSGET	oGetDepDes VAR cGetDepDes SIZE 105,008 OF oPnlTop PIXEL READONLY
oGetDepPsq:lActive := .F.
oGetDepDes:lActive := .F.
// Linha 03 Departamentos Considerar
@030,006 SAY	oSayDepShw PROMPT "Considerar:" SIZE 100,010 OF oPnlTop PIXEL
@028,045 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTop Action(u_PrcElem4("Dep","Add","Shw")) // Adicionar Departamento
@028,055 MSGET	oGetDepShw VAR cGetDepShw SIZE 135,008 OF oPnlTop PIXEL READONLY
@028,190 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTop Action(u_PrcElem4("Dep","Rem","Shw")) // Remover Departamento
oGetDepShw:lActive := .F.
oGetDepShw:cToolTip := "Separar departamentos com ',' (virgula)"
// Linha 02 Funcionarios
@017,206 SAY	oSayFunPsq PROMPT "Funcionario:" SIZE 100,010 OF oPnlTop PIXEL
@015,245 MSGET	oGetFunPsq VAR cGetFunPsq SIZE 025,008 OF oPnlTop F3 "SRAAPT" PIXEL Valid VldFun04() HASBUTTON
@015,280 MSGET	oGetFunNom VAR cGetFunNom SIZE 120,008 OF oPnlTop PIXEL READONLY
oGetFunPsq:lActive := .F.
oGetFunNom:lActive := .F.
// Linha 03 Funcionarios Considerar
@030,206 SAY	oSayFunShw PROMPT "Considerar:" SIZE 100,010 OF oPnlTop PIXEL
@028,245 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTop Action(u_PrcElem4("Fun","Add","Shw")) // Adicionar Funcionario
@028,255 MSGET	oGetFunShw VAR cGetFunShw SIZE 135,008 OF oPnlTop PIXEL READONLY
@028,390 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTop Action(u_PrcElem4("Fun","Rem","Shw")) // Remover Funcionario
oGetFunShw:lActive := .F.
oGetFunShw:cToolTip := "Separar funcionarios com ',' (virgula)"
// GetDados 01: Funcionarios (ZRA)
oGetD1 := MsNewGetDados():New(002,002,182,536,GD_UPDATE,"AllwaysTrue()",,,aFldsAlt01,,,,,"AllwaysTrue()",oPnlGd1,aHdr01,aCls01)
oGetD1:oBrowse:lHScroll := .F.
oGetD1:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD1:aCols, oGetD1:nAt, aHdr01, 1) })
oGetD1:bChange := {|| nLineZG1 := oGetD1:nAt, oGetD1:Refresh(), ChEmpFil( oGetD1:aCols[ oGetD1:nAt, nP01CodEmp ], oGetD1:aCols[ oGetD1:nAt, nP01FilEmp ], Nil) }
oGetD1:bFieldOk := {||, u_VldGetD1() } // Validacao e gravacao de campos GetDados 01
// GetDados 02: Cadastro de Acessos (ZRC)
oGetD2 := MsNewGetDados():New(002,002,095,536,GD_INSERT + GD_UPDATE,"AllwaysTrue()",,,aFldsAlt02,,,,,"AllwaysTrue()",oPnlGd2,aHdr02,aCls02)
oGetD2:oBrowse:lHScroll := .F.
oGetD2:oBrowse:SetBlkBackColor({|| GetDXClr(oGetD2:aCols, oGetD2:nAt, aHdr02, 2) })
oGetD2:bChange := {|| nLineZG2 := oGetD2:nAt, oGetD2:Refresh() }
// Rodape (Atalhos)
@002,440 SAY	oSayAtaF10 PROMPT "F10 = Gera Planilha Excel" SIZE 120,010 OF oPnlBot PIXEL
ACTIVATE MSDIALOG oDlg01 CENTERED ON INIT EnchoiceBar(oDlg01, {|| Nil },{|| oDlg01:End()},, Nil)
SetKey(VK_F10, {|| Nil }) // Remove atalho Gera Excel
Return

Static Function GetDXClr(aCols, nLine, aHdrs, nObj) // Cores GetDados
Local nClr := nClr111 // Cinza Mais Claro
If nLine > 0 .And. nLine <= Len(aCols)
    If nObj == 1 // GetDados 01
        nClr := &("nClr" + cValToChar(nObj) + Iif(!Empty(aCols[nLine,nP01Demiss]),"3","5") + Iif( &("nLineZG" + cValToChar(nObj)) == nLine,"2","1"))
    Else // GetDados 02
        nClr := &("nClr" + cValToChar(nObj) + Iif(aCols[nLine,nP02StaAce] == "01","1","3") + Iif( &("nLineZG" + cValToChar(nObj)) == nLine,"2","1"))
    EndIf
EndIf
Return nClr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsDpAll ºAutor ³Jonathan Schmidt Alves  º Data 11/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de departamentos (SQB).             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsDpAll(cEmpresa) // Carregamento dos Departamentos da Empresa
SQB->(DbGotop())
While SQB->(!EOF())
	//              {  Empresa,   Filial Depto,    Cod  Depto,      Nome Depto, Cod CCusto, Depto Superior,          Chave,,     Filial Resp,  Matricula Resp }
	//              {       01,             02,            03,              04,         05,             06,             07,,              09,              10 }
	aAdd(aAllDepts, { cEmpresa, SQB->QB_FILIAL, SQB->QB_DEPTO, SQB->QB_DESCRIC, SQB->QB_CC, SQB->QB_DEPSUP, SQB->QB_KEYINI,, SQB->QB_FILRESP, SQB->QB_MATRESP })
	SQB->(DbSkip())
End
Return aAllDepts

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsGrMat ºAutor ³Jonathan Schmidt Alves º Data ³12/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtencao do gerente do funcionario conforme hierarquia de  º±±
±±º          ³ departamentos (SQB).                                       º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cEmpSRA: Empresa do funcionario no SRA                     º±±
±±º          ³ cFilSQB: Filial do cadastro de departamentos SQB           º±±
±±º          ³ cDepSRA: Departamento do funcionario no SRA                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsGrMat(cEmpSRA, cFilSQB, cDepSRA)
Local nIni := 0
Local cDeptos := ""
Local aGeren := { Space(06), Space(20) }
If (nFnd := ASCan(aGerDeptos, {|x|, cDepSRA $ x[03] .And. x[04] == cEmpSRA })) > 0
    aGeren := aGerDeptos[ nFnd ]
Else // Ainda nao tenho
    While (nIni := ASCan(aAllDepts, {|x|, x[01] + x[02] + x[03] == cEmpSRA + cFilSQB + cDepSRA }, nIni + 1, Nil)) > 0
        cDeptos += cDepSRA + "/" // Incluo o departamento
        cDepSRA := aAllDepts[nIni,06] // Departamento superior
        If cDepSRA == "000000030" // Se esse departamento ja obtenho o Gerente
            SRA->(DbSeek( aAllDepts[nIni,09] + aAllDepts[nIni,10] ))
            aGeren := { SRA->RA_MAT, SRA->RA_NOME }
            aAdd(aGerDeptos, { SRA->RA_MAT, SRA->RA_NOME, cDeptos, cEmpSRA })
        EndIf
    End
EndIf
Return aGeren

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsSpMat ºAutor ³Jonathan Schmidt Alves º Data ³12/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega o nome do gerente na empresa/filial conforme.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsSpMat(cEmpSRA, cFilSRA, cMatSRA)
Local cNomSup := Space(20)
If cEmpAnt == cEmpSRA // Mesma empresa
    SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
    If SRA->(DbSeek(cFilSRA + cMatSRA))
        cNomSup := SRA->RA_NOME
    EndIf
Else // Empresa diferente
    _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SRA","SQB","SRJ","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
    _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
    u_UPDEMPFIL(cEmpSRA, cFilSRA, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
    SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
    If SRA->(DbSeek(cFilSRA + cMatSRA))
        cNomSup := SRA->RA_NOME
    EndIf
EndIf
Return cNomSup

Static Function ChEmpFil(cEmpFil, cCodFil, cCmbEmpFil) // Change Empresa
Default cCodFil := "01"
If cCmbEmpFil <> Nil
    If SubStr(cCmbEmpFil,3,1) == "/" // Ambas empresas ou Grupo de Empresas (so pra filtrar)
        cEmpFil := Left(cCmbEmpFil,2)
        cCodFil := SubStr(cCmbEmpFil,4,2)
    Else // Limpo e desativo (Todas as Empresas ou um Grupo de Empresas)
        cGetDepPsq := Space(09)
        cGetFunPsq := Space(06)
        cGetDepDes := Space(30)
        oGetDepDes:Refresh()
        cGetFunNom := Space(40)
        oGetFunNom:Refresh()
    EndIf
    aObjects := { "oGetDepPsq", "oGetFunPsq" }
    aEval(aObjects, {|x|, &(x):lActive := SubStr(cCmbEmpFil,3,1) == "/", &(x):Refresh() })
EndIf
If cEmpFil <> Nil .And. cEmpAnt + cFilAnt <> cEmpFil + cCodFil // Esta mudando empresa
    _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SRA","SQB","SRJ","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
    _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
    u_UPDEMPFIL(cEmpFil, cCodFil, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
    _cFilSRA := xFilial("SRA")
    _cFilSQB := xFilial("SQB")
    _cFilSRJ := xFilial("SRJ")
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrepDads ºAutor ³Jonathan Schmidt Alvesº Data ³ 10/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preparacao dos dados.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PrepDads(nMsgPr, lReload, lChkShwDem, cGetDepShw, lLoadZRC)
Default cGetDepShw := "" // Filtros Departamentos
If lReload // .T.=Recarregar registros
    aCls01 := LoadRegs(nMsgPr, lChkShwDem, cGetDepShw) // Carregamento do ZRA
EndIf
// Ordenacao conforme
aSort(aCls01,,, aOrdShow[ Val(Left(cCmbShwOrd,2)), 02 ])
If lLoadZRC // .T.=Carrega ZRC (Cadastros Acessos TI)
    ZRC->(DbSetOrder(1)) // ZRC_FILIAL + ZRC_CODIGO
    ZRC->(DbGotop())
    While ZRC->(!EOF())
        //           {              01,              02,              03,              04,              05,              06,              07,              08,              09,              10,              11,              12, .F. }
        aAdd(aCls02, { ZRC->ZRC_CODIGO, ZRC->ZRC_DESCRI, ZRC->ZRC_ORDFLD, ZRC->ZRC_TIPFLD, ZRC->ZRC_TAMFLD, ZRC->ZRC_DECFLD, ZRC->ZRC_PICFLD, ZRC->ZRC_OPTION, ZRC->ZRC_INIPAD, ZRC->ZRC_PSQFLD, ZRC->ZRC_VLDFLD, ZRC->ZRC_STAACE, .F. })
        ZRC->(DbSkip())
    End
    aSort(aCls02,,, {|x,y|, x[03] < y[03] }) // Ordenacao pela Ordem (ZRC_ORDFLD)
EndIf
If Type("oGetD1") == "O"
    oGetD1:aCols := aClone(aCls01)
    oGetD1:Refresh()
EndIf
Return

User Function VlCodigo() // Validacao Codigo ZRC
Local lRet := .T.
Local _w1
Local cReadVar := ReadVar()
If !Empty(oGetD2:aCols[ oGetD2:nAt, nP02Codigo ]) // Ja gravou
    u_AskYesNo(2500,"VlCodigo","Codigo ja esta gravado (ZRC)!","Codigos nao podem ser alterados!","Codigo: " + oGetD2:aCols[ oGetD1:nAt, nP02Codigo ], "", "", "UPDERROR")
    lRet := .F.
Else // Ainda nao gravou
    For _w1 := 1 To Len(oGetD2:aCols)
        If _w1 <> oGetD2:nAt .And. &(cReadVar) == oGetD2:aCols[ _w1, nP02Codigo ] // Codigo repetido
            u_AskYesNo(2500,"VlCodigo","Codigo ja existe no cadastro (ZRC)!","Verifique o codigo preenchido e tente novamente!","Codigo: " + oGetD2:aCols[ _w1, nP02Codigo ], "", "", "UPDERROR")
            lRet := .F.
            Exit
        EndIf
    Next
EndIf
If Len(AllTrim(&(cReadVar))) <> 4 // Tamanho invalido
    u_AskYesNo(2500,"VlCodigo","Codigo preenchido com tamanho invalido (ZRC)!","Verifique o codigo preenchido e tente novamente!","Codigo: " + &(cReadVar), "", "", "UPDERROR")
    lRet := .F.
EndIf
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlDescri() // Validacao Descricao ZRC
Local lRet := .T.
Local _w1
Local cReadVar := ReadVar()
For _w1 := 1 To Len(oGetD2:aCols)
    If _w1 <> oGetD2:nAt .And. &(cReadVar) == oGetD2:aCols[ _w1, nP02Descri ] // Descricao repetida
        u_AskYesNo(2500,"VlDescri","Descricao ja existe no cadastro (ZRC)!","Verifique a descricao preenchido e tente novamente!","Descricao: " + oGetD2:aCols[ _w1, nP02Descri ], "", "", "UPDERROR")
        lRet := .F.
        Exit
    EndIf
Next
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlOrdFld() // Validacao Ordem Field ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
If Empty( &(cReadVar) ) // Ordem nao preenchida
    u_AskYesNo(2500,"VlOrdFld","Ordem nao preenchida (ZRC)!","Verifique a ordem da informacao preenchida e tente novamente!","", "", "", "UPDERROR")
    lRet := .F.
ElseIf Len( AllTrim( oGetD2:aCols[ oGetD2:nAt, nP02OrdFld ] )) <> 2 // Tamanho da Ordem invalido
    u_AskYesNo(2500,"VlOrdFld","Ordem nao preenchida com tamanho correto (ZRC)!","Verifique a ordem da informacao preenchida e tente novamente!","", "", "", "UPDERROR")
    lRet := .F.
ElseIf Val(oGetD2:aCols[ oGetD2:nAt, nP02OrdFld ]) <= 0 // Ordem menor ou igual a zero
    u_AskYesNo(2500,"VlOrdFld","Ordem nao preenchida corretamente (ZRC)!","Verifique a ordem da informacao preenchida e tente novamente!","", "", "", "UPDERROR")
    lRet := .F.
EndIf
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlTipFld() // Validacao Tipo Field ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
If Empty( &(cReadVar) ) // Tipo nao preenchido
    u_AskYesNo(2500,"VlTipFld","Tipo nao preenchido (ZRC)!","Verifique o tipo da informacao preenchido e tente novamente!","", "", "", "UPDERROR")
    lRet := .F.
ElseIf oGetD2:aCols[ oGetD2:nAt, nP02DecFld ] > 0 // Decimal maior que zero
    oGetD2:aCols[ oGetD2:nAt, nP02DecFld ] := 0
    oGetD2:Refresh()
EndIf
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlTamFld() // Validacao Tamanho Field ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
If &(cReadVar) <= 0 .Or. &(cReadVar) > 40 // Tamanho invalido (minimo 01 maximo 40)
    u_AskYesNo(2500,"VlTipFld","Tamanho invalido (ZRC)!","Verifique o tamanho da informacao preenchido e tente novamente!","Tamanho minimo/maximo: 01/40", "", "", "UPDERROR")
    lRet := .F.
EndIf
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlDecFld() // Validacao Tamanho Decimal ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
If oGetD2:aCols[ oGetD2:nAt, nP02TipFld ] <> "N" .And. &(cReadVar) > 0 // Decimal invalido
    u_AskYesNo(2500,"VlDecFld","Tamanho decimal invalido para o tipo (ZRC)!","Verifique o tipo e o tamanho decimal da informacao preenchido e tente novamente!","", "", "", "UPDERROR")
    lRet := .F.
EndIf
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlPicFld() // Validacao Picture ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlOption() // Validacao Option ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlIniPad() // Validacao Inic Padrao ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlPsqFld() // Validacao Pesq F3 ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlVldFld() // Validacao Valid Field ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

User Function VlStaAce() // Validacao Status Acesso ZRC
Local lRet := .T.
Local cReadVar := ReadVar()
lRet := GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Return lRet

Static Function GrvCdZRC(lRet, cReadVar) // Valido, gravo imediatamente
Local _w1
Local cCodigo := Space(04)
If lRet // .T.=Valido
    If cReadVar <> "M->ZRC_STAACE" // Se nao for alteracao no ZRC_STAACE
        If oGetD2:aCols[ oGetD2:nAt, nP02StaAce ] == "01" // "01"=Ativo
            u_AskYesNo(2500,"GrvCdZRC","Configuracoes so podem ser alteradas em registros com status '02'=Inativo!","Verifique o status do registro preenchido e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        EndIf
    ElseIf &(cReadVar) == "01" // "01"=Ativo
        // Validacao das colunas (Informacoes Obrigatorias)
        If Empty( oGetD2:aCols[ oGetD2:nAt, nP02Codigo ]) // Codigo nao preenchido
            u_AskYesNo(2500,"GrvCdZRC","Codigo do Acesso Ti nao preenchido!","Verifique o codigo do registro preenchido e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        ElseIf Empty(oGetD2:aCols[ oGetD2:nAt, nP02Descri ])
            u_AskYesNo(2500,"GrvCdZRC","Descricao do Acesso Ti nao preenchida!","Verifique a descricao do registro preenchido e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        ElseIf Empty(oGetD2:aCols[ oGetD2:nAt, nP02TipFld ])
            u_AskYesNo(2500,"GrvCdZRC","Tipo do campo de Acesso Ti nao preenchido!","Verifique o tipo do campo do registro preenchido e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        ElseIf Empty(oGetD2:aCols[ oGetD2:nAt, nP02TamFld ])
            u_AskYesNo(2500,"GrvCdZRC","Tamanho do campo de Acesso Ti nao preenchido!","Verifique o tamanho do campo do registro preenchido e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        ElseIf oGetD2:aCols[ oGetD2:nAt, nP02TipFld ] <> "N" .And. oGetD2:aCols[ oGetD2:nAt, nP02DecFld ] > 0 // Decimais em campo nao numerico
            u_AskYesNo(2500,"GrvCdZRC","Tamanho decimal do campo de Acesso Ti invalido!","Verifique o tipo do campo e qtde decimais e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        ElseIf oGetD2:aCols[ oGetD2:nAt, nP02TipFld ] <> "C" .And. !Empty(oGetD2:aCols[ oGetD2:nAt, nP02Option ]) // Option preenchido e nao eh char
            u_AskYesNo(2500,"GrvCdZRC","Opcoes do campo de Acesso Ti invalido!","Verifique o tipo do campo e as opcoes e tente novamente!","", "", "", "UPDERROR")
            lRet := .F.
        Else
            For _w1 := 1 To Len( oGetD2:aCols )
                If _w1 <> oGetD1:nAt // Linha diferente
                    If oGetD2:aCols[ _w1, nP02OrdFld ] == oGetD1:aCols[ oGetD1:nAt, nP02OrdFld ] // Ordem repetida
                        u_AskYesNo(2500,"GrvCdZRC","Ordem de Apresentacao esta repetida na linha " + cValToChar(_w1) + "!","Verifique as ordens preenchidas e tente novamente!","", "", "", "UPDERROR")
                        lRet := .F.
                    EndIf
                EndIf
            Next
        EndIf
    EndIf
    If lRet // .T.=Ainda valido
        If !Empty( oGetD2:aCols[ oGetD2:nAt, nP02Codigo ] )
            cCodigo := oGetD2:aCols[ oGetD2:nAt, nP02Codigo ]
        ElseIf cReadVar == "M->ZRC_CODIGO"
            cCodigo := &(cReadVar)
        EndIf
        If !Empty( cCodigo )
            RecLock("ZRC", ZRC->(!DbSeek(_cFilZRC + cCodigo )))
            For _w1 := 1 To Len( aHdr02 )
                &("ZRC->" + aHdr02[ _w1, 02 ]) := oGetD2:aCols[ oGetD2:nAt, _w1 ]
            Next
            &("ZRC->" + StrTran(cReadVar,"M->","")) := &(cReadVar)
            ZRC->(MsUnlock())
        EndIf
    EndIf
EndIf
Return lRet

User Function VldGetD1() // Validacao e gravacao ZRB de dados GetDados 01 (gravacao imediata ZRB)
Local lRet := .T.
Local xGrvDado := Nil
Local cReadVar := ReadVar()
Local nRecZRA := oGetD1:aCols[ oGetD1:nAt, nP01RecZRA ]
If nRecZRA > 0 // Recno ZRA
    ZRA->(DbGoto( nRecZRA ))
    If ZRA->(!EOF()) // ZRA Posicionado
        ZRB->(DbSetOrder(1)) // ZRB_FILIAL + ZRB_CODEMP + ZRB_FILEMP + ZRB_CODMAT + ZRB_CODACE
        If ZRB->(DbSeek(_cFilZRB + ZRA->ZRA_CODEMP + ZRA->ZRA_FILEMP + ZRA->ZRA_CODMAT + Right(cReadVar,4)))
            RecLock("ZRB",.F.)
        Else // Ainda nao tem ZRB, cria agora
            RecLock("ZRB",.T.)
            ZRB->ZRB_FILIAL := _cFilZRB
            ZRB->ZRB_CODEMP := ZRA->ZRA_CODEMP
            ZRB->ZRB_FILEMP := ZRA->ZRA_FILEMP
            ZRB->ZRB_CODMAT := ZRA->ZRA_CODMAT
            ZRB->ZRB_CODACE := Right(cReadVar,4)
        EndIf
        If ValType(&(cReadVar)) == "D" // Data
            xGrvDado := DtoC(&(cReadVar))
        ElseIf ValType(&(cReadVar)) == "N" // Numerico
            xGrvDado := cValToChar(&(cReadVar))
        Else // Char
            xGrvDado := &(cReadVar)
        EndIf
        ZRB->ZRB_ACESSO := xGrvDado // Gravo a informacao no ZRB
        ZRB->(MsUnlock())
    Else // ZRA nao localizado
        u_AskYesNo(2500,"VldGetD1","Gravacao nao pode ser realizada (ZRA nao encontrado)!","Consulte o suporte Totvs e apresente esta mensagem!","Campo: " + cReadVar, "", "", "UPDERROR")
        lRet := .F.
    EndIf
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MntMolds ºAutor ³Jonathan Schmidt Alvesº Data ³ 10/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem do layout de integracao                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ cTipRg: Tipo dos registros                                 º±±
±±º          ³         Exemplo: "ZRA"=Controle de Acessos TI              º±±
±±º          ³                                                            º±±
±±º          ³ nMsgPr: Mensagem de processamento                          º±±
±±º          ³         Exemplo: 2=AskYesNo                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MntMolds(cTipRg, nMsgPr)
Local _z1
Local aMolds := {}
Local nSortIni := 0
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Controle de Acessos TI)...", "", "", 80, "PROCESSA")
		Sleep(030)
	Next
EndIf
If cTipRg == "ZRA" // Controle de Acessos TI (ZRA)
    //           { { ########################## L A Y O U T  C L I E N T E ######################################################################### }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
    //           { { Nome do Campo,           Regras de Integridade    , Tip, Tam, Dec,                  Picture, Options, IniPad, PesqF3, Validacao }, { Variavel informacoes,		                                 Validacao pre-carregamento,                    		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao, Fld Gravacao } }
    //           { {                                                                                                                                 }, {                                                          antes de carregar a variavel,                                                                                                                                                                                   campos Tabelas/etc,                                    apos carregar a origem,                                            apos carregar a variavel,                         ,                 ,         na tabela de logs,,    pronto p gravacao }, {                                                                         antes de carregar a variavel,                                                               ,             apos carregar da origam,  apos carregar da origam,              } }
    //           { {        01,                                      02,  03,  04,  05,                       06,      07,     08,     09,        10 }, {                   01,                                                              02,                                                                                                                                                                                                   03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,           06 } }
    aAdd(aMolds, { { "Empresa",               "Codigo da Empresa"      , "C",  02,  00,                       "",      "",     "",     "",        "" }, {	               "_",                                                           ".T.",                                                                                                                                                                                    "ZRA->ZRA_CODEMP",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                           "PadR(aDado[01],15)",                               ".T.",                       "", "ZRB_CODEMP" } })
    aAdd(aMolds, { { "Filial",                "Codigo da Filial"       , "C",  02,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "ZRA->ZRA_FILEMP",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[02]))",                               ".T.",                       "", "ZRB_FILEMP" } })
    aAdd(aMolds, { { "Matricula",             "Matricula Funcionario"  , "C",  06,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "ZRA->ZRA_CODMAT",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                            "PadR(aDado[03],4)",                               ".T.",                       "", "ZRB_CODMAT" } })
    aAdd(aMolds, { { "Nome",                  "Descricao do Grupo"     , "C",  30,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                       "SRA->RA_NOME",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[04]))",                               ".T.",                       "", "ZRB_NOMFUN" } })
    aAdd(aMolds, { { "Admissao",              "Data Admissao"          , "D",  08,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "SRA->RA_ADMISSA",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                      "Upper(RTrim(aDado[05]))",                               ".T.",                       "", "ZRB_ADMISS" } })
    aAdd(aMolds, { { "Demissao",              "Data Demissao"          , "D",  08,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "SRA->RA_DEMISSA",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_DEMISS" } })

    // aAdd(aMolds, { { "Cod Depto",             "Codigo Departamento"    , "C",  09,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                      "SRA->RA_DEPTO",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_CODDEP" } })
    aAdd(aMolds, { { "Departamento",          "Descricao Departamento" , "C",  30,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                     "Iif(SQB->(!EOF()), SQB->QB_DESCRIC, Space(40))",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_DESDEP" } })
    
    // aAdd(aMolds, { { "Cod Funcao",            "Codigo da Funcao"       , "C",  05,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "SRA->RA_CODFUNC",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_CODFUN" } })
    aAdd(aMolds, { { "Funcao",                "Descricao da Funcao"    , "C",  20,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                        "Iif(SRJ->(!EOF()), SRJ->RJ_DESC, Space(20))",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_DESFUN" } })
    
    // aAdd(aMolds, { { "Cod Supervisor",        "Codigo do Supervisor"   , "C",  06,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                                                                                                                    "SRA->RA_XMATSUP",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_CODSUP" } })
    aAdd(aMolds, { { "Supervisor",            "Supervisor"             , "C",  20,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                   "Iif(!Empty(SRA->RA_XEMPSUP) .And. !Empty(SRA->RA_XFILSUP) .And. !Empty(SRA->RA_XMATSUP), LdsSpMat(SRA->RA_XEMPSUP, SRA->RA_XFILSUP, SRA->RA_XMATSUP), Space(20))",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_NOMSUP" } })
    
    // aAdd(aMolds, { { "Cod Gerente",           "Codigo do Gerente"      , "C",  06,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                                                                                    "Iif(!Empty(SQB->QB_DEPTO), (aGeren := LdsGrMat(ZRA->ZRA_CODEMP, SQB->QB_FILIAL, SQB->QB_DEPTO))[01], Space(06))",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_CODGER" } })
    aAdd(aMolds, { { "Gerente",               "Gerente"                , "C",  20,  00,                       "",      "",     "",     "",        "" }, {                  "_",                                                           ".T.",                          /*"Iif( !Empty(aTail(aResul[_n])), aGeren[02], Space(30))"*/ "Iif(!Empty(SQB->QB_DEPTO), (aGeren := LdsGrMat(ZRA->ZRA_CODEMP, SQB->QB_FILIAL, SQB->QB_DEPTO))[02], Space(30))",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRB_NOMGER" } })

    nSortIni := Len( aMolds ) + 1
    // Acessos
    ZRC->(DbGotop())
    While ZRC->(!EOF())
        If ZRC->ZRC_STAACE <> "02" // "02"=Inativo
            //           { { ########################## L A Y O U T  C L I E N T E ############################################################################################################################################################## }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P R O C E S S A M E N T O S   D E   M O N T A G E M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }, { %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYOUT CARREGAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% } }
            //           { { Nome do Campo                  ,  Regras de Integridade    ,             Tip,             Tam,             Dec,         Picture,         Options,          IniPad,          PesqF3,       Validacao,     Ordem Field }, { Variavel informacoes,		                                           Validacao pre-carregamento,               		                                                                                                                                                     Origem da informacao,                       Condicao para consideracao do campo,                                            Tratamento da informacao,    	       Aspas Duplas,        Reservado,      Field Gravacao Totvs,, Informacao resultado }, { Reservado,                                                                Validacao pre-carregamento,                                           Origem da informacao, Condicao para consideracao do campo, Tratamento da informacao,               Fld Gravacao } }
            //           { {                              01,                         02,              03,              04,              05,              06,              07,              08,              09,              10,              11 }, {                   01,                                                                         02,                                                                                                                                                                                             03,                                                        04,                                                                  05,                       06,               07,                        08,,                   10 }, {        01,                                                                                        02,                                                             03,                                  04,                       05,                         06 } }
            aAdd(aMolds, { { RTrim(Capital(ZRC->ZRC_DESCRI)),  ""                       , ZRC->ZRC_TIPFLD, ZRC->ZRC_TAMFLD, ZRC->ZRC_DECFLD, ZRC->ZRC_PICFLD, ZRC->ZRC_OPTION, ZRC->ZRC_INIPAD, ZRC->ZRC_PSQFLD, ZRC->ZRC_VLDFLD, ZRC->ZRC_ORDFLD }, {	              "_",                                                                      ".T.",                                       "Eval({|| (nFnd := ASCan(aAcUsr[_n], {|x|, x[01] == '" + ZRC->ZRC_CODIGO + "' })), Iif(nFnd > 0, aAcUsr[_n,nfnd,02],  xTpPad" + ZRC->ZRC_CODIGO + ") })",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                        "",                                                             "",                               ".T.",                       "", "ZRB_AC" + ZRC->ZRC_CODIGO } })
            aAdd(aFldsAlt01, "ZRB_AC" + ZRC->ZRC_CODIGO)
        EndIf
        ZRC->(DbSkip())
    End
    If Len( aMolds ) >= nSortIni // Dados ZRC carregados
        aSort( aMolds, nSortIni, Len( aMolds ), {|x,y|, x[01,11] < y[01,11] }) // Ordenacao pelo ZRC_ORDFLD
    EndIf

    aAdd(aMolds, { { "Recno ZRA",             "Recno ZRA"              , "N",  06,  00,                   "9999",      "",     "",     "",     ".F." }, {                  "_",                                                           ".T.",                                                                                                                                                                                     "ZRA->(Recno())",                                                     ".T.",                                                                  "",                    ".F.",              Nil,                        "",,                  Nil }, {       Nil,                                                                                     ".T.",                                             "Upper(aDado[06])",                               ".T.",                       "", "ZRC_RECZRA" } })
EndIf
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"01/03 Carregando...","Estrutura (Controle de Acessos TI)... Sucesso!", "", "", 80, "OK")
		Sleep(030)
	Next
EndIf
Return aMolds

Static Function LoadRegs(nMsgPr, lChkShwDem, cGetDepShw) // Carregamento da ZRA
Local _w1
Local _z1
Local cQry := ""
Local nRegsZRA := 0
Local cRegsZRA := ""
Local nProcZRA := 0
Local nFiltZRA := 0
Local nRecsSRA := 0
Local xAcesso
Local aRcTab := { { "ZRA", Array(0) }, { "SRA", Array(0) }, { "SQB", Array(0) }, { "SRJ", Array(0) } }
Local cHldCodEmp := cEmpAnt
Local cHldFilEmp := cFilAnt
Local nLastUpdate := Seconds()
Local cCndEmpZRA := "!Empty(ZRA->ZRA_CODEMP)"
Local cMsg02 := "Carregando funcionarios... "
Private aAcess := {}
Private aAcUsr := {}
// Parte 01: Sincronizacao da ZRA com a SRA010 e com a SRA030
For _w1 := 1 To 3 Step 2
    cQry := "SELECT RA_FILIAL, RA_MAT, RA_NOME, ZRA_CODEMP, ZRA_FILEMP, ZRA_CODMAT "
    cQry += "FROM SRA" + StrZero(_w1,2) + "0 SRA "
    cQry += "LEFT JOIN ZRA010 ZRA "
    cQry += "ON '" + StrZero(_w1,2) + "' = ZRA.ZRA_CODEMP AND SRA.RA_FILIAL + SRA.RA_MAT = ZRA.ZRA_FILEMP + ZRA.ZRA_CODMAT "
    cQry += "WHERE ZRA.ZRA_CODMAT IS NULL "
    cQry += "ORDER BY RA_FILIAL + RA_MAT "
    If Select("QRYSRA") > 0
        QRYSRA->(DbCloseArea())
    EndIf
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QRYSRA",.F.,.F.)
    Count To nRecsSRA
    If nRecsSRA > 0 // Registros para sincronizar
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"02/03 Carregando dados...","Sincronizando dados dos funcionarios (SRA x ZRA)...", "", "", 80, "REFRESH")
                Sleep(030)
            Next
        EndIf
        QRYSRA->(DbGotop())
        While QRYSRA->(!EOF())
            RecLock("ZRA",.T.)
            ZRA->ZRA_FILIAL := _cFilZRA                 // Filial
            ZRA->ZRA_CODEMP := StrZero(_w1,2)           // Codigo Empresa
            ZRA->ZRA_FILEMP := QRYSRA->RA_FILIAL        // Filial
            ZRA->ZRA_CODMAT := QRYSRA->RA_MAT           // Matricula
            ZRA->ZRA_CODSTA := "01"                     // Status
            ZRA->(MsUnlock())
            QRYSRA->(DbSkip())
        End
        If nMsgPr == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"02/03 Carregando dados...","Sincronizando dados dos funcionarios (SRA x ZRA)... Concluido!", "", "", 80, "OK")
                Sleep(030)
            Next
        EndIf
    EndIf
Next
// Parte 02: Carregamento da matriz base de acessos
_oMeter:nTotal := (nRegsZRA := ZRA->(RecCount()))
cRegsZRA := cValToChar(nRegsZRA)
If nMsgPr == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(nCurrent,"02/03 Carregando dados...","Carregando funcionarios...", "", "", 80, "PROCESSA")
		Sleep(030)
	Next
EndIf
DbSelectArea("ZRC")
ZRC->(DbSetOrder(1)) // ZRC_FILIAL + ZRC_CODIGO
ZRC->(DbGotop())
While ZRC->(!EOF())
    If ZRC->ZRC_STAACE <> "02" // "02"=Inativo
        If ZRC->ZRC_TIPFLD == "C"
            &("xTpPad" + ZRC->ZRC_CODIGO) := Space( ZRC->ZRC_TAMFLD )
        ElseIf ZRC->ZRC_TIPFLD == "D"
            &("xTpPad" + ZRC->ZRC_CODIGO) := CtoD("")
        ElseIf ZRC->ZRC_TIPFLD == "N"
            &("xTpPad" + ZRC->ZRC_CODIGO) := 0
        EndIf
        //           {              01,              02,              03,              04,              05,              06,              07,              08 }
        aAdd(aAcess, { ZRC->ZRC_CODIGO, ZRC->ZRC_ORDFLD, ZRC->ZRC_TIPFLD, ZRC->ZRC_TAMFLD, ZRC->ZRC_DECFLD, ZRC->ZRC_PICFLD, ZRC->ZRC_OPTION, ZRC->ZRC_INIPAD })
    EndIf
    ZRC->(DbSkip())
End
// Parte 03: Carregamento dos dados da ZRA
DbSelectArea("ZRA")
ZRA->(DbSetOrder(1)) // ZRA_FILIAL + ZRA_CODEMP + ZRA_FILEMP + ZRA_CODMAT
If Left(cCmbEmpFil,2) == "00" // "00"=Ambas Steck SP + Steck AM
    ZRA->(DbGotop())
    cCndEmpZRA := ".T."
    cMsg02 += "Grupos: 01=Steck SP + 03=Steck AM"
ElseIf SubStr(cCmbEmpFil,3,1) <> "/" // Grupo de Empresas "01" ou "03"
    ZRA->(DbSeek(_cFilZRA + Left(cCmbEmpFil,2) ))
    cCndEmpZRA := "ZRA->ZRA_CODEMP == '" + Left(cCmbEmpFil,2) + "'"
    cMsg02 += "Grupo: " + aCmbEmpFil[ oCmbEmpFil:nAt ]
Else // Empresa + Filial especifica
    ZRA->(DbSeek(_cFilZRA + Left(cCmbEmpFil,2) + SubStr(cCmbEmpFil,4,2)))
    cCndEmpZRA := "ZRA->ZRA_CODEMP == '" + Left(cCmbEmpFil,2) + "' .And. ZRA->ZRA_FILEMP == '" + SubStr(cCmbEmpFil,4,2) + "'"
    cMsg02 += "Empresa/Filial: " + aCmbEmpFil[ oCmbEmpFil:nAt ]
EndIf
While ZRA->(!EOF()) .And. &(cCndEmpZRA) // Empresa/Filial conforme
    nCurrent++
    nProcZRA++
    If cEmpAnt + cFilAnt <> ZRA->ZRA_CODEMP + ZRA->ZRA_FILEMP // Empresa + Filial diferente
        _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SRA","SQB","SRJ","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
        _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
        u_UPDEMPFIL(ZRA->ZRA_CODEMP, ZRA->ZRA_FILEMP, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
        _cFilSRA := xFilial("SRA")
        _cFilSQB := xFilial("SQB")
        _cFilSRJ := xFilial("SRJ")
        If ASCan(aAllDepts, {|x|, x[01] == cEmpAnt }) == 0 // Se ainda nao tenho nenhum departamento dessa empresa... carrego
            LdsDpAll(cEmpAnt)
        EndIf
    EndIf
    If SRA->(DbSeek(ZRA->ZRA_FILEMP + ZRA->ZRA_CODMAT))
        If !lChkShwDem .Or. Empty(SRA->RA_DEMISSA) // Mostrar ativos/demitidos ou nao esta demitido
            If Empty(cGetDepShw) .Or. ASCan(aToolDepto, {|x|, Left(x,12) == cEmpAnt + "/" + SRA->RA_DEPTO }) > 0 // Filtro Departamentos
                If Empty(cGetFunShw) .Or. ASCan(aToolFunci, {|x|, Left(x,12) == cEmpAnt + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT }) > 0 // Filtro Funcionarios
                    nFiltZRA++
                    aAdd(aRcTab[01,02], ZRA->(Recno()))     // Recno da ZRA
                    aAdd(aRcTab[02,02], SRA->(Recno()))     // Recno da SRA
                    If !Empty( SRA->RA_DEPTO ) .And. SQB->(DbSeek(_cFilSQB + SRA->RA_DEPTO))
                        aAdd(aRcTab[03,02], SQB->(Recno()))     // Recno da SQB
                    Else
                        aAdd(aRcTab[03,02], 0)                  // Recno da SQB (nao encontrado)
                    EndIf
                    If !Empty( SRA->RA_CODFUNC ) .And. SRJ->(DbSeek(_cFilSRJ + SRA->RA_CODFUNC))
                        aAdd(aRcTab[04,02], SRJ->(Recno()))     // Recno da SRJ
                    Else
                        aAdd(aRcTab[04,02], 0)                  // Recno da SRJ (nao encontrado)
                    EndIf
                    aAdd(aAcUsr, Array(0))                  // Matriz de Acessos
                    If ZRB->(DbSeek(_cFilZRB + ZRA->ZRA_CODEMP + ZRA->ZRA_FILEMP + ZRA->ZRA_CODMAT))
                        While ZRB->(!EOF()) .And. ZRB->ZRB_FILIAL + ZRB->ZRB_CODEMP + ZRB->ZRB_FILEMP + ZRB->ZRB_CODMAT == _cFilZRB + ZRA->ZRA_CODEMP + ZRA->ZRA_FILEMP + ZRA->ZRA_CODMAT
                            If (nFnd := ASCan( aAcess, {|x|, x[01] == ZRB->ZRB_CODACE })) > 0 // Acho o Codigo de Acesso
                                If aAcess[nFnd,02] == "C"
                                    xAcesso := PadR(ZRB->ZRB_ACESSO, aAcess[nFnd,04])
                                ElseIf aAcess[nFnd,03] == "D"
                                    xAcesso := CtoD( AllTrim(ZRB->ZRB_ACESSO) )
                                ElseIf aAcess[nFnd,03] == "N"
                                    xAcesso := Val( AllTrim(ZRB->ZRB_ACESSO) )
                                EndIf
                                //                               {              01,      02 }
                                aAdd(aAcUsr[Len(aRcTab[01,02])], { ZRB->ZRB_CODACE, xAcesso })
                            EndIf
                            ZRB->(DbSkip())
                        End
                    EndIf
                    // Inic Padroes para os acessos nao existentes na ZRB
                    For _w1 := 1 To Len(aAcess)
                        If !Empty(aAcess[ _w1, 08 ]) // Inic Padrao preenchido
                            If ASCan(aAcUsr[Len(aRcTab[01,02])], {|x|, x[01] == aAcess[ _w1, 01 ] }) == 0 // Nao tem nada nesse acesso
                                // Entao vamos colocar o Inic padrao
                                //                               {              01,                   02 }
                                aAdd(aAcUsr[Len(aRcTab[01,02])], { aAcess[_w1, 01], &( aAcess[ _w1,08 ]) })
                            EndIf
                        EndIf
                    Next
                EndIf
            EndIf
        EndIf
    EndIf
    If nMsgPr == 2 // 2=AskYesNo
        If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a última atualização da tela
            For _z1 := 1 To 4
                u_AtuAsk09(nCurrent,"02/03 Carregando dados...", cMsg02, "Filtrados/Avaliados/Total: " + cValToChar(nFiltZRA) + "/" + cValToChar(nProcZRA) + "/" + cRegsZRA, "", 80, "PROCESSA")
                Sleep(030)
            Next
            nLastUpdate := Seconds()
        EndIf
    EndIf
    ZRA->(DbSkip())
End
If nMsgPr == 2 // 2=AskYesNo
    For _z1 := 1 To 4
        u_AtuAsk09(nCurrent,"02/03 Carregando dados...", cMsg02 + " Concluido!", "Filtrados/Avaliados/Total: " + cValToChar(nFiltZRA) + "/" + cValToChar(nProcZRA) + "/" + cRegsZRA, "", 80, "OK")
        Sleep(080)
    Next
EndIf
// Parte 03: Carregamento dos dados
aResul := LoadDads(nMsgPr, aRcTab, aMolds)
aEVal(aResul, {|x|, aAdd(x, .F.) }) // Incluir o .F.
If cEmpAnt + cFilAnt <> cHldCodEmp + cHldFilEmp // Empresa + Filial diferente
    _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SRA","SQB","SRJ","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
    _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
    u_UPDEMPFIL(cHldCodEmp, cHldFilEmp, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
    _cFilSRA := xFilial("SRA")
    _cFilSQB := xFilial("SQB")
    _cFilSRJ := xFilial("SRJ")
EndIf
Return aResul

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LoadDads ºAutor ³Jonathan Schmidt Alvesº Data ³ 10/04/2021 º±±
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
Local _n2, _n
ConOut("")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Parametros recebidos:")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aRcTab: (matriz de registros para carregamento)")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aMolds: (matriz de moldes layout)")
If Len(aRcTab) > 0 // Recnos alimentados
	If nMsgPr == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent,"03/03 Apresentando...","Apresentando dados...", "", "", 80, "PROCESSA")
			Sleep(030)
		Next
	EndIf
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Avaliando dados para carregamento...")
    cTab := aRcTab[01,01]				// Tabela principal de posicionamento
    aAreaTab := (cTab)->(GetArea())
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Tabela Principal: " + cTab)
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Recnos para posicionamento: " + cValToChar(Len(aRcTab[01,02])))
    For _n := 1 To Len(aRcTab[01,02]) // Recnos para posicionamentos	(SB1/SD1,etc)
        (cTab)->(DbGoto( aRcTab[01,02,_n] )) // Posiciono tabela pincipal
        If cEmpAnt + cFilAnt <> ZRA->ZRA_CODEMP + ZRA->ZRA_FILEMP // Empresa + Filial diferente
            _aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SRA","SQB","SRJ","SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED"} // Array contendo os Alias a serem abertos na troca de Emp/Fil
            _aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
            u_UPDEMPFIL(ZRA->ZRA_CODEMP, ZRA->ZRA_FILEMP, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
            _cFilSQB := xFilial("SQB")
            _cFilSRJ := xFilial("SRJ")
        EndIf
        // Posicionamento das demais tabelas
        For _n2 := 2 To Len(aRcTab)
        	If aRcTab[_n2,02,_n] > 0 // Recno para posicionamento
        		(aRcTab[_n2,01])->(DbGoto( aRcTab[_n2,02,_n] ))
        	Else
        		(aRcTab[_n2,01])->(DbGoBottom())
        		(aRcTab[_n2,01])->(DbSkip()) // Deixo em EOF
        	EndIf
        Next
        If (cTab)->(!EOF())
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
        EndIf
    Next
	If nMsgPr == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(nCurrent,"03/03 Apresentando...","Apresentando dados... Sucesso!", "", "", 80, "OK")
			Sleep(030)
		Next
	EndIf
    RestArea(aAreaTab)
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros carregados: " + cValToChar(Len(aResul)))
EndIf
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("")
RestArea(aArea)
Return aResul

Static Function VldDep04() // Validacao do Departamento pesquisa
Local lRet := .T.
DbSelectArea("SQB")
SQB->(DbSetOrder(1)) // SQB_FILIAL + SQB_DEPTO
If !Empty(cGetDepPsq) // Departamento preenchido
	If SQB->(!DbSeek(_cFilSQB + cGetDepPsq))
		MsgStop("Departamento nao encontrado no cadastro (SQB)!" + Chr(13) + Chr(10) + ;
		"Departamento: " + cGetDepPsq + Chr(13) + Chr(10) + ;
		"Verifique o departamento e tente novamente!","VldDep04")
		lRet := .F.
	Else // Encontrado
		cGetDepDes := SQB->QB_DESCRIC
		oGetDepDes:Refresh()
	EndIf
Else // Departamento em branco
	cGetDepDes := Space(30)
	oGetDepDes:Refresh()
EndIf
Return lRet

Static Function VldFun04() // Validacao do Funcionario pesquisa
Local lRet := .T.
DbSelectArea("SRA")
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
If !Empty(cGetFunPsq) // Funcionario preenchido
	If SRA->(!DbSeek(_cFilSRA + cGetFunPsq))
		MsgStop("Funcionario nao encontrado no cadastro (SRA)!" + Chr(13) + Chr(10) + ;
		"Funcionario: " + cGetFunPsq + Chr(13) + Chr(10) + ;
		"Verifique o funcionario e tente novamente!","VldFun04")
		lRet := .F.
	Else // Encontrado
		cGetFunNom := SRA->RA_NOME
		oGetFunNom:Refresh()
	EndIf
Else // Funcionario em branco
	cGetFunNom := Space(40)
	oGetFunNom:Refresh()
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrcElem4 ºAutor ³ Jonathan Schmidt Alves ºData³ 12/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de processamento de campos filtro do Departamento.  º±±
±±º          ³ permitindo multiplos registros.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros:                                                º±±
±±º          ³ cFld: Field de processamento                               º±±
±±º          ³       Exemplos: Dep: Departamentos                         º±±
±±º          ³                 Prj: Projeto                               º±±
±±º          ³                 Ite: Item Contabil (Contrato)              º±±
±±º          ³                 Cli: Cliente                               º±±
±±º          ³                                                            º±±
±±º          ³ cPrc: Processamento                                        º±±
±±º          ³       Exemplos: Add: Adicao de elemento                    º±±
±±º          ³                 Rem: Remocao de elemento                   º±±
±±º          ³                                                            º±±
±±º          ³ cTip: Tipo de filtro                                       º±±
±±º          ³       Exemplos: Shw: Filtro a considerar                   º±±
±±º          ³                 Hde: Filtro a desconsiderar                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PrcElem4(cFld, cPrc, cTip)
Local y
Local cProc := "" // L=Limpeza geral P=Preenchido
Local _cGetDepPrc := ""
Local aGetDepPrc := {}
Local _cGetFunPrc := ""
Local aGetFunPrc := {}
Local cToolTip := ""
If cFld == "Dep" // Departamentos
	If Empty(cGetDepPsq) .And. cPrc == "Rem" // Departamento nao preenchido e eh uma Remocao.. limpeza geral do objeto
		If Empty(&("cGetDep" + cTip))
			MsgStop("Nao ha dados para limpeza dos departamentos para processamento!","PrcElem4")
		Else // Limpando... segue para limpeza geral
			cProc := "L"
			cGetDepPrc := "" // Limpo
		EndIf
	ElseIf Empty(cGetDepPsq) .And. cPrc == "Add" // Departamento nao preenchido e eh uma Adicao
		MsgStop("Departamento nao preenchido para inclusao!" + Chr(13) + Chr(10) + ;
		"Para incluir um departamento devera preencher o codigo na pesquisa acima!","PrcElem4")
	ElseIf !Empty(cGetDepPsq) // Departamento preenchido...
		cProc := "P" // Preenchido... segue normal
	EndIf
	If !Empty(cProc) // Iniciamos processamento...
		If cProc == "P" // Preenchido.. validar
			cProc := ""
			DbSelectArea("SQB")
			SQB->(DbSetOrder(1)) // QB_FILIAL + QB_DEPTO
			If !Empty(cGetDepPsq) .And. SQB->(!DbSeek(_cFilSQB + cGetDepPsq))
				MsgStop("Departamento nao encontrado no cadastro (SQB)!" + Chr(13) + Chr(10) + ;
				"Departamento: " + cGetDepPsq + Chr(13) + Chr(10) + ;
				"Verifique o departamento e tente novamente!","PrcElem4")
			Else // Departamento localizado
				_cGetDepPrc := &("cGetDep" + cTip)
				aGetDepPrc := Iif(!Empty(_cGetDepPrc), StrToKarr(_cGetDepPrc,","), {})
				For y := 1 To Len(aGetDepPrc)
					aGetDepPrc[y] := PadR(aGetDepPrc[y],12)
				Next
				If cPrc == "Add" // Adicionar
					If Len(aGetDepPrc) == 20 // Limite atingido
						MsgStop("Limite de Departamentos para processamento atingido!" + Chr(13) + Chr(10) + ;
						"Limite maximo de 20 Departamentos no mesmo processamento!","PrcElem4")
					Else // Limite ok...
						If Len(aGetDepPrc) > 0 .And. ASCan(aGetDepPrc, {|x|, Left(x,12) == Left(cCmbEmpFil,2) + "/" + SQB->QB_DEPTO }) > 0
							MsgStop("Departamento ja foi incluido neste processamento!" + Chr(13) + Chr(10) + ;
							"Departamento: " + SQB->QB_DEPTO + " " + SQB->QB_DESCRIC,"PrcElem4")
						Else // Considerando departamento entao...
							cProc := "K" // Processamento...
							cGetDepPrc := _cGetDepPrc // Empresa + Depto Atual
							cGetDepPrc := Iif(!Empty(cGetDepPrc), RTrim(cGetDepPrc) + ",", "") + cEmpAnt + "/" + RTrim(SQB->QB_DEPTO) // Atualizado
							aAdd(aGetDepPrc, cEmpAnt + "/" + SQB->QB_DEPTO) // Incluo na matriz
                            // Tooltips
                            aAdd(aToolDepto, cEmpAnt + "/" + SQB->QB_DEPTO + " " + RTrim(SQB->QB_DESCRIC))
						EndIf
					EndIf
				ElseIf cPrc == "Rem" // Remover
					If Len(aGetDepPrc) == 0 // Nao foram carregados departamentos
						MsgStop("Nao existe nenhum departamento carregado para remover!","PrcElem4")
					ElseIf (nPosR := ASCan(aGetDepPrc, {|x|, x == cEmpAnt + "/" + SQB->QB_DEPTO })) == 0 // Departamento nao encontrado
						MsgStop("Departamento nao encontrado para remover!" + Chr(13) + Chr(10) + ;
						"Empresa/Departamento: " + cEmpAnt + "/" + SQB->QB_DEPTO + " " + SQB->QB_DESCRIC,"PrcElem4")
					Else // Removendo departamento
						cProc := "K"
						aDel(aGetDepPrc, nPosR)
						aSize(aGetDepPrc, Len(aGetDepPrc) - 1)
                        // Tooltips
                        aDel(aToolDepto, nPosR)
                        aSize(aToolDepto, Len(aToolDepto) - 1)
						If Len(aGetDepPrc) > 0 // Ainda tem elementos
							cGetDepPrc := ""
							For y := 1 To Len(aGetDepPrc)
								cGetDepPrc += RTrim(aGetDepPrc[y]) + ","
							Next
							cGetDepPrc := Left(cGetDepPrc, Len(cGetDepPrc) - 1) // Removo virgula
						Else // Limpou tudo
							cGetDepPrc := ""
                            // Tooltips
                            aToolDepto := {}
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If cProc $ "L/K" // Processamento Validado "K" ou "L"=Limpeza geral... refresh
			If Len(aGetDepPrc) > 0
				cToolTip += "Departamentos " + Iif(cTip == "Shw", "considerados:","desconsiderados:") + Chr(13) + Chr(10)
                For y := 1 To Len(aToolDepto)
					cToolTip += aToolDepto[y] + Chr(13) + Chr(10)
				Next
				cToolTip += "Total: " + StrZero(Len(aGetDepPrc),2)
            Else // Limpou tudo
                aToolDepto := {}
			EndIf
			&("cGetDep" + cTip) := cGetDepPrc			// Atribuicao na variavel do objeto
			&("oGetDep" + cTip):cToolTip := cToolTip	// Atualizacao dos tooltips
			&("oGetDep" + cTip):Refresh()				// Refresh no objeto
		EndIf
	EndIf
	oGetDepPsq:SetFocus()
ElseIf cFld == "Fun" // Funcionarios
	If Empty(cGetFunPsq) .And. cPrc == "Rem" // Funcionario nao preenchido e eh uma Remocao.. limpeza geral do objeto
		If Empty(&("cGetFun" + cTip))
			MsgStop("Nao ha dados para limpeza dos funcionarios para processamento!","PrcElem4")
		Else // Limpando... segue para limpeza geral
			cProc := "L"
			cGetFunPrc := "" // Limpo
		EndIf
	ElseIf Empty(cGetFunPsq) .And. cPrc == "Add" // Funcionario nao preenchido e eh uma Adicao
		MsgStop("Funcionario nao preenchido para inclusao!" + Chr(13) + Chr(10) + ;
		"Para incluir um funcionario devera preencher o codigo na pesquisa acima!","PrcElem4")
	ElseIf !Empty(cGetFunPsq) // Departamento preenchido...
		cProc := "P" // Preenchido... segue normal
	EndIf
	If !Empty(cProc) // Iniciamos processamento...
		If cProc == "P" // Preenchido.. validar
			cProc := ""
			DbSelectArea("SRA")
			SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
			If !Empty(cGetFunPsq) .And. SRA->(!DbSeek(_cFilSRA + cGetFunPsq))
				MsgStop("Funcionario nao encontrado no cadastro (SRA)!" + Chr(13) + Chr(10) + ;
				"Funcionario: " + cGetFunPsq + Chr(13) + Chr(10) + ;
				"Verifique o departamento e tente novamente!","PrcElem4")
			Else // Funcionario localizado
				_cGetFunPrc := &("cGetFun" + cTip)
				aGetFunPrc := Iif(!Empty(_cGetFunPrc), StrToKarr(_cGetFunPrc,","), {})
				For y := 1 To Len(aGetFunPrc)
					aGetFunPrc[y] := PadR(aGetFunPrc[y],12)
				Next
				If cPrc == "Add" // Adicionar
					If Len(aGetFunPrc) == 20 // Limite atingido
						MsgStop("Limite de Funcionarios para processamento atingido!" + Chr(13) + Chr(10) + ;
						"Limite maximo de 20 Funcionarios no mesmo processamento!","PrcElem4")
					Else // Limite ok...
						If Len(aGetFunPrc) > 0 .And. ASCan(aGetFunPrc, {|x|, Left(x,12) == Left(cCmbEmpFil,2) + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT }) > 0
							MsgStop("Funcionario ja foi incluido neste processamento!" + Chr(13) + Chr(10) + ;
							"Funcionario: " + SRA->RA_MAT + " " + SRA->RA_NOME,"PrcElem4")
						Else // Considerando departamento entao...
							cProc := "K" // Processamento...
							cGetFunPrc := _cGetFunPrc // Empresa + Depto Atual
							cGetFunPrc := Iif(!Empty(cGetFunPrc), RTrim(cGetFunPrc) + ",", "") + cEmpAnt + "/" + SRA->RA_FILIAL + "/" + RTrim(SRA->RA_MAT) // Atualizado
							aAdd(aGetFunPrc, cEmpAnt + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT) // Incluo na matriz
                            // Tooltips
                            aAdd(aToolFunci, cEmpAnt + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME))
						EndIf
					EndIf
				ElseIf cPrc == "Rem" // Remover
					If Len(aGetFunPrc) == 0 // Nao foram carregados funcionarios
						MsgStop("Nao existe nenhum funcionario carregado para remover!","PrcElem4")
					ElseIf (nPosR := ASCan(aGetFunPrc, {|x|, x == cEmpAnt + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT })) == 0 // Funcionario nao encontrado
						MsgStop("Funcionario nao encontrado para remover!" + Chr(13) + Chr(10) + ;
						"Empresa/Filial/Funcionario: " + cEmpAnt + "/" + SRA->RA_FILIAL + "/" + SRA->RA_MAT + " " + SRA->RA_NOME,"PrcElem4")
					Else // Removendo departamento
						cProc := "K"
						aDel(aGetFunPrc, nPosR)
						aSize(aGetFunPrc, Len(aGetFunPrc) - 1)
                        // Tooltips
                        aDel(aToolFunci, nPosR)
                        aSize(aToolFunci, Len(aToolFunci) - 1)
						If Len(aGetFunPrc) > 0 // Ainda tem elementos
							cGetFunPrc := ""
							For y := 1 To Len(aGetFunPrc)
								cGetFunPrc += RTrim(aGetFunPrc[y]) + ","
							Next
							cGetFunPrc := Left(cGetFunPrc, Len(cGetFunPrc) - 1) // Removo virgula
						Else // Limpou tudo
							cGetFunPrc := ""
                            // Tooltips
                            aToolFunci := {}
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If cProc $ "L/K" // Processamento Validado "K" ou "L"=Limpeza geral... refresh
			If Len(aGetFunPrc) > 0
				cToolTip += "Funcionarios " + Iif(cTip == "Shw", "considerados:","desconsiderados:") + Chr(13) + Chr(10)
                For y := 1 To Len(aToolFunci)
					cToolTip += aToolFunci[y] + Chr(13) + Chr(10)
				Next
				cToolTip += "Total: " + StrZero(Len(aGetFunPrc),2)
            Else // Limpou tudo
                aToolFunci := {}
			EndIf
			&("cGetFun" + cTip) := cGetFunPrc			// Atribuicao na variavel do objeto
			&("oGetFun" + cTip):cToolTip := cToolTip	// Atualizacao dos tooltips
			&("oGetFun" + cTip):Refresh()				// Refresh no objeto
		EndIf
	EndIf
	oGetFunPsq:SetFocus()
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GeraEx00 ºAutor ³ Jonathan Schmidt Alves ºData ³15/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Excel da tela de dados carregados/relacionados. º±±
±±º          ³ Atalho F10                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraEx00( nMsgPr ) // Atalho F10
Local w, w2
Local aDados := {}
Local cArqGer := "C:\TEMP\SchRec06_EXL_" + StrTran(DtoC(Date()),"/","-") + "_" + StrTran(Left(Time(),6),":","") + ".CSV"
If Len(oGetD1:aCols) > 0
	nExcLines := 0
	lAuto := .F.
	aColsSoma := {}
	aCabec := {}
	// Parte 01: Carregando configuracoes de perguntas
	aAdd(aCabec, { "RecSch06: Acessos TI" })
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
                    If (nFind := ASCan( &("aOpc" + SubStr(aHdr01[w2,02],5,6)), {|x|, Left(x,1) == xDado })) > 0
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GeraExcl ºAutor  ³Jonathan Schmidt Alvesº Data³ 15/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes genericas geracao excel.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GeraExcl(aCabec, aColun, aDados, aColsSoma, nExcLines, lAuto, cArqDest, nMsgPr)
Local _z1
Local cDet
Local nCount := 0 // aColsSoma { 3, 5, 7 }
Local aSomas := Array(Len(aColsSoma)) // { 0, 0, 0 }
Local nLastUpdate := Seconds()
Local w,x,k,s
Private nHdl := 0
Private nTotReg	:= 0
Private cTotReg := cValToChar(Len(aDados))
Private aRetTela := {}
Private lProsiga := .T.
Private cCRLF := Chr(13) + Chr(10)
Default nExcLines := 0 // Padrao nao desconsidera linhas
Default lAuto := .F.
Default cArqDest := "C:\" + AllTrim(FunName()) + ".CSV"
ConOut("GeraExcl: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := Len( aDados )
EndIf
If !File("C:\TEMP")	// Verifico se o diretorio existe
	MakeDir("C:\TEMP") // Cria a pasta local
EndIf
For w := 1 To Len(aColsSoma)
	aSomas[w] := 0
Next
If !lAuto
	//ProcRegua(Len(aDados) * 4)
EndIf
If lAuto .Or. GeraEx02(cArqDest) // Funcao de apontamento do arquivo retorna .T. (OK, prossegue...)
	If lAuto
		nHdl := fCreate(cArqDest) // Cria arquivo txt
	EndIf
	// Cabecalho
	If ValType(aCabec) == "A" // { { "COLUNA 1", "COLUNA 2", "COLUNA 3" }, { "COLUNA 1", "COLUNA 2", "COLUNA 3" } }
		If Len(aCabec) > 0
			For w := 1 To Len(aCabec)
				cDet := ""
				For x := 1 To Len(aCabec[w])
					cDet += aCabec[w,x] + ";"
				Next
				cDet += cCRLF
				fWrite(nHdl,cDet,Len(cDet))
			Next
			cDet := cCRLF
			fWrite(nHdl,cDet,Len(cDet)) // Pula linha
		EndIf
	EndIf
	// Objeto (colunas)
	If ValType(aColun) == "A"
		If Len(aColun) > 0
			cDet := ""
			For w := 1 To Len(aColun)
				If ValType(aColun[w]) == "C"
					cDet += aColun[w] + ";"
				Else
					cDet += transform(aColun[w],"@E 9999999") + ";"
				EndIf
			Next
			cDet += cCRLF
			fWrite(nHdl,cDet,Len(cDet))
		EndIf
	EndIf
	// Dados (informacoes)
	If ValType(aDados) == "A"
		cDet := ""
		For w := 1 To Len(aDados)
            ++nCurrent
			For k := 1 To 4
				//IncProc("Imprimindo... " + {"/","-","\","|"}[k])
			Next
			If nExcLines == 0 .Or. (Len(aDados) - w + 1) > nExcLines // 50 - 49 = 1 > 2
				cDet := ""
				For x := 1 To Len(aDados[w])
					If ValType(aDados[w,x]) == "C"
						cDet += aDados[w,x] + ";"
					Else
						cDet += Transform(aDados[w,x],"@E 999999.99") + ";"
					EndIf
				Next
				// aColsSoma { 3, 5, 7 }
				// { 0, 0, 0 }
				// Soma das colunas
				For s := 1 To Len(aColsSoma)
					aSomas[s] += Val(AllTrim(StrTran(StrTran(aDados[w,aColsSoma[s]],".",""),",",".")))
				Next
				cDet += cCRLF
				fWrite(nHdl,cDet,Len(cDet))
			EndIf
			nCount++ // Soma de registros
            If nMsgPr == 2 // 2=AskYesNo
                If (Seconds() - nLastUpdate) >= 1 // Se passou 1 segundo desde a última atualização da tela
                    For _z1 := 1 To 4
                        u_AtuAsk09(nCurrent,"Gerando Excel...","Registro: " + cValToChar(nCount) + " / " + cTotReg, "", "", 80, "PROCESSA")
                        Sleep(030)
                    Next
                    nLastUpdate := Seconds()
                EndIf
            EndIf
		Next
	EndIf // Totalizacoes (somadas)
	// Totalizacoes (somadas)
	If ValType(aDados) == "A" .And. Len(aDados) > 0 .And. ValType(aSomas) == "A" .And. Len(aSomas) > 0
		cDet := ""
		For w := 1 To Len(aDados[1])
			nPos := ASCan(aColsSoma, {|y|, y == w }) // Coluna em questao eh de totalizacao
			If nPos > 0 // Coluna totalizavel
				cDet += AllTrim(TransForm(aSomas[nPos],"@E 999,999,999.99"))
			EndIf
			cDet += ";"
		Next
		cDet += cCRLF
		fWrite(nHdl,cDet,Len(cDet))
	EndIf
	fClose(nHdl) // Finaliza processo e fecha arquivo txt
	If nCount == Len(aDados)
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		If !lAuto // Nao eh automatico
            If nMsgPr == 2 // 2=AskYesNo
                For _z1 := 1 To 4
                    u_AtuAsk09(nCurrent,"Gerando Excel... Concluido!","Registro: " + cValToChar(nCount) + " / " + cTotReg, "", "", 80, "OK")
                    Sleep(030)
                Next
            Else
                MsgInfo("Fim do processo!" + Chr(13) + Chr(10) + ;
                "Arquivo gerado com " + cValToChar(Len(aDados)) + " registros!" + Chr(13) + Chr(10) + ;
                "Arquivo destino: " + AllTrim(cArqDest),AllTrim(FunName()))
            EndIf
		EndIf
	Else
		If !lAuto // Nao eh automatico
			MsgAlert("Impressao concluida!" + Chr(13) + Chr(10) + ;
			"Arquivo gerado com " + cValToChar(Len(aDados)) + " registros!" + Chr(13) + Chr(10) + ;
			"ALERTA: Nao foram impressos todos os registros em tela!",AllTrim(FunName()))
		EndIf
	EndIf
EndIf
Return

Static Function GeraEx02(cArqDest)
aRetTela := fTelaParam(cArqDest) // Tela de apontamento de parametros
lProsiga := aRetTela[1] // Fragmentando resultado da variavel
cArqDest := aRetTela[2]
If !lProsiga
	MsgAlert("Erro: 01" + cCRLF + "Operação cancelada!",FunName())
	Return .F.
EndIf
If File(cArqDest) // Apaga arquivo caso exista
	If SimNao("Arquivo já existe, deseja substituir?") == "S"
		If fErase(cArqDest) = -1
			MsgAlert("Erro: 02" + cCRLF + "Operação cancelada!",FunName())
			Return .F.
		EndIf
	Else
		MsgAlert("Erro: 03" + cCRLF + "Operação cancelada!",FunName())
		Return .F.
	EndIf
EndIf
nHdl := fCreate(cArqDest) // Cria arquivo txt
Return .T.

Static Function fTelaParam(cArqDest)
Local oDlg
Local lRet := .T.
Local nOpca := 0
Local cDest := Space(150) // Diretorio
Local cArqu := PadR(cArqDest,150) //  Space(300) // Arquivo
Local bOk := {|| nOpca := 1, oDlg:End() }
Local bCancel := {|| nOpca := 2, oDlg:End() }
If !Empty(cArqDest) // Ajusto cArqu e cDest
	If "\" $ cArqDest
		cDest := SubStr(cArqDest, 1, Rat("\",cArqDest) - 1)
		cArqu := SubStr(cArqDest, Rat("\",cArqDest) + 1, Len(cArqDest))
	EndIf
	fTrataFile(@cArqu,@cDest)
EndIf
DEFINE MSDIALOG oDlg From 000,000 TO 130,400 Title OemToAnsi("Gera Excel (" + AllTrim(FunName()) + ")") Pixel
@035,005 Say OemToAnsi("Caminho destino:") Pixel
@048,005 Say OemToAnsi("Nome do arquivo:") Pixel
@034,050 Get cDest	Size 130,8 Picture "@!" Pixel When .F.
@047,050 Get cArqu	Size 147,8 Picture "@!" Pixel When .T. Valid fTrataFile(@cArqu,@cDest)
@034,185 Button oBtn2 Prompt OemToAnsi("...") Size 10,10 Pixel of oDlg Action fBscDir(.T.,@cDest,@cArqu)
ACTIVATE MSDIALOG oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) CENTERED
If nOpca == 1
	If lRet .And. (Empty(cDest) .Or. Empty(cArqu)) // Se o arquivo nao for encontrado, sair da rotina.
		MsgAlert("Caminho ou nome do arquivo de destino não informado!",FunName())
		lRet := .F.
	EndIf
Else
	lRet := .F.
EndIf
Return { lRet, cDest }

Static Function fTrataFile(cAquivo, cCaminho)
Local cDrive	:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
If Empty(cCaminho)
	cCaminho := "C:"
EndIf
If Empty(cAquivo)
	cAquivo := FunName()
EndIf
cAquivo := AllTrim(cAquivo)
If SubStr(cAquivo,Len(cAquivo)-3,4) != ".CSV"
	cAquivo := cAquivo+".CSV"
EndIf
cAquivo := Padr(cAquivo,150)
If !Empty(cCaminho)
	cCaminho := AllTrim(cCaminho)
	If ".CSV" $ cCaminho
		SplitPath( cCaminho, @cDrive, @cDir, @cFile, @cExten )
		cDir := StrTran( cDir, "/", "\" ) // Caso de ser Linux eu mudo de novo
		cCaminho := StrTran(cDrive + cDir,"\\","\")
		cCaminho := AllTrim(cCaminho)
		MsDocRmvBar(@cCaminho)
	Else
		cCaminho := AllTrim(cCaminho)
	EndIf
	If Right(cCaminho,1) == "\"
		cCaminho := PadR( cCaminho + cAquivo,300)
	Else
		cCaminho := PadR( cCaminho + "\" + cAquivo,300)
	EndIf
EndIf
Return

Static Function fBscDir(lDir,cDirArq,cAquivo)
Local cTipo 	:= "Documentos de texto | *.CSV |"
Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cRet		:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= ""
If lDir
	cGetFile := cGetFile(cTipo,cTitulo,,cDirIni,,GETF_RETDIRECTORY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)
Else
	cGetFile := cGetFile(cTipo,cTitulo,,cDirIni,.F.,GETF_ONLYSERVER+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)
EndIf
MsDocRmvBar(@cGetFile) // Retira a ultima barra invertida se houver
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten ) // Separa os componentes
If !Empty(cFile) .And. !lDir //Trata variavel de retorno
	cRet := cGetFile
EndIf
If lDir // Trata variavel de retorno
	fTrataFile(@cAquivo,"")
	If !Empty(cAquivo)
		cRet := StrTran(cGetFile + "\","\\","\") + cAquivo
	Else
		cRet := cGetFile
	EndIf
EndIf
cDirArq := cRet
Return
