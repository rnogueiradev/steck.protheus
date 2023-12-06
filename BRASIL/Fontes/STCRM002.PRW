#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

//Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STCRM002    | Adaptação | FLÁVIA.ROCHA              | Data | 02/08/2021  |
|=====================================================================================|
|Descrição | Receber e cadastrar contatos   										  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL cadCont DESCRIPTION "Cadastrar contatos"

WSMETHOD POST DESCRIPTION "Cadastrar contato" WSSYNTAX "/rest/cadCont"

END WSRESTFUL

WSMETHOD POST WSSERVICE cadCont

Local cResp 	:= ""
Local _cXmlRec 	:= "" //StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")

_cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")

ConOut("[STCRM002]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
ConOut("[STCRM002]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)


_cXmlRec := FwCutOff(_cXmlRec,.T.)

oInfo := ""
_lRet := FWJsonDeserialize(FwNoAccent(_cXmlRec),@oInfo)

//--------------------------------------------------------------------//
//O ARRAY TESTE PARA CONSULTA E REFERÊNCIA ESTÁ NO FINAL DESTE FONTE
//--------------------------------------------------------------------//
If !_lRet
	cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
	::SetResponse(cResp)
	Return .T.
EndIf

fProcessJson(oInfo,@cResp)

::SetResponse(cResp)

Return .T.


/*====================================================================================\
|Programa  | fProcessJson    | Adaptação | FLÁVIA.ROCHA          | Data | 18/08/2021  |
|=====================================================================================|
|Descrição | Processa o objeto recebido do Rest										  |
|          |                                                                          |
\====================================================================================*/
Static Function fProcessJson(oInfo,cResp)
//Local _cEmp 	:= ""
Local aData 	:= {}	
//Local _aTemSU5  := {}	
Local lProssegue:= .T.
Local _nX
Local i 		  := 0

//Local _cFil		  := ""
Local _cCPF       := ""
Local _cCodcont   := ""
Local _cNomecont  := ""
Local _cCli		  := ""
Local _cLoj 	  := ""
Local nOpcao      := 3 						//3-incluir  //4-alterar //5-excluir
Local lX3		  := .T.
Local _cEmail     := ""

Private lMsErroAuto := .F.
Private cUsaExecauto:= GetNewPar("ST_CRMR02", "N")  //liga/desliga do execauto
Private aCabec	  := {}
Private aContato  := {}
Private aEndereco := {}
Private aTelefone := {}
Private _cErro	  := ""
//Private lMsHelpAuto := .F.

DbSelectArea("SU5")     
SU5->(DbSetOrder(8))     //U5_FILIAL+U5_CPF

aData := ClassDataArr(oInfo)												//transforma o objeto vindo do ws, em um array
aData := FWVetByDic ( aData, "SU5", .F. /*lItens */, 1 /*nCpoPos*/ )		//ordena o array na ordem do SX3
Asort(aData,,,{ | x,y | x[3] < y[3] } )
	
//_cCPF      := oInfo:U5_CPF
_cCPF 	   := "" //FR - esse campo não será mais enviado no array json conforme definido em alinhamento com Renato / Vanderlei em 30/08/2021
_cNomecont := oInfo:U5_CONTAT

//FR - 30/08/2021 - reunião com Renato / Vanderlei - definido que o CPF não é obrigatório e nem chave unica
//_aTemSU5 := fVerSU5( Alltrim(_cCPF))		//verifica se tem o cliente via query no banco

//verificação se o contato já existe:
/*
If Len(_aTemSU5) > 0
	If _aTemSU5[1] 
		cResp := '{"CODRET":"04","DESCRET":"CONTATO JA CADASTRADO","Emp/Fil/CPF": "'+ _cEmp + "/"+ _cFil + "/" + _cCPF +'"}
		//::SetResponse(cResp)
		//Return .T.
		Return
	Endif
EndIf
*/

//If Alltrim(cUsaExecauto) == "N"  //usa execauto
	//verificação se os campos recebidos tem no dicionário:
	lX3 := fTemSX3(@cResp,aData)
//Endif 

If !lX3
	lProssegue := .F.
Endif

If lProssegue
	//primeira varredura do array para saber se é inclusão ou alteração (Se vier o campo U5_CODCONT é alteração)
	For _nX:=1 To Len(aData)
		If AllTrim(aData[_nX][1])=="U5_CODCONT" 
			_cCodcont := Alltrim(aData[_nX][2])			
		Elseif AllTrim(aData[_nX][1])=="U5_CLIENTE"  
			_cCli := Alltrim(aData[_nX][2])
		Elseif AllTrim(aData[_nX][1])=="U5_LOJA"  
			_cLoj := Alltrim(aData[_nX][2])	
		Elseif AllTrim(aData[_nX][1])=="U5_EMAIL"
			_cEmail := Alltrim(aData[_nX][2]) 
		EndIf	
	Next

	//Valida se preencheu o email:
	If Empty(_cEmail)

		cResp := '{"CODRET":"04","DESCRET":"Email Nao Preenchido."'+ '}'
		Return

	Endif 

	//valida cliente recebido no array json:
	If Empty(_cCli) .or. Empty(_cLoj)

		cResp := '{"CODRET":"04","DESCRET":"Cliente / Loja Nao Preenchido.","CODIGO":' + '"'+_cCli + '",' + '"LOJA":'+ '"'+_cLoj + '"}
		Return

	Else
		SA1->(OrdsetFocus(1))
		If !SA1->(Dbseek(xFilial("SA1") + _cCli + _cLoj ))

			cResp := '{"CODRET":"04","DESCRET":"Cliente Nao Cadastrado.","CODIGO":' + '"'+_cCli + '",' + '"LOJA":'+ '"'+_cLoj + '"}
			Return

		Endif 
	Endif	 

	//valida o conteúdo código contato, se veio preenchido, é alteração de contato, se não veio, é inclusão:
	If Empty(_cCodcont)
		_cCodcont := fProxSU5()		//traz um novo código livre
	Else
		nOpcao := 4		//Alteração
	Endif
	
	aadd(aCabec,{"U5_FILIAL"    ,xFilial("SU5")	,Nil})
	aadd(aCabec,{"U5_CODCONT"   ,_cCodcont		,Nil})

	aadd(aTelefone,{"AGB_FILIAL"	, xFilial("AGB") 	, Nil })
	aadd(aTelefone,{"AGB_TIPO" 		, "1" 				, Nil })		//1=Comercial 
	aadd(aTelefone,{"AGB_PADRAO"	, "1" 				, Nil })		//1=Sim (Padrão sim ou não)
	
	//--------------------------------//
	//POVOA OS ARRAYS PARA GRAVAÇÃO:
	//--------------------------------//	
	For _nX:=1 To Len(aData)
		If SubStr(aData[_nX][1],1,3)=="U5_" 
			//If AllTrim(aData[_nX][1])=="U5_CEP" 
			//	aData[_nX][2] := StrTran(StrTran(aData[_nX][2],"-"),".")
			//EndIf
			//aqui povoa o array que vai para o execauto
			//aadd(aCabec,{aData[_nX][1],U_STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})
			aadd(aCabec,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil}) 

			If AllTrim(aData[_nX][1]) == "U5_DDD"
				
				aadd(aTelefone,{"AGB_DDD",STRESTH1("AGB_DDD",aData[_nX][2]),Nil})
			
			ElseIf AllTrim(aData[_nX][1]) == "U5_FCOM1"
				
				aadd(aTelefone,{"AGB_TELEFO",STRESTH1("AGB_TELEFO",aData[_nX][2]),Nil})			 
			
			Endif
		//FR - 30/08/2021 - retirado após reunião com REnato e Vanderlei - será replicado do SU5, não virá mais do array json
		/*
		Elseif SubStr(aData[_nX][1],1,4)=="AGB_" 		
			
			//If Alltrim(aData[_nX][1])  == "AGB_CODENT"
			//	aData[_nX][2] := _cCodcont
			//Endif

			aadd(aTelefone,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
		
		Elseif SubStr(aData[_nX][1],1,4)=="AGA_" 
			//aadd(aTelefone,{aData[_nX][1],U_STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
			aadd(aEndereco,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
		*/
		EndIf

	Next

	
	aTelefone := FWVetByDic ( aTelefone, "AGB", .F. /*lItens */, 1 /*nCpoPos*/ )
		
	aContato := aCabec

	//Prepara arquivo de log de gravação ou erro de gravação:	
	cNArq  := "STCRM002_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"  //nome do arquivo de log
	cDir    := "\arquivos\logs\"
		
	If !ExistDir(cDir)
		Makedir(cDir)
	EndIf
	//arquivo log
	

	If Alltrim(cUsaExecauto) == "S"  //usa execauto

		//EXECAUTO para inclusão do registro:
		MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aContato,nOpcao,aEndereco,aTelefone, .F.) 

	Else

		lProssegue := fGrav1(nOpcao,@cResp,_cCodcont,aContato,aEndereco,aTelefone,@_cErro)

		If lProssegue
			lMsErroAuto := .F.
		Else
			lMsErroAuto := .T.
		Endif 
		

	Endif

	//AQUI INDEPENDENTE SE FOI POR EXECAUTO OU RECLOCK, checa se houve erro e retorna resposta para o REST:
	If !lMsErroAuto		//se não deu erro, cadastro ok

		_cErro := "Sucesso no Cadastro: "+_cCodcont + "-"+_cNomecont
		//cResp := '{"CODRET":"00","DESCRET":"Contato incluido com sucesso.","CONTATO":"'+ _cEmp + _cFil + "/" + _cCodcont + "/" + _cNomecont+'"}
		If nOpcao == 3
			cResp := '{"CODRET":"00","DESCRET":"Contato incluido com sucesso.","CODIGO":' + '"'+_cCodcont + '",' + '"NOME":'+ '"'+_cNomecont + '"} 	 
		Else
			cResp := '{"CODRET":"00","DESCRET":"Contato atualizado com sucesso.","CODIGO":' + '"'+_cCodcont + '",' + '"NOME":'+ '"'+_cNomecont + '"} 	 
		Endif 
		
	Else

		If Alltrim(cUsaExecauto) == "S"  //usa execauto		

			aLog := GetAutoGRLog()	
			For i := 1 to len(aLog)		
				_cErro += aLog[i]
			Next i

		Endif
				
		cResp := '{"CODRET":"03","DESCRET": "'+ _cErro + '"}
		
	EndIf

	//----------------------------------//
	//grava o arquivo de log na pasta:
	//----------------------------------//
	_cFile := cDir+ cNArq  //diretório mais nome do arquivo
			
	nHdlXml:= FCreate(_cFile,0)		//Cria o arquivo no diretorio (cria o nome.extensao na pasta apenas)

	If nHdlXml > 0
						
		FWrite(nHdlXml,_cErro)	//aqui grava o conteudo no arquivo acima gravado na pasta
		FClose(nHdlXml)

	Endif
	//fim grava log

	
Endif //lProssegue

Return

/*====================================================================================\
|Programa  | fTemSX3         | Adaptação | FLÁVIA.ROCHA          | Data | 18/08/2021  |
|=====================================================================================|
|Descrição | Verifica se os campos recebidos do Json existem no SX3					  |
|          |                                                                          |
\====================================================================================*/
Static Function fTemSX3(cResp,aData)
Local lTemX3 := .T.
Local _nX     := 0

//Ver se os campos existem no SX3
lTemX3 := .T.

For _nX:=1 To Len(aData)
	If SubStr(aData[_nX][1],1,3)=="U5_"

		If SU5->(FieldPos(aData[_nX][1])) > 0		
			//aadd(aCabec,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil}) 
		Else 
			lTemX3 := .F.
		Endif  
	
	Elseif SubStr(aData[_nX][1],1,4)=="AGB_"

		If AGB->(FieldPos(aData[_nX][1])) > 0
			//aadd(aTelefone,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
		Else 
			lTemX3 := .F.
		Endif
	
	Elseif SubStr(aData[_nX][1],1,4)=="AGA_"

		If AGA->(FieldPos(aData[_nX][1])) > 0		
			//aadd(aEndereco,{aData[_nX][1],STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
		Else 
			lTemX3 := .F.
		Endif

	EndIf	
Next

If !lTemX3	
	cResp := '{"CODRET":"99","DESCRET":"CAMPO(S) INEXISTENTE(S) NO DICIONARIO"}'
	//::SetResponse(cResp)
	//Return .T.
	Return
EndIf
//ver se tem no SX3

Return(lTemX3)


/*====================================================================================\
|Programa  | fGrav1         | Adaptação | FLÁVIA.ROCHA          | Data | 18/08/2021  |
|=====================================================================================|
|Descrição | Processa os arrays para gravação nas tabelas SU5, AGA, AGB				  |
|          |                                                                          |
\====================================================================================*/
Static Function fGrav1(nOpcao,cResp,_cCodcont,aContato,aEndereco,aTelefone,_cErro)
Local lContinua := .T.

//Valida SU5
lContinua := fVldGrav(nOpcao,"SU5",_cCodcont,aContato,aEndereco,aTelefone,@_cErro)

If lContinua  //se gravou SU5, replica na AGB:
//Depois de validar SU5, grava AGB
	lContinua := fVldGrav(nOpcao,"AGB",_cCodcont,aContato,aEndereco,aTelefone,@_cErro)

	//If lContinua
		//lContinua := fGravTABS("AGA",_cCodcont,aContato,aEndereco,aTelefone,@_cErro)  //por eqto não precisa gravar o endereço
	//Endif 

Endif


Return(lContinua)

//==================================================================================//
//Função  : fVldGrav
//Autoria : Flávia Rocha
//Data    : 11/08/2021
//Objetivo: Função para validar a gravaçao das tabelas SU5, AGA, AGB 
//==================================================================================//
Static Function fVldGrav(nOpcao,cTab,_cCodcont,aContato,aEndereco,aTelefone,_cErro)
Local aArea   	:= GetArea()
Local lGravou 	:= .F.
//Local cAGCOD  	:= ""
Local lVazio  	:= .F.
Local lCompart  := .F.
Local fr      	:= 0
Local cBox 		:= ""

//SU5
Local xCPF 		:= ""
Local xContat 	:= ""
Local xDDD 		:= ""
Local xFcom1 	:= ""
Local xEmail	:= ""
Local xAtivo 	:= ""
Local xFuncao 	:= ""
Local xDepto 	:= ""
Local xCli		:= ""
Local xLoj		:= ""
//local xDescfun  := ""
//Local xDescdep  := ""

//AGA
Local xTipoAG := "" 
Local xPadAG  := ""
Local xEndAG  := ""
Local xCepAG  := ""
Local xBairrAG:= ""
Local xMunAG  := ""
Local xEstAG  := ""

//AGB
Local xTelAG  := ""

If cTab == "AGA"		//endereços

	//ver se tem algum campo vazio
	For fr := 1 to Len(aEndereco)
		If Empty(aEndereco[fr,2])
			lVazio := .T.
			_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S): "+ aEndereco[fr,1] +CRLF
		Endif

		cBox := fSX3Box(aEndereco[fr,1])

		If !lVazio
			If !Empty(cBox)
				If !aEndereco[fr,2] $ cBox  //ex.: se "1" tá contido nas opções do combo do campo
					lVazio := .T.
					_cErro += "CONTEUDO INVALIDO: "+ aEndereco[fr,1] +CRLF
				Endif			 
			Endif
		Endif
	Next

	If !lVazio		//se não houver campos vazios , prossegue						
						
		fr := aScan(aEndereco,{|x| x[1] == "AGA_TIPO" })
		xTipoAG	:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_PADRAO" })
		xPadAG 	:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_END" })
		xEndAG 	:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_CEP" })
		xCepAG 	:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_BAIRRO" })
		xBairrAG:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_MUNDES" })
		xMunAG 	:= aEndereco[fr,2]
		
		fr := aScan(aEndereco,{|x| x[1] == "AGA_EST" })
		xEstAG 	:= aEndereco[fr,2]

		lGravou := fGravOK(nOpcao,cTab,_cCodcont,xTipoAG,xPadAG,xEndAG,xCepAG,xBairrAG,xMunAG,xEstAG,xDDD,xTelAG)

	//Else
	//	_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S) "+CRLF	
	Endif
	

ElseIf cTab == "AGB"		//endereços

	//ver se tem algum campo vazio
	
	For fr := 1 to Len(aTelefone)
		If aTelefone[fr,1] <> 'AGB_FILIAL'
			If Empty(aTelefone[fr,2])
				lVazio := .T.
				_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S): "+ aTelefone[fr,1] +CRLF
			Endif

			cBox := fSX3Box(aTelefone[fr,1])

			If !lVazio
				If !Empty(cBox)
					If !aTelefone[fr,2] $ cBox  //ex.: se "1" tá contido nas opções do combo do campo
						lVazio := .T.
						_cErro += "CONTEUDO INVALIDO: "+ aTelefone[fr,1] +CRLF
					Endif			 
				Endif
			Endif
		Endif 
	Next
	

	If !lVazio		//se não houver campos vazios , prossegue
			
		
		fr := aScan(aTelefone,{|x| x[1] == "AGB_TIPO" })
		If fr > 0
			xTipoAG := aTelefone[fr,2]
		Else 
			lVazio := .T.
		Endif 
	
		fr := aScan(aTelefone,{|x| x[1] == "AGB_PADRAO" })
		If fr > 0
			xPadAG := aTelefone[fr,2]
		Else
			lVazio := .T.
		Endif

		fr := aScan(aTelefone,{|x| x[1] == "AGB_DDD" })		
		If fr > 0
			xDDD := aTelefone[fr,2]
		Else
			lVazio := .T.
		Endif 

		fr := aScan(aTelefone,{|x| x[1] == "AGB_TELEFO" })
		If fr > 0
			xTelAG := aTelefone[fr,2]
		Else
			lVazio := .T.
		Endif 

		If !lVazio
					
			lGravou := fGravOK(nOpcao,cTab,_cCodcont,xTipoAG,xPadAG,xEndAG,xCepAG,xBairrAG,xMunAG,xEstAG,xDDD,xTelAG)
		
		Else
			_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S) OU INVALIDO(S) "+CRLF
		
		Endif 

	//Else
	//	_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S) OU INVALIDO(S) "+CRLF
	Endif 

Elseif cTab == "SU5"
	
	SX2->(OrdSetfocus(1))
	SX2->(Dbseek("SU5"))
	If Alltrim(SX2->X2_MODO) == 'C'
		lCompart := .T.
	Endif 
	//ver se tem algum campo vazio
	For fr := 1 to Len(aContato)
		
		If lCompart //compartilhado filial pode ficar vazia
			If aContato[fr,1] <> 'U5_FILIAL'
				If Empty(aContato[fr,2])
					lVazio := .T.
					_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S): "+ aContato[fr,1] +CRLF
				Endif
			Endif 
		Else
		
			If Empty(aContato[fr,2])
				lVazio := .T.
				_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S): "+ aContato[fr,1] +CRLF
			Endif
		
		Endif
		
		cBox := fSX3Box(aContato[fr,1])

		If !lVazio
			If !Empty(cBox)
				If !aContato[fr,2] $ cBox  //ex.: se "1" tá contido nas opções do combo do campo
					lVazio := .T.
					_cErro += "CONTEUDO INVALIDO "+ aContato[fr,1] +CRLF
				Endif			 
			Endif
		Endif
		
	Next

	If !lVazio		//se não houver campos vazios , prossegue
		//fr := aScan(aContato,{|x| x[1] == "U5_CPF" })
		//xCPF := aContato[fr,2]
	
		fr := aScan(aContato,{|x| x[1] == "U5_CONTAT" })
		If fr > 0
			xContat := aContato[fr,2]
		Else 
			lVazio := .T.
		Endif 
	
		fr := aScan(aContato,{|x| x[1] == "U5_DDD" })
		If fr > 0
			xDDD := aContato[fr,2]
		Else
			lVazio := .T.
		Endif 

		fr := aScan(aContato,{|x| x[1] == "U5_FCOM1" })
		If fr > 0
			xFcom1 := aContato[fr,2]
		Else 
			lVazio := .T.
		Endif 

		fr := aScan(aContato,{|x| x[1] == "U5_EMAIL" })
		If fr > 0
			xEmail := aContato[fr,2]
		Else
			lVazio := .T.
		Endif 

		//fr := aScan(aContato,{|x| x[1] == "U5_ATIVO" })
		xAtivo := "1" //aContato[fr,2]		//1=Sim;2=Não
	
		fr := aScan(aContato,{|x| x[1] == "U5_FUNCAO" })
		If fr > 0
			xFuncao := aContato[fr,2]
		Else 
			lVazio := .T.
		Endif 

		fr := aScan(aContato,{|x| x[1] == "U5_DEPTO" })
		If fr > 0
			xDepto := aContato[fr,2]
		Else
			lVazio := .T.
		Endif 

		fr := aScan(aContato,{|x| x[1] == "U5_CLIENTE" })
		If fr > 0
			xCli := aContato[fr,2]
		Else 
			lVazio := .T.
		Endif 

		fr := aScan(aContato,{|x| x[1] == "U5_LOJA" })
		If fr > 0
			xLoj := aContato[fr,2]
		Else 
			lVazio := .T.
		Endif 
	
		SUM->(OrdSetFocus(1))
		If !SUM->(Dbseek(xFilial("SUM") + xFuncao))
			_cErro += " FUNCAO NAO CADASTRADA " + CRLF
			lVazio := .T.
		Endif					

		SQB->(OrdSetFocus(1))
		If !SQB->(Dbseek(xFilial("SQB") + xDepto))
			_cErro += " DEPTO NAO CADASTRADO " + CRLF
			lVazio := .T.
		Endif

		//ver campos de ativo se pertence 1/2
		//ver se tem validação de município e estado UF

		If !lVazio

			lGravou := fGravOK(nOpcao,cTab,_cCodcont,xTipoAG,xPadAG,xEndAG,xCepAG,xBairrAG,xMunAG,xEstAG,xDDD,xTelAG,xCPF,xContat,xFcom1,xEmail,xAtivo,xFuncao,xDepto,xCli,xLoj)

		Else
			_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S) OU INVALIDO(S) "+CRLF
		Endif 		

	//Else 
	//	_cErro += "CAMPO(S) OBRIGATORIO(S) NAO PREENCHIDO(S) OU INVALIDO(S) "+CRLF
	Endif      
	

Endif 

RestArea( aArea )

Return(lGravou)

//-------------------------------------------------//
//Grava no banco de dados - Tabelas AGA, ABG, SU5
//-------------------------------------------------//
Static Function fGravOK(nOpcao,cTab,_cCodcont,xTipoAG,xPadAG,xEndAG,xCepAG,xBairrAG,xMunAG,xEstAG,xDDD,xTelAG,xCPF,xContat,xFcom1,xEmail,xAtivo,xFuncao,xDepto,xCli,xLoj) 

Local lGrv   := .F.
Local cAGCOD := ""
Local lNovo  := .T.
Local aAGB   := {}
//Local lVai   := .T.

/*
If Alltrim(cTab) == "AGA"
	cAGCOD := GetSx8Num("AGA","AGA_CODIGO") 

	DbSelectArea("AGA")
	AGA->(OrdSetFocus(2))
	While AGA->( DbSeek( xFilial( "AGA" ) + cAGCOD ) )
		ConfirmSX8()   
		cAGCOD := SOMA1(cAGCOD)
	Enddo	

	Reclock("AGA" , .T.)
	AGA->AGA_FILIAL := xFilial("AGA")
	AGA->AGA_CODIGO := cAGCOD
	AGA->AGA_ENTIDA := "SU5"
	AGA->AGA_CODENT := _cCodcont
	AGA->AGA_TIPO   := xTipoAG  
	AGA->AGA_PADRAO := xPadAG
	AGA->AGA_END    := xEndAG  
	AGA->AGA_CEP    := xCepAG 
	AGA->AGA_BAIRRO := xBairrAG
	AGA->AGA_MUNDES := xMunAG 
	AGA->AGA_EST    := xEstAG  
	AGA->(MsUnLock())
	lGrv := .T.	

Elseif Alltrim(cTab) == "AGB"
*/
If Alltrim(cTab) == "AGB"
		
	DbselectArea("AGB")
	
	If nOpcao == 3 //3=inclui;4=altera
		cAGCOD := fProxAGB(nOpcao)

		AGB->(OrdSetFocus(2))
		While AGA->( DbSeek( xFilial( "AGB" ) + cAGCOD ) )
			ConfirmSX8()   
			cAGCOD := SOMA1(cAGCOD)
		Enddo

	Else		//se for alteração, vai que não tem AGB, então procuro pra ver se existe, altera, senão, inclui
		lNovo := .F.
		//AGB->(OrdSetFocus(3)) 	//3-AGB_FILIAL+AGB_ENTIDA+AGB_CODENT+AGB_PADRAO           //1-AGB_FILIAL+AGB_ENTIDA+AGB_CODENT+AGB_TIPO+AGB_PADRAO
		//If AGB->(Dbseek(xFilial("AGB") + "SU5" + _cCodcont + xTipoAG + xPadAG))			
			//lNovo := .F.
			//cAGCOD:= AGB->AGB_CODIGO
		//Else			
			//lNovo := .T.
		//Endif
		aAGB  := fProxAGB(nOpcao,_cCodcont,xPadAG,xTipoAG) //fProxAGB(nOpcao,cCodent,cPad,cTip)
		cAGCOD:= aAGB[1]
		lNovo := iif(aAGB[2] == .F.,.T.,.F.)
	Endif

	Reclock("AGB" , lNovo)
	If lNovo
		AGB->AGB_FILIAL := xFilial("AGB")
		AGB->AGB_CODENT := _cCodcont
		AGB->AGB_CODIGO := cAGCOD
		AGB->AGB_ENTIDA := "SU5"	
	Endif 	  
	AGB->AGB_DDD    := xDDD	
	AGB->AGB_PADRAO := xPadAG
	AGB->AGB_TELEFO := xTelAG
	AGB->AGB_TIPO   := xTipoAG 
	//AGB->AGB_COMP
	//AGB->AGB_DDI
	AGB->(MsUnLock())
	lGrv := .T.
	

Elseif Alltrim(cTab) == "SU5"

	DbSelectArea("SU5")
	If nOpcao <> 3 //3=inclui;4=altera
		lNovo := .F.
	Endif
	
	SU5->(OrdSetfocus(1)) //U5_FILIAL+U5_CODCONT+U5_IDEXC 
	If !SU5->(Dbseek(xFilial("SU5")+ _cCodcont))
		lNovo := .T.
	Endif 
		
	Reclock("SU5" , lNovo)
	If lNovo
		SU5->U5_FILIAL := xFilial("SU5") 
		SU5->U5_CODCONT:= _cCodcont
	Endif
	//SU5->U5_CPF    := xCPF
	SU5->U5_CONTAT := xContat
	SU5->U5_DDD    := xDDD
	SU5->U5_FCOM1  := xFcom1
	SU5->U5_EMAIL  := xEmail
	SU5->U5_ATIVO  := xAtivo
	SU5->U5_FUNCAO := xFuncao
	SU5->U5_DEPTO  := xDepto
	SU5->U5_CLIENTE:= xCli
	SU5->U5_LOJA   := xLoj
	SU5->(MsUnLock())
	lGrv := .T.

	//Atualiza vínculo contato x cliente (AC8)
	If !Empty(xCli) .and. !Empty(xLoj)
		AC8->(OrdSetFocus(1)) //AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
		If !AC8->(Dbseek(xFilial("AC8") + _cCodcont + "SA1" + xFilial("SU5") + xCli + xLoj))
			lNovo := .T.
		Else	
			lNovo := .F.
		Endif
			
			//se não encontrar, inclui vinculo
			DbselectArea("AC8")
			Reclock("AC8" , lNovo)
			AC8->AC8_FILIAL := xFilial("AC8")
			AC8->AC8_FILENT := xFilial("SU5")
			AC8->AC8_ENTIDA := "SA1"
			AC8->AC8_CODENT := Alltrim(xCli)+ Alltrim(xLoj)
			AC8->AC8_CODCON := _cCodcont
			AC8->(Msunlock())
		
	Endif 

Endif	

Return(lGrv)


//==================================================================================//
//Função  : fSX3Box 
//Autoria : Flávia Rocha
//Data    : 11/08/2021
//Objetivo: Função para trazer as opções combobox do campo no SX3 (caso haja)
//==================================================================================//
Static Function fSX3Box(xCpo)
//Local fr    := 0
Local cCBox := ""

dbSelectArea("SX3")
SX3->(dbSetOrder(2))   //X3_CAMPO 

cCBox := ""

If dbSeek(xCpo)		//busca o campo
	If !Empty(SX3->X3_CBOX) 			
		cCBox := SX3->X3_CBOX					                                                                                    
	EndIf			
Endif
	
Return(cCBox)


//==================================================================================//
//Função  : fProxAGB 
//Autoria : Flávia Rocha
//Data    : 11/08/2021
//Objetivo: Função para trazer o próximo código livre 
//==================================================================================//
Static Function fProxAGB(nOpcao,cCodent,cPad,cTip)
Local cQuery := ""
Local cCodAGB:= ""
Local aRet   := {}
Local lExiste:= .F.

If nOpcao == 3
	cQuery := " SELECT MAX(AGB_CODIGO) CODIGO "
	cQuery += " FROM " + RetSqlname("AGB") + " AGB "
	cQuery += " WHERE AGB.D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY AGB_CODIGO "
	cQuery += " ORDER BY AGB_CODIGO DESC "
Else
	cQuery := " SELECT AGB_CODIGO CODIGO, AGB_ENTIDA, AGB_CODENT, AGB_TIPO, AGB_PADRAO "
	cQuery += " FROM " + RetSqlname("AGB") + " AGB "
	cQuery += " WHERE AGB.D_E_L_E_T_ <> '*' "
	cQuery += " AND AGB_ENTIDA = 'SU5' "
	cQuery += " AND AGB_CODENT = '"+cCodent + "'" //código do contato
	cQuery += " AND AGB_PADRAO = '"+cPad + "'"
	cQuery += " AND AGB_TIPO   = '"+cTip + "'"	
EndIf

MemoWrite("C:\TEMP\PROXAGB.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	cCodAGB := XF3TAB->CODIGO
	If nOpcao == 3
		cCodAGB := SOMA1(cCodAGB)	
	Endif
	lExiste := .T.
	
Endif


If Empty(cCodAGB)

	cCodAGB := "000001"
	AGB->(OrdSetFocus(2))
	While AGB->( DbSeek( xFilial( "AGB" ) + cCodAGB ) )
		ConfirmSX8()   
		cCodAGB := SOMA1(cCodAGB)
	Enddo

Endif

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

If nOpcao == 3
	Return(cCodAGB)
Else
	Aadd(aRet, cCodAGB)
	Aadd(aRet, lExiste)  //.T. indica q o registro já existe
	Return(aRet)
Endif 



/*====================================================================================\
|Programa  | STRESTH1        | Autor | RENATO.OLIVEIRA           | Data | 02/09/2020  |
|=====================================================================================|
|Descrição | RETORNA VARIAVEL CONVERTIDA			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STRESTH1(_cCampo,_cVal)

	Local _aAreaSX3 := SX3->(GetArea())
	Local _xVal 	:= ""

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(2))

	If SX3->(DbSeek(_cCampo))

		If SX3->X3_TIPO == 'C' .Or. SX3->X3_TIPO == 'M'
			_xVal := _cVal
		ElseIf SX3->X3_TIPO == 'D'
			_xVal := CtoD(_cVal)
		ElseIf SX3->X3_TIPO == 'N'
			_xVal := Val(_cVal)
		Else
			If _cVal == ".T."
				_xVal := .T.
			Else
				_xVal := .F.
			Endif
		EndIf

	EndIf

	RestArea(_aAreaSX3)

Return(_xVal)


//==================================================================================//
//Função  : fVerSU5  
//Autoria : Flávia Rocha
//Data    : 20/07/2021
//Objetivo: Função para checar se já existe CPF no cadastro de contato
//==================================================================================//
/*
Static Function fVerSU5(_cCPF)
Local lTemSU5 := .F.
Local aRetSU5 := {}
Local cQuery  := ""

cQuery := "SELECT U5_FILIAL, U5_CODCONT, U5_CONTAT, U5_CPF FROM "
cQuery += ""+ RetSqlName("SU5") + " SU5 "
cQuery += " WHERE "
cQuery += " U5_CPF = '" + Alltrim(_cCPF) + "' "
//cQuery += " AND U5_FILIAL = '" + _cFil + "' "
cQuery += " AND SU5.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY U5_FILIAL, U5_CODCONT "

MemoWrite("C:\TEMP\VERSU5.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF()) 
	lTemSU5 := .T.
	Aadd( aRetSU5 , lTemSU5        )
	Aadd( aRetSU5 , XF3TAB->U5_CPF )	
Endif

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(aRetSU5)
*/

//==================================================================================//
//Função  : fProxSU5  
//Autoria : Flávia Rocha
//Data    : 26/07/2021
//Objetivo: Função para trazer o próximo código livre para cliente
//==================================================================================//
Static Function fProxSU5()
Local cQuery := ""
Local cCodRet:= ""

cQuery := " SELECT MAX(U5_CODCONT) CODIGO "
cQuery += " FROM " + RetSqlname("SU5") + " SU5 "
cQuery += " WHERE SU5.D_E_L_E_T_=' ' "
cQuery += " GROUP BY U5_CODCONT "
cQuery += " ORDER BY U5_CODCONT DESC "

//MemoWrite("D:\TMPQRY\PROXSU5.SQL" , cQuery )

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
	cCodRet := "000001"
Endif

SU5->(OrdSetFocus(1))
While SU5->( DbSeek( xFilial( "SU5" ) + cCodRet ) )
   ConfirmSX8()   
   cCodRet := SOMA1(cCodRet)
Enddo

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(cCodRet)

/*
ARRAYS DE TESTE:

2o. array teste pós reunião com Vanderlei e Renato

//inclusão:
{
"U5_CONTAT": "Joao Bosko",
"U5_DDD": "11",
"U5_FCOM1": "55554200",
"U5_EMAIL": "joao.bosko@empresa.com.br",
"U5_FUNCAO": "000002",
"U5_DEPTO": "000000002",
"U5_CLIENTE": "086931",
"U5_LOJA": "01"
}

//alteração
{
"U5_CODCONT":"000002"	
"U5_CONTAT": "Joao Bosko",
"U5_DDD": "11",
"U5_FCOM1": "55554200",
"U5_EMAIL": joao.bosko@empresa.com.br,
"U5_FUNCAO": "000002",
"U5_DEPTO": "000000002",
"U5_CLIENTE": "086931",
"U5_LOJA": "01"
}



1o. array teste
{"U5_CPF": "17618702896",
"U5_CONTAT": "Joao Bosko",
"U5_DDD": "11",
"U5_FCOM1": "55554200",
"U5_EMAIL": "joao.bosko@empresa.com.br",
"U5_ATIVO": "1",
"U5_FUNCAO": "000002",
"U5_DFUNCAO": "COMPRADOR",
"U5_DEPTO": "000000002",
"AGA_TIPO": "1",
"AGA_PADRAO": "1",
"AGA_END": "R. Totvs",
"AGA_CEP": "04851260",
"AGA_BAIRRO": "Bairro Totvs",
"AGA_MUNDES": "Cidade Totvs",
"AGA_EST": "SP",
"AGB_TIPO": "1",
"AGB_PADRAO": "1",
"AGB_DDD": "11"}
*/
