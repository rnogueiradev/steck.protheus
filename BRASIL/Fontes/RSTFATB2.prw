#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATB2   ºAutor  ³Robson Mazzarotto º Data ³  12/06/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de entregas de itens importados				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATB2()
*-----------------------------*
	Local   oReport
	Private cPerg		:= "RFATB2"
	Private cTime		:= Time()
	Private cHora		:= SUBSTR(cTime, 1, 2)
	Private cMinutos	:= SUBSTR(cTime, 4, 2)
	Private cSegundos	:= SUBSTR(cTime, 7, 2)
	Private cAlias1		:= "FATB201"
	Private cAlias2		:= "FATB202"
	Private lXlsHeader	:= .f.
	Private lXmlEndRow	:= .f.
	Private cPergTit	:= cPerg+cHora+cMinutos+cSegundos

	Private dMes1	:= LastDay(dDataBase)
	Private dMes2	:= LastDay(dMes1+1)
	Private dMes3	:= LastDay(dMes2+1)
	Private dMes4	:= LastDay(dMes3+1)
	Private dMes5	:= LastDay(dMes4+1)
	Private dMes6	:= LastDay(dMes5+1)

	Private cMes1	:= Substr(DtoS(dMes1),1,6)	
	Private cMes2	:= Substr(DtoS(dMes2),1,6)	
	Private cMes3	:= Substr(DtoS(dMes3),1,6)	
	Private cMes4	:= Substr(DtoS(dMes4),1,6)	
	Private cMes5	:= Substr(DtoS(dMes5),1,6)	
	Private cMes6	:= Substr(DtoS(dMes6),1,6)	

	Private cMesEx1	:= Upper(MesExtenso(dMes1))
	Private cMesEx2	:= Upper(MesExtenso(dMes2))
	Private cMesEx3	:= Upper(MesExtenso(dMes3))
	Private cMesEx4	:= Upper(MesExtenso(dMes4))
	Private cMesEx5	:= Upper(MesExtenso(dMes5))
	Private cMesEx6	:= Upper(MesExtenso(dMes6))

	PutSx1(cPerg, "01", "Codigo de:" 	,"Codigo de:" 	 ,"Codigo de:" 		,"mv_ch1","C",15,0,0,"G","","SB1" ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Codigo ate:" 	,"Codigo ate:" 	 ,"Codigo ate:" 	,"mv_ch2","C",15,0,0,"G","","SB1" ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Grupo de:"		,"Grupo de:"	 ,"Grupo de:"		,"mv_ch3","C",03,0,0,"G","","SBM","","" ,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Grupo ate:"	,"Grupo ate:"	 ,"Grupo ate:"		,"mv_ch4","C",03,0,0,"G","","SBM","","" ,"mv_par04","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Robson Mazzarottoº Data ³  12/06/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de entregas de itens importados				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório de entregas de itens importados",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório previsão de vendas")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Entregas de itens importados",{"SB1"})

	TRCell():New(oSection,"01",,"CODIGO"				,,30,.F.,)
	TRCell():New(oSection,"02",,"DESCRI"		 		,,60,.F.,)
	TRCell():New(oSection,"03",,"GRUPO" 				,,30,.F.,)
	TRCell():New(oSection,"04",,"DESCGRP"  			 	,,30,.F.,)
	TRCell():New(oSection,"05",,"FMR"					,,30,.F.,)
	TRCell():New(oSection,"06",,"ESTOQUE"				,,30,.F.,)
	TRCell():New(oSection,"07",,"ESTOQUE98"				,,30,.F.,)
	TRCell():New(oSection,"08",,"PREVEN"				,,30,.F.,)
	TRCell():New(oSection,"09",,"FORNEC"				,,30,.F.,)
	TRCell():New(oSection,"10",,"AGRUPAMENTO"			,,50,.F.,)
	TRCell():New(oSection,"11",,"ESTSEG"				,,50,.F.,)
	TRCell():New(oSection,"12",,"CARTEIRA"				,,50,.F.,)
	TRCell():New(oSection,"13",,"FATURADO"				,,50,.F.,)
	TRCell():New(oSection,"14",,"ENTREGA_Q1_"+cMesEx1	,,50,.F.,)
	TRCell():New(oSection,"15",,"ENTREGA_Q2_"+cMesEx1	,,50,.F.,)
	TRCell():New(oSection,"16",,"ENTREGA_Q1_"+cMesEx2	,,50,.F.,)
	TRCell():New(oSection,"17",,"ENTREGA_Q2_"+cMesEx2	,,50,.F.,)
	TRCell():New(oSection,"18",,"ENTREGA_Q1_"+cMesEx3	,,50,.F.,)
	TRCell():New(oSection,"19",,"ENTREGA_Q2_"+cMesEx3	,,50,.F.,)
	TRCell():New(oSection,"20",,"ENTREGA_Q1_"+cMesEx4	,,50,.F.,)
	TRCell():New(oSection,"21",,"ENTREGA_Q2_"+cMesEx4	,,50,.F.,)
	TRCell():New(oSection,"22",,"ENTREGA_Q1_"+cMesEx5	,,50,.F.,)
	TRCell():New(oSection,"23",,"ENTREGA_Q2_"+cMesEx5	,,50,.F.,)
	TRCell():New(oSection,"24",,"ENTREGA_Q1_"+cMesEx6	,,50,.F.,)
	TRCell():New(oSection,"25",,"ENTREGA_Q2_"+cMesEx6	,,50,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SB1")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Robson Mazzarottoº Data ³  12/06/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de entregas de itens importados				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local nY		:= 0
	Local cDescr	:= ""
	Local nEstoque	:= ""
	Local cAgrupam	:= ""

	Local aDadItem	:= {}
	Local aDadTodos	:= {}

	oSection1:Cell("01") :SetBlock( { || aDadItem[01] } )
	oSection1:Cell("02") :SetBlock( { || aDadItem[02] } )
	oSection1:Cell("03") :SetBlock( { || aDadItem[03] } )
	oSection1:Cell("04") :SetBlock( { || aDadItem[04] } )
	oSection1:Cell("05") :SetBlock( { || aDadItem[05] } )
	oSection1:Cell("06") :SetBlock( { || aDadItem[06] } )
	oSection1:Cell("07") :SetBlock( { || aDadItem[07] } )
	oSection1:Cell("08") :SetBlock( { || aDadItem[08] } )
	oSection1:Cell("09") :SetBlock( { || aDadItem[09] } )
	oSection1:Cell("10") :SetBlock( { || aDadItem[10] } )
	oSection1:Cell("11") :SetBlock( { || aDadItem[11] } )
	oSection1:Cell("12") :SetBlock( { || aDadItem[12] } )
	oSection1:Cell("13") :SetBlock( { || aDadItem[13] } )
	oSection1:Cell("14") :SetBlock( { || aDadItem[14] } )
	oSection1:Cell("15") :SetBlock( { || aDadItem[15] } )
	oSection1:Cell("16") :SetBlock( { || aDadItem[16] } )
	oSection1:Cell("17") :SetBlock( { || aDadItem[17] } )
	oSection1:Cell("18") :SetBlock( { || aDadItem[18] } )
	oSection1:Cell("19") :SetBlock( { || aDadItem[19] } )
	oSection1:Cell("20") :SetBlock( { || aDadItem[20] } )
	oSection1:Cell("21") :SetBlock( { || aDadItem[21] } )
	oSection1:Cell("22") :SetBlock( { || aDadItem[22] } )
	oSection1:Cell("23") :SetBlock( { || aDadItem[23] } )
	oSection1:Cell("24") :SetBlock( { || aDadItem[24] } )
	oSection1:Cell("25") :SetBlock( { || aDadItem[25] } )

	oReport:SetTitle("Relatório de entregas de itens importados")// Titulo do relatório

	oReport:SetMeter(0)

	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If Select(cAlias1) > 0
		Do While (cAlias1)->(!Eof())
			cDescr		:= Posicione("SBM",1,xFilial("SBM")+(cAlias1)->B1_GRUPO,"BM_DESC")
			nEstoque 	:= Posicione("SB2",1,xFilial("SB2")+(cAlias1)->B1_COD+(cAlias1)->B1_LOCPAD,"B2_QATU")
			nEstoque98	:= Posicione("SB2",1,xFilial("SB2")+(cAlias1)->B1_COD+"98","B2_QATU")
			cAgrupam	:= Posicione("SX5",1,xFilial("SX5")+"ZZ"+Posicione("SBM",1,xFilial("SBM")+(cAlias1)->B1_GRUPO,"BM_XAGRUP"),"X5_DESCRI")
			aDadItem	:= {}

			aAdd(aDadItem,(cAlias1)->B1_COD)							//01	"CODIGO"
			aAdd(aDadItem,(cAlias1)->B1_DESC)							//02	"DESCRI"
			aAdd(aDadItem,(cAlias1)->B1_GRUPO)							//03	"GRUPO"
			aAdd(aDadItem,cDescr)										//04	"DESCGRP"
			aAdd(aDadItem,(cAlias1)->B1_XFMR)							//05	"FMR"
			aAdd(aDadItem,nEstoque)										//06	"ESTOQUE"
			aAdd(aDadItem,nEstoque98)									//07	"ESTOQUE98"
			aAdd(aDadItem,Val((cAlias1)->B1_XPREMES))					//08	"PREVEN"
			aAdd(aDadItem,(cAlias1)->B1_PROC)							//09	"FORNEC"
			aAdd(aDadItem,cAgrupam)										//10	"AGRUPAMENTO"
			aAdd(aDadItem,(cAlias1)->B1_ESTSEG)							//11	"ESTSEG"
			aAdd(aDadItem,(cAlias1)->CARTEIRA)							//12	"CARTEIRA"
			aAdd(aDadItem,(cAlias1)->FATURA)							//13	"FATURADO"
			aAdd(aDadItem,0)											//14	"ENTREGA_Q1_"+cMesEx1
			aAdd(aDadItem,0)											//15	"ENTREGA_Q2_"+cMesEx1
			aAdd(aDadItem,0)											//16	"ENTREGA_Q1_"+cMesEx2
			aAdd(aDadItem,0)											//17	"ENTREGA_Q2_"+cMesEx2
			aAdd(aDadItem,0)											//18	"ENTREGA_Q1_"+cMesEx3
			aAdd(aDadItem,0)											//19	"ENTREGA_Q2_"+cMesEx3
			aAdd(aDadItem,0)											//20	"ENTREGA_Q1_"+cMesEx4
			aAdd(aDadItem,0)											//21	"ENTREGA_Q2_"+cMesEx4
			aAdd(aDadItem,0)											//22	"ENTREGA_Q1_"+cMesEx5
			aAdd(aDadItem,0)											//23	"ENTREGA_Q2_"+cMesEx5
			aAdd(aDadItem,0)											//24	"ENTREGA_Q1_"+cMesEx6
			aAdd(aDadItem,0)											//25	"ENTREGA_Q2_"+cMesEx6
			aAdd(aDadTodos,aDadItem)
			(cAlias1)->(dbskip())
		EndDo
		(cAlias1)->(dbCloseArea())
	EndIf

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0
	
		Do While (cAlias2)->(!Eof())
			nPosDad := aScan(aDadTodos,{|x| x[1] = (cAlias2)->PRODUTO})
			nColuna := 0
			If ! Empty(nPosDad)
				If ( (cAlias2)->ANOMES < cMes1 ) .Or. ( (cAlias2)->ANOMES = cMes1 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 14
				ElseIf ( (cAlias2)->ANOMES = cMes1 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 15
				ElseIf ( (cAlias2)->ANOMES = cMes2 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 16
				ElseIf ( (cAlias2)->ANOMES = cMes2 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 17
				ElseIf ( (cAlias2)->ANOMES = cMes3 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 18
				ElseIf ( (cAlias2)->ANOMES = cMes3 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 19
				ElseIf ( (cAlias2)->ANOMES = cMes4 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 20
				ElseIf ( (cAlias2)->ANOMES = cMes4 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 21
				ElseIf ( (cAlias2)->ANOMES = cMes5 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 22
				ElseIf ( (cAlias2)->ANOMES = cMes5 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 23
				ElseIf ( (cAlias2)->ANOMES = cMes6 .And. (cAlias2)->QUINZENA = 1 )
					nColuna := 24
				ElseIf ( (cAlias2)->ANOMES > cMes6 ) .Or. ( (cAlias2)->ANOMES = cMes6 .And. (cAlias2)->QUINZENA = 2 )
					nColuna := 25
				EndIf
				aDadTodos[nPosDad,nColuna]	+= (cAlias2)->QTDE
			EndIf
			(cAlias2)->(dbskip())
		EndDo
		(cAlias2)->(dbCloseArea())
	EndIf

	For nX := 1 to Len(aDadTodos)
		aDadItem := {}
		For nY := 1 to Len(aDadTodos[nX])
			aAdd(aDadItem,aDadTodos[nX,nY])
		Next nY
		oSection1:PrintLine()
	Next nX

	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Robson Mazzarottoº Data ³  25/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio previsão de vendas									º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery1 := ""
	Local cQuery2 := ""

	Local cDtD2Ini := DtoS(Firstday(dDataBase)) 
	Local cDtD2Fim := DtoS(dDataBase) 

	cQuery1 += " SELECT B1_COD, B1_DESC, B1_GRUPO, B1_ESTSEG, B1_XFMR, B1_XPREMES, B1_PROC, B1_LOCPAD, " + CRLF 

	cQuery1 += " NVL((SELECT SUM(C6_QTDVEN-C6_QTDENT) FROM " + RetSqlName("SC6") + " SC6 " + CRLF
	cQuery1 += " LEFT OUTER JOIN " + RetSqlName("SC5") + " SC5 " + CRLF
	cQuery1 += " ON SC5.C5_NUM      = SC6.C6_NUM " + CRLF
	cQuery1 += " AND SC5.C5_FILIAL  = SC6.C6_FILIAL " + CRLF
	cQuery1 += " AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery1 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cQuery1 += " AND SC6.C6_PRODUTO = SB1.B1_COD " + CRLF 
	cQuery1 += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT " + CRLF
	cQuery1 += " AND SC6.C6_BLQ <> 'R' " + CRLF
	cQuery1 += " AND SC5.C5_ZREFNF <> '1' "
	cQuery1 += " AND SC5.C5_ZBLOQ <> '1' "
	cQuery1 += " AND SC6.D_E_L_E_T_ = ' '),0) CARTEIRA, " + CRLF 

	cQuery1 += " NVL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery1 += " LEFT OUTER JOIN " + RetSqlName("SF4") + " SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery1 += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "'  " + CRLF
	cQuery1 += " AND SD2.D2_COD = SB1.B1_COD  " + CRLF
	cQuery1 += " AND SD2.D2_EMISSAO BETWEEN '" + cDtD2Ini + "' AND '" + cDtD2Fim + "' " + CRLF
	cQuery1 += " AND F4_ESTOQUE = 'S'   " + CRLF
	cQuery1 += " AND F4_DUPLIC = 'S'  " + CRLF
	cQuery1 += " AND SD2.D_E_L_E_T_ = ' '),0) FATURA " + CRLF 

	cQuery1 += " FROM " + RetSqlName("SB1") + " SB1  " + CRLF
	cQuery1 += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery1 += " AND SB1.B1_ORIGEM IN ('1','2','6','7') " + CRLF
	cQuery1 += " AND SB1.B1_MSBLQL <> '1'   " + CRLF
	cQuery1 += " AND SB1.D_E_L_E_T_ = ' '  " + CRLF
	cQuery1 += " AND SB1.B1_COD BETWEEN '" + MV_PAR01 + "' AND '"+MV_PAR02 + "' " + CRLF
	cQuery1 += " AND SB1.B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04  +"'  " + CRLF

	cQuery1 += " ORDER BY B1_COD " + CRLF

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

	cQuery2 += " SELECT PRODUTO, ANOMES, QUINZENA, SUM(W3_QTDE) QTDE FROM ( " + CRLF
	cQuery2 += " SELECT PRODUTO, SUBSTR(DATA_ENTR,1,6) ANOMES,  " + CRLF
	cQuery2 += " CASE WHEN SUBSTR(DATA_ENTR,7,2) <= '15' THEN 1 ELSE 2 END QUINZENA, " + CRLF 
	cQuery2 += " ZZJ_DATA, W3_DT_ENTR, W3_PO_NUM, W3_QTDE " + CRLF
	cQuery2 += " FROM ( " + CRLF
	cQuery2 += " SELECT W3_COD_I PRODUTO, CASE WHEN ZZJ_DATA IS NULL THEN W3_DT_ENTR ELSE ZZJ_DATA END DATA_ENTR, ZZJ_DATA, W3_DT_ENTR, W3_PO_NUM, W3_QTDE " + CRLF
	cQuery2 += " FROM SW3010 SW3  " + CRLF
	cQuery2 += " LEFT OUTER JOIN " + RetSqlName("ZZJ") + " ON ZZJ_FILIAL = '" + xFilial("ZZJ") + "' AND ZZJ_COD = W3_COD_I AND ZZJ_OP = 'PO'||W3_PO_NUM " + CRLF
	cQuery2 += " LEFT OUTER JOIN " + RetSqlName("SC7") + " ON C7_FILIAL = W3_FILIAL AND C7_SEQUEN = W3_POSICAO AND C7_NUMIMP = W3_PO_NUM " + CRLF
	cQuery2 += " LEFT OUTER JOIN " + RetSqlName("SD1") + " ON D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM " + CRLF
	cQuery2 += " WHERE W3_FILIAL = '" + xFilial("SW3") + "'  " + CRLF
	cQuery2 += " AND SW3.W3_SEQ = 0  " + CRLF
	cQuery2 += " AND SW3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery2 += " AND D1_DOC IS NULL " + CRLF
	cQuery2 += " ) TAB ) TAB " + CRLF
	cQuery2 += " GROUP BY PRODUTO, ANOMES, QUINZENA " + CRLF
	cQuery2 += " ORDER BY PRODUTO, ANOMES, QUINZENA  " + CRLF

	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)

Return()
