#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA16  ºAutor  ³Microsiga           º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monitor Radio Frequencia                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSFA16()
Local oDlg
Local oLbx
Local aLbx 		:={}
Local oTimer
Local aButtons :={}

aAdd(aButtons,{"FRTONLINE"  	,{|| Monitora(oLbx,aLbx)}				,"Monitor"			})
aAdd(aButtons,{"CRITICA"  		,{|| Mensagem(oLbx,aLbx)}	  			,"Mensagem"	 		})
aAdd(aButtons,{"AFASTAMENTO"	,{|| Desconect(oLbx,aLbx,oTimer)}	,"Desconecta"		})

DEFINE MSDIALOG oDlg TITLE "Monitor RF" FROM 0,0 TO 470,600 PIXEL OF oMainWnd

	@ 01,01 LISTBOX oLbx FIELDS HEADER "Coletor","Usuario","Data","Hora","Tamanho","Programa Inicial","Rotina"," " SIZES {15,20,20,20,10,10,10,10} SIZE 490,095 OF oDlg PIXEL	
	oLbx:align := CONTROL_ALIGN_ALLCLIENT                    
	oLbx:bLDblClick := {|| Monitora(oLbx,aLbx)}

   CarregaItens(oLbx,aLbx)
	DEFINE TIMER oTimer INTERVAL 1000 ACTION AtuTela(oLbx,aLbx,oTimer) OF oDlg
	
ACTIVATE MSDIALOG oDlg ON INIT (	EnchoiceBar(oDlg, {|| oDlg:End()  },{|| oDlg:End()},,aButtons ), AtuTela(oLbx,aLbx,oTimer),oTimer:Activate())


Return nil  

                                                  

Static Function AtuTela(oLbx,aLbx,oTimer)
oTimer:Deactivate()  
CarregaItens(oLbx,aLbx)
oTimer:Activate()
Return

              

Static Function CarregaItens(oLbx,aLbx)
Local nX,nPos
Local nH
Local cLinha := Space(70)
Local cNumCol := ''
Local cUsuario:= ''
Local cData   := ''
Local cHora   := ''
Local cProgIni:= ''
Local cRotina := ''
Local nHTemp
Local aColetor := Directory("VT*.SEM")


aLbx := {}
For nX := 1 to Len(aColetor)
	nHTemp := FOpen(aColetor[nX,1],16)
	FClose(nHTemp)
	If nHTemp > 0
		FErase(aColetor[nX,1])
	EndIf
Next

aColetor := Directory("VT*.SEM")
For nX := 1 to Len(aColetor)
	cLinha  := Memoread(aColetor[nX,1])
	cNumCol := Left(cLinha,3)
	cUsuario:= Subs(cLinha,4,25)
	cData   := stod(Subs(cLinha,29,8))
	cHora   := Subs(cLinha,37,8)
	cSize   := Str(Val(Subs(cLinha,45,03))+1,3)+" X "+Str(Val(Subs(cLinha,48,03))+1,3)
	cProgIni:= Subs(cLinha,51,8)
	cRotina := Subs(cLinha,59,30)
	nPos    := AsCan(aLbx,{|x|x[1]==cNumCol})
	If Empty(nPos)
		aadd(aLbx,{cNumcol,cUsuario,cData,cHora,cSize,cProgIni,cRotina,""})
	Else
		aadd(aLbx,{cNumcol,cUsuario,cData,cHora,cSize,cProgIni,cRotina,""})
	EndIf
Next
If Empty(aLbx)
	aadd(aLbx, {'','','','','','','',''})
EndIF  

oLbx:SetArray( aLbx )       
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]} }
oLbx:Refresh()	
Return                                                      
//================

Static Function Mensagem(oLbx,aLbx)
Local nX
Local nCountMsg:= 0
Local oMemo
Local cMemo
Local oFont
Local oDlgMsg

DEFINE FONT oFont NAME "Mono AS" SIZE 8,20

If Len(aLbx)==1 .AND. Empty(aLbx[oLbx:nAt,1])
	Return
EndIf

DEFINE MSDIALOG oDlgMsg FROM 0,0 TO 100,300  Pixel TITLE OemToAnsi("Mensagem para o coletor "+aLbx[oLbx:nAt,1])
	@ 0,0 GET oMemo  VAR cMemo MEMO SIZE 150,30 OF oDlgMsg PIXEL
	TButton():New( 035,001, "Enviar", oDlgMsg, {|| MemoWrite('VT'+aLbx[oLbx:nAt,1]+'.MSG',cMemo),oDlgMsg:End()}, 38, 11,,, .F., .t., .F.,, .F.,,, .F. )
	TButton():New( 035,111, "Sair", oDlgMsg, {|| oDlgMsg:End()}, 38, 11,,, .F., .t., .F.,, .F.,,, .F. )
	oMemo:oFont:=oFont
ACTIVATE MSDIALOG oDlgMsg CENTERED

Return

                                                  

//==========================================================
Static Function Monitora(oLbx,aLbx)
Local oTimer
Local cFile   := 'VT'+aLbx[oLbx:nAt,1]+'.MON'
Local nMaxRow := Val(SubStr(aLbx[oLbx:nAt,5],1,3))
Local nMaxCol := Val(SubStr(aLbx[oLbx:nAt,5],7,3))
Local nBottom := 294
Local nRight  := 400
Local nI,nJ
Local nCount  := 0
Local nLin    := 3
Local nCol    := 3
Local bBlock
Private lSai := .t.

oFont  := TFont():New( "Mono AS", 16, 24, .F.,.T.,,,,,,,,,,, )
DEFINE FONT oFont2 NAME "Mono AS" SIZE 16,24 UNDERLINE BOLD

If Len(aLbx)==1 .AND. Empty(aLbx[oLbx:nAt,1])
	Return
EndIf
//Restaura a possicao
If nMaxRow== 8 .and. nMaxCol==20
	nBottom := 294
	nRight  := 400
ElseIf nMaxRow== 2 .and. nMaxCol==20
	nBottom := 105
	nRight  := 400
ElseIf nMaxRow== 2 .and. nMaxCol==40
	nBottom := 105
	nRight  := 790
EndIf

VTScrToFile(cFile,{{},{}})
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Monitorando Coletor "+aLbx[oLbx:nAt,1]) FROM 00,00 TO nBottom,nRight PIXEL
TButton():New(if(nMaxrow==8,134,38),005, "Sair", oDlg, {|| lSai := .t.}, 38, 11,,, .F., .t., .F.,, .F.,,, .F. )
aSayVt := Array(nMaxRow,nMaxCol,2)
For nI := 1 to nMaxRow 
	nCol := 3
	For nJ := 1 to nMaxCol 
		aSayVt[nI,nJ,2] := " "
		bBlock := &("{||aSayVt["+Str(nI,4)+","+Str(nJ,4)+",2]   }")
		aSayVt[nI,nJ,1] := TSay():New( nLin, nCol, bBlock,,,oFont, .F., .F., .F., .T.,,, 15, 17, .F., .F., .F., .F., .F. )
		nCol+=10
	Next
	nLin+=16
Next
ACTIVATE MSDIALOG oDlg CENTERED ON INIT Gerencia(cFile,aLbx[oLbx:nAt,1],oDlg)

While FErase(cFile) == -1 .and. file(cFile)
	Sleep(10)
End
Return


Static Function Gerencia(cFile,cNumTer,oDlg)
Local nI := 0
nI := 0
If lSai
	lSai := .F.
	While !lSai
		ProcessMessage()
		AtuMon(cFile,cNumTer,oDlg)
		sleep(1000)
	EndDo
	oDlg:End()
Else
	lSai := .T.
EndIf
Return .T.


Static Function AtuMon(cFile,cNumTer,oDlg)
Local nI,nJ
Local aOldSay := {,,}
Local aLoad
Local __aScreen
Local __aReverso
Local nHTemp
IF ! file('VT'+cNumTer+'.SEM')
   lSai := .t.
   Return
EndIf
nHTemp := FOpen('VT'+cNumTer+'.SEM',16)
FClose(nHTemp)
If nHTemp > 0
   FErase('VT'+cNumTer+'.SEM')
   lSai := .t.
   Return
EndIf

aLoad := VTFileToScr(cFile)
IF Len(aLoad) < 2
   Return
ENDIF
__aScreen  := aLoad[1]
__aReverso := aLoad[2]
For nI:= 1 to Len(__aScreen)
  If nI > Len(aSayVt) .or. lSai
     Exit
  EndIf   
  For nJ := 1 to Len(__aScreen[nI])
     If nJ > Len(aSayVt[nI]) .or. lSai
        Exit
     EndIf                               
     aOldSay[1] := aSayVt[nI,nJ,2]
     aOldSay[2] := aSayVt[nI,nJ,1]:NCLRTEXT
     aSayVt[nI,nJ,2] := SubStr(__aScreen[nI],nJ,1)
     If SubStr(__aReverso[nI],nJ,1) == "0"
        aSayVt[nI,nJ,1]:NCLRTEXT := CLR_BLACK                      
        aSayVt[nI,nJ,1]:OFONT    := oFont
     Else
        aSayVt[nI,nJ,1]:NCLRTEXT := CLR_HRED //WHITE
        aSayVt[nI,nJ,1]:OFONT    := oFont2
     EndIf   
     If aSayVt[nI,nJ,2] # aOldSay[1] .or. aOldSay[2] # aSayVt[nI,nJ,1]:NCLRTEXT  // somente faz o refresh quando necessario
        aSayVt[nI,nJ,1]:Refresh()
     EndIf   
  Next                             
Next
sleep(10)
PROCESSMESSAGE()
Return .t.


Static Function Desconect(oLbx,aLbx,oTimer)
Local cFile

If Empty(aLbx[oLbx:nAt,1]) .AND. Len(aLbx)==1 
	Return
EndIf

If !  MsgYesNo('Confirma a desconexao do coletor selecionado?')
	Return
EndIf   

cFile := 'VT'+aLbx[oLbx:nAt,1]+'.FIM'
MemoWrite(cFile,'fim')
AtuTela(oLbx,aLbx,oTimer)
Return

