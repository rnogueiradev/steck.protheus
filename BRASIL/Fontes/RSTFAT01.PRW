#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT01     บAutor  ณGiovani Zago    บ Data ณ  17/03/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Pedidos Aptos a Faturar                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT01()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT01"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Pedidos Aptos a Faturar
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
	
	oReport := TReport():New(cPergTit,"RELATำRIO de Pedidos Aptos a Faturar",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Pedidos Aptos a Faturar")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Aptos a Faturar",{"SC5"})
	TRCell():New(oSection,"Filial"	  	,,"Filial"		,,2,.F.,)
	TRCell():New(oSection,"Pedido"  	,,"Pedido"		,,6,.F.,)
	TRCell():New(oSection,"Emissใo"	  	,,"Emissใo"		,,10,.F.,)
	TRCell():New(oSection,"Cliente"		,,"Cliente"		,,6,.F.,)
	TRCell():New(oSection,"NOME"	  	,,"NOME"		,,25,.F.,)
	TRCell():New(oSection,"Cond"  		,,"Cond"	   	,,5,.F.,)
	TRCell():New(oSection,"Nome_cond"	,,"Nome_cond"	,,15,.F.,)
	TRCell():New(oSection,"TRANSP"  	,,"TRANSP"		,,6,.F.,)
	TRCell():New(oSection,"NOME_TRANS"	,,"NOME_TRANS"	,,25,.F.,)
	TRCell():New(oSection,"Estado"  	,,"Estado"		,,2,.F.,)
	TRCell():New(oSection,"Tipo"        ,,"Tipo"		,,10,.F.,)
	TRCell():New(oSection,"OBS"	  	    ,,"OBS"			,,50,.F.,)
	TRCell():New(oSection,"VEND"		,,"VEND"		,,25,.F.,)
	TRCell():New(oSection,"VAL_FAT"     ,,"VAL_FAT"	,"@E 99,999,999.99",14)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")
	
	
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                  บฑฑ
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
	Local aDados1[14]
	Local _cSta 	:= ''
	Local nValFat := 0
	
	
	
	oSection1:Cell("Filial")    	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("Pedido")  		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Emissใo")  		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Cliente")       :SetBlock( { || aDados1[04] } )
	oSection1:Cell("NOME")    		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Cond")    	    :SetBlock( { || aDados1[06] } )
	oSection1:Cell("Nome_cond")  	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("TRANSP")        :SetBlock( { || aDados1[08] } )
	oSection1:Cell("NOME_TRANS")    :SetBlock( { || aDados1[09] } )
	oSection1:Cell("Estado")    	:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Tipo")    		:SetBlock( { || aDados1[11] } )
	oSection1:Cell("OBS")    		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("VEND")    		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("VAL_FAT")    	:SetBlock( { || aDados1[14] } )
	
	oReport:SetTitle("Pedidos Aptos a Faturar")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	Processa({|| StQuery( ) },"Compondo Relatorio")
	
	
	_cNum:=(cAliasLif)->C5_NUM
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			nValFat	:= round(STFATLIQ((cAliasLif)->C5_FILIAL,(cAliasLif)->C5_NUM),0)
			aDados1[01]	:=	(cAliasLif)->C5_FILIAL
			aDados1[02]	:= 	(cAliasLif)->C5_NUM
			aDados1[03]	:=  Stod((cAliasLif)->C5_EMISSAO)
			aDados1[04]	:= 	(cAliasLif)->C5_CLIENTE
			aDados1[05]	:=  (cAliasLif)->A1_NOME
			aDados1[06]	:=	(cAliasLif)->C5_CONDPAG
			aDados1[07]	:= 	(cAliasLif)->E4_DESCRI
			aDados1[08]	:=  (cAliasLif)->C5_TRANSP
			aDados1[09]	:= 	(cAliasLif)->A4_NOME
			aDados1[10]	:=  (cAliasLif)->A1_EST
			aDados1[11]	:=	(cAliasLif)->C5_TIPOCLI
			aDados1[12]	:= 	(cAliasLif)->C5_XALERTF
			aDados1[13]	:= 	(cAliasLif)->VEND
			aDados1[14]	:= nValFat
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
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                          บฑฑ
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
	Local cMV_XSTCLI	:= SuperGetMV("MV_XSTCLI3",.F.,"033467") // Alterado pelo chamado 006007 - Robson Mazzarotto
	Local aTipo 		:= {"1 - Consumidor Final","2 - Revendedor","3 - Solidแrio"}
	Local cItem 		:= space(20)
	Local oDxlg
	
	cQuery := "  SELECT SC5.C5_FILIAL,SC5.C5_NUM, SC5.C5_TRANSP ,SC5.C5_CONDPAG ,SC5.C5_XTIPO,SC5.C5_EMISSAO,SC5.C5_CLIENTE, SC5.C5_LOJACLI,TE4.E4_DESCRI, SC5.C5_TRANSP, TA1.A1_NOME,TA4.A4_NOME, SC5.C5_XALERTF, TA1.A1_EST, SC5.C5_TIPOCLI"
	cQuery += " ,C5_VEND2||' - '||
	cQuery += " NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = C5_VEND2
	cQuery += " AND SA3.A3_FILIAL = ' ' ),' ')
	cQuery += ' "VEND"
	cQuery += "  FROM "+RetSqlName("SC5")+" SC5  "
	cQuery += " INNER JOIN ( SELECT *
	cQuery += "  FROM "+RetSqlName("SC6")+" SC6  "
	cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.D_E_L_E_T_ <> '*')TC6
	cQuery += " ON TC6.C6_NUM = SC5.C5_NUM
	
	cQuery += " INNER JOIN ( SELECT F4_CODIGO ,F4_ESTOQUE,F4_FILIAL
	cQuery += "  FROM "+RetSqlName("SF4")+" SF4  "
	cQuery += " WHERE SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND SF4.D_E_L_E_T_ <> '*')TF4
	cQuery += " ON TF4.F4_CODIGO = TC6.C6_TES
	cQuery += " AND TF4.F4_ESTOQUE  = '"+iif(MV_PAR07=1,'S','N')+"'"
	
	
	cQuery += " INNER JOIN ( SELECT C9_PEDIDO ,C9_FILIAL,C9_ITEM  ,C9_NFISCAL
	cQuery += "  FROM "+RetSqlName("SC9")+" SC9  "
	cQuery += " WHERE SC9.C9_FILIAL =  '"+xFilial("SC9")+"'"
	cQuery += " AND SC9.D_E_L_E_T_ <>  '*')TC9
	cQuery += " ON TC9.C9_PEDIDO = TC6.C6_NUM
	cQuery += " AND TC9.C9_ITEM     = TC6.C6_ITEM
	cQuery += " AND TC9.C9_NFISCAL = '         '
	
	
	If MV_PAR07=1
		cQuery += " INNER JOIN ( SELECT CB7_STATUS,CB7_NOTA,CB7_PEDIDO ,CB7_FILIAL
		cQuery += "  FROM "+RetSqlName("CB7")+" CB7  "
		cQuery += " WHERE CB7.CB7_FILIAL =  '"+xFilial("CB7")+"'"
		cQuery += " AND CB7.D_E_L_E_T_ <>  '*')TB7
		cQuery += " ON TB7.CB7_PEDIDO   = TC9.C9_PEDIDO
		cQuery += " AND TB7.CB7_NOTA = '         '
		cQuery += " AND TB7.CB7_STATUS = '4'
	EndIf
	
	cQuery += " INNER JOIN ( SELECT E4_FILIAL ,E4_CODIGO,E4_DESCRI
	cQuery += "  FROM "+RetSqlName("SE4")+" SE4  "
	cQuery += " WHERE SE4.E4_FILIAL = '"+xFilial("SE4")+"'"
	cQuery += " AND SE4.D_E_L_E_T_ <> '*')TE4
	cQuery += " ON TE4.E4_CODIGO = SC5.C5_CONDPAG
	
	cQuery += " INNER JOIN ( SELECT A1_COD,A1_LOJA ,A1_NOME , A1_EST
	cQuery += "  FROM "+RetSqlName("SA1")+" SA1  "
	cQuery += " WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND SA1.D_E_L_E_T_ <> '*')TA1
	cQuery += " ON TA1.A1_COD = SC5.C5_CLIENTE
	cQuery += " AND TA1.A1_LOJA = SC5.C5_LOJACLI
	
	cQuery += " LEFT JOIN ( SELECT A4_FILIAL,A4_COD,A4_NOME
	cQuery += " FROM "+RetSqlName("SA4")+" SA4  "
	cQuery += " WHERE SA4.A4_FILIAL  = '"+xFilial("SA4")+"'"
	cQuery += " AND SA4.D_E_L_E_T_ <> '*')TA4
	cQuery += " ON TA4.A4_COD = SC5.C5_TRANSP
	
	
	cQuery += " WHERE SC5.C5_FILIAL =  '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_EMISSAO BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND SC5.C5_NUM            BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery += " AND SC5.C5_TRANSP      BETWEEN '" + MV_PAR03 + "' AND '" +MV_PAR04 + "' "
	cQuery += " AND SC5.C5_CONDPAG    BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	
	
	If MV_PAR08=3 //Braspress - Renato Nogueira - Chamado 000130 - 28/01/2014
		cQuery += " AND TA4.A4_COD = '000163' "
	EndIf
	
	If MV_PAR08<=2 //Retira ou entrega - Renato Nogueira - Chamado 000130 - 28/01/2014
		cQuery += " AND SC5.C5_XTIPO     = '"+IIF(MV_PAR08=1,'1','2')+"'"
		cQuery += " AND TA4.A4_NOME NOT LIKE '%BRASPRESS%' "
	EndIf
	
	lSaida:= .f.
	aTipo:= {"1 - Leroy","2 - C&C","3 - Telha Norte"}
	cItem:= space(20)
	If MV_PAR08=5
	
		Do While !lSaida
									
			Define msDialog oDxlg Title "Informe o Cliente:" From 10,10 TO 150,200 Pixel
				
			@ 010,010 COMBOBOX cItem ITEMS aTipo SIZE 80,80
				
			DEFINE SBUTTON FROM 030,030 TYPE 1 ACTION IF(!(Empty(alltrim(cItem))),(lSaida:=.T.,oDxlg:End()),msgInfo("Tipo de Cliente nใo preenchido","Aten็ใo")) ENABLE OF oDxlg
				
			Activate dialog oDxlg centered
				
		EndDo
		
		If	Substr(cItem,1,1) = '1'
			cQuery += " AND SC5.C5_CLIENTE='038134' "
		ElseIf	Substr(cItem,1,1) = '2'
			cQuery += " AND SC5.C5_CLIENTE='014519' "
		ElseIf	Substr(cItem,1,1) = '3'
			cQuery += " AND SC5.C5_CLIENTE='028358' "
		Endif
	
	
	
	Else
	
		cQuery += " AND SC5.C5_CLIENTE<>'038134' "
		cQuery += " AND SC5.C5_CLIENTE<>'014519' "
		cQuery += " AND SC5.C5_CLIENTE<>'028358' "
	
	EndIf
	
/*	
	If MV_PAR08=5 //Leroy - Renato Nogueira - Chamado 002278
		cQuery += " AND SC5.C5_CLIENTE='038134' "
	EndIf
	
	If MV_PAR08<>5 //Leroy - Renato Nogueira - Chamado 002278
		cQuery += " AND SC5.C5_CLIENTE<>'038134' "
	EndIf
	*/
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' "//Giovani.zago 07/06/2013 Joao Victor excluir pedidos de importa็ใo no relatorio. mit006
	cQuery += " AND SC5.C5_ZREFNF = ' ' "//Giovani.zago 20/06/2013 BLOQUEAR REFATURAMENTO EMQUANTO NAO LIBERAR
	cQuery += " AND SC5.C5_CLIENTE||SC5.C5_LOJACLI NOT LIKE'"+cMV_XSTCLI+"'" // Adicionado pelo Chamado 006007 - Robson Mazzarotto
	
	cQuery += " AND NOT EXISTS (SELECT *
	cQuery += " FROM "+RetSqlName("CB7")+" WB7
	cQuery += " WHERE WB7.CB7_FILIAL =   '"+xFilial("CB7")+"'"
	cQuery += " AND WB7.D_E_L_E_T_ <>  '*'
	cQuery += " AND WB7.CB7_PEDIDO   = SC5.C5_NUM
	cQuery += " AND WB7.CB7_NOTA = '         '
	cQuery += " AND (WB7.CB7_STATUS =  '1'
	cQuery += " OR WB7.CB7_STATUS =  '2'
	cQuery += " OR WB7.CB7_STATUS =  '0' "//giovani zago 09/04/14 chamado
	cQuery += " OR WB7.CB7_STATUS =  '3'))
	
	cQuery += " Group by SC5.C5_FILIAL,SC5.C5_NUM, SC5.C5_TRANSP ,SC5.C5_CONDPAG ,SC5.C5_XTIPO,SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI,TE4.E4_DESCRI, SC5.C5_TRANSP, TA1.A1_NOME, TA4.A4_NOME, SC5.C5_XALERTF, TA1.A1_EST, SC5.C5_TIPOCLI, C5_VEND2 "
	
	If MV_PAR11=1
		cQuery += " Order by SC5.C5_NUM  "
	ElseIf MV_PAR11=2
		cQuery += " Order by SC5.C5_EMISSAO "
	ElseIf MV_PAR11=3
		cQuery += " Order by SC5.C5_TRANSP "
	EndIf
	
	
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
ฑฑบPrograma  ณ STFATLIQ บAutor  ณRenato Nogueira     บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcular valor liquido a faturar							  บฑฑ
ฑฑบ          ณ  								                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STFATLIQ(cFil,cPed)
	
	Local nVal		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	
	cQuery := " SELECT SUM(C6_ZVALLIQ/C6_QTDVEN*C9_QTDLIB) VALOR "
	cQuery += " FROM "+RetSqlName("SC9")+ " C9 "
	cQuery += " LEFT JOIN "+RetSqlName("SC6")+ " C6 "
	cQuery += " ON C9_FILIAL=C6_FILIAL AND C9_PEDIDO=C6_NUM AND C9_ITEM=C6_ITEM AND C9_CLIENTE=C6_CLI AND C9_LOJA=C6_LOJA "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' ' AND C9_NFISCAL=' ' AND C9_ORDSEP<>' ' AND C9_PEDIDO='"+cPed+"' AND C9_FILIAL='"+cFil+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	nVal	:= (cAlias)->VALOR
	
Return(nVal)
