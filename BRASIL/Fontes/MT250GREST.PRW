#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |MT250GREST  �Autor  �Jo�o Victor       � Data �  21/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que Grava e/ou exclui em tabelas e/ou     ���
���          � campos especificos do usu�rio ap�s realizar o estorno      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT250GREST ()
	Local _cArea    := getarea()
	Local _cOp      := SD3->D3_OP
	Local _cCodigo  := SD3->D3_COD
	Local _nQuant   := SD3->D3_QUANT
	Local _cNumSeq  := SD3->D3_NUMSEQ
	Local _cTpMov   := SD3->D3_TM
	Local _cQuery   := ''
	Local _cAlias   := GetNextAlias()
	
	If _cTpMov = '100'
	
		_cQuery  := " SELECT MAX(R_E_C_N_O_) REGISTRO "
		_cQuery  += " FROM " +RetSqlName("PP1")+ " PP1 "
		_cQuery  += " WHERE PP1.D_E_L_E_T_ = ' '
		_cQuery  += " AND PP1_FILIAL       = '"+xFilial("SD4")+"'"
		_cQuery  += " AND PP1_CODIGO       = '"+_cOp+"'"
		_cQuery  += " AND PP1_COD          = '"+_cCodigo+"'"
		_cQuery  += " AND PP1_QUANT        =  "+Cvaltochar(_nQuant)
		_cQuery  += " AND PP1_NUMSEQ       = '"+_cNumSeq+"'"

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())
	
		DbSelectArea("PP1")
		PP1->(DbGoTo((_cAlias)->REGISTRO))
		If PP1->(!Eof())
			PP1->(RecLock("PP1",.F.))
			PP1->PP1_STATUS := "E"
			PP1->(DbDelete())
			PP1->(MsUnLock())
		Endif
	
	Endif
	
	
	RestArea(_cArea)

Return Nil