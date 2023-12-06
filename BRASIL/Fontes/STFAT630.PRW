#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT630        | Autor | RENATO.OLIVEIRA           | Data | 27/01/2023  |
|=====================================================================================|
|Descrição | Limpar SC6, Z96 e voltar saldo PA1 da oferta logistica					  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT630(_cProduto,_cPedido)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Default _cPedido := ""

	DbSelectArea("Z96")
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	DbSelectArea("PA1")
	PA1->(DbSetOrder(2)) //PA1_FILIAL+PA1_TIPO+PA1_DOC+PA1_CODPRO

	//Deletar Z96
	_cQuery1 := " SELECT Z96.R_E_C_N_O_ RECZ96
	_cQuery1 += " FROM "+RetSqlName("Z96")+" Z96
	_cQuery1 += " WHERE Z96.D_E_L_E_T_=' ' AND Z96_PROD='"+_cProduto+"'

	If !Empty(_cPedido)
		_cQuery1 += " AND Z96_PA1DOC='"+_cPedido+"'
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
		
	While (_cAlias1)->(!Eof())

		Z96->(DbGoTo((_cAlias1)->RECZ96))
		If Z96->(!Eof())
			
            IF Z96->Z96_TIPREG=='PO'
               ZA6->(DBSETORDER(2))
			   IF ZA6->(DBSEEK(XFILIAL("ZA6")+Z96->Z96_PEDCOM+Z96->Z96_ITECOM+Z96->Z96_PROD))
			      ZA6->(RECLOCK('ZA6',.F.))
				  IF ZA6->ZA6_CONSUM>=Z96->Z96_QTDATE 
				     ZA6->ZA6_CONSUM-=Z96->Z96_QTDATE 
				  ELSE 
				     ZA6->ZA6_CONSUM:=0
				  ENDIF	 
				  ZA6->(MSUNLOCK('ZA6'))
			   ENDIF 	  
            ENDIF

			Z96->(RecLock("Z96",.F.))
			Z96->(DbDelete())
			Z96->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	//Deletar PA1
	_cQuery1 := " SELECT PA1.R_E_C_N_O_ RECPA1
	_cQuery1 += " FROM "+RetSqlName("PA1")+" PA1
	_cQuery1 += " WHERE PA1.D_E_L_E_T_=' ' AND PA1_CODPRO='"+_cProduto+"'

	If !Empty(_cPedido)
		_cQuery1 += " AND PA1_DOC='"+_cPedido+"'
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
		
	While (_cAlias1)->(!Eof())

		PA1->(DbGoTo((_cAlias1)->RECPA1))
		If PA1->(!Eof())
			
			PA1->(RecLock("PA1",.F.))
			PA1->PA1_SALDO := PA1->PA1_QUANT
			PA1->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo	

	//Deletar SC6
	_cQuery1 := " SELECT SC6.R_E_C_N_O_ RECSC6
	_cQuery1 += " FROM "+RetSqlName("SC6")+" SC6
	_cQuery1 += " WHERE SC6.D_E_L_E_T_=' ' AND C6_PRODUTO='"+_cProduto+"'

	If !Empty(_cPedido)
		_cQuery1 += " AND C6_NUM||C6_ITEM='"+_cPedido+"'
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
		
	While (_cAlias1)->(!Eof())

		SC6->(DbGoTo((_cAlias1)->RECSC6))
		If SC6->(!Eof())
			
			SC6->(RecLock("SC6",.F.))
			SC6->C6_ZENTRE2 := CTOD("")
			SC6->(MsUnLock())
			
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo	

Return()

/*====================================================================================\
|Programa  | STFAT630        | Autor | RENATO.OLIVEIRA           | Data | 27/01/2023  |
|=====================================================================================|
|Descrição | Limpar SC6, Z96 e voltar saldo PA1 da oferta logistica					  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT631(_cDocOri,_cDocDest,_cProd,_nQuant,_cTipo)

	DbSelectArea("Z9D")

	Z9D->(RecLock("Z9D",.T.))
	Z9D->Z9D_FILIAL := cFilAnt
	Z9D->Z9D_PEDIDO := SubStr(_cDocOri,1,6)
	Z9D->Z9D_ITEM   := SubStr(_cDocOri,7,2)
	Z9D->Z9D_PROD   := _cProd
	Z9D->Z9D_TIPO   := _cTipo
	Z9D->Z9D_QUANT  := _nQuant
	Z9D->Z9D_USER   := cUserName
	Z9D->Z9D_DATA   := Date()
	Z9D->Z9D_HORA   := Time()
	Z9D->Z9D_PED1   := SubStr(_cDocDest,1,6)
	Z9D->Z9D_ITEM1  := SubStr(_cDocDest,7,2)
	Z9D->(MsUnLock(()))

Return()
