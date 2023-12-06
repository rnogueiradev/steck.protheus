#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT19     ºAutor  ³Giovani Zago    º Data ³  02/12/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de VENDEDOR INTERNO(MARKETING)                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT19()

Local   oReport
Private cPerg 			:= "RFAT1X"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.




PutSx1(cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Vendedor:" ,"Do Vendedor: ?" ,"Do Vendedor: ?" 			   	,"mv_ch3","C",6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 			,"mv_ch4","C",6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"             ,"mv_ch5","C",10,0,3,"C","",'','','',"mv_par05"   ,"Valor Atual","","","Valor Atual","","","","","","","","","","")


oReport		:= ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPerg,"RELATÓRIO Faturamento Vend.Interno",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Faturamento Vend.Interno .")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Faturamento Vend.Interno",{"SF2"})

TRCell():New(oSection,"Codigo"	,,"Codigo"	,,06,.F.,)
TRCell():New(oSection,"Nome"	,,"Nome"		,,40,.F.,)
TRCell():New(oSection,"Vlr_Atual" ,,"Vlr_Atual"	,"@E 99,999,999.99",14)
TRCell():New(oSection,"Vlr_Carteira" ,,"Vlr_Carteira"	,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SF2")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP9"
Local aDados[2]
Local aDados1[4]
 


oSection1:Cell("Codigo")    :SetBlock( { || aDados1[01] } )
oSection1:Cell("Nome")		:SetBlock( { || aDados1[02] } )
oSection1:Cell("Vlr_Atual")	:SetBlock( { || aDados1[03] } )
oSection1:Cell("Vlr_Carteira")	:SetBlock( { || aDados1[04] } )


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
		aDados1[04]	:=	(cAliasLif)->CARTEIRA
	
	
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

 


cQuery := " SELECT 
cQuery += " SA3.A3_COD 
cQuery += ' "CODIGO",
cQuery += " SA3.A3_NOME 
cQuery += ' "NOME",
cQuery += " SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALMERC -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END) 
cQuery += ' "ATUAL",
cQuery += " SUM(CASE WHEN SF2.F2_VEND1 = SF2.F2_VEND2  THEN SF2.F2_VALMERC -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END) 
cQuery += ' "CARTEIRA"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "  

cQuery += " INNER JOIN(SELECT * FROM SA1010) SA1
cQuery += " ON SA1.D_E_L_E_T_   = ' '
cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
cQuery += " AND SA1.A1_FILIAL = ' ' 
cQuery += " AND SA1.A1_CGC NOT IN  ('" + cEmpresas + "')


cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
cQuery += " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
cQuery += " AND SA3.D_E_L_E_T_ = ' ' 
cQuery += " AND (SA3.A3_COD = SF2.F2_VEND1
cQuery += " OR   SA3.A3_COD = SF2.F2_VEND2)
cQuery += " AND SA3.A3_TPVEND = 'I'
cQuery += " WHERE F2_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SF2.D_E_L_E_T_ = ' ' 
cQuery += " AND (SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " OR SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' )" 
//cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"  

cQuery += " AND EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2 "
cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO 
cQuery += " AND SF4.D_E_L_E_T_ = ' '  
cQuery += " AND SF4.F4_DUPLIC = 'S'
cQuery += " WHERE SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D_E_L_E_T_ = ' ' 
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL )


cQuery += " GROUP BY SA3.A3_COD ,
cQuery += " SA3.A3_NOME 

If MV_PAR05 = 1
	cQuery += " Order by SA3.A3_COD "
ElseIf MV_PAR05 = 2
	cQuery += ' ORDER BY "ATUAL"
EndIf


cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


