#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} IMPQCPRO
(Importacao Planilha QCPRO)

@author jefferson.carlos
@since 06/12/2016
@version 1.0
@return ${return}, ${return_description}

/*/

User Function IMPQCPRO()

	PRIVATE _oCaminho
	PRIVATE _cCaminho := SPACE(100)

	STATIC _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Selecione o Arquivo para importação" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
	@ 009, 005 SAY "Selecione o Arquivo para importação: " SIZE 120, 007 OF _oDlg PIXEL
	@ 019, 005 BUTTON _oBtArq PROMPT "Selecionar" SIZE 082, 012 OF _oDlg ACTION(PROCDIR()) PIXEL WHEN .t.
	@ 035, 005 MSGET _oCaminho VAR _cCaminho SIZE 189, 010 OF _oDlg PIXEL WHEN .F.

	@ 057, 036 BUTTON _oBtOk    PROMPT "IMPORTAR" SIZE 037, 012 OF _oDlg ACTION(Processa( {||StProcSG2(_cCaminho)},"Aguarde...","Importando Arquivo...",.F.),_oDlg:END()) PIXEL
	@ 057, 117 BUTTON _oBtFecha PROMPT "FECHAR"   SIZE 037, 012 OF _oDlg ACTION(_oDlg:END()) PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	/*
	If MsgYesNo("Deseja importar arquivo de Pré-Estrutura?")
		Processa( {||StProcSG2()},"Aguarde...","Importando Arquivo...",.F.)
	EndIf
	*/

Static Function StProcSG2(_cCaminho)

	Local cArq    := "estruturas.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := _cCaminho //"C:\"
	Local i		  := 0

	Private aErro := {}

	If !File(cDir)
		MsgStop("O arquivo " +cDir + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cDir)                   // abrir arquivo
	ProcRegua(FT_FLASTREC()*2)             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()

		IncProc("Lendo arquivo texto... Linha: "+StrZero(1+Len(aDados),6))

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()

	End

	For i:=1 To Len(aDados)  //ler linhas da array

		aDados[i,1] := PADL(AllTrim(aDados[i,1]),2,"0")

		If AllTrim(aDados[i,1])=="04"
			MsgAlert("Rotina desabilitada para a filial 04, a importação será abortada, verifique!")
			Return
		EndIf

		IncProc("Importando SGG... Registro: "+StrZero(i,6))

		DbSelectArea("SGG")

		//GG_FILIAL	GG_COD	GG_COMP	GG_TRT	GG_QUANT	GG_FIXVAR	GG_GROPC	GG_OPC
		Reclock("SGG",.T.)
		SGG->GG_FILIAL	:= aDados[i,1]
		SGG->GG_COD 		:= aDados[i,2]
		SGG->GG_COMP 		:= aDados[i,3]
		SGG->GG_TRT 		:= aDados [i,4]
		SGG->GG_QUANT 	:= Val(aDados [i,5])
		SGG->GG_FIXVAR	:= aDados[i,6]
		SGG->GG_GROPC		:= aDados [i,7]
		SGG->GG_OPC   	:= aDados[i,8]
		SGG->GG_OBSERV 	:= DTOC(DDATABASE)
		SGG->GG_INI  		:= CTOD("01/01/2001")
		SGG->GG_FIM    	:= CTOD("31/12/2049")
		SGG->GG_STATUS  	:= "1"

		SGG->(MsUnlock())

	Next i

	FT_FUSE()

	ApMsgInfo("Importação concluída com sucesso!","[AEST901] - SUCESSO")

Return

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

