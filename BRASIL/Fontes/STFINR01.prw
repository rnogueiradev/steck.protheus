#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFINR01 º Autor ³ Vitor Merguizo     º Data ³  16/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Quantidades Vendidas conforme especificação doº±±
±±º          ³ cliente                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFINR01()

Local oReport
Private cPerg := "STFINR01"
Private cAlias1	:= GetNextAlias()
Private cAlias2	:= GetNextAlias()
Private cAlias3	:= GetNextAlias()
Private cAlias4	:= GetNextAlias()
Private cAlias5	:= GetNextAlias()
Private cAlias6	:= GetNextAlias()

Ajusta()

oReport 	:= ReportDef()
oReport		:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ ReportDef³ Autor ³ Microsiga	        ³ Data ³ 12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Definicao do layout do Relatorio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local oSection5
Local oSection6

oReport := TReport():New(cPerg,"RELATORIO DE CONTAS A RECEBER",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir os titulos a receber conforme parametros selecionados.")
oReport:SetLandscape()
oReport:nFontBody := 6

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01 | Data de Referencia                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Detalhe de títulos",{cAlias1},)
TRCell():New(oSection1,"A1_COD"		,,"Codigo"	,"@!"	,TamSX3("A1_COD")[1]		,/*lPixel*/,{||(cAlias1)->A1_COD})
TRCell():New(oSection1,"A1_LOJA"	,,"Loja"	,"@!"	,TamSX3("A1_LOJA")[1]		,/*lPixel*/,{||(cAlias1)->A1_LOJA})
TRCell():New(oSection1,"A1_NOME"	,,"Cliente"	,"@!"	,TamSX3("A1_NOME")[1]		,/*lPixel*/,{||(cAlias1)->A1_NOME})
TRCell():New(oSection1,"E1_FILIAL"	,,"Filial"	,"@!"	,TamSX3("E1_FILIAL")[1]		,/*lPixel*/,{||(cAlias1)->E1_FILIAL})
TRCell():New(oSection1,"E1_PREFIXO"	,,"Pref."	,"@!"	,TamSX3("E1_PREFIXO")[1]	,/*lPixel*/,{||(cAlias1)->E1_PREFIXO})
TRCell():New(oSection1,"E1_NUM"		,,"Numero"	,"@!"	,TamSX3("E1_NUM")[1]		,/*lPixel*/,{||(cAlias1)->E1_NUM})
TRCell():New(oSection1,"E1_PARCELA"	,,"Parc."	,"@!"	,TamSX3("E1_PARCELA")[1]	,/*lPixel*/,{||(cAlias1)->E1_PARCELA})
TRCell():New(oSection1,"E1_TIPO"	,,"Tipo"	,"@!"	,TamSX3("E1_TIPO")[1]		,/*lPixel*/,{||(cAlias1)->E1_TIPO})
TRCell():New(oSection1,"E1_NATUREZ"	,,"Natureza","@!"	,TamSX3("E1_NATUREZ")[1]	,/*lPixel*/,{||(cAlias1)->E1_NATUREZ})
TRCell():New(oSection1,"E1_EMISSAO"	,,"Emissao"	,""		,TamSX3("E1_EMISSAO")[1]	,/*lPixel*/,{||(cAlias1)->E1_EMISSAO})
TRCell():New(oSection1,"E1_VENCREA"	,,"Vencimento",""	,TamSX3("E1_VENCREA")[1]	,/*lPixel*/,{||(cAlias1)->E1_VENCREA})
TRCell():New(oSection1,"E1_PORTADO"	,,"Portador","@!"	,TamSX3("E1_PORTADO")[1]	,/*lPixel*/,{||(cAlias1)->E1_PORTADO})
TRCell():New(oSection1,"E1_VALOR"	,,"$ Orig."	,"@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias1)->E1_VALOR},"RIGHT")
TRCell():New(oSection1,"E1_VLRVENC"	,,"$ Vencido","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias1)->E1_VLRVENC},"RIGHT")
TRCell():New(oSection1,"E1_VLRAVEN"	,,"$ A Venc.","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias1)->E1_VLRAVEN},"RIGHT")
TRCell():New(oSection1,"E1_ACRESC"	,,"Acresc."	,"@E 999,999,999,999.99",TamSX3("E1_ACRESC")[1]		,/*lPixel*/,{||(cAlias1)->E1_ACRESC},"RIGHT")
TRCell():New(oSection1,"E1_DECRESC"	,,"Decresc.","@E 999,999,999,999.99",TamSX3("E1_DECRESC")[1]	,/*lPixel*/,{||(cAlias1)->E1_DECRESC},"RIGHT")
TRCell():New(oSection1,"E1_JUROS"	,,"Juros"	,"@E 999,999,999,999.99",TamSX3("E1_JUROS")[1]		,/*lPixel*/,{||(cAlias1)->E1_JUROS},"RIGHT")
TRCell():New(oSection1,"E1_MULTA"	,,"Multa"	,"@E 999,999,999,999.99",TamSX3("E1_MULTA")[1]		,/*lPixel*/,{||(cAlias1)->E1_MULTA},"RIGHT")
TRCell():New(oSection1,"E1_DESCONT"	,,"Desconto","@E 999,999,999,999.99",TamSX3("E1_DESCONT")[1]	,/*lPixel*/,{||(cAlias1)->E1_DESCONT},"RIGHT")
TRCell():New(oSection1,"E1_SALDO"	,,"Saldo"	,"@E 999,999,999,999.99",TamSX3("E1_SALDO")[1]		,/*lPixel*/,{||(cAlias1)->E1_SALDO},"RIGHT")
TRCell():New(oSection1,"E1_HIST"	,,"Historico","@!"	,TamSX3("E1_HIST")[1]		,/*lPixel*/,{||(cAlias1)->E1_HIST})
TRCell():New(oSection1,"E1_VEND1"	,,"Vendedor","@!"	,TamSX3("E1_VEND1")[1]		,/*lPixel*/,{||(cAlias1)->E1_VEND1})
TRCell():New(oSection1,"A1_TIPO"	,,"Tp."		,"@!"	,TamSX3("A1_TIPO")[1]		,/*lPixel*/,{||(cAlias1)->A1_TIPO})
TRCell():New(oSection1,"A1_EST"		,,"Est."	,"@!"	,TamSX3("A1_EST")[1]		,/*lPixel*/,{||(cAlias1)->A1_EST})
TRCell():New(oSection1,"A1_GRPVEN"	,,"Grupo V.","@!"	,TamSX3("A1_GRPVEN")[1]		,/*lPixel*/,{||(cAlias1)->A1_GRPVEN})
TRCell():New(oSection1,"ACY_DESCRI"	,,"Descr."	,"@!"	,TamSX3("ACY_DESCRI")[1]	,/*lPixel*/,{||(cAlias1)->ACY_DESCRI})
TRCell():New(oSection1,"A1_PRICOM"	,,"Prim.C."	,""		,TamSX3("A1_PRICOM")[1]		,/*lPixel*/,{||(cAlias1)->A1_PRICOM})
TRCell():New(oSection1,"E1_CLIENTE"	,,"Cliente"	,"@!"	,TamSX3("A1_COD")[1]+TamSX3("A1_NOME")[1],/*lPixel*/,{||(cAlias1)->E1_CLIENTE})
TRCell():New(oSection1,"E1_ATRAS"	,,"Atraso"	,"@!"	,6	,/*lPixel*/,{||(cAlias1)->E1_ATRAS})
oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter(cAlias1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total de Títulos")

oBreak1 := TRBreak():New(oSection1,".T.","Total de Títulos",.F.)
TRFunction():New(oSection1:Cell("E1_VALOR")		,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_VLRVENC")	,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_VLRAVEN")	,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_ACRESC")	,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_DECRESC")	,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_JUROS")		,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_MULTA")		,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_DESCONT")	,"","SUM",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("E1_SALDO")		,"","SUM",oBreak1,,,,.F.,.F.)

oSection2 := TRSection():New(oReport,"Resumo de Agrupamento",{cAlias2},)
TRCell():New(oSection2,"ACY_DESCRI"	,,"Grupo"	,"@!"	,TamSX3("ACY_DESCRI")[1]	,/*lPixel*/,{||(cAlias2)->ACY_DESCRI})
TRCell():New(oSection2,"E1_VLRVENC"	,,"$ Vencido","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias2)->E1_VLRVENC},"RIGHT")
TRCell():New(oSection2,"E1_VLRAVEN"	,,"$ A Venc.","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias2)->E1_VLRAVEN},"RIGHT")
oSection2:SetHeaderSection(.T.)
oSection2:Setnofilter(cAlias2)

oBreak2 := TRBreak():New(oSection2,".T.","Total Agrupamento",.F.)
TRFunction():New(oSection2:Cell("E1_VLRVENC")	,"","SUM",oBreak2,,,,.F.,.F.)
TRFunction():New(oSection2:Cell("E1_VLRAVEN")	,"","SUM",oBreak2,,,,.F.,.F.)

oSection3 := TRSection():New(oReport,"Resumo de Vendedores",{cAlias3},)
TRCell():New(oSection3,"A1_VEND"	,,"Cod."		,"@!"	,TamSX3("A1_VEND")[1]		,/*lPixel*/,{||(cAlias3)->A1_VEND})
TRCell():New(oSection3,"A3_NOME"	,,"Vendedor"	,"@!"	,TamSX3("A3_NOME")[1]		,/*lPixel*/,{||(cAlias3)->A3_NOME})
TRCell():New(oSection3,"E1_VLRVENC"	,,"$ Vencido","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias3)->E1_VLRVENC},"RIGHT")
TRCell():New(oSection3,"E1_VLRAVEN"	,,"$ A Venc.","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias3)->E1_VLRAVEN},"RIGHT")
oSection3:SetHeaderSection(.T.)
oSection3:Setnofilter(cAlias3)

oBreak3 := TRBreak():New(oSection3,".T.","Total Vendedores",.F.)
TRFunction():New(oSection3:Cell("E1_VLRVENC")	,"","SUM",oBreak3,,,,.F.,.F.)
TRFunction():New(oSection3:Cell("E1_VLRAVEN")	,"","SUM",oBreak3,,,,.F.,.F.)

oSection4 := TRSection():New(oReport,"Resumo Vencidos",{cAlias4},)
TRCell():New(oSection4,"A1_EST"		,,"Estado"	,"@!"	,TamSX3("A1_EST")[1]	,/*lPixel*/,{||(cAlias4)->A1_EST})
TRCell():New(oSection4,"E1_VLR0030"	,,"$ 01 a 30","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias4)->E1_VLR0030},"RIGHT")
TRCell():New(oSection4,"E1_VLR3160"	,,"$ 31 a 60","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias4)->E1_VLR3160},"RIGHT")
TRCell():New(oSection4,"E1_VLR6190"	,,"$ 61 a 90","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias4)->E1_VLR6190},"RIGHT")
TRCell():New(oSection4,"E1_VLR91120",,"$ 91 a 120","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias4)->E1_VLR91120},"RIGHT")
TRCell():New(oSection4,"E1_VLR120"	,,"$ Mais de 121","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias4)->E1_VLR120},"RIGHT")
oSection4:SetHeaderSection(.T.)
oSection4:Setnofilter(cAlias4)

oBreak4 := TRBreak():New(oSection4,".T.","Total Vencidos",.F.)
TRFunction():New(oSection4:Cell("E1_VLR0030")	,"","SUM",oBreak4,,,,.F.,.F.)
TRFunction():New(oSection4:Cell("E1_VLR3160")	,"","SUM",oBreak4,,,,.F.,.F.)
TRFunction():New(oSection4:Cell("E1_VLR6190")	,"","SUM",oBreak4,,,,.F.,.F.)
TRFunction():New(oSection4:Cell("E1_VLR91120")	,"","SUM",oBreak4,,,,.F.,.F.)
TRFunction():New(oSection4:Cell("E1_VLR120")	,"","SUM",oBreak4,,,,.F.,.F.)

oSection5 := TRSection():New(oReport,"Resumo de Clientes",{cAlias5},)
TRCell():New(oSection5,"E1_CLIENTE"	,,"Cod."		,"@!"	,TamSX3("E1_CLIENTE")[1]	,/*lPixel*/,{||(cAlias5)->E1_CLIENTE})
TRCell():New(oSection5,"A1_NOME"	,,"Cliente"		,"@!"	,TamSX3("A1_NOME")[1]		,/*lPixel*/,{||(cAlias5)->A1_NOME})
TRCell():New(oSection5,"E1_VLRVENC"	,,"$ Vencido"	,"@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias5)->E1_VLRVENC},"RIGHT")
TRCell():New(oSection5,"E1_VLRAVEN"	,,"$ A Venc."	,"@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias5)->E1_VLRAVEN},"RIGHT")
TRCell():New(oSection5,"A1_LC"		,,"$ Credito"	,"@E 999,999,999,999.99",TamSX3("A1_LC")[1]			,/*lPixel*/,{||(cAlias5)->A1_LC},"RIGHT")
TRCell():New(oSection5,"A1_XSEGVAL"	,,"$ Seguro"	,"@E 999,999,999,999.99",TamSX3("A1_XSEGVAL")[1]	,/*lPixel*/,{||(cAlias5)->A1_XSEGVAL},"RIGHT")
oSection5:SetHeaderSection(.T.)
oSection5:Setnofilter(cAlias5)

oBreak5 := TRBreak():New(oSection5,".T.","Total Clientes",.F.)
TRFunction():New(oSection5:Cell("E1_VLRVENC")	,"","SUM",oBreak5,,,,.F.,.F.)
TRFunction():New(oSection5:Cell("E1_VLRAVEN")	,"","SUM",oBreak5,,,,.F.,.F.)
TRFunction():New(oSection5:Cell("A1_LC")   		,"","SUM",oBreak5,,,,.F.,.F.)
TRFunction():New(oSection5:Cell("A1_XSEGVAL")	,"","SUM",oBreak5,,,,.F.,.F.)

oSection6 := TRSection():New(oReport,"Resumo Bancos",{cAlias6},)
TRCell():New(oSection6,"E1_PORTADO"	,,"Cod."		,"@!"	,TamSX3("E1_PORTADO")[1]		,/*lPixel*/,{||(cAlias6)->E1_PORTADO})
TRCell():New(oSection6,"A6_NOME"	,,"Vendedor"	,"@!"	,TamSX3("A6_NOME")[1]		,/*lPixel*/,{||(cAlias6)->A6_NOME})
TRCell():New(oSection6,"E1_VLRVENC"	,,"$ Vencido","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias6)->E1_VLRVENC},"RIGHT")
TRCell():New(oSection6,"E1_VLRAVEN"	,,"$ A Venc.","@E 999,999,999,999.99",TamSX3("E1_VALOR")[1]		,/*lPixel*/,{||(cAlias6)->E1_VLRAVEN},"RIGHT")
oSection6:SetHeaderSection(.T.)
oSection6:Setnofilter(cAlias6)

oBreak6 := TRBreak():New(oSection6,".T.","Total Bancos",.F.)
TRFunction():New(oSection6:Cell("E1_VLRVENC")	,"","SUM",oBreak6,,,,.F.,.F.)
TRFunction():New(oSection6:Cell("E1_VLRAVEN")	,"","SUM",oBreak6,,,,.F.,.F.)

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³16.11.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport)

Local cTitulo	:= OemToAnsi("Valores a Receber: "+DTOC(mv_par01))
Local cQuery1	:= ""
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cQuery4	:= ""
Local cQuery5	:= ""
Local cQuery6	:= ""
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local oSection3	:= oReport:Section(3)
Local oSection4	:= oReport:Section(4)
Local oSection5	:= oReport:Section(5)
Local oSection6	:= oReport:Section(6)

oReport:SetMeter(0)
oReport:SetTitle(cTitulo)
If mv_par02=1
cQuery1 := "SELECT A1_COD, A1_LOJA, A1_NOME, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_EMISSAO, E1_VENCREA, E1_PORTADO, E1_VALOR, "
cQuery1 += "CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END AS E1_VLRVENC, "
cQuery1 += "CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END AS E1_VLRAVEN, "
cQuery1 += "E1_ACRESC, E1_DECRESC, E1_JUROS, E1_MULTA, E1_DESCONT, E1_SALDO, E1_HIST,E1_VEND1, "
cQuery1 += "A1_TIPO, A1_EST, A1_GRPVEN, ACY_DESCRI, A1_PRICOM, A1_COD||' '||A1_NOME E1_CLIENTE, "
cQuery1 += "CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN '00' WHEN E1_VENCREA >= '"+DTOS(mv_par01-30)+"' THEN '01-30' WHEN E1_VENCREA >= '"+DTOS(mv_par01-60)+"' THEN '31-60' "
cQuery1 += "WHEN E1_VENCREA >= '"+DTOS(mv_par01-90)+"' THEN '61-90' WHEN E1_VENCREA >= '"+DTOS(mv_par01-120)+"' THEN '91-120' ELSE '>120' END E1_ATRAS "
cQuery1 += "FROM ( "
cQuery1 += "SELECT A1_COD, A1_LOJA, A1_NOME, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_EMISSAO, E1_VENCREA, E1_PORTADO, E1_VALOR, "
cQuery1 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery1 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END "
cQuery1 += "E1_SLDNEW, E1_ACRESC, E1_DECRESC, E1_JUROS, E1_MULTA, E1_DESCONT, E1_SALDO, E1_HIST, CASE WHEN A3_TIPO = 'I' THEN 'V.INT.' ELSE E1_VEND1 END E1_VEND1, "
cQuery1 += "CASE WHEN A1_TIPO = 'F' THEN 'Cons.Final' WHEN A1_TIPO = 'L' THEN 'Produtor Rural' WHEN A1_TIPO = 'R' THEN 'Revendedor' "
cQuery1 += "WHEN A1_TIPO = 'S' THEN 'Solidario' WHEN A1_TIPO = 'X' THEN 'Exportacao' ELSE ' ' END A1_TIPO, "
cQuery1 += "A1_EST, A1_GRPVEN, ACY_DESCRI, A1_PRICOM "
cQuery1 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery1 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery1 += "LEFT JOIN "+RetSqlName("ACY")+" ACY ON ACY_FILIAL = '  ' AND ACY_GRPVEN = A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' "
cQuery1 += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '  ' AND A3_COD = E1_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery1 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery1 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery1 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery1 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery1 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery1 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery1 += "WHERE "
cQuery1 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery1 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery1 += "E1_TIPO = 'NF' AND "
cQuery1 += "E1_NATUREZ = '10101' AND "
cQuery1 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery1 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery1 += "SE1.D_E_L_E_T_ = ' ' "
cQuery1 += ")XXX "
cQuery1 += "ORDER BY 1,2,4,5,6,7 "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)

If !Empty(Select(cAlias1))
	
	TCSetField(cAlias1,"E1_VALOR","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias1,"E1_VLRVENC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias1,"E1_VLRAVEN","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias1,"E1_ACRESC","N",TamSX3("E1_ACRESC")[1],2)
	TCSetField(cAlias1,"E1_DECRESC","N",TamSX3("E1_DECRESC")[1],2)
	TCSetField(cAlias1,"E1_JUROS","N",TamSX3("E1_JUROS")[1],2)
	TCSetField(cAlias1,"E1_MULTA","N",TamSX3("E1_MULTA")[1],2)
	TCSetField(cAlias1,"E1_DESCONT","N",TamSX3("E1_DESCONT")[1],2)
	TCSetField(cAlias1,"E1_SALDO","N",TamSX3("E1_SALDO")[1],2)
	
	oSection1:Init()
	
	DbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	While (cAlias1)->(!Eof())
	
		oSection1:PrintLine()
	
		(cAlias1)->(dbSkip())
	EndDo
	oSection1:PrintTotal()
	oSection1:Finish()

	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())

EndIf
EndIf	
cQuery2 := "SELECT ACY_DESCRI, "
cQuery2 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRVENC, "
cQuery2 += "SUM(CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRAVEN "
cQuery2 += "FROM ( SELECT CASE "
cQuery2 += "WHEN A1_GRPVEN = 'ST' THEN 'Intragrupo' "
cQuery2 += "WHEN A1_GRPVEN = 'EX' THEN 'Exportação' "
cQuery2 += "WHEN A1_GRPVEN IN ('C1','C2','C3','C7','C8') THEN 'Usuario Final' "
cQuery2 += "WHEN A1_GRPVEN IN ('D1','D2','D3') THEN 'Distribuidor' "
cQuery2 += "WHEN A1_GRPVEN IN ('R1','R2','R3','R4','R5') THEN 'Revenda' "
cQuery2 += "WHEN A1_GRPVEN IN ('E1','E2','E3','E4','E5','E6','EI') THEN 'Construtor' "
cQuery2 += "WHEN A1_GRPVEN IN ('I1','I2','I3','I4','I5') THEN 'Industrialização' "
cQuery2 += "ELSE 'Others' END AS ACY_DESCRI, E1_VENCREA, "
cQuery2 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery2 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END "
cQuery2 += "E1_SLDNEW "
cQuery2 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery2 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery2 += "LEFT JOIN "+RetSqlName("ACY")+" ACY ON ACY_FILIAL = '  ' AND ACY_GRPVEN = A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' "
cQuery2 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery2 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery2 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery2 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery2 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery2 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery2 += "WHERE "
cQuery2 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery2 += "E1_TIPO = 'NF' AND "
cQuery2 += "E1_NATUREZ = '10101' AND "
cQuery2 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery2 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery2 += "SE1.D_E_L_E_T_ = ' ' "
cQuery2 += ")XXX "
cQuery2 += "GROUP BY ACY_DESCRI ORDER BY 1 "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery2),cAlias2,.T.,.T.)

If !Empty(Select(cAlias2))

	TCSetField(cAlias2,"E1_VLRVENC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias2,"E1_VLRAVEN","N",TamSX3("E1_VALOR")[1],2)
	
	oSection2:Init()
	
	DbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())
	While (cAlias2)->(!Eof())
	
		oSection2:PrintLine()
	
		(cAlias2)->(dbSkip())
	EndDo
	
	oSection2:PrintTotal()
	oSection2:Finish()

	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())

EndIf

cQuery3 := "SELECT A1_VEND,A3_NOME, "
cQuery3 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRVENC, "
cQuery3 += "SUM(CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRAVEN "
cQuery3 += "FROM ( "
cQuery3 += "SELECT CASE WHEN A3_TIPO = 'I' OR A1_VEND = ' ' THEN 'I00000' ELSE A1_VEND END A1_VEND, "
cQuery3 += "CASE WHEN A3_TIPO = 'I' OR A1_VEND = ' ' THEN 'V. INTERNO' WHEN SUBSTR(A3_NOME,1,12) = 'ENCERRADO - ' THEN SUBSTR(A3_NOME,13,40) ELSE A3_NOME END A3_NOME, E1_VENCREA, "
cQuery3 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery3 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END "
cQuery3 += "E1_SLDNEW "
cQuery3 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery3 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery3 += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '  ' AND A3_COD = A1_VEND AND SA3.D_E_L_E_T_ = ' ' "
cQuery3 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery3 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery3 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery3 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery3 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery3 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery3 += "WHERE "
cQuery3 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery3 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery3 += "E1_TIPO = 'NF' AND "
cQuery3 += "E1_NATUREZ = '10101' AND "
cQuery3 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery3 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery3 += "SE1.D_E_L_E_T_ = ' ' "
cQuery3 += ")XXX "
cQuery3 += "GROUP BY A1_VEND, A3_NOME "
cQuery3 += "ORDER BY 1 "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias3))
	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery3),cAlias3,.T.,.T.)

If !Empty(Select(cAlias3))

	TCSetField(cAlias3,"E1_VLRVENC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias3,"E1_VLRAVEN","N",TamSX3("E1_VALOR")[1],2)
	
	oSection3:Init()
	
	DbSelectArea(cAlias3)
	(cAlias3)->(dbGoTop())
	While (cAlias3)->(!Eof())
	
		oSection3:PrintLine()
	
		(cAlias3)->(dbSkip())
	EndDo
	
	oSection3:PrintTotal()
	oSection3:Finish()

	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())

EndIf

cQuery4 := "SELECT A1_EST , "
cQuery4 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' AND E1_VENCREA >= '"+DTOS(mv_par01-30)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLR0030, "
cQuery4 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01-30)+"' AND E1_VENCREA >= '"+DTOS(mv_par01-60)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLR3160, "
cQuery4 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01-60)+"' AND E1_VENCREA >= '"+DTOS(mv_par01-90)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLR6190, "
cQuery4 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01-90)+"' AND E1_VENCREA >= '"+DTOS(mv_par01-120)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLR91120, "
cQuery4 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01-120)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLR120 "
cQuery4 += "FROM ( "
cQuery4 += "SELECT A1_EST , E1_VENCREA, "
cQuery4 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery4 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END "
cQuery4 += "E1_SLDNEW "
cQuery4 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery4 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery4 += "LEFT JOIN "+RetSqlName("ACY")+" ACY ON ACY_FILIAL = '  ' AND ACY_GRPVEN = A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' "
cQuery4 += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '  ' AND A3_COD = E1_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery4 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery4 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery4 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery4 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery4 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery4 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery4 += "WHERE "
cQuery4 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery4 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery4 += "E1_TIPO = 'NF' AND "
cQuery4 += "E1_NATUREZ = '10101' AND "
cQuery4 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery4 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery4 += "SE1.D_E_L_E_T_ = ' ' "
cQuery4 += ")XXX "
cQuery4 += "GROUP BY A1_EST "
cQuery4 += "ORDER BY A1_EST "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias4))
	DbSelectArea(cAlias4)
	(cAlias4)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery4),cAlias4,.T.,.T.)

If !Empty(Select(cAlias4))

	TCSetField(cAlias4,"E1_VLR0030","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias4,"E1_VLR3160","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias4,"E1_VLR6190","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias4,"E1_VLR91120","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias4,"E1_VLR120","N",TamSX3("E1_VALOR")[1],2)
	
	oSection4:Init()
	
	DbSelectArea(cAlias4)
	(cAlias4)->(dbGoTop())
	While (cAlias4)->(!Eof())
	
		oSection4:PrintLine()
	
		(cAlias4)->(dbSkip())
	EndDo
	
	oSection4:PrintTotal()
	oSection4:Finish()

	DbSelectArea(cAlias4)
	(cAlias4)->(dbCloseArea())

EndIf

cQuery5 := "SELECT E1_CLIENTE,
cQuery5 += "(SELECT MAX(A1_NOME) FROM "+RetSqlName("SA1")+" SA1 WHERE A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ = ' ') AS A1_NOME, "
cQuery5 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRVENC, "
cQuery5 += "SUM(CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRAVEN, "
cQuery5 += "(SELECT SUM(A1_LC)A1_LC FROM "+RetSqlName("SA1")+" SA1 WHERE A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ = ' ') AS A1_LC, "
cQuery5 += "(SELECT SUM(A1_XSEGVAL)A1_XSEGVAL FROM "+RetSqlName("SA1")+" SA1 WHERE A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ = ' ') AS A1_XSEGVAL "
cQuery5 += "FROM ( "
cQuery5 += "SELECT E1_CLIENTE, E1_VENCREA, "
cQuery5 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery5 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END E1_SLDNEW "
cQuery5 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery5 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery5 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery5 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery5 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery5 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery5 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery5 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery5 += "WHERE "
cQuery5 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery5 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery5 += "E1_TIPO = 'NF' AND "
cQuery5 += "E1_NATUREZ = '10101' AND "
cQuery5 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery5 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery5 += "SE1.D_E_L_E_T_ = ' ' "
cQuery5 += ")XXX "
cQuery5 += "GROUP BY E1_CLIENTE "
cQuery5 += "ORDER BY 1 "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias5))
	DbSelectArea(cAlias5)
	(cAlias5)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery5),cAlias5,.T.,.T.)

If !Empty(Select(cAlias5))

	TCSetField(cAlias5,"E1_VLRVENC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias5,"E1_VLRAVEN","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias5,"A1_LC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias5,"A1_XSEGVAL","N",TamSX3("E1_VALOR")[1],2)
	
	oSection5:Init()
	
	DbSelectArea(cAlias5)
	(cAlias5)->(dbGoTop())
	While (cAlias5)->(!Eof())
	
		oSection5:PrintLine()
	
		(cAlias5)->(dbSkip())
	EndDo
	
	oSection5:PrintTotal()
	oSection5:Finish()

	DbSelectArea(cAlias5)
	(cAlias5)->(dbCloseArea())

EndIf

cQuery6 := "SELECT E1_PORTADO, "
cQuery6 += "NVL((SELECT MAX(A6_NOME)A6_NOME FROM "+RetSqlName("SA6")+" SA6 WHERE A6_FILIAL = '  ' AND A6_COD = E1_PORTADO AND SA6.D_E_L_E_T_ = ' '),'CARTEIRA') AS A6_NOME, "
cQuery6 += "SUM(CASE WHEN E1_VENCREA < '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRVENC, "
cQuery6 += "SUM(CASE WHEN E1_VENCREA >= '"+DTOS(mv_par01)+"' THEN E1_SLDNEW ELSE 0 END) AS E1_VLRAVEN "
cQuery6 += "FROM ( "
cQuery6 += "SELECT E1_PORTADO, E1_VENCREA, "
cQuery6 += "CASE WHEN NVL(E5_PRIM,' ')=' ' THEN E1_VALOR WHEN E5_PRIM > '"+DTOS(mv_par01)+"' THEN E1_VALOR WHEN NVL(E5_VALOR,0) = 0 THEN E1_SALDO WHEN E1_SALDO = 0 THEN "
cQuery6 += "CASE WHEN NVL(E5_VALOR,0)>E1_VALOR THEN E1_VALOR ELSE NVL(E5_VALOR,0) END ELSE CASE WHEN E1_SALDO+NVL(E5_VALOR,0)> E1_VALOR THEN E1_VALOR ELSE E1_SALDO+NVL(E5_VALOR,0) END END E1_SLDNEW "
cQuery6 += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery6 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '  ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery6 += "LEFT JOIN (SELECT E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA,MIN(E5_DATA)E5_PRIM,MAX(E5_DATA)E5_DATA, "
cQuery6 += "SUM(CASE WHEN E5_DATA > '"+DTOS(mv_par01)+"' THEN CASE WHEN E5_RECPAG = 'R' THEN (E5_VALOR-E5_VLMULTA) ELSE (E5_VALOR-E5_VLMULTA)*-1 END ELSE 0 END)E5_VALOR "
cQuery6 += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery6 += "WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_SITUACA <> 'C' AND E5_TIPODOC IN('VL','BA','CP','ES') AND SE5.D_E_L_E_T_ = ' ' "
cQuery6 += "GROUP BY E5_FILORIG,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIENTE,E5_LOJA)SE5 "
cQuery6 += "ON E5_FILORIG = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA "
cQuery6 += "WHERE "
cQuery6 += "E1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery6 += "E1_EMISSAO <= '"+DTOS(mv_par01)+"' AND "
cQuery6 += "E1_TIPO = 'NF' AND "
cQuery6 += "E1_NATUREZ = '10101' AND "
cQuery6 += "(E1_SALDO > 0 OR E5_DATA > '"+DTOS(mv_par01)+"') AND "
cQuery6 += "A1_GRPVEN NOT IN ('ST','SC') AND "
cQuery6 += "SE1.D_E_L_E_T_ = ' ' "
cQuery6 += ")XXX "
cQuery6 += "GROUP BY E1_PORTADO "
cQuery6 += "ORDER BY 1 "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias6))
	DbSelectArea(cAlias6)
	(cAlias6)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery6),cAlias6,.T.,.T.)

If !Empty(Select(cAlias6))

	TCSetField(cAlias6,"E1_VLRVENC","N",TamSX3("E1_VALOR")[1],2)
	TCSetField(cAlias6,"E1_VLRAVEN","N",TamSX3("E1_VALOR")[1],2)
	
	oSection6:Init()
	
	DbSelectArea(cAlias6)
	(cAlias6)->(dbGoTop())
	While (cAlias6)->(!Eof())
	
		oSection6:PrintLine()
	
		(cAlias6)->(dbSkip())
	EndDo
	
	oSection6:PrintTotal()
	oSection6:Finish()

	DbSelectArea(cAlias6)
	(cAlias6)->(dbCloseArea())

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ Vitor Merguizo 		  ³ Data ³ 16/08/2012		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	³±±
±±³          ³ no SX3                                                           	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Data Base ?                  ","Data Base ?                  ","Data Base ?                  ","mv_ch1","D",8,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Imprime Analitico ?          ","Imprime Analitico ?          ","Imprime Analitico ?          ","mv_ch2","N",1,0,1,"C",""                    ,"mv_par02","Sim           ","Sim           ","Sim           ","","","Não           ","Não           ","Não           ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1(cPerg,aPergs)

Return