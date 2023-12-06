#INCLUDE "PROTHEUS.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ SchArr07 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 20/05/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Arrumacao Locais (em desenvolvimento)                      ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Tabelas de processamento principais:                       ∫±±
±±∫          ≥ ZR1: Cadastro de Arrumacao                                 ∫±±
±±∫          ≥ ZR2: Arrumacoes x Enderecos x Operadores                   ∫±±
±±∫          ≥ ZR3: Arrumacoes processadas                                ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ Parametro usuarios com acesso Auditores:                   ∫±±
±±∫          ≥ ST_USRAR07                                                 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function SchArr07()
Local _w1
Private cTitle := "SchArr07: Arrumacao Locais"
// Acesso Usuario Auditor
Private cCodUsr := RetCodUsr()
Private cCodAud := Space(06)
Private cNomAud := Space(30)
Private lAuditor := cCodUsr $ SuperGetMv("ST_USRAR07",.F.,"") // RENATO: 000010    JEFFERSON PUGLIA: 000276     JONATHAN.SIGANAT: 001478
// Cores GetDados 01
Private nC01C01 := RGB(199,199,199)	// Cinza                        *** 01: Agendado
Private nC01S01 := RGB(141,141,141)	// Cinza Mais Escuro            *** 01: Agendado (linha selecionada)
Private nC01C02 := RGB(143,217,223) // Azul Acinzentado             *** 02: Em Arrumacao
Private nC01S02 := RGB(098,202,210) // Azul Acinzentado Escuro      *** 02: Em Arrumacao (linha selecionada)
Private nC01C04 := RGB(170,170,255)	// Azul                         *** 04: Concluido
Private nC01S04 := RGB(128,131,255)	// Azul Mais Escuro             *** 04: Concluido (linha selecionada)
Private nC01C05 := RGB(170,170,255)	// Azul                         *** 05: Encerrado
Private nC01S05 := RGB(128,131,255)	// Azul Mais Escuro             *** 05: Encerrado (linha selecionada)
// Cores GetDados 03
Private nC03CP1 := RGB(199,199,199)	// Cinza                        *** P1: Pendente
Private nC03SP1 := RGB(141,141,141)	// Cinza Mais Escuro            *** P1: Pendente (linha selecionada)
Private nC03CA1 := RGB(132,255,132)	// Verde                        *** A1: Adequado
Private nC03SA1 := RGB(053,255,053)	// Verde Mais Escuro            *** A1: Adequado (linha selecionada)
Private nC03CD1 := RGB(255,128,131)	// Vermelho                     *** D1: Divergencia produto nao encontrado
Private nC03SD1 := RGB(255,079,083)	// Vermelho Mais Escuro         *** D1: Divergencia produto nao encontrado (linha selecionada)
Private nC03CD2 := RGB(255,128,131)	// Vermelho                     *** D2: Divergencia produto a mais
Private nC03SD2 := RGB(255,079,083)	// Vermelho Mais Escuro         *** D2: Divergencia produto a mais (linha selecionada)
Private nC03CA2 := RGB(170,170,255)	// Azul                         *** A2: Aprovador Auditor
Private nC03SA2 := RGB(128,131,255)	// Azul Mais Escuro             *** A2: Aprovador Auditor (linha selecionada)
Private nC03CR1 := RGB(255,128,131)	// Vermelho                     *** R1: Reprovado Auditor
Private nC03SR1 := RGB(255,079,083)	// Vermelho Mais Escuro         *** R1: Reprovado Auditor (linha selecionada)
// Cores GetDados 02
Private nC02C01 := RGB(199,199,199)	// Cinza                        *** 01: Agendado
Private nC02S01 := RGB(141,141,141)	// Cinza Mais Escuro            *** 01: Agendado (linha selecionada)
Private nC02C02 := RGB(143,217,223) // Azul Acinzentado             *** 02: Em Arrumacao
Private nC02S02 := RGB(098,202,210) // Azul Acinzentado Escuro      *** 02: Em Arrumacao (linha selecionada)
Private nC02C04 := RGB(170,170,255)	// Azul                         *** 04: Concluido
Private nC02S04 := RGB(128,131,255)	// Azul Mais Escuro             *** 04: Concluido (linha selecionada)
Private nC02C05 := RGB(170,170,255)	// Azul                         *** 05: Encerrado
Private nC02S05 := RGB(128,131,255)	// Azul Mais Escuro             *** 05: Encerrado (linha selecionada)
// Cores GetDados 04
Private nC04C01 := RGB(199,199,199)	// Cinza                        *** 01: Agendado
Private nC04S01 := RGB(141,141,141)	// Cinza Mais Escuro            *** 01: Agendado (linha selecionada)
Private nC04C02 := RGB(143,217,223) // Azul Acinzentado             *** 02: Em Arrumacao
Private nC04S02 := RGB(098,202,210) // Azul Acinzentado Escuro      *** 02: Em Arrumacao (linha selecionada)
Private nC04C03 := RGB(230,221,162) // Cinza Amarelado              *** 03: Em Processamento
Private nC04S03 := RGB(217,204,117) // Cinza Amarelado Mais Escuro  *** 03: Em Processamento (linha selecionada)
Private nC04C04 := RGB(170,170,255)	// Azul                         *** 04: Concluido
Private nC04S04 := RGB(128,131,255)	// Azul Mais Escuro             *** 04: Concluido (linha selecionada)
Private nC04C05 := RGB(170,170,255)	// Azul                         *** 05: Encerrado
Private nC04S05 := RGB(128,131,255)	// Azul Mais Escuro             *** 05: Encerrado (linha selecionada)
// Cores Panels Folder 01
Private nClrTp1 := RGB(199,199,199)	// Cinza Padrao Mais Claro      *** Top 01
Private nClrGd1 := RGB(141,141,141)	// Cinza Padrao Escuro          *** GetDados 01
Private nClrGd3 := RGB(217,204,117) // Cinza Amarelado              *** GetDados 03
Private nClrBt1 := RGB(141,141,141)	// Cinza Padrao Escuro          *** Bottom 01
// Cores Panels Folder 02
Private nClrTp2 := RGB(141,141,141)	// Cinza Padrao Escuro          *** Top 02
Private nClrTp4 := RGB(205,131,105)	// Bege Acinzentado             *** Top 04
Private nClrGd2 := RGB(205,131,105)	// Bege Acinzentado             *** GetDados 02
Private nClrGd4 := RGB(217,204,117) // Cinza Amarelado              *** GetDados 02
Private nClrBt2 := RGB(205,131,105)	// Bege Acinzentado             *** Bottom
// Linhas Selecionadas
Private nLineG01 := 1
Private nLineG02 := 1
Private nLineG03 := 1
Private nLineG04 := 1
// Folder
Private oFolder
Private aFolder := { "01: Processamentos de Arrumacao", "02: Cadastro de Arrumacoes" }
// GetDados 01
Private oDlg01
Private oGetD1
Private aHdr01 := {}
Private aCls01 := {}
Private aFldsAlt01 := {}
// GetDados 03
Private oGetD3
Private aHdr03 := {}
Private aCls03 := {}
Private aFldsAlt03 := {}
// GetDados 02
Private oGetD2
Private aHdr02 := {}
Private aCls02 := {}
Private aFldsAlt02 := {}
// GetDados 04
Private oGetD4
Private aHdr04 := {}
Private aCls04 := {}
Private aFldsAlt04 := {}
// ############# FILTRO #################
// Data Agendamento Arrumacao Ini
Private oSayDAgIni
Private oGetDAgIni
Private dGetDAgIni := FirstDay(FirstDay(dDatabase) - 65)
// Data Agendamento Arrumacao Fim
Private oSayDAgFim
Private oGetDAgFim
Private dGetDAgFim := LastDay(LastDay(dDatabase) + 1)
// Data Execucao Ini
Private oSayDExIni
Private oGetDExIni
Private dGetDExIni := FirstDay(FirstDay(dDatabase) - 65)
// Data Execucao Fim
Private oSayDExFim
Private oGetDExFim
Private dGetDExFim := dDatabase
// Combo Ordenacao
Private oSayOrdShw
Private oCmbOrdShw
Private aCmbOrdShw := {}
Private cCmbOrdShw := ""
Private aCmbOrdMnt := {}
// ############# FILTRO #################
Private oSayDAgInc
Private oGetDAgInc
Private dGetDAgInc := FirstDay(FirstDay(dDatabase) - 65)
Private oSayDAgFnl
Private oGetDAgFnl
Private dGetDAgFnl := LastDay(LastDay(dDatabase) + 1)
// Filtro Status Arrumacao
Private oSayStaArr
Private oCmbStaArr
Private aCmbStaArr := { "01=Agendado", "02=Em Arrumacao", "04=Concluido", "05=Encerrado", "00=Todos os status" }
Private cCmbStaArr := "00"
// Status Arrumacoes
Private oChkStaArr
Private lChkStaArr := .F.
// Processamentos com divergencia
Private oChkPrcDvg
Private lChkPrcDvg := .F.
// ############# INCLUSAO ###############
// Armazem
Private oSayArmArr
Private oGetArmArr
Private cGetArmArr := "01"
Private dGetDAgIn2 := dDatabase
Private dGetDAgFi2 := dDatabase + 20
// Endereco De Ate
Private oSayEndIni
Private oGetEndIni
Private cGetEndIni := Space(15)
Private oGetEndFim
Private cGetEndFim := Space(15)
// Endereco Psq
Private oSayEndPsq
Private oGetEndPsq
Private cGetEndPsq := Space(15)
Private oGetEndDes
Private cGetEndDes := Space(30)
// Endereco Shw
Private oSayEndShw
Private oGetEndShw
Private cGetEndShw := Space(200)
// Operador De Ate
Private oSayOpeIni
Private oGetOpeIni
Private cGetOpeIni := Space(06)
Private oSayOpeFim
Private oGetOpeFim
Private cGetOpeFim := Space(06)
// Operador Psq
Private oSayOpePsq
Private oGetOpePsq
Private cGetOpePsq := Space(06)
Private oGetOpeDes
Private cGetOpeDes := Space(30)
// Operador Shw
Private oSayOpeShw
Private oGetOpeShw
Private cGetOpeShw := Space(200)
// Holds Alterar/Cancelar
Private dHldDAgIn2 := dGetDAgIn2
Private dHldDAgFi2 := dGetDAgFi2
Private cHldArmArr := cGetArmArr
Private cHldEndIni := cGetEndIni
Private cHldEndFim := cGetEndFim
Private cHldEndPsq := cGetEndPsq
Private cHldEndDes := cGetEndDes
Private cHldOpeIni := cGetOpeIni
Private cHldOpeFim := cGetOpeFim
Private cHldOpePsq := cGetOpePsq
Private cHldOpeDes := cGetOpeDes
Private cHldEndShw := cGetEndShw
Private cHldOpeShw := cGetOpeShw
Private cHldEndTip := "Separar enderecos com ',' (virgula)"
Private cHldOpeTip := "Separar operadores com ',' (virgula)"
// Filiais
Private _cFilZR1 := xFilial("ZR1")
Private _cFilZR2 := xFilial("ZR2")
Private _cFilZR3 := xFilial("ZR3")
Private _cFilNNR := xFilial("NNR")
Private _cFilSBE := xFilial("SBE")
Private _cFilCB1 := xFilial("CB1")
Private _cFilSB1 := xFilial("SB1")
// Abertura tabelas
DbSelectArea("ZR1") // Cadastro de Arrumacoes
ZR1->(DbSetOrder(1)) // ZR1_FILIAL + ZR1_ARRUMA
DbSelectArea("ZR2") // Arrumacoes x Operadores
ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
DbSelectArea("ZR3") // Processamentos Arrumacoes
ZR3->(DbSetOrder(1)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_CODLOC + ZR3_CODEND + ZR3_CODPRO
DbSelectArea("CB1") // Cadastro de Operadores
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
If lAuditor // .T.=Usario logado auditor
    CB1->(DbSetOrder(2)) // CB1_FILIAL + CB1_CODUSR
    If CB1->(DbSeek( _cFilCB1 + cCodUsr ))
        cCodAud := CB1->CB1_CODOPE
        cNomAud := CB1->CB1_NOME
        aFldsAlt03 := { "I03_STAAUD", "I03_OBSAUD", "I03_OBSLIV" }
    Else
        MsgStop("Usuario com acesso de Auditor nao encontrado no cadastro (CB1)!" + Chr(13) + Chr(10) + ;
        "Usuario: " + cCodUsr + Chr(13) + Chr(10) + ;
        "Verifique o codigo no cadastro de operadores e tente novanente!","SchArr07")
        lAuditor := .F.
    EndIf
EndIf
// ############## HEADER 01: ZR1 Cadastro de Arrumacoes ######################
aHdr01 := LoadsHdr("01") // Criacao do aHdr01
For _w1 := 1 To Len(aHdr01)
	&("nP01" + SubStr(aHdr01[_w1,2],5,6)) := _w1
Next
aCls01 := LoadCols(aHdr01) // Criacao do aCls01
// ############## HEADER 03: ZR3 Processamentos Arrumacoes ######################
aHdr03 := LoadsHdr("03") // Criacao do aHdr03
For _w1 := 1 To Len(aHdr03)
	&("nP03" + SubStr(aHdr03[_w1,2],5,6)) := _w1
Next
aCls03 := LoadCols(aHdr03) // Criacao do aCls03
// ############## HEADER 02: ZR1 Cadastro de Arrumacoes ######################
aHdr02 := LoadsHdr("02") // Criacao do aHdr02
For _w1 := 1 To Len(aHdr02)
	&("nP02" + SubStr(aHdr02[_w1,2],5,6)) := _w1
Next
aCls02 := LoadCols(aHdr02) // Criacao do aCls02
// ############## HEADER 04: ZR2 Arrumacoes x Operadores ######################
aHdr04 := LoadsHdr("04") // Criacao do aHdr04
For _w1 := 1 To Len(aHdr04)
	&("nP04" + SubStr(aHdr04[_w1,2],5,6)) := _w1
Next
aCls04 := LoadCols(aHdr04) // Criacao do aCls04
// Ordenacao GetDados 01
aAdd(aCmbOrdMnt, { "01=Arrumacao ",                     {|x,y|, x[nP01Arruma]                           < y[nP01Arruma] }                           })
aAdd(aCmbOrdMnt, { "02=Dt Prev Inicio + Arrumacao",     {|x,y|, DtoS(x[nP01PrvIni]) + x[nP01Arruma]     < DtoS(y[nP01PrvIni]) + y[nP01Arruma] }     })
For _w1 := 1 To Len( aCmbOrdMnt )
    aAdd(aCmbOrdShw, aCmbOrdMnt[ _w1, 01 ])
Next
cCmbOrdShw := aCmbOrdMnt[01,01]
LoadGd01() // Carregamento GetDados 01/03
LoadGd02() // Carregamento GetDados 02/04
DEFINE MSDIALOG oDlg01 FROM 050,165 TO 752,1540 TITLE cTitle Pixel
// 01: Processamentos de Arrumacao 02: Cadastro de Arrumacoes
oFolder := TFolder():New(001,001,aFolder,,oDlg01,,,,.T.,,685,349)
// ############################### 01: Processamentos de Arrumacao ###################################
// Logo Steck
@001,570 BitMap Size 100,080 File "lgrecibo0101.jpg" Of oFolder:aDialogs[ 01 ] Pixel Stretch NoBorder
// Panel
oPnlTp1	:= TPanel():New(000,000,,oFolder:aDialogs[ 01 ],,,,,nClrTp1,570,040,.F.,.F.) // Filtro
oPnlG11	:= TPanel():New(040,000,,oFolder:aDialogs[ 01 ],,,,,nClrGd1,690,110,.F.,.F.) // GetDados 01
oPnlG31	:= TPanel():New(150,000,,oFolder:aDialogs[ 01 ],,,,,nClrGd3,690,170,.F.,.F.) // GetDados 03
oPnlBt1	:= TPanel():New(320,000,,oFolder:aDialogs[ 01 ],,,,,nClrBt1,690,015,.F.,.F.) // Rodape
// Linha 01
@004,004 SAY	oSayDAgIni PROMPT "Dt Agen Ini:" SIZE 100,010 OF oPnlTp1 PIXEL
@002,036 MSGET	oGetDAgIni VAR dGetDAgIni SIZE 045,008 OF oPnlTp1 PIXEL HASBUTTON
@004,083 SAY	oSayDAgFim PROMPT "Dt Agen Fim:" SIZE 100,010 OF oPnlTp1 PIXEL
@002,118 MSGET	oGetDAgFim VAR dGetDAgFim SIZE 045,008 OF oPnlTp1 PIXEL HASBUTTON
// Linha 02
@017,006 SAY	oSayDExIni PROMPT "Dt Exec Ini:" SIZE 100,010 OF oPnlTp1 PIXEL
@015,042 MSGET	oGetDExIni VAR dGetDExIni SIZE 045,008 OF oPnlTp1 PIXEL HASBUTTON
@017,095 SAY	oSayDExFim PROMPT "Dt Exec Fim:" SIZE 100,010 OF oPnlTp1 PIXEL
@015,130 MSGET	oGetDExFim VAR dGetDExFim SIZE 045,008 OF oPnlTp1 PIXEL HASBUTTON
// Linha 01 Ordem apresentacao
@004,188 SAY	oSayOrdShw PROMPT "Ordem:" SIZE 040,010 OF oPnlTp1 PIXEL
@002,210 MSCOMBOBOX oCmbOrdShw VAR cCmbOrdShw ITEMS aCmbOrdShw SIZE 150,011 OF oPnlTp1 Pixel
oCmbOrdShw:bChange := {|| u_AskYesNo(3500,"OrdShw04","Ordenando...","","","","","S4WB013N",.T.,.F.,{|| OrdShw04() }) }
// Mostrar todos os status
@030,006 CHECKBOX oChkStaArr VAR lChkStaArr PROMPT "Nao mostrar arrumacoes 04=Concluido/05=Encerrado" SIZE 140,008 OF oPnlTp1 PIXEL ON CHANGE u_AskYesNo(3500,"LoadGd01","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadGd01() })
oChkStaArr:cVariable := "lChkStaArr"
// Mostrar apenas processamentos com divergencias
@030,180 CHECKBOX oChkPrcDvg VAR lChkPrcDvg PROMPT "Mostrar apenas processamentos D_=Divergencias" SIZE 140,008 OF oPnlTp1 PIXEL ON CHANGE u_AskYesNo(3500,"LoadGd01","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadGd01() })
oChkPrcDvg:cVariable := "lChkPrcDvg"
// Linha 02 Botoes
@017,185 BUTTON oBtnPsq01   PROMPT "Pesquisar"	SIZE 060,010 Pixel Of oPnlTp1 Action(u_AskYesNo(3500,"LoadGd01","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| LoadGd01() })) // Carregamento Arrumacoes (GetDados 01)
@017,260 BUTTON oBtnImp01   PROMPT "Excel"		SIZE 060,010 Pixel Of oPnlTp1 Action(GeraEx00())
// GetDados 01
oGetD1 := MsNewGetDados():New(003,003,110,682,Nil,"AllwaysTrue()","AllwaysTrue()",,aFldsAlt01,,,,,"AllwaysTrue()",oPnlG11,@aHdr01,@aCls01)
oGetD1:oBrowse:lHScroll := .F.
oGetD1:oBrowse:SetBlkBackColor({|| GetDXClr("01", oGetD1:aCols, oGetD1:nAt, aHdr01) })
oGetD1:bChange := {|| nLineG01 := oGetD1:nAt, ZR1->(DbGoto(oGetD1:aCols[ nLineG01, nP01RecZR1 ])), oGetD1:aCols[ nLineG01, nP01CodSta ] := ZR1->ZR1_CODSTA, oGetD1:Refresh(), LoadGd03(oGetD1:nAt) }
// GetDados 03
oGetD3 := MsNewGetDados():New(003,003,170,682, Iif( lAuditor, GD_UPDATE, Nil ),"AllwaysTrue()","AllwaysTrue()",,aFldsAlt03,,,,,"AllwaysTrue()",oPnlG31,@aHdr03,@aCls03)
oGetD3:oBrowse:lHScroll := .F.
oGetD3:oBrowse:SetBlkBackColor({|| GetDXClr("03", oGetD3:aCols, oGetD3:nAt, aHdr03) })
oGetD3:bChange := {|| nLineG03 := oGetD3:nAt, ZR3->(DbGoto(oGetD3:aCols[ nLineG03, nP03RecZR3 ])), oGetD3:aCols[ nLineG03, nP03CodSta ] := Iif( ZR3->ZR3_STAAUD $ "A2/R1/", ZR3->ZR3_STAAUD, ZR3->ZR3_STAOPE), oGetD3:Refresh() }
// Atalhos
If lAuditor
    @001,070 SAY	oSayAtaF7   PROMPT "F7 = Encerrar Arrumacao"        SIZE 080,010 OF oPnlBt1 PIXEL
    @001,170 SAY	oSayAtaF8   PROMPT "F8 = Altera Status Auditor"     SIZE 080,010 OF oPnlBt1 PIXEL
    @001,250 SAY	oSayAtaF9   PROMPT "F9 = Altera Observacao Auditor" SIZE 140,010 OF oPnlBt1 PIXEL
EndIf
@001,470 SAY	oSayAtaF10  PROMPT "F10 = Gera Excel"				SIZE 080,010 OF oPnlBt1 PIXEL
@001,550 SAY	oSayAtaF12  PROMPT "F12 = About "                   SIZE 080,010 OF oPnlBt1 PIXEL
// ############################### 02: Cadastro de Arrumacoes ###################################
// Panel
oPnlTp2	:= TPanel():New(000,000,,oFolder:aDialogs[ 02 ],,,,,nClrTp2,165,040,.F.,.F.) // Filtro
oPnlTp4	:= TPanel():New(000,165,,oFolder:aDialogs[ 02 ],,,,,nClrTp4,525,040,.F.,.F.) // Inclusao
oPnlG22	:= TPanel():New(040,000,,oFolder:aDialogs[ 02 ],,,,,nClrGd2,690,110,.F.,.F.) // GetDados 02
oPnlG42	:= TPanel():New(150,000,,oFolder:aDialogs[ 02 ],,,,,nClrGd4,690,170,.F.,.F.) // GetDados 04
oPnlBt2	:= TPanel():New(320,000,,oFolder:aDialogs[ 02 ],,,,,nClrBt2,690,015,.F.,.F.) // Rodape
// %%%%%%%%%%%%%%%%%%%% FILTRO %%%%%%%%%%%%%%%%%%%%
// Linha 01
@004,004 SAY	oSayDAgInc PROMPT "Dt Agen Ini:" SIZE 100,010 OF oPnlTp2 PIXEL
@002,036 MSGET	oGetDAgInc VAR dGetDAgInc SIZE 045,008 OF oPnlTp2 PIXEL HASBUTTON
@004,083 SAY	oSayDAgFnl PROMPT "Dt Agen Fim:" SIZE 100,010 OF oPnlTp2 PIXEL
@002,118 MSGET	oGetDAgFnl VAR dGetDAgFnl SIZE 045,008 OF oPnlTp2 PIXEL HASBUTTON
// Linha 02 Status Arrumacoes
@017,004 SAY	oSayStaArr PROMPT "Status Arrumacoes:" SIZE 080,010 OF oPnlTp2 PIXEL
@015,060 MSCOMBOBOX oCmbStaArr VAR cCmbStaArr ITEMS aCmbStaArr SIZE 090,011 OF oPnlTp2 Pixel
oCmbStaArr:bChange := {|| u_AskYesNo(3500,"StaArr04","Status Arrumacoes...","","","","","S4WB013N",.T.,.F.,{|| LoadGd02() }) }
@028,006 BUTTON oBtnPsq02 PROMPT "Pesquisar"	SIZE 060,010 Pixel Of oPnlTp2 Action(u_AskYesNo(3500,"LoadGd02","Carregando Amarracoes x Operadores...","","","","","PROCESSA",.T.,.F.,{|| LoadGd02() })) // Carregamento Cadastro Arrumacoex x Operadors (GetDados 02)
// %%%%%%%%%%%%%%%%%%%% INCLUSAO %%%%%%%%%%%%%%%%%%%%
// Linha 01 Armazem
@004,006 SAY	oSayArmArr PROMPT "Armazem:" SIZE 050,010 OF oPnlTp4 PIXEL
@002,038 MSGET	oGetArmArr VAR cGetArmArr SIZE 025,008 OF oPnlTp4 F3 "NNR" PIXEL VALID VldArm04() HASBUTTON
// Linha 02
@017,006 SAY	oSayDAgIn2 PROMPT "Dt Agen Ini:" SIZE 100,010 OF oPnlTp4 PIXEL
@015,038 MSGET	oGetDAgIn2 VAR dGetDAgIn2 SIZE 045,008 OF oPnlTp4 PIXEL HASBUTTON
@017,085 SAY	oSayDAgFi2 PROMPT "Dt Agen Fim:" SIZE 100,010 OF oPnlTp4 PIXEL
@015,120 MSGET	oGetDAgFi2 VAR dGetDAgFi2 SIZE 045,008 OF oPnlTp4 PIXEL HASBUTTON
// Linha 01 Endereco De Ate
@004,170 SAY	oSayEndIni PROMPT "Endereco De:" SIZE 100,010 OF oPnlTp4 PIXEL
@002,206 MSGET	oGetEndIni VAR cGetEndIni SIZE 050,008 OF oPnlTp4 F3 "SBE" PIXEL VALID VldEnd04() HASBUTTON
@004,257 SAY	oSayEndFim PROMPT "Endereco Ate:" SIZE 100,010 OF oPnlTp4 PIXEL
@002,295 MSGET	oGetEndFim VAR cGetEndFim SIZE 050,008 OF oPnlTp4 F3 "SBE" PIXEL VALID VldEnd04() HASBUTTON
// Linha 02 Enderecos Pesquisar
@017,170 SAY	oSayEndPsq PROMPT "Endereco:" SIZE 100,010 OF oPnlTp4 PIXEL
@015,205 MSGET	oGetEndPsq VAR cGetEndPsq SIZE 050,008 OF oPnlTp4 F3 "SBE" PIXEL VALID VldEnd04()  HASBUTTON
@015,265 MSGET	oGetEndDes VAR cGetEndDes SIZE 080,008 OF oPnlTp4 PIXEL READONLY
oGetEndDes:lActive := .F.
// Linha 03 Enderecos Considerar
@030,170 SAY	oSayEndShw PROMPT "Considerar:" SIZE 100,010 OF oPnlTp4 PIXEL
@028,206 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTp4 Action(PrcElems("End","Add","Shw")) // Adicionar Enderecos
@028,216 MSGET	oGetEndShw VAR cGetEndShw SIZE 120,008 OF oPnlTp4 PIXEL READONLY
@028,336 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTp4 Action(PrcElems("End","Rem","Shw")) // Remover Enderecos
oGetEndShw:lActive := .F.
oGetEndShw:cToolTip := "Separar enderecos agendamento com ',' (virgula)"
// Linha 01 Operador De Ate
@004,348 SAY	oSayOpeIni PROMPT "Operador De:" SIZE 100,010 OF oPnlTp4 PIXEL
@002,387 MSGET	oGetOpeIni VAR cGetOpeIni SIZE 035,008 OF oPnlTp4 F3 "CB1" PIXEL Valid VldOpe04() HASBUTTON
@004,435 SAY	oSayOpeFim PROMPT "Operador Ate:" SIZE 100,010 OF oPnlTp4 PIXEL
@002,476 MSGET	oGetOpeFim VAR cGetOpeFim SIZE 035,008 OF oPnlTp4 F3 "CB1" PIXEL Valid VldOpe04() HASBUTTON
// Linha 02 Operadores Pesquisar
@017,348 SAY	oSayOpePsq PROMPT "Operador:" SIZE 100,010 OF oPnlTp4 PIXEL
@015,387 MSGET	oGetOpePsq VAR cGetOpePsq SIZE 035,008 OF oPnlTp4 F3 "CB1" PIXEL Valid VldOpe04()  HASBUTTON
@015,425 MSGET	oGetOpeDes VAR cGetOpeDes SIZE 086,008 OF oPnlTp4 PIXEL READONLY
oGetOpeDes:lActive := .F.
// Linha 03 Operadores Considerar
@030,348 SAY	oSayOpeShw PROMPT "Considerar:" SIZE 100,010 OF oPnlTp4 PIXEL
@028,387 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTp4 Action(PrcElems("Ope","Add","Shw")) // Adicionar Enderecos
@028,397 MSGET	oGetOpeShw VAR cGetOpeShw SIZE 105,008 OF oPnlTp4 PIXEL READONLY
@028,502 BUTTON ">>"	SIZE 008,010 Pixel Of oPnlTp4 Action(PrcElems("Ope","Rem","Shw")) // Remover Enderecos
oGetOpeShw:lActive := .F.
oGetOpeShw:cToolTip := "Separar operadores com ',' (virgula)"
// Botoes Incluir/Alterar/Cancelar
@028,046 BUTTON oBtnInc02 PROMPT "Incluir" SIZE 060,010 Pixel Of oPnlTp4 Action(u_AskYesNo(3500,"LoadAmar","Incluindo Amarracoes x Operadores...","","","","","PROCESSA",.T.,.F.,{|| InclGd02() })) // Incluindo Cadastro Arrumacao x Operador (GetDados 02)
oBtnInc02:lActive := .F.
@028,006 BUTTON oBtnAlt02 PROMPT "Alterar" SIZE 060,010 Pixel Of oPnlTp4 Action(u_AskYesNo(3500,"LoadAmar","Alterando Amarracoes x Operadores...","","","","","PROCESSA",.T.,.F.,{|| AlteGd02("G") })) // Alterando Cadastro Arrumacao x Operador (GetDados 02)
oBtnAlt02:lVisible := .F.
@028,086 BUTTON oBtnCan02 PROMPT "Cancelar" SIZE 060,010 Pixel Of oPnlTp4 Action(AlteGd02("C")) // Cancelando Cadastro Arrumacao x Operador (GetDados 02)
oBtnCan02:lVisible := .F.
// GetDados 02
oGetD2 := MsNewGetDados():New(003,003,110,682,Nil,"AllwaysTrue()", "AllwaysTrue()" ,,aFldsAlt02,,,,,"AllwaysTrue()",oPnlG22,@aHdr02,@aCls02)
oGetD2:oBrowse:lHScroll := .F.
oGetD2:oBrowse:SetBlkBackColor({|| GetDXClr("02", oGetD2:aCols, oGetD2:nAt, aHdr02) })
oGetD2:bChange := {|| nLineG02 := oGetD2:nAt, ZR1->(DbGoto(oGetD2:aCols[ nLineG02, nP02RecZR1 ])), oGetD2:aCols[ nLineG02, nP02CodSta ] := ZR1->ZR1_CODSTA, oGetD2:Refresh(), LoadGd04(oGetD2:nAt) }
oGetD2:oBrowse:blDblClick := {|| AlteGd02("A") }
// GetDados 04
oGetD4 := MsNewGetDados():New(003,003,170,682,Nil,"AllwaysTrue()", "AllwaysTrue()" ,,aFldsAlt04,,,,,"AllwaysTrue()",oPnlG42,@aHdr04,@aCls04)
oGetD4:oBrowse:lHScroll := .F.
oGetD4:oBrowse:SetBlkBackColor({|| GetDXClr("04", oGetD4:aCols, oGetD4:nAt, aHdr04) })
oGetD4:bChange := {|| nLineG04 := oGetD4:nAt, ZR2->(DbGoto(oGetD4:aCols[ nLineG04, nP04RecZR2 ])), oGetD4:aCols[ nLineG04, nP04CodSta ] := ZR2->ZR2_CODSTA, oGetD4:Refresh() }
// Validacao do Armazem para posicionar NNR
VldArm04("cGetArmArr")
// Atalhos
If lAuditor
    SetKey(VK_F7,{|| EndsGd01() }) // Atalho F7 Encerra Arrumacao
    SetKey(VK_F8,{|| ChgObsF8() }) // Atalho F8 Altera Status Auditor
    SetKey(VK_F9,{|| ChgObsF9() }) // Atalho F9 Altera Observacao Auditor
EndIf
SetKey(VK_F10,{|| GeraEx00() }) // Atalho F10 Gera Excel
SetKey(VK_F12,{|| AboutArr() }) // Atalho F12 About Arrumacao Steck
// Acesso Usuario (Operador/Auditor)
@001,630 SAY	oSayUsrOpe PROMPT "Acesso: " + Iif(lAuditor,"Auditor","Operador")	SIZE 090,010 OF oPnlBt1 PIXEL
oFolder:ShowPage( 01 )
ACTIVATE MSDIALOG oDlg01 CENTERED
Return

Static Function GetDXClr(cGet, aCols, nLine, aHdrs) // Cores GetDados 01/03
Local nClr := nClrTp1 // Cinza Padrao Mais Claro
If nLine <= Len(aCols)
	If nLine > 0 .And. nLine <= Len(aCols) .And. !Empty( aCols[ nLine, &("nP" + cGet + "CodSta") ] )
        nClr := &("nC" + cGet + Iif(nLine == &("nLineG" + cGet),"S","C") + aCols[ nLine, &("nP" + cGet + "CodSta") ])
	EndIf
EndIf
Return nClr

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadGd01 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 20/05/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento 01: Arrumacoes (GetD01)                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadGd01()
DbSelectArea("ZR1") // Cadastro de Arrumacoes
ZR1->(DbSetOrder(2)) // ZR1_FILIAL + DtoS(ZR1_PRVINI)
DbSelectArea("ZR3") // Processamentos Arrumacoes
ZR3->(DbSetOrder(1)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_CODLOC + ZR3_CODEND + ZR3_CODPRO
DbSelectArea("SB1") // Cadastro de Produtos
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("CB1") // Cadastro de Operadores
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
aCls01 := {}
ZR1->(DbSeek(_cFilZR1 + DtoS(dGetDAgIni),.T.))
While ZR1->(!EOF()) .And. ZR1->ZR1_FILIAL == _cFilZR1 .And. ZR1->ZR1_PRVINI >= dGetDAgIni .And. ZR1->ZR1_PRVFIM <= dGetDAgFim // Data Previsao Inicio/Fim conforme
    If !lChkStaArr .Or. (lChkStaArr .And. ZR1->ZR1_CODSTA $ "01/02/") // "01"=Agendado "02"=Em Arrumacao
        lZR3 := .T.
        If lChkPrcDvg // Apenas com arrumacoes com divergencias
            lZR3 := .F.
            ZR3->(DbSetOrder(3)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_STAOPE + ZR3_STAAUD
            If ZR3->(DbSeek(_cFilZR3 + ZR1->ZR1_ARRUMA + "D")) // D1=Divergencia produto nao encontrado		D2=Divergencia produto a mais
                While ZR3->(!EOF()) .And. ZR3->ZR3_FILIAL + ZR3->ZR3_ARRUMA + Left(ZR3->ZR3_STAOPE,1) == _cFilZR3 + ZR1->ZR1_ARRUMA + "D"
                    If Left(ZR3->ZR3_STAAUD,1) <> "A" // A1=Aprovado Auditor
                        lZR3 := .T.
                        Exit
                    EndIf
                    ZR3->(DbSkip())
                End
            EndIf
            ZR3->(DbSetOrder(1)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_CODLOC + ZR3_CODEND + ZR3_CODPRO
        EndIf
        If lZR3 // .T.=Arrumacao conforme nas checkbox das divergencias
            If ZR3->(DbSeek(_cFilZR3 + ZR1->ZR1_ARRUMA))
                While ZR3->(!EOF()) .And. ZR3->ZR3_FILIAL + ZR3->ZR3_ARRUMA == _cFilZR3 + ZR1->ZR1_ARRUMA
                    If ZR3->ZR3_DTEXEC >= dGetDExIni .And. ZR3->ZR3_DTEXEC <= dGetDExFim // Execucao Inicio/Fim conforme
                        If SB1->(DbSeek(_cFilSB1 + ZR3->ZR3_CODPRO)) // Produto localizado
                            //           {              01,              02,              03,              04,              05,              06,              07,              08,              09,              10,              11,             12, .F. }
                            aAdd(aCls01, { ZR1->ZR1_CODSTA, ZR1->ZR1_ARRUMA, ZR1->ZR1_PRVINI, ZR1->ZR1_PRVFIM, ZR1->ZR1_CODLOC, ZR1->ZR1_ENDINI, ZR1->ZR1_ENDFIM, ZR1->ZR1_OPEINI, ZR1->ZR1_OPEFIM, ZR1->ZR1_ENDCON, ZR1->ZR1_OPECON, ZR1->(Recno()), .F. })
                            Exit
                        EndIf
                    EndIf
                    ZR3->(DbSkip())
                End
            Else // Arrumacao ainda sem nenhum apontamento
                //           {              01,              02,              03,              04,              05,              06,              07,              08,              09,              10,              11,             12, .F. }
                aAdd(aCls01, { ZR1->ZR1_CODSTA, ZR1->ZR1_ARRUMA, ZR1->ZR1_PRVINI, ZR1->ZR1_PRVFIM, ZR1->ZR1_CODLOC, ZR1->ZR1_ENDINI, ZR1->ZR1_ENDFIM, ZR1->ZR1_OPEINI, ZR1->ZR1_OPEFIM, ZR1->ZR1_ENDCON, ZR1->ZR1_OPECON, ZR1->(Recno()), .F. })
            EndIf
        EndIf
    EndIf
    ZR1->(DbSkip())
End
If Len(aCls01) == 0
	aCls01 := LoadCols(aHdr01) // Criacao do aCols
    aCls03 := LoadCols(aHdr03) // Criacao do aCols
Else
    bBlock := aCmbOrdMnt[ Val(Left(cCmbOrdShw,2)), 02 ]
    aSort(aCls01,,, bBlock)
EndIf
If Type("oGetD1") == "O"
    oGetD1:aCols := aClone(aCls01)
    oGetD1:Refresh()
    Eval(oGetD1:bChange)
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadGd03 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 20/05/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento 03: Processamentos das Arrumacoes (GetD03)    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadGd03(nLin)
Local cCodSta := Space(02)
Local cNomOpe := Space(30)
Local cNomAud := Space(30)
aCls03 := {}
If ZR3->(DbSeek(_cFilZR3 + oGetD1:aCols[ nLin, nP01Arruma ]))
    While ZR3->(!EOF()) .And. ZR3->ZR3_FILIAL + ZR3->ZR3_ARRUMA == _cFilZR3 + oGetD1:aCols[ nLin, nP01Arruma ]
        If ZR3->ZR3_DTEXEC >= dGetDExIni .And. ZR3->ZR3_DTEXEC <= dGetDExFim // Execucao Inicio/Fim conforme
            If SB1->(DbSeek(_cFilSB1 + ZR3->ZR3_CODPRO)) // Produto localizado
                cNomAud := Space(30)
                cCodSta := ZR3->ZR3_STAOPE
                If CB1->(DbSeek(_cFilCB1 + ZR3->ZR3_CODOPE))
                    cNomOpe := CB1->CB1_NOME
                    If !Empty(ZR3->ZR3_CODAUD)
                        If CB1->(DbSeek(_cFilCB1 + ZR3->ZR3_CODAUD))
                            cNomAud := CB1->CB1_NOME
                        EndIf
                    EndIf
                    If ZR3->ZR3_STAAUD $ "A2/R1/" // A2=Aprovado Auditor R1=Reprovado Auditor
                        cCodSta := ZR3->ZR3_STAAUD
                    EndIf
                    //           {      01,              02,              03,              04,              05,           06,              07,      08,              09,              10,              11,              12,      13,              14,              15,              16,              17,              18,             19, .F. }
                    aAdd(aCls03, { cCodSta, ZR3->ZR3_ARRUMA, ZR3->ZR3_CODLOC, ZR3->ZR3_CODEND, ZR3->ZR3_CODPRO, SB1->B1_DESC, ZR3->ZR3_CODOPE, cNomOpe, ZR3->ZR3_DTEXEC, ZR3->ZR3_HREXEC, ZR3->ZR3_STAOPE, ZR3->ZR3_CODAUD, cNomAud, ZR3->ZR3_STAAUD, ZR3->ZR3_OBSAUD, ZR3->ZR3_DATAUD, ZR3->ZR3_HORAUD, ZR3->ZR3_OBSLIV, ZR3->(Recno()), .F. })
                EndIf
            EndIf
        EndIf
        ZR3->(DbSkip())
    End
EndIf
If Len(aCls03) == 0
	aCls03 := LoadCols(aHdr03) // Criacao do aCols
EndIf
If Type("oGetD3") == "O"
    aSort(aCls03,,, {|x,y|, x[nP03Arruma] + x[nP03CodEnd] + x[nP03CodPro]       < y[nP03Arruma] + y[nP03CodEnd] + y[nP03CodPro] }) // Arrumacao + Endereco + Produto
    oGetD3:aCols := aClone(aCls03)
    oGetD3:Refresh()
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadGd02 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 07/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento 02: Cadastro Amarracoes x Operadores (GetD02) ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadGd02()
DbSelectArea("ZR1") // Cadastro de Arrumacoes
ZR1->(DbSetOrder(2)) // ZR1_FILIAL + DtoS(ZR1_PRVINI)
DbSelectArea("ZR2") // Cadastro Arrumacoes x Operadores
ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
DbSelectArea("SB1") // Cadastro de Produtos
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("CB1") // Cadastro de Operadores
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
aCls02 := {}
aCls04 := {}
ZR1->(DbSeek(_cFilZR1 + DtoS(dGetDAgInc),.T.))
While ZR1->(!EOF()) .And. ZR1->ZR1_FILIAL == _cFilZR1 .And. ZR1->ZR1_PRVINI >= dGetDAgInc // Data Previsao Inicio conforme
    If ZR1->ZR1_PRVFIM <= dGetDAgFnl // Previsao Fim conforme
        If Left(cCmbStaArr,2) == "00" .Or. ZR1->ZR1_CODSTA == Left(cCmbStaArr,02) // Status Arrumacao conforme
            If ZR2->(DbSeek(_cFilZR2 + ZR1->ZR1_ARRUMA))
                //           {              01,              02,              03,              04,              05,              06,              07,              08,              09,              10,              11,             12, .F. }
                aAdd(aCls02, { ZR1->ZR1_CODSTA, ZR1->ZR1_ARRUMA, ZR1->ZR1_PRVINI, ZR1->ZR1_PRVFIM, ZR1->ZR1_CODLOC, ZR1->ZR1_ENDINI, ZR1->ZR1_ENDFIM, ZR1->ZR1_OPEINI, ZR1->ZR1_OPEFIM, ZR1->ZR1_ENDCON, ZR1->ZR1_OPECON, ZR1->(Recno()), .F. })
            EndIf
        EndIf
    EndIf
    ZR1->(DbSkip())
End
If Len(aCls02) == 0
	aCls02 := LoadCols(aHdr02) // Criacao do aCols
    aCls04 := LoadCols(aHdr04) // Criacao do aCols
Else
    aSort(aCls02,,, {|x,y|, x[ nP02Arruma ] < y[ nP02Arruma ] }) // Ordeno pelo Codigo Arrumacao
EndIf
If Type("oGetD2") == "O"
    oGetD2:aCols := aClone(aCls02)
    oGetD2:Refresh()
    Eval(oGetD2:bChange)
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadGd04 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 07/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento 04: Amarracoes Operadores x Enderecos (GetD04)∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadGd04(nLin)
aCls04 := {}
If ZR2->(DbSeek(_cFilZR2 + oGetD2:aCols[ nLin, nP02Arruma ]))
    While ZR2->(!EOF()) .And. ZR2->ZR2_FILIAL + ZR2->ZR2_ARRUMA == _cFilZR2 + oGetD2:aCols[ nLin, nP02Arruma ]
        If CB1->(DbSeek(_cFilCB1 + ZR2->ZR2_CODOPE))
            //           {              01,              02,              03,              04,              05,            06,             07, .F. }
            aAdd(aCls04, { ZR2->ZR2_CODSTA, ZR2->ZR2_ARRUMA, ZR2->ZR2_CODLOC, ZR2->ZR2_CODEND, ZR2->ZR2_CODOPE, CB1->CB1_NOME, ZR2->(Recno()), .F. })
        EndIf
        ZR2->(DbSkip())
    End
EndIf
If Len(aCls04) == 0
	aCls04 := LoadCols(aHdr04) // Criacao do aCols
EndIf
If Type("oGetD4") == "O"
    aSort(aCls04,,, {|x,y|, x[nP04Arruma] + x[nP04CodEnd]                           < y[nP04Arruma] + y[nP04CodEnd] }) // Arrumacao + Endereco
    oGetD4:aCols := aClone(aCls04)
    oGetD4:Refresh()
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ InclGd02 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 20/05/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Inclusao de Amarracao Arrumacoes x Operadores.             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function InclGd02()
Local _w1
Local _w2
Local cNxtArruma := Space(04)
Local aGetEndPrc := LoadEnds(cGetEndShw)    // Carregamento Enderecos Considerar        cGetEndShw -> aGetEndPrc
Local aGetOpePrc := LoadOpes(cGetOpeShw)    // Carregamento Operadores Considerar       cGetOpeShw -> aGetOpePrc
Local aEndPrc := EndsProc(aGetEndPrc)       // Enderecos a processar                    aGetEndPrc -> aEndPrc
Local aOpePrc := OpesProc(aGetOpePrc)       // Operadores a processar                   aGetOpePrc -> aOpePrc
DbSelectArea("NNR")
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
DbSelectArea("CB1")
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
DbSelectArea("ZR1")
ZR1->(DbSetOrder(1)) // ZR1_FILIAL + ZR1_ARRUMA
If Len(aEndPrc) > 0 // Enderecos carregados    
    If Len(aOpePrc) > 0 // Operadores carregados
        // Verificar se o operador esta em alguma arrumacao com pendencia, alertar
        ZR2->(DbSetOrder(3)) // ZR2_FILIAL + ZR2_CODSTA + ZR2_CODOPE + ZR2_CODLOC + ZR2_CODEND + ZR2_ARRUMA        
        For _w1 := 1 To Len(aOpePrc) // Rodo nos operadores
            For _w2 := 1 To 2 // Rodo nos Status "01"=Agendado "02"=Em Arrumacao
                If ZR2->(DbSeek(_cFilZR2 + StrZero( _w1, 2) + aOpePrc[ _w1 ]))
                    If CB1->(DbSeek( _cFilCB1 + aOpePrc[ _w1 ] ))
                        If !MsgYesNo("Operador ainda tem arrumacao pendente!" + Chr(13) + Chr(10) + ;
                            "Operador: " + CB1->CB1_CODOPE + " " + CB1->CB1_NOME + Chr(13) + Chr(10) + ;
                            "Arrumacao: " + ZR2->ZR2_ARRUMA + Chr(13) + Chr(10) + ;
                            "Deseja prosseguir?","InclGd02")
                            Return
                        EndIf
                        _w1 := Len( aOpePrc )
                    EndIf
                EndIf
            Next
        Next
        DbSelectArea("ZR2") // Arrumacoes x Operadores
        ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
        While ZR1->(DbSeek(_cFilZR1 + (cNxtArruma := GetSXENum("ZR1","ZR1_ARRUMA")) ))
            cNxtArruma := Soma1( cNxtArruma, 4)
            ConfirmSX8()
        End
        RecLock("ZR1",.T.)
        ZR1->ZR1_FILIAL := _cFilZR1         // Filial
        ZR1->ZR1_ARRUMA := cNxtArruma       // Codigo Arrumacao
        ZR1->ZR1_PRVINI := dGetDAgIn2       // Previsao inicio
        ZR1->ZR1_PRVFIM := dGetDAgFi2       // Previsao fim
        ZR1->ZR1_CODSTA := "01"             // "01"=Agendado
        ZR1->ZR1_CODLOC := cGetArmArr       // Armazem
        ZR1->ZR1_ENDINI := cGetEndIni       // Endereco Inicial
        ZR1->ZR1_ENDFIM := cGetEndFim       // Endereco Final
        ZR1->ZR1_OPEINI := cGetOpeIni       // Operador Inicial
        ZR1->ZR1_OPEFIM := cGetOpeFim       // Operador Final
        ZR1->ZR1_ENDCON := cGetEndShw       // Enderecos Considerar
        ZR1->ZR1_OPECON := cGetOpeShw       // Operadores Considerar
        ZR1->(MsUnlock())
        For _w1 := 1 To Len(aEndPrc) // Rodo nos enderecos
            For _w2 := 1 To Len(aOpePrc) // Rodo nos operadores
                RecLock("ZR2",.T.)
                ZR2->ZR2_FILIAL := _cFilZR2                                                 // Filial
                ZR2->ZR2_ARRUMA := ZR1->ZR1_ARRUMA                                          // Arrumacao
                ZR2->ZR2_CODLOC := Iif(!Empty(cGetArmArr), cGetArmArr, aEndPrc[_w1,01])     // Armazem
                ZR2->ZR2_CODEND := aEndPrc[_w1,02]                                          // Endereco
                ZR2->ZR2_CODOPE := aOpePrc[_w2]                                             // Operador
                ZR2->ZR2_CODSTA := "01"                                                     // "01"=Agendado
                ZR2->(MsUnlock())
            Next
        Next
        LoadGd01() // Carregamento GetDados 01/03
        LoadGd02() // Carregamento GetDados 02/04
    EndIf
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ AlteGd02 ∫Autor ≥Jonathan Schmidt Alves∫ Data ≥ 20/05/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Alteracao de Amarracao Arrumacoes x Operadores.            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function AlteGd02(cOper) // Alteracao
Local _z1
Local _w1
Local _w2
Local nLin := oGetD2:nAt
Local nAdd := 0 // Registros incluidos
Local nDel := 0 // Registros excluidos
Local cMsg03 := ""
Local cMsg04 := ""
Local aGetEndPrc := {}  // Carregamento Enderecos Considerar
Local aGetOpePrc := {}  // Carregamento Operadores Considerar
Local aEndPrc := {}     // Enderecos a processar
Local aOpePrc := {}     // Operadores a processar
If cOper $ "A/C/" // "A"=Alterar "C"=Cancelar
    If oGetD2:aCols[ nLin, nP02CodSta ] $ "01/02" .Or. cOper == "C" // "01"=Agendado "02"=Em Arrumacao
        aObjects := { "oFolder:aDialogs[01]", "oGetD2:oBrowse", "oGetD4:oBrowse", "oGetDAgInc", "oGetDAgFnl", "oCmbStaArr", "oBtnPsq02", "oBtnInc02" }
        For _w1 := 1 To Len( aObjects )
            &(aObjects[_w1]):lActive := cOper <> "A"
            &(aObjects[_w1]):Refresh()
        Next
        If cOper == "A" // "A"=Alterar
            // Holds
            dHldDAgIn2 := dGetDAgIn2
            dHldDAgFi2 := dGetDAgFi2
            cHldArmArr := cGetArmArr       // Armazem
            cHldEndIni := cGetEndIni
            cHldEndFim := cGetEndFim
            cHldEndPsq := cGetEndPsq
            cHldEndDes := cGetEndDes
            cHldOpeIni := cGetOpeIni
            cHldOpeFim := cGetOpeFim
            cHldOpePsq := cGetOpePsq
            cHldOpeDes := cGetOpeDes
            cHldEndShw := cGetEndShw
            cHldOpeShw := cGetOpeShw
            cHldEndTip := oGetEndShw:cToolTip
            cHldOpeTip := oGetOpeShw:cToolTip
            // Atualizacao dos dados do panel
            cGetArmArr := oGetD2:aCols[ nLin, nP02CodLoc ]       // Armazem
            dGetDAgIn2 := oGetD2:aCols[ nLin, nP02PrvIni ]       // Previsao Inicio
            dGetDAgFi2 := oGetD2:aCols[ nLin, nP02PrvFim ]       // Previsao Fim
            cGetEndIni := oGetD2:aCols[ nLin, nP02EndIni ]       // Endereco Inicial
            cGetEndFim := oGetD2:aCols[ nLin, nP02EndFim ]       // Endereco Final
            cGetOpeIni := oGetD2:aCols[ nLin, nP02OpeIni ]       // Operador Inicial
            cGetOpeFim := oGetD2:aCols[ nLin, nP02OpeFim ]       // Operador Final
            cGetEndShw := oGetD2:aCols[ nLin, nP02EndCon ]       // Enderecos Considerar
            cGetOpeShw := oGetD2:aCols[ nLin, nP02OpeCon ]       // Operadores Considerar
            oGetEndIni:SetFocus()
        Else // Volto Holds
            dGetDAgIn2 := dHldDAgIn2
            dGetDAgFi2 := dHldDAgFi2
            cGetArmArr := cHldArmArr
            cGetEndIni := cHldEndIni
            cGetEndFim := cHldEndFim
            cGetEndPsq := cHldEndPsq
            cGetEndDes := cHldEndDes
            cGetOpeIni := cHldOpeIni
            cGetOpeFim := cHldOpeFim
            cGetOpePsq := cHldOpePsq
            cGetOpeDes := cHldOpeDes
            cGetEndShw := cHldEndShw
            cGetOpeShw := cHldOpeShw
            oGetEndShw:cToolTip := cHldEndTip
            oGetOpeShw:cToolTip := cHldOpeTip
            oGetD2:oBrowse:SetFocus()
        EndIf
        aObjects := { "oGetArmArr", "oGetDAgIn2", "oGetDAgFi2", "oGetEndIni", "oGetEndFim", "oGetOpeIni", "oGetOpeFim", "oGetEndDes", "oGetOpeDes", "oGetEndShw", "oGetOpeShw" }
        For _w1 := 1 To Len( aObjects )
            &(aObjects[_w1]):Refresh()
        Next
        // Atualizacao dos botoes
        oBtnInc02:lVisible := cOper <> "A"
        oBtnInc02:Refresh()
        oBtnAlt02:lVisible := cOper == "A"
        oBtnAlt02:Refresh()
        oBtnCan02:lVisible := cOper == "A"
        oBtnCan02:Refresh()
        MntsEnds() // Atualizacao dos objetos em tela (cGetEndPrc, cToolTip, etc)
        MntsOpes() // Atualizacao dos objetos em tela (cGetEndPrc, cToolTip, etc)
        ChckIncl()
    Else // Status invalido
        MsgStop("Status da Arrumacao invalido para alteracao!" + Chr(13) + Chr(10) + ;
        "Arrumacao: " + oGetD2:aCols[ nLin, nP02Arruma ] + Chr(13) + Chr(10) + ;
        "Status: " + oGetD2:aCols[ nLin, nP02CodSta ],"AlteGd02")
    EndIf
Else // "G"=Gravar
    For _z1 := 1 To 4
        u_AtuAsk09(nCurrent,"Alterando Amarracoes x Operadores...","", "", "", 80, "PROCESSA")
        Sleep(050)
    Next
    aGetEndPrc := LoadEnds(cGetEndShw)    // Carregamento Enderecos Considerar        cGetEndShw -> aGetEndPrc
    aGetOpePrc := LoadOpes(cGetOpeShw)    // Carregamento Operadores Considerar       cGetOpeShw -> aGetOpePrc
    aEndPrc := EndsProc(aGetEndPrc)       // Enderecos a processar                    aGetEndPrc -> aEndPrc
    aOpePrc := OpesProc(aGetOpePrc)       // Operadores a processar                   aGetOpePrc -> aOpePrc
    DbSelectArea("ZR1")
    ZR1->(DbSetOrder(1)) // ZR1_FILIAL + ZR1_ARRUMA
    If ZR1->(DbSeek( _cFilZR1 + oGetD2:aCols[ nLin, nP02Arruma ] ))
        DbSelectArea("ZR2") // Arrumacoes x Operadores
        ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
        If ZR2->(DbSeek( _cFilZR2 + ZR1->ZR1_ARRUMA ))
            While ZR2->(!EOF()) .And. ZR2->ZR2_FILIAL + ZR2->ZR2_ARRUMA == ZR1->ZR1_FILIAL + ZR1->ZR1_ARRUMA
                If ZR2->ZR2_CODSTA == "01" // "01"=Agendado
                    lVld := .T.
                    If ZR2->ZR2_CODOPE < cGetOpeIni .Or. (!Empty(cGetOpeFim) .And. ZR2->ZR2_CODOPE > cGetOpeFim) // Operador nao conforme De/Ate
                        lVld := .F.
                        If ZR2->ZR2_CODSTA == "01"
                            RecLock("ZR2",.F.)
                            ZR2->(DbDelete())
                            ZR2->(MsUnlock())
                        EndIf
                    Else
                        If Len( aOpePrc ) > 0 // Operadores considerar
                            If ASCan( aOpePrc, {|x|, !(" -> " $ x) .And. Left(x,6) == ZR2->ZR2_CODOPE }) > 0 // Operador conforme
                                // Considerar
                            ElseIf Len( aOpePrc ) > 0 .And. ASCan( aOpePrc, {|x|, " -> " $ x .And. ZR2->ZR2_CODOPE >= Left(x,6) .And. ZR2->ZR2_CODOPE <= Right(x,6) }) > 0 // Operador conforme Range
                                // Considerar
                            Else
                                lVld := .F.
                                If ZR2->ZR2_CODSTA == "01"
                                    RecLock("ZR2",.F.)
                                    ZR2->(DbDelete())
                                    ZR2->(MsUnlock())
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                    If lVld // Operador valido, avaliar enderecos
                        SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
                        If SBE->(DbSeek(_cFilSBE + ZR2->ZR2_CODLOC + ZR2->ZR2_CODEND,.T.))
                            If SBE->BE_LOCALIZ < cGetEndIni .Or. (!Empty(cGetEndFim) .And. SBE->BE_LOCALIZ > cGetEndFim) // Endereco nao conforme De/Ate
                                If ZR2->ZR2_CODSTA == "01"
                                    RecLock("ZR2",.F.)
                                    ZR2->(DbDelete())
                                    ZR2->(MsUnlock())
                                EndIf
                            ElseIf ASCan(aEndPrc, {|x|, x[01] == SBE->BE_LOCAL .And. x[02] == SBE->BE_LOCALIZ }) > 0 // Endereco conforme
                                // Considerar
                            Else // Remover
                                lVld := .F.
                                RecLock("ZR2",.F.)
                                ZR2->(DbDelete())
                                ZR2->(MsUnlock())
                            EndIf
                        EndIf
                    EndIf
                EndIf
                ZR2->(DbSkip())
            End
        EndIf
        DbSelectArea("ZR3") // Cadastro de Arrumacoes
        ZR3->(DbSetOrder(1)) // ZR3_FILIAL + ZR3_ARRUMA + ZR3_CODLOC + ZR3_CODEND + ZR3_CODPRO
        DbSelectArea("ZR2") // Arrumacoes x Operadores
        ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
        For _w1 := 1 To Len(aEndPrc) // Rodo nos enderecos
            For _w2 := 1 To Len(aOpePrc) // Rodo nos operadores
                lGrvZR2 := .F.
                If ZR2->(DbSeek(_cFilZR2 + ZR1->ZR1_ARRUMA + aEndPrc[_w1,01] + aEndPrc[_w1,02] + aOpePrc[_w2]))
                    If ZR2->ZR2_CODSTA == "01" // "01"=Agendado
                        lGrvZR2 := .T.
                        RecLock("ZR2",.F.)
                    EndIf
                ElseIf ZR3->(!DbSeek(_cFilZR3 + ZR1->ZR1_ARRUMA + aEndPrc[_w1,01] + aEndPrc[_w1,02])) // Se ja tem processamento dessa Arrumacao + Armazem + Endereco... algum operador ja esta tratando
                    lGrvZR2 := .T.
                    RecLock("ZR2",.T.)
                    ZR2->ZR2_FILIAL := _cFilZR2             // Filial
                    ZR2->ZR2_ARRUMA := ZR1->ZR1_ARRUMA      // Arrumacao
                    nAdd++ // Incremento inclusoes ZR2
                EndIf
                If lGrvZR2 // .T.=Gravar
                    ZR2->ZR2_CODLOC := aEndPrc[_w1,01]      // Armazem
                    ZR2->ZR2_CODEND := aEndPrc[_w1,02]      // Endereco
                    ZR2->ZR2_CODOPE := aOpePrc[_w2]         // Operador
                    ZR2->ZR2_CODSTA := "01"                 // "01"=Agendado
                    ZR2->(MsUnlock())
                EndIf
            Next
        Next
        RecLock("ZR1",.F.)
        ZR1->ZR1_CODLOC := cGetArmArr       // Armazem
        ZR1->ZR1_PRVINI := dGetDAgIn2       // Previsao inicio
        ZR1->ZR1_PRVFIM := dGetDAgFi2       // Previsao fim
        ZR1->ZR1_ENDINI := cGetEndIni       // Endereco Inicial
        ZR1->ZR1_ENDFIM := cGetEndFim       // Endereco Final
        ZR1->ZR1_OPEINI := cGetOpeIni       // Operador Inicial
        ZR1->ZR1_OPEFIM := cGetOpeFim       // Operador Final
        ZR1->ZR1_ENDCON := cGetEndShw       // Enderecos Considerar
        ZR1->ZR1_OPECON := cGetOpeShw       // Operadores Considerar
        ZR1->(MsUnlock())
        If nAdd > 0
            cMsg03 := "Amarracoes incluidas: " + cValToChar(nAdd)
        EndIf
        If nDel > 0
            If Empty(cMsg03)
                cMsg03 := "Amarracoes excluidas: " + cValToChar(nDel)
            Else
                cMsg04 := "Amarracoes excluidas: " + cValToChar(nDel)
            EndIf
        EndIf
        If Empty(cMsg03) .And. Empty(cMsg04)
            cMsg03 := "Nenhuma amarracao foi incluida ou excluida!"
        EndIf
        For _z1 := 1 To 4
            u_AtuAsk09(nCurrent,"Alterando Amarracoes x Operadores... Concluido!",cMsg03, cMsg04, "", 80, "OK")
            Sleep(150)
        Next
        // Volto os holds
        dGetDAgIn2 := dHldDAgIn2
        dGetDAgFi2 := dHldDAgFi2
        cGetArmArr := cHldArmArr
        cGetEndIni := cHldEndIni
        cGetEndFim := cHldEndFim
        cGetEndPsq := cHldEndPsq
        cGetEndDes := cHldEndDes
        cGetOpeIni := cHldOpeIni
        cGetOpeFim := cHldOpeFim
        cGetOpePsq := cHldOpePsq
        cGetOpeDes := cHldOpeDes
        cGetEndShw := cHldEndShw
        cGetOpeShw := cHldOpeShw
        oGetEndShw:cToolTip := cHldEndTip
        oGetOpeShw:cToolTip := cHldOpeTip
        oGetD2:oBrowse:SetFocus()
        aObjects := { "oGetArmArr", "oGetDAgIn2", "oGetDAgFi2", "oGetEndIni", "oGetEndFim", "oGetOpeIni", "oGetOpeFim", "oGetEndDes", "oGetOpeDes", "oGetEndShw", "oGetOpeShw" }
        For _w1 := 1 To Len( aObjects )
            &(aObjects[_w1]):Refresh()
        Next
        aObjects := { "oFolder:aDialogs[01]", "oGetD2:oBrowse", "oGetD4:oBrowse", "oGetDAgInc", "oGetDAgFnl", "oCmbStaArr", "oBtnPsq02", "oBtnInc02" }
        For _w1 := 1 To Len( aObjects )
            &(aObjects[_w1]):lActive := .T.
            &(aObjects[_w1]):Refresh()
        Next
        // Atualizacao dos botoes
        oBtnInc02:lVisible := .T.
        oBtnInc02:Refresh()
        oBtnAlt02:lVisible := .F.
        oBtnAlt02:Refresh()
        oBtnCan02:lVisible := .F.
        oBtnCan02:Refresh()
        LoadGd01() // Carregamento GetDados 01/03
        LoadGd02() // Carregamento GetDados 02/04
        ChckIncl() // Check de inclusao
    EndIf
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ EndsGd01 ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Encerra arrumacao.                                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function EndsGd01()
Local nLin := oGetD1:nAt
If nLin > 0 .And. nLin <= Len(oGetD1:aCols)
    If oGetD1:aCols[ nLin, nP01CodSta ] $ "01/02" // "01"=Agendado "02"=Em Arrumacao
        DbSelectArea("ZR1")
        ZR1->(DbSetOrder(1)) // ZR1_FILIAL + ZR1_ARRUMA
        If ZR1->(DbSeek( _cFilZR1 + oGetD1:aCols[ nLin, nP01Arruma ] ))
            If MsgYesNo("Confirma encerramento da Arrumacao?","EndsGd01")
                RecLock("ZR1",.F.)
                ZR1->ZR1_CODSTA := "05" // "05"=Encerrado
                ZR1->(MsUnlock())
                DbSelectArea("ZR2") // Arrumacoes x Operadores
                ZR2->(DbSetOrder(1)) // ZR2_FILIAL + ZR2_ARRUMA + ZR2_CODLOC + ZR2_CODEND + ZR2_CODOPE
                If ZR2->(DbSeek( _cFilZR2 + ZR1->ZR1_ARRUMA ))
                    While ZR2->(!EOF()) .And. ZR2->ZR2_FILIAL + ZR2->ZR2_ARRUMA == ZR1->ZR1_FILIAL + ZR1->ZR1_ARRUMA
                        If ZR2->ZR2_CODSTA $ "01/02/03/" // "01"=Agendado "02"=Em Arrumacao "03"=Em Processamento
                            RecLock("ZR2",.F.)
                            ZR2->ZR2_CODSTA := "05" // "05"=Encerrado
                            ZR2->(MsUnlock())
                        EndIf
                        ZR2->(DbSkip())
                    End
                EndIf
                oGetD1:aCols[ nLin, nP01CodSta ] := ZR1->ZR1_CODSTA
                oGetD1:Refresh()
                LoadGd01() // Carregamento GetDados 01/03
                LoadGd02() // Carregamento GetDados 02/04
                ChckIncl() // Check de inclusao
            EndIf
        EndIf
    Else // Status
        MsgStop("Status da Arrumacao invalido para encerramento!" + Chr(13) + Chr(10) + ;
        "Arrumacao: " + oGetD1:aCols[ nLin, nP01Arruma ] + Chr(13) + Chr(10) + ;
        "Status: " + oGetD1:aCols[ nLin, nP01CodSta ],"EndsGd01")
    EndIf
EndIf
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadsHdr ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 01/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para recarregamento dos headers.                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadsHdr(cHdr)
If cHdr == "01" // 01=ZR1 Cadastro de Arrumacoes
    aAdd(aHdr01, { "Status",       		            "I01_CODSTA",	"",					    02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "01=01: Agendado;02=02: Em Arrumacao;04=04: Concluido;05=05: Encerrado", "" }) // 01
    aAdd(aHdr01, { "Arrumacao",             		"I01_ARRUMA",	"",						04, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr01, { "Prev Ini",                 		"I01_PRVINI",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 03
    aAdd(aHdr01, { "Prev Fim",                 		"I01_PRVFIM",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 04
    aAdd(aHdr01, { "Armazem",                 		"I01_CODLOC",	"",						02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 05
    aAdd(aHdr01, { "End Ini",                 		"I01_ENDINI",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 06
    aAdd(aHdr01, { "End Fim",                 		"I01_ENDFIM",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 07
    aAdd(aHdr01, { "Oper Ini",                 		"I01_OPEINI",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 08
    aAdd(aHdr01, { "Oper Fim",                 		"I01_OPEFIM",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 09
    aAdd(aHdr01, { "Enderecos",                     "I01_ENDCON",	"",					   200, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 10
    aAdd(aHdr01, { "Operadores",               		"I01_OPECON",	"",					   200, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 11
    aAdd(aHdr01, { "Recno ZR1",               		"I01_RECZR1",	"",					    08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "N", "",		"R", "", "" }) // 12
ElseIf cHdr == "03" // 03=ZR3 Processamentos Arrumacoes
    aAdd(aHdr03, { "Status",						"I03_CODSTA",	"",						02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "P1=P1: Pendente;A1=A1: Adequado;D1=D1: Divergencia produto nao encontrado;D2=D2: Divergencia produto a mais;A2=A2: Aprovado Auditor;R1=R1: Reprovado Auditor", "" }) // 01
    aAdd(aHdr03, { "Arrumacao",             		"I03_ARRUMA",	"",						04, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr03, { "Armazem",						"I03_CODLOC",	"",						02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr03, { "Endereco",						"I03_CODEND",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr03, { "Produto",						"I03_CODPRO",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr03, { "Descricao Produto",     		"I03_DESPRO",	"",						40, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr03, { "Cod Operador",             		"I03_CODOPE",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr03, { "Nome Operador",					"I03_NOMOPE",	"",						30, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 05
    aAdd(aHdr03, { "Data Exec",             		"I03_DATEXE",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 06
    aAdd(aHdr03, { "Hora Exec",			    		"I03_HOREXE",	"@R 99:99:99",			06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 07
    aAdd(aHdr03, { "Status Operador",	            "I03_STAOPE",	"",					    02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "P1=P1: Pendente;A1=A1: Adequado;D1=D1: Divergencia produto nao encontrado;D2=D2: Divergencia produto a mais", "" }) // 13
    aAdd(aHdr03, { "Cod Auditor",             		"I03_CODAUD",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 08
    aAdd(aHdr03, { "Nome Auditor",					"I03_NOMAUD",	"",						30, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 09
    aAdd(aHdr03, { "Status Aud",   		            "I03_STAAUD",	"",					    02, 00, "u_VlStaAud()",     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "N0=N0: Nao auditado;A2=A2: Aprovado Auditor;R1=R1: Reprovado Auditor", "" }) // 12
    aAdd(aHdr03, { "Obs Aud",        		        "I03_OBSAUD",	"",					    02, 00, "u_VlObsAud()",     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "I1=I1: Limpeza inadequada;I2=I2: Limpeza/OrganizaÁ„o inadequada;A1=A1: Limpeza/OrganizaÁ„o adequada", "" }) // 13
    aAdd(aHdr03, { "Data Aud",             		    "I03_DATAUD",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 10
    aAdd(aHdr03, { "Hora Aud",			    		"I03_HORAUD",	"@R 99:99:99",			06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 11
    aAdd(aHdr03, { "Observacoes",     		        "I03_OBSLIV",	"",					   200, 00, "u_VlObLAud()",     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 14
    aAdd(aHdr03, { "Recno ZR3",               		"I01_RECZR3",	"",					    08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "N", "",		"R", "", "" }) // 15
ElseIf cHdr == "02" // 02=ZR1 Arrumacoes
    aAdd(aHdr02, { "Status",       		            "I02_CODSTA",	"",					    02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "01=01: Agendado;02=02: Em Arrumacao;04=04: Concluido;05=05: Encerrado", "" }) // 01
    aAdd(aHdr02, { "Arrumacao",             		"I02_ARRUMA",	"",						04, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr02, { "Prev Ini",                 		"I02_PRVINI",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 03
    aAdd(aHdr02, { "Prev Fim",                 		"I02_PRVFIM",	"",						08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "D", "",		"R", "", "" }) // 04
    aAdd(aHdr02, { "Armazem",                 		"I02_CODLOC",	"",						02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 05
    aAdd(aHdr02, { "End Ini",                 		"I02_ENDINI",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 06
    aAdd(aHdr02, { "End Fim",                 		"I02_ENDFIM",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 07
    aAdd(aHdr02, { "Oper Ini",                 		"I02_OPEINI",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 08
    aAdd(aHdr02, { "Oper Fim",                 		"I02_OPEFIM",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 09
    aAdd(aHdr02, { "Enderecos",                     "I02_ENDCON",	"",					   200, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 10
    aAdd(aHdr02, { "Operadores",               		"I02_OPECON",	"",					   200, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 11
    aAdd(aHdr02, { "Recno ZR1",               		"I01_RECZR1",	"",					    08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "N", "",		"R", "", "" }) // 12
ElseIf cHdr == "04" // 04=ZR2 Arrumacoes x Operadores
    aAdd(aHdr04, { "Status",       		            "I04_CODSTA",	"",					    01, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "01=01: Agendado;02=02: Em Arrumacao;03=03: Em Processamento;04=04: Concluido;05=05: Encerrado", "" }) // 01
    aAdd(aHdr04, { "Arrumacao",						"I04_ARRUMA",	"",						04, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr04, { "Armazem",						"I04_CODLOC",	"",						02, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr04, { "Endereco",						"I04_CODEND",	"",						15, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr04, { "Cod Operador",             		"I04_CODOPE",	"",						06, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 05
    aAdd(aHdr04, { "Nome Operador",					"I04_NOMOPE",	"",						30, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "C", "",		"R", "", "" }) // 06
    aAdd(aHdr04, { "Recno ZR2",               		"I01_RECZR2",	"",					    08, 00, ".F.",				"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†", "N", "",		"R", "", "" }) // 07
EndIf
Return &("aHdr" + cHdr)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadCols ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 01/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento do aCols conforme padrao do aHdr01 passado.   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadCols(aHdr01) // Criador de aCols
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

Static Function OrdShw04() // Ordenacao GetDados 01
aSort(oGetD1:aCols,,, aCmbOrdMnt[ oCmbOrdShw:nAt, 02 ])
oGetD1:Refresh()
Return

Static Function VldArm04(cReadVar) // Validacao do Armazem
Local lRet := .T.
Default cReadVar := ReadVar()
DbSelectArea("NNR")
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
If !Empty(&(cReadVar)) .And. NNR->(!DbSeek(_cFilNNR + &(cReadVar)))
    MsgStop("Armazem nao encontrado no cadastro (NNR)!" + Chr(13) + Chr(10) + ;
    "Armazem: " + &(cReadVar) + Chr(13) + Chr(10) + ;
    "Preencha um armazem valido e tente novamente!","VldArm04")
    lRet := .F.
EndIf
Return lRet

Static Function VldEnd04() // Validacao de Endereco
Local lRet := .T.
Local cReadVar := ReadVar()
If !Empty(&(cReadVar)) // Endereco preenchido
    If !Empty( cGetArmArr )
        DbSelectArea("SBE")
        SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
        If SBE->(!DbSeek( _cFilSBE + cGetArmArr + &(cReadVar) ))
            MsgAlert("Endereco nao encontrado no cadastro (SBE)!" + Chr(13) + Chr(10) + ;
            "Armazem/Endereco: " + cGetArmArr + "/" + &(cReadVar),"VldEnd04")
            lRet := .F.
        EndIf
    Else
        DbSelectArea("SBE")
        SBE->(DbSetOrder(9)) // BE_FILIAL + BE_LOCALIZ
        If SBE->(!DbSeek( _cFilSBE + &(cReadVar) ))
            MsgAlert("Endereco nao encontrado no cadastro (SBE)!" + Chr(13) + Chr(10) + ;
            "Endereco: " + &(cReadVar),"VldEnd04")
            lRet := .F.
        EndIf
    EndIf
    If lRet // Ainda valido
        If !(SBE->BE_STATUS $ "3/4/5/6/") // 1=Desocupado;2=Ocupado;3=Bloqueado;4=Bloqueio Entrada;5=Bloqueio SaÌda;6=Bloqueio Invent·rio
            If SBE->BE_XBLOQ == "S" // Endereco bloqueado
                MsgAlert("Endereco bloqueado para utilizacao (BE_XBLOQ)!" + Chr(13) + Chr(10) + ;
                "Endereco: " + SBE->BE_LOCALIZ + Chr(13) + Chr(10) + ;
                "Bloqueado: " + SBE->BE_XBLOQ,"VldEnd04")
            EndIf
        Else // Endereco com problema de status
            MsgAlert("Endereco com status invalido para utilizacao (BE_STATUS)!" + Chr(13) + Chr(10) + ;
            "Endereco: " + SBE->BE_LOCALIZ + Chr(13) + Chr(10) + ;
            "Status: " + SBE->BE_STATUS,"VldEnd04")
        EndIf
        If lRet // Endereco valido
            If "PSQ" $ Upper(cReadVar)
                cGetEndDes := Iif(!Empty(SBE->BE_DESCRIC), SBE->BE_DESCRIC, "ENDERECO " + SBE->BE_LOCALIZ)
            EndIf
        EndIf
    EndIf
ElseIf "PSQ" $ Upper(cReadVar)
    cGetEndDes := Space(30)
EndIf
oGetEndDes:Refresh()
If lRet // Valido
    ChckIncl()
EndIf
Return lRet

Static Function VldOpe04() // Validacao do Operador
Local lRet := .T.
Default cReadVar := ReadVar()
DbSelectArea("CB1")
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
If !Empty(&(cReadVar))
    If CB1->(!DbSeek(_cFilCB1 + &(cReadVar)))
        MsgAlert("Operador nao encontrado no cadastro (CB1)!" + Chr(13) + Chr(10) + ;
        "Operador: " + &(cReadVar),"VldOpe04")
        lRet := .F.
    ElseIf "PSQ" $ Upper(cReadVar)
        cGetOpeDes := CB1->CB1_NOME
    EndIf
ElseIf "PSQ" $ Upper(cReadVar)
    cGetOpeDes := Space(30)
EndIf
oGetOpeDes:Refresh()
If lRet // Valido
    ChckIncl()
EndIf
Return lRet

User Function VlStaAud() // Validacao do Status Auditor
Local lRet := .T.
Local nLin := oGetD3:nAt
If nLin > 0 .And. nLin <= Len( oGetD3:aCols )
    oGetD3:aCols[ nLin, nP03StaAud ] := &(ReadVar())
    ChckAudi(nLin)
EndIf
Return lRet

User Function VlObsAud() // Validacao Observacao Auditor
Local lRet := .T.
Local nLin := oGetD3:nAt
If nLin > 0 .And. nLin <= Len( oGetD3:aCols )
    oGetD3:aCols[ nLin, nP03ObsAud ] := &(ReadVar())
    ChckAudi(nLin)
EndIf
Return lRet

User Function VlObLAud() // Validacao Observacao Livre Auditor
Local lRet := .T.
Local nLin := oGetD3:nAt
If nLin > 0 .And. nLin <= Len( oGetD3:aCols )
    oGetD3:aCols[ nLin, nP03ObsLiv ] := &(ReadVar())
    ChckAudi(nLin)
EndIf
Return lRet

Static Function ChgObsF8() // Atalho F8 atualiza Status Auditor
Local nLin := oGetD3:nAt
Local nOpt := 0
Local cOpt := "N0"
Local aOpt := { { "N0", "Nao Auditado" }, { "A2", "Aprovado Auditor" }, { "R1", "Reprovado Auditor" } }
If nLin > 0 .And. nLin <= Len( oGetD3:aCols )
    If Empty( oGetD3:aCols[ nLin, nP03StaAud ] )
        cOpt := aOpt[ 01, 01 ]
    ElseIf (nOpt := ASCan( aOpt, {|x|, x[01] == oGetD3:aCols[ nLin, nP03StaAud ] })) > 0
        If nOpt == Len( aOpt )
            cOpt := aOpt[ 01, 01 ]
        Else
            cOpt := aOpt[ nOpt + 1, 01 ]
        EndIf
    Else // Excecao
        cOpt := aOpt[ 01, 01 ]
    EndIf
    oGetD3:aCols[ nLin, nP03StaAud ] := cOpt // Status Auditor
    ChckAudi(nLin)
EndIf
Return

Static Function ChgObsF9() // Atalho F9 atualiza Observacao Auditor
Local nLin := oGetD3:nAt
Local nOpt := 0
Local cOpt := "N0"
Local aOpt := { { "I1", "Limpeza inadequada" }, { "I2", "Limpeza/OrganizaÁ„o inadequada" }, { "A1", "Limpeza/OrganizaÁ„o adequada" } }
If nLin > 0 .And. nLin <= Len( oGetD3:aCols )
    If Empty( oGetD3:aCols[ nLin, nP03ObsAud ] )
        cOpt := aOpt[ 01, 01 ]
    ElseIf (nOpt := ASCan( aOpt, {|x|, x[01] == oGetD3:aCols[ nLin, nP03ObsAud ] })) > 0
        If nOpt == Len( aOpt )
            cOpt := aOpt[ 01, 01 ]
        Else
            cOpt := aOpt[ nOpt + 1, 01 ]
        EndIf
    Else // Excecao
        cOpt := aOpt[ 01, 01 ]
    EndIf
    oGetD3:aCols[ nLin, nP03ObsAud ] := cOpt // Observacao Auditor
    ChckAudi(nLin)
EndIf
Return

Static Function ChckAudi(nLin)
ZR3->(DbGoto( oGetD3:aCols[ nLin, nP03RecZR3 ] ))
If ZR3->(!EOF()) // Posicionado
    RecLock("ZR3",.F.)
    ZR3->ZR3_CODAUD := cCodAud
    ZR3->ZR3_DATAUD := Date()
    ZR3->ZR3_HORAUD := StrTran(Time(),":","")
    ZR3->ZR3_STAAUD := oGetD3:aCols[ nLin, nP03StaAud ]         // Status Auditor
    ZR3->ZR3_OBSAUD := oGetD3:aCols[ nLin, nP03ObsAud ]         // Observacao Auditor
    ZR3->ZR3_OBSLIV := oGetD3:aCols[ nLin, nP03ObsLiv ]         // Observacao Livre
    ZR3->(MsUnlock())
    oGetD3:aCols[ nLin, nP03CodAud ] := ZR3->ZR3_CODAUD         // Codigo Auditor
    oGetD3:aCols[ nLin, nP03NomAud ] := cNomAud                 // Nome Auditor
    oGetD3:aCols[ nLin, nP03DatAud ] := ZR3->ZR3_DATAUD         // Data
    oGetD3:aCols[ nLin, nP03HorAud ] := ZR3->ZR3_HORAUD         // Hora

    If ZR3->ZR3_STAAUD $ "A2/R1/" // A2=Aprovado Auditor R1=Reprovado Auditor
        oGetD3:aCols[ nLin, nP03CodSta ] := ZR3->ZR3_STAAUD
    Else
        oGetD3:aCols[ nLin, nP03CodSta ] := ZR3->ZR3_STAOPE
    EndIf

EndIf
oGetD3:Refresh()
Return

Static Function ChckIncl() // Check de inclusao
Local lInc := .F.
// Armazem
oGetArmArr:lActive := !( !Empty( cGetEndIni ) .Or. !Empty( cGetEndFim ) .Or. !Empty( cGetEndShw ) ) // Algum endereco para filtrar
oGetArmArr:Refresh()
// Botao Incluir
If (!Empty(cGetEndIni) .Or. !Empty(cGetEndFim) .And. cGetEndIni <= cGetEndFim) .Or. !Empty(cGetEndShw) // Enderecos conforme
    If (!Empty(cGetOpeIni) .Or. !Empty(cGetOpeFim) .And. cGetOpeIni <= cGetOpeFim) .Or. !Empty(cGetOpeShw) // Operadores conforme
        lInc := .T.
    EndIf
EndIf
// Botao inclusao
oBtnInc02:lActive := lInc // Fields para inclusao com preenchimento ok
oBtnInc02:Refresh()
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ PrcElems ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 02/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao de processamento de campos filtro do Endereco ou do ∫±±
±±∫          ≥ Operador permitindo multiplos registros.                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Parametros:                                                ∫±±
±±∫          ≥ cFld: Field de processamento                               ∫±±
±±∫          ≥       Exemplos: Dep: Departamentos                         ∫±±
±±∫          ≥                 Prj: Projeto                               ∫±±
±±∫          ≥                 Ite: Item Contabil (Contrato)              ∫±±
±±∫          ≥                 Cli: Cliente                               ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ cPrc: Processamento                                        ∫±±
±±∫          ≥       Exemplos: Add: Adicao de elemento                    ∫±±
±±∫          ≥                 Rem: Remocao de elemento                   ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥ cTip: Tipo de filtro                                       ∫±±
±±∫          ≥       Exemplos: Shw: Filtro a considerar                   ∫±±
±±∫          ≥                 Hde: Filtro a desconsiderar                ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function PrcElems(cFld, cPrc, cTip)
Local y
Local cProc := "" // L=Limpeza geral P=Preenchido
Local _cGetEndPrc := ""
Local aGetEndPrc := {}
Local _cGetOpePrc := ""
Local aGetOpePrc := {}
Local cToolTip := ""
If cFld == "End" // Enderecos
    If !Empty(cGetArmArr)
        DbSelectArea("SBE")
        SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
    Else
        DbSelectArea("SBE")
        SBE->(DbSetOrder(9)) // BE_FILIAL + BE_LOCALIZ
    EndIf
    If cPrc == "Add"
        If Empty(cGetEndPsq) .And. Empty(cGetEndIni) .And. Empty(cGetEndFim) // Nao preenchido e eh uma Adicao
            MsgStop("Endereco(s) nao preenchido para inclusao!" + Chr(13) + Chr(10) + ;
            "Preencha os Enderecos De/Ate ou o codigo na pesquisa acima!","PrcElem4")
        ElseIf !Empty(cGetEndPsq) // Pesquisa
            cProc := "P1" // "P"=Pesq... segue normal
        Else // Range
            cProc := "R1" // "R"=Range... segue normal
        EndIf
    ElseIf cPrc == "Rem"
        If Empty(&("cGetEnd" + cTip))
            MsgStop("Nao ha dados para limpeza dos enderecos para processamento!","PrcElem4")
        Else
            If !Empty(cGetEndIni) .Or. !Empty(cGetEndFim) // Preenchido e eh uma Remocao
                cProc := "C2" // "C2"=Clear Range
            ElseIf !Empty(cGetEndPsq) // Preenchido... limpeza da pesquisa
                cProc := "C1" // "C1"=Clear Pesquisa
            Else // Nao preenchido.. limpeza geral do objeto
                cProc := "C3" // "C"=Clear
                cGetEndPrc := "" // Limpo
            EndIf
        EndIf
    EndIf
    If !Empty(cProc) //  Iniciamos processamento... "P"=Incluir via Pesquisa, "R"=Incluir via Range, "C"=Clear
        // Enderecos/Ranges ja considerados
        _cGetEndPrc := &("cGetEnd" + cTip)
        aGetEndPrc := Iif(!Empty(_cGetEndPrc), StrToKarr(_cGetEndPrc,","), {})
        For y := 1 To Len(aGetEndPrc)
            If " -> " $ aGetEndPrc[y] // De Ate
                aGetEndPrc[y] := PadR(SubStr(aGetEndPrc[y], 01, At("->",aGetEndPrc[y]) - 2),18) + " -> " + PadR(SubStr(aGetEndPrc[y], At("->",aGetEndPrc[y]) + 3, 18),18)
            Else // Pesquisa
                aGetEndPrc[y] := PadR(aGetEndPrc[y],18)
            EndIf
        Next
        If cPrc == "Add"
            If cProc == "P1" // "P1"=Pesqu... validar
                cProc := ""
                If !Empty(cGetEndPsq) .And. !Empty( cGetArmArr ) .And. SBE->(!DbSeek(_cFilSBE + cGetArmArr + cGetEndPsq))
                    MsgStop("Endereco nao encontrado no cadastro (SBE)!" + Chr(13) + Chr(10) + ;
                    "Armazem/Endereco: " + cGetArmArr + "/" + cGetEndPsq + Chr(13) + Chr(10) + ;
                    "Verifique o endereco e tente novamente!","PrcElem4")
                ElseIf !Empty(cGetEndPsq) .And. Empty( cGetArmArr ) .And. SBE->(!DbSeek(_cFilSBE + cGetEndPsq))
                    MsgStop("Endereco nao encontrado no cadastro (SBE)!" + Chr(13) + Chr(10) + ;
                    "Endereco: " + cGetEndPsq + Chr(13) + Chr(10) + ;
                    "Verifique o endereco e tente novamente!","PrcElem4")
                Else // Endereco localizado
                    If Len(aGetEndPrc) == 20 // Limite atingido
                        MsgStop("Limite de Enderecos para processamento atingido!" + Chr(13) + Chr(10) + ;
                        "Limite maximo de 20 Enderecos/Ranges no mesmo processamento!","PrcElem4")
                    Else // Limite ok...
                        If Len(aGetEndPrc) > 0 .And. ASCan(aGetEndPrc, {|x|, x == SBE->BE_LOCAL + "/" + SBE->BE_LOCALIZ }) > 0
                            MsgStop("Endereco ja foi incluido neste processamento!" + Chr(13) + Chr(10) + ;
                            "Armazem/Endereco: " + SBE->BE_LOCAL + "/" + SBE->BE_LOCALIZ,"PrcElem4")
                        Else // Considerando entao...
                            cProc := "P1" // "P1"=Pesqu... Processamento...
                            cGetEndPrc := _cGetEndPrc // Atual
                            cGetEndPrc := Iif(!Empty(cGetEndPrc), RTrim(cGetEndPrc) + ",", "") + RTrim( Iif(!Empty( cGetArmArr ), cGetArmArr, "??") + "/" + SBE->BE_LOCALIZ) // Atualizado
                            aAdd(aGetEndPrc, Iif(!Empty( cGetArmArr ), cGetArmArr, "??") + "/" + SBE->BE_LOCALIZ) // Incluo na matriz
                        EndIf
                    EndIf
                EndIf
            ElseIf cProc == "R1" // "R1"=Range De/Ate
                cProc := ""
                nEnds := 0
                If !Empty( cGetArmArr )
                    SBE->(DbSeek(_cFilSBE + cGetArmArr + cGetEndIni,.T.))
                    While SBE->(!EOF()) .And. SBE->BE_FILIAL + SBE->BE_LOCAL + SBE->BE_LOCALIZ <= _cFilSBE + cGetArmArr + cGetEndFim
                        nEnds++
                        SBE->(DbSkip())
                    End
                Else
                    SBE->(DbSeek(_cFilSBE + cGetEndIni,.T.))
                    While SBE->(!EOF()) .And. SBE->BE_FILIAL + SBE->BE_LOCALIZ <= _cFilSBE + cGetEndFim
                        nEnds++
                        SBE->(DbSkip())
                    End
                EndIf
                If (nFnd := ASCan(aGetEndPrc, {|x|, x == Iif(!Empty(cGetArmArr),cGetArmArr,"??") + "/" + cGetEndIni + " -> " + Iif(!Empty(cGetArmArr),cGetArmArr,"??") + "/" + cGetEndFim })) > 0 // Range ja existe
                    MsgStop("Enderecos ja foi incluidos neste processamento!" + Chr(13) + Chr(10) + ;
                    "Armazem/Endereco De/Ate: " + aGetEndPrc[nFnd],"PrcElem4")
                Else // Ainda nao considerado
                    If Len(aGetEndPrc) == 20 // Limite atingido
                        MsgStop("Limite de Enderecos para processamento atingido!" + Chr(13) + Chr(10) + ;
                        "Limite maximo de 20 Enderecos/Ranges no mesmo processamento!","PrcElem4")
                    Else // Incluir
                        cProc := "R1" // "R1"=Range
                        cGetEndPrc := Iif(!Empty(cGetArmArr),cGetArmArr,"??") + "/" + cGetEndIni + " -> " + Iif(!Empty(cGetArmArr),cGetArmArr,"??") + "/" + cGetEndFim // Atualizado
                        aAdd(aGetEndPrc, cGetEndPrc) // Incluo na matriz
                    EndIf
                EndIf
            EndIf
        ElseIf cPrc == "Rem" // Remover
            If cProc == "C1" // "C1"=Clear de Pesquisa
                cProc := ""
                If Len(aGetEndPrc) == 0 // Nao foram carregados
                    MsgStop("Nao existe nenhum endereco carregado para remover!","PrcElem4")
                ElseIf !Empty( cGetArmArr ) .And. (nPosR := ASCan(aGetEndPrc, {|x|, x == SBE->BE_LOCAL + "/" + SBE->BE_LOCALIZ })) == 0 // Nao encontrado
                    MsgStop("Armazem/Endereco nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Armazem/Endereco: " + SBE->BE_LOCAL + "/" + SBE->BE_LOCALIZ,"PrcElem4")
                ElseIf Empty( cGetArmArr ) .And. (nPosR := ASCan(aGetEndPrc, {|x|, x == "??" + "/" + SBE->BE_LOCALIZ })) == 0 // Nao encontrado
                    MsgStop("Endereco nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Endereco: " + SBE->BE_LOCALIZ,"PrcElem4")
                Else // Removendo
                    cProc := "C1" // "C2"=Clear
                EndIf
            ElseIf cProc == "C2" // "C2"=Clear de Range De/Ate
                cProc := ""
                If Len(aGetEndPrc) == 0 // Nao foram carregados
                    MsgStop("Nao existe nenhum endereco carregado para remover!","PrcElem4")
                ElseIf !Empty( cGetArmArr ) .And. (nPosR := ASCan(aGetEndPrc, {|x|, x == cGetArmArr + "/" + cGetEndIni + " -> " + cGetArmArr + "/" + cGetEndFim })) == 0 // Range nao encontrado
                    MsgStop("Armazem/Endereco De/Ate nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Armazem/Endereco De/Ate: " + cGetArmArr + "/" + cGetEndIni + " -> " + cGetArmArr + "/" + cGetEndFim,"PrcElem4")
                ElseIf Empty( cGetArmArr ) .And. (nPosR := ASCan(aGetEndPrc, {|x|, x == "??" + "/" + cGetEndIni + " -> " + "??" + "/" + cGetEndFim })) == 0 // Range nao encontrado
                    MsgStop("Endereco De/Ate nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Endereco De/Ate: " + "??" + "/" + cGetEndIni + " -> " + "??" + "/" + cGetEndFim,"PrcElem4")
                Else
                    cProc := "C2" // "C1"=Clear de Range
                EndIf
            Else // "C3"=Clear geral
                cGetEndPrc := ""
                aGetEndPrc := {}
            EndIf
        EndIf
        If cProc $ "P1/R1/C1/C2/C3/" // Processamento Validado "P"=Pesquisa, "R"=Range, "C"=Clear... refresh
            If Len(aGetEndPrc) > 0
                If cProc $ "C1/C2/" // "C1/C2"=Clear de elemento
                    aDel(aGetEndPrc, nPosR)
                    aSize(aGetEndPrc, Len(aGetEndPrc) - 1)
                    If Len(aGetEndPrc) > 0 // Ainda tem elementos
                        cGetEndPrc := ""
                        For y := 1 To Len(aGetEndPrc)
                            cGetEndPrc += RTrim(aGetEndPrc[y]) + ","
                        Next
                        cGetEndPrc := Left(cGetEndPrc, Len(cGetEndPrc) - 1) // Removo virgula
                    Else // Limpou tudo
                        cGetEndPrc := ""
                    EndIf
                EndIf
                cToolTip += "Enderecos " + Iif(cTip == "Shw", "considerados:","desconsiderados:") + Chr(13) + Chr(10)
                // aToolEnder := StrToKarr(cGetEndPrc,",")
                cGetEndPrc := ""
                For y := 1 To Len(aGetEndPrc)
                    If " -> " $ aGetEndPrc[y] // Range
                        _cToolTip := aGetEndPrc[y]
                        While At("  -> ", _cToolTip) > 0
                            _cToolTip := StrTran(_cToolTip,"  -> "," -> ")
                        End
                        cToolTip += RTrim(_cToolTip) + Chr(13) + Chr(10)
                        cGetEndPrc += RTrim(_cToolTip) + ","
                    Else // Acho o SBE
                        If !Empty( cGetArmArr )
                            If SBE->(DbSeek(_cFilSBE + Left(aGetEndPrc[y],2) + PadR(SubStr(aGetEndPrc[y],4,15),15)))
                                aGetEndPrc[y] := SBE->BE_LOCAL + "/" + RTrim(SBE->BE_LOCALIZ)
                                cToolTip += aGetEndPrc[y] + Chr(13) + Chr(10)
                                cGetEndPrc += RTrim(aGetEndPrc[y]) + ","
                            EndIf
                        Else
                            If SBE->(DbSeek(_cFilSBE + PadR(SubStr(aGetEndPrc[y],4,15),15)))
                                aGetEndPrc[y] := "??" + "/" + RTrim(SBE->BE_LOCALIZ)
                                cToolTip += aGetEndPrc[y] + Chr(13) + Chr(10)
                                cGetEndPrc += RTrim(aGetEndPrc[y]) + ","
                            EndIf
                        EndIf
                    EndIf
                Next
                cToolTip += "Total: " + StrZero(Len(aGetEndPrc),2)
                cGetEndPrc := Left(cGetEndPrc, Len(cGetEndPrc) - 1) // Removo virgula
            EndIf
            If Len(aGetEndPrc) == 0 // Limpou tudo
                cToolTip := "Separar enderecos com ',' (virgula)"
            EndIf
            &("cGetEnd" + cTip) := cGetEndPrc			// Atribuicao na variavel do objeto
            &("oGetEnd" + cTip):cToolTip := cToolTip	// Atualizacao dos tooltips
            &("oGetEnd" + cTip):Refresh()				// Refresh no objeto
        EndIf
    EndIf
    oGetEndPsq:SetFocus()
ElseIf cFld == "Ope" // Operadores
    DbSelectArea("CB1") // Cadastro de Operadores
    CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
    If cPrc == "Add"
        If Empty(cGetOpePsq) .And. Empty(cGetOpeIni) .And. Empty(cGetOpeFim) // Nao preenchido e eh uma Adicao
            MsgStop("Operadore(s) nao preenchidos para inclusao!" + Chr(13) + Chr(10) + ;
            "Preencha os Operadores De/Ate ou o codigo na pesquisa acima!","PrcElem4")
        ElseIf !Empty(cGetOpePsq) // Pesquisa
            cProc := "P1" // "P"=Pesq... segue normal
        Else // Range
            cProc := "R1" // "R"=Range... segue normal
        EndIf
    ElseIf cPrc == "Rem"
        If Empty(&("cGetOpe" + cTip))
            MsgStop("Nao ha dados para limpeza dos operadores para processamento!","PrcElem4")
        Else
            If !Empty(cGetOpeIni) .Or. !Empty(cGetOpeFim) // Preenchido e eh uma Remocao
                cProc := "C2" // "C2"=Clear Range
            ElseIf !Empty(cGetOpePsq) // Preenchido... limpeza da pesquisa
                cProc := "C1" // "C1"=Clear Pesquisa
            Else // Nao preenchido.. limpeza geral do objeto
                cProc := "C3" // "C"=Clear
                cGetOpePrc := "" // Limpo
            EndIf
        EndIf
    EndIf
    If !Empty(cProc) //  Iniciamos processamento... "P"=Incluir via Pesquisa, "R"=Incluir via Range, "C"=Clear
        // Operadores/Ranges ja considerados
        _cGetOpePrc := &("cGetOpe" + cTip)
        aGetOpePrc := Iif(!Empty(_cGetOpePrc), StrToKarr(_cGetOpePrc,","), {})
        For y := 1 To Len(aGetOpePrc)
            If " -> " $ aGetOpePrc[y] // De Ate
                aGetOpePrc[y] := PadR(SubStr(aGetOpePrc[y], 01, At("->",aGetOpePrc[y]) - 2),6) + " -> " + PadR(SubStr(aGetOpePrc[y], At("->",aGetOpePrc[y]) + 3, 6),6)
            Else // Pesquisa
                aGetOpePrc[y] := PadR(aGetOpePrc[y],6)
            EndIf
        Next
        If cPrc == "Add"
            If cProc == "P1" // "P1"=Pesqu... validar
                cProc := ""
                If !Empty(cGetOpePsq) .And. CB1->(!DbSeek(_cFilCB1 + cGetOpePsq))
                    MsgStop("Operador nao encontrado no cadastro (CB1)!" + Chr(13) + Chr(10) + ;
                    "Operador: " + cGetOpePsq + Chr(13) + Chr(10) + ;
                    "Verifique o operador e tente novamente!","PrcElem4")
                Else // Operador localizado
                    If Len(aGetOpePrc) == 20 // Limite atingido
                        MsgStop("Limite de Operadores para processamento atingido!" + Chr(13) + Chr(10) + ;
                        "Limite maximo de 20 Operadores/Ranges no mesmo processamento!","PrcElem4")
                    Else // Limite ok...
                        If Len(aGetOpePrc) > 0 .And. ASCan(aGetOpePrc, {|x|, x == CB1->CB1_CODOPE }) > 0
                            MsgStop("Operador ja foi incluido neste processamento!" + Chr(13) + Chr(10) + ;
                            "Operador: " + CB1->CB1_CODOPE,"PrcElem4")
                        Else // Considerando entao...
                            cProc := "P1" // "P1"=Pesqu... Processamento...
                            cGetOpePrc := _cGetOpePrc // Atual
                            cGetOpePrc := Iif(!Empty(cGetOpePrc), RTrim(cGetOpePrc) + ",", "") + CB1->CB1_CODOPE // Atualizado
                            aAdd(aGetOpePrc, CB1->CB1_CODOPE) // Incluo na matriz
                        EndIf
                    EndIf
                EndIf
            ElseIf cProc == "R1" // "R1"=Range De/Ate
                cProc := ""
                nOpes := 0
                CB1->(DbSeek(_cFilCB1 + cGetOpeIni,.T.))
                While CB1->(!EOF()) .And. CB1->CB1_FILIAL + CB1->CB1_CODOPE <= _cFilCB1 + cGetOpeFim
                    nOpes++
                    CB1->(DbSkip())
                End
                If (nFnd := ASCan(aGetOpePrc, {|x|, x == cGetOpeIni + " -> " + cGetOpeFim })) > 0 // Range ja existe
                    MsgStop("Operadores ja foi incluidos neste processamento!" + Chr(13) + Chr(10) + ;
                    "Operador De/Ate: " + aGetOpePrc[nFnd],"PrcElem4")
                Else // Ainda nao considerado
                    If Len(aGetOpePrc) == 20 // Limite atingido
                        MsgStop("Limite de Operadores para processamento atingido!" + Chr(13) + Chr(10) + ;
                        "Limite maximo de 20 Operadores/Ranges no mesmo processamento!","PrcElem4")
                    Else // Incluir
                        cProc := "R1" // "R1"=Range
                        cGetOpePrc := cGetOpeIni + " -> " + cGetOpeFim // Atualizado
                        aAdd(aGetOpePrc, cGetOpePrc) // Incluo na matriz
                    EndIf
                EndIf
            EndIf
        ElseIf cPrc == "Rem" // Remover
            If cProc == "C1" // "C1"=Clear de Pesquisa
                cProc := ""
                If Len(aGetOpePrc) == 0 // Nao foram carregados
                    MsgStop("Nao existe nenhum operador carregado para remover!","PrcElem4")
                ElseIf (nPosR := ASCan(aGetOpePrc, {|x|, Left(x,6) == CB1->CB1_CODOPE })) == 0 // Nao encontrado
                    MsgStop("Operador nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Operador: " + CB1->CB1_CODOPE,"PrcElem4")
                Else // Removendo
                    cProc := "C1" // "C2"=Clear
                EndIf
            ElseIf cProc == "C2" // "C2"=Clear de Range De/Ate
                cProc := ""
                If Len(aGetOpePrc) == 0 // Nao foram carregados
                    MsgStop("Nao existe nenhum operador carregado para remover!","PrcElem4")
                ElseIf (nPosR := ASCan(aGetOpePrc, {|x|, x == cGetOpeIni + " -> " + cGetOpeFim })) == 0 // Range nao encontrado
                    MsgStop("Operador De/Ate nao encontrado para remover!" + Chr(13) + Chr(10) + ;
                    "Operador De/Ate: " + cGetOpeIni + " -> " + cGetOpeFim,"PrcElem4")
                Else
                    cProc := "C2" // "C1"=Clear de Range
                EndIf
            Else // "C3"=Clear geral
                cGetOpePrc := ""
                aGetOpePrc := {}
            EndIf
        EndIf
        If cProc $ "P1/R1/C1/C2/C3/" // Processamento Validado "P"=Pesquisa, "R"=Range, "C"=Clear... refresh
            If Len(aGetOpePrc) > 0
                If cProc $ "C1/C2/" // "C1/C2"=Clear de elemento
                    aDel(aGetOpePrc, nPosR)
                    aSize(aGetOpePrc, Len(aGetOpePrc) - 1)
                    If Len(aGetOpePrc) > 0 // Ainda tem elementos
                        cGetOpePrc := ""
                        For y := 1 To Len(aGetOpePrc)
                            cGetOpePrc += RTrim(aGetOpePrc[y]) + ","
                        Next
                        cGetOpePrc := Left(cGetOpePrc, Len(cGetOpePrc) - 1) // Removo virgula
                    Else // Limpou tudo
                        cGetOpePrc := ""
                    EndIf
                EndIf
                cToolTip += "Operadores " + Iif(cTip == "Shw", "considerados:","desconsiderados:") + Chr(13) + Chr(10)
                cGetOpePrc := ""
                For y := 1 To Len(aGetOpePrc)
                    If " -> " $ aGetOpePrc[y] // Range
                        _cToolTip := aGetOpePrc[y]
                        While At("  -> ", _cToolTip) > 0
                            _cToolTip := StrTran(_cToolTip,"  -> "," -> ")
                        End
                        cToolTip += RTrim(_cToolTip) + Chr(13) + Chr(10)
                        cGetOpePrc += RTrim(_cToolTip) + ","
                    Else // Acho o CB1
                        If CB1->(DbSeek(_cFilCB1 + aGetOpePrc[y]))
                            aGetOpePrc[y] := RTrim(CB1->CB1_CODOPE)
                            cToolTip += aGetOpePrc[y] + " " + CB1->CB1_NOME + Chr(13) + Chr(10)
                            cGetOpePrc += RTrim(aGetOpePrc[y]) + ","
                        EndIf
                    EndIf
                Next
                cToolTip += "Total: " + StrZero(Len(aGetOpePrc),2)
                cGetOpePrc := Left(cGetOpePrc, Len(cGetOpePrc) - 1) // Removo virgula
            EndIf
            If Len(aGetOpePrc) == 0 // Limpou tudo
                cToolTip := "Separar operadores com ',' (virgula)"
            EndIf
            &("cGetOpe" + cTip) := cGetOpePrc			// Atribuicao na variavel do objeto
            &("oGetOpe" + cTip):cToolTip := cToolTip	// Atualizacao dos tooltips
            &("oGetOpe" + cTip):Refresh()				// Refresh no objeto
        EndIf
    EndIf
    oGetOpePsq:SetFocus()
EndIf
ChckIncl()
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadEnds ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento Enderecos Considerar                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadEnds(cGetEndShw)
Local y
Local aGetEndPrc := {}
If !Empty(cGetEndShw)
    aGetEndPrc := StrToKarr(cGetEndShw,",")
    For y := 1 To Len(aGetEndPrc)
        If " -> " $ aGetEndPrc[y] // De Ate
            aGetEndPrc[y] := PadR(SubStr(aGetEndPrc[y], 01, At("->",aGetEndPrc[y]) - 2),18) + " -> " + PadR(SubStr(aGetEndPrc[y], At("->",aGetEndPrc[y]) + 3, 18),18)
        Else // Pesquisa
            aGetEndPrc[y] := PadR(aGetEndPrc[y],18)
        EndIf
    Next
EndIf
Return aGetEndPrc

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ LoadOpes ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento Operadores Considerar                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function LoadOpes(cGetOpeShw)
Local y
Local aGetOpePrc := {}
If !Empty(cGetOpeShw)
    aGetOpePrc := StrToKarr(cGetOpeShw,",")
    For y := 1 To Len(aGetOpePrc)
        If " -> " $ aGetOpePrc[y] // De Ate
            aGetOpePrc[y] := PadR(SubStr(aGetOpePrc[y], 01, At("->",aGetOpePrc[y]) - 2),06) + " -> " + PadR(SubStr(aGetOpePrc[y], At("->",aGetOpePrc[y]) + 3, 06),06)
        Else // Pesquisa
            aGetOpePrc[y] := PadR(aGetOpePrc[y],06)
        EndIf
    Next
EndIf
Return aGetOpePrc

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ EndsProc ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento de Enderecos Processamento (Incl/Alter)       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ aGetEndPrc: Matriz com os enderecos carregados (SBE)       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Retorno:                                                   ∫±±
±±∫          ≥ aEndPrc: Enderecos validos para processamento (SBE)        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function EndsProc(aGetEndPrc)
Local aEndPrc := {}
DbSelectArea("NNR")
NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
If !Empty(cGetArmArr) // Armazem
    If NNR->(DbSeek(_cFilNNR + cGetArmArr))
        DbSelectArea("SBE")
        SBE->(DbSetOrder(1)) // BE_FILIAL + BE_LOCAL + BE_LOCALIZ
        SBE->(DbSeek(_cFilSBE + NNR->NNR_CODIGO + cGetEndIni,.T.))
        While SBE->(!EOF()) .And. SBE->BE_FILIAL + SBE->BE_LOCAL == _cFilSBE + NNR->NNR_CODIGO .And. Iif(!Empty(cGetEndFim), SBE->BE_LOCALIZ <= cGetEndFim, .T.)
            If SBE->BE_XBLOQ <> "S" // Endereco nao bloqueado
                If !(SBE->BE_STATUS $ "3/4/5/6/") // 1=Desocupado;2=Ocupado;3=Bloqueado;4=Bloqueio Entrada;5=Bloqueio SaÌda;6=Bloqueio Invent·rio
                    If Len( aGetEndPrc ) == 0
                        aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                    ElseIf ASCan( aGetEndPrc, {|x|, Left(x,2) $ "??/" + SBE->BE_LOCAL .And. !(" -> " $ x) .And. SubStr(x,4,15) == SBE->BE_LOCALIZ }) > 0
                        aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                    ElseIf ASCan( aGetEndPrc, {|x|, Left(x,2) $ "??/" + SBE->BE_LOCAL .And.   " -> " $ x  .And. SBE->BE_LOCALIZ >= SubStr(x,4,15) .And. SBE->BE_LOCALIZ <= SubStr(x,26,15) }) > 0
                        aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                    EndIf
                EndIf
            EndIf
            SBE->(DbSkip())
        End
    Else // Armazem nao encontrado (NNR)
        MsgStop("Armazem nao encontrado no cadastro (NNR)!" + Chr(13) + Chr(10) + ;
        "Armazem: " + cGetArmArr + Chr(13) + Chr(10) + ;
        "Preencha um armazem valido e tente novamente!","InclGd02")
    EndIf
Else // Armazem nao preenchido
    DbSelectArea("SBE")
    SBE->(DbSetOrder(9)) // BE_FILIAL + BE_LOCALIZ
    SBE->(DbSeek(_cFilSBE + cGetEndIni,.T.))
    While SBE->(!EOF()) .And. SBE->BE_FILIAL == _cFilSBE .And. Iif(!Empty(cGetEndFim), SBE->BE_LOCALIZ <= cGetEndFim, .T.)
        If SBE->BE_XBLOQ <> "S" // Endereco nao bloqueado
            If !(SBE->BE_STATUS $ "3/4/5/6/") // 1=Desocupado;2=Ocupado;3=Bloqueado;4=Bloqueio Entrada;5=Bloqueio SaÌda;6=Bloqueio Invent·rio
                If Len( aGetEndPrc ) == 0
                    aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                ElseIf ASCan( aGetEndPrc, {|x|, Left(x,2) $ "??/" + SBE->BE_LOCAL .And. !(" -> " $ x) .And. SubStr(x,4,15) == SBE->BE_LOCALIZ }) > 0
                    aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                ElseIf ASCan( aGetEndPrc, {|x|, Left(x,2) $ "??/" + SBE->BE_LOCAL .And.   " -> " $ x  .And. SBE->BE_LOCALIZ >= SubStr(x,4,15) .And. SBE->BE_LOCALIZ <= SubStr(x,26,15) }) > 0
                    aAdd(aEndPrc, { SBE->BE_LOCAL, SBE->BE_LOCALIZ }) // Enderecos considerar
                EndIf
            EndIf
        EndIf
        SBE->(DbSkip())
    End
EndIf
Return aEndPrc

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ OpesProc ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Carregamento de Operadores Processamento (Incl/Alter)      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Parametros recebidos:                                      ∫±±
±±∫          ≥ aGetOpePrc: Matriz com os operadores carregados (CB1)      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Retorno:                                                   ∫±±
±±∫          ≥ aOpePrc: Operadores validos para processamento (CB1)       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function OpesProc(aGetOpePrc)
Local aOpePrc := {}
DbSelectArea("CB1")
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
CB1->(DbSeek(_cFilCB1 + cGetOpeIni,.T.))
While CB1->(!EOF()) .And. CB1->CB1_FILIAL == _cFilSBE .And. Iif(!Empty( cGetOpeFim ), CB1->CB1_CODOPE <= cGetOpeFim, .T.)
    If !(CB1->CB1_STATUS $ "2/3/") // 1=Ativo;2=Inativo;3=Pausa
        If Len( aGetOpePrc ) == 0
            aAdd(aOpePrc, CB1->CB1_CODOPE) // Operadores considerar
        ElseIf ASCan( aGetOpePrc, {|x|, !(" -> " $ x) .And. CB1->CB1_CODOPE == Left(x,6) }) > 0
            aAdd(aOpePrc, CB1->CB1_CODOPE) // Operadores considerar
        ElseIf ASCan( aGetOpePrc, {|x|,   " -> " $ x  .And. CB1->CB1_CODOPE >= Left(x,6) .And. CB1->CB1_CODOPE <= Right(x,6) }) > 0
            aAdd(aOpePrc, CB1->CB1_CODOPE) // Operadores considerar
        EndIf
    EndIf
    CB1->(DbSkip())
End
Return aOpePrc

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ MntsEnds ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Montagem dos enderecos considerados                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function MntsEnds()
Local y
aGetEndPrc := {}
cGetEndPrc := ""
If !Empty( cGetEndShw )
    cToolTip := "Enderecos considerados:" + Chr(13) + Chr(10)
    aGetEndPrc := Iif(!Empty(cGetEndShw), StrToKarr(cGetEndShw,","), {})
    For y := 1 To Len(aGetEndPrc)
        If " -> " $ aGetEndPrc[y] // Range
            _cToolTip := aGetEndPrc[y]
            While At("  -> ", _cToolTip) > 0
                _cToolTip := StrTran(_cToolTip,"  -> "," -> ")
            End
            cToolTip += RTrim(_cToolTip) + Chr(13) + Chr(10)
            cGetEndPrc += RTrim(_cToolTip) + ","
        Else // Acho o SBE
            If !Empty( cGetArmArr )
                If SBE->(DbSeek(_cFilSBE + Left(aGetEndPrc[y],2) + PadR(SubStr(aGetEndPrc[y],4,15),15)))
                    aGetEndPrc[y] := SBE->BE_LOCAL + "/" + RTrim(SBE->BE_LOCALIZ)
                    cToolTip += aGetEndPrc[y] + Chr(13) + Chr(10)
                    cGetEndPrc += RTrim(aGetEndPrc[y]) + ","
                EndIf
            Else
                If SBE->(DbSeek(_cFilSBE + PadR(SubStr(aGetEndPrc[y],4,15),15)))
                    aGetEndPrc[y] := "??" + "/" + RTrim(SBE->BE_LOCALIZ)
                    cToolTip += aGetEndPrc[y] + Chr(13) + Chr(10)
                    cGetEndPrc += RTrim(aGetEndPrc[y]) + ","
                EndIf
            EndIf
        EndIf
    Next
    cToolTip += "Total: " + StrZero(Len(aGetEndPrc),2)
    cGetEndPrc := Left(cGetEndPrc, Len(cGetEndPrc) - 1) // Removo virgula
EndIf
If Len(aGetEndPrc) == 0 // Limpou tudo
    cToolTip := "Separar enderecos com ',' (virgula)"
EndIf
&("cGetEndShw") := cGetEndPrc			// Atribuicao na variavel do objeto
&("oGetEndShw"):cToolTip := cToolTip	// Atualizacao dos tooltips
&("oGetEndShw"):Refresh()				// Refresh no objeto
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ MntsOpes ∫Autor ≥ Jonathan Schmidt Alves ∫Data≥ 22/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Montagem dos operadores considerados                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function MntsOpes()
Local y
aGetOpePrc := {}
cGetOpePrc := ""
If !Empty( cGetOpeShw )
    cToolTip := "Operadores considerados:" + Chr(13) + Chr(10)
    aGetOpePrc := Iif(!Empty(cGetOpeShw), StrToKarr(cGetOpeShw,","), {})
    For y := 1 To Len(aGetOpePrc)
        If " -> " $ aGetOpePrc[y] // Range
            _cToolTip := aGetOpePrc[y]
            While At("  -> ", _cToolTip) > 0
                _cToolTip := StrTran(_cToolTip,"  -> "," -> ")
            End
            cToolTip += RTrim(_cToolTip) + Chr(13) + Chr(10)
            cGetOpePrc += RTrim(_cToolTip) + ","
        Else // Acho o CB1
            CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
            If CB1->(DbSeek(_cFilCB1 + aGetOpePrc[y]))
                aGetOpePrc[y] := RTrim(CB1->CB1_CODOPE)
                cToolTip += aGetOpePrc[y] + " " + CB1->CB1_NOME + Chr(13) + Chr(10)
                cGetOpePrc += RTrim(aGetOpePrc[y]) + ","
            EndIf
        EndIf
    Next
    cToolTip += "Total: " + StrZero(Len(aGetOpePrc),2)
    cGetOpePrc := Left(cGetOpePrc, Len(cGetOpePrc) - 1) // Removo virgula
EndIf
If Len(aGetOpePrc) == 0 // Limpou tudo
    cToolTip := "Separar operadores com ',' (virgula)"
EndIf
&("cGetOpeShw") := cGetOpePrc			// Atribuicao na variavel do objeto
&("oGetOpeShw"):cToolTip := cToolTip	// Atualizacao dos tooltips
&("oGetOpeShw"):Refresh()				// Refresh no objeto
Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ GeraEx00 ∫Autor ≥ Jonathan Schmidt Alves ∫Data ≥23/06/2021 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Geracao de Excel da tela de arrumacoes processadas.        ∫±±
±±∫          ≥ Atalho F10                                                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SCHNEIDER                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function GeraEx00()
Local w, w2
Local cArqGer := "C:\TEMP\ARRUMACOES_ZR3_" + StrTran(DtoC(Date()),"/","-") + "_" + StrTran(Left(Time(),6),":","") + ".CSV"
Local aCabec := {}
Local aHeaders := {}
Local aDados := {}
Local aColsSoma := {}
Local nExcLines := 0
Local lAuto := .F.
If Len(oGetD3:aCols) > 0
	// Parte 01: Carregando configuracoes de perguntas
	aAdd(aCabec, { cTitle })
	aAdd(aCabec, { "Data/Hora Geracao:", DtoC(Date()) + " " + Time() }) // Data/Hora geracao
	// Parte 02: Colunas de impressao
	For w := 1 To Len(aHdr03)
		aAdd(aHeaders, aHdr03[w,01])
	Next
	// Parte 03: Dados
	For w := 1 To Len(oGetD3:aCols)
		aDado := {}
		For w2 := 1 To Len(aHdr03)
            If aHdr03[w2,08] == "N" // Numerico
                xDado := AllTrim(TransForm(oGetD3:aCols[w,w2], "@E 999999.99"))
			ElseIf aHdr03[w2,08] == "D" // Data
				xDado := DtoC(oGetD3:aCols[w,w2])
            Else // Char
                xDado := oGetD3:aCols[w,w2]
                If !Empty(aHdr03[w2,11]) // Existe Options no aHeader
                    If Type( "aOpc" + SubStr(aHdr03[w2,02],5,6) ) == "U"
                        &("aOpc" + SubStr(aHdr03[w2,02],5,6)) := StrToKarr( aHdr03[w2,11], ";")
                    EndIf
                    If (nFind := ASCan( &("aOpc" + SubStr(aHdr03[w2,02],5,6)), {|x|, Left(x,2) == xDado })) > 0
                        xDado := &("aOpc" + SubStr(aHdr03[w2,02],5,6))[ nFind ]
                    EndIf
                EndIf
            EndIf
        	aAdd(aDado, xDado)
		Next
		aAdd(aDados, aClone(aDado))
	Next
	// Parte 04: Gerando Excel
	u_AskYesNo(1200,"GeraExcel","Gerando Excel...","","","","","PROCESSA",.T.,.F.,{|| u_GeraExcl(aCabec, aHeaders, aDados, aColsSoma, nExcLines, lAuto, cArqGer) })
EndIf
Return

Static Function AboutArr() // F12=About Arrumacao Estoque
Local oBtOK
Local oSay01
Local oSay02
Local oSay03
Local oSay04
Local oSay05
Local oSay06
Local oSay07
Local oSay08
Local oSay09
Local oDlgAbout
Local cVersion := "2.10"
Local cFileLogo := "system\lgrecibo0101.jpg"
If Type("_cVersion") == "C"
	cVersion := _cVersion
EndIf
If lAuditor
    SetKey(VK_F7,{|| Nil }) // Atalho F7 Encerra Arrumacao
    SetKey(VK_F8,{|| Nil }) // Atalho F8 Altera Status Auditor
    SetKey(VK_F9,{|| Nil }) // Atalho F9 Altera Observacao Auditor
EndIf
SetKey(VK_F10,{|| Nil }) // F10 = Gerar Excel
SetKey(VK_F12,{|| oDlgAbout:End() }) // F12 = About
DEFINE MSDIALOG oDlgAbout FROM 0,0 TO 180,440 PIXEL TITLE "Sobre..."
@002,005 BitMap Size 075,075 File cFileLogo Of oDlgAbout Pixel Noborder
@003,090 SAY oSay01 VAR "Build: " + GetBuild() SIZE 140,015 OF oDlgAbout Pixel
@011,090 SAY oSay02 VAR "Environment: " + GetEnvServer() SIZE 140,015 OF oDlgAbout Pixel
@019,090 SAY oSay03 VAR "Arrumacao Locais v." + cVersion SIZE 140,015 OF oDlgAbout Pixel
@027,090 SAY oSay04 VAR "Desenvolvimento: Jonathan Schmidt Alves" SIZE 140,015 OF oDlgAbout Pixel
@035,090 SAY oSay05 VAR "Analista NegÛcio: Jefferson Puglia" SIZE 140,015 OF oDlgAbout Pixel
@043,090 SAY oSay06 VAR "CoordenaÁ„o: Renato Oliveira" SIZE 140,015 OF oDlgAbout Pixel
@051,090 SAY oSay07 VAR "" SIZE 140,015 OF oDlgAbout Pixel
@059,090 SAY oSay08 VAR "" SIZE 140,015 OF oDlgAbout Pixel
@067,090 SAY oSay09 VAR "" SIZE 140,015 OF oDlgAbout Pixel
@075,090 Button oBtOK Prompt "OK" Size 38,12 Action(oDlgAbout:End()) Pixel Of oDlgAbout
ACTIVATE MSDIALOG oDlgAbout CENTERED
If lAuditor
    SetKey(VK_F7,{|| EndsGd02() }) // Atalho F7 Encerra Arrumacao
    SetKey(VK_F8,{|| ChgObsF8() }) // Atalho F8 Altera Status Auditor
    SetKey(VK_F9,{|| ChgObsF9() }) // Atalho F9 Altera Observacao Auditor
EndIf
SetKey(VK_F10, {|| GeraEx00() })	// Atalho Carregar Planilha Excel
SetKey(VK_F12, {|| AboutArr() })    // About
Return
