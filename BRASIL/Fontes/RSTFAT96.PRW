#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT96     บAutor  ณRenato Nogueira บ Data ณ  25/09/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de pedidos de compras	 	           	       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT96()
	*-----------------------------*
	Local   oReport
	Local _cQuery1 			:= ""
	Private cPerg 			:= "RFAT96"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   	:= .f.
	Private lXmlEndRow   	:= .f.
	Private cPergTit		:= cAliasLif

	_cQuery1 := " MERGE INTO "+RetSqlName("SC7")+" C7
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C7.R_E_C_N_O_ RECSC7, MAX(C1_MOTIVO) MOTIVO
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC1")+" C1
	_cQuery1 += " ON C1_FILIAL=C7_FILIAL AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_MOTIVO=' ' AND C7_NUMSC<>' ' AND C1_MOTIVO<>' '
	_cQuery1 += " GROUP BY C7.R_E_C_N_O_
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (C7.R_E_C_N_O_=XXX.RECSC7)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET C7.C7_MOTIVO=XXX.MOTIVO
	
	TcSqlExec(_cQuery1)

	PutSx1(cPerg, "01", "Da Emissao:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "At้ a Emissao:"	,"At้ a Emissao:"		,"At้ a Emissao:" 		,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Motivo de:"		,"Motivo de:"	 		,"Motivo de:"				,"mv_ch3","C"   ,03      ,0       ,0      , "G",""    ,"SZ1" 	 ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "04", "Motivo ate:"		,"Motivo ate:"		,"Motivo ate:" 			,"mv_ch4","C"   ,03      ,0       ,0      , "G",""    ,"SZ1" 	 ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

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

	oReport := TReport():New(cPergTit,"RELATำRIO PEDIDO DE COMPRA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de pedidos de compra")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SC7",{"SC7"})

	TRCell():New(oSection,"EMISSAO"			,,"EMISSAO"			,,10,.F.,)
	TRCell():New(oSection,"PEDIDO"			,,"PEDIDO"				,,06,.F.,)
	TRCell():New(oSection,"PRODUTO"			,,"PRODUTO"			,,15,.F.,)
	TRCell():New(oSection,"DESCRICAO"		,,"DESCRICAO"			,,50,.F.,)
	TRCell():New(oSection,"QTDE"			,,"QUANTIDADE"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"PRCVEN"			,,"PRECO"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"VLRTOT"			,,"TOTAL"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"MOTIVO"			,,"MOTIVO"				,,03,.F.,)
	TRCell():New(oSection,"FILIAL"			,,"FILIAL"				,,02,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC7")

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
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell('EMISSAO')  		:SetBlock( { || aDados1[01] } )
	oSection1:Cell('PEDIDO')  		:SetBlock( { || aDados1[02] } )
	oSection1:Cell('PRODUTO')  		:SetBlock( { || aDados1[03] } )
	oSection1:Cell('DESCRICAO') 	:SetBlock( { || aDados1[04] } )
	oSection1:Cell('QTDE')  			:SetBlock( { || aDados1[05] } )
	oSection1:Cell('PRCVEN')  		:SetBlock( { || aDados1[06] } )
	oSection1:Cell('VLRTOT')  		:SetBlock( { || aDados1[07] } )
	oSection1:Cell('MOTIVO') 		:SetBlock( { || aDados1[08] } )
	oSection1:Cell('FILIAL') 		:SetBlock( { || aDados1[09] } )

	oReport:SetTitle("SC7")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=  DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[02]	:=	(cAliasLif)->PEDIDO
			aDados1[03]	:=	(cAliasLif)->PRODUTO
			aDados1[04]	:=	(cAliasLif)->DESCRICAO
			aDados1[05]	:=	(cAliasLif)->QTDE
			aDados1[06]	:=	(cAliasLif)->PRCVEN
			aDados1[07]	:= 	(cAliasLif)->VLRTOT
			aDados1[08]	:= 	(cAliasLif)->MOTIVO
			aDados1[09]	:= 	(cAliasLif)->FILIAL

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
Static Function StQuery(_ccod)
	*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT C7_FILIAL FILIAL, C7_EMISSAO EMISSAO, C7_NUM PEDIDO, B1_COD PRODUTO, B1_DESC DESCRICAO, "
	cQuery += " C7_QUANT QTDE, C7_PRECO PRCVEN, C7_TOTAL VLRTOT, C7_MOTIVO MOTIVO "
	cQuery += " FROM "+RetSqlName("SC7")+" C7 "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1_COD=C7_PRODUTO "
	cQuery += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	cQuery += " AND C7_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND C7_MOTIVO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()