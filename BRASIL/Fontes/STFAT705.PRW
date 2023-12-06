#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STFAT705
@name STFAT705
@type User Function
@desc rotina a ser processada via JOB para gerar relatório de campanha. 
@author Antonio Cordeiro Moura
@since 06/10/2023
/*/

User Function STFAT705()

Local _cArq    :=""
Local cPasta   :=""
Local cDirTemp :=""
PRIVATE cMes := SPACE(02)
PRIVATE cAno := SPACE(04)
PRIVATE cTime     := Time()
PRIVATE cHora     := SUBSTR(cTime, 1, 2)
PRIVATE cMinutos  := SUBSTR(cTime, 4, 2)
PRIVATE cSegundos := SUBSTR(cTime, 7, 2)
PRIVATE cAliasLIF := cHora+ cMinutos+cSegundos

Private oExcel := FwMsExcelXlsx():New()

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	

cAno := ALLTRIM(STR(YEAR(DATE())))
cMes := ALLTRIM(STR(Month(DATE())))

//cDirTemp:=AllTrim(GetMV("ST_DIRCAMP",,"\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"))
cDirTemp:=AllTrim(GetMV("ST_DIRCAMP",,"\arquivos\SFTP-INTEGRAÇÕES\STECKCONECTA\CAMPANHA\PENDING\"))

//oExcel := FwMsExcelXlsx():New()
//oExcel := FWMSExcel():New()
oOpnArq := NIL
oExcel := LayExcel(oExcel)
PROCESSA({|| U_QRY_CAMP() },"Compondo Relatorio")
PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

_cArq := "campanha_"+dtos(date())+"_.xlsx"
cPasta := cDirTemp+_cArq
FErase(cPasta)
oExcel:Activate()
oExcel:GetXMLFile( cPasta )
oExcel:DeActivate()
//__CopyFile("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\"+_cArq,"\arquivos\SFTP-INTEGRAÇÕES\STECKCONECTA\CAMPANHA\PENDING\"+_cArq)

Return()





/*====================================================================================\
|Programa  | LayExcel           | Autor | ANTONIO.CORDEIRO       | Data | 06/10/2023  |
|=====================================================================================|
|Descrição | Montagem do Layout                                                       |
|=====================================================================================|
|Sintaxe   | 		                                                                      |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
STATIC FUNCTION LayExcel(oExcel)

oExcel := FwMsExcelXlsx():New()

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Campanha")


/*****************************************************
Adiciona uma Worksheet ( Planilha )
FwMsExcelXlsx():AddWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:AddworkSheet("Campanha")

/*****************************************************
Verifica se um nome já foi utilizado para definir uma WorkSheet
FwMsExcelXlsx():IsWorkSheet(< cWorkSheet >)-> lRet
*****************************************************/
oExcel:IsWorkSheet("Campanha")

/*****************************************************
Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
FwMsExcelXlsx():AddTable(< cWorkSheet >, < cTable >, [lPrintHead])-> NIL
*****************************************************/
oExcel:AddTable ("Campanha","Relatorio Campanha")

oExcel:AddColumn("Campanha","Relatorio Campanha","FILIAL"        ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","CNPJ"	       ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","CODIGO"		   ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","LOJA"	       ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","NOME"	       ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","PEDIDO"		   ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","NOTA_FISCAL"   ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","EMISSAO"       ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","SKU"           ,1,1,.F.,,"")
oExcel:AddColumn("Campanha","Relatorio Campanha","QTD ITEM NF"    ,3,3,.F.,PesqPict("SD2","D2_QUANT"))
oExcel:AddColumn("Campanha","Relatorio Campanha","TOTAL ITEM NF"  ,3,3,.F.,PesqPict("SD2","D2_TOTAL"))

RETURN oExcel



//Desenvolvedor: Antonio Cordeiro Moura
//Data.........: 06/10/2023


USER FUNCTION QRY_CAMP()

LOCAL cQuery := ""

IF SELECT (cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
ENDIF

cQuery+= " SELECT SD2.D2_FILIAL FILIAL,SA1.A1_CGC CNPJ ,SA1.A1_COD CODIGO,SA1.A1_LOJA LOJA, SA1.A1_NOME NOME , SD2.D2_PEDIDO PEDIDO , SD2.D2_DOC NOTA_FISCAL , "
cQuery+= " SD2.D2_EMISSAO EMISSAO , SD2.D2_COD SKU ,SD2.D2_QUANT QTD_ITEM_NF,SD2.D2_TOTAL TOTAL_ITEM_NF "
cQuery+= " FROM "+RetSqlName("SD2")+" SD2 "
cQuery+= " INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_GRPVEN IN ('I1','I2','I5')  AND SA1.D_E_L_E_T_ = ' ' "
cQuery+= " WHERE Substr(D2_EMISSAO, 1, 6) = '"+substr(dtos(date()),1,6)+"' "
cQuery+= " AND SD2.D_E_L_E_T_ = ' ' "


DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasLif, .F., .T.)
RETURN cAliasLif




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
        (cAliasLif)->FILIAL,;
        (cAliasLif)->CNPJ,;	
        (cAliasLif)->CODIGO,;	
        (cAliasLif)->LOJA,;	
        (cAliasLif)->NOME,;	
        (cAliasLif)->PEDIDO,;	
        (cAliasLif)->NOTA_FISCAL,;	
        (cAliasLif)->EMISSAO,;	
        (cAliasLif)->SKU,;	
        (cAliasLif)->QTD_ITEM_NF,;	
        (cAliasLif)->TOTAL_ITEM_NF;
		}  
      oExcel:AddRow("Campanha","Relatorio Campanha",aVetor)
	  (cAliasLif)->(DBSKIP())
    ENDDO	 
ENDIF	 
RETURN oExcel







