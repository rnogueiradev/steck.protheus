#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �STVLDNVL  �Autor  � Renato Nogueira       � Data �04.11.2013 ���
��������������������������������������������������������������������������Ĵ��
���          �Validar o n�vel do grupo para o tipo de chamado		       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       �Generico                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function STVLDNVL()

Local aArea     := GetArea()
Local _lRet		:= .T.
Local cQuery1 	:= ""
Local cAlias1 	:= "QRYTEMP"

PswOrder(1)
If PswSeek(__cUserId,.T.)
	_aGrupos	:= PswRet()
EndIf

cQuery1	:= " SELECT * "
cQuery1  += " FROM " +RetSqlName("ZZE")+ " ZZE "
cQuery1  += " WHERE ZZE.D_E_L_E_T_=' ' AND ZZE_GRPSOL LIKE '%"+_aGrupos[1][10][1]+"%' "

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())

If !Empty((cAlias1)->ZZE_CODIGO)
	
	If (cAlias1)->ZZE_NIVEL==1 .And. M->Z0_CLASERP<>"1"
		_lRet	:= .F.
		MsgAlert("Aten��o, este usu�rio s� pode cadastrar chamados do tipo 1 (Erro)")
	EndIf
	
EndIf

RestArea(aArea)

Return(_lRet)