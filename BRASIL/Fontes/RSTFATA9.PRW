#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RSTFATA9  ºAutor  ³João Victor         º Data ³  10/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório Relação de Fatec's Emitidas                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATA9()

	Local   oReport
	Private cPerg 		:= "RFATA9"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private cAlias1      := cAliasLif
	Private _cTitulo     := "Relatório Relação de Fatec's Emitidas"
	Private _cDescri     := "Este programa irá imprimir um relatório com a Relação de Fatec's Emitidas"
	Private _cSection1   := "Relação de Fatec's Emitidas"
	
	Private _cPerg01     := "Motivo De: ?"
	Private _cPerg02     := "Motivo Até: ?"
	Private _cPerg03     := "Fatec De: ?"
	Private _cPerg04     := "Fatec Até: ?"
	Private _cPerg05     := "Emissão De: ?"
	Private _cPerg06     := "Emissão Até: ?"
	Private _cPerg07     := "Tipo Vendedor: ?"
	Private _cPerg08     := "Vendedor De: ?"
	Private _cPerg09     := "Vendedor Até: ?"

	Private _nTam01      := 03
	Private _nTam02      := 03
	Private _nTam03      := TamSX3("PC1_NUMERO")[1]
	Private _nTam04      := TamSX3("PC1_NUMERO")[1]
	Private _nTam05      := TamSX3("PC1_DTOCOR")[1]
	Private _nTam06      := TamSX3("PC1_DTOCOR")[1]
	Private _nTam07      := 01
	Private _nTam08      := TamSX3("A3_COD")[1]
	Private _nTam09      := TamSX3("A3_COD")[1]
	
	Private aHelp1       := {}
	Private aHelp2       := {}
	Private aHelp3       := {}
	Private aHelp4       := {}
	Private aHelp5       := {}

	Private _aRet 		:= {}
	Private _aParamBox 	:= {}
	Private _aCombo      := {"Analítico","Sinético"}

	AADD(_aParamBox,{2,"Tipo de Análise: ",,_aCombo,50,"",.T.})

	ParamBox(_aParamBox,"Tipo de Análise: ",@_aRet,,,.T.,,500)
	If !Len(_aRet) > 0
		Aviso("Tipo de Análise","Favor selecionar um Tipo de Análise...!!!"+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"O Relatório não será emitido...!!!",;
			{"OK"},3)
		Return
	Else
		_cTitulo := _cTitulo + " - " + _aRet[1]
	Endif

	Aadd(aHelp1, "Informe o Motivo Desejado               " )
	Aadd(aHelp2, "Informe o Número da Fatec Desejada      " )
	Aadd(aHelp3, "Informe a Data de Emissão da Fatec      " )
	Aadd(aHelp4, "Informe os dados do Vendedor            " )
	Aadd(aHelp5, "Informe o Tipo de Análise a ser processada" )
	
	//-------cGrupo,cOrdem,cPergunt      ,cPergSpa      ,cPergEng      ,cVar        ,cTipo ,nTamanho ,nDecimal,nPreSel,cGSC,cValid,cF3     ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01                ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	//tSx1(cPerg   ,"01"  ,"Filial ?"    ,"Filial ?"    ,"Filial ?"    ,"mv_ch1"    ,"C"   ,02       ,0       ,0      ,"G" ,""    ,"SM0"   ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"  ,_cPerg01      ,_cPerg01      ,_cPerg01      ,"mv_ch1"    ,"C"   ,_nTam01  ,0       ,0      ,"G" ,""    ,"SK"    ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(_nTam01)        ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"02"  ,_cPerg02      ,_cPerg02      ,_cPerg02      ,"mv_ch2"    ,"C"   ,_nTam02  ,0       ,0      ,"G" ,""    ,"SK"    ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",_nTam02),""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"03"  ,_cPerg03      ,_cPerg03      ,_cPerg03      ,"mv_ch3"    ,"C"   ,_nTam03  ,0       ,0      ,"G" ,""    ,"PC1FSW",""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(_nTam03)        ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp2  ,aHelp2  ,aHelp2)
	PutSx1(cPerg   ,"04"  ,_cPerg04      ,_cPerg04      ,_cPerg04      ,"mv_ch4"    ,"C"   ,_nTam04  ,0       ,0      ,"G" ,""    ,"PC1FSW",""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Replicate("Z",_nTam04),""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp2  ,aHelp2  ,aHelp2)
	PutSx1(cPerg   ,"05"  ,_cPerg05      ,_cPerg05      ,_cPerg05      ,"mv_ch5"    ,"D"   ,_nTam05  ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp3  ,aHelp3  ,aHelp3)
	PutSx1(cPerg   ,"06"  ,_cPerg06      ,_cPerg06      ,_cPerg06      ,"mv_ch6"    ,"D"   ,_nTam05  ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par06"    ,""                ,""      ,""      ,Dtoc(dDatabase)       ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp3  ,aHelp3  ,aHelp3)
	PutSx1(cPerg   ,"07"  ,_cPerg07      ,_cPerg07      ,_cPerg07      ,"mv_ch7"    ,"C"   ,_nTam06  ,0       ,0      ,"C" ,""    ,""      ,""     ,"S"  ,"mv_par07"    ,"Externo"         ,""      ,""      ,""                    ,"Interno"          ,""        ,""      ,"Ambos"        ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp4  ,aHelp4  ,aHelp4)
	PutSx1(cPerg   ,"08"  ,_cPerg08      ,_cPerg08      ,_cPerg08      ,"mv_ch8"    ,"C"   ,_nTam08  ,0       ,0      ,"G" ,""    ,"SA3"   ,""     ,"S"  ,"mv_par08"    ,""                ,""      ,""      ,Space(_nTam08)        ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp4  ,aHelp4  ,aHelp4)
	PutSx1(cPerg   ,"09"  ,_cPerg09      ,_cPerg09      ,_cPerg09      ,"mv_ch9"    ,"C"   ,_nTam09  ,0       ,0      ,"G" ,""    ,"SA3"   ,""     ,"S"  ,"mv_par09"    ,""                ,""      ,""      ,Replicate("Z",_nTam09),""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp4  ,aHelp4  ,aHelp4)

	oReport		:= ReportDef()
	 oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportDef ºAutor  ³João Victor         º Data ³  10/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cabeçalho do Relatório                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
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
	
	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 6

	Pergunte(cPerg,.F.)
	//Primeira Seção
	oSection1 := TRSection():New(oReport,_cSection1,{cAlias1})
	//Analítico
	If _aRet[1]==_aCombo[1]
		TRCell():New(oSection1,"A1" ,,"Fatec"                      ,PesqPict("PC1","PC1_NUMERO")        ,TamSX3("PC1_NUMERO")   [1]+2)
		TRCell():New(oSection1,"A2" ,,"Atendente"                  ,PesqPict("PC1","PC1_ATENDE")        ,TamSX3("PC1_ATENDE")   [1]+2)
		TRCell():New(oSection1,"A3" ,,"Dt. Emissão"                ,PesqPict("PC1","PC1_DTOCOR")        ,TamSX3("PC1_DTOCOR")   [1]+2)
		TRCell():New(oSection1,"A4" ,,"Descr. Motivo"              ,PesqPict("SX5","X5_DESCRI")         ,TamSX3("X5_DESCRI")    [1]+2)
		TRCell():New(oSection1,"A5" ,,"Status"                     ,PesqPict("PC1","PC1_STATUS")        ,TamSX3("PC1_STATUS")   [1]+2)
		TRCell():New(oSection1,"A6" ,,"Filial NF"                  ,PesqPict("SF2","F2_FILIAL")         ,TamSX3("F2_FILIAL")    [1]+2)
		TRCell():New(oSection1,"A7" ,,"Nota Fiscal"                ,PesqPict("SF2","F2_DOC")            ,TamSX3("F2_DOC")       [1]+2)
		TRCell():New(oSection1,"A8" ,,"Dt. Emissão NF"             ,PesqPict("SF2","F2_EMISSAO")        ,TamSX3("F2_EMISSAO")   [1]+2)
		TRCell():New(oSection1,"A9" ,,"Cliente"                    ,PesqPict("SF2","F2_CLIENTE")        ,TamSX3("F2_CLIENTE")   [1]+2)
		TRCell():New(oSection1,"A10",,"Lj"                         ,PesqPict("SF2","F2_LOJA")           ,TamSX3("F2_LOJA")      [1]+2)
		TRCell():New(oSection1,"A11",,"Razão Social"               ,PesqPict("SA1","A1_NOME")           ,TamSX3("A1_NOME")      [1]+2)
		TRCell():New(oSection1,"A12",,"Cód. Vend 1"                ,PesqPict("SF2","F2_VEND1")          ,TamSX3("F2_VEND1")     [1]+2)
		TRCell():New(oSection1,"A13",,"Nome Vendedor 1"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")      [1]+2)
		TRCell():New(oSection1,"A14",,"Cód. Vend 2"                ,PesqPict("SF2","F2_VEND2")          ,TamSX3("F2_VEND2")     [1]+2)
		TRCell():New(oSection1,"A15",,"Nome Vendedor 2"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")      [1]+2)
		TRCell():New(oSection1,"A16",,"Qtde Referências"           ,PesqPict("PC2","PC2_QTDNFS")        ,TamSX3("PC2_QTDNFS")   [1]+2)
		TRCell():New(oSection1,"A17",,"Qtde Vendida"               ,PesqPict("PC2","PC2_QTDNFS")        ,TamSX3("PC2_QTDNFS")   [1]+2)
		TRCell():New(oSection1,"A18",,"Qtde Fatec"                 ,PesqPict("PC2","PC2_QTDFAT")        ,TamSX3("PC2_QTDFAT")   [1]+2)
		TRCell():New(oSection1,"A19",,"Vlr Fatec"                  ,PesqPict("PC2","PC2_QTDFAT")        ,TamSX3("PC2_QTDFAT")   [1]+2)
		TRCell():New(oSection1,"A20",,"Qtde Efetivo"               ,PesqPict("SD1","D1_QUANT")          ,TamSX3("D1_QUANT")     [1]+2)
		TRCell():New(oSection1,"A21",,"Vlr Efetivo"                ,PesqPict("SD1","D1_QUANT")          ,TamSX3("D1_QUANT")     [1]+2)

		oSection1:SetHeaderSection(.T.)
		oSection1:Setnofilter(cAlias1)
		oSection1:SetTotalInLine(.F.)

		oBreak1 := TRBreak():New(oSection1,".T.","Totalizadores : ",.F.)
		TRFunction():New(oSection1:Cell("A5" )      ,"","COUNT",oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A16")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A17")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A18")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A19")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A20")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A21")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	//Sintético
	ElseIf _aRet[1]==_aCombo[2]
		TRCell():New(oSection1,"A1" ,,"Cód. Vend 1"                ,PesqPict("SF2","F2_VEND1")          ,TamSX3("F2_VEND1")     [1]+2)
		TRCell():New(oSection1,"A2" ,,"Nome Vendedor 1"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")      [1]+2)
		TRCell():New(oSection1,"A3" ,,"Cód. Vend 2"                ,PesqPict("SF2","F2_VEND2")          ,TamSX3("F2_VEND2")     [1]+2)
		TRCell():New(oSection1,"A4" ,,"Nome Vendedor 2"            ,PesqPict("SA3","A3_NOME")           ,TamSX3("A3_NOME")      [1]+2)
		TRCell():New(oSection1,"A5" ,,"Descr. Motivo"              ,PesqPict("SX5","X5_DESCRI")         ,TamSX3("X5_DESCRI")    [1]+2)
		TRCell():New(oSection1,"A6" ,,"Status"                     ,PesqPict("PC1","PC1_STATUS")        ,TamSX3("PC1_STATUS")   [1]+2)
		TRCell():New(oSection1,"A7" ,,"Qtde Referências"           ,PesqPict("PC2","PC2_QTDNFS")        ,TamSX3("PC2_QTDNFS")   [1]+2)
		TRCell():New(oSection1,"A8" ,,"Qtde Vendida"               ,PesqPict("PC2","PC2_QTDNFS")        ,TamSX3("PC2_QTDNFS")   [1]+2)
		TRCell():New(oSection1,"A9" ,,"Qtde Fatec"                 ,PesqPict("PC2","PC2_QTDFAT")        ,TamSX3("PC2_QTDFAT")   [1]+2)
		TRCell():New(oSection1,"A10",,"Vlr Fatec"                  ,PesqPict("PC2","PC2_QTDFAT")        ,TamSX3("PC2_QTDFAT")   [1]+2)
		TRCell():New(oSection1,"A11",,"Qtde Efetivo"               ,PesqPict("SD1","D1_QUANT")          ,TamSX3("D1_QUANT")     [1]+2)
		TRCell():New(oSection1,"A12",,"Vlr Efetivo"                ,PesqPict("SD1","D1_QUANT")          ,TamSX3("D1_QUANT")     [1]+2)

		oSection1:SetHeaderSection(.T.)
		oSection1:Setnofilter(cAlias1)
		oSection1:SetTotalInLine(.F.)

		oBreak1 := TRBreak():New(oSection1,".T.","Totalizadores : ",.F.)
		TRFunction():New(oSection1:Cell("A6")       ,"","COUNT",oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A7")       ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A8")       ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A9")       ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A10")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A11")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("A12")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	Endif


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³João Victor         º Data ³  10/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Itens do Relatório                                         º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	//Analítico
	If _aRet[1]==_aCombo[1]
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
		oSection1:Cell("A21"):SetBlock( { || aDados1[21] } )
	
		oReport:SetTitle(_cTitulo)// Titulo do relatório

		oReport:SetMeter(0)
		aFill(aDados,nil)
		aFill(aDados1,nil)
		oSection1:Init()

		Processa({|| StQuery(  ) },"Compondo Relatório")

		DbSelectArea(cAlias1)
		(cAlias1)->(DbGoTop())
		If  Select(cAlias1) > 0
			While 	(cAlias1)->(!Eof())
		

				aDados1[01]	:= (cAlias1)->A1_NUMERO_FATEC
				aDados1[02]	:= UPPER((cAlias1)->A2_ATENDENTE_FATEC)
				aDados1[03]	:= (cAlias1)->A3_DT_EMISSAO_FATEC
				aDados1[04]	:= (cAlias1)->A4_DESCR_MOTIVO
				aDados1[05]	:= (cAlias1)->A5_DESCR_STATUS
				aDados1[06]	:= (cAlias1)->A6_FILIAL
				aDados1[07]	:= (cAlias1)->A7_NOTA_FISCAL_STECK
				aDados1[08]	:= (cAlias1)->A8_DT_EMISSAO_NF
				aDados1[09]	:= (cAlias1)->A9_COD_CLIENTE
				aDados1[10]	:= (cAlias1)->A10_LOJA_CLIENTE
				aDados1[11]	:= (cAlias1)->A11_RAZAO_SOCIAL
				aDados1[12]	:= (cAlias1)->A12_VENDEDOR_1
				aDados1[13]	:= UPPER((cAlias1)->A13_NOME_VEND1)
				aDados1[14]	:= (cAlias1)->A14_VENDEDOR_2
				aDados1[15]	:= UPPER((cAlias1)->A15_NOME_VEND2)
				aDados1[16]	:= (cAlias1)->A16_QTDE_PRODUTOS
				aDados1[17]	:= (cAlias1)->A17_QTD_VENDIDA
				aDados1[18]	:= (cAlias1)->A18_QTD_DEVOLVIDA
				aDados1[19]	:= (cAlias1)->A19_VLR_DEVOLVIDO
				aDados1[20]	:= (cAlias1)->A20_QTD_EFETIVA
				aDados1[21]	:= (cAlias1)->A21_VLR_EFETIVO

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

	//Sintético
	ElseIf _aRet[1]==_aCombo[2]
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

		oReport:SetTitle(_cTitulo)// Titulo do relatório

		oReport:SetMeter(0)
		aFill(aDados,nil)
		aFill(aDados1,nil)
		oSection1:Init()

		Processa({|| StQuery(  ) },"Compondo Relatório")

		DbSelectArea(cAlias1)
		(cAlias1)->(DbGoTop())
		If  Select(cAlias1) > 0
			While 	(cAlias1)->(!Eof())
		

				aDados1[01]	:= (cAlias1)->A1_VENDEDOR_1
				aDados1[02]	:= UPPER((cAlias1)->A2_NOME_VEND1)
				aDados1[03]	:= (cAlias1)->A3_VENDEDOR_2
				aDados1[04]	:= UPPER((cAlias1)->A4_NOME_VEND2)
				aDados1[05]	:= (cAlias1)->A5_DESCR_MOTIVO
				aDados1[06]	:= (cAlias1)->A6_DESCR_STATUS
				aDados1[07]	:= (cAlias1)->A7_QTDE_PRODUTOS
				aDados1[08]	:= (cAlias1)->A8_QTD_VENDIDA
				aDados1[09]	:= (cAlias1)->A9_QTD_DEVOLVIDA
				aDados1[10]	:= (cAlias1)->A10_VLR_DEVOLVIDO
				aDados1[11]	:= (cAlias1)->A11_QTD_EFETIVA
				aDados1[12]	:= (cAlias1)->A12_VLR_EFETIVO

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

	Endif


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |StQuery  ºAutor  ³João Victor         º Data ³  10/11/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Query do Relatório                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery1     := ' '
	//Analítico
	If _aRet[1]==_aCombo[1]
		cQuery1 := "  SELECT
		cQuery1 += "  PC1_NUMERO AS A1_NUMERO_FATEC
		cQuery1 += " ,PC1_ATENDE AS A2_ATENDENTE_FATEC
		cQuery1 += " ,SUBSTR( PC1_DTOCOR,7,2)||'/'|| SUBSTR( PC1_DTOCOR,5,2)||'/'|| SUBSTR( PC1_DTOCOR,1,4) AS A3_DT_EMISSAO_FATEC
		cQuery1 += " ,X5_DESCRI  AS A4_DESCR_MOTIVO
		cQuery1 += " ,CASE WHEN PC1_STATUS = ' '  THEN 'EM ABERTO'  ELSE
		cQuery1 += "  CASE WHEN PC1_STATUS = '1'  THEN 'EM ABERTO'  ELSE
		cQuery1 += "  CASE WHEN PC1_STATUS = '2'  THEN 'AUTORIZADO' ELSE
		cQuery1 += "  CASE WHEN PC1_STATUS = '3'  THEN 'RECEBIDO'   ELSE
		cQuery1 += "  CASE WHEN PC1_STATUS = '4'  THEN 'ATENDIMENTO SEM DEVOLUÇÃO' ELSE
		cQuery1 += "  CASE WHEN PC1_STATUS = '5'  THEN 'ENCERRADO'  ELSE
		cQuery1 += " 'SEM STATUS' END END END END END END A5_DESCR_STATUS
		cQuery1 += " ,F2_FILIAL  AS A6_FILIAL
		cQuery1 += " ,F2_DOC     AS A7_NOTA_FISCAL_STECK
		cQuery1 += " ,SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4) AS A8_DT_EMISSAO_NF
		cQuery1 += " ,F2_CLIENTE   AS A9_COD_CLIENTE
		cQuery1 += " ,F2_LOJA      AS A10_LOJA_CLIENTE
		cQuery1 += " ,A1_NOME      AS A11_RAZAO_SOCIAL
		cQuery1 += " ,F2_VEND1     AS A12_VENDEDOR_1
		cQuery1 += " ,SA31.A3_NOME AS A13_NOME_VEND1
		cQuery1 += " ,F2_VEND2     AS A14_VENDEDOR_2
		cQuery1 += " ,SA32.A3_NOME AS A15_NOME_VEND2
		cQuery1 += " ,COUNT(PC2_PRODUT) AS A16_QTDE_PRODUTOS
		cQuery1 += " ,SUM (PC2_QTDNFS)  AS A17_QTD_VENDIDA
		cQuery1 += " ,SUM (PC2_QTDFAT)  AS A18_QTD_DEVOLVIDA
		cQuery1 += " ,SUM (PC2_QTDFAT*D2_PRCVEN) AS A19_VLR_DEVOLVIDO
		cQuery1 += " ,SUM (D1_QUANT)   AS A20_QTD_EFETIVA
		cQuery1 += " ,SUM (D1_QUANT*D1_VUNIT) AS A21_VLR_EFETIVO

		cQuery1 += " FROM "+RetSqlName("PC2")+" TC2

		cQuery1 += " INNER JOIN "+RetSqlName("PC1")+" PC1
		cQuery1 += " ON  PC1.D_E_L_E_T_ = ' '
		cQuery1 += " AND PC1_FILIAL = PC2_FILIAL
		cQuery1 += " AND PC1_NUMERO = PC2_NFATEC

		cQuery1 += " LEFT JOIN "+RetSqlName("SX5")+" SX5
		cQuery1 += " ON  SX5.D_E_L_E_T_ = ' '
		cQuery1 += " AND X5_TABELA            = 'SK'
		cQuery1 += " AND SUBSTR(X5_CHAVE,1,3) = PC1_MOTIVO

		cQuery1 += " INNER JOIN "+RetSqlName("SD2")+" SD2
		cQuery1 += " ON SD2.D_E_L_E_T_ = ' '
		cQuery1 += " AND D2_DOC     = PC2_NFORIG
		cQuery1 += " AND D2_SERIE   = PC2_SERIE
		cQuery1 += " AND D2_COD     = PC2_PRODUT
		cQuery1 += " AND D2_ITEM    = PC2_ITEM
		cQuery1 += " AND D2_CLIENTE = PC1_CODCLI
		cQuery1 += " AND D2_LOJA    = PC1_LOJA

		cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" TA1
		cQuery1 += " ON  TA1.D_E_L_E_T_ = ' '
		cQuery1 += " AND A1_COD  = PC1_CODCLI
		cQuery1 += " AND A1_LOJA = PC1_LOJA

		cQuery1 += " LEFT JOIN "+RetSqlName("SD1")+" TD1
		cQuery1 += " ON  TD1.D_E_L_E_T_ = ' '
		cQuery1 += " AND D1_XFATEC = PC2_NFATEC
		cQuery1 += " AND D1_COD    = PC2_PRODUT
		cQuery1 += " AND D1_TIPO   = 'D'

		cQuery1 += " INNER JOIN "+RetSqlName("SF2")+" SF2
		cQuery1 += " ON  SF2.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_DOC     = PC2_NFORIG
		cQuery1 += " AND F2_SERIE   = PC2_SERIE
		cQuery1 += " AND F2_CLIENTE = PC1_CODCLI
		cQuery1 += " AND F2_LOJA    = PC1_LOJA

		cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA31
		cQuery1 += " ON SA31.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_VEND1 = SA31.A3_COD

		cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA32
		cQuery1 += " ON SA32.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_VEND2 = SA32.A3_COD

		cQuery1 += " WHERE TC2.D_E_L_E_T_ = ' '
		cQuery1 += " AND PC1_MOTIVO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
		cQuery1 += " AND PC2_NFATEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
		cQuery1 += " AND PC1_DTOCOR BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'
		If MV_PAR07 == 1
			cQuery1 += " AND F2_VEND1   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
		ElseIf MV_PAR07 == 2
			cQuery1 += " AND F2_VEND2   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
		ElseIf MV_PAR07 == 3
			cQuery1 += " AND (F2_VEND1  BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' OR F2_VEND2   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"')
		Endif
		cQuery1 += " GROUP BY
		cQuery1 += " PC1_NUMERO
		cQuery1 += " ,PC1_ATENDE
		cQuery1 += " ,SUBSTR( PC1_DTOCOR,7,2)||'/'|| SUBSTR( PC1_DTOCOR,5,2)||'/'|| SUBSTR( PC1_DTOCOR,1,4)
		cQuery1 += " ,X5_DESCRI
		cQuery1 += " ,PC1_STATUS
		cQuery1 += " ,F2_FILIAL
		cQuery1 += " ,F2_DOC
		cQuery1 += " ,SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4)
		cQuery1 += " ,F2_CLIENTE
		cQuery1 += " ,F2_LOJA
		cQuery1 += " ,A1_NOME
		cQuery1 += " ,F2_VEND1
		cQuery1 += " ,SA31.A3_NOME
		cQuery1 += " ,F2_VEND2
		cQuery1 += " ,SA32.A3_NOME

		cQuery1 += " ORDER BY SUBSTR( PC1_DTOCOR,7,2)||'/'|| SUBSTR( PC1_DTOCOR,5,2)||'/'|| SUBSTR( PC1_DTOCOR,1,4)
	//Sintético
	ElseIf _aRet[1]==_aCombo[2]
		cQuery1 := " SELECT
		cQuery1 += " F2_VEND1      AS A1_VENDEDOR_1
		cQuery1 += " ,SA31.A3_NOME AS A2_NOME_VEND1
		cQuery1 += " ,F2_VEND2     AS A3_VENDEDOR_2
		cQuery1 += " ,SA32.A3_NOME AS A4_NOME_VEND2
		cQuery1 += " ,X5_DESCRI    AS A5_DESCR_MOTIVO
		cQuery1 += " ,CASE WHEN PC1_STATUS = ' ' THEN 'EM ABERTO'  ELSE
		cQuery1 += " CASE WHEN PC1_STATUS = '1'  THEN 'EM ABERTO'  ELSE
		cQuery1 += " CASE WHEN PC1_STATUS = '2'  THEN 'AUTORIZADO' ELSE
		cQuery1 += " CASE WHEN PC1_STATUS = '3'  THEN 'RECEBIDO'   ELSE
		cQuery1 += " CASE WHEN PC1_STATUS = '4'  THEN 'ATENDIMENTO SEM DEVOLUÇÃO' ELSE
		cQuery1 += " CASE WHEN PC1_STATUS = '5'  THEN 'ENCERRADO'  ELSE
		cQuery1 += " 'SEM STATUS' END END END END END END AS A6_DESCR_STATUS
		cQuery1 += " ,COUNT(PC2_PRODUT) AS A7_QTDE_PRODUTOS
		cQuery1 += " ,SUM (PC2_QTDNFS)  AS A8_QTD_VENDIDA
		cQuery1 += " ,SUM (PC2_QTDFAT)  AS A9_QTD_DEVOLVIDA
		cQuery1 += " ,SUM (PC2_QTDFAT*D2_PRCVEN) AS A10_VLR_DEVOLVIDO
		cQuery1 += " ,SUM (D1_QUANT)    AS A11_QTD_EFETIVA
		cQuery1 += " ,SUM (D1_QUANT*D1_VUNIT) AS A12_VLR_EFETIVO

		cQuery1 += " FROM "+RetSqlName("PC2")+" TC2

		cQuery1 += " INNER JOIN "+RetSqlName("PC1")+" PC1
		cQuery1 += " ON PC1.D_E_L_E_T_ = ' '
		cQuery1 += " AND PC1_FILIAL = PC2_FILIAL
		cQuery1 += " AND PC1_NUMERO = PC2_NFATEC

		cQuery1 += " LEFT JOIN "+RetSqlName("SX5")+" SX5
		cQuery1 += " ON SX5.D_E_L_E_T_ = ' '
		cQuery1 += " AND  X5_TABELA           = 'SK'
		cQuery1 += " AND SUBSTR(X5_CHAVE,1,3) = PC1_MOTIVO

		cQuery1 += " INNER JOIN "+RetSqlName("SD2")+" SD2
		cQuery1 += " ON SD2.D_E_L_E_T_ = ' '
		cQuery1 += " AND D2_DOC     = PC2_NFORIG
		cQuery1 += " AND D2_SERIE   = PC2_SERIE
		cQuery1 += " AND D2_COD     = PC2_PRODUT
		cQuery1 += " AND D2_ITEM    = PC2_ITEM
		cQuery1 += " AND D2_CLIENTE = PC1_CODCLI
		cQuery1 += " AND D2_LOJA    = PC1_LOJA

		cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" TA1
		cQuery1 += " ON  TA1.D_E_L_E_T_ = ' '
		cQuery1 += " AND A1_COD  = PC1_CODCLI
		cQuery1 += " AND A1_LOJA = PC1_LOJA

		cQuery1 += " LEFT JOIN "+RetSqlName("SD1")+" TD1
		cQuery1 += " ON  TD1.D_E_L_E_T_ = ' '
		cQuery1 += " AND D1_XFATEC = PC2_NFATEC
		cQuery1 += " AND D1_COD    = PC2_PRODUT
		cQuery1 += " AND D1_TIPO   = 'D'

		cQuery1 += " INNER JOIN "+RetSqlName("SF2")+" SF2
		cQuery1 += " ON  SF2.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_DOC = PC2_NFORIG
		cQuery1 += " AND F2_SERIE = PC2_SERIE
		cQuery1 += " AND F2_CLIENTE = PC1_CODCLI
		cQuery1 += " AND F2_LOJA = PC1_LOJA

		cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA31
		cQuery1 += " ON SA31.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_VEND1 = SA31.A3_COD

		cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" SA32
		cQuery1 += " ON SA32.D_E_L_E_T_ = ' '
		cQuery1 += " AND F2_VEND2 = SA32.A3_COD

		cQuery1 += " WHERE TC2.D_E_L_E_T_ = ' '
		cQuery1 += " AND PC1_MOTIVO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
		cQuery1 += " AND PC2_NFATEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
		cQuery1 += " AND PC1_DTOCOR BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'
		If MV_PAR07 == 1
			cQuery1 += " AND F2_VEND1   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
		ElseIf MV_PAR07 == 2
			cQuery1 += " AND F2_VEND2   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
		ElseIf MV_PAR07 == 3
			cQuery1 += " AND (F2_VEND1  BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' OR F2_VEND2   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"')
		Endif

		cQuery1 += " GROUP BY
		cQuery1 += " F2_VEND1
		cQuery1 += " ,SA31.A3_NOME
		cQuery1 += " ,F2_VEND2
		cQuery1 += " ,SA32.A3_NOME
		cQuery1 += " ,X5_DESCRI
		cQuery1 += " ,PC1_STATUS

		cQuery1 += " ORDER BY F2_VEND1,F2_VEND2

	Endif

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return()
