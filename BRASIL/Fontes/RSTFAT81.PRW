#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT81     ºAutor  ³Renato Nogueira º Data ³  26/05/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de preços orçados em PC	                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT81()
*-----------------------------*          
Local   oReport
Private cPerg 			:= "RFAT81"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1( cPerg, "01","Data de?" 				,"","","mv_ch1","D",08,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Data ate?"				,"","","mv_ch2","D",08,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","PC de:"				,"","","mv_ch3","C",06,0,0,"G","","SC7" ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","PC até:"				,"","","mv_ch4","C",06,0,0,"G","","SC7" ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "05","Forn de:"				,"","","mv_ch5","C",06,0,0,"G","","SA2" ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "06","Forn até:"				,"","","mv_ch6","C",06,0,0,"G","","SA2" ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "07","Usuário De: ?"         ,"Usuário De: ?"            ,"Usuário De: ?"              ,"mv_ch7"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"USR" ,""     ,""   ,"mv_par07"    ,""                ,""      ,""      ,"      "             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1( cPerg, "08","Usuário Até: ?"        ,"Usuário Até: ?"           ,"Usuário Até: ?"             ,"mv_ch8"    ,"C"   ,06      ,0       ,0      ,"G" ,""    ,"USR" ,""     ,""   ,"mv_par08"    ,""                ,""      ,""      ,"ZZZZZZ"             ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ONE VOICE				                          º±±
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
Local oSection1
Local oSection2

oReport := TReport():New(cPergTit,"PEDIDO DE COMPRA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de pedidos de compras")

Pergunte(cPerg,.F.)

oSection  := TRSection():New(oReport,"PEDIDOS DE COMPRAS",{"SC7"})
oSection2 := TRSection():New(oReport,"PEDIDOS DE COMPRAS",{"SC7"})

TRCell():New(oSection,"FILIAL"		,,"FILIAL"									,,02,.F.,)
TRCell():New(oSection,"NUMERO"		,,"NUMERO"									,PesqPict("SC7","C7_NUM"),TamSX3("C7_NUM") [1]+4)
TRCell():New(oSection,"FORNECE"		,,"FORNECEDOR"								,,06,.F.,)
TRCell():New(oSection,"LOJA"		,,"LOJA"									,,02,.F.,)
TRCell():New(oSection,"NOMEFOR"		,,"NOME"									,,50,.F.,)
TRCell():New(oSection,"ITEM"		,,"ITEM"									,,04,.F.,)
TRCell():New(oSection,"PRODUTO"		,,"PRODUTO"									,,15,.F.,)
TRCell():New(oSection,"DESCRI"		,,"DESCRICAO"								,,50,.F.,)
TRCell():New(oSection,"QUANT"		,,"QUANTIDADE"								,"@E 99,999,999.99",14)
TRCell():New(oSection,"PRECO"		,,"PRECO"									,"@E 99,999,999.99",14)
TRCell():New(oSection,"ORCPRC"		,,"PRECO ORÇADO"							,"@E 99,999,999.99",14)
TRCell():New(oSection,"PORC"		,,"PORCENTAGEM"								,"@E 99,999,999.99",14)
TRCell():New(oSection,"DIF"			,,"DIFERENÇA"								,"@E 99,999,999.99",14)
TRCell():New(oSection,"TOTAL"		,,"TOTAL"									,"@E 99,999,999.99",14)
TRCell():New(oSection,"DIFTOT"		,,"DIF TOTAL"								,"@E 99,999,999.99",14)
TRCell():New(oSection,"USER"		,,"USUARIO"									,,50,.F.,)

TRCell():New(oSection2,"Total"	,,"Total"										,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC7")

oSection2:SetHeaderSection(.t.)
oSection2:Setnofilter("SC7")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Produtos em transito	                          º±±
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
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[99]
Local aDados2[1]
Local _nTotal	:= 0

oSection1:Cell("FILIAL") 			:SetBlock( { || aDados1[01] } )
oSection1:Cell("NUMERO") 			:SetBlock( { || aDados1[02] } )
oSection1:Cell("FORNECE") 			:SetBlock( { || aDados1[03] } )
oSection1:Cell("LOJA") 				:SetBlock( { || aDados1[04] } )
oSection1:Cell("NOMEFOR") 			:SetBlock( { || aDados1[05] } )
oSection1:Cell("ITEM")	 			:SetBlock( { || aDados1[06] } )
oSection1:Cell("PRODUTO") 			:SetBlock( { || aDados1[07] } )
oSection1:Cell("DESCRI")	 		:SetBlock( { || aDados1[08] } )
oSection1:Cell("QUANT")		 		:SetBlock( { || aDados1[09] } )
oSection1:Cell("PRECO")	 			:SetBlock( { || aDados1[10] } )
oSection1:Cell("ORCPRC")	 		:SetBlock( { || aDados1[11] } )
oSection1:Cell("TOTAL")	 			:SetBlock( { || aDados1[12] } )
oSection1:Cell("PORC")	 			:SetBlock( { || aDados1[13] } )
oSection1:Cell("DIF")	 			:SetBlock( { || aDados1[14] } )
oSection1:Cell("USER")	 			:SetBlock( { || aDados1[15] } )
oSection1:Cell("DIFTOT") 			:SetBlock( { || aDados1[16] } )

oSection2:Cell("Total")		:SetBlock( { || aDados2[01] } )

oReport:SetTitle("PEDIDO DE COMPRAS")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados1,nil)
aFill(aDados2,nil)
oSection1:Init()
oSection2:Init()

Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
	
	 	aDados1[01]	:=	(cAliasLif)->C7_FILIAL
		aDados1[02]	:= 	(cAliasLif)->C7_NUM
		aDados1[03]	:=  (cAliasLif)->C7_FORNECE
		aDados1[04]	:=  (cAliasLif)->C7_LOJA
		aDados1[05]	:=  (cAliasLif)->A2_NOME
		aDados1[06]	:=  (cAliasLif)->C7_ITEM
		aDados1[07]	:=  (cAliasLif)->C7_PRODUTO
		aDados1[08]	:=  (cAliasLif)->B1_DESC
		aDados1[09]	:=  (cAliasLif)->C7_QUANT
		aDados1[10]	:=  (cAliasLif)->C7_PRECO
		aDados1[11]	:=  (cAliasLif)->C7_XPRCORC
		aDados1[12]	:=  (cAliasLif)->C7_TOTAL
		aDados1[13]	:=  (cAliasLif)->PORC
		aDados1[14]	:=  (cAliasLif)->DIF
		aDados1[15]	:=  (cAliasLif)->C7_USER
		aDados1[16]	:=  (cAliasLif)->DIFTOT
		
		_nTotal		+= (cAliasLif)->DIFTOT

		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf

aDados2[01]	:= _nTotal

oReport:SkipLine()

oSection2:PrintLine()
aFill(aDados2,nil)

oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
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

cQuery := " SELECT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_ITEM, C7_PRODUTO, "
cQuery += " B1_DESC, C7_QUANT, C7_PRECO, C7_XPRCORC, 1-ROUND(C7_PRECO/C7_XPRCORC,2) PORC , C7_TOTAL , "
cQuery += " C7_USER, C7_XPRCORC-C7_PRECO DIF, C7_QUANT*(C7_XPRCORC-C7_PRECO) DIFTOT  "
cQuery += " FROM "+RetSqlName("SC7")+" C7 "
cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
cQuery += " ON B1_COD=C7_PRODUTO "
cQuery += " LEFT JOIN "+RetSqlName("SA2")+" A2 "
cQuery += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA "
cQuery += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' "
cQuery += " AND C7_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND C7_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND C7_FORNECE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND C7_USER BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
cQuery += " AND C7_XPRCORC>0 "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()