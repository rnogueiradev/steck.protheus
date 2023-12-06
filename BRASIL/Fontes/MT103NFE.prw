#include "rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103NFE ºAutor  ³ RVG                º Data ³  30/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para ha habilitar a pesquisa de OP        º±±
±±º          ³ do produto no retorno da OPs de benef externo              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103NFE
                   
SetKey(VK_F11,{|| U_MostrOPs() })

Return

              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MostrOPs ºAutor  ³Microsiga           º Data ³  10/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Escolha das OPs                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MostrOPs

Local cVariavel	:= ReadVar()
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local nRecSD2
Local nRecSD1

Do Case
Case cVariavel == "M->D1_OP" .And. cTipo $ 'NIPBC'
	LAShowOp()
EndCase

Return .T.
    


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LAShowOP ³ Autor ³RVG                   ³ Data ³ 30/10/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta emppenho em Aberto c atraves da tecla F11         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LAshowOP()      				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LAshowOp()
Local oDlg, nOAT
Local nHdl    := GetFocus()
Local nOpt1   := 0
Local aArray  := {}
Local cAlias  := Alias()
Local nOrder  := IndexOrd()
Local nRecno  := Recno()
Local cCampo  := ReadVar()
Local cPicture:= PesqPictQt("C2_QUANT",16)
Local nOrdSC2 := SC2->(IndexOrd())
Local cMascara:= GetMv("MV_MASCGRD")
Local nTamRef := Val(Substr(cMascara,1,2))
Local nPosOp  := AScan(aHeader,{|x| AllTrim(x[2])=='D1_OP'})
Local nPosCod := aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local cProdRef:= IIf(MatGrdPrrf(aCols[n][nPosCod]),Alltrim(aCols[n][nPosCod]),aCols[n][nPosCod])
Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto e' referencia (Grade)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MatGrdPrrf(aCols[n][nPosCod])
	nTamRef	 := Val(Substr(cMascara,1,2))
	cProdRef    := Alltrim(aCols[n][nPosCod])
Else
	nTamRef	 := Len(SC2->C2_PRODUTO)
	cProdRef    := aCols[n][nPosCod]
EndIf

If cCampo <> "M->D1_OP"
	SetKey(VK_F4,bSavKeyF4)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	SetKey(VK_F7,bSavKeyF7)
	SetKey(VK_F8,bSavKeyF8)
	SetKey(VK_F9,bSavKeyF9)
	SetKey(VK_F10,bSavKeyF10)
	SetKey(VK_F11,bSavKeyF11)	
	Return NIL
EndIf

dbSelectArea("SD4")
dbSetOrder(1)
If dbSeek(xFilial("SD4")+cProdRef )

	While !Eof() .And. D4_FILIAL+Substr(D4_COD,1, nTamRef) == xFilial("SD4")+Substr(cProdRef,1, nTamRef)
		If D4_QUANT > 0 
			AADD(aArray,{SUBSTR(D4_OP,1,6),SUBSTR(D4_OP,7,2),SUBSTR(D4_OP,9,3),D4_COD,DTOC(D4_DATA) ,Transform(D4_QUANT,cPicture) })
		EndIf
		dbSkip()
	EndDo
EndIf

If !Empty(aArray)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Empenhos em Aberto deste Produto") From 03,0 To 17,50 OF oMainWnd     //"OPs em Aberto deste Produto"
	@ 0.5,  0 TO 7, 20.0 OF oDlg
	@ 1,.7 LISTBOX oQual VAR cVar Fields; 
	      HEADER OemToAnsi("Numero"),;
	             OemToAnsi("Item"),;
	             OemToAnsi("Seq"),;
	             OemToAnsi("Produto"),;
	             OemToAnsi("Dt Empenho"),;
	             OemToAnsi("Saldo Empenho"),;
	             SIZE 150,80 ON DBLCLICK (nOpt1 := 1,oDlg:End())   //"N£mero"###"Item"###"Sequˆncia"###"Produto"###"Dt. Prev. Inicio"###"Dt. Prev. Fim"###"Saldo"###"It. Grade"
	oQual:SetArray(aArray)
	oQual:bLine := { || {aArray[oQual:nAT][1],aArray[oQual:nAT][2],aArray[oQual:nAT][3],aArray[oQual:nAT][4],aArray[oQual:nAT][5],aArray[oQual:nAT][6] }}
	DEFINE SBUTTON FROM 10  ,166  TYPE 1 ACTION (nOpt1 := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 22.5,166  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT, .T.)
	If nOpt1 == 1
		M->D1_OP :=aArray[nOAT][1]+aArray[nOAT][2]+aArray[nOAT][3]+SPACE(2)
		If nPosOp > 0
			aCols[n][nPosOp] := M->D1_OP
		EndIf
	EndIf
	SetFocus(nHdl)
Else
	HELP(" ",1,"A250NAOOP")
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrder)
MsGoto(nRecno)
SC2->(dbSetOrder(nOrdSC2))
CheckSx3("D1_OP")
SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
Return Nil

    