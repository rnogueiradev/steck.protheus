#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/Protheus.doc STRNUMPV
@(long_description) Relatorio de Pedidos de Vendas
@author Eduardo Pereira - Sigamat
@since 16/07/2021
@version 12.1.25
/*/

User Function STRNUMPV()

Local   oReport
Private cPerg 			:= PadR("STRNUMPV",10)
Private cTime           := Time()
Private cHora           := Substr(cTime, 1, 2)
Private cMinutos    	:= Substr(cTime, 4, 2)
Private cSegundos   	:= Substr(cTime, 7, 2)
Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
Private lXlsHeader      := .F.
Private lXmlEndRow      := .F.
Private cPergTit 		:= cAliasLif

oReport	:= ReportDef()
oReport:PrintDialog()

Return 

/*/Protheus.doc ReportDef
@(long_description) Montagem das Perguntas e do cabeçalho do relatório.
@author Eduardo Pereira - Sigamat
@since 16/07/2021
@version 12.1.25
/*/

Static Function ReportDef()

Local oReport
Local oSection

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPergTit,"RELATÓRIO DE PEDIDOS DE VENDAS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório de pedidos de vendas.")

oSection := TRSection():New(oReport,"Relatório de Pedidos de Vendas",{"SC5"})

TRCell():New(oSection,"01",,"Filial"		    ,,06,.F.,)
TRCell():New(oSection,"02",,"Num PV"	        ,,06,.F.,)
TRCell():New(oSection,"03",,"Cliente"	        ,,06,.F.,)
TRCell():New(oSection,"04",,"Loja"	            ,,06,.F.,)
TRCell():New(oSection,"05",,"Nome Cliente" 	    ,,06,.F.,)
TRCell():New(oSection,"06",,"Dt Emissão" 	    ,,06,.F.,)
TRCell():New(oSection,"07",,"Item PV"           ,,06,.F.,)
TRCell():New(oSection,"08",,"Produto" 	        ,,06,.F.,)
TRCell():New(oSection,"09",,"Descrição" 	    ,,06,.F.,)
TRCell():New(oSection,"10",,"Qtde Venda" 		,,06,.F.,)
TRCell():New(oSection,"11",,"Qtde Entregue" 	,,06,.F.,)
TRCell():New(oSection,"12",,"Saldo" 		    ,,06,.F.,)
TRCell():New(oSection,"13",,"Num PC" 		    ,,06,.F.,)
TRCell():New(oSection,"14",,"Item PC" 		    ,,06,.F.,)
TRCell():New(oSection,"15",,"Bloqueado" 		,,06,.F.,)
TRCell():New(oSection,"16",,"Dt Entregue" 	    ,,06,.F.,)
TRCell():New(oSection,"17",,"Dt Entregue 2" 	,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SC5")

Return oReport

/*/Protheus.doc ReportPrint
@(long_description) Responsável pela impressão e apresentação das informações.
@author Eduardo Pereira - Sigamat
@since 16/07/2021
@version 12.1.25
/*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
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
oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
oSection1:Cell("17") :SetBlock( { || aDados1[17] } )

oReport:SetTitle("Relatório de Pedidos de Vendas")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        aDados1[01]	:= (cAliasLif)->C5_FILIAL
        aDados1[02]	:= (cAliasLif)->C5_NUM
        aDados1[03]	:= (cAliasLif)->C5_CLIENTE
        aDados1[04]	:= (cAliasLif)->C5_LOJACLI
        aDados1[05]	:= Alltrim(Posicione("SA1", 1, xFilial("SA1") + (cAliasLif)->C5_CLIENTE + (cAliasLif)->C5_LOJACLI, "A1_NREDUZ"))
        aDados1[06]	:= DtoC(StoD((cAliasLif)->C5_EMISSAO))
        aDados1[07]	:= (cAliasLif)->C6_ITEM
        aDados1[08]	:= (cAliasLif)->C6_PRODUTO
        aDados1[09]	:= Alltrim(Posicione("SB1", 1, xFilial("SB1") + (cAliasLif)->C6_PRODUTO, "B1_DESC"))
        aDados1[10]	:= (cAliasLif)->C6_QTDVEN  
        aDados1[11]	:= (cAliasLif)->C6_QTDENT  
        aDados1[12]	:= (cAliasLif)->SALDO
        aDados1[13]	:= (cAliasLif)->C6_NUMPCOM
        aDados1[14]	:= (cAliasLif)->C6_ITEMPC
        aDados1[15]	:= (cAliasLif)->C6_BLQ
        aDados1[16]	:= DtoC(StoD((cAliasLif)->C6_ENTREG))
        aDados1[17]	:= DtoC(StoD((cAliasLif)->C6_ZENTRE2))
        oSection1:PrintLine()
        aFill(aDados1,Nil)
        (cAliasLif)->( dbskip() )
    End
EndIf

oReport:SkipLine()

Return oReport

/*/Protheus.doc StQuery
@description Filtra as informações das Tabelas SC7 por Codigo e Data de Emissão
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 16/07/2021
/*/

Static Function StQuery()

Local cQuery := ""

If Select(cAliasLif) > 0
    (cAliasLif)->( dbCloseArea() )
EndIf

cQuery += " SELECT "
cQuery += "     C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, "
cQuery += "     C6_QTDVEN - C6_QTDENT SALDO, C6_NUMPCOM, C6_ITEMPC, C6_BLQ, C6_ENTREG, C6_ZENTRE2 "
cQuery += " FROM " + RetSQLName("SC5") + " C5 "
cQuery += " LEFT JOIN " + RetSQLName("SC6") + " C6 "
cQuery += " ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = ' ' "
cQuery += " WHERE C5.D_E_L_E_T_ = ' ' "
cQuery += "     AND C5_EMISSAO BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' "
cQuery += "     AND C5_CLIENTE = '" + Mv_Par03 + "' "
cQuery += "     AND C5_LOJACLI = '" + Mv_Par04 + "' "
cQuery += "     AND C6_QTDVEN - C6_QTDENT > 0 "
cQuery += "     AND C6_BLQ = ' ' "
cQuery += " ORDER BY C5_EMISSAO "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/Protheus.doc AjustaSX1
@description Cria arquivo de perguntas
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 16/07/2021
/*/

Static Function AjustaSX1(cPerg)

Local i := 0
Local j := 0
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
aRegs := {}

aAdd(aRegs,{cPerg, "01", "Emissao de", "Emissao de", "Emissao de", "mv_ch1","D",8,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "02", "Emissao de", "Emissao de", "Emissao de", "mv_ch2","D",8,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "03", "Cliente"   , "Cliente"   , "Cliente"   , "mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "04", "Loja"      , "Loja"      , "Loja"      , "mv_ch4","C",2,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i := 1 to Len(aRegs)
    If !dbSeek(cPerg + aRegs[i,2])
        RecLock("SX1",.T.)
        For j := 1 to Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
        Next j
        MsUnlock()
    EndIf
Next i

dbSkip()
dbSelectArea(_sAlias)

Return
