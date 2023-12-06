#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Define CR chr(13)+chr(10) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCP     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  Controladoria   		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCP()

	Local   oReport
	Private cPerg 			:= "RFATCP"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data de?" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate?"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")




	If ! (__cuserid $ GetMv("ST_FATCP",,'000271/001169/')+'/000000/000645')
		MsgInfo("Usuario sem acesso, RSTFATCP ")
		Return()
	EndIf


	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Controladoria",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório da Controladoria.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Controladoria",{"SC5"})


	TRCell():New(oSection,"EMPRESA"	  		,,"EMPRESA"			,,1,.F.,)
	TRCell():New(oSection,"MODALIDADE"		,,"MODALIDADE"		,,1,.F.,)
	TRCell():New(oSection,"NOTA_FISCAL"	  	,,"NOTA_FISCAL"		,,1,.F.,)
	TRCell():New(oSection,"EMISSAO"			,,"EMISSAO"			,,1,.F.,)
	TRCell():New(oSection,"QUANTIDADE"		,,"QUANTIDADE"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"PRODUTO"			,,"PRODUTO"			,,1,.F.,)
	TRCell():New(oSection,"DESCRICAO"	  	,,"DESCRICAO"		,,1,.F.,)
	TRCell():New(oSection,"GRUPO"	    	,,"GRUPO"			,,1,.F.,)
	TRCell():New(oSection,"DESC_GRUPO"		,,"DESC_GRUPO"	    ,,1,.F.,) 
	TRCell():New(oSection,"AGRUPAMENTO"	  	,,"AGRUPAMENTO"		,,1,.F.,)
	TRCell():New(oSection,"GRUPO_VENDAS"	,,"GRUPO_VENDAS"	,,1,.F.,)
	TRCell():New(oSection,"CODIGO"	  		,,"CODIGO"			,,1,.F.,)
	TRCell():New(oSection,"LOJA"			,,"LOJA"			,,1,.F.,)
	TRCell():New(oSection,"RAZAO_SOCIAL"	,,"RAZAO_SOCIAL"	,,1,.F.,)
	TRCell():New(oSection,"CNPJ"			,,"CNPJ"			,,1,.F.,)
	TRCell():New(oSection,"ESTADO"	  		,,"ESTADO"			,,1,.F.,)
	TRCell():New(oSection,"MUNICIPIO"	    ,,"MUNICIPIO"		,,1,.F.,)
	TRCell():New(oSection,"CODIGO_MUNICIPIO",,"CODIGO_MUNICIPIO",,1,.F.,)
	TRCell():New(oSection,"REGIAO"	  		,,"REGIAO"			,,1,.F.,)
	TRCell():New(oSection,"VENDEDOR"		,,"VENDEDOR"		,,1,.F.,)
	TRCell():New(oSection,"NOME_VENDEDOR"	,,"NOME_VENDEDOR"	,,1,.F.,)
	TRCell():New(oSection,"COORDENADOR"		,,"COORDENADOR"		,,1,.F.,)
	TRCell():New(oSection,"NOME_COORDENADOR",,"NOME_COORDENADOR",,1,.F.,)
	TRCell():New(oSection,"CUSTO"			,,"CUSTO"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"RECNO"	  		,,"RECNO"			,"@E 9999999999",10)
	TRCell():New(oSection,"LIQUIDO"	  		,,"LIQUIDO"			,"@E 99,999,999.99",14)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")



Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nT1		:= 0
	Local nT2		:= 0
	Local cQuery 	:= ""
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("EMPRESA")       	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("MODALIDADE")	  	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("NOTA_FISCAL")  	  	:SetBlock( { || aDados1[03] } ) 
	oSection1:Cell("EMISSAO")      		:SetBlock( { || aDados1[04] } )
	oSection1:Cell("QUANTIDADE")	  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("PRODUTO")  	  		:SetBlock( { || aDados1[06] } ) 
	oSection1:Cell("DESCRICAO")       	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("GRUPO")	  			:SetBlock( { || aDados1[08] } )
	oSection1:Cell("DESC_GRUPO")  		:SetBlock( { || aDados1[09] } ) 
	oSection1:Cell("AGRUPAMENTO")  		:SetBlock( { || aDados1[10] } ) 
	oSection1:Cell("GRUPO_VENDAS")  	:SetBlock( { || aDados1[11] } ) 
	oSection1:Cell("CODIGO")       		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("LOJA")	  			:SetBlock( { || aDados1[13] } )
	oSection1:Cell("RAZAO_SOCIAL")  	:SetBlock( { || aDados1[14] } ) 
	oSection1:Cell("CNPJ")       		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("ESTADO")	  		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("MUNICIPIO")  	  	:SetBlock( { || aDados1[17] } ) 
	oSection1:Cell("CODIGO_MUNICIPIO")  :SetBlock( { || aDados1[18] } )
	oSection1:Cell("REGIAO")	  		:SetBlock( { || aDados1[19] } )
	oSection1:Cell("VENDEDOR")  	  	:SetBlock( { || aDados1[20] } ) 
	oSection1:Cell("NOME_VENDEDOR")     :SetBlock( { || aDados1[21] } )
	oSection1:Cell("COORDENADOR")	  	:SetBlock( { || aDados1[22] } )
	oSection1:Cell("NOME_COORDENADOR")  :SetBlock( { || aDados1[23] } ) 
	oSection1:Cell("CUSTO")       		:SetBlock( { || aDados1[24] } )
	oSection1:Cell("RECNO")	  			:SetBlock( { || aDados1[25] } )
	oSection1:Cell("LIQUIDO")  			:SetBlock( { || aDados1[26] } )   




	oSection1:Cell("EMPRESA")			:SetBorder("TOP",,,)
	oSection1:Cell("MODALIDADE")		:SetBorder("TOP",,,)
	oSection1:Cell("NOTA_FISCAL")		:SetBorder("TOP",,,)
	oSection1:Cell("EMISSAO")			:SetBorder("TOP",,,)
	oSection1:Cell("QUANTIDADE")		:SetBorder("TOP",,,)
	oSection1:Cell("PRODUTO")			:SetBorder("TOP",,,)
	oSection1:Cell("DESCRICAO")			:SetBorder("TOP",,,)
	oSection1:Cell("GRUPO")				:SetBorder("TOP",,,)
	oSection1:Cell("DESC_GRUPO")		:SetBorder("TOP",,,)
	oSection1:Cell("AGRUPAMENTO")		:SetBorder("TOP",,,)
	oSection1:Cell("GRUPO_VENDAS")		:SetBorder("TOP",,,)
	oSection1:Cell("CODIGO")			:SetBorder("TOP",,,)
	oSection1:Cell("LOJA")				:SetBorder("TOP",,,)
	oSection1:Cell("RAZAO_SOCIAL")		:SetBorder("TOP",,,)
	oSection1:Cell("CNPJ")				:SetBorder("TOP",,,)
	oSection1:Cell("ESTADO")			:SetBorder("TOP",,,)
	oSection1:Cell("MUNICIPIO")			:SetBorder("TOP",,,)
	oSection1:Cell("CODIGO_MUNICIPIO")	:SetBorder("TOP",,,)
	oSection1:Cell("REGIAO")			:SetBorder("TOP",,,)
	oSection1:Cell("VENDEDOR")			:SetBorder("TOP",,,)
	oSection1:Cell("NOME_VENDEDOR")		:SetBorder("TOP",,,)
	oSection1:Cell("COORDENADOR")		:SetBorder("TOP",,,)
	oSection1:Cell("NOME_COORDENADOR")	:SetBorder("TOP",,,)
	oSection1:Cell("CUSTO")				:SetBorder("TOP",,,)
	oSection1:Cell("RECNO")				:SetBorder("TOP",,,)
	oSection1:Cell("LIQUIDO")			:SetBorder("TOP",,,)



	oReport:SetTitle("Controladoria")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()




	Processa({|| StQuery( ) },"Compondo Relatorio")




	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())


			aDados1[01]	:= 	(cAliasLif)->EMPRESA
			aDados1[02]	:=  (cAliasLif)->MODALIDADE
			aDados1[03]	:=	(cAliasLif)->NOTA_FISCAL
			aDados1[04]	:= 	(cAliasLif)->EMISSAO
			aDados1[05]	:=  (cAliasLif)->QUANTIDADE
			aDados1[06]	:=	(cAliasLif)->PRODUTO
			aDados1[07]	:= 	(cAliasLif)->DESCRICAO
			aDados1[08]	:=  (cAliasLif)->GRUPO
			aDados1[09]	:=	(cAliasLif)->DESC_GRUPO
			aDados1[10]	:= 	(cAliasLif)->AGRUPAMENTO
			aDados1[11]	:= 	(cAliasLif)->GRUPO_VENDAS
			aDados1[12]	:= 	(cAliasLif)->CODIGO
			aDados1[13]	:= 	(cAliasLif)->LOJA
			aDados1[14]	:= 	(cAliasLif)->RAZAO_SOCIAL
			aDados1[15]	:= 	(cAliasLif)->CNPJ
			aDados1[16]	:= 	(cAliasLif)->ESTADO
			aDados1[17]	:= 	(cAliasLif)->MUNICIPIO
			aDados1[18]	:= 	(cAliasLif)->CODIGO_MUNICIPIO
			aDados1[19]	:= 	(cAliasLif)->REGIAO
			aDados1[20]	:= 	(cAliasLif)->VENDEDOR
			aDados1[21]	:= 	(cAliasLif)->NOME_VENDEDOR
			aDados1[22]	:= 	(cAliasLif)->COORDENADOR
			aDados1[23]	:= 	(cAliasLif)->NOME_COORDENADOR
			aDados1[24]	:= 	(cAliasLif)->CUSTO
			aDados1[25]	:= 	(cAliasLif)->RECNO
			aDados1[26]	:= 	(cAliasLif)->LIQUIDO

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
	cQuery += CR+ " 'SP'                AS EMPRESA,
	cQuery += CR+ " 'FAT'               AS MODALIDADE,
	cQuery += CR+ " F2_DOC              AS NOTA_FISCAL,
	cQuery += CR+ " SUBSTR(F2_EMISSAO,7,2)||'/'||SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS EMISSAO,
	cQuery += CR+ " D2_QUANT            AS QUANTIDADE,
	cQuery += CR+ " D2_COD              AS PRODUTO,
	cQuery += CR+ " SB1.B1_DESC         AS DESCRICAO,
	cQuery += CR+ " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += CR+ " NVL(BM_DESC,'SEM GRUPO') AS DESC_GRUPO,
	cQuery += CR+ " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += CR+ " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += CR+ " A1_COD              AS CODIGO,
	cQuery += CR+ " A1_LOJA             AS LOJA,
	cQuery += CR+ " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += CR+ " A1_CGC              AS CNPJ,
	cQuery += CR+ " A1_EST              AS ESTADO,
	cQuery += CR+ " A1_MUN              AS MUNICIPIO,
	cQuery += CR+ " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += CR+ " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += CR+ " SA3.A3_COD          AS VENDEDOR,
	cQuery += CR+ " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += CR+ " TA3.A3_COD          AS COORDENADOR,
	cQuery += CR+ " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += CR+ " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += CR+ " SD2.R_E_C_N_O_      AS RECNO,
	cQuery += CR+ " SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM AS LIQUIDO

	cQuery += CR+ " FROM UDBD11.SD2110 SD2 

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBD11.SA1110)SA1
	cQuery += CR+ " ON SA1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND A1_COD = D2_CLIENTE
	cQuery += CR+ " AND A1_LOJA = D2_LOJA
	cQuery += CR+ " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += CR+ " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += CR+ " AND SA1.A1_EST    <> 'EX'

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBD11.SF2110)SF2
	cQuery += CR+ " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND F2_DOC = D2_DOC
	cQuery += CR+ " AND F2_SERIE = D2_SERIE
	cQuery += CR+ " AND F2_FILIAL = D2_FILIAL

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBD11.SB1110)SB1
	cQuery += CR+ " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SB1.B1_COD = D2_COD


	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += CR+ " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TB1.B1_COD = D2_COD


	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SBM110)SBM
	cQuery += CR+ " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += CR+ " AND SBM.BM_XAGRUP <> ' '

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SA3110)SA3
	cQuery += CR+ " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SA3.A3_COD = F2_VEND1

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SA3110)TA3
	cQuery += CR+ " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TA3.A3_COD = SA3.A3_SUPER

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SX5110)SX5
	cQuery += CR+ " ON SX5.X5_TABELA  = 'A2'              
	cQuery += CR+ " AND SX5.X5_CHAVE = SA1.A1_REGIAO

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SX5110)TX5
	cQuery += CR+ " ON TRIM(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += CR+ " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SB9110)SB9
	cQuery += CR+ " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND SB9.B9_FILIAL = '01'
	cQuery += CR+ " AND SB9.B9_COD = SD2.D2_COD
	cQuery += CR+ " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(D2_EMISSAO,1,6)
	cQuery += CR+ " AND SB9.B9_LOCAL = '15'
	cQuery += CR+ " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBD11.SB9110)TB9
	cQuery += CR+ " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND TB9.B9_FILIAL = '01'
	cQuery += CR+ " AND TB9.B9_COD = SD2.D2_COD
	cQuery += CR+ " AND SUBSTR(TB9.B9_DATA,1,6) =  SUBSTR(D2_EMISSAO,1,6)
	cQuery += CR+ " AND TB9.B9_LOCAL = '03'

	cQuery += CR+ " WHERE SD2.D_E_L_E_T_ = ' '    
	cQuery += CR+ " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502')
	cQuery += CR+ " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' 
	//cQuery += CR+ " AND D2_FILIAL ='02'  

	cQuery += CR+ " UNION

	cQuery += CR+ " SELECT 
	cQuery += CR+ " 'AM'                AS EMPRESA,
	cQuery += CR+ " 'FAT'               AS MODALIDADE,
	cQuery += CR+ " F2_DOC              AS NOTA_FISCAL,
	cQuery += CR+ " SUBSTR(F2_EMISSAO,7,2)||'/'||SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS EMISSAO,
	cQuery += CR+ " D2_QUANT            AS QUANTIDADE,
	cQuery += CR+ " D2_COD              AS PRODUTO,
	cQuery += CR+ " SB1.B1_DESC             AS DESCRICAO,
	cQuery += CR+ " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += CR+ " NVL(BM_DESC,'SEM GRUPO') AS DESC_GRUPO,
	cQuery += CR+ " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += CR+ " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += CR+ " A1_COD              AS CODIGO,
	cQuery += CR+ " A1_LOJA             AS LOJA,
	cQuery += CR+ " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += CR+ " A1_CGC              AS CNPJ,
	cQuery += CR+ " A1_EST              AS ESTADO,
	cQuery += CR+ " A1_MUN              AS MUNICIPIO,
	cQuery += CR+ " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += CR+ " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += CR+ " SA3.A3_COD          AS VENDEDOR,
	cQuery += CR+ " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += CR+ " TA3.A3_COD          AS COORDENADOR,
	cQuery += CR+ " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += CR+ " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += CR+ " SD2.R_E_C_N_O_      AS RECNO,
	cQuery += CR+ " SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM AS LIQUIDO

	cQuery += CR+ " FROM UDBP12.SD2030 SD2 

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery += CR+ " ON SA1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND A1_COD = D2_CLIENTE
	cQuery += CR+ " AND A1_LOJA = D2_LOJA
	cQuery += CR+ " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += CR+ " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += CR+ " AND SA1.A1_EST    <> 'EX'

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SF2030)SF2
	cQuery += CR+ " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND F2_DOC = D2_DOC
	cQuery += CR+ " AND F2_SERIE = D2_SERIE
	cQuery += CR+ " AND F2_FILIAL = D2_FILIAL

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SB1010)SB1
	cQuery += CR+ " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SB1.B1_COD = D2_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += CR+ " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TB1.B1_COD = D2_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SBM010)SBM
	cQuery += CR+ " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += CR+ " AND SBM.BM_XAGRUP <> ' '

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3030)SA3
	cQuery += CR+ " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SA3.A3_COD = F2_VEND1

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3030)TA3
	cQuery += CR+ " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TA3.A3_COD = SA3.A3_SUPER

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5030)SX5
	cQuery += CR+ " ON SX5.X5_TABELA  = 'A2'              
	cQuery += CR+ " AND SX5.X5_CHAVE = SA1.A1_REGIAO

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5010)TX5
	cQuery += CR+ " ON TRIM(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += CR+ " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += CR+ " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND SB9.B9_FILIAL = '01'
	cQuery += CR+ " AND SB9.B9_COD = SD2.D2_COD
	cQuery += CR+ " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(D2_EMISSAO,1,6)
	cQuery += CR+ " AND SB9.B9_LOCAL = '15'
	cQuery += CR+ " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9010)TB9
	cQuery += CR+ " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND TB9.B9_FILIAL = '02'
	cQuery += CR+ " AND TB9.B9_COD = SD2.D2_COD
	cQuery += CR+ " AND SUBSTR(TB9.B9_DATA,1,6) =  SUBSTR(D2_EMISSAO,1,6)
	cQuery += CR+ " AND TB9.B9_LOCAL = '03'



	cQuery += CR+ " WHERE SD2.D_E_L_E_T_ = ' '    
	cQuery += CR+ " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502')
	cQuery += CR+ " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += CR+ " AND D2_FILIAL ='01' 

	cQuery += CR+ " UNION

	cQuery += CR+ " SELECT 
	cQuery += CR+ " 'SP'                AS EMPRESA,
	cQuery += CR+ " 'DEV'               AS MODALIDADE,
	cQuery += CR+ " D1_DOC              AS NOTA_FISCAL,
	cQuery += CR+ " SUBSTR(D1_DTDIGIT,7,2)||'/'||SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS EMISSAO,
	cQuery += CR+ " D1_QUANT            AS QUANTIDADE,
	cQuery += CR+ " D1_COD              AS PRODUTO,
	cQuery += CR+ " SB1.B1_DESC             AS DESCRICAO,
	cQuery += CR+ " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += CR+ " NVL(BM_DESC,'SEM GRUPO') AS DESC_GRUPO,
	cQuery += CR+ " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += CR+ " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += CR+ " A1_COD              AS CODIGO,
	cQuery += CR+ " A1_LOJA             AS LOJA,
	cQuery += CR+ " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += CR+ " A1_CGC              AS CNPJ,
	cQuery += CR+ " A1_EST              AS ESTADO,
	cQuery += CR+ " A1_MUN              AS MUNICIPIO,
	cQuery += CR+ " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += CR+ " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += CR+ " SA3.A3_COD          AS VENDEDOR,
	cQuery += CR+ " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += CR+ " TA3.A3_COD          AS COORDENADOR,
	cQuery += CR+ " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += CR+ " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += CR+ " SD1.R_E_C_N_O_      AS RECNO,
	cQuery += CR+ " D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM-SD1.D1_DIFAL AS LIQUIDO

	cQuery += CR+ " FROM UDBP12.SD1010 SD1 

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SA1010)SA1
	cQuery += CR+ " ON SA1.D_E_L_E_T_ = ' '   
	cQuery += CR+ " AND SA1.A1_COD = SD1.D1_FORNECE  
	cQuery += CR+ " AND SA1.A1_LOJA = SD1.D1_LOJA   
	cQuery += CR+ " AND SA1.A1_FILIAL = '  '

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SF2010)SF2
	cQuery += CR+ " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SF2.F2_DOC = D1_NFORI 
	cQuery += CR+ " AND SF2.F2_SERIE = D1_SERIORI 
	cQuery += CR+ " AND SF2.F2_FILIAL = SD1.D1_FILIAL

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SB1010)SB1
	cQuery += CR+ " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SB1.B1_COD    = SD1.D1_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += CR+ " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TB1.B1_COD = D1_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SBM010)SBM
	cQuery += CR+ " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += CR+ " AND SBM.BM_XAGRUP <> ' '

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3010)SA3
	cQuery += CR+ " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SA3.A3_COD = F2_VEND1

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3010)TA3
	cQuery += CR+ " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TA3.A3_COD = SA3.A3_SUPER

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5010)SX5
	cQuery += CR+ " ON SX5.X5_TABELA  = 'A2'              
	cQuery += CR+ " AND SX5.X5_CHAVE = SA1.A1_REGIAO

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5010)TX5
	cQuery += CR+ " ON TRIM(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += CR+ " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += CR+ " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND SB9.B9_FILIAL = '01'
	cQuery += CR+ " AND SB9.B9_COD = SD1.D1_COD
	cQuery += CR+ " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(D1_DTDIGIT,1,6)
	cQuery += CR+ " AND SB9.B9_LOCAL = '15'
	cQuery += CR+ " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9010)TB9
	cQuery += CR+ " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND TB9.B9_FILIAL = '02'
	cQuery += CR+ " AND TB9.B9_COD = SD1.D1_COD
	cQuery += CR+ " AND SUBSTR(TB9.B9_DATA,1,6) =  SUBSTR(D1_DTDIGIT,1,6)
	cQuery += CR+ " AND TB9.B9_LOCAL = '03'



	cQuery += CR+ " WHERE SD1.D_E_L_E_T_ = ' '   
	cQuery += CR+ " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918' ,'2204')
	//cQuery += CR+ " AND  SD1.D1_FILIAL = '02'  
	cQuery += CR+ " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += CR+ " AND SD1.D1_TIPO = 'D'    

	cQuery += CR+ " UNION

	cQuery += CR+ " SELECT 
	cQuery += CR+ " 'AM'                AS EMPRESA,
	cQuery += CR+ " 'DEV'               AS MODALIDADE,
	cQuery += CR+ " D1_DOC              AS NOTA_FISCAL,
	cQuery += CR+ " SUBSTR(D1_DTDIGIT,7,2)||'/'||SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS EMISSAO,
	cQuery += CR+ " D1_QUANT            AS QUANTIDADE,
	cQuery += CR+ " D1_COD              AS PRODUTO,
	cQuery += CR+ " SB1.B1_DESC             AS DESCRICAO,
	cQuery += CR+ " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += CR+ " NVL(BM_DESC,'SEM GRUPO') AS DESC_GRUPO,
	cQuery += CR+ " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += CR+ " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += CR+ " A1_COD              AS CODIGO,
	cQuery += CR+ " A1_LOJA             AS LOJA,
	cQuery += CR+ " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += CR+ " A1_CGC              AS CNPJ,
	cQuery += CR+ " A1_EST              AS ESTADO,
	cQuery += CR+ " A1_MUN              AS MUNICIPIO,
	cQuery += CR+ " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += CR+ " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += CR+ " SA3.A3_COD          AS VENDEDOR,
	cQuery += CR+ " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += CR+ " TA3.A3_COD          AS COORDENADOR,
	cQuery += CR+ " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += CR+ " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += CR+ " SD1.R_E_C_N_O_      AS RECNO,
	cQuery += CR+ " D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM-SD1.D1_DIFAL  AS LIQUIDO

	cQuery += CR+ " FROM UDBP12.SD1030 SD1 

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery += CR+ " ON SA1.D_E_L_E_T_ = ' '   
	cQuery += CR+ " AND SA1.A1_COD = SD1.D1_FORNECE  
	cQuery += CR+ " AND SA1.A1_LOJA = SD1.D1_LOJA   
	cQuery += CR+ " AND SA1.A1_FILIAL = '  '

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SF2030)SF2
	cQuery += CR+ " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SF2.F2_DOC = D1_NFORI 
	cQuery += CR+ " AND SF2.F2_SERIE = D1_SERIORI 
	cQuery += CR+ " AND SF2.F2_FILIAL = SD1.D1_FILIAL

	cQuery += CR+ " INNER JOIN(SELECT * FROM UDBP12.SB1010)SB1
	cQuery += CR+ " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SB1.B1_COD    = SD1.D1_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += CR+ " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TB1.B1_COD = D1_COD

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SBM010)SBM
	cQuery += CR+ " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += CR+ " AND SBM.BM_XAGRUP <> ' '

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3010)SA3
	cQuery += CR+ " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND SA3.A3_COD = F2_VEND1

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SA3010)TA3
	cQuery += CR+ " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += CR+ " AND TA3.A3_COD = SA3.A3_SUPER

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5010)SX5
	cQuery += CR+ " ON SX5.X5_TABELA  = 'A2'              
	cQuery += CR+ " AND SX5.X5_CHAVE = SA1.A1_REGIAO

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SX5010)TX5
	cQuery += CR+ " ON TRIM(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += CR+ " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += CR+ " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND SB9.B9_FILIAL = '01'
	cQuery += CR+ " AND SB9.B9_COD = SD1.D1_COD
	cQuery += CR+ " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(D1_DTDIGIT,1,6)
	cQuery += CR+ " AND SB9.B9_LOCAL = '15'
	cQuery += CR+ " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'

	cQuery += CR+ " LEFT JOIN(SELECT * FROM UDBP12.SB9010)TB9
	cQuery += CR+ " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += CR+ " AND TB9.B9_FILIAL = '02'
	cQuery += CR+ " AND TB9.B9_COD = SD1.D1_COD
	cQuery += CR+ " AND SUBSTR(TB9.B9_DATA,1,6) =  SUBSTR(D1_DTDIGIT,1,6)
	cQuery += CR+ " AND TB9.B9_LOCAL = '03'



	cQuery += CR+ " WHERE SD1.D_E_L_E_T_ = ' '   
	cQuery += CR+ " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','2204')
	cQuery += CR+ " AND  SD1.D1_FILIAL = '01'  
	cQuery += CR+ " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += CR+ " AND SD1.D1_TIPO = 'D'    



	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

