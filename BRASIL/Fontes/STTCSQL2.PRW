#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"

/*====================================================================================\
|Programa  | STTCSQL           | Autor | GIOVANI.ZAGO          | Data | 23/05/2018    |
|=====================================================================================|
|Descrição | UPDATES GERAL								                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTCSQL	                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------*
User Function STTCSQL2()
*-------------------------------*
	Local cQry:= ' '

	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	cQry := " DELETE FROM PA2110 WHERE D_E_L_E_T_<>' ' 
	TcSQLExec(cQry)

	cQry := " DELETE FROM PA1110 WHERE D_E_L_E_T_<>' ' 
	TcSQLExec(cQry)

	cQry := " DELETE FROM SC9110 WHERE D_E_L_E_T_<>' ' 
	TcSQLExec(cQry)

	cQry := " UPDATE SC5110 SET C5_ZBLOQ='2', C5_ZMOTBLO=' ' WHERE SC5110.D_E_L_E_T_=' ' AND SUBSTR(C5_NOTA,1,1)='X' AND C5_ZBLOQ='1'
	TcSQLExec(cQry)

	cQry := " UPDATE SC5110 SET C5_ZBLOQ='2', C5_ZMOTBLO=' ' WHERE SC5110.D_E_L_E_T_=' ' AND C5_ZFATBLQ='1' AND C5_ZBLOQ='1'
	TcSQLExec(cQry)

	cQry := " UPDATE SB2110 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
	TcSQLExec(cQry)

	cQry := " UPDATE SB2110 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
	TcSQLExec(cQry)

	//20220525010931
	cQry := " MERGE INTO SC5110
	cQry += " USING (
	cQry += " SELECT DISTINCT C5_NUM, RESTOT , E4_XVLRMIN, SC5110.R_E_C_N_O_ RECSC5
	cQry += " FROM SC5110
	cQry += " LEFT JOIN SC6110
	cQry += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	cQry += " LEFT JOIN(
	cQry += " SELECT PA2_FILRES, SUBSTR(PA2_DOC,1,6) PED, SUM( ( C6_ZVALLIQ / C6_QTDVEN ) *PA2_QUANT ) RESTOT
	cQry += " FROM PA2110
	cQry += " LEFT JOIN SC6110
	cQry += " ON C6_FILIAL=PA2_FILRES AND C6_NUM||C6_ITEM=PA2_DOC
	cQry += " WHERE PA2110.D_E_L_E_T_=' ' AND SC6110.D_E_L_E_T_=' '
	cQry += " AND PA2_FILRES='01' AND PA2_TIPO='1'
	cQry += " GROUP BY PA2_FILRES,SUBSTR(PA2_DOC,1,6)
	cQry += " ) PA2TOT
	cQry += " ON C6_FILIAL=PA2TOT.PA2_FILRES AND PA2TOT.PED=C6_NUM
	cQry += " LEFT JOIN SE4110
	cQry += " ON E4_CODIGO=C5_CONDPAG AND SE4110.D_E_L_E_T_=' '
	cQry += " WHERE SC5110.D_E_L_E_T_=' ' AND SC6110.D_E_L_E_T_=' '
	cQry += " AND SC6110.C6_CF IN ('5101','5102','5116','5122','5123','5401','5403','5405','5501','5551','5922','6101','6102','6107','6108','6109','6110','6116','6118','6119','6122','6123','6401','6403','6404','6551','6922','7101','7102')
	cQry += " AND C6_FILIAL='01'
	cQry += " AND C5_XTRONF=' '
	cQry += " AND C6_QTDVEN-C6_QTDENT>0
	cQry += " AND C6_BLQ=' '
	cQry += " AND C5_XBLQFMI='S'
	cQry += " AND PA2TOT.RESTOT>E4_XVLRMIN
	cQry += " AND PA2TOT.RESTOT>300
	cQry += " AND C5_TIPOCLI<>'X'
	cQry += " ) XXX
	cQry += " ON (XXX.RECSC5=SC5110.R_E_C_N_O_)
	cQry += " WHEN MATCHED THEN UPDATE
	cQry += " SET SC5110.C5_XBLQFMI='N'
	TcSQLExec(cQry)

Return()


/*====================================================================================\
|Programa  | STA1XPORT           | Autor | FLÁVIA ROCHA        | Data | 25/03/2022    |
|=====================================================================================|
|Descrição | Realiza verificação nas tabelas SZR e Z79 , dos CNPJs de clientes        |
|          | Que utilizam o Portal, e atualiza no cadastro de clientes SA1            |
|          | o campo A1_XPORTAL para ficar = S (Sim)                                  |
|=====================================================================================|
|Sintaxe   | STA1XPORT	                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User Function STA1XPORT()


If Select( 'SX2' ) == 0

  	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	fSZR()

	fZ79()

	Reset environment

Else 
	Processa( {|| MsAguarde({|| fSZR() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gravando A1_XPORTAL..." ) ) } )

	Processa( {|| MsAguarde({|| fZ79() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gravando A1_XPORTAL..." ) ) } )
	MsgInfo("Processo Finalizado OK")

Endif 

Return


Static Function fSZR()
Local cQuery  := ""
Local _cAlias2:= GetNextAlias()	
Local cCodcli := ""
Local cLojcli := ""

/*
SELECT *
FROM SZR110 ZR
WHERE ZR.D_E_L_E_T_=' ';

 

SELECT *
FROM Z79110 Z79
WHERE Z79.D_E_L_E_T_=' ';
*/

//SZR

cQuery := " SELECT ZR_LOGIN, ZR_CODIGO, ZR_LOJA , ZR_NOME "
cQuery += " FROM "+RetSqlName("SZR")+" SZR "
cQuery += " WHERE SZR.D_E_L_E_T_=' ' "


MemoWrite("C:\TEMP\fQrySZR.TXT" , cQuery)

If !Empty(Select(_cAlias2))
	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias2,.T.,.T.)
dbSelectArea(_cAlias2)
(_cAlias2)->(dbGoTop())

If (_cAlias2)->(!Eof())

	While (_cAlias2)->(!Eof())
		cCodcli := (_cAlias2)->ZR_CODIGO
		cLojcli := (_cAlias2)->ZR_LOJA
	
		//localiza no cadastro cliente se existe este código/loja
		DbSelectArea("SA1")
		SA1->(OrdSetFocus(1))
		If SA1->(Dbseek(xFilial("SA1") + cCodcli + cLojcli ))
			Reclock("SA1" , .F.)
			SA1->A1_XPORTAL := "S"
			SA1->(MsUnlock())
		Endif 

		DbSelectArea(_cAlias2)
		(_cAlias2)->(Dbskip())
	Enddo

	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())

EndIf


Return()



Static Function fZ79()
Local cQuery  := ""
Local _cAlias2:= GetNextAlias()	
Local cCnpj   := ""
//Local nRecSA1 := 0

/*
SELECT *
FROM SZR110 ZR
WHERE ZR.D_E_L_E_T_=' ';

 

SELECT *
FROM Z79110 Z79
WHERE Z79.D_E_L_E_T_=' ';
*/

//SZR
cQuery := " SELECT Z79_CNPJS "
cQuery += " FROM "+RetSqlName("Z79")+" Z79 "
cQuery += " WHERE Z79.D_E_L_E_T_=' ' "

MemoWrite("C:\TEMP\fQryZ79.TXT" , cQuery)

If !Empty(Select(_cAlias2))
	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias2,.T.,.T.)
dbSelectArea(_cAlias2)
(_cAlias2)->(dbGoTop())

If (_cAlias2)->(!Eof())
	While (_cAlias2)->(!Eof())

		cCnpj := (_cAlias2)->Z79_CNPJS
	
	
		//localiza no cadastro cliente se existe este código/loja
		DbSelectArea("SA1")
		SA1->(OrdSetFocus(3))
		If SA1->(Dbseek(xFilial("SA1") + cCnpj ))  //procura o cnpj inteiro
			Reclock("SA1" , .F.)
			SA1->A1_XPORTAL := "S"
			SA1->(MsUnlock())
		
		Endif
		DbSelectArea(_cAlias2)
		(_cAlias2)->(Dbskip()) 

	Enddo

	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())

EndIf


Return()





