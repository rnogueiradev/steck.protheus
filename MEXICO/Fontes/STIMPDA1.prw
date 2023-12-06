#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMPDA1        | Autor | RENATO.OLIVEIRA           | Data | 29/02/2020  |
|=====================================================================================|
|Descrição | Atualiza tabela DA1 - Preços mediante leitura de arquivo CSV             |
|          | na ordem das colunas do arquivo                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPDA1()
Local _cLog    := ""
Local cArquivo := ""
//Local cDir     := ""		
	
	_cLog:= "IMPORTAÇÃO TABELA PREÇO "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  //d:\temp\steck\teste_politica_preco.csv		
		MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[STIMPDA1] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Tabela Preço, aguarde...",, {|| fAtuDA1(cArquivo)} )		
	EndIf

	

Return

/************************************/
Static Function fAtuDA1(cArquivo)
/************************************/
Local cLinha  := ""
Local cItem   := ""
Local oDlg
Local cTabela := GetNewPar("ST_TPRCTMK",'001')
Local i       := 0
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local _cLog   := ""
Local _cQuery := ""
Local _cAlias := GetNextAlias()

	

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()           // lendo a linha
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))

	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	
	_nQtd := 0

	For i:=1 to Len(aDados)  //ler linhas da array
	
	conout(i)

	cTabela := aDados[i,1]	
	
	_cCod := AllTrim(aDados[i,2])
	//_cCod := PADR(_cCod,15)

	_cQuery := " SELECT DA1.R_E_C_N_O_ RECDA1
	_cQuery += " FROM "+RetSqlName("DA1")+" DA1
	_cQuery += " WHERE DA1.D_E_L_E_T_=' ' AND DA1_CODTAB='"+cTabela+"' AND DA1_CODPRO='"+_cCod+"'

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	_lAchou := .F.

	If (_cAlias)->(!Eof())
		DA1->(DbGoTo((_cAlias)->RECDA1))
		If DA1->(!Eof())
			DA1->(RecLock("DA1",.F.))
			DA1->DA1_PRCVEN := Val(StrTran(StrTran(aDados[i,3],".",""),",","."))
			DA1->(MsUnLock())
			_lAchou := .T.
		EndIf
	EndIf

	If !_lAchou
		cItem := fProxDA1(cTabela)
		DA1->(RecLock("DA1",.T.))
		DA1->DA1_ITEM 	:= cItem //"000"
		DA1->DA1_CODTAB := cTabela //"T02"
		DA1->DA1_CODPRO := _cCod
		DA1->DA1_PRCVEN := Val(StrTran(StrTran(aDados[i,3],".",""),",","."))
		DA1->DA1_ATIVO  := "1"
		DA1->DA1_TPOPER := "4"
		DA1->DA1_QTDLOT := 999999.00
		DA1->DA1_INDLOT := "000000000999999.99"
		DA1->DA1_MOEDA  := 1
		DA1->DA1_DATVIG := CTOD("01/01/2000")
		DA1->(MsUnLock())
	EndIf
	
	Next
	
	FT_FUSE()

	_cLog := "Processo Finalizado, OK"
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	MsgInfo("Processo Finalizado, OK")

Return


//==================================================================================//
//Função  : fProxDA1  
//Autoria : Flávia Rocha
//Data    : 28/10/2021
//Objetivo: Função para trazer o próximo item da tabela DA1
//==================================================================================//
Static Function fProxDA1(cTabela)
Local cQuery := ""
Local cCodRet:= ""

cQuery := " SELECT MAX(DA1_ITEM) CODIGO
cQuery += " FROM " + RetSqlname("DA1") + " DA1 "
cQuery += " WHERE DA1.D_E_L_E_T_=' '  "
cQuery += " AND DA1_CODTAB = '" + cTabela + "' "

//cQuery += " GROUP BY A2_COD "
//cQuery += " ORDER BY A2_COD DESC "

MemoWrite("D:\QUERY\PROXDA1.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	
	cCodRet := XF3TAB->CODIGO
	cCodRet := SOMA1(cCodRet)
	
Endif

If Empty(cCodRet)
	cCodRet := "0001" 	 
Endif 

DA1->(OrdSetFocus(3))
While DA1->( DbSeek( xFilial( "DA1" ) + cTabela + cCodRet ) )
   ConfirmSX8()   
   cCodRet := SOMA1(cCodRet)
Enddo

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(cCodRet)

/*====================================================================================\
|Programa  | STIMPSB1        | Autor | FLÁVIA ROCHA              | Data | 29/12/2021  |
|=====================================================================================|
|Descrição |Função para gravar no campo B1_XCATEG as categorias, do arquivo csv       |
|          |na ordem das colunas do arquivo                                           |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPB1()
Local _cLog    := ""
Local cArquivo := ""
	
	_cLog:= "IMPORTAÇÃO CATEGORIAS PRODUTO "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  //d:\temp\steck\teste_politica_preco.csv
	
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[STIMPDA1] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Produtos (SB1), aguarde...",, {|| fAtuSB1(cArquivo)} )		
	EndIf

	
Return

/************************************/
Static Function fAtuSB1(cArquivo)
/************************************/
Local cLinha  := ""
Local oDlg
Local i       := 0
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local _cLog   := ""
Local _cCod   := ""
Local _cCateg := ""

	

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()           // lendo a linha
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	
	_nQtd := 0

	For i:=1 to Len(aDados)  //ler linhas da array
	
	conout(i)
	
	_cCod := aDados[i,1]	
	_cCod := PADR(_cCod,15)
	_cCateg := Alltrim(aDados[i,2])
	If Len(aDados[i]) >= 3		//verificar se há 2 colunas (codigo produto, categoria 1) ou 3 (codigo produto, categoria 1, categoria 2)
		_cCateg2:= Alltrim(aDados[i,3])
	Endif 
		
	If SB1->(DbSeek(xFilial("SB1")+ _cCod))
		SB1->(RecLock("SB1",.F.))
		SB1->B1_XCATEG := _cCateg 
		SB1->B1_XCATEG2:= _cCateg2 
		SB1->(MsUnLock())	
	EndIf
	
	Next
	
	FT_FUSE()

	_cLog := "Processo Finalizado, OK"
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	MsgInfo("Processo Finalizado, OK")

Return


/*====================================================================================\
|Programa  | STIMPSA1        | Autor | FLÁVIA ROCHA              | Data | 29/12/2021  |
|=====================================================================================|
|Descrição | Atualiza tabela SA1 - Campo A1_XESCALA - classificação cliente           |
|          | na ordem das colunas do arquivo                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPA1()
Local _cLog    := ""
Local cArquivo := ""
	
		
	_cLog:= "IMPORTAÇÃO CLASSIFICAÇÕES CLIENTES (PLATINUM, OURO, PRATA, BRONZE) "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  //d:\temp\steck\teste_politica_preco.csv
	
		MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[STIMPDA1] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Clientes por CNPJ (SA1), aguarde...",, {|| fAtuSA1(cArquivo)} )		
	EndIf

	//Reset Environment

Return

/************************************/
Static Function fAtuSA1(cArquivo)
/************************************/
Local cLinha  	:= ""
Local oDlg
Local i       	:= 0
Local lPrim   	:= .T.
Local aCampos 	:= {}
Local aDados  	:= {}
Local _cLog   	:= ""
Local _cCod   	:= ""
Local _cCateg 	:= ""
Local _cDescateg:= ""
	

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()           // lendo a linha
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	
	
	For i:=1 to Len(aDados)  //ler linhas da array
	
	conout(i)
	
	_cCod 		:= Alltrim(aDados[i,1])  		//cnpj	
	//_cCod := PADR(_cCod,15)
	_cCateg 	:= Alltrim(aDados[i,2])  		//classificação cliente (PL,OU,PR,BR)
	_cDescateg 	:= UPPER(Alltrim(aDados[i,3]))	//PLATINUM, OURO, PRATA, BRONZE
		
	If SA1->(DbSeek(xFilial("SA1")+ _cCod))
		SA1->(RecLock("SA1",.F.))
		SA1->A1_XESCALA := _cCateg 
		SA1->A1_XESCALD := UPPER(Alltrim(_cDescateg))
		SA1->(MsUnLock())	
	EndIf
	
	Next
	
	FT_FUSE()

	_cLog := "Processo Finalizado, OK"
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	MsgInfo("Processo Finalizado, OK")

Return

/*====================================================================================\
|Programa  | STIMPSB1        | Autor | FLÁVIA ROCHA              | Data | 02/02/2022  |
|=====================================================================================|
|Descrição |Função para gravar no campo B1_XCODSE = "S" (produtos Schneider)          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPB1S()
Local _cLog    := ""
Local cArquivo := ""
	
	_cLog:= "ATUALIZAÇÃO PRODUTOS SCHNEIDER"+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  //d:\temp\steck\teste_politica_preco.csv
	
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[STIMPDA1] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Produtos (SB1), aguarde...",, {|| fAtuSB1S(cArquivo)} )		
	EndIf

	
Return

/************************************/
Static Function fAtuSB1S(cArquivo)
/************************************/
Local cLinha  := ""
Local oDlg
Local i       := 0
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local _cLog   := ""
Local _cCod   := ""
	

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()           // lendo a linha
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))	
	
	For i:=1 to Len(aDados)  //ler linhas da array
	
	conout(i)
	
	_cCod := aDados[i,1]	
	_cCod := PADR(_cCod,15)
	//_cCateg := Alltrim(aDados[i,2])
	//If Len(aDados[i]) >= 3		//verificar se há 2 colunas (codigo produto, categoria 1) ou 3 (codigo produto, categoria 1, categoria 2)
	//	_cCateg2:= Alltrim(aDados[i,3])
	//Endif 
		
	If SB1->(DbSeek(xFilial("SB1")+ _cCod))
		SB1->(RecLock("SB1",.F.))
		SB1->B1_XCODSE := "S"  //PRODUTO SCHNEIDER = SIM	/ NÃO
		SB1->B1_XDESAT := "2"  //1-ATIVADO, 2-DESATIVADO
		SB1->(MsUnLock())	
	EndIf
	
	Next
	
	FT_FUSE()

	_cLog := "Processo Finalizado, OK"
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	MsgInfo("Processo Finalizado, OK")

Return

//FR - 05/04/2022 - IMPORTAÇÃO DE DADOS PARA A TABELA CC2 - Municipios IBGE - 
//Atualiza os campos CC2_XTNT e JC2_XDIAS
/*====================================================================================\
|Programa  | STIMPCC2        | Autor | FLÁVIA ROCHA              | Data | 05/04/2021  |
|=====================================================================================|
|Descrição | Atualiza tabela CC2 - Campo CC2_XTNT - Prazo Transporte                  |
|          | Atualiza tabela JC2 - Campo JC2_XDIAS - Prazo Transporte                 |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPCC2()
Local _cLog    := ""
Local cArquivo := ""	
		
	_cLog:= "IMPORTAÇÃO PRAZOS TRANSPORTE (TRANSIT TIME - Tabelas: CC2 e JC2) "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  
	
		MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[STIMPCC2] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Prazos Transportadora-Transit Time (CC2/JC2), aguarde...",, {|| fAtuCC2(cArquivo)} )		
	EndIf

	
Return

/************************************/
Static Function fAtuCC2(cArquivo)
/************************************/
Local cLinha  	:= ""
Local oDlg
Local i       	:= 0
Local lPrim   	:= .T.
Local aCampos 	:= {}
Local aDados  	:= {}
Local _cLog   	:= ""
Local _cUF   	:= ""
Local _cCodMun  := ""
Local _cAux     := ""
Local _nDias    := 0
Local _cCepDE   := ""
Local _cCepATE  := ""
	

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()           // lendo a linha
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))

	DbSelectArea("CC2")
	CC2->(DbSetOrder(1))  //CC2_FILIAL+CC2_EST+CC2_CODMUN
	
	
	For i:=1 to Len(aDados)  //ler linhas da array
	
		conout(i)
		
		_cUF 		:= Alltrim(aDados[i,1])  			//Estado		
		_cAux       := Substr(Alltrim(aDados[i,3]),3,5)	//Código município pega a partir do 3o. caracter, pois os 2 primeiros são o código da UF
		_cCodMun    := PADR( Alltrim(_cAux),5)			//Código município
		_cCepDE     := Alltrim(aDados[i,4])				//CEP de
		_cCepATE    := Alltrim(aDados[i,5])				//CEP até
		_nDias      := Val( Alltrim(aDados[i,6]) )		//Prazo em dias relativo ao município
		
			
		If CC2->(DbSeek(xFilial("CC2")+ _cUF + _cCodMun))
			CC2->(RecLock("CC2",.F.))
			CC2->CC2_XTNT := _nDias		//Grava o prazo neste campo
			CC2->(MsUnLock())	
		EndIf

		//Atualiza JC2
		DBSelectArea("JC2")
		JC2->(DbSetOrder(1)) //JC2_FILIAL+JC2_CEP+JC2_LOGRAD+JC2_BAIRRO+JC2_CIDADE+JC2_ESTADO
		If JC2->(DbSeek(xFilial("JC2")+ _cCepDE))
			While JC2->(!Eof()) .and. JC2->JC2_CEP >= _cCepDE .and. JC2->JC2_CEP <= _cCepATE
				
				JC2->(RecLock("JC2",.F.))
				JC2->JC2_XDIAS := Alltrim(Str(_nDias))		//Grava o prazo neste campo
				JC2->(MsUnLock())

				JC2->(Dbskip())
			Enddo 
		Endif 
	
	Next
	
	FT_FUSE()

	_cLog := "Processo Finalizado, OK - Atualização Prazos para Municípios e CEP Realizado Com Sucesso"
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	MsgInfo("Processo Finalizado, OK")

Return




