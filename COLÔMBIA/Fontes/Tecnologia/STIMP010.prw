#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP010        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP010()

	Private cArquivo := ""

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

	DbSelectArea("SB9")
	SB9->(DbSetOrder(1)) //B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)

	DbSelectArea("SBK")
	SBK->(DbSetOrder(2)) //BK_FILIAL+BK_COD+BK_LOCAL+BK_LOTECTL+BK_LOCALIZ+BK_NUMSERI+DTOS(BK_DATA)

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		If _lExecAuto

			_cCod := PADR(AllTrim(aDados[_nY][1]),15)

			aRotAuto:= {{'B1_COD' 		,_cCod					,Nil},;
			{'B1_DESC'   				,aDados[_nY][2]  	,Nil},;
			{'B1_TIPO'   				,aDados[_nY][3]  	,Nil},;
			{'B1_UM'   				,aDados[_nY][4]  	,Nil},;
			{'B1_LOCPAD'   				,aDados[_nY][5]  	,Nil},;
			{'B1_TE'   				,aDados[_nY][6]  	,Nil},;
			{'B1_TS'   				,aDados[_nY][7]  	,Nil},;
			{'B1_CONTA'   				,aDados[_nY][8]  	,Nil},;
			{'B1_CC'   				,aDados[_nY][9]  	,Nil},;
			{'B1_UREV'   				,STOD(aDados[_nY][10])  	,Nil},;
			{'B1_DATREF'   				,STOD(aDados[_nY][11])  	,Nil},;
			{'B1_IMPORT'   				,aDados[_nY][12]  	,Nil},;
			{'B1_CFO'   				,aDados[_nY][13]  	,Nil},;
			{'B1_CFO2'   				,aDados[_nY][14]  	,Nil},;
			{'B1_CFO3'   				,aDados[_nY][15]  	,Nil},;
			{'B1_CFO4'   				,aDados[_nY][16]  	,Nil},;
			{'B1_TE2'   				,aDados[_nY][17]  	,Nil},;
			{'B1_TS2'   				,aDados[_nY][18]  	,Nil},;
			{'B1_XCONTAV'   				,aDados[_nY][19]  	,Nil},;
			{'B1_XCONTAC'   				,aDados[_nY][20]  	,Nil},;
			{'B1_XCONTAD'   				,aDados[_nY][21]  	,Nil},;
			{'B1_XCONCO'   				,aDados[_nY][22]  	,Nil},;
			{'B1_XCONCL'   				,aDados[_nY][23]  	,Nil},;
			{'B1_XCTADTO'   				,aDados[_nY][24]  	,Nil},;
			{'B1_XCNTAV2'   				,aDados[_nY][25]  	,Nil};
			}

			If SB1->(DbSeek(xFilial("SB1")+_cCod))
				_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"OK"+";"+"Produto já existe."+CHR(13)+CHR(10)
				//ATUALIZA(aRotAuto)
			Else
				_cProcs += StartJob("U_STIMP011",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,aRotAuto,_nY,aDados)+CHR(13)+CHR(10)
			EndIf

		Else

			MsgAlert("")

		EndIf

	Next

	MakeDir("C:\Temp")
	_cArq :=  "prod_"+DTOS(Date())+StrTran(Time(),":","")+".csv"
	If File("C:\Temp\"+_cArq)
		FErase("C:\Temp\"+_cArq)
	EndIf

	nHdlImp := FCreate("C:\Temp\"+_cArq)
	If nHdlImp <= 0
		MsgAlert("Falha na criação do arquivo")
		Return
	EndIf
	FWrite(nHdlImp,_cProcs)
	FClose(nHdlImp)
	
	MsgAlert("Arquivo criado com sucesso em "+"C:\Temp\"+_cArq)

Return()

/*====================================================================================\
|Programa  | STIMP011        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP011(cNewEmp,cNewFil,aRotAuto,_nY,aDados)

	Local _cRet := ""
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp,cNewFil,,,"FAT")

	MSExecAuto({|x,y| mata010(x,y)},aRotAuto,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		_cRet  := cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"ERRO"+";"+_cErro
	Else
		_cRet := cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"OK"+";"+"Produto incluído com sucesso"
	EndIf

Return(_cRet)

/*====================================================================================\
|Programa  | ATUALIZA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

Static Function ATUALIZA(aVetor)

	Local _nW
	Local _cCampo := ""

	SB1->(RecLock("SB1",.F.))

	For _nW:=1 To Len(aVetor)
		If !("B1_COD" $ AllTrim(aVetor[_nW][1]))
			SB1->&(aVetor[_nW][1]) := aVetor[_nW][2]
		EndIf
	Next

	SB1->(MsUnLock())

Return()
