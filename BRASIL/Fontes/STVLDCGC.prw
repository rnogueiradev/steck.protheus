#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDCGC	�Autor  �Renato Nogueira     � Data �  28/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa utilizado para bloquear a coloca��o do mesmo cnpj  ���
���          �para clientes diferentes   		  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � A1_CGC                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�GICO										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDCGC(_cCnpj)

Local _aArea     := GetArea()
Local _cQuery 	:= ""
Local _cAlias 	:= "QRYTEMP"
Local _lRet		:= .T.
	Return(_lRet) // GIOVANI ZAGO	16/10/2017 ERRO NA ALTERA��O DO CADASTRO DE CLIENTE
	_cQuery	 := " SELECT COUNT(*) CONTADOR "
	_cQuery  += " FROM " +RetSqlName("SA1")+ " A1 "
	_cQuery  += " WHERE A1.D_E_L_E_T_=' ' AND A1_CGC='"+_cCnpj+"' "
	
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
	
	If (_cAlias)->(CONTADOR)>0
		_lRet := .F.
		MsgInfo("Aten��o, esse cnpj j� foi cadastrado, verifique!","Erro")
	EndIf

RestArea(_aArea)

Return(_lRet) 