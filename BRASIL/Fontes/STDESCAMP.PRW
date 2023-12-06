#include 'Protheus.ch'
#include 'RwMake.ch'


/*====================================================================================\
|Programa  | STDESCAMP           | Autor | GIOVANI.ZAGO          | Data | 28/10/2014  |
|=====================================================================================|
|Descrição |  Retorna DESCONTO DE CAMPANHA	                                          |
|=====================================================================================|
|Sintaxe   | STDESCAMP                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------*
User Function STDESCAMP(_cCli,_cLoja,_cProd)
	*---------------------------*
	Local _aArea	:= GetArea()
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STCAMP'+cHora+ cMinutos+cSegundos
	Local cQuery    := ' '
	Local  _nCust   := 0
	Local _nRegDesc := 0
	Local _lCamp    := GetMv("ST_CAMP01",,.F.)

	If !_lCamp
		Return(0)
	EndIf

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+_cProd))

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))

			cQuery := " SELECT
			cQuery += " PPG_VALOR
			cQuery += " FROM "+RetSqlName("PPD")+" PPD

			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPE")+") PPE
			cQuery += " ON PPE.D_E_L_E_T_ = ' '
			cQuery += " AND PPE.PPE_NUM = PPD.PPD_NUM
			cQuery += " AND PPE.PPE_FILIAL = PPD.PPD_FILIAL

			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPG")+") PPG
			cQuery += " ON PPG.D_E_L_E_T_ = ' '
			cQuery += " AND PPG.PPG_NUM = PPD.PPD_NUM
			cQuery += " AND PPG.PPG_FILIAL = PPD.PPD_FILIAL

			cQuery += " WHERE PPD.D_E_L_E_T_ = ' '
			cQuery += " AND PPG.PPG_PROD    = '"+SB1->B1_COD+"'
			cQuery += " AND PPG.PPG_GRUPO   = '"+SB1->B1_GRUPO+"'
			cQuery += " AND PPG.PPG_GRPVEN  = '"+SA1->A1_GRPVEN+"'
			cQuery += " AND PPE.PPE_CLIENT  = '"+SA1->A1_COD+"'
			cQuery += " AND PPE.PPE_LOJA    = '"+SA1->A1_LOJA+"'
			cQuery += " AND PPD.PPD_INI     <= '"+DTOS(DDATABASE)+"'
			cQuery += " AND PPD.PPD_FIM     >= '"+DTOS(DDATABASE)+"'
			cQuery += " AND PPD.PPD_STATUS <> '3'



			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)
			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				_nCust  := (cAliasLif)->PPG_VALOR
			EndIf


			(cAliasLif)->(dbCloseArea())

			If _nCust = 0     // 2 produto sem grpven

				cQuery := " SELECT
				cQuery += " PPG_VALOR
				cQuery += " FROM "+RetSqlName("PPD")+" PPD

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPE")+") PPE
				cQuery += " ON PPE.D_E_L_E_T_ = ' '
				cQuery += " AND PPE.PPE_NUM = PPD.PPD_NUM
				cQuery += " AND PPE.PPE_FILIAL = PPD.PPD_FILIAL

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPG")+") PPG
				cQuery += " ON PPG.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_NUM = PPD.PPD_NUM
				cQuery += " AND PPG.PPG_FILIAL = PPD.PPD_FILIAL

				cQuery += " WHERE PPD.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_PROD    = '"+SB1->B1_COD+"'
				cQuery += " AND PPG.PPG_GRUPO   = '"+SB1->B1_GRUPO+"'
				cQuery += " AND PPG.PPG_GRPVEN  = ' '
				cQuery += " AND PPE.PPE_CLIENT  = '"+SA1->A1_COD+"'
				cQuery += " AND PPE.PPE_LOJA    = '"+SA1->A1_LOJA+"'
				cQuery += " AND PPD.PPD_INI     <= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_FIM     >= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_STATUS <> '3'



				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->PPG_VALOR
				EndIf


				(cAliasLif)->(dbCloseArea())

			EndIf

			If _nCust = 0     // Grupo com grpven

				cQuery := " SELECT
				cQuery += " PPG_VALOR
				cQuery += " FROM "+RetSqlName("PPD")+" PPD

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPE")+") PPE
				cQuery += " ON PPE.D_E_L_E_T_ = ' '
				cQuery += " AND PPE.PPE_NUM = PPD.PPD_NUM
				cQuery += " AND PPE.PPE_FILIAL = PPD.PPD_FILIAL

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPG")+") PPG
				cQuery += " ON PPG.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_NUM = PPD.PPD_NUM
				cQuery += " AND PPG.PPG_FILIAL = PPD.PPD_FILIAL

				cQuery += " WHERE PPD.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_PROD    = ' '
				cQuery += " AND PPG.PPG_GRUPO   = '"+SB1->B1_GRUPO+"'
				cQuery += " AND PPG.PPG_GRPVEN  = '"+SA1->A1_GRPVEN+"'
				cQuery += " AND PPE.PPE_CLIENT  = '"+SA1->A1_COD+"'
				cQuery += " AND PPE.PPE_LOJA    = '"+SA1->A1_LOJA+"'
				cQuery += " AND PPD.PPD_INI     <= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_FIM     >= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_STATUS <> '3'



				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->PPG_VALOR
				EndIf


				(cAliasLif)->(dbCloseArea())

			EndIf
			If _nCust = 0     // 4 Grupo SEM grpven

				cQuery := " SELECT
				cQuery += " PPG_VALOR
				cQuery += " FROM "+RetSqlName("PPD")+" PPD

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPE")+") PPE
				cQuery += " ON PPE.D_E_L_E_T_ = ' '
				cQuery += " AND PPE.PPE_NUM = PPD.PPD_NUM
				cQuery += " AND PPE.PPE_FILIAL = PPD.PPD_FILIAL

				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PPG")+") PPG
				cQuery += " ON PPG.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_NUM = PPD.PPD_NUM
				cQuery += " AND PPG.PPG_FILIAL = PPD.PPD_FILIAL

				cQuery += " WHERE PPD.D_E_L_E_T_ = ' '
				cQuery += " AND PPG.PPG_PROD    = ' '
				cQuery += " AND PPG.PPG_GRUPO   = '"+SB1->B1_GRUPO+"'
				cQuery += " AND PPG.PPG_GRPVEN  = ' '
				cQuery += " AND PPE.PPE_CLIENT  = '"+SA1->A1_COD+"'
				cQuery += " AND PPE.PPE_LOJA    = '"+SA1->A1_LOJA+"'
				cQuery += " AND PPD.PPD_INI     <= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_FIM     >= '"+DTOS(DDATABASE)+"'
				cQuery += " AND PPD.PPD_STATUS <> '3'



				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->PPG_VALOR
				EndIf


				(cAliasLif)->(dbCloseArea())

			EndIf
			_nRegDesc:= xSTGAP01() //giovani zago 10/12/19 ajuste carla lodetti considera o maior desconto entre campanha e regra de desconto.
			If _nRegDesc <> 0
				_nCust:= 0
			EndIf
		EndIf
	EndIf
	RestArea(_aArea)
	Return(round(_nCust,2))



	*-----------------------------*
Static Function xSTGAP01()
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
	Local _LFun     := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local cFunCampo := IIF(_LFun ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private nRet	:= 0
	Private _nCamDes:= 0

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
			//REGRA 01  CLIENTE-CABEÇALHO  &   PRODUTO-ITEM
			If STREG01(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			ElseIf STREG02(cProduto,cCliente,cLoja) > 0
				nDesc := nRet
			EndIf

		
	EndIf
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

