#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT98     ºAutor  ³Renato Nogueira º Data ³  06/10/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório pedidos em aberto (trânsito)          	       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT98()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT98"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    		:= SUBSTR(cTime, 4, 2)
	Private cSegundos   		:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   		:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   	:= .f.
	Private lXmlEndRow   	:= .f.
	Private cPergTit			:= cAliasLif

	PutSx1(cPerg, "01", "Produto de:"		,"Produto de:"			,"Produto de:"				,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    ,"SB1" 	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Produto ate:"		,"Produto ate:"			,"Produto ate:"				,"mv_ch2","C"   ,15      ,0       ,0      , "G",""    ,"SB1" 	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
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

	oReport := TReport():New(cPergTit,"RELATÓRIO DE PEDIDOS EM ABERTO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de pedidos em aberto - trânsito")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SB1",{"SB1"})

	TRCell():New(oSection,"01"				,,"PRODUTO"					,,15,.F.,)
	TRCell():New(oSection,"02"				,,"PEDIDO DE VENDA AM"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"03"				,,"ENTREGUE AM"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"04"				,,"FATURADO"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"05"				,,"TRANSITO"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"06"				,,"SALDO PEDIDO DE COMPRA"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"07"				,,"STATUS"						,,20,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SB1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
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
	Local aDados[2]
	Local aDados1[99]

oSection1:Cell('01')  		:SetBlock( { || aDados1[01] } )
oSection1:Cell('02')  		:SetBlock( { || aDados1[02] } )
oSection1:Cell('03')  		:SetBlock( { || aDados1[03] } )
oSection1:Cell('04') 		:SetBlock( { || aDados1[04] } )
oSection1:Cell('05')  		:SetBlock( { || aDados1[05] } )
oSection1:Cell('06')  		:SetBlock( { || aDados1[06] } )
oSection1:Cell('07')  		:SetBlock( { || aDados1[07] } )

	oReport:SetTitle("SB1")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
		
			aDados1[01]	:=  (cAliasLif)->PRODUTO
			aDados1[02]	:=	(cAliasLif)->PEDVAM
			aDados1[03]	:=	(cAliasLif)->ENTREGAM
			aDados1[04]	:=	(cAliasLif)->FATURADO
			aDados1[05]	:=	(cAliasLif)->TRANSITO
			aDados1[06]	:=	(cAliasLif)->SLDPEDCOM
			aDados1[07]	:= 	(cAliasLif)->STATUS

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
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

	Local cQuery     := ' '

		cQuery := " SELECT B1_COD PRODUTO, "  
		cQuery += " NVL((SELECT SUM(C6_QTDVEN-C6_QTDENT) FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' "
		cQuery += " AND C6_CLI = '033467' AND C6_LOJA = '02' AND C6_BLQ = ' ' AND C6_PRODUTO=SB1.B1_COD "
		cQuery += " AND C6_QTDVEN-C6_QTDENT>0 AND C6_OPER = '15' ),0) PEDVAM, "
		cQuery += " NVL((SELECT SUM(C6_QTDENT) FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_CLI = '033467' "
		cQuery += " AND C6_LOJA = '02' AND C6_BLQ = ' ' AND C6_PRODUTO  =  SB1.B1_COD AND C6_OPER = '15' ),0) ENTREGAM, "
		cQuery += " NVL((SELECT SUM(D2_QUANT) FROM SD2030 SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD=B1_COD "
		cQuery += " AND D2_CLIENTE = '033467' AND D2_LOJA = '02' AND D2_EMISSAO > '20150706'),0) FATURADO, "
		cQuery += " NVL((SELECT SUM(D2_QUANT) FROM SD2030 SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD=B1_COD "
		cQuery += " AND D2_CLIENTE = '033467' AND D2_LOJA = '02' AND D2_EMISSAO > '20150706' "
		cQuery += " AND  NOT EXISTS (   SELECT * FROM SF3030 SF3 WHERE SF3.D_E_L_E_T_ =  ' ' "
		cQuery += " AND SF3.F3_SERIE = SD2.D2_SERIE AND SF3.F3_NFISCAL = SD2.D2_DOC AND F3_OBSERV LIKE '%DENEGADA%') "
		cQuery += " AND  NOT EXISTS ( SELECT * FROM SD1010 SD1 WHERE SD1.D_E_L_E_T_ =  ' ' "
		cQuery += " AND SD1.D1_FORNECE = '005866' AND SD1.D1_DOC = SD2.D2_DOC)),0) TRANSITO, "
		cQuery += " NVL((SELECT SUM(C7_QUANT - C7_QUJE  ) FROM SC7010 SC7 WHERE SC7.D_E_L_E_T_ = ' ' AND C7_PRODUTO=SB1.B1_COD "
		cQuery += " AND SC7.C7_FILIAL ='02' AND C7_FORNECE = '005866' AND  C7_QUANT > C7_QUJE AND C7_RESIDUO = ' '),0) SLDPEDCOM, "
		
		/*
		cQuery += " CASE WHEN NVL((SELECT SUM(C6_QTDVEN) FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_CLI = '033467' AND C6_LOJA = '02' "
		cQuery += " AND C6_BLQ = ' ' AND C6_PRODUTO  =  SB1.B1_COD AND C6_OPER = '15' ),0) "
		cQuery += " - "
		cQuery += " NVL((SELECT SUM(D2_QUANT) FROM SD2030 SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_CLIENTE = '033467' "
		cQuery += " AND D2_LOJA = '02' AND D2_EMISSAO > '20150706'),0) "
		cQuery += " + "
		cQuery += " NVL((SELECT SUM(D2_QUANT) FROM SD2030 SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_CLIENTE = '033467' "
		cQuery += " AND D2_LOJA = '02' AND D2_EMISSAO > '20150706' "
		cQuery += " AND NOT EXISTS ( SELECT * FROM SF3030 SF3 WHERE SF3.D_E_L_E_T_ =  ' ' AND SF3.F3_SERIE = SD2.D2_SERIE AND SF3.F3_NFISCAL = SD2.D2_DOC  "
		cQuery += " AND F3_OBSERV LIKE '%DENEGADA%') AND  NOT EXISTS ( SELECT * FROM SD1010 SD1 WHERE SD1.D_E_L_E_T_ =  ' ' AND SD1.D1_FORNECE = '005866'  "
		cQuery += " AND SD1.D1_DOC = SD2.D2_DOC)),0) "
		cQuery += " <> "
		cQuery += " NVL((SELECT SUM(C7_QUANT - C7_QUJE  ) FROM SC7010 SC7 WHERE SC7.D_E_L_E_T_ = ' ' AND SC7.C7_FILIAL ='02' "
		cQuery += " AND C7_PRODUTO=SB1.B1_COD AND C7_FORNECE = '005866' AND  C7_QUANT > C7_QUJE AND C7_RESIDUO = ' '),0) "
		cQuery += " THEN 'ERRADO' ELSE 'CERTO' END STATUS "
		cQuery += " FROM SB1030 SB1 WHERE SB1.D_E_L_E_T_ = ' ' AND B1_TIPO = 'PA' "
		cQuery += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += " AND EXISTS (SELECT * FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_CLI = '033467' AND C6_LOJA = '02' AND C6_BLQ = ' '  "
		cQuery += " AND C6_PRODUTO  =  SB1.B1_COD AND C6_OPER = '15') "
		*/
		
		cQuery += " CASE WHEN NVL((SELECT SUM(C6_QTDVEN-C6_QTDENT) FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_CLI = '033467' AND C6_LOJA = '02' "
		cQuery += " AND C6_BLQ = ' ' AND C6_PRODUTO  =  SB1.B1_COD AND C6_QTDVEN-C6_QTDENT>0 AND C6_OPER = '15' ),0) "
		cQuery += " + "
		cQuery += " NVL((SELECT SUM(D2_QUANT) FROM SD2030 SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_CLIENTE = '033467' "
		cQuery += " AND D2_LOJA = '02' AND D2_EMISSAO > '20150706' "
		cQuery += " AND NOT EXISTS ( SELECT * FROM SF3030 SF3 WHERE SF3.D_E_L_E_T_ =  ' ' AND SF3.F3_SERIE = SD2.D2_SERIE AND SF3.F3_NFISCAL = SD2.D2_DOC  "
		cQuery += " AND F3_OBSERV LIKE '%DENEGADA%') AND  NOT EXISTS ( SELECT * FROM SD1010 SD1 WHERE SD1.D_E_L_E_T_ =  ' ' AND SD1.D1_FORNECE = '005866'  "
		cQuery += " AND SD1.D1_DOC = SD2.D2_DOC)),0) "
		cQuery += " <> "
		cQuery += " NVL((SELECT SUM(C7_QUANT - C7_QUJE  ) FROM SC7010 SC7 WHERE SC7.D_E_L_E_T_ = ' ' AND SC7.C7_FILIAL ='02' "
		cQuery += " AND C7_PRODUTO=SB1.B1_COD AND C7_FORNECE = '005866' AND  C7_QUANT > C7_QUJE AND C7_RESIDUO = ' '),0) "
		cQuery += " THEN 'ERRADO' ELSE 'CERTO' END STATUS "
		
		cQuery += " FROM SB1030 SB1 WHERE SB1.D_E_L_E_T_ = ' ' AND B1_TIPO = 'PA' "
		cQuery += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += " AND EXISTS (SELECT * FROM SC6030 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_CLI = '033467' AND C6_LOJA = '02' AND C6_BLQ = ' '  "
		cQuery += " AND C6_PRODUTO  =  SB1.B1_COD AND C6_OPER = '15') "


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()