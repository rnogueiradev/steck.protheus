#include "rwmake.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*====================================================================================\
|Programa  | STFIN010         | Autor | RENATO.OLIVEIRA          | Data | 27/09/2018  |
|=====================================================================================|
|Descrição | LER PLANILHA E FAZER BAIXAS AUTOMATICAMENTE                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFIN010()

	Local cArquivo 		:= ""
	Local aExcel		:= {}
	Local _nX			:= 0
	Local _cLog			:= ""
	Local aParamBox		:= {}
	Local _nTipo		:= 0
	Local _cTipo		:= ""
	Local aRet			:= {}
	Local aCampos		:= {}
	Local aExcel		:= {}
	Local lPrim    := .T.
	Private lMsErroAuto := .F.
	Private _cMotBx    := ""

	AADD(aParamBox,{3,"Tipo",,{"Baixa","Canc. Baixa"},70,"",.T.})

	If !ParamBox(aParamBox,"Tipo de baixa",@aRet,,,.T.,,500)
		Return
	EndIf

	If MV_PAR01==1
		_nTipo := 3
		_cTipo := "baixado"
	Else
		_nTipo := 5
		_cTipo := "cancelado"
	EndIf

	_cLog := "RESUMO DO PROCESSAMENTO"+CHR(13)+CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgAlert("Atenção, o arquivo não foi localizado!","Atenção")
		Return
	EndIf

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aExcel,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	//Processa({|| aExcel := OpenExcel(cArquivo,"Plan1"),"Processando ..."})

	For _nX:=2 To Len(aExcel)

		DbSelectArea("SE1")
		SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		SE1->(DbGoTop())
		If SE1->(DbSeek(xFilial("SE1")+PADL(AllTrim(aExcel[_nX][4]),6,"0")+PADL(AllTrim(aExcel[_nX][5]),2,"0")+PADL(AllTrim(aExcel[_nX][6]),3,"0")+PADL(AllTrim(aExcel[_nX][1]),9,"0")+PADL(AllTrim(aExcel[_nX][2]),3,"")))
           
		   If Val(StrTran(StrTran(aExcel[_nX][14],"."),",","."))>0
		   _cMotBx :="DES"
		   Else
           _cMotBx :="NOR"
		   Endif

			lMsErroAuto := .F.

			aBaixa := {{"E1_PREFIXO"  ,SE1->E1_PREFIXO                  ,Nil    },;
			{"E1_NUM"      ,SE1->E1_NUM            ,Nil    },;
			{"E1_PARCELA"  ,SE1->E1_PARCELA        ,Nil    },;
			{"E1_TIPO"     ,SE1->E1_TIPO           ,Nil    },;
			{"E1_CLIENTE"  ,SE1->E1_CLIENTE        ,Nil    },;
			{"E1_LOJA"     ,SE1->E1_LOJA           ,Nil    },;
			{"AUTBANCO"    ,aExcel[_nX][8]         ,Nil    },;
			{"AUTAGENCIA"  ,PADR(aExcel[_nX][9],5)         ,Nil    },;
			{"AUTCONTA"    ,PADR(aExcel[_nX][10],10)    	   ,Nil    },;
			{"AUTMOTBX"    ,_cMotBx                  ,Nil    },;
			{"AUTDTBAIXA"  ,CTOD(aExcel[_nX][11])  ,Nil    },;
			{"AUTDTCREDITO",CTOD(aExcel[_nX][12])  ,Nil    },;
			{"AUTHIST"     ,aExcel[_nX][13]	       ,Nil    },;
			{"AUTDESCONT"  ,Val(StrTran(StrTran(aExcel[_nX][14],"."),",","."))   ,Nil    },;
			{"AUTMULTA"  ,Val(StrTran(StrTran(aExcel[_nX][15],"."),",","."))   ,Nil    },;
			{"AUTJUROS"  ,Val(StrTran(StrTran(aExcel[_nX][16],"."),",","."))   ,Nil    };
			}

			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,_nTipo)

			If lMsErroAuto
				//MostraErro()
				_cLog += "Erro ao baixar título "+SE1->E1_NUM+" parcela "+SE1->E1_PARCELA+CHR(13) +CHR(10)
			Else
				_cLog += "Título "+SE1->E1_NUM+" parcela "+SE1->E1_PARCELA+" "+_cTipo+" com sucesso"+CHR(13) +CHR(10)
			Endif

		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return

/*====================================================================================\
|Programa  | OpenExcel        | Autor | Renato Nogueira            | Data | 28/10/2016|
|=====================================================================================|
|Descrição | Função utilizada para ler o arquivo xls                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico GrandCru                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function OpenExcel(cArquivo,_cWorksheet)

	Local _cBuffer    := ''          //variável de apoio a abertura da planilha em Excel
	//Local _cWorksheet := 'Plan1' //Informe a Worksheet (aba) do Excel que será lida pelo programa
	Local _aCabec     := {'Data','Descrição','Produto','Quant.','Valor'}//Informe a estrutura do cabeçalho da WorkSheet
	Local _aAuxCabec  := {}
	Local _aAuxExcel  := {'','','','','','','','','','','','','','','','',''}  //Manter a estrutura do cabeçalho
	Local _aExcel     := {}
	Local _cCelula    := 'A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q'     //
	Local _aCelula    := {}
	Local _nPosCabec  := 0
	Local _cMsgCabec  := ''
	Local _nLinha     := 0
	Local _nColuna    := 0
	Local _nLinCabec  := 2       //Informe a linha do cabeçalho
	Local _nLinFim    := 500  //Informe a linha final do arquivo a ser lido
	Local _aDados     := {}      //Array utilizado para adicionar as células da Workshhet
	Local _aAux       := {}	     //Array utilizado retorno da função
	Local _nVazio     := 0       //Informe a quantidade de linhas em branco que a rotina irá considerar na leitura
	Local _nTotVazio  := 0       //Variável para totalizar as linhas em branco da WorkSheet
	Local _cVazio     := ''      //Variável para armazenar o texto em branco da primeira célula da linha lida
	Local _nHdl       := 0
	Local _cPath      := '\DLLS\'//Informe o caminho do servidor onde está a Dll de leitura do arquivo em Excel
	Local _cDll       := 'readexcel.dll'
	Local _cTemp      := 'C:\TEMP\'
	Local _nA         := 0
	Local _nB         := 0
	Local _nC         := 0
	Local _lFim		  := .F.

	//+------------------------------------------------------------------------------+
	//| Tratamento para copiar a DLL do Servidor e salvar local na máquina do usuário|
	//+------------------------------------------------------------------------------+
	If ExistDir(_cPath)
		If Directory(_cPath+_cDll)[1][1] == Upper(_cDll)
			If !ExistDir(_cTemp)
				If MakeDir(_cTemp) == 0
					CpyS2T(_cPath+_cDll,_cTemp,.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
				Endif
			Else
				//IF !(Directory(_cTemp+_cDll)[1][1] == Upper(_cDll))
				CpyS2T(_cPath+_cDll,_cTemp,.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
				//Endif
			Endif
		Endif
	Endif

	//+------------------------------------------------------------------------------+
	//| Efetua a abertura da DLL de leitura de planilhas em Excel                    |
	//+------------------------------------------------------------------------------+
	_nHdl       := ExecInDLLOpen(_cTemp+_cDll)

	If (_nHdl >= 0)

		ProcRegua(0)
		//+------------------------------------------------------------------------------+
		//| Montagem das Celulas                                                         |
		//+------------------------------------------------------------------------------+
		_aCelula := STRTOKARR(_cCelula,"/")

		//+------------------------------------------------------------------------------+
		//| Carrega o Excel e abre a planilha                                            |
		//+------------------------------------------------------------------------------+
		_cBuffer := cArquivo + Space(512)
		nBytes   := ExeDLLRun2(_nHdl, CMD_OPENWORKBOOK, @_cBuffer)

		If (nBytes < 0)
			//+------------------------------------------------------------------------------+
			//| Erro critico na abertura do arquivo sem mensagem de erro                     |
			//+------------------------------------------------------------------------------+
			MsgStop('Não foi possível abrir o arquivo : ' + cFile)
			Return(_aAux)
		ElseIf (nBytes > 0)
			//+------------------------------------------------------------------------------+
			//| Erro critico na abertura do arquivo com mensagem de erro                     |
			//+------------------------------------------------------------------------------+
			MsgStop(Subs(_cBuffer, 1, nBytes))
			ExeDLLRun2(_nHdl, CMD_CLOSEWORKBOOK, @_cBuffer)
			ExecInDLLClose(_nHdl)
			Return(_aAux)
		EndIf

		//+------------------------------------------------------------------------------+
		//| Leitura da WorkSheet da planilha em Excel                                    |
		//+------------------------------------------------------------------------------+
		_cBuffer := _cWorksheet
		ExeDLLRun2(_nHdl, CMD_ACTIVEWORKSHEET, @_cBuffer)

		_cForn	:= ReadCell(_nHdl,"C",8)

		For _nLinha := _nLinCabec To _nLinFim

			IncProc("Não feche a planilha! Lendo Linha: "+StrZero(_nLinha,Len(cvaltochar(_nLinFim))))
			_aExcel := aclone(_aAuxExcel)
			For _nColuna := 1 To Len(_aCelula)
				//If !Empty(ReadCell(_nHdl,"A",_nLinha))
				_cDados := ReadCell(_nHdl,_aCelula[_nColuna],_nLinha)
				_aExcel[_nColuna] := _cDados

				If _nColuna==1 .And. Empty(_cDados) //Não tem mais títulos
					_lFim := .T.
					Exit
				EndIf

			Next _nColuna

			If _lFim
				Exit
			EndIf

			AADD(_aExcel,'')
			AADD(_aDados,_aExcel)

		Next _nLinha

		//+------------------------------------------------------------------------------+
		//| Fecha o arquivo e remove o excel da memória                                  |
		//+------------------------------------------------------------------------------+
		_cWorksheet := Space(512)
		ExeDLLRun2(_nHdl, CMD_CLOSEWORKBOOK, @_cWorksheet)
		ExecInDLLClose(_nHdl)
		If Len(_aDados) > 0
			//MsgInfo('Realizada a leitura de '+Alltrim(STR(Len(_aDados)))+' linhas da planilha '+cArquivo+' selecionada.')
			Return(_aDados)
		Else
			MsgInfo('Processo finalizado sem registro(s) gravado(s).')
			Return(_aAux)
		EndIf
	Else
		MsgStop('Nao foi possivel carregar a DLL')
		Return(_aAux)
	EndIf

Return

/*====================================================================================\
|Programa  | ReadCell         | Autor | Renato Nogueira            | Data | 28/10/2016|
|=====================================================================================|
|Descrição | Função utilizada para ler célula		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico GrandCru                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReadCell(_nArq,_nCol,_nLinha)

	Local _cConteudo := ''
	Local _cBufferPl := ''
	Local _cCelula	 :=''

	//+------------------------------------------------------------------------------+
	//| Efetua a leitura da célula                                                   |
	//+------------------------------------------------------------------------------+
	_cCelula    := _nCol+Alltrim(str(_nLinha))
	_cBufferPl  := _cCelula + Space(1024)
	_nBytesPl   := ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
	_cConteudo  := Subs(_cBufferPl, 1, _nBytesPl)
	_cConteudo  := Alltrim(_cConteudo)

Return (_cConteudo)
