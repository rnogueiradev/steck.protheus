#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CR    chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STPCR004 ³ Autor ³ RVG                   ³ Data ³ 20/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estoque Disponivel Steck                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STPCR004()

	Local oReport

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportDef ³ Autor ³Marcos V. Ferreira     ³ Data ³13/06/05  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
	±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATR350			                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local aOrdem    := {}
	Local cPictQt   := PesqPict("SB2","B2_QATU")
	Local nTamQt    := TamSX3('B2_QATU')[1]
	Local oCabec
	Local oFaltas
	Local cAliasTRB := GetNextAlias()
	LOCAL cAliasBD := ""

	Private cPerg   := "STPCR00404"
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
	AjustaSX1()

	oReport:= TReport():New("STPCR004","Lista de Estoque Disponivel Steck",cPerg, {|oReport| ReportPrint(oReport, ,cAliasTRB)},;
		"O relatorio irá listar saldos em estoque STECK ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                          ³
	//³ mv_par01     // Produto inicial                               ³
	//³ mv_par02     // Produto final                                 ³
	//³ mv_par03     // Considera saldo entradas em aberto            ³
	//³ mv_par04     // Lista somente registros com saldo neg         ³
	//³ mv_par05     // Almoxarifado de (para formacao do saldo Ini)  ³
	//³ mv_par06     // Almoxarifado Ate(para formacao do saldo Ini)  ³
	//³ mv_par07     // Considera OPs 1- Firmes 2- Previstas 3- Ambas ³
	//³ mv_par08     // Apenas SCs com data limite de compra em atraso³
	//³ mv_par09     // Da Ordem de Producao                          ³
	//³ mv_par10     // Ate a Ordem de Producao                       ³
	//³ mv_par11     // Listar as OPs 1.Atendidas/N Atendidas/Ambas   ³
	//³ mv_par12     // Qtd. Nossa Poder 3o.  1-Ignora / 2-Soma       ³
	//³ mv_par13     // Qtd. 3o. Nosso Poder  1-Ignora / 2-Subtrai    ³
	//³ mv_par14     // Utiliza Data                                  ³
	//³ mv_par15     // Data de referencia                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(oReport:uParam,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



	oSection1 := TRSection():New(oReport,"Faltas ",{},aOrdem) //"Lista de Faltas"##"Produtos"
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1,'B1_COD'    	,cAliasTRB,/*Titulo*/,"@!",20,/*lPixel*/,{||_xB1_COD})
	TRCell():New(oSection1,'B1_DESC' 	,cAliasTRB,/*Titulo*/,/*Picture*/,35,/*lPixel*/,{||_xDesc})
	TRCell():New(oSection1,'B1_UM'   	,cAliasTRB,/*Titulo*/,/*Picture*/,4,/*lPixel*/,)
	TRCell():New(oSection1,'B1_TIPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,4,/*lPixel*/, )
	TRCell():New(oSection1,'B1_GRUPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,5,/*lPixel*/, )
	TRCell():New(oSection1,'B1_CLAPROD'	,cAliasTRB,/*Titulo*/,/*Picture*/,4,/*lPixel*/, )
	TRCell():New(oSection1,'B1_XLIBDES'	,cAliasTRB,/*Titulo*/,"@!",20,/*lPixel*/, )
	TRCell():New(oSection1,'B1_ESTSEG'	,cAliasTRB,"Estoque Seg"   	,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'SLD_ATU'	,cAliasTRB,"Saldo Atual"   	,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'FALTAS'	    ,cAliasTRB,"FALTAS"   	,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'SALDO'	    , 		  ,"SALDO"   	,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'xOP'		,         ,"Neces. OP"     	,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'xPV'		, 		  ,"Neces. PV"     	,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'xSaldo1'  	, 		  ,"Sld Liquido"    ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'SCS'		,cAliasTRB,"S.Compra"   	,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'PCS'		,cAliasTRB,"P.Compra"  		,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'OPX'		,cAliasTRB,"Ord.Producao"   ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'xSaldo2'  	, 		  ,"Liq.Reabastec." ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'L_98'   	,cAliasTRB,"Saldo CQ"		,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'C_MEDIO'  	,         ,"Media Trim 01"  ,"@E 999999,999.9",12,/*lPixel*/,{|| _cMedio } )
	TRCell():New(oSection1,'C_ANO'  	,         ,"Media Anual 01" ,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'C_MEDIO2'  	,         ,"Media Trim 02"  ,"@E 999999,999.9",12,/*lPixel*/,{|| _cMedio2 } )
	TRCell():New(oSection1,'C_ANO2'  	,         ,"Media Anual 02" ,"@E 999999,999.9",12,/*lPixel*/, )
	TRCell():New(oSection1,'C_BLOQ'  	,         ,"Blq"    		 ,"@!",3,/*lPixel*/,{|| _cBlq } )
	TRCell():New(oSection1,'B1_XFMR'  	,cAliasTRB,"FMR"    		 ,"@!",3,/*lPixel*/,  )
	TRCell():New(oSection1,'B1_XABC'  	,cAliasTRB,"ABC"    		 ,"@!",3,/*lPixel*/,  )
	TRCell():New(oSection1,'SLD_PREV'  	,cAliasTRB,"Previsao Vendas" ,"@E 999999,999.9",12,/*lPixel*/,  )

	oSection2 := TRSection():New(oSection1,"Pedidos ",{},aOrdem) //"Lista de Faltas"##"Produtos"
	oSection2:SetTotalInLine(.F.)

	TRCell():New(oSection2,'PedCompra'  	, ,"Numero PC"     	 ,"@!"				,12,/*lPixel*/,{|| _cPedido })
	TRCell():New(oSection2,'cData'   	  	, ,"Entrega"    	 ,"@!"				,12,/*lPixel*/,{|| _dEntrega })
	TRCell():New(oSection2,'nQuant'  		, ,"Quantidade"      ,"@E 999999,999.9"	,12,/*lPixel*/,{|| _nQuant })

Return(oReport)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportPrint ³ Autor ³ RVG                 ³ Data ³05/04/13  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
	±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³       			                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)

	Local oSection1    := oReport:Section(1)
	Local oSection2    := oReport:Section(1):Section(1)
	Local nOrdem       := oSection1:GetOrder()

	cMes1	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2)
	cMes2	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2)
	cMes3	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)


	IF nOrdem == 2
		_cExpress := "PA1.PA1_FILIAL,PA1.PA1_DOC"
	ELSE
		_cExpress := "PA1.PA1_FILIAL,PA1_CODPRO,PA1.PA1_DOC"
	ENDIF

	lQuery 		:= .T.

	_cFilin := + FORMATIN(MV_PAR13,',')
	_cGrupos := + FORMATIN(MV_PAR14,',')

	Do Case
	Case MV_PAR07 = 1
		_cWhere := " B1_CLAPROD = 'C' "
	Case MV_PAR07 = 2
		_cWhere := " B1_CLAPROD = 'F' "
	Case MV_PAR07 = 3
		_cWhere := " B1_CLAPROD = 'I' "
	Otherwise
		_cWhere := " B1_FILIAL = '"+xfilial("SB1")+"' "
	Endcase

	//(SELECT SUM(%exp:cMes%)/3     FROM %table:SB3% SB3 WHERE %exp:_cFilSB3% AND B3_COD = SB1.B1_COD AND SB3.%NotDel%   ) AS C_MEDIO,

	/*/ BLOCO ANTERIOR
	_cFilSB3 := "% B3_FILIAL = '"+xfilial("SB3")+"' %"
	//_cFilSB2 := "% B2_FILIAL = '"+xfilial("SB2")+"' %"
	_cFilSC1 := "% C1_FILIAL = '"+xfilial("SC1")+"' %"
	_cFilSC4 := "% C4_FILIAL = '"+xfilial("SC4")+"' AND C4_DATA LIKE '"+SUBSTR(DTOS(DATE()),1,6)+ "%' %"
	//_cFilSB2 := "% B2_FILIAL IN ('01','02') %"

	_cFilSB2 := "% B2_FILIAL = '"+xfilial("SB2")+"' %"
	/*/

	_cFilSB3 := "% B3_FILIAL IN "+ _cFilin+" %"
	_cFilSC1 := "% C1_FILIAL IN "+ _cFilin+" %"
	_cFilSC4 := "% C4_FILIAL IN "+ _cFilin+ "%' %"
	_cFilSB2 := "% B2_FILIAL IN "+ _cFilin+" %"
	If Empty(_cGrupos)
		_cGrupFil := "AND	SB1.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+'"
	else
		_cGrupFil := " B1_GRUPO IN "+ _cGrupos+" "
	EndIF

	//	_cFilin

	Do Case
	Case MV_PAR11 = 1
		_cBlq := " B1_MSBLQL = '1' "
	Case MV_PAR11 = 2
		_cBlq := " B1_MSBLQL <> '1' "
	Case MV_PAR11 = 3
		_cBlq := " B1_MSBLQL <> '4' "
	EndCase

	oReport:Section(1):BeginQuery()

	//BeginSql Alias cAliasTRB
	IF MV_PAR15 = 2 
		cQuery := "SELECT DISTINCT B1_COD,B1_DESC,B1_TIPO,B1_GRUPO, B1_UM,B1_CLAPROD,B1_XLIBDES,B1_MSBLQL,B1_XFMR,B1_XABC,B1_ESTSEG, "+CR
		cQuery += "(SELECT SUM(PA2_QUANT) FROM UDBP12.PA2010 PA2OP WHERE  PA2OP.PA2_CODPRO = SB1.B1_COD AND PA2OP.D_E_L_E_T_ = ' ' AND PA2_TIPO = '2' ) AS EMPOP, "+CR
		cQuery += "0 AS EMPPV, "+CR
		cQuery += "0 AS FLTPV, "+CR
		cQuery += "(SELECT SUM(PA1_QUANT) 		   FROM UDBP12.PA1010 PA1X  WHERE PA1X.D_E_L_E_T_ = ' ' AND PA1_FILIAL IN('04','05') AND PA1X.PA1_CODPRO = SB1.B1_COD AND PA1_TIPO = '2' ) AS FLTOP, "+CR
		cQuery += "(SELECT SUM(C1_QUANT-C1_QUJE) FROM UDBP12.SC1010 SC1   WHERE SC1.D_E_L_E_T_  = ' ' AND SC1.C1_FILIAL IN "+_cFilin+" AND C1_PRODUTO=SB1.B1_COD AND C1_QUANT > C1_QUJE) AS SCS, "+CR
		cQuery += "(SELECT SUM(C7_QUANT-C7_QUJE) FROM UDBP12.SC7010 SC7   WHERE SC7.D_E_L_E_T_  = ' ' AND C7_PRODUTO = SB1.B1_COD AND C7_QUANT > C7_QUJE AND C7_RESIDUO = ' ') AS PCS, "+CR
		cQuery += "(SELECT SUM(C2_QUANT-C2_QUJE) FROM UDBP12.SC2010 SC2   WHERE SC2.D_E_L_E_T_  = ' ' AND C2_PRODUTO = SB1.B1_COD AND C2_QUANT > C2_QUJE) AS OPX, "+CR
		cQuery += "(SELECT SUM(B2_QATU)          FROM UDBP12.SB2010 SB2   WHERE SB2.D_E_L_E_T_  = ' ' AND SB2.B2_FILIAL IN "+_cFilin+" AND B2_COD = SB1.B1_COD AND B2_LOCAL = '98'  ) AS L_98, "+CR
		cQuery += "(SELECT SUM(B3_MEDIA)         FROM UDBP12.SB3010 SB3   WHERE SB3.D_E_L_E_T_  = ' ' AND B3_FILIAL='04' AND B3_COD = SB1.B1_COD ) AS C_ANO, "+CR
		cQuery += "(SELECT SUM(B3_MEDIA) 		     FROM UDBP12.SB3010 SB3   WHERE SB3.D_E_L_E_T_  = ' ' AND B3_FILIAL='02' AND B3_COD = SB1.B1_COD ) AS C_ANO2, "+CR
		cQuery += "(SELECT SUM(B2_QATU)          FROM UDBP12.SB2010 SB2   WHERE SB2.D_E_L_E_T_  = ' ' AND SB2.B2_FILIAL IN "+_cFilin+" AND B2_COD = SB1.B1_COD AND  B2_LOCAL <> '98'  "+CR
		cQuery += "																															AND B2_LOCAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'  ) AS SLD_ATU, "+CR
		cQuery += "(SELECT SUM(C4_QUANT)         FROM UDBP12.SC4010 SC4   WHERE SC4.D_E_L_E_T_  = ' ' AND SC4.C4_FILIAL IN "+_cFilin+" AND C4_PRODUTO = SB1.B1_COD  "+CR
		cQuery += "																															AND C4_LOCAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND C4_DATA LIKE '"+SUBSTR(DTOS(DATE()),1,6)+"' ) AS SLD_PREV, "+CR
		cQuery += "(SELECT SUM(PA1_QUANT) 		   FROM UDBP12.PA1010 PA1Y  WHERE PA1Y.D_E_L_E_T_ = ' ' AND PA1_FILIAL = '02' AND PA1_TIPO = '1' AND PA1_CODPRO = SB1.B1_COD ) AS FALTAS "+CR
		cQuery += "FROM  UDBP12.SB1010 SB1 "+CR
		cQuery += "WHERE "+_cWhere+"  "+CR
		cQuery += "AND "+_cBlq+" "+CR
		cQuery += "AND SB1.D_E_L_E_T_ = ' ' "+CR
		cQuery += "AND SB1.B1_COD   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "+CR
		cQuery += "AND	 "+_cGrupFil+" "+CR
		cQuery += "AND SB1.B1_TIPO  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CR
		cQuery += "ORDER BY B1_TIPO,B1_GRUPO,B1_COD "+CR
	ELSE
		cQuery := "SELECT DISTINCT B1_COD,B1_DESC,B1_TIPO,B1_GRUPO, B1_UM,B1_CLAPROD,B1_XLIBDES,B1_MSBLQL,B1_XFMR,B1_XABC,B1_ESTSEG, "+CR
		cQuery += "(SELECT SUM(PA2_QUANT) FROM UDBD11.PA2110 PA2OP WHERE  PA2OP.PA2_CODPRO = SB1.B1_COD AND PA2OP.D_E_L_E_T_ = ' ' AND PA2_TIPO = '2' ) AS EMPOP, "+CR
		cQuery += "0 AS EMPPV, "+CR
		cQuery += "0 AS FLTPV, "+CR
		cQuery += "(SELECT SUM(PA1_QUANT) 		   FROM UDBD11.PA1110 PA1X  WHERE PA1X.D_E_L_E_T_ = ' ' AND PA1_FILIAL = '01' AND PA1X.PA1_CODPRO = SB1.B1_COD AND PA1_TIPO = '2' ) AS FLTOP, "+CR
		cQuery += "(SELECT SUM(C1_QUANT-C1_QUJE) FROM UDBD11.SC1110 SC1   WHERE SC1.D_E_L_E_T_  = ' ' AND SC1.C1_FILIAL = '01' AND C1_PRODUTO=SB1.B1_COD AND C1_QUANT > C1_QUJE) AS SCS, "+CR
		cQuery += "(SELECT SUM(C7_QUANT-C7_QUJE) FROM UDBD11.SC7110 SC7   WHERE SC7.D_E_L_E_T_  = ' ' AND C7_PRODUTO = SB1.B1_COD AND C7_QUANT > C7_QUJE AND C7_RESIDUO = ' ') AS PCS, "+CR
		cQuery += "(SELECT SUM(C2_QUANT-C2_QUJE) FROM UDBD11.SC2110 SC2   WHERE SC2.D_E_L_E_T_  = ' ' AND C2_PRODUTO = SB1.B1_COD AND C2_QUANT > C2_QUJE) AS OPX, "+CR
		cQuery += "(SELECT SUM(B2_QATU)          FROM UDBD11.SB2110 SB2   WHERE SB2.D_E_L_E_T_  = ' ' AND SB2.B2_FILIAL = '01' AND B2_COD = SB1.B1_COD AND B2_LOCAL = '98'  ) AS L_98, "+CR
		cQuery += "(SELECT SUM(B3_MEDIA)         FROM UDBD11.SB3110 SB3   WHERE SB3.D_E_L_E_T_  = ' ' AND B3_FILIAL='01' AND B3_COD = SB1.B1_COD ) AS C_ANO, "+CR
		cQuery += "(SELECT SUM(B3_MEDIA)				 FROM UDBD11.SB3110 SB3   WHERE SB3.D_E_L_E_T_  = ' ' AND B3_FILIAL='01' AND B3_COD = SB1.B1_COD ) AS C_ANO2, "+CR
		cQuery += "(SELECT SUM(B2_QATU)          FROM UDBD11.SB2110 SB2 "+CR
		cQuery += "												       INNER JOIN UDBD11.SB1110 B1 ON B1.B1_COD = SB2.B2_COD AND B1.B1_LOCPAD = SB2.B2_LOCAL "+CR
		cQuery += "                              WHERE SB2.D_E_L_E_T_  = ' ' AND SB2.B2_FILIAL = '01' AND B2_COD = SB1.B1_COD AND  B2_LOCAL <> '98'  "+CR
		cQuery += "															 AND B2_LOCAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'  ) AS SLD_ATU, "+CR
		cQuery += "(SELECT SUM(C4_QUANT)         FROM UDBD11.SC4110 SC4   WHERE SC4.D_E_L_E_T_  = ' ' AND SC4.C4_FILIAL = '01' AND C4_PRODUTO = SB1.B1_COD  "+CR
		cQuery += "																															AND C4_LOCAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND C4_DATA LIKE '"+SUBSTR(DTOS(DATE()),1,6)+"' ) AS SLD_PREV, "+CR
		cQuery += "(SELECT SUM(PA1_QUANT) 		   FROM UDBD11.PA1110 PA1Y  WHERE PA1Y.D_E_L_E_T_ = ' ' AND PA1_FILIAL = '01' AND PA1_TIPO = '1' AND PA1_CODPRO = SB1.B1_COD ) AS FALTAS "+CR
		cQuery += "FROM  UDBD11.SB1110 SB1 "+CR
		cQuery += "WHERE "+_cWhere+"  "+CR
		cQuery += "AND "+_cBlq+" "+CR
		cQuery += "AND SB1.D_E_L_E_T_ = ' ' "+CR
		cQuery += "AND SB1.B1_COD   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "+CR
		cQuery += "AND	 "+_cGrupFil+" "+CR
		cQuery += "AND SB1.B1_TIPO  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CR
		cQuery += "ORDER BY B1_TIPO,B1_GRUPO,B1_COD "+CR
	ENDIF

	If Select(cAliasTRB) > 0
		(cAliasTRB)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB)

	//EndSql

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

	dbSelectArea(cAliasTRB)
	DbGoTop()

	_nRec := 0
	DbEval({|| _nRec++  })

	DbGoTop()

	oSection1:Init()

	oReport:SetMeter(_nRec)

	Do While !eof()

		oReport:IncMeter()

		xSaldo1 := ( SLD_ATU - (emppv+empop+FLTpv+FLTop))
		xSaldo2 := (xSaldo1+(scs+pcs+opx) )

		if xSaldo2 <> 0 .or. mv_par08 == 2
			
			IF MV_PAR15 = 2
				_cQuery :=  "SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTD_SLD FROM UDBP12.SC6010 SC6  "+CR
				_cQuery +=  "LEFT JOIN UDBP12.SC5010 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA  "+CR
				_cQuery +=  "LEFT JOIN UDBP12.SF4010 ON F4_FILIAL = ' ' AND C6_TES = F4_CODIGO AND SF4010.D_E_L_E_T_ = ' '   "+CR
				_cQuery +=  "LEFT JOIN UDBP12.SC9010 SC9 ON SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_ITEM = SC6.C6_ITEM  "+CR
				_cQuery +=  "WHERE SC6.C6_ENTRE1 >= '20130328' AND  "+CR
				_cQuery +=  "SC6.C6_PRODUTO = '" + (cAliasTrb)->B1_COD +"' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_=' ' AND SC5.D_E_L_E_T_ = ' '  "+CR
				_cQuery +=  "AND SC6.C6_QTDVEN>SC6.C6_QTDENT AND SC6.C6_BLQ <> 'R' AND ((SC6.C6_OPER = '01' OR SC6.C6_OPER = '39') OR SC5.C5_TIPOCLI = 'X')  "+CR
				_cQuery +=  "AND SC9.C9_SEQUEN = '01' AND C6_FILIAL IN " + _cFilin+" "+CR
				_cQuery +=  "AND F4_ESTOQUE  = 'S'  "+CR
			ELSE
				_cQuery :=  "SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTD_SLD FROM UDBD11.SC6110 SC6  "+CR
				_cQuery +=  "LEFT JOIN UDBD11.SC5110 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA  "+CR
				_cQuery +=  "LEFT JOIN UDBD11.SF4110 SF4 ON F4_FILIAL = ' ' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '   "+CR
				_cQuery +=  "LEFT JOIN UDBD11.SC9110 SC9 ON SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_ITEM = SC6.C6_ITEM  "+CR
				_cQuery +=  "WHERE SC6.C6_ENTRE1 >= '20130328' AND  "+CR
				_cQuery +=  "SC6.C6_PRODUTO = '" + (cAliasTrb)->B1_COD +"' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_=' ' AND SC5.D_E_L_E_T_ = ' '  "+CR
				_cQuery +=  "AND SC6.C6_QTDVEN>SC6.C6_QTDENT AND SC6.C6_BLQ <> 'R' AND ((SC6.C6_OPER = '01' OR SC6.C6_OPER = '39') OR SC5.C5_TIPOCLI = 'X')  "+CR
				_cQuery +=  "AND SC9.C9_SEQUEN = '01' AND C6_FILIAL IN " + _cFilin+" "+CR
				_cQuery +=  "AND F4_ESTOQUE  = 'S'  "+CR
			ENDIF

			If mv_par12 = "N"
				_cQuery	+=  " AND SC9.C9_BLCRED NOT IN ('02','04','09','10')  "+CR
			EndIf


			TcQuery _cQuery New Alias "QR1"

			dbSelectArea("QR1")
			dbGotop()

			Xemppv :=  QTD_SLD

			IF MV_PAR15 = 1
				Xemppv := 0

				SB1->(DBSETORDER(1)) 
				IF SB1->(DBSEEK(XFILIAL("SB1")+(cAliasTrb)->B1_COD))
					SDC->(DbSetOrder(1))
					SDC->(DbSeek(xFilial('SDC')+SB1->B1_COD))
					While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL ==xFilial('SDC')+SB1->B1_COD+SB1->B1_LOCPAD)
						Xemppv += SDC->DC_QUANT
						SDC->(DbSkip())
					End
				ENDIF

				SB1->(DBSETORDER(1)) 
				IF SB1->(DBSEEK(XFILIAL("SB1")+(cAliasTrb)->B1_COD))
					PA2->(DbSetOrder(1))
					PA2->(DbSeek(xFilial('PA2')+SB1->B1_COD))
					While PA2->(! Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES ==xFilial('PA2')+SB1->B1_COD+cFilAnt)
						IF PA2->PA2_TIPO == '1'
							Xemppv += PA2->PA2_QUANT
						Endif
						PA2->(DbSkip())
					End
				ENDIF
			ENDIF

			DbCloseArea()
			dbSelectArea(cAliasTRB)

			xSaldo1 := ( SLD_ATU - (Xemppv+empop+FLTpv+FLTop))
			xSaldo2 := (xSaldo1+(scs+pcs+opx) )
			oSection1:Cell("SALDO"):SetValue(SLD_ATU - FALTAS )

			oSection1:Cell("Xop"):SetValue(empop+fltop )

			oSection1:Cell("Xpv"):SetValue(Xemppv+fltpv )

			oSection1:Cell("Xsaldo1"):SetValue(xSaldo1 )

			oSection1:Cell("Xsaldo2"):SetValue(xSaldo2 )



			If B1_MSBLQL = '1'
				_cBlq := 'Sim'
			Else
				_cBlq := 'Nao'
			Endif

			_xB1_COD := B1_COD
			_xDesc   := B1_DESC
			Dbselectarea("SB3")
			Dbseek("04"+ _xB1_COD  )
			if !eof()
				_cMedio  := (&cmes1+&cmes2 +&cmes3) / 3
				//_cAnual   := b3_media
			else

				_cAnual	:=	_cMedio  := ""
			Endif

			Dbselectarea("SB3")
			Dbseek("02"+ _xB1_COD  )
			if !eof()
				_cMedio2  := (&cmes1+&cmes2 +&cmes3) / 3
				//_cAnual2   := b3_media
			else

				_cAnual2	:=	_cMedio2  := ""
			Endif


			dbSelectArea(cAliasTrb)
			oSection1:PrintLine()

			if pcs > 0
				oReport:Section(1):Cell("B1_UM"):Disable()
				oReport:Section(1):Cell("B1_TIPO"):Disable()
				oReport:Section(1):Cell("B1_GRUPO"):Disable()
				oReport:Section(1):Cell("B1_CLAPROD"):Disable()
				oReport:Section(1):Cell("B1_XLIBDES"):Disable()
				oReport:Section(1):Cell("SLD_ATU"):Disable()
				oReport:Section(1):Cell("FALTAS"):Disable()
				oReport:Section(1):Cell("SALDO"):Disable()
				oReport:Section(1):Cell("xOP"):Disable()
				oReport:Section(1):Cell("xPV"):Disable()
				oReport:Section(1):Cell("xSaldo1"):Disable()
				oReport:Section(1):Cell("SCS"):Disable()
				oReport:Section(1):Cell("PCS"):Disable()
				oReport:Section(1):Cell("OPX"):Disable()
				oReport:Section(1):Cell("xSaldo2"):Disable()
				oReport:Section(1):Cell("L_98"):Disable()
				oReport:Section(1):Cell("C_MEDIO"):Disable()
				oReport:Section(1):Cell("C_ANO"):Disable()
				oReport:Section(1):Cell("C_MEDIO2"):Disable()
				oReport:Section(1):Cell("C_ANO2"):Disable()
				oReport:Section(1):Cell("C_BLOQ"):Disable()
				oReport:Section(1):Cell("B1_XFMR"):Disable()
				oReport:Section(1):Cell("B1_XABC"):Disable()
				oReport:Section(1):Cell("SLD_PREV"):Disable()


				IF MV_PAR15 = 2
					_cQuery := "SELECT SC7.C7_NUM,SC7.C7_DATPRF,SC7.C7_QUANT-SC7.C7_QUJE AS SALDO FROM UDBP12.SC7010 SC7  "+CR
					_cQuery += "WHERE SC7.C7_PRODUTO='"+_xB1_COD+"' AND SC7.D_E_L_E_T_ = ' ' AND SC7.C7_QUANT > SC7.C7_QUJE "+CR
				ELSE
					_cQuery := "SELECT SC7.C7_NUM,SC7.C7_DATPRF,SC7.C7_QUANT-SC7.C7_QUJE AS SALDO FROM UDBD11.SC7110 SC7  "+CR
					_cQuery += "WHERE SC7.C7_PRODUTO='"+_xB1_COD+"' AND SC7.D_E_L_E_T_ = ' ' AND SC7.C7_QUANT > SC7.C7_QUJE "+CR
				ENDIF
				TcQuery _cQuery New Alias "QR1"
				dbSelectArea("QR1")
				dbGotop()

				Do While !eof()

					_xB1_COD := "   "
					_xDesc   := c7_num + "  "+dtoc(stod(c7_datprf)) + "    " + transform(saldo,'@E 999,999.99')

					oSection1:PrintLine()

					DbSkip()

				Enddo
				oReport:Section(1):Cell("B1_UM"):Enable()
				oReport:Section(1):Cell("B1_TIPO"):Enable()
				oReport:Section(1):Cell("B1_GRUPO"):Enable()
				oReport:Section(1):Cell("B1_CLAPROD"):Enable()
				oReport:Section(1):Cell("B1_XLIBDES"):Enable()
				oReport:Section(1):Cell("SLD_ATU"):Enable()
				oReport:Section(1):Cell("FALTAS"):Enable()
				oReport:Section(1):Cell("SALDO"):Enable()
				oReport:Section(1):Cell("xOP"):Enable()
				oReport:Section(1):Cell("xPV"):Enable()
				oReport:Section(1):Cell("xSaldo1"):Enable()
				oReport:Section(1):Cell("SCS"):Enable()
				oReport:Section(1):Cell("PCS"):Enable()
				oReport:Section(1):Cell("OPX"):Enable()
				oReport:Section(1):Cell("xSaldo2"):Enable()
				oReport:Section(1):Cell("L_98"):Enable()
				oReport:Section(1):Cell("C_MEDIO"):Enable()
				oReport:Section(1):Cell("C_ANO"):Enable()
				oReport:Section(1):Cell("C_MEDIO2"):Enable()
				oReport:Section(1):Cell("C_ANO2"):Enable()
				oReport:Section(1):Cell("C_BLOQ"):Enable()
				oReport:Section(1):Cell("B1_XFMR"):Enable()
				oReport:Section(1):Cell("B1_XABC"):Enable()
				oReport:Section(1):Cell("SLD_PREV"):Enable()

				oReport:SkipLine()

				dbSelectArea("QR1")
				dbCloseArea()

			endif

		Endif

		If oReport:Cancel()
			Exit
		EndIf

		dbSelectArea(cAliasTrb)
		DbSkip()

	Enddo

	oSection1:Finish()

	dbSelectArea(cAliasTRB)
	dbClosearea()

Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³AjustaSX1 ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 04.11.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³Ajusta grupo de pergunta no SX1                             ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³MATR350			                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	DbSelectArea("SX1")
	DbSetOrder(1)

	If ! DbSeek(cPerg+"01",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "01"
		SX1->X1_PERGUNT := "Do Produto"
		SX1->X1_VARIAVL := "mv_ch1"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par01"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"02",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "02"
		SX1->X1_PERGUNT := "Ate Produto"
		SX1->X1_VARIAVL := "mv_ch2"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par02"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"03",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "03"
		SX1->X1_PERGUNT := "Tipo de"
		SX1->X1_VARIAVL := "mv_ch3"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par03"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"04",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "04"
		SX1->X1_PERGUNT := "Tipo ate"
		SX1->X1_VARIAVL := "mv_ch4"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par04"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"05",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "05"
		SX1->X1_PERGUNT := "Grupo de "
		SX1->X1_VARIAVL := "mv_ch5"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par05"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SBM"
		MsUnLock()
	EndIf


	If ! DbSeek(cPerg+"06",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "06"
		SX1->X1_PERGUNT := "Grupo ate "
		SX1->X1_VARIAVL := "mv_ch6"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par06"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SBM"
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"07",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "07"
		SX1->X1_PERGUNT := "Tipo Prod "
		SX1->X1_VARIAVL := "mv_ch7"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "c"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par07"
		SX1->X1_DEF01   := "Comprado"
		SX1->X1_DEF02   := "Fabricado"
		SX1->X1_DEF03   := "Importados"
		SX1->X1_DEF04   := "Todos"
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"08",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "08"
		SX1->X1_PERGUNT := "Lista Zerados "
		SX1->X1_VARIAVL := "mv_ch8"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par08"
		SX1->X1_DEF01   := "Nao"
		SX1->X1_DEF02   := "Sim"
		MsUnLock()
	EndIf
	If ! DbSeek(cPerg+"09",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "09"
		SX1->X1_PERGUNT := "Local de "
		SX1->X1_VARIAVL := "mv_ch9
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par09"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"10",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "10"
		SX1->X1_PERGUNT := "Local de "
		SX1->X1_VARIAVL := "mv_cha
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par10"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"11",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "11"
		SX1->X1_PERGUNT := "Bloqueados"
		SX1->X1_VARIAVL := "mv_cha"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par11"
		SX1->X1_DEF01   := "Sim"
		SX1->X1_DEF02   := "Nao"
		SX1->X1_DEF03   := "Ambos"
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"12",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "12"
		SX1->X1_PERGUNT := "Lista pedidos bloqueados cred "
		SX1->X1_VARIAVL := "mv_chb"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 2
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par12"
		SX1->X1_DEF01   := " "
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"13",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "13"
		SX1->X1_PERGUNT := "Filiais"
		SX1->X1_VARIAVL := "mv_chc"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 30
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par13"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf

	If ! DbSeek(cPerg+"15",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "15"
		SX1->X1_PERGUNT := "Distribuidora ou Fábrica"
		SX1->X1_VARIAVL := "mv_chb"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par15"
		SX1->X1_DEF01   := "Distribuidora"
		SX1->X1_DEF02   := "Fábrica"
		MsUnLock()
	EndIf*/
Return


