#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT24     ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Valor Liquido 		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT24()

	Local   oReport
	Private cPerg 			:= "RFAT03"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private _cDat     := Month2Str( dDataBase  )
	Private _cDat1    := Month2Str(MonthSum(dDataBase,1))
	Private _cDat2    := Month2Str(MonthSum(dDataBase,2))
	Private _cDat3    := Month2Str(MonthSum(dDataBase,3))
	Private _cDat4    := Month2Str(MonthSum(dDataBase,4))
	Private _cDat5    := Month2Str(MonthSum(dDataBase,5))
	Private _cDat6    := Month2Str(MonthSum(dDataBase,6))
	Private _cDat7    := Month2Str(MonthSum(dDataBase,7))
	Private _cDat8    := Month2Str(MonthSum(dDataBase,8))

	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Valor Liquido",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Valor Liquido.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Valor Liquido",{"SC5"})


	TRCell():New(oSection,"GRUPO"	  	,,"GRUPO"		,,6,.F.,)
	TRCell():New(oSection,"DESCRIÇÃO"	,,"DESCRIÇÃO"	,,35,.F.,)
	TRCell():New(oSection,"DISPONIVEL"  ,,"DISPONIVEL"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"REJEITADOS"  ,,"REJEITADOS"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ANALISE"     ,,"ANALISE"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TOTAL"       ,,"TOTAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"MES"       	,,"MES"			,"@E 99,999,999.99",14)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _nToVal:= 0

	TRCell():New(oSection,"TOTAL1"       ,,"TOTAL_"+_cDat1		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TOTAL2"       ,,"TOTAL_"+_cDat2		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TOTAL3"       ,,"TOTAL_"+_cDat3		,"@E 99,999,999.99",14)


	oSection1:Cell("GRUPO")       :SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESCRIÇÃO")	  :SetBlock( { || aDados1[02] } )
	oSection1:Cell("DISPONIVEL")  :SetBlock( { || aDados1[03] } )
	oSection1:Cell("REJEITADOS")  :SetBlock( { || aDados1[04] } )
	oSection1:Cell("ANALISE")	  :SetBlock( { || aDados1[05] } )
	oSection1:Cell("TOTAL")       :SetBlock( { || aDados1[06] } )
	oSection1:Cell("TOTAL1")       :SetBlock( { || aDados1[07] } )
	oSection1:Cell("TOTAL2")       :SetBlock( { || aDados1[08] } )
	oSection1:Cell("TOTAL3")       :SetBlock( { || aDados1[09] } )
	oSection1:Cell("MES")       :SetBlock( { || aDados1[10] } )

	oReport:SetTitle("Valor Liquido")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()




	Processa({|| StQuery( ) },"Compondo Relatorio")




	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())


			aDados1[01]	:= 	(cAliasLif)->GRUPO
			aDados1[02]	:=  (cAliasLif)->DESCRICAO
			_nToVal:=((cAliasLif)->TOTAL-(cAliasLif)->REJEITADOS-(cAliasLif)->ANALISE)-(cAliasLif)->TOTAL5-(cAliasLif)->TOTAL1-(cAliasLif)->TOTAL2-(cAliasLif)->TOTAL3-(cAliasLif)->MES
			aDados1[03]	:=	Iif(_nToVal < 0 ,0,_nToVal)
			aDados1[04]	:=	(cAliasLif)->REJEITADOS
			aDados1[05]	:=	(cAliasLif)->ANALISE
			aDados1[06]	:=	(cAliasLif)->TOTAL
			aDados1[07]	:=	(cAliasLif)->TOTAL1
			aDados1[08]	:=	(cAliasLif)->TOTAL2
			aDados1[09]	:=	(cAliasLif)->TOTAL3
			aDados1[10]	:=	(cAliasLif)->MES
			oSection1:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End



	EndIf



	oReport:SkipLine()




Return oReport



Static Function StQuery()

	Local cQuery      := ' '

	cQuery := " SELECT
	cQuery += ' SB1.B1_GRUPO      "GRUPO",
	cQuery += ' SUBSTR(SBM.BM_DESC,1,30)       "DESCRICAO",

	cQuery += "    SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         )
	cQuery += ' "TOTAL",

	cQuery += "    SUM(round(CASE WHEN  (SC5.C5_XATE = '30' AND C5_XMATE = ' ' OR    SC5.C5_XATE = '31' AND C5_XMATE = ' ') OR  (SC5.C5_XATE = '30' AND C5_XMATE = '11' OR    SC5.C5_XATE = '31' AND C5_XMATE = '11')
	cQuery += "  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "MES",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE  <> '"+_cDat+"' And SC5.C5_XMATE  <> ' ' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	//cQuery += ' "TOTAL4",

	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(TC9.QUANT),2)),0) "REJEITADOS",
	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(BC9.QUANT),2)),0) "ANALISE",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	If _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat1+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL1",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	If _cDat = '11'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE))=   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	ElseIf _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL2",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	If _cDat = '10'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '11'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL3",


	If _cDat = '09'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"01'
	ElseIf _cDat = '10'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"02'
	ElseIf _cDat = '11'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"03'
	ElseIf _cDat = '12'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"04'
	Else
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '" + substr(dtos(date()),1,4)+_cDat4+"'
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL5"




	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
	cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)TC9
	cQuery += " ON  TC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND  TC9.C9_ITEM   = SC6.C6_ITEM
	cQuery += " AND TC9.C9_FILIAL = SC6.C6_FILIAL
	cQuery += " AND TC9.C9_BLCRED = '09'

	cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
	cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)BC9
	cQuery += " ON  BC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND  BC9.C9_ITEM   = SC6.C6_ITEM
	cQuery += " AND BC9.C9_FILIAL = SC6.C6_FILIAL
	cQuery += " AND (BC9.C9_BLCRED = '04' or BC9.C9_BLCRED = '01')
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
	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
	cQuery += " ON SA3.D_E_L_E_T_   = ' '
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND2
	cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '

	//cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')




	cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_EMISSAO  BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " AND PC1.PC1_PEDREP IS NULL

	cQuery += " GROUP BY SB1.B1_GRUPO ,SBM.BM_DESC

	cQuery += " ORDER  BY SB1.B1_GRUPO


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

