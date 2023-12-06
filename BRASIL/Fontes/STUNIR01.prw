#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/{Protheus.doc} STUNIR01
@(long_description) Relatorio do Unicom - Tabela PP7 x PP8 x SA3
@type Function
@author Eduardo Pereira - Sigamat
@since 28/01/2021
@version 12.1.25
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function STUNIR01()

Local   oReport
Private cPerg 			:= PadR("STUNIR01",10)
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

/*/{Protheus.doc} ReportDef
@(long_description) Montagem das Perguntas e do cabeçalho do relatório.
@type Function
@author Eduardo Pereira - Sigamat
@since 28/01/2021
@version 12.1.25
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function ReportDef()

Local oReport
Local oSection

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPergTit,"RELATÓRIO PP7",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório PP7.")

oSection := TRSection():New(oReport,"Relatório PP7",{"PP7"})

TRCell():New(oSection,"01",,"Filial"		    ,,06,.F.,)
TRCell():New(oSection,"02",,"Atendimento"		,,06,.F.,)
TRCell():New(oSection,"03",,"Cliente" 			,,06,.F.,)
TRCell():New(oSection,"04",,"Loja" 		        ,,06,.F.,)
TRCell():New(oSection,"05",,"Nome"			    ,,06,.F.,)	
TRCell():New(oSection,"06",,"Emissao"			,,06,.F.,)
TRCell():New(oSection,"07",,"Representante" 	,,06,.F.,)
TRCell():New(oSection,"08",,"Vend Interno" 		,,06,.F.,)
TRCell():New(oSection,"09",,"Obra" 			    ,,06,.F.,)
TRCell():New(oSection,"10",,"Observacoes" 		,,06,.F.,)
TRCell():New(oSection,"11",,"Status" 			,,06,.F.,)
TRCell():New(oSection,"12",,"Cond Pagto" 		,,06,.F.,)
TRCell():New(oSection,"13",,"Tabela" 			,,06,.F.,)
TRCell():New(oSection,"14",,"Tipo Forneci" 		,,06,.F.,)
TRCell():New(oSection,"15",,"Tipo Entrega" 		,,06,.F.,)
TRCell():New(oSection,"16",,"Contato" 			,,06,.F.,)
TRCell():New(oSection,"17",,"Nome Contato" 		,,06,.F.,)
TRCell():New(oSection,"18",,"Ender Obra" 		,,06,.F.,)
TRCell():New(oSection,"19",,"Dt Programac" 		,,06,.F.,)
TRCell():New(oSection,"20",,"Tp Consumo" 		,,06,.F.,)
TRCell():New(oSection,"21",,"Entrega P.V" 		,,06,.F.,)
TRCell():New(oSection,"22",,"Pedido Venda" 		,,06,.F.,)
TRCell():New(oSection,"23",,"Trava Orcame" 		,,06,.F.,)
TRCell():New(oSection,"24",,"Vlr Fechado" 		,,06,.F.,)
TRCell():New(oSection,"25",,"Mot Bloquei" 		,,06,.F.,)
TRCell():New(oSection,"26",,"Status Pedid" 		,,06,.F.,)
TRCell():New(oSection,"27",,"Tp Frete" 			,,06,.F.,)
TRCell():New(oSection,"28",,"Tipo Cliente" 		,,06,.F.,)
TRCell():New(oSection,"29",,"Cod.Msg.Can" 		,,06,.F.,)
TRCell():New(oSection,"30",,"Cod.Mot.Canc" 		,,06,.F.,)
TRCell():New(oSection,"31",,"Aprovador" 		,,06,.F.,)
TRCell():New(oSection,"32",,"Dt Envio" 			,,06,.F.,)
TRCell():New(oSection,"33",,"N. Envio" 			,,06,.F.,)
TRCell():New(oSection,"34",,"Prazo orc" 		,,06,.F.,)
TRCell():New(oSection,"35",,"Prazo desen" 		,,06,.F.,)
TRCell():New(oSection,"36",,"Rejeitado" 		,,06,.F.,)
TRCell():New(oSection,"37",,"Dt.Rejeitado" 		,,06,.F.,)
TRCell():New(oSection,"38",,"Motivo Rejei" 		,,06,.F.,)
TRCell():New(oSection,"39",,"Pr Comercial" 		,,06,.F.,)
TRCell():New(oSection,"40",,"Supervisor" 		,,06,.F.,)
TRCell():New(oSection,"41",,"Nome Supervisor"	,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("Z2A")

Return oReport

/*/{Protheus.doc} ReportPrint
@(long_description) Responsável pela impressão e apresentação das informações.
@type Function
@author Eduardo Pereira - Sigamat
@since 28/01/2021
@version 12.1.25
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[99]
Local cNotas    := ""
Local cMotRej   := ""
Local cSuper    := ""
Local cDesc     := ""

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
oSection1:Cell("26") :SetBlock( { || aDados1[26] } )
oSection1:Cell("27") :SetBlock( { || aDados1[27] } )
oSection1:Cell("28") :SetBlock( { || aDados1[28] } )
oSection1:Cell("29") :SetBlock( { || aDados1[29] } )
oSection1:Cell("30") :SetBlock( { || aDados1[30] } )
oSection1:Cell("31") :SetBlock( { || aDados1[31] } )
oSection1:Cell("32") :SetBlock( { || aDados1[32] } )
oSection1:Cell("33") :SetBlock( { || aDados1[33] } )
oSection1:Cell("34") :SetBlock( { || aDados1[34] } )
oSection1:Cell("35") :SetBlock( { || aDados1[35] } )
oSection1:Cell("36") :SetBlock( { || aDados1[36] } )
oSection1:Cell("37") :SetBlock( { || aDados1[37] } )
oSection1:Cell("38") :SetBlock( { || aDados1[38] } )
oSection1:Cell("39") :SetBlock( { || aDados1[39] } )
oSection1:Cell("40") :SetBlock( { || aDados1[40] } )
oSection1:Cell("41") :SetBlock( { || aDados1[41] } )

oReport:SetTitle("Relatorio PP7")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        PP7->( dbSetOrder(1) )  // PP7_FILIAL + PP7_CODIGO
        If PP7->( dbSeek(xFilial("PP7") + (cAliasLif)->PP7_CODIGO) )
            cNotas  := Alltrim(PP7->PP7_NOTAS)
            cMotRej := Alltrim(PP7->PP7_MOTREJ)
        EndIf
        SA3->( dbSetOrder(1) )  // A3_FILIAL + A3_COD
        If SA3->( dbSeek(xFilial("SA3") + (cAliasLif)->PP7_REPRES) )
            cSuper  := Alltrim(SA3->A3_SUPER)
            cDesc   := Posicione("SA3", 1, xFilial("SA3") + cSuper, "A3_NOME")
        EndIf
        aDados1[01]	:= (cAliasLif)->PP7_FILIAL
        aDados1[02]	:= (cAliasLif)->PP7_CODIGO
        aDados1[03]	:= (cAliasLif)->PP7_CLIENT
        aDados1[04]	:= (cAliasLif)->PP7_LOJA  
        aDados1[05]	:= (cAliasLif)->PP7_NOME  
        aDados1[06]	:= DtoC(StoD((cAliasLif)->PP7_EMISSA))
        aDados1[07]	:= (cAliasLif)->PP7_REPRES
        aDados1[08]	:= (cAliasLif)->PP7_VEND  
        aDados1[09]	:= (cAliasLif)->PP7_OBRA  
        aDados1[10]	:= cNotas  // Memo
        aDados1[11]	:= (cAliasLif)->PP7_STATUS
        aDados1[12]	:= (cAliasLif)->PP7_CPAG  
        aDados1[13]	:= (cAliasLif)->PP7_REGRA 
        aDados1[14]	:= (cAliasLif)->PP7_TIPF  
        aDados1[15]	:= (cAliasLif)->PP7_TIPO  
        aDados1[16]	:= (cAliasLif)->PP7_CODCON
        aDados1[17]	:= (cAliasLif)->PP7_CONTAT
        aDados1[18]	:= (cAliasLif)->PP7_ENDOBR
        aDados1[19]	:= (cAliasLif)->PP7_DTPROG
        aDados1[20]	:= (cAliasLif)->PP7_ZCONSU
        aDados1[21]	:= (cAliasLif)->PP7_DTNEC 
        aDados1[22]	:= (cAliasLif)->PP7_PEDIDO
        aDados1[23]	:= (cAliasLif)->PP7_TRAVA 
        aDados1[24]	:= (cAliasLif)->PP7_VLRFEC
        aDados1[25]	:= (cAliasLif)->PP7_ZMOTBL
        aDados1[26]	:= (cAliasLif)->PP7_ZBLOQ 
        aDados1[27]	:= (cAliasLif)->PP7_TPFRET
        aDados1[28]	:= (cAliasLif)->PP7_ZTIPOC
        aDados1[29]	:= (cAliasLif)->PP7_XCODCA
        aDados1[30]	:= (cAliasLif)->PP7_XCODMC
        aDados1[31]	:= (cAliasLif)->PP7_APROV 
        aDados1[32]	:= (cAliasLif)->PP7_ENVM  
        aDados1[33]	:= (cAliasLif)->PP7_NUMENV
        aDados1[34]	:= (cAliasLif)->PP7_PRAZO 
        aDados1[35]	:= (cAliasLif)->PP7_PRZDES
        aDados1[36]	:= (cAliasLif)->PP7_REJEIT
        aDados1[37]	:= (cAliasLif)->PP7_DTREJE
        aDados1[38]	:= cMotRej
        aDados1[39]	:= (cAliasLif)->PRC_COM
        aDados1[40]	:= cSuper   //Posicione("SA3", 1, xFilial("SA3") + (cAliasLif)->PP7_VEND, "A3_SUPER")
        aDados1[41]	:= cDesc
        oSection1:PrintLine()
        aFill(aDados1,Nil)
        (cAliasLif)->( dbskip() )
    End
EndIf

oReport:SkipLine()

Return oReport

/*/{Protheus.doc} StQuery
@description Filtra as informações das Tabelas PP7 x PP8 por Codigo e Data de Emissão
@type function
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 28/01/2021
@param cPerg, character, param_description
@return return_type, return_description
/*/

Static Function StQuery()

Local cQuery := ""

If Select(cAliasLif) > 0
    (cAliasLif)->( dbCloseArea() )
EndIf

cQuery += " SELECT
cQuery += "     PP7_FILIAL, PP7_CODIGO, PP7_CLIENT, PP7_LOJA, PP7_NOME, PP7_EMISSA, PP7_REPRES, PP7_VEND, PP7_OBRA, PP7_STATUS, PP7_CPAG, PP7_REGRA, PP7_TIPF, "
cQuery += "     PP7_TIPO, PP7_CODCON, PP7_CONTAT, PP7_ENDOBR, PP7_DTPROG, PP7_ZCONSU, PP7_DTNEC, PP7_PEDIDO, PP7_TRAVA, PP7_VLRFEC, PP7_ZMOTBL, PP7_ZBLOQ, "
cQuery += "     PP7_TPFRET, PP7_ZTIPOC, PP7_XCODCA, PP7_XCODMC, PP7_APROV, PP7_ENVM, PP7_NUMENV, PP7_PRAZO, PP7_PRZDES, PP7_REJEIT, PP7_DTREJE, SUM(PP8_PRCOM) PRC_COM " 
cQuery += " FROM " + RetSqlName("PP7") + " PP7 "
cQuery += " INNER JOIN " + RetSqlName("PP8") + " PP8 "
cQuery += "     ON PP8_FILIAL = PP7_FILIAL AND PP8_CODIGO = PP7_CODIGO AND PP8.D_E_L_E_T_ = ' ' "
cQuery += " WHERE PP7.D_E_L_E_T_ = ' ' "
cQuery += "     AND PP7_CODIGO BETWEEN '" + Mv_Par01 + "' AND '" + Alltrim(Mv_Par02) + "' "
cQuery += "     AND PP7_EMISSA BETWEEN '" + DtoS(Mv_Par03) + "' AND '" + DtoS(Mv_Par04) + "' "
cQuery += " GROUP BY "
cQuery += "     PP7_FILIAL, PP7_CODIGO, PP7_CLIENT, PP7_LOJA, PP7_NOME, PP7_EMISSA, PP7_REPRES, PP7_VEND, PP7_OBRA, PP7_STATUS, PP7_CPAG, PP7_REGRA, PP7_TIPF, "
cQuery += "     PP7_TIPO, PP7_CODCON, PP7_CONTAT, PP7_ENDOBR, PP7_DTPROG, PP7_ZCONSU, PP7_DTNEC, PP7_PEDIDO, PP7_TRAVA, PP7_VLRFEC, PP7_ZMOTBL, PP7_ZBLOQ, "
cQuery += "     PP7_TPFRET, PP7_ZTIPOC, PP7_XCODCA, PP7_XCODMC, PP7_APROV, PP7_ENVM, PP7_NUMENV, PP7_PRAZO, PP7_PRZDES, PP7_REJEIT, PP7_DTREJE "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/{Protheus.doc} AjustaSX1
@description Cria arquivo de perguntas
@type function
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 28/01/2021
@param cPerg, character, param_description
@return return_type, return_description
/*/

Static Function AjustaSX1(cPerg)

Local aAreaX1     := GetArea()
Local _aRegistros := {}
Local i           := 0
Local j           := 0

aAdd(_aRegistros,{cPerg, "01", "Codigo De"  , "Codigo De"    , "Codigo De"    ,"mv_ch1","C",6,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "02", "Codigo Até" , "Codigo Até"   , "Codigo Até"   ,"mv_ch2","C",6,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "03", "Data De"    , "Data De"      , "Data De"      ,"mv_ch3","D",8,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "04", "Data Até"   , "Data Até"     , "Data Até"     ,"mv_ch4","D",8,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
_nCols	:= FCount()
cPerg	:= PadR(cPerg,Len(SX1->X1_GRUPO))

For i := 1 to Len(_aRegistros)
    aSize(_aRegistros[i],_nCols)
    If !dbSeek(cPerg + _aRegistros[i,2])
        RecLock("SX1",.T.)
        For j := 1 to FCount()
            If j <= Len(_aRegistros[i])
                FieldPut(j,_aRegistros[i,j])
            EndIf
        Next j
        MsUnlock()
    EndIf
Next i

RestArea(aAreaX1)

Return
