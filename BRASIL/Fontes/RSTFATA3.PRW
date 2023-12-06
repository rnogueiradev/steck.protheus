#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "Tbiconn.ch"
#include "rptdef.ch"

#DEFINE CR    chr(13)+chr(10)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  |RSTFATA3  ∫Autor  ≥Jo„o Victor         ∫ Data ≥  20/10/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  RelatÛrio Tr‚nsito Filiais STECK SP                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck Industria Eletrica Ltda.                             ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫ Ticket 20190710000072 - Retirar Local 60 da Falta - Everson Santana   ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function RSTFATA3(lJobAuto)

	Local   oReport
	Local   nX			:= 0
	Private cPerg		:= "RFATA3"
	Private cPerg1      := PadR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime       := Time()
	Private cHora       := Substr(cTime, 1, 2)
	Private cMinutos    := Substr(cTime, 4, 2)
	Private cSegundos   := Substr(cTime, 7, 2)
	Private cAliasLif   := cPerg + cHora + cMinutos + cSegundos
	Private cPergTit 	:= cAliasLif
	Private cAlias1     := GetNextAlias()
	Private cAlias2     := GetNextAlias()
	Private _cTitulo    := "RelatÛrio Tr‚nsito SP"
	Private _cDescri    := "Este programa ir· imprimir um relatÛrio Tr‚nsito SP"
	Private _cSection1  := "Tr‚nsito SP"
	Private _cxMes01 	:= cValtoChar(Year(Date())) + Strzero(Month(Date()),2,0)
	Private _cxMes02 	:= Iif(Val(Substr(_cxMes01,5,2)) == 12,cValtoChar(Val(Substr(_cxMes01,1,4))+1) + '01' , cValtoChar(Val(Substr(_cxMes01,1,4))) + PADL(cValtochar(Val(Substr(_cxMes01,5,2))+1),2,"0") )
	Private _cxMes03 	:= Iif(Val(Substr(_cxMes02,5,2)) == 12,cValtoChar(Val(Substr(_cxMes02,1,4))+1) + '01' , cValtoChar(Val(Substr(_cxMes02,1,4))) + PADL(cValtochar(Val(Substr(_cxMes02,5,2))+1),2,"0") )
	Private _cxMes04 	:= Iif(Val(Substr(_cxMes03,5,2)) == 12,cValtoChar(Val(Substr(_cxMes03,1,4))+1) + '01' , cValtoChar(Val(Substr(_cxMes03,1,4))) + PADL(cValtochar(Val(Substr(_cxMes03,5,2))+1),2,"0") )
	Private _cMes01 	:= MesExtenso(Substr(_cxMes01,5,2))
	Private _cMes02 	:= MesExtenso(Substr(_cxMes02,5,2))
	Private _cMes03 	:= MesExtenso(Substr(_cxMes03,5,2))
	Private _cMes04 	:= MesExtenso(Substr(_cxMes04,5,2))
	Private cPastaRel 		:= "\arquivos\"
	Private carquivo_       := 	"RSTFATA3"
	Private cAnexo			:= ""
	Private cPara 			:= SuperGetMV("ST_RSFATA3",.F.,"henrique.youssef@steck.com.br;rafael.rivani@steck.com.br;david.junior@steck.com.br")

	Default lJobAuto 	:= .F.

	If lJobAuto
		


		For nX := 1 To 2 //Roda 2 x
		 	If nX == 1
				//Cria as definiÁıes do relatÛrio
				oReport := ReportDef()
				
				MV_PAR01 := Space(06)           
				MV_PAR02 := Replicate("Z",15)  
				MV_PAR03 := Space(04) 
				MV_PAR04 := Replicate("Z",04) 
				MV_PAR05 := Space(02) 
				MV_PAR06 := Replicate("Z",02)
				MV_PAR07 := 1
				
				//Define um nome do arquivo dentro da Protheus Data - pasta 'x_arquivos'
				cAnexo := carquivo_ + dToS(dDataBase) + StrTran(Time(), ":", "-") + ".xls"
			
				//Define para o relatÛrio n„o mostrar na tela, o Device 4 (Planilha), define o arquivo, e define para imprimir

				oReport:lPreview:= .F.
				oReport:setFile(cPastaRel+cAnexo)
				
				oReport:nDevice			:= 4 	//1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
				oReport:nEnvironment	:= 1 // 1 -Server / 2- Cliente
				oReport:nRemoteType		:= NO_REMOTE
				oReport:cDescription 	:= _cTitulo
				oReport:cFile 			:= cPastaRel+cAnexo
				oReport:lParamPage 		:= .F.
				oReport:SetTpPlanilha({.F., .F., .T., .F.})

				oReport:Print(.F.)
				
			Else				
				If File(cPastaRel+cAnexo)
					//Cria as definiÁıes do relatÛrio
					//oReport := ReportDef()
			
					_cEmail     := cPara
					_cArq       := cAnexo
					_aAttach    := {}
					_cCopia 	:= ""
					_cAssunto   := "[WFPROTHEUS] - " + Alltrim(_cTitulo)
					cMsg		:= ""
					aadd( _aAttach  , _cArq )
		

					cMsg := '<html><head><title>stkSales</title></head>
					cMsg += '<body>
					cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
					cMsg += '<br><br>Ol· <b></b>,<br><br> ' //cMsg += '<br><br>Ol· <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
					cMsg += 'VocÍ est· recebendo o '+ Alltrim(_cTitulo) +' da Steck!<br>
					cMsg += 'Obrigado!<br><br>'
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Ind˙stria ElÈtrica Ltda
					cMsg += '</body></html>'

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,cPastaRel)  //n„o funcionou
				
					cParada := ""
					//oReport:PrintDialog()
				EndIf
			EndIf
		Next nX
	Else
		//-------cGrupo,cOrdem,cPergunt                ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
		//tSx1(cPerg   ,"01"  ,"Filial ?"              ,"Filial ?"                 ,"Filial ?"                   ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
		PutSx1(cPerg   ,"01"  ,"Produto De: ?"         ,"Produto De: ?"            ,"Produto De: ?"              ,"mv_ch1"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(15)            ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"02"  ,"Produto AtÈ: ?"        ,"Produto AtÈ: ?"           ,"Produto AtÈ: ?"             ,"mv_ch2"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",15)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"03"  ,"Grupo De: ?"           ,"Grupo De: ?"              ,"Grupo De: ?"                ,"mv_ch3"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(4)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"04"  ,"Grupo AtÈ: ?"          ,"Grupo AtÈ: ?"             ,"Grupo AtÈ: ?"               ,"mv_ch4"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Replicate("Z",4)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"05"  ,"Tipo De: ?"            ,"Tipo De: ?"               ,"Tipo De: ?"                 ,"mv_ch5"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"02"  ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,Space(2)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"06"  ,"Tipo AtÈ: ?"           ,"Tipo AtÈ: ?"              ,"Tipo AtÈ: ?"                ,"mv_ch6"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"02"  ,""     ,"S"  ,"mv_par06"    ,""                ,""      ,""      ,Replicate("Z",2)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
		PutSx1(cPerg   ,"07"  ,"Apenas Carteira: ?"    ,"Apenas Carteira: ?"       ,"Apenas Carteira: ?"         ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,""    ,""     ,"S"  ,"mv_par07"    ,"1-Sim"           ,""      ,""      ,                     ,"2-N„o"            ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

		oReport	:= ReportDef()
		oReport:PrintDialog()
	Endif
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  |ReportDef ∫Autor  ≥Jo„o Victor         ∫ Data ≥  20/10/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  CabeÁalho do RelatÛrio                                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck Industria Eletrica Ltda.                             ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportDef()

	Local oReport
	Local oSection1

	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 6

	Pergunte(cPerg,.F.)

	//Primeira SeÁ„o
	oSection1 := TRSection():New(oReport,_cSection1,{cAlias1})
	TRCell():New(oSection1,"A1" ,,"CÛdigo "                 ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection1,"A2" ,,"DescriÁ„o Produto"       ,PesqPict("SB1","B1_DESC")        ,TamSX3("B1_DESC")      [1]+2)
	TRCell():New(oSection1,"A3" ,,"ABC"                     ,PesqPict("SB1","B1_XABC")        ,TamSX3("B1_XABC")      [1]+2)
	TRCell():New(oSection1,"A4" ,,"FMR"                     ,PesqPict("SB1","B1_XFMR")        ,TamSX3("B1_XFMR")      [1]+2)
	TRCell():New(oSection1,"A5" ,,"MÈdia Trim"              ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection1,"A6" ,,"Bloq"                    ,PesqPict("SBM","BM_GRUPO")       ,TamSX3("BM_GRUPO")     [1]+2)
	TRCell():New(oSection1,"A7" ,,"Grupo"                   ,PesqPict("SBM","BM_GRUPO")       ,TamSX3("BM_GRUPO")     [1]+2)
	TRCell():New(oSection1,"A8" ,,"DescriÁ„o Grupo"         ,PesqPict("SBM","BM_DESC")        ,TamSX3("BM_DESC")      [1]+2)
	TRCell():New(oSection1,"A9" ,,"Estoque"                 ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A10",,"Estoque 98"              ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A11",,"Carteira"                ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A12",,"Carteira CrÈdito"        ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A13",,"Falta Real 02"           ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A14",,"Falta Real 01"           ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A15",,"Tr‚nsito MÍs"            ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A16",,"Tr‚nsito PrÛximo MÍs"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A17",,"Estoque com Tr‚nsito"    ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A18",,"Cobertura com Tr‚nsito"  ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A19",,_cMes01                   ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A20",,_cMes02                   ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A21",,_cMes03                   ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A22",,_cMes04                   ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A23",,"Faturamento Dentro Mes"	,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A24",,"Previs„o de Vendas"		,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A25",,"Estoque de SeguranÁa"	,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A26",,"Saldo MMG SP"            ,PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	TRCell():New(oSection1,"A27",,"Estoque com Saldo MMG SP",PesqPict("SB2","B2_QATU")        ,TamSX3("B2_QATU")      [1]+2)
	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	TRCell():New(oSection1,"A28",,"C Unit 1a M "			,PesqPict("SB2","B2_CMFIM1")      ,TamSX3("B2_CMFIM1 ")   [1]+2)
	TRCell():New(oSection1,"A29",,"Custo Total "			,PesqPict("SB2","B2_CMFIM1")     ,TamSX3("B2_CMFIM1 ")    [1]+2)
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

	oBreak1 := TRBreak():New(oSection1,".T.","Totalizadores : ",.F.)
	TRFunction():New(oSection1:Cell("A9")      ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A10")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A11")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A12")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A13")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A14")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A15")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A16")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A17")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A18")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A19")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A20")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A21")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A22")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A23")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A24")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A25")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A26")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("A27")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	TRFunction():New(oSection1:Cell("A29")     ,"","SUM"  ,oBreak1,,,,.F.,.F.)
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
Return oReport

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  |ReportPrint∫Autor  ≥Jo„o Victor         ∫ Data ≥  20/10/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Itens do RelatÛrio                                         ∫±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck Industria Eletrica Ltda.                              ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportPrint(oReport)

	Local oSection1		:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]
	Local _cMediaTrim	 := 0

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
	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	oSection1:Cell("A28"):SetBlock( { || aDados1[28] } )
	oSection1:Cell("A29"):SetBlock( { || aDados1[29] } )
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
	oReport:SetTitle(_cTitulo)// Titulo do relatÛrio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery(  ) },"Compondo RelatÛrio")

	DbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )
	If Select(cAlias1) > 0
		While (cAlias1)->( !Eof() )
			_cMediaTrim	:= 0
			dbselectarea("SB3")
			If SB3->( dbseek(xfilial("SB3") + (cAlias1)->A1_CODIGO) )
				_cMediaTrim  := (&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2)) + &("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2)) + &("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)))/3
			EndIf
			aDados1[01]	:= (cAlias1)->A1_CODIGO
			aDados1[02]	:= (cAlias1)->A2_DESCRICAO
			aDados1[03]	:= (cAlias1)->A3_ABC
			aDados1[04]	:= (cAlias1)->A4_FMR
			aDados1[05]	:= _cMediaTrim
			aDados1[06]	:= Iif((cAlias1)->A6_BLOQUEADO == "2","N√O","SIM")
			aDados1[07]	:= (cAlias1)->A7_GRUPO
			aDados1[08]	:= (cAlias1)->A8_DESCGRUP
			aDados1[09]	:= (cAlias1)->A9_ESTOQUE
			aDados1[10]	:= (cAlias1)->A10_ESTOQUE98
			aDados1[11]	:= (cAlias1)->A11_CARTEIRA
			aDados1[12]	:= (cAlias1)->A12_CARTEIRA_CREDITO
			aDados1[13]	:= (cAlias1)->A13_FTREAL02
			aDados1[14]	:= (cAlias1)->A14_FTREAL01
			aDados1[15]	:= (cAlias1)->A15_TRANSITO_MES
			aDados1[16]	:= (cAlias1)->A16_TRANSITO_PROXIMO_MES
			aDados1[17]	:= (cAlias1)->A13_FTREAL02 + (cAlias1)->A15_TRANSITO_MES + (cAlias1)->A16_TRANSITO_PROXIMO_MES
			aDados1[18]	:= (aDados1[17]/(aDados1[05]/30))
			aDados1[19]	:= (cAlias1)->A19_PREV01
			aDados1[20]	:= (cAlias1)->A20_PREV02
			aDados1[21]	:= (cAlias1)->A21_PREV03
			aDados1[22]	:= (cAlias1)->A22_PREV04
			aDados1[23]	:= (cAlias1)->A23_FATUR_DENTRO_MES
			aDados1[24]	:= Val((cAlias1)->A24_PREVISAO_MES)
			aDados1[25]	:= (cAlias1)->A25_ESTOQUE_SEGURANCA
			aDados1[26]	:= (cAlias1)->A26_SALDOMMGSP
			aDados1[27]	:= (aDados1[17]+aDados1[26])
			//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
			aDados1[28]	:= (cAlias1)->CMFIM1
			aDados1[29] := (((cAlias1)->A15_TRANSITO_MES+(cAlias1)->A16_TRANSITO_PROXIMO_MES)*(cAlias1)->CMFIM1)
			//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAlias1)->( dbskip() )
		End
		oSection1:PrintTotal()
		oSection1:Finish()
		oReport:SkipLine()
		aFill(aDados1,Nil)
		(cAlias1)->( dbCloseArea() )
	EndIf
	
	oReport:SkipLine()

Return oReport

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  |StQuery  ∫Autor  ≥Jo„o Victor         ∫ Data ≥  20/10/15    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Query do RelatÛrio                                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck Industria Eletrica Ltda.                             ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StQuery()

	Local cQuery1     := ' '

	cQuery1 := " SELECT "+CR
	cQuery1 += " SB1.B1_COD         AS A1_CODIGO "+CR
	cQuery1 += ",TRIM(SB1.B1_DESC)  AS A2_DESCRICAO "+CR
	cQuery1 += ",SB1.B1_XABC        AS A3_ABC "+CR
	cQuery1 += ",SB1.B1_XFMR        AS A4_FMR "+CR

	cQuery1 += ",SB1.B1_MSBLQL      AS A6_BLOQUEADO "+CR
	cQuery1 += ",SB1.B1_GRUPO       AS A7_GRUPO "+CR
	cQuery1 += ",TRIM(SBM.BM_DESC)  AS A8_DESCGRUP "+CR

	cQuery1 += ",NVL((SELECT SUM(SB2.B2_QATU) "+CR
	cQuery1 += " FROM "+RetSqlName("SB2")+" SB2 " +CR
	cQuery1 += " WHERE SB2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'" +CR
	cQuery1 += " 	AND SB2.B2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' ) "+CR
	cQuery1 += " 	),0) AS A9_ESTOQUE "+CR

	cQuery1 += ",NVL((SELECT SUM(SB2.B2_QATU) "+CR
	cQuery1 += " FROM "+RetSqlName("SB2")+" SB2 " +CR
	cQuery1 += " WHERE SB2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'" +CR
	cQuery1 += " 	AND SB2.B2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND (SB2.B2_LOCAL = '98' ) "+CR
	cQuery1 += " 	),0) AS A10_ESTOQUE98 "+CR

	cQuery1 += ",NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 " +CR
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CR
	cQuery1 += " ON SF4.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CR
	cQuery1 += " 	AND SF4.F4_ESTOQUE = 'S' "+CR
	cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 " +CR
	cQuery1 += " ON SC5.C5_NUM = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CR
	cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC6.C6_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'" +CR
	//cQuery1 += " 	AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery1 += " 	AND SC6.C6_OPER <> '38'   AND SC6.C6_OPER <> '11'    " +CR //pedido de ordem e remessa richeli 17/07/14 giovani 20/01/2020 tp 93 exclui
	cQuery1 += " 	AND SC6.C6_BLQ <> 'R' "+CR
	cQuery1 += " 	AND SC6.C6_LOCAL <> '60' " +CR //Ticket 20190710000072
	cQuery1 += " 	AND SC5.C5_TIPO = 'N' "+CR
	cQuery1 += " 	AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9  "+CR
	cQuery1 += " WHERE SC9.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC9.C9_PEDIDO = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC9.C9_BLCRED In ('01','09') "+CR
	cQuery1 += " 	AND SC9.C9_FILIAL = SC6.C6_FILIAL) "+CR
	cQuery1 += " 	AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0) AS A11_CARTEIRA "+CR

	cQuery1 += ",NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6  "+CR
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CR
	cQuery1 += " ON SF4.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CR
	cQuery1 += " 	AND SF4.F4_ESTOQUE = 'S' "+CR
	cQuery1 += " INNER JOIN(SELECT * FROM  "+RetSqlName("SC5")+" )SC5  "+CR
	cQuery1 += " ON SC5.C5_NUM = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CR
	cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC6.C6_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CR
	//cQuery1 += " 	AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39'  OR SC5.C5_TIPOCLI = 'X')
	cQuery1 += " 	AND SC6.C6_OPER <> '38'   AND SC6.C6_OPER <> '11' "+CR //pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery1 += " 	AND SC6.C6_BLQ <> 'R' "+CR
	cQuery1 += " 	AND SC5.C5_TIPO = 'N' "+CR
	cQuery1 += " 	AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0 "+CR
	cQuery1 += " 	AND SC6.C6_LOCAL <> '60'  "+CR //Ticket 20190710000072
	cQuery1 += " 	AND EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9  "+CR
	cQuery1 += " WHERE SC9.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC9.C9_PEDIDO = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC9.C9_BLCRED In ('01','09') "+CR
	cQuery1 += " 	AND SC9.C9_FILIAL = SC6.C6_FILIAL) "+CR
	cQuery1 += " 	),0) AS A12_CARTEIRA_CREDITO "+CR

	cQuery1 += ",NVL((SELECT SUM(SB2.B2_QATU) "+CR
	cQuery1 += " FROM "+RetSqlName("SB2")+" SB2  "+CR
	cQuery1 += " WHERE SB2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "+CR
	cQuery1 += " 	AND SB2.B2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' ) "+CR
	cQuery1 += " 	),0) "+CR
	cQuery1 += " 	- "+CR
	cQuery1 += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6  "+CR
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CR
	cQuery1 += " ON SF4.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CR
	cQuery1 += " 	AND SF4.F4_ESTOQUE = 'S' "+CR
	cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5  "+CR
	cQuery1 += " ON SC5.C5_NUM = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CR
	cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC6.C6_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CR
	//cQuery1 += " 	AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery1 += " 	AND SC6.C6_OPER <> '38'  AND SC6.C6_OPER <> '11' "+CR//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery1 += " 	AND SC6.C6_BLQ <> 'R' "+CR
	cQuery1 += " 	AND SC6.C6_LOCAL <> '60'  "+CR //Ticket 20190710000072
	cQuery1 += " 	AND SC5.C5_TIPO = 'N' "+CR
	cQuery1 += " 	AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9  "+CR
	cQuery1 += " WHERE SC9.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC9.C9_PEDIDO = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC9.C9_BLCRED In ('01','09') "+CR
	cQuery1 += " 	AND SC9.C9_FILIAL = SC6.C6_FILIAL) "+CR
	cQuery1 += " 	AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0)  AS A13_FTREAL02  "+CR

	cQuery1 += ",NVL((SELECT SUM(PA2_QUANT) "+CR
	cQuery1 += " FROM "+RetSqlName("PA2")+" PA2 "+CR
	cQuery1 += " WHERE PA2.D_E_L_E_T_=' ' "+CR
	cQuery1 += " 	AND PA2_FILRES = '01' "+CR
	cQuery1 += " 	AND PA2_CODPRO = SB1.B1_COD),0) AS A14_FTREAL01 "+CR

	cQuery1 += ",NVL((SELECT "+CR
	cQuery1 += " SUM(D2_QUANT) "+CR
	cQuery1 += " FROM UDBP12.SD2010 SD2  "+CR
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SD2.D2_FILIAL = '05' "+CR
	cQuery1 += " 	AND SD2.D2_CLIENTE = '033467' "+CR

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2022
	Chamado........: 20220124001890 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery1 += " 	AND SD2.D2_LOJA = '02' "+CR
	ELSE
		cQuery1 += " 	AND SD2.D2_LOJA = '06' "+CR
	ENDIF
	cQuery1 += " 	AND SUBSTR( SD2.D2_EMISSAO,1,4) >= '"+AllTrim(GetMv("RSTFATA301",,"2020"))+"' "+CR
	cQuery1 += " 	AND SD2.D2_EMISSAO  <= '"+substr(dtos(date()),1,6)+"15' "+CR
	cQuery1 += " 	AND SD2.D2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND  NOT EXISTS (   SELECT * FROM UDBP12.SF3010 SF3  "+CR
	cQuery1 += " WHERE SF3.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SF3.F3_SERIE = SD2.D2_SERIE "+CR
	cQuery1 += " 	AND SF3.F3_NFISCAL = SD2.D2_DOC "+CR
	cQuery1 += " 	AND F3_OBSERV LIKE '%DENEGADA%') "+CR
	cQuery1 += " 	AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SD1")+" SD1  "+CR
	cQuery1 += " WHERE SD1.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SD1.D1_FILIAL='01' AND SD1.D1_FORNECE = '005764' "+CR
	cQuery1 += " 	AND SD1.D1_DOC = SD2.D2_DOC AND SD1.D1_SERIE= SD2.D2_SERIE)),0) AS A15_TRANSITO_MES "+CR

	cQuery1 += ",NVL((SELECT "+CR
	cQuery1 += " SUM(D2_QUANT) "+CR
	cQuery1 += " FROM  UDBP12.SD2010 SD2  "+CR
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SD2.D2_FILIAL = '05' "+CR
	cQuery1 += " 	AND SD2.D2_CLIENTE = '033467' "+CR
	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220124001890 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery1 += " 	AND SD2.D2_LOJA = '02' "+CR
	ELSE
		cQuery1 += " 	AND SD2.D2_LOJA = '06' "+CR
	ENDIF
	cQuery1 += " 	AND SUBSTR( SD2.D2_EMISSAO,1,4) >= '"+AllTrim(GetMv("RSTFATA301",,"2020"))+"' "+CR
	cQuery1 += " 	AND SD2.D2_EMISSAO  > '"+substr(dtos(date()),1,6)+"15' "+CR
	cQuery1 += " 	AND SD2.D2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND  NOT EXISTS (   SELECT * FROM UDBP12.SF3010 SF3  "+CR
	cQuery1 += " WHERE SF3.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SF3.F3_SERIE = SD2.D2_SERIE "+CR
	cQuery1 += " 	AND SF3.F3_NFISCAL = SD2.D2_DOC "+CR
	cQuery1 += " 	AND F3_OBSERV LIKE '%DENEGADA%') "+CR
	cQuery1 += " 	AND  NOT EXISTS ( SELECT * FROM  "+RetSqlName("SD1")+" SD1  "+CR
	cQuery1 += " WHERE SD1.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SD1.D1_FILIAL='01' AND SD1.D1_FORNECE = '005764' "+CR
	cQuery1 += " 	AND SD1.D1_DOC = SD2.D2_DOC AND SD1.D1_SERIE= SD2.D2_SERIE)),0) AS A16_TRANSITO_PROXIMO_MES "+CR
	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	cQuery1 += ",NVL((SELECT DISTINCT SB21.B2_CMFIM1 "+CR
	cQuery1 += " FROM "+RetSqlName("SB2")+" SB21  "+CR
	cQuery1 += " WHERE SB21.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SB21.B2_FILIAL = '"+xFilial("SB2")+"' "+CR
	cQuery1 += " 	AND SB21.B2_COD = SB1.B1_COD "+CR

If cEmpAnt <> "11"
	cQuery1 += " 	AND ( SB21.B2_LOCAL = '03' OR SB21.B2_LOCAL = '98' ) "+CR
Else
	cQuery1 += " 	AND ( SB21.B2_LOCAL = '03' ) "+CR
EndIf

	cQuery1 += " 	AND B2_CMFIM1 > 0 "+CR
	cQuery1 += " 	),0) AS CMFIM1 "+CR
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
	cQuery1 += ",NVL((SELECT SUM(SB2.B2_QATU) "+CR
	cQuery1 += " FROM "+RetSqlName("SB2")+" SB2  "+CR
	cQuery1 += " WHERE SB2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "+CR
	cQuery1 += " 	AND SB2.B2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' ) "+CR
	cQuery1 += " 	),0) "+CR
	cQuery1 += " 	- "+CR
	cQuery1 += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6  "+CR
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CR
	cQuery1 += " ON SF4.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CR
	cQuery1 += " 	AND SF4.F4_ESTOQUE = 'S' "+CR
	cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5  "+CR
	cQuery1 += " ON SC5.C5_NUM = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CR
	cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC6.C6_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CR
	//cQuery += " 	AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery1 += " 	AND SC6.C6_OPER <> '38'  AND SC6.C6_OPER <> '11' "+CR//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery1 += " 	AND SC6.C6_BLQ <> 'R' "+CR
	cQuery1 += " 	AND SC6.C6_LOCAL <> '60'  "+CR //Ticket 20190710000072
	cQuery1 += " 	AND SC5.C5_TIPO = 'N' "+CR
	cQuery1 += " 	AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9  "+CR
	cQuery1 += " WHERE SC9.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SC9.C9_PEDIDO = SC6.C6_NUM "+CR
	cQuery1 += " 	AND SC9.C9_BLCRED In ('01','09') "+CR
	cQuery1 += " 	AND SC9.C9_FILIAL = SC6.C6_FILIAL) "+CR
	cQuery1 += " 	AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0) "+CR
	cQuery1 += " + "+CR
	cQuery1 += " NVL((SELECT "+CR
	cQuery1 += " SUM(D2_QUANT) "+CR
	cQuery1 += " FROM UDBP12.SD2010 SD2  "+CR
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SD2.D2_FILIAL = '05' "+CR
	cQuery1 += " 	AND SD2.D2_CLIENTE = '033467' "+CR

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220124001890 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery1 += " 	AND SD2.D2_LOJA = '02' "+CR
	ELSE
		cQuery1 += " 	AND SD2.D2_LOJA = '06' "+CR
	ENDIF

	//cQuery1 += " 	AND SD2.D2_DOC <> '000003279'   "+CR //NOTA COM ENTRADA ERRADA
	//cQuery1 += " 	AND SD2.D2_DOC <> '000004299'   "+CR //NOTA COM ENTRADA ERRADA  //giovani zago 09/11/14
	cQuery1 += " 	AND SD2.D2_EMISSAO  > '"+AllTrim(GetMv("RSTFATA301",,"2020"))+"0101' "+CR
	cQuery1 += " 	AND SD2.D2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND  NOT EXISTS (   SELECT * FROM "+RetSqlName("SF3")+" SF3  "+CR
	cQuery1 += " WHERE SF3.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SF3.F3_SERIE = SD2.D2_SERIE "+CR
	cQuery1 += " 	AND SF3.F3_NFISCAL = SD2.D2_DOC "+CR
	cQuery1 += " 	AND F3_OBSERV LIKE '%DENEGADA%') "+CR
	cQuery1 += " 	AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SD1")+" SD1  "+CR
	cQuery1 += " WHERE SD1.D_E_L_E_T_ =  ' ' "+CR
	cQuery1 += " 	AND SD1.D1_FILIAL='02' AND SD1.D1_FORNECE = '005866' "+CR
	cQuery1 += " 	AND SD1.D1_DOC = SD2.D2_DOC AND SD1.D1_SERIE= SD2.D2_SERIE)),0) AS A17_FALTA_TRANSITO "+CR

	cQuery1 += ",NVL((SELECT SUM(SC4.C4_QUANT) FROM "+RetSqlName("SC4")+" SC4  "+CR
	cQuery1 += " WHERE SC4.C4_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND   SC4.C4_FILIAL = '"+xFilial("SC4")+"' "+CR
	cQuery1 += " 	AND   SUBSTR(SC4.C4_DATA,1,6)  = '"+_cxMes01+"'),0) AS A19_PREV01 "+CR

	cQuery1 += ",NVL((SELECT SUM(SC4.C4_QUANT) FROM  "+RetSqlName("SC4")+" SC4  "+CR
	cQuery1 += " WHERE SC4.C4_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND   SC4.C4_FILIAL = '"+xFilial("SC4")+"' "+CR
	cQuery1 += " 	AND   SUBSTR(SC4.C4_DATA,1,6)  = '"+_cxMes02+"'),0) A20_PREV02 "+CR

	cQuery1 += ",NVL((SELECT SUM(SC4.C4_QUANT) FROM "+RetSqlName("SC4")+" SC4  "+CR
	cQuery1 += " WHERE SC4.C4_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND   SC4.C4_FILIAL = '"+xFilial("SC4")+"' "+CR
	cQuery1 += " 	AND   SUBSTR(SC4.C4_DATA,1,6)  = '"+_cxMes03+"'),0) A21_PREV03 "+CR

	cQuery1 += ",NVL((SELECT SUM(SC4.C4_QUANT) FROM "+RetSqlName("SC4")+" SC4  "+CR
	cQuery1 += " WHERE SC4.C4_PRODUTO = SB1.B1_COD "+CR
	cQuery1 += " 	AND   SC4.C4_FILIAL = '"+xFilial("SC4")+"' "+CR
	cQuery1 += " 	AND   SUBSTR(SC4.C4_DATA,1,6)  = '"+_cxMes04+"'),0) AS A22_PREV04 "+CR

	cQuery1 += " ,NVL((SELECT "+CR
	cQuery1 += " SUM(D2_QUANT) "+CR
	cQuery1 += " FROM "+RetSqlName("SD2")+" SD2 "+CR
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '   "+CR
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "'  "+CR
	cQuery1 += " 	AND SD2.D2_EMISSAO LIKE '" + substr(dtos(dDataBase),1,6) + "%'  "+CR
	cQuery1 += " 	AND SD2.D2_COD = SB1.B1_COD "+CR
	cQuery1 += " 	AND F4_ESTOQUE = 'S'  "+CR
	cQuery1 += " 	AND F4_DUPLIC = 'S'   "+CR
	cQuery1 += " 	),0) AS A23_FATUR_DENTRO_MES "+CR

	cQuery1 += " ,SB1.B1_XPREMES  AS A24_PREVISAO_MES "+CR
	cQuery1 += " ,SB1.B1_ESTSEG	 AS A25_ESTOQUE_SEGURANCA "+CR

	cQuery1 += ",NVL((SELECT "+CR
	cQuery1 += " SUM( "+CR
	cQuery1 += " FC6.C6_QTDVEN - FC6.C6_QTDENT) "+CR
	cQuery1 += " FROM UDBP12.SC6010 FC6 "+CR
	cQuery1 += " WHERE FC6.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND FC6.C6_CLI = '033467' "+CR

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220124001890 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery1 += " 	AND FC6.C6_FILIAL = '05' "+CR
		cQuery1 += " 	AND FC6.C6_LOJA = '02' "+CR
		cQuery1 += " 	AND FC6.C6_OPER = '94' "+CR
	ELSE
		cQuery1 += " 	AND FC6.C6_FILIAL = '05' "+CR
		cQuery1 += " 	AND FC6.C6_LOJA = '06' "+CR
		cQuery1 += " 	AND FC6.C6_OPER = '01' "+CR
	ENDIF
	cQuery1 += " 	AND FC6.C6_QTDVEN > FC6.C6_QTDENT "+CR
	cQuery1 += " 	AND FC6.C6_BLQ <> 'R' "+CR
	cQuery1 += " 	AND FC6.C6_PRODUTO = SB1.B1_COD),0) AS A26_SALDOMMGSP "+CR

	cQuery1 += " FROM "+RetSqlName("SB1")+" SB1 "+CR

	cQuery1 += " INNER JOIN(SELECT * FROM  "+RetSqlName("SBM")+" )SBM  "+CR
	cQuery1 += " ON SBM.D_E_L_E_T_ = ' ' "+CR
	cQuery1 += " 	AND SBM.BM_GRUPO = SB1.B1_GRUPO "+CR

	cQuery1 += " WHERE SB1.D_E_L_E_T_ = ' ' "+CR
	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Os produtoas agoara ser„o doi Tipo F-Fabricados e C-Comprados.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220124001890 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	cQuery1 += " 	AND   SB1.B1_CLAPROD IN('F','C') "+CR

	cQuery1 += " 	AND SB1.B1_COD   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CR
	cQuery1 += " 	AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CR
	cQuery1 += " 	AND SB1.B1_TIPO  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CR
	//Chamados 002926 e 002945 abre
	If Mv_Par07 = 1
		cQuery1 += " HAVING "+CR
		cQuery1 += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6  "+CR
		cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5  "+CR
		cQuery1 += " ON SC5.C5_NUM = SC6.C6_NUM  "+CR
		cQuery1 += " 	AND SC5.D_E_L_E_T_ = ' ' "+CR
		cQuery1 += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CR
		cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' ' "+CR
		cQuery1 += " 	AND SC6.C6_PRODUTO = SB1.B1_COD "+CR
		cQuery1 += " 	AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CR
		//cQuery1 += " 	AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
		cQuery1 += " 	AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11'  "+CR//pedido de ordem e remessa richeli 17/07/14 giovani
		cQuery1 += " 	AND SC6.C6_BLQ <> 'R' "+CR
		cQuery1 += " 	AND SC6.C6_LOCAL <> '60'  "+CR //Ticket 20190710000072
		cQuery1 += " 	AND SC5.C5_TIPO = 'N' "+CR
		cQuery1 += " 	AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9  "+CR
		cQuery1 += " WHERE SC9.D_E_L_E_T_ = ' ' "+CR
		cQuery1 += " 	AND SC9.C9_PEDIDO = SC6.C6_NUM "+CR
		cQuery1 += " 	AND SC9.C9_BLCRED In ('01','09') "+CR
		cQuery1 += " 	AND SC9.C9_FILIAL = SC6.C6_FILIAL) "+CR
		cQuery1 += " 	AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0) "+CR
		cQuery1 += " 	> 0 "+CR

		cQuery1 += " GROUP BY "+CR
		cQuery1 += " SB1.B1_COD "+CR
		cQuery1 += " ,TRIM(SB1.B1_DESC) "+CR
		cQuery1 += " ,SB1.B1_XABC "+CR
		cQuery1 += " ,SB1.B1_XFMR "+CR
		cQuery1 += " ,SB1.B1_MSBLQL "+CR
		cQuery1 += " ,SB1.B1_GRUPO "+CR
		cQuery1 += " ,TRIM(SBM.BM_DESC) "+CR
		cQuery1 += " ,SB1.B1_XPREMES "+CR
		cQuery1 += " ,SB1.B1_ESTSEG "+CR
	Endif
	//Chamados 002926 e 002945 fecha
	cQuery1 += "  ORDER BY A17_FALTA_TRANSITO "+CR
	//cQuery1 := ChangeQuery(cQuery1)
	If Select(cAlias1) > 0
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return
