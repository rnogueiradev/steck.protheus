#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT82     ºAutor  ³Renato Nogueira º Data ³  18/06/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de alterações de fornecedores                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT82()
*-----------------------------*          
	Local   oReport
	Private cPerg 			:= "RFAT82"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	PutSx1( cPerg, "01","Forn de:"				,"","","mv_ch1","C",06,0,0,"G","","SA2" 	,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Forn até:"				,"","","mv_ch2","C",06,0,0,"G","","SA2" 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Data de:"				,"","","mv_ch3","D",08,0,0,"G","","" 	  	,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Data até:"				,"","","mv_ch4","D",08,0,0,"G","",""     	,"","","mv_par04","","","","","","","","","","","","","","","","")

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
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"FORNECEDORES",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de alterações em fornecedores")

	Pergunte(cPerg,.F.)

	oSection  := TRSection():New(oReport,"FORNECEDORES",{"SA2"})

	TRCell():New(oSection,"FORNECE"		,,"FORNECEDOR"							,,06,.F.,)
	TRCell():New(oSection,"LOJA"		,,"LOJA"									,,02,.F.,)
	TRCell():New(oSection,"NOMEFOR"		,,"NOME"									,,50,.F.,)
	TRCell():New(oSection,"TIPO"		,,"TIPO"									,,50,.F.,)
	TRCell():New(oSection,"DTINCLU"		,,"INCLUSAO"								,,10,.F.,)
	TRCell():New(oSection,"DTALTER"		,,"ULT ALTERACAO"							,,10,.F.,)
	TRCell():New(oSection,"SOLIC"		,,"SOLICITANTE"							,,50,.F.,)
	TRCell():New(oSection,"USER"		,,"COMPRADOR"								,,50,.F.,)
	TRCell():New(oSection,"QUANT"		,,"QTDE ALTERAÇÕES"						,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ALTERACOES"	,,"ALTERAÇÕES"							,,  ,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SA2")

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
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local _nTotal	:= 0

	oSection1:Cell("FORNECE") 			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("LOJA") 				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("NOMEFOR") 			:SetBlock( { || aDados1[03] } )
	oSection1:Cell("DTINCLU") 			:SetBlock( { || aDados1[04] } )
	oSection1:Cell("SOLIC") 				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("USER")	 			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("QUANT") 				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("ALTERACOES")	 	:SetBlock( { || aDados1[08] } )
	oSection1:Cell("DTALTER")		 	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("TIPO")			 	:SetBlock( { || aDados1[10] } )

	oReport:SetTitle("FORNECEDORES")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
	
			DbSelectArea("SA2")
			SA2->(DbGoTop())
			SA2->(DbGoTo((cAliasLif)->REGISTRO))
		
			If SA2->(!Eof())
	
				aDados1[01]	:=	(cAliasLif)->FORNECE
				aDados1[02]	:= 	(cAliasLif)->LOJA
				aDados1[03]	:=  (cAliasLif)->NOMEFOR
				aDados1[04]	:=  FWLeUserlg("A2_USERLGI",2)
				aDados1[05]	:=  (cAliasLif)->SOLIC
				aDados1[06]	:=  FWLeUserlg("A2_USERLGI",1)
				aDados1[07]	:=  (cAliasLif)->QTDALT
				aDados1[08]	:=  SA2->A2_XLOG
				aDados1[09]	:=  FWLeUserlg("A2_USERLGA",2)
				aDados1[10]	:=  IIF((cAliasLif)->A2_USERLGA==(cAliasLif)->A2_USERLGI,"INCLUSAO","ALTERACAO")
		
			EndIf

			If CTOD(aDados1[09])>=mv_par03 .And. CTOD(aDados1[09])<=mv_par04
				oSection1:PrintLine()
			EndIf
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
		(cAliasLif)->(dbCloseArea())
	EndIf

	oReport:SkipLine()

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

	cQuery := " SELECT FORNECE, LOJA, NOMEFOR, SOLIC, DATAALT, DATAINC, QTDALT, REGISTRO, A2_USERLGA, A2_USERLGI "
	cQuery += " FROM ( "
	cQuery += " SELECT A2_COD FORNECE, A2_LOJA LOJA, A2_NOME NOMEFOR, A2_XSOLIC SOLIC, A2_XQTDALT QTDALT, R_E_C_N_O_ REGISTRO, A2_USERLGA, A2_USERLGI,  "
	cQuery += " EXTRACT(YEAR FROM (ASCII(SUBSTR(A2_USERLGA,12,1)) - 50|| ASCII(SUBSTR(A2_USERLGA,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD'))|| "
	cQuery += " EXTRACT(MONTH FROM (ASCII(SUBSTR(A2_USERLGA,12,1)) - 50||ASCII(SUBSTR(A2_USERLGA,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD'))|| "
	cQuery += " EXTRACT(DAY FROM (ASCII(SUBSTR(A2_USERLGA,12,1)) - 50|| ASCII(SUBSTR(A2_USERLGA,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD')) AS DATAALT, "
	cQuery += " EXTRACT(YEAR FROM (ASCII(SUBSTR(A2_USERLGI,12,1)) - 50||ASCII(SUBSTR(A2_USERLGI,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD'))|| "
	cQuery += " EXTRACT(MONTH FROM (ASCII(SUBSTR(A2_USERLGI,12,1)) - 50||ASCII(SUBSTR(A2_USERLGI,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD'))|| "
	cQuery += " EXTRACT(DAY FROM (ASCII(SUBSTR(A2_USERLGI,12,1)) - 50||ASCII(SUBSTR(A2_USERLGI,16,1)) - 50) + "
	cQuery += " TO_DATE('19960101','YYYYMMDD')) AS DATAINC "
	cQuery += " FROM "+RetSqlName("SA2")+" A2 "
	cQuery += " WHERE A2.D_E_L_E_T_=' ' AND A2_XLOG IS NOT NULL "
	cQuery += " ) "
	cQuery += " WHERE FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " ORDER BY FORNECE "

//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()