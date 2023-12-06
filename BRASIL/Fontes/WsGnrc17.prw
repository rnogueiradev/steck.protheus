#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ WsGnrc17 ºAutor ³Jonathan Schmidt Alves º Data ³29/06/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Prestacao de Contas (Compensacoes).                        º±±
±±º          ³                                                            º±±
±±º          ³ Apresenta tela com os registros provenientes da integracao º±±
±±º          ³ Thomson x Totvs, considera tambem titulos manuais que sao  º±±
±±º          ³ gerados na entrada de documentos amarrados a um processo.  º±±
±±º          ³ Tambem consideramos titulos a pagar provenientes de SC's   º±±
±±º          ³ de compra que tambem estao amarradas a um processo.        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                   WsGnrc17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WsGnrc17()
Local _w1
Local cTitle := "WsGnrc17: Prestacao de Contas"
// Pesquisa da Integracao
Private oSayPrcPsq
Private cSayPrcPsq := "Processo:"
Private oGetPrcPsq
Private cGetPrcPsq := Space(30) // Ex: "02-0026/21"
// Cores GetDados 01
Private nC01C00 := RGB(247,247,247) // Cinza Mais Claro                 *** Cor 00
Private nC01C08 := RGB(095,252,078) // Verde Claro                      *** Cor 08 Adto Marcado Compensacao
Private nC01C09 := RGB(250,239,031) // Amarelo                          *** Cor 09 Titu Marcado Compensacao
// Cor 01
Private nC01C01 := RGB(210,210,210)	// Cinza Claro                      *** Cor 01
Private nC01S01 := RGB(141,141,141)	// Cinza Mais Escuro                *** Cor 01 Selecionada
// Cor 02
Private nC01C02 := RGB(192,209,154)	// Cinza Esverdeado Claro           *** Cor 02
Private nC01S02 := RGB(176,198,128)	// Cinza Esverdeado Mais Escuro     *** Cor 02 Selecionada
// Cor 03
Private nC01C03 := RGB(204,224,244)	// Cinza Azulado Claro              *** Cor 03
Private nC01S03 := RGB(120,173,226)	// Cinza Azulado Mais Escuro        *** Cor 03 Selecionada
// Cor 07
Private nC01C07 := RGB(255,151,151) // Vermelho Claro                   *** Cor 07
Private nC01S07 := RGB(255,100,100) // Vermelho Mais Escuro             *** Cor 07 Selecionada
// Cores Panels Folder 01
Private nClrTop := RGB(164,170,255)	// Azul Padrao Mais Claro           *** Top
Private nClrGd1 := RGB(138,147,255)	// Azul Padrao Escuro               *** GetDados
Private nClrTot := RGB(164,170,255)	// Azul Padrao Mais Claro           *** GetDados
Private nClrBot := RGB(094,105,255)	// Azul Padrao Mais Escuro          *** Bottom
// Controle Cores GetDados 01
Private aCor01 := {}
Private aSel01 := {}
Private aClr01 := { { nC01C01, nC01S01 }, { nC01C02, nC01S02 }, { nC01C03, nC01S03 } }
Private nClr01 := 1
// Processo
Private nRadPrc := 1
Private aRadPrc := { "Importacao", "Exportacao" }
Private nLineG01 := 0
// Nao Mostrar 01=Adiantamentos/02=Prestacoes
Private oChkAdtPre
Private lChkAdtPre := .F.
// Nao Mostrar '03'=Pagamentos
Private oChkPagame
Private lChkPagame := .F.
// Nao Mostrar integracoes sem titulos gerados
Private oChkIntTit
Private lChkIntTit := .F.
// Mostrar registros UNIAO / ESTADO/MUNIC /
Private oChkUniEst
Private lChkUniEst := .F.
// Variaveis Adto/Prestacao:
// Adto Thomson
Private oSayAdtTho
Private cSayAdtTho := "Adto Thomson: "
Private oGetAdtTho
Private nGetAdtTho := 0
// Adto Totvs
Private oSayAdtTot
Private cSayAdtTot := "Adto Totvs: "
Private oGetAdtTot
Private nGetAdtTot := 0
// Prestacao Thomson
Private oSayPreTho
Private cSayPreTho := "Prest Thomson: "
Private oGetPreTho
Private nGetPreTho := 0
// Prestacao Totvs
Private oSayPreTot
Private cSayPreTot := "Prest Totvs: "
Private oGetPreTot
Private nGetPreTot := 0
// Pendencia Totvs
Private oSayPenTot
Private cSayPenTot := "Pend Totvs: "
Private oGetPenTot
Private nGetPenTot := 0
// Variaveis Compensacoes:
// Adtos Sel
Private oSayAdtSel
Private cSayAdtSel := "Adtos Sel: "
Private oGetAdtSel
Private nGetAdtSel := 0
// Pgtos Sel
Private oSayPgtSel
Private cSayPgtSel := "Pgtos Sel: "
Private oGetPgtSel
Private nGetPgtSel := 0
// Saldo Sel
Private oSaySldSel
Private cSaySldSel := "Saldo Sel: "
Private oGetSldSel
Private nGetSldSel := 0
// Variaveis Totalizacoes:
// Cliente/Fornecedor
Private oSayCliFor
Private cSayCliFor := "Cliente/Fornec: "
Private oGetCliFor
Private cGetCliFor := Space(40)
// Adtos
Private oSayTotAdt
Private cSayTotAdt := "Total Adtos: "
Private oGetTotAdt
Private nGetTotAdt := 0
// Prests
Private oSayTotPre
Private cSayTotPre := "Total Prests: "
Private oGetTotPre
Private nGetTotPre := 0
// Pgtos
Private oSayTotPgt
Private cSayTotPgt := "Total Pgtos: "
Private oGetTotPgt
Private nGetTotPgt := 0
// Pends
Private oSayTotPen
Private cSayTotPen := "Total Pends: "
Private oGetTotPen
Private nGetTotPen := 0
// Sldo
Private oSaySldClc
Private cSaySldClc := "Sldo Calculado: "
Private oGetSldClc
Private nGetSldClc := 0
// Atalhos
Private oSayAtaF8_
Private cSayAtaF8_ := "F8 = Marcar/Desmarcar registros"
// Variaveis filiais
Private _cFilZT1 := xFilial("ZT1")
Private _cFilZT2 := xFilial("ZT2")
Private _cFilZTL := xFilial("ZTL")
Private _cFilZTN := xFilial("ZTN")
Private _cFilZTF := xFilial("ZTF")
Private _cFilZTG := xFilial("ZTG")
Private _cFilSE2 := xFilial("SE2")
Private _cFilSB1 := xFilial("SB1")
Private _cFilSA2 := xFilial("SA2")
Private _cFilSC1 := xFilial("SC1")
// Abertura das tabelas
DbSelectArea("ZTN")
ZTN->(DbSetOrder(1)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_IDTRAN + ZTN_STATHO + ZTN_STATOT + ZTN_DTHRLG
DbSelectArea("ZTF")
ZTF->(DbSetOrder(1)) // ZTF_FILIAL + ZTF_CDSPID + ZTF_PROCES + ZTF_IDEPRO
DbSelectArea("ZTG")
ZTG->(DbSetOrder(1)) // ZTG_FILIAL + ZTG_EMPFIL + ZTG_PRCTHO + ZTG_NUMDOC + ZTG_SERDOC + ZTG_CODFOR + ZTG_LOJFOR + ZTG_TIPDOC
SetKey(VK_F8,{|| MrkCmpF8( .F. ) }) // Atalho F8 Marca/Desmarca compensacoes
DEFINE MSDIALOG oDlg01 FROM 050,165 TO 725,1043 TITLE cTitle Pixel
// Panel
oPnlTop	:= TPanel():New(000,000,,oDlg01,,,,,nClrTop,340,060,.F.,.F.) // Top
oPnlGd1	:= TPanel():New(060,000,,oDlg01,,,,,nClrGd1,520,170,.F.,.F.) // GetDados 01
oPnlTot	:= TPanel():New(230,000,,oDlg01,,,,,nClrTot,520,110,.F.,.F.) // Totalizacoes
oPnlBot := TPanel():New(330,000,,oDlg01,,,,,nClrBot,520,010,.F.,.F.) // Bottom
// Logo
@004,345 BitMap Size 100,040 File "TwoSourceLogo.jpg" Of oDlg01 Pixel Stretch NoBorder
// Linha 01 Processo Importacao/Exportacao
oRadPrc := TRadMenu():New(002,015,aRadPrc, {|u| Iif(PCount() == 0, nRadPrc, nRadPrc := u) }, oPnlTop,, {|| LdsPrest( nRadPrc ) },,,,.T.,,200,12,,,,.T.)
oRadPrc:lHoriz := .T.
// Linha 02
// Nao Mostrar 01=Adiantamentos/02=Prestacoes
@017,003 CHECKBOX oChkAdtPre VAR lChkAdtPre PROMPT "Nao Mostrar '01'=Adiantamentos/'02'=Prestacoes" SIZE 130,008 OF oPnlTop PIXEL ON CHANGE u_AskYesNo(3500,"PsqPrest","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| PsqPrest() })
oChkAdtPre:cVariable := "lChkAdtPre"
// Mostrar '03'=Pagamentos
@017,135 CHECKBOX oChkPagame VAR lChkPagame PROMPT "Nao Mostrar '03'=Pagamentos" SIZE 085,008 OF oPnlTop PIXEL ON CHANGE u_AskYesNo(3500,"PsqPrest","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| PsqPrest() })
oChkPagame:cVariable := "lChkPagame"
// Nao Mostrar integracoes com titulos gerados
@017,220 CHECKBOX oChkIntTit VAR lChkIntTit PROMPT "Nao Mostrar integracoes sem titulos gerados" SIZE 120,008 OF oPnlTop PIXEL ON CHANGE u_AskYesNo(3500,"PsqPrest","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| PsqPrest() })
oChkIntTit:cVariable := "lChkIntTit"
// Mostrar registros UNIAO/ESTADO/MUNIC /
@030,220 CHECKBOX oChkUniEst VAR lChkUniEst PROMPT "Mostrar registros UNIAO/ESTADO/MUNIC" SIZE 120,008 OF oPnlTop PIXEL ON CHANGE u_AskYesNo(3500,"PsqPrest","Carregando dados em tela...","","","","","PROCESSA",.T.,.F.,{|| PsqPrest() })
oChkUniEst:cVariable := "lChkUniEst"
// Linha 03
@043,005 SAY oSayPrcPsq Var cSayPrcPsq SIZE 090,011 Of oPnlTop Pixel
@041,042 MSGET oGetPrcPsq Var cGetPrcPsq SIZE 060,008 Of oPnlTop Pixel HASBUTTON
// Linha 04
@041,120 BUTTON oBtnPsq PROMPT "Pesquisar" Size 037,010 Pixel Of oPnlTop Action(PsqPrest()) // Carregamento
// oBtnPsq:lVisible := .F.
@041,160 BUTTON oBtnPrc PROMPT "Processar" Size 037,010 Pixel Of oPnlTop Action(PrcPrest( nRadPrc )) // Carregamento
aHdr01 := LoadsHdr("ZTF") // Carrego aHdr
aCls01 := LoadCols(aHdr01) // Criacao do aCls01
For _w1 := 1 To Len(aHdr01)
	&("nP01" + SubStr(aHdr01[_w1,2],5,6)) := _w1
Next
// GetDados
oGetD1 := MsNewGetDados():New(003,003,160,438,Nil,"AllwaysTrue()", "AllwaysTrue()" ,, /*aFldsAlt01*/ ,,,,,"AllwaysTrue()",oPnlGD1,@aHdr01,@aCls01)
oGetD1:oBrowse:SetBlkBackColor({|| GetD1Clr("01", oGetD1:aCols, oGetD1:nAt, aHdr01) })
oGetD1:bChange := {|| nLineG01 := oGetD1:nAt, oGetD1:Refresh(), LoadsTot() }
oGetD1:oBrowse:lHScroll := .F.
// Cliente/Fornecedor:
@004,005 SAY oSayCliFor Var cSayCliFor SIZE 060,011 Of oPnlTot Pixel
@002,045 MSGET oGetCliFor Var cGetCliFor PICTURE "@!" SIZE 140,008 Of oPnlTot Pixel
oGetCliFor:lActive := .F.
// Totalizadores Adiantamento/Prestacao:
oGrp01 := TGroup():New(015,002,090,130,"Total Adiantamentos/Prestacao:",oPnlTot,,,.T.)
// Adiantamento Thomson:
@027,015 SAY oSayAdtTho Var cSayAdtTho SIZE 060,011 Of oPnlTot Pixel
@025,055 MSGET oGetAdtTho Var nGetAdtTho PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Adiantamento Totvs:
@040,015 SAY oSayAdtTot Var cSayAdtTot SIZE 060,011 Of oPnlTot Pixel
@038,055 MSGET oGetAdtTot Var nGetAdtTot PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Prestacao Thomson:
@053,015 SAY oSayPreTho Var cSayPreTho SIZE 090,011 Of oPnlTot Pixel
@051,055 MSGET oGetPreTho Var nGetPreTho PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Prestacao Totvs:
@066,015 SAY oSayPreTot Var cSayPreTot SIZE 090,011 Of oPnlTot Pixel
@064,055 MSGET oGetPreTot Var nGetPreTot PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Pendencia Totvs:
@079,015 SAY oSayPenTot Var cSayPenTot SIZE 090,011 Of oPnlTot Pixel
@077,055 MSGET oGetPenTot Var nGetPenTot PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
aObjs := { "oGetAdtTho", "oGetAdtTot", "oGetPreTho", "oGetPreTot", "oGetPenTot" }
For _w1 := 1 To Len(aObjs)
	&(aObjs[_w1]):lActive := .F.
Next
// Totais Compensacao Selecionada:
oGrp02 := TGroup():New(015,155,090,285,"Total Compensacao Selecionada:",oPnlTot,,,.T.)
// Adiantamentos Selecionados:
@027,170 SAY oSayAdtSel Var cSayAdtSel SIZE 060,011 Of oPnlTot Pixel
@025,210 MSGET oGetAdtSel Var nGetAdtSel PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Prestacao/Pagamentos Selecionados:
@040,170 SAY oSayPgtSel Var cSayPgtSel SIZE 060,011 Of oPnlTot Pixel
@038,210 MSGET oGetPgtSel Var nGetPgtSel PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Saldo Selecionados:
@053,170 SAY oSaySldSel Var cSaySldSel SIZE 060,011 Of oPnlTot Pixel
@051,210 MSGET oGetSldSel Var nGetSldSel PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
aObjs := { "oGetAdtSel", "oGetPgtSel", "oGetSldSel" }
For _w1 := 1 To Len(aObjs)
	&(aObjs[_w1]):lActive := .F.
Next
// Totalizadores Gerais:
oGrp03 := TGroup():New(015,315,090,435,"Total Geral:",oPnlTot,,,.T.)
// Total Adiantamentos:
@027,325 SAY oSayTotAdt Var cSayTotAdt SIZE 090,011 Of oPnlTot Pixel
@025,365 MSGET oGetTotAdt Var nGetTotAdt PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Total Prestacoes:
@040,325 SAY oSayTotPre Var cSayTotPre SIZE 090,011 Of oPnlTot Pixel
@038,365 MSGET oGetTotPre Var nGetTotPre PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Total Pgtos:
@053,325 SAY oSayTotPgt Var cSayTotPgt SIZE 090,011 Of oPnlTot Pixel
@051,365 MSGET oGetTotPgt Var nGetTotPgt PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Total Pendencias:
@066,325 SAY oSayTotPen Var cSayTotPen SIZE 090,011 Of oPnlTot Pixel
@064,365 MSGET oGetTotPen Var nGetTotPen PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
// Saldo Calculado:
@079,325 SAY oSaySldClc Var cSaySldClc SIZE 090,011 Of oPnlTot Pixel
@076,365 MSGET oGetSldClc Var nGetSldClc PICTURE "@E 99,999,999.99" SIZE 060,008 Of oPnlTot Pixel HASBUTTON
aObjs := { "oGetTotAdt", "oGetTotPre", "oGetTotPgt", "oGetTotPen", "oGetSldClc" }
For _w1 := 1 To Len(aObjs)
	&(aObjs[_w1]):lActive := .F.
Next
// Atalhos:
@001,345 SAY oSayPrcPsq Var cSayAtaF8_ SIZE 100,011 Of oPnlBot Pixel
oGetPrcPsq:SetFocus()
ACTIVATE MSDIALOG oDlg01 CENTERED
SetKey(VK_F8,{|| Nil }) // Atalho F8 Marca/Desmarca compensacoes
Return

Static Function GetD1Clr(cGet, aCols, nLine, aHdrs) // Cores GetDados 01
Local nClr := nC01C01 // Cinza Padrao
If nLine <= Len(aCols)
	If Len(aCor01) > 0 .And. nLine <= Len(aCor01)        
        If aCols[ nLine, nP01MrkCmp ] == "01" // "01"=Sim (Marcado para compensacao)
            If aCols[ nLine, nP01SpTipo ] == "01" // "01"=Adiantamento
                nClr := nC01C08 // Verde
            Else // Prest/Pgtos
                nClr := nC01C09 // Amarelo
            EndIf
        Else // Nao marcado
            If nLine == nLineG01 // Linha selecionada
                nClr := aSel01[ nLine ]
            Else
                nClr := aCor01[ nLine ]
            EndIf
        EndIf
	EndIf
EndIf
Return nClr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LdsPrest ºAutor ³ Jonathan Schmidt Alves ºData³ 22/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RadioBox Importacao/Exportacao.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LdsPrest( nRadPrc ) // Loads
cGetPrcPsq := Space(30)
oGetPrcPsq:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PsqPrest ºAutor ³ Jonathan Schmidt Alves ºData³ 22/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa (ZTN/ZTF).                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PsqPrest( nRadPrc ) // Pesquisar
Local _w1
Local lShwReg := .T.
// Variaveis dados
Local cObserv := ""
Local cStaPrc := ""
Local cEmpFil := ""
Local cCodEve := ""
Local cNumber := ""
Local cIdePro := ""
Local dDatEmi := CtoD("")
Local cCodFor := ""
Local cLojFor := ""
Local cMoePro := ""
Local cSpTipo := ""
Local cNomFor := ""
Local cCodPro := ""
Local cDesPro := ""
// Variaveis valores
Local nVlrAdt := 0
Local nVlrPre := 0
Local nVlrPgt := 0
// Variaveis Recnos
Local nRecZTN := 0
Local nRecZTF := 0
Local nRecSE2 := 0
Local nTitTot := 0
Local nSldTot := 0
// Status Totvs
Local cStaTot := ""
// Chaves
Local cChvAdt := ""
Local cChvDes := ""
Local cChvSol := ""
aCls01 := {}
DbSelectArea("SE2")
SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
DbSelectArea("SC1")
SC1->(DbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM
DbSelectArea("SF1")
SF1->(DbSetOrder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
DbSelectArea("SD1")
SD1->(DbSetOrder(22)) // D1_FILIAL + D1_PEDIDO + D1_ITEMPC
DbSelectArea("ZTN")
ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
DbSelectArea("ZTF")
ZTF->(DbSetOrder(1)) // ZTF_FILIAL + ZTF_CDSPID + ZTF_PROCES + ZTF_IDEPRO
DbSelectArea("ZTG")
ZTG->(DbSetOrder(1)) // ZTG_FILIAL + ZTG_EMPFIL + ZTG_PRCTHO + ZTG_NUMDOC + ZTG_SERDOC + ZTG_CODFOR + ZTG_LOJFOR + ZTG_TIPDOC
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA
If !Empty( cGetPrcPsq ) // Processo preenchido
    If ZTN->(DbSeek( _cFilZTN + "6062" )) // Processos
        While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN == _cFilZTN + "6062"
            If ZTN->ZTN_PVC201 == cGetPrcPsq // Processo conforme
                If ZTF->(DbSeek( ZTN->ZTN_FILIAL + ZTN->ZTN_NUMB01 + Left(ZTN->ZTN_PVC201,10) ))
                    While ZTF->(!EOF()) .And. ZTF->ZTF_FILIAL + ZTF->ZTF_CDSPID + ZTF->ZTF_PROCES == ZTN->ZTN_FILIAL + ZTN->ZTN_NUMB01 + Left(ZTN->ZTN_PVC201,10)
                        If !lChkAdtPre .Or. !(Left(ZTF->ZTF_SPTIPO,2) $ "01/02") // Nao Mostrar Adiantamentos/Prestacoes
                            If !lChkPagame .Or. Left(ZTF->ZTF_SPTIPO,2) <> "03" // .T.=Nao Mostrar Pagamentos
                                _aCls01 := {}
                                lShwReg := .T.
                                cEmpFil := ZTF->ZTF_AREANE                                              // 01: Area Negocio         Ex: "STECK CD            "
                                cCodEve := ZTN->ZTN_IDEVEN                                              // 02: Codigo Evento        Ex: "6062"
                                cNumber := ZTF->ZTF_CDSPID                                              // 03: Id                   Ex: "210       "
                                cIdePro := ZTF->ZTF_IDEPRO                                              // 04: Identif Processo     Ex: "147431    "
                                dDatEmi := StoD(StrTran(Left(ZTF->ZTF_DATEMI,10),"-",""))               // 05: Data Emissao         Ex: "2021-11-05T00:00:00Z"          -> 05/11/2021
                                cCodFor := SubStr(ZTF->ZTF_CODCRE,04,06)                                // 06: Cod Fornecedor       Ex: "F0102130501"                   -> 021305
                                cLojFor := SubStr(ZTF->ZTF_CODCRE,10,02)                                // 07: Loja Fornecedor      Ex: "F0102130501"                   -> 01
                                cNomFor := Space(30)                                                    // 08: Nome Fornecedor      Ex: "V. SANTOS ASSESSORIA"
                                cMoePro := ZTF->ZTF_CMOEDA                                              // 09: Moeda                Ex: "REAL"
                                cDespes := ZTF->ZTF_DESPES                                              // 10: Desc Despesa         Ex: "Com. Despachante"
                                cSpTipo := Left(ZTF->ZTF_SPTIPO,02)                                     // 11: Tipo                 Ex: 1=Adiantamento 2=Prestacao 3=Pagamento
                                nVlrAdt := 0                                                            // 13: Vlr Adiantamento
                                nVlrPre := 0                                                            // 14: Vlr Prestacao
                                nVlrPgt := 0                                                            // 15: Vlr Pagamento
                                cCodPro := ""                                                           // 18: Cod produto
                                cDesPro := ""                                                           // 19: Desc Produto

                                cObserv := ""                                                           // 24: Observacoes
                                cStaPrc := "301=Ok"                                                     // 25: Status de Processamento

                                nTitTot := 0
                                nSldTot := 0
                                nRecSE2 := 0
                                If SA2->(DbSeek( _cFilSA2 + cCodFor + cLojFor ))
                                    If lChkUniEst .Or. !(SA2->A2_COD $ "UNIAO /ESTADO/MUNIC /")
                                        cNomFor := SA2->A2_NREDUZ                                       // 08: Nome Fornecedor      Ex: 
                                        If "01" $ ZTF->ZTF_SPTIPO       // "01"=Adiantamento
                                            nVlrAdt := Val(ZTF->ZTF_ADIDES)                             // 11: Tipo
                                            If Empty( ZTF->ZTF_CHVADT )
                                                cStaPrc := "711=Adiantamento pendente no Totvs"
                                            ElseIf SE2->(!DbSeek( ZTF->ZTF_CHVADT )) // Localizo o titulo
                                                cStaPrc := "721=Adiantamento nao localizado no Totvs (SE2)"
                                            Else // Titulo localizado
                                                nTitTot := SE2->E2_VALOR
                                                nSldTot := SE2->E2_SALDO
                                                nRecSE2 := SE2->(Recno())
                                                If nSldTot == 0
                                                    cStaPrc := "822=Adiantamento nao tem saldo no Totvs (E2_SALDO)"
                                                EndIf
                                            EndIf
                                        ElseIf "02" $ ZTF->ZTF_SPTIPO   // "02"=Prestacao
                                            nVlrPre := Val(ZTF->ZTF_READES)
                                            If !("Serv" $ ZTF->ZTF_FLEXF3 .And. "NF" $ ZTF->ZTF_FLEXF3)
                                                If Empty( ZTF->ZTF_CHVDES )
                                                    cStaPrc := "711=Prestacao pendente no Totvs"
                                                ElseIf SE2->(!DbSeek( ZTF->ZTF_CHVDES )) // Localizo o titulo
                                                    cStaPrc := "725=Prestacao nao localizada no Totvs (SE2)"
                                                Else // Titulo localizado
                                                    nTitTot := SE2->E2_VALOR
                                                    nSldTot := SE2->E2_SALDO
                                                    nRecSE2 := SE2->(Recno())
                                                    If SE2->E2_SALDO == 0
                                                        cStaPrc := "826=Prestacao nao tem saldo no Totvs (E2_SALDO)"
                                                    EndIf
                                                EndIf
                                            EndIf
                                        ElseIf "03" $ ZTF->ZTF_SPTIPO   // "03"=Pagamento
                                            nVlrPgt := Val(ZTF->ZTF_PAGDES)
                                            If !("Serv" $ ZTF->ZTF_FLEXF3 .And. "NF" $ ZTF->ZTF_FLEXF3) // Nao eh nota
                                                If Empty( ZTF->ZTF_CHVDES )
                                                    cStaPrc := "713=Despesa pendente no Totvs"
                                                ElseIf SE2->(!DbSeek( ZTF->ZTF_CHVDES )) // Localizo o titulo
                                                    cStaPrc := "728=Despesa nao localizada no Totvs (SE2)"
                                                Else // Titulo localizado
                                                    nTitTot := SE2->E2_VALOR
                                                    nSldTot := SE2->E2_SALDO
                                                    nRecSE2 := SE2->(Recno())
                                                    If SE2->E2_SALDO == 0
                                                        cStaPrc := "829=Despesa nao tem saldo no Totvs (E2_SALDO)"
                                                    EndIf
                                                EndIf
                                            EndIf
                                        EndIf
                                        If "Serv" $ ZTF->ZTF_FLEXF3 .And. "NF" $ ZTF->ZTF_FLEXF3
                                            cCodPro := ZTF->ZTF_FLEXF4
                                            If SB1->(DbSeek( _cFilSB1 + cCodPro ))
                                                cDesPro := SB1->B1_DESC                                     // 19: Desc Produto
                                                If Empty( ZTF->ZTF_CHVSOL )
                                                    cStaPrc := "712=Solicitacao de Compra pendente no Totvs (SC1)"
                                                ElseIf SC1->(!DbSeek( ZTF->ZTF_CHVSOL ))
                                                    cStaPrc := "731=Solicitacao de Compra nao localizada no Totvs (SC1)"
                                                ElseIf Empty(SC1->C1_PEDIDO)
                                                    cStaPrc := "732=Solicitacao de Compra ainda nao gerou Pedido de Compra (SC1 x SC7)"
                                                ElseIf SD1->(!DbSeek( SC1->C1_FILIAL + SC1->C1_PEDIDO + SC1->C1_ITEMPED ))
                                                    cStaPrc := "733=Documento de Entrada ainda nao foi gerado no Totvs (SD1)"
                                                Else // Localizar o(s) Titulo(s) a pagar no Totvs
                                                    If SF1->(!DbSeek( SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_TIPO ))
                                                        cStaPrc := "734=Documento de Entrada ainda nao foi gerado no Totvs (SF1)"
                                                    ElseIf Empty(SF1->F1_DUPL) // Nao gerou titulos a pagar
                                                        cStaPrc := "735=Documento de Entrada nao gerou titulos a pagar (F1_DUPL)"
                                                    Else // Localizar o(s) Titulo(s) a pagar no Totvs
                                                        If SE2->(!DbSeek( SF1->F1_FILIAL + SF1->F1_PREFIXO + SF1->F1_DUPL ))
                                                            cStaPrc := "736=Titulos a Pagar nao identificados no Totvs (SE2): " + SF1->F1_FILIAL + "/" + SF1->F1_PREFIXO + "/" + SF1->F1_DUPL
                                                        Else // Titulos
                                                            While SE2->(!EOF()) .And. SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM == SF1->F1_FILIAL + SF1->F1_PREFIXO + SF1->F1_DUPL
                                                                aAdd( _aCls01, SE2->(Recno()) )
                                                                SE2->(DbSkip())
                                                            End
                                                        EndIf
                                                    EndIf
                                                EndIf
                                            Else // Produto nao encontrado (SB1)
                                                cStaPrc := "702=Produto nao encontrado no cadastro (SB1): " + cCodPro
                                            EndIf
                                        EndIf
                                        cStaTot := ZTF->ZTF_STATOT                                          // 20: Status Totvs
                                        cChvAdt := ZTF->ZTF_CHVADT                                          // 21: Chave Adiantamento
                                        cChvDes := ZTF->ZTF_CHVDES                                          // 22: Chave Despesa
                                        cChvSol := ZTF->ZTF_CHVSOL                                          // 23: Chave Solicitacao
                                        nRecZTN := ZTN->(Recno())                                           // 26: Recno ZTN
                                        nRecZTF := ZTF->(Recno())                                           // 27: Recno ZTF
                                        nRecSE2 := nRecSE2                                                  // 28: Recno SE2
                                    Else // Nao mostrar UNIAO /ESTADO/MUNIC /
                                        lShwReg := .F.
                                    EndIf
                                Else // Fornecedor nao encontrado (SA2)
                                    cStaPrc := "701=Fornecedor/Loja nao encontrado no cadastro (SA2): " + cCodFor + "/" + cLojFor
                                EndIf
                                If lShwReg // .T.=Apresentar o registro
                                    If !lChkIntTit .Or. Left(cStaPrc,1) <> "7" // Nao pendente de geracao no Totvs ou mostrar mesmo pendente
                                        cStaPrc := PadR(cStaPrc,200)                                        // 25: Status Processamento
                                        //           {      01,      02,      03,      04,      05,      06,      07,      08,      09,      10,      11,   12,      13,      14,      15,      16,      17,      18,      19,      20,      21,      22,      23,      24,      25,      26,      27,      28, .F. }
                                        aAdd(aCls01, { cEmpFil, cCodEve, cNumber, cIdePro, dDatEmi, cCodFor, cLojFor, cNomFor, cMoePro, cDespes, cSpTipo, "02", nVlrAdt, nVlrPre, nVlrPgt, nTitTot, nSldTot, cCodPro, cDesPro, cStaTot, cChvAdt, cChvDes, cChvSol, cObserv, cStaPrc, nRecZTN, nRecZTF, nRecSE2, .F. })
                                        If Len( _aCls01 ) > 0 // Recnos SE2 carregados... descarregar
                                            For _w1 := 1 To Len( _aCls01 )
                                                cStaPrc := "302=Titulo ok para processamento"
                                                SE2->(DbGoto( _aCls01[_w1] )) // Reposiciono SE2
                                                If SE2->E2_SALDO == 0
                                                    cStaPrc := "826=Prestacao nao tem saldo no Totvs (E2_SALDO)"
                                                EndIf
                                                cStaPrc := PadR(cStaPrc,200)                                // 25: Status Processamento
                                                //           {      01,      02,        03,      04,      05,      06,      07,      08,      09,      10,      11,   12,  13,            14, 15,            16,            17,      18,      19,      20,      21,      22,      23,      24,      25,      26,      27,             28, .F. }
                                                aAdd(aCls01, { cEmpFil, cCodEve, Space(10), cIdePro, dDatEmi, cCodFor, cLojFor, cNomFor, cMoePro, cDespes, cSpTipo, "02",   0, SE2->E2_VALOR,  0, SE2->E2_VALOR, SE2->E2_SALDO, cCodPro, cDesPro, cStaTot, cChvAdt, cChvDes, cChvSol, cObserv, cStaPrc, nRecZTN, nRecZTF, SE2->(Recno()), .F. })
                                            Next
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf
                        EndIf
                        ZTF->(DbSkip())
                    End
                EndIf
            EndIf
            ZTN->(DbSkip())
        End
    EndIf
    // Adequacao 01: Ordenacao de Processos relacionados (01=Adiantamento x 02=Prestacao)
    aSort(aCls01,,, {|x,y|, x[nP01SpTipo] + x[nP01IdePro] < y[nP01SpTipo] + y[nP01IdePro] }) // Ordenacao por SpTipo + Processo
    _w1 := 1
    While _w1 <= Len(aCls01)
        If aCls01[_w1,nP01SpTipo] == "01" // "01"=Adiantamento
            lPrest := .F.
            nFnd := _w1
            While (nFnd := ASCan(aCls01, {|x|, x[nP01SpTipo] == "02" .And. x[nP01IdePro] == aCls01[_w1,nP01IdePro] }, _w1 + 1, Nil)) > 0 // Localizada a "02"=Prestacao
                aSize(aCls01, Len( aCls01 ) + 1)                                // Aumento matriz
                aIns(aCls01, _w1 + 1)                                           // Insiro elemento vazio na sequencia
                aCls01[ _w1 + 1 ] := aClone( aCls01[ nFnd + 1 ] )               // Atualizo elemento
                aDel(aCls01, nFnd + 1)                                          // Deleto elemento
                aSize(aCls01, Len( aCls01 ) - 1)                                // Reduzo matriz
                lPrest := .T.
                _w1++
            End
            If !lPrest // Nao tem nenhuma prestacao
                aSize(aCls01, Len( aCls01 ) + 1)                                // Aumento matriz
                aIns(aCls01, _w1 + 1)                                           // Insiro elemento vazio na sequencia
                aCls01[ _w1 + 1 ] := LoadCols(aHdr01)[01]                       // Incluo elemento vazio
                aCls01[ _w1 + 1, nP01EmpFil ] := aCls01[ _w1, nP01EmpFil]       // Empresa/Filial
                aCls01[ _w1 + 1, nP01CodEve ] := aCls01[ _w1, nP01CodEve]       // Codigo Evento
                aCls01[ _w1 + 1, nP01IdePro ] := aCls01[ _w1, nP01IdePro]       // Identificacao Processo
                aCls01[ _w1 + 1, nP01CodFor ] := aCls01[ _w1, nP01CodFor]       // Cod Fornecedor
                aCls01[ _w1 + 1, nP01LojFor ] := aCls01[ _w1, nP01LojFor]       // Loja Fornecedor
                aCls01[ _w1 + 1, nP01NomFor ] := aCls01[ _w1, nP01NomFor]       // Nome Fornecedor
                aCls01[ _w1 + 1, nP01MoePro ] := aCls01[ _w1, nP01MoePro]       // Moeda
                aCls01[ _w1 + 1, nP01Despes ] := aCls01[ _w1, nP01Despes]       // Despesa
                aCls01[ _w1 + 1, nP01SpTipo ] := "02"                           // Tipo                                     Ex: "01"=Adiantamento "02"=Prestacao
                aCls01[ _w1 + 1, nP01MrkCmp ] := "02"                           // Compensar                                Ex: "01"=Sim "02"=Nao
                aCls01[ _w1 + 1, nP01VlrPre ] := aCls01[ _w1, nP01VlrPre]       // Valor Prestado
                aCls01[ _w1 + 1, nP01TitTot ] := 0                              // Valor Titulo Totvs
                aCls01[ _w1 + 1, nP01SldTot ] := 0                              // Saldo Titulo Totvs
                aCls01[ _w1 + 1, nP01StaTot ] := "01"                           // Status Totvs                             Ex: "01"=Pendente "02"=Processado

                aCls01[ _w1 + 1, nP01Observ ] := ""                             // Observacoes

                aCls01[ _w1 + 1, nP01StaPrc ] := "710=Aguardando prestacao"     // Status Processamento
                aCls01[ _w1 + 1, nP01RecZTN ] := 0                              // Recno ZTN
                aCls01[ _w1 + 1, nP01RecZTF ] := 0                              // Recno ZTF
                aCls01[ _w1 + 1, nP01RecSE2 ] := 0                              // Recno SE2
                _w1++
            EndIf
        ElseIf aCls01[_w1,nP01SpTipo] == "03" // "03"=Pagamento
            If !Empty(aCls01[_w1,nP01CodPro]) .And. Left(aCls01[ _w1, nP01StaPrc ],1) <> "3" // Tem produto (Solicitacao de Compra)
                aSize(aCls01, Len( aCls01 ) + 1)                                // Aumento matriz
                aIns(aCls01, _w1 + 1)                                           // Insiro elemento vazio na sequencia
                aCls01[ _w1 + 1 ] := LoadCols(aHdr01)[01]                       // Incluo elemento vazio
                aCls01[ _w1 + 1, nP01EmpFil ] := aCls01[ _w1, nP01EmpFil]       // Empresa/Filial
                aCls01[ _w1 + 1, nP01CodEve ] := aCls01[ _w1, nP01CodEve]       // Codigo Evento
                aCls01[ _w1 + 1, nP01IdePro ] := aCls01[ _w1, nP01IdePro]       // Identificacao Processo
                aCls01[ _w1 + 1, nP01CodFor ] := aCls01[ _w1, nP01CodFor]       // Cod Fornecedor
                aCls01[ _w1 + 1, nP01LojFor ] := aCls01[ _w1, nP01LojFor]       // Loja Fornecedor
                aCls01[ _w1 + 1, nP01NomFor ] := aCls01[ _w1, nP01NomFor]       // Nome Fornecedor
                aCls01[ _w1 + 1, nP01MoePro ] := aCls01[ _w1, nP01MoePro]       // Moeda
                aCls01[ _w1 + 1, nP01Despes ] := aCls01[ _w1, nP01Despes]       // Despesa
                aCls01[ _w1 + 1, nP01SpTipo ] := aCls01[ _w1, nP01SpTipo]       // Tipo
                aCls01[ _w1 + 1, nP01MrkCmp ] := "02"                           // Compensar                                Ex: "01"=Sim "02"=Nao
                aCls01[ _w1 + 1, nP01VlrPgt ] := aCls01[ _w1, nP01VlrPgt]       // Valor Pagamento
                aCls01[ _w1 + 1, nP01TitTot ] := 0                              // Valor Titulo Totvs
                aCls01[ _w1 + 1, nP01SldTot ] := 0                              // Saldo Titulo Totvs
                aCls01[ _w1 + 1, nP01StaTot ] := "01"                           // Status Totvs                             Ex: "01"=Pendente "02"=Processado

                aCls01[ _w1 + 1, nP01Observ ] := ""                             // Observacoes

                aCls01[ _w1 + 1, nP01StaPrc ] := "714=Aguardando nota"          // Status Processamento
                aCls01[ _w1 + 1, nP01RecZTN ] := 0                              // Recno ZTN
                aCls01[ _w1 + 1, nP01RecZTF ] := 0                              // Recno ZTF
                aCls01[ _w1 + 1, nP01RecSE2 ] := 0                              // Recno SE2
                _w1++
            EndIf
        EndIf
        _w1++
    End
    // Inclusao de prestacoes pendentes de titulos
    _w1 := 1
    While _w1 <= Len(aCls01)
        If _w1 < Len(aCls01)
            // Se for uma prestacao com nota e nao tem os titulos... incluir linha de pendencia
            If !Empty(aCls01[ _w1, nP01CodPro ])
                If aCls01[ _w1, nP01IdePro ] == aCls01[ _w1 + 1, nP01IdePro ] // Eh o mesmo processo
                    While _w1 < Len(aCls01) .And. aCls01[ _w1, nP01IdePro ] == aCls01[ _w1 + 1, nP01IdePro ]
                        _w1++
                    End
                Else // Nao eh o mesmo processo, criar linha de pendencia
                    _w2 := _w1 + 1
                    aSize(aCls01, Len( aCls01 ) + 1)                            // Aumento matriz
                    aIns(aCls01, _w2)                                           // Insiro elemento vazio na sequencia
                    aCls01[ _w2 ] := LoadCols(aHdr01)[01]                       // Incluo elemento vazio
                    aCls01[ _w2, nP01EmpFil ] := aCls01[ _w1, nP01EmpFil]       // Empresa/Filial
                    aCls01[ _w2, nP01CodEve ] := aCls01[ _w1, nP01CodEve]       // Codigo Evento
                    aCls01[ _w2, nP01IdePro ] := aCls01[ _w1, nP01IdePro]       // Identificacao Processo
                    aCls01[ _w2, nP01CodFor ] := aCls01[ _w1, nP01CodFor]       // Cod Fornecedor
                    aCls01[ _w2, nP01LojFor ] := aCls01[ _w1, nP01LojFor]       // Loja Fornecedor
                    aCls01[ _w2, nP01NomFor ] := aCls01[ _w1, nP01NomFor]       // Nome Fornecedor
                    aCls01[ _w2, nP01MoePro ] := aCls01[ _w1, nP01MoePro]       // Moeda
                    aCls01[ _w2, nP01Despes ] := aCls01[ _w1, nP01Despes]       // Despesa
                    aCls01[ _w2, nP01SpTipo ] := aCls01[ _w1, nP01SpTipo]       // Tipo
                    aCls01[ _w2, nP01MrkCmp ] := "02"                           // Compensar                                Ex: "01"=Sim "02"=Nao
                    aCls01[ _w2, nP01VlrPre ] := aCls01[ _w1, nP01VlrPre]       // Valor Prestado
                    aCls01[ _w2, nP01TitTot ] := 0                              // Valor Titulo Totvs
                    aCls01[ _w2, nP01SldTot ] := 0                              // Saldo Titulo Totvs
                    aCls01[ _w2, nP01StaTot ] := "01"                           // Status Totvs                             Ex: "01"=Pendente "02"=Processado

                    aCls01[ _w2, nP01Observ ] := ""                             // Observacoes

                    aCls01[ _w2, nP01StaPrc ] := "751=Aguardando nota"          // Status Processamento
                    aCls01[ _w2, nP01RecZTN ] := 0                              // Recno ZTN
                    aCls01[ _w2, nP01RecZTF ] := 0                              // Recno ZTF
                    aCls01[ _w2, nP01RecSE2 ] := 0                              // Recno SE2
                    _w1++
                EndIf
            EndIf
        EndIf
        _w1++
    End
    // Reordenacao do registro de pendencia
    _w1 := 1
    While _w1 <= Len(aCls01)
        If _w1 < Len(aCls01)
            If aCls01[ _w1, nP01SpTipo ] == aCls01[ _w1 + 1, nP01SpTipo ] // Mesmo Tipo
                If aCls01[ _w1, nP01IdePro ] == aCls01[ _w1 + 1, nP01IdePro ] // Mesmo processo
                    If Empty(aCls01[ _w1, nP01Number ]) // Sem Number, inverter
                        aHld01 := aClone(aCls01[ _w1 ])             // Hold
                        aCls01[ _w1 ] := aClone(aCls01[ _w1 + 1 ])  // Regravacao
                        aCls01[ _w1 + 1 ] := aClone(aHld01)         // Regravacao
                    EndIf
                EndIf
            EndIf
        EndIf
        _w1++
    End
    // Inclusao de registros CTE (ZTG)
    If !lChkPagame // .T.=Nao Mostrar Pagamentos
        If ZTG->(DbSeek( _cFilZTG + cEmpAnt + cFilAnt + cGetPrcPsq ))        
            DbSelectArea("SE2")
            SE2->(DbSetOrder(6)) // E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
            While ZTG->(!EOF()) .And. ZTG->ZTG_FILIAL + ZTG->ZTG_EMPFIL + ZTG->ZTG_PRCTHO == _cFilZTG + cEmpAnt + cFilAnt + cGetPrcPsq // Processo conforme
                If SE2->(DbSeek( _cFilSE2 + ZTG->ZTG_CODFOR + ZTG->ZTG_LOJFOR + ZTG->ZTG_PRFTIT + ZTG->ZTG_NUMTIT ))
                    While SE2->(!EOF()) .And. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == _cFilSE2 + ZTG->ZTG_CODFOR + ZTG->ZTG_LOJFOR + ZTG->ZTG_PRFTIT + ZTG->ZTG_NUMTIT
                        cEmpFil := SM0->M0_NOME                                                 // 01: Area Negocio         Ex: "STECK SP            "
                        cCodEve := "CTE "                                                       // 02: Codigo Evento        Ex: "CTE ", "6062"
                        cNumber := Space(10)                                                    // 03: Id                   Ex: "210       "
                        cIdePro := Space(10)                                                    // 04: Identif Processo     Ex: "147431    "
                        dDatEmi := SE2->E2_EMISSAO                                              // 05: Data Emissao         Ex: 17/02/2022
                        cCodFor := SE2->E2_FORNECE                                              // 06: Cod Fornecedor       Ex: 021305
                        cLojFor := SE2->E2_LOJA                                                 // 07: Loja Fornecedor      Ex: 01
                        cNomFor := SE2->E2_NOMFOR                                               // 08: Nome Fornecedor      Ex: "V. SANTOS ASSESSORIA"
                        cMoePro := "REAL"                                                       // 09: Moeda                Ex: "REAL"
                        cDespes := "Conhecimento Frete"                                         // 10: Desc Despesa         Ex: "Com. Despachante"
                        cSpTipo := "03"                                                         // 11: Tipo                 Ex: "01"=Adiantamento "02"=Prestacao "03"=Pagamento
                        cCodPro := ""                                                           // 18: Cod produto
                        cDesPro := ""                                                           // 19: Desc Produto
                        cStaTot := "02"                                                         // 20: Status Totvs         Ex: "02"=Como ja processado (pronto para compensacao)
                        cChvAdt := ""
                        cChvDes := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA    // Chave Despesa
                        cChvSol := ""
                        If SE2->E2_SALDO > 0
                            cStaPrc := "301=Ok"                                                 // 25: Status de Processamento
                        Else
                            cStaPrc := "829=Despesa nao tem saldo no Totvs (E2_SALDO)"          // 25: Status de Processamento
                        EndIf
                        nRecZTN := 0
                        nRecZTF := 0

                        cObserv := ""

                        cStaPrc := PadR(cStaPrc,200)
                        nTitTot := SE2->E2_VALOR
                        nSldTot := SE2->E2_SALDO
                        nRecSE2 := SE2->(Recno())
                        //           {      01,      02,        03,      04,      05,      06,      07,      08,      09,      10,      11,   12,  13,  14,            15,            16,            17,      18,      19,      20,      21,      22,      23,      24,      25,      26,      27,             28, .F. }
                        aAdd(aCls01, { cEmpFil, cCodEve, Space(10), cIdePro, dDatEmi, cCodFor, cLojFor, cNomFor, cMoePro, cDespes, cSpTipo, "02",   0,   0, SE2->E2_VALOR, SE2->E2_VALOR, SE2->E2_SALDO, cCodPro, cDesPro, cStaTot, cChvAdt, cChvDes, cChvSol, cObserv, cStaPrc, nRecZTN, nRecZTF, SE2->(Recno()), .F. })
                        SE2->(DbSkip())
                    End
                EndIf
                ZTG->(DbSkip())
            End
        EndIf
    EndIf
    // Inclusao de registros SC1 (que nao vem do ZTF)
    DbSelectArea("SE2")
    SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
    If !lChkPagame // .T.=Nao Mostrar Pagamentos
        cQrySC1 := "SELECT C1_FILIAL, C1_NUM, C1_ITEM "
        cQrySC1 += "FROM " + RetSqlName("SC1") + " WHERE "
        cQrySC1 += "C1_FILIAL = '" + _cFilSC1 + "' AND "                    // Filial conforme
        cQrySC1 += "C1_XPROTHO = '" + PadR( cGetPrcPsq, 20) + "' AND "      // Processo Thomson conforme
        cQrySC1 += "D_E_L_E_T_ = ' '"                                       // Nao apagado
        If Select("QRYSC1") > 0
            QRYSC1->(DbCloseArea())
        EndIf
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC1),"QRYSC1",.T.,.T.)
        Count To nRecsSC1
        If nRecsSC1 > 0 // Registros SC1 carregados
            _aCls01 := {}
            QRYSC1->(DbGotop())
            While QRYSC1->(!EOF())
                If ASCan( aCls01, {|x|, x[ nP01ChvSol ] == PadR( QRYSC1->C1_FILIAL + QRYSC1->C1_NUM + QRYSC1->C1_ITEM, 28 ) }) == 0 // Solicitacao ainda nao considerada proveniente do ZTF (nao duplicar)
                    If SC1->(!DbSeek( QRYSC1->C1_FILIAL + QRYSC1->C1_NUM + QRYSC1->C1_ITEM ))
                        cStaPrc := "771=Solicitacao de Compra nao localizada no Totvs (SC1)"
                    ElseIf Empty(SC1->C1_PEDIDO)
                        cStaPrc := "772=Solicitacao de Compra ainda nao gerou Pedido de Compra (SC1 x SC7)"
                    ElseIf SD1->(!DbSeek( SC1->C1_FILIAL + SC1->C1_PEDIDO + SC1->C1_ITEMPED ))
                        cStaPrc := "773=Documento de Entrada ainda nao foi gerado no Totvs (SD1)"
                    Else // Localizar o(s) Titulo(s) a pagar no Totvs
                        If SF1->(!DbSeek( SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_TIPO ))
                            cStaPrc := "774=Documento de Entrada ainda nao foi gerado no Totvs (SF1)"
                        ElseIf Empty(SF1->F1_DUPL) // Nao gerou titulos a pagar
                            cStaPrc := "775=Documento de Entrada nao gerou titulos a pagar (F1_DUPL)"
                        Else // Localizar o(s) Titulo(s) a pagar no Totvs
                            If SE2->(!DbSeek( SF1->F1_FILIAL + SF1->F1_PREFIXO + SF1->F1_DUPL ))
                                cStaPrc := "776=Titulos a Pagar nao identificados no Totvs (SE2): " + SF1->F1_FILIAL + "/" + SF1->F1_PREFIXO + "/" + SF1->F1_DUPL
                            Else // Titulos
                                While SE2->(!EOF()) .And. SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM == SF1->F1_FILIAL + SF1->F1_PREFIXO + SF1->F1_DUPL
                                    If ASCan( _aCls01, {|x|, x == SE2->(Recno()) }) == 0 // Titulo SE2 ainda nao considerado (evita duplicar)
                                        aAdd( _aCls01, SE2->(Recno()) )
                                    EndIf
                                    SE2->(DbSkip())
                                End
                            EndIf
                        EndIf
                    EndIf
                    If Left(cStaPrc,1) == "7" // Falha
                        cEmpFil := SM0->M0_NOME                                                 // 01: Area Negocio         Ex: "STECK SP            "
                        cCodEve := "SC1 "                                                       // 02: Codigo Evento        Ex: "SC1 "
                        cNumber := Space(10)                                                    // 03: Id                   Ex: "210       "
                        cIdePro := Space(10)                                                    // 04: Identif Processo     Ex: "147431    "
                        dDatEmi := CtoD("")                                                     // 05: Data Emissao         Ex: 17/02/2022
                        cCodFor := Space(06)                                                    // 06: Cod Fornecedor       Ex: 021305
                        cLojFor := Space(02)                                                    // 07: Loja Fornecedor      Ex: 01
                        cNomFor := Space(20)                                                    // 08: Nome Fornecedor      Ex: "V. SANTOS ASSESSORIA"
                        If SC1->(!EOF()) .And. !Empty(SC1->C1_FORNECE) // Se localizou a Solicitacao de Compra, carrego dados do SC1
                            cCodFor := SC1->C1_FORNECE                                          // 06: Cod Fornecedor       Ex: 021305
                            cLojFor := SC1->C1_LOJA                                             // 07: Loja Fornecedor      Ex: 01
                            If SA2->(DbSeek( _cFilSA2 + SC1->C1_FORNECE + SC1->C1_LOJA ))
                                cNomFor := SA2->A2_NREDUZ                                       // 08: Nome Fornecedor      Ex: "V. SANTOS ASSESSORIA"
                            EndIf
                        EndIf
                        cMoePro := "REAL"                                                       // 09: Moeda                Ex: "REAL"
                        cDespes := "Despesa Manual Totvs"                                       // 10: Desc Despesa         Ex: "Despesa Manual Totvs"
                        cSpTipo := "03"                                                         // 11: Tipo                 Ex: "01"=Adiantamento "02"=Prestacao "03"=Pagamento
                        cMarcad := "02"                                                         // 12: Marcado compensacao  Ex: "01"=Sim "02"=Nao
                        cCodPro := ""                                                           // 18: Cod produto
                        cDesPro := ""                                                           // 19: Desc Produto
                        cStaTot := "02"                                                         // 20: Status Totvs         Ex: "02"=Como ja processado (pronto para compensacao)
                        cChvAdt := ""                                                           // Chave Adiantamento
                        cChvDes := ""                                                           // Chave Despesa
                        cChvSol := ""                                                           // Chave Solicitacao

                        cObserv := Iif(SC1->(!EOF()), RTrim(SC1->C1_OBS), "")                   // 24: Observacoes

                        cStaPrc := PadR(cStaPrc,200)                                            // 25: Status Processamento
                        nRecZTN := 0                                                            // 26: Nao vem do ZTN
                        nRecZTF := 0                                                            // 27: Nao vem do ZTF
                        nRecSE2 := 0                                                            // 28: Recno do SE2 nao foi possivel identificar

                        //           {      01,      02,        03,      04,      05,      06,      07,      08,      09,      10,      11,      12,  13, 14,            15,            16,            17,      18,      19,      20,      21,      22,      23,      24,      25,      26,      27,      28, .F. }
                        aAdd(aCls01, { cEmpFil, cCodEve, Space(10), cIdePro, dDatEmi, cCodFor, cLojFor, cNomFor, cMoePro, cDespes, cSpTipo, cMarcad,   0,  0, SE2->E2_VALOR, SE2->E2_VALOR, SE2->E2_SALDO, cCodPro, cDesPro, cStaTot, cChvAdt, cChvDes, cChvSol, cObserv, cStaPrc, nRecZTN, nRecZTF, nRecSE2, .F. })
                    EndIf
                EndIf
                QRYSC1->(DbSkip())
            End
            If Len( _aCls01 ) > 0 // Registros carregados
                For _w1 := 1 To Len( _aCls01 ) // Registros SE2
                    cStaPrc := "302=Titulo ok para processamento"
                    SE2->(DbGoto( _aCls01[_w1] )) // Reposiciono SE2
                    If lChkUniEst .Or. !(SE2->E2_FORNECE $ "UNIAO /ESTADO/MUNIC /") // Mostra Uniao/Estado/Munic ou eh Uniao/Estado/Munic
                        If SE2->E2_SALDO == 0
                            cStaPrc := "886=Prestacao nao tem saldo no Totvs (E2_SALDO)"
                        EndIf
                        cEmpFil := SM0->M0_NOME                                                 // 01: Area Negocio         Ex: "STECK SP            "
                        cCodEve := "SC1 "                                                       // 02: Codigo Evento        Ex: "SC1 "
                        cNumber := Space(10)                                                    // 03: Id                   Ex: "210       "
                        cIdePro := Space(10)                                                    // 04: Identif Processo     Ex: "147431    "
                        dDatEmi := SE2->E2_EMISSAO                                              // 05: Data Emissao         Ex: 17/02/2022
                        cCodFor := SE2->E2_FORNECE                                              // 06: Cod Fornecedor       Ex: 021305
                        cLojFor := SE2->E2_LOJA                                                 // 07: Loja Fornecedor      Ex: 01
                        cNomFor := SE2->E2_NOMFOR                                               // 08: Nome Fornecedor      Ex: "V. SANTOS ASSESSORIA"
                        cMoePro := "REAL"                                                       // 09: Moeda                Ex: "REAL"
                        cDespes := "Despesa Manual Totvs"                                       // 10: Desc Despesa         Ex: "Despesa Manual Totvs"
                        cSpTipo := "03"                                                         // 11: Tipo                 Ex: "01"=Adiantamento "02"=Prestacao "03"=Pagamento
                        cMarcad := Iif(SE2->E2_FORNECE $ "UNIAO /ESTADO/MUNIC /", "01", "02")   // 12: Marcado compensacao  Ex: "01"=Sim "02"=Nao
                        cCodPro := ""                                                           // 18: Cod produto
                        cDesPro := ""                                                           // 19: Desc Produto
                        cStaTot := "02"                                                         // 20: Status Totvs         Ex: "02"=Como ja processado (pronto para compensacao)
                        cChvAdt := ""                                                           // Chave Adiantamento
                        cChvDes := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA    // Chave Despesa
                        cChvSol := ""                                                           // Chave Solicitacao

                        cObserv := RTrim(SE2->E2_HIST)                                          // 24: Observacoes

                        cStaPrc := PadR(cStaPrc,200)                                            // 25: Status Processamento
                        nRecZTN := 0                                                            // 26: Nao vem do ZTN
                        nRecZTF := 0                                                            // 27: Nao vem do ZTF

                        //           {      01,      02,        03,      04,      05,      06,      07,      08,      09,      10,      11,      12,  13, 14,            15,            16,            17,      18,      19,      20,      21,      22,      23,      24,      25,      26,      27,             28, .F. }
                        aAdd(aCls01, { cEmpFil, cCodEve, Space(10), cIdePro, dDatEmi, cCodFor, cLojFor, cNomFor, cMoePro, cDespes, cSpTipo, cMarcad,   0,  0, SE2->E2_VALOR, SE2->E2_VALOR, SE2->E2_SALDO, cCodPro, cDesPro, cStaTot, cChvAdt, cChvDes, cChvSol, cObserv, cStaPrc, nRecZTN, nRecZTF, SE2->(Recno()), .F. })
                    EndIf
                Next
            EndIf
        EndIf
        QRYSC1->(DbCloseArea())
    EndIf
EndIf
If Len( aCls01 ) == 0
    aCls01 := LoadCols( oGetD1:aHeader ) // Criacao do aCls01
EndIf
oGetD1:aCols := aClone(aCls01)
oGetD1:Refresh()
LoadsTot() // Totalizacoes
GetColor("01") // Montador de matriz de cores
// Carregar com os registros ja selecionados
For _w1 := 1 To Len( oGetD1:aCols )
    If Left(oGetD1:aCols[ _w1, nP01StaPrc ],1) == "3" // Status Registro "3??=Ok para processamento"
        If oGetD1:aCols[ _w1, nP01RecSE2 ] > 0 // Recno SE2
            If oGetD1:aCols[ _w1, nP01SldTot ] > 0 // Saldo positivo
                oGetD1:aCols[ _w1, nP01MrkCmp ] := "01" // "01"=Sim (Compensar)
            EndIf
        EndIf
    EndIf
Next
oGetD1:Refresh()
MrkCmpF8( .T. ) // Totalizacao dos selecionados
oGetD1:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LoadsHdr ºAutor ³ Jonathan Schmidt Alves ºData³ 22/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Totalizacoes.                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LoadsTot()
Local _w1
Local aCls01 := aClone(oGetD1:aCols)
// Totalizacoes Adto/Prestacao:
nGetAdtTho := 0
nGetAdtTot := 0
nGetPreTho := 0
nGetPreTot := 0
nGetPenTot := 0
// Totalizacoes gerais
cGetCliFor := ""
cGetTotAdt := "Adiantamentos: " + Chr(13) + Chr(10)
nGetTotAdt := 0
cGetTotPre := "Prestacoes: " + Chr(13) + Chr(10)
nGetTotPre := 0
cGetTotPgt := "Pagamentos: " + Chr(13) + Chr(10)
nGetTotPgt := 0
cGetTotPen := "Pendencias: " + Chr(13) + Chr(10)
nGetTotPen := 0
cGetSldClc := "Saldo Calculado: " + Chr(13) + Chr(10)
nGetSldClc := 0
If oGetD1:nAt > 0 .And. oGetD1:nAt <= Len( aCls01 )
    cGetCliFor := aCls01[ oGetD1:nAt, nP01CodFor ] + "/" + aCls01[ oGetD1:nAt, nP01LojFor ] + " " + aCls01[ oGetD1:nAt, nP01NomFor ]
    For _w1 := 1 To Len( aCls01 )
        // Totalizacoes Adto/Prestacao:
        If aCls01[ _w1, nP01IdePro ] == aCls01[ oGetD1:nAt, nP01IdePro ] // Mesmo processo da linha posicionada e tem number
            If aCls01[ _w1, nP01SpTipo ] == "01" // "01"=Adiantamento
                nGetAdtTho += aCls01[ _w1, nP01VlrAdt ]
                If aCls01[ _w1, nP01RecSE2 ] > 0 // Recno SE2
                    SE2->(DbGoto( aCls01[ _w1, nP01RecSE2 ] )) // Reposiciono SE2
                    nGetAdtTot += SE2->E2_VALOR
                EndIf
            ElseIf aCls01[ _w1, nP01SpTipo ] == "02" // "02"=Prestacao
                If !Empty( aCls01[ _w1, nP01Number ] )
                    nGetPreTho += aCls01[ _w1, nP01VlrPre ]
                    If aCls01[ _w1, nP01RecSE2 ] > 0 // Recno SE2
                        SE2->(DbGoto( aCls01[ _w1, nP01RecSE2 ] )) // Reposiciono SE2
                        nGetPreTot += SE2->E2_VALOR
                    ElseIf Empty( aCls01[ _w1, nP01CodPro ] ) // Nao tem produto
                        nGetPenTot += aCls01[ _w1, nP01VlrPre ]
                    EndIf
                Else
                    If aCls01[ _w1, nP01RecSE2 ] > 0 // Recno SE2
                        SE2->(DbGoto( aCls01[ _w1, nP01RecSE2 ] )) // Reposiciono SE2
                        nGetPreTot += SE2->E2_VALOR
                    Else
                        nGetPenTot += aCls01[ _w1, nP01VlrPre ]
                    EndIf
                EndIf
            EndIf
        EndIf
        // Totalizacoes Gerais:
        If aCls01[ _w1, nP01CodFor ] + aCls01[ _w1, nP01LojFor ] == aCls01[ oGetD1:nAt, nP01CodFor ] + aCls01[ oGetD1:nAt, nP01LojFor ] .Or. aCls01[ oGetD1:nAt, nP01CodEve ] $ "CTE /SC1 /" .Or. aCls01[ _w1, nP01CodEve ] $ "CTE /SC1 /" // Fornecedor/Loja conforme ou CTE
            If !Empty(aCls01[ _w1, nP01Number ]) .Or. aCls01[ _w1, nP01CodEve ] $ "CTE /SC1 /" // Apenas registros com Number devem ser considerados diretamente (os q nao tem number sao considerados indiretamente) ou CTE
                If aCls01[_w1,nP01SpTipo] == "01" // "01"=Adiantamento
                    nGetTotAdt += aCls01[_w1,nP01VlrAdt]
                    cGetTotAdt += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrAdt], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                ElseIf aCls01[_w1,nP01SpTipo] == "02" // "02"=Prestacao
                    If !Empty(aCls01[_w1, nP01CodPro ]) // Tem produto
                        If _w1 < Len(aCls01) .And. Left(aCls01[_w1 + 1, nP01StaPrc ],1) == "7" // Pendencia
                            nGetTotPen += aCls01[_w1,nP01VlrPre]
                            cGetTotPen += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPre], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        Else // Sem pendencia
                            nGetTotPre += aCls01[_w1,nP01VlrPre]
                            cGetTotPre += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPre], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        EndIf
                    Else // Nao tem produto
                        If Left(aCls01[_w1, nP01StaPrc ],1) == "7" // Pendencia
                            nGetTotPen += aCls01[_w1,nP01VlrPre]
                            cGetTotPen += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPre], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        Else // Sem pendencia
                            nGetTotPre += aCls01[_w1,nP01VlrPre]
                            cGetTotPre += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPre], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        EndIf
                    EndIf
                ElseIf aCls01[_w1,nP01SpTipo] == "03" // "03"=Pagamentos
                    If !Empty(aCls01[_w1, nP01CodPro ]) // Tem produto
                        If _w1 < Len(aCls01) .And. Left(aCls01[_w1 + 1, nP01StaPrc ],1) == "7" // Pendencia
                            nGetTotPen += aCls01[_w1,nP01VlrPgt]
                            cGetTotPen += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPgt], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        Else // Sem pendencia
                            nGetTotPgt += aCls01[_w1,nP01VlrPgt]
                            cGetTotPgt += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPgt], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        EndIf
                    Else // Nao tem produto
                        If Left(aCls01[_w1, nP01StaPrc ],1) == "7" // Pendencia
                            nGetTotPen += aCls01[_w1,nP01VlrPgt]
                            cGetTotPen += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPgt], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        Else // Sem pendencia
                            nGetTotPgt += aCls01[_w1,nP01VlrPgt]
                            cGetTotPgt += "R$ " + u_Tr3(TransForm(aCls01[_w1,nP01VlrPgt], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    Next
EndIf
// Adto/Prestacao:
oGetAdtTho:Refresh()
oGetAdtTot:Refresh()
oGetPreTho:Refresh()
oGetPreTot:Refresh()
oGetPenTot:Refresh()
// Totalizacoes Gerais:
oGetCliFor:Refresh()
oGetTotAdt:cToolTip := cGetTotAdt
oGetTotAdt:Refresh()
oGetTotPre:cToolTip := cGetTotPre
oGetTotPre:Refresh()
oGetTotPgt:cToolTip := cGetTotPgt
oGetTotPgt:Refresh()
oGetTotPen:cToolTip := cGetTotPen
oGetTotPen:Refresh()
nGetSldClc := nGetTotAdt - nGetTotPre - nGetTotPgt - nGetTotPen // Saldo calculado
oGetSldClc:cToolTip := Chr(13) + Chr(10) + Iif(nGetSldClc < 0, "Saldo a nosso favor:", "Saldo a seu favor:") + Chr(13) + Chr(10) + "R$ " + u_Tr3(TransForm(nGetSldClc, "@E 99,999,999.99")) + Chr(13) + Chr(10)
oGetSldClc:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GetColor ºAutor ³ Jonathan Schmidt Alves ºData³ 24/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento da matriz de cores da getdados.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GetColor(cGet) // Montador de matriz de cores
Local _w1
Local _w2
Local nClr
Local lErr := .F.
Local cEval := ""
&("aCor" + cGet) := {}
&("aSel" + cGet) := {}
If cGet == "01"
    cEval := "oGetD1:aCols[_w2,nP01IdePro] == oGetD1:aCols[_w1,nP01IdePro]"     // Status normal
	cEvEr := "Left(oGetD1:aCols[_w1,nP01StaPrc],1) == '7'"                      // Erro
    cEvPr := "oGetD1:aCols[_w1,nP01SpTipo] == '03'"                             // Pagamento
    cEvUF := "oGetD1:aCols[_w1,nP01CodFor] $ 'UNIAO /ESTADO/MUNIC /'"           // UNIAO/ESTADO/MUNIC
EndIf
If !Empty(cEval) // Eval carregado
	For _w1 := 1 To Len( &("aCls" + cGet) )
        lErr := &(cEvEr) // "7??=Status Processamento com Erro
		If _w1 == 1
            &("nClr" + cGet) := 1
        ElseIf &(cEvPr) // Se for pagamento tambem fica no primeiro
			&("nClr" + cGet) := 1
		Else
			_w2 := _w1 - 1
			If &( cEval ) // Mesmo documento
				nClr := &("nClr" + cGet)
			Else // Outro documento
				&("nClr" + cGet) += 1
				If &("nClr" + cGet) > Len( &("aClr" + cGet) )
					&("nClr" + cGet) := 1
				EndIf
			EndIf
		EndIf
        If !lErr // Sem erro
            If  &(cEvUF) // Se for UNIAO/ESTADO/MUNIC
                nClr := nC01C00 // Cinza Mais Claro
                nSel := nC01S01 // Cinza Claro Selecionado
            Else
                nClr := &("aClr" + cGet)[ &("nClr" + cGet), 01 ] // Codigo da cor
                nSel := &("aClr" + cGet)[ &("nClr" + cGet), 02 ] // Codigo da cor qdo linha selecionada
            EndIf
        Else // Erro
            nClr := nC01C07 // Vermelho Claro
            nSel := nC01S07 // Vermelho Escuro
        EndIf
		aAdd(&("aCor" + cGet), nClr)
        aAdd(&("aSel" + cGet), nSel)
	Next
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MrkCmpF8 ºAutor ³ Jonathan Schmidt Alves ºData³ 24/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca/Desmarca registros para compensacao.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MrkCmpF8( lTots )
Local _w1
Local nLin := oGetD1:nAt
Local aLin := oGetD1:aCols[ nLin ]
// Tooltips
Local cGetAdtSel := ""
Local cGetPgtSel := ""
Local cGetSldSel := ""
// Mensagens
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local cMsg04 := ""
If !lTots // .F.=Nao apenas totalizacao .T.=Apenas totalizacao
    If Left(aLin[ nP01StaPrc ],1) == "3" // "3??"=Ok para processamento
        If aLin[ nP01SpTipo ] == "01" // Adiantamento
            If aLin[ nP01RecSE2 ] == 0 // Titulo nao localizado
                cMsg01 := "Nao foi localizado titulo para este processamento!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            ElseIf aLin[ nP01SldTot ] == 0 // Titulo sem saldo
                cMsg01 := "Titulo nao tem saldo para compensacao!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            Else // Ok
                aLin[ nP01MrkCmp ] := StrZero(Abs( Val(aLin[ nP01MrkCmp ]) - 02 ) + 1,2)
            EndIf
        ElseIf aLin[ nP01SpTipo ] == "02" // Prestacao
            If aLin[ nP01RecSE2 ] == 0 // Titulo nao localizado
                cMsg01 := "Nao foi localizado titulo para este processamento!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            ElseIf aLin[ nP01SldTot ] == 0 // Titulo sem saldo
                cMsg01 := "Titulo nao tem saldo para compensacao!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            Else // Ok
                aLin[ nP01MrkCmp ] := StrZero(Abs( Val(aLin[ nP01MrkCmp ]) - 02 ) + 1,2)
            EndIf
        ElseIf aLin[ nP01SpTipo ] == "03" // Pagamento
            If aLin[ nP01RecSE2 ] == 0 // Titulo nao localizado
                cMsg01 := "Nao foi localizado titulo para este processamento!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            ElseIf aLin[ nP01SldTot ] == 0 // Titulo sem saldo
                cMsg01 := "Titulo nao tem saldo para compensacao!"
                cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
            Else // Ok
                aLin[ nP01MrkCmp ] := StrZero(Abs( Val(aLin[ nP01MrkCmp ]) - 02 ) + 1,2)
            EndIf
        EndIf
        oGetD1:aCols[ nLin ] := aClone( aLin )
        oGetD1:Refresh()
    Else// Titulo nao ok
        cMsg01 := "Titulo nao pode ser marcado para compensacao!"
        cMsg02 := "Verifique o registro referente ao titulo a pagar e tente novamente!"
    EndIf
EndIf
If Empty(cMsg01) // Sem mensagens de erro
    // Saldo Compensacoes:
    nGetAdtSel := 0
    cGetAdtSel := Chr(13) + Chr(10) + "Adiantamentos Sel:" + Chr(13) + Chr(10)
    nGetPgtSel := 0
    cGetPgtSel := Chr(13) + Chr(10) + "Pagamentos Sel:" + Chr(13) + Chr(10)
    For _w1 := 1 To Len( oGetD1:aCols )
        If oGetD1:aCols[ _w1, nP01MrkCmp ] == "01" // Marcado
            If oGetD1:aCols[ _w1, nP01SpTipo ] == "01" // Adiantamentos
                If ASCan( oGetD1:aCols, {|x|, x[ nP01ChvAdt ] == oGetD1:aCols[ _w1, nP01ChvAdt ] .And. x[ nP01MrkCmp ] == "01" }, _w1 + 1) == 0 // Nao tem essa mesma chave de adto adiante selecionada
                    nGetAdtSel += oGetD1:aCols[ _w1, nP01SldTot ] // Saldo Totvs
                    cGetAdtSel += "R$ " + u_Tr3(TransForm(oGetD1:aCols[ _w1, nP01SldTot ], "@E 99,999,999.99")) + Chr(13) + Chr(10)
                EndIf
            Else // Prest/Pgtos
                nGetPgtSel += oGetD1:aCols[ _w1, nP01SldTot ] // Saldo Totvs
                cGetPgtSel += "R$ " + u_Tr3(TransForm(oGetD1:aCols[ _w1, nP01SldTot ], "@E 99,999,999.99")) + Chr(13) + Chr(10)
            EndIf
        EndIf
    Next
    nGetSldSel := nGetAdtSel - nGetPgtSel // Saldo
    cGetSldSel := "Saldo Sel:" + Chr(13) + Chr(10)
    cGetSldSel += "R$ " + u_Tr3(TransForm(nGetSldSel, "@E 99,999,999.99"))
    oGetAdtSel:cToolTip := cGetAdtSel
    oGetAdtSel:Refresh()
    oGetPgtSel:cToolTip := cGetPgtSel
    oGetPgtSel:Refresh()
    oGetSldSel:cToolTip := cGetSldSel
    oGetSldSel:Refresh()
Else // Mensagem de erro
    MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
    cMsg02 + Chr(13) + Chr(10) + ;
    cMsg03 + Chr(13) + Chr(10) + ;
    cMsg04,"MrkCmpF8")
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrcPrest ºAutor ³ Jonathan Schmidt Alves ºData³ 29/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento das compensacoes marcadas.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PrcPrest( nRadPrc ) // Processar
Local _w1
Local _w2
Local lRet := .T.
Local nFnd := 0
Local aAdtos := {}
Local aPrsts := {}
Local aRegsSE2 := {}
Local nSldAdt := 0
Local nSldPre := 0
Local nMsgPrc := 2 // 2=AskYesNo
// Variaveis envio email
Local lEnvMail := .F.
Local lSldTits := .F.
Local cProTho := ""
Local cPara := ""
Local cCopia := ""
Local cAssunto := "Prestacao de Contas"
Local cMsg := ""
Local aAttach := {}
Local cCaminho := ""
Local cCo := ""
For _w1 := 1 To Len( oGetD1:aCols )
    If oGetD1:aCols[ _w1, nP01MrkCmp ] == "01" // "01"=Compensar
        If oGetD1:aCols[ _w1, nP01RecSE2 ] > 0 // Recno SE2
            SE2->(DbGoto( oGetD1:aCols[ _w1, nP01RecSE2 ] )) // Posiciono SE2
            If oGetD1:aCols[ _w1, nP01SldTot ] > 0 // Saldo
                If oGetD1:aCols[ _w1, nP01SpTipo ] == "01" // "01"=Adiantamento
                    If ASCan( aAdtos, {|x|, x == SE2->(Recno()) }) == 0 // Recno Adto ainda nao considerado
                        aAdd( aAdtos, SE2->(Recno()) )
                    EndIf
                ElseIf oGetD1:aCols[ _w1, nP01SpTipo ] $ "02/03/" // "02"=Prestacao/Pagamento
                    aAdd( aPrsts, SE2->(Recno()) )
                EndIf
            EndIf
        EndIf
    EndIf
Next
If Len( aAdtos ) > 0 .And. Len( aPrsts ) > 0 // Adiant e Prest/Pgt carregados
    For _w1 :=  1 To Len( aAdtos )
        For _w2 := 1 To Len( aPrsts )
            If lRet // .T.=Ainda valido
                SE2->(DbGoto( aAdtos[ _w1 ] )) // Reposiciono no titulo PA
                If (nSldAdt := SE2->E2_SALDO) > 0 // Saldo PA
                    SE2->(DbGoto( aPrsts[ _w2 ] )) // Reposiciono no titulo Prestacao/Pagamento
                    If (nSldPre := SE2->E2_SALDO) > 0 // Saldo Prest/Pgto
                        //      ( TipProc,  Recno Adiant, Recno PrstPgt,       Valor a Compensar, MsgProc )
                        //      (      01,            02,            03,                      04,      05 )
                        u_AskYesNo(1200,"Compensacao","Processando Compensacao...","","","","","NOTE",.T.,.F.,{|| lRet := CompeTit( nRadPrc, aAdtos[ _w1 ], aPrsts[ _w2 ], Min( nSldAdt, nSldPre ), nMsgPrc ) }) // Compensacao                    
                        If lRet // .T.=Compensacao processada com sucesso
                            lEnvMail := .T. // .T.=Houve compensacao, entao enviar e-mail no final do processamento
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
    // Atualizar GetDados/Recarregar saldos/Etc
    For _w1 := 1 To Len( oGetD1:aCols )
        If oGetD1:aCols[ _w1, nP01MrkCmp ] == "01" // "01"=Compensar
            If oGetD1:aCols[ _w1, nP01RecSE2 ] > 0 // Recno
                SE2->(DbGoto( oGetD1:aCols[ _w1, nP01RecSE2 ] )) // Reposiciono SE2
                oGetD1:aCols[ _w1, nP01SldTot ] := SE2->E2_SALDO // Ajusto coluna de saldo
                // Atualizacao do saldo de outros adiantamentos
                nFnd := _w1
                While (nFnd := ASCan( oGetD1:aCols, {|x|, x[ nP01RecSE2 ] == SE2->(Recno()) }, nFnd + 1, Nil )) > 0
                    oGetD1:aCols[ nFnd, nP01SldTot ] := SE2->E2_SALDO // Ajusto coluna de saldo
                End
            EndIf
            oGetD1:aCols[ _w1, nP01MrkCmp ] := "02" // "02"=Nao Compensar
            oGetD1:Refresh()
        EndIf
    Next
    // Resetar totalizacodes de selecionados:               02-0084/22
    nGetAdtSel := 0 // Saldo Adiantamentos
    nGetPgtSel := 0 // Saldo Prestacoes/Pagamentos
    nGetSldSel := 0 // Saldo Resultado
    oGetAdtSel:Refresh()
    oGetPgtSel:Refresh()
    oGetSldSel:Refresh()
    LoadsTot() // Recarrego os totalizacoes
    oGetD1:Refresh()
    If MsgYesNo("Envia e-mail com resultados do processamento?") // Envio de e-mail
        If nRadPrc == 1 // 1=Importacao
            cAssunto += " Importacao"
            If lEnvMail // .T.=Enviar e-mail
                For _w1 := 1 To Len( oGetD1:aCols )
                    If Empty( cProTho ) // Ainda nao identificou o processo
                        If oGetD1:aCols[ _w1, nP01RecZTN ] > 0 // Recno ZTN
                            ZTN->(DbGoto( oGetD1:aCols[ _w1, nP01RecZTN ] )) // Posiciono no ZTN
                            If !Empty( ZTN->ZTN_PVC201 )
                                cProTho := RTrim(ZTN->ZTN_PVC201) // Numero do Processo Thomson        Ex: "02-0077/22"

                                For _w2 := 1 To Len( oGetD1:aCols )
                                    If oGetD1:aCols[ _w2, nP01RecSE2 ] > 0 // Recno SE2
                                        SE2->(DbGoto( oGetD1:aCols[ _w2, nP01RecSE2 ] )) // Posiciono no primeiro SE2 (se for PA eh saldo a receber, senao eh a pagar)
                                        If SE2->E2_SALDO > 0 // Ficou com saldo
                                            If SE2->E2_TIPO == "PA "
                                                cSaldo := "Saldo a RECEBER."
                                            Else
                                                cSaldo := "Saldo a PAGAR."
                                            EndIf
                                            Exit
                                        EndIf
                                    EndIf
                                Next

                                // Envio de E-mail com os titulos e saldos resultado
                                cPara := "lilia.lima@steck.com.br;adriana.toni@se.com;eric.lopes@se.com"
                                cMsg   := ""
                                cMsg  += '<html>'
                                cMsg  += '<form action="mailto:%WFMailTo%" method="POST"'
                                cMsg  += 'name="FrontPage_Form1">'
                                cMsg  += '    <table border="0" >'
                                cMsg  += '                <tr>'
                                cMsg  += '                    <td colspan="13" width="630" bgcolor="#DFEFFF"'
                                cMsg  += '                    height="24"><p align="center"><font size="4"'
                                cMsg  += '                    face="verdana"><b>Processamento de Prestacao de Contas Importacao realizado. ' + cSaldo + '</b></font></p>'
                                cMsg  += '                    </td>'
                                cMsg  += '                </tr>'
                                cMsg  += '                <tr>'
                                cMsg  += '                    <td colspan="13" width="630" bgcolor="#DFEFFF"'
                                cMsg  += '                    height="24"><p align="center"><font size="4"'
                                cMsg  += '                    face="verdana"><b>Titulos a Pagar que fazem parte do acerto: ' + cProTho + '</b></font></p>'
                                cMsg  += '                    </td>'
                                cMsg  += '                </tr>'
                                cMsg  += '<tr>'
                                cMsg  += '    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Filial</font></td>'
                                cMsg  += '    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Codigo</font></td>'
                                cMsg  += '    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Loja</font></td>'
                                cMsg  += '    <td align="center" width="200"  bgcolor="#DFEFFF" height="18"><font face="verdana">Nome do Fornecedor</font></td>'
                                cMsg  += '    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Prefixo</font></td>'
                                cMsg  += '    <td align="center" width="80" bgcolor="#DFEFFF" height="18"><font face="verdana">Titulo</font></td>'
                                cMsg  += '    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Parcela</font></td>'
                                cMsg  += '    <td align="center" width="120"  bgcolor="#DFEFFF" height="18"><font face="verdana">Tipo</font></td>'
                                cMsg  += '    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Emissão</font></td>'
                                cMsg  += '    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Vencimento</font></td>'
                                cMsg  += '    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Venc.Real</font></td>'
                                cMsg  += '    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Valor</font></td>'
                                cMsg  += '    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Saldo</font></td>'
                                cMsg  += '</tr>'
                            EndIf
                        EndIf
                    EndIf
                    If !Empty( cProTho ) // Processo carregado
                        If oGetD1:aCols[ _w1, nP01RecSE2 ] > 0 // Recno do SE2
                            SE2->(DbGoto( oGetD1:aCols[ _w1, nP01RecSE2 ] )) // Posiciono no SE2
                            If SE2->E2_SALDO > 0 // Ficou saldo
                                If ASCan( aRegsSE2, {|x|, x == SE2->(Recno()) }) == 0 // Recno SE2 ainda nao considerado (no ZTN podemos ter o mesmo SE2 que vem do Thomson em partes menores, evitar mostrar mais de 1 vez o mesmo titulo SE2)
                                    lSldTits := .T. // Ficou saldo em algum titulo
                                    cMsg += '<tr>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_FILIAL + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_FORNECE + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_LOJA + '</font></td>'
                                    cMsg += '  <td align="left"><font size="1" face="verdana">' + SE2->E2_NOMFOR + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_PREFIXO + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_NUM + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_PARCELA + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + SE2->E2_TIPO + " " + {"Adiantamento","Prestacao","Pagamento"}[ Val(oGetD1:aCols[ _w1, nP01SpTipo ]) ] + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + DtoC(SE2->E2_EMISSAO) + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + DtoC(SE2->E2_VENCTO) + '</font></td>'
                                    cMsg += '  <td align="center"><font size="1" face="verdana">' + DtoC(SE2->E2_VENCREA) + '</font></td>'
                                    cMsg += '  <td align="right"><font size="1" face="verdana">' + Transform(SE2->E2_VALOR,"@E 99999999.99") + '</font></td>'
                                    cMsg += '  <td align="right"><font size="1" face="verdana">' + Transform(SE2->E2_SALDO,"@E 99999999.99") + '</font></td>'
                                    cMsg += '</tr>'
                                    aAdd(aRegsSE2, SE2->(Recno()))
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                Next
                If !Empty( cProTho ) // Processo Thomson identificado
                    If !lSldTits // .F.=Nao ficou saldo em nenhum titulo
                        cMsg += "Titulos foram processados e nao ficou saldo em aberto em nenhum titulo." + Chr(13) + Chr(10)
                    EndIf
                    cMsg += '            </table>'
                    cMsg += '</form>'
                    cMsg += '</body>'
                    cMsg += '</html>'
                    // Envio de e-mail:
                    u_STMAILTES(cPara, cCopia, cAssunto, cMsg, aAttach, cCaminho, cCo)
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ CompeTit ºAutor ³ Jonathan Schmidt Alves ºData³ 29/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento das compensacoes marcadas.                   º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ nRadPrc: Processo 1=Importacao ou 2=Exportacao             º±±
±±º          ³ nRecAdt: Recno do adiantamento                             º±±
±±º          ³ nRecPre: Recno da prestacao/pagamento                      º±±
±±º          ³ nVlrCmp: Valor a compensar                                 º±±
±±º          ³ nMsgPrc: Mensagens de processamento                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CompeTit(nRadPrc, nRecAdt, nRecPre, nVlrCmp, nMsgPrc)
Local _z1
Local lRet := .T.
Local aTxMoeda := {}
Local cProcCmp := { "Compensacao Pagar", "Compensacao Receber" } [ nRadPrc ]
If nMsgPrc == 2 // Mensagens
	_oMeter:nTotal := 9
	For _z1 := 1 To 3
		u_AtuAsk09(++nCurrent,"Processando " + cProcCmp + "...","","","",80,"PROCESSA")
		Sleep(050)
	Next
EndIf
If nRadPrc == 1 // 1=Importacao (Compensacao Pagar)
	DbSelectArea("SE2")
	SE2->(DbSetOrder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	SE2->(DbGoto(nRecAdt)) // Posiciono no titulo PA
    If SE2->(!EOF())
		cTitPA := "'Adto Pagar ' Pref/Num: " + SE2->E2_PREFIXO + "/" + SE2->E2_NUM + " " + SE2->E2_NOMFOR
		SE2->(DbGoto(nRecPre)) // Posiciono no titulo NF
		If SE2->(!EOF())
			cTitNF := "'NF ' Pref/Num: " + SE2->E2_PREFIXO + "/" + SE2->E2_NUM + " " + SE2->E2_NOMFOR

			If nMsgPrc == 2 // Mensagens
				For _z1 := 1 To 3
					u_AtuAsk09(nCurrent,"Processando " + cProcCmp + "...", cTitPA, cTitNF, "", 80, "PROCESSA")
					Sleep(120)
				Next
			EndIf

			// Contabilizacao para compensacao nao deve ocorrer
			Pergunte("AFI340",.F.)
			lAglutina		:= .F.              // Aglutina Lancamento Contabil 	1=Sim 2=Nao (Nao aglutinar)
			lDigita			:= .F.              // Mostra Lancamento Contabil		1=Sim 2=Nao
			lContabiliza 	:= .F.              // Contabiliza OnLine				1=Sim 2=Nao (Sempre Offline)
			nTaxaCM			:= RecMoeda(dDataBase, SE2->E2_MOEDA)
			aAdd(aTxMoeda, { 1, 1 })
			aAdd(aTxMoeda, { 2, nTaxaCM })
			SE2->(DbSetOrder(2)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
			aRecPA := { nRecAdt } // Recno Adiantamento
			aVlrPA := { nVlrCmp } // Valor a compensar
			aRecNF := { nRecPre } // Recno Prestacao/Pagamento
			If !MaIntBxCP(2,aRecNF,,aRecPA,,{ lContabiliza, lAglutina, lDigita, .F., .F., .F. },,,,,dDatabase)
				If nMsgPrc == 2 // Mensagens
					For _z1 := 1 To 3 //
						u_AtuAsk09(nCurrent,"Processando " + cProcCmp + "... Falha!", cTitPA, cTitNF, "", 80, "UPDERROR")
						Sleep(1000)
					Next
				EndIf
				Help("CompeTit",1,"HELP","CompeTit","Nao foi possivel a " + cProcCmp + Chr(13) + Chr(10) + " do titulo do adiantamento" + Chr(13) + Chr(10) + cTitPA + Chr(13) + Chr(10) + cTitNF,1,0)
				lRet := .F.
			Else // Sucesso na compensacao
				If nMsgPrc == 2 // Mostra mensagens
					For _z1 := 1 To 3
						u_AtuAsk09(nCurrent,"Processando " + cProcCmp + "... Sucesso!", cTitPA, cTitNF, "", 80, "OK")
						Sleep(440)
					Next
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LoadsHdr ºAutor ³ Jonathan Schmidt Alves ºData³ 17/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para recarregamento dos headers.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LoadsHdr(cHdr)
Local aHdr := {}
// ########### ZTF #############
If cHdr $ "ZTF" // Estrutura ZTF
    aAdd(aHdr, { "EmpFil",          "I01_EMPFIL",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    // Evento, Number, Processo
    aAdd(aHdr, { "Evento",          "I01_CODEVE",	"",                 08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Number",          "I01_NUMBER",	"",                 08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Process",         "I01_IDEPRO",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    // Dados Fornecedor
    aAdd(aHdr, { "Emissao",         "I01_DATEMI",	"",                 08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "", "" }) // 05
    aAdd(aHdr, { "CodFor",          "I01_CODFOR",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 06
    aAdd(aHdr, { "LojFor",          "I01_LOJFOR",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 07
    aAdd(aHdr, { "NomFor",          "I01_NOMFOR",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 08
    aAdd(aHdr, { "Moeda",           "I01_MOEPRO",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 09
    aAdd(aHdr, { "Despesa",         "I01_DESPES",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 10
    aAdd(aHdr, { "Tipo",            "I01_SPTIPO",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "01=01:Adiantamento;02=02:Prestacao;03=03:Pagamento", "" }) // 11
    // Compensar
    aAdd(aHdr, { "Compensar",       "I01_MRKCMP",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "01=01:Sim;02=02:Nao", "" }) // 12
    // Valores
    aAdd(aHdr, { "Vlr Adto",        "I01_VLRADT",	"@E 99,999,999.99", 12, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 13
    aAdd(aHdr, { "Vlr Prest",       "I01_VLRPRE",	"@E 99,999,999.99", 12, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 14
    aAdd(aHdr, { "Vlr Pgto",        "I01_VLRPGT",	"@E 99,999,999.99", 12, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 15
    aAdd(aHdr, { "Vlr Tit Totvs",   "I01_TITTOT",	"@E 99,999,999.99", 12, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 16
    aAdd(aHdr, { "Sld Tit Totvs",   "I01_SLDTOT",	"@E 99,999,999.99", 12, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 17
    // Produto
    aAdd(aHdr, { "Produto",         "I01_CODPRO",	"",                 15, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 18
    aAdd(aHdr, { "Desc Produto",    "I01_DESPRO",	"",                 40, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 19
    aAdd(aHdr, { "Status Totvs",    "I01_STATOT",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "01=01:Pendente;02=02:Processado", "" }) // 20
    // Chaves
    aAdd(aHdr, { "Chave Adto",      "I01_CHVADT",	"",                 28, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 21
    aAdd(aHdr, { "Chave Despesa",   "I01_CHVDES",	"",                 28, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 22
    aAdd(aHdr, { "Chave Solicit",   "I01_CHVSOL",	"",                 28, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 23
    // Observacoes
    aAdd(aHdr, { "Observacoes",     "I01_OBSERV",	"",                100, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 24
    // Status
    aAdd(aHdr, { "Status Proc",     "I01_STAPRC",	"",                150, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 25
    // Recnos
    aAdd(aHdr, { "Recno ZTN",       "I01_RECZTN",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 26
    aAdd(aHdr, { "Recno ZTF",       "I01_RECZTF",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 27
    aAdd(aHdr, { "Recno SE2",       "I01_RECSE2",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 28
EndIf
Return aHdr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ LoadCols ºAutor ³ Jonathan Schmidt Alves ºData³ 17/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregamento do aCols conforme padrao do aHdr01 passado.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PrestTho ºAutor ³ Jonathan Schmidt Alves ºData³ 17/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para preenchimento e gravacao do CTE relacionado a    º±±
±±º          ³ processo Thomson. Ex: "02-0002/22"                         º±±
±±º          ³                                                            º±±
±±º          ³ Processo do Avelino (Compensacao Thomson x Totvs ZTF       º±±
±±º          ³ Jonathan 17/02/2022)                                       º±±
±±º          ³                                                            º±±
±±º          ³ Chamada via MT103FIM:                                      º±±
±±º          ³                                                            º±±
±±º          ³ If SF1->F1_ESPECIE == "CTE  "                              º±±
±±º          ³     If ExistBlock( "PRESTTHO" )                            º±±
±±º          ³         u_PrestTho() // Tela/Gravacao ZTG (Prestacao)      º±±
±±º          ³     EndIf                                                  º±±
±±º          ³ EndIf                                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PrestTho() // Prestacao Thomson
Private oPrcTho
Private oDlgCTE
Private cPrcTho := Space(30)
Private _cFilZTG := xFilial("ZTG")
Private bAction := {|| GrvPrcTh() }

If isBlind()
    Return(.t.)
EndIf

DEFINE MSDIALOG oDlgCTE FROM 010,005 TO 020,060 TITLE OemToAnsi("MT103FIM: CTE THOMSON") // "Local de Entrada"
@001,003 SAY OemToAnsi("Processo Thomson: ") // "Processo Thomson"
@001,008 MSGET oPrcTho VAR cPrcTho VALID VldPrcTh() HASBUTTON
DEFINE SBUTTON FROM 060,180 TYPE 1 ACTION ( Eval(bAction) ) ENABLE OF oDlgCTE
ACTIVATE MSDIALOG oDlgCTE CENTERED
Return

Static Function VldPrcTh()
Local lRet := .T.
DbSelectArea("ZTG")
ZTG->(DbSetOrder(2)) // ZTG_FILIAL + ZTG_EMPFIL + ZTG_NUMDOC + ZTG_SERDOC + ZTG_CODFOR + ZTG_LOJFOR + ZTG_TIPDOC + ZTG_PRCTHO
If !Empty( cPrcTho ) // Preenchido
    DbSelectArea("ZTN")
    ZTN->(DbSetOrder(5)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_PVC201 + ...
	If ZTN->(!DbSeek( xFilial("ZTN") + "6002" + cPrcTho ))
		MsgStop("Processo Thomson nao localizado (ZTN)!" + Chr(13) + Chr(10) + ;
        "O processo deve existir nas integracoes Totvs x Thomson!" + Chr(13) + Chr(10) + ;
		"Processo: " + cPrcTho,"MT103FIM")
		lRet := .F.
	EndIf
EndIf
Return lRet

Static Function GrvPrcTh()
If Empty( cPrcTho )
	If !MsgYesNo("Deseja prosseguir sem o preenchimento?","GrvPrcTh")
        oDlgCTE:End()
		Return
	EndIf
ElseIf MsgYesNo("Confirma dados para gravacao?","GrvPrcTh")
    // Gravacao ZTG
    If ZTG->(!DbSeek( _cFilZTG + cEmpAnt + cFilAnt + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO ))
        RecLock("ZTG",.T.)
        ZTG->ZTG_FILIAL := _cFilZTG                     // Filial                   Ex: "01"
        ZTG->ZTG_EMPFIL := cEmpAnt + cFilAnt            // Empresa Filial           Ex: "1101"
        ZTG->ZTG_NUMDOC := SF1->F1_DOC                  // Numero do Documento      Ex: "000123789"
        ZTG->ZTG_SERDOC := SF1->F1_SERIE                // Serie do Documento       Ex: "001"
        ZTG->ZTG_CODFOR := SF1->F1_FORNECE              // Codigo do Fornecedor     Ex: "001020"
        ZTG->ZTG_LOJFOR := SF1->F1_LOJA                 // Loja do Fornecedor       Ex: "01"
        ZTG->ZTG_TIPDOC := SF1->F1_TIPO                 // Tipo do Documento        Ex: "N"
    Else
        RecLock("ZTG",.F.)
    EndIf
    ZTG->ZTG_PRCTHO := cPrcTho                          // Processo Thomson         Ex: "02-0002/22"
    ZTG->ZTG_PRFTIT := SF1->F1_PREFIXO                  // Prefixo dos titulos      Ex: "001"
    ZTG->ZTG_NUMTIT := SF1->F1_DUPL                     // Numero dos titulos       Ex: "000123789"
    ZTG->ZTG_DTHRLG := DtoC(Date()) + " " + Time()      // Data Hora Log
    ZTG->ZTG_USERLG := cUserName                        // Usuario Log
    ZTG->(MsUnlock())
    oDlgCTE:End()
EndIf
Return
