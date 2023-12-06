#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RSTFAT90  ºAutor  ³João Victor         º Data ³  11/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório para listar Movimentação de Produtos - Entradas º±±
±±º          ³  e Saídas Mês a Mês                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT90()
	*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFAT90"
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
	
	
	
	//-------cGrupo,cOrdem,cPergunt                ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	//tSx1(cPerg   ,"01"  ,"Filial ?"              ,"Filial ?"                 ,"Filial ?"                   ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"  ,"Filial De: ?"          ,"Filial De: ?"             ,"Filial De: ?"               ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(2)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"  ,"Filial Até: ?"         ,"Filial Até: ?"            ,"Filial Até: ?"              ,"mv_ch2"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",2)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"03"  ,"Produto De: ?"         ,"Produto De: ?"            ,"Produto De: ?"              ,"mv_ch3"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(15)            ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"04"  ,"Produto Até: ?"        ,"Produto Até: ?"           ,"Produto Até: ?"             ,"mv_ch4"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Replicate("Z",15)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"05"  ,"Tipo De: ?"            ,"Tipo De: ?"               ,"Tipo De: ?"                 ,"mv_ch5"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"02"  ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,Space(2)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"06"  ,"Tipo Até: ?"           ,"Tipo Até: ?"              ,"Tipo Até: ?"                ,"mv_ch6"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"02"  ,""     ,"S"  ,"mv_par06"    ,""                ,""      ,""      ,Replicate("Z",2)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"07"  ,"Grupo De: ?"           ,"Grupo De: ?"              ,"Grupo De: ?"                ,"mv_ch7"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par07"    ,""                ,""      ,""      ,Space(4)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"08"  ,"Grupo Até: ?"          ,"Grupo Até: ?"             ,"Grupo Até: ?"               ,"mv_ch8"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par08"    ,""                ,""      ,""      ,Replicate("Z",4)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"09"  ,"Armazém De: ?"         ,"Armazém De: ?"            ,"Armazém De: ?"              ,"mv_ch9"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par09"    ,""                ,""      ,""      ,Space(2)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"10"  ,"Armazém Até: ?"        ,"Armazém Até: ?"           ,"Armazém Até: ?"             ,"mv_chA"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par10"    ,""                ,""      ,""      ,Replicate("Z",2)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"11"  ,"Ano: ?"                ,"Ano: ?"                   ,"Ano: ?"                     ,"mv_chB"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par11"    ,""                ,""      ,""      ,'2015'               ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportDef ºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cabeçalho do Relatório  		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection1
	
	oReport := TReport():New(cPergTit,"Movimentação de Produtos - Entradas e Saídas Mês a Mês",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir as informações relacionadas às Movimentação de Produtos - Entradas e Saídas Mês a Mês conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 6
	
	Pergunte(cPerg,.F.)
	
	
	//Primeira Seção
	oSection1 := TRSection():New(oReport,"Movimentação de Produtos - Entradas e Saídas Mês a Mês",{cAlias1,cAlias2})
	TRCell():New(oSection1,"A1" ,,"Código"             ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection1,"A2" ,,"Descrição Prod."    ,PesqPict("SB1","B1_DESC")        ,TamSX3("B1_DESC")      [1]+2)
	TRCell():New(oSection1,"A3" ,,"Tipo"               ,PesqPict("SB1","B1_TIPO")        ,TamSX3("B1_TIPO")      [1]+2)
	TRCell():New(oSection1,"A4" ,,"Grupo"              ,PesqPict("SB1","B1_GRUPO")       ,TamSX3("B1_GRUPO")     [1]+2)
	TRCell():New(oSection1,"A5" ,,"Descrição Grupo"    ,PesqPict("SBM","BM_DESC")        ,TamSX3("BM_DESC")      [1]+2)
	TRCell():New(oSection1,"A6" ,,"Pos Saldo Atual"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A7" ,,"Entradas Mês 01"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A8" ,,"Saídas   Mês 01"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A9" ,,"Entradas Mês 02"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A10",,"Saídas   Mês 02"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A11",,"Entradas Mês 03"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A12",,"Saídas   Mês 03"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A13",,"Entradas Mês 04"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A14",,"Saídas   Mês 04"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A15",,"Entradas Mês 05"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A16",,"Saídas   Mês 05"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A17",,"Entradas Mês 06"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A18",,"Saídas   Mês 06"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A19",,"Entradas Mês 07"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A20",,"Saídas   Mês 07"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A21",,"Entradas Mês 08"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A22",,"Saídas   Mês 08"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A23",,"Entradas Mês 09"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A24",,"Saídas   Mês 09"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A25",,"Entradas Mês 10"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A26",,"Saídas   Mês 10"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A27",,"Entradas Mês 11"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A28",,"Saídas   Mês 11"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A29",,"Entradas Mês 12"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A30",,"Saídas   Mês 12"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A31",,"Total  Entradas"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A32",,"Total    Saídas"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)
	
	TRFunction():New(oSection1:Cell("A6") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A7") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A8") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A9") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A10"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A11"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A12"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A13"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A14"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A15"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A16"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A17"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A18"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A19"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A20"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A21"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A22"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A23"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A24"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A25"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A26"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A27"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A28"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A29"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A30"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A31"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A32"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³João Victor         º Data ³  12/03/15   º±±
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
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	
	
	If !Len(Alltrim(MV_PAR11)) = 4
		MsgStop("Favor informar um Ano Válido...!!!")
		Return
	Endif
	
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
	oSection1:Cell("A22"):SetBlock( { || aDados1[22] } )
	oSection1:Cell("A23"):SetBlock( { || aDados1[23] } )
	oSection1:Cell("A24"):SetBlock( { || aDados1[24] } )
	oSection1:Cell("A25"):SetBlock( { || aDados1[25] } )
	oSection1:Cell("A26"):SetBlock( { || aDados1[26] } )
	oSection1:Cell("A27"):SetBlock( { || aDados1[27] } )
	oSection1:Cell("A28"):SetBlock( { || aDados1[28] } )
	oSection1:Cell("A29"):SetBlock( { || aDados1[29] } )
	oSection1:Cell("A30"):SetBlock( { || aDados1[30] } )
	oSection1:Cell("A31"):SetBlock( { || aDados1[31] } )
	oSection1:Cell("A32"):SetBlock( { || aDados1[32] } )
	
	oReport:SetTitle("Movimentação de Produtos - Entradas e Saídas Mês a Mês")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection1:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatório")
	
	
	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		//DbSelectArea(cAlias2)
		//(cAlias2)->(DbGoTop())
		//If  Select(cAlias2) > 0
		While 	(cAlias1)->(!Eof())// .And. (cAlias2)->(!Eof())
			
			aDados1[01]	:= (cAlias1)->A1_CODIGO
			aDados1[02]	:= (cAlias1)->A2_DESCRICAO
			aDados1[03]	:= (cAlias1)->A3_TIPO
			aDados1[04]	:= (cAlias1)->A4_GRUPO
			aDados1[05]	:= (cAlias1)->A5_DESCGRUPO
			aDados1[06]	:= (cAlias1)->A6_SALDO_ATUAL
			
			aDados1[07]	:= (cAlias1)->B1_ENTRADA_NF_JANEIRO   + (cAlias1)->C1_ENTRADA_SD3_JANEIRO
			aDados1[08]	:= (cAlias1)->E1_SAIDA_NF_JANEIRO     + (cAlias1)->D1_SAIDA_SD3_JANEIRO
			
			aDados1[09]	:= (cAlias1)->B2_ENTRADA_NF_FEVEREIRO + (cAlias1)->C2_ENTRADA_SD3_FEVEREIRO
			aDados1[10]	:= (cAlias1)->E2_SAIDA_NF_FEVEREIRO   + (cAlias1)->D2_SAIDA_SD3_FEVEREIRO
			
			aDados1[11]	:= (cAlias1)->B3_ENTRADA_NF_MARCO     + (cAlias1)->C3_ENTRADA_SD3_MARCO
			aDados1[12]	:= (cAlias1)->E3_SAIDA_NF_MARCO       + (cAlias1)->D3_SAIDA_SD3_MARCO
			
			aDados1[13]	:= (cAlias1)->B4_ENTRADA_NF_ABRIL     + (cAlias1)->C4_ENTRADA_SD3_ABRIL
			aDados1[14]	:= (cAlias1)->E4_SAIDA_NF_ABRIL       + (cAlias1)->D4_SAIDA_SD3_ABRIL
			
			aDados1[15]	:= (cAlias1)->B5_ENTRADA_NF_MAIO      + (cAlias1)->C5_ENTRADA_SD3_MAIO
			aDados1[16]	:= (cAlias1)->E5_SAIDA_NF_MAIO        + (cAlias1)->D5_SAIDA_SD3_MAIO
			
			aDados1[17]	:= (cAlias1)->B6_ENTRADA_NF_JUNHO     + (cAlias1)->C6_ENTRADA_SD3_JUNHO
			aDados1[18]	:= (cAlias1)->E6_SAIDA_NF_JUNHO       + (cAlias1)->D6_SAIDA_SD3_JUNHO
			
			aDados1[19]	:= (cAlias1)->B7_ENTRADA_NF_JULHO     + (cAlias1)->C7_ENTRADA_SD3_JULHO
			aDados1[20]	:= (cAlias1)->E7_SAIDA_NF_JULHO       + (cAlias1)->D7_SAIDA_SD3_JULHO
			
			aDados1[21]	:= (cAlias1)->B8_ENTRADA_NF_AGOSTO    + (cAlias1)->C8_ENTRADA_SD3_AGOSTO
			aDados1[22]	:= (cAlias1)->E8_SAIDA_NF_AGOSTO      + (cAlias1)->D8_SAIDA_SD3_AGOSTO
			
			aDados1[23]	:= (cAlias1)->B9_ENTRADA_NF_SETEMBRO  + (cAlias1)->C9_ENTRADA_SD3_SETEMBRO
			aDados1[24]	:= (cAlias1)->E9_SAIDA_NF_SETEMBRO    + (cAlias1)->D9_SAIDA_SD3_SETEMBRO
			
			aDados1[25]	:= (cAlias1)->B10_ENTRADA_NF_OUTUBRO  + (cAlias1)->C10_ENTRADA_SD3_OUTUBRO
			aDados1[26]	:= (cAlias1)->E10_SAIDA_NF_OUTUBRO    + (cAlias1)->D10_SAIDA_SD3_OUTUBRO
			
			aDados1[27]	:= (cAlias1)->B11_ENTRADA_NF_NOVEMBRO + (cAlias1)->C11_ENTRADA_SD3_NOVEMBRO
			aDados1[28]	:= (cAlias1)->E11_SAIDA_NF_NOVEMBRO   + (cAlias1)->D11_SAIDA_SD3_NOVEMBRO
			
			aDados1[29]	:= (cAlias1)->B12_ENTRADA_NF_DEZEMBRO + (cAlias1)->C12_ENTRADA_SD3_DEZEMBRO
			aDados1[30]	:= (cAlias1)->E12_SAIDA_NF_DEZEMBRO   + (cAlias1)->D12_SAIDA_SD3_DEZEMBRO
			
			aDados1[31]	:= aDados1[07] + aDados1[09] + aDados1[11] + aDados1[13] + aDados1[15] + aDados1[17] + aDados1[19] + aDados1[21] + aDados1[23] + aDados1[25] + aDados1[27] + aDados1[29]
			aDados1[32]	:= aDados1[08] + aDados1[10] + aDados1[12] + aDados1[14] + aDados1[16] + aDados1[18] + aDados1[20] + aDados1[22] + aDados1[24] + aDados1[26] + aDados1[28] + aDados1[30]
			
			oSection1:PrintLine()
			
			aFill(aDados1,nil)
			(cAlias1)->(dbskip())
			//(cAlias2)->(dbskip())
		End
		oSection1:PrintTotal()
		oSection1:Finish()
		
		oReport:SkipLine()
		
		aFill(aDados1,nil)
		
		(cAlias1)->(dbCloseArea())
		//(cAlias2)->(dbCloseArea())
		//Endif
	EndIf
	oReport:SkipLine()
	
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |StQuery  ºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Query do Relatório				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*
	
	Local cQuery1     := ' '
	Local cQuery2     := ' '
	Local cProdImp    := GetMV("MV_PRODIMP")
	
	/*
	cQuery1 := ""
	cQuery1 += "  SELECT
	cQuery1 += "  B1_COD    AS A1_CODIGO
	cQuery1 += ", B1_DESC   AS A2_DESCRICAO
	cQuery1 += ", B1_TIPO   AS A3_TIPO
	cQuery1 += ", B1_GRUPO  AS A4_GRUPO
	cQuery1 += ", BM_DESC   AS A5_DESCGRUPO
	
	cQuery1 += ", NVL((SELECT SUM(SB2.B2_QATU)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SB2") + " SB2"
	
	cQuery1 += " WHERE SB2.B2_COD               = SB1.B1_COD
	cQuery1 += " AND SB2.B2_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SB2.B2_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SB2.B2_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SB2.B2_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SB2.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS A6_SALDO_ATUAL
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '01'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B1_ENTRADA_NF_JANEIRO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '02'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B2_ENTRADA_NF_FEVEREIRO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '03'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B3_ENTRADA_NF_MARCO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '04'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B4_ENTRADA_NF_ABRIL
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '05'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B5_ENTRADA_NF_MAIO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '06'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B6_ENTRADA_NF_JUNHO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '07'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B7_ENTRADA_NF_JULHO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '08'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B8_ENTRADA_NF_AGOSTO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '09'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B9_ENTRADA_NF_SETEMBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '10'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B10_ENTRADA_NF_OUTUBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '11'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B11_ENTRADA_NF_NOVEMBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD1.D1_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD1") + " SD1"
	cQuery1 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery1 += " WHERE SD1.D1_COD               = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD1.D1_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES                 = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,5,2) = '12'
	cQuery1 += " AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"  + mv_par11+ "'"
	cQuery1 += " AND SD1.D1_ORIGLAN             <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD1.D1_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_             = ' '
	cQuery1 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS B12_ENTRADA_NF_DEZEMBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '01'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C1_ENTRADA_SD3_JANEIRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '02'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C2_ENTRADA_SD3_FEVEREIRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '03'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C3_ENTRADA_SD3_MARCO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '04'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C4_ENTRADA_SD3_ABRIL
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '05'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C5_ENTRADA_SD3_MAIO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '06'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C6_ENTRADA_SD3_JUNHO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '07'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C7_ENTRADA_SD3_JULHO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '08'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C8_ENTRADA_SD3_AGOSTO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '09'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C9_ENTRADA_SD3_SETEMBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=       RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '10'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C10_ENTRADA_SD3_OUTUBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '11'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C11_ENTRADA_SD3_NOVEMBRO
	
	cQuery1 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery1 += "  FROM "
	cQuery1 +=        RetSqlName("SD3") + " SD3"
	
	cQuery1 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery1 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '12'
	cQuery1 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery1 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery1 += " AND SD3.D3_TM <= '499'
	cQuery1 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery1 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery1 += "),0) AS C12_ENTRADA_SD3_DEZEMBRO
	
	cQuery1 += " FROM "
	
	cQuery1 +=        RetSqlName("SB1") + " SB1"
	cQuery1 += ", " + RetSqlName("SBM") + " SBM"
	
	cQuery1 += " WHERE SB1.D_E_L_E_T_ = ' '
	cQuery1 += " AND SB1.B1_COD       >= '"  + mv_par03 + "'"
	cQuery1 += " AND SB1.B1_COD       <= '"  + mv_par04 + "'"
	cQuery1 += " AND SB1.B1_FILIAL    =  '"  + xFilial("SB1") + "'"
	cQuery1 += " AND SB1.B1_TIPO      >= '"  + mv_par05	+ "'"
	cQuery1 += " AND SB1.B1_TIPO      <= '"  + mv_par06	+ "'"
	cQuery1 += " AND SB1.B1_GRUPO     >= '"  + mv_par07	+ "'"
	cQuery1 += " AND SB1.B1_GRUPO     <= '"  + mv_par08	+ "'"
	cQuery1 += " AND SB1.B1_COD       <> '"  + cProdimp	+ "'"
	cQuery1 += " AND SB1.B1_GRUPO     = SBM.BM_GRUPO
	
	cQuery1 += " ORDER BY B1_COD
	
	
	cQuery1 := ChangeQuery(cQuery1)
	*/
	
	
	
	cQuery1 := " SELECT B1_COD AS A1_CODIGO,
	cQuery1 += " B1_DESC AS A2_DESCRICAO,
	cQuery1 += " B1_TIPO AS A3_TIPO,
	cQuery1 += " B1_GRUPO AS A4_GRUPO,
	cQuery1 += " BM_DESC AS A5_DESCGRUPO,
	cQuery1 += " COALESCE((SELECT SUM(SB2.B2_QATU) FROM "+RetSqlName("SB2") + " SB2 WHERE  SB2.B2_COD = SB1.B1_COD AND SB2.B2_FILIAL >= '  ' AND SB2.B2_FILIAL <= 'ZZ' AND SB2.B2_LOCAL >= '01' AND SB2.B2_LOCAL <= '01' AND SB2.D_E_L_E_T_ = ' '),0)
	cQuery1 += "  AS A6_SALDO_ATUAL
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '01' then SD1.D1_QUANT else 0 end),0) AS B1_ENTRADA_NF_JANEIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '02' then SD1.D1_QUANT else 0 end),0) AS B2_ENTRADA_NF_FEVEREIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '03' then SD1.D1_QUANT else 0 end),0) AS B3_ENTRADA_NF_MARCO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '04' then SD1.D1_QUANT else 0 end),0) AS B4_ENTRADA_NF_ABRIL
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '05' then SD1.D1_QUANT else 0 end),0) AS B5_ENTRADA_NF_MAIO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '06' then SD1.D1_QUANT else 0 end),0) AS B6_ENTRADA_NF_JUNHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '07' then SD1.D1_QUANT else 0 end),0) AS B7_ENTRADA_NF_JULHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '08' then SD1.D1_QUANT else 0 end),0) AS B8_ENTRADA_NF_AGOSTO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '09' then SD1.D1_QUANT else 0 end),0) AS B9_ENTRADA_NF_SETEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '10' then SD1.D1_QUANT else 0 end),0) AS B10_ENTRADA_NF_OUTUBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '11' then SD1.D1_QUANT else 0 end),0) AS B11_ENTRADA_NF_NOVEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD1.D1_DTDIGIT,5,2) = '12' then SD1.D1_QUANT else 0 end),0) AS B12_ENTRADA_NF_DEZEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '01' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C1_ENTRADA_SD3_JANEIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '02' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C2_ENTRADA_SD3_FEVEREIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '03' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C3_ENTRADA_SD3_MARCO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '04' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C4_ENTRADA_SD3_ABRIL
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '05' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C5_ENTRADA_SD3_MAIO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '06' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C6_ENTRADA_SD3_JUNHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '07' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C7_ENTRADA_SD3_JULHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '08' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C8_ENTRADA_SD3_AGOSTO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '09' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C9_ENTRADA_SD3_SETEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '10' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C10_ENTRADA_SD3_OUTUBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '11' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C11_ENTRADA_SD3_NOVEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '12' AND SD3.D3_TM <= '499'   then SD3.D3_QUANT else 0 end),0) AS C12_ENTRADA_SD3_DEZEMBRO
	
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '01'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D1_SAIDA_SD3_JANEIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '02'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D2_SAIDA_SD3_FEVEREIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '03'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D3_SAIDA_SD3_MARCO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '04'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D4_SAIDA_SD3_ABRIL
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '05'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D5_SAIDA_SD3_MAIO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '06'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D6_SAIDA_SD3_JUNHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '07'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D7_SAIDA_SD3_JULHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '08'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D8_SAIDA_SD3_AGOSTO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '09'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D9_SAIDA_SD3_SETEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '10'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D10_SAIDA_SD3_OUTUBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '11'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D11_SAIDA_SD3_NOVEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD3.D3_EMISSAO,5,2) = '12'  AND SD3.D3_TM >= '500'   then SD3.D3_QUANT else 0 end),0) AS D12_SAIDA_SD3_DEZEMBRO
	
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '01' then SD2.D2_QUANT else 0 end),0) AS E1_SAIDA_NF_JANEIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '02' then SD2.D2_QUANT else 0 end),0) AS E2_SAIDA_NF_FEVEREIRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '03' then SD2.D2_QUANT else 0 end),0) AS E3_SAIDA_NF_MARCO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '04' then SD2.D2_QUANT else 0 end),0) AS E4_SAIDA_NF_ABRIL
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '05' then SD2.D2_QUANT else 0 end),0) AS E5_SAIDA_NF_MAIO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '06' then SD2.D2_QUANT else 0 end),0) AS E6_SAIDA_NF_JUNHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '07' then SD2.D2_QUANT else 0 end),0) AS E7_SAIDA_NF_JULHO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '08' then SD2.D2_QUANT else 0 end),0) AS E8_SAIDA_NF_AGOSTO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '09' then SD2.D2_QUANT else 0 end),0) AS E9_SAIDA_NF_SETEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '10' then SD2.D2_QUANT else 0 end),0) AS E10_SAIDA_NF_OUTUBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '11' then SD2.D2_QUANT else 0 end),0) AS E11_SAIDA_NF_NOVEMBRO
	cQuery1 += " ,NVL(SUM(case when SUBSTR(SD2.D2_EMISSAO,5,2) = '12' then SD2.D2_QUANT else 0 end),0) AS E12_SAIDA_NF_DEZEMBRO
	
	
	cQuery1 += " FROM "+RetSqlName("SB1") + " SB1
	
	
	cQuery1 += " LEFT join(SELECT  *
	cQuery1 += " FROM "+RetSqlName("SD1") + ") SD1
	cQuery1 += " on  SD1.D1_COD = SB1.B1_COD
	cQuery1 += " AND SD1.D1_FILIAL = '"  + xFilial("SD1") + "'"
	cQuery1 += " AND SD1.D1_DTDIGIT  BETWEEN '"  + mv_par11+ "0101'  AND '"  + mv_par11+ "1231'
	cQuery1 += " AND SD1.D1_ORIGLAN <> 'LF'
	cQuery1 += " AND SD1.D1_LOCAL  BETWEEN '"  + mv_par09 + "'  AND '"  + mv_par10 + "'"
	cQuery1 += " AND SD1.D_E_L_E_T_ = ' '
	cQuery1 += " AND EXISTS(select * from "+RetSqlName("SF4") + " SF4
	cQuery1 += " WHERE  SF4.F4_FILIAL = '"  + xFilial("SF4") + "'"
	cQuery1 += " AND SD1.D1_TES = SF4.F4_CODIGO
	cQuery1 += " AND SF4.F4_ESTOQUE = 'S'
	cQuery1 += " AND SF4.D_E_L_E_T_ = ' ')
	
	
	//query 1
	cQuery1 += " LEFT JOIN (SELECT * FROM "+RetSqlName("SD3") + " )SD3
	cQuery1 += " ON  SD3.D3_COD = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL  = '"  + xFilial("SD3") + "'"
	cQuery1 += " AND  SD3.D3_EMISSAO  BETWEEN '"  + mv_par11+ "0101'  AND '"  + mv_par11+ "1231'
	cQuery1 += " AND SD3.D3_ESTORNO <> 'S'
	cQuery1 += " AND SD3.D3_LOCAL BETWEEN '"  + mv_par09 + "'  AND '"  + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_ = ' '
	
	
	
	cQuery1 += " LEFT JOIN(SELECT * FROM "+RetSqlName("SD2") + " )SD2
	cQuery1 += " ON  SD2.D2_COD = SB1.B1_COD
	cQuery1 += " AND SD2.D2_FILIAL = '"  + xFilial("SD2") + "'"
	cQuery1 += " AND  SD2.D2_EMISSAO  BETWEEN '"  + mv_par11+ "0101'  AND '"  + mv_par11+ "1231'
	cQuery1 += " AND SD2.D2_ORIGLAN <> 'LF'
	cQuery1 += " AND SD2.D2_LOCAL  BETWEEN '"  + mv_par09 + "'  AND '"  + mv_par10 + "'"
	cQuery1 += " AND SD2.D_E_L_E_T_ = ' '
	cQuery1 += " AND EXISTS(select * from "+RetSqlName("SF4") + " TF4
	cQuery1 += " WHERE  TF4.F4_FILIAL = '"  + xFilial("SF4") + "'"
	cQuery1 += " AND  SD2.D2_TES = TF4.F4_CODIGO
	cQuery1 += " AND TF4.F4_ESTOQUE = 'S'
	cQuery1 += " AND TF4.D_E_L_E_T_ = ' ')
	
	
	cQuery1 += " LEFT JOIN( SELECT * FROM "+RetSqlName("SBM") + " )SBM
	cQuery1 += " ON SB1.B1_GRUPO = SBM.BM_GRUPO
	cQuery1 += " AND SBM.D_E_L_E_T_ = ' '
	cQuery1 += " AND SBM.BM_FILIAL = ' '
	
	
	cQuery1 += " WHERE  SB1.D_E_L_E_T_ = ' '
	cQuery1 += " AND SB1.B1_COD BETWEEN '"  + mv_par03 + "'  AND '"  + mv_par04 + "'"
	cQuery1 += " AND SB1.B1_FILIAL = '"  + xFilial("SB1") + "'"
	//--AND SB1.B1_TIPO <= 'ZZ'
	cQuery1 += " AND SB1.B1_GRUPO BETWEEN '"  + mv_par07 + "'  AND '"  + mv_par08 + "'"
	cQuery1 += " AND SB1.B1_COD <> '"  + cProdimp	+ "'"
	// comentar caso o gilberto de am solicite ver tudo
	cQuery1 += " AND EXISTS (SELECT * FROM "+RetSqlName("SD3") + " SD3
	cQuery1 += " WHERE  SD3.D3_COD = SB1.B1_COD
	cQuery1 += " AND SD3.D3_FILIAL  = '"  + xFilial("SD3") + "'"
	cQuery1 += " AND  SD3.D3_EMISSAO  BETWEEN '"  + mv_par11+ "0101'  AND '"  + mv_par11+ "1231'
	cQuery1 += " AND SD3.D3_ESTORNO <> 'S'
	cQuery1 += " AND SD3.D3_LOCAL BETWEEN '"  + mv_par09 + "'  AND '"  + mv_par10 + "'"
	cQuery1 += " AND SD3.D_E_L_E_T_ = ' '
	cQuery1 += " AND SD3.D3_TM >= '500' )
	//****************************************************************************
	cQuery1 += " GROUP BY B1_COD ,B1_DESC ,B1_TIPO ,B1_GRUPO,BM_DESC
	cQuery1 += " ORDER BY  B1_COD
	
	
		cQuery1 := ChangeQuery(cQuery1)
	
	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)
	/*
	
	cQuery2 := ""
	cQuery2 += "  SELECT
	cQuery2 += "  B1_COD    AS A1_CODIGO
	cQuery2 += ", B1_DESC   AS A2_DESCRICAO
	cQuery2 += ", B1_TIPO   AS A3_TIPO
	cQuery2 += ", B1_GRUPO  AS A4_GRUPO
	cQuery2 += ", BM_DESC   AS A5_DESCGRUPO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '01'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D1_SAIDA_SD3_JANEIRO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '02'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D2_SAIDA_SD3_FEVEREIRO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '03'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D3_SAIDA_SD3_MARCO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '04'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D4_SAIDA_SD3_ABRIL
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '05'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D5_SAIDA_SD3_MAIO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '06'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D6_SAIDA_SD3_JUNHO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '07'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D7_SAIDA_SD3_JULHO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '08'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D8_SAIDA_SD3_AGOSTO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '09'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D9_SAIDA_SETEMBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '10'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D10_SAIDA_SD3_OUTUBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '11'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D11_SAIDA_SD3_NOVEMBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD3.D3_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD3") + " SD3"
	
	cQuery2 += " WHERE SD3.D3_COD               = SB1.B1_COD
	cQuery2 += " AND SD3.D3_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD3.D3_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,5,2) = '12'
	cQuery2 += " AND SUBSTR(SD3.D3_EMISSAO,1,4) = '"  + mv_par11+ "'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuery2 += " AND SD3.D3_ESTORNO <> 'S'"
	EndIf
	cQuery2 += " AND SD3.D3_TM >= '500'
	cQuery2 += " AND SD3.D3_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD3.D3_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD3.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS D12_SAIDA_SD3_DEZEMBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '01'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E1_SAIDA_NF_JANEIRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '02'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E2_SAIDA_NF_FEVEREIRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '03'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E3_SAIDA_NF_MARCO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '04'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E4_SAIDA_NF_ABRIL
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '05'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E5_SAIDA_NF_MAIO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '06'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E6_SAIDA_NF_JUNHO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '07'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E7_SAIDA_NF_JULHO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '08'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E8_SAIDA_NF_AGOSTO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '09'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E9_SAIDA_NF_SETEMBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '10'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E10_SAIDA_NF_OUTUBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '11'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E11_SAIDA_NF_NOVEMBRO
	
	cQuery2 += ", NVL((SELECT SUM(SD2.D2_QUANT)
	cQuery2 += "  FROM "
	cQuery2 +=        RetSqlName("SD2") + " SD2"
	cQuery2 += ", " + RetSqlName("SF4") + " SF4"
	
	cQuery2 += " WHERE SD2.D2_COD               = SB1.B1_COD
	cQuery2 += " AND SD2.D2_FILIAL              >= '" + mv_par01 + "'"
	cQuery2 += " AND SD2.D2_FILIAL              <= '" + mv_par02 + "'"
	cQuery2 += " AND SF4.F4_FILIAL              = '" + xFilial("SF4") + "'"
	cQuery2 += " AND SD2.D2_TES                 = SF4.F4_CODIGO
	cQuery2 += " AND SF4.F4_ESTOQUE             = 'S'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,5,2) = '12'
	cQuery2 += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"  + mv_par11+ "'"
	cQuery2 += " AND SD2.D2_ORIGLAN             <> 'LF'
	cQuery2 += " AND SD2.D2_LOCAL               >= '" + mv_par09 + "'"
	cQuery2 += " AND SD2.D2_LOCAL               <= '" + mv_par10 + "'"
	cQuery2 += " AND SD2.D_E_L_E_T_             = ' '
	cQuery2 += " AND SF4.D_E_L_E_T_             = ' '
	cQuery2 += "),0) AS E12_SAIDA_NF_DEZEMBRO
	
	cQuery2 += " FROM "
	
	cQuery2 +=        RetSqlName("SB1") + " SB1"
	cQuery2 += ", " + RetSqlName("SBM") + " SBM"
	
	cQuery2 += " WHERE SB1.D_E_L_E_T_ = ' '
	cQuery2 += " AND SB1.B1_COD       >= '"  + mv_par03 + "'"
	cQuery2 += " AND SB1.B1_COD       <= '"  + mv_par04 + "'"
	cQuery2 += " AND SB1.B1_FILIAL    =  '"  + xFilial("SB1") + "'"
	cQuery2 += " AND SB1.B1_TIPO      >= '"  + mv_par05	+ "'"
	cQuery2 += " AND SB1.B1_TIPO      <= '"  + mv_par06	+ "'"
	cQuery2 += " AND SB1.B1_GRUPO     >= '"  + mv_par07	+ "'"
	cQuery2 += " AND SB1.B1_GRUPO     <= '"  + mv_par08	+ "'"
	cQuery2 += " AND SB1.B1_COD       <> '"  + cProdimp	+ "'"
	cQuery2 += " AND SB1.B1_GRUPO     = SBM.BM_GRUPO
	
	cQuery2 += " ORDER BY B1_COD
	
	cQuery2 := ChangeQuery(cQuery2)
	
	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)
	*/
Return()
