#INCLUDE "PROTHEUS.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA60 ³ Autor ³ Totvs                 ³ Data ³ 10/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Romaneio de Transporte                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA60()

	Private _cUserRoman:= GetMv("ST_UROMAN",,"000000")+'/000645/000000'
	Private aRotina := {}

	// Removido Valdemir 20/10/2020 - Ticket: 20200928008019
	// Private aRotina := {	{"Pesquisar",		"AxPesqui",  0,1},;
		// {"Visualizar",		"U_STFSF60M",0,2},;
		// {"Gerar",			"U_STFSF60G",0,3},;
		// {"Alterar",			"U_STFSF60M",0,4},;
		// {"Encerrameto",		"U_STFSF60F",0,5},;
		// {"Relatorio",		"U_STFSFA61",0,6},;
		// {"Legenda"	,		"U_STFSF60L",0,2},;
		// {"Finalizar 15",		"U_STFINROM",0,9}}

	If cEmpAnt=="01" .and. cFilant = "05" .OR. cEmpAnt=="03" .and. cFilant = "01" // Ticket 20210719013041 - Priscila Castro - 23.07.2021

		aRotina := {	{"Pesquisar",		"AxPesqui",  0,1},;
						{"Visualizar",		"U_STFSF60M",0,2},;
						{"Gerar",			"U_STFSF60G",0,3},;
						{"Alterar",			"U_STFSF60M",0,4},;
						{"Encerrameto",		"U_STFSF60F",0,5},;
						{"Relatorio",		"U_STFSFA61",0,6},;
						{"Legenda"	,		"U_STFSF60L",0,2},;
						{"Finalizar 15",	"U_STFINROM",0,9}}
	Else

		aRotina := {	{"Pesquisar",		"AxPesqui",  0,1},;
						{"Visualizar",		"U_STFSF60M",0,2},;
						{"Relatorio",		"U_STFSFA61",0,6},;
						{"Legenda"	,		"U_STFSF60L",0,2}	}

	EndIf

	//Aadd(aRotina,{"New Gerar",		"U_NSF60G",0,3})           //  Ticket: 20200928008019
	Aadd(aRotina,{"Gerar arquivo TNT","U_STFSFA64",0,2})
	Aadd(aRotina,{"Gerar arquivo BrasPress","U_STFSFA65",0,2})

	Private cCadastro := OemtoAnsi( "Romaneio de Transporte")

	Private _cUsrMot := ""
	Private _cNomMot := ""
	Private _cUsrAj1 := ""
	Private _cNomAj1 := ""
	Private _cUsrAj2 := ""
	Private _cNomAj2 := ""

	aCores := {{ "PD1->PD1_STATUS == '0'", "ENABLE"  		},;
		{ "PD1->PD1_STATUS == '1'", "BR_AMARELO"	},;
		{ "PD1->PD1_STATUS == '2'", "BR_PRETO"  	},;
		{ "PD1->PD1_STATUS == '4'", "BR_AZUL"  		},;
		{ "PD1->PD1_STATUS == '5'", "BR_LARANJA"	},;
		{ "PD1->PD1_STATUS == '3'", "DISABLE" }}

	mBrowse( 6, 1, 22, 75, "PD1", , , , , , aCores,,,,,,,,,,{|| o:=GetObjBrow(),}) //Renato Nogueira - Chamado 000136 - Retirado refresh da tela

Return

//------------------------------------------------------------------------
// Romaneio de Transporte - GERACAO
User Function NSF60G( cAlias, nReg, nOpcx )
	Local cRegiaoDe
	Local cRegiaoAte
	Local cNFSDe
	Local cNFSAte
	Local cSerieDe
	Local cSerieAte
	Local cClienteDe
	Local cClienteAte
	Local cLojaDe
	Local cLojaAte
	Local dEmissaoDe
	Local dEmissaoAte
	Local cTransp

	Local cNomeTransp
	Local aSize
	Local aObjects
	Local aPosObj
	Local bDbClick
	Local aButtons  := {}
	Local oDlg
	Local oGetD
	Local oTransp
	Local nOpca     := 0
	Local cTranAte	:= ""
	Local cTpFrete	:= ""

	Private aCols   := {}
	Private aHeader := {}

	Private oQtdNFS
	Private nQtdNFS   := 0
	Private oQtdVols
	Private nQtdVols  := 0
	Private oPBruto
	Private nPBruto   := 0
	Private oPLiquido
	Private nPLiquido := 0
	Private _aColsOld:= {}

	CB7->(DbSetorder(4))  //CB7_FILIAL+CB7_NOTA+CB7_SERIE+CB7_LOCAL+CB7_STATUS

	cRegiaoDe   	:= '     '
	cRegiaoAte  	:= 'ZZ'
	cNFSDe      	:= ' '
	cNFSAte     	:= 'ZZ'
	cSerieDe    	:= ' '
	cSerieAte   	:= 'ZZ'
	cClienteDe  	:= ' '
	cClienteAte 	:= 'ZZ'
	cLojaDe     	:= ' '
	cLojaAte    	:= 'ZZ'
	dEmissaoDe  	:= Ctod( "01/01/" + Strzero(Year(dDatabase),4)) //Stod('20170101')  
	//FR - 07/07/2023 - SIGAMAT CONSULTORIA - TELA FICAVA LENTA DEVIDO ESTA DATA MTO ANTIGA
	dEmissaoAte 	:= Stod('20300101')
	cTransp     	:= ' '
	cTranAte	  	:= 'ZZ'
	cTpFrete		:= '4'

	cNomeTransp := SA4->A4_NOME

	Processa( { || aCols:=STFSF60GX(cNFSDe,cNFSAte,cSerieDe,cSerieAte,cClienteDe,cClienteAte,;
		cLojaDe,cLojaAte,dEmissaoDe,dEmissaoAte,cTransp,cTranAte,;
		cRegiaoDe,cRegiaoAte,cTpFrete) },'Aguarde','Selecionando Registros...', )

	If Empty(aCols)
		MsgAlert("Não existem notas conforme parâmetro informado!!!",".:AVISO:.")
		Return
	Endif

	aSort(aCols,,,{|x,y| x[8]+x[11]      < y[8]+y[11] })
	//aSort(aCols,,,{|x,y| x[8]+x[1]+x[2]+x[3]      < y[16]+y[1]+y[2]+y[3]})
	aHeader  := CrgAheader()
	aSize    := MsAdvSize()
	aObjects := {}
	// Para retornar em linha e coluna iniciais e finais
	Aadd( aObjects, {100,100,.T.,.T.} )
	aPosObj:= MsObjSize({ aSize[1], aSize[2], aSize[3], aSize[4], 1,1 },aObjects,.T.,.T.)

	aadd(aButtons,{"autom",{||MarkDesm(oGetD)},"Marca/Desmarca","Marca/Desmarca Todos" })
	aadd(aButtons,{"autom",{||InsObs(oGetD:aCols[oGetD:nAt,2],oGetD:aCols[oGetD:nAt,3],oGetD)},"Marca/Desmarca","Observação" })
	aadd(aButtons,{"autom",{||InsObsI(oGetD:aCols[oGetD:nAt,2],oGetD:aCols[oGetD:nAt,3],oGetD)},"Marca/Desmarca","Observação por nota" })
	aadd(aButtons,{"autom",{||FilTela(oGetD:aCols,oGetD)},"Marca/Desmarca","Filtro" })
	_aColsOld := aCols
	DEFINE MSDIALOG oDlg TITLE "Romaneio de Transporte" From aSize[7],0 to aSize[6],aSize[5] Pixel

	oGetD    := MsNewGetDados():New( aPosObj[1][1],  aPosObj[1][2],  aPosObj[1][3],  aPosObj[1][4],,"AllWaysTrue()","AllWaysTrue()",,,,Len(aCols),,, ,oDlg, aHeader, aCols )
	oGetD:oBrowse:lUseDefaultColors := .F.
	oGetD:oBrowse:SetBlkBackColor({||NewColor(oGetD:nAt)})
	bDbClick := oGetD:oBrowse:bLDblClick
	oGetD:SetArray(aCols)

	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	AtuInfoNFS(oGetD,.f.)  //Atualiza informacoes de Qtde Notas, Peso, Qtde Volumes

	// Habilita o Duplo Click trocando o valor da MarkBrowse
	// neste caso apenas quando estiver na primeira coluna da GetDados
	oGetD:oBrowse:bLDblClick := {|| (Iif(oGetD:aCols[oGetD:nAt,1]=="LBNO",;
		oGetD:aCols[oGetD:nAt,1]:="LBOK",;
		oGetD:aCols[oGetD:nAt,1]:="LBNO"),;
		oGetD:oBrowse:Refresh(),AtuInfoNFS(oGetD,.t.))}
	//	oGetD:oBrowse:Refresh(),AtuInfoNFS(oGetD,.t.)),Eval(bDbClick))}

	oPanel := TPanel():New( 035, 035, ,oDlg, , , , , , 35, 35, .F.,.T. )
	oPanel:Align := CONTROL_ALIGN_BOTTOM

	//@ 005,005 SAY "Transportadora: " SIZE 110,8 OF oPanel PIXEL
	//@ 004,060 MSGET oTransp VAR cNomeTransp SIZE 160,07 WHEN .F. OF oPanel PIXEL

	//@ 018,005 SAY "Quantidade Notas: " SIZE 110,8 OF oPanel PIXEL
	//@ 017,060 MSGET oQtdNFS VAR nQtdNFS SIZE 60,07 WHEN .F. OF oPanel PIXEL

	@ 015,055 SAY "Quantidade Notas: " SIZE 110,8 OF oPanel PIXEL
	@ 014,110 MSGET oQtdNFS VAR nQtdNFS SIZE 60,07 WHEN .F. OF oPanel PIXEL

	@ 015,305 SAY "Quantidade Volumes: " SIZE 110,8 OF oPanel PIXEL
	@ 014,360 MSGET oQtdVols VAR nQtdVols SIZE 60,07 WHEN .F. OF oPanel PIXEL
	//@ 018,255 SAY "Peso Bruto: " SIZE 110,8 OF oPanel PIXEL
	//@ 017,310 MSGET oPBruto VAR nPBruto SIZE 60,07 WHEN .F. OF oPanel PIXEL
	@ 015,555 SAY "Peso Bruto: " SIZE 110,8 OF oPanel PIXEL
	@ 014,610 MSGET oPBruto VAR nPBruto SIZE 60,07 WHEN .F. OF oPanel PIXEL

	//@ 005,505 SAY "Peso Líquido: " SIZE 110,8 OF oPanel PIXEL
	//	@ 004,560 MSGET oPLiquido VAR nPLiquido SIZE 60,07 WHEN .F. OF oPanel PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(VldTOKGer(oGetD),oDlg:End(),nOpca := 0)},{||oDlg:End()},,aButtons)

	If nOpca == 1
		Begin Transaction
			GravaRomaneio(IiF(nOpcx == 4,PD1->PD1_CODROM,Nil))
		End Transaction
		msginfo("Inclusão Finalizada")
	Endif

Return

Static Function FilTela(_acolss,oGetD)
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local cPerg 	:= "FilTela"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := cPerg+cHora+ cMinutos+cSegundos
	Local aVetor1 	:= {}
	Local aVetor2 	:= {}
	Local aVetor3 	:= {}
	Local aVetor4 	:= {}
	Local oDlg
	Local oLbx,oLbx2,oLbx3,oLbx4
	Local oOk	   	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	   	:= LoadBitmap( GetResources(), "LBNO" )
	Local xs
	Local ix
	Local nPos 		:= 0
	Local oChk1,oChk2,oChk3,oChk4
	Local lChk1	 	:= .t.
	Local lChk2	 	:= .t.
	Local lChk3	 	:= .t.
	Local lChk4	 	:= .t.
	Local _aColsNew := {}
	Local cAliasSuper	:= 'FilTela'
	Local cQuery     	:= ' '

	For xs=1 To Len(_aColsOld)

		nPos := aScan(aVetor1, {|x| x[2] == ALLTRIM(_aColsOld[xs,8])})
		If nPos == 0
			AADD(aVetor1,{.T.,ALLTRIM(_aColsOld[xs,08])})
		EndIf
		nPos := aScan(aVetor1, {|x| x[2] == ALLTRIM(_aColsOld[xs,16])})
		If nPos == 0
			AADD(aVetor1,{.T.,ALLTRIM(_aColsOld[xs,16])})
		EndIf
		nPos := aScan(aVetor2, {|x| x[2] == ALLTRIM(_aColsOld[xs,11])})
		If nPos == 0
			AADD(aVetor2,{.T.,ALLTRIM(_aColsOld[xs,11])})
		EndIf
		nPos := aScan(aVetor3, {|x| x[2] == ALLTRIM(_aColsOld[xs,14])})
		If nPos == 0
			AADD(aVetor3,{.T.,ALLTRIM(_aColsOld[xs,14])})
		EndIf

	Next xs

	aSort(aVetor1,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor2,,,{|x,y| x[2] < y[2]  })
	aSort(aVetor3,,,{|x,y| x[2] < y[2]  })

	/*
	DbSelectArea("SX5")
	SX5->( DbSetOrder( 1 ) )
	SX5->( DbSeek( xFilial()+"_C" ) )

	Do While !(SX5->(Eof())) .AND. SX5->X5_TABELA=="_C" .AND. SX5->X5_FILIAL==xFilial("SX5")

	AADD(aVetor1,{.T.,Alltrim(SX5->X5_CHAVE) + " - " + Alltrim(SX5->X5_DESCRI) })

	SX5->(DBSKIP())
	Enddo
	*/

	AADD(aVetor4,{.T.,'CIF'})
	AADD(aVetor4,{.T.,'FOB'})

	_nTr:= 40

	DEFINE MSDIALOG oDlg TITLE "Parametros" FROM aSize[7],000 To aSize[6]-60,aSize[5]-160 of GetWndDefault() Pixel

	@ 32,1 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor1,{|x| x[1]:=lChk1}) ,oLbx:Refresh())

	@ 1+_nTr,1 LISTBOX oLbx FIELDS HEADER ;
		' ','Zona'  ;
		SIZE 150,225 OF oDlg PIXEL ON dblClick(aVetor1[oLbx:nAt,1] := !aVetor1[oLbx:nAt,1])
	oLbx:SetArray( aVetor1 )
	oLbx:bLine := {|| {Iif(	aVetor1[oLbx:nAt,1],oOk,oNo),;
		aVetor1[oLbx:nAt,2];
		}}

	@ 32,151 CHECKBOX oChk2 VAR lChk2 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor2,{|x| x[1]:=lChk2}) ,oLbx2:Refresh())
	@ 1+_nTr,151 LISTBOX oLbx2 FIELDS HEADER ;
		' ','Cep' ;
		SIZE 150,225 OF oDlg PIXEL ON dblClick(aVetor2[oLbx2:nAt,1] := !aVetor2[oLbx2:nAt,1])
	oLbx2:SetArray( aVetor2 )
	oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
		aVetor2[oLbx2:nAt,2];
		}}

	@ 32,301 CHECKBOX oChk3 VAR lChk3 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor3,{|x| x[1]:=lChk3}) ,oLbx3:Refresh())
	@ 1+_nTr,301 LISTBOX oLbx3 FIELDS HEADER ;
		' ','Transportadora' ;
		SIZE 150,225 OF oDlg PIXEL ON dblClick(aVetor3[oLbx3:nAt,1] := !aVetor3[oLbx3:nAt,1])
	oLbx3:SetArray( aVetor3 )
	oLbx3:bLine := {|| {Iif(	aVetor3[oLbx3:nAt,1],oOk,oNo),;
		aVetor3[oLbx3:nAt,2];
		}}

	@ 32,451 CHECKBOX oChk4 VAR lChk4 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor4,{|x| x[1]:=lChk4}) ,oLbx4:Refresh())
	@ 1+_nTr,451 LISTBOX oLbx4 FIELDS HEADER ;
		' ','Tipo' ;
		SIZE 150,225 OF oDlg PIXEL ON dblClick(aVetor4[oLbx4:nAt,1] := !aVetor4[oLbx4:nAt,1])
	oLbx4:SetArray( aVetor4 )
	oLbx4:bLine := {|| {Iif(	aVetor4[oLbx4:nAt,1],oOk,oNo),;
		aVetor4[oLbx4:nAt,2];
		}}

	oLbx:Refresh()
	oLbx2:Refresh()
	oLbx3:Refresh()
	oLbx4:Refresh()
	oDlg:Refresh()

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| _nOp:=1,oDlg:End() },{||oDlg:End()},,)
	//_aColsNew:= _aColsOld
	For ix=1 To Len(_aColsOld)

		nPos1 := aScan(aVetor1, {|x| x[2] == ALLTRIM(_aColsOld[ix,8])})//zona
		nPos2 := aScan(aVetor2, {|x| x[2] == ALLTRIM(_aColsOld[ix,11])})//cep
		nPos3 := aScan(aVetor3, {|x| x[2] == ALLTRIM(_aColsOld[ix,14])})//transportadora
		nPos4 := aScan(aVetor4, {|x| x[2] == ALLTRIM(_aColsOld[ix,3])})//tipo cif fob

		nPos1x := aScan(aVetor1, {|x| x[2] == ALLTRIM(_aColsOld[ix,16])})//zona

		If ( nPos1 <> 0.And. aVetor1[nPos1,1] .Or.  nPos1x <> 0.And. aVetor1[nPos1x,1] )     .And. ;
				nPos2 <> 0.And. aVetor2[nPos2,1]   .And. ;
				nPos3 <> 0.And. aVetor3[nPos3,1]   .And. ;
				nPos4 <> 0.And. aVetor4[nPos4,1]

			Aadd(_aColsNew,{;
				_aColsOld[ix,01],;
				_aColsOld[ix,02],;
				_aColsOld[ix,03],;
				_aColsOld[ix,04],;
				_aColsOld[ix,05],;
				_aColsOld[ix,06],;
				_aColsOld[ix,07],;
				_aColsOld[ix,08],;
				_aColsOld[ix,09],;
				_aColsOld[ix,10],;
				_aColsOld[ix,11],;
				_aColsOld[ix,12],;
				_aColsOld[ix,13],;
				_aColsOld[ix,14],;
				_aColsOld[ix,15],;
				_aColsOld[ix,16],;
				_aColsOld[ix,17];
				})

		EndIf

	Next ix

	oGetD:aCols:= _aColsNew

	oGetD:oBrowse:Refresh()
Return

//------------------------------------------------------------------------
// Romaneio de Transporte - GERACAO
User Function STFSF60G( cAlias, nReg, nOpcx )
	Local cRegiaoDe
	Local cRegiaoAte
	Local cNFSDe
	Local cNFSAte
	Local cSerieDe
	Local cSerieAte
	Local cClienteDe
	Local cClienteAte
	Local cLojaDe
	Local cLojaAte
	Local dEmissaoDe
	Local dEmissaoAte
	Local cTransp

	Local cNomeTransp
	Local aSize
	Local aObjects
	Local aPosObj
	Local bDbClick
	Local aButtons  := {}
	Local oDlg
	Local oGetD
	Local oTransp
	Local nOpca     := 0
	Local cTranAte	:= ""
	Local cTpFrete	:= ""

	Private aCols   := {}
	Private aHeader := {}

	Private oQtdNFS
	Private nQtdNFS   := 0
	Private oQtdVols
	Private nQtdVols  := 0
	Private oPBruto
	Private nPBruto   := 0
	Private oPLiquido
	Private nPLiquido := 0

	AjustaSX1()
	If !Pergunte("STFSF60",.t.)
		Return
	Endif

	CB7->(DbSetorder(4))  //CB7_FILIAL+CB7_NOTA+CB7_SERIE+CB7_LOCAL+CB7_STATUS

	cRegiaoDe   	:= MV_PAR01
	cRegiaoAte  	:= MV_PAR02
	cNFSDe      	:= MV_PAR03
	cNFSAte     	:= MV_PAR04
	cSerieDe    	:= MV_PAR05
	cSerieAte   	:= MV_PAR06
	cClienteDe  	:= MV_PAR07
	cClienteAte 	:= MV_PAR09
	cLojaDe     	:= MV_PAR08
	cLojaAte    	:= MV_PAR10
	dEmissaoDe  	:= MV_PAR11
	dEmissaoAte 	:= MV_PAR12
	cTransp     	:= MV_PAR13
	cTranAte	  	:= MV_PAR14
	cTpFrete		:= MV_PAR15

	If cRegiaoDe > cRegiaoAte
		MsgAlert("Parâmetros de Região inválidos!",".:AVISO:.")
		Return
	Endif

	If cNFSDe > cNFSAte
		MsgAlert("Parâmetros de Notas Fiscais inválidos!",".:AVISO:.")
		Return
	Endif
	/*
	If cSerieDe > cSerieAte
	MsgAlert("Parâmetros de Série de Notas Fiscais inválidos!",".:AVISO:.")
	Return
	Endif
	*/
	If cClienteDe > cClienteAte
		MsgAlert("Parâmetros de Clientes inválidos!",".:AVISO:.")
		Return
	Endif

	/*
	If cLojaDe > cLojaAte
	MsgAlert("Parâmetros de Lojas de Clientes inválidos!",".:AVISO:.")
	Return
	Endif
	*/
	If dEmissaoDe > dEmissaoAte
		MsgAlert("Parâmetros de Emissão das Notas Fiscais inválidos!",".:AVISO:.")
		Return
	Endif
	/*
	SA4->(DbSetOrder(1))
	If Empty(cTransp) .OR. !SA4->(DbSeek(xFilial("SA4")+cTransp))
	MsgAlert("Transportadora inválida!",".:AVISO:.")
	Return
	Endif
	*/

	cNomeTransp := SA4->A4_NOME

	Processa( { || aCols:=STFSF60GX(cNFSDe,cNFSAte,cSerieDe,cSerieAte,cClienteDe,cClienteAte,;
		cLojaDe,cLojaAte,dEmissaoDe,dEmissaoAte,cTransp,cTranAte,;
		cRegiaoDe,cRegiaoAte,cTpFrete) },'Aguarde','Selecionando Registros...', )

	If Empty(aCols)
		MsgAlert("Não existem notas conforme parâmetro informado!!!",".:AVISO:.")
		Return
	Endif

	aHeader  := CrgAheader()
	aSize    := MsAdvSize()
	aObjects := {}
	// Para retornar em linha e coluna iniciais e finais
	Aadd( aObjects, {100,100,.T.,.T.} )
	aPosObj:= MsObjSize({ aSize[1], aSize[2], aSize[3], aSize[4], 1,1 },aObjects,.T.,.T.)

	aadd(aButtons,{"autom",{||MarkDesm(oGetD)},"Marca/Desmarca","Todos" })
	aadd(aButtons,{"autom",{||InsObs(oGetD:aCols[oGetD:nAt,2],oGetD:aCols[oGetD:nAt,3],oGetD)},"Marca/Desmarca","Observação" })
	aadd(aButtons,{"autom",{||InsObsI(oGetD:aCols[oGetD:nAt,2],oGetD:aCols[oGetD:nAt,3],oGetD)},"Marca/Desmarca","Observação por nota" })
	aadd(aButtons,{"autom",{||ExpExcel()},"Exporta Planilha","Exporta dados para planilha" })

	DEFINE MSDIALOG oDlg TITLE "Romaneio de Transporte" From aSize[7],0 to aSize[6],aSize[5] Pixel

	oGetD    := MsNewGetDados():New( aPosObj[1][1],  aPosObj[1][2],  aPosObj[1][3],  aPosObj[1][4],,"AllWaysTrue()","AllWaysTrue()",,,,Len(aCols),,, ,oDlg, aHeader, aCols )
	bDbClick := oGetD:oBrowse:bLDblClick
	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	AtuInfoNFS(oGetD,.f.)  //Atualiza informacoes de Qtde Notas, Peso, Qtde Volumes

	oGetD:oBrowse:lUseDefaultColors := .F.
	oGetD:oBrowse:SetBlkBackColor({||NewColor(oGetD:nAt)})

	bDbClick := oGetD:oBrowse:bLDblClick
	oGetD:SetArray(aCols)

	// Habilita o Duplo Click trocando o valor da MarkBrowse
	// neste caso apenas quando estiver na primeira coluna da GetDados
	oGetD:oBrowse:bLDblClick := {|| (Iif(oGetD:aCols[oGetD:nAt,1]=="LBNO",;
		oGetD:aCols[oGetD:nAt,1]:="LBOK",;
		oGetD:aCols[oGetD:nAt,1]:="LBNO"),;
		oGetD:oBrowse:Refresh(),AtuInfoNFS(oGetD,.t.))}
	//	oGetD:oBrowse:Refresh(),AtuInfoNFS(oGetD,.t.)),Eval(bDbClick))}

	oPanel := TPanel():New( 035, 035, ,oDlg, , , , , , 35, 35, .F.,.T. )
	oPanel:Align := CONTROL_ALIGN_BOTTOM

	@ 005,005 SAY "Transportadora: " SIZE 110,8 OF oPanel PIXEL
	@ 004,060 MSGET oTransp VAR cNomeTransp SIZE 160,07 WHEN .F. OF oPanel PIXEL

	@ 018,005 SAY "Quantidade Notas: " SIZE 110,8 OF oPanel PIXEL
	@ 017,060 MSGET oQtdNFS VAR nQtdNFS SIZE 60,07 WHEN .F. OF oPanel PIXEL

	@ 005,255 SAY "Quantidade Volumes: " SIZE 110,8 OF oPanel PIXEL
	@ 004,310 MSGET oQtdVols VAR nQtdVols SIZE 60,07 WHEN .F. OF oPanel PIXEL
	@ 018,255 SAY "Peso Bruto: " SIZE 110,8 OF oPanel PIXEL
	@ 017,310 MSGET oPBruto VAR nPBruto SIZE 60,07 WHEN .F. OF oPanel PIXEL

	@ 005,505 SAY "Peso Líquido: " SIZE 110,8 OF oPanel PIXEL
	@ 004,560 MSGET oPLiquido VAR nPLiquido SIZE 60,07 WHEN .F. OF oPanel PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(VldTOKGer(oGetD),oDlg:End(),nOpca := 0)},{||oDlg:End()},,aButtons)

	If nOpca == 1
		Begin Transaction
			GravaRomaneio(IiF(nOpcx == 4,PD1->PD1_CODROM,Nil))
		End Transaction
		msginfo("Inclusão Finalizada")
	Endif

Return

Static Function STFSF60GX(cNFSDe,cNFSAte,cSerieDe,cSerieAte,cClienteDe,cClienteAte,cLojaDe,cLojaAte,dEmissaoDe,dEmissaoAte,cTransp,cTranAte,cRegiaoDe,cRegiaoAte,cTpFrete)

	Local aRet := {}

	Local cQuery
	Local cNomeCli
	Local dEmissao

	Local _cGuia := ''
	ProcRegua( 0 )

	cQuery := " SELECT F2_OK, F2_DOC, F2_SERIE, F2_CLIENTE , F2_LOJA, F2_EMISSAO, F2_TRANSP, F2_VOLUME1, F2_PLIQUI, ROUND(F2_PBRUTO,2) AS F2_PBRUTO, 	A1_COD,  NVL(X5_DESCRI,' ') AS A1_XZONA, A1_LOJA, SUBSTR(A1_NOME,1,30) AS A1_NOME, A1_REGIAO, F2_XGUIA,F2_XPRFGUI,F2_EST  ,
	cQuery += "  SUBSTR(A4_NOME,1,30) AS TRANSP  , F2_XOBSROM AS OBS  , CASE WHEN C5_XTIPO='1' THEN 'RETIRA' ELSE 'ENTREGA' END  AS TPENT , CASE WHEN F2_TPFRETE='C' THEN 'CIF' ELSE 'FOB' END  AS TPFRET

	cQuery += "  FROM "+RetSqlName("SF2")+" SF2

	cQuery += " inner join (SELECT * FROM "+RetSqlName("SA1")+") SA1
	cQuery += " ON      SA1.A1_FILIAL = '" + xFilial("SA1") + "'
	cQuery += " AND 	SF2.F2_CLIENTE = SA1.A1_COD
	cQuery += " AND     SF2.F2_LOJA = SA1.A1_LOJA
	cQuery += " AND     SA1.D_E_L_E_T_ = ' '

	cQuery += " LEFT JOIN(SELECT * FROM SX5010) SX5
	cQuery += " ON SX5.D_E_L_E_T_ = ' '
	cQuery += " AND X5_TABELA = '_C' AND X5_CHAVE = A1_XZONA
	//cQuery += " AND 	SA1.A1_REGIAO BETWEEN  '" + cRegiaoDe + "'  AND   '"+cRegiaoAte+"'

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )D2 ON D2.D_E_L_E_T_=' '
	cQuery += " AND D2.D2_FILIAL=SF2.F2_FILIAL AND D2.D2_DOC=SF2.F2_DOC AND D2.D2_ITEM='01'

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+") C5 ON C5.D_E_L_E_T_=' '
	cQuery += " AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO

	//>>Chamado 008680 - Retirei para fazer o tratamento no While do arquivo temporario.
	//If __cuserid = '001012'
	//	cQuery += " AND C5_XTIPO   = '2'
	//EndIf

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA4")+") A4
	cQuery += " ON A4.D_E_L_E_T_=' '
	cQuery += " AND A4.A4_COD=SF2.F2_TRANSP
	cQuery += " AND A4_FILIAL = '" + xFilial("SA4") + "'

	cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial("SF2") + "'
	cQuery += " AND 	SF2.F2_XCODROM  = '          '
	cQuery += " AND 	SF2.F2_DOC       BETWEEN '" + cNFSDe 			+ "'  AND   '" + cNFSAte + "'
	cQuery += " AND 	SF2.F2_SERIE     BETWEEN '" + cSerieDe 			+ "'  AND   '" + cSerieAte + "'
	cQuery += " AND 	SF2.F2_CLIENTE   BETWEEN '" + cClienteDe 		+ "'  AND   '" + cClienteAte + "'
	cQuery += " AND 	SF2.F2_LOJA      BETWEEN '" + cLojaDe 			+ "'  AND   '" + cLojaAte + "'
	cQuery += " AND 	SF2.F2_EMISSAO   BETWEEN '" + DTOS(dEmissaoDe)  + "'  AND   '" + DTOS(dEmissaoAte) + "'
	cQuery += " AND 	SF2.F2_TRANSP    BETWEEN '" + cTransp 			+ "'  AND   '" + cTranAte + "'
	//cQuery += " AND 	SF2.F2_EMISSAO  >= '20180101'
	If cEmpAnt=="01"
		cQuery += " and	SF2.F2_CLIENTE <> '033467'  "
	EndIf

	//FR - 22/05/2023 - Flávia Rocha - Sigamat Consultoria - MERCADO LIVRE
	//Ajuste na query para igualar PD2_NFS = F2_DOC e PD2_SERIES = F2_SERIE
	//cQuery += " AND       NOT exists (SELECT PD2_NFS FROM "+RetSqlName("PD2")+" PD2 WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL=SF2.F2_FILIAL AND PD2.PD2_NFS=SF2.F2_DOC)
	cQuery += " AND       NOT exists (SELECT PD2_NFS FROM "+RetSqlName("PD2")+" PD2 WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL=SF2.F2_FILIAL AND PD2.PD2_NFS=SF2.F2_DOC and PD2.PD2_SERIES = SF2.F2_SERIE) " + CRLF
	//FR - 22/05/2023 - MERCADO LIVRE

	cQuery += " AND  	SF2.D_E_L_E_T_ = ' '
	cQuery += " ORDER BY F2_DOC, F2_SERIE

	TCQUERY cQuery NEW ALIAS 'SF2TMP'

	While SF2TMP->(!Eof())
		IncProc()
		cNomeCli    := Alltrim(SF2TMP->A1_NOME) //Posicione("SA1",1,XFILIAL("SA1")+SF2TMP->(F2_CLIENTE+F2_LOJA),"A1_NOME")
		dEmissao    := CTOD(Right(SF2TMP->F2_EMISSAO,2)+"/"+SubStr(SF2TMP->F2_EMISSAO,5,2)+"/"+Left(SF2TMP->F2_EMISSAO,4))

		_cRegiao:= 	u_StCepReg(SF2TMP->F2_DOC,SF2TMP->F2_SERIE,' ')
		_cCepx:= 	u_StCepReg(SF2TMP->F2_DOC,SF2TMP->F2_SERIE,'1')

		CB7->(DbSetOrder(4))
		If CB7->(DbSeek(xFilial('CB7')+SF2TMP->(F2_DOC+F2_SERIE)))
			If!Empty(DTOC(CB7->CB7_XDFEM))  .AND. !(CB7->CB7_STATUS $ "1/9")

				If !(Empty(Alltrim(SF2TMP->F2_XGUIA)))
					dbselectarea("SE2")
					SE2->(dbSetOrder(1))
					//If SE2->(DbSeek(Xfilial("SE2")  +'FIN'+padr(alltrim(SF2TMP->F2_EST+Right( AllTrim( SF2TMP->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
					//>> Chamado 006590 - Everson Santana - 26/09/18
					If SE2->(DbSeek(Xfilial("SE2")  +SF2TMP->F2_XPRFGUI+padr(alltrim(SF2TMP->F2_EST+Right( AllTrim( SF2TMP->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
						//<<
						If SE2->E2_SALDO > 0
							_cGuia:= 'Pendente'
						Else
							_cGuia:= 'Paga'
						Endif
					Else
						_cGuia:= 'Pendente'
					Endif
				Endif
				//SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,_cCepx,F2_PBRUTO,TPENT,TRANSP,OBS,.F.}))
				//SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' ') ,F2_PBRUTO,TPENT,TRANSP,OBS ,A1_XZONA,.F.}))
				SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,F2_SERIE,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' ') ,F2_PBRUTO,TPENT,TRANSP,OBS ,A1_XZONA,.F.}))
			Endif
		Else
			//SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,_cCepx,F2_PBRUTO,TPENT,TRANSP,OBS,.F.}))
			//SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' '),F2_PBRUTO,TPENT,TRANSP,OBS ,A1_XZONA,.F.}))
			SF2TMP->(aadd(aRet,{"LBNO",F2_DOC,F2_SERIE,TPFRET,_cGuia,F2_CLIENTE,F2_LOJA,cNomeCli,_cRegiao,dEmissao,F2_VOLUME1,IiF(!(Empty(Alltrim(_cCepx))),Transform(_cCepx,"@r 99999-999"),' '),F2_PBRUTO,TPENT,TRANSP,OBS ,A1_XZONA,.F.}))
		Endif
		_cGuia:= ''
		SF2TMP->(DbSkip())
	Enddo

	SF2TMP->(dbCloseArea())

Return aRet

Static Function VldTOKGer(oGet)
	Local nSelOK := 0

	aEval(oGet:aCols,{|x| If(x[01]=="LBOK",nSelOK++,nil)})
	If nSelOK == 0
		MsgAlert("Notas fiscais não selecionadas!!!",".:AVISO:.")
		Return .f.
	Endif

	If !MsgYesNo("Confirma geração do romaneio ?",".:AVISO:.")
		Return .f.
	Endif

	aCols := aClone(oGet:aCols)

Return .t.

//------------------------------------------------------------------------
// Funcao Marca/Desmarca notas fiscais
Static Function MarkDesm(oGetD,lAtu)
	Local nX
	Default lAtu := .T.
	For nX:=1 to Len(oGetD:aCols)
		oGetD:aCols[nX,1] := If(oGetD:aCols[nX,1]=="LBOK","LBNO","LBOK")
	Next
	oGetD:oBrowse:Refresh()
	If lAtu
		AtuInfoNFS(oGetD,.t.)  //Atualiza informacoes de Qtde Notas, Peso, Qtde Volumes
	Endif
Return

//Insere observação na nota
Static Function InsObs(_cNf,_cSerie,oGetD)

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

	Local nX // Chamado 007317 - Everson Santana	- 07.06.18

	If !__cUserId $ SuperGetMV("ST_OBSROMA",,"000000")
		MsgAlert("Atenção, seu usuário não tem permissão para inserir observação")
		Return
	EndIf

	aAdd(aParam,{1,"Observação:"	,Space(80)						,"@!","","","",80,.T.})

	If ParamBox(aParam,"Observação",aConfig,,,.F.,90,15)

		For nX:=1 to Len(oGetD:aCols)

			IF oGetD:aCols[nX,1] = "LBOK"

				DbSelectArea("SF2")
				SF2->(DbSetOrder(1))
				SF2->(DbGoTop())
				//	If SF2->(DbSeek(xFilial("SF2")+oGetD:aCols[nX,2]+'001'))
				If SF2->(DbSeek(xFilial("SF2")+oGetD:aCols[nX,2]+'001'))
					SF2->(RecLock("SF2",.F.))
					SF2->F2_XOBSROM	:= aConfig[1]
					SF2->(MsUnLock())

					_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_EMAIL"))+';'+ Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_SUPER")),"A3_EMAIL"))
					If Empty(_cEmail)
						_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_EMAIL"))+';'+ Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_SUPER")),"A3_EMAIL"))
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

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

					MsgAlert("Observação inserida com sucesso! "+oGetD:aCols[nX,2])
				Else
					MsgAlert("Documento não encontrado!")
				EndIf
			EndIf
		Next

	EndIf

	RestArea(_aArea)

Return

Static Function GravaRomaneio(cCodigoR)
	Local cCodRom
	Local nPosSel     := 1
	Local nPosNFS     := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_DOC"})
	Local nPosSerieS  := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_SERIE"})
	Local nPosCliente := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_CLIENTE"})
	Local nPosLojaCli := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_LOJA"})
	Local nPosRegiao  := 8//Ascan(aHeader,{|x| substr(Upper(Alltrim(x[2])),1,4)== "ZONA"})
	Local nPosQtdVol  := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_VOLUME1"})
	Local nPosPLiq    := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_PLIQUI"})
	Local nPosPBruto  := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_PBRUTO"})
	Local nX

	Local aParam	:= {}
	Local aConfig	:= {}
	Local aPedido	:= {}
	Local aAreaPD1	:= {}
	Local nQtdPalet := 0

	Default cCodigoR	:= ""

	If Empty(cCodigoR)
		cCodRom := PD1->(GetSX8Num("PD1","PD1_CODROM"))
		ConfirmSX8()

		aAdd(aParam,{1,"Motorista:"		,Space(TamSx3("PD1_MOTORI")[1])	,"@!","","DA4ST","",90,.T.})
		aAdd(aParam,{1,"Placa Veiculo:"	,Space(TamSx3("PD1_PLACA")[1])	,"@!","","DA302","",60,.T.})
		aAdd(aParam,{1,"Dt Entrega:"	,STOD(" ")						,"@D","","","",60,.T.})			//Chamado 008304 - Everson Santana - 01/11/218
		aAdd(aParam,{3,"Tipo Romaneio:"	,1,{"Entrega","Retira"},50,.T.,.T.})
		aAdd(aParam,{1,"Observação:"	,Space(200)						,"@!","","","",200,.T.})

		If !ParamBox(aParam,"Romaneio",aConfig,,,.F.,90,15)
			Help(" ",1,"NOROMANEIO",,"Não foi possivel gravar romaneio",1,0)
			Return
		EndIf

		PD1->(RecLock("PD1",.T.))
		PD1->PD1_FILIAL := xFilial("PD1")
		PD1->PD1_CODROM := cCodRom
		PD1->PD1_DTEMIS := dDataBase
		PD1->PD1_QTDVOL := nQtdVols
		PD1->PD1_PLIQ   := nPLiquido
		PD1->PD1_PBRUTO := nPBruto
		PD1->PD1_QTDPAL := nQtdPalet				// Valdemir Rabelo 13/04/2020
		PD1->PD1_STATUS := "0"

		PD1->PD1_MOTORI	:= aConfig[1]
		PD1->PD1_PLACA	:= aConfig[2]
		PD1->PD1_DTENT	:= aConfig[3] //Chamado 008304 - Everson Santana - 01/11/218
		PD1->PD1_TPROM	:= AllTrim(STR(aConfig[4]))
		PD1->PD1_OBS	:= aConfig[5]

		PD1->PD1_HRROM	:= Substr(Time(),1,5)

		PD1->(MsUnLock())
	Else
		cCodRom 	:= cCodigoR
		aAreaPD1 	:= PD1->(GetArea())

		If PD1->(DbSeek(xFilial("PD1")+cCodRom))
			PD1->(RecLock("PD1",.F.))
			PD1->PD1_QTDVOL := (PD1->PD1_QTDVOL + nQtdVols)
			PD1->PD1_PLIQ   := (PD1->PD1_PLIQ + nPLiquido)
			PD1->PD1_PBRUTO := (PD1->PD1_PBRUTO + nPBruto)
			PD1->PD1_STATUS := "0"
			PD1->(MsUnLock())
		EndIf
		RestArea(aAreaPD1)

	EndIf

	CB7->(DbSetOrder(4))
	SF2->(DbSetOrder(1))
	SD2->(DbSetOrder(3))
	SC5->(DbSetOrder(1))
	For nX:=1 to Len(aCols)
		If aCols[nX,01] == "LBNO"
			Loop
		Endif
		PD2->(RecLock("PD2",.T.))
		PD2->PD2_FILIAL := xFilial("PD2")
		PD2->PD2_STATUS := "0"
		PD2->PD2_CODROM := cCodRom
		PD2->PD2_NFS    := aCols[nX,nPosNFS]
		//-------------------------------------------------------------------------------------------//
		//FR - 22/05/2023 - Flávia Rocha - SIGAMAT CONSULTORIA
		//Correção para considerar notas de quaisquer série, pois estava fixa a série: '001'
		//as notas do Mercado Livre são série 003
		//PD2->PD2_SERIES := '001'
		//-------------------------------------------------------------------------------------------//
		PD2->PD2_SERIES := aCols[nX,nPosSerieS]
		PD2->PD2_CLIENT := aCols[nX,nPosCliente]
		PD2->PD2_LOJCLI := aCols[nX,nPosLojaCli]
		PD2->PD2_REGIAO := aCols[nX,nPosRegiao]
		PD2->PD2_QTDVOL := aCols[nX,nPosQtdVol]
		PD2->PD2_PLIQ   := aCols[nX,nPosPBruto]
		PD2->PD2_PBRUTO := aCols[nX,nPosPBruto]
		//	If CB7->(DbSeek(xFilial("CB7")+PD2->(PD2_NFS+PD2_SERIES)))
		//		PD2->PD2_STATUS := "2" //Fechado
		//	Else
		//		PD2->PD2_STATUS := "0"
		//	Endif
		PD2->(MsUnLock())

		If SA1->(DbSeek(xFilial("SA1")+PD2->(PD2_CLIENT+PD2_LOJCLI)))
			U_STFAT340("4","T",.T.)
			U_STFAT340("1","T",.T.)
		EndIf

		//Flag de controle de romaneio nas notas selecionadas:
		If SF2->(DbSeek(xFilial("SF2")+PD2->(PD2_NFS+PD2_SERIES)))

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XCODROM := cCodRom
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
	Next
	U_STFSF60C(PD1->PD1_CODROM,,PD2->PD2_NFS,PD2->PD2_SERIES) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)

Return

//------------------------------------------------------------------------
// Funcao atualiza informacoes da Qtde Notas, Qtde Volumes e Pesos
Static Function AtuInfoNFS(oGetD,lAtuTela)
	Local nPosVol  := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_VOLUME1"})
	Local nPosPLiq := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_PLIQUI"})
	Local nPosPBru := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_PBRUTO"})
	Local nPosPGuia := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="GUIA"})
	Local nNotas   := 0
	Local nVols    := 0
	Local nPesoL   := 0
	Local nPesoB   := 0
	Local nX
	//>> Chamado 007138 - Everson Santana - 03.04.18
	Local nY
	Local _aMen	:= {}
	Local _aMen1	:= {} //Chamado 005476
	Local _cMen1	:= ""
	Local _cMen	:= ""
	//<< Chamado 007138 - Everson Santana - 03.04.18

	For nX:=1 to Len(oGetD:aCols)

		//chamados 005927 e 005446 - Robson Mazzarotto

		IF oGetD:aCols[nX,1] = "LBOK"

			//>> Chamado 008680 - Everson Santana - 08.01.19
			If __cuserid = '001012'

				If oGetD:aCols[nX,13] $ 'R' .AND. SubString(oGetD:aCols[nX,15],1,3) <> 'TNT' // <> '000163' .AND. SF2TMP->TPENT   == 'R'

					MSGALERT("RETIRA -  BLOQUEADO PARA GERAR ROMANEIO")
					oGetD:aCols[nX,1] := "LBNO"

				EndIf

			EndIf
			//<< Chamado 008680
			if !U_STVLDROM(oGetD:aCols[nX,2],'001',oGetD:aCols[nX,5],oGetD:aCols[nX,6])
				//if !U_STVLDROM(oGetD:aCols[nX,2],'001',oGetD:aCols[nX,5],oGetD:aCols[nX,6])

				If SA1->(DbSeek(xFilial("SA1")+oGetD:aCols[nX,5]+oGetD:aCols[nX,6]))
					If !U_STFAT340("1","T",.T.)
						//Não faz nada pois a msg já é mostrada internamente
					Else
						MSGALERT("PEDIDO BLOQUEADO NO FINANCEIRO, AGUARDANDO LIBERAÇÃO PARA ENTREGA")
					EndIf
				EndIf

				oGetD:aCols[nX,1] := "LBNO"
			endif

			if !U_STVLDEAN(oGetD:aCols[nX,2],'001',oGetD:aCols[nX,5],oGetD:aCols[nX,6])
				MSGALERT("Pedido em retrabalho EAN14, favor aguardar")
				oGetD:aCols[nX,1] := "LBNO"
			endif

			IF oGetD:aCols[nX,5] $ GetMv("ST_CLIROMA",,"")
				Aadd(_aMen,oGetD:aCols[nX,2],'001') //>> Chamado 007138 - Everson Santana - 03.04.18
				//MsgAlert("A nota fiscal " + oGetD:aCols[nX,2],'001' + " selecionada pertence a cliente com entrega agendada !!!",".:AVISO:.")
			Endif

			IF oGetD:aCols[nX,5]+'00' $ GetMv("ST_ETIEXP",,"")
				Aadd(_aMen1,oGetD:aCols[nX,2],'001') //>> Chamado 005476 - Everson Santana - 10.10.18
			Endif

		ENDIF

		If oGetD:aCols[nX,1] == "LBOK"   .And. 'Pendente' $ oGetD:aCols[nX,4]
			oGetD:aCols[nX,1] := "LBNO"
		EndIf
		If oGetD:aCols[nX,1] == "LBOK"
			++nNotas
			nVols  += oGetD:aCols[nX,nPosVol]
			nPesoL += 0//oGetD:aCols[nX,nPosPLiq]
			nPesoB += oGetD:aCols[nX,nPosPBru]
		Endif
	Next
	//>> Chamado 007138 - Everson Santana - 03.04.18
	If Len(_aMen) > 0
		For nY := 1 To Len(_aMen)

			If Empty(_cMen)
				_cMen := _aMen[nY]
			Else
				_cMen += " - "+_aMen[nY]
			EndIf

		Next

		MsgAlert(_cMen, ".:AVISO:."+Chr(13) + Chr(10) +" As notas fiscais selecionadas pertence a cliente com entrega agendada !!!")

	EndIF
	//<< Chamado 007138 - Everson Santana - 03.04.18

	//>> Chamado 005476 - Everson Santana - 10.10.18
	If Len(_aMen1) > 0
		For nY := 1 To Len(_aMen1)

			If Empty(_cMen1)
				_cMen1 := _aMen1[nY]
			Else
				_cMen1 += " - "+_aMen1[nY]
			EndIf

		Next

		MsgAlert(_cMen1, ".:AVISO:."+Chr(13) + Chr(10) +" É necessario colar as etiquetas com o numero da nota fiscal nas notas abaixo. !!!")

	EndIF
	//<< Chamado 005476 - Everson Santana - 10.10.18

	nQtdNFS   := nNotas
	nQtdVols  := nVols
	nPBruto   := ROUND(nPesoB,0)
	nPLiquido := nPesoL

	If lAtuTela
		oQtdNFS:Refresh()
		oQtdVols:Refresh()
		oPBruto:Refresh()
		//oPLiquido:Refresh()
	Endif

Return

//------------------------------------------------------------------------
// Funcao carrega aHeader
Static Function CrgAheader()
	Local aCamposOK := {"F2_DOC","F2_SERIE","FRETE","GUIA","F2_CLIENTE","F2_LOJA","cNomeCli","REGIAO","F2_EMISSAO","F2_VOLUME1","CEPX","F2_PBRUTO","TPENT","TRANSP","OBS","MOTIVO"}
	Local aRet      := {}
	Local nX

	Aadd( aRet, {" ","MARKBROW","@BMP",2,0,"","","C","","" ,"","V","","V","S"} )
	SX3->(dbSetOrder(2))
	For nX := 1 to Len( aCamposOK )
		If SX3->( dbSeek( aCamposOK[nX] ) )
			aadd( aRet, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
			SX3->X3_CAMPO	, ;			// 02 - Campo
			SX3->X3_Picture	, ;			// 03 - Picture
			SX3->X3_TAMANHO	, ;			// 04 - Tamanho
			SX3->X3_DECIMAL	, ;			// 05 - Decimal
			"" 				, ; //SX3->X3_Valid  	, ;			// 06 - Valid
			SX3->X3_USADO  	, ;			// 07 - Usado
			SX3->X3_TIPO   	, ;			// 08 - Tipo
			SX3->X3_F3		, ;			// 09 - F3
			SX3->X3_CONTEXT , ;         // 10 - Contexto
			SX3->X3_CBOX	, ; 		// 11 - ComboBox
			"" 				, ; //SX3->X3_RELACAO   , ;         // 12 - Relacao
			"" 				, ; //SX3->X3_INIBRW  , ;			// 13 - Inicializador Browse
			SX3->X3_Browse  , ;			// 14 - Mostra no Browse
			""  } ) //SX3->X3_VISUAL  } )       // 15 - visual
		Else
			If aCamposOK[nX] $ "cNomeCli"
				If aCamposOK[nX] == "cNomeCli"
					aadd( aRet, { "Nome do Cliente", "","",30,0,"","","V","","V","S"} )
				Endif
			Endif
			If aCamposOK[nX] $ "FRETE"
				aadd( aRet, { "Tp.Frete", "","",3,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "REGIAO"
				aadd( aRet, { "Zona  .", "","",10,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "CEPX"
				aadd( aRet, { "Cep.Entrega", "","",8,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "GUIA"
				aadd( aRet, { "Guia   .", "","",8,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "TPENT"
				aadd( aRet, { "Tipo", "","",1,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "TRANSP"
				aadd( aRet, { "Transportadora   .", "","",40,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "OBS"
				aadd( aRet, { "Observação                   .", "","",80,0,"","","V","","V","S"} )
			Endif
			If aCamposOK[nX] $ "MOTIVO"
				aadd( aRet, { "Mot. retorno                       .", "","",100,0,"","","V","","V","S"} )
			Endif

		EndIf
	Next nX
Return aClone(aRet)

//------------------------------------------------------------------------
// Romaneio de Transporte - VISUALIZACAO / ALTERACAO
User Function STFSF60M( cAlias, nReg, nOpcx )
	Local oDlg
	Local nOpc      := 0
	Local cSeekPD2  := xFilial("PD1") + PD1->PD1_CODROM
	Local oEnc
	Local nOpca     := 0
	Local cTitDlg   := "Romaneio de Transporte"
	Local aButtons  := {}

	Local aSize     := {}
	Local aInfo     := {}
	Local aObjects  := {}
	Local lInclusao	:= .F.

	Private oTimer
	Private aHeader := {}
	Private aCols   := {}

	Private oGet

	If nOpcx == 4
		/* Retirado por solicitação do fabio.brito em 12/11/2013
		If PD1->PD1_STATUS == "2"  //Romaneio Fechado
		MsgAlert("O romaneio " + PD1->PD1_CODROM+ " está fechado, portanto não poderá ser alterado!!!",".:AVISO:.")
		Return
		*/
			If PD1->PD1_STATUS == "3"  //Romaneio Encerrado
				MsgAlert("O romaneio " + PD1->PD1_CODROM+ " está encerrado, portanto não poderá ser alterado!!!",".:AVISO:.")
				Return
			Endif

		Endif

		// Botoes especificos do EnchoiceBar:
		aadd(aButtons,{"PMSCOLOR",{||LegItens()},"Legenda" })
		// aadd(aButtons,{"PMSCOLOR",{||u_STFSF60G( cAlias, nReg, nOpcx ),lInclusao:= .T.,oDlg:End() },"Incluir Nota" })   ticket: 20200928008019
		aadd(aButtons,{"PMSCOLOR",{||u_STFSFA66( cAlias, nReg, nOpcx ) },"Imprimir Danfe" })
		If nOpcx = 4
			aadd(aButtons,{"PMSCOLOR",{||DELNFROM( cAlias, nReg, nOpcx, aCols )},"Estorna conferência" })
		EndIf

		RegToMemory("PD1",.F.,.F.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o cabecalho                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		If	dbSeek( "PD2" )
			Aadd( aHeader, {" ","MARKBROW","@BMP",2,0   ,"","","C",""  ,"" ,"","V","","V","S"} )
			While !Eof() .And. ( x3_arquivo == "PD2" )
				If X3USO(x3_usado) .And. cNivel >= x3_nivel .AND. !(AllTrim( x3_campo ) $ "PD2_CODROM|PD2_STATUS")
					AAdd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_f3, x3_context,x3_cbox,"","",x3_browse,""})
				EndIf
				dbSkip()
			EndDo
		EndIf

		//MontaCols(cSeekPD2)
		Processa( { || MontaCols(cSeekPD2) },'Aguarde','Selecionando Registros...', )

		aSize   := MsAdvSize()
		aAdd(aObjects, {100, 130, .T., .F.})
		aAdd(aObjects, {100, 200, .T., .T.})
		aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
		aPosObj := MsObjSize(aInfo, aObjects)

		DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitDlg) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

		oEnc:=MsMget():New(cAlias,nReg,nOpcx,,,,,{0,0,80,80},,3,,,,,,.t.)
		oEnc:oBox:Align:= CONTROL_ALIGN_TOP
		If nOpcx == 2 //Visualizar
			oGet:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], 2,,,,,,50,,,,oDlg,aHeader,aCols)
			oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		ElseIf nOpcx == 4 //Alteracao
			oGet:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], GD_DELETE,,,,,,50,,,,oDlg,aHeader,aCols)
			oGet:oBrowse:bDelete := {|| VldLinDel(oGet) }
			oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		Endif

		//DEFINE TIMER oTimer INTERVAL 1000 ACTION MontaCols(cSeekPD2,oGet) OF oDlg
		//oTimer:Activate()

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(nOpcx == 4,if(VldTOK(oGet,nOpcx),oDlg:End(),nOpca := 0),oDlg:End())},{||If(PD1->PD1_XALTER<>"S",oDlg:End(),MsgAlert("Favor utilizar o botão confirmar"))},,aButtons)

		If nOpca == 1 .AND. nOpcx == 4 .and. !lInclusao

			PD1->(Reclock("PD1",.F.))
			PD1->PD1_XALTER	:= ""
			PD1->PD1_PLACA  :=  M->PD1_PLACA
			PD1->PD1_MOTORI :=  M->PD1_MOTORI
			PD1->PD1_OBS	:=  M->PD1_OBS
			PD1->(Msunlock())

			Begin Transaction
				AtuRomaneio()
			End Transaction
		Endif

		If lInclusao
			u_STFSF60M( cAlias, nReg, nOpcx )
		EndIf

		Return

Static Function MontaCols(cSeekPD2,oGet,lEncerra)
	Local nCnt,nUsado
	Local oStatus
	Local oVerde	    := LoadBitMap(GetResources(),"BR_VERDE")
	Local oAmarelo	    := LoadBitMap(GetResources(),"BR_AMARELO")
	Local oVermelho	    := LoadBitMap(GetResources(),"BR_VERMELHO")
	Local oBranco  	    := LoadBitMap(GetResources(),"BR_BRANCO")
	Local oAzul		  	:= LoadBitMap(GetResources(),"BR_AZUL")
	Local oPreto	  	:= LoadBitMap(GetResources(),"BR_PRETO")

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
						oStatus := oVerde
					ElseIf PD2->PD2_STATUS == "1"
						oStatus := oAmarelo
					ElseIf PD2->PD2_STATUS == "2"
						oStatus := oVermelho
					ElseIf PD2->PD2_STATUS == "3"
						oStatus := oBranco
					ElseIf PD2->PD2_STATUS == "4"
						oStatus := oAzul
					ElseIf PD2->PD2_STATUS == "5"
						oStatus := oPreto
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

Static Function VldTOK(oGet,nOpcx)
	Local nPosDel:=0
	Local nDel

	If nOpcx == 2
		Return .t.
	Endif

	If !MsgYesNo("Confirma alterações ?",".:AVISO:.")
		Return .f.
	Endif

	nPosDel := Len(aHeader)+1
	nDel    := 0
	aEval(oGet:aCols,{|x| If(x[nPosDel],nDel++,nil)})

	If nDel == Len(oGet:aCols)
		If !MsgYesNo("Confirma exclusão do romaneio ?",".:AVISO:.")
			Return .f.
		Endif
	Endif
	aCols := aClone(oGet:aCols)

Return .t.

Static Function VldLinDel(oGet)
	Local nPosLinAtu    := oGet:nAt
	Local lDel

	If oGet:aCols[nPosLinAtu,Len(aHeader)+01]
		lDel := .f.
	Else
		lDel := .t.
	Endif

	If lDel .AND. oGet:aCols[nPosLinAtu,01]:cName $ "BR_AMARELO|BR_VERMELHO"
		MsgAlert("Item com processo de embarque em andamento ou já finalizado!!!",".:AVISO:.")
		Return .f.
	Endif

	oGet:aCols[nPosLinAtu,Len(aHeader)+01] := lDel
	oGet:Refresh()
	aCols := aClone(oGet:aCols)

Return .t.

Static Function AtuRomaneio(lEstorno)
	Local   nPosNFS
	Local   nPosSerieS
	Local   lLinhaDel
	Local   lLinhaSel
	Local   lDelAll  := .t.
	Local   nX
	Local nAux		:= 0
	Default lEstorno := .f.

	If cEmpAnt <> '03'// Ticket 20201028009606 - Everson Santana - 28.10.2020
		// Valdemir Rabelo 20/10/2020 - Chamado: 20200928008019
		FWMsgRun(,{|| Sleep(4000)},"Atenção!", "Rotina bloqueada para uso, entre em contato com TI.")
		Return
	EndIf

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

				//PD2->(RecLock("PD2",.F.))
				//PD2->(dbDelete())
				//PD2->(MsUnLock())
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
		U_STFSF60C(PD1->PD1_CODROM,lEstorno) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)
	Endif

Return

//------------------------------------------------------------------------
//Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)
User Function STFSF60C(cCodRomaneio,lEncerra,_cNote,_cSerious)
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
				Endif

				//	If PD2->PD2_STATUS == "2"   .And.  PD2->PD2_NFS = _cNote    .And.  PD2->PD2_SERIES = _cSeriousPD2
				//		U_STETIQBRAS(_cNote,_cSeriousPD2)
				//Endif

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
		//Atualiza informacao da tabela de Romaneio:
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_QTDVOL := nVols
		PD1->PD1_PLIQ   := nPesoL
		PD1->PD1_PBRUTO := nPesoB
		//PD1->PD1_STATUS := cStatus

		If lEncerra
			PD1->PD1_STATUS := "3"
			If cEmpAnt $ "01/11"       // Valdemir Rabelo 12/01/2022 - Ticket: 20220110000702
				PD1->PD1_XDTFR  := Date()
				PD1->PD1_XHRFR  := Time()
			EndIf
		Else
			//PD1->PD1_STATUS := "0"
		EndIf

		PD1->(MsUnLock())

	Endif
Return

//------------------------------------------------------------------------
// Romaneio de Transportes - ENCERRAMENTO
User Function STFSF60F( cAlias, nReg, nOpcx )
	Local oDlg
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
	Endif

	If cEmpAnt=="01"
		If !(PD1->PD1_STATUS == "5")
			MsgAlert("Rota não foi finalizada no APP, verifique!",".:AVISO:.")
			Return
		EndIf
		If PD1->PD1_STATUS == "5" .And. Empty(PD1->PD1_KMCHEG)   //Romaneio nao fechado
			MsgAlert("Romaneio sem KM de chegada, favor solicitar o fechamento pelo APP",".:AVISO:.")
			Return
		EndIf
	EndIf

	If STFSF60ATU()
		U_STFSF60C(PD1->PD1_CODROM,.T.)
	Else
		MsgAlert("Romaneio não encerrado.")
		Return
	EndIf

Return

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

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitDlg) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

	oEnc:=MsMget():New(cAlias,nReg,nOpcx,,,,,{0,0,80,80},,3,,,,,,.t.)
	oEnc:oBox:Align:= CONTROL_ALIGN_TOP

	oGetD    := MsNewGetDados():New( aPosObj[1][1],  aPosObj[1][2],  aPosObj[1][3],  aPosObj[1][4],,"AllWaysTrue()","AllWaysTrue()",,,,Len(aCols),,, ,oDlg, aHeader, aCols )
	//bDbClick := oGetD:oBrowse:bLDblClick
	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	// Habilita o Duplo Click trocando o valor da MarkBrowse
	// neste caso apenas quando estiver na primeira coluna da GetDados
	//oGetD:oBrowse:bLDblClick := {|| (Iif(oGetD:aCols[oGetD:nAt,1]=="LBNO",	oGetD:aCols[oGetD:nAt,1]:="LBOK",oGetD:aCols[oGetD:nAt,1]:="LBNO"),;
		//oGetD:oBrowse:Refresh(),"")}

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(VldTOKFec(oGetD),oDlg:End(),nOpca := 0)},{||oDlg:End()},,aButtons)

	If nOpca == 1
		Begin Transaction
			AtuRomaneio(.t.)
		End Transaction
	Endif

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
	If cEmpAnt=="01"
		nVlAbas		:= PD1->PD1_XVLAB
		nLtAbas		:= PD1->PD1_XLTAB
	EndIf

	aAdd( aParamBox,{1,"KM Saida"		,cKMSaid	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Hora Saida"		,cHrSaid	,"@R 99:99"	,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"KM Chegada"		,cKMCheg	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Hora Chegada"	,cHrCheg	,"@R 99:99"	,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Motorista"		,cMotori	,"@!"		,""	,""	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Ajudante 1"		,cAjuda1	,"@!"		,""	,"DAUST"	,""	,0	,.T.})
	aAdd( aParamBox,{1,"Ajudante 2"		,cAjuda2	,"@!"		,""	,"DAUST"	,""	,0	,.T.})
	If cEmpAnt=="01"
		aAdd( aParamBox,{1,"Valor abast."	,nVlAbas	,"@E 9,999,999.99"		,""	,""	,""	,0	,.T.})
		aAdd( aParamBox,{1,"Qtde litros"	,nLtAbas	,"@E 999"		,""	,""	,""	,0	,.T.})
	EndIf

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
	If cEmpAnt=="01"
		PD1->PD1_XVLAB	:= mv_par08
		PD1->PD1_XLTAB	:= mv_par09
	EndIf

	PD1->(MsUnlock())

	RestInter()

Return .t.

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

Static Function LegItens()
	Local cTitulo := "Detalhes dos documentos"

	Local aCores  := {	{"BR_VERDE"		,"- Não iniciado (EXP)" 	},;
		{"BR_AMARELO"	,"- Em andamento (EXP)"   },;
		{"BR_VERMELHO"	,"- Fechado (EXP)" 		},;
		{"BR_BRANCO"	,"- Pendente entrega (APP)"   },;
		{"BR_AZUL"		,"- Entregue (APP)"   },;
		{"BR_PRETO"		,"- Não entregue (APP)"   }}

	BrwLegenda(cTitulo,"Legenda",aCores)

Return

//------------------------------------------------------------------------
//Atualiza informacoes dos itens do Romaneio (status)
User Function STFSF60H(cCodRomaneio,cNota,Serie)

	Local   lBraspress   := Getmv("ST_BRASPRE",,.F.)
	Local   lTnt   		 := Getmv("ST_TNT",,.T.)
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _nOsAberta:= 0
	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYTEMP2"

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " +RetSqlName("CB7")+ " CB7 "
	cQuery1  += " WHERE CB7.D_E_L_E_T_=' ' AND CB7_STATUS='4' AND CB7_PEDIDO = ( "
	cQuery1  += " SELECT DISTINCT D2_PEDIDO "
	cQuery1  += " FROM " +RetSqlName("SD2")+ " D2 "
	cQuery1  += " WHERE D2.D_E_L_E_T_=' ' AND D2_FILIAL='"+cFilAnt+"' AND D2_DOC='"+cNota+"'
	cQuery1  += " AND D2_SERIE='"+Serie+"') "
	cQuery1  += " AND CB7_NOTA='"+cNota+"' "
	cQuery1  += " AND CB7_SERIE='"+Serie+"' "
	cQuery1  += " AND CB7_FILIAL='"+cFilAnt+"'  "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		_nOsAberta	:= (cAlias1)->CONTADOR
	EndIf

	PD2->(DbSetOrder(1))//PD2_FILIAL+PD2_CODROM+PD2_NFS+PD2_SERIES
	If PD2->(DbSeek(xFilial("PD2")+cCodRomaneio+cNota+Serie)) .And. _nOsAberta=0
		PD2->(RecLock("PD2",.F.))
		PD2->PD2_STATUS := "2"  //Fechados
		PD2->(MsUnLock())

		//INICIO GRAVACAO LOG Z05
		DbSelectArea("SC6")
		SC6->(DbSetOrder(4))
		IF SC6->(DbSeek(xFilial("PD2")+PD2->PD2_NFS+PD2->PD2_SERIES))
			u_LOGJORPED("PD1","8"," "," ",SC6->C6_NUM,"","Finalizacao romaneio",SF2->F2_VALBRUT)
		EndIf
		//FIM GRAVACAO LOG Z05			

		cQuery2 := " SELECT SUM(CASE WHEN PD2_STATUS='2' THEN 1 ELSE 0 END) QTDBIP, COUNT(*) QTDTOT
		cQuery2 += " FROM "+RetSqlName("PD2")+" PD2
		cQuery2 += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_FILIAL='"+PD2->PD2_FILIAL+"'
		cQuery2 += " AND PD2_CODROM='"+PD2->PD2_CODROM+"'

		If !Empty(Select(cAlias2))
			DbSelectArea(cAlias2)
			(cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

		dbSelectArea(cAlias2)
		(cAlias2)->(dbGoTop())

		If (cAlias2)->(!Eof())
			If (cAlias2)->QTDBIP==(cAlias2)->QTDTOT
				DbSelectArea("PD1")
				PD1->(DbSetOrder(1))
				If PD1->(DbSeek(PD2->(PD2_FILIAL+PD2_CODROM)))
				    if (PD1->PD1_STATUS != "3")            // Valdemir Rabelo 26/01/2021 - Ticket: 20210105000146
						PD1->(RecLock("PD1",.F.))
						PD1->PD1_STATUS := "2"
						PD1->(MsUnLock())
					Endif 
				EndIf
			EndIf
		EndIf

		If lBraspress .And. !Empty(_cRomaneio)
			U_STETIQBRAS(PD2->PD2_NFS,PD2->PD2_SERIES)
		EndIf

		If lTnt .And. !Empty(_cRomaneio)
			U_STETIQTNT(PD2->PD2_NFS,PD2->PD2_SERIES)
		EndIf

	Endif

Return

//------------------------------------------------------------------------
// Monitor de Controle Manaus
User Function STFSF60L()
	Local aCorDesc
	aCorDesc := {{ "ENABLE",		"- Não iniciado (EXP)" },;
		{ "BR_AMARELO",	"- Em andamento (EXP)" },;
		{ "BR_PRETO",	"- Fechado (EXP)" },;
		{ "BR_AZUL",	"- Em rota (APP)" },;
		{ "BR_LARANJA",	"- Rota finalizada (APP)" },;
		{ "DISABLE",	"- Encerrado (ADM)" }}

	BrwLegenda( "Legenda", "Status", aCorDesc )
Return

//------------------------------------------------------------------------
Static Function AjustaSX1()
	Local cAlias := Alias()
	Local aRegistros:={}
	Local i,j:=0

	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"01","Regiao de            ?","","","mv_ch1","C",TamSX3("A1_REGIAO")[01]	,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"02","Regiao ate           ?","","","mv_ch2","C",TamSX3("A1_REGIAO")[01]	,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"03","Nota Fiscal de       ?","","","mv_ch3","C",TamSX3("F2_DOC")[01]		,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"04","Nota Fiscal ate      ?","","","mv_ch4","C",TamSX3("F2_DOC")[01]		,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"05","Serie de             ?","","","mv_ch5","C",TamSX3("F2_SERIE")[01]	,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"06","Serie ate            ?","","","mv_ch6","C",TamSX3("F2_SERIE")[01]	,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"07","Cliente de           ?","","","mv_ch7","C",TamSX3("F2_CLIENTE")[01]	,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"08","Loja de              ?","","","mv_ch8","C",TamSX3("F2_LOJA")[01]		,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"09","Cliente ate          ?","","","mv_ch9","C",TamSX3("F2_CLIENTE")[01]	,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"10","Loja ate             ?","","","mv_cha","C",TamSX3("F2_LOJA")[01]		,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"11","Emissao de           ?","","","mv_chb","D",TamSX3("F2_EMISSAO")[01]	,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"12","Emissao ate          ?","","","mv_chc","D",TamSX3("F2_EMISSAO")[01]	,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"13","Transportadora De    ?","","","mv_chd","C",TamSX3("F2_TRANSP")[01]	,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"14","Transportadora Ate   ?","","","mv_che","C",TamSX3("F2_TRANSP")[01]	,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","","",""})
	aadd(aRegistros,{Padr("STFSF60",Len(SX1->X1_GRUPO),""),"15","Tipo de frete	     ?","","","mv_chf","C",2							,0,0,"C","","mv_par15","CC-CIF COM END","","","","","CS-CIF SEM END","","","","","FB-FOB","","","","","SF-SEM FILTRO","","","","","","","","","","","","","",""})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	For i:=1 to Len(aRegistros)
		If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegistros[i,j])
			Next j
			MsUnlock()
		EndIf
	Next I
	dbSelectArea(cAlias)
Return

//------------------------------------------------------------------------
//Renato Nogueira - Função para eliminar a conferência - Solicitação fabio.brito
Static Function DELNFROM(cAlias,nReg,nOpcx,aCols)

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
		/*
		cQuery := " SELECT CB7_ORDSEP ORDSEP, CB7_NOTA NF, CB7_SERIE SERIE "
		cQuery += " FROM " +RetSqlName("CB7")+ " CB7 "
		cQuery += " WHERE CB7.D_E_L_E_T_=' ' AND CB7_FILIAL='"+xFilial("CB7")+"' AND CB7_NOTA='"+cNf+"' AND CB7_SERIE='"+cSerie+"'

		If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		cOrdSep	:= (cAlias)->ORDSEP

		If Empty(cOrdSep)
		MsgAlert("Nota fiscal não encontrada, verifique")
		Return()
		EndIf
		*/
		DbSelectArea("CB9")
		CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
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
		PD2->(DbSeek(xFilial("PD2")+PD1->PD1_CODROM+cNf+cSerie))

		If !PD2->(Eof())

			PD1->(RecLock("PD1",.F.))
			PD1->PD1_STATUS := "4"
			PD1->(MsUnLock())

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS	:= "3"
			PD2->PD2_XDTBX  := CTOD("  /  /    ")
			PD2->PD2_XHRBX	:= ""
			PD2->PD2_XUSBX	:= ""
			PD2->PD2_MOTIVO := ""
			PD2->PD2_MOT2 := ""
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

User Function STFSF60X()

	If PD1->PD1_STATUS <> '5'

		PD2->(DbSetOrder(1))
		PD2->(DbSeek(xFilial("PD2")+PD1->PD1_CODROM))
		While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+PD1->PD1_CODROM)

			PD2->(RecLock("PD2",.F.))
			PD2->PD2_STATUS := "3"  //Fechados
			PD2->(MsUnlock())

			PD2->(DbSkip())
		Enddo
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_STATUS := "4"  //Fechados
		PD1->(MsUnlock())

	EndIf
Return()

User Function STFINROM()

	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local _lContinua	:= .T.
	Local _cQuery		:= ""
	Local nErrC6    	:= 0
	Local nQtdPalet     := 0

	// Ticket 20210827017169 - FINALIZAÇÃO DO ROMANEIO -- Eduardo Pereira Sigamat -- 31.08.2021 - Comentei o que esta abaixo e ajustei o tratamento
	If !(cEmpAnt == "01" .And. cFilant == "05" .Or. cEmpAnt == "03" .And. cFilant == "01")	//!(cEmpAnt=="01" .and. cFilant = "05") .OR. (cEmpAnt=="03" .and. cFilant = "01")  //!(cEmpAnt=="03")
		MsgAlert("Atenção, rotina só pode ser utilizada na empresa 03")
		Return
	EndIf

	If AllTrim(PD1->PD1_STATUS)=="3"
		MsgAlert("Romaneio já finalizado, verifique!")
		Return
	EndIf

	cQuery := " SELECT DISTINCT C9_LOCAL LOCAL "
	cQuery += " FROM " +RetSqlName("SC9")+ " C9 "
	cQuery += " WHERE C9.D_E_L_E_T_=' ' AND C9_NFISCAL IN ( "
	cQuery += " SELECT PD2_NFS "
	cQuery += " FROM " +RetSqlName("PD2")+ " PD2 "
	cQuery += " WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL='"+PD1->PD1_FILIAL+"' "
	cQuery += " AND PD2.PD2_CODROM='"+PD1->PD1_CODROM+"' "
	cQuery += " ) GROUP BY C9_LOCAL "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbSelectArea("Z44")
	dbSetOrder(1)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		If !(AllTrim((cAlias)->LOCAL)=="15")
			MsgAlert("Atenção, local diferente de 15, não é possível finalizar!")
			Return
		EndIf

		(cAlias)->(DbSkip())
	EndDo

	Begin Transaction

		IF !PD2->( dbSeek(xFilial("PD2")+PD1->PD1_CODROM) )
			MsgAlert("Item do romaneio não encontrado")
			Return
		ENDIF

		if Z44->( dbSeek(xFilial('Z44')+PD2->PD2_CLIENT+PD2->PD2_LOJCLI) )
			IF (Z44->Z44_NECPAL=="S")
				nQtdPalet := Val(FWInput("Informe o numero de Paletes",""))
			ENDIF
		endif

		PD1->(RecLock("PD1",.F.))
		PD1->PD1_STATUS	:= "3"
		PD1->PD1_QTDPAL := nQtdPalet
		PD1->(MsUnLock())

		_cQuery	:= " UPDATE "+RetSqlName("PD2")+" PD2 "
		_cQuery	+= " SET PD2.PD2_STATUS='2'
		_cQuery	+= " WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL='"+PD1->PD1_FILIAL+"'
		_cQuery	+= " AND PD2.PD2_CODROM='"+PD1->PD1_CODROM+"' "

		nErrC6 := TCSqlExec( _cQuery )

		If nErrC6 <> 0
			Return MsgStop("TCSQLError() " + TCSQLError())
		EndIf

	End Transaction

	MsgAlert("Romaneio finalizado com sucesso!")

Return()

USER Function STVLDROM(cNota,cSerie,cCliente,cLoja)

	Local _lRet := .T.
	Local _cStsPed := ""

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbGoTop()

	if dbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cLoja)

		while !eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+cNota+cSerie+cCliente+cLoja

			_cStsPed := Posicione("SC5",1,XFILIAL("SC5")+SD2->D2_PEDIDO,"C5_XBLQROM")

			IF _cStsPed = "S"
				_lRet := .F.
			endif

			_cStsPed := ""

			dbSelectArea("SD2")
			dbSkip()
		End

	Endif

Return _lRet

USER Function STVLDEAN(cNota,cSerie,cCliente,cLoja)

	Local _lRet := .T.
	Local _cStsPed := ""

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbGoTop()

	if dbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cLoja)

		while !eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+cNota+cSerie+cCliente+cLoja

			_cStsPed := Posicione("SC5",1,XFILIAL("SC5")+SD2->D2_PEDIDO,"C5_XREAN14")

			IF _cStsPed = "S"
				_lRet := .F.
			endif

			_cStsPed := ""

			dbSelectArea("SD2")
			dbSkip()
		End

	Endif

Return _lRet

//Insere observação na nota individual
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

	If !__cUserId $ SuperGetMV("ST_OBSROMA",,"000000")
		MsgAlert("Atenção, seu usuário não tem permissão para inserir observação")
		Return
	EndIf

	aAdd(aParam,{1,"Observação:"	,Space(80)						,"@!","","","",80,.T.})

	If ParamBox(aParam,"Observação",aConfig,,,.F.,90,15)

		DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		SF2->(DbGoTop())
		If SF2->(DbSeek(xFilial("SF2")+oGetD:aCols[oGetD:nat,2]+'001'))

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XOBSROM	:= aConfig[1]
			SF2->(MsUnLock())

			_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_EMAIL"))+';'+ Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_SUPER")),"A3_EMAIL"))
			If Empty(_cEmail)
				_cEmail	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_EMAIL"))+';'+ Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_SUPER")),"A3_EMAIL"))
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

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			MsgAlert("Observação inserida com sucesso! "+oGetD:aCols[oGetD:nat,2])
		Else
			MsgAlert("Documento não encontrado!")
		EndIf

	EndIf

	RestArea(_aArea)

Return

User Function STFSFA64()

	U_STTNT010(.T.)

Return()

User Function STFSFA65()

	U_STBRA010(.T.)

Return()

	/*/{Protheus.doc} User Function ExpExcel
	(long_description)
	Rotina que exporta dados para planilha Excel
	Ticket: 20200214000549
	@author user
	VALDEMIR RABELO (SIGAMAT)
	@since 02/04/2020
	@example
	(examples)
	/*/
Static Function ExpExcel()
	Local aCabecEX := {}
	Local aColsEX  := {}
	Local aTipos   := {}
	Local aAreaEX  := GetArea()
	Local aColTMP  := {}
	Local nX, nY

	aEval(aHeader, {|X| if(!Empty(X[1]), aAdd(aCabecEX, X[1]),nil) })
	aEval(aHeader, {|X| if(!Empty(X[1]), aAdd(aTipos, X[8]),nil)})

	// Remove campo Seleção e Marcação de Deletados
	For nX := 1 to Len(aCols)
		aColTMP := {}
		For nY := 1 to Len(aCols[nX])-2
			if nY > 1
				aAdd(aColTMP, aCols[nX][nY])
			Endif
		Next
		aAdd(aColsEX, aColTMP)
	Next

	//DlgToExcel({ {"ARRAY", "ROMANEIO", aCabecEX, aColsEX} })
	//StaticCall (STFSLIB, ExpotMsExcel, aCabecEX, aColsEX, aTipos, "LISTA DE NOTAS PARA ROMANEIO")
	U_ExpotMsExcel(aCabecEX, aColsEX, aTipos, "LISTA DE NOTAS PARA ROMANEIO")

	RestArea( aAreaEX )

Return

User Function STFSFA66( cAlias, nReg, nOpcx )

	Local _nPosNF 		:= Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="PD2_NFS"})
	Local _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')

	_cNf := oGet:aCols[oGet:nAt][_nPosNf]

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	If SF2->(DbSeek(xFilial("SF2")+_cNf+'001'))

		U_STRONFE(SF2->F2_CHVNFE,.T.)

		If !ExistDir(_cDirRel)
			MakeDir(_cDirRel)
		Endif

		_cNomePdf := SF2->F2_CHVNFE

		FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
		CpyS2T("\arquivos\xml_nfe\"+cEmpAnt+"\"+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

	EndIf

Return

/*/{Protheus.doc} NewColor
@name NewColor
@type Static Function
@desc cor das linhas
@author Renato Nogueira
@since 04/09/2017
/*/

Static Function NewColor(_nLinha)

	Local nCor1 	:= CLR_WHITE	// Branco
	Local nCor2 	:= CLR_YELLOW	// Amarelo
	Local nRet  	:= nCor1
	Local nPosNFS   := Ascan(aHeader,{|x| Upper(Alltrim(x[2]))=="F2_DOC"})
	Local _aAreaPD2 := PD2->(GetArea())

	PD2->(DbSetOrder(2))
	If PD2->(DbSeek(xFilial("PD2")+aCols[_nLinha][nPosNFS]+"001"))
		nRet := nCor2
	EndIf

	RestArea(_aAreaPD2)

Return(nRet)
