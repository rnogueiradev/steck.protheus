#Include "TOTVS.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCHKDA1	�Autor  �Renato Nogueira     � Data �  19/05/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verificar de produto j� existe na tabela de pre�o		    ���
���          �									    				           ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCHKDA1(_cCodTab,_cProduto)

	Local _lRet	:= .T.
	Local _cQuery	:= ""
	Local _cAlias	:= "QRYTEMP"
	Local oModel := FwModelActive() // - Adicionado esta linha pois na 12 tem que ser em MVC - Robson Mazzarotto
    Local _cCodTab := oModel:GetValue("DA0MASTER","DA0_CODTAB") // - Adicionado esta linha pois na 12 tem que ser em MVC - Robson Mazzarotto


	_cQuery  := " SELECT COUNT(DA1_CODPRO) CONTADOR "
	_cQuery  += " FROM " +RetSqlName("DA1")+ " DA1 "
	_cQuery  += " WHERE DA1.D_E_L_E_T_=' ' AND DA1_CODTAB='"+_cCodTab+"' "
	_cQuery  += " AND DA1_CODPRO='"+_cProduto+"' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->CONTADOR>0
		_lRet	:= .F.
		MsgAlert("Atencao, produto ja cadastrado para essa tabela de preco")
	EndIf

Return(_lRet)