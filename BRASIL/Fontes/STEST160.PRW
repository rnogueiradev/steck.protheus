#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STEST160         | Autor | Renato Nogueira            | Data | 21/09/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST160()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1	:= ""

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM PA2010 PA2
	_cQuery1 += " WHERE D_E_L_E_T_=' ' AND PA2_FILRES='02' AND PA2_QUANT>0 AND PA2_TIPO='1'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	DbSelectArea("PA2")
	DbSelectArea("PA1")
	PA1->(DbSetOrder(2))

	While (_cAlias1)->(!Eof())

		PA2->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		If PA1->(DbSeek(PA2->PA2_FILRES+"1"+PA2->PA2_DOC))
			PA1->(RecLock("PA1",.F.))
			PA1->(DbDelete())
			PA1->(MsUnLock())
		EndIf

		If PA2->(!Eof())
			PA2->(RecLock("PA2",.F.))
			PA2->PA2_OBS  := 'AJUSTE TI '+ DTOC(DATE())+ ' - '+TIME()
			PA2->(DbDelete())
			PA2->(MsUnlock())
		EndIf

		PA1->(RecLock('PA1',.T.))
		PA1->PA1_FILIAL		:= (_cAlias1)->PA2_FILRES
		PA1->PA1_CODPRO		:= (_cAlias1)->PA2_CODPRO
		PA1->PA1_DOC		:= (_cAlias1)->PA2_DOC
		PA1->PA1_TIPO		:= '1'
		PA1->PA1_QUANT		:= (_cAlias1)->PA2_QUANT
		PA1->PA1_OBS		:= 'AJUSTE TI '+ DTOC(DATE())+ ' - '+TIME()
		PA1->(MsUnlock())

		(_cAlias1)->(DbSkip())
	EndDo

	Reset Environment

Return()

/*====================================================================================\
|Programa  | STEST160         | Autor | Renato Nogueira            | Data | 21/09/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST161()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1	:= ""

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cFa10Oper    :=  GetMv("ST_FAOPER",,'74')

	_cQuery1 += " SELECT * 
	_cQuery1 += " FROM ( 
	_cQuery1 += " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN-C6_QTDENT SALDO, 
	_cQuery1 += " NVL(SUM(PA2_QUANT),0) RESERVA, 
	_cQuery1 += " NVL(SUM(PA1_QUANT),0) FALTA, 
	_cQuery1 += " NVL(SUM(DC_QUANT),0) EMPENHO 
	_cQuery1 += " FROM SC5010 C5 
	_cQuery1 += " LEFT JOIN SC6010 C6 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM 
	_cQuery1 += " LEFT JOIN SF4010 F4 ON F4_CODIGO=C6_TES 
	_cQuery1 += " LEFT JOIN PA2010 PA2 ON PA2_DOC=C6_NUM||C6_ITEM AND PA2_FILRES=C6_FILIAL AND PA2.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN PA1010 PA1 ON PA1_DOC=C6_NUM||C6_ITEM AND PA1_FILIAL=C6_FILIAL AND PA1.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN SDC010 DC ON DC_FILIAL=C6_FILIAL AND DC_PEDIDO=C6_NUM AND DC_ITEM=C6_ITEM AND DC.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE C6.D_E_L_E_T_=' ' AND F4.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' '  AND C5_FILIAL='02' AND C6_QTDVEN-C6_QTDENT>0 
	_cQuery1 += " AND C6_BLQ=' '  AND F4_ESTOQUE='S' AND C6_OPER NOT LIKE '"+_cFa10Oper+"'"
	_cQuery1 += " AND C5_EMISSAO>='"+DTOS(MonthSub(Date(),6))+"' AND SUBSTR(C5_NOTA,1,1)<>'X' 
	_cQuery1 += " GROUP BY C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN-C6_QTDENT
	_cQuery1 += " ) XXX 
	_cQuery1 += " WHERE SALDO-EMPENHO<>RESERVA+FALTA

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	DbSelectArea("PA2")
	PA2->(DbSetOrder(2)) //PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES
	DbSelectArea("PA1")
	PA1->(DbSetOrder(2)) //PA1_FILIAL+PA1_TIPO+PA1_DOC+PA1_CODPRO

	While (_cAlias1)->(!Eof())
		
		If PA2->(DbSeek("  "+"1"+PADR((_cAlias1)->(C6_NUM+C6_ITEM),11)+(_cAlias1)->(C6_PRODUTO+C6_FILIAL)))
			While PA2->(!Eof()) .And. PA2->(PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES)==;
			"  "+"1"+PADR((_cAlias1)->(C6_NUM+C6_ITEM),11)+(_cAlias1)->(C6_PRODUTO+C6_FILIAL)
				PA2->(RecLock("PA2",.F.))
				PA2->(DbDelete())
				PA2->(MsUnLock())
				PA2->(DbSkip())
			EndDo
		EndIf
		If PA1->(DbSeek((_cAlias1)->C6_FILIAL+"1"+PADR((_cAlias1)->(C6_NUM+C6_ITEM),11)+(_cAlias1)->(C6_PRODUTO)))
			While PA1->(!Eof()) .And. PA1->(PA1_FILIAL+PA1_TIPO+PA1_DOC+PA1_CODPRO)==;
			(_cAlias1)->C6_FILIAL+"1"+PADR((_cAlias1)->(C6_NUM+C6_ITEM),11)+(_cAlias1)->(C6_PRODUTO)
				PA1->(RecLock("PA1",.F.))
				PA1->(DbDelete())
				PA1->(MsUnLock())
				PA1->(DbSkip())
			EndDo
		EndIf

		PA1->(RecLock('PA1',.T.))
		PA1->PA1_FILIAL		:= (_cAlias1)->C6_FILIAL
		PA1->PA1_CODPRO		:= (_cAlias1)->C6_PRODUTO
		PA1->PA1_DOC		:= (_cAlias1)->(C6_NUM+C6_ITEM)
		PA1->PA1_TIPO		:= '1'
		PA1->PA1_QUANT		:= (_cAlias1)->(SALDO-EMPENHO)
		PA1->PA1_OBS		:= 'AJUSTE TI '+ DTOC(DATE())+ ' - '+TIME()
		PA1->(MsUnlock())

		(_cAlias1)->(DbSkip())
	EndDo

Return

/*====================================================================================\
|Programa  | STEST160         | Autor | Renato Nogueira            | Data | 21/09/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST162()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1	:= ""

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 += " Select pa1_filial, pa1_doc, count(*)
_cQuery1 += " from pa1010 pa1
_cQuery1 += " where d_e_l_e_t_=' ' and pa1_filial='02' and pa1_tipo='1'
_cQuery1 += " group by pa1_filial, pa1_doc
_cQuery1 += " having count(*) > 1

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	DbSelectArea("PA1")
	PA1->(DbSetOrder(2))

	While (_cAlias1)->(!Eof())

		If PA1->(DbSeek((_cAlias1)->pa1_filial+"1"+(_cAlias1)->(pa1_doc)))
			PA1->(RecLock("PA1",.F.))
			PA1->(DbDelete())
			PA1->(MsUnLock())
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return
