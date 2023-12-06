#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMPSBE        | Autor | RENATO.OLIVEIRA           | Data | 30/04/2019  |
|=====================================================================================|
|Descrição | Subir carga SBE									                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static __lOpened := .F.

User Function STIMPSBE()

	Local cArq    := "C:\arquivos_protheus\sb1.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\"
	Local n		  := 0
	Local i		  := 0
	Local oDlg

	Private aErro := {}

	RpcSetType( 3 )
	RpcSetEnv("01","05",,,"FAT")

	_cLog:= "RELATÓRIO DE CODIGOS NÃO ENCONTRADOS "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo

	_nX := 0

	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		_nX++

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	//Begin Transaction             //inicia transação

	DbSelectArea("SBE")
	SBE->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA
	
	For i:=1 to Len(aDados)  //ler linhas da array

		conout("rodando "+cValToChar(i))

		_cCodigo := PADR(AllTrim(aDados[i,3]),TamSx3("BE_LOCALIZ")[1])

		If !SBE->(DbSeek(xFilial("SBE")+"03"+_cCodigo))

			SBE->(Reclock("SBE",.T.))
			SBE->BE_FILIAL 	:= xFilial("SBE")
			SBE->BE_LOCAL	:= "03"
			SBE->BE_LOCALIZ	:= _cCodigo
			SBE->BE_DESCRIC := "ENDERECO "+_cCodigo
			SBE->(MsUnlock())
		EndIf
			
	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return
