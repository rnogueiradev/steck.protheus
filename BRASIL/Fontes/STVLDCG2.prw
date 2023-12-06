#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDCG2	�Autor  �Renato Nogueira     � Data �  14/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa utilizado para bloquear a coloca��o do mesmo cnpj  ���
���          �para fornecedores diferentes   		  	 				  ���
�������������������������������������������������������������������������͹��
���Parametro � A2_CGC                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�GICO										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDCG2(_cCnpj)

	Local _aArea     := GetArea()
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"
	Local _lRet		:= .T.
	
	Return(.T.)
	
	//Claudia Ferreira solicitou que fosse retirada a valida��o pois a entrada do xml � CNPJ+IE - 21/10/2015
	/*
	
	_cQuery  := " SELECT COUNT(*) CONTADOR "
	_cQuery  += " FROM " +RetSqlName("SA2")+ " A2 "
	_cQuery  += " WHERE A2.D_E_L_E_T_=' ' AND A2_CGC='"+_cCnpj+"' "
		
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
	
	*/
		
	RestArea(_aArea)
	
	Return(_lRet)