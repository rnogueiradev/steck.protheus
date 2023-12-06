#INCLUDE "Average.ch"
/*
Programa        : EECEstufMerc_rdm.prw
Objetivo        : Realizar as manutenções de estufagem de mercadoria.
Autor           : Julio de Paula Paz
Data/Hora       : 02/09/2010 - 02/09/2010
Obs.            :
*/

/*
Funcao      : ECEstufMerc()
Retorno     : NIL
Objetivos   : Manutencao da rotina de estufatem de mercadorias
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 08:15
Revisao     :
Obs.        :
*/
User Function ECEstufMerc()

	Local nInc, aButtons := {}
	Local nOpcA := 0, nReg := EEC->( Recno() )
	Local bOk , bCancel := {|| oDlg:End() }
	Local aPos,  oDlg, oMark
	Local aSelectFields := {{"EX9_CONTNR",AVSX3("EX9_CONTNR",6),"No.Container"},;
	{"EX9_LACRE",AVSX3("EX9_LACRE",6),"Lacre"},;
	{{|| Transf(TRB->EX9_TARA,AVSX3("EX9_TARA",6))},"","Tara"}}

	Private aCampos :={}, aGets[0], aTela[0], aObjs[4], aDeletados := {}
	Private aMemos:={{"EX9_OBS","EX9_VM_OBS"}}
	Private aDelContainer:={}
	Private nSelecao := 4
	Private cNomArq, cNomArq2

	Begin Sequence
		If !Empty(EEC->EEC_DTEMBA)
			MsgInfo( "Embarque finalizado.", "Atenção") //###
			aAdd(aButtons,{"ANALITICO",{|| EstufMDet(VIS_DET)},"Visualizar"})

		ElseIf lIntermed .And. EEC->EEC_FILIAL <> cFilBr
			MsgInfo("Inclusões/Alterações/Exclusões deverão ser realizadas apenas na filial Brasil.","Atenção")
			aAdd(aButtons,{"ANALITICO",{|| EstufMDet(VIS_DET)},"Visualizar"})

		Else
			aAdd(aButtons,{"ANALITICO",{|| EstufMDet(VIS_DET)},"Visualizar"})
			aAdd(aButtons,{"EDIT"     ,{|| EstufMDet(INC_DET)},"Incluir"})
			aAdd(aButtons,{"ALT_CAD"  ,{|| EstufMDet(ALT_DET)},"Alterar"})
			aAdd(aButtons,{"EXCLUIR"  ,{|| EstufMDet(EXC_DET)},"Excluir"})
		EndIf

		M->EEC_PREEMB := EEC->EEC_PREEMB
		M->EEC_IMPORT := EEC->EEC_IMPORT
		M->EEC_IMPODE := EEC->EEC_IMPODE
		M->EEC_STTDES := EEC->EEC_STTDES
		bOk := {|| nOpcA:=1, IF(EstufValid(3),oDlg:End(),nOpcA:=0)}

		// WORK dos Containers
		aCampos:= Array(EX9->(FCount()))
		aSemSx3 := {}
		Aadd( aSemSx3, { "RECNO", "N", 10, 0 })

/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo de trabalho                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNomArq 	:=  CriaTrab(aSemSx3)
		dbUseArea( .T.,"DBFCDX", cNomArq,"TRB", .F. , .F. )

		cNomArqI := Subs(cNomArq,1,7)+"A"
		IndRegua("TRB",cNomArqI,"EX9_CONTNR",,,)		//"Selecionando Registros..."

		dbClearIndex()
		dbSetIndex(cNomArqI+OrdBagExt())
*/

		cNomArq:=E_CriaTrab("EX9",aSemSx3,"TRB")

		cNomArqI := Subs(cNomArq,1,7)+"A"
		IndRegua("TRB",cNomArqI,"EX9_CONTNR",,,)		//"Selecionando Registros..."

		//dbClearIndex()
		//dbSetIndex(cNomArqI+OrdBagExt())

		//IndRegua("TRB",cNomArq+OrdBagExt(),"EX9_CONTNR")

		// WORK das embalagens separadas no módulo da Microsiga e vinculadas ao processo de embarque.
		aCampos:= Array(ZZA->(FCount()))
		aSemSx3 := {}
		Aadd( aSemSx3, { "RECNO"   , "N", 10, 0 })
		Aadd( aSemSx3, { "WKSTATUS", "C", 01, 0 })
		Aadd( aSemSx3, { "WKFLAG"  , "C", 02, 0 })
		cNomArq2:=E_CriaTrab("ZZA",aSemSx3,"WorkZZA")
		//IndRegua("WorkZZA",cNomArq2+OrdBagExt(),"ZZA_CONTNR+ZZA_PALLET+ZZA_VOLUME")

		//grava registro no WORK
		EstufGrvTRB()

		If lIntermed
			If IsVazio("TRB") .And. EEC->EEC_FILIAL <> cFilBr
				MsgStop("Não existe container cadastrado para o processo.","Atenção")
				lRet:=.f.
				Break
			EndIf
		EndIf

		TRB->(dbGoTop())
		nOpcA := 0
		nOpc  := 2

		Define MsDialog oDlg Title cCadastro From DLG_LIN_INI,DLG_COL_INI To DLG_LIN_FIM,DLG_COL_FIM Of oMainWnd Pixel

		@ 18,03  Say AvSx3("EEC_PREEMB",AV_TITULO) Pixel Of oDlg
		@ 18,180 Say AvSx3("EEC_IMPORT",AV_TITULO) Pixel Of oDlg
		@ 29,03  Say AvSx3("EEC_IMPODE",AV_TITULO) Pixel Of oDlg
		@ 40,03  Say AvSx3("EEC_STTDES",AV_TITULO) Pixel Of oDlg

		@ 18,40  MsGet aObjs[1] Var M->EEC_PREEMB  Picture AVSX3("EEC_PREEMB",AV_PICTURE) Pixel Of oDlg ;
		When .F. Size 3.5*AVSX3("EEC_PREEMB",AV_TAMANHO),08
		@ 18,220 MsGet aObjs[2] Var M->EEC_IMPORT  Picture AVSX3("EEC_IMPORT",AV_PICTURE) Pixel Of oDlg ;
		When .F. Size 4.5*AVSX3("EEC_IMPORT",AV_TAMANHO),08
		@ 29,40  MsGet aObjs[3] Var M->EEC_IMPODE  Picture AVSX3("EEC_IMPODE",AV_PICTURE) Pixel Of oDlg ;
		When .F. Size 3.5*AVSX3("EEC_IMPODE",AV_TAMANHO),08
		@ 40,40  MsGet aObjs[4] Var M->EEC_STTDES  Picture AVSX3("EEC_STTDES",AV_PICTURE) Pixel Of oDlg ;
		When .F. Size 4.5*AVSX3("EEC_STTDES",AV_TAMANHO),08

		oSelect := MsSelect():New("TRB",,,aSelectFields,,,PosDlgDown(oDLG))
		oSelect:bAval := {|| EstufMDet(VIS_DET,oSelect) }

		Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered

		If nOpcA == 1
			Begin Transaction
				Processa({|| EstufGrava(nReg)})
				//Processa Gatilhos
				EvalTrigger()
				If __lSX8
					ConfirmSX8()
				EndIf
			End Transaction
		ElseIf nOpcA == 2
			Begin Transaction
				EX9->(DbSeek(xFilial()+EEC->EEC_PREEMB))
				While EX9->( !Eof() ) .And. EX9->(EX9_FILIAL+EX9_PREEMB)  == EEC->(EEC_FILIAL+EEC_PREEMB)
					MSMM(EX9->EX9_OBS,,,,EXCMEMO)
					MSMM(EX9->EX9_CCOTEM,,,,EXCMEMO)
					EX9->(RecLock("EX9",.F.))
					EX9->(dbDelete())
					EX9->(MSUNLOCK())
					EX9->(dbSkip())
				Enddo

			End Transaction
		ElseIf nOpcA == 0
			If __lSX8
				RollBackSX8()
			Endif
		EndIf

	End Sequence

	If Select("TRB") > 0
		TRB->(E_EraseArq(cNomArq))
	EndIf

	If Select("WorkZZA") > 0
		WorkZZA->(E_EraseArq(cNomArq2))
	EndIf

Return NIL

/*
Funcao      : EstufGrvTRB
Parametros  : nenhum
Retorno     : .T./.F.
Objetivos   : Grava Destinos
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function EstufGrvTRB

	Begin Sequence
		EX9->(dbSeek(xFilial("EX9")+M->EEC_PREEMB ))
		Do While EX9->(!Eof()) .And. EX9->(EX9_FILIAL+EX9_PREEMB) == (XFILIAL("EEC")+M->EEC_PREEMB)
			TRB->(dbAppend())
			TRB->RECNO := EX9->(RecNo())
			AVREPLACE("EX9","TRB")

			TRB->EX9_VM_OBS := MSMM(EX9->EX9_OBS,AVSX3("EX9_VM_OBS")[AV_TAMANHO])
			TRB->EX9_COMTEM := MSMM(EX9->EX9_CCOTEM,AVSX3("EX9_COMTEM")[AV_TAMANHO])
			EX9->(dbSkip())
		Enddo

		ZZA->(DbSetOrder(4))
		ZZA->(DbSeek(xFilial("ZZA")+EEC->EEC_PREEMB))
		Do While !ZZA->(Eof()) .And. ZZA->(ZZA_FILIAL+ZZA_PREEMB) == xFilial("ZZA")+EEC->EEC_PREEMB
			WorkZZA->(DbAppend())
			AvReplace("ZZA","WorkZZA")
			WorkZZA->Recno := ZZA->(Recno())
			WorkZZA->WKSTATUS   := If(!Empty(ZZA->ZZA_PALLET) .And. !Empty(ZZA->ZZA_CONTNR), "2", "0")
			WorkZZA->(MsUnlock())

			ZZA->(DbSkip())
		EndDo

	End Sequence
Return (TRB->(LastRec()) != 0)

/*
Funcao      : EstufGrava
Parametros  : cAlias := alias arq.
nReg   := num.registro
nOpc   := opcao escolhida
Retorno     : .T.
Objetivos   : Grava Containers do Processo
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function EstufGrava(nReg)
	Local i
	Local lRet := .t.

	ProcRegua(TRB->(LastRec())+1)

	IncProc("Atualizando arquivos ...")

	//³ Grava arquivo EX9 (Containers)                               ³

	TRB->(dbGoTop())

	While ! TRB->(Eof())
		IncProc()

		IF TRB->RECNO == 0
			EX9->(RecLock("EX9",.T.))
			EX9->EX9_FILIAL := xFilial("EX9")
			EX9->EX9_PREEMB := EEC->EEC_PREEMB
		Else
			EX9->(dbGoTo(TRB->RECNO))
			EX9->(RecLock("EX9",.F.))
		Endif
		AvReplace("TRB","EX9")

		If TRB->Recno <> 0
			MSMM(EX9->EX9_OBS,,,,EXCMEMO)
			MSMM(EX9->EX9_CCOTEM,,,,EXCMEMO)
		EndIf

		EX9->(MSMM(EX9->EX9_OBS,AVSX3("EX9_VM_OBS",AV_TAMANHO),,TRB->EX9_VM_OBS,INCMEMO,,,"EX9","EX9_OBS"))
		EX9->(MSMM(EX9->EX9_CCOTEM,AVSX3("EX9_COMTEM",AV_TAMANHO),,TRB->EX9_COMTEM,INCMEMO,,,"EX9","EX9_CCOTEM"))

		EX9->(MSUnlock())
		TRB->(DbSkip())
	EndDo

	For i:=1 To Len(aDeletados)
		IncProc()
		EX9->(DbGoTo(aDeletados[i]))

		// Limpa o numero dos containers excluidos da tabela WorkZZA.
		WorkZZA->(DbGoTop())
		Do While !WorkZZA->(Eof())
			If WorkZZA->ZZA_CONTNR == EX9->EX9_CONTNR
				WorkZZA->(RecLock("WorkZZA",.F.))
				WorkZZA->ZZA_CONTNR := Space(AvSx3("EX9_CONTNR",3))
				WorkZZA->(MsUnlock())
			EndIf
			WorkZZA->(DbSkip())
		EndDo

		aAdd(aDelContainer,EX9->EX9_CONTNR)
		MSMM(EX9->EX9_OBS,,,,EXCMEMO)
		MSMM(EX9->EX9_CCOTEM,,,,EXCMEMO)
		EX9->(RecLock("EX9",.F.))
		EX9->(dbDelete())
		EX9->(MSUnlock())
	Next i

	// Grava a Tabela ZZA
	WorkZZA->(DbGoTop())
	Do While !WorkZZA->(Eof())
		ZZA->(DbGoTo(WorkZZA->RECNO))
		ZZA->(RecLock("ZZA",.F.))
		AvReplace("WorkZZA","ZZA")
		ZZA->(MsUnlock())
		WorkZZA->(DbSkip())
	EndDo

Return lRet

/*
Funcao      : EstufMDet
Parametros  : nOpc := 2 // Visualizacao
3 // Inclusao
4 // Alteracao
5 // Exclusao
Retorno     : NIL
Objetivos   : Manutencao dos Containers
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function EstufMDet(nOpc)
	Local nAreaOld := Select()
	Local oDlg, nOpcA:=0
	Local nInc

	Local bOk     := {||nOpcA:=1,If(EstufValDet(nOpc,nReg),oDlg:End(),nOpcA=0)}
	Local bCancel := {|| oDlg:End()}

	Local aSelectZZA := {{"WKFLAG","","  "},;
	{{|| ZZA_PEDIDO}, ,"Pedido Exp."},;
	{{|| ZZA_SEQUEN}, ,"Seq.Pedido"},;
	{{|| ZZA_PEDFAT}, ,"Ped.de Venda"},;
	{{|| ZZA_FATIT }, ,"Item do PV"},;
	{{|| ZZA_CONTNR}, ,"Container"},;
	{{|| ZZA_PALLET}, ,"Pallet"},;
	{{|| ZZA_ORDSEP}, ,"Numero Ordem"},;
	{{|| ZZA_CODETI}, ,"Cod.Etiqueta"},;
	{{|| ZZA_PROD  }, ,"Produto"},;
	{{|| ZZA_VOLUME}, ,"Volume"},;
	{{|| ZZA_ITEM  }, ,"Item"},;
	{{|| Transform(ZZA_QTEEMB,AvSx3("ZZA_QTEEMB",6))}, ,"Qtde Embalado"},;
	{{|| ZZA_LOTECT}, ,"Lote"},;
	{{|| ZZA_NUMLOT}, ,"SubLote"},;
	{{|| ZZA_NUMSER}, ,"Num de Serie"},;
	{{|| ZZA_DOC   }, ,"Documento"},;
	{{|| ZZA_TIPVOL}, ,"Tipo Volume"},;
	{{|| ZZA_DSCVOL}, ,"Descr.Volume"},;
	{{|| Transform(ZZA_PESVOL,AvSx3("ZZA_PESVOL",6))}, ,"Peso Volume"}}
	Local aButtonZZA := {}
	Local bMarca, bDesmarca
	Local aSize	:= {}
	Private cMarca:=GetMark()

	Private aTela[0][0],aGets[0],nUsado:=0
	Private cContainer := ""
	Private oSelectZZA

	Private cNrCntr
	Private cSemContainer := Space(AvSx3("ZZA_CONTNR",3))
	Private lInclusao, lSteckRotContainer := .T.
	Private nReg
	Private aCores := {}

	Begin Sequence
		If nOpc != INC_DET .And. TRB->(EOF()) .AND. TRB->(BOF())
			MsgInfo("Não existem registros para a manutenção !","Aviso")
			Break
		EndIf

		nReg := TRB->(RecNo())

		For nInc := 1 TO TRB->(FCount())
			If AllTrim(TRB->(FieldName(nInc))) $ "DELETE,RECNO"
				Loop
			EndIf

			If nOpc == INC_DET // Inclusao
				TRB->(M->&(FieldName(nInc)) := CriaVar(FieldName(nInc)))
			Else
				TRB->(M->&(FieldName(nInc)) := TRB->(FIELDGET(nInc)))
			EndIf
		Next nInc

		If nOpc == INC_DET // INCLUIR
			M->EX9_PREEMB := M->EEC_PREEMB
			M->EX9_VM_OBS := ""
			M->EX9_OBS    := ""
			lInclusao := .T.
		Else
			cContainer := M->EX9_CONTNR
			lInclusao := .F.
		EndIf

		If !(Str(nOpc,1) $ Str(VIS_DET,1)+"/"+Str(EXC_DET,1))
			aAdd(aButtonZZA,{"CONTAINR"    ,{|| AltVariosPallets()},"Altera Pallet em lotes"})
			aAdd(aButtonZZA,{"EDIT"        ,{|| AltSelectPallet()} ,"Altera Pallet"})
			aAdd(aButtonZZA,{"NOTE"        ,{|| LegendaVolume()}   ,"Legenda"})
		EndIf

		WorkZZA->(DbSetFilter({|| ZZA_CONTNR == M->EX9_CONTNR .Or. ZZA_CONTNR == cSemContainer},"ZZA_CONTNR =='"+M->EX9_CONTNR+"' .Or. ZZA_CONTNR =='"+cSemContainer+"'"))
		WorkZZA->(DbGoTop())
		cNrCntr := M->EX9_CONTNR
		Aadd(aCores, {"WorkZZA->WKSTATUS=='0'", "BR_VERDE"})
		Aadd(aCores, {"WorkZZA->WKSTATUS=='2'", "BR_VERMELHO"})

		// Seleção dos dados
		xbMarca := {|| WKFLAG := cMarca}
		xbDesmarca := {|| WKFLAG := Space(2)}

		While .T.
			nOpcA := 0
			aTela := {}
			aGets := {}
			aSize := MsAdvSize()
			//Define MsDialog oDlg Title "Containers para o Processo => "+M->EEC_PREEMB From DLG_LIN_INI,DLG_COL_INI To DLG_LIN_FIM,DLG_COL_FIM Of oMainWnd Pixel
			Define MsDialog oDlg Title "Containers para o Processo => "+M->EEC_PREEMB FROM aSize[7],00 TO aSize[6],aSize[5] Of oMainWnd Pixel
			aPosEnc:= PosDlg(oDlg)
			aPosEnc[3] -=170 // 30

			//EnChoice("EX9", , 3, , , , , PosDlg(oDLG), IF(STR(nOpc,1) $ Str(VIS_DET,1)+"/"+Str(EXC_DET,1),{},), 3)
			//EnChoice("EX9", , 3, , , , , aPosEnc, IF(STR(nOpc,1) $ Str(VIS_DET,1)+"/"+Str(EXC_DET,1),{},), 3)
			EnChoice("EX9", , 3, , , , , aPosEnc, IF(STR(nOpc,1) $ Str(3,1)+"/"+Str(6,1),{},), 3)

			//oSelectZZA := MsSelect():New("WorkZZA",,,aSelectZZA,,,PosDlgDown(oDLG))
			oSelectZZA := MsSelect():New("WorkZZA" ,"WKFLAG",,aSelectZZA,,@cMarca,PosDlgDown(oDLG),,,,,aCores)
			//oMark:bAval := {|| if(Empty(WorkZZA->WKFLAG), If(ValidaPallet("MSSELECT"),Eval(bMarca),),Eval(bDesMarca))  }
			//oMark:bAval := {|| if(WorkZZA->WKSTATUS != '2' , If(ValidaPallet("MSSELECT"),Eval(bMarca),),Eval(bDesMarca))  }
			//oSelectZZA:bAval := {| | ValidaPallet("MSSELECT")}
			oSelectZZA:bAval := {| | If(Empty(WKFLAG), If(ValidaPallet("MSSELECT"),workZZA->WKFLAG := cMarca,),workZZA->WKFLAG := Space(2))}
			//oSelect:bAval := {|| EstufMDet(VIS_DET,oSelect) }

			Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtonZZA)  // AvBar(nOpc,oDlg,bOk,bCancel,,aButtonZZA)

			If nOpcA == 1 // Ok
				If nOpc == INC_DET
					TRB->(DBAPPEND())
					nReg := TRB->(RecNo())
				EndIf

				If ! Str(nOpc,1) $ Str(VIS_DET,1)+"/"+Str(EXC_DET,1)
					TRB->(DbGoto(nReg))

					For nInc:= 1 To TRB->(FCount())
						If AllTrim(TRB->(FieldName(nInc))) $ "RECNO,DELETE"
							Loop
						EndIf
						TRB->(FieldPut(nInc,M->&(FieldName(nInc))))
					Next
				EndIF

				If nOpc == EXC_DET .And. MsgYesNo("Confirma a exclusão do container?","Atenção")
					WorkZZA->(DbGoTop())
					Do While !WorkZZA->(Eof())
						WorkZZA->(RecLock("WorkZZA",.F.))
						WorkZZA->ZZA_CONTNR := Space(AvSx3("EX9_CONTNR",3))
						WorkZZA->ZZA_PALLET := ""
						WorkZZA->(MsUnlock())
						WorkZZA->(DbSkip())
					EndDo
					If TRB->RECNO > 0
						Aadd(aDeletados,TRB->RECNO)
					EndIf
					TRB->(DbDelete())
				EndIf

				oSelect:oBrowse:Refresh()

				Exit
			ElseIf nOpcA == 0 // Cancel
				Exit
			EndIf
		EndDo

		WorkZZA->(DbClearFilter())

	End Sequence

	Select(nAreaOld)

Return Nil

/*
Funcao      : ValidaPallet(cChamada)
Parametros  : cChamada = "MSSELECT" = Validação Chamada da Rotina MSSelect
cChamada = "DIGITACAO_PALLET" = Validação Chamada da Rotina de Digitação do Pallet.
Retorno     : .T./.F.
Objetivos   : Validar a alteração de um item que já possui pallet informado.
Autor       : Julio de Paula Paz
Data/Hora   : 04/03/2013  - 16h19
Revisao     :
Obs.        :
*/
Static Function ValidaPallet(cChamada)
	Local lRet := .T.

	Begin Sequence
		Do Case
			Case cChamada == "MSSELECT"
			If !Empty(WorkZZA->ZZA_PALLET) .And. !Empty(WorkZZA->ZZA_CONTNR)
				lRet := MsgYesNo("Este volume já está relacionado a um Pallet/Container. Confirma a seleção deste volume?","Atenção")
			EndIf

			Case cChamada == "DIGITACAO_PALLET"
			If !Empty(WorkZZA->ZZA_PALLET)
				lRet := MsgYesNo("Este volume já está relacionado a um Pallet/Container. Confirma a alteração deste volume?","Atenção")
			EndIf

		EndCase
	End Sequence

	//*** Alterado pelo Fernando em 26/08/13
	//If Empty(WKFLAG)
	//  workZZA->WKFLAG := cMarca
	//Else
	//  workZZA->WKFLAG := Space(2)
	//Endif

	//If WKSTATUS=='2'
	//  workZZA->WKFLAG := Space(2)
	//Endif

Return(lRet)

/*
Funcao      : LegendaVolume()
Parametros  : Nenhum.
Retorno     : .T.
Objetivos   : Exibir a legenda dos volumes
Autor       : Julio de Paula Paz
Data/Hora   : 04/03/2013  - 17h13
Revisao     :
Obs.        :
*/
Static Function LegendaVolume()
	Local lRet := .T.
	Local aLegenda := {}

	Begin Sequence
		Aadd(aLegenda,{"BR_VERDE","Pallet já informado para este Volume."})
		Aadd(aLegenda,{"BR_VERMELHO","Volume sem Pallet informado."})

		BrwLegenda("Status dos Volumes","Legenda", aLegenda)

	End Sequence

Return lRet

/*
Funcao      : EstufValid(nOpc)
Parametros  : nOpc := 2 - Visualizacao
3 - Inclusao
4 - Alteracao
5 - Exclusao
Retorno     : .T./.F.
Objetivos   : Consistencias do EX9
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function EstufValid(nOpc)
	Local lRet := .T.

	Begin Sequence
		If Str(nOpc,1) $ Str(INCLUIR,1)+"/"+Str(ALTERAR,1)
			If ! Obrigatorio(aGets,aTela)
				lRet := .F.
				Break
			EndIf
			TRB->(DbGoTop())

		ElseIf nOpc == EXCLUIR
			If ! MsgNoYes("Confirma a Exclusão ?","Atenção")
				lRet := .F.
				Break
			EndIf
		EndIf
	End Sequence

Return lRet

/*
Funcao      : EstufValDet
Parametros  : nOpc   := 2 // Visualizacao
3 // Inclusao
4 // Alteracao
5 // Exclusao
nReg   := Numero do Registro
cCampo := Nome do campo.
Retorno     : .T./.F.
Objetivos   : Consistencias dos Containers
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function EstufValDet()
	Local aOrd, lRet := .T.
	Local nRecno := 0

	Begin Sequence

		If Empty(M->EX9_CONTNR)
			MsgAlert("Favor preencher o container")
			lRet := .F.
			break
		EndIf

		If ReadVar() = "M->EX9_CONTNR"
			If nSelecao = INCLUIR
				aOrd := SaveOrd("EX9")
				If !(lRet := ExistChav("EX9",EEC->EEC_PREEMB+M->EX9_CONTNR))
					Break
				EndIf
			EndIf

			If EECFlags("ESTUFAGEM")
				If nSelecao <> INCLUIR
					nRecno := (cWorkEX9)->(Recno())
				EndIf
				If (cWorkEX9)->(DbSeek(M->EX9_CONTNR))
					If (nSelecao == INCLUIR) .Or. (nRecno == (cWorkEX9)->(Recno()))
						MsgInfo("Registro já existente!", "Aviso")
						lRet := .F.
					EndIf
				EndIf
				If nSelecao <> INCLUIR
					(cWorkEX9)->(DbGoTo(nRecno))
				EndIf
			EndIf
		EndIf

	End Sequence

	If ValType(aOrd) <> "U"
		RestOrd(aOrd,.T.)
	EndIf

Return lRet

/*
Funcao      : AltSelectPallet()
Parametros  :
Retorno     :
Objetivos   : Alterar o pallet do volume posicionado.
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function AltSelectPallet()
	Local lRet
	Local nLinha := 19
	Local cPallet
	Local nOpcA
	Local bOk := {|| nOpcA := 1, oDlg:End()}
	Local bCancel  := {|| nOpcA := 0, oDlg:End()}

	Private cContainer

	Begin Sequence
		If WorkZZA->(Bof()) .Or. WorkZZA->(Eof())
			Break
		EndIf

		If Empty(M->EX9_CONTNR)
			MsgInfo("O preenchimento do numero do container é obrigatório.","Atenção")
			Break
		EndIf

		cPallet := WorkZZA->ZZA_PALLET
		nOpcA := 0

		cContainer := M->EX9_CONTNR

		Define MsDialog oDLG Title "Alteração de Pallets" From 0,0 To 150,400 Of oMainWnd Pixel // 150,455
		@ nLinha,010 Say "Container" Pixel Of oDLG
		@ nLinha,055 MsGet cContainer Picture AvSx3("EX9_CONTNR",AV_PICTURE) Valid(Empty(cContainer) .Or. VldContainer()) When .f. Size 65,08 Pixel Of oDLG
		nLinha+=15

		@ nLinha,010 Say "Pallet" Pixel Of oDLG
		/* O Pallet para a Steck é o numero de um volume. Não é um tipo de embalagem Pallet.
		@ nLinha,055 MsGet cPallet Picture AvSx3("EE5_CODEMB",AV_PICTURE) Valid(Empty(cPallet) .Or. ExistCpo("EE5",cPallet)) Size 65,08 F3("EE5") Pixel Of oDLG
		*/
		@ nLinha,055 MsGet cPallet Picture AvSx3("EE5_CODEMB",AV_PICTURE) Size 65,08 Pixel Of oDLG
		nLinha+=15

		Activate MsDialog oDLG On Init ENCHOICEBAR(oDlg,bOk,bCancel) Centered

		If nOpcA == 1
			WorkZZA->(Reclock("WorkZZA",.F.))
			WorkZZA->ZZA_PALLET := cPallet
			WorkZZA->ZZA_CONTNR := cContainer
			WorkZZA->WKSTATUS   := If(!Empty(cPallet) .And. !Empty(cContainer), "2", "0")
			workZZA->WKFLAG     := Space(2) // Fernando 26/08/13
			WorkZZA->(MsUnlock())
			oSelectZZA:oBrowse:Refresh()
		EndIf


	End Sequence

Return lRet

/*
Funcao      : AltVariosPallets()
Parametros  :
Retorno     :
Objetivos   : Alterar Pallet por volume.
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function AltVariosPallets()
	Local lRet
	Local nLinha := 19
	Local cPallet := Space(AvSx3("ZZA_PALLET",3))
	Local cVolume := Space(AvSx3("ZZA_VOLUME",3))
	Local nOpcA
	Local bOk := {|| nOpcA := 1, oDlg:End()}
	Local bCancel  := {|| nOpcA := 0, oDlg:End()}
	Local lAlterou := .F.
	Local nRegAtu := WorkZZA->(Recno())
	Private cContainer

	Begin Sequence
		If Empty(M->EX9_CONTNR)
			MsgInfo("O preenchimento do numero do container é obrigatório.","Atenção")
			Break
		EndIf

		nOpcA := 0
		cContainer := M->EX9_CONTNR

		Define MsDialog oDLG Title "Alteração de Pallets por Volume" From 0,0 To 150,455 Of oMainWnd Pixel
		@ nLinha,010 Say "Container" Pixel Of oDLG
		@ nLinha,055 MsGet cContainer Picture AvSx3("EX9_CONTNR",AV_PICTURE) Valid(Empty(cContainer) .Or. VldContainer()) When .f. Size 65,08 Pixel Of oDLG
		nLinha+=15

		@ nLinha,010 Say "Pallet" Pixel Of oDLG
		//@ nLinha,055 MsGet cPallet Picture AvSx3("EE5_CODEMB",AV_PICTURE) Valid(Empty(cPallet).Or. ExistCpo("EE5",cPallet)) Size 65,08 F3("EE5") Pixel Of oDLG
		@ nLinha,055 MsGet cPallet Picture AvSx3("EE5_CODEMB",AV_PICTURE) Size 65,08 Pixel Of oDLG
		nLinha+=15

		Activate MsDialog oDLG On Init ENCHOICEBAR(oDlg,bOk,bCancel) Centered

		If nOpcA == 1

			If MsgYesNo("Confirma a alteração dos Pallets para todos os volumes selecionados?","Atenção")
				WorkZZA->(DbGoTop())
				Do While !WorkZZA->(Eof())
					//If AvKey(cVolume,"ZZA_VOLUME") == WorkZZA->ZZA_VOLUME
					If !Empty(WorkZZA->WKFLAG)
						WorkZZA->(Reclock("WorkZZA",.F.))
						WorkZZA->ZZA_PALLET := cPallet
						WorkZZA->ZZA_CONTNR := cContainer
						WorkZZA->WKSTATUS   := If(!Empty(cPallet) .And. !Empty(cContainer), "2", "0")
						workZZA->WKFLAG     := Space(2) // Fernando 26/08/13
						WorkZZA->(MsUnlock())
					EndIf

					WorkZZA->(DbSkip())

				EndDo

			EndIf

			oSelectZZA:oBrowse:Refresh()
		EndIf

		WorkZZA->(DbGoTo(nRegAtu))

	End Sequence

Return lRet

/*
Funcao      : VldContainer()
Parametros  :
Retorno     :
Objetivos   : Validar a digitação do numero do container na tela de digitação do numero do Packing List.
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
Static Function VldContainer()
	Local lRet := .T.

	Begin Sequence
		If !Empty(cContainer) .And. cContainer <> M->EX9_CONTNR
			MsgStop("O numero do container deve ser vazio ou igual ao numero de container: '" + M->EX9_CONTNR+"'. Para desvincular o volume do container atual, limpe o conteúdo do camapo container.","Atenção")
			lRet := .F.
		EndIf
		cContainer := M->EX9_CONTNR

	End Sequence

Return lRet

/*
Funcao      : VldNrCntr()
Parametros  :
Retorno     :
Objetivos   : Validar a digitação do numero do container na tela de containers. Esta validação é acionada pelo campo EX9_CONTNR.
Autor       : Julio de Paula Paz
Data/Hora   : 02/09/2010 - 02/09/2010
Revisao     :
Obs.        :
*/
User Function VldNrCntr()
	Local lRet := .T.

	Begin Sequence
		If Type("lSteckRotContainer") == "U"
			Break
		EndIf

		If Empty(M->EX9_CONTNR)
			MsgInfo("O preenchimento do numero do container é obrigatório.","Atenção")
			lRet := .F.
			Break
		EndIf

		If lInclusao
			If TRB->(DbSeek(M->EX9_CONTNR))
				MsgInfo("Numero de Container já cadastrado!","Atenção")
				lRet := .F.
				Break
			EndIf
		Else
			TRB->(DbGoTop())
			Do While ! TRB->(Eof())
				If TRB->EX9_CONTNR == M->EX9_CONTNR .And. TRB->(Recno()) <> nReg
					MsgInfo("Numero de Container já cadastrado!","Atenção")
					lRet := .F.
					TRB->(DbGoto(nReg))
					Break
				EndIf
				TRB->(DbSkip())
			EndDo
			TRB->(DbGoto(nReg))
		EndIf

		WorkZZA->(DbClearFilter())

		If ! Empty(cNrCntr) .And. AvKey(cNrCntr,"EX9_CONTNR") <> M->EX9_CONTNR
			WorkZZA->(DbGoTop())
			Do While ! WorkZZA->(Eof())
				If AvKey(cNrCntr,"EX9_CONTNR") == WorkZZA->ZZA_CONTNR
					WorkZZA->(RecLock("WorkZZA",.F.))
					WorkZZA->ZZA_CONTNR := M->EX9_CONTNR // Space(AvSx3("ZZA_CONTNR",3))
					WorkZZA->(MsUnlock())
				EndIf
				WorkZZA->(DbSkip())
			EndDo
		EndIf

		WorkZZA->(DbSetFilter({|| ZZA_CONTNR == M->EX9_CONTNR .Or. ZZA_CONTNR == cSemContainer},"ZZA_CONTNR =='"+M->EX9_CONTNR+"' .Or. ZZA_CONTNR =='"+cSemContainer+"'"))
		WorkZZA->(DbGoTop())
		oSelectZZA:oBrowse:Refresh()

	End Sequence

Return lRet