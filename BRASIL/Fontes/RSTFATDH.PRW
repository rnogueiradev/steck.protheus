#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | RSTFATDH        | Autor | RENATO.OLIVEIRA           | Data | 17/01/2022  |
|=====================================================================================|
|Descrição | Relatório de captação comercial (NOVO)	   							      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

USER FUNCTION RSTFATDH(oExcel)
LOCAL _cArq := ""
Local cDirTemp    := ""
PRIVATE cPerg 		:= "RFATDB"
PRIVATE cTime     := Time()
PRIVATE cHora     := SUBSTR(cTime, 1, 2)
PRIVATE cMinutos  := SUBSTR(cTime, 4, 2)
PRIVATE cSegundos := SUBSTR(cTime, 7, 2)
PRIVATE cAliasLIF := cPerg+cHora+ cMinutos+cSegundos
PRIVATE cPergTit 	:= cAliasLif
PRIVATE _lTela 		:= .F.

Default oExcel := FwMsExcelXlsx():New()

oOpnArq := NIL
U_STPutSx1( cPerg, "01","Data de: ","MV_PAR01","mv_ch1","D",08,0,"G",  ,"","@!")
U_STPutSx1( cPerg, "02","Data ate:","MV_PAR02","mv_ch2","D",08,0,"G",  ,"","@!")
U_STPutSx1( cPerg, "03","Status:  ","MV_PAR03","mv_ch3","N",01,0,"C","","","","Somente abertos","Completo"	)
U_STPutSx1( cPerg, "04","Tipo:    ","MV_PAR04","mv_ch4","N",01,0,"C","","","","Somente comercial","Completo"	)
U_STPutSx1( cPerg, "05","Lay-Out: ","MV_PAR05","MV_CH5","N",01,0,"C","","","","Analítico","Sintético"	)

IF IsInCallStack("U_STFAT551") 
	_lTela := .F.
ELSE
	_lTela := .T.
ENDIF

IF _lTela
	IF ! Pergunte(cPerg,.T.)
	   Return()
	Endif   
ELSE
	Pergunte(cPerg,.F.)
ENDIF

IF IsInCallStack("U_STFAT551")
	MV_PAR01 := CTOD("07/08/2023") //CTOD("01/09/2023")
	MV_PAR02 := CTOD("07/08/2023") 
	MV_PAR03 := 1
	MV_PAR04 := 2
	MV_PAR05 := 1
ENDIF

/**********************************
Imprime o relatório Analítico 
**********************************/
IF MV_PAR05 = 1

	oExcel := ImpAnalitico(oExcel)
    PROCESSA({|| U_QRY_FATDH() },"Compondo Relatorio")
	PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

/**********************************
Imprime o relatório Sintético
**********************************/
ELSEIF MV_PAR05 = 2
   oExcel := ImpSintetico(oExcel)
   PROCESSA({|| U_QRY_FATDH() },"Compondo Relatorio")
   PROCESSA({|| oExcel := PrintSinte(oExcel) },"Aguarde", "Carregando informações...")
ENDIF

IF IsInCallStack("U_STFAT551")


   _cArq := 'rstfadh.xlsx'
   cDirTemp    := GetTempPath()
   cPasta := cDirTemp
   oExcel:Activate()
   Processa({|| oExcel:GetXMLFile( cPasta + _cArq) },"Aguarde", "Montando a Planilha...")
   oExcel:DeActivate()
   Sleep(5000)
   ShellExecute("OPEN",_cArq,"",cPasta,1)


   /*/
   _cArq := 'captacao_aberto.xlsx'
   cPasta := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"+_cArq // VOLTAR 
   FErase(cPasta)
   oExcel:Activate()
   oExcel:GetXMLFile( cPasta )
   oExcel:DeActivate()
   /*/

ELSE
   _cArq := 'rstfadh.xlsx'
   cDirTemp    := GetTempPath()
   cPasta := cDirTemp
   oExcel:Activate()
   Processa({|| oExcel:GetXMLFile( cPasta + _cArq) },"Aguarde", "Montando a Planilha...")
   oExcel:DeActivate()
   Sleep(5000)
   ShellExecute("OPEN",_cArq,"",cPasta,1)
   /*/
   _cArq := 'rstfadh.xlsx'
   cPasta := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"+_cArq
   FErase(cPasta)
   oExcel:Activate()
   oExcel:GetXMLFile( cPasta )
   oExcel:DeActivate()
   INCPROC("Gerando Planilha Excel....")
   oOpnArq:= MsExcel():New()
   oOpnArq:WorkBooks:Open( cPasta )
   oOpnArq:SetVisible(.T.)
   oOpnArq:Destroy()
   /*/
ENDIF

RETURN _cArq

/*====================================================================================\
|Programa  | ImpAnalitico       | Autor | RENATO.OLIVEIRA        | Data | 13/02/2019  |
|=====================================================================================|
|Descrição | Impressão do relatório Modelo Analítico                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                      |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
STATIC FUNCTION ImpAnalitico(oExcel)

//oExcel := FwMsExcelXlsx():New()

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

oExcel:AddColumn("Analitico","Relatorio Analitico","EMPRESA"         ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MODALIDADE"	     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NUMERO"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEMPV"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PV_IND"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PED_COM"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ORIGEM"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO"			   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MES_ANO"			   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QUANTIDADE"      ,3,3,.F.,PesqPict("SC7","C7_QUANT"))
oExcel:AddColumn("Analitico","Relatorio Analitico","PRODUTO"			   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESCRICAO"		   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","BLOQUEIO_IND"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CAPTACAO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MOV ESTOQUE"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GERA FINANCEIRO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO"				   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESC_GRUPO"	     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","AGRUPAMENTO"	   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","GRUPO_VENDAS"    ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CODIGO"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LOJA"				     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","RAZAO_SOCIAL"    ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CNPJ"				     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","ESTADO"			     ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MUNICIPIO"		   ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CODIGO_MUNICIPIO",1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","REGIAO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","VENDEDOR"				 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME_VENDEDOR"	 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COORDENADOR"		 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME_COORDENADOR",1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","CUSTO"					 ,3,3,.F.,PesqPict("SB9","B9_CM1"))
oExcel:AddColumn("Analitico","Relatorio Analitico","RECNO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LIQUIDO"				 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","QTDFALTA"				 ,3,3,.F.,PesqPict("PA1","PA1_QUANT" ))
oExcel:AddColumn("Analitico","Relatorio Analitico","VLRFALTA"				 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","QTDRES"				   ,3,3,.F.,PesqPict("PA2","PA2_QUANT" ))
oExcel:AddColumn("Analitico","Relatorio Analitico","VLRRES"					 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","ORIGEM"					 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","FINANCEIRO"			 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","TIPO"						 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","BLOQUEIOS"			 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DTFAT"			 ,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LIQNF"			 ,1,1,.F.,,"")
	
IF MV_PAR04 == 2
	oExcel:AddColumn("Analitico","Relatorio Analitico","CLASPROD"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","SALDO"						 ,3,3,.F.,PesqPict("SB2","B2_QATU"))
	oExcel:AddColumn("Analitico","Relatorio Analitico","TPPROD"						 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DT ENT 1"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DT ENT 2"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DT PROG"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","ORDEM SC5"						 ,1,1,.F.,,"")
//	oExcel:AddColumn("Analitico","Relatorio Analitico","ORDEM SC6"						 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","NUM PED COM CLI"	 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","ITEM PED COM CLI"	 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","QTD VEN"					 ,3,3,.F.,PesqPict("SC6","C6_QTDVEN" ))
	oExcel:AddColumn("Analitico","Relatorio Analitico","QTD ENT"					 ,3,3,.F.,PesqPict("SC6","C6_QTDENT" ))
	oExcel:AddColumn("Analitico","Relatorio Analitico","OBS"				    	 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","TRANSP"						 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","FAT MIN"					 ,3,3,.F.,PesqPict("SC5","C5_XBLQFMI"))
	oExcel:AddColumn("Analitico","Relatorio Analitico","OS"				    		 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DE"								 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","ATE"							 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","A CLASSIFICAR"		 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","ALERTA FATURAMENTO",1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","OPERACAO"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","MTO"							 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","LEAD TIME"						 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","CONDPAG"						 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","QTD EMPENHO"			 ,3,3,.F.,PesqPict("SDC","DC_QUANT"  ))
	oExcel:AddColumn("Analitico","Relatorio Analitico","VLR EMPENHO"			 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
	oExcel:AddColumn("Analitico","Relatorio Analitico","REFATURAMENTO"		 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","% RESERVA"				 ,3,3,.F.,"999.99")
	oExcel:AddColumn("Analitico","Relatorio Analitico","TIPO FATURAMENTO"	 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","SALDO DISP CD"					 ,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DATA FINAL CLIENTE"					 ,1,1,.F.,,"")
ENDIF

RETURN oExcel

/*====================================================================================\
|Programa  | ImpSintetico       | Autor | RENATO.OLIVEIRA        | Data | 13/02/2019  |
|=====================================================================================|
|Descrição | Impressão do relatório Modelo Sintético                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                      |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function ImpSintetico(oExcel)
	 
oExcel := FwMsExcelXlsx():New()

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Sintetico")


/*****************************************************
Adiciona uma Worksheet ( Planilha )
FwMsExcelXlsx():AddWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:AddworkSheet("Sintetico")

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Sintetico")

/*****************************************************
Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
FwMsExcelXlsx():AddTable(< cWorkSheet >, < cTable >, [lPrintHead])-> NIL
*****************************************************/
oExcel:AddTable ("Sintetico","Relatorio Sintetico")


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

oExcel:AddColumn("Sintetico","Relatorio Sintetico","EMPRESA"				 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","MODALIDADE"			 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","NUMERO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","EMISSAO"				 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","MES_ANO"				 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","GRUPO_VENDAS"		 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","CODIGO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","LOJA"						 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","RAZAO_SOCIAL"		 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","CNPJ"						 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","ESTADO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","REGIAO"					 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","VENDEDOR"				 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","NOME_VENDEDOR"	 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","COORDENADOR"		 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","NOME_COORDENADOR",1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","LIQUIDO"				 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Sintetico","Relatorio Sintetico","QTDFALTA"				 ,3,3,.F.,PesqPict("PA1","PA1_QUANT" ))
oExcel:AddColumn("Sintetico","Relatorio Sintetico","VLRFALTA"				 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Sintetico","Relatorio Sintetico","QTDRES"					 ,3,3,.F.,PesqPict("PA2","PA2_QUANT" ))
oExcel:AddColumn("Sintetico","Relatorio Sintetico","VLRRES"					 ,3,3,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Sintetico","Relatorio Sintetico","ORIGEM"					 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","FINANCEIRO"			 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","TIPO"						 ,1,1,.F.,,"")
oExcel:AddColumn("Sintetico","Relatorio Sintetico","BLOQUEIOS"			 ,1,1,.F.,,"")

RETURN oExcel


/*====================================================================================\
|Programa  | PrintAnalit     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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
STATIC FUNCTION PrintAnalit(oExcel)
LOCAL nQtd := 0 
LOCAL aVetor  := {}
LOCAL nTotRec := 0
LOCAL aRet1   :={}
LOCAL cBloq   :=""
LOCAL cCapta  :=""


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
		IF MV_PAR04 <> 2
    aVetor := {}
		aVetor := {;
    	(cAliasLif)->EMPRESA,;
			(cAliasLif)->MODALIDADE,;
			(cAliasLif)->NUMERO,;
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
			(cAliasLif)->LIQUIDO,;
			(cAliasLif)->QTDFALTA,;
			(cAliasLif)->VLRFALTA,;
			(cAliasLif)->QTDRES,;
			(cAliasLif)->VLRRES,;
			(cAliasLif)->ORIGEM,;
			(cAliasLif)->FINANCEIRO,;
			(cAliasLif)->TIPO,;
			(cAliasLif)->BLOQUEIOS,;
			(cAliasLif)->DTFAT,;
			(cAliasLif)->LIQNF;
      }  

	ELSEIF MV_PAR04==2
        cCapta:=IIF(ALLTRIM((cAliasLif)->C6_CF) $  AllTrim(GetMV("ST_CFOPVEN",,"")),'EM ABERTO','SEM FINANC')
	
		aRet1:=BuscaZ96(ALLTRIM((cAliasLif)->NUMERO+(cAliasLif)->C6_ITEM),alltrim((cAliasLif)->PRODUTO))
		
		cBloq:=VerBloq((cAliasLif)->PRODUTO,ALLTRIM(aRet1[1,3]))
		//cBloq:=""
        //IF  (cAliasLif)->MSBLQL =='1' // Bloqueado Engenharia 
        //    cBloq+='Bloqueado Engenharia| '
		//ENDIF
        //IF  (cAliasLif)->XDESAT =='2' // Bloqueio Marketing
        //    cBloq+='Bloqueado Marketing| '
		//ENDIF
        //IF  (cAliasLif)->XR01 =='1' // RRO
        //    cBloq+='Bloqueio RRO '
		//ENDIF

		aVetor := {}
		aVetor := {;
        (cAliasLif)->EMPRESA,;
        (cAliasLif)->MODALIDADE,;
        (cAliasLif)->NUMERO,;
		(cAliasLif)->C6_ITEM,;        
		aRet1[1,1],;
		aRet1[1,2],;
		aRet1[1,3],;
		(cAliasLif)->EMISSAO,;
        (cAliasLif)->MES_ANO,;
        (cAliasLif)->QUANTIDADE,;
        (cAliasLif)->PRODUTO,;
        (cAliasLif)->DESCRICAO,;
		cBloq,; 
        cCapta,; 
		(cAliasLif)->ESTOQUE,;
        (cAliasLif)->DUPLIC,;
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
        (cAliasLif)->LIQUIDO,;
        (cAliasLif)->QTDFALTA,;
        (cAliasLif)->VLRFALTA,;
        (cAliasLif)->QTDRES,;
        (cAliasLif)->VLRRES,;
        (cAliasLif)->ORIGEM,;
        (cAliasLif)->FINANCEIRO,;
        (cAliasLif)->TIPO,;
        (cAliasLif)->BLOQUEIOS,;
		(cAliasLif)->DTFAT,;
		(cAliasLif)->LIQNF,;
        (cAliasLif)->B1_CLAPROD,;
        (cAliasLif)->SALDO,;
        (cAliasLif)->B1_TIPO,;
        DTOC(STOD((cAliasLif)->C6_ENTREG)),;
        DTOC(STOD((cAliasLif)->C6_ZENTRE2)),;
		DTOC(STOD((cAliasLif)->C5_XDTENPR)),;
        (cAliasLif)->C5_XORDEM,;
        (cAliasLif)->C6_NUMPCOM,;
        (cAliasLif)->C6_ITEMPC,;
        (cAliasLif)->C6_QTDVEN,;
        (cAliasLif)->C6_QTDENT,;
        (cAliasLif)->C5_ZOBS,;
        (cAliasLif)->C5_TRANSP,;
        (cAliasLif)->C5_XBLQFMI,;
        (cAliasLif)->C9_ORDSEP,;
        DTOC(STOD((cAliasLif)->DE)),;
        DTOC(STOD((cAliasLif)->ATE)),;
        (cAliasLif)->B2_QACLASS,;
        (cAliasLif)->C5_XALERTF,;
        (cAliasLif)->C6_OPER,;
        (cAliasLif)->B1_XMTO,;
		(cAliasLif)->B1_PE,;
		(cAliasLif)->C5_CONDPAG,;
        (cAliasLif)->QTD_EMPENHO,;
        (cAliasLif)->VLR_EMPENHO,;
        (cAliasLif)->C5_ZREFNF,;
        (cAliasLif)->PERC_RESERVA,;
        (cAliasLif)->C5_XTIPF,;
       	(cAliasLif)->SLDB2,;
		STDTENT(IIf(!Empty(DTOC(STOD((cAliasLif)->C6_ZENTRE2))),DTOC(STOD((cAliasLif)->C6_ZENTRE2)),DTOC(STOD((cAliasLif)->C6_ENTREG))));
		}  

		If GetMv("RSTFATDB01",,.T.)
			If IsInCallStack("U_STFAT551") .And. AllTrim((cAliasLif)->EMPRESA)=="SP"

				SC6->(DbGoTo((cAliasLif)->RECNO))
				If SC6->(!Eof())

					If SC5->( dbSeek(xFilial('SC5')+SC6->C6_NUM) )

						MaFisSave()
						MaFisEnd()
						MaFisIni(Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;	// 1-Codigo Cliente/Fornecedor
						SC5->C5_LOJAENT,; 														// 2-Loja do Cliente/Fornecedor
						IIf(SC5->C5_TIPO$ 'DB' ,"F","C"),; 										// 3-C:Cliente , F:Fornecedor
						SC5->C5_TIPO,; 															// 4-Tipo da NF
						SC5->C5_TIPOCLI,; 														// 5-Tipo do Cliente/Fornecedor
						Nil,;
							Nil,;
							Nil,;
							Nil,;
							"MATA461")

						MaFisAdd(SC6->C6_PRODUTO,;                                                     // 1-Codigo do Produto ( Obrigatorio )
						SC6->C6_TES,;                                                                  // 2-Codigo do TES ( Opcional )
						SC6->C6_QTDENT,;                                                               // 3-Quantidade ( Obrigatorio )
						SC6->C6_PRCVEN,;                                                               // 4-Preco Unitario ( Obrigatorio )
						0,;                                                                            // 5-Valor do Desconto ( Opcional )
						,;                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
						,;                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
						,;                                                                             // 8-RecNo da NF Original no arq SD1/SD2
						0,;                                                                            // 9-Valor do Frete do Item ( Opcional )
						0,;                                                                            // 10-Valor da Despesa do item ( Opcional )
						0,;                                                                            // 11-Valor do Seguro do item ( Opcional )
						0,;                                                                            // 12-Valor do Frete Autonomo ( Opcional )
						SC6->C6_VALOR,;														           // 13-Valor da Mercadoria ( Obrigatorio )
						0,;                                                                            // 14-Valor da Embalagem ( Opiconal )
						0,;                                                                            // 15-RecNo do SB1
						0)                                                                             // 16-RecNo do SF4

						nValICms := noround(MaFisRet(1,'IT_VALICM',14,2) )
						nValPis  := noround(MaFisRet(1,"IT_VALPS2",14,2) )
						nValCof  := noround(MaFisRet(1,"IT_VALCF2",14,2) )
						nValCmp  := noround(MaFisRet(1,"IT_VALCMP",14,2) )
						nValDif  := noround(MaFisRet(1,"IT_DIFAL" ,14,2) )
						nValLIQ  := round(SC6->C6_VALOR - (nValICMS) - (nValPis) - (nValCof) - (nValCmp) - (nValDif),2)
						

						If !SC6->C6_ZVALLIQ==nValLIQ
							If SC6->(RLock())
								RecLock('SC6',.F.)
								SC6->C6_ZVALLIQ := nValLIQ
								MsUnlock()
							EndIf
						EndIf

					EndIf

				EndIf

			EndIf
		EndIf

			ENDIF
      oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

			(cAliasLif)->(DBSKIP())
		EndDo

	ENDIF

RETURN oExcel

/*====================================================================================\
|Programa  | PrintSinte     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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
STATIC FUNCTION PrintSinte(oExcel)
LOCAL i := 0 
LOCAL nQtd := 0 
LOCAL nPos := 0 
LOCAL nTotRec := 0
LOCAL aVetAux := {}

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

		nPos := 0
		nPos := aScan(aVetAux,{|x|UPPER(AllTrim(x[1])) == UPPER(ALLTRIM((cAliasLif)->EMPRESA+(cAliasLif)->NUMERO))})
		IF nPos = 0 
			AADD(aVetAux,{UPPER(ALLTRIM((cAliasLif)->EMPRESA+(cAliasLif)->NUMERO)),{;
			(cAliasLif)->EMPRESA,;
			(cAliasLif)->MODALIDADE,;
			(cAliasLif)->NUMERO,;
			(cAliasLif)->EMISSAO,;
			(cAliasLif)->MES_ANO,;
			(cAliasLif)->GRUPO_VENDAS,;
			(cAliasLif)->CODIGO,;
			(cAliasLif)->LOJA,;
			(cAliasLif)->RAZAO_SOCIAL,;
			(cAliasLif)->CNPJ,;
			(cAliasLif)->ESTADO,;
			(cAliasLif)->REGIAO,;
			(cAliasLif)->VENDEDOR,;
			(cAliasLif)->NOME_VENDEDOR,;
			(cAliasLif)->COORDENADOR,;
			(cAliasLif)->NOME_COORDENADOR,;
			(cAliasLif)->LIQUIDO,;
			(cAliasLif)->QTDFALTA,;
			(cAliasLif)->VLRFALTA,;
			(cAliasLif)->QTDRES,;
			(cAliasLif)->VLRRES,;
			(cAliasLif)->ORIGEM,;
			(cAliasLif)->FINANCEIRO,;
			(cAliasLif)->TIPO,;
			(cAliasLif)->BLOQUEIOS;
			}})
		ELSE
			aVetAux[nPos,2,17] += (cAliasLif)->LIQUIDO
			aVetAux[nPos,2,18] += (cAliasLif)->QTDFALTA
			aVetAux[nPos,2,19] += (cAliasLif)->VLRFALTA
			aVetAux[nPos,2,20] += (cAliasLif)->QTDRES
			aVetAux[nPos,2,21] += (cAliasLif)->VLRRES
		ENDIF
		(cAliasLif)->(DBSKIP())
	ENDDO
ENDIF

FOR i := 1 TO LEN(aVetAux)
  oExcel:AddRow("Sintetico","Relatorio Sintetico",aVetAux[i,2])
NEXT

RETURN oExcel

/*====================================================================================\
|Programa  | StQuery		     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		        		                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

/***********************************************************************************************************************
<<< ALTERAÇÃO >>>
ação.........: A função da geração da Query foi transformada em uma USER FUNCTION, pelo motivo de ela será utilizada na rotina do WSTELEGRAM.PRW
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 20/07/2022
Chamado......: 20220713013842 - Reativar captação no Telegram
xMV01 = Data 
xMV02 = Data 
xMV03 = Numérico
xMV04 = Numérico
xMV05 = Numérico
***********************************************************************************************************************/
USER FUNCTION QRY_FATDH(xMV01,xMV02,xMV03,xMV04,xMV05,xFunName,xAlias)
LOCAL cQuery := ""

IF SELECT (cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
ENDIF


/***********************
Caso tenha recebido os parâmetros subistitui os MV_PAR
***********************/
IF !EMPTY(xMV01)
	MV_PAR01 := xMV01
  MV_PAR02 := xMV02
  MV_PAR03 := xMV03
  MV_PAR04 := xMV04
  MV_PAR05 := xMV05
ENDIF

/************************************
Verifica se a chamada da Query foi feita pelo WSTELEGRAM
************************************/
IF xFunName = "WSTELEGRAM"
	cAliasLIF := xAlias
	cQuery += " SELECT SUM(REJEITADO) AS REJEITADO, SUM(TOTAL) AS TOTAL
	cQuery += " FROM (
	cQuery += " SELECT CASE WHEN FINANCEIRO='REJEITADO' THEN NVL(LIQUIDO,0) ELSE 0 END REJEITADO,
	cQuery += " NVL(LIQUIDO,0) TOTAL
	cQuery += " FROM (
ENDIF

cQuery += "  SELECT  "+CRLF 
cQuery += "  'SP'                AS EMPRESA, "+CRLF 
cQuery += "  'CAP'               AS MODALIDADE, "+CRLF 
cQuery += "  C5_NUM              AS NUMERO, "+CRLF 
cQuery += "  C6_ITEM,C6_CF, C9_SEQUEN,   "+CRLF 
cQuery += "  SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4)          AS EMISSAO, "+CRLF 
cQuery += "  SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4)          AS MES_ANO, "+CRLF 
cQuery += "  C9_QTDLIB QUANTIDADE, "+CRLF 
cQuery += "  C6_PRODUTO          AS PRODUTO, "+CRLF 
cQuery += "  SB1.B1_DESC         AS DESCRICAO, "+CRLF 
cQuery += "  NVL(BM_GRUPO,'S/G') AS GRUPO, "+CRLF 
cQuery += "  NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO, "+CRLF 
cQuery += "  NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO, "+CRLF 
cQuery += "  A1_GRPVEN           AS GRUPO_VENDAS, "+CRLF 
cQuery += "  A1_COD              AS CODIGO, "+CRLF 
cQuery += "  A1_LOJA             AS LOJA, "+CRLF 
cQuery += "  A1_NOME             AS RAZAO_SOCIAL, "+CRLF  
cQuery += "  A1_CGC              AS CNPJ, "+CRLF 
cQuery += "  A1_EST              AS ESTADO, "+CRLF 
cQuery += "  A1_MUN              AS MUNICIPIO, "+CRLF 
cQuery += "  A1_COD_MUN          AS CODIGO_MUNICIPIO, "+CRLF 
cQuery += "  TRIM(SX5.X5_DESCRI) AS REGIAO, "+CRLF 
cQuery += "  SA3.A3_COD          AS VENDEDOR, "+CRLF 
cQuery += "  SA3.A3_NOME         AS NOME_VENDEDOR, "+CRLF 
cQuery += "  TA3.A3_COD          AS COORDENADOR, "+CRLF 
cQuery += "  TA3.A3_NOME         AS NOME_COORDENADOR, "+CRLF 
cQuery += "  0 AS CUSTO, "+CRLF 
cQuery += "  SC6.R_E_C_N_O_      AS RECNO,  "+CRLF 
cQuery += "  ( C6_ZVALLIQ / C6_QTDVEN ) * C9_QTDLIB AS LIQUIDO  "+CRLF 
cQuery += "  ,(CASE WHEN C5_XORIG='2' THEN 'MKP' WHEN C5_XORIG='3' THEN 'EDI' WHEN C5_XORIG='1' THEN 'PORTAL' ELSE ' ' END) ORIGEM  "+CRLF 
cQuery += "  ,(CASE  "+CRLF 
cQuery += "  WHEN C9_BLCRED=' ' THEN 'LIBERADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED='09' THEN 'REJEITADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED IN ('01','04','05') THEN 'BLOQUEADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED='10' THEN 'FATURADO' END) FINANCEIRO , "+CRLF 
cQuery += "  (CASE WHEN (C5_XAANO||C5_XMATE||C5_XATE > '"+DTOS(Date())+"' OR C5_XDTENPR> '"+DTOS(Date())+"') THEN 'PROG' ELSE ' ' END) TIPO,  "+CRLF 
cQuery += "  (CASE  "+CRLF 
cQuery += "  WHEN C5_ZBLOQ='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'BLOQ COMERCIAL'  "+CRLF 
cQuery += "  WHEN C5_ZREFNF='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'REFATURAMENTO' "+CRLF 
cQuery += "  WHEN C5_XTNTFOB='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'TNT FOB'  "+CRLF 
cQuery += "  WHEN A1_XBLQFIN='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'CAD FINANCEIRO'  "+CRLF 
cQuery += "  WHEN (C5_CONDPAG='501' AND C5_XLIBAVI<>'S') AND C6_QTDVEN-C6_QTDENT>0 THEN 'A VISTA BLOQ'  "+CRLF 
cQuery += "  WHEN C5_XBLQFMI='S' THEN 'FAT MIN'  "+CRLF 
cQuery += "  ELSE 'SEM BLOQUEIO' END) BLOQUEIOS  "+CRLF 
cQuery += "  ,(case when c9_blcred<>'10' then nvl((c6_zvalliq / C6_QTDVEN) * nvl(pa1.pa1_quant, 0), 0) ELSE 0 end) VLRFALTA,  "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl(pa1.pa1_quant, 0) ELSE 0 end) QTDFALTA,  "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl((c6_zvalliq / C6_QTDVEN) * nvl(pa2.pa2_quant, 0), 0) ELSE 0 end) VLRRES,  "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl(pa2.pa2_quant, 0) ELSE 0 end) QTDRES, D2_EMISSAO DTFAT, "+CRLF 
cQuery += "  D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6-D2_DIFAL-D2_ICMSCOM LIQNF, "+CRLF 
cQuery += "  ROUND(((D2_TOTAL - D2_VALICM - D2_VALIMP5 - D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM)/D2_QUANT)*C6_QTDVEN,2) LIQPED, C6_ZVALLIQ  "+CRLF 

IF MV_PAR04==2
	cQuery += "  ,SB1.B1_CLAPROD,  "+CRLF 
	cQuery += "  C6_QTDVEN-C6_QTDENT SALDO, "+CRLF 
	cQuery += "  SB1.B1_TIPO, "+CRLF 
	cQuery += "  C6_ENTREG, "+CRLF 
	cQuery += "  C6_ZENTRE2,  "+CRLF 
	cQuery += "  C5_XORDEM, "+CRLF 
//	cQuery += "  C6_XORDEM, "+CRLF 
	cQuery += "  SB1.B1_PE, "+CRLF 
	cQuery += "  C5_CONDPAG, "+CRLF 
	cQuery += "  C6_NUMPCOM,  "+CRLF 
	cQuery += "  C6_ITEMPC, "+CRLF 
	cQuery += "  C6_QTDVEN, "+CRLF 
	cQuery += "  C6_QTDENT, "+CRLF 
	cQuery += "  C5_ZOBS, "+CRLF 
	cQuery += "  C5_TRANSP,  "+CRLF 
	cQuery += "  C5_XBLQFMI,  "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP=' ' THEN 'SEM OS' WHEN CB7_STATUS='4' THEN 'EMB.FINALIZADA' ELSE 'EM SEP' END) C9_ORDSEP,  "+CRLF 
	cQuery += "  SC5.C5_XDE||'/'||SC5.C5_XMDE||'/'||SC5.C5_XDANO DE, "+CRLF 
	cQuery += "  SC5.C5_XAANO||SC5.C5_XMATE||SC5.C5_XATE ATE,  "+CRLF 
	cQuery += "  B2_QACLASS, "+CRLF 
	cQuery += "  C5_XALERTF, "+CRLF 
	cQuery += "  C6_OPER,  "+CRLF 
	cQuery += "  SB1.B1_XMTO,  "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP<>' ' AND C9_NFISCAL=' ' THEN C9_QTDLIB ELSE 0 END) QTD_EMPENHO, "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP<>' ' AND C9_NFISCAL=' ' THEN nvl((c6_zvalliq / C6_QTDVEN) * nvl(C9_QTDLIB, 0), 0) ELSE 0 END) VLR_EMPENHO, "+CRLF 
	cQuery += "  C5_ZREFNF, "+CRLF 
	cQuery += "  ROUND((NVL(PA2TOT.RESTOT,0)/(CASE WHEN (NVL(PA2TOT.RESTOT,0)+NVL(PA1TOT.FALTOT,0))=0 THEN 1 ELSE (NVL(PA2TOT.RESTOT,0)+NVL(PA1TOT.FALTOT,0)) END))*100,2) PERC_RESERVA, "+CRLF 
	cQuery += "  C5_XTIPF, C5_XDTENPR, SLDB2, "+CRLF 
    cQuery += "  SF4.F4_ESTOQUE ESTOQUE, SF4.F4_DUPLIC DUPLIC "+CRLF 


ENDIF

cQuery += " 
cQuery += "  FROM SC6110 SC6 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SC9110 SC9 "+CRLF 
cQuery += "  ON SC9.D_E_L_E_T_ = ' ' "+CRLF 
cQuery += "  AND C9_FILIAL = SC6.C6_FILIAL "+CRLF 
cQuery += "  AND C9_PEDIDO = SC6.C6_NUM "+CRLF 
cQuery += "  AND C9_ITEM = SC6.C6_ITEM "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN PA1110 PA1  "+CRLF 
cQuery += "  ON SC6.C6_FILIAL=PA1.PA1_FILIAL  "+CRLF 
cQuery += "  AND SC6.C6_NUM||SC6.C6_ITEM=PA1.PA1_DOC  "+CRLF 
cQuery += "  AND PA1.D_E_L_E_T_=' '   "+CRLF 
cQuery += "  LEFT JOIN SD2110 D2 ON D2_FILIAL=C9_FILIAL AND D2_DOC=C9_NFISCAL AND D2_ITEMPV=C9_ITEM AND D2_SERIE=C9_SERIENF AND D2.D_E_L_E_T_=' '  "+CRLF 
cQuery += "  LEFT JOIN PA2110 PA2 "+CRLF 
cQuery += "  ON SC6.C6_FILIAL=PA2.PA2_FILRES "+CRLF 
cQuery += "  AND SC6.C6_NUM||SC6.C6_ITEM=PA2.PA2_DOC "+CRLF 
cQuery += "  AND PA2.D_E_L_E_T_=' '   "+CRLF 

IF MV_PAR04==2
	cQuery += "  LEFT JOIN (SELECT B2_FILIAL, B2_COD, SUM(B2_QACLASS) B2_QACLASS  "+CRLF 
	cQuery += "  FROM SB2110 WHERE D_E_L_E_T_=' ' AND B2_FILIAL='01' GROUP BY B2_FILIAL, B2_COD)  "+CRLF 
	cQuery += "  ON B2_FILIAL=C6_FILIAL AND B2_COD=C6_PRODUTO "+CRLF 
	cQuery += " 
	cQuery += "  LEFT JOIN(SELECT PA2_FILRES, SUBSTR(PA2_DOC,1,6) PED, SUM(PA2_QUANT) RESTOT  "+CRLF 
	cQuery += "  FROM PA2110 WHERE D_E_L_E_T_=' ' AND PA2_FILRES='01' AND PA2_TIPO='1' "+CRLF 
	cQuery += "  GROUP BY PA2_FILRES,SUBSTR(PA2_DOC,1,6)) PA2TOT "+CRLF 
	cQuery += "  ON C6_FILIAL=PA2TOT.PA2_FILRES AND PA2TOT.PED=C6_NUM "+CRLF 
	cQuery += " 
	cQuery += "  LEFT JOIN(SELECT PA1_FILIAL, SUBSTR(PA1_DOC,1,6) PED, SUM(PA1_QUANT) FALTOT  "+CRLF 
	cQuery += "  FROM PA1110 WHERE D_E_L_E_T_=' ' AND PA1_FILIAL='01' AND PA1_TIPO='1' "+CRLF 
	cQuery += "  GROUP BY PA1_FILIAL,SUBSTR(PA1_DOC,1,6)) PA1TOT "+CRLF 
	cQuery += "  ON C6_FILIAL=PA1TOT.PA1_FILIAL AND PA1TOT.PED=C6_NUM "+CRLF 
	cQuery += " 
ENDIF

cQuery += "  INNER JOIN SA1110 SA1 "+CRLF 
cQuery += "  ON SA1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND A1_COD = SC6.C6_CLI "+CRLF 
cQuery += "  AND A1_LOJA = SC6.C6_LOJA "+CRLF 
cQuery += "  AND SA1.A1_GRPVEN <> 'ST' "+CRLF 
cQuery += "  AND SA1.A1_GRPVEN <> 'SC' "+CRLF 
cQuery += "  AND SA1.A1_EST    <> 'EX' "+CRLF 
cQuery += " 
cQuery += "  INNER JOIN SC5110 SC5  "+CRLF 
cQuery += "  ON SC5.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND C5_NUM = SC6.C6_NUM "+CRLF 
cQuery += "  AND C5_FILIAL = SC6.C6_FILIAL "+CRLF 
cQuery += "  AND SC5.C5_TIPO = 'N'	 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SE4110  "+CRLF 
cQuery += "  ON E4_CODIGO=C5_CONDPAG AND SE4110.D_E_L_E_T_=' '  "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN CB7110 "+CRLF 
cQuery += "  ON CB7_FILIAL=C9_FILIAL AND CB7_ORDSEP=C9_ORDSEP AND CB7110.D_E_L_E_T_=' '  "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN PC1110 PC1   "+CRLF 
cQuery += "  ON SC6.C6_NUM = PC1.PC1_PEDREP "+CRLF 
cQuery += "  AND PC1.D_E_L_E_T_ = ' ' "+CRLF 
cQuery += "  AND PC1.PC1_FILIAL = '  ' "+CRLF 
cQuery += " 
cQuery += "  INNER JOIN SB1110 SB1 "+CRLF 
cQuery += "  ON SB1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND SB1.B1_COD = SC6.C6_PRODUTO "+CRLF 
cQuery += " 

IF ( MV_PAR03==1 .OR. MV_PAR04=2) .And. !xFunName = "WSTELEGRAM" 
	cQuery += " LEFT JOIN (  "+CRLF 
	cQuery += " SELECT B1_COD, CASE WHEN QTDBF-DC_QUANT-PA2_QUANT<0 THEN 0 ELSE QTDBF-DC_QUANT-PA2_QUANT END SLDB2 "+CRLF 
	cQuery += " FROM ( "+CRLF 
	cQuery += " SELECT B1_COD, B1_LOCPAD, NVL(SUM(BF_QUANT),0) QTDBF, NVL(SUM(DC_QUANT),0) DC_QUANT, NVL(SUM(PA2_QUANT),0) PA2_QUANT "+CRLF 
	cQuery += " FROM SB1110 B1 "+CRLF 
	cQuery += " LEFT JOIN SBF110 BF "+CRLF 
	cQuery += " ON B1_COD=BF_PRODUTO AND B1_LOCPAD=BF_LOCAL AND BF.D_E_L_E_T_=' '  "+CRLF 
	cQuery += " LEFT JOIN ( "+CRLF 
	cQuery += " SELECT DC_PRODUTO, NVL(SUM(DC_QUANT),0) DC_QUANT  "+CRLF 
	cQuery += " FROM SDC110 DC "+CRLF 
	cQuery += " LEFT JOIN SB1110 B1 "+CRLF 
	cQuery += " ON B1_COD=DC_PRODUTO  "+CRLF 
	cQuery += " WHERE DC.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND DC_FILIAL='01' AND DC_ORIGEM='SC6' AND DC_LOCAL=B1_LOCPAD "+CRLF 
	cQuery += " GROUP BY DC_PRODUTO "+CRLF 
	cQuery += " ) ZZZ "+CRLF 
	cQuery += " ON ZZZ.DC_PRODUTO=B1_COD  "+CRLF 
	cQuery += " LEFT JOIN ( "+CRLF 
	cQuery += " SELECT PA2_CODPRO, NVL(SUM(PA2_QUANT),0) PA2_QUANT "+CRLF 
	cQuery += " FROM PA2110 PA2 "+CRLF 
	cQuery += " WHERE PA2.D_E_L_E_T_=' ' "+CRLF 
	cQuery += " GROUP BY PA2_CODPRO "+CRLF 
	cQuery += " ) YYY "+CRLF 
	cQuery += " ON YYY.PA2_CODPRO=B1_COD "+CRLF 
	cQuery += " WHERE B1.D_E_L_E_T_=' ' "+CRLF 
	cQuery += " GROUP BY B1_COD, B1_LOCPAD "+CRLF 
	cQuery += " ) XXX "+CRLF 
	cQuery += " ) SALDO "+CRLF 
	cQuery += " ON SALDO.B1_COD=SC6.C6_PRODUTO "+CRLF 
EndIf	

cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SB1030 TB1 "+CRLF 
cQuery += "  ON TB1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND TB1.B1_COD = SC6.C6_PRODUTO "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SBM110 SBM "+CRLF 
cQuery += "  ON SBM.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND BM_GRUPO = SB1.B1_GRUPO "+CRLF 
cQuery += "  AND SBM.BM_XAGRUP <> ' ' "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SA3110 SA3 "+CRLF 
cQuery += "  ON SA3.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND SA3.A3_COD = C5_VEND1 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SA3110 TA3 "+CRLF 
cQuery += "  ON TA3.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND TA3.A3_COD = SA3.A3_SUPER "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SX5110 SX5 "+CRLF 
cQuery += "  ON SX5.X5_TABELA  = 'A2'  "+CRLF              
cQuery += "  AND SX5.X5_CHAVE = SA1.A1_REGIAO "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SX5110 TX5 "+CRLF 
cQuery += "  ON Trim(TX5.X5_TABELA)  = 'ZZ'   "+CRLF 
cQuery += "  AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP) "+CRLF 
cQuery += " 
cQuery += " INNER JOIN SF4110 SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "   

cQuery += "  WHERE SC6.D_E_L_E_T_ = ' '     "+CRLF 
//cQuery += "  AND SC6.C6_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+") "+CRLF 
cQuery += "  AND SC6.C6_FILIAL ='01'   "+CRLF 
cQuery += "  AND PC1.PC1_PEDREP IS NULL "+CRLF 

IF MV_PAR03==2
	cQuery += " AND (SC6.C6_BLQ <> 'R'  OR  SC6.C6_BLQ = 'R' AND SC6.C6_QTDENT > 0)" +CRLF 
ELSE
	cQuery += "  AND C6_QTDVEN-C6_QTDENT>0 "+CRLF 
	cQuery += "  AND C6_BLQ=' ' "+CRLF 
	cQuery += "  AND C9_NFISCAL=' ' "+CRLF 
	cQuery += "  AND C9_ORDSEP=' ' "+CRLF 
ENDIF

cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CRLF 

cQuery += "  "+CRLF 
cQuery += "  UNION "+CRLF 
cQuery += " 
cQuery += " SELECT  "+CRLF 
cQuery += "  'AM'                AS EMPRESA, "+CRLF 
cQuery += "  'CAP'               AS MODALIDADE, "+CRLF 
cQuery += "  C5_NUM              AS NUMERO, "+CRLF 
cQuery += "  C6_ITEM,C6_CF, C9_SEQUEN,   "+CRLF 
cQuery += "  SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4)          AS EMISSAO, "+CRLF 
cQuery += "  SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4)          AS MES_ANO, "+CRLF 
cQuery += "  C9_QTDLIB QUANTIDADE, "+CRLF 
cQuery += "  C6_PRODUTO          AS PRODUTO, "+CRLF 
cQuery += "  SB1.B1_DESC         AS DESCRICAO, "+CRLF 
cQuery += "  NVL(BM_GRUPO,'S/G') AS GRUPO, "+CRLF 
cQuery += "  NVL(BM_DESC,'SEM GRUPO')AS DESC_GRUPO, "+CRLF 
cQuery += "  NVL(TRIM(TX5.X5_DESCRI),'N/A') AS AGRUPAMENTO, "+CRLF 
cQuery += "  A1_GRPVEN           AS GRUPO_VENDAS, "+CRLF 
cQuery += "  A1_COD              AS CODIGO, "+CRLF 
cQuery += "  A1_LOJA             AS LOJA, "+CRLF 
cQuery += "  A1_NOME             AS RAZAO_SOCIAL, "+CRLF 
cQuery += "  A1_CGC              AS CNPJ, "+CRLF 
cQuery += "  A1_EST              AS ESTADO, "+CRLF 
cQuery += "  A1_MUN              AS MUNICIPIO, "+CRLF 
cQuery += "  A1_COD_MUN          AS CODIGO_MUNICIPIO, "+CRLF 
cQuery += "  TRIM(SX5.X5_DESCRI) AS REGIAO, "+CRLF 
cQuery += "  SA3.A3_COD          AS VENDEDOR, "+CRLF 
cQuery += "  SA3.A3_NOME         AS NOME_VENDEDOR, "+CRLF 
cQuery += "  TA3.A3_COD          AS COORDENADOR, "+CRLF 
cQuery += "  TA3.A3_NOME         AS NOME_COORDENADOR, "+CRLF 
cQuery += "  0 AS CUSTO, "+CRLF 
cQuery += "  SC6.R_E_C_N_O_      AS RECNO, "+CRLF 
cQuery += "  ( C6_ZVALLIQ / C6_QTDVEN ) * C9_QTDLIB AS LIQUIDO "+CRLF 
cQuery += "  ,(CASE WHEN C5_XORIG='2' THEN 'MKP' WHEN C5_XORIG='3' THEN 'EDI' WHEN C5_XORIG='1' THEN 'PORTAL' ELSE ' ' END) ORIGEM "+CRLF 
cQuery += "  ,(CASE  "+CRLF 
cQuery += "  WHEN C9_BLCRED=' ' THEN 'LIBERADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED='09' THEN 'REJEITADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED IN ('01','04','05') THEN 'BLOQUEADO'  "+CRLF 
cQuery += "  WHEN C9_BLCRED='10' THEN 'FATURADO' END) FINANCEIRO , "+CRLF 
cQuery += "  (CASE WHEN (C5_XAANO||C5_XMATE||C5_XATE > '"+DTOS(Date())+"' OR C5_XDTENPR> '"+DTOS(Date())+"') THEN 'PROG' ELSE ' ' END) TIPO, "+CRLF 
cQuery += "  (CASE  "+CRLF 
cQuery += "  WHEN C5_ZBLOQ='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'BLOQ COMERCIAL'  "+CRLF 
cQuery += "  WHEN C5_ZREFNF='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'REFATURAMENTO' "+CRLF 
cQuery += "  WHEN C5_XTNTFOB='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'TNT FOB' "+CRLF 
cQuery += "  WHEN A1_XBLQFIN='1' AND C6_QTDVEN-C6_QTDENT>0 THEN 'CAD FINANCEIRO' "+CRLF 
cQuery += "  WHEN (C5_CONDPAG='501' AND C5_XLIBAVI<>'S') AND C6_QTDVEN-C6_QTDENT>0 THEN 'A VISTA BLOQ' "+CRLF 
cQuery += "  WHEN C5_XBLQFMI='S' THEN 'FAT MIN'  "+CRLF 
cQuery += "  ELSE 'SEM BLOQUEIO' END) BLOQUEIOS "+CRLF 
cQuery += "  ,(case when c9_blcred<>'10' then nvl((c6_zvalliq / C6_QTDVEN) * nvl(pa1.pa1_quant, 0), 0) ELSE 0 end) VLRFALTA, "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl(pa1.pa1_quant, 0) ELSE 0 end) QTDFALTA, "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl((c6_zvalliq / C6_QTDVEN) * nvl(pa2.pa2_quant, 0), 0) ELSE 0 end) VLRRES, "+CRLF 
cQuery += "  (case when c9_blcred<>'10' then nvl(pa2.pa2_quant, 0) ELSE 0 end) QTDRES, D2_EMISSAO DTFAT, "+CRLF 
cQuery += "  D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6-D2_DIFAL-D2_ICMSCOM LIQNF, "+CRLF 
cQuery += "  ROUND(((D2_TOTAL - D2_VALICM - D2_VALIMP5 - D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM)/D2_QUANT)*C6_QTDVEN,2) LIQPED, C6_ZVALLIQ "+CRLF 

IF MV_PAR04==2
	cQuery += "  ,SB1.B1_CLAPROD,  "+CRLF 
	cQuery += "  C6_QTDVEN-C6_QTDENT SALDO, "+CRLF 
	cQuery += "  SB1.B1_TIPO, "+CRLF 
	cQuery += "  C6_ENTRE1, "+CRLF 
	cQuery += "  C6_ZENTRE2,  "+CRLF 
	cQuery += "  C5_XORDEM, "+CRLF 
//	cQuery += "  C6_XORDEM, "+CRLF 
	cQuery += "  SB1.B1_PE, "+CRLF 
	cQuery += "  C5_CONDPAG, "+CRLF 
	cQuery += "  C6_NUMPCOM,  "+CRLF 
	cQuery += "  C6_ITEMPC, "+CRLF 
	cQuery += "  C6_QTDVEN, "+CRLF 
	cQuery += "  C6_QTDENT, "+CRLF 
	cQuery += "  C5_ZOBS, "+CRLF 
	cQuery += "  C5_TRANSP, "+CRLF 
	cQuery += "  C5_XBLQFMI,  "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP=' ' THEN 'SEM OS' WHEN CB7_STATUS='4' THEN 'EMB.FINALIZADA' ELSE 'EM SEP' END) C9_ORDSEP, "+CRLF  
	cQuery += "  SC5.C5_XDE||'/'||SC5.C5_XMDE||'/'||SC5.C5_XDANO DE, "+CRLF 
	cQuery += "  SC5.C5_XAANO||SC5.C5_XMATE||SC5.C5_XATE ATE, "+CRLF  
	cQuery += "  B2_QACLASS, "+CRLF 
	cQuery += "  C5_XALERTF, "+CRLF 
	cQuery += "  C6_OPER, "+CRLF  
	cQuery += "  ' ' B1_XMTO,  "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP<>' ' AND C9_NFISCAL=' ' THEN C9_QTDLIB ELSE 0 END) QTD_EMPENHO, "+CRLF 
	cQuery += "  (CASE WHEN C9_ORDSEP<>' ' AND C9_NFISCAL=' ' THEN nvl((c6_zvalliq / C6_QTDVEN) * nvl(C9_QTDLIB, 0), 0) ELSE 0 END) VLR_EMPENHO, "+CRLF 
	cQuery += "  C5_ZREFNF, "+CRLF 
	cQuery += "  ROUND((NVL(PA2TOT.RESTOT,0)/(CASE WHEN (NVL(PA2TOT.RESTOT,0)+NVL(PA1TOT.FALTOT,0))=0 THEN 1 ELSE (NVL(PA2TOT.RESTOT,0)+NVL(PA1TOT.FALTOT,0)) END))*100,2) PERC_RESERVA, "+CRLF 
	cQuery += "  C5_XTIPF, C5_XDTENPR, SLDB2, "+CRLF 
    cQuery += "  SF4.F4_ESTOQUE ESTOQUE, SF4.F4_DUPLIC DUPLIC "+CRLF 

ENDIF

cQuery += " 
cQuery += "  FROM "+AllTrim(GetMv("STALIASIND"))+".SC6030 SC6 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC9030 SC9 "+CRLF 
cQuery += "  ON SC9.D_E_L_E_T_ = ' ' "+CRLF 
cQuery += "  AND C9_FILIAL = SC6.C6_FILIAL "+CRLF 
cQuery += "  AND C9_PEDIDO = SC6.C6_NUM "+CRLF 
cQuery += "  AND C9_ITEM = SC6.C6_ITEM "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".PA1030 PA1 "+CRLF  
cQuery += "  ON SC6.C6_FILIAL=PA1.PA1_FILIAL  "+CRLF 
cQuery += "  AND SC6.C6_NUM||SC6.C6_ITEM=PA1.PA1_DOC "+CRLF  
cQuery += "  AND PA1.D_E_L_E_T_=' ' "+CRLF   
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SD2030 D2 ON D2_FILIAL=C9_FILIAL AND D2_DOC=C9_NFISCAL AND D2_ITEMPV=C9_ITEM AND D2_SERIE=C9_SERIENF AND D2.D_E_L_E_T_=' ' "+CRLF  
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".PA2030 PA2 "+CRLF 
cQuery += "  ON SC6.C6_FILIAL=PA2.PA2_FILRES "+CRLF 
cQuery += "  AND SC6.C6_NUM||SC6.C6_ITEM=PA2.PA2_DOC "+CRLF 
cQuery += "  AND PA2.D_E_L_E_T_=' '   "+CRLF 


IF MV_PAR04==2
	cQuery += "  LEFT JOIN (SELECT B2_FILIAL, B2_COD, SUM(B2_QACLASS) B2_QACLASS "+CRLF 
	cQuery += "  FROM "+AllTrim(GetMv("STALIASIND"))+".SB2030 WHERE D_E_L_E_T_=' ' AND B2_FILIAL='01' GROUP BY B2_FILIAL, B2_COD) "+CRLF 
	cQuery += "  ON B2_FILIAL=C6_FILIAL AND B2_COD=C6_PRODUTO "+CRLF 
	cQuery += " 
	cQuery += "  LEFT JOIN(SELECT PA2_FILRES, SUBSTR(PA2_DOC,1,6) PED, SUM(PA2_QUANT) RESTOT "+CRLF 
	cQuery += "  FROM "+AllTrim(GetMv("STALIASIND"))+".PA2030 WHERE D_E_L_E_T_=' ' AND PA2_FILRES='01' AND PA2_TIPO='1' "+CRLF 
	cQuery += "  GROUP BY PA2_FILRES,SUBSTR(PA2_DOC,1,6)) PA2TOT "+CRLF 
	cQuery += "  ON C6_FILIAL=PA2TOT.PA2_FILRES AND PA2TOT.PED=C6_NUM "+CRLF 
	cQuery += " 
	cQuery += "  LEFT JOIN(SELECT PA1_FILIAL, SUBSTR(PA1_DOC,1,6) PED, SUM(PA1_QUANT) FALTOT "+CRLF 
	cQuery += "  FROM "+AllTrim(GetMv("STALIASIND"))+".PA1030 WHERE D_E_L_E_T_=' ' AND PA1_FILIAL='01' AND PA1_TIPO='1' "+CRLF 
	cQuery += "  GROUP BY PA1_FILIAL,SUBSTR(PA1_DOC,1,6)) PA1TOT "+CRLF 
	cQuery += "  ON C6_FILIAL=PA1TOT.PA1_FILIAL AND PA1TOT.PED=C6_NUM "+CRLF 
	cQuery += " 
ENDIF

cQuery += "  INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SA1030 SA1 "+CRLF 
cQuery += "  ON SA1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND A1_COD = SC6.C6_CLI "+CRLF 
cQuery += "  AND A1_LOJA = SC6.C6_LOJA "+CRLF 
cQuery += "  AND SA1.A1_GRPVEN <> 'ST' "+CRLF 
cQuery += "  AND SA1.A1_GRPVEN <> 'SC' "+CRLF 
cQuery += "  AND SA1.A1_EST    <> 'EX' "+CRLF 
cQuery += " 
cQuery += "  INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SC5030 SC5 "+CRLF 
cQuery += "  ON SC5.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND C5_NUM = SC6.C6_NUM "+CRLF 
cQuery += "  AND C5_FILIAL = SC6.C6_FILIAL "+CRLF 
cQuery += "  AND SC5.C5_TIPO = 'N'	 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SE4030  "+CRLF 
cQuery += "  ON E4_CODIGO=C5_CONDPAG AND SE4030.D_E_L_E_T_=' ' "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".CB7030 "+CRLF 
cQuery += "  ON CB7_FILIAL=C9_FILIAL AND CB7_ORDSEP=C9_ORDSEP AND CB7030.D_E_L_E_T_=' ' "+CRLF  
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".PC1030 PC1  "+CRLF  
cQuery += "  ON SC6.C6_NUM = PC1.PC1_PEDREP "+CRLF 
cQuery += "  AND PC1.D_E_L_E_T_ = ' ' "+CRLF 
cQuery += "  AND PC1.PC1_FILIAL = '  ' "+CRLF 
cQuery += " 
cQuery += "  INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SB1030 SB1 "+CRLF 
cQuery += "  ON SB1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND SB1.B1_COD = SC6.C6_PRODUTO "+CRLF 
cQuery += " 

IF ( MV_PAR03==1 .OR. MV_PAR04=2 ) .And. !xFunName = "WSTELEGRAM"
	cQuery += " LEFT JOIN ( "+CRLF 
	cQuery += " SELECT B1_COD, CASE WHEN QTDBF-DC_QUANT-PA2_QUANT<0 THEN 0 ELSE QTDBF-DC_QUANT-PA2_QUANT END SLDB2 "+CRLF 
	cQuery += " FROM ( "+CRLF 
	cQuery += " SELECT B1_COD, B1_LOCPAD, NVL(SUM(BF_QUANT),0) QTDBF, NVL(SUM(DC_QUANT),0) DC_QUANT, NVL(SUM(PA2_QUANT),0) PA2_QUANT "+CRLF 
	cQuery += " FROM "+AllTrim(GetMv("STALIASIND"))+".SB1030 B1 "+CRLF 
	cQuery += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SBF030 BF "+CRLF 
	cQuery += " ON B1_COD=BF_PRODUTO AND B1_LOCPAD=BF_LOCAL AND BF.D_E_L_E_T_=' '  "+CRLF 
	cQuery += " LEFT JOIN ( "+CRLF 
	cQuery += " SELECT DC_PRODUTO, NVL(SUM(DC_QUANT),0) DC_QUANT "+CRLF 
	cQuery += " FROM "+AllTrim(GetMv("STALIASIND"))+".SDC030 DC "+CRLF 
	cQuery += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SB1030 B1 "+CRLF 
	cQuery += " ON B1_COD=DC_PRODUTO  "+CRLF 
	cQuery += " WHERE DC.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND DC_FILIAL='01' AND DC_ORIGEM='SC6' AND DC_LOCAL=B1_LOCPAD "+CRLF 
	cQuery += " GROUP BY DC_PRODUTO "+CRLF 
	cQuery += " ) ZZZ "+CRLF 
	cQuery += " ON ZZZ.DC_PRODUTO=B1_COD "+CRLF 
	cQuery += " LEFT JOIN ( "+CRLF 
	cQuery += " SELECT PA2_CODPRO, NVL(SUM(PA2_QUANT),0) PA2_QUANT "+CRLF 
	cQuery += " FROM "+AllTrim(GetMv("STALIASIND"))+".PA2030 PA2 "+CRLF 
	cQuery += " WHERE PA2.D_E_L_E_T_=' ' "+CRLF 
	cQuery += " GROUP BY PA2_CODPRO "+CRLF 
	cQuery += " ) YYY "+CRLF 
	cQuery += " ON YYY.PA2_CODPRO=B1_COD "+CRLF 
	cQuery += " WHERE B1.D_E_L_E_T_=' ' "+CRLF 
	cQuery += " GROUP BY B1_COD, B1_LOCPAD "+CRLF 
	cQuery += " ) XXX "+CRLF 
	cQuery += " ) SALDO "+CRLF 
	cQuery += " ON SALDO.B1_COD=SC6.C6_PRODUTO "+CRLF 
EndIf

cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SB1030 TB1 "+CRLF 
cQuery += "  ON TB1.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND TB1.B1_COD = SC6.C6_PRODUTO "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SBM110 SBM "+CRLF 
cQuery += "  ON SBM.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND BM_GRUPO = SB1.B1_GRUPO "+CRLF 
cQuery += "  AND SBM.BM_XAGRUP <> ' ' "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SA3030 SA3 "+CRLF 
cQuery += "  ON SA3.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND SA3.A3_COD = C5_VEND1 "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SA3030 TA3 "+CRLF 
cQuery += "  ON TA3.D_E_L_E_T_ = ' '  "+CRLF 
cQuery += "  AND TA3.A3_COD = SA3.A3_SUPER "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SX5110 SX5 "+CRLF 
cQuery += "  ON SX5.X5_TABELA  = 'A2'  "+CRLF              
cQuery += "  AND SX5.X5_CHAVE = SA1.A1_REGIAO "+CRLF 
cQuery += " 
cQuery += "  LEFT JOIN SX5110 TX5 "+CRLF 
cQuery += "  ON Trim(TX5.X5_TABELA)  = 'ZZ' "+CRLF   
cQuery += "  AND TRIM(TX5.X5_CHAVE) = TRIM(SBM.BM_XAGRUP) "+CRLF 

AllTrim(GetMv("STALIASIND"))+".

cQuery += " INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SF4110 SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "   

cQuery += "  WHERE SC6.D_E_L_E_T_ = ' ' "+CRLF     
//cQuery += "  AND SC6.C6_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+") "+CRLF 
cQuery += "  AND SC6.C6_FILIAL ='01'   "+CRLF 
cQuery += "  AND PC1.PC1_PEDREP IS NULL "+CRLF 

IF MV_PAR03==2
	cQuery += " AND (SC6.C6_BLQ <> 'R'  OR  SC6.C6_BLQ = 'R' AND SC6.C6_QTDENT > 0)" +CRLF 
ELSE
	cQuery += "  AND C6_QTDVEN-C6_QTDENT>0 "+CRLF 
	cQuery += "  AND C6_BLQ=' ' "+CRLF 
	cQuery += "  AND C9_NFISCAL=' ' "+CRLF 
	cQuery += "  AND C9_ORDSEP=' ' "+CRLF 
ENDIF

cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CRLF 

//// Imprime o relatório Analítico 
IF MV_PAR05 = 1
	cQuery += "  ORDER BY NUMERO,C6_ITEM, C9_SEQUEN  "+CRLF 
//// Imprime o relatório Sintético
ELSEIF MV_PAR05 = 2
	cQuery += "  ORDER BY NUMERO,C6_ITEM "+CRLF 
ENDIF

/************************************
Verifica se a chamada da Query foi feita pelo WSTELEGRAM
************************************/
IF xFunName = "WSTELEGRAM"
	cQuery += " ) XXX
	cQuery += " ) YYY
ENDIF

//Conout(cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasLif, .F., .T.)
RETURN cAliasLif

/*====================================================================================\
|Programa  | STDTENT        | Autor | RENATO.OLIVEIRA           | Data | 21/12/2022  |
|=====================================================================================|
|Descrição | Calcula data de entrega no cliente										  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STDTENT(_dData)

	Local dPrazoEnt     := Ctod("  /  /    ") 

	SC6->(DbGoTo((cAliasLif)->RECNO))
	
	If SC6->(!Eof())

		If SC5->( dbSeek(xFilial('SC5')+SC6->C6_NUM) )

				nDiasTra := U_STFATCC2(.T.,"PEDIDO")				
				//// Dias de operação para o Financeiro
				nDiasFin := GetNewPar("STDIASFIN",2)
				//// Dias de operação para o Comercial
				nDiasCom := GetNewPar("STDIASCOM",0)
				//// Dias de operação para a Logistica 
				nDiasLog := GetNewPar("STDIASLOG",4)
				//// Dias de operação para a Expedição
				nDiasExp := GetNewPar("STDIASEXP",2)
				
				dPrazoEnt     := Ctod("  /  /    ")   		//FR - 11/05/2022 - variável que irá armazenar o prazo de entrega (na porta cliente)
				
				If nDiasTra > 0
					dPrazoEnt   := Ctod("  /  /    ")
					//Prazo produto já está incluída a operação financeiro
					//Fórmula: Data Entrega = Dt. Emissão + Przo Operação Produto + Dias operação logística + Dias liberação expedição + Prazo Transportadora
					//// Soma os dias que compõe a opreação total 
					nTotPrazo := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp
					/****************************
					Trocado para a variável dPrazoEnt para pegar a C6_ENTREG e não mais C5_EMISSAO
					****************************/
					dPrazoEnt   := DataValida(_dData)			
					/****************************
					Modificado para a variavel FR = 2 pois o dia de início de operação não deve ser contado na soma
					****************************/
					fr := 2
					While fr <= nTotPrazo
						//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
						dPrazoEnt := DataValida(dPrazoEnt + 1)
						fr++										
					Enddo
					//dPrazoEnt é a variável q será impressa				
					dPrazoEnt := DataValida(dPrazoEnt) 				
				EndIf

		EndIf

	EndIf

Return(dPrazoEnt)



// Busca proximo numero do pedido devido ja estar sendo usado 
Static Function BuscaZ96(pa1doc,prod)

Local cAlias :=""
Local aRet   :={}
Local aPedCom:={}
Local aPedVen:={}
Local nPos:=0
Local aArea:=GetArea()
Local cEmpFil:=""

AADD(aRet,{'','',''})

cAlias := GetNextAlias()

cQuery := " SELECT Z96_PVIND PVIND, Z96_ITPVIN ITPVIN, Z96_PEDCOM PEDCOM, Z96_ITECOM ITECOM, Z96_QTDATE QTDATE, Z96_EMPFIL EMPFIL, Z96_TIPREG TIPREG "
cQuery += " FROM "+RetSqlName("Z96")+ " Z96 "
cQuery += " WHERE Z96.Z96_FILIAL = '"+XFILIAL('Z96')+"' " 
cQuery += "   AND Z96.Z96_PA1DOC = '"+pa1doc+"' " 
cQuery += "   AND Z96.Z96_PROD   = '"+prod+"' " 
cQuery += "   AND D_E_L_E_T_ = ' ' "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   While (cAlias)->( ! Eof())
     IF ALLTRIM((cAlias)->EMPFIL)=='0301'
	    IF ! 'MANAUS' $ cEmpFil
		   cEmpFil+='MANAUS '
		ENDIF
     ELSEIF ALLTRIM((cAlias)->EMPFIL)=='0105'
	    IF ! 'GUARAREMA' $ cEmpFil
		   cEmpFil+='GUARAREMA '
		ENDIF
     ELSEIF ALLTRIM((cAlias)->EMPFIL)=='1101'
        IF ! 'IMPORTADO' $ cEmpFil
		   cEmpFil+='IMPORTADO '
        ENDIF		   
     ENDIF		
     nPos := Ascan(aPedCom,{|x|x[1]== (cAlias)->PEDCOM+(cAlias)->ITECOM })
     IF nPos<>0
          aPedCom[nPos,2]+=(cAlias)->QTDATE
     ELSE 
          AADD(aPedCom,{(cAlias)->PEDCOM+(cAlias)->ITECOM,(cAlias)->QTDATE,(cAlias)->PEDCOM,(cAlias)->ITECOM})
     ENDIF 
	 
	 IF (cAlias)->TIPREG<>'PO'
	    nPos := Ascan(aPedVen,{|x|x[1]== (cAlias)->PVIND+(cAlias)->ITPVIN })
	    IF nPos<>0
           aPedVen[nPos,2]+=(cAlias)->QTDATE
	    ELSE 
           AADD(aPedVen,{(cAlias)->PVIND+(cAlias)->ITPVIN,(cAlias)->QTDATE,(cAlias)->PVIND,(cAlias)->ITPVIN})
	    ENDIF 
	ELSE 
        AADD(aPedVen,{'PO',0,'',''})
	ENDIF 	
	 (cAlias)->( dbskip())  
   ENDDO
ENDIF

FOR NX:=1 TO LEN(aPedVen)
    IF aPedVen[NX,1]<>'PO'
	   aRet[1,1]+=aPedVen[NX,3]+'-'+aPedVen[NX,4]+' QTD '+ALLTRIM(STR(aPedVen[NX,2]))+ '/'
	ELSE 
	   aRet[1,1]+='Importado'
	ENDIF   
NEXT 

FOR NX:=1 TO LEN(aPedCom)
	aRet[1,2]+=aPedCom[NX,3]+'-'+aPedCom[NX,4]+' QTD '+ALLTRIM(STR(aPedCom[NX,2]))+ '/'
NEXT 

aRet[1,3]:=cEmpFil

(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(aRet)



// Busca proximo numero do pedido devido ja estar sendo usado 
Static Function VerBloq(cCod,cOrigem)

Local cAlias :=""
Local cRet   :=""
Local aArea:=GetArea()

cAlias := GetNextAlias()

cQuery := " SELECT B1_MSBLQL,B1_XDESAT,B1_XR01 "
IF cOrigem=='GUARAREMA'
   cQuery += " FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 "
ELSE 
   cQuery += " FROM "+AllTrim(GetMv("STALIASIND"))+".SB1030 B1 "
ENDIF
cQuery += " WHERE B1.B1_FILIAL = '  ' " 
cQuery += "   AND B1.B1_COD = '"+cCod+"' " 
cQuery += "   AND B1.D_E_L_E_T_ = ' ' "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)

IF (cAlias)->( ! Eof())
   cRet:="" 
   IF  (cAlias)->B1_MSBLQL =='1' // Bloqueado Engenharia 
       cRet+='Bloqueado Engenharia| '
	ENDIF
    IF  (cAlias)->B1_XDESAT =='2' // Bloqueio Marketing
        cRet+='Bloqueado Marketing| '
	ENDIF
    IF  (cAlias)->B1_XR01 =='1' // RRO
        cRet='Bloqueio RRO '
	ENDIF

ENDIF

(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(cRet)




