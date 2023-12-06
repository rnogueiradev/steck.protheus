#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFAT75  บAutor  ณJoใo Victor         บ Data ณ  08/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio contendo dados referente a Pedidos de Compras   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT75()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFAT75A"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private lXlsHeader   := .f.
	Private lXmlEndRow   := .f.
	Private cPergTit 		:= cAliasLif

	Private cAlias1	:= GetNextAlias()
	Private cAlias2	:= GetNextAlias()
	Private cAlias3	:= GetNextAlias()
	Private cAlias4	:= GetNextAlias()
	Private cAlias5	:= GetNextAlias()
	Private cAlias6	:= GetNextAlias()
	Private cAlias7	:= GetNextAlias()


//-------cGrupo    ,cOrdem,cPergunt                 ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
//PutSx1(cPerg     ,"01"  ,"Filial ?"               ,"Filial ?"                 ,"Filial ?"                   ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"   ,"Filial De :?"           ,"Filial De: ?"             ,"Filial De: ?"               ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,"  "                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"   ,"Filial At้ :?"          ,"Filial At้: ?"            ,"Filial At้: ?"              ,"mv_ch2"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,"ZZ"                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"03"   ,"Emissใo De: ?"          ,"Emissใo De: ?"            ,"Emissใo De: ?"              ,"mv_ch3"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par03"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"04"   ,"Emissใo At้: ?"         ,"Emissใo At้: ?"           ,"Emissใo At้: ?"             ,"mv_ch4"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par04"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"05"   ,"Usuแrio De: ?"          ,"Usuแrio De: ?"            ,"Usuแrio De: ?"              ,"mv_ch5"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"USR" ,""     ,""   ,"mv_par05"    ,""                ,""      ,""      ,"      "             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"06"   ,"Usuแrio At้: ?"         ,"Usuแrio At้: ?"           ,"Usuแrio At้: ?"             ,"mv_ch6"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"USR" ,""     ,""   ,"mv_par06"    ,""                ,""      ,""      ,"ZZZZZZ"             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"07"   ,"Fornecedor De: ?"       ,"Fornecedor De: ?"         ,"Fornecedor De: ?"           ,"mv_ch7"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"SA2" ,""     ,""   ,"mv_par07"    ,""                ,""      ,""      ,"      "             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"08"   ,"Loja Fornec De: ?"      ,"Loja Fornec De: ?"        ,"Loja Fornec De: ?"          ,"mv_ch8"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par08"    ,""                ,""      ,""      ,"  "                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"09"   ,"Fornecedor At้: ?"      ,"Fornecedor At้: ?"        ,"Fornecedor At้: ?"          ,"mv_ch9"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"SA2" ,""     ,""   ,"mv_par09"    ,""                ,""      ,""      ,"ZZZZZZ"             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"10"   ,"Loja Fornec At้: ?"     ,"Loja Fornec At้: ?"       ,"Loja Fornec At้: ?"         ,"mv_chA"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par10"    ,""                ,""      ,""      ,"ZZ"                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"11"   ,"Considera Comprador :?" ,"Considera Comprador :?"   ,"Considera Comprador :?"     ,"mv_chB"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par11"    ,"1-Sim"           ,""      ,""      ,""                   ,"2-Nใo"            ,""        ,""      ,"3-Todos"      ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cabe็alho do Relat๓rio  		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3
	Local oSection4
	Local oSection5
	Local oSection6

	oReport := TReport():New(cPergTit,"Painel de Compras",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir as informa็๕es relacionadas a Pedidos de Compras conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 6

	Pergunte(cPerg,.F.)


//Primeira Se็ใo
	oSection1 := TRSection():New(oReport,"Pedidos",{cAlias1})
	TRCell():New(oSection1,"A1" ,,"Filial"         ,PesqPict("SC7","C7_FILIAL")      ,TamSX3("C7_FILIAL")    [1]+2)
	TRCell():New(oSection1,"A2" ,,"Pedido"         ,PesqPict("SC7","C7_NUM")         ,TamSX3("C7_NUM")       [1]+2)
	TRCell():New(oSection1,"A3" ,,"C๓digo"         ,PesqPict("SC7","C7_FORNECE")     ,TamSX3("C7_FORNECE")   [1]+2)
	TRCell():New(oSection1,"A4" ,,"Lj"             ,PesqPict("SC7","C7_LOJA")        ,TamSX3("C7_LOJA")      [1]+2)
	TRCell():New(oSection1,"A5" ,,"Razใo Social"   ,PesqPict("SA2","A2_NOME")        ,TamSX3("A2_NOME")      [1]+2)
	TRCell():New(oSection1,"A6" ,,"Dt. Emissใo"    ,PesqPict("SC7","C7_EMISSAO")     ,TamSX3("C7_EMISSAO")   [1]+2)
	TRCell():New(oSection1,"A7" ,,"Dt. Liber. "    ,PesqPict("SCR","CR_DATALIB")     ,TamSX3("CR_DATALIB")   [1]+2)
	TRCell():New(oSection1,"A8" ,,"Linhas PC"      ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection1,"A9" ,,"Linhas PC SC"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection1,"A10",,"Valor Total"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection1,"A11",,"Valor Desconto" ,PesqPict("SC7","C7_VLDESC")      ,TamSX3("C7_VLDESC")    [1]+2)
	TRCell():New(oSection1,"A15",,"Qtde Cota็๕es"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection1,"A12",,"Emitente"       ,PesqPict("SC7","C7_PRODUTO")     ,TamSX3("C7_PRODUTO")   [1]+2)
	TRCell():New(oSection1,"A13",,"Comprador?"     ,PesqPict("SC7","C7_USER")        ,TamSX3("C7_USER")      [1]+2)
	TRCell():New(oSection1,"A14",,"Liberado por"   ,PesqPict("SC7","C7_PRODUTO")     ,TamSX3("C7_PRODUTO")   [1]+2)
	TRCell():New(oSection1,"A16",,"Qtd Linhas Cot.",PesqPict("SC7","C7_PRODUTO")     ,TamSX3("C7_PRODUTO")   [1]+2) //chamado 002916 - Robson Mazzarotto


	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

	oBreak1 := TRBreak():New(oSection1,{|| (cAlias1)->(A13_EMITENTE) },{|| "Total por Comprador: " },.F.)
	TRFunction():New(oSection1:Cell("A8")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A9")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A10")    ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A11")    ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A15")    ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A12")    ,"","COUNT",oBreak1,,,,.F.,.F.)


//Segunda Se็ใo
	oSection2 := TRSection():New(oReport,"Compradores",{cAlias2})
	TRCell():New(oSection2,"B1" ,,"Emitente"          ,PesqPict("SC7","C7_PRODUTO")     ,TamSX3("C7_PRODUTO")   [1]+2)
	TRCell():New(oSection2,"B2" ,,"Linhas Pedido 01"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B3" ,,"Qtde Pedidos 01"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B4" ,,"Valor Total 01"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection2,"B5" ,,"Linhas Pedido 02"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B6" ,,"Qtde Pedidos 02"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B7" ,,"Valor Total 02"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection2,"B8" ,,"Linhas Pedido 04"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B9" ,,"Qtde Pedidos 04"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B10",,"Valor Total 04"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection2,"B11",,"Linhas Pedido MAO" ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B12",,"Qtde Pedidos MAO"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B13",,"Valor Total MAO"   ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection2,"B14" ,,"Linhas Pedido 03"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B15" ,,"Qtde Pedidos 03"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection2,"B16" ,,"Valor Total 03"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)

	oSection2:SetHeaderSection(.T.)
	oSection2:Setnofilter(cAlias2)
	oSection2:SetTotalInLine(.F.)

	oBreak2 := TRBreak():New(oSection2,".T.","Total Compradores 1: ",.F.)
	TRFunction():New(oSection2:Cell("B2")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B3")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B4")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B5")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B6")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B7")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B8")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B9")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B10")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B11")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B12")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B13")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B14")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B15")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B16")   ,"","SUM"  ,oBreak2,,,,.F.,.F.)



//Terceira Se็ใo
	//oSection3 := TRSection():New(oReport,"Total Compradores",{cAlias3})
	oSection3 := TRSection():New(oReport,"Total Compradores",{cAlias2})
	TRCell():New(oSection3,"C1" ,,"Emitente"             ,PesqPict("SC7","C7_PRODUTO")     ,TamSX3("C7_PRODUTO")   [1]+2)
	TRCell():New(oSection3,"C2" ,,"Total Linhas Pedido"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection3,"C3" ,,"Total Qtde Pedidos"   ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection3,"C4" ,,"Total Valor Total"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)

	oSection3:SetHeaderSection(.T.)
	oSection3:Setnofilter(cAlias2)
	oSection3:SetTotalInLine(.F.)

	oBreak3 := TRBreak():New(oSection3,".T.","Total Compradores 2: ",.F.)
	TRFunction():New(oSection3:Cell("C2")    ,"","SUM"  ,oBreak3,,,,.F.,.F.)
	TRFunction():New(oSection3:Cell("C3")    ,"","SUM"  ,oBreak3,,,,.F.,.F.)
	TRFunction():New(oSection3:Cell("C4")    ,"","SUM"  ,oBreak3,,,,.F.,.F.)



//Quarta Se็ใo
	oSection4 := TRSection():New(oReport,"Motivos",{cAlias4})
	TRCell():New(oSection4,"D1" ,,"Filial"         ,PesqPict("SC7","C7_FILIAL")      ,TamSX3("C7_FILIAL")    [1]+2)
	TRCell():New(oSection4,"D2" ,,"Motivo"         ,PesqPict("SC7","C7_MOTIVO")      ,TamSX3("C7_MOTIVO")    [1]+2)
	TRCell():New(oSection4,"D3" ,,"Descri็ใo Mot"  ,PesqPict("SZ1","Z1_DESCRI")      ,TamSX3("Z1_DESCRI")    [1]+2)
	TRCell():New(oSection4,"D4" ,,"Centro de Custo",PesqPict("SC7","C7_CC")          ,TamSX3("C7_CC")        [1]+2)
	TRCell():New(oSection4,"D5" ,,"Descri็ใo CC"   ,PesqPict("CTT","CTT_DESC01")     ,TamSX3("CTT_DESC01")   [1]+2)
	TRCell():New(oSection4,"D6" ,,"Linhas Pedido"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection4,"D7" ,,"Valor Total"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection4,"D8" ,,"Valor Desconto" ,PesqPict("SC7","C7_VLDESC")      ,TamSX3("C7_VLDESC")    [1]+2)

	oSection4:SetHeaderSection(.T.)
	oSection4:Setnofilter(cAlias4)
	oSection4:SetTotalInLine(.F.)

	oBreak4 := TRBreak():New(oSection4,{|| (cAlias4)->(MOTIVO) },{|| "Total Motivo de Compra: " },.F.)
	TRFunction():New(oSection4:Cell("D6")    ,"","SUM"  ,oBreak4,,,,.F.,.F.)
	TRFunction():New(oSection4:Cell("D7")    ,"","SUM"  ,oBreak4,,,,.F.,.F.)
	TRFunction():New(oSection4:Cell("D8")    ,"","SUM"  ,oBreak4,,,,.F.,.F.)


//Quinta Se็ใo
	oSection5 := TRSection():New(oReport,"Fornecedor",{cAlias5})
	TRCell():New(oSection5,"E1" ,,"C๓digo"         ,PesqPict("SC7","C7_FORNECE")     ,TamSX3("C7_FORNECE")   [1]+2)
	TRCell():New(oSection5,"E2" ,,"Lj"             ,PesqPict("SC7","C7_LOJA")        ,TamSX3("C7_LOJA")      [1]+2)
	TRCell():New(oSection5,"E3" ,,"Descri็ใo"      ,PesqPict("SA2","A2_NOME")        ,TamSX3("A2_NOME")      [1]+2)
	TRCell():New(oSection5,"E4" ,,"Linhas Pedido"  ,PesqPict("SC7","C7_CONTA20")     ,TamSX3("C7_CONTA20")   [1]+2)
	TRCell():New(oSection5,"E5" ,,"Valor Total"    ,PesqPict("SC7","C7_TOTAL")       ,TamSX3("C7_TOTAL")     [1]+2)
	TRCell():New(oSection5,"E6" ,,"Valor Desconto" ,PesqPict("SC7","C7_VLDESC")      ,TamSX3("C7_VLDESC")    [1]+2)
	TRCell():New(oSection5,"E7" ,,"Nบ Compras"     ,PesqPict("SA2","A2_NROCOM")      ,TamSX3("A2_NROCOM")    [1]+2)
	TRCell():New(oSection5,"E8" ,,"Primeira Compra",PesqPict("SA2","A2_PRICOM")      ,TamSX3("A2_PRICOM")    [1]+2)
	TRCell():New(oSection5,"E9",,"ฺltima Compra"   ,PesqPict("SA2","A2_ULTCOM")      ,TamSX3("A2_ULTCOM")    [1]+2)

	oSection5:SetHeaderSection(.T.)
	oSection5:Setnofilter(cAlias5)
	oSection5:SetTotalInLine(.F.)

	oBreak5 := TRBreak():New(oSection5,".T.","Total por Fornecedor: ",.F.)
	TRFunction():New(oSection5:Cell("E1")    ,"","COUNT",oBreak5,,,,.F.,.F.)
	TRFunction():New(oSection5:Cell("E4")    ,"","SUM"  ,oBreak5,,,,.F.,.F.)
	TRFunction():New(oSection5:Cell("E5")    ,"","SUM"  ,oBreak5,,,,.F.,.F.)
	TRFunction():New(oSection5:Cell("E6")    ,"","SUM"  ,oBreak5,,,,.F.,.F.)
	TRFunction():New(oSection5:Cell("E7")    ,"","SUM"  ,oBreak5,,,,.F.,.F.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Itens do Relat๓rio                                         บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local oSection3	:= oReport:Section(3)
	Local oSection4	:= oReport:Section(4)
	Local oSection5	:= oReport:Section(5)
	Local oSection6	:= oReport:Section(6)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("A1") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("A2") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("A3") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("A4") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("A5") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("A6") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("A7") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("A8") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("A9") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("A10"):SetBlock( { || aDados1[10] } )
	oSection1:Cell("A11"):SetBlock( { || aDados1[11] } )
	oSection1:Cell("A12"):SetBlock( { || aDados1[12] } )
	oSection1:Cell("A13"):SetBlock( { || aDados1[13] } )
	oSection1:Cell("A14"):SetBlock( { || aDados1[14] } )
	oSection1:Cell("A15"):SetBlock( { || aDados1[15] } )
	oSection1:Cell("A16"):SetBlock( { || aDados1[50] } )

	oSection2:Cell("B1") :SetBlock( { || aDados1[16] } )
	oSection2:Cell("B2") :SetBlock( { || aDados1[17] } )
	oSection2:Cell("B3") :SetBlock( { || aDados1[18] } )
	oSection2:Cell("B4") :SetBlock( { || aDados1[19] } )
	oSection2:Cell("B5") :SetBlock( { || aDados1[20] } )
	oSection2:Cell("B6") :SetBlock( { || aDados1[21] } )
	oSection2:Cell("B7") :SetBlock( { || aDados1[22] } )
	oSection2:Cell("B8") :SetBlock( { || aDados1[23] } )
	oSection2:Cell("B9") :SetBlock( { || aDados1[24] } )
	oSection2:Cell("B10"):SetBlock( { || aDados1[25] } )
	oSection2:Cell("B11"):SetBlock( { || aDados1[26] } )
	oSection2:Cell("B12"):SetBlock( { || aDados1[27] } )
	oSection2:Cell("B13"):SetBlock( { || aDados1[28] } )
	oSection2:Cell("B14"):SetBlock( { || aDados1[50] } )
	oSection2:Cell("B15"):SetBlock( { || aDados1[51] } )
	oSection2:Cell("B16"):SetBlock( { || aDados1[52] } )


	oSection3:Cell("C1") :SetBlock( { || aDados1[29] } )
	oSection3:Cell("C2") :SetBlock( { || aDados1[30] } )
	oSection3:Cell("C3") :SetBlock( { || aDados1[31] } )
	oSection3:Cell("C4") :SetBlock( { || aDados1[32] } )

	oSection4:Cell("D1") :SetBlock( { || aDados1[33] } )
	oSection4:Cell("D2") :SetBlock( { || aDados1[34] } )
	oSection4:Cell("D3") :SetBlock( { || aDados1[35] } )
	oSection4:Cell("D4") :SetBlock( { || aDados1[36] } )
	oSection4:Cell("D5") :SetBlock( { || aDados1[37] } )
	oSection4:Cell("D6") :SetBlock( { || aDados1[38] } )
	oSection4:Cell("D7") :SetBlock( { || aDados1[39] } )
	oSection4:Cell("D8") :SetBlock( { || aDados1[40] } )

	oSection5:Cell("E1") :SetBlock( { || aDados1[41] } )
	oSection5:Cell("E2") :SetBlock( { || aDados1[42] } )
	oSection5:Cell("E3") :SetBlock( { || aDados1[43] } )
	oSection5:Cell("E4") :SetBlock( { || aDados1[44] } )
	oSection5:Cell("E5") :SetBlock( { || aDados1[45] } )
	oSection5:Cell("E6") :SetBlock( { || aDados1[46] } )
	oSection5:Cell("E7") :SetBlock( { || aDados1[47] } )
	oSection5:Cell("E8") :SetBlock( { || aDados1[48] } )
	oSection5:Cell("E9") :SetBlock( { || aDados1[49] } )


	oReport:SetTitle("Painel de Compras")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection1:Init()


	Processa({|| StQuery(  ) },"Compondo Relat๓rio")


	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0

		While 	(cAlias1)->(!Eof())

			aDados1[01]	:= (cAlias1)->A1_FILIAL
			aDados1[02]	:= (cAlias1)->A2_PEDIDO
			aDados1[03]	:= (cAlias1)->A3_FORNECEDOR
			aDados1[04]	:= (cAlias1)->A4_LOJA_FORNECE
			aDados1[05]	:= (cAlias1)->A5_RAZAO_SOCIAL
			aDados1[06]	:= DTOC(STOD((cAlias1)->A6_DT_EMISSAO))
			//aDados1[07]	:= DTOC(STOD((cAlias1)->A7_DT_LIBER))
			aDados1[08]	:= (cAlias1)->A8_LINHAS_PEDIDO
			aDados1[09]	:= (cAlias1)->A9_LINHAS_PEDIDO
			aDados1[10]	:= (cAlias1)->A10_VALOR_TOTAL
			aDados1[11]	:= (cAlias1)->A11_VALOR_DESCONTO

			aDados1[12]	:= UsrRetName((cAlias1)->A13_EMITENTE)
			aDados1[13]	:= (cAlias1)->A14_COMPRADOR

			DbSelectArea("SCR")
			SCR->(DbSetOrder(1))
			SCR->(DbGoTop())
			If DbSeek(xFilial('SCR')+'PC'+(cAlias1)->A2_PEDIDO)
				While SCR->(! Eof() .and. CR_FILIAL == xFilial('SCR') .AND. CR_NUM = (cAlias1)->A2_PEDIDO)
					If CR_STATUS == '03'
						aDados1[07] := (CR_DATALIB)
						aDados1[14] := UsrRetName(CR_USERLIB)
					Endif
					Exit
					SCR->(DbSkip())

				End
			Endif

					//aDados1[14]	:= UsrRetName((cAlias1)->A15_USER_LIB)

			STQTDESC8(aDados1[02])

			DbSelectArea(cAlias6)
			(cAlias6)->(DbGoTop())
			If  Select(cAlias6) > 0

				While 	(cAlias6)->(!Eof())

					aDados1[15]	:= (cAlias6)->QTDE

					(cAlias6)->(dbskip())
				End

			EndIf

			STQTDESC8L(aDados1[02]) // chamado 002916 - Robson Mazzarotto

			DbSelectArea(cAlias7)
			(cAlias7)->(DbGoTop())
			If  Select(cAlias7) > 0

				While 	(cAlias7)->(!Eof())

					aDados1[50]	:= (cAlias7)->QTDEL

					(cAlias7)->(dbskip())
				End

			EndIf


			oSection1:PrintLine()

			aFill(aDados1,nil)
			(cAlias1)->(dbskip())
		End
		oSection1:PrintTotal()
		oSection1:Finish()

		oReport:SkipLine()

		aFill(aDados1,nil)

		(cAlias1)->(dbCloseArea())
	EndIf
	oReport:SkipLine()




	oSection2:Init()

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0

		While 	(cAlias2)->(!Eof())

			aDados1[16]	:= 	UsrRetName((cAlias2)->B1_EMITENTE)
			aDados1[17]	:= (cAlias2)->B2_LINHAS_PEDIDO_01
			aDados1[18]	:= (cAlias2)->B3_QTDE_01
			aDados1[19]	:= (cAlias2)->B4_VALOR_TOTAL_01
			aDados1[20]	:= (cAlias2)->B5_LINHAS_PEDIDO_02
			aDados1[21]	:= (cAlias2)->B6_QTDE_02
			aDados1[22]	:= (cAlias2)->B7_VALOR_TOTAL_02
			aDados1[23]	:= (cAlias2)->B8_LINHAS_PEDIDO_04
			aDados1[24]	:= (cAlias2)->B9_QTDE_04
			aDados1[25]	:= (cAlias2)->B10_VALOR_TOTAL_04
			aDados1[26]	:= (cAlias2)->B11_LINHAS_PEDIDO_MAO
			aDados1[27]	:= (cAlias2)->B12_QTDE_MAO
			aDados1[28]	:= (cAlias2)->B13_VALOR_TOTAL_MAO

			aDados1[50]	:= (cAlias2)->B16_LINHAS_PEDIDO_03
			aDados1[51]	:= (cAlias2)->B17_QTDE_03
			aDados1[52]	:= (cAlias2)->B18_VALOR_TOTAL_03

			oSection2:PrintLine()

			aFill(aDados1,nil)
			(cAlias2)->(dbskip())
		End
		oSection2:PrintTotal()
		oSection2:Finish()
		oReport:SkipLine()

		aFill(aDados1,nil)

		//(cAlias2)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


	oSection3:Init()

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0

		While 	(cAlias2)->(!Eof())

			aDados1[29]	:= UsrRetName((cAlias2)->B1_EMITENTE)
			aDados1[30]	:= (cAlias2)->B2_LINHAS_PEDIDO_01+(cAlias2)->B5_LINHAS_PEDIDO_02+(cAlias2)->B8_LINHAS_PEDIDO_04+(cAlias2)->B11_LINHAS_PEDIDO_MAO+(cAlias2)->B16_LINHAS_PEDIDO_03 // CHAMADO 005238 - ROBSON MAZZAROTTO
			aDados1[31]	:= (cAlias2)->B3_QTDE_01+(cAlias2)->B6_QTDE_02+(cAlias2)->B9_QTDE_04+(cAlias2)->B12_QTDE_MAO+(cAlias2)->B17_QTDE_03
			aDados1[32]	:= (cAlias2)->B4_VALOR_TOTAL_01+(cAlias2)->B7_VALOR_TOTAL_02+(cAlias2)->B10_VALOR_TOTAL_04+(cAlias2)->B13_VALOR_TOTAL_MAO+(cAlias2)->B18_VALOR_TOTAL_03

			oSection3:PrintLine()

			aFill(aDados1,nil)
			(cAlias2)->(dbskip())
		End
		oSection3:PrintTotal()
		oSection3:Finish()
		oReport:SkipLine()

		aFill(aDados1,nil)

		(cAlias2)->(dbCloseArea())
	EndIf
	oReport:SkipLine()



	oSection4:Init()

	DbSelectArea(cAlias4)
	(cAlias4)->(DbGoTop())
	If  Select(cAlias4) > 0

		While 	(cAlias4)->(!Eof())

			aDados1[33]	:= (cAlias4)->FILIAL_MOTIVO
			aDados1[34]	:= (cAlias4)->MOTIVO
			aDados1[35]	:= (cAlias4)->DESCRI_MOTIVO
			aDados1[36]	:= (cAlias4)->CENTRO_CUSTO
			aDados1[37]	:= (cAlias4)->DESCRICAOCC
			aDados1[38]	:= (cAlias4)->LINHAS_PEDIDO_MOTIVO
			aDados1[39]	:= (cAlias4)->VALOR_TOTAL_MOTIVO
			aDados1[40]	:= (cAlias4)->VALOR_DESCONTO_MOTIVO

			oSection4:PrintLine()

			aFill(aDados1,nil)
			(cAlias4)->(dbskip())
		End
		oSection4:PrintTotal()
		oSection4:Finish()
		oReport:SkipLine()

		aFill(aDados1,nil)

		(cAlias4)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


	oSection5:Init()

	DbSelectArea(cAlias5)
	(cAlias5)->(DbGoTop())
	If  Select(cAlias5) > 0

		While 	(cAlias5)->(!Eof())

			aDados1[41]	:= (cAlias5)->E1_CODIGO
			aDados1[42]	:= (cAlias5)->E2_LOJA
			aDados1[43]	:= (cAlias5)->E3_RAZAO_SOCIAL
			aDados1[44]	:= (cAlias5)->E4_LINHAS_PEDIDO
			aDados1[45]	:= (cAlias5)->E5_VALOR_TOTAL
			aDados1[46]	:= (cAlias5)->E6_VALOR_DESCONTO
			aDados1[47]	:= (cAlias5)->E7_NUMERO
			aDados1[48]	:= DTOC(STOD((cAlias5)->E8_PRICOM))
			aDados1[49]	:= DTOC(STOD((cAlias5)->E9_ULTCOM))

			oSection5:PrintLine()

			aFill(aDados1,nil)
			(cAlias5)->(dbskip())
		End
		oSection5:PrintTotal()
		oSection5:Finish()
		oReport:SkipLine()

		aFill(aDados1,nil)

		(cAlias5)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |StQuery  บAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Query do Relat๓rio				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery1     := ' '
	Local cQuery2     := ' '
	Local cQuery4     := ' '
	Local cQuery5     := ' '

	cQuery1 := " SELECT
	cQuery1 += " C7_FILIAL AS A1_FILIAL,
	cQuery1 += " C7_NUM AS A2_PEDIDO,
	cQuery1 += " C7_FORNECE AS A3_FORNECEDOR,
	cQuery1 += " C7_LOJA AS A4_LOJA_FORNECE,
	cQuery1 += " A2_NOME AS A5_RAZAO_SOCIAL,
	cQuery1 += " C7_EMISSAO AS A6_DT_EMISSAO,
			//cQuery1 += " CR_DATALIB AS A7_DT_LIBER,

	cQuery1 += " NVL((SELECT COUNT(A1.C7_PRODUTO)
	cQuery1 += " FROM "+RetSqlName("SC7")+" A1 "
	cQuery1 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery1 += " AND   A1.C7_FILIAL  = TC7.C7_FILIAL
	cQuery1 += " AND   A1.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery1 += " AND   A1.C7_USER    = TC7.C7_USER
	cQuery1 += " AND   A1.C7_FORNECE = TC7.C7_FORNECE
	cQuery1 += " AND   A1.C7_LOJA    = TC7.C7_LOJA
	cQuery1 += " AND   A1.C7_NUM     = TC7.C7_NUM
	//cQuery1 += " AND   A1.C7_RESIDUO = ' '
	cQuery1 += " ),0)  AS A8_LINHAS_PEDIDO,

	cQuery1 += " NVL((SELECT COUNT(A4.C7_PRODUTO)
	cQuery1 += " FROM "+RetSqlName("SC7")+" A4 "
	cQuery1 += " WHERE A4.D_E_L_E_T_ = ' '
	cQuery1 += " AND   A4.C7_FILIAL  = TC7.C7_FILIAL
	cQuery1 += " AND   A4.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery1 += " AND   A4.C7_USER    = TC7.C7_USER
	cQuery1 += " AND   A4.C7_FORNECE = TC7.C7_FORNECE
	cQuery1 += " AND   A4.C7_LOJA    = TC7.C7_LOJA
	cQuery1 += " AND   A4.C7_NUM     = TC7.C7_NUM
	//cQuery1 += " AND   A4.C7_RESIDUO = ' '
	cQuery1 += " AND   A4.C7_NUMSC <> ' '
	cQuery1 += " ),0)  AS A9_LINHAS_PEDIDO,

	cQuery1 += " NVL((SELECT SUM(A2.C7_TOTAL)
	cQuery1 += " FROM "+RetSqlName("SC7")+" A2 "
	cQuery1 += " WHERE A2.D_E_L_E_T_ = ' '
	cQuery1 += " AND   A2.C7_FILIAL  = TC7.C7_FILIAL
	cQuery1 += " AND   A2.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery1 += " AND   A2.C7_USER    = TC7.C7_USER
	cQuery1 += " AND   A2.C7_FORNECE = TC7.C7_FORNECE
	cQuery1 += " AND   A2.C7_LOJA    = TC7.C7_LOJA
	cQuery1 += " AND   A2.C7_NUM     = TC7.C7_NUM
	//cQuery1 += " AND   A2.C7_RESIDUO = ' '
	cQuery1 += " ),0)  AS A10_VALOR_TOTAL,

	cQuery1 += " NVL((SELECT SUM(A3.C7_VLDESC)
	cQuery1 += " FROM "+RetSqlName("SC7")+" A3 "
	cQuery1 += " WHERE A3.D_E_L_E_T_ = ' '
	cQuery1 += " AND   A3.C7_FILIAL  = TC7.C7_FILIAL
	cQuery1 += " AND   A3.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery1 += " AND   A3.C7_USER    = TC7.C7_USER
	cQuery1 += " AND   A3.C7_FORNECE = TC7.C7_FORNECE
	cQuery1 += " AND   A3.C7_LOJA    = TC7.C7_LOJA
	cQuery1 += " AND   A3.C7_NUM     = TC7.C7_NUM
	//cQuery1 += " AND   A3.C7_RESIDUO = ' '
	cQuery1 += " ),0)  AS A11_VALOR_DESCONTO,

	cQuery1 += " C7_USER AS A13_EMITENTE,
			//cQuery1 += " CASE WHEN Y1_USER >= '000000'  THEN 'SIM' ELSE
			//cQuery1 += " 'NรO' END  AS A14_COMPRADOR

	cQuery1 += " CASE WHEN Y1_ZDEPTO = '1'  THEN 'SIM' ELSE
	cQuery1 += " CASE WHEN Y1_ZDEPTO = '2'  THEN 'NรO' ELSE
	cQuery1 += " 'NC' END END AS A14_COMPRADOR

			//cQuery1 += " CR_USERLIB AS A15_USER_LIB

	cQuery1 += " FROM "+RetSqlName("SC7")+" TC7 "

	If Mv_Par11 = 3
		cQuery1 += " LEFT JOIN "+RetSqlName("SY1")+" TY1 "
		cQuery1 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery1 += " AND Y1_USER = C7_USER
	Else
		cQuery1 += " INNER JOIN "+RetSqlName("SY1")+" TY1 "
		cQuery1 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery1 += " AND Y1_USER = C7_USER
		If Mv_Par11 = 1
			cQuery1 += " AND Y1_ZDEPTO = '1'
		Elseif Mv_Par11 = 2
			cQuery1 += " AND Y1_ZDEPTO = '2'

		Endif
	Endif

	cQuery1 += " INNER JOIN "+RetSqlName("SA2")+" TA2 "
	cQuery1 += " ON TA2.D_E_L_E_T_ = ' '
	cQuery1 += " AND A2_COD = C7_FORNECE
	cQuery1 += " AND A2_LOJA = C7_LOJA

			//cQuery1 += " LEFT JOIN "+RetSqlName("SCR")+" TCR "
			//cQuery1 += " ON TCR.D_E_L_E_T_ = ' '
			//cQuery1 += " AND CR_FILIAL = C7_FILIAL
			//cQuery1 += " AND CR_NUM = C7_NUM
			//cQuery1 += " AND CR_STATUS = '03'

	cQuery1 += " WHERE TC7.D_E_L_E_T_ = ' '
	//cQuery1 += " AND C7_RESIDUO = ' '
	cQuery1 += " AND TC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery1 += " AND TC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
	cQuery1 += " AND TC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
	cQuery1 += " AND TC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
	cQuery1 += " AND TC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

			//cQuery1 += " GROUP BY C7_FILIAL, C7_NUM, C7_USER, Y1_USER, C7_FORNECE,C7_LOJA,A2_NOME, C7_EMISSAO,  CR_DATALIB, CR_EMISSAO,CR_USERLIB,  C7_TIPO
	cQuery1 += " GROUP BY C7_FILIAL, C7_NUM, C7_USER, Y1_USER, C7_FORNECE,C7_LOJA,A2_NOME, C7_EMISSAO, C7_TIPO, Y1_ZDEPTO
	cQuery1 += " ORDER BY C7_USER, C7_FILIAL, C7_NUM


	cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

	cQuery2 := " SELECT

	cQuery2 += " B1_EMITENTE                AS B1_EMITENTE,
	cQuery2 += " SUM(B2_LINHAS_PEDIDO_01)   AS B2_LINHAS_PEDIDO_01,
	cQuery2 += " SUM(B3_QTDE_01)            AS B3_QTDE_01,
	cQuery2 += " SUM(B4_VALOR_TOTAL_01)     AS B4_VALOR_TOTAL_01,
	cQuery2 += " SUM(B5_LINHAS_PEDIDO_02)   AS B5_LINHAS_PEDIDO_02,
	cQuery2 += " SUM(B6_QTDE_02)            AS B6_QTDE_02,
	cQuery2 += " SUM(B7_VALOR_TOTAL_02)     AS B7_VALOR_TOTAL_02,
	cQuery2 += " SUM(B16_LINHAS_PEDIDO_03)  AS B16_LINHAS_PEDIDO_03,
	cQuery2 += " SUM(B17_QTDE_03)           AS B17_QTDE_03,
	cQuery2 += " SUM(B18_VALOR_TOTAL_03)    AS B18_VALOR_TOTAL_03,
	cQuery2 += " SUM(B8_LINHAS_PEDIDO_04)   AS B8_LINHAS_PEDIDO_04,
	cQuery2 += " SUM(B9_QTDE_04)            AS B9_QTDE_04,
	cQuery2 += " SUM(B10_VALOR_TOTAL_04)    AS B10_VALOR_TOTAL_04,
	cQuery2 += " SUM(B11_LINHAS_PEDIDO_MAO) AS B11_LINHAS_PEDIDO_MAO,
	cQuery2 += " SUM(B12_QTDE_MAO)          AS B12_QTDE_MAO,
	cQuery2 += " SUM(B13_VALOR_TOTAL_MAO)   AS B13_VALOR_TOTAL_MAO

	cQuery2 += " FROM
	cQuery2 += " (

	cQuery2 += " SELECT
	cQuery2 += " C7_USER AS B1_EMITENTE,
	cQuery2 += " C7_NUM AS PEDIDO,

	cQuery2 += " NVL((SELECT COUNT(A1.C7_PRODUTO)
	cQuery2 += " FROM  SC7010 A1
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A1.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A1.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A1.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A1.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A1.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A1.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A1.C7_RESIDUO = ' '
	cQuery2 += " AND   A1.C7_FILIAL = '01'
	cQuery2 += " ),0)  AS B2_LINHAS_PEDIDO_01,

	cQuery2 += " NVL((SELECT DISTINCT COUNT(SUM((A2.C7_NUM)))
	cQuery2 += " FROM  SC7010 A2
	cQuery2 += " WHERE A2.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A2.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A2.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A2.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A2.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A2.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A2.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A2.C7_RESIDUO = ' '
	cQuery2 += " AND   A2.C7_FILIAL = '01'
	cQuery2 += " GROUP BY C7_NUM
	cQuery2 += " ),0)  AS B3_QTDE_01,

	cQuery2 += " NVL((SELECT SUM(A3.C7_TOTAL)
	cQuery2 += " FROM  SC7010 A3
	cQuery2 += " WHERE A3.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A3.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A3.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A3.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A3.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A3.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A3.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A3.C7_RESIDUO = ' '
	cQuery2 += " AND   A3.C7_FILIAL = '01'
	cQuery2 += " ),0)  AS B4_VALOR_TOTAL_01,

	cQuery2 += " NVL((SELECT COUNT(A5.C7_PRODUTO)
	cQuery2 += " FROM  SC7010 A5
	cQuery2 += " WHERE A5.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A5.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A5.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A5.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A5.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A5.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A5.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A5.C7_RESIDUO = ' '
	cQuery2 += " AND   A5.C7_FILIAL = '02'
	cQuery2 += " ),0)  AS B5_LINHAS_PEDIDO_02,

	cQuery2 += " NVL((SELECT DISTINCT COUNT(SUM((A6.C7_NUM)))
	cQuery2 += " FROM  SC7010 A6
	cQuery2 += " WHERE A6.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A6.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A6.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A6.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A6.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A6.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A6.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A6.C7_RESIDUO = ' '
	cQuery2 += " AND   A6.C7_FILIAL = '02'
	cQuery2 += " GROUP BY C7_NUM
	cQuery2 += " ),0)  AS B6_QTDE_02,

	cQuery2 += " NVL((SELECT SUM(A7.C7_TOTAL)
	cQuery2 += " FROM  SC7010 A7
	cQuery2 += " WHERE A7.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A7.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A7.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A7.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A7.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A7.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A7.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A7.C7_RESIDUO = ' '
	cQuery2 += " AND   A7.C7_FILIAL = '02'
	cQuery2 += " ),0)  AS B7_VALOR_TOTAL_02,

   // Adicionado na query os pedidos da filial 03, CHAMADO 005238 - Robson Mazzarotto

	cQuery2 += " NVL((SELECT COUNT(A16.C7_PRODUTO)
	cQuery2 += " FROM  SC7010 A16
	cQuery2 += " WHERE A16.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A16.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A16.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A16.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A16.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A16.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A16.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A9.C7_RESIDUO = ' '
	cQuery2 += " AND   A16.C7_FILIAL = '03'
	cQuery2 += " ),0)  AS B16_LINHAS_PEDIDO_03,

	cQuery2 += " NVL((SELECT DISTINCT COUNT(SUM((A17.C7_NUM)))
	cQuery2 += " FROM  SC7010 A17
	cQuery2 += " WHERE A17.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A17.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A17.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A17.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A17.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A17.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A17.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A10.C7_RESIDUO = ' '
	cQuery2 += " AND   A17.C7_FILIAL = '03'
	cQuery2 += " GROUP BY C7_NUM
	cQuery2 += " ),0)  AS B17_QTDE_03,

	cQuery2 += " NVL((SELECT SUM(A18.C7_TOTAL)
	cQuery2 += " FROM  SC7010 A18
	cQuery2 += " WHERE A18.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A18.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A18.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A18.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A18.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A18.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A18.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A11.C7_RESIDUO = ' '
	cQuery2 += " AND   A18.C7_FILIAL = '03'
	cQuery2 += " ),0)  AS B18_VALOR_TOTAL_03,


	cQuery2 += " NVL((SELECT COUNT(A9.C7_PRODUTO)
	cQuery2 += " FROM  SC7010 A9
	cQuery2 += " WHERE A9.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A9.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A9.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A9.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A9.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A9.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A9.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A9.C7_RESIDUO = ' '
	cQuery2 += " AND   A9.C7_FILIAL = '04'
	cQuery2 += " ),0)  AS B8_LINHAS_PEDIDO_04,

	cQuery2 += " NVL((SELECT DISTINCT COUNT(SUM((A10.C7_NUM)))
	cQuery2 += " FROM  SC7010 A10
	cQuery2 += " WHERE A10.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A10.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A10.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A10.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A10.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A10.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A10.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A10.C7_RESIDUO = ' '
	cQuery2 += " AND   A10.C7_FILIAL = '04'
	cQuery2 += " GROUP BY C7_NUM
	cQuery2 += " ),0)  AS B9_QTDE_04,

	cQuery2 += " NVL((SELECT SUM(A11.C7_TOTAL)
	cQuery2 += " FROM  SC7010 A11
	cQuery2 += " WHERE A11.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A11.C7_FILIAL  = TC7.C7_FILIAL
	cQuery2 += " AND   A11.C7_EMISSAO = TC7.C7_EMISSAO
	cQuery2 += " AND   A11.C7_USER    = TC7.C7_USER
	cQuery2 += " AND   A11.C7_FORNECE = TC7.C7_FORNECE
	cQuery2 += " AND   A11.C7_LOJA    = TC7.C7_LOJA
	cQuery2 += " AND   A11.C7_NUM     = TC7.C7_NUM
	//cQuery2 += " AND   A11.C7_RESIDUO = ' '
	cQuery2 += " AND   A11.C7_FILIAL = '04'
	cQuery2 += " ),0)  AS B10_VALOR_TOTAL_04,

	cQuery2 += " 0 AS B11_LINHAS_PEDIDO_MAO,
	cQuery2 += " 0 AS B12_QTDE_MAO,
	cQuery2 += " 0 AS B13_VALOR_TOTAL_MAO

	cQuery2 += " FROM SC7010 TC7

	If Mv_Par11 = 3
		cQuery2 += " LEFT JOIN SY1010 TY1
		cQuery2 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery2 += " AND Y1_USER = C7_USER
	Else
		cQuery2 += " INNER JOIN SY1010 TY1
		cQuery2 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery2 += " AND Y1_USER = C7_USER
		If Mv_Par11 = 1
			cQuery2 += " AND Y1_ZDEPTO = '1'
		Elseif Mv_Par11 = 2
			cQuery2 += " AND Y1_ZDEPTO = '2'

		Endif
	Endif

	cQuery2 += " WHERE TC7.D_E_L_E_T_ = ' '
	//cQuery2 += " AND C7_RESIDUO = ' '
	cQuery2 += " AND TC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery2 += " AND TC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
	cQuery2 += " AND TC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
	cQuery2 += " AND TC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
	cQuery2 += " AND TC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

	cQuery2 += " GROUP BY C7_USER , C7_FILIAL,C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_NUM, Y1_ZDEPTO

	cQuery2 += " UNION

	cQuery2 += " SELECT
	cQuery2 += " C7_USER AS B1_EMITENTE,
	cQuery2 += " C7_NUM AS PEDIDO,

	cQuery2 += " 0 AS B2_LINHAS_PEDIDO_01,
	cQuery2 += " 0 AS B3_QTDE_01,
	cQuery2 += " 0 AS B4_VALOR_TOTAL_01,
	cQuery2 += " 0 AS B5_LINHAS_PEDIDO_02,
	cQuery2 += " 0 AS B6_QTDE_02,
	cQuery2 += " 0 AS B7_VALOR_TOTAL_02,
	cQuery2 += " 0 AS B11_LINHAS_PEDIDO_03,
	cQuery2 += " 0 AS B12_QTDE_03,
	cQuery2 += " 0 AS B13_VALOR_TOTAL_03,
	cQuery2 += " 0 AS B8_LINHAS_PEDIDO_04,
	cQuery2 += " 0 AS B9_QTDE_04,
	cQuery2 += " 0 AS B10_VALOR_TOTAL_04,

	cQuery2 += " NVL((SELECT COUNT(A12.C7_PRODUTO)
	cQuery2 += " FROM  SC7030 A12
	cQuery2 += " WHERE A12.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A12.C7_FILIAL  = SC7.C7_FILIAL
	cQuery2 += " AND   A12.C7_EMISSAO = SC7.C7_EMISSAO
	cQuery2 += " AND   A12.C7_USER    = SC7.C7_USER
	cQuery2 += " AND   A12.C7_FORNECE = SC7.C7_FORNECE
	cQuery2 += " AND   A12.C7_LOJA    = SC7.C7_LOJA
	cQuery2 += " AND   A12.C7_NUM     = SC7.C7_NUM
	//cQuery2 += " AND   A12.C7_RESIDUO = ' '
	cQuery2 += " ),0)  AS B11_LINHAS_PEDIDO_MAO,

	cQuery2 += " NVL((SELECT DISTINCT COUNT(SUM((A13.C7_NUM)))
	cQuery2 += " FROM  SC7030 A13
	cQuery2 += " WHERE A13.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A13.C7_FILIAL  = SC7.C7_FILIAL
	cQuery2 += " AND   A13.C7_EMISSAO = SC7.C7_EMISSAO
	cQuery2 += " AND   A13.C7_USER    = SC7.C7_USER
	cQuery2 += " AND   A13.C7_FORNECE = SC7.C7_FORNECE
	cQuery2 += " AND   A13.C7_LOJA    = SC7.C7_LOJA
	cQuery2 += " AND   A13.C7_NUM     = SC7.C7_NUM
	//cQuery2 += " AND   A13.C7_RESIDUO = ' '
	cQuery2 += " GROUP BY C7_NUM
	cQuery2 += " ),0)  AS B12_QTDE_MAO,

	cQuery2 += " NVL((SELECT SUM(A14.C7_TOTAL)
	cQuery2 += " FROM  SC7030 A14
	cQuery2 += " WHERE A14.D_E_L_E_T_ = ' '
	cQuery2 += " AND   A14.C7_FILIAL  = SC7.C7_FILIAL
	cQuery2 += " AND   A14.C7_EMISSAO = SC7.C7_EMISSAO
	cQuery2 += " AND   A14.C7_USER    = SC7.C7_USER
	cQuery2 += " AND   A14.C7_FORNECE = SC7.C7_FORNECE
	cQuery2 += " AND   A14.C7_LOJA    = SC7.C7_LOJA
	cQuery2 += " AND   A14.C7_NUM     = SC7.C7_NUM
	//cQuery2 += " AND   A14.C7_RESIDUO = ' '
	cQuery2 += " ),0)  AS B13_VALOR_TOTAL_MAO

	cQuery2 += " FROM SC7030 SC7

	If Mv_Par11 = 3
		cQuery2 += " LEFT JOIN SY1030 TY1
		cQuery2 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery2 += " AND Y1_USER = C7_USER
	Else
		cQuery2 += " INNER JOIN SY1030 TY1
		cQuery2 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery2 += " AND Y1_USER = C7_USER
		If Mv_Par11 = 1
			cQuery2 += " AND Y1_ZDEPTO = '1'
		Elseif Mv_Par11 = 2
			cQuery2 += " AND Y1_ZDEPTO = '2'

		Endif
	Endif

	cQuery2 += " WHERE SC7.D_E_L_E_T_ = ' '
	//cQuery2 += " AND C7_RESIDUO = ' '
	cQuery2 += " AND SC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery2 += " AND SC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
	cQuery2 += " AND SC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
	cQuery2 += " AND SC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
	cQuery2 += " AND SC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

	cQuery2 += " GROUP BY C7_USER , C7_FILIAL,C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_NUM, Y1_ZDEPTO
	cQuery2 += " )

	cQuery2 += " GROUP BY B1_EMITENTE
	cQuery2 += " ORDER BY B1_EMITENTE

	cQuery2 := ChangeQuery(cQuery2)

	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)

/*
	cQuery3 := " SELECT
	cQuery3 += " B1_EMITENTE                                                                              AS C1_EMITENTE,
	cQuery3 += " SUM(B2_LINHAS_PEDIDO_01+B5_LINHAS_PEDIDO_02+B8_LINHAS_PEDIDO_04+B11_LINHAS_PEDIDO_MAO)   AS C2_LINHAS_PEDIDO,
	cQuery3 += " SUM(B3_QTDE_01+B6_QTDE_02+B9_QTDE_04+B12_QTDE_MAO)                                       AS C3_QTDE,
	cQuery3 += " SUM(B4_VALOR_TOTAL_01+B7_VALOR_TOTAL_02+B10_VALOR_TOTAL_04+B13_VALOR_TOTAL_MAO)          AS C4_VALOR_TOTAL

	cQuery3 += " FROM "+cTemp

	cQuery3 += " GROUP BY B1_EMITENTE
	cQuery3 += " ORDER BY B1_EMITENTE

	cQuery3 := ChangeQuery(cQuery3)

	If Select(cAlias3) > 0
		(cAlias3)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery3),cAlias3)
*/
	cQuery4 := " " // Chamado 007207 - Everson Santana 18.04.18
	If cEmpAnt <> '03' // Chamado 007207 - Everson Santana 18.04.18
		cQuery4 += " SELECT * FROM ( "
		cQuery4 += " SELECT 'SP' EMPRESA,
		cQuery4 += " C7_FILIAL AS FILIAL_MOTIVO,
		cQuery4 += " C7_MOTIVO AS MOTIVO,
		cQuery4 += " Z1_DESCRI AS DESCRI_MOTIVO,
		cQuery4 += " C7_CC AS CENTRO_CUSTO,
		cQuery4 += " CTT_DESC01 AS DESCRICAOCC,
		cQuery4 += " COUNT(C7_NUM)  AS LINHAS_PEDIDO_MOTIVO,
		cQuery4 += " SUM(C7_TOTAL) AS VALOR_TOTAL_MOTIVO,
		cQuery4 += " SUM(C7_VLDESC) AS VALOR_DESCONTO_MOTIVO

	//cQuery4 += " FROM "+RetSqlName("SC7")+" TC7 " ////>> Chamado 007103 - Everson Santana 02.04.18
		cQuery4 += " FROM SC7010 TC7 " ////>> Chamado 007103 - Everson Santana 02.04.18

	//cQuery4 += " LEFT JOIN "+RetSqlName("CTT")+" CTT " //>> Chamado 007103 - Everson Santana 02.04.18
		cQuery4 += " LEFT JOIN CTT010 CTT " //>> Chamado 007103 - Everson Santana 02.04.18
		cQuery4 += " ON CTT.D_E_L_E_T_ = ' '
		cQuery4 += " AND C7_CC = CTT_CUSTO

	//cQuery4 += " LEFT JOIN "+RetSqlName("SZ1")+" TZ1 " //>> Chamado 007103 - Everson Santana 02.04.18
		cQuery4 += " LEFT JOIN SZ1010 TZ1 " //>> Chamado 007103 - Everson Santana 02.04.18
		cQuery4 += " ON TZ1.D_E_L_E_T_ = ' '
		cQuery4 += " AND C7_MOTIVO = Z1_CODIGO

		If Mv_Par11 = 3
		//cQuery4 += " LEFT JOIN "+RetSqlName("SY1")+" TY1 " //>> Chamado 007103 - Everson Santana 02.04.18
			cQuery4 += " LEFT JOIN SY1010 TY1 " //>> Chamado 007103 - Everson Santana 02.04.18
			cQuery4 += " ON TY1.D_E_L_E_T_ = ' '
			cQuery4 += " AND Y1_USER = C7_USER
		Else
		//cQuery4 += " INNER JOIN "+RetSqlName("SY1")+" TY1 " //>> Chamado 007103 - Everson Santana 02.04.18
			cQuery4 += " INNER JOIN SY1010 TY1 " //>> Chamado 007103 - Everson Santana 02.04.18
			cQuery4 += " ON TY1.D_E_L_E_T_ = ' '
			cQuery4 += " AND Y1_USER = C7_USER
			If Mv_Par11 = 1
				cQuery4 += " AND Y1_ZDEPTO = '1'
			Elseif Mv_Par11 = 2
				cQuery4 += " AND Y1_ZDEPTO = '2'

			Endif
		Endif

		cQuery4 += " WHERE TC7.D_E_L_E_T_ = ' '
	//cQuery4 += " AND C7_RESIDUO = ' '
		cQuery4 += " AND TC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
		cQuery4 += " AND TC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
		cQuery4 += " AND TC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
		cQuery4 += " AND TC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
		cQuery4 += " AND TC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

		cQuery4 += " GROUP BY C7_MOTIVO, C7_FILIAL, Z1_DESCRI, C7_CC , CTT_DESC01, Y1_ZDEPTO


	//>> Chamado 007103 - Everson Santana 02.04.18

		cQuery4 += " UNION "
	EndIf // Chamado 007207 - Everson Santana 18.04.18

	cQuery4 += " SELECT 'MAO' EMPRESA,
	cQuery4 += " C7_FILIAL AS FILIAL_MOTIVO,
	cQuery4 += " C7_MOTIVO AS MOTIVO,
	cQuery4 += " Z1_DESCRI AS DESCRI_MOTIVO,
	cQuery4 += " C7_CC AS CENTRO_CUSTO,
	cQuery4 += " CTT_DESC01 AS DESCRICAOCC,
	cQuery4 += " COUNT(C7_NUM)  AS LINHAS_PEDIDO_MOTIVO,
	cQuery4 += " SUM(C7_TOTAL) AS VALOR_TOTAL_MOTIVO,
	cQuery4 += " SUM(C7_VLDESC) AS VALOR_DESCONTO_MOTIVO

	cQuery4 += " FROM SC7030 TC7 "

	cQuery4 += " LEFT JOIN CTT030 CTT "
	cQuery4 += " ON CTT.D_E_L_E_T_ = ' '
	cQuery4 += " AND C7_CC = CTT_CUSTO

	cQuery4 += " LEFT JOIN SZ1030 TZ1 "
	cQuery4 += " ON TZ1.D_E_L_E_T_ = ' '
	cQuery4 += " AND C7_MOTIVO = Z1_CODIGO

	If Mv_Par11 = 3
		cQuery4 += " LEFT JOIN SY1030 TY1 "
		cQuery4 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery4 += " AND Y1_USER = C7_USER
	Else
		cQuery4 += " INNER JOIN SY1030 TY1 "
		cQuery4 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery4 += " AND Y1_USER = C7_USER
		If Mv_Par11 = 1
			cQuery4 += " AND Y1_ZDEPTO = '1'
		Elseif Mv_Par11 = 2
			cQuery4 += " AND Y1_ZDEPTO = '2'

		Endif
	Endif

	cQuery4 += " WHERE TC7.D_E_L_E_T_ = ' '
	cQuery4 += " AND TC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery4 += " AND TC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
	cQuery4 += " AND TC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
	cQuery4 += " AND TC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
	cQuery4 += " AND TC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

	cQuery4 += " GROUP BY C7_MOTIVO, C7_FILIAL, Z1_DESCRI, C7_CC , CTT_DESC01, Y1_ZDEPTO

	If cEmpAnt <> '03' // Chamado 007207 - Everson Santana 18.04.18

		cQuery4 += " ) MOT"

		cQuery4 += " ORDER BY MOT.MOTIVO, MOT.FILIAL_MOTIVO, MOT.CENTRO_CUSTO "
	Else
		cQuery4 += " ORDER BY MOTIVO, FILIAL_MOTIVO, CENTRO_CUSTO " // Chamado 007207 - Everson Santana 18.04.18
	EndIf

	//<< Chamado 007103 - Everson Santana 02.04.18

	cQuery4 := ChangeQuery(cQuery4)

	If Select(cAlias4) > 0
		(cAlias4)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery4),cAlias4)


	cQuery5 := " SELECT
	cQuery5 += " DISTINCT
	cQuery5 += " C7_FORNECE AS E1_CODIGO,
	cQuery5 += " C7_LOJA AS E2_LOJA,
	cQuery5 += " A2_NOME AS E3_RAZAO_SOCIAL,

	cQuery5 += " NVL (COUNT(C7_PRODUTO)
	cQuery5 += " ,0)  AS E4_LINHAS_PEDIDO,

	cQuery5 += " NVL (SUM(C7_TOTAL)
	cQuery5 += " ,0)AS E5_VALOR_TOTAL,

	cQuery5 += " NVL (SUM(C7_VLDESC)
	cQuery5 += " ,0)AS E6_VALOR_DESCONTO,

	cQuery5 += " A2_NROCOM AS E7_NUMERO,
	cQuery5 += " A2_PRICOM AS E8_PRICOM,
	cQuery5 += " A2_ULTCOM AS E9_ULTCOM

	cQuery5 += " FROM "+RetSqlName("SC7")+" TC7 "

	If Mv_Par11 = 3
		cQuery5 += " LEFT JOIN "+RetSqlName("SY1")+" TY1 "
		cQuery5 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery5 += " AND Y1_USER = C7_USER
	Else
		cQuery5 += " INNER JOIN "+RetSqlName("SY1")+" TY1 "
		cQuery5 += " ON TY1.D_E_L_E_T_ = ' '
		cQuery5 += " AND Y1_USER = C7_USER
		If Mv_Par11 = 1
			cQuery5 += " AND Y1_ZDEPTO = '1'
		Elseif Mv_Par11 = 2
			cQuery5 += " AND Y1_ZDEPTO = '2'

		Endif
	Endif

	cQuery5 += " INNER JOIN "+RetSqlName("SA2")+" TA2 "
	cQuery5 += " ON TA2.D_E_L_E_T_ = ' '
	cQuery5 += " AND A2_COD  = TC7.C7_FORNECE
	cQuery5 += " AND A2_LOJA = TC7.C7_LOJA

	cQuery5 += " WHERE TC7.D_E_L_E_T_ = ' '
	//cQuery5 += " AND C7_RESIDUO = ' '
	cQuery5 += " AND TC7.C7_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery5 += " AND TC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'
	cQuery5 += " AND TC7.C7_USER    BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'
	cQuery5 += " AND TC7.C7_FORNECE BETWEEN '"+(mv_par07)+"' AND '"+(mv_par09)+"'
	cQuery5 += " AND TC7.C7_LOJA    BETWEEN '"+(mv_par08)+"' AND '"+(mv_par10)+"'

	cQuery5 += " GROUP BY C7_FORNECE, C7_LOJA, A2_NOME, A2_NROCOM ,A2_PRICOM ,A2_ULTCOM, Y1_ZDEPTO
	cQuery5 += " ORDER BY C7_FORNECE

	cQuery5 := ChangeQuery(cQuery5)

	If Select(cAlias5) > 0
		(cAlias5)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery5),cAlias5)

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |STQTDESC8   บAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Query do Relat๓rio				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function STQTDESC8(_Cod)
*-----------------------------*

	Local cQuery6   := ' '

	cQuery6 := " SELECT DISTINCT
	cQuery6 += " COUNT(SUM((C8_FORNECE))) AS QTDE

	cQuery6 += " FROM "+RetSqlName("SC8")+" TC8 "

	cQuery6 += " INNER JOIN "+RetSqlName("SC7")+" TC7 "
	cQuery6 += " ON TC7.D_E_L_E_T_ = ' '
	cQuery6 += " AND TC7.C7_NUMSC = TC8.C8_NUMSC
	cQuery6 += " AND TC7.C7_FILIAL = TC8.C8_FILIAL
	cQuery6 += " AND TC7.C7_PRODUTO = TC8.C8_PRODUTO

	cQuery6 += " WHERE TC8.D_E_L_E_T_ = ' '
	cQuery6 += " AND TC7.C7_NUM = '"+(_Cod)+"'"
	cQuery6 += " AND TC8.C8_TOTAL > 0

	cQuery6 += " GROUP BY C8_FORNECE+C8_LOJA

	cQuery6 := ChangeQuery(cQuery6)

	If Select(cAlias6) > 0
		(cAlias6)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery6),cAlias6)

Return ()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |STQTDESC8L  บAutor  ณRobson Mazzarotto บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Query do Relat๓rio				                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function STQTDESC8L(_Cod)
*-----------------------------*

	Local cQuery7   := ' '

	cQuery7 := " SELECT DISTINCT
	cQuery7 += " COUNT(C8_NUM) AS QTDEL

	cQuery7 += " FROM "+RetSqlName("SC8")+" TC8 "

	cQuery7 += " INNER JOIN "+RetSqlName("SC7")+" TC7 "
	cQuery7 += " ON TC7.D_E_L_E_T_ = ' '
	cQuery7 += " AND TC7.C7_NUMSC = TC8.C8_NUMSC
	cQuery7 += " AND TC7.C7_FILIAL = TC8.C8_FILIAL
	cQuery7 += " AND TC7.C7_PRODUTO = TC8.C8_PRODUTO

	cQuery7 += " WHERE TC8.D_E_L_E_T_ = ' '
	cQuery7 += " AND TC7.C7_NUM = '"+(_Cod)+"'"
	cQuery7 += " AND TC8.C8_TOTAL > 0


//	cQuery7 += " GROUP BY C8_FORNECE+C8_LOJA

	cQuery7 := ChangeQuery(cQuery7)

	If Select(cAlias7) > 0
		(cAlias7)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery7),cAlias7)

Return ()








