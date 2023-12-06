#Include "Protheus.ch"
#Include "ApWizard.ch"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xACDI011     บAutor  ณGiovani Zago     บ Data ณ  06/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impressao de Etiqueta									  บฑฑ
ฑฑบ          ณ  								                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------*
User Function xACDI011(nOrigem,aParIni)
	*---------------------------------------------------*
	Local oWizard
	Local oPanel
	Local nTam

	Local oOrigem
	Local aOrigem	:= {}

	Local aparNF	:= {	{1,"Nota Fiscal" 		,Space(9) ,"","","CWB1"	,If(aParIni==NIL,".T.",".F."),0,.F.},; //"Nota Fiscal"
	{1,"Serie" 		,Space(3) ,"","",		,If(aParIni==NIL,".T.",".F."),0,.F.},; //"Serie"
	{1,"Fornecedor"		,Space(6) ,"","","SA2"	,If(aParIni==NIL,".T.",".F."),0,.F.},; //"Fornecedor"
	{1,"Loja"		,Space(2) ,"","",		,If(aParIni==NIL,".T.",".F."),0,.F.} } //"Loja"

	Local aRetNF	:= {Space(9),Space(3),Space(6),Space(2)}

	Local aParPR	:= {{1,"Produto" ,Space(15),"","","SB1"	,If(aParIni==NIL,".T.",".F."),60,.F.}} //"Produto"
	Local aRetPR	:= {Space(15)}

	Local aParOP	:= {{1,"OP" ,Space(13),"","","SC2"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
	Local aRetOP	:= {Space(13)}

	Local aParImp	:= {{1,"Local de Impressใo"	,Space(06),"","","CB5"	,".T.",0,.F.}} //"Local de Impressใo"
	Local aRetImp	:= {Space(6)}

	Local aParam	:= {}
	Local aRetPE	:= {}

	Local nx:= 1

	Private cCondSF1:= ' 1234567890'  // variavel utilizada na consulta sxb CBW, favor nao remover esta linha
	Private oLbx
	Private aLbx	:= {{.f., Space(15),Space(20),Space(10),Space(10),Space(10),Space(10),Space(20)}}
	Private aSvPar	:= {}
	Private cOpcSel	:= ""  // variavel disponivel para infomar a opcao de origem selecionada

	Private _lQtdUni := .F.

	DEFAULT nOrigem := 1

	aParam:={	{"Nota Fiscal"	,aParNF,aRetNF,{|| AWzVNF()}},; //"Nota Fiscal"
	{"Produto"	,aParPR,aRetPR,{|| AWzVPR()}},; //"Produto"
	{"Ordem de Producao"	,aParOP,aRetOP,{|| AWzVOP()}} } //"Ordem de Producao"

	If ExistBlock("ACDI11PA")
		aRetPE := ExecBlock("ACDI11PA",.F.,.F.,{aParam})
		If ValType(aRetPE) == "A"
			aParam := aClone(aRetPE)
		EndIf
	EndIf

	// carrega parametros vindo da funcao pai
	If aParIni <> NIL
		For nX := 1 to len(aParIni)
			nTam := len( aParam[nOrigem,3,nX ] )
			aParam[nOrigem,3,nX ] := Padr(aParIni[nX],nTam )
		Next
	EndIf

	For nx:= 1 to len(aParam)
		aadd(aOrigem,aParam[nX,1])
	Next

	DEFINE WIZARD oWizard TITLE "Etiqueta de Produto ACD" ; //"Etiqueta de Produto ACD"
	HEADER "Rotina de Impressใo de etiquetas termica." ; //"Rotina de Impressใo de etiquetas termica."
	MESSAGE "";
	TEXT "Esta rotina tem por objetivo realizar a impressao das etiquetas termicas de identifica็ใo de produto no padrใo codigo natural/EAN conforme as opcoes disponives a seguir." ; //"Esta rotina tem por objetivo realizar a impressao das etiquetas termicas de identifica็ใo de produto no padrใo codigo natural/EAN conforme as opcoes disponives a seguir."
	NEXT {|| .T.} ;
	FINISH {|| .T. } ;
	PANEL

	// Primeira etapa
	CREATE PANEL oWizard ;
	HEADER "Informe a origem das informa็๕es para impressใo" ; //"Informe a origem das informa็๕es para impressใo"
	MESSAGE "" ;
	BACK {|| .T. } ;
	NEXT {|| nc:= 0,aeval(aParam,{|| &("oP"+str(++nc,1)):Hide()} ),&("oP"+str(nOrigem,1)+":Show()"),cOpcSel:= aParam[nOrigem,1],A11WZIniPar(nOrigem,aParIni,aParam) ,.T. } ;
	FINISH {|| .F. } ;
	PANEL

	oPanel := oWizard:GetPanel(2)

	oOrigem := TRadMenu():New(30,10,aOrigem,BSetGet(nOrigem),oPanel,,,,,,,,100,8,,,,.T.)
	If aParIni <> NIL
		oOrigem:Disable()
	EndIf

	// Segunda etapa
	CREATE PANEL oWizard ;
	HEADER "Preencha as solicita็๕es abaixo para a sele็ใo do produto" ; //"Preencha as solicita็๕es abaixo para a sele็ใo do produto"
	MESSAGE "" ;
	BACK {|| .T. } ;
	NEXT {|| Eval(aParam[nOrigem,4]) } ;
	FINISH {|| .F. } ;
	PANEL

	oPanel := oWizard:GetPanel(3)

	For nx:= 1 to len(aParam)
		&("oP"+str(nx,1)) := TPanel():New( 028, 072, ,oPanel, , , , , , 120, 20, .F.,.T. )
		&("oP"+str(nx,1)):align:= CONTROL_ALIGN_ALLCLIENT
		ParamBox(aParam[nX,2],"Parโmetros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))		 //"Parโmetros..."
		&("oP"+str(nx,1)):Hide()
	Next

	CREATE PANEL oWizard ;
	HEADER "Parametriza็ใo por produto" ; //"Parametriza็ใo por produto"
	MESSAGE "Marque os produtos que deseja imprimir" ; //"Marque os produtos que deseja imprimir"
	BACK {|| .T. } ;
	NEXT {|| aRetImp  := {Space(6)},VldaLbx()} ;
	FINISH {|| .T. } ;
	PANEL
	oPanel := oWizard:GetPanel(4)
	ListBoxMar(oPanel)

	CREATE PANEL oWizard ;
	HEADER "Parametriza็ใo da impressora" ; //"Parametriza็ใo da impressora"
	MESSAGE "Informe o Local de Impressใo" ; //"Informe o Local de Impressใo"
	BACK {|| .T. } ;
	NEXT {|| Imprime(aParam[nOrigem,1]) } ;
	FINISH {|| .T.  } ;
	PANEL
	oPanel := oWizard:GetPanel(5)
	ParamBox(aParImp,"Parโmetros...",aRetImp,,,,,,oPanel)	 //"Parโmetros..."

	CREATE PANEL oWizard ;
	HEADER "Impressใo Finalizada" ; //"Impressใo Finalizada"
	MESSAGE "" ;
	BACK {|| .T. } ;
	NEXT {|| .T. } ;
	FINISH {|| .T.  } ;
	PANEL

	ACTIVATE WIZARD oWizard CENTERED

Return

Static Function A11WZIniPar(nOrigem, aParIni,aParam)
	Local nX
	If aParIni <> NIL
		For nx:= 1 to len(aParIni)
			&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParIni[ nX ]
		Next
	EndIf

	For nx:= 1 to len(aParam[nOrigem,3])
		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParam[nOrigem,3,nX ]
	Next

Return .t.

Static Function AWzVNF()
	Local cNota := Padr(MV_PAR01,9)
	Local cSerie:= Padr(MV_PAR02,3)
	Local cForn := Padr(MV_PAR03,6)
	Local cLoja := Padr(MV_PAR04,2)
	Local nQE
	Local nQVol
	Local nResto
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local nT	:= TamSx3("D3_QUANT")[1]
	Local nD	:= TamSx3("D3_QUANT")[2]

	If Empty(cNota+cSerie+cForn+cLoja)
		MsgAlert(" Necessario informar a nota e o fornecedor. ") //" Necessario informar a nota e o fornecedor. "
		Return .F.
	EndIf
	SF1->(DbSetOrder(1))
	If ! SF1->(DbSeek(xFilial('SF1')+cNota+cSerie+cForn+cLoja))
		MsgAlert(" Nota fiscal nใo encontrada. ") //" Nota fiscal nใo encontrada. "
		Return .F.
	EndIf

	aLbx:={}
	SD1->(DbSetOrder(1))
	SD1->(dbSeek(xFilial('SD1')+cNota+cSerie+cForn+cLoja)	)
	While SD1->(!EOF()  .and. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial('SD1')+cNota+cSerie+cForn+cLoja)

		SB1->(dbSeek(xFilial('SB1')+SD1->D1_COD))

		If ! CBImpEti(SB1->B1_COD)
			SD1->(dbSkip()	)
			Loop
		EndIf
		nQE     := CBQEmbI()
		nQE	    := If(Empty(nQE),1,nQE)
		nQVol   := Int(SD1->D1_QUANT/nQE)
		nResto  := SD1->D1_QUANT%nQE
		If nResto >0
			nQVol++
		EndIf
		SD1->(aadd(aLbx,{.f.,D1_COD,Str(SD1->D1_QUANT,nT,nD),Str(nQe,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),SD1->D1_LOTECTL,Space(20),"SD1",Recno()}))
		SD1->(dbSkip()	)
	End
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()

Return .t.

Static Function AWzVPR()
	Local cProduto	:= Padr(MV_PAR01,15)
	Local oOk		:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local nT		:= TamSx3("D3_QUANT")[1]
	Local nD		:= TamSx3("D3_QUANT")[2]

	If Empty(cProduto)
		MsgAlert(" Necessario informar o codigo do produto. ") //" Necessario informar o codigo do produto. "
		Return .F.
	EndIf

	SB1->(DbSetOrder(1))
	If ! SB1->(DbSeek(xFilial('SB1')+cProduto))
		MsgAlert(" Produto nใo encontrado ") //" Produto nใo encontrado "
		Return .F.
	EndIf

	If ! CBImpEti(SB1->B1_COD)
		MsgAlert(" Este Produto estแ configurado para nao imprimir etiqueta ") //" Este Produto estแ configurado para nao imprimir etiqueta "
		Return .F.
	EndIf
	aLbx:={{	.f., SB1->B1_COD,Space(10),Str(CBQEmbI(),nT,nD),Str(0,nT,nD),Str(0,nT,nD),Space(10),Space(10),"SB1",SB1->(Recno())}}
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()
Return .t.

Static Function AWzVOP()
	Local cOp	:= Padr(MV_PAR01,13)
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local nQtde
	Local nQE
	Local nQVol
	Local nResto
	Local nT	:= TamSx3("D3_QUANT")[1]
	Local nD	:= TamSx3("D3_QUANT")[2]

	If Empty(cOP)
		MsgAlert(" Necessario informar o codigo do ordem de produ็ใo. ") //" Necessario informar o codigo do ordem de produ็ใo. "
		Return .F.
	EndIf

	SC2->(DbSetOrder(1))
	If ! SC2->(DbSeek(xFilial('SC2')+cOP))
		MsgAlert(" Ordem de Produ็ใo nใo encontrado ") //" Ordem de Produ็ใo nใo encontrado "
		Return .F.
	EndIf
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	If ! CBImpEti(SB1->B1_COD)
		MsgAlert(" Este Produto estแ configurado para nao imprimir etiqueta ") //" Este Produto estแ configurado para nao imprimir etiqueta "
		Return .F.
	EndIf

	nQtde	:= SC2->(C2_QUANT-C2_QUJE)
	nQE		:= CBQEmbI()
	nQE		:= If(Empty(nQE),1,nQE)
	nQVol	:= Int(nQtde/nQE)
	nResto  :=nQtde%nQE
	If nResto >0
		nQVol++
	EndIf

	aLbx:={{	.f., SB1->B1_COD,Str(nQtde,nT,nD),Str(nQE,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),Space(10),Space(10),"SC2",SC2->(Recno())}}
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()

Return .t.

Static Function ListBoxMar(oDlg)
	Local oChk1
	Local oChk2
	Local lChk1 := .F.
	Local lChk2 := .F.
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local oP

	@ 10,10 LISTBOX oLbx FIELDS HEADER " ", "Produto","Qtde do Item","Qtde Emb.","Resto","Qtde Etiquetas","Lote","Fracionada"  SIZE 230,095 OF oDlg PIXEL ;  //"Produto"###"Qtde do Item"###"Qtde Emb."###"Resto"###"Qtde Volumes"###"Lote"###"Serie"
	ON dblClick(aLbx[oLbx:nAt,1] := !aLbx[oLbx:nAt,1])

	oLbx:SetArray( aLbx )
	oLbx:bLine	:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:align	:= CONTROL_ALIGN_ALLCLIENT

	oP := TPanel():New( 028, 072, ,oDlg, , , , , , 120, 20, .F.,.T. )
	oP:align:= CONTROL_ALIGN_BOTTOM

	@ 5,010  BUTTON "Alterar"	 SIZE 55,11 ACTION FormProd(1) OF oP PIXEL //"Alterar"
	@ 5,080  BUTTON "Copiar"	 SIZE 55,11 ACTION FormProd(2) OF oP PIXEL //"Copiar"
	@ 5,160 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := lChk1 } ),oLbx:Refresh() ) //"Marca/Desmarca Todos"
	@ 5,230 CHECKBOX oChk2 VAR lChk2 PROMPT "Inverter a sele็ใo" 	SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := !x[1] } ), oLbx:Refresh() ) //"Inverter a sele็ใo"

Return

Static Function FormProd(nopcao)
	Local oOk		:= LoadBitmap( GetResources(), "LBOK" ) //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local aRet		:= {}
	Local aParamBox := {}
	Local cProduto	:= aLbx[oLbx:nAt,2]
	Local nQtde		:= Val(aLbx[oLbx:nAt,3])
	Local nQEmb		:= Val(aLbx[oLbx:nAt,4])
	Local cQtde		:= aLbx[oLbx:nAt,3]
	Local cQEmb		:= aLbx[oLbx:nAt,4]

	Local nQVol		:= 0
	Local nResto	:= 0
	Local cLote		:= aLbx[oLbx:nAt,7]
	//Local cNumSer		:= aLbx[oLbx:nAt,8]
	//Local _cParcial	:= aLbx[oLbx:nAt,8] xx
	Local _nFrac	:= 0 //aLbx[oLbx:nAt,3] //Qtd Francionada
	Local nAt		:= oLbx:nAt

	Local nMv
	Local aMvPar	:={}
	Local lRastro 	:=.T. //Rastro(cProduto)
	Local lEndere 	:=.F. //Localiza(cProduto)
	Local nT		:= TamSx3("D3_QUANT")[1]
	Local nD		:= TamSx3("D3_QUANT")[2]
	Local __aArea	:= {}
	Local aCombo	:= {}
	//Local aCombo1 := {"Nใo","Sim"} xx

	If Alltrim(MV_PAR05)=="Sim"

		If IsInCallSteck("U_STFSPC31")
			_nFrac	:= strtran(str(val(aLbx[oLbx:nAt,3])),"0","")//aLbx[oLbx:nAt,3] //Qtd Francionada
		EndIf

	Else
		_nFrac	:= " " //Qtd Francionada
	EndIf

	__aArea	:= GetArea()

	DbSelectArea("SD1")
	SD1->(DbGoTop())
	SD1->(DbGoTo(aLbx[oLbx:nAt,10]))

	//Chamado 000066 - Ajuste de lote que estava incorreto
	If IsInCallSteck("U_STFSRE21")
		cLote	:= Posicione("QEK",15,xFilial("QEK")+SF1->F1_DOC+SF1->F1_SERIE+DTOS(SF1->F1_EMISSAO)+SD1->D1_ITEM,"QEK_LOTE") //QEK_NTFISC+QEK_SERINF+QEK_DTNFIS+QEK_ITEMNF
	EndIf

	If Empty(cLote)
		cLote	:= aLbx[oLbx:nAt,7]
	EndIf

	RestArea(__aArea)

	For nMv := 1 To 40
		aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv

	//Codigo EAN
	If Alltrim(MV_PAR05)=="Sim"
		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		SB5->(DbGoTop())
		If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))

			If SB5->B5_EAN141>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN141))
			EndIf
			IF SB5->B5_EAN142>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN142))
			EndIf
			If SB5->B5_EAN143>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN143))
			EndIf
			If SB5->B5_EAN144>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN144))
			EndIf
			If SB5->B5_EAN145>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN145))
			EndIf
			If SB5->B5_EAN146>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN146))
			EndIf
			If SB5->B5_EAN147>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN147))
			EndIf
			If SB5->B5_EAN148>0
				AADD(aCombo,CVALTOCHAR(SB5->B5_EAN148))
			EndIf
		EndIf
		If Len(aCombo)=0
			MsgAlert("Produto nใo possui EAN14 cadastrado!")
			Return(.F.)
		EndIf
	EndIf

	/*
	aPergs :={	{1,"Produto"	,cProduto	,"","",""	,".F.",60,.F.},; //"Produto"
	{1,"Quantidade"	,cQtde 		,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.F.},; //"Quantidade"
	IIf(AllTrim(MV_PAR05)=="Sim",{2,"Selecione EAN14",,aCombo,50,"NAOVAZIO()",.T.},;
	{1,"Qtd por Embalagem"	,cQEmb 		,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.t.}),;  //"Qtd por Embalagem"
	{1,"Lote"	,cLote 		,"","",""	,If(lRastro,".T.",".F."),0,.F.},;//} //"Lote"
	{1,"Fracionada"	,_nFrac	,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.F.}} //"Qtd Fracionada",
	*/

	aAdd( aParamBox ,{1,"Produto"	,cProduto	,"","",""	,".F.",60,.F.})
	aAdd( aParamBox ,{1,"Quantidade"	,cQtde 		,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.F.})

	If AllTrim(MV_PAR05) == "Sim"

		aAdd( aParamBox , {2,"Selecione EAN14",,aCombo,50,"NAOVAZIO()",.T.})
	Else
		If _lQtdUni
			cQEmb := "1"
			aAdd( aParamBox , {1,"Qtd por Embalagem"	,cQEmb 		,"",'PesqPict("SD3","D3_QUANT")',""	,".F.",0,.t.})
		Else
			aAdd( aParamBox , {1,"Qtd por Embalagem"	,cQEmb 		,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.t.})
		EndIf
	EndIf

	aAdd( aParamBox , {1,"Lote"	,cLote 		,"","",""	,If(lRastro,".T.",".F."),0,.F.} )

	If AllTrim(MV_PAR05) == "Sim"
		aAdd( aParamBox , {1,"Fracionada"	,_nFrac	,"",'PesqPict("SD3","D3_QUANT")',""	,".T.",0,.F.} )
	EndIf

	//					{1,"Serie"	,cNumSer 	,"","",""	,If(lEndere,".T.",".F."),0,.F.}} //"Serie"

	If ! ParamBox(aParamBox,If(nopcao == 1,"Alterar","Copiar" ),@aRet,,,,,,,,.f.)    //"Alterar","Copiar"
		For nMv := 1 To Len( aMvPar )
			&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
		Next nMv
		oLbx:SetArray( aLbx )
		oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
		oLbx:Refresh()
		Return
	EndIf

	If Len(aRet) == 5
		_nFrac := aRet[5]
	EndIF

	If !Empty(_nFrac)
		nQtde 	:= val("1")//Etiqueta Fracionada so imprimi uma de cada fez
	Else
		nQtde 	:= val(aRet[2])
	EndIf

	If Empty(nQtde)
		If nOpcao == 2
			MsgAlert("Para a copia a quantidade nใo pode estar em branco!") //"Para a copia a quantidade nใo pode estar em branco!"
		EndIf
		If MsgYesNo("Quantidade informada igual a zero, deseja excluir esta linha?") //"Quantidade informada igual a zero, deseja excluir esta linha?"
			aDel(aLbx,nAt)
			aSize(aLbx,len(albx)-1)
		EndIf
	Else
		nQEmb	:= val(aRet[3])
		cLote 	:= aRet[4]
		//	cNumSer	:= aRet[5]

		If !Empty(_nFrac)

			If Val(_nFrac) >= nQEmb

				MsgAlert("A quantidade fracionada nใo pode ser maior que a quantidade por embalagem, por favor verifique!")

				aLbx[nAt,3] := str(0,nT,nD)
				aLbx[nAt,4] := str(nQEmb,nT,nD)
				aLbx[nAt,5] := str(nResto,nT,nD)
				aLbx[nAt,6] := str(nQVol,nT,nD)

				aLbx[nAt,7] := cLote
				aLbx[nAt,8] := str(0,nT,nD)

			Else

				nQVol	:= Int(nQtde/nQEmb)
				nResto	:= nQtde%nQEmb
				If nResto >0
					nQVol++
				EndIf

				If nOpcao == 2
					aadd(aLbx,aClone(aLbx[nAt]))
					nAt := Len(aLbx)
				EndIf
				aLbx[nAt,3] := str(1,nT,nD)
				aLbx[nAt,4] := str(nQEmb,nT,nD)
				aLbx[nAt,5] := str(nResto,nT,nD)
				aLbx[nAt,6] := str(nQVol,nT,nD)

				aLbx[nAt,7] := cLote
				//	aLbx[nAt,8] := cNumSer
				aLbx[nAt,8] := _nFrac

			EndIF

		Else

			//<<

			nQVol	:= Int(nQtde/nQEmb)
			nResto	:= nQtde%nQEmb
			If nResto >0
				nQVol++
			EndIf

			If nOpcao == 2
				aadd(aLbx,aClone(aLbx[nAt]))
				nAt := Len(aLbx)
			EndIf
			aLbx[nAt,3] := str(nQtde,nT,nD)
			aLbx[nAt,4] := str(nQEmb,nT,nD)
			aLbx[nAt,5] := str(nResto,nT,nD)
			aLbx[nAt,6] := str(nQVol,nT,nD)

			aLbx[nAt,7] := cLote
			//	aLbx[nAt,8] := cNumSer
			aLbx[nAt,8] := _nFrac

		EndIf
	EndIf

	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()

	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
Return .t.

Static Function VldaLbx()
	Local nx
	Local nMv
	SB1->(DbSetOrder(1))
	For nX := 1 to Len(aLbx)
		If aLbx[nx,1] .and. ! Empty(aLbx[nX,3])
			exit
		EndIf
	Next
	If nX > len(aLbx)
		MsgAlert("Necessario marcar pelo menos um item com quantidade para imprimir!") //"Necessario marcar pelo menos um item com quantidade para imprimir!"
		Return .f.
	EndIf
	aSvPar := {}
	For nMv := 1 To 40
		aAdd( aSvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv

Return .t.

Static Function Imprime(cOrigem)
	Local cLocImp := MV_PAR01
	Local nX
	Local cProduto
	Local nQtde
	Local nQE
	Local nQVol
	Local nResto
	Local cAliasOri
	Local nRecno
	Local cLote
	Local cNumSerie
	//Local _cParcial1
	Local _nFrac1
	Local nMv

	If ! CBYesNo("Confirma a Impressao de Etiquetas","Aviso")  //"Confirma a Impressao de Etiquetas"###"Aviso"
		Return .f.
	EndIf

	If ! CB5SetImp(cLocImp)
		MsgAlert("Local de Impressใo "+cLocImp+" nao Encontrado!") //"Local de Impressใo "###" nao Encontrado!"
		Return .f.
	Endif

	For nMv := 1 To Len( aSvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aSvPar[ nMv ]
	Next nMv

	SB1->(DbSetOrder(1))
	For nX := 1 to Len(aLbx)
		If ! aLbx[nx,1]
			Loop
		EndIf
		cProduto:= aLbx[nx,2]
		nQtde	:= val(aLbx[nx,3])
		If Empty(nQtde)
			Loop
		EndIf
		nQE		:= val(aLbx[nx,4])
		nResto	:= val(aLbx[nx,5])
		nQVol 	:= val(aLbx[nx,3])
		If nResto > 0 .And. MV_PAR04 <> "Pequeno"
			nQVol--
		EndIf
		cLote	 	:= aLbx[nx,7]
		//cNumSerie	:= aLbx[nx,8]
		_nFrac1	 	:= aLbx[nx,8]
		cAliasOri	:= aLbx[nx,9]
		nRecno		:= aLbx[nx,10]

		(cAliasOri)->(DbGoto(nRecno)) //posiciona na tabela de origem da informa็ใo

		SB1->(DbSeek(xFilial('SB1')+cProduto))
		//	If nQVol > 0
		//ExecBlock("IMG01",,,{nQE,,,nQtde,,,,,,,,cLote,Space(6),,,,,cNumSerie})
		ExecBlock("IMG01",,,{nQE,,,nQtde,,,,,,,,cLote,Space(6),,,,,_nFrac1})
		//	EndIf
		/*
		If nQE > nResto
		ExecBlock("IMG01",,,{nQE,,,1,,,,,,,,cLote,Space(6),,,,,cNumSerie})
		ElseIf nResto > 0
		ExecBlock("IMG01",,,{nResto,,,1,,,,,,,,cLote,Space(6),,,,,cNumSerie})
		EndIf
		*/
	Next
	MSCBCLOSEPRINTER()

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCOLETI   บAutor  ณRenato Nogueira     บ Data ณ  09/02/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte para imprimir etiqueta de produto pelo coletor        บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum 	    									          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCOLETI()

	Etiqueta("1")
	/*
	Local 		lRet				:= .T.
	Local 		cProduto			:= Space(15)
	Local 		cColetivo			:= Space(1)
	Local 		cTamanho			:= Space(1)
	Local 		cQuantidade			:= Space(5)
	Local 		cLote				:= Space(20)
	Local 		cLocal				:= Space(6)
	Private 	aSvPar				:= {}
	Private 	aLbx				:= {}
	Private 	oLbx
	Private 	paramixb

	VTCLEARBUFFER()
	VTCLEAR

	While lRet

	@ 1,0  VTSAY "Produto:"
	@ 2,0  VTGET cProduto  		PICTURE "@!" F3 "SB1" VALID ExistCpo("SB1",cProduto)
	@ 3,0  VTSAY "Coletivo:"
	@ 4,0  VTGET cColetivo 		PICTURE "@!" VALID Iif(!cColetivo $ "S#N",(VtAlert("Atencao, informacao diferente de S/N!"),.F.),.T.)
	@ 5,0  VTSAY "Tamanho:"
	@ 6,0  VTGET cTamanho  		PICTURE "@!" VALID Iif(!cTamanho  $ "P#G",(VtAlert("Atencao, informacao diferente de P/G!"),.F.),.T.)

	VTREAD

	DbSelectArea("SB1")
	SB1->(DbGoTop())
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))

	If VTLASTKEY()==27
	If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
	Return
	Endif
	Endif

	If Empty(cProduto) .Or. Empty(cColetivo) .Or. Empty(cTamanho)
	Loop
	Else
	Exit
	EndIf

	EndDo

	lRet	:= .T.

	While lRet

	VTCLEARBUFFER()
	VTCLEAR

	@ 1,0  VTSAY "Quantidade:"
	@ 2,0  VTGET cQuantidade  	PICTURE "@!"
	@ 3,0  VTSAY "Lote:"
	@ 4,0 	VTGET cLote  			PICTURE "@!"
	@ 5,0  VTSAY "Local de impressao:"
	@ 6,0 	VTGET cLocal 			PICTURE "999999" F3 "CB5"

	VTREAD

	If VTLASTKEY()==27
	If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
	Return
	Endif
	Endif

	If Empty(cQuantidade) .Or. Empty(cLote) .Or. Empty(cLocal)
	Loop
	EndIf

	aLbx:={{.T.,SB1->B1_COD,"1",cQuantidade,"0","0",cLote,Space(20),"SB1",SB1->(Recno())}}

	MV_PAR01	:= cLocal
	If ExistBlock("IMG01")
	SetFunName("U_STFSPC30")
	Imprime("Produto")
	SetFunName("U_STCOLETI")
	lRet	:= .F.
	VTALERT("IMPRESSAO FINALIZADA")
	EndIf

	EndDo
	*/
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCOLETI   บAutor  ณRenato Nogueira     บ Data ณ  09/02/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte para imprimir etiqueta de produto pelo coletor        บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum 	    									          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCOLET2()

	Etiqueta("2")

Return

Static Function Etiqueta(_cTipo)
	Local aArea		:= CB8->(GetArea()) //RENATO/LEO 180413 QUANDO MANDAVA IMPRIMIR PELO CTRL+B E VOLTAVA APRESENTAVA ENDERECO INVALIDO
	Local aTela 	:= VTSave()
	Local cEtiProd := Space(48)
	Local cLoteX	:= ""
	Private cOpcSel	:= ""

	While .t.

		cEtiProd := Space(48)
		cLocImp	 := CB1->CB1_XLOCIM
		cOp		 := ""

		aEtiqueta:= {}
		VtClear()
		@ 0,0 VTSay "Leia a etiqueta"
		@ 1,0 VTGet cEtiProd pict "@!" Valid VldProduto(cEtiProd,aEtiqueta)

		If _cTipo=="2"
			cOp := Space(14)
			@ 2,0 VtSay "OP"
			@ 3,0 VtGet cOp pict "999999" F3 'SC2' Valid ! Empty(cOp)
			_cFun1 := "U_STFSRE23"
			_cFun2 := "U_STCOLETI"
		Else
			_cFun1 := "U_STFSPC30"
			_cFun2 := "U_STCOLETI"
		EndIf

		@ 4,0 VtSay "Local de Impresao"
		@ 5,0 VtGet cLocImp pict "999999" F3 'CB5' Valid ! Empty(cLocImp)

		VTRead
		If VtLastkey() == 27
			Exit
		EndIf
		If ! VTYesNo("Confirma a Impressใo de Etiqueta","Atencao")
			Loop
		EndIf
		VTMSG("Imprimindo..")
		If !CB5SetImp(cLocImp)
			CBAlert("Local de impressใo "+cLocImp+" nใo existe!!!","Aten็ใo")
			Return
		EndIf
		cLoteX := U_RetLoteX()

		If ExistBlock("IMG01")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial('SB1')+aEtiqueta[1]))
			SetFunName(_cFun1)
			ExecBlock("IMG01",,,{aEtiqueta[2],,,1,,,,,,cOp,,cLoteX,Space(6),,,,,Space(20)})
			SetFunName(_cFun2)
		EndIf
		MSCBCLOSEPRINTER()
	End

	VtRestore(,,,,aTela)
	RestArea(aArea)               //RENATO/LEO 180413 QUANDO MANDAVA IMPRIMIR PELO CTRL+B E VOLTAVA APRESENTAVA ENDERECO INVALIDO
Return

Static Function VldProduto(cEtiqueta,aEtiqueta)
	Local _cEtiqueta	:= AllTrim(cEtiqueta)+"|"
	Local aEti 			:= CBRetEtiEan(_cEtiqueta)
	Local cProduto		:= Space(15)
	Local cLote       := Space(10)
	Local cSLote      := Space(6)

	If len(aEti) == 0
		VtAlert("Etiqueta invalida","Atencao [ENTER]")
		VtKeyBoard(chr(20))
		Return .f.
	EndIf
	If Empty(aEti[1])
		VtAlert("Produto nใo encontrado","Atencao [ENTER]")
		VtKeyBoard(chr(20))
		Return .f.
	EndIf

	cProduto := aEti[1]
	cLote 	:= aEti[3]

	If ! CBRastro(cProduto,@cLote,@cSLote)
		Return .f.
	EndIf
	aEti[3] 	:= cLote
	aEtiqueta := aClone(aEti)

Return .t.
