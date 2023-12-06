#include 'TOTVS.ch'
#include 'RPTDEF.ch'
/*/{Protheus.doc} RARG2023
Relatorio de recibos Argentina
@author Jackson Capelato
@since  16/09/23
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
user function RARG2023()

	Local oReport

	oReport:= ReportDef()
	if oReport <> NIL
		oReport:PrintDialog()
	ENDIF
Return
/*/{Protheus.doc} ReportDef
Relatorio de recibos Argentina
@author Jackson Capelato
@since  16/09/23
@version 1.0
@example
(examples)
@see (links_or_references)
/*/

Static Function ReportDef()

	Local cTitle	:= "Relatório Recibos Argentina"
	Local cAliasRel := GetNextAlias()
	Local cNomeRep	:= "FS010821"
	Local oReport 	:= NIL
	Local oDesc     := NIL

	Private cPerg := "RARG2023"

	if !pergunte(cPerg,.t.)
		MsgAlert('abortado pelo operador')
		RETURN(oReport)
	ENDIF

	oReport:= TReport():New(cNomeRep,cTitle,cPerg, {|oReport| ReportPrint(oReport,cAliasRel)},cTitle)
	oReport:SetLandscape()

	oDesc:= TRSection():New(oReport,"Relatório Recibos Argentina",{"SB1","SB2"})
	oDesc:SetTotalInLine(.F.)

	TRCell():New(oDesc,"CLIENTE" 	 ,"SE1","CLIENTE"  		,/*Picture*/		 ,06 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"LOJA"	 	 ,"SE1","LOJA"     		,/*Picture*/		 ,02 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"NOME"	 	 ,"SE1","NOME"     		,/*Picture*/		 ,60 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"FATURA"		 ,"SE1","FATURA"   		,/*Picture*/		 ,12 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TIPO"	 	 ,"SE1","TIPO"     		,/*Picture*/		 ,02 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"PREFIXO" 	 ,"SE1","PREFIXO"  		,/*Picture*/		 ,03 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"CUOTA" 		 ,"SE1","CUOTA"    		,/*Picture*/		 ,03 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"EMISION" 	 ,"SE1","EMISION"  		,/*Picture*/		 ,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"FAT_DOLAR"	 ,"SE1","FAT_DOLAR"		,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TXMOEDA" 	 ,"SE1","TXMOEDA"  		,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"FAT_TOTAL" 	 ,"SE1","FAT_TOTAL"		,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"RECIBO"	 	 ,"SE1","RECIBO"   		,/*Picture*/		 ,12 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"FECHA_RECIBO","SE1","FECHA_RECIBO"  ,/*Picture*/		 ,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TP_DOC"	 	 ,"SE1","TP_DOC"		,/*Picture*/		 ,02 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"VENCIMENTO"	 ,"SE1","VENCIMENTO"	,/*Picture*/		 ,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"ENTRADA"	 ,"SE1","ENTRADA"	    ,/*Picture*/		 ,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TAXADIA"	 ,"SE1","TAXA_DIA"	    ,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TP_VALOR"	 ,"SE1","TP_VALOR"	    ,"@E 99,999,999.99"	 ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"FAT_VALOR"	 ,"SE1","FAT_VALOR"	    ,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"SALDO"	 	 ,"SE1","SALDO"		    ,"@E 99,999,999.99"  ,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/{Protheus.doc} ReportPrint
Relatorio de recibos Argentina
@author Jackson Capelato
@since  16/09/23
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
Static Function ReportPrint(oReport,cAliasRel)

	Local oDesc 	:= oReport:Section(1)

	MakeSqlExpr(oReport:uParam)

	oDesc:BeginQuery()

	BeginSql Alias cAliasRel
		SELECT E1_CLIENTE CLIENTE,E1_LOJA LOJA ,E1_NOMCLI NOME ,F2_DOC FATURA,EL_TIPO TIPO ,EL_PREFIXO PREFIXO,EL_PARCELA CUOTA ,SF2.F2_EMISSAO EMISION
			,CASE WHEN SEL.EL_TIPODOC IN ('TB') THEN 
				( CASE WHEN SF2.F2_TXMOEDA <> 0 THEN 
					ROUND((SF2.F2_VALBRUT/SF2.F2_TXMOEDA),2) ELSE 0 END ) ELSE 0 END FAT_DOLAR  
			,SF2.F2_TXMOEDA TXMOEDA,SF2.F2_VALBRUT FAT_TOTAL ,SEL.EL_RECIBO RECIBO ,SEL.EL_DTDIGIT FECHA_RECIBO ,SEL.EL_TIPODOC TP_DOC,SEL.EL_DTVCTO VENCIMENTO
			,SEL.EL_DTDIGIT ENTRADA ,SM2.M2_MOEDA2 TAXADIA,0 TP_VALOR ,SEL.EL_VALOR FAT_VALOR ,SE1.E1_SALDO SALDO 
		FROM %table:SEL%  SEL
		INNER JOIN %table:SE1% SE1 ON SE1.E1_FILIAL = SEL.EL_FILIAL AND SE1.E1_NUM = SEL.EL_NUMERO AND SE1.E1_PARCELA = SEL.EL_PARCELA
			AND SE1.E1_CLIENTE = SEL.EL_CLIENTE AND SE1.E1_LOJA = SEL.EL_LOJA AND SE1.%NotDel%
		INNER JOIN %table:SF2% SF2 ON SF2.F2_FILIAL = SE1.E1_FILIAL AND SF2.F2_DOC =SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO 
			AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA  AND SF2.%NotDel%
		LEFT JOIN %table:SM2% SM2 ON SM2.M2_DATA = SEL.EL_DTDIGIT  AND SM2.%NotDel%
			WHERE  SEL.%NotDel%
			AND SEL.EL_RECIBO  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND SF2.F2_EMISSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% 
			AND SEL.EL_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND E1_CLIENTE	   BETWEEN %Exp:mv_par07% AND %Exp:mv_par09%
			AND E1_LOJA		   BETWEEN %Exp:mv_par08% AND %Exp:mv_par10%
			AND F2_DOC		   BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
			AND SEL.EL_TIPO <> 'NCC' 
			AND SEL.EL_TIPO = 'NF'
		UNION ALL
		SELECT E1_CLIENTE CLIENTE,E1_LOJA LOJA ,E1_NOMCLI NOME ,'  ' FATURA,EL_TIPO TIPO ,EL_PREFIXO PREFIXO ,EL_PARCELA CUOTA ,'   ' EMISION ,0 FAT_DOLAR
			,0 TXMOEDA,0 FAT_TOTAL,SEL.EL_RECIBO RECIBO ,SEL.EL_DTDIGIT FECHA_RECIBO,SEL.EL_TIPODOC TP_DOC,SEL.EL_DTVCTO VENCIMENTO
			,SEL.EL_DTDIGIT   ENTRADA ,SM2.M2_MOEDA2 TAXADIA
			,CASE WHEN (( SEL.EL_TIPODOC <> 'TB' )  OR ( SEL.EL_TIPODOC = 'TB' AND SEL.EL_TIPO IN ('NCC','NDC','RA') )) THEN SEL.EL_VALOR ELSE 0 END TP_VALOR
			,0 FAT_VALOR ,0 SALDO 
			FROM %table:SEL% SEL
			INNER JOIN %table:SE1% SE1 ON SE1.E1_FILIAL = SEL.EL_FILIAL AND SE1.E1_NUM = SEL.EL_NUMERO AND SE1.E1_PARCELA = SEL.EL_PARCELA
				AND SE1.E1_CLIENTE = SEL.EL_CLIENTE AND SE1.E1_LOJA = SEL.EL_LOJA AND SE1.%NotDel%
			LEFT JOIN %table:SM2% SM2 ON SM2.M2_DATA = SEL.EL_DTVCTO AND SM2.%NotDel%
				WHERE SEL.%NotDel%
			AND SEL.EL_RECIBO  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND SEL.EL_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND E1_CLIENTE	   BETWEEN %Exp:mv_par07% AND %Exp:mv_par09%
			AND E1_LOJA		   BETWEEN %Exp:mv_par08% AND %Exp:mv_par10%
			AND SEL.EL_TIPO<>'NF'  
			AND ( ( SEL.EL_TIPO = 'NCC' AND SEL.EL_PREFIXO='REC' ) OR SEL.EL_TIPO <>'NCC' )
			AND ( ( SEL.EL_TIPO = 'NDC' AND SEL.EL_PREFIXO='NDC' ) OR SEL.EL_TIPO <>'NDC' )
		UNION ALL
		SELECT E1_CLIENTE CLIENTE,E1_LOJA LOJA ,E1_NOMCLI NOME ,F1_DOC FATURA,EL_TIPO TIPO ,EL_PREFIXO PREFIXO,EL_PARCELA CUOTA ,F1_DTDIGIT EMISION
		  	,CASE WHEN SEL.EL_TIPODOC IN ('TB') THEN (CASE WHEN SF1.F1_TXMOEDA <> 0 THEN ROUND((SF1.F1_VALBRUT/SF1.F1_TXMOEDA),2) ELSE 0 END ) ELSE 0 END FAT_DOLAR  
			,SM2X.M2_MOEDA2 TXMOEDA,SF1.F1_VALBRUT FAT_TOTAL ,SEL.EL_RECIBO RECIBO ,SEL.EL_DTDIGIT FECHA_RECIBO ,SEL.EL_TIPODOC TP_DOC,SEL.EL_DTVCTO VENCIMENTO
			,SEL.EL_DTDIGIT ENTRADA ,SM2.M2_MOEDA2 TAXADIA ,0 TP_VALOR  ,SEL.EL_VALOR * (-1) FAT_VALOR  ,SE1.E1_SALDO SALDO 
			FROM %table:SEL% SEL
				INNER JOIN %table:SE1% SE1 ON SE1.E1_FILIAL = SEL.EL_FILIAL AND SE1.E1_NUM = SEL.EL_NUMERO AND SE1.E1_PARCELA = SEL.EL_PARCELA
			AND SE1.E1_CLIENTE = SEL.EL_CLIENTE AND SE1.E1_LOJA = SEL.EL_LOJA AND SE1.%NotDel%
				INNER JOIN %table:SF1% SF1 ON SF1.F1_FILIAL = SE1.E1_FILIAL AND SF1.F1_DOC =SE1.E1_NUM AND SF1.F1_SERIE = SE1.E1_PREFIXO 
			AND SF1.F1_FORNECE = SE1.E1_CLIENTE AND SF1.F1_LOJA = SE1.E1_LOJA AND SF1.%NotDel%
			LEFT JOIN %table:SM2% SM2  ON SM2.M2_DATA  = SEL.EL_DTDIGIT AND SM2.%NotDel%  
			LEFT JOIN %table:SM2% SM2X ON SM2X.M2_DATA = SF1.F1_EMISSAO AND SM2X.%NotDel%
			WHERE  SEL.%NotDel%
			AND SEL.EL_RECIBO  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND SF1.F1_DTDIGIT BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
			AND SEL.EL_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND E1_CLIENTE	   BETWEEN %Exp:mv_par07% AND %Exp:mv_par09%
			AND E1_LOJA		   BETWEEN %Exp:mv_par08% AND %Exp:mv_par10%
			AND F1_DOC		   BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
			AND SEL.EL_TIPO = 'NCC'  AND SEL.EL_PREFIXO = 'AC' 
		UNION ALL
		SELECT EL_CLIORIG CLIENTE,EL_LOJORIG LOJA ,TRIM(A1_NOME) NOME ,'  ' FATURA,EL_TIPO TIPO ,EL_PREFIXO PREFIXO ,EL_PARCELA CUOTA ,'   ' EMISION ,0 FAT_DOLAR
			,0 TXMOEDA,0 FAT_TOTAL,SEL.EL_RECIBO RECIBO ,SEL.EL_DTDIGIT FECHA_RECIBO,SEL.EL_TIPODOC TP_DOC,SEL.EL_DTVCTO VENCIMENTO
			,SEL.EL_DTDIGIT   ENTRADA ,SM2.M2_MOEDA2 TAXADIA
			,CASE WHEN SEL.EL_TIPODOC NOT IN ('TB') THEN SEL.EL_VALOR ELSE 0 END TP_VALOR
			,0 FAT_VALOR ,0 SALDO 
			FROM %table:SEL%  SEL
			INNER JOIN %table:SA1%  SA1 ON SA1.A1_COD = SEL.EL_CLIORIG AND SA1.A1_LOJA = SEL.EL_LOJORIG AND SA1.%NotDel%
			LEFT JOIN  %table:SM2%  SM2 ON SM2.M2_DATA = SEL.EL_DTVCTO  AND SM2.%NotDel%
			WHERE SEL.%NotDel%
			AND SEL.EL_RECIBO  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND SEL.EL_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND EL_CLIORIG	   BETWEEN %Exp:mv_par07% AND %Exp:mv_par09%
			AND EL_LOJORIG	   BETWEEN %Exp:mv_par08% AND %Exp:mv_par10%
			AND SEL.EL_TIPO<>'NF' AND SEL.EL_TIPO <> 'NCC' AND SEL.EL_TIPO <> 'RA' 
			AND             SEL.EL_FILIAL||SEL.EL_PREFIXO||SEL.EL_NUMERO||SEL.EL_PARCELA||SEL.EL_CLIORIG||SEL.EL_LOJORIG
			NOT IN ( SELECT SE1.E1_FILIAL||SE1.E1_PREFIXO||SE1.E1_NUM||SE1.E1_PARCELA||SE1.E1_CLIENTE||SE1.E1_LOJA FROM  %table:SE1%  SE1
					WHERE SE1.%NotDel%  )
		UNION ALL
		SELECT E1_CLIENTE CLIENTE,E1_LOJA LOJA ,E1_NOMCLI NOME ,F2_DOC FATURA,EL_TIPO TIPO ,EL_PREFIXO PREFIXO,EL_PARCELA CUOTA ,F2_EMISSAO EMISION
		,CASE WHEN SEL.EL_TIPODOC IN ('TB') THEN (CASE WHEN SF2.F2_TXMOEDA <> 0 THEN ROUND((SF2.F2_VALBRUT/SF2.F2_TXMOEDA),2) ELSE 0 END ) ELSE 0 END FAT_DOLAR  
		,SM2X.M2_MOEDA2 TXMOEDA,SF2.F2_VALBRUT FAT_TOTAL ,SEL.EL_RECIBO RECIBO ,SEL.EL_DTDIGIT FECHA_RECIBO ,SEL.EL_TIPODOC TP_DOC,SEL.EL_DTVCTO VENCIMENTO
		,SEL.EL_DTDIGIT ENTRADA ,SM2.M2_MOEDA2 TAXADIA ,0 TP_VALOR  ,SEL.EL_VALOR FAT_VALOR  ,SE1.E1_SALDO SALDO 
		FROM SEL070 SEL
		INNER JOIN SE1070 SE1 ON SE1.E1_FILIAL = SEL.EL_FILIAL AND SE1.E1_NUM = SEL.EL_NUMERO AND SE1.E1_PARCELA = SEL.EL_PARCELA
			AND SE1.E1_CLIENTE = SEL.EL_CLIENTE AND SE1.E1_LOJA = SEL.EL_LOJA AND SE1.%NotDel%
		LEFT JOIN SF2070 SF2 ON SF2.F2_FILIAL = SE1.E1_FILIAL AND SF2.F2_DOC =SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO 
			AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA  AND SF2.%NotDel%
		LEFT JOIN SM2070 SM2 ON SM2.M2_DATA = SEL.EL_DTDIGIT AND SM2.%NotDel%
		LEFT JOIN SM2070 SM2X ON SM2X.M2_DATA = SF2.F2_EMISSAO AND SM2X.%NotDel%
		WHERE  SEL.%NotDel%
		AND SEL.EL_RECIBO  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND SEL.EL_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND E1_CLIENTE	   BETWEEN %Exp:mv_par07% AND %Exp:mv_par09%
		AND E1_LOJA		   BETWEEN %Exp:mv_par08% AND %Exp:mv_par10%
		AND SEL.EL_TIPO = 'NDC'  AND SEL.EL_PREFIXO = 'AD'  			
	EndSql

	oDesc:EndQuery()

	(cAliasRel)->(dbGoTop())

	While !oReport:Cancel() .and. !(cAliasRel)->(Eof())

		If oReport:Cancel()
			Exit
		EndIf
		oDesc:Init()
		oDesc:PrintLine()
		(cAliasRel)->(dbSkip())

	EndDo
	oReport:SkipLine(1)
	oDesc:Finish()
	(cAliasRel)->(dbCloseArea())

Return

