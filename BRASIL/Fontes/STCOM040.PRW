#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOM040
@name STCOM040
@type User Function
@desc carregar informações do fornecedor
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM040()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "01"
	Local cArquivo	:= cGetFile( "Arquivo CSV (*.csv) | *.csv", "Selecione o arquivo desejado",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	Local aDados	:= {}
	Local lPrim   	:= .T.
	Local _nX		:= 0

	_cLog := "RESUMO DE PROCESSAMENTO"+CHR(13)+CHR(10)

	If "SP" $ UPPER(cArquivo)
		cNewEmp := "01"
	ElseIf "AM" $ UPPER(cArquivo)
		cNewEmp := "03"
	Else
		MsgAlert("Favor identificar a empresa no arquivo.")
		Return
	EndIf

	RpcSetType( 3 )
	RpcSetEnv(cNewEmp,cNewFil,,,"FAT")

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo
		IncProc("Lendo arquivo texto...")
		cLinha := FT_FREADLN()           // lendo a linha
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf
		FT_FSKIP()
	EndDo

	For _nX:=1 To Len(aDados)

		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbGoTop())
		If !SA2->(DbSeek(xFilial("SA2")+aDados[_nX][1]+aDados[_nX][2]))
			_cLog := "Código "+aDados[_nX][1]+" não encontrado na tabela SA2."+CHR(13)+CHR(10)
			Loop
		EndIf

		DbSelectArea("AI3")
		AI3->(DbSetOrder(2))
		AI3->(DbGoTop())
		If !AI3->(DbSeek(xFilial("AI3")+SA2->A2_CGC))
			_cLog := "Código "+aDados[_nX][1]+" não encontrado na tabela AI3."+CHR(13)+CHR(10)
			Loop
		EndIf
		/*
		DbSelectArea("AI5")
		AI5->(DbSetOrder(1))
		AI5->(DbGoTop())
		If !AI5->(DbSeek(xFilial("AI5")+AI3->AI3_CODUSU))
			_cLog := "Código "+aDados[_nX][1]+" não encontrado na tabela AI5."+CHR(13)+CHR(10)
			Loop
		EndIf
		*/
		AI3->(RecLock("AI3",.F.))
		AI3->AI3_EMAIL := aDados[_nX][3]
		AI3->(MsUnLock())

		SA2->(RecLock("SA2",.F.))
		SA2->A2_EMAIL := aDados[_nX][3]
		SA2->(MsUnLock())

	Next

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return