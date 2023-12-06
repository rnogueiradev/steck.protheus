#include "rwmake.ch"
#include "protheus.ch"
                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STQETXT  ºAutor  ³RVG Solcuoes        º Data ³  06/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STQETXT
Local aArea		:= GetArea()
Local aPC1Area	:= PC1->(GetArea())

Local cTexto := Space(80)
Local nOpca:=0

If Empty(QEK->QEK_XFATEC) 
    MsgStop("Inspeccao n~ao 'e de Fatec !!! ")
	Return
Endif

PC1->(DbSetOrder(1)) //PC1_FILIAL+PC1_NUMERO+PC1_NOTAE+PC1_SERIEE
If PC1->(DbSeek(xFilial("PC1")+SUBSTR(QEK->QEK_XFATEC,1,6)))
	
	cTexto := PC1->PC1_TXTOPF
	
Endif

DEFINE MSDIALOG oDlg1 TITLE "texto de retrabalho da FATEC" FROM 0,0 TO 300,400 PIXEL
@  05, 10 SAY "Texto" PIXEL
@  12, 10 GET oTexto VAR cTexto OF oDlg1 MEMO SIZE 114,100 PIXEL
@ 140, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION  (nOpca:=1,oDLg1:End())
@ 140,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (nOpca:=0,oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

if nOpca == 1
	PC1->(DbSetOrder(1)) //PC1_FILIAL+PC1_NUMERO+PC1_NOTAE+PC1_SERIEE
	If PC1->(DbSeek(xFilial("PC1")+substr(QEK->QEK_XFATEC,1,6) ))
		PC1->(RecLock("PC1",.F.))
		PC1->PC1_TXTOPF := cTexto
		PC1->(MsUnlock())
	Endif
Endif

RestArea(aPC1Area)
RestArea(aArea)

Return


