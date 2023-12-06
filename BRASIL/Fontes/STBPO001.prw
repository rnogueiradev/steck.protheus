#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "ParmType.ch"

//==============================================================================//
//Função  : STBPO001
//Autoria : Flávia Rocha - Data: 07/10/2022 
//Objetivo: Rotina de job para importação de arquivo csv direto da pasta do servidor
//==============================================================================//
User Function STBPO001(aParam)

	Local aTabs				:= {"SA2","SE2"}
	Local oFunc				:= rvgFun01():New()
	Local aEmpresa			:= {}
	Local aLstEmp			:= {}
	Local aLstEmpPr			:= {}
	Local cRotina			:= oFunc:RetFunName(.F.,.T.)  //"[STBPO001] "
	Local bMens				:= {|x| ConOut(cRotina + x)}
	Local ni				:= 0
	Local cEmpCon			:= ""
	Local cFilCon			:= ""
	Local lOk				:= .T.
	
	
	DEFAULT cCdEmp := "11"  //"01" //pode deixar vazio, se vazio, aí ele vai carregar todas as empresas da SM0
	DEFAULT cCdFil := "" 	//"01"  //"05"

	cCdEmp := aParam[01]//Padr(cCdEmp,2)
	cCdFil := aParam[02]//Padr(cCdFil,2)

	//------------------------
	//Validar tipo de acesso
	//------------------------
	If !oFunc:InJob()
		Eval(bMens,"Finalizado. Esta rotina somente pode ser executada via JOB.")
		oFunc:Finish()
		Return Nil
	Endif
	//---------------------------
	//Definir o formato da data
	//---------------------------
	__SetCentury("ON")
	_DFSET("dd/mm/yyyy","dd/mm/yy")
	//------------------------------------------
	//Carregar estrutura de empresas e filiais
	//------------------------------------------
	Eval(bMens,"Iniciado [" + DtoC(Date()) + Space(1) + Time() + "]")
	OpenSm0()
	aEmpresa := FWLoadSM0()
	//-------------------------------------
	//Validar empresa e filial informados
	//-------------------------------------
	If Empty(cCdEmp)
		aLstEmp := aClone(aEmpresa)
	Else
		For ni := 1 to Len(aEmpresa)
			If aEmpresa[ni][SM0_GRPEMP] == cCdEmp .AND. (Empty(cCdFil) .OR. aEmpresa[ni][SM0_CODFIL] == cCdFil)
				aAdd(aLstEmp,aClone(aEmpresa[ni]))
			Endif
		Next ni
		If Empty(aLstEmp)
			Eval(bMens,"Finalizado. Empresa [" + cCdEmp + "] nao consta na lista de empresas!")
		Endif
	Endif
	//--------------------------
	//Varrer lista de empresas
	//--------------------------
	For ni := 1 to Len(aLstEmp)
		cEmpCon := aLstEmp[ni][SM0_GRPEMP]
		cFilCon := aLstEmp[ni][SM0_CODFIL]
        cCNPJCon:= aLstEmp[ni][18]  //CNPJ
		lOk		:= .T.
		//-----------------------------------------------
		//Validar se a empresa esta autorizada para uso
		//-----------------------------------------------
        
		If ValType(aLstEmp[ni][SM0_EMPOK]) == "L" .AND. !aLstEmp[ni][SM0_EMPOK]
			Eval(bMens,"Empresa [" + cEmpCon + "-" + cFilCon + "] nao esta autorizada!")
			Loop
		Endif
        
		//-------------
		//Conexao RPC
		//-------------
		If  oFunc:SetRPCCon(cEmpCon,cFilCon," ")

			//-----------------------------------------------------
			//Validar se a empresa + filial esta liberada pra uso
			//(ApLib050) para evitar erro de execucao
			//-----------------------------------------------------
			If EmprOK(cEmpCon + cFilCon)

			
				//------------------
				//Carregar tabelas
				//------------------
				lOk := oFunc:LoadTables(aTabs,.T.,.T.)
				
				If lOk
					cPending := "\PENDING\"
					cSend    := "\SEND\"
					cError   := "\ERRO\"  //pasta que grava log de erro
					cLog     :="\LOG\"    //pasta que grava log de sucesso

					//VERIFICA SE O CNPJ DA EMPRESA LIDA AGORA É IGUAL AO DE ALGUMA DAS PASTAS:
					If Alltrim(cCNPJCon) $ "\arquivos\SFTP-INTEGRAÇÕES\RH\05890658000563_GUARAREMA"+ cPending
						FABREPASTA(cFilCon, "\arquivos\SFTP-INTEGRAÇÕES\RH\05890658000563_GUARAREMA" , cPending , cSend,cError,cLog)

					ElseIf Alltrim(cCNPJCon) $ "\arquivos\SFTP-INTEGRAÇÕES\RH\06048486000114_MANAUS" + cPending
						FABREPASTA(cFilCon,"\arquivos\SFTP-INTEGRAÇÕES\RH\06048486000114_MANAUS", cPending, cSend, cError, cLog)

					ElseIf Alltrim(cCNPJCon) $ "\arquivos\SFTP-INTEGRAÇÕES\RH\44415136000138_ARUJA" + cPending
						FABREPASTA(cFilCon,"\arquivos\SFTP-INTEGRAÇÕES\RH\44415136000138_ARUJA", cPending , cSend, cError, cLog)

					ElseIf Alltrim(cCNPJCon) $ "\arquivos\SFTP-INTEGRAÇÕES\RH\44415136000219_LIMAO" + cPending
						FABREPASTA(cFilCon,"\arquivos\SFTP-INTEGRAÇÕES\RH\44415136000219_LIMAO", cPending , cSend,cError, cLog)
					Endif 

                    
					//Adicionar empresa a lista de empresas processadas
					aAdd(aLstEmpPr,cEmpCon)
				Endif  //lOK
			Else
				Eval(bMens,"Empresa [" + cEmpCon + "-" + cFilCon + "] nao liberada para o uso!")
			Endif

			If ni < Len(aLstEmp)
				RPCClearEnv()
			EndIf

		Else        //conexao RPC
			Eval(bMens,"Nao foi possivel estabelecer a conexao RPC [" + cEmpCon + "-" + cFilCon + "].")
		Endif
	Next ni

	Eval(bMens,"Finalizado [" + DtoC(Date()) + Space(1) + Time() + "]")	
	RPCClearEnv()
Return

//==============================================================================//
//Função  : fABREPASTA
//Autoria : Flávia Rocha - Data: 07/10/2022 
//Objetivo:
//Função que recebe a pasta, e verifica se tem arquivos dentro para importação
//==============================================================================//
Static Function FABREPasta(cFil,cPasta,cPending,cSend,cError,cLog)
Local aFiles := {}
Local aSizes := {}
Local nX     := 0
Local nCount := 0 
Local lRet   := .F.

//Definindo os diretórios
//cDirUsr  := GetTempPath()
//cDirSrv  := '\x_Diretorio\'

If ExistDir(cPasta + cPending)

	ADir(cPasta + cPending + "\*.CSV", aFiles, aSizes)
	nCount := Len( aFiles )
	
	For nX := 1 to nCount
		//se o arquivo começar com "FIN" é importação para contas a pagar	
		If "FIN" $ UPPER(Alltrim(aFiles[nX])) 
			
			//envia para a função que importa
			//alert("gera SE2")
			lRet := STABRECSV(cFil,cPasta+cPending,aFiles[nX],"P",cPasta,cError,cLog)				

			//se for true, copia o arquivo da pasta pending para send				
			If lRet
				//copia o arquivo de pending para send pois já foi processado com sucesso
				//__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)  //Caminho origem + arquivo , Caminho destino + arquivo
				__CopyFile(cPasta + cPending + aFiles[nX] , cPasta + cSend + aFiles[nX]) 
				
				//apaga o arquivo da pasta pending depois de copiar para send
				//FErase(cPasta+cArquivo+".xml")  //caminho + arquivo com extensão
				FErase(cPasta + cPending + aFiles[nX])
			Else 
				//se for falso, envia email para Camile e Adriane informando				
			Endif 
			
		ElseIf "FOR" $ UPPER(Alltrim(aFiles[nX])) 
			
			//ALERT("gera SA2")
			//chama a função de importação passando por parâmetro o nome do arquivo
			lRet := STABRECSV(cFil,cPasta+cPending,aFiles[nX],"F",cPasta,cError,cLog)	

			If lRet
				//copia o arquivo de pending para send pois já foi processado com sucesso
				//__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)  //Caminho origem + arquivo , Caminho destino + arquivo
				__CopyFile(cPasta + cPending + aFiles[nX] , cPasta + cSend + aFiles[nX]) 
				
				//apaga o arquivo da pasta pending depois de copiar para send
				//FErase(cPasta+cArquivo+".xml")  //caminho + arquivo com extensão
				FErase(cPasta + cPending + aFiles[nX])
			Else 
				//se for falso, envia email para Camile e Adriane informando				
			Endif 

		Endif
	Next

Endif 

Return


//==============================================================================//
//Função  : STABRECSV
//Autoria : Flávia Rocha - Data: 07/10/2022 
//Objetivo:
//Função abre um arquivo csv e faz a importação campo a campo e enviará para 
//o execauto de inclusão de título a pagar
//==============================================================================//User Function STIMPSE2()
Static Function STABRECSV(cFil,cPasta,cArquivo,xTipo,cPastaPrin,cError,cLog)
Local _cLog    := ""
Local lRet     := .F.
		
	_cLog:= "IMPORTAÇÃO DE TÍTULOS A PAGAR (Tabela: SE2) "+CHR(13) +CHR(10)
	
	If !File(cPasta + cArquivo)  //caminho do arquivo + arquivo.extensão
	
		//MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[STIMPCC2] - ATENCAO")
		Conout("O arquivo " +cPasta_Arq + " não foi encontrado. A importação será abortada!","[STIMPSE2] - ATENCAO")
		Return
	Else		
		lRet := FIMPCSV(cFil, cPasta , cArquivo, xTipo,cPastaPrin,cError,cLog)	
	EndIf

	
Return(lRet)


//==============================================================================//
//Função  : FIMPCSV
//Autoria : Flávia Rocha - Data: 07/10/2022 
//Objetivo:
//Função que um arquivo csv e faz a importação campo a campo e enviará para 
//o execauto de inclusão de título a pagar
//==============================================================================//
Static Function FIMPCSV(cFil, cPasta, cArquivo, xTipo,cPastaPrin,cError,cLog)
Local cLinha  	:= ""
//Local oDlg
Local i       	:= 0
Local lPrim   	:= .T.
Local aCampos 	:= {}
Local aDados  	:= {}
//Local _cLog   	:= ""

//variaveis PARA SE2
Local cForn     := ""
Local cLoja     := ""
Local cNum      := ""
Local cPref     :=""
Local cParc     := ""
Local nValor    := 0
Local cNomFor   := ""
Local cNaturez  := ""
Local cHist     := ""
Local dVencto   := Ctod(" /  /    ")	
Local dVencrea  := Ctod(" /  /    ")	
Local dEmissao  := Ctod(" /  /    ")
Local lRet      := .F.   //retorno se gerou o título dentro do loop for/next
Local lRetorno  := .T.	 //retorno geral da função

//variaveis PARA SA2
cTipo       := ""
cCNPJ       := ""
cCod        := ""
cLoja 		:= ""
cNome       := ""
cNReduz		:= ""
cEnd		:= ""
cEst		:= ""
cNroEnd     := ""
cCod_mun    := ""
cBairro		:= ""
cComplem	:= ""
cCep		:= ""
cEmail		:= ""
cMat		:= ""
cTel		:= ""
cInscr		:= ""
cCodpais	:= ""
cXSolic		:= ""
cXDepto 	:= ""
cBloq		:= ""
cNomMun		:= ""

FT_FUSE(cPasta + cArquivo)                   // abrir arquivo
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

For i:=1 to Len(aDados)  //ler linhas da array	
	
	//cFilial, cForn, cLoja, cNum, cPref, cParc, nValor, cAcao)
	//arquivo vem nesta ordem:
	//E2_PREFIXO;		//1
	//E2_NUM;			//2
	//E2_PARCELA;		//3
	//E2_TIPO;			//4
	//E2_NATUREZ;		//5
	//E2_PORTADO;		//6
	//E2_FORNECE;		//7
	//E2_LOJA;			//8
	//E2_NOMFOR;		//9
	//E2_VENCTO;		//10
	//E2_VENCREA;		//11
	//E2_VALOR;			//12
	//E2_BCOPAG;		//13
	//E2_EMIS1;			//14
	//E2_EMISSAO;		//15
	//E2_HIST;			//16
	//E2_VLCRUZ;		//17
	//E2_CONTAD;		//18
	//E2_CCD			//19
	
	If xTipo = "P" //título a pagar
		cPref       := Alltrim(aDados[i,1])		
		cNum        := StrZero(Val(aDados[i,2]), 9)
		cParc       := Alltrim(aDados[i,3])		
		cTipo 		:= Alltrim(aDados[i,4])
		cNaturez    := Alltrim(aDados[i,5])
		cForn 		:= Alltrim(aDados[i,7])  	
		cLoja       := Alltrim(aDados[i,8])
		cNomFor     := Alltrim(aDados[i,9])
		dVencto     := Stod(aDados[i,10])
		dVencrea    := Stod(aDados[i,11])
		nValor      := Val(StrTran(StrTran(aDados[i,12],".",""),",","."))  //cCharToVal( Alltrim(aDados[i,12]) )
		dEmissao    := Stod(aDados[i,15])
		cHist       := Alltrim(aDados[i,16])
		
		lRet := STCRIASE2(cFil, cForn, cLoja, cNum, cPref, cParc, nValor, dVencto, dVencrea, cHist, cTipo, cNaturez, dEmissao,cPasta,cArquivo,cPastaPrin,cError,cLog)
		lRetorno := lRet		

	Else //"F" - cadastro fornecedor
		//A2_TIPO;		//1
		//A2_CGC;		//2
		//A2_COD;		//3
		//A2_LOJA;		//4
		//A2_NOME;		//5
		//A2_NREDUZ;	//6
		//A2_END;		//7
		//A2_EST;		//8
		//A2_NR_END;	//9
		//A2_COD_MUN;	//10
		//A2_BAIRRO;	//11
		//A2_COMPLEM;	//12
		//A2_CEP;		//13
		//A2_EMAIL;		//14
		//A2_MAT;		//15
		//A2_TEL;		//16
		//A2_INSCR;		//17
		//A2_CODPAIS;	//18
		//A2_XSOLIC;	//19
		//A2_XDEPTO;	//20
		//A2_MSBLQL;	//21
		//A2_MUN		//22

		cTipo       := Alltrim(aDados[i,1])		
		cCNPJ       := Alltrim(aDados[i,2])
		cCod        := Alltrim(aDados[i,3])		
		cLoja 		:= Alltrim(aDados[i,4])
		cNome       := substr(Alltrim(aDados[i,5]) , 1, TamSX3("A2_NOME")[1] )
		cNReduz		:= Substr(Alltrim(aDados[i,6]) , 1, TamSX3("A2_NREDUZ")[1] )
		cEnd		:= Substr(Alltrim(aDados[i,7]) , 1, TamSX3("A2_END")[1] )
		cEst		:= Alltrim(aDados[i,8])
		cNroEnd     := Alltrim(aDados[i,9])
		cCod_mun    := Alltrim(aDados[i,10])
		cBairro		:= Substr(Alltrim(aDados[i,11]), 1, TamSX3("A2_BAIRRO")[1] )
		cComplem	:= Alltrim(aDados[i,12])
		cCep		:= Alltrim(aDados[i,13])
		cEmail		:= Alltrim(aDados[i,14])
		cMat		:= Alltrim(aDados[i,15])
		cTel		:= substr(Alltrim(aDados[i,16]) , 1, TamSX3("A2_TEL")[1] )  //Alltrim(aDados[i,16])
		cInscr		:= Alltrim(aDados[i,17])
		cCodpais	:= Alltrim(aDados[i,18])
		cXSolic		:= Iif(!Empty(Alltrim(aDados[i,19])), Alltrim(aDados[i,19]), "RH" )
		cXDepto 	:= Iif(!Empty(Alltrim(aDados[i,20])), Alltrim(aDados[i,20]), "RH" )
		cBloq		:= Alltrim(aDados[i,21])
		cNomMun		:= Alltrim(aDados[i,22])

		lRet := STCRIASA2(cFil,cTipo,cCNPJ,cCod,cLoja,cNome,cNReduz,cEnd,cEst,cNroEnd,cCod_mun,cBairro,cComplem,cCep,cEmail,cMat,cTel,cInscr,cCodpais,cXSolic,cXDepto,cBloq,cNomMun,cPasta,cArquivo,cPastaPrin,cError,cLog)
		lRetorno := lRet			

	Endif 

Next
	
	FT_FUSE()
	
	//MsgInfo("Processo Finalizado, OK")
		

Return(lRetorno)

///EXECAUTO SE2
//==============================================================================//
//Função  : STCRIASE2
//Autoria : Flávia Rocha - Data: 07/10/2022 
//Objetivo:
//Com as informações do arquivo csv, executa o Execauto para criação do título
//a pagar
//==============================================================================//
Static Function STCRIASE2(cFil,cForn, cLoj, cNum, cPref, cParc, nValor, dVencto, dVencrea, cHist, cTipo, cNaturez, dEmissao,cPasta, cArquivo,cPastaPrin,cError,cLog) //(cFilial, cForn, cLoja, cNum, cPref, cParc, nValor)
Local aArray 	:= {}
Local lRet 		:= .F.
Local _nAutoOpc := 0
Local cArqLog   := ""
Local _aAttach  := {}
Local _cEmail   := ""
Local _cCopia   := ""
Local _cAssunto := ""
Local cMsg		:= ""
Local _cCaminho := ""
Local nPos		:= 0
//FR -20/10/2022 - Everson solicitou colocar Usuário responsável pela aprovação do título a pagar (Campo: E2_XAPROV)
Local cUserApv  := GetNewPar("ST_GPEUSR" , "001466/001542")  
//FR -20/10/2022 - Everson solicitou colocar Usuário responsável pela inclusão do título a pagar (Campo: E2_USRINC)
Local cUserInc  := GetNewPar("ST_GPEUSRI", "001411")
Local _cLog     := ""

Private lMsErroAuto := .F.

//E2_PREFIXO;E2_NUM;E2_PARCELA;E2_TIPO;E2_NATUREZ;E2_PORTADO;E2_FORNECE;E2_LOJA;E2_NOMFOR;E2_VENCTO;E2_VENCREA;E2_VALOR;E2_BCOPAG;E2_EMIS1;E2_EMISSAO;E2_HIST;E2_VLCRUZ;E2_CONTAD;E2_CCD
//GETSX8NUM('SA2','A2_COD')

aArray := { { "E2_PREFIXO"  , cPref           	, NIL },;
            { "E2_NUM"      , cNum 				, NIL },;
            { "E2_PARCELA"  , cParc 			, NIL },;
            { "E2_TIPO"     , cTipo           	, NIL },;
            { "E2_NATUREZ"  , cNaturez	      	, NIL },;
            { "E2_FORNECE"  , cForn           	, NIL },;
            { "E2_LOJA"     , cLoj	          	, NIL },;
            { "E2_EMISSAO"  , dEmissao			, NIL },;
            { "E2_VENCTO"   , dVencto			, NIL },;
            { "E2_VENCREA"  , dVencrea			, NIL },;
            { "E2_VALOR"    , nValor            , NIL },;
            { "E2_HIST"     , cHist				, NIL },;
			{ "E2_USRINC"	, cUserInc			, NIL },;
			{ "E2_XAPROV"	, cUserApv			, NIL }}
            
 
//Inicia o controle de transação
Begin Transaction

	//If cAcao == "I" //INCLUSAO
		_nAutoOpc := 3
	//ElseIf cAcao == "A" //ALTERACAO
	//	_nAutoOpc := 4
	//Else //EXCLUSAO
	//	_nAutoOpc := 5
	//EndIf

	SE2->(OrdSetfocus(1))
	If SE2->(DbSeek(cFil + cPref + cNum + cParc + cTipo + cForn + cLoj ))
		//título já existe não pode pr3osseguir
		//ALERT("TITULO: " + cPref + "-"+ cNum + "-" + cParc + " -  JÁ EXISTE!!!")
				
		nPos    := Rat("." , cArquivo)
		xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		cArqLog := "alerta_" + Substr(cArquivo,1,nPos-1) + "_" + xHora + ".log" //pega o nome do arquivo sem a extensão
				
		_cLog += AllTrim( "Filial/Prefixo/Numero/Parcela: " + cFil + cPref + cNum + cParc +"-> Título já existe."+CHR(13)+CHR(10) )
		//MemoWrite(cPasta + cArqLog, _cLog)
		MemoWrite(cPastaPrin + cError + cArqLog , _cLog) //pasta principal sem barra + \ERRO\ + nome arquivo.log

		aadd( _aAttach  , cArqLog)	
		//_cCaminho := cPasta	
		//cAnexo    := cPasta + cArqLog

		_cCaminho := cPastaPrin + cError			//somente o caminho do arquivo
		cAnexo    := cPastaPrin + cError + cArqLog	//caminho do arquivo + arquivo
		
		_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
		//_cEmail   := ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR

		_cAssunto := "WF Inclusao de Titulo a Pagar <Alerta -> " + cPref + "-" + cNum
		cMsg      := _cLog
		lEnviou   := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
				
	Else 
			
		lMsErroAuto := .F.				 
		_cLog       := ""
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, _nAutoOpc)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
		If lMsErroAuto
			//MostraErro() //mostra na tela
			
			nPos    := Rat("." , cArquivo)
			xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
			cArqLog := "erro_" + Substr(cArquivo,1,nPos-1) + "_" + xHora + ".log" //pega o nome do arquivo sem a extensão

			//grava na pasta		
			//_cErro  := MostraErro( cPasta, cArqLog)
			_cErro := MostraErro(cPastaPrin + cError, cArqLog) //pasta principal sem barra + \ERRO\
			_cLog   += AllTrim( "Filial/Prefixo/Numero/Parcela: " + cFil + cPref + cNum + cParc +"-> Erro ao processar: " +CHR(13)+CHR(10) + _cErro  )
			
			aadd( _aAttach  , cArqLog)	
			//_cCaminho := cPasta	
			//cAnexo    := cPasta + cArqLog
			_cCaminho := cPastaPrin + cError			//só o caminho sem o arquivo
			cAnexo    := cPastaPrin + cError + cArqLog  //o arquivo de erro fica na pasta principal\ERRO\
			_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
			//_cEmail   := ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR
			
			_cAssunto := "WF Inclusao de Titulo a Pagar <Erro -> " + cPref + "-" + cNum
			cMsg	  := _cLog
			lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
			DisarmTransaction()

		Else

			lRet := .T.
			nPos    := Rat("." , cArquivo)
			xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
			cArqLog := "sucesso_" + Substr(cArquivo,1,nPos-1) + "_" + xHora + ".log" //pega o nome do arquivo sem a extensão
			_cLog   := ""			
			_cLog   += AllTrim( "Titulo a Pagar Criado Com Sucesso -> Filial/Prefixo/Numero/Parcela: " + cFil + "/" + cPref + "/"+ cNum + "/" + cParc +"/ "+ Alltrim(Transform(nValor,"@E 999,999,999.99" )))
			//MemoWrite(cPasta + cArqLog, _cLog)
			MemoWrite(cPastaPrin + cLog + cArqLog , _cLog) //pasta principal sem barra + \LOG\ + nome arquivo.log

			aadd( _aAttach  , cArqLog)	
			//_cCaminho := cPasta	
			//cAnexo    := cPasta + cArqLog
			_cCaminho := cPastaPrin + cLog				//só o caminho sem o arquivo
			cAnexo    := cPastaPrin + cLog + cArqLog   //caminho com o arquivo -> o arquivo de log fica na pasta principal\LOG\

			_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
			//_cEmail   := ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR

			_cAssunto := "WF Inclusao de Titulo a Pagar <Sucesso -> " + cPref + "-" + cNum
			cMsg      := _cLog
			lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar

		Endif

	Endif 
End Transaction
 
Return( lRet )

//execauto SA2
//==============================================================================//
//Função  : STCRIASA2
//Autoria : Flávia Rocha - Data: 11/10/2022 
//Objetivo:
//Com as informações do arquivo csv, executa o Execauto para criação do título
//a pagar
//==============================================================================//
Static Function STCRIASA2(cFil,cTipo,cCNPJ,cCod,cLoja,cNome,cNReduz,cEnd,cEst,cNroEnd,cCod_mun,cBairro,cComplem,cCep,cEmail,cMat,cTel,cInscr,cCodpais,cXSolic,cXDepto,cBloq,cNomMun,cPasta,cArquivo,cPastaPrin,cError,cLog)
//Local aArray 	:= {}
Local lRet 		:= .F.
//Local _nAutoOpc := 0
Local cArqLog   := ""
Local _aAttach  := {}
Local _cEmail   := ""
Local _cCopia   := ""
Local _cAssunto := ""
Local cMsg		:= ""
Local _cCaminho := ""
Local _cErro	:= ""
Local _cErro1   := {}
Local _cLog		:= ""
Local nPos		:= 0
Local nOpc      := 3 // ----> Inclusão
Local oModel    := Nil
Local fr 		:= 0
Private cMsgRet := ""


Private lMsErroAuto := .F.
                                                                                                    

cCod := FSA2Cod()  //TRAZ O PRÓXIMO CÓDIGO LIVRE A2_COD
 

//A2_ZDFRMPG -> ini padrão: IIF(!INCLUI,ALLTRIM( POSICIONE("SX5",1,XFILIAL("SX5")+"58"+SA2->A2_FORMPAG,"X5_DESCRI")),"")                                    
cFormpag := ""  //"CREDITO EM CONTA CORRENTE"

aVetor := {	{"A2_COD"		,cCod   		,nil},;
			{"A2_LOJA"		,cLoja         	,nil},;
			{"A2_TIPO"		,cTipo         	,nil},;
			{"A2_NOME" 		,cNome         	,nil},;
			{"A2_NREDUZ"	,cNReduz    	,nil},;
			{"A2_END"		,cEnd			,nil},;
			{"A2_BAIRRO"	,cBairro		,nil},;
			{"A2_EST"		,cEst 			,nil},;
			{"A2_COD_MUN"	,cCod_Mun       ,nil},;
			{"A2_MUN"		,cNomMun		,nil},;
			{"A2_CEP"		,cCep			,nil},;  
			{"A2_CGC"		,cCNPJ			,nil},;  
			{"A2_TEL"		,cTel			,nil},;  
			{"A2_CODPAIS"	,cCodpais		,nil},;
			{"A2_XSOLIC"	,cXSolic		,nil},;
			{"A2_XDEPTO"	,cXDepto 		,nil},;  
			{"A2_EMAIL"		,cEmail			,nil},;
			{"A2_MSBLQL"	,cBloq			,nil},;						
			{"A2_ZDFRMPG"	,cFormpag		,nil},;
			{"A2_NOMFAV"    ,cNome			,nil},;
			{"A2_TIPAWB"    ,Space(TamSX3("A2_TIPAWB")[1])		,nil},;
			{"A2_DTPAWB"    ,Space(TamSX3("A2_DTPAWB")[1])		,nil};
			}

			//Inicia o controle de transação
			//Begin Transaction
		
			oModel := FWLoadModel('MATA020')

			oModel:SetOperation(nOpc)
			oModel:Activate()
		
			oModel:SetValue('SA2MASTER','A2_COD' 	,cCod)
			oModel:SetValue('SA2MASTER','A2_LOJA' 	,cLoja)
			oModel:SetValue('SA2MASTER','A2_TIPO' 	,cTipo)
			oModel:SetValue('SA2MASTER','A2_NOME' 	,cNome)
			oModel:SetValue('SA2MASTER','A2_NREDUZ' ,cNReduz)
			oModel:SetValue('SA2MASTER','A2_END' 	,cEnd)
			oModel:SetValue('SA2MASTER','A2_BAIRRO' ,cBairro)
			oModel:SetValue('SA2MASTER','A2_EST' 	,cEst)
			oModel:SetValue('SA2MASTER','A2_COD_MUN',cCod_Mun)
			oModel:SetValue('SA2MASTER','A2_MUN' 	,cNomMun)
			oModel:SetValue('SA2MASTER','A2_CEP' 	,cCep)			
			oModel:SetValue('SA2MASTER','A2_CGC' 	,cCNPJ)
			oModel:SetValue('SA2MASTER','A2_TEL' 	,cTel)
			oModel:SetValue('SA2MASTER','A2_CODPAIS',cCodpais)
			oModel:SetValue('SA2MASTER','A2_XSOLIC' ,cXSolic)
			oModel:SetValue('SA2MASTER','A2_XDEPTO' ,cXDepto)
			oModel:SetValue('SA2MASTER','A2_EMAIL' 	,cEmail)
			oModel:SetValue('SA2MASTER','A2_MSBLQL' ,cBloq)
			oModel:SetValue('SA2MASTER','A2_ZDFRMPG',cFormpag)
			oModel:SetValue('SA2MASTER','A2_NOMFAV' ,cNome)
			oModel:SetValue('SA2MASTER','A2_TIPAWB' ,"")
			oModel:SetValue('SA2MASTER','A2_DTPAWB' ,"")			

			SA2->(OrdSetfocus(3))
			If SA2->(DbSeek(xFilial("SA2")+ cCNPJ)) 
				
				nPos    := Rat("." , cArquivo)
				xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
				cArqLog := "alerta_" + Substr(cArquivo,1,nPos-1) + "_" + xHora +  ".log" //pega o nome do arquivo sem a extensão
				
				_cLog += AllTrim( "CPF/Nome: " + cCNPJ + "-" + cNome + "-> Fornecedor já existe."+CHR(13)+CHR(10) )
				//MemoWrite(cPasta + cArqLog, _cLog)
				MemoWrite(cPastaPrin + cError + cArqLog, _cLog) //grava o log de erro na pasta principal sem barra + \ERRO\ + nome arquivo.log

				aadd( _aAttach  , cArqLog)	
				//_cCaminho := cPasta	
				//cAnexo    := cPasta + cArqLog
				_cCaminho   := cPastaPrin + cError  			//caminho do arquivo sem o arquivo
				cAnexo      := cPastaPrin + cError + cArqLog 	//caminho completo + arquivo -> para anexar pega o arquivo que gravou na pasta principal da empresa + \ERROR\

				_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
				//_cEmail   := ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR

				_cAssunto := "WF Inclusao de Fornecedor <Alerta -> CPF-NOME: " + cCNPJ + "-" + cNome 
				cMsg      := _cLog
				lEnviou   := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
				
			Else 
				/*
				lMsErroAuto := .F.
				 
				//Esse modelo de execauto MATA020 não funciona mais, 
				//precisa ser no modelo MVC, por isso, comentei este bloco
				MSExecAuto({|x,y| Mata020(x,y)},aVetor,3)

				If lMsErroAuto
					
					nPos    := Rat("." , cArquivo)
					xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
					cArqLog := "erro_" + Substr(cArquivo,1,nPos-1) + "_" + xHora + ".log" //pega o nome do arquivo sem a extensão
					
					_cErro  := MostraErro( cPasta, cArqLog)
					_cLog   += AllTrim( "WF Inclusao de Fornecedor -> CPF-NOME: " + cCNPJ + "-" + cNome + CHR(13)+CHR(10) + " - " + cMsgRet + CHR(13)+CHR(10) + _cErro )

					aadd( _aAttach  , cArqLog)	
					_cCaminho := cPasta	
					cAnexo    := cPasta + cArqLog

					_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
					_cEmail   := ";flah.rocha@sigamat.com.br"  //FR RETIRAR
					
					_cAssunto := "WF Inclusao de Fornecedor <Erro -> CPF-NOME: " + cCNPJ + "-" + cNome 
					cMsg      := _cLog
					lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar

					DisarmTransaction()
				Else
					lRet  := .T.
					nPos    := Rat("." , cArquivo)
					xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
					cArqLog := "sucesso_" + Substr(cArquivo,1,nPos-1) + "_" + xHora +  ".log" //pega o nome do arquivo sem a extensão
					_cLog += AllTrim( "CPF: " + cCNPJ + "-" + cNome + " - Incluido no Cad. de Fornecedores com sucesso."+CHR(13)+CHR(10) )
					MemoWrite(cPasta + cArqLog, _cLog)

					aadd( _aAttach  , cArqLog)	
					_cCaminho := cPasta	
					cAnexo    := cPasta + cArqLog

				 	_cEmail   += ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR
					
					_cAssunto := "WF Inclusao de Fornecedor <Sucesso -> CPF-NOME: " + cCNPJ + "-" + cNome 
					cMsg      := _cLog
					lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar

				EndIf
				*/

				//--------------------------------------------------------//
				//MODELO NOVO MVC - EXECAUTO DE CADASTRO DE FORNECEDORES
				//--------------------------------------------------------//
				If oModel:VldData()

					oModel:CommitData()
				 
					lRet  := .T.
					nPos    := Rat("." , cArquivo)
					xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
					cArqLog := "sucesso_" + Substr(cArquivo,1,nPos-1) + "_" + xHora +  ".log" //pega o nome do arquivo sem a extensão
					_cLog += AllTrim( "CPF: " + cCNPJ + "-" + cNome + " - Incluido no Cad. de Fornecedores com sucesso."+CHR(13)+CHR(10) )
					//MemoWrite(cPasta + cArqLog, _cLog)
					MemoWrite(cPastaPrin + cLog + cArqLog, _cLog) //pasta principal sem barra + \LOG\ + nome arquivo.log

					aadd( _aAttach  , cArqLog)	
					//_cCaminho := cPasta	
					//cAnexo    := cPasta + cArqLog
					_cCaminho := cPastaPrin + cLog 				//caminho do arquivo sem o arquivo
					cAnexo    := cPastaPrin + cLog + cArqLog  	//caminho do arquivo + arquivo -> o log de sucesso fica na pasta principal + \LOG\ 

					_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
				 	//_cEmail   := ";flah.rocha@sigamat.com.br;everson.santana@steck.com.br"  //FR RETIRAR
					
					_cAssunto := "WF Inclusao de Fornecedor <Sucesso -> CPF-NOME: " + cCNPJ + "-" + cNome 
					cMsg      := _cLog
					lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
				
				Else 
					//VarInfo("",oModel:GetErrorMessage())
					nPos    := Rat("." , cArquivo)
					xHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
					cArqLog := "erro_" + Substr(cArquivo,1,nPos-1) + "_" + xHora + ".log" //pega o nome do arquivo sem a extensão
					
					//_cErro  := MostraErro( cPasta, cArqLog)
					_cErro1  := oModel:GetErrorMessage()
					For fr := 1 to Len(_cErro1)
						If ValType(_cErro1[fr]) == "C"
							_cErro += CRLF + _cErro1[fr]
						Endif 
					Next
					_cLog   += AllTrim( "WF Inclusao de Fornecedor -> CPF-NOME: " + cCNPJ + "-" + cNome + CHR(13)+CHR(10) + " - " + cMsgRet + CHR(13)+CHR(10) + _cErro )
					//MemoWrite(cPasta + cArqLog, _cLog)
					MemoWrite(cPastaPrin + cError + cArqLog, _cLog) //pasta principal sem barra + \ERRO\ + nome arquivo.log
					
					aadd( _aAttach  , cArqLog)	
					//_cCaminho := cPasta	
					//cAnexo    := cPasta + cArqLog
					_cCaminho := cPastaPrin + cError 			//caminho do arquivo sem o arquivo
					cAnexo    := cPastaPrin + cError + cArqLog  //caminho do arquivo + arquivo -> o log de erro fica na pasta principal + \ERRO\

					_cEmail   := GetNewPar("ST_MAILRH1" , "adriana.silva@steck.com.br;camile.paula@steck.com.br")
					//_cEmail   := ";flah.rocha@sigamat.com.br"  //FR RETIRAR
					
					_cAssunto := "WF Inclusao de Fornecedor <Erro -> CPF-NOME: " + cCNPJ + "-" + cNome 
					cMsg      := _cLog
					lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					//lEnviou   := FRSendMail( _cEmail, _cCopia, _cAssunto, cMsg, cAnexo )		//para testes retirar
					//DisarmTransaction()
				Endif

				oModel:DeActivate()

				oModel:Destroy()

			Endif 

			//End Transaction
			
Return(lRet)



/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
//FUNÇÃO FR PARA TESTES
Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


//================================================//
//Função para trazer o próximo código fornecedor
//================================================//
STATIC FUNCTION FSA2Cod()
Local cQuery   := ""
Local cRet     := ""
Local cRetorno := ""

cQuery := " SELECT MAX(A2_COD) A2COD FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " WHERE " 

cQuery += " SA2.D_E_L_E_T_ = ' ' "
cQuery += " AND A2_COD NOT IN ('ESTADO' , 'INPS' , 'INPS83' , 'MUNIC' , 'UNIAO' , 'INPSAF', 'INPS76', 'INPS83' ,'INPS12' ,"
cQuery += " 'INPSAD', 'INPSAF', 'INPSAH', 'INPS03' , 'INPS02' , 'INPSA6' , 'INPSAK') "

cQuery += " AND A2_COD NOT LIKE '%INP%' "
cQuery += " AND A2_COD NOT LIKE '%IMP%' "
cQuery += " ORDER BY A2_COD DESC "
MemoWrite("C:\QUERY\FSA2COD.TXT" ,cQuery)

cQuery := ChangeQuery( cQuery )		
If Select("TMPA2") > 0
	Dbselectarea("TMPA2")
	DbcloseArea()
Endif 

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPA2", .T., .F. )
DbSelectArea("TMPA2")
DbGoTop()
	
If TMPA2->(!Eof())
	cRet     := TMPA2->A2COD
	cRetorno := Soma1(Alltrim(cRet))

	Dbselectarea("TMPA2")
	DbcloseArea()
Endif

DbSelectarea("SA2")
SA2->(OrdSetFocus(1))
While SA2->( DbSeek( xFilial( "SA2" ) + cRetorno ) )
   ConfirmSX8()   
   cRetorno := SOMA1(cRetorno)
Enddo

RETURN(cRetorno)
