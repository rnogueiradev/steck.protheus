#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STALTCHV  ºAutor  ³Renato Nogueira     º Data ³  24/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa utilizado para trocar a chave de acesso do doc. deº±±
±±º          ³ entrada 			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck - Chamado 000123                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STALTCHV()

Local 	aArea   	:= GetArea()
Local 	lSaida		:= .F.
Private	cGetChv		:= space(44)
Private cFormul 	:= "N"
Private cEspecie	:= "SPED"

If Alltrim(SF1->F1_ESPECIE)=="SPED"
	
	While !lSaida
		
		Define msDialog oDlg Title "Digitar chave de acesso" From 10,10 TO 20,95 //Style DS_MODALFRAME
		
		@ 010,060 MsGet cGetChv valid A103ConsNfeSef() size 200,10 Picture "99999999999999999999999999999999999999999999" pixel OF oDlg //F3 "USR"
		
		DEFINE SBUTTON FROM 50,150 TYPE 1 ACTION IF(Len(Alltrim(cGetChv))=44,(nOpcao:=1,lSaida:=.T.,oDlg:End()),MsgAlert("Atenção, a chave não possui 44 dígitos")) ENABLE OF oDlg
		
		Activate dialog oDlg centered
		
	End
	
	If nOpcao = 1
		
		SF1->(Reclock("SF1",.F.))
		SF1->F1_CHVNFE	:= cGetChv
		SF1->(Msunlock())
		
		MsgInfo("Chave alterada com sucesso!")
		
	EndIf
	
Else
	
	MsgAlert("Atenção, a espécie do documento é diferente de SPED")
	
EndIf

RestArea(aArea)

Return()