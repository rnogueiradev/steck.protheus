#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STSEQSC7	�Autor  �Renato Nogueira     � Data �  01/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para gerar pr�ximo n�mero do pedido de 	  ���
���          �compras			 				  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Branco 										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STSEQSC7()             
                        
Local _cQuery 	:= ""
Local _cAlias 	:= "QRYTEMP"
Local _cProxNum	:= ""

_cQuery := " SELECT MAX(C7_NUM) NUMPED "
_cQuery += " FROM "+RetSqlName("SC7")+" C7 " 
_cQuery += " WHERE D_E_L_E_T_=' ' "
_cQuery += " ORDER BY C7_NUM "

If !Empty(Select(_cAlias))
	DbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

dbSelectArea(_cAlias)
(_cAlias)->(dbGoTop())
        
CA120NUM := Soma1((_cAlias)->NUMPED)

RETURN("")