/****************************************
Ação.........: Gerar arquivo CSV de pedidos de venda com saldo a serer faturado.
.............: Estes pedidos de venda gerados serão importados para dentro da empresa 11.
Regras.......: Somente serão gerados arquivos para pedidos que <<< NÃO >>> estejam com o STATUS:
.............: - Pedido com "ELIMINAÇÃO DE RESÍDUO" = C5_NOTA $ 'XXXX' .AND. C5_ZFATBLQ $ '1/2'
.............: - Pedido de Venda "CANCELADO" = C5_NOTA $ 'XXXX' .AND. (C5_ZFATBLQ = '3' .OR. C5_ZFATBLQ = ' ') 
.............: - Pedido de Venda "FATURADO TOTALMENTE" = !C5_NOTA $ 'XXXX' .AND. C5_ZFATBLQ == '1'
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 15/12/2021
Chamados.....: 20211214026690
****************************************/
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"

USER FUNCTION MSTECK07()
PRIVATE cNumPed := ""
PRIVATE nTotRec := 0
PRIVATE nCount  := 0 
PRIVATE aVetor  := {}
PRIVATE aVetAux := {}
PRIVATE aSX3SC5 := {}
PRIVATE aSX3SC6 := {}
PRIVATE aPergs   := {}
PRIVATE cNumIni  := Space(TamSX3('C6_NUM')[01])
PRIVATE cNumFim  := Space(TamSX3('C6_NUM')[01])
AADD(aPergs, {1, "Pedido De  ", cNumIni,  "", ".T.", "", ".T.", 60,  .T.})
AADD(aPergs, {1, "Pedido Até ", cNumFim,  "", ".T.", "", ".T.", 60,  .T.})

IF MSGYESNO("Deseja gerar os arquivos do Pedido de Venda!")
 
  IF !ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
    RETURN
  ELSE
    IF EMPTY(MV_PAR01) .OR. EMPTY(MV_PAR02)
      MSGALERT("Informe um número de pedido inicial / final.")
      RETURN
    ENDIF
  ENDIF


  /**********************************
  Montagem da query que irá selecionar os pedidos de venda 
  que estão com saldo a ser faturado e que não pertençam  aos seguintes STATUS:

  <<< Regras de Saldo a ser Faturado >>>
  (C6_QTDVEN - C6_QTDENT) > 0 

  <<< Regras de STATUS que não devem entrar na query >>>
  <<< Fonte de referência: MA410LEG.PRW >>>

  - Pedido com "ELIMINAÇÃO DE RESÍDUO"
  C5_NOTA $ 'XXXX' .AND. C5_ZFATBLQ $ '1/2'

  - Pedido de Venda "CANCELADO"
  C5_NOTA $ 'XXXX' .AND. (C5_ZFATBLQ = '3' .OR. C5_ZFATBLQ = ' ') 

  - Pedido de Venda "FATURADO TOTALMENTE"
  !C5_NOTA $ 'XXXX' .AND. C5_ZFATBLQ == '1'
  ***********************************/
  cQuery := "SELECT C5_FILIAL, C5_NUM, C5.R_E_C_N_O_ AS SC5REC, C6.R_E_C_N_O_ AS SC6REC FROM "+RetSqlName("SC5")+" C5 "
  cQuery += "INNER JOIN "+RetSqlName("SC6")+" C6 ON C6.D_E_L_E_T_ = ' ' "
  cQuery += "  AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM "
  cQuery += "  AND (C6.C6_QTDVEN - C6_QTDENT) > 0 "
  cQuery += "WHERE C5.D_E_L_E_T_ = ' ' AND C5.C5_FILIAL = '"+XFILIAL("SC5")+"' "
  cQuery += "  AND NOT (SUBSTRING(C5.C5_NOTA,1,1) = 'X' AND C5.C5_ZFATBLQ IN ('1','2')) "
  cQuery += "  AND NOT (SUBSTRING(C5.C5_NOTA,1,1) = 'X' AND (C5.C5_ZFATBLQ = '3' OR C5.C5_ZFATBLQ = ' ')) "
  cQuery += "  AND NOT (SUBSTRING(C5.C5_NOTA,1,1) <> 'X' AND C5.C5_ZFATBLQ = '1' ) "
  cQuery += "  AND C5.C5_TIPO = 'N' "
//  cQuery += "  AND C5.C5_ESPECI4 = ' ' "

  cQuery += "  AND C5.C5_NUM >= '"+MV_PAR01+"' AND C5.C5_NUM <= '"+MV_PAR02+"' "

  cQuery += "GROUP BY C5_FILIAL, C5_NUM,C5.R_E_C_N_O_, C6.R_E_C_N_O_ "
  cQuery += "ORDER BY C5_FILIAL, C5_NUM "
  cQuery := ChangeQuery(cQuery)
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC5', .F., .T.)
  IF EMPTY(TSC5->C5_NUM)

    MSGALERT("Não foi possível encontrar pedidos de venda com saldo a faturar!")
    TSC5->(DBCLOSEAREA())
    RETURN
  ELSE
    PROCESSA({ || MSTECK7A()}, "Aguarde", "Processando Pedidos de Venda...")
    TSC5->(DBCLOSEAREA())
  ENDIF
ENDIF

RETURN


/*******************************************
Gera os arquivos CSV paara os Pedidos de Venda
********************************************/
STATIC FUNCTION MSTECK7A()
LOCAL i := 0 
LOCAL nX := 0 
LOCAL nHdl := 0
LOCAL cPath := "C:\TEMP\PEDIDO_VENDA\"
LOCAL cNomArq := ""
LOCAL nItemSC6 := 0
PRIVATE nVlVen := 0
PRIVATE nVlUni := 0
PRIVATE nVlVal := 0
PRIVATE nVlIpi := 0
PRIVATE nVlST  := 0
/******************************
Carrega no vetor todos os campos da tabela SC5 
Despresando os campos virtuais
******************************/
AADD(aSX3SC5,"CABECALHO"  )  // 
AADD(aSX3SC5,"C5_TIPO"    )
AADD(aSX3SC5,"C5_TIPOCLI" )
AADD(aSX3SC5,"C5_CLIENTE" )
AADD(aSX3SC5,"C5_LOJACLI" )
AADD(aSX3SC5,"C5_CLIENT"	)
AADD(aSX3SC5,"C5_LOJAENT" )
AADD(aSX3SC5,"C5_EMISSAO" )
AADD(aSX3SC5,"C5_CONDPAG" )
AADD(aSX3SC5,"C5_ZCONDPG" )
AADD(aSX3SC5,"C5_TPFRETE" ) 
AADD(aSX3SC5,"C5_XTIPO"   ) 
AADD(aSX3SC5,"C5_XTIPF"   ) 
AADD(aSX3SC5,"C5_ZCONSUM" ) 

/******************************
Carrega no vetor todos os campos obrigatórios da tabela SC6 
Despresando os campos virtuais
******************************/
AADD(aSX3SC6,"ITEM"		    )
AADD(aSX3SC6,"C6_ITEM"	  )
AADD(aSX3SC6,"C6_PRODUTO" )
AADD(aSX3SC6,"C6_OPER"	  )
AADD(aSX3SC6,"C6_TES"		  )
AADD(aSX3SC6,"C6_QTDVEN"  )
AADD(aSX3SC6,"C6_PRCVEN"  )
AADD(aSX3SC6,"C6_PRUNIT"  )
AADD(aSX3SC6,"C6_VALOR"	  )
AADD(aSX3SC6,"C6_LOCAL"	  )
AADD(aSX3SC6,"C6_NUMPCOM" )
AADD(aSX3SC6,"C6_ITEMPC"	)
AADD(aSX3SC6,"C6_XORDEM"	)



//AADD(aSX3SC6,"C6_CF"			)
//AADD(aSX3SC6,"C6_UM"		  )

//// Pega quantidade de registros a serem gravados
TSC5->(DBGOTOP())
nTotRec := 0
DbEval({|| nTotRec++  })
PROCREGUA(nTotRec)
TSC5->(DBGOTOP())

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

WHILE TSC5->(!EOF())

	nCount++
	INCPROC("Gravando informações...."+ALLTRIM(STR(nCount))+" / "+ALLTRIM(STR(nTotRec)))

  IF ALLTRIM(cNumPed) <> ALLTRIM(TSC5->C5_NUM)

    //// Gra o número do pedido para controle
    cNumPed := ALLTRIM(TSC5->C5_NUM)
    nItemSC6 := 0

    /************************
    Posiciona no registro 
    ************************/
    aVetor  := {}
    SC5->(DBSETORDER(1))
    SC5->(DBGOTO(TSC5->SC5REC))
    
    /************************
    Grava no campo C5_ESPECI4 = "E" para saber que o pedido não poderá ser Exportado novamente
    ************************/
    RECLOCK("SC5",.F.)
    SC5->C5_ESPECI4 := "E"
    SC5->(MSUNLOCK())

    SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
        
    /************************
    Grava os campos do cabeçalho do Pedido de Vendas
    ************************/
    FOR i := 1 TO LEN(aSX3SC5)
      IF i = 1
        AADD(aVetor,{"CABECALHO"})
      ELSE
        AADD(aVetor[LEN(aVetor)],SC5->&(aSX3SC5[i]))
      ENDIF
    NEXT i

    /************************
    Grava os campos do Item do Pedido de Vendas
    ************************/
    SC6->(DBSETORDER(1))
    SC6->(DBGOTO(TSC5->SC6REC))
    nItemSC6++

    nVlVen := 0
    nVlUni := 0
    nVlVal := 0
    nVlST := 0
    nVlIpi := 0

    //// Chama a rotina para pegar os impostos de ST e IPI 
    XRETIMP()

    IF AllTrim(SA1->A1_EST) <> "SP"
      nVlST := 0
      /***********************
      IF SC5->C5_CLIENTE = '003322' .AND. SC5->C5_LOJACLI = '01'
        nVlST := SC6->C6_ZVALIST / SC6->C6_QTDVEN
      ELSE
        nVlST := SC6->C6_ZVALIST
      ENDIF
      ************************/
    ENDIF

    /************************
    Posiciona no cadastro do produto para saber se é importado
    Se o cliente for MAZXEL'003322-01' o valor do IPI deve ser dividido pela quantidade caso contrário o valor está certo.
    IF SC5->C5_CLIENTE = '003322' .AND. SC5->C5_LOJACLI = '01'
      nVlIpi := SC6->C6_ZVALIPI / SC6->C6_QTDVEN
    ELSE
      nVlIpi := SC6->C6_ZVALIPI
    ENDIF
    ************************/

    SB1->(DBSETORDER(1))
    SB1->(DBSEEK(XFILIAL("SB1")+SC6->C6_PRODUTO))
    IF SB1->B1_CLAPROD <> "I" 
      nVlVen := ROUND((SC6->C6_PRCVEN + nVlIpi + nVlST),2)
      nVlUni := ROUND((SC6->C6_PRCVEN + nVlIpi + nVlST),2)
      nVlVal := ROUND(((SC6->C6_QTDVEN - SC6->C6_QTDENT) * nVlVen),2)
    ELSE
      nVlVen := ROUND((SC6->C6_PRCVEN),2)
      nVlUni := ROUND((SC6->C6_PRUNIT),2)
      nVlVal := ROUND(((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN),2)
    ENDIF

    FOR i := 1 TO LEN(aSX3SC6)
      IF i = 1
        AADD(aVetor,{"ITEM"})
      ELSE
        IF aSX3SC6[i] = "C6_QTDVEN"
          AADD(aVetor[LEN(aVetor)],(SC6->C6_QTDVEN - SC6->C6_QTDENT))
        ELSEIF aSX3SC6[i] = "C6_PRCVEN"
          AADD(aVetor[LEN(aVetor)],nVlVen)
        ELSEIF aSX3SC6[i] = "C6_PRUNIT"
          AADD(aVetor[LEN(aVetor)],nVlUni)
        ELSEIF aSX3SC6[i] = "C6_VALOR"
          AADD(aVetor[LEN(aVetor)],nVlVal)
        ELSEIF aSX3SC6[i] = "C6_TES"
          AADD(aVetor[LEN(aVetor)]," ")
        ELSE
          AADD(aVetor[LEN(aVetor)],SC6->&(aSX3SC6[i]))
        ENDIF
      ENDIF
    NEXT i
  ELSE
    /************************
    Grava os campos do Item do Pedido de Vendas
    ************************/
    SC6->(DBSETORDER(1))
    SC6->(DBGOTO(TSC5->SC6REC))
    nItemSC6++

    nVlVen := 0
    nVlUni := 0
    nVlVal := 0
    nVlST := 0
    nVlIpi := 0

    //// Chama a rotina para pegar os impostos de ST e IPI 
    XRETIMP()

    IF AllTrim(SA1->A1_EST) <> "SP"
      nVlST := 0
      /***********************
      IF SC5->C5_CLIENTE = '003322' .AND. SC5->C5_LOJACLI = '01'
        nVlST := SC6->C6_ZVALIST / SC6->C6_QTDVEN
      ELSE
        nVlST := SC6->C6_ZVALIST
      ENDIF
      ************************/
    ENDIF

    /************************
    Posiciona no cadastro do produto para saber se é importado
    Se o cliente for MAZXEL'003322-01' o valor do IPI deve ser dividido pela quantidade caso contrário o valor está certo.
    IF SC5->C5_CLIENTE = '003322' .AND. SC5->C5_LOJACLI = '01'
      nVlIpi := SC6->C6_ZVALIPI / SC6->C6_QTDVEN
    ELSE
      nVlIpi := SC6->C6_ZVALIPI
    ENDIF
    ************************/

    SB1->(DBSETORDER(1))
    SB1->(DBSEEK(XFILIAL("SB1")+SC6->C6_PRODUTO))
    IF SB1->B1_CLAPROD <> "I" 
      nVlVen := ROUND((SC6->C6_PRCVEN + nVlIpi + nVlST),2)
      nVlUni := ROUND((SC6->C6_PRCVEN + nVlIpi + nVlST),2)
      nVlVal := ROUND(((SC6->C6_QTDVEN - SC6->C6_QTDENT) * nVlVen),2)
    ELSE
      nVlVen := ROUND((SC6->C6_PRCVEN),2)
      nVlUni := ROUND((SC6->C6_PRUNIT),2)
      nVlVal := ROUND(((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN),2)
    ENDIF

    FOR i := 1 TO LEN(aSX3SC6)
      IF i = 1
        AADD(aVetor,{"ITEM"})
      ELSE
        IF aSX3SC6[i] = "C6_QTDVEN"
          AADD(aVetor[LEN(aVetor)],(SC6->C6_QTDVEN - SC6->C6_QTDENT))
        ELSEIF aSX3SC6[i] = "C6_PRCVEN"
          AADD(aVetor[LEN(aVetor)],nVlVen)
        ELSEIF aSX3SC6[i] = "C6_PRUNIT"
          AADD(aVetor[LEN(aVetor)],nVlUni)
        ELSEIF aSX3SC6[i] = "C6_VALOR"
          AADD(aVetor[LEN(aVetor)],nVlVal)
        ELSEIF aSX3SC6[i] = "C6_TES"
          AADD(aVetor[LEN(aVetor)]," ")
        ELSE
          AADD(aVetor[LEN(aVetor)],SC6->&(aSX3SC6[i]))
        ENDIF
      ENDIF
    NEXT i
  ENDIF
  TSC5->(DBSKIP())

  IF cNumPed <> ALLTRIM(TSC5->C5_NUM)

    /******************************************
    Grava o Arquivo baseado no vetor montado.
    ******************************************/
    cNomArq := "PEDIDO_VENDA_"+cNumPed+"_"+DTOS(DATE())+".CSV"
	  nHdl := FCreate(Upper(cPath+cNomArq))
	  IF ExistDir("C:\TEMP\PEDIDO_VENDA\") = .F.
      MakeDir("C:\TEMP\PEDIDO_VENDA\")
    ENDIF
    FOR i := 1 TO LEN(aVetor)
      cLinha := ""
      FOR nX := 1 TO LEN(aVetor[i])
        //// Verifica se o campo é DATA
        IF VALTYPE(aVetor[i,nX]) = "D"
          cLinha += DTOC(aVetor[i,nX])+";"
        //// Verifica se o campo é NUMÉRICO
        ELSEIF VALTYPE(aVetor[i,nX]) = "N"
          aVetor[i,nX] := MSTECK7C(ALLTRIM(STR(aVetor[i,nX]))) 
          cLinha += aVetor[i,nX]+";"
        ELSE
          cLinha += ALLTRIM(aVetor[i,nX])+";"
        ENDIF
      NEXT
      cLinha += Chr(13)+Chr(10)
      FWrite(nHdl,cLinha)
    NEXT
    FClose(nHdl)

  ENDIF

ENDDO

RETURN

/*************************
Rotina para Alterar campos Numéricos trocando a casa Descimal de "." para ","
Estou efetuando esta troca pois os arquivos que serão gerados de forma manual
pelos usuários estarão com a casa Decimal com ",".
Assim o fonte de importação não terá problema na hora de converter o valor de texto para numérico.
************************/
STATIC FUNCTION MSTECK7C(xcValor)
LOCAL _cValor := ""
LOCAL nZ := 0 
FOR nZ := 1 TO LEN(xcValor)
  IF SUBSTR(xcValor,nZ,1) = "."
    _cValor += ","
  ELSE
    _cValor += SUBSTR(xcValor,nZ,1)
  ENDIF
NEXT

RETURN _cValor


STATIC FUNCTION XRETIMP()
	Local	nAliqICM 		:= 0
	Local	nValICms		:= 0
	Local	nAliqIPI 		:= 0
	Local	nValIPI 		:= 0
	Local	nValICMSST 	:= 0
	Local	nValPis			:= 0
	Local naliqICMSST := 0
	Local	nValCof			:= 0
	Local nValCmp     := 0
  LOCAL nValDif     := 0

	MaFisSave()
	MaFisEnd()
	MaFisIni(SC5->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,;		// 2-Loja do Cliente/Fornecedor
	IIf(SC5->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,;				// 4-Tipo da NF
	SC5->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

	// 10-Nome da rotina que esta utilizando a funcao
	MaFisAdd(SC6->C6_PRODUTO,;  // 1-Codigo do Produto ( Obrigatorio )
	SC6->C6_TES,;               // 2-Codigo do TES ( Opcional )
	SC6->C6_QTDVEN,;            // 3-Quantidade ( Obrigatorio )
	SC6->C6_PRCVEN,;            // 4-Preco Unitario ( Obrigatorio )
	0,;                         // 5-Valor do Desconto ( Opcional )
	,;                          // 6-Numero da NF Original ( Devolucao/Benef )
	,;                          // 7-Serie da NF Original ( Devolucao/Benef )
	,;                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                         // 9-Valor do Frete do Item ( Opcional )
	0,;                         // 10-Valor da Despesa do item ( Opcional )
	0,;                         // 11-Valor do Seguro do item ( Opcional )
	0,;                         // 12-Valor do Frete Autonomo ( Opcional )
	SC6->C6_PRCVEN,;         // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                         // 14-Valor da Embalagem ( Opiconal )
	0,;                         // 15-RecNo do SB1
	0)                          // 16-RecNo do SF4

	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	nValICms	:= round(MaFisRet(1,'IT_VALICM',14,2) ,2 )

	nAliqIPI 	:= round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
	nValIPI 	:= round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )

	nValICMSST 	:= round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )
	naliqICMSST 	:= nValICMSST * 100 / ROUND(MaFisRet(1,'IT_BASEICM',14,2) ,2 )

	nValPis		:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )

	nValCof		:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )

	//DIFAL
	nValCmp 	:= 0//noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()


//// Retornar os valores unitários do ICMST / IPI
nVlST  := ROUND(nValICMSST,2)
nVlIpi := ROUND(nValIPI,2)

///	aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
///	aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
///	aCols[n][nPosIpi]		:= 	 nAliqIPI
///	aCols[n][nPosCOMISS]	:=  naliqICMSST


RETURN
