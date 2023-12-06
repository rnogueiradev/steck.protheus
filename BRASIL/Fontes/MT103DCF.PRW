#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MT103DCF      ³Autor  ³ Renato Nogueira  ³ Data ³02.03.2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada para adicionar campos customizados          ³±±
±±³          ³no documento de entrada                                      ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103DCF()

	Local aArea      := GetArea()
	Local oDlg       := NIL
	Local oDesc      := NIL
	Local oCodigo    := NIL
	Local cDesc      := SPACE(40)
	Local cNfCli 	 := SPACE(09)
	Local lInclui    := PARAMIXB[1]
	Local lAltera    := PARAMIXB[2]
	Local lVisual    := PARAMIXB[3]
	Local aCamposPar := PARAMIXB[4]
      
	DEFINE MSDIALOG oDlg TITLE "NF do cliente" FROM 0,0 TO 140,360 OF oMainWnd PIXEL
      
	@ 16,10 SAY RetTitle("F1_XNFCLI")  	SIZE 45,09            	OF oDlg PIXEL
	@ 14,50 MSGET oCodigo VAR cNfCli	  	SIZE 45,09 F3 "" 			OF oDlg PIXEL

	DEFINE SBUTTON FROM 50,143 TYPE 1 ACTION {||oDlg:End()}ENABLE OF oDlg
                                        
	ACTIVATE MSDIALOG oDlg CENTERED
      
	aCamposPar:={{"F1_XNFCLI",cNfCli}}

	RestArea(aArea)

Return(aCamposPar)