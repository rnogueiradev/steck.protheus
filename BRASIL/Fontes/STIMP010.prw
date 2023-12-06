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

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

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

			_nPesBru := Val(StrTran(StrTran(aDados[_nY][18],".",""),",","."))
			_nPesLiq := Val(StrTran(StrTran(aDados[_nY][22],".",""),",","."))

			aRotAuto:= {{'B1_COD' 		,_cCod					,Nil},;
			{'B1_DESC'   				,SubStr(U_STTIRAGR(AllTrim(aDados[_nY][2])),1,50)   	,Nil},;
			{'B1_ORIGEM'   				,AllTrim(aDados[_nY][4])   	,Nil},;
			{'B1_XGATCL'   				,AllTrim(aDados[_nY][5])   	,Nil},;
			{'B1_APROPRI'  				,AllTrim(aDados[_nY][7])		,Nil},;
			{'B1_CLAPROD'  				,Substr(AllTrim(aDados[_nY][8]),1,1)		,Nil},;
			{'B1_UM'	  				,AllTrim(aDados[_nY][12])		,Nil},;
			{'B1_TIPO'	  				,AllTrim(aDados[_nY][13])		,Nil},;
			{'B1_GRUPO'	  				,AllTrim(aDados[_nY][16])		,Nil},;
			{'B1_LOCPAD'  				,AllTrim(aDados[_nY][17])		,Nil},;
			{'B1_XDESEXD' 				,U_STTIRAGR(AllTrim(aDados[_nY][3]))		,Nil},;
			{'B1_PESBRU' 				,_nPesBru		,Nil},;
			{'B1_PESO'	 				,_nPesLiq		,Nil},;
			{'B1_TIPOCQ' 				,AllTrim(aDados[_nY][31])		,Nil},;
			{'B1_XPAIS' 				,"9"		,Nil};
			}

			If SB1->(DbSeek(xFilial("SB1")+_cCod))
				_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"OK"+";"+"Produto já existe."+CHR(13)+CHR(10)
				ATUALIZA(aRotAuto)
			Else
				_cProcs += StartJob("U_STIMP011",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,aRotAuto,_nY,aDados)+CHR(13)+CHR(10)
			EndIf

			If SB1->(DbSeek(xFilial("SB1")+_cCod))
				SB1->(RecLock("SB1",.F.))
				SB1->B1_XDESEXD := U_STTIRAGR(AllTrim(aDados[_nY][3]))
				SB1->(MsUnLock())
			EndIf

			//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
			If !SB9->(DbSeek(xFilial("SB9")+_cCod+"04"+"20220331"))
				SB9->(RecLock("SB9",.T.))
				SB9->B9_FILIAL := xFilial("SB9")
				SB9->B9_COD    := _cCod
				SB9->B9_LOCAL  := "04"
				SB9->B9_DATA   := STOD("20220331")
				SB9->B9_QINI   := Val(aDados[_nY][33])
				SB9->B9_MCUSTD  := "1"
				SB9->B9_CM1 := 0.01
				SB9->(MsUnLock())
			EndIf

			//BK_FILIAL+BK_COD+BK_LOCAL+BK_LOTECTL+BK_LOCALIZ+BK_NUMSERI+DTOS(BK_DATA)
			If !SBK->(DbSeek(xFilial("SBK")+_cCod+"04"+"          "+"MANUT          "+"                    "+"20220331"))
				SBK->(RecLock("SBK",.T.))
				SBK->BK_FILIAL := xFilial("SBK")
				SBK->BK_COD := _cCod
				SBK->BK_LOCAL := "04"
				SBK->BK_DATA := STOD("20220331")
				SBK->BK_QINI := Val(aDados[_nY][33])
				SBK->BK_LOCALIZ := "MANUT"
				SBK->(MsUnLock())
			EndIf

		Else

			If !SB1->(DbSeek(xFilial("SB1")+aDados[_nY][1]))

				SB1->(RecLock("SB1",.T.))
				SB1->B1_COD := aDados[_nY][2]
				SB1->B1_DESC := AllTrim(aDados[_nY][300])
				SB1->B1_ORIGEM := AllTrim(aDados[_nY][160])
				SB1->B1_XGATCL := "AAA"
				SB1->B1_APROPRI := "D"
				SB1->B1_CLAPROD := AllTrim(aDados[_nY][3])
				SB1->B1_UM := AllTrim(aDados[_nY][43])
				SB1->B1_TIPO := "PA"
				SB1->B1_GRUPO := "40F"
				SB1->B1_LOCPAD := "03"
				SB1->B1_XDESEXD := AllTrim(aDados[_nY][300])
				SB1->B1_EMIN := Val(StrTran(StrTran(aDados[_nY][6],".",""),",","."))
				SB1->B1_EMAX := Val(StrTran(StrTran(aDados[_nY][8],".",""),",","."))
				SB1->B1_ESTSEG := Val(StrTran(StrTran(aDados[_nY][9],".",""),",","."))
				SB1->B1_LE := Val(StrTran(StrTran(aDados[_nY][10],".",""),",","."))
				SB1->B1_LM := Val(StrTran(StrTran(aDados[_nY][11],".",""),",","."))
				SB1->B1_XOFLOG := Val(StrTran(StrTran(aDados[_nY][14],".",""),",","."))
				SB1->B1_QE := Val(StrTran(StrTran(aDados[_nY][15],".",""),",","."))
				SB1->(MsUnLock())

				_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"OK"+";"+"Produto incluído com sucesso."+CHR(13)+CHR(10)

			Else

				SB1->(RecLock("SB1",.F.))
				SB1->B1_DESC := AllTrim(aDados[_nY][300])
				SB1->B1_ORIGEM := AllTrim(aDados[_nY][160])
				SB1->B1_XGATCL := "AAA"
				SB1->B1_APROPRI := "D"
				SB1->B1_CLAPROD := AllTrim(aDados[_nY][3])
				SB1->B1_UM := AllTrim(aDados[_nY][43])
				SB1->B1_TIPO := "PA"
				SB1->B1_GRUPO := "40F"
				SB1->B1_LOCPAD := "03"
				SB1->B1_XDESEXD := AllTrim(aDados[_nY][300])
				SB1->B1_EMIN := Val(StrTran(StrTran(aDados[_nY][6],".",""),",","."))
				SB1->B1_EMAX := Val(StrTran(StrTran(aDados[_nY][8],".",""),",","."))
				SB1->B1_ESTSEG := Val(StrTran(StrTran(aDados[_nY][9],".",""),",","."))
				SB1->B1_LE := Val(StrTran(StrTran(aDados[_nY][10],".",""),",","."))
				SB1->B1_LM := Val(StrTran(StrTran(aDados[_nY][11],".",""),",","."))
				SB1->B1_XOFLOG := Val(StrTran(StrTran(aDados[_nY][14],".",""),",","."))
				SB1->B1_QE := Val(StrTran(StrTran(aDados[_nY][15],".",""),",","."))
				SB1->(MsUnLock())

				_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"OK"+";"+"Produto já existe."+CHR(13)+CHR(10)

			EndIf

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
