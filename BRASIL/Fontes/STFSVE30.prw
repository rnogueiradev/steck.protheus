#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "tbicode.ch"
#INCLUDE 'TOTVS.CH'



/*
Chamado: 20210408005632 - Valdemir Rabelo
Campos Criado:
PC1_NFORIG
PC1_SRORIG
PC1_TOTAL
PC1_NFDEV
*/

/*
Ticket: 20211029023220 - Flávia Rocha - 03/11/2021
Inclusão de parâmetros para envio de email qdo motivo da Fatec for Logística
Motivos: 501,502,503,504,505,506,507

ST_FTECLOG -> contém os códigos dos motivos de logística
_cMotLog := GetNewPar("ST_FTECLOG","501,502,503,504,505,506,507")

ST_FATECMA -> contém os endereços de email da logística que recebem a notificação
_cMailLog:= GetNewPar("ST_FATECMA" , "kleber.braga@steck.com.br")  
*/
//-------------------------------------------------------------------------------------//
//FR - 29/07/2022 - Flávia Rocha - Sigamat Consultoria - MELHORIA FATEC
//Alterações realizadas mediante Ticket #20220325006576 - Solicitado por Rosa Santos
//Ao liberar uma Fatec onde haja necessidade de se recolocar o pedido de venda, 
//criar este pedido de venda automaticamente
//neste caso será criado se o campo PC1_RECPV estiver com o conteúdo = "S" (Sim) 
//-------------------------------------------------------------------------------------//

User Function STFSVE31()  // opcao para CQ
	u_STFSVE30()
Return

User Function STFSVE32()  // opcao para autorizacao de vendas
	U_STFSVE30()
Return

User Function STFSVE30()

	Local aCamVend :={ 'PC1';
		,'PC1_NUMERO';
		,'PC1_DTOCOR';
		,'PC1_STATUS'  ;
		,'PC1_NOTAE'  ;
		,'PC1_SERIEE' ;
		,'PC1_CODCLIE';
		,'FELIPE'}

Private cNFatec := ""

	U_XSTFSVE31(aCamVend)

Return

User Function XSTFSVE31(aCamVend)

	Local 	lFunc1   := IsFunc({"U_STFSVE31"})//CQ
	Local 	lFunc2   := IsFunc({"U_STFSVE32"})//Vendas
	Local 	_cUser   	:= __cUserID
	Local  cPerfilFat	:= SuperGetMv("ST_EXCLFAT")
	Local  _cUsrExc		:= SuperGetMv("ST_USREXCL",.F.,"000000#001043#000991#001178#001266") // Ticket 20210524008567
	Local aCores := {}

	aCores :={{ 'PC1->PC1_STATUS=="0"'                               , 'BR_AZUL' , 'Em Elaboração'},;
		{'PC1->PC1_STATUS=="1"'                                , 'BR_AMARELO' , 'Em Aberto'},;
		{'PC1->PC1_STATUS=="2" .AND. EMPTY(PC1->PC1_CONFER)'   , 'BR_VERDE'   , 'Autorizado comercial / Pendente fiscal'},;
		{'PC1->PC1_STATUS=="4"'                                , 'BR_PRETO'   , 'Atendimento sem Devolução'},;
		{'PC1->PC1_STATUS=="2" .AND. PC1->PC1_CONFER=="F" '    , 'BR_LARANJA' , 'Pendente Recebimento'},;
		{'PC1->PC1_STATUS=="2" .AND. PC1->PC1_CONFER=="R"'     , 'BR_CINZA'   , 'Recebido Fisicamente'},;
		{'PC1->PC1_STATUS=="3" .or. PC1->PC1_CONFER=="R"'      , 'BR_PINK'    , 'Recebido Classificada'},;
		{'PC1->PC1_STATUS=="5"'                                , 'BR_VERMELHO', 'Encerrado' }}

Private cString    := "PC1"
Private cVend      := 'PC1_NUMERO'
Private cNomVend   := 'PC1_DTOCOR'
Private cGrup      := 'PC1_STATUS'
Private cComsVend  := 'PC1_NOTAE'
Private cFilVend   := 'PC1_SERIEE'
Private cNomGrup   := 'PC1_CODCLIE'

	/*PRIVATE aRotina	 := {{ "Pesquisar"  ,"AxPesqui"      ,0 ,1 ,0 ,.F.},;  //"Pesquisar"
	{ "Visualizar" ,"AxVisual"      ,0 ,2 ,0 ,Nil},;  //"Visualizar"
	{ "Incluir"    ,"U_STFSVE35(3)" ,0 ,3 ,0 ,Nil},;  //"Incluir"
	{ "Alterar"    ,"U_STFSVE35(4)" ,0 ,4 ,0 ,Nil},;  //"Alterar"
	{ "Excluir"    ,"U_STFSVE35(5)" ,0 ,5 ,0 ,Nil},;  //"Excluir"
	{ "Legenda"    ,"U_ENCLEGEN()"	 ,0 ,6 ,0 ,Nil}}    */

	/*Private aRotina :={{"Pesquisa" ,"AxPesqui" ,0 ,1 ,0 ,.F.},; //"Pesquisar"
	                  {"Visualizar"                         , 'U_STFSVE35(2,2)', 0, 2, 0, Nil},; //"Visualizar"
	                  {"Incluir"                            , 'U_STFSVE35(3,3)', 0, 3, 0, Nil},; //"Incluir"
	                  {"Alterar"                            , 'U_STFSVE35(4,4)', 0, 4, 0, Nil},; //"Alterar"
	                  {"Liberar"                            , 'U_STFSVE35(9,4)', 0, 4, 0, Nil},; //"Liberar"
	                  {"Legenda"                            , 'U_ENCLEGEN()'   , 0, 5, 0, Nil}}*/

//>>Ticket 20210524008567 - Everson Santana - 25.05.2021
If _cUser $ _cUsrExc
	Private 	aRotina:= {	{"Pesquisa" 	,"AxPesqui"			,0 ,1 ,0 ,.F.},;  //"Pesquisar"
							{"Visualizar"	,'U_STFSVE35(2,2)'	,0 ,2 ,0 ,Nil},;  //"Visualizar"
							{"Incluir"		,'U_STFSVE35(3,3)'	,0 ,3 ,0 ,Nil},;  //"Incluir"
							{"Alterar"		,'U_STFSVE35(4,4)'	,0 ,4 ,0 ,Nil},;  //"Alterar"
							{"Liberar"		,'U_STFSVE35(9,4)'	,0 ,4 ,0 ,Nil},;  //"Liberar"
							{"Excluir"		,'U_STFSVE35(5,5)'	,0 ,5 ,0 ,Nil},;  //"Excluir"//Ticket 20210524008567 
							{"Legenda" 		,'U_ENCLEGEN()'		,0 ,5 ,0 ,Nil} }
//<< Ticket 20210524008567
else
	Private 	aRotina:= {	{"Pesquisa" 	,"AxPesqui"			,0 ,1 ,0 ,.F.},;  //"Pesquisar"
							{"Visualizar"	,'U_STFSVE35(2,2)'	,0 ,2 ,0 ,Nil},;  //"Visualizar"
							{"Incluir"		,'U_STFSVE35(3,3)'	,0 ,3 ,0 ,Nil},;  //"Incluir"
							{"Alterar"		,'U_STFSVE35(4,4)'	,0 ,4 ,0 ,Nil},;  //"Alterar"
							{"Liberar"		,'U_STFSVE35(9,4)'	,0 ,4 ,0 ,Nil},;  //"Liberar"
							{"Legenda" 		,'U_ENCLEGEN()'		,0 ,5 ,0 ,Nil} }
EndIF

If lFunc1

		aRotina :={{"Pesquisa"     ,"AxPesqui"        , 0, 1 ,0 ,.F.},; //"Pesquisar"
		           {"Visualizar"   , 'U_STFSVE35(2,2)', 0, 2, 0, Nil},; //"Visualizar"
		           {"Encerra GQ"   , 'U_STFSVE35(7,4)', 0, 3, 0, Nil},; //Encerra GQ
		           {"Legenda"      , 'U_ENCLEGEN()'   , 0, 6, 0, Nil},;
			       {"Observações"  , 'U_STVE35OB()'   , 0, 7, 0, Nil}}
Endif

If lFunc2

	IF _cUser $ cPerfilFat

			aRotina:= {	{"Pesquisa"   ,"AxPesqui"			,0 ,1 ,0 ,.F.},;  //"Pesquisar"
						{"Visualizar" ,'U_STFSVE35(2,2)'	,0 ,2 ,0 ,Nil},;  //"Visualizar"
						{"Legenda" 	  ,'U_ENCLEGEN()'		,0 ,6 ,0 ,Nil}}
	ELSE
			aRotina :={{"Pesquisa"   , "AxPesqui"       , 0 ,1 ,0 ,.F.},; //"Pesquisar"
			           {"Visualizar" , 'U_STFSVE35(2,2)', 0, 2, 0, Nil},; //"Visualizar"
			           {"Rejeitar"   , 'U_STFSVE36()'   , 0, 3, 0, Nil},; //"Rejeitar Fatec"
			           {"Autorizacao", 'U_STFSVE35(8,4)', 0, 4, 0, Nil},; //Autorizacao
			           {"Excluir"    , 'U_STFSVE35(5,5)', 0, 5, 0, Nil},; //"Excluir"
							{"Incluir"		,'U_STFSVE35(3,3)'	,0 ,3 ,0 ,Nil},;  //"Incluir"
							{"Alterar"		,'U_STFSVE35(4,4)'	,0 ,4 ,0 ,Nil},;  //"Alterar"
			           {"Legenda"    , 'U_ENCLEGEN()'   , 0, 6, 0, Nil}}
	ENDIF

Endif

	dbSelectArea("PC1")
	dbSetOrder(1)


	MBrowse(6,1,22,75,"PC1",,,,,,aCores)

	//RetIndex(cString)

Return NIL

User Function STFSVE35(nOpcx,nopc)
//U_STFSVE35(8,4) nOpcx -> 8 = Autoriza FATEC

	Local aAreaAnt   := GetArea()
	Local nCntFor    := 0
	Local nOpca	   := 0
	Local oDlgEsp
	Local aVisual    := {}
	Local cCampo     := ''
	Local nOrdem     := 0
	Local aObjects   := {}
	Local aPosObj    := {}
	Local aInfo	   := {}
	Local aSize	   := {}
	Local aNoFields  := {}
	Local cSeekDC6   := ''
	Local cWhile     := ''
	Local l080Visual := .F.
	Local l080Inclui := .F.
	Local l080Altera := .F.
	Local l080Deleta := .F.
	Local l080Copia  := .F.
	Local aCmpUser   := {}
	Local x := 0
	Local aButtons  := {}
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ''
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cEmlFatec:= SuperGetMV("ST_FATECMA",,"")
	Local _cAprov		:= SuperGetMv("ST_STFSVE3") //>>Solicitação do Vanderlei - Everson Santana - 12.04.18

	Private aTela[0][0],aGets[0]
	Private aHeader  := {}
	Private aCols    := {}

	Private aHeadForm 	:= RetHeaderForm()
	Private aHeadFatec	:= Aclone(aHeadForm)
	Private aColsForm 	:= RetColsForm(nOpcx)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx == 2
		l080Visual  := .T.
	ElseIf nOpcx == 3
		l080Inclui	:= .T.
	ElseIf nOpcx == 4
		l080Altera	:= .T.
	ElseIf nOpcx == 5
		l080Deleta	:= .T.
	EndIf

	//>>Solicitação do Vanderlei - Everson Santana - 12.04.18
/*
	If nOpcx == 8 .and. nopc == 4

		If !__cuserid $ _cAprov

			MSGSTOP( "Usuário não está autorizado a realizar liberação de FATEC."+ Chr(13) + Chr(10) +" Solicite autorização ao Vanderlei.", "Atenção - FATEC" )

			Return

		EndIf

	EndIf
*/
	//<<Solicitação do Vanderlei - Everson Santana - 12.04.18

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura variaveis da Enchoice                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX3")
	DbSetOrder(1)
	SX3->(DbSeek(cString))
	While SX3->(!Eof() .And. (SX3->X3_ARQUIVO == cString))
		If	x3uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			cCampo := SX3->X3_CAMPO
			If	( SX3->X3_CONTEXT == "V"  .Or. Inclui )
				M->&(cCampo) := CriaVar(SX3->X3_CAMPO)
			Else
				M->&(cCampo) := (cString)->(FieldGet(FieldPos(SX3->X3_CAMPO)))
			EndIf
			If (AllTrim(SX3->X3_CAMPO)$ (cVend+"."+cNomVend))
				AAdd(aVisual,SX3->X3_CAMPO)
				If l080Copia
					M->&(cCampo) := Space(SX3->X3_TAMANHO)
				Endif
			EndIf
		EndIf
		//-- Acrescenta no array aCmpUser os campos criados pelo usuario.
		If SX3->X3_PROPRI == 'U' .And. SX3->X3_BROWSE <> 'S'
			AAdd(aCmpUser ,cCampo)
		EndIf
		SX3->(DbSkip())
	EndDo

	//-- Varre o array cCmpUser para definir se os campos de usuarios vao aparecer no aCols ou no aHeader.
	If	Len(aCmpUser) == 0
		AAdd(aVisual,"NOUSER")
	Else
		AEval(aCmpUser,{|x| AAdd(aNoFields,x)})
	EndIf

	//-- Array contendo os campos que nao estarao no aHeader
	AAdd( aNoFields, cNomVend )
	AAdd( aNoFields, cVend )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do AHEADER e ACOLS para GetDados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l080Inclui
		FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
	Else
		If l080Copia
			cSeekDC6 := xFilial(cString)+(cString)->(&cVend)
		Else
			cSeekDC6 := xFilial(cString)+M->&cVend
		EndIf
		cWhile   := cString+'->'+cFilVend+'+'+cString+'->'+cVend

		FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
		nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cGrup)})
		aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
	EndIf

	//-- Dimensoes padroes
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 32, .T., .T. } )
	//AAdd( aObjects, { 200, 200, .T., .T. } )
	AAdd( aObjects, { 100, 23, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	Inclui := ((l080Inclui).Or.(l080Copia)) //-- Impede que a Descrição apaceca na inclusão de itens durante a alteracao

	DEFINE MSDIALOG oDlgEsp TITLE "FATEC" FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a Enchoice                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//EnChoice( "PC1", , If(l080Copia, 3, nOpcx),,,,aVisual, aPosObj[1], , 3, , , , , ,.T. )

	//MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),.T., .T., , !l080Visual,			 , ,    ,9999)
	//ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{||If(.T.,(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()})

	oDlgEsp:lEscClose := .F.
	If nOpcx == 3
		RegToMemory('PC1',.T.)
		M->PC1_NUMERO := PC1->(GetSX8Num("PC1","PC1_NUMERO"))
		PC1->(ConfirmSX8())
	Else
		RegToMemory('PC1',.F.,.T.)
	EndIf
	oEnc:=MsMget():New('PC1',,nOpc,,,,,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]},,,,,,oDlgEsp,,,.F.,nil,,.T.)
	oEnc:oBox:align:= CONTROL_ALIGN_TOP

	oNewGetDados:= MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"U_STFSVLOK(oNewGetDados:nAT)",,/*inicpos*/,,/*freeze*/,200,/*fieldok*/,/*superdel*/,/*delok*/,oDlgEsp,aHeadForm,aColsForm)
	oNewGetDados:oBrowse:bDelete := {|| VldLinDel(oNewGetDados:aCols,oNewGetDados:nAt) }
	oNewGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT		//CONTROL_ALIGN_BOTTOM  //
	aadd(aButtons,{"PMSCOLOR",{||VIEWIMP(aCols,oNewGetDados:nAT)} ,"Impostos" }) //Renato Nogueira - Chamado 000034
	aadd(aButtons,{"PMSCOLOR",{||VIEWIMPP(aCols,oNewGetDados:nAT)},"Imposto por produto" }) //Renato Nogueira - Chamado 000034
	aadd(aButtons,{"PMSCOLOR",{||STESTR05(aCols,oNewGetDados:nAT)},"Imprimir Itens" }) //Renato Nogueira - Chamado 000075
	aadd(aButtons,{"PMSCOLOR",{||STCARITENS(	oNewGetDados:aCols,oNewGetDados:nAT)},"Carregar Itens" }) //Giovani Zago 29/01/14
	aadd(aButtons,{"PMSCOLOR",{||getConfer(	oNewGetDados:aCols,oNewGetDados:nAT)},"Conferência" }) //Giovani Zago 29/01/14

	ACTIVATE DIALOG oDlgEsp ON INIT 	EnchoiceBar(oDlgEsp, {|| IIf(U_STFSVLOK(oNewGetDados:nAT), lret:=Acao(nOpcx), .F.),If(lret,oDlgEsp:End(),0)},{|| oDlgEsp:End()},,aButtons)

	If nOpca == 1 .And. !l080Visual
		If	nOpca == 1
			PC1Grava(nOpcx)
		EndIf
	EndIf

	If nOpcx == 8 .And. !l080Visual //nOpca == 1 .And. !l080Visual //>> Chamado 005890 - Everson Santana - 27.02.2018

		_cEmail	  := _cEmlFatec
		_cAssunto := 'Fatec - '+Alltrim(PC1->PC1_NUMERO)+' - foi autorizada'
		cMsg 	  := "A fatec "+Alltrim(PC1->PC1_NUMERO)+" foi autorizada"

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho) //Renato Nogueira - Chamado 000073 - Enviar e-mail após autorização da fatec.


	EndIf

	RestArea(aAreaAnt)

Return( nOpca )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFSVLOK		  ºAutor  ³Luiz Enrique				º Data ³  28/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacoes para Cada linha da NewGetDados					   			º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function STFSVLOK(nlin)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local cChave		:= ""
	Local cNota			:= ""
	Local nIt

Local nPCQTDDEV	:= GdFieldPos("NQTDDEV",aHeadForm)
Local nPCQTDNOTA := GdFieldPos("NQTDNOTA",aHeadForm)
Local nPCQTDFATEC := GdFieldPos("NQTDFATEC",aHeadForm)

	/*If ! M->PC1_STATUS $ " 1"
	Aviso("Atencao","O Status do atendimento nao permite Edição dos itens!",{"SAIR"},2)
	Return .f.
Endif
	*/

If Empty(oNewGetDados:aCols[nlin ,nPCPRODUTO])
	Aviso("Atencao","Declare o Produto!",{"SAIR"},2)
Return .f.
Endif
If Empty(oNewGetDados:aCols[nlin ,nPCNFSORIGI])
	Aviso("Atencao","Declare a Nota Fiscal!",{"SAIR"},2)
Return .f.
Endif
If Empty(oNewGetDados:aCols[nlin ,nPCSERIEORI])
	Aviso("Atencao","Declare a Serie da Nota!",{"SAIR"},2)
Return .f.
Endif
If Empty(oNewGetDados:aCols[nlin ,nPCITEM])
	Aviso("Atencao","Declare o Numero do Item!",{"SAIR"},2)
Return .f.
Endif

If !ValidNF(nPCNFSORIGI, nPCSERIEORI, nPCPRODUTO, nPCITEM, nPCQTDFATEC, .T., nLin)
	Return .F.
Endif

/*
If oNewGetDados:aCols[nlin, nPCQTDFATEC] > (oNewGetDados:aCols[nlin, nPCQTDNOTA] - oNewGetDados:aCols[nlin, nPCQTDDEV])
	FWAlertInfo("A quantidade FATEC é superior a Quantidade da NF - Quantidade já devolvida")
	Return .F.
End If
*/

cChave:= oNewGetDados:aCols[nlin,nPCNFSORIGI]+oNewGetDados:aCols[nlin,nPCSERIEORI]+oNewGetDados:aCols[nlin,nPCPRODUTO]+oNewGetDados:aCols[nlin,nPCITEM]
cNota := oNewGetDados:aCols[nlin,nPCNFSORIGI]+oNewGetDados:aCols[nlin,nPCSERIEORI]
For nit:= 1 to Len (oNewGetDados:aCols)
	If cChave == 	oNewGetDados:aCols[nit,nPCNFSORIGI]+oNewGetDados:aCols[nit,nPCSERIEORI]+;
			oNewGetDados:aCols[nit,nPCPRODUTO]+oNewGetDados:aCols[nit,nPCITEM] .and. nit <> nlin
		Aviso("Atencao","Item ja declarado como Retorno.",{"SAIR"},2)
		Return .f.
	Endif
		/*
	If !(cNota == oNewGetDados:aCols[nit,nPCNFSORIGI]+oNewGetDados:aCols[nit,nPCSERIEORI]) .and. nit <> nlin
		Aviso("Atencao","Não é permitida mais de uma nota fiscal por FATEC!!.",{"SAIR"},2)
		Return .f.
	Endif
		*/
Next

Return .T.


//Static Function ValidNF(nLinX, nNFX, nSerieX, nProdX, nItemX)
Static Function ValidNF(xNotaX, xSerieX, nProdX, nItemX, nQtdFatecX, lVldItens, nLin)
Local aArea := GetArea()
Local aAreaSD2 := SD2->(GetArea())
Local lRet := .T.
Local nDevolOK := 0
Local nDevolNOK := 0
Local cAlias000 := ""
Local cStmt := ""
Local nSomaDev := 0
Local cFatecs := ""

Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)

Default nProdX := GdFieldPos("CPRODUTO",aHeadForm)
Default nItemX := GdFieldPos("CITEM",aHeadForm)
Default nQtdFatecX := 0
Default nLin := 0

If !ALTERA .And. !INCLUI
	Return .T.
End If

/*
Local nPCQTDDEV	:= GdFieldPos("NQTDDEV",aHeadForm)
Local nPCQTDNOTA := GdFieldPos("NQTDNOTA",aHeadForm)
Local nPCQTDFATEC := GdFieldPos("NQTDFATEC",aHeadForm)
*/

//Validação Devolução por completo
//Caso não venha de aCols
If !lVldItens
	If Empty(xNotaX)
		FWAlertInfo("Favor preencher a Nota Fiscal...")
	ElseIf Empty(xSerieX)
		FWAlertInfo("Favor preencher a Série da Nota Fiscal...")
	Else
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(FWxFilial("SD2") + xNotaX + xSerieX))
			While !SD2->(Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == FWxFilial("SD2") + xNotaX + xSerieX
				If SD2->D2_QUANT == SD2->D2_QTDEDEV
					nDevolOK++
				Else
					nDevolNOK++
				End If
				SD2->(DbSkip())
			End While
		Else
			FWAlertInfo("NF de Origem: " + xNotaX + "/" + xSerieX + ", não encontrada. Verifique !!!")
			lRet := .F.
		End If

		If nDevolNOK == 0
			FWAlertInfo("NF de Origem: " + xNotaX + "/" + xSerieX + ", já devolvida por completo Verifique !!!")
			lRet := .F.
		End If
	End If

	//Validação Devolução do último item caso esteja em outra FATEC
	If !Empty(oNewGetDados:acols[1][1])
		cAlias000 := GetNextAlias()
		cStmt := "SELECT PC1_NUMERO FROM " + RetSqlName("PC1") + " PC1 "
		cStmt += "INNER JOIN " + RetSqlName("PC2") + " PC2 ON PC2_NFATEC = PC1_NUMERO "
		cStmt += "WHERE PC1_NFORIG = '" + oNewGetDados:aCols[Len(aCols) - 1, nPCNFSORIGI] + "' AND PC1_SRORIG = '" + oNewGetDados:aCols[Len(aCols) - 1, nPCSERIEORI] + "' AND PC2_ITEM = '" + oNewGetDados:aCols[Len(aCols) - 1, nPCITEM] + "' AND "
//		cStmt += "WHERE PC1_NFORIG = '" + PADL(AllTrim(xNotaX), 9, "0") + "' AND PC1_SRORIG = '" + PADL(AllTrim(xSerieX), 9, "0") + "' AND PC2_ITEM = '" + nItemX + "' AND "
		cStmt += "PC1.D_E_L_E_T_ = ' ' AND PC2.D_E_L_E_T_ = ' '"
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cStmt),cAlias000,.T.,.T.)
//		If !(cAlias000)->(EOF())
////			FWAlertInfo("O item: " + oNewGetDados:aCols[Len(aCols) - 1, nItemX] + "/" + oNewGetDados:aCols[Len(aCols) - 1, nProdX] + ", já consta na FATEC: " + (cAlias000)->PC1_NUMERO + ". Verifique !!!")
//			FWAlertInfo("O item: " + oNewGetDados:aCols[Len(aCols) - 1, nPCITEM] + "/" + oNewGetDados:aCols[Len(aCols) - 1, nProdX] + ", já consta na FATEC: " + (cAlias000)->PC1_NUMERO + ". Verifique !!!")
//			lRet := .F.
//		End If
		(cAlias000)->(DbCloseArea())
		FErase(cAlias000 + GetDbExtension())
	End If
	//Validação Devolução do último item caso esteja em outra FATEC

//Caso vindo do aCols
Else
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	If SD2->(DbSeek(FWxFilial("SD2") + oNewGetDados:aCols[nLin , xNotaX] + oNewGetDados:aCols[nLin , xSerieX] + M->PC1_CODCLI + M->PC1_LOJA))
		While !SD2->(Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == FWxFilial("SD2") + oNewGetDados:aCols[nLin , xNotaX] + oNewGetDados:aCols[nLin , xSerieX] + M->PC1_CODCLI + M->PC1_LOJA
			If SD2->D2_QUANT == SD2->D2_QTDEDEV
				nDevolOK++
			Else
				nDevolNOK++
			End If
			SD2->(DbSkip())
		End While
	Else
		FWAlertInfo("NF de Origem: " + oNewGetDados:aCols[nLin , xNotaX] + ", não encontrada. Verifique !!!")
		lRet := .F.
	End If
	//Validação Devolução por completo

	//Validação Devolução do item
	If lRet .And. nDevolNOK > 0
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(FWxFilial("SD2") + oNewGetDados:aCols[nLin , xNotaX] + oNewGetDados:aCols[nLin , xSerieX] + M->PC1_CODCLI + M->PC1_LOJA + oNewGetDados:aCols[nLin , nProdX] + oNewGetDados:aCols[nLin , nItemX]))
			If SD2->D2_QUANT == SD2->D2_QTDEDEV
				FWAlertInfo("O item: " + SD2->D2_COD + ", já foi devolvido por completo. Verifique !!!")
				lRet := .F.
			ElseIf (SD2->D2_QUANT - SD2->D2_QTDEDEV) < oNewGetDados:aCols[nLin , nQtdFatecX]
				FWAlertInfo("O item: " + SD2->D2_COD + ", já devolveu: " + cValToChar(SD2->D2_QTDEDEV) + " unidades de: " + cValToChar(SD2->D2_QUANT) + " unidades vendidas" + CRLF;
							+ "Verifique a quantidade FATEC preenchida !!!")
				lRet := .F.
			End If
		Else
			FWAlertInfo("O item: " + oNewGetDados:aCols[nLin , nItemX] + "/" + oNewGetDados:aCols[nLin , nProdX] + ", não foi encontrado na NF de origem. Verifique !!!")
			lRet := .F.
		End If
	Else
		FWAlertInfo("A NF de origem: " + oNewGetDados:aCols[nLin , xNotaX] + ", já foi devolvida por completo. Verifique !!!")
		lRet := .F.
	End If
	//Validação Devolução do item

	//Validação Devolução do item caso esteja em outra FATEC
	If lRet .And. !ISINCALLSTACK("U_STFSVE35")
		cAlias000 := GetNextAlias()
		cStmt := "SELECT PC1_NUMERO, PC1_CODCLI, PC1_LOJA, PC2_QTDNFS, PC2_QTDFAT FROM " + RetSqlName("PC1") + " PC1 "
		cStmt += "INNER JOIN " + RetSqlName("PC2") + " PC2 ON PC2_NFATEC = PC1_NUMERO "
		cStmt += "WHERE PC1_NFORIG = '" + oNewGetDados:aCols[nLin, xNotaX] + "' AND PC1_SRORIG = '" + oNewGetDados:aCols[nLin, xSerieX] + "' AND PC2_ITEM = '" + oNewGetDados:aCols[nLin, nItemX] + "' AND "
		cStmt += "PC1_NUMERO <> '" + M->PC1_NUMERO + "' AND PC1_STATUS <> '5' AND PC1.D_E_L_E_T_ = ' ' AND PC2.D_E_L_E_T_ = ' '"
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cStmt),cAlias000,.T.,.T.)

		While !(cAlias000)->(EOF())
				nSomaDev += (cAlias000)->PC2_QTDFAT
				cFatecs += (cAlias000)->PC1_NUMERO + "/"
			(cAlias000)->(DbSkip())
		End While

		If nSomaDev > 0 .And. SD2->D2_ITEM == oNewGetDados:aCols[nLin, nItemX] .And. (nSomaDev + oNewGetDados:aCols[nLin, nQtdFatecX]) >= SD2->D2_QUANT
			FWAlertInfo("O item: " + oNewGetDados:aCols[nLin, nItemX] + "/" + oNewGetDados:aCols[nLin, nProdX] + ", já consta na(s) FATEC(s): " + cFatecs + ". Verifique !!!")
			lRet := .F.
		End If

		(cAlias000)->(DbCloseArea())
		FErase(cAlias000 + GetDbExtension())
		//Validação Devolução do item caso esteja em outra FATEC
	End If
End If

RestArea(aAreaSD2)
RestArea(aArea)
Return lRet


Static Function PC1Grava(nOpcx)
//nOpcx -> 8 = Autoriza FATEC
	Local nCntFor   := 0
	Local nCntFo1   := 0
	Local nPosCpo   := 0
	Local nItem     := 0
	Local n030Index :=(cString)->(IndexOrd())

	If	nOpcx == 5 			//Excluir
		(cString)->(DbSetOrder(1))
		While (cString)->(DbSeek(xFilial(cString) + M->&cVend ))
			RecLock(cString,.F.)
			(cString)->(DbDelete())
			MsUnLock()
		EndDo
	EndIf

	If	nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx == 6 // Incluir, Alterar ou Copia
		Begin Transaction
			nPosCpo := Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})
			(cString)->(DbSetOrder(1))
			For nCntFor := 1 To Len(aCols)
				If	!aCols[nCntFor,Len(aCols[nCntFor])]
					If	(cString)->(DbSeek(xFilial(cString) + M->&cVend + aCols[nCntFor,nPosCpo] ))
						RecLock(cString,.F.)
					Else
						RecLock(cString,.T.)
					EndIf
					(cString)->&cFilVend  := xFilial(cString)
					(cString)->&cVend     := M->&cVend
					(cString)->&cNomVend  := M->&cNomVend
					(cString)->&cGrup     := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]
					(cString)->&cNomGrup  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]  //FR - TESTE
					(cString)->&cComsVend := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})]

					MsUnLock()
				Else
					If	(cString)->(DbSeek(xFilial(cString) + M->&cVend + aCols[nCntFor,nPosCpo] ))
						RecLock(cString,.F.)
						(cString)->(DbDelete())
						MsUnLock()
					EndIf
				EndIf
			Next

			EvalTrigger()
		End Transaction
	EndIf
	//(cString)->(DbSetOrder(n030Index))

Return NIL




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Acao			  ºAutor  ³Luiz Enrique				º Data ³  28/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acoes de Manutencoes												   			º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Acao(nOpcx)

	Local lret:= .t.
	Local cOpc:= Alltrim(Str(nOpcx))

	If cOpc $ "34789"				// Inclusao - ALteracao - Encerramento QG - Autorizacao
		MsgRun("Gravando",,{|| lret:=GravaFatec(nOpcx)})
	ElseIf cOpc == "5"			// Exclusao
		Return EXCFATEC()
	Endif

Return lret
/*
Static Function MenuDefPC1()

PRIVATE aRotina	 := {	{ "Pesquisar" ,"AxPesqui"    ,0 ,1 ,0 ,.F.},;  //"Pesquisar"
{ "Visualizar" ,"AxVisual" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
{ "Incluir" ,"u_XSTFSVE32(3)" ,0 ,3 ,0 ,Nil},;  //"Incluir"
{ "Alterar" ,"u_XSTFSVE32(4)" ,0 ,4 ,0 ,Nil},;  //"Alterar"
{ "Excluir" ,"u_XSTFSVE32(5)" ,0 ,5 ,0 ,Nil}}  //"Excluir"


Return(aRotina)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GravaFatec	  ºAutor  ³Luiz Enrique				º Data ³  28/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava atendimento FATEC - PC1 e PC2							   			º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravaFatec(nOpcx)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local nPNROP		:= GdFieldPos("CNROP",aHeadForm)
	Local nPNQTDDEV	    := GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD",aHeadForm)
	Local nPCDSCPROD	:= GdFieldPos("CDSCPROD",aHeadForm)
	Local nPCOBSFATEC	:= GdFieldPos("COBSFATEC",aHeadForm)

	Local lret		:=.t.
	Local nIt
	Local aUserAtu	:={}
	Local cColab

	//>> Chamado 005890 - Everson Santana - 27.02.2018
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg	     := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cFatecNot:= SuperGetMV("ST_FATECNT",,"")
	Local _cFatecVlr:= SuperGetMV("ST_FATECVR",,"")
	Local _cFatecDir:= SuperGetMV("ST_FTECDIR",,"")
	Local _cFatecVld:= SuperGetMV("ST_FTECVRD",,"")
	Local _totvTot  := 0
	//<< Chamado 005890

	PswOrder(1)
	If PswSeek( __cUSERID, .T. )
		aUserAtu := PswRet()
		cColab   := aUserAtu[1,4]
	Endif

	If Empty(M->PC1_CODCLI)
		MsgAlert("Declare o Codigo do Cliente!")
		Return .f.
	Endif
	If Empty(M->PC1_LOJA)
		MsgAlert("Declare a Loja!")
		Return .f.
	Endif
	If Empty(M->PC1_CONTAT)
		MsgAlert("Declare o Contato!")
		Return .f.
	Endif
	If Empty(M->PC1_ATENDE)
		MsgAlert("Declare o Atendente!")
		Return .f.
	Endif
	If Empty(M->PC1_MOTIVO)
		MsgAlert("Declare o Motivo!")
		Return .f.
	Endif

	//Se a Opcao de Devolução esta NAO, pergunta se elimina os itens relacionados
	//If!ExcItens()
	//	Return .f.
	//Endif

	If Len(oNewGetDados:aCols) >= 1 .And. !Empty(oNewGetDados:aCols[1,nPCPRODUTO])
		For nIt:= 1 to Len(oNewGetDados:aCols)
			If Empty(oNewGetDados:aCols[nIt ,nPNQTDFATEC])
				MsgAlert("Existe quantidade de devolucao nao declarada!")
				lret:=.f.
				oNewGetDados:nAt:= nIt
				exit
				/*
			Else
				If !STVLDPC2(oNewGetDados:aCols[nIt ,nPCNFSORIGI],oNewGetDados:aCols[nIt ,nPCSERIEORI],oNewGetDados:aCols[nIt ,nPCITEM],;
				oNewGetDados:aCols[nIt ,nPNQTDNOTA],oNewGetDados:aCols[nIt ,nPNQTDFATEC],oNewGetDados:aCols[nIt ,nPCPRODUTO])
				lret:=.f.
				oNewGetDados:nAt:= nIt
				exit
					EndIf
				*/
			Endif
		Next
	Endif

	If Len(oNewGetDados:aCols) == 1 .And. Empty(oNewGetDados:aCols[1,nPCPRODUTO]) .and. M->PC1_DEVMAT ==  "1"
		MsgAlert("Considerando atendimento com devolução, é necessário declarar os itens retornados!")
		Return .f.
	Endif

	If nOpcx==7		//Verifica ENCERRA CQ

		//Felipe Santos - 25/03/2013
		//Removida validação pois já está sendo efetuado o encerramento
		//de FATEC com motivos menores que 500
		/*If M->PC1_MOTIVO < "500"
		MsgAlert("O Motivo declarado não permite o Encerramento!")
		Return .f.
	Endif
		*/
	If M->PC1_STATUS == "5"
		MsgAlert("Encerramento já realizado!")
		Return .f.
	ElseIf M->PC1_STATUS $ "1/4"
		MsgAlert("Encerramento do GQ não permitido!")
		Return .f.
	Endif
	If Empty(M->PC1_OBSCQ)
		MsgAlert("Para encerramento do GQ, é necessário a observação!")
		Return .f.
	Endif

	M->PC1_OBSCQ+= CRLF + "Encerrado por: " + cColab + CRLF + DTOC(dDataBase)+" - "+Time()
	M->PC1_STATUS:= "5"	//	Encerrado

ElseIf nOpcx==8	//Verifica AUTORIZACAO
	If M->PC1_STATUS $ "2/3"
		MsgAlert("Autorização/Recebimento já realizado!")
		Return .f.
	ElseIf M->PC1_STATUS == "5"
		MsgAlert("Nao pode ser Autorizado, Atendimento já encerrado!")
		Return .f.
		//>> Chamado 005890 - Everson Santana - 27.02.2018
	ElseIf M->PC1_STATUS == "0"
		MsgAlert("Está FATEC ainda está em processo de Elaboração,"+ CRLF +" portanto não poderá ser Autorizada!")
		Return .f.
		//>> Chamado 005890 - Everson Santana - 27.02.2018
	Endif
	M->PC1_OBS+= CRLF + "Autorizado por: " + cColab + CRLF + DTOC(dDataBase)+" - "+Time()
	M->PC1_STATUS:= "2"	//	Autorizado

	_cEmail := SuperGetMv("ST_FSVE30",.F.,"renato.oliveira@steck.com.br;marcelo.oliveira@steck.com.br")

	_totvTot := VIEWTOT(aCols,oNewGetDados:nAT)

	WFNOTIF(_cEmail,cColab,_totvTot)

ElseIf nOpcx==9

	//>> Chamado 005890 - Everson Santana - 27.02.2018

	_totvTot := VIEWTOT(aCols,oNewGetDados:nAT)

	If _totvTot >= _cFatecVlr //Valor para ser notificado a Diretoria Comercial

		If _totvTot >= _cFatecVld //Valor para ser notificado a Diretoria Geral
			_cEmail	  := _cFatecNot+";"+_cFatecDir
		Else
			_cEmail	  := _cFatecNot
		EndIf

		//WFNOTIF(_cEmail,cColab,_totvTot)

	EndIf
	//<< Chamado 005890

	M->PC1_OBS+= CRLF + "Liberado por: " + cColab + CRLF + DTOC(dDataBase)+" - "+Time()
	M->PC1_STATUS:= "1"	//	Aberto
Endif

// GRAVA ATENDIMENTO
If lret
	Begin Transaction
		GravaPc1()
		If nOpcx <> 9
			GravaPc2(nOpcx)
		EndIf
//		ConfirmSX8()
	End Transaction
Endif

Return lret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GravaPC1  ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava Cabecalho da Ocorrencia PC1							        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static function GravaPC1()

	Local cStatus := ""
	Local cMsg := "Fatec não será analisada pela CQ e será encerrada"
	Local _lInc := .F.



	PC1->(DbSetOrder(1))
	If ! PC1->(DBSeek(xFilial("PC1")+M->PC1_NUMERO))
		RecLock("PC1",.t.)
		_lInc := .T.
	Else
		RecLock("PC1",.f.)
	EndIf

	//FELIPE SANTOS - TOTVS - 25/03/2013
	//REGRA PARA ENCERRAMENTO DE FATEC SEM PASSAR PELO CQ
	IF(M->PC1_STATUS == "2" .AND. M->PC1_DEVMAT = "2" .AND. M->PC1_MOTIVO < "500")
		cStatus := "5"
		MsgAlert(cMsg)
	ELSEIF (M->PC1_STATUS == "3" .AND. M->PC1_DEVMAT = "1" .AND. M->PC1_MOTIVO < "500")
		cStatus := "5"
		MsgAlert(cMsg)
	ELSE
		cStatus:= M->PC1_STATUS
	ENDIF



	PC1->PC1_FILIAL	:= xFilial("PC1")
	PC1->PC1_NUMERO	:= M->PC1_NUMERO
	PC1->PC1_STATUS	:= cStatus
	PC1->PC1_NOTAE	:=	M->PC1_NOTAE
	PC1->PC1_SERIEE	:=	M->PC1_SERIEE
	PC1->PC1_CODCLI	:=	M->PC1_CODCLI
	PC1->PC1_NOMCLI	:=	M->PC1_NOMCLI
	PC1->PC1_LOJA	:=	M->PC1_LOJA
	PC1->PC1_CONTAT	:=	M->PC1_CONTAT
	PC1->PC1_ATENDE	:=	M->PC1_ATENDE
	PC1->PC1_MOTIVO	:=	M->PC1_MOTIVO
	PC1->PC1_REPOSI	:=	M->PC1_REPOSI
	PC1->PC1_DEVMAT	:=	M->PC1_DEVMAT
	PC1->PC1_DTOCOR	:=	M->PC1_DTOCOR
	PC1->PC1_PEDREP	:=	M->PC1_PEDREP
	PC1->PC1_NFDEV  := 	M->PC1_NFDEV        // Valdemir Rabelo Ticket: 20210408005632
	
	//----------------------------------------------------------------------------------------------------//
	//FR - 29/07/2022 - MELHORIA FATEC Ticket #20220325006576 - Solicitado por Rosa Santos
	//este campo recebe "Sim" ou "Não" para Recolocação de Pedido de Venda, se Sim, ao aprovar a Fatec
	//será criado um pedido de venda via Execauto com os itens da Fatec
	//----------------------------------------------------------------------------------------------------//
	If FieldPos("PC1_RECPV") > 0
		PC1->PC1_RECPV  :=  M->PC1_RECPV		
	Endif 

	If _lInc
		PC1->PC1_CODUSR	:= __cUserId
	EndIf

	MSMM( PC1->PC1_CODOBS, 80,, M->PC1_OBS, 1,,, "PC1", "PC1_CODOBS" )
	MSMM( PC1->PC1_CODCQ, 80,, M->PC1_OBSCQ, 1,,, "PC1", "PC1_CODCQ" )

	PC1->(MsUnLock())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GravaPC2  ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava Itens da Nota de Saida na Ocorrencia PC2		        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static function GravaPC2(nOpcx)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local nPNROP		:= GdFieldPos("CNROP",aHeadForm)
	Local nPNQTDDEV	:= GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD",aHeadForm)
	Local nPCDSCPROD	:= GdFieldPos("CDSCPROD",aHeadForm)
	Local nPCOBSFATEC	:= GdFieldPos("COBSFATEC",aHeadForm)

	Local cOpc		:= Alltrim(Str(nOpcx))
	Local cChave	:= xFilial("PC2") + M->PC1_NUMERO
	Local nNunFatec:= PC1->PC1_NUMERO
	Local nIt
	Local _cNota    := ""
	Local _cSerie   := ""
	Local nTotal    := 0
	Local lRecPV    := .F.
	Local _cTipoCli := ""
	Local cItem     := ""
	Local CC5XORDEM := ""
	Local CC5PEDORI := ""
	Local CC5TRANSP := ""
	Local aCabec    := {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local nItemPV   := 0
	
	//-------------------------------------------------------------------------------------//
	//FR - 29/07/2022 - Flávia Rocha - Sigamat Consultoria - MELHORIA FATEC
	//Alterações realizadas mediante Ticket #20220325006576 - Solicitado por Rosa Santos
	//Ao liberar uma Fatec onde haja necessidade de se recolocar o pedido de venda, 
	//criar este pedido de venda automaticamente
	//neste caso será criado se o campo PC1_RECPV estiver com o conteúdo = "S" (Sim) 
	//-------------------------------------------------------------------------------------//
	If nOpcx == 8  //só na aprovação

		If FieldPos("PC1_RECPV") > 0  //se existe o campo

			If PC1->PC1_RECPV == "S"
				If !Empty(PC1->PC1_RECPVN)  //verifica se já tem pedido de venda gerado para esta Fatec
					
					SC5->(OrdSetfocus(1))
					If !SC5->(Dbseek(xFilial("SC5") + PC1->PC1_RECPVN ))

						lRecPV := .T.  //se não encontrar o pedido q tá no PC1_RECPVN deixa recolocar direto

					Else				//se encontrar, checa os campos abaixo

						If ('XXXX' $ C5_NOTA) .And. (C5_ZFATBLQ $ '1/2') 
						//"Pedido de Venda Eliminado por Resíduo (Saldo)....!!!!!!"						
							lRecPV := .T.
						Endif

						If ('XXXX' $ C5_NOTA) .And. (C5_ZFATBLQ = '3' .Or. Empty(Alltrim(C5_ZFATBLQ))) 
						//msgiNFO("Pedido de Venda Cancelado....!!!!!!"						
							lRecPV := .T.
						Endif

						If SC5->C5_ZFATBLQ = '1'
						//msgiNFO("Pedido de Venda Faturado Totalmente....!!!!!!"
							lRecPV := .F.
						Endif  
						
						If !lRecPV
							Alert("Pedido de Venda já Criado: " + SC5->C5_NUM)
						Endif 

					Endif 
				Else 
					lRecPV := .T.
				Endif 

				If lRecPV
					//---------------------//
					//PREPARA CABEÇALHO:
					//---------------------//
								
					aCabec  := {}
					aItens	:= {}
					aLinha	:= {}

					cFili   := xFilial("SC5")

					cC5NUM := GetSxeNum("SC5", "C5_NUM")

					SC5->(OrdSetFocus(1))
					While SC5->( DbSeek( xFilial( "SC5" ) + cC5NUM ) )
						ConfirmSX8()   
						cC5NUM := SOMA1(cC5NUM)
					Enddo

					aadd(aCabec,{"C5_FILIAL"  ,	xFilial("SC5")	,Nil})  //não precisa
								
					AADD(aCabec,{"C5_NUM" 	  ,cC5NUM  			,Nil})
					AADD(aCabec,{"C5_TIPO"    ,	"N"       		,Nil})      //Tipo pedido: N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=Utiliza Fornecedor	 

					AADD(aCabec,{"C5_CLIENTE" ,	PC1->PC1_CODCLI ,Nil})	
					AADD(aCabec,{"C5_LOJACLI" ,	PC1->PC1_LOJA   ,Nil})
					AADD(aCabec,{"C5_LOJAENT" ,	PC1->PC1_LOJA   ,Nil})

					SA1->(OrdSetFocus(1))
					_cTipoCli := POSICIONE("SA1",1,XFILIAL("SA1") + PC1->PC1_CODCLI + PC1->PC1_LOJA, "A1_TIPO")

					AADD(aCabec,{"C5_TIPOCLI" ,	_cTipoCli  		,Nil})		//Tipo de cliente: F=Cons.Final;L=Prod.Rural;R=Revendedor;S=Solidario;X=Exportacao/Importacao				 
					
				Endif 
			Endif

		Endif  //se existe o campo PC1_RECPV

	Endif 	//If nOpcx == 8  //só na aprovação
	//FR - 29/07/2022 - só cria este cabeçalho do pedido de venda na aprovação da Fatec

	PC2->(DbSetOrder(2))

	If cOpc $ "478" 	// Alteracao - Encerramento QG - Autorizacao
		//PC2->(DBSeek(cChave))
		PC2->(DbSeek(xFilial('PC2')+ ALLTRIM(cChave)))
		WHILE PC2->(!Eof() .and. xFilial('PC2 ') == PC2_FILIAL .And. nNunFatec == PC1->PC1_NUMERO .And. nNunFatec == PC2->PC2_NFATEC)
			PC2->(RecLock("PC2",.F.))
			PC2->(DBDelete())
			PC2->(MSUnlock())
			PC2->(dbSkip())
		Enddo
	Endif

	nTotal := 0
	nItemPV:= 0  //FR - 29/07/2022 - Flávia Rocha - Sigamat Consultoria - MELHORIA FATEC
				//Alterações realizadas mediante Ticket #20220325006576 - Solicitado por Rosa Santos

	For nIt:= 1 to Len(oNewGetDados:aCols)
		RecLock("PC2",.t.)
		PC2->PC2_FILIAL := xFilial("PC2")
		PC2->PC2_NFATEC := M->PC1_NUMERO
		PC2->PC2_PRODUT := oNewGetDados:aCols[nIt ,nPCPRODUTO]
		PC2->PC2_DESPRO := oNewGetDados:aCols[nIt ,nPCNOMEPROD]
		PC2->PC2_NFORIG := oNewGetDados:aCols[nIt ,nPCNFSORIGI]
		PC2->PC2_SERIE  := oNewGetDados:aCols[nIt ,nPCSERIEORI]
		PC2->PC2_ITEM   := oNewGetDados:aCols[nIt ,nPCITEM]
		PC2->PC2_QTDNFS := oNewGetDados:aCols[nIt ,nPNQTDNOTA]
		PC2->PC2_QTDFAT := oNewGetDados:aCols[nIt ,nPNQTDFATEC]
		PC2->PC2_NROP   := oNewGetDados:aCols[nIt ,nPNROP]
		PC2->PC2_QTDDEV := oNewGetDados:aCols[nIt ,nPNQTDDEV]
		PC2->PC2_GRPPRO := oNewGetDados:aCols[nIt ,nPCGRPPROD]
		PC2->PC2_DSCPRO := oNewGetDados:aCols[nIt ,nPCDSCPROD]
		PC2->PC2_OBSER  := oNewGetDados:aCols[nIt ,nPCOBSFATEC]
		PC2->(MsUnLock())

		if Empty(_cNota) .and. !Empty(PC2->PC2_NFORIG)
		  _cNota    := PC2->PC2_NFORIG
		  _cSerie   := PC2->PC2_SERIE
		Endif

		nTotal += CalcFatec(nIt)

		//-------------------------------------------------------------------------------------//
		//FR - 29/07/2022 - Flávia Rocha - Sigamat Consultoria - MELHORIA FATEC
		//Alterações realizadas mediante Ticket #20220325006576 - Solicitado por Rosa Santos
		//Ao liberar uma Fatec onde haja necessidade de se recolocar o pedido de venda, 
		//criar este pedido de venda automaticamente
		//neste caso será criado se o campo PC1_RECPV estiver com o conteúdo = "S" (Sim) 
		//-------------------------------------------------------------------------------------//
		If nOpcx == 8  //só na aprovação
			CC5XORDEM := ""
			If lRecPV
				
				nItemPV++
				//prepara itens:
				cItem := Strzero(nItemPV,2)  
				
				//seek na SD2 pra pegar o pedido de venda e dele tirar a condição pagto, tipo frete
				SD2->(OrdSetFocus(3))  			//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				If SD2->(Dbseek(xFilial("SD2") + oNewGetDados:aCols[nIt ,nPCNFSORIGI] + oNewGetDados:aCols[nIt ,nPCSERIEORI] +;
					PC1->PC1_CODCLI + PC1->PC1_LOJA + oNewGetDados:aCols[nIt ,nPCPRODUTO] + oNewGetDados:aCols[nIt ,nPCITEM]))					

					If Empty(CC5PEDORI) 
						CC5PEDORI := SD2->D2_PEDIDO
					Endif

					AADD(aLinha,{"C6_FILIAL" 	,XFILIAL("SC6")		,NIL})
					AADD(aLinha,{"C6_ITEM" 		,cItem				,NIL})
					AADD(aLinha,{"C6_PRODUTO"	,oNewGetDados:aCols[nIt ,nPCPRODUTO]	,NIL})		
					AADD(aLinha,{"C6_QTDVEN" 	,oNewGetDados:aCols[nIt ,nPNQTDFATEC]	,NIL}) 
					AADD(aLinha,{"C6_PRCVEN"	, SD2->D2_PRCVEN	,NIL})	
					AADD(aLinha,{"C6_PRUNIT"	, SD2->D2_PRCVEN	,NIL})									
					AADD(aLinha,{"C6_TES"   	, SD2->D2_TES	,NIL})
					AADD(aLinha,{"C6_CF"   		, SD2->D2_CF	,NIL})
					//AADD(aLinha,{"C6_VALOR"	,nTotal			,NIL})	
				 
					
					AADD(aItens, aLinha)
					aLinha := {}	

					//complementa cabeçalho: 
					SC5->(OrdSetFocus(1)) 
					SC5->(Dbseek(xFilial("SC5")+ SD2->D2_PEDIDO))
					If !Empty(SC5->C5_XORDEM)
						CC5XORDEM := SC5->C5_XORDEM	
						CC5TRANSP := SC5->C5_TRANSP				
					Endif

				Endif 
			Endif
		Endif  
		//FR - 29/07/2022 - adicionar aqui os itens para recolocação do PEDIDO DE VENDA caso PC1_RECPV = "S"

	Next

	If nOpcx == 8  //só na aprovação
		If lRecPV
			//complementa cabeçalho: 
			SC5->(OrdSetFocus(1)) 
			SC5->(Dbseek(xFilial("SC5")+ CC5PEDORI))

			AADD(aCabec,{"C5_CONDPAG" ,	SC5->C5_CONDPAG ,Nil})
			AADD(aCabec,{"C5_ZCONDPG" ,	SC5->C5_ZCONDPG ,Nil})
			AADD(aCabec,{"C5_TPFRETE" ,	SC5->C5_TPFRETE ,Nil})	
			AADD(aCabec,{"C5_XTIPF"   ,	SC5->C5_XTIPF ,Nil})	
			AADD(aCabec,{"C5_XTIPO"   ,	SC5->C5_XTIPO ,Nil})
			If !Empty(CC5XORDEM)	
				AADD(aCabec,{"C5_XORDEM",CC5XORDEM ,Nil})	
			Else
				AADD(aCabec,{"C5_XORDEM","." ,Nil})	
			Endif
			AADD(aCabec,{"C5_TRANSP"   	, CC5TRANSP ,Nil})
			
		Endif 
	Endif  

	// Valdemir Rabelo - 14/05/2021 - Ticket: 20210408005632
	RecLock("PC1", .f.)
	if Empty(PC1->PC1_NFORIG)
		PC1->PC1_NFORIG := _cNota
		PC1->PC1_SRORIG := _cSerie
	Endif
	PC1->PC1_TOTAL := nTotal
	MsUnlock()
	// ---------------
	aColsForm:={}
	oNewGetDados:Refresh()

	//CHAMA EXECAUTO PARA RECOLOCAR PEDIDO DE VENDA (CASO ESTEJA FLAG = SIM)
	//FR - 29/07/2022 - recolocação do PEDIDO DE VENDA caso PC1_RECPV = "S"
	If nOpcx == 8  //só na aprovação
		If lRecPV			
			lEnd := .F.
			Processa({|lEnd| RecPV(aCabec,aItens) } ,"Processando...","Recolocação do Pedido de Venda...",.T.)
		Endif 
	Endif 
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Excfatec  ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³EXCLUI O Processo de Atendimento FATEC (PC1) 				     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Excfatec()

	Local lReturn := .T.
	Local nNunFatec
	Local aMsgs		:= {	"ATENÇÃO !!!",;
		"Este procedimento irá efetuar a eliminação do Atendimento FATEC: " + PC1->PC1_NUMERO,;
		"Confirma realizar esta operção ?"}
	Local aButtons	:= {	{1,.T.,{|| nOpca := 1, FechaBatch()}},;
		{2,.T.,{|| nOpca := 0, FechaBatch()}}}
	Local nOpca


	IF(M->PC1_STATUS == "5" .OR. M->PC1_STATUS == "3")
		MsgAlert("Fatec não poderá ser excluida quando seu status for Recebido ou Encerrada")
		lReturn := .F.
	ENDIF

	IF(lReturn)

		FormBatch( "Exclusao do Atendimento FATEC", aMsgs, aButtons,, 200, 500 )
		If nOpca == 0
			Return .f.
		EndIf

		Begin Transaction
			//Apaga linhas dos Itens das Notas conforme Atendimento
			PC2->(DbSetOrder(1))
			PC2->(DbSeek(xFilial('PC2')+PC1->PC1_NUMERO))
			nNunFatec:=PC1->PC1_NUMERO

			While PC2->(!Eof() .and. xFilial('PC2 ') == PC2_FILIAL .And. nNunFatec == PC1->PC1_NUMERO .And. nNunFatec == PC2->PC2_NFATEC)
				PC2->(RecLock("PC2",.F.))
				PC2->(DBDelete())
				PC2->(MSUnlock())
				PC2->(dbSkip())
			Enddo
			//Apaga Cabecalho do Atendimento
			PC1->(RecLock("PC1",.F.))
			PC1->(DBDelete())
			PC1->(MSUnlock())
		End Transaction
	ENDIF

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ExcItens  ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³EXCLUI somente os Itens do Processo de Atendimento FATEC PC2³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExcItens()

	Local nPCPRODUTO	:= aScan(aHeadFatec, {|x| Upper(AllTrim(x[2])) == "CPRODUTO"})

	Local nit
	Local aMsgs		:= {	"ATENÇÃO !!!",;
		"Descosiderando a devolução de Materiais para o Atendimento FATEC: " + PC1->PC1_NUMERO, ;
		"não justifica a relação dos itens apresentados na lista."," ",;
		"Confirma Realizar a exclusão destes itens ?"}
	Local aButtons	:= {	{1,.T.,{|| nOpca := 1, FechaBatch()}},;
		{2,.T.,{|| nOpca := 0, FechaBatch()}}}
	Local nOpca

	If M->PC1_STATUS <> "4" .Or. (Len(oNewGetDados:aCols) == 1 .And. Empty(oNewGetDados:aCols[1,nPCPRODUTO]))
		Return .t.
	Endif

	FormBatch( "Exclusão dos Itens relacionados - FATEC", aMsgs, aButtons,, 200, 500 )
	If nOpca == 0
		Return .f.
	EndIf

	For nIt:= 1 to Len(oNewGetDados:aCols)
		aDel(oNewGetDados:aCols,nIt)
	Next
	aSize(oNewGetDados:aCols,0)

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldLinDel  ºAutor  ³Luiz Enrique				º Data ³  05/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do DELETE de linhas do MsNewGetDados	  			  		º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldLinDel(aCols,nPosAtu)
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPos
	Local cMsg

	Local cChave:= xFilial("PC2") + 	M->PC1_NUMERO +	Padr(oNewGetDados:aCols[nPosAtu,nPCNFSORIGI],09)	+;
		Padr(oNewGetDados:aCols[nPosAtu,nPCSERIEORI],03)	+;
		Padr(oNewGetDados:aCols[nPosAtu,nPCPRODUTO],15)	+;
		Padr(oNewGetDados:aCols[nPosAtu,nPCITEM],02)
	//FELIPE SANTOS - TOTVS - 25/03/2013
	//REMOVIDA VALIDAÇÃO PARA INCLUSÃO DE MAIS DE 1 ITEM NA MESMA FATEC
	/*If ! M->PC1_STATUS $ " 1"
	MsgAlert("O Status do atendimento nao permite exclusão de itens!")
	Return .f.
Endif
	*/

cMsg:= 								Alltrim(oNewGetDados:aCols[nPosAtu,nPCPRODUTO])+ CRLF
cMsg+= "Item: " + 				Alltrim(oNewGetDados:aCols[nPosAtu,nPCITEM])+ CRLF
cMsg+= "da Nota Fiscal: " + 	Alltrim(oNewGetDados:aCols[nPosAtu,nPCNFSORIGI])+ " - " + oNewGetDados:aCols[nPosAtu,nPCSERIEORI] + CRLF
If !MsgYesNo("Confirma excluir o " + cMsg + " da lista","Exclusão")
Return .f.
Endif

nPos := Ascan(oNewGetDados:aCols,{|x| x[nPCPRODUTO]+x[nPCNFSORIGI]+x[nPCSERIEORI]+x[nPCITEM] == (	oNewGetDados:aCols[nPosAtu,nPCPRODUTO]+;
	oNewGetDados:aCols[nPosAtu,nPCNFSORIGI]+;
	oNewGetDados:aCols[nPosAtu,nPCSERIEORI]+;
	oNewGetDados:aCols[nPosAtu,nPCITEM])})
If nPos > 0
	aDel(oNewGetDados:aCols,nPos)
	aSize(oNewGetDados:aCols,Len(oNewGetDados:aCols)-1)
Endif
oNewGetDados:Refresh()

Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetHeaderForm ºAutor  ³Luiz Enrique				º Data ³  28/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega o Header dos formularios								   			º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetHeaderForm()

	Local aHeaderTMP := {}

	//ATENCAO: 	Caso for necessario alterar a ordem dos campos abaixo, altere tambem a CONSULTA PADRAO "SD2FSW"
	//				Pois a mesma esta gatilhando dados para campos subsequentes: Nf->Serie->Item->Produto->Decricao->grupo->Quantidade

	AADD(aHeaderTMP,{ "NFS Original"		,"cNfsOrigi" 	,"@!"					,09,0,								,,"C","SD2FSW"	,"","",	,"M->PC1_STATUS $ ' 014'"})
	AADD(aHeaderTMP,{ "Serie"				,"cSerieOri" 	,"@!"					,03,0,"U_FSV30NFS()"				,,"C",""			,"","",	,"M->PC1_STATUS $ ' 014'"})
	AADD(aHeaderTMP,{ "Item"				,"cItem" 		,"@!"					,02,0,"U_FSV30VI()"				,,"C",""			,"","",	,"M->PC1_STATUS $ ' 014'"})
	AADD(aHeaderTMP,{ "Produto"				,"cProduto"		,"@!"    				,15,0,"U_FSV30VP(cProduto)"	,,"C","SB1"		,"","","","M->PC1_STATUS $ ' 014'"})
	AADD(aHeaderTMP,{ "Descricao Produto"	,"cNomeProd"	,"@!"    				,30,0,								,,"C",""			,"","","",".F."})
	AADD(aHeaderTMP,{ "Grupo Produto"		,"cGrpProd" 	,"@!"					,04,0,								,,"C",""			,"","",	,".F."})
	AADD(aHeaderTMP,{ "Desc. Grupo Produto"	,"cDscProd" 	,"@!"					,30,0,						,,"C",""			,"","",	,".F."})
	AADD(aHeaderTMP,{ "Qtd da Nota"			,"nQtdNota" 	,"@E 999,999,999.99"	,11,2,								,,"N",""			,"","",	,".F."})
	AADD(aHeaderTMP,{ "Devolucao"			,"nQtdDev" 		,"@E 999,999,999.99"	,11,2,								,,"N",""			,"","",	,".F."})
	AADD(aHeaderTMP,{ "Qtd FATEC"			,"nQtdFatec" 	,"@E 999,999,999.99"	,11,2,"U_FSV30VQ()"		  		,,"N",""			,"","",	,"M->PC1_STATUS $ ' 014'"})
	AADD(aHeaderTMP,{ "Nr. OP"				,"cNrOP" 		,"@!"					,20,0,						  		,,"C",""			,"","",	,".T."})
	AADD(aHeaderTMP,{ "Obs Item"			,"cObsFatec" 	,"@!"					,100,0,						  		,,"C",""			,"","",	,".T."})

Return aClone( aHeaderTMP )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetColsForm   ºAutor  ³ Lufiz Enrique        º Data ³ 05/11/09 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega o aCols dos formularios								   	   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetColsForm(nOpcx)
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO"		,aHeadForm)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD"	,aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI"	,aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI"	,aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM"		,aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA"		,aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC"	,aHeadForm)
	Local nPCNROP		:= GdFieldPos("CNROP"  		,aHeadForm)
	Local nPNQTDDEV	:= GdFieldPos("NQTDDEV"		,aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD"		,aHeadForm)
	Local nPCDSCPROD	:= GdFieldPos("CDSCPROD"		,aHeadForm)
	Local nPCOBSFATEC	:= GdFieldPos("COBSFATEC"	,aHeadForm)

	Local aColstmp := {}
	Local aColsAux := {}

	If nOpcx == 3 // Inclusao
		AADD(aColsTMP,Array(Len(aHeadForm)+1))
		aColsTMP[1,nPCPRODUTO] 	:= Space(15)
		aColsTMP[1,nPCNOMEPROD]	:= Space(30)
		aColsTMP[1,nPCNFSORIGI]	:= Space(09)
		aColsTMP[1,nPCSERIEORI]	:= Space(03)
		aColsTMP[1,nPCITEM]     := Space(02)
		aColsTMP[1,nPNQTDNOTA] 	:= 0
		aColsTMP[1,nPNQTDFATEC]	:= 0
		aColsTMP[1,nPCNROP]		:= Space(20)
		aColsTMP[1,nPNQTDDEV] 	:= 0
		aColsTMP[1,nPCGRPPROD]	:= Space(04)
		aColsTMP[1,nPCDSCPROD]	:= Space(50)
		aColsTMP[1,nPCOBSFATEC]	:= Space(120)
		aColsTMP[1,Len(aColsTMP[1])]	:= .F.
	Else
		PC2->(dbSetOrder(1))
		PC2->(dbSeek(xFilial("PC2")+PC1->PC1_NUMERO))
		While PC2->(!EOF()) 	.and. xFilial('PC2')  == PC2->PC2_FILIAL 	.and. PC2->PC2_NFATEC == PC1->PC1_NUMERO

			aColsAux := Array(13)
			aColsAux[nPCPRODUTO] 	:=  PC2->PC2_PRODUT
			aColsAux[nPCNOMEPROD]	:=  PC2->PC2_DESPRO
			aColsAux[nPCNFSORIGI]	:=	PC2->PC2_NFORIG
			aColsAux[nPCSERIEORI]	:=	PC2->PC2_SERIE
			aColsAux[nPCITEM]		:=	PC2->PC2_ITEM
			aColsAux[nPNQTDNOTA]	:=	PC2->PC2_QTDNFS
			aColsAux[nPNQTDFATEC]	:=	PC2->PC2_QTDFAT
			aColsAux[nPCNROP]  		:=	PC2->PC2_NROP
			aColsAux[nPNQTDDEV]		:=	PC2->PC2_QTDDEV
			aColsAux[nPCGRPPROD]	:=	PC2->PC2_GRPPRO
			aColsAux[nPCDSCPROD]	:=	PC2->PC2_DSCPRO
			aColsAux[nPCOBSFATEC]	:=  PC2->PC2_OBSER
			aColsAux[13]	:= .F.

			aadd(aColstmp,aClone(aColsAux))
			PC2->(dbSkip())
		Enddo
	Endif

Return aClone(aColsTMP)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ENCLEGEN  ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Legenda para o Processo de Transferencia Automatica         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
User Function ENCLEGEN()

	Local aLegenda :={{ 'BR_AZUL' , 'Em Elaboração'},;
		                 {'BR_AMARELO'                 , 'Em Aberto'},;
		                 {'BR_VERDE'                   , 'Autorizado comercial / Pendente fiscal'},;
		                 {'BR_PRETO'                   , 'Atendimento sem Devolução'},;
		                 {'BR_LARANJA'                 , 'Pendente Recebimento'},;
		                 {'BR_CINZA'                   , 'Recebido Fisicamente'},;
		                 {'BR_PINK'                    , 'Recebido Classificada'},;
		                 {'BR_VERMELHO'                , 'Encerrado' }}


	BrwLegenda("Processo de Atendimento FATEC","Legenda",aLegenda)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³IsFunc		³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Veifica Pilha das Chamdas de Funções					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function IsFunc(aRotinas)
	Local lRet := .f.
	Local nX

	For nX:=1 to Len(aRotinas)
		If IsInCallStack(aRotinas[nX])
			lRet := .t.
			Exit
		Endif
	Next

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FSV30VQ    ³ Autor ³ Luiz Enrique     	  ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Quantidade digitada para FATEC.							  ³±±
±±³			 ³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK	                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FSV30VQ()

	Local _aArea	:= GetArea()
	Local _aAreaSF2	:= SF2->(GetArea())
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local nPNROP		:= GdFieldPos("CNROP",aHeadForm)
	Local nPNQTDDEV		:= GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD",aHeadForm)
	Local nPCDSCPROD	:= GdFieldPos("CDSCPROD",aHeadForm)
	Local nPCOBSFATEC	:= GdFieldPos("COBSFATEC",aHeadForm)

	If nQtdFatec > (aCols[oNewGetDados:nAt ,nPNQTDNOTA]-aCols[oNewGetDados:nAt ,nPNQTDDEV])
		MsgAlert("Quantidade execede quantidade disponivel.")
		Return .f.
	Endif

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())
	SD2->(DbSeek(xFilial("SD2")+aCols[oNewGetDados:nAt,nPCNFSORIGI]+aCols[oNewGetDados:nAt,nPCSERIEORI]+M->PC1_CODCLI+M->PC1_LOJA+PADR(aCols[oNewGetDados:nAt,nPCPRODUTO],15)+aCols[oNewGetDados:nAt,nPCITEM])) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

	If nQtdFatec>(SD2->D2_QUANT-SD2->D2_QTDEDEV)
		MsgAlert("Saldo insuficiente para devolução do produto: "+AllTrim(aCols[oNewGetDados:nAt,nPCPRODUTO])+", o saldo em aberto deste produto é: "+CVALTOCHAR(SD2->D2_QUANT-SD2->D2_QTDEDEV))
		Return .F.
	EndIf

	RestArea(_aAreaSF2)
	RestArea(_aArea)

Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE47  ºAutor  ³Microsiga           º Data ³  26/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³   Funcão para rejeição                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE36()

	Local _cTitulo   := 'Rejeitar Fatec - ' + ALLTRIM(PC1_NUMERO)
	Local cLogAnali := "Rejeitado por " + cUserName + CRLF + " em " + DtoC(dDatabase) +CRLF+" às " + Time()+ CRLF
	Local cObs		:= MSMM(PC1->PC1_CODOBS)
	Local cLinha := SPACE(300)
	Local cTexto := ""
	Local oMemo
	Local cDevMat := PC1->PC1_DEVMAT
	Local cFatec :=  PC1->PC1_NUMERO

	IF(PC1->PC1_STATUS == "2") //SÓ PERMITE REJEIÇÃO PARA FATEC AUTORIZADA

		//DEFINE MSDIALOG oDlgRej TITLE OemToAnsi(_cTitulo) From 1,0 To 30,55 OF oMainWnd
		DEFINE MSDIALOG oDlgRej FROM 05,10 TO 260,340 TITLE _cTitulo OF oMainWnd PIXEL

		@ 05,04 SAY 'Rejeitar Fatec' PIXEL OF oDlgRej
		//@ 15,04 MSGet 100  VAR cLinha  Size 145,082  PIXEL OF oDlgRej MULTILINE 179, 060 COLORS 0, 16777215 HSCROLL PIXEL
		@ 15,04 GET oMotCancelamento  VAR cLinha  Size 145,082  OF oDlgRej MULTILINE SIZE 179, 060 COLORS 0, 16777215 HSCROLL PIXEL
		@ 106, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgRej:End()})  Pixel
		@ 106, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgRej:End()})  Pixel
		nOpca:=0

		ACTIVATE MSDIALOG oDlgRej CENTERED

		If nOpca == 1

			PC1->(RecLock("PC1",.F.))
			//MSMM(PC1->PC1_CODOBS,,,cLogAnali +' '+ cObs ,1,,,"PC1", "PC1->PC1_CODOBS",,.T.)

			IF(cDevMat == "1")//CASO SEJA DEVOLUÇÃO DE MATERIAL VOLTA STATUS PARA 4-ATENDIMENTO SEM DEVOLUÇÃO
				PC1->PC1_STATUS := "1"
			ELSEIF(cDevMat == "2")//CASO SEJA DEVOLUÇÃO DE MATERIAL VOLTA STATUS PARA 1-ABERTO
				PC1->PC1_STATUS := "4"
			ENDIF

			MSMM( PC1->PC1_CODOBS,,, cLogAnali +' Observação sobre a Rejeição:'+ cLinha +'   '+ cObs, 1,,, "PC1", "PC1_CODOBS" )

			PC1->(MsUnlock())

			MSGINFO('Rejeição de Fatec efetuada com sucesso')

		Endif
		//>>//Chamado 007087 - Everson Santana - 21.03.18 - Retorno o Status para Elaboração
	ELSEIf (PC1->PC1_STATUS == "1")

		PC1->(RecLock("PC1",.F.))

		PC1->PC1_STATUS := "0"

		MSMM( PC1->PC1_CODOBS,,,'Status Alterado para Elaboração'+ CRLF + cUserName + CRLF + " em " + DtoC(dDatabase) +CRLF+" às " + Time()+ CRLF + cObs, 1,,, "PC1", "PC1_CODOBS" )

		PC1->(MsUnlock())

		MSGINFO('Status Alterado com Sucesso!')
		//<<//Chamado 007087 - Everson Santana - 21.03.18 - Retorno o Status para Elaboração
	Else
		MsgAlert("Rejeição de Fatec é permitida apenas para status Autorizada")
		Return .f.
	ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VIEWIMP	    ºAutor  ³Renato Nogueira º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela com os impostos 								      º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VIEWIMP(aCols,nlin)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPCNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPCNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local _cProduto, _cNota, _cSerie, _cItem	:= ""
	Local _nQtdNota, _QtdFatec	:= 0
	Local _bIcms := _bIpi := _bIcmsSt := _vIcms := _vIpi := _vIcmsSt := _vTot := 0
	Local _newbIcms := _newbIpi := _newbIcmsSt := _newvIcms := _newvIpi := _newvIcmsSt := _newvTot := 0
	Local _totbIcms := _totbIpi := _totbIcmsSt := _totvIcms := _totvIpi := _totvIcmsSt := _totvTot := 0
	Local _aItens	:= {}

	For nlin:= 1 to len(oNewGetDados:aCols)

		_cProduto	:=	oNewGetDados:aCols[nlin ,nPCPRODUTO]
		_cNota		:=	oNewGetDados:aCols[nlin ,nPCNFSORIGI]
		_cSerie		:=	oNewGetDados:aCols[nlin ,nPCSERIEORI]
		_cItem		:=	oNewGetDados:aCols[nlin ,nPCITEM]
		_nQtdNota	:= 	oNewGetDados:aCols[nlin ,nPCNQTDNOTA]
		_nQtdFatec	:= 	oNewGetDados:aCols[nlin ,nPCNQTDFATEC]

		DbSelectArea("SD2")
		DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		DbSeek(xFilial("SD2")+_cNota+_cSerie+M->PC1_CODCLI+M->PC1_LOJA+_cProduto+_cItem)

		If SD2->(!Eof())

			_bIcms		:= SD2->D2_BASEICM
			_bIpi		:= SD2->D2_BASEIPI
			_bIcmsSt	:= SD2->D2_BRICMS
			_vIcms		:= SD2->D2_VALICM
			_vIpi		:= SD2->D2_VALIPI
			_vIcmsSt	:= SD2->D2_ICMSRET
			_vTot		:= SD2->D2_PRCVEN

			_newbIcms	:= (_bIcms	*_nQtdFatec)/_nQtdNota
			_newbIpi	:= (_bIpi 	*_nQtdFatec)/_nQtdNota
			_newbIcmsSt	:= (_bIcmsSt*_nQtdFatec)/_nQtdNota
			_newvIcms	:= (_vIcms  *_nQtdFatec)/_nQtdNota
			_newvIpi	:= (_vIpi	*_nQtdFatec)/_nQtdNota
			_newvIcmsSt	:= (_vIcmsSt*_nQtdFatec)/_nQtdNota
			_newvTot	:= (_vTot	*_nQtdFatec)

			_totbIcms	+= _newbIcms
			_totbIpi	+= _newbIpi
			_totbIcmsSt	+= _newbIcmsSt
			_totvIcms	+= _newvIcms
			_totvIpi	+= _newvIpi
			_totvIcmsSt	+= _newvIcmsSt
			_totvTot	+= _newvTot+_newvIpi+_newvIcmsSt

		EndIf

	Next

	Aadd(_aItens,{round(_totbIcms,2),;
		round(_totvIcms,2),;
		round(_totbIpi,2),;
		round(_totvIpi,2),;
		round(_totbIcmsSt,2),;
		round(_totvIcmsSt,2),;
		round(_totvTot,2)})

	If !Empty(_aItens)

		DEFINE MSDIALOG oDlg TITLE "Tela de impostos" FROM 200,1 TO 500,840 PIXEL //240

		@ 1,1 LISTBOX oLbx FIELDS HEADER ;
			"Base ICMS", "Valor Icms", "Base IPI", "Valor Ipi", "Base Icms St", "Valor Icms St", "Total" ;
			SIZE 430,095 OF oDlg PIXEL //ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

		//Exibe o Array no browse
		oLbx:SetArray( _aItens )
		oLbx:bLine := {||{_aItens[oLbx:nAt,1],;
			_aItens[oLbx:nAt,2],;
			_aItens[oLbx:nAt,3],;
			_aItens[oLbx:nAt,4],;
			_aItens[oLbx:nAt,5],;
			_aItens[oLbx:nAt,6],;
			_aItens[oLbx:nAt,7]}}

		@ 200,90 BTNBMP oBtn1 RESOURCE "FINAL" 	     SIZE 40,40 ACTION oDlg:End() ENABLE OF oDlg

		@ 108,80 Say oSay Var "Sair " Of oDlg Pixel

		ACTIVATE MSDIALOG oDlg CENTER

	Else

		MsgAlert("Não existem itens cadastrados!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VIEWIMPP	    ºAutor  ³Renato Nogueira º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela com os impostos por produtos					      º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VIEWIMPP(aCols,nlin)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPCNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPCNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local _cProduto, _cNota, _cSerie, _cItem	:= ""
	Local _nQtdNota, _QtdFatec	:= 0
	Local _bIcms := _bIpi := _bIcmsSt := _vIcms := _vIpi := _vIcmsSt := _vTot := 0
	Local _newbIcms := _newbIpi := _newbIcmsSt := _newvIcms := _newvIpi := _newvIcmsSt := _newvTot := 0
	Local _totbIcms := _totbIpi := _totbIcmsSt := _totvIcms := _totvIpi := _totvIcmsSt := _totvTot := 0
	Local _aItens	:= {}

	_cProduto	:=	oNewGetDados:aCols[nlin ,nPCPRODUTO]
	_cNota		:=	oNewGetDados:aCols[nlin ,nPCNFSORIGI]
	_cSerie		:=	oNewGetDados:aCols[nlin ,nPCSERIEORI]
	_cItem		:=	oNewGetDados:aCols[nlin ,nPCITEM]
	_nQtdNota	:= 	oNewGetDados:aCols[nlin ,nPCNQTDNOTA]
	_nQtdFatec	:= 	oNewGetDados:aCols[nlin ,nPCNQTDFATEC]

	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	DbSeek(xFilial("SD2")+_cNota+_cSerie+M->PC1_CODCLI+M->PC1_LOJA+_cProduto+_cItem)

	If SD2->(!Eof())

		_bIcms		:= SD2->D2_BASEICM
		_bIpi		:= SD2->D2_BASEIPI
		_bIcmsSt	:= SD2->D2_BRICMS
		_vIcms		:= SD2->D2_VALICM
		_vIpi		:= SD2->D2_VALIPI
		_vIcmsSt	:= SD2->D2_ICMSRET
		_vTot		:= SD2->D2_PRCVEN

		_newbIcms	:= (_bIcms	*_nQtdFatec)/_nQtdNota
		_newbIpi	:= (_bIpi 	*_nQtdFatec)/_nQtdNota
		_newbIcmsSt	:= (_bIcmsSt*_nQtdFatec)/_nQtdNota
		_newvIcms	:= (_vIcms  *_nQtdFatec)/_nQtdNota
		_newvIpi	:= (_vIpi	*_nQtdFatec)/_nQtdNota
		_newvIcmsSt	:= (_vIcmsSt*_nQtdFatec)/_nQtdNota
		_newvTot	:= (_vTot	*_nQtdFatec)

		_totbIcms	+= _newbIcms
		_totbIpi	+= _newbIpi
		_totbIcmsSt	+= _newbIcmsSt
		_totvIcms	+= _newvIcms
		_totvIpi	+= _newvIpi
		_totvIcmsSt	+= _newvIcmsSt
		_totvTot	+= _newvTot+_newvIpi+_newvIcmsSt

	EndIf

	Aadd(_aItens,{round(_totbIcms,2),;
		round(_totvIcms,2),;
		round(_totbIpi,2),;
		round(_totvIpi,2),;
		round(_totbIcmsSt,2),;
		round(_totvIcmsSt,2),;
		round(_totvTot,2),;
		round(_vTot,2)})

	If !Empty(_aItens)

		DEFINE MSDIALOG oDlg TITLE "Tela de impostos por produto - "+AllTrim(SD2->D2_COD)+" - NF: "+Alltrim(SD2->D2_DOC) FROM 200,1 TO 500,840 PIXEL //240

		@ 1,1 LISTBOX oLbx FIELDS HEADER ;
			"Base ICMS", "Valor Icms", "Base IPI", "Valor Ipi", "Base Icms St", "Valor Icms St", "Total", "Unitário" ;
			SIZE 430,095 OF oDlg PIXEL //ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

		//Exibe o Array no browse
		oLbx:SetArray( _aItens )
		oLbx:bLine := {||{_aItens[oLbx:nAt,1],;
			_aItens[oLbx:nAt,2],;
			_aItens[oLbx:nAt,3],;
			_aItens[oLbx:nAt,4],;
			_aItens[oLbx:nAt,5],;
			_aItens[oLbx:nAt,6],;
			_aItens[oLbx:nAt,7],;
			_aItens[oLbx:nAt,8]}}

		@ 200,90 BTNBMP oBtn1 RESOURCE "FINAL" 	     SIZE 40,40 ACTION oDlg:End() ENABLE OF oDlg

		@ 108,80 Say oSay Var "Sair " Of oDlg Pixel

		ACTIVATE MSDIALOG oDlg CENTER

	Else

		MsgAlert("Não existem itens cadastrados!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFATR05	ºAutor  ³Renato Nogueira     º Data ³  29/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para listar os itens da FATEC	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function STESTR05(aCols,nlin)

	Local oReport

	//PutSx1("STESTR05", "01","Fatec?" ,"","","mv_ch1","C",6,0,0,"G","","PC1","","","mv_par01","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2

	//oReport := TReport():New("STESTR05","RELATÓRIO DE LOCALIZAÇÃO","STESTR05",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de localizações.")
	oReport := TReport():New("STESTR05","RELATÓRIO FATEC: "+PC1->PC1_NUMERO,,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um detalhamento da fatec.")

	//Pergunte("STESTR02",.F.)

	oSection1 := TRSection():New(oReport,"CABEC",{"PC1"})

	TRCell():New(oSection1,"NFATEC1"    ,"PC1","NUM. FATEC"    ,PesqPict("PC1","PC1_NUMERO",06),)
	TRCell():New(oSection1,"PEDIDO"     ,"PC1","PEDIDO"        ,PesqPict("PC1","PC1_PEDREP",06),)
	TRCell():New(oSection1,"ATEND"      ,"PC1","ATENDENTE"     ,PesqPict("PC1","PC1_ATENDE",15),)
	TRCell():New(oSection1,"DATAO"      ,"PC1","DATA OCOR."    ,PesqPict("PC1","PC1_DTOCOR",10),)
	TRCell():New(oSection1,"STATUS"     ,"PC1","STATUS"        ,PesqPict("PC1","PC1_STATUS",01),)
	TRCell():New(oSection1,"CONTATO"    ,"PC1","CONTATO"       ,PesqPict("PC1","PC1_CONTAT",30),)
	TRCell():New(oSection1,"MOTIVO"     ,"PC1","MOTIVO"        ,PesqPict("PC1","PC1_MOTIVO",03),)

	oSection2 := TRSection():New(oReport,"FATEC",{"PC2"})

	TRCell():New(oSection2,"NFATEC"    ,"PC2","NUM. FATEC"    ,PesqPict("PC2","PC2_NFATEC",06),)
	TRCell():New(oSection2,"NFORIG"    ,"PC2","NF ORIGINAL"   ,PesqPict("PC2","PC2_NFORIG",09),)
	TRCell():New(oSection2,"SERIE"     ,"PC2","SERIE"         ,PesqPict("PC2","PC2_SERIE" ,03),)
	TRCell():New(oSection2,"CODCLI"    ,"PC1","CLIENTE"       ,PesqPict("PC1","PC1_CODCLI",06),)
	TRCell():New(oSection2,"LOJA"      ,"PC1","LOJA"          ,PesqPict("PC1","PC1_LOJA"  ,02),)
	TRCell():New(oSection2,"NOMCLI"    ,"PC1","NOME"          ,"@!"						 ,30,.F.,)
	TRCell():New(oSection2,"ITEM"      ,"PC2","ITEM"          ,PesqPict("PC2","PC2_ITEM"  ,02),)
	TRCell():New(oSection2,"PROD"      ,"PC2","PRODUTO"       ,PesqPict("PC2","PC2_PRODUT",15),)
	//TRCell():New(oSection2,"DESC"      ,"PC2","DESCRIÇÃO"     ,PesqPict("PC2","PC2_DESPRO",30),)
	//TRCell():New(oSection2,"GRUPO"     ,"PC2","GRUPO"         ,PesqPict("PC2","PC2_GRPPRO",04),)
	//TRCell():New(oSection2,"GRPDES"    ,"PC2","DESC. GRUPO"   ,PesqPict("PC2","PC2_DSCPRO",50),)
	TRCell():New(oSection2,"QTDNF"     ,"PC2","QTDE NF"       ,"@E 99999999.99"           ,11,.F.,)
	TRCell():New(oSection2,"DEV"       ,"PC2","QTDE DEV"      ,"@E 99999999.99"           ,11,.F.,)
	TRCell():New(oSection2,"FATQTD"    ,"PC2","QTDE FAT"      ,"@E 99999999.99"           ,11,.F.,)
	TRCell():New(oSection2,"D2_PRCVEN"    ,"PC2","PRECO"      ,"@E 99999999.99"           ,11,.F.,)

	TRCell():New(oSection2,"BSICM"    ,"SD2","Base Icms"      ,PesqPict("SD2","D2_BASEICM") ,TamSX3("D2_BASEICM")[1],.F.,)
	TRCell():New(oSection2,"VLICM"    ,"SD2","Valor Icms"      ,PesqPict("SD2","D2_VALICM") ,TamSX3("D2_VALICM")[1],.F.,)

	TRCell():New(oSection2,"BSIPI"    ,"SD2","Base IPI"      ,PesqPict("SD2","D2_BASEIPI") ,TamSX3("D2_BASEIPI")[1],.F.,)
	TRCell():New(oSection2,"VLIPI"    ,"SD2","Valor IPI"      ,PesqPict("SD2","D2_VALIPI") ,TamSX3("D2_VALIPI")[1],.F.,)

	TRCell():New(oSection2,"BSICMST"    ,"SD2","Base Icms St"      ,PesqPict("SD2","D2_BRICMS") ,TamSX3("D2_BRICMS")[1],.F.,)
	TRCell():New(oSection2,"VLICMST"    ,"SD2","Valor Icms St"      ,PesqPict("SD2","D2_ICMSRET") ,TamSX3("D2_ICMSRET")[1],.F.,)

	TRCell():New(oSection2,"TOTAL"    ,"SD2","Total"      ,PesqPict("SD2","D2_TOTAL") ,TamSX3("D2_TOTAL")[1],.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("PC1")
	oSection2:SetHeaderSection(.T.)
	oSection2:Setnofilter("PC2")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection1			:= oReport:Section(1)
	Local oSection2			:= oReport:Section(2)
	Local cQuery 			:= ""
	Local cAlias 			:= "QRYTEMP"
	Local aDados[19]
	Local _aDados			:= {}
	Local _cFatec, _cPedido	:= ""

	oSection1:Cell("NFATEC1") :SetBlock( { || PC1->PC1_NUMERO } )
	oSection1:Cell("PEDIDO")  :SetBlock( { || PC1->PC1_PEDREP } )
	oSection1:Cell("ATEND")   :SetBlock( { || PC1->PC1_ATENDE } )
	oSection1:Cell("DATAO")   :SetBlock( { || PC1->PC1_DTOCOR } )
	oSection1:Cell("STATUS")  :SetBlock( { || PC1->PC1_STATUS } )
	oSection1:Cell("CONTATO") :SetBlock( { || PC1->PC1_CONTAT } )
	oSection1:Cell("MOTIVO")  :SetBlock( { || PC1->PC1_MOTIVO } )

	oSection2:Cell("NFATEC") :SetBlock( { || aDados[1] } )
	oSection2:Cell("NFORIG") :SetBlock( { || aDados[2] } )
	oSection2:Cell("SERIE")  :SetBlock( { || aDados[3] } )
	oSection2:Cell("CODCLI") :SetBlock( { || aDados[4] } )
	oSection2:Cell("LOJA") 	:SetBlock( { || aDados[5] } )
	oSection2:Cell("NOMCLI") :SetBlock( { || aDados[6] } )
	oSection2:Cell("ITEM")  	:SetBlock( { || aDados[7] } )
	oSection2:Cell("PROD")	:SetBlock( { || aDados[8] } )
	//oSection2:Cell("DESC")  	:SetBlock( { || aDados[9] } )
	//oSection2:Cell("GRUPO")	:SetBlock( { || aDados[10] } )
	//oSection2:Cell("GRPDES") :SetBlock( { || aDados[11] } )
	oSection2:Cell("QTDNF")  :SetBlock( { || aDados[9] } )
	oSection2:Cell("DEV")   	:SetBlock( { || aDados[10] } )
	oSection2:Cell("FATQTD") :SetBlock( { || aDados[11] } )
	oSection2:Cell("D2_PRCVEN") :SetBlock( { || aDados[12] } )

	oSection2:Cell("BSICM") :SetBlock( { || aDados[13] } )
	oSection2:Cell("VLICM") :SetBlock( { || aDados[14] } )
	oSection2:Cell("BSIPI") :SetBlock( { || aDados[15] } )
	oSection2:Cell("VLIPI") :SetBlock( { || aDados[16] } )
	oSection2:Cell("BSICMST") :SetBlock( { || aDados[17] } )
	oSection2:Cell("VLICMST") :SetBlock( { || aDados[18] } )
	oSection2:Cell("TOTAL") :SetBlock( { || aDados[19] } )

	oReport:SetTitle("Lista de itens da Fatec")// Titulo do relatório
	/*
	cQuery := " SELECT PC2_NFATEC, PC2_NFORIG, PC2_SERIE, PC1_CODCLI, PC1_LOJA, PC1_NOMCLI, "
	cQuery += " PC2_ITEM, PC2_PRODUT, PC2_DESPRO, PC2_GRPPRO, PC2_DSCPRO, PC2_QTDNFS, "
	cQuery += " PC2_QTDDEV, PC2_QTDFAT, PC2_OBSER "
	cQuery += " ,(SELECT D2_PRCVEN FROM " +RetSqlName("SD2")+ " D2 WHERE D2.D_E_L_E_T_=' ' AND D2_FILIAL='"+cFilAnt+"' "
	cQuery += " AND D2_DOC=PC2.PC2_NFORIG AND D2_SERIE=PC2.PC2_SERIE AND D2_ITEM=PC2.PC2_ITEM) D2_PRCVEN "
	cQuery += " FROM " +RetSqlName("PC2")+ " PC2 "
	cQuery += " LEFT JOIN " +RetSqlName("PC1")+ " PC1 "
	cQuery += " ON PC2_FILIAL=PC1_FILIAL AND PC2_NFATEC=PC1_NUMERO "
	//cQuery += " WHERE PC1.D_E_L_E_T_=' ' AND PC2.D_E_L_E_T_=' ' AND PC1_NFATEC='"+PC1->PC1_NFATEC+"' "
	cQuery += " WHERE PC1.D_E_L_E_T_=' ' AND PC2.D_E_L_E_T_=' ' AND PC2_NFATEC='"+PC1->PC1_NUMERO+"' "
	*/

	cQuery := " SELECT XXX.*, (D2_PRCVEN*PC2_QTDFAT)+VIPI+VICMST TOT
	cQuery += " FROM (
	cQuery += " SELECT PC2_NFATEC, PC2_NFORIG, PC2_SERIE, PC1_CODCLI, PC1_LOJA, PC1_NOMCLI,
	cQuery += " PC2_ITEM, PC2_PRODUT, PC2_DESPRO, PC2_GRPPRO, PC2_DSCPRO, PC2_QTDNFS,  PC2_QTDDEV, PC2_QTDFAT, PC2_OBSER
	cQuery += " ,D2_PRCVEN,
	cQuery += " ((D2_BASEICM*PC2_QTDFAT)/PC2_QTDNFS) BICMS,
	cQuery += " ((D2_BASEIPI*PC2_QTDFAT)/PC2_QTDNFS) BIPI,
	cQuery += " ((D2_BRICMS*PC2_QTDFAT)/PC2_QTDNFS) BICMST,
	cQuery += " ((D2_VALICM*PC2_QTDFAT)/PC2_QTDNFS) VICMS,
	cQuery += " ((D2_VALIPI*PC2_QTDFAT)/PC2_QTDNFS) VIPI,
	cQuery += " ((D2_ICMSRET*PC2_QTDFAT)/PC2_QTDNFS) VICMST
	cQuery += " FROM "+RetSqlName("PC2")+" PC2
	cQuery += " LEFT JOIN "+RetSqlName("PC1")+" PC1
	cQuery += " ON PC2_FILIAL=PC1_FILIAL AND PC2_NFATEC=PC1_NUMERO
	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2
	cQuery += " ON D2_FILIAL='"+cFilAnt+"' AND D2_DOC=PC2_NFORIG AND D2_SERIE=PC2_SERIE AND D2_ITEM=PC2_ITEM AND D2.D_E_L_E_T_=' '
	cQuery += " WHERE PC1.D_E_L_E_T_=' ' AND PC2.D_E_L_E_T_=' ' AND PC2_NFATEC='"+PC1->PC1_NUMERO+"'
	cQuery += " ) XXX

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection1:Init()
	oSection2:Init()

	oSection1:PrintLine()

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While !(cAlias)->(Eof())

		aDados[1]	:=	(cAlias)->PC2_NFATEC
		aDados[2]	:=	(cAlias)->PC2_NFORIG
		aDados[3]	:=	(cAlias)->PC2_SERIE
		aDados[4]	:=	(cAlias)->PC1_CODCLI
		aDados[5]	:=	(cAlias)->PC1_LOJA
		aDados[6]	:=	(cAlias)->PC1_NOMCLI
		aDados[7]	:=	(cAlias)->PC2_ITEM
		aDados[8]	:=	(cAlias)->PC2_PRODUT
		//	aDados[9]	:=	(cAlias)->PC2_DESPRO
		//	aDados[10]	:=	(cAlias)->PC2_GRPPRO
		//	aDados[11]	:=	(cAlias)->PC2_DSCPRO
		aDados[9]	:=	(cAlias)->PC2_QTDNFS
		aDados[10]	:=	(cAlias)->PC2_QTDDEV
		aDados[11]	:=	(cAlias)->PC2_QTDFAT
		aDados[12]	:=	(cAlias)->D2_PRCVEN

		aDados[13]	:=	(cAlias)->BICMS
		aDados[14]	:=	(cAlias)->VICMS
		aDados[15]	:=	(cAlias)->BIPI
		aDados[16]	:=	(cAlias)->VIPI
		aDados[17]	:=	(cAlias)->BICMST
		aDados[18]	:=	(cAlias)->VICMST
		aDados[19]	:=	(cAlias)->TOT

		oSection2:PrintLine()
		aFill(aDados,nil)

		(cAlias)->(DbSkip())

	EndDo

	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())

Return oReport


Static Function STCARITENS(_aColsTec,nlin)
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local nPNROP		:= GdFieldPos("CNROP",aHeadForm)
	Local nPNQTDDEV		:= GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD",aHeadForm)
	Local nPCDSCPROD	:= GdFieldPos("CDSCPROD",aHeadForm)
	Local nPCOBSFATEC	:= GdFieldPos("COBSFATEC",aHeadForm)
	Local _cRet 		:= Space(9)
	Local _cSer 		:= Space(3)
	Local oDlgEmail
	Local lSaida      := .F.

	If !Empty(Alltrim(M->PC1_CODCLI))

		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite a Nf") From  1,0 To 120,200 Pixel OF oMainWnd

		@ 02,04 SAY "Nf:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _cRet   Size 55,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
		@ 27,04 SAY "Serie:" PIXEL OF oDlgEmail
		@ 37,04 MSGet _cSer   Size 55,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cSer))

		@ 12,62 Button "Ok"  Size 28,13 Action iif(ValidNF(_cRet, _cSer, , , , .F., ), Eval({|| lSaida:=.T., oDlgEmail:End()}), .F.) Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED

	If lSaida
		DbSelectArea( "SD2" )
		SD2->(DbSetOrder(3))  // D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA
		If SD2->(DbSeek( xFilial("SD2") + _cRet + _cSer+M->PC1_CODCLI+M->PC1_LOJA) )
			SD2->(DbSeek( xFilial("SD2") + _cRet + _cSer+M->PC1_CODCLI+M->PC1_LOJA) )
			While !(SD2->(Eof())) .And. (SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA) = (_cRet + _cSer+M->PC1_CODCLI+M->PC1_LOJA)
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+	SD2->D2_COD))
					dbSelectArea("SBM")
					SBM->(dbSetOrder(1))
					If	SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
						AADD(_aColsTec,Array(Len(aHeadForm) + 1))
						_aColsTec[Len(_aColsTec)][nPCPRODUTO] 	:= SB1->B1_COD
						_aColsTec[Len(_aColsTec)][nPCNOMEPROD] 	:= SB1->B1_DESC
						_aColsTec[Len(_aColsTec)][nPCNFSORIGI] 	:= SD2->D2_DOC
						_aColsTec[Len(_aColsTec)][nPCSERIEORI] 	:= SD2->D2_SERIE
						_aColsTec[Len(_aColsTec)][nPCITEM] 		:= SD2->D2_ITEM
						_aColsTec[Len(_aColsTec)][nPNQTDNOTA] 	:= SD2->D2_QUANT
						_aColsTec[Len(_aColsTec)][nPNQTDFATEC] 	:= SD2->D2_QUANT - SD2->D2_QTDEDEV //SD2->D2_QUANT
						_aColsTec[Len(_aColsTec)][nPNROP] 		:=  ''
						_aColsTec[Len(_aColsTec)][nPNQTDDEV] 	:= SD2->D2_QTDEDEV //0
						_aColsTec[Len(_aColsTec)][nPCGRPPROD] 	:= SB1->B1_GRUPO
						_aColsTec[Len(_aColsTec)][nPCDSCPROD] 	:= SBM->BM_DESC
						_aColsTec[Len(_aColsTec)][nPCOBSFATEC] 	:= ' '
						_aColsTec[Len(_aColsTec)][Len(aHeadForm)+1] := .F.
					EndIf
				EndIf
				SD2->(DbSkip())
			EndDo
		Else
			MsgInfo("Nf Não Encontrado Verifique!!!!!")
		EndIf
	Else
		MsgInfo("Cliente Não Encontrado Verifique!!!!!")
	EndIf
	oNewGetDados:aCols:=_aColsTec
	
	EndIf

	//oDlgEsp:REFRESH()
Return ()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FSV30VP    ³ Autor ³ Luiz Enrique     	  ³ Data ³ 06/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se Codigo do Produto é valido                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FSV30VP (CodProduto)
	Local nPCNOMEPROD	:= GdFieldPos("CNOMEPROD",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local nPNQTDDEV	:= GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCGRPPROD	:= GdFieldPos("CGRPPROD",aHeadForm)

	SB1->(dbsetOrder(1))
	If ! SB1->(dbSeek(xFilial()+Trim(CodProduto)))
		MsgAlert("Código do Produto Inválido")
		Return .f.
	Endif

	aCols[oNewGetDados:nAt ,nPCNOMEPROD] 	:= Alltrim(SB1->B1_DESC)
	aCols[oNewGetDados:nAt ,nPCGRPPROD] 	:= Alltrim(SB1->B1_GRUPO)
	aCols[oNewGetDados:nAt ,nPCNFSORIGI] 	:= Space(09)
	aCols[oNewGetDados:nAt ,nPCSERIEORI] 	:= Space(03)
	aCols[oNewGetDados:nAt ,nPNQTDNOTA] 	:= 0
	aCols[oNewGetDados:nAt ,nPNQTDFATEC] 	:= 0
	aCols[oNewGetDados:nAt ,nPNQTDDEV] 		:= 0

	oNewGetDados:Refresh()

Return .t.
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FSV30NFS	  ³ Autor ³ Luiz Enrique     	  ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Nota Fiscal De Saida				                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK	                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FSV30NFS ()
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPos 			:= oNewGetDados:nAt
	Local cChave		:= ""

	cNfsOrigi 	:= oNewGetDados:aCols[nPos ,nPCNFSORIGI]
	cSerieOri	:= oNewGetDados:aCols[nPos ,nPCSERIEORI]
	cProduto		:= oNewGetDados:aCols[nPos ,nPCPRODUTO]
	cChave:= xFilial("SD2")+Padr(cNfsOrigi,9)+Padr(cSerieOri,3)+Padr(M->PC1_CODCLI,6) + Padr(M->PC1_LOJA,2)

	SD2->(DbSetOrder(3)) //Doc + serie + Cliente + Loja + Produto + Item

	//Valida apenas a Nota
	If !SD2->(DbSeek( cChave ))
		MsgAlert("Nota Fiscal Invalida")
		Return .f.
	Endif

	//Valida Produto na Nota
	cChave+= Padr(cProduto,15)

	If !SD2->(DbSeek( cChave ))
		MsgAlert("Produto Invalido para a Nota Fiscal.")
		Return .f.
	Endif

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FSV30VI 	  ³ Autor ³ Luiz Enrique     	  ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida o ITEM da Nota Fisca De Saida	                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK	                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FSV30VI()

	Local cCodIten:= If(Len(Alltrim(cItem)) == 1,"0"+cItem,cItem)	//Altera a mascara da digitaçcao do Item, caso for digitado apenas 1 digito
	Local nPNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPNQTDDEV	:= GdFieldPos("NQTDDEV",aHeadForm)
	Local nPCITEM 		:= GdFieldPos("CITEM",aHeadForm)
	Local cChave:= xFilial("SD2")+	Padr(cNfsOrigi,9)+;
		Padr(cSerieOri,3)+;
		Padr(M->PC1_CODCLI,6)+;
		Padr(M->PC1_LOJA,2)+Padr(cProduto,15)+ cCodIten
	SD2->(DbSetOrdeR(3))
	If !SD2->(DbSeek( cChave ))
		MsgAlert("Item Invalido para a Nota Fiscal.")
		Return .f.
	Endif

	aCols[oNewGetDados:nAt ,nPNQTDNOTA]	:= SD2->D2_QUANT
	aCols[oNewGetDados:nAt ,nPNQTDDEV] 	:= SD2->D2_QTDEDEV
	aCols[oNewGetDados:nAt ,nPCITEM] 	:= cCodIten
	oNewGetDados:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STVLDPC2  ³ Autor ³ Renato Nogueira     	  ³ Data ³ 05/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida saldo de devolucao da nota		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function STVLDPC2(nNf,nSerie,nItem,nQtdNota,nQtdFatec,cProduto)

	Local _aArea	:= GetArea()
	Local _aAreaSF2	:= SF2->(GetArea())
	Local _lRet		:= .T.

	//If !ISINCALLSTACK("U_STFSVE35")

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())
	SD2->(DbSeek(xFilial("SD2")+nNf+nSerie+M->PC1_CODCLI+M->PC1_LOJA+PADR(cProduto,15)+nItem)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

	If nQtdFatec>(SD2->D2_QUANT-SD2->D2_QTDEDEV)
		_lRet	:= .F.
		MsgAlert("Saldo insuficiente para devolução do produto: "+AllTrim(cProduto)+", o saldo em aberto deste produto é: "+CVALTOCHAR(SD2->D2_QUANT-SD2->D2_QTDEDEV))
	EndIf

	//EndIf

	RestArea(_aAreaSF2)
	RestArea(_aArea)

Return _lRet

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ STVE35OB  ³ Autor ³ Renato Nogueira     	  ³ Data ³ 05/02/15 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Colocar observações						                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ STECK	                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/

User Function STVE35OB()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local _cObs			:= space(200)

	AADD(_aParamBox,{1,"Observação",_cObs,"@!","","","",200,.T.}) //50

	If ParamBox(_aParamBox,"Observação",@_aRet,,,.T.,,500)

		PC1->(RecLock("PC1",.F.))
		MSMM(PC1->PC1_CODOBS,,,CRLF+MV_PAR01,1,,,"PC1","PC1_CODOBS",,.T.)
		PC1->(MsUnLock())

		MsgAlert("Observação inserida com sucesso")

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VIEWIMP	    ºAutor  ³Renato Nogueira º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela com os impostos 								      º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VIEWTOT(aCols,nlin)

	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPCNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPCNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local _cProduto, _cNota, _cSerie, _cItem	:= ""
	Local _nQtdNota, _QtdFatec	:= 0
	Local _bIcms := _bIpi := _bIcmsSt := _vIcms := _vIpi := _vIcmsSt := _vTot := 0
	Local _newbIcms := _newbIpi := _newbIcmsSt := _newvIcms := _newvIpi := _newvIcmsSt := _newvTot := 0
	Local _totbIcms := _totbIpi := _totbIcmsSt := _totvIcms := _totvIpi := _totvIcmsSt := _totvTot := 0
	Local _aItens	:= {}
	Local _totvTot := 0

	For nlin:= 1 to len(oNewGetDados:aCols)

		_cProduto	:=	oNewGetDados:aCols[nlin ,nPCPRODUTO]
		_cNota		:=	oNewGetDados:aCols[nlin ,nPCNFSORIGI]
		_cSerie	:=	oNewGetDados:aCols[nlin ,nPCSERIEORI]
		_cItem		:=	oNewGetDados:aCols[nlin ,nPCITEM]
		_nQtdNota	:= 	oNewGetDados:aCols[nlin ,nPCNQTDNOTA]
		_nQtdFatec	:= 	oNewGetDados:aCols[nlin ,nPCNQTDFATEC]

		DbSelectArea("SD2")
		DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		DbSeek(xFilial("SD2")+_cNota+_cSerie+M->PC1_CODCLI+M->PC1_LOJA+_cProduto+_cItem)

		If SD2->(!Eof())

			_bIcms		:= SD2->D2_BASEICM
			_bIpi		:= SD2->D2_BASEIPI
			_bIcmsSt	:= SD2->D2_BRICMS
			_vIcms		:= SD2->D2_VALICM
			_vIpi		:= SD2->D2_VALIPI
			_vIcmsSt	:= SD2->D2_ICMSRET
			_vTot		:= SD2->D2_PRCVEN

			_newbIcms	:= (_bIcms	*_nQtdFatec)/_nQtdNota
			_newbIpi	:= (_bIpi 	*_nQtdFatec)/_nQtdNota
			_newbIcmsSt	:= (_bIcmsSt*_nQtdFatec)/_nQtdNota
			_newvIcms	:= (_vIcms  *_nQtdFatec)/_nQtdNota
			_newvIpi	:= (_vIpi	*_nQtdFatec)/_nQtdNota
			_newvIcmsSt	:= (_vIcmsSt*_nQtdFatec)/_nQtdNota
			_newvTot	:= (_vTot	*_nQtdFatec)

			_totbIcms	+= _newbIcms
			_totbIpi	+= _newbIpi
			_totbIcmsSt	+= _newbIcmsSt
			_totvIcms	+= _newvIcms
			_totvIpi	+= _newvIpi
			_totvIcmsSt	+= _newvIcmsSt
			_totvTot	+= _newvTot+_newvIpi+_newvIcmsSt

		EndIf

	Next
	/*
	Aadd(_aItens,{round(_totbIcms,2),;
	round(_totvIcms,2),;
	round(_totbIpi,2),;
	round(_totvIpi,2),;
	round(_totbIcmsSt,2),;
	round(_totvIcmsSt,2),;
	round(_totvTot,2)})

	If !Empty(_aItens)

	DEFINE MSDIALOG oDlg TITLE "Tela de impostos" FROM 200,1 TO 500,840 PIXEL //240

	@ 1,1 LISTBOX oLbx FIELDS HEADER ;
	"Base ICMS", "Valor Icms", "Base IPI", "Valor Ipi", "Base Icms St", "Valor Icms St", "Total" ;
	SIZE 430,095 OF oDlg PIXEL //ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

	//Exibe o Array no browse
	oLbx:SetArray( _aItens )
	oLbx:bLine := {||{_aItens[oLbx:nAt,1],;
	_aItens[oLbx:nAt,2],;
	_aItens[oLbx:nAt,3],;
	_aItens[oLbx:nAt,4],;
	_aItens[oLbx:nAt,5],;
	_aItens[oLbx:nAt,6],;
	_aItens[oLbx:nAt,7]}}

	@ 200,90 BTNBMP oBtn1 RESOURCE "FINAL" 	     SIZE 40,40 ACTION oDlg:End() ENABLE OF oDlg

	@ 108,80 Say oSay Var "Sair " Of oDlg Pixel

	ACTIVATE MSDIALOG oDlg CENTER

	Else

	MsgAlert("Não existem itens cadastrados!")

	EndIf
	*/

Return(_totvTot)

/*====================================================================================\
|Programa  | WFNOTIF         | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
//FR - 03/11/2021 - Adição do email de kleber.braga@steck.com.br para receber 
//                  apenas as notificações com motivos Logísticos
//                  TICKET #20211029023220 
\====================================================================================*/

Static Function WFNOTIF(_cEmail,cColab,_totvTot)

	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg	     := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cObs		:= ""
	Local _cMotLog  := ""		//FR - 03/11/2021 - TICKET #20211029023220
	Local _cMailLog := ""		//FR - 03/11/2021 - TICKET #20211029023220

	_cAssunto := 'Notificação Fatec - '+Alltrim(PC1->PC1_NUMERO)

	cMsg  := ""
	cMsg  += '<html>'
	cMsg  += '    <table border="0">'
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	//cMsg  += '                    face="verdana"><b>Fatec '+Alltrim(PC1->PC1_NUMERO)+' Incluida por: '+cColab+'</b></font></p>'
	cMsg  += '                    face="verdana"><b>Fatec '+Alltrim(PC1->PC1_NUMERO)+' Incluida por: '+PC1->PC1_ATENDE+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Cliente '+Alltrim(PC1->PC1_CODCLI)+"/"+PC1->PC1_LOJA  +" - "+PC1->PC1_NOMCLI+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '                <tr>'
	cMsg  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">NFS Original</font></td>'
	cMsg  += '                    <td align="center" width="40"  bgcolor="#DFEFFF" height="18"><font face="verdana">Serie</font></td>'
	cMsg  += '                    <td align="center" width="40"  bgcolor="#DFEFFF" height="18"><font face="verdana">Item</font></td>'
	cMsg  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Produto</font></td>'
	cMsg  += '                    <td align="center" width="200"  bgcolor="#DFEFFF" height="18"><font face="verdana">Descrição do Produto</font></td>'
	cMsg  += '                    <td align="center" width="100" bgcolor="#DFEFFF" height="18"><font face="verdana">Grupo do Produto</font></td>'
	cMsg  += '                    <td align="center" width="100"  bgcolor="#DFEFFF" height="18"><font face="verdana">Descr. Grupo Produto</font></td>'
	cMsg  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Qtd da Nota</font></td>'
	cMsg  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Devolução</font></td>'
	cMsg  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Qtd Fatec</font></td>'
	cMsg  += '                </tr>'

	dbSelectArea("PC2")
	dbSetOrder(1)
	dbGotop()
	dbSeek(xFilial("PC2")+Alltrim(PC1->PC1_NUMERO))
	While !Eof() .and. PC2->PC2_NFATEC == PC1->PC1_NUMERO

		cMsg   += '                <tr>'
		cMsg   += '                    <td align="center"><font size="1" face="verdana">'+PC2->PC2_NFORIG+'</font></td>'
		cMsg   += '                    <td align="center"><font size="1" face="verdana">'+PC2->PC2_SERIE +'</font></td>'
		cMsg   += '                    <td align="center"><font size="1" face="verdana">'+PC2->PC2_ITEM +'</font></td>'
		cMsg   += '                    <td align="left"><font size="1" face="verdana">'+PC2->PC2_PRODUT+'</font></td>'
		cMsg   += '                    <td align="left"><font size="1" face="verdana">'+PC2->PC2_DESPRO+'</font></td>'
		cMsg   += '                    <td align="left"><font size="1" face="verdana">'+PC2->PC2_GRPPRO+'</font></td>'
		cMsg   += '                    <td align="left"><font size="1" face="verdana">'+PC2->PC2_DSCPRO+'</font></td>'
		cMsg   += '                    <td align="right"><font size="1" face="verdana">'+TRANSFORM(PC2->PC2_QTDNFS,"@E 99999999.99")+'</font></td>'
		cMsg   += '                    <td align="right"><font size="1" face="verdana">'+TRANSFORM(PC2->PC2_QTDDEV,"@E 99999999.99")+'</font></td>'
		cMsg   += '                    <td align="right"><font size="1" face="verdana">'+TRANSFORM(PC2->PC2_QTDFAT,"@E 99999999.99")+'</font></td>'
		cMsg   += '                </tr>'

		dbSelectArea("PC2")
		dbSkip()
	End
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Valor da FATEC: R$ '+TransForm(_totvTot,"@E 999,999,999.99")+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Vendedor: '+AllTrim(Posicione("SA1",1,xFilial("SA1")+PC1->(PC1_CODCLI+PC1_LOJA),"A1_VEND"))+" - "+AllTrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA1",1,xFilial("SA1")+PC1->(PC1_CODCLI+PC1_LOJA),"A1_VEND"),"A3_NOME"))+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Motivo: '+PC1->PC1_MOTIVO+' - '+POSICIONE("SX5", 1, xFilial("SX5") +"SK"+ PC1->PC1_MOTIVO, "X5_DESCRI") + '</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '                <BR>'
	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Reposição: '+Iif(Alltrim(PC1->PC1_REPOSI)="1","Sim","Não")+' - '+' Pedido: '+ Alltrim(PC1->PC1_PEDREP)+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	
	//FR - 03/11/2021 - TICKET #20211029023220
	_cMotLog := GetNewPar("ST_FTECLOG","501,502,503,504,505,506,507")
	//_cMailLog:= GetNewPar("ST_FATECMA" , "kleber.braga@steck.com.br") //FR - 11/11/2021 - este não pode porque já é usado para outros motivos
	_cMailLog:= GetNewPar("ST_FTECLGM" , "kleber.braga@steck.com.br")   //FR - 11/11/2021 - criado novo parâmetro

	If PC1->PC1_MOTIVO $ _cMotLog		
		//EMAIL QUE RECEBE A NOTIFICAÇÃO FATEC
		_cCopia += _cMailLog
		_cCopia += ";flah.rocha@gmail.com" 	                               
	Endif 
	//FR - 03/11/2021 - TICKET #20211029023220

	If !Empty(PC1->PC1_CODOBS)

		DbSelectArea("SYP")
		SYP->(DbSetOrder(1))
		SYP->(DbGoTop())
		SYP->(DbSeek(xFilial("SYP")+PC1->PC1_CODOBS))

		While SYP->(!Eof()) .And. SYP->YP_CHAVE==PC1->PC1_CODOBS
			_cObs += StrTran(SYP->YP_TEXTO,"\13\10","")
			SYP->(DbSkip())
		EndDo

	EndIf

	cMsg  += '                <tr>'
	cMsg  += '                    <td colspan="10" width="630" bgcolor="#DFEFFF"'
	cMsg  += '                    height="24"><p align="left"><font size="4"'
	cMsg  += '                    face="verdana"><b>Observação: '+_cObs+'</b></font></p>'
	cMsg  += '                    </td>'
	cMsg  += '                </tr>'
	cMsg  += '  </table>'
	cMsg  += '</body>'
	cMsg  += '</html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)  //FR TESTE VOLTAR	
	
Return()


/*/{Protheus.doc} getConfer
description
Rotina para informar a conferência, liberando a para recebimento físico
Ticket: 20210408005632
@type function
@version  
@author Valdemir Jose
@since 01/06/2021
@param paCols, param_type, param_description
@param pnAT, param_type, param_description
@return return_type, return_description
/*/
Static Function getConfer(	paCols, pnAT)
	Local lRET   := .F.
	Local lPerg  := .F.
	Local lTroca := .F.
	Local nX     := 0
	Local nTotal := 0
	Local cNotaF := ""
	Local cSerie := ""
	Local cUFisc := GetMV("ST_USRFISL",.F.,"001344/000250")
	Local cURece := GetMV("ST_USRRECB",.F.,"000414/000409/001375")
	Local cMsg   := "Conferência está OK?"
	Local cTitulo:= ""

	// Valida os status
	if PC1->PC1_STATUS=='5'
		FWMsgRun(,{|| sleep(4000)},'Informativo',"Não existe conferência, FATEC já Encerrada")
		Return
	elseif PC1->PC1_STATUS=="2" .AND. PC1->PC1_CONFER=="F"
		lPerg := .T.
	elseif PC1->PC1_STATUS=="3" .AND. PC1->PC1_CONFER=="R"
		FWMsgRun(,{|| sleep(4000)},'Informativo',"Não existe conferência, FATEC já Recebida Fisicamente")
		Return
	elseif (PC1->PC1_STATUS=="4") .or. (PC1->PC1_STATUS !="2")
		FWMsgRun(,{|| sleep(4000)},'Informativo',"Registro não pode ser conferido, por não estar autorizado")
		Return
	endif

	_lOK :=  (__cUSERID $ cUFisc) .OR. (__cUSERID $ cURece)
	if _lOK
		if (__cUSERID $ cUFisc)
			IF PC1->PC1_CONFER == "R"
				FWMsgRun(,{|| sleep(3000)},'Informativo',"Conferência de recebimento já realizado.")
				Return
			Endif
			_cConf := "F"
			cTitulo:= "Fiscal"
		Endif
		if (__cUSERID $ cURece)
			IF Empty(PC1->PC1_CONFER)
				FWMsgRun(,{|| sleep(3000)},'Informativo',"Conferência não realizada pelo Depto.Fiscal.")
				Return
			Endif
			_cConf := "R"
			cTitulo:= "Recebimento"
		Endif
	Else
		FWMsgRun(,{|| sleep(3000)},'Informativo',"Usuário não tem permissão para realizar conferência.")
		Return
	ENDIF

	if lPerg .and. (_cConf == "F")
		cMsg := "Deseja realizar a conferência novamente?"
	endif

	if MsgNoYes(cMsg, cTitulo)
	    if _cConf=="F"
			lTroca := MsgNoYes("É troca de nota?","Informação!")
			if lTroca
			   _cConf := "R"
			Endif 
		Endif 
		nTotal := 0
		For nX := 1 to Len(aColsForm)
			if !Empty(aColsForm[nX][1]) .and. Empty(cNotaF)
				cNotaF := aColsForm[nX][1]
				cSerie := aColsForm[nX][2]
			endif
			nTotal += CalcFatec(nX)
		Next
		RecLock("PC1", .F.)
		PC1->PC1_CONFER := _cConf
		if _cConf == "F"
			PC1->PC1_NFORIG := cNotaF
			PC1->PC1_SRORIG := cSerie
			PC1->PC1_TOTAL  := nTotal
		endif
		MsUnlock()

		// Envia Link
		if _cConf == "F"
			cNumNF := getNFPC2()                      // Busca o numero da primeira nota com base na PC1
			GRVPVZS3(cNumNF)                          // Posiciona SC5 e Grava ZS3
			u_ProcesAG(cNumNF)
			//StaticCall (JOBAGAPI, ProcesAG, cNumNF)    // Será disparado o WF para o e-mail informado na SC5
		Endif
		// Enviar WF para Fiscal
		if _cConf == "R"
		   EnvWF()   
		endif 
		FWMsgRun(,{|| sleep(3000)},"Informativo","Conferência confirmada com sucesso!")

	Endif

Return


/*/{Protheus.doc} CalcFatec
description
Rotina que fará o calculo por produto
Ticket: 20210408005632
@type function
@version  
@author Valdemir Jose
@since 01/06/2021
@param nlin, numeric, param_description
@return return_type, return_description
/*/
Static Function CalcFatec(nlin)
	Local nPCPRODUTO	:= GdFieldPos("CPRODUTO",aHeadForm)
	Local nPCNFSORIGI	:= GdFieldPos("CNFSORIGI",aHeadForm)
	Local nPCSERIEORI	:= GdFieldPos("CSERIEORI",aHeadForm)
	Local nPCITEM		:= GdFieldPos("CITEM",aHeadForm)
	Local nPCNQTDNOTA	:= GdFieldPos("NQTDNOTA",aHeadForm)
	Local nPCNQTDFATEC	:= GdFieldPos("NQTDFATEC",aHeadForm)
	Local _cProduto, _cNota, _cSerie, _cItem	:= ""
	Local _nQtdNota, _QtdFatec	:= 0
	Local _bIcms := _bIpi := _bIcmsSt := _vIcms := _vIpi := _vIcmsSt := _vTot := 0
	Local _newbIcms := _newbIpi := _newbIcmsSt := _newvIcms := _newvIpi := _newvIcmsSt := _newvTot := 0
	Local _totbIcms := _totbIpi := _totbIcmsSt := _totvIcms := _totvIpi := _totvIcmsSt := _totvTot := 0
	Local _aItens	:= {}

	_cProduto	:=	oNewGetDados:aCols[nlin ,nPCPRODUTO]
	_cNota		:=	oNewGetDados:aCols[nlin ,nPCNFSORIGI]
	_cSerie		:=	oNewGetDados:aCols[nlin ,nPCSERIEORI]
	_cItem		:=	oNewGetDados:aCols[nlin ,nPCITEM]
	_nQtdNota	:= 	oNewGetDados:aCols[nlin ,nPCNQTDNOTA]
	_nQtdFatec	:= 	oNewGetDados:aCols[nlin ,nPCNQTDFATEC]

	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	DbSeek(xFilial("SD2")+_cNota+_cSerie+M->PC1_CODCLI+M->PC1_LOJA+_cProduto+_cItem)

	If SD2->(!Eof())

		_bIcms		:= SD2->D2_BASEICM
		_bIpi		:= SD2->D2_BASEIPI
		_bIcmsSt	:= SD2->D2_BRICMS
		_vIcms		:= SD2->D2_VALICM
		_vIpi		:= SD2->D2_VALIPI
		_vIcmsSt	:= SD2->D2_ICMSRET
		_vTot		:= SD2->D2_PRCVEN

		_newbIcms	:= (_bIcms	*_nQtdFatec)/_nQtdNota
		_newbIpi	:= (_bIpi 	*_nQtdFatec)/_nQtdNota
		_newbIcmsSt	:= (_bIcmsSt*_nQtdFatec)/_nQtdNota
		_newvIcms	:= (_vIcms  *_nQtdFatec)/_nQtdNota
		_newvIpi	:= (_vIpi	*_nQtdFatec)/_nQtdNota
		_newvIcmsSt	:= (_vIcmsSt*_nQtdFatec)/_nQtdNota
		_newvTot	:= (_vTot	*_nQtdFatec)

		_totbIcms	+= _newbIcms
		_totbIpi	+= _newbIpi
		_totbIcmsSt	+= _newbIcmsSt
		_totvIcms	+= _newvIcms
		_totvIpi	+= _newvIpi
		_totvIcmsSt	+= _newvIcmsSt
		_totvTot	+= _newvTot+_newvIpi+_newvIcmsSt

	EndIf

Return _totvTot


/*/{Protheus.doc} getNFPC2
description
Rotina para pegar a primeira nota fiscal para posicionar o ZS3
@type function
@version  
@author Valdemir Jose
@since 12/05/2021
@return return_type, return_description
/*/
Static Function getNFPC2()
	Local cRET     := ""
	Local aAreaPC2 := GetArea()

	dbSelectArea("PC2")
	dbSetOrder(1)
	dbSeek(xFilial("PC2")+PC1->PC1_NUMERO)
	While PC2->( !Eof() ) .and. PC2->PC2_NFATEC==PC1->PC1_NUMERO
		if !Empty(PC2->PC2_NFORIG)
			cRET := PC2->PC2_NFORIG
			Exit
		Endif
		PC2->( dbSkip() )
	EndDo
	RestArea( aAreaPC2 )

Return cRET

/*/{Protheus.doc} GRVPVZS3
description
Rotina que valida e faz a gravação do agendamento
Ticket: 20210408005632
@type function
@version  
@author Valdemir Jose
@since 13/05/2021
@param cNumNF, character, param_description
@return return_type, return_description
/*/
Static Function GRVPVZS3(cNumNF)
	Local aAreaV  := GetArea()
	Local cQry    := ""
	Local nREG    := 0
	Local lSitAge := .F.

	cQry := "SELECT DISTINCT B.C5_NUM, B.R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("SC6") + " A " + CRLF
	cQry += "INNER JOIN " + RETSQLNAME("SC5") + " B " + CRLF
	cQry += "ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND B.D_E_L_E_T_ = ' ' " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND B.C5_FILIAL='"+XFILIAL('SC5')+"' " + CRLF
	cQry += " AND A.C6_NOTA='"+cNumNF+"' " + CRLF
	cQry += "ORDER BY C5_NUM"

	IF SELECT("TZS3") > 0
		TZS3->( dbCloseArea() )
	ENDIF

	TcQuery cQry New Alias 'TZS3'

	IF TZS3->( !EOF() )
		nREG := TZS3->REG
	EndIF

	RestArea( aAreaV )

	if nREG > 0
		SC5->( dbGoto(TZS3->REG) )
	endif
	lSitAge := getVLDAG(SC5->C5_NUM, cNumNF)
	U_GrvZS3(lSitAge) //StaticCall (APIAGEPD, GrvZS3, lSitAge)
	recLock("ZS3",.F.)
	ZS3->ZS3_NOTAFI := cNumNF
	MsUnlock()

Return


/*/{Protheus.doc} getVLDAG
description
Rotina que faz a validação da existência do registro de agendamento
@type function
@version  
@author Valdemir Jose
@since 13/05/2021
@param pPEDIDO, param_type, param_description
@param cNumNF, character, param_description
@return return_type, return_description
/*/
Static Function getVLDAG(pPEDIDO, cNumNF)
	Local aZS3 := GetArea()
	Local lRET := .T.
	Local nREG := 0
	Local cQry := "SELECT R_E_C_N_O_ REG " + CRLF

	dbSelectArea("ZS3")

	cQry += "FROM " + RETSQLNAME("ZS3") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND A.ZS3_FILIAL='"+XFILIAL('ZS3')+"' " + CRLF
	cQry += " AND (A.ZS3_PEDIDO='"+pPEDIDO+"' " + CRLF
	cQry += " AND  A.ZS3_NOTAFI='"+cNumNF+"')" + CRLF
	cQry += " AND  A.ZS3_DATAGE >='"+dtos(dDatabase)+"'" + CRLF

	if Select('TVLD') > 0
		TVLD->( dbCloseArea() )
	Endif

	TcQuery cQry New Alias "TVLD"

	if TVLD->( !Eof() )
		nREG := TVLD->REG
		lRET := !(nREG > 0)
	Endif

	if Select('TVLD') > 0
		TVLD->( dbCloseArea() )
	Endif

	RestArea( aZS3 )

	if !lRET
		ZS3->( dbGoto(nREG) )
	Endif

Return (lRET)

/*/{Protheus.doc} EnvWF
description
Rotina para enviar WF para o Fiscal após Conferência Fisica do Recebimento
@type function
@version  
@author Valdemir Jose
@since 10/06/2021
@param cNumNF, character, param_description
@return return_type, return_description
/*/
Static Function EnvWF()
	Local aArea     := Getarea()
	Local cMsg      := ""
	Local cCC       := ""
	Local _aMsg     := {}
	Local _cAssunto := ""
	Local cSubject  := "Fatec: "+PC1->PC1_NUMERO+" - Recebimento Fisico Conferido (Autorizado Lançamento)"
	Local cEmail    := GETMV("ST_CONFISC",.f.,"juliete.vieira@steck.com.br,marcelo.avelino@steck.com.br")
	Local _nLin

	aAdd(_aMsg, {"FATEC Nº ", PC1->PC1_NUMERO } )
	aAdd(_aMsg, {"Cod.Cliente", alltrim(PC1->PC1_CODCLI) } )
	aAdd(_aMsg, {"Loja", alltrim(PC1->PC1_LOJA) } )
	aAdd(_aMsg, {"Nome", alltrim(PC1->PC1_NOMCLI) } )
	aAdd(_aMsg, {"NF Devolução", PC1->PC1_NFDEV } )
	aAdd(_aMsg, {"Valor", Transform(PC1->PC1_TOTAL,"@R 999,999,999.99") } )
	aAdd(_aMsg, {"Data envio", dtoc(dDatabase)} )
	aAdd(_aMsg, {"Hora envio", Time() } )

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		if _nLin == 1
			cMsg += '<TD><B><Font Color=#FF0000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		else
			cMsg += '<TD><B>' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		endif
		cMsg += '<TD>' + _aMsg[_nLin,2] + ' </Font></TD>'
	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")


Return


//-------------------------------------------------------------------------------------//
//FR - 29/07/2022 - Flávia Rocha - Sigamat Consultoria - MELHORIA FATEC
//Alterações realizadas mediante Ticket #20220325006576 - Solicitado por Rosa Santos
//Ao liberar uma Fatec onde haja necessidade de se recolocar o pedido de venda, 
//criar este pedido de venda automaticamente
//neste caso será criado se o campo PC1_RECPV estiver com o conteúdo = "S" (Sim) 
//-------------------------------------------------------------------------------------//
//Função : RECPV - Chama o execauto de inclusão do Pedido de Venda
//Autoria: Flávia Rocha - Sigamat Consultoria
//Data   : 29/07/2022
//-------------------------------------------------------------------------------------//
Static Function RecPV(aCabec,aItens)

Local _nOpc  := 3

Private lMsErroAuto := .F.

If Len(aCabec) > 0 .and. Len(aItens) > 0
	
	_nOpc := 3 //incluir
	MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, _nOpc, .F.)

	If lMsErroAuto
	//deu erro
		_cErro := MostraErro()

		If !IsBlind()
			MsgAlert("Não Foi Possível Recolocar o Pedido de Venda")
		Endif
		//DisarmTransaction() //se ativar esta linha, em caso de erro, não vai deixa autorizar a Fatec, 
		//melhor deixar comentado para não impedir a autorização da Fatec, se for o caso inclui o pedido manualmente
 
	Else
	//deu certo

		If !IsBlind()
			MsgInfo("Pedido de Venda Re-Colocado -> Número: " + aCabec[2][2])
		Endif

		//atualiza o cabeçalho da Fatec
		If FieldPos("PC1_RECPVN") > 0
			If RecLock("PC1" , .F.)
				PC1->PC1_RECPVN  :=  aCabec[2][2]		//FR - 29/07/2022 - MELHORIA FATEC Ticket #20220325006576 - Solicitado por Rosa Santos 
				MsUnLock()
			Endif 
		Endif

		//atualiza operação
		SC6->(OrdSetFocus(1))  //C6_FILIAL + C6_NUM         + C6_ITEM        + C6_PRODUTO
		If SC6->(Dbseek(xFilial("SC6")     + aCabec[2][2] )) 
			While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == aCabec[2][2]
				Reclock("SC6", .F.)
				
				SC6->C6_OPER := "01"
				
				SC6->(MsUnlock())				
				
				SC6->(DbSkip())
			Enddo 
		Endif 
		
		//atualiza observação no cabeçalho do pedido:
		SC5->(OrdSetfocus(1))
		If SC5->(Dbseek(xFilial("SC5") + aCabec[2][2] ))
			If RecLock("SC5" , .F.)
				SC5->C5_ZOBS := "PEDIDO DE VENDA GERADO PELA FATEC: " + PC1->PC1_NUMERO
			Endif 
		Endif 

	Endif 
Endif 

Return
