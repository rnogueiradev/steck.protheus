#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP080        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP080()

	Private cArquivo := ""

	//RpcSetType( 3 )
	//RpcSetEnv("01","04",,,"FAT")

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
	Local aDados   := {}
	Local lPrim    := .T.
	Local _cLog	   := ""
	Local oDlg
	Local _lExecAuto := .T.
	Local _cProcs   := "Linha;Código;Status;Observação"+CHR(13)+CHR(10)
	Local _nY

	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")

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

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("QE8")
	QE8->(DbSetOrder(1)) //QE8_FILIAL+QE8_PRODUT+QE8_REVI+QE8_ENSAIO

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		aDados[_nY][1] := PADR(AllTrim(aDados[_nY][1]),TamSx3("QE8_PRODUT")[1])
		aDados[_nY][2] := PADR(AllTrim(aDados[_nY][2]),TamSx3("QE8_ENSAIO")[1])
		aDados[_nY][3] := PADL(AllTrim(aDados[_nY][3]),TamSx3("QE8_SEQLAB")[1],"0")

		Conout(_nY)

		If SB1->(DbSeek(xFilial("SB1")+aDados[_nY][1]))

			If !QE8->(DbSeek(xFilial("QE8")+aDados[_nY][1]+"00"+aDados[_nY][2]))
				QE8->(RecLock("QE8",.T.))
			Else
				QE8->(RecLock("QE8",.F.))
			EndIf

			QE8->QE8_PRODUT := aDados[_nY][1]
			QE8->QE8_REVI	:= "00"
			QE8->QE8_ENSAIO	:= aDados[_nY][2]
			QE8->QE8_ENSDES	:= "2"
			QE8->QE8_LABOR	:= "LABFIS"
			QE8->QE8_SEQLAB := aDados[_nY][3]
			QE8->QE8_TEXTO	:= aDados[_nY][4]
			QE8->QE8_AM_INS	:= "2"
			QE8->(MsUnLock())

		EndIf

	Next

Return()
