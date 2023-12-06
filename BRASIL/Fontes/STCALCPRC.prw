#include "Protheus.ch" 

#DEFINE CR chr(13)+chr(10)

/*/{Protheus.doc} STCalcPrc
Calculo unificado de preços
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 09/10/2022
@param aDados, array, Recno Cliente e Produto
@param nPrecoX, numeric, Preço na tabela
@param cTabelaX, character, tabela de preços
@param nPrcCamX, numeric, preço campanha
@param cOperX, character, Operação de venda
@param cTESX, character, TES
@param lPrcCond, logical, Preço condicional
@return array, preço e regra (se cair em alguma específica)
/*/
User Function STCalcPrc(aDados,nPrecoX,cTabelaX,nPrcCamX,cOperX,cTESX,lPrcCond)
	Local aArea := GetArea()
	Local lOrcamento := FWIsInCallStack("TMKA271") .Or. FWIsInCallStack("TMKA380") .Or. FWIsInCallStack("U_STFSVE46")
	Local nPISX := 0
	Local nCOFX := 0
	Local nIPIX := 0
	Local nICMX := 0
	Local nVLIPIX := 0
	Local nICMSSTX := 0
	Local cOriFabX := ""
	Local nDescX := 0
	Local cTabInflX := ""
	Local nMargZF7X := 0
	Local nFatMarX := 0
	Local nFatInflX := 0
	Local nPrcContX := 0
	Local aPrcContX := {}
	Local cGrpVenX := ""
	Local cGrpPOL2X := ""
//Local nDescPadX := 0
//Local nDescUniX := 0
	Local nCamDescX := 0
	Local cCliMAX := GetMv('ST_FATG02',,'03544401')
	Local CCliSCHX := GetMv('ST_FATG03',,'012047')
	Local cTESOCIX := GetMv('ST_TESOCI',,'827/828/829/830/831')
	Local cRegra := ""

	Local aDadosM := {}
	Local lConsProd := FWIsInCallStack("U_STCONSPROD")

	Default aDados := {}
	Default nPrecoX := 0
	Default cTabelaX := "001"
	Default nPrcCamX := 0
	Default cOperX := ""
	Default cTESX := ""
	Default lPrcCond := .T.

	DbSelectArea("SA1")
	SA1->(DbGoTo(aDados[1]))
	DbSelectArea("SB1")
	SB1->(DbGoTo(aDados[2]))

	aAdd(aDadosM, {"PRODUTO", SB1->B1_COD})

	If SA1->A1_COD + SA1->A1_LOJA $ cCliMAX
		cRegra := "CLIMA"
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1") + "T01" + SB1->B1_COD))
			nPrecoX := DA1->DA1_PRCVEN
		Else
			nPrecoX := 0
			MsgInfo("Produto Não Cadastrado na Tabela de Preço de Transferencia..."+CR+"Solicite o Cadastro...!!!!")
		EndIf
		If lConsProd
			aAdd(aDadosM, {"PREÇO INICIAL", nPrecoX})
			EnvConPrd(aDadosM, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)
			Return {nPrecoX,cRegra}
		Else
			Return {nPrecoX,cRegra}
		End If
	EndIf

	If SA1->A1_COD $ cCliSCHX
		cRegra := "CLISCH"
		If AllTrim(SB1->B1_XCODSE)=="S"
			cTabelaX := "GUA"
		Else
			cTabelaX := "SCH"
		EndIf
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1") + cTabelaX + SB1->B1_COD))
			nPrecoX := DA1->DA1_PRCVEN
		Else
			nPrecoX := 0
			MsgInfo("Produto Não Cadastrado na Tabela de Preço de Transferencia..."+CR+"Solicite o Cadastro...!!!!")
		EndIf
		Return {nPrecoX,cRegra}
	EndIf

//If Empty(cRegra)
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	If DA1->(DbSeek(FWxFilial("DA1") + cTabelaX + SB1->B1_COD))
		nPrecoX := DA1->DA1_PRCVEN
	Else
		nPrecoX := 0.01
		FWAlertInfo("Produto não consta na tabela de Preços")
		cRegra := "SEMPRECO"
		If lConsProd
			aAdd(aDadosM, {"PREÇO INICIAL", nPrecoX})
			EnvConPrd(aDadosM, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)
			Return {nPrecoX,cRegra}
		Else
			Return {nPrecoX,cRegra}
		End If
//	Else
//		nPrecoX := 0.01
//		FWAlertInfo("Produto não consta na tabela de Preços")
//		Return {nPrecoX,cRegra}
	Endif
//EndIf

	aAdd(aDadosM, {"PREÇO INICIAL", nPrecoX})

//Canal do CLiente
	cGrpVenX := SA1->A1_GRPVEN
	cGrpPOL2X := GetNewPar("ST_GRPPO2","E1,E2,I1,I2,I4,I5")

	If lOrcamento
		nICMX := MaFisRet(n,"IT_ALIQICM")
		nPISX := MaFisRet(n,"IT_ALIQPIS")
		nCOFX := MaFisRet(n,"IT_ALIQCOF")
	Else
		If FWIsInCallStack("U_STRETSST")
			If IsInCallStack("U_STCONSCOT") .or. IsInCallStack("U_STCADCOT") .OR. IsInCallStack("POST") .OR. IsInCallStack("U_STCRM07A") .OR. IsInCallStack("U_STCRM08A")
				nICMX := xMafis(cTESX)
			Else
				nICMX := xMafis()
			Endif
			nPISX := SuperGetMv("MV_TXPIS" ,,"")
			nCOFX := SuperGetMv("MV_TXCOFIN",,"")
		Else
			If FWIsInCallStack("U_RSTFAT08")
				nICMX := STFATMAFIS()
			Else
				aImp := CalcImp(nPrecoX)
				nICMX := aImp[4] //U_STFATMAFIS()
				nICMSSTX := aImp[3]
				nVLIPIX := aImp[2]
//Return ({nAliqIPI, nValIPI, nValICMSST, nAliqICM, nValICms, nValPis, nValCof})
			EndIf
			nPISX := SuperGetMv("MV_TXPIS" ,,"")
			nCOFX := SuperGetMv("MV_TXCOFIN",,"")
		EndIf
	EndIf

	nIPIX := SB1->B1_XIPI
	cOriFabX := AllTrim(U_STORIG(SB1->B1_COD))

	If !(cEmpAnt == "03")
		nMargZF7X := U_MargemZF7X(SB1->B1_GRTRIB,SA1->A1_GRPTRIB,SA1->A1_EST,SA1->A1_TIPO)
	EndIf

	cTabInflX := GetNewPar("ST_TABINFL","001")

//Se for Distriuidora e a Tabela Pedido pertencer a Tabelas de Inflação
	If cEmpAnt $ "03#11" .And. (cTabelaX $ cTabInflX)
		//nPrcContX := U_STFAT391(SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD)
		aPrcContX := U_STFAT391(SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD)
		//If nPrcContX > 0
		IF LEN(aPrcContX)>0
		   IF aPrcContX[1,1] > 0
			  cRegra := "PRCCONT"
			  nPrecoX := Round(aPrcContX[1,1],2)
			  If lConsProd
				 EnvConPrd(aDadosM, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)
				 Return{nPrecoX,cRegra}
			  Else
				 Return {nPrecoX,cRegra}
			  End If
		   ENDIF	  
		EndIf

//Fator Inflação
		If SA1->A1_EST == "SP" .And. SA1->A1_TIPO $ "S|R" .And. !(SB1->B1_CLAPROD == "I")
			If nMargZF7X > 0
				If SA1->A1_TIPO == "R"
//Zera ICM
					nICMX := 0
					nFatMarX := U_FatMarX(nIPIX,nMargZF7X,nICMX,.F.)
				Else
					nFatMarX := U_FatMarX(nIPIX,nMargZF7X,nICMX,.F.)
				EndIf
			Else
				nFatMarX := 0
			EndIf
		EndIf
		If !(SA1->A1_EST == "SP") .And. !(SA1->A1_TIPO == "S")
			If cOriFabX == "GUA"
				If nIPIX == 0  .AND. nICMX == 18
					nFatInflX := GetMv("STTMKG0314",,0)
				Elseif nIPIX == 0  .AND. nICMX == 12
					nFatInflX := GetMv("STTMKG0314",,0)
				Elseif nIPIX == 0  .AND. nICMX == 7
					nFatInflX := GetMv("STTMKG0314",,0)
				ElseIf nIPIX == 5  .AND. nICMX == 18
					nFatInflX := GetMv("STTMKG0315",,5.51)
				Elseif nIPIX == 5  .AND. nICMX == 12
					nFatInflX := GetMv("STTMKG0333",,0.49)
				Elseif nIPIX == 5  .AND. nICMX == 7
					nFatInflX := GetMv("STTMKG0333",,0.49)
				ElseIf nIPIX == 10  .AND. nICMX == 18
					nFatInflX := GetMv("STTMKG0318",,11.02)
				Elseif nIPIX == 10  .AND. nICMX == 12
					nFatInflX := GetMv("STTMKG0325",,0.93)
				Elseif nIPIX == 10  .AND. nICMX == 7
					nFatInflX := GetMv("STTMKG0325",,0.93)
				ElseIf nIPIX == 15  .AND. nICMX == 18
					nFatInflX := GetMv("STTMKG0321",,16.53)
				Elseif nIPIX == 15  .AND. nICMX == 12
					nFatInflX := GetMv("STTMKG0334",,1.35)
				Elseif nIPIX == 15  .AND. nICMX == 7
					nFatInflX := GetMv("STTMKG0334",,1.35)
				Endif
//Manaus é Zero
			Else
				nFatInflX := GetMv("STTMKG0302",,0)
			EndIf
//			nPrecoX := (nPrecoX)/(1-(nPISX/100)-(nCOFX/100)-(nICMX/100))
		Else
			If SB1->B1_CLAPROD == "I"
				nFatInfX := GetMv("STTMKG0301",,0)
			Else
				If cOriFabX == "GUA"
					If nIPIX == 0  .AND. nICMX == 18
						nFatInflX := GetMv("STTMKG0314",,0)
					Elseif nIPIX == 0  .AND. nICMX == 12
						nFatInflX := GetMv("STTMKG0314",,0)
					Elseif nIPIX == 0  .AND. nICMX == 7
						nFatInflX := GetMv("STTMKG0314",,0)
					ElseIf nIPIX == 5  .AND. nICMX == 18
						nFatInflX := GetMv("STTMKG0315",,5.51)
					Elseif nIPIX == 5  .AND. nICMX == 12
						nFatInflX := GetMv("STTMKG0325",,0.93)
					Elseif nIPIX == 5  .AND. nICMX == 7
						nFatInflX := GetMv("STTMKG0326",,0.69)
					ElseIf nIPIX == 10  .AND. nICMX == 18
						nFatInflX := GetMv("STTMKG0318",,11.02)
					Elseif nIPIX == 10  .AND. nICMX == 12
						nFatInflX := GetMv("STTMKG0328",,1.77)
					Elseif nIPIX == 10  .AND. nICMX == 7
						nFatInflX := GetMv("STTMKG0329",,1.27)
					ElseIf nIPIX == 15  .AND. nICMX == 18
						nFatInflX := GetMv("STTMKG0321",,16.53)
					Elseif nIPIX == 15  .AND. nICMX == 12
						nFatInflX := GetMv("STTMKG0331",,2.54)
					Elseif nIPIX == 15  .AND. nICMX == 7
						nFatInflX := GetMv("STTMKG0332",,1.86)
					Else
						nFatInflX := GetMv("STTMKG0302",,0)
					Endif
//Manaus é Zero
				Else
					nFatInflX := GetMv("STTMKG0303",,0)
				EndIf
			EndIf
		EndIf

		If cEmpAnt == "03"
			nFatInflX := 0
			nFatMarX  := 0
		EndIf

		nPrecoX  := nPrecoX * (1 + (nFatInflX/100) + (nFatMarX/100))

		nPrecoX := (nPrecoX) / (1 - (nPISX/100) - (nCOFX/100) - (nICMX/100))
		
		//Política Clientes Advanced ou Professional
		If !(AllTrim(cGrpVenX) $ cGrpPOL2X)
			nPrecoX := nPrecoX * GetMv("STTMKG0310",,2.4)
		Endif

		nDescX := U_STGAP01()
		nPrecoX := nPrecoX * (1 - (nDescX/100))

	EndIf

	DbSelectArea("DA1")
	DA1->(DBSetOrder(1))
	If !DA1->(DbSeek(FWxFilial("DA1") + cTabelaX + SB1->B1_COD)) .And. !lPrcCond
		cRegra := "NODA1PRCCOND"
		nPrecoX := 0.01
		If lConsProd
			EnvConPrd(aDadosM, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)
			Return {nPrecoX,cRegra}
		Else
			Return {nPrecoX,cRegra}
		End If
	EndIf

	If cTabelaX $ cTabInflX
		IF !(SB1->B1_XCODSE == "S")
			If !(SA1->A1_EST == "SP") .And. !(SB1->B1_CLAPROD == "I") .And. !(cOriFabX == "MAO")
				If nIPIX > 0
					nPrecoX := Round(nPrecoX + (nPrecoX * (nIPIX / 100)),2)
				Endif
			Endif
		Endif
	Endif

	If cOperX == "78"
		nPrecoX := Round(nPrecoX * 0.9075,2)
	EndIf

    IF LEN(aPrcContX) > 0
	   IF aPrcContX[1,2]>0 // Tem desconto a ser aplicado pelo contrato 
          nPrecox := nPrecox - ( nPrecox * ( aPrcContX[1,2]/100 ) )	   
	   ENDIF	  
	ENDIF


	If lConsProd
		EnvConPrd(aDadosM, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)
		Return {nPrecoX,cRegra}
	End If

	RestArea(aArea)
Return {nPrecoX,cRegra}


/*/{Protheus.doc} EnvConPrd
Alimenta array contendo a Memória de calculo do Preço
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 23/02/2023
@param aDadosX, array, dados da memória de calculo (preço tabela)
@param nIPIX, numeric, IPI
/*/
Static Function EnvConPrd(aDadosX, nIPIX, nVLIPIX, nICMSSTX, nFatMarX, nFatInflX, nDescX, nPrecoX, nMargZF7X, cRegra)

	aSize(aAcresM,0)
	aAcresM := aClone(aDadosX) //para poder trabalhar no STCONSPROD
	aAdd(aAcresM, {"% IPI", nIPIX})
	aAdd(aAcresM, {"VL IPI", nVLIPIX})
	aAdd(aAcresM, {"VL ICMS-ST", nICMSSTX})
	aAdd(aAcresM, {"% MARGEM (Inflação)", nFatMarX})
	aAdd(aAcresM, {"% INFLAÇÃO", nFatInflX})
	aAdd(aAcresM, {"% DESCONTO", nDescX})
	aAdd(aAcresM, {"VL PREÇO FINAL", nPrecoX})
	aAdd(aAcresM, {"Margem ZF7", nMargZF7X})

Return


/*/{Protheus.doc} GeraMemoX
Gera arquivo contendo a Memória de calculo do Preço
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 23/02/2023
@param aAcresM, array, dados da memória de calculo
/*/
User Function GeraMemoX(aAcresM)
	Local aArea := GetArea()
	Local cMensagem := "Memória de calculo gravada em: " + CRLF + CRLF
	Local nX := 1

	For nX := 1 To Len(aAcresM)
		cMensagem += aAcresM[nX][1] + " = " + cValToChar(aAcresM[nX][2]) + CRLF
		If nX == Len(aAcresM)
			cMensagem += CRLF + aAcresM[nX][1] + " = " + cValToChar(aAcresM[nX][2]) + CRLF
		End If
	Next nX

/*
If !IsBlind()
	FWAlertInfo(cMensagem)
End If
*/

	RestArea(aArea)
Return


/*/{Protheus.doc} FatMarX
Calcula o valor conforme Margem ZF7
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 09/10/2022
@param nIPIX, numeric, IPI
@param nMargemZF7X, numeric, valor ZF7
@param nAliqICMX, numeric, ICM
@param lSchneider, logical, Produto Schneider
@return variant, Valor conforme margem ZF7
/*/
User Function FatMarX(nIPIX,nMargemZF7X,nAliqICMX,lSchneider)
	Local aArea := GetArea()
	Local nFatMarX := 0

	Default nMargemZF7X := 0
	Default nAliqICMX := 0

//If lSchneider
	nFatMarX := ((((100*(1+(nIPIX/100)))*(1+(nMargemZF7X/100)))*(18/100))-(100*(nAliqICMX/100)))
//Else
//	nFatMarX := ((((100*(1+(nIPIX/100)))*(1+(nMargemZF7X/100)))*(18/100))-(100*(nAliqICMX/100)))
//EndIf

	RestArea(aArea)
Return nFatMarX


/*/{Protheus.doc} MargemZF7X
Obtém margem na ZF7
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 09/10/2022
@param cB1GRTRIB, character, grupo tributário do produto
@param cA1GRTRIB, character, grupo tributário do cliente
@param cEstX, character, estado do Clinte
@param cTipoCliX, character, tipo do cliente
@return variant, valor margem ZF7
/*/
User Function MargemZF7X(cB1GRTRIB,cA1GRTRIB,cEstX,cTipoCliX)
	Local aArea := GetArea()
	Local nMargemZF7X := 0

	nMargemZF7X := Posicione("SZS",4,FWxFilial("SZS") + cB1GRTRIB + cA1GRTRIB + cEstX + cTipoCliX,"ZS_MARGEM")
	RestArea(aArea)
Return nMargemZF7X


/*/{Protheus.doc} FatInflX
Calcula o Fator Inflação
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 09/10/2022
@param cEstX, character, estado cliente
@param cTipoCliX, character, tipo cliente
@param cCLAPROD, character, classe produto
@param nIPIX, numeric, IPI
@param nAliqICMX, numeric, ICM
@param xOrigFabX, variant, Origem Fábrica
@return variant, valor inflação
/*/
User Function FatInflX(cEstX,cTipoCliX,cCLAPROD,nIPIX,nAliqICMX,xOrigFabX)
	Local nFatInfX := 0

	Default cEstX := ""
	Default cTipoCliX := ""
	Default nAliqICMX := 0
	Default xOrigFabX := ""

	If cEstX <> "SP" .AND. cTipoCliX <> "S"
		If xOrigFabX == "GUA"
			If nIPIX == 0  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0314",,0)						//FR - 24/12/2021
			Elseif nIPIX == 0  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0314",,0)						//FR - 27/12/2021
			Elseif nIPIX == 0  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0314",,0)						//FR - 27/12/2021
			ElseIf nIPIX == 5  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0315",,5.51)					//FR - 24/12/2021
			Elseif nIPIX == 5  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0333",,0.49)					//FR - 27/12/2021
			Elseif nIPIX == 5  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0333",,0.49)					//FR - 27/12/2021
			ElseIf nIPIX == 10  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0318",,11.02)					//FR - 24/12/2021
			Elseif nIPIX == 10  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0325",,0.93)					//FR - 27/12/2021
			Elseif nIPIX == 10  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0325",,0.93)					//FR - 27/12/2021
			ElseIf nIPIX == 15  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0321",,16.53)						//FR - 24/12/2021
			Elseif nIPIX == 15  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0334",,1.35)						//FR - 27/12/2021
			Elseif nIPIX == 15  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0334",,1.35)						//FR - 27/12/2021
			Endif
		Else
			nFatInfX := GetMv("STTMKG0302",,0)  //FR - 24/12/2021 - SE NÃO ENCONTRAR NENHUM É ZERO, TÁ NO PARAMETRO
		EndIf
	Else
		If cCLAPROD == "I"  //SE PRODUTO É IMPORTADO
			nFatInfX := GetMv("STTMKG0301",,0)
		Elseif xOrigFabX == "GUA" 			//ElseIf AllTrim(U_STORIG(SB1->B1_COD))=="GUA" //Fabricado guararema
			If nIPIX == 0  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0314",,0)						//FR - 24/12/2021
			Elseif nIPIX == 0  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0314",,0)							//FR - 27/12/2021
			Elseif nIPIX == 0  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0314",,0)						//FR - 27/12/2021
			ElseIf nIPIX == 5  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0315",,5.51)					//FR - 24/12/2021
			Elseif nIPIX == 5  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0325",,0.93)					//FR - 27/12/2021
			Elseif nIPIX == 5  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0326",,0.69)						//FR - 27/12/2021
			ElseIf nIPIX == 10  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0318",,11.02)						//FR - 24/12/2021
			Elseif nIPIX == 10  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0328",,1.77)						//FR - 27/12/2021
			Elseif nIPIX == 10  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0329",,1.27)						//FR - 27/12/2021
			ElseIf nIPIX == 15  .AND. nAliqICMX == 18
				nFatInfX := GetMv("STTMKG0321",,16.53)						//FR - 24/12/2021
			Elseif nIPIX == 15  .AND. nAliqICMX == 12
				nFatInfX := GetMv("STTMKG0331",,2.54)						//FR - 27/12/2021
			Elseif nIPIX == 15  .AND. nAliqICMX == 7
				nFatInfX := GetMv("STTMKG0332",,1.86)						//FR - 27/12/2021
			Else
				nFatInfX := GetMv("STTMKG0302",,0)  //FR - 24/12/2021 - SE NÃO ENCONTRAR NENHUM É ZERO, TÁ NO PARAMETRO
			EndIf
		Else
			nFatInfX := GetMv("STTMKG0303",,0)
		EndIf
	EndIf

Return nFatInfX


/*====================================================================================\
|Programa  | OciPreco            | Autor | GIOVANI.ZAGO          | Data | 11/02/2014  |
|=====================================================================================|
|Descrição |  Reajuste de preço amazonia ocidental				                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | OciPreco                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function OciPreco(_nPrcTes,cProdX,cGrProd)
*---------------------------------------------------*
Local _nReajus:= 0
//Local _nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
Local _aArea1 	:= GetArea()

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+cProdX))

	If ALLTRIM(cGrProd) $ "066/068/160/161/162/166/167/173/178/183"
		_nReajus:= 3
	ElseIf   ALLTRIM(cGrProd) $ "049/050/063/064/149/150/152/153/176/075/159/170/171/175/177/184/186/158"
		_nReajus:= 5
	ElseIf   ALLTRIM(cGrProd) $ "154"
		_nReajus:= 7
	ElseIf   ALLTRIM(cGrProd) $ "048/148/151"
		_nReajus:= 8
	ElseIf   ALLTRIM(cGrProd) $ "015/020/069/070/071/072/073"
		_nReajus:= 12
	EndIf
	If _nReajus > 0
		_nPrcTes:= (_nPrcTes+(_nPrcTes*(_nReajus/100)))
	EndIf
EndIf
RestArea(_aArea1)
Return  (_nPrcTes)


	*-----------------------------*
Static Function xMafis(_xTES)
	*-----------------------------*

	Local _nPosPrv  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosProd  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nPosTes  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	Local _nTotPed 		:= 0
	Local nAliqICM 		:= 0
	Local nValICms		:= 0
	Local nCnt 			:= 0
	Local nAliqIPI 		:= 0
	Local nValIPI 		:= 0
	Local nValICMSST 	:= 0
	Local nValPis		:= 0
	Local nValCof		:= 0

	MaFisSave()

	MaFisEnd()

	MaFisIni(M->C5_CLIENTE,;				// 1-Codigo Cliente/Fornecedor
		M->C5_LOJACLI,;						// 2-Loja do Cliente/Fornecedor
		IIf(M->C5_TIPO$'DB',"F","C"),;		// 3-C:Cliente , F:Fornecedor
		M->C5_TIPO,;						// 4-Tipo da NF
		M->C5_TIPOCLI,;						// 5-Tipo do Cliente/Fornecedor
		Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	
	If IsInCallStack("U_STCONSCOT") .OR. IsInCallStack("U_STCRM07A") .OR. IsInCallStack("U_STCRM08A")

		//conout("<< U_STCONSCOT - TRATA TES >>>")

		MaFisAdd(aCols[n,_nPosProd],;                                 	// 1-Codigo do Produto ( Obrigatorio )
		_xTES ,; 					                                	// 2-Codigo do TES ( Opcional )
		1,;                                                         	// 3-Quantidade ( Obrigatorio )
		aCols[n,_nPosPrv],;                                     	    // 4-Preco Unitario ( Obrigatorio )
		0,;                												// 5-Valor do Desconto ( Opcional )
		,;                                                              // 6-Numero da NF Original ( Devolucao/Benef )
		,;                                                              // 7-Serie da NF Original ( Devolucao/Benef )
		,;                                                              // 8-RecNo da NF Original no arq SD1/SD2
		0,;                                                             // 9-Valor do Frete do Item ( Opcional )
		0,;                                                             // 10-Valor da Despesa do item ( Opcional )
		0,;                                                             // 11-Valor do Seguro do item ( Opcional )
		0,;                                                             // 12-Valor do Frete Autonomo ( Opcional )
		aCols[n,_nPosPrv],;												// 13-Valor da Mercadoria ( Obrigatorio )
		0,;                                                             // 14-Valor da Embalagem ( Opiconal )
		0,;                                                             // 15-RecNo do SB1
		0)                                                              // 16-RecNo do SF4

	Else

		MaFisAdd(aCols[n,_nPosProd],;                                 	// 1-Codigo do Produto ( Obrigatorio )
		aCols[n,_nPosTes],;                                				// 2-Codigo do TES ( Opcional )
		1,;                                                         	// 3-Quantidade ( Obrigatorio )
		aCols[n,_nPosPrv],;                                     	    // 4-Preco Unitario ( Obrigatorio )
		0,;                												// 5-Valor do Desconto ( Opcional )
		,;                                                              // 6-Numero da NF Original ( Devolucao/Benef )
		,;                                                              // 7-Serie da NF Original ( Devolucao/Benef )
		,;                                                              // 8-RecNo da NF Original no arq SD1/SD2
		0,;                                                             // 9-Valor do Frete do Item ( Opcional )
		0,;                                                             // 10-Valor da Despesa do item ( Opcional )
		0,;                                                             // 11-Valor do Seguro do item ( Opcional )
		0,;                                                             // 12-Valor do Frete Autonomo ( Opcional )
		aCols[n,_nPosPrv],;												// 13-Valor da Mercadoria ( Obrigatorio )
		0,;                                                             // 14-Valor da Embalagem ( Opiconal )
		0,;                                                             // 15-RecNo do SB1
		0)                                                              // 16-RecNo do SF4
 
	Endif 

	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )

	mafisend()

Return  (nAliqICM)


/*====================================================================================\
|Programa  | STFATMAFIS       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STFATMAFIS                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFATMAFIS                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STFATMAFIS()
	*-----------------------------*
	Local _nPosPrv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosPDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_DESCONT"})    // Percentual do desconto
	Local _nPosVDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALDESC"})    // Valor do Desconto
	Local _nPosQtd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})     // Quantidade
	Local _nPosTot  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"})      // Valor total
	Local _nPosUnt  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XPRCLIS"})     // Preço LISTA
	Local _nPosList := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT"})     // Preço Unitário
	Local _nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nValAcre  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XVALACR"})     	// Valor Acrescimo Financeiro
	Local _nPosTes  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "TES"})     	// Valor Acrescimo Financeiro  _nPosTes
	
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local _nTotPed := 0
	Local	nAliqICM := 0
	Local	nValICms:= 0
	Local nCnt := 0
	Local	nAliqIPI := 0
	Local	nValIPI := 0
	
	Local	nValICMSST := 0
	
	Local	nValPis	:= 0
	Local	nValCof	:= 0
	
	//MaFisSave()
	//MaFisEnd()
	MaFisIni(Iif(Empty(M->C5_CLIENTE),M->C5_CLIENTE,M->C5_CLIENTE),;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJACLI,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	1,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	
	mafisend()
	
	
	
Return  (nAliqICM)


/*/{Protheus.doc} GeraMemoX
Calcula impostos baseado em Cliente e Produto
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 25/02/2023
@param nPrcX numeric, preço do Produto
/*/
Static Function CalcImp(nPrcX)
Local aArea := GetArea()

MaFisSave()
MaFisEnd()

MaFisIni(SA1->A1_COD,;// 1-Codigo Cliente/Fornecedor
SA1->A1_LOJA,;		// 2-Loja do Cliente/Fornecedor
"C",;				// 3-C:Cliente , F:Fornecedor
"N",;				// 4-Tipo da NF
SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")

MaFisAdd(SB1->B1_COD,;                                                     // 1-Codigo do Produto ( Obrigatorio )
,;                                                                           // 2-Codigo do TES ( Opcional )
1,;                                                           // 3-Quantidade ( Obrigatorio )
nPrcX,;                                                            // 4-Preco Unitario ( Obrigatorio )
0,;                // 5-Valor do Desconto ( Opcional )
,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
nPrcX,;// 13-Valor da Mercadoria ( Obrigatorio )
0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
0,;                                                                                           // 15-RecNo do SB1
0)                                                                                                            // 16-RecNo do SF4

nAliqICM := round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
nValICms := round(MaFisRet(1,'IT_VALICM',14,2) ,2 )

nAliqIPI := round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
nValIPI := round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )

nValICMSST := round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )

nValPis	:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )
nValCof	:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )

mafisend()

RestArea(aArea)
Return ({nAliqIPI, nValIPI, nValICMSST, nAliqICM, nValICms, nValPis, nValCof})
