#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RSTFAT71  บAutor  ณJoใo Victor         บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de f้rias solicitadas pelo portal               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT71()
*-----------------------------*
Local   oReport
Private cPerg 		:= "RFAT71"
Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
Private cTime        := Time()
Private cHora        := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private lXlsHeader   := .f.
Private lXmlEndRow   := .f.
Private cPergTit 		:= cAliasLif

//-------cGrupo,cOrdem ,cPergunt                  ,cPergSpa                   ,cPergEng                   ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01                      ,cDefSpa1,cDefEng1,cCnt01               ,cDef02           ,cDefSpa2  ,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                         ,cDefSpa4,cDefEng4,cDef05    ,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
PutSx1(cPerg   ,"01"   ,"Filial De :?"            ,"Filial De: ?"             ,"Filial De: ?"             ,"mv_ch1"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                          ,""      ,""      ,"  "                 ,""               ,""        ,""      ,""             ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"02"   ,"Filial At้ :?"           ,"Filial At้: ?"            ,"Filial At้: ?"            ,"mv_ch2"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""                          ,""      ,""      ,"ZZ"                 ,""               ,""        ,""      ,""             ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"03"   ,"M๊s Inํcio F้rias De: ?" ,"M๊s Inํcio F้rias De: ?"  ,"M๊s Inํcio F้rias De: ?"  ,"mv_ch3"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par03"    ,""                          ,""      ,""      ," "                  ,""               ,""        ,""      ,""             ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"04"   ,"M๊s Inํcio F้rias At้: ?","M๊s Inํcio F้rias At้ : ?","M๊s Inํcio F้rias At้: ?" ,"mv_ch4"    ,"C"   ,02      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par04"    ,""                          ,""      ,""      ," "                  ,""               ,""        ,""      ,""             ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"05"   ,"Ano Inํcio F้rias: ?"    ,"Ano Inํcio F้rias: ?"     ,"Ano Inํcio F้rias: ?"     ,"mv_ch5"    ,"C"   ,04      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par05"    ,""                          ,""      ,""      ," "                  ,""               ,""        ,""      ,""             ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"06"   ,"Ordena็ใo: ?"            ,"Ordena็ใo: ?"             ,"Ordena็ใo: ?"             ,"mv_ch6"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par06"    ,"1-Filial"                  ,""      ,""      ,""                   ,"2-Matrํcula"    ,""        ,""      ,"3-Nome"       ,""      ,""      ,""                             ,""      ,""      ,""        ,""      ,"")
PutSx1(cPerg   ,"07"   ,"Status: ?"               ,"Status: ?"                ,"Status: ?"                ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par07"    ,"1-Em processo de aprova็ใo",""      ,""      ,""                   ,"2-Atendida"     ,""        ,""      ,"3-Reprovada"  ,""      ,""      ,"4-Aguardando Efetivacao do RH",""      ,""      ,"5-Todos" ,""      ,"")

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  13/03/15   บฑฑ
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
Local oSection1

oReport := TReport():New(cPergTit,"RELATำRIO DE FษRIAS SOLICITADAS PELO PORTAL",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir as f้rias solicitadas pelo Portal")

Pergunte(cPerg,.F.)

//Primeira Se็ใo
oSection := TRSection():New(oReport,"Itens",{"RH4","SRA","RH3"})

TRCell():New(oSection,"01",,"Filial"		                 ,PesqPict("RH4","RH4_FILIAL") ,TamSX3("RH4_FILIAL") [1]+4)
TRCell():New(oSection,"02",,"Seq"                          ,PesqPict("RH4","RH4_CODIGO") ,TamSX3("RH4_CODIGO") [1]+4)
TRCell():New(oSection,"03",,"Matrํcula"                    ,PesqPict("SRA","RA_MAT")     ,TamSX3("RA_MAT")     [1]+4)
TRCell():New(oSection,"04",,"Nome do Colaborador"          ,PesqPict("SRA","RA_NOME")    ,TamSX3("RA_NOME")    [1]+4)
TRCell():New(oSection,"05",,"Dt. Inํcio"                   ,PesqPict("SRA","RA_ADMISSA") ,TamSX3("RA_ADMISSA") [1]+4)
TRCell():New(oSection,"06",,"Dt. Fim"                      ,PesqPict("SRA","RA_ADMISSA") ,TamSX3("RA_ADMISSA") [1]+4)
TRCell():New(oSection,"07",,"Dias"                         ,PesqPict("SRA","RA_MESESAN") ,TamSX3("RA_MESESAN") [1]+4)
TRCell():New(oSection,"08",,"Op็ใo 13บ?"                   ,PesqPict("RH3","RH3_ORIGEM") ,TamSX3("RH3_ORIGEM") [1]+4)
TRCell():New(oSection,"09",,"Abono?"                       ,PesqPict("RH3","RH3_ORIGEM") ,TamSX3("RH3_ORIGEM") [1]+4)
TRCell():New(oSection,"10",,"Status?"                      ,PesqPict("SRA","RA_NOME")    ,TamSX3("RA_NOME")    [1]+4)

//Segunda se็ใo
oSection1 := TRSection():New(oReport,"Total de Registros:",{"TRB"})

TRCell():New(oSection1,"TOTAL1","TRB","Total de Registros"  ,PesqPict("SRA","RA_MAT")     ,TamSX3("RA_MAT")     [1]+4)

oSection:SetHeaderSection(.T.)
oSection1:SetHeaderSection(.T.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  13/03/15   บฑฑ
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
Local oSection1	:= oReport:Section(2)
//Local oSection
//Local oSection1
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local nTotal 	:= 0

if !MV_PAR03 $ '01--02--03--04--05--06//07--08--09--10--11--12'               
    MsgStop("Somente Meses de 01 a 12 sใo vแlidos para M๊s Inํcio F้rias De !!! Verifique !!!")          
    Return
endif                     

if !MV_PAR04 $ '01--02--03--04--05--06//07--08--09--10--11--12'               
    MsgStop("Somente Meses de 01 a 12 sใo vแlidos para M๊s Inํcio F้rias At้ !!! Verifique !!!")          
    Return
endif

if val(mv_par05) > year(dDatabase)+10 .or. val(mv_par05) < year(dDatabase)-10 
    MsgStop("Ano invแlido !!! Verifique !!!")          
    Return
endif  


oSection:Cell("01") :SetBlock( { || aDados1[01] } )
oSection:Cell("02") :SetBlock( { || aDados1[02] } )
oSection:Cell("03") :SetBlock( { || aDados1[03] } )
oSection:Cell("04") :SetBlock( { || aDados1[04] } )
oSection:Cell("05") :SetBlock( { || aDados1[05] } )
oSection:Cell("06") :SetBlock( { || aDados1[06] } )
oSection:Cell("07") :SetBlock( { || aDados1[07] } )
oSection:Cell("08") :SetBlock( { || aDados1[08] } )
oSection:Cell("09") :SetBlock( { || aDados1[09] } )
oSection:Cell("10") :SetBlock( { || aDados1[10] } )

oSection1:Cell("TOTAL1"):SetBlock( { || nTotal } )

oReport:SetTitle("RELATำRIO DE FษRIAS SOLICITADAS PELO PORTAL")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()
oSection1:Init()


Processa({|| StQuery(  ) },"Compondo Relat๓rio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:= (cAliasLif)->FILIAL
		aDados1[02]	:= (cAliasLif)->SEQ
		aDados1[03]	:= (cAliasLif)->MATRICULA
		aDados1[04]	:= (cAliasLif)->NOME
		aDados1[05]	:= (cAliasLif)->DATAINI
		aDados1[06]	:= (cAliasLif)->DATAFIM	
		aDados1[07]	:= (cAliasLif)->DIAS
		aDados1[08]	:= (cAliasLif)->OPC13
		aDados1[09]	:= (cAliasLif)->ABONO
		aDados1[10]	:= (cAliasLif)->STATUS
		nTotal	++
		oSection:PrintLine()
	
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	
	oReport:SkipLine()
	oSection1:PrintLine()
	
	aFill(aDados1,nil)
	
	(cAliasLif)->(dbCloseArea())
EndIf
oReport:SkipLine()

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |StQuery   บAutor  ณJoใo Victor         บ Data ณ  13/03/15   บฑฑ
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
cQuery += " DISTINCT RH4_FILIAL AS FILIAL, 
cQuery += " RH4_CODIGO AS SEQ,
cQuery += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" H42 WHERE H42.D_E_L_E_T_=' ' AND RH4_CAMPO='R8_MAT'     AND H4.RH4_FILIAL=H42.RH4_FILIAL AND H4.RH4_CODIGO=H42.RH4_CODIGO) AS MATRICULA,
cQuery += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" H43 WHERE H43.D_E_L_E_T_=' ' AND RH4_CAMPO='TMP_NOME'   AND H4.RH4_FILIAL=H43.RH4_FILIAL AND H4.RH4_CODIGO=H43.RH4_CODIGO) AS NOME,
cQuery += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" H44 WHERE H44.D_E_L_E_T_=' ' AND RH4_CAMPO='R8_DATAINI' AND H4.RH4_FILIAL=H44.RH4_FILIAL AND H4.RH4_CODIGO=H44.RH4_CODIGO) AS DATAINI,
cQuery += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" H45 WHERE H45.D_E_L_E_T_=' ' AND RH4_CAMPO='R8_DATAFIM' AND H4.RH4_FILIAL=H45.RH4_FILIAL AND H4.RH4_CODIGO=H45.RH4_CODIGO) AS DATAFIM,
cQuery += " (SELECT RH4_VALNOV FROM "+RetSqlName("RH4")+" H46 WHERE H46.D_E_L_E_T_=' ' AND RH4_CAMPO='R8_DURACAO' AND H4.RH4_FILIAL=H46.RH4_FILIAL AND H4.RH4_CODIGO=H46.RH4_CODIGO) AS DIAS,
cQuery += " (SELECT  
cQuery += " CASE WHEN RH4_VALNOV = '.T.'  THEN 'Optou' ELSE 
cQuery += " CASE WHEN RH4_VALNOV = '.F.'  THEN 'Nใo Optou' ELSE
cQuery += " 'SEM OPวรO' END END 
cQuery += " FROM "+RetSqlName("RH4")+" H47 WHERE H47.D_E_L_E_T_=' ' AND RH4_CAMPO='TMP_1P13SL' AND H4.RH4_FILIAL=H47.RH4_FILIAL AND H4.RH4_CODIGO=H47.RH4_CODIGO) AS OPC13,
cQuery += " (SELECT  
cQuery += " CASE WHEN RH4_VALNOV = '.T.'  THEN 'Optou' ELSE 
cQuery += " CASE WHEN RH4_VALNOV = '.F.'  THEN 'Nใo Optou' ELSE
cQuery += " 'SEM OPวรO' END END 
cQuery += " FROM "+RetSqlName("RH4")+" H48 WHERE H48.D_E_L_E_T_=' ' AND RH4_CAMPO='TMP_ABONO'  AND H4.RH4_FILIAL=H48.RH4_FILIAL AND H4.RH4_CODIGO=H48.RH4_CODIGO) AS ABONO,
cQuery += " CASE WHEN RH3_STATUS = '1'  THEN 'Em processo de aprovacao'    ELSE 
cQuery += " CASE WHEN RH3_STATUS = '2'  THEN 'Atendida'                    ELSE
cQuery += " CASE WHEN RH3_STATUS = '3'  THEN 'Reprovada'                   ELSE
cQuery += " CASE WHEN RH3_STATUS = '4'  THEN 'Aguardando Efetivacao do RH' ELSE
cQuery += " 'SEM OPวรO' END END END END AS STATUS

cQuery += " FROM "+RetSqlName("RH4")+" H4 "

cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("RH3")+") H3 "
cQuery += " ON H3.D_E_L_E_T_ <> '*'
cQuery += " AND RH4_FILIAL = RH3_FILIAL
cQuery += " AND RH4_CODIGO = RH3_CODIGO

cQuery += " WHERE H4.D_E_L_E_T_ = ' ' 
cQuery += " AND RH4_CAMPO       = 'R8_DATAINI'
cQuery += " AND RH4_FILIAL             BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'
cQuery += " AND SUBSTR(RH4_VALNOV,4,2) BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' 
cQuery += " AND SUBSTR(RH4_VALNOV,7,4) BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR05)+"'

If Mv_Par07 <> 5												
	cQuery += " AND RH3_STATUS = '"+ CVALTOCHAR(MV_PAR07) +"' 
Endif

If Mv_Par06 = 1
	cQuery += " ORDER BY FILIAL, SUBSTR(DATAINI,4,2), SUBSTR(DATAINI,7,2), SUBSTR(DATAINI,1,2)
Elseif Mv_Par06 = 2
	cQuery += " ORDER BY MATRICULA, SUBSTR(DATAINI,4,2), SUBSTR(DATAINI,7,2), SUBSTR(DATAINI,1,2)
Elseif Mv_Par06 = 3
	cQuery += " ORDER BY NOME, SUBSTR(DATAINI,4,2), SUBSTR(DATAINI,7,2), SUBSTR(DATAINI,1,2)
Endif
	
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()