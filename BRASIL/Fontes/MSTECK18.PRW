/****************************************
Ação.........: Job de geração de pedido de venda na industria
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 25/05/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "Fileio.ch"
#Include 'FwMVCDef.ch'


#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK18()
LOCAL _cLockBy := ""

IF SELECT("SX2") == 0 
  PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
	cEmpSch   := cEmpAnt
	cFilSched := cFilAnt
  _cLockBy := alltrim("MSTECK16_18"+cEmpSch+cFilSched+GetEnvServer())
  //_cLockBy := alltrim("MSTECK16_18"+cEmpSch+cFilSched)
  IF !LockByName(_cLockBy,.F.,.F.,.T.)
    CONOUT("[MSTECK18] - Rotina sendo executada por outro processo!")
    RETURN
  ELSE
    //_cLockBy		:= "MSTECK18XX"
    MSTECK18A()
    UnLockByName(_cLockBy,.F.,.F.,.T.)
    RESET ENVIRONMENT
  ENDIF
ELSE
	cEmpSch   := cEmpAnt
	cFilSched := cFilAnt
  //_cLockBy := alltrim("MSTECK16_18"+cEmpSch+cFilSched)
  _cLockBy := alltrim("MSTECK16_18"+cEmpSch+cFilSched+GetEnvServer())
  IF !LockByName(_cLockBy,.F.,.F.,.T.)
    MSGALERT("Rotina sendo executada por outro processo!")
    RETURN
  ELSE
    //_cLockBy		:= "MSTECK18XX"
    MSTECK18A()
    UnLockByName(_cLockBy,.F.,.F.,.T.)
  ENDIF
ENDIF

RETURN

STATIC FUNCTION MSTECK18A()
LOCAL i := 0
LOCAL aResult := {}
LOCAL cCodFor := ""
LOCAL aString := strtokarr (GETMV("MSTECK18",,"005866/005764"), "/")
LOCAL nSaldo  := 0
LOCAL nQtdReserva := 0 
LOCAL aVetSC7 := {}
LOCAL _cCodEmp := ""
PRIVATE lRet := .F.
PRIVATE aVetErro := {}

FOR i := 1 TO LEN(aString)
  cCodFor += "'"+aString[i]+"',"
NEXT
cCodFor := SUBSTR(cCodFor,1,(LEN(cCodFor)-1))

DbSelectArea("ZA6")
DbSelectArea("Z96")
DbSelectArea("SC6")
SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

/**************************************
Busca todos os pedidos de compras que se referem aos fornecedores da Industria
***************************************/
cQuery := "SELECT C7.C7_NUM FROM "+RetSqlName("SC7")+" C7 "+CL
cQuery += "WHERE C7.D_E_L_E_T_ = ' ' "+CL
cQuery += "AND C7.C7_FORNECE IN ("+cCodFor+") "+CL
cQuery += "AND C7.C7_XPEDVEN = ' ' "   ////HABILITAR EM PRODUÇÃO OU ATÉ TER NOVOS PEDIDOS 
cQuery += " AND C7.C7_QUANT-C7.C7_QUJE>0 AND C7_RESIDUO=' ' 
cQuery += "GROUP BY C7.C7_NUM "+CL
cQuery += "ORDER BY C7.C7_NUM "+CL
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
CONOUT("[MSTECK18] - Inicio do processmento:"+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5) )
WHILE TSC7->(!EOF())

  //// Posiciona na SC5 
  SC7->(DBSETORDER(1))
  SC7->(DBSEEK(XFILIAL("SC7")+TSC7->C7_NUM))

  /******************************************************
  Efetuar validaçòes prévias na base de dados da Indústria correspondente, aFim de retornar um WorkFlow para as áreas
  1 - Produtos com bloqueio no campo B1_MSBLQL
  2 - Produto Desativado B1_XMSBLQL
  3 - Transfer Price: Tabela relacionamento tabela DA1 e RRO
  ******************************************************/
  lRet := .F.
  lRet := MSTECK18B(TSC7->C7_NUM)

  IF lRet = .T.

    aResult := U_StWeb070(1)
    
    IF aResult[01] = .T.

      CONOUT("[MSTECK18] - Pedido de Venda Indústria: "+RIGHT(aResult[04],6)+" - "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5) )
      //// Filial Guararema
      IF SC7->C7_FORNECE = "005764"
        cQuery := "SELECT C6.C6_NUM,C6.C6_ITEM,C6.C6_NUMPCOM,C6.C6_ITEMPC FROM "+AllTrim(GetMv("STALIASIND"))+".SC6010 C6 "+CL
        cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CL
        cQuery += "AND C6.C6_NUM = '"+RIGHT(aResult[04],6)+"' "+CL
        cQuery += "ORDER BY C6.C6_ITEM"+CL
        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)
        WHILE TSC6->(!EOF())
          SC7->(DBSETORDER(1))
          IF SC7->(DBSEEK(XFILIAL("SC7")+ALLTRIM(TSC6->C6_NUMPCOM)+ALLTRIM(TSC6->C6_ITEMPC)))
            RECLOCK("SC7",.F.)
            SC7->C7_XPEDVEN := TSC6->C6_NUM  //// Campo que conterá o número do pedido de venda.
            SC7->C7_XITEMPV := TSC6->C6_ITEM //// Campo que conterá a qual item do pedido de venda foi atrelado.
            SC7->C7_XDATAPV := DATE()        //// Campo para informação da data que o pedido de venda foi gerado.
            SC7->(MSUNLOCK())

            /********************************
            Grava o RECNO do pedido de compras no vetor para autlizar a tabela Z96
            ********************************/
            AADD(aVetSC7,{SC7->(RECNO()),TSC6->C6_NUM,TSC6->C6_ITEM,"0101","PC"})
          ENDIF
          TSC6->(DBSKIP())
        ENDDO
        TSC6->(DBCLOSEAREA())
      //// Filial Manaus
      ELSEIF SC7->C7_FORNECE = "005866"

        cQuery := "SELECT C6.C6_NUM,C6.C6_ITEM,C6.C6_NUMPCOM,C6_ITEMPC FROM "+AllTrim(GetMv("STALIASIND"))+".SC6030 C6 "+CL
        cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CL
        cQuery += "AND C6.C6_NUM = '"+RIGHT(aResult[04],6)+"' "+CL
        cQuery += "ORDER BY C6.C6_ITEM "+CL
        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)
        WHILE TSC6->(!EOF())
          SC7->(DBSETORDER(1))
          IF SC7->(DBSEEK(XFILIAL("SC7")+ALLTRIM(TSC6->C6_NUMPCOM)+ALLTRIM(TSC6->C6_ITEMPC)))
            RECLOCK("SC7",.F.)
            SC7->C7_XPEDVEN := TSC6->C6_NUM  //// Campo que conterá o número do pedido de venda.
            SC7->C7_XITEMPV := TSC6->C6_ITEM //// Campo que conterá a qual item do pedido de venda foi atrelado.
            SC7->C7_XDATAPV := DATE()        //// Campo para informação da data que o pedido de venda foi gerado.
            SC7->(MSUNLOCK())

            /********************************
            Grava o RECNO do pedido de compras no vetor para autlizar a tabela Z96
            ********************************/
            AADD(aVetSC7,{SC7->(RECNO()),TSC6->C6_NUM,TSC6->C6_ITEM,"0301","PC"})
          ENDIF
          TSC6->(DBSKIP())
        ENDDO
        TSC6->(DBCLOSEAREA())
      ENDIF
    ELSE
      CONOUT("[MSTECK18] - ERRO - "+ALLTRIM(aResult[02])+" - "+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5) )
    ENDIF
  ENDIF  
  
  TSC7->(DBSKIP())
ENDDO
TSC7->(DBCLOSEAREA())


/***************************
Verifica se algum pedido retornou com erro de integração.
Se retornou dispara e-mail
***************************/
IF LEN(aVetErro) > 0 
  MSTECK18D()
ENDIF

/******************************
Baseado nos RECNOS da tabela SC7 iremos alimentar a tabela Z96 e os pedidos de Venda amarrados na PA1
******************************/

cQuery := " SELECT C7.R_E_C_N_O_ SC7REC, C7_PRODUTO, C7_QUANT-C7_QUJE C7SLD,
cQuery += " CASE WHEN C7_XDTENT2<>' ' THEN C7_XDTENT2 ELSE C7_DATPRF END DATASC7,
cQuery += " NVL(Z96_QTDATE,0) QTDZ96,
cQuery += " C7_QUANT-C7_QUJE-NVL(Z96_QTDATE,0) SALDO
cQuery += " FROM "+RetSqlName("SC7")+" C7
cQuery += " LEFT JOIN (
cQuery += " SELECT Z96_FILIAL, Z96_PROD, Z96_PEDCOM, Z96_ITECOM, SUM(NVL(Z96_QTDATE,0)) Z96_QTDATE
cQuery += " FROM "+RetSqlName("Z96")+" Z96
cQuery += " WHERE Z96.D_E_L_E_T_=' ' 
cQuery += " GROUP BY Z96_FILIAL, Z96_PROD, Z96_PEDCOM, Z96_ITECOM
cQuery += " ) Z96
cQuery += " ON Z96_FILIAL=C7_FILIAL AND Z96_PROD=C7_PRODUTO AND Z96_PEDCOM=C7_NUM AND Z96_ITECOM=C7_ITEM
cQuery += " WHERE C7.D_E_L_E_T_=' ' 
cQuery += " AND C7_QUANT-C7_QUJE>0
cQuery += " AND C7_FORNECE IN ('005866','005764')
cQuery += " AND C7_RESIDUO=' ' 
cQuery += " AND C7_PO_EIC=' ' 
cQuery += " AND C7_QUANT-C7_QUJE-NVL(Z96_QTDATE,0)>0
cQuery += " AND C7_XPEDVEN<>' ' AND C7_XITEMPV<>' '
//cQuery += " ORDER BY C7_PRODUTO, CASE WHEN C7_XDTENT2<>' ' THEN C7_XDTENT2 ELSE C7_DATPRF END
cQuery += " ORDER BY C7_PRODUTO, CASE WHEN C7_XDTENT2<>' ' THEN C7_XDTENT2 ELSE C7_DATPRF END,C7_NUM,C7_ITEM "+CL

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
WHILE TSC7->(!EOF())

  SC7->(DBSETORDER(1))
  SC7->(DBGOTO(TSC7->SC7REC))

  //// Variável para controlar o saldo 
  nSaldo := TSC7->SALDO
  
  cQuery := " SELECT PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
  cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_NUM = SUBSTR(PA1.PA1_DOC,1,6) "+CL
  cQuery += " LEFT JOIN "+RetSqlName("SC6")+" C6
  cQuery += " ON C6_FILIAL=PA1_FILIAL AND C6_NUM||C6_ITEM=PA1_DOC
  cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_=' ' AND PA1.PA1_TIPO = '1' AND PA1.PA1_SALDO > 0 "+CL
  cQuery += " AND PA1.PA1_CODPRO = '"+SC7->C7_PRODUTO+"' "+CL
  cQuery += " AND C6_OPER='01'
  cQuery += " ORDER BY C5.R_E_C_N_O_ "+CL
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
  WHILE TPA1->(!EOF()) .AND. nSaldo > 0 

    /*******************************
    Verifica se ainda tem saldo para atender as reservas
    *******************************/
    IF nSaldo > 0
    
      //// Posiciona na tabela PA1 para atualizar o saldo 
      PA1->(DBSETORDER(1))
      PA1->(DBGOTO(TPA1->PA1REC))

      /********************************
      Busca o saldo a reservar no PA1
      Verifica se a variável nSaldo descontando o saldo da PA1 ficará negativa.
      Neste caso a variável nSaldo é zerada e somente será consumido a diferença entre o PA1_SALDO 
      ********************************/
      nQtdReserva := 0
    
      //// Quando a variável nSaldo for maior que a PA1_SALDO 
      IF nSaldo >= PA1->PA1_SALDO
        nSaldo := nSaldo - PA1->PA1_SALDO
        nQtdReserva := PA1->PA1_SALDO
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := 0
        PA1->(MSUNLOCK())
      ELSEIF nSaldo < PA1->PA1_SALDO
        nQtdReserva := nSaldo
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := PA1->PA1_SALDO - nSaldo
        PA1->(MSUNLOCK())
        nSaldo := 0 
      ENDIF 

      /**************************
      Atualiza a tabela de integração 
      **************************/
      _cCodEmp := ""
      IF SC7->C7_FORNECE = "005866"
        _cCodEmp := "0301"
      ELSEIF SC7->C7_FORNECE = "005764"
        _cCodEmp := "0105"
      ENDIF

      RECLOCK("Z96",.T.)
      Z96->Z96_FILIAL  := XFILIAL("Z96")
      Z96->Z96_PA1DOC  := PA1->PA1_DOC
      Z96->Z96_PROD    := SC7->C7_PRODUTO
      Z96->Z96_PEDCOM  := SC7->C7_NUM
      Z96->Z96_ITECOM  := SC7->C7_ITEM
      Z96->Z96_PVIND   := SC7->C7_XPEDVEN
      Z96->Z96_ITPVIND := SC7->C7_XITEMPV
      Z96->Z96_QTDATE  := nQtdReserva
      Z96->Z96_DTPVIN  := IIf(!Empty(SC7->C7_XDTENT2),SC7->C7_XDTENT2,SC7->C7_DATPRF)
      Z96->Z96_ZENTR1 := SC7->C7_ZENTRE1
      Z96->Z96_ZMOTAL := SC7->C7_ZMOTALT
      Z96->Z96_ZENTRC := SC7->C7_ZENTREC
      Z96->Z96_EMPFIL  := IIF(EMPTY(SC7->C7_PO_EIC),_cCodEmp,"1101")
      Z96->Z96_TIPREG  := IIF(EMPTY(SC7->C7_PO_EIC),"PC","PO")
      Z96->(MSUNLOCK())

      /*******************************************************
      Somente altera a data de entrega 2 se a mesma estiver em branco.
      Este tratamento está sendo executado pois pode haver casos de geração parcial da tabela Z96
      *******************************************************/
      SC6->(DBSETORDER(1))
      If SC6->(DbSeek(xFilial("SC6")+SubStr(PA1->PA1_DOC,1,8)))
        IF EMPTY(SC6->C6_ZENTRE2)
          SC6->(RecLock("SC6",.F.))
          SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
          SC6->C6_ZENTRE1 := Z96->Z96_ZENTR1
          SC6->C6_ZMOTALT := Z96->Z96_ZMOTAL
          SC6->C6_ZENTREC := Z96->Z96_ZENTRC
          SC6->(MsUnLock())
        ELSE
          /********************************
          Monta a query para buscar na Z96 a maior data para este pedido/item
          ********************************/
          cQuery := "SELECT Z96.Z96_PA1DOC, MAX(Z96_DTPVIN) MAIORDATA FROM "+RetSqlName("Z96")+" Z96 "
          cQuery += " WHERE Z96.Z96_FILIAL = '"+XFILIAL('Z96')+"' "
          cQuery += "AND Z96.Z96_PA1DOC = '"+Z96->Z96_PA1DOC+"' "
          cQuery += " AND Z96.D_E_L_E_T_ = ' ' "
          cQuery += "GROUP BY Z96.Z96_PA1DOC "
          DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ96', .F., .T.)
          IF ! TZ96->(EOF())
             DBSELECTAREA('SC6')
             //IF SC6->C6_ZENTRE2 < STOD(TZ96->MAIORDATA)
            SC6->(RecLock("SC6",.F.))
            SC6->C6_ZENTRE2 := STOD(TZ96->MAIORDATA)
            SC6->(MsUnLock())
             //ELSE
             //SC6->(RecLock("SC6",.F.))
             //SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
             //SC6->(MsUnLock())
          ENDIF
          TZ96->(DBCLOSEAREA())
        ENDIF
      EndIf

    ENDIF
    TPA1->(DBSKIP())
  ENDDO
  TPA1->(DBCLOSEAREA())
  TSC7->(DBSKIP())
ENDDO
TSC7->(DBCLOSEAREA())

/****************************************
Embarques COMEX 
****************************************/
cQuery := " SELECT ZA6.R_E_C_N_O_ ZA6REC, ZA6_QUANT-ZA6_CONSUM ZA6SALDO, C7_NUM, ZA6_DATA, C7_QUJE
cQuery += " FROM "+RetSqlName("ZA6")+" ZA6
cQuery += " LEFT JOIN "+RetSqlName("SC7")+" C7
cQuery += " ON C7_FILIAL=ZA6_FILIAL AND C7_PO_EIC=ZA6_PO AND C7_ITEM=ZA6_ITEM
cQuery += " WHERE ZA6.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' ' AND ZA6_QUANT-ZA6_CONSUM>0 
cQuery += " AND C7_QUANT-C7_QUJE>0
//cQuery += " ORDER BY ZA6_DATA
cQuery += " ORDER BY ZA6_FILIAL,ZA6_PROD,ZA6_DATA "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
WHILE TSC7->(!EOF())

  ZA6->(DBSETORDER(1))
  ZA6->(DBGOTO(TSC7->ZA6REC))

  If ZA6->ZA6_QUANT-TSC7->C7_QUJE<=0 //Já foi entregue
    TSC7->(DBSKIP())
    Loop
  EndIf

  nSaldo := ZA6->ZA6_QUANT-TSC7->C7_QUJE-ZA6->ZA6_CONSUM

  cQuery := " SELECT PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
  cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_NUM = SUBSTR(PA1.PA1_DOC,1,6) "+CL
  cQuery += " LEFT JOIN "+RetSqlName("SC6")+" C6
  cQuery += " ON C6_FILIAL=PA1_FILIAL AND C6_NUM||C6_ITEM=PA1_DOC
  cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_=' ' AND PA1.PA1_TIPO = '1' AND PA1.PA1_SALDO > 0 "+CL
  cQuery += " AND PA1.PA1_CODPRO = '"+ZA6->ZA6_PROD+"' "+CL
  cQuery += " AND C6_OPER='01'
  cQuery += " ORDER BY C5.R_E_C_N_O_ "+CL
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
  WHILE TPA1->(!EOF()) .AND. nSaldo > 0 

    /*******************************
    Verifica se ainda tem saldo para atender as reservas
    *******************************/
    IF nSaldo > 0
    
      //// Posiciona na tabela PA1 para atualizar o saldo 
      PA1->(DBSETORDER(1))
      PA1->(DBGOTO(TPA1->PA1REC))

      /********************************
      Busca o saldo a reservar no PA1
      Verifica se a variável nSaldo descontando o saldo da PA1 ficará negativa.
      Neste caso a variável nSaldo é zerada e somente será consumido a diferença entre o PA1_SALDO 
      ********************************/
      nQtdReserva := 0
    
      //// Quando a variável nSaldo for maior que a PA1_SALDO 
      IF nSaldo >= PA1->PA1_SALDO
        nSaldo := nSaldo - PA1->PA1_SALDO
        nQtdReserva := PA1->PA1_SALDO
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := 0
        PA1->(MSUNLOCK())
      ELSEIF nSaldo < PA1->PA1_SALDO
        nQtdReserva := nSaldo
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := PA1->PA1_SALDO - nSaldo
        PA1->(MSUNLOCK())
        nSaldo := 0 
      ENDIF 

      ZA6->(RecLock("ZA6",.F.))
      ZA6->ZA6_CONSUM += nQtdReserva
      ZA6->(MsUnLock())

      RECLOCK("Z96",.T.)
      Z96->Z96_FILIAL  := XFILIAL("Z96")
      Z96->Z96_PA1DOC  := PA1->PA1_DOC
      Z96->Z96_PROD    := ZA6->ZA6_PROD
      Z96->Z96_PEDCOM  := ZA6->ZA6_PO
      Z96->Z96_ITECOM  := ZA6->ZA6_ITEM
      Z96->Z96_PVIND   := ""
      Z96->Z96_ITPVIND := ""
      Z96->Z96_QTDATE  := nQtdReserva
      Z96->Z96_DTPVIN  := ZA6->ZA6_DATA
      Z96->Z96_EMPFIL  := "1101"
      Z96->Z96_TIPREG  := "PO"
      Z96->Z96_SEQUEN  := ZA6->ZA6_SEQPO
      Z96->(MSUNLOCK())

      /*******************************************************
      Somente altera a data de entrega 2 se a mesma estiver em branco.
      Este tratamento está sendo executado pois pode haver casos de geração parcial da tabela Z96
      *******************************************************/
      SC6->(DBSETORDER(1))
      If SC6->(DbSeek(xFilial("SC6")+SubStr(PA1->PA1_DOC,1,8)))
        IF EMPTY(SC6->C6_ZENTRE2)
          SC6->(RecLock("SC6",.F.))
          SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
          SC6->(MsUnLock())
        ELSE
          /********************************
          Monta a query para buscar na Z96 a maior data para este pedido/item
          ********************************/
          cQuery := " SELECT Z96.Z96_PA1DOC, MAX(Z96_DTPVIN) MAIORDATA FROM "+RetSqlName("Z96")+" Z96 "
          cQuery += " WHERE Z96.Z96_FILIAL = '"+XFILIAL('Z96')+"' "
          cQuery += "AND Z96.Z96_PA1DOC = '"+Z96->Z96_PA1DOC+"' "
          cQuery += " AND Z96.D_E_L_E_T_ = ' ' "
          cQuery += "GROUP BY Z96.Z96_PA1DOC "
          DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ96', .F., .T.)
          IF ! TZ96->(EOF())
            DBSELECTAREA('SC6')
            //IF Z96->Z96_DTPVIN > STOD(TZ96->MAIORDATA)
            SC6->(RecLock("SC6",.F.))
            SC6->C6_ZENTRE2 := STOD(TZ96->MAIORDATA)
            SC6->(MsUnLock())
            //ELSE
            //  SC6->(RecLock("SC6",.F.))
            //  SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
            //  SC6->(MsUnLock())
            //ENDIF
          ENDIF
          TZ96->(DBCLOSEAREA())
        ENDIF
      EndIf

    ENDIF
    TPA1->(DBSKIP())
  ENDDO
  TPA1->(DBCLOSEAREA())
  TSC7->(DBSKIP())
ENDDO
TSC7->(DBCLOSEAREA())

CONOUT("[MSTECK18] - Fim do processmento:"+DTOC(DATE())+" - "+SUBSTR(TIME(),1,5) )
RETURN

/******************************************************
Efetuar validaçòes prévias na base de dados da Indústria correspondente, aFim de retornar um WorkFlow para as áreas
1 - Produtos com bloqueio no campo B1_MSBLQL
2 - Produto Desativado B1_XMSBLQL
3 - Transfer Price: Tabela relacionamento tabela DA1 e RRO
******************************************************/
STATIC FUNCTION MSTECK18B(_xNumPC)
LOCAL _nX := 0
LOCAL _lRet   := .T.
LOCAL cString := "'"
LOCAL cErro1  := ""
LOCAL cErro2  := ""
LOCAL cErro3  := ""
LOCAL cErro4  := ""
LOCAL cErro5  := ""
LOCAL aVetAux := {}
LOCAL aVetAux1:= {}

cQuery := "SELECT C7.C7_NUM,C7.C7_ITEM,C7.C7_PRODUTO,C7.C7_DESCRI FROM "+RetSqlName("SC7")+" C7 "+CL
cQuery += "WHERE C7.D_E_L_E_T_ = ' ' "+CL
cQuery += "AND C7.C7_NUM = '"+_xNumPC+"'  "+CL
cQuery += "AND C7.C7_XPEDVEN = ' ' "
cQuery += "AND C7.C7_QUANT - C7.C7_QUJE > 0 AND C7_RESIDUO = ' ' 
cQuery += "ORDER BY C7.C7_NUM, C7.C7_ITEM "+CL
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'XSC7', .F., .T.)
WHILE XSC7->(!EOF())

  AADD(aVetAux,{XSC7->C7_ITEM,ALLTRIM(XSC7->C7_PRODUTO),ALLTRIM(XSC7->C7_DESCRI)})
  cString += ALLTRIM(XSC7->C7_PRODUTO)+"','"

  XSC7->(DBSKIP())
ENDDO
XSC7->(DBCLOSEAREA())

cString := SUBSTR(cString,1,(LEN(cString)-2))

//// Filial Guararema
IF SC7->C7_FORNECE = "005764"
  cQuery := "SELECT B1.B1_COD, B1.B1_MSBLQL, B1.B1_XMSBLQL,B1.B1_XR01,B1.B1_XDESAT FROM "+AllTrim(GetMv("STALIASIND"))+".SB1010 B1 "+CL
  cQuery += "WHERE B1.D_E_L_E_T_ = ' ' AND (

  For _nX:=1 To Len(aVetAux)
    cQuery += " (B1_COD='"+aVetAux[_nX][2]+"')
    If !_nX==Len(aVetAux)
      cQuery += " OR
    EndIf
  Next

  cQuery += ")
  
  cQuery := ChangeQuery(cQuery)
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSB1', .F., .T.)
//// Filial Manaus
ELSEIF SC7->C7_FORNECE = "005866"
  cQuery := "SELECT B1.B1_COD, B1.B1_MSBLQL, B1.B1_XMSBLQL,B1.B1_XR01,B1.B1_XDESAT FROM "+AllTrim(GetMv("STALIASIND"))+".SB1030 B1 "+CL
  cQuery += "WHERE B1.D_E_L_E_T_ = ' ' AND (

  For _nX:=1 To Len(aVetAux)
    cQuery += " (B1_COD='"+aVetAux[_nX][2]+"')
    If !_nX==Len(aVetAux)
      cQuery += " OR
    EndIf
  Next

  cQuery += ")

  cQuery := ChangeQuery(cQuery)
  DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSB1', .F., .T.)
ENDIF

WHILE TSB1->(!EOF())
  cErro1 := ""
  IF TSB1->B1_MSBLQL = "1"
    cErro1 := "Produto BLOQUEADO "
  ENDIF
    
  cErro2 := ""
  IF TSB1->B1_XMSBLQL = "1"
    cErro2 := "Produto BLOQEADO2 - B1_XMSBLQL "
  ENDIF

  cErro3 := ""
  IF TSB1->B1_XDESAT = "2"
    cErro3 := "Produto DESATIVADO"
  ENDIF

  /*******************************
  Verifica se na tabela da Distribuidora existe o produto
  Esta chamada é feita através do fonte STRESST na Static Function "STRELQUER" que sempre olha a tabela da Distribuidora.
  Tabela Guararema: "T01"
  Tabela Manaus...: "T02"
  *******************************/
  cErro4  := ""
  //// Filial Guararema
  IF SC7->C7_FORNECE = "005764"
    DA1->(DBSETORDER(1))
    IF !DA1->(DBSEEK(XFILIAL("DA1")+"T01"+TSB1->B1_COD))
      cErro4 := "Não cadastrado na Tabela T01"
    ENDIF
  //// Filial Manaus
  ELSEIF SC7->C7_FORNECE = "005866"
    DA1->(DBSETORDER(1))
    IF !DA1->(DBSEEK(XFILIAL("DA1")+"T02"+TSB1->B1_COD))
      cErro4 := "Não cadastrado na Tabela T02"
    ENDIF
  ENDIF

  cErro5 := ""
  IF TSB1->B1_XR01 = "1"  
    cErro5 := "SIM"
  ENDIF

  /*******************************
  Atualiza o vetor de retorno de Erro
  Tive que ustilizar um FOR pois o mesmo produto pode estar em mais de um item da SC7
  *******************************/
  IF !EMPTY(cErro1) .OR. !EMPTY(cErro2) .OR. !EMPTY(cErro3) .OR. !EMPTY(cErro4) .OR. !EMPTY(cErro5)
    FOR _nX := 1 TO LEN(aVetAux)
      IF ALLTRIM(aVetAux[_nX,2]) = ALLTRIM(TSB1->B1_COD)
        AADD(aVetAux1,{aVetAux[_nX,1],aVetAux[_nX,2],aVetAux[_nX,3],cErro1,cErro2,cErro3,cErro4,cErro5})
      ENDIF
    NEXT
  ENDIF
  
  TSB1->(DBSKIP())
ENDDO
TSB1->(DBCLOSEAREA())

IF LEN(aVetAux1) > 0 

  AADD(aVetErro,{SC7->C7_FORNECE,_xNumPC,aVetAux1})
  _lRet:= .F.
ENDIF

RETURN _lRet


STATIC FUNCTION MSTECK18D()
LOCAL _nX := 0
LOCAL _nY := 0
LOCAL aVetAux := {}
LOCAL cNomInd := ""
LOCAL cMailTo := GETMV("MSTECK1801",,"david.junior@steck.com.br;rafael.rivani@steck.com.br")
LOCAL cCopia  := ""
LOCAL cAssun  := "Pedidos de Compras com itens bloqueados na Indústria "
LOCAL cAnexo  := ""
LOCAL cMsg  := ""

cMsg := "<HTML> "
cMsg += "<HEAD> "
cMsg += "<TITLE> "
cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
cMsg += "</TITLE> "
cMsg += "</HEAD> "

FOR _nX := 1 TO LEN(aVetErro)

  //// Filial Guararema
  IF aVetErro[_nX,1] = "005764"
    cNomInd := "GUARAREMA"
  //// Filial Manaus
  ELSEIF aVetErro[_nX,1] = "005866"
    cNomInd := "MANAUS"
  ENDIF

  cMsg += " <br> <br>"
  cMsg += " <table width='1000' border='2'> "
  cMsg += " <tr> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedido de compra com itens bloqueados na Indústria: "+cNomInd+"</B></font></div></td> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedido de compra Número: "+aVetErro[_nX,2]+"</B></font></div></td> "
  cMsg += " </tr> "
  cMsg += " </table> "

  //// Itens do Pedido de Venda
  cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
  cMsg += "   <tr> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Item</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Código</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Descrição</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Bloqueado</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Bloqueado2</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Desativado</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Tabela de Preço</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>RR/O Indústria</font></div></td> "
  cMsg += "   </tr> "

  aVetAux := {}
  aVetAux := aVetErro[_nX,3] 
  FOR _nY := 1 TO LEN(aVetAux) 
    cMsg += "   <tr> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,1]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,2]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,3]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,4]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,5]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,6]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,7]+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aVetAux[_nY,8]+"</font></div></td> "
    cMsg += "   </tr> "
  NEXT _nY
  cMsg += " </table> "
NEXT _nX

cMsg += " <br> <br> "
cMsg += "MSTECK18.PRW"
cMsg += "</HTML> "


U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)

RETURN
