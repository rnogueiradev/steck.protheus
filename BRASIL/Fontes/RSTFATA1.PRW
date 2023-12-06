#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "Tbiconn.ch"
#include "rptdef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFATA1  บAutor  ณJoใo Victor         บ Data ณ  15/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio MMG Filiais STECK SP                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RSTFATA1(lJobAuto)
	Local   oReport
	Local 	nX := 0
	Private cPerg 		 := "RSTFATA1"
	Private cPerg1     := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime      := Time()
	Private cHora      := SUBSTR(cTime, 1, 2)
	Private cMinutos   := SUBSTR(cTime, 4, 2)
	Private cSegundos  := SUBSTR(cTime, 7, 2)
	Private cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Private cPergTit 	 := cAliasLif
	Private cAlias1    := GetNextAlias()
	Private cAlias2    := GetNextAlias()
	Private _cTitulo   := "Relat๓rio MMG SP"
	Private _cDescri   := "Este programa irแ imprimir um relat๓rio MMG SP"
	Private _cSection1 := "MMG SP"
	Private cPastaRel 		:= "\arquivos\"
	Private carquivo_       := 	"RSTFATA1"
	Private cAnexo			:= ""
	Private cPara 			:= SuperGetMV("ST_RSFATA1",.F.,"henrique.youssef@steck.com.br;rafael.rivani@steck.com.br;david.junior@steck.com.br")
	Private cLocEst			:= SUPERGETMV("FS_RSFATA1",.f., "01|03|15|16|17|18|19" )
	Private aLocEst			:= StrTokArr(cLocEst,"|")

	Default lJobAuto 	:= .F.
	If lJobAuto
		For nX := 1 To 2 //Roda 2 x
			If nX == 1
				//Cria as defini็๕es do relat๓rio
				oReport := ReportDef()

				MV_PAR01 := Space(6)
				MV_PAR02 := Replicate("Z",6)
				MV_PAR03 := Space(6)
				MV_PAR04 := Replicate("Z",15)
				MV_PAR05 := CTOD("01/01/2000")
				MV_PAR06 := CTOD("31/12/2030")
				MV_PAR07 := 2
				MV_PAR08 := 1
				MV_PAR09 := 1

				//Define um nome do arquivo dentro da Protheus Data - pasta 'x_arquivos'
				cAnexo := carquivo_ + dToS(dDataBase) + StrTran(Time(), ":", "-") + ".xls"

				//Define para o relat๓rio nใo mostrar na tela, o Device 4 (Planilha), define o arquivo, e define para imprimir

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
					//Cria as defini็๕es do relat๓rio
					oReport := ReportDef()

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
					cMsg += '<br><br>Olแ <b></b>,<br><br> ' //cMsg += '<br><br>Olแ <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
					cMsg += 'Voc๊ estแ recebendo o '+ Alltrim(_cTitulo) +' da Steck!<br>
					cMsg += 'Obrigado!<br><br>'
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Ind๚stria El้trica Ltda
					cMsg += '</body></html>'

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,cPastaRel)  //nใo funcionou

					cParada := ""
					//oReport:PrintDialog()
				EndIf
			EndIf
		Next nX
	Else

		VALIDPERG(cPerg)
		oReport	:= ReportDef()
		oReport:PrintDialog()
	EndIf
Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  15/10/15   บฑฑ
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
	Local nX := 0
	Local oSection1
	//Local oSection2
	//Local oSection3
	//Local oSection4
	//Local oSection5
	//Local oSection6

	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 10

	Pergunte(cPerg,.F.)

	//Primeira Se็ใo
	oSection1 := TRSection():New(oReport,_cSection1,{cAlias1})
	TRCell():New(oSection1,"A1"  ,,"Pedido Venda"       ,PesqPict("SC5","C5_NUM")         ,TamSX3("C5_NUM")       [1]+2)
	TRCell():New(oSection1,"A2"  ,,"Pedido Compra"      ,PesqPict("SC5","C5_ZNUMPC")      ,TamSX3("C5_ZNUMPC")    [1]+2)
	TRCell():New(oSection1,"A3"  ,,"Produto"            ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection1,"A25" ,,"Descricao"          ,PesqPict("SB1","B1_DESC")        ,TamSX3("B1_DESC")      [1]+2) //JACKSON
	TRCell():New(oSection1,"A4"  ,,"Grupo"              ,PesqPict("SBM","BM_GRUPO")       ,TamSX3("BM_GRUPO")     [1]+2)

	TRCell():New(oSection1,"A15"  ,,"Desc Grupo"         ,PesqPict("SBM","BM_DESC")       ,TamSX3("BM_DESC")     [1]+2)
	//TRCell():New(oSection1,"A16"  ,,"Agrupamento"        ,PesqPict("SX5","X5_DESCRI")     ,TamSX3("X5_DESCRI")   [1]+2) JACKSON

	TRCell():New(oSection1,"A5"  ,,"Qtde. Original"     ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection1,"A6"  ,,"Qtde. Embalado"     ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection1,"A7"  ,,"Qtde. Saldo"        ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection1,"A8"  ,,"Item PV"            ,PesqPict("SC6","C6_ITEM")        ,TamSX3("C6_ITEM")      [1]+2)
	TRCell():New(oSection1,"A9"  ,,"Motivo"             ,PesqPict("SC6","C6_ZMOTPC")      ,TamSX3("C6_ZMOTPC")    [1]+2)
	TRCell():New(oSection1,"A10" ,,"Dt. Emissใo"        ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection1,"A18" ,,"Dt. Entrega"        ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection1,"A19" ,,"Entrega 1"          ,PesqPict("SC6","C6_ENTREG")      ,TamSX3("C6_ENTREG")    [1]+2) //JACKSON

	TRCell():New(oSection1,"A17" ,,"ฺltimo envio"        ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)

	TRCell():New(oSection1,"A11" ,,"Programa็ใo"        ,PesqPict("SC6","C6_NUM")         ,TamSX3("C6_NUM")       [1]+2)

	TRCell():New(oSection1,"A20" ,,"MTO/ MTS "          ,PesqPict("SB1","B1_XMTO")        ,TamSX3("B1_XMTO")      [1]+2) //JACKSON
	TRCell():New(oSection1,"A21" ,,"Custo Unitแrio"     ,PesqPict("SC6","C6_PRCVEN")      ,TamSX3("C6_PRCVEN")    [1]+2) //JACKSON
	TRCell():New(oSection1,"A22" ,,"Pre็o Venda"        ,PesqPict("SC6","C6_PRCVEN")      ,TamSX3("C6_PRCVEN")    [1]+2) //JACKSON
	TRCell():New(oSection1,"A23" ,,"Lead Time Logada"   ,PesqPict("SB1","B1_TIPE")        ,TamSX3("B1_TIPE")      [1]+2) //JACKSON
	TRCell():New(oSection1,"A24" ,,"Lead Time CD"       ,PesqPict("SB1","B1_TIPE")        ,TamSX3("B1_TIPE")      [1]+2) //JACKSON
	//jackson
	ns:=25
	for nx := 1 to len(aLocEst)

		TRCell():New(oSection1,"A"+strzero(++ns,2) ,,"Saldo em estoque (Armaz้m "+aLocEst[nX]+") "        ,PesqPict("SC6","C6_PRCVEN")      ,TamSX3("C6_PRCVEN")    [1]+2)

	NEXT

	TRCell():New(oSection1,"A12" ,,"Cliente"            ,PesqPict("SC5","C5_CLIENTE")     ,TamSX3("C5_CLIENTE")   [1]+2)
	TRCell():New(oSection1,"A13" ,,"Lj         "        ,PesqPict("SC5","C5_LOJACLI")     ,TamSX3("C5_LOJACLI")   [1]+2)
	TRCell():New(oSection1,"A14" ,,"Razใo Social"       ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

	TRFunction():New(oSection1:Cell("A3") ,NIL,"COUNT",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A5") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("A7") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  15/10/15   บฑฑ
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
	Local nX		    := 0
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
//	oSection1:Cell("A16"):SetBlock( { || aDados1[16] } )

	oSection1:Cell("A17"):SetBlock( { || aDados1[17] } )
	oSection1:Cell("A18"):SetBlock( { || aDados1[18] } )

//JACKSON
	oSection1:Cell("A19"):SetBlock( { || aDados1[19] } )
	oSection1:Cell("A20"):SetBlock( { || aDados1[20] } )
	oSection1:Cell("A21"):SetBlock( { || aDados1[21] } )
	oSection1:Cell("A22"):SetBlock( { || aDados1[22] } )
	oSection1:Cell("A23"):SetBlock( { || aDados1[23] } )
	oSection1:Cell("A24"):SetBlock( { || aDados1[24] } )
	oSection1:Cell("A25"):SetBlock( { || aDados1[25] } )
//	NS:=25
//	for nx := 1 to len(aLocEst)
//		oSection1:Cell("L"+aLocEst[nX]):SetBlock( { || aDados1[++NS] } )
//	NEXT
	oSection1:Cell("A26"):SetBlock( { || aDados1[26] } )
	oSection1:Cell("A27"):SetBlock( { || aDados1[27] } )
	oSection1:Cell("A28"):SetBlock( { || aDados1[28] } )
	oSection1:Cell("A29"):SetBlock( { || aDados1[29] } )
	oSection1:Cell("A30"):SetBlock( { || aDados1[30] } )
	oSection1:Cell("A31"):SetBlock( { || aDados1[31] } )
	oSection1:Cell("A32"):SetBlock( { || aDados1[32] } )

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
			aDados1[01]	:= (cAlias1)->A1_PEDIDO
			aDados1[02]	:= (cAlias1)->A2_PC
			aDados1[03]	:= (cAlias1)->A3_CODIGO
			aDados1[04]	:= (cAlias1)->A4_GRUPO
			aDados1[05]	:= (cAlias1)->A5_QUANTIDADE
			aDados1[06]	:= (cAlias1)->A6_EMBALAGEM
			aDados1[07]	:= (cAlias1)->A7_SALDO
			aDados1[08]	:= (cAlias1)->A8_ITEM
			aDados1[09]	:= (cAlias1)->A9_MOTIVO
			aDados1[10]	:= (cAlias1)->A10_EMISSAO
			aDados1[11]	:= (cAlias1)->A11_PROGRAMACAO
			aDados1[12]	:= (cAlias1)->A12_CLIENTE
			aDados1[13]	:= (cAlias1)->A13_LOJA
			aDados1[14]	:= (cAlias1)->A14_NOME

			aDados1[15]	:= (cAlias1)->BM_DESC
			aDados1[16]	:= (cAlias1)->AGRUP

			aDados1[17]	:= STOD((cAlias1)->ULTENV)
			aDados1[18]	:= STOD((cAlias1)->A18_XDTEN)

			//JACKSON
			aDados1[19]	:= STOD((cAlias1)->A19_ENTREG)
			aDados1[20]	:= (cAlias1)->A20_XMTO
			aDados1[21]	:= (cAlias1)->A21_CM1
			aDados1[22]	:= (cAlias1)->A22_PRCVEN
			aDados1[23]	:= (cAlias1)->A23_TIPE
			aDados1[24]	:= (cAlias1)->A24_TIPE
			aDados1[25]	:= (cAlias1)->A25_DESC

			nS := 25
			cFilEst:=''

			If Mv_Par07 = 1
				cFilEst := '01'
			ElseIf Mv_Par07 = 2
				cFilEst := '02'
			ElseIf Mv_Par07 = 3
				cFilEst := '02'
			ElseIf Mv_Par07 = 4
				cFilEst := '04'
			ElseIf Mv_Par07 = 5
				cFilEst := '05'
			EndIf


			for nx := 1 to len(aLocEst)

				DbSelectArea("SB2")
				DbSetOrder(1)

				if SB2->(dBSEEK(cFilEst+(cAlias1)->A3_CODIGO+aLocEst[NX]))
					aDados1[++ns]	:= SB2->B2_QATU
				ELSE
					aDados1[++ns]	:= 0
				ENDIF

			NEXT


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
	ฑฑบPrograma  |StQuery  บAutor  ณJoใo Victor         บ Data ณ  15/10/15    บฑฑ
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

	If Mv_Par08 = 1

			/*******************************************
			<<< ALTERAวรO >>> 
			A็ใo...........: Receber via parโmetro a Empresa e Filial.
			Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
			Data...........: 25/01/2021
			Chamado........: 20220114001125 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
			Vou ter que fixar o acesso a as tabelas para que busquem da empresa 01 trocando RetSqlName por UDBP12.
			******************************************/
		IF MV_PAR07 <> 5
			cQuery1 := "  SELECT
			cQuery1 += "  SC6.C6_NUM     AS A1_PEDIDO
			cQuery1 += " ,C5_ZNUMPC      AS A2_PC
			cQuery1 += " ,SC6.C6_PRODUTO AS A3_CODIGO
			cQuery1 += " ,SC6.C6_DESCRI  AS A25_DESC "   //JACKSON
			cQuery1 += " ,SC6.C6_ENTREG  AS A19_ENTREG " //JACKSON
			cQuery1 += " ,SC6.C6_PRCVEN  AS A22_PRCVEN " //JACKSON
			cQuery1 += " ,(SELECT B1_XMTO  FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A20_XMTO " //JACKSON
			cQuery1 += " ,(SELECT B1_TIPE  FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A23_TIPE " //JACKSON
			cQuery1 += " ,(SELECT B1_TIPE  FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A24_TIPE " //JACKSON
			cQuery1 += " ,SC6.C6_PRCVEN  AS A21_CM1 " //JACKSON
			cQuery1 += " ,(SELECT B1_GRUPO FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A4_GRUPO
			cQuery1 += " ,SC6.C6_QTDVEN  AS A5_QUANTIDADE
			cQuery1 += " ,NVL((SELECT SUM(ZZU_QTDE)  FROM "+AllTrim(GetMv("STALIASIND"))+".ZZU010 ZZU INNER JOIN(SELECT * FROM "+AllTrim(GetMv("STALIASIND"))+".ZZT010) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N'  AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) AS A6_EMBALAGEM   " //Chamado 007618
			cQuery1 += " ,(SC6.C6_QTDVEN - SC6.C6_QTDENT) AS A7_SALDO
			cQuery1 += " ,SC6.C6_ITEM    AS A8_ITEM
			cQuery1 += " ,SC6.C6_ZMOTPC  AS A9_MOTIVO
			cQuery1 += " ,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) AS A10_EMISSAO
			cQuery1 += " ,C5_ZMESPC||'/'||C5_ZANOPC AS A11_PROGRAMACAO
			cQuery1 += " ,C5_CLIENTE     AS A12_CLIENTE
			cQuery1 += " ,C5_LOJACLI     AS A13_LOJA
			cQuery1 += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END AS A18_XDTEN"

			/*******************************************
			<<< ALTERAวรO >>> 
			A็ใo...........: Receber via parโmetro a Empresa e Filial.
			Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
			Data...........: 25/01/2021
			Chamado........: 20220114001125 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
			Incluido a Loja "06" que respresenta a empresa 11 - NEWCO
			******************************************/
			cQuery1 += " ,CASE WHEN C5_LOJACLI = '01'  THEN 'STECK FมBRICA MENDES DA ROCHA' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '02'  THEN 'STECK CENTRO DE DISTRIBUIวรO ' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '03'  THEN 'STECK LIMAO ' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '04'  THEN 'STECK FABRICA ITAQUERA ' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '05'  THEN 'STECK FABRICA GUARAREMA ' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '06'  THEN 'STECK DISTRIBUIDORA ' ELSE
			cQuery1 += "  CASE WHEN C5_LOJACLI = '09'  THEN 'SCHNEIDER' ELSE 'NC'
			cQuery1 += " END END END END END END END AS A14_NOME,BM_DESC,X5_DESCRI AGRUP, MAX(D2_EMISSAO) ULTENV

			cQuery1 += " FROM "+AllTrim(GetMv("STALIASIND"))+".SC6010 SC6

			cQuery1 += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SD2010 D2
			cQuery1 += " ON D2_FILIAL=SC6.C6_FILIAL AND D2_PEDIDO=SC6.C6_NUM AND D2_ITEMPV=C6_ITEM AND D2.D_E_L_E_T_=' '

			cQuery1 += " INNER JOIN( SELECT * FROM "+AllTrim(GetMv("STALIASIND"))+".SC5010)SC5
			cQuery1 += " ON SC5.D_E_L_E_T_ = ' '
			cQuery1 += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
			cQuery1 += " AND SC5.C5_NUM    = SC6.C6_NUM

			cQuery1 += " LEFT JOIN(SELECT * FROM "+AllTrim(GetMv("STALIASIND"))+".SC6010) TC6
			cQuery1 += " ON TC6.D_E_L_E_T_ = ' '
			cQuery1 += " AND TC6.C6_FILIAL IN ('04','05')
			cQuery1 += " AND TC6.C6_CLI = '033467'

			If mv_par09==1
				cQuery1 += " AND TC6.C6_QTDVEN > TC6.C6_QTDENT
			EndIf

			/*******************************************
			<<< ALTERAวรO >>> 
			A็ใo...........: Receber via parโmetro a Empresa e Filial.
			Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
			Data...........: 25/01/2021
			Chamado........: 20220114001125 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
			Incluido o Tipo de Opera็ใo "01" a empresa 11 - NEWCO estแ agora vendendo nใo mais trasnferindo
			******************************************/
			cQuery1 += " AND TC6.C6_BLQ <> 'R'
			cQuery1 += " AND TC6.C6_OPER IN ('01','94')
			cQuery1 += " AND TC6.R_E_C_N_O_ <= SC6.R_E_C_N_O_
			cQuery1 += " AND TC6.C6_PRODUTO = SC6.C6_PRODUTO

			cQuery1 += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 ON B1_COD=SC6.C6_PRODUTO AND B1.D_E_L_E_T_=' '
			cQuery1 += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SBM010 BM ON BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '
			cQuery1 += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SX5010 X5 ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP  AND X5.D_E_L_E_T_=' ' WHERE SC6.D_E_L_E_T_ = ' '

			If mv_par09==1
				cQuery1 += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			EndIf

			cQuery1 += " AND SC6.C6_BLQ <> 'R'

			cQuery1 += " AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X'
			cQuery1 += " AND SC6.C6_NUM     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
			cQuery1 += " AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
			cQuery1 += " AND SC5.C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"'
/* voltar*/
			If Mv_Par07 = 1
				cQuery1 += " AND SC6.C6_CLI = '033467'
				cQuery1 += " AND SC6.C6_OPER = '94'
				cQuery1 += " AND SC6.C6_FILIAL = '02'
				cQuery1 += " AND SC6.C6_LOJA   = '01'
			ElseIf Mv_Par07 = 2
				/*******************************************
				<<< ALTERAวรO >>> 
				A็ใo...........: Receber via parโmetro a Empresa e Filial.
				Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
				Data...........: 25/01/2021
				Chamado........: 20220114001125 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
				Estou unificando 	no parโmetro o CD antigo e a empresa  11 - NEWCO
				Incluido a Loja "06" que respresenta a empresa 11 - NEWCO
				******************************************/
				cQuery1 += " AND SC6.C6_OPER IN('01','94')
				cQuery1 += " AND SC6.C6_CLI = '033467'
				cQuery1 += " AND SC6.C6_FILIAL IN ('04','05')
				cQuery1 += " AND SC6.C6_LOJA IN ('02','06')
			ElseIf Mv_Par07 = 3
				/*******************************************
				<<< ALTERAวรO >>> 
				A็ใo...........: Receber via parโmetro a Empresa e Filial.
				Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
				Data...........: 25/01/2021
				Chamado........: 20220114001125 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
				Incluido o Tipo de Opera็ใo "01" a empresa 11 - NEWCO estแ agora vendendo nใo mais trasnferindo
				Incluido a Loja "06" que respresenta a empresa 11 - NEWCO
				******************************************/
				cQuery1 += " AND SC6.C6_OPER IN ('01','94')
				cQuery1 += " AND SC6.C6_CLI = '033467'
				cQuery1 += " AND SC6.C6_FILIAL IN ('04','05','02')
				cQuery1 += " AND SC6.C6_LOJA   IN ('01','02','06')
			ElseIf Mv_Par07 = 4
				cQuery1 += " AND SC6.C6_CLI = '012047'
				cQuery1 += " AND SC6.C6_FILIAL = '05'
				cQuery1 += " AND SC6.C6_LOJA  = '09'
			EndIf

		cQuery1 += " GROUP BY SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM ,SC6.C6_QTDVEN, SC6.R_E_C_N_O_ ,SC6.C6_QTDVEN - SC6.C6_QTDENT,SC5.C5_EMISSAO,SC6.C6_ZMOTPC,C5_ZMESPC||'/'||C5_ZANOPC,C5_ZNUMPC,C5_CLIENTE,C5_LOJACLI,"
		cQuery1 += " CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END, BM_DESC,X5_DESCRI,"
		cQuery1 += " SC6.C6_DESCRI,SC6.C6_ENTREG,SC6.C6_PRCVEN "
		cQuery1 += " ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_
	else
		cQuery1 := getMntEX()          // Valdemir Rabelo 19/07/2021
	endif
Else


	cQuery1 := "  SELECT
	cQuery1 += "  SC6.C6_NUM     AS A1_PEDIDO
	cQuery1 += " ,C5_ZNUMPC      AS A2_PC
	cQuery1 += " ,SC6.C6_PRODUTO AS A3_CODIGO
	cQuery1 += " ,SC6.C6_DESCRI  AS A25_DESC "   //JACKSON
	cQuery1 += " ,SC6.C6_ENTREG  AS A19_ENTREG " //JACKSON
	cQuery1 += " ,SC6.C6_PRCVEN  AS A22_PRCVEN " //JACKSON
	cQuery1 += " ,(SELECT B1_XMTO  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A20_XMTO " //JACKSON
	cQuery1 += " ,(SELECT B1_TIPE  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A23_TIPE " //JACKSON
	cQuery1 += " ,(SELECT B1_TIPE  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A24_TIPE " //JACKSON
	cQuery1 += " ,SC6.C6_PRCVEN  AS A21_CM1 " //JACKSON
	cQuery1 += " ,(SELECT B1_GRUPO FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A4_GRUPO
	cQuery1 += " ,SC6.C6_QTDVEN  AS A5_QUANTIDADE
	cQuery1 += " ,0 AS A6_EMBALAGEM
	cQuery1 += " ,(SC6.C6_QTDVEN - SC6.C6_QTDENT) AS A7_SALDO
	cQuery1 += " ,SC6.C6_ITEM    AS A8_ITEM
	cQuery1 += " ,SC6.C6_ZMOTPC  AS A9_MOTIVO
	cQuery1 += " ,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) AS A10_EMISSAO
	cQuery1 += " ,C5_ZMESPC||'/'||C5_ZANOPC AS A11_PROGRAMACAO
	cQuery1 += " ,C5_CLIENTE     AS A12_CLIENTE
	cQuery1 += " ,C5_LOJACLI     AS A13_LOJA
	cQuery1 += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END AS A18_XDTEN"
	cQuery1 += " ,'AM'   AS A14_NOME,BM_DESC,NVL(X5_DESCRI,' ') AGRUP, MAX(D2_EMISSAO) ULTENV"

	cQuery1 += " FROM " + RetSqlName("SC6") + " SC6

	cQuery1 += " LEFT JOIN " + RetSqlName("SD2") + " D2
	cQuery1 += " ON D2_FILIAL=SC6.C6_FILIAL AND D2_PEDIDO=SC6.C6_NUM AND D2_ITEMPV=C6_ITEM AND D2.D_E_L_E_T_=' '

	cQuery1 += " INNER JOIN ( SELECT * FROM " + RetSqlName("SC5") + ") SC5
	cQuery1 += " ON SC5.D_E_L_E_T_ = ' '
	cQuery1 += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery1 += " AND SC5.C5_NUM    = SC6.C6_NUM

	cQuery1 += " LEFT JOIN ( SELECT * FROM " + RetSqlName("SC6") + ") TC6
	cQuery1 += " ON TC6.D_E_L_E_T_ = ' '
	cQuery1 += " AND TC6.C6_FILIAL = '05'
	cQuery1 += " AND TC6.C6_CLI = '035444'

	If mv_par09==1
		cQuery1 += " AND TC6.C6_QTDVEN > TC6.C6_QTDENT
	EndIf

	cQuery1 += " AND TC6.C6_BLQ <> 'R' AND SUBSTR(C5_NOTA,1,1)<>'X'
	cQuery1 += " AND TC6.C6_OPER = '85'
	cQuery1 += " AND TC6.R_E_C_N_O_ <= SC6.R_E_C_N_O_
	cQuery1 += " AND TC6.C6_PRODUTO = SC6.C6_PRODUTO

	cQuery1 += " LEFT JOIN " + RetSqlName("SB1") + " B1"
	cQuery1 += " ON B1_COD=SC6.C6_PRODUTO
	//JACKSON
	cQuery1 += " LEFT JOIN SBM010 BM
	cQuery1 += " ON BM_GRUPO=B1_GRUPO
	cQuery1 += " LEFT JOIN SX5010 X5
//		cQuery1 += " LEFT JOIN " + RetSqlName("SBM") + " BM
//		cQuery1 += " ON BM_GRUPO=B1_GRUPO
//		cQuery1 += " LEFT JOIN " + RetSqlName("SX5") + " X5
	cQuery1 += " ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP AND X5.D_E_L_E_T_=' '

	cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' '

	cQuery1 += " AND B1.D_E_L_E_T_=' ' AND BM.D_E_L_E_T_=' '

	cQuery1 += " AND SC6.C6_CLI = '035444' 

	If mv_par09==1
		cQuery1 += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	EndIf

	cQuery1 += " AND SC6.C6_BLQ <> 'R'
	cQuery1 += " AND SC6.C6_OPER = '85' 
	cQuery1 += " AND SC6.C6_NUM     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery1 += " AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery1 += " AND SC5.C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"'
	cQuery1 += " AND SC6.C6_FILIAL = '05' 
	cQuery1 += " AND SC6.C6_LOJA   = '01' 
	cQuery1 += " GROUP BY SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM ,SC6.C6_QTDVEN, SC6.R_E_C_N_O_ ,SC6.C6_QTDVEN - SC6.C6_QTDENT,SC5.C5_EMISSAO,SC6.C6_ZMOTPC,C5_ZMESPC||'/'||C5_ZANOPC,C5_ZNUMPC,C5_CLIENTE,C5_LOJACLI, "
	cQuery1 += " CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END, BM_DESC,X5_DESCRI, "
	cQuery1 += " SC6.C6_DESCRI,SC6.C6_ENTREG,SC6.C6_PRCVEN "
	cQuery1 += " ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_
EndIf

cQuery1 := ChangeQuery(cQuery1)

If Select(cAlias1) > 0
	(cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return()


/*/{Protheus.doc} getMntEX
@description
Rotina que irแ filtrar os dados de exporta็ใo
Ticket: 20210420006308
@type function
@version  1.00
@author Valdemir Jose
@since 19/07/2021
@return variant, return_description
/*/
Static Function getMntEX()
	Local cQuery1 := ""
/*
SE ARGENTINA: 096015
SE CHILE: 098927
SE COLิMBIA: 098802
SE MษXICO: 070558
SE PERU: 099074
Se Marisio: 099116
Se ํndia: 099442
Se Espanha: 099479
*/
		cQuery1 := "  SELECT
		cQuery1 += "  SC6.C6_NUM     AS A1_PEDIDO
		cQuery1 += " ,C5_ZNUMPC      AS A2_PC
		cQuery1 += " ,SC6.C6_PRODUTO AS A3_CODIGO
		cQuery1 += " ,SC6.C6_DESCRI  AS A25_DESC "   //JACKSON
		cQuery1 += " ,SC6.C6_ENTREG  AS A19_ENTREG " //JACKSON
		cQuery1 += " ,SC6.C6_PRCVEN  AS A22_PRCVEN " //JACKSON
		cQuery1 += " ,(SELECT B1_XMTO  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A20_XMTO " //JACKSON
		cQuery1 += " ,(SELECT B1_TIPE  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A23_TIPE " //JACKSON
		cQuery1 += " ,(SELECT B1_TIPE  FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A24_TIPE " //JACKSON
		cQuery1 += " ,SC6.C6_PRCVEN  AS A21_CM1 " //JACKSON
		cQuery1 += " ,(SELECT B1_GRUPO FROM " + RetSqlName("SB1") + " B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO) AS A4_GRUPO
		cQuery1 += " ,SC6.C6_QTDVEN  AS A5_QUANTIDADE
		cQuery1 += " ,NVL((SELECT SUM(ZZU_QTDE)  FROM "+RetSqlName("ZZU")+" ZZU INNER JOIN(SELECT * FROM "+RetSqlName("ZZT")+") ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N'  AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) AS A6_EMBALAGEM   " //Chamado 007618
		cQuery1 += " ,(SC6.C6_QTDVEN - SC6.C6_QTDENT) AS A7_SALDO
		cQuery1 += " ,SC6.C6_ITEM    AS A8_ITEM
		cQuery1 += " ,SC6.C6_ZMOTPC  AS A9_MOTIVO
		cQuery1 += " ,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) AS A10_EMISSAO
		cQuery1 += " ,C5_ZMESPC||'/'||C5_ZANOPC AS A11_PROGRAMACAO
		cQuery1 += " ,C5_CLIENTE     AS A12_CLIENTE
		cQuery1 += " ,C5_LOJACLI     AS A13_LOJA
		cQuery1 += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END AS A18_XDTEN"
		cQuery1 += " ,CASE WHEN C5_CLIENTE = '096015'  THEN 'ARGENTINA' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '098927'  THEN 'CHILE' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '098802'  THEN 'COLOMBIA' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '070558'  THEN 'MEXICO' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '099074'  THEN 'PERU' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '099116'  THEN 'MARISIO' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '099442'  THEN 'INDIA' ELSE
		cQuery1 += "  CASE WHEN C5_CLIENTE = '099479'  THEN 'ESPANHA' ELSE
		cQuery1 += "  'NC' END END END END END END END END AS A14_NOME,BM_DESC,X5_DESCRI AGRUP, MAX(D2_EMISSAO) ULTENV

		cQuery1 += " FROM "+RetSqlName("SC6")+" SC6

		cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
		cQuery1 += " ON D2_FILIAL=SC6.C6_FILIAL AND D2_PEDIDO=SC6.C6_NUM AND D2_ITEMPV=C6_ITEM AND D2.D_E_L_E_T_=' '

		cQuery1 += " INNER JOIN( SELECT * FROM "+RetSqlName("SC5")+")SC5
		cQuery1 += " ON SC5.D_E_L_E_T_ = ' '
		cQuery1 += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
		cQuery1 += " AND SC5.C5_NUM    = SC6.C6_NUM

		cQuery1 += " LEFT JOIN(SELECT * FROM "+RetSqlName("SC6")+") TC6
		cQuery1 += " ON TC6.D_E_L_E_T_ = ' '
		cQuery1 += " AND TC6.C6_FILIAL IN ('04','05')
		cQuery1 += " AND TC6.C6_CLI IN('096015','098927','098802','070558','099074','099116','099442','099479')

		If mv_par09==1
			cQuery1 += " AND TC6.C6_QTDVEN > TC6.C6_QTDENT
		EndIf

		cQuery1 += " AND TC6.C6_BLQ <> 'R'
		cQuery1 += " AND TC6.C6_OPER = '94'
		cQuery1 += " AND TC6.R_E_C_N_O_ <= SC6.R_E_C_N_O_
		cQuery1 += " AND TC6.C6_PRODUTO = SC6.C6_PRODUTO

//	cQuery1 += " LEFT JOIN " + RetSqlName("SB1") + " B1
//	cQuery1 += " ON B1_COD=SC6.C6_PRODUTO AND B1.D_E_L_E_T_=' '
//	cQuery1 += "  LEFT JOIN " + RetSqlName("SBM") + " BM
//	cQuery1 += "  ON BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '
//	cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + "X5
		//JACKSON
		cQuery1 += " LEFT JOIN SB1010 B1
		cQuery1 += " ON B1_COD=SC6.C6_PRODUTO AND B1.D_E_L_E_T_=' '
		cQuery1 += "  LEFT JOIN SBM010 BM
		cQuery1 += "  ON BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '
		cQuery1 += "  LEFT JOIN SX5010 X5
		cQuery1 += "  ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP  AND X5.D_E_L_E_T_=' '
		cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' '

		If mv_par09==1
			cQuery1 += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
		EndIf

		cQuery1 += " AND SC6.C6_BLQ <> 'R'

		cQuery1 += " AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X'
		cQuery1 += " AND SC6.C6_NUM     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
		cQuery1 += " AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
		cQuery1 += " AND SC5.C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"'

		cQuery1 += " AND SC6.C6_CLI IN('096015','098927','098802','070558','099074','099116','099442','099479')
		//cQuery1 += " AND SC6.C6_OPER = '94'
		cQuery1 += " AND SC6.C6_FILIAL = '05'
		cQuery1 += " AND SC6.C6_LOJA   = '01'

		cQuery1 += " GROUP BY SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM ,SC6.C6_QTDVEN, SC6.R_E_C_N_O_ ,SC6.C6_QTDVEN - SC6.C6_QTDENT,SC5.C5_EMISSAO,SC6.C6_ZMOTPC,C5_ZMESPC||'/'||C5_ZANOPC,C5_ZNUMPC,C5_CLIENTE,C5_LOJACLI,"
		cQuery1 += " CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END, BM_DESC,X5_DESCRI,"
		cQuery1 += " SC6.C6_DESCRI,SC6.C6_ENTREG,SC6.C6_PRCVEN "
		cQuery1 += " ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_

/*
	cQuery1 := "  SELECT
	cQuery1 += "  EE8.EE8_PEDIDO     AS A1_PEDIDO
	cQuery1 += " ,' '      AS A2_PC
	cQuery1 += " ,EE8.EE8_COD_I AS A3_CODIGO
	cQuery1 += " ,(SELECT B1_GRUPO FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=EE8.EE8_COD_I) AS A4_GRUPO
	cQuery1 += " ,EE8.EE8_SLDINI  AS A5_QUANTIDADE
	cQuery1 += " ,NVL((SELECT SUM(ZZU_QTDE)  FROM "+RetSqlName("ZZU")+" ZZU INNER JOIN(SELECT * FROM "+RetSqlName("ZZT")+") ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N'  AND ZZU.ZZU_PRODUT   = EE8.EE8_COD_I),0) AS A6_EMBALAGEM   " 
	cQuery1 += " ,EE8.QEE8_SLDINI AS A7_SALDO
	cQuery1 += " ,EE8.EE8_SEQUEN  AS A8_ITEM
	cQuery1 += " ,' '  AS A9_MOTIVO
	cQuery1 += " ,SUBSTR(EE7.EE7_DTPEDI,7,2)||'/'|| SUBSTR(EE7.EE7_DTPEDI,5,2)||'/'|| SUBSTR(EE7.EE7_DTPEDI,1,4) AS A10_EMISSAO
	cQuery1 += " ,' ' AS A11_PROGRAMACAO
	cQuery1 += " ,EE7_CLIENT     AS A12_CLIENTE
	cQuery1 += " ,EE7_CLLOJA     AS A13_LOJA
	cQuery1 += " ,CASE WHEN EE8.EE8_DTENTR < EE8.EE8_DTENTR THEN EE8.EE8_DTENTR ELSE EE8.EE8_DTENTR END AS A18_XDTEN" 
	cQuery1 += " ,CASE WHEN EE7_CLLOJA = '01'  THEN 'STECK FมBRICA MENDES DA ROCHA' ELSE
	cQuery1 += "  CASE WHEN EE7_CLLOJA = '02'  THEN 'STECK CENTRO DE DISTRIBUIวรO ' ELSE
	cQuery1 += "  CASE WHEN EE7_CLLOJA = '03'  THEN 'STECK LIMAO ' ELSE
	cQuery1 += "  CASE WHEN EE7_CLLOJA = '04'  THEN 'STECK FABRICA ITAQUERA ' ELSE
	cQuery1 += "  CASE WHEN EE7_CLLOJA = '05'  THEN 'STECK FABRICA GUARAREMA ' ELSE
	cQuery1 += "  CASE WHEN EE7_CLLOJA = '09'  THEN 'SCHNEIDER' ELSE
	cQuery1 += "  'NC' END END END END END END AS A14_NOME,BM_DESC,X5_DESCRI AGRUP, MAX(D2_EMISSAO) ULTENV

	cQuery1 += " FROM "+RetSqlName("EE8")+" EE8

	cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
	cQuery1 += " ON D2_FILIAL=EE8.EE8_FILIAL AND D2_PEDIDO=EE7.EE7_PEDFAT AND D2_ITEMPV=EE8_FATIT AND D2.D_E_L_E_T_=' '

	cQuery1 += " INNER JOIN( SELECT * FROM "+RetSqlName("EE7")+") EE7
	cQuery1 += " ON EE7.D_E_L_E_T_ = ' '
	cQuery1 += " AND EE7.EE7_FILIAL = EE8.EE8_FILIAL
	cQuery1 += " AND EE7.EE7_PEDIDO = EE8.EE8_PEDIDO

	cQuery1 += " LEFT JOIN(SELECT * FROM "+RetSqlName("EE8")+") TEE8
	cQuery1 += " ON TEE8.D_E_L_E_T_ = ' '
	cQuery1 += " AND TEE8.EE8_FILIAL IN ('04','05')
	cQuery1 += " AND TEE8.EE8_CLIENT = '033467'

	If mv_par09==1
		//cQuery1 += " AND TEE8.C6_QTDVEN > TEE8.C6_QTDENT
	EndIf

	//cQuery1 += " AND TEE8.C6_BLQ <> 'R'
	//cQuery1 += " AND TEE8.C6_OPER = '94'
	cQuery1 += " AND TEE8.R_E_C_N_O_ <= EE8.R_E_C_N_O_
	cQuery1 += " AND TEE8.EE8_COD_I = EE8.EE8_COD_I

	cQuery1 += " LEFT JOIN SB1010 B1
	cQuery1 += " ON B1_COD=EE8.EE8_COD_I AND B1.D_E_L_E_T_=' '
	cQuery1 += "  LEFT JOIN SBM010 BM
	cQuery1 += "  ON BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '
	cQuery1 += "  LEFT JOIN SX5010 X5
	cQuery1 += "  ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP  AND X5.D_E_L_E_T_=' '
	cQuery1 += " WHERE EE8.D_E_L_E_T_ = ' '

	If mv_par09==1
		//cQuery1 += " AND EE8.C6_QTDVEN > EE8.C6_QTDENT
	EndIf

	//cQuery1 += " AND EE8.C6_BLQ <> 'R'

	//cQuery1 += " AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X'
	cQuery1 += " AND EE7.EE7_PEDFAT     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery1 += " AND EE8.EE8_COD_I BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery1 += " AND EE7.EE7_DTPEDI BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"'

	cQuery1 += " AND EE7.EE7_CLIENT IN ('096015','098927','098802','070558','099074')
	cQuery1 += " AND EE8.C6_OPER = '94'
	//cQuery1 += " AND EE7.EE7_FILIAL = '02'
	//cQuery1 += " AND EE7.EE7_LOJA   = '01'

	cQuery1 += " GROUP BY EE8.EE8_COD_I, EE7.EE7_PEDFAT, EE8.EE8_FATIT ,EE8.EE8_SLDINI, EE8.R_E_C_N_O_ ,EE8.C6_QTDVEN - EE8.C6_QTDENT,EE7.EE7_DTPEDI,EE7_CLIENT,EE7_CLLOJA," 
	cQuery1 += " EE8_DTENTR, BM_DESC,X5_DESCRI"
	cQuery1 += " ORDER BY EE8.EE8_COD_I,EE8.R_E_C_N_O_	
*/
		Return cQuery1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDAR PERGUNTAS NO ARQUIVO SX1                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
STATIC FUNCTION VALIDPERG(cPerg)
//LOCAL sAlias := Alias()
	LOCAL aRegs  := {}
	LOCAL i,j

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	cPerg := PADR(cPerg, 10)

	AADD(aRegs,{cPerg,"01","Pedido de:"										,"Pedido de:"										,"Pedido de:"										,"MV_CH1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"02","Pedido Ate:"									,"Pedido Ate:"									,"Pedido Ate:"									,"MV_CH2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"03","Produto de:"									,"Produto de:"									,"Produto de:"									,"MV_CH3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"04","Produto Ate:"									,"Produto Ate:"									,"Produto Ate:"									,"MV_CH4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"05","Emissao De"		  							,"Emissao De"		  							,"Emissao De"		  							,"MV_CH5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""   })
	AADD(aRegs,{cPerg,"06","Emissao Ate"									,"Emissao Ate"									,"Emissao Ate"									,"MV_CH6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""   })
	AADD(aRegs,{cPerg,"07","Destino  :"										,"Destino  :"										,"Destino  :"										,"MV_CH7","N",01,0,0,"C","","MV_PAR07","1-Fabrica","1-Fabrica","1-Fabrica","","","2-Distrib. / CD ","2-Distrib. / CD ","2-Distrib. / CD ","","","3-Ambos","3-Ambos","3-Ambos","","","4-Schneider","4-Schneider","4-Schneider","","","5-Exporta็ใo","5-Exporta็ใo","5-Exporta็ใo","","",""})
	AADD(aRegs,{cPerg,"08","SP/AM: ?"											,"SP/AM: ?"											,"SP/AM: ?"											,"MV_CH8","N",01,0,0,"C","","MV_PAR08","1-SP","1-SP","1-SP","","","2-AM","2-AM","2-AM","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Mostra pedidos jแ atendidos?"	,"Mostra pedidos jแ atendidos?"	,"Mostra pedidos jแ atendidos?"	,"MV_CH9","N",01,0,0,"C","","MV_PAR09","1-Nใo","1-Nใo","1-Nใo","","","2-Sim","2-Sim","2-Sim","","","","","","","","","","","","","","","","","",""})

	FOR i:=1 TO LEN(aRegs)
		cRegistro := cPerg+aRegs[i,2]
		IF !DBSEEK(cRegistro)
			RecLock("SX1",.T.)
			FOR j:=1 TO FCOUNT()
				IF j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			NEXT
			MsUnlock()
		ENDIF
	NEXT

RETURN
