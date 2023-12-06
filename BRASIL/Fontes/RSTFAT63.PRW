#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFAT63  บAutor  ณJoใo Victor         บ Data ณ  28/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio para listar os itens de Purchase Order          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT63()
*-----------------------------*
Local   oReport
Private cPerg 		:= "RFAT63"
Private cTime        := Time()
Private cHora        := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private lXlsHeader   := .f.
Private lXmlEndRow   := .f.
Private cPergTit 		:= cAliasLif
Private _aHelp       := {}

//-----cGrupo,cOrdem,cPergunt          ,cPergSpa        ,cPergEng           ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01,cDefSpa1,cDefEng1,cCnt01               ,cDef02,cDefSpa2	,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
//PutSx1(cPerg ,"01"   ,"Filial ?"       ,"Filial ?"      ,"Filial ?"         ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""    ,""      ,""      ,""                   ,""    ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
PutSx1(cPerg ,"01"   ,"PO ?"           ,"PO ?"	       ,"PO ?"             ,"mv_ch1"    ,"C"   ,06      , 0      , 0     ,"G" ,""    ,"SW2" ,""     ,"S"  ,"mv_par01"    ,""    ,""      ,""      ,""                   ,""    ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")


oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  28/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cabe็alho do Relat๓rio  		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection
Local oSection1
Local oSection2

oReport := TReport():New(cPergTit,"RELATำRIO DE ITENS DE PO#",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir os itens de PO")

Pergunte(cPerg,.F.)
//Primeira Se็ใo
//oSection1 := TRSection():New(oReport,"Cabe็alho",{"SW3"})
//TRCell():New(oSection1,"01",,"PO"		                  ,PesqPict("SW3","W3_PO_NUM"),TamSX3("W3_PO_NUM") [1]+4)


//Segunda Se็ใo
oSection2 := TRSection():New(oReport,"Itens",{"SA5","SB1","SW3"})

TRCell():New(oSection2,"01",,"IT Nb"		                  ,PesqPict("SW3","W3_POSICAO"),TamSX3("W3_POSICAO") [1]+4)
TRCell():New(oSection2,"02",,"UM"                           ,PesqPict("SB1","B1_UM")     ,TamSX3("B1_UM")      [1]+4)
TRCell():New(oSection2,"03",,"Quantity"                     ,PesqPict("SW3","W3_QTDE")   ,TamSX3("W3_QTDE")    [1]+4)
TRCell():New(oSection2,"04",,"Unit Price" 			        ,PesqPict("SW3","W3_PRECO")  ,TamSX3("W3_PRECO")   [1]+5)
TRCell():New(oSection2,"05",,"Amount"                       ,PesqPict("SW3","W3_PRECO")  ,TamSX3("W3_PRECO")   [1]+5)
TRCell():New(oSection2,"06",,"Manufacturer"		           ,PesqPict("SA2","A2_NREDUZ") ,TamSX3("A2_NREDUZ")  [1]+4)
TRCell():New(oSection2,"07",,"Req. Ship Date"                ,PesqPict("SW3","W3_DT_EMB") ,TamSX3("W3_DT_EMB")  [1]+18)
TRCell():New(oSection2,"08",,"Supplier Code"		           ,PesqPict("SA5","A5_CODPRF") ,TamSX3("A5_CODPRF")  [1]+4)
TRCell():New(oSection2,"09",,"Supplier Code Additional Info" ,PesqPict("SA5","A5_PARTOPC"),TamSX3("A5_PARTOPC") [1]+4)
TRCell():New(oSection2,"10",,"STECK Code"                    ,PesqPict("SW3","W3_COD_I")  ,TamSX3("W3_COD_I")   [1]+6)
TRCell():New(oSection2,"11",,"Description Code STECK"        ,PesqPict("SB1","B1_DESC")   ,TamSX3("B1_DESC")    [1]+4)

oBreak1 := TRBreak():New(oSection2,{|| (cAliasLif)->(PO) },{|| "Total :" },.F.)
	TRFunction():New(oSection2:Cell("Quantity")     , "TOT1", 	"SUM"  , oBreak1,,,, .F., .F.)
	TRFunction():New(oSection2:Cell("Manufacturer") , "TOT2", 	"COUNT", oBreak1,,,, .F., .F.)
	TRFunction():New(oSection2:Cell("Amount" )      , "TOT3", 	"SUM"  , oBreak1,,,, .F., .F.)
	

//oSection:SetHeaderSection(.t.)


Return oReport



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  28/01/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Itens do Relat๓rio           	                           บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]

oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
oSection1:Cell("11") :SetBlock( { || aDados1[11] } )


oReport:SetTitle("RELATำRIO DE ITENS DE PO#"+MV_PAR01)// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relat๓rio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->IT_NB
		aDados1[02]	:= 	(cAliasLif)->UM
		aDados1[03]	:= 	(cAliasLif)->QUANTITY
		aDados1[04]	:=  (cAliasLif)->UNIT_PRICE
		aDados1[05]	:=  (cAliasLif)->AMOUNT
		aDados1[06]	:=  (cAliasLif)->MANUFACTURER
		aDados1[07]	:=	 Stod((cAliasLif)->DT_SHIP)
		aDados1[08]	:= 	(cAliasLif)->COD_SUP
		aDados1[09]	:= 	(cAliasLif)->COD_SUP_COMPL
		aDados1[10]	:= 	(cAliasLif)->COD_STECK
		aDados1[11]	:= 	(cAliasLif)->DESCRIP_STECK
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	_nQtdPr:=0
	(cAliasLif)->(dbCloseArea())
EndIf
oReport:SkipLine()

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |StQuery   บAutor  ณJoใo Victor         บ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Query do Relat๓rio				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT DISTINCT
cQuery += " W3_FILIAL AS FILIAL,
cQuery += " W3_POSICAO AS IT_NB,
cQuery += " B1_UM AS UM,
cQuery += " W3_QTDE AS QUANTITY,
cQuery += " W3_PRECO AS UNIT_PRICE,
cQuery += " W3_QTDE * W3_PRECO AS AMOUNT,
cQuery += " A2_NREDUZ AS MANUFACTURER,
cQuery += " W3_DT_EMB AS DT_SHIP,
cQuery += " A5_CODPRF AS COD_SUP,
cQuery += " A5_PARTOPC AS COD_SUP_COMPL,
cQuery += " W3_COD_I AS COD_STECK,
cQuery += " B1_DESC AS DESCRIP_STECK,
cQuery += " W3_PO_NUM AS PO
cQuery += " FROM "+RetSqlName("SW3")+" TW3 "

cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SB1")+" ) TB1
cQuery += " ON B1_COD = W3_COD_I 
cQuery += " AND TB1.D_E_L_E_T_ <> '*' "

cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SA2")+" ) TA2 
cQuery += " ON A2_COD = W3_FABR 
cQuery += " AND A2_LOJA = W3_FABLOJ
cQuery += " AND TA2.D_E_L_E_T_ <> '*' "

cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SA5")+" ) TA5
cQuery += " ON A5_FORNECE = W3_FORN
cQuery += " AND A5_LOJA = W3_FORLOJ
cQuery += " AND A5_PRODUTO = W3_COD_I
cQuery += " AND TA5.D_E_L_E_T_ <> '*' "

cQuery += " WHERE W3_PO_NUM = '"+ MV_PAR01 +"'
cQuery += " AND W3_FILIAL = '"+xFilial("SW3")+"'"

cQuery += " AND TW3.D_E_L_E_T_ <> '*' "

cQuery += " ORDER BY W3_POSICAO

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()