#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STAPO010        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STAPO010()

	Private cArquivo := ""

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

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
	Local _lExecAuto := .F.
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

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

			_nPesBru := Val(StrTran(StrTran(aDados[_nY][16],".",""),",","."))

			aRotAuto:= {{'B1_COD' 		,aDados[_nY][1]					,Nil},;
			{'B1_XGATCL'   				,"AAA"   						,Nil},;
			{'B1_APROPRI'  				,"D"   						,Nil},;
			{'B1_CLAPROD'  				,AllTrim(aDados[_nY][2])   		,Nil},;
			{'B1_TIPO'   				,AllTrim(aDados[_nY][3])	   	,Nil},;
			{'B1_LOCPAD'   				,AllTrim(aDados[_nY][4])	   	,Nil},;
			{'B1_POSIPI'   				,AllTrim(aDados[_nY][6])		,Nil},;
			{'B1_EMAX'  				,Val(StrTran(StrTran(aDados[_nY][7],".",""),",","."))		,Nil},;
			{'B1_ESTSEG'	  			,Val(StrTran(StrTran(aDados[_nY][8],".",""),",","."))		,Nil},;
			{'B1_LE'		  			,Val(StrTran(StrTran(aDados[_nY][9],".",""),",","."))		,Nil},;
			{'B1_LM'		  			,Val(StrTran(StrTran(aDados[_nY][10],".",""),",","."))		,Nil},;
			{'B1_XABC'  				,AllTrim(aDados[_nY][11])		,Nil},;
			{'B1_XFMR'  				,AllTrim(aDados[_nY][12])		,Nil},;
			{'B1_XOFLOG'				,Val(StrTran(StrTran(aDados[_nY][13],".",""),",","."))		,Nil},;
			{'B1_QE'					,Val(StrTran(StrTran(aDados[_nY][14],".",""),",","."))		,Nil},;
			{'B1_GRUPO'	 				,AllTrim(aDados[_nY][15])		,Nil},;
			{'B1_PESBRU'				,Val(StrTran(StrTran(aDados[_nY][16],".",""),",","."))		,Nil},;
			{'B1_PESO'					,Val(StrTran(StrTran(aDados[_nY][17],".",""),",","."))		,Nil},;
			{'B1_UM'	 				,AllTrim(aDados[_nY][18])		,Nil},;
			{'B1_ORIGEM' 				,AllTrim(aDados[_nY][19])		,Nil},;
			{'B1_DESC' 					,SubStr(AllTrim(aDados[_nY][20]),1,50)		,Nil},;
			{'B1_XDESEXD'				,AllTrim(aDados[_nY][20])		,Nil},;
			{'B1_XCODSE'	 			,"S"							,Nil};
			}

			If SB1->(DbSeek(xFilial("SB1")+PADR(aDados[_nY][1],TamSx3("B1_COD")[1])))
				_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"OK"+";"+"Produto já existe."+CHR(13)+CHR(10)
				Loop
			EndIf

			_cProcs += StartJob("U_STAPO011",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,aRotAuto,_nY,aDados)+CHR(13)+CHR(10)

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
|Programa  | STAPO011        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STAPO011(cNewEmp,cNewFil,aRotAuto,_nY,aDados)

	Local _cRet := ""
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp,cNewFil,,,"FAT")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	MSExecAuto({|x,y| mata010(x,y)},aRotAuto,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		_cRet  := cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"ERRO"+";"+_cErro
	Else
		_cRet := cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"OK"+";"+"Produto incluído com sucesso"

		If SB1->(DbSeek(xFilial("SB1")+PADR(aDados[_nY][1],TamSx3("B1_COD")[1])))
			SB1->(RecLock("SB1",.F.))
			MSMM(SB1->B1_DESC_I,,,AllTrim(aDados[_nY][21]),1,,,"SB1", "B1_DESC_I",,.T.)
			SB1->(MsUnLock())
		EndIf
		
	EndIf

Return(_cRet)
