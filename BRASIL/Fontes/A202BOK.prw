#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A202BOK   �Autor  �Renato Nogueira     � Data �  16/09/13.  ���
�������������������������������������������������������������������������͹��
���Desc.     �Tudo Ok pr�-estrutura								          ���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A202BOK()

	Local _aArea     := GetArea()
	Local _aAreaSGG  := SGG->(GetArea())
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"
	Local _aOpc		:= {}
	Local _cProduto	:= PARAMIXB[2]
	Local _lRet		:= .T.

	//_aOpc	:= ACLONE(PARAMIXB[1])

	If INCLUI

		_cQuery	 := " SELECT COUNT(*) CONTADOR "
		_cQuery  += " FROM " +RetSqlName("SGG")+ " GG "
		_cQuery  += " WHERE GG.D_E_L_E_T_=' ' AND GG_COD='"+_cProduto+"' AND GG_FILIAL<>'"+cFilAnt+"' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		If (_cAlias)->(CONTADOR)>0
			_lRet := .F.
			MsgInfo("Aten��o, esse produto j� possui pr�-estrutura cadastrada em outra filial","Erro")
		EndIf

	EndIf

	RestArea(_aAreaSGG)
	RestArea(_aArea)

Return(_lRet) 