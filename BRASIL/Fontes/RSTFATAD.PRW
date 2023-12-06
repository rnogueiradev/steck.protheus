#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  RSTFATAD    ∫Autor  ≥Giovani Zago    ∫ Data ≥  02/03/16      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Planilha de Bonus				                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*-----------------------------*
User Function RSTFATAD()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAD"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cAliasP		   	:= 'P'+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	If !(__cUserId $ Getmv("ST_CODBUN",,"000000/000645/000314/000294/000251/")+"000000/000645")
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cUserId))
			If !(SUBSTR(SA3->A3_COD,1,1) $ 'G/S')
				MsgInfo("usuario sem acesso")
				Return()
			EndIf
		EndIf
	EndIf

	PutSx1(cPerg, "01", "Ano Base:" 	,"Produto de:" 	 ,"Produto de:" 		,"mv_ch1","C",4,0,0,"G","",'' ,"","","MV_PAR01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Grupo de:"		,"Produto Ate:"  ,"Produto Ate:"		,"mv_ch2","C",6,0,0,"G","",'PH4' ,"","","MV_PAR02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Grupo Ate:"	,"Da Emissao:"	 ,"Da Emissao:"			,"mv_ch3","C",6,0,0,"G","","PH4" ,"","","MV_PAR03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "04", "Tipo:"         ,"Tipo:"         ,"Tipo:"       		,"mv_ch4","N",1,0,2,"C","","","","","MV_PAR04","Todos","","","","Marketing","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Codigo" 		,"Produto de:" 	 ,"Produto de:" 		,"mv_ch5","C",6,0,0,"G","",'SA1' ,"","","MV_PAR05","","","","","","","","","","","","","","","","")


	oReport		:= ReportDef()
	oReport:PrintDialog()

	Return
	/*
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ReportDef    ∫Autor  ≥Giovani Zago    ∫ Data ≥  04/07/15     ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥  Relatorio MMG 							                  ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ AP                                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
	*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELAT”RIO DE BONUS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir um relatÛrio DE BONUS")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Planilha de Bonus",{"PH4"})

	TRCell():New(oSection,"20",,"NUMERO"				,,30,.F.,)
	TRCell():New(oSection,"01",,"GRUPO"				,,30,.F.,)
	TRCell():New(oSection,"02",,"COORDENADOR"		,,06,.F.,)
	TRCell():New(oSection,"03",,"NOME" 				,,30,.F.,)
	TRCell():New(oSection,"04",,TIRA1(MV_PAR01)    	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"05",,"META"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"06",,MV_PAR01    		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"07",,"FALTA"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"ALCANCADO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"CONDICIONAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"10",,"MARKETING"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"11",,"INCONDICIONAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12",,"ACMARKETING"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13",,"ACCOMERCIAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14",,"ESTIMADO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"15",,"LIQUIDO"			,"@E 99,999,999.99",14)

	TRCell():New(oSection,"16",,"%CONDICIONAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"17",,"%INCONDICIONAL"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"18",,"%MARKETING"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"19",,"CAPT.ABERTO"		,"@E 99,999,999.99",14)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("PH4")

	Return oReport
	/*
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ReportPrint  ∫Autor  ≥Giovani Zago    ∫ Data ≥  04/07/15     ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥  Relatorio MMG 							                  ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ AP                                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
	*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
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
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	oSection1:Cell("20") :SetBlock( { || aDados1[20] } )

	oReport:SetTitle("Planilha de Bonus")// Titulo do relatÛrio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=  (cAliasLif)->GRUPO
			aDados1[02]	:=  (cAliasLif)->COORDENADOR
			aDados1[03]	:=  (cAliasLif)->NOME
			aDados1[20]	:=  (cAliasLif)->PH4_NUM

			Processa({|| StPQuery('1') },"Compondo Relatorio")
			aDados1[04]	:=  (cAliasP)->(A201501+A201503)
			aDados1[05]	:=  (cAliasP)->META
			aDados1[06]	:=  (cAliasP)->(A201601+A201603)
			aDados1[07]	:=  (cAliasP)->(META-(A201601+A201603))
			aDados1[08]	:=  (cAliasP)->((A201601+A201603)/META*100)

			Processa({|| StPQuery('21') },"Compondo Relatorio")
			aDados1[09]	:=  (cAliasP)->CONDICIONAL
			aDados1[10]	:=  (cAliasP)->MARKETING
			aDados1[11]	:=  (cAliasP)->INCONDICIONAL

			Processa({|| StPQuery('23') },"Compondo Relatorio")
			aDados1[09]	+=  (cAliasP)->CONDICIONAL
			aDados1[10]	+=  (cAliasP)->MARKETING
			aDados1[11]	+=  (cAliasP)->INCONDICIONAL

			Processa({|| StPQuery('31') },"Compondo Relatorio")
			aDados1[12]	:=  (cAliasP)->ACMARKETING
			aDados1[13]	:=  (cAliasP)->ACCOMERCIAL
			aDados1[14]	:=  (cAliasP)->ESTIMADO
			aDados1[15]	:=  (cAliasP)->LIQUIDO
			aDados1[16]	:=  (cAliasP)->A16
			aDados1[17]	:=  (cAliasP)->A17
			aDados1[18]	:=  (cAliasP)->A18
			aDados1[19]	:=  (cAliasP)->A19

			Processa({|| StPQuery('33') },"Compondo Relatorio")
			aDados1[14]	+=  (cAliasP)->ESTIMADO
			aDados1[15]	+=  (cAliasP)->LIQUIDO
			aDados1[19]	+=  (cAliasP)->A19

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	If Select(cAliasP) > 0
		(cAliasP)->(dbCloseArea())
	EndIf

	Return oReport

	/*
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  StQuery      ∫Autor  ≥Giovani Zago    ∫ Data ≥  04/07/15     ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥  Relatorio MMG 							                  ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ AP                                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
	*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT " + CRLF
	cQuery += " PH4_DESC " + CRLF
	cQuery += ' "GRUPO", ' + CRLF
	cQuery += "  PH4_COORD " + CRLF
	cQuery += ' "COORDENADOR", ' + CRLF
	cQuery += " PH4_NOMEC " + CRLF
	cQuery += ' "NOME", PH4_NUM ' + CRLF

	cQuery += " FROM PH4010 PH4 " + CRLF

	If MV_PAR04 = 2
		cQuery += " INNER JOIN (SELECT * FROM PHB010) PHB " + CRLF
		cQuery += " ON PHB.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += " AND PHB_NUM = PH4_NUM " + CRLF
		cQuery += " AND PHB_VALOR <> 0 " + CRLF
	EndIf

	cQuery += " WHERE PH4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " and ph4_num between '" + MV_PAR02 + "' and '" + MV_PAR03 + "' " + CRLF
	cQuery += " and exists (SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
	cQuery += " AND PH6_ANO = '" + MV_PAR01 + "') " + CRLF
	cQuery += " AND PH4_RSN <> '2' " //GIOVANI ZAGO CHAMADO 009173 12/03/19 
	If !(__cUserId $ Getmv("ST_CODBUN",,"000000/000645/000314/000294/000251/")+"000000/000645")
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cUserId))
			cQuery += " AND PH4_COORD = '"+SA3->A3_COD+"' " + CRLF
		EndIf
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	Return()

	/*
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  StPQuery     ∫Autor  ≥Giovani Zago    ∫ Data ≥  04/07/15     ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥  Relatorio MMG 							                  ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ AP                                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
	*/
	*-----------------------------*
Static Function StPQuery(_ccod)
	*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT '"+ substr((cAliasLif)->PH4_NUM,4,3)+"' C, " + CRLF
	cQuery += " PH4_DESC " + CRLF
	cQuery += ' "GRUPO", ' + CRLF

	cQuery += " PH4_COORD " + CRLF
	cQuery += ' "COORDENADOR", ' + CRLF
	cQuery += " PH4_NOMEC " + CRLF
	cQuery += ' "NOME", ' + CRLF

	If _ccod = '1'

		cQuery += " NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + TIRA1(MV_PAR01) + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + TIRA1(MV_PAR01) + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A201501", ' + CRLF

		cQuery += " NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + TIRA1(MV_PAR01) + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + TIRA1(MV_PAR01) + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A201503", ' + CRLF

		cQuery += " NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += ' "META", ' + CRLF

		cQuery += " NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A201601", ' + CRLF

		cQuery += " NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A201603" ' + CRLF

		//		cQuery += " NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		//		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) -(NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		//		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		//		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) " + CRLF
		//		cQuery += ' "FALTA" ' + CRLF

	ElseIf _ccod = '21'

		//		cQuery += " ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		//		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		//		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		//		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2) " + CRLF
		//		cQuery += ' "ALCANCADO", ' + CRLF

		cQuery += " CASE WHEN NVL(( SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM   = PH4_NUM AND PH7_TARGET   <= (ROUND(( ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2)) ),0) <> 0  THEN ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) * ( NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM             = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM             = PH4_NUM AND PH7_TARGET          <= ROUND(( ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))),0) / 100) ELSE 0 END " + CRLF
		cQuery += ' "CONDICIONAL", ' + CRLF

		cQuery += " ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) *(( SELECT PHB_VALOR FROM PHB010 PHB WHERE PHB.D_E_L_E_T_ = ' ' AND PHB.PHB_NUM           = PH4_NUM) / 100) " + CRLF
		cQuery += ' "MARKETING", ' + CRLF

		cQuery += " ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) *(( SELECT PHA_PERCEN FROM PHA010 PHA WHERE PHA.D_E_L_E_T_ = ' ' AND PHA.PHA_NUM           = PH4_NUM) / 100) " + CRLF
		cQuery += ' "INCONDICIONAL" ' + CRLF

	ElseIf _ccod = '23'

		cQuery += " CASE WHEN NVL(( SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM   = PH4_NUM AND PH7_TARGET   <= (ROUND(( ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2)) ),0) <> 0  THEN ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) * ( NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM             = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM             = PH4_NUM AND PH7_TARGET          <= ROUND(( ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))),0) / 100) ELSE 0 END " + CRLF
		cQuery += ' "CONDICIONAL", ' + CRLF

		cQuery += " ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) *(( SELECT PHB_VALOR FROM PHB010 PHB WHERE PHB.D_E_L_E_T_ = ' ' AND PHB.PHB_NUM           = PH4_NUM) / 100) " + CRLF
		cQuery += ' "MARKETING", ' + CRLF

		cQuery += " ( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) *(( SELECT PHA_PERCEN FROM PHA010 PHA WHERE PHA.D_E_L_E_T_ = ' ' AND PHA.PHA_NUM           = PH4_NUM) / 100) " + CRLF
		cQuery += ' "INCONDICIONAL" ' + CRLF

	ElseIf _ccod = '31'

		cQuery += " NVL((SELECT SUM(PH8_VALOR) FROM PH8010 PH8 WHERE PH8.D_E_L_E_T_ = ' 'AND PH8.PH8_NUM           = PH4_NUM),0) " + CRLF
		cQuery += ' "ACMARKETING", ' + CRLF

		cQuery += " NVL((SELECT SUM(PH9_VALOR) FROM PH9010 PH9 WHERE PH9.D_E_L_E_T_ = ' ' AND PH9.PH9_NUM           = PH4_NUM),0) " + CRLF
		cQuery += ' "ACCOMERCIAL", ' + CRLF

		cQuery += " CASE WHEN NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " > NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " THEN((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += "  )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))) / 100 ) * NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " ELSE((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2))) / 100 ) *  NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " END " + CRLF
		cQuery += ' "ESTIMADO", ' + CRLF

		cQuery += " round((CASE WHEN NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " > NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " THEN((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))) / 100 ) * NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " ELSE((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2))) / 100 ) *  NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1010 SD1 INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2010 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " END " + CRLF
		cQuery += " -NVL((SELECT SUM(PH8_VALOR) FROM PH8010 PH8 WHERE PH8.D_E_L_E_T_ = ' ' AND PH8.PH8_NUM = PH4_NUM),0) " + CRLF
		cQuery += " -NVL((SELECT SUM(PH9_VALOR) FROM PH9010 PH9 WHERE PH9.D_E_L_E_T_ = ' ' AND PH9.PH9_NUM = PH4_NUM),0)),2) " + CRLF
		cQuery += ' "LIQUIDO", ' + CRLF

		cQuery += " NVL((SELECT PHA_PERCEN FROM PHA010 PHA WHERE PHA.D_E_L_E_T_ = ' ' AND PHA.PHA_NUM = PH4_NUM),0) " + CRLF
		cQuery += ' "A17", ' + CRLF

		cQuery += " NVL(( SELECT PHB_VALOR FROM PHB010 PHB WHERE PHB.D_E_L_E_T_ = ' ' AND PHB.PHB_NUM = PH4_NUM) ,0) " + CRLF
		cQuery += ' "A18", ' + CRLF

		cQuery += " NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM = PH4_NUM " + CRLF
		cQuery += " AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM ) " + CRLF
		cQuery += " ),0) " + CRLF
		cQuery += ' "A16", ' + CRLF

		cQuery += " NVL((SELECT SUM(round((C6_ZVALLIQ/C6_QTDVEN)*(C6_QTDVEN-C6_QTDENT),2)) " + CRLF
		cQuery += " FROM SC6010 SC6 INNER JOIN ( SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_   = ' ' AND SB1.B1_COD    = SC6.C6_PRODUTO		  AND SB1.B1_FILIAL = ' ' INNER JOIN ( SELECT * FROM SBM010 ) SBM ON SBM.D_E_L_E_T_   = ' ' AND SB1.B1_GRUPO = SBM.BM_GRUPO " + CRLF
		cQuery += " INNER JOIN ( SELECT * FROM SC5010 ) SC5 ON SC5.D_E_L_E_T_   = ' ' " + CRLF
		cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM AND SC5.C5_FILIAL   = SC6.C6_FILIAL " + CRLF
		cQuery += " INNER JOIN (SELECT * FROM SA1010) SA1 ON SA1.D_E_L_E_T_   = ' ' " + CRLF
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " 
		cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI " + CRLF
		cQuery += " AND SA1.A1_FILIAL = ' ' LEFT JOIN (SELECT * FROM PC1010 ) PC1 " + CRLF
		cQuery += " ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "	INNER JOIN (SELECT * FROM SF4010 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO " + CRLF
		cQuery += " AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE SC6.D_E_L_E_T_   = ' ' " + CRLF
		cQuery += " AND SC6.C6_FILIAL = '02' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' " + CRLF
		cQuery += "	AND SA1.A1_EST    <> 'EX' AND SBM.BM_XAGRUP <> ' ' AND PC1.PC1_PEDREP IS NULL " + CRLF
		cQuery += "	AND SB1.B1_GRUPO  = SBM.BM_GRUPO  AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' " + CRLF
		cQuery += "	AND SC5.C5_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A19" ' + CRLF

	ElseIf _ccod = '33'

		cQuery += " CASE WHEN NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " > NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " THEN((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += "  )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))) / 100 ) * NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " ELSE((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2))) / 100 ) *  NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " END " + CRLF
		cQuery += ' "ESTIMADO", ' + CRLF

		cQuery += " round((CASE WHEN NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " > NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " THEN((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),1) * 100 ),2))) / 100 ) * NVL((SELECT PH6_META  FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM  AND PH6_ANO = '" + MV_PAR01 + "'),0) " + CRLF
		cQuery += " ELSE((((NVL((SELECT TH7.PH7_ESCALO FROM PH7010 TH7 WHERE TH7.D_E_L_E_T_ = ' ' AND TH7.PH7_NUM  = PH4_NUM AND TH7.PH7_TARGET = (SELECT MAX(PH7_TARGET) FROM PH7010 PH7 WHERE PH7.D_E_L_E_T_ = ' ' AND PH7_NUM = PH4_NUM " + CRLF
		cQuery += " )),0)) / 100) * (ROUND((( NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0)) / NVL((SELECT PH6_META FROM PH6010 PH6 WHERE PH6.D_E_L_E_T_ = ' ' AND PH6_NUM = PH4_NUM " + CRLF
		cQuery += " AND PH6_ANO = '" + MV_PAR01 + "'),0) * 100 ),2))) / 100 ) *  NVL(( SELECT  SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM ) FROM SD2030 SD2 WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')and SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CRLF
		cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + MV_PAR01 + "' AND D2_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) - NVL((SELECT SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) FROM  SD1030 SD1 INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_ = ' ' 
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SD1.D1_TIPO = 'D' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA  AND SA1.A1_FILIAL = '  '  INNER JOIN(SELECT * FROM SF2030 )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL   WHERE  SD1.D_E_L_E_T_ = ' '  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') " + CRLF
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + MV_PAR01 + "' AND SA1.A1_COD  IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += " END " + CRLF
		cQuery += " -NVL((SELECT SUM(PH8_VALOR) FROM PH8010 PH8 WHERE PH8.D_E_L_E_T_ = ' ' AND PH8.PH8_NUM = PH4_NUM),0) " + CRLF
		cQuery += " -NVL((SELECT SUM(PH9_VALOR) FROM PH9010 PH9 WHERE PH9.D_E_L_E_T_ = ' ' AND PH9.PH9_NUM = PH4_NUM),0)),2) " + CRLF
		cQuery += ' "LIQUIDO", ' + CRLF

		cQuery += " NVL((SELECT SUM(round((C6_ZVALLIQ/C6_QTDVEN)*(C6_QTDVEN-C6_QTDENT),2)) " + CRLF
		cQuery += " FROM SC6030 SC6 INNER JOIN ( SELECT * FROM SB1030 ) SB1 ON SB1.D_E_L_E_T_   = ' ' AND SB1.B1_COD    = SC6.C6_PRODUTO		  AND SB1.B1_FILIAL = ' ' INNER JOIN ( SELECT * FROM SBM030 ) SBM ON SBM.D_E_L_E_T_   = ' ' AND SB1.B1_GRUPO = SBM.BM_GRUPO " + CRLF
		cQuery += " INNER JOIN ( SELECT * FROM SC5030 ) SC5 ON SC5.D_E_L_E_T_   = ' ' " + CRLF
		cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM AND SC5.C5_FILIAL   = SC6.C6_FILIAL " + CRLF
		cQuery += " INNER JOIN (SELECT * FROM SA1030) SA1 ON SA1.D_E_L_E_T_   = ' ' " + CRLF
		If !(Empty(Alltrim(MV_PAR05)))
			cQuery += " AND SA1.A1_COD = '" + MV_PAR05 + "'
		EndIf
		cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI " + CRLF
		cQuery += " AND SA1.A1_FILIAL = ' ' LEFT JOIN (SELECT * FROM PC1030 ) PC1 " + CRLF
		cQuery += " ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "	INNER JOIN (SELECT * FROM SF4030 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO " + CRLF
		cQuery += " AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE SC6.D_E_L_E_T_   = ' ' " + CRLF
		cQuery += " AND SC6.C6_FILIAL = '01' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' " + CRLF
		cQuery += "	AND SA1.A1_EST    <> 'EX' AND SBM.BM_XAGRUP <> ' ' AND PC1.PC1_PEDREP IS NULL " + CRLF
		cQuery += "	AND SB1.B1_GRUPO  = SBM.BM_GRUPO  AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' " + CRLF
		cQuery += "	AND SC5.C5_CLIENTE IN (SELECT PH5_CLIENT FROM PH5010 PH5 WHERE PH5.D_E_L_E_T_ = ' ' AND PH5_NUM = PH4_NUM )),0) " + CRLF
		cQuery += ' "A19" ' + CRLF

	End

	cQuery += " FROM PH4010 PH4 " + CRLF

	cQuery += " WHERE PH4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND PH4_NUM = '" + (cAliasLif)->PH4_NUM + "' " + CRLF



	If Select(cAliasP) > 0
		(cAliasP)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasP)

Return()
