#include "rwmake.ch" 
#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCQC001  ºAutor  ³Microsiga           º Data ³  02/25/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCQC001

Local aArea    := GetArea()
Local oDlg
Local oFolder
Local aoBrw		:={}
Local	nTop 		:= 00
Local	nLeft 	:= 00
Local nBottom
Local	nRight
Local aButtons	:= {}
Local oTimer
Local cArmExp := '01'//GetMv("FS_ARMEXP")
Local cTitOrd := ''
Local aSize    	 := MsAdvSize(.F.) 

//Local aBrowse	:= {"CB7_ORDSEP","CB7_XAUTSE","CB7_LOCAL","CB7_CODOPE","CB7_PEDIDO","CB7_OP","CB7_XSEP","CB7_XPRIOR","CB7_XOSPAI","CB7_XOSFIL"}
//Local aCab2		:= {"1"			,"2"		 ,"Armazem"	 ,"Produto"	  ,"Endereço","Lote","Quantidade","Saldo Separação (1)","Saldo Embalagem (2)",""}
Local aBrowse	:= {"CB7_ORDSEP", "CB7_LOCAL","CB7_CODOPE","CB7_PEDIDO","CB7_OP" }
Local aCab2		:= {"1"			, "Armazem"	 ,"Produto"	  ,"Endereço","Lote","Quantidade","Saldo Separação (1)","Saldo Embalagem (2)",""}

Local aItens2  := {}
Local oLbx
//Local aAutSep 	:= //RetSx3Box(Posicione('SX3', 2, "CB7_XAUTSE", 'X3CBox()' ),,, 1 )// RetSx3Box(Posicione("SX3",2,"CB7_XAUTSE","X3_CBOX"),,,14)
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

Local oSplit

Local nX
Local aBtnLat
Local nAux
Local bBlocoC             

Private cNF 	:= space(9)
Private cPv 	:= space(6)
Private cOP 	:= space(13)
Private cOrdSep := space(6)

oMainWnd:ReadClientCoors()
nBottom := oMainWnd:nBottom
nRight := oMainWnd:nRight

DEFINE MSDIALOG oDlg TITLE "Monitor CQ" FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd

aBtnLat :={			{"BMPVISUAL"    	,{|| ViewCB7()}					,"Visualiza Ordem de Separação"	} }

@ 00,00 MSPANEL oPanel1 PROMPT "" SIZE 20,20 of oDlg
oPanel1:Align := CONTROL_ALIGN_LEFT

nAux:= 0

For nX := 1 To Len(aBtnLat)
	TBtnBmp2():New(nAux,0,40,40 ,aBtnLat[nX,1], NIL, NIL,NIL,aBtnLat[nX,2], oPanel1, aBtnLat[nX,3], NIL, NIL,NIL )
	nAux +=42
Next

@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
oPanel4:Align := CONTROL_ALIGN_TOP

@ 06,20 Say "O. Separação" PIXEL of oPanel4
@ 04,55 MsGet oOrdSep Var cOrdSep Picture "!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "CB7FS1" Valid.t.  //PesqOSep(@cOrdSep,oBrowse)

@ 06,140 Say "O.Producao" PIXEL of oPanel4
@ 04,170 MsGet oCodOpe Var cOP Picture "!!!!!!!!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "SC2" Valid .t.  //PesqOper(@cCodOpe,oBrowse,cArmExp)

@ 06,255 Say "P.Venda" PIXEL of oPanel4
@ 04,285 MsGet oPv Var cPV Picture "!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "SC5" Valid .t.  //PesqOper(@cCodOpe,oBrowse,cArmExp)

@ 06,370 Say "NF Saida" PIXEL of oPanel4
@ 04,400 MsGet oNf Var cNF Picture "!!!!!!!!!" PIXEL of oPanel4 SIZE 50,09 F3 "SF2" Valid .t.  //PesqOper(@cCodOpe,oBrowse,cArmExp)

@00,00 MSPANEL oPanel2 PROMPT "" SIZE 20,20 of oDlg
oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
DbSelectArea("CB7")
	
cCpoFil 	:= "CB7->(CB7_FILIAL+CB7_LOCAL)"
cTopFun 	:= ""
cBotFun 	:= 'ZZZZZZZZZ' //cArmExp
	
//CB7->(DbOrderNickName("STFSCB702"))
//CB7->(DbSeek(xFilial('CB7')+cArmExp))

oBrowse := VCBrowse():New( 0, 0, 266,175,,,,oPanel2 ,cCpoFil,cTopFun,cBotFun,/*bLDblClick*/,,,,,,,, .F.,"CB7", .T.,, .F., ,)
oBrowse := oBrowse:GetBrowse()
oBrowse:bChange := {|| oBrowse :Refresh(),MontaCB8(oLbx,aItens2,cArmExp )  }
oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

oCol := TCColumn():New( " ",{|| AnalisaLeg(1) },,,, "LEFT", 8, .T., .F.,,,, .T., )
oBrowse:AddColumn(oCol)
oCol := TCColumn():New( " ",{|| AnalisaLeg(2) },,,, "LEFT", 8, .T., .F.,,,, .T., )
oBrowse:AddColumn(oCol)

For i:=1 To Len(aBrowse)
	
	oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || CB7->"+aBrowse[i]+"}"),,,, "LEFT",, .F., .F.,,,, .F., )
	oBrowse:AddColumn(oCol)
	If aBrowse[i]=="CB7_CODOPE"
		oCol := TCColumn():New( Alltrim(RetTitle(aBrowse[i])), &("{ || Posicione('CB1',1,xFilial('CB1')+CB7->CB7_CODOPE,'CB1_NOME')}"),,,, "LEFT",, .F., .F.,,,, .F., )
		oBrowse:AddColumn(oCol)
	EndIf
	
Next i

oBrowse :Refresh()

@ 00,00 MSPANEL oPanel3 PROMPT "" SIZE 140,140 of oPanel2
oPanel3:Align := CONTROL_ALIGN_BOTTOM


@00,00 MSPANEL oPanel5 PROMPT "" SIZE 20,20 of oPanel3
oPanel5:Align := CONTROL_ALIGN_BOTTOM

oLbx := TWBrowse():New(10,10,230,95,,aCab2,,oPanel3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
MontaCB8(oLbx,aItens2,cArmExp)
oLbx:Align := CONTROL_ALIGN_ALLCLIENT
oLbx:blDBlClick := {|| U_STFSVE50(aItens2[oLbx:nAt,4])}

DEFINE TIMER oTimer INTERVAL 1000 ACTION AtuTela(oFolder,aoBrw,oTimer) OF oDlg
oDlg:lEscClose:= .f.
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg, {|| oDlg:End()  },{|| oDlg:End()},,aButtons ),AtuTela(oFolder,aoBrw,oTimer),oTimer:Activate())

CB7->(DbClearFilter())
RestArea(aArea)
Return

Static Function AtuTela(oFolder,aoBrw,oTimer)
/*/
Local cCargo 	:= RetPosTab(oFolder)
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

//aoBrw[oFolder:nOption]:Refresh()
//Eval(aoBrw[oFolder:nOption]:bChange)
/*/

oTimer:Activate()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCQC001  ºAutor  ³Microsiga           º Data ³  02/25/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ViewCB7()
Local aArea		:= GetArea()
Local aAreaCB7	:= CB7->(GetArea())

PRIVATE aRotina := {	{"Pesquisar"					,"AxPesqui",   0,1},;
						{"Visualizar"					,"ACDA100Vs",0,2}}

SX3->(DbSetOrder(1))
ACDA100Vs("CB7",CB7->(Recno()),2)
RestArea(aAreaCB7)
RestArea(aArea)
Return




Static Function MontaCB8(oLbx,aItens2,cArmExp)
Local oAzul		:= LoadBitmap( GetResources(), "BR_AZUL" 	)
Local oVerde 	:= LoadBitmap( GetResources(), "BR_VERDE" 	)
Local oNao		:= LoadBitmap( GetResources(), "BR_CANCEL"	)
Local oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
Local cPicture	:= PesqPict("CB8","CB8_QTDORI")
Local nSaldoE	:= 0
Local lEmb		:= .f.
Local oSep		:=NIL
Local oEmb		:=NIL

nTotItem := 0
nTotEnd 	:= 0
aItens2:={}
CB8->(DbSetOrder(1))
CB8->(DbSeek(xFilial('CB8')+CB7->CB7_ORDSEP))
While CB8->(! Eof() .and. CB8_FILIAL+CB8_ORDSEP== xFilial('CB8')+CB7->CB7_ORDSEP)
	
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
		If ! Empty(CB8->CB8_LCALIZ) .and. Ascan(aItens2,{|x| x[5] == CB8->CB8_LCALIZ}) == 0
			nTotEnd++
		EndIf
	EndIf
	CB8->(aadd(aItens2,{oSep,oEmb,CB8_LOCAL,CB8_PROD,CB8_LCALIZ,CB8_LOTECT,Transform(CB8_QTDORI,cPicture),Transform(CB8_SALDOS,cPicture),Transform(nSaldoE,cPicture)," ",Recno()}))
	CB8->(DbSkip())
End

If Empty(aItens2)
	aadd(aItens2,{oNao,oNao,"","","","","","",""," ",0})
EndIf
If oLbx<>NIL
	oLbx:SetArray( aItens2 )
	oLbx:bLine := {|| aEval(aItens2[oLbx:nAt],{|z,w| aItens2[oLbx:nAt,w] } ) }
	oLbx:Refresh()
EndIf
Return

Static Function AnalisaLeg(nColuna)
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