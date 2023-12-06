#INCLUDE "PROTHEUS.CH"
#INCLUDE "SET.CH"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} ARSTETQ03

Etiquetas de Cientes

@type function
@author Everson Santana
@since 15/06/18
@version Protheus 12 - Stock/Costos

@history , ,

/*/
User Function ARSTETQ3()

	Local cPorta 	:= "LPT1"
	LOCAL oButton 	:={}
	LOCAL cProduto 	:= Space(15)
	LOCAL nQuant  	:= space(8)
	LOCAL xQuant	:= space(4)
	Local _nAt		:= 0
	Local nX		:= 0
	Local _lConf	:= .F.
	Local aItems	:= {'Tipo 1','Tipo 2','Tipo 3'}
	Local cCombo1	:= aItems[1]


	LOCAL oDlg, oSay
	LOCAL oFont:= TFont():New("Courier New",,-12,.T.,.T.)
	LOCAL aFont:= TFont():New("Arial",,-12,.T.)
	LOCAL bFont:= TFont():New("Arial",,-14,.T.,.T.)

	DEFINE MSDIALOG oDlg FROM 0,0 TO 240,290 PIXEL TITLE "Impresión de etiquetas - ARSTETQ3"

	@ 010, 07 SAY OemToAnsi("Codigo:")	FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 010, 075 MSGET oGet1 VAR cProduto    SIZE 57,10 OF oDlg F3 "SB1" PIXEL Picture "@!"
	@ 030, 07 SAY OemToAnsi("Cantidad/Pieza:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 030, 075 MSGET oGet2 VAR nQuant		SIZE 57,10 OF oDlg PIXEL
	@ 050, 07 SAY OemToAnsi("Cantidad/Impresión:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 050, 075 MSGET oGet3 VAR xQuant		SIZE 57,10 OF oDlg PIXEL
	@ 070, 07 SAY OemToAnsi("Tipo/Impresión:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	oCombo1 := TComboBox():New(70,075,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,57,10,oDlg,,{||},,,,.T.,,,,,,,,,'cCombo1')

	oButton:=tButton():New(090,90,"CONFIRMA",oDlg,{||_lConf:= .T.,oDlg:End()},40,20,,,,.T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	If _lConf

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SB1")+cProduto)

		MSCBPRINTER("ELTRON",cPorta,,,.F.)

		If cCombo1 $ "Tipo 1"

			MSCBLOADGRF("STECK1.PCX") //Logo Lateral
			MSCBLOADGRF("ARIRAM1.PCX")// Iram

			For nx:=1 to Val(xQuant)

				MSCBBEGIN(1,6)

				MSCBGRAFIC(02,01,"STECK1")

				MSCBGRAFIC(20,34,"ARIRAM1")
				MSCBSAY(20,03,Alltrim(SubStr(Alltrim(SB1->B1_DESC),1,40)) ,"N","4","1,1")
				MSCBSAY(20,06,Alltrim(SubStr(Alltrim(SB1->B1_DESC),41,40)) ,"N","4","1,1")
				MSCBSAY(20,11,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_"," "),"N","4","1,1")

				//>>Argentina
				_nAt := at("_",Alltrim(SB1->B1_COD))

				If _nAt > 0
					If _nAt = 3
						MSCBBOX(25.5,13.8,27,13.8)
					Else
						MSCBBOX(23.5,13.8,25,13.8)
					EndIf

				EndIf
				//<<Argentina

				//Quantidade

				MSCBSAY(70,10,"Conteudo/Contenido: "						,"N","1","1,1")
				MSCBSAY(70,13,"Peca(s)/Pieza(s)"							,"N","1","1,1")
				MSCBSAY(95,10,nQuant										,"N","4","1,1")

				cComposicao := ""
				cTensao 	:= ""
				cCorrente 	:= ""
				_cOrigem	:= ""

				MSCBSAY(20,16,"Composicao/Composicion: "+ cComposicao							,"N","1","1,1")
				MSCBSAY(20,19,"Tensao/Tension Max.: "	+ cTensao								,"N","1","1,1")
				MSCBSAY(45,19,"Corrente/Intensidad: "	+ cCorrente								,"N","1","1,1")
				MSCBSAY(20,22,"Produto nao perecivel - Producto no Perecedero"					,"N","1","1,1")
				MSCBSAY(20,25,"Fabricado/Hecho "+_cOrigem										,"N","1","1,1")
				MSCBSAY(20,28,"www.steck.com.br"												,"N","1","1,1")

				MSCBSAY(55,26,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,28,"STECK INDUSTRIA ELETRICA LTDA"			,"N","1","1,1")
				MSCBSAY(55,30,"AV. CONDESSA ELISABETH ROBIANO 320"		,"N","1","1,1")
				MSCBSAY(55,32,"BOX H - CEP 03074-000 - SAO PAULO"		,"N","1","1,1")
				MSCBSAY(55,34,"BRASIL"									,"N","1","1,1")

				MSCBSAY(55,37,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,39,"STECK ELECTRIC S.A."						,"N","1","1,1")
				MSCBSAY(55,41,"BELISARIO HUEYO, 165 - AVELLANEDA"  		,"N","1","1,1")
				MSCBSAY(55,43,"BUENOS AIRES - ARGENTINA"				,"N","1","1,1")

				MSCBSAY(55,46,"STECK DE MEXICO S.A. DE C.V."			,"N","1","1,1")
				MSCBSAY(55,48,"CALLE MIRANDA, 11"						,"N","1","1,1")
				MSCBSAY(55,50,"COL. ARAGON LA VILLA - DF"				,"N","1","1,1")
				MSCBSAY(55,52,"R.F.C. SME981217GS4"						,"N","1","1,1")

				MSCBEND()

			Next

		Elseif cCombo1 $ "Tipo 2"

			For nx:=1 to Val(xQuant)
				MSCBBEGIN(1,6)
				MSCBGRAFIC(02,01,"STECK1")

				//MSCBGRAFIC(20,34,"ARIRAM1")
				//MSCBSAY(20,03,Alltrim(Alltrim(SB1->B1_DESC)) ,"N","4","1,1")
				MSCBSAY(20,11,StrTran(Alltrim(SB1->B1_COD),"_"," "),"N","4","4,6")

				//>>Argentina
				_nAt := at("_",Alltrim(SB1->B1_COD))
	
				If _nAt > 0
					If _nAt = 3
						MSCBBOX(35.5,25,43,25.5)
					Else
						MSCBBOX(27.5,25,35,25.5)
					EndIf
	
				EndIf
				//<<Argentina
	
				MSCBSAY(20,34,Alltrim(nQuant)+" Unidades "										,"N","4","3,5")
	
				/*
				//Quantidade
	
				MSCBSAY(70,10,"Conteudo/Contenido: "						,"N","1","1,1")
				MSCBSAY(70,13,"Peca(s)/Pieza(s)"							,"N","1","1,1")
				MSCBSAY(95,10,nQuant										,"N","4","1,1")
	
				cComposicao := ""
				cTensao 	:= ""
				cCorrente 	:= ""
				_cOrigem	:= ""
	
				MSCBSAY(20,16,"Composicao/Composicion: "+ cComposicao							,"N","1","1,1")
				MSCBSAY(20,19,"Tensao/Tension Max.: "	+ cTensao								,"N","1","1,1")
				MSCBSAY(45,19,"Corrente/Intensidad: "	+ cCorrente								,"N","1","1,1")
				MSCBSAY(20,22,"Produto nao perecivel - Producto no Perecedero"					,"N","1","1,1")
				MSCBSAY(20,25,"Fabricado/Hecho "+_cOrigem										,"N","1","1,1")
				MSCBSAY(20,28,"www.steck.com.br"												,"N","1","1,1")
	
				MSCBSAY(55,26,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,28,"STECK INDUSTRIA ELETRICA LTDA"			,"N","1","1,1")
				MSCBSAY(55,30,"AV. CONDESSA ELISABETH ROBIANO 320"		,"N","1","1,1")
				MSCBSAY(55,32,"BOX H - CEP 03074-000 - SAO PAULO"		,"N","1","1,1")
				MSCBSAY(55,34,"BRASIL"									,"N","1","1,1")
	
				MSCBSAY(55,37,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,39,"STECK ELECTRIC S.A."						,"N","1","1,1")
				MSCBSAY(55,41,"BELISARIO HUEYO, 165 - AVELLANEDA"  		,"N","1","1,1")
				MSCBSAY(55,43,"BUENOS AIRES - ARGENTINA"				,"N","1","1,1")
	
				MSCBSAY(55,46,"STECK DE MEXICO S.A. DE C.V."			,"N","1","1,1")
				MSCBSAY(55,48,"CALLE MIRANDA, 11"						,"N","1","1,1")
				MSCBSAY(55,50,"COL. ARAGON LA VILLA - DF"				,"N","1","1,1")
				MSCBSAY(55,52,"R.F.C. SME981217GS4"						,"N","1","1,1")
				*/
				MSCBEND()
			Next

		ElseIf cCombo1 $ "Tipo 3"

			MSCBLOADGRF("STECK1.PCX") //Logo Lateral
			//MSCBLOADGRF("ARIRAM1.PCX")// Iram

			For nx:=1 to Val(xQuant)

				MSCBBEGIN(1,6)

				MSCBGRAFIC(02,01,"STECK1")

				//MSCBGRAFIC(20,34,"ARIRAM1")
				MSCBSAY(20,03,Alltrim(SubStr(Alltrim(SB1->B1_DESC),1,40)) ,"N","4","1,1")
				MSCBSAY(20,06,Alltrim(SubStr(Alltrim(SB1->B1_DESC),41,40)) ,"N","4","1,1")
				MSCBSAY(20,11,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_"," "),"N","4","1,1")

				//>>Argentina
				_nAt := at("_",Alltrim(SB1->B1_COD))

				If _nAt > 0
					If _nAt = 3
						MSCBBOX(25.5,13.8,27,13.8)
					Else
						MSCBBOX(23.5,13.8,25,13.8)
					EndIf

				EndIf
				//<<Argentina

				//Quantidade

				MSCBSAY(70,10,"Conteudo/Contenido: "						,"N","1","1,1")
				MSCBSAY(70,13,"Peca(s)/Pieza(s)"							,"N","1","1,1")
				MSCBSAY(95,10,nQuant										,"N","4","1,1")

				cComposicao := ""
				cTensao 	:= ""
				cCorrente 	:= ""
				_cOrigem	:= ""

				MSCBSAY(20,16,"Composicao/Composicion: "+ cComposicao							,"N","1","1,1")
				MSCBSAY(20,19,"Tensao/Tension Max.: "	+ cTensao								,"N","1","1,1")
				MSCBSAY(45,19,"Corrente/Intensidad: "	+ cCorrente								,"N","1","1,1")
				MSCBSAY(20,22,"Produto nao perecivel - Producto no Perecedero"					,"N","1","1,1")
				MSCBSAY(20,25,"Fabricado/Hecho "+_cOrigem										,"N","1","1,1")
				MSCBSAY(20,28,"www.steck.com.br"												,"N","1","1,1")

				MSCBSAY(55,26,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,28,"STECK INDUSTRIA ELETRICA LTDA"			,"N","1","1,1")
				MSCBSAY(55,30,"AV. CONDESSA ELISABETH ROBIANO 320"		,"N","1","1,1")
				MSCBSAY(55,32,"BOX H - CEP 03074-000 - SAO PAULO"		,"N","1","1,1")
				MSCBSAY(55,34,"BRASIL"									,"N","1","1,1")

				MSCBSAY(55,37,"IMPORTADO E DISTRIBUIDO POR"				,"N","1","1,1")
				MSCBSAY(55,39,"STECK ELECTRIC S.A."						,"N","1","1,1")
				MSCBSAY(55,41,"BELISARIO HUEYO, 165 - AVELLANEDA"  		,"N","1","1,1")
				MSCBSAY(55,43,"BUENOS AIRES - ARGENTINA"				,"N","1","1,1")

				MSCBSAY(55,46,"STECK DE MEXICO S.A. DE C.V."			,"N","1","1,1")
				MSCBSAY(55,48,"CALLE MIRANDA, 11"						,"N","1","1,1")
				MSCBSAY(55,50,"COL. ARAGON LA VILLA - DF"				,"N","1","1,1")
				MSCBSAY(55,52,"R.F.C. SME981217GS4"						,"N","1","1,1")

				MSCBEND()

			Next

		EndIf

		MSCBCLOSEPRINTER()

		_lConf := .F.
	EndIf

RETURN