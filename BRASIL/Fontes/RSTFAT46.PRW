#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT46     บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Faturamento 	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT46()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT46"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private c2AliasLif   	:= '2'+cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif
Private _cMes01 		:= mesextenso(Month(Date()))
Private _cMes02 		:= mesextenso(Month(Date())+1)
Private _cMes03 		:= mesextenso(Month(Date())+2)
Private _cMes04 		:= mesextenso(Month(Date())+3)

Private _cxMes01 		:=  cvaltochar(Year (Date()))+strzero(Month(Date()),2,0)
Private _cxMes02 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+1)+'01',cvaltochar(Year (Date()))+strzero(Month(Date())+1,2,0))
Private _cxMes03 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+2)+Iif(Month(Date()) = 12,'02','01'),cvaltochar(Year (Date()))+strzero(Month(Date())+2,2,0))
Private _cxMes04 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+3)+Iif(Month(Date()) = 12,'03',Iif(Month(Date()) = 11,'02','01')),cvaltochar(Year (Date()))+strzero(Month(Date())+3,2,0))
Private _cDistr			:=''

Private Distribuidor 		:= "('D1','D2','D3')"
Private Revendedor 			:= "('R1','R2','R3','R5')"
Private Instalador 			:= "('E1','E2','E4','E5')"
Private Construtor 			:= "'E3'"
Private Industrializador 	:= "('I2','I1','I3','I4','R4')"
Private Consumidor 			:= "('C1','C2','C3')"

PutSx1(cPerg, "01", "Do Vendedor:" 		,"Da Vendedor: ?" 		,"Da Vendedor: ?" 		,"mv_ch1","C",06,0,0,"G","",'SA3' ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Vendedor:" 	,"Ate Vendedor: ?" 		,"Ate Vendedor: ?" 		,"mv_ch2","C",06,0,0,"G","",'SA3' ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Supervisor:" 	,"Do Supervisor: ?" 	,"Do Supervisor: ?" 	,"mv_ch3","C", 6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Supervisor:"  	,"Ate Supervisor: ?" 	,"Ate Supervisor: ?" 	,"mv_ch4","C", 6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "M๊s Ref.:"			,"M๊s Ref.:"			,"M๊s Ref.:"        	,"mv_ch5","C", 2,0,0,"C","mv_par05 $ '01/02/03/04/05/06/07/08/09/10/11/12'"		,''    ,'','',"mv_par05","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Ano Ref.:"			,"Ano Ref.:"			,"Ano Ref.:"        	,"mv_ch6","C", 4,0,0,"C","mv_par06 $ '2013/2014/2015/2016/2017/2018/2019/2020'" ,''    ,'','',"mv_par06","","","","","","","","","","","","","","","")


oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio 						                          บฑฑ
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

oReport := TReport():New(cPergTit,"RELATำRIO Faturamento",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Faturamento")

Pergunte(cPerg,.T.)
_cMes01 		:= mesextenso(MV_PAR05)
_cMes02 		:= mesextenso(Month(Date())+1)
_cMes03 		:= mesextenso(Month(Date())+2)
_cMes04 		:= mesextenso(Month(Date())+3)
oSection := TRSection():New(oReport,"Faturamento",{"SC5"})


TRCell():New(oSection,"VENDEDOR"	  			 ,,"VENDEDOR"		,,30,.F.,)
TRCell():New(oSection,"SUPERVISOR"  			 ,,"SUPERVISOR"	,,30,.F.,)
TRCell():New(oSection,"FATURAMENTO"  			 ,,"FATURAMENTO/"+_cMes01						,"@E 99,999,999.99",14)
TRCell():New(oSection,"META"  			 		 ,,"META/"+_cMes01								,"@E 99,999,999.99",14)
TRCell():New(oSection,"META2"  			 		 ,,"META %"								,"@E 99,999,999.99",14)



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
Local aDados1[29]
Local _cSta 	:= ''
TRCell():New(oSection,"JANEIRO"     		 	 ,,"JANEIRO/"+_cMes01+"-"+cvaltochar(tira1(MV_PAR06))		,"@E 99,999,999.99",14)
TRCell():New(oSection,"MEDIA"     			     ,,"MEDIA-"+cvaltochar(tira1(MV_PAR06))						,"@E 99,999,999.99",14)
TRCell():New(oSection,"JANEIRO2"       	 		 ,,"JANEIRO/"+_cMes01+"-"+MV_PAR06	   			,"@E 99,999,999.99",14)
TRCell():New(oSection,"MEDIA2"     			     ,,"MEDIA-"+(MV_PAR06)							,"@E 99,999,999.99",14)
TRCell():New(oSection,"MEDIA_META"       	 	 ,,"MEDIA x META-"+ cvaltochar(tira1(MV_PAR06))  			,"@E 99,999,999.99",14)
TRCell():New(oSection,"MEDIA_META2"       	 	 ,,"MEDIA x META-"+ MV_PAR06   					,"@E 99,999,999.99",14)
TRCell():New(oSection,"Distribuidor" 			 ,,"Distribuidor-"+ cvaltochar(tira1(MV_PAR06)) 			,"@E 99,999,999.99",14)
TRCell():New(oSection,"Distribuidor2"            ,,"Distribuidor-"+  MV_PAR06  					,"@E 99,999,999.99",14) 
TRCell():New(oSection,"Distribuidor3"            ,,"Distribuidor %" 					,"@E 99,999,999.99",14)  

TRCell():New(oSection,"Revendedor" 			 	 ,,"Revendedor-"+ cvaltochar(tira1(MV_PAR06)) 				,"@E 99,999,999.99",14)
TRCell():New(oSection,"Revendedor2"            	 ,,"Revendedor-"+  MV_PAR06  					,"@E 99,999,999.99",14)
TRCell():New(oSection,"Revendedor3"              ,,"Revendedor %" 					,"@E 99,999,999.99",14)

TRCell():New(oSection,"Instalador" 			     ,,"Instalador-"+ cvaltochar(tira1(MV_PAR06)) 				,"@E 99,999,999.99",14)
TRCell():New(oSection,"Instalador2"              ,,"Instalador-"+  MV_PAR06  					,"@E 99,999,999.99",14)
TRCell():New(oSection,"Instalador3"              ,,"Instalador %" 					,"@E 99,999,999.99",14)

TRCell():New(oSection,"Construtor" 			     ,,"Construtor-"+ cvaltochar(tira1(MV_PAR06)) 				,"@E 99,999,999.99",14)
TRCell():New(oSection,"Construtor2"              ,,"Construtor-"+  MV_PAR06  					,"@E 99,999,999.99",14)
TRCell():New(oSection,"Construtor3"              ,,"Construtor %" 					,"@E 99,999,999.99",14)

TRCell():New(oSection,"Industrializador" 		 ,,"Industrializador-"+ cvaltochar(tira1(MV_PAR06)) 		,"@E 99,999,999.99",14)
TRCell():New(oSection,"Industrializador2"        ,,"Industrializador-"+  MV_PAR06  				,"@E 99,999,999.99",14)
TRCell():New(oSection,"Industrializador3"        ,,"Industrializador %" 					,"@E 99,999,999.99",14)

TRCell():New(oSection,"Consumidor" 			     ,,"Consumidor-"+ cvaltochar(tira1(MV_PAR06)) 				,"@E 99,999,999.99",14)
TRCell():New(oSection,"Consumidor2"              ,,"Consumidor-"+  MV_PAR06  					,"@E 99,999,999.99",14)
TRCell():New(oSection,"Consumidor3"              ,,"Consumidor %" 					,"@E 99,999,999.99",14)

oSection1:Cell("VENDEDOR")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("SUPERVISOR")  			:SetBlock( { || aDados1[02] } )
oSection1:Cell("FATURAMENTO")  			:SetBlock( { || aDados1[03] } )
oSection1:Cell("META")       			:SetBlock( { || aDados1[04] } )  
oSection1:Cell( "JANEIRO" )  			:SetBlock( { || aDados1[05] } )
oSection1:Cell( "MEDIA" )				:SetBlock( { || aDados1[06] } )
oSection1:Cell( "JANEIRO2" )			:SetBlock( { || aDados1[07] } )
oSection1:Cell("MEDIA2")     			:SetBlock( { || aDados1[08] } )
oSection1:Cell("MEDIA_META")     		:SetBlock( { || aDados1[09] } )
oSection1:Cell("MEDIA_META2")			:SetBlock( { || aDados1[10] } )
oSection1:Cell("Distribuidor")      	:SetBlock( { || aDados1[11] } )
oSection1:Cell("Distribuidor2")			:SetBlock( { || aDados1[12] } )    
oSection1:Cell("Revendedor")     		:SetBlock( { || aDados1[13] } )
oSection1:Cell("Revendedor2")			:SetBlock( { || aDados1[14] } ) 
oSection1:Cell("Instalador")			:SetBlock( { || aDados1[15] } )
oSection1:Cell("Instalador2")			:SetBlock( { || aDados1[16] } )   
oSection1:Cell("Construtor")			:SetBlock( { || aDados1[17] } )
oSection1:Cell("Construtor2")			:SetBlock( { || aDados1[18] } )  
oSection1:Cell("Industrializador")		:SetBlock( { || aDados1[19] } )
oSection1:Cell( "Industrializador2" )	:SetBlock( { || aDados1[20] } ) 
oSection1:Cell( "Consumidor" )			:SetBlock( { || aDados1[21] } )
oSection1:Cell( "Consumidor2" )			:SetBlock( { || aDados1[22] } )
oSection1:Cell("META2")       			:SetBlock( { || aDados1[23] } )
oSection1:Cell("Distribuidor3")			:SetBlock( { || aDados1[24] } )    
oSection1:Cell("Revendedor3")			:SetBlock( { || aDados1[25] } ) 
oSection1:Cell("Instalador3")	 		:SetBlock( { || aDados1[26] } )  
oSection1:Cell("Construtor3")			:SetBlock( { || aDados1[27] } ) 
oSection1:Cell( "Industrializador3" )	:SetBlock( { || aDados1[28] } ) 
oSection1:Cell( "Consumidor3" )			:SetBlock( { || aDados1[29] } )


oReport:SetTitle("Faturamento")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
 //	Representante	Supervisor	Faturamento junho 2014	Objetivo Meta 2014	Faturamento 2013 Jan-jun	M้dia 2013	Faturamento 2014 Jan-jun	M้dia 2014	% Comparativo M้dia & Meta 2013	% Comparativo M้dia & Meta 2014	Distribuidor 2013	Distribuidor 2014	Revendedor 2013	Revendedor 2014	Instalador 2013	Instalador 2014	Construtor 2013	Construtor 2014	Industrializador 2013	Industrializador 2014	Consumidor 2013	Consumidor 2014
	
		aDados1[01]	:=	(cAliasLif)->VENDEDOR  //Representante
		aDados1[02]	:= 	(cAliasLif)->SUPERVISOR   //Supervisor
		aDados1[03]	:=  (cAliasLif)->FATURAMENTO_MES - (cAliasLif)->DEVOLUCAO_MES   //	Faturamento junho 2014
		aDados1[04]	:= 	(cAliasLif)->OBJETIVO            //	Objetivo Meta 2014  
		aDados1[23]	:= 	((aDados1[03]*100)/aDados1[04] )-100  
		aDados1[05]	:=  (cAliasLif)->XFATURAMENTO_ANO_PASS - (cAliasLif)->XDEVOLUCAO_ANO_PASS //	Faturamento 2013 Jan-jun
		aDados1[06]	:=  ((cAliasLif)->XFATURAMENTO_ANO_PASS - (cAliasLif)->XDEVOLUCAO_ANO_PASS) / val(MV_PAR05)  //M้dia 2013
		aDados1[07]	:=	((cAliasLif)->YFATURAMENTO_ANO - (cAliasLif)->YDEVOLUCAO_ANO)  //Faturamento 2014 Jan-jun
		aDados1[08]	:=	((cAliasLif)->YFATURAMENTO_ANO - (cAliasLif)->YDEVOLUCAO_ANO)/val(MV_PAR05)  //M้dia 2014
		aDados1[09]	:= 	((aDados1[06]*100)/	(cAliasLif)->XOBJETIVO_PASS)-100            //	% Comparativo M้dia & Meta 2013  
		aDados1[10]	:=  ((aDados1[08]*100)/aDados1[04])-100             //	% Comparativo M้dia & Meta 2014
		St2Query(aDados1[01],aDados1[02],Distribuidor)
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			aDados1[11]	:= (( ((c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05])
			aDados1[12]	:= ((((c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07] )
				aDados1[24]	:= (	(aDados1[12]*100)/	aDados1[11] )-100
		EndIf
		St2Query(aDados1[01],aDados1[02],Revendedor)
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			aDados1[13]	:=  ((((c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05])
			aDados1[14]	:= ((( (c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07])
				aDados1[25]	:= (	(aDados1[14]*100)/	aDados1[13] )-100
		EndIf
		St2Query(aDados1[01],aDados1[02],Instalador)
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			aDados1[15]	:= ((( (c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05]) 
			aDados1[16]	:= ((( (c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07]) 
				aDados1[26]	:= (	(aDados1[16]*100)/	aDados1[15] )-100
		EndIf
		St2Query(aDados1[01],aDados1[02],Construtor)
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			aDados1[17]	:= ((( (c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05]) 
			aDados1[18]	:=  ((((c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07])   
				aDados1[27]	:= (	(aDados1[18]*100)/	aDados1[17] )-100
		EndIf
		St2Query(aDados1[01],aDados1[02],Industrializador)
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			aDados1[19]	:=  ((((c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05]) 
			aDados1[20]	:=(((	(c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07])  
				aDados1[28]	:= (	(aDados1[20]*100)/	aDados1[19] )-100
		EndIf
		DbSelectArea(c2AliasLif)
		(c2AliasLif)->(DbGoTop())
		If  Select(c2AliasLif) > 0
			St2Query(aDados1[01],aDados1[02],Consumidor)
			aDados1[21]	:=(	 (((c2AliasLif)->XFATURAMENTO_PASS - (c2AliasLif)->XDEVOLUCAO_PASS)*100)/aDados1[05]) 
			aDados1[22]	:= ( (((c2AliasLif)->FATURAMENTO - (c2AliasLif)->DEVOLUCAO)*100)/aDados1[07]) 
				aDados1[29]	:=	((aDados1[22]*100)/	aDados1[21] )-100
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


cQuery := " SELECT
cQuery += " SA3.A3_COD||' - '||TRIM(SA3.A3_NOME)
cQuery += ' AS "VENDEDOR",
cQuery += " NVL((SELECT
cQuery += " TA3.A3_COD||' - '||TRIM(TA3.A3_NOME)
cQuery += " FROM SA3010 TA3
cQuery += " WHERE TA3.A3_COD = SA3.A3_SUPER
cQuery += " AND SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_FILIAL  = ' '),' ')
cQuery += ' AS "SUPERVISOR",

cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
cQuery += ' "TOTAL"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2 "
cQuery += " ON SD2.D_E_L_E_T_ = ' '
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'


cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR06+MV_PAR05+"' AND '"+MV_PAR06+MV_PAR05+"'
cQuery += " AND SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
/*
cQuery += " AND EXISTS(SELECT * FROM SC6010 SC6
cQuery += " WHERE  SC6.C6_NUM = SD2.D2_PEDIDO
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ) 
*/ 
cQuery += " ),0)
cQuery += ' AS "FATURAMENTO_MES",

cQuery += "  NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += '  "TOTAL"
cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  ' 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR06+MV_PAR05+"' AND '"+MV_PAR06+MV_PAR05+"' ),0)
cQuery += ' AS "DEVOLUCAO_MES",

cQuery += " NVL((SELECT SUM(ZZD.ZZD_VALOR)
cQuery += " FROM ZZD010 ZZD WHERE  ZZD.D_E_L_E_T_ = ' '
cQuery += " AND ZZD.ZZD_MES BETWEEN '"+ MV_PAR05+"' AND '"+ MV_PAR05+"'
cQuery += " AND ZZD.ZZD_ANO BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR06+"'
cQuery += " AND ZZD.ZZD_FILIAL = '  '  AND ZZD.ZZD_VEND = SA3.A3_COD ),0)
cQuery += ' AS "OBJETIVO",

cQuery += " NVL((SELECT SUM(ZZD.ZZD_VALOR)
cQuery += " FROM ZZD010 ZZD WHERE  ZZD.D_E_L_E_T_ = ' '
cQuery += " AND ZZD.ZZD_MES BETWEEN '"+ MV_PAR05+"' AND '"+ MV_PAR05+"'
cQuery += " AND ZZD.ZZD_ANO BETWEEN '"+TIRA1(MV_PAR06)+"' AND '"+TIRA1(MV_PAR06)+"'
cQuery += " AND ZZD.ZZD_FILIAL = '  '  AND ZZD.ZZD_VEND = SA3.A3_COD ),0)
cQuery += ' AS "XOBJETIVO_PASS",


cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
cQuery += ' "TOTAL"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2 "
cQuery += " ON SD2.D_E_L_E_T_ = ' '
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'


cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+cvaltochar(tira1(MV_PAR06))+"01' AND '"+cvaltochar(tira1(MV_PAR06))+MV_PAR05+"'
cQuery += " AND SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
/*
cQuery += " AND EXISTS(SELECT * FROM SC6010 SC6
cQuery += " WHERE  SC6.C6_NUM = SD2.D2_PEDIDO
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ) 
*/ 
cQuery += " ),0)
cQuery += ' AS "XFATURAMENTO_ANO_PASS",

cQuery += "  NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += '  "TOTAL"
cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '  
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+cvaltochar(tira1(MV_PAR06))+"01' AND '"+cvaltochar(tira1(MV_PAR06))+MV_PAR05+"' ),0)
cQuery += ' AS "XDEVOLUCAO_ANO_PASS",


cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
cQuery += '  "TOTAL"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2 "
cQuery += " ON SD2.D_E_L_E_T_ = ' '
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'


cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR06+"01'AND '"+MV_PAR06+MV_PAR05+"'
cQuery += " AND SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
/*
cQuery += " AND EXISTS(SELECT * FROM SC6010 SC6
cQuery += " WHERE  SC6.C6_NUM = SD2.D2_PEDIDO
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ) 
*/ 
cQuery += " ),0)
cQuery += ' AS "YFATURAMENTO_ANO",

cQuery += "  NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += '  "TOTAL"
cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR06+"01'AND '"+MV_PAR06+MV_PAR05+"'),0)
cQuery += ' AS "YDEVOLUCAO_ANO"

cQuery += " FROM "+RetSqlName("SA3")+" SA3 "



cQuery += " WHERE SA3.A3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQuery += "  AND SA3.A3_TPVEND <> 'I'
cQuery += "  AND SA3.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_FILIAL  = ' '
//cQuery += "  AND SA3.A3_SUPER <> ' '
//cQuery += "  AND SA3.A3_ZBLOQ = '2'
cQuery += "  AND SA3.A3_SUPER BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
cQuery += " ORDER BY  SA3.A3_SUPER

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  St2Query      บAutor  ณGiovani Zago    บ Data ณ  21/02/14    บฑฑ
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
Static Function St2Query(_cVend,_cSuper,_cGrpven)
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT

cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
cQuery += ' "TOTAL"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2 "
cQuery += " ON SD2.D_E_L_E_T_ = ' '
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += "  AND SA1.A1_COD = SF2.F2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
cQuery += " AND TRIM(SA1.A1_GRPVEN) in "+_cGrpven
cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+cvaltochar(tira1(MV_PAR06))+"01' AND '"+cvaltochar(tira1(MV_PAR06))+MV_PAR05+"'
cQuery += " AND SF2.D_E_L_E_T_ = ' '
cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
/*
cQuery += " AND EXISTS(SELECT * FROM SC6010 SC6
cQuery += " WHERE  SC6.C6_NUM = SD2.D2_PEDIDO
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ) 
*/ 
cQuery += " ),0)
cQuery += ' AS "XFATURAMENTO_PASS",

cQuery += "  NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += ' "TOTAL"
cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'D'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += " AND SA1.A1_FILIAL = '  ' 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " AND TRIM(SA1.A1_GRPVEN) in "+_cGrpven
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
cQuery += " AND SA1.A1_VEND = SA3.A3_COD
cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+cvaltochar(tira1(MV_PAR06))+"01' AND '"+cvaltochar(tira1(MV_PAR06))+MV_PAR05+"' ),0)
cQuery += ' AS "XDEVOLUCAO_PASS",



cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
cQuery += ' "TOTAL"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2 "
cQuery += " ON SD2.D_E_L_E_T_ = ' '
cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
cQuery += " AND SA1.A1_FILIAL = '  '
 
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += "  AND SA1.A1_COD = SF2.F2_CLIENTE
cQuery += "  AND SA1.A1_LOJA = SF2.F2_LOJA
cQuery += "  AND SA1.A1_FILIAL = '  '
cQuery += "  AND TRIM(SA1.A1_GRPVEN) in "+_cGrpven
cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR06+"01'AND '"+MV_PAR06+MV_PAR05+"'
cQuery += "  AND SF2.D_E_L_E_T_ = ' '
cQuery += "  AND SF2.F2_VEND1 = SA3.A3_COD
/*
cQuery += " AND EXISTS(SELECT * FROM SC6010 SC6
cQuery += " WHERE  SC6.C6_NUM = SD2.D2_PEDIDO
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ) 
*/ 
cQuery += " ),0)
cQuery += ' AS "FATURAMENTO",

cQuery += "  NVL((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
cQuery += ' "TOTAL"
cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += "  AND SD1.D1_TIPO = 'D'
cQuery += "  AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += "  AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += "  AND SA1.A1_FILIAL = '  '
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_GRPVEN <> 'SC'
cQuery += " AND SA1.A1_EST <> 'EX'
cQuery += "  AND TRIM(SA1.A1_GRPVEN) in "+_cGrpven
cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "  AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
cQuery += "  AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
cQuery += "  AND SA1.A1_VEND = SA3.A3_COD
cQuery += "  AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR06+"01'AND '"+MV_PAR06+MV_PAR05+"'),0)
cQuery += ' AS "DEVOLUCAO"

cQuery += " FROM "+RetSqlName("SA3")+" SA3 "



cQuery += " WHERE SA3.A3_COD = '"+SUBSTR(_cVend,1,6)+"'
cQuery += "  AND SA3.A3_TPVEND <> 'I'
cQuery += "  AND SA3.D_E_L_E_T_ = ' '
cQuery += "  AND SA3.A3_FILIAL  = ' '
//cQuery += "  AND SA3.A3_SUPER <> ' '
//cQuery += "  AND SA3.A3_ZBLOQ = '2'
//cQuery += "  AND SA3.A3_SUPER = '"+SUBSTR(_cSuper,1,6)+"'
cQuery += " ORDER BY  SA3.A3_SUPER

cQuery := ChangeQuery(cQuery)
//cQuery:="SELECT COALESCE((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) "TOTAL" FROM SF2010 SF2 INNER JOIN(SELECT * FROM SD2010 )  SD2 ON SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.A1_FILIAL = '  ' AND TRIM(SA1.A1_GRPVEN) in 'D1/D2/D3'  WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '201301' AND '201306' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD AND EXISTS(SELECT * FROM SC6010 SC6 WHERE  SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.D_E_L_E_T_ = ' ' )  ),0) AS "FATURAMENTO_PASS",COALESCE((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) "TOTAL" FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' AND TRIM(SA1.A1_GRPVEN) in 'D1/D2/D3'  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SA1.A1_VEND = SA3.A3_COD AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '201301' AND '201306' ),0) AS "DEVOLUCAO_PASS",COALESCE((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) "TOTAL" FROM SF2010 SF2 INNER JOIN(SELECT * FROM SD2010 )  SD2 ON SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.A1_FILIAL = '  ' AND TRIM(SA1.A1_GRPVEN) in 'D1/D2/D3'  WHERE  SUBSTR(F2_EMISSAO,1,6) BETWEEN '201401'AND '201406' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD AND EXISTS(SELECT * FROM SC6010 SC6 WHERE  SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.D_E_L_E_T_ = ' ' )  ),0) AS "FATURAMENTO",COALESCE((SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) "TOTAL" FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 )  SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' AND TRIM(SA1.A1_GRPVEN) in 'D1/D2/D3'  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SA1.A1_VEND = SA3.A3_COD AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '201401'AND '201406'),0) AS "DEVOLUCAO" FROM SA3010 SA3 WHERE  SA3.A3_COD = 'R00267' AND SA3.A3_TPVEND <> 'I' AND SA3.D_E_L_E_T_ = ' ' AND SA3.A3_FILIAL = ' ' AND SA3.A3_SUPER <> ' ' AND SA3.A3_ZBLOQ = '2' AND SA3.A3_SUPER = 'S00006'  ORDER BY  SA3.A3_SUPER
If Select(c2AliasLif) > 0
	(c2AliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c2AliasLif)

Return()


