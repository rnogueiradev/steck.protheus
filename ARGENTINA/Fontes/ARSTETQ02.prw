#INCLUDE "PROTHEUS.CH"
#INCLUDE "SET.CH"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} ARSTETQ01

Impresión Etiquetas de Productos Pequeña

@type function
@author Everson Santana
@since 15/06/18
@version Protheus 12 - Stock/Costos

@history , ,

/*/
User Function ARSTETQ2()//u_ARSTETQ02()
	Local cPorta 	:= "LPT1"
	LOCAL oButton 	:={}   
	LOCAL cProduto 	:= Space(15)
	LOCAL nQuant  	:= space(16)
	Local _lConf	:= .F.
	Local aItems	:= {'Tipo 1','Tipo 2','Tipo 3'}
	Local cCombo1	:= aItems[1]
	
	Local n := 0

	LOCAL oDlg, oSay           
	LOCAL oFont:= TFont():New("Courier New",,-12,.T.,.T.)   
	LOCAL aFont:= TFont():New("Arial",,-12,.T.)  
	LOCAL bFont:= TFont():New("Arial",,-14,.T.,.T.) 

	DEFINE MSDIALOG oDlg FROM 0,0 TO 200,300 PIXEL TITLE "Impresión de etiquetas - ARSTETQ2"

	@ 010, 07 SAY OemToAnsi("Codigo:")	FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL     
	@ 010, 075 MSGET oGet VAR cProduto    SIZE 57,10 OF oDlg F3 "SB1" PIXEL
	@ 030, 07 SAY OemToAnsi("Cantidad:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL 
	@ 030, 075 MSGET oGet1 VAR nQuant		SIZE 57,10 OF oDlg PIXEL
	@ 050, 07 SAY OemToAnsi("Tipo/Impresión:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL 
	oCombo1 := TComboBox():New(50,075,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,57,10,oDlg,,{||},,,,.T.,,,,,,,,,'cCombo1')

	oButton:=tButton():New(070,90,"CONFIRMA",oDlg,{||_lConf:= .T.,oDlg:End()},40,20,,,,.T.)    

	ACTIVATE MSDIALOG oDlg CENTERED       

	If _lConf
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbGotop()

		If DbSeeK(xFilial("SB1")+Alltrim(cProduto))

			MSCBPRINTER("ELTRON",cPorta,,,.F.)

			If cCombo1 $ "Tipo 1"

				For n:= 1 To Val(nQuant)

					MSCBBEGIN(1,8) //124.5 Tamanho da etiqueta

					MSCBSAY(013,001, "Importado y distribuido por","N","1","1,1")     
					MSCBSAY(055,001, "Importado y distribuido por","N","1","1,1")

					MSCBSAY(013,003, UPPER(SM0->M0_NOMECOM),"N","2","1,1")     
					MSCBSAY(055,003, UPPER(SM0->M0_NOMECOM),"N","2","1,1")

					MSCBSAY(013,006, SM0->M0_ENDENT,"N","1","1,1")     
					MSCBSAY(055,006, SM0->M0_ENDENT,"N","1","1,1")

					MSCBSAY(013,008, Alltrim(SM0->M0_BAIRENT)+", Bs. As. Argentina","N","1","1,1")     
					MSCBSAY(055,008, Alltrim(SM0->M0_BAIRENT)+", Bs. As. Argentina","N","1","1,1")

					MSCBSAY(013,010, "Origen China","N","1","1,1")     
					MSCBSAY(055,010, "Origen China","N","1","1,1")

					MSCBSAY(013,012, "CODIGO: "+Alltrim(SB1->B1_COD),"N","3","1,1")     
					MSCBSAY(055,012, "CODIGO: "+Alltrim(SB1->B1_COD),"N","3","1,1")

					MSCBSAY(013,015, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","3","1,1")     
					MSCBSAY(055,015, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","3","1,1")

					MSCBEND()	

				Next n

			Elseif cCombo1 $ "Tipo 2"

				MSCBLOADGRF("STECK2.PCX") //Logo Lateral Pq

				For n:= 1 To Val(nQuant)

					MSCBBEGIN(1,8) //124.5 Tamanho da etiqueta

					MSCBGRAFIC(13,01,"STECK2")

					MSCBSAY(019,001, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","2","1,1")     
					MSCBSAY(019,004, SubStr(Alltrim(SB1->B1_DESC),21,40),"N","2","1,1")

					MSCBSAY(026,010, "CODIGO ","N","3","1,1")
					MSCBSAY(023,013, Alltrim(SB1->B1_COD),"N","3","1,1")

					MSCBGRAFIC(55,01,"STECK2")	
					MSCBSAY(061,001, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","2","1,1")
					MSCBSAY(061,004, SubStr(Alltrim(SB1->B1_DESC),21,40),"N","2","1,1")

					MSCBSAY(068,010, "CODIGO ","N","3","1,1")	     
					MSCBSAY(065,013, Alltrim(SB1->B1_COD),"N","3","1,1")


					MSCBEND()

				Next n	

			Elseif cCombo1 $ "Tipo 3"

				MSCBLOADGRF("ARIRAM4.PCX") //Logo Lateral Pq
				
				For n:= 1 To Val(nQuant)
				
					MSCBBEGIN(1,8) //124.5 Tamanho da etiqueta
					
					MSCBSAY(015,001, "Importado y distribuido por","N","1","1,1")     
					MSCBSAY(055,001, "Importado y distribuido por","N","1","1,1")
					
					MSCBGRAFIC(42,03,"ARIRAM4")
					MSCBGRAFIC(81,03,"ARIRAM4")
					
					MSCBSAY(015,003, UPPER(SM0->M0_NOMECOM),"N","1","1,1")     
					MSCBSAY(055,003, UPPER(SM0->M0_NOMECOM),"N","1","1,1")

					MSCBSAY(015,005, SM0->M0_ENDENT,"N","1","1,1")     
					MSCBSAY(055,005, SM0->M0_ENDENT,"N","1","1,1")

					MSCBSAY(015,007, Alltrim(SM0->M0_BAIRENT)+", Bs.","N","1","1,1")     
					MSCBSAY(055,007, Alltrim(SM0->M0_BAIRENT)+", Bs.","N","1","1,1")

					MSCBSAY(015,009, "As. Argentina","N","1","1,1")     
					MSCBSAY(055,009, "As. Argentina","N","1","1,1")

					MSCBSAY(015,011, "Origen China","N","1","1,1")     
					MSCBSAY(055,011, "Origen China","N","1","1,1")
					
					MSCBSAY(015,013, "CODIGO: "+Alltrim(SB1->B1_COD),"N","1","1,1")     
					MSCBSAY(055,013, "CODIGO: "+Alltrim(SB1->B1_COD),"N","1","1,1")

					MSCBSAY(015,015, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","1","1,1")     
					MSCBSAY(055,015, SubStr(Alltrim(SB1->B1_DESC),1,20),"N","1","1,1")

					MSCBEND()	

				Next n

			EndIf

			MSCBCLOSEPRINTER()
		Else
			MsgAlert("Atención","Producto no localizado.")
		EndIf
	EndIF

RETURN