#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#DEFINE CL CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATA5     บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio DATA TRANSITO 				                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATA5()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATA5"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Produto de:" 	,"Produto de:" 	 ,"Produto de:" 		,"mv_ch1","C",15,0,0,"G","",'SB1' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Produto Ate:"	,"Produto Ate:"  ,"Produto Ate:"		,"mv_ch2","C",15,0,0,"G","",'SB1' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Da Emissao:"	,"Da Emissao:"	 ,"Da Emissao:"			,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "04", "At้ a Emissao:","At้ a Emissao:","At้ a Emissao:" 		,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")


	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO Data Transito",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio Data Transito")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Data Transito",{"SC6"})


	TRCell():New(oSection,"01",,"PRODUTO"	,,15,.F.,)
	TRCell():New(oSection,"02",,"DESCRIวรO"		,,50,.F.,)
	TRCell():New(oSection,"03",,"QUANTIDADE" 	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"04",,"NF"	    ,,09,.F.,)
	TRCell():New(oSection,"05",,"EMISSAO"	,,10,.F.,)
	TRCell():New(oSection,"06",,"MODAL"	,,10,.F.,)
	TRCell():New(oSection,"07",,"ENTRADA"		,,10,.F.,)
	TRCell():New(oSection,"08",,"FALTA REAL"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"NF CLASSIFICADA"	,"@!",5)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
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

	oReport:SetTitle("MMG")// Titulo do relat๓rio

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
			aDados1[02]	:=  (cAliasLif)->DESCRICAO
			aDados1[03]	:=  (cAliasLif)->QUANTIDADE
			aDados1[04]	:=  (cAliasLif)->NF
			aDados1[05]	:=  DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[06]	:=	(cAliasLif)->MODAL
			aDados1[07]	:= 	DTOC(STOD((cAliasLif)->ENTRADA))
			aDados1[08]	:= 	(cAliasLif)->FALTA_REAL
			aDados1[09]	:= 	IIf(AllTrim((cAliasLif)->F1_STATUS)=="A","Sim","Nใo")

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*-----------------------------*
STATIC FUNCTION StQuery(_ccod)
	LOCAL cQuery := ""

	cQuery := "SELECT D2_COD PRODUTO,B1_DESC DESCRICAO,D2_QUANT QUANTIDADE,D2_DOC NF,D2_EMISSAO EMISSAO,NVL(ZZT_MODAL, ' ') MODAL,F1_DTDIGIT ENTRADA, F1_STATUS, "+CL
	cQuery += "COALESCE(( SELECT SUM(SB2.B2_QATU)  FROM  "+RetSqlName("SB2")+" SB2  WHERE  SB2.D_E_L_E_T_ = ' ' AND SB2.B2_FILIAL = '"+XFILIAL("SB2") +"' "+CL
	cQuery += "AND SB2.B2_COD = SB1.B1_COD AND (SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' ) ),0) - "+CL
	cQuery += "COALESCE((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "+CL
	cQuery += "INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" ) SC5 ON SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' "+CL
	cQuery += "AND SC5.C5_FILIAL = SC6.C6_FILIAL WHERE  SC6.D_E_L_E_T_ = ' ' AND SC6.C6_PRODUTO = SB1.B1_COD AND SC6.C6_FILIAL = '"+XFILIAL("SC6")+"' "+CL
	cQuery += "AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11'  AND SC6.C6_OPER <> '95' AND SC6.C6_OPER <> '11' AND SC6.C6_BLQ <> 'R' "+CL
	cQuery += "AND SC6.C6_CLI <> '033467' AND NOT EXISTS(SELECT *  FROM  "+RetSqlName("SC9")+" SC9  WHERE  SC9.D_E_L_E_T_ = ' ' AND SC9.C9_PEDIDO = SC6.C6_NUM "+CL
	cQuery += "AND SC9.C9_BLCRED IN ('01','09') AND SC9.C9_FILIAL = SC6.C6_FILIAL) AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0) FALTA_REAL "+CL

	//// Quando se tratar da empresa 03 - Manaus ้ ncessแrio passar o usuแrio de acesso ao Banco
	cQuery += "FROM UDBP12.SD2030 SD2 "+CL

	//// Quando se tratar da empresa 03 - Manaus ้ ncessแrio passar o usuแrio de acesso ao Banco
	cQuery += " INNER JOIN (SELECT * FROM UDBP12.SB1030) SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = D2_COD "+CL

	//// Quando se tratar da empresa 03 - Manaus ้ ncessแrio passar o usuแrio de acesso ao Banco
	cQuery += " INNER JOIN (SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_ = ' ' AND ZZT_NF = D2_DOC "+CL

	cQuery += "LEFT JOIN(SELECT * FROM "+RetSqlName("SF1")+") SF1 ON SF1.D_E_L_E_T_ = ' ' "+CL
	cQuery += "AND F1_FORNECE = '005866' "+CL
	cQuery += "AND F1_LOJA = '01' "+CL
	cQuery += "AND F1_DOC = D2_DOC "+CL

	cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' "+CL
	cQuery += " AND D2_CLIENTE = '033467' "+CL
	
	//// Loja antiga que era utilizada na empresa 01 filial 02
	//// cQuery += " AND D2_LOJA = '02' LOJA ANTIGA 
	cQuery += " AND D2_LOJA = '06' "+CL

	cQuery += " AND D2_EMISSAO BETWEEN '"+ DTOS(MV_PAR03)+"' AND '"+ DTOS(MV_PAR04)+"' "+CL
	cQuery += " AND D2_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CL
	
	///cQuery += " AND SD2.D2_DOC <> '000007281'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17 // TRATAMENTO PARA FILIAL 02 RETIRADO.
	///cQuery += " AND SD2.D2_DOC <> '000007280'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17 // TRATAMENTO PARA FILIAL 02 RETIRADO.
	///cQuery += " AND SD2.D2_DOC <> '000007275'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17 // TRATAMENTO PARA FILIAL 02 RETIRADO.

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

