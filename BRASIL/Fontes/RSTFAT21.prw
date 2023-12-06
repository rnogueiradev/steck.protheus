#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT21     ºAutor  ³Giovani Zago    º Data ³  13/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Vendedor INterno   		                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Caso seja necessario alterar as regras deste relatorio	  º±±
±±			   Por favo alterar tambem no STGPE009.prw					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT21()

Local   oReport
Private cPerg 			:= "RFAT07"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.

PutSx1(cPerg, "01", "Da Data:"      ,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Data:"     ,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Vendedor:"  ,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C",6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C",6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Ordenar Por  :","Ordenar Por  :"	,"Ordenar Por   :"  ,"mv_ch5","C",10,0,0,"C","",''   ,'','',"mv_par05","Vendedor","","","","Valor Atual","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPerg,"RELATÓRIO Vendedor Interno",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Vendedor Interno")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Vendedor Interno",{"ZZI"})

TRCell():New(oSection,"Codigo"	  ,,"Codigo"	,,08,.F.,)
TRCell():New(oSection,"Nome"	  ,,"Nome"		,,40,.F.,)
TRCell():New(oSection,"Atual"     ,,"Atual"	    ,"@E 99,999,999.99",14)
TRCell():New(oSection,"Carteira"  ,,"Carteira"	,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("ZZI")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP9"
Local aDados[2]
Local aDados1[04]

oSection1:Cell("Codigo")    :SetBlock( { || aDados1[01] } )
oSection1:Cell("Nome")	:SetBlock( { || aDados1[02] } )
oSection1:Cell("Atual")	    :SetBlock( { || aDados1[03] } )
oSection1:Cell("Carteira")	:SetBlock( { || aDados1[04] } )

oReport:SetTitle("Faturamento Vend.Interno")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

rptstatus({|| strelquer( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0

	While 	(cAliasLif)->(!Eof())

		aDados1[01]	:=	(cAliasLif)->CODIGO
		aDados1[02]	:=	(cAliasLif)->NOME
		aDados1[03]	:=	(cAliasLif)->ATUAL
		aDados1[04]	:=	(cAliasLif)->(CARTEIRA-QTD_TOTAL)

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasLif)->(dbskip())

	End

EndIf

oReport:SkipLine()

Return oReport

//SELECIONA OS PRODUTOS
Static Function strelquer()
Local aAreaSM0   := SM0->(GETAREA())
Local cQuery     := ' '
Local cEmpresas  := ''
SetRegua(4)

	dbSelectArea("SM0")
	SM0->(dbGotop())
	While !SM0->(Eof())
		If Empty(SM0->M0_CGC)
			SM0->(dbSkip())
			Loop
		EndIf
        If len(cEmpresas)>1
			cEmpresas += "','"
		EndIf
		cEmpresas += AllTrim(SM0->M0_CGC)
		SM0->(dbSkip())
	End

	RestArea(aAreaSM0)

IncRegua(   )

IncRegua(   )


cQuery := " SELECT "
cQuery += " SA3.A3_COD"
cQuery += " AS CODIGO,"
cQuery += " SA3.A3_NOME"
cQuery += " AS NOME,"
cQuery += " SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END)"
cQuery += "	AS ATUAL,"
//cQuery += " SUM(CASE WHEN SA3.A3_COD = SF2.F2_VEND1  THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END)   "// giovani zago 13/01/2014
//cQuery += ' "CARTEIRA"

cQuery += " COALESCE("
cQuery += "    (SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL "
cQuery += "        FROM  "+RetSqlName("SF2")+" SF2"
cQuery += "        INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" ) SD2 ON"
cQuery += "        SD2.D_E_L_E_T_ <> '*'"
cQuery += "        AND SD2.D2_FILIAL = SF2.F2_FILIAL "
cQuery += "        AND SD2.D2_DOC = SF2.F2_DOC "
cQuery += "        AND SD2.D2_SERIE = SF2.F2_SERIE"
cQuery += "        AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')"
//cQuery += "        WHERE  SUBSTR(F2_EMISSAO,1,6) = '"+substr(dtos(_dRef),1,4)+"'"
cQuery += " 	   WHERE F2_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += "        AND SF2.D_E_L_E_T_ <> '*' "
cQuery += "        AND SF2.F2_VEND1 = SA3.A3_COD"
cQuery += "        AND EXISTS"
cQuery += "            (SELECT * FROM SC6010 SC6"
cQuery += "            WHERE  SC6.C6_NUM = SD2.D2_PEDIDO"
cQuery += "            AND SC6.C6_FILIAL = SD2.D2_FILIAL"
cQuery += "            AND SC6.D_E_L_E_T_ <> '*' )  ),0) AS CARTEIRA"

cQuery += " ,COALESCE((SELECT  COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) AS TOTAL  FROM  SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SB1010 )SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2010 ) SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL  WHERE  SD1.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SD1.D1_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' ),0) AS QTD_TOTAL

cQuery += " FROM "+RetSqlName("SF2")+" SF2 "

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1"
cQuery += " ON SA1.D_E_L_E_T_   <> '*'"
cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
cQuery += " AND SA1.A1_FILIAL = ' '
cQuery += " AND SA1.A1_CGC NOT IN  ('" + cEmpresas + "')

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
cQuery += " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
cQuery += " AND SA3.D_E_L_E_T_ <> '*' "
cQuery += " AND (SA3.A3_COD = SF2.F2_VEND1 "
cQuery += " OR   SA3.A3_COD = SF2.F2_VEND2)"
cQuery += " AND SA3.A3_TPVEND = 'I'"
cQuery += " WHERE F2_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
cQuery += " AND (SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " OR SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' )"
//cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"

cQuery += " AND EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2 "
cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO "
cQuery += " AND SF4.D_E_L_E_T_ <> '*' "
//cQuery += " AND SF4.F4_DUPLIC = 'S'
//cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')"

cQuery += " WHERE SD2.D2_DOC = SF2.F2_DOC"
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE"
cQuery += " AND SD2.D_E_L_E_T_ <>'*' "
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL )"

cQuery += " GROUP BY SA3.A3_COD ,"
cQuery += " SA3.A3_NOME "

If MV_PAR05 = 1
	cQuery += " ORDER BY SA3.A3_COD "
ElseIf MV_PAR05 = 2
	cQuery += " ORDER BY ATUAL"
EndIf

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

IncRegua()

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

IncRegua()

Return()