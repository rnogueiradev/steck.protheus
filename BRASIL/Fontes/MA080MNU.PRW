#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "FWMVCDEF.CH"
/*====================================================================================\
|Programa  | MA080MNU        | Autor | GIOVANI.ZAGO              | Data | 29/04/2013  |
|=====================================================================================|
|Descrição |  Menu Cpoia de Tes											              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA080MNU                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MA080MNU()
	*-----------------------------*
	
	Local aArea         := GetArea()
	Local _cOrdem       := {}
	Local _cCodAut      := GetMv("ST_CODTES",,'000000')
	Local aRotina 		:= ParamIxb[1] //Ticket 20200522002410

	If __cuserid $ _cCodAut
		aadd(aRotina,{'Copia','U_StTesCopy("SF4", SF4->(RECNO()),3)', 3,0,NIL})
	EndIf
	
	Restarea(aArea)
Return(aRotina)




User Function MTA360MNU()
	*-----------------------------*
	
	Local aArea         := GetArea()
	Local _cOrdem       := {}
	Local _cCodAut      := GetMv("ST_MTA360",,'000000')

	If !(__cuserid $ _cCodAut)
		aRotina:= {}
		
		ADD OPTION aRotina Title "Visualizar" Action 'VIEWDEF.MATA360' OPERATION 2 ACCESS 0 //"Visualizar"
	EndIf
	
	Restarea(aArea)
Return(_cOrdem)


/*====================================================================================\
|Programa  | U_StTesCopy     | Autor | GIOVANI.ZAGO              | Data | 29/04/2013  |
|=====================================================================================|
|Descrição |  Copia da TES												              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | U_StTesCopy                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function StTesCopy(cAlias,nReg,nOpc)
	*-----------------------------*
	Local aSize     := MsAdvSize()
	Local aInfo     := {}
	Local nSaveSX8   := GetSx8Len()
	Local aObjects  := {}
	Local aObj      := {}
	Local aNoFields := {"FC_TES"}
	Local bCampo    := {|nCPO| Field(nCPO)}
	Local bCondicao := {|| .T.}
	Local cSeek     := ""
	Local cWhile    := ""
	Local cCampo    := ""
	Local lGravaOk  := .T.
	Local nX        := 0
	Local nOpca     := 0
	Local nRecSF4   := SF4->(Recno())
	Local oDlg
	Local aHeadCC7	  := {}
	Local aColsCC7	  := {}
	Local lAjICMS     := AliasIndic("CC6").And.AliasIndic("CC7").And.AliasIndic("CC8").And.AliasIndic("CC9").And.;
		AliasIndic("CCA").And.AliasIndic("CCB").And.AliasIndic("CCC").And.AliasIndic("CCD")
	Local lCalcImpV := GetMV("MV_GERIMPV")=="S"
	Local aFolders	:=	{}
	Local cOk       := ""
	Local aButtons	  := {}
	Local aButtonUsr  := {}
	Local nPosX		:=	0
	Local bSkip		  := IIF(lAjICMS .And. CC7->(FieldPos("CC7_TPREG")) > 0,{|| CC7->CC7_TPREG == "NA" },NIL)
	Local aCmpsCC7	:=	{"CC7_CODLAN"}
	
	PRIVATE oGetd
	PRIVATE aTELA[0][0],aGETS[0]
	
	ALTERA:= .F.
	INCLUI:= .T.
	
	If SoftLock("SF4") .And. SF4->(LastRec()) <> 0 .And. SF4->F4_FILIAL == xFilial("SF4")
		
		aHeader := {}
		aCols	:= {}
		
		If lCalcImpV
			aAdd(aFolders,"Impostos variáveis")	//"Impostos variáveis"
			
			dbSelectArea("SFC")
			dbSetOrder(1)
			If dbSeek(xFilial("SFC")+SF4->F4_CODIGO)
				cSeek    := xFilial("SFC")+SF4->F4_CODIGO
				cWhile   := "SFC->FC_FILIAL+SFC->FC_TES"
				bCondicao:= {|| If( SoftLock("SFC") , .T. , .F. ) }
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FillGetDados(nOpc,"SFC",1,cSeek,{|| &cWhile },bCondicao,aNoFields,,,,,,,,,,,)
			Else
				FillGetDados(nOpc,"SFC",1,,,,aNoFields,,,,,.T.,,,,,)
				aCols[1][aScan(aHeader,{|x| Trim(x[2])=="FC_SEQ"})] := StrZero(1,Len(SFC->FC_SEQ))
			EndIf
		EndIf
		
		If lAjICMS
			Private	oNewGetDad
			
			aAdd(aFolders,"Lançamentos da Apuração de ICMS"	)	//"Lançamentos da Apuração de ICMS"
			aMHead("CC7","CC7_TES/",@aHeadCC7)
			CC7->(dbSeek(xFilial("CC7")+SF4->F4_CODIGO))
			aMAcols(nOpc,"CC7",@aColsCC7,aHeadCC7,{||CC7->CC7_TES==SF4->F4_CODIGO},bSkip)
			
			If CC7->(FieldPos("CC7_IFCOMP"))>0
				aAdd(aCmpsCC7,"CC7_IFCOMP")
			EndIf
			If CC7->(FieldPos("CC7_CLANAP"))>0
				aAdd(aCmpsCC7,"CC7_CLANAP")
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para incluir Botoes na ToolBar.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( ExistBlock("MA080BUT") )
			aButtonUsr := ExecBlock("MA080BUT",.F.,.F.,{nOpc})
			If ( ValType(aButtonUsr) == "A" )
				For nX := 1 To Len(aButtonUsr)
					aadd(aButtons,aClone(aButtonUsr[nX]))
				Next nX
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva a integridade dos campos de Bancos de Dados    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF4")
		For nX := 1 to FCount()
			nPosX := aScan(aAutoCab,{|aX|AllTrim(Eval(bCampo,nX))$aX[1]})
			If nPosX<>0
				M->&(Eval(bCampo,nX)) := aAutoCab[nPosX,2]
			Else
				M->&(Eval(bCampo,nX)) := FieldGet(nX)
			EndIf
		Next nX
		
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 100,  60, .T., .T. } )
		aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
		aObj  := MsObjSize( aInfo, aObjects, .T. )
		
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		
		EnChoice( "SF4", nReg, nOpc, , , , , aObj[1], , 3 )
		
		oFolder := TFolder():New(aObj[2,1],aObj[2,2],aFolders,{},oDlg,,,,.t.,.f.,aObj[2,4],aObj[2,3],)
		
		cOk	:=	"{||nOpcA:=1"
		If lCalcImpV
			A081Cab(nOpc)
			oGetd:=MsGetDados():New(0,0,aObj[2,3]-aObj[2,1]-13,aObj[2,4],nOpc,"A081LinOk","A081TudOk","+FC_SEQ",.T.,,,,,,,,,oFolder:aDialogs[1])
			oGetd:oBrowse:bGotFocus:={|| A081Cab(nOpc)}
			If lAjICMS
				cOk	+=	",if(A081TudOk(,nOpc).And.AjusteLOK(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)"
			Else
				cOk	+=	",if(A081TudOk(,nOpc),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)"
			EndIf
		EndIf
		
		If lAjICMS
			oNewGetDad := MsNewGetDados():New(0,0,aObj[2,3]-aObj[2,1]-13,aObj[2,4],GD_UPDATE+GD_INSERT+GD_DELETE,"AjusteLOK","AllwaysTrue","+CC7_SEQ",aCmpsCC7,/*freeze*/,990,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[Iif(lCalcImpV,2,1)],@aHeadCC7,@aColsCC7)
			cOk	+=	Iif(lCalcImpV,"",",Iif(AjusteLOK(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca:=0)")
		Else
			cOk	+=	Iif(lCalcImpV,"",",Iif(A081TudOk(,nOpc),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)")
		EndIf
		cOk	+=	"}"
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,&(cOk),{||oDlg:End()},,aButtons)
		
		If nOpcA == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o registro em questao esta sendo usado    ³
			//³por outra estacao                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*	Begin Transaction
			
			lGravaOk := A081Grava(nRecSF4)
			IF lGravaOk
				If lAjICMS
					GrvAjuste(.T.)
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  Processa Gatilhos                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				EvalTrigger()
			EndIf
			
		End Transaction   */
		Begin Transaction
			lGravaOk := A081Grava()
			If lGravaOk
				If lAjICMS
					GrvAjuste()
				Endif
				While( GetSx8Len() > nSaveSx8 )
				ConfirmSX8()
			EndDo
			EvalTrigger()
		EndIf
	End Transaction
	
	
	If lGravaOk
		MT080AltOk()
	EndIf
EndIf
Else
	IF SF4->F4_FILIAL <> xFilial("SF4")
		Help(" ",1,"A000FI")
	Endif
EndIf

Return( .T. )

/*====================================================================================\
|Programa  | aMHead          | Autor | GIOVANI.ZAGO              | Data | 29/04/2013  |
|=====================================================================================|
|Descrição |   															              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | aMHead                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function aMHead(cAlias,cNCmps,aH)
	*-----------------------------*
	Local	lRet	:=	.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a Integridade dos campos de Bancos de Dados            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	While !Eof() .And. (X3_ARQUIVO==cAlias)
		IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(AllTrim(X3_CAMPO)+"/"$cNCmps)
			AADD(aH,{ Trim(X3Titulo()), ;
				AllTrim(X3_CAMPO),;
				X3_PICTURE,;
				X3_TAMANHO,;
				X3_DECIMAL,;
				X3_VALID,;
				X3_USADO,;
				X3_TIPO,;
				X3_F3,;
				X3_CONTEXT,;
				X3_CBOX,;
				X3_RELACAO})
		Endif
		dbSkip()
	Enddo
Return lRet

/*====================================================================================\
|Programa  | aMAcols         | Autor | GIOVANI.ZAGO              | Data | 29/04/2013  |
|=====================================================================================|
|Descrição |   															              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | aMAcols                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function aMAcols(nOpc,cAlias,aC,aH,bCond,bSkip)
	*-----------------------------*
	Local	lRet	:=	.T.
	Local	nI		:=	0
	
	DEFAULT bSkip 	:= {|| .F. }
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	If nOpc#3 .And. !Eof()	//nopc==3 indica INCLUSAO
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o array aCols com os itens                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aC	:=	{}
		While !Eof() .And. Eval(bCond)
			IF Eval(bSkip)
				dbSkip()
				Loop
			EndIf
			aAdd(aC,Array(Len(aH)+1))
			For nI := 1 To Len(aH)
				aC[Len(aC),nI] := FieldGet(FieldPos(aH[nI,2]))
			Next
			aC[Len(aC),Len(aH)+1] := .F.
			dbSkip()
		End
	Else
		aC				:=	{Array(Len(aH)+1)}
		aC[1,Len(aH)+1]	:=	.F.
		For nI := 1 To Len(aH)
			If aH[nI,10]#"V"
				aC[1,nI]	:=	CriaVar(aH[nI,2])
			EndIf
			
			If "_SEQ"$aH[nI,2]
				aC[1,nI]	:=	StrZero(1,aH[nI,4])
			EndIf
		Next
	EndIf
Return lRet
/*====================================================================================\
|Programa  | GrvAjuste       | Autor | GIOVANI.ZAGO              | Data | 29/04/2013  |
|=====================================================================================|
|Descrição |   															              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GrvAjuste                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function GrvAjuste(lAltera)
	*-----------------------------*
	Local	lRet		:=	.T.
	Local	aColsNew	:=	aClone(oNewGetDad:aCols)
	Local	aHeadNew	:=	aClone(oNewGetDad:aHeader)
	Local	nPosSeq		:=	aScan(aHeadNew,{|aX| aX[2]=="CC7_SEQ"})
	Local	nPosCA		:=	aScan(aHeadNew,{|aX| aX[2]=="CC7_CODLAN"})
	Local	nPosDR		:=	aScan(aHeadNew,{|aX| aX[2]=="CC7_DESCR"})
	Local	nPosIFCOMP	:=	aScan(aHeadNew,{|aX| aX[2]=="CC7_IFCOMP"})
	Local	nPosClan	:=	aScan(aHeadNew,{|aX| aX[2]=="CC7_CLANAP"})
	Local	nI			:=	0
	Local	lAchouCC7	:=	.F.
	
	Default	lAltera	:=	.F.
	
	dbSelectArea("CC7")
	dbSetOrder(1)
	
	If lAltera
		CC7->(dbSeek(xFilial("CC7")+SF4->F4_CODIGO))
		While !CC7->(Eof()) .And. CC7->(CC7_FILIAL+CC7_TES)==xFilial("CC7")+SF4->F4_CODIGO
			RecLock("CC7",.F.)
			dbDelete()
			MsUnLock()
			CC7->(FKCommit())
			CC7->(dbSkip())
		End
	EndIf
	
	For nI := 1 To Len(aColsNew)
		If !Empty(aColsNew[nI,nPosCA]) .Or.  IIf( CC7->(FieldPos("CC7_CLANAP")) > 0 , !Empty(aColsNew[nI,nPosClan]) , .T. )
			
			If aColsNew[nI,Len(aColsNew[nI])]
				Loop
			Else
				RecLock("CC7",.T.)
				CC7->CC7_FILIAL	:=	xFilial("CC7")
				CC7->CC7_TES	:=	SF4->F4_CODIGO
				CC7->CC7_SEQ	:=	aColsNew[nI,nPosSeq]
				CC7->CC7_CODLAN	:=	aColsNew[nI,nPosCA]
				CC7->CC7_DESCR	:=	aColsNew[nI,nPosDR]
				If CC7->(FieldPos("CC7_IFCOMP"))>0
					CC7->CC7_IFCOMP	:=	aColsNew[nI,nPosIFCOMP]
				EndIf
				If CC7->(FieldPos("CC7_CLANAP"))>0
					CC7->CC7_CLANAP	:= aColsNew[nI,nPosClan]
				EndIf
				MsUnLock()
				CC7->(FKCommit())
			EndIf
		EndIf
	Next nI
Return lRet
