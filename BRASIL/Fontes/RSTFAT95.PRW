#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT95     ºAutor  ³Renato Nogueira º Data ³  23/09/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório do frete embarcador			           	       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT95()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFAT95"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .f.
	Private lXmlEndRow   := .f.
	Private cPergTit		:= cAliasLif


	PutSx1(cPerg, "01", "Da Emissao:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Até a Emissao:"	,"Até a Emissao:"		,"Até a Emissao:" 		,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Transp de:"		,"Transp de:"	 		,"Transp de:"				,"mv_ch3","C"   ,06      ,0       ,0      , "G",""    ,"SA4" 	 ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "04", "Transp ate:"		,"Transp ate:"		,"Transp ate:" 			,"mv_ch4","C"   ,06      ,0       ,0      , "G",""    ,"SA4" 	 ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

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

	oReport := TReport():New(cPergTit,"RELATÓRIO FRETE EMBARCADOR",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório do frete embarcador")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SF2",{"SF2"})

	TRCell():New(oSection,"F2_FILIAL"		,,"FILIAL"				,,02,.F.,)
	TRCell():New(oSection,"F2_DOC"			,,"DOCUMENTO"			,,09,.F.,)
	TRCell():New(oSection,"F2_CLIENTE"		,,"CLIENTE"			,,06,.F.,)
	TRCell():New(oSection,"F2_LOJA"			,,"LOJA"				,,02,.F.,)
	TRCell():New(oSection,"A1_NOME"			,,"NOME"				,,40,.F.,)
	TRCell():New(oSection,"F2_EMISSAO"		,,"EMISSAO"			,,10,.F.,)
	TRCell():New(oSection,"F2_VALBRUT"		,,"VAL BRUTO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"F2_VALMERC"		,,"VAL LIQUIDO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"F2_VOLUME1"		,,"VOLUMES"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"F2_PLIQUI"		,,"PESO LIQ"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"F2_PBRUTO"		,,"PESO BRUT"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"F2_TRANSP"		,,"TRANSPORTADORA"	,,06,.F.,)
	TRCell():New(oSection,"A4_NOME"			,,"NOME TRANSP"		,,40,.F.,)
	TRCell():New(oSection,"CTE"				,,"CTE"				,,44,.F.,)
	TRCell():New(oSection,"VLRFRETE"		,,"VALOR FRETE"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"VLRDOC"			,,"VALOR DCTO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"NRFATURA"		,,"FATURA"				,,16,.F.,)
	TRCell():New(oSection,"DTVENC"			,,"DT VENC"			,,10,.F.,)
	TRCell():New(oSection,"DTEMISFA"		,,"DT EMIS"			,,10,.F.,)
	TRCell():New(oSection,"USUAPR"			,,"USER APROV"		,,50,.F.,)
	TRCell():New(oSection,"DTAPR"			,,"DATA APROV"		,,10,.F.,)
	TRCell():New(oSection,"SIT"				,,"SITUACAO"		,,10,.F.,)
	TRCell():New(oSection,"F2_EST"			,,"ESTADO"			,,02,.F.,)
	TRCell():New(oSection,"MOTAPR"			,,"MOTIVO APROV"	,,200,.F.,)
	TRCell():New(oSection,"1_FREDC"			,,"FRETE DOCUMENTO DE CARGA",,5,.F.,)
	TRCell():New(oSection,"2_FRENF"			,,"FRETE NOTA FISCAL"		,,5,.F.,)
	

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")

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

oSection1:Cell('F2_FILIAL')  	:SetBlock( { || aDados1[01] } )
oSection1:Cell('F2_DOC')  	:SetBlock( { || aDados1[02] } )
oSection1:Cell('F2_CLIENTE')  		:SetBlock( { || aDados1[03] } )
oSection1:Cell('F2_LOJA') 		:SetBlock( { || aDados1[04] } )
oSection1:Cell('A1_NOME')  	:SetBlock( { || aDados1[05] } )
oSection1:Cell('F2_EMISSAO')  		:SetBlock( { || aDados1[06] } )
oSection1:Cell('F2_VALBRUT')  		:SetBlock( { || aDados1[07] } )
oSection1:Cell('F2_VALMERC') 		:SetBlock( { || aDados1[08] } )
oSection1:Cell('F2_VOLUME1')  		:SetBlock( { || aDados1[09] } )
oSection1:Cell('F2_PLIQUI') 		:SetBlock( { || aDados1[10] } )
oSection1:Cell('F2_PBRUTO') 		:SetBlock( { || aDados1[11] } )
oSection1:Cell('F2_TRANSP') 	:SetBlock( { || aDados1[12] } )
oSection1:Cell('A4_NOME') 		:SetBlock( { || aDados1[13] } )
oSection1:Cell('CTE') 		:SetBlock( { || aDados1[14] } )
oSection1:Cell('VLRFRETE') 		:SetBlock( { || aDados1[15] } )
oSection1:Cell('NRFATURA') 		:SetBlock( { || aDados1[16] } )
oSection1:Cell('DTVENC') 		:SetBlock( { || aDados1[17] } )
oSection1:Cell('DTEMISFA') 		:SetBlock( { || aDados1[18] } )
oSection1:Cell('VLRDOC') 		:SetBlock( { || aDados1[19] } )
oSection1:Cell('USUAPR') 		:SetBlock( { || aDados1[20] } )
oSection1:Cell('DTAPR') 		:SetBlock( { || aDados1[21] } )
oSection1:Cell('MOTAPR') 		:SetBlock( { || aDados1[22] } )
oSection1:Cell('SIT') 		:SetBlock( { || aDados1[23] } )
oSection1:Cell('F2_EST') 		:SetBlock( { || aDados1[24] } )
oSection1:Cell('1_FREDC') 		:SetBlock( { || aDados1[25] } )
oSection1:Cell('2_FRENF') 		:SetBlock( { || aDados1[26] } )

	oReport:SetTitle("SF2")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
		
			aDados1[01]	:=  (cAliasLif)->F2_FILIAL
			aDados1[02]	:=  (cAliasLif)->F2_DOC
			aDados1[03]	:=  (cAliasLif)->F2_CLIENTE
			aDados1[04]	:=  (cAliasLif)->F2_LOJA
			aDados1[05]	:=  (cAliasLif)->A1_NOME
			aDados1[06]	:=	 DTOC(STOD((cAliasLif)->F2_EMISSAO))
			aDados1[07]	:= 	(cAliasLif)->F2_VALBRUT
			aDados1[08]	:= 	(cAliasLif)->F2_VALMERC
			aDados1[09]	:=	(cAliasLif)->F2_VOLUME1
			aDados1[10]	:=	(cAliasLif)->F2_PLIQUI
			aDados1[11]	:=	(cAliasLif)->F2_PBRUTO
			aDados1[12]	:=	(cAliasLif)->F2_TRANSP
			aDados1[13]	:=	(cAliasLif)->A4_NOME
			aDados1[14]	:=	(cAliasLif)->CTE
			aDados1[15]	:=	(cAliasLif)->VLRFRETE
			aDados1[16]	:=	(cAliasLif)->NRFATURA
			aDados1[17]	:=	DTOC(STOD((cAliasLif)->DTVENC))
			aDados1[18]	:=	DTOC(STOD((cAliasLif)->DTEMISFA))
			aDados1[19]	:=	(cAliasLif)->VLRDOC
			aDados1[20]	:=	(cAliasLif)->USUAPR
			aDados1[21]	:=	DTOC(STOD((cAliasLif)->DTAPR))
			aDados1[22]	:=	(cAliasLif)->MOTAPR
			aDados1[23]	:=	IIf((cAliasLif)->SIT=="3","SISTEMA",IIf((cAliasLif)->SIT=="4","USUARIO",""))
			aDados1[24]	:=	(cAliasLif)->F2_EST
			aDados1[25]	:=	IIf((cAliasLif)->GW1_TPFRET=="1","CIF",IIf((cAliasLif)->GW1_TPFRET=="3","FOB",(cAliasLif)->GW1_TPFRET))
			aDados1[26]	:=	IIf((cAliasLif)->F2_TPFRETE=="C","CIF",IIf((cAliasLif)->F2_TPFRETE=="F","FOB",(cAliasLif)->F2_TPFRETE))

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

		cQuery := " SELECT F2_FILIAL, F2_DOC, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_VALBRUT, F2_VALMERC, F2_VOLUME1, "  
		cQuery += " F2_PLIQUI, F2_PBRUTO, F2_TRANSP, NVL(GW3_CTE,0) CTE, NVL(SUM(GWI_VLFRET),0) VLRFRETE, NVL(GW3_NRFAT,0) NRFATURA, "
		cQuery += " NVL(GW3_DTVNFT,0) DTVENC, NVL(GW3_DTEMFA,0) DTEMISFA, A4_NOME, "
		cQuery += " NVL(GW3_VLDF,0) VLRDOC, NVL(GW3_USUAPR,' ') USUAPR, NVL(GW3_DTAPR,' ') DTAPR, "
		cQuery += " NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(GW3_MOTAPR, 2000, 1)),' ') MOTAPR, NVL(GW3_SIT, ' ') SIT, F2_EST, GW1_TPFRET, F2_TPFRETE "
		cQuery += " FROM "+RetSqlName("SF2")+" F2 "
		cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
		cQuery += " ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "
		cQuery += " LEFT JOIN "+RetSqlName("GW1")+" G1 "
		cQuery += " ON GW1_FILIAL=F2_FILIAL AND GW1_SERDC=F2_SERIE AND GW1_NRDC=F2_DOC AND G1.D_E_L_E_T_=' ' "
		cQuery += " LEFT JOIN "+RetSqlName("GWH")+" GH "
		cQuery += " ON GWH_FILIAL=GW1_FILIAL AND GW1_SERDC=GWH_SERDC AND GW1_NRDC=GWH_NRDC AND GH.D_E_L_E_T_=' ' "
		cQuery += " LEFT JOIN "+RetSqlName("GWI")+" GI "
		cQuery += " ON GWH_FILIAL=GWI_FILIAL AND GWH_NRCALC=GWI_NRCALC AND GI.D_E_L_E_T_=' ' "
		cQuery += " LEFT JOIN "+RetSqlName("GW4")+" G4 "
		cQuery += " ON GW1_FILIAL=GW4_FILIAL AND GW1_SERDC=GW4_SERDC AND GW1_NRDC=GW4_NRDC AND G4.D_E_L_E_T_=' ' "
		cQuery += " LEFT JOIN "+RetSqlName("GW3")+" G3 "
		cQuery += " ON GW3_FILIAL=GW4_FILIAL AND GW3_CDESP=GW4_CDESP AND GW3_SERDF=GW4_SERDF AND GW3_NRDF=GW4_NRDF AND G3.D_E_L_E_T_=' '  "
		cQuery += " LEFT JOIN "+RetSqlName("SA4")+" A4 "
		cQuery += " ON A4_COD=F2_TRANSP AND A4.D_E_L_E_T_=' '  "
		cQuery += " WHERE F2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		cQuery += " AND F2_TRANSP BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery += " GROUP BY F2_FILIAL, F2_DOC, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_VALBRUT, "
		cQuery += " F2_VALMERC, F2_VOLUME1, F2_PLIQUI, F2_PBRUTO, F2_TRANSP, GW3_CTE, GW3_NRFAT, GW3_DTVNFT, GW3_DTEMFA, A4_NOME "
		cQuery += " ,GW3_VLDF, GW3_USUAPR, GW3_DTAPR, GW3_SIT, F2_EST, GW1_TPFRET, F2_TPFRETE, utl_raw.cast_to_varchar2(dbms_lob.substr(GW3_MOTAPR, 2000, 1)) "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()