#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFATR05    บAutor  ณRichard N. Cabral   บ Data ณ  18/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de classificacao de pedidos                        บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function STFATR05()				//U_STFATR05()
*-----------------------------*
	Local   oReport
	Private cPerg			:= "STFATR05"
	Private cTime			:= Time()
	Private cHora			:= SUBSTR(cTime, 1, 2)
	Private cMinutos		:= SUBSTR(cTime, 4, 2)
	Private cSegundos		:= SUBSTR(cTime, 7, 2)
	Private cAliasLif		:= cPerg+cHora+cMinutos+cSegundos
	Private lXlsHeader		:= .f.
	Private lXmlEndRow		:= .f.
	Private cPergTit		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data Emissใo de?" 		   		,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data Emissใo ate?"				,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef   บAutor  ณRichard N. Cabral   บ Data ณ  18/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de classificacao de pedidos                        บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relat๓rio de classifica็ใo de pedidos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de classifica็ใo de pedidos")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SF2",{"SF2"})

	TRCell():New(oSection,"SITUACAO"		,,"SITUAวรO PEDIDO"		,,30,.F.,)					//01
	TRCell():New(oSection,"C5_NUM"			,,"NUMERO PEDIDO"		,,10,.F.,)					//02
	TRCell():New(oSection,"C5_CLIENTE"		,,"CLIENTE"				,,06,.F.,)					//03
	TRCell():New(oSection,"C5_LOJACLI"		,,"LOJA"				,,02,.F.,)					//04
	TRCell():New(oSection,"A1_NOME"			,,"NOME"				,,40,.F.,)					//05
	TRCell():New(oSection,"C5_EMISSAO"		,,"EMISSAO"				,,10,.F.,)					//06
	TRCell():New(oSection,"C5_ZDTREJE"		,,"DATA REJEIวรO"		,,10,.F.,)					//07
	TRCell():New(oSection,"C5_ZMOTREJ"		,,"REJEIวรO FINANC"		,,254,.F.,)					//08
	TRCell():New(oSection,"C5_XMOTRES"		,,"MOTIVO RESIDUO"		,,200,.F.,)					//09
	TRCell():New(oSection,"VALLIQ"			,,"VAL.LIQ.PEDIDO"		,"@E 99,999,999.99",14)		//10

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrint บAutor  ณRichard N. Cabral   บ Data ณ  18/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio MMG                                                บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell('SITUACAO')  		:SetBlock( { || aDados1[01] } )
	oSection1:Cell('C5_NUM')  			:SetBlock( { || aDados1[02] } )
	oSection1:Cell('C5_CLIENTE') 		:SetBlock( { || aDados1[03] } )
	oSection1:Cell('C5_LOJACLI')  		:SetBlock( { || aDados1[04] } )
	oSection1:Cell('A1_NOME') 			:SetBlock( { || aDados1[05] } )
	oSection1:Cell('C5_EMISSAO')  		:SetBlock( { || aDados1[06] } )
	oSection1:Cell('C5_ZDTREJE') 		:SetBlock( { || aDados1[07] } )
	oSection1:Cell('C5_ZMOTREJ') 		:SetBlock( { || aDados1[08] } )
	oSection1:Cell('C5_XMOTRES') 		:SetBlock( { || aDados1[09] } )
	oSection1:Cell('VALLIQ') 		 	:SetBlock( { || aDados1[10] } )

	oReport:SetTitle("SF2")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	GWI->(DbSetOrder(1))
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0
	
		Do While (cAliasLif)->(!Eof())

			aDados1[01]	:=  (cAliasLif)->STATUS
			aDados1[02]	:=  (cAliasLif)->C5_NUM
			aDados1[03]	:=  (cAliasLif)->C5_CLIENTE
			aDados1[04]	:=  (cAliasLif)->C5_LOJACLI
			aDados1[05]	:=  (cAliasLif)->A1_NOME
			aDados1[06]	:=  DTOC(STOD((cAliasLif)->C5_EMISSAO))
			aDados1[07]	:= 	DTOC(STOD((cAliasLif)->C5_ZDTREJE))
			aDados1[08]	:= 	(cAliasLif)->C5_ZMOTREJ
			aDados1[09]	:= 	(cAliasLif)->C5_XMOTRES
			aDados1[10]	:= 	(cAliasLif)->VALLIQ

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		EndDo
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStQuery     บAutor  ณRichard N. Cabral   บ Data ณ  18/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de classificacao de pedidos                        บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT " + CRLF 
	cQuery += " STATUS, C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO,  C5_ZDTREJE, C5_ZMOTREJ, C5_XMOTRES, SUM(VALLIQ) VALLIQ " + CRLF
	cQuery += " FROM (  " + CRLF
	cQuery += " SELECT  " + CRLF
	cQuery += " ( CASE WHEN SUBSTR(C5_NOTA,1,1) = 'X' THEN 'CANCELADO' " + CRLF 
	cQuery += " WHEN C9_BLCRED =  '  ' THEN 'LIBERADO SEM FATURAR'  " + CRLF
	cQuery += " WHEN C9_NFISCAL <> ' ' THEN 'FATURADO'  " + CRLF
	cQuery += " WHEN C9_BLCRED = '09' THEN 'REJEITADO'  " + CRLF
	cQuery += " END  " + CRLF
	cQuery += " ) STATUS,  " + CRLF
	cQuery += " C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_NOTA, C9_NFISCAL, " + CRLF 
	cQuery += " C5_ZDTREJE, C5_ZMOTREJ, C5_XMOTRES, SUM(C9_QTDLIB * C9_PRCVEN) VALLIQ, NVL(C9_BLCRED,'  ') C9_BLCRED, NVL(C9_BLEST,'  ') C9_BLEST " + CRLF 
	cQuery += " FROM " + RetSqlName("SC5") + " C5  " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SC9") + " C9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9_CLIENTE = C5_CLIENTE AND C9_LOJA = C5_LOJACLI AND C9.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI  " + CRLF
	cQuery += " WHERE C5.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
	cQuery += " GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_NOTA, C9_NFISCAL, " + CRLF 
	cQuery += " C5_ZDTREJE, C5_ZMOTREJ, C5_XMOTRES, C9_BLCRED, C9_BLEST  " + CRLF
	cQuery += " ) XXX  " + CRLF
	cQuery += " GROUP BY  STATUS, C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_ZDTREJE, C5_ZMOTREJ, C5_XMOTRES " + CRLF
	cQuery += " ORDER BY C5_FILIAL, C5_NUM " + CRLF

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()