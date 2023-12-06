#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTFAT45	ºAutor  ³Renato Nogueira     º Data ³  04/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para imprimir informações dos po's      º±±
±±º          ³														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT45()

Local   oReport
Private cPerg 			:= "RFAT45"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

//PutSx1(cPerg, "01", "Emissao de:" 		,"Emissao de: ?" 		,"Emissao de: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "02", "Emissao ate:" 		,"Emissao ate: ?" 		,"Emissao ate: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")

oReport:=ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"Relatório de pos","",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de pos")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"POs",{"SW3"})

TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"			,"@!"					,2 ,.F.,)
TRCell():New(oSection,"FORN"	  			 ,,"FORNECEDOR"		,"@!"					,6 ,.F.,)
TRCell():New(oSection,"PO"		  			 ,,"PO"				,"@!"					,15,.F.,)
TRCell():New(oSection,"PODT"			 	 ,,"DATA PO"		,"@!"					,10,.F.,)
TRCell():New(oSection,"COD"  			 	 ,,"CODIGO"			,"@!"					,15,.F.,)
TRCell():New(oSection,"POQTDE" 			 	 ,,"QTDE PO"		,"@E 999,999,999.999"	,13,.F.,)
TRCell():New(oSection,"PRECPO" 			 	 ,,"PRECO PO"		,"@E 999,999,999.99999"	,15,.F.,)
TRCell():New(oSection,"TOTALPO"			 	 ,,"TOTAL PO"		,"@E 999,999,999.99999"	,15,.F.,)
TRCell():New(oSection,"FATFDT"			 	 ,,"DATA FAT FORN"	,"@!"					,10,.F.,)
TRCell():New(oSection,"FATQTDE" 			 ,,"QTDE FAT"		,"@E 999,999,999.999"	,13,.F.,)
TRCell():New(oSection,"TOTALFAT"			 ,,"TOTAL FAT"		,"@E 999,999,999.99999"	,15,.F.,)
TRCell():New(oSection,"NFPRDT"			 	 ,,"DATA NF PRI"	,"@!"					,10,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SW3")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrinºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[12]

oSection1:Cell("FILIAL")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("FORN")	    			:SetBlock( { || aDados1[02] } )
oSection1:Cell("PO")  					:SetBlock( { || aDados1[03] } )
oSection1:Cell("PODT") 					:SetBlock( { || aDados1[04] } )
oSection1:Cell("COD")  					:SetBlock( { || aDados1[05] } )
oSection1:Cell("POQTDE")  				:SetBlock( { || aDados1[06] } )
oSection1:Cell("PRECPO")  				:SetBlock( { || aDados1[07] } )
oSection1:Cell("TOTALPO")  				:SetBlock( { || aDados1[08] } )
oSection1:Cell("FATFDT")  				:SetBlock( { || aDados1[09] } )
oSection1:Cell("FATQTDE")  				:SetBlock( { || aDados1[10] } )
oSection1:Cell("TOTALFAT")  			:SetBlock( { || aDados1[11] } )
oSection1:Cell("NFPRDT")  				:SetBlock( { || aDados1[12] } )

oReport:SetTitle("POS")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection1:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())

If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		DbSelectArea("SF1")
		SF1->(DbGoTop())
		SF1->(DbSetOrder(5)) //F1_FILIAL+F1_HAWB+F1_TIPO_NF+F1_DOC+F1_SERIE
		SF1->(DbSeek((cAliasLif)->(FILIAL+HAWB)))
		
		aDados1[01]	:=	(cAliasLif)->FILIAL
		aDados1[02]	:=	(cAliasLif)->FORNECEDOR
		aDados1[03]	:=	(cAliasLif)->PO
		aDados1[04] :=  STOD((cAliasLif)->DATAPO)
		aDados1[05]	:=	(cAliasLif)->CODIGO
		aDados1[06]	:=	(cAliasLif)->QTDE
		aDados1[07]	:=	(cAliasLif)->PRECO
		aDados1[08]	:=	(cAliasLif)->TOTAL
		aDados1[09]	:=	STOD((cAliasLif)->DTFATFORN)
		aDados1[10]	:=	(cAliasLif)->QTDEFAT
		aDados1[11]	:=	(cAliasLif)->TOTALFAT
		If SF1->(!Eof())
			aDados1[12]	:=	SF1->F1_EMISSAO
		Else
			aDados1[12]	:=	""
		EndIf
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		(cAliasLif)->(dbskip())
		
	End
	
EndIf

oReport:SkipLine()

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StQuery	ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function StQuery()

Local cQuery     := ' '

cQuery := " SELECT W3_FILIAL FILIAL, W3_FORN FORNECEDOR, W3_PO_NUM PO, W3_COD_I CODIGO, SUM(W3_QTDE) QTDE, SUM(W3_PRECO) PRECO, (SUM(W3_QTDE)*SUM(W3_PRECO)) TOTAL, "
cQuery += " (SELECT NVL(MAX(W6_XDTFFOR),'') FROM "+RetSqlName("SW6")+" W6 WHERE W6.D_E_L_E_T_=' ' AND W6.W6_PO_NUM=W3.W3_PO_NUM) DTFATFORN, "
cQuery += " (SELECT NVL(SUM(W8_QTDE),0) FROM "+RetSqlName("SW8")+" W8 WHERE W8.D_E_L_E_T_=' ' AND W8.W8_PO_NUM=W3.W3_PO_NUM AND W8.W8_COD_I=W3.W3_COD_I) QTDEFAT, "
cQuery += " (SELECT NVL((SUM(W8_QTDE)*SUM(W8_PRECO)),0) FROM "+RetSqlName("SW8")+" W8 WHERE W8.D_E_L_E_T_=' ' AND W8.W8_PO_NUM=W3.W3_PO_NUM AND W8.W8_COD_I=W3.W3_COD_I) TOTALFAT, "
cQuery += " (SELECT W2_PO_DT FROM "+RetSqlName("SW2")+" W2 WHERE W2.W2_FILIAL=W3.W3_FILIAL AND W2.W2_PO_NUM=W3.W3_PO_NUM AND W2.D_E_L_E_T_=' ') DATAPO,
cQuery += " (SELECT NVL(MAX(W8_HAWB),'') FROM "+RetSqlName("SW8")+" W8 WHERE W8.D_E_L_E_T_=' ' AND W8.W8_PO_NUM=W3.W3_PO_NUM AND W8.W8_COD_I=W3.W3_COD_I) HAWB "
cQuery += " FROM "+RetSqlName("SW3")+" W3 "
cQuery += " WHERE W3.D_E_L_E_T_=' ' AND W3_SEQ=0 "
cQuery += " GROUP BY W3_FILIAL, W3_FORN, W3_PO_NUM, W3_COD_I "
cQuery += " ORDER BY W3_FILIAL, W3_FORN, W3_PO_NUM, W3_COD_I "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()