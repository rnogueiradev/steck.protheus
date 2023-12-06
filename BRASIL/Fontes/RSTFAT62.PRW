#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFAT62  บAutor  ณJoใo Victor         บ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio para listar os clientes com os seus respectivos บฑฑ
ฑฑบ          ณ  vencimentos de Regime Especial                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT62()
*-----------------------------*
Local   oReport
Private cPerg 		:= "RFAT62"
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
PutSx1(cPerg ,"01"   ,"Filial De?"	   ,"Filial De?"	,"Filial De?"		,"mv_ch1"    ,"C"  ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""    ,""      ,""      ,"  "                  ,""     ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
PutSx1(cPerg ,"02"   ,"Filial At้?"	   ,"Filial At้?"	,"Filial At้?"		,"mv_ch2"    ,"C"  ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""    ,""      ,""      ,"ZZ"                  ,""     ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
PutSx1(cPerg ,"03"   ,"Perํodo De?"	   ,"Perํodo De?"	,"Perํodo De?"		,"mv_ch3"    ,"D"  ,08      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par03"    ,""    ,""      ,""      ,Dtoc(dDatabase-30)    ,""     ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
PutSx1(cPerg ,"04"   ,"Perํodo At้?"   ,"Perํodo At้?"	,"Perํodo At้?"		,"mv_ch4"    ,"D"  ,08      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par04"    ,""    ,""      ,""      ,Dtoc(dDatabase)       ,""     ,""        ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  12/11/14   บฑฑ
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

oReport := TReport():New(cPergTit,"RELATำRIO DE VENCIMENTOS DE REGIME ESPECIAL DOS CLIENTES STECK",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o Relat๓rio para listar os clientes com os seus respectivos vencimentos de Regime Especial")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"NGA",{"PPC"})


TRCell():New(oSection,"01",,"C๓digo"		,,06,.F.,)
TRCell():New(oSection,"02",,"Loja"		    ,,02,.F.,)
TRCell():New(oSection,"03",,"Razใo Social"  ,,40,.F.,)
TRCell():New(oSection,"04",,"CNPJ" 			,"@R 99.999.999/9999-99",18)
TRCell():New(oSection,"05",,"Insc. Estadual",,15,.F.,)
TRCell():New(oSection,"06",,"UF"		    ,,02,.F.,)
TRCell():New(oSection,"07",,"Vencimento"	,,08,.F.,)
TRCell():New(oSection,"08",,"Nบ Cota็๕es"		,"@E 999,999,999",7)
TRCell():New(oSection,"09",,"Nบ Pedidos"		,"@E 999,999,999",7)
TRCell():New(oSection,"10",,"Nบ Notas Fiscais"  ,"@E 999,999,999",7)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("CB9")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  12/11/14   บฑฑ
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
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local _cSta 	:= ''
Local _cCod    := ' '
Local _nQtdPr  := 0

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



oReport:SetTitle("RELATำRIO DE VENCIMENTOS DE REGIME ESPECIAL DOS CLIENTES STECK")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relat๓rio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
/*		
		If (cAliasLif)->CODIGO <> _cCod  .And. !Empty(Alltrim(_cCod))
			aDados1[05]	:=  _cCod+'  Total:'
			aDados1[06]	:=_nQtdPr
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			_nQtdPr:=0
		EndIf
*/		
		aDados1[01]	:=	(cAliasLif)->CODIGO
		aDados1[02]	:= 	(cAliasLif)->LOJA
		aDados1[03]	:= 	(cAliasLif)->NOME
		aDados1[04]	:=  (cAliasLif)->ID
		aDados1[05]	:=  (cAliasLif)->INSCRICAO
		aDados1[06]	:=  (cAliasLif)->ESTADO
		aDados1[07]	:=	Stod((cAliasLif)->VENCIMENTO)
		aDados1[08]	:= 	(cAliasLif)->COTACOES
		aDados1[09]	:= 	(cAliasLif)->PEDIDOS
		aDados1[10]	:= 	(cAliasLif)->NOTASFISCAIS
		
//		_nQtdPr +=	(cAliasLif)->QTD
//		_cCod := (cAliasLif)->CODIGO
		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
//	aDados1[05]	:=  _cCod+'  Total:'
//	aDados1[06]	:=_nQtdPr
	
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


cQuery := " SELECT
cQuery += " A1_COD 
cQuery += ' "CODIGO", 
cQuery += " A1_LOJA
cQuery += ' "LOJA", 
cQuery += " A1_NOME
cQuery += ' "NOME",
cQuery += " A1_CGC 
cQuery += ' "ID",
cQuery += " A1_INSCR
cQuery += ' "INSCRICAO",
cQuery += " A1_EST
cQuery += ' "ESTADO",
cQuery += " A1_XVALRE
cQuery += ' "VENCIMENTO",
cQuery += " (SELECT COUNT(UA_NUM) FROM "+RetSqlName("SUA")+"  UA WHERE A1_COD = UA_CLIENTE AND A1_LOJA = UA_LOJA    AND UA.D_E_L_E_T_ <> '*'   AND UA_NUMSC5 = ''  AND UA_FILIAL  BETWEEN '" + (MV_PAR01) 	+ "' AND '" + (MV_PAR02) 	+ "' AND UA_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"')
cQuery += ' "COTACOES",
cQuery += " (SELECT COUNT(C5_NUM) FROM "+RetSqlName("SC5")+"  C5 WHERE A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND C5.D_E_L_E_T_ <> '*'   AND C5_NOTA   = ''  AND C5_FILIAL  BETWEEN '" + (MV_PAR01) 	+ "' AND '" + (MV_PAR02) 	+ "' AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"')
cQuery += ' "PEDIDOS",
cQuery += " (SELECT COUNT(F2_DOC) FROM "+RetSqlName("SF2")+"  F2 WHERE A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA    AND F2.D_E_L_E_T_ <> '*'   AND F2_DUPL  <> ''  AND F2_FILIAL  BETWEEN '" + (MV_PAR01) 	+ "' AND '" + (MV_PAR02) 	+ "' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"')
cQuery += ' "NOTASFISCAIS"
cQuery += " FROM "+RetSqlName("SA1")+" TA1 "
cQuery += " WHERE A1_XVALRE  <> '' "
cQuery += " AND   TA1.D_E_L_E_T_ <> '*' " 
cQuery += " ORDER BY A1_XVALRE, A1_COD

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
