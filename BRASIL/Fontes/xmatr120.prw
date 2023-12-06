#Include "Protheus.ch"

/*����������������������������������������������������������������������������
���Fun��o    � MATR120 � Autor � Nereu Humberto Junior � Data � 12.06.06   ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Pedidos de Compras                    ���
���Descri��o �                     										   ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                      ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   		�Manutencao efetuada                   ���
��������������������������������������������������������������������������Ĵ��
��� 12.05.21 � Eduardo Pereira      � De MATR120 p/ User Function XMATR120 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Alterado o MATR120 para User Function incluindo o filtro    ���
���Descri��o � das Filiais para n�o considerar apenas a Filial logada.     ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � .T.	/  .F.                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Steck                                            ���
����������������������������������������������������������������������������*/

User Function xMatr120()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*���������������������������������������������������������������������������
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �12.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
���������������������������������������������������������������������������*/

Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local aOrdem	:= {}
Local cAliasSC7 := GetNextAlias()
Private cPerg 	:= "XMTR120"

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
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

oSection2 := TRSection():New(oSection1,"Pedido de Compras / Autoriza��o de Entrega (Produtos)",{"SC7","SA2","SB1"}) 
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
TRCell():New(oSection2,"C7_RESIDUO","   ","Res." + CRLF + "Elim."/*Titulo*/,/*Picture*/,3,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),"N�o","Sim") })
TRCell():New(oSection2,"C7_FILIAL","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection2:Cell("nVlrIPI"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
TRFunction():New(oSection2:Cell("C7_TOTAL"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nSalRec"),Nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 

Return(oReport)

/*���������������������������������������������������������������������������
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �16.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
���������������������������������������������������������������������������*/

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
//Filtragem do relat�rio
//Transforma parametros Range em expressao SQL
MakeSqlExpr(oReport:uParam)
//Query do relat�rio da secao 1
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
//Posiciona em um registro de uma outra tabela. O posicionamento ser� realizado antes da impressao de cada linha do relat�rio.
//ExpO1 : Objeto Report da Secao
//ExpC2 : Alias da Tabela
//ExpX3 : Ordem ou NickName de pesquisa
//ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexecutada.
TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE + (cAliasSC7)->C7_LOJA})
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE + (cAliasSC7)->C7_LOJA})
TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
//Inicio da impressao do fluxo do relat�rio
oReport:SetMeter( SC7->( LastRec() ) )

If nOrdem <> 2
	oSection1:Cell("cDescri"):SetSize(nTamDPro)
	oSection2:Cell("cDescri"):SetSize(nTamDPro)
EndIf

Do Case
	Case nOrdem == 1
		// Se��o 1
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Se��o 2
		oSection2:Cell("C7_NUM"):Disable()
		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection1:Print()
	Case nOrdem == 2
		// Se��o 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Se��o 2
		oSection2:Cell("C7_PRODUTO"):Disable()
		oSection2:Cell("cDescri"):Disable()
		oSection2:Cell("B1_GRUPO"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection1:Print()
	Case nOrdem == 3
		// Se��o 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()
		// Se��o 2
		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection1:Print()
	Case nOrdem == 4
		// Se��o 1
		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		// Se��o 2
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

/*���������������������������������������������������������������������������
���Funcao    �ImpDescri �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi a descri�ao do Produto.		                      ���
���������������������������������������������������������������������������*/

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

/*���������������������������������������������������������������������������
���Funcao    �ImpVunit  �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi o Valor Unit�rio.                                  ���
���������������������������������������������������������������������������*/

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

/*���������������������������������������������������������������������������
���Funcao    �ImpVIPI   �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi Valor do IPI.                                      ���
���������������������������������������������������������������������������*/

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

/*���������������������������������������������������������������������������
���Funcao    �ImpSaldo  �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi o Saldo.                                           ���
���������������������������������������������������������������������������*/

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

/*���������������������������������������������������������������������������
���Funcao    �ImpVTotal �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi o Valor Total.                                     ���
���������������������������������������������������������������������������*/

Static Function ImpVTotal(cAliasSC7)

Local aArea    := GetArea()
Local nVlrTot  := 0
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)

R120FIniPC((cAliasSC7)->C7_FILIAL,(cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
nTotal  := MaFisRet(,'NF_TOTAL')
nVlrTot := xMoeda(nTotal,(cAliasSC7)->C7_MOEDA,Mv_Par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)		  		

RestArea(aArea)

Return nVlrTot

/*���������������������������������������������������������������������������
���Funcao    �ImpDescon �Autor�Nereu Humberto Junior � Data � 12/06/2006  ���
�������������������������������������������������������������������������͹��
���Uso       � Imprimi o Valor do Desconto.                               ���
���������������������������������������������������������������������������*/

Static Function ImpDescon(cAliasSC7)

Local aArea    := GetArea()
Local nVlrDesc := 0
Local nTxMoeda := Iif((cAliasSC7)->C7_TXMOEDA > 0, (cAliasSC7)->C7_TXMOEDA, Nil)

nVlrDesc := xMoeda(C7_VLDESC,SC7->C7_MOEDA,Mv_Par13,SC7->C7_DATPRF,,nTxMoeda)

RestArea(aArea)

Return nVlrDesc

/*���������������������������������������������������������������������������
���Fun��o    � Formula  � Autor � Julio Saraiva         � Data � 11/04/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Interpreta formula cadastrada trocando o Alias             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � xExp1:= Formula(cExp1,nExp2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� xExp1:= Retorna formula iterpretada                        ���
���          � cExp1:= Codigo da formula previamente cadastrada em SM4    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO                                                   ���
���������������������������������������������������������������������������*/

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

/*���������������������������������������������������������������������������
���Funcao    �R120FIniPC� Autor � Edson Maricate        � Data �20/05/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Inicializa as funcoes Fiscais com o Pedido de Compras      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R120FIniPC(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Numero do Pedido                                  ���
���          � ExpC2 := Item do Pedido                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110,MATR120,Fluxo de Caixa                             ���
���������������������������������������������������������������������������*/

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
