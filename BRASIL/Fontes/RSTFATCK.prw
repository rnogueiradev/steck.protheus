#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCK     ºAutor  ³Giovani Zago    º Data ³  08/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  captação por supervisor                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCK()

	Local   oReport
	Private cPerg 			:= "RFATCK"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Emissão de?" 		   		,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Emissão ate?"				,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "03","Supervisor?"				,"MV_PAR03","mv_ch3","C",06,0,"G",,"SA3"  		,"@!")

	If ! (__cuserid $ GetMv("ST_FATCK",,'000378/000231')+'/000000/000645')
		MsgInfo("Usuario sem acesso, RSTFATCK ")
		Return()
	EndIf


	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO captação por supervisor",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de captação por supervisor.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"captação por supervisor",{"SC5"})


	TRCell():New(oSection,"GRUPO"	  	,,"GRUPO"		,,6,.F.,)
	TRCell():New(oSection,"DESCRIÇÃO"	,,"DESCRIÇÃO"	,,35,.F.,)
	TRCell():New(oSection,"CAPTADO"  	,,"CAPTADO"	,"@E 99,999,999.99",14)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("GRUPO")       :SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESCRIÇÃO")	  :SetBlock( { || aDados1[02] } )
	oSection1:Cell("CAPTADO")  	  :SetBlock( { || aDados1[03] } ) 

	oReport:SetTitle("Valor Captado")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()




	Processa({|| StQuery( ) },"Compondo Relatorio")




	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())


			aDados1[01]	:= 	(cAliasLif)->GRUPO
			aDados1[02]	:=  (cAliasLif)->DESCRICAO
			aDados1[03]	:=	(cAliasLif)->CAPTADO
			oSection1:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End



	EndIf



	oReport:SkipLine()




Return oReport



Static Function StQuery()

	Local cQuery      := ' '

	cQuery := " SELECT
	cQuery += ' SB1.B1_GRUPO      "GRUPO",
	cQuery += ' SUBSTR(SBM.BM_DESC,1,30)       "DESCRICAO",
	cQuery += "    SUM( SC6.C6_ZVALLIQ )
	cQuery += ' "CAPTADO"
	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
	cQuery += " ON SB1.D_E_L_E_T_   = ' '
	cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
	cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
	cQuery += " ON SBM.D_E_L_E_T_   = ' '
	cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_   = ' '
	cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
	cQuery += " ON SA3.D_E_L_E_T_   = ' '
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND1
	cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " AND SA3.A3_SUPER = '" +   MV_PAR03  + "'

	/*
	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )TA3 "
	cQuery += " ON TA3.D_E_L_E_T_   = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " AND TA3.A3_FILIAL = '"+xFilial("SA3")+"'"
	*/
	cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_EMISSAO  BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " AND PC1.PC1_PEDREP IS NULL

	cQuery += " GROUP BY SB1.B1_GRUPO ,SBM.BM_DESC

	cQuery += " ORDER  BY SB1.B1_GRUPO


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

