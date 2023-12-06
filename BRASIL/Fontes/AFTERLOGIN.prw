#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ AFTERLOGIN ºAutor³ Jonathan Schmidt AlvesºData ³21/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. na entrada de qualquer modulo para gravar dados na    º±±
±±º          ³ tabela Z1F (Acessos Usuarios).                             º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01] Cod Usuario                                   º±±
±±º          ³ PARAMIXB[02] Nome do Usuario                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AFTERLOGIN()
Local _cFilZ1F := xFilial("Z1F")
Local cCodUsr := PARAMIXB[01]
Local cNomUsr := PARAMIXB[02]
ConOut("AFTERLOGIN: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
/*
If cCodUsr == "000000"

    SetKey(VK_F2,{|| u_DwFile74() })		// CPYS2T para a Temp
    SetKey(VK_F4,{|| u_UpFile74() })		// CPYT2S para a System

    SetKey(VK_F6,{|| u_SCHGEN03() })		// Programa SOD (Controle dos Menus XNU)		Atalho SCHGEN03 no Desenvolvimento			*** Remover depois
	SetKey(VK_F7,{|| u_SCHGEN05() })		// Programa SALARY REVIEW (Fluxo Aprovacoes)	Atalho SCHGEN05 no Desenvolvimento			*** Remover depois

EndIf
*/
DbSelectArea("Z1F")
Z1F->(DbSetOrder(1)) // Z1F_FILIAL + Z1F_COD
If Z1F->(!DbSeek(_cFilZ1F + cCodUsr))
    RecLock("Z1F",.T.)
    Z1F->Z1F_FILIAL := _cFilZ1F
    Z1F->Z1F_COD    := cCodUsr
    Z1F->Z1F_NOME   := cNomUsr
    Z1F->(MsUnlock())
EndIf
ConOut("AFTERLOGIN: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return



User Function DwFile74() // F2
Local cFile := fAbrir("*.*") // "c:\temp\lgrl7403.bmp"
If File(cFile)
	lRet := CpyS2T(cFile,"c:\temp",.F.)
	If lRet
		MsgInfo("Sucesso!","DwFile74")
	EndIf
EndIf
Return

User Function UpFile74() // F4
Local cFile := fAbrir("*.*") // "c:\temp\lgrl7403.bmp"
If File(cFile)
	// lRet := CpyT2S(cFile,"\workflow\",.F.)
	lRet := CpyT2S(cFile,"\system\",.F.) // lRet := CpyT2S(cFile,"\workflow\",.F.) // lRet := CpyT2S(cFile,"\system\",.F.) //lRet := CpyT2S(cFile,"\workflow\",.F.)
	If lRet
		MsgInfo("Sucesso!","UpFile74")
	EndIf
EndIf
Return

Static Function fAbrir(cExt) // "*.CSV"
Local cType := "Arquivo | " + cExt + "|"
Local cArq := ""
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo para importar"),0,,.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY)
If Empty(cArq)
	cArqRet := ""
Else
	cArqRet := cArq
EndIf
Return cArqRet
