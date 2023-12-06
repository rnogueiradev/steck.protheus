#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "SHELL.CH"
#define cgetfile_type getf_localhard+getf_localfloppy+getf_networkdrive
/*
|==============================================================================|
|                     				S T E C K                          		  |
|==============================================================================|
| Programa  | STESTF03	      |Autor Everson Santana 		|Data 10/03/2018	  |
|-----------+------------------------------------------------------------------|
|           |                                                                  |
|           | Rotina para carga da previsão de vendas 							  |
| Descrição | 														    	   		  |
|           | 									                              	  |
|-----------+------------------------------------------------------------------|
|    Uso    |  TOTVS Protheus | Módulo | SIGACFG          | Chamado | 9999999  |
|------------------------------------------------------------------------------|
|>>>>>>>>>>>>>>>>>>>>>>>>>> Histórico de Alterações <<<<<<<<<<<<<<<<<<<<<<<<<<<|
|------------------------------------------------------------------------------|
|   Data    |               Alteração               |    Autor     |  Chamado  |
|-----------+---------------------------------------+--------------+-----------|
|==============================================================================|
*/
USER FUNCTION STESTF03()

	PRIVATE _oBtArq
	PRIVATE _oBtArq1
	PRIVATE _oBtArq2
	PRIVATE _oBtFecha
	PRIVATE _oBtOk
	PRIVATE _cPath := ""
	PRIVATE _oCaminho
	PRIVATE _cCaminho := SPACE(100)

	STATIC _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Informe o Caminho do Arquivo para Importação" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
	@ 009, 005 SAY "Selecione o Arquivo: " SIZE 094, 007 OF _oDlg PIXEL
	@ 019, 005 BUTTON _oBtArq PROMPT "Selecionar" SIZE 082, 012 OF _oDlg ACTION(PROCDIR()) PIXEL
	@ 035, 005 MSGET _oCaminho VAR _cCaminho SIZE 189, 010 OF _oDlg PIXEL WHEN .F.
	@ 055, 036 BUTTON _oBtOk    PROMPT "Importar" SIZE 037, 012 OF _oDlg ACTION(Processa({|| IMPPROD(_cCaminho) },"Processando..."),_oDlg:END()) PIXEL
	@ 055, 117 BUTTON _oBtFecha PROMPT "FECHAR"   SIZE 037, 012 OF _oDlg ACTION(_oDlg:END()) PIXEL
	ACTIVATE MSDIALOG _oDlg CENTERED

RETURN()
/*
|==============================================================================|
|                     				S T E C K								   |
|==============================================================================|
| Programa  | IMPPROD	      |Autor Everson Santana 		|Data 04/01/2017   |
|-----------+------------------------------------------------------------------|
|           |                                                                  |
|           | Processamento da Rotina de importação							   |
| Descrição | 														    	   |
|           | 									                               |
|-----------+------------------------------------------------------------------|
|    Uso    |  TOTVS Protheus | Módulo | SIGACFG          | Chamado | 9999999  |
|------------------------------------------------------------------------------|
|>>>>>>>>>>>>>>>>>>>>>>>>>> Histórico de Alterações <<<<<<<<<<<<<<<<<<<<<<<<<<<|
|------------------------------------------------------------------------------|
|   Data    |               Alteração               |    Autor     |  Chamado  |
|-----------+---------------------------------------+--------------+-----------|
|==============================================================================|
*/
Static Function IMPPROD(_cCaminho)

	Local cLinha	:= ""
	Local aCampos := {}
	Local aDados	:= {}
	Local lPrim   := .T.
	Local i		:= 0
	Local j		:= 0
	Local cCampo	:= ""
	Local nXPREMES := 0
	Local nESTSEG	:= 0
	Local aRet 	:= {} //TamSX3(cCampo)

	FT_FUSE(_cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	Begin Transaction
		ProcRegua(Len(aDados))
		For i:=1 to Len(aDados)

			IncProc("Importando Produtos...")

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SB1")+aDados[i,1])
				Reclock("SB1",.F.)
				//	SB1->B1_FILIAL := xFilial("SB1")
				For j:=1 to Len(aCampos)
					If !Empty(aDados[i,j])
						If aCampos[j] $ "B1_XPREMES"
							cCampo  := "SB1->" + aCampos[j]
							&(cCampo) := aDados[i,j]
							nXPREMES  := Val(aDados[i,j])
						ElseIf aCampos[j] $ "B1_ESTSEG"
							cCampo  := "SB1->" + aCampos[j]
							&(cCampo) := Val(STRTRAN(aDados[i,j],",","."))
							nESTSEG	:= Val(STRTRAN(aDados[i,j],",","."))
						Else
							cCampo  := "SB1->" + aCampos[j]
							If FieldPos(aCampos[j]) > 0
								aRet := TamSX3(aCampos[j])
								If aRet[03] $ "N"
									&cCampo := Val(STRTRAN(aDados[i,j],",","."))
								ElseIf aRet[03] $ "D"
									&cCampo := Ctod(aDados[i,j])
								Else
									&cCampo := aDados[i,j]
								EndIf
//							Else
//								ConOut("*** RIC")
//								ConOut(cCampo)
							EndIf
						EndIf
					EndIf	
				Next j

				SB1->B1_XTXCOBE := nESTSEG/nXPREMES

				SB1->(MsUnlock())
			EndIf
		Next i
	End Transaction

	FT_FUSE()

	ApMsgInfo("Atualização concluída com sucesso!","[STECK]")

Return

/*
|==============================================================================|
|                     				S T E C 		                 				  |
|==============================================================================|
| Programa  | PROCDIR	      |Autor Everson Santana 		|Data 04/01/2017	  |
|-----------+------------------------------------------------------------------|
|           |                                                                  |
|           | Seleciona arquivo de processamento    								  |
| Descrição | 														    	   		  |
|           | 									                               	  |
|-----------+------------------------------------------------------------------|
|    Uso    |  TOTVS Protheus | Módulo | SIGACFG          | Chamado | 9999999  |
|------------------------------------------------------------------------------|
|>>>>>>>>>>>>>>>>>>>>>>>>>> Histórico de Alterações <<<<<<<<<<<<<<<<<<<<<<<<<<<|
|------------------------------------------------------------------------------|
|   Data    |               Alteração               |    Autor     |  Chamado  |
|-----------+---------------------------------------+--------------+-----------|
|==============================================================================|
*/
STATIC FUNCTION PROCDIR()

	LOCAL _CEXTENS   := "Arquivo a ser Anexado (*.CSV) |*.CSV|"
	_cPath := CGETFILE(_CEXTENS, "Selecione o arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
	_cArq := ALLTRIM(_cPath)
	IF !EMPTY(_cPath)
		IF LEN(_cArq) <= 0
			AVISO( cTitulo, "Não existe arquio no diretório informado.", {"OK"} )
			_cCaminho := ""
			_oCaminho:REFRESH()
		ELSE
			_cCaminho := _cArq
			_oCaminho:REFRESH()
		ENDIF
	ENDIF

RETURN()
