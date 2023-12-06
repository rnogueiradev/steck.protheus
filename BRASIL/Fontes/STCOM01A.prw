#Include "Protheus.ch"
#Include "RWMake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STCOM01A  ºAutor  ³Renato Nogueira     º Data ³  06/26/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validação do documento de entrada    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STCOM01A()
	
	//Local cNatureza := MaFisRet(,"NF_NATUREZA")
	Local cEmp  	:= SM0->M0_CODIGO
	Local lRet 	 	:= .T.
	Local nPosRat 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_RATEIO"})
	Local nConta 	:= aScan(aHeader,{|y| AllTrim(y[2])=="D1_CONTA"})
	Local nItem		:= aScan(aHeader,{|z| AllTrim(z[2])=="D1_ITEMCTA"})
	Local nCusto	:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_CC"})
	Local cForRat	:= GetMv("ST_FORNRAT")
	Local nPosTes 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
	Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
	Local nPosOp 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})	
	Local nX		:= 0
	Local ny		:= 0
	If cEmp == "03"
		For nx := 1 to Len(aCols)
			// If (cNatureza="24019" .Or. cNatureza="24520" .Or. cNatureza="24521" .Or. cNatureza="24013" .Or. cNatureza="24525" .Or. cNatureza="24585" .Or. cNatureza="24586" .Or. (cNatureza="24501" .And. (aCols[1][18]) <> "122001010")) .And. nPosRat>0 .And. (aCols[nx][nPosRat]) = "2"
			If cA100For $ cForRat .And. nPosRat > 0 .And. (aCols[nx][nPosRat]) == "2"
				MsgAlert("PREENCHA O RATEIO")
				lRet := .F.
				Exit
			EndIf
		Next
		For ny := 1 to Len(aCols)
			If (aCols[ny][nConta]) == "122001010" .And. nConta > 0 .And. Empty(aCols[ny][nItem])
				MsgAlert("PREENCHA O ITEM")
				lRet := .F.
				Exit
			EndIf
		Next
		For ny := 1 to Len(aCols)
			If (SubStr((aCols[ny][nConta]),1,1) == "4" .Or. SubStr((aCols[ny][nConta]),1,1) == "5") .And. nConta > 0 .And. Empty(aCols[ny][nCusto])
				MsgAlert("PREENCHA O CENTRO DE CUSTO")
				lRet := .F.
				Exit
			EndIf
		Next
	ElseIf cEmp == "01"
		For nx := 1 to Len(aCols)
			If cA100For $ cForRat .And. nPosRat > 0 .And. (aCols[nx][nPosRat]) == "2"
				MsgAlert("PREENCHA O RATEIO")
				lRet := .F.
				Exit
			EndIf
		Next
		For ny := 1 to Len(aCols)
			If (SubStr((aCols[ny][nConta]),1,1) == "4" .Or. SubStr((aCols[ny][nConta]),1,1) == "5") .And. nConta > 0 .And. Empty(aCols[ny][nCusto])
				MsgAlert("PREENCHA O CENTRO DE CUSTO")
				lRet := .F.
				Exit
			EndIf
		Next
		//chamado 4613 giovani zago 11/10/2016	
		For nx := 1 to Len(aCols)
			If SubStr((aCols[nx][nPosProd]),1,1) == "U" .And. GetMV("ST_COM01A",,.T.)//CASO PRECISE DESBLOQUEAR PONTUALMENTE
				If Posicione("SF4", 1, xFilial("SF4") + (aCols[nx][nPosTes]), "F4_ESTOQUE") == "S"
					MsgAlert("Codigo 'U' com Tes que Movimenta Estoque!!!!!  Produto: " + (aCols[nx][nPosProd]))
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next
		//chamado 4614 giovani zago 11/10/2016	
		For nx := 1 to Len(aCols)
			If GetMV("ST_COM01B",,.T.)	//CASO PRECISE DESBLOQUEAR PONTUALMENTE
				If aCols[nx][nPosTes] $ '036/038' .And. Empty(Alltrim(aCols[nx][nPosOp])) .And. cFormul == "N"	// Ticket 20210405005400 - Saldo de nota de entrada consumido como se fosse nota de beneficiamento. -- Inclusão do .And. cFormul == "N"
					MsgAlert("Codigo sem Op Amarrada!!!!!  Produto: " + (aCols[nx][nPosProd]))
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf
	
Return lRet
