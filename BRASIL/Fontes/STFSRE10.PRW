#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STFSRE10  ³ Autor ³ Luiz Enrique          ³ Data ³12/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³REALIZA O RECEBIMENTO DOS ITENS PROVENIENTES DE FATEC       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

User Function STFSRE10()
	Local   aButtons := {}
	Private oDlg1
	Private aAux 	:= {LoadBitmap( GetResources(), "LBOK"),LoadBitmap( GetResources(), "LBNO")}
	Private oFatec
	Private aFatec	:={}
	Private oItens
	Private aItens	:={}


	DEFINE FONT oFont NAME "Courier New" BOLD

	If ! U_STProducao()
		Return
	EndIf

	DEFINE MSDIALOG oDlg1 TITLE "Recebimento - FATEC" From 50,50 to 500,800 OF oMainWnd PIXEL

	//LISTA FATEC AUTORIZADAS
	@ 28,10 LISTBOX oFatec FIELDS HEADER " ","Codigo FATEC","Nota Fiscal","Serie","Cliente","Loja","Nome do Cliente","";
	SIZES {10,10,08,08,02,40,2} SIZE 490,095 OF oDlg1 PIXEL
	oFatec:align := CONTROL_ALIGN_TOP
	oFatec:bChange := {|| Detalhes()}

	//LISTA OS ITENS PARA RETORNO
	@ 135,10 LISTBOX oItens FIELDS HEADER "Nota Origem","Serie","Item","Produto","Descricao do Produto","Quantidade da Nota","Quantidade Fatec","";
	SIZES {10,5,5,15,30,12,12,02} SIZE 490,070 OF oDlg1 PIXEL
	oItens:align := CONTROL_ALIGN_ALLCLIENT

	MontaFatec()

	Aadd( aButtons, {"HISTORIC", {|| LegReceb()   } , "Legenda"} )
	//Aadd( aButtons, {"HISTORIC", {|| stConfer()   } , "Conferência"} )

	ACTIVATE DIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1, {|| U_STFSRE13(),oDlg1:End()},{|| oDlg1:End()},,@aButtons)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MontaFatec  ³ Autor ³ Luiz Enrique              ³ Data ³12/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Mostra os Processos Fatec Autorizados			                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function MontaFatec()

	PC1->(DbSetOrder(2)) // Indice por Status+Cliente+Loja
	PC1->(DbSeek(xFilial('PC1')+ "2"))
	aFatec:= {}
	While PC1->(!Eof() .and. PC1_FILIAL+PC1_STATUS == xFilial("PC1")+"2")
		PC1->(Aadd(aFatec,{PC1_CONFER,PC1_NUMERO,PC1_NOTAE,PC1_SERIEE,PC1_CODCLI,PC1_LOJA,PC1_NOMCLI}))
		PC1->(dbSkip())
	EndDo

	If Empty(aFatec)
		aFatec:={{Space(01),Space(06),Space(9),Space(3),Space(06),Space(02),Space(40),Space(2)}}
	EndIf

	oFatec:SetArray(aFatec)
	oFatec:bLine := {|| {	if(aFatec[oFatec:nAt,1] $"F",LoadBitmap( GetResources(), "BR_AZUL"),if(aFatec[oFatec:nAt,1]=="R", LoadBitmap( GetResources(), "BR_VERDE"   ), LoadBitmap( GetResources(), "BR_AMARELO" )) ),;
	aFatec[oFatec:nAt,2],aFatec[oFatec:nAt,3],aFatec[oFatec:nAt,4],;
	aFatec[oFatec:nAt,5],aFatec[oFatec:nAt,6],aFatec[oFatec:nAt,7]}}
	oFatec:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Detalhes  ºAutor  ³Luiz Enrique	     º Data ³  12/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Lista as Notas com seus respectivos Itens e Qtd para Retornoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK			                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Detalhes()

	aItens:={}

	If Empty(aFatec)
		Return
	Endif

	PC2->(DbSetORder(1)) // Indice por Codigo Fatec
	PC2->(DbSeek(xFilial('PC2')+ aFatec[oFatec:nAt,2]))

	While PC2->(!Eof() .and. PC2_FILIAL+PC2_NFATEC == xFilial("PC2")+ aFatec[oFatec:nAt,2])
		PC2->(Aadd(aItens,{	PC2_NFORIG,;
		PC2_SERIE,;
		PC2_ITEM,;
		PC2_PRODUT,;
		PC2_DESPRO,;
		Transform(PC2_QTDNFS,"@E 99999999.99"),;
		Transform(PC2_QTDFAT,"@E 99999999.99")}))
		PC2->(dbSkip())
	EndDo

	If Empty(aItens)
		aItens:={{Space(09),Space(03),Space(02),Space(15),Space(30),0,0}}
	EndIf

	oItens:SetArray( aItens )
	oItens:bLine := {|| {	aItens[oItens:nAt,1],aItens[oItens:nAt,2],aItens[oItens:nAt,3],;
	aItens[oItens:nAt,4],aItens[oItens:nAt,5],aItens[oItens:nAt,6],aItens[oItens:nAt,7]}}

	aSort(aItens,,, { |x,y| x[01]+x[02]+x[03]+x[04] < y[01]+y[02]+y[03]+y[04] } )
	oItens:Refresh()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STFSRE11  ³ Autor ³ Luiz Enrique          ³ Data ³12/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Consiste os Itens e Quantidades da Nota fiscal de Devolucao ³±±
±±³			 ³com os itens correspondentes existentes na FATEC (PC2) na   ³±±
±±³			 ³confirmacao da NFE.												     ³±±
±±³			 ³Chamado pelo Ponto de Entrada: MT100TOK (MATA103)		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSRE11()

	Local nit
	Local cMsg			:= "Existem inconsistências nesta nota fiscal e a mesma não poderá ser incluída no sistema!"
	Local lRet			:= .t.
	Local nPD1_COD		:= GdFieldPos("D1_COD")
	Local nPD1_QUANT	:= GdFieldPos("D1_QUANT")
	Local nPD1_XFATEC	:= GdFieldPos("D1_XFATEC")
	Local nPD1_NFORI	:= GdFieldPos("D1_NFORI")
	Local nPD1_SERIORI:= GdFieldPos("D1_SERIORI")
	Local nPD1_ITEMORI:= GdFieldPos("D1_ITEMORI")

	Local cProduto
	Local cCodFatec
	Local cNotaOri
	Local cSeriOri
	Local cItenOri
	Local cQtdFatec
	Local cQtdNfe

	If ! U_STProducao()
		Return
	EndIf

	//Validacao exclusiva para FATEC
	//INICIO
	If IsInCallStack("U_STFSRE10") .Or. !Empty(SF1->F1_XFATEC)
		PC2->(DbSetORder(1)) // Indice por: Codigo Fatec + Nota + Serie + Produto + Item
		For nit:= 1 to Len(acols)
			cProduto	:= Padr(aCols[nit,nPD1_COD],15)
			cCodFatec   := Padr(aCols[nit,nPD1_XFATEC],6)
			cNotaOri	:= Padr(aCols[nit,nPD1_NFORI],9)
			cSeriOri	:= Padr(aCols[nit,nPD1_SERIORI],3)
			cItenOri	:= Padr(aCols[nit,nPD1_ITEMORI],2)

			If Empty(cCodFatec)
				lRet := .F.
				cMsg:= "O Produto " + Alltrim(cProduto)+ ", Item " + aCols[nIt,1] + " não possui código de FATEC"
				Exit
			EndIf

			If !PC2->(DbSeek(xFilial('PC2')+ cCodFatec+cNotaOri+cSeriOri+cProduto/*+cItenOri*/))
				cMsg:= "O Produto " + Alltrim(cProduto)+ ", Item " + cItenOri + " da nota de Origem "+;
				Alltrim(cNotaOri) + "-" + Alltrim(cSeriOri) + ", nao foi encontrado na FATEC: " + Alltrim(cCodFatec)
				lRet:= .f.
				Exit
			Endif

			PC2->(DbSeek(xFilial('PC2')+cCodFatec+cNotaOri+cSeriOri+cProduto+cItenOri)) //[Renato - 090513] Adicionado pois estava apresentando erro com notas com mais de um item do mesmo produto

			aCols[nit,nPD1_QUANT] := StrTran(cValToChar(aCols[nit,nPD1_QUANT]),".")
			aCols[nit,nPD1_QUANT] := Val(aCols[nit,nPD1_QUANT])

			cQtdNfe	:= Transform(aCols[nit,nPD1_QUANT]  	,"@E 999,999.999")
			cQtdFatec:= Transform(PC2->PC2_QTDFAT	   		,"@E 999,999.999")

			If cQtdNfe <> cQtdFatec
				cMsg:= 	"O Produto " + Alltrim(cProduto)+ ", Item " + cItenOri + ", com Quantidade de" + cQtdNfe +;
				" difere da quantidade informada na FATEC: " + Alltrim(cCodFatec) + " correspondente a" + cQtdFatec
				lRet:= .f.
				Exit
			Endif

		Next
	Endif
	//FIM

	If !lret
		Aviso("Atencao",cMsg,{"SAIR"},2)
	Endif

Return lret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STFSRE12  ³ Autor ³ Luiz Enrique          ³ Data ³12/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime Etiqueta de Identificacao FATEC.         			  ³±±
±±³			 ³Chamado pelo Menu.													     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³STECK                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
User Function STFSRE12()
	Local cFatec	:= Space(TamSX3("PC1_NUMERO")		[01])
	Local nQtdVol	:= 0
	Local cObs1		:= Space(20)
	Local cObs2		:= Space(20)
	Local	cLocImp	:= Space(06)
	Local aParBox  := {}
	Local	aRetPar  := {}

	aParBox :={	{1,"Fatec	"			,	cFatec	,	""			,"","PC1FSW",".T.",0,.T.},;
	{1,"Qtde de volumes"	,	nQtdVol	,	"@E 999"	,"",""		,".T.",0,.T.},;
	{1,"Observação 1"		,	cObs1		,	""			,"",""		,".T.",0,.F.},;
	{1,"Observação 2"		,	cObs2		,	""			,"",""		,".T.",0,.F.},;
	{1,"Local Impressao"	,	cLocImp	,	""			,"","CB5"	,".T.",0,.T.}}



	If !ParamBox(aParBox,"Parametros",@aRetPar,,,,,,,,.f.)
		Return
	Endif

	cFatec	:= aRetPar[1]
	nQtdVol	:= aRetPar[2]
	cObs1		:= aRetPar[3]
	cObs2		:= aRetPar[4]
	cLocImp	:= aRetPar[5]

	PC1->(DbSetOrder(1))
	If !PC1->(DbSeek(xFilial("PC1")+cFatec))
		MsgAlert("Fatec não encontrada !","Aviso")
		Return
	Endif

	CB5->(dbsetOrder(1))
	If !CB5->(dbSeek(xFilial()+Trim(cLocImp)))
		MsgAlert("Local de Impressão Inválido")
		Return
	Endif

	//Configura a Impressora
	CB5SetImp(cLocImp)
	MsgRun("Imprimindo Etiqueta",,{|| Imprime(nQtdVol,cObs1,cObs2) })
	MSCBCLOSEPRINTER()
	MsgAlert("Impressão Finalizada.")

Return

Static Function Imprime(nQtdVol,cObs1,cObs2)
	Local nLinH		:= 0
	Local nLinV 	:= 0
	Local cCliente := Substr(Posicione("SA1",1,xFilial("SA1")+PC1->(PC1_CODCLI+PC1_LOJA),"A1_NOME"),1,20)
	Local nX			:= 1

	MSCBInfoEti("FATEC","")
	For nX := 1 to nQtdVol
		MSCBBEGIN(1,6)

		MSCBSAY(nLinH+15,30,DtoC(dDataBase)																	,"B","0","035,040")
		MSCBSAY(nLinH+22,40,"FATEC "+Alltrim(PC1->PC1_NUMERO)												,"B","0","035,040")
		MSCBSAY(nLinH+32,20,AllTrim(cCliente)																,"B","0","035,040")
		MSCBSAY(nLinH+37,20,AllTrim(cObs1)																	,"B","0","035,040")
		MSCBSAY(nLinH+42,20,AllTrim(cObs2)																	,"B","0","035,040")
		MSCBSAY(nLinH+51,21,Strzero(nX,3)+"/"+Strzero(nQtdVol,3)											,"B","0","035,040")
		MSCBSAY(nLinH+66,21,"NF " + Alltrim(PC1->PC1_NOTAE)+"-"+Alltrim(PC1->PC1_SERIEE)					,"B","0","035,040")
		MSCBSAY(nLinH+74,21,SubStr(Alltrim(Posicione("SX5",1,xFilial("SX5")+"SK"+PC1->PC1_MOTIVO,"X5_DESCRI")),1,20)		,"B","0","035,040")
		MSCBSAY(nLinH+81,21,SubStr(Alltrim(Posicione("SX5",1,xFilial("SX5")+"SK"+PC1->PC1_MOTIVO,"X5_DESCRI")),20,20)		,"B","0","035,040")


		MSCBEND()
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE10  ºAutor  ³Microsiga           º Data ³  02/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega os dados da FATEC na interface do MATA103           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSRE13()
	Local lFlagDev	:= .T.
	Local lRestDev	:= .F.
	Local lCliente	:= .T.
	Local lPoder3  := .T.
	Local aLinha	:= {}
	Local aItens	:= {}
	Local aCab		:= {}
	Local cTipoNF	:= "D"
	Local cDocSF2	:= ""
	Local aTitles		:= {}
	Local aFldCBAtu
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local cMsg		:= ""
	Local _aArea	:= {}
	Local _aAreaSD2	:= {}

	Private cCliente := Padr(aFatec[oFatec:nAt,5],6)
	Private cLoja    := Padr(aFatec[oFatec:nAt,6],2)
	Private cQrDvF2  := ""

	// ------------ Valdemir Rabelo Ticket: 20210408005632 -------
	IF Empty(aFatec[oFatec:nAt,1])
	   FWMsgRun(,{|| Sleep(4000) },"Informativo","O registro selecionado não foi realizado a conferência Fiscal.")
	   Return
	Endif
	IF (aFatec[oFatec:nAt,1] == "F")
	   FWMsgRun(,{|| Sleep(4000) },"Informativo","O registro selecionado não foi realizado a conferência de Recebimento.")
	   Return
	Endif 
	// ---------------------------------------------------------

	INCLUI := .T.

	SF2->(DbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	SF2->(DbSeek(xFilial("SF2")+Padr(aFatec[oFatec:nAt,3],9)+Padr(aFatec[oFatec:nAt,3],3)+Padr(aFatec[oFatec:nAt,5],6)+Padr(aFatec[oFatec:nAt,6],2)))

	//Renato Nogueira - 06/08/2014 - Verificar se não existe nenhuma unidade de medida sem preencher
	_aAreaSD2	:= GetArea("SD2")
	_aArea		:= GetArea()

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())
	SD2->(DbSeek(xFilial("SD2")+oItens:AARRAY[1][1]+oItens:AARRAY[1][2]+cCliente+cLoja))

	While SD2->(!Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)==xFilial("SD2")+oItens:AARRAY[1][1]+oItens:AARRAY[1][2]+cCliente+cLoja
		If Empty(SD2->D2_UM)
			DbSelectArea("SB1")
			DbSetOrder(1) //B1_FILIAL+B1_COD
			DbSeek(xFilial("SB1")+SD2->D2_COD)
			If !SB1->(Eof())
				RecLock("SD2",.F.)
				SD2->D2_UM	:= SB1->B1_UM
				MsUnLock()
			EndIf
		EndIf
		SD2->(DbSkip())
	EndDo

	RestArea(_aArea)
	RestArea(_aAreaSD2)

	cDocSF2	:= "( SD2.D2_DOC = '" + SF2->F2_DOC + "' AND SD2.D2_SERIE = '" + SF2->F2_SERIE + "'))"
	lFlagDev	:= SF2->(FieldPos("F2_FLAGDEV")) > 0  .And. GetNewPar("MV_FLAGDEV",.F.)

	aItens := MontaNF()

	AAdd( aCab, { "F1_DOC"    , CriaVar("F1_DOC",.F.)													, Nil })
	AAdd( aCab, { "F1_SERIE"  , CriaVar("F1_SERIE",.F.)													, Nil })
	AAdd( aCab, { "F1_TIPO"   , cTipoNF             											     	, Nil })
	AAdd( aCab, { "F1_FORNECE", cCliente	    														, Nil })
	AAdd( aCab, { "F1_LOJA"   , cLoja    														   		, Nil })
	AAdd( aCab, { "F1_EMISSAO", dDataBase    												       		, Nil })
	AAdd( aCab, { "F1_FORMUL" , "S"         											        		, Nil })
	AAdd( aCab, { "F1_ESPECIE", "SPED "																	, Nil })

	Mata103( aCab, aItens , 3 , .T.)


	//IF len(aItens) >0
	//SALVA DADOS DE FATEC, VALOR FRETE E VALOR MERCADORIA (SD1) NA TABELA QEK (INSPEÇÃO DE ENTRADA)
	//COM O CÓDIGO DA FATEC BUSCO O NUMERO E A NOTA DE SAÍDA PARA ASSIM INCLUIR O REGISTRO NA TABELA QEK
	//JOIN COM A NOTA DE SAÍDA.
	U_STFSRE16()
	//ENDIF

	If !(SF1->F1_DOC==QEK->QEK_NTFISCAL)
		MsgAlert("Atenção, problema ao gravar inspeção de entrada, entre em contato com o T.I.")
		MsgAlert("Atenção, problema ao gravar inspeção de entrada, entre em contato com o T.I.")
		ConOut("Problema ao gerar inspeção de entrada, NF: "+SF1->F1_DOC+" NFQEK: "+QEK->QEK_NTFISCAL)
	EndIf

	If Empty(QEK->QEK_XFATEC)
		MsgAlert("Atenção, a fatec não foi preenchida na inspeção de entrada, entre em contato com o T.I.")
		MsgAlert("Atenção, a fatec não foi preenchida na inspeção de entrada, entre em contato com o T.I.")
	EndIf

	If lFlagDev
		lRestDev := M103FilDv(@aLinha,@aItens,cDocSF2,cCliente,cLoja,lCliente,@cTipoNF,@lPoder3,.F.)
		If !lRestDev
			RecLock("SF2",.F.)
			SF2->F2_FLAGDEV := "1"
			MsUnLock()
		Endif
	Endif

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>Documento: </b>'+Alltrim(SF1->F1_DOC)+'<br><b>Cliente: </b>'+Alltrim(SD1->D1_FORNECE)+'<br>'
	cMsg += '<b>Nome: </b>'+Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NOME")+'<br><b>Fatec: </b>'+SD1->D1_XFATEC+'<br>'
	cMsg += '<b>Nf Ori: </b>'+Alltrim(SD1->D1_NFORI)+'<br>'
	cMsg += '<b>Motivo: </b>'+POSICIONE("SX5",1,XFILIAL("SX5")+"SK" + PC1->PC1_MOTIVO,"X5DESCRI()")+'<br>'
	cMsg += '<b>Obs: </b>'+'<br>'

	DbSelectArea("SYP")
	SYP->(DbSetOrder(1))
	SYP->(DbGoTop())
	SYP->(DbSeek(xFilial("SYP")+PC1->PC1_CODOBS))

	While SYP->(!Eof()) .And. SYP->YP_CHAVE==PC1->PC1_CODOBS
		cMsg += StrTran(SYP->YP_TEXTO,"\13\10","")+'<br>'
		SYP->(DbSkip())
	EndDo

	cMsg += '</body></html>'

	If !U_STMAILTES(GetMv("ST_EMLFATE"), "", "Entrada de doc por fatec",cMsg,_aAttach,_cCaminho) //Renato Nogueira - Chamado 000073 - Enviar e-mail após autorização da fatec.
		VtAlert("Problemas no envio de email!")
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE10  ºAutor  ³Microsiga           º Data ³  02/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta array para passar na funcao de nota fiscal de entrada º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaNF()
	Local nI
	Local aLinha	:= {}
	Local aItOld	:= aClone(aItens)
	Local nSldDev	:= 0
	Local cTesDev	:= "001"
	Local cCfop		:= ""

	aItens := {}

	SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SF4->(DbSetOrder(1))

	For nI:=1 to len(aItOld)
		If !SD2->(DbSeek(xFilial("SD2")+	Padr(aItOld[nI,1],9)+Padr(aItOld[nI,2],3)+Padr(aFatec[oFatec:nAt,5],6)+Padr(aFatec[oFatec:nAt,6],2)+Padr(aItOld[nI,4],15)+Padr(aItOld[nI,3],2)))
			MsgAlert("A busca do item: "+SD2->(Padr(aItOld[nI,4],15))+" na tabela SD2 não retornou registro!")
			Loop
		Endif

		If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))
			If !(Empty(SF4->F4_TESDV) .Or. !(SF4->(MsSeek(xFilial("SF4")+SF4->F4_TESDV))))
				cTesDev := SF4->F4_CODIGO
			EndIf

			If ("000" $ AllTrim(SF4->F4_CF) .Or. "999" $ AllTrim(SF4->F4_CF))
				cCfop := AllTrim(SF4->F4_CF)
			Else
				cCfop := SubStr("123",At(SubStr(SD2->D2_CF,1,1),"567"),1)+SubStr(SD2->D2_CF,2)
				SX5->( dbSetOrder(1) )
				If !SX5->(MsSeek( xFilial("SX5") + "13" + cCfop ))
					cCfop := AllTrim(SF4->F4_CF)
				EndIf
			EndIf
		EndIf

		nSldDev	:= SD2->D2_QUANT-SD2->D2_QTDEDEV
		nQtdeDev	:= SuperVal(aItOld[nI,7])
		If nSldDev < nQtdeDev
			Loop
		Endif

		aLinha	:= {}
		AAdd( aLinha, { "D1_COD"    , SD2->D2_COD		, Nil } )
		AAdd( aLinha, { "D1_QUANT"  , nQtdeDev			, Nil } )

		If SD2->D2_QUANT==nQtdeDev
			If SD2->D2_DESCON+SD2->D2_DESCZFR == 0
				AAdd( aLinha, { "D1_VUNIT"	, SD2->D2_PRCVEN, Nil })
			Else
				AAdd( aLinha, { "D1_VUNIT"	, (SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR)/SD2->D2_QUANT, Nil })
			EndIf
			AAdd( aLinha, { "D1_TOTAL"  	, SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR,Nil } )
			AAdd( aLinha, { "D1_VALDESC"	, SD2->D2_DESCON+SD2->D2_DESCZFR , Nil } )
		Else
			AAdd( aLinha, { "D1_VUNIT"		, (SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR)/SD2->D2_QUANT, Nil })
			AAdd( aLinha, { "D1_TOTAL"		, A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
			AAdd( aLinha, { "D1_VALDESC"	, A410Arred(SD2->D2_DESCON/SD2->D2_QUANT*aLinha[2][2],"D1_VALDESC"),Nil } )
		EndIf
		AAdd( aLinha, { "D1_IPI"		, SD2->D2_IPI    , Nil } )
		AAdd( aLinha, { "D1_LOCAL"		, SD2->D2_LOCAL  , Nil } )
		AAdd( aLinha, { "D1_TES"		, cTesDev , Nil } )
		AAdd( aLinha, { "D1_CF"			, cCfop, Nil } )
		AAdd( aLinha, { "D1_UM"			, SD2->D2_UM , Nil } )

		If Rastro(SD2->D2_COD)
			AAdd( aLinha, { "D1_LOTECTL", SD2->D2_LOTECTL, ".T." } )
			If SD2->D2_ORIGLAN == "LO"
				If Rastro(SD2->D2_COD,"L") .AND. !Empty(SD2->D2_NUMLOTE)
					AAdd( aLinha, { "D1_NUMLOTE", Nil , ".T." } )
				Else
					AAdd( aLinha, { "D1_NUMLOTE", SD2->D2_NUMLOTE, ".T." } )
				EndIf
			Else
				AAdd( aLinha, { "D1_NUMLOTE", SD2->D2_NUMLOTE, ".T." } )
			EndIf

			AAdd( aLinha, { "D1_DTVALID", SD2->D2_DTVALID, ".T." } )
			AAdd( aLinha, { "D1_POTENCI", SD2->D2_POTENCI, ".T." } )
		EndIf
		AAdd( aLinha, { "D1_NFORI"  , SD2->D2_DOC    , Nil } )
		AAdd( aLinha, { "D1_SERIORI", SD2->D2_SERIE  , Nil } )
		AAdd( aLinha, { "D1_ITEMORI", SD2->D2_ITEM   , Nil } )
		AAdd( aLinha, { "D1_ICMSRET", SD2->D2_ICMSRET, Nil } )
		If SF4->F4_PODER3=="D"
			AAdd( aLinha, { "D1_IDENTB6", SD2->D2_NUMSEQ, Nil } )
		Endif
		AAdd( aLinha, { "D1_XFATEC", aFatec[oFatec:nAt,2] 	, Nil } )
		AAdd( aLinha, { "D1RECNO"	,SD2->(RECNO()), Nil } )
		AAdd( aItens, aLinha)
	Next


Return aClone(aItens)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE10  ºAutor  ³Microsiga           º Data ³  03/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizacao do processo de FATEC                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSRE14()
	Local aArea 	:= GetArea()
	Local aAreaSD1	:= SD1->(GetArea('SD1'))
	Local cFatec	:= ""
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''

	SD1->(DbSetOrder(1))
	SD1->(dbSeek(xFilial("SF1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))	)
	While SD1->(!EOF() .and. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA ==  ;
	xFilial('SD1')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		If (!Empty(cFatec := (SD1->D1_XFATEC)))
			Exit
		Endif
		SD1->(DbSkip())
	End

	If !Empty(cFatec)
		PC1->(DbSetOrder(1)) //PC1_FILIAL+PC1_NUMERO+PC1_NOTAE+PC1_SERIEE
		If PC1->(DbSeek(xFilial("PC1")+cFatec))

			_cEmail := "renato.oliveira@steck.com.br"

			If !Empty(PC1->PC1_USERGI) .Or. !Empty(PC1->PC1_CODUSR)

				If !Empty(PC1->PC1_CODUSR)
					_cEmail	:= UsrRetMail(PC1->PC1_CODUSR)+";"
				Else
					_cEmail	:= AllTrim(FWLEUSERLG("PC1->PC1_USERGI",1))+"@steck.com.br;"
				EndIf

				DbSelectArea("SA3")
				SA3->(DbSetOrder(7))
				If SA3->(DbSeek(xFilial("SA3")+PC1->PC1_CODUSR))
					SA3->(DbSetOrder(1))
					If SA3->(DbSeek(xFilial("SA3")+SA3->A3_XSUPINT))
						_cEmail += SA3->A3_EMAIL
					EndIf
				EndIf

			EndIf

			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Fatec: </b>'+Alltrim(PC1->PC1_NUMERO)+'<br><b>Dt ocorrência: </b>'+DTOC(PC1->PC1_DTOCOR)
			cMsg += '<br><b>Cliente: </b>'+Alltrim(PC1->PC1_NOMCLI)
			cMsg += '<br><b>Atendente: </b>'+Alltrim(PC1->PC1_ATENDE)
			cMsg += '<br><b>Pedido: </b>'+Alltrim(PC1->PC1_PEDREP)
			cMsg += '<br><b>Status: </b>'+GETSTATUS(PC1->PC1_STATUS)
			cMsg += '</body></html>

			PC1->(RecLock("PC1",.F.))
			If PC1->PC1_MOTIVO < "500"
				PC1->PC1_STATUS := "5"

				_cAssunto	:= "Fatec: "+PC1->PC1_NUMERO+" encerrada"

				If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					MsgInfo("Problemas no envio de email!")
				EndIf

			Else
				PC1->PC1_STATUS := "3"
				
				_cAssunto	:= "Fatec: "+PC1->PC1_NUMERO+" recebida"

				If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					MsgInfo("Problemas no envio de email!")
				EndIf

			Endif
			PC1->(MsUnlock())
		Endif
	Endif

	RestArea(aAreaSD1)
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE10  ºAutor  ³Microsiga           º Data ³  03/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Volta o status da FATEC na exclusao da nota de devolucao    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSRE15()
	Local aArea		:= GetArea()
	Local aPC1Area	:= PC1->(GetArea())

	If Empty(SD1->D1_XFATEC)
		Return
	Endif

	PC1->(DbSetOrder(1)) //PC1_FILIAL+PC1_NUMERO+PC1_NOTAE+PC1_SERIEE
	If PC1->(DbSeek(xFilial("PC1")+SD1->D1_XFATEC))
		PC1->(RecLock("PC1",.F.))
		PC1->PC1_STATUS := "2"
		PC1->PC1_CONFER := ""           // Ticket: 20210408005632
		PC1->(MsUnlock())
	Endif

	RestArea(aPC1Area)
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE16  ºAutor  ³Microsiga           º Data ³  03/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Volta o status da FATEC na exclusao da nota de devolucao    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSRE16()

	Local aArea		:= GetArea()
	Local aQEKArea	:= QEK->(GetArea())
	Local _cFilial, _cNf, _cSerie, _cDt, _cFatec

	If Empty(SD1->D1_XFATEC)
		Return
	Endif

	_cFilial	:=  SD1->D1_FILIAL
	_cNf		:=	SD1->D1_DOC
	_cSerie		:=	SD1->D1_SERIE
	_cDt    	:=  DTOS(SD1->D1_EMISSAO)
	_cFatec     :=	SD1->D1_XFATEC

	QEK->(DbSetOrder(15)) //QEK_NTFISC+QEK_SERINF+QEK_DTNFIS+QEK_ITEMNF
	If QEK->(DbSeek(xFilial("QEK")+SF1->F1_DOC+SF1->F1_SERIE+DTOS(SF1->F1_EMISSAO)+SD1->D1_ITEM))
		QEK->(RecLock("QEK",.F.))
		QEK->QEK_XFATEC := SD1->D1_XFATEC
		QEK->QEK_VALFRE := SF1->F1_FRETE
		QEK->QEK_VALMER := SF1->F1_VALMERC
		QEK->(MsUnlock())
		MsgInfo("Inspeção de entrada feita com sucesso!")
	Else
		MsgAlert("Atenção, essa nota não gerou inspeção de entrada, verifique com o T.I.")
	Endif

	QEK->(DbGoTop())
	QEK->(DbSetOrder(15)) //QEK_NTFISC+QEK_SERINF+QEK_DTNFIS+QEK_ITEMNF
	QEK->(DbSeek(xFilial("QEK")+_cNf+_cSerie+_cDt))

	While QEK->(!Eof()) .And. xFilial("QEK")+QEK->QEK_NTFISC+QEK->QEK_SERINF+DTOS(QEK->QEK_DTNFIS) == _cFilial+_cNf+_cSerie+_cDt //Renato Nogueira - 230813 - Solicitado por Fabio Lessa - Preencher todos os itens da QEK com o número da FATEC

		If Empty(QEK->QEK_XFATEC)
			QEK->(RecLock("QEK",.F.))
			QEK->QEK_XFATEC := _cFatec
			QEK->(MsUnlock())
		EndIF

		QEK->(DbSkip())

	End

	RestArea(aQEKArea)
	RestArea(aArea)

Return

Static Function EMAILUSR(_cNome)

	Local aUsuario	:= {}
	Local _cEmail	:= ""
	Local nx	:= 0

	aUsuario	:= AllUsers()

	For nX :=1 to Len(aUsuario)
		If SubStr(aUsuario[nX][1][4],1,15)==_cNome
			_cEmail	:= aUsuario[nX][1][14]
		EndIf
	Next

Return(_cEmail)

Static Function M103FilDv(aLinha,aItens,cDocSF2,cCliente,cLoja,lCliente,cTipoNF,lPoder3,lHelp,nHpP3,lHelpTES)

	Local cAliasSD2 := "SD2"
	Local cAliasSF4 := "SF4"
	Local nSldDev   := 0
	Local nSldDevAux:= 0  
	Local nDesc     := 0
	Local nTotal	:= 0
	Local lDevolucao:= .T.
	Local lQuery    := .F.
	Local lMt103FDV := ExistBlock("MT103FDV")
	Local lDevCode	:= .F.
	Local cCfop     := ""
	Local cFilSX5   := xFilial("SX5")
	Local cNFORI  	:= ""
	Local cSERIORI	:= ""
	Local cITEMORI	:= "" 
	Local nVlCompl  := 0
	Local aSaldoTerc:= {}

	Local lCompl    := (GetNewPar("MV_RTCOMPL","S") == "S")

	Local nTpCtlBN  := If(FindFunction("A410CtEmpBN"), A410CtEmpBN(), If(SD4->(FieldPos("D4_NUMPVBN")) > 0, 1, 0))
	Local aAreaAnt	:= GetArea()
	Local cNewDSF2	:= ""
	Local cDSF2Aux	:= ""
	Local nPosDiv	:= 0
	Local nX		:= 0
	Local lTravou	:= .F.
	Local lExit		:= .F.

	#IFDEF TOP
	Local aStruSD2 := {}
	Local cQuery   := ""
	Local cAliasCpl := ""
	#ELSE
	Local cIndex   := ""
	Local cIndexCpl:= ""
	Local aAreaSD2 := {}
	Local nY	   := 0
	#ENDIF

	Default lHelp := .T.
	Default lHelpTES := .T.

	If !Empty(cDocSF2)												// Selecao foi feita por "Cliente/Fornecedor"
		#IFDEF TOP
		cNewDSF2 := StrTran(StrTran(cDocSF2,"('",),"')",)		
		#ELSE
		cDSF2Aux := cDocSF2										// Para ambiente diferente de TOP equaliza string que contem as notas a devolver para continuar a validacao de reserva de registro
		For nY := 1 To Len(cDSF2Aux)
			nPosDiv := At("'",cDSF2Aux)
			If nPosDiv > 0
				cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+1),Len(cDSF2Aux))
				nPosDiv := At("'",cDSF2Aux)
				cNewDSF2 += SubStr(cDSF2Aux,1,(nPosDiv-1))					// Numero
				cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+1),Len(cDSF2Aux))
				nPosDiv := At("'",cDSF2Aux)
				cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+1),Len(cDSF2Aux))
				nPosDiv := At("'",cDSF2Aux)
				cNewDSF2 += SubStr(cDSF2Aux,1,(nPosDiv-1))					// Serie
				cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+1),Len(cDSF2Aux))
				nPosDiv := At("'",cDSF2Aux)
				If nPosDiv > 0
					cNewDSF2 += "','"										// Separador entre notas
				Else
					Exit
				EndIf
			EndIf
		Next nY
		#ENDIF
		nPosDiv := At("','",cNewDSF2)								// String ',' identifica que foi selecionada mais de uma nota de saida
		If nPosDiv == 0												// Se foi selecionada apenas uma nota de saida
			DbSelectArea("SF2")
			DbSetOrder(1)
			If MsSeek(xFilial("SF2")+cNewDSF2+cCliente+cLoja)
				lTravou := SoftLock("SF2")							// Tenta reservar o registro para prosseguir com o processo
			Else
				dbGoTop()
			EndIf
		Else														// Se foi selecionada mais de uma nota de saida 
			cDSF2Aux := cNewDSF2
			For nX := 1 to Len(cDSF2Aux)
				nPosDiv := At("','",cDSF2Aux)
				If nPosDiv > 0
					cNewDSF2 := SubStr(cDSF2Aux,1,(nPosDiv-1))		// Extrai a primeira nota/serie da string
					cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+3),Len(cDSF2Aux)) // Grava nova string sem a primeira nota/serie
				Else
					cNewDSF2 := cDSF2Aux
					lExit := .T.
				EndIf
				If !Empty(cNewDSF2)
					DbSelectArea("SF2")
					DbSetOrder(1)
					If MsSeek(xFilial("SF2")+cNewDSF2+cCliente+cLoja)
						lTravou := SoftLock("SF2")					// Tenta reservar todos os registros para prosseguir com o processo
					Else
						dbGoTop()
					EndIf
				EndIf
				If lExit
					Exit
				EndIf
			Next nX
		EndIf
		RestArea(aAreaAnt)
	Else
		lTravou := SoftLock("SF2")
	EndIf

	If lTravou
		DbSelectArea("SD2")
		DbSetOrder(3)
		#IFDEF TOP
		lQuery    := .T.
		cAliasSD2 := "Oms320Dev"
		cAliasSF4 := "Oms320Dev"
		aStruSD2  := SD2->(dbStruct())
		cQuery    := "SELECT SF4.F4_CODIGO, SF4.F4_CF, SF4.F4_PODER3, SD2.*, SD2.R_E_C_N_O_ SD2RECNO "
		cQuery    += " FROM "+RetSqlName("SD2")+" SD2,"
		cQuery    += RetSqlName("SF4")+" SF4 "
		cQuery    += " WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		If !lCliente
			cQuery    += "SD2.D2_DOC   = '"+SF2->F2_DOC+"' AND "
			cQuery    += "SD2.D2_SERIE = '"+SF2->F2_SERIE+"' AND "   
		Else
			If !Empty(cDocSF2)     
				If UPPER(Alltrim(TCGetDb()))=="POSTGRES" 
					cQuery += " Concat(D2_DOC,D2_SERIE) IN "+cDocSF2+" AND "
				Else
					cQuery += " D2_DOC||D2_SERIE IN "+cDocSF2+" AND "
				EndIf
			EndIf
		EndIf
		cQuery    += " SD2.D2_CLIENTE   = '"+cCliente+"' AND "
		cQuery    += " SD2.D2_LOJA      = '"+cLoja+"' AND "
		cQuery    += " ((SD2.D2_QTDEDEV < SD2.D2_QUANT) OR "
		cQuery    += " (SD2.D2_VALDEV  = 0)) AND "		
		cQuery    += " SD2.D_E_L_E_T_  = ' ' AND "
		cQuery    += " SF4.F4_FILIAL   = '"+xFilial("SF4")+"' AND "
		cQuery    += " SF4.F4_CODIGO   = (SELECT F4_TESDV FROM "+RetSqlName("SF4")+" WHERE "
		cQuery    += " F4_FILIAL	   = '"+xFilial("SF4")+"' AND "
		cQuery    += " F4_CODIGO	   = SD2.D2_TES AND "
		cQuery    += " D_E_L_E_T_	   = ' ' ) AND "
		cQuery    += " SF4.D_E_L_E_T_  = ' ' "
		cQuery    += " ORDER BY "+SqlOrder(SD2->(IndexKey()))	

		cQuery    := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

		For nX := 1 To Len(aStruSD2)
			If aStruSD2[nX][2]<>"C"
				TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
			EndIf
		Next nX

		If Eof()    
			If lHelp  
				Help(" ",1,"DSNOTESDT")
				nHpP3 := 1
			Endif
			lDevolucao := .F.
			lHelpTES   := .F.
		EndIf
		#ELSE
		If lCliente
			cIndex := CriaTrab(NIL,.F.)
			cQuery := " SD2->D2_FILIAL == '" + xFilial("SD2") + "' "
			cQuery += " .And. SD2->D2_CLIENTE == '" + cCliente + "' "
			cQuery += " .And. SD2->D2_LOJA    == '" + cLoja    + "' "
			If !Empty(cDocSF2)
				cQuery += " .And. ( "
				cQuery += cDocSF2
			EndIf
			IndRegua("SD2",cIndex,SD2->(IndexKey()),,cQuery)
			nIndex := RetIndex("SD2")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			SD2->(DbGotop())
		Else
			MsSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+cCliente+cLoja)
		EndIf
		#ENDIF
		While !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And.;
		(cAliasSD2)->D2_CLIENTE 		   == cCliente 		  .And.;
		(cAliasSD2)->D2_LOJA			   == cLoja 		  .And.;
		If(!lCliente,(cAliasSD2)->D2_DOC  == SF2->F2_DOC     .And.;
		(cAliasSD2)->D2_SERIE			   == SF2->F2_SERIE,.T.)

			If ((cAliasSD2)->D2_QTDEDEV < (cAliasSD2)->D2_QUANT) .Or. ((cAliasSD2)->D2_VALDEV == 0)
				If !lQuery
					DbSelectArea("SF4")
					DbSetOrder(1)
					If MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
						If Empty(SF4->F4_TESDV) .Or. !(SF4->(MsSeek(xFilial("SF4")+SF4->F4_TESDV)))
							lDevolucao := .F.
							Exit
						EndIf
						If SF4->F4_PODER3=="D"
							lPoder3 := .T.
						EndIf
						If lPoder3 .And. !cTipo$"B|N"
							cTipo := IIF(cTipoNF=="B","N","B")
						ElseIf !cTipo$"B|N"
							cTipo := "D"
						EndIf
					EndIf
				Else
					If (cAliasSD2)->F4_PODER3=="D"
						lPoder3 := .T.
					EndIf
					If lPoder3 .And. !cTipo$"B|N"
						cTipo := IIF(cTipoNF=="B","N","B")
					ElseIf !cTipo$"B|N"
						cTipo := "D"
					EndIf				
				EndIf
				If !lMt103FDV .Or. ExecBlock("MT103FDV",.F.,.F.,{cAliasSD2})
					If Len(aSaldoTerc)>0 
						aSize(aSaldoTerc,0)
					EndIf 

					cTipoNF := (cAliasSD2)->D2_TIPO

					Do Case
						Case (cAliasSF4)->F4_PODER3=="D"
						aSaldoTerc := CalcTerc((cAliasSD2)->D2_COD,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_IDENTB6,(cAliasSD2)->D2_TES,cTipoNF)
						nSldDev :=iif(Len(aSaldoTerc)>0,aSaldoTerc[1],0)
						Case cTipoNF == "N"
						nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
						Case cTipoNF == "B" .And.(cAliasSF4)->F4_PODER3 =="N" .And. A103DevPdr((cAliasSF4)->F4_CODIGO)
						nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
						lPoder3 := .T.
						OtherWise
						nSldDev := 0
					EndCase

					If nSldDev > 0 .Or. (cTipoNF$"CIP" .And. (cAliasSD2)->D2_VALDEV == 0) .Or.;
					( (cAliasSD2)->D2_QUANT == 0 .And. (cAliasSD2)->D2_VALDEV == 0 .And. (cAliasSD2)->D2_TOTAL > 0 )

						lDevCode := .T.

						If lCompl

							If lQuery
								aAreaAnt  := GetArea()
								cAliasCpl := GetNextAlias()
								cQuery    := "SELECT SUM(SD2.D2_PRCVEN) AS D2_PRCVEN "
								cQuery    += "  FROM "+RetSqlName("SD2")+" SD2 "
								cQuery    += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"'"
								cQuery    += "   AND SD2.D2_TIPO    = 'C' "
								cQuery    += "   AND SD2.D2_NFORI   = '"+SF2->F2_DOC+"'"
								cQuery    += "   AND SD2.D2_SERIORI = '"+SF2->F2_SERIE+"'"
								cQuery    += "   AND SD2.D2_ITEMORI = '"+(cAliasSD2)->D2_ITEM +"'"
								cQuery    += "   AND ((SD2.D2_QTDEDEV < SD2.D2_QUANT) OR "
								cQuery    += "       (SD2.D2_VALDEV = 0))"
								cQuery    += "   AND SD2.D2_TES         = '"+(cAliasSD2)->D2_TES+"'"
								cQuery    += "   AND SD2.D_E_L_E_T_     = ' ' "

								cQuery    := ChangeQuery(cQuery)
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCpl,.T.,.T.)

								TcSetField(cAliasCpl,"D2_PRCVEN","N",TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2])

								If !(cAliasCpl)->(Eof())
									nVlCompl := (cAliasCpl)->D2_PRCVEN
								Else
									nVlCompl := 0
								EndIf

								(cAliasCpl)->(dbCloseArea())
								RestArea(aAreaAnt)
							Else
								aAreaSD2 := SD2->(GetArea())
								SD2->(dbSetOrder(3))
								cIndexCpl := CriaTrab(NIL,.F.)
								cQuery := "       SD2->D2_FILIAL  == '" + xFilial("SD2") + "' "
								cQuery += " .And. SD2->D2_TIPO    == 'C' "
								cQuery += " .And. SD2->D2_NFORI   == '"+SF2->F2_DOC   +"' "
								cQuery += " .And. SD2->D2_SERIORI == '"+SF2->F2_SERIE +"' "
								cQuery += " .And. AllTrim(SD2->D2_ITEMORI) == '"+(cAliasSD2)->D2_ITEM +"' "
								cQuery += " .And. SD2->D2_TES     == '"+(cAliasSD2)->D2_TES+"' "

								IndRegua("SD2",cIndexCpl,SD2->(IndexKey()),,cQuery)
								SD2->(DbGotop())

								nVlCompl := 0
								While !SD2->(Eof())							
									nVlCompl += SD2->D2_PRCVEN
									SD2->(dbSkip())
								EndDo

								nIndex := RetIndex("SD2")
								FErase( cIndexCpl+OrdBagExt() )

								If lCliente
									dbSetIndex(cIndex+OrdBagExt())
									dbSetOrder(nIndex+1)
								EndIf

								RestArea(aAreaSD2)
							EndIf
						EndIf

						aLinha := {}				
						nDesc  := 0
						AAdd( aLinha, { "D1_COD"    , (cAliasSD2)->D2_COD  , Nil } )
						AAdd( aLinha, { "D1_QUANT"  , nSldDev, Nil } )

						If (cAliasSD2)->D2_QUANT==nSldDev
							If Len(aSaldoTerc)=0   // Nf sem Controle Poder Terceiros                      
								If (cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR == 0
									AAdd( aLinha, { "D1_VUNIT"  , (cAliasSD2)->D2_PRCVEN, Nil })
								Else 
									nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
									AAdd( aLinha, { "D1_VUNIT"  , ((cAliasSD2)->D2_TOTAL+nDesc)/(cAliasSD2)->D2_QUANT, Nil })
								EndIf
							Else                   // Nf com Controle Poder Terceiros 
								If (cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR == 0
									AAdd( aLinha, { "D1_VUNIT"  , (aSaldoTerc[5]-aSaldoTerc[4])/nSldDev, Nil })
								Else
									nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
									nDesc:=iif(nDesc>0,(nDesc/aSaldoTerc[6])*nSldDev,0)
									AAdd( aLinha, { "D1_VUNIT"  , ((aSaldoTerc[5]+nDesc)-aSaldoTerc[4])/nSldDev, Nil })
								EndIf
							EndIf
							nTotal:= A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL")
							If nTotal == 0 .And. (cAliasSD2)->D2_QUANT == 0 .And. (cAliasSD2)->D2_PRCVEN == (cAliasSD2)->D2_TOTAL
								nTotal:= (cAliasSD2)->D2_TOTAL
							EndIf
							AAdd( aLinha, { "D1_TOTAL"  , nTotal,Nil } )						
							AAdd( aLinha, { "D1_VALDESC", nDesc , Nil } )						
							AAdd( aLinha, { "D1_VALFRE", (cAliasSD2)->D2_VALFRE, Nil } )  
							AAdd( aLinha, { "D1_SEGURO", (cAliasSD2)->D2_SEGURO, Nil } )  
							AAdd( aLinha, { "D1_DESPESA", (cAliasSD2)->D2_DESPESA, Nil } )
						Else
							nSldDevAux:= (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
							If Len(aSaldoTerc)=0	// Nf sem Controle Poder Terceiros  
								nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
								nDesc:=iif(nDesc>0,(nDesc/(cAliasSD2)->D2_QUANT)*IIf(nSldDevAux==0,1,nSldDevAux),0)
								AAdd( aLinha, { "D1_VUNIT"  ,((((cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR))-(cAliasSD2)->D2_VALDEV)/IIf(nSldDevAux==0,1,nSldDevAux), Nil })
							Else  					// Nf com Controle Poder Terceiros
								nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
								nDesc:=iif(nDesc>0,(nDesc/aSaldoTerc[6])*nSldDev,0)
								AAdd( aLinha, { "D1_VUNIT"  , ((aSaldoTerc[5]+nDesc)-aSaldoTerc[4])/nSldDev, Nil })
							EndIf

							AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
							AAdd( aLinha, { "D1_VALDESC", nDesc , Nil } )						
							AAdd( aLinha, { "D1_VALFRE" , A410Arred(((cAliasSD2)->D2_VALFRE/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_VALFRE"),Nil } )						
							AAdd( aLinha, { "D1_SEGURO" , A410Arred(((cAliasSD2)->D2_SEGURO/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_SEGURO"),Nil } )						
							AAdd( aLinha, { "D1_DESPESA" , A410Arred(((cAliasSD2)->D2_DESPESA/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_DESPESA"),Nil } )						
						EndIf
						AAdd( aLinha, { "D1_IPI"    , (cAliasSD2)->D2_IPI    , Nil } )	
						AAdd( aLinha, { "D1_LOCAL"  , (cAliasSD2)->D2_LOCAL  , Nil } )
						AAdd( aLinha, { "D1_TES" 	, (cAliasSF4)->F4_CODIGO , Nil } )
						If ("000"$AllTrim((cAliasSF4)->F4_CF) .Or. "999"$AllTrim((cAliasSF4)->F4_CF))
							cCfop := AllTrim((cAliasSF4)->F4_CF)
						Else
							cCfop := SubStr("123",At(SubStr((cAliasSD2)->D2_CF,1,1),"567"),1)+SubStr((cAliasSD2)->D2_CF,2)
							SX5->( dbSetOrder(1) )
							If !SX5->(MsSeek( cFilSX5 + "13" + cCfop ))
								cCfop := AllTrim((cAliasSF4)->F4_CF)
							EndIf
						EndIf
						AAdd( aLinha, { "D1_CF"		, cCfop, Nil } )
						AAdd( aLinha, { "D1_UM"     , (cAliasSD2)->D2_UM , Nil } )
						If (nTpCtlBN != 0)
							AAdd( aLinha, { "D1_OP" 	, A103OPBen(cAliasSD2, nTpCtlBN) , Nil } )
						EndIf
						If Rastro((cAliasSD2)->D2_COD)
							AAdd( aLinha, { "D1_LOTECTL", (cAliasSD2)->D2_LOTECTL, ".T." } )
							If (cAliasSD2)->D2_ORIGLAN == "LO"
								If Rastro((cAliasSD2)->D2_COD,"L") .AND. !Empty((cAliasSD2)->D2_NUMLOTE)
									AAdd( aLinha, { "D1_NUMLOTE", Nil , ".T." } )							
								Else
									AAdd( aLinha, { "D1_NUMLOTE", (cAliasSD2)->D2_NUMLOTE, ".T." } )													
								EndIf
							Else
								AAdd( aLinha, { "D1_NUMLOTE", (cAliasSD2)->D2_NUMLOTE, ".T." } )						
							EndIf

							AAdd( aLinha, { "D1_DTVALID", (cAliasSD2)->D2_DTVALID, ".T." } )
							AAdd( aLinha, { "D1_POTENCI", (cAliasSD2)->D2_POTENCI, ".T." } )
							SB8->(dbSetOrder(3)) // FILIAL+PRODUTO+LOCAL+LOTECTL+NUMLOTE+B8_DTVALID
							If SB8->(FieldPos('B8_DFABRIC')) > 0 .And.;
							SB8->(MsSeek(xFilial("SB8")+(cAliasSD2)->D2_COD + (cAliasSD2)->D2_LOCAL + (cAliasSD2)->D2_LOTECTL + (cAliasSD2)->D2_NUMLOTE))  
								AAdd( aLinha, { "D1_DFABRIC", SB8->B8_DFABRIC, ".T." } )
							Endif
						EndIf
						cNFORI  := (cAliasSD2)->D2_DOC
						cSERIORI:= (cAliasSD2)->D2_SERIE
						cITEMORI:= (cAliasSD2)->D2_ITEM 
						If cTipo == "D"
							SF4->(dbSetOrder(1))
							If SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)) .And. SF4->F4_PODER3$"D|R"
								If SF4->(MsSeek(xFilial("SF4")+(cAliasSF4)->F4_CODIGO)) .And. SF4->F4_PODER3 == "N"
									cNFORI  := ""
									cSERIORI:= ""
									cITEMORI:= ""
									Help(" ",1,"A100NOTES")
								EndIf
								If SF4->(MsSeek(xFilial("SF4")+(cAliasSF4)->F4_CODIGO)) .And. SF4->F4_PODER3 == "R"
									cNFORI  := ""
									cSERIORI:= ""
									cITEMORI:= ""
									Help(" ",1,"A103TESNFD")
								EndIf
							EndIf
						EndIf
						AAdd( aLinha, { "D1_NFORI"  , cNFORI   			      , Nil } )
						AAdd( aLinha, { "D1_SERIORI", cSERIORI  		      , Nil } )
						AAdd( aLinha, { "D1_ITEMORI", cITEMORI   			  , Nil } )
						AAdd( aLinha, { "D1_ICMSRET", ((cAliasSD2)->D2_ICMSRET / (cAliasSD2)->D2_QUANT )*nSldDev , Nil })
						If (cAliasSF4)->F4_PODER3=="D"
							AAdd( aLinha, { "D1_IDENTB6", (cAliasSD2)->D2_NUMSEQ, Nil } )								
						Endif

						If (cAliasSD2)->D2_VALACRS >0                                
							AAdd( aLinha, { "D1_VALACRS", ((cAliasSD2)->D2_VALACRS / (cAliasSD2)->D2_QUANT )*nSldDev , Nil })
						Endif

						If ExistBlock("MT103LDV")
							aLinha := ExecBlock("MT103LDV",.F.,.F.,{aLinha,cAliasSD2})
						EndIf

						If !(Empty((cAliasSD2)->D2_CCUSTO ))
							AAdd( aLinha, { "D1_CC"  , (cAliasSD2)->D2_CCUSTO  , Nil } )
						EndIf

						AAdd( aLinha, { "D1RECNO",    Iif(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RECNO()) ), Nil } )



						AAdd( aItens, aLinha)
					EndIf
				Else
					lHelpTes := .F.
				EndIf	
			Else
				nHpP3 := 1 
			Endif
			DbSelectArea(cAliasSD2)
			dbSkip()
		EndDo
		If lQuery
			DbSelectArea(cAliasSD2)
			dbCloseArea()
		Else
			If lCliente
				RetIndex( "SD2" )
				FErase( cIndex+OrdBagExt() )
			EndIf
		EndIf
		If !lDevCode
			lDevolucao := .F.
		Endif
		DbSelectArea("SD2")

	Endif               

Return lDevolucao

Static Function GETSTATUS(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
		Case _cStatus=="0"
		_cDesc := "Elaboracao"
		Case _cStatus=="1"
		_cDesc := "Aberto"
		Case _cStatus=="2"
		_cDesc := "Autorizado"
		Case _cStatus=="3"
		_cDesc := "Recebido"
		Case _cStatus=="4"
		_cDesc := "Atendimento sem devolução"
		Case _cStatus=="5"
		_cDesc := "Encerrado"
	EndCase

Return(_cDesc)


/*/{Protheus.doc} LegReceb
description
Rotina para apresentar Legenda
@type function
@version  
@author Valdemir Jose
@since 01/06/2021
@return return_type, return_description
/*/
Static Function LegReceb()

	Local aLegenda :={{'BR_VERDE'   , 'Liberado para lançamento'},;
	                  {'BR_AZUL'    , 'Pendente Conferência Recebimento'},;
	                  {'BR_AMARELO' , 'Pendente Conferência Fiscal' }}


	BrwLegenda("Processo Recebimento","Legenda",aLegenda)

Return

/*/{Protheus.doc} stConfer
description
Rotina de Conferência de Recebimento
Ticket: 20210408005632
@type function
@version  
@author Valdemir Jose
@since 02/06/2021
@return return_type, return_description
/*/
Static Function stConfer()
	Local aAreaCF := GetArea()

	if Empty(aFatec[oFatec:nAt,1])
	   FWMsgRun(,{|| Sleep(3000)},"Atenção!","Registro não pode ser conferido, por não ter sido autorizado.")
	   Return
	endif 

	aFatec[oFatec:nAt,1] := "R"

	FWMsgRun(,{|| Sleep(3000) },"Conferido!","Pronto para processamento")

	RestArea( aAreaCF )
Return
