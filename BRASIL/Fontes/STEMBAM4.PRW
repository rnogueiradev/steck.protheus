#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |STEMBAM4  ºAutor  ³João Victor         º Data ³  12/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório Relatório de Conferência de Embarque - pallet   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*l
User Function STEMBAM4()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "STEMBAM4"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private lXlsHeader   := .f.
	Private lXmlEndRow   := .f.
	Private cPergTit 		:= cAliasLif
	Private cAlias1      := GetNextAlias()
	Private cAlias2      := GetNextAlias()
	Private _cEmbarque   := ZZT->ZZT_NUMEMB

//-------cGrupo    ,cOrdem,cPergunt                 ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
//PutSx1(cPerg     ,"01"  ,"Filial ?"               ,"Filial ?"                 ,"Filial ?"                   ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"   ,"Pallet De :?"           ,"Pallet De: ?"             ,"Pallet De: ?"               ,"mv_ch1"    ,"C"   ,03      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,"   "                ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"   ,"Pallet Até :?"          ,"Pallet Até: ?"            ,"Pallet Até: ?"              ,"mv_ch2"    ,"C"   ,03      , 0      , 0     ,"G" ,""    ,""    ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,"ZZZ"                ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	
//	oReport		:= ReportDef()
//	oReport:PrintDialog()

Begin Transaction

PUTMV("MV_IMPSX1","N")

oReport           := ReportDef()
oReport:PrintDialog()

PUTMV("MV_IMPSX1","S")

End Transaction


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
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Conferência de Embarque: "+_cEmbarque,cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir as informações do embarque posicionado.")
	//oReport:SetLandscape()
	oReport:SetPortrait()
	oReport:nFontBody := 6

	Pergunte(cPerg,.T.)


//Primeira Seção
	oSection1 := TRSection():New(oReport,"Cabeçalho",{cAlias1})
	TRCell():New(oSection1,"A1" ,,"Dt. Emissão"    ,PesqPict("ZZT","ZZT_DTEMIS")      ,TamSX3("ZZT_DTEMIS")   [1]+8)
	TRCell():New(oSection1,"A2" ,,"Destino"        ,PesqPict("ZZT","ZZT_FILDES")      ,TamSX3("ZZT_FILDES")   [1]+8)
	TRCell():New(oSection1,"A3" ,,"Status"         ,PesqPict("ZZT","ZZT_STATUS")      ,TamSX3("ZZT_NUMEMB")   [1]+8)
	TRCell():New(oSection1,"A4" ,,"Embaque"        ,PesqPict("ZZT","ZZT_NUMEMB")      ,TamSX3("ZZT_NUMEMB")   [1]+8)
	TRCell():New(oSection1,"A5" ,,"Nota Fiscal"    ,PesqPict("ZZT","ZZT_NF")          ,TamSX3("ZZT_NF")       [1]+8)
	TRCell():New(oSection1,"A6" ,,"Série NF"       ,PesqPict("ZZT","ZZT_SERIEN")      ,TamSX3("ZZT_SERIEN")   [1]+8)
	TRCell():New(oSection1,"A7" ,,"Código"         ,PesqPict("SA1","A1_COD")          ,TamSX3("A1_COD")       [1]+8)
	TRCell():New(oSection1,"A8" ,,"Lj"             ,PesqPict("SA1","A1_LOJA")         ,TamSX3("A1_LOJA")      [1]+8)
	TRCell():New(oSection1,"A9" ,,"Razão Social"   ,PesqPict("SA1","A1_NOME")         ,TamSX3("A1_NOME")      [1]+8)
	TRCell():New(oSection1,"A10",,"CNPJ"           ,PesqPict("SA1","A1_CGC")          ,TamSX3("A1_CGC")       [1]+8)
	
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter(cAlias1)
	oSection1:SetTotalInLine(.F.)

//	oBreak1 := TRBreak():New(oSection1,{|| (cAlias1)->(A4_EMBARQUE) },{|| "Total por Comprador: " },.F.)


//Segunda Seção
	oSection2 := TRSection():New(oReport,"Itens",{cAlias2})
	TRCell():New(oSection2,"B1" ,,"Pallet"             ,PesqPict("ZZU","ZZU_PALLET")     ,TamSX3("ZZU_PALLET")   [1]+8)
	TRCell():New(oSection2,"B2" ,,"Volume"             ,PesqPict("ZZU","ZZU_VOLUME")     ,TamSX3("ZZU_VOLUME")   [1]+8)
	TRCell():New(oSection2,"B10" ,,"Vol. Aglut."        ,PesqPict("ZZU","ZZU_CHVVIR")     ,TamSX3("ZZU_CHVVIR")   [1]+8)
	TRCell():New(oSection2,"B3" ,,"Produto"            ,PesqPict("ZZU","ZZU_PRODUT")     ,TamSX3("ZZU_PRODUT")   [1]+8)
	TRCell():New(oSection2,"B4" ,,"Quantidade Volume"  ,PesqPict("SC6","C6_QTDVEN")       ,TamSX3("C6_QTDVEN")   [1]+8)
	TRCell():New(oSection2,"B5" ,,"Ordem Produção"     ,PesqPict("ZZU","ZZU_OP")         ,TamSX3("ZZU_OP")       [1]+8)
	TRCell():New(oSection2,"B6" ,,"Peso Liquido Volume",PesqPict("SC6","C6_QTDVEN")       ,TamSX3("C6_QTDVEN")   [1]+8)
	TRCell():New(oSection2,"B7" ,,"Dt. Inclusão"       ,PesqPict("ZZU","ZZU_DTEMIS")     ,TamSX3("ZZU_DTEMIS")   [1]+8)
	TRCell():New(oSection2,"B8" ,,"Hora Inclusão"      ,PesqPict("ZZU","ZZU_HRINI")      ,TamSX3("ZZU_HRINI")    [1]+8)
	TRCell():New(oSection2,"B9" ,,"Usuário Inclusão"   ,PesqPict("ZZU","ZZU_USERIN")     ,TamSX3("ZZU_PRODUT")   [1]+8)
 	TRCell():New(oSection2,"B11",,"Classif.FRM"        ,PesqPict("SB1","B1_XFMR")        ,TamSX3("B1_XFMR") [1]+8)

	oSection2:SetHeaderSection(.T.)
	oSection2:Setnofilter(cAlias2)
	oSection2:SetTotalInLine(.F.)

	oBreak2 := TRBreak():New(oSection2,{|| (cAlias2)->(B1_PALLET) },{|| "Total por Pallet: " },.F.)
	TRFunction():New(oSection2:Cell("B4")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("B6")    ,"","SUM"  ,oBreak2,,,,.F.,.F.)


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³João Victor         º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Itens do Relatório                                         º±±
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
	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("A1") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("A2") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("A3") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("A4") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("A5") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("A6") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("A7") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("A8") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("A9") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("A10"):SetBlock( { || aDados1[10] } )


	oSection2:Cell("B1") :SetBlock( { || aDados1[11] } )
	oSection2:Cell("B2") :SetBlock( { || aDados1[12] } )
	oSection2:Cell("B3") :SetBlock( { || aDados1[13] } )
	oSection2:Cell("B4") :SetBlock( { || aDados1[14] } )
	oSection2:Cell("B5") :SetBlock( { || aDados1[15] } )
	oSection2:Cell("B6") :SetBlock( { || aDados1[16] } )
	oSection2:Cell("B7") :SetBlock( { || aDados1[17] } )
	oSection2:Cell("B8") :SetBlock( { || aDados1[18] } )
	oSection2:Cell("B9") :SetBlock( { || aDados1[19] } )
	oSection2:Cell("B10") :SetBlock( { || aDados1[20] } )
	oSection2:Cell("B11") :SetBlock( { || aDados1[21] } )					  // Valdemir Rabelo 23/12/2020 - Ticket: 20201221012637
	
	oReport:SetTitle("Conferência de Embarque: "+_cEmbarque+" -> Pallet De: "+(MV_PAR01)+" Pallet Até: "+(MV_PAR02))// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	//oSection1:Init()

	Processa({|| StQuery(  ) },"Compondo Relatório")

	oSection1:Init()

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
	
		While 	(cAlias1)->(!Eof())
		
			aDados1[01]	:= DTOC(STOD((cAlias1)->A1_DT_EMISSAO))
			aDados1[02]	:= (cAlias1)->A2_DESTINO
			aDados1[03]	:= (cAlias1)->A3_STATUS
			aDados1[04]	:= (cAlias1)->A4_EMBARQUE
			aDados1[05]	:= (cAlias1)->A5_NF
			aDados1[06]	:= (cAlias1)->A6_SERIE
			aDados1[07]	:= (cAlias1)->A7_COD
			aDados1[08]	:= (cAlias1)->A8_LOJA
			aDados1[09]	:= (cAlias1)->A9_NOME
			aDados1[10]	:= (cAlias1)->A10_CNPJ

			oSection1:PrintLine()
		
			aFill(aDados1,nil)
			(cAlias1)->(dbskip())
		End
		oSection1:PrintTotal()
		oSection1:Finish()
		oReport:SkipLine()
	
		aFill(aDados1,nil)
	
		(cAlias1)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


	oSection2:Init()

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0
	
		While 	(cAlias2)->(!Eof())
		
			aDados1[11]	:= (cAlias2)->B1_PALLET
			aDados1[12]	:= (cAlias2)->B2_VOLUME
			aDados1[20]	:= SubsTring((cAlias2)->VOL_AGLUT,14,3)
			aDados1[13]	:= (cAlias2)->B3_PRODUTO
			aDados1[14]	:= (cAlias2)->B4_QUANTIDADE
			aDados1[15]	:= (cAlias2)->B5_ORDEM_PRODUCAO
			aDados1[16]	:= (cAlias2)->B6_PESO_LIQUIDO
			aDados1[17]	:= DTOC(STOD((cAlias2)->B7_DT_INCUSAO))
			aDados1[18]	:= (cAlias2)->B8_HR_INCLUSAO 
			aDados1[19]	:= (cAlias2)->B9_USUARIO_INCLUSAO
			aDados1[21]	:= POSICIONE("SB1",1,XFILIAL('SB1')+(cAlias2)->B3_PRODUTO,"B1_XFMR")     // Valdemir Rabelo 23/12/2020 - Ticket: 20201221012637

			oSection2:PrintLine()
		
			aFill(aDados1,nil)
			(cAlias2)->(dbskip())
		End
		oSection2:PrintTotal()
		oSection2:Finish()
		oReport:SkipLine()
	
		aFill(aDados1,nil)
	
		(cAlias2)->(dbCloseArea())
	EndIf
	oReport:SkipLine()


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |StQuery  ºAutor  ³João Victor         º Data ³  12/03/15   º±±
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

	Local cQuery1     := ' '
	Local cQuery2     := ' '

	cQuery1 := " SELECT

	cQuery1 += " ZZT_DTEMIS AS A1_DT_EMISSAO,

	cQuery1 += " CASE WHEN  ZZT_FILDES = '01' THEN 'FÁBRICA'   ELSE
	cQuery1 += " CASE WHEN  ZZT_FILDES = '02' THEN 'CD SP'     ELSE
	cQuery1 += " CASE WHEN  ZZT_FILDES = '09' THEN 'CAJAMAR'   ELSE
	cQuery1 += " CASE WHEN  ZZT_FILDES = '10' THEN 'GUARAREMA' ELSE
	cQuery1 += " 'SEM DESTINO' END END END END AS A2_DESTINO,

	cQuery1 += " CASE WHEN  ZZT_STATUS = '1' THEN 'ABERTO'     ELSE
	cQuery1 += " CASE WHEN  ZZT_STATUS = '2' THEN 'FECHADO'    ELSE
	cQuery1 += " CASE WHEN  ZZT_STATUS = '3' THEN 'FINALIZADO' ELSE
	cQuery1 += " 'SEM STATUS' END END END AS A3_STATUS,

	cQuery1 += " ZZT_NUMEMB AS A4_EMBARQUE,
	cQuery1 += " ZZT_NF     AS A5_NF,

	cQuery1 += " ZZT_SERIEN AS A6_SERIE,
	cQuery1 += " A1_COD     AS A7_COD,
	cQuery1 += " A1_LOJA    AS A8_LOJA,
	cQuery1 += " A1_NOME    AS A9_NOME,
	cQuery1 += " A1_CGC     AS A10_CNPJ


	cQuery1 += " FROM "+RetSqlName("ZZT")+" ZZT "

	cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery1 += " ON SA1.D_E_L_E_T_ = ' '
	cQuery1 += " AND A1_COD  = ZZT_CLIENT
	cQuery1 += " AND A1_LOJA = ZZT_FILDES

	cQuery1 += " WHERE ZZT.D_E_L_E_T_ = ' '
	cQuery1 += " AND ZZT_NUMEMB = '"+_cEmbarque+"'"

	cQuery1 += " ORDER BY ZZT_NUMEMB

	
	cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)


	cQuery2 := " SELECT

	cQuery2 += " ZZT_DTEMIS AS A1_DT_EMISSAO,
	cQuery2 += " ZZT_FILDES AS A2_DESTINO,
	cQuery2 += " ZZT_STATUS AS A3_STATUS,
	cQuery2 += " ZZT_NUMEMB AS A4_EMBARQUE,

	cQuery2 += " ZZU_PALLET AS B1_PALLET,
	cQuery2 += " ZZU_VOLUME AS B2_VOLUME,
	cQuery2 += " ZZU_CHVVIR AS VOL_AGLUT,
	cQuery2 += " ZZU_PRODUT AS B3_PRODUTO,
	cQuery2 += " ZZU_QTDE   AS B4_QUANTIDADE,
	cQuery2 += " ZZU_OP     AS B5_ORDEM_PRODUCAO,
	cQuery2 += " (ZZU_QTDE*B1_PESO)    AS B6_PESO_LIQUIDO,
	cQuery2 += " ZZU_DTEMIS AS B7_DT_INCUSAO,
	cQuery2 += " ZZU_HRINI  AS B8_HR_INCLUSAO,
	cQuery2 += " ZZU_USERIN AS B9_USUARIO_INCLUSAO

	cQuery2 += " FROM "+RetSqlName("ZZT")+" ZZT "

	cQuery2 += " INNER JOIN "+RetSqlName("ZZU")+" ZZU "
	
	cQuery2 += " ON ZZU.D_E_L_E_T_ = ' '
	cQuery2 += " AND ZZT_NUMEMB = ZZU_NUMEMB
	cQuery2 += " AND ZZT_FILIAL = ZZU_FILIAL

	cQuery2 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery2 += " ON SB1.D_E_L_E_T_ = ' '
	cQuery2 += " AND B1_COD = ZZU_PRODUT

	cQuery2 += " WHERE ZZT.D_E_L_E_T_ = ' '
	cQuery2 += " AND ZZT_NUMEMB = '"+_cEmbarque+"'"
	cQuery2 += " AND ZZU_PALLET BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'
	cQuery2 += " AND ZZU_VIRTUA <> 'N' " //Chamado 007618
	
	cQuery2 += " ORDER BY ZZT_NUMEMB, ZZU_PALLET, ZZU_VOLUME,ZZU_CHVVIR

	
	cQuery2 := ChangeQuery(cQuery2)

	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)

Return()
