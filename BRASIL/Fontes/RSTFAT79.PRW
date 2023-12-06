#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT79     ºAutor  ³Renato Nogueira º Data ³  26/05/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de alteracoes em PC		                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT79()
*-----------------------------*          
Local   oReport
Private cPerg 			:= "RFAT79"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1( cPerg, "01","Data de?" 				,"","","mv_ch1","D",08,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Data ate?"				,"","","mv_ch2","D",08,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","PC de:"				,"","","mv_ch3","C",06,0,0,"G","","SC7" ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","PC até:"				,"","","mv_ch4","C",06,0,0,"G","","SC7" ,"","","mv_par04","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ONE VOICE				                          º±±
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
Local oSection1
Local oSection2

oReport := TReport():New(cPergTit,"ALTERAÇÕES PC",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de alterações no PC")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"ALTERAÇÕES PC",{"SC7"})

TRCell():New(oSection,"FILIAL"		,,"FILIAL"									,,02,.F.,)
TRCell():New(oSection,"NUMERO"		,,"NUMERO"									,,06,.F.,)
TRCell():New(oSection,"FORNECE"		,,"FORNECEDOR"								,,06,.F.,)
TRCell():New(oSection,"NOMEFOR"		,,"NOME"									,,50,.F.,)
TRCell():New(oSection,"LOJA"		,,"LOJA"									,,02,.F.,)
TRCell():New(oSection,"ITEM"		,,"ITEM"									,,04,.F.,)
TRCell():New(oSection,"PRODUTO"		,,"PRODUTO"									,,15,.F.,)
TRCell():New(oSection,"DESCRI"		,,"DESCRICAO"								,,50,.F.,)
TRCell():New(oSection,"DATA"		,,"DATA"									,,10,.F.,)
TRCell():New(oSection,"MOTIVO"		,,"MOTIVO"									,,50,.F.,)
TRCell():New(oSection,"USUARIO"		,,"USUARIO"									,,50,.F.,)
TRCell():New(oSection,"ALTERACAO"	,,"ALTERACAO"								,,  ,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC7")

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
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[99]

oSection1:Cell("FILIAL") 			:SetBlock( { || aDados1[01] } )
oSection1:Cell("NUMERO") 			:SetBlock( { || aDados1[02] } )
oSection1:Cell("ITEM") 				:SetBlock( { || aDados1[03] } )
oSection1:Cell("PRODUTO") 			:SetBlock( { || aDados1[04] } )
oSection1:Cell("DATA") 				:SetBlock( { || aDados1[05] } )
oSection1:Cell("MOTIVO") 			:SetBlock( { || aDados1[06] } )
oSection1:Cell("ALTERACAO") 		:SetBlock( { || aDados1[07] } )
oSection1:Cell("FORNECE")	 		:SetBlock( { || aDados1[08] } )
oSection1:Cell("LOJA")		 		:SetBlock( { || aDados1[09] } )
oSection1:Cell("DESCRI")	 		:SetBlock( { || aDados1[10] } )
oSection1:Cell("USUARIO")	 		:SetBlock( { || aDados1[11] } )
oSection1:Cell("NOMEFOR")	 		:SetBlock( { || aDados1[12] } )

oReport:SetTitle("ALTERAÇÕES PC")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection1:Init()

Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
	
		DbSelectArea("SC7")
		SC7->(DbGoTo((cAliasLif)->REGISTRO))
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
		
		If SC7->(!Eof())
		
	 	aDados1[01]	:=	SC7->C7_FILIAL
		aDados1[02]	:= 	SC7->C7_NUM
		aDados1[03]	:=  SC7->C7_ITEM
		aDados1[04]	:=  SC7->C7_PRODUTO
		aDados1[05]	:=  (cAliasLif)->DATA
		aDados1[06]	:=  Posicione("SX5",1,xFilial("SX5")+"99"+SC7->C7_XMOTREJ,"X5_DESCRI")
		aDados1[07]	:=  SC7->C7_XLOG
		aDados1[08]	:=  SC7->C7_FORNECE
		aDados1[09]	:=  SC7->C7_LOJA
		aDados1[10]	:=  SB1->B1_DESC
		aDados1[11]	:=  AllTrim(UsrRetName(SC7->C7_USER))
		aDados1[12]	:=  Posicione("SA2",1,xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME")
		
		EndIf

		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf

oReport:SkipLine()

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
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT R_E_C_N_O_ REGISTRO, C7_XMOTREJ "
cQuery += " ,SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),INSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),'Alterado em: ')+13,10) AS DATA "
cQuery += " FROM "+RetSqlName("SC7")+" C7 "
cQuery += " WHERE D_E_L_E_T_=' ' AND C7_XLOG IS NOT NULL "
cQuery += " AND C7_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND "
cQuery += " SUBSTR(SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),INSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),'Alterado em: ')+13,10),7,4) "
cQuery += " || "
cQuery += " SUBSTR(SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),INSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),'Alterado em: ')+13,10),4,2) "
cQuery += " || "
cQuery += " SUBSTR(SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),INSTR(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(C7_XLOG, 2000,length(c7_xlog)-2000)),'Alterado em: ')+13,10),1,2) "
cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()