#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT15     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Pedido Bloqueados                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT15()

Local   oReport
Private cPerg 			:= "RFAT15"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

PutSx1( cPerg, "01","Data de:"			,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Data Até:"			,"","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","Vendedor de:"      ,"","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","Vendedor Até:"     ,"","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04","","","","","","","","","","","","","","","","")
//PutSx1( cPerg, "05","Os de:"        ,"","","mv_ch5","C",6,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
//PutSx1( cPerg, "06","Os Até:"       ,"","","mv_ch6","C",6,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELATÓRIO PEDIDOS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Pedidos Bloqueados .")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Análise  Pedidos",{"SC5"})


TRCell():New(oSection,"Pedidos"			,,"Pedidos"		,,06,.F.,)
TRCell():New(oSection,"Emissao" 		,,"Emissao"		,,10,.F.,)
TRCell():New(oSection,"Cliente"		 	,,"Cliente"		,,06,.F.,)
TRCell():New(oSection,"Loja"		 	,,"Loja"		,,02,.F.,)
TRCell():New(oSection,"Nome"		 	,,"Nome"		,,50,.F.,)
TRCell():New(oSection,"Telefone"		,,"Telefone"	,,10,.F.,)
TRCell():New(oSection,"Vendedor"		,,"Vendedor"	,,30,.F.,)
TRCell():New(oSection,"Saldo"   		,,"Saldo"   	,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP0"
Local aDados[2]
Local aDados1[8]


oSection1:Cell("Pedidos")       :SetBlock( { || aDados1[01] } )
oSection1:Cell("Emissao")		:SetBlock( { || aDados1[02] } )
oSection1:Cell("Cliente")		:SetBlock( { || aDados1[03] } )
oSection1:Cell("Loja")			:SetBlock( { || aDados1[04] } )
oSection1:Cell("Nome")		    :SetBlock( { || aDados1[05] } )
oSection1:Cell("Telefone")      :SetBlock( { || aDados1[06] } )
oSection1:Cell("Vendedor")      :SetBlock( { || aDados1[07] } )
oSection1:Cell("Saldo")         :SetBlock( { || aDados1[08] } )

oReport:SetTitle("Pedidos Bloqueados")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()




Processa({|| StQuery( ) },"Compondo Relatorio")




dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:= 	(cAliasLif)->C5_NUM
		aDados1[02]	:=SUBSTR((cAliasLif)->C5_EMISSAO,7,2)+'/'+ SUBSTR((cAliasLif)->C5_EMISSAO,5,2)+'/'+ SUBSTR((cAliasLif)->C5_EMISSAO,1,4)
		aDados1[03]	:=	(cAliasLif)->C5_CLIENTE
		aDados1[04]	:=	(cAliasLif)->C5_LOJACLI
		aDados1[05]	:=	(cAliasLif)->A1_NOME
		aDados1[06]	:=	(cAliasLif)->A1_TEL
		aDados1[07]	:=	(cAliasLif)->COD+'-'+(cAliasLif)->VENDEDOR
		aDados1[08]	:=	(cAliasLif)->C6_VALOR
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
		(cAliasLif)->(dbskip())
		
	End
	
	
	
EndIf



oReport:SkipLine()




Return oReport



Static Function StQuery()

Local cQuery     := ' '


cQuery := " SELECT
cQuery += " SC5.C5_NUM,
cQuery += " SC5.C5_EMISSAO ,
cQuery += " SC5.C5_CLIENTE,
cQuery += " SC5.C5_LOJACLI,
cQuery += " A1_NOME,
cQuery += " A1_TEL,
cQuery += "   (SELECT  A3_NOME
cQuery += " FROM SA3010  SA3
cQuery += "   WHERE SA3.D_E_L_E_T_   =    ' '
cQuery += "   AND  SA3.A3_COD    =   SC5.C5_VEND2
cQuery += "   AND SA3.A3_FILIAL  =  '"+xFilial("SA3")+"'  )
cQuery += ' "VENDEDOR"
cQuery += " ,SC5.C5_VEND2  
cQuery += ' "COD",
cQuery += " (SELECT SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2))
cQuery += " FROM SC6010 SC6
cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += "   AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
cQuery += ' ) "C6_VALOR"
cQuery += " ,'1'
cQuery += " FROM SC5010 SC5

cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

cQuery += " WHERE  SC5.C5_EMISSAO BETWEEN  '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += "  AND SC5.D_E_L_E_T_= ' '
cQuery += " AND SC5.C5_XIBL = '2'
cQuery += " AND     SC5.C5_NOTA  NOT LIKE '%XXXX%'
cQuery += "  AND SC5.C5_ZFATBLQ <> '1'
cQuery += "  AND SC5.C5_FILIAL = '02'
cQuery += "  AND  SC5.C5_VEND2 BETWEEN  '" +  MV_PAR03  + "'  AND '" +  MV_PAR04  + "'
cQuery += "  AND  TRIM(SC5.C5_VEND2) <> ''    
cQuery += "  AND (SELECT SUM(XC6.C6_QTDVEN - XC6.C6_QTDENT)
cQuery += " FROM SC6010 XC6
cQuery += " WHERE XC6.D_E_L_E_T_   = ' '
cQuery += "   AND SC5.C5_NUM      = XC6.C6_NUM
cQuery += "  AND SC5.C5_FILIAL   = XC6.C6_FILIAL
cQuery += ' )  > 0

cQuery += " UNION

cQuery += " SELECT
cQuery += " TC5.C5_NUM,
cQuery += " TC5.C5_EMISSAO ,
cQuery += " TC5.C5_CLIENTE,
cQuery += " TC5.C5_LOJACLI,
cQuery += " A1_NOME,
cQuery += " A1_TEL,
cQuery += "   (SELECT  A3_NOME
cQuery += " FROM SA3010  SA3
cQuery += "   WHERE SA3.D_E_L_E_T_   =    ' '
cQuery += "   AND  SA3.A3_COD    =   TC5.C5_VEND1
cQuery += "   AND SA3.A3_FILIAL  =  '"+xFilial("SA3")+"'  )
cQuery += ' "VENDEDOR"
cQuery += " ,TC5.C5_VEND1  
cQuery += ' "COD",
cQuery += " (SELECT SUM(round((TC6.C6_ZVALLIQ/TC6.C6_QTDVEN)*(TC6.C6_QTDVEN - TC6.C6_QTDENT),2))
cQuery += " FROM SC6010 TC6
cQuery += " WHERE TC6.D_E_L_E_T_   = ' '
cQuery += "   AND TC5.C5_NUM      = TC6.C6_NUM
cQuery += "  AND TC5.C5_FILIAL   = TC6.C6_FILIAL
cQuery += ' ) "C6_VALOR"
cQuery += " ,'2'
cQuery += " FROM SC5010 TC5

cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = TC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = TC5.C5_LOJACLI
cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

cQuery += " WHERE  TC5.C5_EMISSAO BETWEEN  '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += "  AND TC5.D_E_L_E_T_= ' '
cQuery += "  AND TC5.C5_XIBL = '2'
cQuery += "  AND TC5.C5_NOTA  NOT LIKE '%XXXX%'
cQuery += "  AND TC5.C5_ZFATBLQ <> '1'
cQuery += "  AND TC5.C5_FILIAL = '02'
cQuery += "  AND  TC5.C5_VEND1 BETWEEN  '" +  MV_PAR03  + "'  AND '" +  MV_PAR04  + "'
cQuery += "  AND  TRIM(TC5.C5_VEND2) =  '' 
cQuery += "  AND (SELECT SUM(ZC6.C6_QTDVEN - ZC6.C6_QTDENT)
cQuery += " FROM SC6010 ZC6
cQuery += " WHERE ZC6.D_E_L_E_T_   = ' '
cQuery += "   AND TC5.C5_NUM      = ZC6.C6_NUM
cQuery += "  AND TC5.C5_FILIAL   = ZC6.C6_FILIAL
cQuery += ' )  > 0
cQuery += "  ORDER BY  C5_CLIENTE , C5_NUM







cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

