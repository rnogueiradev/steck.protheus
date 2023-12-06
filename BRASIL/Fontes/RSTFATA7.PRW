#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFATA7  บAutor  ณJoใo Victor         บ Data ณ  10/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Itens Faltantes em Pedido de Venda              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATA7()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATA7"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private cAlias1      := cAliasLif
	Private _cTitulo     := "Relat๓rio Itens Faltantes em Pedido de Venda"
	Private _cDescri     := "Este programa irแ imprimir um relat๓rio de Itens Faltantes em Pedido de Venda"
	Private _cSection1   := "Itens Faltantes em Pedido de Venda"
	Private _cPerg01     := "Filial De: ?"
	Private _cPerg02     := "Filial At้: ?"
	Private _cPerg03     := "Produto De: ?"
	Private _cPerg04     := "Produto At้: ?"
	Private _cPerg05     := "Emissใo De: ?"
	Private _cPerg06     := "Emissใo At้: ?"
	Private _cPerg07     := "Classifica็ใo: ?"
	Private aHelp1       := {}
	Private aHelp2       := {}
	Private aHelp3       := {}
	Private aHelp4       := {}
	Private _cClaprod    := ''
	
	Aadd(aHelp1, "Informe a Filial desejada               " )
	Aadd(aHelp2, "Informe o Produto desejado              " )
	Aadd(aHelp3, "Informe a Data de Emissใo do Pedido     " )
	Aadd(aHelp4, "Informe a Classifica็ใo do Produto      " )
	
	//-------cGrupo,cOrdem,cPergunt      ,cPergSpa      ,cPergEng      ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	//tSx1(cPerg   ,"01"  ,"Filial ?"    ,"Filial ?"    ,"Filial ?"    ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"  ,_cPerg01      ,_cPerg01      ,_cPerg01      ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(2)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"02"  ,_cPerg02      ,_cPerg02      ,_cPerg02      ,"mv_ch2"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",2)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"03"  ,_cPerg03      ,_cPerg03      ,_cPerg03      ,"mv_ch3"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(15)            ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp2  ,aHelp2  ,aHelp2)
	PutSx1(cPerg   ,"04"  ,_cPerg04      ,_cPerg04      ,_cPerg04      ,"mv_ch4"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Replicate("Z",15)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp2  ,aHelp2  ,aHelp2)
	PutSx1(cPerg   ,"05"  ,_cPerg05      ,_cPerg05      ,_cPerg05      ,"mv_ch5"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp3  ,aHelp3  ,aHelp3)
	PutSx1(cPerg   ,"06"  ,_cPerg06      ,_cPerg06      ,_cPerg06      ,"mv_ch6"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par06"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp3  ,aHelp3  ,aHelp3)
	PutSx1(cPerg   ,"07"  ,_cPerg07      ,_cPerg07      ,_cPerg07      ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,""    ,""     ,"S"  ,"mv_par07"    ,"Comprado"        ,""      ,""      ,""                   ,"Importado"        ,""        ,""      ,"Fabricado"    ,""      ,""      ,"Todos"               ,""      ,""      ,""    ,""      ,""      ,aHelp4  ,aHelp4  ,aHelp4)

	oReport		:= ReportDef()
	 oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  10/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cabe็alho do Relat๓rio                                    บฑฑ
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
	
	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 6

	Pergunte(cPerg,.F.)

//Primeira Se็ใo
	oSection1 := TRSection():New(oReport,_cSection1,{cAlias1})
	TRCell():New(oSection1,"A1" ,,"Filial"                     ,PesqPict("SC6","C6_FILIAL")         ,TamSX3("C6_FILIAL")       [1]+2)
	TRCell():New(oSection1,"A2" ,,"Pedido"                     ,PesqPict("SC6","C6_NUM")            ,TamSX3("C6_NUM")          [1]+2)
	TRCell():New(oSection1,"A3" ,,"Dt. Emissใo"                ,PesqPict("SC5","C5_EMISSAO")        ,TamSX3("C5_EMISSAO")      [1]+2)
	TRCell():New(oSection1,"A4" ,,"C๓digo"                     ,PesqPict("SC6","C6_PRODUTO")        ,TamSX3("C6_PRODUTO")      [1]+2)
	TRCell():New(oSection1,"A5" ,,"Descri็ใo Produto"          ,PesqPict("SB1","B1_DESC")           ,TamSX3("B1_DESC")         [1]+2)
	TRCell():New(oSection1,"A6" ,,"Classifica็ใo"              ,PesqPict("SB1","B1_CLAPROD")        ,TamSX3("B1_CLAPROD")      [1]+2)
	TRCell():New(oSection1,"A7" ,,"Grupo"                      ,PesqPict("SB1","B1_GRUPO")          ,TamSX3("B1_GRUPO")        [1]+2)
	TRCell():New(oSection1,"A8" ,,"Descri็ใo Grupo"            ,PesqPict("SBM","BM_DESC")           ,TamSX3("BM_DESC")         [1]+2)
	TRCell():New(oSection1,"A9" ,,"Saldo Pedido"               ,PesqPict("SC6","C6_QTDVEN")         ,TamSX3("C6_QTDVEN")       [1]+2)
	TRCell():New(oSection1,"A10",,"Falta"                      ,PesqPict("PA1","PA1_QUANT")         ,TamSX3("PA1_QUANT")       [1]+2)
	TRCell():New(oSection1,"A11",,"Reserva"                    ,PesqPict("PA2","PA2_QUANT")         ,TamSX3("PA2_QUANT")       [1]+2)
	TRCell():New(oSection1,"A12",,"Cliente"                    ,PesqPict("SC5","C5_CLIENTE")        ,TamSX3("C5_CLIENTE")      [1]+2)
	TRCell():New(oSection1,"A13",,"Lj"                         ,PesqPict("SC5","C5_LOJACLI")        ,TamSX3("C5_LOJACLI")      [1]+2)
	TRCell():New(oSection1,"A14",,"Razใo Social"               ,PesqPict("SA1","A1_NOME")           ,TamSX3("A1_NOME")         [1]+2)
	TRCell():New(oSection1,"A15",,"C๓d. Vend 1"                ,PesqPict("SC5","C5_VEND1")          ,TamSX3("C5_VEND1")        [1]+2)
	TRCell():New(oSection1,"A16",,"Nome Vendedor 1"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")         [1]+2)
	TRCell():New(oSection1,"A17",,"C๓d. Vend 2"                ,PesqPict("SC5","C5_VEND2")          ,TamSX3("C5_VEND2")        [1]+2)
	TRCell():New(oSection1,"A18",,"Nome Vendedor 2"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")         [1]+2)
	TRCell():New(oSection1,"A19",,"Oper."                      ,PesqPict("SC6","C6_OPER")           ,TamSX3("C6_OPER")         [1]+2)
	TRCell():New(oSection1,"A20",,"Descri็ใo Opera็ใo"         ,PesqPict("SX5","X5_DESCRI")         ,TamSX3("X5_DESCRI")       [1]+2)
		
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

	oBreak1 := TRBreak():New(oSection1,".T.","Totalizadores : ",.F.)
	TRFunction():New(oSection1:Cell("A4")      ,"","COUNT",oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A9")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A10")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A11")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  10/11/15   บฑฑ
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
	Local oSection1   := oReport:Section(1)
	//Local nX		    := 0
	//Local cQuery 	    := ""
	//Local cAlias 	    := "QRYTEMP0"
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
	oSection1:Cell("A16"):SetBlock( { || aDados1[16] } )
	oSection1:Cell("A17"):SetBlock( { || aDados1[17] } )
	oSection1:Cell("A18"):SetBlock( { || aDados1[18] } )
	oSection1:Cell("A19"):SetBlock( { || aDados1[19] } )
	oSection1:Cell("A20"):SetBlock( { || aDados1[20] } )
	
	oReport:SetTitle(_cTitulo)// Titulo do relat๓rio

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
			aDados1[03]	:= (cAlias1)->A3_EMISSAO
			aDados1[04]	:= (cAlias1)->A4_CODIGO
			aDados1[05]	:= (cAlias1)->A5_DESCRICAO
			aDados1[06]	:= (cAlias1)->A6_CLASSIFICACAO
			aDados1[07]	:= (cAlias1)->A7_GRUPO
			aDados1[08]	:= (cAlias1)->A8_DESCGRUPO
			aDados1[09]	:= (cAlias1)->A9_SALDO_PEDIDO
			aDados1[10]	:= (cAlias1)->A10_FALTA
			aDados1[11]	:= (cAlias1)->A11_RESERVA
			aDados1[12]	:= (cAlias1)->A12_COD_CLI
			aDados1[13]	:= (cAlias1)->A13_LJ_CLI
			aDados1[14]	:= (cAlias1)->A14_RAZAO_SOCIAL_CLIENTE
			aDados1[15]	:= (cAlias1)->A15_VEND1
			aDados1[16]	:= UPPER((cAlias1)->A16_NOME_VEND1)
			aDados1[17]	:= (cAlias1)->A17_VEND2
			aDados1[18]	:= UPPER((cAlias1)->A18_NOME_VEND2)
			aDados1[19]	:= (cAlias1)->A19_OPERACAO
			aDados1[20]	:= (cAlias1)->A20_DESCRI_OPERACAO

			oSection1:PrintLine()
		
			aFill(aDados1,nil)
			(cAlias1)->(dbskip())
		End
		
		oSection1:PrintTotal()
		oSection1:Finish()
	
		oReport:SkipLine()
	
		aFill(aDados1,nil)
	
		(cAlias1)->(dbCloseArea())
	Endif

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |StQuery  บAutor  ณJoใo Victor         บ Data ณ  10/11/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Query do Relat๓rio                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery1     := ' '

	cQuery1 := " SELECT
	cQuery1 += " C6_FILIAL  AS A1_FILIAL
	cQuery1 += ",C6_NUM     AS A2_PEDIDO
	cQuery1 += ",SUBSTR( C5_EMISSAO,7,2)||'/'|| SUBSTR( C5_EMISSAO,5,2)||'/'|| SUBSTR( C5_EMISSAO,1,4) AS A3_EMISSAO
	cQuery1 += ",C6_PRODUTO AS A4_CODIGO
	cQuery1 += ",B1_DESC    AS A5_DESCRICAO
	//cQuery1 += ",B1_CLAPROD AS A6_CLASSIFICACAO
	cQuery1 += ",CASE WHEN B1_CLAPROD = 'C' THEN 'COMPRADO'        ELSE
	cQuery1 += " CASE WHEN  B1_CLAPROD = 'I' THEN 'IMPORTADO'       ELSE
	cQuery1 += " CASE WHEN  B1_CLAPROD = 'F' THEN 'FABRICADO'       ELSE
	cQuery1 += " 'N/C' END END END  AS A6_CLASSIFICACAO
	cQuery1 += ",B1_GRUPO   AS A7_GRUPO
	cQuery1 += ",BM_DESC    AS A8_DESCGRUPO
	cQuery1 += ",(C6_QTDVEN - C6_QTDENT ) AS A9_SALDO_PEDIDO

	cQuery1 += ",NVL((SELECT SUM(PA1.PA1_QUANT)
	cQuery1 += " FROM  "+RetSqlName("PA1")+" PA1
	cQuery1 += " WHERE PA1.D_E_L_E_T_ = ' '
	cQuery1 += " AND   PA1.PA1_CODPRO = C6_PRODUTO
	cQuery1 += " AND   PA1.PA1_DOC    = C6_NUM||''||C6_ITEM
	cQuery1 += " AND   PA1.PA1_FILIAL = C6_FILIAL
	cQuery1 += " ),0)  AS A10_FALTA

	cQuery1 += ",NVL((SELECT SUM(PA2.PA2_QUANT)
	cQuery1 += " FROM  "+RetSqlName("PA2")+" PA2
	cQuery1 += " WHERE PA2.D_E_L_E_T_ = ' '
	cQuery1 += " AND   PA2.PA2_CODPRO = C6_PRODUTO
	cQuery1 += " AND   PA2.PA2_DOC    = C6_NUM||''||C6_ITEM
	cQuery1 += " AND   PA2.PA2_FILRES = C6_FILIAL
	cQuery1 += " ),0)  AS A11_RESERVA
	
	cQuery1 += ",C5_CLIENTE   AS A12_COD_CLI
	cQuery1 += ",C5_LOJACLI   AS A13_LJ_CLI
	cQuery1 += ",A1_NOME      AS A14_RAZAO_SOCIAL_CLIENTE
	cQuery1 += ",C5_VEND1     AS A15_VEND1
	cQuery1 += ",SA31.A3_NOME AS A16_NOME_VEND1
	cQuery1 += ",C5_VEND2     AS A17_VEND2
	cQuery1 += ",SA32.A3_NOME AS A18_NOME_VEND2
	cQuery1 += ",C6_OPER      AS A19_OPERACAO
	cQuery1 += ",X5_DESCRI    AS A20_DESCRI_OPERACAO

	cQuery1 += " FROM "+RetSqlName("SC6")+" TC6

	cQuery1 += " INNER JOIN "+RetSqlName("SC5")+" TC5
	cQuery1 += " ON C5_NUM = C6_NUM
	cQuery1 += " AND C5_FILIAL = C6_FILIAL
	cQuery1 += " AND TC5.D_E_L_E_T_ = ' '

	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" TB1
	cQuery1 += " ON B1_COD = C6_PRODUTO
	cQuery1 += " AND TB1.D_E_L_E_T_ = ' '

	cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" TA1
	cQuery1 += " ON A1_COD = C5_CLIENTE
	cQuery1 += " AND A1_LOJA = C5_LOJACLI
	cQuery1 += " AND TA1.D_E_L_E_T_ = ' '

	cQuery1 += " LEFT JOIN "+RetSqlName("SBM")+" SBM
	cQuery1 += " ON SBM.D_E_L_E_T_ = ' '
	cQuery1 += " AND B1_GRUPO = BM_GRUPO

	cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA31
	cQuery1 += " ON SA31.D_E_L_E_T_ = ' '
	cQuery1 += " AND C5_VEND1 = SA31.A3_COD

	cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA32
	cQuery1 += " ON SA32.D_E_L_E_T_ = ' '
	cQuery1 += " AND C5_VEND2 = SA32.A3_COD

	cQuery1 += " LEFT JOIN "+RetSqlName("SX5")+" SX5
	cQuery1 += " ON SX5.D_E_L_E_T_ = ' '
	cQuery1 += " AND C6_OPER = X5_CHAVE
	cQuery1 += " AND X5_TABELA = 'DJ'

	cQuery1 += " WHERE TC6.D_E_L_E_T_ = ' '
	cQuery1 += " AND C6_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery1 += " AND B1_COD     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery1 += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'
	DO CASE
	CASE MV_PAR07=1
		_cClaprod := 'C'
	CASE MV_PAR07=2
		_cClaprod := 'I'
	CASE MV_PAR07=3
		_cClaprod := 'F'
	ENDCASE
	If !(MV_PAR07=4)
		cQuery1 += " AND B1_CLAPROD = '"+_cClaprod+"'
	Endif
	//cQuery1 += " AND C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery1 += " AND A1_GRPVEN <> 'ST'
	cQuery1 += " AND A1_EST    <> 'EX'
	cQuery1 += " AND C5_TIPO = 'N'
	cQuery1 += " AND C5_NOTA NOT LIKE '%XXX%'
	cQuery1 += " AND C6_BLQ <> 'R'
	cQuery1 += " AND (C6_QTDVEN - C6_QTDENT ) > 0

	cQuery1 += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM


	//cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return()
