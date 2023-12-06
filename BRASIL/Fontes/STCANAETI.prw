#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Include "ApWizard.ch"

/*/{Protheus.doc} STCANETI
Impressao etiquetas Tipo canaletas 8x35mm
@author thiago.fonseca
@since 20/05/2016
@version 1.0
@return NIL
/*/

User Function STCANETI()   // U_STCANETI()

U_ACDWZ()
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ACDWZ()
//////////////////////////////////////
Local oWizard
Local oPanel

DEFINE WIZARD oWizard TITLE "Etiqueta de Produto ACD" ; //"Etiqueta de Produto ACD"
       HEADER "Rotina de Impressão de etiquetas termica 8X35mm." ; //"Rotina de Impressão de etiquetas termica."
       MESSAGE "";
       TEXT "Esta rotina tem por objetivo realizar a impressao de etiquetas termicas em lotes com 08 unidades!";
		FINISH {|| .T. } ;
       PANEL


ACTIVATE WIZARD oWizard CENTERED

Return (GERAETIQ())


Static Function GERAETIQ()
	Local _cBarrasSt 	:= ' '
	Local _cDesc     	:= ' '
	Local cVendNew   	:=  Space(15)
	Local nLinH		:= 2
	Local nLinV 		:= 10
	Local nQtdEt		:= 0
	Local nCont		:= 0
	Local nCodBarra	:= 06
	Local _cLocImp		:= Space(6)
	Local nDesc		:= 03
	Local nTotEt		:= 8

	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'  TABLES "SB1","CB5" --- PARA MODO DEBUG


	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Canaleta Etiqueta 8X35mm") From 1,0 To 23,25 OF oMainWnd

	@ 05,04 SAY "Codigo:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew F3 'SB1'      Size 70,012  PIXEL OF oDlgEmail Valid(  Empty(cVendNew) .Or. existcpo("SB1",cVendNew) )
	@ 30,04 SAY substr(Posicione("SB1",1,xFilial("SB1")+cVendNew,"B1_DESC"),1,30)  PIXEL OF oDlgEmail
	@ 45,04 SAY "Qtd. Eti por lote de 08 unidades:" PIXEL OF oDlgEmail
	@ 60,04 MSGet nQtdEt		WHEN .T.   Picture "9999"	Size 30,011 PIXEL OF oDlgEmail
	@ 80,04 SAY "Cod.Bar:  "+ Posicione("SB1",1,xFilial("SB1")+cVendNew,"B1_CODBAR")  PIXEL OF oDlgEmail
	@ 95,04 SAY "Local de Impressao:" PIXEL OF oDlgEmail
	@ 105,04 MSGet _cLocImp F3 'CB5'     Size 70,012  PIXEL OF oDlgEmail Valid(  Empty(_cLocImp) .Or. existcpo("CB5",_cLocImp) )
	@ 120,04 SAY substr(Posicione("CB5",1,xFilial("CB5")+_cLocImp,"CB5_DESCRI"),1,20)  PIXEL OF oDlgEmail
	@ 053+90, 05 Button "Imprimir"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+90, 67 Button "Sair" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		_cDesc      := Alltrim(cVendNew)
		_cBarrasSt := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cDesc,"B1_CODBAR"))

		If EMPTY(_cDesc)
			MsgAlert("A Descrição para o produto "+_cDesc+" nao foi informada, impressao cancelada do item !")
			Return
		EndIf

		If EMPTY(_cBarrasSt)
			MsgAlert("Nao possui informacao para o codigo de barra do produto  "+_cDesc+" verifique, iMpressao sera cancelada !")
			Return
		EndIf

		If ! CB5SetImp(_cLocImp) .Or. Empty(_cLocImp)
			MsgAlert("Local de Impressão "+cLocImp+" nao Encontrado!") //"Local de Impressão "###" nao Encontrado!"
			Return .f.
		Endif


		If   CB5SetImp(_cLocImp)
			If ! MsgYesNo("Confirma a Impressao de "+cValToChar(nQtdEt)+" LOTE(S) com total de "+cValToChar(nQtdEt*8)+" etiquetas?")
				Return .F.
			EndIf

				MSCBInfoEti("CAN","CAN")

				MSCBBEGIN(nQtdEt,6)


				//Etiqueta 01
				MSCBSAYBAR(5,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(6,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(3,28,_cDesc   ,"R","0","018,18",.T.)

				//Etiqueta 02
				MSCBSAYBAR(16,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(17,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(13,28,_cDesc   ,"R","0","018,18",.T.)

				//Etiqueta 03
				MSCBSAYBAR(27,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(28,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(25,28,_cDesc   ,"R","0","018,18",.T.)

				//Etiqueta 04
				MSCBSAYBAR(38,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(39,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(35,28,_cDesc   ,"R","0","020,18",.T.)

				//Etiqueta 05
				MSCBSAYBAR(49,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(50,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(47,28,_cDesc   ,"R","0","015,18",.T.)

				//Etiqueta 06
				MSCBSAYBAR(60,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(61,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(58,28,_cDesc   ,"R","0","015,18",.T.)

				//Etiqueta 07
				MSCBSAYBAR(71,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(72,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(69,28,_cDesc   ,"R","0","015,18",.T.)

				//Etiqueta 08
				MSCBSAYBAR(82,4,_cBarrasSt   ,"R","MB04",4,.T.,.T.,.F.,,2,2,.F.)
				MSCBSAY(83,28.5,"STECK"  ,"R","0","020,20",.T.)
				MSCBSAY(80,28,_cDesc   ,"R","0","015,18",.T.)

			MSCBEND()
			MSCBCLOSEPRINTER()
		EndIf

		MSGINFO("Impressao Finalizada!")
	EndIf


Return()