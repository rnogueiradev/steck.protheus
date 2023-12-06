#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  RSTFAT88     ∫Autor  ≥Renato Nogueira ∫ Data ≥  10/08/15     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio de indicadores do suframa		                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

*-----------------------------*
User Function RSTFAT88()
*-----------------------------*

	Local cQuery 			:= ""
	Local cAlias 			:= "QRYTEMP"
	Private _cNomePdf 	:= ""
	Private cPerg 		:= "RFAT88"
	Private cStartPath	:= '\arquivos\pedido\'
	Private _cDirRel  	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private nErrQry
	Private nProjeto	:= 0
	Private nFolha		:= 0 //Ticket 20190530000004 - Everson Santana - 31052019

	Public _cParam		:= ""

	PutSx1(cPerg, "01", "MÍs:"	,"MÍs:"	 ,"MÍs:"			,"mv_ch1","C"   ,02      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Ano:"	,"Ano:"	 ,"Ano:"			,"mv_ch2","C"   ,04      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "(S)SintÈtico/(A)AnalÌtico"	,"(S)SintÈtico/(A)AnalÌtico","(S)SintÈtico/(A)AnalÌtico"   ,"mv_ch3","C"   ,01      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "04", "(P)ProduÁ„o/(F)Faturamento","(P)ProduÁ„o/(F)Faturamento","(P)ProduÁ„o/(F)Faturamento" ,"mv_ch4","C"   ,01      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

	Pergunte(cPerg,.T.)

	_cQuery := " UPDATE "+RetSqlName("SD2")+" D2 "
	_cQuery += " SET D2.D2_UM=(SELECT B1_UM FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=D2.D2_COD) "
	_cQuery += " WHERE D2.D_E_L_E_T_=' ' AND D2.D2_UM=' ' "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATEN«√O')
	EndIf

	If MV_PAR03=="A" .And. MV_PAR04=="F"
		_cParam	:= MV_PAR02+MV_PAR01
		U_RSTFAT89(_cParam)  //RelatÛrio AnalÌtico faturamento
		Return
	EndIf

	If MV_PAR03=="A" .And. MV_PAR04=="P"
		_cParam	:= MV_PAR02+MV_PAR01
		U_RSTFAT91(_cParam)  //RelatÛrio AnalÌtico produÁ„o
		Return
	EndIf

	_cNomePdf  :=cEmpAnt+"_Suframa_"+MV_PAR01+MV_PAR02

	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\Pedido\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
	oPrint:SetMargin(30,30,30,30)
	oPrint:setPaperSize(9)

	aBmp := "STECK.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont6  := TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n := TFont():New("Courier",9,11 ,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oPrint:StartPage()     // INICIALIZA a p·gina
	nFolha++
	cQuery	:= " SELECT B1_ZPROJAM AS PROJETO "

	cQuery += " ,NVL((SELECT SUM(CASE WHEN D3_UM='UN' THEN D3_QUANT*BB1.B1_PESO WHEN D3_UM='KG' THEN D3_QUANT END)  "
	cQuery += " FROM "+RetSqlName("SD3")+" D3 LEFT JOIN SB1030 BB1 ON BB1.B1_COD=D3_COD WHERE D3.D_E_L_E_T_=' ' "
	cQuery += " AND BB1.D_E_L_E_T_=' ' AND AAA.B1_ZPROJAM=BB1.B1_ZPROJAM AND SUBSTR(D3_EMISSAO,1,6)='"+MV_PAR02+MV_PAR01+"' "
	cQuery += " AND D3_TM='100' AND D3_CF='PR0' AND D3_OP<>' ' ),0) PRDKG "
	cQuery += " ,NVL((SELECT SUM(CASE WHEN D3_UM='UN' THEN D3_QUANT WHEN D3_UM='KG' THEN D3_QUANT/BB1.B1_PESO END)  "
	cQuery += " FROM "+RetSqlName("SD3")+" D3 LEFT JOIN SB1030 BB1 ON BB1.B1_COD=D3_COD WHERE D3.D_E_L_E_T_=' ' "
	cQuery += " AND BB1.D_E_L_E_T_=' ' AND AAA.B1_ZPROJAM=BB1.B1_ZPROJAM AND SUBSTR(D3_EMISSAO,1,6)='"+MV_PAR02+MV_PAR01+"' "
	cQuery += " AND D3_TM='100' AND D3_CF='PR0' AND D3_OP<>' ' ),0) PRDUN "

	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='1' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT            WHEN (D2_UM='KG' AND A1_XTRIB='1' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT/B1_PESO END),0) QTREALUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='1' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND A1_XTRIB='1' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT         END),0) QTREALKG "
	cQuery += " ,NVL(SUM(CASE WHEN A1_XTRIB='1' AND D2_EST NOT IN ('AM','EX') THEN D2_TOTAL+D2_ICMSRET+D2_ICMSRET END),0) TOTREAL "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='2' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT            WHEN (D2_UM='KG' AND A1_XTRIB='2' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT/B1_PESO END),0) QTSIMPUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='2' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND A1_XTRIB='2' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT         END),0) QTSIMPKG "
	cQuery += " ,NVL(SUM(CASE WHEN A1_XTRIB='2' AND D2_EST NOT IN ('AM','EX') THEN D2_TOTAL+D2_ICMSRET+D2_ICMSRET END),0) TOTSIMP "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='3' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT            WHEN (D2_UM='KG' AND A1_XTRIB='3' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT/B1_PESO END),0) QTPRESUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='3' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND A1_XTRIB='3' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT         END),0) QTPRESKG "
	cQuery += " ,NVL(SUM(CASE WHEN A1_XTRIB='3' AND D2_EST NOT IN ('AM','EX') THEN D2_TOTAL+D2_ICMSRET END),0) TOTPRES "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='4' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT            WHEN (D2_UM='KG' AND A1_XTRIB='4' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT/B1_PESO END),0) QTGOVEUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='4' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND A1_XTRIB='4' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT         END),0) QTGOVEKG "
	cQuery += " ,NVL(SUM(CASE WHEN A1_XTRIB='4' AND D2_EST NOT IN ('AM','EX') THEN D2_TOTAL+D2_ICMSRET END),0) TOTGOVE "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='5' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT            WHEN (D2_UM='KG' AND A1_XTRIB='5' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT/B1_PESO END),0) QTOUTRUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND A1_XTRIB='5' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND A1_XTRIB='5' AND D2_EST NOT IN ('AM','EX')) THEN D2_QUANT         END),0) QTOUTRKG "
	cQuery += " ,NVL(SUM(CASE WHEN A1_XTRIB='5' AND D2_EST NOT IN ('AM','EX') THEN D2_TOTAL+D2_ICMSRET END),0) TOTOUTR "

	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST='AM') THEN D2_QUANT            WHEN (D2_UM='KG' AND D2_EST='AM') THEN D2_QUANT/B1_PESO END),0) QTLOCAUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST='AM') THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND D2_EST='AM') THEN D2_QUANT         END),0) QTLOCAKG "
	cQuery += " ,NVL(SUM(CASE WHEN D2_EST='AM' THEN D2_TOTAL+D2_ICMSRET END),0) TOTLOCAL "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST='EX') THEN D2_QUANT            WHEN (D2_UM='KG' AND D2_EST='EX') THEN D2_QUANT/B1_PESO END),0) QTEXUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST='EX') THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND D2_EST='EX') THEN D2_QUANT         END),0) QTEXKG "
	cQuery += " ,NVL(SUM(CASE WHEN D2_EST='EX' THEN D2_TOTAL+D2_ICMSRET END),0) TOTALEX "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST NOT IN ('EX','AM')) THEN D2_QUANT            WHEN (D2_UM='KG' AND D2_EST NOT IN ('EX','AM')) THEN D2_QUANT/B1_PESO END),0) QTNACUN "
	cQuery += " ,NVL(SUM(CASE WHEN (D2_UM='UN' AND D2_EST NOT IN ('EX','AM')) THEN D2_QUANT*B1_PESO    WHEN (D2_UM='KG' AND D2_EST NOT IN ('EX','AM')) THEN D2_QUANT         END),0) QTNACKG "
	cQuery += " ,NVL(SUM(CASE WHEN D2_EST NOT IN ('EX','AM') THEN D2_TOTAL+D2_ICMSRET END),0) TOTALNAC "

	cQuery += " FROM ( "
	cQuery += " SELECT A1_XTRIB,D2_UM,D2_QUANT,B1_PESO,D2_COD,B1_ZPROJAM,D2_EST,D2_TOTAL,D2_ICMSRET "
	cQuery += " FROM "+RetSqlName("SD2")+" D2 "
	cQuery += " LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO=D2_TES  "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA  "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=D2_COD "
	cQuery += " WHERE D2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' '  "
	cQuery += " AND D2.D2_COD=B1.B1_COD AND SUBSTR(D2_EMISSAO,1,6)='"+MV_PAR02+MV_PAR01+"' AND F4_DUPLIC='S' AND F4_ESTOQUE='S' "
	cQuery += " AND B1_ZPROJAM<>' ' "
	cQuery += " ) AAA "
	cQuery += " GROUP BY B1_ZPROJAM "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		DbSelectArea("SZE")
		SZE->(DbSetOrder(1))
		SZE->(DbGoTop())
		SZE->(DbSeek(xFilial("SZE")+(cAlias)->PROJETO))

		DbSelectArea("SX5")
		SX5->(DbSetOrder(1))
		SX5->(DbGoTop())
		SX5->(DbSeek(xFilial("SX5")+"ZY"+SZE->ZE_UNIDADE))

	//Primeiro box
		oPrint:box (020,001,053,580,"-1")
		//>> Ticket 20190530000004 - Everson Santana - 31052019
		If File(aBmp)
			oPrint:SayBitmap(022,005,aBmp,030,007 )
		EndIf

		oPrint:Say (035,005,"SIGA/RSTFAT88/v."+GetVersao(.F.)  ,oFont6)
		oPrint:Say (042,005,"HORA: "+time()  ,oFont6)
		oPrint:Say (049,005,"Grupo de Empresa: "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL),oFont6)

		oPrint:Say (028,525,"Folha....: "  ,oFont6)
		oPrint:Say (028,550, CVALTOCHAR(nFolha)  ,oFont6)
		oPrint:Say (035,525,"Dt Ref...: "  ,oFont6)
		oPrint:Say (035,550,+Dtoc(Date()) ,oFont6)
		oPrint:Say (042,525,"Emiss„o: " ,oFont6)
		oPrint:Say (042,550,Dtoc(dDataBase)  ,oFont6)
		oPrint:Say (049,525,SubStr(GetVersao(),1,16)  ,oFont6)
		nFolha++
		//<< Ticket 20190530000004 - Everson Santana - 31052019
		oPrint:Say (032,075, "INDICADORES DE DESEMPENHO - SUFRAMA - M S: "+MV_PAR01+"/"+MV_PAR02  ,oFont16n)
		oPrint:Say (047,130, "MODELO 2 - DADOS DE PRODU«√O E MERCADO"  ,oFont16n)

		nProjeto++

		oPrint:box (053,001,120,580,"-1")
		oPrint:Say (062,005, CVALTOCHAR(nProjeto)							,oFont12)
		oPrint:Say (062,075, "Produto:"  									,oFont12)
		oPrint:Say (062,115, " "+AllTrim(SZE->ZE_PROJETO) 	 			,oFont12)
		oPrint:Say (062,170, AllTrim(SZE->ZE_NOMEPRJ) 	 				,oFont12)
		oPrint:Say (075,075, "Tipo:"		 								,oFont12)
		oPrint:Say (075,115, " "+AllTrim(SZE->ZE_TIPO)  					,oFont12)
		oPrint:Say (075,170, AllTrim(SZE->ZE_NOMETIP)  					,oFont12)
		oPrint:Say (088,075, "NCM:"			 								,oFont12)
		oPrint:Say (088,115, " "+AllTrim(SubStr(SZE->ZE_NCMS,1,8))		,oFont12)
		oPrint:Say (088,170, AllTrim(SZE->ZE_NOMENCM)  					,oFont12)
		oPrint:Say (101,075, "Unidade:"  									,oFont12)
		oPrint:Say (101,115, " "+AllTrim(SZE->ZE_UNIDADE)  				,oFont12)
		oPrint:Say (101,170, SX5->X5_DESCSPA  							,oFont12)
		oPrint:Say (114,075, "ProduÁ„o:"+TRANSFORM(Round((cAlias)->&("PRD"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")  ,oFont12)


		oPrint:box (120,001,135,580,"-1")
		oPrint:Say (130,025, "Nacional"  						,oFont12n)
		oPrint:Say (130,120, "Lucro Real" 						,oFont12n)
		oPrint:Say (130,220, "Simples"  						,oFont12n)
		oPrint:Say (130,295, "Lucro Presumido"					,oFont12n)
		oPrint:Say (130,400, "Org Govern" 						,oFont12n)
		oPrint:Say (130,510, "Outros"	  						,oFont12n)
		oPrint:box (135,001,150,580,"-1")
		oPrint:Say (145,025, "Quantidade:"  					,oFont12)
		oPrint:Say (145,100, TRANSFORM(Round((cAlias)->&("QTREAL"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")						,oFont12)
		oPrint:Say (145,195, TRANSFORM(Round((cAlias)->&("QTSIMP"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (145,290, TRANSFORM(Round((cAlias)->&("QTPRES"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (145,385, TRANSFORM(Round((cAlias)->&("QTGOVE"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (145,480, TRANSFORM(Round((cAlias)->&("QTOUTR"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (150,001,165,580,"-1")
		oPrint:Say (160,025, "Faturamento($)" 										,oFont12)
		oPrint:Say (160,100, TRANSFORM(Round((cAlias)->TOTREAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (160,195, TRANSFORM(Round((cAlias)->TOTSIMP,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (160,290, TRANSFORM(Round((cAlias)->TOTPRES,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (160,385, TRANSFORM(Round((cAlias)->TOTGOVE,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (160,480, TRANSFORM(Round((cAlias)->TOTOUTR,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (165,001,180,580,"-1")
		oPrint:Say (175,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(120,095,165,095,,"-4")
		oPrint:Line(120,190,165,190,,"-4")
		oPrint:Line(120,285,165,285,,"-4")
		oPrint:Line(120,380,165,380,,"-4")
		oPrint:Line(120,475,165,475,,"-4")


		oPrint:box (185,001,200,580,"-1")
		oPrint:Say (195,220, "Local"  						,oFont12n)
		oPrint:Say (195,310, "Nacional"						,oFont12n)
		oPrint:Say (195,410, "Exterior"						,oFont12n)
		oPrint:Say (195,510, "Total"  						,oFont12n)
		oPrint:box (200,001,215,580,"-1")
		oPrint:Say (210,025, "Quantidade:"  					,oFont12)
		oPrint:Say (210,195, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99") 	 					,oFont12)
		oPrint:Say (210,290, TRANSFORM(Round((cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99") 	 					,oFont12)
		oPrint:Say (210,385, TRANSFORM(Round((cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99") 	 					,oFont12)
		oPrint:Say (210,480, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99") 	 					,oFont12)
		oPrint:box (215,001,230,580,"-1")
		oPrint:Say (225,025, "Faturamento($)" 					,oFont12)
		oPrint:Say (225,195, TRANSFORM(Round((cAlias)->TOTLOCAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (225,290, TRANSFORM(Round((cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (225,385, TRANSFORM(Round((cAlias)->TOTALEX,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (225,480, TRANSFORM(Round((cAlias)->TOTLOCAL+(cAlias)->TOTALEX+(cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (230,001,245,580,"-1")
		oPrint:Say (240,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(185,095,230,095,,"-4")
		oPrint:Line(185,190,230,190,,"-4")
		oPrint:Line(185,285,230,285,,"-4")
		oPrint:Line(185,380,230,380,,"-4")
		oPrint:Line(185,475,230,475,,"-4")

		//--------------------------------------------------------------------
		//Segundo projeto

		(cAlias)->(DbSkip())
		If (cAlias)->(Eof())
			Exit
		EndIf
		nProjeto++

		DbSelectArea("SZE")
		SZE->(DbSetOrder(1))
		SZE->(DbGoTop())
		SZE->(DbSeek(xFilial("SZE")+(cAlias)->PROJETO))

		DbSelectArea("SX5")
		SX5->(DbSetOrder(1))
		SX5->(DbGoTop())
		SX5->(DbSeek(xFilial("SX5")+"ZY"+SZE->ZE_UNIDADE))

		oPrint:box (270,001,337,580,"-1")
		oPrint:Say (279,005, CVALTOCHAR(nProjeto)							,oFont12)
		oPrint:Say (279,075, "Produto:"  									,oFont12)
		oPrint:Say (279,115, " "+AllTrim(SZE->ZE_PROJETO) 	 			,oFont12)
		oPrint:Say (279,170, AllTrim(SZE->ZE_NOMEPRJ) 	 				,oFont12)
		oPrint:Say (292,075, "Tipo:"		 								,oFont12)
		oPrint:Say (292,115, " "+AllTrim(SZE->ZE_TIPO)  					,oFont12)
		oPrint:Say (292,170, AllTrim(SZE->ZE_NOMETIP)  					,oFont12)
		oPrint:Say (305,075, "NCM:"			 								,oFont12)
		oPrint:Say (305,115, " "+AllTrim(SubStr(SZE->ZE_NCMS,1,8))		,oFont12)
		oPrint:Say (305,170, AllTrim(SZE->ZE_NOMENCM)  					,oFont12)
		oPrint:Say (318,075, "Unidade:"  									,oFont12)
		oPrint:Say (318,115, " "+AllTrim(SZE->ZE_UNIDADE)  				,oFont12)
		oPrint:Say (318,170, SX5->X5_DESCSPA		  						,oFont12)
		oPrint:Say (331,075, "ProduÁ„o:"+TRANSFORM(Round((cAlias)->&("PRD"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")  ,oFont12)


		oPrint:box (337,001,352,580,"-1")
		oPrint:Say (347,025, "Nacional"  						,oFont12n)
		oPrint:Say (347,120, "Lucro Real" 						,oFont12n)
		oPrint:Say (347,220, "Simples"  						,oFont12n)
		oPrint:Say (347,295, "Lucro Presumido"					,oFont12n)
		oPrint:Say (347,400, "Org Govern" 						,oFont12n)
		oPrint:Say (347,510, "Outros"	  						,oFont12n)
		oPrint:box (352,001,367,580,"-1")
		oPrint:Say (362,025, "Quantidade:"  					,oFont12)
		oPrint:Say (362,100, TRANSFORM(Round((cAlias)->&("QTREAL"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (362,195, TRANSFORM(Round((cAlias)->&("QTSIMP"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (362,290, TRANSFORM(Round((cAlias)->&("QTPRES"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (362,385, TRANSFORM(Round((cAlias)->&("QTGOVE"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (362,480, TRANSFORM(Round((cAlias)->&("QTOUTR"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (367,001,382,580,"-1")
		oPrint:Say (377,025, "Faturamento($)" 					,oFont12)
		oPrint:Say (377,100, TRANSFORM(Round((cAlias)->TOTREAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (377,195, TRANSFORM(Round((cAlias)->TOTSIMP,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (377,290, TRANSFORM(Round((cAlias)->TOTPRES,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (377,385, TRANSFORM(Round((cAlias)->TOTGOVE,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (377,480, TRANSFORM(Round((cAlias)->TOTOUTR,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (382,001,397,580,"-1")
		oPrint:Say (392,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(337,095,382,095,,"-4")
		oPrint:Line(337,190,382,190,,"-4")
		oPrint:Line(337,285,382,285,,"-4")
		oPrint:Line(337,380,382,380,,"-4")
		oPrint:Line(337,475,382,475,,"-4")


		oPrint:box (402,001,417,580,"-1")
		oPrint:Say (412,220, "Local"  						,oFont12n)
		oPrint:Say (412,310, "Nacional"						,oFont12n)
		oPrint:Say (412,410, "Exterior"						,oFont12n)
		oPrint:Say (412,510, "Total"  						,oFont12n)
		oPrint:box (417,001,432,580,"-1")
		oPrint:Say (427,025, "Quantidade:"  					,oFont12)
		oPrint:Say (427,195, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (427,290, TRANSFORM(Round((cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (427,385, TRANSFORM(Round((cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (427,480, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (432,001,447,580,"-1")
		oPrint:Say (442,025, "Faturamento($)" 					,oFont12)
		oPrint:Say (442,195, TRANSFORM(Round((cAlias)->TOTLOCAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (442,290, TRANSFORM(Round((cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (442,385, TRANSFORM(Round((cAlias)->TOTALEX,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (442,480, TRANSFORM(Round((cAlias)->TOTLOCAL+(cAlias)->TOTALEX+(cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (447,001,462,580,"-1")
		oPrint:Say (457,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(402,095,447,095,,"-4")
		oPrint:Line(402,190,447,190,,"-4")
		oPrint:Line(402,285,447,285,,"-4")
		oPrint:Line(402,380,447,380,,"-4")
		oPrint:Line(402,475,447,475,,"-4")

		//--------------------------------------------------------------------
		//Terceiro projeto

		(cAlias)->(DbSkip())
		If (cAlias)->(Eof())
			Exit
		EndIf
		nProjeto++

		DbSelectArea("SZE")
		SZE->(DbSetOrder(1))
		SZE->(DbGoTop())
		SZE->(DbSeek(xFilial("SZE")+(cAlias)->PROJETO))

		DbSelectArea("SX5")
		SX5->(DbSetOrder(1))
		SX5->(DbGoTop())
		SX5->(DbSeek(xFilial("SX5")+"ZY"+SZE->ZE_UNIDADE))

		oPrint:box (487,001,554,580,"-1")
		oPrint:Say (496,005, CVALTOCHAR(nProjeto)							,oFont12)
		oPrint:Say (496,075, "Produto:"  									,oFont12)
		oPrint:Say (496,115, " "+AllTrim(SZE->ZE_PROJETO) 	 			,oFont12)
		oPrint:Say (496,170, AllTrim(SZE->ZE_NOMEPRJ) 	 				,oFont12)
		oPrint:Say (509,075, "Tipo:"		 								,oFont12)
		oPrint:Say (509,115, " "+AllTrim(SZE->ZE_TIPO)  					,oFont12)
		oPrint:Say (509,170, AllTrim(SZE->ZE_NOMETIP)  					,oFont12)
		oPrint:Say (522,075, "NCM:"			 								,oFont12)
		oPrint:Say (522,115, " "+AllTrim(SubStr(SZE->ZE_NCMS,1,8))		,oFont12)
		oPrint:Say (522,170, AllTrim(SZE->ZE_NOMENCM)  					,oFont12)
		oPrint:Say (535,075, "Unidade:"  									,oFont12)
		oPrint:Say (535,115, " "+AllTrim(SZE->ZE_UNIDADE)  				,oFont12)
		oPrint:Say (535,170, SX5->X5_DESCSPA		  						,oFont12)
		oPrint:Say (548,075, "ProduÁ„o:"+TRANSFORM(Round((cAlias)->&("PRD"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")  ,oFont12)


		oPrint:box (554,001,569,580,"-1")
		oPrint:Say (564,025, "Nacional"  						,oFont12n)
		oPrint:Say (564,120, "Lucro Real" 						,oFont12n)
		oPrint:Say (564,220, "Simples"  						,oFont12n)
		oPrint:Say (564,295, "Lucro Presumido"					,oFont12n)
		oPrint:Say (564,400, "Org Govern" 						,oFont12n)
		oPrint:Say (564,510, "Outros"	  						,oFont12n)
		oPrint:box (569,001,584,580,"-1")
		oPrint:Say (579,025, "Quantidade:"  					,oFont12)
		oPrint:Say (579,100, TRANSFORM(Round((cAlias)->&("QTREAL"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (579,195, TRANSFORM(Round((cAlias)->&("QTSIMP"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (579,290, TRANSFORM(Round((cAlias)->&("QTPRES"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (579,385, TRANSFORM(Round((cAlias)->&("QTGOVE"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (579,480, TRANSFORM(Round((cAlias)->&("QTOUTR"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (584,001,599,580,"-1")
		oPrint:Say (594,025, "Faturamento($)" 					,oFont12)
		oPrint:Say (594,100, TRANSFORM(Round((cAlias)->TOTREAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (594,195, TRANSFORM(Round((cAlias)->TOTSIMP,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (594,290, TRANSFORM(Round((cAlias)->TOTPRES,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (594,385, TRANSFORM(Round((cAlias)->TOTGOVE,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (594,480, TRANSFORM(Round((cAlias)->TOTOUTR,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (599,001,614,580,"-1")
		oPrint:Say (609,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(554,095,599,095,,"-4")
		oPrint:Line(554,190,599,190,,"-4")
		oPrint:Line(554,285,599,285,,"-4")
		oPrint:Line(554,380,599,380,,"-4")
		oPrint:Line(554,475,599,475,,"-4")


		oPrint:box (619,001,634,580,"-1")
		oPrint:Say (629,220, "Local"  						,oFont12n)
		oPrint:Say (629,310, "Nacional"						,oFont12n)
		oPrint:Say (629,410, "Exterior"						,oFont12n)
		oPrint:Say (629,510, "Total"  						,oFont12n)
		oPrint:box (634,001,649,580,"-1")
		oPrint:Say (644,025, "Quantidade:"  					,oFont12)
		oPrint:Say (644,195, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (644,290, TRANSFORM(Round((cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (644,385, TRANSFORM(Round((cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (644,480, TRANSFORM(Round((cAlias)->&("QTLOCA"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTEX"+AllTrim(SX5->X5_DESCRI))+(cAlias)->&("QTNAC"+AllTrim(SX5->X5_DESCRI)),2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (649,001,664,580,"-1")
		oPrint:Say (659,025, "Faturamento($)" 					,oFont12)
		oPrint:Say (659,195, TRANSFORM(Round((cAlias)->TOTLOCAL,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (659,290, TRANSFORM(Round((cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (659,385, TRANSFORM(Round((cAlias)->TOTALEX,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:Say (659,480, TRANSFORM(Round((cAlias)->TOTLOCAL+(cAlias)->TOTALEX+(cAlias)->TOTALNAC,2),"@E 99,999,999,999.99")	  					,oFont12)
		oPrint:box (664,001,679,580,"-1")
		oPrint:Say (674,025, "ObservaÁ„o:" 					,oFont12)

		oPrint:Line(619,095,664,095,,"-4")
		oPrint:Line(619,190,664,190,,"-4")
		oPrint:Line(619,285,664,285,,"-4")
		oPrint:Line(619,380,664,380,,"-4")
		oPrint:Line(619,475,664,475,,"-4")

		oPrint:EndPage()       // Finaliza a p·gina
		oPrint:StartPage()     // INICIALIZA a p·gina

		(cAlias)->(DbSkip())

	EndDo

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath

	oPrint:Print()
	oPrint:EndPage()

	CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USU¡RIO
	ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

Return