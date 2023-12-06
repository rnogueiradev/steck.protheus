#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'APVT100.CH'

/*=========================================================================================	||
||FONTE UTILIZADO PARA REALIZAR COLETA DAS SA - EDUARDO MATIAS - 16/10/18					||
||=========================================================================================	*/

User Function AcdSa01()

	Private cIDConf  := RetCodUsr()
	Private cNconf   := UsrRetName(cIDConf)

	dbSelectArea("CB1")
	CB1->(dbSetOrder(2))
	If CB1->(dbSeek(xFilial("CB1")+cIDConf))

		cIDConf:= CB1->CB1_CODOPE

		While .T.

			AcdSa01A()

			If VTYesNo("Finaliza Separacao?",".:ATENCAO:.",.T.)
				Return(.T.)
			EndIf

		EndDo

	Else
		VTAlert("Usuario nao cadastrado como operador!!!",".:ATENCAO:.",.T.)
	EndIf

Return

/*=========================================================================================	||
||LISTA DAS SA POR OPERADOR																	||
||=========================================================================================	*/

Static Function AcdSa01A()

	Local cTop01	:=	"SQL01"
	Local aCabec	:=	{"NUM","SOLICITANTE","EMISSAO","TIPO SA"}

	Private aItensOp:=	{}
	Private nPos	:=	1

	PutMv("MV_BXPRERQ",.T.)

	cQuery:= " SELECT CP_FILIAL,CP_NUM NUMSA,TRIM(MAX(CP_SOLICIT)) SOLICIT,MAX(CP_EMISSAO) EMISSAO,MAX(CP_XTIPOSA) TPSA " + CRLF
	cQuery+= " FROM "+RetSqlName("SCP")+" SCP " + CRLF
	cQuery+= " INNER JOIN "+RetSqlName("CB1")+" CB1 ON CB1_FILIAL=CP_FILIAL AND TRIM(CB1_CODOPE)=TRIM(CP_XCODOPE) AND CB1_CODOPE='"+cIDConf+"' AND CP_XTIPOSA!=' ' AND CP_SOLICIT!=' ' AND CB1.D_E_L_E_T_!='*' " + CRLF
	//cQuery+= " INNER JOIN "+RetSqlName("CB1")+" CB1 ON CB1_FILIAL=CP_FILIAL AND CB1_CODOPE=TRIM(CP_XCODOPE) AND CB1_CODUSR='"+cIDConf+"' AND CB1.D_E_L_E_T_!='*' " + CRLF
	//cQuery+= " WHERE CP_FILIAL='"+xFilial("SCP")+"' AND CP_PREREQU='S' AND CP_STATUS=' ' AND CP_QUANT > CP_QUJE AND SCP.D_E_L_E_T_!='*' " + CRLF
	cQuery+= " WHERE CP_FILIAL='"+xFilial("SCP")+"' AND CP_PREREQU='S' AND CP_STATUS=' ' AND SCP.D_E_L_E_T_!='*' " + CRLF
	cQuery+= " GROUP BY CP_FILIAL,CP_NUM " + CRLF
	cQuery+= " ORDER BY 1,2 " + CRLF

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

	If (cTop01)->(Eof())

		VTAlert("Nao ha solicitacoes para separacao!!!",".:ATENCAO:.",.T.)

		Return()
	EndIf

	While (cTop01)->(!Eof())

		Aadd(aItensOp,{		;
		(cTop01)->NUMSA,	;
		(cTop01)->SOLICIT,	;
		(cTop01)->EMISSAO,	;
		(cTop01)->TPSA		;
		})

		(cTop01)->(dbSkip())
	EndDo

	aSave := VTSAVE()
	VTClear()
	nPos := VTaBrowse(0,0,7,19,aCabec,aItensOp,{6,20,10,1},,nPos)
	VtRestore(,,,,aSave)
	VTClearBuffer()

	While .T.

		AcdSa01B()

		If VTYesNo("Finaliza Coleta?",".:ATENCAO:.",.T.)
			Exit
		EndIf

		nPos:=1

	EndDo

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

Return()

/*=========================================================================================	||
||ITENS DA SA																				||
||=========================================================================================	*/

Static Function AcdSa01B()

	Local cTop02	:=	"SQL02"
	Local aCabec	:=	{"COD","PRODUTO","SALDO","ITEM","ARMAZEM","TIPO SA"}
	LOcal nPosCod	:=	1
	Local aItens	:=	{}
	Local nCount	:=	1
	Local cSugEnd	:= ""

	Private cCodBar	:=	Space(40)//Space(TamSX3("B1_CODBAR")[1])
	Private cLocaliz:=	Space(TamSX3("BE_LOCAL")[1] + TamSX3("BE_LOCALIZ")[1])
	Private nQuant	:=	0
	Private cNumSA	:=	aItensOp[nPos,1]
	Private cTpBx	:=	""
	Private cLocImp := Space(TamSX3("CB1_XLOCIM")[1])

	cQuery:= " SELECT CP_PRODUTO COD,CP_DESCRI DESCRI,CP_QUANT-CP_QUJE SALDO,CP_ITEM ITEM,CP_LOCAL ARMAZEM, CP_XTIPOSA TPSA " + CRLF
	cQuery+= " FROM "+RetSqlName("SCP")+" SCP " + CRLF
	cQuery+= " WHERE CP_FILIAL='"+ xFilial("SCP") +"' AND CP_NUM='"+ cNumSA +"' AND CP_PREREQU='S' AND CP_STATUS=' ' AND D_E_L_E_T_!='*' " + CRLF

	If !Empty(Select(cTop02))
		DbSelectArea(cTop02)
		(cTop02)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop02, .T., .T. )

	If (cTop02)->(Eof())

		VTAlert("Nao ha itens!!!",".:ATENCAO:.",.T.)

		Return()
	EndIf

	While (cTop02)->(!Eof())

		Aadd(aItens,{		;
		(cTop02)->COD,		;
		(cTop02)->DESCRI,	;
		(cTop02)->SALDO,	;
		(cTop02)->ITEM,		;
		(cTop02)->ARMAZEM,	;
		(cTop02)->TPSA		;
		})

		cTpBx:=	(cTop02)->TPSA//gravo tipo de baixa que vai ser realizada

		(cTop02)->(dbSkip())
	EndDo

	aSave := VTSAVE()
	VTClear()
	nPosCod := VTaBrowse(0,0,7,19,aCabec,aItens,{6,20,10,3,2,1},,nPosCod)
	VtRestore(,,,,aSave)
	VTClearBuffer()

	//BEGIN TRANSACTION

	While .T.

		If Len(aItens)	>=	nPosCod

			cDescri:= AllTrim(aItens[nPosCod,1])+"-"+AllTrim(aItens[nPosCod,2])

			cSugEnd:= SugEnd(aItens[nPosCod,1],aItens[nPosCod,5],aItens[nPosCod,3])//SaldoSBF(cArmazem,cLocaliz,cCodBar,NIL,NIL,NIL)

			VTClear()
			VTClearBuffer()
			DLVTCabec(".:COLETA:.",.F.,.F.,.T.)
			@ 01, 00 VTSay PadR(cDescri,VTMaxCol())
			If Len(cDescri)>VTMaxCol()
				@ 02, 00 VTSay PadR(SubStr(cDescri,VTMaxCol()+1,VTMaxCol()),VTMaxCol())
			EndIf
			@ 03, 00 VTGet cCodBar  Pict '@!' Valid  VldCod()
			@ 04, 00 VTSay "End: "+ aItens[nPosCod,5] + "-" +SubString(cSugEnd,3,15)
			//@ 05, 00 VTGet cLocaliz Pict '@!' Valid  VldEnd(aItens[nPosCod,5])
			@ 05, 00 VTGet cLocaliz Pict '@!' Valid  VldEnd(aItens[nPosCod,5])
			@ 06, 00 VTSay "Qtd p/ Coletar:"+cValToChar(aItens[nPosCod,3])
			@ 07, 00 VTGet nQuant Pict CBPictQtde() Valid VldQtd(aItens[nPosCod,5],aItens[nPosCod,4])

			VTREAD

			If (VTLastKey()==27)
				If VTYesNo("Finaliza Item?",".:ATENCAO:.",.T.)
					Exit
				EndIf
			EndIf

			nQuant	:=	0
			cCodBar	:=	Space(40)//Space(TamSX3("B1_CODBAR")[1])
			cLocaliz:=	Space(TamSX3("BE_LOCALIZ")[1])

			VtClearBuffer()

			VtGetRefresh("nQuant"	)
			VtGetRefresh("cCodBar"	)
			VtGetRefresh("cLocaliz"	)

			nPosCod++

		EndIf

		If Len(aItens)	<	nPosCod
			If VTYesNo("Deseja Gravar?",".:COLETA FINALIZADA:.",.T.)
				PrcBaixa()//Funcao para realizar a baixa/transferencia.
				//Exit
				Return()
			ElseIf VTYesNo("Deseja refazer coleta?",".:COLETA FINALIZADA:.",.T.)
				nPosCod:=1
			Else
				Exit
			EndIf
		EndIf

	EndDo

	//END TRANSACTION

Return()

/*=========================================================================================	||
||VALIDACAO CODIGO INFORMADO																																											||
||=========================================================================================	*/

Static Function VldCod()

	Local lRet    := .F.
	Local lOk     := .F.

	cCodBar	:=	U_STAVALET(AllTrim(cCodBar)) //Rotina para avaliar etiqueta e ajustar para padrão de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014

	VTAlert(cCodBar,".:cCodBar:.",.T.,4000)

	aRet := CBRetEtiEan(cCodBar)

	If	Empty(aRet[1])
		//MsgAlert("Etiqueta invalida","Aviso")
		VTAlert("Etiqueta invalida!",".:Aviso:.",.T.,4000)
		Return .F.
	EndIf

	cCodBar := aRet[1]

	dbSelectArea("SB1")
	SB1->(dbSetorder(1))

	If	SB1->(dbSeek(xFilial('SB1')+cCodBar))
		cCodBar  := SB1->B1_COD
		lRet:=	.T.
	Else
		SB1->(DbSetOrder(5))
		If	SB1->(dbSeek(xFilial('SB1')+cCodBar))
			cCodBar  := SB1->B1_COD
			lRet:=	.T.
		Endif
	Endif

	If !lRet
		dbSelectArea("SLK")
		SLK->(dbSetOrder(1))
		If	SLK->(dbSeek(xFilial('SLK')+cCodBar))
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1')+SLK->LK_CODIGO))
			cCodBar  := SB1->B1_COD
			lRet:=	.T.
		EndIf
	EndIf

	If !lRet
		VTAlert("Produto nao localizado!",".:Aviso:.",.T.,4000)
		cCodBar	:=	Space(40)//Space(TamSX3("B1_CODBAR")[1])
	Else

		nQuant:= aRet[2]
		VtClearBuffer()
		VtGetRefresh("nQuant")

	EndIf

	VtClearBuffer()

	VtGetRefresh("cCodBar")

Return (lRet)

/*=========================================================================================	||
||VALIDACAO ENDERECO INFORMADO																||
||=========================================================================================	*/

Static Function VldEnd(cArmazem)

	Local lRet:= .T.
	Local aCabec	:=	{"LOCAL","ENDERECO","SALDO"}
	Local nPosEnd:=0

	//If AllTrim(Upper(cLocaliz)) != "P"

	dbSelectArea("SBE")
	SBE->(dbSetOrder(1))
	//BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS
	//If !SBE->(dbSeek(xFilial("SBE")+cArmazem+cLocaliz))
	If !SBE->(dbSeek(xFilial("SBE")+cLocaliz))
		VTAlert("Endereco nao cadastrado!",".:Aviso:.",.T.,4000)
		lRet:=	.F.

		cLocaliz:=	Space(TamSX3("BE_LOCAL")[1] + TamSX3("BE_LOCALIZ")[1])

		VtClearBuffer()

		VtGetRefresh("cLocaliz")
	EndIf

	/*Else

	dbSelectArea("SBF")
	SBF->(dbSetOrder(2))

	If SBF->(dbSeek(xFilial("SBF")+cCodBar+cArmazem))

	While SBF->(!Eof()) .And. SBF->BF_PRODUTO = cCodBar .And. SBF->BF_LOCAL = cArmazem

	nSldEnd:= SaldoSBF(cArmazem,SubStr(cLocaliz,3,SBF->BE_LOCALIZ),cCodBar,NIL,NIL,NIL)

	If nSldEnd > 0

	Aadd(aItens,{		;
	SBF->BF_LOCAL,		;
	SBF->BF_LOCALIZ,	;
	nSldEnd	;
	})

	EndIf

	SBF->(dbSkip())
	EndDo

	If Len(aItens) > 0

	aSave := VTSAVE()
	VTClear()
	nPosEnd := VTaBrowse(0,0,7,19,aCabec,aItens,{5,10,5},,nPosEnd)
	VtRestore(,,,,aSave)
	VTClearBuffer()

	cLocaliz:= AllTrim(aItens[nPosEnd,1])+"-"+AllTrim(aItens[nPosEnd,2])

	VtClearBuffer()

	VtGetRefresh("cLocaliz")

	Else

	VTAlert("Saldo insuficiente!!",".:Aviso:.",.T.,4000)
	lRet:=	.F.

	cLocaliz:=	Space(TamSX3("BE_LOCAL")[1] + TamSX3("BE_LOCALIZ")[1])

	VtClearBuffer()

	VtGetRefresh("cLocaliz")

	EndIf

	EndIf*/

	//EndIf

Return(lRet)

/*=========================================================================================	||
||VALIDACAO DE SALDO POR ENDERECO E GRAVACAO DAS INFORMACOES								||
||=========================================================================================	*/

Static Function VldQtd(cArmazem,cItem)

	Local lRet		:= .T.
	Local nSldEnd	:=	SaldoSBF(cArmazem,SubStr(cLocaliz,3, TamSX3("BE_LOCALIZ")[1]),cCodBar,NIL,NIL,NIL)

	If nQuant > nSldEnd .Or. nQuant <= 0

		If nQuant > 0
			VTAlert("Saldo insulficiente",".:SALDO ENDERECO:.",.T.,4000)
		Else
			VTAlert("Valor invalido",".:ERRO:.",.T.,4000)
		EndIf

		nQuant	:=	0

		VtClearBuffer()

		VtGetRefresh("nQuant")

		Return( .F. )

	EndIf

	dbSelectArea("SCP")
	SCP->(dbSetOrder(1))
	//CP_FILIAL+CP_NUM+CP_ITEM+DTOS(CP_EMISSAO)
	If SCP->(dbSeek(xFilial("SCP")+cNumSA+cItem))
		RecLock("SCP",.F.)
		SCP->CP_QUANT	:=	nQuant
		SCP->CP_XHRINIS	:=	Time()
		//SCP->CP_XQTDORI	:=	nQuant
		SCP->CP_XENDER	:=	SubStr(cLocaliz,3, TamSX3("BE_LOCALIZ")[1])
		SCP->(MsUnLock())

		dbSelectArea("SCQ")
		SCQ->(dbSetOrder(1))
		//CQ_FILIAL+CQ_NUM+CQ_ITEM+CQ_NUMSQ
		If SCQ->(dbSeek(xFilial("SCQ")+cNumSA+cItem))
			RecLock("SCQ",.F.)
			SCQ->CQ_QUANT	:=	nQuant
			SCQ->CQ_QTDISP	:=	nQuant
			SCQ->(MsUnLock())
		EndIf

		VTAlert("Gravando quantidade...",".:STATUS:.",.T.,1000)

	Else

		VTAlert("Valor nao foi gravado",".:STATUS:.",.T.,1500)

	EndIf

Return(lRet)

/*=========================================================================================	||
||FUNÇÃO PARA REALIZAR BAIXA SA / TRANSFERECIA												||
||=========================================================================================	*/

Static Function PrcBaixa()

	/*
	Private cNumSA	:=	aItensOp[nPos,1]
	Private cTpBx	:=	""
	*/

	Local aCamposSCP:=	{}
	Local aCamposSD3:=	{}
	Local nOpcAuto	:=	1 // BAIXA
	LOcal cCodMov	:=	SuperGetMv("CODMOVBX",.F.,"800")
	Local cNumDoc 	:=	NextNumero("SD3",2,"D3_DOC",.T.)
	Local cTop03	:=	"SQL03"

	Private _aAutSD3	:=	{}
	Private lMsErroAuto	:= .F.
	Private lMSHelpAuto := .F.

	Private cCusMed:= GetMv("MV_CUSMED")
	Private aRegSD3:= {}

	Private cLocImp:=	Space(6)

	VtClear()
	@ 1,0 VtSay "Local de Impresao"
	@ 2,0 VtGet cLocImp pict "999999" F3 'CB5' Valid ! Empty(cLocImp)
	VTRead

	dbSelectArea("SD3")

	cQuery := " SELECT CP_NUM NUMSA,CP_ITEM ITEM,CP_QUANT QUANT,CP_PRODUTO PRODUTO,CP_DESCRI DESCRI,CP_LOCAL ARMAZEM,CP_XENDER ENDERECO,CP_XQTDORI QTDORI, CP_XLOCDES LOCDES, CP_CC CC " + CRLF
	cQuery += " FROM "+RetSqlName("SCP")+" SCP " + CRLF
	cQuery += " WHERE CP_FILIAL='"+xFilial("SCP")+"' AND CP_NUM='"+ cNumSA +"' AND CP_PREREQU='S' AND CP_STATUS=' ' AND CP_QUANT>0 AND D_E_L_E_T_!='*' " + CRLF

	If !Empty(Select(cTop03))
		DbSelectArea(cTop03)
		(cTop03)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop03, .T., .T. )

	If (cTop03)->(Eof())

		VTAlert("Nao ha itens!!!",".:ATENCAO:.",.T.)

		Return()
	EndIf

	If cTpBx="B"

		While (cTop03)->(!Eof())

			aCamposSCP :=	{;
			{"CP_NUM"	,(cTop03)->NUMSA	,Nil	},;
			{"CP_ITEM"	,(cTop03)->ITEM		,Nil	},;
			{"CP_QUANT"	,(cTop03)->QUANT	,Nil	},;
			{"CP_XHRFIMS"	,TIME()	,Nil	},;
			{"CP_OBS"	,(cTop03)->NUMSA	,Nil	}}

			aCamposSD3 := {;
			{"D3_TM"		,cCodMov			,Nil },;  // Tipo do Mov.
			{"D3_COD"		,(cTop03)->PRODUTO	,Nil },;
			{"D3_LOCAL"		,(cTop03)->ARMAZEM	,Nil },;
			{"D3_DOC"		,cNumDoc			,Nil },;  // No.do Docto.
			{"D3_XOBS"		,(cTop03)->NUMSA	,Nil },;  //
			{"D3_LOCALIZ"	,(cTop03)->ENDERECO	,Nil },;
			{"D3_CC"		,(cTop03)->CC		,Nil },;
			{"D3_EMISSAO"	,dDataBase			,Nil } }

			cNumDoc:=Soma1(cNumDoc)

			lMSHelpAuto := .F.
			lMsErroAuto := .F.

			MSExecAuto({|v,x,y,z| mata185(v,x,y)},aCamposSCP,aCamposSD3,nOpcAuto)  // 1 = BAIXA (ROT.AUT)

			If lMsErroAuto
				VTAlert("ERRO DE EXECUCAO",".:MATA185:." + CRLF  + MostraErro())

			Else

				//VtClear()
				//@ 1,0 VtSay "Local de Impresao"
				//@ 2,0 VtGet cLocImp pict "999999" F3 'CB5' Valid ! Empty(cLocImp)
				//VTRead

				If VTYesNo("Gera Etiqueta?","**ETIQUETA**",.T.)
					ACDSA01E((cTop03)->PRODUTO,(cTop03)->DESCRI,(cTop03)->QUANT)
				EndIf

			EndIf

			(cTop03)->(dbSkip())

		EndDo

		VTAlert("PROCESSADA",".::"+cNumSA+"::.")

	Else

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))

		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))

		dbSelectArea("SCP")
		SCP->(dbSetOrder(1))	//CP_FILIAL+CP_NUM+CP_ITEM+DTOS(CP_EMISSAO)

		cNumSd3	:=	GetSxeNum("SD3","D3_DOC")

		While (cTop03)->(!Eof())

			SB1->(dbSeek(xFilial("SB1")+(cTop03)->PRODUTO))

			cEndDest := "" //Ticket 20190528000013 - Everson Santana

			Do Case
				Case (cTop03)->LOCDES = "01"
				cEndDest:=	"1BENEFICIAMENTO"
				Case (cTop03)->LOCDES = "95"
				cEndDest:=	"4SEGREGADO"
				Case (cTop03)->LOCDES = "97"
				cEndDest:=	"REJEITADO"
				Case (cTop03)->LOCDES = "50"  //Ticket 20190418000012 - Everson Santana - 16.05.19
				cEndDest:=	"DIFPROD"
				Otherwise
				cEndDest:=	"PRODUCAO"
			End Case

			If a260Processa(;
				(cTop03)->PRODUTO,;
				(cTop03)->ARMAZEM,;
				(cTop03)->QUANT	,;
				cNumSd3,;
				dDataBase,;
				0,;
				Nil,Nil,Nil,Nil,;
				(cTop03)->ENDERECO,;
				(cTop03)->PRODUTO,;
				(cTop03)->LOCDES,;
				cEndDest,;
				.F.,;
				Nil,Nil,"ACDSA01",;
				Nil,Nil,Nil,Nil,Nil,Nil,;
				Nil,Nil,Nil,Nil,Nil,Nil,;
				Nil,Nil,Nil,Nil,Nil)

				If SCP->(dbSeek(xFilial("SCP")+(cTop03)->NUMSA+(cTop03)->ITEM))
					RecLock("SCP",.F.)
					SCP->CP_QUJE	:=	SCP->CP_QUANT
					SCP->CP_OBS		:=	SCP->CP_OBS+"-"+cNumSd3 //Ticket 20190528000013 - Everson Santana
					SCP->CP_STATUS	:=	"E"
					SCP->CP_XHRFIMS	:= Time()
					SCP->(MsUnLock())

					If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_ITEM)) .And. SB2->B2_QEMPSA >= SCP->CP_QUANT

						RecLock("SB2",.F.)
						SB2->B2_QEMPSA	:=	SB2->B2_QEMPSA - SCP->CP_QUANT
						SB2->(MsUnLock())

					EndIf

					dbSelectArea("SCQ")
					SCQ->(dbSetOrder(1))
					//CQ_FILIAL+CQ_NUM+CQ_ITEM+CQ_NUMSQ
					If SCQ->(dbSeek(xFilial("SCQ")+SCP->CP_NUM+SCP->CP_ITEM))
						RecLock("SCQ",.F.)
						SCQ->CQ_QTDISP	:=	0
						SCQ->(MsUnLock())
					EndIf

				EndIf

				ACDSA01E((cTop03)->PRODUTO,(cTop03)->DESCRI,(cTop03)->QUANT)

			EndIf
			// Valdemir Rabelo 24/02/2020
			If SCP->(dbSeek(xFilial("SCP")+(cTop03)->NUMSA+(cTop03)->ITEM)) .and. (SCP->CP_STATUS	==	"E")
				RecLock("SCP",.F.)
				SCP->CP_XHRFIMS	:= Time()
				MsUnlock()
			Endif

			(cTop03)->(dbSkip())

		EndDo

		ConfirmSX8()

		dbSelectArea("SD3")
		SD3->(dbSetOrder(2))
		If SD3->(dbSeek(xFilial("SD3")+cNumSd3))
			While SD3->(!Eof()) .and. SD3->D3_DOC == cNumSd3
				RecLock("SD3",.F.)
				SD3->D3_XOBS			:= cNumSA
				//SD3->D3_OBSERVA   := cNumSA
				SD3->D3_OBS			:= cNumSA +" / " + SD3->D3_OBS
				SD3->D3_NUMSA		:= cNumSA
				SD3->(MsUnlock())

				SD3->(dbSkip())
			EndDo
		EndIf

		VtAlert("Produto transferido")

	EndIf

Return( .T. )

Static Function SugEnd(cCodProd,cLacProd,nSldSA)

	Local cSugEnd	:= "SEM SUGESTAO"
	Local nSldBf	:= 0

	dbSelectArea("SBF")
	SBF->(dbSetOrder(2))

	If SBF->(dbSeek(xFilial("SBF")+cCodProd+cLacProd))

		While SBF->(!Eof()) .And. cCodProd+cLacProd = SBF->BF_PRODUTO+SBF->BF_LOCAL

			nSldBf	:=	SaldoSBF(SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_PRODUTO,NIL,NIL,NIL)

			If nSldBf >= nSldSA

				cSugEnd	:= cLacProd +	SBF->BF_LOCALIZ

				Exit

			EndIf

			SBF->(dbSkip())
		EndDo

	EndIf


	//cSugEnd:= SugEnd(aItens[nPosCod,1],aItens[nPosCod,5])//SaldoSBF(cArmazem,cLocaliz,cCodBar,NIL,NIL,NIL)

Return(cSugEnd)

Static Function ACDSA01E(cProd,cDescri,nQtdSa)

	Local cQtd		:= Alltrim(str(nQtdSa))
	Local cParte1	:= SubStr(Alltrim(cDescri),1,20)
	Local cParte2	:= SubStr(Alltrim(cDescri),21,20)
	Local nLinH	:= 0
	Local nLinV := 0
	Local _cDepto := ''
	Local _cCombo := ''
	Local _adados := {}
	Local _nI
	Local _npos

	Local dEmissao := dDatabase

	//VTAlert("Local:"+cLocImp)

	If CB5SETIMP(cLocImp)

		//Chamado 003005 fecha
		MSCBInfoEti("ACDSA01","")
		MSCBBEGIN(1,6,60)
		//MSCBBox(nLinH+03,nLinV+03,nLinH+100,nLinV+79,5)	//Somente para o enquadramento - Tirar ao concluir.

		//MSCBSAYBAR(nLinH+13,nLinV+10,cCodBar,"N","MB07",13,.F.,.T.,.T.,"B",2,2,.F.) //	MSCBSAYBAR(nLinH+15,nLinV+10,cCodBar,"N","MB07",13,.F.,.T.,.T.,"B",2,2,.F.)
		//MSCBSAYBAR(nLinH+13,nLinV+10,cProd,"N","MB07",12,.F.,.t.,.F.,"C",1,1,.F.)
		MSCBSAYBAR(nLinH+13,nLinV+10,cProd,"N","MB07",13,.F.,.t.,.F.,"C",3,2,.F.)
		MSCBSAY(nLinH+15,nLinV+35,Dtoc(dEmissao)		,"B","0","035,040")
		MSCBSAY(nLinH+22,nLinV+35,cProd	,"B","0","035,040")
		MSCBSAY(nLinH+36,nLinV+25,cParte1 		,"B","0","035,040")
		MSCBSAY(nLinH+40,nLinV+25,cParte2		,"B","0","035,040")
		MSCBSAY(nLinH+49,nLinV+35,cQtd			,"B","0","035,040")
		//MSCBSAY(nLinH+57,nLinV+35,"cLote"			,"B","0","035,040")

		/*If ! Empty(cOP)
		MSCBSAY(nLinH+81,nLinV+28,"OP: "+cOP				,"B","0","035,040")
		If !Empty(_cDepto)
		MSCBSAY(nLinH+88,nLinV+28,_cDepto				,"B","0","035,040")
		Endif
		EndIf*/


		MSCBEND()
		MSCBCLOSEPRINTER()

	EndIf

Return()

User Function StCons1(oFolder,oDlg,cArmExp)

	Local aBrowse	:= {"CP_NUM","CP_XTIPOSA","CP_ITEM","CP_EMISSAO","CP_XHRINC","CP_PRODUTO","CP_DESCRI","CP_UM","CP_QUANT","CP_XQTDORI","CP_SOLICIT","CP_DATPRF","CP_XCODOPE","CP_XNOMOPE","CP_LOCAL","CP_XLOCDES","CP_OBS","CP_CC","CP_XHRINIS","CP_XHRFIMS"}
	Local aCab2		:= {"1"			,"2"		 ,"Armazem"	 ,"Produto"	  ,"Descricao"	,"Endereço","Lote","Quantidade","Saldo Separação (1)","Saldo Embalagem (2)",""}
	Local aItens2  := {}
	Local oLbx
	Local aAutSep 	:=RetSx3Box(Posicione('SX3', 2, "CB7_XAUTSE", 'X3CBox()' ),,, 1 )// RetSx3Box(Posicione("SX3",2,"CB7_XAUTSE","X3_CBOX"),,,14)
	Local oCol
	Local oBrowse
	Local i
	Local lAdm		:= Empty(cArmExp)
	//Local cArm		:= cArmExp :=

	Local cCpoFil 	:= NIL
	Local cTopFun 	:= NIL
	Local cBotFun 	:= NIL

	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4
	Local oPanel5

	Local oStatus

	Local oPedido
	Local cPedido := Space(6)

	Local oOP
	Local cOP := Space(13)

	Local oTotItem
	Local nTotItem:=0

	Local oTotEnd
	Local nTotEnd:=0

	Local oSplit

	Local nX
	Local aBtnLat
	Local nAux
	Local bBlocoC

	Local _cUseLib := GetMv("ST_FSFA40",,"000000")
	Local cFS_GRPEXP	:= SuperGetMV("FS_GRPEXP",,"")
	Local _aGrupos, _nPos

	Local oDtIni
	Local dDtIni	:= dDataBase-15
	Local oDtFim
	Local dDtFim	:= dDataBase

	Local   oOk		:=  LoadBitmap( GetResources(), "LBOK" )
	Local   oNo     :=  LoadBitmap( GetResources(), "LBNO" )

	Local oBrowseCon

	Local aTpReq	:=	{"0-Todas","1-Aberto","2-Operação","3-Separada","4-Encerrada","5-Parcial"}

	Local oReqDe
	Local oReqAte
	Local oSolDe
	Local oSolAte

	Local cStCon:= aTpReq[2]

	Local cReqDe	:= Space(6)
	Local cReqAte	:= Replicate("Z",6)
	Local cSolDe	:= Space(TamSX3("CP_SOLICIT")[1])
	Local cSolAte	:= Replicate("Z",TamSX3("CP_SOLICIT")[1])

	aBtnLat :={;
	{"BMPUSER"			,{|| ConAtrib(1,oBrowseCon,SCP->CP_NUM)}		,"Atribuir p/ operador"	},;
	{"BMPGROUP"	  		,{|| ConAtrib(2,oBrowseCon)}					,"Atribuição em Lote"	},;
	{"ESTOMOVI"    		,{|| ConFinal(SCP->CP_NUM,oBrowseCon)}						,"Encerra Documento"	},;
	{"PMSEXCEL"    		,{|| U_AcdSa01R()}						,"Relatório"	},;
	{"WATCH"    		,{|| VtAcdMonit()}						,"Monitor"	},;
	{"COLOR"    		,{|| StLegSCP(oFolder)}						,"Legenda"	}}

	FilCon(oStatus,oBrowseCon,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,1,cStCon,cReqDe,cReqAte,cSolDe,cSolAte,dDtIni,dDtFim)

	@00,00 MSPANEL oPanel1 PROMPT "" SIZE 20,20 of oDlg
	oPanel1:Align := CONTROL_ALIGN_LEFT
	If lConCom
		aBtnLat := {}
	Endif
	nAux:= 0

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	If  _aGrupos[1][10][1] $ cFS_GRPEXP .Or. __cUserId == "000000"

		For nX := 1 To Len(aBtnLat)
			TBtnBmp2():New(nAux,0,40,40 ,aBtnLat[nX,1], NIL, NIL,NIL,aBtnLat[nX,2], oPanel1, aBtnLat[nX,3], NIL, NIL,NIL )
			nAux +=42
		Next

	EndIf
	@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
	oPanel4:Align := CONTROL_ALIGN_TOP

	@ 06,22 Say "Requisição de:" PIXEL of oPanel4
	@ 04,62 MsGet oReqDe Var cReqDe Picture "!!!!!!" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)
	@ 06,110 Say "até:" PIXEL of oPanel4
	@ 04,120 MsGet oReqAte Var cReqAte Picture "!!!!!!" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)

	@ 06,170 Say "Emissão de:" PIXEL of oPanel4
	@ 04,200 MsGet oDtIni Var dDtIni Picture "@D" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)
	@ 06,240 Say "até:" PIXEL of oPanel4
	@ 04,250 MsGet oDtFim Var dDtFim Picture "@D" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)

	@ 06,295 Say "Solicitante de:" PIXEL of oPanel4
	//@ 04,330 MsGet oSolDe Var cSolDe Picture "@!" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)
	@ 04,330 MsGet oSolDe Var cSolDe PIXEL of oPanel4 SIZE 50,09 //F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)
	@ 06,440 Say "até:" PIXEL of oPanel4
	@ 04,450 MsGet oSolAte Var cSolAte  PIXEL of oPanel4 SIZE 50,09 //F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)
	//@ 04,380 MsGet oSolAte Var cSolAte Picture "@!" PIXEL of oPanel4 //SIZE 50,09 F3 "CB7FS1" Valid PesqOSep(@cOrdSep,oBrowseSep)

	@ 06,540 Say "Filtrar Status SA" PIXEL of oPanel4
	@ 04,585 ComboBox oStatus VAR cStCon ITEMS aTpReq Of oPanel4 PIXEL SIZE 85,10

	@ 04,680  BUTTON "Filtrar"	SIZE 55,11 ACTION (FilCon(oStatus,oBrowseCon,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,2,cStCon,cReqDe,cReqAte,cSolDe,cSolAte,dDtIni,dDtFim)) OF oPanel4 PIXEL

	@00,00 MSPANEL oPanel2 PROMPT "" SIZE 20,20 of oDlg
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

	DbSelectArea("SCP")
	//SCP->(dbOrderNickName("STFSCB702"))
	SCP->(dbSetOrder(1))
	//SCP->(dbSeek(xFilial('SCP')+cArmExp))

	oBrowseCon := VCBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,/*bLDblClick*/,,,,,,,, .F.,"SCP", .T.,, .F., ,)
	oBrowseCon := oBrowseCon:GetBrowse()
	oBrowseCon:Align := CONTROL_ALIGN_ALLCLIENT

	oCol := TCColumn():New( " ",{|| LegCon(1) },,,, "LEFT", 8, .T., .F.,,,, .T., )
	oBrowseCon:AddColumn(oCol)

	For i:=1 To Len(aBrowse)

		oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])),&("{ || SCP->"+aBrowse[i]+"}"),,,,"LEFT",,.F.,.F.,,,,.F.	, )
		oBrowseCon:AddColumn(oCol)

	Next i

	oBrowseCon:Refresh()

Return oBrowseCon

Static Function LegCon(nColuna)

	Local oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA"	)
	Local oCinza	:= LoadBitmap( GetResources(), "BR_CINZA"	)
	Local oAzul		:= LoadBitmap( GetResources(), "BR_AZUL"	)
	Local oVerde	:= LoadBitmap( GetResources(), "BR_VERDE"	)
	Local oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")
	Local oSep		:= LoadBitmap( GetResources(), "CONIMG16" )
	Local oEbl		:= LoadBitmap( GetResources(), "WMSIMG16" )
	Local oEbq		:= LoadBitmap( GetResources(), "TMSIMG16" )
	//Local oEst		:= LoadBitmap( GetResources(), "ESTIMG16" )
	Local oEst		:= LoadBitmap( GetResources(), "PMSEXPALL" )
	Local oCor		:= ''

	Do Case

		Case Empty(SCP->CP_STATUS) .And. Empty(SCP->CP_PREREQU)
		/*AMARELO PRE REQUISIÇÃO*/
		oCor:= oAmarelo

		Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. QtdComp(SCP->CP_QUJE) == QtdComp(0)
		/*VERDE BAIXAR(OPERAÇÃO)*/
		oCor:= oVerde

		Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. (QtdComp(SCP->CP_QUANT) == QtdComp(SCP->CP_QUJE))
		/*VERMELHO BAIXADA (SEPARADA)*/
		oCor:= oVermelho

		Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. (QtdComp(SCP->CP_QUANT) > QtdComp(SCP->CP_QUJE))
		/*AZUL ENCERRADA*/
		oCor:= oAzul

		Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. QtdComp(SCP->CP_QUJE) > QtdComp(0)
		/*LARANJA PARCIAL*/
		oCor:= oOrange

	EndCase

	/*Do Case

	Case Empty(SCP->CP_STATUS) .And. Empty(SCP->CP_PREREQU) .And. Empty(SCP->CP_XCODOPE)
	oCor:= oVerde//Aberto

	Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. SCP->CP_QUJE=0 .And. !Empty(SCP->CP_XCODOPE)
	oCor:= oAmarelo//Operação

	Case Empty(SCP->CP_STATUS) 	.And. SCP->CP_PREREQU == "S" .And. QtdComp(SCP->CP_QUJE) > QtdComp(0)
	oCor:=	oOrange//PARCIAL

	Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. QtdComp(SCP->CP_QUJE) == QtdComp(0)
	oCor:= oVerde //BAIXAR

	Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. (QtdComp(SCP->CP_QUANT) == QtdComp(SCP->CP_QUJE))
	oCor:= oVermelho//BAIXADA

	Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. (QtdComp(SCP->CP_QUANT) > QtdComp(SCP->CP_QUJE))
	oCor:=	oAzul//ENCERRADA

	EndCase*/

Return oCor

Static Function FilCon(oStatus,oBrowseCon,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,nTipo,cStCon,cReqDe,cReqAte,cSolDe,cSolAte,dDtIni,dDtFim)

	Local _cFitro	:= ""

	dbSelectarea("SCP")
	SCP->(DbClearFilter())

	//SET FILTER TO (C5_XSTARES = AllTrim(Str(oStatus:nAt)) .And. C5_EMISSAO >= dEmisIni .And. C5_EMISSAO <= dEmisFim)

	If nTipo = 1

		_cFitro += "SCP->CP_FILIAL='"+cFilAnt+"'"
		SET FILTER TO (SCP->CP_FILIAL = cFilAnt)

	Else
		Do Case

			Case SubStr(cStCon,1,1)='0' //TODAS
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"'"

			SET FILTER TO (;
			SCP->CP_FILIAL	= cFilAnt	.And.;
			SCP->CP_EMISSAO	>= dDtIni	.And.;
			SCP->CP_EMISSAO	<= dDtFim	.And.;
			SCP->CP_NUM		>= cReqDe	.And.;
			SCP->CP_NUM		<= cReqAte	.And.;
			SCP->CP_SOLICIT	>= cSolDe	.And.;
			SCP->CP_SOLICIT	<= cSolAte)

			Case SubStr(cStCon,1,1)='1'
			/*AMARELO PRE REQUISIÇÃO*/
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"' .And. Empty(SCP->CP_STATUS) .And. Empty(SCP->CP_PREREQU) "

			Case SubStr(cStCon,1,1)='2'
			/*VERDE BAIXAR(OPERAÇÃO)*/
			_cFitro :=  "SCP->CP_FILIAL='"+cFilAnt+"' .And. Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. SCP->CP_QUJE == 0 "

			Case SubStr(cStCon,1,1)='3'
			/*VERMELHO BAIXADA (SEPARADA)*/
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"' .And. !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. SCP->CP_QUANT == SCP->CP_QUJE "

			Case SubStr(cStCon,1,1)='4'
			/*AZUL ENCERRADA*/
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"' .And. !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. SCP->CP_QUANT > SCP->CP_QUJE "

			Case SubStr(cStCon,1,1)='5'
			/*LARANJA PARCIAL*/
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"' .And. Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. SCP->CP_QUJE > 0 "

		EndCase

		/*Do Case

		Case Empty(SCP->CP_STATUS) .And. Empty(SCP->CP_PREREQU)
		//AMARELO PRE REQUISIÇÃO
		oCor:= oAmarelo

		Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. QtdComp(SCP->CP_QUJE) == QtdComp(0)
		//VERDE BAIXAR(OPERAÇÃO)
		oCor:= oVerde

		Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. (QtdComp(SCP->CP_QUANT) == QtdComp(SCP->CP_QUJE))
		//VERMELHO BAIXADA (SEPARADA)
		oCor:= oVermelho

		Case !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. (QtdComp(SCP->CP_QUANT) > QtdComp(SCP->CP_QUJE))
		//AZUL ENCERRADA
		oCor:= oAzul

		Case Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. QtdComp(SCP->CP_QUJE) > QtdComp(0)
		//LARANJA PARCIAL
		oCor:= oOrange

		EndCase*/

	EndIf

	If nTipo == 2

		If !Empty(_cFitro)

			If !Empty(cReqDe)
				_cFitro+= " .And. SCP->CP_NUM = '" + AllTrim(cReqDe) + "' "
			EndIf
			If !Empty(cSolDe)
				_cFitro+= " .And. SCP->CP_SOLICIT = '" + AllTrim(cSolDe) + "' "
			EndIf

			_cFitro+= " .And. SCP->CP_EMISSAO >= Stod('" + Dtos(dDtIni) + "') .And. SCP->CP_EMISSAO <= Stod('" + Dtos(dDtFim) + "') "

		Else

			_cFitro+= " SCP->CP_FILIAL='" + cFilAnt + "' "

			If !Empty(cReqDe)
				_cFitro+= " .And. SCP->CP_NUM = '" + AllTrim(cReqDe) + "' "
			EndIf
			If !Empty(cSolDe)
				_cFitro+= " .And. SCP->CP_SOLICIT = '" + AllTrim(cSolDe) + "' "
			EndIf

			_cFitro+= " .And. SCP->CP_EMISSAO >= Stod('" + Dtos(dDtIni) + "') .And. SCP->CP_EMISSAO <= Stod('" + Dtos(dDtFim) + "') "

		EndIf

	EndIf

	SET FILTER TO &(_cFitro)

	SCP->(dbGotop())

	If nTipo == 2
		oBrowseCon:nAt:=1
		//Eval(oBrowseCon:bGoTop)
		oBrowseCon:REFRESH()
		//MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)
	EndIf

Return

Static Function ConAtrib(nOpc,oBrowseCon,cNumSA)

	Local	cPerg1	:= "CONXOPEA"
	Local	cPerg2	:= "CONXOPEB"
	Local 	cSeq	:= "01"
	Local	cMsgPrc	:= ""
	Local	aArea 	:= GetArea()
	Local	lVld90	:= .T.
	Local	cMsg90	:=	""

	Default cNumSA	:=	""

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	dbSelectArea("SCP")
	SCP->(dbSetOrder(1))

	dbSelectArea("SB2")
	SB2->(dbSetOrder(1))

	dbSelectArea("CB1")
	CB1->(dbSetOrder(1))

	Do Case

		Case nOpc	= 1
		/*=========================================================================================	||
		||ATRIBUIÇÃO UNITARIA DE OPERADOR X SA														||
		||=========================================================================================	*/
		If SCP->(dbSeek(xFilial("SCP")+cNumSA))

			If SCP->CP_STATUS='E'
				msgStop("Requisição "+cNumSA+" cancelada/atendida.","Atenção")
				Return()
			EndIf

			U_STPutSx1(cPerg1	, "01"	,"Operador:	","MV_PAR01"	,"mv_ch1","C",TamSX3("CB1_CODOPE")[1]	,0,"G","","CB1"	,"@!"							)
			U_StPutSx1(	cPerg1	, "02"	,"Tipo:			","mv_par02"	,"mv_ch2","C",01												,0,"C","",""		,""		,"B=Baixa","T=Transf"	)
			U_StPutSx1(	cPerg1	, "03"	,"Loc.Dest:	","mv_par03"	,"mv_ch3","C",02												,0,"G","","NNR",""								)

			If Pergunte(cPerg1,.T.) .And. !Empty(MV_PAR01)

				If MV_PAR02=2 .And. Empty(MV_PAR03)
					msgInfo("Para tipo TRANSFERÊNCIA local destino deve ser informado!","ATENÇÃO")
					Return()
				EndIf

				If CB1->(dbSeek(xFilial("CB1")+MV_PAR01))

					If !MsgNoYes("Deseja atribuir SA para operador: "+AllTrim(CB1->CB1_NOME)+" ?","***ATENÇÃO***")
						Return()
					EndIf

					nRecnoSa:=	SCP->(Recno())

					While SCP->(!Eof()) .And. SCP->CP_NUM==cNumSA
						If SB1->(dbSeek(xFilial("SB1")+SCP->CP_PRODUTO)) .And. Alltrim(SB1->B1_TIPO) $ "IC#MC" .And. MV_PAR03="90" //Ticket 20200520002344
							cMsg90+= "Produto, "+SCP->CP_PRODUTO+" não pode ser movimentado para armazém 90, pois seu tipo é " + SB1->B1_TIPO + CRLF
							lVld90	:=	.F.
						EndIf
						SCP->(dbSkip())
					EndDo

					If !lVld90
						msgStop(cMsg90)
						RestArea(aArea)
						Return()
					EndIf

					SCP->(dbGoto(nRecnoSa))

					While SCP->(!Eof()) .And. SCP->CP_NUM==cNumSA

						If Empty(SCP->CP_PREREQU) .And. Empty(SCP->CP_STATUS)

							If SB2->(dbSeek(xFilial("SB2") + SCP->CP_PRODUTO + SCP->CP_LOCAL))
								nEstoque:=	SB2->B2_QATU //SaldoSb2()
							Else
								nEstoque:=	0
							EndIf

							If nEstoque >= SCP->CP_QUANT

								RecLock("SCP",.F.)
								SCP->CP_PREREQU :=	"S"
								SCP->CP_XCODOPE :=	MV_PAR01
								SCP->CP_XNOMOPE :=	CB1->CB1_NOME
								SCP->CP_XTIPOSA :=	Iif(MV_PAR02=1,"B","T")
								SCP->CP_XLOCDES :=	MV_PAR03
								SCP->CP_XQTDORI :=	SCP->CP_QUANT
								//SCP->CP_QUANT	:=	0
								SCP->(MsUnLock())

								If MV_PAR02=1

									RecLock("SCQ",.T.)
									SCQ->CQ_FILIAL := xFilial("SCQ")
									SCQ->CQ_NUM    := SCP->CP_NUM
									SCQ->CQ_ITEM   := SCP->CP_ITEM
									SCQ->CQ_PRODUTO:= SCP->CP_PRODUTO
									SCQ->CQ_LOCAL  := SCP->CP_LOCAL
									SCQ->CQ_UM     := SCP->CP_UM
									SCQ->CQ_QUANT  := SCP->CP_QUANT
									SCQ->CQ_QTDISP := nEstoque
									SCQ->CQ_NUMSQ  := cSeq
									SCQ->CQ_DATPRF := SCP->CP_DATPRF
									SCQ->CQ_DESCRI := SCP->CP_DESCRI
									SCQ->CQ_CC     := SCP->CP_CC
									SCQ->CQ_CONTA  := SCP->CP_CONTA
									SCQ->CQ_ITEMCTA:= SCP->CP_ITEMCTA
									SCQ->CQ_CLVL   := SCP->CP_CLVL
									SCQ->CQ_OP	   := SCP->CP_OP
									SCQ->CQ_XCODOPE:= SCP->CP_XCODOPE
									SCQ->CQ_XNOMOPE:= SCP->CP_XNOMOPE
									SCQ->(MsUnLock())

								EndIf

								cSeq  := Soma1(cSeq,Len(SCQ->CQ_NUMSQ))

								cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + " liberada para operador:"+ ALlTRim(SCP->CP_XNOMOPE)  + CRLF

							Else

								cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + "saldo insulficiente para atendimento." + CRLF
								cMsgPrc += "Produto:"+SCP->CP_PRODUTO + "-" + SCP->CP_DESCRI + "Requisitado: "+cValToChar(SCP->CP_QUANT)+" Saldo: "+cValToChar(nEstoque) + CRLF

							EndIf

						Else

							cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + "já foi processada." + CRLF

						EndIf

						SCP->(dbSkip())

					EndDo

				Else

					msgStop("Operador "+MV_PAR01+" não cadastrado","Erro Operador")

				EndIf

			EndIf

		EndIf

		If !Empty(cMsgPrc)
			msgInfo(cMsgPrc,"Status")
		EndIf

		Case nOpc	= 2
		/*=========================================================================================	||
		||ATRIBUIÇÃO EM LOTE DE OPERADOR X SAS														||
		||=========================================================================================	*/
		//If SCP->(dbSeek(xFilial("SCP")+cNumSA))

		U_STPutSx1( cPerg2, "01","Operador:","MV_PAR01"	,"mv_ch1","C",TamSX3("CB1_CODOPE")[1]	,0,"G",		,"CB1"	,"@!")
		U_STPutSx1( cPerg2, "02","SA de:		","MV_PAR02"	,"mv_ch2","C",TamSX3("CP_NUM")[1]			,0,"G",		,""			,"@!")
		U_STPutSx1( cPerg2, "03","SA ate:		","MV_PAR03"	,"mv_ch3","C",TamSX3("CP_NUM")[1]			,0,"G",		,""			,"@!")
		U_StPutSx1(	cPerg2, "04","Tipo:			","mv_par04"	,"mv_ch4","C",01												,0,"C",""	,""			,"","B=Baixa","T=Transf")
		U_StPutSx1(	cPerg2	,"05"	,"Loc.Dest:	","mv_par05"	,"mv_ch5","C",02												,0,"G",""	,"NNR"	,"@!"								)

		If Pergunte(cPerg2,.T.) .And. !Empty(MV_PAR01)

			If MV_PAR04=2 .And. Empty(MV_PAR05)
				msgInfo("Para tipo TRANSFERÊNCIA local destino deve ser informado!","ATENÇÃO")
				Return()
			EndIf

			If CB1->(dbSeek(xFilial("CB1")+MV_PAR01))

				If !MsgNoYes("Deseja atribuir as SA em aberto do número de: "+MV_PAR02+" até: "+MV_PAR03+" para o operador: "+AllTrim(CB1->CB1_NOME)+" ?","***ATENÇÃO***")
					Return()
				EndIf

				SCP->(dbSeek(xFilial("SCP")+MV_PAR02))

				nRecnoSa:=	SCP->(Recno())

				While SCP->(!Eof()) .And. SCP->CP_NUM==cNumSA
					If SB1->(dbSeek(xFilial("SB1")+SCP->CP_PRODUTO)) .And. SB1->B1_TIPO="IC" .And. MV_PAR01="90"
						cMsg90+= "Produto, "+SCP->CP_PRODUTO+" não pode ser movimentado para armazém 90, pois seu tipo é " + SB1->B1_TIPO + CRLF
						lVld90	:=	.F.
					EndIf

					If SCP->CP_STATUS='E'
						cMsg90+="Requisição "+cNumSA+" cancelada/atendida."+ CRLF
						lVld90	:=	.F.
					EndIf

					SCP->(dbSkip())
				EndDo

				If !lVld90
					msgStop(cMsg90)
					RestArea(aArea)
					Return()
				EndIf

				SCP->(dbGoto(nRecnoSa))

				While SCP->(!Eof()) .And. SCP->CP_NUM >= MV_PAR02 .And. SCP->CP_NUM <= MV_PAR03

					If Empty(SCP->CP_PREREQU) .And. Empty(SCP->CP_STATUS)

						If SB2->(dbSeek(xFilial("SB2") + SCP->CP_PRODUTO + SCP->CP_LOCAL))
							nEstoque:=	SaldoSb2()
						Else
							nEstoque:=	0
						EndIf

						If Empty(SCP->CP_PREREQU)

							If nEstoque >= SCP->CP_QUANT

								RecLock("SCP",.F.)
								SCP->CP_PREREQU :=	"S"
								SCP->CP_XCODOPE :=	MV_PAR01
								SCP->CP_XNOMOPE :=	CB1->CB1_NOME
								SCP->CP_XLOCDES :=	MV_PAR05
								SCP->CP_XTIPOSA :=	Iif(MV_PAR04=1,"B","T")
								SCP->CP_XQTDORI :=	SCP->CP_QUANT
								//SCP->CP_QUANT	:=	0
								SCP->(MsUnLock())

								If MV_PAR04=1

									RecLock("SCQ",.T.)
									SCQ->CQ_FILIAL := xFilial("SCQ")
									SCQ->CQ_NUM    := SCP->CP_NUM
									SCQ->CQ_ITEM   := SCP->CP_ITEM
									SCQ->CQ_PRODUTO:= SCP->CP_PRODUTO
									SCQ->CQ_LOCAL  := SCP->CP_LOCAL
									SCQ->CQ_UM     := SCP->CP_UM
									SCQ->CQ_QUANT  := SCP->CP_QUANT
									SCQ->CQ_QTDISP := nEstoque
									SCQ->CQ_NUMSQ  := cSeq
									SCQ->CQ_DATPRF := SCP->CP_DATPRF
									SCQ->CQ_DESCRI := SCP->CP_DESCRI
									SCQ->CQ_CC     := SCP->CP_CC
									SCQ->CQ_CONTA  := SCP->CP_CONTA
									SCQ->CQ_ITEMCTA:= SCP->CP_ITEMCTA
									SCQ->CQ_CLVL   := SCP->CP_CLVL
									SCQ->CQ_OP	   := SCP->CP_OP
									SCQ->CQ_XCODOPE:= SCP->CP_XCODOPE
									SCQ->CQ_XNOMOPE:= SCP->CP_XNOMOPE
									SCQ->(MsUnLock())

								EndIf

								cSeq  := Soma1(cSeq,Len(SCQ->CQ_NUMSQ))

								cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + " liberada para operador:"+ ALlTRim(SCP->CP_XNOMOPE)  + CRLF

							Else

								cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + " saldo insulficiente para atendimento." + CRLF
								cMsgPrc += "Produto:"+SCP->CP_PRODUTO + "-" + SCP->CP_DESCRI + "Requisitado: "+cValToChar(SCP->CP_QUANT)+"Saldo: "+cValToChar(nEstoque) + CRLF

							EndIf

						EndIf

					Else

						cMsgPrc += "SA: " + SCP->CP_NUM + " Item: " + SCP->CP_ITEM + " já foi processada." + CRLF

					EndIf

					SCP->(dbSkip())

				EndDo

			Else

				msgStop("Operador "+MV_PAR01+" não cadastrado","Erro Operador")

			EndIf

		EndIf

		//EndIf

		If !Empty(cMsgPrc)
			msgInfo(cMsgPrc,"Status")
		EndIf

	EndCase

	RestArea(aArea)

	oBrowseCon:bGoTop
	oBrowseCon:Refresh()

Return()

Static Function ConFinal(cNumSa,oBrowseCon)

	Local 	aArea		:= GetArea()
	Private cIDConf  	:= RetCodUsr()
	Private cNconf   	:= UsrRetName(cIDConf)

	SCP->(dbGoTop())
	SCP->(dbSeek(xFilial("SCP")+cNumSa))

	If !MsgNoYes("Deseja encerrar SA ?")
		Return()
	EndIf

	While SCP->(!Eof()) .And. SCP->CP_NUM = cNumSa

		If SCP->CP_STATUS!='E'

			RecLock("SCP",.F.)
			SCP->CP_QUJE	:=	0
			SCP->CP_OBS		:=	SCP->CP_OBS+" Encerrada por:" + AllTrim(cNconf) + " Data: "+Dtoc(dDataBase) //Ticket 20190528000013 - Everson Santana
			SCP->CP_STATUS	:=	"E"
			SCP->CP_PREREQU :=	"S"
			SCP->(MsUnLock())

			/*
			Case SubStr(cStCon,1,1)='4'
			AZUL ENCERRADA
			_cFitro := " SCP->CP_FILIAL='"+cFilAnt+"' .And. !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == 'S' .And. SCP->CP_QUANT > SCP->CP_QUJE "
			*/

			If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_ITEM))

				RecLock("SB2",.F.)
				SB2->B2_QEMPSA	:=	SB2->B2_QEMPSA - SCP->CP_QUANT
				SB2->(MsUnLock())

			EndIf

			dbSelectArea("SCQ")
			SCQ->(dbSetOrder(1))
			//CQ_FILIAL+CQ_NUM+CQ_ITEM+CQ_NUMSQ
			If SCQ->(dbSeek(xFilial("SCQ")+SCP->CP_NUM+SCP->CP_ITEM))
				RecLock("SCQ",.F.)
				SCQ->CQ_QTDISP	:=	0
				SCQ->(MsUnLock())
			EndIf

		Else

			msgInfo("Solicitação já esta finalizada.")

		EndIf

		SCP->(dbSkip())
	EndDo

	RestArea(aArea)
	oBrowseCon:Refresh()

Return()

User Function AcdSa01R()

	Local cTop01	:="SQL01"
	Local	cStPed,cStCom,cStFin,cStLog,cStSep,cStCol,cStEnt,cCodOco
	Local cPergx := "ACDABD"
	Private cPath	:=	""
	Private cSheet1	:=	"Detalhes"
	Private cTable	:=	"Relatório de Solicitações ao Armazém"
	Private oExcel	:=	FWMSEXCEL():New()

	If !ExistDir("C:\TEMP")
		MakeDir("C:\TEMP")
	EndIf

	U_STPutSx1( cPergx, "01","Data de:	","MV_PAR01","mv_ch1","D",TamSX3("C5_EMISSAO")[1]	,0,"G",,"","")
	U_STPutSx1( cPergx, "02","Data ate:	","MV_PAR02","mv_ch2","D",TamSX3("C5_EMISSAO")[1]	,0,"G",,"","")
	U_STPutSx1( cPergx, "03","Sa de:		","MV_PAR03","mv_ch3","C",6,0,"G",,"","")
	U_STPutSx1( cPergx, "04","Sa ate:		","MV_PAR04","mv_ch4","C",6,0,"G",,"","")
	U_STPutSx1( cPergx, "05","Oper de:	","MV_PAR05","mv_ch5","C",6,0,"G",,"CB1","")
	U_STPutSx1( cPergx, "06","Oper ate:	","MV_PAR06","mv_ch6","C",6,0,"G",,"CB1","")

	cPath:= cGetFile("Arquivos xls  (*.xls)  | *.xls  "," ",1,"C:\TEMP",.T.,GETF_LOCALHARD+GETF_RETDIRECTORY ,.F.,.T.)

	If !Pergunte(cPergx,.T.)
		Return()
	EndIf

	If Empty(cPath)
		msgStop('Diretório incorreto!!!','Erro')
		Return()
	Else

		oExcel:AddworkSheet(cSheet1)

		oExcel:AddTable (cSheet1,cTable)
		oExcel:AddColumn(cSheet1,cTable,"FILIAL"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"EMISSÃO"			,1,4)
		oExcel:AddColumn(cSheet1,cTable,"HR INCLUSAO"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"STATUS"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"TIPO"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"NUMERO"				,1,1)
		oExcel:AddColumn(cSheet1,cTable,"CC"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"ITEM"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"PRODUTO"				,1,1)
		oExcel:AddColumn(cSheet1,cTable,"DESCRIÇÃO"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"UNIDADE"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"QUANT_ORI"				,1,2)
		oExcel:AddColumn(cSheet1,cTable,"QUANT_COL"			,1,2)
		oExcel:AddColumn(cSheet1,cTable,"SOLICITANTE"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"OPERADOR"				,1,1)//14
		oExcel:AddColumn(cSheet1,cTable,"NOME"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"LOCAL_ORI"		,1,1)
		oExcel:AddColumn(cSheet1,cTable,"LOCAL_DES"		,1,1)
		oExcel:AddColumn(cSheet1,cTable,"ENDERECO"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"HR INI SEP"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"HR FIM SEP"			,1,1)
		oExcel:AddColumn(cSheet1,cTable,"OBSERVACAO"			,1,1)//19

		cQuery := " SELECT CP_FILIAL FILIAL,CP_EMISSAO EMISSAO, "	+ CRLF
		cQuery += " CASE  "	+ CRLF
		cQuery += " WHEN CP_QUJE=0 AND CP_STATUS='E' THEN 'CANCELADA' "	+ CRLF
		cQuery += " WHEN CP_QUANT=CP_XQTDORI AND CP_STATUS=' ' THEN 'ABERTO' "	+ CRLF
		cQuery += " ELSE 'FINALIZADA' END STATUS, "	+ CRLF
		cQuery += " CP_XTIPOSA TIPO,CP_NUM NUMSA,CP_CC CC,CP_ITEM ITEM,CP_PRODUTO PRODUTO,CP_DESCRI DESCRI, "	+ CRLF
		cQuery += " CP_UM UM,CP_XQTDORI QTDORI,CP_QUANT QTDCOL,CP_SOLICIT SOLICIT,CP_XCODOPE OPERA, "	+ CRLF
		cQuery += " CP_XNOMOPE NOMOPE,CP_LOCAL LOCORI,CP_XLOCDES LOCDES,CP_XENDER ENDERECO,CP_OBS OBS,  "	+ CRLF
		cQuery += " CP_XHRINC XHRINC,CP_XHRINIS XHRINIS,CP_XHRFIMS XHRFIMS "	+ CRLF
		cQuery += " FROM "+RetSqlName("SCP")+" SCP  "	+ CRLF
		cQuery += " WHERE CP_FILIAL='"+cFilAnt+"'  "	+ CRLF
		cQuery += " AND CP_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "	+ CRLF
		cQuery += " AND CP_XCODOPE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "	+ CRLF
		cQuery += " AND CP_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "	+ CRLF
		cQuery += " AND SCP.D_E_L_E_T_!='*' "	+ CRLF

		If !Empty(Select(cTop01))
			DbSelectArea(cTop01)
			(cTop01)->(dbCloseArea())
		Endif

		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

		TcSetField(cTop01,"EMISSAO"	,"D",TamSx3("C5_EMISSAO")[1]	, TamSx3("C5_EMISSAO")[2])

		While (cTop01)->(!Eof())

			oExcel:AddRow(cSheet1,cTable,{;
			(cTop01)->FILIAL,;
			(cTop01)->EMISSAO,;
			(cTop01)->XHRINC,;
			(cTop01)->STATUS,;
			(cTop01)->TIPO,;
			(cTop01)->NUMSA,;
			(cTop01)->CC,;
			(cTop01)->ITEM,;
			(cTop01)->PRODUTO,;
			(cTop01)->DESCRI,;
			(cTop01)->UM,;
			(cTop01)->QTDORI,;
			(cTop01)->QTDCOL,;
			(cTop01)->SOLICIT,;
			(cTop01)->OPERA,;
			(cTop01)->NOMOPE,;
			(cTop01)->LOCORI,;
			(cTop01)->LOCDES,;
			(cTop01)->ENDERECO,;
			(cTop01)->XHRINIS,;
			(cTop01)->XHRFIMS,;
			(cTop01)->OBS;
			})

			(cTop01)->(dbSkip())

		EndDo

		cArq:= cPath+"REL_SOLICITACAO_ARMAZEM.xls"

		oExcel:Activate()
		oExcel:GetXMLFile(cArq)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArq)
		oExcelApp:SetVisible(.T.)

	EndIf

Return()

Static Function StLegSCP(oFolder)

	Local cTiScp 	:= 'Status - Ordem de Separação'

	aLegSCP := {;
	{ "BR_AMARELO"	,	"Pre requisição"},;
	{ "BR_VERDE"	,	"Operação" 			},;
	{ "BR_AZUL"		, 	"Encerrada" },;
	{ "BR_VERMELHO"		, 	"Separada" },;
	{ "BR_LARANJA"	, 	"Parcial" }}

	BrwLegenda(" Legenda ",cTiScp, aLegSCP)

Return()



