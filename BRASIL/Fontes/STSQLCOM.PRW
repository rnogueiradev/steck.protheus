#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"

/*====================================================================================\
|Programa  | STSQLCOM          | Autor | RENATO.OLIVEIRA       | Data | 11/08/2021    |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSQLCOM()

	Local cQry := ''

	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	If dow(date()) = 1  .And. dow(date()) = 7 //domingo ---- sabado
		Return()
	EndIf

	ConOut("[STSQLCOM]["+ FWTimeStamp(2) +"] - Iniciando processamento.")

	//Acordado com Tereza Mello em 11/08/2021

	cQry := " MERGE INTO SC5110 C5
	cQry += " USING (
	cQry += " SELECT *
	cQry += " FROM (
	cQry += " SELECT C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XBLQFMI, C5.R_E_C_N_O_, NVL(SUM(PA2_QUANT*C6_PRCVEN),0) RESERVA
	cQry += " FROM SC5110 C5
	cQry += " LEFT JOIN SC6110 C6
	cQry += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	cQry += " LEFT JOIN SA1110 A1
	cQry += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	cQry += " LEFT JOIN PA2110 PA2
	cQry += " ON PA2_FILRES=C5_FILIAL AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' '
	cQry += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	cQry += " AND C5_FILIAL='01' AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X' AND C5_TIPO='N' 
	cQry += " AND C5_XBLQFMI='S' AND A1_GRPVEN<>'D3' AND C5_XALERTF=' ' 
	cQry += " GROUP BY C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XBLQFMI, C5.R_E_C_N_O_
	cQry += " ) XXX
	cQry += " WHERE C5_TPFRETE='C' AND RESERVA>1500
	cQry += " ) ZZZ
	cQry += " ON (ZZZ.R_E_C_N_O_=C5.R_E_C_N_O_)
	cQry += " WHEN MATCHED THEN UPDATE SET 
	cQry += " C5_XBLQFMI='N'
	TcSQLExec(cQry)

	cQry := " SELECT *
	cQry += " FROM (
	cQry += " SELECT C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XTIPF, C5.R_E_C_N_O_ RECSC5, NVL(SUM(PA2_QUANT*C6_PRCVEN),0) RESERVA
	cQry += " FROM SC5110 C5
	cQry += " LEFT JOIN SC6110 C6
	cQry += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	cQry += " LEFT JOIN SA1110 A1
	cQry += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	cQry += " LEFT JOIN PA2110 PA2
	cQry += " ON PA2_FILRES=C5_FILIAL AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' '
	cQry += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	cQry += " AND C5_FILIAL='01' AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X' AND C5_TIPO='N' 
	cQry += " AND C5_XTIPF='1' AND A1_GRPVEN<>'D3' AND C5_XALERTF=' ' 
	cQry += " GROUP BY C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XTIPF, C5.R_E_C_N_O_
	cQry += " ) XXX
	cQry += " WHERE C5_TPFRETE='C' AND RESERVA>1500

	_cAlias1 := GetNextAlias()

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC5")

	While !(_cAlias1)->(Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
		If SC5->(!Eof())
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XTIPF := "2"
			SC5->(MsUnLock())
			U_STGrvSt(SC5->C5_NUM,Nil)
		EndIf

		(_cAlias1)->(DbSkip())	
	EndDo

	ConOut("[STSQLCOM]["+ FWTimeStamp(2) +"] - Processamento finalizado.")

Return()

