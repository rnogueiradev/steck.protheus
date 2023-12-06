#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP090        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP090()

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

	DbSelectArea("QE1")
	QE1->(DbSetOrder(1))

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		aDados[_nY][1] := PADR(AllTrim(aDados[_nY][1]),TamSx3("QE1_ENSAIO")[1])

		Conout(_nY)

		If !QE1->(DbSeek(xFilial("QE1")+aDados[_nY][1]))
			QE1->(RecLock("QE1",.T.))
		Else
			QE1->(RecLock("QE1",.F.))
		EndIf

		QE1->QE1_ENSAIO := aDados[_nY][1]
		QE1->QE1_DESCPO	:= aDados[_nY][2]
		QE1->QE1_DTCAD	:= CTOD(aDados[_nY][3])
		QE1->QE1_CARTA	:= aDados[_nY][4]
		QE1->QE1_QTDE	:= Val(aDados[_nY][5])
		QE1->QE1_TIPO	:= "2"
		QE1->(MsUnLock())

	Next

Return()
