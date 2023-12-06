#INCLUDE "PROTHEUS.CH" 

/*/{Protheus.doc} RSTFATDG
description
@type function
@version  
@author renato.oliveira
@since 8/17/2023
@param oExcel, object, param_description
@return variant, return_description
/*/

User Function RSTFATDG(oExcel)

	Local cDirTemp    := ""
	Private cPerg 			:= "RFATDG"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= GetNextAlias()
	Private _lTela 			:= .F.
	Default oExcel := FwMsExcelXlsx():New()

	oExcel := ImpAnalitico(oExcel)
	PROCESSA({|| StQuery() },"Compondo Relatorio")
	PROCESSA({|| oExcel := PrintAnalit(oExcel) },"Aguarde", "Carregando informações...")

	If IsInCallStack("U_STFAT373")
		_cArq := SA1->A1_CGC+'.xlsx'
		cPasta := "\arquivos\SFTP-INTEGRAÇÕES\UNICA\PENDING\"+_cArq
		FErase(cPasta)
		oExcel:Activate()
		oExcel:GetXMLFile( cPasta )
		oExcel:DeActivate()
	Else
		Pergunte(cPerg,.T.)
		_cArq := SA1->A1_CGC+'.xlsx'
		cDirTemp    := GetTempPath()
		cPasta := cDirTemp
		oExcel:Activate()
		Processa({|| oExcel:GetXMLFile( cPasta + _cArq) },"Aguarde", "Montando a Planilha...")
		oExcel:DeActivate()
		Sleep(5000)
		ShellExecute("OPEN",_cArq,"",cPasta,1)
	EndIf

Return

/*/{Protheus.doc} StQuery
description
@type function
@version  
@author renato.oliveira
@since 8/17/2023
@return variant, return_description
/*/
Static Function StQuery()

	Local cQuery     := ' '

	cQuery := " SELECT SB1.R_E_C_N_O_ RECSB1, DA1.DA1_CODPRO  ,DA1.DA1_PRCVEN ,SB1.B1_GRUPO  ,SB1.B1_DESC " + CRLF
	cQuery += " FROM "+RetSqlName("DA1")+" DA1 "+ CRLF
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "+ CRLF
	cQuery += " ON SB1.B1_COD = DA1.DA1_CODPRO " + CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1
	cQuery += " ON A1_COD='"+SA1->A1_COD+"' AND A1_LOJA='"+SA1->A1_LOJA+"'
	cQuery += " LEFT JOIN "+RetSqlName("SZD")+" ZD
	cQuery += " ON ZD_CLIENTE=A1_COD AND ZD_CODSTE=B1_COD
	cQuery += " WHERE
	cQuery += " DA1.D_E_L_E_T_     = ' ' AND ZD.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' "   + CRLF
	cQuery += " AND DA1.DA1_PRCVEN > 0 AND SB1.B1_XDESAT<>'2' " + CRLF
	cQuery += " AND DA1.DA1_CODTAB = '"+ ALLTRIM(GETMV("ST_TPRCFAT"))+"'" + CRLF
	cQuery += " AND DA1_XVISUA<>'2'

	//cQuery += " AND B1_COD IN ('S733103719','S3056')

	cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


/*/{Protheus.doc} ImpAnalitico
description
@type function
@version  
@author renato.oliveira
@since 8/17/2023
@param oExcel, object, param_description
@return variant, return_description
/*/
STATIC FUNCTION ImpAnalitico(oExcel)
	
	oExcel:IsWorkSheet("Analitico")
	oExcel:AddworkSheet("Analitico")
	oExcel:AddTable("Analitico","Relatorio Analitico",.F.)

	oExcel:AddColumn("Analitico","Relatorio Analitico","CNPJCliente"       	,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","CodigoProdutoFornecedor"	     	,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","CodigoProdutoCliente"		,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","DescricaoItem"			,1,1,.F.,,"")
	oExcel:AddColumn("Analitico","Relatorio Analitico","PrecoFornecedor"			,1,1,.F.,,"")

RETURN oExcel


/*/{Protheus.doc} PrintAnalit
description
@type function
@version  
@author renato.oliveira
@since 8/17/2023
@param oExcel, object, param_description
@return variant, return_description
/*/

Static Function PrintAnalit(oExcel)

	LOCAL nQtd := 0
	LOCAL aVetor  := {}
	LOCAL nTotRec := 0
	LOCAL cCanal  :=""
	LOCAL cEscala :=""

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SZD")
	SZD->(DbSetOrder(2))
	SZD->(DbGoTop())

	_nPDesc := GetMv("ST_WSPRT02",,0)

	DBSELECTAREA(cAliasLif)
	(cAliasLif)->(DBGOTOP())
	nTotRec := 0
	DbEval({|| nTotRec++  })
	PROCREGUA(nTotRec)
	(cAliasLif)->(DBGOTOP())

	IF  SELECT(cAliasLif) > 0
		WHILE (cAliasLif)->(!EOF())

			SB1->(DbGoTo((cAliasLif)->RECSB1))
			If SB1->(!Eof())

				nQtd++

				If !IsBlind()
					INCPROC("Carregando informações...."+ALLTRIM(STR(nQtd))+" / "+ALLTRIM(STR(nTotRec)))
				EndIf

				_nPreco := 0
				_cCnpj  := SA1->A1_CGC
				_cCodSte:= SB1->B1_COD
				_cCodCli:= ""
				_cDesc  := SB1->B1_DESC

				_nPreco := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,MV_PAR05,'PRECO',.F.,SA1->A1_TIPO,         ,"001",)

				_cCliente :=  SA1->A1_COD
				If  Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
					_cCliente:= '043252'
				EndIf
				If SZD->(DbSeek(xFilial("SZD")+_cCliente+SB1->B1_COD))
					_cCodCli :=  SZD->ZD_CODCLI
				EndIf

				If Empty(_cCodCli)
					Loop
				EndIf

				If _nPDesc>0
					_nvDesc	:= Round(((	_nPDesc*_nPreco)/100),2)
					_nPreco := Round(_nPreco - _nvDesc,2)
				EndIf

				aVetor := {}
				aVetor := {;
					_cCnpj,;
					_cCodSte,;
					_cCodCli,;
					_cDesc,;
					_nPreco;
					}

				oExcel:AddRow("Analitico","Relatorio Analitico",aVetor)

			EndIf

			(cAliasLif)->(DBSKIP())
		EndDo

	ENDIF

RETURN oExcel
