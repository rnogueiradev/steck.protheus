#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMPSZD        | Autor | RENATO.OLIVEIRA           | Data | 30/04/2019  |
|=====================================================================================|
|Descrição | Subir carga SZD									                      |
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

User Function STIMPSZD()

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

	MsgAlert("Formato do csv: sku steck;sku cliente;codigo cliente")

	_cLog:= "RELATÓRIO DE PRODUTOS NÃO ENCONTRADOS "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	While !( oFT:ft_fEof() )
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

	oFT:ft_fSkip()
	End While

	oFT:ft_fUse()	

	DbSelectArea("SZD")
	SZD->(DbSetOrder(1)) 

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1)) 

	For i:=1 to Len(aDados)  //ler linhas da array

		_cCodigo := PADR(AllTrim(aDados[i,1]),15)
		_cCliente := PADL(AllTrim(aDados[i,3]),6,"0")

		If SA1->(DbSeek(xFilial("SA1")+_cCliente+"01"))

			SZD->(RecLock("SZD",.T.))
			SZD->ZD_CLIENTE := _cCliente
			SZD->ZD_CODCLI := aDados[i,2]
			SZD->ZD_CODSTE := _cCodigo
			SZD->(MsUnLock())

		Else

			MsgAlert("Cliente"+_cCliente+" nao encontrado, a importação será abortada")
			Return

		EndIf

	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return
