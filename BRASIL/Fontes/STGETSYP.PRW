#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  STGETSYP     �Autor  �Renato Nogueira � Data �  29/06/15     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Pegar conteudo de campo memo na tabela de SP              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STGETSYP()

Local _cMsg	:= ""

Local cQuery1 	:= ""
Local cAlias1 	:= "QRYTEMP"

	cQuery1  := " SELECT YP_TEXTO "
	cQuery1  += " FROM SYP010 YP "
	cQuery1  += " WHERE YP.D_E_L_E_T_=' ' AND YP_CHAVE='"+QI2->QI2_DDETA+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	
	_cMsg	:= (cAlias1)->YP_TEXTO

Return(_cMsg)

//IF(INCLUI,"",U_STGETSYP())