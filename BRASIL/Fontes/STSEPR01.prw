#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STSEPR01   บ Autor ณ Vitor Merguizo	 บ Data ณ  10/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Separa็ใo Diaria                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STSEPR01()

Local oReport
Local aArea	:= GetArea()

Ajusta()

If Pergunte("STSEPR01",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
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
Local oSection1,oSection2,oSection3

oReport := TReport():New("STSEPR01","Relatorio de Separacao Diaria ","STSEPR01",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o Resumo de Separa็ใo Diaria conforme parametros.")

pergunte("STSEPR01",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros						  ณ
//ณ mv_par01			// Mes							 		  ณ
//ณ mv_par02			// Ano									  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oSection1 := TRSection():New(oReport,"Separacao",{"CB9"},)
TRCell():New(oSection1,"DATA"		,,"Data"		,				 ,024,.F.,)
TRCell():New(oSection1,"PEDIDO"		,,"Tot. Ped."	,"@E 999,999,999",024,.F.,)
TRCell():New(oSection1,"ITEM"		,,"Tot. Itens"	,"@E 999,999,999",024,.F.,)
TRCell():New(oSection1,"VOLUME"		,,"Tot. Vol."	,"@E 999,999,999",024,.F.,)
TRCell():New(oSection1,"QUANT"		,,"Qtd. Total."	,"@E 999,999,999",024,.F.,)
TRCell():New(oSection1,"PESO"		,,"Peso Total"	,"@E 999,999,999",024,.F.,)
oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("CB9")

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

Local cTitulo	:= OemToAnsi("Relatorio de Separa็ใo Diaria")
Local cAlias1	:= "QRY1CB9"
Local cQuery1	:= ""
Local nCont		:= 0
Local nValor	:= 0
Local nPed		:= 0
Local nItem		:= 0
Local nVol		:= 0
Local nQtd		:= 0
Local nPes		:= 0
Local aDados1[6]
Local oSection1	:= oReport:Section(1)

oSection1:Cell("DATA"	)		:SetBlock( { || aDados1[1] })
oSection1:Cell("PEDIDO"	)		:SetBlock( { || aDados1[2] })
oSection1:Cell("ITEM"	)		:SetBlock( { || aDados1[3] })
oSection1:Cell("VOLUME"	)		:SetBlock( { || aDados1[4] })
oSection1:Cell("QUANT"	)		:SetBlock( { || aDados1[5] })
oSection1:Cell("PESO"	)		:SetBlock( { || aDados1[6] })

//Monta Query para Extrair dados de Separa็ใo
cQuery1 := " SELECT CB7_DTFIMS,SUM(TOT_PED)TOT_PED, SUM(TOT_ITEM)TOT_ITEM, SUM(TOT_VOL)TOT_VOL, SUM(TOT_QTD)TOT_QTD, SUM(TOT_PES)TOT_PES FROM ("
cQuery1 += " SELECT CB7_DTFIMS,SUM(QTD_PEDIDO)TOT_PED, 0 TOT_ITEM, 0 TOT_VOL, 0 TOT_QTD, 0 TOT_PES FROM ( "
cQuery1 += " SELECT CB7_FILIAL,CB7_DTFIMS,CB7_PEDIDO,1 QTD_PEDIDO "
cQuery1 += " FROM "+RetSqlName("CB7")+" CB7  "
cQuery1 += " WHERE  "
cQuery1 += " CB7_FILIAL = '"+xFilial("CB7")+"' AND " //BETWEEN '  ' AND 'ZZ' AND Chamado 008741 - Everson Santana - 04.01.2019 
cQuery1 += " SUBSTRING(CB7_DTFIMS,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
cQuery1 += " CB7.D_E_L_E_T_ = ' ' "
cQuery1 += " GROUP BY CB7_FILIAL,CB7_DTFIMS,CB7_PEDIDO)XPED "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " UNION ALL "
cQuery1 += " SELECT CB7_DTFIMS,0 TOT_PED, SUM(QTD_ITEM) TOT_ITEM, 0 TOT_VOL, 0 TOT_QTD, 0 TOT_PES FROM ( "
cQuery1 += " SELECT CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_ITESEP,CB9_PROD,1 QTD_ITEM "
cQuery1 += " FROM "+RetSqlName("CB9")+" CB9  "
cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7 ON CB9_FILIAL = CB7_FILIAL AND CB9_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = ' ' "
cQuery1 += " WHERE  "
cQuery1 += " CB7_FILIAL = '"+xFilial("CB7")+"' AND " //BETWEEN '  ' AND 'ZZ' AND " Chamado 008741
cQuery1 += " SUBSTRING(CB7_DTFIMS,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
cQuery1 += " CB9.D_E_L_E_T_ = ' ' "
cQuery1 += " GROUP BY CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_ITESEP,CB9_PROD)XITEM "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " UNION ALL "
cQuery1 += " SELECT CB7_DTFIMS,0 TOT_PED, 0 TOT_ITEM, SUM(QTD_VOL) TOT_VOL, 0 TOT_QTD, 0 TOT_PES FROM ( "
cQuery1 += " SELECT CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_VOLUME,1 QTD_VOL "
cQuery1 += " FROM "+RetSqlName("CB9")+" CB9  "
cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7 ON CB9_FILIAL = CB7_FILIAL AND CB9_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = ' ' "
cQuery1 += " WHERE  "
cQuery1 += " CB7_FILIAL = '"+xFilial("CB7")+"' AND " //BETWEEN '  ' AND 'ZZ' AND " Chamado 008741
cQuery1 += " SUBSTRING(CB7_DTFIMS,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
cQuery1 += " CB9.D_E_L_E_T_ = ' ' "
cQuery1 += " GROUP BY CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_VOLUME)XVOL "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " UNION ALL "
cQuery1 += " SELECT CB7_DTFIMS,0 TOT_PED, 0 TOT_ITEM, 0 TOT_VOL, SUM(CB9_QTESEP) TOT_QTD, 0 TOT_PES FROM ( "
cQuery1 += " SELECT CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_PROD,CB9_QTESEP "
cQuery1 += " FROM "+RetSqlName("CB9")+" CB9  "
cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7 ON CB9_FILIAL = CB7_FILIAL AND CB9_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = ' ' "
cQuery1 += " WHERE  "
cQuery1 += " CB7_FILIAL = '"+xFilial("CB7")+"' AND " //BETWEEN '  ' AND 'ZZ' AND " Chamado 008741
cQuery1 += " SUBSTRING(CB7_DTFIMS,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
cQuery1 += " CB9.D_E_L_E_T_ = ' ' "
cQuery1 += " GROUP BY  CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB9_PROD,CB9_QTESEP)XQTD "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " UNION ALL "
cQuery1 += " SELECT CB7_DTFIMS,0 TOT_PED,0 TOT_ITEM,0 TOT_VOL,0 TOT_QTD, SUM(CB6_XPESO) TOT_PES FROM ( "
cQuery1 += " SELECT CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP, CB6_XPESO "
cQuery1 += " FROM "+RetSqlName("CB6")+" CB6  "
cQuery1 += " LEFT JOIN (SELECT CB7_FILIAL, MAX(CB7_DTFIMS)CB7_DTFIMS, CB7_ORDSEP FROM "+RetSqlName("CB7")+" CB7 WHERE  CB7.D_E_L_E_T_ = ' ' GROUP BY CB7_FILIAL,CB7_ORDSEP)CB7 ON CB6_FILIAL = CB7_FILIAL AND CB6_XORDSE = CB7_ORDSEP "
cQuery1 += " WHERE  "
cQuery1 += " CB7_FILIAL = '"+xFilial("CB7")+"' AND " //BETWEEN '  ' AND 'ZZ' AND  " Chamado 008741
cQuery1 += " SUBSTR(CB7_DTFIMS,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND  "
cQuery1 += " CB6.D_E_L_E_T_ = ' '  "
cQuery1 += " GROUP BY CB7_FILIAL,CB7_DTFIMS,CB7_ORDSEP,CB6_XPESO) XQTD  "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " )XXX "
cQuery1 += " GROUP BY CB7_DTFIMS "
cQuery1 += " ORDER BY 1 "

cQuery1 := ChangeQuery(cQuery1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Area de Trabalho executando a Query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)

TCSetField(cAlias1,"CB7_DTFIMS"	,"D",8,0)
TCSetField(cAlias1,"TOT_PED"	,"N",16,0)
TCSetField(cAlias1,"TOT_ITEM"	,"N",16,0)
TCSetField(cAlias1,"TOT_VOL"	,"N",16,0)
TCSetField(cAlias1,"TOT_QTD"	,"N",16,0)
TCSetField(cAlias1,"TOT_PES"	,"N",16,0)

oReport:SetTitle(cTitulo)

dbeval({||nCont++})

oReport:SetMeter(nCont)

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())

//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()

//Atualiza Array com dados de Capta็ใo
While (cAlias1)->(!Eof())
	oReport:IncMeter()
	aDados1[1] := (cAlias1)->CB7_DTFIMS
	aDados1[2] := (cAlias1)->TOT_PED
	aDados1[3] := (cAlias1)->TOT_ITEM
	aDados1[4] := (cAlias1)->TOT_VOL
	aDados1[5] := (cAlias1)->TOT_QTD
	aDados1[6] := (cAlias1)->TOT_PES

	nPed	+= (cAlias1)->TOT_PED
	nItem	+= (cAlias1)->TOT_ITEM
	nVol	+= (cAlias1)->TOT_VOL
	nQtd	+= (cAlias1)->TOT_QTD
	nPes	+= (cAlias1)->TOT_PES

	oSection1:PrintLine()
	aFill(aDados1,nil)

	(cAlias1)->(dbSkip())
EndDo

aDados1[1] := "TOTAL"
aDados1[2] := nPed
aDados1[3] := nItem
aDados1[4] := nVol
aDados1[5] := nQtd
aDados1[6] := nPes

oReport:SkipLine()
oSection1:PrintLine()
aFill(aDados1,nil)
oSection1:Finish()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
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

Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STSEPR01",aPergs)

Return