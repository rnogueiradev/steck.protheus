#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | M468VPED        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | CARREGAR O NOME DO CLIENTE NA SD2		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M468VPED()

Local _cQuery1 := ""

	_cQuery1 += " MERGE INTO "+RetSqlName("SD2")+" SD2
	_cQuery1 += " USING (
	_cQuery1 += " SELECT D2.R_E_C_N_O_ RECSD2, A1_NOME
	_cQuery1 += " FROM "+RetSqlName("SD2")+" D2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA
	_cQuery1 += " WHERE D2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '  
	_cQuery1 += " AND D2_XNOME=' ' 
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (SD2.R_E_C_N_O_=XXX.RECSD2)
	_cQuery1 += " WHEN MATCHED THEN UPDATE 
	_cQuery1 += " SET SD2.D2_XNOME=SUBSTR(XXX.A1_NOME,1,40)	

	TCSqlExec(_cQuery1)

Return(.T.)