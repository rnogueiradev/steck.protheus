#INCLUDE "TOTVS.CH"


#DEFINE VALMERC 	1  // Valor total do mercadoria
#DEFINE VALDESC 	2  // Valor total do desconto
#DEFINE VALIPI  	3  // Valor total do IPI
#DEFINE VALICM  	4  // Valor total do ICMS
#DEFINE FRETE   	5  // Valor total do Frete
#DEFINE VALDESP 	6  // Valor total da despesa
#DEFINE TOTF1		7  // Total de Despesas Folder 1
#DEFINE TOTPED		8  // Total do Pedido
#DEFINE BASEIPI 	9  // Base de IPI
#DEFINE BASEICM    10 // Base de ICMS
#DEFINE BASESOL    11 // Base do ICMS Sol.
#DEFINE VALSOL		12 // Valor do ICMS Sol.
#DEFINE VALCOMP 	13 // Valor do ICMS Com.
#DEFINE SEGURO		14 // Valor total do seguro
#DEFINE TOTF3		15 // Total utilizado no Folder 3

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*====================================================================================\
|Programa  | MA150BUT        | Autor | RENATO.OLIVEIRA           | Data | 04/12/2018  |
|=====================================================================================|
|Descrição | PE PARA ADICIONAR BOTOES                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MA150BUT()

	Local aButtons := {}

	AADD(aButtons,{"S4WB005N" ,{|| STUPSC8() },"Carregar planilha","Carregar planilha"})

Return(aButtons)

/*====================================================================================\
|Programa  | STUPSC8         | Autor | RENATO.OLIVEIRA           | Data | 04/12/2018  |
|=====================================================================================|
|Descrição | SUBIR PLANILHA                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STUPSC8()

	Local aExcel 	:= {}
	Local cArquivo  := ""
	Local _nPosProd	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_PRODUTO"})
	Local _nPosPr1  := aScan(aHeader,{|x|AllTrim(x[2])=="C8_PRECO"})
	Local _nPosPDe  := aScan(aHeader,{|x|AllTrim(x[2])=="C8_DESC"})
	Local _nPosVDe  := aScan(aHeader,{|x|AllTrim(x[2])=="C8_VLDESC"})
	Local _nPosPIpi := aScan(aHeader,{|x|AllTrim(x[2])=="C8_ALIIPI"})
	Local _nPosPrz  := aScan(aHeader,{|x|AllTrim(x[2])=="C8_PRAZO"})
	Local _nPosObs	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_OBS"})
	Local _nPosVld	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_VALIDA"})
	Local _nPosDtP	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_DATPRF"})
	Local _nPosDesp	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_DESPESA"})
	Local _nPosSeg	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_SEGURO"})
	Local _nPosVlF	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_VALFRE"})
	//Local _nPosTpF	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_TPFRETE"})
	Local _nPosPr2	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_XVL2UM"})
	Local _nPosPTx	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_XTAXA"})
	Local _nPosPIcm	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_PICM"})
	Local _nPosTot	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_TOTAL"})
	Local _nPosQt1	:= aScan(aHeader,{|x|AllTrim(x[2])=="C8_QUANT"})
	Local _nX 
	Local _nY
	Local aDados   := {}
	Local aCampos  := {}
	Local lPrim	   := .T.

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgAlert("Atenção, o arquivo não foi localizado!")
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
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	_nBkp := n

	//For _nX:=2 To Len(aExcel)
		For _nY:=1 To Len(aDados)

			n := _nY

			If AllTrim(aDados[_nX][1])==AllTrim(aCols[_nY][_nPosProd])

				aCols[_nY][_nPosPr1] := Val(StrTran(aDados[_nX][2],",","."))
				aCols[_nY][_nPosTot] := aCols[_nY][_nPosPr1]*aCols[_nY][_nPosQt1]

				RunTrigger(2,n,Nil,,"C8_PRECO")

				aCols[_nY][_nPosPDe] := Val(StrTran(aDados[_nX][3],",","."))
				aCols[_nY][_nPosVDe] := NoRound(aCols[_nY][_nPosTot]*aCols[_nY][_nPosPDe]/100,TamSx3("C8_VLDESC")[2])

				//aCols[_nY][_nPosVDe] := NoRound(aCols[_nY][_nPosTot]*aCols[_nY][_nPosPDe]/100,TamSx3("C8_VLDESC")[2])
				//aCols[_nY][_nPosVDe] := If(A150Trigger("C8_VLDESC"),aCols[_nY][_nPosVDe],0)

				a150Var[VALDESC] := aCols[_nY][_nPosVDe]

				aCols[_nY][_nPosPIpi] := Val(StrTran(aDados[_nX][4],",","."))
				aCols[_nY][_nPosPrz] := Val(StrTran(aDados[_nX][5],",","."))
				aCols[_nY][_nPosObs] := aDados[_nX][6]
				aCols[_nY][_nPosVld] := CTOD(aDados[_nX][7])
				aCols[_nY][_nPosDtP] := CTOD(aDados[_nX][8])
				aCols[_nY][_nPosDesp] := Val(StrTran(aDados[_nX][9],",","."))
				aCols[_nY][_nPosSeg] := Val(StrTran(aDados[_nX][10],",","."))
				aCols[_nY][_nPosVlF] := Val(StrTran(aDados[_nX][11],",","."))
				aCols[_nY][_nPosPr2] := Val(StrTran(aDados[_nX][12],",","."))
				aCols[_nY][_nPosPTx] := Val(StrTran(aDados[_nX][13],",","."))
				aCols[_nY][_nPosPIcm] := Val(StrTran(aDados[_nX][14],",","."))

				Exit
			EndIf
		Next
	//Next

	n := _nBkp

	Eval(bRefresh)
	Eval(bGDRefresh)

Return()

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
	Local _aCabec     := {}//Informe a estrutura do cabeçalho da WorkSheet
	Local _aAuxCabec  := {}
	Local _aAuxExcel  := {'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''}  //Manter a estrutura do cabeçalho
	Local _aExcel     := {}
	Local _cCelula    := 'A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z/AA/AB/AC/AD/AE/AF/AG/AH/AI/AJ'     //
	Local _aCelula    := {}
	Local _nPosCabec  := 0
	Local _cMsgCabec  := ''
	Local _nLinha     := 0
	Local _nColuna    := 0
	Local _nLinCabec  := 1       //Informe a linha do cabeçalho
	Local _nLinFim    := 230  //Informe a linha final do arquivo a ser lido
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

		_lFim := .F.

		For _nLinha := _nLinCabec To _nLinFim

			IncProc("Não feche a planilha! Lendo Linha: "+StrZero(_nLinha,Len(cvaltochar(_nLinFim))))
			_aExcel := aclone(_aAuxExcel)
			For _nColuna := 1 To Len(_aCelula)
				//If !Empty(ReadCell(_nHdl,"A",_nLinha))
				_cDados := ReadCell(_nHdl,_aCelula[_nColuna],_nLinha)
				_aExcel[_nColuna] := _cDados
				//EndIf

				If _nColuna==1 .And. Empty(_cDados)
					_lFim := .T.
					Exit
				EndIf

			Next _nColuna

			If _lFim
				Exit
			EndIf

			AADD(_aExcel,'')
			AADD(_aDados,_aExcel)

			//+------------------------------------------------------------------------------+
			//| Validação do cabeçalho da planilha com o definido no programa                |
			//+------------------------------------------------------------------------------+
			/*
			If _nLinha = _nLinCabec
			For _nA := 1 to Len(_aCabec)
			_cMsgCabec += _aCabec[_nA]+'|'
			Next _nA
			_cMsgCabec := SUBSTR(_cMsgCabec, 1                      ,RAT( "|"   , _cMsgCabec )-1)
			For _nB := 1 to Len(_aExcel)
			_nPosCabec := Ascan(_aCabec, {|x|UPPER(AllTrim(x)) == UPPER(AllTrim(_aExcel[_nB]))})
			If _nPosCabec = 0
			MsgAlert("Divergência no Cabeçalho da Planilha: "+_cMsgCabec)
			Return(_aAux)
			Else
			AADD(_aAuxCabec,_aCabec[_nPosCabec])
			EndIf
			Next _nB
			//+------------------------------------------------------------------------------+
			//| Validação da ordem do cabeçalho da planilha com o definido no programa       |
			//+------------------------------------------------------------------------------+
			For _nC := 1 to Len(_aCabec)
			If !(_aCabec[_nC] == _aAuxCabec[_nC])
			MsgAlert("Divergência no Cabeçalho da Planilha: "+_cMsgCabec)
			Return(_aAux)
			Endif
			Next _nC
			AADD(_aDados,_aCabec)
			//+------------------------------------------------------------------------------+
			//| Preenchimento dos itens da planilha                                          |
			//+------------------------------------------------------------------------------+
			ElseIf !Empty(_aExcel[1])
			AADD(_aExcel,'')
			AADD(_aDados,_aExcel)
			//+------------------------------------------------------------------------------+
			//| validação para leituras de linhas em branco na WorkSheet                     |
			//+------------------------------------------------------------------------------+
			Else
			If _cVazio = _aExcel[1]
			_nTotVazio++
			Else
			_nTotVazio := 1
			EndIf
			EndIf

			_cVazio := _aExcel[1]
			If _nTotVazio > _nVazio
			Exit
			EndIf
			*/
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
