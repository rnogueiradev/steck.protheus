#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"

User Function MA415MNU()

	aadd( aRotina, {"Efectivar","u_My415Bx()",0,2,0,NIL} )
	aadd( aRotina, {"posicion",	"u_SFATR01()",0,2,0,NIL} )
	aadd( aRotina, {"Resumen","	u_My415Resum()",0,2,0,NIL} )
	aadd( aRotina, {"Importar CSV","U_FIMPCSVEXEC()",0,2,0,NIL} )	
	
Return

User Function My415Bx()
Local lRet 		:= .F.

	If ( SCJ->CJ_STATUS == "A" .And. Empty(SCJ->CJ_PROPOST) )

		If MsgYesNo("Confirma el procesamiento?")
			MsgRun("Efectuando presupuesto. Espera ..",,{|| My415BxA() } )
			lRet := .T.
		Endif
		
	ElseIf ( SCJ->CJ_STATUS == "B" )
		Help(" ",1,"A415BAIXA")
	ElseIf ( SCJ->CJ_STATUS == "C" )
		Help(" ",1,"A415BAIXAC")
	ElseIf ( SCJ->CJ_STATUS == "D" )
		Help(" ",1,"A415BAIXAD")
	ElseIf ( SCJ->CJ_STATUS == "F" )
		Help(" ",1,"A415BAIXAF")
	ElseIf ( SCJ->CJ_STATUS == "A" .And. !Empty(SCJ->CJ_PROPOST))
		//Help( " ", 1,"A415BXPROP") 
		MsgAlert("Atencion, No fue posible hacer la efectuacion. Hay una propuesta comercial en progreso...")
	EndIf
	
Return(lRet)


Static Function My415BxA()
	Local aCabec	:= {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local nX		:= 0

	Private lMsErroAuto := .F.
	
	// Possicionar SCK
	SCK->(dbSetOrder(2))
	
	If SCK->(dbSeek(xFilial("SCK") + SCJ->(CJ_CLIENTE + CJ_LOJA + CJ_NUM)))
	
		AADD(aCabec,{"CJ_NUM",		SCJ->CJ_NUM,	Nil})
		AADD(aCabec,{"CJ_CLIENTE",	SCJ->CJ_CLIENTE,Nil})
		AADD(aCabec,{"CJ_LOJACLI",	SCJ->CJ_LOJA,	Nil})
		AADD(aCabec,{"CJ_CLIENT" ,	SCJ->CJ_CLIENT,	Nil})
		AADD(aCabec,{"CJ_LOJAENT",	SCJ->CJ_LOJAENT,Nil})
		AADD(aCabec,{"CJ_CONDPAG",	SCJ->CJ_CONDPAG,Nil})

		While !Eof() .AND. SCK->(CK_FILIAL + CK_CLIENTE + CK_LOJA + CK_NUM) == SCJ->(CJ_FILIAL + CJ_CLIENTE + CJ_LOJA + CJ_NUM)
			aLinha := {}
			
			AADD(aLinha,{"CK_ITEM",		SCK->CK_ITEM,		Nil})
			AADD(aLinha,{"CK_PRODUTO",	SCK->CK_PRODUTO,	Nil})
			AADD(aLinha,{"CK_QTDVEN",	SCK->CK_QTDVEN,		Nil})
			AADD(aLinha,{"CK_PRCVEN",	SCK->CK_PRCVEN,		Nil})
			AADD(aLinha,{"CK_PRUNIT",	SCK->CK_PRUNIT,		Nil})            
			AADD(aLinha,{"CK_VALOR",	SCK->CK_VALOR,		Nil})
			AADD(aLinha,{"CK_TES",		SCK->CK_TES,		Nil})

			AADD(aItens, aLinha)

			SCK->(dbSkip())
		Enddo
		
		MATA416(aCabec,aItens)

		If !lMsErroAuto

			Reclock("SCJ",.F.)
			SCJ->CJ_XNUMSC5 := SC5->C5_NUM
			MsUnlock()

            If Len(Alltrim(SC5->C5_XNOME)) = 0 
				If SA1->(dbSeek(xFilial("SA1") + SCJ->(CJ_CLIENTE + CJ_LOJA )))
					Reclock("SC5", .F.)
					SC5->C5_XNOME	:= SA1->A1_NOME
					SC5->C5_XNORC	:= SCJ->CJ_NUM
					SC5->C5_XORPC	:= SCJ->CJ_XORPC
					SC5->C5_LIBEROK	:= "S"
					MsUnlock()
				EndIf 
			Endif
			
			// Gerar novo registro de interação ( ZZY )

			u_my415ZZY(SCJ->CJ_NUM)

			MsgAlert("Atencion, Efectivacion del pedido no: " + SC5->C5_NUM + " con exito! ")    
		Else
			MostraErro()
			MsgAlert("Atencion, No fue posible hacer la efectuación...")
		Endif
		
	Else
		MsgAlert("Atencion, Ocorreo un error...")
	Endif

Return()

User Function My415Resum()
Local oButton1
Local oFont1 := TFont():New("Arial Rounded MT Bold",,022,,.F.,,,,,.F.,.F.)
Local oSay1
Local oSay2

Private _cSayA
Private _cSayB
Private _cSayC
Private _cSayD
Private _cSayF

Static oDlg

CalcRecSCJ()

  DEFINE MSDIALOG oDlg TITLE "Resumen" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

    @ 040, 007 SAY oSay1 PROMPT "Abiertos o pendiente el dia:" 	SIZE 127, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 065, 007 SAY oSay2 PROMPT "Efectivados:" 					SIZE 114, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL

    @ 040, 154 MSGET _cSayA PICTURE "999999"  When .F.	SIZE 040, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 065, 154 MSGET _cSayB	PICTURE "999999"  When .F.	SIZE 040, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL 

    @ 116, 183 BUTTON oButton1 PROMPT "Cerrar" SIZE 054, 018 OF oDlg ACTION (oDlg:End()) FONT oFont1 PIXEL

    //MsgAlert("Espera. En desarrollo... ")

  ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function CalcRecSCJ()
	Local cQuery	:= ""

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	cQuery := " SELECT"
	cQuery += " CASE "
	cQuery += "     WHEN CJ_STATUS = 'A' THEN 'A - Abierto'"
	cQuery += "     WHEN CJ_STATUS = 'B' THEN 'B - Efectivado'"
	cQuery += "     WHEN CJ_STATUS = 'C' THEN 'C - Anulado'"
	cQuery += "     WHEN CJ_STATUS = 'D' THEN 'D - Sen Valor'"
	cQuery += "     WHEN CJ_STATUS = 'F' THEN 'F - Con Bloqueo'"
	cQuery += " END AS ESTATUS,"
	cQuery += " COUNT(1) REGS"
	cQuery += " FROM " + RetSqlName("SCJ") + " SCJ"
	cQuery += " WHERE SCJ.D_E_L_E_T_ = ' '"
	cQuery += " AND	CJ_FILIAL = '" + xFilial("SCJ") + "'"
	cQuery += " GROUP BY CJ_STATUS"
	cQuery += " ORDER BY 1"
	TCQUERY cQuery NEW ALIAS "TRB"
	
	dbSelectArea("TRB")
	dbGotop()

	While TRB->(!Eof())
		Do Case 
			Case Left(TRB->ESTATUS,1) = "A"
				_cSayA := TRB->REGS 
			Case Left(TRB->ESTATUS,1) = "B"
				_cSayB := TRB->REGS 
			Case Left(TRB->ESTATUS,1) = "C"
				_cSayC := TRB->REGS 
			Case Left(TRB->ESTATUS,1) = "D"
				_cSayD := TRB->REGS 
			Case Left(TRB->ESTATUS,1) = "F"
				_cSayF := TRB->REGS 
		EndCase 

		TRB->(DbSkip())
	EndDo 

	TRB->(dbCloseArea())
Return

User Function my415ZZY(_cSCJNum)
	Local cQuery	:= ""
	Local cItem		:= ""	
	Local lRet		:= .T.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	cQuery := " SELECT"
	cQuery += " MAX(ZZY_ITEM) ZZY_ITEM"
	cQuery += " FROM " + RetSqlName("ZZY")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND   ZZY_FILIAL = '" + xFilial("ZZY") + "'"
	cQuery += " AND   ZZY_NUM = '" + _cSCJNum + "'"
	TCQUERY cQuery NEW ALIAS "TRB"
	
	dbSelectArea("TRB")
	dbGotop()
	
	cItem := StrZero(Val(TRB->ZZY_ITEM) + 1,2)

	TRB->(dbCloseArea())

	Reclock("ZZY",.T.)
	ZZY->ZZY_FILIAL := xFilial("ZZY")
	ZZY->ZZY_NUM 	:= _cSCJNum
	ZZY->ZZY_ITEM	:= cItem
	ZZY->ZZY_VEND	:= SCJ->CJ_XCVEND
	ZZY->ZZY_NVEND 	:= Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_XCVEND,"A3_NOME")
	ZZY->ZZY_DTINCL	:= dDataBase
	ZZY->ZZY_HORA  	:= Left(Time(),5)
	ZZY->ZZY_CUSERI	:= __CUSERID
	ZZY->ZZY_MOTIVO	:= "6"
	ZZY->ZZY_OBS   	:= "Efectivado con exito en pedido automatico no.: " + SC5->C5_NUM
	MsUnlock()

Return(lRet)
