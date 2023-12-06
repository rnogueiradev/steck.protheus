#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STACDR02  ºAutor  ³Renato Nogueira    º Data ³  08/07/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este relatório tem por objetivo mostrar o status dos pedidosº±±
±±º          ³			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STACDR02()

Local oReport

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STACDR02","RELATÓRIO DE STATUS POR PEDIDO",,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de status dos pedidos em aberto.")

oSection := TRSection():New(oReport,"RELAÇÃO DE PEDIDOS",{"CB7"})

TRCell():New(oSection,"NUMERO" ,"CB7","PEDIDO","@!",6)
TRCell():New(oSection,"OS"     ,"CB7","OS"	  ,"@!",6)
TRCell():New(oSection,"STATUS" ,"CB7","STATUS","@!",1)
TRCell():New(oSection,"MOTIVO" ,"CB7","MOTIVO","@!",60)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("CB7")

Return oReport

Static Function ReportPrint(oReport)

Local oSection		:= oReport:Section(1)
Local nX			:= 0
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local aDados[4]

oSection:Cell("NUMERO"):SetBlock( { || aDados[1] } )
oSection:Cell("OS"):SetBlock( { || aDados[2] } )
oSection:Cell("STATUS"):SetBlock( { || aDados[3] } )
oSection:Cell("MOTIVO"):SetBlock( { || aDados[4] } )

oReport:SetTitle("Pedidos em aberto")// Titulo do relatório

cQuery := " SELECT PEDIDO, OS, STATUSS, MOTIVO "
cQuery += " FROM ( "
cQuery += " SELECT CB7_PEDIDO PEDIDO, CB7_ORDSEP OS, '1' STATUSS, 'EMBALAGEM INICIADA E NÃO FINALIZADA' MOTIVO "
cQuery += " FROM " +RetSqlName("CB7") "
cQuery += " B7 LEFT JOIN " +RetSqlName("CB8") "
cQuery += " B8 ON B7.CB7_FILIAL=B8.CB8_FILIAL AND B7.CB7_ORDSEP=B8.CB8_ORDSEP "
cQuery += " WHERE B7.D_E_L_E_T_=' ' AND B8.D_E_L_E_T_=' ' AND CB7_STATUS='2' AND CB8_SALDOS=0 AND CB8_SALDOE>0 AND CB8_SALDOE<CB8_QTDORI AND CB7_FILIAL='01' "
cQuery += " ORDER BY B7.CB7_PEDIDO "
cQuery += " ) UNION SELECT PEDIDO, OS, STATUSS, MOTIVO "
cQuery += " FROM ( "
cQuery += " SELECT CB7_PEDIDO PEDIDO, CB7_ORDSEP OS, '2' STATUSS, 'EMBALAGEM FINALIZADA SEM NF' MOTIVO "
cQuery += " FROM " +RetSqlName("CB8") "
cQuery += " B8 LEFT JOIN " +RetSqlName("CB7") "
cQuery += " B7 ON B7.CB7_FILIAL=B8.CB8_FILIAL AND B7.CB7_ORDSEP=B8.CB8_ORDSEP "
cQuery += " LEFT JOIN " +RetSqlName("SC9") "
cQuery += " C9 ON B8.CB8_FILIAL=C9.C9_FILIAL AND B8.CB8_PEDIDO=C9.C9_PEDIDO AND B8.CB8_ITEM=C9.C9_ITEM AND B8.CB8_SEQUEN=C9.C9_SEQUEN "
cQuery += " WHERE B7.D_E_L_E_T_=' ' AND B8.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' ' AND CB7_STATUS='4' AND CB8_SALDOS=0 AND CB8_SALDOE=0 AND C9_NFISCAL=' ' AND CB7_FILIAL='01' "
cQuery += " GROUP BY CB7_PEDIDO, CB7_ORDSEP "
cQuery += " ORDER BY B7.CB7_PEDIDO "
cQuery += " ) UNION SELECT PEDIDO, OS, STATUSS, MOTIVO "
cQuery += " FROM ( "
cQuery += " SELECT CB7_PEDIDO PEDIDO, CB7_ORDSEP OS, '3' STATUSS, 'EMBALAGEM FINALIZADA E SEM ROMANEIO OU ROMANEIO EM ABERTO' MOTIVO "
cQuery += " FROM " +RetSqlName("CB8") "
cQuery += " B8 LEFT JOIN " +RetSqlName("CB7") "
cQuery += " B7 ON B7.CB7_FILIAL=B8.CB8_FILIAL AND B7.CB7_ORDSEP=B8.CB8_ORDSEP "
cQuery += " LEFT JOIN " +RetSqlName("SC9") "
cQuery += " C9 ON B8.CB8_FILIAL=C9.C9_FILIAL AND B8.CB8_PEDIDO=C9.C9_PEDIDO AND B8.CB8_ITEM=C9.C9_ITEM AND B8.CB8_SEQUEN=C9.C9_SEQUEN "
cQuery += " WHERE B7.D_E_L_E_T_=' ' AND B8.D_E_L_E_T_=' '  AND C9.D_E_L_E_T_=' ' AND CB8_SALDOS=0 AND CB8_SALDOE=0 AND C9_NFISCAL<>' ' AND CB7_FILIAL='01' "
cQuery += " AND (C9_NFISCAL NOT IN (SELECT PD2_NFS  FROM PD2010 WHERE D_E_L_E_T_=' ') "
cQuery += " OR C9_NFISCAL IN (SELECT PD2_NFS FROM PD2010 WHERE D_E_L_E_T_=' ' AND PD2_STATUS IN ('0','1'))) "
cquery += " GROUP BY CB7_PEDIDO, CB7_ORDSEP "
cQuery += " ORDER BY B7.CB7_PEDIDO) "
cQuery += " ORDER BY STATUSS, PEDIDO "

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

	If Val((cAlias)->OS)>020000
	
	aDados[1]	:=	(cAlias)->PEDIDO
	aDados[2]	:=	(cAlias)->OS
	aDados[3]	:=	(cAlias)->STATUSS
	aDados[4]	:=	(cAlias)->MOTIVO
	
	oSection:PrintLine()
	aFill(aDados,nil)
	
	EndIf
	
	(cAlias)->(DbSkip())
	
EndDo

oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport
