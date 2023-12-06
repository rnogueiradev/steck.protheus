#Include "PROTHEUS.Ch"
#include "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STKCCAIXA� Autor � Vitor Merguizo        � Data � 24/04/10 ���
�������������������������������������������������������������������������Ĵ��
���Desc.     � Funcao utilizada no Lancamentos Padr�es 572 para carregar  ���
���          � a conta cont�bil da natureza utilizada no adiantamento     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � STECK			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STKCCAIXA()
	
	Local _cConta	:= "" // Conta Cont�bil
	Local cQuery	:= ""
	Local cAlias	:= 'xxxtemp'
	Local aArea		:= {SEU->(GetArea("SEU")), GetArea()}
	Local nA := 0
	IF !EMPTY(SEU->EU_NROADIA)
		If Select( cAlias ) > 0
			DbSelectArea( cAlias )
			(cAlias)->(DbCloseArea())
		Endif
		
		cQuery += " SELECT ED_CONTA AS CONTA"
		cQuery += " FROM "+RETSQLNAME("SEU")
		cQuery += " LEFT JOIN "+RETSQLNAME("SED")+" ON ED_FILIAL = ' ' AND ED_CODIGO = EU_X_NATUR"
		cQuery += " WHERE EU_FILIAL = '"+SEU->EU_FILIAL+"' AND EU_NUM = '"+SEU->EU_NROADIA+"' AND EU_CAIXA = '"+SEU->EU_CAIXA+"' AND "+RETSQLNAME("SEU")+".D_E_L_E_T_ = ' '"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		While !(cAlias)->(Eof())
			_cConta := (cAlias)->CONTA
			(cAlias)->(dbSkip())
		EndDo
		
		(cAlias)->(DbCloseArea())
		
	Else
		_cConta := "110101001"
	Endif
	
	For nA := 1 to Len(aArea)
		RestArea(aArea[nA])
	Next
	
Return(_cConta)
