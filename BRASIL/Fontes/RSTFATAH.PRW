#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAH    ºAutor  ³Giovani Zago    º Data ³  07/04/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ITENS S\ COMPROMISSOS 	                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATAH()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAH"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cAliasP		   	:= 'P'+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Da Emissao:"	,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   ,08      	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Até a Emissao:","Até a Emissao:"	,"Até a Emissao:" 		,"mv_ch2","D"   ,08     	,0       	,0      ,"G"	,""    	,""	 	 	,""         ,""   	,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "03", "Do Produto:" 	,"Da Data: ?" 		,"Da Data: ?" 			,"mv_ch3","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Produto:" 	,"Ate Data: ?" 		,"Ate Data: ?" 			,"mv_ch4","C"	,15			,0			,0		,"G"	,""		,'SB1'    	,""			,""		,"mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Do Grupo:" 	,"Do Vendedor: ?" 	,"Do Vendedor: ?" 		,"mv_ch5","C"	,04			,0			,0		,"G"	,""		,'SBM' 		,""			,""		,"mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Grupo:"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 		,"mv_ch6","C"	,04			,0			,0		,"G"	,""		,'SBM' 		,""			,""		,"mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Tipo: ?"		,"Tipo: ?"	 		,"Crédito: ?" 			,"mv_ch7","C"   ,1      	,0       	,0      ,"C"	,""    	,""	 		,""         ,"S"   	,"mv_par07","Comprado"         ,""      ,""      ,""    ,"Fabricado"   ,""     ,""      ,"Todos"   ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

	oReport		:= ReportDef()
	 oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ITENS S\ COMPROMISSOS			                  º±±
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
	
	oReport := TReport():New(cPergTit,"RELATÓRIO DE ITENS Sem COMPROMISSOS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório DE ITENS Sem COMPROMISSOS")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"ITENS Sem COMPROMISSOS",{"SC6"})

	TRCell():New(oSection,"01",,"PEDIDO"			,,06,.F.,)
	TRCell():New(oSection,"17",,"DESTINO"			,,02,.F.,)
	TRCell():New(oSection,"02",,"ITEM"				,,02,.F.,)
	TRCell():New(oSection,"03",,"PRODUTO" 			,,15,.F.,)
	TRCell():New(oSection,"04",,"DESCRICAO" 		,,30,.F.,)
	TRCell():New(oSection,"05",,"GRUPO" 			,,05,.F.,)
	TRCell():New(oSection,"06",,"DESCGRUPO" 		,,30,.F.,)
	TRCell():New(oSection,"07",,"EMISSAO"			,,10,.F.,)
	TRCell():New(oSection,"08",,"SALDO"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"NET"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"10",,"FALTA"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"11",,"CLASSIFICACAO" 	,,01,.F.,)
	TRCell():New(oSection,"12",,"COMPROMISSO" 		,,06,.F.,)
	TRCell():New(oSection,"13",,"DATA2" 				,,10,.F.,)
	TRCell():New(oSection,"16",,"DATA1" 				,,10,.F.,)
	TRCell():New(oSection,"14",,"MMG"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"15",,"DISPONIVEL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"18",,"DE"             ,,20,.F.,)
	TRCell():New(oSection,"19",,"ATE"            ,,20,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")
	
	
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
	
	oReport:SetTitle("ITENS Sem COMPROMISSOS")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			_nDisp:= 0
			Dbselectarea('SB2')
			SB2->(DbSetOrder(1))
			If	SB2->(DbSeek('02'+ (cAliasLif)->PRODUTO +'03'))
				_nDisp:= SB2->B2_QATU - (U_STResSDC(SB2->B2_COD) + u_STSldPV(SB2->B2_COD,'02'))- SB2->B2_QACLASS
			EndIf
			If valtype(_nDisp) <> 'N'
				_nDisp:= 0
			EndIf
			aDados1[01]	:=  (cAliasLif)->PEDIDO
			aDados1[02]	:=  (cAliasLif)->ITEM
			aDados1[03]	:=  (cAliasLif)->PRODUTO
			aDados1[04]	:=  (cAliasLif)->DESCRICAO
			aDados1[05]	:=  (cAliasLif)->GRUPO
			aDados1[06]	:=  (cAliasLif)->DESC
			aDados1[07]	:=  (cAliasLif)->EMISSAO
			aDados1[08]	:=  (cAliasLif)->SALDO
			aDados1[09]	:=  Iif(Getmv("ST_RSTAH",,"000000/000645/") $ __cUserId,(cAliasLif)->NET,0)
			aDados1[10]	:=  (cAliasLif)->FALTA
			aDados1[11]	:=  (cAliasLif)->CLASSIFICACAO
			aDados1[12]	:=  (cAliasLif)->COMPROMISSO
			aDados1[13]	:=  (cAliasLif)->DTCOMPROMISSO
			aDados1[14]	:=  (cAliasLif)->MMG
			aDados1[15]	:=  _nDisp
			aDados1[16]	:=  (cAliasLif)->DT1
			aDados1[17]	:=  (cAliasLif)->DESTINO			
			aDados1[18]	:=  (cAliasLif)->DE
			aDados1[19]	:=  Stod((cAliasLif)->ATE)		
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

	// QUERY ESPECIFICA POR ISSO NAO USEI RESTSQLNAME
	cQuery := " SELECT
	
	cQuery += " C6_NUM
	cQuery += ' "PEDIDO",
	cQuery += " C6_ITEM
	cQuery += ' "ITEM",
	cQuery += " C6_PRODUTO
	cQuery += ' "PRODUTO",
	cQuery += " B1_DESC
	cQuery += ' "DESCRICAO",
	cQuery += " BM_GRUPO
	cQuery += ' "GRUPO",
	cQuery += " BM_DESC
	cQuery += ' "DESC",
	cQuery += " SUBSTR( C5_EMISSAO,7,2)||'/'||SUBSTR( C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4)
	cQuery += ' "EMISSAO",
	cQuery += " (C6_QTDVEN - C6_QTDENT)
	cQuery += ' "SALDO",
	cQuery += " NVL(ROUND(C6_ZVALLIQ/ C6_QTDVEN * (C6_QTDVEN - C6_QTDENT),2),0)
	cQuery += ' "NET",
	cQuery += " PA1_QUANT
	cQuery += ' "FALTA",
	cQuery += " SUBSTR( C6_ENTRE1,7,2)||'/'||SUBSTR( C6_ENTRE1,5,2)||'/'||SUBSTR(C6_ENTRE1,1,4)  
	cQuery += ' "DT1",
	
	cQuery += " 	CASE WHEN
	cQuery += " SC6.C6_OPER = '01'
	cQuery += " THEN 'BR'
	cQuery += " ELSE 'EX' END 
	cQuery += ' 	"DESTINO",
	
	cQuery += "  B1_CLAPROD
	cQuery += ' "CLASSIFICACAO",
	cQuery += " NVL(ZZJ_NUM, ' ')
	cQuery += ' "COMPROMISSO",
	cQuery += " SUBSTR( ZZJ_DATA,7,2)||'/'||SUBSTR( ZZJ_DATA,5,2)||'/'||SUBSTR(ZZJ_DATA,1,4)
	cQuery += ' "DTCOMPROMISSO",
	
	cQuery += " CASE WHEN B1_CLAPROD = 'C'
	cQuery += " THEN
	cQuery += " NVL((SELECT SUM(TC6.C6_QTDVEN - SC6.C6_QTDENT) FROM SC6030 TC6
	cQuery += " WHERE TC6.D_E_L_E_T_ = ' '
	cQuery += " AND TC6.C6_FILIAL = '01'
	cQuery += " AND TC6.C6_CLI = '033467'
	cQuery += " AND TC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND TC6.C6_BLQ <> 'R'
	cQuery += " AND TC6.C6_OPER = '15'
	cQuery += " AND TC6.C6_PRODUTO  = SC6.C6_PRODUTO
	cQuery += " AND TC6.C6_LOJA = '02'),0)
	cQuery += " ELSE
	cQuery += " CASE WHEN B1_CLAPROD = 'F'
	
	cQuery += " THEN
	
	cQuery += " NVL((SELECT SUM(BC6.C6_QTDVEN - BC6.C6_QTDENT) FROM SC6010 BC6
	cQuery += " WHERE BC6.D_E_L_E_T_ = ' '
	cQuery += " AND BC6.C6_FILIAL = '01'
	cQuery += " AND BC6.C6_CLI = '033467'
	cQuery += " AND BC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND BC6.C6_BLQ <> 'R'
	cQuery += " AND BC6.C6_OPER = '94'
	cQuery += " AND BC6.C6_PRODUTO  = SC6.C6_PRODUTO
	cQuery += " AND BC6.C6_LOJA = '02'),0)
	
	cQuery += " ELSE
	cQuery += " 0 END
	cQuery += " END
	
	cQuery += ' "MMG",
	
	cQuery += " SC5.C5_XDE||'/'||SC5.C5_XMDE||'/'||SC5.C5_XDANO
	cQuery += ' "DE",
	cQuery += " SC5.C5_XAANO||SC5.C5_XMATE||SC5.C5_XATE
	cQuery += ' "ATE"
		
	cQuery += " FROM SC6010 SC6

	cQuery += " INNER JOIN ( SELECT * FROM SB1010) SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = SC6.C6_PRODUTO
	cQuery += " AND B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "

	If MV_PAR07 == 1
		cQuery += " AND B1_CLAPROD =  'C'
	ElseIf MV_PAR07 == 2
		cQuery += " AND B1_CLAPROD =  'F'
	EndIf

	cQuery += " INNER JOIN ( SELECT * FROM SBM010) SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND BM_GRUPO = B1_GRUPO
	cQuery += " AND BM_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	
	cQuery += " INNER JOIN( SELECT * FROM PA1010) PA1
	cQuery += " ON PA1.D_E_L_E_T_ =  ' '
	cQuery += " AND PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM
	
	cQuery += " INNER JOIN( SELECT * FROM SC5010) SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = SC6.C6_NUM
	cQuery += " AND C5_FILIAL = SC6.C6_FILIAL
	cQuery += " AND C5_NOTA NOT LIKE 'XXX'
	cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	
	cQuery += " LEFT JOIN(SELECT * FROM ZZJ010) ZZJ
	cQuery += " ON ZZJ.D_E_L_E_T_ = ' '
	cQuery += " AND ZZJ_NUM = SC6.C6_XPREV

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND SC6.C6_FILIAL = '02'
//	cQuery += " AND SC6.C6_OPER = '01'
	cQuery += " AND ( (SC6.C6_OPER = '01') OR (SC6.C6_OPER = ' ' AND SC5.C5_PEDEXP <> ' ') )

	cQuery += " AND NOT EXISTS(SELECT * FROM SC9010 SC9
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND C9_ITEM = SC6.C6_ITEM
	cQuery += " AND  C9_BLCRED IN ('01','09'))
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()
