#INCLUDE "PROTHEUS.CH"  
#INCLUDE "APVT100.CH" 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA71 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monitor do Controle Manaus                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA71()
Private aRotina := {	{"Pesquisar",		"AxPesqui",   0,1},;
						{"Visualizar",		"U_STFSF71M",0,2},;
						{"Manutencao",		"U_STFSF71M",0,4},;
						{"Excluir",			"U_STFSF71M",0,5},;
						{"Fecha controle",	"U_STFSF71F",0,2},;
						{"Gerar Pedido",	"U_STFSF71P",0,3},;
						{"Relatorio",		"U_STFSFA72",0,4},;
						{"Legenda"	,		"U_STFSF71L",0,2}}

Private cCadastro := OemtoAnsi( "Monitor de Controle Manaus" )

aCores := {	{ "PE1->PE1_STATUS == '0'", "ENABLE"  },;
			{ "PE1->PE1_STATUS == '1'", "BR_AMARELO" },;
			{ "PE1->PE1_STATUS == '2'", "BR_AZUL"   },;
			{ "PE1->PE1_STATUS == '3'","DISABLE" } }

mBrowse( 6, 1, 22, 75, "PE1", , , , , , aCores 	,,,,,,,,,3000,{|| o:=GetObjBrow(),o:Refresh()})


Return


//------------------------------------------------------------------------
// Monitor de Controle Manaus - VISUALIZACAO / MANUTENCAO / EXCLUSAO
User Function STFSF71M( cAlias, nReg, nOpcx )
Local oDlg
Local oGet
Local nOpc := 0
Local cSeekPE2 := xFilial("PE1") + PE1->PE1_CTRL
Local oEnc
Local nOpca := 0
Local cTitDlg   := "Monitor de Controle Manaus"

Local aSize     := {}
Local aInfo     := {}
Local aObjects  := {}

Private oTimer
Private aHeader := {}
Private aCols   := {}

If nOpcx == 3
	If PE1->PE1_STATUS == "1"  //Controle fechado
		If !MsgYesNo("Controle " + PE1->PE1_CTRL+ " fechado! Confirma reabertura ?","Aviso")
			Return
		Endif
		PE1->(RecLock("PE1",.F.))
		PE1->PE1_STATUS := "0"
		PE1->(MsUnLock())
	ElseIf PE1->PE1_STATUS == "2"  //Pedido gerado
		MsgAlert("Já existe um pedido de vendas gerado para o controle " + PE1->PE1_CTRL+ "!" + CHR(13) + CHR(10) + "O controle não pode ser alterado!!!","Aviso")
		Return
	ElseIf PE1->PE1_STATUS == "3"  //Faturado
		MsgAlert("Já existe uma nota fiscal gerada para o controle " + PE1->PE1_CTRL+ "!" + CHR(13) + CHR(10) + "O controle não pode ser alterado!!!","Aviso")
		Return
	Endif
Endif

RegToMemory("PE1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o cabecalho                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek( "PE2" )
While !Eof() .And. ( x3_arquivo == "PE2" )
	If X3USO(x3_usado) .And. cNivel >= x3_nivel .AND. AllTrim( x3_campo ) <> "PE2_CTRL"
		AAdd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context,"",,".F."})
	EndIf
	dbSkip()
EndDo

MontaCols(cSeekPE2)
aSize   := MsAdvSize()
aAdd(aObjects, {100, 130, .T., .F.})
aAdd(aObjects, {100, 200, .T., .T.})
aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitDlg) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

	oEnc:=MsMget():New(cAlias,nReg,nOpcx,,,,,{0,0,80,80},,3,,,,,,.t.)
	oEnc:oBox:Align:= CONTROL_ALIGN_TOP
	If nOpcx == 2 .OR. nOpcx == 4 //Visualizar ou Excluir
		oGet:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], 2,,,,,,50,,,,oDlg,aHeader,aCols)
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	ElseIf nOpcx == 3 //Manutencao
		oGet:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], GD_DELETE,,,,,,50,,,,oDlg,aHeader,aCols)
		oGet:oBrowse:bDelete := {|| VldLinDel(oGet) }
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	Endif
	
	DEFINE TIMER oTimer INTERVAL 1000 ACTION MontaCols(cSeekPE2,oGet) OF oDlg
	oTimer:Activate()

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(VldTOK(oGet,nOpcx),oDlg:End(),nOpca := 0)},{||oDlg:End()})

If nOpca == 1
	Begin Transaction
		Grava(oGet:aCols,nOpcx)
	End Transaction
Endif

Return


Static Function MontaCols(cSeekPE2,oGet)
Local nCnt,nUsado

If Type("oTimer") == "O"
	oTimer:Deactivate()
EndIf

aCols := {}
aRecno:={}
nCnt  := 0
PE2->(DbSetOrder(1))
PE2->( dbSeek( cSeekPE2 ) )
While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == cSeekPE2)

	nCnt++
	nUsado := 0
	aadd(aCols,Array(Len(aHeader)+1))
	aadd(aRecno,PE2->(Recno()))
	dbSelectArea("SX3")
	dbSeek( "PE2" )

	While !Eof() .And. x3_arquivo == "PE2"
		If X3USO(x3_usado) .And. cNivel >= x3_nivel .And. AllTrim( x3_campo ) <> "PE2_CTRL"
			nUsado++
			If x3_context # "V"
				cField := X3_CAMPO
				dbSelectArea("PE2")
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

	dbSelectArea( "PE2" )
	dbSkip()

EndDo
If oGet # Nil
	oGet:oBrowse:Refresh()
EndIf
If Type("oTimer") = "O"
	oTimer:Activate()
EndIf
Return


Static Function VldTOK(oGet,nOpcx)
Local nPosDel:=0
Local nDel

If nOpcx == 2
	Return .t.
Endif

If !MsgYesNo(If(nOpcx == 3,"Confirma alterações ?","Confirma exclusão do controle ?"),"Aviso")
	Return .f.
Endif

If nOpcx == 3 //Manutencao
	// -----------------------------------------------------------------------
	//Valida se todas as linhas foram excluidas, nao permitindo via alteracao:
	nPosDel := Len(aHeader)+1
	nDel    := 0
	aEval(oGet:aCols,{|x| If(x[nPosDel],nDel++,nil)})
	
	If nDel == Len(oGet:aCols)
		MsgAlert( "Para excluir todos os itens acessar a rotina de Exclusão de controles!", "Aviso" )
		Return .f.
	Endif
Endif

Return .t.


Static Function VldLinDel(oGet)
Local nPosLinAtu := oGet:nAt
Local lDel

If oGet:aCols[nPosLinAtu,Len(aHeader)+01]
	lDel := .f.
Else
	lDel := .t.
Endif
aCols[nPosLinAtu,Len(aHeader)+01]      := lDel
oGet:aCols[nPosLinAtu,Len(aHeader)+01] := lDel
oGet:Refresh()

Return .t.


Static Function Grava(aCols,nOpcx)
Local nPosPallet
Local nPosProd
Local nPosLote
Local nX
	
PE2->(DbSetOrder(1))
For nX:=1 to Len(aCols)
	nPosPallet := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PE2_PALLET"})
	nPosProd   := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PE2_PROD"})
	nPosLote   := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PE2_LOTE"})
	If PE2->(DbSeek(xFilial("PE2")+PE1->PE1_CTRL+aCols[nX,nPosPallet]+aCols[nX,nPosProd]+aCols[nX,nPosLote]))
		If nOpcx == 4 .OR. aCols[nX,Len(aHeader)+01]
			PE2->(RecLock("PE2",.F.))
			PE2->(dbDelete())
			PE2->(MsUnLock())
		Endif
	Endif
Next

If nOpcx == 4
	PE1->(RecLock("PE1",.F.))
	PE1->(dbDelete())
	PE1->(MsUnLock())
Else
	U_STFSF70C(PE1->PE1_CTRL) //Atualiza informacoes do Controle (pesos, quantidades volumes)
Endif

Return


//------------------------------------------------------------------------
// Monitor de Controle Manaus - FECHAMENTO DO CONTROLE
User Function STFSF71F( cAlias, nReg, nOpcx )

If PE1->PE1_STATUS == "1"  //Controle fechado
	MsgAlert("O controle " + PE1->PE1_CTRL+ " já está fechado!","Aviso")
	Return
ElseIf PE1->PE1_STATUS == "2"  //Pedido gerado
	MsgAlert("Já existe um pedido de vendas gerado para o controle " + PE1->PE1_CTRL+ "!" + CHR(13) + CHR(10) + "O controle não pode ser fechado!!!","Aviso")
	Return
ElseIf PE1->PE1_STATUS == "3"  //Faturado
	MsgAlert("Já existe uma nota fiscal gerada para o controle " + PE1->PE1_CTRL+ "!" + CHR(13) + CHR(10) + "O controle não pode ser fechado!!!","Aviso")
	Return
Endif

If !MsgYesNo("Confirma o fechamento do controle " + PE1->PE1_CTRL+ " ?","Aviso")
	Return
Endif
PE1->(RecLock("PE1",.F.))
PE1->PE1_STATUS := "1"
PE1->(MsUnLock())

Return


//------------------------------------------------------------------------
// Monitor de Controle Manaus
User Function STFSF71P( cAlias, nReg, nOpcx )
Local   cCliente   := Space(TamSX3("C5_CLIENTE")[01])
Local   cLoja      := Space(TamSX3("C5_LOJACLI")[01])
Local   cTransp    := Space(TamSX3("C5_TRANSP")[01])
Local   cCondPgto  := Space(TamSX3("C5_CONDPAG")[01])
Local   cTes 	   := Space(TamSX3("C6_TES")[01])
Local   aCab       := {}
Local   aItens     := {}
Local   aTemp      := {}
Local   nItens     := 0
Local   nPos
Local   nX
Local   aParBox    := {}
Local   aRetPar    := {}
Local   lGerouPV   := .f.
Local 	nPrcVen		:= 0
Local 	cTabela		:= Space(TamSX3("DA0_CODTAB")[01])

If PE1->PE1_STATUS == "0"  //Controle aberto
	MsgAlert("O controle está aberto, portanto o pedido não poderá ser gerado!","Aviso")
	Return
Endif

If !Empty(PE1->PE1_PV)
	MsgAlert("Já existe um pedido de vendas gerado para o controle " + PE1->PE1_CTRL+ "!","Aviso")
	Return
Endif

aParBox :={	{1,"Cliente",cCliente,"","","SA1"			,".T.",0,.T.},;
			{1,"Loja",cLoja,"","",""					,".T.",0,.T.},;
			{1,"Transportadora",cTransp,"","","SA4"		,".T.",0,.T.},;
			{1,"Cond.Pagamento",cCondPgto,"","","SE4"	,".T.",0,.T.},;
			{1,"TES",cTes,"","","SF4"					,".T.",0,.T.},;
			{1,"Tabela",cTabela,"","","DA0"				,".T.",0,.T.}}
			
If !ParamBox(aParBox,"Parametros",@aRetPar,,,,,,,,.f.)
	Return
Endif
cCliente  	:= aRetPar[1]
cLoja     	:= aRetPar[2]
cTransp   	:= aRetPar[3]
cCondPgto 	:= aRetPar[4]
cTes 	  	:= aRetPar[5]
cTabela		:= aRetPar[6]

SA1->(DbSetOrder(1))
If !SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
	MsgAlert("Cliente inválido !","Aviso")
	Return
Endif

SA4->(DbSetOrder(1))
If !SA4->(DbSeek(xFilial("SA4")+cTransp))
	MsgAlert("Transportadora inválida!","Aviso")
	Return
Endif

SE4->(DbSetOrder(1))
If !SE4->(DbSeek(xFilial("SE4")+cCondPgto))
	MsgAlert("Condição de Pagamento inválida!","Aviso")
	Return
Endif

SF4->(DbSetOrder(1))
If !SF4->(DbSeek(xFilial("SF4")+cTes))
	MsgAlert("Tipo de Entrada e Saida inválido!","Aviso")
	Return
Endif

//Monta Cabecalho do pedido:
aadd(aCab,{"C5_TIPO"      ,'N'				,nil})
aadd(aCab,{"C5_CLIENTE"   ,SA1->A1_COD		,nil})
aadd(aCab,{"C5_LOJACLI"   ,SA1->A1_LOJA		,nil})
aadd(aCab,{"C5_TIPOCLI"   ,SA1->A1_TIPO		,nil})
aadd(aCab,{"C5_TRANSP"    ,cTransp			,nil})
aadd(aCab,{"C5_CONDPAG"   ,cCondPgto       ,nil})
aadd(aCab,{"C5_TPFRETE"   ,"F"      		,nil})
aadd(aCab,{"C5_PBRUTO"    ,PE1->PE1_PBRUTO	,nil})
aadd(aCab,{"C5_PESOL"     ,PE1->PE1_PLIQ	,nil})
aadd(aCab,{"C5_VOLUME1"   ,PE1->PE1_QTDVOL	,nil})
aadd(aCab,{"C5_XDTEN"   ,dDataBase		,nil})
aadd(aCab,{"C5_XTIPO"   ,"2"				,nil})
aadd(aCab,{"C5_XTIPF"   ,"1"		,nil})

//Monta os Itens do pedido:
DA1->(dbSetOrder(1)) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
SB1->(DbSetOrder(1))
PE2->(DbSetOrder(1))
PE2->(DbSeek(xFilial("PE2")+PE1->PE1_CTRL))

While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == xFilial("PE1")+PE1->PE1_CTRL)
	SB1->(DbSeek(xFilial("SB1")+PE2->PE2_PROD))
	nPos := Ascan(aItens,{|x| x[02,02] == PE2->PE2_PROD})
	If nPos == 0
		aTemp := {}
		aadd(aTemp,{"C6_ITEM",		"00000",						NIL})
		aadd(aTemp,{"C6_PRODUTO",	SB1->B1_COD,					NIL})
		aadd(aTemp,{"C6_UM",		SB1->B1_UM,						NIL})
		aadd(aTemp,{"C6_QTDVEN",	PE2->PE2_QTDE,					NIL})

		If DA1->(DbSeek(xFilial("DA1")+cTabela+SB1->B1_COD))
			nPrcVen := DA1->DA1_PRCVEN
		Else
			nPrcVen := SB1->B1_PRV1
		Endif

		aadd(aTemp,{"C6_PRCVEN",	nPrcVen,						NIL})
		aadd(aTemp,{"C6_VALOR",		(PE2->PE2_QTDE*nPrcVen),		NIL})
		aadd(aTemp,{"C6_TES",		cTes,							NIL})
		aadd(aTemp,{"C6_LOCAL",		SB1->B1_LOCPAD,					NIL})
		aadd(aTemp,{"C6_DESCRI",	SB1->B1_DESC,					NIL})
		If !Empty(PE2->PE2_LOTE)
			aadd(aTemp,{"C6_LOTECTL",	PE2->PE2_LOTE,				NIL})
		Endif
		aadd(aTemp,{"C6_QTDLIB",	PE2->PE2_QTDE,					NIL})
		aadd(aItens,aClone(aTemp))
	Else
		aItens[nPos,04,02] += PE2->PE2_QTDE
		aItens[nPos,06,02] := aItens[nPos,04,02] * aItens[nPos,05,02]
	Endif
	PE2->(DbSkip())
Enddo
For nX:=1 to Len(aItens)
	++nItens
	aItens[nX,01,02] := StrZero(nItens,02)
Next

MsgRun("Gerando pedido de vendas! Aguarde!",,{|| lGerouPV := GeraPV(aCab,aItens)})
If !lGerouPV
	Return
Endif

//MsgRun("Gerando pedido de vendas! Aguarde!",,{|| GeraNFE()})

//--------------------------------------------------------------------
Static Function GeraPV(aCab,aItens)
Private lMSErroAuto:= .F.

Begin Transaction
	lMSHelpAuto := .T.
	msExecAuto({|x,y|Mata410(x,y)},aCab,aItens)
	lMSHelpAuto := .F.
	If lMSErroAuto
		DisarmTransaction()
		Break
	Endif
	//Grava informacoes na tabela de Controle:
	PE1->(RecLock("PE1",.F.))
	PE1->PE1_PV     := SC5->C5_NUM
	PE1->PE1_STATUS := "2"
	PE1->(MsUnLock())
	//Grava informacoes na tabela de PV:
	SC5->(RecLock("SC5",.F.))
	SC5->C5_XCTRL := PE1->PE1_CTRL
	SC5->(MsUnLock())
End Transaction

If lMSErroAuto
	MsgAlert("Problema na geração de pedidos!","Aviso")
	MostraErro()
Else
	MsgAlert("Pedido gerado com sucesso: " + SC5->C5_NUM + "!","Aviso")
Endif

Return


//--------------------------------------------------------------------------------
// Funcao que limpa a informacao do pedido de vendas da tabela de Controle PE1
User Function STFS71F1()
Local lDelPV := IsInCallStack("A410Deleta")

If ! U_STManaus()
	Return
EndIf

If !lDelPV .OR. Empty(SC5->C5_XCTRL)
	Return
Endif

PE1->(DbSetOrder(1))
If PE1->(DbSeek(xFilial("PE1")+SC5->C5_XCTRL))
	//Limpa informacoes do PV na tabela de Controle:
	PE1->(RecLock("PE1",.F.))
	PE1->PE1_PV     := ""
	PE1->PE1_STATUS := "1"  //Retorna para status controle fechado
	PE1->(MsUnLock())
Endif

Return


//--------------------------------------------------------------------------------
// Funcao que grava a informacao da Nota Fiscal na tabela de Controle PE1
User Function STFS71F2(lEstorno)
Local aPedidos := {}
Local nVolumes := 0
Local nPos
Local nX
Default lEstorno := .f.
return()// desabilitado por giovani zago 07/07/15 NAO ESTA GRAVANDO VOLUME
If ! U_STManaus()
	Return
EndIf

SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
While SD2->(!Eof() .AND. D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == xFilial("SF2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
	nPos := Ascan(aPedidos,SD2->D2_PEDIDO)
	If nPos == 0
		aadd(aPedidos,SD2->D2_PEDIDO)
	Endif
	SD2->(DbSkip())
Enddo

SC5->(DbSetOrder(1))
PE1->(DbSetOrder(1))
For nX:=1 to Len(aPedidos)
	If SC5->(DbSeek(xFilial("SC5")+aPedidos[nX])) .AND. !Empty(SC5->C5_XCTRL)
		If PE1->(DbSeek(xFilial("PE1")+SC5->C5_XCTRL))
			nVolumes += SC5->C5_VOLUME1
			//Grava informacoes da NFS na tabela de Controle:
			PE1->(RecLock("PE1",.F.))
			PE1->PE1_NFS    := If(!lEstorno,SF2->F2_DOC,"")
			PE1->PE1_SERIES := If(!lEstorno,SF2->F2_SERIE,"")
			PE1->PE1_STATUS := If(!lEstorno,"3","2")  //Faturado ou PV
			PE1->(MsUnLock())
		Endif
	Endif
Next

If !lEstorno .AND. nVolumes>0
	SF2->(RecLock("SF2",.F.))
	SF2->F2_VOLUME1 := nVolumes
	SF2->(MsUnLock())
Endif
Return


//--------------------------------------------------------------------------------
// Funcao que grava a Nota Fiscal de Entrada na Empresa destino  
User Function STFS71F3(lEstorno)
return()// desabilitado por giovani zago 01/07/15 pre-nota esta sendo gerada pela importação do xml.
If ! U_STManaus()
	Return
EndIf
MsgRun("Atualizando Pré-nota Filial: 'PRODUCA0' Aguarde!",,{|| RotPreNota(lEstorno) })
Return

Static Function RotPreNota(lEstorno)
Local cEmpDest := Left(GetNewPar("FS_NFEDEST","0101"),2)
Local cFilDest := Right(GetNewPar("FS_NFEDEST","0101"),2)
Local cCond    := GetNewPar("FS_CONDNFE","001")
Local aCab     := {}
Local aItens   := {}
Local aTemp    := {}                  
Local cArq		:= Alltrim(SF2->F2_DOC)+"."+Alltrim(SF2->F2_SERIE)
Local cFornece	:= ""
Local cLoja 	:= ""
Local cCNPJ		:= ""
Default lEstorno := .f.

SM0->(dbGoTop())
While !SM0->(Eof())
     If !(cEmpAnt == SM0->M0_CODIGO)
          SM0->(Dbskip())
          loop
     Endif    
     cCNPJ := SM0->M0_CGC
     Exit
EndDo

cFornece	:= SF2->F2_CLIENTE
cLoja 		:= SF2->F2_LOJA

EmpOpenFile("SA2X","SA2",1,.T.,cEmpDest)
SA2X->(DbSetOrder(3)) //A2_FILIAL+A2_CGC
If !Empty(cCNPJ) .and. SA2X->(DbSeek(cFilDest+cCNPJ))
	cFornece	:= SA2X->A2_COD
	cLoja 		:= SA2X->A2_LOJA
Endif
EmpOpenFile("SA2X","SA2",1,.F.,cEmpDest)

aCab := {	{"F1_TIPO"		,	'N'	,				NIL},;
				{"F1_FORMUL"	,	'N'	,				NIL},;
				{"F1_DOC"		,	SF2->F2_DOC,		NIL},;
				{"F1_SERIE"		,	SF2->F2_SERIE,		NIL},;
				{"F1_EMISSAO"	,	dDataBase,			NIL},;
				{"F1_FORNECE"	,	cFornece,	NIL},;
				{"F1_LOJA"		,	cLoja,		NIL},;
				{"F1_COND"		,	cCond,		NIL},;
				{"F1_ESPECIE"	,	'NF',		NIL} }

SB1->(DbSetOrder(1))
SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
While SD2->(!Eof() .AND. D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == xFilial("SF2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
	SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
	aTemp    := {}
	aadd(aTemp,{"D1_COD"		,	SD2->D2_COD,						NIL})
	aadd(aTemp,{"D1_LOCAL"	,	SB1->B1_LOCPAD,						NIL})
	aadd(aTemp,{"D1_UM"		,	SB1->B1_UM,							NIL})
	aadd(aTemp,{"D1_QUANT"	,	SD2->D2_QUANT,						NIL})
	aadd(aTemp,{"D1_VUNIT"	,	SD2->D2_PRCVEN,						NIL})
	aadd(aTemp,{"D1_TOTAL"	,	(SD2->D2_QUANT*SD2->D2_PRCVEN),	NIL})
	If !Empty(SD2->D2_LOTECTL)
		aadd(aTemp,{"D1_LOTECTL",	SD2->D2_LOTECTL,			NIL})
	Endif
	aadd(aItens,aClone(aTemp))
	SD2->(DbSkip())
Enddo

StartJob("U_STFS71F4",GetEnvServer(),.T.,"1",cEmpDest,cFilDest,aCab,aItens,If(!lEstorno,3,5))

If File(cArq)
	cRetorno:= MemoRead(cArq)
	Mostra(If(!lEstorno,"Inclusão","Exclusão"),cRetorno)
	FErase(cArq)
EndIf
   
Return

Static Function Mostra(cDescOpcao,cMemo)
Local oDlg
Local cFile    :=""
Local oFont 
	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
	DEFINE MSDIALOG oDlg TITLE "Erro na "+cDescOpcao+" do MATA140 (Pre-Nota)" From 3,0 to 340,417 PIXEL
	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile("Arquivos Texto (*.TXT) |*.txt|",OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION (PrintAErr(__cFileLog,cMemo),oDlg:End()) ENABLE OF oDlg PIXEL 
	ACTIVATE MSDIALOG oDlg CENTER
Return

//----------------------------------------------------------------------------------------
// Funcao que executa a rotina automatica para gravacao da Pre-Nota na Empresa destino
User Function STFS71F4(cAcao,cEmpOfi,cFilFis,aCabAux,aIteAux,nOpcx)
Local cStartPath := GetSrvProfString("Startpath","") ///ROOTPATH GetSrvProfString("ROOTPATH","")
Local cNota := aCabAux[3,2]
Local cSerie:= aCabAux[4,2] 
Local cArq		:= Alltrim(cNota)+"."+Alltrim(cSerie)


RpcSetEnv(cEmpOfi,cFilFis)
	FWMonitorMsg("Rotina automatica MATA140 "+cEmpAnt+"/"+cFIlAnt) //PtInternal(1,"Rotina automatica MATA140 "+cEmpAnt+"/"+cFIlAnt) 
	SaveInter()
	lMsErroAuto := .F.
	MATA140(aCabAux,aIteAux,nOpcx)
	If lMsErroAuto  
		MostraErro(cStartPath,cArq)
		lMsErroAuto := .F.                           
	Endif
	RestInter()
RpcClearEnv()

Return

//-------------------------------------------------------------------------------------------
// Funcao que grava a informacao da Nota Fiscal na tabela de Cabecalho de ordem separacao CB7
User Function STFS71F5()
/*
SC9->(DbSetOrder(6))
If SC9->(DbSeek(xFilial("SC9")+SF2->(F2_DOC+F2_SERIE)))
	dbSelectArea("CB7")
	dbSetOrder(1)
	If dbSeek(xFilial("CB7")+SC9->C9_ORDSEP)
		CB7->(RecLock("CB7",.F.))
		CB7->CB7_NOTA	:= SF2->F2_DOC
		CB7->CB7_SERIE	:= SF2->F2_SERIE
		CB7->(MsUnLock())
	EndIf
EndIf
*/
Return

//-------------------------------------------------------------------------------------------
// Funcao que atualiza informacao do pedido caso nao tenha sido atendido totalmente - Leonardo Flex -> 13/03/2013
User Function STFS71F6()

Local aArea 	:= GetArea()
Local aAreaSC6	:= SC6->(GetArea())
Local cSC6Cli	:= ""
Local cSC6Loj	:= ""
Local cSC6Num	:= ""
Local lAtuSC5	:= .F.

DbSelectArea("SC6")
DbSetOrder(4)
If DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE)
	cSC6Cli	:= SC6->C6_CLI
	cSC6Loj	:= SC6->C6_LOJA
	cSC6Num	:= SC6->C6_NUM
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+cSC6Num)
	While !Eof() .And. SC6->C6_NUM == cSC6Num
		If (SC6->C6_QTDVEN - SC6->C6_QTDENT) >0
			lAtuSC5 := .T.
			Exit
		EndIF
		dbSkip()
	EndDo
EndIf

If lAtuSC5
	DbSelectArea("SC5")
	DbSetOrder(3)
	If DbSeek(xFilial("SC5")+cSC6Cli+cSC6Loj+cSC6Num)
		SC5->(RecLock("SC5",.F.))
		SC5->C5_XTIPF   := "1" 
		SC5->C5_XBLQFMI := 'S'//Giovani Zago	06/06/2014 tratamento para bloquear faturamento minimo apos a NF
		SC5->(MsUnlock())
	EndIf
EndIf

RestArea(aAreaSC6)
RestArea(aArea)

Return

//------------------------------------------------------------------------
// Monitor de Controle Manaus
User Function STFSF71L()
Local aCorDesc
aCorDesc := {	{ "ENABLE",		"- Controle aberto" },;
				{ "BR_AMARELO",	"- Controle fechado" },;
				{ "BR_AZUL", 	"- Pedido gerado" },;
				{ "DISABLE",	"- Faturado" }}
BrwLegenda( "Legenda", "Status", aCorDesc )
Return



//-------------------------------------------------------------------------------------------
// Funcao que atualiza a data de entrega: C6_ZDTENRE para os pedidos tipo Retira na geração da nota fiscal
User Function STFS71DT()

Local aArea 	:= GetArea()
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())

DBSELECTAREA('SD2')
DBSETORDER(3)
IF SD2->(DBSEEK(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE))
   SC5->(DBSETORDER(1))
   IF SC5->(DBSEEK(XFILIAL('SC5')+SD2->D2_PEDIDO)) .AND. SC5->C5_XTIPO=='1' // Tipo retira grava data do sistema
      While ! SD2->(EOF()) .AND. SD2->D2_FILIAL == SF2->F2_FILIAL .AND. SD2->D2_DOC == SF2->F2_DOC ;
         .AND. SD2->D2_SERIE == SF2->F2_SERIE 
         SC6->(DBSETORDER(1)) 
         IF SC6->(DBSEEK(SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
            IF SC6->C6_QTDVEN <= SC6->C6_QTDENT // Entrega total do Item 
               SC6->(RECLOCK('SC6',.F.))
               SC6->C6_ZDTENRE:=DATE()
               SC6->(MSUNLOCK())
            ENDIF    
         ENDIF   
         SD2->(DBSKIP())
      ENDDO  
   ENDIF
ENDIF   

RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSD2)
RestArea(aArea)

Return()

//-------------------------------------------------------------------------------------------
// Funcao que atualiza a data de entrega: C6_ZDTENRE pedidos retira na exclusão da nota fiscal. 
User Function STFS71EDT()

Local aArea 	:= GetArea()
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())

DBSELECTAREA('SD2')
DBSETORDER(3)
IF SD2->(DBSEEK(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE))
   SC5->(DBSETORDER(1))
   IF SC5->(DBSEEK(XFILIAL('SC5')+SD2->D2_PEDIDO)) .AND. SC5->C5_XTIPO=='1' // Tipo retira grava data do sistema
      While ! SD2->(EOF()) .AND. SD2->D2_FILIAL == SF2->F2_FILIAL .AND. SD2->D2_DOC == SF2->F2_DOC ;
         .AND. SD2->D2_SERIE == SF2->F2_SERIE 
         SC6->(DBSETORDER(1)) 
         IF SC6->(DBSEEK(SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
            SC6->(RECLOCK('SC6',.F.))
            SC6->C6_ZDTENRE:=CTOD('  /  /  ')
            SC6->(MSUNLOCK())
         ENDIF   
         SD2->(DBSKIP())
      ENDDO  
   ENDIF
ENDIF   

RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSD2)
RestArea(aArea)

Return()

