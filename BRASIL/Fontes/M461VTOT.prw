#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} M461VTOT
@name M461VTOT
@type User Function
@desc ponto de entrada para bloquear faturamento
@author Renato Nogueira
@since 17/05/2018
/*/

User Function M461VTOT()

	Local _lRet 	:= .F.
	Local _cFilial	:= SC9->C9_FILIAL
	Local _cPedido	:= SC9->C9_PEDIDO
	Local _cOrdSep	:= SC9->C9_ORDSEP
	Local _aArea	:= GetArea()

	_lRet := VERIFCB9(_cFilial,_cOrdSep)
	
	RestArea(_aArea)

Return(_lRet)

/*/{Protheus.doc} VERIFCB9
@name VERIFCB9
@type Static Function
@desc verificar embalagem
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function VERIFCB9(_cFilial,_cOrdsep)
	
	Local _lRet		:= .T.
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	
	cQuery1	 := " SELECT FILIAL, ORDSEP, TOTALOS "
	cQuery1  += " ,(SELECT SUM(CB9_QTEEMB) FROM "+RetSqlName("CB9")+" B9 WHERE B9.D_E_L_E_T_=' '
	cQuery1	 += " AND CB9_FILIAL=FILIAL AND CB9_ORDSEP=ORDSEP) TOTALEMB "
	cQuery1  += " FROM ( "
	cQuery1	 += " SELECT CB8_FILIAL FILIAL, CB8_ORDSEP ORDSEP, SUM(CB8_QTDORI) TOTALOS "
	cQuery1  += " FROM "+RetSqlName("CB8")+" B8 "
	cQuery1	 += " WHERE B8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+_cFilial+"' AND CB8_ORDSEP='"+_cOrdsep+"' "
	cQuery1  += " GROUP BY CB8_FILIAL, CB8_ORDSEP ) "
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	
	If (cAlias1)->TOTALOS<>(cAlias1)->TOTALEMB
		_lRet	:= .F.
		MsgInfo("Atenção, total da OS diferente do total embalado, entre em contato com a expedição!")
	EndIf
	
	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery1  += " WHERE CB6.D_E_L_E_T_=' ' AND CB6_FILIAL='"+_cFilial+"' AND CB6_XORDSE='"+_cOrdsep+"' "
	cQuery1  += " AND CB6_XPESO=0 "
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	
	If (cAlias1)->CONTADOR>0
		_lRet	:= .F.
		MsgInfo("Atenção, peso zerado na embalagem, entre em contato com a expedição!")
	EndIf
	
Return(_lRet)