#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTRACKING       | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição | STTRACKING                                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRACKING                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTRACKING(_cStPed)
	*-----------------------------*

	Local aArea 	:= GetArea()
	Local aSC5Area  := SC5->(GetArea())
	Local aSC6Area	:= SC6->(GetArea())
	Local _nLo      := 0
	Local _nko      := 0
	Local nx:=1
	Local _nXLo     := 12
	Local _nZLo     := 17
	Local nOpcao    := 2
	Local _cte      := space(1)
	Local aSize     := MsAdvSize()
	Local lSaida    := .T.
	Local _cRoman   := ""
	Private _cCodEntreg:=''
	Private _lsepaO    := .f.
	Private _lEmbx     := .f.
	Private _cxOrdsep  := ''
	Private _dEmiRom   := CTOD('  /  /    ')
	Private _dEntRom   := CTOD('  /  /    ') //Chamado 008304 - Everson Santana - 01/11/218
	Private _dEmissa   := CTOD('  /  /    ')
	Private oGetDados2
	Private oBmp
	Private aCols      := {}
	Private nCntFor2   :=0
	Private nCntFor3   :=0
	Private nCntFor6   :=0
	Private nCntFor7   :=0
	Private nCntFor0   :=0
	Private nCntFor8   :=0
	Private aTam       := {}
	Private aHeader    := {}
	Private aHeader2   := {}
	Private aHeader4   := {}
	Private aHeader6   := {}
	Private acols7     := {}
	Private aHeader7   := {}
	Private oGet7Dados
	Private acols8     := {}
	Private aHeader8   := {}
	Private oGet8Dados
	Private acols0     := {}
	Private aHeader0   := {}
	Private oGetDados0
	Private oGet3Dados
	Private oGet4Dados
	Private oGet5Dados
	Private oGet6Dados
	Private aCols2   := {}
	Private aCols4   := {}
	Private aCols5   := {}
	Private aCols6   := {}
	Private _lEmbax  :=.f.
	Private _lxbloreg  :=.f.
	Private _lBloq  :=.f.
	Private _lLibe  :=.f.
	Private _lFat   :=.f.
	Private _lRej   :=.f.
	Private _cPedido:= ''
	Private _cRet := ''
	Private _lBloqRet := .F.
	Private _lLibRet := .F.
	Private _lRejRet := .F.
	Private	oWindow,;
	oFontWin,;
	aFolders	    := {},;
	aHead			:= {},;
	bOk 			:= {||(	lSaida:=.t.,oWindow:End()) },;
	bCancel 	    := {||(	lSaida:=.f.,oWindow:End()) },;
	aButtons	    := {},;
	_cMsgCic	    := '',;
	cTitWin

	Define FONT oFontCn NAME "Courier"
	Define FONT oFontCb NAME "Courier" BOLD
	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD
	Private oFontN  := TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	:= TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontt  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	Private	nRegSM0	:= SM0->(Recno())

	Private	cNumCham:= Space(8),;
	cDesCham	    := Space(80),;
	dDtAbert	    := dDataBase,;
	dHrAbert	    := Time(),;
	cSolCham	    := __cUserId,;
	cEmpCham	    := cEmpAnt+'/'+cFilAnt,;
	cTipCham	    := Space(4),;
	cPriCham 	    := Space(4),;
	cModCham	    := Space(3),;//cModulo,;
	cProgCham	    := Space(15),;
	mAberOcor ,;
	oAberOcor ,;
	mSoluOcor ,;
	oSoluOcor ,;
	mComentar ,;
	oComentar ,;
	dDtFecha	    := Ctod('  /  /  '),;
	dHrFecha	    := '  :  :  ',;
	cTecCham	    := Space(6),;
	cClasFech	    := Space(4),;
	cTecAloc	    := Space(6)

	Private	nOpcao 	:= 2,;	// Numero da opcao selecionada..
	lSave		    := .f.,;				// Variavel controla se tem ou nao que salvar.
	lEdite		    := .f.				// Controla se edita ou nao os dados.

	Private	_oTipCham,;
	_cTipCham		:= Space(20),;
	_oPriCham,;
	_cPriCham		:= Space(20),;
	_oSolCham,;
	_cSolCham		:= Space(20),;
	_oEmpCham,;
	_cEmpCham		:= Space(20),;
	_oTecAloc,;
	_cTecAloc		:= Space(20),;
	_oTecCham,;
	_cMailTec,;
	_cTecCham		:= Space(20),;
	_oClasFech,;
	_cClasFech		:= Space(20),;
	_oModulo,;
	_oModCham,;
	_oPrograma,;
	_oProgCham,;
	_cVendNew       := Space(6),;
	oRadio,;
	nRadio 			:= 1

	default _cStPed := SC5->C5_NUM

	//Robson Mazzarotto chamado 004654
	_cRoman := Posicione('PD2',2,xFILIAL('PD2')+SC5->C5_NOTA+SC5->C5_SERIE,"PD2_CODROM")

	aAdd(aButtons,{"DBG06"  , {|| U_STXTRACK('1')} ,"Troca Pedido"})


	If ValType(_cStPed) <> "C"
		If   u_STXTRACK('2') <> 1
			Return(.T.)
		EndIf
	Else
		_cPedido:= _cStPed
	EndIf

	U_STXFINA() //Status Financeiro


	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+_cPedido))
		dbSelectArea("SA1")
		SA1->(DbClearFilter())
		SA1->(dbSetOrder(1))
		If 	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Define os Folders.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aFolders,OemToAnsi('&Geral'))
			aAdd(aHead,'HEADER 1')
			aAdd(aFolders,OemToAnsi('&Bloqueios'))
			aAdd(aHead,'HEADER 2')
			aAdd(aFolders,OemToAnsi('&Financeiro'))
			aAdd(aHead,'HEADER 3')
			aAdd(aFolders,OemToAnsi('&Separação'))
			aAdd(aHead,'HEADER 4')
			aAdd(aFolders,OemToAnsi('&Embalagem'))
			aAdd(aHead,'HEADER 5')
			aAdd(aFolders,OemToAnsi('&Faturamento'))
			aAdd(aHead,'HEADER 6')
			aAdd(aFolders,OemToAnsi('&Romaneio'))
			aAdd(aHead,'HEADER 7')
			aAdd(aFolders,OemToAnsi('&Reservas/Faltas'))
			aAdd(aHead,'HEADER 8')

			While lSaida
				DEFINE MSDIALOG oWindow FROM 90,200 TO 610,1350 TITLE Alltrim(OemToAnsi('Tracking Pedido')) Pixel //430,531

				//	Box(045,005,580,800)
				nAjusteTela := 30
				_nLo:=_nXLo + nAjusteTela
				_nko:=_nXLo + nAjusteTela
				@ 003 + nAjusteTela, 005 To 100 + nAjusteTela,315 Label OemToAnsi('Dados do Pedido') Of oWindow Pixel
				@ _nLo, 011 							Say 'Pedido:             '+SC5->C5_NUM  Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				If alltrim(SC5->C5_ZORCAME) <> ''
					_nLo+=_nXLo
					@ _nLo, 011 Say 'Orçamento:      '+SC5->C5_ZORCAME     Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				EndIf
				If alltrim(SC5->C5_XORDEM) <> ''
					_nLo+=_nXLo
					@ _nLo, 011 Say 'Ord. Compra:   '+SC5->C5_XORDEM     Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				EndIf
				_nLo+=_nXLo
				@ _nLo, 011 Say 'Cliente:            '+SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI Of oWindow Pixel  COLOR CLR_BLUE    FONT oFontN
				_nLo+=_nXLo
				@ _nLo, 011 Say 'Nome:              '+substr(alltrim(Posicione('SA1',1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")),1,35) Of oWindow Pixel  COLOR CLR_BLUE    FONT oFontN
				_nLo+=_nXLo
				@ _nLo, 011 Say 'Emissão:          '+dToc(SC5->C5_EMISSAO)      Of oWindow Pixel   COLOR CLR_BLUE    FONT oFontN
				_nLo+=_nXLo
				@ _nLo, 011 Say 'Bloqueado:          '+IIF(alltrim(Posicione('SA1',1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MSBLQL"))=="1","SIM","NAO") Of oWindow Pixel  COLOR CLR_BLUE    FONT oFontN
				
				If cEmpAnt $ "01#11"
					_nLo+=_nXLo
					@ _nLo, 011 Say 'Bloq. Ger. OS:      '+GetBloqs() Of oWindow Pixel  COLOR CLR_BLUE    FONT oFontN
				EndIf

				@ 003 + nAjusteTela,313 To 100 + nAjusteTela,574 Label OemToAnsi('Situação do Pedido') Of oWindow Pixel
				@ _nko, 317  Say 'Bloqueios:            '+iif(SC5->C5_ZBLOQ   = '1','Bloqueado','Liberado') Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko, 317  Say 'Financeiro:           '+STFIN()  Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko,317   Say 'Separação:           '      Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				@ _nko,380   Say    Alltrim(STSEP())     Of oWindow Pixel COLOR CLR_BLUE    FONT oFontt
				//iif(_cxOrdsep$'01/02','Separando',iif(_cxOrdsep$'03/04/05/06/07/08/09/10','Finalizado','Sem Separação')) Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko,317   Say 'Embalagem:         '      Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				@ _nko,380   Say  Alltrim(STEMB())       Of oWindow Pixel COLOR CLR_BLUE    FONT oFontt
				//iif(_cxOrdsep$'03','Embalando',iif(_cxOrdsep$'04/05/06/07/08/09/10','Embalado','Sem Embalagem')) Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko,317   Say 'Faturamento:        '+iif(SC5->C5_ZFATBLQ = '1','Total',iif(SC5->C5_ZFATBLQ = '2','Parcial','Não Faturado')) Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko,317   Say 'Romaneio:            '+iif(Alltrim(_cCodEntreg)<>'','Gerado','Sem Romaneio')  Of oWindow Pixel COLOR CLR_BLUE    FONT oFontN
				_nko+=_nXLo
				@ _nko,317   Say 'Retrabalho EAN14:    '+iif(SC5->C5_XREAN14 $ 'S','Pendente','NAO')  Of oWindow Pixel COLOR iif(SC5->C5_XREAN14 $ 'S',CLR_RED,CLR_BLUE)    FONT oFontN // Chamado 007986 Jefferson 26/09/18
				oFolder := TFolder():New(100 + nAjusteTela,005,aFolders,aHead,oWindow,,,,.T.,.F.,570,140 - nAjusteTela)
				For nx:=1 to Len(aFolders)
					DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nx]
				Next nx

				//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Geral³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
				nLo:=_nZLo

				oGetDados0 := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[1], aHeader0, aCols0)
				oGetDados2 := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[3], aHeader, aCols)
				oGet3Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[2], aHeader2, aCols2)
				oGet4Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[4], aHeader4, aCols4)
				oGet5Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[5], aHeader4, aCols5)
				oGet6Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[6], aHeader6, aCols6)
				oGet7Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[7], aHeader7, aCols7)
				oGet8Dados := MSNewGetDados():New (01,01,97,567 , 0 , , , , , , , , , ,oFolder:aDialogs[8], aHeader8, aCols8)
				ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,bOk,bCancel,,aButtons)

			End
		EndIf
	EndIf


	If !Empty(alltrim(_cXCodVen361))
		SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
	EndIf
	Return()

	/*====================================================================================\
	|Programa  | ValidTra         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | ValidTra                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ValidTra                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ValidTra()
	*-----------------------------*
	Local _lret := .f.

	_lret := .t.
	lSaida:=.T.
	oWindow:End()

	Return(_lret)

	/*====================================================================================\
	|Programa  | STXTRACK         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STXTRACK                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STXTRACK                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STXTRACK(_cx)
	*-----------------------------*
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Pedido") From 1,0 To 08,25 OF oMainWnd

	@ 05,04 SAY "Pedido: " PIXEL OF oDlgEmail
	@ 15,10 MSGet _cVendNew 	F3 'SC5ST'	  Size 35,012  PIXEL OF oDlgEmail Valid(existcpo("SC5",_cVendNew)  .Or. alltrim(_cVendNew) = '')
	@ 40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	nOpca:=0
	ACTIVATE MSDIALOG oDlgEmail CENTERED
	If nOpca == 1
		_cPedido:=  _cVendNew
	Else
		Return(2)
	Endif
	If _cx ='1'
		Eval(bOk)
	Endif
	U_STXFINA()
	Return(nOpca)

	/*====================================================================================\
	|Programa  | STXFINA          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STXFINA                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STXFINA                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STXFINA(_cStPed)
	*-----------------------------*
	Local	nCntFor0 := 0
	Local	nCntFor1 := 0
	Local	nCntFor2 := 0
	Local	nCntFor3 := 0
	Local	nCntFor4 := 0
	Local	nCntFor5 := 0
	Local	nCntFor6 := 0
	Local	nCntFor7 := 0
	Local	nCntFor8 := 0

	U_STHEADTRA()//CRIA AHEADERS


	//folder bloqueios  **************************************************************************************************************************************************8
	dbSelectArea("SA1")
	SA1->(DbClearFilter())
	SA1->(dbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	AADD(aCols2,Array(Len(aHeader2) + 1))
	For nCntFor3 := 1 To Len(aHeader2)
		If SC5->C5_ZBLOQ = '1'
			If  nCntFor3 = 1  .and. 'MSG' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 2 .and. 'COND' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 3 .and. 'DESC' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 4 .and. 'PSC' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 5 .and. 'VLR' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 6 .and. 'OPE' $ SC5->C5_ZMOTBLO
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			ElseIf  nCntFor3 = 7 .and. SA1->A1_XBLQFIN = '1'
				_lxbloreg:=.t.
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			Else
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERDE" ) 
			EndIf
		Else
			If  nCntFor3 <> 7
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERDE" )
			ElseIf  nCntFor3 = 7 .and. SA1->A1_XBLQFIN = '1'
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
			Else
				aCols2[Len(aCols2)][nCntFor3] := LoaDbitmap( GetResources(), "BR_VERDE" )
			EndIf
		EndIf



	Next nCntFor3

	aCols2[Len(aCols2)][Len(aHeader2)+1] := .F.


	//AADD(aCols2,{'Blq.Financeiro',Iif(SA1->A1_XBLQFIN = '1',LoaDbitmap( GetResources(), "BR_VERMELHO"),LoaDbitmap( GetResources(), "BR_VERDE")),,,,,.F.  })






	//folder financeiro **************************************************************************************************************************************************8

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+_cPedido))
	do While SC6->(! Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+_cPedido
		DbSelectArea('SC6')

		//______________GERAL__________________________________________________________________________________________________________________________
		AADD(aCols0,Array(Len(aHeader0) + 1))

		For nCntFor0 := 1 To Len(aHeader0)
			If    ( alltrim(aHeader0[nCntFor0][3]) =  "@BMP")
				If SC6->C6_QTDENT = 0
					aCols0[Len(aCols0)][nCntFor0] := LoaDbitmap( GetResources(), "BR_VERDE" )
				EndIf
				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT = SC6->C6_QTDVEN
					aCols0[Len(aCols0)][nCntFor0] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
				EndIf

				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT <> SC6->C6_QTDVEN
					aCols0[Len(aCols0)][nCntFor0] := LoaDbitmap( GetResources(), "BR_AMARELO" )
				EndIf
			ElseIf  ( alltrim(aHeader0[nCntFor0][2]) =  "FATURAMENTO")
				If SC6->C6_QTDENT = 0
					aCols0[Len(aCols0)][nCntFor0] := 'Não Faturado'
				EndIf
				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT = SC6->C6_QTDVEN
					aCols0[Len(aCols0)][nCntFor0] := 'Total'
				EndIf

				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT <> SC6->C6_QTDVEN
					aCols0[Len(aCols0)][nCntFor0] := 'Parcial'
				EndIf

			ElseIf ( aHeader0[nCntFor0][10] != "V" )
				aCols0[Len(aCols0)][nCntFor0] := FieldGet(FieldPos(aHeader0[nCntFor0][2]))
			Else
				aCols0[Len(aCols0)][nCntFor0] := CriaVar(aHeader0[nCntFor0][2])
			EndIf
		Next nCntFor0
		acols0[Len(acols0)][Len(aHeader0)+1] := .F.
		//________________________________________________________________________________________________________________________________________

		//____________FINANCEIRO____________________________________________________________________________________________________________________________
		DbSelectArea('SC9')
		SC9->(DbSetOrder(1))
		SC9->(DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
		While SC9->(! Eof()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM

			AADD(aCols,Array(Len(aHeader) + 1))

			For nCntFor2 := 1 To Len(aHeader)
				If    ( alltrim(aHeader[nCntFor2][3]) =  "@BMP")

					If Empty(alltrim(SC9->C9_BLCRED))
						aCols[Len(aCols)][nCntFor2] := LoaDbitmap( GetResources(), "BR_VERDE" )
					EndIf
					If !(alltrim(SC9->C9_BLCRED) $ '09/10') .And. !Empty(alltrim(SC9->C9_BLCRED))  .And. SC5->C5_ZBLOQ <> '1'
						aCols[Len(aCols)][nCntFor2] := LoaDbitmap( GetResources(), "BR_AMARELO" )
					EndIf

					If alltrim(SC9->C9_BLCRED) = '10'
						aCols[Len(aCols)][nCntFor2] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
					EndIf
					If alltrim(SC9->C9_BLCRED) = '09'
						aCols[Len(aCols)][nCntFor2] := LoaDbitmap( GetResources(), "BR_PRETO" )
					EndIf

					If SC5->C5_ZBLOQ = '1'
						aCols[Len(aCols)][nCntFor2] := LoaDbitmap( GetResources(), "BR_AZUL" )
					EndIf


				ElseIf  ( alltrim(aHeader[nCntFor2][2]) =  "TOTAL")
					aCols[Len(aCols)][nCntFor2] := SC9->C9_QTDLIB*SC9->C9_PRCVEN

				ElseIf  ( alltrim(aHeader[nCntFor2][2]) =  "STATUS")
					If Empty(alltrim(SC9->C9_BLCRED))
						aCols[Len(aCols)][nCntFor2] := 'LIBERADO'
					EndIf
					If !(alltrim(SC9->C9_BLCRED) $ '09/10') .And. !Empty(alltrim(SC9->C9_BLCRED)) .And. SC5->C5_ZBLOQ <> '1'
						aCols[Len(aCols)][nCntFor2] := 'EM ANÁLISE'
					EndIf

					If alltrim(SC9->C9_BLCRED) = '10'
						aCols[Len(aCols)][nCntFor2] := 'FATURADO'
					EndIf
					If alltrim(SC9->C9_BLCRED) = '09'
						aCols[Len(aCols)][nCntFor2] := 'REJEITADO'
					EndIf
					If SC5->C5_ZBLOQ = '1'
						aCols[Len(aCols)][nCntFor2] := 'BLOQUEADO'
					EndIf



				ElseIf ( aHeader[nCntFor2][10] != "V" )
					aCols[Len(aCols)][nCntFor2] := FieldGet(FieldPos(aHeader[nCntFor2][2]))
				Else
					aCols[Len(aCols)][nCntFor2] := CriaVar(aHeader[nCntFor2][2])
				EndIf



			Next nCntFor2

			acols[Len(acols)][Len(aHeader)+1] := .F.


			//____________separação & embalagem____________________________________________________________________________________________________________________________
			If !Empty(Alltrim(SC9->C9_ORDSEP))
				AADD(aCols4,Array(Len(aHeader4) + 1))
				AADD(aCols5,Array(Len(aHeader4) + 1))

				For nCntFor4 := 1 To Len(aHeader4)

					_cxOrdsep := Posicione('CB7',1,xFILIAL('CB7')+Alltrim(SC9->C9_ORDSEP),"CB7_STATUS")

					DbSelectArea("SC9")

					If    ( alltrim(aHeader4[nCntFor4][3]) =  "@BMP")
						If _cxOrdsep = '0'
							acols4[Len(acols4)][nCntFor4] := LoaDbitmap( GetResources(), "BR_AZUL" )
						ElseIf _cxOrdsep = '1'
							acols4[Len(acols4)][nCntFor4] := LoaDbitmap( GetResources(), "BR_AMARELO" )
						ElseIf _cxOrdsep $ '2/3/4/5/6/7/8/9'
							acols4[Len(acols4)][nCntFor4] := LoaDbitmap( GetResources(), "BR_VERDE" )
						EndIf
						If _cxOrdsep = '2'
							acols5[Len(acols5)][nCntFor4] := LoaDbitmap( GetResources(), "BR_AZUL" )
						ElseIf _cxOrdsep = '3'
							acols5[Len(acols4)][nCntFor4] := LoaDbitmap( GetResources(), "BR_AMARELO" )
						ElseIf _cxOrdsep $ '4/5/6/7/8/9'
							acols5[Len(acols5)][nCntFor4] := LoaDbitmap( GetResources(), "BR_VERDE" )
						EndIf
					ElseIf  ( alltrim(aHeader4[nCntFor4][2]) =  "TOTAL")
						aCols4[Len(aCols4)][nCntFor4] := SC9->C9_QTDLIB*SC9->C9_PRCVEN
						aCols5[Len(aCols5)][nCntFor4] := SC9->C9_QTDLIB*SC9->C9_PRCVEN
					ElseIf  ( alltrim(aHeader4[nCntFor4][2]) =  "STATUS")
						If _cxOrdsep = '0'
							acols4[Len(acols4)][nCntFor4] := 'AGUARDANDO SEPARAÇÃO'
						ElseIf _cxOrdsep = '1'
							acols4[Len(acols4)][nCntFor4] := 'EM SEPARAÇÃO'
						ElseIf _cxOrdsep  $ '2/3/4/5/6/7/8/9' .Or. !Empty(Alltrim(SC9->C9_NFISCAL))
							acols4[Len(acols4)][nCntFor4] := 'SEPARAÇÃO FINALIZADA'
						EndIf
						If _cxOrdsep = '2'
							acols5[Len(acols5)][nCntFor4] := 'AGUARDANDO EMBALAGEM'
							_lEmbx:=.T.
						ElseIf _cxOrdsep = '3'
							acols5[Len(acols5)][nCntFor4] := 'EMBALANDO'
							_lEmbx:=.T.
						ElseIf _cxOrdsep  $ '4/5/6/7/8/9'  .Or. !Empty(Alltrim(SC9->C9_NFISCAL))
							acols5[Len(acols5)][nCntFor4] := 'EMBALAGEM FINALIZADA'
							_lEmbx:=.T.
						ElseIf _cxOrdsep  $ '0/1'
							acols5[Len(acols5)][nCntFor4] := 'AGUARDANDO SEPARAÇÃO'
						EndIf
					ElseIf ( aHeader4[nCntFor4][10] != "V" )

						If FieldPos(aHeader4[nCntFor4][2])==0
							DbSelectArea("SC9")
						EndIf

						acols4[Len(acols4)][nCntFor4] := FieldGet(FieldPos(aHeader4[nCntFor4][2]))
						acols5[Len(acols5)][nCntFor4] := FieldGet(FieldPos(aHeader4[nCntFor4][2]))
					Else
						acols4[Len(acols4)][nCntFor4] := CriaVar(aHeader4[nCntFor4][2])
						acols5[Len(acols5)][nCntFor4] := CriaVar(aHeader4[nCntFor4][2])
					EndIf




				Next nCntFor4

				If len(aCols4)>0
					acols4[Len(acols4)][Len(aHeader4)+1] := .F.
				Endif
				If len(aCols5) >0
					acols5[Len(acols5)][Len(aHeader4)+1] := .F.
				Endif
			EndIf

			//____________faturamento____________________________________________________________________________________________________________________________
			If !Empty(Alltrim(SC9->C9_NFISCAL))
				AADD(aCols6,Array(Len(aHeader6) + 1))
				For nCntFor6 := 1 To Len(aHeader6)

					_cxOrdsep := Posicione('CB7',1,xFILIAL('CB7')+Alltrim(SC9->C9_ORDSEP),"CB7_STATUS")
					_dEmissa  := Posicione('SF2',1,xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F2_EMISSAO")
					If   Empty(alltrim(dtos(_dEmissa)))
						_dEmissa  := Posicione('SF2',1,'01'+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F2_EMISSAO")
					EndIf
					If    ( alltrim(aHeader6[nCntFor6][3]) =  "@BMP")
						If _cxOrdsep $ '3/4' .And. Empty(Alltrim(SC9->C9_NFISCAL))
							acols6[Len(acols6)][nCntFor6] := LoaDbitmap( GetResources(), "BR_AZUL" )
						ElseIf !Empty(Alltrim(SC9->C9_NFISCAL)) .And. !('CANCEL' $ 	Posicione('SF3',6,xFilial("SF3")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F3_OBSERV"))
							acols6[Len(acols6)][nCntFor6] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
						ElseIf 'CANCEL' $ 	Posicione('SF3',6,xFilial("SF3")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F3_OBSERV")
							acols6[Len(acols6)][nCntFor6] := LoaDbitmap( GetResources(), "BR_VERDE" )
						EndIf

					ElseIf  ( alltrim(aHeader6[nCntFor6][2]) =  "TOTAL")
						aCols6[Len(aCols6)][nCntFor6] := SC9->C9_QTDLIB*SC9->C9_PRCVEN

					ElseIf  ( alltrim(aHeader6[nCntFor6][2]) =  "EMISSAO")  .and.  !Empty(Alltrim(SC9->C9_NFISCAL))
						aCols6[Len(aCols6)][nCntFor6] := _dEmissa
					ElseIf  ( alltrim(aHeader6[nCntFor6][2]) =  "STATUS")
						If _cxOrdsep $ '3'.And. Empty(Alltrim(SC9->C9_NFISCAL))
							acols6[Len(acols6)][nCntFor6] := 'AGUARDANDO EMBALAGEM'
						ElseIf _cxOrdsep $ '4'.And. Empty(Alltrim(SC9->C9_NFISCAL))
							acols6[Len(acols6)][nCntFor6] := 'EMBALAGEM FINALIZADA'
						ElseIf  !Empty(Alltrim(SC9->C9_NFISCAL)) .And. !('CANCEL' $ 	Posicione('SF3',6,xFilial("SF3")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F3_OBSERV"))
							acols6[Len(acols6)][nCntFor6] := 'NF EMITIDA'
						ElseIf 'CANCEL' $ 	Posicione('SF3',6,xFilial("SF3")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F3_OBSERV")
							acols6[Len(acols6)][nCntFor6] := 'NF CANCELADA'
						EndIf
					ElseIf ( aHeader6[nCntFor6][10] != "V" )
						//acols6[Len(acols6)][nCntFor6] := FieldGet(FieldPos(aHeader6[nCntFor6,2]))
						acols6[Len(acols6)][nCntFor6] := SC9->&(aHeader6[nCntFor6,2])
					Else
						acols6[Len(acols6)][nCntFor6] := CriaVar(aHeader6[nCntFor6][2])
					EndIf


				Next nCntFor6


				acols6[Len(acols6)][Len(aHeader6)+1] := .F.

			EndIf
			
			DbSelectArea("PD2")
			PD2->(DbSetOrder(2))
			
			//____________romaneio____________________________________________________________________________________________________________________________
			If !Empty(Alltrim(SC9->C9_NFISCAL))
				AADD(aCols7,Array(Len(aHeader7) + 1))
				For nCntFor7 := 1 To Len(aHeader7)

					_cCodEntreg := ""
					If PD2->(DbSeek(xFILIAL('PD2')+SC9->C9_NFISCAL+SC9->C9_SERIENF))
						_cCodEntreg := PD2->PD2_CODROM
					EndIf

					_dEmiRom    := Posicione('PD1',1,xFILIAL('PD1')+_cCodEntreg,"PD1_DTEMIS")
					_dEntRom	:= Posicione('PD1',1,xFILIAL('PD1')+_cCodEntreg,"PD1_DTENT") //Chamado 008304 - Everson Santana - 01/11/218
					_cObsPd1   := Alltrim(Posicione('SF2',1,xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F2_XOBSROM")) //Alltrim(Posicione('PD1',1,xFILIAL('PD1')+_cCodEntreg,"PD1_OBS"))

					If ( alltrim(aHeader7[nCntFor7][3]) =  "@BMP")
						If !Empty(_cCodEntreg)
							//acols7[Len(acols7)][nCntFor7] := LoaDbitmap( GetResources(), "BR_VERDE" )
							If PD2->PD2_STATUS=="4"
								acols7[Len(acols7)][nCntFor7] := LoaDbitmap( GetResources(), "BR_VERDE" )
							ElseIf PD2->PD2_STATUS=="5"
								acols7[Len(acols7)][nCntFor7] := LoaDbitmap( GetResources(), "BR_CINZA" )
							Else
								acols7[Len(acols7)][nCntFor7] := LoaDbitmap( GetResources(), "BR_BRANCO" )
							EndIf
						Else
							acols7[Len(acols7)][nCntFor7] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
						EndIf
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "EMISSAO")  .and. Alltrim(_cCodEntreg) <> ' '
						aCols7[Len(aCols7)][nCntFor7] := _dEmiRom
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "DT ENT ROM")  .and. Alltrim(_cCodEntreg) <> ' ' //Chamado 008304 - Everson Santana - 01/11/218 
						aCols7[Len(aCols7)][nCntFor7] := _dEntRom //Chamado 008304 - Everson Santana - 01/11/218
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "TOTAL")
						aCols7[Len(aCols7)][nCntFor7] := SC9->C9_QTDLIB*SC9->C9_PRCVEN
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "STATUS")
						
						//Renato Nogueira - Alteração do status do romaneio - 21/11/2013
						If Empty(_cCodEntreg)
							acols7[Len(acols7)][nCntFor7] := 'N/ GERADO'
						ElseIf PD2->PD2_STATUS=="4"
							acols7[Len(acols7)][nCntFor7] := 'ENTREGUE'
						ElseIf PD2->PD2_STATUS=="5"
							acols7[Len(acols7)][nCntFor7] := 'NAO ENTREGUE'
						ElseIf PD1->PD1_STATUS $ "4"
							acols7[Len(acols7)][nCntFor7] := 'EMBARCADO'
						Else
							acols7[Len(acols7)][nCntFor7] := 'GERADO'
						EndIf
						
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "C9_NFISCAL")
						acols7[Len(acols7)][nCntFor7] := SC9->C9_NFISCAL
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "C9_SERIENF")
						acols7[Len(acols7)][nCntFor7] := SC9->C9_SERIENF
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "C9_ITEM")
						acols7[Len(acols7)][nCntFor7] := SC9->C9_ITEM
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "C9_PRODUTO")
						acols7[Len(acols7)][nCntFor7] := SC9->C9_PRODUTO
						
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "DTENT")
						If cEmpAnt=="01"
							If PD2->PD2_STATUS=="4"
								acols7[Len(acols7)][nCntFor7] := PD2->PD2_XDTBX
							Else
								acols7[Len(acols7)][nCntFor7] := CTOD("  /  /    ")
							EndIf
						EndIf
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "HRENT")
						If cEmpAnt=="01"
							If PD2->PD2_STATUS=="4"
								acols7[Len(acols7)][nCntFor7] := PD2->PD2_XHRBX
							Else
								acols7[Len(acols7)][nCntFor7] := ""
							EndIf
						EndIf
					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "ROMANEIO")
						acols7[Len(acols7)][nCntFor7] := _cCodEntreg

					ElseIf  ( alltrim(aHeader7[nCntFor7][2]) =  "OBSERVACAO") //SF2->F2_XOBSROM
						if !empty(_cStPed)
							acols7[Len(acols7)][nCntFor7] := ""
						Else
							acols7[Len(acols7)][nCntFor7] := _cObsPd1
						Endif
						If PD2->PD2_STATUS=="5"
							acols7[Len(acols7)][nCntFor7] := AllTrim(PD2->PD2_MOTIVO)
						EndIf
					ElseIf ( aHeader7[nCntFor7][10] != "V" )
						acols7[Len(acols7)][nCntFor7] := FieldGet(FieldPos(aHeader7[nCntFor7,2]))
					Else
						acols7[Len(acols7)][nCntFor7] := CriaVar(aHeader7[nCntFor7][2])
					EndIf


				Next nCntFor7

				acols7[Len(acols7)][Len(aHeader7)+1] := .F.
			EndIf




			//_______________________flags da tela principal


			If !(SC9->C9_BLCRED $ '09/10') .And. !Empty(Alltrim(SC9->C9_BLCRED))
				_lBloqRet := .T.
			ElseIf SC9->C9_BLCRED $ '09'
				_lRejRet := .T.
			ElseIf Empty(Alltrim(SC9->C9_BLCRED))  .Or. SC9->C9_BLCRED $ '10'
				_lLibRet   := .T.
			EndIf






			SC9->(DbSkip())
		END

		dbselectarea('SC6')
		//______________RESERVA__________________________________________________________________________________________________________________________
		AADD(aCols8,Array(Len(aHeader8) + 1))

		For nCntFor8 := 1 To Len(aHeader8)
			If    ( alltrim(aHeader8[nCntFor8][3]) =  "@BMP")
				If SC6->C6_QTDENT = 0
					aCols8[Len(aCols8)][nCntFor8] := LoaDbitmap( GetResources(), "BR_VERDE" )
				EndIf
				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT = SC6->C6_QTDVEN
					aCols8[Len(aCols8)][nCntFor8] := LoaDbitmap( GetResources(), "BR_VERMELHO" )
				EndIf

				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT <> SC6->C6_QTDVEN
					aCols8[Len(aCols8)][nCntFor8] := LoaDbitmap( GetResources(), "BR_AMARELO" )
				EndIf
			ElseIf  ( alltrim(aHeader8[nCntFor8][2]) =  "FATURAMENTO")
				If SC6->C6_QTDENT = 0
					aCols8[Len(aCols8)][nCntFor8] := 'Não Faturado'
				EndIf
				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT = SC6->C6_QTDVEN
					aCols8[Len(aCols8)][nCntFor8] := 'Total'
				EndIf

				If SC6->C6_QTDENT > 0    .And. SC6->C6_QTDENT <> SC6->C6_QTDVEN
					aCols8[Len(aCols8)][nCntFor8] := 'Parcial'
				EndIf

			ElseIf  ( alltrim(aHeader8[nCntFor8][2]) =  "EMPENHO")
				aCols8[Len(aCols8)][nCntFor8] := StEmpenho(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_LOCAL)
			ElseIf  ( alltrim(aHeader8[nCntFor8][2]) =  "RESERVA")
				aCols8[Len(aCols8)][nCntFor8] := Streserva(SC6->C6_NUM,SC6->C6_ITEM)
			ElseIf  ( alltrim(aHeader8[nCntFor8][2]) =  "FALTA")
				aCols8[Len(aCols8)][nCntFor8] := Stfalta(SC6->C6_NUM,SC6->C6_ITEM)
			ElseIf  ( alltrim(aHeader8[nCntFor8][2]) =  "DEP.FECHADO")
				aCols8[Len(aCols8)][nCntFor8] := Stfechado(SC6->C6_NUM,SC6->C6_ITEM )


			ElseIf ( aHeader8[nCntFor8][10] != "V" )
				aCols8[Len(aCols8)][nCntFor8] := FieldGet(FieldPos(aHeader8[nCntFor8][2]))
			Else
				aCols8[Len(aCols8)][nCntFor8] := CriaVar(aHeader8[nCntFor8][2])
			EndIf
		Next nCntFor8
		aCols8[Len(aCols8)][Len(aHeader8)+1] := .F.
		//________________________________________________________________________________________________________________________________________








		SC6->(DbSkip())
	ENDdo
	Return

	/*====================================================================================\
	|Programa  | STHEADTRA        | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STHEADTRA                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STHEADTRA                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
user Function STHEADTRA()
	*-----------------------------*

	Local oGetDados0
	Local oGet3Dados
	Local oGet4Dados
	Local oGet5Dados
	Local oGet6Dados
	Local oGet7Dados
	Local oGet8Dados

	_lBloq   := .f.
	_lLibe   := .f.
	_lsepaO  := .f.
	_lFat    := .f.
	_lRej    := .f.
	_lEmbax  := .f.
	aHeader  := {}
	acols    := {}
	aHeader2 := {}
	//oGet3Dados
	acols4   := {}
	aHeader4 := {}
	//oGet4Dados
	acols6   := {}
	aHeader6 := {}
	//oGet6Dados
	acols7   := {}
	aHeader7 := {}
	//oGet7Dados
	aCols2   := {}
	_lxbloreg:=.f.
	acols5   := {}
	_cCodEntreg:=''
	//oGet5Dados
	acols0   := {}
	aHeader0 := {}
	//oGetDados0
	acols8     := {}
	aHeader8   := {}
	//oGet8Dados


	//Geral**************************************************************************************************************
	Aadd(aHeader0,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C6_PRODUTO")
	Aadd(aHeader0,{"FATURAMENTO"   , "FATURAMENTO"   , PesqPict('SC6',"C6_PRODUTO", aTam[1]),    13  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C6_ITEM")
	Aadd(aHeader0, {"ITEM"    ,"C6_ITEM"   , PesqPict('SC6',"C6_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C6_PRODUTO")
	Aadd(aHeader0, {"PRODUTO" ,"C6_PRODUTO", PesqPict('SC6',"C6_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C6_QTDVEN")
	Aadd(aHeader0, {"QUANT.VENDIDA."  ,"C6_QTDVEN" , PesqPict('SC6',"C6_QTDVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_QTDENT")
	Aadd(aHeader0, {"QUANT.ENTREGUE."  ,"C6_QTDENT" , PesqPict('SC6',"C6_QTDENT", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_PRCVEN")
	Aadd(aHeader0, {"PRC.VEN" ,"C6_PRCVEN" , PesqPict('SC6',"C6_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_VALOR")
	Aadd(aHeader0, {"TOTAL"   ,"C6_VALOR"     , PesqPict('SC6',"C6_VALOR", aTam[1])  , aTam[1], aTam[2], '', "", 'N', '', ''})

	//folder bloqueios  **************************************************************************************************************************************************8

	Aadd(aHeader2,{"Msg. Cliente"      ,     "Msg. Cliente"         ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Cond. Pagt."       ,     "Cond. Pagt."   	    ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Desconto"          ,     "Desconto"             ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Preço Sob Consulta",     "Preço Sob Consulta"   ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Vlr. Min."         ,     "Vlr. Min."            ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Operação"          ,     "Operação"             ,   "@BMP"                             ,    21   ,     0 ,""  ,   ,"C" ,"",""})
	Aadd(aHeader2,{"Financeiro"        ,     "Financeiro"             ,   "@BMP"                           ,    21   ,     0 ,""  ,   ,"C" ,"",""})

	//FINANCEIRO**************************************************************************************************************
	Aadd(aHeader,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader,{"STATUS"   , "STATUS"   , PesqPict('SC9',"C9_PRODUTO", aTam[1]),    10  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C9_ITEM")
	Aadd(aHeader, {"ITEM"    ,"C9_ITEM"   , PesqPict('SC9',"C9_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader, {"PRODUTO" ,"C9_PRODUTO", PesqPict('SC9',"C9_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_QTDLIB")
	Aadd(aHeader, {"QUANT."  ,"C9_QTDLIB" , PesqPict('SC9',"C9_QTDLIB", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C9_PRCVEN")
	Aadd(aHeader, {"PRC.VEN" ,"C9_PRCVEN" , PesqPict('SC9',"C9_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_VALOR")
	Aadd(aHeader, {"TOTAL"   ,"TOTAL"     , PesqPict('SC6',"C6_VALOR", aTam[1])  , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3('C9_XOBSFIN')
	Aadd(aHeader, {"Obs. Financeiro"      ,'C9_XOBSFIN' , PesqPict('SC9','C9_XOBSFIN', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})

	//SEPARAÇÃO   &   EMBALAGEM  MESMO AHEADER **************************************************************************************************************
	Aadd(aHeader4,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader4,{"STATUS"   , "STATUS"   , PesqPict('SC9',"C9_PRODUTO", aTam[1]),    10  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3('C9_ORDSEP')
	Aadd(aHeader4, {"Ordem De Separação"   ,'C9_ORDSEP' , PesqPict('SC9','C9_ORDSEP', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_ITEM")
	Aadd(aHeader4, {"ITEM"    ,"C9_ITEM"   , PesqPict('SC9',"C9_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader4, {"PRODUTO" ,"C9_PRODUTO", PesqPict('SC9',"C9_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_QTDLIB")
	Aadd(aHeader4, {"QUANT."  ,"C9_QTDLIB" , PesqPict('SC9',"C9_QTDLIB", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C9_PRCVEN")
	Aadd(aHeader4, {"PRC.VEN" ,"C9_PRCVEN" , PesqPict('SC9',"C9_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_VALOR")
	Aadd(aHeader4, {"TOTAL"   ,"TOTAL"     , PesqPict('SC6',"C6_VALOR", aTam[1])  , aTam[1], aTam[2], '', "", 'N', '', ''})
	//nota fiscal **************************************************************************************************************
	Aadd(aHeader6,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader6,{"STATUS"   , "STATUS"   , PesqPict('SC9',"C9_PRODUTO", aTam[1]),    10  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3('C9_NFISCAL')
	Aadd(aHeader6, {"NOTA FISCAL"   ,'C9_NFISCAL' , PesqPict('SC9','C9_NFISCAL', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3('C9_SERIENF')
	Aadd(aHeader6, {"SERIE NF"   ,'C9_SERIENF' , PesqPict('SC9','C9_SERIENF', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3('F2_EMISSAO')//GIOVANI
	Aadd(aHeader6, {"EMISSAO"   ,'EMISSAO' , PesqPict('SF2','F2_EMISSAO', aTam[1]) , aTam[1], aTam[2], '', "", 'D', '', ''}) //GIOVANI
	aTam := TamSX3("C9_ITEM")
	Aadd(aHeader6, {"ITEM"    ,"C9_ITEM"   , PesqPict('SC9',"C9_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader6, {"PRODUTO" ,"C9_PRODUTO", PesqPict('SC9',"C9_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_QTDLIB")
	Aadd(aHeader6, {"QUANT."  ,"C9_QTDLIB" , PesqPict('SC9',"C9_QTDLIB", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C9_PRCVEN")
	Aadd(aHeader6, {"PRC.VEN" ,"C9_PRCVEN" , PesqPict('SC9',"C9_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_VALOR")
	Aadd(aHeader6, {"TOTAL"   ,"TOTAL"     , PesqPict('SC6',"C6_VALOR", aTam[1])  , aTam[1], aTam[2], '', "", 'N', '', ''})
	//ROMANEIO **************************************************************************************************************   "PD2_CODROM"
	Aadd(aHeader7,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader7,{"STATUS"   , "STATUS"   , PesqPict('SC9',"C9_PRODUTO", aTam[1]),    10  ,     0 ,""  ,   ,"C" ,"",""})
	
	If cEmpAnt=="01"
		aTam := TamSX3("PD2_XDTBX")
		Aadd(aHeader7,{"DT ENT NF"   , "DTENT"   , PesqPict('PD2',"PD2_XDTBX", aTam[1]),    aTam[2]  ,     0 ,""  ,   ,"D" ,"",""})
	
		aTam := TamSX3("PD2_XHRBX")
		Aadd(aHeader7,{"HR ENT NF"   , "HRENT"   , PesqPict('PD2',"PD2_XHRBX", aTam[1]),    aTam[2]  ,     0 ,""  ,   ,"C" ,"",""})
	EndIf
	
	aTam := TamSX3("PD2_CODROM")
	Aadd(aHeader7, {"ROMANEIO"   ,"ROMANEIO" , PesqPict('PD2',"PD2_CODROM", aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader7, {"OBSERVACAO"   ,"OBSERVACAO" , PesqPict('SC9',"C9_PRODUTO", aTam[1]) , 50 , aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3('F2_EMISSAO')//GIOVANI
	Aadd(aHeader7, {"EMISSAO"   ,'EMISSAO' , PesqPict('SF2','F2_EMISSAO', aTam[1]) , aTam[1], aTam[2], '', "", 'D', '', ''}) //GIOVANI
	aTam := TamSX3('PD1_DTENT')//Chamado 008304 - Everson Santana - 01/11/218
	Aadd(aHeader7, {"DT ENT ROM"   ,'DT ENT ROM' , PesqPict('PD1','PD1_DTENT', aTam[1]) , aTam[1], aTam[2], '', "", 'D', '', ''}) //Chamado 008304 - Everson Santana - 01/11/218	
	aTam := TamSX3('C9_NFISCAL')
	Aadd(aHeader7, {"NOTA FISCAL"   ,'C9_NFISCAL' , PesqPict('SC9','C9_NFISCAL', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3('C9_SERIENF')
	Aadd(aHeader7, {"SERIE NF"   ,'C9_SERIENF' , PesqPict('SC9','C9_SERIENF', aTam[1]) , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_ITEM")
	Aadd(aHeader7, {"ITEM"    ,"C9_ITEM"   , PesqPict('SC9',"C9_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_PRODUTO")
	Aadd(aHeader7, {"PRODUTO" ,"C9_PRODUTO", PesqPict('SC9',"C9_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C9_QTDLIB")
	Aadd(aHeader7, {"QUANT."  ,"C9_QTDLIB" , PesqPict('SC9',"C9_QTDLIB", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C9_PRCVEN")
	Aadd(aHeader7, {"PRC.VEN" ,"C9_PRCVEN" , PesqPict('SC9',"C9_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_VALOR")
	Aadd(aHeader7, {"TOTAL"   ,"TOTAL"     , PesqPict('SC6',"C6_VALOR", aTam[1])  , aTam[1], aTam[2], '', "", 'N', '', ''})

	//Reserva**************************************************************************************************************
	//Aadd(aHeader8,{"  "       ,     "OK"   ,   "@BMP"                             ,    3   ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C6_PRODUTO")
	Aadd(aHeader8,{"FATURAMENTO"   , "FATURAMENTO"   , PesqPict('SC6',"C6_PRODUTO", aTam[1]),    13  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C6_ITEM")
	Aadd(aHeader8, {"ITEM"    ,"C6_ITEM"   , PesqPict('SC6',"C6_ITEM", aTam[1])   , aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C6_PRODUTO")
	Aadd(aHeader8, {"PRODUTO" ,"C6_PRODUTO", PesqPict('SC6',"C6_PRODUTO", aTam[1]), aTam[1], aTam[2], '', "", 'C', '', ''})
	aTam := TamSX3("C6_QTDVEN")
	Aadd(aHeader8, {"QUANT.VENDIDA."  ,"C6_QTDVEN" , PesqPict('SC6',"C6_QTDVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_QTDENT")
	Aadd(aHeader8, {"QUANT.ENTREGUE."  ,"C6_QTDENT" , PesqPict('SC6',"C6_QTDENT", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_PRCVEN")
	Aadd(aHeader8, {"FALTA" ,"FALTA" , PesqPict('SC6',"C6_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_PRCVEN")
	Aadd(aHeader8, {"RESERVA" ,"RESERVA" , PesqPict('SC6',"C6_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_PRCVEN")
	Aadd(aHeader8, {"DEP.FECHADO" ,"DEP.FECHADO" , PesqPict('SC6',"C6_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})
	aTam := TamSX3("C6_PRCVEN")
	Aadd(aHeader8, {"EMPENHO" ,"EMPENHO", PesqPict('SC6',"C6_PRCVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})



	Return()
	/*====================================================================================\
	|Programa  | STFIN            | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STFIN                                                                    |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFIN                                                                    |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STFIN()
	*-----------------------------*

	If	_lRejRet
		_cRet:= 'Rejeitado'
	ElseIf	_lLibRet
		_cRet:= 'Liberado'
	Elseif _lBloqRet
		_cRet:= 'Analise'
	EndIf


	Return(_cRet)
	/*====================================================================================\
	|Programa  | STRESERVA        | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STRESERVA                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STRESERVA                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STRESERVA(_cPed,_cItem)
	*-----------------------------*
	Local _nRet :=0

	DbSelectArea("PA2")
	PA2->(DbSetOrder(2))
	If PA2->(DbSeek(xFilial('PA2')+"1"+_cPed+_cItem))
		Do While PA2->(!Eof()) .And. PA2->PA2_DOC = _CPED+_cItem  .And. PA2->PA2_TIPO = '1'
			If    PA2->PA2_FILRES = cfilant
				_nRet+= PA2->PA2_QUANT
			EndIf
			PA2->(DbSkip())
		ENDDO
	EndIf

	Return(_nRet)

	/*====================================================================================\
	|Programa  | STFECHADO        | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STFECHADO                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFECHADO                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STFECHADO(_cPed,_cItem)
	*-----------------------------*
	Local _nRet :=0

	/*
	DbSelectArea("PA2")
	PA2->(DbSetOrder(2))
	If PA2->(DbSeek(xFilial('PA2')+"1"+_cPed+_cItem))
	Do While PA2->(!Eof()) .And. PA2->PA2_DOC = _CPED+_cItem  .And. PA2->PA2_TIPO = '1'
	If    PA2->PA2_FILRES = '02'
	_nRet+= PA2->PA2_QUANT
	EndIf
	PA2->(DbSkip())
	ENDDO
	EndIf
	*/
	Return(_nRet)
	/*====================================================================================\
	|Programa  | STFALTA          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STFALTA                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFALTA                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STFALTA(_cPed,_cItem)
	*-----------------------------*
	Local _nRet :=0

	DbSelectArea("PA1")
	PA1->(DbSetOrder(2))
	If PA1->(DbSeek(xFilial('PA1')+"1"+_cPed+_cItem))
		Do While PA1->(!Eof()) .And. PA1->PA1_DOC = _CPED+_cItem  .And. PA1->PA1_TIPO = '1'
			_nRet+=PA1->PA1_QUANT
			PA1->(DbSkip())
		ENDDO
	EndIf


	Return(_nRet)




	/*====================================================================================\
	|Programa  | STFALTA          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STFALTA                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFALTA                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function StEmpenho(_cPed,_cItem,_cProd,_cLocal)
	*-----------------------------*
	Local _nRet :=0

	DbSelectArea("SDC")
	SDC->(DbSetOrder(1))
	If SDC->(DbSeek(xFilial("SDC")+_cProd+_cLocal+'SC6'+_cPed+_cItem))
		Do While SDC->(!Eof()) .And. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM) = xFilial("SDC")+_cProd+_cLocal+'SC6'+_cPed+_cItem
			_nRet+=SDC->DC_QUANT
			SDC->(DbSkip())
		ENDDO
	EndIf


	Return(_nRet)


	/*====================================================================================\
	|Programa  | STSEP            | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STSEP                                                                    |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STSEP                                                                    |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STSEP()
	*-----------------------------*
	Local _cRet:= ''


	DbSelectArea('CB7')
	CB7->(DbSetorder(2))  //CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG
	If CB7->(DbSeek(xFilial('CB7')+SC5->C5_NUM))
		Do While CB7->(!Eof()) .And. xFilial("SDC") = CB7->CB7_FILIAL  .And. CB7->CB7_PEDIDO = SC5->C5_NUM

			If 	CB7->CB7_STATUS $ '01/02'
				_cRet+= 'Os.: '+CB7->CB7_ORDSEP+' em Separação'
			ElseIf CB7->CB7_STATUS $ '03/04/05/06/07/08/09/10'
				_cRet+= '  Os.: '+CB7->CB7_ORDSEP+'  Finalizado'
			EndIf

			CB7->(DbSkip())
		EndDo
	EndIf

	If Empty(Alltrim(_cRet))
		_cRet:= 'Sem Separação'
	EndIf
	Return(_cRet)


	/*====================================================================================\
	|Programa  | STEMB            | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
	|=====================================================================================|
	|Descrição | STEMB                                                                    |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STEMB                                                                    |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STEMB()
	*-----------------------------*
	Local _cRet:= ''


	DbSelectArea('CB7')
	CB7->(DbSetorder(2))  //CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG
	If CB7->(DbSeek(xFilial('CB7')+SC5->C5_NUM))
		Do While CB7->(!Eof()) .And. xFilial("SDC") = CB7->CB7_FILIAL  .And. CB7->CB7_PEDIDO = SC5->C5_NUM

			If 	CB7->CB7_STATUS $ '03'
				_cRet+= 'Os.: '+CB7->CB7_ORDSEP+'  Embalando'
			ElseIf CB7->CB7_STATUS $ '04/05/06/07/08/09/10'
				_cRet+= '  Os.: '+CB7->CB7_ORDSEP+'  Embalado'
			EndIf

			CB7->(DbSkip())
		EndDo
	EndIf

	If Empty(Alltrim(_cRet))
		_cRet:= 'Sem Embalagem'
	EndIf
Return(_cRet)

Static Function GetBloqs()

	Local _cRet := ""
		
	If SC5->C5_XPEDMKT=="S"
		_cRet += "Marketing / "
	EndIf
	If !(SC5->C5_XSTARES =='1' .Or. SC5->C5_XSTARES == '4')
		_cRet += "Reserva / "
	EndIf
	If SC5->(C5_CLIENTE+C5_LOJACLI) $ AllTrim(SuperGetMV("MV_XSTCLI2",.F.,"033467"))
		_cRet += "Cliente Steck / "
	EndIf
	If !(AllTrim(SC5->C5_ZBLOQ)=="2")
		_cRet += "Bloqueio comercial / "
	EndIf
	If Empty(SC5->C5_XPRIORI)
		_cRet += "Sem prioridade / "
	EndIf
	If !Empty(SC5->C5_ZMOTBLO)
		_cRet += "Bloqueio comercial / "
	EndIf
	If SC5->(C5_CLIENTE+C5_LOJACLI) $ SuperGetMV("MV_XCTRANS",,"02504301|03346702|05350001")
		_cRet += "Cliente Steck / "
	EndIf
	If SC5->C5_ZREFNF=="1"
		_cRet += "Refaturamento / "
	EndIf
	If SC5->C5_XTNTFOB=="1"
		_cRet += "TNT Fob / "
	EndIf
	If SC5->C5_XBLQFMI=="S"
		_cRet += "Fat min / "
	EndIf
	If  (Stod(SC5->C5_XAANO+SC5->C5_XMATE+SC5->C5_XATE) >= dDataBase) .And. (Stod(SC5->C5_XDANO+SC5->C5_XMDE+SC5->C5_XDE) <= dDataBase)
		_cRet += "Dt Nao Gera OS / "
	EndIf
	If GetMv("ST_TRIPED",,.T.) .And.  !(Empty(Alltrim(SC5->C5_XPEDTRI ))) .And. SC5->C5_XTIPF <> '1'
		_cRet += "Ped Tri Parcial / "
	EndIf
	If SA1->A1_XBLQFIN=="1"
		_cRet += "Blq Cad Fin / "
	EndIf
	If AllTrim(SC5->C5_CONDPAG)=="501" .And. !AllTrim(SC5->C5_XLIBAVI)=="S"
		_cRet += "A vista bloq / "
	EndIf
	
	If Empty(_cRet)
		_cRet := "Nenhum bloqueio"
	EndIf

Return(_cRet)
