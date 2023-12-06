#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#Define CR Chr(13) + Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  RSTFATCR     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  COMEX - Invoice de Importação                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RSTFATCR()

	Local   oReport
	Private cPerg 			:= "RFATCR"
	Private cTime           := Time()
	Private cHora           := Substr(cTime, 1, 2)
	Private cMinutos    	:= Substr(cTime, 4, 2)
	Private cSegundos   	:= Substr(cTime, 7, 2)
	Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader      := .F.
	Private lXmlEndRow      := .F.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data Invoice de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  	,"@!")
	U_STPutSx1( cPerg, "02","Data Invoice ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  	,"@!")
	U_STPutSx1( cPerg, "03","Processo de:"						,"MV_PAR03","mv_ch3","C",17,0,"G",,""  	,"@!")
	U_STPutSx1( cPerg, "04","Processo ate:"					 	,"MV_PAR04","mv_ch4","C",17,0,"G",,""  	,"@!")
	U_STPutSx1( cPerg, "05","Invoice de:"						,"MV_PAR05","mv_ch5","C",15,0,"G",,""  	,"@!")
	U_STPutSx1( cPerg, "06","Invoice ate:"					 	,"MV_PAR06","mv_ch6","C",15,0,"G",,""  	,"@!")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Invoice de Importação",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório da Invoice de Importação.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Invoice de Importação",{"SC5"})

	TRCell():New(oSection,"01",,"Referência STECK"			,,06,.F.,)
	TRCell():New(oSection,"02",,"Referência Fornecedor"		,,06,.F.,)
	TRCell():New(oSection,"03",,"Exportador" 				,,06,.F.,)
	TRCell():New(oSection,"04",,"Data Invoice" 				,,06,.F.,)
	TRCell():New(oSection,"05",,"Data Vencimento"			,,06,.F.,)	
	TRCell():New(oSection,"06",,"Condicao de Pagamento"		,,06,.F.,)
	TRCell():New(oSection,"07",,"USD-fatura" 				,,06,.F.,)
	TRCell():New(oSection,"08",,"Declaração de Importação"	,,06,.F.,)

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("SW9")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]
	Local _cObs 	:= ""

	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )

	oReport:SetTitle("Invoice de Importação")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->( dbgotop() )
	If Select(cAliasLif) > 0
		While (cAliasLif)->( !Eof() )
			aDados1[01]	:= 	(cAliasLif)->W9_HAWB
			aDados1[02]	:=  (cAliasLif)->W9_INVOICE
			aDados1[03]	:=	(cAliasLif)->W9_NOM_FOR
			aDados1[04]	:= 	(cAliasLif)->W9_DT_EMIS
			If !Empty((cAliasLif)->Y6_DESC_P)
				SYP->( dbSetOrder(1) )
				SYP->( dbGoTop() )
				SYP->( dbSeek(xFilial("SYP") + (cAliasLif)->Y6_DESC_P) )
				While SYP->( !Eof() ) .And. SYP->YP_CHAVE == (cAliasLif)->Y6_DESC_P
					_cObs += StrTran(SYP->YP_TEXTO,"\13\10","")
					SYP->( dbSkip() )
				EndDo
			EndIf
			aDados1[05]	:= (cAliasLif)->WB_DT_VEN
			aDados1[06]	:= _cObs
			aDados1[07]	:=	(cAliasLif)->FOB
			aDados1[08]	:= 	(cAliasLif)->W6_DI_NUM
			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
			_cObs := ""
		End
	EndIf

	oReport:SkipLine()

Return oReport

Static Function StQuery()

	Local cQuery := ' '

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf

	cQuery += " SELECT TMP.W9_MOE_FOB||' '||(TMP.W9_FOB_TOT +W9_FRETEIN+W9_INLAND+W9_PACKING+W9_OUTDESP+W9_SEGURO-W9_DESCONT)AS FOB , TMP.* FROM "
	cQuery += CR+ "    (SELECT "
	cQuery += CR+ "    		W9_HAWB , W9_INVOICE , W9_NOM_FOR , SUBSTR(WB_DT_VEN,7,2)||'/'||SUBSTR(WB_DT_VEN,5,2)||'/'||SUBSTR(WB_DT_VEN,1,4) AS WB_DT_VEN, SUBSTR(W9_DT_EMIS,7,2)||'/'||SUBSTR(W9_DT_EMIS,5,2)||'/'||SUBSTR(W9_DT_EMIS,1,4) AS W9_DT_EMIS , "
	cQuery += CR+ "    		W9_MOE_FOB,W9_FRETEIN,W9_INLAND,W9_PACKING,W9_OUTDESP,W9_SEGURO,W9_DESCONT,W9_FOB_TOT,W6_DI_NUM,Y6_DESC_P "
	cQuery += CR+ "    	FROM " + RetSqlName("SW9") + " SW9 "
	cQuery += CR+ "    	INNER JOIN(SELECT * FROM " + RetSqlName("SW6") + ") SW6 "
	cQuery += CR+ "    	ON SW6.D_E_L_E_T_ = ' ' AND W6_HAWB = W9_HAWB AND W6_FILIAL = W9_FILIAL "
	cQuery += CR+ "    	LEFT JOIN(SELECT * FROM " + RetSqlName("SY6") + ") SY6 "
	cQuery += CR+ "    	ON SY6.D_E_L_E_T_ = ' ' AND W9_COND_PA = Y6_COD "
	cQuery += CR+ "    	LEFT JOIN(SELECT * FROM SWB010) SWB "
    cQuery += CR+ "    	ON SWB.D_E_L_E_T_ = ' ' AND WB_INVOICE = W9_INVOICE AND WB_HAWB = W9_HAWB "
	cQuery += CR+ " WHERE SW9.D_E_L_E_T_ = ' ' "
	cQuery += CR+ " 	AND W9_DT_EMIS BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' "
	cQuery += CR+ " 	AND W9_HAWB BETWEEN '" + Mv_Par03 + "' AND '" + Alltrim(Mv_Par04) + "' "
	cQuery += CR+ " 	AND W9_INVOICE BETWEEN '" + Mv_Par05 + "' AND '" + Alltrim(Mv_Par06) + "' AND W9_FILIAL = '" + cFilAnt + "') TMP "

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return
