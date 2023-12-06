#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | M462NFLT        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ATUALIZAR DADOS NA SC9					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M462NFLT()

	Local aArea 	:= GetArea()
	Local _cQuery1 := ""
	Local _cQuery2 := ""
	Local _cQuery3 := ""
	Local cAlias1	:= "QRY"

	_cQuery1 += " MERGE INTO "+RetSqlName("SC9")+" SC9
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C9.R_E_C_N_O_ RECSC9, A1_NOME
	_cQuery1 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=C9_CLIENTE AND A1_LOJA=C9_LOJA
	_cQuery1 += " WHERE C9.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND C9_XNOME=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (SC9.R_E_C_N_O_=XXX.RECSC9)
	_cQuery1 += " WHEN MATCHED THEN
	_cQuery1 += " UPDATE SET
	_cQuery1 += " C9_XNOME=A1_NOME

	TCSqlExec(_cQuery1)

	_cQuery2 += " MERGE INTO "+RetSqlName("SC9")+" SC9
	_cQuery2 += " USING (
	_cQuery2 += " SELECT C9.R_E_C_N_O_ RECSC9, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(C5_XOBS,250)),' ') C5_XOBS
	_cQuery2 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery2 += " LEFT JOIN "+RetSqlName("SC5")+" C5
	_cQuery2 += " ON C5_NUM=C9_PEDIDO
	_cQuery2 += " WHERE C9.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' '
	_cQuery2 += " AND C9_XOBS =' '
	_cQuery2 += " ) XXX
	_cQuery2 += " ON (SC9.R_E_C_N_O_=XXX.RECSC9)
	_cQuery2 += " WHEN MATCHED THEN
	_cQuery2 += " UPDATE SET
	_cQuery2 += " C9_XOBS=C5_XOBS

	TCSqlExec(_cQuery2)

	//>> Ticket 20190716000017 - Everson Santana - 19072019
	_cQuery3 := " SELECT R_E_C_N_O_ C9RECNO,C9_FILIAL,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO,C9_REMITO,C9_LOCAL,C9_XSALDO FROM "+RetSqlName("SC9")+" WHERE C9_REMITO = ' ' AND D_E_L_E_T_ = ' ' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	While !EOF()

		DbSelectArea("SC9")
		DbGotop()
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+(cAlias1)->(C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO))

			If SC9->(DBRLock((cAlias1)->C9RECNO))

				SC9->(RecLock("SC9",.F.))

				SC9->C9_XSALDO	:= u_STARGSAL((cAlias1)->C9_PRODUTO,(cAlias1)->C9_LOCAL)

				SC9->(MsUnLock())

			EndIf

		EndIF
		(cAlias1)->(dbSkip())

	End
	//<< Ticket 20190716000017

Return("")