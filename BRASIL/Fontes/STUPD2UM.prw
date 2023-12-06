#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STUPD2UM        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | ATUALIZAR INFORMAÇÕES DE 2 UNIDADE DE MEDIDA                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STUPD2UM(_cProduto)

	Local _cQuery1 		:= ""
	Default _cProduto 	:= ""

	_cQuery1 := " MERGE INTO "+RetSqlName("SB5")+" SB5
	_cQuery1 += " USING (
	_cQuery1 += " SELECT B1_COD, ZQ_2UM, B5_UMDIPI, B5_CONVDIP, B5.R_E_C_N_O_ RECSB5,
	_cQuery1 += " (CASE WHEN ZQ_2UM='UN' THEN 1 WHEN ZQ_2UM='KG' THEN B1_PESO END) CONV
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SZQ")+" ZQ
	_cQuery1 += " ON ZQ_NCM=B1_POSIPI
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB5")+" B5
	_cQuery1 += " ON B5_COD=B1_COD
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND ZQ.D_E_L_E_T_=' ' AND B5.D_E_L_E_T_=' '

	If !Empty(_cProduto)
		_cQuery1 += " AND B1_COD='"+_cProduto+"'
	EndIf

	_cQuery1 += " ) XXX
	_cQuery1 += " ON (SB5.R_E_C_N_O_=XXX.RECSB5)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET SB5.B5_UMDIPI=XXX.ZQ_2UM, SB5.B5_CONVDIP=XXX.CONV

	TCSqlExec(_cQuery1)

Return()