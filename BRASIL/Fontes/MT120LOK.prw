#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT120LOK  ºAutor  ³Vitor Merguizo      º Data ³  03/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validação da linha obrigando o Centroº±±
±±º          ³ de Custo para determinados tipos de produtos               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT120LOK()

	Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
	Local nPosCC	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CC'})
	Local lValido	:= .T.
	Local nPosNSc	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMSC'})
	Local nPosISc	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEMSC'})
	Local nPosMot	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_MOTIVO'})
	Local nPosQtd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_QUANT'})
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRECO'})
	Local nQtdSC3	:= 0
	Local cParComp	:= GetMV("ST_CPCOMPR")
	If !U_STVLDSA2(CA120FORN,CA120LOJ) //Chamado 002995
		Return .F.
	EndIf
	dbSelectArea('SB1')
	dbSetOrder(1)	// B1_FILIAL + B1_COD
	If MsSeek(xFilial('SB1') + aCols[n][nPosPrd])
		If !SB1->B1_TIPO $ "MP,EM,PA,PI,PP,BN,IC" .And. Empty(aCols[n][nPosCC])
			lValido := .F.
			MsgAlert("Centro de Custo Obrigatorio!!!")
		EndIf
	EndIf
	If Alltrim(FunName()) == "MATA122"
		aCols[n][nPosMot] := "COT"
	Else
		//dbSelectArea("SC1")
		SC1->( dbSetOrder(1) )	// C1_FILIAL + C1_NUM + C1_ITEM + C1_ITEMGRD
		If SC1->( dbSeek(xFilial("SC1") + aCols[n,nPosNSc] + aCols[n,nPosISc]) )
			aCols[n][nPosMot] := SC1->C1_MOTIVO
		EndIf
	EndIf
	SC3->( dbSetOrder(1) )	// C3_FILIAL + C3_NUM + C3_ITEM
	If SC3->( dbSeek(xFilial("SC1") + aCols[n,nPosNSc] + aCols[n,nPosISc]) )
		nQtdSC3 := SC3->C3_QUANT - SC3->C3_QUJE
		If aCols[n][nPosQtd] > nQtdSC3
			apMsgInfo(	"As quantidades estão divergentes, conforme abaixo:" + CRLF + CRLF +;
						"<FONT COLOR='RED' SIZE='4'>Quantidade do C.P.: </FONT>" + Alltrim(cValtoChar(nQtdSC3)) + CRLF +;
						"<FONT COLOR='BLUE' SIZE='4'>Quantidade do A.E.: </FONT>" + Alltrim(cValtoChar(aCols[n][nPosQtd])) + CRLF + CRLF + CRLF +;
						"<B>Favor, informar a mesma quantidade do CP</B>","Atenção")
			lValido := .F.
		EndIf
		If aCols[n][nPosPrc] != SC3->C3_PRECO
			If !__cUserId $ cParComp
				apMsgInfo(	"Nao é permitido alteração de valor." + CRLF + CRLF +;
							"<B>Favor acionar o departamento de compras!!!</B>","Atenção")
				lValido := .F.
			EndIf
		EndIf
	EndIf
	If !U_STCOM110(aCols[n,nPosMot])
		Return .F.
	EndIf

Return lValido
