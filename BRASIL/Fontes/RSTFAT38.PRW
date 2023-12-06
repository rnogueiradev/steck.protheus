#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT38    บAutor  ณGiovani Zago    บ Data ณ  23/04/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Pedidos cif/fob		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT38()
*-----------------------------*
Local   oReport
Local j 				:= 0
Local l 				:= 0
Private cPerg 			:= "RFAT38"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private cPergTit 		:= cAliasLif
Private _aMes           := {}   
Private j 				:= 0
Private l 				:= 0

For l:=1 To Month(Date())
	
	Aadd(_aMes,{STR(YEAR(Date()),4,0)+STRzero(Month(Date())-(Month(Date())-1)+l-1,2,0),mesextenso(Month(Date())-(Month(Date())-1)+l-1),'Qtd_'+substr(mesextenso(Month(Date())-(Month(Date())-1)+l-1),  1,3)  })
	
Next l
//PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "03", "Do Grupo:" 		    ,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")


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
Local j:= 0 
oReport := TReport():New(cPergTit,"RELATำRIO Produtos especificos",'',{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Produtos especificos")

//Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Produtos especificos",{"SC5"})


TRCell():New(oSection,"PRODUTO"	  			 ,,"PRODUTO"	,,15,.F.,)
TRCell():New(oSection,"DESCRICAO"  			 ,,"DESCRICAO",,30,.F.,)

For j:= 1  To Len(_aMes)
	
	TRCell():New(oSection,_aMes[j,2]  				 ,,_aMes[j,2]	,"@E 99,999,999.99",14)
	TRCell():New(oSection,_aMes[j,3]  				 ,,_aMes[j,3]	,"@E 99,999,999.99",14)
	
Next j

TRCell():New(oSection,"SLD03"	  			 ,,"SALDO 03"		 ,"@E 99,999,999,999.99",14,.F.,)
TRCell():New(oSection,"SLD10"	  			 ,,"SALDO RETRABALHO","@E 99,999,999,999.99",14,.F.,)

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
Local aDados[2]
Local aDados1[26] 
Local k :=0    
Local j :=0   
Local _aResu := {}
Private _aResMe := {}


oSection1:Cell("PRODUTO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("DESCRICAO")  			:SetBlock( { || aDados1[02] } )  


oSection1:Cell(_aMes[1,2])    			:SetBlock( { || aDados1[03] } )
oSection1:Cell(_aMes[1,3])  			:SetBlock( { || aDados1[04] } )

If Len(_aMes)>1
 oSection1:Cell(_aMes[2,2])    			:SetBlock( { || aDados1[05] } )
oSection1:Cell(_aMes[2,3])  			:SetBlock( { || aDados1[06] } )
EndIf
If Len(_aMes)>2
 oSection1:Cell(_aMes[3,2])    			:SetBlock( { || aDados1[07] } )
oSection1:Cell(_aMes[3,3])  			:SetBlock( { || aDados1[08] } )
EndIf
If Len(_aMes)>3
 oSection1:Cell(_aMes[4,2])    			:SetBlock( { || aDados1[09] } )
oSection1:Cell(_aMes[4,3])  			:SetBlock( { || aDados1[10] } )
EndIf
If Len(_aMes)>4
 oSection1:Cell(_aMes[5,2])    			:SetBlock( { || aDados1[11] } )
oSection1:Cell(_aMes[5,3])  			:SetBlock( { || aDados1[12] } )
EndIf
If Len(_aMes)>5                                                  
 oSection1:Cell(_aMes[6,2])    			:SetBlock( { || aDados1[13] } )
oSection1:Cell(_aMes[6,3])  			:SetBlock( { || aDados1[14] } )
EndIf
If Len(_aMes)>6
 oSection1:Cell(_aMes[7,2])    			:SetBlock( { || aDados1[15] } )
oSection1:Cell(_aMes[7,3])  			:SetBlock( { || aDados1[16] } )
EndIf
If Len(_aMes)>7
 oSection1:Cell(_aMes[8,2])    			:SetBlock( { || aDados1[17] } )
oSection1:Cell(_aMes[8,3])  			:SetBlock( { || aDados1[18] } )
EndIf
If Len(_aMes)>8
 oSection1:Cell(_aMes[9,2])    			:SetBlock( { || aDados1[19] } )
oSection1:Cell(_aMes[9,3])  			:SetBlock( { || aDados1[20] } )
EndIf
If Len(_aMes)>9
 oSection1:Cell(_aMes[10,2])    			:SetBlock( { || aDados1[21] } )
oSection1:Cell(_aMes[10,3])  			:SetBlock( { || aDados1[22] } )
EndIf
If Len(_aMes)>10
 oSection1:Cell(_aMes[11,2])    			:SetBlock( { || aDados1[23] } )
oSection1:Cell(_aMes[11,3])  			:SetBlock( { || aDados1[24] } )
EndIf
If Len(_aMes)>11
 oSection1:Cell(_aMes[12,2])    			:SetBlock( { || aDados1[25] } )
oSection1:Cell(_aMes[12,3])  			:SetBlock( { || aDados1[26] } )
EndIf

oSection1:Cell("SLD03")    			:SetBlock( { || nSaldo03 } )
oSection1:Cell("SLD10")  			:SetBlock( { || nSaldo10 } )

oReport:SetTitle("Produtos especificos")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		   
		aadd(_aResu,(cAliasLif)->PRODUTO)  
		aadd(_aResu,(cAliasLif)->DESCRICAO)


		For j:= 1  To Len(_aMes)
		aadd(_aResu, &("(cAliasLif)->"+_aMes[j,2]))  
		aadd(_aResu, &("(cAliasLif)->"+_aMes[j,3]))
		Next j
	    
		nSaldo03	:= (cAliasLif)->SALDO03
		nSaldo10	:= (cAliasLif)->SALDO10 
		
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
Local j:= 0


cQuery := " SELECT

For j:= 1  To Len(_aMes)
	
	cQuery += " NVL((SELECT SUM(D2_QUANT) FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += "  ON SD2.D2_TES = SF4.F4_CODIGO
	cQuery += "  AND SF4.D_E_L_E_T_ = ' '
	cQuery += "  AND SF4.F4_DUPLIC = 'S'
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_EST    <> 'SC'
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_COD  = SB1.B1_COD
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,6) = '"+_aMes[J,1] +"'  ),0)
	cQuery += ' "'+_aMes[J,3] +'",
	cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ) FROM  "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += "  ON SD2.D2_TES = SF4.F4_CODIGO
	cQuery += "  AND SF4.D_E_L_E_T_ = ' '
	cQuery += "  AND SF4.F4_DUPLIC = 'S'
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_EST    <> 'SC'
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_COD  = SB1.B1_COD
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,6) = '"+_aMes[J,1] +"'  ),0)
	cQuery += ' "'+_aMes[J,2] +'",
	
Next j


cQuery += " SB1.B1_DESC
cQuery += ' "DESCRICAO" ,
cQuery += " (SELECT NVL(SUM(B2_QATU),0) SALDO03 FROM "+RetSqlName("SB2")+" B2 WHERE D_E_L_E_T_=' ' AND B2_COD=SB1.B1_COD AND B2_LOCAL='03') SALDO03, "
cQuery += " (SELECT NVL(SUM(B2_QATU),0) SALDO03 FROM "+RetSqlName("SB2")+" B2 WHERE D_E_L_E_T_=' ' AND B2_COD=SB1.B1_COD AND B2_LOCAL='10') SALDO10, "
cQuery += " SB1.B1_COD
cQuery += ' "PRODUTO"

cQuery += " FROM "+RetSqlName("SB1")+"  SB1 "

cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_COD IN (
cQuery += " 'A3076I',
cQuery += " 'A3079I',
cQuery += " 'A4076I',
cQuery += " 'A4079I',
cQuery += " 'A5076I',
cQuery += " 'A3276I',
cQuery += " 'A3279I',
cQuery += " 'A4276I',
cQuery += " 'A4279I',
cQuery += " 'A5276I',
cQuery += " 'A3056I',
cQuery += " 'A3059I',
cQuery += " 'A4056I',
cQuery += " 'A4059I',
cQuery += " 'A3256I',
cQuery += " 'A3259I',
cQuery += " 'A4256I',
cQuery += " 'A4259I',
cQuery += " 'A3006I',
cQuery += " 'A3009I',
cQuery += " 'A4006I',
cQuery += " 'A4009I',
cQuery += " 'A5006I',
cQuery += " 'A3206I',
cQuery += " 'A3209I',
cQuery += " 'A4206I',
cQuery += " 'A4209I',
cQuery += " 'A5206I')

cQuery += " GROUP BY SB1.B1_COD,SB1.B1_DESC

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

