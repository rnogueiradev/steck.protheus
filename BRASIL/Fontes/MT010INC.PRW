#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MT010INC ³Rev.   ³ Ricardo Posman        ³ Data ³28.07.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de Entrada para repliacar o cadastro de produtos na    ³±±
±±³          ³ filial MANAUS                                               ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010INC()

	Local _aArea	:= GetArea()
	//Local _aItens	:= {}
	//Local _aTemp		:= {}
	Local lCOPIASB1	:= IsInCallStack("U_STCOPIAB1")
	Local lCOM025	:= IsInCallStack("U_STCOM025")

	Private cEmpDest1 := "03"
	Private cFilDest1 := "01"
	Private cEmpDest2 := "04"
	Private cFilDest2 := "01"
	Private aCab     := {}

	U_STPCE002()    //CRIAR CODIG DE BARRA STECK

	If Inclui .or. Altera
		U_STGERSB5()	//Criar registro na tabela SB5 - Chamado 001141
	EndIf
	If lCOPIASB1 .Or. lCOM025
		Return
	EndIf

	If FUNNAME() $ "RPC"
		Return
	EndIf

	SB1->(RecLock("SB1",.F.))
	SB1->B1_XDTINCL	:= CTOD(FWLeUserlg("B1_USERLGI",2))
	SB1->(MsUnlock())

	If !IsBlind()
		If cEmpAnt == "01" .And. INCLUI
			If msgyesno("Deseja copiar o produto para a empresa Manaus?")
				U_STCOPIAB1() //Copiar produto para AM
			EndIf
		Elseif cEmpAnt == "03" .And. INCLUI
			If msgyesno("Deseja copiar o produto para a empresa São Paulo?")
				U_STCOPIB1SP() //Copiar produto para SP
			EndIf
		EndIf
	EndIf

	aCab := {	{"B1_COD"		,	SB1->B1_COD	   	,NIL},;
	{"B1_DESC"  	, 	SB1->B1_DESC	,NIL},;
	{"B1_TIPO" 		, 	SB1->B1_TIPO	,NIL},;
	{"B1_UM"	 	, 	SB1->B1_UM		,NIL},;
	{"B1_LOCPAD" 	, 	SB1->B1_LOCPAD	,NIL},;
	{"B1_GRUPO" 	, 	SB1->B1_GRUPO	,NIL},;
	{"B1_PESO" 		, 	SB1->B1_PESO	,NIL} }

	//StartJob("U_UPDSB1",GetEnvServer(),.F.,"1",cEmpDest1,cFilDest1,aCab,3)

	PutMV("ST_PROXDES", SB1->B1_XDESENH)

	RestArea(_aArea)

Return

User Function UPDSB1(cAcao,cEmpOfi,cFilFis,aCabAux,nOpcx)

	RpcSetEnv(cEmpOfi,cFilFis)
	FWMonitorMsg("Rotina automatica MATA010 "+cEmpAnt+"/"+cFIlAnt) //PtInternal(1,"Rotina automatica MATA010 "+cEmpAnt+"/"+cFIlAnt)
	msgalert("Rotina automatica MATA010 "+cEmpAnt+"/"+cFIlAnt)
	SaveInter()

	lMsErroAuto := .F.
	MATA010(aCabAux,nOpcx)
	RestInter()
	RpcClearEnv()

Return
