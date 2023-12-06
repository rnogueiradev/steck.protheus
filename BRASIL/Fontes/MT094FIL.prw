#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*====================================================================================\
|Programa  | MT094FIL         | Autor | Renato Nogueira            | Data | 13/12/2018|
|=====================================================================================|
|Descrição | Filtro na liberação de documentos                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                       |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT094FIL()

	Local cRet 		:= ""
	Local _cQuery	:= ""

	_cQuery := " MERGE INTO "+RetSqlName("SCR")+" CR
	_cQuery += " USING (
	_cQuery += " SELECT CR.R_E_C_N_O_ RECSCR, MAX(C7_MOTIVO) MOTIVO
	_cQuery += " FROM "+RetSqlName("SCR")+" CR
	_cQuery += " LEFT JOIN "+RetSqlName("SC7")+" C7
	_cQuery += " ON C7_FILIAL=CR_FILIAL AND CR_NUM=C7_NUM
	_cQuery += " WHERE CR.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' ' AND CR_TIPO='PC' AND CR_XMOTIVO=' '
	_cQuery += " GROUP BY CR.R_E_C_N_O_
	_cQuery += " ) XXX
	_cQuery += " ON (XXX.RECSCR=CR.R_E_C_N_O_)
	_cQuery += " WHEN MATCHED THEN UPDATE
	_cQuery += " SET CR.CR_XMOTIVO=XXX.MOTIVO
	_cQuery += " WHERE CR.D_E_L_E_T_=' ' AND CR_TIPO='PC' AND CR_XMOTIVO=' '

	TCSqlExec(_cQuery)

	If __cUserId $ GetMv("ST_USRCOM",,"000527#000010")
		cRet :=  " CR_TIPO  == 'PC' .And. !AllTrim(CR_XMOTIVO) $ 'MRP,NPM,NPS,SAO,SSM,SSP' "
	Else
		cRet :=  " !Empty(CR_NUM)
	EndIf

Return(cRet)