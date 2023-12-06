#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCODE0   บAutor  ณRenato Nogueira     บ Data ณ  12/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste relatorio tem por objetivo imprimir uma lista dos      บฑฑ
ฑฑบ          ณcodigos E que foram zerados naquela data                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCODE0()

Local oReport

PutSx1("STCODE0", "01","Data de?" ,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STCODE0", "02","Data ate?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1("STCODE0", "03","Armazem?" ,"","","mv_ch3","C",2,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STCODE0","RELATORIO DE CODIGOS E ZERADOS NO SALDO POR ENDERECO","STCODE0",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio com os c๓digos E que foram zerados no endere็o.")

Pergunte("STCODE0",.F.)

oSection := TRSection():New(oReport,"RELATORIO DE CODIGOS POR ENDERECO",{"SBF"})

TRCell():New(oSection,"CODIGO" 	    ,"SBF","CODIGO"    ,"@!",15)
TRCell():New(oSection,"LOCAL"      ,"SBF","LOCAL"     ,"@!",2)
TRCell():New(oSection,"ENDERECO"   ,"SBF","ENDERECO"  ,"@!",15)
TRCell():New(oSection,"QUANT"	    ,"SD3","QUANTIDADE",PesqPict("SBF","BF_QUANT",12),)
TRCell():New(oSection,"DATAZR"     ,"SD3","ULTIMA DATA QUE ZEROU","@!",10)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SBF")

Return oReport

Static Function ReportPrint(oReport)

Local oSection				:= oReport:Section(1)
Local nX					:= 0
Local cQuery 				:= ""
Local cAlias 				:= "QRYTEMP"
Local aDados[5]
Local cStr,cNovaStr,cUsu	:= ""
Local nDias					:= 0
Local dData

oSection:Cell("CODIGO"):SetBlock( { || aDados[1] } )
oSection:Cell("LOCAL"):SetBlock( { || aDados[2] } )
oSection:Cell("ENDERECO"):SetBlock( { || aDados[3] } )
oSection:Cell("QUANT"):SetBlock( { || aDados[4] } )
oSection:Cell("DATAZR"):SetBlock( { || aDados[5] } )

oReport:SetTitle("CODIGOS ZERADOS")// Titulo do relat๓rio

cQuery := " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_QUANT, BF_EMPENHO, BF_USERLGA "
cQuery += " FROM " +RetSqlName("SBF") "
cQuery += " WHERE BF_LOCAL='"+mv_par03+"' AND BF_FILIAL='"+xFilial("SBF")+"' AND BF_QUANT=0 AND BF_USERLGA<>' ' " //AND D_E_L_E_T_='*'

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
	
	cStr     := (cAlias)->BF_USERLGA
	cNovaStr := Embaralha(cStr, 1) // parametro 0 embaralha, 1 desembaralha
	cUsu     := SubStr(cNovaStr,0,15) //usuario que alterou
	
	nDias    := Load2in4(SubStr(cNovaStr,16))
	dData    := CtoD("01/01/96","DDMMYY") + nDias
	
	If dtos(mv_par01)<=dtos(dData) .And. dtos(mv_par02)>=dtos(dData)
		
		aDados[1]	:=	(cAlias)->BF_PRODUTO
		aDados[2]	:=	(cAlias)->BF_LOCAL
		aDados[3]	:=	(cAlias)->BF_LOCALIZ
		aDados[4]	:=  (cAlias)->BF_QUANT
		aDados[5]	:=	dData
		
		oSection:PrintLine()
		
	EndIf
	
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport