#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"

#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STBLOQORC        | Autor | GIOVANI.ZAGO             | Data | 12/08/2014  |
|=====================================================================================|
|Descrição | STBLOQORC        Bloqueio de Orçamento UB_XTABELA                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STBLOQORC                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STBLOQORC()
*-----------------------------*
Private cPerg 			:= "BLOQOR"
Private _cUserLib 		:= GetMv("MV_BLOQOR",,'000000')+'/000000'
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos


PutSx1(cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Orçamento:" ,"Do Orçamento: ?" ,"Do Orçamento: ?" 	   		,"mv_ch3","C",6,0,0,"G","",'SUA' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Orçamento:" ,"Ate Orçamento: ?" ,"Ate Orçamento: ?"		,"mv_ch4","C",6,0,0,"G","",'SUA' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Do Cliente:" ,"Do Cliente: ?" ,"Do Cliente: ?" 			   	,"mv_ch5","C",6,0,0,"G","",'SA1' ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Da Loja:" ,"Da Loja: ?" ,"Da Loja: ?" 			    			,"mv_ch6","C",2,0,0,"G","",' '   ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "Ate Cliente:" ,"Ate Cliente: ?" ,"Ate Cliente: ?" 				,"mv_ch7","C",6,0,0,"G","",'SA1' ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate Loja:" ,"Ate Loja: ?" ,"Ate Loja: ?" 	   					,"mv_ch8","C",2,0,0,"G","",' '   ,"","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "09", "Do Estado:" ,"Do Estado: ?" ,"Do Estado: ?" 			    	,"mv_ch9","C",2,0,0,"G","",'' ,"","","mv_par09","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "10", "Ate Estado:" ,"Ate Estado: ?" ,"Ate Estado: ?" 		        ,"mv_chA","C",2,0,0,"G","",'' ,"","","mv_par10","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "11", "Do Produto:" ,"Do Produto: ?" ,"Do Produto: ?" 			    ,"mv_chB","C",15,0,0,"G","",'SB1' ,"","","mv_par11","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "12", "Ate Produto:" ,"Ate Produto: ?" ,"Ate Produto: ?" 		        ,"mv_chC","C",15,0,0,"G","",'SB1' ,"","","mv_par12","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "13", "Do Grupo:" ,"Do Grupo: ?" ,"Do Grupo: ?" 			    		,"mv_chD","C",5,0,0,"G","",'SBM' ,"","","mv_par13","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "14", "Ate Grupo:" ,"Ate Grupo: ?" ,"Ate Grupo: ?" 		        	,"mv_chE","C",5,0,0,"G","",'SBM' ,"","","mv_par14","","","","","","","","","","","","","","","","")

If !(__cuserid $ _cUserLib)
	msgInfo("Usuario sem acesso...!!!!")
	Return()
EndIf

If Pergunte(cPerg,.T.)
	
	
	Processa({|| StQuery( ) },"Bloqueando Orçamentos...!!!!!!")
	
EndIf
Return()

Static Function StQuery()

Local cQuery     := ' '


cQuery := " SELECT
cQuery += ' SUB.R_E_C_N_O_ AS "SUBRECNO"

cQuery += " FROM "+RetSqlName("SUB")+" SUB "

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SUA")+" )SUA "
cQuery += " ON SUA.D_E_L_E_T_ = ' '
cQuery += " AND SUA.UA_NUM = SUB.UB_NUM
cQuery += " AND SUA.UA_FILIAL = SUB.UB_FILIAL

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SUA.UA_CLIENTE
cQuery += " AND SUA.UA_LOJA = SA1.A1_LOJA

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
cQuery += " ON SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_COD = SUB.UB_PRODUTO


cQuery += " WHERE SUB.D_E_L_E_T_ = ' '
cQuery += " AND SUB.UB_NUMPV = ' '
cQuery += " AND SUA.UA_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SUB.UB_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " AND SUA.UA_CLIENTE||SUA.UA_LOJA  BETWEEN  '" + MV_PAR05+MV_PAR06+ "' AND '" + MV_PAR07+MV_PAR08 + "' "
cQuery += " AND SA1.A1_EST  BETWEEN  '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQuery += " AND SB1.B1_COD  BETWEEN  '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
cQuery += " AND SB1.B1_GRUPO BETWEEN  '" + MV_PAR13 + "' AND '" + MV_PAR14 + "' "
cQuery += " ORDER BY SUB.R_E_C_N_O_

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	ProcRegua(	(cAliasLif)->(RecCount())) // Numero de registros a processar
	
	
	While 	(cAliasLif)->(!Eof())
		IncProc()
		dbselectarea("SUB")
		SUB->(DbGoto(	(cAliasLif)->SUBRECNO))
		If SUB->(RECNO()) == (cAliasLif)->SUBRECNO
			SUB->(RecLock("SUB",.F.))
			SUB->UB_XTABELA := '1'
			SUB->(MsUnLock())
		EndIf
		(cAliasLif)->(dbskip())
		
	End
	MsgInfo("Bloqueio Finalizado...!!!!")
EndIf

Return( )





/*====================================================================================\
|Programa  | STLIBORC         | Autor | GIOVANI.ZAGO             | Data | 12/08/2014  |
|=====================================================================================|
|Descrição | STLIBORC         Liberação de Orçamento UB_XTABELA                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STLIBORC                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STLIBORC ()
*-----------------------------*
Private cPerg 			:= "BLOQOR"
Private _cUserLib 		:= GetMv("MV_BLOQOR",,'000000')+'/000000'
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos


PutSx1(cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Orçamento:" ,"Do Orçamento: ?" ,"Do Orçamento: ?" 	   		,"mv_ch3","C",6,0,0,"G","",'SUA' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Orçamento:" ,"Ate Orçamento: ?" ,"Ate Orçamento: ?"		,"mv_ch4","C",6,0,0,"G","",'SUA' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Do Cliente:" ,"Do Cliente: ?" ,"Do Cliente: ?" 			   	,"mv_ch5","C",6,0,0,"G","",'SA1' ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Da Loja:" ,"Da Loja: ?" ,"Da Loja: ?" 			    			,"mv_ch6","C",2,0,0,"G","",' '   ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "Ate Cliente:" ,"Ate Cliente: ?" ,"Ate Cliente: ?" 				,"mv_ch7","C",6,0,0,"G","",'SA1' ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate Loja:" ,"Ate Loja: ?" ,"Ate Loja: ?" 	   					,"mv_ch8","C",2,0,0,"G","",' '   ,"","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "09", "Do Estado:" ,"Do Estado: ?" ,"Do Estado: ?" 			    	,"mv_ch9","C",2,0,0,"G","",'' ,"","","mv_par09","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "10", "Ate Estado:" ,"Ate Estado: ?" ,"Ate Estado: ?" 		        ,"mv_chA","C",2,0,0,"G","",'' ,"","","mv_par10","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "11", "Do Produto:" ,"Do Produto: ?" ,"Do Produto: ?" 			    ,"mv_chB","C",15,0,0,"G","",'SB1' ,"","","mv_par11","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "12", "Ate Produto:" ,"Ate Produto: ?" ,"Ate Produto: ?" 		        ,"mv_chC","C",15,0,0,"G","",'SB1' ,"","","mv_par12","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "13", "Do Grupo:" ,"Do Grupo: ?" ,"Do Grupo: ?" 			    		,"mv_chD","C",5,0,0,"G","",'SBM' ,"","","mv_par13","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "14", "Ate Grupo:" ,"Ate Grupo: ?" ,"Ate Grupo: ?" 		        	,"mv_chE","C",5,0,0,"G","",'SBM' ,"","","mv_par14","","","","","","","","","","","","","","","","")

If !(__cuserid $ _cUserLib)
	msgInfo("Usuario sem acesso...!!!!")
	Return()
EndIf

If Pergunte(cPerg,.T.)
	
	
	Processa({|| StQuery1( ) },"Liberando Orçamentos...!!!!!!")
	
EndIf
Return()

Static Function StQuery1()

Local cQuery     := ' '


cQuery := " SELECT
cQuery += ' SUB.R_E_C_N_O_ AS "SUBRECNO"

cQuery += " FROM "+RetSqlName("SUB")+" SUB "

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SUA")+" )SUA "
cQuery += " ON SUA.D_E_L_E_T_ = ' '
cQuery += " AND SUA.UA_NUM = SUB.UB_NUM
cQuery += " AND SUA.UA_FILIAL = SUB.UB_FILIAL

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
cQuery += " ON SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_COD = SUA.UA_CLIENTE
cQuery += " AND SUA.UA_LOJA = SA1.A1_LOJA

cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
cQuery += " ON SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_COD = SUB.UB_PRODUTO


cQuery += " WHERE SUB.D_E_L_E_T_ = ' '
cQuery += " AND SUB.UB_NUMPV = ' '
cQuery += " AND SUA.UA_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SUB.UB_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " AND SUA.UA_CLIENTE||SUA.UA_LOJA  BETWEEN  '" + MV_PAR05+MV_PAR06+ "' AND '" + MV_PAR07+MV_PAR08 + "' "
cQuery += " AND SA1.A1_EST  BETWEEN  '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQuery += " AND SB1.B1_COD  BETWEEN  '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
cQuery += " AND SB1.B1_GRUPO BETWEEN  '" + MV_PAR13 + "' AND '" + MV_PAR14 + "' "
cQuery += " ORDER BY SUB.R_E_C_N_O_

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	ProcRegua(	(cAliasLif)->(RecCount())) // Numero de registros a processar
	
	
	While 	(cAliasLif)->(!Eof())
		IncProc()
		dbselectarea("SUB")
		SUB->(DbGoto(	(cAliasLif)->SUBRECNO))
		If SUB->(RECNO()) == (cAliasLif)->SUBRECNO
			SUB->(RecLock("SUB",.F.))
			SUB->UB_XTABELA := ' '
			SUB->(MsUnLock())
		EndIf
		(cAliasLif)->(dbskip())
		
	End
	MsgInfo("Liberação Finalizada...!!!!")
EndIf

Return( )
