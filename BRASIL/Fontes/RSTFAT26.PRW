#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


Static nPosNota := 01
Static nPosClie := 02
Static nPosLoja := 03
Static nPosNome := 04
Static nPosEmis := 05
Static nPosVlrT := 06
Static nPosPeso := 07
Static nPosCuba := 08
Static nPosEsta := 09
Static nPosFobC := 10
Static nPosNfCf := 11
Static nPosTran := 12
Static nPosVND1 := 13
Static nPosVND2 := 14
Static nPosPedi := 15
Static nPosHora := 16
Static nPosTpEn := 17
Static nPosQtdV := 18
Static nPosTLin := 19
Static nPosParc := 20
Static nPosLSCH := 21
Static nPosLSTK := 22
Static nPosVSCH := 23
Static nPosVSTK := 24

Static nPos2TDevT := 01
Static nPos2TDevS := 02
Static nPos2TDevK := 03


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT26     ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  OS X LINHA			                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT26()

	Local   oReport
	Local   _cTime          :=  ""
	Local   cInicio         := ""
	Local   cFim            := ""
	Private cPerg 			:= "RFAT26"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Da Data:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ate Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Do Cliente:" 	,"Do Cliente: ?" 	,"Do Cliente: ?" 	,"mv_ch3","C",6,0,0,"G","",'SA1' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Cliente:"  ,"Ate Cliente: ?" 	,"Ate Cliente: ?" 	,"mv_ch4","C",6,0,0,"G","",'SA1' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Da Loja:" 		,"Da Loja.: ?" 		,"Da Loja.: ?" 		,"mv_ch5","C",2,0,0,"G","",'' 	 ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Loja.:" 	,"Ate Loja.: ?" 	,"Ate Loja.: ?" 	,"mv_ch6","C",2,0,0,"G","",''    ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Da Nota:" 		,"Da Nota: ?" 		,"Da Nota: ?" 		,"mv_ch7","C",9,0,0,"G","",'SF2' ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "08", "Ate Nota:" 	,"Ate Nota: ?" 		,"Ate Nota: ?" 		,"mv_ch8","C",9,0,0,"G","",'SF2' ,"","","mv_par08","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "09", "Do Status:" ,"Do Status: ?" ,"Do Status: ?" 			    	,"mv_ch9","C",6,0,0,"G","",'' ,"","","mv_par09","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "10", "Ate Status:" ,"Ate Status: ?" ,"Ate Status: ?" 		        ,"mv_chA","C",6,0,0,"G","",'' ,"","","mv_par10","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "11", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"             ,"mv_chB","N",1,0,0,"C","",''    ,'','',"mv_par11","Desconto","","","","Aprovador","","","Cliente","","","","","","","")

	_cTime       := Dtoc(Date())+" Iniciado: " + Time()+"   Finalizado: "
	cInicio     := Time()
	oReport		:= ReportDef()

	oReport:PrintDialog()
	cFim        := Time()
	_cTime      += Time()+CRLF+ "   Tempo Processamento: "+ELAPTIME( cInicio, cFim )
	MsgAlert(_cTime, "Informação")
Return

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2

	oReport := TReport():New(cPergTit,"RELATÓRIO Faturamento",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Faturamento")

	Pergunte(cPerg,.F.)

	oSection  := TRSection():New(oReport,"Faturamento",{"SC5"})
	oSection2 := TRSection():New(oReport,"Devoluções",{"SF1"})
	
	TRCell():New(oSection, "NOTA"          , , "NOTA"          ,                   , 9 , .F.,)
	TRCell():New(oSection, "PEDIDO"        , , "PEDIDO"        ,                   , 6 , .F.,)
	TRCell():New(oSection, "CLIENTE"       , , "CLIENTE"       ,                   , 6 , .F.,)
	TRCell():New(oSection, "LOJA"          , , "LOJA"          ,                   , 2 , .F.,)
	TRCell():New(oSection, 'NOME'          , , 'NOME'          ,                   , 35, .F.,)
	TRCell():New(oSection, "EMISSAO"       , , "EMISSAO"       ,                   , 10, .F.,)
	TRCell():New(oSection, 'HORA'          , , 'HORA'          ,                   , 05, .F.,)

	TRCell():New(oSection, "VALOR_TOTAL"   , , "VALOR TOTAL"   ,   "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	TRCell():New(oSection, "TOTLINHAS"     , , "TOTAL LINHAS"  ,   "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	TRCell():New(oSection, "VALOR_SCH"     , , "VLR SCHNEIDER" ,   "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	TRCell():New(oSection, "LINHAS_SCH"    , , "LINHAS SCHNEIDER", "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	TRCell():New(oSection, "VALOR_STK"     , , "VLR STECK"     ,   "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	TRCell():New(oSection, "LINHAS_STK"    , , "LINHAS STECK",     "@E 99,999,999.99", 14)			// Valdemir Rabelo 21/04/2022 - Ticket: 20220209003237
	
	TRCell():New(oSection, "PESO"          , , "PESO"          , "@E 99,999,999.99", 14)
	TRCell():New(oSection, "QTDVOL"        , , "QTD VOL"       , "@E 99,999,999.99", 14)
	TRCell():New(oSection, "CUBAGEM"       , , "CUBAGEM"       , "@E 99,999,999.99", 14)
	TRCell():New(oSection, 'ESTADO'        , , 'ESTADO'        ,                   , 2 , .F.,)
	TRCell():New(oSection, 'CIF/FOB'       , , 'CADASTRO/CF'   ,                   , 3 , .F.,)
	TRCell():New(oSection, 'NF/CF'         , , 'NF/CF'         ,                   , 3 , .F.,)
	TRCell():New(oSection, 'TRANSPORTADORA', , 'TRANSPORTADORA',                   , 25, .F.,)
	TRCell():New(oSection, 'VEND1'         , , 'VEND1'         ,                   , 25, .F.,)
	TRCell():New(oSection, 'VEND2'         , , 'VEND2'         ,                   , 25, .F.,)
	TRCell():New(oSection, 'TIPOENT'       , , 'TIPO ENTREGA'  ,                   , 25, .F.,)
	TRCell():New(oSection, 'PARCIAL'       , , 'FAT PARCIAL'   ,                   , 4 , .F.,)

	oSection:SetTotalInLine(.F.)

	oBreak1 := TRBreak():New(oSection,{||  },{|| "Total : " },.F.)
	TRFunction():New(oSection:Cell("VALOR_TOTAL"),"","SUM"	 ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection:Cell("TOTLINHAS")  ,"","SUM"	 ,oBreak1,,,,.F.,.F.)

	TRFunction():New(oSection:Cell("VALOR_SCH"), "","SUM"	 ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection:Cell("LINHAS_SCH"),"","SUM"	 ,oBreak1,,,,.F.,.F.)

	TRFunction():New(oSection:Cell("VALOR_STK"), "","SUM"	 ,oBreak1,,,,.F.,.F.)
	TRFunction():New(oSection:Cell("LINHAS_STK"),"","SUM"	 ,oBreak1,,,,.F.,.F.)

	TRCell():New(oSection2,'TOTDEVT' 		,,"TOTAL DEVOLUÇÕES"		,"@E 99,999,999.99",14)
	TRCell():New(oSection2,'TOTDEVS' 		,,"DEVOLUÇÕES SCHNEIDER"	,"@E 99,999,999.99",14)
	TRCell():New(oSection2,'TOTDEVK' 		,,"DEVOLUÇÕES STECK"		,"@E 99,999,999.99",14)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

	oSection2:SetHeaderSection(.t.)
	oSection2:Setnofilter("SF1")


Return oReport

Static Function ReportPrint(oReport)
	Local oSection  := oReport:Section(1)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery1   := ""
	Local cAlias1   := "QRYTEMP1"
	Local _nTotLin  := 0
	Local aDados2[4]
	Local aDados1[99]

	oSection1:Cell( "NOTA")    :SetBlock( { || aDados1[nPosNota] } )
	oSection1:Cell( "CLIENTE") :SetBlock( { || aDados1[nPosClie] } )
	oSection1:Cell( "LOJA")    :SetBlock( { || aDados1[nPosLoja] } )
	oSection1:Cell( 'NOME' )   :SetBlock( { || aDados1[nPosNome] } )
	oSection1:Cell( "EMISSAO") :SetBlock( { || aDados1[nPosEmis] } )
	oSection1:Cell( "VALOR_TOTAL"):SetBlock( { || aDados1[nPosVlrT] } )
	oSection1:Cell( "PESO")    :SetBlock( { || aDados1[nPosPeso] } )
	oSection1:Cell( "QTDVOL")  :SetBlock( { || aDados1[nPosQtdV] } )
	oSection1:Cell( "CUBAGEM") :SetBlock( { || aDados1[nPosCuba] } )
	oSection1:Cell( "ESTADO")  :SetBlock( { || aDados1[nPosEsta] } )
	oSection1:Cell( 'CIF/FOB' ):SetBlock( { || aDados1[nPosFobC] } )
	oSection1:Cell( 'NF/CF' )  :SetBlock( { || aDados1[nPosNfCf] } )
	oSection1:Cell( 'TRANSPORTADORA' ):SetBlock( { || aDados1[nPosTran] } )
	oSection1:Cell( 'VEND1' )  :SetBlock( { || aDados1[nPosVND1] } )
	oSection1:Cell( 'VEND2' )  :SetBlock( { || aDados1[nPosVND2] } )
	oSection1:Cell( 'PEDIDO' ) :SetBlock( { || aDados1[nPosPedi] } )
	oSection1:Cell( 'HORA' )   :SetBlock( { || aDados1[nPosHora] } )
	oSection1:Cell( 'TIPOENT' ):SetBlock( { || aDados1[nPosTpEn] } )

	oSection2:Cell( 'TOTDEVT' ) :SetBlock( { || aDados2[nPos2TDevT] } )
	oSection2:Cell( 'TOTDEVS' ) :SetBlock( { || aDados2[nPos2TDevS] } )
	oSection2:Cell( 'TOTDEVK' ) :SetBlock( { || aDados2[nPos2TDevK] } )
	
	oSection1:Cell("TOTLINHAS"):SetBlock( { || aDados1[nPosTLin] } )
	oSection1:Cell( 'PARCIAL' ):SetBlock( { || aDados1[nPosParc] } )
	oSection1:Cell( 'LINHAS_SCH' ):SetBlock( { || aDados1[nPosLSCH] } )
	oSection1:Cell( 'LINHAS_STK' ):SetBlock( { || aDados1[nPosLSTK] } )
	oSection1:Cell( 'VALOR_SCH' ):SetBlock( { || aDados1[nPosVSCH] } )
	oSection1:Cell( 'VALOR_STK' ):SetBlock( { || aDados1[nPosVSTK] } )

	oReport:SetTitle("Faturamento")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")
	
	_nTotLin := 0

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			DbSelectArea('SF2')
			SF2->(DbSetOrder(1))
			If SF2->(DbSeek((cAliasLif)->FILIAL+(cAliasLif)->DOC+(cAliasLif)->SERIE))

				aDados1[nPosNota]	:=	(cAliasLif)->DOC
				aDados1[nPosClie]	:=	(cAliasLif)->CLIENTE
				aDados1[nPosLoja]	:= 	(cAliasLif)->LOJA
				aDados1[nPosNome]	:=  (cAliasLif)->NOME
				aDados1[nPosEmis]	:=	(cAliasLif)->EMISSAO
				aDados1[nPosVlrT]	:=	(cAliasLif)->VALOR_TOTAL
				aDados1[nPosPeso]	:=  SF2->F2_PBRUTO
				aDados1[nPosCuba]	:=  SF2->F2_XCUBAGE
				aDados1[nPosEsta]   :=  (cAliasLif)->ESTADO
				aDados1[nPosFobC]   :=  IIF((cAliasLif)->CLIFRE = 'F','FOB',IIF((cAliasLif)->CLIFRE = 'C','CIF',''))
				aDados1[nPosNfCf] :=  IIF((cAliasLif)->NFFRE  = 'F','FOB',IIF((cAliasLif)->NFFRE  = 'C','CIF',''))
				aDados1[nPosTran] :=  (cAliasLif)->TRANSP
				aDados1[nPosVND1] :=  (cAliasLif)->VEND1
				aDados1[nPosVND2] :=  (cAliasLif)->VEND2
				aDados1[nPosPedi] :=  (cAliasLif)->PEDIDO
				aDados1[nPosHora] :=  (cAliasLif)->HORA
				aDados1[nPosTpEn] :=  IIF((cAliasLif)->TIPOE  = '1','RETIRA',IIF((cAliasLif)->TIPOE = '2','ENTREGA',''))


				cQuery1 := " SELECT DISTINCT (SELECT COUNT(*) FROM "+RetSqlName("CB6")+" CB6 WHERE   CB7_ORDSEP = CB6_XORDSE "
				cQuery1	+= "             AND CB6.CB6_FILIAL = '"+XFILIAL("CB6")+"' AND  CB6.D_E_L_E_T_ = ' ' ) "
				cQuery1	+= "SOMA"
				cQuery1	+= " FROM "+RetSqlName("CB7")+" CB7"
				cQuery1	+= "   INNER JOIN "+RetSqlName("CB6")+" CB6 "
                cQuery1	+= " ON   CB7_ORDSEP = CB6_XORDSE "
                cQuery1	+= "    AND  CB6.D_E_L_E_T_ = ' ' "
                cQuery1	+= "   AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' "
                cQuery1	+= "        WHERE CB7.D_E_L_E_T_ = ' '  AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
                cQuery1	+= " AND CB7.CB7_NOTA     = '"+(cAliasLif)->DOC+"' "
                cQuery1	+= " AND CB7.CB7_SERIE    = '"+(cAliasLif)->SERIE+"' "

				cQuery1 := ChangeQuery(cQuery1)

				If Select(cAlias1) > 0
					(cAlias1)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

				aDados1[nPosQtdV] := (cAlias1)->SOMA
				
				_nTotLin += (cAliasLif)->TOTLINHAS
				aDados1[nPosTLin] := (cAliasLif)->TOTLINHAS
				aDados1[nPosParc] := (cAliasLif)->PARCIAL
				aDados1[nPosLSCH] := (cAliasLif)->LINHAS_SCH           // Valdemir Rabelo - Ticket: 20220209003237 20/04/2022
				aDados1[nPosLSTK] := (cAliasLif)->LINHAS_STK           // Valdemir Rabelo - Ticket: 20220209003237 20/04/2022
				aDados1[nPosVSCH] := (cAliasLif)->VALOR_SCH           // Valdemir Rabelo - Ticket: 20220209003237 20/04/2022
				aDados1[nPosVSTK] := (cAliasLif)->VALOR_STK           // Valdemir Rabelo - Ticket: 20220209003237 20/04/2022

			EndIf
			oSection:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End
		oSection:PrintTotal()
		oSection:Finish()


	EndIf
	oReport:SkipLine()
	oReport:SkipLine()

	Processa({|| StQuery2('') },"Compondo Totalizador Geral")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		aDados2[nPos2TDevT] :=  (cAliasLif)->TOTDEV
		//oReport:SkipLine()
		//oSection2:PrintLine()
	EndIf

	Processa({|| StQuery2('SCH') },"Compondo Totalizador Schneider")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		aDados2[nPos2TDevS] :=  (cAliasLif)->TOTDEVSCH
		//oReport:SkipLine()
		//oSection2:PrintLine()
	EndIf
	Processa({|| StQuery2('STK') },"Compondo Totalizador Steck")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		aDados2[nPos2TDevK] :=  (cAliasLif)->TOTDEVSTK
		oReport:SkipLine()
		oSection2:PrintLine()
	EndIf
	aFill(aDados2,nil)

	oReport:SkipLine()


Return oReport


/*/{Protheus.doc} StQuery
Rotina refeita conforme solicitação chamado: 20220209003237
@type function
@version  12.1.27
@author Valdemir Rabelo
@since 21/04/2022
@return variant, return_Query
/*/
Static Function StQuery()

	Local cQuery     := ' '
	
	cQuery := " SELECT XXX.*, (CASE WHEN ZFATBLQ = '2'  THEN 'SIM' ELSE CASE WHEN ZFATBLQ = '1'   THEN 'NAO' END END ) as PARCIAL , " + CRLF
	cQuery += getLinhas('')+", "        //  Total Linhas
	cQuery += getLinhas('SCH')+", "     //  Linhas Schneider
	cQuery += getLinhas('STK')+" "      //  Linhas Steck

	cQuery += " FROM ( " + CRLF
	cQuery += "      SELECT " + CRLF
	cQuery += "      "+getTotal('')+", "        //   Total Valor
	cQuery += "      "+getTotal('SCH')+", "     //   Total Schneider
	cQuery += "      "+getTotal('STK')+", "     //   Total Steck
	
	cQuery += "            SD2PAI.D2_DOC DOC ,       " + CRLF
	cQuery += "            SD2PAI.D2_PEDIDO PEDIDO,  " + CRLF
	cQuery += "            SD2PAI.D2_SERIE SERIE ,   " + CRLF
	cQuery += "            SD2PAI.D2_FILIAL FILIAL , " + CRLF
	cQuery += "            SD2PAI.D2_CLIENTE CLIENTE , " + CRLF
	cQuery += "            SD2PAI.D2_LOJA    LOJA  ,   " + CRLF
	cQuery += "            SA1.A1_NOME    NOME  ,   " + CRLF
	cQuery += "            SA1.A1_EST     ESTADO,   " + CRLF
	cQuery += "            SA1.A1_TPFRET  CLIFRE,   " + CRLF
	cQuery += "            SF2.F2_TPFRETE NFFRE,    " + CRLF
	cQuery += "            SF2.F2_HORA    HORA,     " + CRLF
	cQuery += "            SC5.C5_XTIPO   TIPOE,    " + CRLF
	cQuery += "            SC5.C5_ZFATBLQ ZFATBLQ,  " + CRLF
	cQuery += "            NVL(SA3.A3_COD||'-'||SA3.A3_NOME ,' ') 		  " + CRLF
	cQuery += "            VEND2, " + CRLF
	cQuery += "            NVL(TA3.A3_COD||'-'||TA3.A3_NOME ,' ') 		  " + CRLF
	cQuery += "            VEND1, " + CRLF
	cQuery += "            SF2.F2_TRANSP||'-'||TRIM(NVL(SA4.A4_NOME,' ')) " + CRLF
	cQuery += "            TRANSP, " + CRLF
	cQuery += "            substr(SD2PAI.D2_EMISSAO,7,2)||'/'||substr(SD2PAI.D2_EMISSAO,5,2)||'/'||substr(SD2PAI.D2_EMISSAO,1,4) " + CRLF
	cQuery += "            EMISSAO " + CRLF
	cQuery += "      FROM "+RetSqlName("SD2")+" SD2PAI    " + CRLF

	cQuery += "  	 INNER JOIN "+RetSqlName("SF2")+" SF2 " + CRLF
	cQuery += "  	 ON  SF2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  	 AND SF2.F2_DOC = SD2PAI.D2_DOC     " + CRLF
	cQuery += "  	 AND SF2.F2_SERIE = SD2PAI.D2_SERIE " + CRLF
	cQuery += "  	 AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' " + CRLF

	cQuery += "  	 INNER JOIN "+RetSqlName("SB1")+" SB1  " + CRLF
	cQuery += "  	 ON  SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  	 AND  SB1.B1_COD = SD2PAI.D2_COD  " + CRLF

	cQuery += "      LEFT JOIN "+RetSqlName("SA4")+" SA4  " + CRLF
	cQuery += "      ON SA4.D_E_L_E_T_   = ' ' " + CRLF
	cQuery += "      AND SA4.A4_COD = SF2.F2_TRANSP " + CRLF
	cQuery += "      AND SA4.A4_FILIAL = '"+xFilial("SA4")+"' " + CRLF
     
	cQuery += "      LEFT JOIN "+RetSqlName("SA3")+" SA3  " + CRLF
	cQuery += "      ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = SF2.F2_VEND2 AND SA3.A3_FILIAL = ' ' " + CRLF
	cQuery += "      LEFT JOIN "+RetSqlName("SA3")+" TA3  " + CRLF
	cQuery += "      ON SA3.D_E_L_E_T_ = ' ' AND TA3.A3_COD = SF2.F2_VEND1 AND TA3.A3_FILIAL = ' ' " + CRLF
     
	cQuery += "      INNER JOIN "+RetSqlName("SA1")+" SA1  " + CRLF
	cQuery += "      ON SA1.D_E_L_E_T_   = ' ' 			" + CRLF
	cQuery += "      AND SA1.A1_COD = SD2PAI.D2_CLIENTE " + CRLF
	cQuery += "      AND SA1.A1_LOJA = SD2PAI.D2_LOJA 	" + CRLF
	cQuery += "      AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' " + CRLF
	cQuery += "      AND SA1.A1_GRPVEN <> 'ST' " + CRLF
	cQuery += "      AND SA1.A1_GRPVEN <> 'SC' " + CRLF
	cQuery += "      AND SA1.A1_EST    <> 'EX' " + CRLF

	cQuery += "      INNER JOIN "+RetSqlName("SC5")+" SC5  " + CRLF
	cQuery += "      ON SC5.C5_NUM = SD2PAI.D2_PEDIDO " + CRLF
	cQuery += "      AND SC5.D_E_L_E_T_ = ' '         " + CRLF     
	cQuery += "      WHERE SD2PAI.D_E_L_E_T_ = ' '    " + CRLF
	cQuery += "      AND SD2PAI.D2_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") " + CRLF
	cQuery += "      AND SD2PAI.D2_EMISSAO BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "'  " + CRLF
	cQuery += "      AND SD2PAI.D2_DOC     BETWEEN   '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  " + CRLF
	cQuery += "      AND SD2PAI.D2_CLIENTE BETWEEN   '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  " + CRLF
	cQuery += "      AND SD2PAI.D2_LOJA    BETWEEN   '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  " + CRLF
	cQuery += "      AND SD2PAI.D2_FILIAL   = '"+xFilial("SD2")+"'  " + CRLF
	cQuery += "      GROUP BY SD2PAI.D2_DOC, SD2PAI.D2_PEDIDO, SD2PAI.D2_CLIENTE, SD2PAI.D2_LOJA, SD2PAI.D2_EMISSAO, SD2PAI.D2_FILIAL, SD2PAI.D2_SERIE ,SA1.A1_NOME, SA1.A1_EST  ,SA1.A1_TPFRET ,  " + CRLF
	cQuery += "       SF2.F2_TPFRETE  ,SF2.F2_HORA, SF2.F2_TRANSP||'-'||TRIM(NVL(SA4.A4_NOME,' ')) " + CRLF
	cQuery += "      , TA3.A3_COD||'-'||TA3.A3_NOME  " + CRLF
	cQuery += "      , SA3.A3_COD||'-'||SA3.A3_NOME  " + CRLF
	cQuery += "      , SC5.C5_XTIPO      	" + CRLF
	cQuery += "      , SC5.C5_ZFATBLQ    	" + CRLF
	cQuery += "      ORDER BY SD2PAI.D2_DOC " + CRLF
	     
	cQuery += " ) XXX " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()





Static Function StQuery2(pTipo)

	Local cQuery     := ' '
	Local cCond      := ''
	Local cCampo     := ''
	/*
	cQuery += " SELECT SUM(F1_VALMERC+F1_FRETE+F1_DESPESA+F1_VALIPI+F1_ICMSRET-F1_DESCONT) TOTDEV "
	cQuery += " FROM "+RetSqlName("SF1")+" F1 "
	cQuery += " WHERE F1.D_E_L_E_T_=' ' AND F1_TIPO='D' "
	cQuery += " AND F1_DTDIGIT BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' AND F1_FILIAL='"+cFilAnt+"' "
	*/

	// Valdemir Rabelo 22/04/2022 - Ticket: 20220209003237
	if pTipo == "SCH"
	  cCond      := " AND   SB1.B1_XCODSE = 'S' " + CRLF
	  cCampo     := 'TOTDEVSCH'
	ELSEIF pTipo == "STK"
	  cCond      := " AND   (SB1.B1_XCODSE = 'N' OR SB1.B1_XCODSE =' ') " + CRLF
	  cCampo     := 'TOTDEVSTK'
	Else 
	  cCampo     := 'TOTDEV'
	ENDIF 

	//Chamado 008705

		cQuery += " SELECT SUM(D1_TOTAL) " + cCAMPO
		cQuery += " FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SD1")+" SD1,"+RetSqlName("SB1")+" SB1,
		cQuery += " "+RetSqlName("SA1")+" SA1,"+RetSqlName("SF4")+" SF4
		cQuery += " WHERE F1_FILIAL = '"+cFilAnt+"' AND
		cQuery += " F1_TIPO = 'D' AND
		cQuery += " F1_DTDIGIT >= '"+dTos(MV_PAR01)+"' AND F1_DTDIGIT <= '"+dTos(MV_PAR02)+"' AND
		cQuery += " F4_ESTOQUE IN ('S') AND
		//F1_FORNECE >= %Exp:mv_par03% AND F1_FORNECE <= %Exp:mv_par04% AND
		//F1_LOJA >= %Exp:mv_par05% AND F1_LOJA <= %Exp:mv_par06% AND
		//%Exp:cWhere% AND
		cQuery += " SF1.D_E_L_E_T_=' ' AND
		cQuery += " D1_FILIAL = '"+cFilAnt+"' AND
		cQuery += " D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND
		//D1_CF >= %Exp:mv_par07% AND D1_CF <= %Exp:mv_par08% AND
		cQuery += " SD1.D_E_L_E_T_=' ' AND
		//B1_FILIAL = %xFilial:SB1% AND
		cQuery += " B1_COD = D1_COD AND
		cQuery += " SB1.D_E_L_E_T_=' '  AND
		//A1_FILIAL = %xFilial:SA1% AND
		cQuery += " A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA AND
		cQuery += " SA1.D_E_L_E_T_=' ' AND
		cQuery += " F4_CODIGO = D1_TES AND
		cQuery += " SF4.D_E_L_E_T_=' '
		IF !EMPTY(cCond)
		   cQuery += cCond
		ENDIF 
		cQuery += " ORDER BY F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()




/*/{Protheus.doc} getLinhas
Rotina que irá calcular linhas conforme condição
Ticket: 20220209003237
@type function
@version  12.1.27
@author valdemir Rabelo
@since 20/04/2022
@param pTipo, variant, Tipo da Linha
@return variant, Query Montada
/*/
Static Function getLinhas(pTipo)
	Local cRET   := ""
	Local cCampo := ""
	Local cCond  := ""

	if pTipo == 'SCH'
	   cCampo := "LINHAS_SCH "
	   cCond  := " AND SB1.B1_XCODSE='S' "
	elseif pTipo == "STK"
	   cCampo := "LINHAS_STK "
	   cCond  := " AND (SB1.B1_XCODSE='N' OR SB1.B1_XCODSE=' ')  "
	else
	   cCampo := "TOTLINHAS "
	endif 

	cRET += "( SELECT COUNT(*) 				        " + CRLF
	cRET += " FROM "+RetSqlName("CB7")+" CB7        " + CRLF
	cRET += "   LEFT JOIN "+RetSqlName("CB8")+" CB8 " + CRLF
	cRET += "   ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP  " + CRLF
	if !Empty(pTipo)
		cRET += "   INNER JOIN " + RETSQLNAME("SB1") + " SB1        " + CRLF
		cRET += "   ON SB1.B1_COD=CB8_PROD AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	Endif 
	cRET += "   WHERE CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' "+cCond+" AND CB7_FILIAL=XXX.FILIAL AND CB7_NOTA=XXX.DOC AND CB7_SERIE=XXX.SERIE) " +cCampo + CRLF

Return cRET


/*/{Protheus.doc} getTotal
Rotina que calcula o total de cada tipo Schneider/ Steck e Total
Ticket: 20220209003237
@type function
@version 12.1.27 
@author Valdemir Rabelo
@since 20/04/2022
@param pTipo, variant, String
@return variant, Query
/*/
Static Function getTotal(pTipo)
	Local cRET   := ""
	Local cCampo := ""
	Local cCOND  := ""

	if pTipo == "SCH"
	   cCampo := "VALOR_SCH"
	   cCOND  := " AND   SB1.B1_XCODSE = 'S' " + CRLF
	elseif pTipo == "STK"
	   cCampo := "VALOR_STK"
	   cCOND  := " AND   (SB1.B1_XCODSE = 'N' OR  SB1.B1_XCODSE=' ') " + CRLF
	else 
	   cCampo := "VALOR_TOTAL"
	endif 

    cRET += "(SELECT  " + CRLF 
    cRET += "       NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM),0) " + CRLF 
	cRET += "FROM " + RETSQLNAME('SD2') + " SD2   " + CRLF 
	cRET += "INNER JOIN  " + RETSQLNAME('SF2') + " SF2 " + CRLF 
	cRET += "ON  SF2.D_E_L_E_T_ = ' '   " + CRLF 
	cRET += "AND SF2.F2_DOC = SD2.D2_DOC " + CRLF 
	cRET += "AND SF2.F2_SERIE = SD2.D2_SERIE " + CRLF 
	cRET += "AND SF2.F2_FILIAL = '"+XFILIAL('SF2')+"' " + CRLF 
	cRET += "INNER JOIN " + RETSQLNAME('SB1') + " SB1  " + CRLF 
	cRET += "ON  SB1.D_E_L_E_T_ = ' '  AND  SB1.B1_COD = SD2.D2_COD  " + CRLF 
	cRET += "LEFT JOIN "+RETSQLNAME("SA4") + " SA4  " + CRLF
	cRET += "ON SA4.D_E_L_E_T_   =  ' ' AND SA4.A4_COD = SF2.F2_TRANSP AND SA4.A4_FILIAL = ' ' " + CRLF
	cRET += "LEFT JOIN " + RETSQLNAME("SA3") + " SA3 " + CRLF 
	cRET += "ON SA3.D_E_L_E_T_ = ' '  AND SA3.A3_COD = SF2.F2_VEND2 AND SA3.A3_FILIAL = ' ' " + CRLF 
	cRET += "LEFT JOIN " + RETSQLNAME("SA3") + " TA3 " + CRLF 
	cRET += "ON SA3.D_E_L_E_T_ = ' ' AND TA3.A3_COD = SF2.F2_VEND1 AND TA3.A3_FILIAL = ' '  " + CRLF 
	cRET += "INNER JOIN " + RETSQLNAME("SA1") + " SA1 " + CRLF 
	cRET += "ON SA1.D_E_L_E_T_   = ' '  AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA " + CRLF 
	cRET += "AND SA1.A1_FILIAL = ' '    AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX' " + CRLF 
	cRET += "INNER JOIN " + RETSQLNAME('SC5') + " SC5 " + CRLF
	cRET += "ON SC5.C5_NUM  = SD2.D2_PEDIDO " + CRLF 
	cRET += "AND SC5.D_E_L_E_T_ = ' '        " + CRLF 
	cRET += "WHERE SD2.D_E_L_E_T_ = ' '      " + CRLF 
	cRET += "AND SD2.D2_CF IN('5101','5102','5116','5122','5123','5401','5403','5405','5501','5551','5922','6101','6102','6107','6108','6109','6110','6116','6118','6119','6122','6123','6401','6403','6404','6551','6922','7101','7102')  " + CRLF 
	cRET += "AND   SD2.D2_EMISSAO = SD2PAI.D2_EMISSAO     " + CRLF 
	cRET += "AND   SD2.D2_DOC     = SD2PAI.D2_DOC         " + CRLF 
	cRET += "AND   SD2.D2_CLIENTE = SD2PAI.D2_CLIENTE     " + CRLF 
	cRET += "AND   SD2.D2_LOJA    = SD2PAI.D2_LOJA        " + CRLF 
	cRET += cCOND 
	cRET += "AND   SD2.D2_FILIAL   = '"+XFILIAL('SD2')+"' " + CRLF 
	cRET += ") "+cCAMPO	

Return cRET
