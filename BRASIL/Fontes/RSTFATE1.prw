#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Tbiconn.ch"

/*/{Protheus.doc} RSTFATE1
Relatorio OTDC
@type function
@version  1.0
@author Kleber Ribeiro - CRM Services 
@since 20/05/2022
/*/

USER FUNCTION RSTFATE1()

	Private cPerg 			:= "RFATDD"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private cStatusE 		:= " "
	Private cStatusP		:= " "
	
	
	U_STPutSx1( cPerg, "01","Data de: (Emissao)" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate: (Emissao)"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	Pergunte(cPerg,.T.)
	
	oExcel := ImpAnalitico(oExcel)

		PROCESSA({|| StQuery() },"Compondo Relatorio") 
		PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

		If !ExistDir("c:\arquivos_protheus\")
			MakeDir("c:\arquivos_protheus\")
		Endif 

		_cArq := 'rstfate1.xlsx'
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

	
		
Return


Static Function StQuery()

Local cQuery     := ' '

cQuery += " SELECT                                       "+CRLF
cQuery += " SC6.C6_FILIAL       AS FILIAL                "+CRLF
cQuery += " ,SC6.C6_NUM         AS NUM                   "+CRLF
cQuery += " ,SC5.C5_CLIENTE     AS CODCLI                "+CRLF
cQuery += " ,SC5.C5_LOJACLI     AS LOJCLI                "+CRLF
cQuery += " ,SC5.C5_XNOME       AS NOMCLI                "+CRLF
cQuery += " ,SC5.C5_EMISSAO     AS EMISSAO               "+CRLF
cQuery += " ,SC6.C6_ITEM        AS ITEM                  "+CRLF
cQuery += " ,SC6.C6_PRODUTO     AS CODPRO                "+CRLF
cQuery += " ,SC6.C6_DESCRI      AS DESPRO                "+CRLF
cQuery += " ,SC6.C6_QTDVEN      AS QTDVEN                "+CRLF
cQuery += " ,SC6.C6_QTDENT      AS QTDENT                "+CRLF
cQuery += " ,SC6.C6_PRCVEN      AS PRCVEN                "+CRLF
cQuery += " ,SC6.C6_VALOR       AS VALOR                 "+CRLF
cQuery += " ,SC6.C6_ZVALLIQ     AS VALLIQ                "+CRLF
cQuery += " ,SC6.C6_ZENTRE1     AS DATA1ALT	             "+CRLF
cQuery += " ,SC6.C6_ZMOTALT     AS MOT1ALT	             "+CRLF
cQuery += " ,SC6.C6_ZENTREC     AS DATA2ALT	             "+CRLF
cQuery += " ,SC6.C6_ZENTR1C     AS DATA1C                "+CRLF
cQuery += " ,SC6.C6_ZENTREP     AS DATENTPRO             "+CRLF
cQuery += " ,SC6.C6_DATFAT      AS DATFAT                "+CRLF
cQuery += " ,SC6.C6_ZDTENRE     AS DATENT                "+CRLF
cQuery += " FROM "+RetSqlName("SC6")+" SC6                     "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5               "+CRLF
cQuery += " ON SC5.C5_NUM = SC6.C6_NUM                   "+CRLF
cQuery += " AND sc5.d_e_l_e_t_ = ' '                     "+CRLF
cQuery += " WHERE 1=1                                    "+CRLF
cQuery += " AND SC6.C6_ZENTR1C <> ' '                    "+CRLF
cQuery += " AND (SC5.C5_EMISSAO >= '" +Dtos(MV_PAR01)+"' "+CRLF
cQuery += " AND SC5.C5_EMISSAO <= '" +Dtos(MV_PAR02)+"') "+CRLF
cQuery += " AND sc6.d_e_l_e_t_ = ' '          			 "+CRLF
cQuery += " ORDER BY 2				          			 "+CRLF

MemoWrite("C:\QUERY\RSTFATE1.TXT" , cQuery)

cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


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
oExcel:AddColumn("Analitico","Relatorio Analitico","PEDIDO"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","COD_CLIENTE"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","LOJA"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","NOME_CLIENTE"		,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","EMISSAO_PV"			,1,1,.F.,PesqPict("SC5","C5_EMISSAO"))
oExcel:AddColumn("Analitico","Relatorio Analitico","ITEM"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PRODUTO"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DESC_PROD"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QTDVEN"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","QTDENT"				,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","PRCVEN"				,1,1,.F.,PesqPict("SC6","C6_PRCVEN"))
oExcel:AddColumn("Analitico","Relatorio Analitico","TOTAL"				,1,1,.F.,PesqPict("SC6","C6_VALOR"))
oExcel:AddColumn("Analitico","Relatorio Analitico","TOTAL LIQ"			,1,1,.F.,PesqPict("SC6","C6_ZVALLIQ"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA1ALT"			,1,1,.F.,PesqPict("SC6","C6_ZENTRE1"))
oExcel:AddColumn("Analitico","Relatorio Analitico","MOT1ALT"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA2ALT"			,1,1,.F.,PesqPict("SC6","C6_ZDTENRE"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA1C"				,1,1,.F.,PesqPict("SC6","C6_ZENTR1C"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA ENT PRO"		,1,1,.F.,PesqPict("SC6","C6_ZENTREP"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA FAT"			,1,1,.F.,PesqPict("SC6","C6_DATFAT"))
oExcel:AddColumn("Analitico","Relatorio Analitico","DATA ENT"			,1,1,.F.,PesqPict("SC6","C6_ZDTENRE"))
oExcel:AddColumn("Analitico","Relatorio Analitico","STATUS ENT"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","STATUS PED"			,1,1,.F.,,"")
oExcel:AddColumn("Analitico","Relatorio Analitico","MOTIVO"				,1,1,.F.,,"")

RETURN oExcel


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
    	aVetor := {}

		aVetor := {;
		(cAliasLif)->FILIAL,;           	  
		(cAliasLif)->NUM,;  	     	  
		(cAliasLif)->CODCLI,;           	    				  
		(cAliasLif)->LOJCLI,;           	    		  
		(cAliasLif)->NOMCLI,;           	    			  
		STOD((cAliasLif)->EMISSAO),;           	    					  
		(cAliasLif)->ITEM,;           	    				  
		(cAliasLif)->CODPRO,;           	    		  
		(cAliasLif)->DESPRO,;           	    				  
		(cAliasLif)->QTDVEN,;           	    				  
		(cAliasLif)->QTDENT,;           	    			  
		(cAliasLif)->PRCVEN,;           	    			  
		(cAliasLif)->VALOR,;           	    		  
		(cAliasLif)->VALLIQ,;        	    			  
		IF(!EMPTY(STOD((cAliasLif)->DATA1ALT)),STOD((cAliasLif)->DATA1ALT)," "),;          	    		  
		(cAliasLif)->MOT1ALT,;   
		IF(!EMPTY(STOD((cAliasLif)->DATA2ALT)),STOD((cAliasLif)->DATA2ALT)," "),;    	    			  
		STOD((cAliasLif)->DATA1C),;
		IF(!EMPTY(STOD((cAliasLif)->DATENTPRO)),STOD((cAliasLif)->DATENTPRO)," "),;
		IF(!EMPTY(STOD((cAliasLif)->DATFAT)),STOD((cAliasLif)->DATFAT)," "),; 			  
		IF(!EMPTY(STOD((cAliasLif)->DATENT)),STOD((cAliasLif)->DATENT)," "),;
		VerificaStatus(STOD((cAliasLif)->DATA1C),STOD((cAliasLif)->DATENTPRO),STOD((cAliasLif)->DATFAT),STOD((cAliasLif)->DATENT),(cAliasLif)->QTDVEN,(cAliasLif)->QTDENT),;
		cStatusP;
		}

	
      	oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

		(cAliasLif)->(DBSKIP())
	EndDo

ENDIF

RETURN oExcel



STATIC FUNCTION VerificaStatus(dData1C,dDataPro,dDatFat,dDataEnt,nQtdVen,nQtdEnt)
Local dDtComparar

cStatusE := " "
cStatusP := " "

IF !EMPTY(dDataPro)
	IF dDataPro > dData1C
		dDtComparar := dDataPro
	ELSE
		dDtComparar := dData1C
	ENDIF
ELSE
	dDtComparar := dData1C
ENDIF

IF !EMPTY(dDataEnt) .AND. !EMPTY(dDataPro)  //Possui data entrega e data programada preenchidas
	IF dDataEnt == dDtComparar //data entrega MENOR que a data programada, caso for MAIOR caira no ELSE
		cStatusE := "NA DATA"
	ELSEIF dDataEnt < dDtComparar //data entrega MENOR que a data programada, caso for MAIOR caira no ELSE
		cStatusE := "ADIANTADO"
	ELSE
		cStatusE := "ATRASADO"
	ENDIF

	IF nQtdVen-nQtdEnt == 0
		cStatusP := "FINALIZADO" //finalizado pois entrega TOTAL
	ELSE
		cStatusP := "EM ABERTO" //em aberto pois entrega PARCIAL
	ENDIF
ELSEIF EMPTY(dDatFat) .AND. dDataBase <= dDtComparar //Nao faturado e a data de hoje é MENOR que a 1data prometida
	cStatusE := "EM DIA"
	cStatusP := "EM ABERTO"
ELSEIF EMPTY(dDatFat) .AND. dDataBase > dDtComparar //Nao faturado e a data de hoje é MAIOR que a 1data prometida
	cStatusE := "ATRASADO"
	cStatusP := "EM ABERTO"
ELSEIF !EMPTY(dDatFat) .AND. EMPTY(dDataEnt) //Faturado e nao entregue
	IF dDataBase <= dDtComparar //data de hoje é MENOR que a 1data prometida
		cStatusE := "EM DIA"
	ELSE
		cStatusE := "ATRASADO"
	ENDIF
	cStatusP := "EM ABERTO"
ELSEIF !EMPTY(dDatFat) .AND. !EMPTY(dDataEnt) //Faturado e entregue
	IF dDataEnt <= dDtComparar //Data entregue é MENOR que a 1data prometida
		cStatusE := "ADIANTADO"
	ELSE
		cStatusE := "ATRASADO"
	ENDIF

	IF nQtdVen-nQtdEnt == 0 //verifica se nao foi entrega parcial
		cStatusP := "FINALIZADO"
	ELSE
		cStatusP := "EM ABERTO"
	ENDIF
ENDIF

RETURN cStatusE
