#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RSTFAT72  ºAutor  ³João Victor         º Data ³  13/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de pedidos de venda em aberto por Grupo de      º±±
±±º          ³  Produto                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT72()
*-----------------------------*
Local   oReport
Private cPerg 		:= "RFAT72"
Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
Private cTime        := Time()
Private cHora        := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private lXlsHeader   := .f.
Private lXmlEndRow   := .f.
Private cPergTit 		:= cAliasLif

//-------cGrupo,cOrdem ,cPergunt          ,cPergSpa         ,cPergEng           ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	 ,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
PutSx1(cPerg   ,"01"   ,"Filial De :?"    ,"Filial De: ?"   ,"Filial De: ?"     ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,"  "                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"02"   ,"Filial Até :?"   ,"Filial Até: ?"  ,"Filial Até: ?"    ,"mv_ch2"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,"ZZ"                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"03"   ,"Grupo De :?"     ,"Grupo De: ?"    ,"Grupo De: ?"      ,"mv_ch3"    ,"C"   ,03      , 0      , 0     ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,"  "                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"04"   ,"Grupo Até :?"    ,"Grupo Até: ?"   ,"Grupo Até: ?"     ,"mv_ch4"    ,"C"   ,03      , 0      , 0     ,"G" ,""    ,"SBM" ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,"ZZ"                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"05"   ,"Emissão De: ?"   ,"Emissão De: ?"  ,"Emissão De: ?"	   ,"mv_ch5"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par05"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"06"   ,"Emissão Até: ?"  ,"Emissão Até: ?" ,"Emissão Até: ?"   ,"mv_ch6"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par06"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
PutSx1(cPerg   ,"07"   ,"Ordenação: ?"    ,"Ordenação: ?"   ,"Ordenação: ?"     ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,''    ,""     ,""   ,"mv_par07"    ,"1-Filial"        ,""      ,""      ,""                   ,"2-Pedido de Venda",""        ,""      ,"3-Dt. Emissão",""      ,""      ,"4-Grupo de Produto"  ,""      ,""      ,""    ,""      ,"")

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

oReport := TReport():New(cPergTit,"RELATÓRIO DE PEDIDOS DE VENDA EM ABERTO POR GRUPO DE PRODUTO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir os pedidos de venda em aberto por grupo de produto")

Pergunte(cPerg,.F.)

/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
dbSelectArea("SX1")
dbSetorder(1)//X1_GRUPO+X1_ORDEM
If SX1->(dbSeek(cPerg1+'05'))
	RecLock("SX1",.F.)
		SX1->X1_CNT01:= Dtoc(dDatabase-30)
	SX1->(MsUnlock())
Endif

If SX1->(dbSeek(cPerg1+'06'))
	RecLock("SX1",.F.)
		SX1->X1_CNT01:= Dtoc(dDatabase)
	SX1->(MsUnlock())
Endif*/

//Primeira Seção
oSection := TRSection():New(oReport,"Itens",{"SC5","SC6","SA1","SBM"})

TRCell():New(oSection,"01",,"Filial"		                 ,PesqPict("SC6","C6_FILIAL")  ,TamSX3("C6_FILIAL") [1]+6)
TRCell():New(oSection,"02",,"Pedido de Venda"              ,PesqPict("SC6","C6_NUM")     ,TamSX3("C6_NUM")    [1]+14)
TRCell():New(oSection,"03",,"Dt. Emissão"                  ,PesqPict("SC5","C5_EMISSAO") ,TamSX3("C5_EMISSAO")[1]+6)
TRCell():New(oSection,"04",,"Razão Social"                 ,PesqPict("SA1","A1_NOME")    ,TamSX3("A1_NOME")   [1]+6)
TRCell():New(oSection,"05",,"Grupo de Vendas"              ,PesqPict("SA1","A1_GRPVEN")  ,TamSX3("A1_GRPVEN") [1]+14)
TRCell():New(oSection,"06",,"Grupo de Produto"             ,PesqPict("SBM","BM_GRUPO")   ,TamSX3("BM_GRUPO")  [1]+18)
TRCell():New(oSection,"07",,"Descrição do Grupo"           ,PesqPict("SBM","BM_DESC")    ,TamSX3("BM_DESC")   [1]+6)
TRCell():New(oSection,"08",,"Valor Líquido"                ,PesqPict("SC6","C6_VALOR")   ,TamSX3("C6_VALOR")  [1]+6)
TRCell():New(oSection,"09",,"Vendedor 1"                	,PesqPict("SC5","C5_VEND1")   ,TamSX3("C5_VEND1")  [1]+6)
TRCell():New(oSection,"10",,"Vendedor 2"                	,PesqPict("SC5","C5_VEND2")   ,TamSX3("C5_VEND2")  [1]+6)
TRCell():New(oSection,"11",,"Mes De"                			,PesqPict("SC5","C5_XMDE")    ,TamSX3("C5_XMDE")  [1]+6)
TRCell():New(oSection,"12",,"Ano De"                			,PesqPict("SC5","C5_XDANO")   ,TamSX3("C5_XDANO")  [1]+6)
TRCell():New(oSection,"13",,"Mes Ate"                		,PesqPict("SC5","C5_XMATE")   ,TamSX3("C5_XMATE")  [1]+6)
TRCell():New(oSection,"14",,"Ano Ate"                		,PesqPict("SC5","C5_XAANO")   ,TamSX3("C5_XAANO")  [1]+6)
//Segunda seção
oSection1 := TRSection():New(oReport,"TOTAL",{"TRB"})

TRCell():New(oSection1,"TOTAL1","TRB","Qtde. Registros"    ,PesqPict("SC6","C6_NUM")     ,TamSX3("C6_NUM")    [1]+6)
TRCell():New(oSection1,"TOTAL2","TRB","Total Valor Líquido",PesqPict("SC6","C6_VALOR")   ,TamSX3("C6_VALOR")  [1]+6)

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
oSection:Cell("07") :SetBlock( { || aDados1[07] } )
oSection:Cell("08") :SetBlock( { || aDados1[08] } )
oSection:Cell("09") :SetBlock( { || aDados1[09] } )
oSection:Cell("10") :SetBlock( { || aDados1[10] } )
oSection:Cell("11") :SetBlock( { || aDados1[11] } )
oSection:Cell("12") :SetBlock( { || aDados1[12] } )
oSection:Cell("13") :SetBlock( { || aDados1[13] } )
oSection:Cell("14") :SetBlock( { || aDados1[14] } )

oSection1:Cell("TOTAL1"):SetBlock( { || nTotal } )
oSection1:Cell("TOTAL2"):SetBlock( { || nTotal2} )

oReport:SetTitle("RELATÓRIO DE PEDIDOS DE VENDA EM ABERTO POR GRUPO DE PRODUTO")// Titulo do relatório

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

		aDados1[01]	:= (cAliasLif)->FILIAL
		aDados1[02]	:= (cAliasLif)->NUMERO
		aDados1[03]	:= DTOC(STOD((cAliasLif)->EMISSAO))
		aDados1[04]	:= (cAliasLif)->NOME
		aDados1[05]	:= (cAliasLif)->GRUPOCLI
		aDados1[06]	:= (cAliasLif)->GRPROD
		aDados1[07]	:= (cAliasLif)->DESC_GRPROD
		aDados1[08]	:= (cAliasLif)->VALOR_LIQUIDO
		aDados1[09]	:= (cAliasLif)->VEND1
		aDados1[10]	:= (cAliasLif)->VEND2
		aDados1[11]	:= (cAliasLif)->MDE
		aDados1[12]	:= (cAliasLif)->ADE
		aDados1[13]	:= (cAliasLif)->MATE
		aDados1[14]	:= (cAliasLif)->AATE

		nTotal	 ++
		nTotal2 += (cAliasLif)->VALOR_LIQUIDO
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
cQuery += " SC6.C6_FILIAL AS FILIAL,
cQuery += " SC6.C6_NUM AS NUMERO,
cQuery += " SC5.C5_EMISSAO AS EMISSAO,
cQuery += " SC5.C5_VEND1 AS VEND1,
cQuery += " SC5.C5_VEND2 AS VEND2,
cQuery += " SC5.C5_XMDE AS MDE,
cQuery += " SC5.C5_XDANO AS ADE,
cQuery += " SC5.C5_XMATE AS MATE,
cQuery += " SC5.C5_XAANO AS AATE,
cQuery += " SA1.A1_NOME AS NOME,
cQuery += " SA1.A1_GRPVEN AS GRUPOCLI,
cQuery += " SBM.BM_GRUPO AS GRPROD,
cQuery += " SBM.BM_DESC AS DESC_GRPROD,
cQuery += " SUM(ROUND((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT),2))AS VALOR_LIQUIDO

cQuery += " FROM "+RetSqlName("SC6")+" SC6 "

cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+") SB1 "
cQuery += " ON SB1.D_E_L_E_T_   = ' '
cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
cQuery += " AND SB1.B1_FILIAL = ' '

cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+") SBM "
cQuery += " ON SBM.D_E_L_E_T_   = ' '
cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
cQuery += " AND SBM.BM_FILIAL = ' '

cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+") SC5 "
cQuery += " ON  SC5.D_E_L_E_T_   = ' '
cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
cQuery += " ON SA1.D_E_L_E_T_   = ' '
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
cQuery += " AND SA1.A1_FILIAL = ' '

cQuery += " LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+") PC1 "
cQuery += " ON C6_NUM = PC1.PC1_PEDREP
cQuery += " AND PC1.D_E_L_E_T_ = ' '

cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+") SF4 "
cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
cQuery += " AND SF4.D_E_L_E_T_ = ' '
cQuery += " AND SF4.F4_DUPLIC = 'S'

cQuery += " WHERE SC6.D_E_L_E_T_   = ' '
cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
cQuery += " AND SC5.C5_TIPO = 'N'
cQuery += " AND SA1.A1_GRPVEN <> 'ST'
cQuery += " AND SA1.A1_EST    <> 'EX'
cQuery += " AND SBM.BM_XAGRUP <> ' '
cQuery += " AND PC1.PC1_PEDREP IS NULL
cQuery += " AND SC6.C6_BLQ <> 'R'
cQuery += " AND SC6.C6_FILIAL  BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
cQuery += " AND SB1.B1_GRUPO   BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"'
cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'

cQuery += " GROUP BY SC6.C6_FILIAL,SC6.C6_NUM, SC5.C5_EMISSAO, SA1.A1_NOME,SA1.A1_GRPVEN, SBM.BM_GRUPO, SBM.BM_DESC,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_XMDE,SC5.C5_XDANO,SC5.C5_XMATE,SC5.C5_XAANO

If Mv_Par07 = 1
	cQuery += " ORDER BY C6_FILIAL, C6_NUM
Elseif Mv_Par07 = 2
	cQuery += " ORDER BY C6_NUM, C6_FILIAL
Elseif Mv_Par07 = 3
	cQuery += " ORDER BY C5_EMISSAO, C6_FILIAL
Elseif Mv_Par07 = 4
	cQuery += " ORDER BY BM_GRUPO
Endif


cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
