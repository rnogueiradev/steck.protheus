#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Transferencia de Reserva                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA40(cDoc)
	Local aCab		:= {}
	Local aCab1		:= {"Documento","Produto","Qtde Reservada","Fil.","Cliente","Vend2","Vend1","de:","ate"}
	Local aCab2		:= {"","","","Item","Produto","U.M.","Armazém","Quantidade","Reserva","Reserva DF","Falta"}
	Local aCab3		:= {"","","","Armazém","Produto","Quantidade","Reserva","Reserva DF","Falta"}
	Local aItDes  := {}
	Local aItOri	:= {}
	Local oDlg
	Local oLbxDes
	Local oLbxOri
	Local oPEnch,oPBInt,oPBIntE,oPBIntD, oPBDir, oEnc01
	
	Local aButtons 	:= {}
	Local aArea			:= GetArea()
	Local aSC5Area		:= SC5->(GetArea())
	Local aSC2Area		:= SC2->(GetArea())
	Local nRegAtu		:= 0
	Local	cAlias		:= ""
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local nI
	Local _cUseLib 		:= GetMv("ST_FSFA40",,"000000")
	Local _cUseLib1     := GetMv("ST_FSFA40C",,"000000") //Ticket 20210714012612 //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
	Default cDoc 		:= ""
	
	If Empty(cDoc)
		//Acesso pelo menu
		aAdd(aParamBox,{1,"Pedido de Venda"		,Space(6),"","","SC5"," Empty(MV_PAR02) "/*Validacao WHEN*/,0,.F.})
		aAdd(aParamBox,{1,"Ordem de Produção"	,Space(11),"","","SC2","  Empty(MV_PAR01) "/*Validacao WHEN*/,0,.F.})
		
		If !ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,,.f.)
			Return
		Endif
		For nI:=1 To Len(aRet)
			If !Empty(aRet[nI])
				cDoc := Alltrim(aRet[nI])
				Exit
			Endif
		Next
	Endif
	
	If len(Alltrim(cDoc)) == 11
		aCab	:= aCab3
		SC2->(DbSetOrder(1))
		If !SC2->(DbSeek(xFilial("SC5")+cDoc))
			Alert("Ordem de Produção " + cDoc + " não localizada!")
			Return
		Endif
		RegToMemory("SC2", .F. , .F.)
		nRegAtu	:= SC2->(Recno())
		cAlias	:= "SC2"
	Else
		aCab := aCab2
		SC5->(DbSetOrder(1))
		If !SC5->(DbSeek(xFilial("SC5")+cDoc))
			Alert("Pedido de Venda " + cDoc + " não localizado!")
			Return
		Endif
		If SC5->C5_XSTELLA = '1'
			//MsgInfo("Atenção Pedido c/ Stella Versao 2")
		ElseIf SC5->C5_XSTELLA = '2'
			//MsgInfo("Atenção Pedido c/ Stella Versao 3")
		EndIf
		RegToMemory("SC5", .F. , .F.)
		nRegAtu	:= SC5->(Recno())
		cAlias	:= "SC5"
	Endif
	
	//DEFINE MSDIALOG oDlg TITLE "Transferência de Reserva" FROM 178,181 TO 665,893 PIXEL
	DEFINE MSDIALOG oDlg TITLE "Transferência de Reserva" FROM 178,181 TO 1050,1500 PIXEL
	
	@00,00 MSPANEL oPEnch PROMPT "" SIZE 10,50 of oDlg
	oPEnch:Align := CONTROL_ALIGN_TOP
	
	@00,00 MSPANEL oPBInt PROMPT "" SIZE 140,20 of oDlg
	oPBInt:Align := CONTROL_ALIGN_ALLCLIENT
	
	@00,00 MSPANEL oPBEsq PROMPT "" SIZE 800,80 of oPBInt
	oPBEsq:Align := CONTROL_ALIGN_TOP
	
	@00,00 MSPANEL oPBDir PROMPT "" SIZE 10,10 of oPBInt
	oPBDir:Align := CONTROL_ALIGN_ALLCLIENT
	
	@00,00 MSPANEL oPBIntE PROMPT "" SIZE 20,20 of oPBDir
	oPBIntE:Align := CONTROL_ALIGN_TOP
	
	@00,00 MSPANEL oPBIntD PROMPT "" SIZE 10,10 of oPBDir
	oPBIntD:Align := CONTROL_ALIGN_ALLCLIENT
	
	
	oEnc01	:= MsMGet():New(cAlias,nRegAtu,2,,,,,{0,0,110,300},{},,,,,oPEnch,,,.F.,nil)
	oEnc01:oBox:Align:=CONTROL_ALIGN_ALLCLIENT
	
	oLbxDes := TWBrowse():New(10,10,230,95,,aCab,,oPBEsq,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oLbxDes:Align := CONTROL_ALIGN_ALLCLIENT
	If len(Alltrim(cDoc)) == 11
		MontaSD4(oLbxDes,aItDes)
		oLbxDes:bChange := {|| AtuDisp(oLbxOri,aItOri,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),aItDes[oLbxDes:nAt,5]) }
	Else
		MontaSC6(oLbxDes,aItDes)
		oLbxDes:bChange := {|| AtuDisp(oLbxOri,aItOri,SC5->C5_NUM+aItDes[oLbxDes:nAt,4],aItDes[oLbxDes:nAt,5]) }
	Endif
	
	If __cUserId $ _cUseLib+"#"+_cUseLib1 // Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
		TBtnBmp2():New(0,0,40,40 	,"PMSSETAUP", NIL, NIL,NIL,{|| TransRes(cDoc,oLbxDes,aItDes,oLbxOri,aItOri) }, oPBIntE, "TransferÊncia de Reservas", NIL, NIL,NIL )
	EndIf
	
	TBtnBmp2():New(0,40,40,40 ,"BMPVISUAL", NIL, NIL,NIL,{|| ViewDOC(aItOri[oLbxOri:nAt,1]) }, oPBIntE, "Visualiza Documento", NIL, NIL,NIL )
	
	oLbxOri := TWBrowse():New(10,10,230,95,,aCab1,,oPBIntD,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	Eval(oLbxDes:bChange)
	oLbxOri:Align := CONTROL_ALIGN_ALLCLIENT
	oLbxOri:blDBlClick := {|| ViewDOC(aItOri[oLbxOri:nAt,1])}
	
	
	ACTIVATE MSDIALOG oDlg  ON INIT EnchoiceBar(oDlg,{|| (oDlg:End()) } ,{||oDlg:End()},,aButtons)
	
	RestArea(aSC2Area)
	RestArea(aSC5Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta o listbox com os itens do pedido atual               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaSC6(oLbx,aItens)
	Local cStatus  := 1
	Local nFalta	:= 0
	Local nRes		:= 0
	Local nResDF	:= 0
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local oPreto	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oAmarelo := LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local aCores   := {oPreto,oPreto,oPreto}
	Local cPicture	:= "@E 999,999.99"
	Local aSC5Area	:= SC5->(GetArea())
	Local _cDoc1 	//renato 160413
	
	aItens:={}
	
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
	While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+SC5->C5_NUM)
		nRes		:=SC6->(U_STGetRes(C6_NUM+C6_ITEM,C6_PRODUTO,cFilAnt))
		nResDF	:=SC6->(U_STGetRes(C6_NUM+C6_ITEM,C6_PRODUTO,cFilDP))
		nFalta	:=SC6->(U_STGetFal(C6_NUM+C6_ITEM,C6_PRODUTO))
		aCores	:= {If(!Empty(nRes),oVerde,oPreto),If(!Empty(nResDF),oAmarelo,oPreto),If(!Empty(nFalta),oVermelho,oPreto)}
		SC6->(aadd(aItens,{aCores[1],aCores[2],aCores[3],C6_ITEM,C6_PRODUTO,C6_UM,C6_LOCAL,Transform(C6_QTDVEN,cPicture),Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture)," ",Recno()}))
		SC6->(DbSkip())
	End
	
	If Empty(aItens)
		SC6->(aadd(aItens,{aCores[1],aCores[2],aCores[3],"","","","","","","",""," ",0}))
	EndIf
	
	If oLbx<>NIL
		
		/*	For nX := 1 To Len(aItens) // renato 160413  abre
		
		cProduto	:= aItens[nX,5]
		cDoc		:= SC5->(FieldGet(FieldPos("C5_NUM")) + aItens[nX,4])
		
		_cDoc1	:= substr(alltrim(cDoc),1,8)
		
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SC9->(DbSeek(xFilial("SC9")+_cDoc1))
		
		If !SC9->(Eof())
			If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. EMPTY(SC9->C9_BLEST) .And. EMPTY(SC9->C9_BLCRED)
				MsgAlert("Existe ordem de separação em aberto para o pedido, não será possível eliminar o produto: "+cProduto)
				ADEL(aItens, nX)
				ASIZE(aItens, Len(aItens)-1)
				If Empty(aItens)
					SC6->(aadd(aItens,{oPreto,oPreto,oPreto,"","","","","","","",""," ",0}))
				EndIF
				Loop
			EndIf
		EndIf
		
	Next        			//renato 160413 fecha
	
	*/
	oLbx:SetArray( aItens )
	oLbx:bLine := {|| aEval(aItens[oLbx:nAt],{|z,w| aItens[oLbx:nAt,w] } ) }
	oLbx:Refresh()
EndIf

RestArea(aSC5Area)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  12/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ListBox com os empenhos da Ordem de Producao atual          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaSD4(oLbx,aItens2)
	Local cStatus  := 1
	Local nFalta	:= 0
	Local nRes		:= 0
	Local nResDF	:= 0
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local oPreto	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oAmarelo := LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local aCores   := {oPreto,oPreto,oPreto}
	Local cPicture	:= "@E 999,999.99"
	Local nPos		:= 0
	
	aItens2:={}
	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
	While SD4->(! Eof() .and. Alltrim(D4_FILIAL+D4_OP) == Alltrim(xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		nRes		:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilAnt))
		nResDF	:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilDP))
		nFalta	:=SD4->(U_STGetFal(AllTrim(D4_OP),D4_COD))
		aCores	:= {If(!Empty(nRes),oVerde,oPreto),If(!Empty(nResDF),oAmarelo,oPreto),If(!Empty(nFalta),oVermelho,oPreto)}
		nPos := Ascan(aItens2,{|x| x[4]+x[5] == SD4->(D4_LOCAL+D4_COD)})
		If nPos == 0
			SD4->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],D4_LOCAL,D4_COD,D4_QTDEORI,Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture)," ",Recno()}))
		Else
			aItens2[nPos,6]+=SD4->D4_QTDEORI
		EndIf
		
		//	SD4->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],D4_LOCAL,D4_COD,Transform(D4_QTDEORI,cPicture),Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture)," ",Recno()}))
		SD4->(DbSkip())
	End
	If Empty(aItens2)
		SD4->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],"","","","","",""," ",0}))
	EndIf
	If oLbx<>NIL
		oLbx:SetArray( aItens2 )
		oLbx:bLine := {|| aEval(aItens2[oLbx:nAt],{|z,w| aItens2[oLbx:nAt,w] } ) }
		oLbx:Refresh()
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Preapara a montagem do listbox que ira doar/perder a reservaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDisp(oLbxOri,aItOri,cDocAtu,cProdAtu)
	Local _cUseLib  := GetMv("ST_FSFA40",,"000000")
	Local _cUseLib1 := GetMv("ST_FSFA40C",,"000000") //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
	Local _cVend1	 := ""
	Local _cVend2	 := ""
	
	aItOri := {}
	
	PA2->(DbSetOrder(1))//PA2_FILIAL+PA2_CODPRO+PA2_FILRES
	PA2->(DbSeek(xFilial("PA2")+cProdAtu+cfilant))//Giovani Zago 23/09/13
	While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES == xFilial("PA2")+cProdAtu+cfilant)
		
		aPA2 := PA2->(GetArea())
		aSC5 := SC5->(GetArea())
		
		_cPedido := Substr(PA2->PA2_DOC,1,6)
		
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+_cPedido))
		
		If !SC5->(Eof())															//Renato Nogueira [04062013] - Liberado para alterar a prioridade dos pedidos de exportação somente os usuários abaixo
			_cVend1	:= Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")
			_cVend2	:= Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_NOME")
			If SC5->C5_TIPOCLI == "X" .And. !__cUserId $ GetMv("ST_XARESEX")
				RestArea(aPA2)
				RestArea(aSC5)
				PA2->(DbSkip())
				Loop
				/*
			ELseIf SC5->C5_TIPOCLI <> "X" .And. !__cUserId $ _cUseLib+"#"+_cUseLib1 //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
				RestArea(aPA2)
				RestArea(aSC5)
				PA2->(DbSkip())
				Loop
				*/
				
			EndIf
		EndIf
		
		
		
		If !(Alltrim(PA2->PA2_DOC) == cDocAtu)
			PA2->(Aadd(aItOri,{PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES,SC5->C5_XNOME,_cVend2,_cVend1,SC5->C5_XDE+"/"+SC5->C5_XMDE+"/"+SC5->C5_XDANO,SC5->C5_XATE+"/"+SC5->C5_XMATE+"/"+SC5->C5_XAANO})) //Chamado 002370 - Renato Nogueira CHAMADO 003599 GIOVANI ZAGO
		Endif
		
		RestArea(aPA2)
		RestArea(aSC5)
		
		PA2->(DbSkip())
	End
	
	If Empty(aItOri)
		PA2->(Aadd(aItOri,{"","",0,"","","","","",""}))
	EndIf
	
	If oLbxOri<>NIL
		oLbxOri:SetArray( aItOri )
		oLbxOri:bLine := {|| aEval(aItOri[oLbxOri:nAt],{|z,w| aItOri[oLbxOri:nAt,w] } ) }
		oLbxOri:Refresh()
	EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza o documento que ira' perder/doar a reserva        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewDOC(cDoc)
	Local cTipDoc	:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aArea		:= GetArea()
	Local aSC2Area	:= SC2->(GetArea())
	Local aSC5Area	:= SC5->(GetArea())
	
	Private cCadastro := "Ordem de Produção"
	Private aRotina := {{"Pesquisa","AxPesqui"		,0,1,0 ,.F.},{ "Visual","A410Visual"	,0,2,0 ,NIL}}
	
	If cTipDoc == "1"
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+Alltrim(cDoc)))
			a410Visual('SC5',SC5->(Recno()),2)
		Else
			Alert("Pedido de venda "+Alltrim(cDoc)+" não localizado!!")
		Endif
	Else
		SC2->(DbSetOrder(1))
		If SC2->(DbSeek(xFilial("SC2")+cDoc))
			a650View("SC2",SC2->(Recno()),2)
		Else
			Alert("Ordem de produção "+Alltrim(cDoc)+" não localizada!!")
		Endif
	Endif
	
	RestArea(aSC5Area)
	RestArea(aSC2Area)
	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para executar a transferencia da reserva             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TransRes(cDoc,oLbxDes,aItDes,oLbxOri,aItOri)
	Local cDocOri 	:=aItOri[oLbxOri:nAt,1]
	Local cProduto	:=aItOri[oLbxOri:nAt,2]
	Local nQtdDoc	:= 0
	Local nFalta	:= 0
	Local nReserva	:= 0
	Local nDF		:= 0
	Local nQtdTran	:= IIf(Len(AllTrim(aItOri[oLbxOri:nAt,03]))>=8,SuperVal(StrTran(StrTran(aItOri[oLbxOri:nAt,03],".",),",",".")),SuperVal(aItOri[oLbxOri:nAt,03]))
	Local nQtdRes	:= IIf(Len(AllTrim(aItOri[oLbxOri:nAt,03]))>=8,SuperVal(StrTran(StrTran(aItOri[oLbxOri:nAt,03],".",),",",".")),SuperVal(aItOri[oLbxOri:nAt,03]))
	Local cFilTran	:= aItOri[oLbxOri:nAt,04]
	Local aParamBox:= {}
	Local aRet		:= {}
	Local _cStell   := ' '
	Local _cSteNu   := ' '
	If Empty(cFilTran)
		Return
	Endif
	If Len(Alltrim(cDoc))<> 11
		_cStell:=(Substr(SC5->C5_XSTELLA,1,1))
		_cSteNu:= SC5->C5_NUM
		If (_cStell ='1' .Or. _cStell ='2' )
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+Alltrim(cDoc)))
				If  Substr(SC5->C5_XSTELLA,1,1) <> _cStell
					SC5->(DbSetOrder(1))
					If SC5->(DbSeek(xFilial("SC5")+Alltrim(_cSteNu)))
						//	MsgInfo("Versão Stella Diferente Verifique...!!!!")
						//	Return()
					Endif
				Endif
			Endif
		Endif
	Endif
	If Len(Alltrim(cDoc))<> 11  // completa a chave do documento quando pedido
		cDoc		+= aItDes[oLbxDes:nAt,04]
		nQtdDoc		:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,08]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,08],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,08]))
		nReserva	:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,09]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,09],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,09]))
		nDF			:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,10]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,10],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,10]))
		nFalta 		:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,11]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,11],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,11]))
		
	Else
		nQtdDoc		:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,06]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,06],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,06]))
		nReserva 	:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,07]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,07],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,07]))
		nDF			:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,08]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,08],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,08]))
		nFalta 		:= IIf(Len(AllTrim(aItDes[oLbxDes:nAt,09]))>=8,SuperVal(StrTran(StrTran(aItDes[oLbxDes:nAt,09],".",),",",".")),SuperVal(aItDes[oLbxDes:nAt,09]))
	EndIf
	
	If Empty(nFalta)
		MsgAlert("Não há falta para o item " + Alltrim(cProduto) + "-" + Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")) + "!")
		Return
	Endif
	
	If nQtDdoc == nReserva
		MsgAlert("Este documento não necessita de transferência de reserva!!!")
		Return
	EndIf
	
	If nQtdTran > nFalta
		nQtdTran := nFalta
	EndIf
	
	aAdd(aParamBox,{1,"Quantidade",nQtdTran,"@E 99999999.99","","","",0,.T.})
	
	While .T.
		If !ParamBox(aParamBox,"Informe a quantidade a ser transferida",@aRet,,,,,,,,.f.)
			Return
		Endif
		
		If mv_par01 > nFalta
			MsgAlert("Quantidade informada maior que a quantidade em falta!!!")
			Loop
		ElseIf mv_par01 > nQtdRes
			MsgAlert("Quantidade informada maior que a quantidade reservada!!!")
			Loop
		EndIf
		
		Exit
	EndDo
	nQtdTran := mv_par01
	
	If nQtdTran >= nFalta
		U_STReserva(cDocOri,cProduto,nFalta,"-",cFilTran)
		U_STFalta(cDocOri,cProduto,nFalta,"+")
		
		U_STReserva(cDoc,cProduto,nFalta,"+",cFilAnt)
		U_STFalta(cDoc,cProduto,nFalta,"-")
	Else
		U_STReserva(cDocOri,cProduto,nQtdTran,"-",cFilTran)
		U_STFalta(cDocOri,cProduto,nQtdTran,"+")
		
		U_STReserva(cDoc,cProduto,nQtdTran,"+",cFilAnt)
		U_STFalta(cDoc,cProduto,nQtdTran,"-")
	Endif

	U_STFAT631(cDocOri,cDoc,cProduto,nQtdTran,"Transferencia de reserva") //log transferencia de reserva
	
	If Len(Alltrim(cDoc))<> 11
		U_STGrvSt(SC5->C5_NUM+aItDes[oLbxDes:nAt,4])
		MontaSC6(oLbxDes,aItDes)
		AtuDisp(oLbxOri,aItOri,SC5->C5_NUM+aItDes[oLbxDes:nAt,4],aItDes[oLbxDes:nAt,5])
	Else
		U_STGrvSt(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
		MontaSD4(oLbxDes,aItDes)
		AtuDisp(oLbxOri,aItOri,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),aItDes[oLbxDes:nAt,5])
	Endif
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina reserva de produto                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSFA41(cDoc,cProduto)
	
	Local aRet			:= {}
	Local aParamBox	:= {}
	Local aButtons		:= {}
	Local aCab			:= {" ","Documento","Produto","Qtde Reservada","Filial da Reserva"}
	Local aAreaSB1
	Local lChk 		:= .F.
	Local oChk
	Local lOk		:= .F.
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local _cUseLib := GetMv("ST_FSFA40",,"000000")
	Local _cUseLib1 := GetMv("ST_FSFA40C",,"000000") //Ticket 20210714012612
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private aLbxDes		:= {}
	Private oLbxDes
	Default cDoc 		:= ""
	
	If !__cUserId $ _cUseLib1+"#"+_cUseLib //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
		MsgAlert("Usuário sem acesso!")
		Return
	EndIf
		
	//aAdd(aButtons,{"BMPDEL"  	,{|| MataRes(aLbxDes[oLbxDes:nAt,1],aLbxDes[oLbxDes:nAt,2],aLbxDes[oLbxDes:nAt,3],;
		//										aLbxDes[oLbxDes:nAt,4],oLbxDes,aLbxDes)}	,"Eliminar"})
	//aAdd(aButtons,{"BMPVISUAL"	,{|| ViewDOC(aLbxDes[oLbxDes:nAt,1])}		,"Vis. Doc."	})
	aAdd(aButtons,{"BMPVISUAL"	,{|| MarkAll(aLbxDes[oLbxDes:nAt,1])}		,"Marca todos"	})
	aAdd(aButtons,{"BMPVISUAL"	,{|| DesmAll(aLbxDes[oLbxDes:nAt,1])}		,"Desmarca todos"	})
	
	If Empty(cProduto)
		//Acesso pelo menu
		aAdd(aParamBox,{1,"Produto"				,Space(15),"","","SB1","",0,.T.})
		If !ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,,.f.)
			Return
		Endif
		aAreaSB1	:= SB1->(GetArea())
		SB1->(DBSetOrder(1))
		If ! SB1->(DbSeek(xFilial('SB1'+MV_PAR01)))
			MsgAlert("Produto nçao encontrado","Atenção")
			RestArea(aAreaSB1)
			Return
		EndIf
		RestArea(aAreaSB1)
		cProduto := mv_par01
	Endif
	
	//MataRes(cDoc,cProduto)
	MontaPA2(oLbxDes,aLbxDes,cDoc,Padr(cProduto,15))
	DEFINE MSDIALOG oDlg TITLE "Eliminação de Reserva" From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() PIXEL
	
	//oLbxDes := TWBrowse():New(10,10,230,95,,aCab,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//oLbxDes:Align := CONTROL_ALIGN_ALLCLIENT
	
	//oLbxDes:blDBlClick := {|| ViewDOC(aLbxDes[oLbxDes:nAt,1])}
	
	//TBtnBmp2():New(0,40,40,40 ,"BMPVISUAL", NIL, NIL,NIL,{|| ViewDOC(aItOri[oLbxOri:nAt,1]) }, oPBIntE, "Visualiza Documento", NIL, NIL,NIL )
	
	@ 40,1 listbox oLbxDes fields header " ","Documento","Produto","Qtde Reservada","Filial da Reserva"  size  650,250  pixel of oDlg on dbLclick(edlista())
	
	oLbxDes:SetArray( aLbxDes )
	
	oLbxDes:bLine := {|| {Iif(	aLbxDes[oLbxDes:nAt,1],oOk,oNo),;
		aLbxDes[oLbxDes:nAt,2],;
		aLbxDes[oLbxDes:nAt,3],;
		aLbxDes[oLbxDes:nAt,4],;
		aLbxDes[oLbxDes:nAt,5];
		}}
	
	
	
	ACTIVATE MSDIALOG oDlg  ON INIT EnchoiceBar(oDlg,{||  lOk:= .t., oDlg:End()} ,{||oDlg:End()},,aButtons)
	
	If lOk
		If MsgYesNo("Confirma a eliminação de todas as reservas selecionadas?")
			xMataRes()
		EndIf
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina reserva de produto                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSFA42(cDoc,cProduto)
	
	Local aRet			:= {}
	Local aParamBox	:= {}
	Local aLbxDes		:= {}
	Local aButtons		:= {}
	Local aCab			:= {"Documento","Produto","Qtde Reservada","Filial da Reserva"}
	Local oLbxDes
	Local aAreaSB1
	Local _cUseLib  := GetMv("ST_FSFA40",,"000000")
	Local _cUseLib1 := GetMv("ST_FSFA40C",,"000000") //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
	
	Default cDoc		:= ""
	
	If __cUserId $ _cUseLib+"#"+_cUseLib1 //Ticket 20210917019266 em 04/10/11 por Priscila Castro Sigamat
		aAdd(aButtons,{"BMPDEL"  	,{|| MataRes(aLbxDes[oLbxDes:nAt,1],aLbxDes[oLbxDes:nAt,2],aLbxDes[oLbxDes:nAt,3],;
			aLbxDes[oLbxDes:nAt,4],oLbxDes,aLbxDes)}	,"Eliminar"})
	EndIf
	aAdd(aButtons,{"BMPVISUAL"	,{|| ViewDOC(aLbxDes[oLbxDes:nAt,1])}		,"Vis. Doc."	})
	
	If Empty(cProduto)
		//Acesso pelo menu
		aAdd(aParamBox,{1,"Produto"				,Space(15),"","","SB1","",0,.T.})
		If !ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,,.f.)
			Return
		Endif
		aAreaSB1	:= SB1->(GetArea())
		SB1->(DBSetOrder(1))
		If ! SB1->(DbSeek(xFilial('SB1'+MV_PAR01)))
			MsgAlert("Produto nçao encontrado","Atenção")
			RestArea(aAreaSB1)
			Return
		EndIf
		RestArea(aAreaSB1)
		cProduto := mv_par01
	Endif
	
	//MataRes(cDoc,cProduto)
	
	DEFINE MSDIALOG oDlg TITLE "Eliminação de Reserva" FROM 178,181 TO 665,893 PIXEL
	
	oLbxDes := TWBrowse():New(10,10,230,95,,aCab,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oLbxDes:Align := CONTROL_ALIGN_ALLCLIENT
	xMontaPA2(oLbxDes,aLbxDes,cDoc,Padr(cProduto,15))
	oLbxDes:blDBlClick := {|| ViewDOC(aLbxDes[oLbxDes:nAt,1])}
	//TBtnBmp2():New(0,40,40,40 ,"BMPVISUAL", NIL, NIL,NIL,{|| ViewDOC(aItOri[oLbxOri:nAt,1]) }, oPBIntE, "Visualiza Documento", NIL, NIL,NIL )
	
	
	ACTIVATE MSDIALOG oDlg  ON INIT EnchoiceBar(oDlg,{|| (oDlg:End()) } ,{||oDlg:End()},,aButtons)
	
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta Array para eliminacao da reserva                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaPA2(oLbxDes,aLbxDes,cDoc,cProduto)
	
	Local aArea
	Local cAltExp	:= GetMv("ST_XARESEX")
	
	aLbxDes := {}
	PA2->(DbSetOrder(1))//PA2_FILIAL+PA2_CODPRO+PA2_FILRES
	PA2->(DbSeek(xFilial("PA2")+Padr(cProduto,15)))
	While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODPRO == xFilial("PA2")+Padr(cProduto,15))
		If Empty(cDoc) .or. Alltrim(PA2->PA2_DOC) == Alltrim(cDoc)
			If Len(Alltrim(PA2->PA2_DOC))==11
				PA2->(Aadd(aLbxDes,{.T.,PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
			Else
				aArea     := PA2->(GetArea())
				DbSelectArea("SC5")
				DbSetOrder(1) //C5_FILIAL+C5_NUM
				DbSeek(xFilial("SC5")+SubStr(PA2->PA2_DOC,1,6))
				If SC5->(!Eof() .And. SC5->C5_TIPOCLI<>"X")  //Renato Nogueira - 241013 - Adicionado filtro para não mostrar pedidos de exportação
					PA2->(Aadd(aLbxDes,{.T.,PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
				ElseIf SC5->(!Eof() .And. SC5->C5_TIPOCLI=="X" .And. __cUserId $ cAltExp)
					PA2->(Aadd(aLbxDes,{.T.,PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
				ElseIf SC5->(!Eof() .And. SC5->C5_TIPOCLI=="X" .And. !__cUserId $ cAltExp)
					PA2->(Aadd(aLbxDes,{.F.,"","",0,""}))
				EndIf
				RestArea(aArea)
			EndIf
		Endif
		PA2->(DbSkip())
	End
	
	If Empty(aLbxDes)
		Aadd(aLbxDes,{.F.,"","",0,""})
	EndIf
	
	//oLbxDes:SetArray( aLbxDes )
	//oLbxDes:bLine := {|| aEval(aLbxDes[oLbxDes:nAt],{|z,w| aLbxDes[oLbxDes:nAt,w] } ) }
	//oLbxDes:Refresh()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta Array para eliminacao da reserva                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xMontaPA2(oLbxDes,aLbxDes,cDoc,cProduto)
	
	Local aArea
	Local cAltExp	:= GetMv("ST_XARESEX")
	
	aLbxDes := {}
	PA2->(DbSetOrder(1))//PA2_FILIAL+PA2_CODPRO+PA2_FILRES
	PA2->(DbSeek(xFilial("PA2")+Padr(cProduto,15)))
	While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODPRO == xFilial("PA2")+Padr(cProduto,15))
		If Empty(cDoc) .or. Alltrim(PA2->PA2_DOC) == Alltrim(cDoc)
			If Len(Alltrim(PA2->PA2_DOC))==11
				PA2->(Aadd(aLbxDes,{PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
			Else
				aArea     := PA2->(GetArea())
				DbSelectArea("SC5")
				DbSetOrder(1) //C5_FILIAL+C5_NUM
				DbSeek(xFilial("SC5")+SubStr(PA2->PA2_DOC,1,6))
				If SC5->(!Eof() .And. SC5->C5_TIPOCLI<>"X")  //Renato Nogueira - 241013 - Adicionado filtro para não mostrar pedidos de exportação
					PA2->(Aadd(aLbxDes,{PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
				ElseIf SC5->(!Eof() .And. SC5->C5_TIPOCLI=="X" .And. __cUserId $ cAltExp)
					PA2->(Aadd(aLbxDes,{PA2_DOC,PA2_CODPRO,Str(PA2_QUANT,15,2),PA2_FILRES}))
				ElseIf SC5->(!Eof() .And. SC5->C5_TIPOCLI=="X" .And. !__cUserId $ cAltExp)
					PA2->(Aadd(aLbxDes,{"","",0,""}))
				EndIf
				RestArea(aArea)
			EndIf
		Endif
		PA2->(DbSkip())
	End
	
	If Empty(aLbxDes)
		Aadd(aLbxDes,{.F.,"","",0,""})
	EndIf
	
	oLbxDes:SetArray( aLbxDes )
	oLbxDes:bLine := {|| aEval(aLbxDes[oLbxDes:nAt],{|z,w| aLbxDes[oLbxDes:nAt,w] } ) }
	oLbxDes:Refresh()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina a reserva selecionado                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MataRes(cDoc,cProduto,nQtde,cFilRes,oLbxDes,aLbxDes)
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local _cDoc1              //renato 160413
	
	nQtde := SuperVal(nQtde)
	If Empty(nQtde)
		MsgAlert("Não há reserva para ser eliminada!")
		Return
	Endif
	
	_cDoc1	:= substr(alltrim(cDoc),1,8)	   //renato 160413 abre
	
	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	SC9->(DbSeek(xFilial("SC9")+_cDoc1))
	
	If !SC9->(Eof())
		If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. EMPTY(SC9->C9_BLEST) .And. EMPTY(SC9->C9_BLCRED)
			MsgAlert("Existe ordem de separação em aberto para o pedido, não será possível eliminar")
			Return
		EndIf
	EndIf         			             //renato 160413 fecha
	
	aAdd(aParamBox,{1,"Quantidade",nQtde,"99999999.99","","","",0,.F.})
	
	If !ParamBox(aParamBox,"Informe a quantidade a ser eliminada",@aRet,,,,,,,,.f.)
		Return
	Endif
	
	nQtde := mv_par01
	
	U_STReserva(cDoc,cProduto,nQtde,"-",cFilRes)
	U_STFalta(cDoc,cProduto,nQtde,"+")
	U_STGrvSt(cDoc)
	MontaPA2(oLbxDes,aLbxDes,cDoc,Padr(cProduto,15))
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desmarca/Marca			                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function edlista
	
	aLbxDes[oLbxDes:nAt,1]:= ! aLbxDes[oLbxDes:nAt,1]
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Marca tudo			                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarkAll
	
	Local nX	:= 0
	
	For nX:=1 To Len(aLbxDes)
		
		aLbxDes[nX][1]:= .T.
		
	Next
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desmarca tudo 			                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DesmAll
	
	Local nX	:= 0
	
	For nX:=1 To Len(aLbxDes)
		
		aLbxDes[nX][1]:= .F.
		
	Next
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA40  ºAutor  ³Microsiga           º Data ³  01/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina a reserva selecionado                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xMataRes()
	
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local _cDoc1              //renato 160413
	Local nX	:= 0
	
	For nX:=1 To Len(aLbxDes)
		
		If aLbxDes[nX][1]
			
			_cDoc1	:= substr(alltrim(aLbxDes[nX][2]),1,8)	   //renato 160413 abre
			
			SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			SC9->(DbSeek(xFilial("SC9")+_cDoc1))
			
			If !SC9->(Eof())
				If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. EMPTY(SC9->C9_BLEST) .And. EMPTY(SC9->C9_BLCRED)
					MsgAlert("Existe ordem de separação em aberto para o pedido, não será possível eliminar")
					Return
				EndIf
			EndIf         			             //renato 160413 fecha
			
			U_STReserva(aLbxDes[nX][2],aLbxDes[nX][3],Val(aLbxDes[nX][4]),"-",aLbxDes[nX][5])
			U_STFalta(aLbxDes[nX][2],aLbxDes[nX][3],Val(aLbxDes[nX][4]),"+")
			U_STGrvSt(aLbxDes[nX][2])

			U_STFAT631(aLbxDes[nX][2],"",aLbxDes[nX][3],Val(aLbxDes[nX][4]),"Eliminação de reserva") //log eliminação de reserva
			
		EndIf
		
	Next
	
Return
