#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESTR02	ºAutor  ³Renato Nogueira     º Data ³  19/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para listar os saldos na SBF	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STESTR02()

Local oReport        

PutSx1("STESTR02", "01","Codigo de?" ,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STESTR02", "02","Codigo ate?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")                   
PutSx1("STESTR02", "03","Local de?"  ,"","","mv_ch3","C",2,0,0,"G","",		,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("STESTR02", "04","Local ate?" ,"","","mv_ch4","C",2,0,0,"G","",		,"","","mv_par04","","","","","","","","","","","","","","","","")                   
PutSx1("STESTR02", "05","Tipo de?"   ,"","","mv_ch5","C",2,0,0,"G","","02"  ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1("STESTR02", "06","Tipo ate?"  ,"","","mv_ch6","C",2,0,0,"G","","02"  ,"","","mv_par06","","","","","","","","","","","","","","","","")                   

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STESTR02","RELATÓRIO DE LOCALIZAÇÃO","STESTR02",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de localizações.")

Pergunte("STESTR02",.F.)

oSection := TRSection():New(oReport,"CADASTRO DOS PRODUTOS",{"SBF"})

TRCell():New(oSection,"FILIAL"    ,"SBF","FILIAL"        ,"@!",02)
TRCell():New(oSection,"CODIGO"    ,"SBF","CODIGO"        ,"@!",15)
TRCell():New(oSection,"LOCAL"     ,"SBF","LOCAL"         ,"@!",02)
TRCell():New(oSection,"LOCALIZ"   ,"SBF","LOCALIZAÇÃO"   ,"@!",15)
TRCell():New(oSection,"QUANT"     ,"SBF","QUANTIDADE"    ,PesqPict("SBF","BF_QUANT",12),)
TRCell():New(oSection,"EMPENHO"   ,"SBF","EMPENHO"       ,PesqPict("SBF","BF_EMPENHO",12),)
TRCell():New(oSection,"TIPO"      ,"SB1","TIPO"          ,"@!",02)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SB1")
oSection:Setnofilter("SBF")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[7]
Local _aDados	:= {}

oSection:Cell("FILIAL") :SetBlock( { || aDados[1] } )
oSection:Cell("CODIGO") :SetBlock( { || aDados[2] } )
oSection:Cell("LOCAL")  :SetBlock( { || aDados[3] } )
oSection:Cell("LOCALIZ"):SetBlock( { || aDados[4] } )
oSection:Cell("QUANT")  :SetBlock( { || aDados[5] } )
oSection:Cell("EMPENHO"):SetBlock( { || aDados[6] } )
oSection:Cell("TIPO")   :SetBlock( { || aDados[7] } )

oReport:SetTitle("Lista de produtos por endereço")// Titulo do relatório

cQuery := " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_QUANT, BF_EMPENHO, B1_TIPO "
cQuery += " FROM " +RetSqlName("SBF")+ " BF "
cQuery += " LEFT JOIN " +RetSqlName("SB1")+ " B1 " 
cQuery += " ON BF_PRODUTO=B1_COD "
cQuery += " WHERE B1.D_E_L_E_T_=' ' AND BF.D_E_L_E_T_=' ' AND BF_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += " AND BF_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "

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

	aDados[1]	:=	(cAlias)->BF_FILIAL
	aDados[2]	:=	(cAlias)->BF_PRODUTO
	aDados[3]	:=	(cAlias)->BF_LOCAL
	aDados[4]	:=	(cAlias)->BF_LOCALIZ
	aDados[5]	:=	(cAlias)->BF_QUANT
	aDados[6]	:=	(cAlias)->BF_EMPENHO
	aDados[7]	:=	(cAlias)->B1_TIPO

	oSection:PrintLine()
	aFill(aDados,nil)

	(cAlias)->(DbSkip())
	
EndDo                    

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport