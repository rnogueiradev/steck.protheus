#include 'TOTVS.ch'
#include 'RPTDEF.ch'
/*/{Protheus.doc} RARG2023
Relatorio para seguradora
@author Jackson Capelato
@since  18/10/23
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
user function RSEG2023()

	Local oReport

	oReport:= ReportDef()
	if oReport <> NIL
		oReport:PrintDialog()
	ENDIF
Return
/*/{Protheus.doc} ReportDef
Relatorio para seguradora
@author Jackson Capelato
@since  18/10/23
@version 1.0
@example
(examples)
@see (links_or_references)
/*/

Static Function ReportDef()

	Local cTitle	:= "Relatório seguradora"
	Local cAliasRel := GetNextAlias()
	Local cNomeRep	:= "RSEG2023"
	Local oReport 	:= NIL
	Local oDesc     := NIL

	Private cPerg := "RSEG2023"

	if !pergunte(cPerg,.t.)
		MsgAlert('abortado pelo operador')
		RETURN(oReport)
	ENDIF

	oReport:= TReport():New(cNomeRep,cTitle,cPerg, {|oReport| ReportPrint(oReport,cAliasRel)},cTitle)
	oReport:SetLandscape()

	oDesc:= TRSection():New(oReport,"Relatório seguradora",{"SB1","SB2"})
	oDesc:SetTotalInLine(.F.)

	TRCell():New(oDesc,"C_F" 	     ,cAliasRel,"CODIGO"  		,/*Picture*/		 	,11 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"NOME"	 	 ,cAliasRel,"NOMBRE"   		,/*Picture*/		 	,60 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"CGC"		 ,cAliasRel,"CUIT"   		,/*Picture*/			,12 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"DOC"		 ,cAliasRel,"FACTURA"  		,/*Picture*/		 	,12 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"TIPO"	 	 ,cAliasRel,"TIPO"     		,/*Picture*/		 	,03 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"EMISSAO" 	 ,cAliasRel,"EMISION" 		,/*Picture*/		 	,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"VENCTO"		 ,cAliasRel,"VENCIMIENTO"	,/*Picture*/		 	,08 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oDesc,"VALOR"  	 ,cAliasRel,"MONTO"  		,"@E 99,999,999.99"	 	,15 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/{Protheus.doc} ReportPrint
Relatorio para seguradora
@author Jackson Capelato
@since  18/10/23
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
		SELECT F1_DOC DOC, F1_SERIE SERIE, F1_FORNECE || ' - ' || F1_LOJA C_F , A2_NOME NOME,F1_EMISSAO EMISSAO, F1_VALBRUT VALOR, E1_VENCTO VENCTO, E1_TIPO TIPO, A2_CGC CGC
		FROM %table:SF1% SF1
		INNER JOIN %table:SA2% SA2 ON A2_COD    = F1_FORNECE AND A2_LOJA = F1_LOJA  AND SA2.%NotDel%
		INNER JOIN %table:SE1% SE1 ON E1_FILIAL = F1_FILIAL  AND E1_NUM  = F1_DUPL  AND SE1.%NotDel%
		WHERE SF1.%NotDel%
		AND F1_FORNECE BETWEEN %Exp:mv_par01% AND %Exp:mv_par03%
		AND F1_LOJA	   BETWEEN %Exp:mv_par02% AND %Exp:mv_par04%
		AND F1_EMISSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		UNION ALL
		SELECT F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE || ' - ' || F2_LOJA C_F , A1_NOME NOME,F2_EMISSAO EMISSAO, F2_VALBRUT VALOR, E1_VENCTO VENCTO, E1_TIPO TIPO, A1_CGC CGC
		FROM %table:SF2% SF2
		INNER JOIN %table:SA1% SA2 ON A1_COD    = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA2.%NotDel%
		INNER JOIN %table:SE1% SE1 ON E1_FILIAL = F2_FILIAL  AND E1_NUM  = F2_DUPL AND SE1.%NotDel%
		WHERE SF2.%NotDel%
		AND F2_CLIENTE BETWEEN %Exp:mv_par01% AND %Exp:mv_par03%
		AND F2_LOJA	   BETWEEN %Exp:mv_par02% AND %Exp:mv_par04%
		AND F2_EMISSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
	EndSql

	oDesc:EndQuery()

	(cAliasRel)->(dbGoTop())

	While !oReport:Cancel() .and. !(cAliasRel)->(Eof())

		If oReport:Cancel()
			Exit
		EndIf
		oDesc:Init()
		oDesc:Cell("EMISSAO"):SetValue(SToD((cAliasRel)->EMISSAO))
		oDesc:Cell("VENCTO"):SetValue(SToD((cAliasRel)->VENCTO))
		oDesc:PrintLine()
		(cAliasRel)->(dbSkip())

	EndDo
	oReport:SkipLine(1)
	oDesc:Finish()
	(cAliasRel)->(dbCloseArea())

Return

