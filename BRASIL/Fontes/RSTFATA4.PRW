#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RSTFATA4  ºAutor  ³Renato Nogueira     º Data ³  20/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de markup da proforma                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATA4()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATA4"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private cAlias1      := GetNextAlias()
	Private cAlias2      := GetNextAlias()	
	Private _cTitulo     := "Relatório de markup da proforma"
	Private _cDescri     := "Este programa irá imprimir um relatório de markup da proforma"
	Private _cSection1   := ""


	//-------cGrupo,cOrdem,cPergunt                ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	PutSx1(cPerg   ,"01"  ,"Proforma De: ?"        ,"Proforma De: ?"          ,"Proforma De: ?"             ,"mv_ch1"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"" 	,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(6)             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"  ,"Proforma Até: ?"       ,"Proforma Até: ?"         ,"Proforma Até: ?"            ,"mv_ch2"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,""	 ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",6)     ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"03"  ,"Cliente De: ?"         ,"Cliente De: ?"           ,"Cliente De: ?"              ,"mv_ch3"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(15)            ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"04"  ,"Cliente Até: ?"        ,"Cliente Até: ?"          ,"Cliente Até: ?"             ,"mv_ch4"    ,"C"   ,15      ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Replicate("Z",6)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"05"  ,"Emissão De: ?"         ,"Emissão De: ?"           ,"Emissão De: ?"              ,"mv_ch5"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"06"  ,"Emissão Até: ?"        ,"Emissão Até: ?"          ,"Emissão Até: ?"             ,"mv_ch6"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par06"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"07"  ,"Taxa: ? "              ,"Taxa: ?"                 ,"Taxa: ?"                    ,"mv_ch7"    ,"N"   ,14      ,5       ,0      ,"C" ,""    ,""    ,""     ,""   ,"mv_par07"    ,""       		 ,""      ,""      ,""                   ,""                 ,""        ,""      ,""     		 ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

	oReport		:= ReportDef()
	 oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportDef ºAutor  ³João Victor         º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cabeçalho do Relatório                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3
	Local oSection4
	Local oSection5
	Local oSection6
	


	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 6

	Pergunte(cPerg,.F.)

//Primeira Seção
	oSection1 := TRSection():New(oReport,_cSection1,{cAlias1})
	TRCell():New(oSection1,"A1" ,,"Proforma"       	   	,PesqPict("PPJ","PPJ_NUM")        	,TamSX3("PPJ_NUM")      [1]+2)
	TRCell():New(oSection1,"A2" ,,"Data"      		   	,PesqPict("PPJ","PPJ_EMISSA")     	,TamSX3("PPJ_EMISSA")   [1]+2)
	TRCell():New(oSection1,"A3" ,,"Cliente"	        	,PesqPict("PPJ","PPJ_CLIENT")      	,TamSX3("PPJ_CLIENT")       [1]+2)
	TRCell():New(oSection1,"A4" ,,"Loja"              	,PesqPict("PPJ","PPJ_LOJA")       	,TamSX3("PPJ_LOJA")     [1]+2)
	TRCell():New(oSection1,"A5" ,,"Nome"     			,PesqPict("PPJ","PPJ_NOME")      	,TamSX3("PPJ_NOME")    [1]+2)
	TRCell():New(oSection1,"A6" ,,"Item"     			,PesqPict("PPL","PPL_ITEM")      	,TamSX3("PPL_ITEM")    [1]+2)
	TRCell():New(oSection1,"A7" ,,"Produto"        		,PesqPict("PPL","PPL_PRODUT")      	,TamSX3("PPL_PRODUT")    [1]+2)
	TRCell():New(oSection1,"A8" ,,"Descrição"           ,PesqPict("SB1","B1_DESC")        	,TamSX3("B1_DESC")      [1]+2)
	TRCell():New(oSection1,"A9" ,,"Preço"             	,PesqPict("PPL","PPL_PRCVEN")      	,TamSX3("PPL_PRCVEN")    [1]+2)
	TRCell():New(oSection1,"A10",,"Quantidade"        	,PesqPict("PPL","PPL_QUANT")      	,TamSX3("PPL_QUANT")    [1]+2)
	TRCell():New(oSection1,"A11",,"Total"        		,PesqPict("PPL","PPL_TOTAL")      	,TamSX3("PPL_TOTAL")    [1]+2)
	TRCell():New(oSection1,"A12",,"Custo"        		,PesqPict("PPL","PPL_CUSTO")     	,TamSX3("PPL_CUSTO")   [1]+2)
	TRCell():New(oSection1,"A13",,"Taxa"        		,PesqPict("PPL","PPL_PRCVEN")    	,TamSX3("PPL_PRCVEN")       [1]+2)
	TRCell():New(oSection1,"A14",,"Markup unitário"    	,PesqPict("PPL","PPL_PRCVEN")     	,TamSX3("PPL_PRCVEN")   [1]+2)
	
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

	TRFunction():New(oSection1:Cell("A11") ,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³João Victor         º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Itens do Relatório                                         º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection1   := oReport:Section(1)
	Local nX		    := 0
	Local cQuery 	    := ""
	Local cAlias 	    := "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell("A1") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("A2") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("A3") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("A4") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("A5") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("A6") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("A7") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("A8") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("A9") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("A10"):SetBlock( { || aDados1[10] } )
	oSection1:Cell("A11"):SetBlock( { || aDados1[11] } )
	oSection1:Cell("A12"):SetBlock( { || aDados1[12] } )	
	oSection1:Cell("A13"):SetBlock( { || aDados1[13] } )
	oSection1:Cell("A14"):SetBlock( { || aDados1[14] } )
	
	oReport:SetTitle(_cTitulo)// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery(  ) },"Compondo Relatório")

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While 	(cAlias1)->(!Eof())

			aDados1[01]	:= (cAlias1)->A1
			aDados1[02]	:= (cAlias1)->A2
			aDados1[03]	:= (cAlias1)->A3
			aDados1[04]	:= (cAlias1)->A4
			aDados1[05]	:= (cAlias1)->A5
			aDados1[06]	:= (cAlias1)->A6
			aDados1[07]	:= (cAlias1)->A7
			aDados1[08]	:= (cAlias1)->A8
			aDados1[09]	:= (cAlias1)->A9
			aDados1[10]	:= (cAlias1)->A10
			aDados1[11]	:= (cAlias1)->A11
			aDados1[12]	:= Iif((cAlias1)->A12>0,(cAlias1)->A12,U_STCUSTO((cAlias1)->A7)/MV_PAR07)
			aDados1[13]	:= MV_PAR07
			aDados1[14]	:= (aDados1[09]-aDados1[12])/aDados1[12]
		
			oSection1:PrintLine()
		
			aFill(aDados1,nil)
			(cAlias1)->(dbskip())
		End
		
		oSection1:PrintTotal()
		oSection1:Finish()
	
		oReport:SkipLine()
	
		aFill(aDados1,nil)
	
		(cAlias1)->(dbCloseArea())
	Endif

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |StQuery  ºAutor  ³João Victor         º Data ³  15/10/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Query do Relatório                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery1     := ' '

	cQuery1 := " SELECT PPL_NUM A1, PPJ_EMISSA A2, PPJ_CLIENT A3, PPJ_LOJA A4, A1_NOME A5, "
	cQuery1 += " PPL_ITEM A6, PPL_PRODUT A7, B1_DESC A8, PPL_PRCVEN A9, PPL_QUANT A10, PPL_TOTAL A11, B1_XCUSCHI A12 "
	cQuery1 += " FROM "+RetSqlName("PPL")+" PPL "
	cQuery1 += " LEFT JOIN "+RetSqlName("PPJ")+" PJ "
	cQuery1 += " ON PPL_FILIAL=PPJ_FILIAL AND PPL_NUM=PPJ_NUM "
	cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery1 += " ON PPL_PRODUT=B1_COD "
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery1 += " ON A1_COD=PJ.PPJ_CLIENT AND A1_LOJA=PJ.PPJ_LOJA "
	cQuery1 += " WHERE PPL.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND PJ.D_E_L_E_T_=' ' "
	cQuery1 += " AND PPL_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery1 += " AND PPJ_CLIENT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery1 += " AND PPJ_EMISSA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "  
	cQuery1 += " ORDER BY PPL_NUM, PPL_ITEM "
	
	cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return()
