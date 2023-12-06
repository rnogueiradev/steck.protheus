#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP020        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP020()

	Private cArquivo := ""

	DbSelectArea("SG1")
	SG1->(DbSetOrder(1))

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
	Local _cProcs   := "Linha;Código;Status;Observação"+CHR(13)+CHR(10)
	Local _nY
	Local _lTemErro := .F.
	Private lMsErroAuto := .F.

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

	aGet 	:= {}
	_nProx := 0
	_nColC := 4

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		lMsErroAuto := .f.

		_lProcessa := .F.
		If Len(aDados)==_nY //ultimo registro
			_lProcessa := .T.
		ElseIf !AllTrim(aDados[_nY][1])==AllTrim(aDados[_nY+1][1])
			_lProcessa := .T.
		EndIf

		If !SB1->(DbSeek(xFilial("SB1")+aDados[_nY][1]))
			_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"ERRO"+";"+"Produto não existe."+CHR(13)+CHR(10)
			_lTemErro := .T.
		EndIf

		If AllTrim(SB1->B1_MSBLQL)=="1" //Bloqueado
			_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"ERRO"+";"+"Produto bloqueado."+CHR(13)+CHR(10)
			_lTemErro := .T.
		EndIf

		If !SB1->(DbSeek(xFilial("SB1")+aDados[_nY][2]))
			_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"ERRO"+";"+"Componente não existe."+CHR(13)+CHR(10)
			_lTemErro := .T.
		EndIf

		If AllTrim(SB1->B1_MSBLQL)=="1" //Bloqueado
			_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][2])+";"+"ERRO"+";"+"Componente bloqueado."+CHR(13)+CHR(10)
			_lTemErro := .T.
		EndIf

		aCabec := {{"G1_COD",AllTrim(aDados[_nY][1]),NIL},;
		{"G1_QUANT",1,NIL},;
		{"NIVALT","S",NIL}}

		aGets := {}
		aadd(aGets,{"G1_COD",AllTrim(aDados[_nY][1]),NIL})
		aadd(aGets,{"G1_COMP",AllTrim(aDados[_nY][2]),NIL})
		aadd(aGets,{"G1_TRT",AllTrim(aDados[_nY][5]),NIL})
		aadd(aGets,{"G1_QUANT",Val(aDados[_nY][3]),NIL})
		aadd(aGets,{"G1_PERDA",0,NIL})
		aadd(aGets,{"G1_NIV",PADL(AllTrim(aDados[_nY][4]),2,"0"),NIL})
		aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
		aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
		aadd(aGet,aGets)

		If _lProcessa
			If !_lTemErro
				If SG1->(DbSeek(xFilial("SG1")+PADR(AllTrim(aDados[_nY][1]),TamSx3("G1_COD")[1])))
					_cProcs += cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"OK"+";"+"Estrutura já inserida"+CHR(13)+CHR(10)
				Else
					_cProcs += StartJob("U_STIMP021",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,aCabec,aGet,aDados,_nY)
				EndIf
				aGet := {}
				aCabec := {}
			EndIf
			_lTemErro := .F.
		EndIf

	Next

	MakeDir("C:\Temp")
	_cArq :=  "estrut_"+DTOS(Date())+StrTran(Time(),":","")+".csv"
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

User Function STIMP021(cNewEmp,cNewFil,aCabec,aGet,aDados,_nY)

	Local _cRet := ""
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp,cNewFil,,,"FAT")

	MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,aGet,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		_cRet := cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"ERRO"+";"+_cErro+CHR(13)+CHR(10)
	Else
		_cRet := cValToChar(_nY)+";"+AllTrim(aDados[_nY][1])+";"+"OK"+";"+"Estrutura inserida"+CHR(13)+CHR(10)
	EndIf

Return(_cRet)
