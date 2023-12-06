#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT37     ºAutor  ³Giovani Zago    º Data ³  23/04/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Pedidos cif/fob		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT37()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT37"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private cPergTit 		:= cAliasLif
 

//PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")


oReport		:= ReportDef()
 oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
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
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection
 
oReport := TReport():New(cPergTit,"RELATÓRIO Pedidos Cif/Fob",'',{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Pedidos Cif/Fob")

//Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Pedidos Cif/Fob",{"SC5"})


TRCell():New(oSection,"PEDIDO"	  			 ,,"PEDIDO"	,,6,.F.,)
TRCell():New(oSection,"CLIENTE"  			 ,,"CLIENTE",,6,.F.,)
TRCell():New(oSection,"LOJA"  			 	 ,,"LOJA"	,,4,.F.,)
TRCell():New(oSection,"NOME"  			     ,,"NOME"	,,35,.F.,)
TRCell():New(oSection,"VEND1"  				 ,,"VEND1"	,,35,.F.,)
TRCell():New(oSection,"VEND2"  		 	 	 ,,"VEND2"	,,35,.F.,)  
TRCell():New(oSection,"CLICIF"  			 ,,"CLICIF"	,,6,.F.,)
TRCell():New(oSection,"PEDCIF"  		 	 ,,"PEDCIF"	,,6,.F.,)  
TRCell():New(oSection,"VALOR"  				 ,,"VALOR"	,"@E 99,999,999.99",14)
 



oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

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
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[09]
 



oSection1:Cell("PEDIDO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("CLIENTE")  			    :SetBlock( { || aDados1[02] } )
oSection1:Cell("LOJA")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("NOME")       		    :SetBlock( { || aDados1[04] } )
oSection1:Cell( "VEND1" )  				:SetBlock( { || aDados1[05] } )
oSection1:Cell( "VEND2" )				:SetBlock( { || aDados1[06] } )
oSection1:Cell( "CLICIF" )				:SetBlock( { || aDados1[07] } )
oSection1:Cell("PEDCIF")     			:SetBlock( { || aDados1[08] } )
oSection1:Cell("VALOR")     			:SetBlock( { || aDados1[09] } )


oReport:SetTitle("Pedidos Cif/Fob")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
 
		aDados1[01]	:=	(cAliasLif)->PEDIDO
		aDados1[02]	:= 	(cAliasLif)->CLIENTE
		aDados1[03]	:=  (cAliasLif)->LOJA
		aDados1[04]	:= 	(cAliasLif)->NOME
		aDados1[05]	:=  (cAliasLif)->NVEND1
		aDados1[06]	:=	(cAliasLif)->NVEND2
		aDados1[07]	:=	(cAliasLif)->CLICIF
		aDados1[08]	:=	(cAliasLif)->PEDCIF
		aDados1[09]	:=  (cAliasLif)->VALOR

		
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
Static Function StQuery()
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT  

cQuery += " C5_NUM
cQuery += ' "PEDIDO",
cQuery += " C5_CLIENTE
cQuery += ' "CLIENTE",
cQuery += " C5_LOJACLI
cQuery += ' "LOJA",
cQuery += " A1_NOME
cQuery += ' "NOME",
cQuery += " C5_VEND1||' - '||
cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_COD = C5_VEND1
cQuery += " AND SA3.A3_FILIAL =  '"+xFilial("SA3")+"'"
cQuery += "  ),' ') 
cQuery += ' "NVEND1",
cQuery += " C5_VEND2||' - '||
cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_COD = C5_VEND2
cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' ),' ') 
cQuery += ' "NVEND2",
cQuery += " A1_TPFRET 
cQuery += ' "CLICIF",
cQuery += " C5_TPFRETE 
cQuery += ' "PEDCIF",
cQuery += " (SELECT 
cQuery += " NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN-SC6.C6_QTDENT),2)),0)
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_l_e_t_ = ' ' 
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM  
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL
cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
cQuery += " AND SC6.C6_BLQ <> 'R')
cQuery += ' "VALOR"
cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
cQuery += " ON SA1.D_E_l_e_t_ = ' '
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
cQuery += " AND SA1.A1_TPFRET <> 'C'

cQuery += " WHERE SC5.D_E_l_e_t_ = ' ' 
cQuery += " AND SC5.C5_TPFRETE = 'C'
cQuery += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"
cQuery += " AND EXISTS(SELECT * FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.D_E_l_e_t_ = ' ' 
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM 
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL
cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT 
cQuery += " AND SC6.C6_OPER = '01'
cQuery += " AND SC6.C6_BLQ <> 'R')



cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

