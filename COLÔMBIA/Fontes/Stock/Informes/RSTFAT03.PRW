#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFAT03         | Autor | RENATO.OLIVEIRA          | Data | 04/02/2020  |
|=====================================================================================|
|Descri��o |  Relat�rio de stock   			                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function RSTFAT03()

	Local   oReport
	Private cPerg 			:= "RFAT03"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	//U_STPutSx1( cPerg, "01","Data de?" 		   			,"MV_PAR01","mv_ch1","D",10,0,"G",,"","@D")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de Pedidos Aptos a Faturar
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Informe de stock",cPerg,{|oReport| ReportPrint(oReport)},"Este programa imprimir� un informe de stock")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Stock",{"SB2"})

	TRCell():New(oSection,"01"	  	,,"C�digo"				,,TamSx3("B2_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"  	,,"Grupo"				,,TamSx3("B1_GRUPO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"  	,,"Descripci�n"			,,TamSx3("B1_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"  	,,"Cantidad 02"			,,TamSx3("B2_QATU")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"  	,,"Pedido 02"			,,TamSx3("B2_QPEDVEN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  	,,"Cantidad 03"			,,TamSx3("B2_QATU")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"  	,,"Pedido 03"			,,TamSx3("B2_QPEDVEN")[1],.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SB2")

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint  �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio GRUPO DE CLIENTE				                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta 	:= ''
	Local nValFat := 0
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()

	oSection1:Cell("01"):SetBlock( { || aDados1[01] } )
	oSection1:Cell("02"):SetBlock( { || aDados1[02] } )
	oSection1:Cell("03"):SetBlock( { || aDados1[03] } )
	oSection1:Cell("04"):SetBlock( { || aDados1[04] } )
	oSection1:Cell("05"):SetBlock( { || aDados1[05] } )
	oSection1:Cell("06"):SetBlock( { || aDados1[06] } )
	oSection1:Cell("07"):SetBlock( { || aDados1[07] } )

	oReport:SetTitle("Informe de stock")// Titulo do relat�rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Procesamiento")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->B2_COD
			aDados1[02]	:= 	(cAliasLif)->B1_GRUPO
			aDados1[03]	:=	(cAliasLif)->B1_DESC
			aDados1[04]	:=	(cAliasLif)->A02_QATU
			aDados1[05]	:=	(cAliasLif)->A02_QPEDVEN
			aDados1[06]	:=	(cAliasLif)->A03_QATU
			aDados1[07]	:=	(cAliasLif)->A03_QPEDVEN

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio GRUPO DE CLIENTE				                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function StQuery()

	Local cQuery     := ' '

	cQuery := " SELECT *
	cQuery += " FROM
	cQuery += " (
	cQuery += " SELECT B2_COD,B2_LOCAL,B2_QATU, B2_QPEDVEN, B1_GRUPO, B1_DESC
	cQuery += " FROM "+RetSqlName("SB2")+" B2
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1
	cQuery += " ON B1_COD=B2_COD
	cQuery += " WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	cQuery += " AND B2_LOCAL IN ('02','03')
	cQuery += " ) XXX
	cQuery += " PIVOT ( SUM(B2_QATU) AS QATU, SUM(B2_QPEDVEN) AS QPEDVEN FOR (B2_LOCAL) IN ('02' AS A02, '03' as A03) )
	cQuery += " ORDER BY B2_COD

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
