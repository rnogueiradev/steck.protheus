#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTEXP01     ºAutor  ³Giovani Zago    º Data ³  16/08/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Expedição                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTEXP01()

Local   oReport
Private cPerg 			:= "REXP01"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
 
PutSx1( cPerg, "01","Produto de:"			,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Produto até:"			,"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","Grupo de:"    			,"","","mv_ch3","C",4,0,0,"G","","SBM","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","Grupo Até:"   			,"","","mv_ch4","C",4,0,0,"G","","SBM","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "05","Tipo:"               	,"","","mv_ch5","N",1,0,2,"C","","","","","mv_par05","Bloqueados","","","","S/Custo","","","","","","","","","","","")
PutSx1( cPerg, "06","Ordena:"               ,"","","mv_ch6","N",1,0,2,"C","","","","","mv_par06","Produto","","","","Grupo","","","","","","","","","","","")
//PutSx1( cPerg, "06","Os Até:"       ,"","","mv_ch6","C",6,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
//PutSx1( cPerg, "07","Modalidade:"    ,"","","mv_ch7","N",1,0,2,"C","","","","","mv_par07","Faturamento","","","","Captação","","","","","","","","","","","")
oReport		:= ReportDef()
 oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPerg,"RELATÓRIO EXPEDIÇÃO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório EXPEDIÇÃO .")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Análise  Expedição"+iif(mv_par05=1,' - Bloqueados',' - S/Custo'),{"SC5"})

TRCell():New(oSection,"Produto"	    ,,"Produto"		,,15,.F.,)
TRCell():New(oSection,"Descrição"	,,"Descrição"	,,50,.F.,)
TRCell():New(oSection,"Grupo"		,,"Grupo"		,,04,.F.,)
TRCell():New(oSection,"Desc.Grupo"	,,"Desc.Grupo"	,,50,.F.,)  

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("DA1")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP9"
Local aDados[2]
Local aDados1[4]



oSection1:Cell("Produto")    	:SetBlock( { || aDados1[01] } )
oSection1:Cell("Descrição")		:SetBlock( { || aDados1[02] } )
oSection1:Cell("Grupo")			:SetBlock( { || aDados1[03] } )
oSection1:Cell("Desc.Grupo")	:SetBlock( { || aDados1[04] } )



oReport:SetTitle("Análise Expedição"+iif(mv_par05=1,' - Bloqueados',' - S/Custo'))// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()




rptstatus({|| strelquer( ) },"Compondo Relatorio")


dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->B1_COD
		aDados1[02]	:=	(cAliasLif)->B1_DESC
		aDados1[03]	:=	(cAliasLif)->B1_GRUPO
		aDados1[04]	:=	(cAliasLif)->BM_DESC
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
		(cAliasLif)->(dbskip())
		
	End
	
	
EndIf



oReport:SkipLine()




Return oReport


//SELECIONA OS PRODUTOS
Static Function strelquer()

Local cQuery     := ' '

cQuery := " SELECT B1_COD,B1_DESC, B1_GRUPO, BM_DESC
cQuery += " FROM "+RetSqlName("SB1")+" SB1 "

cQuery += " INNER JOIN (SELECT *
cQuery += " FROM "+RetSqlName("SBf")+" )SBf "
cQuery += " ON SBF.D_E_L_E_T_   = ' '
cQuery += " AND SBF.BF_LOCAL     = '03'
cQuery += " AND SBF.BF_QUANT > 0
cQuery += " AND SBF.BF_FILIAL  = '"+xFilial("SBF")+"'"
cQuery += " AND SBF.BF_PRODUTO = SB1.B1_COD
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
cQuery += " AND SBM.D_E_L_E_T_ = ' '
cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_LOCPAD = '03'
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND SB1.B1_COD   BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "

If MV_PAR05 = 1
	cQuery += " AND SB1.B1_MSBLQL = '1'
Else
	cQuery += " AND NVL((SELECT SUM(B2_CMFIM1)
	cQuery += " FROM   "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND   SB2.B2_COD   =  SB1.B1_COD
	cQuery += " AND   SB2.B2_LOCAL =  SB1.B1_LOCPAD
	cQuery += " AND   SB2.B2_FILIAL=  '"+xFilial("SB2")+"'"
	cQuery += " GROUP BY SB2.B2_LOCAL,SB2.B2_COD ),0) < = 0
EndIf
If MV_PAR06 = 1
	cQuery += " ORDER BY SB1.B1_COD
Else
	cQuery += " ORDER BY SB1.B1_GRUPO
EndIf
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


