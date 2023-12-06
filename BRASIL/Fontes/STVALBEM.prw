#include 'PROTHEUS.CH'        
#include 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �STVALBEM     �Autor  �Renato Nogueira  � Data �  17/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina criada para validar se o ativo j� existe independente���
���          �da filial                           					      ���
���          �    									  				      ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function STVALBEM()     

Local _lRet		:= .T.
Local cQuery	:= "" 

cQuery := " SELECT COUNT(*) QUANTIDADE "
cQuery += " FROM "+RetSqlName("ST9")+" ST9 "
cQuery += " WHERE D_E_L_E_T_=' ' AND T9_CODBEM='"+M->T9_CODBEM+"' "

If !Empty(Select("TMP"))
	DbSelectArea("TMP")
	("TMP")->(dbCloseArea())
Endif

//cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "TMP"

If TMP->QUANTIDADE >= 1
	_lRet	:= .F.    
	MsgAlert("Ativo j� cadastrado!")
EndIf

Return(_lRet)