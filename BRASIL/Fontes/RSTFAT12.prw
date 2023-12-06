#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT12     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio analise cliente                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT12()

	Local   oReport
	Private cPerg 			:= "RFAT12"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private c1AliasLif   	:= "x"+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private _cNome          := " "
	Private _cCod           := __cuserid
	Private cPergTit 		:= cAliasLif
	Public  _cXCodVen361    := ' '
	Public n

	DbSelectArea('SA1')
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod))
		If (SA3->A3_TPVEND == 'E') .or. (Left(SA3->A3_COD,1)=="E")    // SA3->A3_TPVEND <> 'I'  - Ticket: 20210712012307 - Valdemir Rabelo 20/07/2021
			_cXCodVen361:=SA3->A3_COD
			SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
		ELSE
			If	!(substr(SA3->A3_COD,1,1)  $ "/C/S")
				If !(_cCod $ GetMv("ST_FAT12",,'000391/000380')+'/000000/000645')
					msginfo("Usuario sem acesso")
					Return()
				EndIf
			EndIf
		EndIf
	EndIf

	PutSx1( cPerg, "01","Cliente:"     	,"","","mv_ch1","C",6,0,0,"G",'ExistCpo("SA1")  ',"SA1"	,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Loja de:"    	,"","","mv_ch2","C",2,0,0,"G",""				 ,""	,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Loja Até:"    	,"","","mv_ch3","C",2,0,0,"G",""				 ,""	,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Ano(base):"   	,"","","mv_ch4","C",4,0,0,"G",""				 ,""	,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "05","Mês de:" 		,"","","mv_ch5","C",2,0,0,"G",""				 ,""	,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "06","Mês Até:"      ,"","","mv_ch6","C",2,0,0,"G",""				 ,""	,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "07","Modalidade:"   ,"","","mv_ch7","N",1,0,2,"C",""				 ,""	,"","","mv_par07","Faturamento","","","","Captação","","","","","","","","","","","")

	oReport		:= ReportDef()
	if oReport <> nil     // Ticket: 20210712012307 - Valdemir Rabelo 20/07/2021 
		oReport:PrintDialog()
	Endif 
	SA1->(DbClearFilter())

Return

Static Function ReportDef()

	Local oReport
	Local oSection


	DbSelectArea("SA1")
	SA1->(dbGoTop())
	SA1->(dbSetOrder(1))
	If Pergunte(cPerg,.t.)     .And.  ( SA1->(DbSeek(xFilial("SA1")+mv_par01 )) .Or. Substr(AllTrim(mv_par01),1,3) = 'MRV' .Or. Substr(AllTrim(mv_par01),1,6) = 'OKINAL')

		oReport := TReport():New(cPergTit,"RELATÓRIO ANÁLISE DE CLIENTE",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Análise de Cliente .")

		_cNome:=''

		DbSelectArea("SA1")
		SA1->(dbGoTop())
		SA1->(dbSetOrder(1))
		If	SA1->(DbSeek(xFilial("SA1")+mv_par01 ))
			_cNome:= ALLTRIM(SA1->A1_NREDUZ)
		ElseIf Substr(AllTrim(mv_par01),1,3) = 'MRV'
			_cNome:= 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			_cNome:= 'OKINALAR'
		EndIf
		oSection := TRSection():New(oReport,"Análise Cliente ("+_cNome+") - "+Iif (mv_par07 = 1,'FATURAMENTO','CAPTAÇÃO'),{"DA1"})

		TRCell():New(oSection,"GRUPO",,"GRUPO",,40,.F.,)
		TRCell():New(oSection,'Quantidade('+tira1(MV_PAR04)+')	 ',,'Quantidade('+tira1(MV_PAR04)+')	 ',"@E 999,999.99",6)
		TRCell():New(oSection,'Valor('+tira1(MV_PAR04)+')',,'Valor('+tira1(MV_PAR04)+')',"@E 99,999,999.99",14)
		TRCell():New(oSection,'Quantidade('+ MV_PAR04 +')	 ',,'Quantidade('+ MV_PAR04 +')	 ',"@E 999,999.99",6)
		TRCell():New(oSection,'Valor('+  MV_PAR04 +')',,'Valor('+ MV_PAR04 +')',"@E 99,999,999.99",14)
		TRCell():New(oSection,"%Diferença",,"%Diferença","@E 99,999.99",7)

		oSection:SetHeaderSection(.t.)
		oSection:Setnofilter("DA1")
	EndIf
Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1[99]
	Local nValLiq 	:= 0
	Local nValBrut	:= 0
	Local   _nPosPrv  		:= 0
	Local   _nPosProd  		:= 0
	Local   _nPosTes  		:= 0
	Local	nPValICMS		:= 0
	Local	nPAliqICM  		:= 0
	Local	nPValICMSST		:= 0
	Local	nPValIPI		:= 0
	Local	nPosIpi		    := 0
	Local	nPosList		:= 0
	Local	_nPosDEXC		:= 0
	Local	nPosCOMISS		    := 0
	Local _nPosDESC         := 0
	Local _cGrupProd        := ' '
	Local aTotal            :={0,0,0,0,0,0,0,0,0,0,0}
	Local _nx               := 0
	Local i               := 0
	If  Mv_PAR07 = 1
		TRCell():New(oSection,"Valor Bruto"	,,"Bruto"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"St"			,,"St"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"Ipi"			,,"Ipi"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"Bruto ST/IPI",,"ST/IPI"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"Icms/Difal"	,,"Icms/Difal"	,"@E 99,999,999.99",14)

	EndIf
	oSection1:Cell("GRUPO")									:SetBlock( { || aDados1[01] } )
	oSection1:Cell('Quantidade('+tira1(MV_PAR04)+')	 ')		:SetBlock( { || aDados1[02] } )
	oSection1:Cell('Valor('+tira1(MV_PAR04)+')')			:SetBlock( { || aDados1[03] } )
	oSection1:Cell('Quantidade('+ MV_PAR04 +')	 ')			:SetBlock( { || aDados1[04] } )
	oSection1:Cell('Valor('+  MV_PAR04 +')')				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("%Diferença")							:SetBlock( { || aDados1[06] } )
	If  Mv_PAR07 = 1
		oSection1:Cell("Bruto")							:SetBlock( { || aDados1[07] } )
		oSection1:Cell("St")							:SetBlock( { || aDados1[08] } )
		oSection1:Cell("Ipi")							:SetBlock( { || aDados1[09] } )
		oSection1:Cell("ST/IPI")						:SetBlock( { || aDados1[10] } )
		oSection1:Cell("Icms/Difal")					:SetBlock( { || aDados1[11] } )
	EndIf



	oReport:SetTitle("Análise Cliente ("+_cNome+") "+Iif (mv_par07 = 1,' - FATURAMENTO',' - CAPTAÇÃO'))// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	strelquer()

	rptstatus({|| xVALUSST('01') },"Compondo Relatorio")
	aSort(Acols,,,{|x,y| x[1]<y[1]})
	For i:=1 To Len(Acols)


		aDados1[01]	:=	aCols[i][1]
		aDados1[02]	:=	aCols[i][2]
		aDados1[03]	:=	aCols[i][3]
		aDados1[04]	:=	aCols[i][4]
		aDados1[05]	:=	aCols[i][5] - sDEVRST(substr(aCols[i][1],1,3),mv_par04)
		aDados1[06]	:= 	aCols[i][6]
		If  Mv_PAR07 = 1
			aDados1[07]	:= 	aCols[i][7]
			aDados1[08]	:= 	aCols[i][8]
			aDados1[09]	:= 	aCols[i][9]
			aDados1[10]	:= 	aCols[i][10]
			aDados1[11]	:= 	aCols[i][11]
		EndIf

		aTotal[01]	:=	aCols[i][2] +	aTotal[01]
		aTotal[02]	:=	aCols[i][3] +	aTotal[02]
		aTotal[03]	:=	aCols[i][4] +	aTotal[03]
		aTotal[04]	:=	aDados1[05] +	aTotal[04]
		aTotal[05]	:= 	aCols[i][6] +	aTotal[05]

		If  Mv_PAR07 = 1
			aTotal[07]	:= 	aCols[i][7] +	aTotal[07]
			aTotal[08]	:= 	aCols[i][8] +	aTotal[08]
			aTotal[09]	:= 	aCols[i][9] +	aTotal[09]
			aTotal[10]	:= 	aCols[i][10] +	aTotal[10]
			aTotal[11]	:= 	aCols[i][11] +	aTotal[11]
		EndIf
		oSection1:PrintLine()
		aFill(aDados1,nil)

		_nx:=i
	next i

	oSection1:PrintLine()
	aFill(aDados1,nil)

	aDados1[01]	:=  'TOTAL'
	aDados1[02]	:=	aTotal[01]
	aDados1[03]	:=  aTotal[02]
	aDados1[04]	:=	aTotal[03]
	aDados1[05]	:=  aTotal[04]
	aDados1[06]	:= ((aTotal[04]*100)/	aTotal[02] ) - 100

	If  Mv_PAR07 = 1
		aDados1[07]	:=	aTotal[07]
		aDados1[08]	:=  aTotal[08]
		aDados1[09]	:=	aTotal[09]
		aDados1[10]	:=  aTotal[10]
		aDados1[11]	:=	aTotal[11]
	EndIf
	oSection1:PrintLine()
	aFill(aDados1,nil)






	oReport:SkipLine()




Return oReport


//SELECIONA OS PRODUTOS
Static Function strelquer()

	Local cQuery     := ' '


	If  Mv_PAR07 = 1
		cQuery := " SELECT
		cQuery += ' SUBSTR(SD2.D2_EMISSAO,1,6) "MES",
		//cQuery += ' SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM) "VALOR",
		//cQuery += ' SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM-NVL(D1_TOTAL,0)) "VALOR",
		cQuery += ' SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM) "VALOR",
		cQuery += ' SUM(SD2.D2_TOTAL) "BRUTO",
		cQuery += ' SUM(SD2.D2_ICMSRET) "ST",
		cQuery += ' SUM(SD2.D2_VALIPI) "IPI",
		cQuery += ' SUM(SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET) "STIPI",
		cQuery += ' SUM(D2_DIFAL+D2_ICMSCOM) "DIFAL",
		cQuery += ' SB1.B1_GRUPO  "GRUPO",
		cQuery += ' SBM.BM_DESC   "DESCG" ,
		cQuery += ' SUM(SD2.D2_QUANT)  "QTD"

		cQuery += " FROM "+RetSqlName("SD2")+" SD2 "

		/*
		cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SD1")+" ) SD1 "
		cQuery += " ON  SD1.D1_TIPO = 'D'
		cQuery += " AND SD1.D_E_L_E_T_ = ' '
		//cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) =  SUBSTR(SD2.D2_EMISSAO,1,4)
		cQuery += " AND SD1.D1_NFORI = SD2.D2_DOC
		cQuery += " AND SD1.D1_SERIORI = SD2.D2_SERIE
		cQuery += " AND SD1.D1_ITEMORI = SD2.D2_ITEM
		cQuery += " AND SD1.D1_FORNECE = SD2.D2_CLIENTE
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND SD1.D1_LOJA = SD2.D2_LOJA
		*/
		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += " ON SB1.D_E_L_E_T_   = ' '
		cQuery += " AND SB1.B1_COD    = SD2.D2_COD
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
		cQuery += " ON SBM.D_E_L_E_T_   = ' '
		cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
		cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_   = ' '
		cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

		If SA3->A3_TPVEND <> 'I'
			cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf

		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		//	cQuery += " AND SF4.F4_DUPLIC = 'S'
		//cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

		cQuery += " WHERE  SD2.D_E_L_E_T_   = ' '
		cQuery += " AND ( SUBSTR(SD2.D2_EMISSAO,1,6) between  '"+tira1(mv_par04)+MV_PAR05+"'  and '"+tira1(mv_par04)+MV_PAR06+"' or SUBSTR(SD2.D2_EMISSAO,1,6) between  '"+mv_par04+MV_PAR05+"'  and '"+mv_par04+MV_PAR06+"')
		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
			cQuery += " AND SD2.D2_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
			cQuery += " AND SD2.D2_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		Else
			cQuery += " AND SD2.D2_CLIENTE =  '" + MV_PAR01 + "'
			cQuery += " AND SD2.D2_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')


		//	cQuery += " AND SD2.D2_FILIAL   = '"+xFilial("SD2")+"'"
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		//	cQuery += " AND SBM.BM_XAGRUP <> ' ' //giovani.zago 20/02/14 solicitação da tatiana
		/*	cQuery += " AND NOT EXISTS(
		cQuery += " SELECT * FROM SD1010 SD1
		cQuery += " WHERE SD1.D1_TIPO = 'D'
		cQuery += " AND SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_NFORI = SD2.D2_DOC
		cQuery += " AND SD1.D1_SERIORI = SD2.D2_SERIE
		cQuery += " AND SD1.D1_ITEMORI = SD2.D2_ITEM)
		*/


		cQuery += " GROUP BY SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC
		cQuery += " ORDER BY SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC
		//SELECT SUBSTR(SD2.D2_EMISSAO,1,6) "MES",SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM) "VALOR",SB1.B1_GRUPO "GRUPO",SBM.BM_DESC "DESCG",SUM(SD2.D2_QUANT) "QTD" FROM SD2010 SD2 INNER JOIN (SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD2.D2_COD AND SB1.B1_FILIAL = '  ' INNER JOIN (SELECT * FROM SBM010 ) SBM ON SBM.D_E_L_E_T_ = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_FILIAL = '  ' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN (SELECT * FROM SF4010 ) SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S'  WHERE  SD2.D_E_L_E_T_ = ' ' AND (SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '201201' AND '201212' OR SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '201301' AND '201312') AND SD2.D2_CLIENTE = '900001' AND SD2.D2_LOJA BETWEEN '01' AND 'ZZ' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX' AND SBM.BM_XAGRUP <> ' ' AND NOT EXISTS(SELECT * FROM SD1010 SD1 WHERE  SD1.D1_TIPO = 'D' AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM)  GROUP BY SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC  ORDER BY  SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC

	Else

		cQuery := " SELECT
		cQuery += ' SUBSTR(SC5.C5_EMISSAO,1,6) "MES",
		cQuery += "	SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR",
		cQuery += ' 0 "BRUTO",
		cQuery += ' 0 "ST",
		cQuery += ' 0 "IPI",
		cQuery += ' 0 "STIPI",
		cQuery += ' 0 "DIFAL",
		cQuery += ' SB1.B1_GRUPO  "GRUPO",
		cQuery += ' SBM.BM_DESC   "DESCG" ,
		cQuery += " 	SUM(CASE WHEN C6_BLQ = 'R' THEN C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '  "QTD"
		cQuery += " FROM SC5010 SC5

		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
		cQuery += " ON SC6.D_E_L_E_T_   = ' '
		cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL


		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += " ON SB1.D_E_L_E_T_   = ' '
		cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
		cQuery += " ON SBM.D_E_L_E_T_   = ' '
		cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
		cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_   = ' '
		cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		If SA3->A3_TPVEND <> 'I'
			cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf

		cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += " ON C6_NUM = PC1.PC1_PEDREP
		cQuery += " AND PC1.D_E_L_E_T_ = ' '
		cQuery += " AND PC1.PC1_FILIAL = '"+xFilial("PC1")+"'"

		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		//	cQuery += " AND SF4.F4_DUPLIC = 'S'
		cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

		cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
		cQuery += " AND ( SUBSTR(SC5.C5_EMISSAO,1,6) between  '"+tira1(mv_par04)+MV_PAR05+"'  and '"+tira1(mv_par04)+MV_PAR06+"' or SUBSTR(SC5.C5_EMISSAO,1,6) between  '"+mv_par04+MV_PAR05+"'  and '"+mv_par04+MV_PAR06+"')
		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
		Else
			cQuery += " AND SC5.C5_CLIENTE = '" + MV_PAR01 + "'
			cQuery += " AND SC5.C5_LOJACLI between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf
		cQuery += " AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'"
		cQuery += " AND SC5.C5_TIPO = 'N'
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		//cQuery += " AND SBM.BM_XAGRUP <> ' ' //giovani.zago 20/02/14 solicitação da tatiana
		cQuery += " AND PC1.PC1_PEDREP IS NULL
		cQuery += " GROUP BY SUBSTR(SC5.C5_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC


		cQuery += " UNION
		cQuery += " SELECT
		cQuery += ' SUBSTR(SC5.C5_EMISSAO,1,6) "MES",
		cQuery += "	SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR", 0 "BRUTO", 0 "ST", 0 "IPI", 0 "STIPI", 0 "DIFAL",
		cQuery += ' SB1.B1_GRUPO  "GRUPO",
		cQuery += ' SBM.BM_DESC   "DESCG" ,
		cQuery += " 	SUM(CASE WHEN C6_BLQ = 'R' THEN C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '  "QTD"
		cQuery += " FROM SC5010 SC5

		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
		cQuery += " ON SC6.D_E_L_E_T_   = ' '
		cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL


		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += " ON SB1.D_E_L_E_T_   = ' '
		cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

		cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
		cQuery += " ON SBM.D_E_L_E_T_   = ' '
		cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
		cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_   = ' '
		cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		If SA3->A3_TPVEND <> 'I'
			cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf

		cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += " ON C6_NUM = PC1.PC1_PEDREP
		cQuery += " AND PC1.D_E_L_E_T_ = ' '
		cQuery += " AND PC1.PC1_FILIAL = '"+xFilial("PC1")+"'"

		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		//	cQuery += " AND SF4.F4_DUPLIC = 'S'
		cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

		cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
		//cQuery += " AND ( SUBSTR(SC5.C5_EMISSAO,1,6) between  '"+tira1(mv_par04)+MV_PAR05+"'  and '"+tira1(mv_par04)+MV_PAR06+"' or SUBSTR(SC5.C5_EMISSAO,1,6) between  '"+mv_par04+MV_PAR05+"'  and '"+mv_par04+MV_PAR06+"')
		cQuery += " AND  substr(SC5.C5_EMISSAO,1,4)  >= '"+tira1(mv_par04)+"'
		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
		Else
			cQuery += " AND SC5.C5_CLIENTE = '" + MV_PAR01 + "'
			cQuery += " AND SC5.C5_LOJACLI between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf
		cQuery += " AND SC5.C5_FILIAL   = '01' "
		cQuery += " AND SC5.C5_TIPO = 'N'
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		//	cQuery += " AND SBM.BM_XAGRUP <> ' '   //giovani.zago 20/02/14 solicitação da tatiana
		cQuery += " AND PC1.PC1_PEDREP IS NULL



		cQuery += " GROUP BY SUBSTR(SC5.C5_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC
		//	cQuery += " ORDER BY SUBSTR(C5_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC
		cQuery += " ORDER BY MES,GRUPO,DESCG
		//SELECT SUBSTR(SC5.C5_EMISSAO,1,6) "MES",SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) "VALOR",SB1.B1_GRUPO "GRUPO",SBM.BM_DESC "DESCG",SUM(CASE WHEN C6_BLQ = 'R' THEN C6_QTDENT ELSE C6_QTDVEN END) "QTD" FROM SC5010 SC5 INNER JOIN(SELECT * FROM SC6010 ) SC6 ON SC6.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL INNER JOIN (SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' INNER JOIN (SELECT * FROM SBM010 ) SBM ON SBM.D_E_L_E_T_ = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_FILIAL = '  ' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  ' LEFT JOIN (SELECT * FROM PC1010 ) PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' AND PC1.PC1_FILIAL = '  ' INNER JOIN (SELECT * FROM SF4010 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S'  WHERE  SC5.D_E_L_E_T_ = ' ' AND (SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '201201' AND '201299' OR SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '201301' AND '201399') AND SC5.C5_CLIENTE = '000005' AND SC5.C5_LOJACLI BETWEEN '01' AND 'zz' AND SC5.C5_FILIAL = '01' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX' AND SBM.BM_XAGRUP <> ' ' AND PC1.PC1_PEDREP IS NULL GROUP BY SUBSTR(C5_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC  ORDER BY  SUBSTR(C5_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC

	EndIf




	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


	*-----------------------------*
Static Function   xVALUSST(_cOper)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= 1
	Local _nPosOper     := 0
	Local _nPosProd     := 0
	Local _nPosTES      := 0
	Local _nPosClas     := 0
	Local _nPosPrc    	:= 0
	Local _nPosDESC     := 0
	Local _nPosDEXC     := 0
	Local _nICMPAD	    :=_nICMPAD2 :=0
	Local _nDescPad		:=0
	Local _nPis 		:=0
	Local _nCofis		:=0
	Local _nIcms    	:= SA1->A1_CONTRIB
	Local _cEst			:= SA1->A1_EST
	Local _nOpcao 		:= 3
	Local _xAlias 		:= GetArea()
	Local aFields 		:= {}
	Local aCpoEnch		:= {}
	Local aTam  		:= {}
	Local aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Local oDlg
	Local _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	Local _nAsc         := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipos das Opcoes						  ³
	//³ _nOpcao == 1 -> Incluir					  ³
	//³ _nOpcao == 2 -> Visualizar                ³
	//³ _nOpcao == 3 -> Alterar                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local bCampoSC5		:= { |nCPO| Field(nCPO) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arrays de controle dos campos que deverao ser alterados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCposAlt 		:= {}
	Local _NgIO := 0
	//Local _nValAcre     := Posicione("SE4",1,xFilial("SE4")+MV_PAR05,"E4_XACRESC")


	Public aHeader 		:= {}
	Public aCols		:={}

	nUsado:=0


	//				  1-Campo    , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		, 6-Validacao  											, 7-ComboBox
	aTam := TamSX3("C6_PRODUTO")
	AAdd( aFields, { 'C6_PRODUTO', 'C'	, aTam[1]	, 0		, 'Grupo'		, " "													, ''				  					} )
	aTam := TamSX3('C6_QTDVEN')
	AAdd( aFields, { 'C6_QTDVEN' , 'N'	, aTam[1]	, 0		, 'Quantidade('+tira1(MV_PAR04)+')	 ' 	, " "													, ''				  					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN' 	 , 'N'	, aTam[1]	, 0		, 'Valor('+tira1(MV_PAR04)+')	 '  	, " "													, ''				  					} )
	aTam := TamSX3('C6_QTDVEN')
	AAdd( aFields, { 'C6_QTDVEN'	 , 'N'	, aTam[1]   , 0		, 'Quantidade('+MV_PAR04+')	 ' 	, " "				   									, ''				   					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, 'Valor('+MV_PAR04+')	 '  		, " "				   									, ''				   					} )
	aTam := TamSX3('C6_QTDVEN')
	AAdd( aFields, { 'C6_QTDVEN' 	 , 'N'	, aTam[1]   , 0		, 'Diferença'	, " "	  							   					, ''  									} )

	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, '07'  		, " "				   									, ''				   					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, '08'  		, " "				   									, ''				   					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, '09'  		, " "				   									, ''				   					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, '10'  		, " "				   									, ''				   					} )
	aTam := TamSX3('C6_PRCVEN')
	AAdd( aFields, { 'C6_PRCVEN'	     , 'N'	, aTam[1]   , 0		, '11'  		, " "				   									, ''				   					} )



	aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
	// 	01-Titulo			   			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
	aAdd( aHeader, {	aFields[01,5]+Space(20)	, aFields[01,1]	, '@!'		, aFields[01,3]	, 0			, aFields[01,6]	, ''		, aFields[01,2]	, ''		, 'R'			, aFields[01,7]	, ''			, ''   			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[02,5]+Space(20)	, aFields[02,1]	, '@E 999,999,999.99'		, aFields[02,3]	, 0			, aFields[02,6]	, ''		, aFields[02,2]	, ''		, 'R'			, aFields[02,7]	, ''			, ''  			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[03,5]+Space(20)	, aFields[03,1]	, '@E 999,999,999.99'		, aFields[03,3]	, 0			, aFields[03,6]	, ''		, aFields[03,2]	, ''		, 'R'			, aFields[03,7]	, ''			, '' 			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[04,5]+Space(20)	, aFields[04,1]	, '@E 999,999,999.99'		, aFields[04,3]	, 0			, aFields[04,6]	, ''		, aFields[04,2]	, ''		, 'R'			, aFields[04,7]	, ''			, '', ''		, ''				} )
	aAdd( aHeader, {	aFields[05,5]+Space(20)	, aFields[05,1]	, '@E 999,999,999.99'		, aFields[05,3]	, 0			, aFields[05,6]	, ''		, aFields[05,2]	, ''		, 'R'			, aFields[05,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[06,5]+Space(20)	, aFields[06,1]	, '@E 999,999,999.99'		, aFields[06,3]	, 0			, aFields[06,6]	, ''		, aFields[06,2]	, ''		, 'R'			, aFields[06,7]	, ''			, ''			  , ''		, ''				} )


	aAdd( aHeader, {	aFields[07,5]+Space(20)	, aFields[07,1]	, '@E 999,999,999.99'		, aFields[07,3]	, 0			, aFields[07,6]	, ''		, aFields[07,2]	, ''		, 'R'			, aFields[07,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[08,5]+Space(20)	, aFields[08,1]	, '@E 999,999,999.99'		, aFields[08,3]	, 0			, aFields[08,6]	, ''		, aFields[08,2]	, ''		, 'R'			, aFields[08,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[09,5]+Space(20)	, aFields[09,1]	, '@E 999,999,999.99'		, aFields[09,3]	, 0			, aFields[09,6]	, ''		, aFields[09,2]	, ''		, 'R'			, aFields[09,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[10,5]+Space(20)	, aFields[10,1]	, '@E 999,999,999.99'		, aFields[10,3]	, 0			, aFields[10,6]	, ''		, aFields[10,2]	, ''		, 'R'			, aFields[10,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[11,5]+Space(20)	, aFields[11,1]	, '@E 999,999,999.99'		, aFields[11,3]	, 0			, aFields[11,6]	, ''		, aFields[11,2]	, ''		, 'R'			, aFields[11,7]	, ''			, ''			  , ''		, ''				} )


	nUsado:=len(aHeader)
	aCols:={}
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If len(aCols) > 0
				_nAsc:=aScan(aCols, {|x| SUBSTR(x[1],1,4) == (cAliasLif)->GRUPO })
			EndIf
			If _nAsc = 0



				AADD(aCols,Array(nUsado+1))
				_nAsc:=	len(aCols)
				aCols[_nAsc,2]:= 0
				aCols[_nAsc,3]:= 0
				aCols[_nAsc,4]:= 0
				aCols[_nAsc,5]:= 0
				aCols[_nAsc,6]:= 0

				aCols[_nAsc,7]:= 0
				aCols[_nAsc,8]:= 0
				aCols[_nAsc,9]:= 0
				aCols[_nAsc,10]:= 0
				aCols[_nAsc,11]:= 0

				If tira1(MV_PAR04) = SUBSTR((cAliasLif)->MES,1,4)
					aCols[_nAsc,1]:= (cAliasLif)->GRUPO+'  '+(cAliasLif)->DESCG
					aCols[_nAsc,2]+= (cAliasLif)->QTD
					aCols[_nAsc,3]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					//	aCols[_nAsc,4]+= 0
					//	aCols[_nAsc,5]+= 0
					//	aCols[_nAsc,6]+= 0



					//aCols[_nAsc,7]:= (cAliasLif)->BRUTO - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					//	aCols[_nAsc,8]:= (cAliasLif)->ST
					//aCols[_nAsc,9]:= (cAliasLif)->IPI
					//	aCols[_nAsc,10]:= (cAliasLif)->STIPI - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					//	aCols[_nAsc,11]:= (cAliasLif)->DIFAL


				Else
					aCols[_nAsc,1]:= (cAliasLif)->GRUPO+'  '+(cAliasLif)->DESCG
					//aCols[_nAsc,2]+= 0
					//aCols[_nAsc,3]+= 0
					aCols[_nAsc,4]+= (cAliasLif)->QTD
					aCols[_nAsc,5]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					//	aCols[_nAsc,6]+= 0

					aCols[_nAsc,7]:= (cAliasLif)->BRUTO - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,8]:= (cAliasLif)->ST
					aCols[_nAsc,9]:= (cAliasLif)->IPI
					aCols[_nAsc,10]:= (cAliasLif)->STIPI - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,11]:= (cAliasLif)->DIFAL

				EndIf
				aCols[Len(aCols),nUsado+1]:=.F.

				_nAsc:=0
			Else

				If  MV_PAR04  = SUBSTR((cAliasLif)->MES,1,4)
					aCols[_nAsc,4]+= (cAliasLif)->QTD
					aCols[_nAsc,5]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,6]:= IiF  (	aCols[_nAsc,5] = 0 .or.  aCols[_nAsc,3] = 0,0, ((	aCols[_nAsc,5]*100)/	aCols[_nAsc,3] ) - 100 )

					aCols[_nAsc,7]+= (cAliasLif)->BRUTO - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,8]+= (cAliasLif)->ST
					aCols[_nAsc,9]+= (cAliasLif)->IPI
					aCols[_nAsc,10]+= (cAliasLif)->STIPI - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,11]+= (cAliasLif)->DIFAL

				Else
					aCols[_nAsc,2]+= (cAliasLif)->QTD
					aCols[_nAsc,3]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,6]:= IiF  (	aCols[_nAsc,5] = 0 .or.  aCols[_nAsc,3] = 0,0, ((	aCols[_nAsc,5]*100)/	aCols[_nAsc,3] ) - 100 )
					/*
					aCols[_nAsc,7]+= (cAliasLif)->BRUTO- DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,8]+= (cAliasLif)->ST
					aCols[_nAsc,9]+= (cAliasLif)->IPI
					aCols[_nAsc,10]+= (cAliasLif)->STIPI- DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,11]+= (cAliasLif)->DIFAL
					*/
				EndIf
			EndIf

			_NgIO+= (cAliasLif)->VALOR
			(cAliasLif)->(dbskip())

		End


	EndIf


Return  ()


Static Function sDEVRST(_cGru,_cDat)

	Local cQuery     := ' '
	Local _nRe       := 0

	If  Mv_PAR07 = 1


		cQuery := " SELECT  NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) "
		cQuery += ' "TOTAL"
		cQuery += " FROM  "+RetSQLName("SD1")+"  SD1 "
		cQuery += " INNER JOIN "+RetSQLName("SA1")+"  SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		/*
		If SA3->A3_TPVEND <> 'I'
		cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf
		*/
		cQuery += " INNER JOIN "+RetSQLName("SF2")+"  SF2 "
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_DOC = D1_NFORI
		cQuery += " AND SF2.F2_SERIE = D1_SERIORI
		cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

		cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
		//cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + _cDat + "'
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '" + _cDat+MV_PAR05 + "' AND '" + _cDat+MV_PAR06 + "'

		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
		Else
			cQuery += " AND SA1.A1_COD = '" + MV_PAR01 + "'
			cQuery += " AND SA1.A1_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf



		cQuery := ChangeQuery(cQuery)

		If Select(c1AliasLif) > 0
			(c1AliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
		If Select(c1AliasLif) > 0
			_nRe:= (c1AliasLif)->TOTAL
		EndIf



	EndIf

Return  (_nRe)
Static Function DEVRST(_cGru,_cDat)

	Local cQuery     := ' '
	Local _nRe       := 0

	If  Mv_PAR07 = 1
		/*
		cQuery := " SELECT  NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
		cQuery += ' "TOTAL"
		cQuery += " FROM SD1010  SD1
		cQuery += " WHERE SD1.D1_TIPO = 'D'
		cQuery += " AND SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_FORNECE = '" + MV_PAR01 + "'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND SD1.D1_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'
		*/


		cQuery := " SELECT  NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) "
		cQuery += ' "TOTAL"
		cQuery += " FROM  "+RetSQLName("SD1")+"  SD1 "
		cQuery += " INNER JOIN "+RetSQLName("SA1")+"  SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		/*
		If SA3->A3_TPVEND <> 'I'
		cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf
		*/
		cQuery += " INNER JOIN "+RetSQLName("SF2")+"  SF2 "
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_DOC = D1_NFORI
		cQuery += " AND SF2.F2_SERIE = D1_SERIORI
		cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

		cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'


		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
		Else
			cQuery += " AND SA1.A1_COD = '" + MV_PAR01 + "'
			cQuery += " AND SA1.A1_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf



		cQuery := ChangeQuery(cQuery)

		If Select(c1AliasLif) > 0
			(c1AliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
		If Select(c1AliasLif) > 0
			_nRe:= (c1AliasLif)->TOTAL
		EndIf



	EndIf
	_nRe:=0
Return  (_nRe)


Static Function xDEVRST(_cGru,_cDat)

	Local cQuery     := ' '
	Local _nRe       := 0

	If  Mv_PAR07 = 1
		/*
		cQuery := " SELECT  NVL(SUM(D1_TOTAL),0)
		cQuery += ' "TOTAL"
		cQuery += " FROM SD1010  SD1
		cQuery += " WHERE SD1.D1_TIPO = 'D'
		cQuery += " AND SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_FORNECE = '" + MV_PAR01 + "'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND SD1.D1_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'
		*/

		cQuery := " SELECT  NVL(SUM(D1_TOTAL),0) "
		cQuery += ' "TOTAL"
		cQuery += " FROM  "+RetSQLName("SD1")+"  SD1 " 
		cQuery += " INNER JOIN "+RetSQLName("SA1")+"  SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		If SA3->A3_TPVEND <> 'I'
			cQuery += " AND SA1.A1_VEND = '"+ _cXCodVen361 +"'"
		EndIf
		cQuery += " INNER JOIN "+RetSQLName("SF2")+"  SF2 " 
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_DOC = D1_NFORI
		cQuery += " AND SF2.F2_SERIE = D1_SERIORI
		cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

		cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'
		If Substr(AllTrim(mv_par01),1,3) = 'MRV'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,3) = 'MRV'
		ElseIf Substr(AllTrim(mv_par01),1,6) = 'OKINAL'
			cQuery += " AND Substr(SA1.A1_NREDUZ,1,8) = 'OKINALAR'
		Else
			cQuery += " AND SA1.A1_COD = '" + MV_PAR01 + "'
			cQuery += " AND SA1.A1_LOJA between '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		EndIf

		cQuery := ChangeQuery(cQuery)

		If Select(c1AliasLif) > 0
			(c1AliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
		If Select(c1AliasLif) > 0
			_nRe:= (c1AliasLif)->TOTAL
		EndIf



	EndIf
Return  (_nRe)

