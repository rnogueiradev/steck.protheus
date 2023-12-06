#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT500        | Autor | RENATO.OLIVEIRA           | Data | 17/04/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT500()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	//Desativado pois está fazendo no STSQLCOM.PRW
	Return

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STFAT500",.F.,.F.,.T.)
		ConOut("[STFAT500]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT500]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	//20210215002560 - ajuste de fat min
	cQry := " MERGE INTO SC5010 C5
	cQry += " USING (
	cQry += " SELECT *
	cQry += " FROM (
	cQry += " SELECT C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XBLQFMI, C5.R_E_C_N_O_, NVL(SUM(PA2_QUANT*C6_PRCVEN),0) RESERVA
	cQry += " FROM SC5010 C5
	cQry += " LEFT JOIN SC6010 C6
	cQry += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	cQry += " LEFT JOIN SA1010 A1
	cQry += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	cQry += " LEFT JOIN PA2010 PA2
	cQry += " ON PA2_FILRES=C5_FILIAL AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' '
	cQry += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	cQry += " AND C5_FILIAL='02' AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X' AND C5_TIPO='N' 
	cQry += " AND C5_XBLQFMI='S' AND A1_ATIVIDA<>'D3'
	cQry += " GROUP BY C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XBLQFMI, C5.R_E_C_N_O_
	cQry += " ) XXX
	cQry += " WHERE C5_TPFRETE='C' AND (C5_TRANSP='000163' OR C5_TRANSP='000001') AND RESERVA>1000
	cQry += " ) ZZZ
	cQry += " ON (ZZZ.R_E_C_N_O_=C5.R_E_C_N_O_)
	cQry += " WHEN MATCHED THEN UPDATE SET 
	cQry += " C5_XBLQFMI='N'
	TcSQLExec(cQry)

	//20210217002662 - ajuste parcial
	cQry := " SELECT *
	cQry += " FROM (
	cQry += " SELECT C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XTIPF, C5.R_E_C_N_O_ RECSC5, NVL(SUM(PA2_QUANT*C6_PRCVEN),0) RESERVA
	cQry += " FROM SC5010 C5
	cQry += " LEFT JOIN SC6010 C6
	cQry += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	cQry += " LEFT JOIN SA1010 A1
	cQry += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	cQry += " LEFT JOIN PA2010 PA2
	cQry += " ON PA2_FILRES=C5_FILIAL AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' '
	cQry += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	cQry += " AND C5_FILIAL='02' AND C5_ZFATBLQ<>'1' AND SUBSTR(C5_NOTA,1,1)<>'X' AND C5_TIPO='N' 
	cQry += " AND C5_XTIPF='1' AND A1_ATIVIDA<>'D3'
	cQry += " GROUP BY C5_FILIAL, C5_NUM, C5_TPFRETE, C5_TRANSP, C5_XTIPF, C5.R_E_C_N_O_
	cQry += " ) XXX
	cQry += " WHERE C5_TPFRETE='C' AND (C5_TRANSP='000163' OR C5_TRANSP='000001') AND RESERVA>1000

	_cAlias1 := GetNextAlias()

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC5")

	While (_cAlias1)->(!Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
		If SC5->(!Eof())
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XTIPF := "2"
			SC5->(MsUnLock())
			U_STGrvSt(SC5->C5_NUM,Nil)
		EndIf

		(_cAlias1)->(DbSkip())	
	EndDo

	UnLockByName("STFAT500",.F.,.F.,.T.)
	
	ConOut("[STFAT500]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment

Return()
