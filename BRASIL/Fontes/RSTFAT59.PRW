#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT59     ºAutor  ³Giovani Zago    º Data ³  29/09/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Unicon						                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT59()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT59"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Numero de:" ,"Da Nota: ?" 	,"Da Nota: ?" 		,"mv_ch1","C",6,0,0,"G","",'' 	 ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Numero Ate:","Ate Nota: ?" ,"Ate Nota: ?" 		,"mv_ch2","C",6,0,0,"G","",'' 	 ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Representante de:" ,"Da Nota: ?" 	," ?" 		,"mv_ch3","C",6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Representante Ate:","Ate Nota: ?" ,"  ?" 		,"mv_ch4","C",6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05"   ,"Da Emissao?         ","",""					,"mv_ch5","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par05",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "06"   ,"Até a Emissao?      ","",""  				,"mv_ch6","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par06",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")


	oReport		:= ReportDef()
	oReport:PrintDialog()

	Return
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio ONE VOICE				                          º±±
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

	oReport := TReport():New(cPergTit,"RELATÓRIO Unicon",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório UNICON")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"UNICON",{"PP7"})



	TRCell():New(oSection,"02",,"CLIENTE"		,,06,.F.,)
	TRCell():New(oSection,"03",,"LOJA" 			,,02,.F.,)
	TRCell():New(oSection,"04",,"NOME"		    ,,25,.F.,)
	TRCell():New(oSection,"05",,"EMISSAO"		,,10,.F.,)
	TRCell():New(oSection,"06",,"REPRESENTANTE"	,,06,.F.,)
	TRCell():New(oSection,"07",,"NOME_REPRE"	,,25,.F.,)
	TRCell():New(oSection,"08",,"VENDEDOR" 		,,06,.F.,)
	TRCell():New(oSection,"09",,"NOME_VENDE"	,,25,.F.,)
	TRCell():New(oSection,"01",,"NUMERO"		,,06,.F.,)
	TRCell():New(oSection,"16",,"STATUS"	    ,,10,.F.,)
	TRCell():New(oSection,"10",,"ITEM"		    ,,04,.F.,)
	TRCell():New(oSection,"11",,"PRODUTO"		,,15,.F.,)
	TRCell():New(oSection,"12",,"DESCRICAO"		,,30,.F.,)
	TRCell():New(oSection,"13",,"QTD"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14",,"PRECO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"15",,"TOTAL"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"17",,"PEDIDO"		,,06,.F.,)
	TRCell():New(oSection,"18",,"EMISSAO"		,,10,.F.,)


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("CB9")

	Return oReport
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio Produtos em transito	                          º±±
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
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _cCod    := ' '
	Local _nQtdPr  := 0

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
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )

	oReport:SetTitle("UNICON")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If (cAliasLif)->PP7_CODIGO <> _cCod
				oSection1:PrintLine()
				aFill(aDados1,nil)
			EndIf

			aDados1[01]	:=  (cAliasLif)->PP7_CODIGO
			aDados1[02]	:=  (cAliasLif)->PP7_CLIENT
			aDados1[03]	:=  (cAliasLif)->PP7_LOJA
			aDados1[04]	:=  (cAliasLif)->PP7_NOME
			aDados1[05]	:=  (cAliasLif)->PP7_EMISSA
			aDados1[06]	:=	(cAliasLif)->PP7_REPRES
			aDados1[07]	:= 	(cAliasLif)->NOME
			aDados1[08]	:= 	(cAliasLif)->PP7_VEND
			aDados1[09]	:=	(cAliasLif)->VENDEDOR
			aDados1[10]	:= 	(cAliasLif)->PP8_ITEM
			aDados1[11]	:=  (cAliasLif)->PP8_PROD
			aDados1[12]	:=  (cAliasLif)->PP8_DESCR
			aDados1[13]	:=  (cAliasLif)->PP8_QUANT
			aDados1[14]	:=	(cAliasLif)->PP8_PRORC
			aDados1[17]	:=	(cAliasLif)->PP8_PEDVEN

			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+(cAliasLif)->PP8_PEDVEN))
				aDados1[18]	:=	DTOC(SC5->C5_EMISSAO)
			EndIf
			aDados1[15]	:= 	(cAliasLif)->TOTAL
			If (cAliasLif)->PP7_STATUS=="1"
				aDados1[16]	:= 	 "Em Aberto"
			ElseIf (cAliasLif)->PP7_STATUS=="2"
				aDados1[16]	:= 	 "Des.Liberados Prod.TOTAL"
			ElseIf (cAliasLif)->PP7_STATUS=="8"
				aDados1[16]	:= 	 "Des.Liberados Prod.PARCIAL"
			ElseIf (cAliasLif)->PP7_STATUS=="3" .And. Empty(Alltrim((cAliasLif)->PP7_PEDIDO))
				aDados1[16]	:= 	 "Sol.Desenho sem PV"
			ElseIf (cAliasLif)->PP7_STATUS=="3" .And. !Empty(Alltrim((cAliasLif)->PP7_PEDIDO))
				aDados1[16]	:= 	 "Sol.Desenho com PV"
			ElseIf (cAliasLif)->PP7_STATUS=="6"
				aDados1[16]	:= 	 "Enviado ao Orcamento"
			ElseIf (cAliasLif)->PP7_STATUS=="7"
				aDados1[16]	:= 	 "Orçamento Cancelado"
			ElseIf (cAliasLif)->PP7_STATUS=="5" .and. Empty(Alltrim((cAliasLif)->PP7_TRAVA))
				aDados1[16]	:= 	 "Aguardando Prc.Final"
			ElseIf (cAliasLif)->PP7_STATUS=="5" .and. !Empty(Alltrim((cAliasLif)->PP7_TRAVA))
				aDados1[16]	:= 	 "Orçamento Finalizado"

			EndIf


			_cCod := (cAliasLif)->PP7_CODIGO


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
	±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
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

	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If SA3->A3_TPVEND <> 'I'
			MV_PAR03    :=  SA3->A3_COD
			MV_PAR04    :=  SA3->A3_COD
		EndIf
	EndIf


	cQuery := " SELECT
	cQuery += " PP7_CODIGO ,
	cQuery += " PP7_CLIENT ,
	cQuery += " PP7_LOJA   , PP7_STATUS,PP7_PEDIDO,PP7_TRAVA,
	cQuery += " PP7_NOME   ,
	cQuery += " SUBSTR(PP7.PP7_EMISSA,7,2)||'/'|| SUBSTR(PP7.PP7_EMISSA,5,2)||'/'|| SUBSTR(PP7.PP7_EMISSA,1,4)
	cQuery += ' "PP7_EMISSA",
	cQuery += " PP7_REPRES ,
	cQuery += "  (SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3  WHERE SA3.D_E_L_E_T_ = ' ' AND SA3.A3_FILIAL = ' ' AND SA3.A3_COD = PP7_REPRES)
	cQuery += ' "NOME" ,
	cQuery += " PP7_VEND   ,
	cQuery += "  (SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3  WHERE SA3.D_E_L_E_T_ = ' ' AND SA3.A3_FILIAL = ' ' AND SA3.A3_COD = PP7_VEND)
	cQuery += ' "VENDEDOR" ,
	cQuery += " PP8_CODIGO ,
	cQuery += " PP8_ITEM   ,
	cQuery += " PP8_PROD   ,
	cQuery += " PP8_GRUPO  ,
	cQuery += " PP8_DESCR  ,
	cQuery += " PP8_QUANT  ,
	cQuery += " PP8_PRORC  ,PP8_PEDVEN,
	cQuery += ' PP8_PRORC * PP8_QUANT "TOTAL"


	cQuery += " FROM "+RetSqlName("PP7")+" PP7 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PP8")+" )PP8 "
	cQuery += " ON PP8.D_E_L_E_T_ = ' '
	cQuery += " AND PP8.PP8_CODIGO = PP7.PP7_CODIGO

	cQuery += " WHERE PP7.D_E_L_E_T_ = ' '
	cQuery += " AND PP7.PP7_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND PP7.PP7_REPRES BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery += " AND PP7.PP7_EMISSA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'
	cQuery += " ORDER BY PP8_CODIGO , PP8_ITEM

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

