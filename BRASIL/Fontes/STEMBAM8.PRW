#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |STEMBAM8  บAutor  ณJoใo Victor         บ Data ณ  12/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rela็ใo de  Embarque								      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function STEMBAM8()
	*-----------------------------*
	Local   oReport
	Private cPerg 		:= PADR("STEMBAM8" , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	//Private lXlsHeader   := .f.
	//Private lXmlEndRow   := .f.
	Private cPergTit 		:= cAliasLif
//	Private cAlias1      := GetNextAlias()
	Private cAlias2      := GetNextAlias()

	PutSx1(cPerg   ,"01"   ,"Do Embarque :?"           ,"Do Embarque :?"             ,"Do Embarque :?"               ,"mv_ch1"    ,"C"   ,06      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,"   "                ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"   ,"At้ Embarque :?"          ,"At้ Embarque :?"            ,"At้ Embarque :?"              ,"mv_ch2"    ,"C"   ,06      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,"ZZZ"                ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

	Begin Transaction

		PUTMV("MV_IMPSX1","N")

		oReport           := ReportDef()
		oReport:PrintDialog()

		PUTMV("MV_IMPSX1","S")

	End Transaction

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
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
	Local oSection1

	oReport := TReport():New(cPergTit,"Rela็ใo de  Embarque: ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir as informa็๕es do embarque posicionado.")
	oReport:SetPortrait()
	oReport:nFontBody := 6

	Pergunte(cPerg,.T.)

	oSection1 := TRSection():New(oReport,"Itens",{cAlias2})

	TRCell():New(oSection1,"A4" ,,"Embaque"        		,PesqPict("ZZT","ZZT_NUMEMB")    ,TamSX3("ZZT_NUMEMB")   [1]+8)
	TRCell():New(oSection1,"B1" ,,"Produto"            ,PesqPict("ZZU","ZZU_PRODUT")     ,TamSX3("ZZU_PRODUT") [1]+8)
	TRCell():New(oSection1,"B2" ,,"Qtde. Total"        ,PesqPict("ZZU","ZZU_QTDE")       ,TamSX3("ZZU_QTDE")   [1]+8)
	TRCell():New(oSection1,"B3" ,,"Qtde Volumes"       ,PesqPict("ZZU","ZZU_QTDE")       ,TamSX3("ZZU_QTDE")   [1]+8)
	TRCell():New(oSection1,"A5" ,,"Nota Fiscal"    ,PesqPict("ZZT","ZZT_NF")          ,TamSX3("ZZT_NF")       [1]+8)
	TRCell():New(oSection1,"A2" ,,"Destino"        		,PesqPict("ZZT","ZZT_FILDES")    ,TamSX3("ZZT_FILDES")   [1]+8)

	TRCell():New(oSection1,"A6" ,,"S้rie NF"       ,PesqPict("ZZT","ZZT_SERIEN")      ,TamSX3("ZZT_SERIEN")   [1]+8)
	TRCell():New(oSection1,"A7" ,,"C๓digo"         ,PesqPict("SA1","A1_COD")          ,TamSX3("A1_COD")       [1]+8)
	TRCell():New(oSection1,"A8" ,,"Lj"             ,PesqPict("SA1","A1_LOJA")         ,TamSX3("A1_LOJA")      [1]+8)
	TRCell():New(oSection1,"A9" ,,"Razใo Social"   ,PesqPict("SA1","A1_NOME")         ,TamSX3("A1_NOME")      [1]+8)
	TRCell():New(oSection1,"A10",,"CNPJ"           ,PesqPict("SA1","A1_CGC")          ,TamSX3("A1_CGC")       [1]+8)
	TRCell():New(oSection1,"B31" ,,"Qtde. Aglut."      ,PesqPict("ZZU","ZZU_QTDE")       ,TamSX3("ZZU_QTDE")   [1]+8)
	TRCell():New(oSection1,"B4" ,,"Qtde Faturada"      ,PesqPict("ZZU","ZZU_QTDE")       ,TamSX3("ZZU_QTDE")   [1]+8)
	TRCell():New(oSection1,"B5" ,,"Status"             ,PesqPict("ZZU","ZZU_PRODUT")     ,TamSX3("ZZU_PRODUT") [1]+8)
	TRCell():New(oSection1,"A1" ,,"Dt. Emissใo"    		,PesqPict("ZZT","ZZT_DTEMIS")    ,TamSX3("ZZT_DTEMIS")   [1]+8)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias2)
	oSection1:SetTotalInLine(.F.)
	/*
	oBreak2 := TRBreak():New(oSection2,{|| (cAlias2)->(A4_EMBARQUE) },{|| "Total do Embarque: " },.F.)
	TRFunction():New(oSection2:Cell("B2")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B3")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B4")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	*/

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrintบAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Itens do Relat๓rio                                         บฑฑ
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
	Local oSection1	:= oReport:Section(1)
//	Local nX		:= 0
//	Local cQuery 	:= ""
//	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell("A1") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("A2") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("A4") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("A5") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("A6") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("A7") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("A8") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("A9") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("A10"):SetBlock( { || aDados1[10] } )
	oSection1:Cell("B1") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("B2") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("B3") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("B4") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("B5") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("B31") :SetBlock( { || aDados1[16] } )

	oReport:SetTitle("Rela็ใo de  Embarque: -> Embarque De: "+(MV_PAR01)+" Embarque At้: "+(MV_PAR02))// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)

	Processa({|| StQuery(  ) },"Compondo Relat๓rio")

	oSection1:Init()

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0

		While 	(cAlias2)->(!Eof())

			aDados1[01]	:= DTOC(STOD((cAlias2)->A1_DT_EMISSAO))
			aDados1[02]	:= (cAlias2)->A2_DESTINO
			aDados1[04]	:= (cAlias2)->A4_EMBARQUE
			aDados1[05]	:= (cAlias2)->A5_NF
			aDados1[06]	:= (cAlias2)->A6_SERIE
			aDados1[07]	:= (cAlias2)->A7_COD
			aDados1[08]	:= (cAlias2)->A8_LOJA
			aDados1[09]	:= (cAlias2)->A9_NOME
			aDados1[10]	:= (cAlias2)->A10_CNPJ
			aDados1[11]	:= (cAlias2)->B1_PRODUTO
			aDados1[12]	:= Iif((cAlias2)->AGLU <> 'N',(cAlias2)->B2_QUANTIDADE,0)
			aDados1[13]	:= (cAlias2)->B3_VOLUME
			aDados1[16]	:= Iif((cAlias2)->AGLU = 'S',(cAlias2)->B2_QUANTIDADE,0)
			aDados1[14]	:= (cAlias2)->B4_QTD_FAT
			aDados1[15]	:= (cAlias2)->B5_STATUS

			oSection1:PrintLine()

			aFill(aDados1,nil)
			(cAlias2)->(dbskip())

		End
		oSection1:PrintTotal()
		oSection1:Finish()
		oReport:SkipLine()

		aFill(aDados1,nil)

		(cAlias2)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |StQuery  บAutor  ณJoใo Victor         บ Data ณ  12/03/15   บฑฑ
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

	Local cQuery2     := ' '

	cQuery2 := " SELECT

	cQuery2 += " ZZU_VIRTUA AS AGLU,
	cQuery2 += " ZZT_DTEMIS AS A1_DT_EMISSAO,
	cQuery2 += " CASE WHEN  ZZT_FILDES = '01' THEN 'FมBRICA'   ELSE
	cQuery2 += " CASE WHEN  ZZT_FILDES = '02' THEN 'CD SP'     ELSE
	cQuery2 += " CASE WHEN  ZZT_FILDES = '09' THEN 'CAJAMAR'   ELSE
	cQuery2 += " CASE WHEN  ZZT_FILDES = '10' THEN 'GUARAREMA' ELSE
	cQuery2 += " 'SEM DESTINO' END END END END AS A2_DESTINO,
	cQuery2 += " CASE WHEN  ZZT_STATUS = '1' THEN 'ABERTO'     ELSE
	cQuery2 += " CASE WHEN  ZZT_STATUS = '2' THEN 'FECHADO'    ELSE
	cQuery2 += " CASE WHEN  ZZT_STATUS = '3' THEN 'FINALIZADO' ELSE
	cQuery2 += " 'SEM STATUS' END END END AS A3_STATUS,
	cQuery2 += " ZZT_NUMEMB AS A4_EMBARQUE,
	cQuery2 += " ZZT_NF     AS A5_NF,
	cQuery2 += " ZZT_SERIEN AS A6_SERIE,
	cQuery2 += " A1_COD     AS A7_COD,
	cQuery2 += " A1_LOJA    AS A8_LOJA,
	cQuery2 += " A1_NOME    AS A9_NOME,
	cQuery2 += " A1_CGC     AS A10_CNPJ,
	cQuery2 += " ZZU_PRODUT AS B1_PRODUTO,
	cQuery2 += " SUM(ZZU_QTDE)   AS B2_QUANTIDADE,
	cQuery2 += " CASE WHEN ZZU_VIRTUA = 'S' THEN 0 ELSE COUNT(ZZU_VOLUME) END AS B3_VOLUME,
	cQuery2 += " NVL((SELECT SUM(A1.C9_QTDLIB)
	cQuery2 += " FROM "+RetSqlName("SC9")+" A1 "
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1.C9_NUMEMB  = ZZT.ZZT_NUMEMB
	cQuery2 += " AND A1.C9_PRODUTO = ZZU.ZZU_PRODUT
	cQuery2 += " AND A1.C9_NFISCAL = ZZT.ZZT_NF
	cQuery2 += " AND A1.C9_SERIENF = ZZT.ZZT_SERIEN
	cQuery2 += " ),0)  AS B4_QTD_FAT,
	cQuery2 += " CASE WHEN  NVL((SELECT SUM(A1.C9_QTDLIB)
	cQuery2 += " FROM "+RetSqlName("SC9")+" A1 "
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1.C9_NUMEMB  = ZZT.ZZT_NUMEMB
	cQuery2 += " AND A1.C9_PRODUTO = ZZU.ZZU_PRODUT
	cQuery2 += " AND A1.C9_NFISCAL = ZZT.ZZT_NF
	cQuery2 += " AND A1.C9_SERIENF = ZZT.ZZT_SERIEN
	cQuery2 += " ),0) = 0 AND ZZU_VIRTUA <> 'N' THEN 'NรO FATURADO'     ELSE
	cQuery2 += " CASE WHEN  NVL((SELECT SUM(A1.C9_QTDLIB)
	cQuery2 += " FROM "+RetSqlName("SC9")+" A1 "
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1.C9_NUMEMB  = ZZT.ZZT_NUMEMB
	cQuery2 += " AND A1.C9_PRODUTO = ZZU.ZZU_PRODUT
	cQuery2 += " AND A1.C9_NFISCAL = ZZT.ZZT_NF
	cQuery2 += " AND A1.C9_SERIENF = ZZT.ZZT_SERIEN
	cQuery2 += " ),0) = SUM(ZZU_QTDE) AND ZZU_VIRTUA <> 'N' THEN 'FATURAMENTO OK'    ELSE
	cQuery2 += " CASE WHEN  NVL((SELECT SUM(A1.C9_QTDLIB)
	cQuery2 += " FROM "+RetSqlName("SC9")+" A1 "
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1.C9_NUMEMB  = ZZT.ZZT_NUMEMB
	cQuery2 += " AND A1.C9_PRODUTO = ZZU.ZZU_PRODUT
	cQuery2 += " AND A1.C9_NFISCAL = ZZT.ZZT_NF
	cQuery2 += " AND A1.C9_SERIENF = ZZT.ZZT_SERIEN
	cQuery2 += " ),0) > SUM(ZZU_QTDE) AND ZZU_VIRTUA <> 'N'  THEN 'FATURAMENTO MAIOR' ELSE
	cQuery2 += " CASE WHEN  NVL((SELECT SUM(A1.C9_QTDLIB)
	cQuery2 += " FROM "+RetSqlName("SC9")+" A1 "
	cQuery2 += " WHERE A1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1.C9_NUMEMB  = ZZT.ZZT_NUMEMB
	cQuery2 += " AND A1.C9_PRODUTO = ZZU.ZZU_PRODUT
	cQuery2 += " AND A1.C9_NFISCAL = ZZT.ZZT_NF
	cQuery2 += " AND A1.C9_SERIENF = ZZT.ZZT_SERIEN
	cQuery2 += " ),0) < SUM(ZZU_QTDE) AND ZZU_VIRTUA <> 'N' THEN 'FATURAMENTO PARCIAL' ELSE
	cQuery2 += " 'SEM STATUS' END END END END AS B5_STATUS
	cQuery2 += " FROM "+RetSqlName("ZZT")+" ZZT "
	cQuery2 += " INNER JOIN "+RetSqlName("ZZU")+" ZZU "
	cQuery2 += " ON ZZU.D_E_L_E_T_ = ' '
	cQuery2 += " AND ZZT_NUMEMB = ZZU_NUMEMB
	cQuery2 += " AND ZZT_FILIAL = ZZU_FILIAL
	cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery2 += " ON SB1.D_E_L_E_T_ = ' '
	cQuery2 += " AND B1_COD = ZZU_PRODUT
	cQuery2 += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery2 += " ON SA1.D_E_L_E_T_ = ' '
	cQuery2 += " AND A1_COD  = ZZT_CLIENT
	cQuery2 += " AND A1_LOJA = ZZT_FILDES
	cQuery2 += " WHERE ZZT.D_E_L_E_T_ = ' '
	cQuery2 += " AND ZZT_NUMEMB BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery2 += " GROUP BY ZZT_DTEMIS, ZZT_FILDES, ZZT_STATUS, ZZT_NUMEMB, ZZU_PRODUT, ZZT_NF, ZZT_SERIEN, A1_COD, A1_LOJA, A1_NOME ,A1_CGC,ZZU_VIRTUA
	cQuery2 += " ORDER BY ZZT_NUMEMB, ZZU_PRODUT

	cQuery2 := ChangeQuery(cQuery2)

	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)

Return()