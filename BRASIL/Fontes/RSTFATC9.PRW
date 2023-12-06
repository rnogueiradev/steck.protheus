#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  RSTFAT86     บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio PVG - Manaus					                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RSTFATC9()

	Local   oReport
	Private cPerg 		 := "RSTFATC9"
	Private cTime      := Time()
	Private cHora      := Substr(cTime, 1, 2)
	Private cMinutos   := Substr(cTime, 4, 2)
	Private cSegundos  := Substr(cTime, 7, 2)
	Private cAliasLif  := cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader := .F.
	Private lXmlEndRow := .F.
	Private cPergTit 	 := cAliasLif

	VALIDPERG(cPerg)
	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio PVG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO PVG - MANAUS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio PVG - Manaus")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"PVG",{"SC6"})

	TRCell():New(oSection,"01",,"PEDIDO VENDA(AM)"	,,06,.F.,)
	TRCell():New(oSection,"10",,"PEDIDO COMPRA(SP)"	,,06,.F.,)
	TRCell():New(oSection,"02",,"PRODUTO"		,,06,.F.,)
	TRCell():New(oSection,"11",,"GRUPO"			,,04,.F.,)
	TRCell():New(oSection,"12",,"DESCR"			,,50,.F.,)
	TRCell():New(oSection,"07",,"QTD.ORIGINAL"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"QTD.EMBALADO"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"QTD.SALDO" 	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"03",,"ITEM" 			,,02,.F.,)
	TRCell():New(oSection,"04",,"MOTIVO"	    ,,03,.F.,)
	TRCell():New(oSection,"05",,"EMISSAO"		,,10,.F.,)
	TRCell():New(oSection,"06",,"PROGRAMACAO"	,,07,.F.,)
	//TRCell():New(oSection,"13",,"ARMAZEM 03"	,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"14",,"ARMAZEM 15"	,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"15",,"FILIAL"		,,02,.F.,)	

	//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704
	TRCell():New(oSection,"16",,"Dt. Entrega"        ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection,"22",,"Dt. Entrega 2"      ,PesqPict("SC6","C6_ZENTRE2")     ,TamSX3("C6_ZENTRE2")   [1]+2)
	TRCell():New(oSection,"17",,"ฺltimo envio"       ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection,"21",,"Fim de Produ็ใo"    ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)

	//FR - 21/09/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir novas colunas - #Ticket 20220919017785
	TRCell():New(oSection,"18",,"Cod.Cliente" 		,PesqPict("SC5","C5_CLIENTE")      ,TamSX3("C5_CLIENTE")[1])
	TRCell():New(oSection,"19",,"Loja Cliente"		,PesqPict("SC5","C5_LOJACLI")      ,TamSX3("C5_LOJACLI")[1])
	TRCell():New(oSection,"20",,"Nome Cliente"		,PesqPict("SA1","A1_NOME")     	   ,TamSX3("A1_NOME")[1])


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio PVG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	//oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	//oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	//oSection1:Cell("15") :SetBlock( { || aDados1[15] } )

	//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - Ticket #20220523010704
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )

	//FR - 21/09/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir novas colunas - Ticket #20220919017785
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	oSection1:Cell("20") :SetBlock( { || aDados1[20] } )

	oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
	oSection1:Cell("22") :SetBlock( { || aDados1[22] } )

	oReport:SetTitle("PVG")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If  Select(cAliasLif) > 0
		While 	(cAliasLif)->(!Eof())
			aDados1[01]	:= (cAliasLif)->PEDIDO
			aDados1[02]	:= (cAliasLif)->CODIGO
			aDados1[03]	:= (cAliasLif)->ITEM
			If Empty((cAliasLif)->MOTIVO)
				If (cAliasLif)->CLIENTE = '019886' //Mexio
					aDados1[04]	:= "MEX"
				ElseIf Alltrim((cAliasLif)->CLIENTE) $ ('012047#096015') //SCHNEIDER
					aDados1[04]	:= "EASY"
				Elseif (cAliasLif)->CLIENTE = '033833' //ARGENTINA
					aDados1[04]	:= "ARG"
				Elseif (cAliasLif)->CLIENTE = '096401' // COLิMBIA
					aDados1[04]	:= "COL"
				Else
					aDados1[04]	:= "MAO"
				EndIf
			Else
				aDados1[04]	:=  (cAliasLif)->MOTIVO
			EndIf
			aDados1[05]	:=  (cAliasLif)->EMISSAO
			aDados1[06]	:=	(cAliasLif)->PROGRAMACAO
			aDados1[07]	:= 	(cAliasLif)->QUANTIDADE
			aDados1[08]	:= 	(cAliasLif)->SALDO
			aDados1[09]	:=	(cAliasLif)->LIQUIDO
			aDados1[10]	:=	(cAliasLif)->PC
			aDados1[11]	:=	(cAliasLif)->GRUPO
			aDados1[12]	:=	Iif(!Empty((cAliasLif)->DESCR),(cAliasLif)->DESCR, POSICIONE("SB1", 1, xFilial("SB1") + (cAliasLif)->CODIGO, "B1_DESC"))
			// Posiciona no Saldo Fisico do Produto
			//dbSelectArea("SB2")
			SB2->( dbSetOrder(1) )	// B2_FILIAL + B2_COD + B2_LOCAL
			SB2->( dbSeek(xFilial("SB2") + (cAliasLif)->CODIGO + "03") )
			aDados1[13]	:= SaldoSb2()
			// Posiciona no Saldo Fisico do Produto
			//dbSelectArea("SB2")
			SB2->( dbSeek(xFilial("SB2") + (cAliasLif)->CODIGO + "15") )
			aDados1[14]	:= SaldoSb2()
			aDados1[15]	:=	(cAliasLif)->LOJACLI
			
			//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - Ticket #20220523010704
			aDados1[16]	:= CTOD((cAliasLif)->EMISSAO) + 60
			aDados1[17]	:= STOD((cAliasLif)->ULTENV)

			//FR - 21/09/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir novas colunas - Ticket #20220919017785	
			aDados1[18]	:=	(cAliasLif)->CLIENTE
			aDados1[19]	:=	(cAliasLif)->LOJACLI
			aDados1[20]	:=  POSICIONE("SA1", 1, xFilial("SA1") + (cAliasLif)->CLIENTE + (cAliasLif)->LOJACLI, "A1_NOME")	
			aDados1[21]	:= CTOD((cAliasLif)->EMISSAO) + 40
			aDados1[22]	:= DTOC(STOD((cAliasLif)->A18_XDTEN))
			
			// Abro a tabela temporaria
			dbSelectArea(cAliasLif)
			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
		End
		oSection1:PrintLine()
		aFill(aDados1,Nil)
		// Fecho a tabela temporaria
		(cAliasLif)->( dbCloseArea() )
	EndIf

	oReport:SkipLine()

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio PVG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function StQuery(_ccod)

	Local cQuery := " "

	If Mv_Par07 == 1 .Or. Mv_Par07 == 2 .Or. Mv_Par07 == 3
		cQuery := " SELECT " + CHR(13) + CHR(10)
		cQuery += " SC6.C6_CLI " + CHR(13) + CHR(10)
		cQuery += ' "CLIENTE",' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_PRODUTO " + CHR(13) + CHR(10)
		cQuery += ' "CODIGO", '  + CHR(13) + CHR(10)
		cQuery += " (SELECT B1_GRUPO FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO ) AS GRUPO,"  + CHR(13) + CHR(10)
		cQuery += " SC6.C6_NUM " + CHR(13) + CHR(10)
		cQuery += ' "PEDIDO", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_ITEM " + CHR(13) + CHR(10)
		cQuery += ' "ITEM", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_DESCRI " + CHR(13) + CHR(10)
		cquery += ' "DESCR", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_QTDVEN " + CHR(13) + CHR(10)
		cQuery += ' "QUANTIDADE", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_QTDVEN - SC6.C6_QTDENT " + CHR(13) + CHR(10)
		cQuery += ' "SALDO", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_ZMOTPC " + CHR(13) + CHR(10)
		cQuery += ' "MOTIVO", ' + CHR(13) + CHR(10)
		cQuery += " NVL((SELECT SUM(ZZU_QTDE)  FROM ZZU030 ZZU INNER JOIN(SELECT * FROM ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) " + CHR(13) + CHR(10) //Chamado 007618
		cQuery += ' "EMBALAGEM", ' + CHR(13) + CHR(10)
		cQuery += " SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0)) " + CHR(13) + CHR(10)
		cQuery += ' "TC6", ' + CHR(13) + CHR(10)
		cQuery += " SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) " + CHR(13) + CHR(10)
		cQuery += ' "EMISSAO", ' + CHR(13) + CHR(10)
		cQuery += " SC5.C5_ZMESPC||'/'||SC5.C5_ZANOPC " + CHR(13) + CHR(10)
		cQuery += ' "PROGRAMACAO",' + CHR(13) + CHR(10)
		cQuery	+= " SC5.C5_ZNUMPC " + CHR(13) + CHR(10)
		cQuery	+= ' "PC", ' + CHR(13) + CHR(10)
		cQuery += " CASE WHEN NVL((SELECT SUM(ZZU_QTDE)  FROM ZZU030 ZZU INNER JOIN(SELECT * FROM ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) = 0 THEN 0 ELSE " + CHR(13) + CHR(10) //Chamado 007618
		cQuery += " CASE WHEN NVL((SELECT SUM(ZZU_QTDE)  FROM ZZU030 ZZU INNER JOIN(SELECT * FROM ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) > SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0)) THEN SC6.C6_QTDVEN - SC6.C6_QTDENT ELSE " + CHR(13) + CHR(10) //Chamado 007618
		cQuery += " CASE WHEN ((SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0)) ) - (SC6.C6_QTDVEN - SC6.C6_QTDENT)) > NVL((SELECT SUM(ZZU_QTDE)  FROM ZZU030 ZZU INNER JOIN(SELECT * FROM ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0)  THEN 0 " + CHR(13) + CHR(10) //Chamado 007618
		cQuery += " ELSE  NVL((SELECT SUM(ZZU_QTDE)  FROM ZZU030 ZZU INNER JOIN(SELECT * FROM ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0)- (SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0))-(SC6.C6_QTDVEN - SC6.C6_QTDENT)) " + CHR(13) + CHR(10) //Chamado 007618
		cQuery += " END END END " + CHR(13) + CHR(10)
		cQuery += ' "LIQUIDO", ' + CHR(13) + CHR(10)
		cQuery += " SC5.C5_LOJACLI " + CHR(13) + CHR(10)
		cQuery += ' "LOJACLI" ' + CHR(13) + CHR(10)

		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704 
		cQuery += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END AS A18_XDTEN " + CRLF

		cQuery += " , MAX(D2.D2_EMISSAO) ULTENV " + CRLF
		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704

		//cQuery += " FROM SC6030 SC6 " + CHR(13) + CHR(10)
		cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CHR(13) + CHR(10)

		//cQuery += " INNER JOIN( SELECT * FROM SC5030)SC5 " + CHR(13) + CHR(10)
		cQuery += " INNER JOIN( SELECT * FROM " + RetSqlName("SC5") + ")SC5 " + CHR(13) + CHR(10)
		cQuery += " ON SC5.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += " 	AND SC5.C5_FILIAL = SC6.C6_FILIAL " + CHR(13) + CHR(10)
		cQuery += " 	AND SC5.C5_NUM    = SC6.C6_NUM " + CHR(13) + CHR(10)

		//cQuery += " LEFT JOIN (SELECT * FROM SB1030) SB1 " + CHR(13) + CHR(10)
		cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("SB1") + ") SB1 " + CHR(13) + CHR(10)
		cQuery += " ON SB1.B1_COD = SC6.C6_PRODUTO " + CHR(13) + CHR(10)
		cQuery += " 	AND SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)

		cQuery += " LEFT JOIN " + RetSqlname("SD2") + " D2 " + CRLF	//FR - 06/06/2022 - altera็ใo para captar a tabela automaticamente 
		cQuery += " ON D2_FILIAL = SC6.C6_FILIAL AND D2_PEDIDO = SC6.C6_NUM AND D2_ITEMPV = C6_ITEM AND D2.D_E_L_E_T_=' ' " + CRLF


		/*
		cQuery += " LEFT JOIN(SELECT * FROM ZZU030) ZZU
		cQuery += " ON ZZU.D_E_L_E_T_ = ' '
		cQuery += " AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO
		cQuery += " AND EXISTS(SELECT * FROM ZZT030 ZZT
		cQuery += " WHERE ZZT.D_E_L_E_T_    = ' '
		cQuery += " AND ZZT.ZZT_NUMEMB   = ZZU_NUMEMB
		cQuery += " AND ZZT.ZZT_NF       = ' ')
		*/

		//cQuery += " LEFT JOIN(SELECT * FROM SC6030) TC6 " + CHR(13) + CHR(10)
		cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("SC6") + ") TC6 " + CHR(13) + CHR(10)
		cQuery += " ON TC6.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += " 	AND TC6.C6_FILIAL = '01' " + CHR(13) + CHR(10)
		//Query += " AND TC6.C6_CLI = '033467' " + CHR(13) + CHR(10)
		//cQuery += " AND TC6.C6_CLI IN ('033467','019886','012047','033833' ) " + CHR(13) + CHR(10)

		//// Filtra pedidos jแ emitidos 
		IF MV_PAR08 <> 1
			cQuery += " 	AND TC6.C6_QTDVEN > TC6.C6_QTDENT " + CHR(13) + CHR(10)
		ENDIF
		cQuery += " 	AND TC6.C6_BLQ <> 'R' " + CHR(13) + CHR(10)
		cQuery += " 	AND TC6.C6_OPER in( '04','12','01','10','16','05','15','48','94',' ' ) " + CHR(13) + CHR(10)
		cQuery += " 	AND TC6.R_E_C_N_O_ <= SC6.R_E_C_N_O_ " + CHR(13) + CHR(10)
		cQuery += " 	AND TC6.C6_PRODUTO = SC6.C6_PRODUTO " + CHR(13) + CHR(10)
		
		cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += " 	AND SC6.C6_FILIAL = '01' " + CHR(13) + CHR(10)
		//cQuery += " AND SC6.C6_CLI = '033467' " + CHR(13) + CHR(10)
		//cQuery += " AND SC6.C6_CLI IN ('033467','019886','012047','033833' ) " + CHR(13) + CHR(10)

		//// Filtra pedidos jแ emitidos 
		IF MV_PAR08 <> 1
			cQuery += " 	AND SC6.C6_QTDVEN > SC6.C6_QTDENT " + CHR(13) + CHR(10)
		ENDIF
		cQuery += " 	AND SC6.C6_BLQ <> 'R' " + CHR(13) + CHR(10)
		cQuery += " 	AND SC6.C6_OPER in( '04','12','01','10','16','05','15','48','94',' ' ) " + CHR(13) + CHR(10)
		cQuery += " 	AND SC6.C6_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CHR(13) + CHR(10)
		cQuery += " 	AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CHR(13) + CHR(10)
		cQuery += " 	AND SC5.C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"' " + CHR(13) + CHR(10)
		cQuery += " 	AND SB1.B1_TIPO IN ('PA','PI') "+ CHR(13) + CHR(10)
		
		If Mv_Par07 == 1
			cQuery += " 	AND SC6.C6_LOJA = '01' " + CHR(13) + CHR(10)
		ElseIf Mv_Par07 == 2
			cQuery += " 	AND SC6.C6_LOJA = '02' " + CHR(13) + CHR(10)
		EndIf


		cQuery += " GROUP BY SC6.C6_CLI,SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM , SC6.C6_DESCRI,SC6.C6_QTDVEN, SC6.R_E_C_N_O_ ,SC6.C6_QTDVEN - SC6.C6_QTDENT,SC5.C5_EMISSAO,SC6.C6_ZMOTPC,SC5.C5_ZMESPC||'/'||SC5.C5_ZANOPC,SC5.C5_ZNUMPC, SC5.C5_LOJACLI " + CHR(13) + CHR(10)
		
		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704
		cQuery += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END  " + CRLF
		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704

		cQuery += " ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_ " + CHR(13) + CHR(10)
	
	ElseIf  Mv_Par07 == 4 .Or. Mv_Par07 == 5

		cQuery := " SELECT " + CHR(13) + CHR(10)
		cQuery += " SC6.C6_PRODUTO " + CHR(13) + CHR(10)
		cQuery += ' "CODIGO", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_NUM " + CHR(13) + CHR(10)
		cQuery += ' "PEDIDO", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_ITEM " + CHR(13) + CHR(10)
		cQuery += ' "ITEM", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_DESCRI " + CHR(13) + CHR(10)
		cQuery += ' "DESCR", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_QTDVEN " + CHR(13) + CHR(10)
		cQuery += ' "QUANTIDADE", ' + CHR(13) + CHR(10)
		cQuery += " SC6.C6_QTDVEN - SC6.C6_QTDENT " + CHR(13) + CHR(10)
		cQuery += ' "SALDO", ' + CHR(13) + CHR(10)
		cQuery += " ' ' " + CHR(13) + CHR(10)
		cQuery += ' "MOTIVO", ' + CHR(13) + CHR(10)
		cQuery += " 0 " + CHR(13) + CHR(10)
		cQuery += ' "EMBALAGEM", ' + CHR(13) + CHR(10)
		cQuery += " 0 " + CHR(13) + CHR(10)
		cQuery += ' "TC6", ' + CHR(13) + CHR(10)
		cQuery += " SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) " + CHR(13) + CHR(10)
		cQuery += ' "EMISSAO", ' + CHR(13) + CHR(10)
		cQuery += " '00/0000' " + CHR(13) + CHR(10)
		cQuery += ' "PROGRAMACAO", ' + CHR(13) + CHR(10)
		cQuery += " 0 " + CHR(13) + CHR(10)
		cQuery += ' "LIQUIDO", ' + CHR(13) + CHR(10)
		cQuery += " SC5.C5_LOJACLI " + CHR(13) + CHR(10)
		cQuery += ' "LOJACLI" ' + CHR(13) + CHR(10)

		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704 
		cQuery += " ,CASE WHEN SC6.C6_ZENTRE2 < SC6.C6_ENTRE1 THEN SC6.C6_ENTRE1 ELSE SC6.C6_ZENTRE2 END AS A18_XDTEN " + CRLF
		cQuery += " ,( SELECT MAX(D2.D2_EMISSAO) FROM SD2030 D2 WHERE D2_FILIAL = SC6.C6_FILIAL AND D2_PEDIDO = SC6.C6_NUM AND D2_ITEMPV =  SC6.C6_ITEM AND D2.D_E_L_E_T_=' ' ) AS ULTENV " + CRLF		
		//FR - 14/06/2022 - Flแvia Rocha - Sigamat Consultoria - Altera็ใo - incluir duas novas colunas - #Ticket 20220523010704


		//cQuery += " FROM SC6030 SC6 " + CHR(13) + CHR(10)
		cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CHR(13) + CHR(10)

		//cQuery += " LEFT JOIN( SELECT * FROM SC5030)SC5 " + CHR(13) + CHR(10)
		cQuery += " LEFT JOIN( SELECT * FROM " + RetSqlName("SC5") + ")SC5 " + CHR(13) + CHR(10)
		cQuery += " ON SC5.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL " + CHR(13) + CHR(10)
		cQuery += " AND SC5.C5_NUM    = SC6.C6_NUM " + CHR(13) + CHR(10)

		cQuery += " LEFT JOIN " + RetSqlname("SD2") + " D2 " + CRLF	
		cQuery += " ON D2_FILIAL = SC6.C6_FILIAL AND D2_PEDIDO = SC6.C6_NUM AND D2_ITEMPV = C6_ITEM AND D2.D_E_L_E_T_=' ' " + CRLF

		
		cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += " AND SC6.C6_FILIAL = '01' " + CHR(13) + CHR(10)

		If Mv_Par07 == 4
			cQuery += " AND SC6.C6_CLI = '012047'" + CHR(13) + CHR(10)
			cQuery += " AND SC6.C6_OPER = '15' " + CHR(13) + CHR(10)
		ElseIf Mv_Par07 == 5
			cQuery += " AND (SC6.C6_CLI = '033833' OR " + CHR(13) + CHR(10)
			cQuery += "  	 SC6.C6_CLI = '019886') " + CHR(13) + CHR(10)
		EndIf

		//// Filtra pedidos jแ emitidos 
		IF MV_PAR08 <> 1
			cQuery += " 	AND TC6.C6_QTDVEN > TC6.C6_QTDENT " + CHR(13) + CHR(10)
		ENDIF
		cQuery += " AND SC6.C6_BLQ <> 'R' " + CHR(13) + CHR(10)
		

		//cQuery += " AND SC6.C6_OPER <> '15'
		cQuery += " ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_ " + CHR(13) + CHR(10)

	EndIf

	MemoWrite("C:\TEMP\RSTFATC9_PVG.TXT" , cQuery)

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

//033833 ARGENTINA
//012047 SCHNEIDER

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDAR PERGUNTAS NO ARQUIVO SX1                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
STATIC FUNCTION VALIDPERG(cPerg)
LOCAL aRegs  := {}
LOCAL i,j

DBSELECTAREA("SX1")
DBSETORDER(1)
cPerg := PADR(cPerg, 10)

AADD(aRegs,{cPerg,"01", "Pedido de:" 	                ,"Pedido de:" 	               ,"Pedido de:" 			            ,"MV_CH1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
AADD(aRegs,{cPerg,"02", "Pedido Ate:"	                ,"Pedido Ate:"                 ,"Pedido Ate:" 		            ,"MV_CH2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
AADD(aRegs,{cPerg,"03", "Produto de:" 	              ,"Produto de:" 	               ,"Produto de:" 		            ,"MV_CH3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"04", "Produto Ate:"	              ,"Produto Ate:"                ,"Produto Ate:"		            ,"MV_CH4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"05", "Da Emissao:"	                ,"Da Emissao:"	               ,"Da Emissao:"			            ,"MV_CH5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"06", "At้ a Emissao:"              ,"At้ a Emissao:"              ,"At้ a Emissao:" 		          ,"MV_CH6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"07", "Destino  :"	                ,"Destino  :"                  ,"Destino  :"       	          ,"MV_CH7","N",01,0,0,"C","","MV_PAR07","1-Fabrica","1-Fabrica","1-Fabrica","","","2-CD ","2-CD ","2-CD ","","","3-Ambos","3-Ambos","3-Ambos","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09", "Mostra pedidos jแ atendidos?","Mostra pedidos jแ atendidos?","Mostra pedidos jแ atendidos?","MV_CH8","N",01,0,0,"C","","MV_PAR08","1-Nใo"    ,"1-Nใo"    ,"1-Nใo"    ,"","","2-Sim","2-Sim","2-Sim","","",""       ,""       ,""       ,"","","","","","","","","","","","",""})

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




