#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function GerPA1Pr(cProduto)

Local cQuery 	:= ""
Local cAlias22 	:= "QRYTEMP"
Local aAreaPA1
Local aArea22           
Local aProds	:= {}
Local nI := 0
If cFilAnt="02"
	
	cQuery := " SELECT C6_FILIAL, C6_NUM, C6_ITEM,C6_PRODUTO,C6_ENTRE1,C6_QTDVEN,C6_QTDENT,C6_QTDVEN-C6_QTDENT AS SALDO_PV, "
	cQuery += " NVL(PA1_QUANT,0) AS FALTAS, NVL(PA2_QUANT,0) AS RESERVAS ,NVL(C9_QTDLIB,0) NO_SC9 , "
	cQuery += " (C6_QTDVEN-C6_QTDENT) -  ( NVL(PA1_QUANT,0) + NVL(PA2_QUANT,0) + NVL(C9_QTDLIB,0) ) AS DIFERENCA "
	cQuery += " FROM SC6010 "
	cQuery += " LEFT JOIN SF4010 ON F4_FILIAL = ' '        AND F4_CODIGO = C6_TES AND SF4010.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN PA1010 ON PA1_FILIAL = C6_FILIAL AND PA1_DOC   = C6_NUM||C6_ITEM AND PA1010.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN PA2010 ON PA2_FILIAL = ' '       AND PA2_DOC   = C6_NUM||C6_ITEM AND PA2010.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SC9010 ON C9_FILIAL = C6_FILIAL  AND C9_PEDIDO||C9_ITEM  = C6_NUM||C6_ITEM AND SC9010.D_E_L_E_T_ = ' '  AND SC9010.C9_ORDSEP <> ' ' "
	cQuery += " WHERE C6_QTDVEN - C6_QTDENT  > 0 AND C6_BLQ = ' ' AND C6_ENTRE1 >= '20130401' AND SC6010.D_E_L_E_T_ = ' ' AND F4_ESTOQUE ='S' "
	If !Empty(cProduto)
	cQuery += " AND C6_PRODUTO='"+cProduto+"' "
	EndIf
	cQuery += " AND C6_FILIAL = '02' AND (C6_QTDVEN-C6_QTDENT) -  (NVL(PA1_QUANT,0) + NVL(PA2_QUANT,0) + NVL(C9_QTDLIB,0) ) > 0 "
	cQuery += " ORDER BY C6_PRODUTO "
	
	If !Empty(Select(cAlias22))
		DbSelectArea(cAlias22)
		(cAlias22)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias22,.T.,.T.)
	
	dbSelectArea(cAlias22)
	(cAlias22)->(dbGoTop())
	
	While (cAlias22)->(!Eof())
		
		DbSelectArea("PA1")
		PA1->(DbGoTop())
		PA1->(DbSetOrder(3))
		PA1->(DbSeek((cAlias22)->C6_FILIAL+(cAlias22)->C6_NUM+(cAlias22)->C6_ITEM+"   "+(cAlias22)->C6_PRODUTO))
		
		If !PA1->(Eof())
			
			PA1->(RecLock("PA1",.F.))
			PA1->PA1_QUANT	+= (cAlias22)->DIFERENCA
			PA1->(MsUnlock())
			
		Else
			
			PA1->(RecLock("PA1",.T.))
			PA1->PA1_FILIAL	:= (cAlias22)->C6_FILIAL
			PA1->PA1_CODPRO	:= (cAlias22)->C6_PRODUTO
			PA1->PA1_QUANT	:= (cAlias22)->DIFERENCA
			PA1->PA1_DOC	:= (cAlias22)->C6_NUM+(cAlias22)->C6_ITEM
			PA1->PA1_TIPO	:= "1"
			PA1->PA1_OBS	:= "GERADO POR ROTINA AUTOMATICA EM 11/12/2013"
			PA1->(MsUnlock())
			
		Endif

		aAreaPA1 := PA1->(GetArea())
		aArea22  := (cAlias22)->(GetArea())

		U_STGrvSt((cAlias22)->C6_NUM+(cAlias22)->C6_ITEM,NIL)
		AADD(aProds,(cAlias22)->C6_PRODUTO)

		RestArea(aAreaPA1)
		RestArea(aArea22)
		
		DbSelectArea(cAlias22)					
		(cAlias22)->(DbSkip())
		
	EndDo
	
	(cAlias22)->(DbCloseArea())
	
	MsgInfo("Registros Atualizados com sucesso!","OK")
	
Else
	
	MsgAlert("Atenção, logar na filial 02!")
	
EndIf

Return
