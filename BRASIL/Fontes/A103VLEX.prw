#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103VLEX	�Autor  �Renato Nogueira     � Data �  09/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para devolver os saldos dos pedidos de 	  ���
���          �compra ap�s a exclus�o da NF			   				      ���
�������������������������������������������������������������������������͹��
���Parametro � 		                                                      ���
�������������������������������������������������������������������������ͼ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A103VLEX()

Local _aArea 		:= GetArea()
Local _aAreaSD1		:= SD1->(GetArea())
Local _aAreaSF1		:= SF1->(GetArea())
Local _aAreaSC7		:= SC7->(GetArea())
Local _lRet			:= .T.
Local _cQuery 		:= ""
Local _cAlias 		:= "QRYTEMP"

/*Inibido por Emerson Holanda 04/09/23 - A Baixa do saldo sera efetuada pelas rotina padr�es.
DbSelectArea("ZZS")
ZZS->(DbSetOrder(1))
ZZS->(DbGoTop())

If ZZS->(DbSeek(xFilial("ZZS")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
//If AllTrim(SF1->F1_FORNECE)=="005866" .And. AllTrim(SF1->F1_TIPO)=="N" .And. cEmpAnt == "01" //Notas vindas da Steck Manaus
	
	_cQuery	:= " SELECT * "
	_cQuery	+= " FROM "+RetSqlName("ZZS")+" ZS "
	_cQuery	+= " WHERE ZS.D_E_L_E_T_=' ' AND ZZS_FILIAL='"+SF1->F1_FILIAL+"' AND ZZS_NF='"+SF1->F1_DOC+"' AND ZZS_SERIE='"+SF1->F1_SERIE+"' "
	_cQuery += " AND ZZS_FORNEC='"+SF1->F1_FORNECE+"' AND ZZS_LOJA='"+SF1->F1_LOJA+"' "
	
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
	
	While (_cAlias)->(!Eof())
		
		DbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		SC7->(DbGoTop())
		
		If DbSeek((_cAlias)->(ZZS_FILIAL+ZZS_PEDCOM+ZZS_ITEMPC))
			
			SC7->(RecLock("SC7",.F.))
			SC7->C7_QUJE	:= SC7->C7_QUJE-(_cAlias)->ZZS_QTDSUB
			SC7->(MsUnLock())
			
		EndIf
		
		DbSelectArea("ZZS")
		ZZS->(DbGoTop())
		ZZS->(DbGoTo((_cAlias)->R_E_C_N_O_))
		
		If ZZS->(!Eof())
			
			ZZS->(RecLock("ZZS",.F.))
			ZZS->(DbDelete())
			ZZS->(MsUnLock())
			
		EndIf
		
		(_cAlias)->(DbSkip())
		
	EndDo
	
EndIf
*/
RestArea(_aAreaSC7)
RestArea(_aAreaSF1)
RestArea(_aAreaSD1)
RestArea(_aArea)

Return(_lRet)
