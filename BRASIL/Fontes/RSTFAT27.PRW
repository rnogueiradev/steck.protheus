#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT27     ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio P.V. Programados		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT27()

Local   oReport
Private cPerg 			:= "RFAT27"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1(cPerg, "01", "Da Data:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "03", "Do Cliente:" 	,"Do Cliente: ?" 	,"Do Cliente: ?" 	,"mv_ch3","C",6,0,0,"G","",'SA1' ,"","","mv_par03","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "04", "Ate Cliente:"  ,"Ate Cliente: ?" 	,"Ate Cliente: ?" 	,"mv_ch4","C",6,0,0,"G","",'SA1' ,"","","mv_par04","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "05", "Da Loja:" 		,"Da Loja.: ?" 		,"Da Loja.: ?" 		,"mv_ch5","C",2,0,0,"G","",'' 	 ,"","","mv_par05","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "06", "Ate Loja.:" 	,"Ate Loja.: ?" 	,"Ate Loja.: ?" 	,"mv_ch6","C",2,0,0,"G","",''    ,"","","mv_par06","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "07", "Da Nota:" 		,"Da Nota: ?" 		,"Da Nota: ?" 		,"mv_ch7","C",9,0,0,"G","",'SF2' ,"","","mv_par07","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "08", "Ate Nota:" 	,"Ate Nota: ?" 		,"Ate Nota: ?" 		,"mv_ch8","C",9,0,0,"G","",'SF2' ,"","","mv_par08","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "09", "Do Status:" ,"Do Status: ?" ,"Do Status: ?" 			    	,"mv_ch9","C",6,0,0,"G","",'' ,"","","mv_par09","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "10", "Ate Status:" ,"Ate Status: ?" ,"Ate Status: ?" 		        ,"mv_chA","C",6,0,0,"G","",'' ,"","","mv_par10","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "11", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"             ,"mv_chB","N",1,0,0,"C","",''    ,'','',"mv_par11","Desconto","","","","Aprovador","","","Cliente","","","","","","","")




oReport		:= ReportDef()
	 oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELATÓRIO P.V. Programados",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de P.V. Programados")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"P.V. Programados",{"SC5"})


TRCell():New(oSection,"PEDIDO"	  	,,"PEDIDO"		,,6,.F.,)
TRCell():New(oSection,"CLIENTE"		,,"CLIENTE"		,,6,.F.,)
TRCell():New(oSection,"LOJA"  		,,"LOJA"		,,2,.F.,)
TRCell():New(oSection,'NOME'  		,,'NOME'		,,35,.F.,)
TRCell():New(oSection,"EMISSAO"  	,,"EMISSAO"	    ,,10,.F.,)
TRCell():New(oSection,"VALOR"       ,,"VALOR"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"VEND1"  		,,"VEND1"		,,35,.F.,)
TRCell():New(oSection,"VEND2"  		,,"VEND2"	    ,,35,.F.,)
TRCell():New(oSection,"DE"  		,,"DE"			,,5,.F.,)
TRCell():New(oSection,"ATE"  		,,"ATE"	    	,,5,.F.,)
TRCell():New(oSection,"TIPO"  		,,"TIPO"	    ,,10,.F.,)

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
Local aDados1[11]
Local _cSta := ''

oSection1:Cell("PEDIDO")    :SetBlock( { || aDados1[01] } )
oSection1:Cell("CLIENTE")	:SetBlock( { || aDados1[02] } )
oSection1:Cell("LOJA")  	:SetBlock( { || aDados1[03] } )
oSection1:Cell('NOME')  	:SetBlock( { || aDados1[04] } )
oSection1:Cell("EMISSAO")	:SetBlock( { || aDados1[05] } )
oSection1:Cell("VALOR")     :SetBlock( { || aDados1[06] } )
oSection1:Cell("VEND1")     :SetBlock( { || aDados1[07] } )
oSection1:Cell("VEND2")		:SetBlock( { || aDados1[08] } )
oSection1:Cell("DE")      	:SetBlock( { || aDados1[09] } )
oSection1:Cell("ATE")		:SetBlock( { || aDados1[10] } )
oSection1:Cell("TIPO")		:SetBlock( { || aDados1[11] } )


oReport:SetTitle("Faturamento")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()




Processa({|| StQuery( ) },"Compondo Relatorio")




dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:=	(cAliasLif)->C5_NUM
		aDados1[02]	:=	(cAliasLif)->C5_CLIENTE
		aDados1[03]	:= 	(cAliasLif)->C5_LOJACLI
		aDados1[04]	:=  (cAliasLif)->C5_XNOME
		aDados1[05]	:=	(cAliasLif)->EMISSAO
		aDados1[06]	:=	(cAliasLif)->LIQUIDO
		aDados1[07]	:=  (cAliasLif)->NVEND1
		aDados1[08]	:=  (cAliasLif)->NVEND2
		If Empty(Alltrim((cAliasLif)->C5_XMDE))
			aDados1[09]	:=  (cAliasLif)->C5_XDE
			aDados1[10]	:=  (cAliasLif)->C5_XATE
			aDados1[11]	:=  'Mensal'
		Else
			aDados1[09]	:=  (cAliasLif)->C5_XDE+'/'+(cAliasLif)->C5_XMDE+'/'+(cAliasLif)->C5_XDANO
			aDados1[10]	:=  (cAliasLif)->C5_XATE+'/'+(cAliasLif)->C5_XMATE+'/'+(cAliasLif)->C5_XAANO
			aDados1[11]	:=  'Intervalo'
			
		EndIf
		
		
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
cQuery += " C5_NUM,
cQuery += " C5_CLIENTE,
cQuery += " C5_LOJACLI,
cQuery += " C5_XNOME,
cQuery += " substr(C5_EMISSAO,7,2)||'/'||substr(C5_EMISSAO,5,2)||'/'||substr(C5_EMISSAO,1,4)
cQuery += ' "EMISSAO",
cQuery += " C5_VEND1||' - '||
cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_COD = C5_VEND1
cQuery += " AND SA3.A3_FILIAL = ' ' ),' ') 
cQuery += ' "NVEND1",
cQuery += " C5_VEND2||' - '||
cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_COD = C5_VEND2
cQuery += " AND SA3.A3_FILIAL = ' ' ),' ') 
cQuery += ' "NVEND2",
cQuery += " C5_XDE,
cQuery += " C5_XMDE,
cQuery += " C5_XATE,
cQuery += " C5_XMATE,C5_XAANO,C5_XDANO,

cQuery += " ROUND(NVL((SELECT SUM((C6_QTDVEN-C6_QTDENT)*(C6_ZVALLIQ/C6_QTDVEN))
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE C6_NUM = C5_NUM
cQuery += " AND SC6.D_E_L_E_T_ = ' '
cQuery += " AND SC6.C6_BLQ <> 'R'
cQuery += ' AND SC6.C6_FILIAL = SC5.C5_FILIAL),0),2) "LIQUIDO"


cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
cQuery += " WHERE (SC5.C5_XATE <> ' ' OR SC5.C5_XDE <> ' ')
cQuery += " AND SC5.D_E_L_E_T_ = ' '
cQuery += " AND   SC5.C5_EMISSAO BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"
cQuery += " AND 0 <
cQuery += " NVL((SELECT SUM(C6_QTDVEN-C6_QTDENT)
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE C6_NUM = C5_NUM
cQuery += " AND SC6.D_E_L_E_T_ = ' '
cQuery += " AND SC6.C6_BLQ <> 'R'
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL),0)

cQuery += " ORDER BY SC5.C5_NUM


cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

