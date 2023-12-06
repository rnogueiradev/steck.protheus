#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKR02	 ºAutor  ³Willian Borges     º Data ³  20/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para verificar o valor líquido da       º±±
±±º          ³reserva                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±ºAlteração³ Giovani Zago 21/10/13 query bichada sem os xfilial  dei tapaº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKR02()

Local oReport

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STTMKR02","RELATÓRIO DE VALOR LÍQUIDO DE RESERVA",/*Pergunta do Sx1*/,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de valor líquido de reserva.")
 
Pergunte("STTMKR02",.F.)

oSection := TRSection():New(oReport,"RESERVAS DOS PEDIDOS",{"SC5"})

TRCell():New(oSection,"PEDIDO","SC5","PEDIDO","@!",6)
TRCell():New(oSection,"VEND","SA3","VENDEDOR","@!",20)
TRCell():New(oSection,"EMISSAO","SC5","DT EMISSAO","@!",10)
TRCell():New(oSection,"DTFAB","SC5","DATA FAB","@!",10)
TRCell():New(oSection,"CLIENTE","SA1","CLIENTE","@!",20)
TRCell():New(oSection,"LOJA","SA1","LOJA","@!",02)
TRCell():New(oSection,"NOME","SA1","NOME CLIENTE","@!",20)
TRCell():New(oSection,"VALLIQ","SC6","VALOR LIQUIDO",PesqPict("SC6","C6_ZVALLIQ",20),)
TRCell():New(oSection,"VALRES","SC6","VALOR LIQUIDO RES","@E",10)
TRCell():New(oSection,"RESERVADO","PA2","%RESERVADO","@E",10)
TRCell():New(oSection,"VALFAL","PA1","VALOR LIQUIDO FALTA","@E",10)
TRCell():New(oSection,"FALTA","PA1","%FALTA","@E",10)
TRCell():New(oSection,"TIPOFAT","SC5","TIPOFAT","@E",10)
TRCell():New(oSection,"999","SC5","999","@E",3)
TRCell():New(oSection,"BLCRED","SC5","BL CRED?","@!",3)
TRCell():New(oSection,"XALERTF","SC5","ALERT FATUR?","@!",40)
oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SC5")
oSection:Setnofilter("SA3") 
oSection:Setnofilter("SA1")
oSection:Setnofilter("SC6")
oSection:Setnofilter("PA1")
oSection:Setnofilter("PA2")


Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local cQuery1 	:= ""
Local cAlias1 	:= "QRYTEMP1"
Local aDados[16]

oSection:Cell("PEDIDO"):SetBlock( { || aDados[1] } )
oSection:Cell("VEND"):SetBlock( { || aDados[2] } )
oSection:Cell("EMISSAO"):SetBlock( { || aDados[3] } )
oSection:Cell("DTFAB"):SetBlock( { || aDados[4] } )
oSection:Cell("CLIENTE"):SetBlock( { || aDados[5] } )
oSection:Cell("LOJA"):SetBlock( { || aDados[6] } )
oSection:Cell("NOME"):SetBlock( { || aDados[7] } )
oSection:Cell("VALLIQ"):SetBlock( { || aDados[8] } )
oSection:Cell("VALRES"):SetBlock( { || aDados[9] } )
oSection:Cell("RESERVADO"):SetBlock( { || aDados[10] } )
oSection:Cell("VALFAL"):SetBlock( { || aDados[11] } )
oSection:Cell("FALTA"):SetBlock( { || aDados[12] } )
oSection:Cell("TIPOFAT"):SetBlock( { || aDados[13] } )
oSection:Cell("999"):SetBlock( { || aDados[14] } )
oSection:Cell("BLCRED"):SetBlock( { || aDados[15] } )
oSection:Cell("XALERTF"):SetBlock( { || aDados[16] } )

oReport:SetTitle("RESERVAS DOS PEDIDOS")// Titulo do relatório

cQuery := "SELECT SC5.C5_NUM PEDIDO, SUBSTR(SA3.A3_NOME,1,30) VENDEDOR  ,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) EMISSAO, " 
cQuery += "CASE WHEN EXISTS (SELECT DB1.B1_GRUPO FROM "+RetSqlName("SC6")+" GC6 "
cQuery += "INNER JOIN(SELECT *  FROM "+RetSqlName("SB1")+" ) DB1 ON DB1.D_E_L_E_T_   = ' ' AND DB1.B1_COD    = GC6.C6_PRODUTO AND DB1.B1_FILIAL = ' ' AND DB1.B1_GRUPO = '999' "
cQuery += "WHERE GC6.D_E_L_E_T_   = ' ' AND GC6.C6_QTDVEN - GC6.C6_QTDENT > 0 "
cQuery += "AND SC5.C5_NUM      = GC6.C6_NUM AND SC5.C5_FILIAL   = GC6.C6_FILIAL GROUP BY DB1.B1_GRUPO) THEN 'SIM' ELSE 'NAO' END GRUPO, "
cQuery += "SUBSTR(SC5.C5_XDTFABR,7,2)||'/'|| SUBSTR(SC5.C5_XDTFABR,5,2)||'/'|| SUBSTR(SC5.C5_XDTFABR,1,4) DTPREVFAB, SC5.C5_CLIENTE CLIENTE, SC5.C5_LOJACLI LOJA, SUBSTR(SA1.A1_NOME ,1,45) NOME, "
cQuery += "SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2)) LIQUIDO, NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA2.PA2_QUANT),2)),0) RESLIQ, "
cQuery += "CASE WHEN NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA2.PA2_QUANT),2)),0) <> 0 THEN ROUND( (NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA2.PA2_QUANT),2)),0)*100)/SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2)),2) ELSE 0 END  RESERVADO, "
cQuery += "NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA1.PA1_QUANT),2)),0) FALLIQ, CASE  WHEN NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA1.PA1_QUANT),2)),0) <> 0 THEN ROUND( (NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA1.PA1_QUANT),2)),0)*100)/SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2)),2) ELSE 0 END FALTA, "
cQuery += "CASE WHEN SC5.C5_XTIPF ='1'THEN 'TOTAL' ELSE 'PARCIAL' END TIPOFAT ,SC5.C5_XALERTF AS XALERTF "
cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
cQuery += "INNER JOIN (SELECT * FROM "+RetSqlName("SC6")+" ) SC6 ON SC6.D_E_L_E_T_   = ' ' AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 AND SC5.C5_NUM      = SC6.C6_NUM AND SC5.C5_FILIAL   = SC6.C6_FILIAL "
cQuery += "LEFT  JOIN (SELECT * FROM "+RetSqlName("PA2")+" ) PA2 ON PA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM AND PA2.D_E_L_E_T_   = ' ' AND PA2.PA2_FILIAL   = '"+xFilial("PA2")+"' " 
cQuery += "LEFT  JOIN (SELECT * FROM "+RetSqlName("PA1")+" ) PA1 ON PA1.PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM AND PA1.D_E_L_E_T_   = ' ' AND PA1.PA1_FILIAL   = '"+xFilial("PA1")+"' " 
cQuery += "INNER JOIN (SELECT * FROM "+RetSqlName("SB1")+" ) SB1 ON SB1.D_E_L_E_T_   = ' ' AND SB1.B1_COD    = SC6.C6_PRODUTO AND SB1.B1_FILIAL = ' ' "
cQuery += "INNER JOIN (SELECT * FROM "+RetSqlName("SBM")+" ) SBM ON SBM.D_E_L_E_T_   = ' ' AND SBM.BM_GRUPO    = SB1.B1_GRUPO AND SBM.BM_FILIAL = ' ' "
cQuery += "INNER JOIN (SELECT * FROM "+RetSqlName("SA1")+" ) SA1 ON SA1.D_E_L_E_T_   = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = ' ' "
cQuery += "LEFT  JOIN (SELECT * FROM "+RetSqlName("SA3")+" ) SA3 ON SA3.D_E_L_E_T_   = ' ' AND SA3.A3_COD = SC5.C5_VEND2 AND SA3.A3_FILIAL = ' ' "
cQuery += "LEFT  JOIN (SELECT * FROM "+RetSqlName("PC1")+" ) PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' "
cQuery += "WHERE SC5.D_E_L_E_T_   = ' ' AND SC5.C5_EMISSAO >=  '20130329'  AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'  AND SC5.C5_NOTA NOT LIKE '%XXX%' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST    <> 'EX' AND SBM.BM_XAGRUP <> ' ' AND PC1.PC1_PEDREP IS NULL "
cQuery += "GROUP BY SC5.C5_NUM , SA3.A3_NOME, CASE WHEN EXISTS (SELECT DB1.B1_GRUPO FROM "+RetSqlName("SC6")+" GC6 "
cQuery += "INNER JOIN(SELECT *  FROM "+RetSqlName("SB1")+" ) DB1 ON DB1.D_E_L_E_T_   = ' ' AND DB1.B1_COD    = GC6.C6_PRODUTO AND DB1.B1_FILIAL = ' ' AND DB1.B1_GRUPO = '999' "
cQuery += "WHERE GC6.D_E_L_E_T_   = ' ' AND GC6.C6_QTDVEN - GC6.C6_QTDENT > 0 AND SC5.C5_NUM      = GC6.C6_NUM AND SC5.C5_FILIAL   = GC6.C6_FILIAL GROUP BY DB1.B1_GRUPO) "
cQuery += "THEN 'SIM' ELSE 'NAO' END, "
cQuery += "SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4)   , SUBSTR(SC5.C5_XDTFABR,7,2)||'/'|| SUBSTR(SC5.C5_XDTFABR,5,2)||'/'|| SUBSTR(SC5.C5_XDTFABR,1,4)   , SC5.C5_CLIENTE  , SC5.C5_LOJACLI , SA1.A1_NOME , SC5.C5_XTIPF,SC5.C5_XALERTF "
cQuery += "ORDER BY NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA2.PA2_QUANT),2)),0) "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While !(cAlias)->(Eof())

	cQuery1 := " SELECT COUNT(*) BLOQUEADO "
	cQuery1 += " FROM " +RetSqlName("SC9")+ " C9 "
	cQuery1 += " WHERE D_E_L_E_T_=' ' AND C9_FILIAL='"+xFilial("SC9")+"' AND C9_PEDIDO='"+(cAlias)->PEDIDO+"' AND C9_BLCRED IN ('02','04','09') "

	If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	
	aDados[1]	:=	(cAlias)->PEDIDO
	aDados[2]	:=	(cAlias)->VENDEDOR
	aDados[3]	:=	(cAlias)->EMISSAO
	aDados[4]	:=	(cAlias)->DTPREVFAB
	aDados[5]	:=	(cAlias)->CLIENTE
	aDados[6]	:=	(cAlias)->LOJA
	aDados[7]	:=	(cAlias)->NOME
	aDados[8]	:=	(cAlias)->LIQUIDO
	aDados[9]	:=	(cAlias)->RESLIQ
	aDados[10]	:=	(cAlias)->RESERVADO
	aDados[11]	:=	(cAlias)->FALLIQ
	aDados[12]	:=	(cAlias)->FALTA
	aDados[13]  :=  (cAlias)->TIPOFAT
	aDados[14]  :=  (cAlias)->GRUPO
	aDados[15]  :=  Iif((cAlias1)->BLOQUEADO>0,"SIM","NAO")
   	aDados[16]  :=  (cAlias)->XALERTF	
	oSection:PrintLine()
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

//oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

DbSelectArea(cAlias1)
(cAlias1)->(dbCloseArea())

Return oReport
