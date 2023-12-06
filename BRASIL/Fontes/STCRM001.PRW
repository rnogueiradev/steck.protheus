#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

//Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STCRMR01    | Adaptação | FLÁVIA.ROCHA              | Data | 21/07/2021  |
|=====================================================================================|
|Descrição | Receber e cadastrar clientes   										  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//Alterações realizadas:
//FR - 23/08/2021 - Após incluir um cliente via API enviar um WF para o pessoal de 
//                  cadastro, inicialmente a aricleia.silva@steck.com.br
//------------------------------------------------------------------------------------//

WSRESTFUL cadCli DESCRIPTION "Cadastrar clientes"

WSMETHOD POST DESCRIPTION "Cadastrar clientes" WSSYNTAX "/rest/cadCli"

END WSRESTFUL

WSMETHOD POST WSSERVICE cadCli

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	//Local _cEmp 	:= ""
	Local _cFil		:= ""
	Local aCabec	:= {}
	Local _nX

	//Local cQuery      := ""
	Local _cCNPJ      := ""
	Local _cErro	  := ""
	Local _cRet		  := ""
	Local _cAux		  := ""
	Local _cLog		  := ""
	Local _aTemSA1    := {}
	Local aLog		  := {}
	Local _lBascnpj   := .F.
	Local i           := 0
	Local nOpcao	  := 3
	
	Private lMsErroAuto := .F.
	
	ConOut("[STCRM001]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STCRM001]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)
    
    
	_cXmlRec := FwCutOff(_cXmlRec,.T.)

	oInfo := ""
	_lRet := FWJsonDeserialize(FwNoAccent(_cXmlRec),@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))        //A1_FILIAL+A1_CGC 

	aData := ClassDataArr(oInfo)												//transforma o objeto vindo do ws, em um array
	aData := FWVetByDic ( aData, "SA1", .F. /*lItens */, 1 /*nCpoPos*/ )		//ordena o array na ordem do SX3
	
	_cCNPJ := oInfo:A1_CGC

	_aTemSA1 := fVerSA1( Alltrim(_cCNPJ),1)		//verifica se tem o cliente via query no banco
	/*
	//Tipo 1 retorno:
	If nTipo == 1 .or. nTipo == 2 //devolve se tem na Sa1, e o cnpj para posterior comparação
		Aadd( aRetSa1 , lTemSA1        ) //1
		Aadd( aRetSa1 , XF3TAB->A1_CGC ) //2
		Aadd( aRetSa1 , XF3TAB->A1_COD ) //3
		Aadd( aRetSa1 , XF3TAB->A1_LOJA) //4
	*/

	If Len(_aTemSA1) > 0
		If _aTemSA1[1] 
			//cResp := '{"CODRET":"04","DESCRET":"CLIENTE JA CADASTRADO","Emp/Fil/CNPJ": "'+ _cEmp + "/"+ _cFil + "/" + _cCNPJ +'"}
			//::SetResponse(cResp)
			//Return .T.
			_cCodcli := _aTemSA1[3]
			_cLojcli := _aTemSA1[4]
			nOpcao := 4
		Endif
	EndIf

	//se não encontrou o cnpj inteiro na base, tenta com parte dele para ver se é cadastro de nova filial
	If nOpcao == 3  
		cAux := ""
		cAux := Substr(_cCNPJ,1,8)
		_aTemSA1 := fVerSA1( Alltrim(cAux),2)  
	
		//1a. checagem do cnpj inteiro se já existe ex.: 44020535000108 / 44020535000280
		If Len(_aTemSA1) > 0
									
			cAux1 := ""
			cAux2 := ""
		
			If _aTemSA1[1] 						
				cAux1:= Alltrim( _cCNPJ      )
				cAux2:= Alltrim( _aTemSA1[2] )

				//SE JÁ EXISTE, CHECA SE A BASE É IGUAL E O FINAL É DIFERENTE
				If Substr(cAux1,1,8) == Substr(cAux2,1,8) .and.  Substr(cAux1,9,6) <> Substr(cAux2,9,6) 

					_lBascnpj := .T.
					
				Endif
				
			Endif

		Endif

		If !_lBascnpj
	    
			_cCodcli := fProxSa1()		//traz um novo código livre
			_cLojcli := "01"  			//SE FOR CLIENTE NOVO, LJA SEMPRE 01, SE A BASE DO CNPJ FOR A MESMA E O FINAL DIFERENTE, MUDA A LOJA		
		
		Else
			cAux := Substr(Alltrim(_cCNPJ),1,8)
			_aTemSA1 := fVerSA1(  cAux , 3 )
			_cCodcli := _aTemSA1[1]		//Aadd( aRetSa1, { cCod, Alltrim(Str(nLj) })		//devolve código e nova loja
			_cLojcli := _aTemSA1[2]

		Endif

	Endif 

	
    //prepara o cabeçalho:
    aadd(aCabec,{"A1_FILIAL",_cFil,Nil})
	aadd(aCabec,{"A1_COD"   ,_cCodcli,Nil})
	aadd(aCabec,{"A1_LOJA"  ,_cLojcli,Nil})

	//array de leitura do aData que vai para o aCabec, trata campos específicos ex.: A1_CEP para tirar ponto ou traço e deixar só número
	For _nX:=1 To Len(aData)
		If SubStr(aData[_nX][1],1,3)=="A1_" 
			If AllTrim(aData[_nX][1])=="A1_CEP" 
				aData[_nX][2] := StrTran(StrTran(aData[_nX][2],"-"),".")
			EndIf
			//aqui povoa o array que vai para o execauto
			aadd(aCabec,{aData[_nX][1],U_STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})  
		EndIf	
	Next

	//retirado porque pode ser alteração
	/*
	If SA1->(Dbseek(_cFil+_cCNPJ))
		cResp := '{"CODRET":"04","DESCRET":"CLIENTE JA CADASTRADO","CODIGO":"'+_cEmp+_cFil+SA1->A1_COD+"/"+SA1->A1_LOJA+'"}
		::SetResponse(cResp)
		Return .T.
	EndIf
	*/
	
	//Prepara arquivo de log de gravação ou erro de gravação:	
	cNArq  := "STCRM001_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"  //nome do arquivo de log
	cDir    := "\arquivos\logs\"

	If !ExistDir(cDir)
		Makedir(cDir)
	EndIf
	//arquivo log
	
	MSExecAuto({|x,y| Mata030(x,y)},aCabec,nOpcao) //3- Inclusão;4-Alteração

	If lMsErroAuto		
		
		//_cErro := MostraErro("arquivos\logs","STCRMR01"+dtos(date())+time()+".log")
		_cErro := MostraErro(cDir,cNArq)
		//_cRet  := "Campo(s) Com Conteudo(s) Invalido(s):"  //+CRLF  //ativar para msg resumida
		
		aLog := GetAutoGRLog()	
		For i := 1 to len(aLog)
			If !"---" $ aLog[i]
				_cLog += aLog[i]
			Endif 
		Next

		_cAux := ""
		_cRet := ""

		/*
		//caso for exibir uma msg resumida do erro:		//ativar se for usar a msg resumida
		For i := 1 to len(_cErro)				
			//If Substr(_cErro,i,3) <> "---" .and. Substr(_cErro,i,4) <> '\r\n' 
			If Substr(UPPER(Alltrim(_cErro)),i,8) == "INVALIDO" 
				_cAux := Substr(Alltrim(_cErro),i-50,55)
				_cRet += _cAux + " ; "
				_cAux := ""
			Endif
		Next i
		*/

		//msg completa:
		cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		//msg resumida:		
		//cResp := '{"CODRET":"03","DESCRET":"'+_cRet+'"}		//ativar se msg resumida
	
	Else

		//cResp := '{"CODRET":"04","DESCRET":"CLIENTE JA CADASTRADO","CODIGO":"'+_cEmp+_cFil+SA1->A1_COD+"/"+SA1->A1_LOJA+'"}
		//cResp := '{"CODRET":"00","DESCRET":"Cliente incluido com sucesso.","CODIGO":' + _cCodcli+ ","+ '"LOJA":'+ _cLojcli + '}" //deu certo
		//cResp := '{"CODRET":"00","DESCRET":"Cliente incluido com sucesso.","CODIGO":' + '"'+_cCodcli+ '",' + '"LOJA":'+ '"'+_cLojcli + '"} 
		//deu certo o cResp acima tb
		/* //FR - 09/03/2022 - Alteração - colocar dentro do dbseek do cliente para ter certeza que cadastrou
		If nOpcao == 3
			_cErro := "Cliente incluido com sucesso: " + CRLF
			cResp := '{"CODRET":"00","DESCRET":"Cliente incluido com sucesso.","CODIGO":' + '"'+_cCodcli+ '",' + '"LOJA":'+ '"'+_cLojcli + '"} 
		Else
			_cErro := "Cliente atualizado com sucesso: " + CRLF
			cResp := '{"CODRET":"00","DESCRET":"Cliente atualizado com sucesso.","CODIGO":' + '"'+_cCodcli+ '",' + '"LOJA":'+ '"'+_cLojcli + '"} 
		Endif 
		
		_cErro += ""+_cCodcli + "/"+_cLojcli + "-"+ Posicione("SA1",1,xFilial("SA1")+_cCodcli+_cLojcli,"A1_NOME")
		*/
		SA1->(OrdSetFocus(1))
		If SA1->(Dbseek(xFilial("SA1")+ _cCodcli + _cLojcli ))
			//Altera o registro criado para bloqueado:
			Reclock("SA1",.F.)
			SA1->A1_MSBLQL := "1"
			SA1->(MsUnlock())

			If nOpcao == 3
				_cErro := "Cliente incluido com sucesso: " + CRLF
				cResp := '{"CODRET":"00","DESCRET":"Cliente incluido com sucesso.","CODIGO":' + '"'+_cCodcli+ '",' + '"LOJA":'+ '"'+_cLojcli + '"} 

				//ENVIA EMAIL QDO SUCESSO CADASTRO só na inclusão
				//fEnvMail(_cCodcli, _cLojCli)		

			Else
				_cErro := "Cliente atualizado com sucesso: " + CRLF
				cResp := '{"CODRET":"00","DESCRET":"Cliente atualizado com sucesso.","CODIGO":' + '"'+_cCodcli+ '",' + '"LOJA":'+ '"'+_cLojcli + '"} 
			Endif 
			
			_cErro += ""+_cCodcli + "/"+_cLojcli + "-"+ Posicione("SA1",1,xFilial("SA1")+_cCodcli+_cLojcli,"A1_NOME")

			//ENVIA EMAIL QDO SUCESSO CADASTRO (inclusão / alteração)
			fEnvMail(_cCodcli, _cLojCli)		

		Else 
			_cErro := "Falha ao Tentar Cadastrar o Cliente"   //-> " +_cCodcli + "/"+_cLojcli
			cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		Endif		
		//FR - 09/03/2022 - Alteração - colocar dentro do dbseek do cliente para ter certeza que cadastrou
		

		//::SetResponse(cResp)
		//Return .T.		
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

	::SetResponse(cResp)

Return .T.

//Chama função U_STMAILTES para enviar email:
Static Function fEnvMail(_cCodcli,_cLojcli)

Local _cEmail	:= ""
Local _cArq  	:= ""
Local _aAttach  := {}
Local _cCopia 	:= ""
Local _cAssunto := ""
Local cMsg		:= ""

_cEmail		:= Alltrim(GetNewPar("ST_CRMR01","aricleia.silva@steck.com.br"))  
_cEmail 	+= ";flah.rocha@gmail.com"   //retirar	
_cArq   	:= "" 
_aAttach	:= {}
_cCopia 	:= ""
_cAssunto   := "[WFPROTHEUS] - CADASTRO CLIENTES via APi"
//_cAssunto   += " - TESTE " //FR RETIRAR
cMsg		:= ""
//aadd( _aAttach  , cStartPath+_cArq )
	
cMsg := '<html><head><title>stkSales</title></head>
cMsg += '<body>
cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
cMsg += '<br><br>Olá <b></b>,<br><br> ' //cMsg += '<br><br>Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
cMsg += 'Você está recebendo a confirmação do Cadastro do Cliente via API da Steck!<br>
cMsg += 'Código Cliente: '+ _cCodcli + '<br>'
cMsg += 'Loja Cliente: '  + _cLojcli + '<br>'
cMsg += 'Nome Cliente: '  + Posicione("SA1",1,xFilial("SA1")+_cCodcli+_cLojcli,"A1_NOME") + '<br><br>'
cMsg += 'Obrigado!<br><br>'
cMsg += 'Atenciosamente,<br>
cMsg += 'Steck Indústria Elétrica Ltda
cMsg += '</body></html>'
//MemoWrite("C:\TEMP\STCRM001.TXT" , cMsg)

lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,"")  

//esta parte pode retirar - //FR TESTE RETIRAR DEPOIS
/*
cMailto := "flah.rocha@gmail.com"
cCopia  := ""
cAssun  := _cAssunto
lEnviou := .F.
cCorpo  := ""
cAnexo  := ""	

cCorpo  := cMsg
cAnexo  := ""

lEnviou := FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )		//FR TESTE RETIRAR	
*/
//esta parte pode retirar - //FR TESTE


If lEnviou	
	Conout("<<< STCRM001 - CADASTRO CLIENTE API - EMAIL ENVIADO OK >>>")
Endif

Return(lEnviou)


//==================================================================================//
//Função  : fVerSA1  
//Autoria : Flávia Rocha
//Data    : 20/07/2021
//Objetivo: Função para checar se já existe CNPJ no cadastro de cliente
//          de OS já alocada
//==================================================================================//
Static Function fVerSA1(_cCNPJ, nTipo)
Local lTemSA1 := .F.
Local aRetSA1 := {}
Local cCod    := ""
Local nLj     := 0

cQuery := "SELECT A1_COD, A1_LOJA, A1_CGC FROM "
cQuery += ""+ RetSqlName("SA1") + " SA1 "
cQuery += " WHERE "
If nTipo == 1	
	cQuery += " A1_CGC = '" + Alltrim(_cCNPJ) + "' "
Elseif nTipo == 2 .or. nTipo == 3
	cQuery += " SUBSTRING(A1_CGC,1,8) = '" + Alltrim(_cCNPJ) + "' "
Endif

cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY A1_FILIAL, A1_COD, A1_LOJA "

MemoWrite("C:\TEMP\VERSA1.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF()) 
	lTemSA1 := .T.
	If nTipo == 1 .or. nTipo == 2 //devolve se tem na Sa1, e o cnpj para posterior comparação
		Aadd( aRetSa1 , lTemSA1        )
		Aadd( aRetSa1 , XF3TAB->A1_CGC )
		Aadd( aRetSa1 , XF3TAB->A1_COD )
		Aadd( aRetSa1 , XF3TAB->A1_LOJA)
		//array de retorno se caso existir o cnpj, poderá comparar com o novo que está se tentando cadastrar, 
		//pois a base pode ser igual mas o final diferente, nesse caso pode cadastrar pois é outra filial da mesma empresa
	
	Elseif nTipo == 3  //retorna o novo código para cadastro da filial
		XF3TAB->(dbGoTop())
		While XF3TAB->(!Eof()) .and. Substr(XF3TAB->A1_CGC,1,8) == _cCNPJ
			cCod    := XF3TAB->A1_COD
			nLj     := Val(XF3TAB->A1_LOJA)
			nLj++
			XF3TAB->(DBSKIP())
		Enddo

		Aadd( aRetSa1, cCod )
		Aadd( aRetSa1, Alltrim(Strzero(nLj,2))  ) 		//devolve código e nova loja
		
	Endif
Endif

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(aRetSa1)


//==================================================================================//
//Função  : fProxSa1  
//Autoria : Flávia Rocha
//Data    : 26/07/2021
//Objetivo: Função para trazer o próximo código livre para cliente
//==================================================================================//
Static Function fProxSa1()
Local cQuery := ""
Local cCodRet:= ""

//cQuery := " SELECT MAX(A1_COD) CODCLI FROM " + RetSqlName("SA1") + " SA1 "
//cQuery += " WHERE A1_COD <> 'ZZZZZZ' "

cQuery := " SELECT MAX(A1_COD) CODIGO
cQuery += " FROM " + RetSqlname("SA1") + " SA1 "
cQuery += " WHERE SA1.D_E_L_E_T_=' ' AND A1_COD NOT IN ( "
cQuery += " '909709', "
cQuery += " '909695', "
cQuery += " '900886', "
cQuery += " '900001', "
cQuery += " '900000', "
cQuery += " '122246', "
cQuery += " '122246', "
cQuery += " '111131', "
cQuery += " '111125', "
cQuery += " '111125', "
cQuery += " '101161', "
cQuery += " '101161', "
cQuery += " '1', "
cQuery += " '099001', "
cQuery += " 'ZZZZZZ' "
cQuery += " ) AND A1_PESSOA <> ' ' "
cQuery += " GROUP BY A1_COD "
cQuery += " ORDER BY A1_COD DESC "

MemoWrite("D:\TMPQRY\PROXSA1.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	
	cCodRet := XF3TAB->CODIGO
	cCodRet := SOMA1(cCodRet)
	
Endif

SA1->(OrdSetFocus(1))
While SA1->( DbSeek( xFilial( "SA1" ) + cCodRet ) )
   ConfirmSX8()   
   cCodRet := SOMA1(cCodRet)
Enddo

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(cCodRet)


//ARRAY PARA TESTE:
/*
//MATRIZ
{
"A1_CGC": "44020535000108",
"A1_NOME": "Atos Automação",
"A1_PESSOA": "J",
"A1_NREDUZ": "ATOS",
"A1_END": "Rua Arnoldo Felmanas, 201",
"A1_TIPO": "F",
"A1_EST": "SP",
"A1_COD_MUN": "50308",
"A1_BAIRRO": "VILA FRIBURGO",
"A1_DDD": "11",
"A1_CEP": "04775170",
"A1_TEL": "3375-8968",
"A1_EMAIL": "flavia.rocha@atos.com.br",
"A1_MSBLQL": "1",
"A1_NATUREZ": "10101",
"A1_VEND": "000006",
"A1_TPFRET": "F",
"A1_GRPVEN":"E3"
}

//FILIAL
{
"A1_CGC": "44020535000280",
"A1_NOME": "ATOS AUTOMACAO",
"A1_PESSOA": "J",
"A1_NREDUZ": "ATOS FILIAL",
"A1_END": "Rua Arnoldo Felmanas, 201",
"A1_TIPO": "F",
"A1_EST": "SP",
"A1_COD_MUN": "50308",
"A1_BAIRRO": "VILA FRIBURGO",
"A1_DDD": "11",
"A1_CEP": "04775170",
"A1_TEL": "3375-8968",
"A1_INSCRM": "ISENTO",
"A1_EMAIL": "flavia.rocha@atos.com.br",
"A1_MSBLQL": "2",
"A1_NATUREZ": "10101",
"A1_VEND": "000006",
"A1_TPFRET": "F"
"A1_GRPVEN":"E3"
}



{
  "A1_ATIVIDA": "AA",
  "A1_BAIRRO": "CENTRO",
  "A1_CEP": "11995000",
  "A1_CGC": "74468536000172",
  "A1_CODPAIS": "01058",
  "A1_COD_MUN": "03004",
  "A1_DDD": "11",
  "A1_EMAIL": "emaildogoogle@gmail.com",
  "A1_END": "RUA CIQUEIRA JUNIOR, 100",
  "A1_EST": "RS",
  "A1_GRPVEN": "AA",
  "A1_MSBLQL": "1",
  "A1_NATUREZ": "10101",
  "A1_NOME": "GOOGLE",
  "A1_NREDUZ": "GOOGLE",
  "A1_PESSOA": "J",
  "A1_TEL": "43219874",
  "A1_TIPO": "F",
  "A1_TPFRET": "F",
  "A1_VEND": "R98765"
}

*/
