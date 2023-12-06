#include 'Protheus.ch'
#include 'RwMake.ch'
#include 'Topconn.ch'

/*====================================================================================\
|Programa  | STTMKG02         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
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
//------------------------------------------------------------------------------------//
//Alterações Realizadas:
//------------------------------------------------------------------------------------//
//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568 
//FR - 23/11/2021 - Ticket #20211119024862 - Nova estrutura de oferta Steck
// + APOEMA para 2022
//------------------------------------------------------------------------------------//
//FR - 14/03/2022 - Alteração - Verificar se o campo B1_XCATEG e B1_XCATEG2 existem
//                  Na base antes de processar o desconto
//                  Pois na base P12 não haverá necessidade de criar estes campos
//------------------------------------------------------------------------------------//

*-----------------------------*
User Function STGAP01()
	*-----------------------------*
	Local nDesc := 0
	Local cProduto  := SB1->B1_COD
	Local cCliente  := SA1->A1_COD
	Local cLoja     := SA1->A1_LOJA
	Local cGrpVen   := SA1->A1_GRPVEN 		//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568
	Local cCategB1  := ""			 		//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568 categoria 1
	Local cCategB12 := ""			 		//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568 categoria 2
	Local cGrupo    := ""			 		//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568

	Local _nRe     := 0
	Local cTabPreco := DA0->DA0_CODTAB
	Local cCondPg   := DA0->DA0_CONDPG
	Local cFormPg   := ACO->ACO_FORMPG
	Local nFaixa    := 0
	Local nTipo     := 1
	Local _LFun     := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46") .OR. IsInCallSteck("U_STGAP01")
	Local cFunCampo := IIF(_LFun ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private nRet	:= 0
	Private _nCamDes:= 0

	//FR - 18/08/2021 - Projeto Nova Política Preços - CRM - #20210812015568
	Private cGrpPOLPRC := GetNewPar("ST_GRPPOL", 'C1,C2,C3,D1,D2,R1,R2,R3,R4,R5,E3,E4,E5')  //grupos de clientes que entram na nova política de preço
	Private cGrpPOL2   := GetNewPar("ST_GRPPO2", "E1,E2,I1,I2,I4,I5")  //FR - 29/12/2021

	If !cEmpAnt $ GetMv("STGAP01001",,"11#03")
		Return(0)
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		SB1->(DbCloseArea())
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(Dbseek(xFilial("SB1") + cProduto )) //B1_XCODSE='S' (schneider) usar modo antigo de desconto

			//FR - 14/03/2022 - ALTERAÇÃO - adequação para campos que não existem na base INDÚSTRIA
			If FieldPos("B1_XCATEG") > 0 .and. FieldPos("B1_XCATEG2") > 0
				cCategB1 := SB1->B1_XCATEG		//este campo será usado na composição da regra de desconto cascata
				cCategB12 := SB1->B1_XCATEG2

				//1. Avaliar se o canal do cliente (A1_GRPVEN) entra na nova política ou não
				If Alltrim(cGrpVen) $ Alltrim(cGrpPOLPRC)

					//POLÍTICA NOVA:
					//aqui vai contar PP, PB, PL (Produto Prescrito, Produto Básico, Produto Lançamento)
					_nRet := STREG05(cCategB1,cCliente,cLoja)		//TABELA Z01 - filtra cliente, loja, produto, aqui usa categoria 1
					nDesc  := _nRet

				Elseif Alltrim(cGrpVen) $ Alltrim(cGrpPOL2)  //POLÍTICA ADVANCED, PROFESSIONAL
					_nRet := STREG07(cCategB12,cCliente,cLoja)		//TABELA Z02 - filtra cliente, loja, produto aqui usa a categoria 2
					nDesc  := _nRet

				Endif

			Endif //se existem os campos B1_XCATEG , B1_XCATEG2

		Endif //seek do produto

	EndIf	//If ( Type("l410Auto") == "U" .OR. !l410Auto )

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
	Memowrite("C:\TEMP\STREG01.SQL",cQuery)
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
//	_nCamDes := U_STDESCAMP(cCliente,cLoja,cProduto)
	If _nCamDes <> 0
		//nRet:= 0
	EndIf
	/*
	If IsInCallSteck("U_STDESCAMP")
	_nCamDes := 0
	Else
	_nCamDes := U_STDESCAMP(cCliente,cLoja,cProduto)
	EndIf
	If GetMv("ST_DEPRO",,.T.)
	If	nRet < _nCamDes
	nRet:= 0
	EndIf
	Else
	If _nCamDes <> 0
	nRet:= 0
	EndIf
	EndIf
	*/

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
		Memowrite("C:\TEMP\STREG02.SQL",cQuery)
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
	//_nCamDes := U_STDESCAMP(cCliente,cLoja,cProduto)
	If _nCamDes <> 0
		//nRet:= 0
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
		Memowrite("C:\TEMP\STREG03.SQL",cQuery)
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
			cQuery += " AND ACP.ACP_GRUPO    = '"+SB1->B1_GRUPO+"'"
			cQuery += " AND ACO.ACO_GRPVEN   = '"+SA1->A1_GRPVEN+"'"
			cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
			cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
			cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
			cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
			Memowrite("C:\TEMP\STREG04.SQL",cQuery)
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


//FR - 16/08/2021 - TICKET #20210812015568 
/*-------------------------------------------------------------------------------------*/
//Programa:  - STREG05 - Retorna desconto conforme cascata de produtos x clientes
//             Onde A1_GRPVEN contido em : 'C1,C2,C3,D1,D2,R1,R2,R3,R4,R5,E3,E4,E5'
//Autoria : Flávia Rocha
//Data    :16/08/2021
//
/*-------------------------------------------------------------------------------------*/
Static Function STREG05(cCategB1,cCliente,cLoja)

	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '
	Local cClassCli  := ""
	//Local cClassX5   := ""
	Local cNivelX5   := ""

	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja))
	cClassCli := SA1->A1_XESCALA  //PL, OU, PR, BR (PLATINUM, OURO, PRATA, BRONZE)

	/*
	//EXEMPLO:
	SELECT Z01_CTGPRO CATEG, Z01_DESCN1 DESCBRONZE, Z01_DESCN2 DESCPRATA, Z01_DESCN3 DESCOURO, Z01_DESCN4 DESCPLATIN
	,X5_FILIAL, X5_TABELA, X5_CHAVE CODCLASS, X5_DESCRI, X5_DESCENG NIVEL 
	FROM  Z01110 Z01  
	INNER JOIN SX5110 SX5 
	ON X5_TABELA = 'Z0' 
	AND RTRIM(X5_CHAVE) = 'PL'
	AND SX5.D_E_L_E_T_ <> '*' 
	AND SX5.X5_FILIAL = '' 
	WHERE Z01.Z01_FILIAL = ''
	AND Z01.Z01_CTGPRO = 'PB' 
	*/

	cQuery := " SELECT Z01_CTGPRO CATEG, Z01_DESCN1 DESCBRONZE, Z01_DESCN2 DESCPRATA, Z01_DESCN3 DESCOURO, Z01_DESCN4 DESCPLATIN " + CRLF
	cQuery += " ,X5_FILIAL, X5_TABELA, X5_CHAVE CODCLASS, X5_DESCRI, X5_DESCENG NIVEL , X5_CHAVE

	cQuery += " FROM  "+RetSqlName("Z01")+" Z01  "+ CRLF
	cQuery += " INNER JOIN " + RetSqlName("SX5") + " SX5 "+ CRLF
	cQuery += " ON X5_TABELA = 'Z0' "+ CRLF
	cQuery += " AND RTRIM(X5_CHAVE) = '" + Alltrim(cClassCli) + "' "+ CRLF		//PLATINUM, OURO, PRATA, BRONZE
	cQuery += " AND SX5.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "' "

	cQuery += " WHERE Z01.Z01_FILIAL = '"+xFilial("Z01")+"'"+ CRLF
	cQuery += " AND Z01.Z01_CTGPRO = '"	 + cCategB1 + "' " + CRLF
	cQuery += " AND Z01.Z01_XCODSE <> 'S' " + CRLF 		//não Schneider

	Memowrite("C:\TEMP\STREG05.SQL",cQuery)
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If (cAliasLif)->(!Eof())
		(cAliasLif)->(dbgotop())

		//desconto base de todos
		cNivelX5 := Alltrim((cAliasLif)->NIVEL )
		nRet     := 0
		//FR - 02/12/2021 - não vai mais acumular os descontos, vai retornar apenas o desconto respectivo à categoria do cliente
		/*
		nRet     += (cAliasLif)->DESCBRONZE  //bronze é a base de todos os descontos, por isso ficou do lado de fora do if

		//conform sobe o nível, vai somando:
		//If "1" $ cNivelX5		//bronze
		//	nRet += (cAliasLif)->DESCBRONZE
		
		If "2" $ cNivelX5		//prata
			nRet += (cAliasLif)->DESCPRATA

		Elseif "3" $ cNivelX5  //ouro
			nRet += (cAliasLif)->DESCPRATA
			nRet += (cAliasLif)->DESCOURO

		ElseIf "4" $ cNivelX5  //platinum recebe todos somados
			nRet += (cAliasLif)->DESCPRATA
			nRet += (cAliasLif)->DESCOURO
			nRet += (cAliasLif)->DESCPLATIN				
		Endif
		*/

		If "1" $ cNivelX5		//bronze
			nRet := (cAliasLif)->DESCBRONZE

		ElseIf "2" $ cNivelX5		//prata
			nRet := (cAliasLif)->DESCPRATA

		Elseif "3" $ cNivelX5  //ouro
			nRet := (cAliasLif)->DESCOURO

		ElseIf "4" $ cNivelX5  //platinum
			nRet := (cAliasLif)->DESCPLATIN
		Endif

	Endif
Return (nRet)


//FR - 09/12/2021 - TICKET #20210812015568 
/*-------------------------------------------------------------------------------------*/
//Programa:  - STREG06 - Retorna desconto conforme cascata de produtos x clientes
//                       Para produtos Schneider
//             Onde A1_GRPVEN contido em : 'C1,C2,C3,D1,D2,R1,R2,R3,R4,R5,E3,E4,E5'
//Autoria : Flávia Rocha
//Data    : 09/12/2021
//
/*-------------------------------------------------------------------------------------*/
Static Function STREG06(cCategB1,cCliente,cLoja)

	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '
	Local cClassCli  := ""
	Local cNivelX5   := ""

	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja))
	cClassCli := SA1->A1_XESCALA  //PL, OU, PR, BR (PLATINUM, OURO, PRATA, BRONZE)

	cQuery := " SELECT Z01_CTGPRO CATEG, Z01_DESCN1 DESCBRONZE, Z01_DESCN2 DESCPRATA, Z01_DESCN3 DESCOURO, Z01_DESCN4 DESCPLATIN " + CRLF
	cQuery += " ,X5_FILIAL, X5_TABELA, X5_CHAVE CODCLASS, X5_DESCRI, X5_DESCENG NIVEL , X5_CHAVE

	cQuery += " FROM  "+RetSqlName("Z01")+" Z01  "+ CRLF
	cQuery += " INNER JOIN " + RetSqlName("SX5") + " SX5 "+ CRLF
	cQuery += " ON X5_TABELA = 'Z0' "+ CRLF
	cQuery += " AND RTRIM(X5_CHAVE) = '" + Alltrim(cClassCli) + "' "+ CRLF		//PLATINUM, OURO, PRATA, BRONZE
	cQuery += " AND SX5.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "' "

	cQuery += " WHERE Z01.Z01_FILIAL = '"+xFilial("Z01")+"'"+ CRLF
	cQuery += " AND Z01.Z01_CTGPRO = '"	 + cCategB1 + "' " + CRLF
	cQuery += " AND Z01.Z01_XCODSE = 'S' "		//Schneider = Sim

	Memowrite("C:\TEMP\STREG06.SQL",cQuery)
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If (cAliasLif)->(!Eof())
		(cAliasLif)->(dbgotop())

		//desconto base de todos
		cNivelX5 := Alltrim((cAliasLif)->NIVEL )
		nRet     := 0

		If "1" $ cNivelX5		//bronze
			nRet := (cAliasLif)->DESCBRONZE

		ElseIf "2" $ cNivelX5		//prata
			nRet := (cAliasLif)->DESCPRATA

		Elseif "3" $ cNivelX5  //ouro
			nRet := (cAliasLif)->DESCOURO

		ElseIf "4" $ cNivelX5  //platinum
			nRet := (cAliasLif)->DESCPLATIN
		Endif

	Endif

Return (nRet)


//FR - 09/12/2021 - TICKET #20210812015568 
/*-------------------------------------------------------------------------------------*/
//Programa:  - STREG07 - Retorna desconto conforme cascata de produtos x clientes
//                       Para produtos categoria Advanced,Professional 
//                       E grupo de vendas A1_GRPVEN contido em: E1, E2, I1, I2, I4, I5
//Autoria : Flávia Rocha
//Data    : 09/12/2021
//
/*-------------------------------------------------------------------------------------*/
Static Function STREG07(cCategB1,cCliente,cLoja)

	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '
	Local cClassCli  := ""
	//Local cNivelX5   := ""

	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja))
	cClassCli := SA1->A1_XESCALA  //PL, OU, PR, BR (PLATINUM, OURO, PRATA, BRONZE)

/*
SELECT Z02_CTGPRO CATEGPRO,  Z02_CTGCLI CATEGCLI,  Z02_DESCON DESCON,  X5_FILIAL,  X5_TABELA,  
X5_CHAVE CODCLASS,  X5_DESCRI,  Z02_CTGCLI,  X5_CHAVE 
 FROM  Z02110 Z02 INNER JOIN SX5110 SX5 
 ON X5_TABELA = 'Z0' 
 AND RTRIM(X5_CHAVE) = 'AD' 
 AND RTRIM(X5_CHAVE) = RTRIM(Z02_CTGCLI) 
 AND SX5.D_E_L_E_T_ <> '*' 
 AND SX5.X5_FILIAL = '  '  WHERE Z02.Z02_FILIAL = '  '
 AND Z02.Z02_CTGPRO = 'OI'
*/

	cQuery := " SELECT Z02_CTGPRO CATEGPRO, "	+ CRLF
	cQuery += " Z02_CTGCLI CATEGCLI, "			+ CRLF
	cQuery += " Z02_DESCON DESCON, " 			+ CRLF
	cQuery += " X5_FILIAL, "					+ CRLF
	cQuery += " X5_TABELA, "					+ CRLF
	cQuery += " X5_CHAVE CODCLASS, "			+ CRLF
	cQuery += " X5_DESCRI,  "					+ CRLF
	cQuery += " Z02_CTGCLI, "					+ CRLF
	cQuery += " X5_CHAVE "						+ CRLF

	cQuery += " FROM  "+RetSqlName("Z02")+" Z02  "+ CRLF
	cQuery += " INNER JOIN " + RetSqlName("SX5") + " SX5 "+ CRLF
	cQuery += " ON X5_TABELA = 'Z0' "+ CRLF
	cQuery += " AND RTRIM(X5_CHAVE) = '" + Alltrim(cClassCli) + "' "+ CRLF		//ADVANCED, PROFESSIONAL
	cQuery += " AND RTRIM(X5_CHAVE) = RTRIM(Z02_CTGCLI) " + CRLF
	cQuery += " AND SX5.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "' "

	cQuery += " WHERE Z02.Z02_FILIAL = '"+xFilial("Z02")+"'"+ CRLF
	cQuery += " AND Z02.Z02_CTGPRO = '"	 + cCategB1 + "' "
	cQuery += " AND Z02.Z02_XCODSE <> 'S' " + CRLF  //Não Schneider


	Memowrite("C:\TEMP\STREG07.SQL",cQuery)
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If (cAliasLif)->(!Eof())
		(cAliasLif)->(dbgotop())

		nRet     := 0

		nRet := (cAliasLif)->DESCON

	Endif

Return (nRet)

/*-------------------------------------------------------------------------------------*/
//Programa:  - STREG08 - Retorna desconto conforme cascata de produtos x clientes
//                       Para produtos categoria Advanced,Professional 
//                       E grupo de vendas A1_GRPVEN contido em: E1, E2, I1, I2, I4, I5
//                       Para produtos Schneider
//Autoria : Flávia Rocha
//Data    : 09/12/2021
//
/*-------------------------------------------------------------------------------------*/
Static Function STREG08(cCategB1,cCliente,cLoja)

	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '
	Local cClassCli  := ""
	//Local cNivelX5   := ""

	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja))
	cClassCli := SA1->A1_XESCALA  //PL, OU, PR, BR (PLATINUM, OURO, PRATA, BRONZE)

/*
SELECT Z02_CTGPRO CATEGPRO,  Z02_CTGCLI CATEGCLI,  Z02_DESCON DESCON,  X5_FILIAL,  X5_TABELA,  
X5_CHAVE CODCLASS,  X5_DESCRI,  Z02_CTGCLI,  X5_CHAVE 
 FROM  Z02110 Z02 INNER JOIN SX5110 SX5 
 ON X5_TABELA = 'Z0' 
 AND RTRIM(X5_CHAVE) = 'AD' 
 AND RTRIM(X5_CHAVE) = RTRIM(Z02_CTGCLI) 
 AND SX5.D_E_L_E_T_ <> '*' 
 AND SX5.X5_FILIAL = '  '  WHERE Z02.Z02_FILIAL = '  '
 AND Z02.Z02_CTGPRO = 'OI'
*/

	cQuery := " SELECT Z02_CTGPRO CATEGPRO, "	+ CRLF
	cQuery += " Z02_CTGCLI CATEGCLI, "			+ CRLF
	cQuery += " Z02_DESCON DESCON, " 			+ CRLF
	cQuery += " X5_FILIAL, "					+ CRLF
	cQuery += " X5_TABELA, "					+ CRLF
	cQuery += " X5_CHAVE CODCLASS, "			+ CRLF
	cQuery += " X5_DESCRI,  "					+ CRLF
	cQuery += " Z02_CTGCLI, "					+ CRLF
	cQuery += " X5_CHAVE "						+ CRLF

	cQuery += " FROM  "+RetSqlName("Z02")+" Z02  "+ CRLF
	cQuery += " INNER JOIN " + RetSqlName("SX5") + " SX5 "+ CRLF
	cQuery += " ON X5_TABELA = 'Z0' "+ CRLF
	cQuery += " AND RTRIM(X5_CHAVE) = '" + Alltrim(cClassCli) + "' "+ CRLF		//ADVANCED, PROFESSIONAL
	cQuery += " AND RTRIM(X5_CHAVE) = RTRIM(Z02_CTGCLI) " + CRLF
	cQuery += " AND SX5.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "' "

	cQuery += " WHERE Z02.Z02_FILIAL = '"+xFilial("Z02")+"'"+ CRLF
	cQuery += " AND Z02.Z02_XCODSE = 'S' " + CRLF 		//Schneider Sim
	cQuery += " AND Z02.Z02_CTGPRO = '"	 + cCategB1 + "' "


	Memowrite("C:\TEMP\STREG08.SQL",cQuery)
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If (cAliasLif)->(!Eof())
		(cAliasLif)->(dbgotop())

		nRet     := 0

		nRet := (cAliasLif)->DESCON

	Endif

Return (nRet)







/*-------------------------------------------------------------------------------------*/
//Programa:  - Cadastro de Classificações p/ Clientes
//Autoria : Flávia Rocha
//Data    : 16/08/2021
//
/*-------------------------------------------------------------------------------------*/
User Function STFATC01()

	Local   aIndexYL    := {}
	Local   aCampos  	:= {}
	Local   aCores      := {}
	Local   xArea		:= {}
	Local   cFiltro		:= ""

	Private cCadastro   := ""
	Private cString 	:= "SX5"
	Private cDelFunc    := .T.
	Private aRotina     := {}


	cCadastro	:= "Cadastro de Classificações para Cliente"
	aCampos     :={}
	cDelfunc    :=".T."


	cFiltro	:= "X5_TABELA == 'Z0'"

	Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
	{"Visualizar"   ,	"U_fManutZ0" 	,0,2},;  	// Visualizar
	{"Incluir"     ,	"U_fManutZ0"	,0,3},;	    // Incluir
	{"Excluir"	   ,    "U_fManutZ0"	,0,4};      // Excluir
	}

	aCampos:={{"Codigo"		 		,"X5_CHAVE" 	,"C"	,6	,0	,"@X"},;
		{"Descricao Escala"	,"X5_DESCRI" 	,"C"	,30	,0	,"@!"},;
		{"Nível"				,"X5_DESCENG" 	,"C"	,30	,0	,"@!"};
		}

	If !Empty(cFiltro)
		bFiltraBrw	:= { || FilBrowse(cString, @aIndexYL, @cFiltro) }
		Eval(bFiltraBrw)
	EndIf

	DbSelectArea(cString)
	aAdd( xArea, (cString)->( getArea() ) )
	(cString)->(OrdSetFocus(1))

	mBrowse( 6, 1,22,75, cString, aCampos,,,,,aCores)

	EndFilBrw(cString, aIndexYL)

Return



//abre tela manutenção da tabela de cadastro de CLASSIFICAÇÕES PARA CLIENTES
/*-------------------------------------------------------------------------------------*/
//Programa: fManutZ0 - Cadastro de Escalas Clientes
//Autoria : Flávia Rocha
//Data    : 16/08/2021
//
/*-------------------------------------------------------------------------------------*/
User Function fManutZ0(cAlias,nReg,nOpc)
	Local oButton2
	Local oGet1
	Local oGet2
	Local oGroup1
	Local oSay1
	Local nOpcao  	:= 0

	Local lEdita  	:= .F.
	Local cCodClass	:= ""
	Local cDescClass:= ""
	Local cCodX5   	:= ""
	Local cNivel    := ""
	Local aNiveis   := {}
	Local oTButton

	Default cCadastro := "Cadastro de Escalas Clientes"

	Static oDlg

	If nOpc = 3 		//incluir
		//cCodX5		:= fProxSX5()
		cCodClass 	:= Space(2)
		cDescClass  := Space(30)
		lEdita 		:= .T.
	Else

		cCodClass := SX5->X5_DESCRI //pega a sigla da classificação, ex.: PL = PLATINUM, OU = OURO
		cDescClass:= Alltrim(SX5->X5_DESCSPA)
		cNivel    := Alltrim(SX5->X5_DESCENG)

	Endif

	aNiveis := {" " ,"F1", "F2", "F3", "F4"}

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000  TO 260,609 COLORS 0, 16777215 PIXEL

	@ 005, 004 GROUP oGroup1 TO 084,294 PIXEL OF oDlg /*COLOR 0, 16777215*/
	@ 026, 015 SAY   oSay1   PROMPT "Código Classific." 	SIZE 050,010              														PIXEL OF oDlg /*COLORS 0, 16777215*/
	@ 024, 057 MSGET oGet1   VAR    cCodClass  PICTURE "@!"	SIZE 060,010   WHEN lEdita  /*VALID (lTUDOK:= fTUDOK(cCodClass))*/				PIXEL OF oDlg /*COLORS 0, 16777215*/
	@ 046, 017 SAY   				"Descrição"         	SIZE 041,010              														PIXEL OF oDlg 							   /*COLORS 0, 16777215*/
	@ 042, 057 MSGET oGet2   VAR    cDescClass PICTURE "@!"	SIZE 198, 012  WHEN lEdita  /*VALID (lTUDOK:= fTUDOK(cCodClass,cDescClass))*/	PIXEL OF oDlg /*COLORS 0, 16777215*/
	@ 066, 017 SAY   				"Nivel		"         	SIZE 041,010              														PIXEL OF oDlg 							   /*COLORS 0, 16777215*/
	@ 062 ,057 MSCOMBOBOX oCombo VAR cNivel ITEMS aNiveis 	SIZE 056,50 																	PIXEL OF oDlg

	oTButton:= TButton():New( 096,193, "Confirmar",oDlg,{|| (nOpcao := 1 , lTUDOK := fTUDOK(nOpc,cCodClass,cDescClass,cNivel), iif(lTUDOK,oDlg:End(),nOpcao := 0) ) }, 37,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	@ 096,250 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 012 OF oDlg  ACTION (nOpcao := 0, oDlg:End())PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpcao = 1
		If nOpc =  4  //excluir

			If MsgYesNo("Confirma a Exclusão ?")

				If SX5->X5_TABELA == 'Z0'
					Reclock("SX5", .F.)
					SX5->(Dbdelete())
					SX5->(MsUnlock())
				Endif

			Endif

		Else
			/* Removido\Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
			Reclock("SX5", .T.)
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := 'Z0'
			//SX5->X5_CHAVE  := cCodX5
			SX5->X5_CHAVE := cCodClass
			//SX5->X5_DESCRI := cCodClass
			SX5->X5_DESCRI := Alltrim(cDescClass)
			SX5->X5_DESCSPA:= Alltrim(cDescClass)
			SX5->X5_DESCENG:= Alltrim(cNivel)
			SX5->(Msunlock())*/

		Endif
		//MSGINFO("GRAVOU")
	Endif

	SX5->(Dbgotop())

Return

//==================================================================================//
//Função  : fTUDOK  
//Autoria : Flávia Rocha
//Data    : 18/08/2021
//Objetivo: Função para verificar se a sigla digitada já existe na SX5 - TABELA Z0
//==================================================================================//
Static Function fTUDOK(nOpc,cCodClass,cDescClass,cNivel)
	Local lOK 		:= .T.
	Local lTem   	:= .F.
	Local cQuery 	:= ""

	If nOpc <> 4  //se não for excluir
		If Empty(cCodClass)
			lOK := .F.
			MsgAlert("Sigla Precisa ser Preenchida")
		Endif

		If cDescClass <> Nil
			If Empty(cDescClass)
				lOK := .F.
				MsgAlert("Descrição Precisa ser Preenchida")
			Endif
		Endif

		If cNivel <> Nil
			If Empty(cNivel)
				lOK := .F.
				MsgAlert("Nivel Precisa ser Preenchido")
			Endif
		Endif

		cQuery := " SELECT X5_TABELA, X5_CHAVE, X5_DESCRI, X5_DESCSPA "
		cQuery += " FROM " + RetSqlname("SX5") + " SX5 "
		cQuery += " WHERE SX5.D_E_L_E_T_=' ' "
		cQuery += " AND X5_TABELA = 'Z0' "
		//cQuery += " AND X5_DESCRI IN ( '" + Alltrim(cCodClass) + "' ) "
		cQuery += " AND RTRIM(X5_CHAVE) = '" + Alltrim(cCodClass) + "' "		//EX.: se digitar PR e já existir PR não deixará prosseguir

		cQuery := ChangeQuery(cQuery)

		Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)

		TcQuery cQuery New Alias "XF3TAB"

		XF3TAB->(dbSelectArea("XF3TAB"))
		XF3TAB->(dbGoTop())

		If !XF3TAB->(EOF())
			lTem := .T.
		Endif

		XF3TAB->(dbSelectArea("XF3TAB"))
		DbCloseArea()

		If lTem
			MsgAlert("Sigla Já Existe!")
			lOk := .F.
		Endif

	Endif
Return(lOK)



//==================================================================================//
//Função  : fProxSX5  
//Autoria : Flávia Rocha
//Data    : 18/08/2021
//Objetivo: Função para trazer o próximo código livre SX5 - TABELA Z0
//==================================================================================//
Static Function fProxSX5()
	Local cQuery := ""
	Local cCodRet:= ""

	cQuery := " SELECT MAX(X5_CHAVE) CODIGO "
	cQuery += " FROM " + RetSqlname("SX5") + " SX5 "
	cQuery += " WHERE SX5.D_E_L_E_T_=' ' "
	cQuery += " AND X5_TABELA = 'Z0' "
	cQuery += " GROUP BY X5_CHAVE "
	cQuery += " ORDER BY X5_CHAVE DESC "

//MemoWrite("D:\TMPQRY\PROXSU5.SQL" , cQuery )

	cQuery := ChangeQuery(cQuery)

	Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)

	TcQuery cQuery New Alias "XF3TAB"

	XF3TAB->(dbSelectArea("XF3TAB"))
	XF3TAB->(dbGoTop())

	If !XF3TAB->(EOF())

		cCodRet := XF3TAB->CODIGO
		cCodRet := SOMA1(cCodRet)

	Endif

	If Empty(cCodRet)
		cCodRet := "000001"
	Endif

	SX5->(OrdSetFocus(1))  //X5_FILIAL+X5_TABELA+X5_CHAVE
	While SX5->( DbSeek( xFilial( "SX5" ) + 'Z0' + cCodRet ) )
		ConfirmSX8()
		cCodRet := SOMA1(cCodRet)
	Enddo

	XF3TAB->(dbSelectArea("XF3TAB"))
	DbCloseArea()

Return(cCodRet)


//tela para manuteção do cadastro das regras de desconto
//FR - 18/08/2021
/*==========================================================================
|Funcao    | fCADZ01            | Flávia Rocha          | Data | 18/08/2021|
============================================================================
|Descricao | Cadastro de Regras Desconto                 				   |
|Cliente   | STECK                                                         |
============================================================================
|Observações: CRM														   |
==========================================================================*/
User Function fCADZ01()
	Local cAlias
	Local aCampos
	Local aCores
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina   := {{"Pesquisar" 		,"AxPesqui"   ,0 ,1} ,;
    	         		{"Visualizar"		,"U_fManuZ01" ,0 ,2} ,;
    	         		{"Incluir"          ,"U_fManuZ01" ,0 ,3} ,;  
            	 		{"Alterar" 			,"U_fManuZ01" ,0 ,4} ,;            	 	
            	 		{"Excluir" 			,"U_fManuZ01" ,0 ,5} ,;
						{"Classif.Clientes"	,"U_STFATC01" ,0 ,3} ,;
            	 		{"Legenda"  		,"U_fZ01Leg"  ,0 ,7} }            	 		
            	 	
	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro de Regras de Desconto"
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z01"
	aCampos 	:= {}	

    aCores := {}
	/*
	aCores := {	{ 'Z01->Z01_CTGPRO == "PB"'   ,'BR_AZUL' },;
				{ 'Z01->Z01_CTGPRO == "PL"'   ,'ENABLE'  },;
           		{ 'Z01->Z01_CTGPRO == "PP"'   ,'BR_CINZA'}; 	
           	  }
	*/ 	
	//FR  15/12 - Equipe Comercial solicitou mudar as nomenclaturas
	aCores := {	{ 'Z01->Z01_CTGPRO == "OB"'   ,'BR_AZUL'   },;
		{ 'Z01->Z01_CTGPRO == "OE"'   ,'ENABLE'    },;
		{ 'Z01->Z01_CTGPRO == "OP"'   ,'BR_CINZA'  },;
		{ 'Z01->Z01_CTGPRO == "OI"'   ,'BR_MARRON_OCEAN'    },;
		{ 'Z01->Z01_CTGPRO == "OC"'   ,'BR_VIOLETA'   };
		}

	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(1))
	xArea       := GetArea()

	mBrowse( 6, 1,22,75, cAlias, aCampos,,,,,aCores)

	RestArea(xArea)

Return

/*==========================================================================
|Funcao    | fCADZ02            | Flávia Rocha          | Data | 18/08/2021|
============================================================================
|Descricao | Cadastro de Regras Desconto                 				   |
|Cliente   | STECK                                                         |
============================================================================
|Observações: CRM														   |
==========================================================================*/
User Function fCADZ02()
	Local cAlias
	Local aCampos
	Local aCores
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }      	 		
            	 	
	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro de Regras de Desconto Professional/Advanced "
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z02"
	aCampos 	:= {}	

    aCores := {}
	/*
	aCores := {	{ 'Z01->Z01_CTGPRO == "PB"'   ,'BR_AZUL' },;
				{ 'Z01->Z01_CTGPRO == "PL"'   ,'ENABLE'  },;
           		{ 'Z01->Z01_CTGPRO == "PP"'   ,'BR_CINZA'}; 	
           	  }
	*/ 	


	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(2))
	xArea       := GetArea()

	mBrowse( 6, 1,22,75, cAlias, aCampos,,,,,aCores)

	RestArea(xArea)

Return




/*==========================================================================
|Funcao    | fZ01Leg          | Flávia Rocha          | Data |   18/08/2021|
============================================================================
|Descricao | Legenda do Browse do cadastro das regras de desconto		   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fZ01Leg()

/*
BrwLegenda(cCadastro,,{ {"ENABLE"    ,"Produto Lançamento" },;
   					    {"BR_AZUL" 	 ,"Produto Básico"},;
						{"BR_CINZA"  , "Produto Prescrito"} } )	

	aCores := {	{ 'Z01->Z01_CTGPRO == "OB"'   ,'BR_AZUL'   },;
				{ 'Z01->Z01_CTGPRO == "OE"'   ,'ENABLE'    },;
           		{ 'Z01->Z01_CTGPRO == "OP"'   ,'BR_CINZA'  },;
			    { 'Z01->Z01_CTGPRO == "OI"'   ,'BR_MARRON_OCEAN'    },; 	 	
				{ 'Z01->Z01_CTGPRO == "OC"'   ,'BR_VIOLETA'   }; 	

*/

	BrwLegenda(cCadastro,,{ {"BR_AZUL" 	 		,"Oferta Básica"	 		},;
		{"ENABLE"    		,"Oferta Especial"  		},;
		{"BR_CINZA"  		,"Oferta Prescrita"			},;
		{"BR_MARRON_OCEAN"	,"Oferta Industrialização"	},;
		{"BR_VIOLETA"  		,"Oferta Complementar"		};
		} )


Return .T.

/*==========================================================================
|Funcao    | fManuZ01          | Flávia Rocha          | Data | 18/08/2021|
============================================================================
|Descricao | Tela principal de Cadastro de Regras Desconto        		   |
|          |                                                               |
============================================================================
|Observações: CRM														   |
==========================================================================*/
User Function fManuZ01(cAlias,nRec,nOpc)
	Local   aPos1
	Local   aPos2
	Local   aPos3
	Local   aSizeAut
	Local   xArea
		
	Local   nLin1
	Local   nLin2
	Local   nCol1
	Local   nCol2
	Local   nOpca
	Local   lTemZ0 := .F. 

	Private oFont2
	Private oBtOk	
	Private oBtCancela	
	Private oOk   
	Private oNo
	Private oTela
	
	Private lOk
	Private lSai    
	Private lCriouVar   
	Private lEdita
	//Private lClicaBotao
		     
	Private cOpcao      := ""
	Private cFili		:= ""
	Private cTiProd		:= Space(1)
	Private cDescTipo   := Space(30)
		
	Private aObjects:= {}								
	Private aSize   := {}  				
	Private aInfo   := {}								
	Private aPos    := {}

	//FR - 02/12/2021 - não precisa mais destes limites
	/*
	Private nDescBBRO := GetNewPar("ST_DSCBBRO" ,50) //limite desconto produto categoria BRONZE, BÁSICOS
	Private nDescPBRO := GetNewPar("ST_DSCPBRO" ,45) //limite desconto produto categoria BRONZE, PRESCRITO
	Private nDescLBRO := GetNewPar("ST_DSCLBRO" ,54) //limite desconto produto categoria BRONZE, LANÇAMENTO
	
	Private nDescBPRA := GetNewPar("ST_DSCBPRA" ,7) //limite desconto produto categoria PRATA, BÁSICOS
	Private nDescPPRA := GetNewPar("ST_DSCPPRA" ,10) //limite desconto produto categoria PRATA, PRESCRITO
	Private nDescLPRA := GetNewPar("ST_DSCLPRA" ,2) //limite desconto produto categoria PRATA, LANÇAMENTO
	
	Private nDescBOUR := GetNewPar("ST_DSCBOUR" ,5) //limite desconto produto categoria OURO, BÁSICOS
	Private nDescPOUR := GetNewPar("ST_DSCPOUR" ,5) //limite desconto produto categoria OURO, PRESCRITO
	Private nDescLOUR := GetNewPar("ST_DSCLOUR" ,2) //limite desconto produto categoria OURO, LANÇAMENTO 
	
	Private nDescBPLA := GetNewPar("ST_DSCBPLA" ,5) //limite desconto produto categoria PLATINUM, BÁSICOS
	Private nDescPPLA := GetNewPar("ST_DSCPPLA" ,10) //limite desconto produto categoria PLATINUM, PRESCRITO
	Private nDescLPLA := GetNewPar("ST_DSCLPLA" ,5) //limite desconto produto categoria PLATINUM, LANÇAMENTO
	*/
	Static oDlg

	oFont2		:= TFont():New("Arial",,014,,.F.,,,,,.F.,.F.)
	oBtOk
	oBtCancela

	lOk       	:= .T.
	lSai		:= .F.

	oNeutro    	:= LoadBitmap( GetResources(), "ENABLE" )
	oCons    	:= LoadBitmap( GetResources(), "BR_AMARELO" )
	oDev    	:= LoadBitmap( GetResources(), "BR_AZUL" )
	oEncerr     := LoadBitmap( GetResources(), "BR_PRETO" )
	oOk       	:= LoadBitmap( GetResources(), "LBOK" )
	oNo       	:= LoadBitmap( GetResources(), "LBNO" )
	bLineIT   	:= Nil

	lEdita	    := .T.   	//FR - USADA NA CHAMADA REGTOMEMORY

	aPos1       := {}
	aPos2       := {}
	aPos3       := {}

	xArea       := {}

	cOpcao      := ""
	cFili		:= ""
	cTiProd		:= ""
	//cClasCli    := ""
	nDescN1 	:= 0
	nDescN2     := 0
	nDescN3     := 0
	nDescN4     := 0

	oTela
	nOpca := 1

	If nOpc = 3
		cOpcao := "INCLUSÃO"
		lEdita := .T.

	ElseIf nOpc = 4
		cOpcao      := "ALTERAÇÃO"
		lEdita      := .T.

	Elseif nOpc = 5
		cOpcao := "EXCLUSÃO"
		lEdita := .F.

	Else
		cOpcao := "VISUALIZAÇÃO"
		lEdita := .F.
	Endif

	SX5->(OrdSetFocus(1))
	If SX5->(Dbseek(xFilial("SX5") + 'Z0'))
		lTemZ0 := .T.
	Endif

	If !lTemZ0 //se não tiver registro das classificações de clientes, não deixa prosseguir

		MsgAlert("Por Favor, Cadastre as Classificações Clientes")		//PLATINUM, OURO, PRATA , BRONZE
		Return .F.
	Endif


	xArea       := GetArea()
	Z01->(OrdSetFocus(1))

	RegToMemory("Z01",Iif(nOpc <> 3,.F.,lEdita))   				//Cabeçalho da Contagem, chama as variáveis de memória para os gets

	cFili		:= Iif(nOpc = 3, xFilial("Z01"), Z01->Z01_FILIAL)
	cTiProd		:= Iif(nOpc = 3, M->Z01_CTGPRO , Z01->Z01_CTGPRO)
	nDescN1 	:= Iif(nOpc = 3, M->Z01_DESCN1 , Z01->Z01_DESCN1)
	nDescN2     := Iif(nOpc = 3, M->Z01_DESCN2 , Z01->Z01_DESCN2)
	nDescN3     := Iif(nOpc = 3, M->Z01_DESCN3 , Z01->Z01_DESCN3)
	nDescN4     := Iif(nOpc = 3, M->Z01_DESCN4 , Z01->Z01_DESCN4)


	aSizeAut := MsAdvSize(,.F.,400)
	/*
	//Medidas do aSizeAut:
	aSizeAut[1] =    0
	aSizeAut[2] =   30
	aSizeAut[3] =  953
	aSizeAut[4] =  446     ,	aSizeAut[5] = 1906
	aSizeAut[6] =  892
	aSizeAut[7] =    0
	aSizeAut[8] =    5
	*/

	//========================================//
	//GERA A DIALOG PRINCIPAL
	//========================================//
	nLiIni := aSizeAut[1] 		//0
	nCoIni := aSizeAut[8] 		//5
	nLiFim := aSizeAut[4]+100 	//446+100=546
	nCoFim := aSizeAut[6]*2 	//892*2= 1784


	DEFINE MSDIALOG oDlg TITLE "Cadastro Regras Desconto - " + cOpcao From nLiIni, nCoIni  TO nLiFim, nCoFim OF oMainWnd PIXEL STYLE DS_MODALFRAME

	aPos1 := fFRTela(oDlg,"TOT")
	//Medidas do aPos1:
	/*
	aPos1[1] 		//1
	aPos1[2]		//1
	aPos1[3]		//269.5
	aPos1[4]		//891.5
	*/

	//Tela com os Gets de campos da tabela: Z84
	oTela := MsMget():New("Z01",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.)
	oTela:Refresh()

	nLin1 := aPos1[1] 	    //1
	nCol1 := aPos1[2]     	//1
	nLin2 := aPos1[3]-30	//269.5-30=239.5
	nCol2 := aPos1[4]-100 	//891.5-100=791.5

	DEFINE SBUTTON oBtOk      FROM nLin2,nCol2-80 TYPE 1 OF oDlg  ENABLE ACTION  Processa( {|| lOk := fGRaVZ01(nOpc,cTiProd), Iif(lOk,oDlg:End(),.F.) } )
	DEFINE SBUTTON oBtCancela FROM nLin2,nCol2-40 TYPE 2 OF oDlg  ENABLE ACTION  ( iif(fFecha(nOpc),oDlg:End(),.F.))

	ACTIVATE MSDIALOG oDlg Centered

	RestArea( xArea )

Return

/*==========================================================================
|Funcao    | fFecha             | Flávia Rocha          | Data | 18/08/2021|
============================================================================
|Descricao | Função auxiliar que determina o fechamento da Dialog Principal|
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fFecha(xOpc)
	Local lFecha := .F.
	
	If xOpc <> 5 .and. xOpc <> 2  		//qdo for Excluir ou Visualizar, não faz a pergunta
		If MsgYesNo("Deseja Realmente Sair ? ")		
			lFecha := .T.  	
		Endif
	Else
		lFecha := .T.
	Endif
	
Return(lFecha)

/*==========================================================================
|Funcao    | fFRTela           | Flávia Rocha          | Data | 26/08/2015 |
============================================================================
|Descricao  | Função para posicionar todo o objeto na Dialog  			   | 
|Parametros | oBjet = Objeto a ser dimencionado                            |
|           | cTipo = Tipo de posicionamento                               |
|         	|		"UP"   = Posiciona na parte de cima da Dialog          |
|          	|		"DOWN" = Posiciona na parte de baixo da Dialog         |
|          	|		"TOT"  = Posiciona em toda Dialog                      |
|           |                                                              |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fFRTela(oBjet,cTipo,xVerMDI)

Local aPosicao := {}

Do Case
	Case cTipo = "TOT"
		aPosicao    := {1,1,(oBjet:nClientHeight-6)/2,(oBjet:nClientWidth-4)/2}
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)
		EndIf
		
	Case cTipo = "UP"
		aPosicao:= {1,1,(oBjet:nClientHeight-6)/4-1,(oBjet:nClientWidth-4)/2}
		//Versão MDI
		If Empty(xVerMDI)
			If SetMdiChild()
				aPosicao[3] += 4
				aPosicao[4] += 3
			EndIf
		EndIf
		
	Case cTipo = "DOWN"
		aPosicao:= {(oBjet:nClientHeight-6)/4+1,1,(oBjet:nClientHeight-6)/4-2,(oBjet:nClientWidth-4)/2}
		//Versão MDI
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)			
		EndIf

End Case

Return(aPosicao)


//-----------------------//
//FUNÇÕES PARA GRAVAÇÃO:
//-----------------------//
/*==========================================================================
|Funcao    | fGravZ01              | Flávia Rocha       | Data | 18/08/2021|
============================================================================
|Descricao | Efetua validações e chama rotinas para gravação das           |
|          | informações de tela.                                          |
============================================================================
|Observações: CRM														   |
==========================================================================*/
Static Function fGRaVZ01(xOpc,xTiProd)        
	Local lContinua   := .T.
    Local lDel        := .F.
	Local lNew        := .F.
	Local xAlias      := ""
	Local nInd		  := 0
	
	xAlias := "Z01"
	  
	If xOpc = 3
		lNew     := .T. //lock que será feito na tabela, .T. para inclusão, .F. para alteração	
				
	Elseif xOpc = 4 .or. xOPc = 5 
		lNew := .F.
	
		If xOpc = 5
			lDel := .T.
		Endif		

	Endif
	
	/*
	ORDEM	CAMPO  TIPO TAMANHO DECIMAL TITULO  DESCRIÇÃO                   OPÇÕES                               OBRIGATÓRIO
	01	Z01_FILIAL	C	2	0	Filial      	Filial do Sistema        	                                         
	02	Z01_CTGPRO	C	2	0	Categoria		Categ Produto             	1=Básico;2=Prescrito;3=Lançamento        
	03	Z01_DESCN1	N	3	0	Descon.Bronz	Desconto Nivel Bronze    	                                       	x
	04	Z01_DESCN2	N	3	0	Descon.Prata	Desconto Nivel Prata     	                                        
	05	Z01_DESCN3	N	3	0	Descon.Ouro 	Desconto Nivel Ouro      	                                        
	06	Z01_DESCN4	N	3	0	Desc.Platinu	Desconto Nivel Platinum  	                                        
	*/

	If xOpc <> 2
		cMsg      := 'Campos Obrigatórios: ' + CHR(13) + CHR(10) + CHR(13) + CHR(10)

		If xOpc = 3 .or. xOpc = 4   	//Incluir ou alterar

			If Empty(M->Z01_CTGPRO)
				cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Categ Prod' "+ CHR(13) + CHR(10)
				lContinua  := .F.

			Elseif Z01->(Dbseek(xFilial("Z01") + M->Z01_CTGPRO))
				If Z01->Z01_XCODSE == M->Z01_SCODSE  //não pode repetir esses campos juntos categoria + flag schneider
					cMsg += "Categoria Já Cadastrada !" + CHR(13) + CHR(10)
					lContinua := .F.
				Endif

			Endif
			/*
			If Empty(M->ZTM_CLASCL)
		 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Classificação Cliente' "+ CHR(13) + CHR(10) 
				lContinua  := .F.
			Endif
			*/

			If lContinua

				If Empty(M->Z01_DESCN1)
					cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Desconto Nível Bronze' "+ CHR(13) + CHR(10)
					//lContinua  := .F.  //pode ter desconto = 0%
				Endif

				If Empty(M->Z01_DESCN2)
					cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Desconto Nível Prata' "+ CHR(13) + CHR(10)
					//lContinua  := .F.	//pode ter desconto = 0%
				Endif

				If Empty(M->Z01_DESCN3)
					cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Desconto Nível Ouro' "+ CHR(13) + CHR(10)
					//lContinua  := .F.	//pode ter desconto = 0%
				Endif

				If Empty(M->Z01_DESCN4)
					cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Desconto Nível Platinum' "+ CHR(13) + CHR(10)
					//lContinua  := .F.	//pode ter desconto = 0%
				Endif

			Endif
			    /* 
			    //referência
				Private nDescBBRO := GetNewPar("ST_DSCBBRO" ,50) //limite desconto produto categoria BRONZE, BÁSICOS
				Private nDescPBRO := GetNewPar("ST_DSCPBRO" ,45) //limite desconto produto categoria BRONZE, PRESCRITO
				Private nDescLBRO := GetNewPar("ST_DSCLBRO" ,54) //limite desconto produto categoria BRONZE, LANÇAMENTO
				
				Private nDescBPRA := GetNewPar("ST_DSCBPRA" ,7) //limite desconto produto categoria PRATA, BÁSICOS
				Private nDescPPRA := GetNewPar("ST_DSCPPRA" ,10) //limite desconto produto categoria PRATA, PRESCRITO
				Private nDescLPRA := GetNewPar("ST_DSCLPRA" ,2) //limite desconto produto categoria PRATA, LANÇAMENTO
				
				Private nDescBOUR := GetNewPar("ST_DSCBOUR" ,5) //limite desconto produto categoria OURO, BÁSICOS
				Private nDescPOUR := GetNewPar("ST_DSCPOUR" ,5) //limite desconto produto categoria OURO, PRESCRITO
				Private nDescLOUR := GetNewPar("ST_DSCLOUR" ,2) //limite desconto produto categoria OURO, LANÇAMENTO 
				
				Private nDescBPLA := GetNewPar("ST_DSCBPLA" ,5) //limite desconto produto categoria PLATINUM, BÁSICOS
				Private nDescPPLA := GetNewPar("ST_DSCPPLA" ,10) //limite desconto produto categoria PLATINUM, PRESCRITO
				Private nDescLPLA := GetNewPar("ST_DSCLPLA" ,5) //limite desconto produto categoria PLATINUM, LANÇAMENTO
			    */
			If lContinua
				/*
				If M->Z01_CTGPRO == 'PB' //BÁSICO
					//==============================================================================================================//
					
					If M->Z01_DESCN1 > nDescBBRO
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Bronze Supera o Limite: " + Alltrim(Str(nDescBBRO)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN2 > nDescBPRA
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Prata Supera o Limite: " + Alltrim(Str(nDescBPRA)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN3 > nDescBOUR
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Ouro Supera o Limite: " + Alltrim(Str(nDescBOUR)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN4 > nDescBPLA
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Platinum Supera o Limite: " + Alltrim(Str(nDescBPLA)) + "."+ CHR(13) + CHR(10) 
					Endif
					//==============================================================================================================//
					
				Elseif M->Z01_TIPROD == 'PP' //PRESCRITO
				    
					//==============================================================================================================//
					If M->Z01_DESCN1 > nDescPBRO
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Bronze Supera o Limite: " + Alltrim(Str(nDescPBRO)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN2 > nDescPPRA
						lContinua := .F. 
						cMsg+= "Desconto Digitado Nivel Prata Supera o Limite: " + Alltrim(Str(nDescPPRA)) + "."+ CHR(13) + CHR(10) 						
					Endif
					
					If M->Z01_DESCN3 > nDescPOUR
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Ouro Supera o Limite: " + Alltrim(Str(nDescPOUR)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN4 > nDescPPLA
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Platinum Supera o Limite: " + Alltrim(Str(nDescPPLA)) + "."+ CHR(13) + CHR(10) 
					Endif
					//==============================================================================================================//
				
				Elseif M->Z01_TIPROD == 'PL' //LANÇAMENTO
					
					//==============================================================================================================//
					If M->Z01_DESCN1 > nDescLBRO
						lContinua := .F. 
						cMsg+= "Desconto Digitado Nivel Bronze Supera o Limite: " + Alltrim(Str(nDescLBRO)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN2 > nDescLPRA
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Prata Supera o Limite: " + Alltrim(Str(nDescLPRA)) + "."+ CHR(13) + CHR(10) 						
					Endif
					
					If M->Z01_DESCN3 > nDescLOUR
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Ouro Supera o Limite: " + Alltrim(Str(nDescLOUR)) + "."+ CHR(13) + CHR(10) 
					Endif
					
					If M->Z01_DESCN4 > nDescLPLA
						lContinua := .F.
						cMsg+= "Desconto Digitado Nivel Platinum Supera o Limite: " + Alltrim(Str(nDescLPLA)) + "."+ CHR(13) + CHR(10) 
					Endif
					//==============================================================================================================//
				
				Endif
				*/
			Endif

		Endif


		If lContinua

			//----------------------------------------------//
			//Checagem dos campos obrigatórios do cabeçalho
			//----------------------------------------------//
			SX3->(OrdSetFocus(2))
			For nInd := 1 To Z01->(FCount())
				cCpoCab := Z01->(FieldName(nInd))

				If SX3->(dbSeek ( cCpoCab ) )
					If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V"

						If X3Obrigat(SX3->X3_CAMPO)     //se for obrigatório
							If Empty( M->(&(cCpoCab)) )
								cMsg += "Campo: '" + SX3->X3_TITULO + "' -> Sem Preenchimento..." + CHR(13) + CHR(10)
								lContinua := .F.
							EndIf
						Endif

					Endif
				Endif

			Next
		Endif

		//----------------------------------------------//
		//Checagens finais antes da gravação de fato
		//----------------------------------------------//
		If lContinua

			//grava itens - se tivesse itens, seria aqui primeira etapa

			If lContinua //.and. xOpc <> 5 	//se gravou os itens, grava o cabeçalho
				//atende as opções: 3-Incluir, 4-Alterar , 5-Excluir
				lContinua := GrvCpoMem("Z01",lNew,lDel)

			Endif	//lContinua
		Endif 	//lContinua

		If !lContinua
			AutoGrLog(cMsg)
			MostraErro()
		Endif

	Else
		lContinua := .T.
	Endif

Return(lContinua)

/*==========================================================================
|Funcao    | GrvCpoMem            | Flávia Rocha        | Data | 27/04/2021|
============================================================================
|Descricao | Grava os campos de memória                                    |
|          | Usada na gravação da Ordem de Manutenção                      |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function GrvCpoMem(xAlias,xLock,xDel)	
	Local nInd		:= 0
	Local xConteudo := ""	
	Local lGravou   := .F.
	Local xArea     := GetArea() 
	

	DbSelectArea(xAlias)
	Begin Transaction
		&(xAlias)->(RecLock(xAlias,xLock))
		If xDel == .T. .AND. xLock == .F.
			&(xAlias)->(dbDelete())
			lGravou := .T.
		Else
			For nInd := 1 To &(xAlias)->(FCount())
				cCpoDest := &(xAlias)->(FieldName(nInd))
				If &(xAlias)->(FieldPos(cCpoDest)) > 0
					If "FILIAL" $ cCpoDest
						M->(&(cCpoDest)) := xFilial(xAlias)
						xConteudo        := xFilial(xAlias) 
						FieldPut(FieldPos(cCpoDest), xConteudo )				
						
					Else
						FieldPut(FieldPos(cCpoDest), M->(&(cCpoDest)) )			
					EndIf	
					
				EndIf
			Next
		
			&(xAlias)->(dbCommit())
			&(xAlias)->(MsUnlock())
			lGravou := .T.
		EndIf
		
	End Transaction
	
	RestArea(xArea)		

Return(lGravou) 
