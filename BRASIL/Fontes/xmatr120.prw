#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MATR120 ³ Autor ³ Nereu Humberto Junior ³ Data ³ 12.06.06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da Rela‡„o de Pedidos de Compras                    ³±±
±±³Descri‡…o ³                     										   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   		³Manutencao efetuada                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 12.05.21 ³ Eduardo Pereira      ³ De MATR120 p/ User Function XMATR120 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Alterado o MATR120 para User Function incluindo o filtro    ³±±
±±³Descri‡…o ³ das Filiais para não considerar apenas a Filial logada.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.	/  .F.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Steck                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function xMatr120()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³12.06.2006³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local aOrdem	:= {}
Local cAliasSC7 := GetNextAlias()
Private cPerg 	:= "XMTR120"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("XMATR120","Relacao de Pedidos de Compras","XMTR120", {|oReport| ReportPrint(oReport,cAliasSC7)},"Emissao da Relacao de  Pedidos de Compras. Sera solicitado em qual Ordem, qual o Intervalo para a emissao dos pedidos de compras.")
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)

Pergunte("XMTR120",.F.)
aAdd( aOrdem, "Por Numero" ) 
aAdd( aOrdem, "Por Produto" )
aAdd( aOrdem, "Por Fornecedor" )
aAdd( aOrdem, "Por Previsao de Entrega" )

oSection1 := TRSection():New(oReport,"Relacao de Pedidos de Compras",{"SC7","SA2","SB1"},aOrdem)
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"C7_NUM","SC7","Num.PC"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_NUMSC","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_LOJA","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_FAX","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection1,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
TRCell():New(oSection1,"C7_DATPRF","SC7","ENTREGA PREVISTA :  ",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cDescri"):GetFieldInfo("B1_DESC")             

oSection2 := TRSection():New(oSection1,"Pedido de Compras / Autorização de Entrega (Produtos)",{"SC7","SA2","SB1"}) 
oSection2:SetTotalInLine(.F.)
oSection2:SetHeaderPage()
oSection2:SetTotalText("Total Geral ")

TRCell():New(oSection2,"C7_NUM","SC7","Num.PC"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_ITEM","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
oSection2:Cell("cDescri"):GetFieldInfo("B1_DESC")
TRCell():New(oSection2,"B1_GRUPO","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_EMISSAO","SC7","Emissao"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_LOJA","SC7","Lj"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_DATPRF","SC7","Entrega"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_QUANT","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_UM","SC7","UM"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"nVlrUnit","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVunit(cAliasSC7) }) 
oSection2:Cell("nVlrUnit"):GetFieldInfo("C7_PRECO")
TRCell():New(oSection2,"C7_VLDESC","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescon(cAliasSC7) }) 
TRCell():New(oSection2,"nVlrIPI","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVIPI(cAliasSC7) })
oSection2:Cell("nVlrIPI"):GetFieldInfo("C7_VALIPI")
TRCell():New(oSection2,"C7_TOTAL","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVTotal(cAliasSC7) })
TRCell():New(oSection2,"C7_QUJE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"nQtdRec","   ","Quant.Receber",PesqPict('SC7','C7_QUANT'),/*Tamanho*/,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),IIF((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE<0,0,(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE),0) })
TRCell():New(oSection2,"nSalRec","   ","Saldo Receber",PesqPict('SC7','C7_TOTAL'),TamSX3("C7_TOTAL")[1],/*lPixel*/,{|| ImpSaldo(cAliasSC7) })
TRCell():New(oSection2,"C7_RESIDUO","   ","Res." + CRLF + "Elim."/*Titulo*/,/*Picture*/,3,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),"Não","Sim") })
TRCell():New(oSection2,"C7_FILIAL","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection2:Cell("nVlrIPI"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
TRFunction():New(oSection2:Cell("C7_TOTAL"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nSalRec"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 

Return(oReport)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportPrint(oReport,cAliasSC7)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local nOrdem    := oReport:Section(1):GetOrder() 
Local nTamDPro	:= If( TamSX3("C7_PRODUTO")[1] > 15, 20, 30 )
Local nFilters 	:= 0
Local nI
Local cWhere	:= ""
Local cFrom		:= "%%"
Local lFilUsr	:= oSection1:GetAdvplExp() <> ""

dbSelectArea("SC7")
If nOrdem == 4
	dbSetOrder(16) 
Else
	dbSetOrder(nOrdem)
EndIf

If nOrdem == 1
	If ( cPaisLoc $ "ARG|POR|EUA" )	//Ordena los pedidos de compra y luego la AE.
		dbSetOrder(10)
	EndIf	
	oReport:SetTitle( oReport:Title() + " - POR NUMERO")
	oSection1 :SetTotalText("Total dos Itens: ")
ElseIf nOrdem == 2
	oReport:SetTitle( oReport:Title() + " - POR PRODUTO")
	oSection1 :SetTotalText("Total do Produto")
ElseIf nOrdem == 3
	oReport:SetTitle( oReport:Title() + " - POR FORNECEDOR")
	oSection1 :SetTotalText("Total do Fornecedor")
ElseIf nOrdem == 4
	oReport:SetTitle( oReport:Title() + " - POR PREVISAO DE ENTREGA")
	oSection1 :SetTotalText("Total da Previsao de Entrega")
EndIf

If Mv_Par07 == 1
	oReport:SetTitle( oReport:Title() + ", Todos")
ElseIf Mv_Par07 == 2
	oReport:SetTitle( oReport:Title() + ", Em Abertos")
ElseIf Mv_Par07 == 3
	oReport:SetTitle( oReport:Title() + ", Residuos")
ElseIf Mv_Par07 == 4
	oReport:SetTitle( oReport:Title() + ", Atendidos")
ElseIf Mv_Par07 == 5
	oReport:SetTitle( oReport:Title() + ", Atendidos + Parcial entregue")
EndIf
oReport:SetTitle( oReport:Title() + " - " + GetMv("MV_MOEDA" + Str(Mv_Par13,1)))
//Filtragem do relatório
//Transforma parametros Range em expressao SQL
MakeSqlExpr(oReport:uParam)
//Query do relatório da secao 1
oReport:Section(1):BeginQuery()	

cWhere := "%"
If Mv_Par11 == 1 
	cWhere += "AND C7_CONAPRO <> 'B' "	
ElseIf Mv_Par11 == 2
	cWhere += "AND C7_CONAPRO = 'B' "	
EndIf

If Mv_Par07 == 2 
	cWhere += "AND ( (C7_QUANT-C7_QUJE) > 0 ) "	
	cWhere += "AND C7_RESIDUO = ' ' "
ElseIf Mv_Par07 == 3
	cWhere += "AND C7_RESIDUO <> ' ' "
ElseIf Mv_Par07 == 4
	cWhere += "AND C7_QUANT <= C7_QUJE "	
ElseIf Mv_Par07 == 5
	cWhere += "AND C7_QUJE > 0 "		
EndIf

If Mv_Par10 == 1 
	cWhere += "AND C7_TIPO = 1 "	
ElseIf Mv_Par10 == 2
	cWhere += "AND C7_TIPO = 2 "	
EndIf

If Mv_Par12 == 1 //Firmes
	cWhere += "AND (C7_TPOP = 'F' OR C7_TPOP = ' ') "	
ElseIf Mv_Par12 == 2 //Previstas
	cWhere += "AND C7_TPOP = 'P' "	
EndIf

If lFilUsr
	nFilters := Len(oSection1:aUserFilter)	
	cFrom := "%"
	For nI := 1 to nFilters
		If oSection1:aUserFilter[nI][1] == "SA2" .And. oSection1:aUserFilter[nI][2] <> ""
			cFrom += "," + RetSqlName("SA2") + " SA2 "
			cWhere += "AND C7_FORNECE = A2_COD AND SA2.D_E_L_E_T_ = ' ' "
			If FWModeAccess("SC7") == "E" .And. FWModeAccess("SA2") == "E"
				cWhere += "AND SC7.C7_FILIAL = SA2.A2_FILIAL "
			EndIf
		ElseIf	oSection1:aUserFilter[nI][1] == "SB1" .And. oSection1:aUserFilter[nI][2] <> ""
			cFrom += "," + RetSqlName("SB1") + " SB1 "
			cWhere += "AND C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' ' "
			If FWModeAccess("SC7") == "E" .And. FWModeAccess("SB1") == "E"
				cWhere += "AND SC7.C7_FILIAL = SB1.B1_FILIAL "
			EndIf
		EndIf
	Next nI
	cFrom += "%" 
EndIf

cWhere += "%"	
BeginSql Alias cAliasSC7
	SELECT SC7.*
	FROM %table:SC7% SC7 %Exp:cFrom%
	WHERE C7_FILIAL >= %Exp:Mv_Par17% AND
			C7_FILIAL <= %Exp:Mv_Par18% AND
			C7_NUM >= %Exp:Mv_Par08% AND
			C7_NUM <= %Exp:Mv_Par09% AND
			C7_PRODUTO >= %Exp:Mv_Par01% AND
			C7_PRODUTO <= %Exp:Mv_Par02% AND
			C7_EMISSAO >= %Exp:Dtos(Mv_Par03)% AND
			C7_EMISSAO <= %Exp:Dtos(Mv_Par04)% AND
			C7_DATPRF >= %Exp:Dtos(Mv_Par05)% AND
			C7_DATPRF <= %Exp:Dtos(Mv_Par06)% AND
			C7_FORNECE >= %Exp:Mv_Par15% AND
			C7_FORNECE <= %Exp:Mv_Par16%  AND
			SC7.%NotDel%
			%Exp:cWhere%
	ORDER BY %Order:SC7%
EndSql 

oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

oSection2:SetParentQuery()

Do Case
	Case nOrdem == 1
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_NUM == cParam },{ || (cAliasSC7)->C7_NUM })
	Case nOrdem == 2
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_PRODUTO == cParam },{ || (cAliasSC7)->C7_PRODUTO })
	Case nOrdem == 3
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA == cParam },{ || (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA })
	Case nOrdem == 4
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_DATPRF == cParam },{ || (cAliasSC7)->C7_DATPRF })
EndCase
//Metodo TrPosition()
//Posiciona em um registro de uma outra tabela. O posicionamento será realizado antes da impressao de cada linha do relatório.
//ExpO1 : Objeto Report da Secao
//ExpC2 : Alias da Tabela
//ExpX3 : Ordem ou NickName de pesquisa
//ExpX4 : String ou Bloco de código para pesquisa. A string será macroexecutada.
TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE + (cAliasSC7)->C7_LOJA})
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE + (cAliasSC7)->C7_LOJA})
TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
//Inicio da impressao do fluxo do relatório
oReport:SetMeter( SC7->( LastRec() ) )

If nOrdem <> 2
	oSection1:Cell("cDescri"):SetSize(nTamDPro)
	oSection2:Cell("cDescri"):SetSize(nTamDPro)
EndIf

Do Case
	Case nOrdem == 1
		// Seção 1
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Seção 2
		oSection2:Cell("C7_NUM"):Disable()
		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection1:Print()
	Case nOrdem == 2
		// Seção 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Seção 2
		oSection2:Cell("C7_PRODUTO"):Disable()
		oSection2:Cell("cDescri"):Disable()
		oSection2:Cell("B1_GRUPO"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection1:Print()
	Case nOrdem == 3
		// Seção 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Seção 2
		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection1:Print()
	Case nOrdem == 4
		// Seção 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		// Seção 2
		oSection2:Cell("B1_GRUPO"):Disable()
		oSection2:Cell("C7_DATPRF"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection2:Cell("C7_FORNECE"):SetTitle("Fornec.")
		oSection2:Cell("cDescri"):SetSize(15)            
		If TamSX3("C7_PRODUTO")[1] > 15
			oSection2:Cell("A2_NOME"):Disable()
			oSection1:Cell("cDescri"):SetSize(14)
			oSection2:Cell("cDescri"):SetSize(14)
		Else
			oSection1:Cell("A2_NOME"):SetSize(15)
			oSection2:Cell("A2_NOME"):SetSize(15)
		EndIf
		oSection1:Print()
EndCase			

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpDescri ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi a descriçao do Produto.		                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpDescri(cAliasSC7)

Local aArea   := GetArea()
Local cDescri := ""

If Empty(Mv_Par14)
	Mv_Par14 := "B1_DESC"
EndIf

// Impressao da descricao cientifica do Produto.
If AllTrim(Mv_Par14) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	dbSeek( xFilial("SB5") + (cAliasSC7)->C7_PRODUTO )
	cDescri := Alltrim(B5_CEME)
EndIf

If AllTrim(Mv_Par14) == "C7_DESCRI"
	dbSelectArea("SC7")
	cDescri := Alltrim((cAliasSC7)->C7_DESCRI)
EndIf

// Impressao da descricao generica do Produto.
If AllTrim(Mv_Par14) == "B1_DESC" .Or. Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1") + (cAliasSC7)->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
EndIf

RestArea(aArea)

Return cDescri

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpVunit  ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi o Valor Unitário.                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpVunit(cAliasSC7)

Local aArea    := GetArea()
Local nVlrUnit := 0
Local aTam	   := TamSx3("C7_PRECO")
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)

If !Empty((cAliasSC7)->C7_REAJUST)
	nVlrUnit := xMoeda(Form120((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda) 
Else
	nVlrUnit := xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda) 
EndIf

RestArea(aArea)

Return nVlrUnit

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpVIPI   ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi Valor do IPI.                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpVIPI(cAliasSC7)

Local aArea    := GetArea()
Local nVlrIPI  := 0
Local nToTIPI  := 0
Local nTotal   := 0
Local nItemIVA := 0 
Local nValor   := ((cAliasSC7)->C7_QUANT) * Iif(Empty((cAliasSC7)->C7_REAJUST), (cAliasSC7)->C7_PRECO, Formula((cAliasSC7)->C7_REAJUST))
Local nTotDesc := (cAliasSC7)->C7_VLDESC
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)
Local nI 

If cPaisLoc <> "BRA"
	R120FIniPC((cAliasSC7)->C7_FILIAL,(cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
	aValIVA := MaFisRet(,"NF_VALIMP")
	If !Empty( aValIVA )
		For nI := 1 To Len( aValIVA )
			nItemIVA += aValIVA[nI]
		Next
	EndIf
	nVlrIPI := xMoeda(nItemIVA,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)  
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
	EndIF
	nTotal := nValor - nTotDesc
	nTotIPI := Iif((cAliasSC7)->C7_IPIBRUT == "L", nTotal, nValor) * ( (cAliasSC7)->C7_IPI / 100 )
	nVlrIPI := xMoeda(nTotIPI,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)  
EndIf

RestArea(aArea)

Return nVlrIPI

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpSaldo  ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi o Saldo.                                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpSaldo(cAliasSC7)

Local aArea    := GetArea()
Local nSalRec  := 0
Local nItemIVA := 0 
Local nQuant   := If(Empty((cAliasSC7)->C7_RESIDUO), Iif((cAliasSC7)->C7_QUANT - (cAliasSC7)->C7_QUJE < 0, 0, (cAliasSC7)->C7_QUANT - (cAliasSC7)->C7_QUJE), 0)
Local nTotal   := 0
Local nSalIPI  := 0
Local nValor   := ((cAliasSC7)->C7_QUANT) * Iif(Empty((cAliasSC7)->C7_REAJUST), (cAliasSC7)->C7_PRECO, Formula((cAliasSC7)->C7_REAJUST))
Local nSaldo   := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * Iif(Empty((cAliasSC7)->C7_REAJUST), (cAliasSC7)->C7_PRECO, Formula((cAliasSC7)->C7_REAJUST))
Local nTotDesc := (cAliasSC7)->C7_VLDESC
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)
Local nI 

If cPaisLoc <> "BRA"
	R120FIniPC((cAliasSC7)->C7_FILIAL,(cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
	aValIVA  := MaFisRet(,"NF_VALIMP")
	If !Empty( aValIVA )
		For nI := 1 To Len( aValIVA )
			nItemIVA += aValIVA[nI]
		Next
	EndIf
	nSalIPI := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * nItemIVA / (cAliasSC7)->C7_QUANT
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
	EndIf
	nTotal := nValor - nTotDesc
	If Empty((cAliasSC7)->C7_RESIDUO)
		nTotal := nSaldo - nTotDesc
		nSalIPI := Iif((cAliasSC7)->C7_IPIBRUT == "L", nTotal, nSaldo) * ( (cAliasSC7)->C7_IPI / 100 )
	EndIf
EndIf

If Empty((cAliasSC7)->C7_REAJUST)
	nSalRec := nQuant * xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)-xMoeda((cAliasSC7)->C7_VLDESC,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) + xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) 
Else
	nSalRec  := nQuant * xMoeda(Formula((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) + xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) 
EndIf

RestArea(aArea)

Return nSalRec

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpVTotal ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi o Valor Total.                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpVTotal(cAliasSC7)

Local aArea    := GetArea()
Local nVlrTot  := 0
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)

R120FIniPC((cAliasSC7)->C7_FILIAL,(cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
nTotal  := MaFisRet(,'NF_TOTAL')
nVlrTot := xMoeda(nTotal,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)		  		

RestArea(aArea)

Return nVlrTot

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ImpDescon ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Imprimi o Valor do Desconto.                               º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpDescon(cAliasSC7)

Local aArea    := GetArea()
Local nVlrDesc := 0
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)

nVlrDesc := xMoeda(C7_VLDESC,SC7->C7_MOEDA,Mv_Par13,SC7->C7_DATPRF,,nTxMoeda)

RestArea(aArea)

Return nVlrDesc

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ Formula  ³ Autor ³ Julio Saraiva         ³ Data ³ 11/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interpreta formula cadastrada trocando o Alias             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ xExp1:= Formula(cExp1,nExp2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ xExp1:= Retorna formula iterpretada                        ³±±
±±³          ³ cExp1:= Codigo da formula previamente cadastrada em SM4    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Form120(cFormula)

Local xAlias 
Local cForm		:= "" , xValor
Local cString 	:= "SC7->"
Local cNewAlias := "" 
Local cNewForm	:= ""
//Salva a integridade dos dados
xAlias := Alias()

dbSelectArea("SM4")
If dbSeek(cFilial + cFormula)
	cForm := AllTrim(M4_FORMULA)
	cNewAlias := xAlias + "->"
	cNewForm := StrTran(cForm,cString,cNewAlias)
	dbSelectArea(xAlias)      
	xValor := &cNewForm
Else
	xValor := Nil
EndIf

dbSelectArea(xAlias)

Return xValor

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao    ³R120FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R120FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function R120FIniPC(cFil,cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->( GetArea() )
Local cValid	:= ""
Local nPosRef	:= 0
Local nItem		:= 0
Local cItemDe	:= Iif(cItem == Nil, '', cItem)
Local cItemAte	:= Iif(cItem == Nil, Repl('Z',Len(SC7->C7_ITEM)), cItem)
Local cRefCols	:= ''
Local aStru		:= FWFormStruct(3,"SC7")[1]
Local nX

Default cSequen	:= ""
Default cFiltro	:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(cFil + cPedido + cItemDe + Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .And. SC7->C7_FILIAL + SC7->C7_NUM == cFil + cPedido .And. SC7->C7_ITEM <= cItemAte .And. (Empty(cSequen) .Or. cSequen == SC7->C7_SEQUEN)
		// Nao processar os Impostos se o item possuir residuo eliminado  
		If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
			Loop
		EndIf
		// Inicia a Carga do item nas funcoes MATXFIS  
		nItem++
		MaFisIniLoad(nItem)
		For nX := 1 To Len(aStru)
			cValid	:= StrTran(Upper(GetCbSource(aStru[nX][7]))," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF" $ cValid .And. !(aStru[nX][14])
				nPosRef  := At('MAFISREF("',cValid) + 10
				cRefCols := Substr(cValid,nPosRef,At('","MT120",',cValid)-nPosRef )
				// Carrega os valores direto do SC7.           
				MaFisLoad(cRefCols,&("SC7->" + aStru[nX][3]),nItem)
			EndIf
		Next nX
		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.

Static Function SchedDef()

Local aParam 	:= {}
Local aOrd		:= {}

aAdd( aOrd, "Por Numero" )
aAdd( aOrd, "Por Produto" )
aAdd( aOrd, "Por Fornecedor" )
aAdd( aOrd, "Por Previsao de Entrega " )

aParam := { "R",;		//Tipo R para relatorio P para processo
            "XMTR120",;	//Pergunte do relatorio, caso nao use passar ParamDef
            "SC7",;		//Alias
            aOrd,;		//Array de ordens
            "Relacao de Pedidos de Compras"}	//Titulo

Return aParam
