#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACDI11PA     ºAutor  ³Giovani Zago     º Data ³  06/12/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada  Impressao de Etiqueta					  º±±
±±º          ³  								                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------*
User Function ACDI11PA()
	*---------------------------------------------------*
	Local aParam := PARAMIXB[1]
	Local aRet:={}
	Local cFunName := Upper(FunName())

	If "STFSRE" $ cFunName  // impressão de cartao
		aParam[1,4] := {|| NFPA0()}   	// altera a rotina de montagem do array do listbox
		aadd(aParam[1,2],	{1,"Emissão"			,SPACE(8)	,"","",""			,".T.",60,.F.})
		aadd(aParam[1,3],  dDataBase)

		aadd(aParam[2,2],	{1,"Emissão"			,SPACE(8)	,"","",""			,".T.",60,.F.})
		aadd(aParam[2,3], dDataBase)

		aadd(aParam[3,2],	{1,"Emissão"			,SPACE(8)	,"","",""			,".T.",60,.F.})
		aadd(aParam[3,3], dDataBase)

		aParam[3,4] := {|| AWzVOP()}  	// altera a rotina de montagem do array do listbox

		aadd(aParam,ParCartao())			// acrescenta mais uma opcao para impressao referente a ordem de separacao
		aadd(aParam[4,2],	{1,"Emissão"			,SPACE(8)	,"","",""			,".T.",60,.F.})
		aadd(aParam[4,3],   dDataBase)

		If cFunName == "U_STFSRE21"
			aadd(aRet,aClone(aParam[1]))
		ElseIf cFunName == "U_STFSRE22"
			aadd(aRet,aClone(aParam[2]))
		ElseIf cFunName =="U_STFSRE23"
			aadd(aRet,aClone(aParam[3]))
		ElseIf cFunName =="U_STFSRE24"
			aadd(aRet,aClone(aParam[4]))
		Else
			aRet:=aClone(aParam)
		EndIf
		//aRet:=aClone(aParam)
	ElseIf "STFSPC" $ cFunName // impressao de produto acabado
		aParam:= ParPA()
		If cFunName == "U_STFSPC31"
			aadd(aRet,aClone(aParam[2]))   	// por produto
		ElseIf cFunName == "U_STFSPC32"
			aadd(aRet,aClone(aParam[3]))   	// por OP
		ElseIf cFunName =="U_STFSPC33"
			aadd(aRet,aClone(aParam[1]))   	// ordem de separcao
		Else
			aRet:=aClone(aParam)			   	// todos
		EndIf
	Endif

Return aRet


//===============================================   CARTAO ===========================
Static Function ParCartao()
	Local aPar		:=	{	{1,"Ordem de Separação"	,Space(6),"","","CB7FS3"				,".T.",0,.F.}}
	Local aRet	   := 	{Space(6)}
	Local aParam	:={"Ordem de Separacao" ,aPar,aRet,{|| AWzVOS()}}
Return aClone(aParam)

Static Function AWzVOS()
	Local	cOrdSep	:= Padr(MV_PAR01,6)
	Local nQE
	Local nQVol
	Local nResto
	Local oOk           := LoadBitmap( GetResources(), "LBOK" )
	Local oNo           := LoadBitmap( GetResources(), "LBNO" )
	Local nT			:= TamSx3("D3_QUANT")[1]
	Local nD			:= TamSx3("D3_QUANT")[2]


	CB7->(DbSetOrder(1))
	If ! CB7->(DbSeek(xFilial('CB7')+cOrdSep))
		MsgAlert(" Ordem de Separação "+cOrdSep+" não encontrada !")
		Return .F.
	EndIf

	aLbx:={}
	CB8->(DbSetOrder(1))
	CB8->(dbSeek(xFilial('CB8')+CB7->CB7_ORDSEP))
	While CB8->(!EOF()  .and. CB8_FILIAL+CB8_ORDSEP ==xFilial('CB8')+CB7->CB7_ORDSEP )
		SB1->(dbSeek(xFilial('SB1')+CB8->CB8_PROD))
		If ! CBImpEti(SB1->B1_COD)
			CB8->(dbSkip()	)
			Loop
		EndIf
		nQE   := CBQEmbI()
		nQE	:= If(Empty(nQE),1,nQE)
		If ! Empty(CB8->CB8_LOTECT)
			nQVol := Int(CB8->CB8_QTDORI/nQE)
			nResto  :=CB8->CB8_QTDORI%nQE
			If nResto >0
				nQVol++
			EndIf
			CB8->(aadd(aLbx,{.f.,CB8_PROD,Str(CB8_QTDORI,nT,nD),Str(nQe,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),CB8_LOTECT,Space(20),"CB8",Recno()}))
		Else
			PA0->(DbSetOrder(1))
			PA0->(DbSeek(xFilial("PA0")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD)))
			While PA0->(! Eof() .and. PA0_FILIAL+PA0_ORDSEP+PA0_ITSEP+PA0_PROD == xFilial("PA0")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD))
				nQVol := Int(PA0->PA0_QTDE/nQE)
				nResto  :=PA0->PA0_QTDE%nQE
				If nResto >0
					nQVol++
				EndIf
				CB8->(aadd(aLbx,{.f.,CB8_PROD,Str(PA0->PA0_QTDE,nT,nD),Str(nQe,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),PA0->PA0_LOTEX,Space(20),"CB8",Recno()}))
				PA0->(DbSkip())
			End
		EndIf
		CB8->(dbSkip()	)
	End
	If Empty(aLbx)
		aadd(aLbx,{.f.,Space(15),Str(0,10),Str(0,10),Str(0,10),Str(0,10),Space(10),Space(20),"SB1",0})
	EndIf

	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()

Return .t.

Static Function NFPA0()
	Local	cNota 	:= Padr(MV_PAR01,9)
	Local	cSerie	:= Padr(MV_PAR02,3)
	Local	cForn 	:= Padr(MV_PAR03,6)
	Local cLoja 	:= Padr(MV_PAR04,2)
	Local nQE
	Local nQVol
	Local nResto
	Local oOk      := LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo      := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local xLote		:= Space(10)
	Local nT			:= TamSx3("D3_QUANT")[1]
	Local nD			:= TamSx3("D3_QUANT")[2]

	If Empty(cNota+cSerie+cForn+cLoja)
		MsgAlert(" Necessario informar a nota e o fornecedor. ")
		Return .F.
	EndIf
	SF1->(DbSetOrder(1))
	If ! SF1->(DbSeek(xFilial('SF1')+cNota+cSerie+cForn+cLoja))
		MsgAlert(" Nota fiscal não encontrada. ")
		Return .F.
	EndIf

	aLbx:={}
	PA0->(DbSetOrder(2))
	SD1->(DbSetOrder(1))
	SD1->(dbSeek(xFilial('SD1')+cNota+cSerie+cForn+cLoja)	)
	While SD1->(!EOF()  .and. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial('SD1')+cNota+cSerie+cForn+cLoja)
		SB1->(dbSeek(xFilial('SB1')+SD1->D1_COD))
		If ! CBImpEti(SB1->B1_COD)
			SD1->(dbSkip()	)
			Loop
		EndIf
		nQE   	:= CBQEmbI()
		nQE		:= If(Empty(nQE),1,nQE)
		nQVol 	:= Int(SD1->D1_QUANT/nQE)
		nResto  	:=SD1->D1_QUANT%nQE
		xLote 	:=Space(10)
		If nResto >0
			nQVol++
		EndIf
		If PA0->(DbSeek(xFilial('PA0')+'SD1'+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)))
			xLote := PA0->PA0_LOTEX
		EndIf
		SD1->(aadd(aLbx,{.f.,D1_COD,Str(SD1->D1_QUANT,nT,nD),Str(nQe,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),xLote,Space(20),"SD1",Recno()}))
		SD1->(dbSkip()	)
	End
	If Empty(aLbx)
		aadd(aLbx,{.f.,Space(15),Str(0,10),Str(0,10),Str(0,10),Str(0,10),Space(10),Space(20),"SB1",0})
	EndIf
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()
Return .t.



//===============================================   PRODUTO ACABADO ===========================
Static Function ParPA()

	Local aYesNo	:= {"Sim","Não"}
	Local aCompo 	:= {"mat.plastico","ligas/aleaciones metálicas","mat.plastico e/y ligas/aleaciones metalicas"}
	Local aTam		:= {"Grande","Pequeno"}
	//Local aImpor	:= {"Padrao","Mexico"}
	Local aImpor	:= {"Padrao"}
	Local aEmp		:= BuscaEmp()
	Local aYesNo1	:= {"Sim","Não"}

	Local aParPR	:=	{	{1,"Produto"			,Space(15)	,"","U_ACDI11V(1)","SB1"			,".T.",60,.F.},;
	{2,"Coletivo"			,2 ,aYesNo 	,50						,".T.",.F.},;
	{2,"Importado"			,1	,aImpor	,50						,".T.",.F.},;
	{2,"Tamanho"			,1	,aTam		,50						,".T.",.F.},;
	{2,"EAN14"				,1	,aYesNo1		,50						,".T.",.F.}}
	//{2,"Empresa"			,1	,aEmp		,70						,".T.",.F.}}

	Local aRetPR   := {Space(15),"","","    ","    ","",""}

	Local aParOP	:=	{	{1,"Ordem Produção"	,Space(13)	,"","U_ACDI11V(2)","SC2"				,".T.",50,.F.},;
	{2,"Coletivo"			,2 ,aYesNo 	,50						,".T.",.F.},;
	{2,"Importado"			,1,aImpor	,50						,".T.",.F.},;
	{2,"Tamanho"			,1,aTam		,50						,".T.",.F.},;
	{2,"Empresa"			,1	,aEmp		,70						,".T.",.F.}}

	Local aRetOP   := {Space(13),"","","    ","    ","",""}

	Local aParCB7		:=	{	{1,"Ordem de Separação"	,Space(06),"","","CB7FS1"				,".T.",0,.F.}}
	Local aRetCB7	   := {Space(06),"","","    ","    ","",""}  							//alterado dia 29/11/12 pois estava faltando parâmetros


	Local aParam	:={		{"Ordem de Separacao" 	,aParCB7	,aRetCB7,{|| AWzVOS()}},;   //alterado dia 29/11/12 pois ordem estava incorreta
	{"Produto"				,aParPR		,aRetPR	,{|| AWzVPR()}},;	//alterado dia 29/11/12 pois ordem estava incorreta
	{"Ordem de Produção" 	,aParOP		,aRetOP	,{|| AWzVOP()}}} 	//alterado dia 29/11/12 pois ordem estava incorreta

Return aClone(aParam)

Static Function BuscaEmp()
	Local nRecnoSM0 := SM0->(Recno())
	Local aEmp	:= {}
	SM0->(DBGoTop())
	While ! SM0->(Eof())
		SM0->(aadd(aEmp,M0_CODIGO+"-"+M0_CODFIL+"-"+M0_NOME))
		SM0->(DbSkip())
	End
	SM0->(DbGoto(nRecnoSM0))
Return aClone(aEmp)



User Function ACDI11V(nModo)
	Local cProduto
	Local cOP
	Local aSC2:= SC2->(GetArea())
	Local aSB1:= SB1->(GetArea())

	If nModo == 2 // por op
		cOP		:= Padr(MV_PAR01,15)
		SC2->(DbSetorder(1))
		If !  SC2->(DbSeek(xFilial('SC2')+cOP))
			MsgAlert("Ordem de produção não encontrada!!!")
			RestArea(aSC2)
			Return .f.
		EndIf
		cProduto := SC2->C2_PRODUTO
	Else
		cProduto := Padr(MV_PAR01,15)
	EndIf

	SB1->(DBSetOrder(1))
	If !  SB1->(DbSeek(xFilial('SB1')+cProduto))
		MsgAlert("Codigo de produto não encontrado!!!")
		RestArea(aSC2)
		RestArea(aSB1)
		Return .f.
	EndIf

	RestArea(aSC2)
	RestArea(aSB1)
Return .t.

Static Function AWzVPR()
	Local	cProduto := Padr(MV_PAR01,15)
	Local oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local nT			:= TamSx3("D3_QUANT")[1]
	Local nD			:= TamSx3("D3_QUANT")[2]

	//>> Chamado 007174

	SB5->(DbSetOrder(1))
	If  SB5->(DbSeek(xFilial('SB5')+cProduto))

		If SB5->B5_EAN13 = "2" .AND. MV_PAR05 $ 'Não'
			//MsgAlert(" Para este produto não é permitir emitir etiqueta EAN13 somente EAN14. ") //" Produto não encontrado "
			//Return .F.
			_lQtdUni := .T.
		EndIf
	EndIf

	//<<

	If Empty(cProduto)
		MsgAlert(" Necessario informar o codigo do produto. ")
		Return .F.
	EndIf

	SB1->(DbSetOrder(1))
	If ! SB1->(DbSeek(xFilial('SB1')+cProduto))
		MsgAlert(" Produto não encontrado ")
		Return .F.
	EndIf

	If ! CBImpEti(SB1->B1_COD)
		MsgAlert(" Este Produto está configurado para nao imprimir etiqueta ")
		Return .F.
	EndIf
	aLbx:={{	.f., SB1->B1_COD,Space(10),Str(CBQEmbI(),nT,nD),Str(0,nT,nD),Str(0,nT,nD),Space(10),Space(20),"SB1",SB1->(Recno())}}
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()
Return .t.

Static Function AWzVOP()
	Local	cOp		:= Padr(MV_PAR01,13)
	Local oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local nQtde
	Local nQE
	Local nQVol
	Local nResto
	Local nT			:= TamSx3("D3_QUANT")[1]
	Local nD			:= TamSx3("D3_QUANT")[2]


	If Empty(cOP)
		MsgAlert(" Necessario informar o codigo do ordem de produção. ")
		Return .F.
	EndIf

	SC2->(DbSetOrder(1))
	If ! SC2->(DbSeek(xFilial('SC2')+cOP))
		MsgAlert(" Ordem de Produção não encontrado ")
		Return .F.
	EndIf
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	If ! CBImpEti(SB1->B1_COD)
		MsgAlert(" Este Produto está configurado para nao imprimir etiqueta ")
		Return .F.
	EndIf

	nQtde := SC2->(C2_QUANT-C2_QUJE)
	nQE   := CBQEmbI()
	nQE	:= If(Empty(nQE),1,nQE)
	nQVol := Int(SD1->D1_QUANT/nQE)
	nResto  :=SD1->D1_QUANT%nQE
	If nResto >0
		nQVol++
	EndIf
	cLote := SC2->C2_XLOTE


	aLbx:=         {{	.f., SB1->B1_COD,Str(nQtde,nT,nD),Str(nQE,nT,nD),Str(nResto,nT,nD),Str(nQVol,nT,nD),cLote,Space(20),"SC2",SC2->(Recno())}}
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()

Return .t.


