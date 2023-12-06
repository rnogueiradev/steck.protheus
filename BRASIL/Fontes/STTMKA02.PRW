#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKA02     ºAutor  ³Renato Nogueira  º Data ³  02/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para adicionar motivos de cancelamento no orçamento	  º±±
±±º          ³ 				                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 


User Function STTMKA02()

Local cGetPre :=  space(6)
Local cGetNum :=  space(6)
Local _NomeUser1 := cUserName
Public _cStxVend

dbSelectArea("SU7")
SU7->(dbSetOrder(4))
If SU7->(dbSeek( xFilial("SU7")+__cUserId))
	
	_cStxVend := SU7->U7_CODVEN
	
Endif

dbSelectArea("SUA")

If SUBSTR(_cStxVend,1,1) <> 'I'
	SUA->(dbSetFilter({|| SUA->UA_VEND  ==  _cStxVend }," SUA->UA_VEND  ==  _cStxVend"))
EndIf


Do While .t.
	
	Define msDialog oDlg Title "Mot Canc Orc" From 10,10 TO 30,45
	
	@ 015,010 say "Orçamento: "
	@ 025,010 get cGetPre size 15,12 VALID (existcpo("SUA",cGetPre)) F3 "SUA"
	@ 040,010 say "Motivo: "
	@ 050,010 get cGetNum valid !empty(cGetNum) size 15,12 F3 'PA3FSW'
	
	DEFINE SBUTTON FROM 75,15 TYPE 1 ACTION IF( !empty(cGetNum),(nOpcao:=1,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg
	DEFINE SBUTTON FROM 75,55 TYPE 2 ACTION (nOpcao:=0,oDlg:End()) ENABLE OF oDlg
	
	Activate dialog oDlg centered
	
	If nOpcao = 1
		
		Processa({|| insertcanc(cGetPre,cGetNum,_cStxVend) }, "Inserindo motivo. Aguarde! ...")
		
		Exit
		
	Else
		Exit
	Endif
Enddo
return()

Static Function insertcanc(cGetPre,cGetNum,_cStxVend)

dbSelectArea( "SUA" )
SUA->(dbSetOrder(1))
If dbSeek( xFilial("SUA")+cGetPre)
	If substr(_cStxVend,1,1) = 'I'
		SUA->( RecLock("SUA",.F.) )
		UA_XCODMCA := cGetNum
		SUA->( MsUnLock('SUA'))
		SUA->( DbCommit() )
		 If UA_XCODMCB==UA_XCODMCA
		 	SUA->( RecLock("SUA",.F.) )
			UA_STATUS := "CAN"
			UA_CANC   := "S"
			UA_CODCANC:= UA_XCODMCA
			SUA->( MsUnLock('SUA'))
			SUA->( DbCommit() )
		 EndIf
	Elseif substr(_cStxVend,1,1) <> 'I'
		SUA->( RecLock("SUA",.F.) )
		UA_XCODMCB:= cGetNum
		SUA->( MsUnLock('SUA'))
		SUA->( DbCommit() )
		If UA_XCODMCB==UA_XCODMCA
		 	SUA->( RecLock("SUA",.F.) )
			UA_STATUS := "CAN"
			UA_CANC   := "S"
			UA_CODCANC:= UA_XCODMCA
			SUA->( MsUnLock('SUA'))
			SUA->( DbCommit() )
		 EndIf
	Else
		ALERT("Não achou o orçamento")
	EndIf
EndIf

Return()