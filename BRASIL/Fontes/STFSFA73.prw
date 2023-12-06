#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

User Function STFSFA73()			// U_STFSFA73()

	Private aFreq		:= StrTokArr(Alltrim(GetMv("ST_INVRND",,"F=3;M=2;R=1;RR=1;O=1;N=1")),";")	
	Private aProdFreq	:= {}
	Private nDiasUteis	:= 0 
	Private nQtdProd	:= 0
	Private nQtdInv		:= 0
	Private nTotDia		:= 0
	Private cLocInv		:= Alltrim(GetMv("ST_LOCINV",,"01/03"))
	Private cAnoProc	:= StrZero(Year(dDataBase),4)
	Private nMinInter	:= GetMv("ST_MININT",,22)
	Private cFreqGer	:= ""
	
	nDiasUteis := CalcDiasUteis(dDataBase)	// Calcula dias uteis ate final do ano
	QtdProdFreq()							// Gera Array quantidade de produtos por frquencia e quantidade de dias por tipo
	InvJaExec()								// Analisa os inventarios ja executados no ano

	If Empty(nTotDia)
		MsgAlert("Inventários do dia já gerados ou não há nada a gerar")
		Return
	EndIf

	If MsgNoYes("Confirma a geração dos mestres de inventários ?")			// MsgNoYes("Confirma a geração dos mestres de inventários de acordo com a distribuição abaixo ?" + CRLF + CRLF + cFreqGer)
		Processa({|| GeraCBA() },"Gerando Mestres de Inventário")		// Gera mestre de inventario de acordo com as regras passadas
	EndIf

Return

Static Function InvJaExec()
	Local cQuery	:= ""
	Local nPosFreq	:= 0
	Local nX

	cQuery += " SELECT LTRIM(RTRIM(B1_XFMR)) FREQ, COUNT(*) QTDREG, "
	cQuery += " SUM(CASE WHEN CBA_DATA = '" + DtoS(dDataBase) + "' THEN 1 ELSE 0 END) HOJE "
	cQuery += " FROM " + RetSqlName("CBA") + " CBA "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = CBA_PROD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE CBA_FILIAL = '" + xFilial("CBA") + "' "
	cQuery += " AND SUBSTR(CBA_DATA,1,4) = '" + cAnoProc + "' "
	cQuery += " AND CBA_XROTAT = '1' "
	cQuery += " AND B1_MSBLQL <> '1' "
	cQuery += " AND B1_XFMR <> ' ' "
	cQuery += " AND CBA.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY LTRIM(RTRIM(B1_XFMR)) "

	TCQUERY cQuery NEW ALIAS "TMPCBA"
	
	TMPCBA->(DbGotop())

	Do While ! TMPCBA->(Eof())

		nPosFreq := aScan(aProdFreq,{|x| x[1] = Alltrim(TMPCBA->FREQ)})
		If ! Empty(nPosFreq)		
			aProdFreq[nPosFreq,5] := TMPCBA->QTDREG
			aProdFreq[nPosFreq,6] := TMPCBA->HOJE
			nQtdInv += TMPCBA->QTDREG
		EndIf
		TMPCBA->(DbSkip())
	EndDo

	For nX := 1 to Len(aProdFreq)
		aProdFreq[nX,4] := Max(Round((aProdFreq[nX,3] * aProdFreq[nX,2] - aProdFreq[nX,5]) / (nQtdProd - nQtdInv) * ((nQtdProd - nQtdInv) / nDiasUteis),0) - aProdFreq[nX,6],0)
		cFreqGer += ( aProdFreq[nX,1] + " - " + Alltrim(Str(aProdFreq[nX,4])) + CRLF )
		nTotDia += aProdFreq[nX,4] 
	Next nX

	dbSelectArea("TMPCBA")
	dbCloseArea()

Return

Static Function GeraCBA()
	Local cQuery		:= ""
	Local nQtdFreqGer	:= 0
	Local aProdGer		:= {}
	Local cProdAnt		:= ""
	Local nX
	Local nY

	For nX := 1 to Len(aProdFreq)

		nQtdFreqGer := 0
		
		cQuery := ""
		cQuery += " SELECT B1_GRUPO, B1_DESC, B1_XFMR, SBF.* FROM " + RetSqlName("SBF") + " SBF "
		cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = BF_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE BF_FILIAL = '" + xFilial("SBF") + "' "
		cQuery += " AND BF_LOCAL IN " + FormatIn(cLocInv,"/") + " "
		cQuery += " AND BF_QUANT <> 0 "
		cQuery += " AND B1_MSBLQL <> '1' "
		cQuery += " AND LTRIM(RTRIM(B1_XFMR)) = '" + Alltrim(aProdFreq[nX,1]) + "' "
		cQuery += " AND SBF.D_E_L_E_T_ = ' ' " 
		cQuery += " ORDER BY BF_LOCAL, BF_PRODUTO, BF_LOCALIZ, B1_GRUPO " 

		TCQUERY cQuery NEW ALIAS "TMPFREQ"
		
		TMPFREQ->(DbGotop())
	
		cProdAnt := ""
		
		Do While ! TMPFREQ->(Eof())

			// Chamado 007125 - Richard 03/04/18
			If cProdAnt <> TMPFREQ->BF_PRODUTO
				If nQtdFreqGer > aProdFreq[nX,4]	// Quantidade gerado > quantidade a gerar no tipo de frequencia
					Exit
				EndIf
			EndIf

			cProdAnt := TMPFREQ->BF_PRODUTO
				
			nPosProd := aScan(aProdGer,{|x| x[1] = TMPFREQ->BF_PRODUTO})

			If Empty(nPosProd) 

				aAdd(aProdGer,{TMPFREQ->BF_PRODUTO,{}})
	
				nPosProd := Len(aProdGer)

				cQuery := ""
				cQuery += " SELECT DISTINCT CBA_FILIAL, CBA_LOCAL, CBA_DATA, CBA_PROD FROM " + RetSqlName("CBA") + " CBA "
				cQuery += " WHERE CBA_FILIAL = '" + xFilial("CBA") + "' "
				cQuery += " AND CBA_LOCAL = '" + TMPFREQ->BF_LOCAL + "' "
				cQuery += " AND CBA_PROD = '" + TMPFREQ->BF_PRODUTO + "' "
				cQuery += " AND CBA_XROTAT = '1' "
				cQuery += " AND SUBSTR(CBA_DATA,1,4) = '" + cAnoProc + "' "
				cQuery += " AND CBA.D_E_L_E_T_ = ' ' "
				cQuery += " ORDER BY CBA_FILIAL, CBA_LOCAL, CBA_DATA, CBA_PROD "

				TCQUERY cQuery NEW ALIAS "TMPCBA"
				
				TMPCBA->(DbGotop())
			
				Do While ! TMPCBA->(Eof())
					aAdd(aProdGer[nPosProd,2], TMPCBA->CBA_DATA)
					TMPCBA->(DbSkip())
				EndDo
			
				dbSelectArea("TMPCBA")
				dbCloseArea()

			EndIf

			Do Case
				 				
				Case Len(aProdGer[nPosProd,2]) >= aProdFreq[nX,2]
					// Ja foram feitos inventarios suficientes no ano
					DbSelectArea("TMPFREQ")
					TMPFREQ->(DbSkip())
					Loop
					
				Case aProdFreq[nX,2] >= 2 .And. Len(aProdGer[nPosProd,2]) >= 1
					// Frequencia >= 2 por ano e ja foi feito pelo menos 1 inventario - analisar a data 
					For nY := 1 to Len(aProdGer[nPosProd,2])
						nDiasUltInv := CalcDiasUteis(StoD(aProdGer[nPosProd,2,nY]))
					Next nY

					nInter := Int(nDiasUltInv / aProdFreq[nX,2])
					If nInter < nMinInter
						nInter := Int(nDiasUltInv / (aProdFreq[nX,2]-1))
					EndIf
					nDiasProx := nDiasUltInv - nInter
					If nDiasUteis > nDiasProx
						// Intervalo nao respeitado
						DbSelectArea("TMPFREQ")
						TMPFREQ->(DbSkip())
						Loop
					EndIf

			EndCase

			CBA->(DbSetOrder(1))
			Do While .T.
				cCodInv := GetSXENum("CBA","CBA_CODINV")
				ConfirmSx8()
				If ! CBA->(DbSeek(xFilial("CBA")+cCodInv))
					Exit
				EndIf
			EndDo			

			nQtdFreqGer ++
			RecLock("CBA",.T.)
			CBA->CBA_FILIAL		:= xFilial("CBA") 
			CBA->CBA_CODINV		:= cCodInv
			CBA->CBA_ANALIS		:= " "							//1=Ok;2=Divergente
			CBA->CBA_DATA		:= dDataBase
			CBA->CBA_CONTS		:= GetMv("ST_CONTINV",,4)
			CBA->CBA_LOCAL		:= TMPFREQ->BF_LOCAL
			CBA->CBA_TIPINV		:= "2" 							//1=Produto;2=Endereco
			CBA->CBA_LOCALI		:= TMPFREQ->BF_LOCALIZ
			CBA->CBA_PROD		:= TMPFREQ->BF_PRODUTO
			CBA->CBA_STATUS		:= "0"							//0=Nao iniciado;1=Em andamento;2=Em Pausa;3=Contado;4=Finalizado;5=Processado;7=Processado
			CBA->CBA_XROTAT		:= "1"
			MsUnlock("CBA")

			DbSelectArea("TMPFREQ")
			TMPFREQ->(DbSkip())
		EndDo
	
		dbSelectArea("TMPFREQ")
		dbCloseArea()

	Next nX

Return

Static Function QtdProdFreq()

	Local cQuery	:= ""
	Local nPosIgual := 0
	Local nPosFreq	:= 0
	Local nX

	For nX := 1 to Len(aFreq)
		nPosIgual = At("=",aFreq[nX])
		aAdd(aProdFreq,{Substr(aFreq[nX],1,nPosIgual-1),Val(Substr(aFreq[nX],nPosIgual+1)),0,0,0,0})
	Next nX

	cQuery += " SELECT LTRIM(RTRIM(B1_XFMR)) FREQ, COUNT(*) QTDREG FROM " + RetSqlName("SBF") + " SBF "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = BF_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE BF_FILIAL = '" + xFilial("SBF") + "' "
	cQuery += " AND BF_LOCAL IN " + FormatIn(cLocInv,"/") + " "
	cQuery += " AND BF_QUANT <> 0 "
	cQuery += " AND B1_MSBLQL <> '1' "
	cQuery += " AND B1_XFMR <> ' ' "
	cQuery += " AND SBF.D_E_L_E_T_ = ' ' " 
	cQuery += " GROUP BY LTRIM(RTRIM(B1_XFMR)) "

	TCQUERY cQuery NEW ALIAS "TMPFREQ"
	
	TMPFREQ->(DbGotop())

	Do While ! TMPFREQ->(Eof())

		nPosFreq := aScan(aProdFreq,{|x| x[1] = Alltrim(TMPFREQ->FREQ)})
		If ! Empty(nPosFreq)		
			aProdFreq[nPosFreq,3] := TMPFREQ->QTDREG
			nQtdProd += (TMPFREQ->QTDREG * aProdFreq[nPosFreq,2])
		EndIf
		TMPFREQ->(DbSkip())
	EndDo

	dbSelectArea("TMPFREQ")
	dbCloseArea()

Return 

Static Function CalcDiasUteis(dDataCalc)

	Local dDataIni		:= dDataCalc
	Local dDataAtu		:= dDataCalc
	Local dDataFim		:= StoD(StrZero(Year(dDataCalc),4)+"1231")
	Local nDias			:= 0
	Local nX

	For nX := dDataIni to dDataFim
		If dDataAtu = DataValida(dDataAtu)
			nDias++
		Endif
		dDataAtu++
	Next nX 

Return nDias
