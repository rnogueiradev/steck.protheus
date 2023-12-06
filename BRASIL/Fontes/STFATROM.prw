#INCLUDE "PROTHEUS.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
	"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"+;
	"QPushButton:pressed {	color: #FFFFFF; "+;
	"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"

// Variavel Geral
Static NPOSSEL 		:= 01
Static NPOSDOC 		:= 02
Static NPOSSERIE  	:= 03
Static NPOSTPFRET 	:= 04
Static NPOSGUIA		:= 05
Static NPOSCLIENT	:= 06
Static NPOSLOJA		:= 07
Static NPOSNOMCLI	:= 08
Static NPOSREGIAO	:= 09
Static NPOSEMISAO	:= 10
Static NPOSVOLUME	:= 11
Static NPOSCEP		:= 12
Static NPOSPLIQ		:= 13
Static NPOSPBRU		:= 14
Static NPOSTPENT	:= 15
Static NPOSTRANSP	:= 16
Static NPOSDTATUOBS := 17
Static NPOSOBS		:= 18
Static NPOSZONA		:= 19
Static NPOSCUBA		:= 20
Static NPOSDELET	:= 21

// Variavel Notas
Static gdSelec := 01
Static gdDocum := 02
Static gdSerie := 03
Static gdVolum := 04
Static gdPesBr := 05
Static gdTpFre := 06
Static gdGuia  := 07
Static gdClie  := 08
Static gdLoja  := 09
Static gdNCli  := 10
Static gdZona  := 11
Static gdDtEmi := 12
Static gdCEPE  := 13
Static gdPesL  := 14
Static gdTipo  := 15
Static gdTran  := 16
Static gdDtAtu := 17
Static gdObser := 18


Static cRETGERVR      //   Criado para ser usado no retorno da consulta, que fará a consulta padr
Static cVarCori    := ""
Static _cUsrMot    := ""
Static _cNomMot    := ""
Static _cUsrAj1    := ""
Static _cNomAj1    := ""
Static _cUsrAj2    := ""
Static _cNomAj2    := ""
Static oFont1 	   := TFont():New("MS Sans Serif",,019,,.T.,,,,,.F.,.F.)
Static oFont2 	   := TFont():New("MS Sans Serif",,011,,.T.,,,,,.F.,.F.)
Static oFont9 	   := TFont():New("MS Sans Serif",,009,,.T.,,,,,.F.,.F.)
Static _cMsgRom    := ""
static aMsgRom     := {}
static _aMen       := {}
static _aMen1      := {}
static aRegSel     := {}

/* {Protheus.doc} Function FilTela
Description
Rotina Chamada da Tela
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 30/09/2019
@type 
*/
User Function STFATROM()
	Private nGetIDROM := 0
	// Valdemir Rabelo 09/06/2020
	Private cAjuEsp   := "C&C,VOLUME ZERO,TELHA NORTE (SAINT-GOBAIN),RETIRA,INTERNET,LEROY MERLIN,TNT,FATEC,EXPORTAÇÃO,MALOTE,TROCA NF"
	Private cVeiEsp   := "C&C,EXPORTAÇ,FATEC,LEROY,MALOTE,RETIRA,INTERNET,TELHA N,TNT,TROCA NF,VOLUME 0"
	Private cMotEsp   := "FATEC,TNT,C&C,VOLUME ZERO,TELHA NORTE (SAINT-GOBAIN),INTERNET,LEROY MERLIN,CLIENTE RETIRA,EXPORTAÇÃO,MALOTE,TROCA NF"

	DbSelectArea("ZH2")
	ZH2->(DbSetOrder(3))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	FWMsgRun(,{|| FilTela()},"Informativo","Carregando Interface, Aguarde.")

Return

/* {Protheus.doc} Function FilTela
Description
Rotina Montagem da Tela
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 30/09/2019
@type  
*/
Static Function FilTela()
	Local aSize          := MsAdvSize(, .F., 400)
	Local aInfo          :={aSize[1], aSize[2]  , aSize[3], aSize[4]-12, 1, 1}
	Local aObjects       :={{100, 100,.T.,.T. }}
	Local aPosObj        := MsObjSize( aInfo, aObjects,.T. )
	Local cPerg          := "FilTela"
	Local cTime          := Time()
	Local cHora          := SUBSTR(cTime, 1, 2)
	Local cMinutos       := SUBSTR(cTime, 4, 2)
	Local cSegundos      := SUBSTR(cTime, 7, 2)
	Local cAliasLif      := cPerg+cHora+ cMinutos+cSegundos
	Local xs
	Local ix
	Local nPos           := 0
	Local oChk1,oChk2,oChk3,oChk4
	Local lChk1          := .t.
	Local lChk2          := .t.
	Local lChk3          := .t.
	Local lChk4          := .t.
	Local lChk5          := .F.
	Local _aColsNew      := {}
	Local cAliasSuper    := 'FilTela'
	Local cQuery         := ' '
	Local cTitulo        := "Selecione os Filtros e Registros"
	Local nOpcx          := 0
	Local _nOp           := 0
	Local lGRV           := .T.
	Local cNF            := ""
	Local nQtdNF         := 0
	Local oNotas         := nil
	Local nPosPBru       := 0
	Local bImprime       :={|| LimpaCPO()                            , ImpLoteR()}
	Local aButtons       := {}
	Local cPorc          := Alltrim(Str(SuperGetMV("ST_PERCUB",.F.,20)))
	Local aCampos        := {}
	Local aCPOCHV        := {}
	Local aCpoRom        := {}
	Local aRomCHV        := {}
	Local oBtnPesR
	Local oBtnPesN
	Local bSavKeyF12     := SetKey(VK_F12, NIL)

//	Private oDlg
	Private oLbx,oLbx2,oLbx3,oLbx4,oLbx5
	Private aCoordenadas := MsAdvSize(.T.)
	Private oWinSup01    := Nil
	Private oWinSup02    := Nil
	Private oWinSup03    := Nil
	Private oWinSup04    := Nil
	Private oWinInf01    := Nil
	Private oWinInf02    := Nil
	Private oWinInf03    := Nil
	Private oWinInf04    := Nil
	Private oWinCnt01    := Nil
	Private oWinCnt02    := Nil
	Private oWnFull      := Nil
	Private oWnInfFl     := Nil
	Private oWnInfF2     := Nil
	Private oWnInfF3     := Nil
	Private oWnInfF4     := Nil
	Private oWnInfFull   := Nil
	Private oGetD        := Nil
	Private oVeiGet
	Private aDadosGer    := {}
	Private aCols        := {}
	Private aHeadR       := {}
	Private oQtdCub
	Private oQtdNFS
	Private nQtdNFS      := 0
	Private nQtdCub      := 0
	Private lPisca       := .F.
	Private lPiscaB      := .F.
	Private lPisRod      := .F.
	Private oQtdVols
	Private nQtdVols     := 0
	Private oPBrutoE
	Private nPBrutoE     := 0
	Private oQtdNFRO
	Private nQtdNFRO     := 0
	Private nCubPer      := 0
	Private nPLiquido    := 0
	Private oPesoBrt     := nil
	Private oCubage      := nil
	Private oOk          := LoadBitmap( GetResources(), "LBOK" )
	Private oNo          := LoadBitmap( GetResources(), "LBNO" )
	Private oChk5        := nil
	Private lSel         := .T.
	Private cVeiculo     := Space(TamSX3("DA3_COD")[1])
	Private cDescVei     := Space(90)
	Private nCubVei      := 0
	Private nPesVei      := 0
	Private nCubagem     := 0
	Private cRomaneio    := ""
	Private cMotorista   := ""
	Private cEmissao     := ""
	Private cDtEnt       := ""
	Private cAjudant     := ''
	Private nQtdVol      := 0
	Private nPesLiq      := 0
	Private nPesBrt      := 0
	Private oRodizio
	Private cMsgRodiz    := ""
	Private aVetor5      :={{.F., '' , '' , '' , '' , '' , '' ,0,0,0}}
	Private aPrepRot     := {}
	Private aVetor1      := {}
	Private aVetor2      := {}
	Private aVetor3      := {}
	Private aVetor4      := {}
	Private oBtnPlan
	Static oDlg

	SetKey(VK_F12, {|| LimpDados() })

	aHeadR := CrgaHeadR()

	// Carregando Registros
	GetDadosIt()
	AtuaList(@aVetor1,@aVetor2,@aVetor3,@aVetor4)

	_nTr:= 40

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aCoordenadas[7],000 To aCoordenadas[6],aCoordenadas[5] COLORS 0,16772829 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

	MntTela(oDlg)

	// Quadro de Zona
	oPnlZona := TPanel():New( 0, 0, ,oWinSup01, , , , ,CLR_WHITE , 0, 0, .F.,.F. )
	oPnlZona:Align := CONTROL_ALIGN_ALLCLIENT

	@ 02,02 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oPnlZona on CLICK(aEval(aVetor1,{|x| x[1]:=lChk1, lChk2 := lChk1, lChk3 := lChk1, oChk2:Refresh(), oChk3:Refresh()  }), VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4), oLbx:Refresh())
	@ 10,02 LISTBOX oLbx FIELDS HEADER ;
		' ','Zona','Qtd.NF','Peso Bruto'  ;
		SIZE oPnlZona:nClientWidth/2,(oPnlZona:nClientHeight/2)-10 OF oPnlZona PIXEL ON dblClick(aVetor1[oLbx:nAt,1] := !aVetor1[oLbx:nAt,1], SelSelecao(aVetor1,aVetor2,aVetor3), VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.T.))
	oLbx:SetArray( aVetor1 )
	oLbx:bLine := {|| {Iif(	aVetor1[oLbx:nAt,1],oOk,oNo),;
		aVetor1[oLbx:nAt,2],;
		aVetor1[oLbx:nAt,3],;
		aVetor1[oLbx:nAt,4];
		}}

	// Quadro de CEP
	oPnlCEP := TPanel():New( 0, 0, ,oWinSup02, , , , ,CLR_WHITE , 0, 0, .F.,.F. )
	oPnlCEP:Align := CONTROL_ALIGN_ALLCLIENT

	@ 02,02 CHECKBOX oChk2 VAR lChk2 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oPnlCEP on CLICK(aEval(aVetor2,{|x| x[1]:=lChk2}), VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.T.) ,oLbx2:Refresh())
	@ 10,02 LISTBOX oLbx2 FIELDS HEADER ;
		' ','Cep   ','Qtd.NF','Peso Bruto'  ;
		SIZE oPnlCEP:nClientWidth/2,(oPnlCEP:nClientHeight/2)-10 OF oPnlCEP PIXEL ON dblClick(aVetor2[oLbx2:nAt,1] := !aVetor2[oLbx2:nAt,1], VldCEP(),VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.T.))
	oLbx2:SetArray( aVetor2 )
	oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
		aVetor2[oLbx2:nAt,2],;
		aVetor2[oLbx2:nAt,3],;
		aVetor2[oLbx2:nAt,4];
		}}

	// Quadro de Transportadora
	oPnlTRAN := TPanel():New( 0, 0, ,oWinSup03, , , , ,CLR_WHITE , 0, 0, .F.,.F. )
	oPnlTRAN:Align := CONTROL_ALIGN_ALLCLIENT

	@ 02,02 CHECKBOX oChk3 VAR lChk3 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oPnlTRAN on CLICK(aEval(aVetor3,{|x| x[1]:=lChk3}),  VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.T.) ,oLbx3:Refresh())
	@ 10,02 LISTBOX oLbx3 FIELDS HEADER ;
		' ','Transportadora','Qtd.NF','Peso Bruto'  ;
		SIZE oPnlTRAN:nClientWidth/2,(oPnlTRAN:nClientHeight/2)-10 OF oPnlTRAN PIXEL ON dblClick(aVetor3[oLbx3:nAt,1] := !aVetor3[oLbx3:nAt,1], VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.T.))
	oLbx3:SetArray( aVetor3 )
	oLbx3:bLine := {|| {Iif(	aVetor3[oLbx3:nAt,1],oOk,oNo),;
		aVetor3[oLbx3:nAt,2],;
		aVetor3[oLbx3:nAt,3],;
		aVetor3[oLbx3:nAt,4];
		}}

	// Quadro de TIPO
	oPnlTIPO := TPanel():New( 0, 0, ,oWinSup04, , , , ,CLR_WHITE , 0, 0, .F.,.F. )
	oPnlTIPO:Align := CONTROL_ALIGN_ALLCLIENT

	@ 02,02 CHECKBOX oChk4 VAR lChk4 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oPnlTIPO on CLICK(aEval(aVetor4,{|x| x[1]:=lChk4}), VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4) ,oLbx4:Refresh())
	@ 10,02 LISTBOX oLbx4 FIELDS HEADER ;
		' ','Tipo' ;
		SIZE oPnlTIPO:nClientWidth/2,(oPnlTIPO:nClientHeight/2)-10 OF oPnlTIPO PIXEL ON dblClick(aVetor4[oLbx4:nAt,1] := !aVetor4[oLbx4:nAt,1], VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4))
	oLbx4:SetArray( aVetor4 )
	oLbx4:bLine := {|| {Iif(	aVetor4[oLbx4:nAt,1],oOk,oNo),;
		aVetor4[oLbx4:nAt,2];
		}}

	// Carrega Browse
	oNotas := MntNotas()

	// Valdemir Rabelo 24/01/2020
	// Arrays para botão de pesquisa de Nota a romanear
	aCampos := { ;
		{"Nota Fiscal",	NPOSDOC,   "C",09,"@!"},;
		{"Nome Cliente",NPOSNOMCLI,"C",30,"@!"},;
		{"Dt Emissao",	NPOSEMISAO,"D",08,"@D 99/99/9999"},;
		{"Tipo Frete",	NPOSTPFRET,"C",03,"@!"};
		}
	aCPOCHV := {{"Nota Fiscal",NPOSDOC,    "C",09,"@!"}}

	// Arrays para botão de pesquisa de Notas romaneadas
	aCpoRom := { ;
		{"Nota Fiscal",  2,  "C",09,"@!"},;
		{"Nome Cliente", 6,	"C",30,"@!"},;
		{"Região",		7,	"C",08,"@!"};
		}
	aRomCHV := {{"Nota Fiscal", 2,  "C",09,"@!"}}

	// Quadro Selecao
	oPanel := TPanel():New( 0, 0, ,oWinCnt01, , , , ,CLR_WHITE , 10, 10, .F.,.F. )
	oPanel:Align := CONTROL_ALIGN_TOP
	nConta := 0
	@ 000,002 CHECKBOX oChk5 VAR lSel PROMPT "Marca/Desmarca" SIZE 60,8 PIXEL OF oPanel ON CHANGE( (aEVal(aCols, {|X| X[1] := lSel, oGetD:Refresh() }),InfoNFS(oGetD, .T.) ) )

	oBtnPlan  := TButton():New( 000, (oPanel:nClientWidth/2)-167, "Planilha"	, oPanel,{ || FWMsgRun(, {|| PostExcel(aCols)},"Processando","Gerando Planilha, Aguarde")  },40,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnPlan:SetCSS(CSSBOTAO)
	oBtnPlan:cToolTip:= "Gerar Planilha"

	oBtnPesN  := TButton():New( 000, (oPanel:nClientWidth/2)-125, "Pesquisar"	, oPanel,{ || u_STPesqGD(oNotas, aCols, aCampos,aCPOCHV)  },40,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnPesN:SetCSS(CSSBOTAO)
	oBtnPesN:cToolTip:= "Pesquisar"

	oBtnObsL  := TButton():New( 000, (oPanel:nClientWidth/2)-83, "Obs Lote"	, oPanel,{ || InsObs( )  },40,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnObsL:SetCSS(CSSBOTAO)
	oBtnObsL:cToolTip:= "Observação em Lote"

	oBtnObsI  := TButton():New( 000, (oPanel:nClientWidth/2)-41,  "Obs Ind."	, oPanel,{ || InsObsI(aCols[oGetD:nAt][NPOSDOC],aCols[oGetD:nAt][NPOSSERIE], oNotas ) },40,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnObsI:SetCSS(CSSBOTAO)
	oBtnObsI:cToolTip:= "Observação Individual"

	// Total de Notas - Lado Esquerdo
	@ 003,010 SAY oQtdCub    PROMPT Transform(nQtdCub,  "@E 999,999,999.999")	SIZE 60,07 OF oWinInf01 FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oQtdVols   PROMPT TransForm(nQtdVols, "@E 999,999.999") 		SIZE 60,07 OF oWinInf02 FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oQtdNFS    PROMPT TransForm(nQtdNFS,  "@E 99999999999")   	SIZE 110,8 OF oWinInf03 FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oPBrutoE   PROMPT Transform(nPBrutoE,  "@E 999,999,999.999")   SIZE 110,8 OF oWinInf04 FONT oFont1 COLORS 16711680, 16777215 PIXEL

	// Carrega Dados de Seleção
	oGroup := tGroup():New(05,05,040,(oWnFull:nClientWidth/2)-10,'[ DADOS VEÍCULO ]',oWnFull,CLR_BLUE,,.T.)
	@ 016,012 SAY oVeiculo PROMPT "Veículo"   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 016,110 SAY oDesVeic PROMPT "Desc.Veiculo" SIZE 50,08 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 016,320 SAY oCubag   PROMPT "Cubagem" 	 SIZE 040,08 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 016,395 SAY oCubag   PROMPT cPorc+" % " 	 SIZE 020,08 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 031,320 SAY oPBrutoC PROMPT "P.Bruto" 	 SIZE 060,08 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL

	@ 030,012 SAY oRodizio PROMPT cMsgRodiz   	 SIZE 150,8 OF oWnFull FONT oFont2 COLORS CLR_RED, 16777215 PIXEL

	@ 013, 053 MSGET oVeiGet VAR cVeiculo PICTURE "@!" SIZE 030, 010 F3 "DA305" VALID {|| vldVei02(cVeiculo),AtuLbx5(oLbx5),oLbx5:Refresh(),oLbx5:SetFocus() } WHEN .T. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 013, 160 MSGET cDescVei PICTURE "@!" SIZE 140, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 013, 350 MSGET nCubVei  PICTURE "@E 999.999" SIZE  30, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 013, 413 MSGET nCubPer  PICTURE "@E 999.999" SIZE  30, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 028, 350 MSGET nPesVei  PICTURE "@E 999,999,999.999" SIZE  50, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL				// Valdemir Rabelo 06/02/2020

	oGropROM := tGroup():New(42,05,090,(oWnFull:nClientWidth/2)-10,'[ DADOS ROMANEIO ]',oWnFull,CLR_BLUE,,.T.)
	@ 059,012 SAY oRomaneio PROMPT "Romaneio"   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 059,110 SAY oEmissao  PROMPT "Motorista"	   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 059,320 SAY oEmissao  PROMPT "Emissão"	   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL

	@ 056, 053 MSGET cRomaneio  PICTURE "@!" SIZE 040, 010  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 056, 160 MSGET cMotorista PICTURE "@!" SIZE 140, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 056, 350 MSGET cEmissao   PICTURE "@D 99/99/9999"  SIZE 060, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL

	@ 073,110 SAY oAjuda  PROMPT "Ajudante"	   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 073,320 SAY oDtEnt  PROMPT "Entrega"	   	 SIZE 040,8 OF oWnFull FONT oFont2 COLORS CLR_RED, 16777215 PIXEL

	@ 070,160 MSGET cAjudant PICTURE "@!" SIZE 140, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL
	@ 070,350 MSGET cDtEnt   PICTURE "@D 99/99/9999"  SIZE 060, 008  WHEN .F. OF oWnFull COLORS 0, 16777215 PIXEL

	// Valdemir Rabelo 10/06/2020
	oBtnRom  := TButton():New( 075, 012, "&Procura", oWnFull, { || FiltraBD(oLbx5)  },39,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnRom:SetCSS(CSSBOTAO)
	oBtnRom:cToolTip := "Procura Romaneio"

	oBtnObsR  := TButton():New( 075, 052, "Observ", oWnFull, { || STObsRom(cRomaneio)  },39,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnObsR:SetCSS(CSSBOTAO)
	oBtnObsR:cToolTip := "Observação do Romaneio"

	oBtnPesR  := TButton():New( 090, (oPanel:nClientWidth/2)-100, "Pesquisar"		, oWnFull,{ || u_STPesqGD(oLbx5, aVetor5, aCpoRom, aRomCHV)  },60,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnPesR:SetCSS(CSSBOTAO)
	oBtnPesR:cToolTip:= "Pesquisar"
	oVeiGet:cToolTip := "F12 - Limpar Campos"

	@ 092,05 CHECKBOX oChk6 VAR lChk5 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oWnFull on CLICK(aEval(aVetor5,{|x| x[1]:=lChk5}) ,oLbx5:Refresh())
	oBtnRot  := TButton():New( 090, (oWnFull:nClientWidth/2)-73, "Roteirizar"		, oWnFull,{ || Processa( {|| PrepRote()},"Aguarde") , oLbx5:Refresh() },60,009,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnRot:SetCSS(CSSBOTAO)
	oBtnRot:cToolTip:= "Roteiriza de acordo com CEP"

	@ 100,05 LISTBOX oLbx5 FIELDS HEADER ;
		' ', 'Nota Fiscal', 'Serie', 'Cliente', 'Loja', 'Nome Cliente','Região', 'Qtd.Vol', 'Peso Liq', 'Peso Bruto'  ;
		SIZE (oWnFull:nClientWidth/2)-10,(oWnFull:nClientHeight/2)-100 OF oWnFull PIXEL ON dblClick(aVetor5[oLbx5:nAt,1] := !aVetor5[oLbx5:nAt,1], AtuTotais())      // VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4)
	AtuLbx5(oLbx5)

	// Total de Notas - Lado Direito
	@ 003,010 SAY oCubage   PROMPT Transform(nCubagem, "@E 999,999,999.999")	SIZE 060,8 OF oWnInfFl FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oQtdVol   PROMPT Transform(nQtdVol,  "@E 999,999.999")	 	SIZE 060,8 OF oWnInfF2 FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oQtdNFRO  PROMPT Transform(nQtdNFRO, "@E 999999999999")	 	SIZE 060,8 OF oWnInfF3 FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 003,010 SAY oPesoBrt  PROMPT Transform(nPesBrt,  "@E 999,999,999.999")  	SIZE 060,8 OF oWnInfF4 FONT oFont1 COLORS 16711680, 16777215 PIXEL

	oBtnAdd  := TButton():New( 010, 002, ">>"		, oWinCnt02,{||  AddReg(oNotas, aCols, oLbx5, aVetor1), AtuTotais(), oLbx5:Refresh() },20,070,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnRem  := TButton():New( 090, 002, "<<"		, oWinCnt02,{||  RemReg(oNotas, aCols, oLbx5), AtuaList(@aVetor1,@aVetor2,@aVetor3,@aVetor4),VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4,.t.), AtuLbx5(oLbx5),	AtuaBrow(), AtuTotais(), oLbx5:Refresh() },20,070,,oFont1,.F.,.T.,.F.,,.F.,,,.F. )
	oBtnAdd:SetCSS(CSSBOTAO)
	oBtnAdd:cToolTip:= "Adiciona registro marcado"
	oBtnRem:SetCSS(CSSBOTAO)
	oBtnRem:cToolTip:= "Remove registro marcado"

	oLbx:SetFocus()
	oLbx:Refresh()
	oLbx2:Refresh()
	oLbx3:Refresh()
	oLbx4:Refresh()
	oLbx5:Refresh()
	oDlg:Refresh()

	Define Timer oTimer Interval 1 Action ( TimeBlink() ) Of GetWndDefault()
	oTimer:Activate()

	Aadd( aButtons, {"HISTORIC", bImprime, "Gerencia Impressão"} )

	Aadd( aButtons, {"HISTORIC", {|| U_STFATRO1() } , "Encerramento"} )
	//Aadd( aButtons, {"HISTORIC", {|| STFATEO1()   } , "Estorno Encer."} )     // Valdemir Rabelo 23/03/2020 - Ticket:
	Aadd( aButtons, {"HISTORIC", {|| U_STFATRO2() } , "Fechamento"} )
	Aadd( aButtons, {"HISTORIC", {|| DELNFROM()   } , "Estorna conferência"} )
	Aadd( aButtons, {"HISTORIC", {|| AtuDados()   } , "Atualiza Dados"} )

	VLDFil(@aVetor1,@aVetor2,@aVetor3,@aVetor4, .T.)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||  },{|| SetKey(VK_F12, bSavKeyF12), oDlg:End()},,@aButtons,,,.F.,.F.,.F.,.F.,.F.)

Return


/* {Protheus.doc} Function MnTela
Description
Rotina Montar tela com separação
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 30/09/2019
@type 
*/
Static Function MntTela(oDlg)
	Local oFWLMain := Nil
	Local oFWLMnD  := Nil
	Local oFWLMnS  := Nil

	oFWLMain := FWLayer():New()
	oPanelD := TPanel():New( 0, 0, ,oDlg, , , , ,CLR_WHITE , oDlg:nWidth/4, 0, .F.,.F. )
	oPanelD:Align := CONTROL_ALIGN_RIGHT

	oFWLMain:Init( oDlg, .F. )

	// Linhas existente na tela
	oFWLMain:AddLine("LineSup" ,040,.T.)
	oFWLMain:AddLine("LineIte" ,040,.T.)
	oFWLMain:AddLine("LineInf" ,020,.T.)
	// Colunas Superiores
	oFWLMain:AddCollumn( "ColSup01", 025, .T.,"LineSup" )
	oFWLMain:AddCollumn( "ColSup02", 025, .T.,"LineSup" )
	oFWLMain:AddCollumn( "ColSup03", 030, .T.,"LineSup" )
	oFWLMain:AddCollumn( "ColSup04", 020, .T.,"LineSup" )
	// Colunas Central
	oFWLMain:AddCollumn( "ColIte01", 093, .T.,"LineIte" )
	oFWLMain:AddCollumn( "ColIte02", 007, .T.,"LineIte" )
	// Colunas Inferiores
	oFWLMain:AddCollumn( "ColInf01", 025, .T.,"LineInf" )
	oFWLMain:AddCollumn( "ColInf02", 025, .T.,"LineInf" )
	oFWLMain:AddCollumn( "ColInf03", 025, .T.,"LineInf" )
	oFWLMain:AddCollumn( "ColInf04", 025, .T.,"LineInf" )

	// Janelas Superiores
	oFWLMain:AddWindow( "ColSup01", "WinSup01", "Zona",             100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColSup02", "WinSup02", "Cep",              100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColSup03", "WinSup03", "Transportadora",   100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColSup04", "WinSup04", "Tipo",  		    100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)

	// Janelas Central
	oFWLMain:AddWindow( "ColIte01", "WinIte01", "Notas",             100, .T., .F.,/*bAction*/,"LineIte",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColIte02", "WinIte02", "Ação",              100, .F., .F.,/*bAction*/,"LineIte",/*bGotFocus*/)

	// Janelas Inferiores
	oFWLMain:AddWindow( "ColInf01", "WinInf01", "Cubagem",             056, .T., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColInf02", "WinInf02", "Qtde.Volumes",        056, .T., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColInf03", "WinInf03", "Qtde.Notas",          056, .T., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColInf04", "WinInf04", "Peso Bruto",          056, .T., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)

	// Gerando Objeto Superior
	oWinSup01 := oFWLMain:GetWinPanel('ColSup01','WinSup01',"LineSup" )
	oWinSup02 := oFWLMain:GetWinPanel('ColSup02','WinSup02',"LineSup" )
	oWinSup03 := oFWLMain:GetWinPanel('ColSup03','WinSup03',"LineSup" )
	oWinSup04 := oFWLMain:GetWinPanel('ColSup04','WinSup04',"LineSup" )
	// Gerando Objeto Central
	oWinCnt01 := oFWLMain:GetWinPanel('ColIte01','WinIte01',"LineIte" )
	oWinCnt02 := oFWLMain:GetWinPanel('ColIte02','WinIte02',"LineIte" )

	// Gerando Objeto Inferior
	oWinInf01 := oFWLMain:GetWinPanel('ColInf01','WinInf01',"LineInf" )
	oWinInf02 := oFWLMain:GetWinPanel('ColInf02','WinInf02',"LineInf" )
	oWinInf03 := oFWLMain:GetWinPanel('ColInf03','WinInf03',"LineInf" )
	oWinInf04 := oFWLMain:GetWinPanel('ColInf04','WinInf04',"LineInf" )

	// LayOut da Direita
	oFWLMnW := FWLayer():New()
	oFWLMnW:Init( oPanelD, .F. )
	oFWLMnW:AddLine("LineFull"  ,080,.T.)
	oFWLMnW:AddLine("LnTotF01"  ,020,.T.)

	oFWLMnW:AddCollumn( "ColFull", 		100, .T.,"LineFull" )
	oFWLMnW:AddWindow( "ColFull", 	"WnFull", "Tela de Seleção ( F12 - Limpa Tela )", 100, .F., .F.,/*bAction*/,"LineFull",/*bGotFocus*/)

	oFWLMnW:AddCollumn( "ColInf01", 	025, .T.,"LnTotF01" )
	oFWLMnW:AddCollumn( "ColInf02", 	025, .T.,"LnTotF01" )
	oFWLMnW:AddCollumn( "ColInf03", 	025, .T.,"LnTotF01" )
	oFWLMnW:AddCollumn( "ColInf04", 	025, .T.,"LnTotF01" )

	oFWLMnW:AddWindow( "ColInf01", 	"WnInfFl", "Cubagem", 		056, .F., .F.,/*bAction*/,"LnTotF01",/*bGotFocus*/)
	oFWLMnW:AddWindow( "ColInf02", 	"WnInfF2", "Qtde.Volumes", 	056, .F., .F.,/*bAction*/,"LnTotF01",/*bGotFocus*/)
	oFWLMnW:AddWindow( "ColInf03", 	"WnInfF3", "Qtde.Notas", 	056, .F., .F.,/*bAction*/,"LnTotF01",/*bGotFocus*/)
	oFWLMnW:AddWindow( "ColInf04", 	"WnInfF4", "Peso Bruto", 	056, .F., .F.,/*bAction*/,"LnTotF01",/*bGotFocus*/)

	// Gerando Objeto Superior
	oWnFull  := oFWLMnW:GetWinPanel('ColFull','WnFull',"LineFull" )

	oWnInfFl := oFWLMnW:GetWinPanel('ColInf01','WnInfFl',"LnTotF01" )
	oWnInfF2 := oFWLMnW:GetWinPanel('ColInf02','WnInfF2',"LnTotF01" )
	oWnInfF3 := oFWLMnW:GetWinPanel('ColInf03','WnInfF3',"LnTotF01" )
	oWnInfF4 := oFWLMnW:GetWinPanel('ColInf04','WnInfF4',"LnTotF01" )

Return

/* {Protheus.doc} Function MntNotas
Description
Rotina Montar NewGetDados de Notas
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 01/10/2019
@type 
*/
Static Function MntNotas()
	Local aTam := {5,30,20,30,30,20,20,30,20,150,30,38,40,40,40,120,20,400}
	aHeadR   := {}

	aHeadR   := CrgaHeadR()

	if Len(aCols)==0
		aCols := {Array(17)}
		aCols[1,1] := .F.
	endif

	oGetD    := TWBrowse():New( 0 , 0, 0, 0,,;   //350
	aHeadR, aTam, oWinCnt01, ,,,,;
		{||},,,,,,,.F.,,.T.,,.F.,,, )

	oGetD:Align := CONTROL_ALIGN_ALLCLIENT
	oGetD:SetArray(aCols)
	oGetD:bLine := {||{;
		If( aCols[oGetD:nAt,01],oOK,oNO),;
			aCols[oGetD:nAt,02],;
			aCols[oGetD:nAt,03],;
			aCols[oGetD:nAt,04],;
			aCols[oGetD:nAt,05],;
			aCols[oGetD:nAt,06],;
			aCols[oGetD:nAt,07],;
			aCols[oGetD:nAt,08],;
			aCols[oGetD:nAt,09],;
			aCols[oGetD:nAt,10],;
			aCols[oGetD:nAt,11],;
			aCols[oGetD:nAt,12],;
			aCols[oGetD:nAt,13],;
			aCols[oGetD:nAt,14],;
			aCols[oGetD:nAt,15],;
			aCols[oGetD:nAt,16],;
			aCols[oGetD:nAt,17],;
			aCols[oGetD:nAt,18] } }

		InfoNFS(oGetD,.f.)

		oGetD:bLDblClick := {|| (aCols[oGetD:nAt,1] := !aCols[oGetD:nAt,1],;
			oGetD:DrawSelect(),;
			oGetD:Refresh(),MsgCliente(),InfoNFS(oGetD,.t.))}

		Return oGetD

/* {Protheus.doc} Function GetDadosIt
Description
Rotina Montar Array Generico
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 01/10/2019
@type 
*/
Static Function GetDadosIt()
	Local cRegiaoDe   	:= '     '
	Local cRegiaoAte  	:= 'ZZ'
	Local cNFSDe      	:= ' '
	Local cNFSAte     	:= 'ZZ'
	Local cSerieDe    	:= ' '
	Local cSerieAte   	:= 'ZZ'
	Local cClienteDe  	:= ' '
	Local cClienteAte 	:= 'ZZ'
	Local cLojaDe     	:= ' '
	Local cLojaAte    	:= 'ZZ'
	Local dEmissaoDe  	:= Stod('20170101')
	Local dEmissaoAte 	:= Stod('20300101')
	Local cTransp     	:= ' '
	Local cTranAte	  	:= 'ZZ'
	Local cTpFrete		:= '4'

	aDadosGer := {}
	cNomeTransp := SA4->A4_NOME

	Processa( { || aDadosGer := STFSF60GX(cNFSDe,cNFSAte,cSerieDe,cSerieAte,cClienteDe,cClienteAte,;
		cLojaDe,cLojaAte,dEmissaoDe,dEmissaoAte,cTransp,cTranAte,;
		cRegiaoDe,cRegiaoAte,cTpFrete) },'Aguarde','Preparando Registros...', )

	If Empty(aDadosGer)
		FWMsgRun(,{|| sleep(3000)},"Informativo","Não existem notas conforme parâmetro informado!!!")
		Return
	Endif

	aSort(aDadosGer,,,{|x,y| x[NPOSREGIAO]+x[NPOSCEP] < y[NPOSREGIAO]+y[NPOSCEP] })

Return

/* {Protheus.doc} Function VLDFil
Description
Rotina de validação dos filtros
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 01/10/2019
@type 
*/
Static Function VLDFil(aVetor1,aVetor2,aVetor3,aVetor4,lPrim)
	Local _aColsOld := aClone(aDadosGer)
	Local _aColsNew := {}
	Local nTodosM   := 0
	Local ix        := 0
	Default lPrim   := .F.

	IF !lPrim
		// Seleciona registros com base na zona
		SelSelecao(aVetor1,@aVetor2,@aVetor3)
	Endif
	aRegSel := aClone(aVetor1)

	_aColsNew := GetDbCols(_aColsOld)

	if Len(_aColsNew) > 0
		aCols := _aColsNew
	else
		aCols := {Array(18)}
		aCols[1,1] := .F.
		oGetD:aArray := {}
	Endif

	AtuaBrow()
	lSel := (Len(aCols) > 1)
	InfoNFS(oGetD, .T.)
	oGetD:Refresh()
Return


Static Function GetDbCols(_aColsOld, plRemove)
	Local ix 		:= 0
	Local nPos1 	:= 0
	Local nPos2 	:= 0
	Local nPos3 	:= 0
	Local nPos4 	:= 0
	Local nPos5 	:= 0
	Local aRET      := {}
	Local lOpc      := .T.
	DEFAULT plRemove:= .F.

	For ix=1 To Len(_aColsOld)

		nPos1 := aScan(aVetor1, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[ix,9]) })					//zona - NPOSZONA
		nPos2 := aScan(aVetor2, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[ix,NPOSCEP])  })			//cep
		nPos3 := aScan(aVetor3, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[ix,NPOSTRANSP]) })			//transportadora
		nPos4 := aScan(aVetor4, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[ix,NPOSTPFRET]) })			//tipo cif fob
		nPos5 := aScan(aVetor1, {|x| Alltrim(x[2]) == upper(ALLTRIM(_aColsOld[ix,NPOSREGIAO]))})	//guia

		If  ( (nPos1 <> 0 .And. aVetor1[nPos1,1])   .And. ;    // .Or.  (nPos1x <> 0 .And. aVetor1[nPos1x,1] ) Renato informou que não existe essa situação
			(nPos2 <> 0 .And. aVetor2[nPos2,1])   .And. ;
				(nPos3 <> 0 .And. aVetor3[nPos3,1])   .And. ;
				(nPos4 <> 0 .And. aVetor4[nPos4,1])   .And. ;
				(upper((ALLTRIM(_aColsOld[ix,NPOSREGIAO]))) != "PENDENTE"); //.And.;
			  /*(aScan(aVetor5, {|X| X[2] == _aColsOld[ix,02]})=0)*/ ) .or.;
				( (nPos5 <> 0) .And. (aVetor1[nPos5,1] .And. (Upper(aVetor1[nPos5,2])=="PENDENTE")) .And.;
				( (upper(ALLTRIM(_aColsOld[ix,NPOSREGIAO])) == "PENDENTE") ) ) .or. ;
				(plRemove )

			lOpc      := (upper((ALLTRIM(_aColsOld[ix,NPOSREGIAO]))) != "PENDENTE")
			if plRemove
				Aadd(aRET,{;
					lOpc,;
					_aColsOld[ix,gdDocum],;
					_aColsOld[ix,gdSerie],;
					_aColsOld[ix,gdVolum],;
					_aColsOld[ix,gdPesBr],;
					_aColsOld[ix,gdTpFre],;
					_aColsOld[ix,gdGuia],;
					_aColsOld[ix,gdClie],;
					_aColsOld[ix,gdLoja],;
					alltrim(_aColsOld[ix,gdNCli]),;
					_aColsOld[ix,gdZona],;
					_aColsOld[ix,gdDtEmi],;
					_aColsOld[ix,gdCEPE],;
					_aColsOld[ix,gdPesL],;
					_aColsOld[ix,gdDtAtu],;
					_aColsOld[ix,gdTran],;
					_aColsOld[ix,gdDtAtu],;
					_aColsOld[ix,gdDtAtu],;
					_aColsOld[ix,gdZona],;
					0;
					})
			else
				Aadd(aRET,{;
					lOpc,;
					_aColsOld[ix,NPOSDOC],;
					_aColsOld[ix,NPOSSERIE],;
					_aColsOld[ix,NPOSVOLUME],;
					_aColsOld[ix,NPOSPBRU],;
					_aColsOld[ix,NPOSTPFRET],;
					_aColsOld[ix,NPOSGUIA],;
					_aColsOld[ix,NPOSCLIENT],;
					_aColsOld[ix,NPOSLOJA],;
					alltrim(_aColsOld[ix,NPOSNOMCLI]),;
					_aColsOld[ix,NPOSREGIAO],;
					_aColsOld[ix,NPOSEMISAO],;
					_aColsOld[ix,NPOSCEP],;
					_aColsOld[ix,NPOSPLIQ],;
					_aColsOld[ix,NPOSTPENT],;
					_aColsOld[ix,NPOSTRANSP],;
					_aColsOld[ix,NPOSDTATUOBS],;
					_aColsOld[ix,NPOSOBS],;
					_aColsOld[ix,NPOSZONA],;
					_aColsOld[ix,NPOSCUBA];
					})
			endif

		EndIf

	Next ix

Return aRET


Static Function VldCEP()
	Local _aColsOld := aClone(aDadosGer)
	Local xs        := 0
	aVetor3         := {}

	For xs := 1 to Len(aVetor1)
		if aVetor1[xs, 1]
			_GetTRA(aVetor1[xs], aVetor2, aVetor3,_aColsOld)
		endif
	Next
	AtuaLbx()

Return

Static Function InfoNFS(oGetD, lAtuTela)

	Local nNotas   := 0
	Local nVols    := 0
	Local nPesoL   := 0
	Local nPesoB   := 0
	Local nQtdReg  := 0
	Local nX
	Local nY
	Local _cMen1	:= ""
	Local _cMen		:= ""
	Local nTMP

	_aMen1	 := {}
	nCubagem := 0
	aMsgRom  := {}
	nQtdCub  := 0
	nQtdNFS  := 0
	nVols    := 0

	// Calcula totais lado esquerdo
	aEval(aCols, {|X| if(X[1], nQtdNFS += 1,  0)})
	if ValType(aCols[1][5])=="C"
		aEval(aCols, {|X| if(X[1], nVols   += X[NPOSVOLUME], 0)})
		aEval(aCols, {|X| if(X[1], nPesoL  += X[NPOSPLIQ],  0)})
		aEval(aCols, {|X| if(X[1], nPesoB  += X[NPOSPBRU], 0)})
	else
		aEval(aCols, {|X| if(X[1], nVols   += X[gdVolum], 0)})
		aEval(aCols, {|X| if(X[1], nPesoL  += X[gdPesL],  0)})
		aEval(aCols, {|X| if(X[1], nPesoB  += X[gdPesBr], 0)})
	endif

	nQtdVols  := nVols
	nPBrutoE   := ROUND(nPesoB,3)
	nPLiquido := nPesoL

	aEval(aCols, {|X| if(X[1], nQtdCub += GetRetF2(X[gdDocum],X[gdSerie],X[gdClie],X[gdLoja],"F2_XCUBAGE") , 0)})

	nCubagem:= 0
	nPesBrt := 0
	nQtdVol := 0
	nQtdNFRO:= 0
	aEval(aVetor5, {|X| if(!Empty(X[2]), nQtdReg++,0) })
	if nQtdReg > 0
		// Calcula totais lado direito
		aEval(aVetor5, { |X| if(!Empty(X[2]), nNotas++, 0) })
		aEval(aVetor5, { |X| nQtdVol += X[8] })
		aEval(aVetor5, { |X| nPesBrt += X[10] })
		aEval(aVetor5, { |X| if(nNotas > 0, nCubagem += GetRetF2(X[2],X[3],X[4],X[5],"F2_XCUBAGE"), 0) })

		// Soma os lados
		nCubagem  += nQtdCub
		nQtdNFRO  := nQtdNFS+nNotas
		nQtdVol   += nVols
		nPesBrt	  += ROUND(nPesoB,3)
	Endif

	If lAtuTela
		oQtdCub:Refresh()
		oQtdVols:Refresh()
		oQtdNFS:Refresh()
		oPBrutoE:Refresh()
		oChk5:Refresh()

		//oCubage:Refresh()
		oQtdNFRO:Refresh()
		// Lado Direito
		oCubage:Refresh()
		oQtdVol:Refresh()
		oQtdNFRO:Refresh()
		oPesoBrt:Refresh()

		GETDREFRESH()

		if (ValType(oDlg) == "O")
			oDlg:Refresh()
		endif
	Endif

	if Len(aMsgRom) > 0
		AvisoRom()
	Endif

Return

Static Function GetMens(paCols)
	Local _aMen	    := {}
	Local _aMen1	:= {}
	Local _cMen1	:= ""
	Local _cMen		:= ""
	Local nY
	Local _lRET     := .T.
	Local _cPedito  := ""
	Local aAreaZ44  := GetArea()

	If __cuserid = '001012'

		If (paCols[nX,NPOSTPENT] $ 'R') .AND. !(SubString(paCols[NPOSZONA],1,3) $ cVeiEsp)    //'TNT'  - Valdemir Rabelo 09/06/2020			// <> '000163' .AND. SF2TMP->TPENT   == 'R'
			aAdd(aMsgRom, "RETIRA -  BLOQUEADO PARA GERAR ROMANEIO")
			paCols[1] := .F.
			_lRET     := .F.
		EndIf

	EndIf

	if !STVLDROM(paCols[NPOSDOC],'001',paCols[gdClie],paCols[gdLoja], @_cPedito)

		// Busca mensagem Z44
		_cMen := Alltrim(getZ44Mg(paCols[gdClie],paCols[gdLoja],'1'))+CRLF
		_cMen +=" <b>NOTA: <FONT COLOR=RED>"+paCols[NPOSDOC]+"</b></FONT> <b>PEDIDO: <FONT COLOR=RED>"+alltrim(_cPedito)+"</b></FONT>"
		if Len(_cMen) > 0
			Aadd(aMsgRom,{paCols[NPOSDOC],_cMen})
		endif
		paCols[1] := .F.
		_lRET     := .F.
	endif

	if !STVLDEAN(paCols[NPOSDOC],'001',paCols[gdClie],paCols[gdLoja],@_cPedito)
		// Busca mensagem Z44
		_cMen := Alltrim(getZ44Mg(paCols[gdClie],paCols[gdLoja],'4'))+CRLF
		_cMen += " <b>NOTA: <FONT COLOR=RED>"+paCols[NPOSDOC]+"</b></FONT> <b>PEDIDO: <FONT COLOR=RED>"+alltrim(_cPedito)+"</b></FONT>"
		if Len(_cMen) > 0
			Aadd(aMsgRom,{paCols[NPOSDOC],_cMen})
		endif
		paCols[1] := .F.
		_lRET     := .F.
	endif

	If paCols[1]    .And. ('Pendente' $ paCols[gdGuia])
		paCols[1] := .T.
	EndIf

	RestArea( aAreaZ44 )

Return _lRET

Static Function AvisoRom()
	Local nX     := 0

	_cMsgRom := ""

	For nX := 1 to Len(aMsgRom)
		_cMsgRom += aMsgRom[nX][2] + CRLF+ CRLF
	Next
	if !Empty(_cMsgRom)
		MsgInfo(_cMsgRom, "Atenção!!!" )
	Endif

Return

/* {Protheus.doc} Function STFSF60GX
Description
Rotina Filtra Registros
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 01/10/2019
@type 
*/
Static Function STFSF60GX(cNFSDe,cNFSAte,cSerieDe,cSerieAte,cClienteDe,cClienteAte,cLojaDe,cLojaAte,dEmissaoDe,dEmissaoAte,cTransp,cTranAte,cRegiaoDe,cRegiaoAte,cTpFrete, plRem)

	Local aRet    := {}
	Local nTotReg := 0
	Local cQuery
	Local cNomeCli
	Local dEmissao
	Local cEst    := ""
	Local cCid    := ""
	Local _XDTOBS := ''
	Local _cGuia  := ''
	Local aEstCid  := {;
		{'Rio Preto da Eva','AM'},;
		{'Manaus','AM'},;
		{'Presidente Figueiredo','AM'},;
		{'Tabatinga','AM'},;
		{'Boa Vista','RR'},;
		{'Bonfim','RR'},;
		{'Pacaraima','RR'},;
		{'Macapa','AP'},;
		{'Santana','AP'},;
		{'Cruzeiro do Sul','AC'},;
		{'Brasileia','AC'},;
		{'Epitaciolandia','AC'},;
		{'Guajara-mirim','RO'}}

	Default plRem := .F.

	aEval(aEstCid, {|X| cEST += Upper(X[2]+",") })
	aEval(aEstCid, {|X| cCid += UPPER(X[1]+",") })
	cEST := Substr(cEST,1,Len(cEST)-1)
	cCid := Substr(cCid,1,Len(cCid)-1)

	dbSelectArea("SF2")

	// adicionado A1_ATIVIDA - Valdemir Rabelo 04/02/2020
	cQuery := " SELECT F2_OK, F2_DOC, F2_SERIE, F2_CLIENTE , F2_LOJA, F2_EMISSAO, F2_TRANSP, F2_VOLUME1, ROUND(F2_PLIQUI,2) AS F2_PLIQUI, ROUND(F2_PBRUTO,2) AS F2_PBRUTO, 	A1_COD,  A1_ATIVIDA, NVL(X5_DESCRI,' ') AS A1_XZONA, A1_LOJA, SUBSTR(A1_NOME,1,30) AS A1_NOME, A1_REGIAO, F2_XGUIA,F2_XPRFGUI,F2_EST,F2_XDECLA,F2_XPIN, A1_MUN, A1_EST," + CRLF
	cQuery += " F2_XCODROM, C5_XPLACA," + CRLF
	//cQuery += "   CASE WHEN F2_TRANSP='000001' THEN SUBSTR(A1_NOME, 1, 20) ELSE SUBSTR(A4_NOME, 1, 30) END  AS TRANSP, F2_XCUBAGE, F2_XOBSROM AS OBS  , CASE WHEN C5_XTIPO='1' THEN 'RETIRA' ELSE 'ENTREGA' END  AS TPENT , CASE WHEN F2_TPFRETE='C' THEN 'CIF' ELSE 'FOB' END  AS TPFRET, F2_XDTOBSR   Removido conforme solicitação do Kleber 09/06/2020
	cQuery += " SUBSTR(A4_NOME, 1, 30) AS TRANSP, F2_XCUBAGE, F2_XOBSROM AS OBS  , CASE WHEN C5_XTIPO='1' THEN 'RETIRA' ELSE 'ENTREGA' END  AS TPENT , CASE WHEN F2_TPFRETE='C' THEN 'CIF' ELSE 'FOB' END  AS TPFRET, F2_XDTOBSR, SF2.R_E_C_N_O_ REGSF2 " + CRLF

	cQuery += "  FROM "+RetSqlName("SF2")+" SF2 " + CRLF

	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SA1")+") SA1 " + CRLF
	cQuery += " ON      SA1.A1_FILIAL = '" + xFilial("SA1") + "' " + CRLF
	cQuery += " AND 	SF2.F2_CLIENTE = SA1.A1_COD " + CRLF
	cQuery += " AND     SF2.F2_LOJA = SA1.A1_LOJA " + CRLF
	cQuery += " AND     SA1.D_E_L_E_T_ = ' ' " + CRLF

	//cQuery += " LEFT JOIN(SELECT * FROM SX5010) SX5
	cQuery += " LEFT JOIN( SELECT * FROM " + RETSQLNAME("SX5") + ") SX5  " + CRLF    // Valdemir Rabelo 05/01/2022 - Ticket: 20220105000239
	cQuery += " ON SX5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND X5_TABELA = '_F' AND X5_CHAVE = A1_XZONA " + CRLF

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )D2 ON D2.D_E_L_E_T_=' ' " + CRLF
	cQuery += " AND D2.D2_FILIAL=SF2.F2_FILIAL AND D2.D2_DOC=SF2.F2_DOC AND D2.D2_ITEM='01' " + CRLF
	//FR - 02/05/2023 - IGUALAR O CAMPO SÉRIE NESTA QUERY
	cQuery += " AND D2.D2_SERIE = SF2.F2_SERIE " + CRLF

//Ticket 20221216022034
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )C6 ON C6.D_E_L_E_T_=' ' " + CRLF
	cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6.C6_NUM=D2.D2_PEDIDO AND C6.C6_PRODUTO = D2.D2_COD AND C6.C6_OPER <> '30' " + CRLF
////

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+") C5 ON C5.D_E_L_E_T_=' ' " + CRLF
	cQuery += " AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO " + CRLF

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA4")+") A4 " + CRLF
	cQuery += " ON A4.D_E_L_E_T_=' ' " + CRLF
	cQuery += " AND A4.A4_COD=SF2.F2_TRANSP " + CRLF
	cQuery += " AND A4_FILIAL = '" + xFilial("SA4") + "' " + CRLF

	cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial("SF2") + "' " + CRLF
	cQuery += " AND SF2.F2_CHVNFE  <> ' ' " + CRLF
	if !plRem
		cQuery += " AND 	SF2.F2_XCODROM  = '          ' " + CRLF
	Endif
	/*Comentado por jackson santos -Totvs em atendimento ao chamado: 20220824016361
	cQuery += " AND     C5.C5_XTRONF <> '1' "     // Valdemir Rabelo 03/05/2022 - Chamado: 20220412007894      
	Fim Comentario jackson Santos-Totvs*/
	cQuery += " AND 	C5.C5_XPLACA <> 'TRIANGUL' " + CRLF
	cQuery += " AND 	SF2.F2_DOC       BETWEEN '" + cNFSDe 			+ "'  AND   '" + cNFSAte + "' " + CRLF
	cQuery += " AND 	SF2.F2_SERIE     BETWEEN '" + cSerieDe 			+ "'  AND   '" + cSerieAte + "' " + CRLF
	cQuery += " AND 	SF2.F2_CLIENTE   BETWEEN '" + cClienteDe 		+ "'  AND   '" + cClienteAte + "' " + CRLF
	cQuery += " AND 	SF2.F2_LOJA      BETWEEN '" + cLojaDe 			+ "'  AND   '" + cLojaAte + "' " + CRLF
	if !plRem		// Valdemir Rabelo 08/05/2020
		dEmissaoDe := Ctod( "01/01/" + Strzero(Year(dDatabase),4))

		cQuery += " AND 	SF2.F2_EMISSAO   BETWEEN '" + DTOS(dEmissaoDe)  + "'  AND   '" + DTOS(dEmissaoAte) + "' " + CRLF
	endif
	cQuery += " AND 	SF2.F2_TRANSP    BETWEEN '" + cTransp 			+ "'  AND   '" + cTranAte + "' " + CRLF

	If cEmpAnt=="01"
		cQuery += " AND ((SF2.F2_CLIENTE <> '033467') OR (SF2.F2_CLIENTE='033467' AND SF2.F2_EMISSAO>='20201013')) " + CRLF
	Else 
		cQuery += " AND SUBSTRING(SF2.F2_CLIENTE,1,1) <> 'X' " + CRLF	
		//FR - 07/07/2023 - CONFORME VALIDAÇÃO DE KLEBER PARA ROMANEIO, NOTAS DE CLIENTES COM CÓDIGO INICIADO COM 'X' NÃO PODEM SER MOSTRADAS
	EndIf
	if !plRem
		//FR - 02/05/2023 - Flávia Rocha - Sigamat Consultoria
		//Ajuste na query para igualar PD2_NFS = F2_DOC e PD2_SERIES = F2_SERIE
		cQuery += " AND       NOT exists (SELECT PD2_NFS FROM "+RetSqlName("PD2")+" PD2 WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL=SF2.F2_FILIAL AND PD2.PD2_NFS=SF2.F2_DOC and PD2.PD2_SERIES = SF2.F2_SERIE) " + CRLF
	Endif
	cQuery += " AND  	SF2.D_E_L_E_T_ = ' ' " + CRLF

	cQuery += " AND SF2.F2_TRANSP NOT IN ("+AllTrim(GetMv("STFSFA1002",,"'COMERH'"))+")

	cQuery += " ORDER BY F2_DOC, F2_SERIE " + CRLF
	
	Memowrite("C:\TEMP\STFATROM.TXT" , cQuery)

	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS 'SF2TMP'

	SF2TMP->( dbEval({|| nTotReg++},,{|| !Eof() }) )
	SF2TMP->( dbGotop() )
	ProcRegua( nTotReg )

	While SF2TMP->(!Eof())
		IncProc()
		cNomeCli    := Alltrim(SF2TMP->A1_NOME)
		dEmissao    := CTOD(Right(SF2TMP->F2_EMISSAO,2)+"/"+SubStr(SF2TMP->F2_EMISSAO,5,2)+"/"+Left(SF2TMP->F2_EMISSAO,4))

		_cRegiao:= 	u_StCepReg(SF2TMP->F2_DOC,SF2TMP->F2_SERIE,' ')
		_cCepx  := 	u_StCepReg(SF2TMP->F2_DOC,SF2TMP->F2_SERIE,'1')
		_XDTOBS := DTOC(STOD(SF2TMP->F2_XDTOBSR))

		CB7->(DbSetOrder(4))
		If CB7->(DbSeek(xFilial('CB7')+SF2TMP->(F2_DOC+F2_SERIE)))
			If!Empty(DTOC(CB7->CB7_XDFEM))  .AND. !(CB7->CB7_STATUS $ "1/9")

				If !(Empty(Alltrim(SF2TMP->F2_XGUIA)))
					dbselectarea("SE2")
					SE2->(dbSetOrder(1))
					If SE2->(DbSeek(Xfilial("SE2")  +SF2TMP->F2_XPRFGUI+padr(alltrim(SF2TMP->F2_EST+Right( AllTrim( SF2TMP->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )			//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
						If SE2->E2_SALDO > 0
							_cGuia:= 'Pendente'
						Else
							_cGuia:= 'Paga'
						Endif
					Else
						_cGuia:= 'Pendente'
					Endif
				Endif
				if ((ALLTRIM(SF2TMP->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2TMP->F2_EST) == 'MS') .AND. (SF2TMP->F2_XDECLA=="S")) .OR. (SF2TMP->F2_XPIN=="S")		// Valdemir Rabelo 04/02/2020 - Declaração - Trocado E5 p/ E3 - Ticket: 20210318004396 - 04/06/2021
					_cGuia:= 'Pendente'
				endif
				SF2TMP->(aadd(aRet,{.F.,F2_DOC,F2_SERIE,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1, IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' ')  ,F2_PLIQUI,F2_PBRUTO,TPENT,TRANSP,_XDTOBS,OBS ,A1_XZONA,F2_XCUBAGE,.F.}))
			Else 
				//if plRem
					SF2TMP->(aadd(aRet,{.F.,F2_DOC,F2_SERIE,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1, IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' ')  ,F2_PLIQUI,F2_PBRUTO,TPENT,TRANSP,_XDTOBS,OBS ,A1_XZONA,F2_XCUBAGE,.F.}))
				//endif
			Endif
		Else
			if ((ALLTRIM(SF2TMP->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2TMP->F2_EST) == 'MS') .AND. (SF2TMP->F2_XDECLA=="S"))  .OR. (SF2TMP->F2_XPIN=="S")		// Valdemir Rabelo 04/02/2020 - Declaração - Trocado E5 p/ E3 - Ticket: 20210318004396 - 04/06/2021
				_cGuia:= 'Pendente'
			endif
			SF2TMP->(aadd(aRet,{.F.,F2_DOC,F2_SERIE,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' '),F2_PLIQUI,F2_PBRUTO,TPENT,TRANSP,_XDTOBS,OBS ,A1_XZONA,F2_XCUBAGE,.F.}))
		Endif
		_cGuia:= ''
		SF2TMP->(DbSkip())
	Enddo

	SF2TMP->(dbCloseArea())

Return aRet

/* {Protheus.doc} Function CrgaHeadR
Description
Rotina Monta Cabecalho
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 01/10/2019
@type 
*/
Static Function CrgaHeadR()
	Local aCamposOK := {"","Numero","Serie","Volume 1","Peso Bruto","Tp.Frete","Guia","Cliente","Loja","Nome Cliente","Zona","Dt.Emissão","Cep Entrega","Peso Liq","Tipo","Transportadora","Dt.Atu.Obs","Observação"}
	Local aRet      := aClone(aCamposOK)
Return aRet

/* {Protheus.doc} Function STFSF60C
Description
Rotina Atualizar informações do romaneios
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 02/10/2019
@type 
*/
Static Function STFSF60C(cCodRomaneio,lEncerra,_cNote,_cSerious)
	Local   nVols       := 0
	Local   nPesoL      := 0
	Local   nPesoB      := 0
	Local   nAndamentos := 0
	Local   nFechados   := 0
	Local   cStatus     := "0"
	Local   nRegsPD2    := 0
	Local   lBraspress   := Getmv("ST_BRASPRE",,.F.)
	Local   lEtiqBras   := .f.
	Default lEncerra    := .f.
	Default _cNote      := ''
	Default _cSerious   := ''

	PD1->(DbSetOrder(1))
	If	PD1->(DbSeek(xFilial("PD1")+cCodRomaneio))

		PD2->(DbSetOrder(1))
		If	PD2->(DbSeek(xFilial("PD2")+cCodRomaneio))
			While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+cCodRomaneio)
				++nRegsPD2
				If PD2->PD2_STATUS == "1"  //Em andamento
					++nAndamentos
				ElseIf PD2->PD2_STATUS == "2"  //Fechados
					++nFechados
					//INICIO GRAVACAO LOG Z05
					DbSelectArea("SC6")
					SC6->(DbSetOrder(4))
					IF SC6->(DbSeek(xFilial("PD2")+PD2->PD2_NFS+PD2->PD2_SERIES))
						u_LOGJORPED("PD1","8"," "," ",SC6->C6_NUM,"","Finalizacao romaneio",SF2->F2_VALBRUT)
					EndIf
					//FIM GRAVACAO LOG Z05
				Endif

				nVols 	+= PD2->PD2_QTDVOL
				nPesoL 	+= PD2->PD2_PLIQ
				nPesoB 	+= PD2->PD2_PBRUTO
				PD2->(DbSkip())
			Enddo

			If nFechados == nRegsPD2
				cStatus := If(lEncerra,"3","2")
			ElseIf nFechados>0 .OR. nAndamentos>0
				cStatus := "1"
			ElseIf nFechados==0 .OR. nAndamentos==0
				cStatus := "0"
			Endif
		Endif
		IF (nRegsPD2=0)				// Adicionado 26/11/2019 - Valdemir
			if MsgYesNo("Deseja excluir o romaneio?","Atenção!")
				if VldPD2Exc(cCodRomaneio)   // Valdemir Rabelo 28/05/2021 - Ticket: 20210527008842
					PD1->(RecLock("PD1",.F.))
					PD1->( dbDelete() )
					PD1->(MsUnLock())
					LimpDados()
					Return
				Endif
			Endif
		Endif

		//Atualiza informacao da tabela de Romaneio:
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_QTDVOL := nVols
		PD1->PD1_PLIQ   := nPesoL
		PD1->PD1_PBRUTO := nPesoB
		PD1->PD1_STATUS := cStatus
		PD1->(MsUnLock())

	Endif
Return

/* {Protheus.doc} Function VLDINFOS
Description
Rotina validação na Gravação Apos Parametros
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 02/10/2019
@type 
*/
Static Function VLDINFOS()
	Local _lRet 	  := .T.
	Local _cQuery1 	  := ""
	Local nX          := 0
	Local nCUBDA3     := 0
	Local _nQtPeVei   := 0
	Local lVld        := .F.
	Local _cAlias1    := GetNextAlias()
	Local nPosPBruto  := Ascan(aHeadR,{|x| Upper(Alltrim(x))=="PESO BRUTO"})
	Local aRange      := {}

	_xDtEntre := MV_PAR01
	_xPeriodo := MV_PAR02
	_xMotoris := MV_PAR03
	_xAjudan1 := MV_PAR04
	_xAjudan2 := MV_PAR05
	_xVeiculo := MV_PAR06
	_xModelo  := MV_PAR07
	_xTipoRom := MV_PAR08
	_xObserv  := MV_PAR09
	_xRota    := MV_PAR10

	cVeiculo  := _xVeiculo
	cDtEnt    := _xDtEntre

	// Valdemir Rabelo 13/09/2019
	lVld := u_gVldCPO('PD1_MOTORI','_xMotoris') .AND. u_gVldCPO('PD1_AJUDA1','_xAjudan1')  .and. STFSFA63()
	if !lVld
		Return .F.
	endif

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("DA4")+" DA4
	_cQuery1 += " WHERE DA4.D_E_L_E_T_=' ' AND DA4_FILIAL='"+xFilial("DA4")+"'
	_cQuery1 += " AND DA4_NOME LIKE '"+AllTrim(_xMotoris)+"%'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		MsgAlert("Motorista não encontrado no cadastro, selecione através da lupa por favor.")
		Return(.F.)
	Else
		_cUsrMot := (_cAlias1)->DA4_XUSER
		_cNomMot := (_cAlias1)->DA4_NOME

		_cQuery1 := " SELECT * FROM "+RetSqlName("PD1")+" PD1
		_cQuery1 += " WHERE PD1.D_E_L_E_T_ = ' '
		_cQuery1 += " AND PD1_MOTORI = '"+_cUsrMot+"'
		_cQuery1 += " AND PD1_DTEMIS = '"+ DTOS(DATE())+"'
		_cQuery1 += " AND PD1_FILIAL = '"+cFilAnt+"'
		_cQuery1 += " AND PD1_STATUS <> '3' AND  PD1_STATUS <> '5'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If !(_cAlias1)->(Eof())
			MsgAlert("Motorista ja Associado em outro Romaneio Ativo.")
			Return(.F.)
		EndIf
	EndIf

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("DAU")+" DAU
	_cQuery1 += " WHERE DAU.D_E_L_E_T_=' ' AND DAU_FILIAL='"+xFilial("DAU")+"'
	_cQuery1 += " AND DAU_NOME LIKE '"+AllTrim(_xAjudan1)+"%'"

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		MsgAlert("Ajudante1 não encontrado no cadastro, selecione através da lupa por favor.")
		Return(.F.)
	Else
		_cUsrAj1 := (_cAlias1)->DAU_XUSER
		_cNomAj1 := (_cAlias1)->DAU_NOME

		_cQuery1 := " SELECT * FROM "+RetSqlName("PD1")+" PD1
		_cQuery1 += " WHERE PD1.D_E_L_E_T_ = ' '
		_cQuery1 += " AND PD1_AJUDA1 = '"+_cUsrAj1+"'
		_cQuery1 += " AND PD1_DTEMIS = '"+ DTOS(DATE())+"'
		_cQuery1 += " AND PD1_FILIAL = '"+cFilAnt+"'
		_cQuery1 += " AND PD1_STATUS <> '3' AND  PD1_STATUS <> '5'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If !(_cAlias1)->(Eof())
			MsgAlert("Ajudante ja Associado em outro Romaneio Ativo.")
			Return(.F.)
		EndIf

	EndIf

	If !Empty(_xAjudan2)

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("DAU")+" DAU
		_cQuery1 += " WHERE DAU.D_E_L_E_T_=' ' AND DAU_FILIAL='"+xFilial("DAU")+"'
		_cQuery1 += " AND DAU_NOME LIKE '"+AllTrim(_xAjudan2)+"%'"

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(Eof())
			MsgAlert("Ajudante2 não encontrado no cadastro, selecione através da lupa por favor.")
			Return(.F.)
		Else
			_cUsrAj2 := (_cAlias1)->DAU_XUSER
			_cNomAj2 := (_cAlias1)->DAU_NOME
		EndIf

	EndIf

	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	If !DA3->(DbSeek(xFilial("DA3")+_xVeiculo))
		MsgAlert("Placa não encontrada no cadastro, selecione através da lupa por favor.")
		Return(.F.)
	Else
		MV_PAR07 := DA3->DA3_DESC
		nX:=0
		For nX:=1 to Len(aCols)
			if aCols[nX,1]
				_nQtPeVei= aCols[nX,nPosPBruto]
			Endif
		Next nX
		If 	_nQtPeVei > (DA3->DA3_CAPACN/100*80)
			MsgAlert("Peso acima do permitido, Peso Excedente: "+cValtochar(_nQtPeVei - (DA3->DA3_CAPACN/100*80)))
			Return(.F.)
		EndIf

		_lRET := (Right(_xVeiculo,1) $ "0/1/2/3/4/5/6/7/8/9")
		nCUBDA3 := (DA3->DA3_ALTINT * DA3->DA3_COMINT * DA3->DA3_LARINT)
		if _lRET .And. (nCUBDA3==0)
			MsgAlert("Não foi infomado a cubagem para este veículo. Por favor, ajuste o cadastro.")
			Return(.F.)
		Else
			_lREt := .T.
		Endif

	EndIf
	If _xDtEntre < Date()
		MsgAlert("Data de entrega menor que a data de hoje, verifique!")
		Return(.F.)
	EndIf

Return(_lRet)

Static Function AtuaBrow()
	oGetD:SetArray(aCols)
	oGetD:bLine := {||{;
		If( aCols[oGetD:nAt,01],oOK,oNO),;
			aCols[oGetD:nAt,02],;
			aCols[oGetD:nAt,03],;
			aCols[oGetD:nAt,04],;
			aCols[oGetD:nAt,05],;
			aCols[oGetD:nAt,06],;
			aCols[oGetD:nAt,07],;
			aCols[oGetD:nAt,08],;
			aCols[oGetD:nAt,09],;
			aCols[oGetD:nAt,10],;
			aCols[oGetD:nAt,11],;
			aCols[oGetD:nAt,12],;
			aCols[oGetD:nAt,13],;
			aCols[oGetD:nAt,14],;
			aCols[oGetD:nAt,15],;
			aCols[oGetD:nAt,16],;
			aCols[oGetD:nAt,17],;
			aCols[oGetD:nAt,18] } }
		oGetD:Refresh()

Return

Static Function STFSFA63()
	Local lRET    := .T.			// Valdemir Rabelo 23/08/2019
	Local nPeso   := 0				// Valdemir Rabelo 23/08/2019
	Local nCubag  := 0              // Valdemir Rabelo 23/08/2019
	Local nCUBDA3 := 0				// Valdemir Rabelo 23/08/2019
	Local nPerCub := SuperGetMV("ST_PERCUB",.F.,20)   // Valdemir Rabelo 23/08/2019
	Local nPesoB  := Ascan(aHeadR,{|x| Upper(Alltrim(x))=="PESO BRUTO"})

	if Empty(cVeiculo)
		Return .T.
	endif
	// Valido o veículo se existe
	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	lRET := DA3->(DbSeek(xFilial("DA3")+cVeiculo))
	if lRET
		MV_PAR07 := DA3->DA3_DESC
		lRET :=  u_GVldPD1("PD1_PLACA", cVeiculo) 		// Valdemir Rabelo 23/08/2019
		if !lRET
			FWMsgRun(,{|| Sleep(3000)}, "Atenção!", "Veículo: "+alltrim(_xModelo)+" não disponível. ")
		else
			// -------------------------------- Valdemir Rabelo 26/08/2019 -----------------------------------------------------------
			aEVal(aCols, {|X| if(X[1], nPeso += X[nPesoB], 0) })
			// Será validado o peso se está de acordo com o valor informado no cadastro de veículo - DA3_VOLMAX
			lRET := (nPeso <= DA3->DA3_CAPACM)

			if !lRET
				FWMsgRun(,{|| Sleep(3000)}, "Atenção!", "Total Peso: "+Transform(nPeso,"@E 999,999.99")+" ultrapassa o limite maximo: "+Transform(DA3->DA3_CAPACM,"@E 999,999.99"))
			Endif

			// Será validado a cubagem
			nCUBDA3 := (DA3->DA3_ALTINT * DA3->DA3_COMINT * DA3->DA3_LARINT)

			/*if !lRET
				cMsg := ""
				cMsg := "O total da cubagem <FONT COLO='RED'><b>" +cValToChar(nCubag)+ "</b></FONT> ultrapassa o limite permitido" + CRLF
			if nCUBDA3=0
					cMsg := "Os dados para calculo de cubagem não foi informado no cadastro do veículo <B>Tabela: DA3</B>"
			else
					cMsg += " <B>"+CVALTOCHAR(nCUBDA3)+"</B>"
			endif
				MsgInfo(cMsg, "Atenção!")
		Else*/
				lRET := gVldRod(_xDtEntre)   // Valida placa em dia de rodizio
			//Endif
			//---------------------------------------------------------------------------------------------------
		endif
	else
		FWMsgRun(,{|| Sleep(3000)}, "Atenção!", "Veículo não encontrado")
	EndIf

Return(lRET)

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function GVldPD1
	Description
	Valida se o veículo/Motorista/Ajudante ja está sendo utilizado em outro romaneio
	e no período informado
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 23/08/2019
	@type 
	/*/
//--------------------------------------------------------------
user Function GVldPD1(pCAMPO, pConteudo)
	Local aAreaM     := GetArea()
	Local lRET       := .T.
	Local cQry       := ""
	Local _cConteudo := ""

	// Valdemir Rabelo 09/06/2020
	if 		(pCAMPO=='PD1_PLACA')
		_cConteudo := cVeiEsp
	elseif (pCAMPO=='PD1_MOTORI')
		_cConteudo := cMotEsp
	elseif (Left(pCAMPO,9)=='PD1_AJUDA')
		_cConteudo := cAjuEsp
	endif

	if (alltrim(pConteudo) $ _cConteudo)			// Valdemir Rabelo 11/05/2020 / 09/06/2020
		Return lRET
	Endif

	cQry := "SELECT COUNT(*) REG " + CRLF
	cQry += "FROM " + RETSQLNAME("PD1") + " PD1 " + CRLF
	cQry += "WHERE PD1.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND PD1.PD1_DTENT='" +dtos(MV_PAR01)+ "'"				// Valdemir Rabelo 09/06/2020
	cQry += " AND PD1.PD1_STATUS IN ('2','1') " + CRLF
	cQry += " AND PD1.PD1_PERIOD=" +cValToChar(MV_PAR02)+ " " + CRLF
	cQry += " AND PD1."+pCAMPO+" LIKE '" +pConteudo+ "%' " + CRLF

	IF SELECT("TPLACA") > 0
		TPLACA->( dbCloseArea() )
	endif
	TcQuery cQry New Alias "TPLACA"

	lRET := (TPLACA->( eof() ) .or. Empty(TPLACA->REG))

	IF SELECT("TPLACA") > 0
		TPLACA->( dbCloseArea() )
	endif

	RestArea( aAreaM )

Return lRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function STFMOTF3
	Description
	Rotina para apresentar os Ajudantes disponíveis
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 10/09/2019
	@type 
	/*/
//--------------------------------------------------------------
USER FUNCTION STFAJUF3(pCampo)
	Local aAreaF3 := GetArea()
	Local cQry    := ""
	Local nRetCol := 2			// Coluna que fará o retorno
	Local cAlias  := "DAU"
	Local aCampos := { {"Código","Nome"},;
		{"DAU_COD","DAU_NOME"} }

	cQry := "SELECT DAU_COD, PAI.DAU_NOME, PAI.R_E_C_N_O_ REG   " + CRLF
	cQry += "FROM " + RETSQLNAME('DAU') + " PAI 				" + CRLF
	cQry += "WHERE PAI.D_E_L_E_T_ = ' '							" + CRLF
	if !(alltrim(MV_PAR06) $ cVeiEsp)							// Valdemir Rabelo 09/06/2020
		cQry += "AND (SELECT count(*)" + CRLF
		cQry += "		FROM " + RETSQLNAME('PD1') + " PD1 " + CRLF
		cQry += "		WHERE PD1.D_E_L_E_T_ = ' '" + CRLF
		if alltrim(upper(cVeiEsp)) != "BRASPRESS"          // Valdemir Rabelo Ticket: 20220112000954 - 18/01/2022
			cQry += "		AND PD1.PD1_DTENT='"+dtos(MV_PAR01)+"' " + CRLF
		Endif 
		cQry += "		AND Substr(PD1."+pCampo+",1,15)=Substr(PAI.DAU_NOME,1,15) " + CRLF
		if MV_PAR02 < 3
			cQry += " AND PD1.PD1_PERIOD IN (" +cValToChar(MV_PAR02)+ ", 3) " + CRLF
		ELSE
			cQry += " AND PD1.PD1_PERIOD IN (1,2,3,4)" + CRLF
		ENDIF
		cQry += "  ) = 0" + CRLF
		// VALDEMIR RABELO 18/01/2022 - 20220112000954
		cQry += " OR (SELECT count(*) " + CRLF
		cQry += "		FROM "+RETSQLNAME("PD1")+" PD1 " + CRLF
		cQry += "		WHERE PD1.D_E_L_E_T_ = ' '" + CRLF	
		cQry += "       AND Substr(PD1.PD1_MOTORI,1,10)='BRASPRESS' " + CRLF 
 		cQry += "       AND PD1_STATUS IN('0','1','2') )=0" + CRLF 

	Endif
	U_BUSCAF3(cAlias, aCampos, '', '', cQry, nRetCol)

	RestArea( aAreaF3 )

RETURN .T.

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function vldVei01
	Description
	Rotina para validar veiculo parâmetro
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 10/09/2019
	@type 
	/*/
//--------------------------------------------------------------
User Function vldVei01()
	Local lRET := .T.
	Local pPlaca := MV_PAR06

	if !Empty(pPlaca)
		DbSelectArea("DA3")
		DA3->(DbSetOrder(1))
		IF DA3->(DbSeek(xFilial("DA3")+alltrim(pPlaca)))
			MV_PAR07 := DA3->DA3_DESC
			cDescVei := DA3->DA3_DESC
			nCubVei  := (DA3->DA3_ALTINT * DA3->DA3_COMINT * DA3->DA3_LARINT)
			nPesVei  := DA3->DA3_CAPACM
		else
			FWMsgRun(,{|| sleep(3000)},"Informativo","Veículo não encontrado")

			lRET := .F.
		Endif
	Endif

Return lRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function vldVei02
	Description
	Rotina para validar veiculo com romaneios
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 10/09/2019
	@type 
	/*/
//--------------------------------------------------------------
Static Function vldVei02(pPlaca, lTrue, lAdic)
	Local lRET     := .T.
	Local nREG     := 0
	Local nPerCub  :=SuperGetMV("ST_PERCUB",.F.,20)
	Local lNovo    := .F.
	Default pPlaca := ""
	Default lTrue  := .T.
	Default lAdic  := .T.
	Default pPlaca := "RETIRA"

	if !Empty(pPlaca)
		if (pPlaca $ cVeiEsp) .and. lTrue    // Valdemir Rabelo 09/06/2020
			lNovo    := MSGYESNO("Deseja criar um novo romaneio?","Atenção!")
		Endif
		if lNovo
			// Será um novo romaneio
			cRomaneio := CriaRoma(pPlaca)
			if !Empty(cRomaneio)
				FWMsgRun(,{|| vldVei02(pPlaca, .F.,.f.) },"Informativo","Aguarde, processando...")
			endif
			if !Empty(cRomaneio)
				AtuTotais()
			Endif
		Else
			DbSelectArea("DA3")
			DA3->(DbSetOrder(1))
			IF DA3->(DbSeek(xFilial("DA3")+alltrim(pPlaca)))
				MV_PAR07 := DA3->DA3_DESC
				cDescVei := DA3->DA3_DESC
				nCubVei  := (DA3->DA3_ALTINT * DA3->DA3_COMINT * DA3->DA3_LARINT)
				nCubPer  := nCubVei-(nCubVei*nPerCub/100)
				nPesVei  := DA3->DA3_CAPACM
			else
				FWMsgRun(,{|| sleep(3000)},"Informativo","Veículo não encontrado (DA3)")
				lRET := .F.
			Endif
			if lRET
				if lAdic
					lNovo    := MSGYESNO("Deseja criar um novo romaneio?","Atenção!")
					if lNovo
						// Será um novo romaneio
						cRomaneio := CriaRoma(pPlaca)
						if !Empty(cRomaneio)
							vldVei02(pPlaca, .F., .f.)
							AtuTotais()
						endif
					Else
						// Filtrar Romaneio referente a placa informada
						FWMsgRun(,{|| GetRomOpen(pPlaca), nREG := nGetIDROM},"Informativo","Filtrando registros para placa: "+pPlaca+", aguarde,")
						if nREG > 0
						   getDadosRom(nREG)
						else
							// Será um novo romaneio
							cRomaneio := CriaRoma(pPlaca)
							if !Empty(cRomaneio)
								vldVei02(pPlaca)
							endif
						endif
					Endif
				else
					if (!lTrue .and. !lNovo)
						cRomaneio := PD1->PD1_CODROM
						cMotorista:= PD1->PD1_MOTORI
						cEmissao  := DTOC(PD1->PD1_DTEMIS)
						cDtEnt    := DTOC(PD1->PD1_DTENT)
						cAjudant  := PD1->PD1_AJUDA1
					endif
				endif
				if !Empty(cRomaneio)
					AtuTotais()
				Endif
			endif
		Endif
	Else
		LimpDados()					// Valdemir Rabelo 05/02/2020 - conforme reunião

	Endif

Return lRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function STFMOTF3
	Description
	Rotina para apresentar os motoristas disponíveis
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 09/09/2019
	@type 
	/*/
//--------------------------------------------------------------
User  Function STFMOTF3()
	Local aAreaF3 := GetArea()
	Local cQry    := ""
	Local nRetCol := 2			// Coluna que fará o retorno
	Local cAlias  := "DA4"
	Local aCampos := { {"Codigo","Nome"},;
		{"DA4_COD","DA4_NOME"} }

	cQry := "SELECT DA4_COD, DA4_NOME, PAI.R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME('DA4') + " PAI " + CRLF
	cQry += "WHERE PAI.D_E_L_E_T_ = ' ' 		" + CRLF
	if !(alltrim(MV_PAR06) $ cMotEsp)			// Valdemir Rabelo 09/06/2020
		cQry += " AND (SELECT count(*)" + CRLF
		cQry += "		FROM "+RETSQLNAME("PD1")+" PD1 " + CRLF
		cQry += "		WHERE PD1.D_E_L_E_T_ = ' '" + CRLF			
		cQry += "		 AND PD1.PD1_DTENT='"+DTOS(MV_PAR01)+"' " + CRLF
		cQry += "		 AND Substr(PD1.PD1_MOTORI,1,15)=Substr(PAI.DA4_NOME,1,15) " + CRLF

		if MV_PAR02 < 3
			cQry += " AND PD1.PD1_PERIOD IN (" +cValToChar(MV_PAR02)+ ", 3) " + CRLF
		ELSE
			cQry += " AND PD1.PD1_PERIOD IN (1,2,3)" + CRLF
		ENDIF
		cQry += " AND PD1_STATUS IN('0','1','2') " + CRLF
		cQry += " )=0 " + CRLF 
		// VALDEMIR RABELO 18/01/2022 - 20220112000954
		cQry += " OR (SELECT count(*) " + CRLF
		cQry += "		FROM "+RETSQLNAME("PD1")+" PD1 " + CRLF
		cQry += "		WHERE PD1.D_E_L_E_T_ = ' '" + CRLF	
		cQry += "       AND Substr(PD1.PD1_MOTORI,1,10)='BRASPRESS' " + CRLF 
 		cQry += "       AND PD1_STATUS IN('0','1','2') )=0" + CRLF 
		cQry += " ORDER BY DA4_COD " + CRLF
	Endif
	U_BUSCAF3(cAlias, aCampos, '', '', cQry, nRetCol)

	RestArea( aAreaF3 )

Return .T.

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function STFMOTF3
	Description
	Rotina para apresentar os veículos disponíveis
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 10/09/2019
	@type 
	/*/
//--------------------------------------------------------------
USER FUNCTION STFVEIF3(pPlaca, plFiltra)
	Local aAreaF3 := GetArea()
	Local cQry    := ""
	Local _RET
	Local nMVPAR  := iif(MV_PAR02==nil .or. Empty(MV_PAR02), 9, MV_PAR02)
	Local nRetCol := 1			// Coluna que fará o retorno
	Local cAlias  := "DA3"
	Local aCampos := { {"Placa","Veículo", "Qtd.NF"},;
		{"DA3_COD","DA3_DESC", "QTDNF"} }
	Default pPlaca := ""
	Default plFiltra := .F.

	IF EMPTY(pPlaca)
		cQry := "SELECT PAI.DA3_COD, PAI.DA3_DESC, ("+MntQtdNF()+") AS QTDNF,PAI.R_E_C_N_O_ REG   " + CRLF
		cQry += "FROM " + RETSQLNAME('DA3') + " PAI 					" + CRLF
		cQry += "WHERE PAI.D_E_L_E_T_ = ' '								" + CRLF
		cQry += " AND DA3_FILIAL = '"+XFILIAL('DA3')+"' 				" + CRLF
		if !plFiltra
			cQry += " AND DA3_COD NOT IN (SELECT PD1_PLACA  			" + CRLF
			cQry += "                FROM " + RETSQLNAME('PD1') + " PD1 " + CRLF
			cQry += "                WHERE PD1.D_E_L_E_T_ = ' '			" + CRLF
			cQry += "                 AND PD1_PLACA NOT IN ('"+cVeiEsp+"') " + CRLF
			if nMVPAR < 3
				cQry += " AND PD1.PD1_PERIOD IN (" +cValToChar(nMVPAR)+ ", 3) " + CRLF
			ELSE
				cQry += " AND PD1.PD1_PERIOD IN (1,2,3,4)" + CRLF
			ENDIF
			cQry += "                 AND PD1.PD1_STATUS <> '3')		" + CRLF
			// VALDEMIR RABELO 18/01/2022 - 20220112000954
			cQry += " OR (SELECT count(*) " + CRLF
			cQry += "		FROM "+RETSQLNAME("PD1")+" PD1 " + CRLF
			cQry += "		WHERE PD1.D_E_L_E_T_ = ' '" + CRLF	
			cQry += "       AND Substr(PD1.PD1_MOTORI,1,10)='BRASPRESS' " + CRLF 
			cQry += "       AND PD1_STATUS IN('0','1','2') )=0" + CRLF 

		Endif
		U_BUSCAF3(cAlias, aCampos, '', '', cQry, nRetCol)
		_RET := .T.
	Else
		cQry := "SELECT PD1_CODROM, PD1_PLACA, R_E_C_N_O_ REG " + CRLF
		cQry += "FROM " + RETSQLNAME('PD1') + " PD1 " + CRLF
		cQry += "WHERE PD1.D_E_L_E_T_ = ' '			" + CRLF
		cQry += " AND PD1.PD1_PLACA ='"+pPlaca+"'   " + CRLF
		cQry += " AND PD1.PD1_STATUS <> '3'		    " + CRLF
		cQry += " AND PD1.PD1_FILIAL = '"+XFILIAL('PD1')+"' " + CRLF
		cQry += "ORDER BY R_E_C_N_O_  DESC" + CRLF

		_RET := 0
		if Select('TVeic') > 0
			TVeic->( dbCloseArea() )
		endif
		TcQuery cQry New Alias "TVeic"
		if TVeic->( !Eof() )
			_RET := TVeic->REG
		Endif

	endif

	RestArea( aAreaF3 )

RETURN _RET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function gVldRod
	Description
	Valida a placa do veículo se está no dia de rodizio
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 26/08/2019
	@type 
	/*/
//--------------------------------------------------------------
Static Function gVldRod(pdData, plRod)
	Local lRET     := .F.
	Local nPos     := 0
	Local _cMsg    := ""
	Local cFinal   := Right(alltrim(cVeiculo),1)
	Local aRodizio := { {"1/2", "Segunda-Feria", 2},;
		{"3/4", "Terça-Feira", 3},;
		{"5/6", "Quarta-Feira", 4},;
		{"7/8", "Quinta-Feira", 5},;
		{"9/0", "Sexta-Feira", 6} }
	Default plRod := .F.

	if Empty(pdData)
		Return .T.
	endif

	lRET := Len(ALLTRIM(cVeiculo)) >= 7     // Valido tamanho da string referente a placa do veiculo
	if lRET
		lRET := (cFinal $ "0/1/2/3/4/5/6/7/8/9")		// Verifico se o ultimo caracter referente a placa do veículo é valida
	endif
	if lREt
		nPos := aScan(aRodizio, {|X| Dow(pdData) = X[3]})   // Realizado ajuste Chamado: 20200904006922 - Valdemir Rabelo 04/09/2020
		lRET := !(cFinal $ cValToChar(aRodizio[nPos,1]) )
		_cMsg += "Placa final: <b>"+cFinal+"</b> está no dia de rodizio"+CRLF
		if !plRod
			if nPos > 0
				_cMsg += "Placas com final: <font color='red'>"+aRodizio[nPos][1]+" "+aRodizio[nPos][2]+CRLF+CRLF+"</font>"
			endif
			if !lRET
				_cMsg += "Deseja continuar mesmo assim?"
				lRET := MsgYesNo(_cMsg, "Atenção!")
			endif
		Endif
	else
		if !plRod
			lRET := MsgNoYes("Essa não é uma placa válida. <b>Deseja continuar mesmo assim?</b>","Atenção!")
		else
			lRET := .T.
		Endif
	endif

Return lRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function CheckTime
	Description
	Validação da hora informada
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/08/2019
	@type 
	/*/
//--------------------------------------------------------------
Static Function CheckTime(pHora)
	Local lRet := .T.
	Local cH := SubStr(pHora,1,2)
	Local cM := SubStr(pHora,4,2)

	If Len(AllTrim(pHora)) < 5
		lRet := .F.
	EndIf

	if lRET
		If (Val(cH) < 0) .or. (Val(cH) > 23)
			lRet := .F.
		EndIf
	Endif
	if lRET
		If (Val(cM) < 0) .or. (Val(cM) > 59)
			lRet := .F.
		EndIf
	Endif

	if !lRet
		FWMsgRun(, {|| sleep(3000)},"Atenção!","Hora informada é invalida. Por favor, verifique.")
	endif

Return lRet

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function gVldCPO
	Description
	Valida se o Motorista/Ajudante ja está sendo utilizado em outro romaneio
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 23/08/2019
	@type 
	/*/
//--------------------------------------------------------------
USER Function gVldCPO(pCAMPO, pConteudo)
	Local aAreaM := GetArea()
	Local lRET   := .T.
	Local cCampo := ""

	IF Empty(&(pConteudo))
		Return .T.
	endif

	if pCAMPO=="PD1_MOTORI"
		cCAMPO := "Motorista"
	elseif pCAMPO=="PD1_AJUDA1"
		cCAMPO := "Ajudante 1 "
	elseif pCAMPO=="PD1_AJUDA2"
		cCAMPO := "Ajudante 2 "
	endif

	lRET := u_gVldPD1(pCAMPO, &(pConteudo))

	IF !lRET
		FWMsgRun(,{|| sleep(3000)},"Atenção!",cCampo+" não disponível. Por favor, verifique.")
	ENDIF
	IF LEFT(pCAMPO,9)=="PD1_AJUDA"
		DAU->( dbSetOrder(2) )
		if DAU->( dbSeek(xFilial("DAU")+&(pConteudo)) )
			cVarCori := DAU->DAU_XUSER
		Endif
	Endif

	RestArea( aAreaM )

Return lRET

Static Function STVLDROM(cNota,cSerie,cCliente,cLoja, pcPedido)

	Local _lRet := .T.
	Local _cStsPed := ""

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbGoTop()

	if dbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cLoja)

		while !eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+cNota+cSerie+cCliente+cLoja

			_cStsPed := Posicione("SC5",1,XFILIAL("SC5")+SD2->D2_PEDIDO,"C5_XBLQROM")

			IF (_cStsPed $ "S/1")
				_lRet := .F.
			endif
		    
			pcPedido := SD2->D2_PEDIDO		// Valdemir Rabelo 14/07/2020

			_cStsPed := ""

			dbSelectArea("SD2")
			dbSkip()
		End

	Endif

Return _lRet

Static Function STVLDEAN(cNota,cSerie,cCliente,cLoja, pcPedido)

	Local _lRet := .T.
	Local _cStsPed := ""

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbGoTop()

	if dbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cLoja)

		while !eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+cNota+cSerie+cCliente+cLoja

			_cStsPed := Posicione("SC5",1,XFILIAL("SC5")+SD2->D2_PEDIDO,"C5_XREAN14")

			IF (_cStsPed $ "S/1")
				_lRet := .F.
			endif

		    pcPedido := SD2->D2_PEDIDO		// Valdemir Rabelo 14/07/2020
			_cStsPed := ""

			dbSelectArea("SD2")
			dbSkip()
		End

	Endif

Return _lRet

/* {Protheus.doc} Function AtuLbx5
Description
Rotina para atualizar o ListBox
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 08/11/2019
@type 
*/
Static Function AtuLbx5(oLbx5)
	oLbx5:SetArray( aVetor5 )
	oLbx5:bLine := {|| {Iif(	aVetor5[oLbx5:nAt,01],oOk,oNo),;
		aVetor5[oLbx5:nAt,02],;
		aVetor5[oLbx5:nAt,03],;
		aVetor5[oLbx5:nAt,04],;
		aVetor5[oLbx5:nAt,05],;
		aVetor5[oLbx5:nAt,06],;
		aVetor5[oLbx5:nAt,07],;
		aVetor5[oLbx5:nAt,08],;
		aVetor5[oLbx5:nAt,09],;
		aVetor5[oLbx5:nAt,10];
		}}
	oLbx5:Refresh()
Return

/* {Protheus.doc} Function AddReg
Description
Rotina de controle dos Romaneios a serem transferidos
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 10/11/2019
@type 
*/
Static Function AddReg(oNotas, aCols, oLbx5, aVetor1)
	Local nX 	  := 0
	Local cExclui := ""
	Local nExclui := 0
	Local nPen    := 0
	Local nConta  := 0

	aEval(aCols, {|X|  if(X[1], nConta++,nil)})

	if nConta==0
		FWMsgRun(,{|| Sleep(3000) },"Informativo","Não foi selecionado nenhum registro para ser movido.")
		Return .T.
	Endif

	if Empty(cVeiculo) .or. Empty(cRomaneio)
		FWMsgRun(,{|| Sleep(3000) },"Informativo","Não foi informado Veiculo/Romaneio. Por favor, verifique.")
		Return .T.
	Endif

	// Valida seleção da Região, se existe algum pendente marcado
	aEVal(aVetor1, { |X| if(X[1] .and. X[2]=="PENDENTE", nPen++,Nil) })
	if nPen==0
		aEVal(aCols, { |X| if(X[1] .and. upper(alltrim(X[7]))=="PENDENTE", nPen++, Nil) })    // Trocado NPOSGUIA para 7 Valdemir Rabelo Ticket: 20210323004666
	Endif

	if nPen > 0				// Valdemir Rabelo 05/03/2020 - Deixando mensagem mais legível e automatizando para não perder tempo refazendo
		//FWMsgRun(,{|| Sleep(3500) },"Informativo","Região pendente as NF não serão movidos. Por favor, verifique.")
		nSel := aScan(aVetor1, { |X| X[2]=="PENDENTE" })
		aVetor1[nSel][1] := .F.
		nPen := 0
		aEVal(aCols, { |X| if(X[1] .and. upper(alltrim(X[7]))=="PENDENTE", nPen++, Nil) })    // Trocado NPOSGUIA para 7 Valdemir Rabelo Ticket: 20210323004666
		if nPen > 0
			aEVal(aCols, { |X| if(X[1] .and. upper(alltrim(X[7]))=="PENDENTE", X[1] := .F., Nil) })
		Endif
		//Return .T.
	Endif

	if (nCubagem > nCubPer)
		_cMsg := "O total da cubagem das notas selecionadas <B>"+cValToChar(nCubagem)+"</B>, <font color='RED'><b>ultrapassam o limite dos 20%</b></font> <B>"+cValToChar(nCubPer)+"</B>"+CRLF+CRLF
		_cMsg += "Deseja continuar mesmo assim?"
		if !MsgNoYes(_cMsg,"Atenção!")
			Return .T.
		endif
	Endif

	CursorWait()

	if Len(aVetor5)==1
		if Empty(aVetor5[1][2])
			aVetor5 := {}
		Endif
	Endif

	VldCubag(.T.)
	aMsgRom := {}
	For nX := 1 to Len(aCols)
		if aCols[nX, NPOSSEL]

			if !GetMens(aCols[nX])
				aCols[nX, NPOSSEL] := .F.
				Loop
			Endif

			aAdd(aVetor5, {;
				.F.,;
				aCols[nX, gdDocum],;
				aCols[nX, gdSerie],;
				aCols[nX, gdClie],;
				aCols[nX, gdLoja],;
				aCols[nX, gdNCli],;
				aCols[nX, gdZona],;
				aCols[nX, gdVolum],;
				aCols[nX, gdPesL],;
				aCols[nX, gdPesBr];
				})
			// Adiciona Registro na Tabela
			FWMsgRun(,{|| AddTabPD1(aCols[nX]) },"Informativo","Aguarde, adicionando Nota Fiscal: "+Alltrim(aCols[nX, NPOSDOC])+" ao romaneio")
			//Exclui elemento do Array
			if !Empty(cExclui)
				cExclui += "/"
			endif
			cExclui += aCols[nX, NPOSDOC]
		Endif
	Next

	if !Empty(cExclui)
		aExclui := Separa(cExclui,"/")
		nEX := 0
		nX  := 0
		For nX := 1 to Len(aExclui)
			nEX := aScan(aCols, {|Z| Z[NPOSDOC] == aExclui[nX] })
			aDel(aCols, nEx)
		Next
		nEX := Len(aExclui)
		//Redimensiona o Array
		aSize(aCols, Len(aCols)-nEX)
	Endif
	AtuLbx5(oLbx5)
	// Carrega com as informações do romaneio
	AtuaBrow()

	CursorArrow()

	if Len(aMsgRom) > 0
		AvisoRom()
	Endif

Return .T.

/* {Protheus.doc} Function RemReg
Description
Rotina de controle para remoção dos romaneios
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 12/11/2019
@type 
*/
Static Function RemReg(oNotas, aCols, oLbx5)
	Local nX 	  := 0
	Local cExclui := ""
	Local _cGuia  := ""
	Local cTPFRET := ""
	Local nExclui := 0
	Local aAreaF2 := GetArea()
	Local dEmissaoDe  	:= Stod('20170101')
	Local dEmissaoAte 	:= Stod('20300101')
	Local cTransp     	:= ' '
	Local cTranAte	  	:= 'ZZ'
	Local cTpFrete		:= '4'
	Local cRegiaoDe   	:= '     '
	Local cRegiaoAte  	:= 'ZZ'
	Local aTmp          := {}
	Local _cMsg         := ""
	Local lContinue     := .T.
	Local nConta        := 0

	aEval(aVetor5, {|X|  if(X[1], nConta++,nil)})

	if nConta==0
		FWMsgRun(,{|| Sleep(3000) },"Informativo","Não foi selecionado nenhum registro para ser movido.")
		Return .T.
	Endif

	CursorWait()

	For nX := 1 to Len(aVetor5)
		if aVetor5[nX, 1]
			if aScan(aRegSel, {|X| Left(X[2],3) == aVetor5[nX][7]})==0
				_cMsg := "A nota fiscal: <font color='red'><b>"+aVetor5[nX, 2]+"</b></font> Serie: <font color='red'><b>"+aVetor5[nX, 3]+"</b></font>"+CRLF+;
					"está em uma região diferente do filtro selecionado. A nota será removida e ao entrar novamente, estará na região de origem." + CRLF + CRLF +;
					"Deseja continuar apresentando a mensagem para os demais registros?"
				if lContinue
					lContinue := MsgYesNo(_cMsg,"Atenção!")
				Endif
			Endif

			//Exclui elemento do Array
			if !Empty(cExclui)
				cExclui += "/"
			endif
			cExclui += aVetor5[nX, 2]

			_lCont := .F.
			aTMP   := {}
			aTmp   := STFSF60GX(aVetor5[nX, 2],aVetor5[nX, 2],aVetor5[nX, 3],aVetor5[nX, 3],aVetor5[nX, 4],aVetor5[nX, 4],aVetor5[nX, 5],aVetor5[nX, 5],dEmissaoDe,dEmissaoAte,cTransp,cTranAte,cRegiaoDe,cRegiaoAte,cTpFrete, .t.)
			if Len(aTmp) > 0	// Valdemir Rabelo 08/05/2020

				// Remove Registro na Tabela
				FWMsgRun(,{|| _lCont := RemTabPD1(aVetor5[nX]) },"Informativo","Aguarde, removendo Nota Fiscal: "+alltrim(aVetor5[nX, 2])+" do romaneio")

				if !_lCont   // Valdemir Rabelo - Caso exista alguma inconsistencia vai para o proximo - 11/06/2020
					Loop
				endif

				if (nX <= Len(aVetor5))
					if (Len(aTmp) > 0) .and. (aScan(aRegSel, {|X| Left(X[2],3) == aVetor5[nX][7]}) > 0)
						//aAdd(aCols, aTmp[1] )    // oGetD:
						aAdd(aCols, GetDbCols(aTmp, .T. )[1])    // oGetD:
					endif
				Endif 
				
			Endif

		Endif
	Next

	RestArea( aAreaF2 )

	if Len(aTmp) > 0			// Valdemir Rabelo 08/05/2020
		if !Empty(cExclui)
			aExclui := Separa(cExclui,"/")
			aSort(aExclui,,, {|X,Y| X > Y})
			nX  := 1
			nEX := 0
			lEX := .F.
			For nX := 1 to Len(aExclui)
				nEX := aScan(aVetor5, {|X| X[2]== aExclui[nX]})
				if nEX > 0
				   aDel(aVetor5, nEX)
				   lEX := .T.
				endif 
			Next
			if lEX
				nExclui := Len(aExclui)

				//Redimensiona o Array
				aSize(aVetor5, Len(aVetor5)-nExclui)
			endif
			if Len(aVetor5)==0
			    LimpDados()
				aVetor5   := {{.F.,'','','','','','',0,0,0}}
			Endif
			// Valdemir Rabelo - 08/05/2020
			oLbx5:Refresh()

			// Valdemir 26/11/2019 - Atualiza Registros
			GetDadosIt()

		Endif
	Else
		MsgInfo("Existe algum problema de relacionamento de tabela. Por favor, informar o setor de TI","Atenção!")
		LimpDados()
	Endif

	CursorArrow()

Return

/* {Protheus.doc} Function GetCubag
Description
Rotina para buscar o valor da cubagem que consta no romaneio
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 10/11/2019
@type 
*/
Static Function GetRetF2(pNota,pSerie,pClient,pLoja,pCampo)
	Local nRET := 0
	Local aAreaSF2 := GetArea()

	dbSelectArea("SF2")
	dbSetOrder(1)
	if dbSeek(xFilial('SF2')+pNota+pSerie+pClient+pLoja)
		nRET := SF2->&(pCampo)
	endif

	RestArea( aAreaSF2 )

Return nRET

/* {Protheus.doc} Function AddTabPD1
Description
Rotina para Adicionar notas ao romaneio
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 11/11/2019
@type 
*/
Static Function AddTabPD1(paCols)
	Local aPedido := {}

	CB7->(DbSetOrder(4))
	SF2->(DbSetOrder(1))
	SD2->(DbSetOrder(3))
	SC5->(DbSetOrder(1))

	If PD1->(DbSeek(xFilial("PD1")+cRomaneio))
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_QTDVOL := (PD1->PD1_QTDVOL + paCols[gdVolum])
		PD1->PD1_PLIQ   := (PD1->PD1_PLIQ + paCols[gdPesL])
		PD1->PD1_PBRUTO := (PD1->PD1_PBRUTO + paCols[gdPesBr])
		PD1->PD1_STATUS := "0"
		PD1->(MsUnLock())
	EndIf

	PD2->(RecLock("PD2",.T.))
	PD2->PD2_FILIAL := xFilial("PD2")
	PD2->PD2_STATUS := "0"
	PD2->PD2_CODROM := cRomaneio
	PD2->PD2_NFS    := paCols[gdDocum]
	//-------------------------------------------------------------------------------------------//
	//FR - 22/05/2023 - Flávia Rocha - SIGAMAT CONSULTORIA
	//Correção para considerar notas de quaisquer série, pois estava fixa a série: '001'
	//as notas do Mercado Livre são série 003
	//PD2->PD2_SERIES := '001'
	//-------------------------------------------------------------------------------------------//
	PD2->PD2_SERIES := paCols[gdSerie]
	PD2->PD2_CLIENT := paCols[gdClie]
	PD2->PD2_LOJCLI := paCols[gdLoja]
	PD2->PD2_REGIAO := paCols[gdZona]
	PD2->PD2_QTDVOL := paCols[gdVolum]
	PD2->PD2_PLIQ   := paCols[gdPesL]
	PD2->PD2_PBRUTO := paCols[gdPesBr]
	PD2->(MsUnLock())

	// If SA1->(DbSeek(xFilial("SA1")+PD2->(PD2_CLIENT+PD2_LOJCLI)))
	// 	U_STFAT340("4","T",.T.)
	// 	U_STFAT340("1","T",.T.)
	// EndIf

	//Flag de controle de romaneio nas notas selecionadas:
	If SF2->(DbSeek(xFilial("SF2")+PD2->(PD2_NFS+PD2_SERIES)))
		SF2->(RecLock("SF2",.F.))
		SF2->F2_XCODROM := cRomaneio
		SF2->F2_XPLACA	:= PD1->PD1_PLACA
		SF2->(MsUnLock())

		//Atualiza Placa no SC5
		If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
			While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

				If aScan(aPedido,{|a|a == SD2->D2_PEDIDO}) > 0
					SD2->(DbSkip())
					Loop
				Else
					aAdd(aPedido,SD2->D2_PEDIDO)
				EndIf

				If SC5->(DbSeek(xFilial("SC5")+PADR(SD2->D2_PEDIDO,TamSx3("C5_NUM")[1])))
					SC5->(RecLock("SC5",.F.))
					SC5->C5_XPLACA	:= PD1->PD1_PLACA
					SC5->(MsUnLock())

					If AllTrim(SC5->C5_XORIG)=="2"

						DbSelectArea("Z76")
						Z76->(DbSetOrder(1)) //Z76_FILIAL+Z76_PEDPAI+Z76_PEDFIL
						DbSelectArea("ZH2")
						ZH2->(DbSetOrder(3))

						Z76->(DbSeek(xFilial("Z76")+SC5->C5_XNUMWEB))
						While Z76->(!Eof()) .And. Z76->(Z76_FILIAL+Z76_PEDPAI)==xFilial("Z76")+SC5->C5_XNUMWEB

							If !ZH2->(DbSeek(xFilial("ZH2")+Z76->Z76_PEDFIL+"3"))
								ZH2->(RecLock("ZH2",.T.))
								ZH2->ZH2_FILIAL := xFilial("ZH2")
								ZH2->ZH2_DTINS	:= Date()
								ZH2->ZH2_HRINS  := Time()
								ZH2->ZH2_TIPO 	:= "3"
								ZH2->ZH2_PEDMKP	:= Z76->Z76_PEDFIL
								ZH2->ZH2_PEDERP := SC5->C5_NUM
								ZH2->ZH2_DOC	:= SF2->F2_DOC
								ZH2->ZH2_SERIE	:= SF2->F2_SERIE
								ZH2->(MsUnLock())
							EndIf

							Z76->(DbSkip())
						EndDo

					EndIf

				EndIf
				SD2->(DbSkip())
			EndDo
		EndIf
	Endif
	DBCOMMITALL()

	STFSF60C(PD1->PD1_CODROM,,PD2->PD2_NFS,PD2->PD2_SERIES) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)

	// Carrega com as informações do romaneio
	vldVei02(PD1->PD1_PLACA, ,.f.)

Return

/* {Protheus.doc} Function RemTabPD1
Description
Rotina para remover Romaneio
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 12/11/2019
@type 
*/
Static Function RemTabPD1(paVetor5)
	Local aPedido  := {}
	Local aAreaRem := GetArea()
	Local lRET     := .T.
	Local cMsgRom  := ""

	CB7->(DbSetOrder(4))
	SF2->(DbSetOrder(1))
	SD2->(DbSetOrder(3))
	SC5->(DbSetOrder(1))
	PD1->( dbSetOrder(1) )
	PD2->( dbSetOrder(1) )

	If PD1->(DbSeek(xFilial("PD1")+cRomaneio))

		If SF2->(DbSeek(xFilial("SF2")+paVetor5[2]+paVetor5[3]))

			// Valido se a nota está em condições de ser removida - Valdemir Rabelo 11/06/2020
			PD2->( dbSetOrder(1) )
			if PD2->( dbSeek(xFilial("PD2")+cRomaneio+SF2->(F2_DOC+F2_SERIE) ) )
				IF PD2->PD2_STATUS != "0"
					if PD2->PD2_STATUS=='2'
						cMsgRom := "Status da nota: "+SF2->F2_DOC+" no romaneio: "+cRomaneio+" é 'Fechado'"
					elseif PD2->PD2_STATUS=='1'
						cMsgRom := "Status da nota: "+SF2->F2_DOC+" no romaneio: "+cRomaneio+" é 'Andamento'"
					endif
					if !Empty(cMsgRom)   // Valdemir Rabelo 04/09/2020 Chamado: 20200904006922
						lRET := .F.
						FWMsgRun(,{|| Sleep(4500) },"Atenção!", cMsgRom)
						Return lRET
					Endif
				Endif
			Endif

			//Atualiza Placa no SC5
			If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
				While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

					If aScan(aPedido,{|a|a == SD2->D2_PEDIDO}) > 0
						SD2->(DbSkip())
						Loop
					Else
						aAdd(aPedido,SD2->D2_PEDIDO)
					EndIf

					If SC5->(DbSeek(xFilial("SC5")+PADR(SD2->D2_PEDIDO,TamSx3("C5_NUM")[1])))
						SC5->(RecLock("SC5",.F.))
						SC5->C5_XPLACA	:= ""              // Removo a referencia
						SC5->(MsUnLock())
					EndIf
					SD2->(DbSkip())
				EndDo
				// Desmaraca cabeçalho - Removo a Referência
				SF2->(RecLock("SF2",.F.))
				SF2->F2_XCODROM := ""
				SF2->F2_XPLACA	:= ""
				SF2->(MsUnLock())

				PD2->( dbSetOrder(1) )
				if PD2->( dbSeek(xFilial("PD2")+cRomaneio+SF2->(F2_DOC+F2_SERIE) ) )
					RecLock("PD2",.F.)
					PD2->( dbDelete() )
					MsUnlock()
				endif

			EndIf

			// Valdemir Rabelo 09/11/2021 - Ticket: 20210804014755
			dbSelectArea("CB9")
			dbSetOrder(1)

			// Atualiza CB7 22-01/2020
			//>> Ticket 20200731004956 - Everson Satnana - 18.08.2020 -
			dbSelectArea("CB7")
			dbSetOrder(4)
			if dbSeek(XFilial("CB7")+SF2->(F2_DOC+F2_SERIE) )
			
				// Valdemir Rabelo 09/11/2021 - Ticket: 20210804014755
				IF CB9->( dbSeek(xFilial('CB9')+CB7->CB7_ORDSEP))
				   WHILE CB9->( !EOF() ) .AND. (CB9->CB9_ORDSEP==CB7->CB7_ORDSEP)
				      if CB9->CB9_STATUS=="3"
					     RecLock("CB9",.F.)
						 CB9->CB9_STATUS := "2"
						 MsUnlock()
					  endif 
				      CB9->( dbSkip() )
				   ENDDO 
				ENDIF 
				// ---------------
				If CB7->CB7_STATUS $ ('8#9')
					RecLock("CB7",.f.)
					CB7->CB7_STATUS := "4"//cValToChar(Val(CB7->CB7_STATUS)-1) Volto o status para embalagem finalizada quando o embarque já foi realizado e por algum motivo precisa ser romaneado novamente.
					MsUnlock()
				EndIf

			else
				MSGINFO( "Não encontrou a Nota: "+SF2->F2_DOC+" na tabela: CB7"+CRLF+;
					"status não alterado. Registro não constará na lista de seleção,"+CRLF+;
					"informe o setor de TI", "Atenção!" )
			endif
			//<<
			// Desmaraca cabeçalho - Removo a Referência - Valdemir Rabelo 08/04/2022 -  20220315005852
			if !Empty(SF2->F2_XCODROM)
				SF2->(RecLock("SF2",.F.))
				SF2->F2_XCODROM := ""
				SF2->F2_XPLACA	:= ""
				SF2->(MsUnLock())
			Endif 

		Endif

	Endif

	RestArea( aAreaRem )

	STFSF60C(PD1->PD1_CODROM,,PD2->PD2_NFS,PD2->PD2_SERIES) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)

Return lRET

/* {Protheus.doc} Function CriaRoma
Description
Rotina para Criar Romaneio
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 12/11/2019
@type 
*/
Static Function CriaRoma(pPlaca)
	Local aParam	  := {}
	Local aConfig	  := {}
	Local nX
	Local aPedido	  := {}
	Local aAreaPD1	  := {}
	Local nHandle     := 0

	Private	_xMotoris
	Private	_xAjudan1
	Private	_xAjudan2
	Private	_xVeiculo
	Private	_xModelo
	Private	_xDtEntre
	Private	_xTipoRom
	Private	_xObserv
	Private	_xRota
	Private	_xPeriodo

	LimpDados()

	aAdd(aParam,{1,"Dt Entrega:"	,STOD(" ")						,"@D","","","",60,.T.})
	aAdd(aParam,{3,"Período:"	    ,1,{"Manhã", "Tarde","Integral","Extra"},50,.T.,.T.})
	aAdd(aParam,{1,"Motorista:"		,Space(TamSx3("PD1_MOTORI")[1]+10)	,"@!",".T.","DA4MOT","",90,.T.})
	aAdd(aParam,{1,"Ajudante1:"		,Space(TamSx3("PD1_AJUDA1")[1]+10)	,"@!",".T.","DAUST2","",90,.T.})
	aAdd(aParam,{1,"Ajudante2:"		,Space(TamSx3("PD1_AJUDA2")[1]+10)	,"@!","u_gVldCPO('PD1_AJUDA2','MV_PAR03')","DAUST3","",90,.F.})
	aAdd(aParam,{1,"Placa Veiculo:"	,pPlaca	    ,"@!","u_vldVei01()","DA304","",60,.T.})

	aAdd(aParam,{1,"Modelo:"	,Space(TamSx3("DA3_DESC")[1])	,"@!","","",".F.",90,.T.})

	aAdd(aParam,{3,"Tipo Romaneio:"	,1,{"Entrega","Retira"},50,.T.,.T.})
	aAdd(aParam,{1,"Observação:"	,Space(200)						,"@!","","","",200,.T.})
	aAdd(aParam,{1,"Rota:"			,Space(TamSx3("X5_CHAVE")[1])	,"@!","","SZN","",90,.T.})

	If !ParamBox(aParam,"Romaneio",aConfig, {|| VLDINFOS()},,.F.,90,15)
		nHandle := oVeiGet:hWHandle()
		oVeiGet:SetFocus(nHandle)
		Return ""
	EndIf

	cCodRom := PD1->(GetSX8Num("PD1","PD1_CODROM"))
	ConfirmSX8()

	_xDtEntre := MV_PAR01
	_xPeriodo := MV_PAR02
	_xMotoris := MV_PAR03
	_xAjudan1 := MV_PAR04
	_xAjudan2 := MV_PAR05
	_xVeiculo := MV_PAR06
	_xModelo  := MV_PAR07
	_xTipoRom := MV_PAR08
	_xObserv  := MV_PAR09
	_xRota    := MV_PAR10

	PD1->(RecLock("PD1",.T.))
	PD1->PD1_FILIAL := xFilial("PD1")
	PD1->PD1_CODROM := cCodRom
	PD1->PD1_DTEMIS := dDataBase
	PD1->PD1_QTDVOL := nQtdVols
	PD1->PD1_PLIQ   := nPLiquido
	PD1->PD1_PBRUTO := nPBrutoE
	PD1->PD1_STATUS := "0"

	PD1->PD1_MOTORI	:= _cNomMot
	PD1->PD1_AJUDA1	:= _cNomAj1
	PD1->PD1_AJUDA2	:= _cNomAj2
	PD1->PD1_USRMOT := _cUsrMot
	PD1->PD1_USRAJ1 := _cUsrAj1
	PD1->PD1_USRAJ2 := _cUsrAj2
	PD1->PD1_PLACA	:= _xVeiculo
	PD1->PD1_DTENT	:= _xDtEntre
	PD1->PD1_TPROM	:= AllTrim(STR(_xTipoRom))
	PD1->PD1_OBS	:= _xObserv
	PD1->PD1_XROTA	:= _xRota
	PD1->PD1_PERIOD := _xPeriodo
	PD1->PD1_HRROM	:= Substr(Time(),1,5)
	PD1->(MsUnLock())

	cRomaneio := cCodRom

	FWMsgRun(,{|| Sleep(3000)},"Informativo","Romaneio criado com sucesso")

	vldvei02(pPlaca, .F.,.F.)

Return cCodRom

Static Function AtuTotais()
	Local aAreaPD2 	  	:= GetArea()
	Local nNotas		:= 0
	Local nVols			:= 0
	Local nPesoL		:= 0
	Local nPesoB		:= 0
	Local nX

	nQtdVol	  := 0
	nPesLiq   := 0
	nPesBrt   := 0
	nCubagem  := 0
	nQtdNFRO  := 0
	nQtdCub   := 0

	// Calculando Notas a serem transferidas
	For nX := 1 to Len(aCols)
		if aCols[nX, 1]
			nQtdCub  += GetRetF2(aCols[nX][gdDocum],aCols[nX][gdSerie],aCols[nX][gdClie],aCols[nX][gdLoja],"F2_XCUBAGE")
			//nQtdCub  += GetRetF2(aCols[nX][NPOSDOC],aCols[nX][NPOSSERIE],aCols[nX][NPOSCLIENT],aCols[nX][NPOSLOJA],"F2_XCUBAGE")
			++nNotas
			if (ValType(aCols[nX,gdVolum]) == "N")
				nVols  += aCols[nX,gdVolum]
				nPesoL += aCols[nX,gdPesL]
				nPesoB += aCols[nX,gdPesBr]
			endif 
		Endif
	Next

	nQtdNFS   := nNotas
	nQtdVols  := nVols
	nPBrutoE  := ROUND(nPesoB,3)
	nPLiquido := nPesoL

	if !Empty(cRomaneio)
		// Calculando Cubagem do Romaneio
		dbSelectArea("PD2")
		dbSetOrder(1)
		if dbSeek(XFilial('PD2')+cRomaneio)
			While !Eof() .and. (PD2->PD2_CODROM==cRomaneio)
				nQtdNFRO  += 1
				nQtdVol	  += PD2->PD2_QTDVOL
				nPesLiq   += PD2->PD2_PLIQ
				nPesBrt   += PD2->PD2_PBRUTO
				nCubagem  += GetRetF2(PD2->PD2_NFS,PD2->PD2_SERIES,PD2->PD2_CLIENT,PD2->PD2_LOJCLI,"F2_XCUBAGE")
				dbSkip()
			EndDo
		Endif
		if nCubagem > 0					// Valdemir Rabelo 05/02/2020
			nCubagem  += nQtdCub
		Endif
		nPesBrt  += nPesoB
		nPesLiq  += nPesoL
		nQtdVol  += nVols
		nQtdNFRO += nNotas
	Endif

	RestArea( aAreaPD2 )

	oQtdCub:Refresh()
	oQtdVols:Refresh()
	oPBrutoE:Refresh()
	oChk5:Refresh()
	oQtdNFS:Refresh()
	if oCubage != nil; oCubage:Refresh(); endif
		oDlg:Refresh()

		Return .T.

		//--------------------------------------------------------------
	/*/{Protheus.doc} Function TimeBlink
		Description
		Rotina para apresentar intermitencia no objeto de cubage
		@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
		@since 13/11/2019
		@type
	/*/
//--------------------------------------------------------------
Static Function TimeBlink()
	Local lMaior    := (!VldCubag())
	Local lPesMaior := (nPesVei <= nPesBrt)
	Local lRodz     := .f.

	if ValType(cDtEnt) == "C"
		cDtEnt := ctod(cDtEnt)
	endif

	lRodz  := if(!Empty(cDtEnt), (!gVldRod(cDtEnt, .T.)), .F.)

	cMsgRodiz := ""
	if !Empty(cRomaneio)
		if lMaior
			oCubage:NCLRTEXT := CLR_RED
			If lPisca
				lPisca := .f.
				oCubage:Hide()
			Else
				lPisca := .t.
				oCubage:Show()
			EndIf
		else
			lPisca := .f.
			oCubage:NCLRTEXT := 16711680
			oCubage:Show()
		Endif
		if lPesMaior
			oPesoBrt:NCLRTEXT := CLR_RED
			If lPiscaB
				lPiscaB := .f.
				oPesoBrt:Hide()
			Else
				lPiscaB := .t.
				oPesoBrt:Show()
			EndIf
		else
			lPiscaB := .f.
			oPesoBrt:NCLRTEXT := 16711680
			oPesoBrt:Show()
		endif
		oCubage:Refresh()
		// Verifico Rodizio
		if lRodz
			cMsgRodiz := "<< Veículo em dia de rodizio >>"
			oRodizio:Refresh()
			If lPisRod
				lPisRod := .f.
				oRodizio:Hide()
			Else
				lPisRod := .t.
				oRodizio:Show()
			EndIf
		endif

	else
		oCubage:NCLRTEXT  := 16711680
		oPesoBrt:NCLRTEXT := 16711680
	Endif

Return .T.

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function VldCubag
	Description
	Rotina para validar cubagem com base na porcentagem informada
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function VldCubag(plMsg)
	Local nCUBDA3 := nCubVei
	Local nPerCub := SuperGetMV("ST_PERCUB",.F.,20)   // Valdemir Rabelo 23/08/2019
	Local lRET    := .T.
	Local _cMsg   := "A cubagem ultrapassou o limite dos <font color='red'><b> "+cValToChar(nPerCub)+"%.</font></b> Verifique por favor."

	Default plMsg := .F.

	if nCUBDA3 > 0
		nCUBDA3 := nCUBDA3-(nCUBDA3*nPerCub/100)
		lRET    := (nCubagem <= nCUBDA3)
	Endif

	if !lRET
		if plMsg
			MsgInfo(_cMsg,"Atenção!")
		Endif
	Endif
	// Valdemir Rabelo 06/02/2020
	IF nPesVei > 0
		_cMsg   := "O peso bruto ultrapassou o limite dos <font color='red'><b> "+cValToChar(nPesVei)+".</font></b> Verifique por favor."
		if (nPesBrt > nPesVei)
			if plMsg
				MsgInfo(_cMsg,"Atenção!")
			Endif
		Endif
	Endif

Return lRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function LimpDados
	Description
	Rotina para limpar os objetos
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function LimpDados()
	Local nHandle := oVeiGet:hWHandle()
	cVeiculo  := Space(TamSX3("DA3_COD")[1])
	cRomaneio := CriaVar("PD1_CODROM")
	cMotorista:= CriaVar("PD1_MOTORI")
	cEmissao  := CriaVar("PD1_DTEMIS")
	cDtEnt    := CriaVar("PD1_DTENT")
	cAjudant  := CriaVar("PD1_AJUDA1")
	cDescVei  := CriaVar("DA3_DESC")
	nCubVei   := 0
	nPesVei   := 0					// Valdemir Rabelo 06/02/2020
	nCubPer   := 0
	aVetor5   := {}
	cMsgRodiz := ""
	nCubagem  := 0
	nQtdVols  := 0
	nPBrutoE   := 0
	nPLiquido := 0
	aVetor5   := {{.F.,'','','','','','',0,0,0}}
	AtuTotais()
	oVeiGet:SetFocus(nHandle)
	AtuLbx5(oLbx5)				// Valdemir Rabelo 27/07/2020
	oDlg:Refresh()
Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function ImpLoteR
	Description
	Rotina para realizar impressão por lote
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function ImpLoteR()
	Local lFiltra := (!Empty(cRomaneio))
	FWMsgRun(,{|| u_STFSF60B(cRomaneio, lFiltra)},"Informativo","Aguarde, carregando registros do romaneio")
Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function PrepRote
	Description
	Rotina para preparar roteirização
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function PrepRote()
	Local nX       := 0
	Local cCEP     := ""
	Local aGrvRot  := {}
	Local aAreaCEP := GetArea()
	Local lGrv     := .F.
	Local nUltCol  := 0
	Local nPosTMP  := 0

	SD2->(DbSetOrder(3))
	SC5->(DbSetOrder(1))

	aPrepRot := {}
	if Len(aVetor5) > 0
		nUltCol := Len(aVetor5[1])
	Endif
	ProcRegua(Len(aVetor5)*2)
	For nX := 1 to Len(aVetor5)
		IncProc()

		SD2->(DbSeek(xFilial("SD2")+aVetor5[nX][2]+aVetor5[nX][3]+aVetor5[nX][4]+aVetor5[nX][5]))
		SC5->(DbSeek(xFilial("SC5")+PADR(SD2->D2_PEDIDO,TamSx3("C5_NUM")[1])))

		cCEP := U_STTNT011()[1,1] 				//u_StCepReg(aVetor5[nX][2],aVetor5[nX][3],' ')
		aAdd(aPrepRot, {aVetor5[nX][2], aVetor5[nX][3], cCEP, "","",0})
	Next
	if Len(aPrepRot) > 0
		dbSelectArea("PD2")
		PD2->( dbSetOrder(2) )
		aGrvRot := u_stfat280(aPrepRot)
		For nX := 1 to Len(aGrvRot)
			IncProc()
			IF aGrvRot[nX][6] > 0
				if PD2->( dbSeek(XFilial("PD2")+aGrvRot[nX][1]+aGrvRot[nX][2]) )
					RecLock("PD2",.F.)
					PD2->PD2_ORDROT := aGrvRot[nX][6]
					MsUnlock()
					// Valdemir Rabelo 12/02/2020
					nPosTMP  := aScan(aVetor5, {|X| X[2]+X[3]==aGrvRot[nX][1]+aGrvRot[nX][2]})
					if nPosTMP > 0
						aVetor5[nPosTMP][nUltCol] := aGrvRot[nX][6]
					Endif
					lGrv     := .T.
				Endif
			Endif
		Next
	endif

	aSort(aVetor5,,,{|x,y| x[nUltCol] < y[nUltCol] })
	oLbx5:Refresh()
	if lGrv
		FWMsgRun(,{|| Sleep(3000)},"Informativo","Roteirização realizado com sucesso")
	Endif

Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function MntQtdNF
	Description
	Rotina para montagem de query para apresentar quantidade de NF
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function MntQtdNF()
	Local cRET := ""

	cRET += "SELECT COUNT(*)  " + CRLF
	cRET += "FROM  " + RETSQLNAME("PD1") + " A " + CRLF
	cRET += "INNER JOIN  " + RETSQLNAME("PD2") + " B   " + CRLF
	cRET += "ON B.PD2_CODROM=A.PD1_CODROM AND B.D_E_L_E_T_ = ' '  " + CRLF
	cRET += "WHERE A.D_E_L_E_T_ = ' '   " + CRLF
	cRET += " AND A.PD1_FILIAL=PAI.DA3_FILIAL AND A.PD1_PLACA = PAI.DA3_COD  " + CRLF
	cRET += "	AND A.PD1_STATUS <> '3'  " + CRLF

Return cRET

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function AtuaList
	Description
	Rotina para atualizar a List principal
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function AtuaList(aVetor1,aVetor2,aVetor3,aVetor4)
	Local xs
	Local ix
	Local nPos 	:= 0

	_aColsOld := aClone(aDadosGer)
	aCols     := aClone(aDadosGer)

	aEVal(aCols,   {|X| X[1] := .T. })
	aEval(aVetor1, {|X| X[3] := 0, X[4] := 0})
	aEval(aVetor2, {|X| X[3] := 0, X[4] := 0})
	aEval(aVetor3, {|X| X[3] := 0, X[4] := 0})

	For xs=1 To Len(_aColsOld)
		// Vetor -> Zona
		nPos := aScan(aVetor1, { |x| UPPER(x[2])=="PENDENTE"} )
		if nPos==0
			AADD(aVetor1,{.F., "PENDENTE", 0, 0})
		endif
		nPos := aScan(aVetor1, { |x| UPPER(x[2])=="PENDENTE"} )
		If !Empty(_aColsOld[xs,nPosGUIA])
			aVetor1[nPos][3] += 1							  // Qtde.Notas
			aVetor1[nPos][4] += _aColsOld[xs,nPosPBru]        // Peso Bruto
		else
			if !Empty(_aColsOld[xs,09])
				nPos := aScan(aVetor1, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[xs,09])})   // nPosZona
				If nPos == 0
					// Colunas:    1-Selecione, 2-Zona, 3-Qtde.NF, 4-Peso Bruto
					AADD(aVetor1,{.T.,ALLTRIM(_aColsOld[xs,09]), 1, _aColsOld[xs,nPosPBru]})
				else
					aVetor1[nPos][3] += 1							  // Qtde.Notas
					aVetor1[nPos][4] += _aColsOld[xs,nPosPBru]        // Peso Bruto
				EndIf
			else
				nPos := aScan(aVetor1, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[xs,09])})    // 18
				If nPos == 0
					AADD(aVetor1,{.T.,ALLTRIM(_aColsOld[xs,09]), 1, _aColsOld[xs,nPosPBru]})    // 18
				else
					aVetor1[nPos][3] += 1						// Qtde.Notas
					aVetor1[nPos][4] += _aColsOld[xs,nPosPBru]      // Peso Bruto
				EndIf
			Endif
		Endif
		nVetor1 := nPos
		if nVetor1 > 0
			// Vetor2 -> CEP
			if aVetor1[nVetor1][1]
				nPos := aScan(aVetor2, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[xs,nPosCEP])})
				If nPos == 0
					AADD(aVetor2,{.T.,ALLTRIM(_aColsOld[xs,nPosCEP]), 1, _aColsOld[xs,nPosPBru]})
				Else
					aVetor2[nPos][3] += 1						// Qtde.Notas
					aVetor2[nPos][4] += _aColsOld[xs,nPosPBru]      // Peso Bruto
				EndIf
			Endif
			if aVetor1[nVetor1][1]

				// Vetor3 -> Transportadora
				nPos := aScan(aVetor3, {|x| Alltrim(x[2]) == ALLTRIM(_aColsOld[xs,NPOSTRANSP])})
				If nPos == 0
					AADD(aVetor3,{.T.,ALLTRIM(_aColsOld[xs,NPOSTRANSP]), 1, _aColsOld[xs,nPosPBru]})
				Else
					aVetor3[nPos][3] += 1						    // Qtde.Notas
					aVetor3[nPos][4] += _aColsOld[xs,nPosPBru]      // Peso Bruto
				EndIf
			Endif
		Endif
	Next xs

	if Len(aVetor1)=0
	   AADD(aVetor1,{.F.,"", 0, ""})
	endif
	if Len(aVetor2)=0
	   AADD(aVetor2,{.F.,"", 0, ""})
	endif 
	if Len(aVetor3)=0
	   AADD(aVetor3,{.F.,"", 0, ""})
	endif 

	aSort(aVetor1,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor2,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor3,,,{|x,y| x[2] < y[2]  })

	if Len(aVetor4)=0
		AADD(aVetor4,{.T.,'CIF'})
		AADD(aVetor4,{.T.,'FOB'})
	Endif

	if oGetD != nil
		AtuaBrow()
		oDlg:Refresh()
	Endif

Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function SelSelecao
	Description
	Rotina para atualizar os list de seleção referente aos filtros
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function SelSelecao(aVetor1,aVetor2,aVetor3)
	Local xs
	Local ix
	Local nPos 	:= 0

	aVetor2 := {}
	aVetor3 := {}

	_aColsOld := aClone(aDadosGer)
	aCols     := aClone(aDadosGer)
	aEVal(aCols, {|X| X[1] := .T. })

	For xs := 1 to Len(aVetor1)
		if aVetor1[xs, 1]
			_GetCEP(aVetor1[xs],@aVetor2,_aColsOld)
			_GetTRA(aVetor1[xs],aVetor2, @aVetor3,_aColsOld)
		endif
	next

	aSort(aVetor1,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor2,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor3,,,{|x,y| x[2] < y[2]  })

	// Atualiza os ListBox
	AtuaLbx()
Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function _GetCEP
	Description
	Rotina para montar os ceps com base na seleção da zona
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function _GetCEP(aVetor1, aVetor2, _aColsOld)
	Local nX   := 0
	Local nPos := 0

	For nX := 1 to Len(_aColsOld)
		if (aVetor1[2] == ALLTRIM(_aColsOld[nX,nPosRegiao]))   // nPosZona
			nPos := aScan(aVetor2, {|x| x[2] == ALLTRIM(_aColsOld[nX,nPosCEP])})
			If nPos == 0
				AADD(aVetor2,{.T.,ALLTRIM(_aColsOld[nX,nPosCEP]), 1, _aColsOld[nX,nPosPBru]})
			Else
				aVetor2[nPos][3] += 1							// Qtde.Notas
				aVetor2[nPos][4] += _aColsOld[nX,nPosPBru]      // Peso Bruto
			EndIf
		Endif
	Next

Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function _GetTRA
	Description
	Rotina para montar o listbox da transportadora, com base na zona e cep
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function _GetTRA(aVetor1, aVetor2, aVetor3,_aColsOld)
	Local nX   := 0
	Local nPos := 0
	Local nY   := 0

	For nX := 1 to Len(_aColsOld)
		if (aVetor1[2] == ALLTRIM(_aColsOld[nX,nPosRegiao]))			// Verifico se faz parte da Zona - nPosZona
			For nY := 1 to Len(aVetor2)
				if aVetor2[nY][1]
					if aVetor2[nY][2]== ALLTRIM(_aColsOld[nX,nPosCEP])
						nPos := aScan(aVetor3, {|x| x[2] == ALLTRIM(_aColsOld[nX,NPOSTRANSP])})
						If nPos == 0
							AADD(aVetor3,{.T.,ALLTRIM(_aColsOld[nX,NPOSTRANSP]), 1, _aColsOld[nX,NPOSPBRU]})
						Else
							aVetor3[nPos][3] += 1							// Qtde.Notas
							aVetor3[nPos][4] += _aColsOld[nX,NPOSPBRU]      // Peso Bruto
						Endif
					EndIf
				Endif
			Next

		Endif
	Next

Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function AtuaLbx
	Description
	Rotina para atualizar todos os lists de seleção, ja dando refresh
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 27/11/2019
	@type
	/*/
//--------------------------------------------------------------
Static Function AtuaLbx()
	// Atualiza Zona
	oLbx:SetArray( aVetor1 )
	oLbx:bLine := {|| {Iif(	aVetor1[oLbx:nAt,1],oOk,oNo),;
		aVetor1[oLbx:nAt,2],;
		aVetor1[oLbx:nAt,3],;
		aVetor1[oLbx:nAt,4];
		}}
	oLbx:Refresh()
	// Atualiza CEP
	oLbx2:SetArray( aVetor2 )
	oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
		aVetor2[oLbx2:nAt,2],;
		aVetor2[oLbx2:nAt,3],;
		aVetor2[oLbx2:nAt,4];
		}}
	oLbx2:Refresh()
	// Atualiza Transportadora
	oLbx3:SetArray( aVetor3 )
	oLbx3:bLine := {|| {Iif(	aVetor3[oLbx3:nAt,1],oOk,oNo),;
		aVetor3[oLbx3:nAt,2],;
		aVetor3[oLbx3:nAt,3],;
		aVetor3[oLbx3:nAt,4];
		}}
	oLbx3:Refresh()
	oLbx4:Refresh()
	oLbx5:Refresh()
Return

	//--------------------------------------------------------------
	/*/{Protheus.doc} Function MsgCliente
	Description
	Mostrar msg de cliente
	@author Renato Nogueira
	@since 03/12/2019
	@type
	/*/
//--------------------------------------------------------------

Static Function MsgCliente()

	//20190507000024
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+aCols[oGetD:nAt,6]+aCols[oGetD:nAt,7]))
		If AllTrim(SA1->A1_XTPBLOQ)=="1" .And. !Empty(SA1->A1_XMSBLQ)
			MsgAlert(AllTrim(SA1->A1_XMSBLQ))
		EndIf
	EndIf

Return()

//Insere observação na nota
Static Function InsObs()

	Local _aArea		:= GetArea()
	Local aParam		:= {}
	Local aConfig		:= {}
	Local _cEmail 		:= ""
	Local _cCopia		:= ""
	Local _cAssunto		:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local cMsg			:= ''
	Local nX            := 0

	If !__cUserId $ SuperGetMV("ST_OBSROMA",,"000000/001177")
		MsgAlert("Atenção, seu usuário não tem permissão para inserir observação")
		Return
	EndIf

	aAdd(aParam,{1,"Observação:"	,Space(80)						,"@!","","","",80,.T.})

	If ParamBox(aParam,"Observação",aConfig,,,.F.,90,15)

		For nX:=1 to Len(aCols)

			IF aCols[nX,1]

				DbSelectArea("SF2")
				SF2->(DbSetOrder(1))
				SF2->(DbGoTop())
				If SF2->(DbSeek(xFilial("SF2")+aCols[nX,NPOSDOC]+'001'))
					SF2->(RecLock("SF2",.F.))
					SF2->F2_XOBSROM	:= aConfig[1]
					SF2->F2_XDTOBSR := dDATABASE		// Valdemir Rabelo 22/01/2020
					SF2->(MsUnLock())

					aCols[oGetD:nat][NPOSDTATUOBS] := DTOC(dDATABASE)			// Valdemir Rabelo 22/01/2020
					aCols[oGetD:nat][NPOSOBS]      := aConfig[1]				// Valdemir Rabelo 28/01/2020

					_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_EMAIL"))
					If Empty(_cEmail)
						_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_EMAIL"))
					EndIf
					_cAssunto	:= "Pendência para embarque no CD - NF "+AllTrim(SF2->F2_DOC)

					cMsg := '<html><head><title></title></head><body>'
					cMsg += '<b>Observação: </b>'+Alltrim(SF2->F2_XOBSROM)
					cMsg += '<br><b>Cod. Cliente:</b>'+SF2->F2_CLIENTE
					cMsg += '<br><b>Cliente:</b>'+Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME")
					cMsg += '<br><b>Pedido:</b>'+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO")
					cMsg += '<br><b>Transportadora:</b>'+SF2->F2_TRANSP+" - "+Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_NOME")
					cMsg += '<br><b>Tp. Entrega:</b>'+IIf(Posicione("SC5",1,SF2->F2_FILIAL+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XTIPO")=="1","Retira","Entrega")
					cMsg += '<br><b>Dt Emissão:</b>'+DTOC(SF2->F2_EMISSAO)
					//>>Ticket 20200709004018 - Everson Santana - 21.07.2020
					cMsg += '<br><b>Ordem Compra:</b>'+Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XORDEM")
					cMsg += '<br><b>Qtd Volume:</b>'+Transform( SF2->F2_VOLUME1,"@E 9999")
					cMsg += '<br><b>Peso Bruto:</b>'+Transform( SF2->F2_PBRUTO,"@E 999,999,999.999")
					//<<Ticket 20200709004018
					cMsg += '</body></html>'

					_cCopia := GetMv("ST_MAIL001",,"francisco.smania@steck.com.br")

					// Ticket: 20210330005139
					If SA1->A1_COD $ "092887x014519x028358x023789x038134"
						_cCopia := Alltrim(_cCopia) + ";caroline.atouguia@steck.com.br"
					Endif

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

					MsgAlert("Observação inserida com sucesso! "+aCols[nX,NPOSDOC])
				Else
					MsgAlert("Documento não encontrado!")
				EndIf
			EndIf
		Next

	EndIf

	RestArea(_aArea)

Return

Static Function InsObsI(_cNf,_cSerie,oGetD)

	Local _aArea		:= GetArea()
	Local aParam		:= {}
	Local aConfig		:= {}
	Local _cEmail 		:= ""
	Local _cCopia		:= ""
	Local _cAssunto		:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local cMsg			:= ''

	If !__cUserId $ SuperGetMV("ST_OBSROMA",,"000000/001177")
		MsgAlert("Atenção, seu usuário não tem permissão para inserir observação")
		Return
	EndIf

	aAdd(aParam,{1,"Observação:"	,Space(80)						,"@!","","","",80,.T.})

	If ParamBox(aParam,"Observação",aConfig,,,.F.,90,15)

		DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		SF2->(DbGoTop())
		If SF2->(DbSeek(xFilial("SF2")+aCols[oGetD:nat,NPOSDOC]+'001'))

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XOBSROM	:= aConfig[1]			// Valdemir Rabelo 28/01/2020
			SF2->F2_XDTOBSR := dDATABASE			// Valdemir Rabelo 22/01/2020
			SF2->(MsUnLock())

			aCols[oGetD:nat][NPOSDTATUOBS] := DTOC(dDATABASE)
			aCols[oGetD:nat][NPOSOBS]      := aConfig[1]

			_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_EMAIL"))
			If Empty(_cEmail)
				_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_EMAIL"))
			EndIf
			_cAssunto	:= "Pendência para embarque no CD - NF "+AllTrim(SF2->F2_DOC)

			cMsg := '<html><head><title></title></head><body>'
			cMsg += '<b>Observação: </b>'+Alltrim(SF2->F2_XOBSROM)
			cMsg += '<br><b>Cod. Cliente:</b>'+SF2->F2_CLIENTE
			cMsg += '<br><b>Cliente:</b>'+Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME")
			cMsg += '<br><b>Pedido:</b>'+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO")
			cMsg += '<br><b>Transportadora:</b>'+SF2->F2_TRANSP+" - "+Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_NOME")
			cMsg += '<br><b>Tp. Entrega:</b>'+IIf(Posicione("SC5",1,SF2->F2_FILIAL+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XTIPO")=="1","Retira","Entrega")
			cMsg += '<br><b>Dt Emissão:</b>'+DTOC(SF2->F2_EMISSAO)
			//>>Ticket 20200709004018 - Everson Santana - 21.07.2020
			cMsg += '<br><b>Ordem Compra:</b>'+Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XORDEM")
			cMsg += '<br><b>Qtd Volume:</b>'+Transform( SF2->F2_VOLUME1,"@E 9999")
			cMsg += '<br><b>Peso Bruto:</b>'+Transform( SF2->F2_PBRUTO,"@E 999,999,999.999")
			//<<Ticket 20200709004018
			cMsg += '</body></html>'

			_cCopia := GetMv("ST_MAIL001",,"francisco.smania@steck.com.br")

			// Ticket: 20210330005139
			If SA1->A1_COD $ "092887x014519x028358x023789x038134"
				_cCopia := Alltrim(_cCopia) + ";caroline.atouguia@steck.com.br"
			Endif

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			MsgAlert("Observação inserida com sucesso! "+aCols[oGetD:nat,NPOSDOC])
		Else
			MsgAlert("Documento não encontrado!")
		EndIf

	EndIf

	RestArea(_aArea)

Return

/*/{Protheus.doc} GetRomOpen
(long_description)
Rotina irá apresentar os romaneios que estão abertos
@type  Static Function
@author user
Valdemir José Rabelo
@since date
20/01/2020
@version version
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
@type 
/*/
Static Function GetRomOpen(pPlaca)
	Local aAreaZ   := GetArea()
	Local cQry     := ""
	Local nRetCol := 1			// Coluna que fará o retorno
	Local aCampos  := {  {"Romaneio","Qtd.Vol", "Peso Bruto","Período"},;
		{"PD1_CODROM","PD1_QTDVOL", "PD1_PBRUTO","PERIODO"} }

	Default pPlaca   := ""

	cQry := "SELECT PD1_CODROM, PD1_QTDVOL, PD1_PBRUTO, " + CRLF
	cQry += "CASE PD1_PERIOD     " + CRLF
	cQry += "WHEN 1 THEN 'MANHÃ' " + CRLF
	cQry += "WHEN 2 THEN 'TARDE' " + CRLF
	cQry += "WHEN 3 THEN 'NOITE' " + CRLF
	cQry += "WHEN 4 THEN 'EXTRA' " + CRLF
	cQry += "ELSE ' ' " + CRLF
	cQry += "END AS PERIODO, " + CRLF
	cQry += "R_E_C_N_O_ REG  " + CRLF
	cQry += "FROM " + RETSQLNAME('PD1') + " PD1 " + CRLF
	cQry += "WHERE PD1.D_E_L_E_T_ = ' '			" + CRLF
	IF !EMPTY(pPlaca)
		cQry += " AND PD1.PD1_PLACA ='"+pPlaca+"'   " + CRLF
	ENDIF
	cQry += " AND PD1.PD1_STATUS <> '3'		    " + CRLF
	cQry += " AND PD1.PD1_FILIAL = '"+XFILIAL('PD1')+"' " + CRLF
	cQry += "ORDER BY PD1_CODROM" + CRLF

	U_BUSCAF3("PD1", aCampos, '', '', cQry, nRetCol)

	GetDRefresh()

	RestArea( aAreaZ )

Return .T.

Static Function LimpaCPO()

	if Empty(cVeiculo)
		cRomaneio := CriaVar("PD1_CODROM")
		cMotorista:= CriaVar("PD1_MOTORI")
		cEmissao  := CriaVar("PD1_DTEMIS")
		cDtEnt    := CriaVar("PD1_DTENT")
		cAjudant  := CriaVar("PD1_AJUDA1")
		cDescVei := CriaVar("DA3_DESC")
		nCubVei  := 0
		nPesVei  := 0					// Valdemir Rabelo 06/02/2020
		nCubPer  := 0
		aVetor5  := {}
		AtuLbx5(oLbx5)
		InfoNFS(oGetD,.t.)
	Endif

Return

/*/{Protheus.doc} PostExcel
(long_description)
Rotina exportar Notas Fiscais para Planilha Excel
@type  Static Function
@author user
Valdemir José Rabelo
@since date
20/02/2020
@version version
(examples)
@see (links_or_references)
@type 
/*/
Static Function PostExcel(aCols)
	Local _nX 		:= 0
	Local _nY 		:= 0
	Local aColsX    := aClone(aCols)
	Local aHeadX    := aClone(aHeadR)
	Local cSheet1	:=	"Pendentes"
	Local cTable	:=	"NOTAS FISCAIS PENDENTES"
	Local oExcel	:=	FWMSEXCEL():New()
	Local cPath		:=	"C:\TEMP"
	Local cCaminho	:=	""
	Local cArq		:=	"NOTAS_PENDENTES_"+Dtos(dDataBase)+"_"+StrTran(TIME(),":","")	+".xls"
	Local aAlgn 	:= {1,1,1,1,1,1,1,1,1,1,1,3,3,1,1,1,1}			// Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Local aForm 	:= {1,1,1,1,1,1,1,1,4,1,1,3,3,1,1,4,1}			// Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	Local nSelecao  := 0
	Local CompTit   := ""

	aEval(aVetor1, {|x| if(x[1],++nSelecao, 0) })

	if nSelecao == 0
		FWMsgRun(,{|| Sleep(3500)},"Atenção!","Para exportar precisa ser selecionado uma região")
		Return
	endif

	For _nX := 1 to Len(aVetor1)
		if aVetor1[_nX][1]
			if !Empty(CompTit)
				CompTit += "/"
			endif

			CompTit += aVetor1[_nX][2]
		Endif
	Next
	CompTit := " - ZONA [ "+CompTit+" ]"
	cTable += CompTit

	If !ExistDir(cPath)
		MakeDir(cPath)
	EndIf

	cCaminho	:=	cPath+"\"+cArq

	aEval(aColsX, {|X| aDel(x, 1), aDel(x, Len(x)), aDel(x, Len(x)) })
	aEval(aColsX, {|X| aDel(x, Len(x)) })
	aEval(aColsX, {|X| aDel(x, Len(x)) })
	aEval(aColsX, {|X| aSize(x, Len(x)-3)})

	aDel(aHeadX, 1)
	aSize(aHeadX, Len(aHeadX)-1)

	oExcel:AddworkSheet(cSheet1)

	oExcel:AddTable (cSheet1,cTable)

	// Carrega Cabecalho
	For _nX := 1 to Len(aHeadX)

		oExcel:AddColumn(cSheet1,cTable, aHeadX[_nX], aAlgn[_nX], aForm[_nX])
	Next

	For _nx := 1 to Len(aColsX)
		oExcel:AddRow(cSheet1,cTable, aColsX[_nx])
	Next

	oExcel:Activate()
	oExcel:GetXMLFile(cCaminho)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cCaminho)
	oExcelApp:SetVisible(.T.)

Return


/* {Protheus.doc} Function STFATRO1
Description
Rotina
@author
@since
@type 
*/

User Function STFATRO1()

	Local oDlgRO1
	Local cSeekPD2  := xFilial("PD1") + PD1->PD1_CODROM
	Local oGetD
	Local bDbClick
	Local oEnc
	Local nOpca     := 0
	Local cTitDlg   := "Romaneio de Transporte"
	Local aButtons  := {}

	Local aSize     := {}
	Local aInfo     := {}
	Local aObjects  := {}

	Private aHeader := {}
	Private aCols   := {}

	If PD1->PD1_STATUS == "3"  //Romaneio Encerramento
		MsgAlert("O romaneio " + PD1->PD1_CODROM+ " já está encerrado!!!",".:AVISO:.")
		Return
	ElseIf PD1->PD1_STATUS <> "2"   //Romaneio nao fechado
		MsgAlert("O romaneio não foi fechado, portanto não poderá ser encerrado!!!",".:AVISO:.")
		Return
	Endif

	If STFSF60ATU()
		MsgAlert("Para o encerramento é necessário preencher as informações da entrega!!!",".:AVISO:.")
		Return
	EndIf

	// Botoes especificos do EnchoiceBar:
	aadd(aButtons,{"PMSCOLOR",{||LegItens()},"Legenda" })
	//aadd(aButtons,{"autom",{||MarkDesm(oGetD,.F.)},"Marca/Desmarca","Todos" })
	RegToMemory("PD1")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSeek( "PD2" )
	Aadd( aHeader, {" ","MARKBROW","@BMP",2,0,"","","C","","" ,"","V","","V","S"} )
	Aadd( aHeader, {" ","MARKBROW","@BMP",2,0,"","","C","","" ,"","V","","V","S"} )
	While !Eof() .And. ( x3_arquivo == "PD2" )
		If X3USO(x3_usado) .And. cNivel >= x3_nivel .AND. !(AllTrim( x3_campo ) $ "PD2_CODROM|PD2_STATUS")
			AAdd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_f3, x3_context,x3_cbox,"","",x3_browse,""})
		EndIf
		dbSkip()
	EndDo

	MontaCols(cSeekPD2,,.t.)
	aSize   := MsAdvSize()
	aAdd(aObjects, {100, 130, .T., .F.})
	aAdd(aObjects, {100, 200, .T., .T.})
	aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects)

	DEFINE MSDIALOG oDlgRO1 TITLE OemToAnsi(cTitDlg) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

	oEnc:=MsMget():New("PD1",PD1->(Recno()),5,,,,,{0,0,80,80},,3,,,,,,.t.)
	oEnc:oBox:Align:= CONTROL_ALIGN_TOP

	oGetD    := MsNewGetDados():New( aPosObj[1][1],  aPosObj[1][2],  aPosObj[1][3],  aPosObj[1][4],,"AllWaysTrue()","AllWaysTrue()",,,,Len(aCols),,, ,oDlgRO1, aHeader, aCols )
	//bDbClick := oGetD:oBrowse:bLDblClick
	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	// Habilita o Duplo Click trocando o valor da MarkBrowse
	// neste caso apenas quando estiver na primeira coluna da GetDados
	//oGetD:oBrowse:bLDblClick := {|| (Iif(oGetD:aCols[oGetD:nAt,1]=="LBNO",	oGetD:aCols[oGetD:nAt,1]:="LBOK",oGetD:aCols[oGetD:nAt,1]:="LBNO"),;
		//oGetD:oBrowse:Refresh(),"")}

	ACTIVATE MSDIALOG oDlgRO1 ON INIT EnchoiceBar(oDlgRO1,{||nOpca:=1,if(VldTOKFec(oGetD),oDlgRO1:End(),nOpca := 0)},{||oDlgRO1:End()},,aButtons)

	If nOpca == 1
		Begin Transaction
			AtuRomaneio(.T.)
		End Transaction
	Endif

Return

/* {Protheus.doc} Function STFATRO2
Description
Rotina
@author
@since
@type 
*/

User Function STFATRO2()

	If !(__cUserId $ GetMv("ST_UROMAN",,"000000")+'/000645/000000/001375')
		MsgAlert("Sem acesso!")
		Return
	EndIf

	If PD1->PD1_STATUS == '3'				// Valdemir Rabelo 20/01/2021 - Ticket: 20210105000146
		FWMsgRun(,{|| Sleep(3000)},'Atenção!',"Registro já Encerrado. Por favor, verifique.")
		Return
	ElseIf PD1->PD1_STATUS == '2'			// Valdemir Rabelo 20/01/2021 - Ticket: 20210105000146 
		FWMsgRun(,{|| Sleep(3000)},'Atenção!',"Registro já Fechado. Por favor, verifique.")
		Return
	Else

		PD2->(DbSetOrder(1))
		PD2->(DbSeek(xFilial("PD2")+PD1->PD1_CODROM))
		While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+PD1->PD1_CODROM)

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS := "2"  //Fechados
			PD2->(MsUnlock())

			PD2->(DbSkip())
			
			//INICIO GRAVACAO LOG Z05
			DbSelectArea("SC6")
			SC6->(DbSetOrder(4))
			IF SC6->(DbSeek(xFilial("PD2")+PD2->PD2_NFS+PD2->PD2_SERIES))
				u_LOGJORPED("PD1","8"," "," ",SC6->C6_NUM,"","Finalizacao romaneio",SF2->F2_VALBRUT)
			EndIf
			//FIM GRAVACAO LOG Z05
		Enddo

		PD1->(RecLock("PD1",.F.))
		PD1->PD1_STATUS := "2"  //Fechados 
		PD1->(MsUnlock())



		MsgAlert("Processamento finalizado!")

	EndIf


Return

Static Function STFSF60ATU()

	Local cKMSaid, cHrSaid, cKMCheg, cHrCheg
	Local cMotori, cAjuda1, cAjuda2
	Local aParamBox		:= {}
	Local aRet			:= {}

	cKMSaid		:= PD1->PD1_KMSAID
	cHrSaid		:= PD1->PD1_HRSAID
	cKMCheg		:= PD1->PD1_KMCHEG
	cHrCheg		:= PD1->PD1_HRCHEG
	cMotori		:= PD1->PD1_MOTORI
	cAjuda1		:= PD1->PD1_AJUDA1
	cAjuda2		:= PD1->PD1_AJUDA2

	aAdd( aParamBox,{1,"KM Saida"		,cKMSaid	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Hora Saida"		,cHrSaid	,"@R 99:99"	,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"KM Chegada"		,cKMCheg	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Hora Chegada"	,cHrCheg	,"@R 99:99"	,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Motorista"		,cMotori	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Ajudante 1"		,cAjuda1	,"@!"		,""	,"DAUST"	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Ajudante 2"		,cAjuda2	,"@!"		,""	,"DAUST"	,""	,0	,.T.})
	SaveInter()
	If !ParamBox(aParamBox,"Parametros",@aRet,,,,,,,,.f.)
		RestInter()
		Return .F.
	Endif

	PD1->(RecLock("PD1",.F.))
	PD1->PD1_KMSAID	:= mv_par01
	PD1->PD1_HRSAID	:= mv_par02
	PD1->PD1_KMCHEG	:= mv_par03
	PD1->PD1_HRCHEG	:= mv_par04
	PD1->PD1_MOTORI	:= mv_par05
	PD1->PD1_AJUDA1	:= mv_par06
	PD1->PD1_AJUDA2	:= mv_par07
	PD1->(MsUnlock())

	RestInter()

Return .F.

Static Function AtuRomaneio(lEstorno)
	Local   nPosNFS
	Local   nPosSerieS
	Local   lLinhaDel
	Local   lLinhaSel
	Local   lDelAll  := .t.
	Local   nX
	Local nAux		:= 0
	Default lEstorno := .f.

	SF2->(DbSetOrder(1))
	PD2->(DbSetOrder(1))
	For nX:=1 to Len(aCols)
		nPosNFS    := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PD2_NFS"})
		nPosSerieS := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PD2_SERIES"})
		lLinhaDel  := aCols[nX,Len(aHeader)+01]
		lLinhaSel  := If(!lEstorno,.f.,If(aCols[nX,01]=="LBOK",.t.,.f.))
		If PD2->(DbSeek(xFilial("PD2")+PD1->PD1_CODROM+aCols[nX,nPosNFS]+aCols[nX,nPosSerieS]))
			If lLinhaDel .OR. (lEstorno .AND. lLinhaSel)
				If SF2->(DbSeek(xFilial("SF2")+PD2->(PD2_NFS+PD2_SERIES))) .AND. !Empty(SF2->F2_XCODROM)
					SF2->(RecLock("SF2",.F.))
					SF2->F2_XCODROM := ""
					SF2->(MsUnLock())
				Endif

				If lEstorno .Or. lLinhaDel //Renato Nogueira - Ajustar status da CB7 quando deletar a linha
					CB7->(DbSetOrder(4))
					If CB7->(DbSeek(xFilial('CB7')+PD2->(PD2_NFS+PD2_SERIES))) .And. CB7->CB7_STATUS == "9"
						CB7->(RecLock("CB7",.F.))
						CB7->CB7_STATUS := "4"
						CB7->(MsUnLock())
					Endif
				EndIf

				PD2->(RecLock("PD2",.F.))
				PD2->(dbDelete())
				PD2->(MsUnLock())
				nAux ++
			Else
				lDelAll := .f.
			Endif
		Endif
	Next
	lDelAll := If(nAux == Len(aCols),.T.,.F.)

	If lDelAll
		PD1->(RecLock("PD1",.F.))
		PD1->(dbDelete())
		PD1->(MsUnLock())
	Else
		U_STFATRO3(PD1->PD1_CODROM,lEstorno) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)
	Endif

Return

User Function STFATRO3(cCodRomaneio,lEncerra,_cNote,_cSerious)
	Local   nVols       := 0
	Local   nPesoL      := 0
	Local   nPesoB      := 0
	Local   nAndamentos := 0
	Local   nFechados   := 0
	Local   cStatus     := "0"
	Local   nRegsPD2    := 0
	Local   lBraspress   := Getmv("ST_BRASPRE",,.F.)
	Local   lEtiqBras   := .f.
	Default lEncerra    := .f.
	Default _cNote      := ''
	Default _cSerious   := ''

	PD1->(DbSetOrder(1))
	If	PD1->(DbSeek(xFilial("PD1")+cCodRomaneio))

		PD2->(DbSetOrder(1))
		If	PD2->(DbSeek(xFilial("PD2")+cCodRomaneio))
			While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+cCodRomaneio)
				++nRegsPD2
				If PD2->PD2_STATUS == "1"  //Em andamento
					++nAndamentos
				ElseIf PD2->PD2_STATUS == "2"  //Fechados
					++nFechados
					//INICIO GRAVACAO LOG Z05
					DbSelectArea("SC6")
					SC6->(DbSetOrder(4))
					IF SC6->(DbSeek(xFilial("PD2")+PD2->PD2_NFS+PD2->PD2_SERIES))
						u_LOGJORPED("PD1","8"," "," ",SC6->C6_NUM,"","Finalizacao romaneio",SF2->F2_VALBRUT)
					EndIf
					//FIM GRAVACAO LOG Z05

				Endif

				nVols 	+= PD2->PD2_QTDVOL
				nPesoL 	+= PD2->PD2_PLIQ
				nPesoB 	+= PD2->PD2_PBRUTO
				PD2->(DbSkip())
			Enddo

			If (nFechados > 0) .and. (nFechados == nRegsPD2)    // Ajustado Valdemir Rabelo 08/04/2022
				cStatus := If(lEncerra,"3","2")
			ElseIf nFechados>0 .OR. nAndamentos>0
				cStatus := "1"
			ElseIf nFechados==0 .OR. nAndamentos==0
				cStatus := "0"
			Endif
		Endif
		IF (nRegsPD2==0)				// Adicionado 26/11/2019 - Valdemir
			if MsgYesNo("Deseja excluir o romaneio?","Atenção!")
				if VldPD2Exc(cCodRomaneio)   // Valdemir Rabelo 28/05/2021 - Ticket: 20210527008842
					PD1->(RecLock("PD1",.F.))
					PD1->( dbDelete() )
					PD1->(MsUnLock())
					LimpDados()
				Endif
				Return
			Endif
		Endif

		//Atualiza informacao da tabela de Romaneio:
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_QTDVOL := nVols
		PD1->PD1_PLIQ   := nPesoL
		PD1->PD1_PBRUTO := nPesoB
		PD1->PD1_STATUS := cStatus
		PD1->(MsUnLock())

	Endif
Return

Static Function MontaCols(cSeekPD2,oGet,lEncerra)
	Local nCnt,nUsado
	Local oStatus
	Local oFlagVerde    := LoadBitMap(GetResources(),"BR_VERDE")
	Local oFlagVermelho := LoadBitMap(GetResources(),"BR_VERMELHO")
	Local oFlagAmarelo  := LoadBitMap(GetResources(),"BR_AMARELO")
	Default lEncerra    := .f.
	ProcRegua( 0 )
	If Type("oTimer") == "O"
		oTimer:Deactivate()
	EndIf

	aCols := {}
	aRecno:={}
	nCnt  := 0
	PD2->(DbSetOrder(1))
	PD2->( dbSeek( cSeekPD2 ) )
	While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == cSeekPD2)

		nCnt++
		nUsado := 0
		If !lEncerra
			aadd(aCols,Array(Len(aHeader)+1))
			aCols[Len(aCols),01] := ""
			nUsado++
		Else
			aadd(aCols,Array(Len(aHeader)+1))
			aCols[Len(aCols),01] := "LBNO"
			aCols[Len(aCols),02] := ""
			nUsado := nUsado + 2
		Endif
		aadd(aRecno,PD2->(Recno()))
		dbSelectArea("SX3")
		dbSeek( "PD2" )

		While !Eof() .And. x3_arquivo == "PD2"
			If X3USO(x3_usado) .And. cNivel >= x3_nivel .And. AllTrim( x3_campo ) <> "PD2_CODROM"
				If AllTrim( x3_campo ) == "PD2_STATUS"
					If PD2->PD2_STATUS == "0"
						oStatus := oFlagVerde
					ElseIf PD2->PD2_STATUS == "1"
						oStatus := oFlagAmarelo
					Else
						oStatus := oFlagVermelho
					Endif
					If !lEncerra
						aCols[Len(aCols),01] := oStatus
					Else
						aCols[Len(aCols),02] := oStatus
					Endif
					SX3->(dbSkip())
					Loop
				Endif
				nUsado++
				If x3_context # "V"
					cField := X3_CAMPO
					dbSelectArea("PD2")
					aCols[ nCnt, nUsado ] := FieldGet( FieldPos( cField ) )
					dbSelectArea("SX3")
				ElseIf x3_context == "V"
					aCols[ nCnt, nUsado ] := CriaVar( AllTrim( x3_campo ) )
					// Processa Gatilhos
					EvalTrigger()
				Endif
			Endif

			aCols[ nCnt, nUsado + 1 ] := .f.

			dbSelectArea("SX3")
			dbSkip()

		EndDo

		dbSelectArea( "PD2" )
		dbSkip()

	EndDo

	If Empty(aCols)

		dbSelectArea("SX3")
		dbSeek( "PD2" )
		nUsado	:= 0
		nCnt	:= 1
		aadd(aCols,Array(Len(aHeader)+1))
		aCols[Len(aCols),01] := ""
		nUsado++
		While !Eof() .And. x3_arquivo == "PD2"
			If X3USO(x3_usado) .And. cNivel >= x3_nivel .And. AllTrim( x3_campo ) <> "PD2_CODROM"
				If AllTrim( x3_campo ) == "PD2_STATUS"
					aCols[Len(aCols),01] := oFlagVermelho
					SX3->(dbSkip())
					Loop
				Endif
				nUsado++
				aCols[ nCnt, nUsado ] := CriaVar( AllTrim( x3_campo ) )
			Endif

			dbSelectArea("SX3")
			dbSkip()

		EndDo
		aCols[ nCnt,Len(aHeader)+1] := .F.

	Endif

	If oGet # Nil
		oGet:oBrowse:Refresh()
	EndIf
	//	If Type("oTimer") = "O"
	//		oTimer:Activate()
	//	EndIf
Return

Static Function VldTOKFec(oGet)
	Local nSelOK := 0

	aEval(oGet:aCols,{|x| If(x[01]=="LBOK",nSelOK++,nil)})
	//If nSelOK == 0
	//	MsgAlert("Todas as notas serão consideradas como entregues!!!",".:AVISO:.")
	//	Return .f.
	//Endif

	If nSelOK > 0 .and. !MsgYesNo("Confirma devolução dos documentos selecionados ?",".:AVISO:.")
		Return .f.
	Endif
	aCols := aClone(oGet:aCols)

Return .t.

Static Function DELNFROM()

	Local aArea     := GetArea()
	Local aAreaPD2  := PD2->(GetArea())
	Local aAreaPD1  := PD1->(GetArea())
	Local cNf		:= Space(9)
	Local cSerie	:= Space(3)
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local cOrdSep	:= ""

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Nota fiscal") From 1,0 To 15,60 OF oMainWnd

	@ 05,04 SAY "NF:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cNf Size 200,012  PIXEL OF oDlgEmail

	@ 35,04 SAY "Série:" PIXEL OF oDlgEmail
	@ 45,04 MSGet cSerie Size 200,012  PIXEL OF oDlgEmail

	@ 065, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 065, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel

	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1

		PD1->(Reclock("PD1",.F.))
		PD1->PD1_AJUDA1	:= "S"	//Renato Nogueira - Chamado 000098 - Se houver alteração, forçar o usuário a confirmar o romaneio para alterar os status
		PD1->(Msunlock())

		DbSelectArea("CB9")
		CB9->(DbSetOrder(1)) 	//CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
		CB9->(DbGoTop())
		CB9->(DbSeek(xFilial("CB9")+cOrdSep))

		While CB9->(!Eof()) .And. AllTrim(CB9->CB9_ORDSEP)==AllTrim(cOrdSep)

			CB9->(RecLock("CB9",.F.))
			CB9->CB9_STATUS	:= "2"
			CB9->(MsUnlock())

			CB9->(DbSkip())

		EndDo

		DbSelectArea("PD2")
		PD2->(DbSetOrder(1)) //PD2_FILIAL+PD2_CODROM+PD2_NFS+PD2_SERIES
		PD2->(DbSeek(PD1->(PD1_FILIAL+PD1->PD1_CODROM)+cNf+cSerie))

		If !PD2->(Eof())

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS	:= "0"
			PD2->(MsUnlock())

			MsgAlert("Status atualizado com sucesso")

		Else

			MsgAlert("Nota fiscal não encontrada para este romaneio")

		Endif

	EndIf

	RestArea(aAreaPD1)
	RestArea(aAreaPD2)
	RestArea(aArea)

Return .T.




/*/{Protheus.doc} STObsRom
description
Rotina para apresentar e alterar observação do romaneio
@type function
@version 
@author Valdemir Jose
@since 10/06/2020
@param cRomaneio, character, param_description
@return return_type, return_description
/*/
Static Function STObsRom(cRomaneio)
	Local aArea := GetArea()
	Local _cObs := Space(250)
	Local nOPC  := 0
	Local oBtOK
	Local oMObs
	Static oDlgRom

	if Empty(cRomaneio)
		FWMsgRun(,{|| sleep(4000)},"Atenção!","Romaneio está em branco. Observação não pode ser apresentado.")
		Return
	endif

	dbSelectArea("PD1")
	dbSetOrder(1)
	if dbSeek(xFilial('PD1')+cRomaneio)
		_cObs := PD1->PD1_OBS
	endif

	DEFINE MSDIALOG oDlgRom TITLE "Observação Romaneio" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

	@ 006, 004 GET oMObs VAR _cObs OF oDlgRom MULTILINE SIZE 240, 115 COLORS 0, 16777215 HSCROLL PIXEL
	@ 128, 106 BUTTON oBtOK PROMPT "&Confirma" ACTION (ConfObs(_cObs),oDlgRom:End()) SIZE 037, 012 OF oDlgRom PIXEL

	ACTIVATE MSDIALOG oDlgRom CENTERED

	RestArea( aArea )
Return

Static Function ConfObs(_cObs)

	RecLock("PD1",.F.)
	PD1->PD1_OBS := _cObs
	MsUnlock()

Return


/*/{Protheus.doc} FiltraBD
description
   Filtra Banco Dados
@type function
@version 
@author Valdemir Jose
@since 10/06/2020
@return return_type, return_description
/*/
Static Function FiltraBD(poListDados)
	Local obtFiltrar
	Local oBtOK
	Local obtSair
	Local oGData1
	Local oGData2
	Local oGEnt1
	Local oGet1
	Local oGMotorista
	Local oGPCampos
	Local oGPEnt
	Local oGPlaca
	Local oGRomaneio
	Local oGrpData
	Local oListDados
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSData2
	Local oSDe
	Local oSRom
	Private oCBStatus
	Private nCBStatus := 1
	Private oGAjuda1
	Private cGAjuda1 	:= Space(20)
	Private dGData1  	:= CTOD('')
	Private dGData2  	:= CTOD('')
	Private dGEnt1   	:= CTOD('')
	Private dGEnt2   	:= CTOD('')
	Private cGMotorista := space(20)
	Private cGPlaca 	:= space(7)
	Private cGRomaneio 	:= space(10)
	Private nListDados 	:= 1
	Private aListView  	:= {}
	Static oDlgFil

	aAdd(aListView,{;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'';
		})

	DEFINE MSDIALOG oDlgFil TITLE "Filtra Romaneio" FROM 000, 000  TO 550, 680 COLORS 0, 16777215 PIXEL

	@ 004, 005 GROUP oGrpData TO 069, 073 PROMPT "[ Período Emissão ]" OF oDlgFil COLOR 0, 16777215 PIXEL
	@ 014, 008 SAY   oSDe    PROMPT "De"  SIZE 025, 007 OF oGrpData COLORS 0, 16777215 PIXEL
	@ 022, 008 MSGET oGData1 VAR dGData1  SIZE 060, 010 OF oGrpData PICTURE "@D 99/99/9999" COLORS 0, 16777215 PIXEL
	@ 035, 008 SAY   oSData2 PROMPT "Até" SIZE 025, 007 OF oGrpData COLORS 0, 16777215 PIXEL
	@ 043, 008 MSGET oGData2 VAR dGData2  SIZE 060, 010 OF oGrpData PICTURE "@D 99/99/9999" COLORS 0, 16777215 PIXEL

	@ 004, 075 GROUP oGPEnt TO 069, 143 PROMPT "[ Período Entrega ]" OF oDlgFil COLOR 0, 16777215 PIXEL
	@ 014, 080 SAY   oSay1 PROMPT "De"  SIZE 025, 007 OF oGPEnt COLORS 0, 16777215 PIXEL
	@ 022, 080 MSGET oGEnt1 VAR dGEnt1  SIZE 060, 010 OF oGPEnt PICTURE "@D 99/99/9999" COLORS 0, 16777215 PIXEL
	@ 035, 080 SAY   oSay2 PROMPT "Até" SIZE 025, 007 OF oGPEnt COLORS 0, 16777215 PIXEL
	@ 043, 080 MSGET oGet1 VAR dGEnt2   SIZE 060, 010 OF oGPEnt PICTURE "@D 99/99/9999" COLORS 0, 16777215 PIXEL

	@ 005, 146 GROUP oGPCampos TO 069, 341 PROMPT "[ Campos ]" 	OF oDlgFil 		COLOR  0, 16777215 PIXEL
	@ 014, 151 SAY oSay3 PROMPT "Placa" 		 SIZE 025, 007 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 013, 179 MSGET oGPlaca VAR cGPlaca 		 SIZE 041, 010 F3 "DA3"	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 026, 151 SAY oSRom PROMPT "Romaneio" 		 SIZE 025, 007 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 025, 179 MSGET oGRomaneio VAR cGRomaneio 	 SIZE 041, 010 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 038, 151 SAY oSay4 PROMPT "Motorista" 	 SIZE 025, 007 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 037, 179 MSGET oGMotorista VAR cGMotorista SIZE 145, 010 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 050, 151 SAY oSay5 PROMPT "Ajudante" 		 SIZE 025, 007	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 049, 179 MSGET oGAjuda1 VAR cGAjuda1 		 SIZE 145, 010 	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 014, 225 SAY oSay6 PROMPT "Status" 		 SIZE 025, 007	OF oGPCampos 	COLORS 0, 16777215 PIXEL
	@ 013, 245 MSCOMBOBOX oCBStatus VAR nCBStatus ITEMS {"0 - Não Iniciado","1 - Em Andamento","2 - Fechado","3 - Encerrado","TODOS"} SIZE 079, 010 OF oDlgFil COLORS 0, 16777215 PIXEL
	oCBStatus:nAT := 5
	@ 070, 285 BUTTON obtFiltrar PROMPT "&Filtrar" SIZE 056, 012 OF oDlgFil ACTION FiltraDados(oListDados) PIXEL
	oBtFiltrar:SetCSS(CSSBOTAO)
	@ 084, 006 LISTBOX oListDados FIELDS HEADER ;
		'Romaneio ', 'Emissao', 'Entrega','Placa', 'Motorista', 'Ajudante','Status'  ;
		SIZE 337,172 OF oDlgFil COLORS 0, 16777215 PIXEL ON dblClick( {|| ConfFil(oListDados),oDlgFil:End()})
	AtuFiltro(oListDados, aListView)

	@ 258, 180 BUTTON obtSair 	PROMPT "&Sair" 	SIZE 037, 012 OF oDlgFil ACTION oDlgFil:End() PIXEL
	@ 258, 138 BUTTON oBtOK 	PROMPT "&Ok" 	SIZE 037, 012 OF oDlgFil ACTION (ConfFil(oListDados, poListDados), oDlgFil:End()) PIXEL
	obtSair:SetCSS(CSSBOTAO)
	oBtOK:SetCSS(CSSBOTAO)
	ACTIVATE MSDIALOG oDlgFil CENTERED

Return


/*/{Protheus.doc} ConfFil
description
   Rotina de Confirmar Filtro apos Selecao
@type function
@version 
@author Valdemir Jose
@since 10/06/2020
@param oListDados, object, param_description
@return return_type, return_description
/*/
Static Function ConfFil(oListDados, poListDados)
	Local nSelecao := oListDados:nAT
	Local cRomSel  := aListView[nSelecao][1]
	Local cPlaca   := aListView[nSelecao][4]
	Local nREG     := 0

	dbSelectArea('PD1')
	dbSetOrder(1)
	IF dbSeek(XFilial("PD1")+cRomSel)
		nREG     := PD1->( RECNO() )
		cVeiculo := cPlaca
		vldVei02(cPlaca, .F., .f.)
		getDadosRom(nREG, poListDados)

	ELSE
		FWMsgRun(,{|| sleep(4000)},"Atenção!","Romaneio não encontrado")
		nREG := 0
	ENDIF

	oDlg:Refresh()

Return


/*/{Protheus.doc} FiltraDados
description
  Rotina que fará o filtro dos dados da procura do romaneio
@type function
@version 
@author 
@since 10/06/2020
@param oListDados, object, param_description
@return return_type, return_description
/*/
Static Function FiltraDados(oListDados)
	Local cQry := ""

	aListView := {}

	cQry := "SELECT " + CRLF
	cQry += "PD1_CODROM ROMANEIO, PD1_PLACA PLACA, PD1_MOTORI MOTORISTA, PD1_AJUDA1 AJUDANTE, PD1_DTEMIS EMISSAO, PD1_DTENT ENTREGA, PD1_STATUS STATUS " + CRLF
	cQry += "FROM " + RETSQLNAME("PD1") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	IF !Empty(dtos(dGData2))
		cQry += " AND PD1_DTEMIS BETWEEN '"+DTOS(dGData1)+"' AND '"+DTOS(dGData2)+"' " + CRLF
	Endif
	IF !Empty(DTOS(dGEnt2))
		cQry += " AND PD1_DTEMIS BETWEEN '"+DTOS(dGEnt1)+"' AND '"+DTOS(dGEnt2)+"' " + CRLF
	Endif
	IF !Empty(cGPlaca)
		cQry += " AND PD1_PLACA = '"+Upper(cGPlaca)+"' " + CRLF
	Endif
	IF !Empty(cGRomaneio)
		cQry += " AND PD1_CODROM = '"+cGRomaneio+"' " + CRLF
	Endif
	IF !Empty(cGMotorista)
		cQry += " AND PD1_MOTORI = '"+Upper(cGMotorista)+"' " + CRLF
	Endif
	IF !Empty(cGAjuda1)
		cQry += " AND PD1_AJUDA1 = '"+Upper(cGAjuda1)+"' " + CRLF
	Endif
	// 0=Nao iniciado;1=Em andamento;2=Fechado;3=Encerrado                                                                             
	IF oCBStatus:nAT > 0
		if     oCBStatus:nAT==1
			cQry += " AND PD1_STATUS = '0' " + CRLF
		elseif oCBStatus:nAT==2
			cQry += " AND PD1_STATUS = '1' " + CRLF
		elseif oCBStatus:nAT==3
			cQry += " AND PD1_STATUS = '2' " + CRLF
		elseif oCBStatus:nAT==4
			cQry += " AND PD1_STATUS = '3' " + CRLF
		Endif
	Endif
	cQry += "ORDER BY PD1_CODROM" + CRLF

	IF SELECT("TFIL") > 0
		TFIL->( dbCloseArea() )
	ENDIF
	TcQuery cQry New Alias "TFIL"

	IF EOF()
		aAdd(aListView,{;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'';
			})
	ELSE
		While !Eof()
			aAdd(aListView,{;
				TFIL->ROMANEIO,;
				DTOC(STOD(TFIL->EMISSAO)),;
				DTOC(STOD(TFIL->ENTREGA)),;
				TFIL->PLACA,;
				TFIL->MOTORISTA,;
				TFIL->AJUDANTE,;
				getStatus(TFIL->STATUS);
				})
			dbSkip()
		EndDo
	ENDIF
	IF SELECT("TFIL") > 0
		TFIL->( dbCloseArea() )
	ENDIF

	AtuFiltro(oListDados, aListView)
Return


/*/{Protheus.doc} AtuFiltro
description
   Atualiza tela de filtro
@type function
@version 
@author Valdemir Jose
@since 10/06/2020
@param oListDados, object, param_description
@param aVetor5, array, param_description
@return return_type, return_description
/*/
Static Function AtuFiltro(oListDados, aVetorX)
	oListDados:SetArray( aVetorX )
	oListDados:bLine := {|| {aVetorX[oListDados:nAt,01],;
		aVetorX[oListDados:nAt,02],;
		aVetorX[oListDados:nAt,03],;
		aVetorX[oListDados:nAt,04],;
		aVetorX[oListDados:nAt,05],;
		aVetorX[oListDados:nAt,06],;
		aVetorX[oListDados:nAt,07];
		}}
	oListDados:Refresh()
Return

/*/{Protheus.doc} getDadosRom
description
   Rotina para retornar dados do romaneio
@type function
@version 
@author Valdemir Jose
@since 11/06/2020
@param nREG, numeric, param_description
@return return_type, return_description
/*/
Static Function getDadosRom(nREG, poListDados)
	Local aAreaPD2
	DEFAULT poListDados := nil

	dbSelectArea("PD1")
	PD1->( dbGoto(nREG) )
	cRomaneio := PD1->PD1_CODROM
	cMotorista:= PD1->PD1_MOTORI
	cEmissao  := DTOC(PD1->PD1_DTEMIS)
	cDtEnt    := DTOC(PD1->PD1_DTENT)
	cAjudant  := PD1->PD1_AJUDA1
	cVeiculo  := PD1->PD1_PLACA
	// carrega as notas referente ao romaneio
	cNomCli  := ""
	cMsgRodiz:= ""
	aVetor5  := {}
	nQtdVol  := 0
	nPesLiq  := 0
	nPesBrt  := 0
	nQtdNFRO := 0
	aAreaPD2 := GetArea()
	dbSelectArea("PD2")
	dbSetOrder(1)
	if dbSeek(XFilial('PD2')+cRomaneio)
		nCubagem := 0
		While !Eof() .and. (PD2->PD2_CODROM==cRomaneio)
			cNomCli := Posicione("SA1",1,xFilial('SA1')+PD2->PD2_CLIENT+PD2->PD2_LOJCLI,"A1_NOME")
			aAdd(aVetor5, {.F.,;
				PD2->PD2_NFS,;
				PD2->PD2_SERIES,;
				PD2->PD2_CLIENT,;
				PD2->PD2_LOJCLI,;
				cNomCli,;
				PD2->PD2_REGIAO,;
				PD2->PD2_QTDVOL,;
				PD2->PD2_PLIQ,;
				PD2->PD2_PBRUTO})
			// soma
			nQtdNFRO  += 1
			nQtdVol	  += PD2->PD2_QTDVOL
			nPesLiq   += PD2->PD2_PLIQ
			nPesBrt   += PD2->PD2_PBRUTO
			nCubagem  += GetRetF2(PD2->PD2_NFS,PD2->PD2_SERIES,PD2->PD2_CLIENT,PD2->PD2_LOJCLI,"F2_XCUBAGE")

			dbSkip()
		EndDo
	else
		aVetor5 := {}
		aAdd(aVetor5, {.F.,;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			0,;
			0,;
			0})
	endif
	RestArea( aAreaPD2 )
	if poListDados != nil
		AtuLbx5(poListDados)				// Valdemir Rabelo 27/07/2020
	Endif
Return



/*/{Protheus.doc} getStatus
description
   Rotina para retornar descrição dos status
@type function
@version 
@author Valdemir Jose
@since 11/06/2020
@param pSTATUS, param_type, param_description
@return return_type, return_description
/*/
Static Function getStatus(pSTATUS)
	Local cRET := ""
	if pSTATUS == '0'
		cRET := "Não Iniciado"
	elseif pSTATUS == '2'
		cRET := "Em Andamento"
	elseif pSTATUS == '3'
		cRET := "Encerramento"
	endif
Return cRET


Static Function getZ44Mg(pCliente,pLoja,_cTipo)
	Local aZ44 := GetArea()
	Local cMsg := ""

	DbSelectArea("Z44")
	Z44->(DbSetOrder(1))
	If Z44->(DbSeek(xFilial("Z44")+pCliente+pLoja))

		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL1)
			cMsg := Z44->Z44_XMSBL1
		EndIf
		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL2)
			cMsg := Z44->Z44_XMSBL2
		EndIf
		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL3)
			cMsg := Z44->Z44_XMSBL3
		EndIf
		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL4)
			cMsg := Z44->Z44_XMSBL4
		EndIf

	Endif

	RestArea( aZ44 )

Return cMsg


/*/{Protheus.doc} AtuDados
description
Atualiza Dados da Placa e Motorista
@type function
@version 
@author Valdemir Jose
@since 27/10/2020
@return return_type, return_description
/*/
Static Function AtuDados()
	Local oBtOk
	Local oBtSair
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	Local oGVeiculo
	Local oGPlaca
	Local oGAjudante
	Local oGCodMot
	Local oSMotorista
	Local oGMotorista
	Local oSNomeM
	Local oSVeiculo
	Local cGCodMot := Space(10)
	Local cNomVei  := Space(30)
	Local cSNomAju := Space(10)
	Local cGPlaca  := Space(8)
	Local cGetAjud := Space(10)
	Local cDESCVEIC:= Space(30)
	Local cNMotAtu := Space(30)
	Local CSSFUND  := u_GetSetCSS("GROUP",,)
	Local oSay1
	Local oSay2
	Local oSay3
	Local nOPC     := 0
	Static oDlg

	// Valida Dados Informações
	if Empty(cVeiculo)
		FWMsgRun(,{|| sleep(4000)},"Informação","Para realizar alteração de dados, precisa do romaneio na tela")
		Return .T.
	endif

	DEFINE MSDIALOG oDlgAtu TITLE "Altera Dados" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

	@ 009, 009 GROUP oGVeiculo TO 042, 237 PROMPT "[ Veículo ]" OF oDlgAtu COLOR 0, 16777215 PIXEL
	@ 021, 014 SAY   oSay1 PROMPT "Placa" SIZE 025, 007 OF oDlgAtu COLORS 0, 16777215 PIXEL
	@ 020, 041 MSGET oGPlaca VAR cGPlaca VALID VldAltDados(cGPlaca, @cDescVeic) F3 "DA305" SIZE 033, 010 OF oDlgAtu COLORS 0, 16777215 PIXEL
	@ 022, 086 SAY   oSVeiculo PROMPT cDescVeic SIZE 143, 007 OF oDlgAtu FONT oFont1 COLORS 16711680, 16777215 PIXEL

	@ 047, 009 GROUP oGMotorista TO 080, 238 PROMPT "[ Motorista ]" OF oDlgAtu COLOR 0, 16777215 PIXEL
	@ 059, 014 SAY 	 oSMotorista PROMPT "Motorista"  SIZE 025, 007 OF oDlgAtu COLORS 0, 16777215 PIXEL
	@ 059, 041 MSGET oGCodMot VAR cGCodMot VALID VldMotDados(cGCodMot,@cNMotAtu) F3 "DA4" SIZE 033, 010 OF oDlgAtu COLORS 0, 16777215 PIXEL
	@ 059, 086 SAY   oSNomeM PROMPT cNMotAtu SIZE 143, 007 OF oDlgAtu FONT oFont1 COLORS 16711680, 16777215 PIXEL

	@ 087, 009 GROUP oGAjudante TO 119, 238 PROMPT "[ Ajudante ]" OF oDlgAtu COLOR 0, 16777215 PIXEL
	@ 099, 014 SAY   oSAjud PROMPT "Ajudante" SIZE 025, 007 OF oGAjudante COLORS 0, 16777215 PIXEL
	@ 099, 041 MSGET oGAjud VAR cGetAjud VALID VldAjuDados(cGetAjud, @cSNomAju) F3 "DAU" SIZE 033, 010 OF oGAjudante COLORS 0, 16777215 PIXEL
	@ 099, 086 SAY   oSNomAju PROMPT cSNomAju SIZE 143, 007 OF oGAjudante FONT oFont1 COLORS 16711680, 16777215 PIXEL

	@ 129, 085 BUTTON oBtOk   PROMPT "Ok"   SIZE 037, 012 OF oDlgAtu ACTION (nOPC :=1, oDlgAtu:End() ) PIXEL
	@ 129, 126 BUTTON oBtSair PROMPT "Sair" SIZE 037, 012 OF oDlgAtu ACTION oDlgAtu:End() PIXEL
	oGVeiculo:SetCSS( CSSFUND )
	oGMotorista:SetCSS( CSSFUND )
	oGAjudante:SetCSS( CSSFUND )
	oBTOk:SetCSS( SetCssImg("", "Success") )
	oBtSair:SetCSS( SetCssImg("", "Danger") )

	ACTIVATE MSDIALOG oDlgAtu CENTERED

	if (nOPC==1)
		lAtu := (!Empty(cGPlaca)) .or. (!Empty(cNMotAtu)) .or. (!Empty(cSNomAju))
		if lAtu
			if MsgYesNo("Deseja realmente atualizar o romaneio: "+PD1->PD1_CODROM,"Informativo")
				RecLock('PD1',.f.)
				IF !Empty(cGPlaca)
					PD1->PD1_PLACA := cGPlaca
					cVeiculo := cGPlaca
				Endif
				if !Empty(cGCodMot)
					PD1->PD1_MOTORI := cNMotAtu
					cMotorista := cNMotAtu
				Endif
				IF !Empty(cGetAjud)
					PD1->PD1_AJUDA1 := cSNomAju
					cAjudant := cSNomAju
				Endif
				MsUnlock()
				oDlg:Refresh()
				FWMsgRun(,{|| sleep(3000)},"Informativo","Registro atualizado com sucesso")
			endif
		Endif
	Endif

Return

/*/{Protheus.doc} VldAltDados
description
Valida Dados do Veiculo
@type function
@version 
@author Valdemir Jose
@since 27/10/2020
@param cGPlaca, character, param_description
@param cDescVeic, character, param_description
@return return_type, return_description
/*/
Static Function VldAltDados(cGPlaca, cDescVeic)
	Local lRET     := .T.
	Local _nCubVei := 0
	Local _nCubPer := 0
	Local _nPesVei := 0
	Local nPerCub  := SuperGetMV("ST_PERCUB",.F.,20)

	if !Empty(cGPlaca)
		DbSelectArea("DA3")
		DA3->(DbSetOrder(1))
		IF DA3->(DbSeek(xFilial("DA3")+alltrim(cGPlaca)))
			cDescVeic := DA3->DA3_DESC
			_nCubVei   := (DA3->DA3_ALTINT * DA3->DA3_COMINT * DA3->DA3_LARINT)
			_nCubPer   := nCubVei-(nCubVei*nPerCub/100)
			_nPesVei   := DA3->DA3_CAPACM

			IF _nPesVei > 0
				_cMsg   := "O peso bruto ultrapassou o limite dos <font color='red'><b> "+cValToChar(nPesVei)+".</font></b> Verifique por favor."
				if (nPesBrt > nPesVei)
					MsgInfo(_cMsg,"Atenção!")
					lRET := .F.
				Endif
			Endif

		else
			FWMsgRun(,{|| sleep(3000)},"Informativo","Veículo não encontrado (DA3)")
			lRET := .F.
		Endif
	Endif

Return lRET

/*/{Protheus.doc} VldMotDados
description
Valida Dados do Motorista
@type function
@version 
@author Valdemir Jose
@since 27/10/2020
@param cGCodMot, character, param_description
@param cNomMot, character, param_description
@return return_type, return_description
/*/
Static Function VldMotDados(cGCodMot,cNomMot)
	Local lRET     := .T.
	Local aAreaDA4 := GetArea()

	if !Empty(cGCodMot)
		DbSelectArea("DA4")
		DA4->(DbSetOrder(1))
		IF DA4->(DbSeek(xFilial("DA4")+alltrim(cGCodMot)))
			cNomMot := DA4->DA4_NREDUZ
		Else
			FWMsgRun(,{|| sleep(4000)},"Informção","Motorista não encontrado (DA4)")
			lRET := .F.
		Endif
	Endif
	RestArea( aAreaDA4 )

Return lRET

/*/{Protheus.doc} VldAjuDados
description
Valida Dados do Ajudante
@type function
@version 
@author Valdemir Jose
@since 27/10/2020
@param cGetAjud, character, param_description
@param cSNomAju, character, param_description
@return return_type, return_description
/*/
Static Function VldAjuDados(cGetAjud, cSNomAju)
	Local lRET     := .T.
	Local aAreaDA4 := GetArea()

	if !Empty(cGetAjud)
		dbSelectArea("DAU")
		DAU->( dbSetOrder(1) )
		if DAU->( dbSeek(xFilial("DAU")+cGetAjud) )
			cSNomAju := DAU->DAU_NREDUZ
		Else
			FWMsgRun(,{|| sleep(4000)},"Informção","Ajudante não encontrado (DAU)")
			lRET := .F.
		Endif
	ENDIF
	RestArea( aAreaDA4 )

Return lRET








Static Function SetCssImg(cImg, cTipo)

	Local cCssRet := ""
	Default cImg := "rpo:yoko_sair.png"
	Default cTipo := "Botao Branco"

	If cTipo == "Success"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#28a745;border-color:#28a745 "
		cCssRet += "}"
	EndIf

	If cTipo == "Primary"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
		cCssRet += "}"
	EndIf

	If cTipo == "Danger"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
		cCssRet += "}"
	EndIf

	If cTipo == "Warning"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#FFD700;border-color:#FFD700 "
		cCssRet += "}"
	EndIf

Return cCssRet


/*/{Protheus.doc} STFATEO1
	description
	Rotina para realizar o estorno do encerramento
	@type function
	@version  
	@author Valdemir Jose
	@since 23/03/2021
	@return return_type, return_description
/*/
Static Function STFATEO1()
	Local aAreaT  := GetArea()
	Local aPar    := {}
	Local aRET    := {}
	Local lResp   := .F.
	Local cCodRom := CriaVar("PD2_CODROM")

	aAdd( aPar,{1,"Romaneio ",cCodRom	,"@!","u_vldRoma()","","",90,.T.})

	lResp := ParamBox(aPar, "Informe os Dados", @aRET)

	IF !lResp
		Return
	Endif

	lResp := MsgNoYes("Deseja realmente estornar encerramento - romaneio: "+PD1->PD1_CODROM+"?")

	if lResp
		PD2->(DbSetOrder(1))
		PD2->(DbSeek(xFilial("PD2")+PD1->PD1_CODROM))
		While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+PD1->PD1_CODROM)

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS := "0"  //Fechados
			PD2->(MsUnlock())

			PD2->(DbSkip())
		Enddo

		PD1->(RecLock("PD1",.F.))
		PD1->PD1_STATUS := "0"  //Fechados
		PD1->(MsUnlock())
	endif

	RestArea( aAreaT )

Return

User Function vldRoma()
	Local lRET := .T.

	dbSelectArea("PD1")
	dbSetOrder(1)
	if !Empty(MV_PAR01)
		lRET := dbSeek(xFilial("PD1")+MV_PAR01)

		IF !lRET
			FWMsgRun(,{|| sleep(3000)},"Informativo","Romaneio não encontrado")
		Else
			lRET := (PD1->PD1_STATUS == '3')
			if !lRET
				FWMsgRun(,{|| sleep(3000)},"Informativo","Romaneio não foi encerrado")
			endif
		Endif
	Endif

Return

/*/{Protheus.doc} VldPD2Exc
description
Rotina faz a validação dos itens do romaneio e permite a exclusão caso
não encontre nenhum registro na PD2
Ticket: 20210527008842
@type function
@version  1.00
@author Valdemir Jose
@since 28/05/2021
@param cCodRomaneio, character, param_description
@return return_type, return_description
/*/
Static Function VldPD2Exc(cCodRomaneio)
	Local lRET   := .T.
	Local aAreaQ := GetArea()
	Local cQry   := ""

	cQry += "SELECT COUNT(*) REG " + CRLF
	cQry += "FROM " + RETSQLNAME("PD2") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' '"
	cQry += " AND A.PD2_CODROM='"+cCodRomaneio+"' " + CRLF

	if Select("TEXC") > 0
		TEXC->( dbCloseArea() )
	endif
	TCQUERY cQry NEW ALIAS "TEXC"

	TEXC->( dbGotop() )
	IF TEXC->(! EOF() )
		lRET := !(TEXC->REG > 0)
	ENDIF

	if Select("TEXC") > 0
		TEXC->( dbCloseArea() )
	endif

	RestArea( aAreaQ )

Return lRET
