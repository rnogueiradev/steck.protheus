#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTMKG02         | Autor | GIOVANI.ZAGO             | Data | 17/07/2018  |
|=====================================================================================|
|Descrição |    Regra de desconto        		 	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTMKG02                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\=====================================================================================
*/ 
*-----------------------------*
User Function STGAP01()
	*-----------------------------*
	Local nDesc := 0
	Local cProduto  := SB1->B1_COD
	Local cCliente  := SA1->A1_COD
	Local cLoja     := SA1->A1_LOJA
	Local cTabPreco := DA0->DA0_CODTAB
	Local cCondPg   := DA0->DA0_CONDPG
	Local cFormPg   := ACO->ACO_FORMPG
	Local nFaixa    := 0
	Local nTipo     := 1
	Local _LFun     := IsInCallSteck("MATA415")  
	Local cFunCampo := IIF(_LFun ,"M->CJ_CLIENTE","M->C5_CLIENTE")
	Private nRet	:= 0 
	Private _nCamDes:= 0
	
	//If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !Empty(&cFunCampo)
			
			//REGRA 01  CLIENTE-CABEÇALHO  &   PRODUTO-ITEM
			If STREG01(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			ElseIf STREG02(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			ElseIf STREG03(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			ElseIf STREG04(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			EndIf
			
		EndIf
	//EndIf
Return (nDesc)


Static Function STREG01(cProduto,cCliente,cLoja)
	
	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '
	
	cQuery := " SELECT ACP.ACP_PERDES DESCONTO
	cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
	cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
	cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
	cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
	cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
	cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
	cQuery += " AND ACP.ACP_CODPRO   = '"+cProduto+"'"
	cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
	cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
	cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	If  Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		nRet:= (cAliasLif)->DESCONTO
	EndIf

Return (nRet)



Static Function STREG02(cProduto,cCliente,cLoja)
	
	Local cAliasLif  := 'TMP02'
	Local cQuery     := ' '
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cProduto))
		
		
		cQuery := " SELECT ACP.ACP_PERDES DESCONTO
		cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
		cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
		cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
		cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
		cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
		cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
		cQuery += " AND ACP.ACP_CODPRO   = ' '"
		cQuery += " AND ACP.ACP_GRUPO    = '"+SB1->B1_GRUPO+"'"
		cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
		cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
		cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		
		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			nRet:= (cAliasLif)->DESCONTO
		EndIf
	EndIf
 
Return (nRet)


Static Function STREG03(cProduto,cCliente,cLoja)
	
	Local cAliasLif  := 'TMP03'
	Local cQuery     := ' '
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
		
		
		cQuery := " SELECT ACP.ACP_PERDES DESCONTO
		cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
		cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
		cQuery += " AND  ACO.ACO_CODCLI  = ' '"
		cQuery += " AND  ACO.ACO_LOJA    = ' '"
		cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
		cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
		cQuery += " AND ACP.ACP_CODPRO   = '"+cProduto+"'"
		cQuery += " AND ACP.ACP_GRUPO    = ' '"
		cQuery += " AND ACO.ACO_GRPVEN    = '"+SA1->A1_GRPVEN+"'"
		cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
		cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
		cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		
		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			nRet:= (cAliasLif)->DESCONTO
		EndIf
	EndIf
Return (nRet)



Static Function STREG04(cProduto,cCliente,cLoja)
	
	Local cAliasLif  := 'TMP04'
	Local cQuery     := ' '
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+cProduto))
			
			cQuery := " SELECT ACP.ACP_PERDES DESCONTO
			cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
			cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
			cQuery += " AND  ACO.ACO_CODCLI  = ' '"
			cQuery += " AND  ACO.ACO_LOJA    = ' '"
			cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
			cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
			cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
			cQuery += " AND ACP.ACP_CODPRO   = ' '"
			//cQuery += " AND ACP.ACP_GRUPO    = '"+SB1->B1_GRUPO+"'"
			cQuery += " AND ACO.ACO_GRPVEN   = '"+SA1->A1_GRPVEN+"'"
			cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
			cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
			cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
			cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
			cQuery := ChangeQuery(cQuery)
			
			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			
			If  Select(cAliasLif) > 0
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				nRet:= (cAliasLif)->DESCONTO
			EndIf
		EndIf
	EndIf
Return (nRet)
