#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/Protheus.doc STRCOMPC
@(long_description) Relatorio de Custo MP sem Imposto
@author Eduardo Pereira - Sigamat
@since 26/05/2021
@version 12.1.25
/*/

User Function STRCOMPC()

Local   oReport
Private cPerg 			:= PadR("STRCOMPC",10)
Private cTime           := Time()
Private cHora           := Substr(cTime, 1, 2)
Private cMinutos    	:= Substr(cTime, 4, 2)
Private cSegundos   	:= Substr(cTime, 7, 2)
Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
Private lXlsHeader      := .F.
Private lXmlEndRow      := .F.
Private cPergTit 		:= cAliasLif
Private nPisCof         := 0

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

oReport := TReport():New(cPergTit,"RELATÓRIO CUSTO MP SEM IMPOSTO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório de Custo MP sem Imposto.")

oSection := TRSection():New(oReport,"Relatório Custo MP sem Imposto",{"SC7"})

TRCell():New(oSection,"01",,"Filial"		    ,,06,.F.,)
TRCell():New(oSection,"02",,"Pedido"		    ,,06,.F.,)
TRCell():New(oSection,"03",,"Item"		        ,,06,.F.,)
TRCell():New(oSection,"04",,"Produto"		    ,,06,.F.,)
TRCell():New(oSection,"05",,"Descrição" 		,,06,.F.,)
TRCell():New(oSection,"06",,"Unidade Medida" 	,,06,.F.,)
TRCell():New(oSection,"07",,"Quantidade"		,,06,.F.,)
TRCell():New(oSection,"08",,"Preço Unitário"	,,06,.F.,)	
TRCell():New(oSection,"09",,"Prc Unit. Sem Imp"	,,06,.F.,)
TRCell():New(oSection,"10",,"Valor Total" 	    ,,06,.F.,)
TRCell():New(oSection,"11",,"Motivo de Compra" 	,,06,.F.,)
TRCell():New(oSection,"12",,"Fornecedor" 		,,06,.F.,)
TRCell():New(oSection,"13",,"Loja" 		        ,,06,.F.,)
TRCell():New(oSection,"14",,"Nome Fornecedor" 	,,06,.F.,)
TRCell():New(oSection,"15",,"Dt Emissão" 		,,06,.F.,)
TRCell():New(oSection,"16",,"Dt Entrega" 		,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SC7")

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

oReport:SetTitle("Relatorio de Custo MP sem Imposto")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        nPisCof := CalcPCC()
        aDados1[01]	:= (cAliasLif)->C7_FILIAL
        aDados1[02]	:= (cAliasLif)->C7_NUM
        aDados1[03]	:= (cAliasLif)->C7_ITEM
        aDados1[04]	:= (cAliasLif)->C7_PRODUTO
        aDados1[05]	:= (cAliasLif)->B1_DESC
        aDados1[06]	:= (cAliasLif)->C7_UM
        aDados1[07]	:= (cAliasLif)->C7_QUANT
        aDados1[08]	:= (cAliasLif)->C7_PRECO
        If cEmpAnt == "01"
            aDados1[09]	:= (cAliasLif)->C7_PRECO * ((100 - ((cAliasLif)->C7_PICM + nPisCof)) / 100)
        ElseIf cEmpAnt == "03"
            aDados1[09]	:= (cAliasLif)->C7_PRECO * ((100 - ((cAliasLif)->C7_PICM + (cAliasLif)->C7_DESC)) / 100)
        EndIf
        aDados1[10]	:= (cAliasLif)->C7_TOTAL
        aDados1[11]	:= (cAliasLif)->C7_MOTIVO
        aDados1[12]	:= (cAliasLif)->C7_FORNECE
        aDados1[13]	:= (cAliasLif)->C7_LOJA
        aDados1[14]	:= Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->C7_FORNECE + (cAliasLif)->C7_LOJA, "A2_NOME")  
        aDados1[15]	:= DtoC(StoD((cAliasLif)->C7_EMISSAO)) 
        aDados1[16]	:= DtoC(StoD((cAliasLif)->C7_DATPRF))
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
If cEmpAnt == "01"
    cQuery += "     C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT, C7_PRECO, C7_PICM, C7_TOTAL, C7_MOTIVO, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_DATPRF "
ElseIf cEmpAnt == "03"
    cQuery += "     C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT, C7_PRECO, C7_PICM, C7_DESC, C7_TOTAL, C7_MOTIVO, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_DATPRF "
EndIf
cQuery += " FROM " + RetSQLName("SC7") + " SC7 "
cQuery += " LEFT JOIN " + RetSQLName("SB1") + " SB1 "
cQuery += "     ON B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SC7.D_E_L_E_T_ = ' ' "
cQuery += "     AND C7_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "
cQuery += "     AND C7_NUM BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' "
cQuery += "     AND C7_EMISSAO BETWEEN '" + DtoS(Mv_Par05) + "' AND '" + DtoS(Mv_Par06) + "' "
cQuery += "     AND B1_TIPO = 'MP' "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/Protheus.doc CalcPCC
@description Calcula o PCC do Produto da última compra para o mesmo Fornecedor ou diferente.
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 18/06/2021
/*/

Static Function CalcPCC()

Local cQryD1    := ""
Local nCalcPCC  := 0

If Select("TRBSD1") > 0
    TRBSD1->( dbCloseArea() )
EndIf

cQryD1 += " SELECT "
cQryD1 += "     MAX(D1_EMISSAO), D1_ALQIMP6, D1_ALQIMP5 "
cQryD1 += " FROM " + RetSQLName("SD1")
cQryD1 += " WHERE D_E_L_E_T_ = ' ' "
cQryD1 += "     AND D1_FILIAL = '" + (cAliasLif)->C7_FILIAL + "' "
cQryD1 += "     AND D1_COD = '" + (cAliasLif)->C7_PRODUTO + "' "
cQryD1 += "     AND (D1_FORNECE = '" + (cAliasLif)->C7_FORNECE + "' OR D1_FORNECE <> '" + (cAliasLif)->C7_FORNECE + "') "
cQryD1 += "     AND ( D1_ALQIMP6 > 0 OR D1_ALQIMP5 > 0) "
cQryD1 += " GROUP BY D1_ALQIMP6, D1_ALQIMP5 "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryD1),"TRBSD1")

If TRBSD1->( !Eof() )
    nCalcPCC := TRBSD1->D1_ALQIMP6 + TRBSD1->D1_ALQIMP5
EndIf

Return nCalcPCC

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
aAdd(aRegs,{cPerg, "02", "Filial Ate"     , "Filial Ate"  , "Filial Ate"  ,"mv_ch2","C",2,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "03", "Pedido De"      , "Pedido De"   , "Pedido De"   ,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "04", "Pedido Ate"     , "Pedido Até"  , "Pedido Até"  ,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
