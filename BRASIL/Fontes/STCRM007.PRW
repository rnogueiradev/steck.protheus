/**************************************** 
Função.......: STCRM007
Ação.........: JOB para atualização dos Preços do Consulta Preços CRM
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 27/07/2022
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

USER FUNCTION STCRM007()
LOCAL nY := 0
LOCAL nThreads := ""
LOCAL nCount   := 0
LOCAL aVetZ98  := {}

PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

/***********************************
Busca na tabela Z98 todas consultas de preços pendentes
***********************************/
nThreads := SUPERGETMV("STCRM007",,99)
cQuery := "SELECT Z98.R_E_C_N_O_ AS Z98REC FROM "+RetSqlName("Z98")+" Z98 "
cQuery += "WHERE Z98.D_E_L_E_T_ = ' ' "
cQuery += "AND Z98.Z98_TIPO = '1' AND Z98.Z98_STATUS = '0' "
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
Chama a função STCRM07A - JOB para atualização dos Preços do Consulta Preços CRM
*************************************/
FOR nY := 1 TO LEN(aVetZ98)
	StartJob("U_STCRM07A",GetEnvserver(),.F.,aVetZ98[nY])
NEXT nY

RESET ENVIRONMENT
RETURN

USER FUNCTION STCRM07A(xRecZ98,cChaveCli)
LOCAL nX := 0
LOCAL _cTes  := "" 
LOCAL aVetor := {}
LOCAL lRet   := NIL
LOCAL _cJson := ""
LOCAL cCount := "00"
LOCAL _nPreco := 0
LOCAL _cTabela := '001'
LOCAL _nEstoque := 0
LOCAL _cEntrega := ""
LOCAL cErroCab  := ""
LOCAL cErroItem := ""
LOCAL cErroTes  := ""
LOCAL cErroPrc  := ""
LOCAL cErroCli  := ""
LOCAL cMsgProt  := ""
LOCAL cRet      :=""
Local aRet1     :={}

Local _aRet := {}

PRIVATE nRecZ98    := xRecZ98 
PRIVATE _cLockBy   := "STCRM007"+ALLTRIM(STR(nRecZ98))
PRIVATE nValDesc   := 0 //Valor do desconto
PRIVATE nValAcresc := 0
PRIVATE nAliqICM 	 := 0 //Aliquota do ICMS
PRIVATE nValICms	 := 0 //Valor do ICMS
PRIVATE nAliqIPI 	 := 0 //Aliqutota do IPI
PRIVATE nValIPI 	 := 0 //Valor do IPI
PRIVATE nValICMSST := 0 //Valor do ICMS-ST
PRIVATE nValSuf		 := 0 //Valor do suframa
PRIVATE nValPis		 := 0 //Valor do PIS
PRIVATE nValCof		 := 0 //Valor do COFINS
PRIVATE nTotIPI 	 := 0 //Valor total do IPI
PRIVATE nTotICMSST := 0 //Valor total do ICMS-ST
PRIVATE nTotSuf		 := 0 //Valor total do suframa
PRIVATE nTotPis		 := 0 //Valor total do PIS
PRIVATE nTotCof		 := 0 //Valor total do COFINS
PRIVATE nTotDesc   := 0 //Valor Total do Deconto
PRIVATE nTotNota   := 0 //Valor Total da NF
PRIVATE nTotMerc   := 0 //Total de Mercadorias
PRIVATE _nQtdRest  := 0 // Quantidade do produto
PRIVATE _cConsumo  := ""
PRIVATE lMafisIni  := .T.
PRIVATE UrlTemQuebra:=""
PRIVATE cUrlTQ      :=""

Default cChaveCli  :=""

RpcSetType(3)
RpcSetEnv( "11", "01",,,"FAT")

cUrlTQ:=ALLTRIM(SUPERGETMV("ST_TEMQUEB",,"http://rest-p12-qa.steck.com.br:9502/rest/DtEntrega?"))

IF !LockByName(_cLockBy,.F.,.F.,.T.)
	CONOUT("[STCRM007] - ERRO: Processo sendo executado por outra instância!")
   RETURN
 ELSE

	oJson	 := NIL	//// Deve clarar sem ser local ou private
	oItens := NIL //// Deve clarar sem ser local ou private

	/************************************
	Posiciona na tabela Z98
	************************************/
	Z98->(DBSETORDER(1))
	Z98->(DBGOTO(nRecZ98))
	CONOUT("[STCRM007] - Inicio de processamento "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))

	/************************************
	Busca o Json gravado na tabela Z98 e transforma em objeto para inicar os trabalhos
	************************************/
	_cJson := ALLTRIM(Z98->Z98_JSREC)
	lRet := FWJsonDeserialize(FwNoAccent(_cJson),@oJson)

	IF lRet = .F.
		CONOUT("[STCRM006] - Erro na montagem do ojeto. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
		RETURN
	ENDIF
    
	
	/*********************************
	Valida Cliente 
	*********************************/
	
	IF ! Empty(cChaveCli)
	   SA1->(DBSETORDER(1))
       IF !SA1->(DBSEEK(XFILIAL("SA1")+cChaveCli))
		   cErroCab += 'Cliente nao encontrado no Protheus'
		   CONOUT("[STCRM07A] - Cliente nao encontrado no Protheus. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
		   RETURN
	   ENDIF
	ELSE 
       cRet:=U_ValidaCli(ALLTRIM(oJson:CNPJ))
       IF cRet=='X'
		   cErroCab += 'Cliente nao encontrado no Protheus'
		   CONOUT("[STCRM07A] - Cliente nao encontrado no Protheus. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
	      RETURN 
       ELSEIF cRet=='B'   
		   cErroCab += 'Cliente bloqueado'
		   CONOUT("[STCRM07A] - Cliente Bloqueado. REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
	      RETURN 
       ELSE 
          SA1->(DBSETORDER(1))    
          SA1->(DBSEEK(XFILIAL("SA1")+cRet))
       ENDIF   
	ENDIF 

	/*********************************
	Validação da Mensagem de Bloqueio do Cliente
	*********************************/
	IF !EMPTY(SA1->A1_XCODMC) //- Mensagem de Bloqueio do Cliente
		IF !EMPTY(MSMM(SA1->A1_XCODMC))
			cErroCli += NoAcento(MSMM(SA1->A1_XCODMC))
		ENDIF
	ENDIF

	/************************************
	Passa o consumo para carregar a TES
	Se o Tipo do Cliente for Consumidor final "SA1->A1_TIPO = 'F'" passa o tipo de Consumo
	************************************/
	IF TYPE("oJson:UA_ZCONSUM") <> "U"
		//IF SA1->A1_TIPO = 'F'
			_cConsumo := oJson:UA_ZCONSUM
		//ENDIF
	ENDIF

	/************************************
	Verifica se o cliente se encontra bloqueado
	************************************/
	//IF SA1->A1_MSBLQL = "1"
	//	cErroCab += ' - Cliente Bloqueado no Protheus'
	//ENDIF

	/************************************
	Valida se encontrou algum erro nem procesa o preço
	************************************/
	IF !EMPTY(cErroCab)
		_cJson := '{'
		_cJson += '"nec_json":' 
		_cJson += '"{' 
		_cJson += '\"alertaProtheus\":'+'\"'+ALLTRIM(cErroCab)+'\"'+','
		_cJson += '\"ITEMS\":'
		_cJson += '[]'
		_cJson += '}",'
		_cJson += '"nec_CotacaoId@odata.bind": "/quotes('+ALLTRIM(oJson:UA_XGUID)+')",'
		_cJson += '"nec_integracao": 279440000,'
		_cJson += '}'
	ELSE
		/************************************
		Busca a tabela para o cliente Cadastro de Clinte
		************************************/
		_cTabela := U_STXZ2B(SA1->A1_COD,SA1->A1_LOJA)		

		/************************************
		Calcula o Preço do Produtos relacionados no Json
		************************************/
		oItens := oJson:ITEMS
		FOR nX := 1 TO LEN(oItens)

				/************************************
				Limpa as variáveis
				************************************/
				nValDesc	 := 0  //Valor do desconto
				nValAcresc   := 0 //Valor do acrescimo
				nAliqICM	 := 0  //Aliquota do ICMS
				nValICms	 := 0  //Valor do ICMS
				nAliqIPI	 := 0  //Aliqutota do IPI
				nValIPI		 := 0  //Valor do IPI
				nValICMSST := 0  //Valor do ICMS-ST
				nValSuf		 := 0  //Valor do suframa
				nValPis		 := 0  //Valor do PIS
				nValCof		 := 0  //Valor do COFINS
				_nQtdRest  := 0  // Quantidade do produto
				_nPreco 	 := 0  // Valor do Produto
				_cTes   	:= "" // Tes

			/**********************************
			Variavel de Quantidade.
			Estou criando esta variável como Private para que dentro da rotina STRETSST ela esteja populada para poder corrigir
			o cálculo do valor do produto na rotina que será chamada a rotina ST04GAX
			**********************************/
			_nQtdRest := oItens[nX]:UB_QUANT
			
			_nPreco   := 0
			//_nPreco := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'PRECO',.F.,SA1->A1_TIPO,         ,_cTabela,@_cTes00)
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(FWxFilial("SB1") + AllTrim(oItens[nX]:UB_PRODUTO)))
			
			_aRet:={}
			_aRet:= U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'TUDO'  ,.F.,SA1->A1_TIPO,_cConsumo,_cTabela)
			
			//_nPreco := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'PRECO',.F.,SA1->A1_TIPO,         ,_cTabela,@_cTes)
			//_cTes   := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'TES'  ,.F.,SA1->A1_TIPO,_cConsumo,_cTabela)
			if ValType(_aRet)=="A"
			   IF LEN(_aRet)>0
			      _nPreco:=_aRet[1]
			      _cTes  :=_aRet[7]
			   ELSE 
			      _nPreco := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'PRECO',.F.,SA1->A1_TIPO,         ,_cTabela,@_cTes)
			      _cTes   := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,ALLTRIM(oItens[nX]:UB_PRODUTO),ALLTRIM(oJson:UA_XCONDPG),'TES'  ,.F.,SA1->A1_TIPO,_cConsumo,_cTabela)
               ENDIF 			   
            ELSE 			   
		       _nPreco := 0
			   _cTes   := ""
            ENDIF			   
               

			
			/************************************
			Verifica se encontrou a TES
			************************************/
			IF EMPTY(_cTes) 
				IF EMPTY(cErroTes)
					cErroTes += ' - O(s) Produto(s) nao atende(m) as novas regras de Tes Inteligente. Codigo do(s) produto(s): '+ALLTRIM(oItens[nX]:UB_PRODUTO)
				ELSE
					cErroTes += ' - '+ALLTRIM(oItens[nX]:UB_PRODUTO)
				ENDIF
			ENDIF

			IF _nPreco == NIL .OR. _nPreco <= 0
				_nPreco := 0
				IF EMPTY(cErroPrc)
					cErroPrc += ' - O(s) Produto(s) com Valor unitario nao calculado no Protheus. Codigo do(s) produto(s): '+ALLTRIM(oItens[nX]:UB_PRODUTO)
				ELSE
					cErroPrc += ' - '+ALLTRIM(oItens[nX]:UB_PRODUTO)
				ENDIF
			ENDIF 

			/************************************
			Verifica se o produto possui um percentual de desconto aplicado a ele no Json
			DEVOLVER EM UMA TAG ESPECÍFICA VALOR MENOS O DESCONTO	
			************************************/
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_XPORDEC") <> "U"
				IF oItens[nX]:UB_XPORDEC > 0
					nValDesc := ROUND(((_nPreco / 100) * oItens[nX]:UB_XPORDEC),2)
				ENDIF
			ENDIF
			IF TYPE("oItens["+ALLTRIM(STR(nX))+"]:UB_XACREPO") <> "U"
				IF oItens[nX]:UB_XACREPO > 0
					nValAcresc := ROUND(((_nPreco / 100) * oItens[nX]:UB_XACREPO),2)
				ENDIF
			ENDIF

			IF nValIPI == NIL
				nValIPI := 0
			ENDIF 

			IF nValICMSST == NIL
				nValICMSST := 0
			ENDIF 		

			_nEstoque := U_STTMKG02("E",ALLTRIM(oItens[nX]:UB_PRODUTO),oItens[nX]:UB_QUANT) 
			_cEntrega  := DTOS(U_STTMKG02("D",ALLTRIM(oItens[nX]:UB_PRODUTO),oItens[nX]:UB_QUANT))
			_cEntrega := SUBSTR(_cEntrega,1,4) + "-" + SUBSTR(_cEntrega,5,2) + "-" + SUBSTR(_cEntrega,7,2)


			/****************************
			Valida se o Produto possui múltiplo cadastrado
			****************************/
			cMsgProt := ""
			SB1->(DBSETORDER(1))
			IF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(oItens[nX]:UB_PRODUTO)))
				IF SB1->B1_XLM > 0 .AND. !(ALLTRIM(SA1->A1_COD) $ ALLTRIM(GETMV("STEDIPV001",,"038134/014519/092187/092887")))
					IF SB1->B1_XTIPLM $ 'M'
						IF (SUBSTR(SA1->A1_GRPVEN,1,1)=="C" .AND. SB1->B1_XEMBC=="S") .OR.;
						   (SUBSTR(SA1->A1_GRPVEN,1,1)=="D" .AND. SB1->B1_XEMBD=="S") .OR.;
						   (SUBSTR(SA1->A1_GRPVEN,1,1)=="E" .AND. SB1->B1_XEMBE=="S") .OR.;
						   (SUBSTR(SA1->A1_GRPVEN,1,1)=="I" .AND. SB1->B1_XEMBI=="S") .OR.;
						   (SUBSTR(SA1->A1_GRPVEN,1,1)=="R" .AND. SB1->B1_XEMBR=="S")

							IF (oItens[nX]:UB_QUANT % SB1->B1_XLM) <> 0 
								cMsgProt := 'Produto fora do multiplo, lancar multiplo de '+ALLTRIM(STR(SB1->B1_XLM))
							ENDIF
						ENDIF
					ENDIF
				ELSEIF oItens[nX]:UB_QUANT < SB1->B1_XLM
					cMsgProt := 'Quantidade inferior ao permitido! Minimo permitido: '+ALLTRIM(STR(SB1->B1_XLM))
				ENDIF
			ENDIF


			/**********************************
			Monta o Vetor que irá alimentar os Itens do Json de Retorno para o CRM
			**********************************/
			AADD(aVetor,{	STRZERO(nX,4),;                //  1 - Número do Item
										oItens[nX]:UB_PRODUTO,;        //  2 - Código do Produto
										oItens[nX]:UB_QUANT,;	         //  3 - Quantidade
										_nPreco,;                      //  4 - Valor Unitário do Produto já concedido o desconto caso exista
										nValIPI,;                      //  5 - Valor do IPI
										nValICMSST,;                   //  6 - Valor do ICMS ST
										nValSuf,;                      //  7 - Valor do Suframa
										_nEstoque,;                    //  8 - Quantidade em Estoque
										_cEntrega,;                    //  9 - Data de Entrega no formato AAA-MM-DD
										ALLTRIM(oItens[nX]:UB_xGUID),; // 10 - xGuid do Produto
										_cTes                       ,; // 11 - TES do produto
										cMsgProt                    ,; // 12 - Mensagem para produtos fora do Multiplo
										nValDesc										 ,; // 13 - Valor do desconto no produto
										nValAcresc   ;//14 - Valor do acrescimo
										})
		NEXT


		/************************************
		Roda o MatFis separado pois estava dando comflito com a chamada da TES Inteligente
		************************************/
		FOR nX := 1 TO LEN(aVetor)
			lMafisIni := .T.
			xMafis(aVetor[nX,11],SA1->A1_COD,SA1->A1_LOJA,SA1->A1_TIPO,ALLTRIM(aVetor[nX,2]),aVetor[nX,3],(aVetor[nX,4]-aVetor[nX,13]),((aVetor[nX,4]-aVetor[nX,13]+aVetor[nX,14]) * aVetor[nX,3]),aVetor[nX,13],aVetor[nX,14])
			aVetor[nX,5] := nValIPI    //  5 - Valor do IPI  
			aVetor[nX,6] := nValICMSST //  6 - Valor do ICMS ST  
			aVetor[nX,7] := nValSuf    //  7 - Valor do Suframa 
			nTotDesc +=  (aVetor[nX,3] * aVetor[nX,13]) // Valor Total do Deconto
			nValAcresc += (aVetor[nX,3] * aVetor[nX,14]) // Valor Total do Acrescimo
			nTotMerc += ((aVetor[nX,4]-aVetor[nX,13]+aVetor[nX,14]) * aVetor[nX,3])
			MaFisEnd()
		NEXT

		/***********************************
		Limpa as variaveis de memoria do Matxfis
		***********************************/
		MaFisSave()
		MaFisEnd()
		lMafisIni := .T.
		FOR nX := 1 TO LEN(aVetor)																								
			xMafis(aVetor[nX,11],SA1->A1_COD,SA1->A1_LOJA,SA1->A1_TIPO,ALLTRIM(aVetor[nX,2]),aVetor[nX,3],(aVetor[nX,4]-aVetor[nX,13]),((aVetor[nX,4]-aVetor[nX,13]) * aVetor[nX,3]),aVetor[nX,13],aVetor[nX,14])
		NEXT

		nTotIPI		 := MaFisRet(,'NF_VALIPI') 		// Valor total do IPI
		nTotICMSST := MaFisRet(,'NF_VALSOL') 		// Valor total do ICMS-ST
		nTotSuf		 := MaFisRet(,'NF_DESCZF') 		// Valor total do suframa
		nTotPis		 := MaFisRet(,'NF_VALPIS') 		// Valor total do PIS
		nTotCof		 := MaFisRet(,'NF_VALCOF') 		// Valor total do COFINS
		//nTotDesc   := MaFisRet(,'NF_DESCONTO')  // Valor Total do Deconto
		//nTotMerc   := MaFisRet(,'NF_VALMERC')  	// Valor Total dos Produtos
		nTotNota   := MaFisRet(,'NF_TOTAL')  		// Valor Total do Orçamento 
		MaFisEnd()

	ENDIF

	/************************************
	Valida se encontrou algum erro nos itens nem procesa o preço
	************************************/
	cErroItem := cErroTes+' '+cErroPrc

	IF !EMPTY(cErroItem) .AND. EMPTY(cErroCab)
		_cJson := '{'
		_cJson += '"nec_json":' 
		_cJson += '"{' 
		_cJson += '\"alertaProtheus\":'         +'\"'+ALLTRIM(cErroItem)+'\"'+','
		_cJson += '\"nec_mensagem_cliente\":'   +'\"\"'+','
    _cJson += '\"nec_valortotalipi\":'      +'\"\"'+','
    _cJson += '\"nec_valortotalicmsst\":'   +'\"\"'+','
    _cJson += '\"nec_valortotalsuframa\":'  +'\"\"'+','
    _cJson += '\"nec_valortotalorcamento\":'+'\"\"'+','
    _cJson += '\"nec_totalamountprotheus\":'+'\"\"'+','
		_cJson += '\"ITEMS\":'
		_cJson += '[]'
		_cJson += '}",'
		_cJson += '"nec_CotacaoId@odata.bind": "/quotes('+ALLTRIM(oJson:UA_XGUID)+')",'
		_cJson += '"nec_integracao": 279440000'
		_cJson += '}'
	ELSEIF EMPTY(cErroCab)
		/*******************************
		Monta o Json de Retorno para o CRM
		*******************************/
		_cJson := '{'
		_cJson += '"nec_json":' 
		_cJson += '"{' 
		_cJson += '\"alertaProtheus\":'         +'\"'+ALLTRIM(cErroCab)+'\"'+','
		_cJson += '\"nec_mensagem_cliente\":'   +'\"'+cErroCli+'\"'+','
    _cJson += '\"nec_valortotalipi\":'      +'\"'+cValToChar(nTotIPI)   +'\"'+',' // Valor total do IPI
    _cJson += '\"nec_valortotalicmsst\":'   +'\"'+cValToChar(nTotICMSST)+'\"'+',' // Valor total do ICMS-ST
    _cJson += '\"nec_valortotalsuframa\":'  +'\"'+cValToChar(nTotSuf)   +'\"'+',' // Valor total do SUFRAMA
    _cJson += '\"nec_valortotalorcamento\":'+'\"'+cValToChar(nTotMerc+nTotIPI+nTotICMSST-nTotSuf)  +'\"'+',' // Valor total do ORÇAMENTO
    _cJson += '\"nec_totalamountprotheus\":'+'\"'+cValToChar(nTotMerc)+'\"'+',' // Valor total das Mercadorias
		_cJson += '\"ITEMS\":'
		_cJson += '[' 
		cCount := "00"

		FOR nX := 1 TO LEN(aVetor)
			//Ver se tem quebra de datas. 

            aRet1:=U_STREST11(aVetor[nX,2],aVetor[nX,3])
						
			cCount := SOMA1(cCount,2)
			_cJson += '{'
			_cJson += '\"nec_item\":'              +'\"'+cCount+'\", '
			_cJson += '\"quotedetailid\":'         +'\"'+aVetor[nX,10]+'\", '
			_cJson += '\"productnumber\":'         +'\"'+aVetor[nX,2]+'\",'
			_cJson += '\"quantity\":'              +'\"'+cValToChar(aVetor[nX,3])+'\",'
			_cJson += '\"priceperunit\":'          +'\"'+cValToChar(aVetor[nX,4])+'\",'
			_cJson += '\"nec_ipi_mn\":'            +'\"'+cValToChar(ROUND(aVetor[nX,5],2))+'\",'
			_cJson += '\"nec_icmst_mn\":'          +'\"'+cValToChar(ROUND(aVetor[nX,6],2))+'\",'
			_cJson += '\"nec_suframa_mn\":'        +'\"'+cValToChar(ROUND(aVetor[nX,7],2))+'\",'
			_cJson += '\"nec_estoque_disponivel\":'+'\"'+cValToChar(aVetor[nX,8])+'\",'
			_cJson += '\"nec_previsao_entrega\":'  +'\"'+aVetor[nX,9]+'\",'
			_cJson += '\"nec_mensagemprotheus\":'  +'\"'+aVetor[nX,12]+'\",'
			_cJson += '\"manualdiscountamount\":'  +'\"'+cValToChar(aVetor[nX,3] * aVetor[nX,13])+'\",'
			_cJson += '\"nec_precomanual\":'       +'\"'+cValToChar(aVetor[nX,4] - aVetor[nX,13] + aVetor[nX,14])+'\",'   
			//IF len(aRet1)>1
			   UrlTemQuebra:=cUrlTq+'_cProd='+ALLTRIM(aVetor[nX,2])+'&_cQuant='+ALLTRIM(STR(aVetor[nX,3]))
			   _cJson += '\"nec_temquebra\":'       +'\"'+ALLTRIM(UrlTemQuebra)+'\"'   //// Informa se terá quebra de datas ou não. 
			//ELSE 
			//   _cJson += '\"nec_temquebra\":'       +'\"'+' '+'\"'   //// Informa se terá quebra de datas ou não. 
			//ENDIF 
			_cJson += '},'
		NEXT

		//// Retira a última vígula do ITEM e fecha o Json
		_cJson := SUBSTR(_cJson,1,(LEN(_cJson)-1))
		_cJson += ']'
		_cJson += '}",'
		_cJson += '"nec_CotacaoId@odata.bind": "/quotes('+ALLTRIM(oJson:UA_XGUID)+')",'
		_cJson += '"nec_integracao": 279440000'
		_cJson += '}'
	ENDIF

	/**************************************
	Chama a Rotina de Conexão com o CRM
	**************************************/
	_cJson := EncodeUTF8(_cJson)
	lRet := .F.
	lRet := PostNectar(_cJson)

	Z98->(DBSETORDER(1))
	Z98->(DBGOTO(nRecZ98))
	RECLOCK("Z98",.F.)
	Z98->Z98_DTENV  := DATE()
	Z98->Z98_HRENV  := SUBSTR(TIME(),1,5)
	Z98->Z98_JSENV  := IIF(lRet = .T.,_cJson,"ERRO AO CONECTAR AO CRM - "+_cJson)
	Z98->Z98_STATUS := IIF(lRet = .T.,"1","2")
	Z98->(MSUNLOCK())

	/**********************************
	Manda e-mail caso não conectar ao Nectar 
	**********************************/
	IF lRet = .F. 
		SENDEMAIL("Erro ao conectar ao CRM - Consulta de Preços. UA_XGUID:"+ALLTRIM(Z98->Z98_XGUID))
	ENDIF

	UnLockByName(_cLockBy,.F.,.F.,.T.)
	CONOUT("[STCRM007] - Fim de processamento "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5)+" REGISTRO: "+ALLTRIM(Z98->Z98_XGUID))
ENDIF

RpcClearEnv()

RETURN

/*********************************
Rotina para cálculo dos impostos dos produtos
*********************************/
STATIC FUNCTION xMafis(_xTes,_cCodCli,_cLojCli,_cTipoCli,_cProduto,_nQuant,_nVrunit,_nVrTotal,_nValDesc,_nValAcresc)

nAliqICM 	 := 0 //Aliquota do ICMS
nValICms	 := 0 //Valor do ICMS
nAliqIPI 	 := 0 //Aliqutota do IPI
nValIPI 	 := 0 //Valor do IPI
nValICMSST := 0 //Valor do ICMS-ST
nValSuf		 := 0 //Valor do suframa
nValPis		 := 0 //Valor do PIS
nValCof		 := 0 //Valor do COFINS

IF lMafisIni = .T.
	MaFisIni(	_cCodCli,;	// 1-Codigo Cliente / Fornecedor
						_cLojCli,;	// 2-Loja do Cliente / Fornecedor
						"C",;				// 3-C:Cliente , F:Fornecedor
						"N",;				// 4-Tipo da NF
						_cTipoCli,;	// 5-Tipo do Cliente / Fornecedor
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						"MATA461")
	lMafisIni := .F.
ENDIF

MaFisAdd(	_cProduto,; // 1-Codigo do Produto ( Obrigatorio )
					_xTes ,;    // 2-Codigo do TES ( Opcional )
					_nQuant,;   // 3-Quantidade ( Obrigatorio )
					_nVrunit,;  // 4-Preco Unitario ( Obrigatorio )
					0,; 				// 5-Valor do Desconto ( Opcional )
					,;          // 6-Numero da NF Original ( Devolucao/Benef )
					,;          // 7-Serie da NF Original ( Devolucao/Benef )
					,;          // 8-RecNo da NF Original no arq SD1/SD2
					0,;         // 9-Valor do Frete do Item ( Opcional )
					0,;         // 10-Valor da Despesa do item ( Opcional )
					0,;         // 11-Valor do Seguro do item ( Opcional )
					0,;         // 12-Valor do Frete Autonomo ( Opcional )
					_nVrTotal,; // 13-Valor da Total da Mercadoria ( Obrigatorio )
					0,;         // 14-Valor da Embalagem ( Opiconal )
					0,;         // 15-RecNo do SB1
					0)          // 16-RecNo do SF4

nAliqICM   := (MaFisRet(1,'IT_ALIQICM',5,2)) // Aliquota do ICMS					
nValICms   := (MaFisRet(1,'IT_VALICM',14,2)) // Valor do ICMS					
nAliqIPI   := (MaFisRet(1,"IT_ALIQIPI",5,2)) // Aliqutota do IPI			
nValIPI    := (MaFisRet(1,"IT_VALIPI",14,2)) // Valor do IPI			
nValICMSST := (MaFisRet(1,'IT_VALSOL',14,2)) // Valor do ICMS-ST		
nValSuf    := (MaFisRet(1,"IT_DESCZF",14,2)) // Valor do suframa		
nValPis    := (MaFisRet(1,"IT_VALPS2",14,2)) // Valor do PIS			
nValCof    := (MaFisRet(1,"IT_VALCF2",14,2)) // Valor do COFINS	

MaFisSave()

RETURN

/*********************************
Rotina de Conexão com o CRM - Metodo POST
*********************************/
STATIC FUNCTION PostNectar(_cJson)

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
	Local _cUApiPass := AllTrim(GetMv("ST_APIPAS1",,"https://core.apipass.com.br/api/b190b169-204c-4c60-a098-ae812dc11014/dev/erp_crm_envio_de_precos"))

	If GetMv("ST_APIPAS3",,.F.)
		cPOSTParms:= _cJson
		cResponse := HTTPQuote( _cUApiPass , "POST" , "" , cPOSTParms, nTimeOut, aHeadOut, @cHeadRet )
		IF "204 No Content" $ cHeadRet 
			lRet := .T.
		EndIf
	Else
		IF cAmbiente == '1'   // produção
			_cUrlEnt    := "https://steck.crm2.dynamics.com"
		ELSEIF cAmbiente == '2' // homologação
			_cUrlEnt := "https://steckhml.crm2.dynamics.com"
		ELSEIF cAmbiente == '3' // desenvolvimento
			_cUrlEnt := "https://steckdev.crm2.dynamics.com"
		ENDIF

		_cPath    := "/api/data/v9.2/nec_integracaos"

		// Efetua Login
		lRet := .F.
		oJson := LoginNectar()

		IF !EMPTY(oJson)	   

			// Carregando informações para Registrar KeyAccess
			cTokenBare    := oJson:TOKEN_TYPE
			cACCESS_TOKEN := oJson:ACCESS_TOKEN
			cEXPIRES_IN   := oJson:EXPIRES_IN
			cRESOURCE     := oJson:RESOURCE // "https://steckdev.crm2.dynamics.com/"
				
			//// Executando Metodo Post
			AADD( aHeadOut,"Content-Type: application/json; charset=utf-8")
			AADD( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )

			//// AWQUI SERIA O JSON PARA ENVIO PARA O CRM.....MKL
			cGETParms := ""
			cPOSTParms:= _cJson
			cResponse := HTTPQuote( _cUrlEnt+_cPath , "POST" , cGETParms, cPOSTParms, nTimeOut, aHeadOut, @cHeadRet )
				
			/*******************************************************
			Os códigos de status das respostas HTTP indicam se uma requisição HTTP foi corretamente concluída. 
			As respostas são agrupadas em cinco classes:
			Respostas de informação (100-199),
			Respostas de sucesso (200-299),
			Redirecionamentos (300-399)
			Erros do cliente (400-499)
			Erros do servidor (500-599).
			*******************************************************/
		EndIf
		IF "204 No Content" $ cHeadRet 
			lRet := .T.
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
STATIC FUNCTION LoginNectar(xAmb)
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
Elseif cAmbiente == '2' //homologação
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
	_cEmail   := GETMV("WFSTCRM07")

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


