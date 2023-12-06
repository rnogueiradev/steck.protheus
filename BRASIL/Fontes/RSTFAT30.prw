#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RSTFAT30	ºAutor  ³Renato Nogueira     º Data ³  12/03/14   º±±
±±ºAlterado  ³RSTFAT30	ºAutor  ³Eduardo Sigamat     º Data ³  02/12/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio utilizado para listar as OS com operadores        º±±
±±º          ³com os status de não iniciada e iniciada				      º±±
±±º          ³															  º±±
±±º          ³Ticket 20200403001445 - Adequação Rel. Sep por Operador	  º±±
±±º          ³1. Tratamento para nao sair Pedidos ZERADOS.				  º±±
±±º          ³2. Totalizadores das Colunas.				      			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RSTFAT30()

Local oReport

PutSx1("RSTFAT30", "01","Operador de?" ,"","","mv_ch1","C",6,0,0,"G","","CB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("RSTFAT30", "02","Operador ate?","","","mv_ch2","C",6,0,0,"G","","CB1","","","mv_par02","","","","","","","","","","","","","","","","")

oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection
Local oSection1
Local oSection2

oReport := TReport():New("RSTFAT30","RELATÓRIO DE OPERADORES","RSTFAT30",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de operadores.")

Pergunte("RSTFAT30",.F.)
                                                         
oSection  := TRSection():New(oReport,"OPERADORES",{"CB7"})
oSection1 := TRSection():New(oReport,"DATA",	 {"CB7"})
oSection2 := TRSection():New(oReport,"TOTAL",	 {"CB7"})

TRCell():New(oSection1,"DATA" 		,"CB1","DATA ULT EMISSAO"			,"@!",40)
TRCell():New(oSection1,"HORA" 		,"CB1","DATA ULT EMISSAO"	 		,"@!",40)

TRCell():New(oSection,"OPER" 		,"CB1","OPERADOR"			 		,"@!",6)
TRCell():New(oSection,"NOME" 		,"CB1","NOME"				 		,"@!",30)
TRCell():New(oSection,"PEDTOT" 		,"CB1","TOTAL PEDIDOS"		 		,"@E",5)
TRCell():New(oSection,"LINTOT" 		,"CB1","TOTAL LINHAS"		 		,"@E",5)
TRCell():New(oSection,"PECTOT" 		,"CB1","TOTAL PECAS"		 		,"@E",5)
TRCell():New(oSection,"VALLIQ" 		,"CB1","VALOR LIQ"		 			,"@E",7)

TRCell():New(oSection2,"" 			,""	  ,""			 				,"@!",6)
TRCell():New(oSection2,"" 			,""	  ,""				 			,"@!",30)
TRCell():New(oSection2,"TOTPEDTOT" 	,"CB1","QTDE TOTAL PEDIDOS" 		,"@E",5)
TRCell():New(oSection2,"TOTLINTOT" 	,"CB1","QTDE TOTAL LINHAS"	 		,"@E",5)
TRCell():New(oSection2,"TOTPECTOT" 	,"CB1","QTDE TOTAL PECAS"		 	,"@E",5)
TRCell():New(oSection2,"TOTVALLIQ" 	,"CB1","TOTAL VALOR LIQ"		   	,"@E",7)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("CB1")

oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("CB1")

oSection2:SetHeaderSection(.T.)
oSection2:Setnofilter("CB1")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(2)
Local oSection2	:= oReport:Section(3)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[7]
Local cData		:= ""
Local cHora		:= ""
Local nTotPed	:= 0
Local nTotLin	:= 0
Local nTotPec	:= 0
Local nTotVal	:= 0

oSection1:Cell("DATA")   	:SetBlock( { || cData } )
oSection1:Cell("HORA")   	:SetBlock( { || cHora } )

oSection:Cell("OPER")   	:SetBlock( { || aDados[2] } )
oSection:Cell("NOME")  		:SetBlock( { || aDados[3] } )
oSection:Cell("PEDTOT")  	:SetBlock( { || aDados[4] } )
oSection:Cell("LINTOT")  	:SetBlock( { || aDados[5] } )
oSection:Cell("PECTOT")  	:SetBlock( { || aDados[6] } )
oSection:Cell("VALLIQ")  	:SetBlock( { || aDados[7] } )

oSection2:Cell("TOTPEDTOT")  :SetBlock( { || nTotPed } )
oSection2:Cell("TOTLINTOT")  :SetBlock( { || nTotLin } )
oSection2:Cell("TOTPECTOT")  :SetBlock( { || nTotPec } )
oSection2:Cell("TOTVALLIQ")  :SetBlock( { || nTotVal } )

oReport:SetTitle("Lista operadores")// Titulo do relatório

cQuery := " SELECT CB1_FILIAL FILIAL, CB1_CODOPE OPERADOR, CB1_NOME NOME, "
cQuery += " 	SUM((SELECT COUNT(CB7_XOPEXP) "
cQuery += " 	 	 FROM " + RetSqlName("CB7")
cQuery += " 	 	 WHERE D_E_L_E_T_ = ' ' "
cQuery += " 	 		AND CB7_FILIAL = '" + xFilial("CB7") + "' "
cQuery += " 			AND CB7_STATUS IN ('0','1') "
cQuery += " 			AND CB7_XOPEXP = CB1_CODOPE)) TOTALPEDIDO, "
cQuery += " 	SUM((SELECT COUNT(CB8_PROD) "
cQuery += " 	 	 FROM " + RetSqlName("CB8") + " CB8 "
cQuery += " 	 	 LEFT JOIN " + RetSqlName("CB7") + " CB7 "
cQuery += " 	 	 ON CB7_FILIAL = CB8_FILIAL AND CB7_ORDSEP = CB8_ORDSEP "
cQuery += " 	 	 WHERE CB7.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB8.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB7_FILIAL = '" + xFilial("CB7") + "' "
cQuery += " 			AND CB7_STATUS IN ('0','1') "
cQuery += " 			AND CB7_XOPEXP = CB1_CODOPE )) TOTALLINHAS, "
cQuery += " 	SUM((SELECT SUM(CB8_QTDORI) "
cQuery += " 	 	 FROM " + RetSqlName("CB8") + " CB8 "
cQuery += " 	 	 LEFT JOIN " + RetSqlName("CB7") + " CB7 "
cQuery += " 	 	 ON CB7_FILIAL = CB8_FILIAL AND CB7_ORDSEP = CB8_ORDSEP "
cQuery += " 	 	 WHERE CB7.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB8.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB7_FILIAL = '" + xFilial("CB7") + "' "
cQuery += " 			AND CB7_STATUS IN ('0','1') "
cQuery += " 			AND CB7_XOPEXP = CB1_CODOPE )) TOTALPECAS, "
cQuery += " 	SUM((SELECT SUM(C6_ZVALLIQ/C6_QTDVEN*CB8_QTDORI) "
cQuery += " 	 	 FROM " + RetSqlName("CB8") + " CB8 "
cQuery += " 	 	 LEFT JOIN " + RetSqlName("CB7") + " CB7 "
cQuery += " 	 	 ON CB7_FILIAL = CB8_FILIAL AND CB7_ORDSEP = CB8_ORDSEP "
cQuery += " 	 	 LEFT JOIN " + RetSqlName("SC6") + " C6 "
cQuery += " 	 	 ON CB8_FILIAL = C6_FILIAL AND CB8_ITEM = C6_ITEM AND CB8_PEDIDO = C6_NUM "
cQuery += " 	 	 WHERE C6.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB7.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB8.D_E_L_E_T_ = ' ' "
cQuery += " 			AND CB7_FILIAL = '" + xFilial("CB7") + "' "
cQuery += " 			AND CB7_STATUS IN ('0','1') "
cQuery += " 			AND CB7_XOPEXP = CB1_CODOPE )) VALLIQ "
cQuery += " FROM " + RetSqlName("CB1") + " CB1 "
cQuery += " WHERE CB1.D_E_L_E_T_ = ' ' "
cQuery += " 	AND CB1_FILIAL = '" + xFilial("CB1") + "' "
cQuery += " 	AND CB1_CODOPE BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "
cQuery += " GROUP BY CB1_FILIAL, CB1_CODOPE, CB1_NOME "

If !Empty(Select(cAlias))
	dbSelectArea(cAlias)
	(cAlias)->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->( dbGoTop() )

oReport:SetMeter(0)

// Inicio a Seção do Cabeçalho
oSection1:Init()
cData	:= StoD(SubStr(GetMv("ST_DTFAT30"),1,8))
cHora	:= SubStr(GetMv("ST_DTFAT30"),9,9)
// Gravo a Seção do Cabeçalho
oSection1:PrintLine()
// Fecho a Seção do Cabeçalho
oSection1:Finish()

aFill(aDados,Nil)
// Inicio a Seção dos Itens
oSection:Init()
// Inicio a Seção dos Totalizadores
oSection2:Init()

While (cAlias)->( !Eof() )
	If (cAlias)->TOTALPEDIDO > 0
		aDados[1] := (cAlias)->FILIAL
		aDados[2] := (cAlias)->OPERADOR
		aDados[3] := (cAlias)->NOME
		aDados[4] := (cAlias)->TOTALPEDIDO
		aDados[5] := (cAlias)->TOTALLINHAS
		aDados[6] := (cAlias)->TOTALPECAS
		aDados[7] := (cAlias)->VALLIQ
		nTotPed	+= aDados[4]
		nTotLin	+= aDados[5]
		nTotPec	+= aDados[6]
		nTotVal	+= aDados[7]
		oSection:PrintLine()
		aFill(aDados,Nil)
	EndIf
	(cAlias)->( dbSkip() )
EndDo

dbSelectArea(cAlias)
(cAlias)->( dbCloseArea() )

PutMv("ST_DTFAT30",DtoS(Date()) + " " + Time())

// Gravo a Seção dos Totalizadores
oSection2:PrintLine()
// Fecho a Seção dos Totalizadores
oSection2:Finish()
// Fecho a Seção dos Itens
oSection:Finish()

Return oReport
