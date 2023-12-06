#Include "RwMake.CH"
#include "tbiconn.ch"

User function Q215FIM()

	Local cProd 	:= PARAMIXB[1]
	Local cRevpr	:= PARAMIXB[2]
	Local cForn		:= PARAMIXB[3]
	Local cLjFor	:= PARAMIXB[4]
	Local cDtent	:= dtos(PARAMIXB[5])
	Local cLote		:= PARAMIXB[6]
	Local cNtfis	:= PARAMIXB[7]
	Local cSerNF	:= PARAMIXB[8]
	Local cItNF		:= PARAMIXB[9]
	Local cTpNF		:= PARAMIXB[10]
	Local nOpc		:= PARAMIXB[11]

	Local cLocDest	:= "97"
	Local cEndDest	:= "REJEITADOS"

	Local n 		:= 0
	Local _nLOCDEST	:= 0
	Local _nQtde	:= 0
	Local _nLOTECTL	:= 0
	Local _nTipo 	:= 0
	Local _cItem	:= ""
	Local nEmpenho	:= 0
	Local nEmpenh2	:= 0
	Local nBaixa	:= 0
	Local nBaixa2	:= 0
	Local nQuant2UM	:= 0
	Local cNumero	:= SD7->D7_NUMERO
	Local cLocAnt	:= SD7->D7_LOCAL
	Local lOk       := .F.
	_nLOCDEST		:= aScan(aHeader,{|x| Upper(allTrim(x[2])) == "D7_LOCDEST"})
	_nSEQ			:= aScan(aHeader,{|x| Upper(allTrim(x[2])) == "D7_SEQ"})
	_nQtde			:= aScan(aHeader,{|x| Upper(allTrim(x[2])) == "D7_QTDE"})
	_nTipo			:= aScan(aHeader,{|x| Upper(allTrim(x[2])) == "D7_TIPO"})

    //If cEmpAnt = "01" .And. cFilAnt = "02"
	If cEmpAnt = "11" .And. cFilAnt = "01"       // Valdemir Rabelo 29/03/2022 - Chamado: 20220204002879 

		For n := 1 To Len(aCols)

			If ((aCols[n][_nTipo] == 1 .Or. aCols[n][_nTipo] == 2) .And. Alltrim(aCols[n,_nLOCDEST]) $ "10/40/60/95/97")

				cLocDest := Alltrim(aCols[n,_nLOCDEST])
				
				If aCols[n][_nTipo] == 1   .And. !Empty(Alltrim(aCols[n,_nLOCDEST])) //Liberado
					//Liberado - Armazém 10 (endereço RETRABALHO)
					If cLocDest == "10"
						cLocDest := "10"
						cEndDest := "RETRABALHO"
					//Liberado - Armazém 95 (endereço SEGREGADO)
					ElseIf cLocDest == "95"
						cLocDest := "95"
						cEndDest := "SEGREGADO"
					//Liberado - Armazém 60 (endereço NF)
					ElseIf cLocDest == "60"
						cLocDest := "60"
						cEndDest := "NF"
					EndIf   
				Elseif aCols[n][_nTipo] == 2 .And. !Empty(Alltrim(aCols[n,_nLOCDEST])) //Rejeitado
					
					//Rejeitado Armazém 40 (endereço SINISTRO)
					If cLocDest == "40"
						cLocDest := "40"
						cEndDest := "SINISTRO"
					//Rejeitado - Armazém 97 (endereço REJEITADOS)
					ElseIf cLocDest == "97"
						cLocDest := "97"
						cEndDest := "REJEITADOS"
					ElseIf cLocDest == "95"
						cLocDest := "95"
						cEndDest := "SEGREGADO"
					EndIf
					
				EndIf

				SD7->(DbSetOrder(1))
				SD7->(DbSeek(xFilial("SD7")+cNumero+cProd+cLocAnt+aCols[n][_nSEQ]))

				cNumSeq		:= SD7->D7_NUMSEQ
				nQuant2UM	:= ConvUm(cProd,aCols[n][_nQtde],nQuant2UM,2)

				DbSelectArea("SDA")
				SDA->(DbSetOrder(1))

				If SDA->(DbSeek(xFilial("SDA")+cProd+aCols[n,_nLOCDEST]+cNumSeq))			//+cNtfis+cSerNF

					/*
					RecLock("SDA",.F.)
					SDA->DA_FILIAL	:= xFilial("SDA")
					SDA->DA_PRODUTO	:= cProd
					SDA->DA_QTDORI	:= aCols[n,_nQtde]
					SDA->DA_SALDO	:= aCols[n,_nQtde]
					SDA->DA_DATA	:= dDataBase
					SDA->DA_LOCAL	:= cLocRej
					SDA->DA_DOC		:= cNtfis
					SDA->DA_SERIE	:= cSerNF
					SDA->DA_CLIFOR	:= cForn
					SDA->DA_LOJA	:= cLjFor
					SDA->DA_TIPONF	:= cTpNF
					SDA->DA_ORIGEM	:= "SD7"		//???
					SDA->DA_NUMSEQ	:= cNumSeq
					SDA->DA_QTSEGUM	:= nQuant2UM
					SDA->(MsUnlock())
					*/

					//-- Gera arquivo de Movimento no SDB
					_cItem	:=	A265UltIt('C')
					CriaSDB(cProd, cLocDest, aCols[n][_nQtde], cEndDest, SDA->DA_SERIE, SDA->DA_DOC, SDA->DA_SERIE, SDA->DA_CLIFOR, SDA->DA_LOJA, SDA->DA_TIPONF, SDA->DA_ORIGEM, dDataBase, DA_LOTECTL, DA_NUMLOTE, SDA->DA_NUMSEQ, '499', 'D', StrZero(Val(_cItem)+1, Len(_cItem)), .F., If(QtdComp(SDA->DA_EMPENHO)>QtdComp(0),aCols[n][_nQtde],0),nQuant2UM)
					//CriaSDB(cProd, aCols[n][_nLOCDEST], aCols[n][_nQtde], "REJEITADOS", cSerNF, cNtfis, SDA->DA_SERIE, SDA->DA_CLIFOR, SDA->DA_LOJA, SDA->DA_TIPONF, SDA->DA_ORIGEM, IIf(SDA->DA_DATA>=dUlMes,SDA->DA_DATA,dDataBase) , DA_LOTECTL, DA_NUMLOTE, SDA->DA_NUMSEQ, '499', 'D', StrZero(Val(_cItem)+1, Len(_cItem)), .F., If(QtdComp(SDA->DA_EMPENHO)>QtdComp(0),aCols[n][_nQtde],0),nQuant2UM)

					//-- Atualiza o Saldo no SDA
					RecLock('SDA', .F.)
					Replace DA_SALDO   With (DA_SALDO-SDB->DB_QUANT)
					Replace DA_EMPENHO With (DA_EMPENHO-SDB->DB_EMPENHO)
					Replace DA_QTSEGUM With (DA_QTSEGUM - SDB->DB_QTSEGUM)
					Replace DA_EMP2    With (DA_EMP2 - SDB->DB_EMP2)
					MsUnlock()

					//-- Baixa Saldo a Classificar no SB2
					SB2->(dbSetOrder(1))
					SB2->(MsSeek(xFilial("SB2")+SDA->DA_PRODUTO+SDA->DA_LOCAL))
					RecLock('SB2', .F.)
					Replace B2_QACLASS With (B2_QACLASS-SDB->DB_QUANT)
					MsUnlock()

					//-- Baixa Saldo Empenhado (Ref. ao Saldo a Classificar) no SB8
					If Rastro(SDA->DA_PRODUTO)
						dbSelectArea('SB8')
						dbSetOrder(3)
						If Rastro(SDA->DA_PRODUTO, 'S')
							If dbSeek(cSeek:=xFilial('SB8')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL+SDA->DA_NUMLOTE, .F.)
								RecLock('SB8', .F.)
								Replace B8_QACLASS With (B8_QACLASS-SDB->DB_QUANT)
								Replace B8_QACLAS2 With (B8_QACLAS2-SDB->DB_QTSEGUM)
								MsUnlock()
							EndIf
						Else
							nEmpenho := SDB->DB_QUANT
							nEmpenh2 := SDB->DB_QTSEGUM
							dbSeek(cSeek:=xFilial('SB8')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL, .T.)
							Do While !Eof() .And. QtdComp(nEmpenho) > QtdComp(0) .And. cSeek == B8_FILIAL+B8_PRODUTO+B8_Local+B8_LOTECTL
								If QtdComp(nBaixa:=If(QtdComp(B8_QACLASS)<QtdComp(nEmpenho),B8_QACLASS,nEmpenho)) > QtdComp(0)
									nBaixa2:=If(QtdComp(B8_QACLAS2)<QtdComp(nEmpenh2),B8_QACLAS2,nEmpenh2)
									Reclock('SB8', .F.)
									Replace B8_QACLASS With (B8_QACLASS-nBaixa)
									Replace B8_QACLAS2 With (B8_QACLAS2-nBaixa2)
									MsUnlock()
									nEmpenho -= nBaixa
								EndIf
								dbSkip()
							EndDo
						EndIf
					EndIf

					//-- Cria Saldo no SBF baseado no movimento do SDB
					GravaSBF('SDB')
					lOk := .T.
					//A100Distri(cProd,aCols[n][_nLOCDEST], aCols[n][_nNUMSEQ], cNtfis, Nil, Nil, Nil,aCols[n][_nLocaliz], Nil, aCols[n][_nQtde], Nil,Nil, Nil, Nil, Nil, Nil, aCols[n][_nQtde])

				EndIf
			EndIf

		Next n
		iF lOk
			MsgAlert("Processamento Ok!")
		EndIf
	EndIf

Return

//User Function Q215END(cTipo,cLocaliz)				//U_Q215END(M->D7_TIPO,M->D7_LOCALIZ)
//
//	If cEmpAnt = "01" .And. cFilAnt = "02" .And. cTipo = 2		// .And. __cUserId $ "000276"
//		cLocaliz := "REJEITADOS"
//	EndIf
//
//Return(cLocaliz)

