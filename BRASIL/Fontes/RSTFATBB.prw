#Include "MATR100.ch"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RSTFATBB  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 06.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao das Solicitacoes de Compras                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RSTFATBB()
	Local oReport

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³06.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oCell
	Local aOrdem := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= TReport():New("RSTFATBB","Relacao de Solicitacoes de Compras","RSTFATBB", {|oReport| ReportPrint(oReport)},"Emite um relacao para controle das solicitacoes cadastradas ,"+" "+"seus respectivos pedidos e prazos de entrega.")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	Pergunte("MTR100",.F.)
	Aadd( aOrdem, " Por Solicitacao    " )
	Aadd( aOrdem, " Por Produto        " )

	oSection1 := TRSection():New(oReport,"Relacao de Solicitacoes de Compras",{"SC1","SB1","SC7","SA2"},aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()
	oSection1:SetNoFilter("SB1")
	oSection1:SetNoFilter("SC7")
	oSection1:SetNoFilter("SA2")

	TRCell():New(oSection1,"C1_FILIAL"		,"SC1","Filial"/*Titulo*/	,/*Picture*/,TamSX3("C1_NUM")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/) // ##
	TRCell():New(oSection1,"C1_NUM"			,"SC1","Numero"+CRLF+"SC"/*Titulo*/	,/*Picture*/,TamSX3("C1_NUM")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/) // ##
	TRCell():New(oSection1,"C1_ITEM"		,"SC1","Item"+CRLF+"SC"/*Titulo*/	,/*Picture*/,TamSX3("C1_ITEM")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/) // ##
	TRCell():New(oSection1,"C1_PRODUTO"	,"SC1",/*Titulo*/						,/*Picture*/,TamSX3("C1_PRODUTO")[1]+15,/*lPixel*/,/*{|| code-block de impressao }*/,/**/, /**/, /**/, /**/, /**/,.F.)
	TRCell():New(oSection1,"C1_DESCRI"		,"SC1",/*Titulo*/						,/*Picture*/,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_TIPO"		,"SB1","Tp"/*Titulo*/				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //
	TRCell():New(oSection1,"B1_GRUPO"		,"SB1",/*Titulo*/						,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C1_QUANT"		,"SC1",/*Titulo*/						,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C1_UM"			,"SC1","UM"/*Titulo*/				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //
	TRCell():New(oSection1,"C1_CC"			,"SC1",/*Titulo*/						,/*Picture*/,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C1_EMISSAO"	,"SC1","Data de"+CRLF+"Emissao"/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //
	TRCell():New(oSection1,"C1_DATPRF"		,"SC1","Entrega"+CRLF+"SC"/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##
	TRCell():New(oSection1,"C1_SOLICIT"	,"SC1",/*Titulo*/						,/*Picture*/,9			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"dDtPrazo"		,"   ","Dt.Limite"+CRLF+"de Compra",/*Picture*/	,/*Tamanho*/,/*lPixel*/	,{||SomaPrazo(SC1->C1_DATPRF, - CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT))}) //##
	TRCell():New(oSection1,"nSaldo"			,"   ","Saldo SC",/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/) //

	TRCell():New(oSection1,"C7_NUM"			,"SC7","Numero"+CRLF+"PC"/*Titulo*/	,/*Picture*/,TamSX3("C7_NUM")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/) //##
	TRCell():New(oSection1,"C7_FORNECE"	,"SC7","Fornec."+CRLF+"PC",/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##
	TRCell():New(oSection1,"C7_LOJA"		,"SC7","Lj"+CRLF+"PC",/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##

	TRCell():New(oSection1,"C1_FORNECE"	,"SC1","Fornec."+CRLF+"SC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##
	TRCell():New(oSection1,"C1_LOJA"		,"SC1","Lj"+CRLF+"SC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRCell():New(oSection1,"A2_NOME"		,"SA2",AllTrim(RetTitle("A2_NOME")),/*Picture*/,38/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C7_EMISSAO"	,"SC7","Emissao"+CRLF+"PC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##
	//TRCell():New(oSection1,"_cCompra"		," ","Comprador",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //##

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³06.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oReport:Section(1):GetOrder()
	Local lFirst    := .T.
	Local lCotacao  := .F.
	Local lPedido   := .F.
	Local cNum      := ""
	Local cCotacao  := ""
	Local oBreak
	Local aIndex		:= {}
	//Private _cCompra	:=  ""
	If nOrdem == 1
		oBreak := TRBreak():New(oSection1,oSection1:Cell("C1_NUM"),"Total  -  ",.F.) //
	ElseIf nOrdem == 2
		oBreak := TRBreak():New(oSection1,oSection1:Cell("C1_PRODUTO"),"Total  -  ",.F.) //
	Endif
	TRFunction():New(oSection1:Cell("C1_QUANT"),NIL,"SUM",oBreak,"",/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("nSaldo"),NIL,"SUM",oBreak,"",/*cPicture*/,/*uFormula*/,.F.,.F.)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR06 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SC7 em outra area para criar uma nova IndRegua        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC7")  // ChkFile() precisa da tabela (SC7) criada
		ChkFile('SC7',.F.,'TMP')
		aADD(aIndex,CriaTrab(NIL,.F.))
		IndRegua("TMP",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMCOT+C7_PRODUTO")
		dbSelectArea("SC7")
		aADD(aIndex,CriaTrab(NIL,.F.))
		IndRegua("SC7",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMSC+C7_ITEMSC+C7_PRODUTO")
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o usuario escolher a opcao que lista as SC's canceladas   ³
//³ pelo sistema ,e' necessario ativar as deletadas.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR03 == 3
		SET DELE OFF
	Endif

	oReport:SetMeter(SC1->(LastRec()))

	oSection1:Init()

	dbSelectArea("SC1")
	dbSetOrder(nOrdem)
	If nOrdem == 1
		dbSeek("01"+MV_PAR01,.T.)//Chamado 006803
	Else
		dbSeek("01")//Chamado 006803
	EndIf
//While !oReport:Cancel() .And. SC1->(!Eof()) .And. SC1->C1_FILIAL == xFilial() .And.;
	While !oReport:Cancel() .And. SC1->(!Eof()) .And. 	IIf(nOrdem==1,C1_NUM <= MV_PAR02,.T.) //Chamado 006803

		If oReport:Cancel()
			Exit
		EndIf
	
		oReport:IncMeter()

		cNum := SC1->C1_NUM
	//>> Chamado 006803
	/* Retirado conforme solicitação do usuario
		_cCompra := POSICIONE("SY1", 3, xFilial("SY1") + SC1->C1_USER, "Y1_ZDEPTO")
			
		If  MV_PAR09 = 1
			If _cCompra <> "1"
				dbSelectArea("SC1")	
				dbSkip()
				Loop
			EndIf
		EndIf
		
		If MV_PAR09 = 2
			If _cCompra <> "2"
				dbSelectArea("SC1")
				dbSkip()
				Loop
			EndIf
		EndIf
		*/
	//<< Chamado 006803
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes maior que o numero definido           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If C1_NUM < mv_par01 .Or. C1_NUM > mv_par02
			dbSkip()
			Loop
		Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes cancelados pelo sistema               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 3 .And. !Deleted() .Or. ("CANCELADA PELO SISTEMA."$C1_OBS) //"CANCELADA PELO SISTEMA."
			dbSkip()
			Loop
		EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes de importacao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par08 == 2 .And. ;
				(!Empty(C1_COTACAO) .And. (C1_COTACAO == "IMPORT" .Or. C1_COTACAO == "IMPORX"))
			dbSkip()
			Loop
		Endif
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes em aberto gerada cotacao ou pedido    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 2 .And. ;
				(C1_QUANT <= C1_QUJE  .Or. (!Empty(C1_COTACAO) .And. (C1_COTACAO <> "IMPORT" .And. C1_COTACAO <> "IMPORX")) .Or. !Empty(C1_RESIDUO))  // BOPS 089411
			dbSkip()
			Loop
		Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes completamente atendidas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 5 .And. C1_QUANT == C1_QUJE
			dbSkip()
			Loop
		Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica intervalo de data de emissao                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (C1_EMISSAO < mv_par04 .Or. C1_EMISSAO > mv_par05)
			dbSkip()
			Loop
		Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as solicitacoes nao entregue                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 4
			If !Empty(C1_COTACAO) .And. C1_COTACAO <> "XXXXXX"
				nRegSC1 := SC1->(RecNo())
				nOrdSC1 := SC1->( IndexOrd())
				cCotSC1 := SC1->C1_COTACAO
				cProSC1 := SC1->C1_PRODUTO
				cItPSC1 := SC1->C1_ITEMPED
				nQtdSC1 := 0
				nQtdSC7 := 0
				lPedido := .F.
				dbSelectArea("SC7")
				dbSetOrder(2)
				dbSeek(xFilial("SC7")+SC1->C1_PRODUTO)
				While !Eof() .And. xFilial("SC7")+cProSC1 == C7_FILIAL+C7_PRODUTO
					If SC7->C7_NUMCOT == cCotSC1 .And. SC7->C7_ITEM == cItPSC1
						lPedido := .T.
						nQtdSC7 += If(SC7->C7_RESIDUO == "S",SC7->C7_QUANT,SC7->C7_QUJE)

						dbSelectArea("SC8")
						dbSetOrder(3)
						MsSeek(xFilial("SC8")+SC7->C7_NUMCOT+SC7->C7_PRODUTO+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM+SC7->C7_ITEM)

						dbSelectArea("SC1")
						dbSetOrder(5)
						MsSeek(xFilial("SC1")+SC8->C8_NUM+SC8->C8_PRODUTO+SC8->C8_IDENT)
						While ( !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And. SC8->C8_NUM == SC1->C1_COTACAO .And.;
								SC8->C8_PRODUTO == SC1->C1_PRODUTO .And. SC8->C8_IDENT == SC1->C1_IDENT .And. ;
								SC8->C8_NUMPED == SC1->C1_PEDIDO .And. SC8->C8_ITEMPED == SC1->C1_ITEMPED )
							nQtdSC1 += SC1->C1_QUANT
							dbSelectArea("SC1")
							dbSkip()
						EndDo
					Endif
					dbSelectArea("SC7")
					dbSkip()
				EndDo

				dbSelectArea("SC1")
				dbSetOrder(nOrdSC1)
				MsGoto(nRegSC1)

				If lPedido
					nSldEntre := nQtdSC1 - nQtdSC7
				Else
					nSldEntre := SC1->C1_QUANT
				EndIf

			Else
				nSldEntre := SC1->C1_QUANT
				dbSelectArea("SC7")
				dbSetOrder(2)
				dbSeek(xFilial("SC7")+SC1->C1_PRODUTO)
				While !Eof() .And. xFilial( "SC7" ) +SC1->C1_PRODUTO == C7_FILIAL+C7_PRODUTO
					If C7_NUMSC == SC1->C1_NUM .And. C7_ITEMSC == SC1->C1_ITEM
						nSldEntre -= If(SC7->C7_RESIDUO == "S",SC7->C7_QUANT,SC7->C7_QUJE)
					Endif
					dbSelectArea("SC7")
					dbSkip()
				EndDo
			Endif
		
			If nSldEntre <= 0
				dbSelectArea("SC1")
				dbSkip()
				Loop
			Endif

		Endif

		dbSelectArea("SC1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !MtrAValOP(mv_par07, 'SC1')
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)

		If MV_PAR06 == 1
			oSection1:Cell("C1_FORNECE"):Disable()
			oSection1:Cell("C1_LOJA"):Disable()
		
			If Empty(SC1->C1_COTACAO) .Or. SC1->C1_COTACAO == "XXXXXX" .Or. SC1->C1_COTACAO == "IMPORX"
				lFirst := .T.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de produtos                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)
			
				cAliasSC7 := "SC7"
				dbSelectArea("SC7")
				//If dbSeek(xFilial("SC7")+SC1->C1_NUM+SC1->C1_ITEM+SC1->C1_PRODUTO) //Chamado 006803
				If dbSeek(SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM+SC1->C1_PRODUTO)
					//While !Eof() .and. C7_FILIAL+C7_NUMSC+C7_ITEMSC == xFilial("SC7")+SC1->C1_NUM+SC1->C1_ITEM //Chamado 006803
					While !Eof() .and. C7_FILIAL+C7_NUMSC+C7_ITEMSC == SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !MtrAValOP(mv_par07, "SC7" )
							dbSkip()
							Loop
						EndIf
					
						dbSelectArea("SA2")
						dbSeek(xFilial("SA2")+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA)
				
						oSection1:Cell("C7_NUM"):SetValue((cAliasSC7)->C7_NUM) 
						oSection1:Cell("C7_FORNECE"):SetValue((cAliasSC7)->C7_FORNECE)
						oSection1:Cell("C7_LOJA"):SetValue((cAliasSC7)->C7_LOJA)
						oSection1:Cell("C7_EMISSAO"):SetValue((cAliasSC7)->C7_EMISSAO)
					
						ImprimeSC(lFirst,0,@oSection1)
					
						If lFirst
							lFirst := .F.
						EndIf

						dbSelectArea(cAliasSC7)
						dbSkip()
					EndDo
					dbSelectArea("SC7")
				Else
					ImprimeSC(.T.,1,@oSection1)
				EndIf
			Else
				lFirst := .T.
				dbSelectArea("TMP")
				If dbSeek(xFilial('SC7')+SC1->C1_COTACAO+SC1->C1_PRODUTO)
					lCotacao  := .T.
					While !Eof() .And. C7_FILIAL+C7_NUMCOT+C7_PRODUTO  == xFilial('SC7')+SC1->C1_COTACAO+SC1->C1_PRODUTO
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !MtrAValOP(mv_par07, 'SC7')
							dbSkip()
							Loop
						EndIf

						dbSelectArea("SA2")
						dbSeek(xFilial()+TMP->C7_FORNECE+TMP->C7_LOJA)
					
						oSection1:Cell("C7_NUM"):SetValue(TMP->C7_NUM)
						oSection1:Cell("C7_FORNECE"):SetValue(TMP->C7_FORNECE)
						oSection1:Cell("C7_LOJA"):SetValue(TMP->C7_LOJA)
						oSection1:Cell("C7_EMISSAO"):SetValue(TMP->C7_EMISSAO)
					
						If lFirst
							ImprimeSC(lFirst,0,@oSection1)
							lFirst := .F.
						Else
							ImprimeSC(lFirst,0,@oSection1)
						Endif

						dbSelectArea("TMP")
						dbSkip()
					EndDo
				Else
					lCotacao  := .F.
					ImprimeSc(.T.,1,@oSection1)
				EndIf
			EndIf
		Else
			oSection1:Cell("C7_NUM"):Disable()
			oSection1:Cell("C7_FORNECE"):Disable()
			oSection1:Cell("C7_LOJA"):Disable()
			oSection1:Cell("C7_EMISSAO"):Disable()
	
			dbSelectArea("SA2")
			dbSeek(xFilial()+SC1->C1_FORNECE+SC1->C1_LOJA)
			dbSelectArea("SC1")
			oSection1:Cell("C1_QUANT"):SetValue(SC1->C1_QUANT)
			oSection1:Cell("nSaldo"):SetValue(SC1->C1_QUANT-SC1->C1_QUJE)
			//oSection1:Cell("_cCompra"):SetValue(Iif(_cCompra = "1","SIM",Iif(_cCompra = "2","NAO","NC")))
			oSection1:PrintLine()
		EndIf
		cCotacao := IIF(!Empty(SC1->C1_COTACAO) .And. SC1->C1_COTACAO <> "XXXXXX" .And. lCotacao,SC1->C1_COTACAO,"")
		dbSelectArea("SC1")
		dbSkip()
		If SC1->C1_NUM <> cNum .And. !Empty(cCotacao)
			oReport:PrintText(STR0016+cCotacao,,oSection1:Cell('C7_NUM'):ColPos())
		Endif
		
		//_cCompra := ""
	EndDo

	If MV_PAR03 == 3
		SET DELE ON
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	RetIndex("SC7")
	dbSelectArea("SC1")
	Set Filter To
	RetIndex("SC1")
	dbSetOrder(1)
	If ( Select("TMP")<>0 )
		dbSelectArea("TMP")
		dbCloseArea()
		dbSelectArea("SC7")
	EndIf
	oSection1:Finish()

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImprimeSC³ Autor ³ Julio C.Guerato³ Data ³27/05/2009 |     |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Dados da SC na versão R4                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lImp:  Parâmetro para indicar como será setada a impressa  ³±±
±±³          ³ nTipo: 0 = Detalhe  / 1 = Totalizacao                      ³±±
±±³          ³ oSection1: Objeto Impressao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR100			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImprimeSC(lAtiva,nTipo,oSection1)

	If lAtiva
		oSection1:Cell("C1_NUM"):Show()
		oSection1:Cell("C1_ITEM"):Show()
		oSection1:Cell("C1_PRODUTO"):Show()
		oSection1:Cell("C1_DESCRI"):Show()
		oSection1:Cell("B1_TIPO"):Show()
		oSection1:Cell("B1_GRUPO"):Show()
		oSection1:Cell("C1_QUANT"):Show()
		oSection1:Cell("C1_UM"):Show()
		oSection1:Cell("C1_CC"):Show()
		oSection1:Cell("C1_EMISSAO"):Show()
		oSection1:Cell("C1_DATPRF"):Show()
		oSection1:Cell("C1_SOLICIT"):Show()
		oSection1:Cell("dDtPrazo"):Show()
		oSection1:Cell("nSaldo"):Show()
		//oSection1:Cell("_cCompra"):Show()
	else
		oSection1:Cell("C1_NUM"):Hide()
		oSection1:Cell("C1_ITEM"):Hide()
		oSection1:Cell("C1_PRODUTO"):Hide()
		oSection1:Cell("C1_DESCRI"):Hide()
		oSection1:Cell("B1_TIPO"):Hide()
		oSection1:Cell("B1_GRUPO"):Hide()
		oSection1:Cell("C1_QUANT"):Hide()
		oSection1:Cell("C1_UM"):Hide()
		oSection1:Cell("C1_CC"):Hide()
		oSection1:Cell("C1_EMISSAO"):Hide()
		oSection1:Cell("C1_DATPRF"):Hide()
		oSection1:Cell("C1_SOLICIT"):Hide()
		oSection1:Cell("dDtPrazo"):Hide()
		oSection1:Cell("nSaldo"):Hide()
	EndIf


	Do Case
	Case nTipo == 0
		If lAtiva
			oSection1:Cell("C1_QUANT"):SetValue(SC1->C1_QUANT)
			oSection1:Cell("nSaldo"):SetValue(SC1->C1_QUANT-SC1->C1_QUJE)
			//oSection1:Cell("_cCompra"):SetValue(Iif(_cCompra = "1","SIM",Iif(_cCompra = "2","NAO","NC")))
			oSection1:PrintLine()
		Else
			oSection1:Cell("C1_QUANT"):SetValue(0)
			oSection1:Cell("nSaldo"):SetValue(0)
			//oSection1:Cell("_cCompra"):SetValue(0)
			oSection1:PrintLine()
		Endif
    
	Case nTipo == 1
		If lAtiva
			oSection1:Cell("C7_NUM"):Hide()
			oSection1:Cell("C7_FORNECE"):Hide()
			oSection1:Cell("C7_LOJA"):Hide()
			oSection1:Cell("A2_NOME"):Hide()
			oSection1:Cell("C7_EMISSAO"):Hide()
			
			oSection1:Cell("C1_QUANT"):SetValue(SC1->C1_QUANT)
			oSection1:Cell("nSaldo"):SetValue(SC1->C1_QUANT-SC1->C1_QUJE)
			//oSection1:Cell("_cCompra"):SetValue(Iif(_cCompra = "1","SIM",Iif(_cCompra = "2","NAO","NC")))

			oSection1:PrintLine()
				
			oSection1:Cell("C7_NUM"):Show()
			oSection1:Cell("C7_FORNECE"):Show()
			oSection1:Cell("C7_LOJA"):Show()
			oSection1:Cell("A2_NOME"):Show()
			oSection1:Cell("C7_EMISSAO"):Show()
		EndIf
	EndCase

Return


