#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/Protheus.doc STREICPO
@(long_description) Relatorio de Itens Purchase Order
@author Eduardo Pereira - Sigamat
@since 04/06/2021
@version 12.1.25
/*/

User Function STREICPO()

Local   oReport
Private cPerg 			:= PadR("STREICPO",10)
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
@since 04/06/2021
@version 12.1.25
/*/

Static Function ReportDef()

Local oReport
Local oSection

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPergTit,"RELATÓRIO DE ITENS PURCHASE ORDER",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório de itens purchase order.")

oSection := TRSection():New(oReport,"Relatório de Itens Purchase Order",{"SW3"})

TRCell():New(oSection,"01",,"Filial"		,,06,.F.,)
TRCell():New(oSection,"02",,"Unid.Requis."	,,06,.F.,)
TRCell():New(oSection,"03",,"No. da S.I."	,,06,.F.,)
TRCell():New(oSection,"04",,"Codigo Item"	,,06,.F.,)
TRCell():New(oSection,"05",,"Part-Number" 	,,06,.F.,)
TRCell():New(oSection,"06",,"Fabricante" 	,,06,.F.,)
TRCell():New(oSection,"07",,"Loja Fabr."	,,06,.F.,)	
TRCell():New(oSection,"08",,"Qtde Pedida"	,,06,.F.,)
TRCell():New(oSection,"09",,"Saldo Qtde" 	,,06,.F.,)
TRCell():New(oSection,"10",,"Preco Unit." 	,,06,.F.,)
TRCell():New(oSection,"11",,"Dt Embarque" 	,,06,.F.,)
TRCell():New(oSection,"12",,"Dt Entrega" 	,,06,.F.,)
TRCell():New(oSection,"13",,"Pos.IPI/NCM" 	,,06,.F.,)
TRCell():New(oSection,"14",,"Posicao" 		,,06,.F.,)
TRCell():New(oSection,"15",,"No. do P.O." 	,,06,.F.,)
TRCell():New(oSection,"16",,"No. da PLI" 	,,06,.F.,)
TRCell():New(oSection,"17",,"Sequencia" 	,,06,.F.,)
TRCell():New(oSection,"18",,"Parcela No." 	,,06,.F.,)
TRCell():New(oSection,"19",,"Fornecedor" 	,,06,.F.,)
TRCell():New(oSection,"20",,"Loja Forn." 	,,06,.F.,)
TRCell():New(oSection,"21",,"Peso Bru Uni" 	,,06,.F.,)
TRCell():New(oSection,"22",,"Peso Liq Uni" 	,,06,.F.,)
TRCell():New(oSection,"23",,"Cent.Custo" 	,,06,.F.,)
TRCell():New(oSection,"24",,"Qtde Embarcada",,06,.F.,)
TRCell():New(oSection,"25",,"Saldo Qtde" 	,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SW3")

Return oReport

/*/Protheus.doc ReportPrint
@(long_description) Responsável pela impressão e apresentação das informações.
@author Eduardo Pereira - Sigamat
@since 04/06/2021
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
oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
oSection1:Cell("25") :SetBlock( { || aDados1[25] } )

oReport:SetTitle("Relatorio de Itens Purchase Order")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        aDados1[01]	:= (cAliasLif)->W3_FILIAL
        aDados1[02]	:= (cAliasLif)->W3_CC
        aDados1[03]	:= (cAliasLif)->W3_SI_NUM
        aDados1[04]	:= (cAliasLif)->W3_COD_I  
        aDados1[05]	:= (cAliasLif)->W3_PART_N
        aDados1[06]	:= (cAliasLif)->W3_FABR
        aDados1[07]	:= (cAliasLif)->W3_FABLOJ
        aDados1[08]	:= (cAliasLif)->W3_QTDE  
        aDados1[09]	:= (cAliasLif)->W3_SALDO_Q  
        aDados1[10]	:= (cAliasLif)->W3_PRECO
        aDados1[11]	:= DtoC(StoD((cAliasLif)->W3_DT_EMB))
        aDados1[12]	:= DtoC(StoD((cAliasLif)->W3_DT_ENTR))
        aDados1[13]	:= (cAliasLif)->W3_TEC
        aDados1[14]	:= (cAliasLif)->W3_POSICAO
        aDados1[15]	:= (cAliasLif)->W3_PO_NUM
        aDados1[16]	:= (cAliasLif)->W3_PGI_NUM
        aDados1[17]	:= (cAliasLif)->W3_SEQ
        aDados1[18]	:= (cAliasLif)->W3_REG
        aDados1[19]	:= (cAliasLif)->W3_FORN
        aDados1[20]	:= (cAliasLif)->W3_FORLOJ
        aDados1[21]	:= (cAliasLif)->W3_PESO_BR
        aDados1[22]	:= (cAliasLif)->W3_PESOL
        aDados1[23]	:= (cAliasLif)->W3_CTCUSTO
        aDados1[24]	:= (cAliasLif)->QTDE_EMB
        aDados1[25]	:= (cAliasLif)->W3_QTDE - (cAliasLif)->QTDE_EMB
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
@since 26/05/2021
/*/

Static Function StQuery()

Local cQuery := ""

If Select(cAliasLif) > 0
    (cAliasLif)->( dbCloseArea() )
EndIf

cQuery += " SELECT "
cQuery += " 	W3_FILIAL, W3_CC, W3_SI_NUM, W3_COD_I, W3_PART_N, W3_FABR, W3_FABLOJ, W3_QTDE, "
cQuery += " 	W3_SALDO_Q, W3_PRECO, W3_DT_EMB, W3_DT_ENTR, W3_TEC, W3_POSICAO, W3_PO_NUM, "
cQuery += " 	W3_PGI_NUM, W3_SEQ, W3_REG, W3_FORN, W3_FORLOJ, W3_PESO_BR, W3_PESOL, W3_CTCUSTO, "
cQuery += " 	(SELECT SUM(W7_SALDO_Q) "
cQuery += " 	FROM " + RetSQLName("SW7") + " SW7 "
cQuery += " 	WHERE SW7.D_E_L_E_T_ = ' ' "
cQuery += " 	    AND SW7.W7_FILIAL = SW3.W3_FILIAL "
cQuery += " 	    AND SW7.W7_PO_NUM = SW3.W3_PO_NUM "
cQuery += " 	    AND SW7.W7_POSICAO = SW3.W3_POSICAO) AS QTDE_EMB "
cQuery += " FROM " + RetSQLName("SW3") + " SW3 "
cQuery += " WHERE SW3.D_E_L_E_T_ = ' ' "
cQuery += " 	AND W3_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "
cQuery += " 	AND W3_PO_NUM BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' "
cQuery += " 	AND W3_DT_EMB BETWEEN '" + DtoS(Mv_Par05) + "' AND '" + Dtos(Mv_Par06) + "' "
cQuery += " 	AND W3_TEC <> ' ' "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/Protheus.doc AjustaSX1
@description Cria arquivo de perguntas
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 04/06/2021
/*/

Static Function AjustaSX1(cPerg)

Local i := 0
Local j := 0
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
aRegs := {}

aAdd(aRegs,{cPerg, "01", "Filial De"      , "Filial De"   , "Filial De"   ,"mv_ch1","C", 2,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "02", "Filial Até"     , "Filial Até"  , "Filial Até"  ,"mv_ch1","C", 2,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "03", "Pedido De"      , "Pedido De"   , "Pedido De"   ,"mv_ch3","C",15,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "04", "Pedido Ate"     , "Pedido Até"  , "Pedido Até"  ,"mv_ch4","C",15,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "05", "Embarque De"    , "Embarque De" , "Embarque De" ,"mv_ch5","D", 8,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "06", "Embarque Ate"   , "Embarque Até", "Embarque Até","mv_ch6","D", 8,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
