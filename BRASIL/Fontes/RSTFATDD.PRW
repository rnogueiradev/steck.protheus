#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Tbiconn.ch"

/*====================================================================================\
|Programa  | RSTFATDD       | Autor | Flávia Rocha           | Data |     23/12/2022  |
|=====================================================================================|
|Descrição | Relatório de faturamento comercial										  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
\====================================================================================*/
USER FUNCTION RSTFATDD(aParam)

	Local lFora    := .F.
	Local cCdEmp   := ""  
	Local cCdFil   := ""
	Private cPerg 			:= "RFATDD"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private _lTela 			:= .F.
	
	DEFAULT aParam := {"11", "01"}

	If Select("SX2") == 0

		cCdEmp := aParam[01]
		cCdFil := aParam[02]

		RpcSetType( 3 )		
		RpcSetEnv( cCdEmp, cCdFil,,,"FAT") 
		lFora := .T.
	Else 
		cCdEmp := SM0->M0_CODIGO
		cCdFil := SM0->M0_CODFIL
	Endif 
	

	U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	If IsBlind()
		_lTela := .F.
	Else
		_lTela := .T.
	EndIf

	If _lTela
		Pergunte(cPerg,.T.)
	Else
		Pergunte(cPerg,.F.)
	EndIf

	If IsBlind()
		//MV_PAR01 := CTOD("01/07/2022") //FirstDate(dDatabase)  //retorna o primeiro dia do mês
		MV_PAR01 := FirstDate(dDatabase)  //retorna o primeiro dia do mês
		MV_PAR02 := dDatabase
	EndIf

	//oReport		:= ReportDef()	//FR - 14/12/2022 - mudar Classe Treport para Classe FwMSExcel	
	oExcel := ImpAnalitico(oExcel)
	If !IsBlind()  //dentro do Protheus

		PROCESSA({|| StQuery() },"Compondo Relatorio") 
		PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

		If !ExistDir("c:\arquivos_protheus\")
			MakeDir("c:\arquivos_protheus\")
		Endif 

		_cArq := 'rstfadd.xlsx'
		//cPasta := "\arquivos\dpo\"
		cPasta := "C:\arquivos_protheus\"		//teste RETIRAR
		//FErase(cPasta)  
		oExcel:Activate()
		oExcel:GetXMLFile( cPasta + _cArq )
		oExcel:DeActivate()
			INCPROC("Gerando Planilha Excel....")
		oOpnArq:= MsExcel():New()
		oOpnArq:WorkBooks:Open( cPasta + _cArq)
		oOpnArq:SetVisible(.T.)
		//oOpnArq:Destroy()

	Else //via job
		StQuery()
		oExcel := PrintAnalit(oExcel)

		If !ExistDir("\arquivos\dpo\")
			MakeDir("\arquivos\dpo\")
		Endif

		nMes  := Month(dDatabase)
		cMes  := UPPER(MesExtenso(nMes))
		_cArq := 'DPO_Dia_' + Substr(DtoS(dDatabase),7,2) + "_Mes_" + Substr(cMes,1,3) + "_Emp_" + cCdEmp+ '.xlsx'  //Exemplo, emissão em 05/12/2022 empresa 11 -> DPO_05DEZ11.xlsx
		
		cPasta := "\arquivos\dpo\"
		//cPasta := "C:\arquivos_protheus\"+_cArq		//teste RETIRAR
		//FErase(cPasta)
		oExcel:Activate()
		oExcel:GetXMLFile( cPasta + _cArq )
		oExcel:DeActivate()

		_cEmail   := GetNewPar("RSTFATDD" , "bruno.reichenbach@steck.com.br;leandro.godoy@steck.com.br")
		//_cEmail   += ";flah.rocha@sigamat.com.br;leandro.godoy@steck.com.br"  //FR RETIRAR
		_cCopia := "" 
		_cAssunto := "DPO - " + Dtoc(dDatabase) 
		cMsg      := "Arquivo DPO gerado do período: " + Dtoc(MV_PAR01) + " até " + Dtoc( MV_PAR02) 		
		_aAttach := {}
		aadd( _aAttach  , _cArq)		
		_cCaminho := cPasta			//somente o caminho do arquivo
		cAnexo    := cPasta + _cArq	//caminho do arquivo + arquivo		
		lEnviou   := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		//para testes 
		/*		
		cAnexo    := cPasta + _cArq
		lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar			
		*/
		//para testes		

	Endif 
		
	If lFora 
		ConOut(CRLF + "[RSTFADD]["+ FWTimeStamp(2) +"] Fim do processamento.")
		Reset Environment 
	Endif 	

Return


/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |Adaptado por Flávia Rocha - Sigamat Consultoria                           |
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
Local _aEmpStk   := {}
Local _cEmpStk   := ""
Local _nX        := 0

_aEmpStk := StrTokArr(GetMv("STDPOCLIST",,"018545#019381#000268#015709#021799#023024#070878#014953#005866#005764"),"#")
	For _nX := 1 To Len(_aEmpStk)
		_cEmpStk += "'" + AllTrim(_aEmpStk[_nX]) + "'"
		If !(_nX == Len(_aEmpStk))
			_cEmpStk += ","
		EndIf
	Next
	/*
	SELECT D1_FILIAL  FILIAL, D1_COD PRODUTO, D1_PEDIDO PEDIDO, D1_ITEMPC ITEM_PEDIDO, D1_ITEM ITEM_NF, D1_DOC NF, D1_SERIE SERIE, F1_FORNECE COD_FORNECEDOR, F1_LOJA LOJA, A2_NOME, F1_COND COND_NF, E41.E4_DESCRI COND_PAGTO_NF, F1_DUPL TIT_FIN, E2_VALOR  VALOR_TIT, 
	TO_DATE(F1_EMISSAO,'YYYYMMDD') EMISSAO_NF,
	TO_DATE(C7_EMISSAO,'YYYYMMDD') EMISSAO_PC, 
	TO_DATE(F1_DTDIGIT, 'YYYYMMDD') DT_ENTRADA_NF,  
	C7_COND COND_PEDIDO, E42.E4_DESCRI  CONDICAO_PEDIDO, F1_STATUS STATUS_NF, 
	TO_DATE(E2_VENCREA,'YYYYMMDD')  VENCIMENTO_FIN, E2_PARCELA,
	TO_DATE(e2_venCREA,'YYYYMMDD')-TO_DATE(F1_EMISSAO,'YYYYMMDD') AS DIAS_FIN
	FROM SD1110
	INNER JOIN SF1110 ON (D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SD1110.D_E_L_E_T_ = SF1110.D_E_L_E_T_)
	INNER JOIN SA2110 ON (F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SF1110.D_E_L_E_T_ = SA2110.D_E_L_E_T_)
	LEFT JOIN SE4110 E41 ON (F1_COND = E41.E4_CODIGO AND E41.D_E_L_E_T_ = SF1110.D_E_L_E_T_)
	LEFT JOIN SC7110 ON (C7_FILIAL = F1_FILIAL AND C7_PRODUTO = D1_COD AND C7_FORNECE = F1_FORNECE AND C7_LOJA = F1_LOJA AND SC7110.D_E_L_E_T_ = SF1110.D_E_L_E_T_ AND C7_ITEM = D1_ITEMPC AND C7_NUM = D1_PEDIDO)
	LEFT JOIN SE4110 E42 ON (C7_COND = E42.E4_CODIGO AND E42.D_E_L_E_T_ = SF1110.D_E_L_E_T_)
	LEFT JOIN SE2110 ON (E2_NUM = D1_DOC AND E2_FILIAL = D1_FILIAL AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA AND SD1110.D_E_L_E_T_ = SE2110.D_E_L_E_T_ AND (E2_PARCELA LIKE '% %' OR E2_PARCELA = 'AAA' OR E2_PARCELA = '001'))
	WHERE SD1110.D_E_L_E_T_ <> '*'
	AND D1_EMISSAO >= '20221201'
	AND F1_DTDIGIT <= '20221205'
	--AND E2_VENCTO > TO_CHAR(SYSDATE,'YYYYMMDD')
	AND F1_STATUS = 'A' --NF CLASSIFICADAS
	AND F1_FORNECE NOT IN ('018545','019381','000268','015709','021799','023024','070878','014953','005866','005764')  --INTERCOMPANY
	--AND D1_TES NOT IN ('038','022','409') -- RETORNO BENEFICIAMENTO, RET. SEM INDL.    , AM.GRATIS /IPI      
	AND D1_TES NOT IN (SELECT F4_CODIGO FROM SF4110 WHERE F4_DUPLIC = 'N')
	--AND D1_FILIAL = '01'
	AND F1_ESPECIE <> 'CTE'  --EXCLUIDOS OS FRETES
	AND F1_TIPO <> 'D' -- EXCLUIDOS DEVOLUCAO
	AND F1_SERIE = E2_PREFIXO
	--AND D1_FORNECE IN ('000693','000183','010454')
	ORDER BY 21

	*/

cQuery += " SELECT D1_FILIAL  FILIAL, D1_COD PRODUTO, D1_PEDIDO PEDIDO, D1_ITEMPC ITEM_PEDIDO, D1_ITEM ITEM_NF, "+CRLF
cQuery += " D1_DOC NF, D1_SERIE SERIE, F1_FORNECE COD_FORNECEDOR, F1_LOJA LOJA, A2_NOME, F1_COND COND_NF, " + CRLF
cQuery += " E41.E4_DESCRI COND_PAGTO_NF, F1_DUPL TIT_FIN, E2_VALOR  VALOR_TIT, " + CRLF
cQuery += " TO_DATE(F1_EMISSAO,'YYYYMMDD') EMISSAO_NF, "+ CRLF
cQuery += " TO_DATE(C7_EMISSAO,'YYYYMMDD') EMISSAO_PC,  "+CRLF
cQuery += " TO_DATE(F1_DTDIGIT, 'YYYYMMDD') DT_ENTRADA_NF,   "+CRLF
cQuery += " C7_COND COND_PEDIDO, E42.E4_DESCRI  CONDICAO_PEDIDO, F1_STATUS STATUS_NF,  "+CRLF
cQuery += " TO_DATE(E2_VENCREA,'YYYYMMDD')  VENCIMENTO_FIN, E2_PARCELA, "+CRLF
cQuery += " TO_DATE(e2_venCREA,'YYYYMMDD')-TO_DATE(F1_EMISSAO,'YYYYMMDD') AS DIAS_FIN "+CRLF + CRLF 

cQuery += " FROM " + RetSqlName("SD1") + " SD1 "+CRLF

cQuery += " INNER JOIN "+ RetSqlName("SF1") + " SF1  ON (D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE " + CRLF 
cQuery += "    AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_) "+CRLF

cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON (F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SF1.D_E_L_E_T_ = SA2.D_E_L_E_T_) "+CRLF

cQuery += " LEFT JOIN " + RetSqlName("SE4") + " E41 ON (F1_COND = E41.E4_CODIGO AND E41.D_E_L_E_T_ = SF1.D_E_L_E_T_) "+ CRLF + CRLF

cQuery += " LEFT JOIN " + RetSqlName("SC7") + " SC7 ON (C7_FILIAL = F1_FILIAL AND C7_PRODUTO = D1_COD AND C7_FORNECE = F1_FORNECE " + CRLF 
cQuery += "   AND C7_LOJA = F1_LOJA AND SC7.D_E_L_E_T_ = SF1.D_E_L_E_T_ AND C7_ITEM = D1_ITEMPC AND C7_NUM = D1_PEDIDO) "+CRLF + CRLF 

cQuery += " LEFT JOIN " + RetSqlName("SE4") + "  E42 ON (C7_COND = E42.E4_CODIGO AND E42.D_E_L_E_T_ = SF1.D_E_L_E_T_) "+CRLF + CRLF 

cQuery += " LEFT JOIN " + RetSqlName("SE2") +"  SE2 ON (E2_NUM = D1_DOC AND E2_FILIAL = D1_FILIAL AND E2_FORNECE = D1_FORNECE " + CRLF 
cQuery += "   AND E2_LOJA = D1_LOJA AND SD1.D_E_L_E_T_ = SE2.D_E_L_E_T_ AND (E2_PARCELA LIKE '% %' OR E2_PARCELA = 'AAA' OR E2_PARCELA = '001')) "+CRLF
cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "+CRLF
cQuery += " AND D1_EMISSAO >= '" + Dtos(MV_PAR01) + "' "+CRLF
cQuery += " AND F1_DTDIGIT <= '" + Dtos(MV_PAR02) + "' "+CRLF

//--AND E2_VENCTO > TO_CHAR(SYSDATE,'YYYYMMDD')
cQuery += " AND F1_STATUS = 'A'  "+CRLF  //--NF CLASSIFICADAS

//cQuery += " AND F1_FORNECE NOT IN ('018545','019381','000268','015709','021799','023024','070878','014953','005866','005764')  "+CRLF //  --INTERCOMPANY
cQuery += " 	AND F1_FORNECE NOT IN (" + _cEmpStk + ") " + CRLF  //INTERCOMPANY

//--AND D1_TES NOT IN ('038','022','409') -- RETORNO BENEFICIAMENTO, RET. SEM INDL.    , AM.GRATIS /IPI      
cQuery += " AND D1_TES NOT IN (SELECT F4_CODIGO FROM SF4110 WHERE F4_DUPLIC = 'N') "+CRLF

//--AND D1_FILIAL = '01'
cQuery += " AND F1_ESPECIE <> 'CTE'  "+CRLF  // --EXCLUIDOS OS FRETES
cQuery += " AND F1_TIPO <> 'D'  "+CRLF //-- EXCLUIDOS DEVOLUCAO
cQuery += " AND F1_SERIE = E2_PREFIXO "+CRLF
//--AND D1_FORNECE IN ('000693','000183','010454')
cQuery += " ORDER BY 21 "+CRLF

MemoWrite("C:\QUERY\RSTFATDD.TXT" , cQuery)

cQuery := ChangeQuery(cQuery)

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

oExcel := FwMsExcelXlsx():New()

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

oExcel:AddColumn("Analitico","Relatorio Analitico","FILIAL"         	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PRODUTO"	     	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PEDIDO"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEM_PEDIDO"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEM_NF"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NF"					,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","SERIE"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COD_FORNECEDOR"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LOJA"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","A2_NOME"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COND_NF"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COND_PAGTO_NF"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","TIT_FIN"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","VALOR_TIT"			,3,3,.F.,PesqPict("SF1","F1_VALBRUT"))
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO_NF"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO_PC"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DT_ENTRADA_NF"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COND_PEDIDO"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CONDICAO_PEDIDO"	,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","STATUS_NF"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","VENCIMENTO_FIN"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","E2_PARCELA"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DIAS_FIN"     	 	,3,3,.F.,PesqPict("SE4","E4_ACRSFIN"))

/*
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
*/
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
		nQtd++
		INCPROC("Carregando informações...."+ALLTRIM(STR(nQtd))+" / "+ALLTRIM(STR(nTotRec)))
		//IF MV_PAR04 <> 2
    	aVetor := {}

		aVetor := {;
		(cAliasLif)->FILIAL,;           	  
		(cAliasLif)->PRODUTO,;  	     	  
		(cAliasLif)->PEDIDO,;           	    				  
		(cAliasLif)->ITEM_PEDIDO,;           	    		  
		(cAliasLif)->ITEM_NF,;           	    			  
		(cAliasLif)->NF,;           	    					  
		(cAliasLif)->SERIE,;           	    				  
		(cAliasLif)->COD_FORNECEDOR,;           	    		  
		(cAliasLif)->LOJA,;           	    				  
		(cAliasLif)->A2_NOME,;           	    			  
		(cAliasLif)->COND_NF,;           	    			  
		(cAliasLif)->COND_PAGTO_NF,;           	    		  
		(cAliasLif)->TIT_FIN,;           	    			  
		(cAliasLif)->VALOR_TIT,;           	    			
		(cAliasLif)->EMISSAO_NF,;           	    			  
		(cAliasLif)->EMISSAO_PC,;           	    			  
		(cAliasLif)->DT_ENTRADA_NF,;           	    		  
		(cAliasLif)->COND_PEDIDO,;           	    		  
		(cAliasLif)->CONDICAO_PEDIDO,;           	    	  
		(cAliasLif)->STATUS_NF,;           	    			  
		(cAliasLif)->VENCIMENTO_FIN,;           	    			  
		(cAliasLif)->E2_PARCELA,;           	    			  
		(cAliasLif)->DIAS_FIN;
		}

		/*
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
		(cAliasLif)->D2_ITEMPV;
		 }  			
		 */
	
      	oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

		(cAliasLif)->(DBSKIP())
	EndDo

ENDIF

RETURN oExcel

//FUNÇÃO PARA TESTES APENAS
/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
//FUNÇÃO FR PARA TESTES

Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )



