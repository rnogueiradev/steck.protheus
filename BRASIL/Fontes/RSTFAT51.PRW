#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT51     บAutor  ณGiovani Zago    บ Data ณ  18/08/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Gerencial da Carteira	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT51()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT51"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif  
Private _lDtGrp         := Iif (ddatabase >= Stod('20140819'),.T.,.F.)


PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Do Pedido:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch5","C", 6,0,0,"G","",'SC5' ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Ate Pedido:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch6","C", 6,0,0,"G","",'SC5' ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "Da Emissใo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch7","D", 8,0,0,"G","",'' ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate Emissใo:"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch8","D", 8,0,0,"G","",'' ,"","","mv_par08","","","","","","","","","","","","","","","","")
  

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELATำRIO Gerencial da Carteira",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio Gerencial da Carteira")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Gerencial da Carteira",{"SC5"})


TRCell():New(oSection,"PEDIDO"	  			 ,,"PEDIDO"		,,06,.F.,)
TRCell():New(oSection,"EMISSAO"  			 ,,"EMISSAO"	,,10,.F.,)
TRCell():New(oSection,"PRODUTO"	  			 ,,"PRODUTO"	,,15,.F.,)
TRCell():New(oSection,"DESCRI"  			 ,,"DESCRICAO"	,,35,.F.,)
TRCell():New(oSection,"QUANTIDADE" 			 ,,"QUANTIDADE"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"VALOR"     			 ,,"VALOR"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"GRUPO"	  			 ,,"GRUPO"		,,05,.F.,)
TRCell():New(oSection,"DES_GRUPO"  			 ,,"DES_GRUPO"	,,35,.F.,)
TRCell():New(oSection,"DTGRP"  			 	 ,,"DT_GRUPO"	,,10,.F.,) 
TRCell():New(oSection,"TP_OPER"	  			 ,,"TP_OPER"	,,02,.F.,)
TRCell():New(oSection,"OPER"  			 	 ,,"DESC_OPER"	,,35,.F.,)
TRCell():New(oSection,"FINANCEIRO"	  		 ,,"FINANCEIRO"		,,05,.F.,)
 

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Produtos em transito	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local _cSta 	:= ''
 
 

oSection1:Cell("PEDIDO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("EMISSAO")  				:SetBlock( { || aDados1[02] } )
oSection1:Cell("PRODUTO")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("DESCRI")       			:SetBlock( { || aDados1[04] } )
oSection1:Cell( "QUANTIDADE" )  		:SetBlock( { || aDados1[05] } )
oSection1:Cell("VALOR")    				:SetBlock( { || aDados1[06] } )
oSection1:Cell("GRUPO")  				:SetBlock( { || aDados1[07] } )
oSection1:Cell("DES_GRUPO")  			:SetBlock( { || aDados1[08] } )
oSection1:Cell("DTGRP")       			:SetBlock( { || aDados1[09] } )
oSection1:Cell( "TP_OPER" )  			:SetBlock( { || aDados1[10] } )
oSection1:Cell("OPER")       			:SetBlock( { || aDados1[11] } )
oSection1:Cell( "FINANCEIRO" )  		:SetBlock( { || aDados1[12] } )    

oReport:SetTitle("Produtos brasikon")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()
 

Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:=	(cAliasLif)->PEDIDO
		aDados1[02]	:= 	(cAliasLif)->EMISSAO
		aDados1[03]	:=  (cAliasLif)->PRODUTO
		aDados1[04]	:=  (cAliasLif)->DESCRI
		aDados1[05]	:=  (cAliasLif)->QUANTIDADE 
	    aDados1[06]	:=	(cAliasLif)->VALOR
		aDados1[07]	:= 	(cAliasLif)->GRUPO
		aDados1[08]	:=  (cAliasLif)->DES_GRUPO  
		aDados1[09]	:=  Iif(_lDtGrp ,(cAliasLif)->DT_UNI  , ' ') 
		aDados1[10]	:=  (cAliasLif)->TP_OPER
		aDados1[11]	:=	(cAliasLif)->OPER
		aDados1[12]	:= 	(cAliasLif)->FINANCEIRO

 
 	oSection1:PrintLine()
		aFill(aDados1,nil)
	 	(cAliasLif)->(dbskip())
 	End
	 	(cAliasLif)->(dbCloseArea())	
 EndIf
 oReport:SkipLine()
 Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '

  
cQuery := "  SELECT 
cQuery += " SC5.C5_NUM 
cQuery += ' "PEDIDO",
cQuery += " SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) 
cQuery += ' "EMISSAO",
cQuery += " SC6.C6_PRODUTO 
cQuery += ' "PRODUTO",  
If _lDtGrp
cQuery += "  SUBSTR( SB1.B1_XDTUNIC ,7,2)||'/'|| SUBSTR( SB1.B1_XDTUNIC ,5,2)||'/'|| SUBSTR( SB1.B1_XDTUNIC ,1,4)  
cQuery += ' "DT_UNI",
EndIf
cQuery += " SB1.B1_DESC 
cQuery += ' "DESCRI",
cQuery += " SC6.C6_QTDVEN - SC6.C6_QTDENT 
cQuery += ' "QUANTIDADE",
cQuery += " round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2) 
cQuery += ' "VALOR",
cQuery += " SB1.B1_GRUPO 
cQuery += ' "GRUPO",
cQuery += " SBM.BM_DESC 
cQuery += ' "DES_GRUPO",
cQuery += " SC6.C6_OPER 
cQuery += ' "TP_OPER",
cQuery += " SX5.X5_DESCRI 
cQuery += ' "OPER",
cQuery += " CASE WHEN SC9.C9_BLCRED = ' ' THEN 'LIBERADO' ELSE CASE WHEN TC9.C9_BLCRED = '09' THEN 'REJEITADO'  ELSE CASE WHEN BC9.C9_BLCRED = '01' THEN 'ANALISE' ELSE 'VERIFICAR' END END END AS 
cQuery += ' "FINANCEIRO"


cQuery += " FROM SC6010 SC6

cQuery += " LEFT JOIN(SELECT * FROM  "+RetSqlName("SC9")+") SC9 "
cQuery += " ON SC9.D_E_L_E_T_ = ' ' 
cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL 
cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
cQuery += " AND SC9.C9_ITEM = SC6.C6_ITEM
cQuery += " AND SC9.C9_BLCRED <> '10' 
cQuery += " AND SC9.C9_BLCRED = ' ' 

cQuery += " LEFT JOIN(SELECT * FROM  "+RetSqlName("SC9")+") TC9 "
cQuery += " ON TC9.D_E_L_E_T_ = ' ' 
cQuery += " AND TC9.C9_FILIAL = SC6.C6_FILIAL 
cQuery += " AND TC9.C9_PEDIDO = SC6.C6_NUM
cQuery += " AND TC9.C9_ITEM = SC6.C6_ITEM
cQuery += " AND TC9.C9_BLCRED <> '10' 
cQuery += " AND TC9.C9_BLCRED = '09' 

cQuery += " LEFT JOIN(SELECT * FROM  "+RetSqlName("SC9")+") BC9 "
cQuery += " ON BC9.D_E_L_E_T_ = ' ' 
cQuery += " AND BC9.C9_FILIAL = SC6.C6_FILIAL 
cQuery += " AND BC9.C9_PEDIDO = SC6.C6_NUM
cQuery += " AND BC9.C9_ITEM = SC6.C6_ITEM
cQuery += " AND BC9.C9_BLCRED <> '10' 
cQuery += " AND BC9.C9_BLCRED = '01' 

cQuery += "  INNER JOIN(SELECT * FROM  "+RetSqlName("SC5")+") SC5 "
cQuery += " ON SC5.D_E_L_E_T_ = ' '
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL  




cQuery += " 	 INNER JOIN(SELECT * FROM  "+RetSqlName("SA1")+") SA1 "
cQuery += " 	 ON SA1.D_E_L_E_T_ = ' '
cQuery += " 	 AND SA1.A1_COD  = SC6.C6_CLI
cQuery += " 	 AND SA1.A1_LOJA = SC6.C6_LOJA
cQuery += " 	 AND SA1.A1_FILIAL = ' '
cQuery += " 	 AND SA1.A1_GRPVEN <> 'ST' 
cQuery += " 	 AND SA1.A1_GRPVEN <> 'SC'
cQuery += " 	 AND SA1.A1_EST    <> 'EX'

cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SB1")+") SB1 "
cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
cQuery += " AND SB1.B1_COD = SC6.C6_PRODUTO

cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SBM")+") SBM "
cQuery += " ON SBM.D_E_L_E_T_ = ' ' 
cQuery += " AND SB1.B1_GRUPO = SBM.BM_GRUPO
cQuery += " AND SBM.BM_XAGRUP <> ' '  

cQuery += " INNER JOIN( SELECT * FROM  "+RetSqlName("SX5")+") SX5 "
cQuery += " ON SX5.D_E_L_E_T_ = ' ' 
cQuery += " AND SX5.X5_TABELA = 'DJ'
cQuery += " AND SX5.X5_CHAVE = SC6.C6_OPER

cQuery += " LEFT JOIN (SELECT * FROM  "+RetSqlName("PC1")+") PC1 "
cQuery += " ON C6_NUM = PC1.PC1_PEDREP
cQuery += "  AND PC1.D_E_L_E_T_ = ' '




cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' 
cQuery += " AND SC6.C6_CF  IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SC6.C6_FILIAL = '02'
cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
cQuery += " AND SC6.C6_BLQ <> 'R'
cQuery += "  AND PC1.PC1_PEDREP IS NULL
cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
cQuery += " AND SC5.C5_TIPO = 'N'  
cQuery += " AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
 cQuery += " AND SC5.C5_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
 cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'


 
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

