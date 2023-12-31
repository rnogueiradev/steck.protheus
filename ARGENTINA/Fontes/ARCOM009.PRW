#Include "Matr120.ch"
#Include "PROTHEUS.Ch"

/*/{Protheus.doc} ARCOM009

Relacao de Pedidos de Compras - Argentina

@type function
@author Everson Santana
@since 17/06/19
@version Protheus 12 - Compras

@history ,Ticket 20190611000095,

/*/

User Function ARCOM009()
	Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef(nReg)

	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3
	Local oSection4
	Local oSection5
	Local oCell
	Local aOrdem	:= {}
	Local cAliasSC7 := GetNextAlias()

	PRIVATE cPerg := "MTR120"
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿎riacao do componente de impressao                                      �
	//�                                                                        �
	//쿟Report():New                                                           �
	//쿐xpC1 : Nome do relatorio                                               �
	//쿐xpC2 : Titulo                                                          �
	//쿐xpC3 : Pergunte                                                        �
	//쿐xpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
	//쿐xpC5 : Descricao                                                       �
	//�                                                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	oReport:= TReport():New("MATR120",STR0007,"MTR120", {|oReport| ReportPrint(oReport,cAliasSC7)},STR0001+" "+STR0002+" "+STR0003) //"Relacao de Pedidos de Compras"##"Emissao da Relacao de  Pedidos de Compras."##"Sera solicitado em qual Ordem, qual o Intervalo para"##"a emissao dos pedidos de compras."
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	Pergunte("MTR120",.F.)
	Aadd( aOrdem, STR0004 ) // "Por Numero"
	Aadd( aOrdem, STR0005 ) // "Por Produto"
	Aadd( aOrdem, STR0006 ) // "Por Fornecedor"
	Aadd( aOrdem, STR0049 ) // "Por Previsao de Entrega "

	oSection1 := TRSection():New(oReport,"Relacao de Pedidos de Compras",{"SC7","SA2","SB1","Z27"},aOrdem) //"Relacao de Pedidos de Compras"
	oSection1 :SetTotalInLine(.F.)

	TRCell():New(oSection1,"C7_NUM","SC7","Num.PC"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Num.PC"
	TRCell():New(oSection1,"C7_NUMSC","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C7_LOJA","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"A2_FAX","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
	TRCell():New(oSection1,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
	TRCell():New(oSection1,"C7_DATPRF","SC7",STR0052,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"ENTREGA PREVISTA :  "
	oSection1:Cell("cDescri"):GetFieldInfo("B1_DESC")

	oSection2 := TRSection():New(oSection1,STR0063,{"SC7","SA2","SB1","Z27"})
	oSection2 :SetTotalInLine(.F.)
	oSection2 :SetHeaderPage()
	oSection2 :SetTotalText(STR0033) //"Total Geral "

	TRCell():New(oSection2,"C7_NUM","SC7",STR0065/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Num.PC"
	TRCell():New(oSection2,"C7_ITEM","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
	TRCell():New(oSection2,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
	oSection2:Cell("cDescri"):GetFieldInfo("B1_DESC")
	TRCell():New(oSection2,"B1_GRUPO","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C7_EMISSAO","SC7",STR0068/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Emissao"
	TRCell():New(oSection2,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C7_LOJA","SC7",STR0067/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Lj"
	TRCell():New(oSection2,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C7_DATPRF","SC7",STR0066/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Entrega"
	TRCell():New(oSection2,"C7_QUANT","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C7_UM","SC7",STR0069/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"UM"
	TRCell():New(oSection2,"nVlrUnit","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVunit(cAliasSC7) })
	oSection2:Cell("nVlrUnit"):GetFieldInfo("C7_PRECO")
	TRCell():New(oSection2,"C7_VLDESC","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescon(cAliasSC7) })
	TRCell():New(oSection2,"nVlrIPI","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVIPI(cAliasSC7) })
	oSection2:Cell("nVlrIPI"):GetFieldInfo("C7_VALIPI")
	TRCell():New(oSection2,"C7_TOTAL","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVTotal(cAliasSC7) })
	TRCell():New(oSection2,"C7_QUJE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"nQtdRec","   ",STR0060,PesqPict('SC7','C7_QUANT'),/*Tamanho*/,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),IIF((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE<0,0,(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE),0) }) //Quant.Receber
	TRCell():New(oSection2,"nSalRec","   ",STR0061,PesqPict('SC7','C7_TOTAL'),TamSX3("C7_TOTAL")[1],/*lPixel*/,{|| ImpSaldo(cAliasSC7) }) //Saldo Receber
	TRCell():New(oSection2,"C7_RESIDUO","   ",STR0070+CRLF+STR0071/*Titulo*/,/*Picture*/,3,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),STR0031,STR0032) }) //"Res."##"Elim."

	TRCell():New(oSection2,"Z27_FACTUR","Z27","Factura		",/*Picture*/,TamSX3("Z27_FACTUR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_MARCA ","Z27","Marca		",/*Picture*/,TamSX3("Z27_MARCA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_PEDFAT","Z27","Pedido		",/*Picture*/,TamSX3("Z27_PEDFAT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_EMBARQ","Z27","Puerto Embar	",/*Picture*/,TamSX3("Z27_EMBARQ")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_DESTIN","Z27","Destino Fina	",/*Picture*/,TamSX3("Z27_DESTIN")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_DESEMB","Z27","Puerto Desem	",/*Picture*/,TamSX3("Z27_DESEMB")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_PNETO ","Z27","Peso Neto	",/*Picture*/,TamSX3("Z27_PNETO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_PBRUTO","Z27","Peso Bruto	",/*Picture*/,TamSX3("Z27_PBRUTO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_VOLUME","Z27","Volumen		",/*Picture*/,TamSX3("Z27_VOLUME")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_TOTAL ","Z27","Total		",/*Picture*/,TamSX3("Z27_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_LOCAL ","Z27","Local	    ",/*Picture*/,TamSX3("Z27_LOCAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_NOTIFI","Z27","Notificar   	",/*Picture*/,TamSX3("Z27_NOTIFI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_ORIGEN","Z27","Origen      	",/*Picture*/,TamSX3("Z27_ORIGEN")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"Z27_PROCED","Z27","Procedencia 	",/*Picture*/,TamSX3("Z27_PROCED")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

	TRFunction():New(oSection2:Cell("nVlrIPI"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("C7_TOTAL"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("nSalRec"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)


Return(oReport)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿝eportPrin� Autor 쿙ereu Humberto Junior  � Data �16.05.2006낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿌 funcao estatica ReportDef devera ser criada para todos os 낢�
굇�          퀁elatorios que poderao ser agendados pelo usuario.          낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpO1: Objeto Report do Relat�rio                           낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Static Function ReportPrint(oReport,cAliasSC7)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oBreak
	Local nTxMoeda	:= 1
	Local lFirst    := .F.
	Local nOrdem    := oReport:Section(1):GetOrder()
	Local nTamDPro	:= If( TamSX3("C7_PRODUTO")[1] > 15, 20, 30 )
	Local nFilters 	:= 0
	Local nI
	Local cWhere := ""
	Local cFrom := "%%"
	Local lFilUsr	:= oSection1:GetAdvplExp() <> ""

	dbSelectArea("SC7")
	If nOrdem == 4
		dbSetOrder(16)
	Else
		dbSetOrder(nOrdem)
	EndIf

	If nOrdem == 1
		If ( cPaisLoc$"ARG|POR|EUA" )	//Ordena los pedidos de compra y luego la AE.
			dbSetOrder(10)
		Endif
		oReport:SetTitle( oReport:Title()+STR0014) // " - POR NUMERO"
		oSection1 :SetTotalText(STR0034) //"Total dos Itens: "
	ElseIf nOrdem == 2
		oReport:SetTitle( oReport:Title()+STR0018) //" - POR PRODUTO"
		oSection1 :SetTotalText(STR0035) //"Total do Produto"
	ElseIf nOrdem == 3
		oReport:SetTitle( oReport:Title()+STR0022) //" - POR FORNECEDOR"
		oSection1 :SetTotalText(STR0036) //"Total do Fornecedor"
	ElseIf nOrdem == 4
		oReport:SetTitle( oReport:Title()+STR0053) //" - POR PREVISAO DE ENTREGA"
		oSection1 :SetTotalText(STR0043) //"Total da Previsao de Entrega"
	Endif

	If mv_par07==1
		oReport:SetTitle( oReport:Title()+STR0025) //", Todos"
	Elseif mv_par07==2
		oReport:SetTitle( oReport:Title()+STR0026) //", Em Abertos"
	Elseif mv_par07==3
		oReport:SetTitle( oReport:Title()+STR0027) //", Residuos"
	Elseif mv_par07==4
		oReport:SetTitle( oReport:Title()+STR0028) //", Atendidos"
	Elseif mv_par07==5
		oReport:SetTitle( oReport:Title()+STR0059) //", Atendidos + Parcial entregue"
	Endif
	oReport:SetTitle( oReport:Title()+" - " + GetMv("MV_MOEDA"+STR(mv_par13,1))) //" MOEDA "
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿑iltragem do relat�rio                                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿟ransforma parametros Range em expressao SQL                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	MakeSqlExpr(oReport:uParam)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿜uery do relat�rio da secao 1                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	oReport:Section(1):BeginQuery()

	cWhere :="%"

	If mv_par11 == 1
		cWhere += "AND C7_CONAPRO <> 'B' "
	ElseIf mv_par11 == 2
		cWhere += "AND C7_CONAPRO = 'B' "
	Endif

	If mv_par07 == 2
		cWhere += "AND ( (C7_QUANT-C7_QUJE) > 0 ) "
		cWhere += "AND C7_RESIDUO = ' ' "
	ElseIf mv_par07 == 3
		cWhere += "AND C7_RESIDUO <> ' ' "
	ElseIf mv_par07 == 4
		cWhere += "AND C7_QUANT <= C7_QUJE "
	ElseIf mv_par07 == 5
		cWhere += "AND C7_QUJE > 0 "
	Endif

	If mv_par10 == 1
		cWhere += "AND C7_TIPO = 1 "
	ElseIf mv_par10 == 2
		cWhere += "AND C7_TIPO = 2 "
	Endif

	If mv_par12 == 1 //Firmes
		cWhere += "AND (C7_TPOP = 'F' OR C7_TPOP = ' ') "
	ElseIf mv_par12 == 2 //Previstas
		cWhere += "AND C7_TPOP = 'P' "
	Endif

	If lFilUsr
		nFilters := len(oSection1:aUserFilter)

		cFrom := "%"

		For nI := 1 to nFilters
			If oSection1:aUserFilter[nI][1] == "SA2" .And. oSection1:aUserFilter[nI][2] <> ""
				cFrom += "," + RetSqlName("SA2") + " SA2 "
				cWhere += "AND C7_FORNECE = A2_COD AND SA2.D_E_L_E_T_ = ' ' "
				If FWModeAccess("SC7")=="E" .And. FWModeAccess("SA2")=="E"
					cWhere += "AND SC7.C7_FILIAL = SA2.A2_FILIAL "
				Endif

			ElseIf	oSection1:aUserFilter[nI][1] == "SB1" .And. oSection1:aUserFilter[nI][2] <> ""
				cFrom += "," + RetSqlName("SB1") + " SB1 "
				cWhere += "AND C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' ' "
				If FWModeAccess("SC7")=="E" .And. FWModeAccess("SB1")=="E"
					cWhere += "AND SC7.C7_FILIAL = SB1.B1_FILIAL "
				Endif
			ElseIf	oSection1:aUserFilter[nI][1] == "Z27" .And. oSection1:aUserFilter[nI][2] <> ""
				cFrom += "," + RetSqlName("Z27") + " Z27 "
				cWhere += "AND C7_NUM = Z27_PEDCOM AND Z27.D_E_L_E_T_ = ' ' "
				If FWModeAccess("SC7")=="E" .And. FWModeAccess("Z27")=="E"
					cWhere += "AND SC7.C7_FILIAL = Z27.Z27_FILIAL "
				Endif

			Endif
		Next nI

		cFrom += "%"
	Endif

	cWhere +="%"

	BeginSql Alias cAliasSC7

		SELECT SC7.*

		FROM %table:SC7% SC7 %Exp:cFrom%

		WHERE C7_FILIAL = %xFilial:SC7% AND
		C7_NUM >= %Exp:mv_par08% AND
		C7_NUM <= %Exp:mv_par09% AND
		C7_PRODUTO >= %Exp:mv_par01% AND
		C7_PRODUTO <= %Exp:mv_par02% AND
		C7_EMISSAO >= %Exp:Dtos(mv_par03)% AND
		C7_EMISSAO <= %Exp:Dtos(mv_par04)% AND
		C7_DATPRF >= %Exp:Dtos(mv_par05)% AND
		C7_DATPRF <= %Exp:Dtos(mv_par06)% AND
		C7_FORNECE >= %Exp:mv_par15% AND
		C7_FORNECE <= %Exp:mv_par16% AND
		SC7.%NotDel%
		%Exp:cWhere%

		ORDER BY %Order:SC7%

	EndSql
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿘etodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//쿛repara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//쿐xpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿘etodo TrPosition()                                                     �
	//�                                                                        �
	//쿛osiciona em um registro de uma outra tabela. O posicionamento ser�     �
	//퀁ealizado antes da impressao de cada linha do relat�rio.                �
	//�                                                                        �
	//�                                                                        �
	//쿐xpO1 : Objeto Report da Secao                                          �
	//쿐xpC2 : Alias da Tabela                                                 �
	//쿐xpX3 : Ordem ou NickName de pesquisa                                   �
	//쿐xpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
	//�        cutada.                                                         �
	//�                                                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA})
	TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
	TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA})
	TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
	TRPosition():New(oSection2,"Z27",1,{|| xFilial("Z27") + (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA})
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿔nicio da impressao do fluxo do relat�rio                               �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	oReport:SetMeter(SC7->(LastRec()))

	If nOrdem <> 2
		oSection1:Cell("cDescri"):SetSize(nTamDPro)
		oSection2:Cell("cDescri"):SetSize(nTamDPro)
	EndIf

	Do Case
		Case nOrdem == 1

		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()

		oSection2:Cell("C7_NUM"):Disable()
		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()

		oSection1:Print()

		Case nOrdem == 2

		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()

		oSection2:Cell("C7_PRODUTO"):Disable()
		oSection2:Cell("cDescri"):Disable()
		oSection2:Cell("B1_GRUPO"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection2:Cell("A2_TEL"):Disable()

		oSection1:Print()

		Case nOrdem == 3

		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()
		oSection1:Cell("C7_DATPRF"):Disable()

		oSection2:Cell("C7_FORNECE"):Disable()
		oSection2:Cell("A2_NOME"):Disable()
		oSection2:Cell("A2_TEL"):Disable()
		oSection2:Cell("C7_UM"):Disable()

		oSection1:Print()

		Case nOrdem == 4

		oSection1:Cell("C7_NUM"):Disable()
		oSection1:Cell("C7_NUMSC"):Disable()
		oSection1:Cell("C7_FORNECE"):Disable()
		oSection1:Cell("A2_NOME"):Disable()
		oSection1:Cell("A2_TEL"):Disable()
		oSection1:Cell("A2_FAX"):Disable()
		oSection1:Cell("A2_CONTATO"):Disable()
		oSection1:Cell("C7_PRODUTO"):Disable()
		oSection1:Cell("cDescri"):Disable()

		oSection2:Cell("B1_GRUPO"):Disable()
		oSection2:Cell("C7_DATPRF"):Disable()
		oSection2:Cell("C7_UM"):Disable()
		oSection2:Cell("C7_FORNECE"):SetTitle(STR0064) //"Fornec."
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

Return NIL
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpDescri 튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpDescri(cAliasSC7)

	Local aArea   := GetArea()
	Local cDescri := ""

	If Empty(mv_par14)
		mv_par14 := "B1_DESC"
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Impressao da descricao cientifica do Produto.                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If AllTrim(mv_par14) == "B5_CEME"
		dbSelectArea("SB5")
		dbSetOrder(1)
		dbSeek( xFilial("SB5")+(cAliasSC7)->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf

	If AllTrim(mv_par14) == "C7_DESCRI"
		dbSelectArea("SC7")
		cDescri := Alltrim((cAliasSC7)->C7_DESCRI)
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Impressao da descricao generica do Produto.                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If AllTrim(mv_par14) == "B1_DESC" .OR. Empty(cDescri)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial("SB1")+(cAliasSC7)->C7_PRODUTO )
		cDescri := Alltrim(SB1->B1_DESC)
	EndIf

	RestArea(aArea)
Return(cDescri)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpVunit  튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpVunit(cAliasSC7)

	Local aArea    := GetArea()
	Local nVlrUnit := 0
	Local aTam	   := TamSx3("C7_PRECO")
	Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

	If !Empty((cAliasSC7)->C7_REAJUST)
		nVlrUnit := xMoeda(Form120((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda)
	Else
		nVlrUnit := xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda)
	Endif

	RestArea(aArea)

Return(nVlrUnit)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpVIPI   튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpVIPI(cAliasSC7)

	Local aArea    := GetArea()
	Local nVlrIPI  := 0
	Local nToTIPI  := 0
	Local nTotal   := 0
	Local nItemIVA := 0
	Local nValor   := ((cAliasSC7)->C7_QUANT) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
	Local nTotDesc := (cAliasSC7)->C7_VLDESC
	Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)
	Local nI

	If cPaisLoc <> "BRA"
		R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
		aValIVA := MaFisRet(,"NF_VALIMP")
		If !Empty( aValIVA )
			For nI := 1 To Len( aValIVA )
				nItemIVA += aValIVA[nI]
			Next
		Endif
		nVlrIPI := xMoeda(nItemIVA,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)
	Else
		If nTotDesc == 0
			nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
		EndIF
		nTotal := nValor - nTotDesc
		nTotIPI := IIF((cAliasSC7)->C7_IPIBRUT == "L",nTotal, nValor) * ( (cAliasSC7)->C7_IPI / 100 )
		nVlrIPI := xMoeda(nTotIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)
	EndIf

	RestArea(aArea)

Return(nVlrIPI)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpSaldo  튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpSaldo(cAliasSC7)

	Local aArea    := GetArea()
	Local nSalRec  := 0
	Local nItemIVA := 0
	Local nQuant   := If(Empty((cAliasSC7)->C7_RESIDUO),IIF((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE<0,0,(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE),0)
	Local nTotal   := 0
	Local nSalIPI  := 0
	Local nValor   := ((cAliasSC7)->C7_QUANT) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
	Local nSaldo   := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
	Local nTotDesc := (cAliasSC7)->C7_VLDESC
	Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)
	Local nI

	If cPaisLoc <> "BRA"
		R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
		aValIVA  := MaFisRet(,"NF_VALIMP")
		If !Empty( aValIVA )
			For nI := 1 To Len( aValIVA )
				nItemIVA += aValIVA[nI]
			Next
		Endif
		nSalIPI := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * nItemIVA / (cAliasSC7)->C7_QUANT
	Else
		If nTotDesc == 0
			nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
		EndIF
		nTotal := nValor - nTotDesc
		If Empty((cAliasSC7)->C7_RESIDUO)
			nTotal := nSaldo - nTotDesc
			nSalIPI := IIF((cAliasSC7)->C7_IPIBRUT == "L",nTotal, nSaldo) * ( (cAliasSC7)->C7_IPI / 100 )
		Endif
	EndIf

	If Empty((cAliasSC7)->C7_REAJUST)
		nSalRec := nQuant * xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)-xMoeda((cAliasSC7)->C7_VLDESC,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) + xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)
	Else
		nSalRec  := nQuant * xMoeda(Formula((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) + ;
		xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)
	Endif

	RestArea(aArea)

Return(nSalRec)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpVTotal 튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpVTotal(cAliasSC7)

	Local aArea    := GetArea()
	Local nVlrTot  := 0
	Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

	R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
	nTotal  := MaFisRet(,'NF_TOTAL')
	nVlrTot := xMoeda(nTotal,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)

	RestArea(aArea)

Return(nVlrTot)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿔mpDescon 튍utor쿙ereu Humberto Junior � Data � 12/06/2006  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튧so       � MATR120                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function ImpDescon(cAliasSC7)

	Local aArea    := GetArea()
	Local nVlrDesc := 0
	Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

	nVlrDesc := xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)

	RestArea(aArea)

Return(nVlrDesc)


Static Function R120FIniPC(cPedido,cItem,cSequen,cFiltro)

	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cValid		:= ""
	Local nPosRef		:= 0
	Local nItem		:= 0
	Local cItemDe		:= IIf(cItem==Nil,'',cItem)
	Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
	Local cRefCols	:= ''
	DEFAULT cSequen	:= ""
	DEFAULT cFiltro	:= ""

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
		MaFisEnd()
		MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
		While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
		SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

			// Nao processar os Impostos se o item possuir residuo eliminado
			If &cFiltro
				dbSelectArea('SC7')
				dbSkip()
				Loop
			EndIf

			// Inicia a Carga do item nas funcoes MATXFIS
			nItem++
			MaFisIniLoad(nItem)
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek('SC7')
			While !EOF() .AND. (X3_ARQUIVO == 'SC7')
				cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
				cValid	:= StrTran(cValid,"'",'"')
				If "MAFISREF" $ cValid
					nPosRef  := AT('MAFISREF("',cValid) + 10
					cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
					// Carrega os valores direto do SC7.
					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
				dbSkip()
			End
			MaFisEndLoad(nItem,2)
			dbSelectArea('SC7')
			dbSkip()
		End
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return .T.