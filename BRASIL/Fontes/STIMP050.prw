#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP050        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMP050()

	Private cArquivo := ""

	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oProcess := MsNewProcess():New( { || PROCESSA() } , "Processando" , "Processando, por favor aguarde..." , .F. )
	oProcess:Activate()

Return()

/*====================================================================================\
|Programa  | PROCESSA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSA()

	Local aCampos  := {}
	Local lPrim    := .T.
	Local _cLog	   := ""
	Local oDlg
	Local _lExecAuto := .T.
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _nY
	Private aDados   := {}
	Private _nY

	oProcess:SetRegua1(FT_FLASTREC())

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		oProcess:IncRegua1("Lendo arquivo...")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	oProcess:SetRegua1(Len(aDados))

	_cLog := ""

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	DbSelectArea("SBF")
	SBF->(DbSetOrder(1))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		If !SB1->(DbSeek(xFilial("SB1")+aDados[_nY][1]))
			_cLog += "Linha "+cValToChar(_nX)+" - produto não encontrado!"+CHR(13)+CHR(10)
			Loop
		EndIf
		If !SB2->(DbSeek(xFilial("SB2")+PADR(aDados[_nY][1],TamSx3("B2_COD")[1])+aDados[_nY][2]))
			SB2->(RecLock("SB2",.T.))
			SB2->B2_FILIAL := xFilial("SB2")
			SB2->B2_COD    := SB1->B1_COD
			SB2->B2_LOCAL  := aDados[_nY][2]
			SB2->B2_QATU   := Val(StrTran(aDados[_nY][4],",","."))
			SB2->(MsUnLock())
		Else
			SB2->(RecLock("SB2",.F.))
			SB2->B2_QATU   := Val(StrTran(aDados[_nY][4],",","."))
			SB2->(MsUnLock())
		EndIf
		If !SBF->(DbSeek(xFilial("SBF")+PADR(aDados[_nY][2],TamSx3("BF_LOCAL")[1])+PADR(aDados[_nY][3],TamSx3("BF_LOCALIZ")[1])+PADR(aDados[_nY][4],TamSx3("B2_COD")[1])))
			SBF->(RecLock("SBF",.T.))
			SBF->BF_FILIAL := xFilial("SBF")
			SBF->BF_PRODUTO:= SB1->B1_COD
			SBF->BF_LOCAL  := aDados[_nY][2]
			SBF->BF_LOCALIZ:= aDados[_nY][3]
			SBF->BF_QUANT  := Val(StrTran(aDados[_nY][4],",","."))
			SBF->(MsUnLock())
		Else
			SBF->(RecLock("SBF",.F.))
			SBF->BF_QUANT  := Val(StrTran(aDados[_nY][4],",","."))
			SBF->(MsUnLock())
		EndIf
		
		_cLog += "Linha "+cValToChar(_nY)+" - produto atualizado!"+CHR(13)+CHR(10)

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatório de inconsistências'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()