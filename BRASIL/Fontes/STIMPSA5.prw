#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMPSA5        | Autor | RENATO.OLIVEIRA           | Data | 30/04/2019  |
|=====================================================================================|
|Descrição | Subir carga SA5									                      |
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

User Function STIMPSA5()

	Local cArq    := "C:\arquivos_protheus\sa5.csv
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
	RpcSetEnv("11","01",,,"FAT")

	_cLog:= "RELATÓRIO DE PRODUTOS NÃO ENCONTRADOS "+CHR(13) +CHR(10)

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

		Conout(_nX)

		FT_FSKIP()
	EndDo

	//Begin Transaction             //inicia transação

	DbSelectArea("SA5")

	For i:=1 to Len(aDados)  //ler linhas da array

		conout(i)

		_cProd := PADR(AllTrim(aDados[i,3]),TamSx3("A5_PRODUTO")[1])
		_cForn := PADR(AllTrim(aDados[i,1]),TamSx3("A5_FORNECE")[1])
		_cLoja := PADR(AllTrim(aDados[i,2]),TamSx3("A5_LOJA")[1])

		If Empty(_cProd) .Or. Empty(_cForn) .Or. Empty(_cLoja)
			Loop
		EndIf

		SA5->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA
		If SA5->(DbSeek(xFilial("SA5")+_cForn+_cLoja+_cProd+aDados[i,5]+aDados[i,6]))
			SA5->(Reclock("SA5",.F.))
			_cLog += _cForn+" "+_cLoja+" "+_cProd+" atualizado"+CHR(13) +CHR(10)
		Else
			SA5->(Reclock("SA5",.T.))
			_cLog += _cForn+" "+_cLoja+" "+_cProd+" criado"+CHR(13) +CHR(10)
		Endif

		SA5->A5_FORNECE 	:= _cForn
		SA5->A5_LOJA 		:= _cLoja
		SA5->A5_NOMEFOR		:= Posicione("SA2",1,xFilial("SA2")+_cForn+_cLoja,"A2_NREDUZ")
		SA5->A5_PRODUTO 	:= _cProd
		SA5->A5_NOMPROD 	:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC")
		SA5->A5_CODPRF		:= aDados[i,4]
		SA5->A5_FABR		:= aDados[i,5]
		SA5->A5_FALOJA		:= aDados[i,6]
		SA5->A5_SITU		:= aDados[i,7]
		SA5->A5_SKPLOT		:= aDados[i,8]
		SA5->A5_TEMPLIM		:= Val(aDados[i,9])
		SA5->A5_FABREV		:= aDados[i,10]
		SA5->(MsUnlock())

	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return
