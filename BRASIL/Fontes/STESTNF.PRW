#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � STESTNF   �Autor  � Giovani Zago		  �   Data �23.01.2014 ���
��������������������������������������������������������������������������Ĵ��
���          �Mostrar n�mero da nota na tela de endere�amento de produto   ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function STESTNF()

Local aArea     := GetArea()
Local aAreaSDA  := SDA->(GetArea())
Local aAreaSDB  := SDB->(GetArea())
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local cNf			:= ""


If SDA->DA_ORIGEM = 'SD1'
	
	cNf			:= SDA->DA_DOC
	
Else
	
	cQuery := " SELECT QEK_NTFISC "
	cQuery += " FROM " +RetSqlName("QEK") "
	cQuery += " WHERE D_E_L_E_T_=' ' AND QEK_FILIAL='"+xFilial("QEK")+"' AND QEK_CERFOR='"+SDA->DA_DOC+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	
	(cAlias)->(dbGoTop())
	
	cNf	:= (cAlias)->QEK_NTFISC
	
	(cAlias)->(dbCloseArea())
	
EndIf

RestArea(aAreaSDA)
RestArea(aAreaSDB)
RestArea(aArea)

Return(cNf)
