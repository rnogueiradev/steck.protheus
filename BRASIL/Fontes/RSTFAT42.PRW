#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  RSTFAT42    ∫Autor  ≥Giovani Zago    ∫ Data ≥  23/04/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Anual vendedor		                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*-----------------------------*
User Function RSTFAT42()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT42"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private cPergTit 		:= cAliasLif
Private _aMes           := {}
Private j 				:= 0

/*
For l:=1 To YEAR(Date())-2010

Aadd(_aMes,{STR(YEAR(Date()),4,0)+STRzero(Month(Date())-(Month(Date())-1)+l-1,2,0),mesextenso(Month(Date())-(Month(Date())-1)+l-1),'Qtd_'+substr(mesextenso(Month(Date())-(Month(Date())-1)+l-1),  1,3)  })

Next l
*/
PutSx1(cPerg, "01", "Do vendedor:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C", 6,0,0,"G","",'SA3'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate vendedor:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C", 6,0,0,"G","",'SA3'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Supervisor:" 	,"Supervisor: ?" 	,"Supervisor: ?" 	,"mv_ch3","C", 6,0,0,"G","",'SA3'    ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Supervisor:"  	,"Ate Supervisor: ?","Ate Supervisor: ?","mv_ch4","C", 6,0,0,"G","",'SA3'    ,"","","mv_par04","","","","","","","","","","","","","","","","")


oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ReportDef    ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio COMISSAO				                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELAT”RIO Anual Vendedor",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir um relatÛrio Anual vendedor")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Anual Vendedor",{"SF2"})


TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"	,,6,.F.,)
TRCell():New(oSection,"NOME"  			     ,,"NOME",,30,.F.,)
TRCell():New(oSection,"SUPERVISOR"  		 ,,"SUPERVISOR",,30,.F.,) 
TRCell():New(oSection,"REGIAO"  		     ,,"REGIAO",,30,.F.,)
TRCell():New(oSection,'2010'  				 ,,'2010'	,"@E 99,999,999.99",14)
TRCell():New(oSection,'2011'  				 ,,'2011'	,"@E 99,999,999.99",14)
TRCell():New(oSection,'2012'  				 ,,'2012'	,"@E 99,999,999.99",14)
TRCell():New(oSection,'2013'  				 ,,'2013'	,"@E 99,999,999.99",14)
TRCell():New(oSection,'2014'  				 ,,'2014'	,"@E 99,999,999.99",14)



oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

Return oReport
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ReportPrint  ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Produtos em transito	                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[26]
Local k :=0
Local _aResu := {}
Private _aResMe := {}


oSection1:Cell("CODIGO")    		:SetBlock( { || aDados1[01] } )
oSection1:Cell("NOME")  			:SetBlock( { || aDados1[02] } )
oSection1:Cell('2010')    			:SetBlock( { || aDados1[03] } )
oSection1:Cell('2011')  			:SetBlock( { || aDados1[04] } )
oSection1:Cell('2012')    			:SetBlock( { || aDados1[05] } )
oSection1:Cell('2013')  			:SetBlock( { || aDados1[06] } )
oSection1:Cell('2014')    			:SetBlock( { || aDados1[07] } ) 
oSection1:Cell("SUPERVISOR")  		:SetBlock( { || aDados1[08] } ) 
oSection1:Cell("REGIAO")  		    :SetBlock( { || aDados1[09] } )  
 
oReport:SetTitle("Anual vendedor")// Titulo do relatÛrio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aadd(_aResu,(cAliasLif)->A3_COD)
		aadd(_aResu,(cAliasLif)->A3_NOME) 
		aadd(_aResu,(cAliasLif)->A10-(cAliasLif)->DEV10)
		aadd(_aResu,(cAliasLif)->A11-(cAliasLif)->DEV11)
		aadd(_aResu,(cAliasLif)->A12-(cAliasLif)->DEV12)
		aadd(_aResu,(cAliasLif)->A13-(cAliasLif)->DEV13)
		aadd(_aResu,(cAliasLif)->A14-(cAliasLif)->DEV14)
		aadd(_aResu,(cAliasLif)->A3_SUPER)
		aadd(_aResu,(cAliasLif)->REGIAO)
		/*
		For j:= 1  To Len(_aMes)
		aadd(_aResu, &("(cAliasLif)->"+_aMes[j,2]))
		aadd(_aResu, &("(cAliasLif)->"+_aMes[j,3]))
		Next j
		*/
		
		
		aDados1:=Aclone(_aResu)
		_aResu:={}
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
		
		(cAliasLif)->(dbskip())
		
	End
	
	
	
EndIf



oReport:SkipLine()




Return oReport


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  StQuery      ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Anual Vendedor		                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

Local cQuery     := ' '



cQuery := " SELECT
cQuery += " SA3.A3_COD,
cQuery += " SA3.A3_SUPER, 
cQuery += " CASE WHEN SA3.A3_XREGIAO = '1' THEN 'SUL' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '2' THEN 'SUDESTE' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '3' THEN 'NORTE' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '4' THEN 'NORDESTE' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '5' THEN 'CENTRO-OESTE' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '6' THEN 'CAPITAL' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '7' THEN 'CAPITAL-ENGENHARIA' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '8' THEN 'SP INTERIOR/LITORAL' ELSE
cQuery += " CASE WHEN SA3.A3_XREGIAO = '9' THEN 'GERENCIA' ELSE ' '
cQuery += " END END END END END END END END END 
cQuery += 'AS "REGIAO",

cQuery += " SA3.A3_NOME,(SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
cQuery += "  FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
cQuery += " AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += " AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_EMISSAO BETWEEN '20100101' AND '20101231' )
cQuery += ' "A10"
cQuery += " ,
            
cQuery += " (SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += "  FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = D1_NFORI
cQuery += " AND SF2.F2_SERIE = D1_SERIORI
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')  AND SD1.D1_DTDIGIT BETWEEN '20100101' AND '20101231' )
cQuery += '  "DEV10"
cQuery += " ,
cQuery += " (SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
cQuery += " FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
cQuery += "  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
cQuery += "  AND SA1.A1_EST <> 'EX'
cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_EMISSAO BETWEEN '20110101' AND '20111231' )
cQuery += '  "A11"
cQuery += " ,
            
cQuery += " (SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += "  FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = D1_NFORI
cQuery += " AND SF2.F2_SERIE = D1_SERIORI
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')  AND SD1.D1_DTDIGIT BETWEEN '20110101' AND '20111231' )
cQuery += '  "DEV11"
cQuery += " ,
cQuery += " (SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
cQuery += "  FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
cQuery += "  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
cQuery += "  AND SA1.A1_EST <> 'EX'
cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_EMISSAO BETWEEN '20120101' AND '20121231' )
cQuery += '  "A12"
cQuery += " ,
            
cQuery += " (SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += "  FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = D1_NFORI
cQuery += " AND SF2.F2_SERIE = D1_SERIORI
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')  AND SD1.D1_DTDIGIT BETWEEN '20120101' AND '20121231' )
cQuery += '  "DEV12"
cQuery += " ,
cQuery += " (SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
cQuery += "  FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
cQuery += "  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
cQuery += "  AND SA1.A1_EST <> 'EX'
cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_EMISSAO BETWEEN '20130101' AND '20131231' )
cQuery += '  "A13"
cQuery += " ,
            
cQuery += " (SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += "  FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = D1_NFORI
cQuery += " AND SF2.F2_SERIE = D1_SERIORI
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')  AND SD1.D1_DTDIGIT BETWEEN '20130101' AND '20131231' )
cQuery += '  "DEV13"
cQuery += " ,
cQuery += " (SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
cQuery += "  FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
cQuery += "  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
cQuery += "  AND SA1.A1_EST <> 'EX'
cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " AND SD2.D2_EMISSAO BETWEEN '20140101' AND '20141231' )
cQuery += '  "A14"
cQuery += " ,
            
cQuery += " (SELECT nvl(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += "  FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " INNER JOIN(SELECT * FROM SF2010 ) SF2
cQuery += " ON SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_DOC = D1_NFORI
cQuery += " AND SF2.F2_SERIE = D1_SERIORI
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_COD = SF2.F2_VEND1
//cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')  AND SD1.D1_DTDIGIT BETWEEN '20140101' AND '20141231' )
cQuery += ' "DEV14"


cQuery += " FROM SA3010 SA3
cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
//cQuery += " AND (SA3.A3_TPVEND ='E' OR SA3.A3_TPVEND ='R')
cQuery += " AND SA3.A3_COD BETWEEN '"+MV_PAR01+"'  AND  '"+MV_PAR02+"' 
//If !Empty(Alltrim(MV_PAR03))
cQuery += " AND SA3.A3_SUPER  BETWEEN '"+MV_PAR03+"'  AND  '"+MV_PAR04+"' 
 //EndIf
cQuery += " GROUP BY SA3.A3_COD,SA3.A3_NOME,SA3.A3_SUPER,SA3.A3_XREGIAO
   /*
SELECT 
sf2.F2_VEND1 
"A3_COD",
COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM),0) "A10",
NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA
AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' 
 AND SA1.A1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2010 )  DF2 ON DF2.D_E_L_E_T_ = ' ' AND DF2.F2_DOC = D1_NFORI AND DF2.F2_SERIE = D1_SERIORI AND DF2.F2_FILIAL = SD1.D1_FILIAL  WHERE  SD1.D_E_L_E_T_ = ' ' 
AND  DF2.F2_VEND1 = SF2.F2_VEND1 
AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') 
AND SD1.D1_DTDIGIT BETWEEN '20100101' AND '20101231' ),0) "DEV10"
FROM SD2010 SD2 
INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2010 )  SF2 
ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') 
AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX' AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') 
AND SD2.D2_EMISSAO BETWEEN '20100101' AND '20101231'

GROUP BY sf2.F2_VEND1
ORDER BY sf2.F2_VEND1

    */




cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

