#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT48     บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Produtos grupo 005 abner                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT48()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT48"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif
Private _cMes01 		:= mesextenso(Month(Date()))
Private _cMes02 		:= mesextenso(Month(Date())+1)
Private _cMes03 		:= mesextenso(Month(Date())+2)
Private _cMes04 		:= mesextenso(Month(Date())+3) 
Private _asb1  := {}
Private _cxMes01 		:=  cvaltochar(Year (Date()))+strzero(Month(Date()),2,0)
Private _cxMes02 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+1)+'01',cvaltochar(Year (Date()))+strzero(Month(Date())+1,2,0))
Private _cxMes03 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+2)+Iif(Month(Date()) = 12,'02','01'),cvaltochar(Year (Date()))+strzero(Month(Date())+2,2,0))
Private _cxMes04 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+3)+Iif(Month(Date()) = 12,'03',Iif(Month(Date()) = 11,'02','01')),cvaltochar(Year (Date()))+strzero(Month(Date())+3,2,0))


PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "05", "Tipo  :"			,"Tipo   :"			,"Tipo    :"        ,"mv_ch5","N", 1,0,0,"C","",''    ,'','',"mv_par05","Completo","","","","C/F","","","","","","","","","","")
PutSx1(cPerg, "05", "Emissao de:" 		,"Emissao de: ?" 		,"Emissao de: ?" 		,"mv_ch5","D",8,0,0,"G","",''    ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Emissao ate:" 		,"Emissao ate: ?" 		,"Emissao ate: ?" 		,"mv_ch6","D",8,0,0,"G","",''    ,"","","mv_par06","","","","","","","","","","","","","","","","")
  

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

oReport := TReport():New(cPergTit,"RELATำRIO Produtos  p/ Grupo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Produtos  p/ Grupo")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Produtos p/ Grupo",{"SC5"})


TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"		,,15,.F.,)
TRCell():New(oSection,"DESCRICAO"  			 ,,"DESCRICAO"	,,35,.F.,)
TRCell():New(oSection,"QUANT"     			 ,,"QUANTIDADE"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"CUSTO"     			 ,,"CUSTO"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"VALOR"     			 ,,"VALOR_D1"		,"@E 99,999,999.99",14)

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
Local aDados1[5]
Local _cSta 	:= ''


oSection1:Cell("CODIGO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("DESCRICAO")  			:SetBlock( { || aDados1[02] } )
oSection1:Cell("QUANT")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("CUSTO")       		:SetBlock( { || aDados1[04] } )
oSection1:Cell( "VALOR" )  				:SetBlock( { || aDados1[05] } )


oReport:SetTitle("Produtos brasikon")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:=	(cAliasLif)->B1_COD
		aDados1[02]	:= 	(cAliasLif)->B1_DESC
		aDados1[03]	:=  (cAliasLif)->QUANT-(cAliasLif)->DEV
		aDados1[04]	:= U_STCUSTO(aDados1[01])
		aDados1[05]	:=  U_STRETSST('01',GetMv("ST_CLIPAD",,'094320') , 'SP',aDados1[01],'501','PRECO') 
	       

		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
		
		(cAliasLif)->(dbskip())
		
	End
	
	
	
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
Static Function StQuery()
*-----------------------------*

Local cQuery     := ' '


cQuery := "  SELECT  
cQuery += "      SB1.B1_COD, SB1.B1_DESC,
cQuery += " 	 ((SELECT
cQuery += " 	 NVL(SUM(SD2.D2_QUANT)	,0)
cQuery += " 	 FROM "+RetSqlName("SD2")+" SD2 "
cQuery += " 	 INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " 	 ON SA1.D_E_L_E_T_ = ' '
cQuery += " 	 AND SA1.A1_COD  = SD2.D2_CLIENTE
cQuery += " 	 AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " 	 AND SA1.A1_FILIAL = ' '
cQuery += " 	 AND SA1.A1_GRPVEN <> 'ST' 
cQuery += " 	 AND SA1.A1_GRPVEN <> 'SC'
cQuery += " 	 AND SA1.A1_EST    <> 'EX'
cQuery += " 	 WHERE SD2.D_E_L_E_T_ = ' '
cQuery += " 	 AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += " 	 AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_COD = SB1.B1_COD
cQuery += " AND   SD2.D2_EMISSAO  BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'   )) as 
cQuery += ' "QUANT"
cQuery += " ,
cQuery += " (SELECT NVL(SUM(D1_QUANT),0) 
cQuery += ' "TOTAL" 
cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D'
cQuery += " 	 AND SA1.A1_GRPVEN <> 'ST' 
cQuery += " 	 AND SA1.A1_GRPVEN <> 'SC'
cQuery += " 	 AND SA1.A1_EST    <> 'EX'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  '  
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' ' 
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') 
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') 
cQuery += " AND SD1.D1_COD = SB1.B1_COD 
cQuery += " AND  SD1.D1_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"')
cQuery += ' AS "DEV" 
cQuery += " FROM "+RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
   
_cMes01:=cQuery
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

