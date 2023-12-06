/* 
Ação.........: Job de reserva de pedido de venda para o novo conceito utilizado no projeto de Oferta Logística.
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 03/05/2022
Chamado......: 20220429009114 - Oferta Logística
*/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK16(aEmpFil)  

Local _cLockBy := ""
Default aEmpFil := {"", ""}

cEmpSch   := aEmpFil[1]
cFilSched := aEmpFil[2]

VarInfo("aEmpFil", aEmpFil,, .F.)

If !Empty(cEmpSch) .and. !Empty(cFilSched)
   //_cLockBy := alltrim("MSTECK16"+cEmpSch+cFilSched+GetEnvServer())
   _cLockBy := alltrim("MSTECK16_18"+cEmpSch+cFilSched+GetEnvServer())
   //_cLockBy := alltrim("MSTECK16"+cEmpSch+cFilSched)

    IF SELECT("SX2") == 0
      PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilSched
      IF !LockByName(_cLockBy ,.F.,.F.,.T.)
        CONOUT("[MSTECK16] - Rotina sendo executada por outro processo!")  
        RETURN
      ELSE
        MSTECK16A()
        UnLockByName(_cLockBy,.F.,.F.,.T.)
        RESET ENVIRONMENT
      ENDIF
    ELSE
      IF !LockByName(_cLockBy,.F.,.F.,.T.)
        MSGALERT("Rotina sendo executada por outro processo!")
        RETURN
      ELSE
        MSTECK16A()
        UnLockByName(_cLockBy,.F.,.F.,.T.)
      ENDIF
    ENDIF
Else
    CONOUT("[MSTECK16] - Empresa e filial nao informada no Schedule!")   
Endif

RETURN

User FUNCTION STECK16B(cNewEmp,cNewFil,_cProd,_cLocal)

 	RpcSetType( 3 )
	RpcSetEnv( cNewEmp,cNewFil,,,"FAT")

  // Executa a distribuição do FIFO normal
  U_STFSC10H(_cProd,0,_cLocal)

  // Novo Fura FIFO
  //U_FURAFNEW(cNewEmp,cNewFil,_cProd)

Return()

STATIC FUNCTION MSTECK16A()

LOCAL nDiaMais := SuperGetMV("MSTECK16",.F.,10)   
LOCAL _dDataDia := DATE()

Local cStmt := ""
Local cAlias000 := ""
Local _cOerFalRes := "("
Local nX := 0
Local aOpers := Separa(AllTrim(GetMv("ST_OPRESFA",,"94/74")),",") 
Local nRegs 	:= 0

For nX := 1 To Len(aOpers)
  
  _cOerFalRes += "'" + aOpers[nX] + "'"

  If !Len(aOpers)==nX
    _cOerFalRes += ","
  EndIf

Next nX

_cOerFalRes += ")"

//Distribuição de falta com saldo disponível
cAlias000 := GetNextAlias()

cStmt := " SELECT PA1_CODPRO, BF_LOCAL
cStmt += " FROM "+RetSqlName("PA1")+" PA1
cStmt += " LEFT JOIN "+RetSqlName("SD4")+" D4
cStmt += " ON PA1_FILIAL=D4_FILIAL AND PA1_DOC=D4_OP
cStmt += " INNER JOIN (
cStmt += " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL
cStmt += " FROM (
cStmt += " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, SUM(BF_QUANT) BF_QUANT, NVL(DC_QUANT,0) EMPENHO, NVL(RESPED,0) RESPED, NVL(RESOP,0) RESOP
cStmt += " FROM "+RetSqlName("SBF")+" BF
cStmt += " LEFT JOIN (
cStmt += " SELECT DC_FILIAL, DC_PRODUTO, DC_LOCAL, SUM(DC_QUANT) DC_QUANT
cStmt += " FROM "+RetSqlName("SDC")+" DC
cStmt += " WHERE DC.D_E_L_E_T_=' ' AND DC_ORIGEM='SC6' AND DC_QUANT>0
cStmt += " GROUP BY DC_FILIAL, DC_PRODUTO, DC_LOCAL
cStmt += " ) DC
cStmt += " ON DC_FILIAL=BF_FILIAL AND DC_PRODUTO=BF_PRODUTO AND DC_LOCAL=BF_LOCAL
cStmt += " LEFT JOIN (
cStmt += " SELECT PA2_FILRES, PA2_CODPRO, C6_LOCAL, SUM(PA2_QUANT) RESPED
cStmt += " FROM "+RetSqlName("PA2")+" PA2
cStmt += " LEFT JOIN "+RetSqlName("SC6")+" C6
cStmt += " ON C6_FILIAL=PA2_FILRES AND C6_NUM||C6_ITEM=PA2_DOC AND C6.D_E_L_E_T_=' ' 
cStmt += " WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='1' AND PA2_QUANT>0 
cStmt += " GROUP BY PA2_FILRES, PA2_CODPRO, C6_LOCAL
cStmt += " ) PA2PED
cStmt += " ON PA2PED.PA2_FILRES=BF_FILIAL AND PA2PED.PA2_CODPRO=BF_PRODUTO AND C6_LOCAL=BF_LOCAL
cStmt += " LEFT JOIN (
cStmt += " SELECT PA2_FILRES, PA2_CODPRO, D4_LOCAL, SUM(PA2_QUANT) RESOP
cStmt += " FROM "+RetSqlName("PA2")+" PA2
cStmt += " LEFT JOIN "+RetSqlName("SD4")+" D4
cStmt += " ON D4_FILIAL=PA2_FILRES AND D4_OP=PA2_DOC AND D4_COD=PA2_CODPRO AND D4.D_E_L_E_T_=' ' 
cStmt += " WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='2' AND PA2_QUANT>0 
cStmt += " GROUP BY PA2_FILRES, PA2_CODPRO, D4_LOCAL
cStmt += " ) PA2OP
cStmt += " ON PA2OP.PA2_FILRES=BF_FILIAL AND PA2OP.PA2_CODPRO=BF_PRODUTO AND D4_LOCAL=BF_LOCAL
cStmt += " WHERE BF.D_E_L_E_T_=' ' AND BF_QUANT>0 
cStmt += " GROUP BY BF_FILIAL, BF_PRODUTO, BF_LOCAL, NVL(DC_QUANT,0), NVL(RESPED,0), NVL(RESOP,0)
cStmt += " ) XXX
cStmt += " WHERE BF_QUANT-EMPENHO-RESPED-RESOP>0
cStmt += " ) YYY
cStmt += " ON BF_FILIAL=PA1_FILIAL AND BF_PRODUTO=PA1_CODPRO AND BF_LOCAL=D4_LOCAL
cStmt += " WHERE PA1.D_E_L_E_T_=' ' AND D4.D_E_L_E_T_=' ' AND PA1_FILIAL='"+cFilAnt+"' AND BF_LOCAL NOT IN ('90')
cStmt += " GROUP BY PA1_CODPRO, BF_LOCAL
cStmt += " UNION 
cStmt += " SELECT PA1_CODPRO, BF_LOCAL
cStmt += " FROM "+RetSqlName("PA1")+" PA1
cStmt += " LEFT JOIN "+RetSqlName("SC6")+" C6
cStmt += " ON PA1_FILIAL=C6_FILIAL AND PA1_DOC=C6_NUM||C6_ITEM
cStmt += " INNER JOIN (
cStmt += " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL
cStmt += " FROM (
cStmt += " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, SUM(BF_QUANT) BF_QUANT, NVL(DC_QUANT,0) EMPENHO, NVL(RESPED,0) RESPED, NVL(RESOP,0) RESOP
cStmt += " FROM "+RetSqlName("SBF")+" BF
cStmt += " LEFT JOIN (
cStmt += " SELECT DC_FILIAL, DC_PRODUTO, DC_LOCAL, SUM(DC_QUANT) DC_QUANT
cStmt += " FROM "+RetSqlName("SDC")+" DC
cStmt += " WHERE DC.D_E_L_E_T_=' ' AND DC_ORIGEM='SC6' AND DC_QUANT>0
cStmt += " GROUP BY DC_FILIAL, DC_PRODUTO, DC_LOCAL
cStmt += " ) DC
cStmt += " ON DC_FILIAL=BF_FILIAL AND DC_PRODUTO=BF_PRODUTO AND DC_LOCAL=BF_LOCAL
cStmt += " LEFT JOIN (
cStmt += " SELECT PA2_FILRES, PA2_CODPRO, C6_LOCAL, SUM(PA2_QUANT) RESPED
cStmt += " FROM "+RetSqlName("PA2")+" PA2
cStmt += " LEFT JOIN "+RetSqlName("SC6")+" C6
cStmt += " ON C6_FILIAL=PA2_FILRES AND C6_NUM||C6_ITEM=PA2_DOC AND C6.D_E_L_E_T_=' ' 
cStmt += " WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='1' AND PA2_QUANT>0 
cStmt += " GROUP BY PA2_FILRES, PA2_CODPRO, C6_LOCAL
cStmt += " ) PA2PED
cStmt += " ON PA2PED.PA2_FILRES=BF_FILIAL AND PA2PED.PA2_CODPRO=BF_PRODUTO AND C6_LOCAL=BF_LOCAL
cStmt += " LEFT JOIN (
cStmt += " SELECT PA2_FILRES, PA2_CODPRO, D4_LOCAL, SUM(PA2_QUANT) RESOP
cStmt += " FROM "+RetSqlName("PA2")+" PA2
cStmt += " LEFT JOIN "+RetSqlName("SD4")+" D4
cStmt += " ON D4_FILIAL=PA2_FILRES AND D4_OP=PA2_DOC AND D4_COD=PA2_CODPRO AND D4.D_E_L_E_T_=' ' 
cStmt += " WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='2' AND PA2_QUANT>0 
cStmt += " GROUP BY PA2_FILRES, PA2_CODPRO, D4_LOCAL
cStmt += " ) PA2OP
cStmt += " ON PA2OP.PA2_FILRES=BF_FILIAL AND PA2OP.PA2_CODPRO=BF_PRODUTO AND D4_LOCAL=BF_LOCAL
cStmt += " WHERE BF.D_E_L_E_T_=' ' AND BF_QUANT>0 
cStmt += " GROUP BY BF_FILIAL, BF_PRODUTO, BF_LOCAL, NVL(DC_QUANT,0), NVL(RESPED,0), NVL(RESOP,0)
cStmt += " ) XXX
cStmt += " WHERE BF_QUANT-EMPENHO-RESPED-RESOP>0
cStmt += " ) YYY
cStmt += " ON BF_FILIAL=PA1_FILIAL AND BF_PRODUTO=PA1_CODPRO AND BF_LOCAL=C6_LOCAL
cStmt += " WHERE PA1.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND PA1_FILIAL='"+cFilAnt+"' AND BF_LOCAL NOT IN ('90')
cStmt += " GROUP BY PA1_CODPRO, BF_LOCAL

If GetMv("MSTECK161",,.F.)

  Conout("MSTECK16 - Antes da distribuição de saldo")

  DbUseArea(.T.,"TOPCONN",TcGenQry(,,cStmt),cAlias000,.T.,.T.)

  While !(cAlias000)->(EOF())
    CONOUT("[MSTECK16] - INICIO - DISTRIBUICAO DE SALDO "+(cAlias000)->PA1_CODPRO) 
    StartJob("U_STECK16B",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,(cAlias000)->PA1_CODPRO,(cAlias000)->BF_LOCAL)
    CONOUT("[MSTECK16] - FIM - DISTRIBUICAO DE SALDO "+(cAlias000)->PA1_CODPRO)
    (cAlias000)->(DbSkip())
  End While

  Conout("MSTECK16 - Depois da distribuição de saldo")

  (cAlias000)->(DbCloseArea())
  FErase(cAlias000 + GetDbExtension())

EndIf
//Distribuição de Saldo

//FIM BLOCO 

DbSelectArea("SC5")
DbSelectArea("SC6")
DbSelectArea("PA1")

/*
Primeiramente irá rodar a query somente para pedidos com "DATA DE ENTREGA PROGRAMADA"
Regras para os pedidos Liberados:
C9_BLCRED = ' '	  /// LIBERADO FINANCEIRO
C5_ZBLOQ <> '1'	  /// LIBERADO COMERCIAL
C5_XTNTFOB <> '1'	/// LIBERADO PARA TRANSPORTE FOB
C5_XBLQFMI <> 'S'	/// LIBERADO FATURAMENTO MÍNIMO – NÃO CONSIDERAR NO MOMENTO
A1_XBLQFIN <> '1'	/// LIBERADO CADASTRO FINANCEIRO
(C5_CONDPAG='501' AND C5_XLIBAVI='S')	/// PAGAMENTO A VISTA E JÁ PAGOU.
C5_TIPO='N'
C6_QTDVEN-C6_QTDENT>0
C6_BLQ BRANCO
C6_OPER='01'
*/
cQuery := "SELECT C5_XPRIORI, C5.R_E_C_N_O_ AS C5REC,C6.R_E_C_N_O_ AS C6REC,NVL(C9AGRUP.QTDBLQ,0) QTDBLQ FROM "+RetSqlName("SC6")+" C6 "+CL
cQuery += "INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_XDTENPR <>  '        ' "+CL
cQuery += "AND C5.C5_NUM = C6.C6_NUM AND C5.C5_TIPO = 'N' "+CL
cQuery += "AND (C5_ZBLOQ <> '1' OR C5_XTNTFOB <> '1' OR (C5_CONDPAG ='501' AND C5_XLIBAVI='S')) "+CL
cQuery += "AND (C5_XAANO||C5_XMATE||C5_XATE<= '"+Dtos(Date())+"' OR C5_XAANO||C5_XMATE||C5_XATE=' ')"+CL
cQuery += "AND C5_XALERTF = ' ' "+CL
cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = C5.C5_CLIENTE AND A1.A1_LOJA = C5.C5_LOJACLI AND A1_XBLQFIN <> '1' "+CL
cQuery += "INNER JOIN "+RetSqlName("SC9")+" C9 ON C9.D_E_L_E_T_ = ' ' AND C9.C9_PEDIDO = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM "+CL
cQuery += "AND C9.C9_PRODUTO = C6.C6_PRODUTO AND C9.C9_NFISCAL = ' ' AND C9.C9_BLCRED = ' ' "+CL
cQuery += "LEFT JOIN ( SELECT C9_FILIAL, C9_PEDIDO, COUNT(*) QTDBLQ FROM "+RetSqlName("SC9")+" SC9110 "+CL
cQuery += "WHERE SC9110.D_E_L_E_T_=' ' AND SC9110.C9_NFISCAL = ' ' AND SC9110.C9_BLCRED IN ('01','04','05','09') "+CL
cQuery += "GROUP BY C9_FILIAL, C9_PEDIDO) C9AGRUP ON C9AGRUP.C9_FILIAL=C5.C5_FILIAL AND C9AGRUP.C9_PEDIDO=C5.C5_NUM "+CL
cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CL
cQuery += "AND C5.C5_XTRONF = ' ' " + CL
cQuery += "AND (C6_QTDVEN - C6_QTDENT) > 0 AND C6_BLQ = ' ' AND C6.C6_OPER NOT IN " + _cOerFalRes + " "+CL
cQuery += "AND C6.C6_XDTRERE = '        ' "+CL
cQuery += "AND C6.C6_ENTREG<='"+DTOS(Date())+"' "+CL
cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"+CL// LINHA ADD BRUNO FILIAL NA QUERY
cQuery += "GROUP BY C5_XPRIORI, C5.R_E_C_N_O_,C6.R_E_C_N_O_,C9AGRUP.QTDBLQ "+CL 
cQuery += "ORDER BY C5_XPRIORI, C5.R_E_C_N_O_ "+CL
CONOUT("[MSTECK16] - Inicio de processamento Entrega Programada"+DTOC(DATE())+" - "+TIME()+CL+cQuery)
cQuery := ChangeQuery(cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

Count To nRegs

_nCount := 0

TSC6->(DbGoTop())

WHILE TSC6->(!EOF())

  _nCount++

  CONOUT("[MSTECK16] - Inicio de processamento Entrega Programada "+cValToChar(_nCount)+"/"+cValToChar(nRegs))

  //// Verifica se o pedido está totalmente liberado 
  IF TSC6->QTDBLQ = 0 

    //// Posiciona na SC5 
    DBSELECTAREA("SC5") 
    SC5->(DBSETORDER(1))
    SC5->(DBGOTO(TSC6->C5REC))

    IF !dbRLock()
      CONOUT("[MSTECK16] - ERRO - Pedido está em sendo utilizado por outra rotina "+SC5->C5_NUM)
    ELSE

      //// Posiciona na SC6
      SC6->(DBSETORDER(1))
      SC6->(DBGOTO(TSC6->C6REC))

      U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
      U_STGrvFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),SC6->C6_LOCAL)
      U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
      U_STPriSC5()  // grava prioridade

      cQuery := "SELECT PA1.PA1_DOC, PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
      cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
      cQuery += " AND PA1_FILIAL = '"+xFilial("PA1")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
      cQuery := ChangeQuery(cQuery)
      DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
      IF !EMPTY(TPA1->PA1_DOC)
        RECLOCK("SC6",.F.)
        SC6->C6_XDTRERE := DATE()
        SC6->(MSUNLOCK())

        PA1->(DBSETORDER(1))
        PA1->(DBGOTO(TPA1->PA1REC))
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := PA1->PA1_QUANT
        PA1->(MSUNLOCK())
      ELSE
        cQuery := "SELECT PA2.PA2_DOC FROM "+RetSqlName("PA2")+" PA2 "+CL
        cQuery += "WHERE PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
        cQuery += " AND PA2_FILRES = '"+xFilial("SC5")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA2', .F., .T.)
        IF !EMPTY(TPA2->PA2_DOC)
          RECLOCK("SC6",.F.)
          SC6->C6_XDTRERE := DATE()
          SC6->(MSUNLOCK())
        ENDIF
        TPA2->(DBCLOSEAREA())
      ENDIF
      TPA1->(DBCLOSEAREA())
    ENDIF

    SC5->(DbCloseArea())

  ENDIF

  TSC6->(DBSKIP())
ENDDO
TSC6->(DBCLOSEAREA())
CONOUT("[MSTECK16] - FIM de processamento Entrega Programada"+DTOC(DATE())+" - "+TIME())

/*
Rodar a query somente para pedidos "NORMAIS = SEM Data de entrega programada"
Regras para os pedidos Liberados:
C9_BLCRED = ' '	  /// LIBERADO FINANCEIRO
C5_ZBLOQ <> '1'	  /// LIBERADO COMERCIAL
C5_XTNTFOB <> '1'	/// LIBERADO PARA TRANSPORTE FOB
C5_XBLQFMI <> 'S'	/// LIBERADO FATURAMENTO MÍNIMO – NÃO CONSIDERAR NO MOMENTO
A1_XBLQFIN <> '1'	/// LIBERADO CADASTRO FINANCEIRO
(C5_CONDPAG='501' AND C5_XLIBAVI='S')	/// PAGAMENTO A VISTA E JÁ PAGOU.
C5_TIPO='N'
C6_QTDVEN-C6_QTDENT>0
C6_BLQ BRANCO
C6_OPER='01'
*/
cQuery := "SELECT C5_XPRIORI, C5.R_E_C_N_O_ AS C5REC,C6.R_E_C_N_O_ AS C6REC,NVL(C9AGRUP.QTDBLQ,0) QTDBLQ FROM "+RetSqlName("SC6")+" C6 "+CL
cQuery += "INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_XDTENPR =  '        ' "+CL
cQuery += "AND C5.C5_NUM = C6.C6_NUM AND C5.C5_TIPO = 'N' "+CL
cQuery += "AND (C5_ZBLOQ <> '1' OR C5_XTNTFOB <> '1' OR (C5_CONDPAG ='501' AND C5_XLIBAVI='S')) "+CL
cQuery += "AND (C5_XAANO||C5_XMATE||C5_XATE<= '"+Dtos(Date())+"' OR C5_XAANO||C5_XMATE||C5_XATE=' ')"+CL
cQuery += "AND C5_XALERTF=' '"+CL
cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = C5.C5_CLIENTE AND A1.A1_LOJA = C5.C5_LOJACLI AND A1_XBLQFIN <> '1' "+CL
cQuery += "INNER JOIN "+RetSqlName("SC9")+" C9 ON C9.D_E_L_E_T_ = ' ' AND C9.C9_PEDIDO = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM "+CL
cQuery += "AND C9.C9_PRODUTO = C6.C6_PRODUTO AND C9.C9_NFISCAL = ' ' AND C9.C9_BLCRED = ' ' "+CL
cQuery += "LEFT JOIN ( SELECT C9_FILIAL, C9_PEDIDO, COUNT(*) QTDBLQ FROM "+RetSqlName("SC9")+" SC9110 "+CL
cQuery += "WHERE SC9110.D_E_L_E_T_=' ' AND SC9110.C9_NFISCAL = ' ' AND SC9110.C9_BLCRED IN ('01','04','05','09') "+CL
cQuery += "GROUP BY C9_FILIAL, C9_PEDIDO) C9AGRUP ON C9AGRUP.C9_FILIAL=C5.C5_FILIAL AND C9AGRUP.C9_PEDIDO=C5.C5_NUM "+CL
cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "+CL
cQuery += "AND C5.C5_XTRONF = ' ' " + CL
cQuery += "AND (C6_QTDVEN - C6_QTDENT) > 0 AND C6_BLQ = ' ' 
cQuery += " AND C6.C6_OPER NOT IN " + _cOerFalRes + " "+CL
cQuery += "AND C6.C6_XDTRERE = '        ' "+CL
cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"+CL// LINHA ADD BRUNO FILIAL NA QUERY
cQuery += "GROUP BY C5_XPRIORI, C5.R_E_C_N_O_,C6.R_E_C_N_O_,C9AGRUP.QTDBLQ "+CL
cQuery += "ORDER BY C5_XPRIORI, C5.R_E_C_N_O_"+CL
CONOUT("[MSTECK16] - Inicio de processamento Pedidos Normais"+DTOC(DATE())+" - "+TIME()+CL+cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

Count To nRegs

_nCount := 0

TSC6->(DbGoTop())

WHILE TSC6->(!EOF())

  _nCount++

  CONOUT("[MSTECK16] - Inicio de processamento Pedidos Normais "+cValToChar(_nCount)+"/"+cValToChar(nRegs))

  //// Verifica se o pedido está totalmente liberado 
  IF TSC6->QTDBLQ = 0 

    //// Posiciona na SC5
    DBSELECTAREA("SC5") 
    SC5->(DBSETORDER(1))
    SC5->(DBGOTO(TSC6->C5REC))
    
    /*
    Verifica se o registro está sendo requsitado por alguma rotina.
    Se estiver sendo utilizado não faz a reserva pois pode estar sendo alterado.
    */
    If !dbRLock()
      CONOUT("[MSTECK16] - ERRO - Pedido está em sendo utilizado por outra rotina "+SC5->C5_NUM)
    ELSE

      //// Posiciona na SC6
      SC6->(DBSETORDER(1))
      SC6->(DBGOTO(TSC6->C6REC))

      U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
      U_STGrvFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),SC6->C6_LOCAL)
      U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
      U_STPriSC5()  // grava prioridade

      /*
      Verifica se gravou na PA1 ou PA2 as informações
      */
      cQuery := "SELECT PA1.PA1_DOC, PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
      cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
       cQuery += " AND PA1_FILIAL = '"+xFilial("PA1")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
      cQuery := ChangeQuery(cQuery)
      DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
      IF !EMPTY(TPA1->PA1_DOC)
        RECLOCK("SC6",.F.)
        SC6->C6_XDTRERE := DATE()
        SC6->(MSUNLOCK())

        /*
        Atualiza o Saldo da PA1 igualando a quantidade
        */
        PA1->(DBSETORDER(1))
        PA1->(DBGOTO(TPA1->PA1REC))
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := PA1->PA1_QUANT
        PA1->(MSUNLOCK())

      ELSE
        cQuery := "SELECT PA2.PA2_DOC FROM "+RetSqlName("PA2")+" PA2 "+CL
        cQuery += "WHERE PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
        cQuery += " AND PA2_FILRES = '"+xFilial("SC5")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA2', .F., .T.)
        IF !EMPTY(TPA2->PA2_DOC)
          RECLOCK("SC6",.F.)
          SC6->C6_XDTRERE := DATE()
          SC6->(MSUNLOCK())
        ENDIF
        TPA2->(DBCLOSEAREA())
      ENDIF
      TPA1->(DBCLOSEAREA())
    ENDIF

    SC5->(DbCloseArea())

  ENDIF
  TSC6->(DBSKIP())
  
ENDDO
TSC6->(DBCLOSEAREA())
CONOUT("[MSTECK16] - Fim de processamento Pedidos Normais."+DTOC(DATE())+" - "+TIME())

	If cEmpAnt=="11" //Rodar somente para distribuidora esse bloco

		//Data 1 em atraso sem data 2 preenchida

cQuery := " SELECT C6.R_E_C_N_O_ RECSC6
cQuery += " FROM "+RetSqlName("SC6")+" C6
cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5
cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM 
cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"+CL// LINHA ADD BRUNO FILIAL NA QUERY 
cQuery += " AND C6_ENTREG < '"+DTOS(Date())+"'
cQuery += " AND C6_BLQ=' ' 
cQuery += " AND C6_ZENTRE2 = ' '
cQuery += " AND C6_QTDVEN > C6_QTDENT
cQuery += " AND C5_XDTENPR=' ' 
cQuery += " AND C6_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
cQuery += " AND C5_TIPO='N'
cQuery += " AND C5_TIPOCLI<>'X'

CONOUT("[MSTECK16] - Inicio de processamento de data 1 em atraso"+DTOC(DATE())+" - "+TIME()+CL+cQuery)

cQuery := ChangeQuery(cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

Count To nRegs

_nCount := 0

TSC6->(DbGoTop())

WHILE TSC6->(!EOF())

  _nCount++

  CONOUT("[MSTECK16] - Inicio de processamento de data 1 em atraso "+cValToChar(_nCount)+"/"+cValToChar(nRegs))

  SC6->(DBGOTO(TSC6->RECSC6))
  If SC6->(!Eof())
    _nSldDisp   :=  u_versaldo(SC6->C6_PRODUTO)
		_dNewData   :=  u_atudtentre(_nSldDisp,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT))
    SC6->(RecLock("SC6",.F.))
    SC6->C6_ZENTRE2 := _dNewData
    SC6->C6_XALTDT  := "S"
    SC6->(MsUnLock())
  EndIf

  TSC6->(DBSKIP())
  
ENDDO
TSC6->(DBCLOSEAREA())

CONOUT("[MSTECK16] - Fim de processamento de data 1 em atraso"+DTOC(DATE())+" - "+TIME()+CL+cQuery)

    //Data 1 e data 2 em atraso sem z96 vinculada (pedidos bloqueados e etc.)

		cQuery := " SELECT DISTINCT C6.R_E_C_N_O_ RECSC6
		cQuery += " FROM "+RetSqlName("SC6")+" C6
		cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5
		cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
		cQuery += " LEFT JOIN "+RetSqlName("Z96")+" Z96
		cQuery += " ON Z96_FILIAL=C6_FILIAL AND Z96_PA1DOC=C6_NUM||C6_ITEM AND Z96.D_E_L_E_T_=' '
		cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
		cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"+CL// LINHA ADD BRUNO FILIAL NA QUERY
		cQuery += " AND C6_ENTREG < '"+DTOS(Date())+"'
		cQuery += " AND C6_ZENTRE2 < '"+DTOS(Date())+"'
		cQuery += " AND C6_BLQ=' '
		cQuery += " AND C6_QTDVEN > C6_QTDENT
		cQuery += " AND C5_XDTENPR=' '
		cQuery += " AND C6_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
		cQuery += " AND C5_TIPO='N'
		cQuery += " AND C5_TIPOCLI<>'X'
		cQuery += " AND Z96_PA1DOC IS NULL

		CONOUT("[MSTECK16] - Inicio de processamento de data 2 em atraso sem z96 "+DTOC(DATE())+" - "+TIME()+CL+cQuery)

		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

		Count To nRegs

		_nCount := 0

		TSC6->(DbGoTop())

		WHILE TSC6->(!EOF())

			_nCount++

			CONOUT("[MSTECK16] - Inicio de processamento de data 2 em atraso sem z96 "+cValToChar(_nCount)+"/"+cValToChar(nRegs))

			SC6->(DBGOTO(TSC6->RECSC6))
			If SC6->(!Eof())
				_nSldDisp   :=  u_versaldo(SC6->C6_PRODUTO)
				_dNewData   :=  u_atudtentre(_nSldDisp,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT))
				SC6->(RecLock("SC6",.F.))
				SC6->C6_ZENTRE2 := _dNewData
				SC6->C6_XALTDT  := "S"
				SC6->(MsUnLock())
			EndIf

			TSC6->(DBSKIP())

		ENDDO
		TSC6->(DBCLOSEAREA())

		CONOUT("[MSTECK16] - Fim de processamento de data 2 em atraso sem z96 "+DTOC(DATE())+" - "+TIME()+CL+cQuery)

	EndIf

/*
Pedidos com c6_xdtrere diferente de branco e sem reserva/falta
*/
cQuery := " SELECT C6_NUM, C6_ITEM, C6.R_E_C_N_O_ RECSC6
cQuery += " FROM "+RetSqlName("SC6")+" C6
cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5
cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
cQuery += " LEFT JOIN "+RetSqlName("PA1")+" PA1
cQuery += " ON PA1_FILIAL=C6_FILIAL AND PA1_DOC=C6_NUM||C6_ITEM AND PA1.D_E_L_E_T_=' ' 
cQuery += " LEFT JOIN "+RetSqlName("PA2")+" PA2
cQuery += " ON PA2_FILRES=C6_FILIAL AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' ' 
cQuery += " LEFT JOIN "+RetSqlName("SDC")+" DC
cQuery += " ON DC_FILIAL=C6_FILIAL AND DC_ITEM=C6_ITEM AND DC_PEDIDO=C6_NUM AND DC.D_E_L_E_T_=' ' 
cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_BLQ=' ' AND C6_QTDVEN-C6_QTDENT>0 AND C6_XDTRERE<>' ' 
cQuery += " AND C6_OPER NOT IN " + _cOerFalRes 
cQuery += " AND C5.C5_XTRONF = ' ' 
cQuery += " AND (PA1_DOC IS NULL AND PA2_DOC IS NULL AND DC_PEDIDO IS NULL)

CONOUT("[MSTECK16] - Inicio de processamento pedidos sem reserva/falta"+DTOC(DATE())+" - "+TIME()+CL+cQuery) 

cQuery := ChangeQuery(cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

Count To nRegs

_nCount := 0

TSC6->(DbGoTop())

WHILE TSC6->(!EOF())

  _nCount++

  CONOUT("[MSTECK16] - Inicio de processamento pedidos sem reserva/falta "+cValToChar(_nCount)+"/"+cValToChar(nRegs))

  SC6->(DBGOTO(TSC6->RECSC6))
  If SC6->(!Eof())

      U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
      U_STGrvFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),SC6->C6_LOCAL)
      U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
      U_STPriSC5()  // grava prioridade

      /*
      Verifica se gravou na PA1 ou PA2 as informações
      */
      cQuery := "SELECT PA1.PA1_DOC, PA1.R_E_C_N_O_ AS PA1REC FROM "+RetSqlName("PA1")+" PA1 "+CL
      cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
      cQuery += " AND PA1_FILIAL = '"+xFilial("PA1")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
      cQuery := ChangeQuery(cQuery)
      DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.)
      IF !EMPTY(TPA1->PA1_DOC)
        RECLOCK("SC6",.F.)
        SC6->C6_XDTRERE := DATE()
        SC6->(MSUNLOCK())

        /*
        Atualiza o Saldo da PA1 igualando a quantidade
        */
        PA1->(DBSETORDER(1))
        PA1->(DBGOTO(TPA1->PA1REC))
        RECLOCK("PA1",.F.)
        PA1->PA1_SALDO := PA1->PA1_QUANT
        PA1->(MSUNLOCK())

      ELSE
        cQuery := "SELECT PA2.PA2_DOC FROM "+RetSqlName("PA2")+" PA2 "+CL
        cQuery += "WHERE PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
        cQuery += " AND PA2_FILRES = '"+xFilial("SC5")+"'"+CL //LINHA ADD BRUNO FILIAL NA QUERY
        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA2', .F., .T.)
        IF !EMPTY(TPA2->PA2_DOC)
          RECLOCK("SC6",.F.)
          SC6->C6_XDTRERE := DATE()
          SC6->(MSUNLOCK())
        ENDIF
        TPA2->(DBCLOSEAREA())
      ENDIF
      TPA1->(DBCLOSEAREA())

  EndIf

  TSC6->(DBSKIP())
  
ENDDO
TSC6->(DBCLOSEAREA())


***************************************/
cQuery := " SELECT C6_PRODUTO
cQuery += " FROM "+RetSqlName("SC6")+" C6
cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5
cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_BLQ=' ' AND C6_QTDVEN-C6_QTDENT>0
cQuery += " AND C6_OPER NOT IN " + _cOerFalRes 
//cQuery += " AND C6_PRODUTO = 'S3509D'"
cQuery += " AND C5.C5_XTRONF = ' ' 
cQuery += " AND C5_XPRIOR2 = 'S' "

CONOUT("[MSTECK16] - Inicio de processamento pedidos fura fifo"+DTOC(DATE())+" - "+TIME()+CL+cQuery) 

cQuery := ChangeQuery(cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'FIFO', .F., .T.)

Count To nRegs

_nCount := 0

FIFO->(DbGoTop())

WHILE FIFO->(!EOF())
  
    U_FURAFNEW(SM0->M0_CODIGO,SM0->M0_CODFIL, FIFO->C6_PRODUTO )

    FIFO->( dbskip() )
ENDDO
FIFO->(DBCLOSEAREA())

CONOUT("[MSTECK16] - Fim de processamento pedidos sem reserva/falta"+DTOC(DATE())+" - "+TIME()+CL+cQuery)

RETURN

User Function STREFOP()

  Local _cQuery1 := ""
  Local _cAlias1 := ""

  PREPARE ENVIRONMENT EMPRESA '01' FILIAL '05'

  _cAlias1 := GetNextAlias()

  _cQuery1 := " SELECT DISTINCT D4_OP, C2.R_E_C_N_O_ RECSC2
  _cQuery1 += " FROM "+RetSqlName("SC2")+" C2
  _cQuery1 += " LEFT JOIN "+RetSqlName("SD4")+" D4
  _cQuery1 += " ON D4_FILIAL=C2_FILIAL AND D4_OP=C2_NUM||C2_ITEM||C2_SEQUEN
  _cQuery1 += " WHERE C2.D_E_L_E_T_=' ' AND D4.D_E_L_E_T_=' ' 
  _cQuery1 += " AND C2_QUANT-C2_QUJE>0 AND C2_FILIAL='"+cFilAnt+"' 
  _cQuery1 += " AND D4_LOCAL<>'90' 
  //_cQuery1 += " AND D4_OP='UNLAIJ01001'

  If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

  DbSelectArea("SC2")

	While (_cAlias1)->(!Eof())

    SC2->(DbGoTo((_cAlias1)->RECSC2))
    If SC2->(!Eof())
      U_STFSC10D()
    EndIf

    (_cAlias1)->(DbSkip())
  EndDo

Return()

/*/{Protheus.doc} FURAFNEW
NOva função de fura fifo, chamado 20230525006537
@type function
@version 12.1.33  
@author Tiago Castilho
@since 01/08/2023
@param cNewEmp, character, Empresa para iniciar o ambiente
@param cNewFil, character, Filial para iniciar o ambiente
@param _cProd, variant, Produto que está sendo distribuido
/*/
User Function FURAFNEW(cNewEmp,cNewFil,cProdFifo)

  Local aArea      := {}
  Local cPrioriza  := GetNextAlias()
  Local cNaoPriori := GetNextAlias()
  Local cPriorExp  := GetNextAlias()
  Local cNaoPriExp := GetNextAlias()
  Local cSldExp    := GetNextAlias()
  Local nSaldoB2   := 0

	//RpcSetType( 3 )
	//RpcSetEnv( cNewEmp,cNewFil,,,"FAT")

  aArea := {GetArea()}
  AADD(aArea,PA1->(GetArea()))
  AADD(aArea,PA2->(GetArea()))  
  AADD(aArea,SC5->(GetArea()))

  SB1->(DbSetOrder(1))
  SB1->(DbSeek(xFilial("SB1")+cProdFifo))

  SB2->(DbSetOrder(1))
  if SB2->(DbSeek( xFilial("SB2") + cProdFifo + SB1->B1_LOCPAD )) 
    nSaldoB2    := SB2->B2_QATU

    BeginSql Alias cSldExp	
      SELECT 
        PA2.PA2_FILRES, PA2.PA2_CODPRO, PA2.PA2_QUANT, PA2.PA2_DOC
      FROM   
        %table:PA2% PA2

      INNER JOIN 
          %table:SC5% SC5 ON 
          (SC5.C5_FILIAL = %xFilial:SC5%
          AND Substring(PA2.PA2_DOC,1,6) = SC5.C5_NUM
          AND SC5.%notDel% 
          )

      WHERE  
            PA2.PA2_FILIAL = %xFilial:PA2%
        AND PA2.PA2_CODPRO = %Exp:cProdFifo%
        AND SC5.C5_TIPOCLI =  'X'
        AND PA2.%notDel% 
    EndSql

    (cSldExp)->(DbGoTop())
    while (cSldExp)->(!eof())
        nSaldoB2 := nSaldoB2 - (cSldExp)->PA2_QUANT
        (cSldExp)->(DbSkip())
    enddo
    (cSldExp)->(DbCloseArea())

  endif
  // Fura FIFO pedidos nacionais
  BeginSql Alias cPrioriza		

    SELECT 
      PA1.PA1_FILIAL, PA1.PA1_CODPRO, PA1.PA1_QUANT, PA1.PA1_DOC, SC5.C5_NUM, SC5.C5_XTIPF
    FROM   
      %table:PA1% PA1
      INNER JOIN 
        %table:SC5% SC5 ON (
          SC5.C5_FILIAL = %xFilial:SC5%
          AND Substring(PA1.PA1_DOC,1,6) = SC5.C5_NUM
          AND SC5.%notDel%)
    WHERE  
      PA1.PA1_FILIAL  = %xFilial:PA1%
      AND SC5.C5_TIPOCLI <> 'X'
      AND SC5.C5_XPRIOR2 = 'S'
      AND PA1.PA1_CODPRO = %exp:cProdFifo%
      //AND PA1.PA1_CODPRO = %Exp:_cProd%
      AND PA1.%notDel% 
	EndSql 

  (cPrioriza)->(DbGoTop())
  if (cPrioriza)->(!Eof())
    Do While (cPrioriza)->(!Eof())

      BeginSql Alias cNaoPriori	
        SELECT 
          PA2.PA2_FILRES, PA2.PA2_CODPRO, PA2.PA2_QUANT, PA2.PA2_DOC, SC5.C5_NUM, SC5.C5_XTIPF
        FROM   
          %table:PA2% PA2

        INNER JOIN 
            %table:SC5% SC5 ON 
            (SC5.C5_FILIAL = %xFilial:SC5%
            AND Substring(PA2.PA2_DOC,1,6) = SC5.C5_NUM
            AND SC5.%notDel% 
            )

        WHERE  
              PA2.PA2_FILIAL = %xFilial:PA2%
          AND PA2.PA2_CODPRO = %Exp:(cPrioriza)->PA1_CODPRO%
          AND SC5.C5_TIPOCLI <> 'X'
          AND SC5.C5_XPRIOR2 <> 'S'
          AND PA2.%notDel% 
      EndSql
      
      If (cNaoPriori)->(!Eof())

        Do While (cNaoPriori)->(!Eof())
          // Tira reserva de produto não priorizado
          U_STRESERVA((cNaoPriori)->PA2_DOC, (cNaoPriori)->PA2_CODPRO, (cNaoPriori)->PA2_QUANT, '-', (cNaoPriori)->PA2_FILRES) // Retira PA2
          U_STFALTA((cNaoPriori)->PA2_DOC  , (cNaoPriori)->PA2_CODPRO, (cNaoPriori)->PA2_QUANT, '+') // Inclui PA1
          U_STGrvSt((cNaoPriori)->C5_NUM, (cNaoPriori)->C5_XTIPF=="2")
          (cNaoPriori)->(DbSkip())
        Enddo

        if nSaldoB2 >= (cPrioriza)->PA1_QUANT
          // Inclui reserva de produto priorizado
          U_STFALTA((cPrioriza)->PA1_DOC  , (cPrioriza)->PA1_CODPRO, (cPrioriza)->PA1_QUANT, '-') // Retira PA1
          U_STRESERVA((cPrioriza)->PA1_DOC, (cPrioriza)->PA1_CODPRO, (cPrioriza)->PA1_QUANT , '+', (cPrioriza)->PA1_FILIAL) // Inclui PA2
          U_STGrvSt((cPrioriza)->C5_NUM, (cPrioriza)->C5_XTIPF=="2")
        else
          // Inclui reserva de produto priorizado
          U_STFALTA((cPrioriza)->PA1_DOC  , (cPrioriza)->PA1_CODPRO, nSaldoB2, '-') // Retira PA1
          U_STRESERVA((cPrioriza)->PA1_DOC, (cPrioriza)->PA1_CODPRO, nSaldoB2 , '+', (cPrioriza)->PA1_FILIAL) // Inclui PA2
          U_STGrvSt((cPrioriza)->C5_NUM, (cPrioriza)->C5_XTIPF=="2")
        endif

        nSaldoB2 := nSaldoB2 - (cPrioriza)->PA1_QUANT
      Endif
      (cNaoPriori)->(dbclosearea())
      (cPrioriza)->(DbSkip())
    EndDo
  else
    BeginSql Alias cNaoPriori	
      SELECT 
        PA2.PA2_FILRES, PA2.PA2_CODPRO, PA2.PA2_QUANT, PA2.PA2_DOC
      FROM   
        %table:PA2% PA2

      INNER JOIN 
          %table:SC5% SC5 ON 
          (SC5.C5_FILIAL = %xFilial:SC5%
          AND Substring(PA2.PA2_DOC,1,6) = SC5.C5_NUM
          AND SC5.%notDel% 
          )

      WHERE  
            PA2.PA2_FILIAL = %xFilial:PA2%
        AND PA2.PA2_CODPRO = %Exp:cProdFifo%
        AND SC5.C5_TIPOCLI <> 'X'
        AND SC5.C5_XPRIOR2 <> 'S'
        AND PA2.%notDel% 
    EndSql

    If (cNaoPriori)->(!Eof())
      while (cNaoPriori)->(!Eof())
        nSaldoB2 := nSaldoB2 - (cNaoPriori)->PA2_QUANT
        (cNaoPriori)->(dbskip())
      enddo
    endif
    (cNaoPriori)->(dbclosearea())
  endif

  cPrioriza   := " "
  cNaoPriori  := " "
  cChavePrio  := " "
  cChaveNaoP  := " "

  // Fura FIFO pedidos exportação
  BeginSql Alias cPriorExp		
    SELECT 
      PA1.PA1_FILIAL, PA1.PA1_CODPRO, PA1.PA1_QUANT, PA1.PA1_DOC, SC5.C5_NUM, SC5.C5_XTIPF
    FROM   
      %table:PA1% PA1

    INNER JOIN 
        %table:SC5% SC5 ON (
          SC5.C5_FILIAL = %xFilial:SC5%
          AND Substring(PA1.PA1_DOC,1,6) = SC5.C5_NUM
          AND SC5.%notDel%)

    WHERE  
          PA1.PA1_FILIAL = %xFilial:PA1%
      AND SC5.C5_TIPOCLI = 'X'
      AND SC5.C5_XPRIOR2 = 'S'
      AND PA1.PA1_CODPRO = %exp:cProdFifo%
      //AND PA1.PA1_CODPRO = 'N4247'
      //AND PA1.PA1_CODPRO = %Exp:_cProd%
      AND PA1.%notDel% 
	EndSql

  (cPriorExp)->(DbGoTop())
  Do While (cPriorExp)->(!Eof())

    BeginSql Alias cNaoPriExp	
      SELECT 
        PA2.PA2_FILRES, PA2.PA2_CODPRO, PA2.PA2_QUANT, PA2.PA2_DOC, SC5.C5_NUM, SC5.C5_XTIPF
      FROM   
        %table:PA2% PA2

      INNER JOIN 
          %table:SC5% SC5 ON 
          (SC5.C5_FILIAL = %xFilial:SC5%
          AND Substring(PA2.PA2_DOC,1,6) = SC5.C5_NUM
          AND SC5.%notDel% 
          )

      WHERE  
            PA2.PA2_FILIAL = %xFilial:PA2%
        AND PA2.PA2_CODPRO = %Exp:(cPriorExp)->PA1_CODPRO%
        AND SC5.C5_TIPOCLI =  'X'
        AND SC5.C5_XPRIOR2 <> 'S'
        AND PA2.%notDel% 
    EndSql
    
    (cNaoPriExp)->(DbGoTop())
    if (cNaoPriExp)->(!Eof())
        Do While (cNaoPriExp)->(!Eof())
          // Tira reserva de produto não priorizado
          U_STRESERVA((cNaoPriExp)->PA2_DOC, (cNaoPriExp)->PA2_CODPRO, (cNaoPriExp)->PA2_QUANT, '-', (cNaoPriExp)->PA2_FILRES) // Retira PA2
          U_STFALTA((cNaoPriExp)->PA2_DOC  , (cNaoPriExp)->PA2_CODPRO, (cNaoPriExp)->PA2_QUANT, '+') // Inclui PA1
          U_STGrvSt((cNaoPriExp)->C5_NUM, (cNaoPriExp)->C5_XTIPF=="2")
          (cNaoPriExp)->(DbSkip())
        Enddo

        // Inclui reserva de produto priorizado
        if nSaldoB2 >= (cPriorExp)->PA1_QUANT
          U_STFALTA((cPriorExp)->PA1_DOC  , (cPriorExp)->PA1_CODPRO, (cPriorExp)->PA1_QUANT, '-') // Retira PA1
          U_STRESERVA((cPriorExp)->PA1_DOC, (cPriorExp)->PA1_CODPRO, (cPriorExp)->PA1_QUANT, '+', (cPriorExp)->PA1_FILIAL) // INclui PA2
          U_STGrvSt((cPriorExp)->C5_NUM, (cPriorExp)->C5_XTIPF=="2")
        elseIF nSaldoB2 > 0
          U_STFALTA((cPriorExp)->PA1_DOC  , (cPriorExp)->PA1_CODPRO, nSaldoB2, '-') // Retira PA1
          U_STRESERVA((cPriorExp)->PA1_DOC, (cPriorExp)->PA1_CODPRO, nSaldoB2, '+', (cPriorExp)->PA1_FILIAL) // INclui PA2
          U_STGrvSt((cPriorExp)->C5_NUM, (cPriorExp)->C5_XTIPF=="2")
        endif

        nSaldoB2 := nSaldoB2 - (cPriorExp)->PA1_QUANT

    endif
    (cNaoPriExp)->(dbclosearea())
    (cPriorExp)->(DbSkip())
  EndDo

  If Select(cNaoPriori) > 0 
    (cNaoPriori)->(DbCloseArea())
  Endif

  If Select(cPriorExp) > 0 
    (cPriorExp)->(DbCloseArea())
  Endif

  If Select(cNaoPriori) > 0 
    (cNaoPriori)->(DbCloseArea())
  Endif

   If Select(cPrioriza) > 0 
    (cPrioriza)->(DbCloseArea())
  Endif 

  AEval(aArea, {|aArea| RestArea(aArea)})
	FwFreeArray(aArea)

Return()
