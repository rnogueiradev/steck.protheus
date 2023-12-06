/**************************************** 
Função.......: STCRM008
Ação.........: JOB para inclusão de orçamento, atualização do orçamento e geração de pedido de venda enviado pelo CRM
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 15/08/2022
Chamado......: 20220727014715 - Integração de Cotações
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

USER FUNCTION STCRM008()
LOCAL nY := 0
LOCAL nThreads := ""
LOCAL nCount   := 0
LOCAL aVetZ98  := {}

PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

/***********************************
Busca na tabela Z98 todas consultas de preços pendentes
***********************************/
nThreads := SUPERGETMV("STCRM008",,99)
cQuery := "SELECT Z98.R_E_C_N_O_ AS Z98REC FROM "+RetSqlName("Z98")+" Z98 "
cQuery += "WHERE Z98.D_E_L_E_T_ = ' ' "
cQuery += "AND Z98.Z98_TIPO <> '1' AND Z98.Z98_STATUS = '0' "
cQuery += "ORDER BY Z98.Z98_DTREC "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ98', .F., .T.)
WHILE TZ98->(!EOF()) .AND. nCount <= nThreads
	nCount++
	AADD(aVetZ98,TZ98->Z98REC)
	TZ98->(DBSKIP())
ENDDO
TZ98->(DBCLOSEAREA())
	
/*************************************
Chama a função STCRM008A - JOB para Inclusão / Alteração de orçamento e Geração de Pedido de Venda
*************************************/
FOR nY := 1 TO LEN(aVetZ98)
	StartJob("U_STCRM08A",GetEnvserver(),.F.,aVetZ98[nY])
NEXT nY
	
RESET ENVIRONMENT

RETURN

USER FUNCTION STCRM08A(xRecZ98,cChaveCli)
LOCAL nX   := 0
LOCAL lRet := .F.
LOCAL _cArq  := ""
LOCAL _cDir  := ""
LOCAL	_cFile := ""
LOCAL _nOpc  := ""
LOCAL _nItem := "00"
LOCAL _cJson := ""
LOCAL _cErro := ""
LOCAL aCabec := {}
LOCAL aItens := {}
LOCAL aVetErro := {}
LOCAL aVetItem := {}
LOCAL nHdlXml  := 0
LOCAL cCodOper := ""
LOCAL cRotina  := ""
LOCAL _cRetorno := ""
PRIVATE _dDatProg := STOD("")
PRIVATE nRecZ98 := xRecZ98
PRIVATE _cLockBy  := ""
PRIVATE cMsgRet   := ""   // Alteração para receber as msg de alerta das validações pois o msgalert trava o processo no execauto
PRIVATE _cConsumo   := ""
PRIVATE lMsErroAuto := .F.

Default cChaveCli  :=""

RpcSetType(3)
RpcSetEnv( "11", "01",,,"FAT")

_cLockBy  := "STCRM008"+ALLTRIM(STR(nRecZ98))

IF !LockByName(_cLockBy,.F.,.F.,.T.)
	CONOUT("[STCRM008] - ERRO: Processo sendo executado por outra instância!")
	RETURN
ELSE

	oJson	 := NIL 	//// Deve clarar sel ser local ou private
	oItens := NIL //// Deve clarar sel ser local ou private

	/************************************
	Posiciona na tabela Z98
	************************************/
	Z98->(DBSETORDER(1))
	Z98->(DBGOTO(nRecZ98))
	CONOUT("[STCRM08A] - Inicio de processamento "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))

	/************************************
	Busca o Json gravado na tabela Z98 e transforma em objeto para inicar os trabalhos
	************************************/
	_cJson := ALLTRIM(Z98->Z98_JSREC)
	lRet := FWJsonDeserialize(FwNoAccent(_cJson),@oJson)

	IF lRet = .F.
		CONOUT("[STCRM08A] - Erro na montagem do ojeto. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
		RETURN .T.
	ENDIF

	/************************************
	Posiciona no Cadastro de Clinte
	************************************/
	IF ! Empty(cChaveCli)
	   SA1->(DBSETORDER(1))
	   IF !SA1->(DBSEEK(XFILIAL("SA1")+cChaveCli))
		  _cRetorno += 'Cliente nao encontrado no Protheus'
		  CONOUT("[STCRM08A] - Cliente nao encontrado no Protheus. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
		  RETURN .T.
	   ENDIF  
	ELSE 
       cRet:=U_ValidaCli(ALLTRIM(oJson:CNPJ))
       IF cRet=='X'
	      cErroCab += 'Cliente nao encontrado no Protheus'
	      CONOUT("[STCRM08A] - Cliente nao encontrado no Protheus. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
	      RETURN .T.
       ELSEIF cRet=='B'   
		  cErroCab += 'Cliente bloqueado'
		  CONOUT("[STCRM08A] - Cliente Bloqueado. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
	      RETURN .T.
       ELSE 
          SA1->(DBSETORDER(1))    
          SA1->(DBSEEK(XFILIAL("SA1")+cRet))
	   ENDIF	  
	ENDIF 


	/************************************
	Verifica se o cliente se encontra bloqueado
	************************************/
	//IF SA1->A1_MSBLQL = "1"
	//	_cRetorno += ' - Cliente Bloqueado no Protheus'
	//ENDIF

	/************************************
	Passa o consumo para carregar a TES
	Se o Tipo do Cliente for Consumidor final "SA1->A1_TIPO = 'F'" passa o tipo de Consumo
	************************************/
	IF TYPE("oJson:UA_ZCONSUM") <> "U"
		//IF SA1->A1_TIPO = 'F'
			_cConsumo := oJson:UA_ZCONSUM
		//ENDIF
	ENDIF

	/**************************************
	Alimenta o objeto de Itens do orçamento
	**************************************/
	oItens := oJson:ITEMS

	/************************************
	Verifica se enviou a Data Programada 
	Se enviou valida se a Data é Valida antes de gerar o orçamento
	************************************/
	IF TYPE("oJson:UA_XDTENPR") <> "U"
		IF !EMPTY(STOD(ALLTRIM(oJson:UA_XDTENPR)))
			_cRetorno += STCRM08B(STOD(ALLTRIM(oJson:UA_XDTENPR)),oItens)
		ENDIF
	ENDIF

	/************************************
	Valida se encontrou algum erro não processa
	************************************/
	IF !EMPTY(_cRetorno)

		_cJson := '{'+;
		'"statuscode": 279440007,'+; //// 279440004
		'"statecode": 1,'+;
		'"nec_erroprotheus":'+'"'+ALLTRIM(_cRetorno)+'"'+'}'

		/**************************************
		Chama a Rotina de Conexão com o CRM
		**************************************/
		lRet := .F.
		lRet := U_PatchNectar(_cJson,ALLTRIM(oJson:UA_XGUID))
		
		/**********************************
		Manda e-mail caso não conectar ao Nectar
		**********************************/
		IF lRet = .F.
			//SENDEMAIL("Erro ao conectar ao CRM - Inclusão/Alteração Orçamento. UA_XGUID: "+ALLTRIM(oJson:UA_XGUID))
		ENDIF
		
		Z98->(DBSETORDER(1))
		Z98->(DBGOTO(nRecZ98))
		RECLOCK("Z98",.F.)
		Z98->Z98_DTENV  := DATE()
		Z98->Z98_HRENV  := SUBSTR(TIME(),1,5)
		Z98->Z98_JSENV  := IIF(lRet = .T.,_cJson,"ERRO AO CONECTAR AO CRM - "+_cJson)
		Z98->Z98_STATUS := IIF(lRet = .T.,"1","0")
		Z98->(MSUNLOCK())
		RETURN .T.
	ENDIF

	/*******************************************
	Regras para o tipo de operação do orçamento

	<<<<<< CADASTRO DE COTAÇÃO >>>>>
	UA_NUM...: " " - Campo em Branco
	UA_OPER..: "2" - Orcamento

	<<<<<< ATUALIZAÇÃO DA COTAÇÃO >>>>>
	UA_NUM...: "999999" - Vem preenchido com o código do orçamento
	UA_OPER..: "2" - Orcamento

	<<<<<< GERAÇÃO DO PEDIDO DE VENDA >>>>>
	UA_NUM...: "999999" - Vem preenchido com o código do orçamento
	UA_OPER..: "1" - Faturamento
	********************************************/
	IF TYPE("oJson:UA_NUM") <> "U"
		IF EMPTY(oJson:UA_NUM) .AND. ALLTRIM(oJson:UA_OPER) = "2"
			_nOpc := 3
			_cOper := "2"
		ELSEIF !EMPTY(oJson:UA_NUM) .AND. ALLTRIM(oJson:UA_OPER) = "2"
			_nOpc := 4
			_cOper := "2"
		ELSEIF !EMPTY(oJson:UA_NUM) .AND. ALLTRIM(oJson:UA_OPER) = "1"
			_nOpc := 4
			_cOper := "1"
		ENDIF
	ELSE
		/*******************************************
		Caso não tenham declarado o Número do Orçamento no Json.
		- Se o tipo da operação for "2" será considerado como uma inclusão de orçamento.
		- Se o tipo da operação for "1" será feita a inclusão do orçamento já com a efetivação do pedido de venda.
		*******************************************/
		IF ALLTRIM(oJson:UA_OPER) = "2"
			_nOpc := 3
			_cOper := "2"
		ELSEIF ALLTRIM(oJson:UA_OPER) = "1"
			_nOpc := 3
			_cOper := "1"
		ENDIF
	ENDIF

	If _nOpc==3
		
		_cAlias1 := GetNextAlias()

		_cQuery1 := " SELECT UA_NUM
		_cQuery1 += " FROM "+RetSqlName("SUA")+" UA
		_cQuery1 += " WHERE UA.D_E_L_E_T_=' '  
		_cQuery1 += " AND UA_FILIAL='"+xFilial("SUA")+"' AND UA_XGUID='"+AllTrim(oJson:UA_XGUID)+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())
			_cRetorno += " - Orçamento já existe no ERP, número "+(_cAlias1)->UA_NUM
		EndIf

		(_cAlias1)->(DbCloseArea())

	EndIf

	/****************************************
	Força a o código do usuário como Administrador para pegar o código do Operador
	****************************************/
	__cUserId := "000000"
	cCodOper  := POSICIONE("SU7",4,XFILIAL("SU7")+__cUserId,"U7_COD")

	/****************************************
	Posiciona na tabe de Contatos
	****************************************/
	cCodCont  := POSICIONE("SU5",1,XFILIAL("SU5")+ALLTRIM(oJson:UA_CODCONT),"U5_CODCONT")

	AADD(aCabec,{"UA_FILIAL"  ,XFILIAL("SUA")						,NIL})
	AADD(aCabec,{"UA_CLIENTE" ,SA1->A1_COD							,NIL})
	AADD(aCabec,{"UA_LOJA"    ,SA1->A1_LOJA							,NIL})
	AADD(aCabec,{"UA_OPERADO" ,cCodOper									,NIL})
	AADD(aCabec,{"UA_TIPOCLI" ,SA1->A1_TIPO							,NIL})
	AADD(aCabec,{"UA_XORIG"   ,"4"											,NIL})	// 4 - Orçamento enviado pelo CRM
	AADD(aCabec,{"UA_CODCONT" ,cCodCont									,NIL})
	AADD(aCabec,{"UA_DESCNT"  ,SU5->U5_CONTAT						,NIL})
	AADD(aCabec,{"UA_XEMLSZR" ,ALLTRIM(SU5->U5_EMAIL)		,NIL})
	AADD(aCabec,{"UA_TMK"     ,"1"											,NIL})	// Tipo de Marketing 	1=Receptivo;2=Ativo;3=Fax;4=Representante
	AADD(aCabec,{"UA_CONDPG"  ,ALLTRIM(oJson:UA_XCONDPG),NIL})	// grava a mesma condição de pagamento do campo customizado, no campo padrão
	AADD(aCabec,{"UA_XCONDPG" ,ALLTRIM(oJson:UA_XCONDPG),NIL})	// grava a mesma condição de pagamento do campo customizado, no campo padrão
	AADD(aCabec,{"UA_ZCONSUM" ,ALLTRIM(oJson:UA_ZCONSUM),NIL})
	AADD(aCabec,{"UA_TPFRETE" ,ALLTRIM(oJson:UA_TPFRETE),NIL})
	AADD(aCabec,{"UA_XTIPFAT" ,ALLTRIM(oJson:UA_XTIPFAT),NIL})
	AADD(aCabec,{"UA_XTIPOPV" ,ALLTRIM(oJson:UA_XTIPOPV),NIL})
	AADD(aCabec,{"UA_OPER" 	  ,ALLTRIM(oJson:UA_OPER)		,NIL})  //- Tipo de Operacao: 1 = Faturamento; 2 = Orcamento; 3 = Atendimento
	AADD(aCabec,{"UA_XGUID"   ,ALLTRIM(oJson:UA_XGUID)	,NIL})
	AADD(aCabec,{"UA_TRANSP"   ,ALLTRIM(oJson:UA_TRANSP),NIL})

	IF TYPE("oJson:UA_XMOTDES") <> "U"
		AADD(aCabec,{"UA_XMOTDES",ALLTRIM(oJson:UA_XMOTDES),NIL})
	ENDIF
	IF TYPE("oJson:UA_NUM") <> "U"
		AADD(aCabec,{"UA_NUM",ALLTRIM(oJson:UA_NUM),NIL})
	ENDIF
	IF TYPE("oJson:UA_VEND2") <> "U"
		AADD(aCabec,{"UA_VEND2",ALLTRIM(oJson:UA_VEND2),NIL})
	ENDIF
	IF TYPE("oJson:UA_ENDENT") <> "U"
		AADD(aCabec,{"UA_ENDENT",ALLTRIM(oJson:UA_ENDENT),NIL})
	ENDIF
	IF TYPE("oJson:UA_BAIRROE") <> "U"
		AADD(aCabec,{"UA_BAIRROE",ALLTRIM(oJson:UA_BAIRROE),NIL})
	ENDIF
	IF TYPE("oJson:UA_CEPE") <> "U"
		AADD(aCabec,{"UA_CEPE",ALLTRIM(oJson:UA_CEPE),NIL})
	ENDIF
	IF TYPE("oJson:UA_ESTE") <> "U"
		AADD(aCabec,{"UA_ESTE",ALLTRIM(oJson:UA_ESTE),NIL})
	ENDIF
	IF TYPE("oJson:UA_MUNE") <> "U"
		AADD(aCabec,{"UA_MUNE",ALLTRIM(oJson:UA_MUNE),NIL})
	ENDIF
	IF TYPE("oJson:UA_XORDEM") <> "U"
		AADD(aCabec,{"UA_XORDEM",ALLTRIM(oJson:UA_XORDEM),NIL})
	ENDIF
	IF TYPE("oJson:UA_ZOBS") <> "U"
		AADD(aCabec,{"UA_ZOBS",ALLTRIM(oJson:UA_ZOBS),NIL})
	ENDIF
	IF TYPE("oJson:UA_CODOPOR") <> "U"
		AADD(aCabec,{"UA_CODOPOR",ALLTRIM(oJson:UA_CODOPOR),NIL})
	ENDIF
	IF TYPE("oJson:UA_NOMOPOR") <> "U"
		AADD(aCabec,{"UA_NOMOPOR",ALLTRIM(oJson:UA_NOMOPOR),NIL})
	ENDIF
	IF TYPE("oJson:UA_CODOBRA") <> "U"
		AADD(aCabec,{"UA_CODOBRA",ALLTRIM(oJson:UA_CODOBRA),NIL})
	ENDIF
	IF TYPE("oJson:UA_NOMOBRA") <> "U"
		AADD(aCabec,{"UA_NOMOBRA",ALLTRIM(oJson:UA_NOMOBRA),NIL})
	ENDIF

	IF TYPE("oJson:UA_XCODMUN") <> "U"
		AADD(aCabec,{"UA_XCODMUN",ALLTRIM(oJson:UA_XCODMUN),NIL})
	ENDIF
	/**************************************
	Ordena o vetor pela ordem do dicionário
	**************************************/
	aCabec := FWVetByDic(aCabec,"SUA",.F.,1)

	/**************************************
	<<<<<<<< ALTERAÇÃO DE ORÇAMENTO >>>>>>>
	**************************************/
	IF _nOpc = 4

		/**************************************
		Caso seja um alteração do orçamento, carraga todos os itens no vetor auxiliar e marca como deletado. 
		**************************************/
		SUB->(DBSETORDER(1))
		IF SUB->(DBSEEK(XFILIAL("SUB")+ALLTRIM(oJson:UA_NUM)))
			WHILE SUB->(!EOF()) .AND. SUB->UB_FILIAL = XFILIAL("SUB") .AND. ALLTRIM(SUB->UB_NUM) = ALLTRIM(oJson:UA_NUM)
				aVetItem := {}
				AADD(aVetItem,{"UB_ITEM"  	,SUB->UB_ITEM  	,NIL})
				AADD(aVetItem,{"UB_FILIAL" 	,SUB->UB_FILIAL ,NIL})
				AADD(aVetItem,{"UB_PRODUTO"	,SUB->UB_PRODUTO,NIL})
				AADD(aVetItem,{"UB_QUANT" 	,SUB->UB_QUANT 	,NIL})
				AADD(aVetItem,{"UB_VRUNIT"	,SUB->UB_VRUNIT	,NIL})
				AADD(aVetItem,{"UB_OPER"   	,SUB->UB_OPER   ,NIL})
				AADD(aVetItem,{"UB_TES"   	,SUB->UB_TES   	,NIL})
				AADD(aVetItem,{"UB_XGUID"   ,SUB->UB_XGUID  ,NIL})
				AADD(aVetItem,{"UB_XPORDEC"	,SUB->UB_XPORDEC,NIL})
				AADD(aVetItem,{"UB_XACREPO"	,SUB->UB_XACREPO,NIL})
				AADD(aVetItem,{"UB_UM"			,SUB->UB_UM			,NIL})
				AADD(aVetItem,{"UB_NUMPCOM"	,SUB->UB_NUMPCOM,NIL})
				AADD(aVetItem,{"UB_ITEMPC"	,SUB->UB_ITEMPC	,NIL})
				AADD(aVetItem,{"UB_XORDEM"	,SUB->UB_XORDEM	,NIL})
					AADD(aVetItem,{"AUTDELETA"	,"S"        		,Nil})
				AADD(aItens, aVetItem)
				_nItem := aVetItem[1,2]
				SUB->(DBSKIP())
			ENDDO
		ENDIF
	ELSE
		_nItem := "00"
	ENDIF

	_nItem := "00" //Sempre começa os itens novos partindo do 01

	/**************************************
	Alimenta o Vetor de Itens do orçamento
	**************************************/
		FOR nX := 1 TO LEN(oItens)

			aVetItem := {}
			_nItem := SOMA1(_nItem,2)
			
			AADD(aVetItem,{"UB_ITEM"  	,_nItem															,NIL})
			AADD(aVetItem,{"UB_FILIAL" 	,XFILIAL("SUB")											,NIL})
			AADD(aVetItem,{"UB_PRODUTO"	,ALLTRIM(oItens[nX]:UB_PRODUTO)			,NIL})
			AADD(aVetItem,{"UB_QUANT" 	,oItens[nX]:UB_QUANT								,NIL})
			AADD(aVetItem,{"UB_VRUNIT"	,oItens[nX]:UB_VRUNIT								,NIL})
			AADD(aVetItem,{"UB_XGUID"   ,ALLTRIM(oItens[nX]:UB_XGUID)				,NIL})
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_XPORDEC") <> "U"
				AADD(aVetItem,{"UB_XPORDEC",oItens[nX]:UB_XPORDEC,NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_XACREPO") <> "U"
				AADD(aVetItem,{"UB_XACREPO",oItens[nX]:UB_XACREPO,NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_UM") <> "U"
				AADD(aVetItem,{"UB_UM",ALLTRIM(oItens[nX]:UB_UM),NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_NUMPCOM") <> "U"
				AADD(aVetItem,{"UB_NUMPCOM",ALLTRIM(oItens[nX]:UB_NUMPCOM),NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_ITEMPC") <> "U"
				AADD(aVetItem,{"UB_ITEMPC",ALLTRIM(oItens[nX]:UB_ITEMPC),NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_XORDEM") <> "U"
				AADD(aVetItem,{"UB_XORDEM",ALLTRIM(oItens[nX]:UB_XORDEM),NIL})
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_OPER") <> "U"
				AADD(aVetItem,{"UB_OPER",ALLTRIM(oItens[nX]:UB_OPER),NIL})
			ENDIF

			/**************************************
			Ordena o vetor pela ordem do dicionário
			**************************************/
			aVetItem := FWVetByDic(aVetItem,"SUB",.F.,1)
			AADD(aItens, aVetItem)
		NEXT

	/*******************************
	Força a troca do usuário para Adminstrador
	*******************************/
	__cUserId := '000000'

	/*****************************
	Taratemnto para a rotina de Orçamento
	Se for alteração força o posicionamento no orçamento correto
	*****************************/
	IF _nOpc = 4
		DBSELECTAREA("SUA")
		DBOrderNickname("XGUID")
		SUA->(DBSEEK(XFILIAL("SUA")+ALLTRIM(oJson:UA_XGUID)))
	ENDIF
	n := LEN(aItens)
	SetModulo("SIGATMK",'TMK')
	cRotina := "2"

	_cGuid := oJson:UA_XGUID

	/*****************************
	Chama o execauto do Orçamento
	*****************************/
	Begin Transaction 
	lMsErroAuto := .F.
	TMKA271(aCabec,aItens,_nOpc,cRotina)

	IF lMsErroAuto = .F.
		
		/******************************************
		Força o posicionamento da SUA
		******************************************/
		DBSELECTAREA("SUA")
		DBOrderNickname("XGUID")
		SUA->(DBSEEK(XFILIAL("SUA")+ALLTRIM(_cGuid)))

		/******************************************
		Força a atualização da data de entrega dos itens pois via execauto não está entrando no PE TK271BOK
		******************************************/
		IF !EMPTY(_dDatProg)
			DBSELECTAREA("SUB")
			SUB->(DBSETORDER(1))
			IF SUB->(DBSEEK(XFILIAL("SUB")+SUA->UA_NUM))
				WHILE SUB->(!EOF()) .AND. SUB->UB_FILIAL = SUA->UA_FILIAL .AND. SUB->UB_NUM = SUA->UA_NUM
					RECLOCK("SUB",.F.)
					SUB->UB_DTENTRE := _dDatProg
					SUB->(DBSKIP())
				ENDDO
			ENDIF
		ENDIF

		/******************************************
		Verifica o status do orçamento para informar o CRM
		******************************************/
		IF SUA->UA_XBLOQ <> "1"
			xRetStatus := "2" // LIBERADO
		ELSE
			xRetStatus := "1" // BLOQUEADO
		ENDIF

		_cStaCode := ""

		If !Empty(SUA->UA_NUMSC5)  //cotação ganha
		
			_cStaCode := "4"

				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(SUA->(UA_FILIAL+UA_NUMSC5)))

					SC5->(RecLock("SC5",.F.))
					SC5->C5_ZBLOQ 	:= "2"
					SC5->C5_ZMOTBLO := ""
					SC5->(MsUnLock())

					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
						While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)
								//Recarregar data programada
								_nSldDisp   :=  u_versaldo(SC6->C6_PRODUTO)
								_dNewData   :=  u_atudtentre(_nSldDisp,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT))
								SC6->(RecLock("SC6",.F.))
								SC6->C6_ENTREG  := _dNewData
								SC6->(MsUnLock())
							SC6->(DbSkip())
						EndDo
					EndIf

				EndIf

		Else
			_cStaCode := "279440003"
		EndIf

		/******************************************
		Mensagem de retorno ao CRM
		******************************************/
		IF EMPTY(SUA->UA_NUMSC5)
			_cJson := '{' +;
			'"nec_statusorcamento":'+'"'+xRetStatus+'"'+',' +;
			'"nec_motivodobloqueio":'+'"'+ALLTRIM(SUA->UA_XDESBLQ)+'"'+','+;
			'"statuscode": '+_cStaCode+','+;
			'"nec_codigo_protheus":'+'"'+SUA->UA_NUM+'"'+','+ ;
			'"nec_orcamentoatualizadoem":'+'"'+FWTimeStamp( 6, Date(), Time())+'"'+;
			'}'
		ELSE
			_cJson := '{' +;
			'"nec_statusorcamento":'+'"'+xRetStatus+'"'+',' +;
			'"nec_motivodobloqueio":'+'"'+ALLTRIM(SUA->UA_XDESBLQ)+'"'+','+;
			'"statuscode": '+_cStaCode+','+;
			'"nec_codigo_protheus":'+'"'+SUA->UA_NUM+'"'+','+ ;
			'"nec_orcamentoatualizadoem":'+'"'+FWTimeStamp( 6, Date(), Time())+'"'+','+;
			'"nec_codigopedido": "'+AllTrim(SUA->UA_NUMSC5)+'"'+;
			'}'
		ENDIF
		
		/**************************************
		Chama a Rotina de Conexão com o CRM
		**************************************/
		lRet := .F.
		lRet := U_PatchNectar(_cJson,ALLTRIM(_cGuid))
		
		/**********************************
		Manda e-mail caso não conectar ao Nectar
		**********************************/
		IF lRet = .F.
			///SENDEMAIL("Erro ao conectar ao CRM - Inclusão/Alteração Orçamento. UA_XGUID: "+ALLTRIM(oJson:UA_XGUID))
		ENDIF
		
		Z98->(DBSETORDER(1))
		Z98->(DBGOTO(nRecZ98))
		RECLOCK("Z98",.F.)
		Z98->Z98_DTENV  := DATE()
		Z98->Z98_HRENV  := SUBSTR(TIME(),1,5)
		Z98->Z98_JSENV  := IIF(lRet = .T.,_cJson,"ERRO AO CONECTAR AO CRM - "+_cJson)
		Z98->Z98_STATUS := IIF(lRet = .T.,"1","2")
		Z98->(MSUNLOCK())
		
		CONOUT("[STCRM08A] - Orçamento gerado com sucesso Numero: "+SUA->UA_NUM+" - "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))

		//If !Empty(SUA->UA_NUMSC5)
		//	U_STFAT612()
		//EndIf
		
		/******************************************
		Falha ao gerar o orçamento
		******************************************/
	ELSE
		DisarmTransaction() // Deu error.log disarma transação. 
		/*********************************
		Trata o erro do execauto
		*********************************/
		_cArq := "STCRM008_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"
		_cDir := "\arquivos\logs\"
		IF !ExistDir(_cDir)
			Makedir(_cDir)
		ENDIF
		
		_cErro := MostraErro(_cDir,_cArq)
		IF EMPTY(_cErro)
			aVetErro := GetAutoGRLog()
			FOR nX := 1 TO LEN(aVetErro)
				_cErro += aVetErro[nX]
			NEXT Nx
		ENDIF
		
		CONOUT("[STCRM08A] - ERRO ao gerar o orçamento REGISTRO: "+ALLTRIM(Z98->Z98_XGUID)+" - "+_cErro)
		
		IF EMPTY(cMsgRet)
			_cRetorno := _cErro
		ELSE
			_cRetorno := cMsgRet + " - " + _cErro
			_cErro    := _cRetorno
		ENDIF
		
		/************************************
		Grava o arquivo de log na pasta:
		************************************/
		_cFile  := _cDir + _cArq
		nHdlXml := FCreate(_cFile,0)
		IF nHdlXml > 0
			FWrite(nHdlXml,_cErro)
			FClose(nHdlXml)
		ENDIF
		
		_cJson := '{'+;
		'"statuscode": 279440007,'+; //// 279440004
		'"statecode": 1,'+;
		'"nec_erroprotheus":'+'"'+_cErro+'"'+'}'
		
		/**************************************
		Chama a Rotina de Conexão com o CRM
		**************************************/
		lRet := .F.
		lRet := U_PatchNectar(_cJson,ALLTRIM(_cGuid))
		
		Z98->(DBSETORDER(1))
		Z98->(DBGOTO(nRecZ98))
		RECLOCK("Z98",.F.)
		Z98->Z98_DTENV  := DATE()
		Z98->Z98_HRENV  := SUBSTR(TIME(),1,5)
		Z98->Z98_JSENV  := IIF(lRet = .T.,_cJson,"ERRO AO CONECTAR AO CRM - "+_cJson)
		Z98->Z98_STATUS := IIF(lRet = .T.,"1","0")
		Z98->(MSUNLOCK())
		
		/**********************************
		Manda e-mail caso não conectar ao Nectar
		**********************************/
		IF lRet = .F.
			///SENDEMAIL("Erro ao conectar ao CRM - Inclusão/Alteração Orçamento. UA_XGUID: "+ALLTRIM(Z98->Z98_XGUID))
		ENDIF
		CONOUT("[STCRM08A] - Erro ao gerar o orçamento "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
	ENDIF

	UnLockByName(_cLockBy,.F.,.F.,.T.)

	IF _nOpc==3 // Inclusão reforço para evitar duplicidades. 
       IF VerDupli(_cGuid)>1
 		   cErro:='Ja exite um Orcamento cadastrado para esta UA_XGUID. Orcamento cadastrado: '+SUA->UA_NUM 
		   DisarmTransaction() // Aborta gravação. 
		   _cJson := '{'+;
		   '"statuscode": 279440007,'+; //// 279440004
		   '"statecode": 1,'+;
		   '"nec_erroprotheus":'+'"'+"ENVIADO EM DUPLICIDADE"+'"'+'}'
		   /**************************************
		   Chama a Rotina de Conexão com o CRM
		   **************************************/
		   lRet := .F.
		   lRet := U_PatchNectar(_cJson,ALLTRIM(_cGuid))
	       Z98->(DBSETORDER(1))
		   Z98->(DBGOTO(nRecZ98))
		   RECLOCK("Z98",.F.)
		   Z98->Z98_DTENV  := DATE()
		   Z98->Z98_HRENV  := SUBSTR(TIME(),1,5)
		   Z98->Z98_JSENV  := IIF(lRet = .T.,_cJson,cErro+_cJson)
		   Z98->Z98_STATUS := IIF(lRet = .T.,"1","2")
		   Z98->(MSUNLOCK())
		   RETURN()
	   ENDIF
	ENDIF 
	

    End Transaction 
	
ENDIF

//// Encerra a conexão
RpcClearEnv()

RETURN

/*********************************
Rotina de Conexão com o CRM - Método PATCH
*********************************/
USER FUNCTION PatchNectar(_cJson,_cGuid)

	LOCAL oJson
	LOCAL lRet := .F.
	LOCAL cAmbiente := GETNewPar("ST_NECTAR1",'3') // 1-Produção;2-Homologação;3-Desenvolvimento
	LOCAL _cPath		:= ""
	LOCAL _cUrlEnt  := 	.F.
	LOCAL aHeadOut  := {}
	LOCAL nTimeOut  := 60
	LOCAL cHeadRet 	:= ""
	LOCAL cTokenBare := ""
	LOCAL cEXPIRES_IN   := 0
	LOCAL cACCESS_TOKEN := ""
	Local _cUApiPass := AllTrim(GetMv("ST_APIPAS2",,"https://core.apipass.com.br/api/b190b169-204c-4c60-a098-ae812dc11014/dev/erp_crm_inserir_alterar_orcamentos"))

	If GetMv("ST_APIPAS3",,.F.)
		AADD( aHeadOut,"GUID: "+_cGuid)
		cPOSTParms:= _cJson
		cResponse := HTTPQuote( _cUApiPass , "POST" , "" , cPOSTParms, nTimeOut, aHeadOut, @cHeadRet )
		IF "204 No Content" $ cHeadRet
			//// Atualização efetuada com sucesso no CRM
			lRet := .T.
		ENDIF
	Else
		IF cAmbiente == '1'   // produção
			_cUrlEnt    := "https://steck.crm2.dynamics.com"
		ELSEIF cAmbiente == '2'	// homologação
			_cUrlEnt := "https://steckhml.crm2.dynamics.com"
		ELSEIF cAmbiente == '3' // desenvolvimento
			_cUrlEnt := "https://steckdev.crm2.dynamics.com"
		ENDIF

		//// Path para Inclusão do Orçamento / Alteração do Orçamento / Geração Pedido de Venda
		_cPath := "/api/data/v9.2/quotes(" + _cGuid + ")

		// Efetua Login
		lRet := .F.
		oJson := LoginNectar()

		IF !EMPTY(oJson)
			
			// Carregando informações para Registrar KeyAccess
			cTokenBare    := oJson:TOKEN_TYPE
			cACCESS_TOKEN := oJson:ACCESS_TOKEN
			cEXPIRES_IN   := oJson:EXPIRES_IN
			cRESOURCE     := oJson:RESOURCE // "https://steckdev.crm2.dynamics.com/"
			
			//// Executando Metodo PATCH
			AADD( aHeadOut,"Content-Type: application/json; charset=utf-8")
			AADD( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )
			
			//// AWQUI SERIA O JSON PARA ENVIO PARA O CRM.....MKL
			cGETParms := ""
			cPOSTParms:= _cJson
			cResponse := HTTPQuote( _cUrlEnt+_cPath , "PATCH" , cGETParms, cPOSTParms, nTimeOut, aHeadOut, @cHeadRet )
			
			/*******************************************************
			Os códigos de status das respostas HTTP indicam se uma requisição HTTP foi corretamente concluída.
			As respostas são agrupadas em cinco classes:
			Respostas de informação (100-199),
			Respostas de sucesso (200-299),
			Redirecionamentos (300-399)
			Erros do cliente (400-499)
			Erros do servidor (500-599).
			*******************************************************/
			IF "204 No Content" $ cHeadRet
				//// Atualização efetuada com sucesso no CRM
				lRet := .T.
			ENDIF	
		EndIf
	EndIf

RETURN lRet


/*/{Protheus.doc} LoginNectar
description
Rotina que fará o login para acessar Dynamics da Nectar
@type function
@version  1.00
@author Valdemir Jose / adaptado por Flávia Rocha
@since 19/04/2021
@return return_type, return_description
/*/
STATIC FUNCTION LoginNectar()
/*
TenantID: 2422a1cd-474b-4d91-965a-59ea2dc1a9c8
Cliente_id: e4cf112c-5dd3-4bd2-93aa-89c51478f266
Cliente_secret: 02vMHP1-X0WESfD.7wt77u-Yzt_gCfU0.6
Resource: https://steckdev.crm2.dynamics.com/
*/
LOCAL oRet := NIL
LOCAL _lRet := .F.
LOCAL cAmbiente := GETNewPar("ST_NECTAR2",'3')				// 1-Produção;2-Homologação;3-Desenvolvimento
LOCAL nTimeOut 	:= 60
LOCAL aHeadOut 	:= {}
LOCAL cHeadRet 	:= ""
LOCAL sPostRet  := ""
LOCAL _cUrl 		:= ""
LOCAL _xJson		:= ""
LOCAL cResource := ""

//_cUrlHml += _cHmlID + _cUrl2  // "https://login.microsoftonline.com/{{TenantID}}/oauth2/token"
//concatenando:
//                "https://login.microsoftonline.com/"+   {{TenantID}}						   + "/oauth2/token"
//ficando assim: "https://login.microsoftonline.com/" + "2422a1cd-474b-4d91-965a-59ea2dc1a9c8" + "/oauth2/token"
//                https://login.microsoftonline.com/2422a1cd-474b-4d91-965a-59ea2dc1a9c8/oauth2/token
// Efetuando o Login

/*
aAdd( aHeadOut,"grant_type:" 	+ "client_credentials" )
aAdd( aHeadOut,"client_id:" 	+ cClientID )
aAdd( aHeadOut,"client_secret:" + cCliSecre )
aAdd( aHeadOut,"resource:" 		+ cResource )
*/

//FR - Alteração - Em 11/05 Vanderlei da Nectar passou esses novos ID's para acesso de obter token, então coloquei via parâmetro:
cClientID := AllTrim(GetNewPar("ST_NECTAR3" , "d0208216-6fc6-4174-97bc-96916daeeb4e"))
cCliSecre := AllTrim(GetNewPar("ST_NECTAR4" , "97D8Q~SOoQ4BXWhydmkvlLaWcyhpKJcrdjaoxdqk"))

If cAmbiente == '1'  //produção
	cResource := "https://steck.crm2.dynamics.com"
Elseif cAmbiente == '2'	//homologação
	cResource := "https://steckhml.crm2.dynamics.com"
Elseif cAmbiente == '3' //desenvolvimento
	cResource := "https://steckdev.crm2.dynamics.com"
Endif
_cUrl := "https://login.microsoftonline.com/2422a1cd-474b-4d91-965a-59ea2dc1a9c8/oauth2/token"


// Efetuando o Login
AADD(aHeadOut,"grant_type:client_credentials")
AADD(aHeadOut,"client_id:"+cClientID )
AADD(aHeadOut,"client_secret:"+cCliSecre )
If cAmbiente == '1'  //produção
	AADD(aHeadOut,"resource:https://steck.crm2.dynamics.com/" )
ELSE
	AADD(aHeadOut,"resource:https://steckdev.crm2.dynamics.com/" )
ENDIF

//qdo concatenar utilizar & no final de cada string:
_xJson := 'grant_type=client_credentials&'
_xJson += 'client_id='+cClientID+'&' 	+ Chr(13) + Chr(10)
_xJson += 'client_secret='+cCliSecre+'&' 	+ Chr(13) + Chr(10)
_xJson += 'resource=' + cResource
sPostRet := HttpPost(_cUrl,,_xJson, nTimeOut, aHeadOut, @cHeadRet)
_lRet := FWJsonDeserialize(sPostRet, @oRet)

/*
client_id=535fb089-9ff3-47b6-9bfb-4f1264799865
&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default
&client_secret=sampleCredentia1s
&grant_type=client_credentials
*/
IF EMPTY(sPostRet)
	CONOUT("[STCRM007] [LogimNectar] Falha ao conectar com servidor NecTar")
	oRet := NIL
ENDIF

RETURN oRet

STATIC FUNCTION SENDEMAIL(_cTexto)
	_cEmail   := GETMV("WFSTCRM08")

	IF !EMPTY(_cEmail)
		_cCopia   := ""
		_cAssunto := "Erro ao conectar ao CRM"
		_aAttach  := {}
		_cCaminho := ""

		_cMsg     := ""
		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>'+_cAssunto+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+_cAssunto +'</FONT> </Caption></Table><BR>'

		// Definicao do texto/detalhe do email                                         ï¿½
		cMsg += '<tr>'+_cTexto+'</tr><br>'
		// Definicao do rodape do email
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(STCRM007)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	ENDIF
RETURN

/***********************************************************************************************************************
Função.......: STCRM08B
ação.........: Função para cálculo dos dias da entrega progamada do Orçamento validação antes de entrar nos itens
.............: Utilizado fonte MSTECK15 como referência
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 12/09/2022
Chamado......: 20220429009114 - Oferta Logística

MV_DIASENT...: Parâmetro de dias mínimos de entraga.
***********************************************************************************************************************/
STATIC FUNCTION STCRM08B(xDataPrg,oItens)
LOCAL _nX := 0
LOCAL lRet   := .T.
LOCAL nDiasGrp  := 0
LOCAL nDiasLT   := 0
LOCAL cMsgRet   := ""

/****************************
Variável da Data de Entrega Programada que será utilizada nos itens
****************************/
_dDatProg := STOD("")

IF cEmpAnt = "11"
	
	/*********************************************
	Se o Pedido de Venda  possui Entrega Programada a cidade de entrega devera
	possuir o tempo de translado cadastrado na tabela CC2
	*********************************************/
	CC2->(DBSETORDER(1))
	IF CC2->(DBSEEK(XFILIAL("CC2")+SA1->A1_EST+SA1->A1_COD_MUN))
		IF CC2->CC2_XTNT = 0
			/***************************
			Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
			***************************/
			cMsgRet := "ERRO - Pedido de Venda com Entrega Programada! "+;
			"O Municipio "+SA1->A1_COD_MUN+" nao possui cadastro na tabela CC2"
			lRet := .F.
		ENDIF
		
		/************************************
		Passou pela validação de tempo de translado CC2
		*************************************/
		IF lRet = .T.
			
			/************************************
			Verifica se TODOS os produtos do Pedido de Venda são  MTS "Produto de Estoque"
			Se todos os itens no pedido forem de Estoque não considera o Lead Time do produto
			Se algum dos produtos for MTO "Produto a ser fabricado/comprado" a rotina irá buscar o MAIOR Lead Time informado e
			a data de entrega devera considerar o Lead Time mais o Tempo de Operação mais o Tempo de Translado
			*************************************/
			nDiasGrp   := 0
			nDiasLT    := 0
			FOR _nX := 1 TO LEN (oItens)
				SB1->(DBSETORDER(1))
				IF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(oItens[_nX]:UB_PRODUTO)))
					IF ALLTRIM(SB1->B1_XMTO) = "MTO"
						nDiasGrp := U_STLDGRUP(SB1->B1_COD)
						IF nDiasGrp > nDiasLT
							nDiasLT := nDiasGrp
						ENDIF
					ENDIF
				ENDIF
			NEXT
			
			/******************************************************
			Encontrou algum produto MTO
			Calcula a nova data programada baseando-se na maior data de Lead Time mais 05 dias de operação e mais o tempo de translado.
			*******************************************************/
			IF nDiasLT > 0
				IF xDataPrg < (DATE() + nDiasLT)
					/***************************
					Verifica se a rotina ésta sendo chamada via ExecAuto ou  na tela do Call Center
					***************************/
					cMsgRet := "ERRO - Pedido de Venda com Entrega Programada! "+;
					"Existem produtos do tipo MTO por tanto a data minima para entrega devera ser "+DTOC((DATE() + nDiasLT))
				ELSE
					
					/************************************
					Carrega os dias necessários para a operação:
					
					Parâmetros para o tempo total de operação do produto
					STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
					STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
					STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
					STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
					*************************************/
					//// Dias de Translado para a entrega Tabela CC2
					nDiasTra := CC2->CC2_XTNT
					
					//// Dias de operação para o Financeiro
					nDiasFin := GetNewPar("STDIASFIN",2)
					
					//// Dias de operação para o Comercial
					nDiasCom := GetNewPar("STDIASCOM",0)
					
					//// Dias de operação para a Logistica
					nDiasLog := GetNewPar("STDIASLOG",4)
					
					//// Dias de operação para a Expedição
					nDiasExp := GetNewPar("STDIASEXP",2)
					
					//// Soma os dias que compõe a opreação total
					nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp
					
					/********************************************
					Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
					Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
					A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
					Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
					********************************************/
					//// Data da Entrega Programada
					nDiaBase := xDataPrg
					
					FOR _nX := 1 TO nDiasOpe
						nDiaBase := DataValida((nDiaBase - 1),.F.)
					NEXT
					
					/************************************
					Verifica se passou na regra.
					Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
					Somente se o tipo de operação for "01" / "93"
					*************************************/
					_dDatProg := nDiaBase
				ENDIF
			ELSE
				
				/************************************
				Produtos MTS - Peordutos em Estoque
				Veriifa se a data de entrega é maior que a definida no parâmetro MV_DIASENT
				************************************/
				nDiasLT := GETMV("MV_DIASENT")
				IF xDataPrg < (DATE()+nDiasLT)
					cMsgRet := "ERRO - Pedido de Venda com Entrega Programada! "+;
					"A data minima para entrega devera ser "+DTOC((DATE() + nDiasLT))
				ELSE
					
					/************************************
					Carrega os dias necessários para a operação:
					
					Parâmetros para o tempo total de operação do produto
					STDIASFIN	– DIAS FINANCEIRO POR PADRÃO SERÁ 02 (DOIS)   DIAS
					STDIASCOM	– DIAS FINANCEIRO POR PADRÃO SERÁ 00 (ZERO)   DIAS
					STDIASLOG	– DIAS LOGISTICA  POR PADRÃO SERÁ 04 (QUATRO) DIAS
					STDIASEXP	– DIAS EXPEDIÇÃO  POR PADRÃO SERÁ 02 (DOIS)   DIAS
					*************************************/
					//// Dias de Translado para a entrega Tabela CC2
					nDiasTra := CC2->CC2_XTNT
					
					//// Dias de operação para o Financeiro
					nDiasFin := GetNewPar("STDIASFIN",2)
					
					//// Dias de operação para o Comercial
					nDiasCom := GetNewPar("STDIASCOM",0)
					
					//// Dias de operação para a Logistica
					nDiasLog := GetNewPar("STDIASLOG",4)
					
					//// Dias de operação para a Expedição
					nDiasExp := GetNewPar("STDIASEXP",2)
					
					//// Soma os dias que compõe a opreação total
					nDiasOpe := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp
					
					/********************************************
					Com a quantidade dias já na variável, agora devo subtraindo do dia da programação "UA_XDTENPR" a quantidade de dias.
					Tem que ser via "FOR" pois será verifcado se a data da programação -1 não cai no Sábado / Domingo / Feriado
					A função DataValida quando passado o parâmetro .F. ele pega o dia anterior.
					Exemplo: 15/05/2022 (Sábado) retornará 13/05/2022 (Sexta-Feira)
					********************************************/
					//// Data da Entrega Programada
					nDiaBase := xDataPrg
					
					FOR _nX := 1 TO nDiasOpe
						nDiaBase := DataValida((nDiaBase - 1),.F.)
					NEXT
					
					/************************************
					Verifica se passou na regra.
					Se passou, recalcula a data caso o acols esteja com a data de entrega preenchida
					Somente se o tipo de operação for "01" / "93"
					*************************************/
					_dDatProg := nDiaBase
					
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF

RETURN cMsgRet



// Busca proximo numero do pedido devido ja estar sendo usado 
Static Function VerDupli(cGuid)

Local cAlias:=""
Local nTotal:=0
Local aArea:=GetArea()

cAlias := GetNextAlias()

cQuery := " SELECT UA_FILIAL,UA_XGUID, COUNT(*) TOTAL   "
cQuery += " FROM "+RetSqlName("SUA")+ " SUA "
cQuery += " WHERE UA_FILIAL ='"+XFILIAL('SUA')+"' "
cQuery += "   AND UA_XGUID ='"+cGuid+"' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY UA_FILIAL,UA_XGUID "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   nTotal:=(cAlias)->TOTAL
ENDIF
(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(nTotal)


