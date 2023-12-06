#Include "Colors.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "TOTVS.CH"
#DEFINE CL CHR(13)+CHR(10)
//#INCLUDE "STR.CH"


/*====================================================================================\
|Programa  | STPREVATU           | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição | Email de previsao de chegada de produtos                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPREVATU                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado 006719 - Adicionei o e-mail da Maria do Carmo na altura da linha 700         |
\====================================================================================*/

*-------------------------------*
User Function STPREVATU(_cVar)  //u_STPREVATU('m')
	*-------------------------------*
	Default _cVar := 'A'

	If _cVar = 'A'
		PREVDEL()//DELETO OS COMPROMISSOS CANCELADOS
	EndIf
	
	//PREVDISTRI()//DISTRIBUO OS COMPROMISSO NO SC6
	Processa({|| PREVDISTRI( ) },"Aguarde")
	//U_STZZJMAIL()
	//Processa({|| U_STZZJMAIL( ) },"Aguarde enviando e-Mail")
	
Return()



/*====================================================================================\
|Programa  | STPREVJOB           | Autor | GIOVANI.ZAGO          | Data | 15/07/2015  |
|=====================================================================================|
|Descrição | JOB COMPROMISSO						                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPREVJOB                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*--------------------------*
User Function STPREVJOB()
	*------------------------ -*
	Local _cLockBy		:= ""
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	//MsgAlert("Rotina desativada")
	Return
	 
	_cLockBy		:= "STPREVJOB"
	
	If !LockByName(_cLockBy,.F.,.F.,.T.)
		Return()
	EndIf


	U_STC6PA1PA2()
	//U_STC5PRO()

	PREVDISTRI('1' )
	U_STMAILTES('richely.lima@steck.com.br ; paulo.filho@steck.com.br ', '', 'Fim de Processamento Compromisso: '+dToc(date())+' - '+ time(), ' ',{})
	//U_STZZJMAIL('1')
	 UnLockByName(_cLockBy,.F.,.F.,.T.)
	
Return()
/*====================================================================================\
|Programa  | PREVDEL             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição |  DELETA COMPROMISSO NA SC6                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | PREVDEL                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function PREVDEL()
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cAliasLif  := 'PREVDEL'
	Local cQuery     := ' '
	
	cQuery := " SELECT "
	cQuery += ' SC6.R_E_C_N_O_   "REC"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("ZZJ")+" )ZZJ "
	cQuery += " ON ZZJ.ZZJ_NUM = SC6.C6_XPREV
	cQuery += " AND ZZJ.ZZJ_CANCEL <> ' '
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL   = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_XPREV <> ' ' 
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND SC6.C6_BLQ <> 'R'
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			dbSelectArea('SC6')
			SC6->(DbGoTo((cAliasLif)->REC))
			If SC6->(RECNO()) = (cAliasLif)->REC
				SC6->(RecLock('SC6',.F.))
				SC6->C6_XPREV  := ' '
				SC6->C6_XQTPRV := 0
				SC6->(MsUnlock())
				SC6->(DbCommit())
			EndIf
			(cAliasLif)->(dbSkip())
		End
				
	EndIf
	
Return()



/*====================================================================================\
|Programa  | PREVDISTRI          | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição |  GRAVA COMPROMISSO NA SC6                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | PREVDISTRI                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function PREVDISTRI()
	*---------------------------*
	Local _aArea	  := GetArea()
	Local cAliasLif   := 'PREVDISTRI'
	Local cQuery      := ' '
	Local _nQtdDisp   := 0
	Local _cProdx     := ' '
	Local cQry 		  := ' '
	LOCAL nRet := 0
	Private cAliasSc6 := 'C6PREVDISTRI'
	 
	cQry := "UPDATE "+RetSqlName("SC5")+" SC5 SET C5_XDTEN = ( "+CL
	cQry += "																										SELECT MAX(C6_ENTRE1)  FROM "+RetSqlName("SC6")+" SC6  "+CL
	cQry += "																										WHERE SC6.D_E_L_E_T_ = ' '  AND SC6.C6_NUM = C5_NUM AND SC6.C6_FILIAL = C5_FILIAL ) "+CL
	cQry += "WHERE D_E_L_E_T_ = ' ' "+CL
	cQry += "AND C5_XDTEN = ' ' AND C5_FILIAL = '"+XFILIAL("SC5")+"' AND C5_EMISSAO > '20210308' "+CL
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := "  UPDATE "+RetSqlName("PA2")+" SET PA2_FILIAL = 'WQ' WHERE R_E_C_N_O_ IN(SELECT PA2.R_E_C_N_O_ FROM "+RetSqlName("PA2")+" PA2 INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+")SC6  ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = PA2_FILRES AND C6_NUM||C6_ITEM = PA2_DOC AND (C6_QTDVEN = C6_QTDENT OR C6_BLQ = 'R') WHERE PA2.D_E_L_E_T_ = ' ' ) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := "  UPDATE "+RetSqlName("PA1")+" SET PA1_FILIAL = 'WQ' WHERE R_E_C_N_O_ IN( SELECT PA1.R_E_C_N_O_ FROM "+RetSqlName("PA1")+" PA1 INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+")SC6 ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = PA1_FILIAL AND C6_NUM||C6_ITEM = PA1_DOC AND (C6_QTDVEN = C6_QTDENT OR C6_BLQ = 'R') WHERE PA1.D_E_L_E_T_ = ' ' ) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	//limpa a reserva onde o item foi eliminado
	cQry := " UPDATE "+RetSqlName("PA2")+" SET PA2_FILIAL = 'WQ' WHERE R_E_C_N_O_ IN( SELECT PA2.R_E_C_N_O_  FROM "+RetSqlName("PA2")+" PA2 WHERE PA2.D_E_L_E_T_ = ' ' AND PA2_FILRES='"+XFILIAL("PA2")+"' AND PA2_TIPO='1' AND NOT EXISTS ( SELECT * FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = PA2_FILRES AND C6_NUM||C6_ITEM = PA2_DOC)) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	//limpa a falta onde o item foi eliminado
	cQry := " UPDATE "+RetSqlName("PA1")+" SET PA1_FILIAL = 'WQ' WHERE R_E_C_N_O_ IN( SELECT PA1.R_E_C_N_O_ FROM "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL ='"+XFILIAL("PA1")+"'  AND NOT EXISTS ( SELECT * FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_ = ' '  AND C6_FILIAL = PA1_FILIAL AND C6_NUM||C6_ITEM = PA1_DOC)) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	
	dbselectarea("PA2")
	dbsetorder(1)
	If dbseek('WQ')
		
		do while .not. eof() .and. PA2->PA2_FILIAL == 'WQ'
			
			Reclock("PA2",.F.)
			PA2->PA2_OBS:='JOB LIMPEZA - '+ TIME()+' - '+DTOC(DATE())
			DbDelete()
			Msunlock()
			
			dbskip()
			
		enddo
		
	EndIf
	
	dbselectarea("PA1")
	dbsetorder(1)
	If dbseek('WQ')
		
		do while .not. eof() .and. PA1->PA1_FILIAL == 'WQ'
			
			Reclock("PA1",.F.)
			PA1->PA1_OBS:='JOB LIMPEZA - '+ TIME()+ ' - ' + DTOC(DATE())
			DbDelete()
			Msunlock()
			
			dbskip()
			
		enddo
		
	EndIf
	
	cQry := " UPDATE "+RetSqlName("ZZJ")+" SET ZZJ_NUM = '999999' WHERE ZZJ_NUM IN( select DISTINCT ZZJ.ZZJ_NUM from "+RetSqlName("ZZJ")+" ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND EXISTS (select * from "+RetSqlName("ZZJ")+" TZJ WHERE TZJ.D_E_L_E_T_ = ' ' AND TZJ.ZZJ_NUM = ZZJ.ZZJ_NUM and TZJ.r_e_c_n_o_ <>  ZZJ.r_e_c_n_o_ ) ) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := "UPDATE "+RetSqlName("SC6")+"  TC6 SET C6_ZENTRE2 = ' ', C6_XEMAIL = ' ', C6_XPREV = ' ' WHERE  TC6.R_E_C_N_O_ IN( SELECT SC6.R_E_C_N_O_ FROM "+RetSqlName("SC6")+" SC6 WHERE C6_XPREV <> ' ' AND SC6.D_E_L_E_T_ = ' '  AND NOT EXISTS(SELECT * FROM "+RetSqlName("ZZJ")+" ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND ZZJ_NUM = C6_XPREV)) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	u_ZZJAJUS()
	
	cQry := "UPDATE "+RetSqlName("SC6")+" TC6 SET TC6.C6_XEMAIL =  ' ' ,TC6.C6_ZENTRE2 = (SELECT ZZJ_DATA FROM "+RetSqlName("ZZJ")+" ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND TC6.C6_XPREV = ZZJ_NUM ) "
	cQry += "WHERE TC6.D_E_L_E_T_ = ' ' "
	cQry += "AND TC6.R_E_C_N_O_ IN ( SELECT SC6.R_E_C_N_O_ FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' "
	cQry += "                        AND C6_XPREV <> ' ' AND C6_ZENTRE2 <> ( SELECT ZZJ_DATA FROM "+RetSqlName("ZZJ")+" ZZJ  WHERE ZZJ.D_E_L_E_T_ = ' ' AND C6_XPREV = ZZJ_NUM) ) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := " UPDATE "+RetSqlName("SC6")+" SC6 SET C6_XPREV = ' ',C6_ZENTRE2 = ' ',C6_XEMAIL = ' ' WHERE SC6.R_E_C_N_O_ IN ( "
	cQry += " SELECT SC6.R_E_C_N_O_ FROM "+RetSqlName("SC6")+" SC6 INNER JOIN (SELECT * FROM "+RetSqlName("ZZJ")+") ZZJ ON ZZJ.D_E_L_E_T_ = ' ' AND ZZJ_NUM = C6_XPREV AND ZZJ_DATA < "
	cQry += " '"+ dtos(dDatabase)+"'  INNER JOIN( SELECT * FROM "+RetSqlName("PA1")+")PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1_DOC = C6_NUM||C6_ITEM WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_XPREV <> ' '  AND C6_BLQ <> 'R' AND C6_QTDVEN > C6_QTDENT ) "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := " UPDATE "+RetSqlName("SC6")+" SC6 SET C6_QTDENT = NVL((SELECT SUM(D2_QUANT) FROM "+RetSqlName("SD2")+" SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD = C6_PRODUTO AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM),0) "
	cQry += " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQry += " AND   C6_OPER = '15' "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQry := "	UPDATE "+RetSqlName("PC1")+" PC1 SET PC1_CNPJ = NVL((SELECT A1_CGC FROM "+RetSqlName("SA1")+" SA1 WHERE SA1.D_E_L_E_T_ = ' ' AND A1_COD = PC1_CODCLI AND A1_LOJA = PC1_LOJA),' ') WHERE PC1.D_E_L_E_T_ = ' ' and PC1_CNPJ = ' ' "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	
	cQry := "	UPDATE "+RetSqlName("SC6")+" TC6 SET TC6.C6_ZENTRE2 =  ' ' , TC6.C6_XEMAIL =  ' ' WHERE TC6.R_E_C_N_O_ IN ( "
	cQry += " SELECT SC6.R_E_C_N_O_ FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQry += " INNER JOIN( SELECT * FROM "+RetSqlName("SC6")+") SC6 "
	cQry += " ON SC6.D_E_L_E_T_ =  ' ' "
	cQry += " AND SC6.C6_XPREV = ZZJ_NUM "
	cQry += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	cQry += " AND SC6.C6_BLQ <> 'R' "
	cQry += " AND SC6.C6_ZENTRE2 <> ZZJ_DATA "
	cQry += " WHERE ZZJ.D_E_L_E_T_ =  ' ' "
	cQry += " AND ZZJ_ALT <> ' ' "
	//cQry += " AND ZZJ.ZZJ_DATA >= '20150911'
	cQry += " AND ZZJ.ZZJ_CANCEL = ' ') "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	
	cQry := "	UPDATE "+RetSqlName("SC6")+" TC6 SET TC6.C6_ZENTRE2 = NVL((SELECT ZZJ_DATA FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQry += " 		WHERE ZZJ.D_E_L_E_T_ =  ' ' "
	cQry += " 		 AND ZZJ_ALT <> ' ' "
	//cQry += " AND ZZJ.ZZJ_DATA >= '20150911'
	cQry += " 		 AND ZZJ.ZZJ_CANCEL = ' ' "
	cQry += " 		 AND TC6.C6_XPREV = ZZJ_NUM),' ') "
	cQry += " WHERE  TC6.D_E_L_E_T_ =  ' ' "
	cQry += " AND TC6.C6_QTDVEN > TC6.C6_QTDENT "
	cQry += " AND TC6.C6_BLQ <> 'R' "
	cQry += " AND TC6.C6_XPREV <> ' ' "
	cQry += " AND TC6.C6_ZENTRE2 = ' ' "
	nRet := TcSQLExec(cQry)
	IF nRet <> 0
	  CONOUT("[PREVDISTRI] - Erro na execução da Query -"+CHR(13)+CHR(10)+cQry)
	ENDIF
	
	cQuery := " SELECT ZZJ_COD, ZZJ_NUM, "
	cQuery += " ZZJ_QUANT, "
	cQuery += " ZZJ_DATA "
	cQuery += "  FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQuery += " WHERE ZZJ.D_E_L_E_T_ = ' ' "
	cQuery += " AND ZZJ.ZZJ_CANCEL = ' ' "
	cQuery += " AND ZZJ.ZZJ_DATA >= '"+dtos(ddatabase)+"' " 
	cQuery += " AND EXISTS ( SELECT * FROM "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = '"+XFILIAL("PA1")+"' AND PA1_TIPO = '1' "
	cQuery += " AND ZZJ_COD = PA1_CODPRO) "
	cQuery += " ORDER BY ZZJ_COD,ZZJ_DATA "
	//cQuery := ChangeQuery(cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	ProcRegua(RecCount()) // Numero de registros a processar
	IncProc()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			If !(Alltrim((cAliasLif)->ZZJ_COD) $ ('CA2010AB/CA2010B'))
				IncProc()
				_nQtdDisp   := 	((cAliasLif)->ZZJ_QUANT  - PREVSUM((cAliasLif)->ZZJ_NUM) )
			
				If Select(cAliasSc6) > 0
					(cAliasSc6)->(dbCloseArea())
				EndIf
			
				cAliasSc6 := 'Prev'+Alltrim((cAliasLif)->ZZJ_COD)
				PREVSC6(Alltrim((cAliasLif)->ZZJ_COD))
			
				If  Select(cAliasSc6) > 0
					(cAliasSc6)->(dbgotop())
					While !(cAliasSc6)->(Eof())
				 
						If _nQtdDisp >= (cAliasSc6)->QTDSC6
							_nQtdDisp  -= (cAliasSc6)->QTDSC6
						
							dbSelectArea('SC6')
							SC6->(DbGoTo((cAliasSc6)->REC))
							If SC6->(RECNO()) = (cAliasSc6)->REC
								SC6->(RecLock('SC6',.F.))
								SC6->C6_XPREV  := (cAliasLif)->ZZJ_NUM
								SC6->C6_XQTPRV := (cAliasSc6)->QTDSC6
								SC6->C6_ZENTRE2:= STOD((cAliasLif)->ZZJ_DATA)
								SC6->(MsUnlock())
								SC6->(DbCommit())
							EndIf
							
							/*****************************************
							Alteração....: Se a variável _nQtdDisp ficar <= 0 não permite gravar os campos referente ao compromisso na tabela SC6
							Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
							Data.........: 22/09/2021
							Trecho retirado do código

							Else
						
							_nQtdDisp  -= (cAliasSc6)->QTDSC6
							If _nQtdDisp< 0
								_nQtdDisp  :=0
							EndIf

							dbSelectArea('SC6')
							SC6->(DbGoTo((cAliasSc6)->REC))
							If SC6->(RECNO()) = (cAliasSc6)->REC
								SC6->(RecLock('SC6',.F.))
								SC6->C6_XPREV  := (cAliasLif)->ZZJ_NUM
								SC6->C6_XQTPRV := (cAliasSc6)->QTDSC6
								SC6->C6_ZENTRE2:= STOD((cAliasLif)->ZZJ_DATA)
								SC6->(MsUnlock())
								SC6->(DbCommit())
							EndIf
							*****************************************/
						EndIf
					(cAliasSc6)->(dbSkip())
					End
															
				EndIf
			
			Else
			
				If  Select(cAliasSc6) > 0
				(cAliasSc6)->(dbgotop())
					While !(cAliasSc6)->(Eof())
					_dDat:= u_StDtCanl(Alltrim((cAliasLif)->ZZJ_COD),(cAliasSc6)->QTDSC6)
					_nQtdDisp:= (cAliasSc6)->QTDSC6
						If _nQtdDisp >= (cAliasSc6)->QTDSC6
						_nQtdDisp  -= (cAliasSc6)->QTDSC6
						
						dbSelectArea('SC6')
						SC6->(DbGoTo((cAliasSc6)->REC))
							If SC6->(RECNO()) = (cAliasSc6)->REC
							SC6->(RecLock('SC6',.F.))
							SC6->C6_XPREV  := 'CUSTOM'
							SC6->C6_XQTPRV := (cAliasSc6)->QTDSC6
							SC6->C6_ZENTRE2:=  _dDat
							SC6->(MsUnlock())
							SC6->(DbCommit())
							EndIf
						
						
						EndIf
					(cAliasSc6)->(dbSkip())
					End
															
				EndIf
			
			
			
			EndIf
			
			(cAliasLif)->(dbSkip())
		End
		
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
Return()



User Function StDtCanl(_cCod,_nQtdx)
Local _cDate 	:= Stod('20200101')
	Local _aArea	 := GetArea()
	Local cQuery     := ' '
	Private cAliasCAN := 'StDtCanl'
	
	cQuery := " SELECT "
	cQuery += ' SUM(PA1_QUANT) "QTDSC6"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" ) SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM "
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA1")+" ) PA1 "
	cQuery += " ON PA1.PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM "
	cQuery += " AND PA1.PA1_CODPRO = SC6.C6_PRODUTO "
	cQuery += " AND PA1.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA1.PA1_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND PA1.PA1_QUANT > 0 "
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO "
	cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC6.C6_FILIAL    = '"+xFilial("SC6")+"' "
	cQuery += " AND SC6.C6_XPREV <> 'CUSTOM' "
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	cQuery += " AND SC6.C6_BLQ <> 'R' "
	cQuery += " AND SC6.C6_PRODUTO = '"+_cCod+"' "
	cQuery += " ORDER BY C5_XPRIORI "
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasCAN) > 0
		(cAliasCAN)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasCAN)
	dbSelectArea(cAliasCAN)
	If  Select(cAliasCAN) > 0

_nQtdx:= _nQtdx+ (cAliasCAN)->QTDSC6
		If _nQtdx  < 8500
_nQtdx:= 1 
		Else
_nQtdx:= Round(_nQtdx/8500,0)
		EndIf
_cDate:= ddatabase+_nQtdx




	EndIf
 



 
Return(_cDate)
/*====================================================================================\
|Programa  | PREVSC6             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição |  SELECIONA  SC6                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | PREVSC6                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function PREVSC6(_cProdx)
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cQuery     := ' '
	
	cQuery := " SELECT "
	cQuery += " C5_NUM, "
	cQuery += " SC6.R_E_C_N_O_  REC, "
	cQuery += " SC6.C6_PRODUTO , "
	//cQuery += ' SC6.C6_QTDVEN-SC6.C6_QTDENT "QTDSC6",
	cQuery += " PA1_QUANT QTDSC6, "
	cQuery += " C5_XPRIORI "
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" ) SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM "
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA1")+" ) PA1 "
	cQuery += " ON PA1.PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM "
	cQuery += " AND PA1.PA1_CODPRO = SC6.C6_PRODUTO "
	cQuery += " AND PA1.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA1.PA1_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND PA1.PA1_QUANT > 0 "
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO "
	cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	//cQuery += " AND SF4.F4_CF IN('5101','7101','7102','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	//cQuery += " AND SC6.C6_CF IN('6910','5910','5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC6.C6_FILIAL    = '"+xFilial("SC6")+"' "
	cQuery += " AND SC6.C6_XPREV = ' ' "
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	cQuery += " AND SC6.C6_BLQ <> 'R' "
	cQuery += " AND SC6.C6_PRODUTO = '"+_cProdx+"' "
	cQuery += " ORDER BY C5_XPRIORI "
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasSc6) > 0
		(cAliasSc6)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSc6)
	dbSelectArea(cAliasSc6)
	
Return()

/*====================================================================================\
|Programa  | PREVSUM             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição |  SUM COMPROMISSO NA SC6                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | PREVSUM                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function PREVSUM(_cPrevs)
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cAliasSum  := 'PREVSUM'
	Local cQuery     := ' '
	Local _nRet      := 0
	
	cQuery := " SELECT
	cQuery += ' SUM(SC6.C6_XQTPRV) "QTD"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL   = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_XPREV = '"+_cPrevs+"'"
	//cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND SC6.C6_BLQ <> 'R'
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasSum) > 0
		(cAliasSum)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSum)
	dbSelectArea(cAliasSum)
	If  Select(cAliasSum) > 0
		(cAliasSum)->(dbgotop())
		
		_nRet:= (cAliasSum)->QTD
		
	EndIf
	
Return(_nRet)



/*====================================================================================\
|Programa  | STMAIPREV           | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Processa o Envio de email                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMAIPREV                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function STMAIPREV(_aResul)
	*---------------------------*
	Local _nSoQuan  := 0
	Local k
	
	ProcRegua(Len(_aResul)) // Numero de registros a processar
	IncProc()
	
	For k:=1 To Len(_aResul)
		IncProc()
		DbSelectArea("SC6")
		SC6->(DbGoTo(_aResul[K,12] ))
		If _aResul[K,12]   = SC6->(RECNO()) .And. SC6->C6_XPREV <> ' '
			SC6->(RecLock("SC6",.F.))
			SC6->C6_XEMAIL := dDataBase
			SC6->(MsUnlock())
			SC6->( DbCommit() )
		EndIf
		MailPrev(k,_aResul)
	Next k
	
Return()
/*====================================================================================\
|Programa  | MailPrev         | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | MailPrev                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MailPrev                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
Static Function  MailPrev(f,_aResul)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Faturamento -Previsão de Chegada.('+_aResul[f,9]+')'
	Local cFuncSent:= "MailPrev"
	Local _aMsg    := {}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ''				//'giovani.zago@steck.com.br' Removido conforme solicitação Giovani 03/09/2020
	Local cAttach  := ''
	Local _cEmail  :=  'alex.lourenco@steck.com.br,lucas.machado@steck.com.br'
	Local dDTREC   := ctod("")
	Local nDEmb    := SuperGetMV("ST_DIAEMBA",.F.,3)																// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
	Local cEmlResp := ""																							// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
	Local aAreaV
	Local lPedUni  := U_getPedVen(_aResul[f,3]) //StaticCall (STFSLIB, getPedVen, _aResul[f,3])			// Valdemir Rabelo 20/03/2020

	// Valdemir Rabelo 20/08/2020 - ticket Nº 20200609002790 
	if lPedUni
		_cCopia += ";filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br"
	endif

	// Ticket 20201127011283
	// Zeca
	If cFilAnt <> "05"
		// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
		if f==1
			if ApMsgYesNo("Deseja informar e-mail da pessoa responsável","Atenção!")
				While .F.
	               cEmlResp := FWInput("Informe o e-mail do responsável", cEmlResp)
					if Empty(cEmlResp)
						if ApMsgYesNo("E-mail não foi informando, deseja continuar mesmo assim?","Informativo")
					     exit
						endif
					endif
				EndDo
			Endif
		Endif
	Endif
	
	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	_cEmail  += ','+_aResul[f,8]

	// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
	if !Empty(cEmlResp)
		_cEmail  += "," + cEmlResp
	Endif

	// Valdemir Rabelo 20/08/2020 - ticket Nº 20200609002790 
	cVend := Posicione("SA1",1,xFilial("SA1")+_aResul[f,1]+_aResul[f,2],"A1_VEND")
	IF !EMPTY(cVend)
		cTMP := Posicione("SA3",1,xFilial("SA3")+cVend, "A3_EMAIL")
		if !Empty(cTMP)
			_cEmail += ","+cTMP
		Endif
	Endif

	// Valdemir Rabelo - 29/01/2020 - ticket Nº 20200127000157 Envia WF a vendedores externos
	if !Empty(_aResul[f,6]) .and. (Left(_aResul[f,6],1)=="E")
	    aAreaV := GetArea()
		cEmlResp := Posicione("SA3",1,xFilial("SA3")+_aResul[f,6],"A3_EMAIL")
		IF !Empty(cEmlResp)
        	_cEmail  += "," + cEmlResp
		Endif
		RestArea( aAreaV )
	Endif
	
	//Chamado 004384 - Thiago Godinho
	If Alltrim(_aResul[f,1]) $ "008724#010566#001236"
		_cCopia += "eliane.silva@steck.com.br"			    // Valdemir Rabelo 26/08/2020
	EndIf
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
        dData     := ctod(_aResul[f,11])
		dDTREC    := U_PrxDiaUt(dData, nDEmb) //StaticCall (STFSLIB,PrxDiaUt, dData, nDEmb) 			// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
		cModal    := Iif(Alltrim( _aResul[f,18])= '1' , 'Rodoviario' ,Iif(Alltrim( _aResul[f,18])= '2' , 'Aereo' , 'Maritimo' )) // Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
	    cZZJLOCAL := Iif(Alltrim( _aResul[f,20])= '1' , 'Fabrica AM' ,Iif(Alltrim( _aResul[f,20])= '2' , 'Fabrica SP' , 'Importado' ))

		Aadd(_aMsg	,{ ' ' 				,'De:'						,'Para:'})
		Aadd(_aMsg	,{ 'Numero' 		,Alltrim( _aResul[f,16]) 	,Alltrim( _aResul[f,16])})
		Aadd(_aMsg	,{ 'Referencia' 	,Alltrim( _aResul[f,17])	,Alltrim( _aResul[f,17])})

		Aadd( _aMsg , { "Pedido: "          , _aResul[f,3], 	_aResul[f,3]}  )
		Aadd( _aMsg , { "Ordem: "           , _aResul[f,13], 	_aResul[f,13]} )
		Aadd( _aMsg , { "Cliente - Loja: "  , _aResul[f,1]+' - '+_aResul[f,2], _aResul[f,1]+' - '+_aResul[f,2] } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+_aResul[f,1]+_aResul[f,2],"A1_NOME"),1,35),substr(Posicione("SA1",1,xFilial("SA1")+_aResul[f,1]+_aResul[f,2],"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Vendedor : "    	, _aResul[f,6], 	_aResul[f,6]})
		Aadd( _aMsg , { "Nome Vendedor: "   , _aResul[f,7], 	_aResul[f,7]  } )
		Aadd( _aMsg , { "Produto:"    		, _aResul[f,10], 	_aResul[f,10] } )
		Aadd( _aMsg , { "Descrição:"   		, Posicione("SB1",1,xFilial('SB1')+_aResul[f,10],"B1_DESC"), Posicione("SB1",1,xFilial('SB1')+_aResul[f,10],"B1_DESC") } )					// Valdemir Rabelo 28/01/2020 - ticket Nº 20200127000158 
		Aadd( _aMsg , { "Quantidade: "    	, transform((_aResul[f,4])	,"@E 99,999,999,999"),transform((_aResul[f,4])	,"@E 99,999,999,999")  } )
		Aadd( _aMsg , { "Previsão:"    		, _aResul[f,11],	_aResul[f,11] } )
		Aadd( _aMsg , { "Previsão Embarque:", dtoc(dDTREC), 	dtoc(dDTREC)  } )		
		Aadd(_aMsg	, {'Modal' 				, cModal, cModal})
		Aadd(_aMsg	, {'Motivo' 			, Alltrim( _aResul[f,14]) 	 ,Alltrim( _aResul[f,14]) })
		Aadd(_aMsg	, {'Compl.Alter.'		, Alltrim( _aResul[f,19])    ,Alltrim( _aResul[f,19]) })      // Chamado 20200818005811- Valdemir Rabelo
		If ExistSx3("ZZJ_LOCAL")
			Aadd(_aMsg,{'Steck'				, cZZJLOCAL, cZZJLOCAL})			 				
		EndIf
		Aadd(_aMsg,{CUSERNAME			,DTOC(DATE()) 				,TIME()})
		
/*						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
				
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)
*/		

		// Valdemir Rabelo 14/10/2020 Titcket: 20200806005285 (Unificação de WFs Alteração / Faturamento  Previsão de Chegada)
		// Mantendo a regra de e-mail para envio de cada rotina que faz a chamada
		U_STWFPRVC(_aMsg, _cAssunto,_cEMail, _cCopia) //StaticCall (STFSLIB, STWFPRVC, _aMsg, _cAssunto,_cEMail, _cCopia)

	EndIf
	RestArea(aArea)
Return()


User Function STZZJMAIL()

	Local _aArea	:= GetArea()
	Local cAliaZzj  := 'TMPBZZJ'
	Local cQuery     := ' '
	Local _aResul := {}

	cQuery := " SELECT
	cQuery += " C5_CLIENTE CLIENTE,
	cQuery += " C5_LOJACLI LOJA,
	cQuery += " C5_XNOME NOME,
	cQuery += " C5_NUM NUMERO,
	cQuery += " C5_XORDEM ORDEM,
	cQuery += " C6_PRODUTO PRODUTO,
	cQuery += " C6_XPREV PREV,
	cQuery += " C6_XQTPRV QTD,
	cQuery += " SC6.R_E_C_N_O_ REC,
	cQuery += " substr(ZZJ_DATA,7,2)||'/'||substr(ZZJ_DATA,5,2)||'/'||substr(ZZJ_DATA,1,4) DATA,
	cQuery += " C5_XPRIORI PRIORIDADE,
	cQuery += '  ZZJ_ALTER,ZZJ_LOCAL,ZZJ_COMPAL,utl_raw.cast_to_varchar2(dbms_lob.substr(ZZJ_MHISTO,2000,1)) AS ZZJ_MHISTO,ZZJ_NUM NUMZZJ,ZZJ_OP NUMOP,ZZJ_TRANSP ZZJTRANSP,
	cQuery += "  CASE WHEN C5_VEND2 <> ' ' THEN C5_VEND2 ELSE  C5_VEND1 END VENDEDOR,
	cQuery += "   NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND2
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),
	cQuery += "   NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND1
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ') )
	cQuery += '   "NVEND" , SC5.C5_TIPOCLI ,
	cQuery += "  NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND2
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),
	cQuery += "  NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND1
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ') ) EMAIL

	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "


	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" ) SC6 "
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL
	cQuery += " AND SC6.C6_NUM = SC5.C5_NUM
	cQuery += " AND SC6.C6_XEMAIL = ' '
	cQuery += " AND SC6.C6_XPREV <> ' '

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("ZZJ")+" ) ZZJ "
	cQuery += " ON ZZJ.D_E_L_E_T_ = ' '
	cQuery += " AND ZZJ.ZZJ_NUM = C6_XPREV
	cQuery += " AND ZZJ.ZZJ_DATA > '"+DTOS(DDATABASE)+"'"

	cQuery += " WHERE SC5.D_E_L_E_T_ =  ' '
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Trocando a chamada para buscar da nova empresa
	Data...........: 08/02/2022
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Chamado........: 20220125001951 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	if FWIsInCallStack("U_ST650EMP")				// Valdemir Rabelo 01/09/2020
		cQuery += " AND   SC5.C5_FILIAL  = '02'"
	else
		cQuery += " AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	Endif
	*************************************************************/	
	cQuery += " AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	//cQuery += " AND   SC5.C5_TIPOCLI <> 'X'

	//cQuery += " GROUP BY C5_NUM,C5_XPRIORI,C5_VEND2,C5_VEND1,C5_CLIENTE,C5_LOJACLI,C5_XNOME
	cQuery += " ORDER BY SC5.C5_VEND2



	//cQuery := ChangeQuery(cQuery)

	If Select(cAliaZzj) > 0
		(cAliaZzj)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliaZzj)
	dbSelectArea(cAliaZzj)
	If  Select(cAliaZzj) > 0
		(cAliaZzj)->(dbgotop())
		While (cAliaZzj)->(!Eof())
			aadd(	_aResul,{ (cAliaZzj)->CLIENTE   ,;		// 01
			(cAliaZzj)->LOJA   ,;						// 02
			(cAliaZzj)->NUMERO  ,;						// 03
			(cAliaZzj)->QTD   ,;						// 04
			(cAliaZzj)->PRIORIDADE  ,;					// 05
			(cAliaZzj)->VENDEDOR  , ;					// 06
			(cAliaZzj)->NVEND  ,;						// 07
			Iif((cAliaZzj)->C5_TIPOCLI <> 'X',(cAliaZzj)->EMAIL, "  Arisla.Aciardi@steck.com.br;    beatriz.melazzo@steck.com.br ; gabrielle.souza@steck.com.br    ; kamila.melo@steck.com.br ; maria.carmo@steck.com.br;richely.lima@steck.com.br" )  ,; //Chamad 006759 - Adicionei a usuaria richely.lima
			(cAliaZzj)->PREV  ,;						// 09
			(cAliaZzj)->PRODUTO  ,;						// 10
			(cAliaZzj)->DATA  ,;						// 11
			(cAliaZzj)->REC  ,;							// 12
			(cAliaZzj)->ORDEM , ;						// 13
			(cAliaZzj)->ZZJ_ALTER  ,;					// 14
			(cAliaZzj)->ZZJ_MHISTO ,;					// 15
			(cAliaZzj)->NUMZZJ  ,;						// 16
			(cAliaZzj)->NUMOP,;							// 17
			(cAliaZzj)->ZZJTRANSP,;						// 18
			(cAliaZzj)->ZZJ_COMPAL,;					// 19
			(cAliaZzj)->ZZJ_LOCAL ;					    // 20
			})


			(cAliaZzj)->(DbSkip())
		End
	EndIf
	If len(_aResul) > 0
		//	STMAIPREV(_aResul)
	EndIf

	If Select(cAliaZzj) > 0
		(cAliaZzj)->(dbCloseArea())
	EndIf


Return()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCEPIMPORTºAutor ³ GIOVANI ZAGO	     º Data ³  27/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  										                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Exportação                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*-----------------------------*
User Function STCOMIMPORT()
	Private tTabFAT				// Tabela temporária
	Private aCamposFAT := {}	// Campos da tabela

	Processa({|| Importacao()},"Importando arquivos", "")



Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= 'C:\COMPROMISSO'
	Local cDirOk		:= ' '
	Local cDirErro		:= ' '
	Local lImportou     := .T.
	Private GFEResult := GFEViewProc():New()
	Private cFilialFat
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog116 	:= GFELog():New("Importacao_COMPROMISSO", "COMPROMISSO - Importação", SuperGetMV('MV_GFEEDIL',,'1'))
	Private GFEFile     := GFEXFILE():New()


	aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )

	// Verifica se existe arquivos no diretório informado
	If Len(aDirImpor) == 0
		GFELog116:Add("** " + "Nenhum arquivo encontrado no diretório " + cDiretorio)
		GFELog116:EndLog()
		MsgAlert("Nenhum arquivo encontrado no diretório " + cDiretorio, "Aviso")
		Return
	Endif

	// Data e Hora
	cFormatDt := stuff(DTOC(date()),3,1,'')
	cFormatDt := stuff(cFormatDt,5,1,'')

	cFormatTm := stuff(Time(),3,1,'')
	cFormatTm := stuff(cFormatTm,5,1,'')

	GFELog116:Add("- Início da importação")
	GFELog116:NewLine()
	GFELog116:Save()

	ProcRegua(Len(aDirImpor))

	For nCountFiles := 1 To Len(aDirImpor)
		lArquivoValido := .T.
		cNomeArq := aDirImpor[nCountFiles][1]

		GFELog116:Add(Replicate("-", 80))
		GFELog116:Add("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)

		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)

		cBuffer := GFEFile:Line()

		LayoutPro3()

	Next

	GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Ocorreram erros na importação")

	GFELog116:EndLog()

Return Nil

Static Function LayoutPro3()
	Local cBuffer			:= ""
	Local nContDF			:= 1
	Local lSelecao		:= .T.
	Local nContLinhas	:= 0        // Contador de Linhas do arquivo
	Local nCountFatArq	:= 0		// Contador de Faturas por arquivo
	Local lDocFind		:= .F.
	Local nI				:= 0
	Local nJ				:= 0
	Local cCdTrp			:= ""
	Local lContEmis		:= .F.
	Local cCGCTrp			:= ""
	Local lEmisDf			:= .F.
	Local cCDEMIT			:= "'
	Local cNrDf			:= ""
	Local cNrDfArquivo	:= ""
	Local nQtNumDF		:= 0
	Local rTabFAT[2]				// Chave da tabela temporária tTabFAT, FILIAL + NRIMP
	Local aDocFrete[10]
	Local cEmitEmbarc	:= ""
	Local aEmitFatura	:= {}
	Local nContPrev		:= 0
	Local cSerDFBase		:= ""
	Local cNrDFBase		:= ""
	Local cEmitFatura	:= ""

	//faça enquanto não chega o fim do arquivo
	nContLinhas := 0
	nCountFatArq := 0
	rTabFAT[1] := ""
	rTabFAT[2] := ""
	While !GFEFile:FEof()
		nContLinhas++

		cBuffer := GFEFile:Line()
		lEmisDf := .F.
		If u_xSTZZJVAL(UPPER(AllTrim(SubStr(cBuffer,001,15))),Val(SubStr(cBuffer,16,06)))
			DbSelectArea("ZZJ")
			RecLock("ZZJ", .T.)



			ZZJ->ZZJ_FILIAL 	:= " "
			ZZJ->ZZJ_NUM 		:= GETSXENUM("ZZJ","ZZJ_NUM")
			ZZJ->ZZJ_COD 		:= UPPER(AllTrim(SubStr(cBuffer,001,15)))
			ZZJ->ZZJ_QUANT		:= val(SubStr(cBuffer,16,06))
			ZZJ->ZZJ_FILIAL		:= UPPER(AllTrim(SubStr(cBuffer,023,02)))
			ZZJ->ZZJ_DATA		:= STOD(UPPER(AllTrim(SubStr(cBuffer,025,08))))
			ZZJ->ZZJ_OP 		:= UPPER(AllTrim(SubStr(cBuffer,033,020)))
			ZZJ->ZZJ_TRANSP		:= UPPER(AllTrim(SubStr(cBuffer,053,01)))
			ZZJ->ZZJ_USUARI		:= 'TXT'
			ZZJ->ZZJ_NOME	  	:= cUserName


			MsUnLock("ZZJ")
		EndIf

		GFEFile:FNext()

		GFELog116:Save()
	EndDo
Return



User Function STEMBZZJ(_cNf)


	Local	cQuery		:= ' '
	Private cPerg       := 'STEMBZZJ'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private _cAliasZ    := cPerg+cHora+ cMinutos+cSegundos


	cQuery := "  SELECT
	cQuery += "  D2_COD
	cQuery += '  "COD",
	cQuery += "  SUM(D2_QUANT)
	cQuery += '  "QUANT",
	cQuery += "  ZZT_MODAL
	cQuery += '  "MODAL"

	cQuery += "   FROM "+RetSqlName("SD2")+" SD2
	cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("ZZT")+") ZZT
	cQuery += "  ON ZZT.D_E_L_E_T_ =  ' '
	cQuery += "  AND ZZT_NF = D2_DOC AND ZZT_FILDES = '"+XFILIAL("ZZT")+"'

	cQuery += "  WHERE SD2.D_E_L_E_T_ =  ' '
	cQuery += "  AND D2_CLIENTE = '033467'
	cQuery += "  AND D2_DOC = '"+_cNf+"'"

	cQuery += "  AND NOT EXISTS( SELECT * FROM "+RetSqlName("ZZJ")+" ZZJ
	cQuery += "  WHERE ZZJ.D_E_L_E_T_ =  ' '
	cQuery += "  AND ZZJ_COD = D2_COD
	cQuery += "  AND ZZJ_DATA >   CASE WHEN  ZZT_MODAL = 'A' THEN '"+ DTOS(DDATABASE+3)+"' ELSE '"+ DTOS(DDATABASE+15)+"' END
	cQuery += "  )
	cQuery += "  GROUP BY D2_COD,ZZT_MODAL



	If Select(_cAliasZ) > 0
		(_cAliasZ)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),_cAliasZ)


	If  Select(_cAliasZ) > 0
		(_cAliasZ)->(dbgotop())


		While !(_cAliasZ)->(Eof())

			DbSelectArea("ZZJ")
			RecLock("ZZJ", .T.)

			ZZJ->ZZJ_FILIAL 	:= " "
			ZZJ->ZZJ_NUM 		:= GETSXENUM("ZZJ","ZZJ_NUM")
			ZZJ->ZZJ_COD 		:= (_cAliasZ)->COD
			ZZJ->ZZJ_QUANT		:= (_cAliasZ)->QUANT
			ZZJ->ZZJ_DATA		:= Iif((_cAliasZ)->MODAL = 'A', DDATABASE+3 , DDATABASE+15)
			ZZJ->ZZJ_OP 		:= _cNf
			ZZJ->ZZJ_TRANSP		:= Iif((_cAliasZ)->MODAL = 'A', '2' , '1')
			ZZJ->ZZJ_USUARI		:= 'JOB-NF'
			ZZJ->ZZJ_NOME	  	:= 'SYSTEM '+DTOC(DATE())+' - '+ TIME()

			ZZJ->(MsUnlock())
			ZZJ->(DbCommit())

			(_cAliasZ)->(dbSkip())
		End
	EndIf

Return

/*====================================================================================\
|Programa  | xLegendAlca    | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xLegendAlca                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function XZZJNEXTNUM()
	Local _cRet := '000000'
	Local _aArea	:= GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	
	If ! GetMv("ST_PREV2",,.F.) //TESTE TA DANDO ERRO NISSO AQUI
		return(IIF(INCLUI,GETSXENUM("ZZJ","ZZJ_NUM"),ZZJ->ZZJ_NUM) )
		//IIF(INCLUI,GETSXENUM("ZZJ","ZZJ_NUM"),ZZJ->ZZJ_NUM)
	EndIf
	
	cQuery := " SELECT ZZJ_NUM
	cQuery += " FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQuery += " ORDER BY ZZJ_NUM DESC
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		_cRet 	:= (cAliasLif)->ZZJ_NUM
		
	EndIf
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	_cRet:=soma1(_cRet)
Return(_cRet)


User Function xSTZZJVAL(_cProc,_nQtd)
	Local _lRezzj := .F.
	Local _nQtAcol:= 0
	Local _nQuer  := 0
	Local cQuery     := ' '
	Local cAliaszzj     := 'TMPZZJ'
	
	
	cQuery := " SELECT
	cQuery += " SUM(SC7.C7_QUANT - SC7.C7_QUJE )
	cQuery += ' "VALOR"
	// Ticket: 20201029009652 - Valdemir Rabelo - Adicionado Filial: 05
	cQuery += " FROM "+RetSqlName("SC7")+" SC7
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_PRODUTO = '"+ Alltrim(_cProc)+"'
	cQuery += " AND SC7.C7_QUANT > SC7.C7_QUJE
	cQuery += " AND SC7.C7_RESIDUO = ' '
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Trocando a chamada para buscar da nova empresa
	Data...........: 08/02/2022
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Chamado........: 20220125001951 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	cQuery += " AND SC7.C7_FILIAL  IN('02','05')			
	*************************************************************/	
	cQuery += " AND SC7.C7_FILIAL = '"+XFILIAL("SC7")+"'
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliaszzj) > 0
		(cAliaszzj)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliaszzj)
	dbSelectArea(cAliaszzj)
	If  Select(cAliaszzj) > 0
		(cAliaszzj)->(dbgotop())
		
		_nQuer 	:= (cAliaszzj)->VALOR
		
	EndIf
	
	
	If _nQuer  >= _nQtd
		_lRezzj := .T.
		//Else
		//MsgInfo("Quantidade Superior ao Saldo do Pedido de Compras...!!!"+CR+CR+"Saldo Disponivel: "+ cvaltochar(_nQuer - _nQtAcol))
	EndIf
	
Return(_lRezzj)





/*====================================================================================\
|Programa  | PREVDEL             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
|=====================================================================================|
|Descrição |  DELETA COMPROMISSO NA SC6                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | PREVDEL                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
User Function STC6PA1PA2()
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cAliasLif  := 'STC6PA1PA2'
	Local cQuery     := ' '
	
	
	
	cQuery := " SELECT
	cQuery += "  C6_NUM
	cQuery += ' "NUM",
	cQuery += "  C6_PRODUTO
	cQuery += ' "PRODUTO",
	cQuery += " c6_item
	cQuery += ' "ITEM",
	cQuery += " C6_NUM||c6_item
	cQuery += ' "DOC",
	cQuery += " c6_qtdven-c6_qtdent
	cQuery += ' "SALDO",
	cQuery += " NVL( PA2.R_E_C_N_O_,0)
	cQuery += ' "PA2",
	cQuery += " NVL(PA1.R_E_C_N_O_,0)
	cQuery += ' "PA1" ,C5_EMISSAO ,SC5.C5_TIPOCLI
	
	cQuery += " FROM "+RetSqlName("SC6")+" SC6
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+")SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_EMISSAO < '"+ DTOS(( DATE() - 3 ))+"'
	cQuery += " AND   SC5.C5_TIPOCLI <> 'X'
	
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("PA2")+" )PA2
	cQuery += " ON PA2.D_E_L_E_T_ = ' '
	cQuery += " AND PA2_FILRES = C6_FILIAL
	cQuery += " AND PA2_DOC = C6_NUM||C6_ITEM
	
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("PA1")+" )PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = '"+XFILIAL("SC6")+"'
	cQuery += " and c6_blq <> 'R'
	cQuery += " AND EXISTS (SELECT * FROM "+RetSqlName("SC9")+" SC9
	cQuery += " WHERE  SC9.D_E_L_E_T_ = ' '
	cQuery += " AND C9_FILIAL = C6_FILIAL
	cQuery += " AND C9_PEDIDO = C6_NUM
	cQuery += " AND C9_ITEM = C6_ITEM
	cQuery += " AND C9_BLCRED = '09')
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			
			If (cAliasLif)->C5_TIPOCLI <> 'X' .Or. (cAliasLif)->C5_TIPOCLI = 'X'  .And. stod((cAliasLif)->C5_EMISSAO) < ( DATE() - 20 )
				
				dbSelectArea('PA2')
				PA2->(DbGoTo((cAliasLif)->PA2))
				If PA2->(RECNO()) = (cAliasLif)->PA2
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS  := 'LIMPEZA REJEITADO XXG '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA2->(DbDelete())
					PA2->(MsUnlock())
					PA2->(DbCommit())
				EndIf
				
				dbSelectArea('PA1')
				PA1->(DbGoTo((cAliasLif)->PA1))
				If PA1->(RECNO()) = (cAliasLif)->PA1
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS  := 'LIMPEZA REJEITADO XXG '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA1->(DbDelete())
					PA1->(MsUnlock())
					PA1->(DbCommit())
				EndIf
				
				
				
				PA1->(RecLock('PA1',.T.))
				PA1->PA1_FILIAL		:= xFilial('PA1')
				PA1->PA1_CODPRO		:= (cAliasLif)->PRODUTO
				PA1->PA1_DOC		:= (cAliasLif)->DOC
				PA1->PA1_TIPO		:= '1'
				PA1->PA1_QUANT		:= (cAliasLif)->SALDO
				PA1->(MsUnlock())
				PA1->(DbCommit())
			EndIf
			
			(cAliasLif)->(dbSkip())
		End
		
		
		
		
	EndIf
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	


Return()


User Function STC5PRO()
	Local _aArea	 := GetArea()
	Local cAliasLif  := 'STC5PRO'
	Local cQuery     := ' '
	
	
	
	cQuery := " SELECT
	cQuery += "  C6_NUM
	cQuery += ' "NUM",
	cQuery += "  C6_PRODUTO
	cQuery += ' "PRODUTO",
	cQuery += " c6_item
	cQuery += ' "ITEM",
	cQuery += " C6_NUM||c6_item
	cQuery += ' "DOC",
	cQuery += " c6_qtdven-c6_qtdent
	cQuery += ' "SALDO",
	cQuery += " NVL( PA2.R_E_C_N_O_,0)
	cQuery += ' "PA2",
	cQuery += " NVL(PA1.R_E_C_N_O_,0)
	cQuery += ' "PA1" ,C5_EMISSAO ,SC5.C5_TIPOCLI
	
	cQuery += " FROM "+RetSqlName("SC6")+" SC6
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+")SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_XAANO||C5_XMATE||C5_XATE >= '20210315'
	cQuery += " AND C5_XAANO <> ' '
	cQuery += " AND C5_XPRIORI = '99999999999999'
	cQuery += " AND   SC5.C5_TIPOCLI <> 'X'
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA2")+" )PA2
	cQuery += " ON PA2.D_E_L_E_T_ = ' '
	cQuery += " AND PA2_FILRES = C6_FILIAL
	cQuery += " AND PA2_DOC = C6_NUM||C6_ITEM
	
	cQuery += " LEFT JOIN(SELECT * FROM PA1010 )PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = '"+XFILIAL("SC6")+"'
	cQuery += " and c6_blq <> 'R'
	
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			
			If (cAliasLif)->C5_TIPOCLI <> 'X' .Or. (cAliasLif)->C5_TIPOCLI = 'X'  .And. stod((cAliasLif)->C5_EMISSAO) < ( DATE() - 20 )
				
				dbSelectArea('PA2')
				PA2->(DbGoTo((cAliasLif)->PA2))
				If PA2->(RECNO()) = (cAliasLif)->PA2
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS  := 'LIMPEZA REJEITADO XXGYY '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA2->(DbDelete())
					PA2->(MsUnlock())
					PA2->(DbCommit())
				EndIf
				
				dbSelectArea('PA1')
				PA1->(DbGoTo((cAliasLif)->PA1))
				If PA1->(RECNO()) = (cAliasLif)->PA1
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS  := 'LIMPEZA REJEITADO XXGYY '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA1->(DbDelete())
					PA1->(MsUnlock())
					PA1->(DbCommit())
				EndIf
				
				
				
				PA1->(RecLock('PA1',.T.))
				PA1->PA1_FILIAL		:= xFilial('PA1')
				PA1->PA1_CODPRO		:= (cAliasLif)->PRODUTO
				PA1->PA1_DOC		:= (cAliasLif)->DOC
				PA1->PA1_TIPO		:= '1'
				PA1->PA1_QUANT		:= (cAliasLif)->SALDO
				PA1->(MsUnlock())
				PA1->(DbCommit())
			EndIf
			
			(cAliasLif)->(dbSkip())
		End
		
		
		
		
	EndIf
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	





Return()


*---------------------------*
User Function ANOPA2PA1()
	*---------------------------*
	Local _aArea
	Local cAliasLif  := 'ANOPA2PA1'
	Local cQuery     := ' '
	Local _cOerFalRes   := ' '
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '04'
	
	_aArea	 := GetArea()
	
	
	cQuery := " SELECT
	cQuery += "  C6_NUM
	cQuery += ' "NUM", C6_OPER,
	cQuery += "  C6_PRODUTO
	cQuery += ' "PRODUTO",
	cQuery += " c6_item
	cQuery += ' "ITEM",
	cQuery += " C6_NUM||c6_item
	cQuery += ' "DOC",
	cQuery += " c6_qtdven-c6_qtdent
	cQuery += ' "SALDO",
	cQuery += " NVL( PA2.R_E_C_N_O_,0)
	cQuery += ' "PA2",
	cQuery += " NVL(PA1.R_E_C_N_O_,0)
	cQuery += ' "PA1" ,C5_EMISSAO ,SC5.C5_TIPOCLI
	
	cQuery += " FROM "+RetSqlName("SC6")+" SC6
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+")SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_EMISSAO >= '20170101'
	cQuery += " AND   SC5.C5_TIPO = 'N' AND SC5.C5_XTRONF = ' '
	
	cQuery += " LEFT JOIN(SELECT * FROM PA2010 )PA2
	cQuery += " ON PA2.D_E_L_E_T_ = ' '
	cQuery += " AND PA2_FILRES = C6_FILIAL
	cQuery += " AND PA2_DOC = C6_NUM||C6_ITEM
	
	cQuery += " LEFT JOIN(SELECT * FROM PA1010 )PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = '04'
	cQuery += " and c6_blq <> 'R' and c6_qtdven > c6_qtdent
	
	_cOerFalRes   := GetMv("ST_OPRESFA",,"94/74")
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			if cFilAnt = "04" // Adicionado por Robson Mazzarotto para tratar os pedidos de transferencia entre filials somente do CD para a Fabrica
				_cOerFalRes += ",94"
			Endif
			
			If !(SC6->C6_OPER $ _cOerFalRes)
				
				dbSelectArea('PA2')
				PA2->(DbGoTo((cAliasLif)->PA2))
				If PA2->(RECNO()) = (cAliasLif)->PA2
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS  := 'LIMPEZA ANO 2017 '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA2->(DbDelete())
					PA2->(MsUnlock())
					PA2->(DbCommit())
				EndIf
				
				dbSelectArea('PA1')
				PA1->(DbGoTo((cAliasLif)->PA1))
				If PA1->(RECNO()) = (cAliasLif)->PA1
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS  := 'LIMPEZA ANO 2017 '+ DTOC(DATE())+ ' - '+TIME()+ ' - ' + (cAliasLif)->C5_EMISSAO
					PA1->(DbDelete())
					PA1->(MsUnlock())
					PA1->(DbCommit())
				EndIf
				
				
				
				PA1->(RecLock('PA1',.T.))
				PA1->PA1_FILIAL		:= xFilial('PA1')
				PA1->PA1_CODPRO		:= (cAliasLif)->PRODUTO
				PA1->PA1_DOC		:= (cAliasLif)->DOC
				PA1->PA1_TIPO		:= '1'
				PA1->PA1_QUANT		:= (cAliasLif)->SALDO
				PA1->(MsUnlock())
				PA1->(DbCommit())
				
				
			Endif
			(cAliasLif)->(dbSkip())
		End
		
		
		
		
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
Return()









*---------------------------*
User Function SC2PA2PA1()
	*---------------------------*
	Local _aArea
	Local cAliasLif  := 'SC2PA2PA1'
	Local cQuery     := ' '
	Local _cOerFalRes   := ' '
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '04'
	
	_aArea	 := GetArea()
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Trocando a chamada para buscar da nova empresa
	Data...........: 08/02/2022
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Chamado........: 20220125001951 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/	
	cQuery := " SELECT R_E_C_N_O_ AS SC2 FROM "+RetSqlName("SC2")+" SC2 WHERE SC2.D_E_L_E_T_ = ' ' AND C2_EMISSAO >= '20171001' AND C2_QUANT > C2_QUJE AND C2_FILIAL = '"+XFILIAL("SC2")+"' "
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			
			dbSelectArea('SC2')
			SC2->(DbGoTo((cAliasLif)->SC2))
			If SC2->(RECNO()) = (cAliasLif)->SC2
				U_STFSC10D()
			EndIf
			
			(cAliasLif)->(dbSkip())
		End
		
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
Return()


/*/{Protheus.doc} STPesqGD()
	(long_description)
	Rotina que retorna os dias uteis
	@type  Static Function
	@author user
	Valdemir Rabelo - SigaMat
	@since date
	28/01/2020

Static Function DiasUteis(dDtAtu, nDias)
    Local aArea    := GetArea()
	Local lDtValid := .F.
	Local iCont    := 0
	Local dResult  := dDtAtu
     
	While (!lDtValid) .and. (iCont!=nDias)
        //Se a data atual for uma data Válida
        lDtValid :=  DataValida(dResult, .T.) 
         
        dResult := DaySum(dResult, 1)

		iCont++
	EndDo
    
    RestArea(aArea)
Return dResult
*/
