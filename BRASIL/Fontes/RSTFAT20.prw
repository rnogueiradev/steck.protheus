#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT20     ºAutor  ³Giovani Zago    º Data ³  06/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Alçada de desconto			                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT20()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT20"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	
	
	
	
	PutSx1(cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Do Vendedor:" ,"Do Vendedor: ?" ,"Do Vendedor: ?" 			   	,"mv_ch3","C",6,0,0,"G","",'SA3' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 			,"mv_ch4","C",6,0,0,"G","",'SA3' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Do Pedido:" ,"Do Pedido: ?" ,"Do Pedido: ?" 			   	    ,"mv_ch5","C",6,0,0,"G","",'SC5' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Pedido:" ,"Ate Pedido: ?" ,"Ate Pedido: ?" 			    ,"mv_ch6","C",6,0,0,"G","",'SC5' ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Do Supervisor:" ,"Do Aprovador: ?" ,"Do Aprovador: ?" 			,"mv_ch7","C",6,0,0,"G","",'SA3' ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "08", "Ate Supervisor:" ,"Ate Aprovador: ?" ,"Ate Aprovador: ?" 		,"mv_ch8","C",6,0,0,"G","",'SA3' ,"","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "09", "Do Cliente:" ,"Do Cliente: ?" ,"Do Cliente: ?" 			    ,"mv_ch9","C",6,0,0,"G","",'SA1' ,"","","mv_par09","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "10", "Ate Cliente:" ,"Ate Cliente: ?" ,"Ate Cliente: ?" 		        ,"mv_chA","C",6,0,0,"G","",'SA1' ,"","","mv_par10","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "11", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"             ,"mv_chB","N",1,0,0,"C","",''    ,'','',"mv_par11","Desconto","","","","Aprovador","","","Cliente","","","","","","","")
	PutSx1(cPerg, "12", "Status:","Ordenar Por  :","Ordenar Por   :"             		,"mv_chC","N",1,0,0,"C","",''    ,'','',"mv_par12","Aprovadas","","","","Em Analise","","","Todas","","","","","","","")
	
	
	oReport		:= ReportDef()
 oReport:PrintDialog()
	
Return

Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cAliasLif,"RELATÓRIO Alçada Comercial",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Alçada Comercial")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Alçada Comercial",{"ZZI"})
	
	TRCell():New(oSection,"Status"	  ,,"Status"	,,10,.F.,)
	TRCell():New(oSection,"Tipo"	  ,,"Tipo"		,,09,.F.,)
	TRCell():New(oSection,"Pedido"	  ,,"Numero"	,,06,.F.,)
	TRCell():New(oSection,"Data"	  ,,"Data"		,,10,.F.,)
	TRCell():New(oSection,"Cliente"	  ,,"Cliente"	,,06,.F.,)
	TRCell():New(oSection,"Nome"	  ,,"Nome"		,,40,.F.,)
	TRCell():New(oSection,"Vendedor"  ,,"Representante"	,,06,.F.,)
	TRCell():New(oSection,"Vendedor2"  ,,"Vendedor"	,,40,.F.,)
	TRCell():New(oSection,"Obs_Vend"  ,,"Obs_Vend"	,,40,.F.,)
	TRCell():New(oSection,"Aprovador" ,,"Area"		,,40,.F.,)
	TRCell():New(oSection,"Grupo"	  ,,"Grupo"		,,10,.F.,)
	TRCell():New(oSection,"Apr"	  	  ,,"Aprovador"	,,12,.F.,)
	TRCell():New(oSection,"Obs_Apr"	  ,,"Obs_Apr"	,,40,.F.,)
	TRCell():New(oSection,"Markup"    ,,"Fator"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Custo"     ,,"Custo"	    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Total"     ,,"Total"	    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Desconto"  ,,"Vlr.Des."	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Desp"  	  ,,"%Des."		,"@E 99,999,999.99",14)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("ZZI")
	
Return oReport

Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1[99]
	
	
	
	oSection1:Cell("Pedido")    :SetBlock( { || aDados1[01] } )
	oSection1:Cell("Cliente")	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Nome")	    :SetBlock( { || aDados1[03] } )
	oSection1:Cell("Vendedor")	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Obs_Vend")  :SetBlock( { || aDados1[05] } )
	oSection1:Cell("Aprovador")	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("Obs_Apr")	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Markup")	:SetBlock( { || aDados1[08] } )
	oSection1:Cell("Custo")     :SetBlock( { || aDados1[09] } )
	oSection1:Cell("Total")		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Desconto")	:SetBlock( { || aDados1[11] } )
	oSection1:Cell("Vendedor2")	:SetBlock( { || aDados1[12] } )
	oSection1:Cell("Tipo")		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("Data")		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("Grupo")		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("Apr")		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("Desp")		:SetBlock( { || aDados1[17] } )
	oSection1:Cell("Status")	:SetBlock( { || aDados1[18] } )
	
	oReport:SetTitle("Faturamento Vend.Interno")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	
	
	rptstatus({|| strelquer( ) },"Compondo Relatorio")
	
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			aDados1[13]	:=	(cAliasLif)->TIPO
			aDados1[01]	:=	(cAliasLif)->Pedido
			aDados1[14]	:=	(cAliasLif)->DATAE
			aDados1[02]	:=	(cAliasLif)->Cliente
			aDados1[03]	:=	(cAliasLif)->Nome
			aDados1[04]	:=	(cAliasLif)->Vendedor
			aDados1[12]	:=	(cAliasLif)->Vendedor2
			aDados1[05]	:=	(cAliasLif)->Obs
			aDados1[06]	:=	(cAliasLif)->Aprovador
			aDados1[07]	:=	(cAliasLif)->Obs_Apr
			aDados1[08]	:=	(cAliasLif)->Markup
			aDados1[09]	:=	(cAliasLif)->Custo
			aDados1[10]	:=	(cAliasLif)->Total
			aDados1[11]	:=	(cAliasLif)->Desconto
			aDados1[15]	:=	(cAliasLif)->GRUPO
			aDados1[16]	:=	(cAliasLif)->APR
			aDados1[17]	:=	(cAliasLif)->DESP
			aDados1[18]	:=	(cAliasLif)->STATU
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			
			(cAliasLif)->(dbskip())
			
		End
		
		
	EndIf
	
	
	
	oReport:SkipLine()
	
	
	
	
Return oReport


//SELECIONA OS PRODUTOS
Static Function strelquer()
	Local aAreaSM0   := SM0->(GETAREA())
	Local cQuery     := ' '
	Local cEmpresas  := ''
	
	
	
	
	cQuery := " SELECT
	cQuery += " ZZI_NUM
	cQuery += ' "Pedido",
	cQuery += " ZZI_CLIENT
	cQuery += ' "Cliente",
	cQuery += " ZZI_USERAP
	cQuery += ' "APR",
	
	cQuery += " ZZI_TIPO
	cQuery += ' "TIPO",
	cQuery += " SUBSTR(ZZI_DATA,7,2)||'/'|| SUBSTR(ZZI_DATA,5,2)||'/'|| SUBSTR(ZZI_DATA,1,4)
	cQuery += ' "DATAE",
	cQuery += " ZZI_NOMECL
	cQuery += ' "Nome",
	cQuery += " ZZI_VEND1 "//||' - '||ZZI_NVEND1
	cQuery += ' "Vendedor",
	
	cQuery += " ZZI_VEND2 ||' - '||ZZI_NVEND2
	cQuery += ' "Vendedor2",
	
	cQuery += " ZZI_OBSVEN
	cQuery += ' "Obs",
	cQuery += " ZZI_SUPER||' - '||nvl((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=ZZI_SUPER) ,'') "
	cQuery += ' "Aprovador",
	cQuery += " ZZI_RASTRO
	cQuery += ' "Obs_Apr",
	
	cQuery += " ZZI_MARKUP
	cQuery += ' "Markup",
	cQuery += " ZZI_CUSTO
	cQuery += ' "Custo",
	cQuery += " ZZI_VALOR
	cQuery += ' "Total",
	
	cQuery += " CASE WHEN  ZZI_BLQ = '1' THEN  'APROVADO' ELSE CASE WHEN  ZZI_BLQ = '3' THEN  'REJEITADO'   ELSE 'EM ANALISE' END END
	cQuery += ' "STATU",
	
	cQuery += " ZZI_DESTOT
	cQuery += ' "DESP",
	cQuery += " ZZI_GRP
	cQuery += ' "GRUPO",
	cQuery += " ZZI_DESCON
	cQuery += ' "Desconto"
	
	
	
	cQuery += " FROM "+RetSqlName("ZZI")+" ZZI "
	
	cQuery += " WHERE ZZI.ZZI_DATA BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND ZZI.D_E_L_E_T_ = ' '
	cQuery += " AND ZZI.ZZI_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += " AND ZZI.ZZI_NUM   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND ZZI.ZZI_SUPER BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND ZZI.ZZI_CLIENT BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	
	If MV_PAR12 = 1
		cQuery += " AND ZZI.ZZI_BLQ = '1'
	ElseIf MV_PAR12 = 2
		cQuery += " AND ZZI.ZZI_BLQ = '2'
	EndIf
	
	
	If MV_PAR11 = 1
		cQuery += ' ORDER BY ZZI_DESCON
	ElseIf MV_PAR11 = 2
		cQuery += ' ORDER BY ZZI_SUPER
	ElseIf MV_PAR11 = 3
		cQuery += ' ORDER BY ZZI_CLIENT
	EndIf
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

