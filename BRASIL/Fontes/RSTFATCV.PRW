#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCV        | Autor | RENATO.OLIVEIRA           | Data | 16/07/2020  |
|=====================================================================================|
|Descrição | Relatório de unicom			                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCV()

	Local   oReport
	Private cPerg 			:= "RFATCV"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	//U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	//U_STPutSx1( cPerg, "02","Data ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de unicom",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de unicom")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"Z51",{"Z51"})

	TRCell():New(oSection1,"01"	  			 ,,"Pedido"									,,TamSx3("C6_NUM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Nome"									,,TamSx3("C5_XNOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Emissão"								,,TamSx3("C5_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Programação"							,,TamSx3("C5_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Produto"								,,TamSx3("C6_PRODUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"Preço"									,,TamSx3("C6_PRCVEN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"Quantidade"								,,TamSx3("C6_QTDVEN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"Valor liquido"							,,TamSx3("C6_ZVALLIQ")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"Descrição"								,,TamSx3("B1_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"Grupo"									,,TamSx3("B1_GRUPO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"Dt Lib Des"								,,TamSx3("B1_XLIBDES")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"Qtde Res"								,,TamSx3("PA1_QUANT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"13"	  			 ,,"Dt ent 2"								,,TamSx3("C6_ZENTRE2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"14"	  			 ,,"Ordex"									,,TamSx3("C6_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"15"	  			 ,,"Obs"									,,100,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"16"	  			 ,,"Status"									,,TamSx3("PP8_XSTATU")[1],.F.,,,,,,,.T.)	

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SC6")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )
	oSection1:Cell('09')      :SetBlock( { || aDados1[09] } )
	oSection1:Cell('10')      :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11')      :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12')      :SetBlock( { || aDados1[12] } )
	oSection1:Cell('13')      :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14')      :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15')      :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16')      :SetBlock( { || aDados1[16] } )

	oReport:SetTitle("Relatório de unicom")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= (cAliasLif)->C6_NUM
			aDados1[02]	:= (cAliasLif)->C5_XNOME
			aDados1[03]	:= STOD((cAliasLif)->C5_EMISSAO)
			aDados1[04]	:= (cAliasLif)->PROGRAMACAO
			aDados1[05]	:= (cAliasLif)->C6_PRODUTO
			aDados1[06]	:= (cAliasLif)->C6_PRCVEN
			aDados1[07]	:= (cAliasLif)->C6_QTDVEN
			aDados1[08]	:= (cAliasLif)->C6_ZVALLIQ
			aDados1[09]	:= (cAliasLif)->B1_DESC
			aDados1[10]	:= (cAliasLif)->B1_GRUPO
			aDados1[11]	:= STOD((cAliasLif)->B1_XLIBDES)
			aDados1[12]	:= (cAliasLif)->PA1_QUANT
			aDados1[13]	:= STOD((cAliasLif)->C6_ZENTRE2)							
			aDados1[14]	:= STOD((cAliasLif)->ORDERX)
			aDados1[15]	:= (cAliasLif)->OBS
			aDados1[16]	:= (cAliasLif)->STATUS

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT  C6_NUM,C5_XNOME,C5_EMISSAO,C5_XATE||'/'||C5_XMATE||'/'||C5_XAANO AS PROGRAMACAO,C6_PRODUTO,C6_PRCVEN,C6_QTDVEN,C6_ZVALLIQ,B1_DESC,B1_GRUPO,B1_XLIBDES,PA1_QUANT,C6_ZENTRE2 , 
	cQuery += " C5_XAANO||C5_XMATE||C5_XATE AS ORDERX ,NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(PP8_OBS,2000,1)),' ') OBS, NVL(PP8_XSTATU,' ') STATUS 
	cQuery += " FROM SC6010 SC6 
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = C6_PRODUTO AND B1_GRUPO IN ('041','042','122') 
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C6_FILIAL AND PA1_DOC = C6_NUM||C6_ITEM 
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.C5_TIPOCLI <> 'X'  
	cQuery += " LEFT JOIN PP8010 PP8 ON PP8_FILIAL=C6_FILIAL AND PP8_PEDVEN=C6_NUM||C6_ITEM AND PP8_PROD=C6_PRODUTO AND PP8.D_E_L_E_T_=' '  
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_FILIAL = '02' 
	cQuery += " UNION 
	cQuery += " SELECT ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL PROGRAMADOS' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX ,' ' OBS, ' ' STATUS 
	cQuery += " FROM SC6010 SC6 
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = C6_PRODUTO AND B1_GRUPO IN ('041','042','122') 
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C6_FILIAL AND PA1_DOC = C6_NUM||C6_ITEM 
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.C5_TIPOCLI <> 'X'  
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_FILIAL = '02' AND C5_XAANO||C5_XMATE||C5_XATE   <> ' ' 
	cQuery += " UNION 
	cQuery += " SELECT ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL NÃO PROGRAMADOS' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX ,' ' OBS, ' ' STATUS 
	cQuery += " FROM SC6010 SC6 
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = C6_PRODUTO AND B1_GRUPO IN ('041','042','122') 
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C6_FILIAL AND PA1_DOC = C6_NUM||C6_ITEM 
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.C5_TIPOCLI <> 'X'  
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_FILIAL = '02' AND C5_XAANO||C5_XMATE||C5_XATE   = ' ' 
	cQuery += " UNION 
	cQuery += " SELECT ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL  ' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX ,' ' OBS, ' ' STATUS 
	cQuery += " FROM SC6010 SC6 
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = C6_PRODUTO AND B1_GRUPO IN ('041','042','122') 
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C6_FILIAL AND PA1_DOC = C6_NUM||C6_ITEM 
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.C5_TIPOCLI <> 'X'  
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_FILIAL = '02'
	cQuery += " ORDER BY ORDERX

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()