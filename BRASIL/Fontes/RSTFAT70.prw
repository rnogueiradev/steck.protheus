#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RSTFAT70  ºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório contendo os itens de nota fiscal de entrada     º±±
±±º          ³  que estejam alocados no centro de custo 112104 para       º±±
±±º          ³  as empresas 01-SP e 03-MAO                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT70()
*-----------------------------*
Local   oReport
Private cPerg 		:= "RFAT70"
Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
Private cTime        := Time()
Private cHora        := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private lXlsHeader   := .f.
Private lXmlEndRow   := .f.
Private cPergTit 		:= cAliasLif

//-------cGrupo,cOrdem,cPergunt          ,cPergSpa         ,cPergEng           ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02           ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
//PutSx1(cPerg ,"01"   ,"Filial ?"       ,"Filial ?"       ,"Filial ?"         ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""               ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
PutSx1(cPerg   , "01" , "Entrada De: ?"  ,"Entrada De: ?"  ,"Entrada De: ?"	  ,"mv_ch1"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par01"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""               ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   , "02" , "Entrada Até: ?" ,"Entrada Até: ?" ,"Entrada Até: ?"	  ,"mv_ch2"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par02"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""               ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   , "03" , "Demonstração: ?","Demonstração: ?","Demonstração: ?"  ,"mv_ch3"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par03"    ,"1-Analítico"     ,""      ,""      ,""                   ,"2-Sintético"    ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   , "04" , "Ordenação: ?"   ,"Ordenação: ?"   ,"Ordenação: ?"     ,"mv_ch4"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par04"    ,"1-Empresa"       ,""      ,""      ,""                   ,"2-Nota Fiscal"  ,""        ,""      ,"3-Entrada"    ,""      ,""      ,"4-Descrição Prod"    ,""      ,""      ,""    ,""      ,"")

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportDef ºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cabeçalho do Relatório  		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection
Local oSection1

oReport := TReport():New(cPergTit,"RELATÓRIO DE ITENS DE NOTA FISCAL DE ENTRADA PARA O CENTRO DE CUSTO 112104",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir os itens de nota Fiscal de Entrada do Centro de Custo 112104")

Pergunte(cPerg,.F.)

/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
dbSelectArea("SX1")
dbSetorder(1)//X1_GRUPO+X1_ORDEM
If SX1->(dbSeek(cPerg1+'01'))
	RecLock("SX1",.F.)
		SX1->X1_CNT01:= Dtoc(dDatabase-30)
	SX1->(MsUnlock())
Endif

If SX1->(dbSeek(cPerg1+'02'))
	RecLock("SX1",.F.)
		SX1->X1_CNT01:= Dtoc(dDatabase)
	SX1->(MsUnlock())
Endif
*/


//Primeira Seção
oSection := TRSection():New(oReport,"Itens",{"SD1","SA2","SB1"})

TRCell():New(oSection,"01",,"Empresa"		                 ,PesqPict("SD1","D1_FILIAL") ,TamSX3("D1_FILIAL") [1]+4)
TRCell():New(oSection,"02",,"Razão Social"                 ,PesqPict("SA2","A2_NOME")   ,TamSX3("A2_NOME")   [1]+4)
TRCell():New(oSection,"03",,"Descrição"                    ,PesqPict("SB1","B1_DESC")   ,TamSX3("B1_DESC")   [1]+4)
TRCell():New(oSection,"04",,"Nota Fiscal"                  ,PesqPict("SD1","D1_DOC")    ,TamSX3("D1_DOC")    [1]+4)
TRCell():New(oSection,"05",,"Dt. Entrada"                  ,PesqPict("SD1","D1_DTDIGIT"),TamSX3("D1_DTDIGIT")[1]+4)
TRCell():New(oSection,"06",,"Total NF"                     ,PesqPict("SD1","D1_TOTAL")  ,TamSX3("D1_TOTAL")  [1]+4)

//Segunda seção
oSection1 := TRSection():New(oReport,"TOTAL",{"TRB"})

TRCell():New(oSection1,"TOTAL1","TRB","Qtde. Registros"    ,PesqPict("SD1","D1_DOC")    ,TamSX3("D1_DOC")    [1]+4)
TRCell():New(oSection1,"TOTAL2","TRB","Valor Total "       ,PesqPict("SD1","D1_TOTAL")  ,TamSX3("D1_TOTAL")  [1]+4)

oSection:SetHeaderSection(.T.)
oSection1:SetHeaderSection(.T.)	

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Itens do Relatório           	                           º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(2)
Local oSection
Local oSection1
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local nTotal 	:= 0
Local nTotal2	:= 0

oSection:Cell("01") :SetBlock( { || aDados1[01] } )
oSection:Cell("02") :SetBlock( { || aDados1[02] } )
oSection:Cell("03") :SetBlock( { || aDados1[03] } )
oSection:Cell("04") :SetBlock( { || aDados1[04] } )
oSection:Cell("05") :SetBlock( { || aDados1[05] } )
oSection:Cell("06") :SetBlock( { || aDados1[06] } )

oSection1:Cell("TOTAL1"):SetBlock( { || nTotal } )
oSection1:Cell("TOTAL2"):SetBlock( { || nTotal2} )

oReport:SetTitle("RELATÓRIO DE ITENS DE NOTA FISCAL DE ENTRADA PARA O CENTRO DE CUSTO 112104")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()
oSection1:Init()


Processa({|| StQuery(  ) },"Compondo Relatório")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:= (cAliasLif)->EMPRESA
		aDados1[02]	:= (cAliasLif)->NOME
		aDados1[03]	:= (cAliasLif)->DESCRICAO
		aDados1[04]	:= (cAliasLif)->NF
		aDados1[05]	:= DTOC(STOD((cAliasLif)->ENTRADA))
		aDados1[06]	:= (cAliasLif)->TOTAL_NF
		nTotal	 ++
		nTotal2 += (cAliasLif)->TOTAL_NF
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |StQuery   ºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Query do Relatório				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '

cQuery := " SELECT 
cQuery += " 'SP' AS EMPRESA,  
cQuery += " SA2.A2_NOME AS NOME,
cQuery += " SB1.B1_DESC AS DESCRICAO,
cQuery += " D1_DOC AS NF,
cQuery += " D1_DTDIGIT AS ENTRADA,
If Mv_Par03 = 1
	cQuery += " D1_TOTAL AS TOTAL_NF
ElseIf Mv_Par03 = 2
	cQuery += " SUM(D1_TOTAL) AS TOTAL_NF
Endif

cQuery += " FROM SD1010 SD1

cQuery += " INNER JOIN(SELECT * FROM SA2010 )  SA2
cQuery += " ON SA2.D_E_L_E_T_ = ' ' 
cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE 
cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA 
cQuery += " AND SA2.A2_FILIAL = '  ' 

cQuery += " INNER JOIN(SELECT * FROM SB1010 )  SB1 
cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
cQuery += " AND SD1.D1_COD = SB1.B1_COD

cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' 
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' 
cQuery += " AND SD1.D1_CC = '112104'
cQuery += " AND SD1.D1_TIPO = 'N'

If Mv_Par03 = 2
	cQuery += " GROUP BY SA2.A2_NOME,D1_DOC,D1_DTDIGIT, SB1.B1_DESC
Endif

cQuery += " UNION

cQuery += " SELECT 
cQuery += " 'AM' AS EMPRESA,  
cQuery += " SA2.A2_NOME AS NOME,
cQuery += " SB1.B1_DESC AS DESCRICAO,
cQuery += " D1_DOC AS NF,
cQuery += " D1_DTDIGIT AS ENTRADA,
If Mv_Par03 = 1
	cQuery += " D1_TOTAL AS TOTAL_NF
ElseIf Mv_Par03 = 2
	cQuery += " SUM(D1_TOTAL) AS TOTAL_NF
Endif
cQuery += " FROM SD1030 SD1

cQuery += " INNER JOIN(SELECT * FROM SA2030 )  SA2
cQuery += " ON SA2.D_E_L_E_T_ = ' ' 
cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE 
cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA 
cQuery += " AND SA2.A2_FILIAL = '  ' 

cQuery += " INNER JOIN(SELECT * FROM SB1030 )  SB1 
cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
cQuery += " AND SD1.D1_COD = SB1.B1_COD

cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' 
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' 
cQuery += " AND SD1.D1_CC = '112104'
cQuery += " AND SD1.D1_TIPO = 'N'

If Mv_Par03 = 2
	cQuery += " GROUP BY SA2.A2_NOME,D1_DOC,D1_DTDIGIT, SB1.B1_DESC
Endif

If Mv_Par04 = 1
	cQuery += " ORDER BY EMPRESA DESC, NOME
Elseif Mv_Par04 = 2
	cQuery += " ORDER BY NF, NOME
Elseif Mv_Par04 = 3
	cQuery += " ORDER BY ENTRADA, NOME
Elseif Mv_Par04 = 4
	cQuery += " ORDER BY DESCRICAO, NOME
Endif
	
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
