#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/Protheus.doc STREICPF
@(long_description) Relatorio de Pedidos Faturados
@author Eduardo Pereira - Sigamat
@since 28/05/2021
@version 12.1.25
/*/

User Function STREICPF()

Local   oReport
Private cPerg 			:= PadR("STREICPF",10)
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
@since 26/05/2021
@version 12.1.25
/*/

Static Function ReportDef()

Local oReport
Local oSection

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPergTit,"RELATÓRIO DE PEDIDOS FATURADOS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório de pedidos faturados.")

oSection := TRSection():New(oReport,"Relatório de Pedidos Faturados",{"EE7"})

TRCell():New(oSection,"01",,"Filial"		    ,,06,.F.,)
TRCell():New(oSection,"02",,"Pedido"		    ,,06,.F.,)
TRCell():New(oSection,"03",,"Pedido de Venda"	,,06,.F.,)
TRCell():New(oSection,"04",,"Código Importador"	,,06,.F.,)
TRCell():New(oSection,"05",,"Loja Importador" 	,,06,.F.,)
TRCell():New(oSection,"06",,"Importador" 	    ,,06,.F.,)
TRCell():New(oSection,"07",,"Dt Faturado"	    ,,06,.F.,)  // Dt Pedido/Emissão	
TRCell():New(oSection,"08",,"Item"	            ,,06,.F.,)
TRCell():New(oSection,"09",,"Produto" 	        ,,06,.F.,)
TRCell():New(oSection,"10",,"Descrição" 	    ,,06,.F.,)
TRCell():New(oSection,"11",,"Preço Unit" 		,,06,.F.,)
TRCell():New(oSection,"12",,"Qtde" 		        ,,06,.F.,)
TRCell():New(oSection,"13",,"Valor Total" 	    ,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("EE7")

Return oReport

/*/Protheus.doc ReportPrint
@(long_description) Responsável pela impressão e apresentação das informações.
@author Eduardo Pereira - Sigamat
@since 26/05/2021
@version 12.1.25
/*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[99]
Local cQryPRC   := ""
Local nPrcEE8   := 0

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

oReport:SetTitle("Relatório de Pedidos Faturados")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        If Select("TRBEE8") > 0
            TRBEE8->( dbCloseArea() )
        EndIf
        cQryPRC := " SELECT EE8_PRECO FROM " + RetSQLName("EE8")
        cQryPRC += " WHERE D_E_L_E_T_ = ' ' ""
        cQryPRC += "     AND EE8_FILIAL = '" + (cAliasLif)->EE7_FILIAL + "' " 
        cQryPRC += "     AND EE8_PEDIDO = '" + (cAliasLif)->EE7_PEDIDO + "' "
        cQryPRC += "     AND EE8_COD_I = '" + (cAliasLif)->D2_COD + "' "
        dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryPRC),"TRBEE8")
        If TRBEE8->( !Eof() )
            nPrcEE8 := TRBEE8->EE8_PRECO
        EndIf
        aDados1[01]	:= (cAliasLif)->EE7_FILIAL
        aDados1[02]	:= (cAliasLif)->EE7_PEDIDO
        aDados1[03]	:= (cAliasLif)->EE7_PEDFAT
        aDados1[04]	:= (cAliasLif)->EE7_IMPORT  
        aDados1[05]	:= (cAliasLif)->EE7_IMLOJA
        aDados1[06]	:= (cAliasLif)->EE7_IMPODE
        aDados1[07]	:= DtoC(StoD((cAliasLif)->D2_EMISSAO))
        aDados1[08]	:= (cAliasLif)->D2_ITEM  
        aDados1[09]	:= (cAliasLif)->D2_COD  
        aDados1[10]	:= Alltrim(Posicione("SB1", 1, xFilial("SB1") + (cAliasLif)->D2_COD, "B1_DESC"))
        aDados1[11]	:= nPrcEE8
        aDados1[12]	:= (cAliasLif)->D2_QUANT
        aDados1[13]	:= aDados1[11] * aDados1[12]
        oSection1:PrintLine()
        aFill(aDados1,Nil)
        (cAliasLif)->( dbskip() )
    End
EndIf

// EE8_FILIAL+EE8_PEDIDO+EE8_SEQUEN+EE8_COD_I

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
cQuery += "     EE7_FILIAL, EE7_PEDIDO, EE7_PEDFAT, EE7_IMPORT, EE7_IMLOJA, EE7_IMPODE, "
cQuery += "     D2_EMISSAO, D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_DOC "
//cQuery += "     EE8_SEQUEN, EE8_COD_I, EE8_PRECO, EE8_SLDINI, EE8_PRCTOT "
//cQuery += "     D2_EMISSAO, D2_DOC, D2_PRCVEN, D2_TOTAL "
cQuery += " FROM " + RetSQLName("EE7") + " EE7 "
//cQuery += " LEFT JOIN " + RetSQLName("EE8") + " EE8 "
//cQuery += "     ON EE8_FILIAL = EE7_FILIAL AND EE8_PEDIDO = EE7_PEDIDO AND EE8.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RetSQLName("SD2") + " SD2 "
cQuery += "     ON D2_FILIAL = EE7_FILIAL AND D2_PEDIDO = EE7_PEDFAT AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE EE7.D_E_L_E_T_ = ' ' "
cQuery += "     AND EE7_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "
cQuery += "     AND EE7_PEDIDO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' "
cQuery += "     AND EE7_DTPEDI BETWEEN '" + DtoS(Mv_Par05) + "' AND '" + DtoS(Mv_Par06) + "' "
cQuery += " ORDER BY D2_DOC "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/Protheus.doc AjustaSX1
@description Cria arquivo de perguntas
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 26/05/2021
/*/

Static Function AjustaSX1(cPerg)

Local i := 0
Local j := 0
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
aRegs := {}

aAdd(aRegs,{cPerg, "01", "Filial De"      , "Filial De"   , "Filial De"   ,"mv_ch1","C",2,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "02", "Filial Até"     , "Filial Até"  , "Filial Até"  ,"mv_ch1","C",2,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "03", "Pedido De"      , "Pedido De"   , "Pedido De"   ,"mv_ch3","C",9,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "04", "Pedido Ate"     , "Pedido Até"  , "Pedido Até"  ,"mv_ch4","C",9,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "05", "Emissao De"     , "Emissao De"  , "Emissao De"  ,"mv_ch5","D",8,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "06", "Emissao Ate"    , "Emissao Até" , "Emissao Até" ,"mv_ch6","D",8,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
