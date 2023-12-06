#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TOPConn.ch"

/*/Protheus.doc RSTCOM01
@(long_description) Relatorio de Clientes sem movimentação de compras dos ultimos 3 meses
@author Eduardo Pereira - Sigamat
@since 04/05/2021
@version 12.1.25
/*/

User Function RSTCOM01()

Local   oReport
Private cPerg 			:= PadR("RSTCOM01",10)
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
@since 28/01/2021
@version 12.1.25
/*/

Static Function ReportDef()

Local oReport
Local oSection

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPergTit,"RELATÓRIO CLIENTE SEM MOV. COMP. ULT. 3 MESES",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o relatório de Cliente sem Mov. Comp. Ult. 3 Meses.")

oSection := TRSection():New(oReport,"Relatório Cliente sem Mov. Comp. Ult. 3 Meses",{"SA1"})

TRCell():New(oSection,"01",,"Cliente" 			,,06,.F.,)
TRCell():New(oSection,"02",,"Loja" 		        ,,06,.F.,)
TRCell():New(oSection,"03",,"CGC"			    ,,06,.F.,)	
TRCell():New(oSection,"04",,"Nome"			    ,,06,.F.,)	
TRCell():New(oSection,"05",,"Tipo"  			,,06,.F.,)
TRCell():New(oSection,"06",,"Endereço" 	        ,,06,.F.,)
TRCell():New(oSection,"07",,"Estado" 		    ,,06,.F.,)
TRCell():New(oSection,"08",,"Bairro" 			,,06,.F.,)
TRCell():New(oSection,"09",,"CEP" 		        ,,06,.F.,)
TRCell():New(oSection,"10",,"Telefone" 			,,06,.F.,)
TRCell():New(oSection,"11",,"E-mail" 		    ,,06,.F.,)
TRCell():New(oSection,"12",,"Situação" 		    ,,06,.F.,)
TRCell():New(oSection,"13",,"Vendedor" 			,,06,.F.,)
TRCell():New(oSection,"14",,"Nome Vendedor" 	,,06,.F.,)
TRCell():New(oSection,"15",,"E-mail Vendedor" 	,,06,.F.,)
TRCell():New(oSection,"16",,"Ultima Compra" 	,,06,.F.,)
TRCell():New(oSection,"17",,"Data do Cadastro" 	,,06,.F.,)
TRCell():New(oSection,"18",,"Coordenador" 		,,06,.F.,)
TRCell():New(oSection,"19",,"Nome Coordenador" 	,,06,.F.,)
TRCell():New(oSection,"20",,"E-mail Coordenador",,06,.F.,)
TRCell():New(oSection,"21",,"Grupo" 		    ,,06,.F.,)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("Z2A")

Return oReport

/*/Protheus.doc ReportPrint
@(description) Responsável pela impressão e apresentação das informações.
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 04/05/2021
/*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local aDados[2]
Local aDados1[99]
Local cNomSup   := ""
Local cMailSup  := ""

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

oReport:SetTitle("Relatório Cliente sem Mov. Comp. Ult. 3 Meses")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,Nil)
aFill(aDados1,Nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

dbSelectArea(cAliasLif)
(cAliasLif)->( dbgotop() )
If Select(cAliasLif) > 0
    While (cAliasLif)->( !Eof() )
        SA3->( dbSetOrder(1) )  // A3_FILIAL + A3_COD
        If SA3->( dbSeek(xFilial("SA3") + (cAliasLif)->A3_SUPER) )
            cNomSup  := Alltrim(SA3->A3_NOME)    // Posicione("SA3", 1, xFilial("SA3") + cSuper, "A3_NOME")
            cMailSup := Alltrim(SA3->A3_EMAIL)   // Posicione("SA3", 1, xFilial("SA3") + cSuper, "A3_NOME")
        EndIf
        aDados1[01]	:= (cAliasLif)->A1_COD
        aDados1[02]	:= (cAliasLif)->A1_LOJA
        aDados1[03]	:= (cAliasLif)->A1_CGC
        aDados1[04]	:= (cAliasLif)->A1_NOME  
        aDados1[05]	:= (cAliasLif)->A1_PESSOA  
        aDados1[06]	:= (cAliasLif)->A1_END
        aDados1[07]	:= (cAliasLif)->A1_EST
        aDados1[08]	:= (cAliasLif)->A1_BAIRRO  
        aDados1[09]	:= (cAliasLif)->A1_CEP  
        aDados1[10]	:= (cAliasLif)->A1_TEL
        aDados1[11]	:= (cAliasLif)->A1_EMAIL
        aDados1[12]	:= If((cAliasLif)->A1_MSBLQL == "2", "LIBERADO", "BLOQUEADO")
        aDados1[13]	:= (cAliasLif)->A1_VEND  
        aDados1[14]	:= (cAliasLif)->A3_NOME  
        aDados1[15]	:= (cAliasLif)->A3_EMAIL  
        aDados1[16]	:= DtoC(StoD((cAliasLif)->A1_ULTCOM))
        aDados1[17]	:= DtoC(StoD((cAliasLif)->A1_DTCAD))
        aDados1[18]	:= (cAliasLif)->A3_SUPER
        aDados1[19]	:= cNomSup
        aDados1[20]	:= cMailSup
        aDados1[21]	:= (cAliasLif)->A1_GRPVEN
        oSection1:PrintLine()
        aFill(aDados1,Nil)
        (cAliasLif)->( dbskip() )
    End
EndIf

oReport:SkipLine()

Return oReport

/*/Protheus.doc StQuery
@description Filtra as informações das Tabelas PP7 x PP8 por Codigo e Data de Emissão
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 04/05/2021
/*/

Static Function StQuery()

Local cQuery := ""

If Select(cAliasLif) > 0
    (cAliasLif)->( dbCloseArea() )
EndIf
cQuery := " SELECT "
cQuery += " 	A1_COD, A1_LOJA, A1_CGC, A1_NOME, A1_PESSOA, A1_END, A1_EST, A1_BAIRRO, A1_CEP, A1_TEL, A1_EMAIL, A1_VEND, A1_DTCAD, A1_GRPVEN, A1_ULTCOM, A1_MSBLQL,"
cQuery += " 	A3_NOME, A3_EMAIL, A3_SUPER "
cQuery += " FROM " + RetSQLName("SA1") + " A1 "
cQuery += " LEFT JOIN " + RetSQLName("SA3") + " A3 "
cQuery += " ON A3_COD = A1_VEND AND A3.D_E_L_E_T_ = ' ' "
cQuery += " WHERE A1.D_E_L_E_T_ = ' ' "
cQuery += " 	AND A1_COD BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "  // 093390
cQuery += "     AND A3_COD BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' "
cQuery += "     AND A1_GRPVEN BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*/Protheus.doc AjustaSX1
@description Cria arquivo de perguntas
@version 12.1.25
@author Eduardo Pereira - Sigamat
@since 04/05/2021
/*/

Static Function AjustaSX1(cPerg)

Local aAreaX1     := GetArea()
Local _aRegistros := {}
Local i           := 0
Local j           := 0

aAdd(_aRegistros,{cPerg, "01", "Cliente De"     , "Cliente De"      , "Cliente De"   ,"mv_ch1","C",6,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "02", "Cliente Ate"    , "Cliente Ate"     , "Cliente Ate"  ,"mv_ch2","C",6,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "03", "Vendedor De"    , "Vendedor De"     , "Vendedor De"  ,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "04", "Vendedor Ate"   , "Vendedor Ate"    , "Vendedor Ate" ,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "05", "Grupo De"       , "Grupo De"        , "Grupo De"     ,"mv_ch5","C",3,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aRegistros,{cPerg, "06", "Grupo Ate"      , "Grupo Ate"       , "Grupo Ate"    ,"mv_ch6","C",3,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
