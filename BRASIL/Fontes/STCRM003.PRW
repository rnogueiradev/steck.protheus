/**************************************** 
A��o.........: WebService de Consulta de pre�os integra��o CRM x Protheus - consCotacoes
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 26/07/2022
Chamado......: 20220727014715 - Integra��o de Cota��es

C�DIGOS DE RETORNO NESTA API:
{"CODRET":"00","DESCRET":"Aguarde Processamento..."} = Processamento efetuado
{"CODRET":"01","DESCRET":"ERRO...MENSAGEM"} = Erro em alguma valida��o
****************************************/
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

WSRESTFUL consCotacoes DESCRIPTION "Consultar Pre�o"
WSMETHOD POST DESCRIPTION "Consultar Pre�o" WSSYNTAX "/rest/consCotacoes"
END WSRESTFUL

/***************************************
Endere�o para WebService Desenvolvimento
http://rest-p12.steck.com.br:9997/rest/conscotacoes -> homologa��o
***************************************/
WSMETHOD POST WSSERVICE consCotacoes
LOCAL nX        := 0
LOCAL _lRet     := .F.
LOCAL _cJson    := ""
LOCAL _cRetorno := ""
Local cRet      := ""
Local cChaveCli := ""


oJson  := NIL
oItens := NIL

::SetContentType("application/json") 
_cJson := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")  
_lRet := FWJsonDeserialize(FwNoAccent(_cJson),@oJson)

/*********************************
Valida o Json recebido.
*********************************/
IF _lRet = .F. 
	_cRetorno := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o a chave do cabe�alho GUID do CRM
*********************************/
IF EMPTY(oJson:UA_XGUID)
	_cRetorno := '{"CODRET":"01","DESCRET":"CHAVE UA_XGUID EM BRANCO"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o do Cliente
*********************************/
cRet:=U_ValidaCli(ALLTRIM(oJson:CNPJ))
IF cRet=='X'
	_cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE NAO ENCONTRADO"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ELSEIF cRet=='B'   
	_cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE BLOQUEADO "}'
	::SetResponse(_cRetorno)
	RETURN .T.
ELSE 
   SA1->(DBSETORDER(1))    
   IF ! SA1->(DBSEEK(XFILIAL("SA1")+cRet))
  	  _cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE N�O ENCONTRADO NO PROTHEUS"}'
	  ::SetResponse(_cRetorno)
	  RETURN .T.
   ELSE 
      cChaveCli:=cRet
   ENDIF
ENDIF   

//DBSELECTAREA("SA1")
//SA1->(DBSETORDER(3))
//IF !SA1->(DBSEEK(XFILIAL("SA1")+ALLTRIM(oJson:CNPJ)))
//	_cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE NAO ENCONTRADO"}'
//	::SetResponse(_cRetorno)
//	RETURN .T.
//ENDIF

/*********************************
Valida��o da Condi��o de Pagamento
*********************************/
DBSELECTAREA("SE4")
SE4->(DBSETORDER(1))
IF !SE4->(DBSEEK(XFILIAL("SE4")+ALLTRIM(oJson:UA_XCONDPG)))
  _cRetorno := '{"CODRET":"01","DESCRET":"CONDICAO PAGTO NAO CADASTRADA"}'
	::SetResponse(_cRetorno)
  RETURN .T.
ENDIF


/*********************************
Grava o in�cio do processamento
*********************************/
CONOUT("[STCRM003] - CONSCOTACOES - In�cio da grava��o do Json na tabela Z98 "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" - registro:"+ALLTRIM(oJson:UA_XGUID))

/********************************
Varre os itens do Objeto
********************************/

oItens := oJson:ITEMS
FOR nX := 1 TO LEN(oItens)

   /****************************
   Valida o C�digo do Produto
   ****************************/
   DBSELECTAREA("SB1")
   SB1->(DBSETORDER(1))
   IF !SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(oItens[nX]:UB_PRODUTO)))
			_cRetorno := '{"CODRET":"01","DESCRET":"UM OU MAIS PRODUTOS NAO CADASTRADOS NO PROTHEUS. '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
   ELSE
		//// Verifica se o produto est� DESATIVADO
		IF SB1->B1_XDESAT == "2"
			_cRetorno := '{"CODRET":"01","DESCRET":"UM OU MAIS PRODUTOS DESATIVADOS NO PROTHEUS.'+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
   ENDIF


   /****************************
   Valida se a quantiade � maior que ZERO
   ****************************/
   IF oItens[nX]:UB_QUANT <= 0 
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"QUANTIDADE ZERADA. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
   ENDIF

   /****************************
   Valida se a chave GUID est� preenchida
   ****************************/
   IF EMPTY(oItens[nX]:UB_XGUID)
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"PRODUTO COM CHAVE GUID EM BRANCO. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
   ENDIF
NEXT


/****************************
Alimenta a tabela Z98 com as informa��es
****************************/
DBSELECTAREA("Z98")
Z98->(DBSETORDER(1))
IF Z98->(DBSEEK(XFILIAL("Z98")+"1"+ALLTRIM(oJson:UA_XGUID)))

  //// Se Achou uma chamada limpa os campos de envio ao CRM
  RECLOCK("Z98",.F.)
	Z98->Z98_TIPO   := "1"
  Z98->Z98_XGUID  := ALLTRIM(oJson:UA_XGUID)
  Z98->Z98_DTREC  := DATE()
  Z98->Z98_HRREC  := SUBSTR(TIME(),1,5)
  Z98->Z98_JSREC  := ALLTRIM(_cJson)
  Z98->Z98_DTENV  := STOD("")
  Z98->Z98_HRENV  := "" 
  Z98->Z98_JSENV  := "" 
  Z98->Z98_STATUS := "0"
  Z98->(MSUNLOCK())
ELSE
  RECLOCK("Z98",.T.)
	Z98->Z98_FILIAL := XFILIAL("Z98")
  Z98->Z98_TIPO   := "1"
  Z98->Z98_XGUID  := ALLTRIM(oJson:UA_XGUID)
  Z98->Z98_DTREC  := DATE()
  Z98->Z98_HRREC  := SUBSTR(TIME(),1,5)
  Z98->Z98_JSREC  := ALLTRIM(_cJson)
  Z98->Z98_STATUS := "0"
  Z98->(MSUNLOCK())
ENDIF

//// Retorna para API
_cRetorno := '{"CODRET":"00","DESCRET":"Aguarde Processamento..."' + '}'
::SetResponse(_cRetorno)

/*************************************
Chama a fun��o STCRM007 - JOB para atualiza��o dos Pre�os do Consulta Pre�os CRM
*************************************/
CONOUT("[STCRM003] - Chamando o  StarJob STCRM07A")
StartJob("U_STCRM07A",GetEnvserver(),.F.,Z98->(RECNO()),cChaveCli)

/*********************************
Grava o in�cio do processamento
*********************************/
CONOUT("[STCRM003] - CONSCOTACOES - Fim da grava��o do Json na tabela Z98 "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" - registro:"+ALLTRIM(oJson:UA_XGUID))

RETURN .T.

/*********************************************************
Cadastro de cota��es CRM x Protheus

Endere�o REST Homologa��o http://rest-p12.steck.com.br:9997/rest/cadcotacoes
Endere�o REST Desenvolvimento http://rest-p12.steck.com.br:9095/rest/cadcotacoes
*********************************************************/
WSRESTFUL cadCotacoes DESCRIPTION "Cadastrar Cota��es"
WSMETHOD POST DESCRIPTION "Cadastrar Cota��es" WSSYNTAX "/rest/cadCotacoes"
END WSRESTFUL

/************************************
M�TODO POST:
************************************/
WSMETHOD POST WSSERVICE cadCotacoes
LOCAL nX     := 0
LOCAL _lRet  := .F.
LOCAL _cJson := ""
LOCAL _cRetorno
LOCAL _nTotal:=0
LOCAL cRet   :=""
LOCAL cChaveCli:=""
LOCAL nToler := SuperGetMV("ST_TOLECRM",.F.,5)


oJson	 := NIL	//// Deve clarar sel ser local ou private
oItens := NIL //// Deve clarar sel ser local ou private

/*************************************************************************************************************************
C�digos de retorno para Nectar:
'{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
'{"CODRET":"01","DESCRET":"CLIENTE NAO ENCONTRADO"}'
'{"CODRET":"01","DESCRET":"TIPO ENTREGA (UA_XTIPOPV) INVALIDA, PRECISA SER IGUAL A 1 OU 2"}'
'{"CODRET":"01","DESCRET":"TIPO FRETE (UA_TPFRETE) INVALIDO, ENTREGA PRECISA SER C, F, T ou S"}'		
'{"CODRET":"01","DESCRET":"VALIDACAO INTERNA PROTHEUS RETORNOU FALSO - U_STVLDTRA: '+ _cMsgRet + '"}'
'{"CODRET":"01","DESCRET":"CONDICAO PAGTO NAO CADASTRADA"}'
'{"CODRET":"01","DESCRET":' + '"'+ cMsgInvld + '"' + '}'
'{"CODRET":"01","DESCRET":"ORCAMENTO NAO LOCALIZADO"}'
'{"CODRET":"01","DESCRET":' + '"Pedido: '+ SUA->UA_NUMSC5 + ' Ja Gerado para este orcamento: ' + SUA->UA_NUM + '"' +  '}'
'{"CODRET":"01","DESCRET":' + '"Este orcamento foi cancelado: ' + SUA->UA_NUM + '"' +  '}'				
'{"CODRET":"01","DESCRET":' + '"Pedido: '+ SC5->C5_NUM + ' Ja Gerado para este orcamento: ' + SUA->UA_NUM + '"' +  '}'
'{"CODRET":"01","DESCRET":"CONTATO NAO LOCALIZADO"}'
'{"CODRET":"01","DESCRET":"TRANSPORTADORA NAO CADASTRADA"}'
'{"CODRET":"01","DESCRET":"PARA OPERACAO 1-FATURAMENTO, ENVIAR CAMPO UA_TRANSP (TRANSPORTADORA)"}'
'{"CODRET":"01","DESCRET":' + '"Ja existe uma sessao [STCRM003][CADCOTACOES] Em Processamento"}'
'{"CODRET":"01","DESCRET":' + '"Orcamento Possui Pedido de Venda Gerado, Alteracao Nao Permitida"' +  '}'
'{"CODRET":"01","DESCRET":"CAMPO(S) OBRIGATORIO(S) NAO RECEBIDO PELO JSON",' + '"CAMPOS":' + '"' + cVazio + '"' + '}'
'{"CODRET":"01","DESCRET":"CODIGO(S) PRODUTO(S) INVALIDO(S): ' + cMsgProd + '"' + '}'
'{"CODRET":"01","DESCRET":"CODIGO(S) PRODUTO(S) DESATIVADO(S): ' + cMsgProd + '"' + '}'
'{"CODRET":"01","DESCRET":"QTDE OU PRECO MENOR OU IGUAL A ZERO."' + '}'
'{"CODRET":"01","DESCRET":"VALOR TOTAL ORCAMENTO MENOR QUE O VALOR MINIMO DA COND.PAGTO."' + '}'
*************************************************************************************************************************/
::SetContentType("application/json") 
_cJson := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")  
_lRet := FWJsonDeserialize(FwNoAccent(_cJson),@oJson)

/*********************************
Valida o Json recebido.
*********************************/
IF _lRet = .F. 
	_cRetorno := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o do Cliente
*********************************/
cRet:=U_ValidaCli(ALLTRIM(oJson:CNPJ))
IF cRet=='X'
	_cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE NAO ENCONTRADO"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ELSEIF cRet=='B'   
	_cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE BLOQUEADO "}'
	::SetResponse(_cRetorno)
	RETURN .T.
ELSE 
   SA1->(DBSETORDER(1))    
   IF ! SA1->(DBSEEK(XFILIAL("SA1")+cRet))
  	  _cRetorno := '{"CODRET":"01","DESCRET":"CLIENTE N�O ENCONTRADO NO PROTHEUS"}'
	  ::SetResponse(_cRetorno)
	  RETURN .T.
   ELSE 
      cChaveCli:=cRet
   ENDIF
ENDIF   


/********************************
Verifica se Mandou o Tipo de Opera��o = "1" - Faturamento mas n�o enviou o UA_NUM
********************************/
IF TYPE("oJson:UA_NUM") <> "U" .AND. ALLTRIM(oJson:UA_OPER) = "1"
	IF EMPTY(oJson:UA_NUM) .AND. ALLTRIM(oJson:UA_OPER) = "1"
		_cRetorno := '{"CODRET":"01","DESCRET": "PARA O TIPO DE OPERACAO 1 - FATURAMENTO E NECESSARIO O ENVIO DO NUMERO DO ORCAMENTO"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF
ELSEIF TYPE("oJson:UA_NUM") = "U" .AND. ALLTRIM(oJson:UA_OPER) = "1"
	_cRetorno := '{"CODRET":"01","DESCRET": "PARA O TIPO DE OPERACAO 1 - FATURAMENTO E NECESSARIO O ENVIO DO NUMERO DO ORCAMENTO"'+'}'
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*****************************
Verifica se existe algum or�amento cadastrado com UA_XGUID
Esta Verifica��o serve para caso o campo UA_NUM (N�mero do Or�amento)
 venha em branco e j� existir algum or�amento cadastrado com a mesma UA_XGUID
Neste caso houve um erro por parte do CRM
1 - Verifica se o or�amento informado exsite no sistema.
2 - Verifica se o ro�amento j� possui Pedido de Venda Gerado para ele
3 - Verifica se o or�amento est� CANCELADO
4 - Verifica se mandou o UA_NUM valida se o UA_XGUID pertence ao or�amento informado
*****************************/
DBSELECTAREA("SUA")
DBOrderNickname("XGUID")
IF SUA->(DBSEEK(XFILIAL("SUA")+ALLTRIM(oJson:UA_XGUID)))

	/**********************************
	Valida se o UA_NUM foi iformado, se foi, verifica se pertence a mesma UA_XGUID informada.
	**********************************/
	IF TYPE("oJson:UA_NUM") <> "U"
		IF ALLTRIM(SUA->UA_NUM) <> ALLTRIM(oJson:UA_NUM)
			_cRetorno := '{"CODRET":"01","DESCRET":' + '"Ja exite um Orcamento cadastrado para esta UA_XGUID. Orcamento cadastrado: '+SUA->UA_NUM+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
	ELSEIF TYPE("oJson:UA_NUM") == "U" .AND. ALLTRIM(oJson:UA_OPER) = "2" // Inclus�o 
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"Ja exite um Orcamento cadastrado para esta UA_XGUID. Orcamento cadastrado: '+SUA->UA_NUM+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF


	/***********************************
	Achou o or�amento, agora efetua as outras valida��es
	***********************************/
	IF !EMPTY(SUA->UA_NUMSC5) .OR. SUA->UA_OPER == "1"
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"Pedido: '+ SUA->UA_NUMSC5 + ' Ja Gerado para este orcamento: ' + SUA->UA_NUM + '"' +  '}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF

	/***********************************
	Verifica se est� cancelado
	***********************************/
	IF ALLTRIM(SUA->UA_STATUS)=="CAN"
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"Este orcamento foi cancelado: ' + SUA->UA_NUM + '"' +  '}'				
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF

	/*******************************
	For�a a valida��o se existe um pedido de venda gerado para o or�amento
	*******************************/
	DBSELECTAREA("SC5")
	SC5->(DBSETORDER(11))
	IF SC5->(DBSEEK(SUA->UA_FILIAL+SUA->UA_NUM))
		_cRetorno := '{"CODRET":"01","DESCRET":' + '"Pedido: '+ SC5->C5_NUM + ' Ja Gerado para este orcamento: ' + SUA->UA_NUM + '"' +  '}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF

	/********************************
	Verifica se existe algum pedido de venda gerado para algum dos itens do or�amento
	Caso exista n�o deixa continuar
	********************************/
	cQuery := "SELECT COUNT(*) QTD "
	cQuery += "FROM "+RetSqlName("SUB")+" UB  WHERE UB.D_E_L_E_T_=' ' "
	cQuery += "AND UB.UB_FILIAL = '"+XFILIAL("SUB")+"' AND UB.UB_NUM = '"+SUA->UA_NUM+"' "
	cQuery += "AND UB.UB_NUMPV <> ' ' "
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSUB', .F., .T.)
	IF TSUB->QTD > 0 
		_cRetorno := '{"CODRET":"01","DESCRET":"ESTE OR�AMENTO POSSUIEM ITENS COM PEDIDO DE VENDA GERADO, ALTERACAO NAO PERMITIDA"}'
		::SetResponse(_cRetorno)
		TSUB->(DBCLOSEAREA())
		RETURN .T.
	ENDIF
	TSUB->(DBCLOSEAREA())
ENDIF

/************************************
Verifica se Existe um or�amento cadastrado com esse n�mero mas pro algum motivo n�o possui UA_XGUID gravado na SUA
************************************/
IF TYPE("oJson:UA_NUM") <> "U"
	DBSELECTAREA("SUA")
	SUA->(DBSETORDER(1))
	IF !SUA->(DBSEEK(XFILIAL("SUA")+ALLTRIM(oJson:UA_NUM)))
			_cRetorno := '{"CODRET":"01","DESCRET":"Orcamento nao encontrado no sistema: "'+ALLTRIM(oJson:UA_NUM)+'}'
			::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF
ENDIF

/*********************************
Valida��o do Tipo de Entrega
*********************************/
IF !ALLTRIM(oJson:UA_XTIPOPV) $ "1/2"
	_cRetorno := '{"CODRET":"01","DESCRET":"TIPO ENTREGA (UA_XTIPOPV) INVALIDA, PRECISA SER IGUAL A 1 OU 2"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o do Tipo do Frete
*********************************/
IF EMPTY(oJson:UA_TPFRETE) .OR. !UPPER(oJson:UA_TPFRETE) $ "C/F/T/S"
	_cRetorno := '{"CODRET":"01","DESCRET":"TIPO FRETE (UA_TPFRETE) INVALIDO, ENTREGA PRECISA SER C, F, T ou S"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o do Tipo de Opera��o
UA_OPER:
 1 - Faturamento
 2 - Orcamento
 3 - Atendimento 
*********************************/
IF EMPTY(oJson:UA_OPER) .OR. !ALLTRIM(oJson:UA_OPER) $ "1/2/3"
	_cRetorno := '{"CODRET":"01","DESCRET":"TIPO DA ORPE��O N�O INFORMADA CORRETAMENTE (UA_OPER)"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ENDIF

/*********************************
Valida��o da Transportadora
Somente ser� necess�rio a transportadora se a opera��o UA_OPER for igual a "1" - faturamento
*********************************/
IF ALLTRIM(oJson:UA_OPER) = "1"

	DBSELECTAREA("SA4")
	SA4->(DBSETORDER(1))
	IF SA4->(DBSEEK(XFILIAL("SA4")+ALLTRIM(oJson:UA_TRANSP)))

		/*******************************
		Chama fun��o customizada para validar a transportadora
		*******************************/
		IF U_STVLDTRA(ALLTRIM(oJson:UA_TRANSP),;
									ALLTRIM(oJson:UA_XTIPOPV),;
									ALLTRIM(oJson:UA_TPFRETE),;
									IIF(!EMPTY(SA1->A1_ESTE), SA1->A1_ESTE, SA1->A1_EST),;
									SA1->A1_COD_MUN, @_cRetorno) = .F.

			_cRetorno := '{"CODRET":"01","DESCRET":"VALIDACAO INTERNA PROTHEUS RETORNOU FALSO - U_STVLDTRA: '+_cRetorno+ '"}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
	ELSE
		_cRetorno := '{"CODRET":"01","DESCRET":"TRANSPORTADORA NAO CADASTRADA"}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF
ENDIF

_nTotal:=0
/********************************
Varre os itens do Objeto
********************************/
oItens := oJson:ITEMS
FOR nX := 1 TO LEN(oItens)

  /****************************
  Valida o C�digo do Produto
  ****************************/
	DBSELECTAREA("SB1")
  SB1->(DBSETORDER(1))
  IF !SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(oItens[nX]:UB_PRODUTO)))
			_cRetorno := '{"CODRET":"01","DESCRET":"PRODUTO NAO CADASTRADO NO PROTHEUS.  PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
	ELSE
		//// Verifica se o produto est� DESATIVADO
		IF SB1->B1_XDESAT == "2"
			_cRetorno := '{"CODRET":"01","DESCRET":"PRODUTO DESATIVADO NO PROTHEUS. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
  ENDIF

  /****************************
  Valida se a quantiade � maior que ZERO
  ****************************/
  IF oItens[nX]:UB_QUANT <= 0 
		_cRetorno := '{"CODRET":"01","DESCRET":"PRODUTO COM QUANTIDADE ZERADA. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
  ENDIF

  /****************************
  Valida se a chave GUID est� preenchida
  ****************************/
  IF EMPTY(oItens[nX]:UB_XGUID)
		_cRetorno := '{"CODRET":"01","DESCRET":"PRODUTO COM A CHAVE UB_XGUID EM BRANCO. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
  ENDIF

  /****************************
  Valida se o Valor � maior que ZERO
  ****************************/
  IF oItens[nX]:UB_VRUNIT <= 0 
		_cRetorno := '{"CODRET":"01","DESCRET":"PRODUTO COM O VALOR ZERADO. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
		::SetResponse(_cRetorno)
		RETURN .T.
  ENDIF

  /****************************
  Valida se o or�amento � para gerar um pedido de venda
	Regras: 
	1 - Se for informado o N�mero do Pedido de Compra obrigatoriamente o Item deve ser informado
	2 - Se for informado o Item do Pedido de Compra obrigatoriamente o N�mero deve ser informado
	UB_NUMPCOM
  UB_ITEMPC
  UB_XORDEM
  ****************************/
  IF ALLTRIM(oJson:UA_OPER) = "1"
		IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_NUMPCOM") <> "U" .AND. TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_ITEMPC") = "U"
			_cRetorno := '{"CODRET":"01","DESCRET":"ITEM DO PEDIDO DE COMPRA NAO INFORMADO. PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ELSEIF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_NUMPCOM") = "U" .AND. TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_ITEMPC") <> "U"
			_cRetorno := '{"CODRET":"01","DESCRET":"ITENM SEM O NUMERO DO PEDIDO DE COMPRA NAO INFORMADO PRODUTO: '+ALLTRIM(oItens[nX]:UB_PRODUTO)+'"'+'}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
	ENDIF

  /****************************
  Valida a Quantidade M�nima para o item.
	<<<< REGRA EM AN�LISE SE FOR USAR SOMENTE TIRAR O COMENT�RIO >>>>>
  SB1->(DBSETORDER(1))
  IF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(oItens[nX]:UB_PRODUTO)))
		IF SB1->B1_XLM > oItens[nX]:UB_QUANT 
			nPos := 0
			nPos := aScan(aVetErro,{|x|UPPER(AllTrim(x[3])) == UPPER(ALLTRIM(oItens[nX]:UB_XGUID))})
			IF nPos = 0 
				AADD(aVetErro,{ALLTRIM(oItens[nX]:UB_PRODUTO),oItens[nX]:UB_QUANT,oItens[nX]:UB_XGUID,"QUANTIDADE INFERIOR AO PERMITIDO. MINIMO PERMITIDO: "+ALLTRIM(STR(SB1->B1_XLM))+" / "})
			ELSE
				aVetErro[nPos,4] += "QUANTIDADE INFERIOR AO PERMITIDO. MINIMO PERMITIDO: "+ALLTRIM(STR(SB1->B1_XLM))+" / "
			ENDIF
		ENDIF
	ENDIF
  ****************************/

/********************
Fim valida��o Itens
********************/
   _nTotal+=oItens[nX]:UB_QUANT * oItens[nX]:UB_VRUNIT

NEXT


/*********************************
Valida��o da Condi��o de Pagamento
*********************************/
DBSELECTAREA("SE4")
SE4->(DBSETORDER(1))
IF !SE4->(DBSEEK(XFILIAL("SE4")+ALLTRIM(oJson:UA_XCONDPG)))
  _cRetorno := '{"CODRET":"01","DESCRET":"CONDICAO PAGTO NAO CADASTRADA"}'
	::SetResponse(_cRetorno)
  RETURN .T.
ELSE
   IF ALLTRIM(oJson:UA_OPER)=="1" //Faturamento
	  If _nTotal<SE4->E4_XVLRMIN
         _cRetorno := '{"CODRET":"01","DESCRET":"O VALOR M�NIMO PARA VIRAR ESTE OR�AMENTO PARA PEDIDO � R$ '+cValToChar(SE4->E4_XVLRMIN)+'"'+'}'
	     ::SetResponse(_cRetorno)
		 RETURN .T.
      ENDIF 
   ENDIF
ENDIF   	   		 


/*****************************
Valida o campo do Contato 
****************************/
IF TYPE("oJson:UA_CODCONT") = "U"
	_cRetorno := '{"CODRET":"01","DESCRET":"INFORMAR O CAMPO DE CONTATO"}'
	::SetResponse(_cRetorno)
	RETURN .T.
ELSE
	IF !EMPTY(oJson:UA_CODCONT)
		DBSELECTAREA("SU5")
		SU5->(DBSETORDER(1))
		IF !SU5->(DBSEEK(XFILIAL("SU5")+ALLTRIM(oJson:UA_CODCONT)))
			_cRetorno := '{"CODRET":"01","DESCRET":"CONTATO NAO LOCALIZADO"}'
			::SetResponse(_cRetorno)
			RETURN .T.
		ENDIF
	ENDIF
ENDIF
	

/****************************
Alimenta a tabela Z98 com as informa��es
****************************/
DBSELECTAREA("Z98")
Z98->(DBSETORDER(1))
IF Z98->(DBSEEK(XFILIAL("Z98")+"2"+ALLTRIM(oJson:UA_XGUID)))
	// Ja existe um registro recebido a menos de 10 minutos - aguardar 
	IF TYPE("oJson:UA_NUM") == "U" .AND. ALLTRIM(oJson:UA_OPER) == "2" // Inclus�o 
       IF Z98->Z98_STATUS =='0' // Transa��o pendente de processamento. 
		     _cRetorno := '{"CODRET":"01","DESCRET":"EXISTE UMA REQUISICAO DE INCLUSAO PENDENTE PARA ESTE ID  '+ALLTRIM(Z98->Z98_XGUID)+' AGUARDAR ALGUNS MINUTOS!!"}'
		     ::SetResponse(_cRetorno)
		     RETURN .T.
	   ENDIF 		 
	ENDIF   

	//// Se Achou uma chamada limpa os campos de envio ao CRM
	RECLOCK("Z98",.F.)
	Z98->Z98_TIPO   := "2"
	Z98->Z98_XGUID  := ALLTRIM(oJson:UA_XGUID)
	Z98->Z98_DTREC  := DATE()
	Z98->Z98_HRREC  := SUBSTR(TIME(),1,5)
	Z98->Z98_JSREC  := ALLTRIM(_cJson)
	Z98->Z98_DTENV  := STOD("")
	Z98->Z98_HRENV  := "" 
	Z98->Z98_JSENV  := "" 
	Z98->Z98_STATUS := "0"
	Z98->Z98_SEQPRO := 0
	Z98->Z98_SEQAVI := 0
	Z98->(MSUNLOCK())
ELSE

	RECLOCK("Z98",.T.)
	Z98->Z98_FILIAL := XFILIAL("Z98")
	Z98->Z98_TIPO   := "2"
	Z98->Z98_XGUID  := ALLTRIM(oJson:UA_XGUID)
	Z98->Z98_DTREC  := DATE()
	Z98->Z98_HRREC  := SUBSTR(TIME(),1,5)
	Z98->Z98_JSREC  := ALLTRIM(_cJson)
	Z98->Z98_STATUS := "0"
	Z98->(MSUNLOCK())
ENDIF

_cRetorno := '{"CODRET":"OK","DESCRET":"Aguarde Processamento..."' + '}'
::SetResponse(_cRetorno)

/*************************************
Chama a fun��o STCRM08A - JOB para Inclus�o / Altera��o de Or�amento e Gera��o de Pedido de Venda.
*************************************/
CONOUT("[STCRM003] - Chamando o  StarJob STCRM08A")
StartJob("U_STCRM08A",GetEnvserver(),.F.,Z98->(RECNO()),cChaveCli)

RETURN .T.

//MAFISRET
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �STMAFISREL� Autor � Jo�o Victor           � Data �31/07/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Abre o MAFISRET para trazer os valores dos tributos        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � EspecIFico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function STMAFISREL(_cCodCli,_cLojCli,_cTipoCli,_cProduto,_nQuant,_nVrunit,_nVlrItem)
	MaFisSave()
	MaFisEnd()
	MaFisIni(	_cCodCli,; 	// 1-Codigo Cliente/Fornecedor
						_cLojCli,;	// 2-Loja do Cliente/Fornecedor
						"C",;				// 3-C:Cliente , F:Fornecedor
						"N",;				// 4-Tipo da NF
						_cTipoCli,; // 5-Tipo do Cliente/Fornecedor
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						"TMKA271")  // 10-Nome da rotina que esta utilizando a funcao

	
	MaFisAdd(	_cProduto,; // 1-Codigo do Produto ( Obrigatorio )
						_cTes,;     // 2-Codigo do TES ( Opcional )
						_nQuant ,;  // 3-Quantidade ( Obrigatorio )
						_nVrUnit,;  // 4-Preco Unitario ( Obrigatorio )
						0,;         // 5-Valor do Desconto ( Opcional )
						,;          // 6-Numero da NF Original ( Devolucao/Benef )
						,;          // 7-Serie da NF Original ( Devolucao/Benef )
						,;          // 8-RecNo da NF Original no arq SD1/SD2
						0,;         // 9-Valor do Frete do Item ( Opcional )
						0,;         // 10-Valor da Despesa do item ( Opcional )
						0,;         // 11-Valor do Seguro do item ( Opcional )
						0,;         // 12-Valor do Frete Autonomo ( Opcional )
						_nVlrItem,; // 13-Valor da Mercadoria ( Obrigatorio )
						0,;         // 14-Valor da Embalagem ( Opiconal )
						0,;         // 15-RecNo do SB1
						0)          // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	nValSuf		:= (MaFisRet(1,"IT_DESCZF",14,2)  )	   //Valor do suframa

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

Return
//Fim MAFISRET

/******************************
******************************/
STATIC FUNCTION xMafis(_xTES,_cCodCli,_cLojCli,_cTipoCli,_cProduto,_nQuant,_nVrunit,_nVlrItem)
MaFisSave()
MaFisEnd()
MaFisIni(	_cCodCli,;	// 1-Codigo Cliente/Fornecedor
					_cLojCli,;	// 2-Loja do Cliente/Fornecedor
					"C",;				// 3-C:Cliente , F:Fornecedor
					"N",;				// 4-Tipo da NF
					_cTipoCli,;	// 5-Tipo do Cliente/Fornecedor
					NIL,;
					NIL,;
					NIL,;
					NIL,;
					"MATA461")

MaFisAdd(	_cProduto,;	// 1-Codigo do Produto ( Obrigatorio )
					_xTES ,; 	 	// 2-Codigo do TES ( Opcional )
					_nQuant,;   // 3-Quantidade ( Obrigatorio )
					_nVrunit,;  // 4-Preco Unitario ( Obrigatorio )
					0,;         // 5-Valor do Desconto ( Opcional )
					,;          // 6-Numero da NF Original ( Devolucao/Benef )
					,;          // 7-Serie da NF Original ( Devolucao/Benef )
					,;          // 8-RecNo da NF Original no arq SD1/SD2
					0,;         // 9-Valor do Frete do Item ( Opcional )
					0,;         // 10-Valor da Despesa do item ( Opcional )
					0,;         // 11-Valor do Seguro do item ( Opcional )
					0,;         // 12-Valor do Frete Autonomo ( Opcional )
					_nVrunit,; 	// 13-Valor da Mercadoria ( Obrigatorio )
					0,;         // 14-Valor da Embalagem ( Opiconal )
					0,;         // 15-RecNo do SB1
					0)          // 16-RecNo do SF4

	
	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	nValSuf		:= (MaFisRet(1,"IT_DESCZF",14,2)  )	   //Valor do suframa

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

RETURN


/*====================================================================================\
|Programa  | VALIDACLI        | Autor | ANTONIO MOURA            | Data | 12/06/2023  |
|=====================================================================================|
|Descri��o | Valicar o cliente a partir do CNPJ                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
\====================================================================================*/

User Function ValidaCli(Cnpj)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local aArea    :=GetArea()
	Local cRet     :=""

	_cQuery1 := " SELECT A1_COD,A1_LOJA,A1_MSBLQL "
	_cQuery1 += " FROM "+RetSqlName("SA1")+" SA1 "
	_cQuery1 += " WHERE SA1.A1_FILIAL = '"+XFILIAL('SA1')+"' "
	_cQuery1 += "   AND SA1.A1_CGC ='"+CNPJ+"' "
	_cQuery1 += "   AND SA1.D_E_L_E_T_=' ' "
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	(_cAlias1)->(dbGoTop())
	IF (_cAlias1)->(!Eof())
	   While (_cAlias1)->(!Eof())
          IF (_cAlias1)->A1_MSBLQL<>'1'      
             cRet:=(_cAlias1)->A1_COD+(_cAlias1)->A1_LOJA
			 EXIT 
	      ENDIF	
		  (_cAlias1)->(DbSkip())
	   ENDDO 
	ELSE 
	    cRet:='X'
	ENDIF
    IF EMPTY(cRet)
       cRet:='B' 
	ENDIF 

	If !Empty(Select(_cAlias1))
	   DbSelectArea(_cAlias1)
	   (_cAlias1)->(dbCloseArea())
	Endif

    RestArea(aArea)

Return(cRet)
