#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "FWBROWSE.CH"
#Include "FwMvcDef.ch"
#INCLUDE "Tbiconn.ch"



//Static aPosAloc := {}  usuแrio vanessa.costa vnc@2022


//---------------------------------------------------------------------------------------------------//
//Altera็๕es Realizadas:
//---------------------------------------------------------------------------------------------------//
//FR - 27/05/2021 - Ticket #20200710004035 / #20210614010082 - Prioridade Aloca็ใo
//---------------------------------------------------------------------------------------------------//
/*
<<Altera็ใo>>
Chamado...: 20210825016836
A็ใo......: Inclusใo da coluna "Data de Emissใo do Pedido" na tela de "Gera็ใo de Ordem de Separa็ใo - Pedido de Venda"
Analista..: Marcelo Klopfer Leme - SIGAMAT
Data......: 03/11/2021

<<Altera็ใo>>
Chamado...: Sem Chamado
A็ใo......: Crorre็ใo na Func็ใo DISTRES
Analista..: Marcelo Klopfer Leme - SIGAMAT
Data......: 10/11/2021

<<<< ALTERAวรO >>>>
A็ใo.........: Corre็ใo na Query que estava chumbado a tabela para empresa 010 sendo que agora a empres a้ a 110
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 11/01/2022
Chamados.....: 20220107000504

**************************************************************************************************************************************/

User Function STFSFA10()  // visao Administrador
Private aPosAloc := {}
	U_Tela(.t.,.t.,.t.,NIL)
Return

User Function STFSFA11() // visao comercial
Private aPosAloc := {}
	U_Tela(.t.,.f.,.f.,NIL)
Return

User Function STFSFA12() // visao Produ็ใo
Private aPosAloc := {}
	U_Tela(.f.,.t.,.f.,NIL)
Return

User Function STFSFA13() // visao expedi็ใo
	Local cArmExp := "" //GetMv("FS_ARMEXP")//03
	Private aPosAloc := {}
	cArmExp := Alltrim(GetNewPar("FS_ARMEXP","03"))		//FR - 27/05/2021 - Ticket #20200710004035 / #20210614010082
	U_Tela(.t.,.f.,.t.,cArmExp)
Return

User Function STFSFA14() // visao estoque
	Local cArmEst := GetMv("FS_ARMEST")
	Private aPosAloc := {}
	U_Tela(.f.,.f.,.t.,cArmEst)
Return

User Function STFSFA15() // visao PCP;estoque
	Local cArmEst := GetMv("FS_ARMEST")
	Private aPosAloc := {}
	U_Tela(.f.,.f.,.t.,cArmEst)
Return

User Function STFSFA18() // visao expedi็ใo
	Local cArmExp := GetMv("FS_ARMEXP")
	Private aPosAloc := {}
	U_Tela(.t.,.f.,.t.,cArmExp)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Tela(lComercial,lProducao,lExpedicao,cArmSel)
User Function Tela(lComercial,lProducao,lExpedicao,cArmSel)
	Local aArea		:= GetArea()
	Local oDlg
	Local oFolder
	Local aoBrw		:={}
	Local nTop		:= 00
	Local nLeft		:= 00
	Local nBottom
	Local nRight
	Local aButtons	:= {}
	Local cArmExp	:= ""  //GetMv("FS_ARMEXP") //FR - 27/05/2021 - Ticket #20200710004035 / #20210614010082
	Local cTitOrd	:= ''
	Local aSize		:= MsAdvSize(.F.)//Giovani Zago - TOTVS 06/12/12

Local cFuraFIFO := SuperGetMV("ST_FFIFO",,"")

	PRIVATE cCB1FILTRO	:= cArmSel
	PRIVATE cOperCb7	:= cCB1FILTRO//Giovani TOTVS     11/12/12
	PRIVATE cARMFILTRO	:= cArmSel
	PRIVATE lConCom		:= IsInCallSteck("U_STFSFA18")

	PRIVATE CSTCON
	PRIVATE oBrowseCon
	Private aPosAloc := {}
	PRIVATE oTimer
	cArmExp := Alltrim(GetNewPar("FS_ARMEXP","03"))  //FR - 27/05/2021 - Ticket #20200710004035 / #20210614010082

	If ! U_STProducao()
		Return
	EndIf

	If cArmSel == NIL
		cTitOrd := "Administrador"
	Else
		If cArmExp == cArmSel
			cTitOrd := "Expedi็ใo ("+cArmSel+")"
		Else
			cTitOrd := "Estoque ("+cArmSel+")"
		EndIf
	EndIf

	oMainWnd:ReadClientCoors()
	nBottom := oMainWnd:nBottom
	nRight := oMainWnd:nRight

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	aAdd(aButtons,{"PMSSETAUP"  	,{|| U_MoveUP(oFolder,aoBrw,cArmSel)}	,"Move Documento para cima"		,"Move Doc."})
	aAdd(aButtons,{"PMSSETADOWN"	,{|| U_MoveDown(oFolder,aoBrw,cArmSel)}	,"Move Documento para baixo"	,"Move Doc."})

	If __cuserId $ cFuraFIFO
		aAdd(aButtons,{"FURAFIFO"	,{|| U_FuraFIFO()}	,"Fura FIFO"	,"Fura FIFO"})
	End If

	aAdd(aButtons,{"NOTE"			,{|| U_STFSCE12()}						,"Lote Especํfico"				,"Lote Esp."})
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	aAdd(aButtons,{"SVM"    		,{|| U_Legenda(oFolder)}				,"Legenda"						,"Legenda"})

	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	//aAdd(aButtons,{"AUTOM"    		,{|| U_ReProc90(oFolder,aoBrw,cArmSel) }	,"Reprocessa Transferencia"	,"Reproc Transf.90"})

	aAdd(aButtons,{"NOTE"			,{|| U_AUTORD()}						,"Habilita OS Automatica"				,"OrdSep Aut."})

	DEFINE MSDIALOG oDlg TITLE "Painel de Controle de Prioridade" FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd

	oFolder := TFolder():New(1,0,,,oDlg,,,,.F.,.F.,340,140,) //340
	If lComercial
		oFolder:AddItem("Comercial")
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aadd(aoBrw,U_Comercial(oFolder,oFolder:aDialogs[len(ofolder:aDialogs)]))
		oFolder:aDialogs[len(ofolder:aDialogs)]:Cargo:="SC5"
	EndIf

	If lProducao
		oFolder:AddItem("Produ็ใo")
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aadd(aoBrw,U_Producao(oFolder,oFolder:aDialogs[len(ofolder:aDialogs)]) )
		oFolder:aDialogs[len(ofolder:aDialogs)]:Cargo:="SC2"
	EndIf

	If lExpedicao
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		SetKey(VK_F12,{|| U_QtdDoc(oFolder)})

		oFolder:AddItem("Ordem de Separa็ใo - "+cTitOrd)
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aadd(aoBrw,U_Expedicao(oFolder,oFolder:aDialogs[len(ofolder:aDialogs)],cArmSel))
		oFolder:aDialogs[len(ofolder:aDialogs)]:Cargo:="CB7"

		oFolder:AddItem("Requisicao Consumo - "+cTitOrd)
		
		aadd(aoBrw,U_StCons1(oFolder,oFolder:aDialogs[len(ofolder:aDialogs)],cArmSel))//SUBTITUIDO A FUNวรO Consumo por U_StCons1 que se encontra no fonte acdsa01 - Eduardo Matias 05/02/2019  //VOLTAR
		oFolder:aDialogs[len(ofolder:aDialogs)]:Cargo:="SCP"  //VOLTAR

	EndIf

	DEFINE TIMER oTimer INTERVAL 1000 ACTION U_AtuTela(oFolder,aoBrw,oTimer) OF oDlg   
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oFolder :Align := CONTROL_ALIGN_ALLCLIENT
	oFolder :SetOption(1)
	oDlg:lEscClose:= .f.
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg, {|| oDlg:End()  },{|| oDlg:End()},,aButtons ),U_AtuTela(oFolder,aoBrw,oTimer),oTimer:Activate())
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	If lExpedicao
		SetKey(VK_F12,NIL)
	EndIf
	CB7->(DbClearFilter())
	SC5->(DbClearFilter())
	SC2->(DbClearFilter())
	RestArea(aArea)
Return

//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
USER FUNCTION ReProc90(oFolder,aoBrw,cArmSel) 
Local cCargo 	:= U_RetPosTab(oFolder)
Local nRecno	:= 0
Local cOS       := ""
Local cPedido   := ""
Local cOP       := ""
Local cxOPER    := ""
Local lVai      := .T.  //indica que poderแ fazer a transf para o armaz้m 90
Local lTela     := .T.

If  cCargo =='CB7'
	nRecno	:= CB7->(Recno())
	CB7->(DbSeek(xFilial('CB7')+'0',.T.))
	CB7->(DbGoto(nRecno))
	cOS     := CB7->CB7_ORDSEP
	cPedido := CB7->CB7_PEDIDO 
	cOP     := CB7->CB7_OP 
	cxOPER  := CB7->CB7_CODOPE //operador estoque

	CB8->(OrdSetFocus(1))
	If CB8->(Dbseek(xFilial("CB8") + cOS ))
		While CB8->(!EOF()) .AND. CB8->CB8_ORDSEP == cOS
			//-----------------------------------------------------//
			//condi็ใo para fazer a transf do 01 para o 90:  
			//armaz้m na CB8 estar = 01
			//saldo de separa็ใo estar = zero
			//-----------------------------------------------------//
			If CB8->CB8_LOCAL <> "01"  //se encontrar algum registro com armaz้m diferente de 01, lVai fica FALSO
				lVai := .F.
			Endif 

			If CB8->CB8_SALDOS > 0    //se encontrar algum registro que nใo foi feita separa็ใo, lVai fica FALSO
				lVai := .F.
			Endif 
			CB8->(Dbskip())
		Enddo 
	Endif 

	If lVai 
		U_STTranArm(cPedido,cOP,cxOPER,lTela)
	Else 
		Alert("Reprocessar Transfer๊ncia Nใo Poderแ Continuar, Possํveis Motivos: " + CRLF + CRLF +;
		"Armaz้m Diferente de 01, ou; " + CRLF +;
		"Saldo Separa็ใo > 0 ")
	Endif 

	//        STTranArm(cPedido   ,cOP   ,cxOPER    ,lTela)
	//CB7->(U_STTranArm(CB7_PEDIDO,CB7_OP,CB7_CODOPE     ))
Endif 


RETURN

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function AtuTela(oFolder,aoBrw,oTimer)
User Function AtuTela(oFolder,aoBrw,oTimer)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local nRecno	:= 0
	oTimer:Deactivate()
	If cCargo =='SC5'
		nRecno	:= SC5->(Recno())
		SC5->(DbSeek(xFilial('SC5')+'0',.T.))
		SC5->(DbGoto(nRecno))
	ElseIf  cCargo =='SC2'
		nRecno	:= SC2->(Recno())
		SC2->(DbSeek(xFilial('SC2')+'0',.T.))
		SC2->(DbGoto(nRecno))
	ElseIf  cCargo =='CB7'
		nRecno	:= CB7->(Recno())
		CB7->(DbSeek(xFilial('CB7')+'0',.T.))
		CB7->(DbGoto(nRecno))

	EndIf

	aoBrw[oFolder:nOption]:Refresh()
	Eval(aoBrw[oFolder:nOption]:bChange)

	oTimer:Activate()
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function RetPosTab(oFolder)
User Function RetPosTab(oFolder)
Return oFolder:aDialogs[oFolder:nOption]:Cargo

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Legenda(oFolder)
User Function Legenda(oFolder)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local cTitulo 	:= ''
	Local aLegenda	:={}
	If cCargo =='SC5' .or. cCargo =='SC2' // Tela Comercial ou producao
		cTitulo 		:= 'Status - Controle de Reserva'
		aLegenda		:= {	{"BR_VERDE"		,	"Atendido"			},;
		{"BR_VERMELHO"	,	"Nใo Atendido"		},;
		{"BR_AMARELO"	,	"Depend๊cia Deposito Fechado"	},;
		{"BR_AZUL"		,	"Parcial"			}}
	Elseif cCargo =='CB7' // Tela Expedicao
		cTitulo 	:= 'Status - Ordem de Separa็ใo'
		aLegenda := {	{ "DISABLE"		,	"Diverg๊ncia" 	},;
		{ "BR_CINZA"	,	"Pausa" 			},;
		{ "ENABLE"		,	"Finalizado" 	},;
		{ "BR_AZUL"		, 	"Nao iniciado" },;
		{ "BR_AMARELO"	,	"Em andamento:"},;
		{ "CONIMG16"	, 	"   Separa็ใo" },;
		{ "PMSEXPALL"	, 	"   Ag.Embalagem"},;
		{ "WMSIMG16"	, 	"   Embalagem" },;
		{ "TMSIMG16"	, 	"   Embarque" }}

	EndIf
	BrwLegenda(" Legenda ",cTitulo, aLegenda)

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MoveUP(oFolder,aoBrw,cArmExp)
User Function MoveUP(oFolder,aoBrw,cArmExp)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local aArea 	:= GetArea()
	Local aAreaX
	Local cPriori1
	Local cPriori2
	Local nAtuRec
	Local lAdm		:= Empty(cArmExp)
	Local cCodOpe

	If cCargo =='SC5' // Tela Comercial
		aAreaX	:= SC5->(GetArea())
		cCampo	:= "C5_XPRIORI"
		cPriori1	:= SC5->(FieldGet(FieldPos(cCampo)))
		nAtuRec 	:= SC5->(Recno())
		SC5->(DbSkip(-1))
		If SC5->(Bof() .or. Empty(FieldGet(FieldPos(cCampo))))
			SC5->(DbGoto(nAtuRec))
		Else
			cPriori2	:= SC5->(FieldGet(FieldPos(cCampo)))
			If Left(cPriori1,1) == Left(cPriori2,1)
				SC5->(Reclock('SC5',.f.))
				SC5->(FieldPut(FieldPos(cCampo),cPriori1))
				SC5->(MsUnlock())
			Else
				SC5->(Reclock('SC5',.f.))
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				SC5->(FieldPut(FieldPos(cCampo),U_AdSub(cPriori2,"+")))
				SC5->(MsUnlock())
			EndIf
			SC5->(DbGoto(nAtuRec))
			SC5->(Reclock('SC5',.f.))
			SC5->(FieldPut(FieldPos(cCampo),cPriori2))
			SC5->(MsUnlock())
		EndIf
	ElseIf cCargo =='SC2' // Tela Producao
		aAreaX	:= SC2->(GetArea())
		cCampo	:= "C2_XPRIORI"
		cPriori1	:= SC2->(FieldGet(FieldPos(cCampo)))
		nAtuRec 	:= SC2->(Recno())
		SC2->(DbSkip(-1))
		If SC2->(Bof() .or. Empty(FieldGet(FieldPos(cCampo))))
			SC2->(DbGoto(nAtuRec))
		Else
			cPriori2	:= SC2->(FieldGet(FieldPos(cCampo)))
			If Left(cPriori1,1) == Left(cPriori2,1)
				SC2->(Reclock('SC2',.f.))
				SC2->(FieldPut(FieldPos(cCampo),cPriori1))
				SC2->(MsUnlock())
			Else
				SC2->(Reclock('SC2',.f.))
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				SC2->(FieldPut(FieldPos(cCampo),U_AdSub(cPriori2,"+")))
				SC2->(MsUnlock())
			EndIf
			SC2->(DbGoto(nAtuRec))
			SC2->(Reclock('SC2',.f.))
			SC2->(FieldPut(FieldPos(cCampo),cPriori2))
			SC2->(MsUnlock())
		EndIf
	Elseif cCargo =='CB7' // Tela Expedicao
		aAreaX	:= CB7->(GetArea())
		If !lConCom
			cCampo	:= "CB7_XPRIOR"
			cPriori1	:= CB7->(FieldGet(FieldPos(cCampo)))
			cCodOpe	:= CB7->CB7_CODOPE

			nAtuRec 	:= CB7->(Recno())
			CB7->(DbSkip(-1))
			If CB7->(Bof() .OR. cCodOpe <> CB7_CODOPE .OR. CB7_XSEP =='1' )
				CB7->(DbGoto(nAtuRec))
			Else
				If ! lAdm .and. CB7->CB7_LOCAL <> cArmExp
					CB7->(DbGoto(nAtuRec))
				Else
					cPriori2	:= CB7->(FieldGet(FieldPos(cCampo)))
					If Left(cPriori1,8) == Left(cPriori2,8)
						CB7->(Reclock('CB7',.f.))
						CB7->(FieldPut(FieldPos(cCampo),cPriori1))
						CB7->(MsUnlock())
					Else
						CB7->(Reclock('CB7',.f.))
						//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
						CB7->(FieldPut(FieldPos(cCampo),U_AdSub(AllTrim(cPriori2),"+")))
						CB7->(MsUnlock())
					EndIf
					CB7->(DbGoto(nAtuRec))
					CB7->(Reclock('CB7',.f.))
					CB7->(FieldPut(FieldPos(cCampo),cPriori2))
					CB7->(MsUnlock())
				EndIf
			EndIf
		Endif
	EndIf
	aoBrw[oFolder:nOption]:Refresh()
	RestArea(aAreaX)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MoveDown(oFolder,aoBrw,cArmExp)
User Function MoveDown(oFolder, aoBrw, cArmExp)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local aArea 	:= GetArea()
	Local aAreaX
	Local cPriori1
	Local cPriori2
	Local nAtuRec
	Local lAdm		:= Empty(cArmExp)
	Local cCodOpe

	If cCargo =='SC5' // Tela Comercial
		aAreaX	:= SC5->(GetArea())
		cCampo	:= "C5_XPRIORI"
		cPriori1	:= SC5->(FieldGet(FieldPos(cCampo)))
		nAtuRec 	:= SC5->(Recno())
		SC5->(DbSkip())
		If SC5->(Eof() .or. Empty(FieldGet(FieldPos(cCampo))))
			SC5->(DbGoto(nAtuRec))
		Else
			cPriori2	:= SC5->(FieldGet(FieldPos(cCampo)))
			If Left(cPriori1,1) == Left(cPriori2,1)
				SC5->(Reclock('SC5',.f.))
				SC5->(FieldPut(FieldPos(cCampo),cPriori1))
				SC5->(MsUnlock())
			Else
				SC5->(Reclock('SC5',.f.))
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				SC5->(FieldPut(FieldPos(cCampo),U_AdSub(cPriori2,"-")))
				SC5->(MsUnlock())
			EndIf
			SC5->(DbGoto(nAtuRec))
			SC5->(Reclock('SC5',.f.))
			SC5->(FieldPut(FieldPos(cCampo),cPriori2))
			SC5->(MsUnlock())
		EndIf
	ElseIf cCargo =='SC2' // Tela Producao
		aAreaX	:= SC2->(GetArea())
		cCampo	:= "C2_XPRIORI"
		cPriori1	:= SC2->(FieldGet(FieldPos(cCampo)))
		nAtuRec 	:= SC2->(Recno())
		SC2->(DbSkip())
		If SC2->(Eof() .or. Empty(FieldGet(FieldPos(cCampo))))
			SC2->(DbGoto(nAtuRec))
		Else
			cPriori2	:= SC2->(FieldGet(FieldPos(cCampo)))
			If Left(cPriori1,1) == Left(cPriori2,1)
				SC2->(Reclock('SC2',.f.))
				SC2->(FieldPut(FieldPos(cCampo),cPriori1))
				SC2->(MsUnlock())
			Else
				SC2->(Reclock('SC2',.f.))
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				SC2->(FieldPut(FieldPos(cCampo),U_AdSub(cPriori2,"-")))
				SC2->(MsUnlock())
			EndIf
			SC2->(DbGoto(nAtuRec))
			SC2->(Reclock('SC2',.f.))
			SC2->(FieldPut(FieldPos(cCampo),cPriori2))
			SC2->(MsUnlock())
		EndIf
	Elseif cCargo =='CB7' // Tela Expedicao
		aAreaX	:= CB7->(GetArea())
		If !lConCom
			cCampo	:= "CB7_XPRIOR"
			cPriori1	:= CB7->(FieldGet(FieldPos(cCampo)))
			nAtuRec 	:= CB7->(Recno())
			cCodOpe	:= CB7->CB7_CODOPE
			CB7->(DbSkip())
			If CB7->(Eof() .OR. cCodOpe <> CB7_CODOPE .OR. CB7_XSEP =='1' )
				CB7->(DbGoto(nAtuRec))
			Else
				If ! lAdm .and. CB7->CB7_LOCAL <> cArmExp
					CB7->(DbGoto(nAtuRec))
				Else
					cPriori2	:= CB7->(FieldGet(FieldPos(cCampo)))
					If Left(cPriori1,8) == Left(cPriori2,8)
						CB7->(Reclock('CB7',.f.))
						CB7->(FieldPut(FieldPos(cCampo),cPriori1))
						CB7->(MsUnlock())
					Else
						CB7->(Reclock('CB7',.f.))
						//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
						CB7->(FieldPut(FieldPos(cCampo),U_AdSub(Alltrim(cPriori2),"-")))
						CB7->(MsUnlock())
					EndIf
					CB7->(DbGoto(nAtuRec))
					CB7->(Reclock('CB7',.f.))
					CB7->(FieldPut(FieldPos(cCampo),cPriori2))
					CB7->(MsUnlock())
				EndIf
			EndIf
		Endif
	EndIf
	aoBrw[oFolder:nOption]:Refresh()
	RestArea(aAreaX)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function AdSub(cVar,cOper)
User Function AdSub(cVar, cOper)
	Local nLen := Len(cVar)
	Local nVar := Val(cVar)
	If cOper == "+"
		nVar++
	Else
		nVar--
	EndIf
Return Str(nVar,nLen)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Comercial(oFolder,oDlg)
User Function Comercial(oFolder, oDlg)
	//Local aBrowse	:= {"C5_NUM","C5_CLIENTE","C5_LOJACLI","C5_XTIPO","C5_XTIPF","C5_XPRIORI","C5_EMISSAO","C5_XDTEN"}// Chamado 007655 - Everson Santana - 22/08/18
	Local aBrowse	:= {"C5_NUM","C5_CLIENTE","C5_LOJACLI","NOME","C5_XTIPO","C5_XTIPF","C5_EMISSAO","C5_XDTEN"}
	Local aCab2		:= {"1","2","3","Item","Produto","Descricao","U.M.","Armaz้m","Quantidade","Reserva (1)","Reserva DF (2)","Falta (3)",""}
	Local aItens2  	:= {}
	Local oLbx

	Local oCol
	Local oBrowse
	Local i

	Local cCpoFil	:= "SC5->(C5_FILIAL+C5_XPRIORI)"
	Local cTopFun	:= xFilial('SC5')+'0'
	Local cBotFun	:= xFilial('SC5')+'ZZZZZZZZZZZZZZZZZZZZ'

	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4

	Local oPedido
	Local cPedido 	:= Space(6)
	Local oStatus
	Local cStatusPed:= "Todos"
	Local oEmisIni
	Local dEmisIni	:= dDataBase
	Local oEmisFim
	Local dEmisFim	:= dDataBase
	Local oIndexOrd
	Local cIndexOrd	:= "Pedido"
	Local oSplit
	Local aLegenda	:= {	LoadBitmap( GetResources(), "BR_PRETO" 	),;
	LoadBitmap( GetResources(), "BR_VERDE" 	),;
	LoadBitmap( GetResources(), "BR_VERMELHO"	),;
	LoadBitmap( GetResources(), "BR_AMARELO"	),;
	LoadBitmap( GetResources(), "BR_AZUL"		)}

	Local aTipoEntrega 	:= RetSx3Box(Posicione('SX3', 2, 'C5_XTIPO', 'X3CBox()' ),,, 1 )// {{"1=Retira"},{"2=Entrega"}} //RetSx3Box(Posicione("SX3",2,"C5_XTIPO","X3_CBOX"),,,14)
	Local aTipoFatura 	:= RetSx3Box(Posicione('SX3', 2, 'C5_XTIPF', 'X3CBox()' ),,, 1 )  //RetSx3Box(Posicione("SX3",2,"C5_XTIPF","X3_CBOX"),,,14)
	// RetSx3Box(Posicione('SX3', 2, 'C5_XTIPF', 'X3CBox()' ),,, 1 )
	Local nX
	Local aBtnLat
	Local nAux
	Local _cUseLib := GetMv("ST_FSFA40",,"000000")

	If !IsInCallStack("U_STFSFA13")
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aBtnLat :={			{"BMPVISUAL"    	,{|| U_ViewSC5() }	,"Visualiza Pedido"				,},;
		{"SDURECALL"    	,{|| U_TransRes(oFolder)}				,"Transfere Reserva"			,},;
		{"SELECTALL"  	 	,{|| U_DistRes(aItens2,oLbx)}			,"Distribui Reserva"			,Iif(IsInCallStack("U_STFSFA11"),.F.,.T.)},;
		{"SDUGOTO"   	 	,{|| U_MataRes(oFolder,aItens2,oLbx)}	,"Elimina Reserva Item"			,Iif(__cUserId $ _cUseLib,.T.,.F.)},;
		{"SDUIMPORT"   	 	,{|| U_MatResPV(aItens2)}	            ,"Elimina Reserva Pedido"		,Iif(__cUserId $ _cUseLib,.T.,.F.)},;
		{"OK"   	 		,{|| U_OSAUTO(aItens2)}		            ,"OS Automatico"		,Iif(__cUserId $ _cUseLib,.T.,.F.)},;
		{"PREDIO"    		,{|| U_STFSFA17(1)}						,"Pend๊ncia Deposito Fechado"	,Iif(IsInCallStack("U_STFSFA11"),.F.,.T.)},;
		{"SDUORDER"   	 	,{|| U_AltSC5(oFolder)}					,"Altera Cabe็alho Pedido"		,}}
	Else
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aBtnLat :={			{"BMPVISUAL"    	,{|| U_ViewSC5() }	,"Visualiza Pedido"				,},;
		{"SELECTALL"  	 	,{|| U_DistRes(aItens2,oLbx)}			,"Distribui Reserva"			,},;
		{"SDUORDER"   	 	,{|| U_AltSC5(oFolder)}					,"Altera Cabe็alho Pedido"		,}}
	Endif

	@00,00 MSPANEL oPanel1 PROMPT "" SIZE 20,20 of oDlg
	oPanel1:Align := CONTROL_ALIGN_LEFT

	nAux:= 0
	For nX := 1 To Len(aBtnLat)
		&("__oBnt"+StrZero(nX,2)):= TBtnBmp2():New(nAux,0,40,40 ,aBtnLat[nX,1], NIL, NIL,NIL,aBtnLat[nX,2], oPanel1, aBtnLat[nX,3], NIL, NIL,NIL )
		&("__oBnt"+StrZero(nX,2)):lActive := Iif(aBtnLat[nX,4] == Nil,.T.,aBtnLat[nX,4])
		nAux +=42
	Next

	@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
	oPanel4:Align := CONTROL_ALIGN_TOP

	@ 06,022 Say "Pedido" PIXEL of oPanel4
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 04,050 MsGet oPedido Var cPedido Picture "!!!!!!" PIXEL of oPanel4 SIZE 40,09 F3 "SC5" Valid U_PesqSC5(@cPedido,oBrowse)

	@ 06,140 Say "Filtrar Status" PIXEL of oPanel4
	@ 04,180 ComboBox oStatus VAR cStatusPed ITEMS {"Atendido","Nao Atendido","Dependencia Deposito Fechado","Parcial","Todos"} Of oPanel4 PIXEL SIZE 85,10
	//oStatus:bChange := {|| StsFilCom(oStatus,oBrowse,oLbx,aItens2) }

	@ 06,275 Say "Emissao de" PIXEL of oPanel4
	@ 04,305 MsGet oEmisIni Var dEmisIni Picture "@D" PIXEL of oPanel4 SIZE 50,09

	@ 06,370 Say "Emissao ate" PIXEL of oPanel4
	@ 04,400 MsGet oEmisFim Var dEmisFim Picture "@D" PIXEL of oPanel4 SIZE 50,09

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 4,470  BUTTON "Confimar"	 SIZE 55,11 ACTION (U_StsFilCom(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2)) OF oPanel4 PIXEL

	@ 06,565 Say "Ordem" PIXEL of oPanel4
	@ 04,590 ComboBox oIndexOrd VAR cIndexOrd ITEMS {"Pedido","Prioridade"} Of oPanel4 PIXEL SIZE 55,10
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oIndexOrd:bChange := {|| U_IndOrdCom(oIndexOrd,oBrowse,oLbx,aItens2) }

	@00,00 MSPANEL oPanel2 PROMPT "" SIZE 20,20 of oDlg
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

	oBrowse := VCBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,/*bLDblClick*/,,,,,,,, .F.,"SC5", .T.,, .F., ,)
	oBrowse := oBrowse:GetBrowse()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oBrowse:bChange := {|| oBrowse :Refresh(),U_MontaSC6(oLbx,aItens2)  }
	oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oCol := TCColumn():New( " ",{|| aLegenda[val(SC5->C5_XSTARES)+1] },,,, "LEFT", 8, .T., .F.,,,, .T., )
	oBrowse:AddColumn(oCol)

	For i:=1 To Len(aBrowse)
		If aBrowse[i] == "C5_XTIPO"
			oCol := TCColumn()	:New( Alltrim(RetTitle(aBrowse[i])),{|| If(Empty(SC5->C5_XTIPO),aTipoEntrega[1,3],aTipoEntrega[val(SC5->C5_XTIPO),3]) },,,, "LEFT",, .F., .F.,,,, .F., )
		ElseIf aBrowse[i] == "C5_XTIPF"
			oCol := TCColumn()	:New( Alltrim(RetTitle(aBrowse[i])),{|| If(Empty(SC5->C5_XTIPF),aTipoFatura	[1,3],aTipoFatura[val(SC5->C5_XTIPF),3]) },,,, "LEFT",, .F., .F.,,,, .F., )
		ElseIf aBrowse[i] == "NOME"//Ticket 20191216000008 - Everson Santana - 17.12.2019
			oCol := TCColumn()	:New( Alltrim("Nome"),&("{|| Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME') }"),,,, "LEFT",, .F., .F.,,,, .F., )
		Else
			oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || SC5->"+aBrowse[i]+"}"),,,, "LEFT",, .F., .F.,,,, .F., )
		EndIf
		oBrowse:AddColumn(oCol)
	Next i

	SC5->(DbOrderNickName("STFSSC501"))
	SC5->(DbSeek(xFilial('SC5')+'0',.T.))
	oBrowse :Refresh()

	@00,00 MSPANEL oPanel3 PROMPT "" SIZE 140,140 of oPanel2
	oPanel3:Align := CONTROL_ALIGN_BOTTOM

	oLbx := TWBrowse():New(10,10,230,95,,aCab2,,oPanel3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaSC6(oLbx,aItens2)
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:blDBlClick := {|| U_STFSVE50(aItens2[oLbx:nAt,5],,aItens2[oLbx:nAt,8])}

	@ 000,000 BUTTON oSplit PROMPT "*" SIZE 5,5 OF oPanel2 PIXEL
	oSplit:cToolTip := "Habilita e desabilita os itens."
	oSplit:bLClicked := {|| oPanel3:lVisibleControl 	:= !oPanel3:lVisibleControl}
	oSplit:Align := CONTROL_ALIGN_BOTTOM

Return oBrowse

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function StsFilCom(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2)
User Function StsFilCom(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2)

	Local _cFitro := ""
	
	Dbselectarea("SC5")
	If oStatus:nAt <> 5
		//_cFitro += "C5_XSTARES = '"+AllTrim(Str(oStatus:nAt))+"'"
		DbClearFilter()
		SET FILTER TO (C5_XSTARES = AllTrim(Str(oStatus:nAt)) .And. C5_EMISSAO >= dEmisIni .And. C5_EMISSAO <= dEmisFim)
	Else
		DbClearFilter()
		SET FILTER TO (C5_EMISSAO >= dEmisIni .And. C5_EMISSAO <= dEmisFim)
	EndIf

	DbGotop()
	DbSeek(xFilial("SC5"))

	oBrowse:nAt:=1
	oBrowse:SetFocus()
	Eval(oBrowse:bGoTop)
	oBrowse:REFRESH()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaSC6(oLbx,aItens2)

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function IndOrdCom(oIndexOrd,oBrowse,oLbx,aItens2)
User Function IndOrdCom(oIndexOrd,oBrowse,oLbx,aItens2)

	If oIndexOrd:nAt == 1
		SC5->(DbSetOrder(1))
	Else
		SC5->(DbSetOrder(5))
	EndIf

	oBrowse:nAt:=1
	oBrowse:SetFocus()
	oBrowse:REFRESH()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaSC6(oLbx,aItens2)

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MontaSC6(oLbx,aItens2)
User Function MontaSC6(oLbx,aItens2)
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
	Local cPicture	:= PesqPict("SC6","C6_QTDVEN")
	Local nSaldoSC6	:= 0

	aItens2:={}
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
	While SC6->(! Eof() .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM)

		If AllTrim(SC6->C6_BLQ) == "R"             //os duplicada 150413 abre
			SC6->(DbSkip())
			LOOP
		EndIf

		nSaldoSC6 := U_STSLDSC6(SC6->(RECNO()))
		If nSaldoSC6 <= 0
			SC6->(DbSkip())
			LOOP
		EndIf                                  	   //os duplicada 150413 fecha

		If GetMv("ST_CB8LERO",,.F.) .And. cfilant = '02' .And. cEmpAnt = '01'
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			If (SC5->C5_CLIENTE $ '038134/023789') .And. U_STCB8PROD(SC5->C5_NUM,SC6->C6_PRODUTO)   // Valdemir Rabelo Ticket: 20210803014605 - Adicionado ConstruDecor
				SC6->(DbSkip())
				LOOP
			EndIf
		EndIf

		nRes	:=SC6->(U_STGetRes(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,cFilAnt))
		nResDF	:=SC6->(U_STGetRes(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,cFilDP))
		nFalta	:=SC6->(U_STGetFal(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO))
		aCores	:= {If(!Empty(nRes),oVerde,oPreto),If(!Empty(nResDF),oAmarelo,oPreto),If(!Empty(nFalta),oVermelho,oPreto)}
		SC6->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],C6_ITEM,C6_PRODUTO,Posicione("SB1",1,xFilial('SB1')+C6_PRODUTO,"B1_DESC"),C6_UM,C6_LOCAL,Transform(nSaldoSC6,cPicture),Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture)," ",Recno()}))
		SC6->(DbSkip())
	End

	If Empty(aItens2)
		SC6->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],"","","","","","","","",""," ",0}))
	EndIf
	If oLbx<>NIL
		oLbx:SetArray( aItens2 )
		oLbx:bLine := {|| aEval(aItens2[oLbx:nAt],{|z,w| aItens2[oLbx:nAt,w] } ) }
		oLbx:Refresh()
	EndIf
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function PesqSC5(cPedido,oBrowse)
User Function PesqSC5(cPedido,oBrowse)
	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())
	Local nRecno

	If Empty(cPedido)
		Return .t.
	EndIf

	SC5->(DbSetOrder(1))
	If ! SC5->(DbSeek(xFilial('SC5')+cPedido))
		MsgAlert('Pedido nใo encontrado!!!',"Aten็ใo")
		cPedido:= Space(6)
		RestArea(aAreaSC5)
		RestArea(aArea)
		Return .t.
	EndIf

	nRecno:= SC5->(Recno())
	cPedido:= Space(6)
	RestArea(aAreaSC5)
	RestArea(aArea)
	SC5->(DbGoto(nRecno))
	oBrowse:Refresh()
	Eval(oBrowse:bChange)

Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function ViewSC5()
User Function ViewSC5()
	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())

	Private aRotina := {	{"Pesquisa","AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
	{ "Visual","A410Visual"	,0,2,0 ,NIL}}

	a410Visual('SC5',SC5->(Recno()),2)

	RestArea(aAreaSC5)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Producao(oFolder,oDlg)
User Function Producao(oFolder,oDlg)
	Local aBrowse	:= {"C2_NUM","C2_ITEM","C2_SEQUEN","C2_PRODUTO","C2_UM","C2_LOCAL","C2_XPRIORI","C2_PEDIDO","C2_XLOTE","C2_EMISSAO","C2_DATPRF"}
	Local aCab2		:= {"1","2","3","Armazem","Produto","Descricao","Quantidade","Reserva (1)","Reserva DF (2)","Falta (3)","Separa็ใo",""}
	Local aItens2  := {}
	Local oLbx

	Local oCol
	Local oBrowse
	Local i

	Local cCpoFil := "SC2->(C2_FILIAL+C2_XPRIORI)"
	Local cTopFun := xFilial('SC2')+'0'
	Local cBotFun := xFilial('SC2')+'ZZZZZZZZZZZZZZZZZZZZ'
	Local cArmEst := GetMv("FS_ARMEST")

	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4

	Local oOP
	Local cOP := Space(13)
	Local oStatus
	Local cStatusPed:= "Todos"
	Local oEmisIni
	Local dEmisIni	:= dDataBase
	Local oEmisFim
	Local dEmisFim	:= dDataBase
	Local oSplit
	
	Local aLegenda	:= {;
	LoadBitmap( GetResources(), "BR_PRETO" 		),;
	LoadBitmap( GetResources(), "BR_VERDE" 		),;
	LoadBitmap( GetResources(), "BR_VERMELHO"	),;
	LoadBitmap( GetResources(), "BR_AMARELO"	),;
	LoadBitmap( GetResources(), "BR_AZUL"		)}
	Local nX
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local aBtnLat :={;
	{"BMPVISUAL"    	,{|| U_ViewSC2()		}				,"Visualiza Ordem de Produ็ใo"	},; 
	{"SDURECALL"    	,{|| U_TransRes(oFolder)}				,"Transfere Reserva"			},;
	{"SELECTALL"  	 	,{|| U_DistRes(aItens2,oLbx)}		  	,"Distribui Reserva"			},;
	{"SDUGOTO"   	 	,{|| U_MataRes(oFolder,aItens2,oLbx)}	,"Elimina Reserva"				},;
	{"PREDIO"    		,{|| U_STFSFA17(2)}						,"Pend๊ncia Deposito Fechado"	},;
	{"DEVOLNF"    		,{|| U_DeleCB7(cArmEst)}				,"Estorna Ordem de Separa็ใo"	},;
	{"OK" 			   	,{|| U_GeraCB7Sel(cArmEst,oFolder)}		,"Gera Ordem de Separa็ใo Selecionada"	}}

	//{"BMPINCLUIR"  		,{|| GeraCB7(cArmEst)}			   		,"Gera Ordem de Separa็ใo"		},;
	Local nAux
	
	// FMT - CONSULTORIA
	Local oDestino 
	Local cDestino := "  "

	@00,00 MSPANEL oPanel1 PROMPT "" SIZE 20,20 of oDlg
	oPanel1:Align := CONTROL_ALIGN_LEFT

	nAux:= 0
	For nX := 1 To Len(aBtnLat)
		TBtnBmp2():New(nAux,0,40,40 ,aBtnLat[nX,1], NIL, NIL,NIL,aBtnLat[nX,2], oPanel1, aBtnLat[nX,3], NIL, NIL,NIL )
		nAux +=42
	Next

	@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
	oPanel4:Align := CONTROL_ALIGN_TOP

	@ 06,22 Say "Ordem de Produ็ใo" PIXEL of oPanel4
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 04,80 MsGet oOP Var cOP Picture "!!!!!!!!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "SC2" Valid U_PesqSC2(@cOP,oBrowse)

	@ 06,140 Say "Filtrar Status" PIXEL of oPanel4
	@ 04,180 ComboBox oStatus VAR cStatusPed ITEMS {"Atendido","Nao Atendido","Dependencia Deposito Fechado","Parcial","Todos","Destino"} Of oPanel4 PIXEL SIZE 85,10
	//oStatus:bChange := {|| StsFilPcp(oStatus,oBrowse,oLbx,aItens2) }

	@ 06,275 Say "Emissao de" PIXEL of oPanel4
	@ 04,305 MsGet oEmisIni Var dEmisIni Picture "@D" PIXEL of oPanel4 SIZE 50,09

	@ 06,360 Say "Emissao ate" PIXEL of oPanel4
	@ 04,390 MsGet oEmisFim Var dEmisFim Picture "@D" PIXEL of oPanel4 SIZE 50,09

	// FMT - CONSULTORIA
	@ 06,443 Say "Destino " PIXEL of oPanel4
	@ 04,465 MsGet oDestino Var cDestino Picture "!!" PIXEL of oPanel4 SIZE 30,09 F3 "NNR"

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 4,500  BUTTON "Confimar"	 SIZE 55,11 ACTION (U_StsFilPcp(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2,cDestino)) OF oPanel4 PIXEL

	@00,00 MSPANEL oPanel2 PROMPT "" SIZE 20,20 of oDlg
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

	oBrowse := VCBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,,{|| U_STFSVE50(SC2->C2_PRODUTO)},,,,,,, .F.,"SC2", .T.,, .F., ,)
	oBrowse := oBrowse:GetBrowse()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oBrowse:bChange := {|| oBrowse :Refresh(),U_MontaSD4(oLbx,aItens2)  }
	oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oCol := TCColumn():New( " ",{|| aLegenda[val(SC2->C2_XSTARES)+1] },,,, "LEFT", 8, .T., .F.,,,, .T., )
	oBrowse:AddColumn(oCol)

	For i:=1 To Len(aBrowse)
		oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || SC2->"+aBrowse[i]+"}"),,,, "LEFT",, .F., .F.,,,, .F., )
		oBrowse:AddColumn(oCol)
	Next i

	SC2->(DbOrderNickName("STFSSC201"))
	SC2->(DbSeek(xFilial('SC2')+'0',.T.))
	oBrowse :Refresh()

	@00,00 MSPANEL oPanel3 PROMPT "" SIZE 140,140 of oPanel2
	oPanel3:Align := CONTROL_ALIGN_BOTTOM

	oLbx := TWBrowse():New(10,10,230,95,,aCab2,,oPanel3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaSD4(oLbx,aItens2)
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:blDBlClick := {|| U_STFSVE50(aItens2[oLbx:nAt,5])}

	@ 000,000 BUTTON oSplit PROMPT "*" SIZE 5,5 OF oPanel2 PIXEL
	oSplit:cToolTip := "Habilita e desabilita os itens."
	oSplit:bLClicked := {|| oPanel3:lVisibleControl 	:= !oPanel3:lVisibleControl}
	oSplit:Align := CONTROL_ALIGN_BOTTOM

Return oBrowse

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function StsFilPcp(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2,cDestino)
User Function StsFilPcp(oStatus,oBrowse,dEmisIni,dEmisFim,oLbx,aItens2,cDestino)

	Local _cFitro := ""
	
	Dbselectarea("SC2")
	// FMT - CONSULTORIA
	If oStatus:nAt == 6
		DbClearFilter()
		iF Empty(cDestino)
			SET FILTER TO C2_LOCAL # cDestino .and. (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
		Else	
			SET FILTER TO C2_LOCAL == cDestino .and. (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
		Endif	
	ElseIf oStatus:nAt == 4 // Parcial
		DbClearFilter()
		SET FILTER TO C2_QUANT > C2_QUJE .AND. EMPTY(C2_DATRF) .and. (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
	ElseIf oStatus:nAt == 1 // Atendidas
		DbClearFilter()
		SET FILTER TO !EMPTY(C2_DATRF) .and. (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
	ElseIf oStatus:nAt == 2 // Nใo Atendidas
		DbClearFilter()
		SET FILTER TO EMPTY(C2_DATRF) .AND. C2_QUJE==0 .and. (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
	Else
		If oStatus:nAt <> 5
			//_cFitro += "C2_XSTARES = '"+AllTrim(Str(oStatus:nAt))+"'"
			DbClearFilter()
			SET FILTER TO (C2_XSTARES = AllTrim(Str(oStatus:nAt)) .And. C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
		Else
			DbClearFilter()
			SET FILTER TO (C2_EMISSAO >= dEmisIni .And. C2_EMISSAO <= dEmisFim)
		EndIf
	Endif

	DbGotop()
	DbSeek(xFilial("SC2"))

	oBrowse:nAt:=1
	Eval(oBrowse:bGoTop)
	oBrowse:REFRESH()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaSD4(oLbx,aItens2)

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MontaSD4(oLbx,aItens2)
User Function MontaSD4(oLbx,aItens2)
	Local cStatus  := 1
	Local nFalta	:= 0
	Local nRes		:= 0
	Local nResDF	:= 0
	Local nSDC		:= 0
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local oPreto	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oAmarelo := LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local aCores   := {oPreto,oPreto,oPreto}
	Local cPicture	:= PesqPict("SD4","D4_QTDEORI")
	Local nPos		:= 0

	aItens2:={}
	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
	While SD4->(! Eof() .and. Alltrim(D4_FILIAL+D4_OP) == Alltrim(xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		If IsInCallStack('GeraCB7R') .and. U_STIsIndireto(SD4->D4_COD)
			SD4->(DbSkip())
			Loop
		Endif
		nRes	:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilAnt))
		nResDF	:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilDP))
		nFalta	:=SD4->(U_STGetFal(AllTrim(D4_OP),D4_COD))
		aCores	:= {If(!Empty(nRes),oVerde,oPreto),If(!Empty(nResDF),oAmarelo,oPreto),If(!Empty(nFalta),oVermelho,oPreto)}
		nPos := Ascan(aItens2,{|x| x[4]+x[5] == SD4->(D4_LOCAL+D4_COD)})
		If nPos == 0
			SD4->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],D4_LOCAL,D4_COD,Posicione("SB1",1,xFilial('SB1')+D4_COD,"B1_DESC"),0,Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture),0," ",Recno()}))
			nPos := len(aItens2)
		EndIf
		aItens2[nPos,7]+=SD4->D4_QTDEORI
		If ! Empty(SD4->D4_XORDSEP)
			aItens2[nPos,11]+=SD4->D4_QTDEORI
		EndIf

		SD4->(DbSkip())
	End
	If Empty(aItens2)
		SD4->(aadd(aItens2,{aCores[1],aCores[2],aCores[3],"","","","","","","",""," ",0}))
	EndIf
	If oLbx<>NIL
		oLbx:SetArray( aItens2 )
		oLbx:bLine := {|| aEval(aItens2[oLbx:nAt],{|z,w| aItens2[oLbx:nAt,w] } ) }
		oLbx:Refresh()
	EndIf
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MudaSD4(aItens,cOP)
User Function MudaSD4(aItens,cOP)
	Local oDlg
	Local oP1
	Local oP2
	Local nX
	Local cProduto
	Local cArm
	Local nReserva
	Local cReserva
	Local nQtdEstru
	Local nQtOriSD4
	Local cQtde
	Local oLbx
	Local aLbx 		:={}
	Local lOk		:= .F.

	Local nQtPaCal	:= 0
	Local oQtPaCal
	Local nQtPaSug	:= 0
	Local oQtPaSug
	Local nMenor	:= 0
	Local cPicture	:= PesqPict("SD4","D4_QTDEORI")
	Local nQtdSC2	:= SC2->C2_QUANT
	Local aMenor	:={}

	For nX:= 1 to len(aItens)
		nQtOriSD4:= aItens[nx,7]
		nReserva := SuperVal(StrTran(aItens[nx,8],".",""))
		nQtdEstru:= nQtOriSD4/nQtdSC2
		nMenor	:= nReserva/nQtdEstru
		aadd(aMenor,nMenor)
	Next
	aSort(aMenor)
	nQtPaCal := aMenor[1]
	nQtPaSug := aMenor[1]
	For nX:= 1 to len(aItens)
		cProduto	:= aItens[nx,5]
		cArm		:= aItens[nx,4]
		cReserva	:= aItens[nx,8]
		nReserva := SuperVal(StrTran(aItens[nx,8],".",""))
		nQtOriSD4:= aItens[nx,7]
		nQtdEstru:= nQtOriSD4/nQtdSC2
		cQtde		:= Transform(nQtPaSug*nQtdEstru,cPicture)
		aadd(aLbx,{cProduto,cArm,cReserva,cQtde,"",nQtdEstru})
	Next

	DEFINE MSDIALOG oDlg TITLE "Ajuste da quantidade a separar para OP:"+cOP FROM 0,0 TO 470,600 PIXEL OF oMainWnd
	oP1:= TPanel():New( 028, 072, ,oDlg, , , , , , 120, 30, .F.,.T. )
	oP1:align:= CONTROL_ALIGN_TOP

	@ 06,05 Say "Possibilidade de produ็ใo da Ordem de Produ็ใo com base na quantidade reservada  " PIXEL of oP1
	@ 04,220 MsGet oQtPaCal Var nQtPaCal Picture cPicture PIXEL of oP1 SIZE 40,09 When .f.
	@ 18,05 Say "Informe a quantidade que deseja produzir para o calculo da separa็ใo " PIXEL of oP1
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 16,220 MsGet oQtPaSug Var nQtPaSug Picture cPicture PIXEL of oP1 SIZE 40,09  Valid U_VldPaSug(nQtPaSug,nQtPaCal,aLbx,oLbx)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 10,10 LISTBOX oLbx FIELDS HEADER "Produto", "Armazem","Reserva","Quantidade"," "  SIZE 230,095 OF oDlg PIXEL ON dblClick(U_FormQtde(oLbx,aLbx,aItens))

	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}

	oLbx:align:= CONTROL_ALIGN_ALLCLIENT

	oP2 := TPanel():New( 028, 072, ,oDlg, , , , , , 120, 20, .F.,.T. )
	oP2:align:= CONTROL_ALIGN_BOTTOM
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 5,010  BUTTON "Alterar"	 SIZE 55,11 ACTION U_FormQtde(oLbx,aLbx,aItens) OF oP2 PIXEL
	@ 5,180  BUTTON "Confimar"	 SIZE 55,11 ACTION (lOk:= .t.,oDlg:End()) OF oP2 PIXEL
	@ 5,240  BUTTON "Cancelar"	 SIZE 55,11 ACTION oDlg:End() OF oP2 PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

	If lOk
		For nX:= 1 to len(aItens)
			aItens[nx,8] := aLbx[nX,4]
		Next
	Else
		MsgAlert(" A gera็ใo da Ordem de Separa็ใo "+cOP+" foi cancelada")
	EndIf

Return lOk

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function VldPaSug(nQtPaSug,nQtPaCal,aLbx,oLbx)
User Function VldPaSug(nQtPaSug,nQtPaCal,aLbx,oLbx)
	Local nx
	Local cPicture	:= PesqPict("SD4","D4_QTDEORI")

	If nQtPaSug > nQtPaCal
		MsgAlert("Quantidade sugerida nใo pode ser maior que a quantidade calculada","Aten็ใo")
		Return .f.
	EndIf

	For nX:= 1 to len(aLbx)
		aLbx[nX,4]	:= Transform(nQtPaSug*aLbx[nx,6],cPicture)
	Next

	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
	oLbx:Refresh()
Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function FormQtde(oLbx,aLbx, aItens)
User Function FormQtde(oLbx,aLbx, aItens)
	Local aRet := {}
	Local aParamBox := {}
	Local cProduto := aLbx[oLbx:nAt,1]
	Local cArm		:= aLbx[oLbx:nAt,2]
	Local nReserva	:= SuperVal(StrTran(aLbx[oLbx:nAt,3],".",""))
	Local nQtde    := SuperVal(StrTran(aLbx[oLbx:nAt,4],".",""))
	Local nQtdeAnt	:= SuperVal(StrTran(aItens[oLbx:nAt,8],".",""))
	Local cPicture	:= PesqPict("SD4","D4_QTDEORI")

	Local nMv
	Local aMvPar:={}

	For nMv := 1 To 40
		aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv

	aParamBox :={	{1,"Produto"				,cProduto	,"","",""	,".F.",0,.F.},;
	{1,"Armazem"				,cArm			,"","",""	,".F.",0,.F.},;
	{1,"Reserva"				,nReserva	,"9999999.99","",""	,".F.",0,.F.},;
	{1,"Quantidade"			,nQtde 		,"9999999.99","",""	,".T.",0,.F.}}

	If ! ParamBox(aParamBox,"Parametros",@aRet,,,,,,,,.f.)
		For nMv := 1 To Len( aMvPar )
			&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
		Next nMv
		oLbx:SetArray( aLbx )
		oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
		oLbx:Refresh()
		Return
	EndIf

	nQtde 	:= MV_PAR04
	If nQtde > nQtdeAnt
		MsgAlert("Quantidade nใo pode ser superior a quantidade reservada")
		Return
	Else
		aLbx[oLbx:nAt,4] := Transform(nQtde,cPicture)
	EndIf

	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
	oLbx:Refresh()
	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv

Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function ViewSC2()
User Function ViewSC2()
	Local aArea 	:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Private cCadastro := "Ordem de Produ็ใo"
	a650View("SC2",SC2->(Recno()),2)

	RestArea(aAreaSC2)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function PesqSC2(cOP,oBrowse)
User Function PesqSC2(cOP,oBrowse)
	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local nRecno

	If Empty(cOP)
		Return .t.
	EndIf

	SC2->(DbSetOrder(1))
	If ! SC2->(DbSeek(xFilial('SC2')+Alltrim(cOP)))
		MsgAlert('Ordem de produ็ใo nใo encontrada!!!',"Aten็ใo")
		cOP:= Space(13)
		RestArea(aAreaSC2)
		RestArea(aArea)
		Return .t.
	EndIf

	nRecno:= SC2->(Recno())
	cOP:= Space(13)
	RestArea(aAreaSC2)
	RestArea(aArea)
	SC2->(DbGoto(nRecno))
	oBrowse:Refresh()
	Eval(oBrowse:bChange)

Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Expedicao(oFolder,oDlg,cArmExp)
User Function Expedicao(oFolder,oDlg,cArmExp)
	//Local aBrowse	:= {"CB7_ORDSEP","CB7_XAUTSE","CB7_LOCAL","CB7_CODOPE","CB7_XOPEXP","CB7_PEDIDO","CB7_OP","CB7_XSEP","CB7_XPRIOR","CB7_XOSPAI","CB7_XOSFIL"}
	//Local aBrowse	:= {"CB7_ORDSEP","CB7_PEDIDO","CB7_LOCAL","CB7_XOPEXP","CB7_CODOPE","CB7_OP","GRUPO","CB7_XAUTSE","CB7_XSEP","CB7_XPRIOR","CB7_XOSPAI","CB7_XOSFIL"}
	Local aBrowse	:= {"CB7_ORDSEP","CB7_PEDIDO","CB7_LOCAL","CB7_XOPEXP","CB7_CODOPE","CB7_OP","GRUPO","CB7_XAUTSE","CB7_XSEP","CB7_XPRIOR","CB7_XOSPAI","CB7_XOSFIL","CB7_XOPEXG"}  //FR - #20200710004035
	Local aCab2		:= {"1"			,"2"		 ,"Armazem"	 ,"Produto"	  ,"Descricao"	,"Endere็o","Lote","Quantidade","Saldo Separa็ใo (1)","Saldo Embalagem (2)","Separador"}
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

	Local oOrdSep
	Local cOrdSep := Space(6)

	Local oStatus
	Local cStatusPed:= "Todos"

	Local oCodOpe
	Local cCodOpe := Space(6)

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

	Local oBrowseSep
	Local _cUseLib := GetMv("ST_FSFA40",,"000000")
	Local cFS_GRPEXP	:= SuperGetMV("FS_GRPEXP",,"")
	Local _aGrupos
	//Local _nPos

	Local oGen 					//FR - 21/07/2021 - Ticket #20210614010082 - listar OS/Pedidos cujo separador foi gerado pela aloca็ใo automแtica (op. gen้rico)
	Local cCodOpeGen := "" 		//FR - 21/07/2021 - Ticket #20210614010082
	//Local _aItens3   := {}
	
	Private oSayPed   			//FR - 23/07/2021 - Ticket #20210614010082
	Private oSayLin				//FR - 23/07/2021 - Ticket #20210614010082

	Public xnLix      := 0
	Public xnTotped   := 0
	
	cCodOpeGen := U_fTrazCB1Gen()		//VERIFICA QUAL O CำDIGO QUE CORRESPONDE A OPERADOR GENษRICO
	

	if (cEmpAnt=="03")				// Valdemir Rabelo 28/12/2020 - Ticket:  20201106010114
		aCab2		:= {"1"			,"2"		 ,"Armazem"	 ,"Produto"	  ,"Descricao"	,"Endere็o","Lote","Quantidade","Saldo Separa็ใo (1)","Saldo Embalagem (2)","Separador","Programador","Depto.","Lote OP"}
	endif 
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	If IsInCallStack("U_STFSFA14")
		aBtnLat :={			{"BMPVISUAL"    	,{|| U_ViewCB7()}					,"Visualiza Ordem de Separa็ใo"	},;
		{"BMPINCLUIR"  		,{|| U_GeraCB7(cArmExp)}			,"Gera Ordem de Separa็ใo"		},;
		{"DEVOLNF"    		,{|| U_DeleCB7(cArmExp)}			,"Estorna Ordem de Separa็ใo"	},;
		{"CLIENTE"    		,{|| U_Aloca(cArmExp)}				,"Alocar Operador"				},;
		{"AFASTAMENTO"   	,{|| U_Desaloca(cArmExp)}			,"Desalocar Operador"			},;
		{"CRITICA"    		,{|| U_Mensagem(CB7->CB7_CODOPE)}	,"Mensagem"						},;
		{"FRTONLINE"  		,{|| CBMonRF()}						,"Monitor"						},;
		{"CADEADO_MDI" 		,{|| U_BloqCB7()}					,"Autoriza Ord.Sep"				},;
		{"ALTERA" 		,{|| U_STALTCB7(CB7->CB7_ORDSEP)}		,"Finaliza OS"				}}
	ElseIf IsInCallStack("U_STFSFA15")
		aBtnLat :={			{"BMPVISUAL"    	,{|| U_ViewCB7()}					,"Visualiza Ordem de Separa็ใo"	},;
		{"CLIENTE"    		,{|| U_Aloca(cArmExp)}				,"Alocar Operador"				},;
		{"AFASTAMENTO"   	,{|| U_Desaloca(cArmExp)}			,"Desalocar Operador"			},;
		{"CRITICA"    		,{|| U_Mensagem(CB7->CB7_CODOPE)}	,"Mensagem"						},;
		{"FRTONLINE"  		,{|| CBMonRF()}						,"Monitor"						},;
		{"CADEADO_MDI" 		,{|| U_BloqCB7()}					,"Autoriza Ord.Sep"				}}
	Else
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aBtnLat :={			{"BMPVISUAL"    	,{|| U_ViewCB7()}					,"Visualiza Ordem de Separa็ใo"	},;
		{"BMPINCLUIR"  		,{|| U_GeraCB7(cArmExp,.F.,.F.)}	,"Gera Ordem de Separa็ใo"		},;  //FR - 19/09/2022 - ativar qdo validado '1 OS PARA 'N' PEDIDOS' --> {"AUTOM"			,{|| U_GeraCB7(cArmExp,.T.,.F.)}	,"Gera 1 OS para N Pedidos"		},;   //FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
		{"DEVOLNF"    		,{|| U_DeleCB7(cArmExp)}			,"Estorna Ordem de Separa็ใo"	},;
		{"CLIENTE"    		,{|| U_Aloca(cArmExp)}				,"Alocar Operador"				},;
		{"BMPGROUP"    		,{|| U_AlocaAut(cArmExp)}			,"Aloca็ใo Automแtica"			},;		//FR - 27/05/2021 - Ticket #20200710004035 - Prioridade Aloca็ใo
		{"AFASTAMENTO"   	,{|| U_Desaloca(cArmExp)}			,"Desalocar Operador"			},;
		{"WMSIMG32"    		,{|| U_STFSFA30(.T.,oLbx)	}		,"Embalagem"					},;
		{"CRITICA"    		,{|| U_Mensagem(CB7->CB7_CODOPE)}	,"Mensagem"						},;
		{"FRTONLINE"  		,{|| CBMonRF()}						,"Monitor"						},;
		{"CADEADO_MDI" 		,{|| U_BloqCB7()}					,"Autoriza Ord.Sep"				},;
		{"OK"   	 		,{|| U_OSAUTO(aItens2)}		        ,"OS Automatico"		,Iif(__cUserId $ _cUseLib,.T.,.F.)},;
		{"ALTERA" 			,{|| U_STALTCB7(CB7->CB7_ORDSEP)}					,"Finaliza OS"				}}

	Endif

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_StsFilExp(oStatus,oBrowseSep,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,1)

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
	If __cuserid $ GetMv("ST_FA10CA",,"000651/000301/000566 /000076/000077/000529/000000")
		TBtnBmp2():New(nAux,0,40,40 ,"WMSIMG32", NIL, NIL,NIL,{|| U_STFSFA30(.T.,oLbx)	}, oPanel1, "Embalagem", NIL, NIL,NIL )
	EndIf
	@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
	oPanel4:Align := CONTROL_ALIGN_TOP

	@ 06,22 Say "Ordem de Separa็ใo" PIXEL of oPanel4
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 04,80 MsGet oOrdSep Var cOrdSep Picture "!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "CB7FS1" Valid U_PesqOSep(@cOrdSep,oBrowseSep)

	@ 06,150 Say "Operador" PIXEL of oPanel4
	@ 04,180 MsGet oCodOpe Var cCodOpe Picture "!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "CB1FSW" //Valid PesqOper(@cCodOpe,oBrowseSep,cArmExp)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oCodOpe:bChange := {|| U_StFilOper(cCodOpe,cArmExp,.F.,.T.) }
	//@ 06,240 Say "* Somente para ordens com status em separa็ใo" PIXEL of oPanel4

	@ 06,252 Say "Pedido" PIXEL of oPanel4
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 04,275 MsGet oPedido Var cPedido Picture "!!!!!!" PIXEL of oPanel4 SIZE 40,09 F3 "SC5" Valid U_PesqCB7(@cPedido,oBrowseSep,1)

	@ 06,334 Say "OP" PIXEL of oPanel4
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 04,350 MsGet oOP Var cOP Picture "!!!!!!!!!!!!!" PIXEL of oPanel4 SIZE 49,09 F3 "SC2Q" Valid U_PesqCB7(@cOP,oBrowseSep,2)

	@ 06,430 Say "Filtrar Status" PIXEL of oPanel4
	@ 04,480 ComboBox oStatus VAR cStatusPed ITEMS {"Divergencia","Pausa","Finalizado","Nao Iniciado","Em Andamento","Todos"} Of oPanel4 PIXEL SIZE 85,10
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oStatus:bChange := {|| U_StsFilExp(oStatus,oBrowseSep,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,2) }

	//FR - 21/07 - botใo listar gen้rico - Ticket #20200710004035 / #20210614010082
	xnTotped := 0
	xnLix    := 0
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@05,600 BUTTON oGen PROMPT "Sequencial Automแtico" ACTION ( Processa( {|lEnd| U_StFilOper(cCodOpeGen,cArmExp,.T.,.T.,@xnTotped,@xnLix)}, "Aguarde...", "SELECIONANDO REGISTROS", .T. ) ) SIZE 080,12 OF oPanel4 PIXEL
	
	//FR - 21/07 - contador de pedidos e linhas do operador Gen้rico - Ticket #20200710004035 / #20210614010082
	//OPERADOR GENษRICO = .T. MAS TELA = .F., nใo mostra tela s๓ faz o cแlculo
	xnTotped := 0
	xnLix    := 0
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F.
	
	@05,690 Say oSayPed Var "Total Pedidos: " + AllTrim(Str(xnTotped)) Pixel of oPanel4 
	@05,745 Say oSayLin Var "Total Linhas:  "  + AllTrim(Str(xnLix )) Pixel of oPanel4
	oSayPed:Refresh()
	oSayLin:Refresh()

	@00,00 MSPANEL oPanel2 PROMPT "" SIZE 20,20 of oDlg
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	DbSelectArea("CB7")
	If lAdm
		CB7->(DbOrderNickName("STFSCB701"))
		CB7->(DbSeek(xFilial('CB7')+'2',.T.))
	Else

		cCpoFil 	:= "CB7->(CB7_FILIAL+CB7_LOCAL)"
		cTopFun 	:= xFilial('CB7')+"" //""
		cBotFun 	:= xFilial('CB7')+cArmExp //'ZZZZZZZZZ' //cArmExp

		CB7->(DbOrderNickName("STFSCB702"))
		CB7->(DbSeek(xFilial('CB7')+cArmExp))

	EndIf

	oBrowseSep := VCBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,/*bLDblClick*/,,,,,,,, .F.,"CB7", .T.,, .F., ,)
	//oBrowseSep := TWBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,/*bLDblClick*/,,,,,,,, .F.,"CB7", .T.,, .F., ,)
	oBrowseSep := oBrowseSep:GetBrowse()
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oBrowseSep:bChange := {|| oBrowseSep:Refresh(),U_MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)  }
	oBrowseSep:Align := CONTROL_ALIGN_ALLCLIENT

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oCol := TCColumn():New( " ",{|| U_AnalisaLeg(1) },,,, "LEFT", 8, .T., .F.,,,, .T., )
	oBrowseSep:AddColumn(oCol)
	If cArmExp == GetMv("FS_ARMEXP")
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		oCol := TCColumn():New( " ",{|| U_AnalisaLeg(2) },,,, "LEFT", 8, .T., .F.,,,, .T., )
		oBrowseSep:AddColumn(oCol)
	EndIf

	For i:=1 To Len(aBrowse)

		If aBrowse[i]=="CB7_XAUTSE"
			If Empty(CB7->CB7_XAUTSE)
				bBlocoC := &("{ || aAutSep[1,3] }")
			Else
				bBlocoC := &("{ || aAutSep[val(CB7->"+aBrowse[i]+"),3] }")
			Endif
			oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), bBlocoC,,,, "LEFT",, .F., .F.,,,, .F., )
		Else
			If !aBrowse[i]$"GRUPO"//>> Ticket 20190507000034 - Everson Santana - 12.09.2019
				oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || CB7->"+aBrowse[i]+"}"),,,, "LEFT",, .F., .F.,,,, .F., )
			EndIf//>> Ticket 20190507000034 - Everson Santana - 12.09.2019
		Endif

		If aBrowse[i]=="CB7_CODOPE"
			oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || Posicione('CB1',1,xFilial('CB1')+CB7->CB7_CODOPE,'CB1_NOME')}"),,,, "LEFT",, .F., .F.,,,, .F., )
		EndIf
		If aBrowse[i]=="CB7_XOPEXP"
			oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || Posicione('CB1',1,xFilial('CB1')+CB7->CB7_XOPEXP,'CB1_NOME')}"),,,, "LEFT",, .F., .F.,,,, .F., )
		EndIf

		//FR
		//_cOpGen := U_fTrazCB1Gen()

		If aBrowse[i]=="CB7_XOPEXG"
			oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || Posicione('CB1',1,xFilial('CB1')+CB7->CB7_XOPEXG,'CB1_NOME')}"),,,, "LEFT",, .F., .F.,,,, .F., )
		EndIf
		//FR

		//>> Ticket 20190507000034 - Everson Santana - 12.09.2019
		If aBrowse[i]=="GRUPO"
			oCol := TCColumn():New( Alltrim("GRUPO"), &("{ || Posicione('SBM',1,xFilial('SBM')+Posicione('SB1',1,xFilial('SB1')+Posicione('SC2',1,xFilial('SC2')+CB7->CB7_OP,'C2_PRODUTO'),'B1_GRUPO'),'BM_DESC')}"),,,, "LEFT",, .F., .F.,,,, .F., )
		EndIf
		//<<
		oBrowseSep:AddColumn(oCol)
	Next i

	oBrowseSep:Refresh()

	@00,00 MSPANEL oPanel3 PROMPT "" SIZE 140,140 of oPanel2
	oPanel3:Align := CONTROL_ALIGN_BOTTOM

	@00,00 MSPANEL oPanel5 PROMPT "" SIZE 20,20 of oPanel3
	oPanel5:Align := CONTROL_ALIGN_BOTTOM
	If ! Empty(cArmExp)
		@ 06,230 Say "* Totalizados para o Armazem:"+cArmExp PIXEL of oPanel5
	EndIf
	@ 06,000 Say "Qtde Itens:" PIXEL of oPanel5
	@ 04,030 MsGet oTotItem Var nTotItem Picture "9999" PIXEL of oPanel5 SIZE 50,09 When .f.

	@ 06,100 Say "Qtde Endere็os:" PIXEL of oPanel5
	@ 04,150 MsGet oTotEnd Var nTotEnd Picture "999" PIXEL of oPanel5 SIZE 50,09 When .f.

	oLbx := TWBrowse():New(10,10,230,95,,aCab2,,oPanel3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:blDBlClick := {|| U_STFSVE50(aItens2[oLbx:nAt,4])}

	@ 000,000 BUTTON oSplit PROMPT "*" SIZE 5,5 OF oPanel2 PIXEL
	oSplit:cToolTip := "Habilita e desabilita os itens."
	oSplit:bLClicked := {|| oPanel3:lVisibleControl 	:= !oPanel3:lVisibleControl}
	oSplit:Align := CONTROL_ALIGN_BOTTOM

Return oBrowseSep

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function PesqCB7(cPesq,oBrowseSep,nTipoPsq)
User Function PesqCB7(cPesq,oBrowseSep,nTipoPsq)
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local nRecno

	If Empty(cPesq)
		Return .t.
	EndIf

	If nTipoPsq == 1
		CB7->(DbSetOrder(2))
		If ! CB7->(DbSeek(xFilial('CB7')+cPesq))
			MsgAlert('Pedido nใo encontrado!!!',"Aten็ใo")
			cPesq:= Space(6)
			RestArea(aAreaCB7)
			RestArea(aArea)
			Return .t.
		EndIf
	Else
		CB7->(DbSetOrder(5))
		If ! CB7->(DbSeek(xFilial('CB7')+cPesq))
			MsgAlert('Pedido nใo encontrado!!!',"Aten็ใo")
			cPesq:= Space(13)
			RestArea(aAreaCB7)
			RestArea(aArea)
			Return .t.
		EndIf
	EndIf

	nRecno:= CB7->(Recno())
	cPesq:= Iif(nTipoPsq == 1,Space(6),Space(13))
	RestArea(aAreaCB7)
	RestArea(aArea)
	CB7->(DbGoto(nRecno))
	oBrowseSep:Refresh()
	Eval(oBrowseSep:bChange)

Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function StsFilExp(oStatus,oBrowseSep,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,nTipo)
User Function StsFilExp(oStatus,oBrowseSep,oLbx,aItens2,cArmExp,oTotItem,oTotEnd,nTipo)

	Local _cFitro	:= ""

	Dbselectarea("CB7")

	If cArmExp <> Nil
		If nTipo == 2
			If oStatus:nAt == 1
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"') .And. CB7_DIVERG = '1'"
			ElseIf oStatus:nAt == 2
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"') .And. CB7_STATPA = '1'"
			ElseIf oStatus:nAt == 3
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"') .And. CB7_STATUS = '9'"
			ElseIf oStatus:nAt == 4
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"') .And. CB7_STATUS = '0'"
			ElseIf oStatus:nAt == 5
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"') .And. (CB7_DIVERG <> '1' .And. CB7_STATPA <> '1' .And. CB7_STATUS <> '0' .And. CB7_STATUS <> '9')"
			ElseIf oStatus:nAt == 6
				_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"')"
			EndIf
		Else
			_cFitro += "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"')"
		EndIf
		DbClearFilter()
		SET FILTER TO &(_cFitro)
	Else
		If nTipo == 2 .And. oStatus:nAt <> 6
			If oStatus:nAt == 1
				_cFitro += "CB7_DIVERG = '1'"
			ElseIf oStatus:nAt == 2
				_cFitro += "CB7_STATPA = '1'"
			ElseIf oStatus:nAt == 3
				_cFitro += "CB7_STATUS = '9'"
			ElseIf oStatus:nAt == 4
				_cFitro += "CB7_STATUS = '0'"
			ElseIf oStatus:nAt == 5
				_cFitro += "(CB7_DIVERG <> '1' .And. CB7_STATPA <> '1' .And. CB7_STATUS <> '0' .And. CB7_STATUS <> '9')"
			EndIf

			DbClearFilter()
			SET FILTER TO &(_cFitro)
		Else
			DbClearFilter()
		EndIf
	EndIf

	DbGotop()

	If nTipo == 2
		oBrowseSep:nAt:=1
		Eval(oBrowseSep:bGoTop)
		oBrowseSep:REFRESH()
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		U_MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)
	EndIf

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)
User Function MontaCB8(oLbx,aItens2,cArmExp,oTotItem,oTotEnd)
	Local oAzul		:= LoadBitmap( GetResources(), "BR_AZUL" 	)
	Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oNao		:= LoadBitmap( GetResources(), "BR_CANCEL"	)
	Local oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local cPicture	:= PesqPict("CB8","CB8_QTDORI")
	Local nSaldoE	:= 0
	Local lEmb		:= .f.
	Local oSep		:=NIL
	Local oEmb		:=NIL
	Local cProgram := ''
	Local cDepto   := ''
	Local cLoteOP  := ''
	Local lAgrup   := .F.  //FR 

	nTotItem := 0
	nTotEnd 	:= 0
	aItens2:={}
	CB8->(DbSetOrder(1))
	CB8->(DbSeek(xFilial('CB8')+CB7->CB7_ORDSEP))
	While CB8->(! Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial('CB8')+CB7->CB7_ORDSEP)

		If Empty(CB8->CB8_SALDOS)
			oSep	:= oVerde
		Else
			If CB8->CB8_SALDOS == CB8->CB8_QTDORI
				oSep := oAzul
			Else
				oSep := oAmarelo
			EndIf

			If ! IsInCallStack('U_STFSFA10') .and. cArmExp <> CB8->CB8_LOCAL
				oSep := oNao
			EndIf
		EndIF
		If "01*" $ CB7->CB7_TIPEXP .or. "02*" $ CB7->CB7_TIPEXP
			If Empty(CB8->CB8_SALDOE)
				oEmb	:= oVerde
			Else
				If CB8->CB8_SALDOE == CB8->CB8_QTDORI
					oEmb := oAzul
				Else
					oEmb := oAmarelo
				EndIf
			EndIF
		Else
			oEmb	:= oNao
		EndIf

		lEmb		:= "01*" $ CB7->CB7_TIPEXP .or. "02*" $ CB7->CB7_TIPEXP
		If lEmb
			nSaldoE:=CB8->CB8_SALDOE
		EndIf
		If Empty(cArmExp) .or. cArmExp == CB8->CB8_LOCAL
			If Ascan(aItens2,{|x| x[4] == CB8->CB8_PROD}) == 0
				nTotItem++
			EndIf
			If ! Empty(CB8->CB8_LCALIZ) .and. Ascan(aItens2,{|x| x[6] == CB8->CB8_LCALIZ}) == 0
				nTotEnd++
			EndIf
		EndIf
		if (cEmpAnt=="03")				// Valdemir Rabelo 28/12/2020 - Ticket:  20201106010114
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			U_getProd(@cProgram,@cDepto,@cLoteOP, CB8->CB8_OP)
			CB8->(aadd(aItens2,{oSep,oEmb,CB8_LOCAL,CB8_PROD,Posicione("SB1",1,xFilial('SB1')+CB8_PROD,"B1_DESC"),CB8_LCALIZ,CB8_LOTECT,Transform(CB8_QTDORI,cPicture),Transform(CB8_SALDOS,cPicture),Transform(nSaldoE,cPicture),CB8->CB8_CODOPE,cProgram,cDepto,cLoteOP,Recno()}))
		else 
			CB8->(aadd(aItens2,{oSep,oEmb,CB8_LOCAL,CB8_PROD,Posicione("SB1",1,xFilial('SB1')+CB8_PROD,"B1_DESC"),CB8_LCALIZ,CB8_LOTECT,Transform(CB8_QTDORI,cPicture),Transform(CB8_SALDOS,cPicture),Transform(nSaldoE,cPicture),CB8->CB8_CODOPE,Recno()}))
		endif 
		CB8->(DbSkip())
	End

	If Empty(aItens2)
	    if (cEmpAnt=="03")				// Valdemir Rabelo 28/12/2020 - Ticket:  20201106010114
			aadd(aItens2,{oNao,oNao,"","","","","","","",""," "," "," "," ",0})
		else 
			aadd(aItens2,{oNao,oNao,"","","","","","","",""," ",0})
		endif 
	EndIf
	//=========================================================================================================//
	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	//FLAG para marcar que o item prov้m de agrupamento de pedidos
	//=========================================================================================================//
	If lAgrup
		ASort(aItens2,,,{|x,y| (x[4]) < (y[4])})
	Endif 
	If oLbx<>NIL
		oLbx:SetArray( aItens2 )
		oLbx:bLine := {|| aEval(aItens2[oLbx:nAt],{|z,w| aItens2[oLbx:nAt,w] } ) }
		oLbx:Refresh()
		oTotItem:cText:= nTotItem
		oTotItem:Refresh()
		oTotEnd:cText:= nTotEnd
		oTotEnd:Refresh()
	EndIf
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function QtdDoc(oFolder)
User Function QtdDoc(oFolder)
	Local nQtdDoc 		:= GetMv("FS_QTDDOC")
	Local aRet			:= {}
	oFolder :SetOption(len(ofolder:aDialogs))
	If ParamBox({	{ 1, "Qtde Documentos"	, nQtdDoc 			, "@E 999"    , "", "", "" , 0  , .f. }},"Configura็๕es",@aRet,,,,,,,,.F.)
		PutMv("FS_QTDDOC",aRet[1])
	EndIf
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function GeraCB7(cArmSel,l1PN,lJob)		//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
User Function GeraCB7(cArmSel,l1PN,lJob,aParms,aOSGer)		//U_GeraCB7(cArmExp,.T.,.F.)
	Local lAdmin 	:= Empty(cArmSel)
	Local aRet		:={0,0}
	Local aCabDoc	:= {}
	Local aDocs		:= {}
	Local nQtdDoc 	:= GetMv("FS_QTDDOC")
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local aArea		:= GetArea()
	Local aSC5Area	:= SC5->(GetArea())
	Local aSC2Area	:= SC2->(GetArea())
	Local cMsgLog 	:= ''
	Local lMudaQtd	:= .F.  // ALTERADO POR GALLO-RVG EM 11/05/13 ERA .T.
	Local aParam 	:= {}	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Local aRet		:= {}	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Local fr        := 0	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
    Local lAutOrd  := GetMV("ST_AUTORD",.F.,.T.)
    //Local _cLockBy  := "GeraCB7"
	Local _cLockBy  :='GeraCB7_'+GetEnvServer()

	Default l1PN    := .F.	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Default lJob	:= .F.	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Default aParms  := {}

    IF !LockByName(_cLockBy,.T.,.T.,.T.)
	   MsgAlert('Processa sendo executado em outra se็ใo !!! Usuario:'+GetMv("ST_USEROS",," "),"Aten็ใo")
	   RETURN()
    ELSE 
	   PutMv("ST_USEROS",cusername)   
    ENDIF
	
	
	If !lJob
		If lAdmin
			If  ! ParamBox({{ 2, "Origem do documento	"	, "Pedido de Venda"	, {"Pedido de Venda","Produ็ใo"},80,'',.F.}},"Ordem de Separa็ใo",@aRet,,,,,,,,.F.)
				UnLockByName(_cLockBy,.T.,.T.,.T.)
				PutMv("ST_USEROS",'  ')  
				Return()
			EndIf
			If aRet[1] == "Pedido de Venda"
				cArmSel := cArmExp
			Else
				cArmSel := cArmEst
			EndIf
		EndIf
	Else 
		cArmSel := cArmExp
	Endif 

	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	If l1PN .AND. !lJob
		//037400 - cliente teste
		aAdd(aParam	,{1, "Cliente:"  				, SPACE(TamSX3('A1_COD')[01])		, "", "", "SA1", "", 80, .F.})
		aAdd(aParam	,{1, "Loja:"  					, SPACE(TamSX3('A1_COD')[01])		, "", "", ""   , "", 80, .F.})
		aAdd(aParam	,{1, "Transportadora:"			, SPACE(TamSX3('A4_COD')[01])		, "", "", "SA4", "", 80, .F.})
		aAdd(aParam	,{1, "Cond.Pagto:" 				, SPACE(TamSX3('E4_CODIGO')[01])	, "", "", "SE4", "", 80, .F.})
		
		If !ParamBox(aParam,"Parโmetros", @aRet,,,,,,,,.F.,.F.)
			UnLockByName(_cLockBy,.T.,.T.,.T.)
			PutMv("ST_USEROS",'  ')  
			MsgInfo("Opera็ใo Cancelada Pelo Operador")
			Return
		Endif 	

	Elseif lJob 
		/*
		Aadd(aParam, TMPC5->C5_CLIENTE )	
		Aadd(aParam, TMPC5->C5_LOJACLI )
		Aadd(aParam, TMPC5->C5_CLIENT  )
		Aadd(aParam, TMPC5->C5_LOJAENT )
		Aadd(aParam, TMPC5->C5_TRANSP  )
		Aadd(aParam, TMPC5->C5_CONDPAG )
		*/

aRet := aClone(aParms)

Endif
//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672

If cArmSel == cArmExp
	//aCabDoc:= {"C5_NUM","C5_CLIENTE","C5_LOJACLI","C5_XNOME","C5_XTIPO","C5_EMISSAO","C5_XTIPF","QTD_LIN","REABASTECIMENTO","E4_XVLRMIN","C6_VALOR","C5_XBLQFMI","RESERVA","C5_XALERTF"} //Chamado 007655 - Everson Santana - 22/08/18
	aCabDoc:= {"C5_NUM","C5_CLIENTE","C5_LOJACLI","C5_XNOME","C5_XTIPO","C5_EMISSAO","C5_XTIPF","QTD_LIN","LIN_SCH","LIN_STK","REABASTECIMENTO","E4_XVLRMIN","C6_VALOR","VLR_SCH","VLR_STK","C5_XBLQFMI","RESERVA","C5_XALERTF"} //Chamado 007655 - Everson Santana - 22/08/18

	IF !lAutOrd
	If !lJob
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		FWMsgRun(, {|| aDocs := U_LoadSC5(nQtdDoc,aCabDoc,@cMsgLog,aRet,lJob,l1PN)},"Aguarde","Separando registros")
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		FWMsgRun(, {|| U_SelDoc(aCabDoc,aDocs,"Gera็ใo de Ordem de Separa็ใo - Pedido de Venda",cMsgLog,,.F.,.F.,l1PN,lJob)},"Aguarde","Montando a tela")
	Else
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aDocs := U_LoadSC5(nQtdDoc,aCabDoc,@cMsgLog,aRet,lJob,l1PN)
		U_SelDoc(aCabDoc,aDocs,"Gera็ใo de Ordem de Separa็ใo - Pedido de Venda",cMsgLog,,.F.,.F.,l1PN,lJob)
	Endif
	ELSE 
       MsgAlert('Processo automแtico habilitado!!! Necessแrio desabilitar para processamento manual ')
	ENDIF  

ElseIf cArmSel == cArmEst
	aCabDoc:= {"C2_NUM","C2_ITEM","C2_SEQUEN","C2_PRODUTO","C2_UM","C2_LOCAL","C2_XPRIORI","C2_PEDIDO","C2_XLOTE","C2_DATPRF"}
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	aDocs := U_LoadSC2(nQtdDoc,aCabDoc,@cMsgLog)
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_SelDoc(aCabDoc,aDocs,"Gera็ใo de Ordem de Separa็ใo - Produ็ใo",cMsgLog,@lMudaQtd,.F.,.F.)
Endif

//If !lJob
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
MsgRun( "Gerando Ordem de Separa็ใo, aguarde...",, {|| U_GeraCB7R(cArmSel,aDocs,lMudaQtd,l1PN,lJob,@aOSGer)} )
If cFilAnt = '02' .and. cEmpAnt = '01'
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_STDPLOS()
EndIf

UnLockByName(_cLockBy,.T.,.T.,.T.)
PutMv("ST_USEROS",'  ')  

//If Len(aOSGer) > 0
//	For fr := 1 to Len(aOSGer)
//		U_STAvisOS(aOSGer[fr])
//	Next
//Endif

//Else
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//U_GeraCB7R(cArmSel,aDocs,lMudaQtd,l1PN,lJob,@aOSGer)
//If Len(aOSGer) > 0
//For fr := 1 to Len(aOSGer)
//U_STAvisOS(aOSGer[fr])
//Next
//Endif
//Endif
RestArea(aSC5Area)
RestArea(aSC2Area)
RestArea(aArea)

Return()

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function GeraCB7R(cArmSel,aDocs,lMudaQtd,cProc)
User Function GeraCB7R(cArmSel,aDocs,lMudaQtd,l1PN,lJob,aOSGer)

	Local cArmExp 	:= GetMv("FS_ARMEXP")
	//Local cArmEst 	:= GetMv("FS_ARMEST")

	Local aItens	:={}
	Local nX		:= 0
	Local nY		:= 0
	Local cDoc		:= ''
	Local cProduto	:= ''
	Local cArm		:= ''
	Local nReserva	:= 0
	Local nCalcSld	:= 0
	Local nRecno	:= 0
	Local cOrdSep	:= ""
	Local cOrdAux	:= ""
	Local aSD4		:= {}
	Local cArmAnt	:= ""
	Local lDifArm	:= .F.
	Local _lSVDI300	:= .F.  //Chamado 003370
	Local lOp 		:= .f.
	Local nCont		:= 0
	Local nMaximoOS := 0

	Private _aEmaReab	:={}
	Private lQuebra	:= .F.

	Default l1PN   	:= .F.
	Default lJob   	:= .F.
	Default aOSGer 	:= {}  //FR - armazenarแ o n๚mero das OS's que foram geradas - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672


	AaDd(_aEmaReab,{"PEDIDO",'PRODUTO','ENDEREวO', 'QUANTIDADE' })

	//-----------------------------//
	//Obt้m PRำXIMO NUMERO OS:
	//-----------------------------//
	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	//Se for 1 OS para N pedidos, cria o n๚mero da OS aqui fora e o looping dos pedidos serแ executado e criada apenas 1 OS
	//If l1PN
	//cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )
	//cOrdAux  := cOrdSep
	//CB7->(ConfirmSX8())
	//Endif
	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672

	For nX:= 1 to len(aDocs)   //ler array adocs e verificar quais foram marcados na rotina de gerar OS - os marcados vem com a primeira posi็ใo true

		lProssegue  := .T.		//FR - 25/07/2022
		_lSVDI300	:= .F.

		If !aDocs[nx,1]
			Loop
		EndIf

		lOp := .F.
		If SC2->(dbseek(XFILIAL("SC2") + aDocs[nx,2] + aDocs[nx,3] + aDocs[nx,4] ))
			If SC2->C2_QUANT > SC2->C2_QUJE .AND. Empty(SC2->C2_DATRF)
				lOp := .T.
			ENDIF
		Endif

		/*
		<<< Altera็ใo >>>
		A็ใo......: Depois de testar alguns cenแrios identifiquei que o vetor "aDocs" dependedo da rotina que o chama
		..........: ele pode vir com diversas dimens๕es "12/15/16".
		..........: A chamada "ValEstoq" precisa do recno onde sempre estแ fixo no ๚ltimo registro do vetor.
		Analista..: Marcelo Klopfer Leme - SIGAMAT
		Data......: 18/11/2021
		Chamado...: 20210825016836/
		If !ValEstoq(aDocs[nx,2],Iif(cArmSel==cArmExp,aDocs[nx,15],aDocs[nX,12]),cArmSel) //Renato Nogueira[29/05/2013]
		ValEstoq(_cPedido,_nRecno,cArmSel)
		*/
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		IF !U_ValEstoq(aDocs[nx,2],aDocs[nx,LEN(aDocs[nx])],cArmSel,lOp)
			LOOP
		ENDIF

		//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
		//If !l1PN  			//Se nใo for 1 OS para N pedidos, zera esta variแvel
		cOrdAux	:= ''	//variแvel auxiliar no n๚mero de OS

		//-----------------------------//
		//Obt้m PRำXIMO NUMERO OS:
		//-----------------------------//
		//cOrdSep  := GetSX8Num( "CB7", "CB7_ORDSEP" )
		//cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

		//CB7->(ConfirmSX8())
		//Endif
		//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
		If cArmSel == cArmExp  //Pedido de vendas
			SC5->(DbGoto(aDocs[nx,Len(aDocs[nx])]))  //posiciona na tabela SC5 atrav้s do RECNO
			IF SA1->(Dbseek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				IF SA1->A1_XNITNF > 0 .AND. SA1->A1_XNITNF <= 100
					nMaximoOS := SA1->A1_XNITNF
				Else
					nMaximoOS := SUPERGETMV("MV_NUMITEM",.F.,0)
				Endif
			Endif
           
		    nCont := 0
			//TESTE TIAGO//pai!@#3105//124849//075503
			//nMaximoOS := 2

			If SC5->( Rlock() )  // Ticket: 20210609009722 - Valdemir Rabelo 06/09/2021

				U_MontaSC6(NIL,aItens)
				If nMaximoOS <= 0
					nMaximoOS := len(aItens)
				Endif

				Begin Transaction

					For nY:= 1 to len(aItens)
						//nCont ++ Alterado devido a erro na quebra de OS 20230725009283

						//if nCont == nMaximoOS
						if nCont >= nMaximoOS
                           //if (nCont-1) == nMaximoOS Alterado devido ao problema na quebra de OS 20230725009283
							lQuebra := .T.
							nCont := 0
                        	//nCont := 1 Alterado devido ao problema na quebra de OS 20230725009283
						ELSE
							lQuebra := .F.
						ENDIF

						IF lQuebra

							cOrdSep	 := " "
							cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

							CB7->(DBSETORDER(1))
							Do while CB7->(dbseek(xfilial("CB7")+cOrdSep))

								cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

							Enddo

							CB7->(ConfirmSX8())

						ELSE

							If nY = 1

								cOrdSep	 := " "
								cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

								CB7->(DBSETORDER(1))
								Do while CB7->(dbseek(xfilial("CB7")+cOrdSep))

									cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

								Enddo

								CB7->(ConfirmSX8())

							Endif

						ENDIF
                      
						cDoc		:= SC5->C5_NUM+aItens[nY,4]
						cProduto	:= aItens[nY,5]
						cArm		:= aItens[nY,8]
						nRecno		:= aItens[nY,len(aItens[nY])]
						nSldSC6		:= SuperVal(StrTran(aItens[nY,9],".",""))
						nReserva 	:= SuperVal(StrTran(aItens[nY,10],".",""))
						nCalcSld	:= nReserva - nSldSC6
                        
						If AllTrim(cProduto)=="SVDI300"
							_lSVDI300	:= .T.
						EndIf

						//giovani zago 02/04/2020 TRATAMENTO PARA NAO SEPARAR ITEM PARCIAL DA LEROY 20200227000730
						If cempant = '01' .and. cfilant = '02' .And. (SC5->C5_CLIENTE $ '038134/023789')     // Valdemir Rabelo Tiket: 20210803014605 adicionado cliente Construdecor
							If nReserva <> nSldSC6
								nReserva:= 0
							EndIf
						EndIf

						If nReserva > 0 .And. nCalcSld > 0
							U_STReserva	(cDoc,cProduto,nCalcSld,"-",cFilAnt)
						EndIf

						If nReserva > 0
                        	
							U_STReserva(cDoc,cProduto,Iif(nReserva < nSldSC6, nReserva, nSldSC6),"-",cFilAnt)

							U_STGrvSt(cDoc)

							U_STGeraSDC(cDoc,cProduto,cArm,Iif(nReserva < nSldSC6, nReserva, nSldSC6),nRecno,,cOrdSep)
							//U_STGeraOS	("SC5",cOrdSep,,cOrdAux,cArmSel,lDifArm)

							U_STGeraOS("SC5",cOrdSep,,cOrdAux,cArm,lDifArm)

						    nCont ++
						EndIf
						//nCont ++
					Next nY

					MaLiberOk	({SC5->C5_NUM},.F.)
					SC5->(RecLock('SC5'))
					/* chamado 007792
					If _lSVDI300
					SC5->C5_XOBSEXP	:= AllTrim(SC5->C5_XOBSEXP)+" SVDI300 - OBRA"
					EndIf
					*/

					If SC5->C5_XSTARES == "0"
						SC5->C5_XPRIORI := ' '
					EndIf

					SC5->C5_XTIPF    := '1'    //Giovani Zago 26/06/13 solicita็ใo Simone Soares Gravar Pedido como total quando gera os

					SC5->C5_XBLQFMI  := 'S'//Giovani Zago	06/06/2014 tratamento para bloquear faturamento minimo apos a NF

					If nReserva > 0
						U_STGrvSt(cDoc)//Giovani Zago 01/07/13
					EndIf

					SC5->(MsUnLock())

					//FR - adiciona as OS's geradas num array que serแ usado para enviar por email a informa็ใo das OS's Gerada 1 OS para N Pedidos
					//If Ascan(aOsGer, cOrdSep) == 0
					//	Aadd(aOSGer, cOrdSep)
					//Endif

				End Transaction
				SC5->( DBRUnlock() )   // Ticket: 20210609009722 - Valdemir Rabelo 06/09/2021
			Else
				FWMsgRun(,{|| Sleep(3000)},"Informativo","Pedido: "+SC5->C5_NUM+" Estแ em uso por outro usuแrio e nใo serแ processado.")
			Endif

		Else

			cOrdSep	 := " "
			cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

			CB7->(DBSETORDER(1))
			Do while CB7->(dbseek(xfilial("CB7")+cOrdSep))

				cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )

			Enddo

			CB7->(ConfirmSX8())

			SC2->(DbGoto(aDocs[nx,Len(aDocs[nx])]))

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			aItens	:= U__CheckPA0(2)

			If lMudaQtd
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				If ! U_MudaSD4(aItens,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
					Return
				EndIf
			EndIf

// FMT - Consultoria - JUN/2021
			If GetMv("STFSFA1001",,.T.)
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				aItens := U_LibQtdCB7( SC2->(C2_NUM+C2_ITEM+C2_SEQUEN), aItens)

				If Len(aItens) < 1
					Return
				Endif
			EndIf
// FMT - Consultoria - JUN/2021

//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
//Se nใo for 1 OS para N pedidos, cria o n๚mero da OS aqui dentro, e serแ 1 OS para cada PEDIDO
			If !l1PN
				For nY:= 1 to len(aItens)
					If aItens[nY,4] <> cArmSel .AND. SuperVal(StrTran(aItens[nY,8],".","")) <> 0
						cOrdAux := GetSX8Num( "CB7", "CB7_ORDSEP" )
						CB7->(ConfirmSX8())
						Exit
					EndIf
				Next
			Endif
//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672

			lDifArm	:= .F.
			For nY:= 1 to len(aItens)
				If !Empty(cArmAnt) .And. cArmAnt <> aItens[nY,4] .AND. SuperVal(StrTran(aItens[nY,8],".","")) <> 0
					lDifArm := .T.
					Exit
				EndIf
				cArmAnt := aItens[nY,4]
			Next

//Begin Transaction   //retirado pois estava gerando os duplicada
			For nY:= 1 to len(aItens)
				cDoc		:= SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
				cProduto	:= aItens[nY,5]
				cArm		:= aItens[nY,4]
				nRecno		:= aItens[nY,len(aItens[nY])]
				_nReserv	:= SuperVal(StrTran(aItens[nY,8],".",""))

				aSD4 := {nRecno}
				If _nReserv > 0
					U_STReserva	(cDoc,cProduto,_nReserv,"-",cFilAnt)
					U_STGrvSt	(cDoc)
					//				U_STGeraSDC	(cDoc,cProduto,cArm,_nReserv,nRecno,aSD4,cOrdSep)
					U_STGeraSDC	(cDoc,cProduto,cArm,_nReserv,nRecno,aSD4,IIf(cArm=="03",cOrdAux,cOrdSep)) //alterado dia 200613 [Renato Nogueira]
					U_STGeraOS	("SC2",cOrdSep,aSD4,cOrdAux,cArmSel,lDifArm)
				EndIf
			Next

			If SC2->C2_XSTARES == "0"
				SC2->(RecLock('SC2'))
				SC2->C2_XPRIORI := ''
				SC2->(MsUnLock())
			EndIf
//End Transaction     //retirado pois estava gerando os duplicada
		Endif
	Next

//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	If l1PN .and. !lJob
		If !IsBlind()
			MsgInfo("ORDEM DE SEPARAวรO GERADA: " + cOrdSep)
		Endif
	Endif

	If Len(_aEmaReab) > 1
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		U_REABMA(_aEmaReab)
	EndIf


Return()

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function TemAux(aItens,cArmSel,nPosArm)
User Function TemAux(aItens,cArmSel,nPosArm)
	Local nX
	For nX:= 1 to len(aItens)
		If aItens[nX,nPosArm] == cArmSel
			Return .t.
		EndIf
	Next

Return .f.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadSC5	บAutor  ณMicrosiga           บ Data ณ  03/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManuten็ใo da Reserva		                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAFAT                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function LoadSC5(nQtdDoc,aCabDoc,cMsgLog,aParam,lJob)
User Function LoadSC5(nQtdDoc,aCabDoc,cMsgLog,aParam,lJob,l1PN)
	Local aArea 		:= GetArea()
	Local aAreaSC5		:= SC5->(GetArea())
	Local aRet 			:= {}
	Local aAux 			:= {}

	Local nX			:= 0
	Local aTipoEntrega 	:= RetSx3Box(Posicione('SX3', 2, "C5_XTIPO", 'X3CBox()' ),,, 1 )//RetSx3Box(Posicione("SX3",2,"C5_XTIPO","X3_CBOX"),,,14)
	Local aTipoFatura 	:= RetSx3Box(Posicione('SX3', 2, "C5_XTIPF", 'X3CBox()' ),,, 1 )// RetSx3Box(Posicione("SX3",2,"C5_XTIPF","X3_CBOX"),,,14)
	//Local lBlqCred		:= .F.
	//Local cMV_XCTRANS	:= SuperGetMV("MV_XCTRANS",,"02504301|03346702|05350001")

	//Jair Ribeiro
	Local nValorMin		:= 0
	Local nValorPed		:= 0
	Local lBloqVal		:= .T.
	Local nValorSCH     := 0
	Local nValorSTK     := 0

	//Renato/Leo -> Verificacao de OS duplicada
	Local lAvalSC6		:= .T.
	Local aAvalSC6		:= {}

	//Leo -> Verificacao se o cliente e' a propria STECK
	//Local cMV_XSTCLI	:= SuperGetMV("MV_XSTCLI2",.F.,"033467") // Alterado pelo chamado 005430 - Robson Mazzarotto
	Local _cCond        :=  ' '//Giovani zago 24/05/13     mit006 ajuste no valor minimo
	Local _nGetCond     :=  GetMv("ST_VALMIN",,400)//Giovani zago 24/05/13  mit006 ajuste no valor minimo
	//Local _cFa10Oper    :=  GetMv("ST_FAOPER",,'74')//Giovani zago 14/06/2013 Tipos de Opera็ใo que nao entram na separa็ใo
	//Local _cOperFa10    := ' ' //Giovani zago 14/06/2013 Tipos de Opera็ใo que nao entram na separa็ใo
	Local aBarras       :=  {} //Giovani zago 24/05/13 mit006 ajuste no valor minimo
	Local _nDivCond     :=  0//Giovani zago 24/05/13  mit006 ajuste no valor minimo

	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Local nTOTLINHAS    := 0 					//conta qtas linhas acumuladas de itens de pedidos para limitar a 199
	Local nLimitaLin    := GetNewPar("ST_1OSPN" , 170)		//limita qtde de linhas de itens por cliente //FR - 15/09/2022 - Kleber pediu para diminuir para 170
	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672

	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= 'loadsc5'+cHora+ cMinutos+cSegundos

	Default aParam		:= {} 	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Default lJob		:= .F.  //FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	Default l1PN        := .F.

	//If msgyesno("Deseja novo Filtro ?")

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Processa( {|lEnd| U_STQUELOADSC5(aParam,lJob,l1PN)}, "Aguarde...", "SELECIONANDO REGISTROS", .T. )

	/*********************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Corre็ใo na Query que estava chumbado a tabela para empresa 010 sendo que agora a empres a้ a 110
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 11/01/2022
	Chamados.....: 20220107000504
	*********************************************/
	_cUpdate := " DELETE "+RetSqlName("PA2")+" PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_QUANT=0
	TcSqlExec(_cUpdate)
	
	_cUpdate := " DELETE "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_=' ' AND PA1_QUANT=0
	TcSqlExec(_cUpdate)

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			dbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			SC5->(DbGoTo(	(cAliasLif)->C5REC  ))

			if SC5->( Rlock() )     // Tiket: 20210609009722 - Valdemir Rabelo 03/11/2021
			   U_STGrvSt(SC5->C5_NUM,Nil)		//FR - GRAVA STATUS NA SC5
			   SC5->( DBRUnlock() )
			else 
				(cAliasLif)->(DbSkip())
				Loop
			endif

			If AllTrim(SC5->C5_XSTARES)=="2"
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			lAvalSC6 := .T.    //230413 abre nao gera os duplicada
			aAvalSC6 := {}
			aAdd(aAvalSC6,SC5->C5_NUM)

			//	If  (Stod(IIF(SC5->C5_XMATE < substr(dtos(date()),5,2) ,Soma1(substr(dtos(date()),1,4)),substr(dtos(date()),1,4))+SC5->C5_XMATE+SC5->C5_XATE) > dDataBase)

			If  (Stod(SC5->C5_XAANO+SC5->C5_XMATE+SC5->C5_XATE) >= dDataBase) .And. (Stod(SC5->C5_XDANO+SC5->C5_XMDE+SC5->C5_XDE) <= dDataBase)

				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If GetMv("ST_TRIPED",,.T.) .And.  !(Empty(Alltrim(SC5->C5_XPEDTRI ))) .And. SC5->C5_XTIPF <> '1'

				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If !lAvalSC6  .Or. Len(aAvalSC6) == 0
				(cAliasLif)->(DbSkip())
				Loop
			EndIf
			//230413 fecha nao gera os duplicada

			//giovani zago	02/02/2017 chamado 005110
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				If GetMv("ST_FINLIB",,.F.)
					If SA1->A1_XBLQFIN=="1"
						//cMsgLog+=   "Cliente bloqueado Fin."
						(cAliasLif)->(DbSkip())
						Loop

					EndIf
				EndIf

			EndIf

			//20200622003235
			If AllTrim(SC5->C5_CONDPAG)=="501" .And. !AllTrim(SC5->C5_XLIBAVI)=="S"
				(cAliasLif)->(DbSkip())
				Loop			
			EndIf

			/*	IF !U_INVCBA(SC5->C5_NUM) // Nใo permitir gerar OS para pedidos com itens em invetario rotativo. Robson Mazzarotto
			(cAliasLif)->(DbSkip())
			Loop
			ENDIF
			*/
			/*	DESATIVADO GIOVANI ZAGO 30/04/18
			If TemDF(SC5->C5_NUM)
			cMsgLog+= "Pedido:"+SC5->C5_NUM+" pend๊ncia no dep๓sito fechado."+chr(13)+chr(10)
			(cAliasLif)->(DbSkip())
			Loop
			Endif
			*/

	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	If l1PN
		nTOTLINHAS += U_QTDSC6(SC5->C5_NUM,"")
	Endif

	If nTOTLINHAS <= nLimitaLin  //se nใo for 1 OS para N Pedidos esse nTOTLINHAS sempre serแ zero e no caso, menor que nLimitaLin
		nQtdDoc--
		aAux 	:= Array(Len(aCabDoc)+2)
		IF !lJob
		aAux[1]	:= .F.
		ELSE 
           aAux[1]	:= .T.
		ENDIF   

		//Jair Ribeiro
		nValorMin		:= 0
		nValorPed		:= 0
		nValorSCH       := 0
		nValorSTK       := 0
		lBloqVal		:= .T.

		For nx:= 1 to len(aCabDoc)

			If aCabDoc[nx] == "C5_XTIPO"
				aAux[nx+1] :=	aTipoEntrega[val(SC5->C5_XTIPO),3]   //Leonardo Flex -> C5_XTIPO nao pode estar vazio
			ElseIf aCabDoc[nx] == "REABASTECIMENTO"
				aAux[nx+1] :=	SC5->C5_XEMPENH
				nValorMin 	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_XVLRMIN")

				_cCond  := Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_COND")
				If At(",",_cCond) > 0
					aBarras :=StrTokArr( _cCond, ',' )
					_nDivCond := len(aBarras)
				Else
					_nDivCond := 1
				EndIf
				//***************************************************************************************
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			ElseIf aCabDoc[nx] == "QTD_LIN"
				aAux[nx+1] :=	U_QTDSC6(SC5->C5_NUM,"")
			ElseIf aCabDoc[nx] == "LIN_SCH"
				aAux[nx+1] :=	U_QTDSC6(SC5->C5_NUM,"SCH")
			ElseIf aCabDoc[nx] == "LIN_STK"
				aAux[nx+1] :=	U_QTDSC6(SC5->C5_NUM,"STK")
			ElseIf aCabDoc[nx] == "C5_XTIPF"
				aAux[nx+1] := aTipoFatura[val(SC5->C5_XTIPF),3]

				//Jair Ribeiro
			ElseIf aCabDoc[nx] == "E4_XVLRMIN"
				aAux[nx+1] 	:= GetAdvFval("SE4","E4_XVLRMIN",xFilial("SE4")+SC5->C5_CONDPAG,1,0)
				nValorMin 	:= aAux[nx+1]

				//Giovani Zago 24/05/13 valor minimo de acordo com a qtd de parcelas; mit006 ajuste no valor minimo
				_cCond  :=   GetAdvFval("SE4","E4_COND",xFilial("SE4")+SC5->C5_CONDPAG,1,0)
				If At(",",_cCond) > 0
					aBarras :=StrTokArr( _cCond, ',' )
					_nDivCond := len(aBarras)
				Else
					_nDivCond := 1
				EndIf
				//***************************************************************************************

			ElseIf aCabDoc[nx] == "C6_VALOR"
				aAux[nx+1]	:= U_STFSXRES(SC5->C5_NUM) //FRetSldC6(SC5->C5_NUM) Leonardo Flex -> Incluido funcao para buscar o valor dos itens reservado
				nValorPed 	:= aAux[nx+1]

			ElseIf aCabDoc[nx] == "VLR_SCH"				// Valdemir Rabelo 25/04/2022
				aAux[nx+1]	:= U_STFSXRES(SC5->C5_NUM, 'SCH')
				nValorSCH 	:= aAux[nx+1]

			ElseIf aCabDoc[nx] == "VLR_STK"				// Valdemir Rabelo 25/04/2022
				aAux[nx+1]	:= U_STFSXRES(SC5->C5_NUM, 'STK')
				nValorSTK 	:= aAux[nx+1]

			ElseIf aCabDoc[nx] == "C5_XBLQFMI"
				aAux[nx+1] 	:= SC5->(FieldGet(FieldPos(aCabDoc[nx])))
				lBloqVal	:= (Upper(aAux[nx+1]) == "S")
			ElseIf aCabDoc[nx] == "RESERVA" //Giovani Zago 04/07/13 solicita็ใo simone soares coluna de valor reservado do pedido
				aAux[nx+1]	:= U_STRESFAB(SC5->C5_NUM,'1',' ')
			Else
				aAux[nx+1] := SC5->(FieldGet(FieldPos(aCabDoc[nx])))
			EndIf

		Next


		If !lBloqVal
			//aAux[1]	:= .T.
			aAux[nX+1] := SC5->(Recno())
			aadd(aRet,aClone(aAux))
		EndIf

	Endif //nTOTLINHAS

	(cAliasLif)->(dbskip())

Enddo

EndIf

If Empty(aRet)
	aAux := Array(Len(aCabDoc)+2)
	aAux[1] := .f.
	aadd(aRet,aClone(aAux))
EndIf
RestArea(aAreaSC5)
RestArea(aArea)
Return aClone(aRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function QTDSC6(_cQtdC6, pTIPO)
//Fun็ใo: QTDSC6 - Objetivo: Obter a quantidade de itens que existe no pedido por contagem COUNT(*) versus a tabela PA2 (Reservas)
User Function QTDSC6(_cQtdC6, pTIPO)

	Local cQuery     	:= ' '
	Local _nRet     	:= 0
	Local _cCond        := ""
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasSuper   	:= "QTDC6"+cHora+ cMinutos+cSegundos
	DEFAULT pTIPO           := ""

	// ---- Valdemir Rabelo 25/04/2022 - Chamado: 20220407007598
	if pTipo == "SCH"
		_cCond := " AND SB1.B1_XCODSE = 'S' "
	elseif pTipo == "STK"
		_cCond := " AND (SB1.B1_XCODSE = 'N' OR  SB1.B1_XCODSE=' ') "
	endif
	// ------------------
	cQuery := " SELECT NVL(COUNT(*),0) AS QTDC6 " + CRLF
	cQuery += "  FROM "+RetSqlName("SC6")+" SC6 " + CRLF
	cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("PA2")+") PA2 " + CRLF
	cQuery += "  ON SC6.C6_FILIAL = PA2.PA2_FILRES AND SC6.C6_NUM||SC6.C6_ITEM=PA2.PA2_DOC AND PA2.D_E_L_E_T_=' ' " + CRLF
	IF !EMPTY(pTIPO)			// ---- Valdemir Rabelo 25/04/2022 - Chamado: 20220407007598
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 " + CRLF
		cQuery += "  ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	ENDIF
	cQuery += "  WHERE SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  AND  SC6.C6_NUM = '"+_cQtdC6+"' " + CRLF
	cQuery += _cCond

	If cEmpAnt=="01"
		cQuery += "  AND SC6.C6_FILIAL = '02'
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		_nRet:= (cAliasSuper)->QTDC6

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return (_nRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function TemBloqueio()
User Function TemBloqueio()
	Local aSC6Area	:= SC6->(GetArea())
	Local aArea		:= GetArea()
	Local lRet 		:= .F.
	Local nSaldo	:= 0
	Local aSaldos	:= {}

	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	If !SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
		SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+SC5->C5_NUM)
			nSaldo := SC6->(C6_QTDVEN - C6_QTDENT)
			If nSaldo > 0
				nRecno:= SC6->(Recno())
				aSaldos := {{ "","","","",nSaldo,ConvUm(SC6->C6_PRODUTO,0,2,nSaldo),Ctod(""),"","","",SC6->C6_LOCAL,0}}
				MaLibDoFat(SC6->(Recno()),nSaldo,.T.,.T.,.T.,.T.,.F.,.F.,Nil,Nil,aSaldos,Nil,Nil,Nil)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				SC6->(DbGoto(nRecno))
			Endif
			SC6->(DbSkip())
		End
		SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
	Endif

	While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO == xFilial("SC9")+SC5->C5_NUM)
		If Empty(SC9->C9_ORDSEP) .and. ! (SC9->C9_BLCRED+"*" $ "  *10*")
			lRet := .t.
			Exit
		EndIf
		SC9->(DbSkip())
	End

	RestArea(aSC6Area)
	RestArea(aArea)
Return lRet

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function TemDF(cDoc)
User Function TemDF(cDoc)
	Local aPA2Area := PA2->(GetArea())
	Local aArea		:= GetArea()
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local lRet		:= .F.

	PA2->(DBSetOrder(4))
	lRet := PA2->(DBSeek(xFilial('PA2')+cFilDP+cDoc))

	RestArea(aPA2Area)
	RestArea(aArea)

Return lRet

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function LoadSC2(nQtdDoc,aCabDoc,cMsgLog)
User Function LoadSC2(nQtdDoc, aCabDoc, cMsgLog)
	Local aArea 	:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local aRet 		:= {}
	Local aAux 		:= {}
	Local nX			:= 0
	//Local cHora     := ' '
	Private  cAliasLif   	:= ' '

	///If msgyesno('Novo Filtro ?')
	//	cHora:=TIME()
	//Giovani Zago otimiza็ใo da query
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Processa( {|lEnd| U_STQUESC2LOAD()}, "Aguarde...", "SELECIONANDO REGISTROS", .T. )

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			dbSelectArea("SC2")
			SC2->(DbSetOrder(1))
			//	SC2->(DbSeek(xFilial('SC2')+'0',.T.))
			If	SC2->(DbSeek(xFilial('SC2')+(cAliasLif)->C2_NUM+(cAliasLif)->C2_ITEM+(cAliasLif)->C2_SEQUEN) )
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				If U_TemDF(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
					cMsgLog+= "Ordem de produ็ใo:"+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+" com pend๊ncia no dep๓sito fechado."+chr(13)+chr(10)
					(cAliasLif)->(DbSkip())
					Loop
				EndIf

				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				If !U__CheckPA0(1)              //nใo gerar os duplicada para op 240413 abre      renato

					Reclock("SC2",.F.)
					SC2->C2_XSTARES	:= ""

					(cAliasLif)->(DbSkip())
					Loop
				EndIf              			//nใo gerar os duplicada para op 240413 fecha     renato

				nQtdDoc--
				aAux := Array(Len(aCabDoc)+2)
				aAux[1] := .t.
				For nx:= 1 to len(aCabDoc)
					aAux[nx+1] := SC2->(FieldGet(FieldPos(aCabDoc[nx])))
				Next
				aAux[nX+1] := SC2->(Recno())
				aadd(aRet,aClone(aAux))
				(cAliasLif)->(DbSkip())

			EndIf
		End

	EndIf

	/*
	//Else
	cHora:=TIME()
	SC2->(DbOrderNickName("STFSSC201"))
	SC2->(DbSeek(xFilial('SC2')+'0',.T.))
	While SC2->(! Eof()) .and. nQtdDoc > 0
	If ! SC2->C2_XSTARES $ "14"
	SC2->(DbSkip())
	Loop
	EndIf

	If TemDF(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
	cMsgLog+= "Ordem de produ็ใo:"+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+" com pend๊ncia no dep๓sito fechado."+chr(13)+chr(10)
	SC2->(DbSkip())
	Loop
	EndIf

	If !_CheckPA0(1)              //nใo gerar os duplicada para op 240413 abre      renato

	Reclock("SC2",.F.)
	SC2->C2_XSTARES	:= ""

	SC2->(DbSkip())
	Loop
	EndIf              			//nใo gerar os duplicada para op 240413 fecha     renato

	nQtdDoc--
	aAux := Array(Len(aCabDoc)+2)
	aAux[1] := .t.
	For nx:= 1 to len(aCabDoc)
	aAux[nx+1] := SC2->(FieldGet(FieldPos(aCabDoc[nx])))
	Next
	aAux[nX+1] := SC2->(Recno())
	aadd(aRet,aClone(aAux))
	SC2->(DbSkip())
	End
	EndIf
	MsgAlert( ELAPTIME(cHora, TIME()) )
	*/
	If Empty(aRet)
		aAux := Array(Len(aCabDoc)+2)
		aAux[1] := .f.
		aadd(aRet,aClone(aAux))
	EndIf

	RestArea(aAreaSC2)
	RestArea(aArea)
Return aClone(aRet)

/*
ฑฑบPrograma  ณSelDoc	บAutor  ณMicrosiga           บ Data ณ  03/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de selecao de documentos                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAFAT                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function SelDoc(aCabDoc,aDocs,cTitulo,cMsgLog,lMuda,lAloca,lDesaloca)
User Function SelDoc(aCabDoc,aDocs,cTitulo,cMsgLog,lMuda,lAloca,lDesaloca,l1PN,lJob)

	Local oPanel
	Local oPanel1
	Local oChk
	Local lChk 		:= .F.
	Local oDlg
	Local oLbx
	Local aCab		:= {}
	Local nX,i
	Local aButtons	:= {}
	Local lOk		:= .F.
	Local oChkQtd
	Local lChkQtd	:= .F.
	Local lStOper   := .T.//Giovani TOTVS     11/12/12
	Local aTMPDOC   := aClone(aDocs)

	//Jair Ribeiro
	Local nPosVlrM	:= (AsCan(aCabDoc,{|a| AllTrim(a) == "E4_XVLRMIN"}) +1)
	Local nPosVlrP	:= (AsCan(aCabDoc,{|a| AllTrim(a) == "C6_VALOR"}) +1)
	Local nPosBloq	:= (AsCan(aCabDoc,{|a| AllTrim(a) == "C5_XBLQFMI"}) +1)
	Local lCpoBloq	:= (nPosVlrM > 0 .and. nPosVlrP > 0 .and. nPosBloq > 0)

	//Leonardo Flex
	Local oTotalPed
	Local oTotalSel
	Local nTotalPed	:= 0
	Local nTotalSel	:= 0
	Local _aDox 	:= {}
	Local aTipo 	:= {}   // Valdemir Rabelo 02/04/2020

	// Eduardo Pereira - Sigamat
	Local oPesqPed
	Local cPesqPed	:= Space(06)
	Local oTotLinh
	Local nTotLinh	:= 0
	Local oVlrLiq
	Local nVlrLiq	:= 0

	Default cMsgLog := ""

	Default lJob    := .F.
	Default l1PN    := .F.

	Private aSize   := MsAdvSize()

	aAdd(aCab," ")

	For nX := 1 to Len(aCabDoc)
		If Alltrim(aCabDoc[nX]) = "QTD_LIN"
			aAdd(aCab,"Nr.Linhas")
		ElseIf (Alltrim(aCabDoc[nX]) = "LIN_SCH") .And. (!lAloca)       // Valdemir RAbelo 25/04/2022
			aAdd(aCab,"Nr.Lin SCH")
		ElseIf (Alltrim(aCabDoc[nX]) = "LIN_STK") .And. (!lAloca) // Valdemir RAbelo 25/04/2022
			aAdd(aCab,"Nr.Lin STK")
		ElseIf Alltrim(aCabDoc[nX]) = "REABASTECIMENTO"
			aAdd(aCab,"Reabas.")
		ElseIf Alltrim(aCabDoc[nX]) = "RESERVA"
			aAdd(aCab,"Vlr.Res.Liq.")
		ElseIf (Alltrim(aCabDoc[nX]) = "VLR_SCH") .And. (!lAloca)
			aAdd(aCab,"Vlr.Schneider")
		ElseIf (Alltrim(aCabDoc[nX]) = "VLR_STK") .And. (!lAloca)
			aAdd(aCab,"Vlr.Steck")
		Elseif (Alltrim(aCabDoc[nX]) = "RECCB7") 	//FR - 05/10/2022 - Erro ao estornar - AJuste posicionamento de coluna 
			AADD(aCab, "Registro")
		Else
			aAdd(aCab,Alltrim(RetTitle(aCabDoc[nX])))
		EndIf
	Next
	//AADD(aCab, "Registro")	//FR - 05/10/2022 - Erro ao estornar - AJuste posicionamento de colunas 
	
	/**************************
	Altera็ใo....: Inclusใo do coluna Data de Emissใo para a Form de Gera็ใo de Ordem de Separa็ใo
	Desenvolvedor: Marcelo Klopfer Leme 
	Data.........: 16/11/2021
	**************************/
	//// Verifica se o tamanho do aCabDoc estแ contemplado a Data de Emissใo.
	IF LEN(aCabDoc) = 14
		aTipo := {'C','C','C','C','C','D','C','N','C','N','N','C','N','C'}
	ELSE
		aTipo := {'C','C','C','C','C','C','N','C','N','N','C','N','C','N','N','C','C','C','C','N'}    // Valdemir Rabelo 09/05/2022 Chamado: 20220407007598
		//aTipo := {'C','C','C','C','N','N','N','N'}
	ENDIF

	If lAloca .And. (Upper(aCab[3]) = 'PEDIDO VENDA')
	   // ------ Valdemir Rabelo 27/04/2022 Chamado: 20220407007598
   	   //FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	   U_AjCabec()		
	   aCab := {}
	   aEval(aPosAloc, {|X| aAdd(aCab, X[2]) })
	   aSize(aCab, Len(aPosAloc))

		// Valdemir Rabelo 27/04/2022 Chamado: 20220407007598
		aTipo := {}
		aEval(aPosAloc, {|X| aAdd(aTipo, X[3]) })

		nPDocSel := 1
		nPDocOS  := 2
		nPDocPV  := 3
		nPDOCRc  := 9
		// -------------------

		For nX := 1 to Len(aTMPDOC)
			
			If aTMPDOC[nX,nPDocSel]
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				U_SunCalcSel(.T.,.T.,aTMPDOC[nX,nPDocPV], @nTotalPed, Nil, @nTotalSel, Nil, aTMPDOC[nX,nPDocOS])
			EndIf
			// Valdemir Rabelo 27/04/2022 Chamado: 20220407007598
			If Valtype(aTMPDOC[nX,nPDocPV]) = 'C'
				asize(aTMPDOC[nX], 19) // Valdemir Rabelo 27/04/2022
				asize(aDocs[nX], 19)
				
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				aDocs[nX,U_PosAloc("Tp.Cliente")] :=  U_StTpClien(aTMPDOC[nX,nPDocOS])
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial("SC5")+alltrim(aTMPDOC[nX,nPDocPV]) ))
					aDocs[nX,U_PosAloc("Tp.PV")]  :=  Iif(SC5->C5_XTIPO ='1', 'Retira', 'Entrega')
				EndIf
				//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
				aDocs[nX,U_PosAloc("Qtd.Lin")]        := U_stlinhas(aTMPDOC[nX,nPDocOS],1)
				aDocs[nX,U_PosAloc("Qtd.Pe็a")]       := U_stlinhas(aTMPDOC[nX,nPDocOS],2)
				aDocs[nX,U_PosAloc("Almoxarifado")]   := U_stlinhas(aTMPDOC[nX,nPDocOS],3)
				aDocs[nX,U_PosAloc("Vlr. $")]         := U_STRESFAB(SC5->C5_NUM, '2' ,aTMPDOC[nX,nPDocOS])
				aDocs[nX,U_PosAloc("$ /Lin")]         := round(aDocs[nX,U_PosAloc("Vlr. $")] / aDocs[nX,U_PosAloc("Qtd.Pe็a")], 2) //Valdemir Rabelo 17/01/2020
				aDocs[nX,U_PosAloc("Ordem Produ็ใo")] := POSICIONE("CB7", 1, xFilial("CB7") + aTMPDOC[nX,nPDocOS], "CB7_OP")
				aDocs[nX,U_PosAloc("Data emissใo")]   := DtoC(POSICIONE("CB7", 1, xFilial("CB7") + aTMPDOC[nX,nPDocOS], "CB7_DTEMIS"))
				aDocs[nX,U_PosAloc("Tp.Pedido")]      := IIf(AllTrim(SC5->C5_XORIG)=="2","Pedido de internet","Pedido normal")
				aDocs[nX,U_PosAloc("Nr.Lin SCH")]     := U_stlinhas(aTMPDOC[nX,nPDocOS],1,"SCH")
				aDocs[nX,U_PosAloc("Nr.Lin STK")]     := U_stlinhas(aTMPDOC[nX,nPDocOS],1,"STK")
				aDocs[nX,U_PosAloc("Vlr Schneider")]  := U_STRESFAB(SC5->C5_NUM, '2' ,aTMPDOC[nX,nPDocOS], 'SCH' )
				aDocs[nX,U_PosAloc("Vlr Steck")]      := U_STRESFAB(SC5->C5_NUM, '2' ,aTMPDOC[nX,nPDocOS], 'STK' )
				aDocs[nX,U_PosAloc("Recno")]          := aTMPDOC[nX,nPDOCRc]

			EndIf
		Next nX
	
	EndIf

	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672
	If !lJob
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aAdd(aButtons,{"PAPEL_ESCRITO", {|| U_ExpExcel(aCab, aDocs, aTipo)}, "Exportar para planilha"})	// Valdemir Rabelo 02/04/2020 - Ticket: 20200401001391

		If !Empty(cMsgLog)
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			aAdd(aButtons,{"PAPEL_ESCRITO", {|| U_LogOS(cMsgLog)},"Log"})
		EndIf

		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
		oPanel := TPanel():New( 010, 010, ,oDlg, , , , , , 14, 14, .F.,.T. )
		oPanel:align := CONTROL_ALIGN_TOP
		oPanel1 := TPanel():New( 010, 010, ,oDlg, , , , , , 70, 70, .F.,.T. )
		oPanel1:align := CONTROL_ALIGN_ALLCLIENT
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		@ 002 ,002 CHECKBOX oChk VAR lChk PROMPT "Inverte sele็ใo" 	SIZE 70,7 	PIXEL OF oPanel ON Click( aEval( aDocs, { |x| x[1] := !x[1] } ), U_ValidOS(oLbx, aDocs, oTotLinh, @nTotLinh, oVlrLiq, @nVlrLiq, "T", lAloca, lDesaloca), U_InvSel(aDocs, lAloca, @nTotalPed, oTotalPed, @nTotalSel, oTotalSel, oTotLinh, @nTotLinh, oVlrLiq, @nVlrLiq, lDesaloca), oLbx:Refresh() )
		// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Inicio
		If !lAloca .And. !lDesaloca .And. !IsInCallStack("DeleCB7")
			@ 003,200 Say "Pedido" PIXEL of oPanel
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			@ 001,220 MsGet oPesqPed Var cPesqPed Picture "@!" PIXEL of oPanel SIZE 60,10 Valid U_PesqNumP(@aDocs,@cPesqPed,oLbx,@nTotLinh,@nVlrLiq)
			@ 003,350 Say "Tot. Linhas" PIXEL of oPanel
			@ 001,380 MsGet oTotLinh Var nTotLinh Picture "@E 99999" PIXEL of oPanel When .F. SIZE 50,10
			@ 003,500 Say "Vlr. Liquido" PIXEL of oPanel
			@ 001,530 MsGet oVlrLiq Var nVlrLiq Picture "@E 99,999,999.99" PIXEL of oPanel When .F. SIZE 80,10
		EndIf
		// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Fim
		If lMuda <> NIL
			lChkQtd:= lMuda
			@ 002 ,080 CHECKBOX oChkQtd VAR lChkQtd PROMPT "Altera quantidade" 	SIZE 70,7 	PIXEL OF oPanel //ON CLICK( lChkQtd:= !lChkQtd )
		EndIF

		If lAloca
			@ 002,135 Say "Qtde.Pedidos Selecionados" PIXEL of oPanel
			@ 001,205 MsGet oTotalPed Var nTotalPed Picture "@E 999999" PIXEL of oPanel When .F. SIZE 50,09

			@ 002,273 Say "Qtde.Itens dos Pedidos Selecionados" PIXEL of oPanel
			@ 001,366 MsGet oTotalSel Var nTotalSel Picture "@E 999999" PIXEL of oPanel When .F. SIZE 50,09
		EndIf
		oLbx := TwBrowse():New(01,01,490,490,,aCab,, oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		oLbx:bLDblClick 	:= { || aDocs[oLbx:nAt,1]:= ! aDocs[oLbx:nAt,1], U_ValidOS(oLbx, aDocs, oTotLinh, @nTotLinh, oVlrLiq, @nVlrLiq, "", lAloca, lDesaloca), U_SunCalcSel(aDocs[oLbx:nAt,1], lAloca, aDocs[oLbx:nAt,3], @nTotalPed, oTotalPed, @nTotalSel, oTotalSel, aDocs[oLbx:nAt,2])}

		oLbx:align 			:= CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDocs )
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		oLbx:bLine 			:= {|| U_Retbline(oLbx,aDocs) }
		oLbx:Refresh()
		
		U_exemploa(oLbx,oDlg,aCabDoc,aDocs,034,1310)		//FR - 05/07/2021
		
		If !l1PN
			ACTIVATE MSDIALOG oDlg on init EnchoiceBar( oDlg, {|| lOK := .T., lMuda := lChkQtd, oDlg:End()}, {|| oDlg:End() },,aButtons ) CENTERED
		Else 
			//SE FOR 1 OS PARA N PEDIDOS, VALIDA POR VALOR MอNIMO A SELEวรO: 
			ACTIVATE MSDIALOG oDlg on init EnchoiceBar( oDlg, {|| lOK := U_fValMIN(nVlrLiq), lMuda := lChkQtd, oDlg:End()}, {|| oDlg:End() },,aButtons ) CENTERED
		Endif 
		

		If ! lOk
			aDocs:={}
		EndIf
		//giovani Zago 27/08/13 IBL tipo de cliente
		If lAloca .And. (upper(aCab[3]) = 'PEDIDO VENDA')
			For nX := 1 to Len(aDocs)
				asize(aDocs[nX], 5)
			Next
		EndIf
		//=========================================
	Else

		//faz a marca็ใo porque via job nใo tem como usuแrio marcar [x]
		//nTOTC6    := 0  //traz o valor total do pedido
		//nTOTGERC6 := 0  //acumula o total e verifica se estแ dentro do valor mํnimo para aglutinar
		For i := 1 To Len(aDocs)
			aDocs[i,1] := .T.			
			nVlrLiq		+= aDocs[i][14]   //acumula o valor lํquido para comparar se estแ dentro do valor mํnimo para aglutinar 1 OS para N Pedidos			
		Next

		lOK := U_fValMIN(nVlrLiq)

	Endif //lJob
	//FR - 25/07/2022 - Flแvia Rocha - Sigamat Consultoria - Ticket 1 OS para N Pedidos #20220606011672

	//Giovani TOTVS     11/12/12
	If lOk .And. "Aloca็ใo" $ cTitulo .And. Len(aDocs) > 0 .And. aDocs[1,2] <> Nil
		For i := 1 To Len(aDocs)
			If aDocs[i,1]
				CB8->( dbSetOrder(1) )
				If  CB8->( dbSeek(xFilial('CB8') + aDocs[i,2]) )
					cOperCb7 := CB8->CB8_LOCAL
					While CB8->(! Eof()) .And. aDocs[i,2] = CB8->CB8_ORDSEP
						If cOperCb7 <> CB8->CB8_LOCAL
							lStOper := .F.
						EndIf
						CB8->( dbSkip() )
					End
				EndIf
			EndIf
		Next i
		If !lStOper
			cCB1FILTRO := " "
		Else
			cCB1FILTRO :=	cOperCb7
		EndIf
	ElseIf lOk .And. !("Aloca็ใo" $ cTitulo) .And. Len(aDocs) > 0 .And. aDocs[1,2] == Nil
		aDocs := {}
	ElseIf lOk .And. !("Aloca็ใo" $ cTitulo)
		cCB1FILTRO := cCB1FILTRO
	EndIf
	//===================================================================================
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function InvSel(aDocs, lAloca, nTotalPed, oTotalPed, nTotalSel, oTotalSel, oTotLinh, nTotLinh, oVlrLiq, nVlrLiq, lDesaloca)
User Function InvSel(aDocs, lAloca, nTotalPed, oTotalPed, nTotalSel, oTotalSel, oTotLinh, nTotLinh, oVlrLiq, nVlrLiq, lDesaloca)
	Local nX := 0
	If lAloca
		For nX := 1 to Len(aDocs)
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			U_SunCalcSel(aDocs[nX,1], .T., aDocs[nX,3], @nTotalPed, oTotalPed, @nTotalSel, oTotalSel, aDocs[nX,2])
		Next
	// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Inicio
	Else
		If !lAloca .And. !lDesaloca .And. !IsInCallStack("U_DeleCB7")  //FR - 05/10/2022 - Erro ao estornar 
			lInvert := .F.
			For nX := 1 to Len(aDocs)
				If aDocs[nX,1]
					lInvert := .T.
					If Len(aDocs[nX]) >= 9
						nTotLinh += aDocs[nX,9]  //FR - 05/10/2022 - Erro ao estornar - dava erro aqui porque esta posi็ใo 9 nใo existe 
					Endif 
					If Len(aDocs[nX])>=14
						nVlrLiq	 += aDocs[nX,14] //FR - 05/10/2022 - Erro ao estornar - dava erro aqui porque esta posi็ใo 14 nใo existe 
					Endif 
				Else
					If Len(aDocs[nX]) >= 9
						nTotLinh -= aDocs[nX,9]
					Endif 
					If Len(aDocs[nX]) >= 14
						nVlrLiq	 -= aDocs[nX,14]
					Endif 
				EndIf
			Next
			If !lInvert
				nTotLinh := 0
				nVlrLiq	 := 0
			EndIf
			oTotLinh:Refresh()
			oVlrLiq:Refresh()
		EndIf
	// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Fim
	EndIf

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function SunCalcSel(lSelec, lAloca, cPedido, nTotalPed, oTotalPed, nTotalSel, oTotalSel, _cxOs)
User Function SunCalcSel(lSelec, lAloca, cPedido, nTotalPed, oTotalPed, nTotalSel, oTotalSel, _cxOs)

	Local aArea := GetArea()

	If lAloca
		/*
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6") + cPedido)
		While !Eof() .And. C6_FILIAL == xFilial("SC6") .And. C6_NUM == cPedido
			If lSelec
				nTotalSel++
			Else
				nTotalSel--
			EndIf
			dbSkip()
		EndDo

		*/
	dbSelectArea("CB8")
	CB8->( dbSetOrder(1) )
	CB8->( dbSeek(xFilial('CB8') + _cxOs))
	While CB8->( !Eof() .And. CB8_FILIAL+CB8_ORDSEP == xFilial('CB8') + _cxOs)
		If lSelec
			nTotalSel++
		Else
			nTotalSel--
		EndIf
		dbSkip()
	EndDo

	If lSelec
		nTotalPed++
	Else
		nTotalPed--
	EndIf
	If oTotalPed <> Nil .And. oTotalSel <> Nil
		oTotalPed:Refresh()
		oTotalSel:Refresh()
	EndIf
EndIf

RestArea(aArea)

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function LogOS(cMemo)
User Function LogOS(cMemo)
	Local oDlg
	Local oFont
	Local oMemo

	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
	DEFINE MSDIALOG oDlg TITLE "Log" From 3,0 to 340,417 PIXEL

	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL   //145
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	ACTIVATE MSDIALOG oDlg CENTER

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function RetbLine(oLbx,aDocs)
User Function RetbLine(oLbx,aDocs)
	Local nx
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" )
	Local aRet	:= {}

	For nX := 1 to len(aDocs[oLbx:nAt])
		If nX==1
			If aDocs[oLbx:nAt,1]
				aadd(aRet,oOk)
			Else
				aadd(aRet,oNo)
			EndIf
		Else
			aadd(aRet,aDocs[oLbx:nAt,nX])
		EndIf
	Next
Return aclone(aRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function LoadCB7(aCabDoc,cArmSel,cCodOpe,lNaoOsPai,lChkFilho,cMsgLog,lDesaloca)
User Function LoadCB7(aCabDoc,cArmSel,cCodOpe,lNaoOsPai,lChkFilho,cMsgLog,lDesaloca)
	Local aArea 		:= GetArea()
	Local aAreaCB7		:= CB7->(GetArea())
	Local aRet 			:= {}
	Local aAux 			:= {}
	Local nX			:= 0
	//Giovani Zago 07/06/2013
	Local cTime           := Time()
	Local cHora           := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAliasLif   	:= 'cb8'+cHora+ cMinutos+cSegundos
	Local cQuery        := ' '
	//*************************************************************
	//Local cArmProd	:= GetMv("FS_LOCPROD",.F.,"90") // Leonardo Flex -> Buscar CB8 com Local Padrao tanto para alocar como para desalocar
	Default cCodOpe		:= Space(6)
	Default lNaoOsPai	:= .f.
	Default lChkFilho	:= .f.
	Default lDesaloca	:= .f.

	ProcRegua(8)

	CB7->(DbOrderNickName("STFSCB702"))
	CB8->(DbOrderNickName("STFSCB801"))

	If lDesaloca
		IncProc()
		CB7->(DbSetOrder(1))
		//If msgyesno("Deseja novo Filtro ?")

		cQuery := ' SELECT  CB8_ORDSEP    ,CB8_QTDORI ,CB8_SALDOS    ,CB8_LOCAL
		cQuery += " FROM "+RetSqlName("CB8")+ ' CB8 '   "

		cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("CB7")+ ' )CB7 '    "
		cQuery += " ON CB7.CB7_ORDSEP = CB8.CB8_ORDSEP   "
		cQuery += " AND CB7.D_E_L_E_T_ = ' '    "
		If !Empty(Alltrim(cCodOpe))
			cQuery += " AND CB7.CB7_CODOPE  =  '"+cCodOpe+"'"
		EndIf
		//cQuery += " and CB7.CB7_XSEP = '1'
		cQuery += " AND ((CB7_STATUS='0') OR (CB7_STATUS='1' AND CB7_STATPA='1')) " //Chamado 001505
		cQuery += " and CB7.CB7_NOTA = ' '
		cQuery += " AND  CB7.CB7_FILIAL =  '"+xFilial("CB7")+"'"

		cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
		cQuery += " AND  CB8.CB8_FILIAL =  '"+xFilial("CB8")+"'"
		cQuery += " AND  CB8.CB8_LOCAL  =  '"+cArmSel+"'"
		//	cQuery += " AND  CB8.CB8_QTDORI <> CB8.CB8_SALDOS
		cQuery += " ORDER BY cb7_dtemis, cb7_ordsep

		//cQuery := ChangeQuery(cQuery)
		MemoWrite("C:\TEMP\LOADCB7.SQL" , cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		IncProc()
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		IncProc()

		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		If  Select(cAliasLif) > 0

			While 	(cAliasLif)->(!Eof())
				dbSelectArea("CB8")
				CB8->(DbSetOrder(1))
				CB8->(DbSeek(xFilial('CB8')+(cAliasLif)->CB8_ORDSEP))
				dbSelectArea("CB7")
				CB7->(DbSetOrder(1))
				CB7->(DbSeek(xFilial('CB7')+CB8->CB8_ORDSEP))

				//	If ! Empty(cCodOpe) .And. CB8->CB8_QTDORI <> CB8->CB8_SALDOS
				//		(cAliasLif)->(DbSkip())
				//		Loop
				//	EndIf

				//	If !CB7->(DbSeek(xFilial('CB7')+CB8->CB8_ORDSEP))
				//		CB8->(DbSkip())
				//		Loop
				//	EndIf

				/*
				If lChkFilho .and. ! Empty(CB7->CB7_XOSFIL)
				cMsgLog += "Ord Sep : "+CB7->CB7_ORDSEP+" tem O.S. Filho em andamento"+chr(13)+chr(10)
				(cAliasLif)->(DbSkip())
				Loop
				EndIf

				If lNaoOsPai .and. ! Empty(CB7->CB7_XOSPAI)  // se tem pai, portanto eh filho e nใo pode ser mostrado
				cMsgLog += "Ord Sep : "+CB7->CB7_ORDSEP+" tem O.S. Pai e nใo pode ser excluida"+chr(13)+chr(10)
				(cAliasLif)->(DbSkip())
				Loop
				EndIf
				*/
				If AsCan(aRet,{|X| AllTrim(X[2]) == CB8->CB8_ORDSEP}) > 0
					(cAliasLif)->(DbSkip())
					Loop
				EndIf

				aAux := Array(Len(aCabDoc)+2)
				aAux[1] := .t.
				For nX := 2 to Len(aAux)
					aAux[nX] :=  0
				Next
				For nx:= 1 to len(aCabDoc)
					//FR - 17/08/2022 - REVISรO DO POSICIONAMENTO DO RECNO DA CB7
					If aCabDoc[nx] = 'RECCB7'
						aAux[nX+1] := CB7->(Recno())
					Else
						aAux[nx+1] := CB7->(FieldGet(FieldPos(aCabDoc[nx])))
					Endif
				Next
				//FR - 17/08/2022 - REVISรO DO POSICIONAMENTO DO RECNO DA CB7
				//aAux[nX+1] := CB7->(Recno())
				aadd(aRet,aClone(aAux))

				(cAliasLif)->(DbSkip())
			EndDo
		EndIf

		CB7->(DbSetOrder(1))
		IncProc()
	EndIf
	cQuery := ' SELECT  CB8_ORDSEP    ,CB8_QTDORI ,CB8_SALDOS    ,CB8_LOCAL
	cQuery += " FROM "+RetSqlName("CB8")+ ' CB8 '   "
	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("CB7")+ ' )CB7 '    "
	cQuery += " ON CB7.CB7_ORDSEP = CB8.CB8_ORDSEP   "
	cQuery += " AND CB7.D_E_L_E_T_ = ' '    "
	cQuery += " and CB7.CB7_XSEP = '2'
	cQuery += " AND ((CB7_STATUS='0') OR (CB7_STATUS='1' AND CB7_STATPA='1')) " //Chamado 001505
	cQuery += " AND  CB7.CB7_FILIAL =  '"+xFilial("CB7")+"'"

	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5
	cQuery += " ON C5_FILIAL=CB7_FILIAL AND C5_NUM=CB7_PEDIDO AND C5.D_E_L_E_T_=' '

	cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	cQuery += " AND  CB8.CB8_FILIAL =  '"+xFilial("CB8")+"'"

	cQuery += " ORDER BY c5_xcanal desc, cb7_dtemis, cb7_ordsep
	MemoWrite("C:\TEMP\LOADCB7.SQL" , cQuery)
	//cQuery := ChangeQuery(cQuery)
	IncProc()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	IncProc()
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			dbSelectArea("CB8")
			CB8->(DbSetOrder(1))
			CB8->(DbSeek(xFilial('CB8')+(cAliasLif)->CB8_ORDSEP))

			If cArmSel=="01" .And. ((cAliasLif)->CB8_LOCAL=="03" .Or. (cAliasLif)->CB8_LOCAL=="90")      //130513
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If ! Empty(cCodOpe) .and. (cAliasLif)->CB8_QTDORI <> (cAliasLif)->CB8_SALDOS
				(cAliasLif)->(DbSkip())
				Loop
			EndIf
			dbSelectArea("CB7")
			CB7->(DbSetOrder(1))
			//If !CB7->(DbSeek( xFilial('CB7') + Padr( (cAliasLif)->CB8_ORDSEP, TamSx3("CB7_CODOPE")[1] ) ))
			If !CB7->(DbSeek( xFilial('CB7') + Padr( (cAliasLif)->CB8_ORDSEP, TamSx3("CB7_ORDSEP")[1] ) ))
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If lDesaloca .And. CB7->CB7_CODOPE <> cCodOpe
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If !lDesaloca .And. (!Empty(CB7->CB7_CODOPE) .Or. !Empty(CB7->CB7_XOPEXP))
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If lChkFilho .and. ! Empty(CB7->CB7_XOSFIL)
				cMsgLog += "Ord Sep : "+CB7->CB7_ORDSEP+" tem O.S. Filho em andamento"+chr(13)+chr(10)
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If lNaoOsPai .and. ! Empty(CB7->CB7_XOSPAI)  // se tem pai, portanto eh filho e nใo pode ser mostrado
				cMsgLog += "Ord Sep : "+CB7->CB7_ORDSEP+" tem O.S. Pai e nใo pode ser excluida"+chr(13)+chr(10)
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			If AsCan(aRet,{|X| AllTrim(X[2]) == CB8->CB8_ORDSEP}) > 0
				(cAliasLif)->(DbSkip())
				Loop
			EndIf

			aAux := Array(Len(aCabDoc)+2)
			aAux[1] := .t.
			For nx:= 1 to len(aCabDoc)
				If aCabDoc[nx] = 'NOME'
					aAux[nx+1] := Alltrim(Posicione("SA1",1,xFilial("SA1")+CB7->CB7_CLIENT+CB7->CB7_LOJA,"A1_NOME"))
					//FR - 17/08/2022 - REVISรO DO POSICIONAMENTO DO RECNO DA CB7
				Elseif aCabDoc[nx] = 'RECCB7'
					aAux[nX+1] := CB7->(Recno())
					//FR - 17/08/2022 - REVISรO DO POSICIONAMENTO DO RECNO DA CB7
				Else
					aAux[nx+1] := CB7->(FieldGet(FieldPos(aCabDoc[nx])))
				EndIf
			Next
			//aAux[nX+1] := CB7->(Recno())  //FR - 17/08/2022 - REVISรO DO POSICIONAMENTO DO RECNO DA CB7

			aadd(aRet,aClone(aAux))

			(cAliasLif)->(dbskip())

		End

	EndIf

	IncProc()

	If Empty(aRet)
		aAux := Array(Len(aCabDoc)+2)
		aAux[1] := .f.
		aadd(aRet,aClone(aAux))
	EndIf

	RestArea(aAreaCB7)
	RestArea(aArea)
Return aClone(aRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function ChkOrd(cOrdSep,cArmSel)
User Function ChkOrd(cOrdSep,cArmSel)
	Local aArea 	:= GetArea()
	Local aAreaCB8 := CB8->(GetArea())
	Local lRet		:= .t.

	CB8->(DbSetOrder(1))
	CB8->(DbSeek(xFilial("CB8")+cOrdSep))
	While CB8->(!Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+cOrdSep)
		If CB8->CB8_QTDORI <> CB8->CB8_SALDOS //.And. cArmSel == CB8->CB8_LOCAL
			lRet := .F.
			Exit
		Endif
		CB8->(DbSkip())
	EndDo
	RestArea(aAreaCB8)
	RestArea(aArea)
Return lRet

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function DeleCB7(cArmSel)
User Function DeleCB7(cArmSel)
	Local aCabDoc	:= {}
	Local aDocs		:= {}
	Local lAdmin 	:= Empty(cArmSel)
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local aRet		:={0,0}
	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local cMsgLog		:= ""
	Local _cFitro := "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"')"

	If lAdmin
		If  ! ParamBox({{ 2, "Armazem	","Expedi็ใo",{"Expedi็ใo","Estoque"},80,'',.F.}},"Ordem de Separa็ใo",@aRet,,,,,,,,.F.)
			Return
		EndIf
		If aRet[1] == "Expedi็ใo"
			cArmSel := cArmExp
		Else
			cArmSel := cArmEst
		EndIf
	EndIf
	CB7->(DbClearFilter())
	If cArmSel == cArmExp  //Pedido de vendas
		//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7
		aCabDoc:= {"CB7_ORDSEP","CB7_PEDIDO","CB7_OP","RECCB7"}
	Else
		//aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO"}
		//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7
		aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO", "RECCB7"}
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Processa({|| aDocs := U_LoadCB7(aCabDoc,cArmSel,,.t.,.t.,@cMsgLog)},"Selecionando Registros Aguarde!!!!!!")
	//aDocs := LoadCB7(aCabDoc,cArmSel,,.t.,.t.,@cMsgLog)

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_SelDoc(aCabDoc,aDocs,"Excluir Ordem de Separa็ใo",cMsgLog,,.F.,.F.)
	If Empty(aDocs)
		Return
	EndIf
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	MsgRun( "Excluindo Ordem de Separa็ใo, aguarde...",, {|| U_DeleCB7R(aDocs,aCabDoc)} )

	DbSelectArea("CB7")
	SET FILTER TO &(_cFitro)
	RestArea(aArea)
	RestArea(aAreaSC5)
	RestArea(aAreaSC2)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function DeleCB7R(aDocs)
User Function DeleCB7R(aDocs,aCabDoc)
	Local nx
	Local aItens	:={}
	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local nY
	Local cOrdSep
	Local cDoc
	Local cProduto
	Local cArm
	Local cPriAnt
	Local cOsFilho
	Local nPos		:= 0
	Local nRecCB7   := 0		//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744

	DbSelectArea("ZZA")
	ZZA->(DbSetOrder(3)) // ZZA_FILIAL+ZZA_PEDFAT+ZZA_ORDSEP

	For nX:= 1 to len(aDocs)
		If ! aDocs[nx,1]
			Loop
		EndIf

		nPos    := (Ascan(aCabDoc,"RECCB7"))+1
		//nRecCB7 := aDocs[nX,Len(aDocs[nx])]

		//If nRecCB7 > 0 .and. nRecCB7 <> Nil

		If nPos > 0
			nRecCB7 := aDocs[nX,nPos]		//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744
			CB7->(DbGoto(nRecCB7))   //CB7->(DbGoto(aDocs[nx,Len(aDocs[nx])]))
			If AllTrim(CB7->CB7_STATUS)<>"0" //Chamado 001485
				MsgAlert("Aten็ใo, a OS "+AllTrim(CB7->CB7_ORDSEP)+" esta com status de separacao diferente de 0")
				Loop
			EndIf
			If !Empty(CB7->CB7_CODOPE) //Chamado 001485
				MsgAlert("Aten็ใo, a OS "+AllTrim(CB7->CB7_ORDSEP)+" esta operador alocado")
				Loop
			EndIf
			cOrdSep	:= CB7->CB7_ORDSEP
			cPriAnt	:= CB7->CB7_XPRIAN
			cOsFilho	:= CB7->CB7_XOSFIL

			//Verificar se OS existe na tabela ZZA e apagar registros
			//20190919000050
			If ZZA->(DbSeek(xFilial("ZZA")+CB7->(CB7_PEDIDO+CB7_ORDSEP)))
				While ZZA->(!Eof()) .And. ZZA->(ZZA_FILIAL+ZZA_PEDIDO+ZZA_PEDFAT)==xFilial("ZZA")+CB7->(CB7_PEDIDO+CB7_ORDSEP)
					ZZA->(RecLock("ZZA",.F.))
					ZZA->(DbDelete())
					ZZA->(MsUnLock())
					ZZA->(DbSkip())
				EndDo
			EndIf

			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			U_MontaCB8(NIL,aItens)
			Begin Transaction
				For nY:= 1 to len(aItens)
					nRecno	:= aItens[nY,len(aItens[nY])]
					CB8->(DbGoto(nRecno))
					If Empty(CB8->CB8_OP) //Pedido de vendas
						cDoc		:= CB8->CB8_PEDIDO+CB8->CB8_ITEM
					Else
						cDoc		:= AllTrim(CB8->CB8_OP)
					EndIf
					cProduto	:= CB8->CB8_PROD
					cArm		:= CB8->CB8_LOCAL
					nReserva	:= CB8->CB8_QTDORI
					U_STDelSDC	(cDoc,cProduto,cOrdSep)
					U_STReserva	(cDoc,cProduto,nReserva,"+",cFilAnt)
					U_STGrvSt	(cDoc)
					U_STDelOS	(cOrdSep)
				Next
				If ! Empty(cOsFilho)
					U_STDelAux(cOsFilho)
				EndIf
				/*
				If Len(Alltrim(cDoc)) == 11  //OP
					SC2->(DbSetOrder(1))
					SC2->(DbSeek(xFilial('SC2')+cDoc))
					SC2->(RecLock('SC2'))
					SC2->C2_XPRIORI := cPriAnt
					SC2->(MsUnLock())
				Else
					SC5->(DbSetOrder(1))
					SC5->(DbSeek(xFilial('SC1')+cDoc))
					SC5->(RecLock('SC5'))
					SC5->C5_XPRIORI := cPriAnt
					SC5->(MsUnLock())
				EndIf
				*/
			End Transaction
		Endif
	Next
	RestArea(aAreaSC5)
	RestArea(aAreaSC2)
	RestArea(aArea)
Return

//----------------------------------------//
//ALOCAวรO INDIVIDUAL
//----------------------------------------//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Aloca(cArmSel)
User Function Aloca(cArmSel)
	Local lAdmin 		:= Empty(cArmSel)
	Local aCabDoc		:= {}
	Local aDocs			:= {}
	Local aRet			:= {}
	Local aParamOper	:= {}
	Local aArea			:= GetArea()
	Local cCodOpe 		:= Space(6)
	Local cCodOpExp		:= Space(6)
	Local cCodOp2		:= Space(6)
	Local cCodOp3		:= Space(6)
	Local cCodOp4		:= Space(6)
	Local cCodOp5		:= Space(6)
	Local cArmExp 		:= GetMv("FS_ARMEXP")
	Local cArmEst 		:= GetMv("FS_ARMEST")
	Local cMsgLog		:= ""
	Local _cFitro 		:= "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"')"

	CB7->(DbClearFilter())

	Default xnTotped := 0
	Default xnLix    := 0

	If lAdmin
		If  ! ParamBox({{ 2, "Armazem	","Expedi็ใo",{"Expedi็ใo","Estoque"},80,'',.F.}},"Ordem de Separa็ใo",@aRet,,,,,,,,.F.)
			Return
		EndIf
		If aRet[1] == "Expedi็ใo"
			cArmSel := cArmExp
		Else
			cArmSel := cArmEst
		EndIf
	EndIf
	If cArmSel == cArmExp  //Pedido de vendas
		aCabDoc:= {"CB7_ORDSEP","CB7_PEDIDO","NOME","LIN_SCH","LIN_STK","VLR_SCH","VLR_STK","RECCB7"}
	Else
		//aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO"}
		//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7
		aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO", "RECCB7"}
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Processa({|| aDocs := U_LoadCB7(aCabDoc,cArmSel,,,,@cMsgLog)},"Selecionando Registros Aguarde!!!!!!")
	//aDocs := LoadCB7(aCabDoc,cArmSel,,,,@cMsgLog)

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	FWMsgRun(, {|| U_SelDoc(aCabDoc,aDocs,"Aloca็ใo da Ordem de Separa็ใo",cMsgLog,,.T.,.F.)},"Aguarde","Montando a tela")
	If Empty(aDocs)
		Return
	EndIf

	Aadd(aParamOper,{ 1, "Operador Estoque"		, cCodOpe 			, "@!"    , '', "CB1FSW", "" , 0  , .F. })
	Aadd(aParamOper,{ 1, "Operador Expedicao"	, cCodOpExp			, "@!"    , 'ExistCpo("CB1")', "CB1EXP", "" , 0  , .F. })

	Aadd(aParamOper,{ 1, "Operador 2"	, cCodOp2			, "@!"    , 'ExistCpo("CB1")', "CB1EXP", "" , 0  , .F. })
	Aadd(aParamOper,{ 1, "Operador 3"	, cCodOp3			, "@!"    , 'ExistCpo("CB1")', "CB1EXP", "" , 0  , .F. })
	Aadd(aParamOper,{ 1, "Operador 4"	, cCodOp4			, "@!"    , 'ExistCpo("CB1")', "CB1EXP", "" , 0  , .F. })
	Aadd(aParamOper,{ 1, "Operador 5"	, cCodOp5			, "@!"    , 'ExistCpo("CB1")', "CB1EXP", "" , 0  , .F. })

	If ! ParamBox(aParamOper,"Aloca็ใo",@aRet,,,,,,,,.F.)
		Return
	EndIf
	cCodOpe		:= aRet[1]
	cCodOpExp	:= aRet[2]
	cCodOp2		:= aRet[3]
	cCodOp3		:= aRet[4]
	cCodOp4		:= aRet[5]
	cCodOp5		:= aRet[6]
	If !Empty(cCodOpe) .And. !CBVldOpe(cCodOpe)
		Return
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	MsgRun( "Gravando a aloca็ใo, aguarde...",, {|| U_AlocaR(aDocs,cCodOpe,cCodOpExp,cCodOp2,cCodOp3,cCodOp4,cCodOp5,aCabDoc)} )

	cCodOpeGen := U_fTrazCB1Gen()		//VERIFICA QUAL O CำDIGO QUE CORRESPONDE A OPERADOR GENษRICO
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F. //FR - 23/07/2021

	DbSelectArea("CB7")
	SET FILTER TO &(_cFitro)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function AlocaR(aDocs,cCodOpe,cCodOpExp,cCodOp2,cCodOp3,cCodOp4,cCodOp5)
User Function AlocaR(aDocs,cCodOpe,cCodOpExp,cCodOp2,cCodOp3,cCodOp4,cCodOp5,aCabDoc)
	Local nx
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local nRecCB7   := 0		//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744

	For nX:= 1 to len(aDocs)
		If ! aDocs[nx,1]
			Loop
		EndIf

		//CB7->(DbGoto(aDocs[nx,Len(aDocs[nx])]))
		nRecCB7 := aDocs[nX,Len(aDocs[nx])]		//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744

		If nRecCB7 > 0 .and. nRecCB7 <> Nil

			CB7->(DbGoto(nRecCB7))   //CB7->(DbGoto(aDocs[nx,Len(aDocs[nx])]))

			U_STPriCB7(CB7->CB7_LOCAL,cCodOpe)
			CB7->(RecLock('CB7',.F.))
			CB7->CB7_CODOPE:= Iif(Empty(cCodOpe),CB7->CB7_CODOPE,cCodOpe)
			CB7->CB7_XOPEXP:= Iif(Empty(cCodOpExp),CB7->CB7_XOPEXP,cCodOpExp)
			CB7->CB7_XOPE2 := cCodOp2
			CB7->CB7_XOPE3 := cCodOp3
			CB7->CB7_XOPE4 := cCodOp4
			CB7->CB7_XOPE5 := cCodOp5
			CB7->(MsUnLock())
		Endif
	Next
	RestArea(aAreaCB7)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//Static Function Desaloca(cArmSel)
User Function Desaloca(cArmSel)
	Local lAdmin 	:= Empty(cArmSel)
	Local aCabDoc	:= {}
	Local aDocs		:= {}
	Local aRet		:= {}
	Local cCodOpe 	:= CB7->CB7_CODOPE
	Local cXopExp 	:= CB7->CB7_XOPEXP
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local cMsgLog		:= ""

	Local cCodOpeGen := ""

	Default xnTotped := 0
	Default xnLix    := 0

	If Empty(cCodOpe) .And. Empty(cXopExp)
		MsgAlert("Necessario posicionar na Ordem de Separa็ใo alocada.","Aviso")
		Return
	EndIf
	If lAdmin
		If  ! ParamBox({{ 2, "Armazem	","Expedi็ใo",{"Expedi็ใo","Estoque"},80,'',.F.}},"Ordem de Separa็ใo",@aRet,,,,,,,,.F.)
			Return
		EndIf
		If aRet[1] == "Expedi็ใo"
			cArmSel := cArmExp
		Else
			cArmSel := cArmEst
		EndIf
	EndIf
	If cArmSel == cArmExp  //Pedido de vendas
		aCabDoc:= {"CB7_ORDSEP","CB7_PEDIDO","CB7_OP","RECCB7"}
	Else
		//aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO"}
		//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7
		aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO", "RECCB7"}
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Processa({|| aDocs := U_LoadCB7(aCabDoc,cArmSel,cCodOpe,,,@cMsgLog,.T.)},"Selecionando Registros Aguarde!!!!!!")
	//aDocs := LoadCB7(aCabDoc,cArmSel,cCodOpe,,,@cMsgLog,.T.)

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_SelDoc(aCabDoc,aDocs,"Desaloca็ใo da Ordem de Separa็ใo",cMsgLog,,.F.,.T.)
	If Empty(aDocs)
		Return
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	MsgRun( "Gravando a aloca็ใo, aguarde...",, {|| U_DesalocR(aDocs,aCabDoc)} )

	cCodOpeGen := U_fTrazCB1Gen()		//VERIFICA QUAL O CำDIGO QUE CORRESPONDE A OPERADOR GENษRICO
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F. //FR - 23/07/2021

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBloqCB7	บAutor  ณMicrosiga           บ Data ณ  03/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBloqueio/Desbloqueio CB7                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAFAT                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function BloqCB7()
//Static Function BloqCB7()
	Local cStatus	:= CB7->CB7_XAUTSE
	Local cMsg		:= "Deseja "+Iif(cStatus == "1","bloquear","autorizar")+" esta ordem de separa็ใo?"

	//Jair Ribeiro
	If !Empty(CB7->CB7_XOSPAI)
		If (Aviso("Aten็ใo",cMsg,{"Sim","Nใo"})) == 1
			CB7->(RecLock("CB7",.F.))
			//CB7->CB7_XAUTSE := Iif(cStatus == "1","2","1")  				//[Renato 100513] - Alterado para nใo gerar OS bloqueada.
			CB7->CB7_XAUTSE := "1"
			CB7->(MsUnlock())
		Endif
	Else
		Aviso("Aten็ใo","Apenas Ordem de Separa็ใo Filha pode ser Autorizada/Bloqueada",{"Ok"})
	EndIf
Return Nil

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function DesalocR(aDocs,aCabDoc)
//Static Function DesalocaR(aDocs)
	Local nx
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local nPos		:= 0
	Local nRecCB7	:= 0		//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744

	DbSelectArea("CB8")
	CB8->(DbSetOrder(1))

	For nX:= 1 to len(aDocs)

		If ! aDocs[nx,1]
			Loop
		EndIf

		//CB7->(DbGoto(aDocs[nx,Len(aDocs[nx])]))
		nPos    := (Ascan(aCabDoc,"RECCB7"))+1
		//nRecCB7 := aDocs[nX,Len(aDocs[nx])]

		//If nRecCB7 > 0 .and. nRecCB7 <> Nil

		If nPos > 0
			nRecCB7 := aDocs[nX,nPos]				//FR - 19/09/2022 - Erro na aloca็ใo de OS - Ticket #20220919017744
			CB7->(DbGoto(nRecCB7))   //CB7->(DbGoto(aDocs[nx,Len(aDocs[nx])]))

			U_STPriCB7(CB7->CB7_LOCAL,Space(6))
			CB7->(RecLock('CB7',.F.))
			CB7->CB7_CODOPE:= Space(6)
			CB7->CB7_XOPEXP:= Space(6)
			CB7->CB7_STATUS:= "0"
			CB7->CB7_STATPA:= Space(1)
			CB7->CB7_DTINIS:= CTOD("//")
			CB7->CB7_HRINIS:= Space(6)
			CB7->CB7_DTFIMS:= CTOD("//")
			CB7->CB7_HRFIMS:= Space(6)
			CB7->CB7_XSEP 		:= "2"
			CB7->CB7_XOPE2:= Space(6)
			CB7->CB7_XOPE3:= Space(6)
			CB7->CB7_XOPE4:= Space(6)
			CB7->CB7_XOPE5:= Space(6)
			CB7->CB7_XOPEXG:= Space(6)		//FR - 18/06/2021 - Desaloca o "Gen้rico" tamb้m
			CB7->(MsUnLock())

			CB8->(DbSeek(CB7->(CB7_FILIAL+CB7_ORDSEP)))

			While CB8->(!Eof()) .And. CB7->(CB7_FILIAL+CB7_ORDSEP)==CB8->(CB8_FILIAL+CB8_ORDSEP)
				CB8->(RecLock("CB8",.F.))
				CB8->CB8_CODOPE := ""
				CB8->(MsUnLock())
				CB8->(DbSkip())
			EndDo
		Endif

	Next

	RestArea(aAreaCB7)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function PesqOSep(cOrdSep,oBrowse)
//Static Function PesqOSep(cOrdSep,oBrowse)
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local nRecno

	If Empty(cOrdSep)
		Return .t.
	EndIf

	CB7->(DbSetOrder(1))
	If ! CB7->(DbSeek(xFilial('CB7')+cOrdSep))
		MsgAlert('Ordem de separa็ใo nใo encontrada!!!',"Aten็ใo")
		cOrdSep:= Space(6)
		RestArea(aAreaCB7)
		RestArea(aArea)
		Return .t.
	EndIf

	nRecno:= CB7->(Recno())
	cOrdSep:= Space(6)
	RestArea(aAreaCB7)
	RestArea(aArea)
	CB7->(DbGoto(nRecno))
	oBrowse:Refresh()
	Eval(oBrowse:bChange)

Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function PesqOper(cCodOpe,oBrowse,cArmAtu)
//Static Function PesqOper(cCodOpe,oBrowse,cArmAtu)
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local nRecno
	Local lAdmin	:= Empty(cArmAtu)
	Local cArmExp := GetMv("FS_ARMEXP")
	Local cArmEst := GetMv("FS_ARMEST")

	If Empty(cCodOpe)
		Return .t.
	EndIf

	If lAdmin
		DBOrderNickName("STFSCB701")
		If cArmExp < cArmEst
			If ! CB7->(DbSeek(xFilial('CB7')+"2"+cArmExp+cCodOpe)) .and. ! CB7->(DbSeek(xFilial('CB7')+"2"+cArmEst+cCodOpe))
				MsgAlert('Ordem de separa็ใo para este operador nใo encontrado!!!',"Aten็ใo")
				cCodOpe:= Space(6)
				RestArea(aAreaCB7)
				RestArea(aArea)
				Return .t.
			EndIf
		Else
			If ! CB7->(DbSeek(xFilial('CB7')+"2"+cArmEst+cCodOpe)) .and. ! CB7->(DbSeek(xFilial('CB7')+"2"+cArmExp+cCodOpe))
				MsgAlert('Ordem de separa็ใo para este operador nใo encontrado!!!',"Aten็ใo")
				cCodOpe:= Space(6)
				RestArea(aAreaCB7)
				RestArea(aArea)
				Return .t.
			EndIf
		EndIf
	Else
		DBOrderNickName("STFSCB702")
		If ! CB7->(DbSeek(xFilial('CB7')+cArmAtu+"2"+cCodOpe))
			MsgAlert('Ordem de separa็ใo para este operador nใo encontrado!!!',"Aten็ใo")
			cCodOpe:= Space(6)
			RestArea(aAreaCB7)
			RestArea(aArea)
			Return .t.
		EndIf
	EndIf

	nRecno:= CB7->(Recno())
	cCodOpe:= Space(6)
	RestArea(aAreaCB7)
	RestArea(aArea)
	CB7->(DbGoto(nRecno))
	oBrowse:Refresh()
	Eval(oBrowse:bChange)
Return .t.

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function ViewCB7()
//Static Function ViewCB7()
	Local aArea		:= GetArea()	// Valdemir Rabelo 21/08/2019
	Local aAreaCB7	:= CB7->(GetArea())
	PRIVATE aRotina := {}
	Private aHeader := {}			// Valdemir Rabelo 21/08/2019

	SX3->(DbSetOrder(1))
	dbSelectArea("CB7")

	aRotina := {	{"Pesquisar"					,"AxPesqui",   0,1},;
		{"Visualizar"					,"ACDA100Vs",0,2}}

	ACDA100Vs("CB7",CB7->(Recno()),2)
	RestArea(aAreaCB7)
	RestArea(aArea)
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AnalisaLeg(nColuna)
//Static Function AnalisaLeg(nColuna)
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
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
	If nColuna == 1        // analise da ordem de separacao como um todo
		If CB7->CB7_DIVERG == '1'
			Return oVermelho
		EndIf
		If CB7->CB7_STATPA == '1'
			Return oCinza
		EndIf
		If CB7->CB7_STATUS == '0'
			Return oAzul
		EndIf
		If CB7->CB7_STATUS == '9'
			Return oVerde
		EndIf
		Return oAmarelo
	Else
		If ! Empty(CB7->CB7_XDISE)
			oCor:= oSep
		EndIF
		If ! Empty(CB7->CB7_XDIEM)
			oCor:= oEbl
		EndIF
		If ! Empty(CB7->CB7_XDIEB)
			oCor:= oEbq
		EndIF
		If ! Empty(CB7->CB7_XDFSE) .and. Empty(CB7->CB7_XDIEM)
			oCor:= oEst
		Endif
		If ! Empty(CB7->CB7_XDFEM)
			oCor:= oEbq
		Endif
	EndIf
Return oCor

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function Mensagem(cCodOpe)
//Static Function Mensagem(cCodOpe)
	//Local nX
	//Local nCountMsg:= 0
	Local oMemo
	Local cMemo
	Local oFont
	Local oDlgMsg
	Local cNumCol

	If Empty(cCodOpe)
		MsgAlert('Ordem de separa็ใo nใo alocada!!!')
		Return
	EndIf

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	cNumCol := U_RetNumCol(cCodOpe)
	If Empty(cNumCol)
		Return
	EndIf

	DEFINE FONT oFont NAME "Mono AS" SIZE 8,20
	DEFINE MSDIALOG oDlgMsg FROM 0,0 TO 100,300  Pixel TITLE OemToAnsi("Mensagem para o coletor "+cNumCol)
	@ 0,0 GET oMemo  VAR cMemo MEMO SIZE 150,30 OF oDlgMsg PIXEL
	TButton():New( 035,001, "Enviar", oDlgMsg, {|| MemoWrite('VT'+cNumCol+'.MSG',cMemo),oDlgMsg:End()}, 38, 11,,, .F., .t., .F.,, .F.,,, .F. )
	TButton():New( 035,111, "Sair", oDlgMsg, {|| oDlgMsg:End()}, 38, 11,,, .F., .t., .F.,, .F.,,, .F. )
	oMemo:oFont:=oFont
	ACTIVATE MSDIALOG oDlgMsg CENTERED
Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function RetNumCol(cCodOpe)
//Static Function RetNumCol(cCodOpe)
	Local aArea		:= GetArea()
	Local aAreaCB1	:= CB1->(GetArea())
	Local cLinha 	:= Space(70)
	Local cNumCol 	:= ''
	Local cNomCol	:= ''
	Local nHTemp
	Local aColetor := Directory("VT*.SEM")
	Local cNomUsr	:= ''
	Local nX

	CB1->(DbSetOrder(1))
	If ! CB1->(DbSeek(xFilial('CB1')+cCodOpe))
		MsgAlert('Operador '+cCodOpe+' nใo cadastrado!!')
		RestArea(aAreaCB1)
		RestArea(aArea)
		Return ''
	EndIf

	// eliminar coletor com conexao morta
	aColetor := Directory("VT*.SEM")
	For nX := 1 to Len(aColetor)
		nHTemp := FOpen(aColetor[nX,1],16)
		FClose(nHTemp)
		If nHTemp > 0
			FErase(aColetor[nX,1])
		EndIf
	Next

	//Procura o usuario nos coletores ativos
	cNomUsr := UsrRetName(CB1->CB1_CODUSR)
	aColetor := Directory("VT*.SEM")
	For nX := 1 to Len(aColetor)
		cLinha  	:= Memoread(aColetor[nX,1])
		cNomCol	:= Subs(cLinha,4,25)
		If AllTrim(cNomCol) == Alltrim(cNomUsr)
			cNumCol 	:= Left(cLinha,3)
			Exit
		EndIf
	Next
	If Empty(cNumCol)
		MsgAlert('Operador com RF desligado!',"Aten็ใo")
	EndIf
	RestArea(aAreaCB1)
	RestArea(aArea)
Return cNumCol

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSFA10  บAutor  ณMicrosiga           บ Data ณ  12/30/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function TransRes(oFolder)
//Static Function TransRes(oFolder)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local cDoc		:= ""
	Local cAltExp	:= GetMv("ST_XARESEX")

	If cCargo =='SC5' //Pedido de Venda

		If SC5->C5_TIPOCLI=="X" .And. !__cUserId $ cAltExp
			MsgAlert("Aten็ใo, seu usuแrio nใo tem permissใo para eliminar reservas de exporta็ใo")
			Return
		EndIf

		cDoc	:= SC5->(FieldGet(FieldPos("C5_NUM")))

	Else
		cDoc	:= SC2->(FieldGet(FieldPos("C2_NUM")) + FieldGet(FieldPos("C2_ITEM")) + FieldGet(FieldPos("C2_SEQUEN")))
	Endif
	U_STFSFA40(cDoc)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSFA10  บAutor  ณMicrosiga           บ Data ณ  01/17/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณElimina quantidade inforamda de reserva                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function MataRes(oFolder,aItens2,oLbx)
//Static Function MataRes(oFolder,aItens2,oLbx)
	Local cCargo 	:= U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	Local cProduto	:= aItens2[oLbx:nAt,5]
	Local cAltExp	:= GetMv("ST_XARESEX")

	If cCargo == 'SC5' //Pedido de Venda

		If SC5->C5_TIPOCLI=="X" .And. !__cUserId $ cAltExp
			MsgAlert("Aten็ใo, seu usuแrio nใo tem permissใo para eliminar reservas de exporta็ใo")
			Return
		EndIf

		cDoc	:= SC5->(FieldGet(FieldPos("C5_NUM")) + aItens2[oLbx:nAt,4])
	Else
		cDoc	:= SC2->(FieldGet(FieldPos("C2_NUM")) + FieldGet(FieldPos("C2_ITEM")) + FieldGet(FieldPos("C2_SEQUEN")))
	Endif

	U_STFSFA41(cDoc,cProduto)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMatResPV  บAutor  ณ Leonardo Kichitaro บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณElimina reserva de todos os itens do pedido selecionado     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function MatResPV(aItens2)
//Static Function MatResPV(aItens2)
	Local cDoc		:= ""
	Local cProduto	:= ""
	Local cFilRes	:= ""
	Local nQtde		:= 0
	Local _cDoc1              //renato 160413
	Local cAltExp	:= GetMv("ST_XARESEX")
	Local nX := 0
	If SC5->C5_TIPOCLI=="X" .And. !__cUserId $ cAltExp
		MsgAlert("Aten็ใo, seu usuแrio nใo tem permissใo para eliminar reservas de exporta็ใo")
		Return
	EndIf

	If !MsgYesNo("Deseja eliminar reservas de todos os itens do pedido de venda ?","Aviso")
		Return
	EndIf

	For nX := 1 To Len(aItens2)
		cProduto	:= aItens2[nX,5]
		cDoc		:= SC5->(FieldGet(FieldPos("C5_NUM")) + aItens2[nX,4])
		nQtde		:= SuperVal(aItens2[nX,9])

		cFilRes := ""

		_cDoc1	:= substr(alltrim(cDoc),1,8)	   //renato 160413

		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO renato 160413
		SC9->(DbSeek(xFilial("SC9")+_cDoc1)) 			//renato 160413

		If !SC9->(Eof())   //renato 160413 abre
			If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. EMPTY(SC9->C9_BLEST) .And. EMPTY(SC9->C9_BLCRED)
				MsgAlert("Existe ordem de separa็ใo em aberto para o pedido, nใo serแ possํvel eliminar o produto: "+cProduto)
				Loop
			EndIf
		EndIf                      //renato 160413 fecha

		PA2->(DbSetOrder(1))//PA2_FILIAL+PA2_CODPRO+PA2_FILRES
		PA2->(DbSeek(xFilial("PA2")+Padr(cProduto,15)))
		While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODPRO == xFilial("PA2")+Padr(cProduto,15))
			If Empty(cDoc) .or. Alltrim(PA2->PA2_DOC) == Alltrim(cDoc)
				cFilRes := PA2->PA2_FILRES
			Endif
			PA2->(DbSkip())
		End

		U_STReserva(cDoc,cProduto,nQtde,"-",cFilRes)
		U_STFalta(cDoc,cProduto,nQtde,"+")
		U_STGrvSt(cDoc)

		U_STFAT631(cDoc,"",cProduto,nQtde,"Elimina็ใo de reserva") //log elimina็ใo de reserva

	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSFA10  บAutor  ณMicrosiga           บ Data ณ  05/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera cabecalho do pedido de venda	                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AltSC5(oFolder)
//Static Function AltSC5(oFolder)
	Local cCargo := U_RetPosTab(oFolder)	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION

	If !(cCargo == 'SC5')
		Return
	Endif

	If SC5->C5_ZFATBLQ == '1'.Or. ('XXXX' $ SC5->C5_NOTA) //Renato Nogueira - 230114 - Nใo permitir alterar o cabe็alho quando PV estiver faturado totalmente
		MsgAlert("Aten็ใo, pedido "+AllTrim(SC5->C5_NUM)+" faturado totalmente e nใo pode ser alterado!")
		Return
	EndIf

	oTimer:Deactivate()
	U_STALTSC5()
	U_STGrvSt(SC5->C5_NUM)
	oTimer:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDistRes   บAutor  ณMicrosiga           บ Data ณ  01/17/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function DistRes(aItens2,oLbx)
//Static Function DistRes(aItens2,oLbx)
	Local cProduto	:= Padr(aItens2[oLbx:nAt,5],15)
	Local aRet		:= {}
	Local aParamBox:={{1,"Produto"				,cProduto,"","","SB1","",0,.T.}}
	Local aAreaSB1	:= SB1->(GetArea())
	Local _cDoc1, _cDoc2, _Rec
	Local cQuery	:= ""
	lOCAL cLocal := ""

	If !ParamBox(aParamBox,"Distribui็ใo de Reserva",@aRet,,,,,,,,.f.)
		Return
	Endif
	cProduto := MV_PAR01
	SB1->(DBSetOrder(1))
	If ! SB1->(DbSeek(xFilial('SB1')+cProduto))
		MsgAlert("Produto nใo encontrado","Aten็ใo")
		RestArea(aAreaSB1)
		Return
	EndIf
	RestArea(aAreaSB1)

	/*************************************************************
	Altera็ใo na chamada do  aItens 
	Marcelo Klopfer Leme - Sigamat
	10/11/2021
	cDoc		:= SC5->(FieldGet(FieldPos("C5_NUM")) + aItens2[1,4])
	*************************************************************/
	cDoc		:= SC5->(FieldGet(FieldPos("C5_NUM")) + aItens2[oLbx:nAt,4])

	_cDoc1	:= substr(alltrim(cDoc),1,6)					//renato 160413 abre
	_cDoc2	:= substr(alltrim(cDoc),7,2)

	cQuery := "SELECT C9_PEDIDO, C9_ITEM, MAX(R_E_C_N_O_) C9_RECNO "
	cQuery += "FROM "+RetSqlName("SC9")+" C9"
	cQuery += "WHERE D_E_L_E_T_=' ' AND C9_PEDIDO='"+_cDoc1+"' AND C9_ITEM='"+_cDoc2+"' "
	cQuery += "GROUP BY C9_PEDIDO, C9_ITEM "

	cQuery := ChangeQuery(cQuery)  //INCLUอDA ESSA LINHA GIOVANI FEZ MERDA!!
	TCQUERY cQuery NEW ALIAS "TMP"

	_Rec	:= TMP->C9_RECNO

	SC9->(DbGoto(_Rec))

	If !SC9->(Eof())
		If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. EMPTY(SC9->C9_BLEST) .And. EMPTY(SC9->C9_BLCRED)
			MsgAlert("Existe ordem de separa็ใo em aberto para o pedido, nใo serแ possํvel eliminar o produto: "+cProduto)
			Return
		EndIf
		cLocal := SC9->C9_LOCAL
	EndIf

	If !Empty(Select("TMP"))
		DbSelectArea("TMP")
		("TMP")->(dbCloseArea())
	Endif																					//renato 160413 fecha

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFRetSldC6 บAutor  ณJair Ribeiro		 บ Data ณ  03/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno Saldo do pedido                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAATF                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function FRetSldC6(cPedido)
//Static Function FRetSldC6(cPedido)
	Local aAreaAll	:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local nValRet	:= 0

	SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM

	If SC6->(DbSeek(xFilial("SC6")+cPedido))
		While SC6->(!EOF()) .and. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+cPedido
			nValRet	+= ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN )
			SC6->(DbSkip())
		EndDo
	EndIf

	RestArea(aAreaAll)
	RestArea(aAreaSC6)
Return nValRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CheckPA0 บAutor  ณRenato/Gallo 		 บ Data ณ  24/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChecar se existe OS para essa OP				              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAPCP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function _CheckPA0(_nTipo)
//Static Function _CheckPA0(_nTipo)  // qaundo vier 1= retorna se tem saldo ou nao , qdo vier 2= retorna array com saldos de empenho

	Local cNumOP 	:= SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
	Local aArea 	:= GetArea()
	Local _aArea	:= SC2->(GetArea())
	Local _aSD4Area	:= SD4->(GetArea())
	Local _lRet		:= .f.
	Local _Asaldos  := {}
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local oAzul		:= LoadBitmap( GetResources(), "BR_AZUL" 	)
	Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oNao		:= LoadBitmap( GetResources(), "BR_CANCEL"	)
	Local oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local cPicture	:= PesqPict("CB8","CB8_QTDORI")
	Local oPreto	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO"	)

	DbSelectArea("SD4")
	DbSetOrder(2)
	DbSeek(xFilial('SD4')+cNumOP)

	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+cNumOP)
		If U_STIsIndireto(SD4->D4_COD) .Or. !Empty(SD4->D4_XORDSEP)
			SD4->(DbSkip())
			Loop
		EndIf

		_nQtMov   := 0
		_nQuantOri:= 0
		_nQuant	  := 0
		_cCodigo  := SD4->D4_COD
		_nRecno   := SD4->(Recno())
		_Clocal   := SD4->D4_LOCAL

		DbSelectArea("SD4")
		Do While !EOF() .AND. SD4->D4_OP = cNumOP .AND. SD4->D4_COD = _cCodigo
			If Empty(SD4->D4_XORDSEP)
				_nQuantOri	+= SD4->D4_QTDEORI
				_nQuant		+= SD4->D4_QUANT
				If _nRecno <> SD4->(Recno())
					RecLock("SD4",.F.)
					DbDelete()
					MsUnlock()
				Endif
			EndIf
			Dbskip()
		Enddo
		DbSelectArea("SD4")
		SD4->(DbGoTo(_nRecno))
		RecLock("SD4",.F.)
		SD4->D4_QTDEORI := _nQuantOri
		SD4->D4_QUANT 	:= _nQuant

		MsUnlock()

		DbSelectArea("PA0")
		DbSetOrder(2) //PA0_FILIAL+PA0_TIPDOC+PA0_DOC+PA0_PROD+PA0_LOTEX
		DbSeek(xFilial("PA0")+"SC2"+cNumOP+SD4->D4_COD)

		Do while cNumOP == Left(SD4->D4_OP,11) .and. SD4->D4_COD == PA0_PROD .and. !eof()
			_nQtMov += PA0_QTDE
			Dbskip()
		Enddo

		IF _nQuantOri > _nQtMov
			DbSelectArea("SD4")
			nRes	:=SD4->(U_STGetRes(AllTrim(cNumOP),_cCodigo,cFilAnt))
			nResDF	:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilDP))
			nFalta	:=SD4->(U_STGetFal(AllTrim(D4_OP),D4_COD))
			aCores	:= {If(!Empty(nRes),oVerde,oPreto),If(!Empty(nResDF),oAmarelo,oPreto),If(!Empty(nFalta),oVermelho,oPreto)}
			aadd(_Asaldos , {aCores[1],aCores[2],aCores[3],_Clocal ,_cCodigo,Posicione("SB1",1,xFilial('SB1')+D4_COD,"B1_DESC"),_nQuantOri - _nQtMov,Transform(nRes,cPicture),Transform(nResDF,cPicture),Transform(nFalta,cPicture),0," ",SD4->(Recno())})
			_lret := .t.
		Endif

		DbSelectArea("SD4")
		SD4->(DbSkip())
	End

	DbSelectArea("SD4")
	RestArea(_aSD4Area)

	DbSelectArea("SC2")
	RestArea(_aArea)

Return IIF(_nTipo==1, _lRet, _Asaldos )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSFA10  บAutor  ณMicrosiga           บ Data ณ  04/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function  _GeraOSxOP(cArmSel,aDocs,lMudaQtd, NX)
//Static Function  _GeraOSxOP(cArmSel,aDocs,lMudaQtd, NX)
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local cArmAnt	:= ""
	Local aSD4		:={}
	Local cOrdSep	:= ""
	Local cOrdAux	:= ""
	Local aSD4		:={}
	Local cArmAnt	:= ""
	Local lDifArm	:= .F.
	Local nY		:= 0
	Local nCont		:= 0
	Local nMaximoOS	:= 0

	SC2->(DbGoto(aDocs[nx,Len(aDocs[nx])]))

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	aItens	:= U__CheckPA0(2)

	If lMudaQtd
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		If ! U_MudaSD4(aItens,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
			Return
		EndIf
	EndIf
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	If U_TemAux(aItens,cArmExp,4)
		cOrdAux := GetSX8Num( "CB7", "CB7_ORDSEP" )
		CB7->(ConfirmSX8())
	EndIf

	lDifArm	:= .F.
	For nY:= 1 to len(aItens)
		If !Empty(cArmAnt) .And. cArmAnt <> aItens[nY,4]
			lDifArm := .T.
			Exit
		EndIf
		cArmAnt := aItens[nY,4]
	Next

	Begin Transaction
		For nY:= 1 to len(aItens)
			cDoc		:= SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
			cProduto	:= aItens[nY,5]
			cArm		:= aItens[nY,4]
			nRecno		:= aItens[nY,len(aItens[nY])]
			_nReserv	:= SuperVal(StrTran(aItens[nY,8],".",""))

			nMaximoOS := SUPERGETMV("MV_NUMITEM",.F.,0)

			If nMaximoOS <= 0
				nMaximoOS := len(aItens)
			Endif

			nCont ++
			If nY = 1
				cOrdSep	 := " "
				cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )
				CB7->(ConfirmSX8())
			Elseif nCont == nMaximoOS
				cOrdSep  := " "
				cOrdSep  := GetSXENum( "CB7", "CB7_ORDSEP" )
				CB7->(ConfirmSX8())
				nCont := 0
			Endif

			/*	If aItens[nY,7]>_nReserv .And. _nReserv<>0
			nReserva	:= aItens[nY,7]
			Else
			nReserva	:= _nReserv
			EndIf
			*/
			aSD4 := {nRecno}
			If _nReserv > 0
				U_STReserva	(cDoc,cProduto,_nReserv,"-",cFilAnt)
				U_STGrvSt	(cDoc)
				U_STGeraSDC	(cDoc,cProduto,cArm,_nReserv,nRecno,aSD4,cOrdSep)
				U_STGeraOS	("SC2",cOrdSep,aSD4,cOrdAux,cArmSel,lDifArm)
			EndIf
		Next
		If SC2->C2_XSTARES =="0"
			SC2->(RecLock('SC2'))
			SC2->C2_XPRIORI := ''
			SC2->(MsUnLock())
		EndIf
	End Transaction

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraCB7Sel บAutor  ณRenato	 		 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGerar ordem de separa็ใo individual			              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAPCP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function GeraCB7Sel(cArmEst,oFolder)
//Static Function GeraCB7Sel(cArmEst,oFolder)

	Local aRet		:={0,0}
	Local aCabDoc	:= {}
	Local aDocs		:= {}
	Local nQtdDoc 	:= GetMv("FS_QTDDOC")
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local aSC2Area	:= SC2->(GetArea())
	Local cMsgLog 	:= ''
	Local aRet 		:= {}
	Local aAux 		:= {}
	Local nX		:= 0
	Local aDocs		:= {}

	cArmSel		:= cArmEst
	lMudaQtd	:=	.F.

	cDoc	:= SC2->(FieldGet(FieldPos("C2_NUM")) + FieldGet(FieldPos("C2_ITEM")) + FieldGet(FieldPos("C2_SEQUEN")))

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2")+cDoc))

	If !SC2->(Eof())

		IF SC2->C2_QUJE==0 .AND. SC2->C2_QUANT>SC2->C2_QUJE  // FMT - Consultoria
			If ! SC2->C2_XSTARES $ "14"
				MsgAlert("C2_XSTARES diferente de 1 ou 4")
				Return
			EndIf
		Endif

		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		If U_TemDF(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
			MsgAlert("Ordem de produ็ใo:"+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+" com pend๊ncia no dep๓sito fechado.")
			Return
		EndIf

		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		If !U__CheckPA0(1)              //nใo gerar os duplicada para op 240413 abre      renato
			MsgAlert("Nใo tem saldo para gerar OS")
			Reclock("SC2",.F.)
			SC2->C2_XSTARES	:= ""
			Return
		EndIf              			//nใo gerar os duplicada para op 240413 fecha     renato

		Aadd(aDocs,{.T.,;
			SC2->C2_NUM,;
			SC2->C2_ITEM,;
			SC2->C2_SEQUEN,;
			SC2->C2_PRODUTO,;
			SC2->C2_UM,;
			SC2->C2_LOCAL,;
			SC2->C2_XPRIORI,;
			NIL,;
			SC2->C2_XLOTE,;
			SC2->C2_DATPRF,;
			SC2->(RECNO())})

		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		MsgRun( "Gerando Ordem de Separa็ใo, aguarde...",, {|| U_GeraCB7R(cArmSel,aDocs,lMudaQtd)} )

	Else
		MsgAlert("Documento nใo encontrado na tabela SC2")
		Return
	EndIf

	RestArea(aSC2Area)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStFilOper	 บAutor  ณRenato	 		 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de prioridade com filtro por operador			      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function StFilOper(cCodOpe,cArmExp,lGenerico,lTela,xnTotped,xnLix)  //StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F.
//Static Function StFilOper(cCodOpe,cArmExp,lGenerico,lTela,xnTotped,xnLix)  //StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F.

	Local aArea		:= GetArea()
	Local _aBrowse	:= {"CB7_ORDSEP","CB7_LOCAL","CB7_CODOPE","CB7_XOPEXP","CB7_PEDIDO","CB7_OP","CB7_XSEP","CB7_XPRIOR"}
	Local _aItens3	:= {}
	Local cQuery 	:= ""
	Local _cTpEnt
	Local oSay
	Local _nLix  := 0
	Local _nQtx  := 0
	Local k:=0
	Local cCodOpeGen := ""


	//cCodOpeGen := U_fTrazCB1Gen()

	//If cCodOpe == cCodOpeGen  //se a sele็ใo foi feita escolhendo o operador gen้rico, o filtro serแ pelo campo CB7_XOPEXG
	//	lGenerico := .T.
	//Endif

	If cFilAnt == '01'

		cQuery := "SELECT CB7_ORDSEP, CB7_LOCAL, CB7_CODOPE, CB7_XOPEXP, CB7_XOPEXG, CB7_PEDIDO, CB7_OP, CB7_XSEP, CB7_XPRIOR, CB7_DTEMIS, CB7_HREMIS, CB7_STATUS "
		cQuery += " FROM " +RetSqlName("CB7")
		//FR - 20/07/2021 - Filtro de operador - conforme alinhado com Jefferson
		cQuery += " WHERE D_E_L_E_T_=' ' AND CB7_STATUS='0' "
		If lGenerico
			cQuery += " AND CB7_XOPEXG = '" + Alltrim(cCodOpe) + "' "
		Else
			cQuery += " AND (   CB7_CODOPE = '" + Alltrim(cCodOpe) + "' "
			cQuery += "      OR CB7_XOPEXP = '" + Alltrim(cCodOpe) + "' "
			cQuery += "      ) "
		Endif
		//FR - 20/07/2021 - Filtro de operador - conforme alinhado com Jefferson
	Else

		cQuery := "SELECT CB7_ORDSEP, CB7_LOCAL, CB7_CODOPE, CB7_XOPEXP, CB7_XOPEXG, CB7_PEDIDO, CB7_OP, CB7_XSEP, CB7_XPRIOR, CB7_DTEMIS, CB7_HREMIS, CB7_STATUS "
		cQuery += " FROM " +RetSqlName("CB7")
		//FR - 20/07/2021 - Filtro de operador - conforme alinhado com Jefferson
		cQuery += " WHERE D_E_L_E_T_=' ' AND CB7_STATUS='0' "
		If lGenerico
			cQuery += " AND CB7_XOPEXG = '" + Alltrim(cCodOpe) + "' "
		Else
			cQuery += " AND  (  CB7_CODOPE = '" + Alltrim(cCodOpe) + "' "
			cQuery += "        OR CB7_XOPEXP = '" + Alltrim(cCodOpe) + "' "
			cQuery += "      ) "
		Endif
		//FR - 20/07/2021 - Filtro de operador - conforme alinhado com Jefferson
	EndIf
	MemoWrite("C:\TEMP\STFILOPER.SQL" , cQuery)
	//cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"

	DbSelectArea("TMP")
	TMP->(DBGoTop())

	While TMP->(!Eof())

		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+TMP->CB7_PEDIDO)

		If !SC5->(Eof())
			_cTpEnt := Iif(AllTrim(SC5->C5_XTIPO)=="1","Retira","Entrega")  //1=Retira;2=Entrega
		EndIf

		Aadd(_aItens3,{TMP->CB7_XPRIOR,;
			TMP->CB7_ORDSEP,;
			TMP->CB7_LOCAL,;
			TMP->CB7_CODOPE,;
			TMP->CB7_XOPEXP,;
			TMP->CB7_PEDIDO,;
			_cTpEnt,;
			IIF(AllTrim(SC5->C5_XORIG)=="2","Pedido de internet","Pedido normal"),;
			STOD(TMP->CB7_DTEMIS),;
			TMP->CB7_HREMIS,;
			TMP->CB7_OP,;
			TMP->CB7_STATUS,;
			U_stlinhas(TMP->CB7_ORDSEP,1),;
			U_stlinhas(TMP->CB7_ORDSEP,2 ),;
			U_STVLRLIQ(TMP->CB7_ORDSEP),;
			Round(U_STVLRLIQ(TMP->CB7_ORDSEP) / U_stlinhas(TMP->CB7_ORDSEP,1 ), 2),;     // Valdemir 20/01/2020
		TMP->CB7_XOPEXG;														//FR - 21/07/2021 - Ticket #20200710004035
		})

		TMP->(Dbskip())

	EndDo

	ASort(_aItens3,,,{|x,y| (x[1]) < (y[1])})

	For k:= 1 To Len(_aItens3)
		_nLix  += _aItens3[k,13]
		_nQtx  += _aItens3[k,14]
	Next k

	k        := 0
	xnLix    := 0
	xnTotped := 0
	If Len(_aItens3) > 0
		For k:= 1 To Len(_aItens3)
			xnLix  += _aItens3[k,13]
		Next k
		xnTotped := len(_aItens3)
	Endif

	If lTela
		If !Empty(_aItens3)

			DEFINE MSDIALOG oDlg TITLE "Tela de prioridade por operador" FROM 200,1 TO 500,1300 PIXEL //240

			@ 1,1 LISTBOX oLbx FIELDS HEADER ;
				"Prioridade", "OS", "Local", "Operador", "Operador Exp", "Pedido", "Tipo","Tipo pedido", "Dt Emis", "Hr emis", "OP", "Status" ,'Linhas','Pe็as','Vlr Res Liq',"$ /Lin","Oper.Generico" ;
				SIZE 650,095 OF oDlg PIXEL //ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

			//Exibe o Array no browse
			oLbx:SetArray( _aItens3 )
			oLbx:bLine := {||{_aItens3[oLbx:nAt,1],;
				_aItens3[oLbx:nAt,2],;
				_aItens3[oLbx:nAt,3],;
				_aItens3[oLbx:nAt,4],;
				_aItens3[oLbx:nAt,5],;
				_aItens3[oLbx:nAt,6],;
				_aItens3[oLbx:nAt,7],;
				_aItens3[oLbx:nAt,8],;
				_aItens3[oLbx:nAt,9],;
				_aItens3[oLbx:nAt,10],;
				_aItens3[oLbx:nAt,11],;
				_aItens3[oLbx:nAt,12],;
				_aItens3[oLbx:nAt,13],;		// pe็a
			_aItens3[oLbx:nAt,14],;     // Liq
			_aItens3[oLbx:nAt,15],;     // Liq
			_aItens3[oLbx:nAt,16],;
				_aItens3[oLbx:nAt,17];		//FR - 21/07/2021 - Ticket #20200710004035
			}}

			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			U_exemplob(oLbx,oDlg,_aItens3,210,730)		//FR - 20/07/2021

			@ 200,90 BTNBMP oBtn1 RESOURCE "FINAL" 	     SIZE 40,40 ACTION oDlg:End() ENABLE OF oDlg
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			@ 200,10 BTNBMP oBtn1 RESOURCE "PMSSETAUP"   SIZE 40,40 ACTION if(oLbx:nAt<>1,U_AjustPrior(_aItens3[oLbx:nAt,1],_aItens3[oLbx:nAt,2],_aItens3[oLbx:nAt-1,1],_aItens3[oLbx:nAt-1,2],@_aItens3,1),MsgSTop("Aten็ใo, primeiro documento")) ENABLE OF oDlg
			@ 200,50 BTNBMP oBtn2 RESOURCE "PMSSETADOWN" SIZE 40,40 ACTION if(oLbx:nAt<>len(_aItens3),U_AjustPrior(_aItens3[oLbx:nAt,1],_aItens3[oLbx:nAt,2],_aItens3[oLbx:nAt+1,1],_aItens3[oLbx:nAt+1,2],@_aItens3,2),MsgSTop("Aten็ใo, ๚ltimo documento")) ENABLE OF oDlg

			@ 108,80 Say oSay Var  "Total de Pedidos: "+AllTrim(Str(len(_aItens3))) Of oDlg Pixel
			@ 108,180 Say oSay Var "Total de Linhas: "+AllTrim(Str( _nLix )) Of oDlg Pixel
			@ 108,280 Say oSay Var "Total de Pe็as: "+AllTrim(Str( _nQtx  )) Of oDlg Pixel



			ACTIVATE MSDIALOG oDlg CENTER

		Else

			MsgAlert("Nใo existem ordens de separa็ใo para este operador: "+cCodOpe)

		EndIf

	Else
		TMP->(dbCloseArea())
		RestArea(aArea)


	Endif  //se mostra ou nใo a tela

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	Endif
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustPrior บAutor  ณRenato	 		 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณModifica prioridade									      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AjustPrior(_cPrior1,_cOrdSep1,_cPrior2,_cOrdSep2,_aItens3,nTipo)
//Static Function AjustPrior(_cPrior1,_cOrdSep1,_cPrior2,_cOrdSep2,_aItens3,nTipo)
//              AjustPrior(_aItens3[oLbx:nAt,1],_aItens3[oLbx:nAt,2],_aItens3[oLbx:nAt-1,1],_aItens3[oLbx:nAt-1,2],@_aItens3,1)
//                         (_cPrior1           ,_cOrdSep1           ,_cPrior2              ,_cOrdSep2             ,_aItens3 ,nTipo)

	Local aArea		:= GetArea()
	Local __n := 0
	DbSelectArea("CB7")
	DbSetOrder(1)
	DbSeek(xFilial("CB7")+_cOrdSep1)

	If !CB7->(Eof())

		CB7->(RecLock("CB7",.F.))
		CB7_XPRIOR := _cPrior2
		CB7->(MsUnLock())

	EndIf

	DbSeek(xFilial("CB7")+_cOrdSep2)

	If !CB7->(Eof())

		CB7->(RecLock("CB7",.F.))
		CB7_XPRIOR := _cPrior1
		CB7->(MsUnLock())

	EndIf

	For __n := 1 to len(_aItens3)
		DbSeek(xFilial("CB7")+_aItens3[__n,2])
		If !CB7->(Eof())
			_aItens3[__n,1] := CB7_XPRIOR
		Endif
	Next _nn
	ASort(_aItens3,,,{|x,y| (x[1]) < (y[1])})

	if nTipo == 1
		oLbx:nAt--
	else
		oLbx:nAt++
	endif

	oLbx:Refresh()

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValEstoq    บAutor  ณRenato Nogueira	 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica saldo no estoque antes de gerar OS       	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function ValEstoq(_cPedido,_nRecno,cArmSel,lOp)
//Static Function ValEstoq(_cPedido,_nRecno,cArmSel,lOp)

	Local lRet		:= .T.
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local aItens	:={}
	Local cQuery	:= ""
	Local nX:= 0
	Local _aAreaSC5	:= SC5->(GetArea())
	Local _aAreaSD2	:= SD2->(GetArea())
	Local _aArea	:= GetArea()
	Local i := 0
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	If cArmSel == cArmExp  //Pedido de vendas

		SC5->(DbSetOrder(1))
		If !SC5->(DbSeek(xFilial("SC5")+_cPedido))
			lRet	:= .F.
			MsgInfo("Pedido: "+_cPedido+" nใo encontrado, entre em contato com o TI!","Erro")
		EndIf
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		If U_PEDSEMOPER()
			lRet	:= .F.
			MsgInfo("Pedido: "+_cPedido+" com opera็ใo em branco, entre em contato com o TI!","Erro") //Chamado 002679
		EndIf

		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		U_MontaSC6(NIL,aItens)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		If SA1->(!Eof())
			If SA1->A1_MSBLQL=="1"
				lRet	:= .F.
				MsgInfo("O cliente: "+Alltrim(SC5->C5_CLIENTE)+" loja: "+SC5->C5_LOJACLI+" do pedido: "+SC5->C5_NUM+" estแ bloqueado para uso, verifique!","Erro") //Solicita็ใo Rog้rio Martelo em 09092013
			EndIf
		EndIf
	Else
		SC2->(DbGoto(_nRecno))
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		aItens	:= U__CheckPA0(2)
	EndIf

	For nX:= 1 to len(aItens)

		//Checar se possui saldo disponํvel na SBF - Legenda preta

		cQuery	:= "SELECT BF_PRODUTO, SUM(BF_QUANT-BF_EMPENHO) AS BF_SALDO "
		cQuery	+= "FROM " +RetSqlName("SBF")+ " BF "
		cQuery	+= "WHERE D_E_L_E_T_=' ' AND BF_FILIAL='"+xFilial("SBF")+"' "
		If lOp // OP
			cQuery	+= "AND (BF_LOCAL='01' OR BF_LOCAL='03' OR BF_LOCAL='15') "
		else
			cQuery	+= "AND BF_LOCAL='"+aItens[nX][8]+"' "
		Endif
		cQuery	+= "AND BF_PRODUTO='"+aItens[nX][5]+"' "
		cQuery  += "GROUP BY BF_PRODUTO "

		//cQuery := ChangeQuery(cQuery)
		TCQUERY cQuery NEW ALIAS "TMP"

		If cArmSel == cArmExp  //Pedido de vendas

			If TMP->BF_SALDO < Val(aItens[nX][10])
				lRet	:= .F.
				MsgAlert("Aten็ใo, o produto: "+Alltrim(aItens[nX][5])+" do pedido: "+_cPedido+" nใo possui saldo suficiente e a OS nใo serแ gerada, favor verifique")
			ElseIf TMP->BF_SALDO < 0
				lRet	:= .F.
				MsgAlert("Aten็ใo, o produto: "+Alltrim(aItens[nX][5])+" do pedido: "+_cPedido+" ficarแ com o saldo negativo e a OS nใo serแ gerada, favor verifique")
			EndIf

		Else

			If TMP->BF_SALDO < Val(aItens[nX][8])
				lRet	:= .F.
				MsgAlert("Aten็ใo, o produto: "+Alltrim(aItens[nX][5])+" da OP: "+_cPedido+" nใo possui saldo suficiente e a OS nใo serแ gerada, favor verifique")
			ElseIf TMP->BF_SALDO < 0
				lRet	:= .F.
				MsgAlert("Aten็ใo, o produto: "+Alltrim(aItens[nX][5])+" da OP: "+_cPedido+" ficarแ com o saldo negativo e a OS nใo serแ gerada, favor verifique")
			EndIf

		EndIf

		TMP->(DbCloseArea())

		//Checar se produto nใo possui endere็o duplicado na BF - Embalagem negativa - Chamado 000563

		cQuery	:= " SELECT FILIAL, PRODUTO, LOCAL, LOCALIZACAO, SUM(CONTADOR) CONTADOR "
		cQuery	+= " FROM ( "
		cQuery	+= " SELECT BF_FILIAL FILIAL, BF_PRODUTO PRODUTO, BF_LOCAL LOCAL, BF_LOCALIZ LOCALIZACAO, 1 AS CONTADOR "
		cQuery	+= " FROM " +RetSqlName("SBF")+ " BF "
		cQuery	+= " WHERE BF.D_E_L_E_T_=' ' AND BF_QUANT>0 AND (BF_LOCAL='01' OR BF_LOCAL='03') "
		cQuery	+= " ) HAVING SUM(CONTADOR)>1  AND PRODUTO='"+aItens[nX][5]+"' "
		cQuery	+= " GROUP BY FILIAL, PRODUTO, LOCAL, LOCALIZACAO "

		//cQuery := ChangeQuery(cQuery)
		TCQUERY cQuery NEW ALIAS "TMP"

		If cArmSel == cArmExp  //Pedido de vendas

			If TMP->CONTADOR > 1
				lRet	:= .F.
				MsgAlert("Aten็ใo, o produto: "+Alltrim(aItens[nX][5])+" possui endere็o duplicado na SBF, verifique!")
			EndIf

		EndIf

		TMP->(DbCloseArea())
		SC5->(DbGoto(_nRecno))

		If cArmSel == cArmExp  .And. Getmv("ST_FASBF",,.T.)   .And. cEmpAnt = '11'

			cProduto	:= aItens[nX,5]
			cArm		:= aItens[nX,8]

			nReserva	:= Val(StrTran(StrTran(aItens[nX][10],".",""),",","."))
			_nXsald		:= 0

			If cEmpAnt=="11" .And. cFilAnt=="01"
				aSaldos := U_SLDSTECK(cProduto,'03',nReserva,ConvUm(cProduto,2,0,nReserva),' ','','','',NIL,NIL,NIL,.f.,nil,nil,dDataBase)
			Else
				aSaldos := SldPorLote(cProduto,'03',nReserva,ConvUm(cProduto,2,0,nReserva),' ','','','',NIL,NIL,NIL,.f.,nil,nil,dDataBase)
			EndIf

			For i:=1 To Len(aSaldos)



				dbSelectArea("SBE")
				SBE->(dbSetOrder(1))
				If	SBE->(dbSeek(xFilial("SBE")+'03'+ Alltrim(aSaldos[i,3])))
					If SBE->BE_XEMPENH = 'N' 

						lRet:= .F.
						SC5->(DbGoto(_nRecno))  //posiciona na tabela SC5 atrav้s do RECNO
						Reclock("SC5",.F.)
						SC5->C5_XEMPENH:= 'S'
						SC5->(MsUnLock())
						SC5->( DbCommit())

						If 	aSaldos[i,5]<=	(nReserva-_nXsald)
							_nQtdReab:= aSaldos[i,5]
						Else
							_nQtdReab:= nReserva-_nXsald
						EndIF


						AADD(_aEmaReab,{SC5->C5_NUM,cProduto,Alltrim(aSaldos[i,3]), cValToChar(_nQtdReab) })

					EndIf
				EndIf
				_nXsald+= aSaldos[i,5]
			Next i

		EndIf

	Next

	If lRet .And. SC5->C5_XEMPENH = 'N'
		SC5->(DbGoto(_nRecno))  //posiciona na tabela SC5 atrav้s do RECNO
		Reclock("SC5",.F.)
		SC5->C5_XEMPENH:= ' '
		SC5->(MsUnLock())
		SC5->( DbCommit())
	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSD2)
	RestArea(_aAreaSC5)

Return(lRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function STQUELOADSC5(aParam,lJob,l1PN)
//Static Function STQUELOADSC5(aParam,lJob)
	//Local cMV_XCTRANS	:= SuperGetMV("MV_XCTRANS",,"02504301|03346702|05350001")
	//Local cMV_XSTCLI	:= SuperGetMV("MV_XSTCLI2",.F.,"033467")
	Local _nGetCond     :=  GetMv("ST_VALMIN",,400)//Giovani zago 24/05/13  mit006 ajuste no valor minimo
	//Local _cFa10Oper    :=  GetMv("ST_FAOPER",,'74')//Giovani zago 14/06/2013 Tipos de Opera็ใo que nao entram na separa็ใo
	Local cQuery        := ' '
	Local oDlgEmail
	Local _nVal       :=  0
	Local lSaida      := .F.
	Local _xnOpca       :=  0

    Local _cFa10Oper    :=  MontaExp(GetMv("ST_FAOPER",,'74'),3)
    Local cMV_XSTCLI	:=  MontaExp(SuperGetMV("MV_XSTCLI2",.F.,"033467"),9)
    Local cMV_XCTRANS	:=  MontaExp(SuperGetMV("MV_XCTRANS",,"02504301|03346702|05350001"),9)

	Local nDiasAnt      :=GetMv("ST_XDIASAN",,720)


	ProcRegua(4) // Numero de registros a processar

	IncProc()
	_xnOpca:=1
	/*
	desativei pois so utiliza numero de pedido giovani 30/04/18
	Do While !lSaida
	_xnOpca := 0
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Ordenar") From 1,0 To 80,200 Pixel OF oMainWnd

	@ 15,03 Button "Pedido"         Size 28,12 Action Eval({||lSaida:=.T.,_xnOpca:=1,oDlgEmail:End()})  Pixel

	@ 15,33 Button "Prioridade"  Size 38,12 Action Eval({||lSaida:=.T.,_xnOpca:=2,oDlgEmail:End()})  Pixel

	@ 15,73 Button "Data "      Size 28,12 Action Eval({||lSaida:=.T.,_xnOpca:=3,oDlgEmail:End()})  Pixel

	ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo
	*/

	IncProc()


	cQuery := ' SELECT C5_XTIPO,SC5.R_E_C_N_O_ C5REC ,c5_xpriori   ,C5_EMISSAO, c5_xorig '+CRLF
	cQuery += " FROM "+RetSqlName('SC5')+ " SC5 "+CRLF

	cQuery += "	INNER JOIN "+RetSqlName("SC6")+ " SC6 "+CRLF
	cQuery += " ON  SC6.C6_FILIAL = '"+xFilial("SC6")+"'"+CRLF 
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL"+CRLF
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM "+CRLF
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 "+CRLF
	cQuery += " AND SC6.C6_BLQ   <> 'R' "+CRLF
	cQuery += " AND SC6.C6_OPER NOT IN "+_cFa10Oper+" "+CRLF
    cQuery += " AND SC6.D_E_L_E_T_   = ' ' "+CRLF
   
    cQuery += " 	INNER JOIN  "+RetSqlName("SC9")+ " SC9 "+CRLF
	cQuery += " ON  SC9.C9_FILIAL   = SC6.C6_FILIAL " +CRLF
	cQuery += " AND SC9.C9_PEDIDO     = SC6.C6_NUM "+CRLF
	cQuery += " AND SC9.C9_ITEM = SC6.C6_ITEM "+CRLF
	cQuery += " AND SC9.C9_BLCRED = ' ' "+CRLF
	cQuery += " AND SC9.C9_NFISCAL= ' ' "+CRLF
    cQuery += " AND SC9.D_E_L_E_T_   = ' ' "+CRLF

	cQuery += " INNER JOIN "+RetSqlName("SF4")+ " SF4 "+CRLF
    cQuery += " ON	SF4.F4_FILIAL = '"+xFilial("SF4")+"'" +CRLF
    cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO "+CRLF
	cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " AND SF4.F4_ESTOQUE = 'S' "+CRLF
	
    cQuery += " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'"+CRLF
	cQuery += " AND SC5.C5_EMISSAO >= '"+dtos(dDatabase-nDiasAnt)+"' "+CRLF
	cQuery += " AND SUBSTR(C5_NOTA,1,1) <> 'X' "+CRLF
	//cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%' "+CRLF
    cQuery += " AND (SC5.C5_XPEDMKT='N' OR SC5.C5_XPEDMKT=' ') "+CRLF
	cQuery += " AND (SC5.C5_XSTARES ='1' OR SC5.C5_XSTARES ='4') "+CRLF
	cQuery += " AND SC5.C5_CLIENTE||SC5.C5_LOJACLI NOT IN "+cMV_XSTCLI+" " // Adicionado pelo Chamado 005430 - Robson Mazzarotto
    cQuery += " AND SC5.C5_ZBLOQ = '2'  and c5_xpriori <> ' ' AND C5_ZMOTBLO = ' ' "+CRLF
	cQuery += " AND SC5.C5_CLIENT||SC5.C5_LOJAENT NOT IN "+cMV_XCTRANS+" " 
    cQuery += " AND SC5.C5_XIBL <> '2' "+CRLF   //BLOQUEAR OS PEDIDOS NA MUDANวA DA IBL
	cQuery += " AND SC5.C5_ZREFNF<>'1' "+CRLF   //BLOQUEAR OS PEDIDOS COM REFATURAMENTO BLOQUEADO - RENATO 171013
	cQuery += " AND SC5.C5_XTNTFOB<>'1' "+CRLF  //BLOQUEAR OS PEDIDOS COM REFATURAMENTO BLOQUEADO - RENATO 171013
	cQuery += " AND SC5.C5_XBLQFMI <> 'S' "
	cQuery += " AND SC5.C5_TRANSP NOT IN ("+AllTrim(GetMv("STFSFA1002",,"'COMERH'"))+")
	cQuery += " AND SC5.D_E_L_E_T_   = ' ' "+CRLF
   
    If GetMv("ST_ANOSC5",,.F.)
		cQuery += " AND (  SC5.C5_XDE = '' or  SC5.C5_XATE = ''  OR ( ('"+substr(dtos(date()),7,2)+"' < SC5.C5_XDE AND SC5.C5_XMDE = '') OR ('"+substr(dtos(date()),7,2)+"' > SC5.C5_XATE AND SC5.C5_XMATE = ''))  OR ( '"+substr(dtos(date()),5,4)+"' < SC5.C5_XMDE||SC5.C5_XDE  OR '"+substr(dtos(date()),5,4)+"' > SC5.C5_XMATE||SC5.C5_XATE) ) "+CRLF
	Else
		cQuery += " AND (  SC5.C5_XDE = '' or  SC5.C5_XATE = ''  OR ( ('"+substr(dtos(date()),7,2)+"' < SC5.C5_XDE AND SC5.C5_XMDE = '') OR ('"+substr(dtos(date()),7,2)+"' > SC5.C5_XATE AND SC5.C5_XMATE = ''))  OR ( '"+substr(dtos(date()),5,4)+"' < SC5.C5_XMDE||SC5.C5_XDE||SC5.C5_XDANO  OR '"+substr(dtos(date()),5,4)+"' > SC5.C5_XMATE||SC5.C5_XATE||SC5.C5_XAANO) ) "+CRLF
	EndIf
	cQuery += " GROUP BY C5_XTIPO,SC5.R_E_C_N_O_,c5_xpriori  ,C5_EMISSAO, c5_xorig "+CRLF
	cQuery += " order by C5_XTIPO,C5_EMISSAO "+CRLF


	/*/
	cQuery := ' SELECT C5_XTIPO,SC5.R_E_C_N_O_ "C5REC"  ,c5_xpriori   ,C5_EMISSAO, c5_xorig
	cQuery += " FROM "+RetSqlName("SC5")+ ' SC5 '    "

	cQuery += " 	INNER JOIN ( SELECT * FROM "+RetSqlName("SC6")+ ") SC6
	cQuery += " ON  SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_BLQ   <> 'R'
	cQuery += " AND SC6.C6_OPER NOT LIKE '"+_cFa10Oper+"'"

	cQuery += " 	INNER JOIN ( SELECT * FROM "+RetSqlName("SC9")+ ") SC9
	cQuery += " ON  SC9.D_E_L_E_T_   = ' '
	cQuery += " AND SC9.C9_PEDIDO     = SC6.C6_NUM
	cQuery += " AND SC9.C9_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC9.C9_ITEM = SC6.C6_ITEM
	cQuery += " AND SC9.C9_BLCRED = ' '
	cQuery += " AND SC9.C9_NFISCAL= ' '

	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+ ") SF4
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '
	cQuery += " AND SF4.F4_ESTOQUE = 'S'
	cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
	
	//cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("CBA")+ ") CBA
	//cQuery += " ON SC6.C6_PRODUTO = CBA.CBA_PROD
	//cQuery += " AND SC6.C6_FILIAL = CBA.CBA_FILIAL
	//cQuery += " AND CBA.CBA_XROTAT <> '1'
	//cQuery += " AND CBA.CBA_STATUS = '5'
	
	cQuery += " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " AND SC5.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_EMISSAO >= '20130329'
	//Chamado 001109 - Marketing
	cQuery += " AND (SC5.C5_XPEDMKT='N' OR SC5.C5_XPEDMKT=' ')
	cQuery += " AND (SC5.C5_XSTARES ='1' OR SC5.C5_XSTARES ='4')
	//cQuery += " AND SC5.C5_CLIENTE NOT LIKE'"+cMV_XSTCLI+"'" // Chamado 005430 - Robson Mazzarotto
	cQuery += " AND SC5.C5_CLIENTE||SC5.C5_LOJACLI NOT LIKE'"+cMV_XSTCLI+"'" // Adicionado pelo Chamado 005430 - Robson Mazzarotto
	cQuery += " AND SC5.C5_ZBLOQ = '2'  and c5_xpriori <> ' ' AND C5_ZMOTBLO = ' '
	cQuery += " AND SC5.C5_CLIENT||SC5.C5_LOJAENT NOT LIKE '"+cMV_XCTRANS+"'"
	cQuery += " AND SC5.C5_XIBL <> '2' "//BLOQUEAR OS PEDIDOS NA MUDANวA DA IBL
	cQuery += " AND SC5.C5_ZREFNF<>'1' "//BLOQUEAR OS PEDIDOS COM REFATURAMENTO BLOQUEADO - RENATO 171013
	cQuery += " AND SC5.C5_XTNTFOB<>'1' "//BLOQUEAR OS PEDIDOS COM REFATURAMENTO BLOQUEADO - RENATO 171013
	If GetMv("ST_ANOSC5",,.F.)
		cQuery += " AND (  SC5.C5_XDE = '' or  SC5.C5_XATE = ''  OR ( ('"+substr(dtos(date()),7,2)+"' < SC5.C5_XDE AND SC5.C5_XMDE = '') OR ('"+substr(dtos(date()),7,2)+"' > SC5.C5_XATE AND SC5.C5_XMATE = ''))  OR ( '"+substr(dtos(date()),5,4)+"' < SC5.C5_XMDE||SC5.C5_XDE  OR '"+substr(dtos(date()),5,4)+"' > SC5.C5_XMATE||SC5.C5_XATE) )
	Else
		cQuery += " AND (  SC5.C5_XDE = '' or  SC5.C5_XATE = ''  OR ( ('"+substr(dtos(date()),7,2)+"' < SC5.C5_XDE AND SC5.C5_XMDE = '') OR ('"+substr(dtos(date()),7,2)+"' > SC5.C5_XATE AND SC5.C5_XMATE = ''))  OR ( '"+substr(dtos(date()),5,4)+"' < SC5.C5_XMDE||SC5.C5_XDE||SC5.C5_XDANO  OR '"+substr(dtos(date()),5,4)+"' > SC5.C5_XMATE||SC5.C5_XATE||SC5.C5_XAANO) )
	EndIf
	cQuery += " GROUP BY C5_XTIPO,SC5.R_E_C_N_O_,c5_xpriori  ,C5_EMISSAO, c5_xorig
	//If _xnOpca = 1
	//	cQuery += " order by c5_xorig desc,SC5.R_E_C_N_O_
	//ElseIf _xnOpca = 2
	//	cQuery += " order by c5_xorig desc,c5_xpriori
	//ElseIf _xnOpca=3
	//	cQuery += " order by c5_xorig desc,C5_EMISSAO
	//EndIf
	//cQuery := ChangeQuery(cQuery)
	cQuery += " order by C5_XTIPO,C5_EMISSAO
    /*/

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	IncProc()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	IncProc()
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())

Return()

//Fun็ใo: STRESFAB - Objetivo: obter o total em valor (lํquido) do pedido de venda
User Function STRESFAB(_cXPedF,_cTp,_cXOrdF,pTipo)
	Local cQuery        := ' '
	Local _nResF        := 0
	Local cPerg       	:= "RESER"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Local cCond         := ""
	Default pTipo       := ''

	If _cTp = '1'
		cQuery := "  SELECT
		cQuery += " NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(PA2.PA2_QUANT),2)),0)
		cQuery += ' "RESERVADO"
		cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA2")+" )PA2 "
		cQuery += " ON PA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM
		cQuery += " AND PA2.D_E_L_E_T_   = ' '
		cQuery += " AND PA2.PA2_FILIAL   = '"+xFilial("PA2")+"'"
		cQuery += " WHERE  SC6.D_E_L_E_T_   = ' '
		cQuery += " AND SC6.C6_NUM     = '"+_cXPedF+"'"
		cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	Else

		IF (pTipo=="SCH")
			cCond := " AND SB1.B1_XCODSE = 'S' "
		ELSEIF (pTipo=="SCH")
			cCond := " AND SB1.B1_XCODSE = 'N' AND SB1.B1_XCODSE = ' ' "
		ENDIF

		cQuery := "  SELECT "
		cQuery += "  NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(C9_QTDLIB),2)),0) "
		cQuery += '  "RESERVADO"
		cQuery += "  FROM "+RetSqlName("SC6")+" SC6
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SC9")+" )SC9 "
		cQuery += "  ON  C9_PEDIDO = C6_NUM "
		cQuery += "  AND SC9.D_E_L_E_T_   = ' ' "
		cQuery += "  AND C9_ORDSEP        = '"+_cXOrdF+"'"
		cQuery += "  AND C6_ITEM         = C9_ITEM      "
		cQuery += "  AND SC6.C6_FILIAL  = SC9.C9_FILIAL "
		if !Empty(pTipo)
			cQuery += "INNER JOIN " + RETSQLNAME("SB1") +" SB1 "
			cQuery += "ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_   = ' ' "+cCond
		Endif
		cQuery += "  WHERE  SC6.D_E_L_E_T_   = ' '
		cQuery += " AND SC6.C6_NUM     = '"+_cXPedF+"'"
		cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	EndIf

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		_nResF:= (cAliasLif)->RESERVADO
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

Return(_nResF)

	/*====================================================================================\
	|Programa  | STQUESC2LOAD   | Autor | GIOVANI.ZAGO               | Data | 21/10/2013  |
	|=====================================================================================|
	|Descri็ใo | Performace 			    										      |
	|          | 													                      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STQUESC2LOAD                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	*---------------------------------------------------*
//Static Function STQUESC2LOAD()
User Function STQUESC2LOAD()
	*---------------------------------------------------*
	Local cQuery        := ' '
	Local cPerg       	:= "SERGIO"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)

	cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

	ProcRegua(4)

	IncProc()

	cQuery += " SELECT C2_NUM, C2_ITEM, C2_SEQUEN  ,C2_XPRIORI
	cQuery += " FROM "+RetSqlName("SC2")+" SC2 "
	cQuery += " WHERE (SC2.C2_XSTARES ='1' OR SC2.C2_XSTARES ='4')
	cQuery += " AND SC2.C2_XPRIORI <> ' '
	cQuery += " AND SC2.D_E_L_E_T_ = ' '
	cQuery += " AND SC2.C2_FILIAL  = '"+xFilial("SC2")+"'"
	cQuery += " order by SC2.C2_XPRIORI

	IncProc()
	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	IncProc()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	IncProc()
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())

	Return()
	/*====================================================================================\
	|Programa  | StTpClien      | Autor | GIOVANI.ZAGO               | Data | 27/08/2013  |
	|=====================================================================================|
	|Descri็ใo | Retorna Tipo de Cliente    										      |
	|          | 													                      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StTpClien                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION	
	*---------------------------------------------------*
User Function StTpClien(_cortpcli)
//Static Function StTpClien(_cortpcli)
	*---------------------------------------------------*
	Local cQuery        := ' '
	Local cPerg       	:= "FABIOIBL"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cRet          := ' '
	Default _cortpcli	:= ' '
	cAliasLif   	    := cPerg+cHora+ cMinutos+cSegundos

	cQuery := ' SELECT SA1.A1_GRPVEN "GRUPO", SA1.A1_TIPO "TIPO"
	cQuery += " FROM "+RetSqlName("CB7")+" CB7 "
	cQuery += " inner JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_   = ' '
	cQuery += " AND SA1.A1_COD = CB7.CB7_CLIENT
	cQuery += " AND SA1.A1_LOJA = CB7.CB7_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " where CB7.D_E_L_E_T_ = ' '
	cQuery += " AND CB7.CB7_ORDSEP =  '"+_cortpcli+"'"
	cQuery += " AND CB7.CB7_FILIAL =  '"+xFilial("CB7")+"'"

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If (cAliasLif)->GRUPO = 'ST' .And. (cAliasLif)->TIPO <> 'X'  //Renato Nogueira - 13092013 - Solicita็ใo Kleber.Braga para se for exporta็ใo nใo aparecer como transfer๊ncia mesmo sendo do grupo
				cRet:= 'TRANSFERENCIA'
			ElseIf (cAliasLif)->GRUPO = 'EX' .Or. (cAliasLif)->TIPO == 'X'
				cRet:= 'EXPORTAวรO'
				//Else
				//	cRet:= 'NACIONAL'
			EndIf
			(cAliasLif)->(dbskip())

		End

	EndIf

Return(cRet)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function stlinhas(_cOrdLin ,_xn, pTipo)
//Static Function stlinhas(_cOrdLin ,_xn, pTipo)
	Local cQuery        := ' '
	Local cPerg       	:= "LINORD"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cRet          := ' '
	Local cCond         := ''
	Local _nLinRet      := 0
	Local _cLinRet      := ' '
	Local cxAliasLif   	    := cPerg+cHora+ cMinutos+cSegundos
	Default _cOrdLin	:= ' '
	Default pTipo       := ''

	If _xn =1  .Or. _xn = 3
		cQuery := " SELECT COUNT( * )
		if pTipo == "SCH"
		   cCond         := " AND SB1.B1_XCODSE = 'S' "
		elseif pTipo == "STK"
		   cCond         := " AND (SB1.B1_XCODSE = 'N' OR SB1.B1_XCODSE = ' ') "
		endif 
	Else
		cQuery := " SELECT SUM(CB8_QTDORI)
	EndIf
	cQuery += ' "QUANT"
	cQuery += " FROM "+RetSqlName("CB8")+" CB8 "
	IF !EMPTY(pTipo)
	   cQuery += "INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
	   cQuery += "ON SB1.B1_COD=CB8.CB8_PROD AND SB1.D_E_L_E_T_ = ' ' "
	ENDIF 
	cQuery += " WHERE CB8.CB8_FILIAL    =  '"+xFilial("CB8")+"'"
	cQuery += " AND CB8.D_E_L_E_T_      = ' '
	cQuery += " AND CB8.CB8_ORDSEP      = '"+_cOrdLin+"'	
	cQuery += cCond
	If  _xn = 3
		cQuery += " AND CB8.CB8_LOCAL      = '01'
	EndIf
	//cQuery := ChangeQuery(cQuery)

	If Select(cxAliasLif) > 0
		(cxAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cxAliasLif)

	dbSelectArea(cxAliasLif)
	(cxAliasLif)->(dbgotop())

	If  Select(cxAliasLif) > 0

		_nLinRet:=(cxAliasLif)->QUANT
		If  _xn = 3  .And. _nLinRet > 0
			_cLinRet := 'SIM'
		EndIf
	EndIf
	If  _xn = 3
		Return(_cLinRet)
	Else
		Return(_nLinRet)
	EndIf

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function STVLRLIQ(_OrdSep)
//Static Function STVLRLIQ(_OrdSep)

	Local _nValor	:= 0
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"

	_cQuery	 := " SELECT NVL((SELECT ROUND(SUM(C6_ZVALLIQ/C6_QTDVEN*CB8_QTDORI),2) RESLIQ "
	_cQuery  += " FROM " +RetSqlName("CB8")+ " CB8 "
	_cQuery  += " LEFT JOIN (SELECT * FROM " +RetSqlName("SC6")+ ") SC6 "
	_cQuery  += " ON CB8_FILIAL=C6_FILIAL "
	_cQuery  += " AND CB8_PEDIDO=C6_NUM AND CB8_ITEM=C6_ITEM AND C6_PRODUTO=CB8_PROD "
	_cQuery  += " WHERE CB8.D_E_L_E_T_= ' ' AND SC6.D_E_L_E_T_= ' ' AND CB8.CB8_ORDSEP='"+_OrdSep+"' "
	_cQuery  += " ),0) RESLIQ "
	_cQuery  += " FROM " +RetSqlName("CB8")+ " B8 "
	_cQuery  += " WHERE B8.D_E_L_E_T_=' ' AND B8.CB8_ORDSEP='"+_OrdSep+"' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())
		_nValor	:= (_cAlias)->RESLIQ
	EndIf

Return(_nValor)

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function STCB8PROD(_cPed,_cPro)
//Static Function STCB8PROD(_cPed,_cPro)

	Local _RetCb8	:= .F.
	Local _cQuery 	:= ""
	Local _cAlias 	:= "STCB8PROD"

	_cQuery	 := " 	SELECT * FROM " +RetSqlName("CB8")
	_cQuery  += " WHERE D_E_L_E_T_ = ' '
	_cQuery  += " AND CB8_PEDIDO = '"+_cPed+"' "
	_cQuery  += " AND CB8_FILIAL = '02'
	_cQuery  += " AND CB8_PROD = '"+_cPro+"' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())
		_RetCb8	:= .T.
	EndIf

	(_cAlias)->(dbCloseArea())

Return(_RetCb8)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEDSEMOPER  บAutor  ณRenato Nogueira	 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerificar se pedido tem opera็ใo cadastrada       	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function PEDSEMOPER()
//Static Function PEDSEMOPER()

	Local _lRetorno	:= .F.
	Local cQuery9 	:= ""
	Local cAlias9 	:= "QRYTEMP9"

	cQuery9	 := " SELECT COUNT(*) CONTADOR "
	cQuery9  += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery9  += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery9  += " ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM "
	cQuery9  += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_OPER=' ' "
	cQuery9  += " AND C5_TIPOCLI<>'X' AND C5_FILIAL='"+SC5->C5_FILIAL+"' AND C5_NUM='"+SC5->C5_NUM+"' "

	If !Empty(Select(cAlias9))
		DbSelectArea(cAlias9)
		(cAlias9)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery9),cAlias9,.T.,.T.)

	dbSelectArea(cAlias9)
	(cAlias9)->(dbGoTop())

	If (cAlias9)->(!Eof())
		If (cAlias9)->CONTADOR>0
			_lRetorno	:= .T.
		EndIf
	EndIf

Return(_lRetorno)

/*
User function INVCBA(cNupedi)

Local cInvent := .T.

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
dbGotop()
If SC6->(dbSeek(xFilial("SC6")+cNupedi))
while !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNupedi
dbSelectArea("CBA")
dbSetOrder(4)
dbGotop()
If dbSeek(xFilial("CBA")+SC6->C6_PRODUTO+"1")
while !EOF() .AND. CBA->CBA_PROD+"1" == SC6->C6_PRODUTO+"1"
IF CBA->CBA_STATUS = "1" .OR. (CBA->CBA_STATUS > "2" .AND. CBA->CBA_STATUS < "5")
cInvent := .F.
Endif
CBA->(dbSkip())
End
Endif
dbSelectArea("SC6")
dbSkip()
End
Endif

Return cInvent
*/

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function STDPLOS()
//Static Function STDPLOS()

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Os Duplicada'
	Local cFuncSent:= "STDPLOS"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin    := 0
	Local _cCopia  := 'guilherme.fernandez@steck.com.br ; everson.santana@steck.com.br ;jefferson.puglia@steck.com.br; leandro.nobre@steck.com.br'
	Local cAttach  := ''
	Local _aMsg  := {}
	Local cAliasLif := 'STDPLOS'
	Local cQuery    := ' '

	/*********************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Corre็ใo na Query que estava chumbado a tabela para empresa 010 sendo que agora a empres a้ a 110
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 11/01/2022
	Chamados.....: 20220107000504
	*********************************************/
	cQuery := " SELECT
	cQuery += " SC6.C6_NUM
	cQuery += ' "PEDIDDO",
	cQuery += " SUBSTR(C5_EMISSAO,7,2)||'/'|| SUBSTR(C5_EMISSAO,5,2)||'/'|| SUBSTR(C5_EMISSAO,1,4)
	cQuery += ' "EMISSAO",
	cQuery += " C6_PRODUTO
	cQuery += ' "PRODUTO",
	cQuery += " C6_ITEM
	cQuery += ' "ITEM",
	cQuery += " C6_QTDVEN
	cQuery += ' "QTDPED",
	cQuery += " NVL((SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_ = ' 'AND CB8.CB8_PEDIDO      = SC6.C6_NUM AND CB8.CB8_ITEM      = SC6.C6_ITEM AND CB8.CB8_PROD      = SC6.C6_PRODUTO
	cQuery += " ),0)
	cQuery += ' "ORDESEP",
	cQuery += " CASE WHEN C6_QTDVEN < NVL((SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_ = ' 'AND CB8.CB8_PEDIDO      = SC6.C6_NUM AND CB8.CB8_ITEM      = SC6.C6_ITEM AND CB8.CB8_PROD      = SC6.C6_PRODUTO AND CB8.CB8_FILIAL = SC6.C6_FILIAL
	cQuery += " ),0)
	cQuery += " THEN 'ERRADO' ELSE 'OK' END
	cQuery += ' "STATUS"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+") SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM     = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_EMISSAO > '20170101' WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_OPER      = '01' AND SC6.C6_BLQ <> 'R' AND  SC6.C6_NUM <> '372675'    AND SC6.C6_FILIAL = '02' AND C6_QTDVEN < NVL(( SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_ = ' ' AND CB8.CB8_PEDIDO      = SC6.C6_NUM AND CB8.CB8_ITEM      = SC6.C6_ITEM AND CB8.CB8_PROD      = SC6.C6_PRODUTO AND CB8.CB8_FILIAL = SC6.C6_FILIAL ),0)

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		aadd(_aMsg ,{ 'Pedido' 		,;
		'Emissao'		 		,;
		'Produto'	 			,;
		'Item'					,;
		'Qtd.'   				,;
		'Os'  	})

		While !(cAliasLif)->(Eof())

			aadd(_aMsg ,{ (cAliasLif)->PEDIDDO 	,;
			(cAliasLif)->EMISSAO		 		,;
			(cAliasLif)->PRODUTO	 			,;
			(cAliasLif)->ITEM 					,;
			cValToChar((cAliasLif)->QTDPED)   	,;
			cValToChar((cAliasLif)->ORDESEP)  	})

			(cAliasLif)->(dbSkip())
		End
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	_cEmail  := ' kleber.braga@steck.com.br  ; Simone.Mara@steck.com.br'

	If ( Type("l410Auto") == "U" .OR. !l410Auto ) .And. Len(_aMsg) > 1
		MsgInfo("Possivel erro de Os Duplicado verifique no seu E-mail.!!!!!!")

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email nใo Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)

	Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	*-------------------------------*
User Function OSAUTO(aItens2)
//Static Function OSAUTO(aItens2)
	*-------------------------------*
	local lSaida   	:= .f.
	local nOpcao   	:= 2
	Local _lret		:= .f.
	Local _cStx 	:= space(6)
	Local aArea 	:= GetArea()

	If !MsgYesNo("Deseja Separar automatico ?","Aviso")
		Return
	EndIf

	Define msDialog oDxlg Title "OS Auto" From 10,10 TO 200,250 Pixel

	@ 065,010 say "OS"   Of oDxlg Pixel
	@ 065,050 get  _cStx picture "@!"  when .t. size 050,08  Of oDxlg Pixel
	@ 075,050 Button "&Confirma"    size 40,14  action ((lSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel

	Activate dialog oDxlg centered

	If  nOpcao = 1

		DbSelectArea("CB7")
		CB7->(DbSetOrder(1))
		CB7->(DbGotop())
		If	CB7->(DbSeek(xFilial('CB7')+_cStx))
			DbSelectArea("CB8")
			CB8->(DbSetOrder(1))
			CB8->(DbGotop())
			If	CB8->(DbSeek(xFilial('CB8')+_cStx))
				While CB8->(! Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP) == xFilial('CB8')+_cStx

					CB7->(RecLock("CB7",.F.))
					CB7->CB7_STATUS := '2'
					CB7->CB7_CODOPE := '2108'
					CB7->CB7_XOPEXP := '2108'
					CB7->CB7_XVIRTU := '1'
					CB7->(MsUnLock())
					CB7->(DbCommit())

					CB8->(RecLock("CB8",.F.))
					CB8->CB8_SALDOS := 0
					CB8->CB8_XVIRTU := '1'
					CB8->(MsUnLock())
					CB8->(DbCommit())

					RecLock("CB9",.T.)
					CB9->CB9_FILIAL := xFilial("CB9")
					CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
					CB9->CB9_CODETI := ' '
					CB9->CB9_PROD   := CB8->CB8_PROD
					CB9->CB9_CODSEP := CB7->CB7_CODOPE
					CB9->CB9_ITESEP := CB8->CB8_ITEM
					CB9->CB9_SEQUEN := '01
					CB9->CB9_LOCAL  := CB8->CB8_LOCAL
					CB9->CB9_LCALIZ := CB8->CB8_LCALIZ
					CB9->CB9_LOTSUG := CB8->CB8_LOTECT
					CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
					CB9->CB9_NSERSU := CB8->CB8_NUMSER
					CB9->CB9_PEDIDO := CB8->CB8_PEDIDO
					CB9->CB9_QTESEP := CB8->CB8_QTDORI
					CB9->CB9_STATUS := "1"
					CB9->(MsUnlock())
					CB9->(DbCommit())

					CB8->(DbSkip())
				End

			Endif

			If MsgYesNo("Deseja Embalar Automatico ?")

				CB6->(RecLock("CB6",.T.))
				CB6->CB6_FILIAL := xFilial("CB6")
				CB6->CB6_VOLUME := CB7->CB7_ORDSEP+'AUTO'
				CB6->CB6_XORDSE := CB7->CB7_ORDSEP
				CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
				CB6->CB6_TIPVOL := 'AUTO'
				CB6->CB6_XVIRTU := '1'
				CB6->CB6_XPESO   :=   1
				CB6->(MsUnLock())
				CB6->(DbCommit())

				DbSelectArea("CB7")
				CB7->(DbSetOrder(1))
				CB7->(DbGotop())
				If	CB7->(DbSeek(xFilial('CB7')+_cStx))
					DbSelectArea("CB8")
					CB8->(DbSetOrder(1))
					CB8->(DbGotop())
					If	CB8->(DbSeek(xFilial('CB8')+_cStx))
						While CB8->(! Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP) == xFilial('CB8')+_cStx

							CB7->(RecLock("CB7",.F.))
							CB7->CB7_STATUS := '4'
							CB7->CB7_XVIRTU := '1'
							CB7->(MsUnLock())
							CB7->(DbCommit())

							CB8->(RecLock("CB8",.F.))
							CB8->CB8_SALDOE := 0
							CB8->CB8_XVIRTU := '1'
							CB8->(MsUnLock())
							CB8->(DbCommit())

							DbSelectArea("CB9")
							CB9->(DbSetOrder(6)) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+CB9_LOTSUG+CB9_SLOTSU+CB9_SUBVOL+CB9_CODETI
							CB9->(DbGoTop())
							If CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM)))
								RecLock("CB9",.F.)
								CB9->CB9_QTESEP := CB8->CB8_QTDORI
								CB9->CB9_VOLUME := CB8->CB8_ORDSEP+'AUTO'
								CB9->CB9_QTEEMB := CB8->CB8_QTDORI
								CB9->CB9_QTEEBQ := CB8->CB8_QTDORI
								CB9->CB9_CODEMB := 'XXX'
								CB9->CB9_LOTECT := 'XXX'
								CB9->CB9_STATUS := '3'
								CB9->(MsUnlock())
								CB9->(DbCommit())
							Endif
							CB8->(DbSkip())
						End

					Endif

				Endif
			Endif

		Else
			MsgInfo("Os Nใo Encontrada")

		Endif

	Endif
	RestArea(aArea)
	MsgInfo("Automatico Finalizado.....!!!!!!!")
	return()

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	*------------------------------------------------------------------*
User Function REABMA(_aMsg)
//Static Function REABMA(_aMsg)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Reabastecimento Local Picking'
	Local cFuncSent		:= "REABMA"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	:= ""
	Local _cCopia  	:= ' '

	_cEmail  	:=  GetMv("ST_FAMAIL",,'')

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

			EndIf

			//Gravar tabela Z35
			DbSelectArea("Z35")
			Z35->(DbSetOrder(1))
			Z35->(DbGoTop())
			If !Z35->(DbSeek(xFilial("CB7")+PADR(_aMsg[_nLin,1],TamSx3("C5_NUM")[1])+PADR(_aMsg[_nLin,2],TamSx3("B1_COD")[1])+PADR(_aMsg[_nLin,3],TamSx3("BE_LOCALIZ")[1])))

				Z35->(RecLock("Z35",.T.))
				Z35->Z35_FILIAL := xFilial("CB7")
				Z35->Z35_PEDIDO := _aMsg[_nLin,1]
				Z35->Z35_PROD 	:= _aMsg[_nLin,2]
				Z35->Z35_END 	:= _aMsg[_nLin,3]
				Z35->Z35_QTDE	:= Val(_aMsg[_nLin,4])
				Z35->Z35_DATA	:= Date()
				Z35->Z35_HORA	:= Time()
				Z35->(MsUnLock())

			EndIf

		Next

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')

	EndIf
	RestArea(aArea)
	Return()

	Return()

/*/Protheus.doc ValidOS
(long_description)
Valida Ordem de servi็o
@author user
Valdemir Rabelo - SigaMat
@since 13/08/2019
/*/

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function ValidOS(poLbx, aDocs, oTotLinh, nTotLinh, oVlrLiq, nVlrLiq, pOpcao, lAloca, lDesaloca)
//Static Function ValidOS(poLbx, aDocs, oTotLinh, nTotLinh, oVlrLiq, nVlrLiq, pOpcao, lAloca, lDesaloca)

	Local aAreaSC9 := GetArea()
	Local lRET     := .T.
	Local lTransp  := .T.
	Local lMsg     := .F.
	Local cCONF    := ""
	Local cPedido  := ""
	Local nRecCB7  := CB7->( Recno() )
	Local cMsgInf  := "Existe separa็ใo em andamento para o(s) pedido(s):" + CRLF
	Local cVldTran := SuperGetMV("FS_VLDTRAN", .F., "000163/004064")
	Local nX
	Default pOpcao := ""

	SC5->( dbSetOrder(1) )
	CB7->( dbSetOrder(2) )
	If Empty(pOpcao)
		cPedido  := aDocs[poLbx:nAt][2]
		SC5->( dbSeek(xFilial('SC5') + cPedido) )
		CB7->( dbSeek(xFilial('CB7') + cPedido) )
		lTransp := (SC5->C5_TRANSP $ cVldTran )		// S๓ Valida caso fa็a parte do parโmetro
		If lTransp .And. !lAloca .And. !lDesaloca
			CB7->( dbEVal( {|| cCONF := CB7->CB7_ORDSEP},, { || !Eof() .And. (CB7_FILIAL == xFilial('CB7') .And. CB7_PEDIDO == cPedido) .And. Empty(CB7_NOTA) } ) )
			lRET := Empty(cCONF)
			If !lRET
				MsgInfo("Jแ existe separa็ใo em andamento para este pedido. SEPARAวรO: <b>" + cCONF + "</b>", "Aten็ใo!")
				aDocs[poLbx:nAt,1] := .F.
			EndIf
		EndIf
		// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Inicio
		If !lAloca .And. !lDesaloca .And. !IsInCallStack("U_DeleCB7")
			If aDocs[poLbx:nAt][1]
				nTotLinh	+= aDocs[poLbx:nAt][9]  
				nVlrLiq		+= aDocs[poLbx:nAt][14]
			Else
				If Len(aDocs[poLbx:nAt]) >=9
					nTotLinh	-= aDocs[poLbx:nAt][9]		//FR - 05/10/2022 - Erro ao estornar - dava erro aqui porque esta posi็ใo 9 nใo existe 
				Endif 
				If Len(aDocs[poLbx:nAt]) >= 14
					nVlrLiq		-= aDocs[poLbx:nAt][14]		//FR - 05/10/2022 - Erro ao estornar - dava erro aqui porque esta posi็ใo 14 nใo existe 
				Endif
				 
			EndIf
		EndIf
		// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Fim
	Else	// Valida desmarcando op็๕es que estejam ja em andamento na separa็ใo
		For nX := 1 to Len(aDocs)
			If aDocs[nX][1]
				cCONF    := ""
				cPedido  := aDocs[nX][2]
				SC5->( dbSeek(xFilial('SC5') + cPedido) )
				CB7->( dbSeek(xFilial('CB7') + cPedido) )
				lTransp := (SC5->C5_TRANSP $ cVldTran )		// S๓ Valida caso fa็a parte do parโmetro
				if lTransp
					CB7->( dbEVal( { || cCONF := CB7->CB7_ORDSEP},, {|| !Eof() .And. (CB7_FILIAL == xFilial('CB7') .And. CB7_PEDIDO == cPedido) .And. Empty(CB7_NOTA) } ) )
					lRET := Empty(cCONF)
					If !lRET
						cMsgInf += "Pedido: <b>" + cPedido + "</b> - Separa็ใo: <b>" + cCONF +"</b>"+ CRLF
						aDocs[nX,1] := .F.
						lMsg        := .T.
					EndIf
				EndIf
			EndIf
		Next nX
		If lMsg
			MsgInfo(cMsgInf,"Aten็ใo!")
		EndIf
		lRET := .T.
	EndIf

	RestArea( aAreaSC9 )

	CB7->( dbGoto(nRecCB7) )

	// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Inicio
	If !lAloca .And. !lDesaloca .And. !IsInCallStack("U_DeleCB7")
		oTotLinh:Refresh()
		oVlrLiq:Refresh()
	EndIf
	// Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10 - Eduardo Pereira - Sigamat - 27.05.2021 - Fim

Return lRET

/*/{Protheus.doc} User Function ExpExcel
    (long_description)
    Rotina que exporta dados para planilha Excel
    Ticket: 20200401001391
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 02/04/2020
    @example
    (examples)
/*/

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function ExpExcel(aCab, aCols, aTipos)
//Static Function ExpExcel(aCab, aCols, aTipos)
	Local aCabecEX := {}
	Local aColsEX  := {}
	Local aAreaEX  := GetArea()
	Local aColTMP  := {}
	Local nY, nX

	aEval(aCab, {|X| if(!Empty(X), aAdd(aCabecEX, X),nil) })
	nLimite := 0
	// Remove campo Sele็ใo e Marca็ใo de Deletados
	For nX := 1 to Len(aCols)
		aColTMP := {}
		//FR - 06/10/2022 - Erro ao exportar para Excel , conflito de colunas - checagem do tamanho do cabe็alho x qtde colunas (itens)
		For nY := 1 to Len(aCols[nX]) 		
		    if nY > 1 
				If Len(aColTMP) < Len(aCabecEX)
			   		aAdd(aColTMP, aCols[nX][nY])
				Endif 
			Endif
		Next
		//FR - 06/10/2022 - Erro ao exportar para Excel , conflito de colunas - checagem do tamanho do cabe็alho x qtde colunas (itens)
		aAdd(aColsEX, aColTMP)
	Next

	
	//DlgToExcel({ {"ARRAY", "ROMANEIO", aCabecEX, aColsEX} })
	//StaticCall (STFSLIB, ExpotMsExcel, aCabecEX, aColsEX, aTipos,"REGISTROS - GERAR ORDEM DE SEPARAวรO")
	//FR - 19/09/2022 - No Release .33 nใo ้ mais permitido o uso de Static
	Processa( { | lEnd | U_ExpotMsExcel(aCabecEX, aColsEX,aTipos,"REGISTROS - GERAR ORDEM DE SEPARAวรO") } , "Aguarde...", "REGISTROS - GERAR ORDEM DE SEPARAวรO", .T. )

	RestArea( aAreaEX )

Return

/*/{Protheus.doc} getProd
	description
	Rotina que irแ pegar o conteudo da OP
	@type function
	@version  
	@author Valdemir Jose
	@since 28/12/2020
	@param cProgram, character, param_description
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function getProd(cProgram,cDepto,cLoteOP, pOP)
//Static Function getProd(cProgram,cDepto,cLoteOP, pOP)
	Local aAreaSC2 := GetArea()

	cProgram := ""
	cDepto   := ""
	cLoteOP  := ""
	dbSelectArea("SC2")
	if dbSeek(xFilial('SC2')+pOP)	                                                              
       cProgram := SC2->C2_XUSER
	   //FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	   cDepto   := U_getDepto(SC2->C2_ZDEPTO)
	   cLoteOP  := SC2->C2_XLOTE
	endif 

	RestArea( aAreaSC2 )

Return

/*/{Protheus.doc} getDepto
	description
	Retorna a Sele็ใo do Departamento
	Ticket:  20201106010114
	@type function
	@version  
	@author Valdemir Jose
	@since 28/12/2020
	@param pC2_ZDEPTO, param_type, param_description
	@return cRet
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function getDepto(pC2_ZDEPTO)
//Static Function getDepto(pC2_ZDEPTO)
	Local cRet   := ''
	Local nPos   := 0
	Local aDepto := { {'1','Injecao'},;
	                  {'2','Montagem'},;
					  {'3','Automaticas'},;
					  {'4','Usinagem'},;
					  {'5','Estampagem'};
					}

	nPos := aScan(aDepto, {|X| X[1]==pC2_ZDEPTO })
	if nPos > 0
       cRet := aDepto[nPos][2]
	endif

Return cRet

/*
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?ldPorLote?Autor ?Eduardo Riera         ?Data ?01.02.99 ??
???????????????????????????????????????
??escri?o ?valia os saldo por lote e Localizacao devolvendo um array  ??
??         ?ara movimentacao. Assume que o SB2 esta Travado            ??
???????????????????????????????????????
??etorno   ?01] Lote de Controle                                       ??
??         ?02] Sub-Lote                                               ??
??         ?03] Localizacao                                            ??
??         ?04] Numero de Serie                                        ??
??         ?05] Quantidade                                             ??
??         ?06] Quantidade 2aUM                                        ??
??         ?07] Data de Validade                                       ??
??         ?08] Registro do SB2                                        ??
??         ?09] Registro do SBF                                        ??
??         ?10] Array com Registros do SB8 e qtd                       ??
??         ?11] Local                                                  ??
??         ?12] Potencia                                               ??
??         ?13] Prioridade do endereco (BF_PRIOR)                      ??
???????????????????????????????????????
??arametros?xpC1: Codigo do Produto         - Obrigatorio              ??
??         ?xpC2: Local                     - Obrigatorio              ??
??         ?xpN1: Quantidade                - Obrigatorio              ??
??         ?xpN2: Quantidade 2aUM           - Obrigatorio              ??
??         ?xpC3: Lote de Controle          - Obrig. se Inf. Sub-Lote  ??
??         ?xpC4: Sub-Lote                                             ??
??         ?xpC5: Localizacao                                          ??
??         ?xpC6: Numero de Serie                                      ??
??         ?xpA1: Array para o travamento dos saldos, caso nao seja    ??
??         ?      informado nao havera travamento.                     ??
??         ?xpL1: Flag que indica se esta baixando material empenhado  ??
??         ?      ou nao                                               ??
??         ?xpC7: Local Ate (utilizado para selecao de almoxarifados)  ??
??         ?xpL2: Flag que indica se considera lotes vencidos          ??
??         ?xpA1: Array com lotes a serem desconsiderados              ??
??         ?      [1] Lote [2] Sub-Lote [3] Endereco [4] Num. de Serie ??
??         ?      [5] Qtd 1a UM a ser considerada como indisponivel    ??
??         ?      (deve ser subtraida do saldo a ser retornado)        ??
??         ?      [6] Qtd 2a UM a ser considerada como indisponivel    ??
??         ?      (deve ser subtraida do saldo a ser retornado)        ??
??         ?xpL3: Flag que indica se considera empenhos previstos      ??
??         ?xpD1: Data de referencia para verificar o saldo            ??
??         ?xpL4: .T. = Quando integrado ao WMS considera os saldos    ??
??         ?            reservados para execucao da radio frequencia   ??
??         ?xpL5: .T. = Quando utilizado retorna o saldo fisico sem    ??
??         ?            descontar o saldo empenhado/reservado          ??
???????????????????????????????????????
??  DATA   ?Programador   ?anutencao Efetuada                         ??
???????????????????????????????????????
??         ?              ?                                           ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
User Function SldSteck(cCodPro,cLocal,nQtd,nQtd2UM,cLoteCtl,cNumLote,cLocaliza,cNumSer,aTravas,lBaixaEmp,cLocalAte,lConsVenc,aLotesFil,lEmpPrevisto,dDataRef,lInfoWms,cOP,lSaldo,nPercPrM,lAtuSB2,nQtdeOri)
	Static lRDSldPor  := NIL
	Static lQuantRet  := NIL
	Static lMontSetBF := .T.
	Static lMontSetB8 := .T.
	Static aSetPorLot := {}
	Static aPrepPorLot:= {}

	Local lContSB8    := .T.
	Local lContSBF    := .T.
	Local lUtiliza    := .T.
	Local lOrdValid   := .F.

	Local aRetorno    := {}
	Local aStruSB8    := {}
	Local aStruSBF    := {}
	Local aQtdRdmake  := {}
	Local aInsert     := {}

	Local nx          := 0
	Local nAchou      := 0
	Local nEmpenho	  := 0
	Local nEmpenho2   := 0
	Local nQtdSB8     := 0
	Local nQtdSB82    := 0
	Local nReserva    := 0
	Local nReserva2   := 0
	Local nReservaSB8 := 0
	Local nReserva2SB8:= 0
	Local nRecSB8     := 0
	Local nProcura    := 0
	Local nSldRF	  := 0
	Local nPosPrep    := 0

	Local cLoteSb8    := ""
	Local cNumLSb8    := ""
	Local cQuery      := ""
	Local cOrder      := ""
	Local cOrdBkp     := ""
	Local cAliasSB8   := "SB8"
	Local cAliasSBF   := "SBF"
	Local cMD5        := ""

	Local lAglutSub   := Rastro(cCodPro,"L")
	Local lMTSLDORD   := ExistBlock("MTSLDORD")
	Local lSelLote    := (SuperGetMV("MV_SELLOTE") == "1")
	Local lTravas     := If (ValType(aTravas)!="A",.F.,.T.)
	Local lMVPerdInf  := If(Type('lPerdInf')#"L",SuperGetMV('MV_PERDINF',.F.,.F.),lPerdInf)
	Local lWmsNew     := SuperGetMV("MV_WMSNEW",.F.,.F.)
	Local lLocalWMS	  := .F.
	Local lLocalNoWMS := .F.
	Local lUsaWMS := .F.
	Local aAreaSB1	  := SB1->(GetArea())

	DEFAULT lEmpPrevisto:= .F.
	DEFAULT lInfoWms    := .F.
	DEFAULT lSaldo      := .F.
	DEFAULT cOP         := Nil
	DEFAULT lAtuSB2     := .T.
	DEFAULT nPercPrM    := 0
	DEFAULT nQtdeOri    := 0

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + cCodPro))

//?????????????????????????????????????
//?VERIFICA A EXISTENCIA DO P.E. MTSLDLOT                                 ?
//?????????????????????????????????????
	lRDSldPor := If(lRDSldPor == NIL,ExistBlock("MTSLDLOT"),lRDSldPor)
//?????????????????????????????????????
//?VERIFICA A EXISTENCIA DO P.E. MTRETLOT                                 ?
//?????????????????????????????????????
	lQuantRet := If(lQuantRet == NIL,ExistBlock("MTRETLOT"),lQuantRet)

//?????????????????????????????????????
//?nalisa os dados de entrada da funcao                                   ?
//?????????????????????????????????????
	cLocalAte := If(cLocalAte == NIL,"",cLocalAte)
	cLoteCtl  := If(cLoteCtl  == NIL .Or. Empty(cLoteCtl),"",cLoteCtl)
	cNumLote  := If(cNumLote  == NIL .Or. Empty(cNumLote) .Or. Rastro(cCodPro,"L"),"",cNumLote)
	cLocaliza := If(cLocaliza == NIL .Or. Empty(cLocaliza),If(!Empty(cNumSer),CriaVar("BF_LOCALIZ"),""),cLocaliza)
	cNumSer	  := If(cNumSer   == NIL .Or. Empty(cNumSer) ,"",cNumSer)
	lBaixaEmp := If(lBaixaEmp == NIL ,.F.,lBaixaEmp .And. !Empty(cLoteCtl+cNumLote+cLocaliza))
	lConsVenc := If(lConsVenc == NIL,SUPERGETMV("MV_LOTVENC",.T.,"S") == "S",lConsVenc)
	nQtd2UM   := If(nQtd2UM   == NIL,ConvUm(cCodPro,nQtd,0,2),nQtd2UM)
	aLotesFil := If(aLotesFil == NIL,{},aLotesFil)

	lLocalWMS	:= Localiza(cCodPro,.T.)
	lLocalNoWMS := Localiza(cCodPro)
	lUsaWMS     := (lWmsNew .And. IntWMS(cCodPro))

//?????????????????????????????????????
//?erifica se considera local de/ate                                      ?
//?????????????????????????????????????
	If Empty(cLocalAte)
		cLocalAte := cLocal
	EndIf

//?????????????????????????????????????
//?erifica os Saldos por Lote / Sub-Lote / Localizacao                    ?
//?????????????????????????????????????
	If Rastro(cCodPro)
		dbSelectArea("SB8")
		If !Empty(cLoteCtl+cNumLote)
			lOrdValid := .F.
			dbSetOrder(3)
		Else
			lOrdValid := .T.
			dbSetOrder(1)
		EndIf
		If lLocalNoWMS
			SBF->(dbSetOrder(2))
		EndIf
		//?????????????????????????????????????
		//?Otimizacao para versoes SQL                                            ?
		//?????????????????????????????????????
		aStruSB8  := SB8->(dbStruct())
		SB8->(dbCommit())
		cAliasSB8 := "SLDPORLOTE"
		cAliasSBF := "SLDPORLOTE"
		If lLocalWMS .And. !lUsaWMS
			cQuery := "SELECT "
			For nX := 1 To Len(aStruSB8)
				cQuery+=aStruSB8[nx,1]+","
				// Montagem do array que sera utilizado no TCSetField
				If lMontSetB8
					If aStruSB8[nX][2]<>"C"
						aAdd(aSetPorLot, {aStruSB8[nX][1],aStruSB8[nX][2],aStruSB8[nX][3],aStruSB8[nX][4]})
					EndIf
				EndIf
			Next nX
			lMontSetB8 := .F.
			aStruSBF:= SBF->(dbStruct())
			SBF->(dbCommit())
			For nX := 1 To Len(aStruSBF)
				cQuery+=aStruSBF[nx,1]+","
				// Montagem do array que sera utilizado no TCSetField
				If lMontSetBF
					If aStruSBF[nX][2]<>"C"
						aAdd(aSetPorLot, {aStruSBF[nX][1],aStruSBF[nX][2],aStruSBF[nX][3],aStruSBF[nX][4]})
					EndIf
				EndIf
			Next nX
			lMontSetBF := .F.
			cQuery += "SB8.R_E_C_N_O_ SB8RECNO,SBF.R_E_C_N_O_ SBFRECNO "
			cQuery += "FROM "+RetSqlName("SB8")+" SB8,"
			cQuery += RetSqlName("SBF")+" SBF "
		Else
			cQuery := "SELECT "
			For nX := 1 To Len(aStruSB8)
				cQuery+=aStruSB8[nx,1]+","
				// Montagem do array que sera utilizado no TCSetField
				If lMontSetB8
					If aStruSB8[nX][2]<>"C"
						aAdd(aSetPorLot, {aStruSB8[nX][1],aStruSB8[nX][2],aStruSB8[nX][3],aStruSB8[nX][4]})
					EndIf
				EndIf
			Next nX
			lMontSetB8 := .F.
			cQuery += "SB8.R_E_C_N_O_ SB8RECNO "
			cQuery += "FROM "+RetSqlName("SB8")+" SB8 "
		EndIf
		cQuery += "WHERE SB8.B8_FILIAL= ? AND "
		cQuery += "SB8.B8_PRODUTO= ? AND "
		aAdd(aInsert, xFilial("SB8"))
		aAdd(aInsert, cCodPro)
		If cLocal == cLocalAte
			cQuery += "SB8.B8_LOCAL= ? AND "
			aAdd(aInsert, cLocal)
		Else
			cQuery += "SB8.B8_LOCAL>= ? AND "
			cQuery += "SB8.B8_LOCAL<= ? AND "
			aAdd(aInsert, cLocal)
			aAdd(aInsert, cLocalAte)
		EndIf
		If !lOrdValid
			cQuery += "SB8.B8_LOTECTL= ? AND "
			aAdd(aInsert, cLoteCtl)
			If !Empty(cNumLote)
				cQuery += "SB8.B8_NUMLOTE= ? AND "
				aAdd(aInsert, cNumLote)
			EndIf
		EndIf
		cQuery += "SB8.B8_SALDO > 0 AND SB8.D_E_L_E_T_=' ' "
		If lLocalWMS .And. !lUsaWMS
			cQuery += "AND SBF.BF_FILIAL= ? AND "
			cQuery += "SBF.BF_PRODUTO= ? AND "
			cQuery += "SBF.BF_LOCAL=SB8.B8_LOCAL AND "
			cQuery += "SBF.BF_LOTECTL=SB8.B8_LOTECTL AND "
			aAdd(aInsert, xFilial("SBF"))
			aAdd(aInsert, cCodPro)
			If !Empty(cLocaliza)
				cQuery += "SBF.BF_LOCALIZ= ? AND "
				aAdd(aInsert, cLocaliza)
			EndIf
			If !Empty(cNumLote)
				cQuery += "SBF.BF_NUMLOTE= ? AND "
				aAdd(aInsert, cNumLote)
			EndIf
			If !Empty(cNumSer)
				cQuery += "SBF.BF_NUMSERI= ? AND "
				aAdd(aInsert, cNumSer)
			EndIf
			cQuery += "SBF.D_E_L_E_T_=' ' "
			If lOrdValid
				cOrder := "ORDER BY "+SqlOrder("B8_FILIAL+B8_PRODUTO+DTOS(B8_DTVALID)+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE")+","+SqlOrder(SBF->(IndexKey()))
			Else
				cOrder := "ORDER BY "+SqlOrder(SB8->(IndexKey()))+","+SqlOrder(SBF->(IndexKey()))
			EndIf
		Else
			If lOrdValid
				cOrder := "ORDER BY "+SqlOrder("B8_FILIAL+B8_PRODUTO+DTOS(B8_DTVALID)+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE")
			Else
				cOrder := "ORDER BY "+SqlOrder(SB8->(IndexKey()))
			EndIf
		EndIf

		//?????????????????????????????????????????????
		//?MTSLDORD - Ponto de entrada utilizado para alterar a ordenacao de requisicao de lotes ?
		//?????????????????????????????????????????????
		If lMTSLDORD
			cOrdBkp := ExecBlock("MTSLDORD",.F.,.F.,{cLoteCtl,cNumLote,cCodPro,cLocal,cLocalAte})
			If !Empty(cOrdBkp)
				cOrder := cOrdBkp
			EndIf
		EndIf

		cQuery:= (cQuery+cOrder)

		// Define um identificador para a query
		cMD5 := MD5(cQuery)
		// Monta FWPreparedStatement e ChangeQuery apenas 1x para cada variacao da query
		If (nPosPrep := aScan(aPrepPorLot,{|x| x[2] == cMD5})) == 0
			aAdd(aPrepPorLot,{FWPreparedStatement():New(), cMD5})
			nPosPrep := Len(aPrepPorLot)
			aPrepPorLot[nPosPrep][1]:SetQuery(ChangeQuery(cQuery))
		EndIf
		// Seta as variaveis na query
		For nX := 1 To Len(aInsert)
			aPrepPorLot[nPosPrep][1]:SetString(nX, aInsert[nX])
		Next nX
		// Recupera a query transformada
		cQuery := aPrepPorLot[nPosPrep][1]:getFixQuery()

		// Abre um alias com a query e ja executa o TCSetField nos campos
		cAliasSB8 := MPSysOpenQuery(cQuery, cAliasSB8, aSetPorLot)
		dbSelectArea(cAliasSB8)

		While ( !Eof() .And. xFilial("SB8")	== (cAliasSB8)->B8_FILIAL .And. ;
				cCodPro			== (cAliasSB8)->B8_PRODUTO .And.;
				(cLoteCtl		== (cAliasSB8)->B8_LOTECTL.Or.Empty(cLoteCtl)).And.;
				(cNumLote		== (cAliasSB8)->B8_NUMLOTE.Or.Empty(cNumLote)).And.;
				lContSB8 )
			lUtiliza := .T.
			nRecSB8:=(cAliasSB8)->SB8RECNO
			//?????????????????????????????????????
			//?aso tenha travado registro trava tambem o SB2                          ?
			//?????????????????????????????????????
			SB2->(dbSetOrder(1))
			If !(SB2->(MsSeek(xFilial("SB2")+cCodPro+(cAliasSB8)->B8_LOCAL)))
				CriaSB2(cCodPro,(cAliasSB8)->B8_LOCAL)
			EndIf
			If ( lTravas .And. lAtuSB2 )
				nAchou   := ASCAN(aTravas,{|x| x[1] == "SB2" .And. x[2] == SB2->(RecNo())})
				If nAchou == 0
					SoftLock("SB2")
					AADD(aTravas,{ "SB2" , SB2->(RecNo()) })
				EndIf
			EndIf
			//?????????????????????????????????????
			//?valia os Saldos por Lote e Sub-Lote                                    ?
			//?????????????????????????????????????
			nReservaSB8 :=0
			nReserva2SB8:=0
			nQtdSB8     :=Min(nQtd-nReserva,SB8Saldo(lBaixaEmp,lConsVenc,NIL,NIL,cAliasSB8,lEmpPrevisto,NIL,dDataRef,lSaldo,IIf(lMVPerdInf,cOP,Nil),nPercPrM,nQtdeOri))
			nQtdSB82    :=Min(nQtd2UM-nReserva2,SB8Saldo(lBaixaEmp,lConsVenc,NIL,.T.,cAliasSB8,lEmpPrevisto,NIL,dDataRef,lSaldo,IIf(lMVPerdInf,cOP,Nil),nPercPrM,nQtdeOri))
			If nQtdSB8 > 0 .And. If(ValType(dDataRef) == "D",(cAliasSB8)->B8_DATA <= dDataRef,.T.)
				//?????????????????????????????????????
				//?valia os saldos por Localizacao e Nr.Serie                             ?
				//?????????????????????????????????????
				If lLocalNoWMS .And. !lUsaWMS
					lContSBF := .T.
					cNumLSb8 := If(Rastro(cCodPro,"S"),(cAliasSB8)->B8_NUMLOTE,CriaVar("B8_NUMLOTE",.F.))
					cLoteSb8 := (cAliasSB8)->B8_LOTECTL
					While ( !Eof() .And. xFilial("SBF") == (cAliasSBF)->BF_FILIAL .And.;
							cCodPro	== (cAliasSBF)->BF_PRODUTO  .And.;
							cLoteSb8 == (cAliasSBF)->BF_LOTECTL .And.;
							lContSBF)
						If	( (	(cAliasSBF)->BF_LOCALIZ == cLocaliza .Or. Empty(cLocaliza)) .And.;
								( (cAliasSBF)->BF_NUMSERI == cNumSer   .Or. Empty(cNumSer))   .And.;
								(cNumLSb8 == (cAliasSBF)->BF_NUMLOTE .Or. Empty(cNumLSb8)))
							If ( If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo)) > 0 )
								nAchou   := ASCAN(aRetorno,{|x| x[1] == (cAliasSBF)->BF_LOTECTL  .And.;
									x[2]  == (cAliasSBF)->BF_NUMLOTE  .And.;
									x[3]  == (cAliasSBF)->BF_LOCALIZ  .And.;
									x[4]  == (cAliasSBF)->BF_NUMSERIE .And.;
									x[11] == (cAliasSBF)->BF_LOCAL })
								nEmpenho := nQtdSB8 - nReservaSB8
								nEmpenho2:= nQtdSB82- nReserva2SB8

								lUtiliza :=.T.
								//?????????????????????????????????????
								//?Qdo Usuario seleciona Lote manualmente, observar se utiliza registro   ?
								//?????????????????????????????????????
								If cPaisLoc == "ARG" .and. lSelLote
									If (Empty(SC6->C6_LOCALIZ) .or. Empty(SC6->C6_LOTECTL)) .and.;
											AllTrim(FunName()) $ "MATA440|MATA450|MATA456"
										lUtiliza := .F.
									EndIf
								EndIf

								//?????????????????????????????????????
								//?Executa P.E. MTSLDLOT para verificar se utiliza registro               ?
								//?????????????????????????????????????
								If lRDSldPor
									lUtiliza:= ExecBlock("MTSLDLOT",.F.,.F.,{	(cAliasSBF)->BF_PRODUTO	,;
										(cAliasSBF)->BF_LOCAL	,;
										(cAliasSBF)->BF_LOTECTL	,;
										(cAliasSBF)->BF_NUMLOTE	,;
										(cAliasSBF)->BF_LOCALIZ	,;
										(cAliasSBF)->BF_NUMSERI	,;
										nEmpenho				,;
										.F.						})
									If ValType(lUtiliza) != "L"
										lUtiliza :=.T.
									EndIf
								EndIf

								If lUtiliza
									//?????????????????????????????????????
									//?erifica se o lote deve ser considerado                                 ?
									//?????????????????????????????????????
									nProcura:=0
									If lAglutSub
										nProcura:=aScan(aLotesFil,{|x| x[1] == (cAliasSBF)->BF_LOTECTL .And. x[3] == (cAliasSBF)->BF_LOCALIZ .And. x[4] == (cAliasSBF)->BF_NUMSERI})
									Else
										nProcura:=aScan(aLotesFil,{|x| x[1] == (cAliasSBF)->BF_LOTECTL .And. x[2] == (cAliasSBF)->BF_NUMLOTE .And. x[3] == (cAliasSBF)->BF_LOCALIZ .And. x[4] == (cAliasSBF)->BF_NUMSERI})
									EndIf

									If (lAglutSub .And. nAchou == 0) .Or. !lAglutSub
										If lInfoWms
											nSldRF   := WmsSaldoSBF((cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,cCodPro,(cAliasSBF)->BF_NUMSERI,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,.T.,.T.,.F.,.T.)
											nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,nSldRF-If(nProcura>0,aLotesFil[nProcura,5],0)),nEmpenho)
											nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2,ConvUm(cCodPro, nSldRF, 0, 2)-If(nProcura>0,aLotesFil[nProcura,6],0)),nEmpenho2)
											If nEmpenho <= 0
												nEmpenho := 0
												nEmpenho2:= 0
											EndIf
										Else
											nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo)-If(nProcura>0,aLotesFil[nProcura,5],0)),nEmpenho)
											nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2,ConvUm(cCodPro, SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo), SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,.T.,lSaldo), 2)-If(nProcura>0,aLotesFil[nProcura,6],0)),nEmpenho2)
										EndIf

										If lQuantRet
											aQtdRdmake:=ExecBlock("MTRETLOT",.F.,.F.,{cCodPro,cLocal,nQtd,nQtd2UM,nEmpenho,nEmpenho2,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_NUMSERI})
											If Valtype(aQtdRdmake) == "A"
												If (Valtype(aQtdRdmake[1]) == "N") .And. (aQtdRdmake[1] <= nEmpenho) .And. (aQtdRdmake[1] >= 0)
													nEmpenho:=aQtdRdmake[1]
												EndIf
												If (Valtype(aQtdRdmake[2]) == "N") .And. (aQtdRdmake[2] <= nEmpenho2) .And. (aQtdRdmake[2] >= 0)
													nEmpenho2:=aQtdRdmake[2]
												EndIf
											EndIf
										EndIf

										If QtdComp(nEmpenho) > QtdComp(0) .Or. QtdComp(nEmpenho2) > QtdComp(0)
											AADD(aRetorno,{	(cAliasSBF)->BF_LOTECTL,;
												(cAliasSBF)->BF_NUMLOTE,;
												(cAliasSBF)->BF_LOCALIZ,;
												(cAliasSBF)->BF_NUMSERI,;
												nEmpenho,;
												nEmpenho2,;
												(cAliasSB8)->B8_DTVALID,;
												SB2->(Recno()),;
												(cAliasSBF)->SBFRECNO,;
												{{(cAliasSB8)->SB8RECNO,nEmpenho,nEmpenho2}},;
												(cAliasSBF)->BF_LOCAL,(cAliasSB8)->B8_POTENCI,(cAliasSBF)->BF_PRIOR})
										EndIf
									Else
										If lInfoWms
											nSldRF   := WmsSaldoSBF((cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,cCodPro,(cAliasSBF)->BF_NUMSERI,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,.T.,.T.,.F.,.T.)
											nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,nSldRF-If(nProcura>0,aLotesFil[nProcura,5],0))-aRetorno[nAchou,5],nEmpenho)
											nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2,ConvUm(cCodPro, nSldRF, 0, 2)-If(nProcura>0,aLotesFil[nProcura,6],0))-aRetorno[nAchou,6],nEmpenho2)
											If nEmpenho <= 0
												nEmpenho := 0
												nEmpenho2:= 0
											EndIf
										Else
											nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo)-If(nProcura>0,aLotesFil[nProcura,5],0))-aRetorno[nAchou,5],nEmpenho)
											nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2,ConvUm(cCodPro, SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo), SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,.T.,lSaldo), 2)-If(nProcura>0,aLotesFil[nProcura,6],0))-aRetorno[nAchou,6],nEmpenho2)
										EndIf

										If lQuantRet
											aQtdRdmake:=ExecBlock("MTRETLOT",.F.,.F.,{cCodPro,cLocal,nQtd,nQtd2UM,nEmpenho,nEmpenho2,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_NUMSERI})
											If Valtype(aQtdRdmake) == "A"
												If (Valtype(aQtdRdmake[1]) == "N") .And. (aQtdRdmake[1] <= nEmpenho) .And. (aQtdRdmake[1] >= 0)
													nEmpenho:=aQtdRdmake[1]
												EndIf
												If (Valtype(aQtdRdmake[2]) == "N") .And. (aQtdRdmake[2] <= nEmpenho2) .And. (aQtdRdmake[2] >= 0)
													nEmpenho2:=aQtdRdmake[2]
												EndIf
											EndIf
										EndIf

										If QtdComp(nEmpenho) > QtdComp(0) .Or. QtdComp(nEmpenho2) > QtdComp(0)
											aRetorno[nAchou,5]+=nEmpenho
											aRetorno[nAchou,6]+=nEmpenho2
											AADD(aRetorno[nAchou,10],{(cAliasSB8)->SB8RECNO,nEmpenho,nEmpenho2})
										EndIf
									EndIf
									nReserva     += nEmpenho
									nReserva2    += nEmpenho2
									nReservaSB8  += nEmpenho
									nReserva2SB8 += nEmpenho2
								EndIf
							EndIf
						EndIf
						If (nReservaSB8 >= nQtdSB8)
							lContSBF := .F.
						EndIf
						dbSelectArea(cAliasSBF)
						dbSkip()
					EndDo
				Else
					nAchou   := ASCAN(aRetorno,{|x| x[1]  == (cAliasSB8)->B8_LOTECTL .And.;
						x[2]  == If(lAglutSub,CriaVar("B8_NUMLOTE"),(cAliasSB8)->B8_NUMLOTE) .And.;
						x[11] == (cAliasSB8)->B8_LOCAL })
					nEmpenho := nQtdSB8 - nReservaSB8
					nEmpenho2:= nQtdSB82- nReserva2SB8

					lUtiliza :=.T.
					//?????????????????????????????????????
					//?Qdo Usuario seleciona Lote manualmente, observar se utiliza registro   ?
					//?????????????????????????????????????
					If cPaisLoc == "ARG" .and. lSelLote
						If (Empty(SC6->C6_LOCALIZ) .or. Empty(SC6->C6_LOTECTL)) .and.;
								AllTrim(FunName()) $ "MATA440|MATA450|MATA456"
							lUtiliza := .F.
						EndIf
					EndIf

					//?????????????????????????????????????
					//?Executa P.E. MTSLDLOT para verificar se utiliza registro               ?
					//?????????????????????????????????????
					If	lRDSldPor
						lUtiliza:= ExecBlock("MTSLDLOT",.F.,.F.,{	(cAliasSB8)->B8_PRODUTO	,;
							(cAliasSB8)->B8_LOCAL	,;
							(cAliasSB8)->B8_LOTECTL	,;
							(cAliasSB8)->B8_NUMLOTE	,;
							""						,;
							""						,;
							nEmpenho				,;
							.F.						})
						If ValType(lUtiliza) != "L"
							lUtiliza :=.T.
						EndIf
					EndIf

					If lUtiliza
						//?????????????????????????????????????
						//?erifica se o lote deve ser considerado                                 ?
						//?????????????????????????????????????
						nProcura:=0
						If lAglutSub
							nProcura:=aScan(aLotesFil,{|x| x[1] == (cAliasSB8)->B8_LOTECTL .And. x[7] == (cAliasSB8)->B8_LOCAL})
						Else
							nProcura:=aScan(aLotesFil,{|x| x[1] == (cAliasSB8)->B8_LOTECTL .And. x[2] == (cAliasSB8)->B8_NUMLOTE .And. x[7] == (cAliasSB8)->B8_LOCAL})
						EndIf

						If (lAglutSub .And. nAchou == 0) .Or. !lAglutSub
							nEmpenho := Min(If(lBaixaEmp,If(lEmpPrevisto,(cAliasSB8)->B8_QEMPPRE,SB8SALDO(.T.,,,,cAliasSB8,,,,.T.,IIf(lMVPerdInf,cOp,Nil),nPercPrM,nQtdeOri)),SB8Saldo(NIL,lConsVenc,NIL,NIL,cAliasSB8,lEmpPrevisto,NIL,dDataRef,lSaldo,IIf(lMVPerdInf,cOp,Nil),nPercPrM,nQtdeOri)-If(nProcura>0,aLotesFil[nProcura,5],0)),nEmpenho)
							nEmpenho2:= Min(If(lBaixaEmp,If(lEmpPrevisto,(cAliasSB8)->B8_QEPRE2,SB8SALDO(.T.,,,.T.,cAliasSB8,,,,.T.,IIf(lMVPerdInf,cOp,Nil),nPercPrM,nQtdeOri)),SB8Saldo(NIL,lConsVenc,NIL,.T.,cAliasSB8,lEmpPrevisto,NIL,dDataRef,lSaldo,IIf(lMVPerdInf,cOp,Nil),nPercPrM,nQtdeOri)-If(nProcura>0,aLotesFil[nProcura,6],0)),nEmpenho2)

							If lQuantRet
								aQtdRdmake:=ExecBlock("MTRETLOT",.F.,.F.,{cCodPro,cLocal,nQtd,nQtd2UM,nEmpenho,nEmpenho2,(cAliasSB8)->B8_LOTECTL,(cAliasSB8)->B8_NUMLOTE,NIL,NIL})
								If Valtype(aQtdRdmake) == "A"
									If (Valtype(aQtdRdmake[1]) == "N") .And. (aQtdRdmake[1] <= nEmpenho) .And. (aQtdRdmake[1] >= 0)
										nEmpenho:=aQtdRdmake[1]
									EndIf
									If (Valtype(aQtdRdmake[2]) == "N") .And. (aQtdRdmake[2] <= nEmpenho2) .And. (aQtdRdmake[2] >= 0)
										nEmpenho2:=aQtdRdmake[2]
									EndIf
								EndIf
							EndIf

							If QtdComp(nEmpenho) > QtdComp(0) .Or. QtdComp(nEmpenho2) > QtdComp(0)
								AADD(aRetorno,{(cAliasSB8)->B8_LOTECTL,;
									If(lAglutSub,CriaVar("B8_NUMLOTE"),(cAliasSB8)->B8_NUMLOTE),;
										"",;
										"",;
										nEmpenho,;
										nEmpenho2,;
										(cAliasSB8)->B8_DTVALID,;
										SB2->(Recno()),;
										0,;
										{{(cAliasSB8)->SB8RECNO,nEmpenho,nEmpenho2}},;
										(cAliasSB8)->B8_LOCAL,(cAliasSB8)->B8_POTENCI,''})
								EndIf
							Else
								If QtdComp(nEmpenho) > QtdComp(0) .Or. QtdComp(nEmpenho2) > QtdComp(0)
									nEmpenho :=nEmpenho -If(nProcura>0,aLotesFil[nProcura,5],0)
									nEmpenho2:=nEmpenho2-If(nProcura>0,aLotesFil[nProcura,6],0)

									If lQuantRet
										aQtdRdmake:=ExecBlock("MTRETLOT",.F.,.F.,{cCodPro,cLocal,nQtd,nQtd2UM,nEmpenho,nEmpenho2,(cAliasSB8)->B8_LOTECTL,(cAliasSB8)->B8_NUMLOTE,NIL,NIL})
										If Valtype(aQtdRdmake) == "A"
											If (Valtype(aQtdRdmake[1]) == "N") .And. (aQtdRdmake[1] <= nEmpenho) .And. (aQtdRdmake[1] >= 0)
												nEmpenho:=aQtdRdmake[1]
											EndIf
											If (Valtype(aQtdRdmake[2]) == "N") .And. (aQtdRdmake[2] <= nEmpenho2) .And. (aQtdRdmake[2] >= 0)
												nEmpenho2:=aQtdRdmake[2]
											EndIf
										EndIf
									EndIf

									aRetorno[nAchou,5]+=nEmpenho
									aRetorno[nAchou,6]+=nEmpenho2
									AADD(aRetorno[nAchou,10],{(cAliasSB8)->SB8RECNO,nEmpenho,nEmpenho2})
								EndIf
							EndIf
							nReserva     += nEmpenho
							nReserva2    += nEmpenho2
							nReservaSB8  += nEmpenho
							nReserva2SB8 += nEmpenho2
						EndIf
					EndIf
				EndIf
				If (nReserva >= nQtd)
					lContSB8 := .F.
				EndIf
				//?????????????????????????????????????
				//?aso utilize localizacao nao salta registro novamente , ja saltou no    ?
				//?aco das localizacoes .                                                 ?
				//?????????????????????????????????????
				dbSelectArea(cAliasSB8)
				While !Eof() .And. (cAliasSB8)->SB8RECNO == nRecSB8
					dbSkip()
				End
			EndDo
			//?????????????????????????????????????
			//?echa query criada                                                      ?
			//?????????????????????????????????????
			dbSelectArea(cAliasSB8)
			dbCloseArea()
			dbSelectArea("SB8")

			aInsert := aSize(aInsert,0)

			//?????????????????????????????????????
			//?erifica os saldo por Localizacao quando nao ha rastro                  ?
			//?????????????????????????????????????
		ElseIf lLocalNoWMS .And. !lUsaWMS .And. Empty(aRetorno)
			dbSelectArea("SBF")
			dbSetOrder(2)
			cAliasSBF := "SLDPORLOTE"
			aStruSBF  := SBF->(dbStruct())
			SBF->(dbCommit())
			cQuery  := "SELECT "
			For nX := 1 To Len(aStruSBF)
				cQuery+=aStruSBF[nx,1]+","
				// Montagem do array que sera utilizado no TCSetField
				If lMontSetBF
					If aStruSBF[nX][2]<>"C"
						aAdd(aSetPorLot, {aStruSBF[nX][1],aStruSBF[nX][2],aStruSBF[nX][3],aStruSBF[nX][4]})
					EndIf
				EndIf
			Next nX
			lMontSetBF := .F.
			cQuery += "SBF.R_E_C_N_O_ SBFRECNO "
			cQuery += "FROM "+RetSqlName("SBF")+" SBF "
			cQuery += "WHERE SBF.BF_FILIAL= ? AND "
			cQuery += "SBF.BF_PRODUTO= ? AND "
			aAdd(aInsert, xFilial("SBF"))
			aAdd(aInsert, cCodPro)
			If cLocal == cLocalAte
				cQuery += "SBF.BF_LOCAL= ? AND "
				aAdd(aInsert, cLocal)
			Else
				cQuery += "SBF.BF_LOCAL>= ? AND "
				cQuery += "SBF.BF_LOCAL<= ? AND "
				aAdd(aInsert, cLocal)
				aAdd(aInsert, cLocalAte)
			EndIf
			If !Empty(cLocaliza)
				cQuery += "SBF.BF_LOCALIZ= ? AND "
				aAdd(aInsert, cLocaliza)
			EndIf
			If !Empty(cNumSer)
				cQuery += "SBF.BF_NUMSERI= ? AND "
				aAdd(aInsert, cNumSer)
			EndIf
			cQuery += "SBF.D_E_L_E_T_=' ' "
			//cQuery += "ORDER BY "+SqlOrder(SBF->(IndexKey()))
			cQuery += " ORDER BY BF_FILIAL,BF_PRODUTO,BF_LOCAL,BF_LOTECTL,BF_NUMLOTE,BF_PRIOR,
			cQuery += " SUBSTR(BF_LOCALIZ,LENGTH(RTRIM(BF_LOCALIZ)),1),BF_NUMSERI

			// Define um identificador para a query
			cMD5 := MD5(cQuery)
			// Monta FWPreparedStatement e ChangeQuery apenas 1x para cada variacao da query
			If (nPosPrep := aScan(aPrepPorLot,{|x| x[2] == cMD5})) == 0
				aAdd(aPrepPorLot,{FWPreparedStatement():New(), cMD5})
				nPosPrep := Len(aPrepPorLot)
				aPrepPorLot[nPosPrep][1]:SetQuery(ChangeQuery(cQuery))
			EndIf
			// Seta as variaveis na query
			For nX := 1 To Len(aInsert)
				aPrepPorLot[nPosPrep][1]:SetString(nX, aInsert[nX])
			Next nX
			// Recupera a query transformada
			cQuery := aPrepPorLot[nPosPrep][1]:getFixQuery()

			// Abre um alias com a query e ja executa o TCSetField nos campos
			cAliasSBF := MPSysOpenQuery(cQuery, cAliasSBF, aSetPorLot)
			dbSelectArea(cAliasSBF)

			While ( !Eof() .And. xFilial("SBF") == (cAliasSBF)->BF_FILIAL .And.;
					cCodPro	== (cAliasSBF)->BF_PRODUTO .And. lContSBF)
				//?????????????????????????????????????
				//?aso tenha travado registro trava tambem o SB2                          ?
				//?????????????????????????????????????
				SB2->(dbSetOrder(1))
				If !(SB2->(MsSeek(xFilial("SB2")+cCodPro+(cAliasSBF)->BF_LOCAL)))
					CriaSB2(cCodPro,(cAliasSBF)->BF_LOCAL)
				EndIf
				If ( lTravas .And. lAtuSB2 )
					nAchou   := ASCAN(aTravas,{|x| x[1] == "SB2" .And. x[2] == SB2->(RecNo())})
					If nAchou == 0
						SoftLock("SB2")
						AADD(aTravas,{ "SB2" , SB2->(RecNo()) })
					EndIf
				EndIf
				If	( ((cAliasSBF)->BF_LOCALIZ == cLocaliza  .Or. Empty(cLocaliza) ) .And. ((cAliasSBF)->BF_NUMSERI == cNumSer  .Or. Empty(cNumSer)) )
					If (If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo)) > 0)
						If lInfoWms
							nSldRF   := WmsSaldoSBF((cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,cCodPro,(cAliasSBF)->BF_NUMSERI,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,.T.,.T.,.F.,.T.)
							nEmpenho := nQtd - nReserva
							nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,nSldRF),nEmpenho)
							nEmpenho2:= nQtd2UM - nReserva2
							nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2, ConvUm(cCodPro, nSldRF, 0, 2) ),nEmpenho2)
							If nEmpenho <= 0
								nEmpenho := 0
								nEmpenho2:= 0
							EndIf
						Else
							nEmpenho := nQtd - nReserva
							nEmpenho := Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPENHO,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,NIL,lSaldo)),nEmpenho)
							nEmpenho2:= nQtd2UM - nReserva2
							nEmpenho2:= Min(If(lBaixaEmp,(cAliasSBF)->BF_EMPEN2,SBFSaldo(NIL,cAliasSBF,lEmpPrevisto,.T.,lSaldo)),nEmpenho2)
						EndIf
						lUtiliza :=.T.
						//?????????????????????????????????????
						//?Qdo Usuario seleciona Lote manualmente, observar se utiliza registro   ?
						//?????????????????????????????????????
						If cPaisLoc == "ARG" .and. lSelLote
							If (Empty(SC6->C6_LOCALIZ) .or. Empty(SC6->C6_LOTECTL)) .and.;
									AllTrim(FunName()) $ "MATA440|MATA450|MATA456"
								lUtiliza := .F.
							EndIf
						EndIf
						//?????????????????????????????????????
						//?Executa P.E. MTSLDLOT para verificar se utiliza registro               ?
						//?????????????????????????????????????
						If lRDSldPor
							lUtiliza:= ExecBlock("MTSLDLOT",.F.,.F.,{	(cAliasSBF)->BF_PRODUTO	,;
								(cAliasSBF)->BF_LOCAL	,;
								""						,;
								""						,;
								(cAliasSBF)->BF_LOCALIZ	,;
								(cAliasSBF)->BF_NUMSERI	,;
								nEmpenho				,;
								.F.						})
							If ValType(lUtiliza) != "L"
								lUtiliza :=.T.
							EndIf
						EndIf

						If lUtiliza
							//?????????????????????????????????????
							//?erifica se o lote deve ser considerado                                 ?
							//?????????????????????????????????????
							nProcura :=0
							nProcura :=aScan(aLotesFil,{|x| x[3] == (cAliasSBF)->BF_LOCALIZ .And. x[4] == (cAliasSBF)->BF_NUMSERI .And. x[7] == (cAliasSBF)->BF_LOCAL})
							nEmpenho :=nEmpenho -If(nProcura>0,aLotesFil[nProcura,5],0)
							nEmpenho2:=nEmpenho2-If(nProcura>0,aLotesFil[nProcura,6],0)

							If lQuantRet
								aQtdRdmake:=ExecBlock("MTRETLOT",.F.,.F.,{cCodPro,cLocal,nQtd,nQtd2UM,nEmpenho,nEmpenho2,NIL,NIL,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_NUMSERI})
								If Valtype(aQtdRdmake) == "A"
									If (Valtype(aQtdRdmake[1]) == "N") .And. (aQtdRdmake[1] <= nEmpenho) .And. (aQtdRdmake[1] >= 0)
										nEmpenho:=aQtdRdmake[1]
									EndIf
									If (Valtype(aQtdRdmake[2]) == "N") .And. (aQtdRdmake[2] <= nEmpenho2) .And. (aQtdRdmake[2] >= 0)
										nEmpenho2:=aQtdRdmake[2]
									EndIf
								EndIf
							EndIf

							nReserva  += nEmpenho
							nReserva2 += nEmpenho2

							If QtdComp(nEmpenho) > QtdComp(0) .Or. QtdComp(nEmpenho2) > QtdComp(0)
								AADD(aRetorno,{	""						,;
									""						,;
									(cAliasSBF)->BF_LOCALIZ	,;
									(cAliasSBF)->BF_NUMSERI	,;
									nEmpenho				,;
									nEmpenho2				,;
									Ctod("")				,;
									SB2->(Recno())			,;
									(cAliasSBF)->SBFRECNO   ,;
									{}						,;
									(cAliasSBF)->BF_LOCAL,0,(cAliasSBF)->BF_PRIOR})
							EndIf
						EndIf
					EndIf
				EndIf
				dbSelectArea(cAliasSBF)
				dbSkip()
				If ( nReserva >= nQtd )
					lContSBF:= .F.
				EndIf
			EndDo
			//?????????????????????????????????????
			//?echa query criada                                                      ?
			//?????????????????????????????????????
			dbSelectArea(cAliasSBF)
			dbCloseArea()
			dbSelectArea("SBF")

			aInsert := aSize(aInsert,0)

		EndIf

		RestArea(aAreaSB1)
		Return(aRetorno)

/*/Protheus.doc PesqNumP
		(long_description) Tratamento para localizar o registro informado no campo. - Ticket 20210524008544 - Melhoria Tela de Gerar Objeto: U_STFSFA10
		@author Eduardo Pereira - Sigamat
		@since 27/05/2021
		@version 12.1.25
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function PesqNumP(aDocs,cPesqPed,oLbx,nTotLinh,nVlrLiq)
//Static Function PesqNumP(aDocs,cPesqPed,oLbx,nTotLinh,nVlrLiq)

	Local nPos	:= 0
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" )
	Local oOk	:= LoadBitmap( GetResources(), "LBTIK" )

	If Empty(cPesqPed)
		apMsgInfo("Para localizar precisa informar o Nro do Pedido","Aten็ใo")
		Return
	EndIf

	nPos := aScan(aDocs, { |x| Alltrim(x[2]) == Alltrim(cPesqPed)} )

	If nPos > 0
		oLbx:nAT := nPos
		oLbx:SetArray(aDocs)
		oLbx:bLine := {|| { Iif(aDocs[oLbx:nAt,1],oOk,oNo),;
			aDocs[oLbx:nAt,2],;
			aDocs[oLbx:nAt,3],;
			aDocs[oLbx:nAt,4],;
			aDocs[oLbx:nAt,5],;
			aDocs[oLbx:nAt,6],;
			aDocs[oLbx:nAt,7],;
			aDocs[oLbx:nAt,8],;
			aDocs[oLbx:nAt,9],;
			aDocs[oLbx:nAt,10],;
			aDocs[oLbx:nAt,11],;
			aDocs[oLbx:nAt,12],;
			aDocs[oLbx:nAt,13],;
			aDocs[oLbx:nAt,14],;
			aDocs[oLbx:nAt,15]}}
		aDocs[oLbx:nAt,1] := .T.
		nTotLinh	+= aDocs[oLbx:nAt,9]
		nVlrLiq		+= aDocs[oLbx:nAt,14]
	EndIf

	oLbx:SetFocus()
	oLbx:Refresh()

Return


/*==========================================================================
|Funcao    | AlocaAut          | Flแvia Rocha         | Data | 27/05/2021  |
============================================================================
|Descricao | Gera uma tela com os operadores a serem marcados p/ alocar	   | 
|            para separa็ใo            	  						           |
============================================================================
|Observa็๕es: Gen้rico      											   |
==========================================================================*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AlocaAut(cArmSel)		
//Static Function AlocaAut(cArmSel)		

Local lAdmin 		:= .F. 
Local aCabDoc		:= {}
Local aDocs			:= {}
//Local aRet			:= {}
//Local aParamOper	:= {}
Local aArea			:= GetArea()
Local cCodOpe 		:= Space(6)
Local cCodOpExp		:= Space(6)
Local cCodOp2		:= Space(6)
Local cCodOp3		:= Space(6)
Local cCodOp4		:= Space(6)
Local cCodOp5		:= Space(6)
Local cArmExp 		:= GetMv("FS_ARMEXP")
//Local cArmEst 		:= GetMv("FS_ARMEST")
Local cMsgLog		:= ""
Local _cFitro := "(Empty(CB7_LOCAL) .Or. CB7_LOCAL = '"+cArmExp+"')"

Local cCodOpeGen := "" //operador gen้rico
Local fr

Private _xDlg

Default xnTotped := 0
Default xnLix    := 0

//FR - 10/06/2021 - #20200710004035 - adicionar um operador gen้rico para a consulta abaixo
//U_fTrazCB1Gen - seleciona na CB1 o operador "GENERICO" e adiciona o c๓digo na variแvel
cCodOpeGen := U_fTrazCB1Gen()

CB7->(DbClearFilter())

lAdmin := Empty(cArmSel)

If cArmSel == cArmExp  //Pedido de vendas
	//aCabDoc:= {"CB7_ORDSEP","CB7_PEDIDO","NOME"}
	//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7	
	aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO", "RECCB7"}   	
Else
	//aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO"}		
	//FR - 17/08/2022 - INSERIR A POSIวรO DO RECNO DA CB7	
	aCabDoc:= {"CB7_ORDSEP","CB7_OP","CB7_PEDIDO", "RECCB7"}   	
EndIf
//aqui seleciona os pedidos x OS
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
Processa({|| aDocs := U_LoadCB7(aCabDoc,cArmSel,,,,@cMsgLog)},"Selecionando Registros Aguarde!!!!!!")

//aqui mostra a tela dos pedidos de venda para serem marcados
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
U_SelDoc(aCabDoc,aDocs,"Aloca็ใo Automแtica - Ordem de Separa็ใo",cMsgLog,,.T.)
If Empty(aDocs)
	Return
EndIf

aOpers := {}

//aqui ao inv้s de mostrar perguntas, jแ abre tela com os possํveis operadores (que estใo sem OS , para poderem ser [x] marcados)
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
U_SelOpers(@aOpers,cCodOpeGen)

//Povoar estas variแveis com as marca็๕es da tela
cCodOpe		:= "" 
cCodOpExp	:= "" 
cCodOp2		:= "" 
cCodOp3		:= "" 
cCodOp4		:= "" 
cCodOp5		:= "" 

If Len(aOpers) <= 0
	Return
Endif

nConta := 1
For fr := 1 to Len(aDocs)
	If aDocs[fr,1]
		nRecCb7   := aDocs[fr, (Ascan(aCabDoc, "RECCB7")) + 1] //aDocs[fr,Len(aDocs[fr])]
		If nConta <= Len(aOpers)
			cCodOpExp := aOpers[nConta]
		Else
			cCodOpExp := aOpers[Len(aOpers)]  //senใo recebe o ฺLTIMO
		Endif			
		
		//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
		MsgRun( "Gravando a aloca็ใo, aguarde...",, {|| U_AlocaR2(cCodOpExp,cCodOpeGen,nRecCb7)} )
		nConta++
	Endif	
Next

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
U_StFilOper(cCodOpeGen,cArmExp,.T.,.F.,@xnTotped,@xnLix) //OPERADOR GENษRICO = .T. MAS TELA = .F.

DbSelectArea("CB7")
SET FILTER TO &(_cFitro)
RestArea(aArea)

Return

//==================================================================================//
//Fun็ใo  : AlocaR2  
//Autoria : Flแvia Rocha
//Data    : 28/05/2021
//Objetivo: Grava as informa็๕es dos separadores nas OS's selecionadas pelo usuแrio
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AlocaR2(cOpExp,cOpegen,nRecCb7)	
//Static Function AlocaR2(cOpExp,cOpegen,nRecCb7)	
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())	

	CB7->(DbGoto(nRecCb7))
	CB7->(RecLock('CB7',.F.))
	If Empty(CB7->CB7_XOPEXP)
		CB7->CB7_XOPEXP:= cOpExp
		//msgalert("Teste OS: " + CB7->CB7_ORDSEP + " - gravou expedi็ใo: " + cOpExp)  //teste retirar
	Endif

		
		//-------------------------------------------------------------------------------------------------//
		//FR - 23/08/2022 - Ajuste perante valida็ใo de Jefferson Puglia, 
		//qdo um operador assumir uma OS que jแ estแ alocada para outro operador,
		//mas este 1o. operador nใo iniciou a separa็ใo, o sistema deixa este novo operador "furar a fila"	
		//-------------------------------------------------------------------------------------------------//
		If Empty(CB7->CB7_CODOPE)
			CB7->CB7_CODOPE:= cOpExp
		Endif
		//FR - 23/08/2022 

		If Empty(CB7->CB7_XOPEXG)
			CB7->CB7_XOPEXG:= cOpegen
			//msgalert("Teste OS: " + CB7->CB7_ORDSEP + " - gravou generico: " + cOpegen)  //teste retirar
		Endif
	CB7->(MsUnLock())
	
	RestArea(aAreaCB7)
	RestArea(aArea)

Return



//==================================================================================//
//Fun็ใo  : SelOpers  
//Autoria : Flแvia Rocha
//Data    : 28/05/2021
//Objetivo: Efetua consulta aos operadores x ordens separa็ใo e monta tela sele็ใo
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function SelOpers(aOpers,cOpegen)
//Static Function SelOpers(aOpers,cOpegen)
Local oDlgF3   := Nil 
Local oLbxF3
Local bLineF3
Local cSql     		:= ""
Local aVetF3   		:= {}

Local oOk      		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo      		:= LoadBitmap( GetResources(), "LBNO" )
Local oConf
Local oCanc 
Local oOper
Local oTBPesq
Local xOpConf  		:= 0
Local lTUDOK   		:= .F.
Private aInfo  		:= {}
Private aObjects 	:= {}
Private aSize       := {}


Define FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

cAux := "{IF(aVetF3[oLbxF3:nAt,1],oOk,oNo) "
cAux += ",aVetF3[oLbxF3:NAT,2]"
cAux += ",aVetF3[oLbxF3:nAt,3]"
cAux += ",aVetF3[oLbxF3:nAt,4]"
cAux += ",aVetF3[oLbxF3:nAt,5]"
//cAux += ",aVetF3[oLbxF3:nAt,6]"
//cAux += ",aVetF3[oLbxF3:nAt,7]"
//cAux += ",aVetF3[oLbxF3:nAt,8]"
//cAux += ",aVetF3[oLbxF3:nAt,9]"
cAux += "} 

bLineF3 := &("{ || "+ cAux +" }") 

//--------------------------------------//
//CB7_XSEP - Status Separa็ใo na CB7: 
//1=Concluido;2=Aberto
//--------------------------------------//

cSql += " SELECT CB1_CODOPE CODOPE, CB1_NOME NOMEOPER, "
cSql += " CASE WHEN CB1_STATUS = '1' THEN 'ATIVO' ELSE
cSql += " CASE WHEN CB1_STATUS = '2' THEN 'PAUSA' END END STATUS, "
cSql += " ("
cSql += "   SELECT COUNT(*)   FROM " + RetSqlName("CB7") + " CB7 "
cSql += "   WHERE CB7_FILIAL = '" + Alltrim(xFilial("CB7")) + "' AND CB7_XOPEXP = CB1.CB1_CODOPE " 
cSql += "   AND CB7_FILIAL   = CB1.CB1_FILIAL AND CB7.D_E_L_E_T_ <> '*' "
cSql += "   AND ( (CB7_STATUS='0') OR (CB7_STATUS='1' AND CB7_STATPA='1') ) " 
cSql += "   AND CB7.CB7_NOTA = ' ' "
cSql += " ) AS QTOS,
cSql += " CB1.*
cSql += " FROM " + RetSqlname("CB1") + "  CB1 "
cSql += " WHERE CB1.D_E_L_E_T_ <> '*' "
cSql += " AND CB1.CB1_FILIAL = '" + Alltrim(xFilial("CB1")) + "' "
cSql += " AND CB1.CB1_STATUS <> '2' "		//1=Ativo;2=Inativo;3=Pausa
//cSql += " AND QTOS = 0 "		//nใo  filtrar por zero OS
cSql += " AND CB1.CB1_CODOPE <> '" + cOpegen + "' " 
cSql += " AND CB1.CB1_CODOPE <> '999999' "  //Administrador
cSql += " ORDER BY QTOS, CB1_NOME "    

MemoWrite("C:\TEMP\selopers.SQL", cSql)
		
Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)

TcQuery cSql New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
		
If XF3TAB->(EOF()) .AND. XF3TAB->(EOF())
	aAdd(aVetF3,{.F.   ,""       ,""        ,""     ,""        })   
	            //marca,cod. oper, nome oper, status, qtas os  
Else
	XF3TAB->(dbGoTop())
	While XF3TAB->(!EOF())
		aAdd( aVetF3,{ .F. , XF3TAB->CODOPE, XF3TAB->NOMEOPER, XF3TAB->STATUS, XF3TAB->QTOS } )
		XF3TAB->(dbSkip())
	EndDo
EndIf
XF3TAB->(dbCloseArea())

U_CALCTELA()
aInfo    := {}
aObjects := {}
aPos     := {}
 
//========================================//
//GERA A DIALOG PRINCIPAL                   
//========================================//

///novo calculo tela
aPos1 := {}
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
aPos1 := U_xFRTela(oMainWnd,"TOT") 
  

nLiIni := aPos1[1]		//231.25		
nCoIni := aPos1[2]		//1					
nLiFim := aPos1[3]		//446.50 		
nCoFim := aPos1[4] 		//956

nWidth := (nCoFim/2)-10  	//468  	 
nHeight:= ((nLiFim/2)/2)+20		//131.625		 
///novo calculo  tela


	
Define MsDialog oDlgF3 TITLE "Sele็ใo Operadores - Expedi็ใo" /*STYLE DS_MODALFRAME*/ From nLiIni,nCoIni To nLiFim,nCoFim OF oMainWnd PIXEL    
                                                               //   1        2          3                4        5        
	oLbxF3:= TWBrowse():New( nLiIni+5, nCoIni+5, nWidth, nHeight+10 ,,{"","Cod.Operador","Nome Operador","Status","Qtd. OS Tem Atualmente"},,oDlgF3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)	
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oLbxF3:bLDblClick := { || U_fMarkOS(aVetF3,oLbxF3) } 
	oLbxF3:SetArray(aVetF3)
	oLbxF3:bLine := bLineF3
	
	nLiIni := nHeight + 20
	nCoIni := nCoIni + 5	

	@ nLiIni   , nCoIni SAY "[x] Marque Para Selecionar Operador(es) Expedi็ใo" SIZE 180,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE //Centered
	
	nLiIni   := nLiIni +15
	cOper    := SPACE(80)
	oOper    := TGet():New( nLiIni, nCoIni,bSetGet(cOper) ,oDlgF3,080,010,'@X',{||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.   ,"",cOper ,,,,,,,"Nome Operador",1 )		
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oTBPesq  := TButton():New( nLiIni+7, nCoIni+82, "Pesquisa",oDlgF3,{||Processa({|| U_fPesqOper(aVetF3,oLbxF3,oLbxF3:bLine,cOper)}, "Localizando Operador...")}, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	
	nLiIni  := nLiIni + 10
	nCoFim1 := nWidth -150 
	nCoFim2 := nWidth -130
	
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@nLiIni, nCoFim1 BUTTON oConf PROMPT "Confirmar" ACTION Processa( { || (xOpConf := 1 , aOpers := U_XSelOpexp(aVetF3,@lTUDOK), iif(lTUDOK, oDlgF3:End(),xOpConf := 0) ) }, "Aguarde...", "Adicionando Operadores...",.F.)	 SIZE 037,12 OF oDlgF3 PIXEL
	nCoFim2 += 50
	 
	@ nLiIni, nCoFim2    BUTTON oCanc PROMPT "Sair" ACTION (oDlgF3:End()) SIZE 037,12 OF oDlgF3 PIXEL
		

ACTIVATE MSDIALOG oDlgF3 CENTER
	

Return

//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
//==================================================================================//
//Fun็ใo  : fPesqOper 
//Autoria : Flแvia Rocha
//Data    : 17/06/2021
//Objetivo: Pesquisa no array de operadores para posicionar no registro desejado
//==================================================================================//
User Function fPesqOper(aVetF3,oLbxF3,zLine,xOper)  //fRefreshitem(aVetF3,aItensXML,oLbxF3,zLine)
//Static Function fPesqOper(aVetF3,oLbxF3,zLine,xOper)  //fRefreshitem(aVetF3,aItensXML,oLbxF3,zLine)
Local xPos := 0
Local xf   := 0

If Empty(xOper)
	Alert("Nome Operador Vazio !")
	Return 
Endif

For xf := 1 to Len(aVetF3)
	If Alltrim(Upper(xOper)) $ Alltrim(Upper(aVetF3[xf,3]))
		xPos := xf
		Exit 
	Endif
Next

If xPos > 0
	oLbxF3:nAt := xPos  //posiciona no operador pesquisado ou no mais pr๓ximo que encontrar
	cOper      := "" //limpa o campo	
Endif

Return


//==================================================================================//
//Fun็ใo  : XSelOpexp 
//Autoria : Flแvia Rocha
//Data    : 28/05/2021
//Objetivo: Processa o array de operadores marcados para retornar เ tela de grava็ใo
//          das OS's
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function XSelOpexp(aVetF3,lTUDOK)
//Static Function XSelOpexp(aVetF3,lTUDOK)
Local xOpers := {}
Local fr     := 0

For fr := 1 to Len(aVetF3)
	If aVetF3[fr][1] 				//.T. marcado 	//valida marcados
		Aadd(xOpers , aVetF3[fr,2])	//adiciona o c๓digo do operador
		lTUDOK 	:= .T.
	Endif
Next


Return(xOpers)

//==================================================================================//
//Fun็ใo  : fMarkOS  
//Autoria : Flแvia Rocha
//Data    : 28/05/2021
//Objetivo: Marca / Desmarca operador da tela de sele็ใo operadores
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fMarkOS(aVetF3,oLbxF3)
//Static Function fMarkOS(aVetF3,oLbxF3)
Local nCol := 0
Local nRow := 0

nCol      := oLbxF3:ColPos() 
nRow    := oLbxF3:NAT 

If nCol == 1
	aVetF3[oLbxF3:nAt][1] := !aVetF3[oLbxF3:nAt][1] 
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ CALCTELA ณ Autor ณ Flแvia Rocha          ณ Data ณ30/03/2020ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Calcula o tamanho da tela de acordo com a resolu็ใo        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
USER FUNCTION CALCTELA()
//STATIC FUNCTION CALCTELA()
	//-------------------------------------------------------//
	//Retorna area de trabalho e coordenadas para janela
	//-------------------------------------------------------//
	aSIZE := MsAdvSize(.T.)
	// .T. se tera enchoicebar
	* Retorno:
	* 1 Linha inicial area trabalho.
	* 2 Coluna inicial area trabalho.
	* 3 Linha final area trabalho.
	* 4 Coluna final area trabalho.    
	* 5 Coluna final dialog (janela).
	* 6 Linha final dialog (janela).
	* 7 Linha inicial dialog (janela).
	                  
	//--------------------------------------------------------------------------------------//
	//Contera parametros utilizados para calculo de posicao usadas pelo objetos na tela
	//--------------------------------------------------------------------------------------//
	aObjects := {}
	
	AAdd( aObjects, { 0, 95, .T., .F., .F. } ) // Coordenadas para o ENCHOICE
	// largura
	// altura
	// .t. permite alterar largura
	// .t. permite alterar altura
	// .t. retorno: linha, coluna, largura, altur
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	AAdd( aObjects, { 0, 0, .T., .T., .F. } ) // Coordenadas para o MSGETDADOS
	// largura
	// altura
	// .t. permite alterar largura
	// .f. NAO permite alterar altura ***
	// .t. retorno: linha, coluna, largura, altura
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	
	AAdd( aObjects, { 0, 60, .T., .F., .T. } ) // Coordenadas para o FOLDER
	// largura
	// altura
	// .t. permite alterar largura
	// .f. NAO permite alterar altura ***
	// .t. retorno: linha, coluna, largura, altura
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	//-------------------------------------------------------------------//
	//Informacoes referente a janela que serao passadas ao MsObjSize
	//-------------------------------------------------------------------//
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 } 
	// aSize[1] LI 
	// aSize[2] CI 
	// aSize[3] LF 
	// aSize[4] CF 
	// 3        separacao horizontal  
	// 3        separacao vertical
	
	aPos  := MsObjSize( aInfo, aObjects )
	               
	// {  {} , {} , {} } 
	
	// aPos - array bidimensional, cada elemento sera um array com as coordenadas 
	// para cada objeto
	//
	// 1 -> Linha inicial        aObjects[ N , 5 ] ==== .F. 
	// 2 -> Coluna inicial
	// 3 -> Linha final
	// 4 -> Coluna final
	// 
	// ou
	// 
	// 1 -> Linha inicial        aObjects[ N , 5 ] ==== .T. 
	// 2 -> Coluna inicial
	// 3 -> Largura X
	// 4 -> Altura Y
	
RETURN



//==================================================================================//
//Fun็ใo  : exemploa  
//Autoria : Flแvia Rocha
//Data    : 02/07/2021
//Objetivo: Monta bot๕es de ordena็ใo e retornar da tela de OS's nใo alocadas
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User function exemploa(oLbx,oParent,aCabDoc,aDocs,xLin,xCol)
//Static function exemploa(oLbx,oParent,aCabDoc,aDocs,xLin,xCol)
local oMenu := nil
local oButton1 := nil, oMenu01 := nil, oMenu0101 := nil, oMenu0102 := nil, oMenu0103 := nil
local oButton2 := nil, oMenu02 := nil, oMenu0201 := nil, oMenu0202 := nil, oMenu0203 := nil
local oButton3 := nil, oMenu03 := nil, oMenu0301 := nil, oMenu0302 := nil, oMenu0303 := nil
local oSubMenu := nil
   
// cria os menus 
oMenu01 := tMenu():new(0, 0, 0, 0, .T., , oMenu) 
oMenu02 := tMenu():new(0, 0, 0, 0, .T., , oMenu) 
oMenu03 := tMenu():new(0, 0, 0, 0, .T., , oMenu)
   
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION   
oMenu0201 := tMenuItem():new(oMenu02, "Maior Valor"			, , , , {|| U_fOrdena(oLbx,aDocs,"1") }	, , , , , , , , , .T.)
oMenu0202 := tMenuItem():new(oMenu02, "Data Emissใo"		, , , , {|| U_fOrdena(oLbx,aDocs,"2") }	, , , , , , , , , .T.)
oMenu0203 := tMenuItem():new(oMenu02, "$ / Lin"				, , , , {|| U_fOrdena(oLbx,aDocs,"3") }	, , , , , , , , , .T.)
oMenu0204 := tMenuItem():new(oMenu02, "Menor Nro. Linha"	, , , , {|| U_fOrdena(oLbx,aDocs,"4") }	, , , , , , , , , .T.)

oMenu02:add(oMenu0201) 
oMenu02:add(oMenu0202) 
oMenu02:add(oMenu0203) 
oMenu02:add(oMenu0204)   

oButton2 := tButton():create(oParent)
oButton2:cCaption := "Ordena" 
oButton2:nWidth   := 100 
oButton2:nTop     := xLin
oButton2:nLeft    := xCol
oButton2:bAction  := {|| } 
oButton2:setPopupMenu(oMenu02) 


oButton3 := tButton():create(oParent)
oButton3:cCaption := "Remover / Retornar" 
oButton3:nWidth   := 150 
oButton3:nTop     := xLin
oButton3:nLeft    := xCol + 120
oButton3:bAction  := {|| fFiltra(oLbx,aCabDoc,aDocs)} 
//oButton3:setPopupMenu(oMenu03)

  
Return

//==================================================================================//
//Fun็ใo  : fOrdena  
//Autoria : Flแvia Rocha
//Data    : 05/07/2021
//Objetivo: Fun็๕es de ordena็ใo para o botใo "Ordena" na tela de aloca็ใo automแtica
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fOrdena(oLbx,aDocs,xOrd)
//Static Function fOrdena(oLbx,aDocs,xOrd)

If Len(aDocs) > 0
	If xOrd == "1"		//maior valor
		ASort(aDocs,,, { |x, y| x[11] > y[11] })	
	ElseIf xOrd == "2"		//dt emissใo+hora
		ASort(aDocs,,, { |x, y| x[6] < y[6] })
	Elseif xOrd == "3"	//$ / Lin
		ASort(aDocs,,, { |x, y| x[12] > y[12] })
	Elseif xOrd == "4"	//Menor nro. Lin
		ASort(aDocs,,, { |x, y| x[8] < y[8] })
	Endif
Else
	MsgAlert("Nใo Hแ Dados a Ordenar")
Endif

oLbx:Refresh()


Return


//==================================================================================//
//Fun็ใo  : fFiltra  
//Autoria : Flแvia Rocha
//Data    : 05/07/2021
//Objetivo: Fun็ใo de filtro na tela de aloca็ใo automแtica
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fFiltra(oLbx,aCabDoc,aDocs)
//Static Function fFiltra(oLbx,aCabDoc,aDocs)
Local aAux 	:= {}
Local fr   	:= 0
Local aVetF3:= {}
Local cAux  := ""
Local oOk      		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo      		:= LoadBitmap( GetResources(), "LBNO" )
Local oLbxF3
Local bLineF3
Local aParamBox		:= {}
Local lChk
Local oChk
Local lValido 		:= .F. 
Local aAux			:= {}

Local aTpENT		:= {}	//tipo entrega
Local aTpFAT 		:= {}	//tipo fatura
Local aRet			:= {}
Local xx

Private aInfo  		:= {}
Private aObjects 	:= {}
Private aSize       := {}

//C5_XTIPO - Tipo Entrega
aTpENT	 := {"1=Retira","2=Entrega", "3=Todos"}  
//C5_XTIPF - Tipo Fatura
aTpFAT	 := {"1=Total",	"2=Parcial", "3=Normal","4=Todos"}  
nValorde := 0
nValorate:= 0

//TELA perguntas para filtrar as informa็๕es
/*01*/AAdd( aParamBox, { 1, "Ord.Sep de"	,	SPACE(TamSX3('CB7_ORDSEP')[01])				,	""					,	""		,	"CB7",	"",	50,	.F.}) 
/*02*/AAdd( aParamBox, { 1, "Ord.Sep ate"	,	Replicate('Z' , TamSX3('CB7_ORDSEP')[01])	,	""					,	""		,	"CB7",	"",	50,	.T.}) 
/*03*/AAdd( aParamBox, { 1, "Pedido de"		,	SPACE(TamSX3('C5_NUM')[01])					,	""					,	""		,	"SC5",	"",	50,	.F.}) 
/*04*/AAdd( aParamBox, { 1, "Pedido ate"	,	Replicate('Z' , TamSX3('C5_NUM')[01])		,	""					,	""		,	"SC5",	"",	50,	.T.}) 
/*05*/AAdd( aParamBox, { 1, "Emissใo de"	,	CTOD('01/01/2000')							,	""					,	""		,	"",	"",	50,	.T.})
/*06*/AAdd( aParamBox, { 1, "Emissใo ate"	,	CTOD('31/12/2099')							,	""					,	""		,	"",	"",	50,	.T.})
/*07*/AAdd( aParamBox, { 2, "Tipo Entrega"  ,	3 /*aTpENT[3]*/								,	aTpENT				,	100		,	"AllwaysTrue()",	.T.})
/*08*/aAdd( aParamBox, { 1, "Valor de"		,	nValorde									,  "@E 9,999,999.99"	, "Positivo()", "", ".T.", 80,  .F.})
/*09*/aAdd( aParamBox, { 1, "Valor at้"		, 	nValorate									,  "@E 9,999,999.99"	, "Positivo()", "", ".T.", 80,  .F.})


//*08*/AAdd( aParamBox, { 2, "Tipo Fatura"   ,	4 /*aTpFAT[3]*/									,	aTpFAT				,	100		,	"AllwaysTrue()",	.T.})
lCentered := .T.	//FR - 14/01/2021 - centraliza a janela de parโmetros
lCanSave  := .T.
lUserSave := .T.

//----------------------------------------------------------------------------------------------------------//
//Parambox - sintaxe geral
//ParamBox( < aParametros >  , < cTitle > , < aRet > , < bOk >, < aButtons > ,< lCentered >, < nPosX >,< nPosY > ,;
//          < oDlgWizard >, < cLoad > ,< lCanSave >,< lUserSave >  ) 

    // 1 - < aParametros > - Vetor com as configura็๕es
    // 2 - < cTitle >      - Tํtulo da janela
    // 3 - < aRet >        - Vetor passador por referencia que cont้m o retorno dos parโmetros
    // 4 - < bOk >         - Code block para validar o botใo Ok
    // 5 - < aButtons >    - Vetor com mais bot๕es al้m dos bot๕es de Ok e Cancel
    // 6 - < lCentered >   - Centralizar a janela
    // 7 - < nPosX >       - Se nใo centralizar janela coordenada X para inํcio
    // 8 - < nPosY >       - Se nใo centralizar janela coordenada Y para inํcio
    // 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
    //10 - < cLoad >       - Nome do perfil se caso for carregar
    //11 - < lCanSave >    - Salvar os dados informados nos parโmetros por perfil
    //12 - < lUserSave >   - Configura็ใo por usuแrio
//----------------------------------------------------------------------------------------------------------//     
If Len(aDocs) <= 0
	MsgAlert("Nใo Hแ Dados Para Filtrar")
	Return
Endif

If ParamBox(aParamBox, "Parโmetros", @aRet,,,lCentered,,,,,lCanSave,lUserSave)
			
		//aRet //tem os dados preenchidos
		//[x] , OS , PEDIDO , EMISSรO , TIPO ENTREGA, TIPO FATURA, VALOR DE, VALOR ATษ
		//1     2      3         4           5           6           7         8
		//msginfo("confirmou parametro")
		nCont := 0
		lVai  := .F.
		For fr := 1 to Len(aDocs)
			
			lVai := .F.
			//os de
			lVai := aDocs[fr,2] >= aRet[1]
			
			//os ate
			If lVai
				lVai := aDocs[fr,2] <= aRet[2]				
			Endif
			
			//pedido de
			If lVai
				lVai := aDocs[fr,3] >= aRet[3]				
				//pedido at้
				lVai := aDocs[fr,3] <= aRet[4]				
			Endif

			//emissใo de
			If lVai
				lVai := CtoD(aDocs[fr,6]) >= aRet[5]					
				//emissใo at้
				lVai := CtoD(aDocs[fr,6]) <= aRet[6]				
			Endif

			//tipo entrega
			//aTpENT	 := {"1=Retira","2=Entrega", "3-Todos"}  1,2,3 aqui ้ num้rico
			//aTpFAT	 := {"1=Total",	"2=Parcial", "3-Todos"}  1,2,3 aqui ้ num้rico
			//aDocs[fr,7] aqui ้ caracter ex: "Entrega"
			
			//---------------//
			//tipo entrega
			//---------------//
			If lVai
				
				If Valtype(aRet[7]) == "C"
					If "3" $ aRet[7]
						lVai := .T.
					Else
						lVai := .F.
					Endif
					//tratativa qdo o conte๚do ้ tipo caracter
					If !lVai
						xAchou := 0
						For xx := 1 to Len(aTpENT)
							If aDocs[fr,7] $ aTpENT[xx]
								xAchou := xx
							Endif
						Next
						lVai := Alltrim(Str(xAchou)) == Alltrim(aRet[7])					
					Endif 

				Elseif Valtype(aRet[7]) == "N"
					If aRet[7] == 3
						lVai := .T.
					Else
						lVai := .F.
					Endif
					//tratativa qdo o conte๚do ้ tipo num้rico
					If !lVai
						xAchou := 0
						For xx := 1 to Len(aTpENT)
							If Upper(aDocs[fr,7]) $ Upper(aTpENT[xx])
								xAchou := xx
							Endif
						Next
						lVai := xAchou == aRet[7]					
					Endif 
				Endif
			Endif
			
			//---------------//
			//tipo fatura
			//---------------//
			/*
			If lVai
				
				If Valtype(aRet[8]) == "C"
					If "4" $ aRet[8]		//4=Todos
						lVai := .T.
					Else
						lVai := .F.
					Endif

					//tratativa qdo o conte๚do ้ tipo caracter
					If !lVai
						xAchou := 0
						For xx := 1 to Len(aTpFAT)
							If Upper(aDocs[fr,15]) $ Upper(aTpFAT[xx])
								xAchou := xx
							Endif
						Next
						lVai := Alltrim(Str(xAchou)) == Alltrim(aRet[8])									
					Endif 


				Elseif Valtype(aRet[8]) == "N"
					If aRet[8] == 3
						lVai := .T.
					Else
						lVai := .F.
					Endif 

					//tratativa qdo o conte๚do ้ tipo num้rico
					If !lVai
						xAchou := 0
						For xx := 1 to Len(aTpFAT)
							If aDocs[fr,15] $ aTpFAT[xx]
								xAchou := xx
							Endif
						Next
						lVai := xAchou == aRet[8]
					Endif
				Endif
			Endif
			*/

	//valor de
	If lVai
		lVai := aDocs[fr,11] >= aRet[8]
		//valor at้
		If aRet[9] > 0
			lVai := aDocs[fr,11] <= aRet[9]
		Endif
	Endif

	//depois de passar por todas as condi็๕es acima:
	If lVai
		nCont++
		Aadd(aVetF3,Array(8))	//adiciona uma linha nova
		aVetF3[nCont,1] := .T.
		aVetF3[nCont,2] := aDocs[fr,2]
		aVetF3[nCont,3] := aDocs[fr,3]
		aVetF3[nCont,4] := aDocs[fr,6]
		aVetF3[nCont,5] := aDocs[fr,7]
		aVetF3[nCont,6] := aDocs[fr,15]
		aVetF3[nCont,7] := aDocs[fr,11]
		aVetF3[nCont,8] := aRet[9]
	Endif

Next
//fim parambox

Define FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

cAux := "{IF(aVetF3[oLbxF3:nAt,1],oOk,oNo) "
cAux += ",aVetF3[oLbxF3:NAT,2]"
cAux += ",aVetF3[oLbxF3:nAt,3]"
cAux += ",aVetF3[oLbxF3:nAt,4]"
cAux += ",aVetF3[oLbxF3:nAt,5]"
cAux += ",aVetF3[oLbxF3:nAt,6]"
cAux += ",aVetF3[oLbxF3:nAt,7]"
cAux += ",aVetF3[oLbxF3:nAt,8]"
	/*
	cAux += ",aVetF3[oLbxF3:nAt,9]"
	cAux += ",aVetF3[oLbxF3:nAt,10]"
	cAux += ",aVetF3[oLbxF3:nAt,11]"
	cAux += ",aVetF3[oLbxF3:nAt,12]"
	cAux += ",aVetF3[oLbxF3:nAt,13]"
	cAux += ",aVetF3[oLbxF3:nAt,14]"
	*/
cAux += "}

bLineF3 := &("{ || "+ cAux +" }")



//========================================//
//GERA A DIALOG
//========================================//

aPos1 := {}
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
aPos1 := U_xFRTela(oLbx,"TOT")

nLiIni := aPos1[1]	//45
nCoIni := aPos1[2]	//11
nLiFim := aPos1[3]	//358.5
nCoFim := aPos1[4] 	//747

nWidth := nCoFim-495 	//403
nHeight:= nLiFim-255	//108.5

Define MsDialog oDlgF3 TITLE "Filtro(s)" From nLiIni,nCoIni To nLiFim+100,nCoFim OF oLbx PIXEL
nLiIni += 5
@ nLiIni, nCoIni+5 SAY "Expressใo do Filtro: " SIZE 180,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE

nLiIni += 15
@ nLiIni, nCoIni+5 SAY "OS De/At้.......:" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
@ nLiIni, nCoIni+60 SAY aRet[1] + " / " + aRet[2] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE

nLiIni += 10
@ nLiIni, nCoIni+5 SAY "Pedido De/At้   :" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
@ nLiIni, nCoIni+60 SAY aRet[3] + " / " + aRet[4] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE

nLiIni += 10
@ nLiIni, nCoIni+5 SAY "Emissใo De/At้  :" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
@ nLiIni, nCoIni+60 SAY Dtoc(aRet[5]) + " / " + Dtoc(aRet[6]) SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE

nLiIni += 10
@ nLiIni, nCoIni+5 SAY "Tipo Entrega    :" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
If Valtype(aRet[7]) == "C"
	@ nLiIni, nCoIni+60 SAY aTpENT[ Val(aRet[7]) ] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE
Else
	@ nLiIni, nCoIni+60 SAY aTpENT[ aRet[7] ] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE
Endif
		/*
		nLiIni += 10
		@ nLiIni, nCoIni+5 SAY "Tipo Fatura     :" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
		If Valtype(aRet[8]) == "C"
			@ nLiIni, nCoIni+60 SAY aTpFAT[ Val(aRet[8]) ] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE 																										
		Else
			@ nLiIni, nCoIni+60 SAY aTpFAT[ aRet[8] ] SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE 																										
		Endif
		*/
nLiIni += 10
@ nLiIni, nCoIni+5 SAY "Valor De/At้    :" SIZE 80,20 PIXEL OF oDlgF3 FONT oBold COLOR CLR_HBLUE
@ nLiIni, nCoIni+60 SAY Transform(aRet[8],"@E 999,999,999.99") + " / " + Transform(aRet[9],"@E 999,999,999.99") SIZE 80,20 PIXEL OF oDlgF3 FONT oBold //COLOR CLR_HBLUE

nLiIni += 20
oLbxF3:= TWBrowse():New( nLiIni, nCoIni+5, nWidth, nHeight ,,{"", "OS" , "PEDIDO" , "EMISSรO" , "TIPO ENTREGA", "TIPO FATURA", "VALOR DE", "VALOR ATษ" },,oDlgF3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
oLbxF3:bLDblClick := { || U_fMarkCpo(aVetF3,oLbxF3) }
oLbxF3:SetArray(aVetF3)
oLbxF3:bLine := bLineF3

nLiIni := nHeight + 10
nCoIni := nCoIni + 5


nLiIni  := nLiIni + 90
nCoFim1 := nWidth -150
nCoFim2 := nWidth -130

@ nLiIni,nCoIni+5 CHECKBOX oChk VAR lChk PROMPT "Inverte sele็ใo" 	SIZE 70,7 	PIXEL OF oDlgF3 ON CLICK( aEval( aVetF3, {|x| x[1] := !x[1] } ), oLbxF3:Refresh() )
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
@nLiIni, nCoFim1 BUTTON oConf PROMPT "Confirmar" ACTION ( lValido := U_fRetorna(aVetF3,aDocs,@aAux), iif(lValido, oDlgF3:End(), .F.) ) SIZE 037,12 OF oDlgF3 PIXEL
nCoFim2 += 50

@ nLiIni, nCoFim2  BUTTON oCanc PROMPT "Sair" ACTION (oDlgF3:End()) SIZE 037,12 OF oDlgF3 PIXEL


ACTIVATE MSDIALOG oDlgF3 CENTER

If lValido
	oLbx:SetArray( aDocs )
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oLbx:bLine := {|| U_Retbline(oLbx,aDocs) }
	oLbx:Refresh()
Endif
Endif

Return

//==================================================================================//
//Fun็ใo  : fRetorna  
//Autoria : Flแvia Rocha
//Data    : 12/07/2021
//Objetivo: Efetua o filtro das OS, retornando para tela anterior as que forem marcadas
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fRetorna(aVetF3,aDocs,aAux)
//Static Function fRetorna(aVetF3,aDocs,aAux)
	Local fr := 0
	Local lMarcado := .F.
	Local lValid   := .F.
//Local aAux     := {}
	Local nCont    := 0
	Local xr       := 0

	If MsgYesNo("Deseja Realmente Retornar a(s) OS(s) Marcada(s) ?")

		For fr := 1 to Len(aVetF3)
			If aVetF3[fr,1]
				lMarcado := .T.
				lValid   := .T.
			Endif
		Next

		If !lMarcado
			MsgAlert("Por Favor, Marque ao menos um Item")
			//Return .F.
		Endif

		xr  := 0

		For fr := 1 to Len(aDocs)
			xPos := Ascan(aVetF3,{|x| x[2] == aDocs[fr,2] })
			If xPos > 0
				If !aVetF3[xPos,1]	//se nใo estแ marcado, adiciona no array apoio, pois sใo as OS que irใo ficar para a automatiza็ใo
					nCont++
					Aadd( aAux, Array(Len(aDocs[fr])) )	//adiciona uma linha nova
					For xr := 1 to Len(aDocs[fr])
						aAux[nCont,xr] := aDocs[fr,xr]
						lValid := .T.
					Next
				Endif
			Endif
		Next

		If lValid
			aDocs := aAux
		Endif
	Else
		MsgInfo("Opera็ใo Cancelada Pelo Operador")
	Endif

Return(lValid)



//FR - Incluํda por Flแvia Rocha - Fun็ใo gen้rica para cแlculo de Tela:
//+-----------------------------------------------------------------------------------//
//|Funcao....: U_FRTela(oBjet,cTipo)
//|Parametros: oBjet = Objeto a ser dimencionado
//|            cTipo = Tipo de posicionamento
//|            			"UP"   = Posiciona na parte de cima da Dialog
//|            			"DOWN" = Posiciona na parte de baixo da Dialog
//|            			"TOT"  = Posiciona em toda Dialog
//|
//|Autoria...: Flแvia Rocha
//|Data......: 26/08/2015
//|Descricao.: Fun็ใo para posicionar todo o objeto na Dialog
//|Observa็ใo: 
//+-----------------------------------------------------------------------------------//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function xFRTela(oBjet,cTipo,xVerMDI)
//Static Function fFRTela(oBjet,cTipo,xVerMDI)

	Local aPosicao := {}

	Do Case
	Case cTipo = "TOT"
		aPosicao    := {1,1,(oBjet:nClientHeight-6)/2,(oBjet:nClientWidth-4)/2}
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)
		EndIf

	Case cTipo = "UP"
		aPosicao:= {1,1,(oBjet:nClientHeight-6)/4-1,(oBjet:nClientWidth-4)/2}
		//Versใo MDI
		If Empty(xVerMDI)
			If SetMdiChild()
				aPosicao[3] += 4
				aPosicao[4] += 3
			EndIf
		EndIf

	Case cTipo = "DOWN"
		aPosicao:= {(oBjet:nClientHeight-6)/4+1,1,(oBjet:nClientHeight-6)/4-2,(oBjet:nClientWidth-4)/2}
		//Versใo MDI
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)
		EndIf

	End Case

Return(aPosicao)


//==================================================================================//
//Fun็ใo  : fMarkCpo  
//Autoria : Flแvia Rocha
//Data    : 05/07/2021
//Objetivo: Marca / Desmarca o(s) campo(s) para filtro de tela
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fMarkCpo(aVetF3,oLbxF3)
//Static Function fMarkCpo(aVetF3,oLbxF3)
	Local nCol := 0
	Local nRow := 0


	nCol      := oLbxF3:ColPos()
	nRow    := oLbxF3:NAT

	If nCol == 1
		aVetF3[oLbxF3:nAt][1] := !aVetF3[oLbxF3:nAt][1]
	Endif

Return


//==================================================================================//
//Fun็ใo  : exemplob  
//Autoria : Flแvia Rocha
//Data    : 20/07/2021
//Objetivo: Monta bot๕es de ordena็ใo e retornar da tela de OS's jแ alocadas
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User function exemplob(oLbx,oParent,aItens,xLin,xCol)
//Static function exemplob(oLbx,oParent,aItens,xLin,xCol)
	local oMenu := nil
	local oButton1 := nil, oMenu01 := nil, oMenu0101 := nil, oMenu0102 := nil, oMenu0103 := nil
	local oButton2 := nil, oMenu02 := nil, oMenu0201 := nil, oMenu0202 := nil, oMenu0203 := nil
	local oButton3 := nil, oMenu03 := nil, oMenu0301 := nil, oMenu0302 := nil, oMenu0303 := nil
	local oSubMenu := nil

// cria os menus 
	oMenu01 := tMenu():new(0, 0, 0, 0, .T., , oMenu)
	oMenu02 := tMenu():new(0, 0, 0, 0, .T., , oMenu)
	oMenu03 := tMenu():new(0, 0, 0, 0, .T., , oMenu)

// cria os itens dos menus
/* 
"Prioridade",	//1 
"OS",			//2
"Local",		//3
"Operador",		//4
"Operador Exp",	//5
"Pedido",		//6
"Tipo",			//7
"Tipo pedido",	//8
"Dt Emis",		//9
"Hr emis",		//10
"OP",			//11
"Status" ,		//12
'Linhas',		//13
'Pe็as',		//14
'Vlr Res Liq'	//15
,"$ /Lin" ;		//16
*/
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	oMenu0201 := tMenuItem():new(oMenu02, "Maior Valor"			, , , , {|| U_fOrdenb(oLbx,aItens,"1") }	, , , , , , , , , .T.)
	oMenu0202 := tMenuItem():new(oMenu02, "Data Emissใo"		, , , , {|| U_fOrdenb(oLbx,aItens,"2") }	, , , , , , , , , .T.)
	oMenu0203 := tMenuItem():new(oMenu02, "$ / Lin"				, , , , {|| U_fOrdenb(oLbx,aItens,"3") }	, , , , , , , , , .T.)
	oMenu0204 := tMenuItem():new(oMenu02, "Menor Nro. Linha"	, , , , {|| U_fOrdenb(oLbx,aItens,"4") }	, , , , , , , , , .T.)

	oMenu02:add(oMenu0201)
	oMenu02:add(oMenu0202)
	oMenu02:add(oMenu0203)
	oMenu02:add(oMenu0204)

// cria os bot๕es que receberใo os menus 
	oButton2 := tButton():create(oParent)
	oButton2:cCaption := "Ordena"
	oButton2:nWidth   := 100
	oButton2:nTop     := xLin
	oButton2:nLeft    := xCol
	oButton2:bAction  := {|| }
	oButton2:setPopupMenu(oMenu02)


Return


//==================================================================================//
//Fun็ใo  : fOrdenb  
//Autoria : Flแvia Rocha
//Data    : 20/07/2021
//Objetivo: Fun็๕es de ordena็ใo para o botใo "Ordena" na tela de aloca็ใo automแtica
//          de OS jแ alocada
//==================================================================================//
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fOrdenb(oLbx,aItens,xOrd)
//Static Function fOrdenb(oLbx,aItens,xOrd)
	Local aPrior := {}
	Local p      := 0
	Local i      := 0

	For p := 1 to Len(aItens)
		Aadd(aPrior, aItens[p,1])  //adiciona o c๓digo de prioridade + os
	Next

	ASort(aPrior)

	If Len(aItens) > 0
		If xOrd == "1"		//maior valor
			ASort(aItens,,, { |x, y| x[15] > y[15] })
		ElseIf xOrd == "2"		//dt emissใo + hora
			//ASort(aItens,,, { |x, y| x[9]+ x[10] < y[9]+ y[10] })
			ASort(aItens,,, { |x, y| Dtoc(x[9])+ x[10] < Dtoc(y[9])+ y[10] })
		Elseif xOrd == "3"	//$ / Lin
			ASort(aItens,,, { |x, y| x[16] > y[16] })
		Elseif xOrd == "4"	//Menor nro. Lin
			ASort(aItens,,, { |x, y| x[13] < y[13] })
		Endif

		i := 1
		For p := 1 to Len(aItens)
			aItens[p,1] := aPrior[i]  //regrava a prioridade no array ordenado
			i++
		Next

		For p := 1 to Len(aItens)
			//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
			U_fAjustPriD(aItens[p,1],aItens[p,2],aItens,1)
		Next

	Else
		MsgAlert("Nใo Hแ Dados a Ordenar")
	Endif

	oLbx:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustPrioD บAutor  ณRenato	 		 บ Data ณ  21/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณModifica prioridade - Adaptado por Flแvia Rocha - 23/07/2021 ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fAjustPriD(_cPrior1,_cOrdSep1,_aItens3,nTipo)
//Static Function AjustPrioD(_cPrior1,_cOrdSep1,_aItens3,nTipo)
//              AjustPrioD(_aItens3[oLbx:nAt,1],_aItens3[oLbx:nAt,2],@_aItens3,1)
//                         (_cPrior1           ,_cOrdSep1           ,_aItens3 ,nTipo)

	Local aArea		:= GetArea()
	DbSelectArea("CB7")
	DbSetOrder(1)
	DbSeek(xFilial("CB7")+_cOrdSep1)

	If !CB7->(Eof())

		CB7->(RecLock("CB7",.F.))
		CB7_XPRIOR := _cPrior1
		CB7->(MsUnLock())

	EndIf

	oLbx:Refresh()

	RestArea(aArea)

Return

//============================================
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  LibQtdCB7	บAutor  ณFMT CONSULTORIA     บ Data ณ  03/06/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManuten็ใo da Reserva		                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAPCP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function LibQtdCB7(cOP,aItens)
//Static Function LibQtdCB7(cOP,aItens)

	Local oGet1
	Local oGet2
	Local oSay1
	Local oSay2
	Local oSButton1
	Local oSButton2

	Private nGet1 := 0
	Private nGet2 := 0

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Selecionar Quantidades" FROM 000, 000  TO 290, 610 COLORS 0, 16777215 PIXEL

	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	U_fMSNewGe1(cOP,aItens)
	@ 016, 009 SAY oSay1 PROMPT "Produto Final Reservado" SIZE 063, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 016, 164 SAY oSay2 PROMPT "Ordem Produ็ใo" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
	//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
	@ 014, 073 MSGET oGet1 VAR nGet1 SIZE 050, 010 OF oDlg PICTURE "@E 9999,999.99" COLORS 0, 16777215 PIXEL VALID U_AtuaCols(nGet1,cOP)
	@ 014, 212 SAY oGet2 VAR nGet2 SIZE 050, 010 OF oDlg PICTURE "@E 9999,999.99" COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 118, 226 TYPE 02 OF oDlg ENABLE ACTION (aItens:={},oDlg:End())
	DEFINE SBUTTON oSButton2 FROM 118, 265 TYPE 01 OF oDlg ENABLE ACTION (aItens:=U_GravaItens(aItens,nGet1,cOP),oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

Return(aItens)

//------------------------------------------------ 
// FMT Consultoria
//------------------------------------------------ 
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function fMSNewGe1(cOP,aItens)
//Static Function fMSNewGe1(cOP,aItens)

	Local nX
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFieldFill := {}
	Local aFields := {"B1_COD","B2_QATU","C2_QUANT","C2_QUANT","C2_QUANT"}
	Local aCab    := {"Produto PI","Reservado","Total Estoque","Qtde.Estr.P/ 1 UN","Sepera็ใo"}
	Local aAlterFields := {"B2_QATU"}
	Local cVal := ""
	Local nQtdOrd := 0
	Local nQtdOri := 0

	Private nEstru  := 0
	Private aEstru := {}
	Private cProd  := ""

	Static oMSNewGe1

	// Define field properties
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeaderEx, {AllTrim(aCab[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,12,2,;
				IIF(Alltrim(aFields[nX])=="B2_QATU","",SX3->X3_VALID),;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	// Define field values
	For nX:=1 to Len(aFields)
		If DbSeek(aFields[nX])
			Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX

	//Aadd(aFieldFill, .F.)
	//Aadd(aColsEx, aFieldFill)

	aColsEx := {}

	//Carrega aCols
	IF SC2->(DBSEEK(XFILIAL("SC2")+cOP))
		nGet2 := SC2->C2_QUANT - SC2->C2_QUJE

		nX := 1
		For nX:=1 to Len(aItens)
			SB2->(dbSeek(xFilial("SB2") + aItens[nX,5] + aItens[nX,4] ))
			nSaldo := SaldoSb2()

			cVal := StrTran(aItens[nX,8],'.','')
			cVal :=StrTran(cVal,',','.')

			//If Val(cVal) > 0 .AND. nSaldo>0

			nQtdOrd := 0
			cQuery := "SELECT SUM(D4_QTDEORI-D4_QUANT) AS QUANTD4, SUM(D4_QTDEORI) AS QTDORI FROM "+RetSqlName("SD4")+" WHERE D_E_L_E_T_='' "
			cQuery += "AND D4_FILIAL='"+XFILIAL("SD4")+"' AND D4_COD='"+aItens[nX,5]+"' "
			//cQuery += "AND D4_XORDSEP <> '' "
			cQuery += "AND D4_OP='"+cOP+"' "

			cQuery := ChangeQuery(cQuery)  //INCLUอDA ESSA LINHA GIOVANI FEZ MERDA!!
			TCQUERY cQuery NEW ALIAS "SD4A"
			nQtdOrd := SD4A->QUANTD4
			nQtdOri := SD4A->QTDORI

			SD4A->(DBCLOSEAREA())

			aadd(aColsEx, { aItens[nX,5], Val(cVal) , nSaldo, 0, nQtdOrd , iif(nSaldo<0,.t.,.f.) } )
			//Endif
		Next Nx

		cProd := SC2->C2_PRODUTO
		aEstru := estrut(SC2->C2_PRODUTO,1)

		nX := 1
		For nX:=1 to Len(aEstru)
			if aEstru[nX,1] == 1 // Somente Nivel 1
				nPos := Ascan(aColsEx ,{|x|Upper(Alltrim(x[1])) == AllTrim(aEstru[nX,3]) })
				if nPos > 0
					aColsEx[nPos, 4] := aEstru[nX, 4]
				Endif
			Endif
		Next nX
	Endif

	oMSNewGe1 := MsNewGetDados():New( 031, 007, 108, 305, GD_INSERT+GD_DELETE+GD_UPDATE, "U_VldQuant", "U_VldAllOK", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "", oDlg, aHeaderEx, aColsEx)

Return

//------------------------------------------------ 
// FMT Consultoria
//------------------------------------------------ 
User Function VldQuant()

	If oMSNewGe1:aCols[n,2] > oMSNewGe1:aCols[n,3]
		MsgAlert("Quantidade nใo pode ser maior que saldo em estoque !")
		Return(.f.)
	EndIF

	If oMSNewGe1:aCols[n,2] > ( nGet2 * oMSNewGe1:aCols[n,4] )
		MsgAlert("Quantidade nใo pode ser maior saldo da OP X Quant.na Estrutura !")
		Return(.f.)
	EndIF

	If (oMSNewGe1:aCols[n,2] + oMSNewGe1:aCols[n,5] ) > ( nGet2 * oMSNewGe1:aCols[n,4] )
		MsgAlert("Quantidade nใo pode ser maior saldo mais a Ordem de separa็ใo !")
		Return(.f.)
	EndIF

Return(.T.)

//------------------------------------------------ 
// FMT Consultoria
//------------------------------------------------ 
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AtuaCols(nGet1,cOp)
//Static Function AtuaCols(nGet1,cOp)

	Local aColNew := aClone(oMSNewGe1:aCols)
	Local nX := 0

	If nGet1 > nGet2
		MsgAlert("Quantidade nใo pode ser maior que saldo da OP !")
		Return(.f.)
	Endif

	SC2->(DBSEEK(XFILIAL("SC2") + cOp ))
	nFator := nGet1 / SC2->C2_QUANT

	For nX:=1 to Len(aColNew)
		if aColNew[nX,6] == .f.
			//aColNew[nX,2] := nGet1 * aColNew[nX,4]
			aColNew[nX,2] := nFator * aColNew[nX,7]
		Endif
	Next nX

	oMSNewGe1:aCols := aClone(aColNew)
	oMSNewGe1:oBrowse:Refresh()

Return(.T.)

//------------------------------------------------ 
// FMT Consultoria
//------------------------------------------------ 
User Function VldAllOK()

	Local nX := 0

	For nX:=1 to Len(oMSNewGe1:aCols)
		If oMSNewGe1:aCols[nX,2] > oMSNewGe1:aCols[nX,3]
			MsgAlert("Quantidade nใo pode ser maior que saldo em estoque !")
			Return(.f.)
		EndIF
	Next nX

Return(.T.)

//------------------------------------------------ 
// FMT Consultoria
//------------------------------------------------ 
User Function GravaItens(aItens,nQuantOP,cOP)

	Local nX := 1
	Local nPos := 0
	Local cPicture	:= PesqPict("SD4","D4_QTDEORI")

	For nX:=1 to Len(oMSNewGe1:aCols)

		nPos := Ascan(aItens ,{|x|Upper(Alltrim(x[5])) == AllTrim(oMSNewGe1:aCols[nX,1]) })
		if nPos > 0
			aItens[nPos, 7] := oMSNewGe1:aCols[nX,2]
			aItens[nPos, 8] := Transform(oMSNewGe1:aCols[nX,2] , cPicture)
		Endif
	Next nX

Return(aItens)


/*/{Protheus.doc} AjCabec
Rotina com montagem do cabe็alho
Chamado: 20220407007598
@type function
@version  12.1.27
@author valde
@since 27/04/2022
@return variant, nil
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function AjCabec()
//Static Function AjCabec()
//FR - 26/10/2022 - REINICIAR O ARRAY APOSALOC PARA NรO ACUMULAR TอTULOS SOBRE TอTULOS, POIS CAUSAVA ERRO NA HORA DE EXPORTAR PARA EXCEL
	aPosAloc := {}
//FR - 26/10/2022 - Flแvia Rocha - Sigamat Consultoria	

	aadd(aPosAloc, {'Sel', ' '             , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Numero Ordem'  , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Pedido Venda'  , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Nome'          , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Recno'         , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Data emissใo'  , 'D', 1})
	aadd(aPosAloc, {'Sel', 'Tp.PV'         , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Qtd.Lin'       , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Nr.Lin SCH'    , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Nr.Lin STK'    , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Almoxarifado'  , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Qtd.Pe็a'      , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Vlr. $'  	   , 'N' ,1})
	aadd(aPosAloc, {'Sel', 'Vlr Schneider' , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Vlr Steck'     , 'N', 1})
	aadd(aPosAloc, {'Sel', '$ /Lin'        , 'N', 1})
	aadd(aPosAloc, {'Sel', 'Ordem Produ็ใo', 'C', 1})
	aadd(aPosAloc, {'Sel', 'Tp.Cliente'    , 'C', 1})
	aadd(aPosAloc, {'Sel', 'Tp.Pedido'     , 'C', 1})
Return


/*/{Protheus.doc} PosAloc
Rotina para retornar o posicionamento do campo
@type function
@version  12.1.27
@author Valdemir Rabelo
@since 27/04/2022
@param pCampo, variant, String
@param pTipo, variant, SCH / STK
@return variant, Integer/String
/*/
//FR - 25/08/2022 - Alterado para User Function, Motivo: NรO ษ MAIS PERMITIDO S T A T I C FUNCTION
User Function PosAloc(pCampo,pTipo)
//Static Function PosAloc(pCampo,pTipo)
	Local _RET
	Local nPos := Ascan(aPosAloc, {|X| Upper(Alltrim(X[2]))==Upper(alltrim(pCampo))})
	Default pTipo := ""

	if pTipo == "TIPO"
		_RET := aPosAloc[nPos][3]
	else
		_RET := nPos
	Endif

Return _RET




//----------------------------------------------------------------------------//
//Fun็ใo : U_AVISOS
//Autoria: Flแvia Rocha - 08/09/2022 - Sigamat Consultoria
//Esta fun็ใo envia o aviso aos responsแveis sobre as OS's que foram geradas
//pela fun็ใo "1 OS para N Pedidos"
//----------------------------------------------------------------------------//
USER FUNCTION STAVISOS(cOS)

	Local cMailTo := ""
	Local cCopia  := ""
	Local cAssun  := ""
	Local cCorpo  := ""
	Local cAnexo  := ""
	Local cPedido := ""
	Local cCliente:= ""
	Local cLojaCli:= ""
	Local fr      := 0
	Local aItOrd  := {}

	cMailto := GetNewPar("ST_AVISOS", "kleber.braga@steck.com.br;vanessa.costa@steck.com.br;rosa.santos@steck.com.br")  //quem recebe o email aviso de pedidos cancelados
	cMailTo += ";flah.rocha@sigamat.com.br;flah.rocha@gmail.com"  //retirar
	cCopia  := ""

	If !Empty(cMailTo)

		cCopia  := ""
		cAssun  := "AVISO de OS Gerada por Aglutina็ใo de Pedidos de Venda"

		cCorpo  := "Olแ ," + CHR(13) + CHR(10) + CHR(13) + CHR(10)

		cCorpo  += "Informamos que o(s) seguinte(s) pedido(s) Foram Aglutinados na Seguinte Ordem de Separa็ใo: " + cOS + CHR(13) + CHR(10)

		CB7->(OrdSetFocus(1))
		If CB7->(Dbseek(xFilial("CB7") + cOS ))
			cPedido := CB7->CB7_PEDIDO

			SC5->(OrdSetFocus(1))
			SC5->(Dbseek(xFilial("SC5") + cPedido))
			cCliente := SC5->C5_CLIENTE
			cLojaCli := SC5->C5_LOJACLI

		Endif

		cCorpo  += "Cliente: " + Posicione('SA1',1,xFilial('SA1')+ cCliente + cLojaCli, 'A1_NOME') + CHR(13) + CHR(10)

		cAnexo  := ""

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg := cCorpo + CHR(13) + CHR(10)
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + cAssun + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=90%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cAssun +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '<TR BgColor=#FFFFFF>'

		//cabe็alho da msg:
		cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">FILIAL</Font></B></TD>'
		cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">PEDIDO</Font></B></TD>'
		cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">ITEM</Font></B></TD>'
		cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">PRODUTO</Font></B></TD>'
		cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">QTDE</Font></B></TD>'

		CB8->(OrdSetFocus(1))
		CB8->(Dbseek(xFilial("CB8")+ cOS))
		fr := 1
		While CB8->(!Eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. Alltrim(CB8->CB8_ORDSEP) == Alltrim(cOS)
			//For fr := 1 to Len(aAviso)
			//If (fr/2) == Int( fr/2 )
			//	cMsg += '<TR BgColor=#B0E2FF>'
			//Else
			//	cMsg += '<TR BgColor=#FFFFFF>'
			//EndIf

			//cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + CB8->CB8_FILIAL + ' </Font></TD>'
			//cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + CB8->CB8_PEDIDO + ' </Font></TD>'
			//cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + CB8->CB8_ITEM 	+ ' </Font></TD>'
			//cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + CB8->CB8_PROD   + ' </Font></TD>'
			//cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + cValTochar(CB8->CB8_QTDORI)	+ ' </Font></TD>'

			//Next

			Aadd( aItOrd , {CB8->CB8_FILIAL, CB8->CB8_PEDIDO , CB8->CB8_ITEM, CB8->CB8_PROD, cValToChar(CB8->CB8_QTDORI) } )

			CB8->(Dbskip())
			//fr++
		Enddo

		If Len(aItOrd) > 0

			ASort(aItOrd,,,{|x,y| (x[2]+x[3]) < (y[2]+y[3])})

			For fr := 1 to Len(aItOrd)

				If (fr/2) == Int( fr/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf

				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aItOrd[fr,1] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aItOrd[fr,2] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aItOrd[fr,3] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aItOrd[fr,4] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aItOrd[fr,5] + ' </Font></TD>'

			Next

		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(U_STAVISOS)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		//FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )		//para testes retirar
		U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)		//envia email ao t้rmino do processo

	Endif

Return

/*==========================================================================
|Funcao    | FRSendMail          | Flแvia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observa็๕es: Gen้rico      											   |
==========================================================================*/
//FUNวรO FR PARA TESTES
Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail nใo enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


//U_fValMIN(nVlrLiq)
/*==========================================================================
|Funcao    | FVALMIN          | Flแvia Rocha            | Data | 08/09/2022|
============================================================================
|Descricao | VALIDA TOTAL DO PEDIDO SE ESTม DENTRO DO VALOR MอNIMO  	   | 
|            PARA AGLUTINAR            	  						           |
============================================================================
|Observa็๕es: 1 OS PARA N PEDIDOS										   |
==========================================================================*/
USER FUNCTION FVALMIN(nVlrLiq)
Local lValidou := .T.
Local nTOTMIN   := GetNewPar("ST_VLMINOS", 600)  //FR - valor mํnimo de pedido de venda para poder aglutinar em 1 OS

If nVlrLiq < nTOTMIN //valor total dos pedidos selecionados ้ menor que valor mํnimo entใo nใo deixar prosseguir
	lValidou := .F.
	If !IsBlind()
		MsgAlert("O somat๓rio total do Valor do(s) Pedido(s) Selecionado(s) ้ Menor que o Valor Mํnimo para Aglutinar ->" + cValToChar(nTOTMIN))
	Endif
Endif 

Return(lValidou)


/*/{Protheus.doc} FuraFIFO
Fura FIFO
@type function
@version 12 1 33 
@author Ricardo Munhoz
@since 15/04/2023
/*/
User Function FuraFIFO()
	
	Local aArea 	:= " "
	Local nRecnoSC5 := SC5->(Recno())

	aArea := {GetArea()}
    AADD(aArea,SC5->(GetArea()))

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTo(nRecnoSC5))

	If !(AllTrim(SC5->C5_XPRIOR2) == "S")
		If RecLock("SC5", .F.)
			SC5->C5_XPRIOR2 := "S"
			SC5->(MsUnlock("SC5"))
			FWAlertInfo("Fura FIFO para o Pedido: " + SC5->C5_NUM + ", atribuํdo com sucesso...")
		Else
			FWAlertInfo("Falha ao tentar reservar o registro...") 
		End If
	Else 
		FWAlertInfo("O Pedido: " + SC5->C5_NUM + ", jแ foi adicionado a fila...")
	EndIf

	AEval(aArea, {|aArea| RestArea(aArea)})
	FwFreeArray(aArea)
	
Return

/*/{Protheus.doc} FuraFIFO
Estrutura expressใo 
@type function
@version 12 1 33 
@author Antonio Moura
@since 01/08/2023
/*/

Static Function MontaExp(cExp,nStep1)

Local cRet:=""
Local nx:=0

cRet+='('

FOR nx:=1 to len(cExp) step nStep1
    cRet+="'"+substr(cExp,nx,nStep1-1)+"',"
NEXT     

cRet:=substr(cRet,1,len(cRet)-1)+')'


Return(cRet)

//Habilita/Desabilida gera็ใo da ordem de separa็ใo automatica 
User Function AUTORD()

Local lAutOrd  := GetMV("ST_AUTORD",.F.,.T.)
Local aArea    :=GETAREA()

IF lAutOrd 
   IF MSGYESNO( 'Desabilida a gera็ใo automแtica da ordem de separa็ใo ?')
      PutMv("ST_AUTORD",.F.)    
   ENDIF
ELSE 
   IF MSGYESNO( 'Habilita gera็ใo automแtica da ordem de separa็ใo ?')
      PutMv("ST_AUTORD",.T.)
   ENDIF
ENDIF

RestArea(aArea)     

Return()
