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
|           | Rotina para carga da tabela Z74 -  							  |
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
USER FUNCTION STFATZ74(_CodCon)
	PRIVATE xCodCon := _CodCon
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
	Local aDados	:= {}
	Local i		:= 0
	Local _lLock := .F.

	Z74->(DBCLOSEAREA())

	FT_FUSE(_cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()
		AADD(aDados,Separa(cLinha,";",.T.))
		aDados[LEN(aDados),1] := PADR(aDados[LEN(aDados),01],15, " ")
		FT_FSKIP()
	EndDo

	//Begin Transaction

		ProcRegua(Len(aDados))
		For i:=1 to Len(aDados)

			IncProc("Importando Produtos...")
			DBSELECTAREA("Z74")
			Z74->(DBSETORDER(2))
			If DbSeek(xFilial("Z74")+xCodCon+aDados[i,01])
				_lLock := .F.
			else
				_lLock := .T.
			Endif
			Reclock("Z74",_lLock)
			Z74->Z74_FILIAL := XFILIAL("Z74")
			Z74->Z74_CODIGO := xCodCon
			Z74->Z74_PROD   := aDados[i,1]
			Z74->Z74_PRECO  := VAL(STRTRAN(aDados[i,2],",","."))
			Z74->(MSUNLOCK())
			Z74->(DBCLOSEAREA())
		Next i
	//End Transaction
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
