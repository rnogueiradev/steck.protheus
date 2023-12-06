#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | STVLDSA2        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descrição | STVLDSA2                                                                 |
|          | Valida bloqueio de compras                                               |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVLDSA2                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STVLDSA2(_cCod,_cLoja)

	Local _aArea    := GetArea()
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"
	Local _lRet		:= .T.
	
	If Empty(_cCod) .AND. Empty(_cLoja)
		MsgAlert("Código do fornecedor ou loja não preenchidos!")
		_lRet	:= .F.
	EndIf
	
	_cQuery  := " SELECT COUNT(*) CONTADOR "
	_cQuery  += " FROM " +RetSqlName("SA2")+ " A2 "
	_cQuery  += " WHERE A2.D_E_L_E_T_=' ' AND A2_COD='"+_cCod+"' AND A2_LOJA='"+_cLoja+"' AND A2_XBLQCOM='S' "
		
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
		
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
		
	If (_cAlias)->(CONTADOR)>0
		_lRet := .F.
		MsgInfo("Atenção, esse fornecedor: "+_cCod+" loja: "+_cLoja+" está bloqueado por compras!","Erro")
	EndIf
	
	RestArea(_aArea)
	
Return(_lRet)