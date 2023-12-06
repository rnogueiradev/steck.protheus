#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATDC        | Autor | RENATO.OLIVEIRA           | Data | 17/01/2022  |
|=====================================================================================|
|Descrição | Relatório de faturamento comercial										  |
|          | 14/12/2022 - Adaptado por: Flávia Rocha - Sigamat Consultoria            |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
14/12/2022 - Alteração realizada mediante ticket #20221214021835
Por Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
para que o arquivo gerado seja menos pesado que o gerado via Treport
\====================================================================================*/

User Function RSTFATDC(oExcel)

	//Local   oReport
	Local cDirTemp    := ""
	Private cPerg 			:= "RFATDC"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private _lTela 			:= .F.
	Default oExcel := FwMsExcelXlsx():New()

	U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	If IsInCallStack("U_STFAT570")
		_lTela := .F.
	Else
		_lTela := .T.
	EndIf

	If _lTela
	   IF ! Pergunte(cPerg,.T.)
	      Return()
	   Endif  
	Else
		Pergunte(cPerg,.F.)
	EndIf

	If IsInCallStack("U_STFAT570")
		MV_PAR01 := GetMv("RSTFATDC01",,CTOD("01/01/2023"))
		MV_PAR02 := Date()
	EndIf

	//oReport		:= ReportDef()	//FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
	oExcel := ImpAnalitico(oExcel)
	PROCESSA({|| StQuery() },"Compondo Relatorio") 
	PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

	If IsInCallStack("U_STFAT570")
		//_cArq := 'faturamento.xls'
		//FErase(_cArq)
		//oReport:SetPreview(.F.)
		//oReport:SetDevice(4)
		//oReport:cFile := '\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\'+_cArq
		//oReport:Print(.F.)

		//---------------------------------------------------------------------------------------//
		//14/12/2022 - Alteração realizada mediante ticket #20221214021835
		//FR - Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
		//para que o arquivo gerado seja menos pesado que o gerado via Treport
		//---------------------------------------------------------------------------------------//
		_cArq := 'faturamento.xlsx'
		cPasta := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"+_cArq
		FErase(cPasta)
		oExcel:Activate()
		oExcel:GetXMLFile( cPasta )
		oExcel:DeActivate()
	Else
		_cArq := 'rstfadc.xlsx'
		cDirTemp    := GetTempPath()
		cPasta := cDirTemp
		oExcel:Activate()
		//If !ExistDir("C:\Temp")
		//	MakeDir("C:\Temp")
		//EndIf
		Processa({|| oExcel:GetXMLFile( cPasta + _cArq) },"Aguarde", "Montando a Planilha...")
		oExcel:DeActivate()
		Sleep(5000)
		ShellExecute("OPEN",_cArq,"",cPasta,1)
	EndIf

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
//---------------------------------------------------------------------------------------//
//14/12/2022 - Alteração realizada mediante ticket #20221214021835
//FR - Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
//para que o arquivo gerado seja menos pesado que o gerado via Treport
//---------------------------------------------------------------------------------------//
/* //FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
Static Function ReportDef()

	Local oReport
	Local oSection1
	//Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de faturamento",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de faturamento comercial")

	oSection1 := TRSection():New(oReport,"SF2",{"SF2"})

	TRCell():New(oSection1,"01"	  			 ,,"EMPRESA"								,,2,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"MODALIDADE"								,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"NOTA_FISCAL"							,,TamSx3("F2_DOC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"EMISSAO"								,,TamSx3("F2_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"MES_ANO"								,,TamSx3("F2_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"QUANTIDADE"								,,TamSx3("D2_QUANT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"PRODUTO"								,,TamSx3("D2_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"DESCRICAO"								,,TamSx3("B1_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"GRUPO"									,,TamSx3("BM_GRUPO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"DESC_GRUPO"								,,TamSx3("BM_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"AGRUPAMENTO"							,,TamSx3("X5_DESCRI")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"GRUPO_VENDAS"							,,TamSx3("A1_GRPVEN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"13"	  			 ,,"CODIGO"									,,TamSx3("A1_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"14"	  			 ,,"LOJA"									,,TamSx3("A1_LOJA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"15"	  			 ,,"RAZAO_SOCIAL"							,,TamSx3("A1_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"16"	  			 ,,"CNPJ"									,,TamSx3("A1_CGC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"17"	  			 ,,"ESTADO"									,,TamSx3("A1_EST")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"18"	  			 ,,"MUNICIPIO"								,,TamSx3("A1_MUN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"19"	  			 ,,"CODIGO_MUNICIPIO"						,,TamSx3("A1_COD_MUN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"20"	  			 ,,"REGIAO"									,,TamSx3("X5_DESCRI")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"21"	  			 ,,"VENDEDOR"								,,TamSx3("A3_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"22"	  			 ,,"NOME_VENDEDOR"							,,TamSx3("A3_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"23"	  			 ,,"COORDENADOR"							,,TamSx3("A3_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"24"	  			 ,,"NOME_COORDENADOR"						,,TamSx3("A3_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"25"	  			 ,,"CUSTO"									,,TamSx3("B9_CM1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"26"	  			 ,,"RECNO"									,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"27"	  			 ,,"LIQUIDO_NET"							,,TamSx3("D2_TOTAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"28"	  			 ,,"ORIGEM"									,,TamSx3("C5_XORIG")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"29"	  			 ,,"PEDIDO"									,,6,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"30"	  			 ,,"ITEMPV"									,,2,.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SF2")

Return oReport
*/

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
//---------------------------------------------------------------------------------------//
//14/12/2022 - Alteração realizada mediante ticket #20221214021835
//FR - Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
//para que o arquivo gerado seja menos pesado que o gerado via Treport
//---------------------------------------------------------------------------------------//
/* //FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	//Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	//Local _cAlias1  := GetNextAlias()
	//Local _nX

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
	oSection1:Cell('17')      :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18')      :SetBlock( { || aDados1[18] } )
	oSection1:Cell('19')      :SetBlock( { || aDados1[19] } )
	oSection1:Cell('20')      :SetBlock( { || aDados1[20] } )
	oSection1:Cell('21')      :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22')      :SetBlock( { || aDados1[22] } )
	oSection1:Cell('23')      :SetBlock( { || aDados1[23] } )
	oSection1:Cell('24')      :SetBlock( { || aDados1[24] } )
	oSection1:Cell('25')      :SetBlock( { || aDados1[25] } )
	oSection1:Cell('26')      :SetBlock( { || aDados1[26] } )
	oSection1:Cell('27')      :SetBlock( { || aDados1[27] } )
	oSection1:Cell('28')      :SetBlock( { || aDados1[28] } )
	oSection1:Cell('29')      :SetBlock( { || aDados1[29] } )
	oSection1:Cell('30')      :SetBlock( { || aDados1[30] } )

	oReport:SetTitle("Relatório de captação comercial")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While (cAliasLif)->(!Eof())

			aDados1[01]	:= (cAliasLif)->EMPRESA
			aDados1[02]	:= (cAliasLif)->MODALIDADE
			aDados1[03]	:= (cAliasLif)->NOTA_FISCAL
			aDados1[04]	:= (cAliasLif)->EMISSAO
			aDados1[05]	:= (cAliasLif)->MES_ANO
			aDados1[06]	:= (cAliasLif)->QUANTIDADE
			aDados1[07]	:= (cAliasLif)->PRODUTO
			aDados1[08]	:= (cAliasLif)->DESCRICAO
			aDados1[09]	:= (cAliasLif)->GRUPO
			aDados1[10]	:= (cAliasLif)->DESC_GRUPO
			aDados1[11]	:= (cAliasLif)->AGRUPAMENTO
			aDados1[12]	:= (cAliasLif)->GRUPO_VENDAS
			aDados1[13]	:= (cAliasLif)->CODIGO
			aDados1[14]	:= (cAliasLif)->LOJA
			aDados1[15]	:= (cAliasLif)->RAZAO_SOCIAL
			aDados1[16]	:= (cAliasLif)->CNPJ
			aDados1[17]	:= (cAliasLif)->ESTADO
			aDados1[18]	:= (cAliasLif)->MUNICIPIO
			aDados1[19]	:= (cAliasLif)->CODIGO_MUNICIPIO
			aDados1[20]	:= (cAliasLif)->REGIAO
			aDados1[21]	:= (cAliasLif)->VENDEDOR
			aDados1[22]	:= (cAliasLif)->NOME_VENDEDOR
			aDados1[23]	:= (cAliasLif)->COORDENADOR
			aDados1[24]	:= (cAliasLif)->NOME_COORDENADOR
			aDados1[25]	:= (cAliasLif)->CUSTO
			aDados1[26]	:= (cAliasLif)->RECNO
			aDados1[27]	:= (cAliasLif)->LIQUIDO_NET
			aDados1[28]	:= (cAliasLif)->ORIGEM
			aDados1[29]	:= (cAliasLif)->D2_PEDIDO
			aDados1[30]	:= (cAliasLif)->D2_ITEMPV

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport
//FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
*/

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
	//Local nReg

	cQuery := " SELECT 
	cQuery += " 'SP'                AS EMPRESA,
	cQuery += " 'FAT'               AS MODALIDADE,
	cQuery += " F2_DOC              AS NOTA_FISCAL,
	cQuery += " SUBSTR(F2_EMISSAO,7,2)||'/'||SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS EMISSAO,
	cQuery += " SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS MES_ANO,
	cQuery += " D2_QUANT            AS QUANTIDADE,
	cQuery += " D2_COD              AS PRODUTO,
	cQuery += " SB1.B1_DESC         AS DESCRICAO,
	cQuery += " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += " NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO,
	cQuery += " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += " A1_COD              AS CODIGO,
	cQuery += " A1_LOJA             AS LOJA,
	cQuery += " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += " A1_CGC              AS CNPJ,
	cQuery += " A1_EST              AS ESTADO,
	cQuery += " A1_MUN              AS MUNICIPIO,
	cQuery += " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += " A1_XESCALA          AS CATEGORIA,
	cQuery += " A1_GRPVEN           AS CANAL,
	cQuery += " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += " SA3.A3_COD          AS VENDEDOR,
	cQuery += " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += " TA3.A3_COD          AS COORDENADOR,
	cQuery += " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += " SD2.R_E_C_N_O_      AS RECNO,
	cQuery += " SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM AS LIQUIDO_NET,
	cQuery += " (CASE WHEN C5_XORIG='2' THEN 'MKP' WHEN C5_XORIG='3' THEN 'EDI' WHEN C5_XORIG='1' THEN 'PORTAL' WHEN C5_XORIG='4' THEN 'CRM' ELSE ' ' END) ORIGEM
	cQuery += " ,D2_PEDIDO,D2_ITEMPV,C5_CODOPOR

	cQuery += " FROM SD2110 SD2 
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SA1110)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' ' 
	cQuery += " AND A1_COD = D2_CLIENTE
	cQuery += " AND A1_LOJA = D2_LOJA
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " 
	cQuery += " LEFT JOIN SC5110 C5
	cQuery += " ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5.D_E_L_E_T_=' ' 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SF2110)SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += " AND F2_DOC = D2_DOC
	cQuery += " AND F2_SERIE = D2_SERIE
	cQuery += " AND F2_FILIAL = D2_FILIAL
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND SB1.B1_COD = D2_COD
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND TB1.B1_COD = D2_COD
	cQuery += " 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SBM110)SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND SA3.A3_COD = F2_VEND1
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)SX5
	cQuery += " ON SX5.X5_TABELA  = 'A2'              
	cQuery += " AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)TX5
	cQuery += " ON Trim(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += " AND SB9.B9_FILIAL = '01'
	cQuery += " AND SB9.B9_COD = SD2.D2_COD
	cQuery += " AND SB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D2_EMISSAO,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND SB9.B9_LOCAL = '15'
	cQuery += " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SB9110)TB9
	cQuery += " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += " AND TB9.B9_FILIAL = '01'
	cQuery += " AND TB9.B9_COD = SD2.D2_COD
	cQuery += " AND TB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D2_EMISSAO,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND TB9.B9_LOCAL = '03'
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '    
	cQuery += " AND SD2.D2_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
	cQuery += " AND D2_EMISSAO between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"'
	cQuery += " AND F2_TIPO='N'
	cQuery += " 
	cQuery += " UNION
	cQuery += " 
	cQuery += " SELECT 
	cQuery += " 'AM'                AS EMPRESA,
	cQuery += " 'FAT'               AS MODALIDADE,
	cQuery += " F2_DOC              AS NOTA_FISCAL,
	cQuery += " SUBSTR(F2_EMISSAO,7,2)||'/'||SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS EMISSAO,
	cQuery += " SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS MES_ANO,
	cQuery += " D2_QUANT            AS QUANTIDADE,
	cQuery += " D2_COD              AS PRODUTO,
	cQuery += " SB1.B1_DESC             AS DESCRICAO,
	cQuery += " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += " NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO,
	cQuery += " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += " A1_COD              AS CODIGO,
	cQuery += " A1_LOJA             AS LOJA,
	cQuery += " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += " A1_CGC              AS CNPJ,
	cQuery += " A1_EST              AS ESTADO,
	cQuery += " A1_MUN              AS MUNICIPIO,
	cQuery += " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += " A1_XESCALA          AS CATEGORIA,
	cQuery += " A1_GRPVEN           AS CANAL,
	cQuery += " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += " SA3.A3_COD          AS VENDEDOR,
	cQuery += " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += " TA3.A3_COD          AS COORDENADOR,
	cQuery += " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += " SD2.R_E_C_N_O_      AS RECNO,
	cQuery += " SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM AS LIQUIDO_NET
	cQuery += " ,' ' ORIGEM
	cQuery += " ,D2_PEDIDO,D2_ITEMPV, ' ' C5_CODOPOR
	cQuery += " 
	cQuery += " FROM UDBP12.SD2030 SD2 
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' ' 
	cQuery += " AND A1_COD = D2_CLIENTE
	cQuery += " AND A1_LOJA = D2_LOJA
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM UDBP12.SF2030)SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += " AND F2_DOC = D2_DOC
	cQuery += " AND F2_SERIE = D2_SERIE
	cQuery += " AND F2_FILIAL = D2_FILIAL
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND SB1.B1_COD = D2_COD
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND TB1.B1_COD = D2_COD
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SBM110)SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SA3030)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND SA3.A3_COD = F2_VEND1
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SA3030)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SX5030)SX5
	cQuery += " ON SX5.X5_TABELA  = 'A2'              
	cQuery += " AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)TX5
	cQuery += " ON Trim(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += " AND SB9.B9_FILIAL = '01'
	cQuery += " AND SB9.B9_COD = SD2.D2_COD
	cQuery += " AND SB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D2_EMISSAO,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND SB9.B9_LOCAL = '15'
	cQuery += " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SB9110)TB9
	cQuery += " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += " AND TB9.B9_FILIAL = '01'
	cQuery += " AND TB9.B9_COD = SD2.D2_COD
	cQuery += " AND TB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D2_EMISSAO,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND TB9.B9_LOCAL = '03'
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '    
	cQuery += " AND SD2.D2_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
	cQuery += " AND D2_EMISSAO between  '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"'
	cQuery += " AND D2_FILIAL ='01' 
	cQuery += " AND F2_TIPO='N'
	cQuery += " 
	cQuery += " UNION
	cQuery += " 
	cQuery += " SELECT 
	cQuery += " 'SP'                AS EMPRESA,
	cQuery += " 'DEV'               AS MODALIDADE,
	cQuery += " D1_DOC              AS NOTA_FISCAL,
	cQuery += " SUBSTR(D1_DTDIGIT,7,2)||'/'||SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS EMISSAO,
	cQuery += " SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS MES_ANO,
	cQuery += " D1_QUANT            AS QUANTIDADE,
	cQuery += " D1_COD              AS PRODUTO,
	cQuery += " SB1.B1_DESC             AS DESCRICAO,
	cQuery += " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += " NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO,
	cQuery += " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += " A1_COD              AS CODIGO,
	cQuery += " A1_LOJA             AS LOJA,
	cQuery += " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += " A1_CGC              AS CNPJ,
	cQuery += " A1_EST              AS ESTADO,
	cQuery += " A1_MUN              AS MUNICIPIO,
	cQuery += " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += " A1_XESCALA          AS CATEGORIA,
	cQuery += " A1_GRPVEN           AS CANAL,
	cQuery += " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += " SA3.A3_COD          AS VENDEDOR,
	cQuery += " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += " TA3.A3_COD          AS COORDENADOR,
	cQuery += " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += " SD1.R_E_C_N_O_      AS RECNO,
	cQuery += " (D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM-D1_DIFAL)*-1 AS LIQUIDO_NET
	cQuery += " ,' ' ORIGEM
	cQuery += " ,' ' D2_PEDIDO,' ' D2_ITEMPV, ' ' C5_CODOPOR
	cQuery += " 
	cQuery += " FROM SD1110 SD1 
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SA1110)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '   
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE  
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA   
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SF2110)SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += " AND SF2.F2_DOC = D1_NFORI 
	cQuery += " AND SF2.F2_SERIE = D1_SERIORI 
	cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND SB1.B1_COD = D1_COD
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND TB1.B1_COD = D1_COD
	cQuery += " 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SBM110)SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND SA3.A3_COD = F2_VEND1
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)SX5
	cQuery += " ON SX5.X5_TABELA  = 'A2'              
	cQuery += " AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)TX5
	cQuery += " ON Trim(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)
	cQuery += " 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += " AND SB9.B9_FILIAL = '01'
	cQuery += " AND SB9.B9_COD = SD1.D1_COD
	//cQuery += " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(SD1.D1_DTDIGIT,1,6)
	cQuery += " AND SB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D1_DTDIGIT,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND SB9.B9_LOCAL = '15'
	cQuery += " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SB9110)TB9
	cQuery += " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += " AND TB9.B9_FILIAL = '01'
	cQuery += " AND TB9.B9_COD = SD1.D1_COD
	cQuery += " AND TB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D1_DTDIGIT,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND TB9.B9_LOCAL = '03'
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " WHERE SD1.D_E_L_E_T_ = ' '   
	cQuery += " AND SD1.D1_CF IN ("+GetMV("ST_CFOPDEV",.F.,'1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')+")
	cQuery += " AND SD1.D1_DTDIGIT between  '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"'
	cQuery += " AND SD1.D1_TIPO = 'D'    
	cQuery += " 
	cQuery += " UNION
	cQuery += " 
	cQuery += " SELECT 
	cQuery += " 'AM'                AS EMPRESA,
	cQuery += " 'DEV'               AS MODALIDADE,
	cQuery += " D1_DOC              AS NOTA_FISCAL,
	cQuery += " SUBSTR(D1_DTDIGIT,7,2)||'/'||SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS EMISSAO,
	cQuery += " SUBSTR(D1_DTDIGIT,5,2)||'/'||SUBSTR(D1_DTDIGIT,1,4)          AS MES_ANO,
	cQuery += " D1_QUANT            AS QUANTIDADE,
	cQuery += " D1_COD              AS PRODUTO,
	cQuery += " SB1.B1_DESC             AS DESCRICAO,
	cQuery += " NVL(BM_GRUPO,'S/G') AS GRUPO,
	cQuery += " NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO,
	cQuery += " NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO,  
	cQuery += " A1_GRPVEN           AS GRUPO_VENDAS,
	cQuery += " A1_COD              AS CODIGO,
	cQuery += " A1_LOJA             AS LOJA,
	cQuery += " A1_NOME             AS RAZAO_SOCIAL,
	cQuery += " A1_CGC              AS CNPJ,
	cQuery += " A1_EST              AS ESTADO,
	cQuery += " A1_MUN              AS MUNICIPIO,
	cQuery += " A1_COD_MUN          AS CODIGO_MUNICIPIO,
	cQuery += " A1_XESCALA          AS CATEGORIA,
	cQuery += " A1_GRPVEN           AS CANAL,
	cQuery += " TRIM(SX5.X5_DESCRI) AS REGIAO,
	cQuery += " SA3.A3_COD          AS VENDEDOR,
	cQuery += " SA3.A3_NOME         AS NOME_VENDEDOR,
	cQuery += " TA3.A3_COD          AS COORDENADOR,
	cQuery += " TA3.A3_NOME         AS NOME_COORDENADOR,
	cQuery += " CASE WHEN SB9.B9_CM1 <> 0 THEN ROUND(SB9.B9_CM1,2) ELSE CASE WHEN TB9.B9_CM1 <> 0 THEN ROUND(TB9.B9_CM1,2) ELSE ROUND(SB1.B1_XPCSTK,2)   END END AS CUSTO,
	cQuery += " SD1.R_E_C_N_O_      AS RECNO,
	cQuery += " (D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM-D1_DIFAL)*-1 AS LIQUIDO_NET
	cQuery += " ,' ' ORIGEM
	cQuery += " ,' ' D2_PEDIDO,' ' D2_ITEMPV, ' ' C5_CODOPOR
	cQuery += " 
	cQuery += " FROM UDBP12.SD1030 SD1 
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '   
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE  
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA   
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SF2030)SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += " AND SF2.F2_DOC = D1_NFORI 
	cQuery += " AND SF2.F2_SERIE = D1_SERIORI 
	cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " 
	cQuery += " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND SB1.B1_COD = D1_COD
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += " ON TB1.D_E_L_E_T_ = ' ' 
	cQuery += " AND TB1.B1_COD = D1_COD
	cQuery += " 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SBM110)SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' ' 
	cQuery += " AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND SA3.A3_COD = F2_VEND1
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SA3110)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' ' 
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)SX5
	cQuery += " ON SX5.X5_TABELA  = 'A2'              
	cQuery += " AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SX5110)TX5
	cQuery += " ON Trim(TX5.X5_TABELA)  = 'ZZ'  
	cQuery += " AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP)
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM UDBP12.SB9030)SB9
	cQuery += " ON SB9.D_E_L_E_T_ = ' '             
	cQuery += " AND SB9.B9_FILIAL = '01'
	cQuery += " AND SB9.B9_COD = SD1.D1_COD
	//cQuery += " AND SUBSTR(SB9.B9_DATA,1,6) =  SUBSTR(SD1.D1_DTDIGIT,1,6)
	cQuery += " AND SB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D1_DTDIGIT,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND SB9.B9_LOCAL = '15'
	cQuery += " AND SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F'
	cQuery += " 
	cQuery += " LEFT JOIN(SELECT * FROM SB9110)TB9
	cQuery += " ON TB9.D_E_L_E_T_ = ' '             
	cQuery += " AND TB9.B9_FILIAL = '01'
	cQuery += " AND TB9.B9_COD = SD1.D1_COD
	cQuery += " AND TB9.B9_DATA =  TO_CHAR(LAST_DAY(TO_DATE(D1_DTDIGIT,'YYYYMMDD')),'YYYYMMDD')
	cQuery += " AND TB9.B9_LOCAL = '03'
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " 
	cQuery += " WHERE SD1.D_E_L_E_T_ = ' '   
	cQuery += " AND SD1.D1_CF IN ("+GetMV("ST_CFOPDEV",.F.,'1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')+")
	cQuery += " AND  SD1.D1_FILIAL = '01'  
	cQuery += " AND SD1.D1_DTDIGIT between  '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"'
	cQuery += " AND SD1.D1_TIPO = 'D' "
	MemoWrite("C:\QUERY\RSTFATDC.TXT" , cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


/*====================================================================================\
|Programa  | ImpAnalitico       | Autor | RENATO.OLIVEIRA        | Data | 13/02/2019  |
|=====================================================================================|
|Descrição | Impressão do relatório Comercial                                         |
|          | 14/12/2022 - Adaptado por: Flávia Rocha - Sigamat Consultoria            |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
//-----------------------------------------------------------------------------------//
//14/12/2022 - Alteração realizada mediante ticket #20221214021835
//FR - Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
//para que o arquivo gerado seja menos pesado que o gerado via Treport
//------------------------------------------------------------------------------------//
\====================================================================================*/
STATIC FUNCTION ImpAnalitico(oExcel)

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Analitico")


/*****************************************************
Adiciona uma Worksheet ( Planilha )
FwMsExcelXlsx():AddWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:AddworkSheet("Analitico")

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Analitico")

/*****************************************************
Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
FwMsExcelXlsx():AddTable(< cWorkSheet >, < cTable >, [lPrintHead])-> NIL
*****************************************************/
oExcel:AddTable ("Analitico","Relatorio Analitico")


/************************************************************************************************************************************
FwMsExcelXlsx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, [< nAlign >], [< nFormat >], [< lTotal >], [ < cPicture >])-> lRet
Descrição
Adiciona uma coluna a tabela de uma Worksheet.

Parâmetros
Nome	       Tipo	        Descrição	                                                          Default	  Obrigatório	  Referência
cWorkSheet	 Caracteres	  Nome da planilha	                                                                X	
cTable	     Caracteres	  Nome da planilha	                                                                X	
cColumn      Caracteres	  Titulo da tabela que será adicionada	                                            X	
nAlign       Numérico	    Alinhamento da coluna ( 1-Left,2-Center,3-Right )	                    1	
nFormat      Numérico	    Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	  1	
lTotal	     Lógico	      Indica se a coluna deve ser totalizada	                              .F.	
cPicture	   Caracteres	  Mascara de picture a ser aplicada. Somente para campos numéricos	    ""	
************************************************************************************************************************************/

oExcel:AddColumn("Analitico","Relatorio Analitico","EMPRESA"         	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MODALIDADE"	     	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOTA_FISCAL"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MES_ANO"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QUANTIDADE"      	,3,3,.F.,PesqPict("SC7","C7_QUANT"))
oExcel:AddColumn("Analitico","Relatorio Analitico","PRODUTO"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESCRICAO"		   	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESC_GRUPO"	     	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","AGRUPAMENTO"	   	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO_VENDAS"    	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CODIGO"			    ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LOJA"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","RAZAO_SOCIAL"    	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CNPJ"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ESTADO"			    ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MUNICIPIO"		   	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CODIGO_MUNICIPIO"	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","REGIAO"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","VENDEDOR"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME_VENDEDOR"	 	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COORDENADOR"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME_COORDENADOR"	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CUSTO"				,3,3,.F.,PesqPict("SB9","B9_CM1"))
oExcel:AddColumn("Analitico","Relatorio Analitico","RECNO"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LIQUIDO_NET"		,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","ORIGEM"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PEDIDO"			 	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEMPV"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CODOPOR"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CATEGORIA"       	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CANAL"           	,1,1,.F.,,"")

RETURN oExcel


/*====================================================================================\
|Programa  | PrintAnalit     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |  14/12/2022 - Adaptado por: Flávia Rocha - Sigamat Consultoria           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
//------------------------------------------------------------------------------------//
//14/12/2022 - Alteração realizada mediante ticket #20221214021835
//FR - Flávia Rocha - Sigamat Consultoria, adequar o relatório para a classe FWMSEXCEL
//para que o arquivo gerado seja menos pesado que o gerado via Treport
//------------------------------------------------------------------------------------//
\====================================================================================*/
STATIC FUNCTION PrintAnalit(oExcel)
LOCAL nQtd := 0 
LOCAL aVetor  := {}
LOCAL nTotRec := 0
LOCAL cCanal  :=""
LOCAL cEscala :=""

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
DbSelectArea("SC6")
SC6->(DbSetOrder(1))


//// Pega quantidade de registros a serem gravados
DBSELECTAREA(cAliasLif)
(cAliasLif)->(DBGOTOP())
nTotRec := 0
DbEval({|| nTotRec++  })
PROCREGUA(nTotRec)
(cAliasLif)->(DBGOTOP())

IF  SELECT(cAliasLif) > 0
	WHILE (cAliasLif)->(!EOF())
		
  	    _cCanal  := Posicione("ACY", 1, XFilial("ACY") + (cAliasLif)->CANAL, "ACY_DESCRI")
		_cEscala := Tabela("Z0",(cAliasLif)->CATEGORIA,.F.)

		
		nQtd++
		INCPROC("Carregando informações...."+ALLTRIM(STR(nQtd))+" / "+ALLTRIM(STR(nTotRec)))
		//IF MV_PAR04 <> 2
    	aVetor := {}
		aVetor := {;
    	(cAliasLif)->EMPRESA,;
		(cAliasLif)->MODALIDADE,;
		(cAliasLif)->NOTA_FISCAL,;
		(cAliasLif)->EMISSAO,;
		(cAliasLif)->MES_ANO,;
		(cAliasLif)->QUANTIDADE,;
		(cAliasLif)->PRODUTO,;
		(cAliasLif)->DESCRICAO,;
		(cAliasLif)->GRUPO,;
		(cAliasLif)->DESC_GRUPO,;
		(cAliasLif)->AGRUPAMENTO,;
		(cAliasLif)->GRUPO_VENDAS,;
		(cAliasLif)->CODIGO,;
		(cAliasLif)->LOJA,;
		(cAliasLif)->RAZAO_SOCIAL,;
		(cAliasLif)->CNPJ,;
		(cAliasLif)->ESTADO,;
		(cAliasLif)->MUNICIPIO,;
		(cAliasLif)->CODIGO_MUNICIPIO,;
		(cAliasLif)->REGIAO,;
		(cAliasLif)->VENDEDOR,;
		(cAliasLif)->NOME_VENDEDOR,;
		(cAliasLif)->COORDENADOR,;
		(cAliasLif)->NOME_COORDENADOR,;
		(cAliasLif)->CUSTO,;
		(cAliasLif)->RECNO,;
		(cAliasLif)->LIQUIDO_NET,;			
		(cAliasLif)->ORIGEM,;
		(cAliasLif)->D2_PEDIDO,;
		(cAliasLif)->D2_ITEMPV,;
		(cAliasLif)->C5_CODOPOR,;
        ALLTRIM((cAliasLif)->CATEGORIA)+'-'+ALLTRIM(_cEscala),;
        ALLTRIM((cAliasLif)->CANAL)+'-'+ALLTRIM(_cCanal);
      }  			
	
      	oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

		(cAliasLif)->(DBSKIP())
	EndDo

ENDIF

RETURN oExcel
