#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*====================================================================================\
|Programa  | ARCOM010        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA INSERIR PEDIDO DE COMPRA	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User function ARCPEDCOMP()
    Default cFilEmp    := ''
	Default cEmpresa   := ''
	default cMessageError := ''
    Processa({|| u_ARCOM010()}, "Lendo TXT....")

Return
User Function ARCOM010()

	Local _aCabec 	:= {}
	Local _aItens 	:= {}
	Local _aItem  	:= {}
    Local dEmisPedCom:= ''
    Local cChvCabec := ''
    Local lRetPrxPed:= .T.
    Local nAtual := 0
    Local cError := ""
    cArqErro:= "cIdProc"+StrTran(Time(),':','_')+'.log'
    Local _nX := 0
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv("07","01",,,"COM")

	_cLog := "RESUMO DO PROCESSAMENTO"+CHR(13)+CHR(10)

    aRPedCom := U_GerArrCSV()

	//cArquivo := cGetFile("Arquivos XLS (*.XLS) |*.XLS*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	//cArquivo := AllTrim(cArquivo)

	//cArquivo := "C:\Arquivos\pc_arg.xlsx"

	
		//Processa({|| aExcel := OpenExcel(cArquivo,CVALTOCHAR(_nY)),"Processando ..."})

		If Len(aRPedCom)=0
			MsgAlert('Não foi possível importar o arquivo!')
			Return
		EndIf
        /*
		_cQuery1 := " SELECT COUNT(*) CONTADOR
		_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_OBS='"+AllTrim(aExcel[2][8])+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->CONTADOR>0
			_cLog += "Aba "+CVALTOCHAR(_nY)+" já existe na base"+CHR(13) +CHR(10)
			Loop
		EndIf
        */
		DbSelectArea("SC7")

		_nMoeda := 0
		_aCabec := {}
		_aItens := {}
        /*
		If UPPER(AllTrim(aExcel[1][3]))=="USD"
			_nMoeda := 2
		ElseIf UPPER(AllTrim(aExcel[1][3]))=="EURO"
			_nMoeda := 4
		EndIf
        */
        //Grava a primeira linha e salva o cabecalho
        ProcRegua(Len(aRPedCom))
        dEmisPedCom:=    U_TRATACAMPO(aRPedCom[1][1],"D")
        cChvCabec:= AllTrim(dToc(dEmisPedCom)+aRPedCom[1][2]+aRPedCom[1][3]+aRPedCom[1][4]+aRPedCom[1][5])
		For _nX:=1 To Len(aRPedCom)
            nAtual++
        	IncProc("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(Len(aRPedCom)) + "...")
            dEmisPedCom:=    U_TRATACAMPO(aRPedCom[_nX][1],"D")
            If cChvCabec == AllTrim(dToc(dEmisPedCom)+aRPedCom[_nX][2]+aRPedCom[_nX][3]+aRPedCom[_nX][4]+aRPedCom[_nX][5])
                If Len(_aCabec)== 0
                    _cNumPc := GetNumSC7()                                                                                                                     //GetSXENum("SC7","C7_NUM")
				    _aCabec:=   {{"C7_NUM"            ,_cNumPc 			,nil},;
			            	{"C7_EMISSAO"                   ,dEmisPedCom		,nil},;
				            {"C7_FORNECE"                   ,aRPedCom[_nX][2]		,nil},;
				            {"C7_LOJA"                      ,aRPedCom[_nX][3]   		,nil},;
				            {"C7_COND"                   	,aRPedCom[_nX][4]		,nil}}
				            //{"C7_MOEDA"                   	,aRPedCom[_nX][5]		,nil}}  
                            _aItem := {}             
                Endif
                If Len(_aItem) == 0
                    _cItem  := "0000"
                Endif    	
		
				_cItem 		:= Soma1(_cItem)
				_dDtPrev	:= U_TRATACAMPO(aRPedCom[_nX][10],"D")
 
				_aItem :=   {	{"C7_ITEM"   		,_cItem    				,nil},;
				                {"C7_PRODUTO"		,aRPedCom[_nX][6]       ,nil},;    
								{"C7_TES"		    ,aRPedCom[_nX][12]       ,nil},; 
				                {"C7_QUANT" 		,Val(StrTran(aRPedCom[_nX][7],",",".")) ,nil},;
				                {"C7_PRECO" 		,Val(StrTran(aRPedCom[_nX][8],",",".")) ,nil},;
				                {"C7_OBS" 			,AllTrim(aRPedCom[_nX][9])   	        ,nil},; 
                                {"C7_MOEDA"         ,aRPedCom[_nX][5]			,nil},;
				                {"C7_DATPRF" 		,_dDtPrev		    ,nil},;
				                {"C7_PROVENT"       ,"EX" 			   	,nil}}  

				                aadd(_aItens,_aItem)  
                                cChvCabec := AllTrim(dToc(dEmisPedCom)+aRPedCom[_nX][2]+aRPedCom[_nX][3]+aRPedCom[_nX][4]+aRPedCom[_nX][5])  
            Else
                lRetPrxPed := .T.
                lMsErroAuto := .F.                    
		        MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCabec,_aItens,3)
                _aCabec 	:= {}
                _aItem      := {}
                _aItens     := {}
		        If lMsErroAuto
			        lErro := .T.
			        //MostraErro()
			        SC7->(RollBackSX8())
                    If file(GetSrvProfString("Startpath","")+cArqErro)
				        Ferase(GetSrvProfString("Startpath","")+cArqErro)
			        EndIf	
		
			        MostraErro( GetSrvProfString("Startpath","") , cArqErro )
			        cError := MemoRead(  GetSrvProfString("Startpath","") + '\' + cArqErro )
			        _cLog += "Linha;"+CVALTOCHAR(_nX-1)+";não inserida;"+cError+CHR(13) +CHR(10)
		        Else
			        SC7->(ConfirmSX8())
			        _cLog += "Linha; "+CVALTOCHAR(_nX-1)+";inserido com sucesso;Pedido;"+_cNumPc+";"+CHR(13) +CHR(10)
		        EndIf
                    _cNumPc :=  GetNumSC7()
				    _aCabec:=   {{"C7_NUM"            ,_cNumPc 			,nil},;
			            	{"C7_EMISSAO"                   ,dEmisPedCom		,nil},;
				            {"C7_FORNECE"                   ,aRPedCom[_nX][2]		,nil},;
				            {"C7_LOJA"                      ,aRPedCom[_nX][3]   		,nil},;
				            {"C7_COND"                   	,aRPedCom[_nX][4]		,nil}}
				            //{"C7_MOEDA"                   	,aRPedCom[_nX][5]		,nil}}  
                            _aItem := {}
                    If Len(_aItem) == 0
                        _cItem  := "0000"
                    Endif    	
		
                    _cItem 		:= Soma1(_cItem)
                    _dDtPrev	:= U_TRATACAMPO(aRPedCom[_nX][10],"D")
    
                    _aItem :=   {	{"C7_ITEM"   		,_cItem    				,nil},;
                                    {"C7_PRODUTO"		,aRPedCom[_nX][6]       ,nil},; 
									{"C7_TES"		    ,aRPedCom[_nX][12]       ,nil},;    
                                    {"C7_QUANT" 		,Val(StrTran(aRPedCom[_nX][7],",",".")) ,nil},;
                                    {"C7_PRECO" 		,Val(StrTran(aRPedCom[_nX][8],",",".")) ,nil},;
                                    {"C7_OBS" 			,AllTrim(aRPedCom[_nX][9])   	        ,nil},; 
                                    {"C7_MOEDA"         ,aRPedCom[_nX][5]			,nil},;
                                    {"C7_DATPRF" 		,_dDtPrev		    ,nil},;
                                    {"C7_PROVENT"       ,"EX" 			   	,nil}}  

                    aadd(_aItens,_aItem)  
                    cChvCabec := AllTrim(dToc(dEmisPedCom)+aRPedCom[_nX][2]+aRPedCom[_nX][3]+aRPedCom[_nX][4]+aRPedCom[_nX][5])            
            Endif
                
		Next             
        lRetPrxPed := .T.
        lMsErroAuto := .F.                    
		MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCabec,_aItens,3)
        _aCabec 	:= {}
        _aItem      := {}
        _aItens     := {}
		If lMsErroAuto
			        lErro := .T.
			        //MostraErro()
			        SC7->(RollBackSX8())
                    If file(GetSrvProfString("Startpath","")+cArqErro)
				        Ferase(GetSrvProfString("Startpath","")+cArqErro)
			        EndIf	
		
			        MostraErro( GetSrvProfString("Startpath","") , cArqErro )
			        cError := MemoRead(  GetSrvProfString("Startpath","") + '\' + cArqErro )
			        _cLog += "Linha;"+CVALTOCHAR(_nX-1)+";não inserida;"+cError+CHR(13) +CHR(10)
		        Else
			        SC7->(ConfirmSX8())
			        _cLog += "Linha; "+CVALTOCHAR(_nX-1)+";inserido com sucesso;Pedido;"+_cNumPc+";"+CHR(13) +CHR(10)
		        EndIf
                MemoWrite("c:\log\"+cArqErro, _cLog) 
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

	Local _aAuxCabec  := {}
	Local _aAuxExcel  := {'','','','','','','','','','',''}  //Manter a estrutura do cabeçalho
	Local _aExcel     := {}
	Local _cCelula    := 'A/B/C/D/E/F/G/H/I/J/K'     //
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

		For _nLinha := _nLinCabec To _nLinFim

			IncProc("Não feche a planilha! Lendo Linha: "+StrZero(_nLinha,Len(cvaltochar(_nLinFim))))
			_aExcel := aclone(_aAuxExcel)
			For _nColuna := 1 To Len(_aCelula)
				//If !Empty(ReadCell(_nHdl,"A",_nLinha))
				_cDados := ReadCell(_nHdl,_aCelula[_nColuna],_nLinha)
				_aExcel[_nColuna] := _cDados
				//EndIf
			Next _nColuna

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
User Function GerArrCSV()

Local 	cLinha		:= ""
Local	aItens		:={}
Local	aCampos	:={}
Local nTotal := 0
	
cfOpen:=cGetFile("Arquivos Csv (MS DOS)|*.*",OemToAnsi("Abrir Arquivo para Importacao..."),0,GetSrvProfString("c:\",""),.T.)

if !Empty(cFOpen)
		//Alert(" Arquivo Encontrado ! ")
		FT_Fuse(cfOpen)
		While !FT_FEOF()
            //Alert(" Passou Aqui 1 ! ")
			cLinha  := FT_FReadLn() // Retorna a linha corrente
            If (";;;;" $ cLinha)
				EXIT
			Endif	
			If  Empty(aCampos)
                //Alert(" Passou Aqui 2 ! ")
				aCampos := &("{'"+StrTran(cLinha,";","','")+"'}")
			Else
                //Alert(" Passou Aqui 2 ! ")
				aAdd(aItens,&("{'"+StrTran(cLinha,";","','")+"'}"))
			Endif
			FT_FSkip()
		End		
		FT_FUse()
		nTotal := Len(aItens)
       // ProcRegua(nTotal)
Endif        
Return aItens
User Function TrataCampo(xCampo,xTpType,lRetCmp,cTamCmp)
						
	Local  aArea                  := GetArea()
	Local cRet
	Local lRetCmp 				  := .F.
	If upper(xCampo) == ".T." .or. upper(xCampo) == ".F." 
		xTpType := "L"
	Endif
	Do Case
		Case xTpType == "L" 	
				If upper(xCampo) == ".T."
					cRet := .T.
				ELSE
					cRet := .F.
				ENDIF	
		Case xTpType == ValType(xCampo)//regra para campo logico
				cRet := xCampo
				If ValType(cRet) == "C"
				    lRetCmp := LEN(cRet) <= cTamCmp
				Else
					lRetCmp := .T.
				Endif
		Case xTpType == "N" .And. ValType(xCampo) == "C"
			//xCampo := StrTran(xCampo,".","")
			xCampo := StrTran(xCampo,",",".")
			lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO 
			cRet := Val(xCampo)
		
		Case xTpType == "C" .And. ValType(xCampo) == "N"
			cRet := AllTrim(Str(xCampo))
			lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO
		
		Case xTpType == "C" .And. ValType(xCampo) == "D"
			cRet := DtoC(xCampo)
		    lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO
			
		Case xTpType = "D" .And. ValType(xCampo) == "C"
			lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO
			cRet :=CtoD(xCampo)
		
		If Empty(cRet)
			cRet := StoD(xCampo)
		EndIf
		
		Case xTpType == "M"
			//cRet := xGrava
			cRet := xCampo
	EndCase
RestArea(aArea)
RETURN(cRET)
