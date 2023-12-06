#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATDF        | Autor | ANTONIO.CORDEIRO          | Data | 17/01/2022  |
|=====================================================================================|
|Descrição | Relatório de posição pedidos    										  |
|          | 04/07/2023 - Adaptado por: Antonio Cordeiro - Consultoria Triyo          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATDF(oExcel)

	//Local   oReport
	Local cDirTemp    := ""
	Private cPerg 			:= "RFATDF"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private _lTela 			:= .F.
	Default oExcel := FwMsExcelXlsx():New()
    
	U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data Ate:"		   			,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	If IsInCallStack("U_STFAT571")
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

	If IsInCallStack("U_STFAT571")
		MV_PAR01 := GetMv("RSTFATDF01",,CTOD("05/07/2023"))
		MV_PAR02 := dDatabase
	EndIf

	//oReport		:= ReportDef()	//FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
	oExcel := ImpAnalitico(oExcel)
	PROCESSA({|| StQuery() },"Compondo Relatorio") 
	PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

	If IsInCallStack("U_STFAT571")
		_cArq := 'pedidos.xlsx'
		cPasta := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"+_cArq
		//cPasta := "c:\temp\"+_cArq
		FErase(cPasta)
		oExcel:Activate()
		oExcel:GetXMLFile( cPasta )
		oExcel:DeActivate()
	Else
		_cArq := 'pedidos.xlsx'
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

    cQuery := " SELECT * "
    cQuery += " FROM (SELECT C5_NUM,C6_ITEM,A1_COD,A1_LOJA,A1_NOME,A1_CGC,C5_EMISSAO,SB1110.B1_COD, "
    cQuery += " SB1110.B1_DESC,SB1110.B1_GRUPO,BM_XAGRUP,X5_DESCRI,BM_GRUPO,BM_DESC,Z92_DSCGRP,Z93_DSCGRP, "
    cQuery += " SB1110.B1_XMTO,( CASE "
    cQuery += " WHEN SB1030.B1_CLAPROD = 'F' THEN 'FAB_AM' "
    cQuery += " WHEN SB1010.B1_CLAPROD = 'F' THEN 'FAB_GUA' "
    cQuery += " WHEN SB1110.B1_CLAPROD = 'I' THEN 'IMPORTADO' "
    cQuery += " END ) ORIGEM,C6_QTDVEN QTD_PEDIDO,C6_BLQ,C6_QTDVEN - C6_QTDENT SALDO,C6_ZVALLIQ, "
    cQuery += " CB8_QTDORI QTD_SEPARADA,CB8_XDTINI DT_SEPARADA,SUM(D2_QUANT) QTD_FATURADA, "
    cQuery += " Max(D2_EMISSAO) DATA_FATURAMENTO,Max(D2_DOC) DOC "
    cQuery += " FROM SC5110 C5 "
    cQuery += " LEFT JOIN SC6110 C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN (SELECT CB8_FILIAL,CB8_PEDIDO,CB8_ITEM,CB8_PROD,SUM(CB8_QTDORI) CB8_QTDORI, "
    cQuery += " Max(CB8_XDTINI) CB8_XDTINI FROM CB8110 "
    cQuery += " WHERE D_E_L_E_T_ = ' ' "
    cQuery += " GROUP BY CB8_FILIAL,CB8_PEDIDO,CB8_ITEM,CB8_PROD ) CB8 "
    cQuery += " ON CB8_FILIAL = C6_FILIAL AND CB8_PEDIDO = C6_NUM AND CB8_ITEM = C6_ITEM "
    cQuery += " LEFT JOIN (SELECT D2_FILIAL, D2_PEDIDO,D2_ITEMPV,D2_CLIENTE,D2_LOJA,SUM(D2_QUANT) D2_QUANT,MAX(D2_EMISSAO) D2_EMISSAO,MAX(D2_DOC) D2_DOC "
    cQuery += " FROM SD2110 WHERE D_E_L_E_T_=' ' GROUP BY D2_FILIAL, D2_PEDIDO,D2_ITEMPV,D2_CLIENTE,D2_LOJA) D2 "
    cQuery += " ON D2_FILIAL = CB8_FILIAL  AND D2_PEDIDO = CB8_PEDIDO AND D2_ITEMPV = CB8_ITEM "
    cQuery += " AND D2_CLIENTE = C5_CLIENTE AND D2_LOJA = C5_LOJACLI "
    cQuery += " LEFT JOIN SB1110 SB1110 "
    cQuery += " ON SB1110.B1_COD = C6_PRODUTO "
    cQuery += " AND SB1110.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN UDBP12.SB1030 SB1030 "
    cQuery += " ON SB1030.B1_COD = C6_PRODUTO "
    cQuery += " AND SB1030.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN UDBP12.SB1010 SB1010 "
    cQuery += " ON SB1010.B1_COD = C6_PRODUTO "
    cQuery += " AND SB1010.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN SBM110 BM "
    cQuery += " ON BM_GRUPO = SB1110.B1_GRUPO "
    cQuery += " AND BM.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN Z92110 Z92 "
    cQuery += " ON Z92_CODGRP = BM_XAGRUP2 "
    cQuery += " AND Z92.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN Z93110 Z93 "
    cQuery += " ON Z93_CODGRP = BM_XAGRUP3 "
    cQuery += " AND Z92.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN SX5110 X5 "
    cQuery += " ON X5_TABELA = 'ZZ' "
    cQuery += " AND X5_CHAVE = BM_XAGRUP "
    cQuery += " AND X5.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN SA1110 A1 "
    cQuery += " ON A1_COD = C5_CLIENTE "
    cQuery += " AND A1_LOJA = C5_LOJACLI "
    cQuery += " AND A1.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE C5.D_E_L_E_T_ = ' ' "
    cQuery += " AND C5_EMISSAO >= '"+DTOS(MV_PAR01)+"' "
    cQuery += " AND C5_EMISSAO <= '"+DTOS(MV_PAR02)+"' "	
    cQuery += " AND ( ( C6_BLQ = ' ' ) "
    cQuery += " OR ( C6_BLQ <> ' ' "
    cQuery += " AND C6_QTDVEN > 0 ) ) "
    cQuery += " GROUP BY C5_NUM, "
    cQuery += " C6_ITEM,A1_COD,A1_LOJA,A1_NOME,A1_CGC,C5_EMISSAO,SB1110.B1_COD,SB1110.B1_DESC,SB1110.B1_GRUPO, "
    cQuery += " BM_XAGRUP,X5_DESCRI,BM_GRUPO,BM_DESC,Z92_DSCGRP,Z93_DSCGRP,SB1110.B1_XMTO, "
    cQuery += " ( CASE "
    cQuery += " WHEN SB1030.B1_CLAPROD = 'F' THEN 'FAB_AM' "
    cQuery += " WHEN SB1010.B1_CLAPROD = 'F' THEN 'FAB_GUA' "
    cQuery += " WHEN SB1110.B1_CLAPROD = 'I' THEN 'IMPORTADO' "
    cQuery += " END ), "
    cQuery += " C6_QTDVEN, "
    cQuery += " C6_BLQ, "
    cQuery += " C6_QTDVEN - C6_QTDENT, "
    cQuery += " C6_ZVALLIQ, "
    cQuery += " CB8_QTDORI, "
    cQuery += " CB8_XDTINI) XXX "
    //cQuery += " WHERE C5_NUM = '000006' "
	cQuery += " ORDER BY C5_NUM, "
    cQuery += " C6_ITEM "

	MemoWrite("C:\QUERY\RSTFATDF.TXT" , cQuery)
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
DBSELECTAREA('SC6')
DBSELECTAREA('CB8')

oExcel:AddColumn("Analitico","Relatorio Analitico","PEDIDO"         ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEM"            ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CLIENTE"         ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LOJA"            ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME"            ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CNPJ"            ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO"         ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COD.PRODUTO"     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESCRIÇÃO"       ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO"           ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","AGRUPAMENTO"     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESCRIÇÃO"       ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO"           ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESCRIÇÃO"       ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO NÍVEL 2"   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO NÍVEL 3"   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MTO/MTS"         ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ORIGEM"          ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QTD PEDIDO"      ,3,3,.F.,PesqPict("SC6","C6_QTDVEN"))
oExcel:AddColumn("Analitico","Relatorio Analitico","STATUS BLQ."     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QTD PENDENTE"    ,3,3,.F.,PesqPict("SC6","C6_QTDVEN"))
oExcel:AddColumn("Analitico","Relatorio Analitico","VLR LIQUIDO"     ,3,3,.F.,PesqPict("SC6","C6_QTDVEN"))
oExcel:AddColumn("Analitico","Relatorio Analitico","QTD_SEPARADA"    ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DT_SEPARADA"     ,3,3,.F.,PesqPict("CB8","CB8_QTDORI"))
oExcel:AddColumn("Analitico","Relatorio Analitico","QTD_FATURADA"    ,3,3,.F.,PesqPict("SC6","C6_QTDVEN"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DT FATURAMENTO"  ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DOC"             ,1,1,.F.,,"")
//oExcel:AddColumn("Analitico","Relatorio Analitico","CAMPO27"         ,1,1,.F.,,"")


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


//// Pega quantidade de registros a serem gravados
DBSELECTAREA(cAliasLif)
(cAliasLif)->(DBGOTOP())
nTotRec := 0
DbEval({|| nTotRec++  })
PROCREGUA(nTotRec)
(cAliasLif)->(DBGOTOP())

IF  SELECT(cAliasLif) > 0
	WHILE (cAliasLif)->(!EOF())
		
		nQtd++
		INCPROC("Carregando informações...."+ALLTRIM(STR(nQtd))+" / "+ALLTRIM(STR(nTotRec)))
    	aVetor := {}
		aVetor := {;
    	(cAliasLif)->C5_NUM,;
    	(cAliasLif)->C6_ITEM,;
    	(cAliasLif)->A1_COD,;
    	(cAliasLif)->A1_LOJA,;
    	(cAliasLif)->A1_NOME,;
    	(cAliasLif)->A1_CGC,;
    	DTOC(STOD((cAliasLif)->C5_EMISSAO)),;
    	(cAliasLif)->B1_COD,;
    	(cAliasLif)->B1_DESC,;
    	(cAliasLif)->B1_GRUPO,;
    	(cAliasLif)->BM_XAGRUP,;
		(cAliasLif)->X5_DESCRI,;
    	(cAliasLif)->BM_GRUPO,;
    	(cAliasLif)->BM_DESC,;
    	(cAliasLif)->Z92_DSCGRP,;
    	(cAliasLif)->Z93_DSCGRP,;
    	(cAliasLif)->B1_XMTO,;
    	(cAliasLif)->ORIGEM,;
		(cAliasLif)->QTD_PEDIDO,;
    	(cAliasLif)->C6_BLQ,;
    	(cAliasLif)->SALDO,;
    	(cAliasLif)->C6_ZVALLIQ,;
    	(cAliasLif)->QTD_SEPARADA,;
    	DTOC(STOD(((cAliasLif)->DT_SEPARADA))),;
    	(cAliasLif)->QTD_FATURADA,;
    	DTOC(STOD(((cAliasLif)->DATA_FATURAMENTO))),;
		(cAliasLif)->DOC;
		 }  			
	
      	oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

		(cAliasLif)->(DBSKIP())
	EndDo

ENDIF

RETURN oExcel
