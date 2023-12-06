#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | ARFAT020        | Autor | RENATO.OLIVEIRA           | Data | 15/08/2018  |
|=====================================================================================|
|Descrição | ATUALIZAR DADOS NA SF2					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARFAT020()

	Local _cQuery1 := ""

	RpcSetType( 3 )
	RpcSetEnv("07","01",,,"FAT")

	If !LockByName("ARFAT020",.F.,.F.,.T.)
		ConOut("[ARFAT020]["+ FWTimeStamp(2) +"] Já existe uma sessão em processamento.")
		Return
	EndIf

	ConOut("[ARFAT020]["+ FWTimeStamp(2) +"] Iniciando processamento.")

	_cQuery1 := " MERGE INTO "+RetSqlName("SF2")+" SF2
	_cQuery1 += " USING (
	_cQuery1 += " SELECT RECSF2, MAX(PEDIDO) PEDIDO
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT DISTINCT XD2.D2_PEDIDO PEDIDO, F2.R_E_C_N_O_ RECSF2
	_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
	_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" XD2
	_cQuery1 += " ON XD2.D2_FILIAL=D2.D2_FILIAL AND XD2.D2_DOC=D2.D2_REMITO AND XD2.D2_CLIENTE=D2.D2_CLIENTE AND XD2.D2_LOJA=D2.D2_LOJA
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND XD2.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_SERIE='A' AND F2_XPED=' ' AND D2.D2_REMITO<>' '
	_cQuery1 += " ) YYY
	_cQuery1 += " GROUP BY RECSF2
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSF2=SF2.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET SF2.F2_XPED=XXX.PEDIDO

	TCSqlExec(_cQuery1)

	_cQuery1 := " MERGE INTO "+RetSqlName("SC5")+" SC5 "  //giovani zago esta dando erro no dbacess 26/11/18 _cQuery1 += por _cQuery1 :=
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C5.R_E_C_N_O_ RECSC5, A1_NOME
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND C5_XNOME=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (SC5.R_E_C_N_O_=XXX.RECSC5)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET SC5.C5_XNOME=SubStr(XXX.A1_NOME,1,40)

	TCSqlExec(_cQuery1)

	_cQuery1 := " MERGE INTO "+RetSqlName("SF2")+" F2
	_cQuery1 += " USING (
	_cQuery1 += " SELECT DISTINCT F2.R_E_C_N_O_ RECSF2, C9_REMITO
	_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC9")+" C9
	_cQuery1 += " ON C9_FILIAL=F2_FILIAL AND C9_CLIENTE=F2_CLIENTE AND C9_LOJA=F2_LOJA AND C9_NFISCAL=F2_DOC AND C9_SERIENF=F2_SERIE
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_SERIE='A'
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (F2.R_E_C_N_O_=XXX.RECSF2)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET F2.F2_XREMITO=XXX.C9_REMITO
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND F2_SERIE='A'

	TCSqlExec(_cQuery1)

	_cQuery1 := " MERGE INTO "+RetSqlName("SF1")+" F1
	_cQuery1 += " USING (
	_cQuery1 += " SELECT F1.R_E_C_N_O_ RECSF1, F1_XNOME, CASE WHEN F1_TIPO IN ('N','C') THEN A2_NOME ELSE A1_NOME END NOME
	_cQuery1 += " FROM "+RetSqlName("SF1")+" F1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND F1_TIPO IN ('D') AND A1.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" A2
	_cQuery1 += " ON A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND F1_TIPO IN ('N','C') AND A2.D_E_L_E_T_=' '
	_cQuery1 += " WHERE F1.D_E_L_E_T_=' ' AND F1_XNOME=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSF1=F1.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET F1.F1_XNOME=XXX.NOME
	_cQuery1 += " WHERE F1.D_E_L_E_T_=' ' AND F1_XNOME=' '

	TCSqlExec(_cQuery1)


	//>> ticket 20190513000041 - Everson Santana - 14.06.19

	_cQuery1 := " MERGE INTO SF2070 SF2
	_cQuery1 += " USING (
	_cQuery1 += " SELECT RECSF2, MAX(C5_XOBS) C5_XOBS
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT DISTINCT XD2.D2_PEDIDO PEDIDO, F2.R_E_C_N_O_ RECSF2, utl_raw.cast_to_varchar2(dbms_lob.substr(C5.C5_XOBS)) C5_XOBS
	_cQuery1 += " FROM SF2070 F2
	_cQuery1 += " LEFT JOIN SD2070 D2
	_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
	_cQuery1 += " LEFT JOIN SD2070 XD2
	_cQuery1 += " ON XD2.D2_FILIAL=D2.D2_FILIAL AND XD2.D2_DOC=D2.D2_DOC AND XD2.D2_CLIENTE=D2.D2_CLIENTE AND XD2.D2_LOJA=D2.D2_LOJA
	_cQuery1 += " LEFT JOIN SC5070 C5
	_cQuery1 += " ON C5.C5_FILIAL = D2.D2_FILIAL AND C5.C5_NUM = D2.D2_PEDIDO  AND C5.D_E_L_E_T_ = ' '
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND XD2.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_SERIE='R'
	_cQuery1 += " AND F2_XNORC=' '
	_cQuery1 += " AND C5.C5_XOBS IS NOT NULL
	_cQuery1 += " ) YYY
	_cQuery1 += " GROUP BY RECSF2
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSF2=SF2.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET SF2.F2_XOBSPED = Substr(XXX.C5_XOBS,1,254)

	TCSqlExec(_cQuery1)

	_cQuery1 := " MERGE INTO SF2070 SF2
	_cQuery1 += " USING (
	_cQuery1 += " SELECT RECSF2, MAX(C5_XNORC) C5_XNORC
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT DISTINCT XD2.D2_PEDIDO PEDIDO, F2.R_E_C_N_O_ RECSF2, C5.C5_XNORC
	_cQuery1 += " FROM SF2070 F2
	_cQuery1 += " LEFT JOIN SD2070 D2
	_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
	_cQuery1 += " LEFT JOIN SD2070 XD2
	_cQuery1 += " ON XD2.D2_FILIAL=D2.D2_FILIAL AND XD2.D2_DOC=D2.D2_DOC AND XD2.D2_CLIENTE=D2.D2_CLIENTE AND XD2.D2_LOJA=D2.D2_LOJA
	_cQuery1 += " LEFT JOIN SC5070 C5
	_cQuery1 += " ON C5.C5_FILIAL = D2.D2_FILIAL AND C5.C5_NUM = D2.D2_PEDIDO  AND C5.D_E_L_E_T_ = ' '
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND XD2.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_SERIE='R'
	_cQuery1 += " AND F2_XNORC=' '
	_cQuery1 += " AND C5.C5_XNORC <> ' '
	_cQuery1 += " ) YYY
	_cQuery1 += " GROUP BY RECSF2
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSF2=SF2.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE
	_cQuery1 += " SET SF2.F2_XNORC = XXX.C5_XNORC

	TCSqlExec(_cQuery1)

	//<<
	UnLockByName("ARFAT020",.F.,.F.,.T.)

	ConOut("[ARFAT020]["+ FWTimeStamp(2) +"] Processamento finalizado.")

Return()