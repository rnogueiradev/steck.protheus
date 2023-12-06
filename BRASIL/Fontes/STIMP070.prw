#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP070        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP070()

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

	DbSelectArea("QE6")
	QE6->(DbSetOrder(1)) //QE6_FILIAL+QE6_PRODUT+QE6_REVINV

	DbSelectArea("QE7")
	QE7->(DbSetOrder(1)) //QE7_FILIAL+QE7_PRODUT+QE7_REVI+QE7_ENSAIO

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		aDados[_nY][1] := PADR(AllTrim(aDados[_nY][1]),TamSx3("QE6_PRODUT")[1])
		aDados[_nY][2] := PADL(AllTrim(aDados[_nY][2]),TamSx3("QE6_REVI")[1],"0")
		aDados[_nY][3] := PADR(AllTrim(aDados[_nY][3]),TamSx3("QE7_ENSAIO")[1])

		Conout(_nY)

		If SB1->(DbSeek(xFilial("SB1")+aDados[_nY][1]))

			If !QE6->(DbSeek(xFilial("QE6")+aDados[_nY][1]+"YY"))
				QE6->(RecLock("QE6",.T.))
			Else
				QE6->(RecLock("QE6",.F.))
			EndIf

			QE6->QE6_PRODUT := aDados[_nY][1]
			QE6->QE6_REVI	:= aDados[_nY][2]
			QE6->QE6_REVINV := "YY"
			QE6->QE6_DESCPO	:= SB1->B1_DESC
			QE6->QE6_TIPO	:= SB1->B1_TIPO
			QE6->QE6_DTINI	:= CTOD(aDados[_nY][5])
			QE6->QE6_DTCAD	:= CTOD(aDados[_nY][6])
			QE6->QE6_UNAMO1	:= aDados[_nY][14]
			QE6->QE6_FATCO1	:= aDados[_nY][15]
			QE6->(MsUnLock())

			If !QE7->(DbSeek(xFilial("QE7")+aDados[_nY][1]+aDados[_nY][2]+aDados[_nY][3]))
				QE7->(RecLock("QE7",.T.))
			Else
				QE7->(RecLock("QE7",.F.))
			EndIf

			aDados[_nY][4] := PADL(AllTrim(aDados[_nY][2]),TamSx3("QE7_SEQLAB")[1],"0")

			QE7->QE7_PRODUT	:= aDados[_nY][1]
			QE7->QE7_REVI	:= aDados[_nY][2]
			QE7->QE7_ENSAIO	:= aDados[_nY][3]
			QE7->QE7_SEQLAB	:= aDados[_nY][4]
			QE7->QE7_XDESC	:= aDados[_nY][7]
			QE7->QE7_UNIMED	:= aDados[_nY][8]
			QE7->QE7_NOMINA	:= aDados[_nY][9]
			QE7->QE7_LSC	:= aDados[_nY][10]
			QE7->QE7_LIC	:= aDados[_nY][11]
			//QE7->QE7_AFS	:= aDados[_nY][12]
			//QE7->QE7_AFI	:= aDados[_nY][13]
			//QE7->QE7_TIPO6	:= aDados[_nY][16]
			//QE7->QE7_ENDDES	:= "2"
			QE7->QE7_LABOR	:= "LABFIS"
			QE7->QE7_MINMAX	:= "1"
			QE7->QE7_AM_INS	:= "1"
			QE7->(MsUnLock())

		EndIf

	Next

Return()
