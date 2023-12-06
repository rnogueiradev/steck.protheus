#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STEST130         | Autor | Renato Nogueira            | Data | 21/09/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST130()

	Local cArquivo 		:= ""
	Local lPrim	   		:= .T.
	Local aDados   		:= {}
	Local aVetor		:= {}
	Local _nX
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv("01","05",,,"FAT")

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
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

	If Len(aDados)=0
		MsgAlert('Não foi possível importar o arquivo!')
		Return
	EndIf

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))

	DbSelectArea("SBK")
	SBK->(DbSetOrder(1)) //BK_FILIAL+BK_COD+BK_LOCAL+DTOS(BK_DATA)

	DbSelectArea("SDB")
	SDB->(DbSetOrder(1)) //BK_FILIAL+BK_COD+BK_LOCAL+DTOS(BK_DATA)

	_cLog   := "Produto;Status"+CHR(10)+CHR(13)

	For _nX:=1 To Len(aDados)

		If !SB1->(DbSeek(xFilial("SB1")+PADR(AllTrim(aDados[_nx][1]),TamSx3("B1_COD")[1])))
			_cLog   += AllTrim(aDados[_nx][1])+";Produto não encontrado"+CHR(10)+CHR(13)
			Loop
		EndIf
		/*
		If !SB9->(DbSeek(xFilial("SB9")+SB1->B1_COD+"20200930"))
			SB9->(RecLock("SB9",.T.))
			SB9->B9_FILIAL 	:= xFilial("SB9")
			SB9->B9_COD 	:= SB1->B1_COD
			SB9->B9_DATA	:= STOD("20200930")
			SB9->B9_LOCAL	:= "01"
			SB9->B9_QINI	:= Val(StrTran(StrTran(aDados[_nX][2],".",""),",","."))
			SB9->B9_VINI1	:= Val(StrTran(StrTran(aDados[_nX][5],".",""),",","."))
			SB9->(MsUnLock())
		EndIf

		If !SBK->(DbSeek(xFilial("SBK")+SB1->B1_COD+"01"+"20200930"))
			SBK->(RecLock("SBK",.T.))
			SBK->BK_FILIAL 	:= xFilial("SB9")
			SBK->BK_COD 	:= SB1->B1_COD
			SBK->BK_LOCAL	:= "01"
			SBK->BK_DATA	:= STOD("20200930")
			SBK->BK_QINI	:= Val(StrTran(StrTran(aDados[_nX][2],".",""),",","."))
			SBK->BK_LOCALIZ	:= "1A0101A"
			SBK->(MsUnLock())
		EndIf
		*/
		//DB_FILIAL+DB_PRODUTO+DB_LOCAL+DTOS(DB_DATA)
		//If !SDB->(DbSeek(xFilial("SDB")+SB1->B1_COD+"01"+"20200930"))
		
		_cProxNum	:= SD3->(ProxNum())

		SDB->(RecLock("SDB",.T.))
		SDB->DB_FILIAL 	:= xFilial("SDB")
		SDB->DB_ITEM  	:= "0001"
		SDB->DB_PRODUTO := SB1->B1_COD
		SDB->DB_LOCAL 	:= "01"
		SDB->DB_LOCALIZ	:= "1A0101A"
		SDB->DB_DOC		:= "SCHNEIDER"
		SDB->DB_ORIGEM	:= "SD3"
		SDB->DB_DATA	:= STOD("20200930")
		SDB->DB_NUMSEQ	:= _cProxNum
		SDB->DB_TIPO	:= "D"
		SDB->DB_ATIVID	:= "ZZZ"
		SDB->DB_ANOMAL  := "N"
		SDB->DB_TM		:= "200"
		SDB->DB_SERVIC	:= "499"
		SDB->DB_QUANT	:= Val(StrTran(StrTran(aDados[_nX][2],".",""),",","."))
		SDB->(MsUnLock())
		//EndIf
		
		SD3->(RecLock("SD3",.T.))
		SD3->D3_FILIAL  := xFilial("SD3")
		SD3->D3_COD     := SB1->B1_COD
		SD3->D3_QUANT   := Val(StrTran(StrTran(aDados[_nX][2],".",""),",","."))
		SD3->D3_TM      := "200"
		SD3->D3_DOC     := "SCHNEIDER"
		SD3->D3_EMISSAO := STOD("20200930")
		SD3->D3_LOCALIZ := "1A0101A"
		SD3->D3_CC      := SB1->B1_CC
		SD3->D3_UM      := SB1->B1_UM
		SD3->D3_GRUPO   := SB1->B1_GRUPO
		SD3->D3_TIPO    := SB1->B1_TIPO
		SD3->D3_SEGUM   := SB1->B1_SEGUM
		SD3->D3_CONTA   := SB1->B1_CONTA
		SD3->D3_LOCAL   := "01"
		SD3->D3_CF      := "DE0"
		SD3->D3_CHAVE   := "E0"
		SD3->D3_CUSTO1	:= Val(StrTran(StrTran(aDados[_nX][3],".",""),",","."))
		//SD3->D3_USUARIO := cusername
		SD3->D3_NUMSEQ  := _cProxNum
		//SD3->D3_LOTECTL := TSB2->LOTECT
		SD3->(MsUnLock())

	Next

Return()
