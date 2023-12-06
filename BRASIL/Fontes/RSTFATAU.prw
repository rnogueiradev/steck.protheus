#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAU   ºAutor  ³Robson Mazzarotto º Data ³  21/03/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de processo de Compras                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAU()

Local   oReport
Private cPerg 			:= "RFATAU"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1(cPerg, "01", "CNPJ:" 		,"CNPJ: ?" 		   ,"CNPJ: ?" 		   ,"mv_ch1","C",14,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "De  Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Ate Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch3","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
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

oReport := TReport():New(cPergTit,"Relatório de Rastreamento do processo de Compras",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Rastramento de Processo de Compras")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Rastreamento de Compras",{"SC1"})


TRCell():New(oSection,"SOLICITACAO"  	,,"SOLICITACAO      "	,,10,.F.,)
TRCell():New(oSection,"DTSOLICITA"		,,"DATA SOLICITACAO "	,,8,.F.,)
TRCell():New(oSection,"PEDIDO"  		,,"PEDIDO           "	,,6,.F.,)
TRCell():New(oSection,'DTPEDIDO'  		,,"DATA PEDIDO      "	,,8,.F.,)
TRCell():New(oSection,'ITPEDIDO'  		,,"ITEM PEDIDO      "	,,8,.F.,)
TRCell():New(oSection,'PRODUTO'  		,,"PRODUTO          "	,,30,.F.,)
TRCell():New(oSection,"DATALIB"  		,,"DATA LIBERACAO   "	,,8,.F.,)
TRCell():New(oSection,"NOMEAPRO"  		,,"NOME APROVADOR   "	,,30,.F.,)
TRCell():New(oSection,"NOTA"       	,,"NOTA             "	,,20,.F.,)
TRCell():New(oSection,"DTNOTA"  		,,"DATA NOTA        "	,,8,.F.,)
TRCell():New(oSection,"HORANOTA"  		,,"HORA NOTA        "	,,8,.F.,)
TRCell():New(oSection,"ZLOG" 	 		,,"ZLOG"				   ,,2000,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC1")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP0"
Local aDados[2]
Local aDados1[12]
Local _cSta := ''

oSection1:Cell("SOLICITACAO")    :SetBlock( { || aDados1[01] } )
oSection1:Cell("DTSOLICITA")     :SetBlock( { || aDados1[02] } )
oSection1:Cell("PEDIDO")  	     :SetBlock( { || aDados1[03] } )
oSection1:Cell('DTPEDIDO')       :SetBlock( { || aDados1[04] } )
oSection1:Cell('ITPEDIDO')       :SetBlock( { || aDados1[05] } )
oSection1:Cell("PRODUTO")        :SetBlock( { || aDados1[06] } )
oSection1:Cell("DATALIB")        :SetBlock( { || aDados1[07] } )
oSection1:Cell("NOMEAPRO")       :SetBlock( { || aDados1[08] } )
oSection1:Cell("NOTA")           :SetBlock( { || aDados1[09] } )
oSection1:Cell("DTNOTA")         :SetBlock( { || aDados1[10] } )
oSection1:Cell("HORANOTA")       :SetBlock( { || aDados1[11] } )
oSection1:Cell("ZLOG") 	        :SetBlock( { || aDados1[12] } )

oReport:SetTitle("Log processo de compras")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())

If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->SOLICITACAO
		aDados1[02]	:=	(cAliasLif)->DTSOLICITA
		aDados1[03]	:= 	(cAliasLif)->PEDIDO
		aDados1[04]	:=  (cAliasLif)->DTPEDIDO
		aDados1[05]	:=  (cAliasLif)->ITPEDIDO
		aDados1[06]	:=  (cAliasLif)->PRODUTO
		aDados1[07]	:=  (cAliasLif)->DATALIB
		aDados1[08]	:=  (cAliasLif)->NOMEAPRO
		aDados1[09]	:=	(cAliasLif)->NOTA
		aDados1[10]	:=	(cAliasLif)->DTNOTA
		aDados1[11]	:=	(cAliasLif)->HORANOTA
		aDados1[12]	:=	(cAliasLif)->ZLOG 
 		
		
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
cQuery += " A2_COD,
cQuery += " A2_LOJA,
cQuery += " F1_DOC
cQuery += " NOTA,"
cQuery += " SUBSTR( F1_DTDIGIT,7,2)||'/'||SUBSTR( F1_DTDIGIT,5,2)||'/'||SUBSTR(F1_DTDIGIT,1,4)
cQuery += " DTNOTA,"
cQuery += " D1_PEDIDO
cQuery += " PEDIDO,"
cQuery += " D1_ITEMPC
cQuery += " ITPEDIDO,"
cQuery += " D1_COD
cQuery += " PRODUTO,"
cQuery += " SUBSTR( C7_EMISSAO,7,2)||'/'||SUBSTR( C7_EMISSAO,5,2)||'/'||SUBSTR(C7_EMISSAO,1,4)
cQuery += " DTPEDIDO,"
cQuery += " C1_NUM
cQuery += " SOLICITACAO,"
cQuery += " SUBSTR( C1_EMISSAO,7,2)||'/'||SUBSTR( C1_EMISSAO,5,2)||'/'||SUBSTR(C1_EMISSAO,1,4)
cQuery += " DTSOLICITA,"
cQuery +=  "Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( SC1.C1_ZLOG,2000 ) ) ) As ZLOG,"
cQuery += " CR_USERLIB,
cQuery += " SUBSTR( CR_DATALIB,7,2)||'/'||SUBSTR( CR_DATALIB,5,2)||'/'||SUBSTR(CR_DATALIB,1,4)
cQuery += " DATALIB,"
cQuery += " AK_NOME
cQuery += " NOMEAPRO,"
cQuery += " F1_HORA
cQuery += " HORANOTA"


cQuery += " FROM "+RetSqlName("SA2")+" SA2 "

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SF1")+" )SF1 "
cQuery += " ON SF1.D_E_L_E_T_   = ' '
cQuery += " AND SF1.F1_FORNECE = SA2.A2_COD
cQuery += " AND SF1.F1_LOJA = SA2.A2_LOJA
cQuery += " AND SF1.F1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SD1")+" )SD1 "
cQuery += " ON SD1.D_E_L_E_T_   = ' '
cQuery += " AND SD1.D1_DOC = SF1.F1_DOC
cQuery += " AND SD1.D1_FORNECE = SA2.A2_COD
cQuery += " AND SD1.D1_LOJA = SA2.A2_LOJA 
cQuery += " AND SD1.D1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SC7")+" )SC7 "
cQuery += " ON SC7.D_E_L_E_T_   = ' '
cQuery += " AND SC7.C7_NUM = SD1.D1_PEDIDO
cQuery += " AND SC7.C7_PRODUTO = SD1.D1_COD
cQuery += " AND SC7.C7_ITEM = SD1.D1_ITEMPC

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SC1")+" )SC1 "
cQuery += " ON SC1.D_E_L_E_T_   = ' '
cQuery += " AND SC1.C1_NUM = SC7.C7_NUMSC
cQuery += " AND SC1.C1_ITEM = SC7.C7_ITEMSC
cQuery += " AND SC1.C1_PRODUTO = SD1.D1_COD

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SCR")+" )SCR "
cQuery += " ON SCR.D_E_L_E_T_   = ' '
cQuery += " AND SCR.CR_NUM = SC7.C7_NUM
cQuery += " AND SCR.CR_DATALIB <> ' '
cQuery += " AND SCR.CR_STATUS  = '03'

cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SAK")+" )SAK "
cQuery += " ON SAK.D_E_L_E_T_   = ' '
cQuery += " AND SAK.AK_USER = SCR.CR_USERLIB

cQuery += " WHERE SA2.A2_CGC =  '"+ MV_PAR01 +"'"
cQuery += " AND SA2.D_E_L_E_T_ = ' '

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

