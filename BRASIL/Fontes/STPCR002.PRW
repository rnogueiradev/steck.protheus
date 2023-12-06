#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STPCR002 ³ Autor ³ RVG                   ³ Data ³ 23/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lista de Faltas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR350                                                    ³±±
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
User Function STPCR002()

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

Private cPerg   := "STPCR00204"
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

oReport:= TReport():New("MATR350","Lista de Faltas-Steck",cPerg, {|oReport| ReportPrint(oReport, ,cAliasTRB)},;
"O relatorio fara' a alocacao do material em estoque  "+;
" em ordem sequencial  ")

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
 
cMes	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2)+;
	    	"+B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2)+;
   	 	    "+B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)
       

oSection1 := TRSection():New(oReport,"Faltas ",{},aOrdem) //"Lista de Faltas"##"Produtos"
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,'B2_COD'    	,cAliasTRB,/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,cAliasTRB,/*Titulo*/,/*Picture*/,35,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'   	,cAliasTRB,/*Titulo*/,/*Picture*/,4,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,4,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SALDO'  	,cAliasTRB,"Em Estoque"     ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMPOP'		,cAliasTRB,"Neces. OP"     ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMPPV'		,cAliasTRB,"Neces. PV"     ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'xSaldo1'  	, 		  ,"Sld Liquido"    ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SCS'		,cAliasTRB,"Solic.Compra"   ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PCS'		,cAliasTRB,"Pedido Compra"  ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'OPS'		,cAliasTRB,"Ord.Producao"   ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'xSaldo2'  	, 		  ,"Liq.Reabastec." ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C_MEDIO'  	,cAliasTRB,"Consumo"        ,"@E 999999,999.9",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LIBDES'  	,cAliasTRB,"Lib. Des."        ,"@!",10,/*lPixel*/,/*{|| code-block de impressao }*/)

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
Local nOrdem       := oSection1:GetOrder()

IF nOrdem == 2
	_cExpress := "PA1.PA1_FILIAL,PA1.PA1_DOC"
ELSE
	_cExpress := "PA1.PA1_FILIAL,PA1_CODPRO,PA1.PA1_DOC"
ENDIF

lQuery 		:= .T.

oReport:Section(1):BeginQuery()

BeginSql Alias cAliasTRB
	
	SELECT DISTINCT B2_COD,B1_DESC,B1_TIPO,B1_GRUPO,SUM(B2_QATU) AS SALDO,B1_UM,
	(SELECT SUM(D4_QUANT) FROM %table:SD4% SD4 WHERE  D4_COD = B2_COD AND SD4.%NotDel%) AS EMPOP,
	(SELECT SUM(C6_QTDVEN-C6_QTDENT) FROM %table:SC6% SC6 WHERE  C6_PRODUTO = B2_COD AND SC6.%NotDel% AND C6_QTDVEN>C6_QTDENT AND C6_BLQ <> 'R') AS EMPPV,
	(SELECT SUM(C1_QUANT-C1_QUJE) FROM %table:SC1% SC1 WHERE  C1_PRODUTO=B2_COD AND SC1.%NotDel%  AND C1_QUANT > C1_QUJE) AS SCS,
	(SELECT SUM(C7_QUANT-C7_QUJE) FROM %table:SC7% SC7 WHERE  C7_PRODUTO=B2_COD AND SC7.%NotDel% AND C7_QUANT > C7_QUJE) AS PCS,
	(SELECT SUM(C2_QUANT-C2_QUJE) FROM %table:SC2% SC2 WHERE  C2_PRODUTO=B2_COD AND SC2.%NotDel% AND C2_QUANT > C2_QUJE) AS OPS,
	(SELECT B1_XLIBDES LIBDES FROM %table:SB1% B1 WHERE B1.D_E_L_E_T_=' ' AND B1_XLIBDES<>' ' AND B1_COD=B2_COD) LIBDES
	FROM  %table:SB2% SB2, %table:SB1% SB1 	

	WHERE	

	SB2.%NotDel%    
	AND SB1.%NotDel%
	AND SB2.B2_LOCAL <> '98'
	AND SB2.B2_COD   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
	AND SB1.B1_COD = SB2.B2_COD
	AND	SB1.B1_GRUPO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%  
	AND SB1.B1_TIPO  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%  

	GROUP BY B1_TIPO,B1_GRUPO,B2_COD,B1_DESC,B1_UM

	HAVING (SELECT SUM(D4_QUANT) FROM %table:SD4% SD4 WHERE  D4_COD = B2_COD AND SD4.%NotDel% ) > 0
	OR (SELECT SUM(C6_QTDVEN-C6_QTDENT) FROM %table:SC6% SC6 WHERE C6_PRODUTO = B2_COD AND SC6.%NotDel% AND C6_QTDVEN>C6_QTDENT AND C6_BLQ <> 'R')>0 

	ORDER BY B1_TIPO,B1_GRUPO,B2_COD 
	
EndSql

oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

dbSelectArea(cAliasTRB)

oSection1:Init()

oReport:SetMeter(RecCount())

Do While !eof()
	
	xSaldo1 := (saldo-(emppv+empop)) 	
  	oSection1:Cell("Xsaldo1"):SetValue(xSaldo1 )
	xSaldo2 := (saldo-(emppv+empop)+(scs+pcs+ops) ) 	
  	oSection1:Cell("Xsaldo2"):SetValue(xSaldo2 )

	oSection1:PrintLine()
	oReport:IncMeter()
	DbSkip()          
	
Enddo

oSection1:Finish()


//oSection1:Print()

dbSelectArea(cAliasTRB)
dbClosearea(cAliasTRB)

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

Local aArea	:= GetArea()
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
EndIf*/


Return
