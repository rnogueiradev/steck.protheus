#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STFATR04   บ Autor ณ Vitor Merguizo     บ Data ณ  30/03/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Listagem Comparativa de Quantidades por Item               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STFATR04()

Local oReport
Local aArea	:= GetArea()
Private aSuper := {}

Ajusta()

If cEmpAnt = "01"
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
Else
	MsgAlert("Relat๓rio valido apenas para empresa Steck Matriz.")
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definicao do layout do Relatorio                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("STFATR04","Listagem Comparativa de Quantidades por Item","STFATR04",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir uma listagem comparativa de quantidades por item conforme parametros.")

pergunte("STFATR04",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros						  ณ
//ณ mv_par01			// Mes							 		  ณ
//ณ mv_par02			// Ano									  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oReport:SetTitle("Litagem Comparativa de Quantidades por Item")
oSection1:= TRSection():New(oReport,"Itens",{"QR1"},)
oSection1:SetTotalInLine(.t.)
oSection1:SetHeaderPage()
oSection1:Setnofilter("QR1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณMicrosiga		          ณ Data ณ12.05.12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

Local cQuery	:= ""
Local cAlias	:= "QR1"
Local nTotNF	:= 0
Local nTotLib	:= 0
Local nTotSep	:= 0
Local nTotEmb	:= 0
Local oSection1	:= oReport:Section(1)
Local aDados1[10]

TRCell():New(oSection1,"FILIAL",,"Filial","@!",10,				/*lPixel*/,{||aDados1[1]})
TRCell():New(oSection1,"NOTA",,"Nota Fiscal","@!",10,				/*lPixel*/,{||aDados1[2]})
TRCell():New(oSection1,"PEDIDO",,"Pedido","@!",10,				/*lPixel*/,{||aDados1[3]})
TRCell():New(oSection1,"ITEM",,"Item","@!",5,				   		/*lPixel*/,{||aDados1[4]})
TRCell():New(oSection1,"COD",,"Produto","@!",15,					/*lPixel*/,{||aDados1[5]})
TRCell():New(oSection1,"DESC",,"Descricao","@!",30,				/*lPixel*/,{||aDados1[6]})
TRCell():New(oSection1,"QTD_D2",,"Qtd. Nota","@E 9,999,999",16,	/*lPixel*/,{||aDados1[7]})
TRCell():New(oSection1,"QTD_C9",,"Qtd. Lib.","@E 9,999,999",16,	/*lPixel*/,{||aDados1[8]})
TRCell():New(oSection1,"QTD_SEP",,"Qtd. Sep.","@E 9,999,999",16,	/*lPixel*/,{||aDados1[9]})
TRCell():New(oSection1,"QTD_EMB",,"Qtd. Emb.","@E 9,999,999",16,	/*lPixel*/,{||aDados1[10]})

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

cQuery	:= " SELECT FILIAL, PEDIDO, ITEM, DOC, COD, B1_DESC, SUM(QTD_D2) QTD_D2, SUM(QTD_C9) QTD_C9, SUM(QTD_SEP) QTD_SEP, SUM(QTD_EMB) QTD_EMB FROM ( "
cQuery	+= " SELECT D2_FILIAL FILIAL, D2_DOC DOC, D2_PEDIDO PEDIDO, D2_ITEMPV ITEM, D2_COD COD, SUM(D2_QUANT) QTD_D2, 0 QTD_C9, 0 QTD_SEP, 0 QTD_EMB "
cQuery	+= " FROM "+RetSqlName("SD2")+" SD2 "
cQuery	+= " WHERE "
cQuery	+= " D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+= " D2_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery	+= " D2_SERIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery	+= " D2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' AND "
cQuery	+= " SD2.D_E_L_E_T_= ' ' "
cQuery	+= " GROUP BY D2_FILIAL, D2_DOC, D2_PEDIDO, D2_ITEMPV, D2_COD "
cQuery	+= " UNION ALL "
cQuery	+= " SELECT C9_FILIAL FILIAL, C9_NFISCAL, C9_PEDIDO, C9_ITEM, C9_PRODUTO, 0 QTD_D2, SUM(C9_QTDLIB)QTD_C9, 0 QTD_SEP, 0 QTD_EMB "
cQuery	+= " FROM "+RetSqlName("SC9")+" SC9 "
cQuery	+= " INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = C9_FILIAL AND F2_DOC = C9_NFISCAL AND F2_SERIE = C9_SERIENF AND SF2.D_E_L_E_T_= ' ' "
cQuery	+= " WHERE "
cQuery	+= " C9_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+= " C9_NFISCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery	+= " C9_SERIENF BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery	+= " F2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' AND "
cQuery	+= " SC9.D_E_L_E_T_= ' ' "
cQuery	+= " GROUP BY C9_FILIAL, C9_NFISCAL, C9_PEDIDO, C9_ITEM, C9_PRODUTO "
cQuery	+= " UNION ALL "
cQuery	+= " SELECT CB9_FILIAL FILIAL, C9_NFISCAL, CB9_PEDIDO, CB9_ITESEP, CB9_PROD, 0 QTD_D2, 0 QTD_C9, SUM(CB9_QTESEP)QTD_SEP, SUM(CB9_QTEEMB)QTD_EMB "
cQuery	+= " FROM "+RetSqlName("CB9")+" CB9 "
cQuery	+= " INNER JOIN ( "
cQuery	+= " SELECT C9_FILIAL,C9_ORDSEP,C9_NFISCAL "
cQuery	+= " FROM "+RetSqlName("SC9")+" SC9 "
cQuery	+= " INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = C9_FILIAL AND F2_DOC = C9_NFISCAL AND F2_SERIE = C9_SERIENF AND SF2.D_E_L_E_T_= ' ' "
cQuery	+= " WHERE "
cQuery	+= " C9_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+= " C9_NFISCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery	+= " C9_SERIENF BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery	+= " F2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' AND "
cQuery	+= " C9_ORDSEP <> ' ' AND "
cQuery	+= " SC9.D_E_L_E_T_= ' ' "
cQuery	+= " GROUP BY C9_FILIAL, C9_ORDSEP, C9_NFISCAL) C9 ON CB9_FILIAL = C9_FILIAL AND C9_ORDSEP = CB9_ORDSEP "
cQuery	+= " WHERE "
cQuery	+= " CB9_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+= " CB9.D_E_L_E_T_= ' ' "
cQuery	+= " GROUP BY CB9_FILIAL, C9_NFISCAL, CB9_PEDIDO, CB9_ITESEP, CB9_PROD "
cQuery	+= " )XXX "
cQuery	+= " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON COD = B1_COD AND SB1.D_E_L_E_T_= ' ' "
cQuery	+= " GROUP BY FILIAL, DOC, PEDIDO, ITEM, COD, B1_DESC "
cQuery	+= " ORDER BY FILIAL, DOC, PEDIDO, ITEM "

cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TcSetField(cAlias,"QTD_D2"	, "N",TamSx3("D2_QUANT")[1]	, TamSx3("D2_QUANT")[2])
TcSetField(cAlias,"QTD_C9"	, "N",TamSx3("C9_QTDLIB")[1]	, TamSx3("C9_QTDLIB")[2])
TcSetField(cAlias,"QTD_SEP"	, "N",TamSx3("CB9_QTESEP")[1]	, TamSx3("CB9_QTESEP")[2])
TcSetField(cAlias,"QTD_EMB"	, "N",TamSx3("CB9_QTEEMB")[1]	, TamSx3("CB9_QTEEMB")[2])

DbSelectArea (cAlias)
(cAlias)->(DbGoTop())
nCount:=0
dbeval({||nCount++})

oReport:SetMeter(nCount)

aFill(aDados1,nil)
oSection1:Init()

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	aDados1[01] := (cAlias)->FILIAL
	aDados1[02] := (cAlias)->DOC
	aDados1[03] := (cAlias)->PEDIDO
	aDados1[04] := (cAlias)->ITEM
	aDados1[05] := (cAlias)->COD
	aDados1[06] := (cAlias)->B1_DESC
	aDados1[07] := (cAlias)->QTD_D2
	aDados1[08] := (cAlias)->QTD_C9
	aDados1[09] := (cAlias)->QTD_SEP
	aDados1[10] := (cAlias)->QTD_EMB

	nTotNF	+= (cAlias)->QTD_D2
	nTotLib	+= (cAlias)->QTD_C9
	nTotSep	+= (cAlias)->QTD_SEP
	nTotEmb	+= (cAlias)->QTD_EMB

	oReport:IncMeter()
	oSection1:PrintLine()
	aFill(aDados1,nil)

	(cAlias)->(dbSkip())
EndDo

aDados1[06] := "Total"
aDados1[07] := nTotNF
aDados1[08] := nTotLib
aDados1[09] := nTotSep
aDados1[10] := nTotEmb

oReport:SkipLine()
oSection1:PrintLine()
aFill(aDados1,nil)
oSection1:Finish()
	
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Filial de ?                  ","Filial de ?                  ","Filial de ?                  ","mv_ch1","C",2,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Filial ate ?                 ","Filial ate ?                 ","Filial ate ?                 ","mv_ch2","C",2,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Documento de ?               ","Documento de ?               ","Documento de ?               ","mv_ch3","C",9,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Documento ate ?              ","Documento ate ?              ","Documento ate ?              ","mv_ch4","C",9,0,0,"G",""                   ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Serie de ?                   ","Serie de ?                   ","Serie de ?                   ","mv_ch5","C",3,0,0,"G",""                   ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Serie ate ?                  ","Serie ate ?                  ","Serie ate ?                  ","mv_ch6","C",3,0,0,"G",""                   ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Emissao de ?                 ","Emissao de ?                 ","Emissao de ?                 ","mv_ch7","D",8,0,0,"G",""                   ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Emissao ate ?                ","Emissao ate ?                ","Emissao ate ?                ","mv_ch8","D",8,0,0,"G",""                   ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Somente Divergente ?         ","Somente Divergente ?         ","Somente Divergente ?         ","mv_ch9","N",1,0,1,"C",""                   ,"mv_par09","Sim           ","Sim           ","Sim           ","","","Nao           ","Nao           ","Nao           ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STFATR04",aPergs)

Return