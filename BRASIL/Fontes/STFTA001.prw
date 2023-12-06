#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#Include "Colors.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#DEFINE CR    chr(13)+chr(10)

Static cRETGERVR
Static cIDMODEL := 'FIELD1'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ STFTA001 ³ Autor ³ RVG Solucoes          ³ Data ³13.12.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cadastro de Oportunidade de Venda Unidade Combinada - UNICOM  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³Steck                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFTA001()

	// Define Variaveis
	Local aArea		:= GetArea()
	Local cFiltro 	:= ""
	Local cUsrFilt	:= ""
	Local aCores	:= {	{ 'PP7_STATUS=="1"' , 'ENABLE' }	,; 											//Includio
	{ 'PP7_STATUS=="2"' , 'BR_PRETO'}	,;											//Cancelado
	{ 'PP7_STATUS=="8"' , 'BR_BRANCO'}	,;											//Cancelado
	{ 'PP7_STATUS=="3" .And. Empty(Alltrim(PP7_PEDIDO))' , 'BR_AMARELO'}	,;		//Em Desenvolvimento Engenharia
	{ 'PP7_STATUS=="6"' , 'BR_LARANJA'}	,; 											//Em Orcamento
	{ 'PP7_STATUS=="3" .And. !Empty(Alltrim(PP7_PEDIDO))' , 'BR_AZUL'}	,;   		//Em Aprovacao
	{ 'PP7_STATUS=="7"' , 'BR_MARROM'}	,;   										//Em Aprovacao
	{ 'PP7_STATUS=="5" .and. Empty(Alltrim(PP7_TRAVA))' , "BR_PINK"}	,;   		//Prc.Final
	{ 'PP7_STATUS=="5" .and. !Empty(Alltrim(PP7_TRAVA)) ' , 'DISABLE'}}  			//Concluido
	Private _cIntern    := .T.
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If !Alltrim(SA3->A3_TIPO) $ ('I#E') // Tciket 20210119000991 - Everson Santana - 03.02.2021 
			_cIntern:= .f.
		EndIf
	EndIf

	PRIVATE cCadastro 	:= "UNICOM"
	PRIVATE aRotina 	:= MenuDef(_cIntern)
	PRIVATE aButtons	:= {}
	Private _aCusto     := {}

	DbSelectArea("PP7")
	DbSetOrder(1)
	If !_cIntern
		PP7->(dbSetFilter({|| PP7->PP7_REPRES  ==  SA3->A3_COD }," PP7->PP7_REPRES  ==  SA3->A3_COD"))
	EndIf

	mBrowse( 6, 1,22,75,"PP7",,,,,,aCores)

	If !_cIntern
		PP7->(DbClearFilter())
	EndIf
	RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT001Alt  ³ Autor ³ RVG Solucoes          ³ Data ³13.12.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Tratamento para Visualizacao,Alteracao e Exclusao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Verdadeiro                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do arquivo                                     ³±±
±±³          ³ExpN2: Registro do Arquivo                                  ³±±
±±³          ³ExpN3: Opcao da MBrowse                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Ft001Alt(cAlias,nReg,nOpcx)

	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()
	Local aTitles   := { }
	Local aMessage  := {}
	Local aHelp     := {}
	Local aFolder	:= {}
	Local aColsProd	:= {}
	Local aButtons  := {}

	Local bWhile    := {|| .T. }
	Local bCampo 	:= { |cCampo| ( cAlias )->( FieldGet( ( cAlias )->( FieldPos( cAlias + "_" + cCampo ) ) ) ) }

	Local cCadastro := "UNICOM"
	Local cQuery    := ""
	Local cTrab     := "PP7"
	Local cNRopor   := ""
	Local cRevisa   := ""
	Local cModRevis := ""
	Local cMotivo	:= Space(TamSX3("UN_ENCERR")[1])
	Local cMemo		:= ""
	Local cMensagem := ""
	Local cVend		:= ""
	Local dDTPRZ    := ctod("  /  /  ")

	Local lContinua := .T.
	Local lContMsEx	:= .T.
	Local lQuery    := .F.
	Local lNewRevis := .T.
	Local lVisRevis	:= .F.

	Local nUsado    := 0
	Local nCntFor   := 0
	Local nCusto    := 0
	Local nOpcA     := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aWFDes 	:= {}
	Local aRegis 	:= {}


	Local lInclui	:= IIF(INCLUI,.T.,.F.)
	Local oEnch
	Local lEncerrada:= .F.
	Local lOrcamento:= .F.
	Local cEmailDes := ""

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE lAltEnt	:= Nil
	PRIVATE	Inclui 	:= .F.
	PRIVATE	Altera 	:= .F.
	PRIVATE	Exclui	:= .F.
	PRIVATE	Visual	:= .F.
	PRIVATE _cGetUser  := GetMv("ST_UNI001",,"000000")

	Do Case
	Case nOpcx = 2
		Visual 	:= .T.
	Case nOpcx = 3
		Inclui 	:= .T.
		Altera 	:= .F.
	Case nOpcx = 4
		Inclui 	:= .F.
		Altera 	:= .T.
		AAdd( aButtons,{"SVM",{|| U_STVENUNI()},"Alterar vendedor","Alterar vendedor"})
		AAdd( aButtons,{"SVM",{|| u_DadosSD(aCols,oGetDad1) },"Dados Sol.Desenho","Dados Sol.Desenho"})		// Valdemir Rabelo 26/03/2020
		AAdd( aButtons,{"SVM",{|| U_STRELSD(aCols,oGetDad1)},"Rel.Sol.Desenho","Rel.Sol.Desenho"})			// Valdemir Rabelo 24/03/2020
	Case nOpcx = 5
		Exclui	:= .T.
		Visual	:= .F.
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para permitir ou nao o prosseguimento da³
	//³inclusao/alteracao/exclusao/visualizacao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SA3 correto de acordo com o representante utilizado na workarea³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cNRopor 	:= Eval( bCampo, "NROPOR" )
	cRevisa	 	:= Eval( bCampo, "REVISA" )
	lVisRevis	:= .f.

	If !Empty( Eval( bCampo, "NUMORC" ) )
		DbSelectArea("SCJ")
		DbSetOrder(1)
		DbSeek(xFilial("SCJ")+Eval( bCampo, "NUMORC" ))
	EndIf

	lEncerrada := If(PP7->PP7_STATUS == "5", .T., .F.)
	lOrcamento := .F.

	//If aRotina[nOpcx,4]==2 .OR. aRotina[nOpcx,4] == 3 .OR. (!lEncerrada .AND. !lOrcamento)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a Variaveis da Enchoice.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory( cAlias , INCLUI , .T. )

	//Ft001Acols(nOpcX		, @aHeader1	,  @aCols1	,  cNRopor	,	cRevisa		, @aColsProd)

	aHeader1 :=  _CriaHeader("PP8","")//,"PP4_CODIGO")
	aCols1   := _carga_Acols("PP8",1,"PP8_CODIGO",M->PP7_CODIGO,aHeader1)

	cVend  := M->PP7_VEND
	cRepr  := M->PP7_REPRES
	dDTPRZ := M->PP7_PRAZO				// Valdemir Rabelo 09/01/2020

	aSize    := MsAdvSize()

	aObjects := {}
	AAdd( aObjects, {  60, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	nGetLin := aPosObj[2,1] + 200

	nCusto  := 0 // OU MONTACUSTO

	IF Visual
		_nfator := 25
	else
		_nfator := 0
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da Tela                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DEFINE MSDIALOG oDlgp TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL
	//oEnch 	:= MsMGet():New(cAlias,nReg,nOpcx,,,,, aPosObj[1], , 3, , , , , , .F.)
	oEnch 	:= MsMGet():New(cAlias,nReg,nOpcx,,,,, {aPosObj[1,1],aPosObj[1,2]+_nfator,aPosObj[1,3],aPosObj[1,4]}, , 3, , , , , , .F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as posicoes da Getdados a partir do folder    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nGd1 	:= 2
	nGd2 	:= 2
	nGd3 	:= aPosObj[2,3]//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 	:= aPosObj[2,4] //aPosObj[2,4]-aPosObj[2,2]-4
	nOpcGD	:= IIF(!INCLUI.And.!ALTERA,0,GD_INSERT+GD_UPDATE+GD_DELETE)

	oGetDad1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2]+_nfator,nGd3,nGd4,;
		GD_INSERT+GD_DELETE+GD_UPDATE,;
		"AllwaysTrue()",;
		"AllwaysTrue()",;
		"",;
		,;
		,;
		9999,;
		,;
		,;
		,;
		oDlgp,;
		aHeader1,;
		aCols1)

	oGetDad1:bchange := {||ft001adl()}

	nAjustBot := 80
	IF Visual
		If _cIntern
			If !(__cuserid $ GetMv("ST_UNI003",,'000388'))
				@ 010+nAjustBot,2 BTNBMP oBtn1 RESOURCE "FORM" 		SIZE 40,40 ACTION GeraOrc() MESSAGE "Enviar p/ Orcamento"
				If __cuserid $ GetMv("ST_UNI002",,'000375/000000/000315/000231')
					@ 045+nAjustBot,2 BTNBMP oBtn2 RESOURCE "S4WB008N" 	SIZE 40,40 ACTION GeraCst() MESSAGE "Ver Custo"
				EndIf
				@ 080+nAjustBot,2 BTNBMP oBtn6 RESOURCE "S4WB010N" 	SIZE 40,40 ACTION ORCCLIE() MESSAGE "Orcamento Cliente"
				@ 115+nAjustBot,2 BTNBMP oBtn3 RESOURCE "CHAVE2" 	SIZE 40,40 ACTION AprClie() MESSAGE "Aprovacao / Gerar S.D."
				@ 150+nAjustBot,2 BTNBMP oBtn3 RESOURCE "BMPPARAM" 	SIZE 40,40 ACTION ReabrSd() MESSAGE "Reabre S.D. "
				@ 185+nAjustBot,2 BTNBMP oBtn7 RESOURCE "S4WB011N" 	SIZE 40,40 ACTION ApvDese() MESSAGE "Aprovacao Desenho."
				@ 220+nAjustBot,2 BTNBMP oBtn8 RESOURCE "AUTOM" 	SIZE 40,40 ACTION GeraPv()  MESSAGE "Gerar Pedido de Venda..."
				@ 300+nAjustBot,2 BTNBMP oBtn6 RESOURCE "OK" 		SIZE 40,40 ACTION LibOrc()  MESSAGE "Libera Orcamento "
				@ 350+nAjustBot,2 BTNBMP oBtn6 RESOURCE "SIMULACA" 	SIZE 40,40 ACTION OrcInte() MESSAGE "Orcamento Interno"
				@ 385+nAjustBot,2 BTNBMP oBtn5 RESOURCE "S4WB009N" 	SIZE 40,40 ACTION VerHist() MESSAGE "Historico..."
				@ 255+nAjustBot,2 BTNBMP oBtn3 RESOURCE "EDITABLE" 	SIZE 40,40 ACTION xReabrSd() MESSAGE "Reabre Orcamento"

				If __cuserid $ _cGetUser
					@ 420+nAjustBot,2 BTNBMP oBtn3 RESOURCE "BUDGETY" 	SIZE 40,40 ACTION GeraGru() MESSAGE "Definir Grupo"
				EndIf
			Else
				@ 010+nAjustBot,2 BTNBMP oBtn1 RESOURCE "FORM" 		SIZE 40,40 ACTION GeraOrc() MESSAGE "Enviar p/ Orcamento"
			EndIf
			//	@ 370+nAjustBot,2 BTNBMP oBtn5 RESOURCE "BUDGETY" 	SIZE 40,40 ACTION GrpComi() MESSAGE "Grupo de Comissoes"
		Endif
	Endif
	cBkpStatus := PP7->PP7_STATUS

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ACTIVATE MSDIALOG oDlgp ON INIT EnchoiceBar(oDlgp, {||nOpcA := 1 ,iif(Empty(Alltrim(M->PP7_OBRA)),MsgInfo("preencha o Campo Obra"),oDlgp:End())} ,{||nOpcA := 0,oDlgp:End()},,aButtons)

	If ( nOpcA == 1 )

		FT001Cnf(nOpcx		, @oGetDad1	, cMotivo	, cMemo		,;
			nSaveSx8	, @aColsProd, aCols, aHeader )

		If nOpcx == 3
			If !Empty(SA1->A1_XCODMC)
				PP7->(RecLock("PP7",.F.))
				PP7->PP7_ZBLOQ	:= "1"
				PP7->PP7_ZMOTBL 	:= "MSG/"
				PP7->(MsUnLock())
				MsgAlert("Este orçamento encontra-se bloqueado!")
			EndIf
		EndIf
		/*
		//Chamado 000819 - Produtos de catalogo
		DbSelectArea("PP8")
		PP8->(DbSetOrder(1)) //PP8_FILIAL+PP8_CODIGO+PP8_ITEM
		PP8->(DbGoTop())
		If PP8->(DbSeek(xFilial("PP8")+PP7->PP7_CODIGO))

			While PP8->(!Eof()) .And. PP8->(PP8_FILIAL+PP8_CODIGO)==PP7->(PP7_FILIAL+PP7_CODIGO)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
				If SB1->(DbSeek(xFilial("SB1")+PP8->PP8_PROD))
					If AllTrim(PP8->PP8_STATUS)=="I" .And. !AllTrim(SB1->B1_GRUPO) $ "039#040#041#999" .And. !PP8->PP8_STATUS $ "E#O#P#Z"
		PP8->(RecLock("PP8",.F.))
		PP8->PP8_STATUS	:= "E" //Produto de catalogo - Deixar gerar pedido direto - Chamado 000819
		PP8->(MsUnLock())
					EndIf
				EndIf

		PP8->(DbSkip())
			EndDo

		EndIf
		//-------------------------------------------------------
		*/
		// Valdemir Rabelo 09/01/2020
		if ((nOpcx ==3) .or. (nOpcx ==4)) .AND. (dDTPRZ != PP7->PP7_PRAZO)
			aWFDes := {}
			aRegis := {}
			cEmailPrz := SuperGetMV("ST_WFDTPRZ",.f.,"filipe.nascimento@steck.com.br,francis.lima@steck.com.br,gustavo.joaquim@steck.com.br")	// Valdemir Rabelo 06/12/2019

			Aadd( aRegis , { "Atendimento: "    , PP7->PP7_CODIGO  } )
			Aadd( aRegis , { "Prazo: "    		, dtoc(PP7->PP7_PRAZO) } )
			Aadd( aRegis , { "Data: "    		, dtoc(dDataBase) } )
			Aadd( aRegis , { "Hora: "    		, time() } )
			Aadd( aRegis , { "Usuario: "   		, Alltrim(cUserName) } )
			aAdd( aWFDes, aRegis)
			aRegis := {}
			// ------------ Adicionando Vendedor Externo - 11/08/2020 -----------
			SA1->( dbSetOrder(1) )
			SA1->( dbSeek(xFilial('SA1')+PP7->PP7_CLIENT+PP7->PP7_LOJA) )
			IF !EMPTY(SA1->A1_VEND)
				cTMP := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND, "A3_EMAIL")
				if !Empty(cTMP)
					cEmailPrz += ","+cTMP
				Endif
			Endif
			//---------------------------------------------------------------------
			// Valdemir Rabelo 11/02/2020
			if !Empty(PP7->PP7_VEND)
				cTMP := Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND, "A3_EMAIL")
				if !Empty(cTMP)
					cEmailPrz += ","+cTMP
				Endif
			Endif
			EnviaWF(aWFDes, cEmailPrz, "AVISO - REGISTROS PENDENTES ( DATA PRAZO INFORMADO )")
		endif
	Else
		If INCLUI
			While (GetSx8Len() > nSaveSx8)
				RollBackSX8()
			End
		EndIf

	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade dos dados                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Endif
	MsUnLockAll()
	RestArea(aArea)
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FT001Cnf  | Autor ³  RVG Solucoes                 ³ Data ³13.12.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava a oportunidade                                                ³±±
±±³          ³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Totvs                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Analista     ³ Data   ³ BOPS ³          Manutencoes efetuadas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               ³        ³      ³                                                ³±±
±±³               ³        ³      ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FT001Cnf(	nOpcx	, oGetDad1	, cMotivo	, cMemo		, nSaveSx8, aColsProd	)

	Local lContinua   := .T.
	Local lNewRevis   := .T.
	Local lRet        := .T.
	Local xRet		  := {}
	Local cModRevis   := ""
	Local aMessage    := {}
	Local aHelp       := {}
	Local nI          := 0 //Indice do laco
	Local lObs        := .F.			// Valdemir Rabelo 28/01/2020

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida a exclusao da oportunidade de venda                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lContinua := If( nOpcx == 5, FtCanDelOv( @aMessage, @aHelp ), .T. )

	If lContinua

		lNewRevis := .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se deve gerar uma nova revisao da oporutidade de venda               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF EXCLUI
			RecLock("PP7",.F.)
			DbDelete()
			Msunlock()
			Dbselectarea("PP8")
			Dbsetorder(1)
			dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
			Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
				RecLock("PP8",.F.)
				PP8->PP8_HIST := PP8->PP8_HIST +  "ITEM EXCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
				DbDelete()
				Msunlock()
				Dbskip()
			Enddo

		ELSEIF !VISUAL
			If INCLUI
				While (GetSx8Len() > nSaveSx8)
					ConfirmSX8()
				End
				RecLock("PP7",.T.)
				PP7_FILIAL := xFilial("PP7")
				PP7_CODIGO  := M->PP7_CODIGO
				PP7_STATUS  := "1"
				PP7_ENVM 	:= Date()
				EvalTrigger()
			ElseIf ALTERA
			    lObs := (PP7->PP7_PRAZO  != M->PP7_PRAZO)			// Valdemir Rabelo 28/01/2020
				RecLock("PP7",.F.)
			EndIf

			PP7->PP7_CLIENT	:=M->PP7_CLIENT
			PP7->PP7_LOJA	:=M->PP7_LOJA
			PP7->PP7_NOME	:=M->PP7_NOME
			PP7->PP7_EMISSA	:=M->PP7_EMISSA
			PP7->PP7_REPRES	:=M->PP7_REPRES
			PP7->PP7_VEND	:=M->PP7_VEND
			PP7->PP7_NOTAS	:=M->PP7_NOTAS
			PP7->PP7_DTNEC	:=M->PP7_DTNEC
			PP7->PP7_OBRA	:=M->PP7_OBRA
			PP7->PP7_ENDOBR	:=M->PP7_ENDOBR
			PP7->PP7_CPAG	:=M->PP7_CPAG
			PP7->PP7_TIPF	:=M->PP7_TIPF
			PP7->PP7_TIPO	:=M->PP7_TIPO
			PP7->PP7_CODCON :=M->PP7_CODCON
			PP7->PP7_CONTAT :=M->PP7_CONTAT
			PP7->PP7_TPFRET :=M->PP7_TPFRET
			PP7->PP7_PRAZO  := M->PP7_PRAZO				// Valdemir Rabelo 07/01/2020
			PP7->PP7_STATUS := '1'
			if INCLUI
			   PP7->PP7_NOTAS  := PP7->PP7_NOTAS + CRLF + "* * * HISTÓRICO * * *"+ CRLF + "Prazo: "+dtoc(M->PP7_PRAZO)
			else
			    // Valdemir Rabelo 07/01/2020
				IF !Empty(M->PP7_PRAZO) .and. lObs
					PP7->PP7_NOTAS  := PP7->PP7_NOTAS + CRLF  + "Prazo: " + dtoc(M->PP7_PRAZO)
				Endif
			Endif
			PP7->PP7_PEDIDO := M->PP7_PEDIDO           // Valdemir Rabelo 05/01/2021 - Ticket: 20201127011359
			//Chamado 001423
			PP7->PP7_ZTIPOC := M->PP7_ZTIPOC
			PP7->PP7_ZCONSU := M->PP7_ZCONSU
			Msunlock()
			// ------ Grava ZZ5 ------ Valdemir Rabelo 08/10/2019
			If INCLUI
			    ZZ5->( dbSetOrder(1) )
				lInc := ZZ5->( !dbSeek(xFilial('ZZ5')+"UN"+PP7->PP7_CODIGO) )
				RecLock("ZZ5", lInc)
				if lInc
					ZZ5->ZZ5_FILIAL := XFILIAL("ZZ5")
					ZZ5->ZZ5_COD    := "UN"+PP7->PP7_CODIGO
				endif 
				ZZ5->ZZ5_CLIENT := PP7->PP7_CLIENT
				ZZ5->ZZ5_LOJA	:= PP7->PP7_LOJA
				ZZ5->ZZ5_NOMEOB := PP7->PP7_OBRA
				ZZ5->ZZ5_ENDERE := PP7->PP7_ENDOBR
				ZZ5->ZZ5_AREA   := PP7->PP7_REPRES
				ZZ5->ZZ5_CODORI := PP7->PP7_CODIGO
				ZZ5->ZZ5_STATUS := 'O'
				ZZ5->ZZ5_DATA	:= PP7->PP7_EMISSA
				ZZ5->ZZ5_NOMCLI := PP7->PP7_NOME
				MsUnlock()
				
				U_STEITC01(3)
				
			EndIf
			// -----------------------	
			_Grava_Acols("PP8",1,"PP8_CODIGO",M->PP7_CODIGO,aHeader1, oGetDad1:aCols )		

		Endif

	Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft001Acols³ Autor ³ RVG Solucoes          ³ Data ³13.12.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta Acols de Itens do Unicom                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := Ft001Cli()                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> Validacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft001Acols(	nOpcX	, aHeader1	, aCols1	, cNRopor	, cRevisa	, aColsProd	)

	Local aArea		:= GetArea()
	Local aAreaSA3  := SA3->(GetArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aHeader e aCols (1)                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Ft001FG(nOpcX, @aHeader1, @aCols1, PP7->PP7_CODIGO, "" )

	RestArea(aAreaSA3)
	RestArea(aArea)

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ft300VOk  ³ Autor ³ RVG Solucoes          ³ Data ³ 13.12.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao do array das revisoes para comparacão.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Revisoes da oportunidade                               ³±±
±±³          ³ExpA2: Comparacoes das revisoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 -> Retorno da validacao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGAFAT                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft300ROk(aRevisoes,aCmp)

	Local lRetorno   := .T.

	Default aCmp     := {}

	aEval(aRevisoes,{|x| If(x[1],aAdd(aCmp,{x[Len(x)-1],x[Len(x)]}),)})
	If Len(aCmp) < 2
		Aviso( "Atenção!","É necessária a escolha de 2 revisões para comparação.",{"Ok"}, 2 ) //"Atenção!"###"É necessária a escolha de 2 revisões para comparação."###"Ok"
		lRetorno := .F.
		aCmp := {}
	EndIf

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Vendas Clientes       ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef(_cIntern)

	/*
	If !_cIntern
	Private aRotina := {	{ "Gerenciar"	,"u_Ft001Alt"	,0,2,,.T.}}
	Else
	*/
		Private aRotina := {		{ "Pesquisar"	,"AxPesqui"  	,0,1,0,.F.},;
			{ "Gerenciar"	,"u_Ft001Alt"	,0,2,,.T.},;
			{ "Incluir"		,"u_Ft001Alt"	,0,3,,.T.},;
			{ "Alterar"		,"u_Ft001Alt"	,0,4,,.T.},;
			{ "Copia"		,"u_Ft001Cop"	,0,4,,.T.},;
			{ "Exclusao"	,"u_Ft001Alt"	,0,5,,.T.},;
			{ "Legenda"		,"u_Ft001Leg"		,0,2,0,.F.}}
		AAdd( aRotina, { "Conhecimento"    ,"MsDocument",0,4,0,NIL} )
		AAdd( aRotina, { "Pesquisa Estrutura"    ,"U_STPESQESTRU()",0,2,0,NIL} )
		AAdd( aRotina, { "Cancelar"    ,"U_STCANUNIC()",0,4,0,NIL} )
		AAdd( aRotina, { "Anexar Doc." ,"u_AnexaST01()",0,4,0,NIL} )
		If __cUserId $ GetMv("ST_MIXCUS",,'000000')
			AAdd( aRotina, { "Mix/Custo"    ,"U_STMIXUNI()",0,4,0,NIL} )
			AAdd( aRotina, { "Liberar"    	 ,"U_FT001LIB()",0,4,0,NIL} )
			AAdd( aRotina, { "Unicom Excel"    	 ,"U_RSTFATB4()",0,4,0,NIL} )
		EndIf
	/*
	EndIf
	*/
	AAdd( aRotina, { "Lista Avancada"    ,"U_RSTFATAN()",0,4,0,NIL} )

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ft001FG   ³ Autor ³ FLEX   			    ³ Data ³16.12.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenche o aHeader e aCols para tabela PP8.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft001FG(	nOpc, aHead, aCols, cNRopor, cRevisa)
	Local aArea := GetArea()
	Local cSeek		:= ""	//Armazena a string de busca
	Local cWhile	:= ""	//Armazena a condição de parada
	Local bCond            	//Armazena a condicao para validar os registros
	Local cQuery	:= ""   //Armazena a query para TOP

	aHeader1 :=  _CriaHeader("PP8","")//,"PP4_CODIGO")
	aCols1   := _carga_Acols("PP8",1,"PP8_CODIGO",PP7->PP7_CODIGO,aHeader1)

	RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_carga_AcolsºAutor  ³ RVG Solucoes       º Data ³  19/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                              º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _carga_Acols(_cTabela,_nidice,_cCampo,_cChave,_xAHeadLoc)
	Local _LocAcols := {}
	Local _nPosItem := Ascan(_xAHeadLoc,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	//Local _nPosItem := Ascan(_xAHeadLoc,{|x| AllTrim(x[2]) == "PP8_ITEM" })                   PP8_NUMORC
	Local nX
	Dbselectarea(_cTabela)
	Dbsetorder(1)
	dbseek(xfilial(_cTabela)+_cChave)

	if eof()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do vazio ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aAdd(_LocAcols, Array(Len(_xAHeadLoc)+1))
		For nX := 1 to Len(_xAHeadLoc)
			_LocAcols[1,nX] := CriaVar(_xAHeadLoc[nX,2])
		Next nX
		_LocAcols[1,Len(_xAHeadLoc)+1] := .f.
		_LocAcols[1,_nPosItem] := "001"

	else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do acols com dados para alteraco ou exclusao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		do while !eof()   .and. alltrim(&_cCampo) == alltrim(_cChave)
			aAdd(_LocAcols, Array(Len(_xAHeadLoc)+1))
			For nX := 1 to Len(_xAHeadLoc)

				If ALLTRIM(_xAHeadLoc[nX,2]) = 'PP8_NTORC'
					_LocAcols[len(_LocAcols),nX] :=  POSICIONE('SCJ',1,XFILIAL("SCJ")+SUBSTR(PP8->PP8_NUMORC,1,6),"SCJ->CJ_OBSORC")
				Else
					_LocAcols[len(_LocAcols),nX] := &(_xAHeadLoc[nX,2])
				EndIf
			Next nX
			_LocAcols[len(_LocAcols),Len(_xAHeadLoc)+1] := .f.
			dbskip()
		enddo
	endif

return(_LocAcols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaHeaderºAutor  ³RVG Solucoes        º Data ³  18/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _CriaHeader(_cfile,_cExecessao)

	nUsado  := 0
	_xaHeader := {}

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(_cfile)
	While ( !Eof() .And. SX3->X3_ARQUIVO == _cfile )
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )

			if ! Alltrim(X3_CAMPO) $ _cExecessao

				aAdd(_xaHeader,{ Trim(X3Titulo()), ;
					alltrim(SX3->X3_CAMPO), ;
					SX3->X3_PICTURE , ;
					SX3->X3_TAMANHO , ;
					SX3->X3_DECIMAL , ;
					SX3->X3_VALID   , ;
					SX3->X3_USADO   , ;
					SX3->X3_TIPO    , ;
					SX3->X3_F3,;
					SX3->X3_CONTEXT ,;
					SX3->X3_CBOX,;
					SX3->X3_RELACAO } )

				nUsado++
			Endif

		Endif

		DbSkip()
	End

Return(_xaHeader)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ft300Leg  ³Autor  ³ Flex Projects         ³ Data ³13.12.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Demonstra a legenda das cores da mbrowse                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina monta uma dialog com a descricao das cores da    ³±±
±±³          ³Mbrowse.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STFTA001                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Ft001Leg()
	Local aCores    := {{"ENABLE"		,"Em Aberto"					},;
		{"BR_PRETO"		,"Des.Liberados Prod.TOTAL"		},;
		{"BR_BRANCO"  	,"Des.Liberados Prod.PARCIAL"	},;
		{"BR_AMARELO"	,"Sol.Desenho sem PV"			},;
		{"BR_AZUL"		,"Sol.Desenho com PV"			},;
		{"BR_LARANJA"	,"Enviado ao Orcamento"			},;
		{"BR_MARROM"	,"Orçamento Cancelado"			},;
		{"BR_PINK"  	,"Aguardando Prc.Final"			},;
		{"DISABLE"		,"Orçamento Finalizado"			}}

	BrwLegenda(cCadastro,"Status de Processo",aCores)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ft001adl ºAutor  ³ RVG Solucoes       º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ft001adl()
	Local _cItem 	:= "000"
	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local a

	for a:=1 to len(acols)

		If empty(acols[a,_nPosItem])
			_cItem := soma1(_cItem)
			acols[a,_nPosItem] := _cItem
		Else
			_cItem := acols[a,_nPosItem]
		Endif
	next a

	oGetDad1:refresh()

Return

	'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPCP001  ºAutor  ³RVG Solucoes        º Data ³  27/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _Grava_Acols(_cTabela,_nOrdem,_cCampo,_cChave,_aHeader, _aCols )

	Local _nCol
	Local _nlin

	Dbselectarea(_cTabela)
	Dbsetorder(_nOrdem)
	dbseek(xfilial(_cTabela)+_cChave)

	For _nlin=1 to len(_aCols)
		if !_aCols[_nlin,len(_aCols[_nlin])]

			if &_cCampo == _cChave
				reclock(_cTabela,.f.)
				PP8->PP8_HIST := PP8->PP8_HIST +  "ITEM ALTERADO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
			else
				reclock(_cTabela,.t.)
				&(_cTabela+"_FILIAL") := XFILIAL(_cTabela)

				PP8_HIST := "ITEM INCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10) + REPLICATE("-",80) + chr(13) + chr(10)

			endif

			For _nCol := 1 to Len(_aHeader)
				&(_aHeader[_nCol,2]) := _Acols[_nlin,_nCol]
			Next _nCol
			&_cCampo := _cChave

			Msunlock()
			Dbskip()
		Else
			Dbselectarea(_cTabela)
			Dbsetorder(_nOrdem)
			If	dbseek(xfilial(_cTabela)+_cChave+alltrim(_Acols[_nlin,2]))
				reclock(_cTabela,.f.)

				PP8_HIST := "ITEM excluido EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10) + REPLICATE("-",80) + chr(13) + chr(10)
				DbDelete()
				Msunlock()
				Dbskip()
			Endif
		Endif
	Next _nLin
	/*
	Do While &_cCampo == _cChave .and. !eof()
	reclock(_cTabela,.t.)
	DbDelete()
	msunlock()
	Dbskip()
	Enddo
	*/
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraOrc
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= "Liberacao Unicom para Orcamento"
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin

	Local _cEmail  := getmv("ST_UNCORCA")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Gerar Orcamentos "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local __ncount
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	SA1->(dbsetorder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF EMPTY(PP8->PP8_NUMORC)

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()
	Enddo

	if len(aitens) == 0

		Msgstop("Todos os itens ja foram para Orcamento!")

	else

		DEFINE MSDIALOG oDlg1 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1, {||nOpcA := 1 ,oDlg1:End()} ,{||oDlg1:End()},, )

		If  nOpcA == 1

			_aorcs := {}
			_cOrcs := ""

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					IN_PEDIDO := GetSX8Num("SCJ","CJ_NUM")
					ConfirmSX8()

					_cOrcs += IN_PEDIDO + chr(13)+ chr(10)
					aadd(_aorcs,{IN_PEDIDO,PP8->PP8_DESCR})
					RecLock("SCJ",.T.)

					SCJ->CJ_FILIAL  := xFilial("SCJ")
					SCJ->CJ_NUM     := IN_PEDIDO
					SCJ->CJ_EMISSAO := dDataBase
					SCJ->CJ_XDSCUNC  := PP8->PP8_DESCR
					SCJ->CJ_CLIENTE := PP7->PP7_CLIENTE
					SCJ->CJ_LOJA    := PP7->PP7_LOJA
					SCJ->CJ_CLIENT  := PP7->PP7_CLIENTE
					SCJ->CJ_LOJAENT := PP7->PP7_LOJA
					SCJ->CJ_STATUS  := "A"
					SCJ->CJ_VALIDA  := dDataBase+30
					SCJ->CJ_CONDPAG := IF(!EMPTY(SA1->A1_COND),SA1->A1_COND,'001')
					SCJ->CJ_TIPLIB  := "2"
					SCJ->CJ_XNOTA   := PP7->PP7_NOTAS
					SCJ->CJ_XUNICOM := PP8->(PP8_CODIGO+PP8_ITEM)
					SCJ->CJ_XOBRA 	:= PP7->PP7_OBRA
					SCJ->CJ_XENDOBR := PP7->PP7_ENDOBR
					SCJ->CJ_XCONTAT:= PP7->PP7_CONTAT
					SCJ->CJ_TXMOEDA := 1
					SCJ->CJ_TABELA  := '001'
					SCJ->CJ_XVEND   := PP7->PP7_VEND

					MsUnlock()

					dbselectarea("SCK")
					RecLock("SCK",.T.)
					SCK->CK_FILIAL  := SCJ->CJ_FILIAL
					SCK->CK_NUM     := IN_PEDIDO
					SCK->CK_ITEM    := "01"
					SCK->CK_PRODUTO := "UNICOM"
					SCK->CK_DESCRI  := PP8->PP8_DESCR
					SCK->CK_QTDVEN  := 1
					SCK->CK_PRCVEN  := 1
					SCK->CK_VALOR   := PP8->PP8_QUANT
					SCK->CK_LOCAL   := "01"
					SCK->CK_UM      := "PC"
					SCK->CK_CLIENTE := PP7->PP7_CLIENTE
					SCK->CK_LOJA    := PP7->PP7_LOJA
					SCK->CK_DESCONT := 0
					SCK->CK_VALDESC := 0
					SCK->CK_PRUNIT  := 1
					SCK->CK_FILVEN  := SCJ->CJ_FILIAL
					SCK->CK_FILENT  := SCJ->CJ_FILIAL
					SCK->CK_TES     := "501"

					MsUnlock()

					Dbselectarea("PP8")
					RecLock("PP8",.F.)
					PP8->PP8_NUMORC := IN_PEDIDO
					PP8->PP8_HIST 	:= PP8->PP8_HIST + "ORCAMENTO " + IN_PEDIDO +" GERADO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10) + REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS := 'V'

					MsUnlock()

					Dbselectarea("PP7")
					RECLOCK("PP7",.F.)
					PP7->PP7_STATUS:="6"
					MsUnlock()

				Endif

			Next __nCount

			if !empty(_cOrcs)

				Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO+ '-'+ PP8->PP8_ITEM } )
				Aadd( _aMsg , { "Ocorrencia: "    	, "Liberacao para Orcamento"  } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				cMsg += '<tr>'
				cMsg += '</tr>'
				For _nLin := 1 to Len(_aOrcs)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aorcs[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aorcs[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

				MsgStop("Foram gerados os orcamentos"  + chr(13)+ chr(10)+ chr(13)+ chr(10)+_cOrcs)

			Endif

		Endif

	Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerHist()
	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	@ 000, 000 TO 430, 550 DIALOG oDlgX1 TITLE 'Historico de Unicom'
	@ 005,005 Get PP8->PP8_HIST  Size 267,180 MEMO Object oMemo   //WHEN .F.
	@ 192,235 BMPBUTTON TYPE 1 ACTION Close(oDlgX1)

	ACTIVATE DIALOG oDlgX1 CENTERED

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraCst()
	Local   _cArea 		:=  GetArea()
	Local	oAlert		:=	LoadBitmap( GetResources(), "BR_AMARELO" )
	Local	oErro		:=	LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local	oOk			:=	LoadBitmap( GetResources(), "BR_VERDE")
	Local	oVlrer		:=	LoadBitmap( GetResources(), "BR_AZUL")
	Local   _cTipoDoc   := '1'

	Local oCheck		:= LoadBitmap( GetResources(), "CHECKED_15" )   //CHECKED    //LBOK  //LBTIK
	Local oUncheck		:= LoadBitmap( GetResources(), "CANCEL_15" ) //UNCHECKED  //LBNO

	Private _aitens 		:= {}
	Private _aitens2		:= {}
	Private _xMargem
	Private oDlg2
	Private _nStNet  :=0
	Private _nStCust :=0
	Private _nStMark :=0
	Private _nStMarg :=0
	Private _cTexto2 := ''
	Private _cTexto3 := ''
	Private _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Private _nPosDesc := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_DESCR" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))
	/*
	IF PP8->PP8_STATUS == 'V'
	MsgStop('Item ainda nao Orcado !!!')
	Return
	ENDIF
	*/
	_cTipo :="Orcado"
	//_Faz_custo(_cTipo,.f.)
	Processa({||_Faz_custo(_cTipo,.f.),"Recalculando... "})
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlgx2 FROM 000,000  TO 600,1290 TITLE OemToAnsi("Verificacao de Custo") Of oMainWnd PIXEL

	aCbx   		:= 	{"Orcado","Medio","Steck","Ult.Compra"}
	_atit_cab1	:= 	{" ","Produto","Descricao","Quantidade", "Pr. Venda Final","Pr Final Total","Preco Base","Total Base","Custo","Markup"}

	@ 001,002 SAY oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]+"-"+oGetDad1:ACOLS[oGetDad1:nat,_nPosDesc] of oDlgx2 PIXEL COLOR CLR_HBLUE
	oListBox2 := TWBrowse():New( 32,2,650,150                              ,,_atit_cab1, ,oDlgx2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(substr(_aItens[ oListBox2:nAt, 09 ],1,1) $ 'S ',oOk,iif(substr(_aItens[ oListBox2:nAt, 09 ],1,1) == 'X',oAlert,oErro))  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
	oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif( _aItens[ oListBox2:nAt, 05 ] > 0 ,oCheck,oUnCheck )}, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
	oListBox2:AddColumn(TCColumn():New( "Produto"  			,{|| _aItens[ oListBox2:nAt, 01 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| _aItens[ oListBox2:nAt, 02 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Quantidade"  		,{|| _aItens[ oListBox2:nAt, 03 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Pr. Venda Final" 	,{|| _aItens[ oListBox2:nAt, 04 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Pr Final Total"	,{|| _aItens[ oListBox2:nAt, 05 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Preco Base"  		,{|| _aItens[ oListBox2:nAt, 06 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Total Base" 		,{|| _aItens[ oListBox2:nAt, 07 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Custo" 			,{|| _aItens[ oListBox2:nAt, 10 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Prc.Net" 			,{|| _aItens[ oListBox2:nAt, 11]  },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Markup" 			,{|| _aItens[ oListBox2:nAt, 12]  },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))

	oListBox2:SetArray(_aitens)
	oListBox2:bLine := {|| {iif(substr(_aItens[ oListBox2:nAt, 09 ],1,1) $ 'S ',oOk,iif(substr(_aItens[ oListBox2:nAt, 09 ],1,1) == 'X',oAlert,oErro))  ,;
		iif( _aItens[ oListBox2:nAt, 05 ]> 0  ,oCheck,oUnCheck ) ,;
		_aItens[ oListBox2:nAT, 01 ], _aItens[ oListBox2:nAT, 02 ], _aItens[ oListBox2:nAT, 03 ],;
		_aItens[ oListBox2:nAT, 04 ], _aItens[ oListBox2:nAT, 05 ],;  // preco venda
	_aItens[ oListBox2:nAT, 06 ], _aItens[ oListBox2:nAT, 07 ],_aItens[ oListBox2:nAT, 10 ]  ,_aItens[ oListBox2:nAT, 11 ] ,_aItens[ oListBox2:nAT, 12 ]  } }  // custo

	oListBox2:blDblClick := {|| Alin_Vlr(oListBox2:nAT),oListBox2:refresh() }

	oListBox3 := TWBrowse():New( 185,2,290,70                              ,,_atit_cab1, ,oDlgx2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	oListBox3:AddColumn(TCColumn():New( "Grupo"  			,{|| _aItens2[ oListBox3:nAt, 01 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox3:AddColumn(TCColumn():New( "Descricao"  		,{|| _aItens2[ oListBox3:nAt, 02 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox3:AddColumn(TCColumn():New( "Valor "  			,{|| _aItens2[ oListBox3:nAt, 03 ] },"@E 999,999.9999",,,'RIGHT',,.F.,.F.,,,,.F.,))

	oListBox3:SetArray(_aitens2)
	oListBox3:bLine := {|| {	_aItens2[ oListBox3:nAT, 01 ], _aItens2[ oListBox3:nAT, 02 ], _aItens2[ oListBox3:nAT, 03 ] } }

	_cTexto1 := "Terceiros(%) " + transform(SCJ->CJ_XPRCTER , "@e 999.99" )
	_cTexto2 := "Markup (%)   " + transform(_nStMark , "@e 999.99" )
	_cTexto3 := "Margem Geral " + transform(_nStMarg        , "@e 999.99" )

	@ 0.5,6 Say oPromptt1 VAR _cTexto1  of Odlgx2
	@ 1.1,6 Say oPromptm1 VAR _cTexto3  of Odlgx2
	@ 1.7,6 Say oPromptg1 VAR _cTexto2  of Odlgx2  COLOR CLR_HRED

	@ 008,180   BUTTON OemToAnsi("OK")             	    SIZE 045,015  FONT oDlgx2:oFont ACTION SairUnic()       	OF oDlgx2 PIXEL
	@ 008,230   BUTTON OemToAnsi("Orcamento")       	SIZE 045,015  FONT oDlgx2:oFont ACTION OrcUnic()		   	OF oDlgx2 PIXEL
	@ 008,280   BUTTON OemToAnsi("Reajuste")     		  	SIZE 045,015  FONT oDlgx2:oFont ACTION MkpUnic()        	OF oDlgx2 PIXEL
	@ 008,330   BUTTON OemToAnsi("Margens")    			SIZE 045,015  FONT oDlgx2:oFont ACTION SupUnic()  			OF oDlgx2 PIXEL
	@ 008,380   BUTTON OemToAnsi("Legenda")    			SIZE 045,015  FONT oDlgx2:oFont ACTION SupLegen()  			OF oDlgx2 PIXEL
	@ 008,430   BUTTON OemToAnsi("Valor Inf.")    			SIZE 045,015  FONT oDlgx2:oFont ACTION vlrinfo()  			OF oDlgx2 PIXEL

	ACTIVATE MSDIALOG oDlgx2 CENTERED

	RestArea(_cArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OrcClie()

	Local aArea 	:= GetArea()
	Local _nLin

	Local _cEmail  := getmv("ST_UNCORCA")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Imprimir Orcamentos "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local _cItens   := ' '
	Local __ncount
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	If Empty(Alltrim(PP7->PP7_TRAVA))
		MsgInfo("Orçamento aguardando Valores!!!!!")
		Return()
	EndIf
	SA1->(dbsetorder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF !EMPTY(PP8->PP8_NUMORC)  .And. !EMPTY(PP8->PP8_USORC)

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()
	Enddo

	if len(aitens) == 0

		Msgstop("nao existem itens em Orcamento!")

	else

		DEFINE MSDIALOG oDlg1 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos " // Chamado 007002 - Everson Santana - Ajustar Posicionamento do Botão na Tela
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos " // Chamado 007002 - Everson Santana - Ajustar Posicionamento do Botão na Tela

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1, {||nOpcA := 1 ,oDlg1:End()} ,{||oDlg1:End()},, )

		If  nOpcA == 1

			_aorcs := {}
			_cOrcs := ""

			_lPreco := .f.

			if msgyesno("Imprime preços ? (S/N)" )
				_lPreco := .t.
			endif

			//	oPrint:= TMSPrinter():New( "Orcamento" )
			//	oPrint:SetPortrait() // ou SetLandscape()

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))
					_cItens  :=_cItens+'/'+PP8->PP8_item
					//	PrtClie(PP7->PP7_CODIGO + aitens[__ncount ,2])

				Endif

			Next __ncount
			If 	!Empty(Alltrim(_cItens))

				DbSelectArea("SU5")
				SU5->(DbSetOrder(1))
				SU5->(DbGoTop())
				SU5->(DbSeek(xFilial("SU5")+PP7->PP7_CODCON))

				u_ORCUNICON(_cItens,_lPreco)

			Endif
			//oPrint:Preview()     // Visualiza antes de imprimir

		Endif

	Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  04/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrtClie(_cOrcamento)

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+_cOrcamento )) //PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	//IF PP8->PP8_STATUS  ==  "O"

	_nTotGeral := SCJ->CJ_XVLRMOD

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	Dbselectarea("SCJ")
	MsSeek(Xfilial("SCJ") + PP8->PP8_NUMORC  )

	if eof()

		msgstop("Orcamento Nao Encontrado !!!  Verifique !!! " )

	else

		dbselectarea("SA1")
		MsSeek(Xfilial("SA1")  + scj->cj_cliente + scj->cj_loja )

		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + scj->cj_Condpag )

		Dbselectarea("SCJ")

		u_fr001Imp()

	ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OrcInte()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	_nTotGeral := SCJ->CJ_XVLRMOD

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	u_STFTR002()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³FlexPrjects         º Data ³  02/12/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AprClie()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Gerar Solicitacao de Desenvolvimento "
	Local cQuery    := ""
	Local cTrab     := "PP8"
	Local aRegis    := {}
	Local aWFDes    := {}

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local cEmailDes := SuperGetMV("ST_WFDTDES",.f.,"gustavo.joaquim@steck.com.br,francis.lima@steck.com.br")	// Valdemir Rabelo 06/12/2019
	Local __ncount
	Local _nLin
	Local cTMP	   := ""
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens  := {}
	PRIVATE aPrior  := {"0=Extrema Urgência","1=Urgênte","2=Pouco Urgente","3=Normal","4=Média","5=Baixa"," "}
	Private nPrior  := 0


	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		//	IF EMPTY(PP8->PP8_DAPCLI) .AND. PP8->PP8_STATUS  ==  "O" 013360
		IF  PP8->PP8_STATUS  ==  "O"
			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()

	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem itens a serem liberados para SD!")

	else
		lOK    := .F.
		nPrior := 0
		// Informar a prioridade - Valdemir Rabelo 25/03/2020
		While (!lOK)
			lOK := getPrior(@nPrior)
			if !lOK
				FWMsgRun(,{|| Sleep(3000)}, "Atenção!", "A Prioridade precisa ser selecionada.")
			Endif
		EndDo

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  	//aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		If  nOpcA == 1

			_aSds := {}

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					RecLock("PP8",.F.)
					PP8->PP8_HIST  	 := PP8->PP8_HIST +  iif(!empty(PP8->PP8_PROD), "SD REABERTA EM: "  ,  "SD GERADA EM: " ) + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS  := "E"
					PP8->PP8_DAPCLI  := DDATABASE
					PP8->PP8_UAPCLI  := CUSERNAME
					PP8->PP8_DTRCSD  := CTOD('  /  /    ')
					PP8->PP8_PRIOR	 := cValToChar(nPrior)
					MSUNLOCK()

					Dbselectarea("PP7")
					RECLOCK("PP7",.F.)
					PP7->PP7_STATUS:="3"
					MsUnlock()

					aadd(_aSds,{PP8->pp8_item,PP8->pp8_descr+"/"+ PP8->PP8_PROD })//Ticket 20190830000015

					// Prepara Array para WF - Valdemir Rabelo 05/12/2019
					if !Empty(PP8->PP8_DAPCLI) .and. Empty(PP8->PP8_DTPRES)      // PP8_PEDVEN terá que ser regra sempre ter pedido, para funcionar este processo.
						if aScan(aWFDes, {|X| X[1]=="Atendimento: "})==0
							Aadd( aRegis , { "Atendimento: "     , PP7->PP7_CODIGO  } )
						Endif
						Aadd( aRegis, {"Item: ",    PP8->PP8_ITEM }  )
						Aadd( aRegis, {"Data Liberação",   dtoc(PP8->PP8_DAPCLI) }  )
						Aadd( aRegis, { "Pedido"       , PP8->PP8_PEDVEN} )				// Chamado 20200527002503 - Valdemir Rabelo 07/08/2020

						//Aadd( aRegis, {"Descrição", PP8->PP8_DESCR}  )            // Conforme contato telefonico, Filipe informou que neste momento não tem o código do produto
						//Aadd( aRegis, {"Desenho",   PP8->PP8_DESENH} )			// precisam apenas que seja informado o código Unicom e a sequencia.
					Endif

				Endif

			Next __nCount
			// Verifico se envio o WF a fabrica - Valdemir Rabelo 05/12/2019
			IF LEN(aRegis) > 0
				Aadd( aRegis , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( aRegis , { "Hora: "    		, time() } )
				Aadd( aRegis , { "Usuario: "   		, Alltrim(cUserName) } )
				Aadd( aRegis , { "Prioridade: "     , aPrior[nPrior+1] } )				// Valdemir Rabelo 25/03/2020

				aAdd( aWFDes, aRegis)
				aRegis := {}
				// Valdemir Rabelo 29/01/2020
				if !Empty(PP7->PP7_VEND)
					cTMP := Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND, "A3_EMAIL")
					if !Empty(cTMP)
						cEmailDes += ","+cTMP
					Endif
				Endif
				EnviaWF(aWFDes, cEmailDes, "AVISO - REGISTROS PENDENTES ( DATA ENTREGA DESENHO )")
				aWFDes := nil
			Endif


			/*
			Dbselectarea("PP8")
			PP8->(dbsetorder(1))
			PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO ))
			Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
			RecLock("PP8",.F.)
			PP8->PP8_STATUS  := "E"

			MSUNLOCK()
			Dbskip()
			Enddo

			*/
			_cEmail    := getmv("ST_UNCENGE")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
			_cAssunto  := "Liberacao para Desenvolvimento - Engenharia"
			if len(_aSds) > 0

				_aMsg := {}

				Aadd( _aMsg , { "Atendimento: "          , PP8->PP8_CODIGO } )
				Aadd( _aMsg , { "Ocorrencia: "    	, "Liberacao para Desenvolvimento - Engenharia"  } )
				Aadd( _aMsg , { "Cliente: "          , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )
				Aadd( _aMsg , { "Dt.Necessidade: "    		, IIF(EMPTY(ALLTRIM(PP8->PP8_DTNEC)),dtoc(PP7->PP7_DTNEC),dtoc(PP8->PP8_DTNEC)) } )
				//Aadd( _aMsg , { "Item: "+ PP8->PP8_ITEM ,"Desenho: "+PP8->PP8_DESENH+"/"+ PP8->PP8_PROD } ) //Ticket 20190830000015
				Aadd( _aMsg , { "Base: "          , Iif(PP8->PP8_BASE='1','SIM','NÃO')   } )
				Aadd( _aMsg , { "Prioridade: "    , aPrior[nPrior+1] } )				// Valdemir Rabelo 25/03/2020
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				cMsg += '<tr>'
				cMsg += '</tr>'
				For _nLin := 1 to Len(_aSds)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' +'ITEM:'+ _aSds[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")
				
				If Empty(Alltrim(PP7->PP7_TRAVA))
					MsgInfo("Orçamento aguardando Valores!!!!!")
				Else
					//GeraPV2()
				EndIf

				MsgStop("Liberacao para SD efetuada com sucesso")//"Foi criado o produto " + _cCodProd + ", e tambem a SD referente a ele !")

			Endif

		Endif

	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³FlexPrjects         º Data ³  02/12/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraPv()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Gerar Pedidos de Vendas "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local _nVal:= 0
	Local	_nTot:= 0
	lOCAL aitens :={}
	Local _nBaix  := 0
	Local __ncount
	Local _cVend	:= ""
	Local oObjEtq   := Nil
	Private lMsErroAuto := .F.

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}
	PRIVATE oPrinter

	If PP7->PP7_ZBLOQ=="1"
		MsgAlert("Atenção, este orçamento está bloqueado e não pode gerar pedido!")
		Return
	EndIf

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		//if PP8_STATUS $ 'E,O,P,Z' // ajuste solicitado por filipe 29/10/19 giovani zago
		If	PP8->PP8_STATUS  = "E"
			aadd(aitens,{" ",pp8_item,pP8_prod,pp8_descr,pp8_dtnec})
		Endif
		Dbskip()
	Enddo
	If Empty(Alltrim(PP7->PP7_TRAVA))
		MsgInfo("Orçamento aguardando Valores!!!!!")
		Return()
	EndIf

	If Empty(Alltrim(PP7->PP7_TPFRET))
		MsgInfo("Por favor preencha o tipo de Frete!!!!!")
		Return()
	EndIf

	If Empty(Alltrim(PP7->PP7_DTPROG))
		MsgInfo("Esta Unicom possui programação?")
	EndIf

	if len(aitens) == 0

		Msgstop("Nao Exitem pedidos de venda a serem gerados !")

	else

		MsgInfo("ANTES DE VIRAR PEDIDO , VERIFICAR COM O FINANCEIRO O CRÉDITO DO CLIENTE, OU AGUARDAR O FINANCEIRO LIBERAR O PEDIDO PARA GERAR O PROCESSO DE DESENHO(GED), JUNTO A ENGENHARIA")

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50
		nGd4 	:= aSize[4]

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Produto "  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 05 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04] , aItens[ oListBox2:nAT, 05]   }   }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		If  nOpcA == 1

			aItenspv := {}

			SA1->(dbsetorder(1))
			SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))

			If PP7->PP7_REPRES <> SA1->A1_VEND
				_cVend := SA1->A1_VEND
			Else
				_cVend := PP7->PP7_REPRES
			EndIf

			aCab := {	{"C5_TIPO"		,"N"				,Nil},;
				{"C5_EMISSAO"	,ddatabase						,Nil},;
				{"C5_CLIENTE"	,alltrim(SA1->A1_COD)			,Nil},;
				{"C5_LOJACLI"	,alltrim(SA1->A1_LOJA)			,Nil},;
				{"C5_LOJAENT"	,alltrim(SA1->A1_LOJA)			,Nil},;
				{"C5_CONDPAG"	,PP7->PP7_CPAG					,Nil},;
				{"C5_ZCONDPG"	,PP7->PP7_CPAG					,Nil},;
				{"C5_TPFRETE"	,PP7->PP7_TPFRET				,Nil},;
				{"C5_XTIPF"		,"2" 							,Nil},;
				{"C5_XTIPO"		,"1" 							,Nil},;
				{"C5_TRANSP"	,"" 							,Nil},; //Chamado 009048 - Everson Santana - 08.02.2019
			{"C5_ZCODCON"	,PP7->PP7_CODCON				,Nil},;
				{"C5_XUNICON"	,PP7->PP7_CODIGO				,Nil},;
				{"C5_VEND1"		,_cVend							,Nil},;
				{"C5_VEND2"		,Iif(PP7->PP7_VEND == PP7->PP7_REPRES,"",PP7->PP7_VEND)					,Nil},; //Ticket 20190522000009
			{"C5_ZCONSUM"	,PP7->PP7_ZCONSU				,Nil},;//Ticket 20190508000008 - Everson Santana - 09.05.2019
			{"C5_ZDESCNT"	,PP7->PP7_CONTAT				,Nil}}

			_nItens := 0

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'
					_nItens++
					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					IF EMPTY(PP8->PP8_PROD)
						_CHk_Sunicom()
					Endif

					cTesPad  :=	 U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD),PP7->PP7_CPAG  ,'TES')//"501"//u_StOper01()

					_nVal:= STLiq(PP8->PP8_PRORC*PP8->PP8_QUANT,IF(EMPTY(ALLTRIM(PP8->PP8_PROD)),'SUNICOM',PP8->PP8_PROD),PP8->PP8_QUANT,if(empty(cTesPad),"501",cTesPad))
					_nTot+=_nVal
					AADD(aItenspv, {	{"C6_ITEM"		,strzero(_nItens,TamSX3("C6_ITEM")[1])		,Nil},;
						{"C6_PRODUTO"	,IF(EMPTY(ALLTRIM(PP8->PP8_PROD)),'SUNICOM',PP8->PP8_PROD)	,Nil},;
						{"C6_OPER"		,"01"														,Nil},;
						{"C6_DESCRI"	,PP8->PP8_DESCR												,Nil},;
						{"C6_QTDVEN"	,PP8->PP8_QUANT												,Nil},;
						{"C6_PRCVEN"	,PP8->PP8_PRORC												,Nil},;
						{"C6_VALOR"		,PP8->PP8_QUANT*PP8->PP8_PRORC								,Nil},;
						{"C6_ENTRE1"	,PP7->PP7_DTNEC												,Nil},;
						{"C6_PRUNIT"	,PP8->PP8_PRORC	 											,Nil},;
						{"C6_ZVALLIQ"	, 	_nVal 													,Nil},; //Chamado 001311   tava cagado aqui giovani zago 14/05/2018
					{"C6_TES"		,if(empty(cTesPad),"501",cTesPad)							,Nil},;
						{"C6_XNUMUNI"	,PP8->PP8_CODIGO											,Nil},;
						{"C6_XITEUNI"	,PP8->PP8_ITEM												,Nil}} )

				Endif

			Next __ncount
			lMsErroAuto:= .f.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItenspv,3)

			If lMsErroAuto

				MostraErro()
				lMsErroAuto := .F.
				DisarmTransaction()
				RollBackSX8()

			Else

				ConfirmSX8()

				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_VEND1  := PP7->PP7_REPRES
				MSUNLOCK()

				_cVend := ""
				MsgStop("Pedido de venda " + SC5->C5_NUM +" Gerado !!!"  )

				u_xSTFISS(SC5->(Recno()))
				STAJULIQ()

				//>> Chamado 008606 - Everson Santana - 08.01.2019
				U_YPVSTANEX(.t.)
				//<<
				nSel   := _nItens
				_nItens:= 0
				_nTot:=0
				For __ncount := 1 to len(aitens)

					if aItens[__ncount , 01 ] = 'X'
						_nItens++
						_nBaix++

						_aAreaPP8	:= PP8->(GetArea())
						_aAreaSC6	:= SC6->(GetArea())

						PP8->(DbSetOrder(1))
						If PP8->(DbSeek(xFilial("PP8")+PP7->PP7_CODIGO+aitens[__ncount][2]))

							DbSelectArea("SC6")
							SC6->(DbOrderNickName("C6UNICITEM"))
							SC6->(DbGoTop())
							If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+PP7->PP7_CODIGO+aitens[__ncount][2]))
								RecLock("PP8",.F.)
								PP8->PP8_HIST := PP8->PP8_HIST +  "PEDIDO DE VENDA: " + SC5->C5_NUM + " GERADO EM:" + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
								PP8->PP8_STATUS := 'F'
								PP8->PP8_PEDVEN :=  SC6->(C6_NUM+C6_ITEM)
								PP8->(MsUnlock())
								PP8->(DbCommit())
							EndIf

							// Valdemir Rabelo 22/04/2021
							oObjEtq := u_DadosSD(aitens[__ncount],,nSel,_nItens, oObjEtq)
                            
						EndIf

						RestArea(_aAreaSC6)
						RestArea(_aAreaPP8)

					EndIf

				Next __ncount

			EndIf

			/*
			Dbselectarea("PP7")
			RECLOCK("PP7",.F.)
			PP7->PP7_STATUS :="3"
			PP7->PP7_PEDIDO :=SC6->C6_NUM
			MsUnlock()
			*/
			_nBaix:=0
			Dbselectarea("PP8")
			Dbsetorder(1)
			dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
			Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
				If !Empty(alltrim(PP8->PP8_PEDVEN ))
					_nBaix++
				EndIf
				Dbskip()
			Enddo

			If _nBaix = len(aitens)
				RecLock("PP7",.F.)
				PP7->PP7_STATUS  := "2"
				MSUNLOCK()
			ElseIf _nBaix >= 1 .and. _nBaix < len(aitens)
				RecLock("PP7",.F.)
				PP7->PP7_STATUS  := "8"
				MSUNLOCK()
			Endif

		Endif

	Endif



Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xApvDese()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	IF PP8_STATUS  <> 'Z'

		MsgStop("SD ainda nao concluida !!!  Desenho nao pode ser aprovado !!!"  )

	ELSE

		IF MsgYesNo("Confirma a aprovacao do Desenho (S/N)")

			RecLock("PP8",.F.)
			PP8->PP8_HIST := PP8->PP8_HIST +  "DESENHO("+PP8->PP8_NUNSEQ+") APROVADO EM:" + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
			PP8->PP8_STATUS := 'P'
			PP8->PP8_DTSDAP	:= DATE() //chamado 001777
			PP8->PP8_HRSDAP	:= TIME() //chamado 001777
			MsUnLock()

			GeraSeq()

		Endif
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVlGrup

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_GRUPO" })
	Local _nPosProd := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_PROD" })
	Local a
	_cGrupo := &(Readvar())

	//If !empty(acols[1,_nPosItem])

	for a:=2 to len(acols)

		If empty(acols[a,_nPosItem])
			acols[a,_nPosItem] := _cGrupo//acols[1,_nPosItem]
		Endif

		If empty(acols[a,_nPosProd])

			Dbselectarea("SB1")
			DbsetOrder(1)
			Dbseek(xfilial("SB1")+acols[a,_nPosProd])

			if !eof()
				Reclock("SB1",.F.)
				B1_GRUPO := acols[a,_nPosItem]
				MsUnlock()
			Endif

		Endif

	next a

	//Endif

Return .t.

	*------------------------------------------------------------------*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StEmail   ºAutor  ³Microsiga           º Data ³  26/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia Email de SD                                          º±±
±±º          ³ baseado na funcao e-mail Criado por Giovanni Zago          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  StEmail(_cTitulo,_cEmail,_cTipo,cAnexo)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= _cTitulo
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin

	DEFAULT _cEmail  := "gallo@rvgsolucoes.com.br"

	Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO+ '-'+ PP8->PP8_ITEM } )
	Aadd( _aMsg , { "Ocorrencia: "    	, _cTipo  } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

	RestArea(aArea)
Return()

/*/
	antiga rotina de geracao de produto e pre_estrutura

	Dbselectarea('SCJ')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	Dbselectarea('SCK')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
	_cCaixa := ""
	Do while !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM

		Dbselectarea("SB1")
		Dbseek(xfilial("SB1")+SCK->CK_PRODUTO)

		AADD( aitens , {SCK->CK_PRODUTO,SCK->CK_DESCRI,SCK->CK_QTDVEN,SCK->CK_PRCVEN,SCK->CK_VALOR})

		IF alltrim(SB1->B1_GRUPO) $ getmv('ST_GRPCAIX')  .AND. EMPTY(_cCaixa)
			_cCaixa := SCK->CK_PRODUTO
		Endif

		Dbselectarea('SCK')
		Dbskip()

	Enddo

	if empty(_cCaixa)

		MsgStop("Nao foi encontrada caixa nesta Unicom")
		return

	endif

	_cArqTRB := 'SGSX'
	_cQuery := "SELECT MAX(B1_COD) ULTIMO FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ = '' AND B1_FILIAL = '"+XFilial("SB1")+"' "
	_cQuery += "AND B1_COD LIKE '%"+SUBSTR(_cCaixa,1,6)+"%' "
	_cQuery := ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqTRB,.t.,.t.)

	dbSelectArea(_cArqTRB)

	_cCodProd := SUBSTR(_cCaixa,1,6)+ IIF(Empty((_cArqTRB)->ULTIMO),"0001",SOMA1(SUBSTR((_cArqTRB)->ULTIMO,7,4)) )

	(_cArqTRB)->(dbCloseArea())

	Dbselectarea("SB1")

	If !DbSeek(xFilial("SB1")+_cCodProd)

		RecLock("SB1",.t.)

		SB1->B1_FILIAL := XFILIAL("SB1")
		SB1->B1_COD		:= 	_cCodProd
		SB1->B1_DESC 	:= PP8->PP8_DESCR
		SB1->B1_TIPO 	:= "PA"
		SB1->B1_UM		:= "PC"
		SB1->B1_LOCPAD 	:= "01"
		SB1->B1_GRUPO 	:= "999"
		SB1->B1_TIPCONV := "M"
		SB1->B1_PRV1 	:= iif(PP8->PP8_PRCOM>0,PP8->PP8_PRCOM,PP8->PP8_PRORC)
		SB1->B1_MCUSTD 	:= "1"
		SB1->B1_APROPRI := "D"
		SB1->B1_TIPODEC := "N"
		SB1->B1_RASTRO 	:= "N"
		SB1->B1_UREV 	:= dDataBase
		SB1->B1_DATREF  := dDataBase
		SB1->B1_DTREFP1 := dDataBase
		SB1->B1_CODBAR 	:= _cCodProd
		SB1->B1_ATIVO 	:= "S"
		SB1->B1_PIS 	:= "2"
		SB1->B1_COFINS 	:= "2"
		SB1->B1_CSLL 	:= "2"
		SB1->B1_MSBLQL 	:= "2"

		MsUnLock()
		DbSelectArea("SGG")
		DbSeek(xFilial("SGG")+_cCodProd)
		If Eof()
			For _nCount := 1 to len(aitens)
				RecLock("SGG",.T.)
				Replace GG_FILIAL  With xFilial("SG1")
				Replace GG_COD     With _cCodProd
				Replace GG_COMP    With aitens[_ncount,1]
				Replace GG_TRT     With strzero(_ncount,3)
				Replace GG_QUANT   With aitens[_ncount,3]
				Replace GG_PERDA   With 0
				Replace GG_OBSERV  With "REF UNICOM " + SCJ->CJ_XUNICOM
				Replace GG_FIXVAR  With "V"
				Replace GG_GROPC   With ""
				Replace GG_OPC     With ""
				Replace GG_STATUS  With "1"

				DbUnLock()
			Next _nCount
		Endif
	Endif
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_mAll     ºAutor  ³ RVG Solcuoes       º Data ³  06/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _mAll(_nTipo,aItens)

	Local _nCount
	For _nCount  := 1 to len(aitens)
		aItens[_nCount,1] := iif(_nTipo = 1,'X',' ')
	Next _nCount

	oListBox2:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³FlexPrjects         º Data ³  02/12/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ApvDese()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Aprovar Desenho "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local _nBaix   := 0
	Local _lCredito
	Local __ncount
	Local _nLin
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF PP8->PP8_STATUS  $  "Z#F"

			If !(Alltrim(Posicione("SB1",1,xFilial("SB1")+PP8->PP8_PROD,"B1_GRUPO"))=="999")
				aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})
			EndIf

		Endif
		Dbskip()

	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem Desenhos a serem liberados !")

	else

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		If  nOpcA == 1

			_aSds := {}
			_Ctexto  := ""
			_cnumseq := GeraSeq()

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'
					_nBaix++
					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					RecLock("PP8",.F.)
					PP8_NUMSEQ :=  _cNumSeq
					PP8->PP8_HIST := PP8->PP8_HIST +  "DESENHO APROVADO EM:" + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS := 'P'
					MsUnLock()

					Dbselectarea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbGoTop())
					If SB1->(DbSeek(xFilial("SB1")+PP8->PP8_PROD))

						SB1->(RecLock("SB1",.F.))
						SB1->B1_XLIBDES	:= Date()
						SB1->(MsUnLock())

						DbSelectArea("SB2")
						SB2->(DbSetOrder(1))
						If !SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
							CriaSb2(SB1->B1_COD,SB1->B1_LOCPAD) //Cria saldo zero na SB2
						EndIf

					EndIf

					U_GERESTRU(PP8->PP8_PROD) //Chamado 001511

					If date()>=CTOD("16/03/2015") //Data do ajuste da rotina - Chamado 001645

						If  !Empty(Alltrim(PP8->PP8_PEDVEN)) .And. !Empty(Alltrim(PP8->PP8_PROD))

							DbSelectArea("SC5")
							SC6->(DbSetOrder(1))
							SC5->(DbGoTop())
							SC5->(DbSeek(xFilial("SC5")+SubStr(Alltrim(PP8->PP8_PEDVEN),1,6)))

							DbSelectArea("SC6")
							SC6->(DbOrderNickName("C6UNICITEM"))
							SC6->(DbGoTop())
							If SC6->(DbSeek(xFilial("SC6")+SubStr(Alltrim(PP8->PP8_PEDVEN),1,6)+PP8->PP8_CODIGO+PP8->PP8_ITEM))

								DbSelectArea("SC9")
								SC9->(DbSetOrder(1))
								SC9->(DbGoTop())
								If SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))

									If	Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
										a460estorna()
									EndIf
									//Chamado 002940
									U_STDelFR(SC6->(C6_NUM+C6_ITEM),SC6->C6_PRODUTO)//Elimina Falta e Reserva
									RecLock("SC6",.F.)
									SC6->C6_PRODUTO := PP8->PP8_PROD
									SC6->C6_XDTLDES := dDataBase
									SC6->C6_LOCAL   := Posicione("SB1",1,xFilial('SB1')+(SC6->C6_PRODUTO),"B1_LOCPAD")//Ajuste João Victor - 16/11/2015 para que o armazém do pedido seja igual ao armazém do produto
									Msunlock()
									//Chamado 002940

									_lCredito := MaAvalCred(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_VALOR,SC5->C5_MOEDA,.F.)
									nRecno:= SC6->(RecNo())
									MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,.F.,.T.,_lCredito,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
									MaLiberOk({SC6->C6_NUM},.F.)
									MsUnLockall()
									SC6->(DbGoto(nRecno))
								Else 
									RecLock("SC6",.F.)
									SC6->C6_PRODUTO := PP8->PP8_PROD
									SC6->C6_XDTLDES := dDataBase
									SC6->C6_LOCAL   := Posicione("SB1",1,xFilial('SB1')+(SC6->C6_PRODUTO),"B1_LOCPAD")//Ajuste João Victor - 16/11/2015 para que o armazém do pedido seja igual ao armazém do produto
									Msunlock()
								EndIf

							EndIf

						EndIf

					Else

						if  !Empty(Alltrim(PP8->PP8_PEDVEN)) .And. !Empty(Alltrim(PP8->PP8_PROD))

							DbSelectArea('SC6')
							SC6->(	DbSetOrder(1))
							SC6->(DbSeek(xFilial("SC6")+alltrim(PP8->PP8_PEDVEN)) )
							IF !Eof()
								RecLock("SC6",.F.)
								SC6->C6_PRODUTO :=  PP8->PP8_PROD
								SC6->C6_XDTLDES := dDataBase
								Msunlock()
							Endif

						endif

					EndIf

					/*/
					RecLock("PP8",.F.)
					PP8->PP8_HIST  	 := PP8->PP8_HIST +  iif(!empty(PP8->PP8_PROD), "SD REABERTA EM: "  ,  "SD GERADA EM: " ) + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS  := "E"
					PP8->PP8_DAPCLI   := DDATABASE
					PP8->PP8_UAPCLI   := CUSERNAME
					MSUNLOCK()
					/*/
					aadd(_aSds,{PP8->PP8_item,PP8->PP8_desenh+"/"+ PP8->PP8_PROD+"-"+ALLTRIM(PP8->PP8_DESCR)})//Ticket 20190830000015

					_Ctexto += _cNumSeq + chr(13)+ chr(10)

				Endif

			Next __nCount

			If _nBaix = len(aitens)
				RecLock("PP7",.F.)
				PP7->PP7_STATUS  := "2"
				MSUNLOCK()
			ElseIf _nBaix >= 1 .and. _nBaix < len(aitens)
				RecLock("PP7",.F.)
				PP7->PP7_STATUS  := "8"
				MSUNLOCK()
			Endif
			_cEmail    := getmv("ST_UNCENGE")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))+";everton.dias@steck.com.br;silvana.silva@steck.com.br"
			_cAssunto  := "Liberação de Desenho p/ Produção  "
			if len(_aSds) > 0

				_aMsg := {}

				Aadd( _aMsg , { "Atendimento: "          , PP8->PP8_CODIGO } )
				Aadd( _aMsg , { "Ocorrencia: "    	, "Aprovacao de Desenho - Controle: " +PP8->PP8_NUMSEQ } )
				Aadd( _aMsg , { "Cliente: "          , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )
				Aadd( _aMsg , {'',''} )		// Descrição  - Adicionado aspas simples Valdemir 08/05/2020
				//Aadd( _aMsg , { "Item: "+ PP8->PP8_ITEM ,"Desenho: "+PP8->PP8_DESENH+"/"+ PP8->PP8_PROD } ) //Ticket 20190830000015

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				cMsg += '<tr>'
				cMsg += '</tr>'
				For _nLin := 1 to Len(_aSds)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' +'Item: '+ _aSds[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' +'Desenho: '+ _aSds[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

				MsgStop("Liberacao de Desenho efetuada com sucesso" +chr(13) + chr(10)+chr(13) + chr(10)+"Foram gerados os seguintes sequenciais: " + chr(13) + chr(10)+ _Ctexto )//"Foi criado o produto " + _cCodProd + ", e tambem a SD referente a ele !")

			Endif

		Endif

	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  09/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Ft001Cop
	Local _nPreco := 0
	Local _cCliCop := ' '
	Local nSE5
	Local _ncount
	Local _nRetVal
	_cUnicom := PP7->PP7_CODIGO

	If MsgYesno("Confirma copia deste processo para um novo ?","Copia Unicom")
		_cCliCop:=STCLILOJ()
		If Empty(Alltrim(_cCliCop))
			return()
		EndIf
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+ _cCliCop))
			If !(MsgYesno("Confirma copia p/o cliente "+SA1->A1_NOME,"Copia Unicom"))
				return()
			EndIf
			cQuery := ""
			cQuery += " SELECT  *     "
			cQuery += " FROM " + RetSqlName("PP7")+" PP7 , " + RetSqlName("PP8") + " PP8"
			cQuery += " WHERE PP8.PP8_FILIAL = '" + xFilial("PP8") + "' "
			cQuery += " AND PP7.PP7_FILIAL = '" + xFilial("PP7") + "' "
			cQuery += " AND PP7.PP7_CODIGO = '" + _cUnicom + "' "
			cQuery += " AND PP8.PP8_CODIGO = PP7.PP7_CODIGO    "
			cQuery += " AND PP7.D_E_L_E_T_ = ' ' AND    PP8.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

			aStruPP7:= PP7->(dbStruct())

			For nSE5 := 1 To Len(aStruPP7)
				If aStruPP7[nSE5][2] <> "C" .and.  FieldPos(aStruPP7[nSE5][1]) > 0
					TcSetField("TRB",aStruPP7[nSE5][1],aStruPP7[nSE5][2],aStruPP7[nSE5][3],aStruPP7[nSE5][4])
				EndIf
			Next nSE5

			aStruPP8:= PP8->(dbStruct())

			For nSE5 := 1 To Len(aStruPP8)
				If aStruPP8[nSE5][2] <> "C" .and.  FieldPos(aStruPP8[nSE5][1]) > 0
					TcSetField("TRB",aStruPP8[nSE5][1],aStruPP8[nSE5][2],aStruPP8[nSE5][3],aStruPP8[nSE5][4])
				EndIf
			Next nSE5

			DbGotop()

			_cNewUnicom := GetSX8Num("PP7","PP7_CODIGO")
			ConfirmSX8()

			Dbselectarea("PP7")

			Reclock("PP7",.T.)
			For _ncount := 1 to len(aStruPP7)
				if valtype(aStruPP7[_nCount][1]) <> "U"  .AND. aStruPP7[_nCount][2] <> 'M'
					IF  ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_CODIGO"
						PP7_CODIGO := _cNewUnicom
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_CLIENT"
						PP7->&(aStruPP7[_nCount][1])  := SA1->A1_COD
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_LOJA"
						PP7->&(aStruPP7[_nCount][1])  := SA1->A1_LOJA
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_NOME"
						PP7->&(aStruPP7[_nCount][1])  := SA1->A1_NREDUZ
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_TRAVA"
						PP7->&(aStruPP7[_nCount][1])  := ' '
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_REPRES"
						PP7->&(aStruPP7[_nCount][1])  := SA1->A1_VEND
					ElseIf ALLTRIM(UPPER(aStruPP7[_nCount][1])) = "PP7_VEND"
						PP7->&(aStruPP7[_nCount][1])  := Posicione("SA3",7,xFilial("SA3")+__CUSERID,"A3_COD")
					ELSE
						PP7->&(aStruPP7[_nCount][1])  := TRB->&(aStruPP7[_nCount][1])
					ENDIF

				endif
			Next _nCount
			PP7->PP7_ENVM := Date()
			Msunlock()

			Dbselectarea("TRB")

			DO WHILE !EOF()
				Dbselectarea("PP8")
				Reclock("PP8",.T.)
				For _ncount := 1 to len(aStruPP8)
					if valtype(aStruPP8[_nCount][1]) <> "U" .AND. aStruPP8[_nCount][2] <> 'M'
						IF  ALLTRIM(UPPER(aStruPP8[_nCount][1])) = "PP8_CODIGO"
							PP8_CODIGO := _cNewUnicom
							/*
						ElseIf  ALLTRIM(UPPER(aStruPP8[_nCount][1])) = "PP8_CLIENT"
							PP8->&(aStruPP8[_nCount][1])  :=   SA1->A1_COD
						ElseIf ALLTRIM(UPPER(aStruPP8[_nCount][1])) = "PP8_LOJA"
							PP8->&(aStruPP8[_nCount][1])  := SA1->A1_LOJA
							*/
						ELSE

							PP8->&(aStruPP8[_nCount][1])  := TRB->&(aStruPP8[_nCount][1])
						ENDIF
					endif
				Next _nCount
				Msunlock()
				Dbselectarea("TRB")
				dBSKIP()

			Enddo

			Dbselectarea("TRB")
			DbClosearea("TRB")

			cQuery := ""
			cQuery += " SELECT  *     "
			cQuery += " FROM " + RetSqlName("SCJ")+" SCJ , " + RetSqlName("SCK") + " SCK"
			cQuery += " WHERE SCK.CK_FILIAL = '" + xFilial("SCK") + "' "
			cQuery += " AND SCJ.CJ_FILIAL = '" + xFilial("SCJ") + "' "
			cQuery += " AND SUBSTR(SCJ.CJ_XUNICOM,1,6) = '" +  _cUnicom + "' "
			cQuery += " AND SCJ.CJ_NUM =  SCK.CK_NUM    "
			cQuery += " AND SCK.D_E_L_E_T_ = ' ' AND    SCJ.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

			aStruPP7:= SCJ->(dbStruct())

			For nSE5 := 1 To Len(aStruPP7)
				If aStruPP7[nSE5][2] <> "C" .and.  FieldPos(aStruPP7[nSE5][1]) > 0
					TcSetField("TRB",aStruPP7[nSE5][1],aStruPP7[nSE5][2],aStruPP7[nSE5][3],aStruPP7[nSE5][4])
				EndIf
			Next nSE5

			aStruPP8:= SCK->(dbStruct())

			For nSE5 := 1 To Len(aStruPP8)
				If aStruPP8[nSE5][2] <> "C" .and.  FieldPos(aStruPP8[nSE5][1]) > 0
					TcSetField("TRB",aStruPP8[nSE5][1],aStruPP8[nSE5][2],aStruPP8[nSE5][3],aStruPP8[nSE5][4])
				EndIf
			Next nSE5

			COPMEMOS(xFilial("PP8"),PP8->PP8_CODIGO,_cUnicom) //Atualizar campos MEMO

			DbGotop()

			Do While !eof()

				IN_PEDIDO := GetSX8Num("SCJ","CJ_NUM")
				ConfirmSX8()

				_cOrca := TRB->CJ_NUM

				Reclock("SCJ",.T.)

				For _ncount := 1 to len(aStruPP7)

					if valtype(aStruPP7[_nCount][1]) <> "U" .AND. aStruPP7[_nCount][2] <> 'M'

						Do Case

						Case ALLTRIM(UPPER(aStruPP7[_nCount][1])) == "CJ_NUM"

							SCJ->CJ_NUM := IN_PEDIDO

						Case ALLTRIM(UPPER(aStruPP7[_nCount][1])) == "CJ_XUNICOM"

							_cItem :=  SUBSTR(TRB->CJ_XUNICOM,7,3)

							SCJ->CJ_XUNICOM := _cNewUnicom   + SUBSTR(TRB->CJ_XUNICOM,7,3)
						Case ALLTRIM(UPPER(aStruPP7[_nCount][1])) == "CJ_CLIENTE"
							SCJ->CJ_CLIENTE :=  SA1->A1_COD
						Case ALLTRIM(UPPER(aStruPP7[_nCount][1])) == "CJ_LOJA"
							SCJ->CJ_LOJA := SA1->A1_LOJA
						Otherwise

							SCJ->&(aStruPP7[_nCount][1])  := TRB->&(aStruPP7[_nCount][1])

						EndCase

					endif
				Next _nCount
				Msunlock()

				DbselectArea("PP8")
				Dbsetorder(1)
				Dbseek(xfilial("PP8")+_cNewUnicom+_cItem )

				IF !EOF()

					Reclock("PP8",.F.)
					PP8->PP8_NUMORC := IN_PEDIDO
					PP8->PP8_HIST 	:= PP8->PP8_HIST + "UNICOM COPIADO DO UNICOM  " + _cUnicom + "  EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10) + REPLICATE("-",80) + chr(13) + chr(10)
					Msunlock()

				Endif

				Dbselectarea("TRB")
				Do While _cOrca == TRB->CJ_NUM .AND. !eof()

					Dbselectarea("SCK")
					Reclock("SCK",.T.)
					For _ncount := 1 to len(aStruPP8)
						if valtype(aStruPP8[_nCount][1]) <> "U" .AND. aStruPP8[_nCount][2] <> 'M'

							IF  ALLTRIM(UPPER(aStruPP8[_nCount][1])) == "CK_NUM"
								SCK->CK_NUM := IN_PEDIDO //_cNewUnicom
							ElseIf 	ALLTRIM(UPPER(aStruPP8[_nCount][1])) == "CK_CLIENTE"
								SCK->CK_CLIENTE := SA1->A1_COD
							ElseIf 	ALLTRIM(UPPER(aStruPP8[_nCount][1])) == "CK_LOJA"
								SCK->CK_LOJA := SA1->A1_LOJA
							ELSE
								SCK->&(aStruPP8[_nCount][1])  := TRB->&(aStruPP8[_nCount][1])
							ENDIF
						endif

					Next _nCount
					Msunlock()
					Dbselectarea("TRB")
					dBSKIP()

				Enddo

				Dbselectarea("SCK")
				SCK->(Dbsetorder(1))
				SCK->(DbGoTop()  )
				If	SCK->(Dbseek(xfilial("SCK")+IN_PEDIDO))
					Do While SCK->(!eof())   .and. IN_PEDIDO = SCK->CK_NUM

						_nRetVal:=  U_STRETSST('01',SCK->CK_cliente , SCK->CK_loja,SCK->CK_PRODUTO,scj->cj_Condpag,'PRECO')

						_nPreco := Iif(valtype(_nRetVal)= 'N',_nRetVal,0)//U_STRETSST('01',SCK->CK_cliente , SCK->CK_loja,SCK->CK_PRODUTO,scj->cj_Condpag,'PRECO')
						_nPreco := iif(_nPreco==0,0.01,_nPreco)

						DbSelectarea("SCK")
						RecLock("SCK",.F.)
						SCK->CK_PRCVEN		:= _nPreco
						SCK->CK_XPRUNIC 	:= _nPreco
						SCK->CK_PRUNIT	 	:= _nPreco
						SCK->CK_TES         := U_STRETSST('01',SCK->CK_cliente , SCK->CK_loja,SCK->CK_PRODUTO,scj->cj_Condpag,'TES')
						SCK->CK_VALOR		:= _nPreco*SCK->CK_QTDVEN
						msunlock()

						SCK->(DbSkip())

					Enddo

				EndIf

				Dbselectarea("TRB")

			Enddo

			MsgStop("Foi gerado o unicom "  + _cNewUnicom )
		Else
			MsgInfo("Cliente Não Encontrado..!!!")
		Endif
	Endif

	Dbselectarea("TRB")
	DbClosearea("TRB")

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  09/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraSeq()

	_cQuery := "SELECT NVL(MAX(SUBSTR(PP8_NUMSEQ,7,3)),'000') AS NUMSEQ FROM "+RETSQLNAME("PP8")
	_cQuery += "  WHERE  PP8_NUMSEQ LIKE '"+SUBSTR(DTOS(DDATABASE),1,6)+"%' AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"NUMSEQ",.T.,.T.)

	_cNumSeq := SUBSTR(DTOS(DDATABASE),1,6) +  STRZERO(val(NUMSEQ)+1,3)

	DbCloseArea("NUMSEQ")
	/*/
	DbSelectarea("PP8")
	RecLock("PP8",.F.)

	PP8_NUMSEQ :=  _cNumSeq

	MsUnlock()
	/*/
Return(_cNumseq )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReabrSd()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aArea     := GetArea()

	Local cCadastro := "Reabrir Solicitacao de Desenvolvimento "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local __ncount
	Local _nLin

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF  PP8->PP8_STATUS $  "EZP"  //.and. !empty(PP8->PP8_PROD)

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()

	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem itens para Reabrir SD!")

	else

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		_lSD := .f.

		If  nOpcA == 1

			_aSds := {}

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					IF PP8->PP8_STATUS $  "EZ
						_lSD := .t.
					Endif

					RecLock("PP8",.F.)
					PP8->PP8_HIST  	 := PP8->PP8_HIST +  iif(!empty(PP8->PP8_PROD), "SD REABERTA EM: "  ,  "SD GERADA EM: " ) + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS  := "E"
					PP8->PP8_DAPCLI   := DDATABASE
					PP8->PP8_UAPCLI   := CUSERNAME
					PP8->PP8_DTENG 	:= ctod("  /  /   ")
					PP8->PP8_USENG 	:= " "
					PP8->PP8_DTRCSD   := ctod("  /  /   ")
					PP8->PP8_USRCSD   := " "
					PP8->PP8_INDESE   := ctod("  /  /   ")
					PP8->PP8_QUDESE   := " "
					PP8->PP8_PROD   := " "
					PP8->PP8_DESENH   := " "
					MSUNLOCK()

					aadd(_aSds,{pp8_item,pp8_descr})

					Dbselectarea("PP7")
					RECLOCK("PP7",.F.)
					PP7->PP7_STATUS:="3"
					MsUnlock()
				Endif

			Next __nCount

			_cEmail    := getmv("ST_UNCENGE") +";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
			_cAssunto  := "Reabertura de Desenvolvimento - Engenharia"

			if len(_aSds) > 0
				_lOrc := .f.
				/*	IF MsgYesNo("Reabre Orcamento ?? ")
				_lOrc := .t.
				For __ncount := 1 to len(aitens)

					if aItens[__ncount , 01 ] = 'X'

				Dbselectarea('SCJ')
				SCJ->(dbsetorder(6))
				SCJ->(Dbseek(xfilial("SCJ") +PP7->PP7_CODIGO + aitens[__ncount ,2]))
				RecLock("SCJ",.F.)
				CJ_STATUS = 'A'
				Msunlock()
					Endif
				Next __nCount
				Dbselectarea("PP7")
				RECLOCK("PP7",.F.)
				PP7->PP7_STATUS:="3"
				MsUnlock()
			Else
				_lOrc := .f.

			Endif
				*/
			_aMsg := {}

			Aadd( _aMsg , { "Atendimento: "          , PP8->PP8_CODIGO } )
			Aadd( _aMsg , { "Ocorrencia: "    	, "Alterações no Projeto - Engenharia " + iif(_lOrc ,"/ Orcamento "," ")  } )
			Aadd( _aMsg , { "Cliente: "          , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
			Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
			Aadd( _aMsg , { "Hora: "    		, time() } )
			Aadd( _aMsg , { "Dt.Necessidade: "    		, IIF(EMPTY(ALLTRIM(PP8->PP8_DTNEC)),dtoc(PP7->PP7_DTNEC),dtoc(PP8->PP8_DTNEC)) } )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do cabecalho do email                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do texto/detalhe do email                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _nLin := 1 to Len(_aMsg)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			cMsg += '<tr>'
			cMsg += '</tr>'
			For _nLin := 1 to Len(_aSds)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' +'Iten: '+ _aSds[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do rodape do email                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'

			IF _lSd //PP8->PP8_STATUS $  "EZ
				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")
			ENDIF

			if _lOrc
				_cEmail  := getmv("ST_UNCORCA")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
				_cAssunto  := "Reabertura de Orcamento "
				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

			endif
			MsgStop("Reabertura de SD efetuada com sucesso")//"Foi criado o produto " + _cCodProd + ", e tambem a SD referente a ele !")

		Endif

	Endif

Endif
Return

Static Function _AltCust()

	MsgStop("Altercao de custo bloqueada")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _Faz_custo(_cTipo,_lRefresh )
	Local _nPosItem  := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local _nPosPreco := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_PRORC" })
	Local _lzerado   := .f.
	Local _nXnet     := 0
	Local _nNETGeral := 0
	Local _nPosCus   := 0
	Local _nCusGeral := 0
	Local _cTesA	 := ' '
	Procregua(len(_aitens))
	_aitens 		:= {}
	_aitens2		:= {}

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	Dbselectarea('SCJ')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	_nTotGeral := SCJ->CJ_XVLRMOD
	_nCstGeral := SCJ->CJ_XVLRMOD
	_nStNet :=0
	_nStCust:=0
	Dbselectarea('SCK')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCK") + PP8->PP8_NUMORC )
	Do while !eof() .and. PP8->PP8_NUMORC == SCK->CK_NUM
		IncProc()
		Dbselectarea('SB1')
		SB1->(dbsetorder(1))
		Dbseek(xfilial("SB1") + SCK->CK_PRODUTO )

		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xfilial("SB2") + SCK->CK_PRODUTO +SB1->B1_LOCPAD))

		Dbselectarea('SCK')

		_xValor := SB1->B1_XPCSTK

		_nPosCus := aScan(_aCusto,{|x| AllTrim(x[1]) == ALLTRIM(SCK->CK_PRODUTO)})

		If _nPosCus = 0
			_nCust  :=U_STCUSTO(SCK->CK_PRODUTO)
			_cTesA:=U_STRETSST('01',PP7->PP7_CLIENT,PP7->PP7_LOJA ,ALLTRIM(SCK->CK_PRODUTO) ,PP7->PP7_CPAG  ,'TES')
			aadd(_aCusto,{ALLTRIM(SCK->CK_PRODUTO)   , _nCust ,_cTesA }  )

		Else
			_nCust := _aCusto[_nPosCus,2]
			_cTesA := _aCusto[_nPosCus,3]
		EndIf

		IF	SCK->CK_XTP_PRD $ 'S '
			_cPrec_Ven := SCK->CK_PRCVEN * (1+(SCJ->CJ_XMARGEM/100))
		ELSE
			_cPrec_Ven := SCK->CK_PRCVEN * (1+(SCJ->CJ_XPRCTER/100))
		ENDIF

		if _cPrec_Ven == 0
			_lzerado := .t.
		endif

		_xValor :=SCK->CK_PRCVEN
		//	_nXnet:=	STLiq(	SCK->CK_QTDVEN * _cPrec_Ven,SCK->CK_PRODUTO,	SCK->CK_QTDVEN)
		_nXnet:=	STLiq(	_cPrec_Ven*SCK->CK_QTDVEN,SCK->CK_PRODUTO,	SCK->CK_QTDVEN,_cTesA)

		//1               2               3              4            5                         6           7                      8                     9
		AADD( _aitens , {SCK->CK_PRODUTO,;
			SCK->CK_DESCRI,;
			SCK->CK_QTDVEN,;
			_cPrec_Ven ,;
			SCK->CK_QTDVEN * _cPrec_Ven ,;
			_xValor,;
			SCK->CK_QTDVEN * _xValor,;
			SCK->(recno()),;
			sck->CK_XTP_PRD,;
			_nCust,;
			_nXnet,;
			iif(_nCust<>0,_nXnet/_nCust,0);
			})
		IF	SCK->CK_XTP_PRD $ 'S '
			_nStNet +=_nXnet
			_nStCust +=_nCust
		EndIf
		_nTotGeral +=	(SCK->CK_QTDVEN * _cPrec_Ven  )

		_nCstGeral +=	(SCK->CK_QTDVEN * _xValor)
		_nNETGeral +=  _nXnet
		_nCusGeral +=  _nCust
		nPos1:= aScan(_aitens2,{|x| AllTrim(x[1]) == alltrim(SB1->B1_GRUPO)})

		IF nPos1 == 0
			AADD(_aitens2,{SB1->B1_GRUPO,posicione("SBM",1,XFILIAL("SBM")+SB1->B1_GRUPO,"BM_DESC"),	(SCK->CK_QTDVEN *	_xValor) })
		Else
			_aitens2[nPos1,3] +=(SCK->CK_QTDVEN *	_xValor)
		Endif

		Dbselectarea('SCK')
		Dbskip()

	Enddo
	_nStMarg:=_nNETGeral/_nCusGeral
	_nStMark:=_nStNet/ _nStCust
	_cTexto2 := "Markup (%)   " + transform(_nStMark , "@e 999.99" )
	_cTexto3 := "Margem Geral " + transform(_nStMarg        , "@e 999.99" )
	_xMargem :=  ( ( (_nTotGeral - SCJ->CJ_XVLRMOD) / (_nCstGeral- SCJ->CJ_XVLRMOD ) )-1) * 100

	AADD(_aitens , {"M.O.D.","Taxa de Mao de Obra",1,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,0,"X",0,0,0})
	AADD(_aitens , {"NET","Total Geral NET",0,0,_nTotGeral,0,_nCstGeral,0,"X",_nCusGeral,_nNETGeral,_nNETGeral/_nCusGeral})
	//AADD(_aitens , {"Total","Total c/ Impostos",0,0,_nTotGeral,0,_nCstGeral,0,"X"})

	if len(_aitens2) == 0

		AADD(_aitens2,{' ',' ',	0})
	endif

	_ntotImps := U_STMAFISUNI(_nTotGeral)

	AADD(_aitens , {"Total","Total c/ Impostos",0,0,_nTotImps ,0,0,0,"X",0,0,0})

	if !_lZerado
		Dbselectarea("PP8")
		RecLock("PP8",.F.)
		PP8_PRORC := _nTotGeral
		MsUnlock()
	Endif
	//oGetDad1:ACOLS[oGetDad1:nat,_nPosPreco] := _nTotImps

	if len(_aitens2) == 0

		AADD(_aitens2,{' ',' ',	0})
	endif

	if _lRefresh

		oListBox2:Refresh()
		oListBox3:Refresh()
		odlg2:Refresh()
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SupUnic()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	If u_STFTA003()

		//_Faz_custo(_cTipo,.f.)
		Processa({||_Faz_custo(_cTipo,.f.),"Recalculando... "})
	EndIf

	_ctexto1 := "Terceiros(%) " + transform(SCJ->CJ_XPRCTER , "@e 999.99" )
	_cTexto2 := "Markup (%)   " + transform(_nStMark , "@e 999.99" )
	_cTexto3 := "Margem Geral " + transform(_nStMarg        , "@e 999.99" )
	oPromptt1:Refresh()
	oListBox2:Refresh()
	oListBox3:Refresh()
	odlgx2:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkpUnic()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	//If u_STFTA03b(StMarkUp())
	If u_STFTA03b(SCJ->CJ_XMARGEM)
		Processa({|| _Faz_custo(_cTipo,.f.),"Recalculando... "})
		//_Faz_custo(_cTipo,.f.)
	EndIf

	_cTexto1 := "Terceiros(%) " + transform(SCJ->CJ_XPRCTER , "@e 999.99" )
	_cTexto2 := "Markup (%)   " + transform(_nStMark , "@e 999.99" )
	_cTexto3 := "Margem Geral " + transform(_nStMarg        , "@e 999.99" )

	oPromptm1:Refresh()
	oListBox2:Refresh()
	oListBox3:Refresh()
	odlgx2:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  01/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  Alin_Vlr(_nLinhaAc)

	Local lOk:=.F.

	IF __cUserId $ getmv('ST_ALTPUNI',,'000000')

		IF _aitens[_nLinhaAC,8] <> 0

			_nValor := _aitens[_nLinhaAC,6]

			DEFINE MSDIALOG oDlg FROM  140,000 TO 350,615 TITLE OemToAnsi("Alterar Valor Custo") PIXEL
			DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oDlg
			@ 026,006 TO 056,305 LABEL OemToAnsi(alltrim(_aitens[_nLinhaAC,1])+"-"+alltrim(_aitens[_nLinhaAC,2])) OF oDlg PIXEL

			@ 040,013 SAY OemtoAnsi("Valor")   SIZE 24,7  OF oDlg PIXEL
			@ 038,035 MSGET _nValor  Picture '@e 999,999.99' VALID Chk_Custo(_nLinhaAc) SIZE 105,09 OF oDlg PIXEL

			ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})

			If lOk

				_aitens[_nLinhaAC,6]  := _nValor

				Dbselectarea('SCK')
				DbGoto(_aitens[_nLinhaAC,8])

				Dbselectarea('PP8')
				reclock('PP8',.f.)
				PP8->PP8_HIST := PP8->PP8_HIST +  "ITEM ALTERADO PRECO COMPONENTE :"+alltrim(_aitens[_nLinhaAC,1])+ " DE: << "+ ALLTRIM(TRANSFORM(SCK->CK_PRCVEN,'@e 999,999.99'))+  " >>  PARA: << "+ ALLTRIM(TRANSFORM(_nValor,'@e 999,999.99'))+" >> EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
				MsUnlock()

				Dbselectarea('SCK')
				RecLock('SCK',.F.)
				sck->ck_valor := _nValor
				SCK->CK_PRCVEN:= _nValor
				If SCK->CK_PRUNIT = 0
					SCK->CK_PRUNIT := _nValor
				EndIf
				MsUnlock()

				Processa({||_Faz_custo(_cTipo,.f.),"Recalculando... "})
				//	_Faz_custo(_cTipo,.f.)

				_cTexto3 := "Margem Geral " + transform(_xMargem        , "@e 999.99" )
				_ctexto2 := "Markup (%)   " + transform(SCJ->CJ_XMARGEM , "@e 999.99" )

				oPromptm1:Refresh()
				oListBox2:Refresh()
				oListBox3:Refresh()
				odlgx2:Refresh()

			Endif
		Else
			MsgStop("Item nao pode ser alterado !!!")
		Endif
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  05/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Chk_Custo(_nLinhaAc)

	_lRet := .t.

	Dbselectarea("SB1")
	DbsetOrder(1)
	Dbseek(xfilial("SB1")+_aitens[_nLinhaAC,1])

	if _nValor < IIF(SB1->B1_XPCSTK <> 0,SB1->B1_XPCSTK ,SB1->B1_CUSTD)

		MsgStop('Preco abaixo do custo nao permitido','Atencao')
		_lRet := .f.

	endif

Return   _lRet

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±º Metodo   ³ STFATG02 ºAutor  ³ DONIZETE           º Data ³  28/01/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Recalcula o valor de venda baseando-se na UF do cliente    º±±
	±±º          ³ e no fator de reducao de ICMS, clientes com A1_CONTRIB='1' º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ STECK                                                      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºValidacao ³  Gatilho do campo C6_PRODUTO - Item 2.4 MIT044             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºAlteração ³  Giovani.Zago Fiz Funcionar...                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

	*-------------------------------*
User Function STFTG001(_cCliente,_cLoja,_cProduto)
	*-------------------------------*
	Local _nIcms    := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_CONTRIB")  // Se é Contribuinte ICMS
	Local _cEst		:= Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_EST")  	// Estado do CLiente
	Local _nVend	:= 0.01
	Local _nDescPad	:= 0 // Fator reducao ICMS
	Local _nTotPed	:= 0
	Local  nCnt		:= 0
	Local _cOrig	:= 0
	Local nPrcVen	:= 0
	Local lretx     := .F.
	Local aRet 		:= {}
	Local aRefFis 	:= {}
	Local aImpostos := {"IT_VALICM","IT_VALIPI","IT_VALSOL","IT_ALIQICM","IT_VALMERC","IT_VALPS2","IT_VALCF2"}
	Local nCnt  	:= 0
	Local nCnt1 	:= 0
	Local nValIcms	:= 0
	Local _cTabela  :=''
	Local _nICMPAD	:=_nICMPAD2 :=0
	Local lSaida        := .F.
	Local nopcao        := 1
	Local oDxlg
	Local _nStx         :=0
	Local _cItemx       := ''
	Local aSalAtu       := {}
	local _lcall 		:= isincallsteck("U_STFAT15")
	Local _cOpeTran     := GetMv('ST_OPERTRAN',,'94/74/75')//TIPO DE OPERAÇÃO transferencia/beneficiamento  ....utiliza preço de custo sb2
	Private _nValUlt 	:= 0
	Private	_dUltVen    := CTOD('  /  /    ')
	Private	_lUltVen    := .F.
	Private _nPis 	    := 0
	Private _nCofins    := 0

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If  aCols[n,_nPosOper] $ _cOpeTran  //.Or.  M->C5_CLIENTE+M->C5_LOJACLI = '03544401'
			aCols[n,_nPosPrv]   := STTel()
			aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
			If	M->C5_TIPO $ 'C/P/I'
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] //pedidos de complemento nao possuem quantidade o valor total fica igual ao valor unitario giovani.zago 30/01/13
			Else
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			EndIf
			aCols[n,_nPosList]  := aCols[n,_nPosPrv]
			_oDlgDefault        := GetWndDefault()
			aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf
			Return(.F.)
		EndIf

		DbSelectArea("ZZB")    //Renato - 050713 - Preço de queima de estoque - Solicitação Abner
		ZZB->(DbSetOrder(1))
		If  ZZB->(DbSeek(xFilial("ZZB")+aCols[n,_nPosProd]) )  .and. DATE() <= ZZB->ZZB_DTVALID
			aCols[n,_nPosPrv]   := ZZB->ZZB_PRECO
			aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
			aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			aCols[n,_nPosList]  := aCols[n,_nPosPrv]
			//	_oDlgDefault        := GetWndDefault()
			//	aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf
			Return(.F.)
		EndIf

		If  aCols[n,_nxDesc] <> 0
			aCols[n,_nPosPDesc] :=	aCols[n,_nxDesc]
			aCols[n,_nPosVDesc] :=	aCols[n,_nXVdes]
		EndIf
		_nICMPAD2:= U_STFATMAFIS()
		_cAreaSC5 := GetArea("SC5")
		_cAreaSC6 := GetArea("SC6")
		U_ST04GAX()
		_cTabela := M->C5_TABELA

		STREG01(aCols[n,_nPosProd], M->C5_CLIENTE, M->C5_LOJACLI)

		aCols[n,_nPosUltPrc]  := _nValUlt
		aCols[n,_nPosDtUlt]   := _dUltVen
		aCols[n,_nPosLult]    := _lUltVen

		DbSelectArea("DA1")
		if ! DA1->(Dbseek(xFilial("DA1")+_cTabela+aCols[n,_nPosProd])) .And. aCols[n,_nPosPscPrc]  = 0
			aCols[n,_nPosPrv]  := 0.01
			aCols[n,_nBloqIt]  := "1"

			aCols[n,_nPosUnt]  := 0.01
			aCols[n,_nPosTot]  := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			aCols[n,_nPosList] := aCols[n,_nPosPrv]

			M->C5_ZBLOQ        := "1"
			M->C5_ZMOTBLO      := ALLTRIM(M->C5_ZMOTBLO)+'PSC/'
			u_stmafisret()
			// _oDlgDefault := GetWndDefault()
			// aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
			If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
				If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
					oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
					oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
				EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
			EndIf
			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf

			Return(.F.)
		EndIf
		nPrcVen := aCols[n,_nPosPrv]

		_cOrig:=Posicione("SB1",1,xFilial("SB1")+aCols[n,_nPosProd],"B1_ORIGEM")
		IF  _cOrig $ "1|3"  	// Origem do Produto se for 1 ou 3 Aborta
			//		ApMsgAlert("Produto com Origem " + _cOrig,"Atenção.")
		ENDIF

		_nUfCli    := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")      // Uf do cliente

		_nICMPAD  	:= SuperGetMv("MV_ICMPAD",,"") // Parâmetro com ICMS da Empresa dentro do Estado

		IF  _nIcms == "1" //Calcula o somente quando o cliente é Contribuinte = 1
			IF Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_ZDIFPC") == "1" // Diferencial de PIS/Cofins
				IIF (_nPis 		== 0,_nPis		:=SuperGetMv("MV_TXPIS"  ,,""),)
				IIF (_nCofins 	== 0,_nCofins	:=SuperGetMv("MV_TXCOFIN",,""),)
				//	_nDescPad	:= (1-((100 - (_nICMPAD+_nPis+_nCofins))/((100 -_nICMPAD2) +_nPis+_nCofins)))*100   // Ex. SP: (1-((100-18+1.65+7.60)/(100-(12+1.65+7.60))))*100
				_nDescPad	:= (1-((100 - (_nICMPAD+_nPis+_nCofins))/(100-(_nICMPAD2+_nPis+_nCofins))))*100   // Ex. SP: (1-((100-18+1.65+7.60)/(100-(12+1.65+7.60))))*100
			else
				_nDescPad	:= (1-((100 - _nICMPAD)/(100 - _nICMPAD2 )))*100   // (1-((100-18)/(100-12)))*100
			Endif
		EndIf

		// Calcula o desconto somente quando o cliente é Contribuinte = 1 e Estado Diferente de SP
		if  _nIcms == "1" .and. _cEst != "SP"
			_nDescUnit:= nPrcVen * ( _nDescPad/100)
		else
			_nDescUnit:=0
		Endif
		_nStx:=	ROUND(aCols[n,_nPosPrv] - _nDescUnit,2)

		If _lUltVen
			if !_lcall
				aCols[n,_nPosLult] :=STTELAPRE(_nStx)
			else
				acols[n,_nposlult] :=.f.
			endif
		Else
			aCols[n,_nPosLult] :=.f.
		Endif

		If aCols[n,_nPosPscPrc]  <> 0
			aCols[n,_nPosPrv]   := aCols[n,_nPosPscPrc]
		ElseIf !aCols[n,_nPosLult]
			aCols[n,_nPosPrv]   := ROUND(aCols[n,_nPosPrv] - _nDescUnit,2)
		ElseIf  aCols[n,_nPosLult]
			aCols[n,_nPosPrv]   := aCols[n,_nPosUltPrc]
			If ROUND(aCols[n,_nPosPrv] - _nDescUnit,2) > _nValUlt
				aCols[n,_nBloqIt]  :=	"2"
				M->C5_ZBLOQ  := '1'
				M->C5_ZDESBLQ:=M->UA_XDESBLQ+'/ATU'
			Endif
		Endif

		_nVend :=aCols[n,_nPosPrv]
		// Grava o valor total
		aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
		aCols[n,_nPosList]  := aCols[n,_nPosPrv]
		aCols[n,_nxDesc]    :=	aCols[n,_nPosPDesc]
		aCols[n,_nXVdes]    :=	aCols[n,_nPosVDesc]
		aCols[n,_nPosPDesc] :=0
		aCols[n,_nPosVDesc] :=0
		aCols[n,_nPrccon]   := aCols[n,_nPosPrv]

		U_STMAFISRET()
		// Atualiza a Get Dados	e Rodapé
		//_oDlgDefault := GetWndDefault()
		//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
		If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
			If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
				oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
				oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
			EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
		EndIf

		Ma410Rodap(,,0)
		If ( Type("l410Auto") == "U" .OR. !l410Auto )
			oGetDad:oBrowse:Refresh()
		EndIf
		dbcommitall()

		RestArea(_cAreaSC5)
		RestArea(_cAreaSC6)
		lretx      := .f.
	EndIf
Return(lretx)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  03/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function _CHk_Sunicom()

	DbselectArea('SB1')
	DBSETORDER(1)
	Dbseek(xfilial("SB1")+"SUNICOM")
	IF EOF()

		aVetor:= {	{"B1_COD"       ,"SUNICOM" 	     	,NIL},;
			{"B1_DESC"      ,"PRODUTO S-UNICOM" ,NIL},;
			{"B1_TIPO"    	,"PA"            	,Nil},;
			{"B1_UM"      	,"UN"            	,Nil},;
			{"B1_GRUPO"     ,"999"            	,Nil},;
			{"B1_LOCPAD"  	,"01"            	,Nil},;
			{"B1_PICM"    	,0               	,Nil},;
			{"B1_IPI"     	,0               	,Nil},;
			{"B1_CONTRAT" 	,"N"             	,Nil},;
			{"B1_LOCALIZ" 	,"N"             	,Nil}}

		lMsErroAuto := .f.

		MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)

		If lMsErroAuto
			MostraErro()
		Endif

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  04/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraPV2
	Local	_npvs := 0
	Local __ncount
	Local _nVal:= 0
	Local _nTot:= 0
	For __ncount := 1 to len(aitens)

		if aItens[__ncount , 01 ] = 'X'
			_npvs++
		endif

	Next __ncount

	if _npvs > 0 .and. MsgYesno("Gera Pedido de Vendas ")
		aItenspv := {}

		SA1->(dbsetorder(1))
		SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))

		aCab := {	{"C5_TIPO"		,"N"							,Nil},;
			{"C5_EMISSAO"	,ddatabase						,Nil},;
			{"C5_CLIENTE"	,alltrim(SA1->A1_COD)			,Nil},;
			{"C5_LOJACLI"	,alltrim(SA1->A1_LOJA)			,Nil},;
			{"C5_LOJAENT"	,alltrim(SA1->A1_LOJA)			,Nil},;
			{"C5_CONDPAG"	,PP7->PP7_CPAG					,Nil},;
			{"C5_ZCONDPG"	,PP7->PP7_CPAG					,Nil},;
			{"C5_TPFRETE"	,"F"							,Nil},;
			{"C5_XTIPF"		,"2" 							,Nil},;
			{"C5_XTIPO"		,"1" 							,Nil},;
			{"C5_ZCODCON"	,PP7->PP7_CODCON				,Nil},;
			{"C5_XUNICON"	,PP7->PP7_CODIGO				,Nil},;
			{"C5_ZDESCNT"	,PP7->PP7_CONTAT				,Nil}}
		_nItens := 0

		For __ncount := 1 to len(aitens)

			if aItens[__ncount , 01 ] = 'X'
				_nItens++
				Dbselectarea("PP8")
				PP8->(dbsetorder(1))
				PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

				IF EMPTY(PP8->PP8_PEDVEN)

					IF EMPTY(PP8->PP8_PROD)
						_CHk_Sunicom()
					Endif

					cTesPad  :=	U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD),PP7->PP7_CPAG  ,'TES')//"501"//u_StOper01()

					_nVal:= STLiq(PP8->PP8_PRORC*PP8->PP8_QUANT	,IF(EMPTY(ALLTRIM(PP8->PP8_PROD)),'SUNICOM',PP8->PP8_PROD),PP8->PP8_QUANT,if(empty(cTesPad),"501",cTesPad))
					_nTot+=_nVal
					AADD(aItenspv, {	{"C6_ITEM"		,strzero(_nItens,TamSX3("C6_ITEM")[1])						,Nil},;
						{"C6_PRODUTO"	,IF(EMPTY(ALLTRIM(PP8->PP8_PROD)),'SUNICOM',PP8->PP8_PROD)	,Nil},;
						{"C6_OPER"		,"01"														,Nil},;
						{"C6_DESCRI"	, PP8->PP8_DESCR											,Nil},;
						{"C6_QTDVEN"	, PP8->PP8_QUANT											,Nil},;
						{"C6_PRCVEN"	, PP8->PP8_PRORC	 										,Nil},;
						{"C6_VALOR"		, PP8->PP8_QUANT*PP8->PP8_PRORC 							,Nil},;
						{"C6_ENTRE1"	, PP7->PP7_DTNEC											,Nil},;
						{"C6_PRUNIT"	, PP8->PP8_PRORC					 						,Nil},;
						{"C6_ZVALLIQ"	,  	 _nVal													,Nil},; //Chamado 001311  tava cagado aqui giovani zago 14/05/2018
					{"C6_TES"		,if(empty(cTesPad),"501",cTesPad)							,Nil},;
						{"C6_XNUMUNI"	,PP8->PP8_CODIGO											,Nil},;
						{"C6_XITEUNI"	,PP8->PP8_ITEM												,Nil}})

				Endif
			Endif

		Next __ncount
		lMsErroAuto :=.f.
		BEGIN Transaction
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItenspv,3)
		End Transaction
		If lMsErroAuto
			MostraErro()
			lMsErroAuto := .F.
			DisarmTransaction()
		Else
			Dbselectarea('SC5')
			SC5->(dbsetorder(9))
			Dbseek(xfilial("SC5") +PP7->PP7_CODIGO )

			MsgStop("Pedido de venda " + SC5->C5_NUM +" Gerado !!!"  )





			u_xSTFISS(SC5->(Recno()))

			STAJULIQ()

			RecLock("PP8",.F.)
			PP8->PP8_HIST := PP8->PP8_HIST +  "PEDIDO DE VENDA: " + SC6->C6_NUM + " GERADO EM:" + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
			PP8->PP8_STATUS := 'F'
			PP8->PP8_PEDVEN :=  SC5->C5_NUM+SC6->C6_ITEM
			MsUnLock()

			Dbselectarea("PP7")
			RECLOCK("PP7",.F.)
			PP7->PP7_STATUS:="3"
			PP7->PP7_PEDIDO:=SC5->C5_NUM
			MsUnlock()

		Endif
	Endif

Return

Static Function STAJULIQ()
	Local _nTot:=0
	Local _nVal:=0

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC6->(DbGoTop())
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

			_nVal:=0
			_nVal:= STLiq(SC6->C6_VALOR	,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_TES)
			_nTot+=_nVal

			RecLock("SC6",.F.)
			SC6->C6_ZVALLIQ:=_nVal
			SC6->(MsUnlock())
			SC6->(DbCommit())

			SC6->(DbSkip())

		End
	EndIf
	RecLock("SC5",.F.)
	SC5->C5_ZVALLIQ	:= _nTot
	SC5->(MsUnlock())
	SC5->(DbCommit())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  05/15/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraPrc
	Local _lZerado := .f.

	Dbselectarea('SCJ')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	Dbselectarea('SCK')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCK") + PP8->PP8_NUMORC )
	Do while !eof() .and. PP8->PP8_NUMORC == SCK->CK_NUM

		Dbselectarea('SB1')
		SB1->(dbsetorder(1))
		Dbseek(xfilial("SB1") + SCK->CK_PRODUTO )

		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xfilial("SB2") + SCK->CK_PRODUTO +SB1->B1_LOCPAD))

		Dbselectarea('SCK')

		_xValor := SB1->B1_XPCSTK

		IF	sck->CK_XTP_PRD=='S'
			_cPrec_Ven := SCK->CK_PRCVEN * (1+(SCJ->CJ_XMARGEM/100))
		ELSE
			_cPrec_Ven := SCK->CK_PRCVEN * (1+(SCJ->CJ_XPRCTER/100))
		ENDIF

		if _cPrec_Ven == 0

			_lZerado := .t.

		endif

		//1               2               3              4            5                         6           7                      8                     9
		AADD( _aitens , {SCK->CK_PRODUTO,SCK->CK_DESCRI,SCK->CK_QTDVEN,_cPrec_Ven ,SCK->CK_QTDVEN * _cPrec_Ven ,_xValor,SCK->CK_QTDVEN * _xValor,SCK->(recno()),sck->CK_XTP_PRD}) //iif(sck->CK_XTP_PRD=='S','Steck',iif(sck->CK_XTP_PRD=='M','Terceiros','A Desenvolver'))})

		_nTotGeral +=	(SCK->CK_QTDVEN * SCK->CK_PRCVEN )

		_nCstGeral +=	(SCK->CK_QTDVEN * _xValor)

		nPos1:= aScan(_aitens2,{|x| AllTrim(x[1]) == alltrim(SB1->B1_GRUPO)})

		IF nPos1 == 0
			AADD(_aitens2,{SB1->B1_GRUPO,posicione("SBM",1,XFILIAL("SBM")+SB1->B1_GRUPO,"BM_DESC"),	_xValor })
		Else
			_aitens2[nPos1,3] +=	_xValor
		Endif

		Dbselectarea('SCK')
		Dbskip()

	Enddo

	AADD(_aitens , {"M.O.D.","Taxa de Mao de Obra",1,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,SCJ->CJ_XVLRMOD,0})
	AADD(_aitens , {"MKP","Mark-up ("+transform(SCJ->CJ_XMARGEM,'@e 999,99')+"%)",0,_nTotGeral*(SCJ->CJ_XMARGEM/100),_nTotGeral*(SCJ->CJ_XMARGEM/100),0,_nCstGeral*(SCJ->CJ_XMARGEM/100),0})
	_nTotGeral += (_nTotGeral*(1+(SCJ->CJ_XMARGEM/100)))
	_nCstGeral += (_nCstGeral*(1+(SCJ->CJ_XMARGEM/100)))
	AADD(_aitens , {"NET","Total Geral NET",1,_nTotGeral,_nTotGeral,0,_nCstGeral,0})

	if len(_aitens2) == 0

		AADD(_aitens2,{' ',' ',	0})
	endif

	_ntotImps := U_STMAFISUNI(_nTotGeral)

	AADD(_aitens , {"Total","Total c/ Impostos",0,0,_nTotImps ,0,0,0,"X"})
	if !_lZerado
		Dbselectarea("PP8")
		RecLock("PP8",.F.)
		PP8_PRORC := _nTotGeral
		MsUnlock()
	Endif
	oGetDad1:ACOLS[oGetDad1:nat,_nPosPreco] := _nTotImps

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OrcUnic()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	A415Visual('SCJ',SCJ->(RECNO()),4)
	Processa({||_Faz_custo(_cTipo,.f.),"Recalculando... "})
	//_Faz_custo(_cTipo,.f.)

	oListBox2:Refresh()
	oListBox3:Refresh()
	oDlgx2:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SupLegen  ºAutor  ³Microsiga           º Data ³  05/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SupLegen
	Local aCores    := {{"ENABLE"		,"Produtos Steck"},;
		{"BR_AMARELO"	,"Totais e Mao de Obra"},;
		{"DISABLE"		,"Terceiros / A Desenvolver"}}

	BrwLegenda(cCadastro,"Tipos de Produto",aCores)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SairUnic()

	Local _nPosPreco := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_PRORC" })

	Local _lprec := .t.
	Local _ncount

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + oGetDad1:ACOLS[oGetDad1:nat,_nPosItem]))

	For _ncount := 1 to len(_aItens)
		if _aItens[_ncount,5] == 0
			_lprec := .f.
		endif
	Next _ncount

	RecLock('PP8',.F.)
	if !_lprec
		PP8->PP8_PRCOM  := 0
		PP8->PP8_PRORC  := 0
		//else
		//	PP8->PP8_PRORC  := _aItens[len(_aItens),5]
	endif
	Msunlock()

	//oGetDad1:ACOLS[oGetDad1:nat,_nPosPreco] := PP8->PP8_PRORC

	oDlgx2:end()

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³STMAFISREL³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Abre o MAFISRET para trazer os valores dos tributos        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico Steck                                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STMAFISUNI(_nValor,_cTesA)

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'

	_cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	_cProduto := IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD)
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST
	If Valtype(_cTesA) ='C'
		_cTes:=_cTesA
	Else
		_cTes:=U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')	// u_LcStOper()
	EndIf
	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTes,;                                                            // 2-Codigo do TES ( Opcional )
	1,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

	//_nValor += (nValICms  + nValICMSST + nValPis + nValCof)
	_nValor +=nValIPI
Return(_nValor)

Static Function LibOrc()
	Local _lZero := .F.
	Local _cEmail :=  ' '
	Local _cAssunto :=   ' '
	Local cMsg := ' '
	Local _cOrc := ' '
	Local _cAtend := ' '
	Local _nLin

	Dbselectarea("PP8")
	PP8->(dbsetorder(1))
	If PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO ))
		Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
			If    PP8->PP8_PRORC = 0
				_lZero := .T.
				_cAtend:=_cAtend+ " / "+PP8->PP8_ITEM
			EndIf

			Dbselectarea('SCJ')
			SCJ->(dbsetorder(1))
			If SCJ->(	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC ))
				If 	0 =  SCJ->CJ_XVLRMOD
					_lZero := .T.
					_cOrc:=_cOrc+ " / "+PP8->PP8_ITEM
				EndIf
			EndIf
			PP8->(Dbskip())

		Enddo
	EndIf
	If _lZero
		MsgInfo("Unicon Não Pode ser Liberada...Itens sem Preço..!!!"+CR+'Item(unicom): '+_cAtend+_cOrc)
	EndIf
	If !_lZero .And. msgYesno("Deseja Liberar o Orcamento ?")
		RECLOCK("PP7",.F.)
		PP7->PP7_TRAVA :="1"
		PP7->PP7_APROV := __cUserId //chamado 006663
		MsUnlock()

		_aMsg := {}

		Aadd( _aMsg , { "Atendimento: "          , PP7->PP7_CODIGO} )
		Aadd( _aMsg , { "Ocorrencia: "    	, "Liberação de Custo" } )
		Aadd( _aMsg , { "Cliente: "          , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		cMsg += '<tr>'
		cMsg += '</tr>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		_cEmail  := getmv("ST_UNCORCA")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
		_cAssunto  := "Liberação de Orcamento "
		U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA001  ºAutor  ³Microsiga           º Data ³  06/13/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function val_crn()
	Local _lRet    := .T.
	Local _lCli    := .T.
	Local _cMsg    := ""
	Local _cmsblql := ""
	Local _cXcodmc := ""
	Local _ccodCli := ""

	//Chamado 001423
	dbSelectArea("SA1")
	SB1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+M->PP7_CLIENT+M->PP7_LOJA))
		_lCli := .T.
		_cmsblql := SA1->A1_MSBLQL
		_cXcodmc := SA1->A1_XCODMC
	Else
		_lCli := .F.
	Endif

	If _lCli
		_ccodCli := M->PP7_CLIENT
		If _cmsblql	== "1"
			MsgStop("Cliente Bloqueado !!!")
			_lRet := .f.
		Endif

		If ! Empty(_cXcodmc)

			DbSelectArea("SYP")
			SYP->(DbSetOrder(1))
			SYP->(DbGoTop())
			SYP->(DbSeek(xFilial("SYP")+_cXcodmc))

			While SYP->(!Eof()) .And. SYP->YP_CHAVE==_cXcodmc
				_cMsg	+= SYP->YP_TEXTO
				SYP->(DbSkip())
			EndDo

			If !Empty(_cMsg)
				MsgInfo(_cMsg)
			EndIf

		EndIf
	Else
		MsgStop("Cliente não encontrado")
		_lRet := .f.
	Endif

Return (_lRet)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³STMAFISREL³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Abre o MAFISRET para trazer os valores dos tributos        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico Steck                                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function STLiq(_nValor,_cProduto,_nQuant,_cTesA)
	Local   nValCmp , nValDif 							:= 0
	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'

	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	//_cTes:=U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')	// u_LcStOper()

	MaFisSave()

	MaFisEnd()

	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS
	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof+nValCmp +nValDif)

Return(round(_nValor,2))

Static Function vlrinfo()
	Local _nRet 	:= 0
	Local _nxRet 	:= 0
	Local _lRet 	:= .f.
	Local _nObr 	:= 0
	Local _nPosMark := Ascan(_aitens,{|x| AllTrim(x[1]) == "NET" })
	Local _nPosobr 	:= Ascan(_aitens,{|x| AllTrim(x[1]) == "M.O.D." })
	Local _nprMkup	:= SCJ->CJ_XMARGEM
	local _n12:= _n10:= _n11:= _n13 :=0
	Local _nk
	Private _nValRet:=0

	If _nPosMark <> 0
		_nRet:= _aitens[_nPosMark,07]
		_nObr:=_aitens[_nPosobr,05]

		@ 096,042 TO 280,505 DIALOG oDlgX TITLE "Valor Informado"
		@ 002,010 TO 066,222

		@ 015,020 SAY "Valor Fechado"
		@ 015,080 Get _nxRet Picture "@e 999,999,999.99" SIZE 045,15   valid(valret(_nxRet))

		@ 075,0150 BMPBUTTON TYPE 1 ACTION   Eval( { || _lRet:=.t., Close(oDlgX) }  )
		@ 075,0180 BMPBUTTON TYPE 2 ACTION  oDlgX:End()

		ACTIVATE DIALOG oDlgX CENTERED

		If _nxRet > 0    .And. _lRet

			For _nk:=1 To Len(_aItens)

				If	SubStr(_aItens[ _nk, 09 ],1,1) == 'M'
					_n10 +=_aItens[ _nk, 05 ]
					_n13 +=_aItens[ _nk, 07 ]
				EndIf
			Next _nk

			_n12  	 := ((_nValRet*100)/_nxRet) -100
			_n11   	 := (_nxRet*100)/(    100+_n12)
			_nprMkup := (((_n11-_nObr-_n10)*100)/(_nRet-_nObr-_n13))-100

			RecLock("SCJ",.f.)
			SCJ->CJ_XMARGEM  := round(_nprMkup,6)
			MsUnlock()
			Processa({|| _Faz_custo(_cTipo,.f.),"Recalculando... "})
		EndIf

	EndIf

Return()
Static Function valret(_nxRet)

	_nValRet:=	U_STMAFISUNI(_nxRet)

Return (.t.)

Static Function xReabrSd()

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Reabrir Orcamento "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local __ncount
	Local _nLin

	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF  PP8->PP8_STATUS $  "EZOP"  //.and. !empty(PP8->PP8_PROD)

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()

	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem itens para Orçamento!")

	else

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		_lSD := .f.

		If  nOpcA == 1

			_aSds := {}

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					IF PP8->PP8_STATUS $  "EZ
						_lSD := .t.
					Endif

					RecLock("PP8",.F.)
					PP8->PP8_HIST  	 := PP8->PP8_HIST +  "ORÇAMENTO REABERTA EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					/*	PP8->PP8_STATUS  := "E"
					PP8->PP8_DAPCLI   := DDATABASE
					PP8->PP8_UAPCLI   := CUSERNAME
					PP8->PP8_DTENG 	:= ctod("  /  /   ")
					PP8->PP8_USENG 	:= " "
					PP8->PP8_DTRCSD   := ctod("  /  /   ")
					PP8->PP8_USRCSD   := " "
					PP8->PP8_INDESE   := ctod("  /  /   ")
					PP8->PP8_QUDESE   := " "
					PP8->PP8_PROD   := " "
					PP8->PP8_DESENH   := " "
					*/
					MSUNLOCK()

					aadd(_aSds,{pp8_item,pp8_descr})

					Dbselectarea("PP7")
					RECLOCK("PP7",.F.)
					PP7->PP7_STATUS:="3"
					MsUnlock()
				Endif

			Next __nCount

			_cEmail    := getmv("ST_UNCENGE")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
			_cAssunto  := "Reabertura de Desenvolvimento - Engenharia"

			if len(_aSds) > 0
				_lOrc := .f.
				//IF MsgYesNo("Reabre Orcamento ?? ")
				_lOrc := .t.
				For __ncount := 1 to len(aitens)

					if aItens[__ncount , 01 ] = 'X'

						Dbselectarea('SCJ')
						SCJ->(dbsetorder(6))
						If SCJ->(Dbseek(xfilial("SCJ") +PP7->PP7_CODIGO + aitens[__ncount ,2]))
							RecLock("SCJ",.F.)
							CJ_STATUS = 'A'
							Msunlock()
						EndIf
					Endif
				Next __nCount
				Dbselectarea("PP7")
				RECLOCK("PP7",.F.)
				PP7->PP7_STATUS:="6"
				MsUnlock()
				//Else
				//	_lOrc := .f.

				//Endif

				_aMsg := {}

				Aadd( _aMsg , { "Atendimento: "          , PP8->PP8_CODIGO } )
				Aadd( _aMsg , { "Ocorrencia: "    	, "Alterações no Projeto " + iif(_lOrc ,"/ Orcamento "," ")  } )
				Aadd( _aMsg , { "Cliente: "          , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )
				Aadd( _aMsg , { "Dt.Necessidade: "    		, IIF(EMPTY(ALLTRIM(PP8->PP8_DTNEC)),dtoc(PP7->PP7_DTNEC),dtoc(PP8->PP8_DTNEC)) } )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				cMsg += '<tr>'
				cMsg += '</tr>'
				For _nLin := 1 to Len(_aSds)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' +'Iten: '+ _aSds[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				IF _lSd //PP8->PP8_STATUS $  "EZ
					U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")
				ENDIF

				if _lOrc
					_cEmail  := getmv("ST_UNCORCA")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
					_cAssunto  := "Reabertura de Orcamento "
					U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

				endif
				MsgStop("Reabertura de Orçamento Efetuada com sucesso")//"Foi criado o produto " + _cCodProd + ", e tambem a SD referente a ele !")

			Endif

		Endif

	Endif
Return
	/*====================================================================================\
	|Programa  | STCLILOJ         | Autor | GIOVANI.ZAGO             | Data | 19/07/2014  |
	|=====================================================================================|
	|Descrição | STCLILOJ                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCLILOJ                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STCLILOJ()
	*-----------------------------*
	Local _cRet 		:= Space(6)
	Local _cLoja   		:= '01'
	Local oDlgEmail
	Local lSaida      	:= .F.
	Private _cEst 		:= ' '
	Private _cGrp 		:= ' '
	Private _cUserSuper := GetMv("ST_FTA001",,"000360/000391/000380/000088")+'/000000/000645'

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+ PP7->PP7_CLIENT+PP7->PP7_LOJA)) .And. !(__cUserId $ _cUserSuper)
		_cEst := SA1->A1_EST
		_cGrp := SA1->A1_GRPVEN
		SA1->(dbSetFilter({|| SA1->A1_EST == _cEst .And.  _cGrp == SA1->A1_GRPVEN  },"SA1->A1_EST == _cEst  .And.  _cGrp == SA1->A1_GRPVEN  "))
	EndIf
	Do While !lSaida

		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite o Cliente") From  1,0 To 140,200 Pixel OF oMainWnd

		@ 02,04 SAY "Cliente:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _cRet   Size 55,013  F3 'SA1' PIXEL OF oDlgEmail Valid Empty(Alltrim(_cRet)) .Or. ExistCpo('SA1',_cRet)
		@ 27,04 SAY "Loja:" PIXEL OF oDlgEmail
		@ 37,04 MSGet _cLoja   Size 55,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cLoja))
		@ 12,62 Button "Ok"      Size 28,13 Action iif(!(Empty(Alltrim(_cRet))),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Cliente..!!!"))  Pixel
		@ 25,62 Button "Cancelar"  Size 28,13 Action Eval({|| _cRet:= ' ',_cLoja:= ' ',lSaida:=.T.,oDlgEmail:End()}) Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

	SA1->(DbClearFilter())
	Return(_cRet+_cLoja)
	/*====================================================================================\
	|Programa  | GeraGru          | Autor | GIOVANI.ZAGO             | Data | 19/07/2014  |
	|=====================================================================================|
	|Descrição | GeraGru                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GeraGru                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function GeraGru()
	*-----------------------------*
	Local _cRet  := Space(5)
	Local _cLoja := '01'
	Local oDlgEmail
	Local lSaida      := .F.
	Local cGrpVerif   := SuperGetMV("STGRPCOMPR",.F.,"005,039,040,041,042,047,110,117,122,127")

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Definir Grupo"
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }
	Local _cxProds := ' '
	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local _aGrupos	:= {}
	Local __ncount
	Local lRoteiro    := .F.				// Valdemir Rabelo 17/03/2020
	Local aGruRoteiro := {}
	Local emailpcp    := SuperGetMV("ST_PCPEMAI",.F.,"valdemir.rabelo@sigamat.com.br")

	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	dbSelectArea("SG1")

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		If !(Alltrim(PP8->PP8_PROD) $ 'SUNICON/S-UNICOM') .And. !(Empty(Alltrim(PP8->PP8_PROD)))

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec,PP8->PP8_PROD})

		Endif
		Dbskip()

	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem itens para Alterar o Grupo !!!!")

	else

		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 065,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
		@ 095,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

		_lSD := .f.

		If  nOpcA == 1

			_aSds := {}

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					_cxProds :=	aitens[__ncount ,5]
					_cItem   := aitens[__ncount ,2]

					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+Alltrim(_cxProds)))
						_cRet  := SB1->B1_GRUPO
						DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite o Grupo") From  1,0 To 140,300 Pixel OF oMainWnd

						@ 02,04 SAY "Produto:  "+SB1->B1_COD+" - "+Alltrim(SB1->B1_DESC) PIXEL OF oDlgEmail
						@ 15,04 SAY "Grupo:  "  PIXEL OF oDlgEmail
						@ 25,04 MSGet _cRet   Size 55,013  F3 'SBM' PIXEL OF oDlgEmail Valid ExistCpo('SBM',_cRet)

						@ 40,04 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({|| lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Grupo..!!!"))  Pixel

						ACTIVATE MSDIALOG oDlgEmail CENTERED

						If lSaida
							_cGrupo := SB1->B1_GRUPO
							// ------ Valdemir Rabelo - 28/10/2020 20200106000015 - Esta sendo realizado um estorno
							if (AllTrim(_cRet) == "999")
								if !EstGrpUn(_cGrupo, PP7->PP7_CODIGO, _cxProds, _cItem)
							      Return
								Endif
							endif
							// ------
							If AllTrim(SB1->B1_GRUPO)=="999" .And. AllTrim(_cRet) $ cGrpVerif    // Valdemir Rabelo Chamado: 20200701003633
								AADD(_aGrupos,{SB1->B1_COD,_cRet})
								U_STEMLGRP("UNICON",PP7->PP7_CODIGO,_aGrupos,PP7->PP7_REPRES)
							EndIf
							RecLock("SB1",.F.)
							SB1->B1_GRUPO  :=   _cRet
							SB1->B1_XDTUNIC := dDatabase
							SB1->(	Msunlock())
							// Verifica se existe Roteirização "Estrutura de Produto" - Valdemir Rabelo 17/03/2020
							SG1->( dbSetOrder(6) )			// G1_FILIAL + G1_COD + G1_TRT + G1_COMP
							lRoteiro := SG1->( dbSeek(xFilial("SG1")+SB1->B1_COD+_cRet) )			// Estrutura de Produto Gil informou que eles chamam de roteiro
							if !lRoteiro
								aAdd(aGruRoteiro, {"Produto - Grupo: ",SB1->B1_COD + " - " + SB1->B1_GRUPO} )
							Endif
							MsgInfo("Grupo Alterado....!!!")

						EndIf
					Else
						MsgInfo("Produto Não Cadastrado....!!!")
					EndIf

				Endif

			Next __nCount
			// Valdemir Rabelo - 17/03/2020
			if Len(aGruRoteiro) > 0
			   u_EMailST(emailpcp, "", "Grupos sem Roteirização", aGruRoteiro)
			Endif

		Endif
	Endif

	ApvDese()

Return()


/*/{Protheus.doc} EstGrpUn
description
Rotina de Estorno, caso necessite voltar ao grupo=999 Ticket: 20200106000015
@type function
@version 
@author Valdemir Jose
@since 29/10/2020
@param _cGrupo, param_type, param_description
@param CodUni, character, param_description
@param _cxProds, param_type, param_description
@return return_type, return_description
/*/
Static Function EstGrpUn(_cGrupo, CodUni, _cxProds, _cItem)
	Local cQry     := ""
	Local aAreaSC6 := GetArea()
	Local lRET     := .T.
	Local cPedido  := ""

	dbSelectArea("PP8")
	dbSetOrder(1)
	dbSelectArea("SC6")
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))

	if PP8->( dbSeek(xFilial('PP8')+CodUni+_cItem))

		cPedido := PP8->PP8_PEDVEN

		cQry += "SELECT R_E_C_N_O_ REGSC6 " + CRLF
		cQry += "FROM " + RETSQLNAME("SC6")	+ " A 			" + CRLF
		cQry += "WHERE A.D_E_L_E_T_ = ' ' 		" + CRLF
		cQry += " AND A.C6_NUM || A.C6_ITEM='"+cPedido+"' " + CRLF
		cQry += " AND A.C6_FILIAL='" + XFILIAL('SC6') + "' " + CRLF

		if Select("TSC6") > 0
			TSC6->( dbCloseArea() )
		endif

		TcQuery cQry New Alias "TSC6"

		While TSC6->( !Eof() )
			SC6->( dbGoto(TSC6->REGSC6) )
			if Empty(SC6->C6_NUMOP)
				// Realizar o Estorno da Liberação
				If SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))

					If	Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
						a460estorna()
					else
						FWMsgRun(,{|| Sleep(3000),"Informativo","Pedido: "+SC6->C6_NUM+" ITEM: "+SC6->C6_ITEM+" Está com ordem separação/Nota Fiscal Gerada. Processo não estornado"})
						lRET := .F.
					EndIf

				Endif
				if SB1->( dbSeek(xFilial('SB1')+SC6->C6_PRODUTO) )
					SB1->(RecLock("SB1",.F.))
					SB1->B1_XLIBDES	:= ctod("")
					SB1->(MsUnLock())
				Endif

				RecLock("SC6",.F.)
				SC6->C6_PRODUTO := "SUNICON"
				SC6->C6_XDTLDES := ctod("")
				MsUnlock()
			Else
				FWMsgRun(,{|| Sleep(3000),"Informativo","Pedido: "+SC6->C6_NUM+" ITEM: "+SC6->C6_ITEM+" Tem Ordem Produção Gerada. Processo não estornado"})
				lRET := .F.
			Endif

			TSC6->( dbSkip() )
		EndDo
		// Volta para ser liberado o desenho novamente
		RECLOCK("PP8",.F.)
		PP8->PP8_STATUS := "F"
		MSUNLOCK()
	endif 

	RestArea( aAreaSC6 )

Return lRET



	/*====================================================================================\
	|Programa  | STCANUNIC        | Autor | GIOVANI.ZAGO             | Data | 20/10/2014  |
	|=====================================================================================|
	|Descrição | STCANUNIC                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCANUNIC                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCANUNIC()
	*-----------------------------*
	Local cGetMot := Space(60)
	Local _nOpcao := 0

	Define msDialog oDlg Title "Motivo de Cancelamento" From 10,10 TO 20,45 Style DS_MODALFRAME

	@ 010,010 say "Motivo: "
	@ 020,010 get cGetMot  size 90,60 Picture "@!"   valid IiF( Len(alltrim(cGetMot)) >= 20,.t.,(msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"),.f.))

	DEFINE SBUTTON FROM 40,10 TYPE 1 ACTION IiF( Len(alltrim(cGetMot)) >= 20,(_nOpcao:=1,oDlg:End()),msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"))  ENABLE OF oDlg

	Activate dialog oDlg centered

	If _nOpcao = 1

		RecLock("PP7",.F.)
		PP7->PP7_STATUS  := "7"
		PP7->PP7_NOTAS	 := 	PP7->PP7_NOTAS+' - '+  " Cancelado:" + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + ' - Motivo: '+cGetMot
		MSUNLOCK()
	EndIf
	Return()

	/*====================================================================================\
	|Programa  | GERESTRU         | Autor | RENATO.NOGUEIRA          | Data | 24/02/2015  |
	|=====================================================================================|
	|Descrição | GERESTRU                                                                 |
	|          | Gerar estrutura assim que os desenhos forem aprovados						  |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GERESTRU                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-----------------------------*
User Function GERESTRU(_cProduto)
	*-----------------------------*

	Local _aArea	:= GetArea()
	Local _cFilial	:= ""

	/*
	±±³cProduto  ³ Codigo do produto origem                                    ³±±
	±±³nNivelCal ³ Leitura dos itens     - 1 Todos niveis  2 - Primeiro nivel  ³±±
	±±³nTipoItens³ Leitura dos itens     - 1 Aprovados     2 - Rejeitados      ³±±
	±±³          ³                         3 - Todos                           ³±±
	±±³nTipoData ³ Leitura dos itens     - 1 Qualquer data 2 - Data valida     ³±±
	±±³          ³                         3 - Data de/ate                     ³±±
	±±³dDataIni  ³ Leitura dos itens     - data limite inicial para filtragem  ³±±
	±±³dDataFim  ³ Leitura dos itens     - data limite final para filtragem    ³±±
	±±³nTipoSobre³ Gravacao dos itens    - 1 Sobrescreve   2 - Mantem          ³±±
	±±³nTipoApaga³ Pre estrutura gravada - 1 Apaga         2 - Mantem          ³±±
	±±³lMudaNome ³ Nome do produto pai   - T Muda          F - Mantem          ³±±
	±±³cNomePai  ³ Novo nome do produto pai                                    ³±±
	*/

	//A202GravG1(cProduto,nNivelCal,nTipoItens,nTipoData,dDataIni,dDataFim,nTipoSobre,nTipoApaga,lMudaNome,cNomePai)

	_cFilial := cFilAnt
	cFilAnt	 := "05" 				//"04"      Trocado por Valdemir 26/10/2020 Titcket: 20201023009371
	A202GravG1(PADR(_cProduto,15),1,3,1,Date(),Date(),1,2,.F.)
	cFilAnt	 := _cFilial

	RestArea(_aArea)

Return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A202GravG1³Rev.   ³Rodrigo de A Sartorio  ³ Data ³08.03.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Grava preestrutura como estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³cProduto  ³ Codigo do produto origem                                    ³±±
±±³nNivelCal ³ Leitura dos itens     - 1 Todos niveis  2 - Primeiro nivel  ³±±
±±³nTipoItens³ Leitura dos itens     - 1 Aprovados     2 - Rejeitados      ³±±
±±³          ³                         3 - Todos                           ³±±
±±³nTipoData ³ Leitura dos itens     - 1 Qualquer data 2 - Data valida     ³±±
±±³          ³                         3 - Data de/ate                     ³±±
±±³dDataIni  ³ Leitura dos itens     - data limite inicial para filtragem  ³±±
±±³dDataFim  ³ Leitura dos itens     - data limite final para filtragem    ³±±
±±³nTipoSobre³ Gravacao dos itens    - 1 Sobrescreve   2 - Mantem          ³±±
±±³nTipoApaga³ Pre estrutura gravada - 1 Apaga         2 - Mantem          ³±±
±±³lMudaNome ³ Nome do produto pai   - T Muda          F - Mantem          ³±±
±±³cNomePai  ³ Novo nome do produto pai                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A202GravG1(cProduto,nNivelCal,nTipoItens,nTipoData,dDataIni,dDataFim,nTipoSobre,nTipoApaga,lMudaNome,cNomePai)
	Local cAlias   := Alias()
	Local cNomeArq := ""
	Local lAchouCod:= .F.
	Local cCodiSeek:= ""
	Local nx       :=0
	Local nISGG    :=0
	Local cNomeCamp:=0
	Local nPosicao :=0
	Local aCodiSeek:={}
	Local aNomePos :={}
	Local aRegsSGG :={}
	Local lIntSFC	 := FindFunction('IntegraSFC') .And. IntegraSFC()
	Local lGravouSG1:=.F.
	Local lQBase   :=.T.
	Local cAliasB1BZ := If(GetMv('MV_ARQPROD')=="SBZ","SBZ","SB1")
	Local aAliasAnt := {}
	Local cCpoDest := If(cAliasB1BZ=="SBZ" .And. SBZ->(FieldPos("BZ_QB"))>0,"BZ_QB","B1_QB")
	Local lRevAut  := SuperGetMv("MV_REVAUT",.F.,.F.)
	Local lArqRev  := .F.
	Local cRevIni  := CriaVar("G1_REVINI")
	Local cRevFim  := CriaVar("G1_REVFIM")
	Local cProPai  := ""

	Private	nEstru := 0
	Private 	lRestEst   := SuperGetMv("MV_APRESTR",.F.,.F.)

	DbSelectArea("SGG")
	SGG->(DbSetOrder(1))
	SGG->(DbGoTop())
	If	SGG->(DbSeek(xFilial("SGG")+cProduto))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega perguntas do MTA200 e MATA202                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MTA200", .F.)
		lArqRev := MV_PAR02 == 1
		Pergunte('MTA202', .F.)

		// Muda ordem Codigo + Componente
		SG1->(dbSetOrder(1))
		// Cria arquivo de trabalho com a estrutura completa
		cNomeArq := Estrut2(cProduto,NIL,NIL,NIL,NIL,.T.)
		// Percorre arquivo para atualizar estrutura
		dbSelectArea('ESTRUT')
		ESTRUT->(dbGotop())
		ProcRegua(Lastrec())
		Begin Transaction
			Do While !ESTRUT->(Eof())
				IncProc()
				// Caso tenha aceitado somente primeiro nivel valida
				If nNivelCal == 2 .And. Val(ESTRUT->NIVEL) > 1
					ESTRUT->(dbSkip())
					Loop
				EndIf
				SGG->(dbGoto(ESTRUT->REGISTRO))
				/* Caso o paramento MV_APRESTR esteja habilitado somente devera ser gerado a estrutura para aquelas que foram
				aprovadas pelo grupo de aprovavao do controle de alcada */
				If (lRestEst .And. SGG->GG_STATUS <> "2")
					ESTRUT->(dbSkip())
					Loop
				EndIf
				// Verifica o tipo de item a ser considerado
				If (nTipoItens == 1 .And. SGG->GG_STATUS <> "2") .Or. (nTipoItens == 2 .And. SGG->GG_STATUS <> "3")
					dbSkip()
					Loop
				EndIf
				// Valida data com database
				If nTipodata == 2 .And. ((dDataBase < SGG->GG_INI)  .Or. (dDataBase > SGG->GG_FIM))
					dbSkip()
					Loop
				EndIf
				// Valida data com data de parametros
				If nTipodata == 3 .And. ((SGG->GG_INI < dDataIni)  .Or. (SGG->GG_INI > dDataFim))
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SG1")
				// Verifica qual o nome a ser alterado
				If lMudaNome .And. !Empty(cNomePai) .And. Val(ESTRUT->NIVEL) == 1
					cCodiSeek:=cNomePai
				Else
					cCodiSeek:=SGG->GG_COD
				EndIf
				lAchouCod:=dbSeek(xFilial("SG1")+cCodiSeek)
				// Processa gravacao se nao achou codigo ou se permite sobreposicao
				If nTipoSobre == 1 .Or. (nTipoSobre == 2 .And. !lAchouCod)
					lGravouSG1:=.T.
					// Sobrepoe estrutura caso necessario
					If lAchouCod .And. !(lRevAut .And. lArqRev)
						While !EOF() .And. 	xFilial("SG1")+cCodiSeek == G1_FILIAL+G1_COD
							Reclock("SG1",.F.)
							dbDelete()
							MsUnlock()
							dbSkip()
						End
					EndIf
					// Array com caracteristicas de campo
					// Criado para acelerar o processo evitando fieldpos e fieldname a todo momento
					If Len(aNomePos) == 0
						For nx:=1 to SGG->(FCount())
							cNomeCamp:="G1_"+Substr(SGG->(FieldName(nx)),4)
							nPosicao :=SG1->(FieldPos(cNomeCamp))
							// Grava todos os campos de SGG (mesmo nao existindo em SG1)
							// Array com
							// 1 Nome do campo no SG1
							// 2 Posicao do campo no SG1
							// 3 Posicao do campo no SGG
							Aadd(aNomePos,{cNomecamp,nPosicao,nx})
						Next nx
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega as informacoes do registro SGG 				            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nISGG++
					Aadd(aCodiSeek,cCodiSeek)
					Aadd(aRegsSGG,Array(SGG->(FCount())))
					For nx:=1 to SGG->(FCount())
						aRegsSGG[nISGG,nx] := SGG->(FieldGet(nx))
					Next
					// Grava status atualizado
					Reclock("SGG",.F.)
					If lMudaNome .And. !Empty(cNomePai) .And. Val(ESTRUT->NIVEL) == 1
						// Novo codigo do produto
						Replace GG_COD With cNomePai
					EndIf
					Replace GG_STATUS With "4"
					Replace GG_USUARIO With IIF(!lRestEst,Subs(cUsuario,7,6),RetCodUsr())
					If nTipoApaga == 1
						dbDelete()
					EndIf
					MsUnlock()
					// Grava qtd base no SB1
					If Val(ESTRUT->NIVEL) == 1 .And. lQBase
						aAliasAnt := GetArea()
						dbSelectArea(cAliasB1BZ)
						(cAliasB1BZ)->(dbSetOrder(1))
						If (cAliasB1BZ)->(dbSeek(xFilial(cAliasB1BZ)+SGG->GG_COD))
							If Substr(cCpoDest,1,2) == "B1"
								SB1->(dbSeek(xFilial("SB1")+SGG->GG_COD))
							EndIf
							Reclock(If(cCpoDest=="BZ_QB","SBZ","SB1"),.F.)
							If cAliasB1BZ == "SBZ"
								Replace &(cCpoDest) With If(SBZ->(FieldPos("BZ_QBP"))>0,SBZ->BZ_QBP,1)
							Else
								Replace &(cCpoDest) With If(SB1->(FieldPos("B1_QBP"))>0,SB1->B1_QBP,1)
							EndIf
							MsUnlock()
						Else
						    // Adicionando condição, peguei situação onde o código estava vindo em branco e
							// gerando problemas na gravação - Valdemir Rabelo 29/10/2020 - 20200106000015
							if SB1->(dbSeek(xFilial("SB1")+SGG->GG_COD))
								RecLock("SB1",.F.)
								If FieldPos("B1_QBP") > 0
									Replace SB1->B1_QB With SB1->B1_QBP
								Else
									Replace SB1->B1_QB With 1
								EndIf
								MsUnLock()
							Endif
						EndIf
						lQBase:=.F.
						RestArea(aAliasAnt)
					EndIf
				EndIf
				dbSelectArea('ESTRUT')
				dbSkip()
			EndDo
			If lGravouSG1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Le as informacoes dos registros de SGG contidas no array e      ³
				//³ grava as mesmas no arquivo SG1                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nISGG:=1 to Len(aRegsSGG)
					IF (lRevAut .And. lArqRev)
						IF cProPai <> 	aCodiSeek[nISGG]
							cRevFim  := A200Revis(aCodiSeek[nISGG],.F.)
							cRevIni  := cRevFim
						EndIf
						cProPai := aCodiSeek[nISGG]
					EndIf
					dbSelectArea("SG1")
					cCodiSeek := aCodiSeek[nISGG]
					Begin Transaction
						If !dbSeek(xFilial("SG1")+cCodiSeek+aRegsSGG[nISGG,3]+aRegsSGG[nISGG,4])
							Reclock("SG1",.T.)
							For nx:=1 to Len(aNomePos)
								If aNomePos[nx,2] > 0  // Verifica se campo existe em SG1
									FieldPut(aNomePos[nx,2],aRegsSGG[nISGG,nx])
								EndIf
							Next nx
							// Grava informacoes especificas
							// Filial
							G1_FILIAL := xFilial("SG1")
							G1_COD	  := cCodiSeek		//Incluido para nao gerar erro se o codigo do pai for alterado
							Replace G1_REVINI With cRevIni
							Replace G1_REVFIM With cRevFim
						Else
							Reclock("SG1",.F.)
							Replace G1_REVFIM With cRevFim
							If lRestEst
								Replace G1_QUANT With aRegsSGG[nISGG,5]
							EndIf
						EndIf
						Replace G1_PP7CODI with PP8->PP8_CODIGO			// Valdemir rabelo 28/02/2020 - Ticket: 20200204000316
						MsUnlock()
						If lIntSFC
							A200IntSFC(aCodiSeek[nISGG],'2')
						EndIf
					End Transaction
				Next
				// Atualiza parametro para recalcular nivel das estruturas 
				a200NivAlt()
			EndIf
		End Transaction
		FimEstrut2(Nil,cNomeArq)
		dbSelectArea(cAlias)

		If ExistBlock ("MTA202CRIA")
			ExecBlock ("MTA202CRIA",.F.,.F.,{cProduto,cNomePai})
		Endif

	Else

		MsgAlert("Pré-estrutura do produto "+AllTrim(cProduto)+" não encontrada")

	EndIf

RETURN .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Estrut2  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura a partir do SG1            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Estrut(ExpC1,ExpN1,ExpC2,ExpC3)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade a ser explodida                         ³±±
±±³          ³ ExpC2 = Alias do arquivo de trabalho                       ³±±
±±³          ³ ExpC3 = Nome do arquivo criado                             ³±±
±±³          ³ ExpL1 = Monta a Estrutura exatamente como se ve na tela    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observa‡„o³ Como e uma funcao recursiva precisa ser criada uma variavel³±±
±±³          ³ private nEstru com valor 0 antes da chamada da fun‡„o.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function Estrut2(cProduto,nQuant,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
	LOCAL nRegi:=0,nQuantItem:=0
	LOCAL aCampos:={},aTamSX3:={},lAdd:=.F.
	LOCAL nRecno
	LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc
	DEFAULT lPreEstru := .F.
	cAliasEstru:=IF(cAliasEstru == NIL,"ESTRUT",cAliasEstru)
	nQuant:=IF(nQuant == NIL,1,nQuant)
	lAsShow:=IF(lAsShow==NIL,.F.,lAsShow)
	nEstru++
	If nEstru == 1
		// Cria arquivo de Trabalho
		AADD(aCampos,{"NIVEL","C",6,0})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_COD","G1_COD"))
		AADD(aCampos,{"CODIGO","C",aTamSX3[1],0})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_COMP","G1_COMP"))
		AADD(aCampos,{"COMP","C",aTamSX3[1],0})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_QUANT","G1_QUANT"))
		AADD(aCampos,{"QUANT","N",Max(aTamSX3[1],18),aTamSX3[2]})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_TRT","G1_TRT"))
		AADD(aCampos,{"TRT","C",aTamSX3[1],0})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_GROPC","G1_GROPC"))
		AADD(aCampos,{"GROPC","C",aTamSX3[1],0})
		aTamSX3:=TamSX3(If(lPreEstru,"GG_OPC","G1_OPC"))
		AADD(aCampos,{"OPC","C",aTamSX3[1],0})
		// NUMERO DO REGISTRO ORIGINAL
		AADD(aCampos,{"REGISTRO","N",14,0})
		//cArqTrab := CriaTrab(aCampos)				  //Função CriaTrab descontinuada, adicionado o oTable no lugar
		oTable := FWTemporaryTable():New(cAliasEstru) //adicionado\Ajustado
		oTable:SetFields(aCampos)				      //adicionado\Ajustado
		oTable:Create()								  //adicionado\Ajustado
		cArqTrab := oTable:GetRealName()			  //adicionado\Ajustado
		If Select(cAliasEstru) > 0
			dbSelectArea(cAliasEstru)
			dbCloseArea()
		EndIf
		Use &cArqTrab NEW Exclusive Alias &(cAliasEstru) VIA TOPCONN // adicionado o driver TOPCONN \Ajustado
		IndRegua(cAliasEstru,cArqTrab,"NIVEL+CODIGO+COMP+TRT",,,"Selecionando registros") //"Selecionando Registros..."
		dbSetIndex(cArqtrab+OrdBagExt())
	EndIf
	dbSelectArea(If(lPreEstru,"SGG","SG1"))
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	While !Eof() .And. If(lPreEstru,GG_FILIAL+GG_COD,G1_FILIAL+G1_COD) == xFilial()+cProduto
		nRegi:=Recno()
		cCodigo    :=If(lPreEstru,GG_COD,G1_COD)
		cComponente:=If(lPreEstru,GG_COMP,G1_COMP)
		cTrt       :=If(lPreEstru,GG_TRT,G1_TRT)
		cGrOpc     :=If(lPreEstru,GG_GROPC,G1_GROPC)
		cOpc       :=If(lPreEstru,GG_OPC,G1_OPC)
		If cCodigo != cComponente
			lAdd:=.F.
			If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow)
				nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
				RecLock(cAliasEstru,.T.)
				Replace NIVEL    With StrZero(nEstru,6)
				Replace CODIGO   With cCodigo
				Replace COMP     With cComponente
				Replace QUANT    With nQuantItem
				Replace TRT      With cTrt
				Replace GROPC    With cGrOpc
				Replace OPC      With cOpc
				Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
				MsUnlock()
				lAdd:=.T.
				dbSelectArea(If(lPreEstru,"SGG","SG1"))
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRecno:=Recno()
			IF dbSeek(xFilial()+cComponente)
				cCodigo:=If(lPreEstru,GG_COD,G1_COD)
				Estrut2(cCodigo,nQuantItem,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
				nEstru --
			Else
				dbGoto(nRecno)
				If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow.And.!lAdd)
					nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
					RecLock(cAliasEstru,.T.)
					Replace NIVEL    With StrZero(nEstru,6)
					Replace CODIGO   With cCodigo
					Replace COMP     With cComponente
					Replace QUANT    With nQuantItem
					Replace TRT      With cTrt
					Replace GROPC    With cGrOpc
					Replace OPC      With cOpc
					Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
					MsUnlock()
					dbSelectArea(If(lPreEstru,"SGG","SG1"))
				EndIf
			Endif
		EndIf
		dbGoto(nRegi)
		dbSkip()
	Enddo
Return cArqTrab

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³FimEstrut2³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Encerra arquivo utilizado na explosao de uma estrutura     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ FimEstrut2(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo de Trabalho                       ³±±
±±³          ³ ExpC2 = Nome do Arquivo de Trabalho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function FimEstrut2(cAliasEstru,cArqTrab)
	cAliasEstru:=IF(cAliasEstru == NIL,"ESTRUT",cAliasEstru)
	dbSelectArea(cAliasEstru)
	dbCloseArea()
	FErase(AllTrim(cArqTrab)+GetDBExtension())
	FErase(AllTrim(cArqTrab)+OrdBagExt())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ STVENUNI ³ Autor ³ Renato Nogueira       ³ Data ³10.03.2015  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Altera vendedor unicon						 			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³Steck                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVENUNI()

	Local cVendMemory:=  M->PP7_REPRES
	Local cVendNew   :=  M->PP7_REPRES

	If __cUserId $ GetMv("ST_TRCVEND")

		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Vendedor") From 1,0 To 10,25 OF oMainWnd

		@ 05,04 SAY "Vendedor:" PIXEL OF oDlgEmail
		@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid ((existcpo("SA3",cVendNew)) .Or. alltrim(cVendNew)='' )
		@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
		@ 053, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
		@ 053, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
		nOpca:=0

		ACTIVATE MSDIALOG oDlgEmail CENTERED

		If nOpca == 1
			M->PP7_REPRES    := cVendNew

			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Pedido: </b>'+Alltrim(M->PP7_CODIGO)+'<br><b>Usuário: </b>'+Alltrim(cUserName)+'<br>'
			cMsg += '<b>Vendedor1 de: </b>'+M->PP7_REPRES+'<br>'
			cMsg += '<b>Vendedor1 para: </b>'+cVendNew+'<br>'
			cMsg += '</body></html>'

			//U_STMAILTES('filipe.nascimento@steck.com.br;daniel.santos@steck.com.br',"","Troca Vendedor",cMsg)




		Else
			M->PP7_REPRES := cVendMemory
		Endif

	Else

		MsgAlert("Usuário não autorizado para trocar vendedor")

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ COPMEMOS ³ Autor ³ Renato Nogueira       ³ Data ³13.03.2015  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Copia campos MEMO								 				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³Steck                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function COPMEMOS(_cFilial,_cNewUni,_cOldUni)

	Local _aAreaPP8	:= PP8->(GetArea())
	Local _aAreaPP82	:= {}
	Local _cNota		:= ""
	Local _cHsteng	:= ""
	Local _cNtorc		:= ""

	DbSelectArea("PP8")
	PP8->(DbSetOrder(1))
	PP8->(DbGoTop())

	If PP8->(DbSeek(xFilial("PP8")+_cNewUni))

		Do While PP8->(!Eof())  .and. PP8->PP8_CODIGO==_cNewUni

			_aAreaPP82	:= PP8->(GetArea())

			_cNota		:= Posicione("PP8",1,PP8->PP8_FILIAL+_cOldUni+PP8->PP8_ITEM,"PP8_NOTA")
			_cHsteng	:= Posicione("PP8",1,PP8->PP8_FILIAL+_cOldUni+PP8->PP8_ITEM,"PP8_HSTENG")
			_cNtorc		:= Posicione("PP8",1,PP8->PP8_FILIAL+_cOldUni+PP8->PP8_ITEM,"PP8_NTORC")

			RestArea(_aAreaPP82)

			PP8->(RecLock("PP8",.F.))
			PP8->PP8_NOTA		:= _cNota
			PP8->PP8_HSTENG		:= _cHsteng
			PP8->PP8_NTORC 		:= _cNtorc
			PP8->(Msunlock())
			PP8->(DbCommit())
			PP8->(Dbskip())

		Enddo

	EndIf

	RestArea(_aAreaPP8)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ FT001LIB ³ Autor ³ Renato Nogueira       ³ Data ³13.03.2015  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Copia campos MEMO								 				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³Steck                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT001LIB()

	If MsgYesNo("Deseja liberar o orçamento: "+PP7->PP7_CODIGO+"?")
		PP7->(RecLock("PP7",.F.))
		PP7->PP7_ZMOTBL	:= ""
		PP7->PP7_ZBLOQ	:= ""
		PP7->(MsUnLock())
	EndIf

Return()



/*/{Protheus.doc} ImpExcel
    Rotina Envio de WorkFlow - Aviso de data entrega Desenho
    @author Valdemir Rabelo
    @since 05/12/2019
/*/ 
User Function EnviaWF1(aWFDes, _cEmail, pAssunto)

	Local aArea 	:= GetArea()
	Local _cFrom    := "protheus@steck.com.br"
	Local cFuncSent := "STFTA001"
	Local nX        := 0
	Local cArq      := ""
	Local cMsg      := ""
	Local _nLin
	Local _cCopia   := ' '
	Local cAttach   := ' '
	Local _cEmaSup  := ' '
	Local _nCam     := 0
	Local nCol      := 0
	Local _aMsg     := aClone(aWFDes)
	Local _cAssunto := pAssunto


	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

		// Definicao do texto/detalhe do email
		For _nLin := 1 to Len(_aMsg)
			For nCol := 1 to Len(_aMsg[_nLin])
				If Alltrim(_aMsg[1,nCol,1]) == "Atendimento:"
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf

				cMsg += '<TD width="50%"><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,1] + ' </Font></B></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,nCol,2] + ' </Font></TD>'
			Next

		Next

		// Definicao do rodape do email
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf
	RestArea(aArea)
Return




/*/{Protheus.doc} STANEX
		(long_description)
		Chamada da rotina de anexar
		@type  Function
		@author user
		Valdemir Rabelo
		@since date
		30/01/2020
		@version version
		@param param, param_type, param_descr
		@return return, return_type, return_description
		@example
		(examples)
		@see (links_or_references)
/*/
Static Function STANEX(_lT)

	Local aArea       := GetArea()
	Local aArea1      := PP7->(GetArea())

	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _nLin       := 000
	Local cSolicit	  := 	PP7->PP7_CODIGO

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\UNICON\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""
	Private _cNUm       := ""+PP7->PP7_CODIGO+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Gravação do Fornecedor...!!!!")
			Return()
		EndIf
	EndIf

	//Criação das pastas para salvar os anexos das Solicitações do Fornecedor no Servidor
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	if !Empty(_cFil)
		_cServerDir += _cFil
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif
	Endif

	_cServerDir += _cNUm
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	If ExistDir(_cServerDir)

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(2,6)+".mzp")) = 1
			_cAne02 := Strzero(2,6)+".mzp"
		Else
			_cAne02 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(3,6)+".mzp")) = 1
			_cAne03 := Strzero(3,6)+".mzp"
		Else
			_cAne03 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(4,6)+".mzp")) = 1
			_cAne04 := Strzero(4,6)+".mzp"
		Else
			_cAne04 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(5,6)+".mzp")) = 1
			_cAne05 := Strzero(5,6)+".mzp"
		Else
			_cAne05 := space(90)
		Endif

		DbSelectArea("PP7")
		PP7->(DbSetOrder(1))
		If PP7->(DbSeek(xFilial("PP7")+cSolicit))
			dDtEmiss   := PP7->PP7_EMISSA
			cNomeVnd   := ALLTRIM(POSICIONE("SA3",1,XFILIAL("SA3")+PP7->PP7_VEND,"A3_NOME"))
			cCliente   := PP7->PP7_NOME
			cCNPJ      := Z54->Z54_CGC

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Nº Atend" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,140 say "Vend.Int." COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,170 get  cNomeVnd  when .f. size 110,08  Of oDxlg Pixel


				_nLin += 013
				@ _nLin,010 say "Cliente" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cCliente  when .f. size 095,08  Of oDxlg Pixel


				@ _nLin,140 say "Emissao" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,170 get  dDtEmiss  when .f. size 040,08  Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20

				DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg
				//DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

		EndIf

	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return()


 /*/{Protheus.doc} SaveAnexo
	(long_description)
	Salva anexo referente ao registro selecionado
	@type  Function
	@author user
	Valdemir Rabelo - SigaMat
	@since date
	13/12/2019
	@example
/*/
Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 5
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := Z54->(GetArea())

	//Local nOpcoes   := GETF_LOCALHARD
	// OpÃ§Ãµes permitidas
	//GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
	//GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
	//GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
	//GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
	//GETF_RETDIRECTORY   // Retorna apenas o diretÃ³rio e não o nome do arquivo

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - TÃ­tulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho máximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
			,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("Já existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Atenção")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				// Copio o arquivo original da máquina do usuário para o servidor
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					// Realizo a compactAção do arquivo para a Extensão .mzp
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					// Apago o arquivo original do servidor
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
					,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
					)
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' não foi anexado."+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
					,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"A Extensão "+cExtensao+" é inválida para anexar junto a solicitação de Compras."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
				,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)



 /*/{Protheus.doc} SaveAnexo
	(long_description)
	Deleta anexo referente ao registro selecionado
	@type  Function
	@author user
	Valdemir Rabelo - SigaMat
	@since date
	16/12/2019
	@example
/*/
Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := Z54->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa Ação o arquivo não ficará mais disponÃ­vel para consulta.","Atenção")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"não existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)



 /*/{Protheus.doc} OpenAnexo
	(long_description)
	Abre anexo referente ao registro selecionado
	@type  Function
	@author user
	Valdemir Rabelo - SigaMat
	@since date
	13/12/2019
	@example
/*/
Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "FORNECEDORES\"
	Local _lUnzip     := .T.

	//CriAção das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras na máquina Local do usuário
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

/*
	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif
*/
	_cLocalDir += _cEmp
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil+"\"
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cNUm
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		_cOpen   := Strzero(_nOpen,6)+".mzp"
		cZipFile := _cServerDir+_cOpen
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
			_lUnzip := MsDecomp( _cLocalDir+_cOpen , _cLocalDir )
			If _lUnzip
				Ferase  ( _cLocalDir+_cOpen)
				ShellExecute("open", _cLocalDir, "", "", 1)
			Else
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
				,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inválido"; //01 - cTitulo - TÃ­tulo da janela
			,"não existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
			,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

Return (_cOpen)


/*/{Protheus.doc} AnexaST01()
		(long_description)
		Chamada da rotina de anexar
		@type  Function
		@author user
		Valdemir Rabelo
		@since date
		30/01/2020
/*/
User Function AnexaST01()
	STANEX(.T.)
Return .T.


/*/{Protheus.doc} getPrior
	(long_description)
	Chamada da rotina Prioridade
	@type  Function
	@author user
	Valdemir Rabelo
	@since date
	25/03/2020
/*/
Static Function getPrior(nCombo)
	Local oBtOk
	Local oCMB
	Local nCMB := 7
	Local oGrupo
	Local oSayPior
	Local lRET := .F.
	Local nOPC := 0
	Static oDlgPrior


	DEFINE MSDIALOG oDlgPrior TITLE "PRIORIDADE" FROM 000, 000  TO 160, 320 COLORS 0, 16777215 PIXEL

	@ 007, 005 GROUP oGrupo TO 047, 151 PROMPT "[ Selecione ]" OF oDlgPrior COLOR 16711680, 12123885 PIXEL
	@ 024, 024 SAY oSayPior PROMPT "Prioridade" SIZE 025, 007 OF oDlgPrior COLORS 0, 16777215 PIXEL
	@ 022, 055 MSCOMBOBOX oCMB VAR nCMB ITEMS aPrior SIZE 072, 010 OF oDlgPrior COLORS 0, 16777215 PIXEL
	@ 054, 061 BUTTON oBtOk PROMPT "Ok" SIZE 037, 012 OF oDlgPrior ACTION (nOPC := ConfPrior(@lRET,oCMB,nCMB), oDlgPrior:End() ) PIXEL

	ACTIVATE MSDIALOG oDlgPrior CENTERED

	if nOPC < 7
		nCombo := (nOPC-1)
	endif

Return lRET


/*/{Protheus.doc} ConfPrior
	(long_description)
	Chamada da rotina Confirmação Prioridade
	@type  Function
	@author user
	Valdemir Rabelo
	@since date
	25/03/2020
/*/
Static Function ConfPrior(plRET, poCMB, pnCMB)
	Local nOPC := poCMB:nAT
	plRET := (nOPC < 7)
Return nOPC


/*/{Protheus.doc} DadosSD
	(long_description)
	Chamada da rotina Dados solicitação desenho
	@type  Function
	@author user
	Valdemir Rabelo
	@since date
	26/03/2020
/*/
User Function DadosSD(aCols, oGetDad1, nTotal, nItem, oObjEtq)
	Local aArea    := GetArea()
	Local nTop
	Local nLeft
	Local nBottom
	Local nRight
	Local cCadastro
	Local lNovo      := .F.
	Local cAliasZ67  := 'Z67'
	Local nOpcA      := 3
	Local cMemo      := ""
	Local nReg       := 0
	Local oDlgSD
	Local oRET       := nil
	Local cItem      := ''
	Local lVirtual   := .T. 								// Qdo .F. carrega inicializador padrao nos campos virtuais
	Local lMaximized := .T.
	Local aAcho		 := {"Z67_ENGENH","Z67_ESPECI","Z67_POSICA","Z67_FORELE","Z67_CORNOM","Z67_BITENT","Z67_INTERL","Z67_AMBINT","Z67_GPRTIP","Z67_TEMPER","Z67_NPRTUV","Z67_QTEMPO","Z67_SUJEXP","Z67_QTIPO","Z67_AMOSTR","Z67_DEPCML","Z67_APVCLI","Z67_PRZENT","Z67_PRIOR","NOUSER"}
	Local aCpos      := {"Z67_ENGENH","Z67_ESPECI","Z67_POSICA","Z67_FORELE","Z67_CORNOM","Z67_BITENT","Z67_INTERL","Z67_AMBINT","Z67_GPRTIP","Z67_TEMPER","Z67_NPRTUV","Z67_QTEMPO","Z67_SUJEXP","Z67_QTIPO","Z67_AMOSTR","Z67_DEPCML","Z67_APVCLI","Z67_PRZENT","Z67_PRIOR"}
	Local nX
	Private cCHAVE   := ""
	Default oGetDad1 := Nil
	Default nItem    := 0
	Default nTotal   := 0
	Default oObjEtq  := Nil

	if oGetDad1 == Nil
	   cItem := aCols[2]
	else 
	   cItem := oGetDad1:aCols[oGetDad1:nAt][2]
	endif 

	dbSelectArea(cAliasZ67)
	dbSetOrder(1)
	lNovo := (!dbSeek(xFilial('Z67')+PP7->PP7_CODIGO+cItem) )

	cCadastro := "UNICOM: "+PP7->PP7_CODIGO+" ITEM: " + cItem

	if oGetDad1 != Nil
		if lNovo
			nOPC := 3
		else
			nOPC := 4
		endif
		RegToMemory(cAliasZ67,.T.,lNovo)
		cCHAVE   := PP7->PP7_CODIGO+cItem

		_nRet := FWExecView(cCadastro,'STFTA001',nOPC)
	else 
		RecLock(cAliasZ67, lNovo)	   
		if lNovo
		   (cAliasZ67)->Z67_FILIAL := XFILIAL("Z67")
		   (cAliasZ67)->Z67_ATENDI := PP7->PP7_CODIGO+cItem
		Endif 
		For nX := 3 to (cAliasZ67)->( FCount() )
		    (cAliasZ67)->( FieldPut(nX, CriaVar(FieldName(nX),.T.)) )
		Next 
		MsUnlock()
		oRET := u_STRELSD(,, nTotal, nItem, oObjEtq)           // Ticket: 20210201001627 - Valdemir Rabelo
	Endif 

Return oRET


/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local _oModel
	Local oStr1:= FWFormStruct(1,'Z67')
	Local _aRel	:= {}

	_oModel := MPFormModel():New(cIDMODEL, {|_oModel|VLDALT(_oModel)},{|_oModel|TUDOOK(_oModel)},{|_oModel|GrvTOK(_oModel)})

	_oModel:SetDescription(cIDMODEL)

	_oModel:addFields('Z67',,oStr1, )    // cIDMODEL
	oStr1:SetProperty('Z67_ATENDI' , MODEL_FIELD_INIT, {|| cCHAVE } )
	// Tratando When
	oStr1:SetProperty('Z67_ATENDI' , MODEL_FIELD_WHEN, {|| .F. } )
	oStr1:SetProperty('Z67_ENGENH' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_ESPECI' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_POSICA' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_FORELE' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_TALENT' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_CORNOM' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_BITENT' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_INTERL' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	// Local de Trabalho
	oStr1:SetProperty('Z67_AMBINT' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_GPRTIP' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_TEMPER' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_NPRTUV' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_QTEMPO' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_SUJEXP' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_QTIPO'  , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_AMOSTR' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	// Fornecer desenho para
	oStr1:SetProperty('Z67_DEPCML' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_APVCLI' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_PRZENT' , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	oStr1:SetProperty('Z67_PRIOR'  , MODEL_FIELD_WHEN, {|| VldCmlWhen( _oModel ) } )
	// Preenchimento Engenharia
	oStr1:SetProperty('Z67_ENVENG' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_ASSENV' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_RECENG' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_ASSREC' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_RECPOR' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_DTPOR'  , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_HRPOR'  , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_DESENV' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_RESTIC' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_CPDPRD' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_CODVND' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_PS'	   , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_PRZDES' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_CONCLU' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )
	oStr1:SetProperty('Z67_HSCONC' , MODEL_FIELD_WHEN, {|| vldEngWhen( _oModel ) } )

	oStr1:setProperty('Z67_POSICA' ,MODEL_FIELD_VALID, {|| if(M->Z67_POSICAO=="..." .OR. EMPTY(alltrim(M->Z67_POSICAO)), u_GetPos67(),.F.) })

	_oModel:SetPrimaryKey({})

	_oModel:getModel('Z67'):SetDescription('Solicitação Desenvolvimento')   // cIDMODEL

Return _oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView		:= NIL
	Local oStr1		:= FWFormStruct(2, 'Z67')
	Local oModel    := FWLoadModel("STFTA001")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField(cIDMODEL , oStr1, 'Z67' )  //

	oView:CreateHorizontalBox( 'BOXFORM1', 100)

	oView:SetOwnerView(cIDMODEL,'BOXFORM1')

	oView:EnableTitleView(cIDMODEL,'Comercial')

	//Criando grupos
	oStr1:AddGroup( 'GRUPO01', ''		, 		'', 1 )
	oStr1:AddGroup( 'GRUPO02', 'Local de Trabalho', 	'', 2 )
	oStr1:AddGroup( 'GRUPO03', 'Fornecer Desenho Para', '', 3 )
	oStr1:AddGroup( 'GRUPO04', 'Preenchimento da Engenharia (Produtos)', '', 3 )

	oStr1:SetProperty( 'Z67_ATENDI'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_ENGENH'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_ESPECI'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_POSICA'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_FORELE'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_TALENT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_CORNOM'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_BITENT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z67_INTERL'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	// Local de Trabalho
	oStr1:SetProperty( 'Z67_AMBINT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_GPRTIP'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_TEMPER'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_NPRTUV'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_QTEMPO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_SUJEXP'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_QTIPO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z67_AMOSTR'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	// Fornecer desenho para
	oStr1:SetProperty( 'Z67_DEPCML'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z67_APVCLI'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z67_PRZENT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z67_PRIOR'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	// Preenchimento Engenharia
	oStr1:SetProperty( 'Z67_ENVENG'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_ASSENV'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_RECENG'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_ASSREC'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_RECPOR'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_DTPOR'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_HRPOR'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_DESENV'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_RESTIC'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_CPDPRD'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_CODVND'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_PS'		, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_PRZDES'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_CONCLU'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	oStr1:SetProperty( 'Z67_HSCONC'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView


/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet			:= .T.
	Local nOp         	:= oModel:GetOperation()
	Local cPosicao      := M->Z67_ENGENH
	Local cReadVar      := ReadVar()


Return(_lRet)



/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.


Return(_lRet)



/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp         		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv


/*/{Protheus.doc} GetPosicao
@type Static Function
@desc realiza Selecao
@author Valdemir Rabelo
@since 26/03/2020
/*/
User Function GetPos67()
	Local lRET := .T.
	if !Empty(alltrim(M->Z67_POSICA))
		lRET := MsgYesNo("Deseja atualizar seleção","Atenção!")
	endif
	if lRET
		GetPst67()
	endif
Return .T.



Static Function GetPst67()
	Local aPosicao  := {}
	Local cResp     := ""
	Local nPos		:= 0
	Local nX 		:= 0
	Local oListBox
	Local uVarRet
	Local aRecebe   := Separa(Alltrim(M->Z67_POSICA),"/")
	Local cReadVar  := ReadVar()
	Private oOk 	:= LoadBitmap(GetResources(),"LBOK")
	Private oNo 	:= LoadBitmap(GetResources(),"LBNO")
	Static oDlgZ

	uVarRet := GetMemVar(cReadVar)

	aAdd(aPosicao, {.f., "001", "Prensa Cabo"})
	aAdd(aPosicao, {.f., "002", "Adaptador"})
	aAdd(aPosicao, {.f., "003", "Somente Furação"})
	aAdd(aPosicao, {.f., "004", "Tampão"})
	aAdd(aPosicao, {.f., "005", "Será feito pelo cliente"})
	aAdd(aPosicao, {.f., "006", "Entrada Flange - Superior"})
	aAdd(aPosicao, {.f., "007", "Entrada Flange - Inferior"})

	// Verifico se ja foi selecionado algum registro
	For nX := 1 to Len(aRecebe)
		nPos := aScan(aPosicao, {|X| X[2]==aRecebe[nX]})
		if nPos > 0
			aPosicao[nPos][1] := .T.
		Endif
	Next
	// -----------------

	DEFINE MSDIALOG oDlgZ TITLE "Selecione" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@013, 007 LISTBOX oListBox  VAR cVar FIELDS Header " ", "Codigo", "Descricao" SIZE 234, 191 of oDlgZ PIXEL ON dblClick(aPosicao[oListBox:nAt,1] := (!aPosicao[oListBox:nAt,1]) )
	oListBox:SetArray(aPosicao)
	oListBox:bLine := {|| {Iif(aPosicao[oListBox:nAt, 1], oOk, oNo), aPosicao[oListBox:nAt,2], aPosicao[oListBox:nAt,3] }}

	@ 225, 081 BUTTON oBTOk 	PROMPT "OK"	  SIZE 037, 012 OF oDlgZ ACTION {OkConf(@uVarRet, cReadVar,oListBox,aPosicao), oDlgZ:End()} PIXEL
	@ 226, 130 BUTTON oBTSair 	PROMPT "Sair" SIZE 037, 012 OF oDlgZ ACTION oDlgZ:End() PIXEL

	ACTIVATE MSDIALOG oDlgZ CENTERED

Return


Static Function OkConf(uVarRet, cReadVar,oListBox,aPosicao)
	Local aArea 	:= GetArea()
	Local nUlt  	:= Len(aPosicao[1])
	Local nX    	:= 0
	DEFAULT uVarRet := ""
	DEFAULT cReadVar:= ""

	For nX := 1 to Len(aPosicao)
		if aPosicao[nX, 1]
			if !Empty(uVarRet)
				uVarRet += "/"
			Endif
			uVarRet += Alltrim(aPosicao[nX, 2])
		Endif
	Next

	// Atualiza a Variável de Retorno
	cRETGERVR    := uVarRet
	//------------------------------------------------------------------------------------------------
	// Atualiza a Variável de Memória com o Conteúdo do Retorno
	SetMemVar(cReadVar,cRETGERVR)

	//------------------------------------------------------------------------------------------------
	// Força a atualização dos Componentes (Provavelmente não irá funcionar). A solução. ENTER
	SysRefresh(.T.)

	M->Z67_POSICA := uVarRet

	// Atualiza os componentes
	GetDRefresh()

	RestArea( aArea )

Return .t.

/*/{Protheus.doc} VldCmlWhen
	@type Static Function
	@desc realiza validacao de usuario Comercial
	@author Valdemir Rabelo
	@since 26/03/2020
/*/
Static Function VldCmlWhen( oModel )
	Local lRET 		:= .F.
	Local oModWhen  := oModel:GetModel( 'FORM1' )
	Local cUsuarios := SuperGetMV('ST_COML067',.F.,'001177')

	cUsuarios += "#001246#001375"

	lRET := (__cUserId $ cUsuarios)

	//oModel:Refresh()

Return lRET

/*/{Protheus.doc} vldEngWhen
	@type Static Function
	@desc realiza validacao de usuario engenheiro
	@author Valdemir Rabelo
	@since 26/03/2020
/*/
Static Function vldEngWhen( oModel )
	Local lRET 		:= .F.
	Local oModWhen  := oModel:GetModel( 'FORM1' )
	Local cUsuarios := SuperGetMV('ST_ENGE067',.F.,'')

	cUsuarios += "#001246#001375"

	lRET := (__cUserId $ cUsuarios)

	//oModel:Refresh()

Return lRET
