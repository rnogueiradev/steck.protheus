#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT58     ºAutor  ³Giovani Zago    º Data ³  29/09/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio CD EMBALAGEM					                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT58()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT58"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1(cPerg, "01", "Nota:" ,"Da Nota: ?" 	,"Da Nota: ?" 		,"mv_ch1","C",9,0,0,"G","",'SF2' ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Serie:","Ate Nota: ?" ,"Ate Nota: ?" 		,"mv_ch2","C",3,0,0,"G","",'' ,"","","mv_par02","","","","","","","","","","","","","","","","")


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

oReport := TReport():New(cPergTit,"RELATÓRIO EMBALAGEM",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório EMBALAGEM")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"NGA",{"PPC"})


TRCell():New(oSection,"01",,"NF"			,,09,.F.,)
TRCell():New(oSection,"02",,"PEDIDO"		,,06,.F.,)
TRCell():New(oSection,"03",,"OS" 			,,06,.F.,)
TRCell():New(oSection,"04",,"CODIGO"		,,15,.F.,)
TRCell():New(oSection,"05",,"VOLUME"		,,04,.F.,)
TRCell():New(oSection,"06",,"QTD"			,"@E 99,999,999.99",14)
TRCell():New(oSection,"07",,"EMBALAGEM"		,,04,.F.,)



oSection:SetHeaderSection(.t.)
oSection:Setnofilter("CB9")

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




oReport:SetTitle("EMBALAGEM")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		If (cAliasLif)->CODIGO <> _cCod  .And. !Empty(Alltrim(_cCod))
			aDados1[05]	:=  _cCod+'  Total:'
			aDados1[06]	:=_nQtdPr
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			_nQtdPr:=0
		EndIf
		
		aDados1[01]	:=	(cAliasLif)->NF
		aDados1[02]	:= 	(cAliasLif)->PEDIDO
		aDados1[03]	:=  (cAliasLif)->OS
		aDados1[04]	:=  (cAliasLif)->CODIGO
		aDados1[05]	:=  (cAliasLif)->VOLUME
		aDados1[06]	:=	(cAliasLif)->QTD
		aDados1[07]	:= 	(cAliasLif)->EMBALAGEM
		
		_nQtdPr +=	(cAliasLif)->QTD
		_cCod := (cAliasLif)->CODIGO
		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	aDados1[05]	:=  _cCod+'  Total:'
	aDados1[06]	:=_nQtdPr
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	_nQtdPr:=0
	(cAliasLif)->(dbCloseArea())
EndIf
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


cQuery := " SELECT
cQuery += " SC9.C9_NFISCAL
cQuery += ' "NF",
cQuery += " CB9_PEDIDO
cQuery += ' "PEDIDO",
cQuery += " CB9_ORDSEP
cQuery += ' "OS",
cQuery += " CB9_PROD
cQuery += ' "CODIGO",
cQuery += " SUBSTR(CB9_VOLUME,7,4)
cQuery += ' "VOLUME",
cQuery += " CB9_QTESEP
cQuery += ' "QTD",
cQuery += " NVL((SELECT CB6.CB6_TIPVOL FROM "+RetSqlName("CB6")+" CB6 "
cQuery += " WHERE CB6.D_E_L_E_T_ = ' '   AND CB6.CB6_VOLUME = CB9.CB9_VOLUME AND CB9.CB9_FILIAL = CB6.CB6_FILIAL), ' ')
cQuery += ' "EMBALAGEM"

cQuery += " FROM "+RetSqlName("CB9")+" CB9 "

cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("SC9")+" )SC9 "
cQuery += " ON SC9.D_E_L_E_T_ = ' '
cQuery += " AND SC9.C9_FILIAL = CB9.CB9_FILIAL
cQuery += " AND SC9.C9_PEDIDO = CB9.CB9_PEDIDO
cQuery += " AND SC9.C9_ORDSEP = CB9.CB9_ORDSEP
cQuery += " AND SC9.C9_ITEM   = CB9.CB9_ITESEP
cQuery += " AND SC9.C9_NFISCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR01+"'
cQuery += " AND SC9.C9_SERIENF BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR02+"'
cQuery += " WHERE CB9.D_E_L_E_T_ = ' '

cQuery += " ORDER BY SC9.C9_NFISCAL,CB9_PROD


// SELECT SC9.C9_NFISCAL "NF", CB9_PEDIDO "PEDIDO", CB9_ORDSEP "OS", CB9_PROD "CODIGO", SUBSTR(CB9_VOLUME,7,4) "VOLUME", CB9_ITESEP "QTD", NVL((SELECT CB6.CB6_TIPVOL FROM CB6010 CB6  WHERE CB6.D_E_L_E_T_ = ' '   AND CB6.CB6_VOLUME = CB9.CB9_VOLUME AND CB9.CB9_FILIAL = CB6.CB6_FILIAL), ' ') "EMBALAGEM" FROM CB9010 CB9  INNER JOIN( SELECT * FROM SC9010 )SC9  ON SC9.D_E_L_E_T_ = ' ' AND SC9.C9_FILIAL = CB9.CB9_FILIAL AND SC9.C9_PEDIDO = CB9.CB9_PEDIDO AND SC9.C9_ORDSEP = CB9.CB9_ORDSEP AND SC9.C9_ITEM   = CB9.CB9_ITESEP AND SC9.C9_NFISCAL BETWEEN '000080085' AND '000080085' AND SC9.C9_SERIENF BETWEEN '001' AND '001' WHERE CB9.D_E_L_E_T_ = ' ' ORDER BY SC9.C9_NFISCAL,CB9_PROD



//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

