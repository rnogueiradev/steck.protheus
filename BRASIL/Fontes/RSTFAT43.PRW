#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  RSTFAT43     ºAutor  ³Giovani Zago    º Data ³  09/05/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio entradas no CD		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RSTFAT43()

Local   oReport
Private cPerg 			:= "RFAT43"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

PutSx1(cPerg, "01","Data?"			,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02","Data?"			,"","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Produto de?" 	,"","","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Produto ate?"	,"","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Grupo de?" 	,"","","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Gruupo ate?"	,"","","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "05", "Tipo "     ,"",""									,"mv_ch5","N",1,0,2,"C","","","","","mv_par05","Faturamento","","","","Captação","","","","","","","","","","","")

oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio entradas no CD		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELATÓRIO GRUPO DE CLIENTE",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Comissão")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Comissão",{"SC5"})

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio entradas no CD		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[10]

TRCell():New(oSection,"FORNECEDOR"	,,"FORNECEDOR"	,,9,.F.,)
TRCell():New(oSection,"NOME"  		,,"NOME"		,,25,.F.,)
TRCell():New(oSection,"PRODUTO"	  	,,"PRODUTO"		,,15,.F.,)
TRCell():New(oSection,"DESCRICAO"  	,,"DESCRICAO"	,,25,.F.,)
TRCell():New(oSection,"GRUPO"	  	,,"GRUPO"		,,4,.F.,)
TRCell():New(oSection,"AGRUPAMENTO" ,,"AGRUPAMENTO"	,,4,.F.,)
TRCell():New(oSection,"QUANTIDADE"  ,,"QUANTIDADE"	,"@E 99,999,999.99",14)
TRCell():New(oSection,"NF"  		,,"NF"			,,9,.F.,)
TRCell():New(oSection,"SERIE"	  	,,"SERIE"		,,3,.F.,)
TRCell():New(oSection,"DATA"  		,,"DATA"		,,10,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

oSection1:Cell("FORNECEDOR")    	:SetBlock( { || aDados1[01] } )
oSection1:Cell("NOME")  			:SetBlock( { || aDados1[02] } )
oSection1:Cell("PRODUTO")  			:SetBlock( { || aDados1[03] } )
oSection1:Cell("DESCRICAO")       	:SetBlock( { || aDados1[04] } )
oSection1:Cell("GRUPO")  			:SetBlock( { || aDados1[05] } )
oSection1:Cell("AGRUPAMENTO")  		:SetBlock( { || aDados1[06] } )
oSection1:Cell("QUANTIDADE")  		:SetBlock( { || aDados1[07] } )
oSection1:Cell("NF")  				:SetBlock( { || aDados1[08] } )
oSection1:Cell("SERIE")  			:SetBlock( { || aDados1[09] } )
oSection1:Cell("DATA")  			:SetBlock( { || aDados1[10] } )

oReport:SetTitle("GRUPO DE CLIENTE")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbGoTop() )
If  Select(cAliasLif) > 0
	While (cAliasLif)->( !Eof() )
		aDados1[01]	:=	(cAliasLif)->D1_FORNECE + "-" + (cAliasLif)->D1_LOJA
		aDados1[02]	:= 	(cAliasLif)->NOME
		aDados1[03]	:=  (cAliasLif)->D1_COD
		aDados1[04]	:= 	(cAliasLif)->B1_DESC
		aDados1[05]	:=  (cAliasLif)->B1_GRUPO
		aDados1[06]	:= 	(cAliasLif)->BM_XAGRUP
		aDados1[07]	:=  (cAliasLif)->D1_QUANT
		aDados1[08]	:= 	(cAliasLif)->D1_DOC
		aDados1[09]	:= 	(cAliasLif)->D1_SERIE
		aDados1[10]	:= 	(cAliasLif)->D1_DTDIGIT		
		oSection1:PrintLine()
		aFill(aDados1,Nil)
		(cAliasLif)->( dbskip() )
	End
EndIf

oReport:SkipLine()

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio entradas no CD		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function StQuery()

Local cQuery := ""

cQuery := " SELECT
cQuery += " D1_FORNECE,
cQuery += " D1_LOJA,
cQuery += " NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " 		WHERE SA2.D_E_L_E_T_ = ' '
cQuery += " 			AND D1_FORNECE = A2_COD
cQuery += " 			AND D1_LOJA = A2_LOJA),' ')
cQuery += '"NOME",

cQuery += " D1_COD,
cQuery += " B1_DESC,
cQuery += " B1_GRUPO,
cQuery += " BM_XAGRUP,
cQuery += " D1_QUANT,
cQuery += " D1_DOC,
cQuery += " D1_SERIE,
cQuery += " SUBSTR(SD1.D1_DTDIGIT,7,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,5,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,1,4)   
cQuery += ' "D1_DTDIGIT"
cQuery += " FROM "+ RetSqlName("SD1") + " SD1
cQuery += " INNER JOIN(SELECT * FROM " + RetSqlName("SB1") + " )SB1 "
cQuery += " ON SB1.D_E_L_E_T_ = ' '
cQuery += " 	AND SB1.B1_COD = SD1.D1_COD
cQuery += " INNER JOIN(SELECT * FROM " + RetSqlName("SBM") + " )SBM "
cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
cQuery += " 	AND SBM.D_E_L_E_T_ = ' '
cQuery += " 	AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' "
cQuery += " WHERE SD1.D_E_L_E_T_ = ' '
cQuery += " 	AND SD1.D1_FILIAL = '" + xFilial("SD1") + "' " // Solicitação fabio.brito 20/05/2014
cQuery += " 	AND SD1.D1_TIPO = 'N'
cQuery += " 	AND SD1.D1_DTDIGIT BETWEEN '" + Dtos(Mv_Par01) + "' AND '" + Dtos(Mv_Par02) + "' "
cQuery += " 	AND SD1.D1_COD BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' "
cQuery += " 	AND SD1.D1_GRUPO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->( dbCloseArea() )
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return
