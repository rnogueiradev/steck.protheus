#INCLUDE "PROTHEUS.CH"
/*====================================================================================\
|Programa  | STALTREJ         | Autor | GIOVANI.ZAGO             | Data | 28/10/2013  |
|=====================================================================================|
|Descrição |   P.E. MA410MNU				     	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STALTREJ                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STALTREJ()
	*-----------------------------*
	
	Local cVendNew    :=  SC5->C5_ZMOTREJ
	Local nOpca      := 0
	Local _cc5Mail :=  ' '
	
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Motivo Rejeição") From 1,0 To 10,60 OF oMainWnd
	
	@ 05,04 SAY "Motivo:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew   Size 200,012  PIXEL OF oDlgEmail
	
	@ 043, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 043, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	
	
	nOpca:=0
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
	
	If nOpca == 1
		
		SC5->(RecLock("SC5",.F.))
		SC5->C5_ZMOTREJ    := cVendNew
		SC5->(MsUnlock())
		
		If Empty(Alltrim(SC5->C5_PEDEXP))
			_cc5Mail := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+(Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
		Else
			_cc5Mail := GetMv("ST_EXMAIL",,'')
		EndIf
		u_StLibFinMail(alltrim(cVendNew),'rejeição',cusername,dtoc(date()),time(),_cc5Mail,'Rejeição')
		
	Endif
	
Return()
