#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CRLF chr(10)+chr(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFATB8   �Autor  �Richard N Cabral  � Data �  28/11/17     ���
�������������������������������������������������������������������������͹��
���Desc.     � An�lise de Oferta Log�stica                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFATB8()		//U_RSTFATB8()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATB8"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	cHelpPrazo := "Informe o c�digo para filtro ou * para Todos, X somente imprimir produtos que N�o Controla ou deixe em branco para todos exceto os que N�o Controla"

	U_STPutSx1( cPerg, "01","Produto de:"			   		,"MV_PAR01","mv_ch1","C",15,0,"G",,"SB1"	,"@!")
	U_STPutSx1( cPerg, "02","Produto at�:"			   		,"MV_PAR02","mv_ch2","C",15,0,"G",,"SB1"	,"@!")
	U_STPutSx1( cPerg, "03","Grupo de:"    			   		,"MV_PAR03","mv_ch3","C",04,0,"G",,"SBM"	,"@!")
	U_STPutSx1( cPerg, "04","Grupo At�:"   			   		,"MV_PAR04","mv_ch4","C",04,0,"G",,"SBM"	,"@!")
	U_STPutSx1( cPerg, "05","Grp.Vendas de?" 		   		,"MV_PAR05","mv_ch5","C",06,0,"G",,"ACY"	,"@!")
	U_STPutSx1( cPerg, "06","Grp.Vendas ate?"		   		,"MV_PAR06","mv_ch6","C",06,0,"G",,"ACY"	,"@!")
	U_STPutSx1( cPerg, "07","Cliente de?" 			   		,"MV_PAR07","mv_ch7","C",06,0,"G",,"SA1"	,"@!")
	U_STPutSx1( cPerg, "08","Cliente ate?"					,"MV_PAR08","mv_ch8","C",06,0,"G",,"SA1"	,"@!")
	U_STPutSx1( cPerg, "09","Data Emiss�o de?" 		   		,"MV_PAR09","mv_ch9","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "10","Data Emiss�o ate?"				,"MV_PAR10","mv_cha","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "11","Data Entrega de?" 		   		,"MV_PAR11","mv_chb","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "12","Data Entrega ate?"				,"MV_PAR12","mv_chc","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "13","Data Lib.Financ. de?" 		   	,"MV_PAR13","mv_chd","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "14","Data Lib.Financ. ate?"			,"MV_PAR14","mv_che","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "15","Prazo Oferta Logistica?"		,"MV_PAR15","mv_chf","C",01,0,"G",,"ZZO001"	,"@!",,,,,,cHelpPrazo)

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef  �Autor  �Richard N Cabral  � Data �  28/11/17     ���
�������������������������������������������������������������������������͹��
���Desc.     � An�lise de Oferta Log�stica                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	Pergunte(cPerg,.T.)

	oReport := TReport():New(cPergTit,"Relatorio de An�lise de Oferta Log�stica",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir o relat�rio de An�lise de Oferta Log�stica")

	oSection := TRSection():New(oReport,"An�lise de Oferta Log�stica",{"SC6"})

	TRCell():New(oSection,"01",,"Pedido"				,"@!"		,06,.F.,)
	TRCell():New(oSection,"02",,"Cliente"				,"@!"		,06,.F.,)
	TRCell():New(oSection,"03",,"Loja"					,"@!"		,02,.F.,)
	TRCell():New(oSection,"04",,"Raz�o Social"			,"@!"		,40,.F.,)
	TRCell():New(oSection,"05",,"Grupo Vendas"			,"@!"		,06,.F.,)
	TRCell():New(oSection,"06",,"Descri��o Grupo Vendas","@!"		,30,.F.,)
	TRCell():New(oSection,"07",,"Tipo Fatura"			,"@!"		,07,.F.,)
	TRCell():New(oSection,"08",,"Item"					,"@!"		,02,.F.,)
	TRCell():New(oSection,"09",,"Qtde.Vendida"			,"@!"		,08,.F.,)
	TRCell():New(oSection,"10",,"Produto"				,"@!"		,15,.F.,)
	TRCell():New(oSection,"11",,"Descri��o Produto"		,"@!"		,50,.F.,)
	TRCell():New(oSection,"12",,"Grupo"					,"@!"		,04,.F.,)
	TRCell():New(oSection,"13",,"Descri��o Grupo"		,"@!"		,45,.F.,)
	TRCell():New(oSection,"14",,"Data Emiss�o"			,"@!"		,10,.F.,)
	TRCell():New(oSection,"15",,"Data Lib.Financ."		,"@!"		,10,.F.,)
	TRCell():New(oSection,"16",,"Dias OF"				,"@E 9999"	,03,.F.,)
	TRCell():New(oSection,"17",,"Data Oferta Log"		,"@!"		,10,.F.,)
	TRCell():New(oSection,"18",,"Data Entrega"			,"@!"		,10,.F.,)
	TRCell():New(oSection,"19",,"Diferen�a"				,"@E 9999"	,04,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint�Autor  �Richard N Cabral  � Data �  28/11/17     ���
�������������������������������������������������������������������������͹��
���Desc.     � An�lise de Oferta Log�stica                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local aDados[19]

	oSection:Cell("01") :SetBlock( { || aDados[01] } )
	oSection:Cell("02") :SetBlock( { || aDados[02] } )
	oSection:Cell("03") :SetBlock( { || aDados[03] } )
	oSection:Cell("04") :SetBlock( { || aDados[04] } )
	oSection:Cell("05") :SetBlock( { || aDados[05] } )
	oSection:Cell("06") :SetBlock( { || aDados[06] } )
	oSection:Cell("07") :SetBlock( { || aDados[07] } )
	oSection:Cell("08") :SetBlock( { || aDados[08] } )
	oSection:Cell("09") :SetBlock( { || aDados[09] } )
	oSection:Cell("10") :SetBlock( { || aDados[10] } )
	oSection:Cell("11") :SetBlock( { || aDados[11] } )
	oSection:Cell("12") :SetBlock( { || aDados[12] } )
	oSection:Cell("13") :SetBlock( { || aDados[13] } )
	oSection:Cell("14") :SetBlock( { || aDados[14] } )
	oSection:Cell("15") :SetBlock( { || aDados[15] } )
	oSection:Cell("16") :SetBlock( { || aDados[16] } )
	oSection:Cell("17") :SetBlock( { || aDados[17] } )
	oSection:Cell("18") :SetBlock( { || aDados[18] } )
	oSection:Cell("19") :SetBlock( { || aDados[19] } )

	oReport:SetTitle("An�lise de Oferta Log�stica")

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()


	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		Do While (cAliasLif)->(!Eof())
			aDados[01]	:=  (cAliasLif)->C6_NUM
			aDados[02]	:=  (cAliasLif)->C5_CLIENTE
			aDados[03]	:=  (cAliasLif)->C5_LOJACLI
			aDados[04]	:=  (cAliasLif)->A1_NOME
			aDados[05]	:=  (cAliasLif)->ACY_GRPVEN
			aDados[06]	:=  (cAliasLif)->ACY_DESCRI
			aDados[07]	:=  (cAliasLif)->TIPO
			aDados[08]	:=  (cAliasLif)->C6_ITEM
			aDados[09]	:=  (cAliasLif)->C6_QTDVEN
			aDados[10]	:=  (cAliasLif)->C6_PRODUTO
			aDados[11]	:=	(cAliasLif)->B1_DESC
			aDados[12]	:=	(cAliasLif)->B1_GRUPO
			aDados[13]	:= 	(cAliasLif)->BM_DESC
			aDados[14]	:= 	StoD((cAliasLif)->C6_ZDTEMIS)
			aDados[15]	:= 	StoD((cAliasLif)->C6_ZDTLIBF)
			aDados[16]	:= 	(cAliasLif)->C6_ZPROFL
			aDados[17]	:= 	DataValida(StoD((cAliasLif)->C6_ZDTLIBF) + (cAliasLif)->C6_ZPROFL,.T.)
			aDados[18]	:= 	StoD((cAliasLif)->C6_ENTRE1)
			aDados[19]	:= 	( DataValida(StoD((cAliasLif)->C6_ZDTLIBF) + (cAliasLif)->C6_ZPROFL,.T.) - StoD((cAliasLif)->C6_ENTRE1 ))

			oSection:PrintLine()
			aFill(aDados,nil)
			(cAliasLif)->(dbskip())
		EndDo
	
		oSection:PrintLine()
		aFill(aDados,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery    �Autor  �Richard N Cabral  � Data �  28/11/17     ���
�������������������������������������������������������������������������͹��
���Desc.     � An�lise de Oferta Log�stica                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery := ' '

	cQuery := " SELECT C5_CLIENTE, C5_LOJACLI, C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, " + CRLF
	cQuery += " CASE WHEN C5_XTIPF = 1 THEN 'TOTAL' ELSE 'PARCIAL' END AS TIPO, " + CRLF
	cQuery += " B1_DESC, B1_GRUPO, BM_DESC, B1_ZCODOL, A1_NOME, ACY_GRPVEN, ACY_DESCRI, " + CRLF
	cQuery += " C6_ZDTEMIS, C6_ZDTLIBF, C6_ZPROFL, C6_ENTRE1 " + CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SC5") + " SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND SC5.D_E_L_E_T_= ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SF4") + " SF4 ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("ACY") + " ACY ON ACY_GRPVEN = A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SBM") + " SBM ON BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cQuery += " AND (B1_TIPO = 'PA' OR B1_TIPO = 'PI') " + CRLF
	cQuery += " AND F4_ESTOQUE = 'S' " + CRLF
	cQuery += " AND F4_DUPLIC = 'S' " + CRLF
	cQuery += " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
	cQuery += " AND B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	cQuery += " AND C6_ZDTEMIS BETWEEN '" + DtoS(MV_PAR09) + "' AND '" + Dtos(MV_PAR10) + "' " + CRLF
	cQuery += " AND C6_ENTRE1 BETWEEN '" + DtoS(MV_PAR11) + "' AND '" + Dtos(MV_PAR12) + "' " + CRLF
	cQuery += " AND C6_ZDTLIBF BETWEEN '" + DtoS(MV_PAR13) + "' AND '" + Dtos(MV_PAR14) + "' " + CRLF
	cQuery += " AND C6_CLI BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " + CRLF
	cQuery += " AND A1_GRPVEN BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
	If MV_PAR15 <> "*"
		If MV_PAR15 = " "
			cQuery += " AND B1_ZCODOL <> 'X' " + CRLF
		Else
			cQuery += " AND B1_ZCODOL = '" + MV_PAR15 + "' " + CRLF
		EndIf		
	EndIf		
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " ORDER BY C6_NUM, C6_ITEM " + CRLF

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
